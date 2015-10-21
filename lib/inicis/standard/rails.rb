require "inicis/standard/rails/version"

module Inicis
  module Standard
    module Rails
      class Engine < ::Rails::Engine
        isolate_namespace Inicis::Standard::Rails

        initializer "inicis.assets.precompile" do |app|
          app.config.assets.precompile += %w(inicis_standard/inicis_standard_close.js inicis_standard/inicis_standard_popup.js)
        end
      end
    end
  end
end
