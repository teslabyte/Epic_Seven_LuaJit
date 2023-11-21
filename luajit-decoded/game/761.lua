SPLMovableSystem = {}

copy_functions(HTBMovableSystem, SPLMovableSystem)

function SPLMovableSystem.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:base_init(SPLInterfaceImpl.movableRendererInit, arg_1_1, arg_1_2)
	
	arg_1_0.vars.current_player_id = 1
end

function SPLMovableSystem.initVariables(arg_2_0)
	arg_2_0:base_initVariables(SPLInterfaceImpl.movableManagerCreate)
end

function SPLMovableSystem.releaseCurrentMapResource(arg_3_0)
	arg_3_0:base_releaseCurrentMapResource(SPLInterfaceImpl.movableRendererRelease)
end

function SPLMovableSystem.addMovable(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.vars.movable_manager:addMovable(arg_4_1)
	
	if var_4_0 then
		SPLMovableRenderer:addDrawObject(var_4_0)
		
		local var_4_1 = var_4_0:getPos()
		
		SPLFogSystem:discover(var_4_1.x, var_4_1.y, var_4_0:getSightCell())
	end
end

function SPLMovableSystem.getPlayerPos(arg_5_0)
	local var_5_0 = arg_5_0:getPlayer()
	
	if not var_5_0 then
		return 
	end
	
	return var_5_0:getPos()
end

function SPLMovableSystem.setPlayerPos(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0:getPlayer()
	
	if not var_6_0 then
		return 
	end
	
	var_6_0:setPos(arg_6_1, arg_6_2, true)
	arg_6_0:updateMovableArea()
end

function SPLMovableSystem.getPlayer(arg_7_0)
	return arg_7_0.vars.movable_manager:getMovableById(arg_7_0.vars.current_player_id)
end

function SPLMovableSystem.getCurrentPlayerId(arg_8_0)
	return arg_8_0.vars.current_player_id
end

function SPLMovableSystem.calcPlayerRealCost(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:getPlayer()
	
	if not var_9_0 then
		return 
	end
	
	local var_9_1 = SPLPathFindingSystem:find(var_9_0:getPos(), arg_9_1, var_9_0:getMoveCell())
	
	if not var_9_1 then
		return -1
	end
	
	return #var_9_1
end

function SPLMovableSystem.getPlayerMoveCell(arg_10_0)
	local var_10_0 = arg_10_0:getPlayer()
	
	if not var_10_0 then
		return 
	end
	
	return var_10_0:getMoveCell()
end

function SPLMovableSystem.getPlayerSightCell(arg_11_0)
	local var_11_0 = arg_11_0:getPlayer()
	
	if not var_11_0 then
		return 
	end
	
	return var_11_0:getSightCell()
end

function SPLMovableSystem.getPlayerTeam(arg_12_0)
	local var_12_0 = arg_12_0:getPlayer()
	
	if not var_12_0 then
		return 
	end
	
	return var_12_0:getNpcTeam()
end

function SPLMovableSystem.updateMovableArea(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.movable_manager:getMovableById(arg_13_0.vars.current_player_id)
	
	if not var_13_0 then
		return 
	end
	
	arg_13_1 = arg_13_1 or var_13_0:getMoveCell()
	
	local var_13_1 = var_13_0:getPos()
	local var_13_2 = SPLPathFindingSystem:getReachableTiles(var_13_1, arg_13_1, true) or {}
	
	table.insert(var_13_2, var_13_1)
	
	local var_13_3 = {}
	
	for iter_13_0, iter_13_1 in pairs(var_13_2) do
		local var_13_4 = SPLTileMapSystem:getTileByPos(iter_13_1)
		
		if var_13_4 then
			table.insert(var_13_3, var_13_4)
		end
	end
	
	SPLTileMapSystem:updateInteractArea(var_13_3)
end

function SPLMovableSystem.isPlayerOutScreen(arg_14_0)
	return arg_14_0:base_isPlayerOutScreen(SPLInterfaceImpl.getCameraPos, SPLInterfaceImpl.calcTilePosToWorldPos, SPLInterfaceImpl.calcWorldPosToCameraPos)
end

function SPLMovableSystem.close(arg_15_0)
	return arg_15_0:base_close(SPLInterfaceImpl.movableRendererClose)
end

function SPLMovableSystem.isPlayerRunning(arg_16_0)
	local var_16_0 = arg_16_0:getPlayer()
	
	if not var_16_0 then
		return 
	end
	
	return var_16_0.is_running
end

function SPLMovableSystem.movePath(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_1:getUID()
	
	arg_17_0.vars.move_to_path[var_17_0] = arg_17_2
	arg_17_0.vars.move_idx[var_17_0] = 1
	
	local var_17_1 = SPLMovableRenderer:getDrawObject(arg_17_1)
	local var_17_2 = {}
	local var_17_3 = 500 / arg_17_1:getMoveSpeed()
	local var_17_4 = SPLEventSystem:isPlayingEvent()
	
	if var_17_4 then
		SPLEventSystem:pause()
	else
		SPLEventSystem:onBeginStep()
	end
	
	for iter_17_0 = 1, #arg_17_0.vars.move_to_path[var_17_0] do
		local var_17_5 = table.clone(arg_17_0.vars.move_to_path[var_17_0][iter_17_0])
		local var_17_6 = arg_17_0.vars.move_to_path[var_17_0][iter_17_0 - 1] or arg_17_1:getPos()
		local var_17_7 = table.clone(var_17_6)
		local var_17_8 = SPLMovableRenderer:calcTilePosToWorldPos(var_17_1, var_17_7)
		local var_17_9 = SPLMovableRenderer:calcTilePosToWorldPos(var_17_1, var_17_5)
		local var_17_10
		
		var_17_10 = iter_17_0 <= #arg_17_0.vars.move_to_path[var_17_0]
		
		arg_17_1:setPos(var_17_7.x, var_17_7.y)
		table.insert(var_17_2, SEQ(CALL(function()
			arg_17_1:setPos(var_17_5.x, var_17_5.y)
		end), CALL(function()
			local var_19_0 = var_17_1.model
			
			if var_19_0 then
				local var_19_1 = math.abs(var_19_0:getScaleX())
				
				if var_17_9.x - var_17_8.x < 0 then
					var_19_1 = var_19_1 * -1
				end
				
				var_19_0:setScaleX(var_19_1)
			end
		end), MOVE_TO(var_17_3, var_17_9.x, var_17_9.y), CALL(function()
			local var_20_0 = var_17_5.y * -5 + 1
			
			var_17_1:setLocalZOrder(var_20_0)
			SPLObjectRenderer:setClairPosition(var_17_0, var_17_5)
		end)))
	end
	
	UIAction:Add(SEQ(SEQ(CALL(function()
		SPLMovableRenderer:startRunAnimation(arg_17_1)
		
		arg_17_1.is_running = true
	end), table.unpack(var_17_2)), SEQ(DELAY(60), CALL(function()
		SPLMovableRenderer:stopRunAnimation(arg_17_1)
		
		arg_17_1.is_running = nil
	end), CALL(function()
		if var_17_4 then
			SPLEventSystem:resume()
		else
			SPLEventSystem:onEndStep()
		end
	end))), var_17_1, "block")
end

function SPLMovableSystem.setPlayerPreset(arg_24_0, arg_24_1)
	arg_24_0:setMovablePreset(arg_24_0.vars.current_player_id, arg_24_1)
end

function SPLMovableSystem.setMovablePreset(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0:getMovableById(arg_25_1)
	
	if not var_25_0 then
		return 
	end
	
	if arg_25_2 == var_25_0:getPresetId() then
		return 
	end
	
	var_25_0:setPreset(arg_25_2)
	SPLMovableRenderer:updatePlayerModel(var_25_0)
end
