HTUtil = {}
HTUtil.MovablePaths = {
	{
		x = 1,
		y = 1
	},
	{
		x = 2,
		y = 0
	},
	{
		x = 1,
		y = -1
	},
	{
		x = -1,
		y = 1
	},
	{
		x = -2,
		y = 0
	},
	{
		x = -1,
		y = -1
	}
}
HTUtil.InverseMovablePathIndex = {
	6,
	5,
	4,
	3,
	2,
	1
}

function HTUtil.getMultiplyPosition(arg_1_0, arg_1_1, arg_1_2)
	return {
		x = arg_1_1.x * arg_1_2,
		y = arg_1_1.y * arg_1_2
	}
end

function HTUtil.getAddedPosition(arg_2_0, arg_2_1, arg_2_2)
	return {
		x = arg_2_1.x + arg_2_2.x,
		y = arg_2_1.y + arg_2_2.y
	}
end

function HTUtil.getDecedPosition(arg_3_0, arg_3_1, arg_3_2)
	return {
		x = arg_3_1.x - arg_3_2.x,
		y = arg_3_1.y - arg_3_2.y
	}
end

function HTUtil.getAbsPosition(arg_4_0, arg_4_1)
	return {
		x = math.abs(arg_4_1.x),
		y = math.abs(arg_4_1.y)
	}
end

function HTUtil.getNormalVector(arg_5_0, arg_5_1)
	local var_5_0 = math.sqrt(math.pow(arg_5_1.x, 2) + math.pow(arg_5_1.y, 2))
	
	return {
		x = arg_5_1.x / var_5_0,
		y = arg_5_1.y / var_5_0
	}
end

function HTUtil.isSamePosition(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 or not arg_6_2 then
		return false
	end
	
	return arg_6_1.x == arg_6_2.x and arg_6_1.y == arg_6_2.y
end

function HTUtil.getTileCost(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0:getDecedPosition(arg_7_2, arg_7_1)
	local var_7_1 = arg_7_0:getAbsPosition(var_7_0)
	local var_7_2 = math.min(var_7_1.x, var_7_1.y)
	local var_7_3 = var_7_2
	local var_7_4 = var_7_1.x - var_7_2
	
	if var_7_4 > 0 then
		var_7_3 = var_7_3 + math.floor(var_7_4 / 2)
	end
	
	local var_7_5 = var_7_1.y - var_7_2
	
	if var_7_5 > 0 then
		var_7_3 = var_7_3 + var_7_5
	end
	
	return var_7_3
end

function HTUtil.getTileRect(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = {}
	
	for iter_8_0 = 0, arg_8_3 - 1 do
		local var_8_1 = arg_8_1.y + (iter_8_0 - math.floor(arg_8_3 / 2))
		local var_8_2 = arg_8_1.x + -(arg_8_2 / 2)
		local var_8_3 = arg_8_2 / 2 - 1
		
		if math.abs(var_8_1 % 2) ~= math.abs(arg_8_1.y % 2) then
			if math.abs(var_8_2 % 2) == math.abs(arg_8_1.x % 2) then
				var_8_2 = var_8_2 - 1
			end
			
			var_8_3 = var_8_3 + 1
		elseif math.abs(var_8_2 % 2) ~= math.abs(arg_8_1.x % 2) then
			var_8_2 = var_8_2 + 1
		end
		
		for iter_8_1 = 0, var_8_3 do
			local var_8_4 = iter_8_1 * 2 + var_8_2
			
			table.insert(var_8_0, {
				x = var_8_4,
				y = var_8_1
			})
		end
	end
	
	return var_8_0
end

function HTUtil.createDebugLabel(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
	local var_9_0 = create_label(arg_9_2)
	
	arg_9_4 = arg_9_4 or cc.c4b(0, 0, 0, 150)
	
	local var_9_1 = arg_9_1 .. "_label"
	
	if arg_9_5 then
		var_9_1 = "label"
	end
	
	local var_9_2 = cc.LayerColor:create(arg_9_4)
	
	var_9_0:setName(var_9_1)
	var_9_2:setContentSize(arg_9_3)
	var_9_2:addChild(var_9_0)
	var_9_2:setName(arg_9_1)
	var_9_2:setCascadeOpacityEnabled(arg_9_6 or false)
	var_9_0:setPosition(arg_9_3.width / 2, arg_9_3.height / 2)
	
	return var_9_2
end

function HTUtil.getDiscoverRange(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_2 == 0 then
		return {
			arg_10_1
		}
	end
	
	local var_10_0 = {}
	
	for iter_10_0 = 1, 6 do
		var_10_0[iter_10_0] = arg_10_0:getMultiplyPosition(arg_10_0.MovablePaths[iter_10_0], arg_10_2)
	end
	
	local var_10_1 = arg_10_0:getAddedPosition(var_10_0[4], arg_10_1)
	local var_10_2 = arg_10_0:getAddedPosition(var_10_0[1], arg_10_1)
	local var_10_3 = arg_10_0:getAddedPosition(var_10_0[5], arg_10_1)
	local var_10_4 = arg_10_0:getAddedPosition(var_10_0[2], arg_10_1)
	local var_10_5 = arg_10_0:getAddedPosition(var_10_0[6], arg_10_1)
	local var_10_6 = arg_10_0:getAddedPosition(var_10_0[3], arg_10_1)
	local var_10_7 = var_10_2.x - var_10_1.x
	local var_10_8 = var_10_4.x - var_10_3.x
	local var_10_9 = {}
	
	for iter_10_1 = var_10_7, var_10_8, 2 do
		local var_10_10 = (iter_10_1 - var_10_7) / 2
		local var_10_11 = var_10_1.x - var_10_10
		local var_10_12 = var_10_1.y - var_10_10
		local var_10_13 = var_10_5.x - var_10_10
		local var_10_14 = var_10_5.y + var_10_10
		
		for iter_10_2 = 0, iter_10_1, 2 do
			table.insert(var_10_9, {
				x = var_10_11 + iter_10_2,
				y = var_10_12
			})
			table.insert(var_10_9, {
				x = var_10_13 + iter_10_2,
				y = var_10_14
			})
		end
	end
	
	for iter_10_3 = 0, var_10_8, 2 do
		table.insert(var_10_9, {
			x = var_10_3.x + iter_10_3,
			y = var_10_3.y
		})
	end
	
	return var_10_9
end

function HTUtil.sendERROR(arg_11_0, arg_11_1)
	Log.e(arg_11_1)
	
	arg_11_0._ERROR_CNT = arg_11_0._ERROR_CNT or 0
	
	if not PRODUCTION_MODE then
		local var_11_0 = LotaUtil:createDebugLabel("test", arg_11_1, {
			width = 200,
			height = 24
		})
		
		var_11_0:setColor(cc.c3b(244, 12, 24))
		var_11_0:setPositionX(380)
		var_11_0:setPositionY(VIEW_HEIGHT + arg_11_0._ERROR_CNT * 24 - 48)
		var_11_0:setLocalZOrder(99999 + arg_11_0._ERROR_CNT)
		
		arg_11_0._ERROR_CNT = arg_11_0._ERROR_CNT + 1
		
		SceneManager:getRunningPopupScene():addChild(var_11_0)
	end
end

function HTUtil.getPosToHashKey(arg_12_0, arg_12_1)
	return arg_12_1.x .. "/" .. arg_12_1.y
end
