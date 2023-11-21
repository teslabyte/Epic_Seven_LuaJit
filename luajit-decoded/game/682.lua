LotaMovableData = ClassDef()
LotaMovableDataInterface = {
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
LotaMovableDataNotifyInterface = {
	setPos = "onSetPos",
	checkPos = "onCheckPos"
}

local var_0_0 = {
	onSetPos = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		if arg_1_0 and arg_1_0.onSetPos then
			arg_1_0:onSetPos(arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		end
	end,
	onCheckPos = function(arg_2_0, arg_2_1, arg_2_2)
		if arg_2_0 and arg_2_0.onCheckPos then
			return arg_2_0:onCheckPos(arg_2_1, arg_2_2)
		end
		
		Log.e("WARN. NOT CHECKED.")
		
		return true
	end
}

function LotaMovableData.interfaceCall(arg_3_0, arg_3_1, ...)
	return var_0_0[LotaMovableDataNotifyInterface[arg_3_1]](arg_3_0.notify_object, arg_3_0, ...)
end

function LotaMovableData.constructor(arg_4_0, arg_4_1, arg_4_2)
	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		arg_4_0[iter_4_0] = iter_4_1
	end
	
	arg_4_0.last_move_tm = 0
end

function LotaMovableData.notifyObject(arg_5_0, arg_5_1)
	arg_5_0.notify_object = arg_5_1
end

function LotaMovableData.getType(arg_6_0)
	return arg_6_0.type
end

function LotaMovableData.setPosX(arg_7_0, arg_7_1)
	arg_7_0:setPos(arg_7_1, arg_7_0.pos.y)
end

function LotaMovableData.setPosY(arg_8_0, arg_8_1)
	arg_8_0:setPos(arg_8_0.pos.x, arg_8_1)
end

function LotaMovableData.getUserID(arg_9_0)
	return arg_9_0.user_id
end

function LotaMovableData.checkPos(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {
		x = arg_10_1,
		y = arg_10_2
	}
	
	return arg_10_0:interfaceCall("checkPos", var_10_0)
end

function LotaMovableData.setPos(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = {
		x = arg_11_1,
		y = arg_11_2
	}
	
	if not arg_11_0:interfaceCall("checkPos", table.clone(var_11_0)) then
		table.print(var_11_0)
		print("checkPos! checkPos! checkPos!", arg_11_0:interfaceCall("checkPos", table.clone(var_11_0)))
		
		return false
	end
	
	local var_11_1 = arg_11_0.pos
	
	arg_11_0.pos = var_11_0
	
	arg_11_0:interfaceCall("setPos", table.clone(arg_11_0.pos), var_11_1, arg_11_3)
	
	return true
end

function LotaMovableData.getName(arg_12_0)
	return arg_12_0.name
end

function LotaMovableData.getLeaderCode(arg_13_0)
	return arg_13_0.leader_code
end

function LotaMovableData.getBorderCode(arg_14_0)
	return arg_14_0.border_code
end

function LotaMovableData.getPos(arg_15_0)
	return arg_15_0.pos
end

function LotaMovableData.getLastMoveTm(arg_16_0)
	return arg_16_0.last_move_tm or 0
end

function LotaMovableData.updateLastMoveTm(arg_17_0, arg_17_1)
	arg_17_0.last_move_tm = to_n(arg_17_1)
end

function LotaMovableData.getLevel(arg_18_0)
	local var_18_0 = arg_18_0.exp or 0
	
	return LotaUtil:getUserLevel(var_18_0)
end

function LotaMovableData.getExp(arg_19_0)
	return arg_19_0.exp
end

function LotaMovableData.updateExp(arg_20_0, arg_20_1)
	arg_20_0.exp = arg_20_1
end

function LotaMovableData.getUID(arg_21_0)
	return arg_21_0.id
end
