# CatalogAPI

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/catalogapi`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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
  #<CatalogAPI::Catalog:0x00007faa44be80e8 @currency="USD", @export_uri=...,
  #<CatalogAPI::Catalog:0x00007faa44be80e9 @currency="USD", @export_uri=...,
]
```

#### List the item categories available in a catalog

```
CatalogAPI::Catalog.new(socket_id: '123').breakdown.data
=> [
  #<CatalogAPI::Category:0x00007f806a40c5d0
    @category_id="99",
    @children=[#<CatalogAPI::Category:0x00007f806a40c530 @category_id="11"...>],
    ...
  >,
  ...
]
```

#### Searches a catalog by keyword, category, or price range.

```
CatalogAPI::Catalog.new(socket_id: '123').search(search: 'ipod').data
=> [
  #<CatalogAPI::Item:0x00007fa77c56f3d0
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
CatagalogAPI::Item.new(catalog_item_id: 1, socket_id: 2).view.data
=> #<CatalogAPI::Item:0x00007ff7eb43efc8
  ...
  @catalog_item_id="1",
  ...
  @description=
  ...
>
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/catalogapi.
