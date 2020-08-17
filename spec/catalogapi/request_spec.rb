# frozen_string_literal: true

RSpec.describe CatalogAPI::Request do
  it 'has checksum value' do
    expect(CatalogAPI::Request.new(:test_me).checksum).to_not be nil
  end

  it 'has required parameters' do
    expect(CatalogAPI::Request.new(:test_me).required_params.keys).to be
    %i[creds_datetime creds_uuid creds_checksum]
  end

  describe '#get' do
    let(:request) { CatalogAPI::Request.new(:test_me) }

    it 'makes http GET request and renders JSON response' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/test_me}
      stub_request(:get, url)
        .to_return(status: 200, body: { test: 'OK' }.to_json, headers: {})
      request.get

      expect(a_request(:get, url))
        .to have_been_made.once

      expect(request.json).to eq(test: 'OK')
    end
  end
end
