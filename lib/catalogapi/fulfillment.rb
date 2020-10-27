# frozen_string_literal: true

module CatalogAPI
  class Fulfillment
    attr_reader :fulfillment_date, :items, :metadata
    def initialize(opts)
      @fulfillment_date = opts[:fulfillment_date]
      @items = opts.dig(:items, :FulfillmentItem).to_a.map { |i| CatalogAPI::OrderItem.new(i) }
      @metadata = opts.dig(:metadata, :Meta).to_a.map { |i| CatalogAPI::Metadata.new(i) }
    end
  end
end
