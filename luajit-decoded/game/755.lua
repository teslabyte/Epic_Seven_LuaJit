SPLTileData = ClassDef(HTBTileData)

function SPLTileData.constructor(arg_1_0, arg_1_1)
	arg_1_0:base_constructor(arg_1_1, "tile_sub_tile_texture")
end

function SPLTileData.isExistObject(arg_2_0)
	if arg_2_0.inst == nil then
		return false
	end
	
	if arg_2_0.inst.object_id == nil then
		return false
	end
	
	local var_2_0 = SPLObjectSystem:getObject(arg_2_0.inst.object_id)
	
	if var_2_0:getType() == "empty" or var_2_0:getType() == "overlap" then
		return false
	end
	
	return true
end

function SPLTileData.isExistOverlap(arg_3_0)
	if arg_3_0.inst == nil then
		return false
	end
	
	if arg_3_0.inst.object_id == nil then
		return false
	end
	
	if SPLObjectSystem:getObject(arg_3_0.inst.object_id):getType() == "overlap" then
		return true
	end
	
	return false
end

function SPLTileData.isMovable(arg_4_0, arg_4_1)
	local var_4_0
	
	if arg_4_0:isExistObject() and arg_4_1 then
		return true
	end
	
	if arg_4_0:isExistObject() or arg_4_0:isExistOverlap() then
		return false
	end
	
	if arg_4_0.movable_condition == "always" then
		var_4_0 = arg_4_0.condition_result_value
	end
	
	return var_4_0 == "move"
end
