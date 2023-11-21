function printLog(arg_1_0, arg_1_1, ...)
	local var_1_0 = {
		"[",
		string.upper(tostring(arg_1_0)),
		"] ",
		string.format(tostring(arg_1_1), ...)
	}
	
	print(table.concat(var_1_0))
end

function printError(arg_2_0, ...)
	printLog("ERR", arg_2_0, ...)
	print(debug.traceback("", 2))
end

function printInfo(arg_3_0, ...)
	printLog("INFO", arg_3_0, ...)
end

local function var_0_0(arg_4_0)
	if type(arg_4_0) == "string" then
		arg_4_0 = "\"" .. arg_4_0 .. "\""
	end
	
	return tostring(arg_4_0)
end

function dump(arg_5_0, arg_5_1, arg_5_2)
	if type(arg_5_2) ~= "number" then
		arg_5_2 = 3
	end
	
	local var_5_0 = {}
	local var_5_1 = {}
	local var_5_2 = string.split(debug.traceback("", 2), "\n")
	
	print("dump from: " .. string.trim(var_5_2[3]))
	
	local function var_5_3(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		arg_6_1 = arg_6_1 or "<var>"
		
		local var_6_0 = ""
		
		if type(arg_6_4) == "number" then
			var_6_0 = string.rep(" ", arg_6_4 - string.len(var_0_0(arg_6_1)))
		end
		
		if type(arg_6_0) ~= "table" then
			var_5_1[#var_5_1 + 1] = string.format("%s%s%s = %s", arg_6_2, var_0_0(arg_6_1), var_6_0, var_0_0(arg_6_0))
		elseif var_5_0[tostring(arg_6_0)] then
			var_5_1[#var_5_1 + 1] = string.format("%s%s%s = *REF*", arg_6_2, var_0_0(arg_6_1), var_6_0)
		else
			var_5_0[tostring(arg_6_0)] = true
			
			if arg_6_3 > arg_5_2 then
				var_5_1[#var_5_1 + 1] = string.format("%s%s = *MAX NESTING*", arg_6_2, var_0_0(arg_6_1))
			else
				var_5_1[#var_5_1 + 1] = string.format("%s%s = {", arg_6_2, var_0_0(arg_6_1))
				
				local var_6_1 = arg_6_2 .. "    "
				local var_6_2 = {}
				local var_6_3 = 0
				local var_6_4 = {}
				
				for iter_6_0, iter_6_1 in pairs(arg_6_0) do
					var_6_2[#var_6_2 + 1] = iter_6_0
					
					local var_6_5 = var_0_0(iter_6_0)
					local var_6_6 = string.len(var_6_5)
					
					if var_6_3 < var_6_6 then
						var_6_3 = var_6_6
					end
					
					var_6_4[iter_6_0] = iter_6_1
				end
				
				table.sort(var_6_2, function(arg_7_0, arg_7_1)
					if type(arg_7_0) == "number" and type(arg_7_1) == "number" then
						return arg_7_0 < arg_7_1
					else
						return tostring(arg_7_0) < tostring(arg_7_1)
					end
				end)
				
				for iter_6_2, iter_6_3 in ipairs(var_6_2) do
					var_5_3(var_6_4[iter_6_3], iter_6_3, var_6_1, arg_6_3 + 1, var_6_3)
				end
				
				var_5_1[#var_5_1 + 1] = string.format("%s}", arg_6_2)
			end
		end
	end
	
	var_5_3(arg_5_0, arg_5_1, "- ", 1)
	
	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		print(iter_5_1)
	end
end

function printf(arg_8_0, ...)
	print(string.format(tostring(arg_8_0), ...))
end

function checknumber(arg_9_0, arg_9_1)
	return tonumber(arg_9_0, arg_9_1) or 0
end

function checkint(arg_10_0)
	return math.round(checknumber(arg_10_0))
end

function checkbool(arg_11_0)
	return arg_11_0 ~= nil and arg_11_0 ~= false
end

function checktable(arg_12_0)
	if type(arg_12_0) ~= "table" then
		arg_12_0 = {}
	end
	
	return arg_12_0
end

function isset(arg_13_0, arg_13_1)
	local var_13_0 = type(arg_13_0)
	
	return (var_13_0 == "table" or var_13_0 == "userdata") and arg_13_0[arg_13_1] ~= nil
end

local var_0_1

local function var_0_2(arg_14_0, arg_14_1)
	if type(arg_14_0) == "userdata" then
		local var_14_0 = tolua.getpeer(arg_14_0)
		
		if not var_14_0 then
			var_14_0 = {}
			
			tolua.setpeer(arg_14_0, var_14_0)
		end
		
		var_0_2(var_14_0, arg_14_1)
	else
		local var_14_1 = getmetatable(arg_14_0) or {}
		
		if not var_14_1.__index then
			var_14_1.__index = arg_14_1
			
			setmetatable(arg_14_0, var_14_1)
		elseif var_14_1.__index ~= arg_14_1 then
			var_0_2(var_14_1, arg_14_1)
		end
	end
end

setmetatableindex = var_0_2

function clone(arg_15_0)
	local var_15_0 = {}
	
	local function var_15_1(arg_16_0)
		if type(arg_16_0) ~= "table" then
			return arg_16_0
		elseif var_15_0[arg_16_0] then
			return var_15_0[arg_16_0]
		end
		
		local var_16_0 = {}
		
		var_15_0[arg_16_0] = var_16_0
		
		for iter_16_0, iter_16_1 in pairs(arg_16_0) do
			var_16_0[var_15_1(iter_16_0)] = var_15_1(iter_16_1)
		end
		
		return setmetatable(var_16_0, getmetatable(arg_16_0))
	end
	
	return var_15_1(arg_15_0)
end

function class(arg_17_0, ...)
	local var_17_0 = {
		__cname = arg_17_0
	}
	local var_17_1 = {
		...
	}
	
	for iter_17_0, iter_17_1 in ipairs(var_17_1) do
		local var_17_2 = type(iter_17_1)
		
		assert(var_17_2 == "nil" or var_17_2 == "table" or var_17_2 == "function", string.format("class() - create class \"%s\" with invalid super class type \"%s\"", arg_17_0, var_17_2))
		
		if var_17_2 == "function" then
			assert(var_17_0.__create == nil, string.format("class() - create class \"%s\" with more than one creating function", arg_17_0))
			
			var_17_0.__create = iter_17_1
		elseif var_17_2 == "table" then
			if iter_17_1[".isclass"] then
				assert(var_17_0.__create == nil, string.format("class() - create class \"%s\" with more than one creating function or native class", arg_17_0))
				
				function var_17_0.__create()
					return iter_17_1:create()
				end
			else
				var_17_0.__supers = var_17_0.__supers or {}
				var_17_0.__supers[#var_17_0.__supers + 1] = iter_17_1
				
				if not var_17_0.super then
					var_17_0.super = iter_17_1
				end
			end
		else
			error(string.format("class() - create class \"%s\" with invalid super type", arg_17_0), 0)
		end
	end
	
	var_17_0.__index = var_17_0
	
	if not var_17_0.__supers or #var_17_0.__supers == 1 then
		setmetatable(var_17_0, {
			__index = var_17_0.super
		})
	else
		setmetatable(var_17_0, {
			__index = function(arg_19_0, arg_19_1)
				local var_19_0 = var_17_0.__supers
				
				for iter_19_0 = 1, #var_19_0 do
					local var_19_1 = var_19_0[iter_19_0]
					
					if var_19_1[arg_19_1] then
						return var_19_1[arg_19_1]
					end
				end
			end
		})
	end
	
	if not var_17_0.ctor then
		function var_17_0.ctor()
		end
	end
	
	function var_17_0.new(...)
		local var_21_0
		
		if var_17_0.__create then
			var_21_0 = var_17_0.__create(...)
		else
			var_21_0 = {}
		end
		
		setmetatableindex(var_21_0, var_17_0)
		
		var_21_0.class = var_17_0
		
		var_21_0:ctor(...)
		
		return var_21_0
	end
	
	function var_17_0.create(arg_22_0, ...)
		return var_17_0.new(...)
	end
	
	return var_17_0
end

local var_0_3

local function var_0_4(arg_23_0, arg_23_1)
	local var_23_0 = rawget(arg_23_0, "__index")
	
	if type(var_23_0) == "table" and rawget(var_23_0, "__cname") == arg_23_1 then
		return true
	end
	
	if rawget(arg_23_0, "__cname") == arg_23_1 then
		return true
	end
	
	local var_23_1 = rawget(arg_23_0, "__supers")
	
	if not var_23_1 then
		return false
	end
	
	for iter_23_0, iter_23_1 in ipairs(var_23_1) do
		if var_0_4(iter_23_1, arg_23_1) then
			return true
		end
	end
	
	return false
end

function iskindof(arg_24_0, arg_24_1)
	local var_24_0 = type(arg_24_0)
	
	if var_24_0 ~= "table" and var_24_0 ~= "userdata" then
		return false
	end
	
	local var_24_1
	
	if var_24_0 == "userdata" then
		if tolua.iskindof(arg_24_0, arg_24_1) then
			return true
		end
		
		var_24_1 = tolua.getpeer(arg_24_0)
	else
		var_24_1 = getmetatable(arg_24_0)
	end
	
	if var_24_1 then
		return var_0_4(var_24_1, arg_24_1)
	end
	
	return false
end

function import(arg_25_0, arg_25_1)
	local var_25_0
	local var_25_1 = arg_25_0
	local var_25_2 = 1
	
	while true do
		if string.byte(arg_25_0, var_25_2) ~= 46 then
			var_25_1 = string.sub(arg_25_0, var_25_2)
			
			if var_25_0 and #var_25_0 > 0 then
				var_25_1 = table.concat(var_25_0, ".") .. "." .. var_25_1
			end
			
			break
		end
		
		var_25_2 = var_25_2 + 1
		
		if not var_25_0 then
			if not arg_25_1 then
				local var_25_3, var_25_4 = debug.getlocal(3, 1)
				
				arg_25_1 = var_25_4
			end
			
			var_25_0 = string.split(arg_25_1, ".")
		end
		
		table.remove(var_25_0, #var_25_0)
	end
	
	return require(var_25_1)
end

function handler(arg_26_0, arg_26_1)
	return function(...)
		return arg_26_1(arg_26_0, ...)
	end
end

function math.newrandomseed()
	local var_28_0, var_28_1 = pcall(function()
		return require("socket")
	end)
	
	if var_28_0 then
		math.randomseed(var_28_1.gettime() * 1000)
	else
		math.randomseed(os.time())
	end
	
	math.random()
	math.random()
	math.random()
	math.random()
end

function math.round(arg_30_0)
	arg_30_0 = checknumber(arg_30_0)
	
	return math.floor(arg_30_0 + 0.5)
end

local var_0_5 = math.pi / 180

function math.angle2radian(arg_31_0)
	return arg_31_0 * var_0_5
end

local var_0_6 = math.pi * 180

function math.radian2angle(arg_32_0)
	return arg_32_0 / var_0_6
end

function io.exists(arg_33_0)
	local var_33_0 = io.open(arg_33_0, "r")
	
	if var_33_0 then
		io.close(var_33_0)
		
		return true
	end
	
	return false
end

function io.readfile(arg_34_0)
	local var_34_0 = io.open(arg_34_0, "r")
	
	if var_34_0 then
		local var_34_1 = var_34_0:read("*a")
		
		io.close(var_34_0)
		
		return var_34_1
	end
	
	return nil
end

function io.writefile(arg_35_0, arg_35_1, arg_35_2)
	arg_35_2 = arg_35_2 or "w+b"
	
	local var_35_0 = io.open(arg_35_0, arg_35_2)
	
	if var_35_0 then
		if var_35_0:write(arg_35_1) == nil then
			return false
		end
		
		io.close(var_35_0)
		
		return true
	else
		return false
	end
end

function io.pathinfo(arg_36_0)
	local var_36_0 = string.len(arg_36_0)
	local var_36_1 = var_36_0 + 1
	
	while var_36_0 > 0 do
		local var_36_2 = string.byte(arg_36_0, var_36_0)
		
		if var_36_2 == 46 then
			var_36_1 = var_36_0
		elseif var_36_2 == 47 then
			break
		end
		
		var_36_0 = var_36_0 - 1
	end
	
	local var_36_3 = string.sub(arg_36_0, 1, var_36_0)
	local var_36_4 = string.sub(arg_36_0, var_36_0 + 1)
	local var_36_5 = var_36_1 - var_36_0
	local var_36_6 = string.sub(var_36_4, 1, var_36_5 - 1)
	local var_36_7 = string.sub(var_36_4, var_36_5)
	
	return {
		dirname = var_36_3,
		filename = var_36_4,
		basename = var_36_6,
		extname = var_36_7
	}
end

function io.filesize(arg_37_0)
	local var_37_0 = false
	local var_37_1 = io.open(arg_37_0, "r")
	
	if var_37_1 then
		local var_37_2 = var_37_1:seek()
		
		var_37_0 = var_37_1:seek("end")
		
		var_37_1:seek("set", var_37_2)
		io.close(var_37_1)
	end
	
	return var_37_0
end

function table.nums(arg_38_0)
	local var_38_0 = 0
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0) do
		var_38_0 = var_38_0 + 1
	end
	
	return var_38_0
end

function table.keys(arg_39_0)
	local var_39_0 = {}
	
	for iter_39_0, iter_39_1 in pairs(arg_39_0) do
		var_39_0[#var_39_0 + 1] = iter_39_0
	end
	
	return var_39_0
end

function table.values(arg_40_0)
	local var_40_0 = {}
	
	for iter_40_0, iter_40_1 in pairs(arg_40_0) do
		var_40_0[#var_40_0 + 1] = iter_40_1
	end
	
	return var_40_0
end

function table.merge(arg_41_0, arg_41_1)
	for iter_41_0, iter_41_1 in pairs(arg_41_1) do
		arg_41_0[iter_41_0] = iter_41_1
	end
end

function table.insertto(arg_42_0, arg_42_1, arg_42_2)
	arg_42_2 = checkint(arg_42_2)
	
	if arg_42_2 <= 0 then
		arg_42_2 = #arg_42_0 + 1
	end
	
	local var_42_0 = #arg_42_1
	
	for iter_42_0 = 0, var_42_0 - 1 do
		arg_42_0[iter_42_0 + arg_42_2] = arg_42_1[iter_42_0 + 1]
	end
end

function table.indexof(arg_43_0, arg_43_1, arg_43_2)
	for iter_43_0 = arg_43_2 or 1, #arg_43_0 do
		if arg_43_0[iter_43_0] == arg_43_1 then
			return iter_43_0
		end
	end
	
	return false
end

function table.keyof(arg_44_0, arg_44_1)
	for iter_44_0, iter_44_1 in pairs(arg_44_0) do
		if iter_44_1 == arg_44_1 then
			return iter_44_0
		end
	end
	
	return nil
end

function table.removebyvalue(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = 0
	local var_45_1 = 1
	local var_45_2 = #arg_45_0
	
	while var_45_1 <= var_45_2 do
		if arg_45_0[var_45_1] == arg_45_1 then
			table.remove(arg_45_0, var_45_1)
			
			var_45_0 = var_45_0 + 1
			var_45_1 = var_45_1 - 1
			var_45_2 = var_45_2 - 1
			
			if not arg_45_2 then
				break
			end
		end
		
		var_45_1 = var_45_1 + 1
	end
	
	return var_45_0
end

function table.map(arg_46_0, arg_46_1)
	for iter_46_0, iter_46_1 in pairs(arg_46_0) do
		arg_46_0[iter_46_0] = arg_46_1(iter_46_1, iter_46_0)
	end
end

function table.walk(arg_47_0, arg_47_1)
	for iter_47_0, iter_47_1 in pairs(arg_47_0) do
		arg_47_1(iter_47_1, iter_47_0)
	end
end

function table.filter(arg_48_0, arg_48_1)
	for iter_48_0, iter_48_1 in pairs(arg_48_0) do
		if not arg_48_1(iter_48_1, iter_48_0) then
			arg_48_0[iter_48_0] = nil
		end
	end
end

function table.unique(arg_49_0, arg_49_1)
	local var_49_0 = {}
	local var_49_1 = {}
	local var_49_2 = 1
	
	for iter_49_0, iter_49_1 in pairs(arg_49_0) do
		if not var_49_0[iter_49_1] then
			if arg_49_1 then
				var_49_1[var_49_2] = iter_49_1
				var_49_2 = var_49_2 + 1
			else
				var_49_1[iter_49_0] = iter_49_1
			end
			
			var_49_0[iter_49_1] = true
		end
	end
	
	return var_49_1
end

function table.contains(arg_50_0, arg_50_1)
	for iter_50_0, iter_50_1 in pairs(arg_50_0) do
		if iter_50_1 == arg_50_1 then
			return true
		end
	end
	
	return false
end

string._htmlspecialchars_set = {}
string._htmlspecialchars_set["&"] = "&amp;"
string._htmlspecialchars_set["\""] = "&quot;"
string._htmlspecialchars_set["'"] = "&#039;"
string._htmlspecialchars_set["<"] = "&lt;"
string._htmlspecialchars_set[">"] = "&gt;"

function string.htmlspecialchars(arg_51_0)
	for iter_51_0, iter_51_1 in pairs(string._htmlspecialchars_set) do
		arg_51_0 = string.gsub(arg_51_0, iter_51_0, iter_51_1)
	end
	
	return arg_51_0
end

function string.restorehtmlspecialchars(arg_52_0)
	for iter_52_0, iter_52_1 in pairs(string._htmlspecialchars_set) do
		arg_52_0 = string.gsub(arg_52_0, iter_52_1, iter_52_0)
	end
	
	return arg_52_0
end

function string.nl2br(arg_53_0)
	return string.gsub(arg_53_0, "\n", "<br />")
end

function string.text2html(arg_54_0)
	arg_54_0 = string.gsub(arg_54_0, "\t", "    ")
	arg_54_0 = string.htmlspecialchars(arg_54_0)
	arg_54_0 = string.gsub(arg_54_0, " ", "&nbsp;")
	arg_54_0 = string.nl2br(arg_54_0)
	
	return arg_54_0
end

function string.split(arg_55_0, arg_55_1)
	arg_55_0 = tostring(arg_55_0)
	arg_55_1 = tostring(arg_55_1)
	
	if arg_55_1 == "" then
		return false
	end
	
	local var_55_0 = 0
	local var_55_1 = {}
	
	for iter_55_0, iter_55_1 in function()
		return string.find(arg_55_0, arg_55_1, var_55_0, true)
	end do
		table.insert(var_55_1, string.sub(arg_55_0, var_55_0, iter_55_0 - 1))
		
		var_55_0 = iter_55_1 + 1
	end
	
	table.insert(var_55_1, string.sub(arg_55_0, var_55_0))
	
	return var_55_1
end

function string.ltrim(arg_57_0)
	return string.gsub(arg_57_0, "^[ \t\n\r]+", "")
end

function string.rtrim(arg_58_0)
	return string.gsub(arg_58_0, "[ \t\n\r]+$", "")
end

function string.trim(arg_59_0)
	arg_59_0 = string.gsub(arg_59_0, "^[ \t\n\r]+", "")
	
	return string.gsub(arg_59_0, "[ \t\n\r]+$", "")
end

function string.ucfirst(arg_60_0)
	return string.upper(string.sub(arg_60_0, 1, 1)) .. string.sub(arg_60_0, 2)
end

local function var_0_7(arg_61_0)
	return "%" .. string.format("%02X", string.byte(arg_61_0))
end

function string.urlencode(arg_62_0)
	arg_62_0 = string.gsub(tostring(arg_62_0), "\n", "\r\n")
	arg_62_0 = string.gsub(arg_62_0, "([^%w%.%- ])", var_0_7)
	
	return string.gsub(arg_62_0, " ", "+")
end

function string.urldecode(arg_63_0)
	arg_63_0 = string.gsub(arg_63_0, "+", " ")
	arg_63_0 = string.gsub(arg_63_0, "%%(%x%x)", function(arg_64_0)
		return string.char(checknumber(arg_64_0, 16))
	end)
	arg_63_0 = string.gsub(arg_63_0, "\r\n", "\n")
	
	return arg_63_0
end

function string.utf8len(arg_65_0)
	local var_65_0 = string.len(arg_65_0)
	local var_65_1 = 0
	local var_65_2 = {
		0,
		192,
		224,
		240,
		248,
		252
	}
	
	while var_65_0 ~= 0 do
		local var_65_3 = string.byte(arg_65_0, -var_65_0)
		local var_65_4 = #var_65_2
		
		while var_65_2[var_65_4] do
			if var_65_3 >= var_65_2[var_65_4] then
				var_65_0 = var_65_0 - var_65_4
				
				break
			end
			
			var_65_4 = var_65_4 - 1
		end
		
		var_65_1 = var_65_1 + 1
	end
	
	return var_65_1
end

function string.formatnumberthousands(arg_66_0)
	local var_66_0 = tostring(checknumber(arg_66_0))
	local var_66_1
	
	repeat
		local var_66_2
		
		var_66_0, var_66_2 = string.gsub(var_66_0, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var_66_2 == 0
	
	return var_66_0
end
