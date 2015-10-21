Inicis::Standard::Rails::Engine.routes.draw do
  get "pay/close", to: "pay#close"
  get "pay/popup", to: "pay#popup"
end
