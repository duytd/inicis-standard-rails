require "inicis/standard/rails/payment"
require "inicis/standard/rails/authorization"

module Inicis
  module Standard
    module Rails
      module Mobile
        class TransactionController < Inicis::Standard::Rails.configuration.parent_klass
          protect_from_forgery with: :null_session
          before_action :load_logger

          include InicisHelper

          def pay
            payment_method_shop = current_shop.payment_method_shops.find_by_payment_method_id InicisPayment.first.id
            merchant_id = payment_method_shop.load_option "merchant_id"

            inicis_payment = Inicis::Standard::Rails::Payment.new(
              order: inicis_order,
              merchant_id: merchant_id,
            )

            @request_payload = inicis_payment.generate_payload true
          end

          def callback
          end

          def next
            payment_method_shop = current_shop.payment_method_shops.find_by_payment_method_id InicisPayment.first.id
            inipayhome = File.dirname payment_method_shop.key.url
            merchant_id = payment_method_shop.load_option "merchant_id"
            inicis_authorization = Inicis::Standard::Rails::Authorization.new

            @logger.info "Mobile Authentication Result:"
            @logger.debug params

            if params[:P_STATUS] == "00"
              data = {
                inipayhome: inipayhome,
                mid: merchant_id,
                p_rmesg1: params[:P_RMESG1],
                p_tid: params[:P_TID],
                p_req_url: params[:P_REQ_URL],
                p_noti: params[:P_REQ_URL],
                p_status: params[:P_STATUS]
              }

              authorize_data = inicis_authorization.authorize_mobile data

              if authorize_data
                order = Order.find authorize_data["m_moid"]

                if authorize_data["m_payMethod"].downcase == "vbank"
                  extra_data = {
                    oid: authorize_data["m_moid"],
                    vact_bank_code: authorize_data["m_vcdbank"],
                    vact_name: authorize_data["m_nmvacct"],
                    vact_input_name: authorize_data["m_buyerName"],
                    vact_date: authorize_data["m_dtinput"],
                    vact_time: authorize_data["m_tminput"],
                    vact_num: authorize_data["m_vacct"],
                    total: authorize_data["m_resultprice"]
                  }

                  order.payment.update_attributes extra_data: extra_data.to_json
                else
                  order.payment.change_state "paid"
                  order.change_status "processed"
                end

                redirect_to main_app.customer_thank_you_path
              else
                render "inicis/transaction/failure"
              end
            else
              @logger.debug "Failed to make payment request. Code: #{params[:P_STATUS]}. Message: #{params[:P_RMESG1]}"
              render "inicis/transaction/failure"
            end
          end

          def cancel
          end

          def noti
          end

          private
          def load_logger
            @logger ||= Logger.new "#{::Rails.root}/log/inicis/mobile.log"
          end
        end
      end
    end
  end
end
