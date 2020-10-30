# frozen_string_literal: true

require 'catalogapi/request'
require 'catalogapi/catalog'
require 'catalogapi/category'
require 'catalogapi/order_item'
require 'catalogapi/fulfillment'
require 'catalogapi/item'
require 'catalogapi/metadata'
require 'catalogapi/order'
require 'catalogapi/version'

module CatalogAPI
  class Error < StandardError; end

  class << self
    attr_accessor :environment, :key, :token, :username

    def development?
      !production?
    end

    def production?
      environment == 'production'
    end

    def request
      CatalogAPI::Request
    end
  end

  # @return [Services::OnlineRewards::Request] request to the list_available_catalogs endpoint
  def list_available_catalogs
    request.new(:list_available_catalogs).get
  end

  # @param socket_id [String] the Socket ID from the list_available_catalogs
  # @return [Services::OnlineRewards::Request]
  def catalog_breakdown(socket_id)
    request.new(:catalog_breakdown).get(socket_id: socket_id)
  end

  # @param socket_id [String] the Socket ID from the list_available_catalogs
  # @param search [String] keywork to search for
  # @return [Services::OnlineRewards::Request]
  def search_catalog(socket_id, search)
    request.new(:search_catalog).get(socket_id: socket_id, search: search)
  end
end
