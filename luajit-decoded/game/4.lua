if _VERSION == "Lua 5.3" then
	if not origin_setfenv then
		origin_setfenv = setfenv
	end
	
	function setfenv(arg_1_0, arg_1_1)
		local var_1_0 = 1
		
		while true do
			local var_1_1 = debug.getupvalue(arg_1_0, var_1_0)
			
			if var_1_1 == "_ENV" then
				debug.upvaluejoin(arg_1_0, var_1_0, function()
					return arg_1_1
				end, 1)
				
				break
			elseif not var_1_1 then
				break
			end
			
			var_1_0 = var_1_0 + 1
		end
		
		return arg_1_0
	end
	
	if not origin_getfenv then
		origin_getfenv = getfenv
	end
	
	function getfenv(arg_3_0)
		local var_3_0 = 1
		
		while true do
			local var_3_1, var_3_2 = debug.getupvalue(arg_3_0, var_3_0)
			
			if var_3_1 == "_ENV" then
				return var_3_2
			elseif not var_3_1 then
				break
			end
			
			var_3_0 = var_3_0 + 1
		end
	end
	
	function table.foreach(arg_4_0, arg_4_1)
		for iter_4_0, iter_4_1 in pairs(arg_4_0 or {}) do
			arg_4_1(iter_4_0, iter_4_1)
		end
	end
	
	if not math[":random"] then
		math[":random"] = math.random
		
		function math.random(arg_5_0, arg_5_1)
			if arg_5_0 == nil and arg_5_1 == nil then
				return math[":random"]()
			end
			
			local var_5_0 = arg_5_0
			local var_5_1 = arg_5_1
			
			if var_5_0 == var_5_1 then
				return var_5_0
			end
			
			var_5_0 = var_5_0 or 0
			var_5_1 = var_5_1 or 0
			
			if var_5_1 < var_5_0 then
				var_5_0, var_5_1 = var_5_1, var_5_0
			end
			
			return math[":random"](math.floor(var_5_0), math.floor(var_5_1))
		end
	end
end

function argument_unpack(arg_6_0)
	if not arg_6_0 then
		return 
	end
	
	return unpack(arg_6_0, 1, table.maxn(arg_6_0))
end

function bind_func(arg_7_0, ...)
	local var_7_0 = {
		["-func"] = arg_7_0,
		["-args"] = {
			...
		}
	}
	
	setmetatable(var_7_0, {
		__call = function(arg_8_0)
			arg_8_0["-func"](argument_unpack(arg_8_0["-args"]))
		end
	})
	
	return var_7_0
end

function table_func(arg_9_0, arg_9_1)
	local var_9_0 = {
		["-func"] = f,
		["-self"] = arg_9_0
	}
	
	setmetatable(var_9_0, {
		__call = function(arg_10_0, ...)
			arg_10_0["-func"](arg_10_0["-self"], ...)
		end
	})
	
	return var_9_0
end

function tableFormatStrToTable(arg_11_0)
	if tolua.type(arg_11_0) ~= "string" then
		Log.e("string to table", "src 의 타입은 string 이어야 합니다. type: " .. tolua.type(arg_11_0))
		
		return nil
	end
	
	local var_11_0, var_11_1 = loadstring("return " .. arg_11_0)
	
	if var_11_1 ~= nil then
		Log.e("string to table", var_11_1, arg_11_0)
		
		return nil
	end
	
	return var_11_0()
end

