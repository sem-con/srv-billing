module Api
    module V1
        class PaymentsController < ApiController
        	include PriceHelper
        	
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            # curl http://localhost:4800/api/payment_info
            def info
            	# extract pubkey from private key
            	fpr = GPGME::Key.find(:public, ENV["EMAIL"]).first.subkeys.first.fingerprint

                if ENV["ETHER_ADDRESS"].to_s == ""
                    path_str = ENV["HDW_PATH"] + "/" + $address_counter.to_s
                    address = `node script/getAddress.js "#{ENV["HDW_SEED"].to_s}" "#{path_str}"`.strip
                    retVal = {
                        "address": address.to_s,
                        "path": path_str,
                        "email": ENV["EMAIL"].to_s,
                        "pubkey-id": fpr.to_s
                    }.stringify_keys
                else
                	retVal = {
                		"address": ENV["ETHER_ADDRESS"].to_s,
                		"email": ENV["EMAIL"].to_s,
                		"pubkey-id": fpr.to_s
                	}.stringify_keys
                end

                $address_counter += 1

                render json: retVal, 
                       status: 200
            end

            # curl -H "Content-Type: application/json" -d '{"request":"station=20202","usage-policy":"none","method":"Ether"}' -X POST http://localhost:4800/api/price
            def terms
            	request_string = params[:request].to_s
            	usage_policy = params["usage-policy"].to_s
            	payment_method = params[:method].to_s

            	valid, duration, cost, info = calc_price(request_string, usage_policy, payment_method)

            	render json: { "valid": valid,
                               "price": cost.to_s,
                               "offer-end": duration.to_i, 
                               "offer-info": info.to_s },
            		   status: 200
            end
        end
    end
end