module Inicis
  module Standard
    module Rails
      module Paymethod
        class DirectBank
          def initialize options = {}
            @data = options[:data]
          end

          def transaction_info
            [{
              label: I18n.t("inicis.methods.common.paymethod"),
              value: @data["payMethod"]
            },
            {
              label: I18n.t("inicis.methods.direct_bank.issuance_result_code"),
              value: Vbank.bank_name(@data["CSHR_ResultCode"])
            },
            {
              label: I18n.t("inicis.methods.direct_bank.issuance_type_code"),
              value: @data["CSHR_Type"]
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
