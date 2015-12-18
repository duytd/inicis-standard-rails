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
        attr_accessor :parent_klass, :thrift_server

        def initialize
          @parent_klass = ::ApplicationController
          @thrift_server = "http://localhost:9090"
        end
      end
    end
  end
end
