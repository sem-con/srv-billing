module Api
    module V1
        class PaymentsController < ApiController
        	include PriceHelper
        	
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            # curl http://localhost:4900/api/payment_info
            def info
            	# get address from private key
            	key = Eth::Key.new priv: ENV["PRIVATEKEY_ETHER"].to_s
            	adr = key.address

            	# extract pubkey from private key
            	fpr = GPGME::Key.find(:public, ENV["EMAIL"]).first.subkeys.first.fingerprint

            	retVal = {
            		"address": adr.to_s,
            		"email": ENV["EMAIL"].to_s,
            		"pubkey-id": fpr.to_s
            	}.stringify_keys

                render json: retVal, 
                       status: 200
            end

            # curl -H "Content-Type: application/json" -d '{"request":"station=20202","usage-policy":"none","method":"Ether"}' -X POST http://localhost:4900/api/price
            def price
            	request_string = params[:request].to_s
            	usage_policy = params["usage-policy"].to_s
            	payment_method = params[:method].to_s

            	cost = calc_price(request_string, usage_policy, payment_method)

            	render json: { "price": cost.to_s },
            		   status: 200
            end
        end
    end
end