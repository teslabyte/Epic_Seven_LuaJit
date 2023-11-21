local var_0_0, var_0_1 = pcall(require, "jit")

if not var_0_0 then
	var_0_1 = nil
end

local var_0_2 = string.pack and #string.pack("n", 0) or 8
local var_0_3
local var_0_4

if not var_0_1 and _VERSION < "Lua 5.3" then
	local var_0_5 = loadstring or load
	local var_0_6 = string.dump(var_0_5("a = 1"))
	
	var_0_2 = ({
		var_0_6:sub(1, 12):byte(1, 12)
	})[11]
end

local var_0_7 = assert
local var_0_8 = error
local var_0_9 = pairs
local var_0_10 = pcall
local var_0_11 = setmetatable
local var_0_12 = tostring
local var_0_13 = type
local var_0_14 = require("string").char
local var_0_15 = require("string").format
local var_0_16 = require("math").floor
local var_0_17 = require("math").tointeger or var_0_16
local var_0_18 = require("math").frexp or require("mathx").frexp
local var_0_19 = require("math").ldexp or require("mathx").ldexp
local var_0_20 = require("math").huge
local var_0_21 = require("table").concat
local var_0_22 = {}

local function var_0_23(arg_1_0, arg_1_1, arg_1_2)
	var_0_8("bad argument #" .. var_0_12(arg_1_1) .. " to " .. arg_1_0 .. " (" .. arg_1_2 .. ")")
end

