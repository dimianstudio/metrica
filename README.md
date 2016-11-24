# Metrica

[![Build Status](https://travis-ci.org/dimianstudio/metrica.svg?branch=master)](https://travis-ci.org/dimianstudio/metrica)

Simple gem for pushing metrics into different sources

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metrica'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metrica

## Usage

You can add the file at `config/initializers/metrica.rb`:

``` ruby
Metrica.configure do |c|
  if File.exist?('config/influx_db.yml')
    c.adapter = Metrica::Adapters::InfluxDbAdapter
    c.connection_hash = YAML.load(File.open('config/influx_db.yml'))[ENV].symbolize_keys
  else
    c.adapter = Metrica::Adapters::FakeAdapter
  end
end
```

By default Metrica uses `Metrica::Adapters::FakeAdapter` which means nowhere and nothing will be sent.

After you can use:

``` ruby
Metrica.write_point('events', {url: '/foo', user_id: current_user.id})
```

## Usage

There are 2 adapters:

| Adapter | Description | Options  |
|---|---|---|
| Metrica::Adapters::InfluxDbAdapter | InfluxDB adapter ([influxdb](https://github.com/influxdata/influxdb-ruby)) | connection_hash - ```{ hosts: ['localhost'], port: 8086, username: 'root', password: 'root', database: 'db' }``` |
| Metrica::Adapters::FakeAdapter | Nowhere nothing will be sent | |


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dimianstudio/metrica. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
