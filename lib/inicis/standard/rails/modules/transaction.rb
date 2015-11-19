require "active_support/time"

class Transaction
  class << self
    def generate_transaction_id payment_method, mid, mobile_type
      current_time = Time.now.in_time_zone("Asia/Seoul")
      time = current_time.strftime("%Y%m%d%H%M%S") + ((current_time.to_f - current_time.to_i)*1000).round.to_s
      prefix = ""

      prefix = if mobile_type
        "StdMX_"
      else
        "Stdpay"
      end

      if time.length == 17
      elsif time.length == 16
        time = time + "0"
      else
        time = time + "00"
      end

      prefix + get_PGID(payment_method) + mid + time + generate_random_number
    end

    private
    def get_PGID payment_method
      pgid = ""

      case payment_method
      when "Card"
          pgid = "CARD"
       when "Account"
          pgid = "ACCT"
       when "DirectBank"
          pgid = "DBNK"
       when "OCBPoint"
          pgid = "OCBP"
       when "VCard"
          pgid = "ISP_"
       when "HPP"
          pgid = "HPP_"
       when "Nemo"
          pgid = "NEMO"
       when "ArsBill"
          pgid = "ARSB"
       when "PhoneBill"
          pgid = "PHNB"
       when "Ars1588Bill"
          pgid = "1588"
       when "VBank"
          pgid = "VBNK"
       when "Culture"
          pgid = "CULT"
       when "CMS"
          pgid = "CMS_"
       when "AUTH"
          pgid = "AUTH"
       when "INIcard"
          pgid = "INIC"
       when "MDX"
          pgid = "MDX_"
       when "CASH"
          pgid = "CASH"
        else
          if payment_method.length > 4
            pgid = payment_method.upcase
            pgid = pgid.slice 0, 4
          else
            pgid = pgid.strip
          end
        end

        pgid
    end

    def generate_random_number
      number_string  = ""
      random = Random.rand 0..300

      if random < 10
        number_string = number_string + "00" + random.to_s
      elsif random < 100
        number_string = number_string + "0" + random.to_s
      else
        number_string = random.to_s
      end

      number_string
    end
  end
end
