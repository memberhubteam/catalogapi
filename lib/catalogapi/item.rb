# frozen_string_literal: true

module CatalogAPI
  class Item
    attr_accessor :description

    attr_reader :brand, :catalog_item_id, :catalog_price, :categories,
                :currency, :has_options, :image_150, :image_300,
                :image_75, :model, :name, :options, :original_points,
                :original_price, :points, :rank, :retail_price,
                :shipping_estimate, :socket_id, :tags,
                :quantity, :option_id
    def initialize(opts)
      @brand = opts[:brand]
      @catalog_item_id = opts[:catalog_item_id]
      @catalog_price = opts[:catalog_price]
      @categories = opts[:categories].to_h[:integer]
      @currency = opts[:currency] || 'USD'
      @description = opts[:description]
      @has_options = opts[:has_options]
      @image_150 = opts[:image_150]
      @image_300 = opts[:image_300]
      @image_75 = opts[:image_75]
      @model = opts[:model]
      @name = opts[:name]
      @options = opts[:options]
      @original_points = opts[:original_points]
      @original_price = opts[:original_price]
      @points = opts[:points]
      @rank = opts[:rank]
      @retail_price = opts[:retail_price]
      @shipping_estimate = opts[:shipping_estimate]
      @socket_id = opts[:socket_id]
      @tags = opts[:tags].to_h[:string]
      @quantity = opts[:quantity] || 1
      @option_id = opts[:option_id]
    end

    def order_params
      {
        catalog_item_id: catalog_item_id,
        quantity: quantity,
        currency: currency,
        catalog_price: catalog_price,
        option_id: option_id
      }
    end

    def orderable?
      !catalog_item_id.nil? && !catalog_price.nil?
    end

    def view
      raise CatalogAPI::Error, 'No Socket ID' if socket_id.nil?
      raise CatalogAPI::Error, 'No Catalog Item ID' if catalog_item_id.nil?

      request = CatalogAPI.request.new(:view_item)
                          .get(socket_id: socket_id, catalog_item_id: catalog_item_id)
      fields = request.json.dig(:view_item_response, :view_item_result, :item)
      request.data = self.class.new(fields)
      request
    end
  end
end
