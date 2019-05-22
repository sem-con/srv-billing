module Api
    module V1
        class BlockchainsController < ApiController
            def transaction
                tx = params[:tx].to_s

                # query transaction via Etherscan.io
                query_url = "https://api.etherscan.io/api?module=proxy&action=eth_getTransactionByHash"
                query_url += "&txhash=" + tx 
                query_url += "&apikey=" + ENV["ETHERSCAN_APIKEY"].to_s
                response = HTTParty.get(query_url).parsed_response rescue nil
                if response.nil?
                    render json: {"error": "failed to query transaction hash"},
                           status: 500
                    return
                end

                response = response["result"] rescue nil
                if response.nil?
                    render json: {"error": "failed to parse transaction response"},
                           status: 500
                    return
                end

                block = response["blockNumber"].to_i(16) rescue nil
                if block.nil?
                    render json: {"error": "failed to parse block"},
                           status: 500
                    return
                end

                query_url = "https://api.etherscan.io/api?module=block&action=getblockreward"
                query_url += "&blockno=" + block.to_s 
                query_url += "&apikey=" + ENV["ETHERSCAN_APIKEY"].to_s
                block_response = HTTParty.get(query_url).parsed_response rescue nil
                if block_response.nil?
                    render json: {"error": "failed to query block"},
                           status: 500
                    return
                end

                block_response = block_response["result"] rescue nil
                if block_response.nil?
                    render json: {"error": "failed to parse block response"},
                           status: 500
                    return
                end
                ts = block_response["timeStamp"].to_i rescue nil
                if ts.nil?
                    render json: {"error": "failed to read timestamp"},
                           status: 500
                    return
                end

                if response["input"].to_s[0..1] == "0x"
                    input_string = response["input"].to_s
                else
                    input_string = `node script/input2hex.js #{response["input"].to_s}`.strip
                end
                val = response["value"].to_s[2..-1].to_i(16)/1e18 rescue 0.0

                retVal = {
                    "from": response["from"].to_s,
                    "to": response["to"].to_s,
                    "timestamp": ts.to_i,
                    "input": input_string,
                    "value": val
                }.stringify_keys
                render json: retVal, 
                       status: 200

            end
        end
    end
end
