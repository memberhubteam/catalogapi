# frozen_string_literal: true

module CatalogAPI
  class OrderItem
    attr_reader :catalog_item_id, :catalog_price, :currency, :metadata, :name,
                :option, :order_item_id, :order_item_status,
                :order_item_status_id, :points
    def initialize(opts)
      @catalog_item_id = opts[:catalog_item_id]
      @catalog_price = opts[:catalog_price]
      @currency = opts[:currency]
      @metadata = opts.dig(:metadata, :Meta).to_a.map { |i| CatalogAPI::Metadata.new(i) }
      @name = opts[:name]
      @option = opts[:option]
      @order_item_id = opts[:order_item_id]
      @order_item_status = opts[:order_item_status]
      @order_item_status_id = opts[:order_item_status_id]
      @points = opts[:points]
    end
  end
end
