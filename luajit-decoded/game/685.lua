LotaBattleSlotData = ClassDef()
LotaBattleSlotDataInterface = {
	inst = {
		slot_user_1 = 2424,
		floor = 1,
		slot_user_3 = 2424,
		slot_tm_1 = 2424,
		clan_id = 4242,
		object_id = "",
		season_id = "",
		tile_id = "",
		slot_user_2 = 2424,
		slot_tm_2 = 2424,
		slot_tm_3 = 2424
	}
}

function LotaBattleSlotData.constructor(arg_1_0, arg_1_1)
	arg_1_1.tile_id = tostring(arg_1_1.tile_id)
	arg_1_0.inst = arg_1_1 or {}
end

function LotaBattleSlotData.getTileId(arg_2_0)
	return arg_2_0.inst.tile_id
end

function LotaBattleSlotData.getFloor(arg_3_0)
	return tostring(arg_3_0.inst.floor)
end

function LotaBattleSlotData.getTmAndUser(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.inst["slot_tm_" .. tostring(arg_4_1)]
	local var_4_1 = arg_4_0.inst["slot_user_" .. tostring(arg_4_1)]
	
	return var_4_0, var_4_1
end

function LotaBattleSlotData.getSlotData(arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = arg_5_0:getTmAndUser(arg_5_0, arg_5_1)
	
	if not var_5_0 or not var_5_1 then
		return 
	end
	
	return {
		idx = arg_5_1,
		tm = to_n(var_5_0),
		user = tostring(var_5_1)
	}
end

function LotaBattleSlotData.isExistSlot(arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = arg_6_0:getTmAndUser(arg_6_1)
	
	if not var_6_0 or not var_6_1 then
		return false
	end
	
	return to_n(var_6_0) > os.time() - 3600
end

function LotaBattleSlotData.getSlotMaxCount(arg_7_0)
	return 3
end

function LotaBattleSlotData.isAvailableEnter(arg_8_0, arg_8_1)
	return arg_8_1 > arg_8_0:getSlotUserCount()
end

function LotaBattleSlotData.getSlotUserCount(arg_9_0)
	local var_9_0 = 0
	
	for iter_9_0 = 1, 3 do
		if arg_9_0:isExistSlot(iter_9_0) then
			var_9_0 = var_9_0 + 1
		end
	end
	
	return var_9_0
end
