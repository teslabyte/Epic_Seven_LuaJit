LotaMovableSystem = {}

function MakeMovableInfo(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = table.clone(LotaMovableDataInterface)
	
	var_1_0.id = arg_1_0
	var_1_0.dir = 1
	var_1_0.leader_code = arg_1_2
	var_1_0.type = arg_1_1
	var_1_0.pos = arg_1_3
	var_1_0.user_id = arg_1_4
	
	return var_1_0
end

function LotaMovableSystem.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:initVariables()
	LotaMovableRenderer:init(arg_2_1, arg_2_2)
	LotaMovableRenderer:firstDraw(arg_2_0.vars.movable_manager:getList())
end

function LotaMovableSystem.initVariables(arg_3_0)
	arg_3_0.vars = {}
	arg_3_0.vars.move_to_path = {}
	arg_3_0.vars.move_idx = {}
	arg_3_0.vars.wait_to_draw = {}
	arg_3_0.vars.movable_manager = LotaMovableManager()
	arg_3_0.vars.current_player_id = nil
end

function LotaMovableSystem.releaseCurrentMapResource(arg_4_0)
	arg_4_0.vars.movable_manager:releaseCurrentMapResource()
	arg_4_0:initVariables()
	LotaMovableRenderer:release()
end

function LotaMovableSystem.updateMovablesExp(arg_5_0, arg_5_1)
	local var_5_0 = false
	
	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		local var_5_1 = to_n(iter_5_1[1])
		
		if var_5_1 ~= AccountData.id then
			local var_5_2 = iter_5_1[2]
			local var_5_3 = arg_5_0:getMovableById(var_5_1)
			
			if var_5_3 then
				local var_5_4 = var_5_3:getLevel()
				
				var_5_3:updateExp(var_5_2)
				
				if var_5_4 ~= var_5_3:getLevel() then
					LotaMovableRenderer:addLevelUpEffect(var_5_3, nil)
					
					var_5_0 = true
				end
			end
		end
	end
	
	if var_5_0 then
		LotaGroupScrollView:updateItems()
	end
end

function LotaMovableSystem.updateMovableInfo(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.id
	
	if arg_6_0.vars.movable_manager:getMovableById(var_6_0) then
		arg_6_0.vars.movable_manager:removeMovableById(var_6_0)
		LotaMovableRenderer:removeDrawObject(var_6_0)
	elseif arg_6_0.vars.wait_to_draw[var_6_0] then
		arg_6_0.vars.wait_to_draw[var_6_0] = nil
	end
	
	if tostring(arg_6_1.floor) == tostring(LotaUserData:getFloor()) then
		local var_6_1 = LotaTileMapSystem:getTileById(arg_6_1.tile_id)
		
		if var_6_1 then
			arg_6_1.pos = var_6_1:getPos()
		end
	end
	
	arg_6_0:addMovable(arg_6_1)
end

function LotaMovableSystem.addMovable(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1.pos and (tostring(arg_7_1.floor) == tostring(LotaUserData:getFloor()) or not arg_7_2) then
		arg_7_0.vars.movable_manager:addMovable(arg_7_1)
		
		local var_7_0 = arg_7_0.vars.movable_manager:getMovableById(arg_7_1.id)
		
		LotaMovableRenderer:addDrawObject(var_7_0)
	else
		arg_7_0.vars.wait_to_draw[arg_7_1.id] = arg_7_1
	end
end

function LotaMovableSystem.isWaitToDrawMovable(arg_8_0, arg_8_1)
	return arg_8_0.vars.wait_to_draw[arg_8_1] ~= nil
end

function LotaMovableSystem.addWaitDrawMovable(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.vars.wait_to_draw[arg_9_1]
	
	if not var_9_0 then
		return 
	end
	
	var_9_0.pos = arg_9_2
	
	arg_9_0:addMovable(var_9_0)
	LotaFogSystem:onAnotherPlayerConfirmStartPos(arg_9_2)
	
	arg_9_0.vars.wait_to_draw[arg_9_1] = nil
end

function LotaMovableSystem.addPlayerMovable(arg_10_0, arg_10_1)
	arg_10_0.vars.current_player_id = arg_10_1.id
	
	arg_10_0.vars.movable_manager:addMovable(arg_10_1)
	
	local var_10_0 = arg_10_0.vars.movable_manager:getMovableById(arg_10_0.vars.current_player_id)
	
	LotaFogSystem:onConfirmStartPoint(var_10_0:getPos())
	LotaMovableRenderer:addDrawObject(var_10_0)
end

function LotaMovableSystem.addEffectAfterMoveEnd(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 == "move_tile_add_exp" then
		arg_11_0.vars.artifact_effect_value = arg_11_2
	end
end

function LotaMovableSystem.onAfterMoveUpdate(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_1:getUID() == AccountData.id
	
	if arg_12_2 and var_12_0 then
		local var_12_1
		
		if arg_12_0.vars.artifact_effect_value then
			var_12_1 = arg_12_0.vars.artifact_effect_value
			arg_12_0.vars.artifact_effect_value = nil
		end
		
		LotaMovableRenderer:addMovableEffectAction(arg_12_1, {
			{
				exp = arg_12_2,
				additional_exp = var_12_1
			}
		})
	end
	
	if var_12_0 then
		TutorialGuide:startGuide("tuto_heritage_move")
		
		if TutorialGuide:isPlayingTutorial("tuto_heritage_move") then
			TutorialGuide:setOnFinish(function()
				LotaSystem:setBlockCoolTime()
			end)
		end
	end
	
	if arg_12_3 then
		if var_12_0 then
			LotaUserData:procLevelUp(arg_12_4)
		else
			LotaMovableRenderer:addLevelUpEffect(arg_12_1, arg_12_4)
		end
	end
end

function LotaMovableSystem.isProcJumpPath(arg_14_0)
	return arg_14_0.vars and arg_14_0.vars.proc_jump_path
end

function LotaMovableSystem._jumpPathBySelf(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2[1]
	
	LotaSystem:showCurtain()
	LotaCameraSystem:beginCommand()
	
	arg_15_0.vars.proc_jump_path = true
	
	local var_15_1 = LotaCameraCommands:SEQ(LotaCameraCommands:CameraWait(300), LotaCameraCommands:CALL(function()
		LotaNetworkSystem:stopSync()
		LotaMovableRenderer:setMovableVisible(arg_15_1, false)
		LotaTileRenderer:revertMovableArea(true)
		arg_15_1:setPos(var_15_0.x, var_15_0.y, true)
		LotaCameraSystem:setCameraPlayerPos()
	end), LotaCameraCommands:CameraWait(1651), LotaCameraCommands:CALL(function()
		arg_15_0.vars.proc_jump_path = false
		
		LotaMovableRenderer:addSpawnEffect(arg_15_1)
	end), LotaCameraCommands:CameraWait(366), LotaCameraCommands:CALL(function()
		LotaMovableSystem:drawMovableArea()
		LotaUIMainLayer:addGuideEffect()
		LotaNetworkSystem:resumeSync()
	end))
	
	LotaCameraSystem:addCommand(var_15_1)
	LotaCameraSystem:executeCommand("block")
	
	if LotaInteractiveUI:isActive() then
		LotaInteractiveUI:close()
	end
end

function LotaMovableSystem._jumpPathByAnother(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2[1]
	
	arg_19_1:setPos(var_19_0.x, var_19_0.y, true)
	LotaMovableRenderer:addSpawnEffect(arg_19_1)
end

function LotaMovableSystem.jumpPath(arg_20_0, arg_20_1, arg_20_2)
	if AccountData.id == arg_20_1:getUID() then
		arg_20_0:_jumpPathBySelf(arg_20_1, arg_20_2)
	else
		arg_20_0:_jumpPathByAnother(arg_20_1, arg_20_2)
	end
end

function LotaMovableSystem.floatingTileTravelPath_setDrawObjectScale(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = LotaMovableRenderer:getDrawObject(arg_21_1).model
	
	if var_21_0 then
		local var_21_1 = math.abs(var_21_0:getScaleX())
		local var_21_2 = arg_21_1:getPos()
		
		if LotaTileMapSystem:getPosById(arg_21_2).x - var_21_2.x < 0 then
			var_21_1 = var_21_1 * -1
		end
		
		var_21_0:setScaleX(var_21_1)
	end
end

function LotaMovableSystem.floatingTileTravelPath_getRenderData(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	local var_22_0 = LotaTileMapSystem:getPosById(arg_22_2)
	local var_22_1 = LotaObjectSystem:getObject(arg_22_2)
	local var_22_2 = LotaObjectRenderer:getRenderObjectInHash(arg_22_2)
	local var_22_3 = LotaTileRenderer:getTile(var_22_0)
	local var_22_4 = LotaMovableRenderer:getDrawObject(arg_22_1)
	local var_22_5 = {
		left = {
			x = -4,
			y = 0
		},
		right = {
			x = 4,
			y = 0
		},
		down = {
			x = 0,
			y = -2
		},
		up = {
			x = 0,
			y = 2
		}
	}
	local var_22_6 = var_22_1:getFloatingDirection() or "left"
	local var_22_7 = LotaUtil:getAddedPosition(var_22_0, var_22_5[var_22_6])
	local var_22_8 = LotaMovableRenderer:calcTilePosToWorldPos(var_22_4, var_22_0)
	local var_22_9 = LotaMovableRenderer:calcTilePosToWorldPos(var_22_4, var_22_7)
	local var_22_10 = LotaTileRenderer:getTileSpritePos(var_22_7)
	local var_22_11 = LotaObjectRenderer:getObjectPosition(var_22_7)
	local var_22_12 = LotaTileMapSystem:getTileById(arg_22_3)
	local var_22_13 = LotaTileMapSystem:getPosById(arg_22_3)
	local var_22_14 = {
		left = {
			x = 6,
			y = 0
		},
		right = {
			x = -6,
			y = 0
		},
		down = {
			x = 0,
			y = 3
		},
		up = {
			x = 0,
			y = -3
		}
	}
	local var_22_15 = LotaUtil:getAddedPosition(var_22_13, var_22_14[var_22_6])
	local var_22_16 = LotaMovableRenderer:calcTilePosToWorldPos(var_22_4, var_22_15)
	local var_22_17 = LotaTileRenderer:getTileSpritePos(var_22_15)
	local var_22_18 = LotaObjectRenderer:getObjectPosition(var_22_15)
	local var_22_19 = LotaMovableRenderer:calcTilePosToWorldPos(var_22_4, var_22_13)
	local var_22_20 = LotaTileRenderer:getTileSpritePos(var_22_13)
	local var_22_21 = LotaObjectRenderer:getObjectPosition(var_22_13)
	local var_22_22 = LotaTileRenderer:getTempTile(var_22_12)
	local var_22_23 = LotaTileRenderer:getTile(var_22_13)
	local var_22_24 = LotaTileMapSystem:getPosById(arg_22_4)
	local var_22_25 = LotaMovableRenderer:calcTilePosToWorldPos(var_22_4, var_22_24)
	
	return {
		start_to_dest_wait_tm = 300,
		dest_render_objects = {
			movable = var_22_4,
			begin_tile_sprite = var_22_3,
			begin_object_render_object = var_22_2,
			dest_clone_tile_render_object = var_22_22,
			dest_origin_tile_render_object = var_22_23
		},
		dest_data = {
			begin_object_tile_pos = var_22_0,
			movable = arg_22_1
		},
		start_effect = {
			begin_target_to_tm = 2500,
			ui_fade_out_tm = 500,
			begin_effect_wait_tm = 2000,
			movable_walk_to_tm = 1000,
			scale_tm = 1000,
			movable_walk_to_pos = var_22_8,
			movable_begin_target_to_pos = var_22_9,
			tile_begin_target_to_pos = var_22_10,
			object_begin_target_to_pos = var_22_11,
			scale_to = LotaCameraSystem:getPlayScale() * 1.2
		},
		dest_effect = {
			scale_tm = 2000,
			ui_fade_in_tm = 1000,
			move_to_tm = 2500,
			ui_wait_tm = 1250,
			ui_delay_tm = 1250,
			fade_in_tm = 1000,
			real_dest_move_tm = 1000,
			letterbox_out_tm = 1000,
			tile_pos = var_22_13,
			movable_dest_begin_pos = var_22_16,
			tile_dest_begin_pos = var_22_17,
			object_dest_begin_pos = var_22_18,
			movable_dest_target_pos = var_22_19,
			tile_dest_target_pos = var_22_20,
			object_dest_target_to_pos = var_22_21,
			object_origin_pos = {
				x = var_22_2:getPositionX(),
				y = var_22_2:getPositionY()
			},
			movable_real_dest_pos = var_22_25,
			real_dest_tile_pos = var_22_24,
			scale_to = LotaCameraSystem:getPlayScale()
		}
	}
end

function LotaMovableSystem.floatingTileTravelPath(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	if not AccountData.id == arg_23_1:getUID() then
		Log.e("floatingTileTravelPath must ONLY Current Account USER.", arg_23_1:getUID())
		
		return 
	end
	
	LotaTileRenderer:revertMovableArea()
	arg_23_0:floatingTileTravelPath_setDrawObjectScale(arg_23_1, arg_23_2)
	
	local var_23_0 = arg_23_0:floatingTileTravelPath_getRenderData(arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_1 = var_23_0.dest_data.movable
	local var_23_2 = var_23_0.dest_render_objects
	local var_23_3 = var_23_0.dest_data.begin_object_tile_pos
	local var_23_4 = var_23_2.movable
	local var_23_5 = var_23_2.begin_tile_sprite
	local var_23_6 = var_23_2.dest_clone_tile_render_object
	local var_23_7 = var_23_2.dest_origin_tile_render_object
	local var_23_8 = var_23_2.begin_object_render_object
	local var_23_9 = var_23_0.start_effect
	local var_23_10 = var_23_0.dest_effect
	local var_23_11 = var_23_10.movable_real_dest_pos
	local var_23_12 = var_23_10.real_dest_move_tm
	local var_23_13 = var_23_9.begin_target_to_tm
	local var_23_14 = var_23_9.ui_fade_out_tm
	local var_23_15 = var_23_10.ui_wait_tm
	local var_23_16 = var_23_10.ui_fade_in_tm
	local var_23_17 = var_23_10.object_origin_pos
	
	LotaCameraSystem:beginCommand()
	LotaCameraSystem:addCommand(LCC:SEQ(LCC:SPAWN(LCC:SEQ(LCC:CALL(function()
		LotaMovableRenderer:startRunAnimation(var_23_1)
	end), LCC:TargetMoveTo(var_23_4, var_23_9.movable_walk_to_tm, var_23_9.movable_walk_to_pos), LCC:CALL(function()
		LotaMovableRenderer:stopRunAnimation(var_23_1)
	end)), LCC:CameraMoveByTile(var_23_3.x - 2, var_23_3.y + 1, var_23_9.movable_walk_to_tm)), LCC:CameraWait(500), LCC:SPAWN(LCC:MonsterFieldUILayerFadeOut(var_23_14), LCC:PlayerFieldUILayerFadeOut(var_23_14), LCC:MemoFieldUILayerFadeOut(var_23_14), LCC:UILayerFadeOut(var_23_14), LCC:LetterBoxIn(var_23_14, true), LCC:TargetMoveTo(var_23_4, var_23_13, var_23_9.movable_begin_target_to_pos, "rlog", 10), LCC:TargetMoveTo(var_23_5, var_23_13, var_23_9.tile_begin_target_to_pos, "rlog", 10), LCC:TargetMoveTo(var_23_8, var_23_13, var_23_9.object_begin_target_to_pos, "rlog", 10), LCC:SEQ(LCC:CameraScale(var_23_9.scale_tm * 0.5, {
		x = VIEW_WIDTH / 2 + 164,
		y = VIEW_HEIGHT / 2
	}, var_23_9.scale_to)), LCC:SEQ(LCC:CameraWait(var_23_9.begin_effect_wait_tm), LCC:CALL(function()
		local var_26_0 = SceneManager:getRunningNativeScene()
		
		EffectManager:Play({
			pivot_z = 99998,
			fn = "eff_anc_floor.cfx",
			layer = var_26_0
		})
	end))), LCC:CameraWait(var_23_0.start_to_dest_wait_tm), LCC:CALL(function()
		LotaCameraSystem:setCameraPosByTilePos(var_23_10.tile_pos)
		
		local var_27_0 = var_23_10.real_dest_tile_pos
		
		LotaMovableSystem:setPos(var_27_0.x, var_27_0.y)
		
		local var_27_1 = var_23_10.movable_dest_begin_pos
		local var_27_2 = var_23_10.tile_dest_begin_pos
		
		var_23_4:setPosition(var_27_1.x, var_27_1.y)
		
		local var_27_3 = var_23_4.model
		
		if var_27_3 then
			local var_27_4 = math.abs(var_27_3:getScaleX())
			
			if var_27_1.x - var_23_11.x > 1 then
				var_27_4 = var_27_4 * -1
			end
			
			var_27_3:setScaleX(var_27_4)
		end
		
		var_23_6:setPosition(var_27_2.x, var_27_2.y)
		var_23_7:setVisible(false)
		var_23_8:setPosition(var_23_17.x, var_23_17.y)
		LotaTileRenderer:setPosingSprite(var_23_5, var_23_5.tile)
		var_23_7.render_object:setVisible(false)
	end), LCC:SPAWN(LCC:SEQ(LCC:SPAWN(LCC:TargetMoveTo(var_23_4, var_23_10.move_to_tm, var_23_10.movable_dest_target_pos, true, 18), LCC:TargetMoveTo(var_23_6, var_23_10.move_to_tm, var_23_10.tile_dest_target_pos, true, 18)), LCC:CALL(function()
		LotaMovableRenderer:startRunAnimation(var_23_1)
	end), LCC:TargetMoveTo(var_23_4, var_23_12, var_23_11), LCC:CALL(function()
		LotaMovableSystem:drawMovableArea()
		LotaMovableRenderer:stopRunAnimation(var_23_1)
		var_23_7:setVisible(true)
		var_23_7.render_object:setVisible(true)
		var_23_6:removeFromParent()
		LotaTileRenderer:setPosingSprite(var_23_5, var_23_5.tile)
	end)), LCC:CameraScale(var_23_10.scale_tm, {
		x = VIEW_WIDTH / 2,
		y = VIEW_HEIGHT / 2
	}, var_23_10.scale_to), LCC:SEQ(LCC:CameraWait(var_23_15), LCC:SPAWN(LCC:LetterBoxOut(var_23_10.letterbox_out_tm, true), LCC:MonsterFieldUILayerFadeIn(var_23_16), LCC:PlayerFieldUILayerFadeIn(var_23_16), LCC:MemoFieldUILayerFadeIn(var_23_16), LCC:UILayerFadeIn(var_23_16))))))
	LotaCameraSystem:executeCommand("block")
end

function LotaMovableSystem.movePath(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	local var_30_0 = arg_30_1:getUID()
	
	arg_30_1.is_running = true
	arg_30_0.vars.move_to_path[var_30_0] = arg_30_2
	arg_30_0.vars.move_idx[var_30_0] = 1
	
	local var_30_1
	
	if arg_30_3 then
		local var_30_2 = arg_30_3 / #arg_30_0.vars.move_to_path[var_30_0]
	end
	
	local var_30_3 = LotaMovableRenderer:getDrawObject(arg_30_1)
	local var_30_4 = {}
	
	for iter_30_0 = 1, #arg_30_0.vars.move_to_path[var_30_0] do
		local var_30_5 = table.clone(arg_30_0.vars.move_to_path[var_30_0][iter_30_0])
		local var_30_6 = arg_30_0.vars.move_to_path[var_30_0][iter_30_0 - 1] or arg_30_1:getPos()
		local var_30_7 = table.clone(var_30_6)
		local var_30_8 = LotaMovableRenderer:calcTilePosToWorldPos(var_30_3, var_30_7)
		local var_30_9 = LotaMovableRenderer:calcTilePosToWorldPos(var_30_3, var_30_5)
		local var_30_10
		
		var_30_10 = iter_30_0 <= #arg_30_0.vars.move_to_path[var_30_0]
		
		arg_30_1:setPos(var_30_7.x, var_30_7.y)
		table.insert(var_30_4, SEQ(CALL(function()
			arg_30_1:setPos(var_30_5.x, var_30_5.y)
		end), CALL(function()
			local var_32_0 = var_30_3.model
			
			if var_32_0 then
				local var_32_1 = math.abs(var_32_0:getScaleX())
				
				if var_30_9.x - var_30_8.x < 0 then
					var_32_1 = var_32_1 * -1
				end
				
				var_32_0:setScaleX(var_32_1)
			end
			
			LotaMovableRenderer:updateGroupView(var_30_7)
			LotaMovableRenderer:updateGroupView(var_30_5)
			LotaPingRenderer:updatePingOpacity()
		end), MOVE_TO(480, var_30_9.x, var_30_9.y), CALL(function()
			var_30_3:setLocalZOrder(var_30_5.y * -5 + 1)
			
			arg_30_1.is_running = nil
			
			LotaMovableRenderer:updateGroupView(var_30_5)
		end)))
	end
	
	local var_30_11
	
	if tostring(arg_30_1:getUID()) == tostring(AccountData.id) then
		var_30_11 = "block"
	end
	
	UIAction:Add(SEQ(SEQ(CALL(function()
		LotaMovableRenderer:startRunAnimation(arg_30_1)
	end), table.unpack(var_30_4)), SEQ(CALL(function()
		if arg_30_1:getUID() == arg_30_0.vars.current_player_id then
			arg_30_0:drawMovableArea()
		end
	end), CALL(function()
		arg_30_0:onAfterMoveUpdate(arg_30_1, arg_30_3, arg_30_4, arg_30_5)
	end), DELAY(60), CALL(function()
		LotaMovableRenderer:stopRunAnimation(arg_30_1)
	end))), var_30_3, var_30_11)
end

function LotaMovableSystem.confirmPlayerStartPoint(arg_38_0, arg_38_1)
	if arg_38_0.vars.current_player_id then
		Log.e("TRY START POINT")
		
		return 
	end
	
	LotaNetworkSystem:sendQuery("lota_select_start_pos", {
		tile_id = arg_38_1
	})
end

function LotaMovableSystem.isPlayerOnBossTile(arg_39_0)
	local var_39_0 = arg_39_0:getPlayerMovable()
	
	if not var_39_0 then
		return 
	end
	
	return LotaTileMapSystem:getTileByPos(var_39_0:getPos()):getType() == "boss"
end

function LotaMovableSystem.isMovable(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_0.vars.movable_manager:getMovableById(arg_40_0.vars.current_player_id)
	
	arg_40_3 = arg_40_3 or LotaPathFindingSystem:find(var_40_0:getPos(), {
		x = arg_40_1,
		y = arg_40_2
	})
	
	if #arg_40_3 > LotaUserData:getActionPoint() then
		return false
	end
	
	return true
end

function LotaMovableSystem.moveToById(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = arg_41_0.vars.movable_manager:getMovableById(arg_41_1)
	
	if not var_41_0 then
		print("Movable NOT EXIST!")
		
		return 
	end
	
	local var_41_1 = LotaPathFindingSystem:find(var_41_0:getPos(), {
		x = arg_41_2,
		y = arg_41_3
	})
	
	if not var_41_1 then
		return 
	end
	
	local var_41_2 = {}
	
	if not arg_41_0:isMovable(arg_41_2, arg_41_3, var_41_1) then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return 
	end
	
	for iter_41_0 = 1, #var_41_1 do
		local var_41_3 = var_41_1[iter_41_0]
		
		table.insert(var_41_2, var_41_3.id)
	end
	
	if arg_41_0.vars.current_player_id == arg_41_1 then
		LotaNetworkSystem:sendQuery("lota_move_sync", {
			movable_id = arg_41_1,
			tile_ids = json.encode(var_41_2)
		})
	else
		Log.e("PLAYER ID DIFF")
	end
end

function LotaMovableSystem.getPlayerPos(arg_42_0)
	local var_42_0 = arg_42_0.vars.movable_manager:getMovableById(arg_42_0.vars.current_player_id)
	
	if not var_42_0 then
		return 
	end
	
	return var_42_0:getPos()
end

function LotaMovableSystem.moveTo(arg_43_0, arg_43_1, arg_43_2)
	if UIAction:Find("block") then
		return 
	end
	
	arg_43_0:moveToById(arg_43_0.vars.current_player_id, arg_43_1, arg_43_2)
end

function LotaMovableSystem.setPosById(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	arg_44_0.vars.movable_manager:getMovableById(arg_44_3):setPos(arg_44_1, arg_44_2, true)
end

function LotaMovableSystem.requestJumpTo(arg_45_0, arg_45_1, arg_45_2)
	LotaNetworkSystem:sendQuery("JumpTo", {
		movable_id = arg_45_1,
		tile_id = arg_45_2
	})
end

function LotaMovableSystem.setPos(arg_46_0, arg_46_1, arg_46_2)
	arg_46_0:setPosById(arg_46_1, arg_46_2, arg_46_0.vars.current_player_id)
end

function LotaMovableSystem.calcPlayerMoveCost(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.vars.movable_manager:getMovableById(arg_47_0.vars.current_player_id)
	
	if not var_47_0 then
		return 
	end
	
	return LotaUtil:getTileCost(var_47_0:getPos(), arg_47_1)
end

function LotaMovableSystem.calcPlayerRealCost(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0.vars.movable_manager:getMovableById(arg_48_0.vars.current_player_id)
	
	if not var_48_0 then
		return 
	end
	
	local var_48_1 = LotaPathFindingSystem:find(var_48_0:getPos(), arg_48_1)
	
	if not var_48_1 then
		return -1
	end
	
	return #var_48_1
end

function LotaMovableSystem.drawMovableArea(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0.vars.movable_manager:getMovableById(arg_49_0.vars.current_player_id)
	
	if not var_49_0 then
		return 
	end
	
	local var_49_1 = var_49_0:getPos()
	local var_49_2 = LotaPathFindingSystem:getReachableTiles(var_49_1, arg_49_1 or LotaWhiteboard:get("map_move_cell"), true)
	
	table.insert(var_49_2, var_49_1)
	
	local var_49_3 = {}
	
	for iter_49_0, iter_49_1 in pairs(var_49_2) do
		local var_49_4 = LotaTileMapSystem:getTileByPos(iter_49_1)
		
		if var_49_4 then
			table.insert(var_49_3, var_49_4)
		end
	end
	
	LotaTileRenderer:drawMovableArea(var_49_3, arg_49_2)
end

function LotaMovableSystem.isPlayerOutScreen(arg_50_0)
	local var_50_0 = LotaCameraSystem:getCameraPos()
	local var_50_1 = arg_50_0:getPlayerPos()
	
	if not var_50_1 then
		return false
	end
	
	local var_50_2, var_50_3 = LotaCameraSystem:worldPosToCameraPos(LotaUtil:calcTilePosToWorldPos(var_50_1))
	local var_50_4 = {
		x = var_50_2,
		y = var_50_3
	}
	local var_50_5 = LotaUtil:getAbsPosition(LotaUtil:getDecedPosition(var_50_4, var_50_0))
	
	return var_50_5.x > VIEW_WIDTH / 2 or var_50_5.y > VIEW_HEIGHT / 2
end

function LotaMovableSystem.isPlayerOnPos(arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0:getPlayerPos()
	
	if not var_51_0 then
		return 
	end
	
	return LotaUtil:isSamePosition(arg_51_1, var_51_0)
end

function LotaMovableSystem.getCurrentPlayerId(arg_52_0)
	return arg_52_0.vars.current_player_id
end

function LotaMovableSystem.getMovableById(arg_53_0, arg_53_1)
	return arg_53_0.vars.movable_manager:getMovableById(arg_53_1)
end

function LotaMovableSystem.getPlayerMovable(arg_54_0)
	return arg_54_0.vars.movable_manager:getMovableById(arg_54_0:getCurrentPlayerId())
end

function LotaMovableSystem.getMovablesByPos(arg_55_0, arg_55_1)
	return arg_55_0.vars.movable_manager:getMovablesByPos(arg_55_1)
end

function LotaMovableSystem.close(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	LotaMovableRenderer:close()
	
	arg_56_0.vars = nil
end
