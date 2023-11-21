LotaTileMapSystem = {}
TileMoveFailedReasons = {
	TILE_NOT_EXIST = "TILE_NOT_EXIST",
	TILE_NOT_MOVABLE = "TILE_NOT_MOVABLE"
}
LotaTileMapSystemInterface = {
	onCheckPos = function(arg_1_0)
		return LotaTileMapSystem:onCheckPos(arg_1_0)
	end
}

function LotaTileMapSystem.init(arg_2_0, arg_2_1, arg_2_2)
	LotaSystem:_addDebugPerformanceTracker("LotaTileMapSystem_init", "start")
	
	arg_2_0.vars = {}
	arg_2_0.vars.tile_map_data = LotaTileMapData(nil, arg_2_2)
	arg_2_0.vars.field_layer = arg_2_1
	
	LotaWhiteboard:set("map_min_x", arg_2_0.vars.tile_map_data:getMinX())
	LotaWhiteboard:set("map_max_x", arg_2_0.vars.tile_map_data:getMaxX())
	LotaWhiteboard:set("map_min_y", arg_2_0.vars.tile_map_data:getMinY())
	LotaWhiteboard:set("map_max_y", arg_2_0.vars.tile_map_data:getMaxY())
	LotaSystem:_addDebugPerformanceTracker("LotaTileMapSystem_init:LotaTileRenderer", "start")
	LotaTileRenderer:init(arg_2_1)
	LotaTileRenderer:draw(arg_2_0.vars.tile_map_data)
	LotaSystem:_addDebugPerformanceTracker("LotaTileMapSystem_init:LotaTileRenderer", "end")
	LotaSystem:_addDebugPerformanceTracker("LotaTileMapSystem_init", "end")
end

