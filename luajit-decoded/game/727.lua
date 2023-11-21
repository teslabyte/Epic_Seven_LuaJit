HTBFogMapData = ClassDef()

function HTBFogMapData.constructor(arg_1_0, arg_1_1)
	arg_1_0.fog_map = {}
	arg_1_0.fog_list = {}
	arg_1_0.fog_discovered_list = {}
	arg_1_0.movable_paths = {
		{
			x = 1,
			y = 1
		},
		{
			x = 2,
			y = 0
		},
		{
			x = 1,
			y = -1
		},
		{
			x = -1,
			y = 1
		},
		{
			x = -2,
			y = 0
		},
		{
			x = -1,
			y = -1
		}
	}
	
	for iter_1_0 = 1, 9999 do
		local var_1_0, var_1_1, var_1_2, var_1_3 = DBN(arg_1_1, iter_1_0, {
			"id",
			"x",
			"y",
			"tile"
		})
		
		if not var_1_0 then
			break
		end
		
		local var_1_4 = table.clone(HTBFogDataInterface)
		
		if not arg_1_0.fog_map[var_1_2] then
			arg_1_0.fog_map[var_1_2] = {}
		end
		
		var_1_4.visibility = HTBFogVisibilityEnum.NOT_DISCOVER
		var_1_4.pos = {
			x = var_1_1,
			y = var_1_2
		}
		
		local var_1_5 = HTBFogData(var_1_4)
		
		arg_1_0.fog_map[var_1_2][var_1_1] = var_1_5
		
		table.insert(arg_1_0.fog_list, arg_1_0.fog_map[var_1_2][var_1_1])
	end
	
	arg_1_0.updated_cnt = 0
	arg_1_0.player_visibility = {}
end

function HTBFogMapData.base_setDiscover(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.fog_map[arg_2_4.y]
	
	if not var_2_0 then
		return 
	end
	
	local var_2_1 = var_2_0[arg_2_4.x]
	
	if not var_2_1 then
		return 
	end
	
	arg_2_5 = arg_2_5 or HTBFogVisibilityEnum.DISCOVER
	
	if arg_2_5 > var_2_1:getVisibility() then
		var_2_1:setVisibility(arg_2_5)
		
		if arg_2_6 then
			return 
		end
		
		local var_2_2 = HTBInterface:getTileByPos(arg_2_1, arg_2_4)
		
		if not var_2_2 then
			return 
		end
		
		local var_2_3 = HTBInterface:getObject(arg_2_3, var_2_2:getTileId())
		
		if not var_2_3 then
			return 
		end
		
		local var_2_4 = var_2_3:getChildTileList()
		
		if not var_2_4 then
			return 
		end
		
		local var_2_5 = HTBInterface:getTileById(arg_2_2, var_2_3:getTileId())
		
		arg_2_0:setDiscover(var_2_5:getPos(), arg_2_5, true, arg_2_7)
		
		for iter_2_0, iter_2_1 in pairs(var_2_4) do
			local var_2_6 = HTBInterface:getTileById(arg_2_2, iter_2_1)
			
			if var_2_6 then
				arg_2_0:setDiscover(var_2_6:getPos(), arg_2_5, true, arg_2_7)
			end
		end
	end
end

function HTBFogMapData.getFogDataByIdx(arg_3_0, arg_3_1)
	return arg_3_0.fog_list[arg_3_1]
end

function HTBFogMapData.setFogData(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = table.clone(HTBFogDataInterface)
	local var_4_1 = tonumber(arg_4_2)
	local var_4_2 = HTBFogVisibilityInvEnum[var_4_1 + 1]
	
	var_4_0.visibility = HTBFogVisibilityEnum[var_4_2]
	var_4_0.pos = {
		x = arg_4_1.x,
		y = arg_4_1.y
	}
	arg_4_0.fog_map[arg_4_1.y][arg_4_1.x] = HTBFogData(var_4_0)
end

function HTBFogMapData.getHashKey(arg_5_0, arg_5_1)
	return arg_5_1.x .. "_" .. arg_5_1.y
end

function HTBFogMapData.getLastUpdatedCnt(arg_6_0)
	return arg_6_0.updated_cnt
end

function HTBFogMapData.discoverFog(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_0:getHashKey(arg_7_1)
	
	if not arg_7_0.fog_discovered_list[var_7_0] or arg_7_3 > arg_7_0.fog_discovered_list[var_7_0].level or arg_7_2 > arg_7_0.fog_discovered_list[var_7_0].length then
		arg_7_0.updated_cnt = arg_7_0.updated_cnt + 1
		arg_7_0.fog_discovered_list[var_7_0] = {
			pos = arg_7_1,
			length = arg_7_2,
			level = arg_7_3,
			updated_cnt = arg_7_0.updated_cnt
		}
	else
		return 
	end
	
	local var_7_1 = HTUtil:getDiscoverRange(arg_7_1, arg_7_2)
	
	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if arg_7_4 then
			if not table.find(arg_7_4, function(arg_8_0, arg_8_1)
				return HTUtil:isSamePosition(iter_7_1, arg_8_1)
			end) then
				arg_7_0:setDiscover(iter_7_1, arg_7_3, nil, arg_7_4)
			end
		else
			arg_7_0:setDiscover(iter_7_1, arg_7_3)
		end
	end
end

function HTBFogMapData.getFogDiscoveredList(arg_9_0)
	return arg_9_0.fog_discovered_list
end

function HTBFogMapData.getPlayerPos(arg_10_0)
	return arg_10_0.player_pos
end

function HTBFogMapData.getFogVisibility(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.fog_map[arg_11_2] and arg_11_0.fog_map[arg_11_2][arg_11_1] then
		return arg_11_0.fog_map[arg_11_2][arg_11_1]:getVisibility()
	end
	
	return nil
end
