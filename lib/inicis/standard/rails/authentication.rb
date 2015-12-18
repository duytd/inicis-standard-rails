$:.push(File.expand_path('../../../../../',__FILE__) + "/server/gen-rb")
$:.unshift "./rb/lib"

require "thrift"
require "inicis"
require "json"

module Inicis
  module Standard
    module Rails
      class Authentication
        def approve data
          @logger ||= Logger.new "#{::Rails.root}/log/inicis.log"

          begin
            transport = Thrift::BufferedTransport.new Thrift::HTTPClientTransport.new(Inicis::Standard::Rails.configuration.thrift_server)
            protocol = Thrift::BinaryProtocol.new transport
            client = Inicis::Client.new protocol
            transport.open

            timestamp = client.getTimestamp
            signature = client.makePaymentAproveSignature data[:token], timestamp

            hash = {
              "mid" => "INIpayTest",
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
                  "mid" => data[:mid],
                  "authToken" => data[:token],
                  "signature" => signature,
                  "timestamp" => client.getTimestamp,
                  "applDate" => result_hash[:applDate],
                  "applTime" => result_hash[:applTime],
                  "charset" => "UTF-8",
                  "format" => "JSON"
                }

                ack_result_str = client.getAuthenticationResult check_hash, data[:ack_url]
                ackMap = JSON.parse ack_result_str

                transport.close

                return result_hash
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
