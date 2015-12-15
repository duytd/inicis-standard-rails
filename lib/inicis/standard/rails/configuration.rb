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
        attr_accessor :parent_klass

        def initialize
          @parent_klass = ::ApplicationController
        end
      end
    end
  end
end
