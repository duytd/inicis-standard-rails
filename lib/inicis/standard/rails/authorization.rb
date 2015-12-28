$:.push(File.expand_path('../../../../../',__FILE__) + "/server/gen-rb")
$:.unshift "./rb/lib"

require "thrift"
require "inicis"
require "json"

module Inicis
  module Standard
    module Rails
      class Authorization
        def authorize data
          @logger ||= Logger.new "#{::Rails.root}/log/inicis/pc.log"

          begin
            transport = Thrift::BufferedTransport.new Thrift::HTTPClientTransport.new(Inicis::Standard::Rails.configuration.thrift_server)
            protocol = Thrift::BinaryProtocol.new transport
            client = Inicis::Client.new protocol
            transport.open

            timestamp = client.getTimestamp
            signature = client.makePaymentAproveSignature data[:token], timestamp

            hash = {
              "mid" => data[:mid],
              "authToken" => data[:token],
              "signature" => signature,
              "timestamp" => timestamp,
              "charset" => "UTF-8",
              "format" => "JSON"
            }

            result_str = client.getAuthenticationResult hash, data[:authorize_url]

            @logger.debug result_str

            if result_str != "http_connect_error"
              result_hash = JSON.parse result_str

              if result_hash["resultCode"] == "0000"
                check_hash = {
                  "mid" => result_hash["mid"],
                  "tid" => result_hash["tid"],
                  "applDate" => result_hash["applDate"],
                  "applTime" => result_hash["applTime"],
                  "price" => result_hash["TotPrice"],
                  "goodsName" => result_hash["goodsName"],
                  "charset" => "UTF-8",
                  "format" => "JSON"
                }

                @logger.info "Payment is authorized successfully"

                ack_result_str = client.getAuthenticationResult check_hash, data[:ack_url]
                ackMap = JSON.parse ack_result_str

                transport.close

                return result_hash
              else
                @logger.info "Failed to authorize payment. Code: #{result_hash['resultCode']}. Message: #{result_hash['resultMsg']}"
              end
            end

          rescue Thrift::Exception => tx
            print "Thrift::Exception: ", tx.message, "\n"
          end

          nil
        end
      end
    end
  end
end
