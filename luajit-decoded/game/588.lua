ShopBuyAge = ShopBuyAge or {}
ShopBuyAge.vars = {}
ShopBuyAge.onSelectDate = Delegate.new()

function ShopBuyAge.getFromToYear(arg_1_0)
	local var_1_0 = os.date("*t", os.time())
	
	return var_1_0.year - 80, var_1_0.year - 13
end

function ShopBuyAge.getDefaultYear(arg_2_0)
	return os.date("*t", os.time()).year - 22
end

function ShopBuyAge.getDate(arg_3_0)
	return arg_3_0:getYear(), arg_3_0:getMonth(), arg_3_0:getDay()
end

function ShopBuyAge.getYear(arg_4_0)
	return arg_4_0.vars.year or arg_4_0:getDefaultYear()
end

function ShopBuyAge.getMonth(arg_5_0)
	return arg_5_0.vars.month or 1
end

function ShopBuyAge.getDay(arg_6_0)
	return arg_6_0.vars.day or 1
end

function ShopBuyAge.setYear(arg_7_0, arg_7_1)
	arg_7_0.vars.year = arg_7_1
	
	ShopBuyAge.onSelectDate()
end

function ShopBuyAge.setMonth(arg_8_0, arg_8_1)
	arg_8_0.vars.month = arg_8_1
	
	ShopBuyAge.onSelectDate()
end

function ShopBuyAge.setDay(arg_9_0, arg_9_1)
	arg_9_0.vars.day = arg_9_1
	
	ShopBuyAge.onSelectDate()
end

function ShopBuyAge.getEndDay(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = false
	
	if arg_10_1 % 400 == 0 then
		var_10_0 = true
	elseif arg_10_1 % 100 == 0 then
	elseif arg_10_1 % 4 == 0 then
		var_10_0 = true
	end
	
	return ({
		31,
		var_10_0 and 29 or 28,
		31,
		30,
		31,
		30,
		31,
		31,
		30,
		31,
		30,
		31
	})[arg_10_2]
end

function ShopBuyAge.isValidDate(arg_11_0)
	return arg_11_0:getDay() <= arg_11_0:getEndDay(arg_11_0:getYear(), arg_11_0:getMonth())
end
