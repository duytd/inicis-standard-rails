module Inicis
  module Standard
    module Rails
      class Payload
        attr_reader :merchant_id, :signature, :order_id, :goods_name, :price, :currency, :timestamp,
          :merchant_key, :buyer_name, :buyer_email, :buyer_phone, :gopay_method, :accept_method, :pay_view_type

        def initialize params={}
          @merchant_id = params[:merchant_id]
          @signature = params[:signature]
          @order_id = params[:order_id]
          @goods_name = params[:goods_name]
          @price = params[:price]
          @currency = params[:currency]
          @timestamp = params[:timestamp]
          @merchant_key = params[:merchant_key]
          @buyer_name = params[:buyer_name]
          @buyer_email = params[:buyer_email]
          @buyer_phone = params[:buyer_phone]
          @gopaymethod = params[:gopay_method]
          @accept_method = params[:accept_method]
          @pay_view_type = params[:pay_view_type]
        end
      end
    end
  end
end
