# frozen_string_literal: true

require 'base64'
require 'openssl'
require 'securerandom'
require 'time'

module CatalogAPI
  class Request
    attr_accessor :method_name, :path, :response, :json, :data
    def initialize(method_name, path: nil)
      @data = []
      @method_name = method_name
      @path = path || method_name
    end

    def base_url
      env = CatalogAPI.production? ? 'prod' : 'dev'
      username = CatalogAPI.username
      "https://#{username}.#{env}.catalogapi.com/v1/rest/"
    end

    def get(params = {})
      url = "#{base_url}#{path}"
      self.response = HTTP.get(url, { params: params.merge(required_params) })
      json_response
    end

    def json_response
      check_status!
      self.json = JSON.parse(response.body.to_s, symbolize_names: true)
      self
    end

    # CatalogAPI Error
    class Error < StandardError
      attr_accessor :code, :body
      def initialize(response)
        @body = response.body
        @code = response.code
      end

      def message
        "#{code} #{body}"
      end
    end

    def first
      data.first
    end

    def each(&block)
      data.each(&block)
    end

    def map(&block)
      data.map(&block)
    end

    private

    def required_params
      {
        creds_datetime: time,
        creds_uuid: uuid,
        creds_checksum: checksum
      }
    end

    # http://memberhub.catalogapi.com/docs/checksums/
    def checksum
      Base64.encode64(OpenSSL::HMAC.digest('sha1', CatalogAPI.key, concatted))
            .gsub("\n", '')
    end

    def check_status!
      case response.code.to_i
      when 200 then response
      else raise Error, response
      end
    end

    def concatted
      @concatted ||= "#{method_name}#{uuid}#{time}"
    end

    def time
      @time ||= Time.now.utc.iso8601
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end
  end
end
