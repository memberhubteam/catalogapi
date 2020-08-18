# frozen_string_literal: true

RSpec.describe CatalogAPI::Order do
  describe '#list' do
    it 'makes http GET request and renders Order List' do
      url = %r{https://username.dev.catalogapi.com/v1/rest/order_list}
      body = fixture('order_list.json')
      stub_request(:get, url)
        .to_return(status: 200, body: body.to_json, headers: {})
      request = CatalogAPI::Order.list(external_user_id: 1)
      items = request.data
      expect(items.count).to eq 2
      expect(items.first.class).to eq CatalogAPI::Order
    end

    context 'when paginated' do
      it 'makes http GET request paginated' do
        body = fixture('order_list.paginated.json')
        url = %r{https://username.dev.catalogapi.com/v1/rest/order_list}
        stub_request(:get, url).to_return(status: 200, body: body.to_json, headers: {})
        body = fixture('order_list.json')
        stub_request(:get, %r{https://username.dev.catalogapi.com/v1/rest/order_list?.{0,1000}page=2}).to_return(status: 200, body: body.to_json, headers: {})
        request = CatalogAPI::Order.list({ external_user_id: 1, paginated: true })
        items = request.data
        expect(items.count).to eq 4
      end
    end

    it 'requires external_user_id' do
      expect { CatalogAPI::Order.list }.to raise_error(CatalogAPI::Error)
    end
  end

  describe '#place' do
    let(:options) do
      {
        socket_id: 'something',
        external_user_id: 'something',
        external_order_number: 'something',
        first_name: 'something',
        last_name: 'something',
        address_1: 'something',
        address_2: 'something',
        address_3: 'something',
        city: 'something',
        state_province: 'something',
        postal_code: 'something',
        country: 'something',
        email: 'something',
        phone_number: 'something',
        items: [CatalogAPI::Item.new(catalog_item_id: 1, catalog_price: 1.00)]
      }
    end

    it 'makes http POST request and renders Order' do
      body = fixture('order_place.json')
      order = CatalogAPI::Order.new(options)
      request = CatalogAPI.request.new(:order_place)
      allow_any_instance_of(CatalogAPI::Request).to receive(:required_params)
        .and_return({})
      stub_request(:post, 'https://username.dev.catalogapi.com/v1/json/order_place')
        .with(body: order.send(:place_params, request).to_json.to_s)
        .to_return(status: 200, body: body.to_json, headers: {})

      request = order.place
      order = request.data
      expect(order.order_number).to eq '1111-22222-33333-4444'
    end

    it 'validates required params' do
      required = %i[socket_id first_name last_name address_1 city state_province postal_code country items]
      required.each do |i|
        expect do
          CatalogAPI::Order.new(options.merge(i => nil)).place
        end.to raise_error(CatalogAPI::Error)
      end
    end
  end

  describe '#track' do
    it 'makes http GET request and renders Order' do
      order_number = '9266-02805-92881-0001'
      body = fixture('order_track.json')
      stub_request(:get, "https://username.dev.catalogapi.com/v1/json/order_track?order_number=#{order_number}")
        .to_return(status: 200, body: body.to_json, headers: {})

      order = CatalogAPI::Order.new(order_number: order_number)
      request = order.track
      order = request.data
      expect(order.order_number).to eq order_number
    end

    it 'validates order_number params' do
      expect do
        CatalogAPI::Order.new({}).track
      end.to raise_error(CatalogAPI::Error)
    end
  end
end
