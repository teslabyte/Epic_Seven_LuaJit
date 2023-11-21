LotaCameraCommands = {}
LCC = LotaCameraCommands

function LotaCameraCommands.Test(arg_1_0)
	LotaCameraSystem:beginCommand()
	
	local var_1_0 = LotaCameraCommands:CameraScale(3000, {
		x = VIEW_WIDTH / 2,
		y = VIEW_HEIGHT / 2
	}, 1, true)
	local var_1_1 = LotaCameraCommands:CameraScale(3000, {
		x = VIEW_WIDTH / 2,
		y = VIEW_HEIGHT / 2
	}, 2.7, "rlog")
	local var_1_2 = LotaMovableSystem:getPlayerPos()
	local var_1_3 = LotaUtil:getAddedPosition(var_1_2, {
		x = 21,
		y = 5
	})
	local var_1_4 = LotaCameraCommands:CameraMoveByTile(var_1_3.x, var_1_3.y, 2000, true)
	local var_1_5 = LotaCameraCommands:SEQ(var_1_0, var_1_4, var_1_1)
	local var_1_6 = LotaCameraCommands:CameraFadeIn(1500)
	local var_1_7 = LotaCameraCommands:ReturnToNormal()
	local var_1_8 = LotaCameraCommands:CameraWait(1000)
	local var_1_9 = LotaCameraCommands:CameraFadeOut(1500)
	
	LotaCameraSystem:addCommand(var_1_5)
	LotaCameraSystem:addCommand(LotaCameraCommands:CameraWait(500))
	LotaCameraSystem:addCommand(var_1_6)
	LotaCameraSystem:addCommand(var_1_7)
	LotaCameraSystem:addCommand(var_1_8)
	LotaCameraSystem:addCommand(var_1_9)
	LotaCameraSystem:executeCommand()
end

