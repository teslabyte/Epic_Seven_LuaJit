HTBCameraSystem = {}

function HTBCameraSystem.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_1
	arg_1_0.vars.pivot = arg_1_3
	arg_1_0.vars.min_scaling = arg_1_4 or 0.1
	arg_1_0.vars.max_scaling = arg_1_5 or 10
	
	arg_1_0:initVariables(arg_1_2)
end

function HTBCameraSystem.base_getMoveRatio(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.vars.pos_x
	local var_2_1 = arg_2_0.vars.pos_y
	local var_2_2, var_2_3 = HTBInterface:getWorldMinMaxPos(arg_2_1)
	local var_2_4, var_2_5 = arg_2_0:cameraPosToWorldPos(var_2_0, var_2_1)
	local var_2_6 = (var_2_4 - var_2_2.x) / var_2_3.x
	local var_2_7 = (var_2_5 - var_2_2.y) / var_2_3.y
	
	return var_2_6, var_2_7
end

function HTBCameraSystem.base_procMovePosition(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = 1
	
	arg_3_2 = arg_3_2 * var_3_0
	arg_3_3 = arg_3_3 * var_3_0
	
	local var_3_1 = arg_3_0.vars.pos_x + arg_3_2
	local var_3_2 = arg_3_0.vars.pos_y + arg_3_3
	local var_3_3, var_3_4 = HTBInterface:getWorldMinMaxPos(arg_3_1)
	local var_3_5, var_3_6 = arg_3_0:cameraPosToWorldPos(var_3_1, var_3_2)
	
	if var_3_5 < var_3_3.x or var_3_5 > var_3_4.x or var_3_6 < var_3_3.y or var_3_6 > var_3_4.y then
		return 
	end
	
	arg_3_0.vars.pos_x = var_3_1
	arg_3_0.vars.pos_y = var_3_2
	
	arg_3_0.vars.pivot:setPosition(arg_3_0.vars.pos_x, arg_3_0.vars.pos_y)
	
	if get_cocos_refid(arg_3_0.vars.ui_pivot) then
		arg_3_0.vars.ui_pivot:setPosition(arg_3_0.vars.pos_x, arg_3_0.vars.pos_y)
	end
end

function HTBCameraSystem.base_procScale(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:setScale(arg_4_3, arg_4_4)
	HTBInterface:updateFieldUIScale(arg_4_1)
	HTBInterface:updatePingScale(arg_4_2)
end

function HTBCameraSystem.base_drawCameraArea(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0:getCameraTilePos()
	local var_5_1 = HTUtil:getTileRect(var_5_0, 26, 12)
	local var_5_2 = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		local var_5_3 = HTBInterface:getTileByPos(arg_5_1, iter_5_1)
		
		table.insert(var_5_2, var_5_3)
	end
	
	HTBInterface:drawMovableTiles(arg_5_2, var_5_2)
	HTBInterface:getTileSprite(arg_5_3, HTBInterface:getTileByPos(arg_5_1, var_5_0)):setColor(cc.c3b(255, 0, 0))
end

function HTBCameraSystem.base_setScale(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0
	local var_6_1
	local var_6_2
	
	if not arg_6_4 then
		arg_6_0.vars.pivot:setScale(arg_6_3)
		
		if get_cocos_refid(arg_6_0.vars.ui_pivot) then
			arg_6_0.vars.ui_pivot:setScale(arg_6_3)
		end
		
		arg_6_0.vars.scale = arg_6_3
		
		local var_6_3 = HTBInterface:getPlayerPos(arg_6_1)
		local var_6_4 = HTBInterface:calcTilePosToWorldPos(arg_6_2, var_6_3)
		
		var_6_0, var_6_1 = arg_6_0:worldPosToCameraPos(var_6_4)
	else
		arg_6_4 = table.clone(arg_6_4)
		arg_6_4.x = arg_6_4.x - VIEW_WIDTH / 2 - VIEW_BASE_LEFT
		arg_6_4.y = arg_6_4.y - VIEW_HEIGHT / 2
		
		local var_6_5 = arg_6_0.vars.zoom_pivot:convertToWorldSpace({
			x = 0,
			y = 0
		})
		
		var_6_5.x = var_6_5.x
		var_6_5.y = var_6_5.y
		arg_6_4 = HTUtil:getDecedPosition(arg_6_4, var_6_5)
		
		local var_6_6, var_6_7 = arg_6_0.vars.zoom_pivot:getPosition()
		
		arg_6_0.vars.zoom_pivot:setPosition(var_6_6 + arg_6_4.x, var_6_7 + arg_6_4.y)
		
		if get_cocos_refid(arg_6_0.vars.ui_zoom_pivot) then
			arg_6_0.vars.ui_zoom_pivot:setPosition(var_6_6 + arg_6_4.x, var_6_7 + arg_6_4.y)
		end
		
		local var_6_8, var_6_9 = arg_6_0:cameraPosToWorldPos(arg_6_0.vars.pos_x, arg_6_0.vars.pos_y)
		
		arg_6_0.vars.pivot:setScale(arg_6_3)
		
		if get_cocos_refid(arg_6_0.vars.ui_pivot) then
			arg_6_0.vars.ui_pivot:setScale(arg_6_3)
		end
		
		arg_6_0.vars.scale = arg_6_3
		
		local var_6_10 = var_6_8 + arg_6_4.x / arg_6_0.vars.scale
		local var_6_11 = var_6_9 + arg_6_4.y / arg_6_0.vars.scale
		
		var_6_0, var_6_1 = arg_6_0:worldPosToCameraPos({
			x = var_6_10,
			y = var_6_11
		})
	end
	
	arg_6_0:setCameraPos(var_6_0, var_6_1)
end

function HTBCameraSystem.base_getCameraTilePos(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = HTBInterface:touchPosToWorldPos(arg_7_1, {
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	local var_7_1 = var_7_0.x
	local var_7_2 = var_7_0.y
	local var_7_3 = HTBInterface:calcWorldPosToTilePos(arg_7_2, {
		x = var_7_1,
		y = var_7_2
	}, true)
	local var_7_4 = HTBInterface:getPosById(arg_7_3, 1)
	
	if var_7_4.x % 2 ~= var_7_3.x % 2 and var_7_4.y % 2 == var_7_3.y % 2 or var_7_4.x % 2 == var_7_3.x % 2 and var_7_4.y % 2 ~= var_7_3.y % 2 then
		var_7_3.x = var_7_3.x + 1
	end
	
	return var_7_3
end

function HTBCameraSystem.base_objectCulling(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = uitick()
	local var_8_1 = arg_8_0:getCameraTilePos()
	
	arg_8_5 = arg_8_5 or 26
	arg_8_6 = arg_8_6 or 12
	
	local var_8_2 = HTUtil:getTileRect(var_8_1, arg_8_5, arg_8_6)
	local var_8_3 = {}
	
	HTBInterface:onVisibleOffCallback(arg_8_1)
	
	local var_8_4 = {}
	
	for iter_8_0, iter_8_1 in pairs(var_8_2) do
		local var_8_5 = HTBInterface:onVisibleCheckCallback(arg_8_2, iter_8_1)
		
		if var_8_5 then
			table.insert(var_8_4, var_8_5)
		end
	end
	
	for iter_8_2, iter_8_3 in pairs(var_8_4) do
		HTBInterface:onVisibleCallback(arg_8_3, iter_8_3)
	end
	
	HTBInterface:onConsiderExpire(arg_8_4)
	
	HTBCameraSystem.last_tick = uitick() - var_8_0
end

function HTBCameraSystem.base_setCameraPos(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.vars.pos_x = arg_9_2
	arg_9_0.vars.pos_y = arg_9_3
	
	arg_9_0.vars.pivot:setPosition(arg_9_0.vars.pos_x, arg_9_0.vars.pos_y)
	
	if get_cocos_refid(arg_9_0.vars.ui_zoom_pivot) then
		arg_9_0.vars.ui_pivot:setPosition(arg_9_0.vars.pos_x, arg_9_0.vars.pos_y)
	end
	
	HTBInterface:fogSyncPosition(arg_9_1)
end

function HTBCameraSystem.base_setPivotReset(arg_10_0, arg_10_1)
	arg_10_0.vars.zoom_pivot:setPosition(0, 0)
	
	if get_cocos_refid(arg_10_0.vars.ui_zoom_pivot) then
		arg_10_0.vars.ui_zoom_pivot:setPosition(0, 0)
	end
	
	HTBInterface:fogSyncPosition(arg_10_1)
end

function HTBCameraSystem.base_setCameraPlayerPos(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = HTBInterface:getPlayerPos(arg_11_2)
	
	if not var_11_0 then
		return 
	end
	
	local var_11_1 = HTBInterface:calcTilePosToWorldPos(arg_11_1, var_11_0)
	local var_11_2, var_11_3 = arg_11_0:worldPosToCameraPos(var_11_1)
	local var_11_4 = var_11_2 - VIEW_BASE_LEFT
	
	arg_11_0:setCameraPos(var_11_4, var_11_3)
	arg_11_0:setPivotReset()
end

function HTBCameraSystem.base_setCameraPosByTile(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2:getPos()
	local var_12_1 = HTBInterface:calcTilePosToWorldPos(arg_12_1, var_12_0)
	local var_12_2, var_12_3 = arg_12_0:worldPosToCameraPos(var_12_1)
	
	arg_12_0:setCameraPos(var_12_2, var_12_3)
end

function HTBCameraSystem.base_setCameraPosByTilePos(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_2
	local var_13_1 = HTBInterface:calcTilePosToWorldPos(arg_13_1, var_13_0)
	local var_13_2, var_13_3 = arg_13_0:worldPosToCameraPos(var_13_1)
	
	if arg_13_3 then
		var_13_2 = var_13_2 - VIEW_BASE_LEFT
	end
	
	arg_13_0:setCameraPos(var_13_2, var_13_3)
end

function HTBCameraSystem.moveCameraPos(arg_14_0, arg_14_1, arg_14_2)
	arg_14_1 = arg_14_1 or 0
	arg_14_2 = arg_14_2 or 0
	
	local var_14_0 = arg_14_0.vars.pos_x + arg_14_1
	local var_14_1 = arg_14_0.vars.pos_y + arg_14_2
	
	arg_14_0:setCameraPos(var_14_0, var_14_1)
end

function HTBCameraSystem.attachUIPivot(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.vars.ui_zoom_pivot = cc.Node:create()
	
	arg_15_0.vars.ui_zoom_pivot:setName("zoom_pivot")
	arg_15_0.vars.ui_zoom_pivot:addChild(arg_15_1)
	
	arg_15_0.vars.ui_pivot = arg_15_1
	
	arg_15_2:addChild(arg_15_0.vars.ui_zoom_pivot)
end

function HTBCameraSystem.initVariables(arg_16_0, arg_16_1)
	arg_16_0.vars.scale = 1
	arg_16_0.vars.start_tm = 0
	arg_16_0.vars.target_tm = 1000
	arg_16_0.vars.scaling_time = 0
	arg_16_0.vars.pos_x = 0
	arg_16_0.vars.pos_y = 0
	arg_16_0.vars.pos = {}
	arg_16_0.vars.pos.start_tm = 0
	arg_16_0.vars.pos.target_tm = 0
	arg_16_0.vars.pivot_pos = {}
	arg_16_0.vars.zoom_pivot = cc.Node:create()
	
	arg_16_0.vars.zoom_pivot:setName("zoom_pivot")
	arg_16_0.vars.zoom_pivot:addChild(arg_16_0.vars.layer)
	arg_16_1:addChild(arg_16_0.vars.zoom_pivot)
end

function HTBCameraSystem.setZOrder(arg_17_0, arg_17_1)
	arg_17_0.vars.zoom_pivot:setLocalZOrder(arg_17_1)
end

function HTBCameraSystem.getZoomPivotPos(arg_18_0)
	return arg_18_0.vars.zoom_pivot:getPosition()
end

function HTBCameraSystem.getCameraScale(arg_19_0)
	return arg_19_0.vars.scale
end

function HTBCameraSystem.beginCommand(arg_20_0)
	arg_20_0.vars.commands = {}
end

function HTBCameraSystem.addCommand(arg_21_0, arg_21_1)
	if not arg_21_0.vars.commands then
		Log.e("COMMANDS NOT START")
		
		return 
	end
	
	table.insert(arg_21_0.vars.commands, arg_21_1)
end

function HTBCameraSystem.executeCommand(arg_22_0, arg_22_1)
	if not arg_22_0.vars.commands then
		Log.e("COMMANDS NOT START")
		
		return 
	end
	
	local var_22_0 = {}
	
	for iter_22_0 = 1, #arg_22_0.vars.commands do
		local var_22_1 = arg_22_0.vars.commands[iter_22_0]
		
		table.insert(var_22_0, var_22_1)
	end
	
	UIAction:Add(SEQ(table.unpack(var_22_0)), arg_22_0.vars.pivot, arg_22_1 or "lota_camera")
	
	arg_22_0.vars.commands = nil
end

function HTBCameraSystem.getPlayScale(arg_23_0)
	return 1.314
end

function HTBCameraSystem.getScale(arg_24_0)
	return arg_24_0.vars.scale
end

function HTBCameraSystem.setPlayScale(arg_25_0)
	arg_25_0:setScale(arg_25_0:getPlayScale())
end

function HTBCameraSystem.loadCameraStatus(arg_26_0, arg_26_1)
	arg_26_0:setCameraPos(arg_26_1.camera_x, arg_26_1.camera_y)
	arg_26_0.vars.zoom_pivot:setPosition(arg_26_1.pivot_x, arg_26_1.pivot_y)
	
	if get_cocos_refid(arg_26_0.vars.ui_zoom_pivot) then
		arg_26_0.vars.ui_zoom_pivot:setPosition(arg_26_1.pivot_x, arg_26_1.pivot_y)
	end
	
	arg_26_0.vars.pivot:setScale(arg_26_1.scale)
	
	if get_cocos_refid(arg_26_0.vars.ui_pivot) then
		arg_26_0.vars.ui_pivot:setScale(arg_26_1.scale)
	end
end

function HTBCameraSystem.setCameraPosBySprite(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0, var_27_1 = arg_27_1:getPosition()
	local var_27_2 = arg_27_1:getChildByName("render_object")
	local var_27_3 = false
	
	if get_cocos_refid(var_27_2) then
		var_27_0 = var_27_0 + var_27_2:getPositionX()
		var_27_1 = var_27_1 + var_27_2:getPositionY()
		var_27_3 = true
	end
	
	local var_27_4, var_27_5 = arg_27_0:worldPosToCameraPos({
		x = var_27_0,
		y = var_27_1
	})
	
	if arg_27_2 then
		var_27_4 = var_27_4 - VIEW_BASE_LEFT
	end
	
	arg_27_0:setCameraPos(var_27_4, var_27_5)
	
	return var_27_3
end

function HTBCameraSystem.onScaling(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = 0.02
	local var_28_1 = arg_28_0:getPlayScale()
	
	if arg_28_0.vars.scale < arg_28_0.vars.min_scaling * var_28_1 and -arg_28_1 < 0 then
		return 
	end
	
	if arg_28_0.vars.scale > arg_28_0.vars.max_scaling * var_28_1 and -arg_28_1 > 0 then
		return 
	end
	
	arg_28_2 = table.clone(arg_28_2)
	
	arg_28_0:procScale(arg_28_0.vars.scale + var_28_0 * -arg_28_1, arg_28_2)
end

function HTBCameraSystem.setCameraPosByEffect(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0, var_29_1 = arg_29_1:getPosition()
	local var_29_2 = arg_29_1:getChildByName("effect_node")
	
	if get_cocos_refid(var_29_2) then
		var_29_0 = var_29_0 + var_29_2:getPositionX()
		var_29_1 = var_29_1 + var_29_2:getPositionY()
	end
	
	local var_29_3, var_29_4 = arg_29_0:worldPosToCameraPos({
		x = var_29_0,
		y = var_29_1
	})
	
	if arg_29_2 then
		var_29_3 = var_29_3 - VIEW_BASE_LEFT
	end
	
	arg_29_0:setCameraPos(var_29_3, var_29_4)
end

function HTBCameraSystem.setScaleJustValue(arg_30_0, arg_30_1)
	arg_30_0.vars.scale = arg_30_1
end

function HTBCameraSystem.saveCameraStatus(arg_31_0)
	local var_31_0, var_31_1 = arg_31_0.vars.zoom_pivot:getPosition()
	
	return {
		camera_x = arg_31_0.vars.pos_x,
		camera_y = arg_31_0.vars.pos_y,
		pivot_x = var_31_0,
		pivot_y = var_31_1,
		scale = arg_31_0.vars.pivot:getScale()
	}
end

function HTBCameraSystem.getCameraPos(arg_32_0)
	local var_32_0, var_32_1 = arg_32_0.vars.pivot:getPosition()
	
	return {
		x = var_32_0,
		y = var_32_1
	}
end

function HTBCameraSystem.setVisible(arg_33_0, arg_33_1)
	arg_33_0.vars.zoom_pivot:setVisible(arg_33_1)
	
	if get_cocos_refid(arg_33_0.vars.ui_zoom_pivot) then
		arg_33_0.vars.ui_zoom_pivot:setVisible(arg_33_1)
	end
end

function HTBCameraSystem.worldPosToCameraPos(arg_34_0, arg_34_1)
	local var_34_0 = -320
	local var_34_1 = 27
	local var_34_2 = 300 * (arg_34_0.vars.scale - 1)
	local var_34_3 = 390 * (arg_34_0.vars.scale - 1)
	local var_34_4 = arg_34_1.x * arg_34_0.vars.scale
	local var_34_5 = arg_34_1.y * arg_34_0.vars.scale
	local var_34_6 = (var_34_4 + var_34_0 + var_34_2) * -1
	local var_34_7 = (var_34_5 + var_34_1 + var_34_3) * -1
	
	return var_34_6, var_34_7
end

function HTBCameraSystem.cameraPosToWorldPos(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = -320
	local var_35_1 = 27
	local var_35_2 = 300 * (arg_35_0.vars.scale - 1)
	local var_35_3 = 390 * (arg_35_0.vars.scale - 1)
	local var_35_4 = (arg_35_1 + var_35_2 + var_35_0) / arg_35_0.vars.scale * -1
	local var_35_5 = (arg_35_2 + var_35_3 + var_35_1) / arg_35_0.vars.scale * -1
	
	return var_35_4, var_35_5
end

function HTBCameraSystem.close(arg_36_0)
	if not arg_36_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_36_0.vars.zoom_pivot) then
		arg_36_0.vars.zoom_pivot:removeFromParent()
	end
	
	if get_cocos_refid(arg_36_0.vars.ui_zoom_pivot) then
		arg_36_0.vars.ui_zoom_pivot:removeFromParent()
	end
	
	arg_36_0.vars = nil
end
