LotaBattleSlotSystem = {}

function LotaBattleSlotSystem.init(arg_1_0)
	arg_1_0.vars = {}
end

function LotaBattleSlotSystem.updateBattleSlots(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars.prv_battle_slot_hash = arg_2_0.vars.battle_slot_hash or {}
	arg_2_0.vars.last_info = arg_2_1
	arg_2_0.vars.battle_slot_hash = {}
	
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		local var_2_0 = LotaBattleSlotData(iter_2_1)
		
		if not arg_2_0.vars.battle_slot_hash[var_2_0:getFloor()] then
			arg_2_0.vars.battle_slot_hash[var_2_0:getFloor()] = {}
		end
		
		arg_2_0.vars.battle_slot_hash[var_2_0:getFloor()][var_2_0:getTileId()] = var_2_0
	end
	
	arg_2_0:requestUpdateObjectsUI()
end

function LotaBattleSlotSystem.requestUpdateObjectsUI(arg_3_0)
	local var_3_0 = arg_3_0.vars.prv_battle_slot_hash[tostring(LotaUserData:getFloor())] or {}
	local var_3_1 = arg_3_0.vars.battle_slot_hash[tostring(LotaUserData:getFloor())] or {}
	
	if table.empty(var_3_1) and table.empty(var_3_0) then
		return 
	end
	
	local var_3_2 = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		var_3_2[iter_3_1:getTileId()] = iter_3_1
	end
	
	for iter_3_2, iter_3_3 in pairs(var_3_0) do
		var_3_2[iter_3_3:getTileId()] = iter_3_3
	end
	
	for iter_3_4, iter_3_5 in pairs(var_3_2) do
		local var_3_3 = iter_3_5:getTileId()
		
		LotaObjectRenderer:updateObjectUI(var_3_3)
	end
end

function LotaBattleSlotSystem.getSlotData(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = tostring(arg_4_1)
	
	if not arg_4_0.vars or not arg_4_0.vars.battle_slot_hash or not arg_4_0.vars.battle_slot_hash[var_4_0] then
		return 
	end
	
	return arg_4_0.vars.battle_slot_hash[var_4_0][tostring(arg_4_2)]
end
