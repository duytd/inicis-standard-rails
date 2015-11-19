require "active_support/time"

class PaymentUltility
  class << self
    def get_timestamp
      current_time = Time.now.in_time_zone "Asia/Seoul"
      milliseconds = (current_time.to_f * 1000).round
      temp_value1 = (milliseconds/1000).round.to_s
      temp_value2 = ((current_time.to_f - current_time.to_i) * 1000).round.to_s

      case temp_value2.length
      when 3
      when 2
        temp_value2 = "0" + temp_value2
      when 1
        temp_value2 = "00" + temp_value2
      else
        temp_value2 = "000"
      end

      temp_value1 + temp_value2
    end

    def generate_signature sign_param
      string = ""

      sign_param.keys.sort.each do |k|
        string = string + "&" + k.to_s + "=" + sign_param[k].to_s
      end

      string = string.slice 1, sign_param.length - 1

      generate_hash string
    end

    def generate_hash data
      sha256 = OpenSSL::Digest::SHA256.new
      sha256.digest data
    end
  end
end
