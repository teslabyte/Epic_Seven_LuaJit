LotaBattleDataSystem = {}

function LotaBattleDataSystem.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.tile_id_to_reward_data = {}
	arg_1_0.vars.battle_id_to_reward_data = {}
end

function LotaBattleDataSystem.addReward(arg_2_0, arg_2_1)
	local var_2_0 = LotaUtil:createBattleData(arg_2_1)
	
	arg_2_0.vars.battle_id_to_reward_data[tostring(var_2_0:getBattleId())] = var_2_0
end

function LotaBattleDataSystem.isActiveRewardExist(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.battle_id_to_reward_data) do
		local var_3_0 = iter_3_1:getObjectId()
		
		if DB("clan_heritage_object_data", var_3_0, "type_2") == "boss_monster" then
		elseif iter_3_1:isBossDead() and iter_3_1:isUserAvailableReceiveReward() and not iter_3_1:isUserReceiveReward() then
			return true
		end
	end
	
	return false
end

function LotaBattleDataSystem.getActiveRewardList(arg_4_0)
	local var_4_0 = {}
	
	local function var_4_1(arg_5_0, arg_5_1)
		local var_5_0 = arg_5_0:getBattleId()
		local var_5_1 = string.split(var_5_0, ":")
		local var_5_2 = tostring(var_5_1[1])
		local var_5_3 = tostring(var_5_1[2])
		
		table.insert(var_4_0, {
			floor = var_5_2,
			tile_id = var_5_3,
			object_id = arg_5_1,
			battle_data = arg_5_0
		})
	end
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.battle_id_to_reward_data) do
		local var_4_2 = iter_4_1:getObjectId()
		
		if DB("clan_heritage_object_data", var_4_2, "type_2") == "boss_monster" then
			if not iter_4_1:isBossDead() then
				var_4_1(iter_4_1, var_4_2)
			end
		elseif iter_4_1:isUserAvailableReceiveReward() and not iter_4_1:isUserReceiveReward() then
			var_4_1(iter_4_1, var_4_2)
		end
	end
	
	return var_4_0
end

function LotaBattleDataSystem.removeReward(arg_6_0, arg_6_1)
	if not arg_6_0.vars.battle_id_to_reward_data[arg_6_1] then
		Log.e("NOT EXIST REWARD BUT TRY REMOVE")
		
		return 
	end
	
	arg_6_0.vars.battle_id_to_reward_data[tostring(arg_6_1)] = nil
end

function LotaBattleDataSystem.updateRoomInfo(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.battle_id_to_reward_data[tostring(arg_7_1.battle_id)]
	
	if var_7_0 then
		var_7_0:updateRoomInfo(arg_7_1)
	else
		local var_7_1 = {
			room = arg_7_1,
			user = {}
		}
		
		arg_7_0:addReward(var_7_1)
	end
end

function LotaBattleDataSystem.updateReward(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.battle_id_to_reward_data[tostring(arg_8_1.battle_id)]
	
	if var_8_0 then
		var_8_0:updateInfo(arg_8_1)
	else
		arg_8_0:addReward(arg_8_1)
	end
	
	if not arg_8_2 then
		LotaUIMainLayer:updateSetVisibleNoti()
	end
end

function LotaBattleDataSystem.updateObjectRewardState(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		arg_9_0:updateRoomInfo(iter_9_1)
	end
	
	LotaUIMainLayer:updateSetVisibleNoti()
end

function LotaBattleDataSystem.isExistReward(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	return arg_10_0.vars.battle_id_to_reward_data[tostring(arg_10_1)] ~= nil
end

function LotaBattleDataSystem.getBattleData(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	return arg_11_0.vars.battle_id_to_reward_data[tostring(arg_11_1)]
end

function LotaBattleDataSystem.getBattleDataByTileId(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = LotaUserData:getFloor() .. ":" .. arg_12_1
	local var_12_1 = arg_12_0.vars.battle_id_to_reward_data[var_12_0]
	
	if not var_12_1 then
		local var_12_2 = var_12_0 .. ":" .. tostring(arg_12_2)
		
		var_12_1 = arg_12_0.vars.battle_id_to_reward_data[var_12_2]
	end
	
	return var_12_1
end

function LotaBattleDataSystem.isBossDeadByTileId(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.vars then
		return 
	end
	
	local var_13_0 = LotaUserData:getFloor() .. ":" .. arg_13_1
	local var_13_1 = arg_13_0.vars.battle_id_to_reward_data[var_13_0]
	
	if not var_13_1 then
		local var_13_2 = var_13_0 .. ":" .. tostring(arg_13_2)
		
		var_13_1 = arg_13_0.vars.battle_id_to_reward_data[var_13_2]
	end
	
	if var_13_1 then
		return var_13_1:isBossDead()
	end
	
	return nil
end

function LotaBattleDataSystem.isBossDeadByObjectId(arg_14_0, arg_14_1)
	if not arg_14_0.vars then
		return 
	end
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.battle_id_to_reward_data) do
		if arg_14_1 == iter_14_1:getObjectId() then
			return iter_14_1:isBossDead()
		end
	end
	
	return false
end

function LotaBattleDataSystem.battleIdToTileId(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.battle_id_to_reward_data[tostring(arg_15_1)]
	
	if not var_15_0 then
		return nil
	end
	
	if tostring(var_15_0:getFloor()) ~= tostring(LotaUserData:getFloor()) then
		return nil
	end
	
	return var_15_0:getTileId()
end

function LotaBattleDataSystem.tileIdToBattleId(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = LotaUserData:getFloor() .. ":" .. arg_16_1
	local var_16_1 = arg_16_0.vars.battle_id_to_reward_data[var_16_0]
	
	if not var_16_1 then
		local var_16_2 = var_16_0 .. ":" .. tostring(arg_16_2)
		
		var_16_1 = arg_16_0.vars.battle_id_to_reward_data[var_16_2]
	end
	
	if not var_16_1 then
		return nil
	end
	
	return var_16_1:getBattleId()
end

function LotaBattleDataSystem.close(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	arg_17_0.vars = nil
end
