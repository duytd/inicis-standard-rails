module Inicis
  module Standard
    module Rails
      module Paymethod
        class Card
          def initialize options = {}
            @data = options[:data]
          end

          def transaction_info
            [{
              label: I18n.t("inicis.methods.common.paymethod"),
              value: @data["payMethod"]
            },
            {
              label: I18n.t("inicis.methods.card.card_number"),
              value: @data["CARD_Num"]
            },
            {
              label: I18n.t("inicis.methods.card.card_interest"),
              value: @data["CARD_Interest"]
            },
            {
              label: I18n.t("inicis.methods.card.card_quota"),
              value: @data["CARD_Quota"]
            },
            {
              label: I18n.t("inicis.methods.card.refund_possibility"),
              value: @data["CARD_PRTC_CODE"]
            },
            {
              label: I18n.t("inicis.methods.common.amount"),
              value: @data["TotPrice"]
            },
            {
              label: I18n.t("inicis.methods.common.approval_time"),
              value: "#{@data["applDate"]} #{@data["applTime"]}"
            }]
          end
        end
      end
    end
  end
end
