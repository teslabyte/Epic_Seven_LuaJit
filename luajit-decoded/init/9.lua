if not jit then
	if not math.old_min then
		math.old_min = math.min
		
		function math.min(...)
			local var_1_0 = {
				...
			}
			local var_1_1 = tonumber(var_1_0[1])
			
			for iter_1_0, iter_1_1 in pairs(var_1_0) do
				local var_1_2 = tonumber(iter_1_1)
				
				if var_1_2 < var_1_1 then
					var_1_1 = var_1_2
				end
			end
			
			return var_1_1
		end
	end
	
	if not math.old_max then
		math.old_max = math.max
		
		function math.max(...)
			local var_2_0 = {
				...
			}
			local var_2_1 = tonumber(var_2_0[1])
			
			for iter_2_0, iter_2_1 in pairs(var_2_0) do
				local var_2_2 = tonumber(iter_2_1)
				
				if var_2_1 < var_2_2 then
					var_2_1 = var_2_2
				end
			end
			
			return var_2_1
		end
	end
	
	function json.encode(...)
		local var_3_0 = {
			...
		}
		local var_3_1 = 0
		local var_3_2 = 0
		
		for iter_3_0, iter_3_1 in ipairs(var_3_0) do
			var_3_2 = var_3_2 + 1
		end
		
		for iter_3_2, iter_3_3 in pairs(var_3_0) do
			var_3_1 = var_3_1 + 1
		end
		
		local var_3_3, var_3_4
		
		if var_3_2 ~= var_3_1 then
			var_3_3 = 0
			var_3_4 = {}
			
			for iter_3_4, iter_3_5 in pairs(var_3_0) do
				var_3_4[iter_3_4] = iter_3_5
			end
			
			for iter_3_6 = 1, table.maxn(var_3_4) do
				if var_3_3 > 7 then
					local var_3_5 = {}
					
					if not PRODUCTION_MODE then
						Log.e("--Json Encode Warnning--")
						print("--Json Encode Warnning--")
						print("* wrong Json Array, too many empty elements!")
						print("* Don't Use UID for json key type, Casting First!")
						print(debug.traceback())
						print("------------------------")
					end
					
					for iter_3_7, iter_3_8 in pairs(var_3_0) do
						if type(iter_3_7) == "number" then
							var_3_5[tostring(iter_3_7)] = iter_3_8
						else
							var_3_5[iter_3_7] = iter_3_8
						end
					end
					
					local var_3_6, var_3_7 = pcall(cjson.encode, table.unpack(var_3_5))
					
					if var_3_6 then
						return var_3_7
					end
					
					return 
				end
				
				if not var_3_4[iter_3_6] then
					var_3_3 = var_3_3 + 1
					var_3_4[iter_3_6] = nil
				else
					var_3_3 = 0
				end
				
				if iter_3_6 == table.maxn(var_3_4) then
					local var_3_8, var_3_9 = pcall(cjson.encode, table.unpack(var_3_4))
					
					if var_3_8 then
						return var_3_9
					end
					
					return 
				end
			end
		end
		
		local var_3_10, var_3_11 = pcall(cjson.encode, ...)
		
		if var_3_10 then
			return var_3_11
		end
	end
	
	function json.decode(...)
		local var_4_0, var_4_1 = pcall(cjson.decode, ...)
		
		if var_4_0 then
			return var_4_1
		end
	end
	
	setfenv = setfenv or function(arg_5_0, arg_5_1)
		local var_5_0 = 1
		
		while true do
			local var_5_1 = debug.getupvalue(arg_5_0, var_5_0)
			
			if var_5_1 == "_ENV" then
				debug.upvaluejoin(arg_5_0, var_5_0, function()
					return arg_5_1
				end, 1)
				
				break
			elseif not var_5_1 then
				break
			end
			
			var_5_0 = var_5_0 + 1
		end
		
		return arg_5_0
	end
	getfenv = getfenv or function(arg_7_0)
		local var_7_0 = 1
		
		while true do
			local var_7_1, var_7_2 = debug.getupvalue(arg_7_0, var_7_0)
			
			if var_7_1 == "_ENV" then
				return var_7_2
			elseif not var_7_1 then
				break
			end
			
			var_7_0 = var_7_0 + 1
		end
	end
end