function LotaTileMapSystem.onCheckPos(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0.vars.tile_map_data:getTileByPos(arg_3_1)
	
	if not var_3_0 then
		return false, TileMoveFailedReasons.TILE_NOT_EXIST
	end
	
	if not var_3_0:isMovable(arg_3_2) then
		return false, TileMoveFailedReasons.TILE_NOT_MOVABLE
	end
	
	return true
end

function LotaTileMapSystem.toNormalZero(arg_4_0, arg_4_1)
	if arg_4_1 == 0 then
		return 0
	end
	
	return arg_4_1
end

function LotaTileMapSystem.getRandomStartPosition(arg_5_0, arg_5_1)
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(LotaUtil.MovablePaths) do
		local var_5_1 = LotaUtil:getAddedPosition(arg_5_1, iter_5_1)
		local var_5_2 = arg_5_0.vars.tile_map_data:getTileByPos(var_5_1)
		
		if var_5_2 and var_5_2:isMovable() then
			table.insert(var_5_0, var_5_2)
		end
	end
	
	table.shuffle(var_5_0)
	
	return var_5_0[1]
end

function LotaTileMapSystem.detachObject(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.tile_map_data:getTileById(tostring(arg_6_1))
	
	if not var_6_0 then
		print("CAN'T.  TILE IS NOT EXISTS.")
	end
	
	var_6_0:setObjectId(nil)
end

function LotaTileMapSystem.attachObject(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.vars.tile_map_data:getTileById(arg_7_1)
	
	if not var_7_0 then
		print("CAN'T.  TILE IS NOT EXISTS.")
	end
	
	var_7_0:setObjectId(arg_7_2)
end

function LotaTileMapSystem.getPosById(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:getTileById(arg_8_1)
	
	if not var_8_0 then
		return 
	end
	
	return var_8_0:getPos()
end

function LotaTileMapSystem.getTileMapData(arg_9_0)
	return arg_9_0.vars.tile_map_data
end

function LotaTileMapSystem.getTileByPos(arg_10_0, arg_10_1)
	return arg_10_0.vars.tile_map_data:getTileByPos(arg_10_1)
end

function LotaTileMapSystem.getTileById(arg_11_0, arg_11_1)
	arg_11_1 = tostring(arg_11_1)
	
	return arg_11_0.vars.tile_map_data:getTileById(arg_11_1)
end

function LotaTileMapSystem.getTileIdByPos(arg_12_0, arg_12_1)
	return arg_12_0.vars.tile_map_data:getTileIdByPos(arg_12_1)
end

function LotaTileMapSystem.getBossRoomPositionByIdx(arg_13_0, arg_13_1)
	return arg_13_0.vars.tile_map_data:getTilesArrayByType("boss")[arg_13_1]
end

function LotaTileMapSystem.getStartPositionByIdx(arg_14_0, arg_14_1)
	return arg_14_0.vars.tile_map_data:getTilesArrayByType("start")[arg_14_1]
end

function LotaTileMapSystem.getRandomStartPositionByTileId(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:getTileById(arg_15_1)
	
	return arg_15_0:getRandomStartPosition(var_15_0:getPos())
end

function LotaTileMapSystem.getRandomStartPositionByIdx(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:getStartPositionByIdx(arg_16_1)
	
	return arg_16_0:getRandomStartPosition(var_16_0:getPos())
end

function LotaTileMapSystem.drawInteractionArea(arg_17_0)
	LotaTileRenderer:drawInteractionArea(arg_17_0.vars.tile_map_data)
end

function LotaTileMapSystem.loadNextMap(arg_18_0)
	arg_18_0.vars.tile_map_data:loadNextMap()
	LotaTileRenderer:release()
	LotaTileRenderer:draw(arg_18_0.vars.tile_map_data)
	print("BUG")
end

function LotaTileMapSystem.getWorldPosOriginPos(arg_19_0)
	return arg_19_0.vars.field_layer:convertToWorldSpace({
		x = 0,
		y = 0
	})
end

function LotaTileMapSystem.calcWorldPosToTilePos(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = LotaWhiteboard:get("tile_width")
	local var_20_1 = LotaWhiteboard:get("tile_height")
	
	arg_20_1.y = arg_20_1.y - 100
	
	local var_20_2 = 60
	local var_20_3 = arg_20_1.x / (var_20_0 / 2)
	local var_20_4 = arg_20_1.y / (var_20_1 / 2)
	local var_20_5 = arg_20_0:toNormalZero(math.floor(var_20_3))
	local var_20_6 = arg_20_0:toNormalZero(math.ceil(var_20_3))
	local var_20_7 = arg_20_0:toNormalZero(math.floor(var_20_4))
	local var_20_8 = arg_20_0:toNormalZero(math.ceil(var_20_4))
	local var_20_9 = {
		{
			x = var_20_5,
			y = var_20_7
		},
		{
			x = var_20_5,
			y = var_20_8
		},
		{
			x = var_20_6,
			y = var_20_7
		},
		{
			x = var_20_6,
			y = var_20_8
		}
	}
	local var_20_10 = 99999999
	local var_20_11
	local var_20_12 = {}
	local var_20_13 = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_9) do
		if arg_20_0.vars.tile_map_data:getTileByPos(iter_20_1) and LotaTileRenderer:getTileSprite(iter_20_1) or arg_20_2 then
			local var_20_14 = iter_20_1.x * var_20_0 / 2
			local var_20_15 = iter_20_1.y * var_20_1 / 2
			
			var_20_12[iter_20_0] = {
				sp_x = var_20_14,
				sp_y = var_20_15
			}
			
			local var_20_16 = var_20_15 - arg_20_1.y
			
			var_20_13[iter_20_0] = var_20_16
			
			if math.abs(var_20_16) < var_20_2 / 2 then
				local var_20_17 = math.pow(var_20_14 - arg_20_1.x, 2) + math.pow(var_20_15 - arg_20_1.y, 2)
				
				if var_20_17 < var_20_10 then
					var_20_11 = iter_20_1
					var_20_10 = var_20_17
				end
			end
		end
	end
	
	if DEBUG.TILE_COLLISION_CHECK then
		MTV:setTbl({
			push_pos = arg_20_1,
			min_pos = var_20_11,
			min_dist = var_20_10,
			usable_tiles = var_20_9,
			usable_tiles_real_pos = var_20_12,
			usable_tile_y_dist = var_20_13
		}, "Tile Pos")
	end
	
	return var_20_11
end

function LotaTileMapSystem.close(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	LotaTileRenderer:close()
	
	arg_21_0.vars = nil
end
