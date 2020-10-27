# frozen_string_literal: true

RSpec.describe CatalogAPI::Item do
  describe '#view' do
    let(:item) { CatalogAPI::Item.new(catalog_item_id: '123', socket_id: '456') }

    it 'makes http GET request and update the description' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/view_item\?catalog_item_id=123.{0,1000}&socket_id=456}
      body = fixture('view_item.json')
      stub_request(:get, url)
        .to_return(status: 200, body: body.to_json, headers: {})
      request = item.view
      expect(request.data.description).to_not eq nil
      expect(request.data.socket_id).to_not eq nil
    end

    it 'requires catalog_item_id' do
      item = CatalogAPI::Item.new(catalog_item_id: nil, socket_id: '456')

      expect { item.view }.to raise_error(CatalogAPI::Error)
    end

    it 'requires socket_id' do
      item = CatalogAPI::Item.new(catalog_item_id: '123', socket_id: nil)

      expect { item.view }.to raise_error(CatalogAPI::Error)
    end
  end
end
