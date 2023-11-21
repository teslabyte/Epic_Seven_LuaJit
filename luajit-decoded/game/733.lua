HTBMovableSystem = {}

function HTBMovableSystem.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0:initVariables()
	HTBInterface:movableRendererInit(arg_1_1, arg_1_2, arg_1_3, arg_1_0.vars.movable_manager)
end

function HTBMovableSystem.base_initVariables(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.move_to_path = {}
	arg_2_0.vars.move_idx = {}
	arg_2_0.vars.wait_to_draw = {}
	arg_2_0.vars.movable_manager = HTBInterface:movableManagerCreate(arg_2_1)
	arg_2_0.vars.current_player_id = nil
end

function HTBMovableSystem.base_releaseCurrentMapResource(arg_3_0, arg_3_1)
	arg_3_0.vars.movable_manager:releaseCurrentMapResource()
	arg_3_0:initVariables()
	HTBInterface:movableRendererRelease(arg_3_1)
end

function HTBMovableSystem.base_updateMovablesExp(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = false
	
	for iter_4_0, iter_4_1 in pairs(arg_4_3) do
		local var_4_1 = to_n(iter_4_1[1])
		
		if var_4_1 ~= AccountData.id then
			local var_4_2 = iter_4_1[2]
			local var_4_3 = arg_4_0:getMovableById(var_4_1)
			
			if var_4_3 then
				local var_4_4 = var_4_3:getLevel()
				
				var_4_3:updateExp(var_4_2)
				
				if var_4_4 ~= var_4_3:getLevel() then
					LotaMovableRenderer:addLevelUpEffect(var_4_3, nil)
					
					var_4_0 = true
				end
			end
		end
	end
	
	if var_4_0 then
		LotaGroupScrollView:updateItems()
	end
end

function HTBMovableSystem.base_updateMovableInfo(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_4.id
	
	if arg_5_0.vars.movable_manager:getMovableById(var_5_0) then
		arg_5_0.vars.movable_manager:removeMovableById(var_5_0)
		HTBInterface:movableRendererRemoveDrawObject(arg_5_1, var_5_0)
	elseif arg_5_0.vars.wait_to_draw[var_5_0] then
		arg_5_0.vars.wait_to_draw[var_5_0] = nil
	end
	
	if HTBInterface:isMovableCanCreate(arg_5_2, arg_5_4) then
		local var_5_1 = HTBInterface:getTileById(arg_5_3, arg_5_4.tile_id)
		
		if var_5_1 then
			arg_5_4.pos = var_5_1:getPos()
		end
	end
	
	arg_5_0:addMovable(arg_5_4)
end

function HTBMovableSystem.base_addMovable(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if HTBInterface:isMovableCanCreate(arg_6_1, arg_6_3, arg_6_4) then
		arg_6_0.vars.movable_manager:addMovable(arg_6_3)
		
		local var_6_0 = arg_6_0.vars.movable_manager:getMovableById(arg_6_3.id)
		
		HTBInterface:movableRendererAddDrawObject(arg_6_2, var_6_0)
	else
		arg_6_0.vars.wait_to_draw[arg_6_3.id] = arg_6_3
	end
end

function HTBMovableSystem.base_addWaitDrawMovable(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.vars.wait_to_draw[arg_7_2]
	
	if not var_7_0 then
		return 
	end
	
	var_7_0.pos = arg_7_3
	
	arg_7_0:addMovable(var_7_0)
	HTBInterface:onMovableAdd(arg_7_1, var_7_0)
	
	arg_7_0.vars.wait_to_draw[arg_7_2] = nil
end

function HTBMovableSystem.base_isWaitToDrawMovable(arg_8_0, arg_8_1)
	return arg_8_0.vars.wait_to_draw[arg_8_1] ~= nil
end

function HTBMovableSystem.base_onAfterMoveUpdate(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8)
	local var_9_0 = HTBInterface:isPlayerMovable(arg_9_1, arg_9_5)
	
	if arg_9_6 and var_9_0 then
		local var_9_1
		
		if arg_9_0.vars.artifact_effect_value then
			var_9_1 = arg_9_0.vars.artifact_effect_value
			arg_9_0.vars.artifact_effect_value = nil
		end
		
		HTBInterface:addMovableEffect(arg_9_2, arg_9_5, {
			{
				exp = arg_9_6,
				additional_exp = var_9_1
			}
		})
	end
	
	if var_9_0 then
		HTBInterface:onPlayerMovableMoved(arg_9_3, arg_9_5)
	end
	
	if arg_9_7 then
		HTBInterface:onPlayerLevelUp(arg_9_4, arg_9_5, arg_9_8)
	end
end

function HTBMovableSystem.base_isMovable(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_0.vars.movable_manager:getMovableById(arg_10_0.vars.current_player_id)
	
	arg_10_5 = arg_10_5 or HTBInterface:findPath(arg_10_1, var_10_0:getPos(), {
		x = arg_10_3,
		y = arg_10_4
	})
	
	local var_10_1 = #arg_10_5
	
	if not HTBInterface:checkMovableCost(arg_10_2, var_10_1) then
		return false
	end
	
	return true
end

function HTBMovableSystem.base_movePath(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10)
	local var_11_0 = arg_11_6:getUID()
	
	arg_11_6.is_running = true
	arg_11_0.vars.move_to_path[var_11_0] = arg_11_7
	arg_11_0.vars.move_idx[var_11_0] = 1
	
	local var_11_1
	
	if arg_11_8 then
		local var_11_2 = arg_11_8 / #arg_11_0.vars.move_to_path[var_11_0]
	end
	
	local var_11_3 = HTBInterface:getDrawObject(arg_11_1, arg_11_6)
	local var_11_4 = {}
	
	for iter_11_0 = 1, #arg_11_0.vars.move_to_path[var_11_0] do
		local var_11_5 = table.clone(arg_11_0.vars.move_to_path[var_11_0][iter_11_0])
		local var_11_6 = arg_11_0.vars.move_to_path[var_11_0][iter_11_0 - 1] or arg_11_6:getPos()
		local var_11_7 = table.clone(var_11_6)
		local var_11_8 = HTBInterface:calcTilePosToWorldPosForMovable(arg_11_2, var_11_3, var_11_7)
		local var_11_9 = HTBInterface:calcTilePosToWorldPosForMovable(arg_11_2, var_11_3, var_11_5)
		
		arg_11_6:setPos(var_11_7.x, var_11_7.y)
		table.insert(var_11_4, SEQ(CALL(function()
			arg_11_6:setPos(var_11_5.x, var_11_5.y)
		end), CALL(function()
			local var_13_0 = var_11_3.model
			
			if var_13_0 then
				local var_13_1 = math.abs(var_13_0:getScaleX())
				
				if var_11_9.x - var_11_8.x < 0 then
					var_13_1 = var_13_1 * -1
				end
				
				var_13_0:setScaleX(var_13_1)
			end
			
			HTBInterface:onAfterMovePath(arg_11_3, var_11_7, var_11_5)
		end), MOVE_TO(480, var_11_9.x, var_11_9.y), CALL(function()
			var_11_3:setLocalZOrder(var_11_5.y * -5 + 1)
			
			arg_11_6.is_running = nil
			
			LotaMovableRenderer:updateGroupView(var_11_5)
		end)))
	end
	
	local var_11_10
	
	if tostring(arg_11_6:getUID()) == tostring(AccountData.id) then
		var_11_10 = "block"
	end
	
	UIAction:Add(SEQ(SEQ(CALL(function()
		LotaMovableRenderer:startRunAnimation(arg_11_6)
	end), table.unpack(var_11_4)), SEQ(CALL(function()
		if arg_11_6:getUID() == arg_11_0.vars.current_player_id then
			arg_11_0:drawMovableArea()
		end
	end), CALL(function()
		arg_11_0:onAfterMoveUpdate(arg_11_6, arg_11_8, arg_11_9, arg_11_10)
	end), DELAY(60), CALL(function()
		LotaMovableRenderer:stopRunAnimation(arg_11_6)
	end))), var_11_3, var_11_10)
end

function HTBMovableSystem.base_calcPlayerRealCost(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.vars.movable_manager:getMovableById(arg_19_0.vars.current_player_id)
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = HTBInterface:findPath(arg_19_1, var_19_0:getPos(), arg_19_2)
	
	if not var_19_1 then
		return -1
	end
	
	return #var_19_1
end

function HTBMovableSystem.base_drawMovableArea(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_0 = arg_20_0.vars.movable_manager:getMovableById(arg_20_0.vars.current_player_id)
	
	if not var_20_0 then
		return 
	end
	
	arg_20_5 = arg_20_5 or HTBInterface:whiteboardGet(arg_20_1, "map_move_cell")
	
	local var_20_1 = var_20_0:getPos()
	local var_20_2 = HTBInterface:getReachableTiles(arg_20_2, var_20_1, arg_20_5, true) or {}
	
	table.insert(var_20_2, var_20_1)
	
	local var_20_3 = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_2) do
		local var_20_4 = HTBInterface:getTileByPos(arg_20_3, iter_20_1)
		
		if var_20_4 then
			table.insert(var_20_3, var_20_4)
		end
	end
	
	HTBInterface:drawMovableTiles(arg_20_4, var_20_3, arg_20_6)
end

function HTBMovableSystem.base_isPlayerOutScreen(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = HTBInterface:getCameraPos(arg_21_1)
	local var_21_1 = arg_21_0:getPlayerPos()
	
	if not var_21_1 then
		return false
	end
	
	local var_21_2 = HTBInterface:calcTilePosToWorldPos(arg_21_2, var_21_1)
	local var_21_3, var_21_4 = HTBInterface:calcWorldPosToCameraPos(arg_21_3, var_21_2)
	local var_21_5 = {
		x = var_21_3,
		y = var_21_4
	}
	local var_21_6 = HTUtil:getAbsPosition(HTUtil:getDecedPosition(var_21_5, var_21_0))
	
	return var_21_6.x > VIEW_WIDTH / 2 or var_21_6.y > VIEW_HEIGHT / 2
end

function HTBMovableSystem.base_close(arg_22_0, arg_22_1)
	if not arg_22_0.vars then
		return 
	end
	
	HTBInterface:movableRendererClose(arg_22_1)
	
	arg_22_0.vars = nil
end

function HTBMovableSystem.addEffectAfterMoveEnd(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_1 == "move_tile_add_exp" then
		arg_23_0.vars.artifact_effect_value = arg_23_2
	end
end

function HTBMovableSystem.isProcJumpPath(arg_24_0)
	return arg_24_0.vars and arg_24_0.vars.proc_jump_path
end

function HTBMovableSystem.getPlayerPos(arg_25_0)
	local var_25_0 = arg_25_0.vars.movable_manager:getMovableById(arg_25_0.vars.current_player_id)
	
	if not var_25_0 then
		return 
	end
	
	return var_25_0:getPos()
end

function HTBMovableSystem.calcPlayerMoveCost(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.vars.movable_manager:getMovableById(arg_26_0.vars.current_player_id)
	
	if not var_26_0 then
		return 
	end
	
	return HTUtil:getTileCost(var_26_0:getPos(), arg_26_1)
end

function HTBMovableSystem.isPlayerOnPos(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0:getPlayerPos()
	
	if not var_27_0 then
		return 
	end
	
	return HTUtil:isSamePosition(arg_27_1, var_27_0)
end

function HTBMovableSystem.addPlayerMovable(arg_28_0, arg_28_1)
	arg_28_0.vars.wait_to_draw[arg_28_1.id] = arg_28_1
	
	arg_28_0:addWaitDrawMovable(arg_28_1.id, arg_28_1.pos)
	
	arg_28_0.vars.current_player_id = arg_28_1.id
end

function HTBMovableSystem.getCurrentPlayerId(arg_29_0)
	return arg_29_0.vars.current_player_id
end

function HTBMovableSystem.getMovableById(arg_30_0, arg_30_1)
	return arg_30_0.vars.movable_manager:getMovableById(arg_30_1)
end

function HTBMovableSystem.getPlayerMovable(arg_31_0)
	return arg_31_0.vars.movable_manager:getMovableById(arg_31_0:getCurrentPlayerId())
end

function HTBMovableSystem.getMovablesByPos(arg_32_0, arg_32_1)
	return arg_32_0.vars.movable_manager:getMovablesByPos(arg_32_1)
end
