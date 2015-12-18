$:.push(File.expand_path('../../../../../',__FILE__) + "/server/gen-rb")
$:.unshift "./rb/lib"

require "thrift"
require "inicis"
require "inicis/standard/rails/payload"

module Inicis
  module Standard
    module Rails
      class Payment
        include ActionView::Helpers::NumberHelper

        def initialize options={}
            @sign_key = "SU5JTElURV9UUklQTEVERVNfS0VZU1RS"
            @order = options[:order]
            @merchant_id = "INIpayTest"
            @accept_method = "HPP(1):Card(0):OCB:receipt:cardpoint"
            @gopay_method = "Card:DirectBank:VBank:useescrow"
            @pay_view_type = "overlay"
        end

        def generate_payload mobile=false
          begin
            transport = Thrift::BufferedTransport.new Thrift::HTTPClientTransport.new(Inicis::Standard::Rails.configuration.thrift_server)
            protocol = Thrift::BinaryProtocol.new transport
            client = Inicis::Client.new protocol
            transport.open

            merchant_key = client.makeHash @sign_key
            timestamp = client.getTimestamp
            signature = client.makeSignature @order[:id].to_s, number_with_precision(@order[:price], precision: 0, delimiter: ""), timestamp

            transport.close
          rescue Thrift::Exception => tx
            print "Thrift::Exception: ", tx.message, "\n"
          end

          Payload.new(
            merchant_id: @merchant_id,
            signature: signature,
            order_id: @order[:id],
            goods_name: @order[:goods_name],
            price: @order[:price],
            currency: @order[:currency],
            timestamp: timestamp,
            merchant_key: merchant_key,
            buyer_name: @order[:buyer_name],
            buyer_email: @order[:buyer_email],
            buyer_phone: @order[:buyer_phone],
            gopay_method: @gopay_method,
            accept_method: @accept_method,
            pay_view_type: @pay_view_type
          )
        end
      end
    end
  end
end
