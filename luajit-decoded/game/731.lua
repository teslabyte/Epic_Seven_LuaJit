HTBMovableData = ClassDef()
HTBMovableDataInterface = {
	exp = 0,
	name = "this_is_name",
	border_code = "ma_border1",
	type = "player",
	dir = 1,
	leader_code = "c1002",
	user_id = 0,
	last_move_tm = 0,
	id = 1,
	artifact_items = {},
	pos = {
		x = 0,
		y = 0
	}
}

function HTBMovableData.base_getLevel(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.exp or 0
	
	return HTBInterface:getUserLevel(arg_1_1, var_1_0)
end

function HTBMovableData.base_constructor(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		arg_2_0[iter_2_0] = iter_2_1
	end
	
	arg_2_0.last_move_tm = 0
end

HTBMovableDataNotifyInterface = {
	setPos = "onSetPos",
	checkPos = "onCheckPos"
}

local var_0_0 = {
	onSetPos = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if arg_3_0 and arg_3_0.onSetPos then
			arg_3_0:onSetPos(arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		end
	end,
	onCheckPos = function(arg_4_0, arg_4_1, arg_4_2)
		if arg_4_0 and arg_4_0.onCheckPos then
			return arg_4_0:onCheckPos(arg_4_2)
		end
		
		Log.e("WARN. NOT CHECKED.")
		
		return true
	end
}

function HTBMovableData.interfaceCall(arg_5_0, arg_5_1, ...)
	return var_0_0[HTBMovableDataNotifyInterface[arg_5_1]](arg_5_0.notify_object, arg_5_0, ...)
end

function HTBMovableData.notifyObject(arg_6_0, arg_6_1)
	arg_6_0.notify_object = arg_6_1
end

function HTBMovableData.getType(arg_7_0)
	return arg_7_0.type
end

function HTBMovableData.setPosX(arg_8_0, arg_8_1)
	arg_8_0:setPos(arg_8_1, arg_8_0.pos.y)
end

function HTBMovableData.setPosY(arg_9_0, arg_9_1)
	arg_9_0:setPos(arg_9_0.pos.x, arg_9_1)
end

function HTBMovableData.getUserID(arg_10_0)
	return arg_10_0.user_id
end

function HTBMovableData.checkPos(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = {
		x = arg_11_1,
		y = arg_11_2
	}
	
	return arg_11_0:interfaceCall("checkPos", var_11_0)
end

function HTBMovableData.setPos(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = {
		x = arg_12_1,
		y = arg_12_2
	}
	
	if not arg_12_0:interfaceCall("checkPos", table.clone(var_12_0)) then
		table.print(var_12_0)
		print("checkPos! checkPos! checkPos!", arg_12_0:interfaceCall("checkPos", table.clone(var_12_0)))
		
		return false
	end
	
	local var_12_1 = arg_12_0.pos
	
	arg_12_0.pos = var_12_0
	
	arg_12_0:interfaceCall("setPos", table.clone(arg_12_0.pos), var_12_1, arg_12_3)
	
	return true
end

function HTBMovableData.getName(arg_13_0)
	return arg_13_0.name
end

function HTBMovableData.getLeaderCode(arg_14_0)
	return arg_14_0.leader_code
end

function HTBMovableData.getBorderCode(arg_15_0)
	return arg_15_0.border_code
end

function HTBMovableData.getPos(arg_16_0)
	return arg_16_0.pos
end

function HTBMovableData.getLastMoveTm(arg_17_0)
	return arg_17_0.last_move_tm or 0
end

function HTBMovableData.updateLastMoveTm(arg_18_0, arg_18_1)
	arg_18_0.last_move_tm = to_n(arg_18_1)
end

function HTBMovableData.getExp(arg_19_0)
	return arg_19_0.exp
end

function HTBMovableData.updateExp(arg_20_0, arg_20_1)
	arg_20_0.exp = arg_20_1
end

function HTBMovableData.getUID(arg_21_0)
	return arg_21_0.id
end
