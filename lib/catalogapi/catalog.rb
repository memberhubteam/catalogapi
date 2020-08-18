# frozen_string_literal: true

module CatalogAPI
  class Catalog
    class << self
      # @return [Array[CatalogAPI::Catalog]] Returns a list of the catalog sockets you have available on your account.
      def list_available
        request = CatalogAPI.request.new(:list_available_catalogs).get
        sockets = request.json.dig(
          :list_available_catalogs_response, :list_available_catalogs_result,
          :domain, :sockets, :Socket
        ).to_a
        request.data = sockets.map { |socket| new(socket) }
        request
      end
    end

    attr_reader :currency, :export_uri, :language, :point_to_currency_ratio,
                :region, :socket_id, :socket_name
    def initialize(opts)
      @currency = opts[:currency]
      @export_uri = opts[:export_uri]
      @language = opts[:language]
      @point_to_currency_ratio = opts[:point_to_currency_ratio]
      @region = opts[:region]
      @socket_id = opts[:socket_id]
      @socket_name = opts[:socket_name]
    end

    # @return [Array[CatalogAPI::Category]] Returns a list of item categories available in a catalog
    def breakdown(is_flat: 0)
      raise CatalogAPI::Error, 'No Socket ID' if socket_id.nil?

      request = CatalogAPI.request.new(:catalog_breakdown).get(socket_id: socket_id, is_flat: is_flat)
      catgories = request.json.dig(
        :catalog_breakdown_response, :catalog_breakdown_result, :categories,
        :Category
      ).to_a
      request.data = catgories.map { |cateogry| CatalogAPI::Category.new(cateogry) }
      request
    end

    # @option options [String] :name Searches the names of items.
    # @option options [String] :search Search the name, description and model of items.
    # @option options [String] :category_id Returns only items within this category_id. (This includes any child categories of the category_id.) The category_id comes from the catalog_breakdown method.
    # @option options [String] :min_points Return only items that have a point value of at least this value.
    # @option options [String] :max_points Return only items that have a point value of no more than this value.
    # @option options [String] :min_price Return only items that have a price of at least this value.
    # @option options [String] :max_price Return only items that have a price of no more than this value.
    # @option options [String] :max_rank Do not return items with a rank higher than this value.
    # @option options [String] :tag We have the ability to "tag" certain items based on custom criteria that is unique to our clients. If we setup these tags on your catalog, you can pass a tag name with your search.
    # @option options [String] :page The page number. Defaults to 1.
    # @option options [String] :paginated Whether to paginate the call or return the first page result default: nil
    # @option options [String] :per_page The number of items to return, per page. Can be from 1 to 50. Defaults to 10.
    # @option options [String] :sort The following sort values are supported: 'points desc', 'points asc', 'rank asc', 'score desc', 'random asc'
    # @option options [String] :catalog_item_ids Return only items in the given list.
    # @return [Array[CatalogAPI::Item]] Searches a catalog by keyword, category, or price range.
    def search(options = {}, request = nil)
      raise CatalogAPI::Error, 'No Socket ID' if socket_id.nil?

      request ||= CatalogAPI.request.new(:search_catalog)
      request = request.get(options.to_h.merge(socket_id: socket_id))
      items = request.json.dig(
        :search_catalog_response, :search_catalog_result, :items, :CatalogItem
      ).to_a
      request.data += items.map { |item| CatalogAPI::Item.new(item.merge(socket_id: socket_id)) }
      # Pagination
      next_page = options[:paginated] ? request.next_page : nil
      request = search(options.merge(page: next_page), request) if next_page
      request
    end
  end
end