function totable(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {}
	local var_12_1 = string.split(arg_12_0, arg_12_2 or ",")
	
	for iter_12_0, iter_12_1 in pairs(var_12_1) do
		local var_12_2 = string.split(iter_12_1, arg_12_1 or "=")
		local var_12_3 = string.trim(var_12_2[1])
		local var_12_4 = string.trim(var_12_2[2] or "")
		
		if string.find(var_12_4, ";") then
			var_12_0[var_12_3] = {}
			
			local var_12_5 = string.split(var_12_4, ";")
			
			for iter_12_2, iter_12_3 in pairs(var_12_5) do
				table.insert(var_12_0[var_12_3], iter_12_3)
			end
		else
			var_12_0[var_12_3] = var_12_4
		end
	end
	
	return var_12_0
end

local var_0_0 = {
	__call = function(arg_13_0, ...)
		local var_13_0 = {}
		local var_13_1 = {}
		local var_13_2 = arg_13_0
		
		while var_13_2 do
			copy_functions(var_13_2, var_13_0, true)
			
			if var_13_2.constructor then
				table.insert(var_13_1, 1, var_13_2.constructor)
			end
			
			var_13_2 = var_13_2.__inherited
		end
		
		var_13_0["--class"] = arg_13_0
		
		for iter_13_0, iter_13_1 in pairs(var_13_1) do
			if iter_13_1(var_13_0, ...) == false then
				return 
			end
		end
		
		return var_13_0
	end
}

function is_class_table(arg_14_0, arg_14_1)
	if not arg_14_0 or not arg_14_1 then
		return false
	end
	
	local var_14_0 = arg_14_0["--class"]
	
	while var_14_0 do
		if var_14_0 == arg_14_1 then
			return true
		end
		
		var_14_0 = var_14_0.__inherited
	end
end

function get_class_table(arg_15_0)
	return arg_15_0["--class"]
end

function ClassDef(arg_16_0)
	local var_16_0 = {
		__inherited = arg_16_0
	}
	
	setmetatable(var_16_0, var_0_0)
	
	return var_16_0
end

local function var_0_1(arg_17_0)
	if not arg_17_0 then
		return 0
	elseif arg_17_0 > 240 then
		return 4
	elseif arg_17_0 > 225 then
		return 3
	elseif arg_17_0 > 192 then
		return 2
	else
		return 1
	end
end

local function var_0_2(arg_18_0, arg_18_1)
	local var_18_0 = string.byte
	
	arg_18_1 = arg_18_1 or 1
	
	if type(arg_18_0) ~= "string" then
		error("bad argument #1 to 'utf8charbytes' (string expected, got " .. type(arg_18_0) .. ")")
	end
	
	if type(arg_18_1) ~= "number" then
		error("bad argument #2 to 'utf8charbytes' (number expected, got " .. type(arg_18_1) .. ")")
	end
	
	local var_18_1 = var_18_0(arg_18_0, arg_18_1)
	
	if var_18_1 > 0 and var_18_1 <= 127 then
		return 1
	elseif var_18_1 >= 194 and var_18_1 <= 223 then
		local var_18_2 = var_18_0(arg_18_0, arg_18_1 + 1)
		
		if not var_18_2 then
			error("UTF-8 string terminated early")
		end
		
		if var_18_2 < 128 or var_18_2 > 191 then
			error("Invalid UTF-8 character")
		end
		
		return 2
	elseif var_18_1 >= 224 and var_18_1 <= 239 then
		local var_18_3 = var_18_0(arg_18_0, arg_18_1 + 1)
		local var_18_4 = var_18_0(arg_18_0, arg_18_1 + 2)
		
		if not var_18_3 or not var_18_4 then
			error("UTF-8 string terminated early")
		end
		
		if var_18_1 == 224 and (var_18_3 < 160 or var_18_3 > 191) then
			error("Invalid UTF-8 character")
		elseif var_18_1 == 237 and (var_18_3 < 128 or var_18_3 > 159) then
			error("Invalid UTF-8 character")
		elseif var_18_3 < 128 or var_18_3 > 191 then
			error("Invalid UTF-8 character")
		end
		
		if var_18_4 < 128 or var_18_4 > 191 then
			error("Invalid UTF-8 character")
		end
		
		return 3
	elseif var_18_1 >= 240 and var_18_1 <= 244 then
		local var_18_5 = var_18_0(arg_18_0, arg_18_1 + 1)
		local var_18_6 = var_18_0(arg_18_0, arg_18_1 + 2)
		local var_18_7 = var_18_0(arg_18_0, arg_18_1 + 3)
		
		if not var_18_5 or not var_18_6 or not var_18_7 then
			error("UTF-8 string terminated early")
		end
		
		if var_18_1 == 240 and (var_18_5 < 144 or var_18_5 > 191) then
			error("Invalid UTF-8 character")
		elseif var_18_1 == 244 and (var_18_5 < 128 or var_18_5 > 143) then
			error("Invalid UTF-8 character")
		elseif var_18_5 < 128 or var_18_5 > 191 then
			error("Invalid UTF-8 character")
		end
		
		if var_18_6 < 128 or var_18_6 > 191 then
			error("Invalid UTF-8 character")
		end
		
		if var_18_7 < 128 or var_18_7 > 191 then
			error("Invalid UTF-8 character")
		end
		
		return 4
	else
		error("Invalid UTF-8 character")
	end
end

function utf8len(arg_19_0)
	if type(arg_19_0) ~= "string" then
		for iter_19_0, iter_19_1 in pairs(arg_19_0) do
			print("\"", tostring(iter_19_0), "\"", tostring(iter_19_1), "\"")
		end
		
		error("bad argument #1 to 'utf8len' (string expected, got " .. type(arg_19_0) .. ")")
	end
	
	local var_19_0 = 1
	local var_19_1 = string.len(arg_19_0)
	local var_19_2 = 0
	
	while var_19_0 <= var_19_1 do
		var_19_2 = var_19_2 + 1
		var_19_0 = var_19_0 + var_0_2(arg_19_0, var_19_0)
	end
	
	return var_19_2
end

function utf8sub(arg_20_0, arg_20_1, arg_20_2)
	arg_20_2 = arg_20_2 or -1
	
	local var_20_0 = 1
	local var_20_1 = string.len(arg_20_0)
	local var_20_2 = 0
	local var_20_3 = arg_20_1 >= 0 and arg_20_2 >= 0 or utf8len(arg_20_0)
	local var_20_4 = arg_20_1 >= 0 and arg_20_1 or var_20_3 + arg_20_1 + 1
	local var_20_5 = arg_20_2 >= 0 and arg_20_2 or var_20_3 + arg_20_2 + 1
	
	if var_20_5 < var_20_4 then
		return ""
	end
	
	local var_20_6 = 1
	local var_20_7 = var_20_1
	
	while var_20_0 <= var_20_1 do
		var_20_2 = var_20_2 + 1
		
		if var_20_2 == var_20_4 then
			var_20_6 = var_20_0
		end
		
		var_20_0 = var_20_0 + var_0_2(arg_20_0, var_20_0)
		
		if var_20_2 == var_20_5 then
			var_20_7 = var_20_0 - 1
			
			break
		end
	end
	
	if var_20_2 < var_20_4 then
		var_20_6 = var_20_1 + 1
	end
	
	if var_20_5 < 1 then
		var_20_7 = 0
	end
	
	return string.sub(arg_20_0, var_20_6, var_20_7)
end

function utf8Validator(arg_21_0)
	local var_21_0 = 1
	local var_21_1 = #arg_21_0
	
	while var_21_0 <= var_21_1 do
		if var_21_0 == string.find(arg_21_0, "[%z\x01-\x7F]", var_21_0) then
			var_21_0 = var_21_0 + 1
		elseif var_21_0 == string.find(arg_21_0, "[\xC2-\xDF][\x80-\xBF]", var_21_0) then
			var_21_0 = var_21_0 + 2
		elseif var_21_0 == string.find(arg_21_0, "\xE0[\xA0-\xBF][\x80-\xBF]", var_21_0) or var_21_0 == string.find(arg_21_0, "[\xE1-\xEC][\x80-\xBF][\x80-\xBF]", var_21_0) or var_21_0 == string.find(arg_21_0, "\xED[\x80-\x9F][\x80-\xBF]", var_21_0) or var_21_0 == string.find(arg_21_0, "[\xEE-\xEF][\x80-\xBF][\x80-\xBF]", var_21_0) then
			var_21_0 = var_21_0 + 3
		elseif var_21_0 == string.find(arg_21_0, "\xF0[\x90-\xBF][\x80-\xBF][\x80-\xBF]", var_21_0) or var_21_0 == string.find(arg_21_0, "[\xF1-\xF3][\x80-\xBF][\x80-\xBF][\x80-\xBF]", var_21_0) or var_21_0 == string.find(arg_21_0, "\xF4[\x80-\x8F][\x80-\xBF][\x80-\xBF]", var_21_0) then
			var_21_0 = var_21_0 + 4
		else
			return false, var_21_0
		end
	end
	
	return true
end

local var_0_3 = {
	["í"] = "i0",
	["Ö"] = "O4",
	["ù"] = "u0",
	["Î"] = "I2",
	["Ï"] = "I3",
	["È"] = "E0",
	["Ô"] = "O2",
	["à"] = "a0",
	["ì"] = "i1",
	["ë"] = "e3",
	["ã"] = "a3",
	["Á"] = "A1",
	["î"] = "i2",
	["ï"] = "i3",
	["Ò"] = "O0",
	["ú"] = "u1",
	["Ç"] = "C0",
	["Ó"] = "O1",
	["ê"] = "e2",
	["Ñ"] = "N5",
	["û"] = "u2",
	["é"] = "e1",
	["ò"] = "o0",
	["õ"] = "o3",
	["ó"] = "o1",
	["ö"] = "o4",
	["Ä"] = "A4",
	["ñ"] = "n0",
	["Ü"] = "U3",
	["è"] = "e0",
	["ô"] = "o2",
	["ç"] = "c0",
	["Â"] = "A2",
	["Ã"] = "A3",
	["Ú"] = "U1",
	["Û"] = "U2",
	["Í"] = "I0",
	["Ù"] = "U0",
	["À"] = "A0",
	["Ì"] = "I1",
	["ä"] = "a4",
	["ü"] = "u3",
	["Ê"] = "E2",
	["Ë"] = "E3",
	["â"] = "a2",
	["É"] = "E1",
	["Õ"] = "O3",
	["á"] = "a1"
}

function utf8LatinAccentCompare(arg_22_0, arg_22_1)
	local var_22_0 = utf8len(arg_22_0)
	local var_22_1 = utf8len(arg_22_1)
	local var_22_2 = math.min(var_22_0, var_22_1)
	
	for iter_22_0 = 1, var_22_2 do
		local var_22_3 = utf8sub(arg_22_0, iter_22_0, iter_22_0)
		local var_22_4 = string.lower(var_0_3[var_22_3] or var_22_3)
		local var_22_5 = utf8sub(arg_22_1, iter_22_0, iter_22_0)
		local var_22_6 = string.lower(var_0_3[var_22_5] or var_22_5)
		
		if var_22_4 ~= var_22_6 then
			return var_22_4 < var_22_6
		end
	end
	
	return var_22_0 < var_22_1
end

RANDOM_FLOAT_PRECISION = 1000000

function getRandom(arg_23_0, arg_23_1)
	local var_23_0
	local var_23_1
	local var_23_2
	
	if type(arg_23_0) == "string" then
		var_23_1 = arg_23_0
	else
		var_23_2 = tonumber(arg_23_0)
	end
	
	if var_23_1 then
		var_23_0 = json.decode(var_23_1)
	else
		var_23_0 = {}
		
		if var_23_2 then
			var_23_0.X1, var_23_0.X2 = var_23_2, var_23_2 + 1
		else
			var_23_0.X1, var_23_0.X2 = 0, 1
		end
	end
	
	var_23_0.name = arg_23_1
	
	function var_23_0.clone(arg_24_0)
		local var_24_0 = {}
		
		for iter_24_0, iter_24_1 in pairs(arg_24_0) do
			var_24_0[iter_24_0] = iter_24_1
		end
		
		var_24_0["-clone"] = true
		
		return var_24_0
	end
	
	function var_23_0.shuffleSeed(arg_25_0)
		arg_25_0:get(1, 1)
	end
	
	function var_23_0.get(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
		if arg_26_1 and arg_26_2 and (arg_26_1 - math.floor(arg_26_1) > 1 / RANDOM_FLOAT_PRECISION or arg_26_2 - math.floor(arg_26_2) > 1 / RANDOM_FLOAT_PRECISION) then
			return arg_26_0:get(math.floor(arg_26_1 * RANDOM_FLOAT_PRECISION), math.floor(arg_26_2 * RANDOM_FLOAT_PRECISION), arg_26_3) / RANDOM_FLOAT_PRECISION
		end
		
		local var_26_0 = arg_26_0.X1
		local var_26_1 = arg_26_0.X2
		local var_26_2 = 727595
		local var_26_3 = 798405
		local var_26_4 = 1048576
		local var_26_5 = 1099511627776
		local var_26_6 = arg_26_0.X2 * var_26_3
		local var_26_7 = ((arg_26_0.X1 * var_26_3 + arg_26_0.X2 * var_26_2) % var_26_4 * var_26_4 + var_26_6) % var_26_5
		
		arg_26_0.X1 = math.floor(var_26_7 / var_26_4)
		arg_26_0.X2 = var_26_7 - arg_26_0.X1 * var_26_4
		
		local var_26_8 = var_26_7 / var_26_5
		
		if arg_26_3 then
			arg_26_0.X1 = var_26_0 or arg_26_0.X1
			arg_26_0.X2 = var_26_1 or arg_26_0.X2
		else
			if not arg_26_0.cnt then
				arg_26_0.cnt = 0
			end
			
			arg_26_0.cnt = arg_26_0.cnt + 1
		end
		
		if arg_26_2 == nil then
			return var_26_8
		end
		
		return math.floor(var_26_8 * (arg_26_2 - arg_26_1 + 1)) + arg_26_1
	end
	
	function var_23_0.encode(arg_27_0)
		return json.encode({
			X1 = arg_27_0.X1,
			X2 = arg_27_0.X2
		})
	end
	
	function var_23_0.shuffle(arg_28_0, arg_28_1)
		local var_28_0 = #arg_28_1
		
		for iter_28_0 = var_28_0, 1, -1 do
			local var_28_1 = arg_28_0:get(1, var_28_0)
			
			arg_28_1[iter_28_0], arg_28_1[var_28_1] = arg_28_1[var_28_1], arg_28_1[iter_28_0]
		end
		
		return arg_28_1
	end
	
	function var_23_0.pick(arg_29_0, arg_29_1, arg_29_2)
		local var_29_0 = 0
		
		for iter_29_0, iter_29_1 in ipairs(arg_29_1) do
			var_29_0 = var_29_0 + iter_29_1
		end
		
		local var_29_1 = arg_29_0:get(0, var_29_0 - 1, arg_29_2)
		
		for iter_29_2, iter_29_3 in ipairs(arg_29_1) do
			if var_29_1 < iter_29_3 then
				return iter_29_2
			end
			
			var_29_1 = var_29_1 - iter_29_3
		end
		
		return nil
	end
	
	return var_23_0
end

function __function()
	if PRODUCTION_MODE then
		return 
	end
	
	return debug.getinfo(2, "f").func
end

function __traceback(arg_31_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if arg_31_0 then
		print(arg_31_0, debug.traceback())
	else
		print(debug.traceback())
	end
end

function getNodePath(arg_32_0)
	local var_32_0 = arg_32_0:getName()
	
	if arg_32_0.guide_tag then
		var_32_0 = var_32_0 .. "[" .. arg_32_0.guide_tag .. "]"
	end
	
	local var_32_1 = var_32_0
	
	while arg_32_0:getParent() do
		arg_32_0 = arg_32_0:getParent()
		
		local var_32_2 = arg_32_0:getName()
		
		if arg_32_0.guide_tag then
			var_32_2 = var_32_2 .. "[" .. arg_32_0.guide_tag .. "]"
		end
		
		var_32_1 = var_32_2 .. "/" .. var_32_1
	end
	
	return var_32_1
end

local function var_0_4(arg_33_0)
	local var_33_0 = ""
	local var_33_1 = tolua.type(arg_33_0)
	
	if not arg_33_0.getName then
		var_33_0 = var_33_0 .. "type: " .. var_33_1
	elseif var_33_1:starts("cc") then
		var_33_0 = getNodePath(arg_33_0)
		var_33_0 = var_33_0 .. string.format(", \n\t\t\tpos: [%.1f, %.1f]", arg_33_0:getPosition())
		var_33_0 = var_33_0 .. string.format(", size: [%d, %d]", arg_33_0:getContentSize().width, arg_33_0:getContentSize().height)
		var_33_0 = var_33_0 .. string.format(", scale: [%.2f, %.2f], x_size: %.2f", arg_33_0:getScaleX(), arg_33_0:getScaleY(), arg_33_0:getContentSize().width * arg_33_0:getScaleX())
		var_33_0 = var_33_0 .. string.format(", anchor: [%.2f, %.2f]", arg_33_0:getAnchorPoint().x, arg_33_0:getAnchorPoint().y)
		var_33_0 = var_33_0 .. string.format(", " .. (arg_33_0:isVisible() and "visible" or "invisible"))
		var_33_0 = var_33_0 .. ", type: " .. var_33_1
		
		if var_33_1 == "ccui.Text" or var_33_1 == "ccui.RichText" then
			var_33_0 = var_33_0 .. string.format(": '%s'", arg_33_0:getString())
		end
		
		local var_33_2 = (function(arg_34_0)
			local var_34_0 = arg_34_0:getComponent("ComExtensionData")
			
			return var_34_0 and var_34_0:getCustomProperty() or nil
		end)(arg_33_0)
		
		if var_33_2 and var_33_2 ~= "" then
			var_33_0 = var_33_0 .. string.format(", userdata: %s", var_33_2)
		end
	else
		var_33_0 = getNodePath(arg_33_0)
		var_33_0 = var_33_0 .. ", type: " .. var_33_1
	end
	
	return var_33_0
end

function getNodeLog(arg_35_0)
	return var_0_4(arg_35_0)
end

local function var_0_5(arg_36_0)
	if arg_36_0 == nil then
		return "nil"
	end
	
	if type(arg_36_0) == "number" then
		return arg_36_0
	end
	
	if type(arg_36_0) == "string" then
		return "'" .. arg_36_0 .. "'"
	end
	
	if type(arg_36_0) == "userdata" then
		return var_0_4(arg_36_0)
	end
	
	if tolua.type(arg_36_0) == "boolean" then
		return arg_36_0 and "true" or "false"
	end
	
	if tolua.type(arg_36_0) == "table" then
		__line_depth = __line_depth or 4
		
		return table.to_json(arg_36_0, __line_depth)
	end
	
	return type(arg_36_0)
end

local function var_0_6()
	local var_37_0 = ""
	local var_37_1 = 1
	
	while true do
		local var_37_2, var_37_3 = debug.getlocal(3, var_37_1)
		
		if not var_37_2 then
			break
		end
		
		if var_37_2 ~= "self" then
			if tolua.type(var_37_3) == "table" then
				var_37_2 = "print.table(" .. var_37_2 .. ")"
			end
			
			var_37_0 = var_37_0 .. "\n\t" .. var_37_2 .. ":\t\t" .. var_0_5(var_37_3)
		end
		
		var_37_1 = var_37_1 + 1
	end
	
	return var_37_0
end

local function var_0_7(...)
	local var_38_0 = false
	local var_38_1 = ""
	
	for iter_38_0 = 1, select("#", ...) do
		local var_38_2 = select(iter_38_0, ...)
		
		if tolua.type(var_38_2) == "function" then
			var_38_0 = not var_38_2()
			
			if var_38_0 then
				break
			end
		else
			var_38_1 = iter_38_0 == 1 and "" or var_38_1 .. ", "
			var_38_1 = var_38_1 .. var_0_5(var_38_2)
		end
	end
	
	if var_38_0 then
		return nil, nil
	end
	
	local var_38_3 = debug.getinfo(3, "Snl")
	local var_38_4 = var_38_3.source or ""
	local var_38_5 = var_38_3.name or ""
	local var_38_6 = var_38_3.currentline or ""
	
	return "[LINE] " .. var_38_4 .. "@" .. var_38_5 .. "()L" .. var_38_6, var_38_1
end

function __userdataInfo(arg_39_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_39_0 = type(arg_39_0)
	
	if var_39_0 ~= "userdata" then
		if var_39_0 == "table" then
			__line_depth = __line_depth or 4
			
			Log.e("userdata info", table.to_json(arg_39_0, __line_depth, 1, true))
		else
			Log.e("userdata info", var_39_0 .. " 은 uesrdata 가 아니다.")
		end
		
		return 
	end
	
	local var_39_1 = getmetatable(arg_39_0)
	local var_39_2 = var_0_4(arg_39_0)
	local var_39_3 = {}
	
	for iter_39_0, iter_39_1 in pairs(var_39_1) do
		table.insert(var_39_3, tolua.type(iter_39_1) .. "\t" .. iter_39_0)
	end
	
	table.sort(var_39_3, function(arg_40_0, arg_40_1)
		return arg_40_0 < arg_40_1
	end)
	
	for iter_39_2, iter_39_3 in ipairs(var_39_3) do
		var_39_2 = var_39_2 .. "\n\t" .. iter_39_3
	end
	
	Log.e("userdata info", var_39_2)
end

function __line(...)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_41_0, var_41_1 = var_0_7(...)
	
	if var_41_0 then
		Log.e(var_41_0, var_41_1)
	end
end

function ___line(...)
	if PRODUCTION_MODE then
		return 
	end
	
	print("======= line ===================================================================")
	print(debug.traceback(var_0_6(), 2))
	Log.e(var_0_7(...))
	print("================================================================================")
end

function __call_node_tree(arg_43_0, arg_43_1, arg_43_2)
	if PRODUCTION_MODE then
		return 
	end
	
	if arg_43_1 == 0 then
		return 
	end
	
	if not get_cocos_refid(arg_43_0) then
		return 
	end
	
	arg_43_2(arg_43_0)
	
	if not get_cocos_refid(arg_43_0) then
		return 
	end
	
	for iter_43_0, iter_43_1 in pairs(arg_43_0:getChildren()) do
		__call_node_tree(iter_43_1, arg_43_1 - 1, arg_43_2)
	end
end

function __node_tree(arg_44_0, arg_44_1)
	if PRODUCTION_MODE then
		return 
	end
	
	if tolua.type(arg_44_0) == "number" then
		arg_44_1 = arg_44_0
		arg_44_0 = nil
	end
	
	arg_44_1 = arg_44_1 or -1
	
	print("====================================================================================================================================================")
	print("scene_name: " .. "'" .. SceneManager:getCurrentSceneName() .. "'", "node_name: " .. "'" .. (arg_44_0 or "") .. "'", "n: " .. arg_44_1)
	print("----------------------------------------------------------------------------------------------------------------------------------------------------")
	
	local var_44_0 = SceneManager:getRunningRootScene()
	
	if arg_44_0 then
		var_44_0 = var_44_0:getChildByName(arg_44_0)
	end
	
	__call_node_tree(var_44_0, arg_44_1, function(arg_45_0)
		print(var_0_4(arg_45_0))
	end)
	print("====================================================================================================================================================")
end

local var_0_8 = {}

function __find_node(arg_46_0, arg_46_1)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_46_0 = arg_46_0 or 1
	
	if table.empty(var_0_8) then
		return nil
	end
	
	if not arg_46_1 then
		print(var_0_4(var_0_8[arg_46_0]))
	end
	
	return var_0_8[arg_46_0]
end

function __find_node_by_text(arg_47_0)
	if not arg_47_0 then
		Log.e("text 에 값이 없습니다.")
		
		return 
	end
	
	if tolua.type(arg_47_0) == "number" then
		Log.d("text 가 숫자 입니다. 문자열로 변경합니다.")
		
		arg_47_0 = tostring(arg_47_0)
	end
	
	if tolua.type(arg_47_0) ~= "string" then
		Log.e("text는 string 타입이여야 합니다.")
	end
	
	if PRODUCTION_MODE then
		return 
	end
	
	print("====================================================================================================================================================")
	print("scene_name: " .. "'" .. SceneManager:getCurrentSceneName() .. "'", "text: " .. "'" .. arg_47_0 .. "'")
	print("----------------------------------------------------------------------------------------------------------------------------------------------------")
	
	local function var_47_0(arg_48_0)
		local var_48_0 = tolua.type(arg_48_0)
		
		if var_48_0 ~= "ccui.Text" and var_48_0 ~= "ccui.RichText" then
			return 
		end
		
		local var_48_1, var_48_2 = string.find(arg_48_0:getString():lower(), arg_47_0:lower())
		
		if not var_48_1 then
			return 
		end
		
		table.insert(var_0_8, arg_48_0)
		print(var_0_4(arg_48_0))
	end
	
	var_0_8 = {}
	
	__call_node_tree(SceneManager:getRunningRootScene(), -1, var_47_0)
	print("====================================================================================================================================================")
end

function __find_node_by_type(arg_49_0, arg_49_1)
	if PRODUCTION_MODE then
		return 
	end
	
	print("====================================================================================================================================================")
	print("scene_name: " .. "'" .. SceneManager:getCurrentSceneName() .. "'", "node_name: " .. "'" .. arg_49_0 .. "'", "root_node_name: " .. "'" .. (arg_49_1 or "") .. "'")
	print("----------------------------------------------------------------------------------------------------------------------------------------------------")
	
	local var_49_0 = SceneManager:getRunningRootScene()
	
	if arg_49_1 then
		var_49_0 = var_49_0:getChildByName(arg_49_1)
	end
	
	local function var_49_1(arg_50_0)
		local var_50_0, var_50_1 = string.find(tolua.type(arg_50_0):lower(), arg_49_0:lower())
		
		if not var_50_0 then
			return 
		end
		
		table.insert(var_0_8, arg_50_0)
		print(var_0_4(arg_50_0))
	end
	
	var_0_8 = {}
	
	__call_node_tree(var_49_0, -1, var_49_1)
	print("====================================================================================================================================================")
end

function __find_node_by_name(arg_51_0, arg_51_1)
	if PRODUCTION_MODE then
		return 
	end
	
	print("====================================================================================================================================================")
	print("scene_name: " .. "'" .. SceneManager:getCurrentSceneName() .. "'", "node_name: " .. "'" .. arg_51_0 .. "'", "root_node_name: " .. "'" .. (arg_51_1 or "") .. "'")
	print("----------------------------------------------------------------------------------------------------------------------------------------------------")
	
	local var_51_0 = SceneManager:getRunningRootScene()
	
	if arg_51_1 then
		var_51_0 = var_51_0:getChildByName(arg_51_1)
	end
	
	local function var_51_1(arg_52_0)
		local var_52_0, var_52_1 = string.find(arg_52_0:getName():lower(), arg_51_0:lower())
		
		if not var_52_0 then
			return 
		end
		
		table.insert(var_0_8, arg_52_0)
		print(var_0_4(arg_52_0))
	end
	
	var_0_8 = {}
	
	__call_node_tree(var_51_0, -1, var_51_1)
	print("====================================================================================================================================================")
end

function table.join(arg_53_0, arg_53_1)
	for iter_53_0 = 1, #arg_53_1 do
		arg_53_0[#arg_53_0 + 1] = arg_53_1[iter_53_0]
	end
	
	return arg_53_0
end

function table.unique(arg_54_0)
	local var_54_0 = {}
	local var_54_1 = {}
	
	for iter_54_0, iter_54_1 in ipairs(arg_54_0) do
		if not var_54_0[iter_54_1] then
			var_54_1[#var_54_1 + 1] = iter_54_1
			var_54_0[iter_54_1] = true
		end
	end
	
	return var_54_1
end

function table.push(arg_55_0, arg_55_1)
	arg_55_0[#arg_55_0 + 1] = arg_55_1
end

function table.pop(arg_56_0)
	local var_56_0 = arg_56_0[#arg_56_0]
	
	arg_56_0[#arg_56_0] = nil
	
	return var_56_0
end

function table.push_not_nil(arg_57_0, arg_57_1)
	if arg_57_1 then
		arg_57_0[#arg_57_0 + 1] = arg_57_1
	end
end

function table.max_num_value(arg_58_0)
	local var_58_0 = -math.huge
	
	for iter_58_0, iter_58_1 in pairs(arg_58_0) do
		if var_58_0 < iter_58_1 then
			var_58_0 = iter_58_1
		end
	end
	
	return var_58_0
end

function table.tostring(arg_59_0, arg_59_1)
	arg_59_1 = tonumber(arg_59_1)
	
	local var_59_0 = ""
	local var_59_1 = {}
	
	local function var_59_2(arg_60_0)
		var_59_0 = var_59_0 .. (arg_60_0 or "") .. "\n"
	end
	
	local function var_59_3(arg_61_0, arg_61_1)
		local var_61_0 = string.rep("\t", arg_61_1)
		
		if arg_59_1 and arg_61_1 >= arg_59_1 then
			var_59_2(var_61_0 .. tostring(arg_61_0))
			
			return 
		end
		
		if var_59_1[tostring(arg_61_0)] then
			var_59_2(var_61_0 .. "*" .. tostring(arg_61_0))
		else
			var_59_1[tostring(arg_61_0)] = true
			
			if type(arg_61_0) == "table" then
				for iter_61_0, iter_61_1 in pairs(arg_61_0) do
					if (tolua and tolua.type and tolua.type(iter_61_0) or type(iter_61_0)) == "string" then
						iter_61_0 = "\"" .. iter_61_0 .. "\""
					end
					
					if type(iter_61_1) == "table" then
						var_59_2(var_61_0 .. "[" .. tostring(iter_61_0) .. "] => " .. tostring(arg_61_0))
						var_59_2(var_61_0 .. "  {")
						var_59_3(iter_61_1, arg_61_1 + 1)
						var_59_2(string.rep("\t", arg_61_1) .. "  }")
					elseif type(iter_61_1) == "string" then
						var_59_2(var_61_0 .. "[" .. tostring(iter_61_0) .. "] => \"" .. iter_61_1 .. "\"")
					else
						var_59_2(var_61_0 .. "[" .. tostring(iter_61_0) .. "] => " .. tostring(iter_61_1))
					end
				end
			else
				var_59_2(var_61_0 .. tostring(arg_61_0))
			end
		end
	end
	
	local var_59_4 = 0
	
	if type(arg_59_0) == "table" then
		var_59_2(tostring(arg_59_0))
		var_59_2("{")
		var_59_3(arg_59_0, var_59_4)
		var_59_2("}")
	else
		var_59_3(arg_59_0, var_59_4)
	end
	
	return var_59_0
end

function table.print(arg_62_0, arg_62_1)
	print(table.tostring(arg_62_0, arg_62_1))
end

function table.to_json(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	arg_63_2 = arg_63_2 or 1
	
	local var_63_0 = string.rep("  ", arg_63_2)
	
	if arg_63_1 and arg_63_1 == arg_63_2 then
		return var_63_0 .. string.format("--depth: %d\n", arg_63_2)
	end
	
	local var_63_1 = ""
	
	for iter_63_0, iter_63_1 in pairs(arg_63_0) do
		local var_63_2 = type(iter_63_0) == "string" and tostring(iter_63_0) .. " = " or ""
		
		if type(iter_63_1) == "function" then
			if arg_63_3 then
				var_63_1 = var_63_1 .. var_63_0 .. var_63_2 .. "'" .. tostring(iter_63_1) .. "', \n"
			end
		elseif type(iter_63_1) == "table" then
			local var_63_3 = table.to_json(iter_63_1, arg_63_1, arg_63_2 + 1, arg_63_3)
			
			if var_63_3 == "" then
				var_63_1 = var_63_1 .. var_63_0 .. var_63_2 .. "{}, \n"
			else
				var_63_1 = var_63_1 .. var_63_0 .. var_63_2 .. "{\n" .. var_63_3 .. var_63_0 .. "}, \n"
			end
		elseif type(iter_63_1) == "string" then
			var_63_1 = var_63_1 .. var_63_0 .. var_63_2 .. "'" .. iter_63_1 .. "', \n"
		elseif type(iter_63_1) == "userdata" then
			var_63_1 = var_63_1 .. var_63_0 .. var_63_2 .. "'" .. tostring(iter_63_1) .. "', \n"
		else
			var_63_1 = var_63_1 .. var_63_0 .. var_63_2 .. tostring(iter_63_1) .. ", \n"
		end
	end
	
	if arg_63_2 == 1 then
		return "\n{\n" .. var_63_1 .. "}"
	end
	
	return var_63_1
end

function table.set_readonly(arg_64_0)
	local var_64_0 = {}
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0) do
		if type(iter_64_1) == "table" then
			table.set_readonly(iter_64_1)
		end
	end
	
	setmetatable(arg_64_0, {
		__newindex = function()
			error(" tabls is readonly ")
		end
	})
	
	return var_64_0
end

function table.alignment_clone(arg_66_0)
	local var_66_0 = {}
	
	for iter_66_0, iter_66_1 in pairs(arg_66_0) do
		if type(iter_66_0) == "number" then
			table.insert(var_66_0, iter_66_1)
		end
	end
	
	return var_66_0
end

function table.shallow_clone(arg_67_0)
	local var_67_0 = {}
	
	for iter_67_0, iter_67_1 in pairs(arg_67_0) do
		var_67_0[iter_67_0] = iter_67_1
	end
	
	return var_67_0
end

function table.merge(arg_68_0, arg_68_1)
	for iter_68_0, iter_68_1 in pairs(arg_68_1) do
		arg_68_0[iter_68_0] = iter_68_1
	end
end

function table.clone(arg_69_0, arg_69_1, arg_69_2)
	local var_69_0 = arg_69_2 or {}
	
	arg_69_1 = arg_69_1 or {
		[arg_69_0] = var_69_0
	}
	
	local var_69_1 = pairs
	local var_69_2 = getmetatable(arg_69_0)
	
	if var_69_2 and var_69_2.__pairs then
		var_69_1 = var_69_2.__pairs
	end
	
	for iter_69_0, iter_69_1 in var_69_1(arg_69_0) do
		local var_69_3 = iter_69_0
		
		if type(iter_69_0) == "table" then
			local var_69_4 = {}
			
			arg_69_1[iter_69_0] = var_69_4
			
			table.clone(iter_69_0, arg_69_1, var_69_4)
			
			var_69_3 = var_69_4
		end
		
		if type(iter_69_1) == "table" then
			if arg_69_1[iter_69_1] then
				var_69_0[var_69_3] = arg_69_1[iter_69_1]
			else
				local var_69_5 = {}
				
				arg_69_1[iter_69_1] = var_69_5
				
				table.clone(iter_69_1, arg_69_1, var_69_5)
				
				var_69_0[var_69_3] = var_69_5
			end
		else
			var_69_0[var_69_3] = iter_69_1
		end
	end
	
	return var_69_0
end

function table.copyElement(arg_70_0, arg_70_1)
	local var_70_0 = {}
	
	for iter_70_0, iter_70_1 in pairs(arg_70_1) do
		var_70_0[iter_70_1] = arg_70_0[iter_70_1]
	end
	
	return var_70_0
end

function table.find(arg_71_0, arg_71_1)
	if not arg_71_0 or type(arg_71_0) ~= "table" then
		return 
	end
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0) do
		if type(arg_71_1) == "function" then
			if arg_71_1(iter_71_0, iter_71_1) then
				return iter_71_0
			end
		elseif iter_71_1 == arg_71_1 then
			return iter_71_0
		end
	end
	
	return nil
end

function table.compare_any(arg_72_0, arg_72_1)
	for iter_72_0, iter_72_1 in pairs(arg_72_0) do
		if table.find(arg_72_1, iter_72_1) then
			return true
		end
	end
	
	return false
end

function table.compare_all(arg_73_0, arg_73_1)
	if #arg_73_0 ~= #arg_73_1 then
		return false
	end
	
	for iter_73_0, iter_73_1 in pairs(arg_73_0) do
		if not table.find(arg_73_1, iter_73_1) then
			return false
		end
	end
	
	return true
end

function table.convert(arg_74_0, arg_74_1)
	for iter_74_0, iter_74_1 in pairs(arg_74_0) do
		arg_74_0[iter_74_0] = arg_74_1(iter_74_0, iter_74_1)
	end
end

function table.each(arg_75_0, arg_75_1)
	for iter_75_0, iter_75_1 in pairs(arg_75_0) do
		arg_75_1(iter_75_0, iter_75_1)
	end
end

function table.each_reverse(arg_76_0, arg_76_1)
	for iter_76_0 = #arg_76_0, 1, -1 do
		arg_76_1(iter_76_0, arg_76_0[iter_76_0])
	end
end

function table.delete_i(arg_77_0, arg_77_1)
	local var_77_0 = 0
	
	for iter_77_0 = #arg_77_0, 1, -1 do
		if arg_77_1(iter_77_0, arg_77_0[iter_77_0]) then
			table.remove(arg_77_0, iter_77_0)
			
			var_77_0 = var_77_0 + 1
		end
	end
	
	return var_77_0
end

function table.deleteByValue(arg_78_0, arg_78_1)
	table.delete_i(arg_78_0, function(arg_79_0, arg_79_1)
		return arg_79_1 == arg_78_1
	end)
end

function table.all(arg_80_0, arg_80_1)
	for iter_80_0, iter_80_1 in pairs(arg_80_0) do
		if not arg_80_1(iter_80_0, iter_80_1) then
			return false
		end
	end
	
	return true
end

function table.isInclude(arg_81_0, arg_81_1)
	for iter_81_0, iter_81_1 in pairs(arg_81_0) do
		if type(arg_81_1) == "function" then
			if arg_81_1(iter_81_0, iter_81_1) then
				return true
			end
		elseif iter_81_1 == arg_81_1 then
			return true
		end
	end
	
	return false
end

function table.appendIfNotExist(arg_82_0, arg_82_1)
	if table.find(arg_82_0, arg_82_1) then
		return 
	end
	
	table.insert(arg_82_0, arg_82_1)
end

function table.select(arg_83_0, arg_83_1)
	local var_83_0 = {}
	
	for iter_83_0, iter_83_1 in pairs(arg_83_0) do
		if arg_83_1(iter_83_0, iter_83_1) then
			table.insert(var_83_0, iter_83_1)
		end
	end
	
	return var_83_0
end

function table.collect(arg_84_0, arg_84_1)
	local var_84_0 = {}
	
	for iter_84_0, iter_84_1 in pairs(arg_84_0) do
		var_84_0[iter_84_0] = arg_84_1(iter_84_0, iter_84_1)
	end
	
	return var_84_0
end

function table.indexOf(arg_85_0, arg_85_1)
	for iter_85_0, iter_85_1 in pairs(arg_85_0) do
		if type(arg_85_1) == "function" then
			if arg_85_1(iter_85_0, iter_85_1) then
				return iter_85_0
			end
		elseif arg_85_1 == iter_85_1 then
			return iter_85_0
		end
	end
	
	return 0
end

function table.toCommaStr(arg_86_0, arg_86_1)
	local var_86_0 = ""
	local var_86_1 = ", "
	
	if arg_86_1 then
		var_86_1 = arg_86_1
	end
	
	for iter_86_0, iter_86_1 in pairs(arg_86_0) do
		if type(iter_86_1) == "string" then
			var_86_0 = var_86_0 .. iter_86_1 .. var_86_1
		end
	end
	
	return var_86_0
end

function table.dig(arg_87_0, ...)
	if not arg_87_0 then
		return nil
	end
	
	local var_87_0 = {
		...
	}
	local var_87_1 = arg_87_0
	
	for iter_87_0, iter_87_1 in ipairs(var_87_0) do
		if not var_87_1[iter_87_1] then
			return nil
		end
		
		var_87_1 = var_87_1[iter_87_1]
	end
	
	return var_87_1
end

function table.pack(...)
	return {
		...
	}
end

function string.empty(arg_89_0)
	if arg_89_0 then
		return string.len(arg_89_0) <= 0
	end
	
	return true
end

function string.starts(arg_90_0, arg_90_1)
	if not arg_90_1 then
		return false
	end
	
	return string.sub(arg_90_0, 1, string.len(arg_90_1)) == arg_90_1
end

function string.ends(arg_91_0, arg_91_1)
	if not arg_91_0 then
		return false
	end
	
	return arg_91_1 == "" or string.sub(arg_91_0, -string.len(arg_91_1)) == arg_91_1
end

function string.ltrim(arg_92_0)
	return string.gsub(arg_92_0, "^[ \t\n\r]+", "")
end

function string.rtrim(arg_93_0)
	return string.gsub(arg_93_0, "[ \t\n\r]+$", "")
end

function string.trim(arg_94_0)
	arg_94_0 = string.gsub(arg_94_0, "^[ \t\n\r]+", "")
	
	return string.gsub(arg_94_0, "[ \t\n\r]+$", "")
end

function string.ucfirst(arg_95_0)
	return string.upper(string.sub(arg_95_0, 1, 1)) .. string.sub(arg_95_0, 2)
end

function string.erase_bom(arg_96_0)
	assert(type(arg_96_0) == "string")
	
	if string.byte(arg_96_0, 1) == 239 and string.byte(arg_96_0, 2) == 187 and string.byte(arg_96_0, 3) == 191 then
		return string.sub(arg_96_0, 4)
	end
	
	if string.byte(arg_96_0, 1) == 254 and string.byte(arg_96_0, 2) == 254 then
		return string.sub(arg_96_0, 3)
	end
	
	if string.byte(arg_96_0, 1) == 254 and string.byte(arg_96_0, 2) == 255 then
		return string.sub(arg_96_0, 3)
	end
	
	return arg_96_0
end

function string.unpack(arg_97_0, arg_97_1, arg_97_2)
	arg_97_1 = arg_97_1 or ","
	
	local var_97_0 = string.split(arg_97_0, arg_97_1)
	
	if arg_97_2 then
		for iter_97_0, iter_97_1 in pairs(var_97_0) do
			var_97_0[iter_97_0] = string.trim(var_97_0[iter_97_0])
		end
	end
	
	return unpack(var_97_0, 1, table.maxn(var_97_0))
end

function string.format2(arg_98_0, ...)
	if not arg_98_0 then
		return 
	end
	
	local var_98_0
	local var_98_1 = 1
	local var_98_2 = string.len(arg_98_0)
	local var_98_3 = {
		...
	}
	
	if #var_98_3 == 1 and type(var_98_3[1]) == "table" then
		var_98_3 = var_98_3[1]
	end
	
	while var_98_1 <= var_98_2 do
		local var_98_4, var_98_5, var_98_6 = string.find(arg_98_0, "{(.-)}", var_98_1)
		
		if not var_98_4 or not var_98_5 then
			if var_98_0 then
				var_98_0 = var_98_0 .. string.sub(arg_98_0, var_98_1)
			end
			
			break
		end
		
		var_98_0 = (var_98_0 or "") .. string.sub(arg_98_0, var_98_1, var_98_4 - 1)
		var_98_0 = var_98_0 .. tostring(var_98_3[tonumber(var_98_6) or var_98_6])
		var_98_1 = var_98_5 + 1
	end
	
	return var_98_0 or arg_98_0
end

if _VERSION ~= "Lua 5.3" then
	table.unpack = argument_unpack
end

function html_escape(arg_99_0)
	return (string.gsub(tostring(arg_99_0), "[}{\">/<'&]", {
		[">"] = "&gt;",
		["'"] = "&#39;",
		["/"] = "&#47;",
		["<"] = "&lt;",
		["&"] = "&amp;",
		["\""] = "&quot;"
	}))
end

function comma_value(arg_100_0)
	arg_100_0 = arg_100_0 or 0
	
	local var_100_0 = arg_100_0
	local var_100_1
	
	repeat
		local var_100_2
		
		var_100_0, var_100_2 = string.gsub(var_100_0, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var_100_2 == 0
	
	return var_100_0
end

path = {}
Path = path

function path.dirname(arg_101_0)
	return string.match(arg_101_0, ".*/")
end

function path.filename(arg_102_0)
	return string.match(arg_102_0, ".*/(.*)") or arg_102_0
end

function path.filename_withoutext(arg_103_0)
	arg_103_0 = path.filename(arg_103_0)
	
	return string.sub(arg_103_0, 1, (string.find(arg_103_0, ".", 1, true) or 0) - 1)
end

function path.split(arg_104_0)
	return string.match(arg_104_0, "(.-)([^/]-)(%.[^/]-)$")
end

function path.join(arg_105_0, arg_105_1, arg_105_2)
	if string.sub(arg_105_0, -1) ~= "/" and arg_105_0 ~= "" then
		arg_105_0 = arg_105_0 .. "/"
	end
	
	return arg_105_0 .. arg_105_1 .. (arg_105_2 or "")
end

function table.add(arg_106_0, arg_106_1)
	local var_106_0 = #arg_106_0
	
	for iter_106_0, iter_106_1 in ipairs(arg_106_1) do
		table.insert(arg_106_0, var_106_0 + iter_106_0, iter_106_1)
	end
end

function table.reverse(arg_107_0)
	for iter_107_0 = 1, math.floor(#arg_107_0 / 2) do
		arg_107_0[iter_107_0], arg_107_0[#arg_107_0 - iter_107_0 + 1] = arg_107_0[#arg_107_0 - iter_107_0 + 1], arg_107_0[iter_107_0]
	end
end

function table.removeByValue(arg_108_0, arg_108_1)
	for iter_108_0 = #arg_108_0, 1, -1 do
		if arg_108_1 == arg_108_0[iter_108_0] then
			table.remove(arg_108_0, iter_108_0)
		end
	end
end

function table.clear(arg_109_0)
	for iter_109_0, iter_109_1 in pairs(arg_109_0) do
		arg_109_0[iter_109_0] = nil
	end
end

function table.count(arg_110_0)
	local var_110_0 = 0
	
	for iter_110_0, iter_110_1 in pairs(arg_110_0) do
		var_110_0 = var_110_0 + 1
	end
	
	return var_110_0
end

function table.icount(arg_111_0)
	local var_111_0 = 0
	
	for iter_111_0, iter_111_1 in pairs(arg_111_0) do
		if type(iter_111_0) == "number" then
			var_111_0 = var_111_0 + 1
		end
	end
	
	return var_111_0
end

function table.shuffle(arg_112_0)
	local var_112_0 = #arg_112_0
	
	if var_112_0 < 2 then
		return arg_112_0
	end
	
	for iter_112_0 = 1, var_112_0 do
		local var_112_1 = math.random(1, var_112_0)
		
		arg_112_0[var_112_1], arg_112_0[iter_112_0] = arg_112_0[iter_112_0], arg_112_0[var_112_1]
	end
	
	return arg_112_0
end

function table.empty(arg_113_0)
	for iter_113_0, iter_113_1 in pairs(arg_113_0 or {}) do
		return false
	end
	
	return true
end

function table.flip(arg_114_0)
	local var_114_0 = {}
	
	for iter_114_0, iter_114_1 in pairs(arg_114_0 or {}) do
		var_114_0[iter_114_1] = iter_114_0
	end
	
	return var_114_0
end

math.epsilon = 0.001

function math.equal(arg_115_0, arg_115_1)
	return math.abs(arg_115_0 - arg_115_1) < math.epsilon
end

function math.clamp(arg_116_0, arg_116_1, arg_116_2)
	return math.max(arg_116_1, math.min(arg_116_2, arg_116_0))
end

function math.normalize(arg_117_0, arg_117_1)
	arg_117_0 = tonumber(arg_117_0) or 0
	
	if arg_117_0 == 0 then
		return arg_117_1
	end
	
	return arg_117_0 / math.abs(arg_117_0)
end

function math.is_nan(arg_118_0)
	if arg_118_0 ~= arg_118_0 then
		return true
	end
end

function math.is_inf(arg_119_0)
	if arg_119_0 == 1 / 0 then
		return true
	end
end

function math.is_nan_or_inf(arg_120_0)
	if arg_120_0 == 1 / 0 or arg_120_0 ~= arg_120_0 then
		return true
	end
end

function math.if_nan(arg_121_0, arg_121_1)
	if arg_121_0 ~= arg_121_0 then
		return arg_121_1
	end
	
	return arg_121_0
end

function math.if_inf(arg_122_0, arg_122_1)
	if arg_122_0 == 1 / 0 then
		return arg_122_1
	end
	
	return arg_122_0
end

function math.if_nan_or_inf(arg_123_0, arg_123_1)
	if arg_123_0 == 1 / 0 or arg_123_0 ~= arg_123_0 then
		return arg_123_1
	end
	
	return arg_123_0
end

function round(arg_124_0, arg_124_1)
	if arg_124_1 then
		return math.floor(arg_124_0 * 10^arg_124_1 + 0.5) / 10^arg_124_1
	else
		return math.floor(arg_124_0 + 0.5)
	end
end

function is_nil(arg_125_0)
	if arg_125_0 == nil then
		return true
	end
end

function if_nil(arg_126_0, arg_126_1)
	if arg_126_0 == nil then
		return arg_126_1
	end
	
	return arg_126_0
end

function is_empty(arg_127_0)
	return arg_127_0 == nil or arg_127_0 == ""
end

function merge_table(arg_128_0, arg_128_1, arg_128_2)
	arg_128_1 = arg_128_1 or {}
	
	for iter_128_0, iter_128_1 in pairs(arg_128_0) do
		if not arg_128_2 or not arg_128_1[iter_128_0] then
			arg_128_1[iter_128_0] = iter_128_1
		end
	end
	
	return arg_128_1
end

function copy_functions(arg_129_0, arg_129_1, arg_129_2)
	arg_129_1 = arg_129_1 or {}
	
	for iter_129_0, iter_129_1 in pairs(arg_129_0) do
		if type(iter_129_1) == "function" and (not arg_129_2 or not arg_129_1[iter_129_0]) then
			arg_129_1[iter_129_0] = iter_129_1
		end
	end
	
	return arg_129_1
end

function set_child_string(arg_130_0, arg_130_1, arg_130_2)
	local var_130_0 = arg_130_0:getChildByName(arg_130_1)
	
	if var_130_0 then
		var_130_0:setString(arg_130_2)
	end
end

function set_child_visible(arg_131_0, arg_131_1, arg_131_2)
	local var_131_0 = arg_131_0:getChildByName(arg_131_1)
	
	if var_131_0 then
		var_131_0:setVisible(arg_131_2)
	end
end

function to_n(arg_132_0)
	return tonumber(arg_132_0) or 0
end

function to_name(arg_133_0)
	for iter_133_0, iter_133_1 in pairs(_G) do
		if iter_133_1 == arg_133_0 then
			return iter_133_0
		end
	end
end

function array_to_json(arg_134_0)
	local var_134_0 = "["
	
	for iter_134_0, iter_134_1 in pairs(arg_134_0) do
		if iter_134_0 > 1 then
			var_134_0 = var_134_0 .. ","
		end
		
		var_134_0 = var_134_0 .. json.encode(iter_134_1)
	end
	
	return var_134_0 .. "]"
end

function swap_kv(arg_135_0)
	local var_135_0 = {}
	
	for iter_135_0, iter_135_1 in pairs(arg_135_0) do
		var_135_0[iter_135_1] = iter_135_0
	end
	
	return var_135_0
end

function try(arg_136_0)
	local var_136_0
	
	for iter_136_0, iter_136_1 in ipairs(arg_136_0) do
		var_136_0 = iter_136_1
		
		break
	end
	
	if not var_136_0 then
		return 
	end
	
	local var_136_1 = {
		xpcall(var_136_0, __G__TRACKBACK__)
	}
	
	if not table.remove(var_136_1, 1) and arg_136_0.except then
		var_136_1 = {
			xpcall(arg_136_0.except, __G__TRACKBACK__)
		}
		
		table.remove(var_136_1, 1)
	end
	
	if arg_136_0.finally then
		xpcall(arg_136_0.finally, __G__TRACKBACK__)
	end
	
	return argument_unpack(var_136_1)
end

function DBNFields(arg_137_0, arg_137_1, arg_137_2)
	local var_137_0 = {}
	local var_137_1 = {
		DBN(arg_137_0, arg_137_1, arg_137_2)
	}
	
	for iter_137_0, iter_137_1 in pairs(arg_137_2) do
		var_137_0[iter_137_1] = var_137_1[iter_137_0]
	end
	
	return var_137_0
end

function unixtime()
	return os.time() + G_TIME_DIFF
end

function math.percent(arg_139_0)
	local var_139_0 = 1e-07
	
	return math.floor((arg_139_0 + var_139_0) * 100)
end

function string.per_to_string(arg_140_0)
	return string.format("%.1f", arg_140_0 * 100)
end

function string.tohex(arg_141_0)
	return (arg_141_0:gsub(".", function(arg_142_0)
		return string.format("%02X", string.byte(arg_142_0))
	end))
end

function string.split(arg_143_0, arg_143_1, arg_143_2, arg_143_3)
	if arg_143_2 == nil then
		arg_143_2 = true
	end
	
	arg_143_0 = tostring(arg_143_0)
	arg_143_1 = tostring(arg_143_1)
	
	if arg_143_1 == "" then
		return false
	end
	
	local var_143_0 = 0
	local var_143_1 = {}
	
	for iter_143_0, iter_143_1 in function()
		return string.find(arg_143_0, arg_143_1, var_143_0, arg_143_2)
	end do
		table.insert(var_143_1, string.sub(arg_143_0, var_143_0, arg_143_3 and iter_143_0 or iter_143_0 - 1))
		
		var_143_0 = iter_143_1 + 1
	end
	
	table.insert(var_143_1, string.sub(arg_143_0, var_143_0))
	
	return var_143_1
end

function string.replace(arg_145_0, arg_145_1, arg_145_2)
	local var_145_0 = ""
	local var_145_1 = 1
	
	for iter_145_0 = 1, #arg_145_0 do
		local var_145_2, var_145_3 = string.find(arg_145_0, arg_145_1, var_145_1)
		
		if not var_145_2 then
			local var_145_4 = string.sub(arg_145_0, var_145_1)
			
			var_145_0 = var_145_0 .. var_145_4
			
			break
		else
			local var_145_5 = string.sub(arg_145_0, var_145_1, var_145_2 - 1)
			
			var_145_0 = var_145_0 .. var_145_5 .. arg_145_2
			var_145_1 = var_145_2 + (var_145_3 - var_145_2) + 1
		end
	end
	
	return var_145_0
end

function string.join(arg_146_0, arg_146_1)
	local var_146_0 = ""
	
	arg_146_1 = arg_146_1 or ","
	
	local var_146_1 = table.count(arg_146_0)
	
	for iter_146_0, iter_146_1 in pairs(arg_146_0) do
		var_146_0 = var_146_0 .. tostring(iter_146_1)
		
		if iter_146_0 < var_146_1 then
			var_146_0 = var_146_0 .. arg_146_1
		end
	end
	
	return var_146_0
end

string._b91enc = {
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"!",
	"#",
	"$",
	"%",
	"&",
	"(",
	")",
	"*",
	"+",
	",",
	".",
	"/",
	":",
	";",
	"<",
	"=",
	">",
	"?",
	"@",
	"[",
	"]",
	"^",
	"_",
	"`",
	"{",
	"|",
	"}",
	"~",
	"\""
}
string._b91enc[0] = "A"
string._b91dec = table.flip(string._b91enc)

function string.base91decode(arg_147_0)
	local var_147_0 = #arg_147_0
	local var_147_1 = -1
	local var_147_2 = ""
	local var_147_3 = 0
	local var_147_4 = 0
	
	for iter_147_0 in arg_147_0:gmatch(".") do
		local var_147_5 = string._b91dec[iter_147_0]
		
		if not var_147_5 then
		elseif var_147_1 < 0 then
			var_147_1 = var_147_5
		else
			var_147_1 = var_147_1 + var_147_5 * 91
			var_147_3 = bit.bor(var_147_3, bit.lshift(var_147_1, var_147_4))
			
			if bit.band(var_147_1, 8191) then
				var_147_4 = var_147_4 + 13
			else
				var_147_4 = var_147_4 + 14
			end
			
			repeat
				var_147_2 = var_147_2 .. string.char(bit.band(var_147_3, 255))
				var_147_3 = bit.rshift(var_147_3, 8)
				var_147_4 = var_147_4 - 8
			until not (var_147_4 > 7)
			
			var_147_1 = -1
		end
	end
	
	if var_147_1 + 1 > 0 then
		var_147_2 = var_147_2 .. string.char(bit.band(bit.bor(var_147_3, bit.lshift(var_147_1, var_147_4)), 255))
	end
	
	return var_147_2
end

function string.base91encode(arg_148_0)
	local var_148_0 = 0
	local var_148_1 = 0
	local var_148_2 = ""
	local var_148_3 = #arg_148_0
	
	for iter_148_0 in arg_148_0:gmatch(".") do
		var_148_0 = bit.bor(var_148_0, bit.lshift(string.byte(iter_148_0), var_148_1))
		var_148_1 = var_148_1 + 8
		
		if var_148_1 > 13 then
			v = bit.band(var_148_0, 8191)
			
			if v > 88 then
				var_148_0 = bit.rshift(var_148_0, 13)
				var_148_1 = var_148_1 - 13
			else
				v = bit.band(var_148_0, 16383)
				var_148_0 = bit.rshift(var_148_0, 14)
				var_148_1 = var_148_1 - 14
			end
			
			var_148_2 = var_148_2 .. string._b91enc[v % 91] .. string._b91enc[math.floor(v / 91)]
		end
	end
	
	if var_148_1 > 0 then
		var_148_2 = var_148_2 .. string._b91enc[var_148_0 % 91]
		
		if var_148_1 > 7 or var_148_0 > 90 then
			var_148_2 = var_148_2 .. string._b91enc[math.floor(var_148_0 / 91)]
		end
	end
	
	return var_148_2
end

function args_to_hash(arg_149_0)
	local var_149_0 = {}
	local var_149_1 = string.split(arg_149_0, ",")
	
	for iter_149_0, iter_149_1 in pairs(var_149_1) do
		local var_149_2 = string.split(iter_149_1, "=")
		
		var_149_0[var_149_2[1]] = var_149_2[2]
	end
	
	return var_149_0
end

function summarizer(arg_150_0)
	if type(arg_150_0) == "function" then
		return 
	end
	
	if type(arg_150_0) == "table" and arg_150_0.summary then
		return arg_150_0:summary()
	end
	
	return arg_150_0
end

function add_prefix(arg_151_0, arg_151_1)
	if type(arg_151_1) == "number" then
		arg_151_1 = string.rep("  ", arg_151_1)
	end
	
	local var_151_0 = ""
	local var_151_1 = string.split(arg_151_0, "\n")
	
	for iter_151_0, iter_151_1 in pairs(var_151_1) do
		if var_151_0 ~= "" then
			var_151_0 = var_151_0 .. "\n"
		end
		
		if #var_151_1 == 1 or iter_151_0 > 1 then
			var_151_0 = var_151_0 .. arg_151_1 .. iter_151_1
		else
			var_151_0 = var_151_0 .. iter_151_1
		end
	end
	
	return var_151_0
end

function table.assign_pure_value(arg_152_0, arg_152_1)
	arg_152_0 = arg_152_0 or {}
	
	for iter_152_0, iter_152_1 in pairs(arg_152_1) do
		local var_152_0 = type(arg_152_1[iter_152_0])
		
		if var_152_0 == "table" then
			if arg_152_1[iter_152_0] and not arg_152_1[iter_152_0].isUnit then
				table.assign_pure_value(arg_152_0[iter_152_0], arg_152_1[iter_152_0])
			end
		elseif var_152_0 == "number" or var_152_0 == "string" or var_152_0 == "boolean" then
			arg_152_0[iter_152_0] = iter_152_1
		end
	end
end

function table.filter_pure_value(arg_153_0)
	local var_153_0 = {}
	
	for iter_153_0, iter_153_1 in pairs(arg_153_0) do
		local var_153_1 = type(iter_153_1)
		
		if var_153_1 == "table" then
			var_153_0[iter_153_0] = table.filter_pure_value(iter_153_1)
		elseif var_153_1 == "number" or var_153_1 == "string" or var_153_1 == "boolean" then
			var_153_0[iter_153_0] = iter_153_1
		end
	end
	
	return var_153_0
end

function table.assign_pure_value2(arg_154_0, arg_154_1)
	arg_154_0 = arg_154_0 or {}
	
	for iter_154_0, iter_154_1 in pairs(arg_154_1) do
		local var_154_0 = type(arg_154_1[iter_154_0])
		
		if var_154_0 == "table" then
			if arg_154_1[iter_154_0].uid and arg_154_1[iter_154_0].isUnit then
			else
				table.assign_pure_value(arg_154_0[iter_154_0], arg_154_1[iter_154_0])
			end
		elseif var_154_0 == "number" or var_154_0 == "string" or var_154_0 == "boolean" then
			arg_154_0[iter_154_0] = iter_154_1
		end
	end
	
	return arg_154_0
end

function table.filter_pure_value2(arg_155_0)
	local var_155_0 = {}
	
	for iter_155_0, iter_155_1 in pairs(arg_155_0) do
		local var_155_1 = type(iter_155_1)
		
		if var_155_1 == "table" then
			if iter_155_1.isUnit then
				var_155_0[iter_155_0] = {
					isUnit = true,
					uid = iter_155_1:getUID()
				}
			else
				var_155_0[iter_155_0] = table.filter_pure_value2(iter_155_1)
			end
		elseif var_155_1 == "number" or var_155_1 == "string" or var_155_1 == "boolean" then
			var_155_0[iter_155_0] = iter_155_1
		end
	end
	
	return var_155_0
end

function get_utc_offset()
	return 32400 - (os.time() - os.time(os.date("!*t")))
end

function convert_koreatime_to_utc(arg_157_0, arg_157_1)
	local var_157_0, var_157_1, var_157_2 = string.match(tostring(arg_157_0), "(%d%d)(%d%d)(%d%d)")
	local var_157_3 = tonumber(var_157_0) + 2000
	local var_157_4 = tonumber(var_157_1)
	local var_157_5 = tonumber(var_157_2)
	local var_157_6 = 0
	local var_157_7 = 0
	
	arg_157_1 = tonumber(arg_157_1)
	
	if arg_157_1 < 1000 then
		var_157_6, var_157_7 = string.match(tostring(arg_157_1), "(%d)(%d%d)")
	else
		var_157_6, var_157_7 = string.match(tostring(arg_157_1), "(%d%d)(%d%d)")
	end
	
	local var_157_8 = tonumber(var_157_6) * 60 * 60 + tonumber(var_157_7) * 60 - get_utc_offset()
	
	return os.time({
		hour = 0,
		min = 0,
		sec = 0,
		year = var_157_3,
		month = var_157_4,
		day = var_157_5
	}) + var_157_8
end

function table.ieach(arg_158_0, arg_158_1)
	local var_158_0 = table.maxn(arg_158_0)
	
	for iter_158_0 = 1, var_158_0 do
		if arg_158_0[iter_158_0] then
			arg_158_1(iter_158_0, arg_158_0[iter_158_0])
		end
	end
end

function table.debug(arg_159_0)
	local var_159_0 = ""
	local var_159_1 = {}
	local var_159_2 = 0
	
	function _out(arg_160_0, arg_160_1)
		arg_160_1 = arg_160_1 or var_159_0
		arg_160_1 = arg_160_1 .. add_prefix(tostring(arg_160_0), var_159_2) .. "\n"
	end
	
	function tbl_str(arg_161_0)
		if var_159_1[arg_161_0] then
			return "[*dup]"
		end
		
		var_159_1[arg_161_0] = true
		
		local var_161_0 = "{\n"
		
		for iter_161_0, iter_161_1 in pairs(arg_161_0) do
			local var_161_1 = summarizer(iter_161_1)
			
			if var_161_1 and not string.starts(tostring(iter_161_0), "--") then
				if type(var_161_1) == "table" then
					var_159_2 = var_159_2 + 1
					
					local var_161_2 = tbl_str(var_161_1) == "{\n}" and "{}" or add_prefix(, var_159_2)
					
					var_159_2 = var_159_2 - 1
					var_161_0 = var_161_0 .. "  " .. tostring(iter_161_0) .. " : " .. tostring(var_161_2) .. "\n"
				else
					var_161_0 = var_161_0 .. "  " .. tostring(iter_161_0) .. " : " .. tostring(var_161_1) .. "\n"
				end
			end
		end
		
		return var_161_0 .. "}"
	end
	
	function proc(arg_162_0)
		local var_162_0 = summarizer(arg_162_0)
		
		if not var_162_0 then
			return 
		end
		
		if type(arg_162_0) ~= "table" then
			_out(var_162_0)
			
			return 
		end
		
		local var_162_1 = tbl_str(arg_162_0)
		
		_out(var_162_1)
		
		var_159_0 = var_159_0 .. var_162_1
	end
	
	proc(arg_159_0)
	
	return var_159_0
end

Queue = {}

function Queue.new()
	return {
		first = 0,
		last = -1,
		size = 0
	}
end

function Queue.push(arg_164_0, arg_164_1)
	local var_164_0 = arg_164_0.last + 1
	
	arg_164_0.last = var_164_0
	arg_164_0[var_164_0] = arg_164_1
	arg_164_0.size = arg_164_0.size + 1
end

function Queue.pop(arg_165_0)
	local var_165_0 = arg_165_0.first
	
	if var_165_0 > arg_165_0.last then
		return nil
	end
	
	local var_165_1 = arg_165_0[var_165_0]
	
	arg_165_0[var_165_0] = nil
	arg_165_0.first = var_165_0 + 1
	arg_165_0.size = arg_165_0.size - 1
	
	return var_165_1
end

function Queue.top(arg_166_0)
	if Queue.empty(arg_166_0) then
		return nil
	end
	
	return arg_166_0[arg_166_0.first]
end

function Queue.size(arg_167_0)
	return arg_167_0.size
end

function Queue.empty(arg_168_0)
	return arg_168_0.size == 0
end

function Queue.exist(arg_169_0, arg_169_1)
	for iter_169_0 = arg_169_0.first, arg_169_0.last do
		if arg_169_1(arg_169_0[iter_169_0]) then
			return true
		end
	end
	
	return false
end

local var_0_9 = 3988292384

local function var_0_10(arg_170_0)
	local var_170_0 = {}
	local var_170_1 = setmetatable({}, var_170_0)
	
	function var_170_0.__index(arg_171_0, arg_171_1)
		local var_171_0 = arg_170_0(arg_171_1)
		
		var_170_1[arg_171_1] = var_171_0
		
		return var_171_0
	end
	
	return var_170_1
end

local function var_0_11(arg_172_0)
	local var_172_0 = arg_172_0
	
	for iter_172_0 = 1, 8 do
		local var_172_1 = var_172_0 % 2
		
		var_172_0 = (var_172_0 - var_172_1) / 2
		
		if var_172_1 == 1 then
			var_172_0 = bit.bxor(var_172_0, var_0_9)
		end
	end
	
	return var_172_0
end

local var_0_12 = var_0_10(var_0_11)

function crc32_byte(arg_173_0, arg_173_1)
	arg_173_1 = 4294967295 - (arg_173_1 or 0)
	
	local var_173_0 = (arg_173_1 - arg_173_1 % 256) / 256
	local var_173_1 = var_0_12[bit.bxor(arg_173_1 % 256, arg_173_0)]
	
	return 4294967295 - bit.bxor(var_173_0, var_173_1)
end

function crc32_string(arg_174_0, arg_174_1)
	arg_174_1 = arg_174_1 or 0
	
	for iter_174_0 = 1, #arg_174_0 do
		arg_174_1 = crc32_byte(arg_174_0:byte(iter_174_0), arg_174_1)
	end
	
	return arg_174_1
end

function crc32_range_over(arg_175_0)
	if arg_175_0 == nil or type(arg_175_0) ~= "number" then
		return 
	end
	
	if arg_175_0 < 0 then
		return true
	end
	
	if arg_175_0 > 2147483647 then
		return true
	end
	
	return false
end

function crc32_xxor(arg_176_0, arg_176_1)
	if type(arg_176_0) == "table" then
		return bit.bxor(arg_176_0[1], arg_176_1) * 2147483647 + bit.bxor(arg_176_0[2], arg_176_1)
	end
	
	if arg_176_0 > 2147483647 then
		local var_176_0 = arg_176_0 % 2147483647
		local var_176_1 = (arg_176_0 - var_176_0) / 2147483647
		
		return {
			bit.bxor(var_176_1, arg_176_1),
			bit.bxor(var_176_0, arg_176_1)
		}
	else
		return bit.bxor(arg_176_0, arg_176_1)
	end
end

function report_convic()
	if g_UNIT_CONVIC and not table.empty(g_UNIT_CONVIC) then
		local var_177_0 = array_to_json(g_UNIT_CONVIC)
		
		query("convic_list", {
			convic = var_177_0
		})
		
		g_UNIT_CONVIC = {}
	end
end

if bit then
	bit.bxor64 = bit_xor64
	bit.bhash64 = bit_hash64
end

if TEST_CRC32 then
	print("TEST CRC32 CRC64 ================================================================")
	
	local var_0_13 = 4241280204
	
	local function var_0_14(arg_178_0, arg_178_1)
		if not arg_178_0 then
			return 
		end
		
		if arg_178_1 then
			if not arg_178_0 then
				return 
			end
			
			local var_178_0, var_178_1 = math.modf(tonumber(arg_178_0[2]) or 0)
			
			return bit.bxor(arg_178_0[1] or 0, arg_178_0[3]) + var_178_1
		end
		
		local var_178_2, var_178_3 = math.modf(arg_178_0)
		
		return {
			bit.bxor(var_178_2, var_0_13),
			var_178_3,
			var_0_13
		}
	end
	
	local function var_0_15(arg_179_0, arg_179_1)
		return crc32_string(tostring(arg_179_0), arg_179_1)
	end
	
	local function var_0_16(arg_180_0)
		if arg_180_0 == nil or type(arg_180_0) ~= "number" then
			return 
		end
		
		if arg_180_0 < 0 then
			return true
		end
		
		if arg_180_0 > 2147483647 then
			return true
		end
		
		return false
	end
	
	local var_0_17 = 0
	local var_0_18 = 0
	local var_0_19 = 0
	local var_0_20 = systick()
	
	for iter_0_0 = 1, 10000000 do
		t = iter_0_0 + 0.1234567789901
		
		if var_0_16(iter_0_0) then
			local var_0_21 = iter_0_0
		else
			local var_0_22 = var_0_14(t)
			local var_0_23 = var_0_15("kingsland", t)
		end
	end
	
	print("bit.xor test : ", systick() - var_0_20 .. "ms")
	
	local var_0_24 = systick()
	
	for iter_0_1 = 1, 10000000 do
		t = iter_0_1 + 0.1234567789901
		
		local var_0_25 = bit_hash64(t)
		local var_0_26 = bit_xor64(t, enkey)
	end
	
	print("bit_xor64 test : ", systick() - var_0_24 .. "ms")
	
	local var_0_27 = 4480.1234565
	
	print(string.format("origin number : %18.13f", var_0_27))
	print(string.format("origin number : %g", var_0_27))
	
	local var_0_28 = 4241280204
	
	print(string.format("encrypt key : 0x%X", var_0_28))
	
	local var_0_29 = bit_hash64(var_0_27)
	
	print(string.format("bit_hash64(a) : %g, type : %s,  bit_hash64 compaire : ", var_0_29, type(var_0_29)), var_0_29 == bit_hash64(1234567890.1234567), var_0_29)
	
	local var_0_30 = bit.bxor(var_0_27, var_0_28)
	
	print(string.format("result bit.bxor : %g", var_0_30))
	print(string.format("result bit.bxor-bxor : %g", bit.bxor(var_0_30, var_0_28)))
	print(string.format("compair bxor-bxor : %g == %g", var_0_27, bit.bxor(var_0_30, var_0_28)), var_0_27 == bit.bxor(var_0_30, var_0_28))
	print(string.format("compair bxor-bxor : %18.18f == %18.18f", var_0_27, bit.bxor(var_0_30, var_0_28)), var_0_27 == bit.bxor(var_0_30, var_0_28))
	
	local var_0_31 = bit_xor64(var_0_27, var_0_28)
	
	print(string.format("result bit_xor64 : %g", var_0_31))
	print(string.format("origin bit_xor64 : %g", bit_xor64(var_0_31, var_0_28)))
	print(string.format("compair xor64 : %g == %g", var_0_27, bit_xor64(var_0_31, var_0_28)), var_0_27 == bit_xor64(var_0_31, var_0_28))
	print(string.format("compair xor64 : %18.18f == %18.18f", var_0_27, bit_xor64(var_0_31, var_0_28)), var_0_27 == bit_xor64(var_0_31, var_0_28))
	print("TEST CRC32 CRC64 END =============================================================")
end
