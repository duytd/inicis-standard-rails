module Inicis
  module Standard
    module Rails
      module Paymethod
        class Vbank
          def initialize options = {}
            @data = options[:data]
          end

          def transaction_info
            [{
              label: I18n.t("inicis.methods.common.paymethod"),
              value: @data["payMethod"]
            },
            {
              label: I18n.t("inicis.methods.vbank.note"),
              value: I18n.t("inicis.methods.vbank.note_content"),
              show_admin: false
            },
            {
              label: I18n.t("inicis.methods.vbank.account_number"),
              value: @data["VACT_Num"]
            },
            {
              label: I18n.t("inicis.methods.vbank.bank_name"),
              value: Vbank.bank_name(@data["VACT_BankCode"])
            },
            {
              label: I18n.t("inicis.methods.vbank.account_holder_name"),
              value: @data["VACT_Name"]
            },
            {
              label: I18n.t("inicis.methods.vbank.sender_name"),
              value: @data["VACT_InputName"]
            },
            {
              label: I18n.t("inicis.methods.common.amount"),
              value: @data["TotPrice"]
            },
            {
              label: I18n.t("inicis.methods.vbank.wire_transfer_date"),
              value: @data["VACT_Date"]
            },
            {
              label: I18n.t("inicis.methods.vbank.wire_transfer_time"),
              value: @data["VACT_Time"]
            }]
          end

          def self.bank_name code
            name_list = {
              "03" => "기업은행",
              "04" => "국민은행",
              "05" => "외환은행",
              "06" => "국민은행(구 주택은행)",
              "07" => "수협중앙회",
              "11" => "농협중앙회",
              "12" => "단위농협",
              "20" => "우리은행",
              "21" => "조흥은행",
              "23" => "제일은행",
              "32" => "부산은행",
              "71" => "우체국",
              "81" => "하나은행",
              "88" => "신한은행"
            }

            name_list[code] || code
          end
        end
      end
    end
  end
end
