local var_0_0 = _G

module("Delegate")

local var_0_1 = "Wrong parameter type: must be a function"

local function var_0_2(arg_1_0)
	if arg_1_0 and var_0_0.type(arg_1_0) == "function" then
		return true
	else
		return false
	end
end

local function var_0_3(arg_2_0)
	if not var_0_2(arg_2_0) then
		var_0_0.error(var_0_1)
	end
end

local function var_0_4(arg_3_0, arg_3_1, arg_3_2)
	var_0_3(arg_3_2)
	
	arg_3_0.__subscribers[arg_3_1] = arg_3_2
end

local function var_0_5(arg_4_0, arg_4_1)
	arg_4_0.__subscribers[arg_4_1] = nil
end

local function var_0_6(arg_5_0, arg_5_1)
	arg_5_0.__subscribers = {}
end

function new()
	return var_0_0.setmetatable({
		__subscribers = {},
		add = var_0_4,
		remove = var_0_5,
		remove_all = var_0_6
	}, {
		__call = function(arg_7_0, ...)
			for iter_7_0, iter_7_1 in var_0_0.pairs(arg_7_0.__subscribers) do
				iter_7_1(...)
			end
		end
	})
end
