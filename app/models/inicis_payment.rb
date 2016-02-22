class InicisPayment < PaymentMethod
  def required_fields
    ["title", "key_password", "sign_key", "merchant_id", "gopaymethod"]
  end
end
