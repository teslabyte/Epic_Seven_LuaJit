LotaPingData = ClassDef()
LotaPingInterface = {
	ping_number = 0,
	floor = "",
	tile_id = ""
}

function LotaPingData.constructor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.ping_number = arg_1_1
	
	arg_1_0:updateByInfo(arg_1_2)
end

function LotaPingData.updateByInfo(arg_2_0, arg_2_1)
	arg_2_0.tile_id = arg_2_1
	arg_2_0.floor = LotaUserData:getFloor()
end

function LotaPingData.isPingValid(arg_3_0)
	return arg_3_0.tile_id ~= -1 and arg_3_0.floor ~= -1
end

function LotaPingData.getPingNumber(arg_4_0)
	return arg_4_0.ping_number
end

function LotaPingData.getTileId(arg_5_0)
	return arg_5_0.tile_id
end

function LotaPingData.getFloor(arg_6_0)
	return arg_6_0.floor
end
