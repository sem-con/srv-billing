module PriceHelper
    def calc_price(request, up, payment_method)
    	return true, Time.now+30.days, 0.001, "info" 
   	end
end
