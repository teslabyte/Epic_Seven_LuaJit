HTBTileMapData = ClassDef()

function HTBGenTileMap(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = {}
	local var_1_2 = {}
	local var_1_3 = 0
	local var_1_4 = 0
	local var_1_5 = 9999999
	local var_1_6 = 99999999
	
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		local var_1_7 = iter_1_1:getPos()
		
		if not var_1_0[var_1_7.y] then
			var_1_0[var_1_7.y] = {}
		end
		
		var_1_0[var_1_7.y][var_1_7.x] = iter_1_1
		
		local var_1_8 = iter_1_1:getType()
		
		if not var_1_1[var_1_8] then
			var_1_1[var_1_8] = {}
		end
		
		local var_1_9 = iter_1_1:getTileId()
		
		if var_1_2[var_1_9] then
			error("TILE ID ALREDY EXIST")
		end
		
		var_1_2[var_1_9] = iter_1_1
		
		table.insert(var_1_1[var_1_8], iter_1_1)
		
		var_1_3 = math.max(var_1_7.x, var_1_3)
		var_1_4 = math.max(var_1_7.y, var_1_4)
		var_1_5 = math.min(var_1_7.x, var_1_5)
		var_1_6 = math.min(var_1_7.y, var_1_6)
	end
	
	return var_1_0, var_1_2, var_1_1, var_1_5, var_1_6, var_1_3, var_1_4
end

function HTBTileMapData.constructor(arg_2_0, arg_2_1, arg_2_2)
	print("theme, map_id? ", arg_2_1, arg_2_2)
	
	arg_2_0.theme = arg_2_1
	
	arg_2_0:loadNextMap(arg_2_2)
end

function HTBTileMapData.loadNextMap_Core(arg_3_0, arg_3_1)
	local var_3_0
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4, var_3_5, var_3_6, var_3_7
	
	arg_3_0.tile_map, arg_3_0.tile_id_hash_map, arg_3_0.tile_types_hash_map, var_3_4, var_3_5, var_3_6, var_3_7 = HTBGenTileMap(arg_3_1)
	arg_3_0.tile_width = var_3_6 - var_3_4
	arg_3_0.tile_height = var_3_7 - var_3_5
	arg_3_0.min_x = var_3_4
	arg_3_0.min_y = var_3_5
	arg_3_0.max_x = var_3_6
	arg_3_0.max_y = var_3_7
end

function HTBTileMapData.loadNextMap(arg_4_0, arg_4_1)
	arg_4_0.tiles = load_next_map(arg_4_1)
	
	arg_4_0:loadNextMap_Core(arg_4_0.tiles)
end

function HTBTileMapData.getWidth(arg_5_0)
	return arg_5_0.tile_width
end

function HTBTileMapData.getHeight(arg_6_0)
	return arg_6_0.tile_height
end

function HTBTileMapData.getMinX(arg_7_0)
	return arg_7_0.min_x
end

function HTBTileMapData.getMaxX(arg_8_0)
	return arg_8_0.max_x
end

function HTBTileMapData.getMinY(arg_9_0)
	return arg_9_0.min_y
end

function HTBTileMapData.getMaxY(arg_10_0)
	return arg_10_0.max_y
end

function HTBTileMapData.getLength(arg_11_0)
	return table.count(arg_11_0.tiles)
end

function HTBTileMapData.getTileByIndex(arg_12_0, arg_12_1)
	return arg_12_0.tiles[arg_12_1]
end

function HTBTileMapData.getTileByPos(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.x
	local var_13_1 = arg_13_1.y
	
	if not arg_13_0.tile_map[var_13_1] then
		return nil
	end
	
	if not arg_13_0.tile_map[var_13_1][var_13_0] then
		return nil
	end
	
	return arg_13_0.tile_map[var_13_1][var_13_0]
end

function HTBTileMapData.getTileIdByPos(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:getTileByPos(arg_14_1)
	
	if not var_14_0 then
		return nil
	end
	
	return var_14_0:getTileId()
end

function HTBTileMapData.getTileById(arg_15_0, arg_15_1)
	return arg_15_0.tile_id_hash_map[arg_15_1]
end

function HTBTileMapData.getTilesArrayByType(arg_16_0, arg_16_1)
	return arg_16_0.tile_types_hash_map[arg_16_1]
end
