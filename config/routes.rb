Inicis::Standard::Rails::Engine.routes.draw do
  get "transaction/close", to: "transaction#close", as: "transaction_close"
  get "transaction/popup", to: "transaction#popup", as: "transaction_popup"
  get "transaction/pay", to: "transaction#pay", as: "transaction_pay"
  post "transaction/callback", to: "transaction#callback", as: "transaction_callback"
  post "transaction/vbank_noti", to: "transaction#vbank_noti", as: "transaction_vbank_noti"
  get "transaction/failure", to: "transaction#failure", as: "transaction_failure"

  get "mobile/transaction/pay", to: "mobile/transaction#pay", as: "mobile_transaction_pay"
  get "mobile/transaction/callback", to: "mobile/transaction#callback", as: "mobile_transaction_callback"
  post "mobile/transaction/next", to: "mobile/transaction#next", as: "mobile_transaction_next"
  post "mobile/transaction/noti", to: "mobile/transaction#noti", as: "mobile_transaction_noti"
  post "mobile/transaction/cancel", to: "mobile/transaction#cancel", as: "mobile_transaction_cancel"
end
