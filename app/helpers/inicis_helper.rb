module InicisHelper
  def inicis_order
    cart_token = cookies[:cart]
    order ||= Order.find_by_token cart_token
    @inicis_order ||= {
      id: order.id,
      goods_name: order.order_products.inject(""){|str, x| str + x.product.name + ","},
      buyer_name: order.billing_address.first_name + order.billing_address.last_name.to_s,
      buyer_email: order.billing_address.email,
      buyer_phone: order.billing_address.phone_number,
      price: order.total,
      submethod: order.payment.submethod
    }
  end
end
