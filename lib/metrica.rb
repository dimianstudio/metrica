require 'metrica/version'
require 'metrica/service'
require 'metrica/config'

module Metrica
  class << self
    def configure
      yield(config)
      @service = nil
    end

    def config
      @config ||= Metrica::Config.new
    end

    def service
      @service ||= Metrica::Service.new(config)
    end

    def write_point(name, data)
      service.write_point(name, data)
    end

    def query(query)
      service.query(query)
    end
  end
end
