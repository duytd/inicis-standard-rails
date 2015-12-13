require "inicis/standard/rails/payment"

module Inicis
  module Standard
    module Rails
      class TransactionController < ::ApplicationController
        def pay
          #To do: shopstory order integration

          inicis_payment = Inicis::Standard::Rails::Payment.new order: order
          @request_payload = inicis_payment.generate_payload
        end

        def close
        end

        def popup
        end

        def callback
        end
      end
    end
  end
end
