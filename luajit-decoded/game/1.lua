local var_0_0 = os.getenv("OS")

if var_0_0 and var_0_0:lower():match("window") then
	local function var_0_1()
		return string.split(string.split(debug.traceback("", 2), "\n")[4], " ")[2]
	end
	
	local var_0_2 = getmetatable(_G)
	
	if var_0_2 == nil then
		var_0_2 = {}
		
		setmetatable(_G, var_0_2)
	end
	
	if __STRICT == nil then
		__STRICT = true
	end
	
	var_0_2.__declared = {}
	
	function var_0_2.__newindex(arg_2_0, arg_2_1, arg_2_2)
		if __STRICT and not var_0_2.__declared[arg_2_1] then
			local var_2_0 = debug.getinfo(2, "S")
			
			if var_2_0 then
				local var_2_1 = var_2_0.what
				
				if var_2_1 ~= "main" and var_2_1 ~= "C" then
					print(var_0_1() .. " variable " .. arg_2_1 .. " is not declared")
				end
				
				var_0_2.__declared[arg_2_1] = true
			end
		end
		
		rawset(arg_2_0, arg_2_1, arg_2_2)
	end
	
	function var_0_2.__index(arg_3_0, arg_3_1)
		if __STRICT and not var_0_2.__declared[arg_3_1] and debug.getinfo(2, "S").what ~= "C" then
			print(var_0_1() .. " variable " .. arg_3_1 .. " is not declared")
		end
		
		return rawget(arg_3_0, arg_3_1)
	end
	
	function global(...)
		for iter_4_0, iter_4_1 in ipairs({
			...
		}) do
			var_0_2.__declared[iter_4_1] = true
		end
	end
end