local function var_0_24(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	var_0_23(arg_2_0, arg_2_1, arg_2_3 .. " expected, got " .. var_0_13(arg_2_2))
end

local function var_0_25(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if var_0_13(arg_3_2) ~= arg_3_3 then
		var_0_24(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	end
end

local var_0_26 = var_0_11({}, {
	__index = function(arg_4_0, arg_4_1)
		if arg_4_1 == 1 then
			return 
		end
		
		var_0_8("pack '" .. arg_4_1 .. "' is unimplemented")
	end
})

var_0_22.packers = var_0_26
var_0_26["nil"] = function(arg_5_0)
	arg_5_0[#arg_5_0 + 1] = var_0_14(192)
end

function var_0_26.boolean(arg_6_0, arg_6_1)
	if arg_6_1 then
		arg_6_0[#arg_6_0 + 1] = var_0_14(195)
	else
		arg_6_0[#arg_6_0 + 1] = var_0_14(194)
	end
end

function var_0_26.string_compat(arg_7_0, arg_7_1)
	local var_7_0 = #arg_7_1
	
	if var_7_0 <= 31 then
		arg_7_0[#arg_7_0 + 1] = var_0_14(160 + var_7_0)
	elseif var_7_0 <= 65535 then
		arg_7_0[#arg_7_0 + 1] = var_0_14(218, var_0_16(var_7_0 / 256), var_7_0 % 256)
	elseif var_7_0 <= 4294967295 then
		arg_7_0[#arg_7_0 + 1] = var_0_14(219, var_0_16(var_7_0 / 16777216), var_0_16(var_7_0 / 65536) % 256, var_0_16(var_7_0 / 256) % 256, var_7_0 % 256)
	else
		var_0_8("overflow in pack 'string_compat'")
	end
	
	arg_7_0[#arg_7_0 + 1] = arg_7_1
end

function var_0_26._string(arg_8_0, arg_8_1)
	local var_8_0 = #arg_8_1
	
	if var_8_0 <= 31 then
		arg_8_0[#arg_8_0 + 1] = var_0_14(160 + var_8_0)
	elseif var_8_0 <= 255 then
		arg_8_0[#arg_8_0 + 1] = var_0_14(217, var_8_0)
	elseif var_8_0 <= 65535 then
		arg_8_0[#arg_8_0 + 1] = var_0_14(218, var_0_16(var_8_0 / 256), var_8_0 % 256)
	elseif var_8_0 <= 4294967295 then
		arg_8_0[#arg_8_0 + 1] = var_0_14(219, var_0_16(var_8_0 / 16777216), var_0_16(var_8_0 / 65536) % 256, var_0_16(var_8_0 / 256) % 256, var_8_0 % 256)
	else
		var_0_8("overflow in pack 'string'")
	end
	
	arg_8_0[#arg_8_0 + 1] = arg_8_1
end

function var_0_26.binary(arg_9_0, arg_9_1)
	local var_9_0 = #arg_9_1
	
	if var_9_0 <= 255 then
		arg_9_0[#arg_9_0 + 1] = var_0_14(196, var_9_0)
	elseif var_9_0 <= 65535 then
		arg_9_0[#arg_9_0 + 1] = var_0_14(197, var_0_16(var_9_0 / 256), var_9_0 % 256)
	elseif var_9_0 <= 4294967295 then
		arg_9_0[#arg_9_0 + 1] = var_0_14(198, var_0_16(var_9_0 / 16777216), var_0_16(var_9_0 / 65536) % 256, var_0_16(var_9_0 / 256) % 256, var_9_0 % 256)
	else
		var_0_8("overflow in pack 'binary'")
	end
	
	arg_9_0[#arg_9_0 + 1] = arg_9_1
end

local function var_0_27(arg_10_0)
	if arg_10_0 == "string_compat" then
		var_0_26.string = var_0_26.string_compat
	elseif arg_10_0 == "string" then
		var_0_26.string = var_0_26._string
	elseif arg_10_0 == "binary" then
		var_0_26.string = var_0_26.binary
	else
		var_0_23("set_string", 1, "invalid option '" .. arg_10_0 .. "'")
	end
end

var_0_22.set_string = var_0_27

function var_0_26.map(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 <= 15 then
		arg_11_0[#arg_11_0 + 1] = var_0_14(128 + arg_11_2)
	elseif arg_11_2 <= 65535 then
		arg_11_0[#arg_11_0 + 1] = var_0_14(222, var_0_16(arg_11_2 / 256), arg_11_2 % 256)
	elseif arg_11_2 <= 4294967295 then
		arg_11_0[#arg_11_0 + 1] = var_0_14(223, var_0_16(arg_11_2 / 16777216), var_0_16(arg_11_2 / 65536) % 256, var_0_16(arg_11_2 / 256) % 256, arg_11_2 % 256)
	else
		var_0_8("overflow in pack 'map'")
	end
	
	for iter_11_0, iter_11_1 in var_0_9(arg_11_1) do
		var_0_26[var_0_13(iter_11_0)](arg_11_0, iter_11_0)
		var_0_26[var_0_13(iter_11_1)](arg_11_0, iter_11_1)
	end
end

function var_0_26.array(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2 <= 15 then
		arg_12_0[#arg_12_0 + 1] = var_0_14(144 + arg_12_2)
	elseif arg_12_2 <= 65535 then
		arg_12_0[#arg_12_0 + 1] = var_0_14(220, var_0_16(arg_12_2 / 256), arg_12_2 % 256)
	elseif arg_12_2 <= 4294967295 then
		arg_12_0[#arg_12_0 + 1] = var_0_14(221, var_0_16(arg_12_2 / 16777216), var_0_16(arg_12_2 / 65536) % 256, var_0_16(arg_12_2 / 256) % 256, arg_12_2 % 256)
	else
		var_0_8("overflow in pack 'array'")
	end
	
	for iter_12_0 = 1, arg_12_2 do
		local var_12_0 = arg_12_1[iter_12_0]
		
		var_0_26[var_0_13(var_12_0)](arg_12_0, var_12_0)
	end
end

local function var_0_28(arg_13_0)
	if arg_13_0 == "without_hole" then
		function var_0_26._table(arg_14_0, arg_14_1)
			local var_14_0 = false
			local var_14_1 = 0
			local var_14_2 = 0
			
			for iter_14_0 in var_0_9(arg_14_1) do
				if var_0_13(iter_14_0) == "number" and iter_14_0 > 0 then
					if var_14_2 < iter_14_0 then
						var_14_2 = iter_14_0
					end
				else
					var_14_0 = true
				end
				
				var_14_1 = var_14_1 + 1
			end
			
			if var_14_2 ~= var_14_1 then
				var_14_0 = true
			end
			
			if var_14_0 then
				var_0_26.map(arg_14_0, arg_14_1, var_14_1)
			else
				var_0_26.array(arg_14_0, arg_14_1, var_14_1)
			end
		end
	elseif arg_13_0 == "with_hole" then
		function var_0_26._table(arg_15_0, arg_15_1)
			local var_15_0 = false
			local var_15_1 = 0
			local var_15_2 = 0
			
			for iter_15_0 in var_0_9(arg_15_1) do
				if var_0_13(iter_15_0) == "number" and iter_15_0 > 0 then
					if var_15_2 < iter_15_0 then
						var_15_2 = iter_15_0
					end
				else
					var_15_0 = true
				end
				
				var_15_1 = var_15_1 + 1
			end
			
			if var_15_0 then
				var_0_26.map(arg_15_0, arg_15_1, var_15_1)
			else
				var_0_26.array(arg_15_0, arg_15_1, var_15_2)
			end
		end
	elseif arg_13_0 == "always_as_map" then
		function var_0_26._table(arg_16_0, arg_16_1)
			local var_16_0 = 0
			
			for iter_16_0 in var_0_9(arg_16_1) do
				var_16_0 = var_16_0 + 1
			end
			
			var_0_26.map(arg_16_0, arg_16_1, var_16_0)
		end
	else
		var_0_23("set_array", 1, "invalid option '" .. arg_13_0 .. "'")
	end
end

var_0_22.set_array = var_0_28

function var_0_26.table(arg_17_0, arg_17_1)
	var_0_26._table(arg_17_0, arg_17_1)
end

function var_0_26.unsigned(arg_18_0, arg_18_1)
	if arg_18_1 >= 0 then
		if arg_18_1 <= 127 then
			arg_18_0[#arg_18_0 + 1] = var_0_14(arg_18_1)
		elseif arg_18_1 <= 255 then
			arg_18_0[#arg_18_0 + 1] = var_0_14(204, arg_18_1)
		elseif arg_18_1 <= 65535 then
			arg_18_0[#arg_18_0 + 1] = var_0_14(205, var_0_16(arg_18_1 / 256), arg_18_1 % 256)
		elseif arg_18_1 <= 4294967295 then
			arg_18_0[#arg_18_0 + 1] = var_0_14(206, var_0_16(arg_18_1 / 16777216), var_0_16(arg_18_1 / 65536) % 256, var_0_16(arg_18_1 / 256) % 256, arg_18_1 % 256)
		else
			arg_18_0[#arg_18_0 + 1] = var_0_14(207, 0, var_0_16(arg_18_1 / 281474976710656) % 256, var_0_16(arg_18_1 / 1099511627776) % 256, var_0_16(arg_18_1 / 4294967296) % 256, var_0_16(arg_18_1 / 16777216) % 256, var_0_16(arg_18_1 / 65536) % 256, var_0_16(arg_18_1 / 256) % 256, arg_18_1 % 256)
		end
	elseif arg_18_1 >= -32 then
		arg_18_0[#arg_18_0 + 1] = var_0_14(256 + arg_18_1)
	elseif arg_18_1 >= -128 then
		arg_18_0[#arg_18_0 + 1] = var_0_14(208, 256 + arg_18_1)
	elseif arg_18_1 >= -32768 then
		arg_18_1 = 65536 + arg_18_1
		arg_18_0[#arg_18_0 + 1] = var_0_14(209, var_0_16(arg_18_1 / 256), arg_18_1 % 256)
	elseif arg_18_1 >= -2147483648 then
		arg_18_1 = 4294967296 + arg_18_1
		arg_18_0[#arg_18_0 + 1] = var_0_14(210, var_0_16(arg_18_1 / 16777216), var_0_16(arg_18_1 / 65536) % 256, var_0_16(arg_18_1 / 256) % 256, arg_18_1 % 256)
	else
		arg_18_0[#arg_18_0 + 1] = var_0_14(211, 255, var_0_16(arg_18_1 / 281474976710656) % 256, var_0_16(arg_18_1 / 1099511627776) % 256, var_0_16(arg_18_1 / 4294967296) % 256, var_0_16(arg_18_1 / 16777216) % 256, var_0_16(arg_18_1 / 65536) % 256, var_0_16(arg_18_1 / 256) % 256, arg_18_1 % 256)
	end
end

function var_0_26.signed(arg_19_0, arg_19_1)
	if arg_19_1 >= 0 then
		if arg_19_1 <= 127 then
			arg_19_0[#arg_19_0 + 1] = var_0_14(arg_19_1)
		elseif arg_19_1 <= 32767 then
			arg_19_0[#arg_19_0 + 1] = var_0_14(209, var_0_16(arg_19_1 / 256), arg_19_1 % 256)
		elseif arg_19_1 <= 2147483647 then
			arg_19_0[#arg_19_0 + 1] = var_0_14(210, var_0_16(arg_19_1 / 16777216), var_0_16(arg_19_1 / 65536) % 256, var_0_16(arg_19_1 / 256) % 256, arg_19_1 % 256)
		else
			arg_19_0[#arg_19_0 + 1] = var_0_14(211, 0, var_0_16(arg_19_1 / 281474976710656) % 256, var_0_16(arg_19_1 / 1099511627776) % 256, var_0_16(arg_19_1 / 4294967296) % 256, var_0_16(arg_19_1 / 16777216) % 256, var_0_16(arg_19_1 / 65536) % 256, var_0_16(arg_19_1 / 256) % 256, arg_19_1 % 256)
		end
	elseif arg_19_1 >= -32 then
		arg_19_0[#arg_19_0 + 1] = var_0_14(256 + arg_19_1)
	elseif arg_19_1 >= -128 then
		arg_19_0[#arg_19_0 + 1] = var_0_14(208, 256 + arg_19_1)
	elseif arg_19_1 >= -32768 then
		arg_19_1 = 65536 + arg_19_1
		arg_19_0[#arg_19_0 + 1] = var_0_14(209, var_0_16(arg_19_1 / 256), arg_19_1 % 256)
	elseif arg_19_1 >= -2147483648 then
		arg_19_1 = 4294967296 + arg_19_1
		arg_19_0[#arg_19_0 + 1] = var_0_14(210, var_0_16(arg_19_1 / 16777216), var_0_16(arg_19_1 / 65536) % 256, var_0_16(arg_19_1 / 256) % 256, arg_19_1 % 256)
	else
		arg_19_0[#arg_19_0 + 1] = var_0_14(211, 255, var_0_16(arg_19_1 / 281474976710656) % 256, var_0_16(arg_19_1 / 1099511627776) % 256, var_0_16(arg_19_1 / 4294967296) % 256, var_0_16(arg_19_1 / 16777216) % 256, var_0_16(arg_19_1 / 65536) % 256, var_0_16(arg_19_1 / 256) % 256, arg_19_1 % 256)
	end
end

local function var_0_29(arg_20_0)
	if arg_20_0 == "unsigned" then
		var_0_26.integer = var_0_26.unsigned
	elseif arg_20_0 == "signed" then
		var_0_26.integer = var_0_26.signed
	else
		var_0_23("set_integer", 1, "invalid option '" .. arg_20_0 .. "'")
	end
end

var_0_22.set_integer = var_0_29

function var_0_26.float(arg_21_0, arg_21_1)
	local var_21_0 = 0
	
	if arg_21_1 < 0 then
		var_21_0 = 128
		arg_21_1 = -arg_21_1
	end
	
	local var_21_1, var_21_2 = var_0_18(arg_21_1)
	
	if var_21_1 ~= var_21_1 then
		arg_21_0[#arg_21_0 + 1] = var_0_14(202, 255, 136, 0, 0)
	elseif var_21_1 == var_0_20 or var_21_2 > 128 then
		if var_21_0 == 0 then
			arg_21_0[#arg_21_0 + 1] = var_0_14(202, 127, 128, 0, 0)
		else
			arg_21_0[#arg_21_0 + 1] = var_0_14(202, 255, 128, 0, 0)
		end
	elseif var_21_1 == 0 and var_21_2 == 0 or var_21_2 < -126 then
		arg_21_0[#arg_21_0 + 1] = var_0_14(202, var_21_0, 0, 0, 0)
	else
		local var_21_3 = var_21_2 + 126
		local var_21_4 = var_0_16((var_21_1 * 2 - 1) * var_0_19(0.5, 24))
		
		arg_21_0[#arg_21_0 + 1] = var_0_14(202, var_21_0 + var_0_16(var_21_3 / 2), var_21_3 % 2 * 128 + var_0_16(var_21_4 / 65536), var_0_16(var_21_4 / 256) % 256, var_21_4 % 256)
	end
end

function var_0_26.double(arg_22_0, arg_22_1)
	local var_22_0 = 0
	
	if arg_22_1 < 0 then
		var_22_0 = 128
		arg_22_1 = -arg_22_1
	end
	
	local var_22_1, var_22_2 = var_0_18(arg_22_1)
	
	if var_22_1 ~= var_22_1 then
		arg_22_0[#arg_22_0 + 1] = var_0_14(203, 255, 248, 0, 0, 0, 0, 0, 0)
	elseif var_22_1 == var_0_20 or var_22_2 > 1024 then
		if var_22_0 == 0 then
			arg_22_0[#arg_22_0 + 1] = var_0_14(203, 127, 240, 0, 0, 0, 0, 0, 0)
		else
			arg_22_0[#arg_22_0 + 1] = var_0_14(203, 255, 240, 0, 0, 0, 0, 0, 0)
		end
	elseif var_22_1 == 0 and var_22_2 == 0 or var_22_2 < -1022 then
		arg_22_0[#arg_22_0 + 1] = var_0_14(203, var_22_0, 0, 0, 0, 0, 0, 0, 0)
	else
		local var_22_3 = var_22_2 + 1022
		local var_22_4 = var_0_16((var_22_1 * 2 - 1) * var_0_19(0.5, 53))
		
		arg_22_0[#arg_22_0 + 1] = var_0_14(203, var_22_0 + var_0_16(var_22_3 / 16), var_22_3 % 16 * 16 + var_0_16(var_22_4 / 281474976710656), var_0_16(var_22_4 / 1099511627776) % 256, var_0_16(var_22_4 / 4294967296) % 256, var_0_16(var_22_4 / 16777216) % 256, var_0_16(var_22_4 / 65536) % 256, var_0_16(var_22_4 / 256) % 256, var_22_4 % 256)
	end
end

local function var_0_30(arg_23_0)
	if arg_23_0 == "float" then
		function var_0_26.number(arg_24_0, arg_24_1)
			if var_0_16(arg_24_1) == arg_24_1 and arg_24_1 < var_0_3 and arg_24_1 > var_0_4 then
				var_0_26.integer(arg_24_0, arg_24_1)
			else
				var_0_26.float(arg_24_0, arg_24_1)
			end
		end
	elseif arg_23_0 == "double" then
		function var_0_26.number(arg_25_0, arg_25_1)
			if var_0_16(arg_25_1) == arg_25_1 and arg_25_1 < var_0_3 and arg_25_1 > var_0_4 then
				var_0_26.integer(arg_25_0, arg_25_1)
			else
				var_0_26.double(arg_25_0, arg_25_1)
			end
		end
	else
		var_0_23("set_number", 1, "invalid option '" .. arg_23_0 .. "'")
	end
end

var_0_22.set_number = var_0_30

for iter_0_0 = 0, 4 do
	local var_0_31 = var_0_17(2^iter_0_0)
	local var_0_32 = 212 + iter_0_0
	
	var_0_26["fixext" .. var_0_12(var_0_31)] = function(arg_26_0, arg_26_1, arg_26_2)
		var_0_7(#arg_26_2 == var_0_31, "bad length for fixext" .. var_0_12(var_0_31))
		
		arg_26_0[#arg_26_0 + 1] = var_0_14(var_0_32, arg_26_1 < 0 and arg_26_1 + 256 or arg_26_1)
		arg_26_0[#arg_26_0 + 1] = arg_26_2
	end
end

function var_0_26.ext(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = #arg_27_2
	
	if var_27_0 <= 255 then
		arg_27_0[#arg_27_0 + 1] = var_0_14(199, var_27_0, arg_27_1 < 0 and arg_27_1 + 256 or arg_27_1)
	elseif var_27_0 <= 65535 then
		arg_27_0[#arg_27_0 + 1] = var_0_14(200, var_0_16(var_27_0 / 256), var_27_0 % 256, arg_27_1 < 0 and arg_27_1 + 256 or arg_27_1)
	elseif var_27_0 <= 4294967295 then
		arg_27_0[#arg_27_0 + 1] = var_0_14(201, var_0_16(var_27_0 / 16777216), var_0_16(var_27_0 / 65536) % 256, var_0_16(var_27_0 / 256) % 256, var_27_0 % 256, arg_27_1 < 0 and arg_27_1 + 256 or arg_27_1)
	else
		var_0_8("overflow in pack 'ext'")
	end
	
	arg_27_0[#arg_27_0 + 1] = arg_27_2
end

function var_0_22.pack(arg_28_0)
	local var_28_0 = {}
	
	var_0_26[var_0_13(arg_28_0)](var_28_0, arg_28_0)
	
	return var_0_21(var_28_0)
end

local var_0_33

local function var_0_34(arg_29_0)
	local var_29_0 = arg_29_0.s
	local var_29_1 = arg_29_0.i
	
	if var_29_1 > arg_29_0.j then
		arg_29_0:underflow(var_29_1)
		
		var_29_0, var_29_1 = arg_29_0.s, arg_29_0.i, arg_29_0.j
	end
	
	local var_29_2 = var_29_0:sub(var_29_1, var_29_1):byte()
	
	arg_29_0.i = var_29_1 + 1
	
	return var_0_33[var_29_2](arg_29_0, var_29_2)
end

var_0_22.unpack_cursor = var_0_34

local function var_0_35(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.s
	local var_30_1 = arg_30_0.i
	local var_30_2 = arg_30_0.j
	local var_30_3 = var_30_1 + arg_30_1 - 1
	
	if var_30_2 < var_30_3 or arg_30_1 < 0 then
		arg_30_0:underflow(var_30_3)
		
		var_30_0, var_30_1 = arg_30_0.s, arg_30_0.i, arg_30_0.j
		var_30_3 = var_30_1 + arg_30_1 - 1
	end
	
	arg_30_0.i = var_30_1 + arg_30_1
	
	return var_30_0:sub(var_30_1, var_30_3)
end

local function var_0_36(arg_31_0, arg_31_1)
	local var_31_0 = {}
	
	for iter_31_0 = 1, arg_31_1 do
		var_31_0[iter_31_0] = var_0_34(arg_31_0)
	end
	
	return var_31_0
end

local function var_0_37(arg_32_0, arg_32_1)
	local var_32_0 = {}
	
	for iter_32_0 = 1, arg_32_1 do
		local var_32_1 = var_0_34(arg_32_0)
		local var_32_2 = var_0_34(arg_32_0)
		
		if var_32_1 == nil or var_32_1 ~= var_32_1 then
			var_32_1 = var_0_22.sentinel
		end
		
		if var_32_1 ~= nil then
			var_32_0[var_32_1] = var_32_2
		end
	end
	
	return var_32_0
end

local function var_0_38(arg_33_0)
	local var_33_0 = arg_33_0.s
	local var_33_1 = arg_33_0.i
	
	if arg_33_0.j < var_33_1 + 3 then
		arg_33_0:underflow(var_33_1 + 3)
		
		var_33_0, var_33_1 = arg_33_0.s, arg_33_0.i, arg_33_0.j
	end
	
	local var_33_2, var_33_3, var_33_4, var_33_5 = var_33_0:sub(var_33_1, var_33_1 + 3):byte(1, 4)
	local var_33_6 = var_33_2 > 127
	local var_33_7 = var_33_2 % 128 * 2 + var_0_16(var_33_3 / 128)
	local var_33_8 = (var_33_3 % 128 * 256 + var_33_4) * 256 + var_33_5
	local var_33_9 = var_33_6 and -1 or 1
	local var_33_10
	
	if var_33_8 == 0 and var_33_7 == 0 then
		var_33_10 = var_33_9 * 0
	elseif var_33_7 == 255 then
		if var_33_8 == 0 then
			var_33_10 = var_33_9 * var_0_20
		else
			var_33_10 = 0 / 0
		end
	else
		var_33_10 = var_33_9 * var_0_19(1 + var_33_8 / 8388608, var_33_7 - 127)
	end
	
	arg_33_0.i = var_33_1 + 4
	
	return var_33_10
end

local function var_0_39(arg_34_0)
	local var_34_0 = arg_34_0.s
	local var_34_1 = arg_34_0.i
	
	if arg_34_0.j < var_34_1 + 7 then
		arg_34_0:underflow(var_34_1 + 7)
		
		var_34_0, var_34_1 = arg_34_0.s, arg_34_0.i, arg_34_0.j
	end
	
	local var_34_2, var_34_3, var_34_4, var_34_5, var_34_6, var_34_7, var_34_8, var_34_9 = var_34_0:sub(var_34_1, var_34_1 + 7):byte(1, 8)
	local var_34_10 = var_34_2 > 127
	local var_34_11 = var_34_2 % 128 * 16 + var_0_16(var_34_3 / 16)
	local var_34_12 = (((((var_34_3 % 16 * 256 + var_34_4) * 256 + var_34_5) * 256 + var_34_6) * 256 + var_34_7) * 256 + var_34_8) * 256 + var_34_9
	local var_34_13 = var_34_10 and -1 or 1
	local var_34_14
	
	if var_34_12 == 0 and var_34_11 == 0 then
		var_34_14 = var_34_13 * 0
	elseif var_34_11 == 2047 then
		if var_34_12 == 0 then
			var_34_14 = var_34_13 * var_0_20
		else
			var_34_14 = 0 / 0
		end
	else
		var_34_14 = var_34_13 * var_0_19(1 + var_34_12 / 4503599627370496, var_34_11 - 1023)
	end
	
	arg_34_0.i = var_34_1 + 8
	
	return var_34_14
end

local function var_0_40(arg_35_0)
	local var_35_0 = arg_35_0.s
	local var_35_1 = arg_35_0.i
	
	if var_35_1 > arg_35_0.j then
		arg_35_0:underflow(var_35_1)
		
		var_35_0, var_35_1 = arg_35_0.s, arg_35_0.i, arg_35_0.j
	end
	
	local var_35_2 = var_35_0:sub(var_35_1, var_35_1):byte()
	
	arg_35_0.i = var_35_1 + 1
	
	return var_35_2
end

local function var_0_41(arg_36_0)
	local var_36_0 = arg_36_0.s
	local var_36_1 = arg_36_0.i
	
	if arg_36_0.j < var_36_1 + 1 then
		arg_36_0:underflow(var_36_1 + 1)
		
		var_36_0, var_36_1 = arg_36_0.s, arg_36_0.i, arg_36_0.j
	end
	
	local var_36_2, var_36_3 = var_36_0:sub(var_36_1, var_36_1 + 1):byte(1, 2)
	
	arg_36_0.i = var_36_1 + 2
	
	return var_36_2 * 256 + var_36_3
end

local function var_0_42(arg_37_0)
	local var_37_0 = arg_37_0.s
	local var_37_1 = arg_37_0.i
	
	if arg_37_0.j < var_37_1 + 3 then
		arg_37_0:underflow(var_37_1 + 3)
		
		var_37_0, var_37_1 = arg_37_0.s, arg_37_0.i, arg_37_0.j
	end
	
	local var_37_2, var_37_3, var_37_4, var_37_5 = var_37_0:sub(var_37_1, var_37_1 + 3):byte(1, 4)
	
	arg_37_0.i = var_37_1 + 4
	
	return ((var_37_2 * 256 + var_37_3) * 256 + var_37_4) * 256 + var_37_5
end

local function var_0_43(arg_38_0)
	local var_38_0 = arg_38_0.s
	local var_38_1 = arg_38_0.i
	
	if arg_38_0.j < var_38_1 + 7 then
		arg_38_0:underflow(var_38_1 + 7)
		
		var_38_0, var_38_1 = arg_38_0.s, arg_38_0.i, arg_38_0.j
	end
	
	local var_38_2, var_38_3, var_38_4, var_38_5, var_38_6, var_38_7, var_38_8, var_38_9 = var_38_0:sub(var_38_1, var_38_1 + 7):byte(1, 8)
	
	arg_38_0.i = var_38_1 + 8
	
	return ((((((var_38_2 * 256 + var_38_3) * 256 + var_38_4) * 256 + var_38_5) * 256 + var_38_6) * 256 + var_38_7) * 256 + var_38_8) * 256 + var_38_9
end

local function var_0_44(arg_39_0)
	local var_39_0 = arg_39_0.s
	local var_39_1 = arg_39_0.i
	
	if var_39_1 > arg_39_0.j then
		arg_39_0:underflow(var_39_1)
		
		var_39_0, var_39_1 = arg_39_0.s, arg_39_0.i, arg_39_0.j
	end
	
	local var_39_2 = var_39_0:sub(var_39_1, var_39_1):byte()
	
	arg_39_0.i = var_39_1 + 1
	
	if var_39_2 < 128 then
		return var_39_2
	else
		return var_39_2 - 256
	end
end

local function var_0_45(arg_40_0)
	local var_40_0 = arg_40_0.s
	local var_40_1 = arg_40_0.i
	
	if arg_40_0.j < var_40_1 + 1 then
		arg_40_0:underflow(var_40_1 + 1)
		
		var_40_0, var_40_1 = arg_40_0.s, arg_40_0.i, arg_40_0.j
	end
	
	local var_40_2, var_40_3 = var_40_0:sub(var_40_1, var_40_1 + 1):byte(1, 2)
	
	arg_40_0.i = var_40_1 + 2
	
	if var_40_2 < 128 then
		return var_40_2 * 256 + var_40_3
	else
		return (var_40_2 - 255) * 256 + (var_40_3 - 255) - 1
	end
end

local function var_0_46(arg_41_0)
	local var_41_0 = arg_41_0.s
	local var_41_1 = arg_41_0.i
	
	if arg_41_0.j < var_41_1 + 3 then
		arg_41_0:underflow(var_41_1 + 3)
		
		var_41_0, var_41_1 = arg_41_0.s, arg_41_0.i, arg_41_0.j
	end
	
	local var_41_2, var_41_3, var_41_4, var_41_5 = var_41_0:sub(var_41_1, var_41_1 + 3):byte(1, 4)
	
	arg_41_0.i = var_41_1 + 4
	
	if var_41_2 < 128 then
		return ((var_41_2 * 256 + var_41_3) * 256 + var_41_4) * 256 + var_41_5
	else
		return (((var_41_2 - 255) * 256 + (var_41_3 - 255)) * 256 + (var_41_4 - 255)) * 256 + (var_41_5 - 255) - 1
	end
end

local function var_0_47(arg_42_0)
	local var_42_0 = arg_42_0.s
	local var_42_1 = arg_42_0.i
	
	if arg_42_0.j < var_42_1 + 7 then
		arg_42_0:underflow(var_42_1 + 7)
		
		var_42_0, var_42_1 = arg_42_0.s, arg_42_0.i, arg_42_0.j
	end
	
	local var_42_2, var_42_3, var_42_4, var_42_5, var_42_6, var_42_7, var_42_8, var_42_9 = var_42_0:sub(var_42_1, var_42_1 + 7):byte(1, 8)
	
	arg_42_0.i = var_42_1 + 8
	
	if var_42_2 < 128 then
		return ((((((var_42_2 * 256 + var_42_3) * 256 + var_42_4) * 256 + var_42_5) * 256 + var_42_6) * 256 + var_42_7) * 256 + var_42_8) * 256 + var_42_9
	else
		return (((((((var_42_2 - 255) * 256 + (var_42_3 - 255)) * 256 + (var_42_4 - 255)) * 256 + (var_42_5 - 255)) * 256 + (var_42_6 - 255)) * 256 + (var_42_7 - 255)) * 256 + (var_42_8 - 255)) * 256 + (var_42_9 - 255) - 1
	end
end

function var_0_22.build_ext(arg_43_0, arg_43_1)
	return nil
end

local function var_0_48(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0.s
	local var_44_1 = arg_44_0.i
	local var_44_2 = arg_44_0.j
	local var_44_3 = var_44_1 + arg_44_1 - 1
	
	if var_44_2 < var_44_3 or arg_44_1 < 0 then
		arg_44_0:underflow(var_44_3)
		
		var_44_0, var_44_1 = arg_44_0.s, arg_44_0.i, arg_44_0.j
		var_44_3 = var_44_1 + arg_44_1 - 1
	end
	
	arg_44_0.i = var_44_1 + arg_44_1
	
	return var_0_22.build_ext(arg_44_2, var_44_0:sub(var_44_1, var_44_3))
end

var_0_33 = var_0_11({
	[192] = function()
		return nil
	end,
	[194] = function()
		return false
	end,
	[195] = function()
		return true
	end,
	[196] = function(arg_48_0)
		return var_0_35(arg_48_0, var_0_40(arg_48_0))
	end,
	[197] = function(arg_49_0)
		return var_0_35(arg_49_0, var_0_41(arg_49_0))
	end,
	[198] = function(arg_50_0)
		return var_0_35(arg_50_0, var_0_42(arg_50_0))
	end,
	[199] = function(arg_51_0)
		return var_0_48(arg_51_0, var_0_40(arg_51_0), var_0_44(arg_51_0))
	end,
	[200] = function(arg_52_0)
		return var_0_48(arg_52_0, var_0_41(arg_52_0), var_0_44(arg_52_0))
	end,
	[201] = function(arg_53_0)
		return var_0_48(arg_53_0, var_0_42(arg_53_0), var_0_44(arg_53_0))
	end,
	[202] = var_0_38,
	[203] = var_0_39,
	[204] = var_0_40,
	[205] = var_0_41,
	[206] = var_0_42,
	[207] = var_0_43,
	[208] = var_0_44,
	[209] = var_0_45,
	[210] = var_0_46,
	[211] = var_0_47,
	[212] = function(arg_54_0)
		return var_0_48(arg_54_0, 1, var_0_44(arg_54_0))
	end,
	[213] = function(arg_55_0)
		return var_0_48(arg_55_0, 2, var_0_44(arg_55_0))
	end,
	[214] = function(arg_56_0)
		return var_0_48(arg_56_0, 4, var_0_44(arg_56_0))
	end,
	[215] = function(arg_57_0)
		return var_0_48(arg_57_0, 8, var_0_44(arg_57_0))
	end,
	[216] = function(arg_58_0)
		return var_0_48(arg_58_0, 16, var_0_44(arg_58_0))
	end,
	[217] = function(arg_59_0)
		return var_0_35(arg_59_0, var_0_40(arg_59_0))
	end,
	[218] = function(arg_60_0)
		return var_0_35(arg_60_0, var_0_41(arg_60_0))
	end,
	[219] = function(arg_61_0)
		return var_0_35(arg_61_0, var_0_42(arg_61_0))
	end,
	[220] = function(arg_62_0)
		return var_0_36(arg_62_0, var_0_41(arg_62_0))
	end,
	[221] = function(arg_63_0)
		return var_0_36(arg_63_0, var_0_42(arg_63_0))
	end,
	[222] = function(arg_64_0)
		return var_0_37(arg_64_0, var_0_41(arg_64_0))
	end,
	[223] = function(arg_65_0)
		return var_0_37(arg_65_0, var_0_42(arg_65_0))
	end
}, {
	__index = function(arg_66_0, arg_66_1)
		if arg_66_1 < 192 then
			if arg_66_1 < 128 then
				return function(arg_67_0, arg_67_1)
					return arg_67_1
				end
			elseif arg_66_1 < 144 then
				return function(arg_68_0, arg_68_1)
					return var_0_37(arg_68_0, arg_68_1 % 16)
				end
			elseif arg_66_1 < 160 then
				return function(arg_69_0, arg_69_1)
					return var_0_36(arg_69_0, arg_69_1 % 16)
				end
			else
				return function(arg_70_0, arg_70_1)
					return var_0_35(arg_70_0, arg_70_1 % 32)
				end
			end
		elseif arg_66_1 > 223 then
			return function(arg_71_0, arg_71_1)
				return arg_71_1 - 256
			end
		else
			return function()
				var_0_8("unpack '" .. var_0_15("%#x", arg_66_1) .. "' is unimplemented")
			end
		end
	end
})

local function var_0_49(arg_73_0)
	return {
		i = 1,
		s = arg_73_0,
		j = #arg_73_0,
		underflow = function()
			var_0_8("missing bytes")
		end
	}
end

local function var_0_50(arg_75_0)
	return {
		j = 0,
		s = "",
		i = 1,
		underflow = function(arg_76_0, arg_76_1)
			arg_76_0.s = arg_76_0.s:sub(arg_76_0.i)
			arg_76_1 = arg_76_1 - arg_76_0.i + 1
			arg_76_0.i = 1
			arg_76_0.j = 0
			
			while arg_76_1 > arg_76_0.j do
				local var_76_0 = arg_75_0()
				
				if not var_76_0 then
					var_0_8("missing bytes")
				end
				
				arg_76_0.s = arg_76_0.s .. var_76_0
				arg_76_0.j = #arg_76_0.s
			end
		end
	}
end

function var_0_22.unpack(arg_77_0)
	var_0_25("unpack", 1, arg_77_0, "string")
	
	local var_77_0 = var_0_49(arg_77_0)
	local var_77_1 = var_0_34(var_77_0)
	
	if var_77_0.i <= var_77_0.j then
		var_0_8("extra bytes")
	end
	
	return var_77_1
end

function var_0_22.unpacker(arg_78_0)
	if var_0_13(arg_78_0) == "string" then
		local var_78_0 = var_0_49(arg_78_0)
		
		return function()
			if var_78_0.i <= var_78_0.j then
				return var_78_0.i, var_0_34(var_78_0)
			end
		end
	elseif var_0_13(arg_78_0) == "function" then
		local var_78_1 = var_0_50(arg_78_0)
		
		return function()
			if var_78_1.i > var_78_1.j then
				var_0_10(var_78_1.underflow, var_78_1, var_78_1.i)
			end
			
			if var_78_1.i <= var_78_1.j then
				return true, var_0_34(var_78_1)
			end
		end
	else
		var_0_23("unpacker", 1, "string or function expected, got " .. var_0_13(arg_78_0))
	end
end

var_0_27("string_compat")
var_0_29("unsigned")

if var_0_2 == 4 then
	var_0_3 = 16777215
	var_0_4 = -var_0_3
	var_0_22.small_lua = true
	var_0_33[203] = nil
	var_0_33[207] = nil
	var_0_33[211] = nil
	
	var_0_30("float")
else
	var_0_3 = 9007199254740991
	var_0_4 = -var_0_3
	
	var_0_30("double")
	
	if var_0_2 > 8 then
		var_0_22.long_double = true
	end
end

var_0_28("without_hole")

var_0_22._VERSION = "0.5.1"
var_0_22._DESCRIPTION = "lua-MessagePack : a pure Lua implementation"
var_0_22._COPYRIGHT = "Copyright (c) 2012-2018 Francois Perrad"
MSGPack = var_0_22
