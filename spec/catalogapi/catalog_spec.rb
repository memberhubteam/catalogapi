# frozen_string_literal: true

RSpec.describe CatalogAPI::Catalog do
  describe '#list_available' do
    it 'makes http GET request and renders Catalogs' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/list_available_catalogs}
      body = fixture('list_available_catalogs.json')
      stub_request(:get, url)
        .to_return(status: 200, body: body.to_json, headers: {})
      request = CatalogAPI::Catalog.list_available
      catalogs = request.data
      expect(catalogs.count).to eq 1
    end
  end

  describe '#breakdown' do
    let(:catalog) { CatalogAPI::Catalog.new(socket_id: '123') }

    it 'makes http GET request and renders Catalog Breakdown' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/catalog_breakdown?.{0,1000}&socket_id=123}
      body = fixture('catalog_breakdown.json')
      stub_request(:get, url)
        .to_return(status: 200, body: body.to_json, headers: {})
      request = catalog.breakdown
      categories = request.data
      expect(categories.count).to eq 1
      expect(categories.first.class).to eq CatalogAPI::Category
    end

    it 'requires socket_id' do
      catalog = CatalogAPI::Catalog.new(socket_id: nil)

      expect { catalog.breakdown }.to raise_error(CatalogAPI::Error)
    end
  end

  describe '#search' do
    let(:catalog) { CatalogAPI::Catalog.new(socket_id: '123') }

    it 'makes http GET request and renders Catalog Breakdown' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/search_catalog}
      body = fixture('search_catalog.json')
      stub_request(:get, url)
        .to_return(status: 200, body: body.to_json, headers: {})
      request = catalog.search
      items = request.data
      expect(items.count).to eq 2
      expect(items.first.class).to eq CatalogAPI::Item
    end

    context 'when paginated' do
      it 'makes http GET request paginated' do
        body = fixture('search_catalog.paginated.json')
        url = %r{https://username.dev.catalogapi.com/v1/rest/search_catalog.{0,1000}socket_id=123}
        stub_request(:get, url).to_return(status: 200, body: body.to_json, headers: {})
        body = fixture('search_catalog.json')
        stub_request(:get, %r{https://username.dev.catalogapi.com/v1/rest/search_catalog?.{0,1000}page=2&.{0,100}}).to_return(status: 200, body: body.to_json, headers: {})
        request = catalog.search(paginated: true)
        items = request.data
        expect(items.count).to eq 4
      end
    end

    it 'makes http GET request and renders Catalog Breakdown with search' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/search_catalog?.{0,1000}search=Search%20It&socket_id=123}
      body = fixture('search_catalog.json')
      stub_request(:get, url)
        .to_return(status: 200, body: body.to_json, headers: {})
      request = catalog.search(search: 'Search It')
      items = request.data
      expect(items.count).to eq 2
      expect(items.first.class).to eq CatalogAPI::Item
    end

    it 'requires socket_id' do
      catalog = CatalogAPI::Catalog.new(socket_id: nil)

      expect { catalog.search }.to raise_error(CatalogAPI::Error)
    end
  end
end
