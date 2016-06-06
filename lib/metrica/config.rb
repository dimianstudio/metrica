require 'metrica/adapters/fake_adapter'

module Metrica
  class Config
    attr_accessor :enabled
    attr_accessor :adapter
    attr_accessor :connection_hash

    DEFAULTS = {
      enabled: false,
      adapter: Metrica::Adapters::FakeAdapter
    }

    def initialize
      @enabled = DEFAULTS[:enabled]
      @adapter = DEFAULTS[:adapter]
    end

    def enabled?
      @enabled == true
    end

    def default_adapter
      DEFAULTS[:adapter]
    end
  end
end