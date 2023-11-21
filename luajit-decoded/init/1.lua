local var_0_0 = true
local var_0_1 = true
local var_0_2 = "json"

NULL_STRING = "null"

local var_0_3 = pairs
local var_0_4 = type
local var_0_5 = tostring
local var_0_6 = tonumber
local var_0_7 = getmetatable
local var_0_8 = setmetatable
local var_0_9 = rawset
local var_0_10 = error
local var_0_11 = require
local var_0_12 = pcall
local var_0_13 = select
local var_0_14 = math.floor
local var_0_15 = math.huge
local var_0_16 = string.rep
local var_0_17 = string.gsub
local var_0_18 = string.sub
local var_0_19 = string.byte
local var_0_20 = string.char
local var_0_21 = string.find
local var_0_22 = string.len
local var_0_23 = string.format
local var_0_24 = string.match
local var_0_25 = table.concat
local var_0_26 = {
	version = "dkjson 2.5"
}

if var_0_1 then
	_G[var_0_2] = var_0_26
end

var_0_12(function()
	local var_1_0 = var_0_11("debug").getmetatable
	
	if var_1_0 then
		var_0_7 = var_1_0
	end
end)

var_0_26.null = var_0_8({}, {
	__tojson = function()
		return NULL_STRING
	end
})

local function var_0_27(arg_3_0)
	local var_3_0 = 0
	local var_3_1 = 0
	local var_3_2 = 0
	
	for iter_3_0, iter_3_1 in var_0_3(arg_3_0) do
		if iter_3_0 == "n" and var_0_4(iter_3_1) == "number" then
			var_3_2 = iter_3_1
			
			if var_3_0 < iter_3_1 then
				var_3_0 = iter_3_1
			end
		else
			if var_0_4(iter_3_0) ~= "number" or iter_3_0 < 1 or var_0_14(iter_3_0) ~= iter_3_0 then
				return false
			end
			
			if var_3_0 < iter_3_0 then
				var_3_0 = iter_3_0
			end
			
			var_3_1 = var_3_1 + 1
		end
	end
	
	if var_3_0 > 10 and var_3_2 < var_3_0 and var_3_0 > var_3_1 * 2 then
		return false
	end
	
	return true, var_3_0
end

local var_0_28 = {
	["\f"] = "\\f",
	["\b"] = "\\b",
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\\"] = "\\\\",
	["\r"] = "\\r",
	["\""] = "\\\""
}

local function var_0_29(arg_4_0)
	local var_4_0 = var_0_28[arg_4_0]
	
	if var_4_0 then
		return var_4_0
	end
	
	local var_4_1, var_4_2, var_4_3, var_4_4 = var_0_19(arg_4_0, 1, 4)
	local var_4_5, var_4_6, var_4_7
	
	var_4_5, var_4_6, var_4_7, var_4_4 = var_4_1 or 0, var_4_2 or 0, var_4_3 or 0, var_4_4 or 0
	
	if var_4_5 <= 127 then
		var_4_0 = var_4_5
	elseif var_4_5 >= 192 and var_4_5 <= 223 and var_4_6 >= 128 then
		var_4_0 = (var_4_5 - 192) * 64 + var_4_6 - 128
	elseif var_4_5 >= 224 and var_4_5 <= 239 and var_4_6 >= 128 and var_4_7 >= 128 then
		var_4_0 = ((var_4_5 - 224) * 64 + var_4_6 - 128) * 64 + var_4_7 - 128
	elseif var_4_5 >= 240 and var_4_5 <= 247 and var_4_6 >= 128 and var_4_7 >= 128 and var_4_4 >= 128 then
		var_4_0 = (((var_4_5 - 240) * 64 + var_4_6 - 128) * 64 + var_4_7 - 128) * 64 + var_4_4 - 128
	else
		return ""
	end
	
	if var_4_0 <= 65535 then
		return var_0_23("\\u%.4x", var_4_0)
	elseif var_4_0 <= 1114111 then
		local var_4_8 = var_4_0 - 65536
		local var_4_9 = 55296 + var_0_14(var_4_8 / 1024)
		local var_4_10 = 56320 + var_4_8 % 1024
		
		return var_0_23("\\u%.4x\\u%.4x", var_4_9, var_4_10)
	else
		return ""
	end
