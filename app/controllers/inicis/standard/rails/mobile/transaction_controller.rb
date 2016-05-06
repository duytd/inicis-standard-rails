require "inicis/standard/rails/payment"
require "inicis/standard/rails/authorization"
require "rubygems"
require "browser"
require "iconv"

module Inicis
  module Standard
    module Rails
      module Mobile
        class TransactionController < Inicis::Standard::Rails.configuration.parent_klass
          protect_from_forgery with: :null_session
          before_action :load_logger
          before_action :detect_browser, only: :pay

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
            clear_order
            redirect_to main_app.customer_success_path
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
                extra_data = {
                  payMethod: authorize_data["m_payMethod"],
                  MOID: authorize_data["m_moid"],
                  tid: authorize_data["m_tid"],
                  VACT_BankCode: authorize_data["m_vcdbank"],
                  VACT_Name: authorize_data["m_nmvacct"],
                  VACT_Inputname: authorize_data["m_buyerName"],
                  VACT_Date: authorize_data["m_dtinput"],
                  VACT_Time: authorize_data["m_tminput"],
                  VACT_Num: authorize_data["m_vacct"],
                  TotPrice: authorize_data["m_resultprice"],
                  applTime: authorize_data["m_pgAuthTime"],
                  applDate: authorize_data["m_pgAuthDate"],
                  CARD_Num: authorize_data["m_cardCode"],
                  CARD_Quota: authorize_data["m_cardQuota"],
                  CARD_PRTC_CODE: authorize_data["m_prtc"],
                }

                order.payment.save_transaction(
                  submethod: authorize_data["m_payMethod"].downcase,
                  extra_data: extra_data.to_json,
                  transaction_number: authorize_data["tid"]
                )

                if authorize_data["m_payMethod"].downcase == "vbank"
                  order.processing!
                else
                  order.payment.paid!
                  order.processed!
                end

                redirect_to main_app.customer_success_path
              else
                @error = Iconv.iconv "UTF-8//IGNORE", "euc-kr", "Code: #{params[:P_STATUS]}. Message: #{params[:P_RMESG1]}"
                render "inicis/standard/rails/transaction/failure"
              end
            else
              @error = Iconv.iconv "UTF-8//IGNORE", "euc-kr", "Code: #{params[:P_STATUS]}. Message: #{params[:P_RMESG1]}"
              @logger.debug "Failed to make payment request. #{@error}"
              render "inicis/standard/rails/transaction/failure"
            end
          end

          def cancel
          end

          def noti
            @logger.info "Mobile notification from Inicis:"
            @logger.debug params

            pg_ip = request.remote_ip
            @logger.info "Receiving noti from IP: #{pg_ip}"

            if pg_ip == "181.224.158.40" || pg_ip == "118.129.210.25"
              if params[:P_TYPE].downcase == "vbank"
                order = Order.find params[:P_OID]

                arr_tmp = params[:P_RMESG1].split "|"
                p_vacct_no_tmp = arr_tmp[0].split "="
                p_vacct_no = p_vacct_no_tmp[1]
                p_exp_datetime_tmp = arr_tmp[1].split "="
                p_exp_datetime = p_exp_datetime_tmp[1]

                payment_extra_data = JSON.parse order.payment.extra_data
                @logger.debug payment_extra_data

                if params[:P_STATUS] == "02"
                  unless order.processed? && order.payment.paid?
                    if payment_extra_data["oid"] != params[:P_OID]
                      render plain: "FAIL_M11" and return
                    elsif payment_extra_data["vact_bank_code"] != params[:P_FN_CD1]
                      render plain: "FAIL_M12" and return
                    elsif payment_extra_data["vact_num"] != p_vacct_no
                      render plain: "FAIL_M13" and return
                    elsif payment_extra_data["total"].to_f != params[:P_AMT].to_f
                      render plain: "FAIL_M14" and return
                    end

                    order.payment.paid!
                    order.payment.save_transaction transaction_number: params[:P_TID]
                    order.processed!

                    @logger.info "Completed Virtual Bank payment"
                    render plain: "OK" and return
                  else
                    @logger.info "Payment had already been processed"
                    render plain: "FAIL_20" and return
                  end
                elsif params[:P_STATUS] == "00"
                  render plain: "OK" and return
                else
                  @logger.info "Failed: Code #{params[:P_STATUS]}"
                  render plain: "FAIL" and return
                end
              end

              notification = JSON.parse Inicis::Standard::Rails::Payload.decrypt_notification params[:P_NOTI]
              @logger.debug notification

              unless notification
                @logger.info "Empty notification"
                render plain: "FAIL" and return
              end

              if params[:P_STATUS] == "00"
                order = Order.find params[:P_OID]
                checkhash = Inicis::Standard::Rails::Payload.noti_hash "#{params[:P_MID]}|#{params[:P_OID]}|#{params[:P_AMT]}|#{order.billing_address.email}||||||"
                @logger.debug "Checkhash: #{checkhash}"

                unless order.processed? && order.payment.paid?
                  if notification["oid"] != params[:P_OID]
                    render plain: "FAIL" and return
                  elsif notification["hash"] != checkhash
                    render plain: "FAIL" and return
                  end

                  order.payment.save_transaction_number params[:P_TID]
                  order.payment.paid!
                  order.processed!

                  @logger.info "Completed mobile payment via #{params[:P_TYPE]}"
                  render plain: "OK" and return
                else
                  @logger.info "Payment had already been processed"
                  render plain: "FAIL_20" and return
                end
              else
                @logger.info "Failed: Code #{params[:P_STATUS]}"
                render plain: "FAIL" and return
              end
            else
              @logger.info "Permission denied from remote ip: #{temp_ip}"
              render plain: "FAILED" and return
            end
          end

          private
          def load_logger
            @logger ||= Logger.new "#{::Rails.root}/log/inicis/mobile.log"
          end

          def detect_browser
            unless browser.device.mobile?
              redirect_to transaction_pay_path
            end
          end
        end
      end
    end
  end
end
