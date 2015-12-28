require "inicis/standard/rails/payment"
require "inicis/standard/rails/authorization"

module Inicis
  module Standard
    module Rails
      module Mobile
        class TransactionController < Inicis::Standard::Rails.configuration.parent_klass
          protect_from_forgery with: :null_session
          before_action :load_logger
          before_action :load_order, only: :pay

          def pay
          end

          def vbank_noti
          end

          def failure
          end

          def cancel
          end

          private
          def load_logger
            @logger ||= Logger.new "#{::Rails.root}/log/inicis/mobile.log"
          end

          def load_order
            if cart_token = cookies[:cart]
              @order = Order.find_by_token cart_token
            else
              redirect_to main_app.root_path
            end
          end

        end
    end
  end
end
