# frozen_string_literal: true

module CatalogAPI
  class Category
    attr_reader :category_id, :children, :depth, :item_count, :name,
                :parent_category_id
    def initialize(opts)
      @category_id = opts[:category_id]
      @children = opts.dig(:children, :Category).to_a.map do |child|
        CatalogAPI::Category.new(child)
      end
      @depth = opts[:depth]
      @item_count = opts[:item_count]
      @name = opts[:name]
      @parent_category_id = opts[:parent_category_id]
    end
  end
end
