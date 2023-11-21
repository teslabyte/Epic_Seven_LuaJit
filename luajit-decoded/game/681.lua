LotaFogMapData = ClassDef()

function LotaFogMapData.constructor(arg_1_0, arg_1_1)
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
		
		local var_1_4 = table.clone(LotaFogDataInterface)
		
		if not arg_1_0.fog_map[var_1_2] then
			arg_1_0.fog_map[var_1_2] = {}
		end
		
		var_1_4.visibility = LotaFogVisibilityEnum.NOT_DISCOVER
		var_1_4.pos = {
			x = var_1_1,
			y = var_1_2
		}
		
		local var_1_5 = LotaFogData(var_1_4)
		
		arg_1_0.fog_map[var_1_2][var_1_1] = var_1_5
		
		table.insert(arg_1_0.fog_list, arg_1_0.fog_map[var_1_2][var_1_1])
	end
	
	arg_1_0.updated_cnt = 0
	arg_1_0.player_visibility = {}
end

function LotaFogMapData.getFogDataByIdx(arg_2_0, arg_2_1)
	return arg_2_0.fog_list[arg_2_1]
end

function LotaFogMapData.setFogData(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = table.clone(LotaFogDataInterface)
	local var_3_1 = tonumber(arg_3_2)
	local var_3_2 = LotaFogVisibilityInvEnum[var_3_1 + 1]
	
	var_3_0.visibility = LotaFogVisibilityEnum[var_3_2]
	var_3_0.pos = {
		x = arg_3_1.x,
		y = arg_3_1.y
	}
	arg_3_0.fog_map[arg_3_1.y][arg_3_1.x] = LotaFogData(var_3_0)
end

function LotaFogMapData.setDiscover(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0.fog_map[arg_4_1.y]
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = var_4_0[arg_4_1.x]
	
	if not var_4_1 then
		return 
	end
	
	arg_4_2 = arg_4_2 or LotaFogVisibilityEnum.DISCOVER
	
	local var_4_2 = var_4_1:getVisibility()
	local var_4_3, var_4_4, var_4_5 = LotaObjectSystem:debug_lookUpTypes(arg_4_1)
	
	if var_4_3 == "y" and arg_4_2 >= LotaFogVisibilityEnum.DISCOVER then
		arg_4_4 = arg_4_4 or {}
		
		table.insert(arg_4_4, arg_4_1)
		arg_4_0:discoverFog(arg_4_1, 1, LotaFogVisibilityEnum.VISIBLE, arg_4_4)
		
		arg_4_2 = LotaFogVisibilityEnum.VISIBLE
	end
	
	if var_4_2 < arg_4_2 then
		var_4_1:setVisibility(arg_4_2)
		
		if arg_4_2 == LotaFogVisibilityEnum.VISIBLE or arg_4_2 == LotaFogVisibilityEnum.DISCOVER and LotaUtil:isDiscoverAllowType(var_4_4, var_4_5) then
			LotaObjectSystem:debug_findAndAdd(arg_4_1)
		end
		
		if arg_4_3 then
			return 
		end
		
		local var_4_6 = LotaTileMapSystem:getTileByPos(arg_4_1)
		
		if not var_4_6 then
			return 
		end
		
		local var_4_7 = LotaObjectSystem:getObject(var_4_6:getTileId())
		
		if not var_4_7 then
			return 
		end
		
		local var_4_8 = var_4_7:getChildTileList()
		
		if not var_4_8 then
			return 
		end
		
		local var_4_9 = LotaTileMapSystem:getTileById(var_4_7:getTileId())
		
		arg_4_0:setDiscover(var_4_9:getPos(), arg_4_2, true, arg_4_4)
		
		for iter_4_0, iter_4_1 in pairs(var_4_8) do
			local var_4_10 = LotaTileMapSystem:getTileById(iter_4_1)
			
			if var_4_10 then
				arg_4_0:setDiscover(var_4_10:getPos(), arg_4_2, true, arg_4_4)
			end
		end
	end
end

function LotaFogMapData.getHashKey(arg_5_0, arg_5_1)
	return arg_5_1.x .. "_" .. arg_5_1.y
end

function LotaFogMapData.getLastUpdatedCnt(arg_6_0)
	return arg_6_0.updated_cnt
end

function LotaFogMapData.discoverFog(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
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
	
	local var_7_1 = LotaUtil:getDiscoverRange(arg_7_1, arg_7_2)
	
	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if arg_7_4 then
			if not table.find(arg_7_4, function(arg_8_0, arg_8_1)
				return LotaUtil:isSamePosition(iter_7_1, arg_8_1)
			end) then
				arg_7_0:setDiscover(iter_7_1, arg_7_3, nil, arg_7_4)
			end
		else
			arg_7_0:setDiscover(iter_7_1, arg_7_3)
		end
	end
end

function LotaFogMapData.getFogDiscoveredList(arg_9_0)
	return arg_9_0.fog_discovered_list
end

function LotaFogMapData.getPlayerPos(arg_10_0)
	return arg_10_0.player_pos
end

function LotaFogMapData.getFogVisibility(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.fog_map[arg_11_2] and arg_11_0.fog_map[arg_11_2][arg_11_1] then
		return arg_11_0.fog_map[arg_11_2][arg_11_1]:getVisibility()
	end
	
	return nil
end
