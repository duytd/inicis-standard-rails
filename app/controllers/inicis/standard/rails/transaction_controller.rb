require "inicis/standard/rails/payment"
require "inicis/standard/rails/authorization"
require "rubygems"
require "browser"
require "iconv"

module Inicis
  module Standard
    module Rails
      class TransactionController < Inicis::Standard::Rails.configuration.parent_klass
        protect_from_forgery with: :null_session
        before_action :load_logger
        before_action :detect_browser, only: :pay
        before_action :validate_order!, only: :pay

        layout false

        include InicisHelper

        def pay
          payment_method_shop = current_shop.payment_method_shops.find_by_payment_method_id InicisPayment.first.id
          inipayhome = File.dirname(payment_method_shop.key.url) if payment_method_shop.key
          sign_key = payment_method_shop.load_option "sign_key"
          merchant_id = payment_method_shop.load_option "merchant_id"
          accept_method = payment_method_shop.load_option "accept_method"
          pay_view_type = payment_method_shop.load_option "pay_view_type"
          quotabase = payment_method_shop.load_option "quotabase"

          gopay_method = case inicis_order[:submethod]
                                                when "card"
                                                  "Card"
                                                when "vbank"
                                                  "VBank"
                                                when "directbank"
                                                  "DirectBank"
                                                else
                                                  "Card:DirectBank:VBank"
                                                end

          accept_method.gsub!("useescrow" , "") if inicis_order[:submethod] == "card"

          inicis_payment = Inicis::Standard::Rails::Payment.new(
            order: inicis_order,
            inipayhome: inipayhome,
            sign_key: sign_key,
            merchant_id: merchant_id,
            gopay_method: gopay_method,
            accept_method: accept_method,
            pay_view_type: pay_view_type,
            quotabase: quotabase
          )

          @request_payload = inicis_payment.generate_payload
        end

        def close
        end

        def popup
        end

        def callback
          @logger.info "Callback from Inicis..."
          @logger.debug params
          inicis_authorization = Inicis::Standard::Rails::Authorization.new

          if params[:resultCode] == "0000"
            @logger.info "Successful make payment request. Waiting for approvement..."

            data = {
              mid: params[:mid],
              token: params[:authToken],
              authorize_url: params[:authUrl],
              net_cancel_url: params[:netCancelUrl],
              ack_url: params[:checkAckUrl]
            }

            authorize_data = inicis_authorization.authorize data

            if authorize_data
              order = Order.find params[:orderNumber]
              order.payment.save_transaction(
                submethod: authorize_data["payMethod"].downcase,
                extra_data: authorize_data.to_json,
                transaction_number: authorize_data["tid"]
              )

              if authorize_data["payMethod"].downcase == "vbank"
                order.processing!
              else
                order.payment.paid!
                order.processed!
              end

              redirect_to main_app.customer_success_path
            else
              @error = Iconv.iconv "UTF-8//IGNORE", "euc-kr", "Code: #{params[:resultCode]}. Message: #{params[:resultMsg]}"
              render :failure
            end
          else
            @error = Iconv.iconv "UTF-8//IGNORE", "euc-kr", "Code: #{params[:resultCode]}. Message: #{params[:resultMsg]}"
            @logger.debug "Failed to make payment request. #{@error}"
            render :failure
          end
        end

        def cancel
        end

        def vbank_noti
          @logger.info "Virtual Bank notification from Inicis:"
          @logger.debug params

          temp_ip = request.remote_ip
          pg_ip = temp_ip[0, 10]

          @logger.info "Receiving noti from IP: #{pg_ip}"

          if pg_ip == "118.129.210" || pg_ip == "203.238.37" || pg_ip == "211.219.96"
            no_oid = params[:no_oid]
            no_tid = params[:no_tid]
            no_vacct = params[:no_vacct]
            cd_bank = params[:cd_bank]
            amt_input = params[:amt_input]

            order = Order.find no_oid
            payment_extra_data = JSON.parse order.payment.extra_data

            unless order.processed? && order.payment.paid?
              if payment_extra_data["MOID"] != no_oid
                render plain: "FAIL_11" and return
              elsif payment_extra_data["VACT_BankCode"].to_i != cd_bank.to_i
                render plain: "FAIL_12" and return
              elsif payment_extra_data["VACT_Num"] != no_vacct
                render plain: "FAIL_13" and return
              elsif payment_extra_data["TotPrice"].to_f != amt_input.to_f
                render plain: "FAIL_14" and return
              end

              order.payment.paid!
              order.processed!

              @logger.info "Completed Virtual Bank payment"
              render plain: "OK" and return
            else
              @logger.info "Payment had already been processed"
              render plain: "FAILED" and return
            end
          else
            @logger.info "Permission denied from remote ip: #{temp_ip}"
            render plain: "FAILED" and return
          end
        end

        def failure
          flash[:danger] = t "inicis.failure"
        end

        private
        def validate_order!
          unless inicis_order
            render text: "access_denied", status: :unauthorized
          end
        end

        def load_logger
          @logger ||= Logger.new "#{::Rails.root}/log/inicis/pc.log"
        end

        def detect_browser
          if browser.device.mobile?
            redirect_to mobile_transaction_pay_path
          end
        end
      end
    end
  end
end
