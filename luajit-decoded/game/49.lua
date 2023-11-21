function init_curve(arg_1_0)
	if arg_1_0 then
		arg_1_0:init()
	end
end

function get_curveatX(arg_2_0, arg_2_1)
	if arg_2_0 then
		return arg_2_0:getPercentAtX(arg_2_1)
	end
	
	return arg_2_1
end

function to_curve_table(...)
	local var_3_0 = {
		0.3,
		0.3,
		0.7,
		0.7
	}
	local var_3_1 = {
		...
	}
	
	if #var_3_1 == 0 then
		return var_3_0
	end
	
	if tonumber(var_3_1[1]) then
		var_3_0[1] = tonumber(var_3_1[1]) or 0.3
		var_3_0[2] = tonumber(var_3_1[2]) or 0.3
		var_3_0[3] = tonumber(var_3_1[3]) or 0.7
		var_3_0[4] = tonumber(var_3_1[4]) or 0.7
	elseif type(var_3_1[1]) == "string" then
		local var_3_2 = string.split(tostring(var_3_1[1]), ",")
		
		var_3_0[1] = tonumber(var_3_2[1]) or 0.3
		var_3_0[2] = tonumber(var_3_2[2]) or 0.3
		var_3_0[3] = tonumber(var_3_2[3]) or 0.7
		var_3_0[4] = tonumber(var_3_2[4]) or 0.7
	elseif type(var_3_1[1]) == "table" then
		var_3_0[1] = tonumber(var_3_1[1][1]) or 0.3
		var_3_0[2] = tonumber(var_3_1[1][2]) or 0.3
		var_3_0[3] = tonumber(var_3_1[1][3]) or 0.7
		var_3_0[4] = tonumber(var_3_1[1][4]) or 0.7
	end
	
	return var_3_0
end

function bezierat2(arg_4_0, arg_4_1, arg_4_2)
	return 3 * arg_4_2 * math.pow(1 - arg_4_2, 2) * arg_4_0 + 3 * math.pow(arg_4_2, 2) * (1 - arg_4_2) * arg_4_1 + math.pow(arg_4_2, 3)
end

function bezierat4(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	return math.pow(1 - arg_5_4, 3) * arg_5_0 + 3 * arg_5_4 * math.pow(1 - arg_5_4, 2) * arg_5_1 + 3 * math.pow(arg_5_4, 2) * (1 - arg_5_4) * arg_5_2 + math.pow(arg_5_4, 3) * arg_5_3
end

function normal_bezierat_pp(arg_6_0, arg_6_1)
	return bezierat2(arg_6_0[1], arg_6_0[3], arg_6_1), bezierat2(arg_6_0[2], arg_6_0[4], arg_6_1)
end

local function var_0_0(arg_7_0, ...)
	local var_7_0 = to_curve_table(...)
	
	if not arg_7_0.init or type(arg_7_0.init) ~= "function" then
		function init(arg_8_0)
			arg_8_0._timeIndex = 0
		end
	end
	
	arg_7_0._ctrpt = var_7_0
end

local var_0_1 = 19

local function var_0_2(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._timeIndex or 0
	
	if not arg_9_0._curves then
		arg_9_0._curves = {}
	end
	
	for iter_9_0 = var_9_0, var_0_1 do
		local var_9_1 = iter_9_0 / var_0_1
		
		if not arg_9_0._curves[iter_9_0] then
			arg_9_0._curves[iter_9_0] = cc.p(normal_bezierat_pp(arg_9_0._ctrpt, var_9_1))
		end
		
		local var_9_2 = arg_9_0._curves[iter_9_0]
		
		if arg_9_1 <= var_9_2.x then
			local var_9_3 = {
				x = 0,
				y = 0
			}
			
			if iter_9_0 > 0 then
				var_9_3 = arg_9_0._curves[iter_9_0 - 1]
			end
			
			local var_9_4 = var_9_3.y + (var_9_2.y - var_9_3.y) * (arg_9_1 - var_9_3.x) / (var_9_2.x - var_9_3.x)
			
			if var_9_4 ~= var_9_4 then
				return 0
			end
			
			return var_9_4
		end
		
		arg_9_0._timeIndex = iter_9_0 + 1
	end
	
	return 1
end

BezierCurves = ClassDef()

function BezierCurves.constructor(arg_10_0, ...)
	var_0_0(arg_10_0, ...)
	arg_10_0:init()
end

function BezierCurves.init(arg_11_0)
	arg_11_0._timeIndex = nil
end

function BezierCurves.getPercentAtX(arg_12_0, arg_12_1)
	if arg_12_0._ctrpt then
		return var_0_2(arg_12_0, arg_12_1)
	end
	
	return arg_12_1
end

function BezierCurves.getPoint(arg_13_0, arg_13_1)
	if arg_13_0._ctrpt then
		return cc.p(normal_bezierat_pp(arg_13_0._ctrpt, arg_13_1))
	end
	
	return arg_13_1
end
