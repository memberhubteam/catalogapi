# frozen_string_literal: true

module CatalogAPI
  class Metadata
    attr_reader :key, :uri, :value
    def initialize(opts)
      @key = opts[:key]
      @url = opts[:url]
      @value = opts[:value]
    end
  end
end
