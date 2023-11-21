LotaBattleData = ClassDef()
LotaRewardStateEnum = {
	PROGRESS = 0,
	CLEAR = 1,
	RECEIVE = 2
}
LotaBattleDataInterface = {
	battle_id = "",
	tile_id = "",
	room = {
		battle_id = "24",
		floor = 1,
		creator = 0,
		last_hp = 0,
		dead = false,
		tile_id = -1,
		create = 0,
		state = LotaRewardStateEnum.PROGRESS,
		invitee = {}
	},
	user = {
		enter_count = 1,
		state = 0
	}
}

function LotaBattleData.constructor(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0[iter_1_0] = iter_1_1
	end
end

function LotaBattleData.updateRoomInfo(arg_2_0, arg_2_1)
	arg_2_0.room = arg_2_1
end

function LotaBattleData.updateInfo(arg_3_0, arg_3_1)
	arg_3_0.room = table.clone(arg_3_1.room)
	arg_3_0.user = table.clone(arg_3_1.user)
end

function LotaBattleData.getInvitee(arg_4_0)
	return arg_4_0.room.invitee
end

function LotaBattleData.getObjectId(arg_5_0)
	return arg_5_0.room and arg_5_0.room.object_id or nil
end

function LotaBattleData.getHPStatus(arg_6_0)
	local var_6_0 = arg_6_0.room.last_hp or 0
	local var_6_1 = arg_6_0.room and arg_6_0.room.max_hp or 0
	
	return var_6_0, var_6_1
end

function LotaBattleData.isUserAvailableReceiveReward(arg_7_0)
	return arg_7_0.user ~= nil and not table.empty(arg_7_0.user)
end

function LotaBattleData.isUserReceiveReward(arg_8_0)
	if arg_8_0.user and arg_8_0.user.state then
		return arg_8_0.user.state ~= 0
	end
	
	return false
end

function LotaBattleData.getFloor(arg_9_0)
	return arg_9_0.room.floor
end

function LotaBattleData.isBossDead(arg_10_0)
	return arg_10_0.room.dead == true
end

function LotaBattleData.getBattleId(arg_11_0)
	return arg_11_0.battle_id
end

function LotaBattleData.getTileId(arg_12_0)
	return arg_12_0.room.tile_id
end
