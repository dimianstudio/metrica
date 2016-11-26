module Metrica
  class Service
    def initialize(config)
      @adapter = config.adapter.instance(config) || config.default_adapter.instance(config)
    end

    def write_point(name, data)
      @adapter.write_point(name, data)
    end

    def query(query)
      @adapter.query(query)
    end
  end
end
