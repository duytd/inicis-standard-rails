module InicisHelper
  def inicis_order
    order_token = case session[:order_type]
                  when "ticket"
                    cookies[:to]
                  else
                    cookies[:po]
                  end

    order ||= Order.find_by_token order_token

    unless order.nil?
      case order.type
      when "ShopstoryTicket::Booking"
        goods_name = order.ticket_bookings.inject(""){|str, x| str + x.ticket.name + ","}
      when "ProductOrder"
        goods_name = order.order_products.inject(""){|str, x| str + x.variation.name + ","}
      end

      @inicis_order ||= {
        id: order.id,
        goods_name: goods_name,
        buyer_name: "#{order.billing_address.first_name.to_s} #{order.billing_address.last_name.to_s}",
        buyer_email: order.billing_address.email,
        buyer_phone: order.billing_address.phone_number,
        price: order.total,
        submethod: order.payment.submethod
      }
      return @inicis_order
    end

    nil
  end
end
