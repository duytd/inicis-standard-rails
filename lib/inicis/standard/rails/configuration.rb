module Inicis
  module Standard
    module Rails
      class << self
        attr_accessor :configuration
      end

      def self.configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end

      class Configuration
        attr_accessor :parent_klass, :thrift_server, :crypto_key, :crypto_iv

        def initialize
          @parent_klass = ::ApplicationController
          @thrift_server = "http://localhost:9090"
          @crypto_key = "inicis_crypto_key"
          @crypto_iv = "inicis_crypto_iv"
        end
      end
    end
  end
end
