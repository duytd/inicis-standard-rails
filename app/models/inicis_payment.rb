class InicisPayment < ::PaymentMethod
  def required_fields
    %w( title key_password sign_key merchant_id gopay_method )
  end
end