end

local function var_0_30(arg_5_0, arg_5_1, arg_5_2)
	if var_0_21(arg_5_0, arg_5_1) then
		return var_0_17(arg_5_0, arg_5_1, arg_5_2)
	else
		return arg_5_0
	end
end

local function var_0_31(arg_6_0)
	arg_6_0 = var_0_30(arg_6_0, "[%z\x01-\x1F\"\\\x7F]", var_0_29)
	
	if var_0_21(arg_6_0, "[\xC2\xD8\xDC\xE1\xE2\xEF]") then
		arg_6_0 = var_0_30(arg_6_0, "\xC2[\x80-\x9F\xAD]", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "\xD8[\x80-\x84]", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "܏", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "\xE1\x9E[\xB4\xB5]", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "\xE2\x80[\x8C-\x8F\xA8-\xAF]", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "\xE2\x81[\xA0-\xAF]", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "﻿", var_0_29)
		arg_6_0 = var_0_30(arg_6_0, "\xEF\xBF[\xB0-\xBF]", var_0_29)
	end
	
	return "\"" .. arg_6_0 .. "\""
end

var_0_26.quotestring = var_0_31

local function var_0_32(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0, var_7_1 = var_0_21(arg_7_0, arg_7_1, 1, true)
	
	if var_7_0 then
		return var_0_18(arg_7_0, 1, var_7_0 - 1) .. arg_7_2 .. var_0_18(arg_7_0, var_7_1 + 1, -1)
	else
		return arg_7_0
	end
end

local var_0_33
local var_0_34

local function var_0_35()
	var_0_33 = var_0_24(var_0_5(0.5), "([^05+])")
	var_0_34 = "[^0-9%-%+eE" .. var_0_17(var_0_33, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"
end

var_0_35()

local function var_0_36(arg_9_0)
	return var_0_32(var_0_30(var_0_5(arg_9_0), var_0_34, ""), var_0_33, ".")
end

local function var_0_37(arg_10_0)
	local var_10_0 = var_0_6(var_0_32(arg_10_0, ".", var_0_33))
	
	if not var_10_0 then
		var_0_35()
		
		var_10_0 = var_0_6(var_0_32(arg_10_0, ".", var_0_33))
	end
	
	return var_10_0
end

local function var_0_38(arg_11_0, arg_11_1, arg_11_2)
	arg_11_1[arg_11_2 + 1] = "\n"
	arg_11_1[arg_11_2 + 2] = var_0_16("  ", arg_11_0)
	arg_11_2 = arg_11_2 + 2
	
	return arg_11_2
end

function var_0_26.addnewline(arg_12_0)
	if arg_12_0.indent then
		arg_12_0.bufferlen = var_0_38(arg_12_0.level or 0, arg_12_0.buffer, arg_12_0.bufferlen or #arg_12_0.buffer)
	end
end

local var_0_39

local function var_0_40(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9)
	local var_13_0 = var_0_4(arg_13_0)
	
	if var_13_0 ~= "string" and var_13_0 ~= "number" then
		return nil, "type '" .. var_13_0 .. "' is not supported as a key by JSON."
	end
	
	if arg_13_2 then
		arg_13_6 = arg_13_6 + 1
		arg_13_5[arg_13_6] = ","
	end
	
	if arg_13_3 then
		arg_13_6 = var_0_38(arg_13_4, arg_13_5, arg_13_6)
	end
	
	arg_13_5[arg_13_6 + 1] = var_0_31(arg_13_0)
	arg_13_5[arg_13_6 + 2] = ":"
	
	return var_0_39(arg_13_1, arg_13_3, arg_13_4, arg_13_5, arg_13_6 + 2, arg_13_7, arg_13_8, arg_13_9)
end

local function var_0_41(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2.bufferlen
	
	if var_0_4(arg_14_0) == "string" then
		var_14_0 = var_14_0 + 1
		arg_14_1[var_14_0] = arg_14_0
	end
	
	return var_14_0
end

local function var_0_42(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_5 = arg_15_5 or arg_15_0
	
	local var_15_0 = arg_15_2.exception
	
	if not var_15_0 then
		return nil, arg_15_5
	else
		arg_15_2.bufferlen = arg_15_4
		
		local var_15_1, var_15_2 = var_15_0(arg_15_0, arg_15_1, arg_15_2, arg_15_5)
		
		if not var_15_1 then
			return nil, var_15_2 or arg_15_5
		end
		
		return var_0_41(var_15_1, arg_15_3, arg_15_2)
	end
end

function var_0_26.encodeexception(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	return var_0_31("<" .. arg_16_3 .. ">")
end

function var_0_39(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	local var_17_0 = var_0_4(arg_17_0)
	local var_17_1 = var_0_7(arg_17_0)
	
	if var_0_4(var_17_1) == "table" then
	else
		var_17_1 = var_17_1
	end
	
	local var_17_2 = var_17_1 and var_17_1.__tojson
	
	if var_17_2 then
		if arg_17_5[arg_17_0] then
			return "reference cycle:" .. var_0_5(arg_17_0)
		end
		
		arg_17_5[arg_17_0] = true
		arg_17_7.bufferlen = arg_17_4
		
		local var_17_3, var_17_4 = var_17_2(arg_17_0, arg_17_7)
		
		if not var_17_3 then
			return var_0_42("custom encoder failed", arg_17_0, arg_17_7, arg_17_3, arg_17_4, var_17_4)
		end
		
		arg_17_5[arg_17_0] = nil
		arg_17_4 = var_0_41(var_17_3, arg_17_3, arg_17_7)
	elseif arg_17_0 == nil then
		arg_17_4 = arg_17_4 + 1
		arg_17_3[arg_17_4] = NULL_STRING
	elseif var_17_0 == "number" then
		local var_17_5
		
		if arg_17_0 ~= arg_17_0 or arg_17_0 >= var_0_15 or -arg_17_0 >= var_0_15 then
			var_17_5 = NULL_STRING
		else
			var_17_5 = var_0_36(arg_17_0)
		end
		
		arg_17_4 = arg_17_4 + 1
		arg_17_3[arg_17_4] = var_17_5
	elseif var_17_0 == "boolean" then
		arg_17_4 = arg_17_4 + 1
		arg_17_3[arg_17_4] = arg_17_0 and "true" or "false"
	elseif var_17_0 == "string" then
		arg_17_4 = arg_17_4 + 1
		arg_17_3[arg_17_4] = var_0_31(arg_17_0)
	elseif var_17_0 == "table" then
		if arg_17_5[arg_17_0] then
			return "reference cycle:" .. var_0_5(arg_17_0)
		end
		
		arg_17_5[arg_17_0] = true
		arg_17_2 = arg_17_2 + 1
		
		local var_17_6, var_17_7 = var_0_27(arg_17_0)
		
		if var_17_7 == 0 and var_17_1 and var_17_1.__jsontype == "object" then
			var_17_6 = false
		end
		
		local var_17_8
		
		if var_17_6 then
			arg_17_4 = arg_17_4 + 1
			arg_17_3[arg_17_4] = "["
			
			for iter_17_0 = 1, var_17_7 do
				local var_17_9
				
				arg_17_4, var_17_9 = var_0_39(arg_17_0[iter_17_0], arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
				
				if not arg_17_4 then
					return nil, var_17_9
				end
				
				if iter_17_0 < var_17_7 then
					arg_17_4 = arg_17_4 + 1
					arg_17_3[arg_17_4] = ","
				end
			end
			
			arg_17_4 = arg_17_4 + 1
			arg_17_3[arg_17_4] = "]"
		else
			local var_17_10 = false
			
			arg_17_4 = arg_17_4 + 1
			arg_17_3[arg_17_4] = "{"
			
			local var_17_11 = var_17_1 and var_17_1.__jsonorder or arg_17_6
			
			if var_17_11 then
				local var_17_12 = {}
				local var_17_13 = #var_17_11
				
				for iter_17_1 = 1, var_17_13 do
					local var_17_14 = var_17_11[iter_17_1]
					local var_17_15 = arg_17_0[var_17_14]
					
					if var_17_15 then
						var_17_12[var_17_14] = true
						
						local var_17_16
						
						arg_17_4, var_17_16 = var_0_40(var_17_14, var_17_15, var_17_10, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
						var_17_10 = true
					end
				end
				
				for iter_17_2, iter_17_3 in var_0_3(arg_17_0) do
					if not var_17_12[iter_17_2] then
						local var_17_17
						
						arg_17_4, var_17_17 = var_0_40(iter_17_2, iter_17_3, var_17_10, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
						
						if not arg_17_4 then
							return nil, var_17_17
						end
						
						var_17_10 = true
					end
				end
			else
				for iter_17_4, iter_17_5 in var_0_3(arg_17_0) do
					local var_17_18
					
					arg_17_4, var_17_18 = var_0_40(iter_17_4, iter_17_5, var_17_10, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
					
					if not arg_17_4 then
						return nil, var_17_18
					end
					
					var_17_10 = true
				end
			end
			
			if arg_17_1 then
				arg_17_4 = var_0_38(arg_17_2 - 1, arg_17_3, arg_17_4)
			end
			
			arg_17_4 = arg_17_4 + 1
			arg_17_3[arg_17_4] = "}"
		end
		
		arg_17_5[arg_17_0] = nil
	else
		arg_17_4 = arg_17_4 + 1
		arg_17_3[arg_17_4] = NULL_STRING
	end
	
	return arg_17_4
end

function var_0_26.encode(arg_18_0, arg_18_1)
	arg_18_1 = arg_18_1 or {}
	
	local var_18_0 = arg_18_1.buffer
	local var_18_1 = var_18_0 or {}
	
	arg_18_1.buffer = var_18_1
	
	var_0_35()
	
	local var_18_2, var_18_3 = var_0_39(arg_18_0, arg_18_1.indent, arg_18_1.level or 0, var_18_1, arg_18_1.bufferlen or 0, arg_18_1.tables or {}, arg_18_1.keyorder, arg_18_1)
	
	if not var_18_2 then
		return "\"encode_error:" .. var_0_5(var_18_3) .. "\""
	elseif var_18_0 == var_18_1 then
		arg_18_1.bufferlen = var_18_2
		
		return true
	else
		arg_18_1.bufferlen = nil
		arg_18_1.buffer = nil
		
		return var_0_25(var_18_1)
	end
end

local function var_0_43(arg_19_0, arg_19_1)
	local var_19_0 = 1
	local var_19_1 = 1
	local var_19_2 = 0
	
	while true do
		var_19_1 = var_0_21(arg_19_0, "\n", var_19_1, true)
		
		if var_19_1 and var_19_1 < arg_19_1 then
			var_19_0 = var_19_0 + 1
			var_19_2 = var_19_1
			var_19_1 = var_19_1 + 1
		else
			break
		end
	end
	
	return "line " .. var_19_0 .. ", column " .. arg_19_1 - var_19_2
end

local function var_0_44(arg_20_0, arg_20_1, arg_20_2)
	return nil, var_0_22(arg_20_0) + 1, "unterminated " .. arg_20_1 .. " at " .. var_0_43(arg_20_0, arg_20_2)
end

local function var_0_45(arg_21_0, arg_21_1)
	while true do
		arg_21_1 = var_0_21(arg_21_0, "%S", arg_21_1)
		
		if not arg_21_1 then
			return nil
		end
		
		local var_21_0 = var_0_18(arg_21_0, arg_21_1, arg_21_1 + 1)
		
		if var_21_0 == "\xEF\xBB" and var_0_18(arg_21_0, arg_21_1 + 2, arg_21_1 + 2) == "\xBF" then
			arg_21_1 = arg_21_1 + 3
		elseif var_21_0 == "//" then
			arg_21_1 = var_0_21(arg_21_0, "[\n\r]", arg_21_1 + 2)
			
			if not arg_21_1 then
				return nil
			end
		elseif var_21_0 == "/*" then
			arg_21_1 = var_0_21(arg_21_0, "*/", arg_21_1 + 2)
			
			if not arg_21_1 then
				return nil
			end
			
			arg_21_1 = arg_21_1 + 2
		else
			return arg_21_1
		end
	end
end

local var_0_46 = {
	b = "\b",
	f = "\f",
	t = "\t",
	r = "\r",
	n = "\n",
	["\\"] = "\\",
	["/"] = "/",
	["\""] = "\""
}

local function var_0_47(arg_22_0)
	if arg_22_0 < 0 then
		return nil
	elseif arg_22_0 <= 127 then
		return var_0_20(arg_22_0)
	elseif arg_22_0 <= 2047 then
		return var_0_20(192 + var_0_14(arg_22_0 / 64), 128 + var_0_14(arg_22_0) % 64)
	elseif arg_22_0 <= 65535 then
		return var_0_20(224 + var_0_14(arg_22_0 / 4096), 128 + var_0_14(arg_22_0 / 64) % 64, 128 + var_0_14(arg_22_0) % 64)
	elseif arg_22_0 <= 1114111 then
		return var_0_20(240 + var_0_14(arg_22_0 / 262144), 128 + var_0_14(arg_22_0 / 4096) % 64, 128 + var_0_14(arg_22_0 / 64) % 64, 128 + var_0_14(arg_22_0) % 64)
	else
		return nil
	end
end

local function var_0_48(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1 + 1
	local var_23_1 = {}
	local var_23_2 = 0
	
	while true do
		local var_23_3 = var_0_21(arg_23_0, "[\"\\]", var_23_0)
		
		if not var_23_3 then
			return var_0_44(arg_23_0, "string", arg_23_1)
		end
		
		if var_23_0 < var_23_3 then
			var_23_2 = var_23_2 + 1
			var_23_1[var_23_2] = var_0_18(arg_23_0, var_23_0, var_23_3 - 1)
		end
		
		if var_0_18(arg_23_0, var_23_3, var_23_3) == "\"" then
			var_23_0 = var_23_3 + 1
			
			break
		else
			local var_23_4 = var_0_18(arg_23_0, var_23_3 + 1, var_23_3 + 1)
			local var_23_5
			
			if var_23_4 == "u" then
				var_23_5 = var_0_6(var_0_18(arg_23_0, var_23_3 + 2, var_23_3 + 5), 16)
				
				if var_23_5 then
					local var_23_6
					
					if var_23_5 >= 55296 and var_23_5 <= 56319 and var_0_18(arg_23_0, var_23_3 + 6, var_23_3 + 7) == "\\u" then
						var_23_6 = var_0_6(var_0_18(arg_23_0, var_23_3 + 8, var_23_3 + 11), 16)
						
						if var_23_6 and var_23_6 >= 56320 and var_23_6 <= 57343 then
							var_23_5 = (var_23_5 - 55296) * 1024 + (var_23_6 - 56320) + 65536
						else
							var_23_6 = nil
						end
					end
					
					var_23_5 = var_23_5 and var_0_47(var_23_5)
					
					if var_23_5 then
						if var_23_6 then
							var_23_0 = var_23_3 + 12
						else
							var_23_0 = var_23_3 + 6
						end
					end
				end
			end
			
			if not var_23_5 then
				var_23_5 = var_0_46[var_23_4] or var_23_4
				var_23_0 = var_23_3 + 2
			end
			
			var_23_2 = var_23_2 + 1
			var_23_1[var_23_2] = var_23_5
		end
	end
	
	if var_23_2 == 1 then
		return var_23_1[1], var_23_0
	elseif var_23_2 > 1 then
		return var_0_25(var_23_1), var_23_0
	else
		return "", var_23_0
	end
end

local var_0_49

local function var_0_50(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = var_0_22(arg_24_2)
	local var_24_1 = {}
	local var_24_2 = 0
	local var_24_3 = arg_24_3 + 1
	
	if arg_24_0 == "object" then
		var_0_8(var_24_1, arg_24_5)
	else
		var_0_8(var_24_1, arg_24_6)
	end
	
	while true do
		var_24_3 = var_0_45(arg_24_2, var_24_3)
		
		if not var_24_3 then
			return var_0_44(arg_24_2, arg_24_0, arg_24_3)
		end
		
		if var_0_18(arg_24_2, var_24_3, var_24_3) == arg_24_1 then
			return var_24_1, var_24_3 + 1
		end
		
		local var_24_4
		local var_24_5
		local var_24_6, var_24_7
		
		var_24_6, var_24_3, var_24_7 = var_0_49(arg_24_2, var_24_3, arg_24_4, arg_24_5, arg_24_6)
		
		if var_24_7 then
			return nil, var_24_3, var_24_7
		end
		
		var_24_3 = var_0_45(arg_24_2, var_24_3)
		
		if not var_24_3 then
			return var_0_44(arg_24_2, arg_24_0, arg_24_3)
		end
		
		local var_24_8 = var_0_18(arg_24_2, var_24_3, var_24_3)
		
		if var_24_8 == ":" then
			if var_24_6 == nil then
				return nil, var_24_3, "cannot use nil as table index (at " .. var_0_43(arg_24_2, var_24_3) .. ")"
			end
			
			var_24_3 = var_0_45(arg_24_2, var_24_3 + 1)
			
			if not var_24_3 then
				return var_0_44(arg_24_2, arg_24_0, arg_24_3)
			end
			
			local var_24_9
			local var_24_10, var_24_11
			
			var_24_10, var_24_3, var_24_11 = var_0_49(arg_24_2, var_24_3, arg_24_4, arg_24_5, arg_24_6)
			
			if var_24_11 then
				return nil, var_24_3, var_24_11
			end
			
			var_24_1[var_24_6] = var_24_10
			var_24_3 = var_0_45(arg_24_2, var_24_3)
			
			if not var_24_3 then
				return var_0_44(arg_24_2, arg_24_0, arg_24_3)
			end
			
			var_24_8 = var_0_18(arg_24_2, var_24_3, var_24_3)
		else
			var_24_2 = var_24_2 + 1
			var_24_1[var_24_2] = var_24_6
		end
		
		if var_24_8 == "," then
			var_24_3 = var_24_3 + 1
		end
	end
end

function var_0_49(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	arg_25_1 = arg_25_1 or 1
	arg_25_1 = var_0_45(arg_25_0, arg_25_1)
	
	if not arg_25_1 then
		return nil, var_0_22(arg_25_0) + 1, "no valid JSON value (reached the end)"
	end
	
	local var_25_0 = var_0_18(arg_25_0, arg_25_1, arg_25_1)
	
	if var_25_0 == "{" then
		return var_0_50("object", "}", arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	elseif var_25_0 == "[" then
		return var_0_50("array", "]", arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	elseif var_25_0 == "\"" then
		return var_0_48(arg_25_0, arg_25_1)
	else
		local var_25_1, var_25_2 = var_0_21(arg_25_0, "^%-?[%d%.]+[eE]?[%+%-]?%d*", arg_25_1)
		
		if var_25_1 then
			local var_25_3 = var_0_37(var_0_18(arg_25_0, var_25_1, var_25_2))
			
			if var_25_3 then
				return var_25_3, var_25_2 + 1
			end
		end
		
		local var_25_4, var_25_5 = var_0_21(arg_25_0, "^%a%w*", arg_25_1)
		
		if var_25_4 then
			local var_25_6 = var_0_18(arg_25_0, var_25_4, var_25_5)
			
			if var_25_6 == "true" then
				return true, var_25_5 + 1
			elseif var_25_6 == "false" then
				return false, var_25_5 + 1
			elseif var_25_6 == NULL_STRING then
				return arg_25_2, var_25_5 + 1
			end
		end
		
		return nil, arg_25_1, "no valid JSON value at " .. var_0_43(arg_25_0, arg_25_1)
	end
end

local function var_0_51(...)
	if var_0_13("#", ...) > 0 then
		return ...
	else
		return {
			__jsontype = "object"
		}, {
			__jsontype = "array"
		}
	end
end

function var_0_26.decode(arg_27_0, arg_27_1, arg_27_2, ...)
	local var_27_0, var_27_1 = var_0_51(...)
	
	return (var_0_49(arg_27_0, arg_27_1, arg_27_2, var_27_0, var_27_1))
end

function var_0_26.use_lpeg()
	local var_28_0 = var_0_11("lpeg")
	
	if var_28_0.version() == "0.11" then
		var_0_10("due to a bug in LPeg 0.11, it cannot be used for JSON matching")
	end
	
	local var_28_1 = var_28_0.match
	local var_28_2 = var_28_0.P
	local var_28_3 = var_28_0.S
	local var_28_4 = var_28_0.R
	
	local function var_28_5(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		if not arg_29_3.msg then
			arg_29_3.msg = arg_29_2 .. " at " .. var_0_43(arg_29_0, arg_29_1)
			arg_29_3.pos = arg_29_1
		end
		
		return false
	end
	
	local function var_28_6(arg_30_0)
		return var_28_0.Cmt(var_28_0.Cc(arg_30_0) * var_28_0.Carg(2), var_28_5)
	end
	
	local var_28_7 = var_28_2("//") * (1 - var_28_3("\n\r"))^0
	local var_28_8 = var_28_2("/*") * (1 - var_28_2("*/"))^0 * var_28_2("*/")
	local var_28_9 = (var_28_3(" \n\r\t") + var_28_2("﻿") + var_28_7 + var_28_8)^0
	local var_28_10 = 1 - var_28_3("\"\\\n\r")
	local var_28_11 = var_28_2("\\") * var_28_0.C(var_28_3("\"\\/bfnrt") + var_28_6("unsupported escape sequence")) / var_0_46
	local var_28_12 = var_28_4("09", "af", "AF")
	
	local function var_28_13(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
		arg_31_2, arg_31_3 = var_0_6(arg_31_2, 16), var_0_6(arg_31_3, 16)
		
		if arg_31_2 >= 55296 and arg_31_2 <= 56319 and arg_31_3 >= 56320 and arg_31_3 <= 57343 then
			return true, var_0_47((arg_31_2 - 55296) * 1024 + (arg_31_3 - 56320) + 65536)
		else
			return false
		end
	end
	
	local function var_28_14(arg_32_0)
		return var_0_47(var_0_6(arg_32_0, 16))
	end
	
	local var_28_15 = var_28_2("\\u") * var_28_0.C(var_28_12 * var_28_12 * var_28_12 * var_28_12)
	local var_28_16 = var_28_0.Cmt(var_28_15 * var_28_15, var_28_13) + var_28_15 / var_28_14 + var_28_11 + var_28_10
	local var_28_17 = var_28_2("\"") * var_28_0.Cs(var_28_16^0) * (var_28_2("\"") + var_28_6("unterminated string"))
	local var_28_18 = var_28_2("-")^-1 * (var_28_2("0") + var_28_4("19") * var_28_4("09")^0)
	local var_28_19 = var_28_2(".") * var_28_4("09")^0
	local var_28_20 = var_28_3("eE") * var_28_3("+-")^-1 * var_28_4("09")^1
	local var_28_21 = var_28_18 * var_28_19^-1 * var_28_20^-1 / var_0_37
	local var_28_22 = var_28_2("true") * var_28_0.Cc(true) + var_28_2("false") * var_28_0.Cc(false) + PNULL_STRING * var_28_0.Carg(1)
	local var_28_23 = var_28_21 + var_28_17 + var_28_22
	local var_28_24
	local var_28_25
	
	local function var_28_26(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
		local var_33_0
		local var_33_1
		local var_33_2
		local var_33_3 = {}
		local var_33_4 = 0
		
		repeat
			local var_33_5, var_33_6, var_33_7 = var_28_1(var_28_24, arg_33_0, arg_33_1, arg_33_2, arg_33_3)
			
			if not var_33_7 then
				break
			end
			
			arg_33_1 = var_33_7
			var_33_4 = var_33_4 + 1
			var_33_3[var_33_4] = var_33_5
		until var_33_6 == "last"
		
		return arg_33_1, var_0_8(var_33_3, arg_33_3.arraymeta)
	end
	
	local function var_28_27(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
		local var_34_0
		local var_34_1
		local var_34_2
		local var_34_3
		local var_34_4 = {}
		
		repeat
			local var_34_5, var_34_6, var_34_7, var_34_8 = var_28_1(var_28_25, arg_34_0, arg_34_1, arg_34_2, arg_34_3)
			
			if not var_34_8 then
				break
			end
			
			arg_34_1 = var_34_8
			var_34_4[var_34_5] = var_34_6
		until var_34_7 == "last"
		
		return arg_34_1, var_0_8(var_34_4, arg_34_3.objectmeta)
	end
	
	local var_28_28 = var_28_9 * (var_28_2("[") * var_28_0.Cmt(var_28_0.Carg(1) * var_28_0.Carg(2), var_28_26) * var_28_9 * (var_28_2("]") + var_28_6("']' expected")) + var_28_2("{") * var_28_0.Cmt(var_28_0.Carg(1) * var_28_0.Carg(2), var_28_27) * var_28_9 * (var_28_2("}") + var_28_6("'}' expected")) + var_28_23)
	local var_28_29 = var_28_28 + var_28_9 * var_28_6("value expected")
	
	var_28_24 = var_28_28 * var_28_9 * (var_28_2(",") * var_28_0.Cc("cont") + var_28_0.Cc("last")) * var_28_0.Cp()
	var_28_25 = var_28_0.Cg(var_28_9 * var_28_17 * var_28_9 * (var_28_2(":") + var_28_6("colon expected")) * var_28_29) * var_28_9 * (var_28_2(",") * var_28_0.Cc("cont") + var_28_0.Cc("last")) * var_28_0.Cp()
	
	local var_28_30 = var_28_29 * var_28_0.Cp()
	
	function var_0_26.decode(arg_35_0, arg_35_1, arg_35_2, ...)
		local var_35_0 = {}
		
		var_35_0.objectmeta, var_35_0.arraymeta = var_0_51(...)
		
		local var_35_1, var_35_2 = var_28_1(var_28_30, arg_35_0, arg_35_1, arg_35_2, var_35_0)
		
		if var_35_0.msg then
			return nil, var_35_0.pos, var_35_0.msg
		else
			return var_35_1, var_35_2
		end
	end
	
	function var_0_26.use_lpeg()
		return var_0_26
	end
	
	var_0_26.using_lpeg = true
	
	return var_0_26
end

if var_0_0 then
	var_0_12(var_0_26.use_lpeg)
end
