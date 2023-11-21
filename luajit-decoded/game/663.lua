LotaCameraSystem = {}

function LotaCameraSystem.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_1
	arg_1_0.vars.pivot = arg_1_3
	arg_1_0.vars.min_scaling = DB("clan_heritage_config", "view_min", "client_value") or 0.1
	arg_1_0.vars.max_scaling = DB("clan_heritage_config", "view_max", "client_value") or 10
	
	arg_1_0:initVariables(arg_1_2)
end

function LotaCameraSystem.attachUIPivot(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars.ui_zoom_pivot = cc.Node:create()
	
	arg_2_0.vars.ui_zoom_pivot:setName("zoom_pivot")
	arg_2_0.vars.ui_zoom_pivot:addChild(arg_2_1)
	
	arg_2_0.vars.ui_pivot = arg_2_1
	
	arg_2_2:addChild(arg_2_0.vars.ui_zoom_pivot)
end

function LotaCameraSystem.initVariables(arg_3_0, arg_3_1)
	arg_3_0.vars.scale = 1
	arg_3_0.vars.start_tm = 0
	arg_3_0.vars.target_tm = 1000
	arg_3_0.vars.scaling_time = 0
	arg_3_0.vars.pos_x = 0
	arg_3_0.vars.pos_y = 0
	arg_3_0.vars.pos = {}
	arg_3_0.vars.pos.start_tm = 0
	arg_3_0.vars.pos.target_tm = 0
	arg_3_0.vars.pivot_pos = {}
	arg_3_0.vars.zoom_pivot = cc.Node:create()
	
	arg_3_0.vars.zoom_pivot:setName("zoom_pivot")
	arg_3_0.vars.zoom_pivot:addChild(arg_3_0.vars.layer)
	arg_3_1:addChild(arg_3_0.vars.zoom_pivot)
end

function LotaCameraSystem.setZOrder(arg_4_0, arg_4_1)
	arg_4_0.vars.zoom_pivot:setLocalZOrder(arg_4_1)
end

function lcs_min_max(arg_5_0, arg_5_1)
	LotaCameraSystem.vars.min_scaling = arg_5_0
	LotaCameraSystem.vars.max_scaling = arg_5_1
end

function LotaCameraSystem.onScaling(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = 0.02
	local var_6_1 = arg_6_0:getPlayScale()
	
	if arg_6_0.vars.scale < arg_6_0.vars.min_scaling * var_6_1 and -arg_6_1 < 0 then
		return 
	end
	
	if arg_6_0.vars.scale > arg_6_0.vars.max_scaling * var_6_1 and -arg_6_1 > 0 then
		return 
	end
	
	arg_6_2 = table.clone(arg_6_2)
	
	arg_6_0:procScale(arg_6_0.vars.scale + var_6_0 * -arg_6_1, arg_6_2)
end

function LotaCameraSystem.getZoomPivotPos(arg_7_0)
	return arg_7_0.vars.zoom_pivot:getPosition()
end

function LotaCameraSystem.getCameraScale(arg_8_0)
	return arg_8_0.vars.scale
end

function LotaCameraSystem.getMoveRatio(arg_9_0)
	local var_9_0 = arg_9_0.vars.pos_x
	local var_9_1 = arg_9_0.vars.pos_y
	local var_9_2, var_9_3 = LotaUtil:getWorldMinMaxPos()
	local var_9_4, var_9_5 = arg_9_0:cameraPosToWorldPos(var_9_0, var_9_1)
	local var_9_6 = (var_9_4 - var_9_2.x) / var_9_3.x
	local var_9_7 = (var_9_5 - var_9_2.y) / var_9_3.y
	
	return var_9_6, var_9_7
end

function LotaCameraSystem.procMovePosition(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = 1
	
	arg_10_1 = arg_10_1 * var_10_0
	arg_10_2 = arg_10_2 * var_10_0
	
	local var_10_1 = arg_10_0.vars.pos_x + arg_10_1
	local var_10_2 = arg_10_0.vars.pos_y + arg_10_2
	local var_10_3, var_10_4 = LotaUtil:getWorldMinMaxPos()
	local var_10_5, var_10_6 = arg_10_0:cameraPosToWorldPos(var_10_1, var_10_2)
	
	if var_10_5 < var_10_3.x or var_10_5 > var_10_4.x or var_10_6 < var_10_3.y or var_10_6 > var_10_4.y then
		return 
	end
	
	arg_10_0.vars.pos_x = var_10_1
	arg_10_0.vars.pos_y = var_10_2
	
	arg_10_0.vars.pivot:setPosition(arg_10_0.vars.pos_x, arg_10_0.vars.pos_y)
	
	if get_cocos_refid(arg_10_0.vars.ui_pivot) then
		arg_10_0.vars.ui_pivot:setPosition(arg_10_0.vars.pos_x, arg_10_0.vars.pos_y)
	end
end

function LotaCameraSystem.procScale(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0:setScale(arg_11_1, arg_11_2)
	LotaSystem:updateFieldUIScale()
	LotaPingRenderer:updateScale()
end

function LotaCameraSystem.beginCommand(arg_12_0)
	arg_12_0.vars.commands = {}
end

function LotaCameraSystem.addCommand(arg_13_0, arg_13_1)
	if not arg_13_0.vars.commands then
		Log.e("COMMANDS NOT START")
		
		return 
	end
	
	table.insert(arg_13_0.vars.commands, arg_13_1)
end

function LotaCameraSystem.executeCommand(arg_14_0, arg_14_1)
	if not arg_14_0.vars.commands then
		Log.e("COMMANDS NOT START")
		
		return 
	end
	
	local var_14_0 = {}
	
	for iter_14_0 = 1, #arg_14_0.vars.commands do
		local var_14_1 = arg_14_0.vars.commands[iter_14_0]
		
		table.insert(var_14_0, var_14_1)
	end
	
	UIAction:Add(SEQ(table.unpack(var_14_0)), arg_14_0.vars.pivot, arg_14_1 or "lota_camera")
	
	arg_14_0.vars.commands = nil
end

function LotaCameraSystem.setPlayScale(arg_15_0)
	arg_15_0:setScale(arg_15_0:getPlayScale())
end

function LotaCameraSystem.getPlayScale(arg_16_0)
	return 1.314
end

function LotaCameraSystem.getScale(arg_17_0)
	return arg_17_0.vars.scale
end

function LotaCameraSystem.setScaleJustValue(arg_18_0, arg_18_1)
	arg_18_0.vars.scale = arg_18_1
end

function LotaCameraSystem.setScale(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0
	local var_19_1
	local var_19_2
	
	if not arg_19_2 then
		arg_19_0.vars.pivot:setScale(arg_19_1)
		
		if get_cocos_refid(arg_19_0.vars.ui_pivot) then
			arg_19_0.vars.ui_pivot:setScale(arg_19_1)
		end
		
		arg_19_0.vars.scale = arg_19_1
		
		local var_19_3 = LotaMovableSystem:getPlayerPos()
		local var_19_4 = LotaUtil:calcTilePosToWorldPos(var_19_3)
		
		var_19_0, var_19_1 = arg_19_0:worldPosToCameraPos(var_19_4)
	else
		arg_19_2 = table.clone(arg_19_2)
		arg_19_2.x = arg_19_2.x - VIEW_WIDTH / 2 - VIEW_BASE_LEFT
		arg_19_2.y = arg_19_2.y - VIEW_HEIGHT / 2
		
		local var_19_5 = arg_19_0.vars.zoom_pivot:convertToWorldSpace({
			x = 0,
			y = 0
		})
		
		var_19_5.x = var_19_5.x
		var_19_5.y = var_19_5.y
		arg_19_2 = LotaUtil:getDecedPosition(arg_19_2, var_19_5)
		
		local var_19_6, var_19_7 = arg_19_0.vars.zoom_pivot:getPosition()
		
		arg_19_0.vars.zoom_pivot:setPosition(var_19_6 + arg_19_2.x, var_19_7 + arg_19_2.y)
		
		if get_cocos_refid(arg_19_0.vars.ui_zoom_pivot) then
			arg_19_0.vars.ui_zoom_pivot:setPosition(var_19_6 + arg_19_2.x, var_19_7 + arg_19_2.y)
		end
		
		local var_19_8, var_19_9 = arg_19_0:cameraPosToWorldPos(arg_19_0.vars.pos_x, arg_19_0.vars.pos_y)
		
		arg_19_0.vars.pivot:setScale(arg_19_1)
		
		if get_cocos_refid(arg_19_0.vars.ui_pivot) then
			arg_19_0.vars.ui_pivot:setScale(arg_19_1)
		end
		
		local var_19_10 = var_19_8 + arg_19_2.x / arg_19_0.vars.scale
		local var_19_11 = var_19_9 + arg_19_2.y / arg_19_0.vars.scale
		
		var_19_0, var_19_1 = arg_19_0:worldPosToCameraPos({
			x = var_19_10,
			y = var_19_11
		})
	end
	
	arg_19_0:setCameraPos(var_19_0, var_19_1, true)
end

function LotaCameraSystem.saveCameraStatus(arg_20_0)
	local var_20_0, var_20_1 = arg_20_0.vars.zoom_pivot:getPosition()
	
	return {
		camera_x = arg_20_0.vars.pos_x,
		camera_y = arg_20_0.vars.pos_y,
		pivot_x = var_20_0,
		pivot_y = var_20_1,
		scale = arg_20_0.vars.pivot:getScale()
	}
end

function LotaCameraSystem.loadCameraStatus(arg_21_0, arg_21_1)
	arg_21_0:setCameraPos(arg_21_1.camera_x, arg_21_1.camera_y)
	arg_21_0.vars.zoom_pivot:setPosition(arg_21_1.pivot_x, arg_21_1.pivot_y)
	
	if get_cocos_refid(arg_21_0.vars.ui_zoom_pivot) then
		arg_21_0.vars.ui_zoom_pivot:setPosition(arg_21_1.pivot_x, arg_21_1.pivot_y)
	end
	
	arg_21_0.vars.pivot:setScale(arg_21_1.scale)
	
	if get_cocos_refid(arg_21_0.vars.ui_pivot) then
		arg_21_0.vars.ui_pivot:setScale(arg_21_1.scale)
	end
end

function LotaCameraSystem.getCameraTilePos(arg_22_0)
	local var_22_0 = LotaSystem:touchPosToWorldPos({
		x = VIEW_WIDTH / 2,
		y = VIEW_HEIGHT / 2
	})
	local var_22_1 = var_22_0.x
	local var_22_2 = var_22_0.y
	local var_22_3 = LotaTileMapSystem:calcWorldPosToTilePos({
		x = var_22_1,
		y = var_22_2
	}, true)
	local var_22_4 = LotaTileMapSystem:getPosById(1)
	
	if var_22_4.x % 2 ~= var_22_3.x % 2 and var_22_4.y % 2 == var_22_3.y % 2 or var_22_4.x % 2 == var_22_3.x % 2 and var_22_4.y % 2 ~= var_22_3.y % 2 then
		var_22_3.x = var_22_3.x + 1
	end
	
	return var_22_3
end

function LotaCameraSystem.drawCameraArea(arg_23_0)
	local var_23_0 = arg_23_0:getCameraTilePos()
	local var_23_1 = LotaUtil:getTileRect(var_23_0, 26, 12)
	local var_23_2 = {}
	
	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		local var_23_3 = LotaTileMapSystem:getTileByPos(iter_23_1)
		
		table.insert(var_23_2, var_23_3)
	end
	
	LotaTileRenderer:drawMovableArea(var_23_2)
	LotaTileRenderer:getTileSprite(LotaTileMapSystem:getTileByPos(var_23_0)):setColor(cc.c3b(255, 0, 0))
end

function LotaCameraSystem.objectCulling(arg_24_0)
	local var_24_0 = uitick()
	local var_24_1 = arg_24_0:getCameraTilePos()
	local var_24_2 = LotaMovableSystem:getPlayerPos()
	local var_24_3 = 26
	local var_24_4 = 12
	
	if LOW_RESOLUTION_MODE then
		var_24_3 = 26
		var_24_4 = 12
	end
	
	local var_24_5 = LotaUtil:getTileRect(var_24_1, var_24_3, var_24_4)
	local var_24_6 = {}
	
	LotaMovableRenderer:visibleOff()
	LotaObjectRenderer:visibleOff()
	
	if LOW_RESOLUTION_MODE then
		LotaTileRenderer:visibleOff()
	end
	
	local var_24_7 = {}
	
	for iter_24_0, iter_24_1 in pairs(var_24_5) do
		local var_24_8 = LotaTileMapSystem:getTileIdByPos(iter_24_1)
		
		if var_24_8 then
			if LotaFogSystem:getFogVisibility(iter_24_1.x, iter_24_1.y) >= LotaFogVisibilityEnum.DISCOVER then
				LotaObjectRenderer:requirePreload(var_24_8)
				LotaMovableRenderer:requirePreload(var_24_8)
				table.insert(var_24_7, var_24_8)
			end
			
			LotaTileRenderer:createTile(iter_24_1)
		end
	end
	
	for iter_24_2, iter_24_3 in pairs(var_24_7) do
		LotaObjectRenderer:setVisibleObject(iter_24_3, true)
		LotaMovableRenderer:setVisibleMovable(iter_24_3)
	end
	
	local var_24_9, var_24_10 = LotaObjectRenderer:considerExpire()
	local var_24_11, var_24_12 = LotaMovableRenderer:considerExpire()
	
	if LOW_RESOLUTION_MODE then
		LotaTileRenderer:considerExpire()
	end
	
	if var_24_12 + var_24_10 > 0 then
	end
	
	LotaCameraSystem.last_tick = uitick() - var_24_0
end

function LotaCameraSystem.getCameraPos(arg_25_0)
	local var_25_0, var_25_1 = arg_25_0.vars.pivot:getPosition()
	
	return {
		x = var_25_0,
		y = var_25_1
	}
end

function LotaCameraSystem.setVisible(arg_26_0, arg_26_1)
	arg_26_0.vars.zoom_pivot:setVisible(arg_26_1)
	
	if get_cocos_refid(arg_26_0.vars.ui_zoom_pivot) then
		arg_26_0.vars.ui_zoom_pivot:setVisible(arg_26_1)
	end
end

function LotaCameraSystem.moveCameraPos(arg_27_0, arg_27_1, arg_27_2)
	arg_27_1 = arg_27_1 or 0
	arg_27_2 = arg_27_2 or 0
	
	local var_27_0 = arg_27_0.vars.pos_x + arg_27_1
	local var_27_1 = arg_27_0.vars.pos_y + arg_27_2
	
	arg_27_0:setCameraPos(var_27_0, var_27_1)
end

function LotaCameraSystem.setCameraPos(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.vars.pos_x = arg_28_1
	arg_28_0.vars.pos_y = arg_28_2
	
	arg_28_0.vars.pivot:setPosition(arg_28_0.vars.pos_x, arg_28_0.vars.pos_y)
	
	if get_cocos_refid(arg_28_0.vars.ui_zoom_pivot) then
		arg_28_0.vars.ui_pivot:setPosition(arg_28_0.vars.pos_x, arg_28_0.vars.pos_y)
	end
	
	LotaFogRenderer:syncPosition()
end

function LotaCameraSystem.setPivotReset(arg_29_0)
	arg_29_0.vars.zoom_pivot:setPosition(0, 0)
	
	if get_cocos_refid(arg_29_0.vars.ui_zoom_pivot) then
		arg_29_0.vars.ui_zoom_pivot:setPosition(0, 0)
	end
	
	LotaFogRenderer:syncPosition()
end

function LotaCameraSystem.setCameraPlayerPos(arg_30_0)
	local var_30_0 = LotaMovableSystem:getPlayerPos()
	
	if not var_30_0 then
		return 
	end
	
	local var_30_1 = LotaUtil:calcTilePosToWorldPos(var_30_0)
	local var_30_2, var_30_3 = arg_30_0:worldPosToCameraPos(var_30_1)
	local var_30_4 = var_30_2 - VIEW_BASE_LEFT
	
	arg_30_0:setCameraPos(var_30_4, var_30_3)
	arg_30_0:setPivotReset()
end

function LotaCameraSystem.setCameraPosByTile(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1:getPos()
	local var_31_1 = LotaUtil:calcTilePosToWorldPos(var_31_0)
	local var_31_2, var_31_3 = arg_31_0:worldPosToCameraPos(var_31_1)
	
	arg_31_0:setCameraPos(var_31_2, var_31_3)
end

function LotaCameraSystem.setCameraPosByTilePos(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_1
	local var_32_1 = LotaUtil:calcTilePosToWorldPos(var_32_0)
	local var_32_2, var_32_3 = arg_32_0:worldPosToCameraPos(var_32_1)
	
	if arg_32_2 then
		var_32_2 = var_32_2 - VIEW_BASE_LEFT
	end
	
	arg_32_0:setCameraPos(var_32_2, var_32_3)
end

function LotaCameraSystem.setCameraPosBySprite(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0, var_33_1 = arg_33_1:getPosition()
	local var_33_2 = arg_33_1:getChildByName("render_object")
	local var_33_3 = false
	
	if get_cocos_refid(var_33_2) then
		var_33_0 = var_33_0 + var_33_2:getPositionX()
		var_33_1 = var_33_1 + var_33_2:getPositionY()
		var_33_3 = true
	end
	
	local var_33_4, var_33_5 = arg_33_0:worldPosToCameraPos({
		x = var_33_0,
		y = var_33_1
	})
	
	if arg_33_2 then
		var_33_4 = var_33_4 - VIEW_BASE_LEFT
	end
	
	arg_33_0:setCameraPos(var_33_4, var_33_5)
	
	return var_33_3
end

function LotaCameraSystem.setCameraPosByEffect(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0, var_34_1 = arg_34_1:getPosition()
	local var_34_2 = arg_34_1:getChildByName("effect_node")
	
	if get_cocos_refid(var_34_2) then
		var_34_0 = var_34_0 + var_34_2:getPositionX()
		var_34_1 = var_34_1 + var_34_2:getPositionY()
	end
	
	local var_34_3, var_34_4 = arg_34_0:worldPosToCameraPos({
		x = var_34_0,
		y = var_34_1
	})
	
	if arg_34_2 then
		var_34_3 = var_34_3 - VIEW_BASE_LEFT
	end
	
	arg_34_0:setCameraPos(var_34_3, var_34_4)
end

function LotaCameraSystem.worldPosToCameraPos(arg_35_0, arg_35_1)
	local var_35_0 = -320
	local var_35_1 = 27
	local var_35_2 = 300 * (arg_35_0.vars.scale - 1)
	local var_35_3 = 390 * (arg_35_0.vars.scale - 1)
	local var_35_4 = arg_35_1.x * arg_35_0.vars.scale
	local var_35_5 = arg_35_1.y * arg_35_0.vars.scale
	local var_35_6 = (var_35_4 + var_35_0 + var_35_2) * -1
	local var_35_7 = (var_35_5 + var_35_1 + var_35_3) * -1
	
	return var_35_6, var_35_7
end

function LotaCameraSystem.cameraPosToWorldPos(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = -320
	local var_36_1 = 27
	local var_36_2 = 300 * (arg_36_0.vars.scale - 1)
	local var_36_3 = 390 * (arg_36_0.vars.scale - 1)
	local var_36_4 = (arg_36_1 + var_36_2 + var_36_0) / arg_36_0.vars.scale * -1
	local var_36_5 = (arg_36_2 + var_36_3 + var_36_1) / arg_36_0.vars.scale * -1
	
	return var_36_4, var_36_5
end

function LotaCameraSystem.close(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_37_0.vars.zoom_pivot) then
		arg_37_0.vars.zoom_pivot:removeFromParent()
	end
	
	if get_cocos_refid(arg_37_0.vars.ui_zoom_pivot) then
		arg_37_0.vars.ui_zoom_pivot:removeFromParent()
	end
	
	arg_37_0.vars = nil
end
