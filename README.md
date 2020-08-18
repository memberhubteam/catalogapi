# CatalogAPI

Ruby wrapper around the http://catalogapi.com/ API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'catalogapi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install catalogapi

## Usage

### Setup your CatalogAPI

```
CatalogAPI.key         = 'test-key'    # provided by CatalogAPI.com
CatalogAPI.token       = 'test-token'  # provided by CatalogAPI.com
CatalogAPI.environment = 'development' # or production, default is development
CatalogAPI.username    = 'username'    # provided by CatalogAPI.com (subdomain)
```

### Catalogs

#### List Available Catalogs

```
CatalogAPI::Catalog.list_available.data
=> [
  #<CatalogAPI::Catalog @currency="USD", @export_uri=...,
  #<CatalogAPI::Catalog @currency="USD", @export_uri=...,
]
```

#### List the item categories available in a catalog

```
CatalogAPI::Catalog.new(socket_id: '123').breakdown.data
=> [
  #<CatalogAPI::Category
    @category_id="99",
    @children=[#<CatalogAPI::Category @category_id="11"...>],
    ...
  >,
  ...
]
```

#### Searches a catalog by keyword, category, or price range.

```
CatalogAPI::Catalog.new(socket_id: '123').search(search: 'ipod').data
=> [
  #<CatalogAPI::Item
    @brand="Apple",
    @catalog_item_id=1234
    ...
  >,
  ...
]
```

__Note the `paginated` option will paginate over all pages and aggregate the result__

### Items

#### View the full details of a single item.

```
CatalogAPI::Item.new(catalog_item_id: 1, socket_id: 2).view.data
=> #<CatalogAPI::Item
  ...
  @catalog_item_id="1",
  ...
  @description=
  ...
>
```

### Orders

#### List all orders

```
CatalogAPI::Order.list(external_user_id).data
=> [
  #<CatalogAPI::Order
    external_user_id=1
    ...
  >,
  ...
]
```
__Note the `paginated` option will paginate over all pages and aggregate the result__

#### Place an order
```
CatalogAPI::Order.new(
  items: CatalogAPI::Item.new,
  first_name: "Test",
  last_name: "Testman",
  address_1: "123 Test Street",
  city: "Cincinnati",
  state_province: "OH",
  postal_code: "00000",
  country: "US"
).place.data
=> #<CatalogAPI::Order @order_number="XXXX-XXXXX-XXXXX-XXXX" ...>
```

#### Track an order

```
CatalogAPI::Order.new(order_number: '4004-20883-04361-0098').track.data
=> #<CatalogAPI::Item:0x00007f92d6430948 @order_number="4004-20883-04361-0098" ...>
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/catalogapi.