function LotaCameraCommands._CreateMoveStateValueByTile(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = LotaCameraSystem:getCameraPos()
	local var_2_1 = LotaUtil:calcTilePosToWorldPos({
		x = arg_2_1,
		y = arg_2_2
	})
	local var_2_2, var_2_3 = LotaCameraSystem:worldPosToCameraPos(var_2_1)
	
	return {
		origin_camera_pos = var_2_0,
		target_camera_pos = {
			x = var_2_2,
			y = var_2_3
		}
	}
end

function LotaCameraCommands.CameraMoveByTile(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = LINEAR_CALL(arg_3_3, {}, function(arg_4_0, arg_4_1)
		if not arg_4_0.value then
			arg_4_0.value = arg_3_0:_CreateMoveStateValueByTile(arg_3_1, arg_3_2)
		end
		
		if not arg_4_1 then
			return 
		end
		
		local var_4_0 = arg_4_0.value.origin_camera_pos
		local var_4_1 = arg_4_0.value.target_camera_pos
		local var_4_2 = LotaUtil:getDecedPosition(var_4_1, var_4_0)
		local var_4_3 = LotaUtil:getMultiplyPosition(var_4_2, arg_4_1)
		local var_4_4 = LotaUtil:getAddedPosition(var_4_0, var_4_3)
		
		LotaCameraSystem:setCameraPos(var_4_4.x, var_4_4.y)
	end, 0, 1)
	
	if arg_3_4 then
		if arg_3_4 == "rlog" then
			var_3_0 = RLOG(var_3_0, arg_3_5)
		else
			var_3_0 = LOG(var_3_0, arg_3_5)
		end
	end
	
	return var_3_0
end

function LotaCameraCommands.CALL(arg_5_0, arg_5_1)
	return CALL(arg_5_1)
end

function LotaCameraCommands.CameraMovePlayerPos(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = LotaMovableSystem:getPlayerPos()
	
	return arg_6_0:CameraMoveByTile(var_6_0.x, var_6_0.y, arg_6_1, arg_6_2)
end

function LotaCameraCommands.CameraWait(arg_7_0, arg_7_1)
	return DELAY(arg_7_1)
end

function LotaCameraCommands._CreateScaleStateValue(arg_8_0, arg_8_1)
	return {
		origin_camera_scale = LotaCameraSystem:getCameraScale(),
		target_camera_scale = arg_8_1
	}
end

function LotaCameraCommands.CameraScale(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = LINEAR_CALL(arg_9_1, {}, function(arg_10_0, arg_10_1)
		if not arg_10_0.value then
			arg_10_0.value = arg_9_0:_CreateScaleStateValue(arg_9_3)
		end
		
		if not arg_10_1 then
			return 
		end
		
		local var_10_0 = arg_10_0.value.origin_camera_scale
		local var_10_1 = (arg_10_0.value.target_camera_scale - var_10_0) * arg_10_1
		
		LotaCameraSystem:setScale(var_10_0 + var_10_1, arg_9_2)
	end, 0, 1)
	
	if arg_9_4 then
		if arg_9_4 == "rlog" then
			var_9_0 = RLOG(var_9_0)
		else
			var_9_0 = LOG(var_9_0)
		end
	end
	
	return var_9_0
end

function LotaCameraCommands.CameraFadeIn(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_3 = arg_11_3 or LotaSystem:getDimLayer()
	
	local var_11_0 = FADE_IN(arg_11_1)
	
	if arg_11_2 then
		var_11_0 = LOG(var_11_0)
	end
	
	return TARGET(arg_11_3, var_11_0)
end

function LotaCameraCommands.UILayerFadeOut(arg_12_0, arg_12_1)
	return TARGET(LotaSystem.vars.ui_layer, FADE_OUT(arg_12_1))
end

function LotaCameraCommands.UILayerFadeIn(arg_13_0, arg_13_1)
	return TARGET(LotaSystem.vars.ui_layer, FADE_IN(arg_13_1))
end

function LotaCameraCommands.MonsterFieldUILayerFadeOut(arg_14_0, arg_14_1)
	return TARGET(LotaSystem.vars.monster_field_ui_layer, FADE_OUT(arg_14_1))
end

function LotaCameraCommands.MonsterFieldUILayerFadeIn(arg_15_0, arg_15_1)
	return TARGET(LotaSystem.vars.monster_field_ui_layer, FADE_IN(arg_15_1))
end

function LotaCameraCommands.PlayerFieldUILayerFadeOut(arg_16_0, arg_16_1)
	return TARGET(LotaSystem.vars.movable_field_ui_layer, FADE_OUT(arg_16_1))
end

function LotaCameraCommands.PlayerFieldUILayerFadeIn(arg_17_0, arg_17_1)
	return TARGET(LotaSystem.vars.movable_field_ui_layer, FADE_IN(arg_17_1))
end

function LotaCameraCommands.MemoFieldUILayerFadeOut(arg_18_0, arg_18_1)
	return TARGET(LotaSystem.vars.ping_field_ui_layer, FADE_OUT(arg_18_1))
end

function LotaCameraCommands.MemoFieldUILayerFadeIn(arg_19_0, arg_19_1)
	return TARGET(LotaSystem.vars.ping_field_ui_layer, FADE_IN(arg_19_1))
end

function LotaCameraCommands.LetterBoxIn(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0, var_20_1 = LotaSystem:getLetterBoxes()
	local var_20_2, var_20_3 = var_20_0:getPosition()
	local var_20_4, var_20_5 = var_20_1:getPosition()
	local var_20_6 = MOVE_TO(arg_20_1, var_20_2, var_20_3 - 175)
	local var_20_7 = MOVE_TO(arg_20_1, var_20_4, var_20_5 + 175)
	
	if arg_20_2 then
		var_20_6 = LOG(var_20_6)
		var_20_6 = LOG(var_20_6)
	end
	
	local var_20_8 = TARGET(var_20_0, var_20_6)
	local var_20_9 = TARGET(var_20_1, var_20_7)
	
	return SPAWN(var_20_8, var_20_9)
end

function LotaCameraCommands.LetterBoxOut(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0, var_21_1 = LotaSystem:getLetterBoxes()
	local var_21_2, var_21_3 = var_21_0:getPosition()
	local var_21_4, var_21_5 = var_21_1:getPosition()
	local var_21_6 = MOVE_TO(arg_21_1, var_21_2, var_21_3)
	local var_21_7 = MOVE_TO(arg_21_1, var_21_4, var_21_5)
	
	if arg_21_2 then
		var_21_6 = LOG(var_21_6)
		var_21_6 = LOG(var_21_6)
	end
	
	local var_21_8 = TARGET(var_21_0, var_21_6)
	local var_21_9 = TARGET(var_21_1, var_21_7)
	
	return SPAWN(var_21_8, var_21_9)
end

function LotaCameraCommands.ReturnToNormal(arg_22_0)
	return CALL(function()
		LotaCameraSystem:setCameraPlayerPos()
		LotaCameraSystem:setPlayScale()
	end)
end

function LotaCameraCommands.CameraFadeOut(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_3 = arg_24_3 or LotaSystem:getDimLayer()
	
	local var_24_0 = FADE_OUT(arg_24_1)
	
	if arg_24_2 then
		var_24_0 = LOG(var_24_0)
	end
	
	return TARGET(arg_24_3, var_24_0)
end

function LotaCameraCommands.TargetMoveTo(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0 = MOVE_TO(arg_25_2, arg_25_3.x, arg_25_3.y)
	
	if arg_25_4 == "rlog" then
		var_25_0 = RLOG(var_25_0, arg_25_5)
	elseif arg_25_4 then
		var_25_0 = LOG(var_25_0, arg_25_5)
	end
	
	return TARGET(arg_25_1, var_25_0)
end

function LotaCameraCommands.SPAWN(arg_26_0, ...)
	return SPAWN(...)
end

function LotaCameraCommands.SEQ(arg_27_0, ...)
	return SEQ(...)
end

function LotaCameraCommands.LOOP(arg_28_0, ...)
	return LOOP(...)
end
