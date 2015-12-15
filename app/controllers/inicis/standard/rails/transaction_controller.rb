require "inicis/standard/rails/payment"
require "inicis/standard/rails/authentication"

module Inicis
  module Standard
    module Rails
      class TransactionController < Inicis::Standard::Rails.configuration.parent_klass
        protect_from_forgery with: :null_session
        before_action :load_logger

        def pay
          if cart_token = cookies[:cart]
            order = Order.find_by_token cart_token
          else
            redirect_to main_app.root_path
          end

          order = {
            id: order.id,
            goods_name: order.order_products.inject(""){|str, x| str + x.product.name + ","},
            buyer_name: order.shipping_address.first_name + order.shipping_address.last_name,
            buyer_email: order.shipping_address.email,
            buyer_phone: order.shipping_address.phone_number,
            price: order.subtotal
          }

          inicis_payment = Inicis::Standard::Rails::Payment.new order: order
          @request_payload = inicis_payment.generate_payload
        end

        def close
        end

        def popup
        end

        def callback
          @logger.info "Callback from Inicis..."
          @logger.debug params
          inicis_authentication = Inicis::Standard::Rails::Authentication.new

          if params[:resultCode] == "0000"
            @logger.info "Successful make payment request. Waiting for approvement..."

            data = {
              mid: params[:mid],
              token: params[:authToken],
              authorize_url: params[:authUrl],
              net_cancel_url: params[:netCancelUrl],
              ack_url: params[:ackUrl]
            }

            approvement = inicis_authentication.approve data

            if approvement
              @logger.info "Payment is approved successfully"
              #To_do: save_transaction
              #To_do: success
            else
              @logger.debug "Failed to approve payment"
              failure "Approvement Failed !"
            end
          else
            @logger.debug "Failed to make payment request"
            failure "Invalid Request !"
          end
        end

        def failure message
          flash[:danger] = message
          render :pay
        end

        def success
        end

        private
        def load_logger
          @logger ||= Logger.new "#{::Rails.root}/log/inicis.log"
        end
      end
    end
  end
end
