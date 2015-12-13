require "inicis/standard/rails/payment"

module Inicis
  module Standard
    module Rails
      class TransactionController < ::ApplicationController
        def pay
          order = {
            id: "order_1",
            goods_name: "Good Name",
            buyer_name: "Trinh Duc Duy",
            buyer_email: "duytd.hanu@gmail.com",
            buyer_phone: "0123456789",
            price: 10000
          }

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
