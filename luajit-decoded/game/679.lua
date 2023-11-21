LotaTileData = ClassDef()
LotaTileInfoInterface = {
	condition_result_value = true,
	type = "grass",
	id = 1,
	movable_condition = "always",
	pos = {
		x = 0,
		y = 0
	},
	inst = {}
}

function LotaTileData.constructor(arg_1_0, arg_1_1, arg_1_2)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0[iter_1_0] = iter_1_1
	end
	
	local var_1_0 = arg_1_0.tile
	
	if var_1_0 then
		local var_1_1, var_1_2, var_1_3, var_1_4 = DB("clan_heritage_tile_texture", var_1_0, {
			"resource",
			"move_type",
			"type",
			"location_z"
		})
		local var_1_5 = string.split(var_1_2, ",")
		
		arg_1_0.movable_condition = var_1_5[1]
		arg_1_0.condition_result_value = var_1_5[2]
		arg_1_0.resource = var_1_1
		arg_1_0.type = var_1_3
		arg_1_0.location_z = var_1_4
	end
end

function LotaTileData.getResource(arg_2_0)
	return arg_2_0.resource
end

function LotaTileData.setType(arg_3_0, arg_3_1)
	if arg_3_1 == "lava" then
		arg_3_0.movable = false
	end
	
	arg_3_0.type = arg_3_1
end

function LotaTileData.getTileId(arg_4_0)
	return tostring(arg_4_0.id)
end

function LotaTileData.getLocationZ(arg_5_0)
	return arg_5_0.location_z
end

function LotaTileData.setObjectId(arg_6_0, arg_6_1)
	if arg_6_1 == nil then
		arg_6_0.inst.object_id = nil
	else
		arg_6_0.inst.object_id = tostring(arg_6_1)
	end
end

function LotaTileData.getObjectId(arg_7_0)
	return arg_7_0.inst.object_id
end

function LotaTileData.isExistObject(arg_8_0)
	if arg_8_0.inst == nil then
		return false
	end
	
	if arg_8_0.inst.object_id == nil then
		return false
	end
	
	local var_8_0 = LotaObjectSystem:getObject(arg_8_0.inst.object_id)
	
	if var_8_0:getTypeDetail() == "overlap" then
		return false
	end
	
	if var_8_0 and var_8_0:isMonsterType() and not var_8_0:isActive() then
		return false
	end
	
	return true
end

function LotaTileData.getType(arg_9_0)
	return arg_9_0.type
end

function LotaTileData.getPos(arg_10_0)
	return arg_10_0.pos
end

local var_0_0 = {
	disable = "move",
	move = "disable"
}

function LotaTileData.isMovable(arg_11_0, arg_11_1)
	local var_11_0
	
	if arg_11_0:isExistObject() and arg_11_1 then
		return true
	end
	
	if arg_11_0:isExistObject() then
		return false
	end
	
	if arg_11_0.movable_condition == "always" then
		var_11_0 = arg_11_0.condition_result_value
	elseif arg_11_0.movable_condition == "bossopen" then
		var_11_0 = var_0_0[arg_11_0.condition_result_value]
	end
	
	if arg_11_0.type == "boss" and not LotaUtil:isBossActive() then
		var_11_0 = "disable"
	end
	
	return var_11_0 == "move"
end
