Inicis::Standard::Rails::Engine.routes.draw do
  get "transaction/close", to: "transaction#close", as: "transaction_close"
  get "transaction/popup", to: "transaction#popup", as: "transaction_popup"
  get "transaction/pay", to: "transaction#pay", as: "transaction_pay"
  post "transaction/callback", to: "transaction#callback", as: "transaction_callback"
end
