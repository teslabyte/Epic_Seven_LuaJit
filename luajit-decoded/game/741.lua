HTBTileMapSystem = {}
HexTileMoveError = {
	TILE_NOT_EXIST = "TILE_NOT_EXIST",
	TILE_NOT_MOVABLE = "TILE_NOT_MOVABLE"
}

function HTBTileMapSystem.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0.vars = {}
	arg_1_0.vars.tile_map_data = HTBInterface:createTileMapData(arg_1_1, arg_1_6)
	arg_1_0.vars.field_layer = arg_1_5
	
	HTBInterface:whiteboardSet(arg_1_2, "map_min_x", arg_1_0.vars.tile_map_data:getMinX())
	HTBInterface:whiteboardSet(arg_1_2, "map_max_x", arg_1_0.vars.tile_map_data:getMaxX())
	HTBInterface:whiteboardSet(arg_1_2, "map_min_y", arg_1_0.vars.tile_map_data:getMinY())
	HTBInterface:whiteboardSet(arg_1_2, "map_max_y", arg_1_0.vars.tile_map_data:getMaxY())
	HTBInterface:tileRendererInit(arg_1_3, arg_1_5)
	HTBInterface:tileRendererDraw(arg_1_4, arg_1_0.vars.tile_map_data)
end

function HTBTileMapSystem.base_onCheckPos(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = HTBInterface:getTileByPos(arg_2_1, arg_2_2)
	
	if not var_2_0 then
		return false, HexTileMoveError.TILE_NOT_EXIST
	end
	
	if not var_2_0:isMovable(arg_2_3) then
		return false, HexTileMoveError.TILE_NOT_MOVABLE
	end
	
	return true
end

function HTBTileMapSystem.base_drawInteractionArea(arg_3_0, arg_3_1)
	HTBInterface:drawInteractionArea(arg_3_1, arg_3_0.vars.tile_map_data)
end

function HTBTileMapSystem.base_loadNextMap(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars.tile_map_data:loadNextMap()
	HTBInterface:tileRendererRelease(arg_4_1)
	HTBInterface:tileRendererDraw(arg_4_2, arg_4_0.vars.tile_map_data)
end

function HTBTileMapSystem.base_calcWorldPosToTilePos(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = HTBInterface:whiteboardGet(arg_5_1, "tile_width")
	local var_5_1 = HTBInterface:whiteboardGet(arg_5_1, "tile_height")
	
	arg_5_3.y = arg_5_3.y - 100
	
	local var_5_2 = 60
	local var_5_3 = arg_5_3.x / (var_5_0 / 2)
	local var_5_4 = arg_5_3.y / (var_5_1 / 2)
	local var_5_5 = arg_5_0:toNormalZero(math.floor(var_5_3))
	local var_5_6 = arg_5_0:toNormalZero(math.ceil(var_5_3))
	local var_5_7 = arg_5_0:toNormalZero(math.floor(var_5_4))
	local var_5_8 = arg_5_0:toNormalZero(math.ceil(var_5_4))
	local var_5_9 = {
		{
			x = var_5_5,
			y = var_5_7
		},
		{
			x = var_5_5,
			y = var_5_8
		},
		{
			x = var_5_6,
			y = var_5_7
		},
		{
			x = var_5_6,
			y = var_5_8
		}
	}
	local var_5_10 = 99999999
	local var_5_11
	local var_5_12 = {}
	local var_5_13 = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_9) do
		if arg_5_0.vars.tile_map_data:getTileByPos(iter_5_1) and HTBInterface:getTileSprite(arg_5_2, iter_5_1) or arg_5_4 then
			local var_5_14 = iter_5_1.x * var_5_0 / 2
			local var_5_15 = iter_5_1.y * var_5_1 / 2
			
			var_5_12[iter_5_0] = {
				sp_x = var_5_14,
				sp_y = var_5_15
			}
			
			local var_5_16 = var_5_15 - arg_5_3.y
			
			var_5_13[iter_5_0] = var_5_16
			
			if math.abs(var_5_16) < var_5_2 / 2 then
				local var_5_17 = math.pow(var_5_14 - arg_5_3.x, 2) + math.pow(var_5_15 - arg_5_3.y, 2)
				
				if var_5_17 < var_5_10 then
					var_5_11 = iter_5_1
					var_5_10 = var_5_17
				end
			end
		end
	end
	
	if DEBUG.TILE_COLLISION_CHECK then
		MTV:setTbl({
			push_pos = arg_5_3,
			min_pos = var_5_11,
			min_dist = var_5_10,
			usable_tiles = var_5_9,
			usable_tiles_real_pos = var_5_12,
			usable_tile_y_dist = var_5_13
		}, "Tile Pos")
	end
	
	return var_5_11
end

function HTBTileMapSystem.base_close(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	HTBInterface:tileRendererClose(arg_6_1)
	
	arg_6_0.vars = nil
end

function HTBTileMapSystem.toNormalZero(arg_7_0, arg_7_1)
	if arg_7_1 == 0 then
		return 0
	end
	
	return arg_7_1
end

function HTBTileMapSystem.getRandomStartPosition(arg_8_0, arg_8_1)
	local var_8_0 = {}
	
	for iter_8_0, iter_8_1 in pairs(HTUtil.MovablePaths) do
		local var_8_1 = HTUtil:getAddedPosition(arg_8_1, iter_8_1)
		local var_8_2 = arg_8_0.vars.tile_map_data:getTileByPos(var_8_1)
		
		if var_8_2 and var_8_2:isMovable() then
			table.insert(var_8_0, var_8_2)
		end
	end
	
	table.shuffle(var_8_0)
	
	return var_8_0[1]
end

function HTBTileMapSystem.detachObject(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.vars.tile_map_data:getTileById(tostring(arg_9_1))
	
	if not var_9_0 then
		print("CAN'T.  TILE IS NOT EXISTS.")
	end
	
	var_9_0:setObjectId(nil)
end

function HTBTileMapSystem.attachObject(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.vars.tile_map_data:getTileById(arg_10_1)
	
	if not var_10_0 then
		print("CAN'T.  TILE IS NOT EXISTS.")
	end
	
	var_10_0:setObjectId(arg_10_2)
end

function HTBTileMapSystem.getPosById(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getTileById(arg_11_1)
	
	if not var_11_0 then
		return 
	end
	
	return var_11_0:getPos()
end

function HTBTileMapSystem.getTileMapData(arg_12_0)
	return arg_12_0.vars.tile_map_data
end

function HTBTileMapSystem.getTileByPos(arg_13_0, arg_13_1)
	return arg_13_0.vars.tile_map_data:getTileByPos(arg_13_1)
end

function HTBTileMapSystem.getTileById(arg_14_0, arg_14_1)
	arg_14_1 = tostring(arg_14_1)
	
	return arg_14_0.vars.tile_map_data:getTileById(arg_14_1)
end

function HTBTileMapSystem.getTileIdByPos(arg_15_0, arg_15_1)
	return arg_15_0.vars.tile_map_data:getTileIdByPos(arg_15_1)
end

function HTBTileMapSystem.getBossRoomPositionByIdx(arg_16_0, arg_16_1)
	return arg_16_0.vars.tile_map_data:getTilesArrayByType("boss")[arg_16_1]
end

function HTBTileMapSystem.getStartPositionByIdx(arg_17_0, arg_17_1)
	return arg_17_0.vars.tile_map_data:getTilesArrayByType("start")[arg_17_1]
end

function HTBTileMapSystem.getRandomStartPositionByTileId(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:getTileById(arg_18_1)
	
	return arg_18_0:getRandomStartPosition(var_18_0:getPos())
end

function HTBTileMapSystem.getRandomStartPositionByIdx(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:getStartPositionByIdx(arg_19_1)
	
	return arg_19_0:getRandomStartPosition(var_19_0:getPos())
end

function HTBTileMapSystem.getWorldPosOriginPos(arg_20_0)
	return arg_20_0.vars.field_layer:convertToWorldSpace({
		x = 0,
		y = 0
	})
end
