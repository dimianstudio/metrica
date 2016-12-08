require 'influxdb'

module Metrica
  module Adapters
    class InfluxDbAdapter
      def self.instance(config)
        if config.connection_hash.is_a?(Hash)
          hosts_checking = config.connection_hash[:hosts].any? do |host|
            url = "http://#{host}:#{config.connection_hash[:port]}/ping"
            !(Net::HTTP.get_response(URI(url)).code rescue nil).nil?
          end

          new(config.connection_hash) if hosts_checking
        end
      end

      def initialize(config)
        check_and_create_db!(config)
        @client = InfluxDB::Client.new(config[:database],
          hosts:    config[:hosts],
          port:     config[:port],
          username: config[:username],
          password: config[:password],
          async:    config[:async].nil? ? true : config[:async],
          time_precision: config[:time_precision] || 'us' # microseconds
        )
      end

      def write_point(name, data)
        data[:timestamp] = if data.key?(:timestamp)
          diff = 19 - Math.log10(data[:timestamp]).ceil
          diff > 0 ? data[:timestamp] * (10**diff) : data[:timestamp]
        else
          (Time.now.to_f * 1000000000).to_i
        end

        @client.write_point(name, data)
      end

      def query(query)
        @client.query(query)
      end

      private

      def check_and_create_db!(config)
        client = InfluxDB::Client.new(
          hosts:    config[:hosts],
          port:     config[:port],
          username: config[:username],
          password: config[:password]
        )

        unless client.list_databases.any? { |db| db['name'] == config[:database] }
          client.create_database(config[:database])
        end
      end
    end
  end
end
