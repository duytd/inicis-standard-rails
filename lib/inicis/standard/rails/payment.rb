require "rjb"
require "inicis/standard/rails/payload"

module Inicis
  module Standard
    module Rails
      class Payment
        def initialize options={}
          jars = Dir.glob("#{File.dirname(__FILE__)}/java/*.jar").join ":"
          Rjb.load jars, ["-Xmx512M"]

          date_format = Rjb::import "java.text.SimpleDateFormat"
          signature_util = Rjb::import "com.inicis.std.util.SignatureUtil"
          hash_map = Rjb::import "java.util.HashMap"

          #To do: shopstory admin integration
          sign_key = "SU5JTElURV9UUklQTEVERVNfS0VZU1RS"
          @merchant_key = signature_util._invoke "hash", "Ljava.lang.String;Ljava.lang.String;", sign_key, "SHA-256"
          @timestamp = signature_util.getTimestamp

          @order = options[:order]
          @merchant_id = "INIpayTest"
          @accept_method = "HPP(1):Card(0):OCB:receipt:cardpoint"
          @gopay_method = "Card:DirectBank:VBank:useescrow"
          @pay_view_type = "overlay"

          sign_params = hash_map.new
          sign_params.put "oid", @order[:id]
          sign_params.put "price", @order[:price].to_s
          sign_params.put "timestamp", @timestamp

          @signature = signature_util.makeSignature sign_params
        end

        def generate_payload
          Payload.new(
            merchant_id: @merchant_id,
            signature: @signature,
            order_id: @order[:id],
            goods_name: @order[:goods_name],
            price: @order[:price],
            currency: @order[:currency],
            timestamp: @timestamp,
            merchant_key: @merchant_key,
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
