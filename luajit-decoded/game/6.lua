PlistParser = PlistParser or {}

function PlistParser._nextTag(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0, var_1_1, var_1_2, var_1_3, var_1_4 = string.find(arg_1_1, "<(%/?)([%w%s?]+)(%/?)>", arg_1_2)
	local var_1_5 = string.trim(var_1_3)
	
	return var_1_0, var_1_1, var_1_2, var_1_5, var_1_4
end

function PlistParser._array(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {}
	local var_2_1
	local var_2_2
	local var_2_3
	local var_2_4
	local var_2_5
	
	while true do
		local var_2_6, var_2_7, var_2_8, var_2_9, var_2_10 = arg_2_0:_nextTag(arg_2_1, arg_2_2)
		local var_2_11 = var_2_10
		local var_2_12 = var_2_9
		local var_2_13 = var_2_8
		local var_2_14 = var_2_7
		
		if not var_2_6 then
			return {}
		end
		
		if var_2_13 == "" then
			if var_2_11 == "/" then
				if var_2_12 == "dict" or var_2_12 == "array" then
					var_2_0[#var_2_0 + 1] = {}
				else
					var_2_0[#var_2_0 + 1] = var_2_12 == "true" and true or false
				end
			elseif var_2_12 == "array" then
				var_2_0[#var_2_0 + 1], arg_2_2, var_2_14 = arg_2_0:_array(arg_2_1, var_2_14 + 1)
			elseif var_2_12 == "dict" then
				var_2_0[#var_2_0 + 1], arg_2_2, var_2_14 = arg_2_0:_dictionary(arg_2_1, var_2_14 + 1)
			else
				arg_2_2 = var_2_14 + 1
				
				local var_2_15, var_2_16
				
				var_2_15, var_2_14, var_2_13, var_2_12, var_2_16 = arg_2_0:_nextTag(arg_2_1, arg_2_2)
				
				local var_2_17 = string.sub(arg_2_1, arg_2_2, var_2_15 - 1)
				
				if var_2_12 == "integer" or var_2_12 == "real" then
					var_2_0[#var_2_0 + 1] = tonumber(var_2_17)
				else
					var_2_0[#var_2_0 + 1] = var_2_17
				end
			end
		elseif var_2_13 == "/" then
			if var_2_12 ~= "array" then
				return {}
			end
			
			return var_2_0, var_2_14 + 1, var_2_14
		end
		
		arg_2_2 = var_2_14 + 1
	end
end

function PlistParser._dictionary(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {}
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4
	local var_3_5
	
	while true do
		local var_3_6, var_3_7, var_3_8, var_3_9, var_3_10 = arg_3_0:_nextTag(arg_3_1, arg_3_2)
		local var_3_11 = var_3_10
		local var_3_12 = var_3_9
		local var_3_13 = var_3_8
		local var_3_14 = var_3_7
		
		if not var_3_6 then
			return {}
		end
		
		if var_3_13 == "" then
			if var_3_12 == "key" then
				arg_3_2 = var_3_14 + 1
				
				local var_3_15, var_3_16
				
				var_3_15, var_3_14, var_3_13, var_3_12, var_3_16 = arg_3_0:_nextTag(arg_3_1, arg_3_2)
				
				if var_3_13 ~= "/" or var_3_12 ~= "key" then
					return {}
				end
				
				local var_3_17 = string.sub(arg_3_1, arg_3_2, var_3_15 - 1)
				
				arg_3_2 = var_3_14 + 1
				
				local var_3_18, var_3_19
				
				var_3_18, var_3_14, var_3_13, var_3_12, var_3_19 = arg_3_0:_nextTag(arg_3_1, arg_3_2)
				
				if var_3_19 == "/" then
					if var_3_12 == "dict" or var_3_12 == "array" then
						var_3_0[var_3_17] = {}
					else
						var_3_0[var_3_17] = var_3_12 == "true" and true or false
					end
				elseif var_3_12 == "dict" then
					var_3_0[var_3_17], arg_3_2, var_3_14 = arg_3_0:_dictionary(arg_3_1, var_3_14 + 1)
				elseif var_3_12 == "array" then
					var_3_0[var_3_17], arg_3_2, var_3_14 = arg_3_0:_array(arg_3_1, var_3_14 + 1)
				else
					arg_3_2 = var_3_14 + 1
					
					local var_3_20, var_3_21
					
					var_3_20, var_3_14, var_3_13, var_3_12, var_3_21 = arg_3_0:_nextTag(arg_3_1, arg_3_2)
					
					local var_3_22 = string.sub(arg_3_1, arg_3_2, var_3_20 - 1)
					
					if var_3_12 == "integer" or var_3_12 == "real" then
						var_3_0[var_3_17] = tonumber(var_3_22)
					else
						var_3_0[var_3_17] = var_3_22
					end
				end
			end
		elseif var_3_13 == "/" then
			if var_3_12 ~= "dict" then
				return {}
			end
			
			return var_3_0, var_3_14 + 1, var_3_14
		end
		
		arg_3_2 = var_3_14 + 1
	end
end

function PlistParser.parse_plist(arg_4_0, arg_4_1)
	local var_4_0 = 0
	local var_4_1 = 0
	local var_4_2
	local var_4_3
	local var_4_4
	local var_4_5
	
	while var_4_2 ~= "plist" do
		local var_4_6, var_4_7, var_4_8, var_4_9 = string.find(arg_4_1, "<([%w]+)(.-)>", var_4_1 + 1)
		local var_4_10 = var_4_9
		
		var_4_2 = var_4_8
		var_4_1 = var_4_7
		
		if not var_4_6 then
			return {}
		end
	end
	
	local var_4_11, var_4_12, var_4_13, var_4_14, var_4_15 = arg_4_0:_nextTag(arg_4_1, var_4_1)
	
	if var_4_15 == "/" then
		return {}
	elseif var_4_14 == "dict" then
		return arg_4_0:_dictionary(arg_4_1, var_4_12 + 1)
	elseif var_4_14 == "array" then
		return arg_4_0:_array(arg_4_1, var_4_12 + 1)
	end
end
