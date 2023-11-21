local function var_0_0(arg_1_0, arg_1_1)
	if type(arg_1_0) ~= type(arg_1_1) then
		return false, "difference type"
	end
	
	if type(arg_1_0) == "table" then
		for iter_1_0, iter_1_1 in pairs(arg_1_0) do
			if not var_0_0(iter_1_1, arg_1_1[iter_1_0]) then
				return false, "difference base client"
			end
		end
		
		for iter_1_2, iter_1_3 in pairs(arg_1_1) do
			if not var_0_0(iter_1_3, arg_1_0[iter_1_2]) then
				return false, "difference base server"
			end
		end
		
		return true
	else
		return arg_1_0 == arg_1_1
	end
end

VerifySpec[VSE.status].proc = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0, var_2_1, var_2_2, var_2_3, var_2_4, var_2_5, var_2_6 = table.unpack(arg_2_2)
	local var_2_7 = getRandom(var_2_0)
	local var_2_8 = false
	local var_2_9 = false
	local var_2_10 = false
	local var_2_11 = 0
	local var_2_12 = 0
	local var_2_13 = 0
	
	if var_2_3 then
		var_2_13 = FORMULA.weak_smite_rate(var_2_1, var_2_2)
		var_2_12 = FORMULA.weak_cri_rate(var_2_1, var_2_2)
	end
	
	if var_2_4 then
		var_2_11 = FORMULA.weak_dodge_rate(var_2_1, var_2_2)
	end
	
	if not DEBUG.MOVIE_MODE and var_2_7:get() + var_2_11 > FORMULA.hit(var_2_1, var_2_2) then
		var_2_8 = true
	elseif DEBUG.TEST_CRITICAL then
		if type(DEBUG.TEST_CRITICAL) == "number" then
			var_2_9 = math.random() < DEBUG.TEST_CRITICAL
		else
			var_2_9 = true
		end
	elseif DEBUG.TEST_SMITE then
		var_2_10 = true
	elseif var_2_7:get() < var_2_1.cri - var_2_2.cri_res + var_2_12 and not var_2_5 then
		var_2_9 = true
	elseif var_2_7:get() < var_2_1.smite + var_2_13 and not var_2_6 then
		var_2_10 = true
	end
	
	local var_2_14 = arg_2_0:after(var_2_9, var_2_10, var_2_8, var_2_13, var_2_12, var_2_11)
	
	if VERIFY_LOCAL_TEST then
		Log.e("client result", table.print(arg_2_3))
		Log.e("server result", table.print(var_2_14))
	end
	
	return var_0_0(arg_2_3, var_2_14)
end
VerifySpec[VSE.deal].proc = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = {
		atk_result = {}
	}
	
	return var_0_0(arg_3_3, var_3_0)
end
