require "rjb"

module Inicis
  module Standard
    module Rails
      class Authentication
        def initialize
          jars = Dir.glob("#{File.dirname(__FILE__)}/java/*.jar").join ":"
          Rjb.load jars, ["-Xms128M", "-Xmx512M"]

          @hash_map = Rjb::import "java.util.HashMap"
          @hash_table = Rjb::import "java.util.Hashtable"
          @signature_util = Rjb::import "com.inicis.std.util.SignatureUtil"
          @http_util = Rjb::import "com.inicis.std.util.HttpUtil"
          @parse_util = Rjb::import "com.inicis.std.util.ParseUtil"
        end
      end

      def approve data
        sign_params = @hash_map.new
        sign_params.put "authToken", data.token
        sign_params.put "timestamp", timestamp

        signature = signature_util.makeSignature sign_params

        hash = @hash_table.new
        hash.put "mid", data[:mid]
        hash.put "authToken", data[:token]
        hash.put "signature", signature
        hash.put "timestamp", @signature_util.getTimestamp
        hash.put "charset", "UTF-8"
        hash.put "format", "JSON"
        hash.put "price", price

        result_str = @http_util.processHTTP hash, data[:authorize_url]
        result_str = result_str.replace(",", "&").replace(":", "=").replace("\"", "").replace(" ","").replace("\n", "").replace("}", "").replace("{", "")
        result_map = parse_util.parseStringToMap result_str

        if result_map.get("resultCode") == "0000"
          check_map = @hash_table.new
          check_map.put "mid", data[:mid]
          check_map.put "authToken", data[:token]
          check_map.put "signature", signature
          check_map.put "timestamp", @signature_util.getTimestamp
          check_map.put "applDate", result_map.get("applDate")
          check_map.put "applTime", result_map.get("applTime")
          check_map.put "charset", "UTF-8"
          check_map.put "format", "JSON"

          ack_result_str = @http_util.processHTTP checkMap, data[:ack_url]
          ack_map = @hash_map.new
          ackMap = @parse_util.parseStringToMap ack_result_str

          return map_to_hash result_map
        end

        nil
      end

      def self.map_to_hash map
         Hash[map.toString[1..-2].split(",").collect{|x| x.strip.split("=")}]
      end
    end
  end
end
