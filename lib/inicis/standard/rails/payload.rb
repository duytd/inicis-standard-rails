require "digest"

$:.push(File.expand_path('../../../../../',__FILE__) + "/server/gen-rb")
$:.unshift "./rb/lib"

require "thrift"
require "inicis"

module Inicis
  module Standard
    module Rails
      class Payload
        include ActionView::Helpers::NumberHelper

        attr_reader :merchant_id, :signature, :order_id, :goods_name, :price, :currency, :timestamp,
          :merchant_key, :buyer_name, :buyer_email, :buyer_phone, :gopay_method, :accept_method,
          :pay_view_type, :notification, :submethod

        def initialize params={}
          @merchant_id = params[:merchant_id]
          @signature = params[:signature]
          @order_id = params[:order_id].to_s
          @goods_name = params[:goods_name]
          @price = number_with_precision(params[:price], precision: 0, delimiter: "")
          @currency = params[:currency]
          @timestamp = params[:timestamp]
          @merchant_key = params[:merchant_key]
          @buyer_name = params[:buyer_name]
          @buyer_email = params[:buyer_email]
          @buyer_phone = params[:buyer_phone]
          @gopay_method = params[:gopay_method]
          @accept_method = params[:accept_method]
          @pay_view_type = params[:pay_view_type]
          @submethod = params[:submethod]
          @notification = Inicis::Standard::Rails::Payload.encrypt_notification @order_id, Inicis::Standard::Rails::Payload.noti_hash
        end

        def self.encrypt_notification data, hash
          param = {
            oid: data,
            hash: hash
          }

          Inicis::Standard::Rails::Payload.crypto :aes256_cbc_encrypt, Inicis::Standard::Rails.configuration.crypto_key,
            param.to_json, Inicis::Standard::Rails.configuration.crypto_iv
        end

        def self.decrypt_notification data
          Inicis::Standard::Rails::Payload.crypto :aes256_cbc_decrypt, Inicis::Standard::Rails.configuration.crypto_key,
            data, Inicis::Standard::Rails.configuration.crypto_iv
        end

        def self.noti_hash
          Digest::SHA512.hexdigest "#{@merchant_id}|#{@order_id}|#{@price}|#{@buyer_email}||||||"
        end

        def self.crypto function_name, key, data, iv
          begin
            transport = Thrift::BufferedTransport.new Thrift::HTTPClientTransport.new(Inicis::Standard::Rails.configuration.thrift_server)
            protocol = Thrift::BinaryProtocol.new transport
            client = Inicis::Client.new protocol
            transport.open

            crypto_data = client.send function_name, key, data, iv

            transport.close
          rescue Thrift::Exception => tx
            print "Thrift::Exception: ", tx.message, "\n"
          end

          return crypto_data
        end
      end
    end
  end
end
