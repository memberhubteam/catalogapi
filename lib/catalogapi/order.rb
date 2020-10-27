# frozen_string_literal: true

module CatalogAPI
  class Order
    attr_reader :date_placed, :external_user_id, :order_number,
                :external_order_number, :first_name, :last_name,
                :address_1, :address_2, :address_3, :city, :state_province,
                :postal_code, :country, :phone_number, :email, :items,
                :fulfillments

    def initialize(opts)
      @date_placed = nil
      if opts[:date_placed] && !opts[:date_placed].empty?
        @date_placed = Time.parse(opts[:date_placed]).to_time
      end
      @external_user_id = opts[:external_user_id]
      @order_number = opts[:order_number]

      @external_user_id = opts[:external_user_id]
      @external_order_number = opts[:external_order_number]
      @first_name = opts[:first_name]
      @last_name = opts[:last_name]
      @address_1 = opts[:address_1]
      @address_2 = opts[:address_2]
      @address_3 = opts[:address_3]
      @city = opts[:city]
      @state_province = opts[:state_province]
      @postal_code = opts[:postal_code]
      @country = opts[:country]
      @email = opts[:email]
      @phone_number = opts[:phone_number]
      @fulfillments = opts[:fulfillments].to_a
      @items = opts[:items].to_a
    end

    class << self
      # @option options [String] :external_user_id external user id used placing the order
      # @option options [String] :page page number of results to return when there are more than per_page results.
      # @option options [String] :per_page number of orders to return. Defaults to 10. Can be increased to a maximum of 50.
      # @option options [String] :paginated return all orders by paginating over all pages
      # @return [Array[CatalogAPI::Order]] return all orders placed by that user.
      def list(options = {}, request = nil)
        external_user_id = options[:external_user_id]
        raise CatalogAPI::Error, 'No External User ID' if external_user_id.nil?

        request ||= CatalogAPI.request.new(:order_list)
        request = request.get(options.merge(external_user_id: external_user_id))
        orders = request.json.dig(
          :order_list_response, :order_list_result, :orders, :OrderSummary
        ).to_a
        request.data += orders.map { |item| CatalogAPI::Order.new(item.merge(external_user_id: external_user_id)) }
        # Pagination
        next_page = options[:paginated] ? request.next_page : nil
        request = list(options.merge(page: next_page), request) if next_page
        request
      end
    end

    # Place an order without requiring a cart.
    # @return [CatalogAPI::Order]
    def place
      raise CatalogAPI::Error, 'No Items' if items.nil? || items.length.zero?
      raise CatalogAPI::Error, 'No Socket ID' if items.first.socket_id.nil?
      raise CatalogAPI::Error, 'No First Name' if first_name.nil?
      raise CatalogAPI::Error, 'No Last Name' if last_name.nil?
      raise CatalogAPI::Error, 'No Adress1' if address_1.nil?
      raise CatalogAPI::Error, 'No City' if city.nil?
      raise CatalogAPI::Error, 'No State' if state_province.nil?
      raise CatalogAPI::Error, 'No Postal Code' if postal_code.nil?
      raise CatalogAPI::Error, 'No Country' if country.nil?
      raise CatalogAPI::Error, 'No Items' if items.nil?

      request = CatalogAPI.request.new(:order_place)
      request.post(place_params(request))
      json = request.json.dig(:order_place_response, :order_place_result)
      request.data = CatalogAPI::Order.new(json)
      request
    end

    # @return [CatalogAPI::Order] Return the details of a previously placed order, including any shipment information.
    def track
      raise CatalogAPI::Error, 'No Order Number' if order_number.nil?

      request = CatalogAPI.request.new(:order_track).get(order_number: order_number)
      json = request.json.dig(:order_track_response, :order_track_result, :order)
      items = json.dig(:items, :OrderItem).to_a.map { |i| CatalogAPI::OrderItem.new(i) }
      fulfillments = json.dig(:fulfillments, :Fulfillment).to_a.map { |i| CatalogAPI::Fulfillment.new(i) }
      request.data = CatalogAPI::Order.new(json.merge(items: items, fulfillments: fulfillments))
      request
    end

    private

    def place_params(request)
      {
        order_place: {
          order_place_request: {
            credentials: request.required_params(''),
            socket_id: items.first.socket_id,
            external_user_id: external_user_id,
            external_order_number: external_order_number,
            first_name: first_name,
            last_name: last_name,
            address_1: address_1,
            address_2: address_2,
            address_3: address_3,
            city: city,
            state_province: state_province,
            postal_code: postal_code,
            country: country,
            phone_number: phone_number,
            email: email,
            items: items.map(&:order_params)
          }.reject { |_k, v| v.nil? }.to_h
        }
      }
    end
  end
end
