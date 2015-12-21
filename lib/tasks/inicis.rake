namespace :inicis do
  task install: :environment do
    inicis_payment = InicisPayment.create name: "INICIS Payment"

    inicis_payment.payment_method_options.create([
      {
        name: "title",
        title: "Title"
      },
      {
        name: "key_password",
        title: "Key Password"
      },
      {
        name: "sign_key",
        title: "Signature Key"
      },
      {
        name: "merchant_id",
        title: "Merchant ID"
      },
      {
        name: "force_krw_converting",
        title: "Force KRW Converting"
      },
      {
        name: "gopay_method",
        title: "gopaymethod",
        default_value: "Card:DirectBank:VBank:useescrow"
      },
      {
        name: "accept_method",
        title: "acceptmethod",
        default_value: "HPP(1):Card(0):OCB:receipt:cardpoint"
      },
      {
        name: "pay_view_type",
        title: "Pay View Type (popup | overlay)",
        default_value: "overlay"
      },
    ])
  end
end
