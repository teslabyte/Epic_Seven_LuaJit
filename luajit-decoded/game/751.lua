SPLCameraSystem = {}

copy_functions(HTBCameraSystem, SPLCameraSystem)

function SPLCameraSystem.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = SPLWhiteboard:get("view_min") or arg_1_0:getCameraMinScale()
	local var_1_1 = SPLWhiteboard:get("view_max") or 2
	
	arg_1_0:base_init(arg_1_1, arg_1_2, arg_1_3, var_1_0, var_1_1)
	arg_1_0:updateCameraMinMax()
	arg_1_0:updateCameraTileRect()
end

function SPLCameraSystem.getMoveRatio(arg_2_0)
	local var_2_0 = arg_2_0.vars.pos_x
	local var_2_1 = arg_2_0.vars.pos_y
	local var_2_2, var_2_3 = arg_2_0:getCameraMinMaxPos()
	local var_2_4 = (var_2_0 - var_2_2.x) / var_2_3.x
	local var_2_5 = (var_2_1 - var_2_2.y) / var_2_3.y
	
	return var_2_4, var_2_5
end

function SPLCameraSystem.procScale(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1 = math.clamp(arg_3_1, arg_3_0.vars.min_scaling, arg_3_0.vars.max_scaling)
	
	if arg_3_1 == arg_3_0.vars.scale then
		return 
	end
	
	arg_3_0:base_procScale(SPLInterfaceImpl.updateFieldUIScale, SPLInterfaceImpl.updatePingScale, arg_3_1, arg_3_2)
end

function SPLCameraSystem.drawCameraArea(arg_4_0)
	arg_4_0:base_drawCameraArea(SPLInterfaceImpl.getTileByPos, SPLInterfaceImpl.drawMovableTiles, SPLInterfaceImpl.getTileSprite)
end

function SPLCameraSystem.setScale(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:base_setScale(SPLInterfaceImpl.getPlayerPos, SPLInterfaceImpl.calcTilePosToWorldPos, arg_5_1, arg_5_2)
	arg_5_0:updateCameraTileRect()
end

function SPLCameraSystem.getCameraTilePos(arg_6_0)
	return arg_6_0:base_getCameraTilePos(SPLInterfaceImpl.touchPosToWorldPos, SPLInterfaceImpl.calcWorldPosToTilePos, SPLInterfaceImpl.getPosById)
end

function SPLCameraSystem.objectCulling(arg_7_0)
	local var_7_0 = arg_7_0:getCameraTileRect()
	
	arg_7_0:base_objectCulling({
		onVisibleOffCallback = function()
			SPLMovableRenderer:visibleOff()
			SPLObjectRenderer:visibleOff()
			
			if LOW_RESOLUTION_MODE then
				SPLTileMapRenderer:visibleOff()
			end
		end
	}, {
		onVisibleCheckCallback = function(arg_9_0, arg_9_1)
			local var_9_0 = SPLTileMapSystem:getTileIdByPos(arg_9_1)
			
			if not var_9_0 then
				return 
			end
			
			SPLTileMapRenderer:createTile(arg_9_1)
			
			if SPLFogSystem:getFogVisibility(arg_9_1.x, arg_9_1.y) < HTBFogVisibilityEnum.DISCOVER then
				return 
			end
			
			SPLObjectRenderer:requirePreload(var_9_0)
			SPLMovableRenderer:requirePreload(var_9_0)
			
			return var_9_0
		end
	}, {
		onVisibleCallback = function(arg_10_0, arg_10_1)
			SPLObjectRenderer:setVisibleObject(arg_10_1, true)
			SPLMovableRenderer:setVisibleMovable(arg_10_1)
		end
	}, {
		onConsiderExpire = function()
			SPLObjectRenderer:considerExpire()
			SPLMovableRenderer:considerExpire()
			
			if LOW_RESOLUTION_MODE then
				SPLTileMapRenderer:considerExpire()
			end
		end
	}, var_7_0.width, var_7_0.height)
end

function SPLCameraSystem.setCameraPos(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0, var_12_1 = arg_12_0:getClampedPos(arg_12_1, arg_12_2)
	
	arg_12_0:base_setCameraPos(SPLInterfaceImpl.fogSyncPosition, var_12_0, var_12_1)
	arg_12_0:stopMoveAction()
end

function SPLCameraSystem.setPivotReset(arg_13_0)
	arg_13_0:base_setPivotReset(SPLInterfaceImpl.fogSyncPosition)
	arg_13_0:updateCameraMinMax()
	arg_13_0:stopMoveAction()
end

function SPLCameraSystem.setCameraPlayerPos(arg_14_0)
	arg_14_0:base_setCameraPlayerPos(SPLInterfaceImpl.calcTilePosToWorldPos, SPLInterfaceImpl.getPlayerPos)
end

function SPLCameraSystem.setCameraPosByTile(arg_15_0, arg_15_1)
	arg_15_0:base_setCameraPosByTile(SPLInterfaceImpl.calcTilePosToWorldPos, arg_15_1)
end

function SPLCameraSystem.setCameraPosByTilePos(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0:base_setCameraPosByTilePos(SPLInterfaceImpl.calcTilePosToWorldPos, arg_16_1, arg_16_2)
end

function SPLCameraSystem.updateCameraMinMax(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	local var_17_0, var_17_1 = SPLUtil:getWorldMinMaxPos()
	local var_17_2, var_17_3 = arg_17_0:worldPosToCameraPos(var_17_0)
	local var_17_4, var_17_5 = arg_17_0:worldPosToCameraPos(var_17_1)
	local var_17_6, var_17_7 = arg_17_0.vars.zoom_pivot:getPosition()
	
	arg_17_0.vars.min_x = var_17_2 - var_17_6
	arg_17_0.vars.max_x = var_17_4 - var_17_6
	arg_17_0.vars.min_y = var_17_3 - var_17_7
	arg_17_0.vars.max_y = var_17_5 - var_17_7
end

function SPLCameraSystem.getCameraMinMaxPos(arg_18_0)
	local var_18_0
	local var_18_1
	
	if not arg_18_0.vars then
		local var_18_2, var_18_3 = SPLUtil:getWorldMinMaxPos()
		local var_18_4, var_18_5 = arg_18_0:worldPosToCameraPos(var_18_2)
		local var_18_6, var_18_7 = arg_18_0:worldPosToCameraPos(var_18_3)
		
		var_18_0 = {
			x = var_18_4,
			y = var_18_5
		}
		var_18_1 = {
			x = var_18_6,
			y = var_18_7
		}
	else
		var_18_0 = {
			x = arg_18_0.vars.min_x,
			y = arg_18_0.vars.min_y
		}
		var_18_1 = {
			x = arg_18_0.vars.max_x,
			y = arg_18_0.vars.max_y
		}
	end
	
	return var_18_0, var_18_1
end

function SPLCameraSystem.getPlayScale(arg_19_0)
	if not arg_19_0.vars then
		return 1.314
	end
	
	return (arg_19_0.vars.min_scaling + arg_19_0.vars.max_scaling) / 2
end

function SPLCameraSystem.updateCameraTileRect(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	local var_20_0 = arg_20_0:getCameraScale()
	
	if not arg_20_0.vars.tile_rect then
		arg_20_0.vars.tile_rect = {}
	end
	
	arg_20_0.vars.tile_rect.width = math.round(20 * VIEW_WIDTH_RATIO / var_20_0) * 2
	arg_20_0.vars.tile_rect.height = math.round(24 / var_20_0)
end

function SPLCameraSystem.getCameraTileRect(arg_21_0)
	if not arg_21_0.vars then
		return {}
	end
	
	return arg_21_0.vars.tile_rect or {}
end

function SPLCameraSystem.getClampedPos(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1 or arg_22_0.vars.pos_x
	local var_22_1 = arg_22_2 or arg_22_0.vars.pos_y
	local var_22_2, var_22_3 = arg_22_0:getCameraMinMaxPos()
	local var_22_4 = math.clamp(var_22_0, var_22_3.x, var_22_2.x)
	local var_22_5 = math.clamp(var_22_1, var_22_3.y, var_22_2.y)
	
	return var_22_4, var_22_5
end

function SPLCameraSystem.getCameraMinScale(arg_23_0)
	local var_23_0, var_23_1 = SPLUtil:getWorldMinMaxPos()
	local var_23_2 = var_23_1.x - var_23_0.x
	local var_23_3 = var_23_1.y - var_23_0.y
	
	return math.max(VIEW_WIDTH / var_23_2, VIEW_HEIGHT / var_23_3)
end

function SPLCameraSystem.onScaling(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = 0.02 * -arg_24_1
	
	arg_24_2 = table.clone(arg_24_2)
	
	arg_24_0:procScale(arg_24_0.vars.scale + var_24_0, arg_24_2)
end

function SPLCameraSystem.procMovePosition(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0.vars.pos_x + arg_25_1
	local var_25_1 = arg_25_0.vars.pos_y + arg_25_2
	local var_25_2, var_25_3 = arg_25_0:getClampedPos(var_25_0, var_25_1)
	
	arg_25_0:base_setCameraPos(SPLInterfaceImpl.fogSyncPosition, var_25_2, var_25_3)
end

function SPLCameraSystem.procTouchMove(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0:procMovePosition(arg_26_1, arg_26_2)
	
	arg_26_0.vars.vel_x = arg_26_1
	arg_26_0.vars.vel_y = arg_26_2
end

function SPLCameraSystem.initDim(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_1) then
		return 
	end
	
	arg_27_0.vars.dim = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	arg_27_0.vars.dim:setOpacity(0)
	
	arg_27_0.vars.letter_top = cc.Sprite:create("img/heritage_cinema_bg.png")
	arg_27_0.vars.letter_bot = cc.Sprite:create("img/heritage_cinema_bg.png")
	arg_27_0.vars.letter_top.org_x = VIEW_WIDTH * 0.5
	arg_27_0.vars.letter_bot.org_x = VIEW_WIDTH * 0.5
	arg_27_0.vars.letter_top.org_y = VIEW_HEIGHT
	arg_27_0.vars.letter_bot.org_y = -arg_27_0.vars.letter_top:getContentSize().height
	
	arg_27_0.vars.letter_top:setPosition(arg_27_0.vars.letter_top.org_x, arg_27_0.vars.letter_top.org_y)
	arg_27_0.vars.letter_top:setAnchorPoint(0.5, 0)
	arg_27_0.vars.letter_bot:setPosition(arg_27_0.vars.letter_bot.org_x, arg_27_0.vars.letter_bot.org_y)
	arg_27_0.vars.letter_bot:setAnchorPoint(0.5, 1)
	arg_27_0.vars.letter_bot:setScale(-1, -1)
	arg_27_1:addChild(arg_27_0.vars.dim)
	arg_27_1:addChild(arg_27_0.vars.letter_top)
	arg_27_1:addChild(arg_27_0.vars.letter_bot)
end

function SPLCameraSystem.getDim(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.dim) then
		return 
	end
	
	return arg_28_0.vars.dim
end

function SPLCameraSystem.getLetterBoxes(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	return arg_29_0.vars.letter_top, arg_29_0.vars.letter_bot
end

function SPLCameraSystem.onLeave(arg_30_0)
	arg_30_0:stopMoveAction()
end

local function var_0_0(arg_31_0, arg_31_1)
	local var_31_0 = math.sqrt(arg_31_0 * arg_31_0 + arg_31_1 * arg_31_1)
	
	if var_31_0 == 0 then
		return arg_31_0, arg_31_1, 0
	end
	
	return arg_31_0 / var_31_0, arg_31_1 / var_31_0, var_31_0
end

local var_0_1 = 50

function SPLCameraSystem.decelMoveAction(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	local var_32_0, var_32_1, var_32_2 = var_0_0(arg_32_0.vars.vel_x, arg_32_0.vars.vel_y)
	
	if var_32_2 == 0 then
		return 
	end
	
	local var_32_3 = math.min(var_32_2, var_0_1)
	local var_32_4 = LINEAR_CALL(var_32_3 * 10, {}, function(arg_33_0, arg_33_1)
		arg_32_0:procMovePosition(var_32_0 * arg_33_1, var_32_1 * arg_33_1)
	end, var_32_3, 0)
	
	UIAction:Remove("spl.camera")
	UIAction:Add(LOG(var_32_4), arg_32_0.vars.pivot, "spl.camera")
end

function SPLCameraSystem.stopMoveAction(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	arg_34_0.vars.vel_x = 0
	arg_34_0.vars.vel_y = 0
	
	UIAction:Remove("spl.camera")
end

function SPLCameraSystem.setZoomPivotPos(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0.vars.zoom_pivot:setPosition(arg_35_1, arg_35_2)
	
	if get_cocos_refid(arg_35_0.vars.ui_zoom_pivot) then
		arg_35_0.vars.ui_zoom_pivot:setPosition(arg_35_1, arg_35_2)
	end
end

function SPLCameraSystem.tweenCameraPlayerPos(arg_36_0, arg_36_1)
	local var_36_0 = SPLMovableSystem:getPlayerPos()
	
	if not var_36_0 then
		return 
	end
	
	local var_36_1 = SPLUtil:calcTilePosToWorldPos(var_36_0)
	
	arg_36_1 = arg_36_1 or 1000
	
	UIAction:Add(arg_36_0:createCameraTween(arg_36_1, var_36_1.x, var_36_1.y), arg_36_0.vars.pivot, "spl.block")
end

function SPLCameraSystem.tweenCameraToTile(arg_37_0, arg_37_1, arg_37_2)
	arg_37_2 = arg_37_2 or {}
	
	if not arg_37_1 then
		return NONE()
	end
	
	local var_37_0 = SPLUtil:calcTilePosToWorldPos(arg_37_1:getPos())
	local var_37_1 = SPLObjectSystem:getObject(arg_37_1:getTileId())
	
	if var_37_1 and var_37_1:isModel() then
		var_37_0.y = var_37_0.y + var_37_1:getAdjustFocusYPos()
	end
	
	local var_37_2 = arg_37_2.tm or 1000
	
	UIAction:Add(arg_37_0:createCameraTween(var_37_2, var_37_0.x, var_37_0.y), arg_37_0.vars.pivot, "spl.block")
end

function SPLCameraSystem.createCameraTween(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = SPLCameraSystem:getCameraPos()
	local var_38_1, var_38_2 = SPLCameraSystem:getZoomPivotPos()
	local var_38_3, var_38_4 = SPLCameraSystem:worldPosToCameraPos({
		x = arg_38_2,
		y = arg_38_3
	})
	local var_38_5 = var_38_3 - VIEW_BASE_LEFT
	
	return BEZIER(LINEAR_CALL(arg_38_1, {}, function(arg_39_0, arg_39_1)
		local var_39_0 = (1 - arg_39_1) * var_38_0.x + arg_39_1 * var_38_5
		local var_39_1 = (1 - arg_39_1) * var_38_0.y + arg_39_1 * var_38_4
		local var_39_2 = (1 - arg_39_1) * var_38_1
		local var_39_3 = (1 - arg_39_1) * var_38_2
		
		SPLCameraSystem:setCameraPos(var_39_0, var_39_1)
		SPLCameraSystem:setZoomPivotPos(var_39_2, var_39_3)
	end, 0, 1), {
		0.5,
		0,
		0.5,
		1
	})
end
