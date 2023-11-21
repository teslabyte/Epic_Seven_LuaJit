HTBTileData = ClassDef()

function HTBTileData.base_constructor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or "clan_heritage_tile_texture"
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0[iter_1_0] = iter_1_1
	end
	
	local var_1_0 = arg_1_0.tile
	
	if var_1_0 then
		local var_1_1, var_1_2, var_1_3, var_1_4 = DB(arg_1_2, var_1_0, {
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

function HTBTileData.base_isExistObject(arg_2_0, arg_2_1)
	if arg_2_0.inst == nil then
		return false
	end
	
	if arg_2_0.inst.object_id == nil then
		return false
	end
	
	local var_2_0 = HTBInterface:getObject(arg_2_1, arg_2_0.inst.object_id)
	
	if var_2_0:getTypeDetail() == "overlap" then
		return false
	end
	
	if var_2_0 and var_2_0:isMonsterType() and not var_2_0:isActive() then
		return false
	end
	
	return true
end

function HTBTileData.getResource(arg_3_0)
	return arg_3_0.resource
end

function HTBTileData.setType(arg_4_0, arg_4_1)
	if arg_4_1 == "lava" then
		arg_4_0.movable = false
	end
	
	arg_4_0.type = arg_4_1
end

function HTBTileData.getTileId(arg_5_0)
	return tostring(arg_5_0.id)
end

function HTBTileData.getLocationZ(arg_6_0)
	return arg_6_0.location_z
end

function HTBTileData.setObjectId(arg_7_0, arg_7_1)
	if arg_7_1 == nil then
		arg_7_0.inst.object_id = nil
	else
		arg_7_0.inst.object_id = tostring(arg_7_1)
	end
end

function HTBTileData.getObjectId(arg_8_0)
	return arg_8_0.inst.object_id
end

function HTBTileData.getType(arg_9_0)
	return arg_9_0.type
end

function HTBTileData.getPos(arg_10_0)
	return arg_10_0.pos
end

local var_0_0 = {
	disable = "move",
	move = "disable"
}

function HTBTileData.isMovable(arg_11_0, arg_11_1)
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
	
	if arg_11_0.type == "boss" then
	end
	
	return var_11_0 == "move"
end
