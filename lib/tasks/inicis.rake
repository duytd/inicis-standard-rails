namespace :inicis do
  task install: :environment do
    inicis_payment = InicisPayment.find_or_create_by name: "INICIS Payment",
      key_required: true, mobile_submethods: "card|vbank|directbank", desktop_submethods: "card|vbank|directbank"

    inicis_payment.payment_method_options.create([
      {
        name: "title",
        title: "Title",
        option_type: "text"
      },
      {
        name: "key_password",
        title: "Key Password",
        option_type: "text"
      },
      {
        name: "sign_key",
        title: "Signature Key",
        option_type: "text"
      },
      {
        name: "merchant_id",
        title: "Merchant ID",
        option_type: "text"
      },
      {
        name: "gopay_method",
        title: "gopaymethod",
        default_value: "Card:DirectBank:VBank",
        option_type: "text"
      },
      {
        name: "quotabase",
        title: "Installment",
        option_type: "text"
      },
      {
        name: "accept_method",
        title: "acceptmethod",
        default_value: "HPP(1):Card(0):OCB:receipt:cardpoint:useescrow",
        option_type: "text"
      },
      {
        name: "pay_view_type",
        title: "Pay View Type (popup | overlay)",
        default_value: "overlay",
        option_type: "text"
      },
    ])
  end
end
