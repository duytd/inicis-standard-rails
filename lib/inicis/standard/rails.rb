require "inicis/standard/rails/version"
require "inicis/standard/rails/paymethod/card"
require "inicis/standard/rails/paymethod/vbank"
require "inicis/standard/rails/paymethod/direct_bank"
require "inicis/standard/rails/configuration"

module Inicis
  module Standard
    module Rails
      class Engine < ::Rails::Engine
        isolate_namespace Inicis::Standard::Rails

        initializer "inicis.assets.precompile" do |app|
          app.config.assets.precompile += %w(inicis_standard/inicis_standard.js inicis_standard/inicis_standard_close.js inicis_standard/inicis_standard_popup.js)
        end
      end
    end
  end
end
