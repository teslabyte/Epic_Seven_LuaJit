local var_0_0 = 0.8

WorldMapTownView = ClassDef()

function WorldMapTownView.constructor(arg_1_0)
end

function WorldMapTownView.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	arg_2_0.WIDTH = arg_2_1
	arg_2_0.HEIGHT = arg_2_2
	arg_2_0.MAP_SCALE = arg_2_5
	arg_2_0.maxScale = arg_2_3
	arg_2_0.mapContentSize = arg_2_4
	arg_2_0.scaleDelta = 0.02
	arg_2_0.originZoomScale = arg_2_6
end

function WorldMapTownView.clear(arg_3_0)
	arg_3_0.WIDTH = 0
	arg_3_0.HEIGHT = 0
	arg_3_0.MAP_SCALE = 0
	arg_3_0.maxScale = 0
	arg_3_0.mapContentSize = 0
	arg_3_0.scaleDelta = 0.02
	arg_3_0.scaleAccumulate = 0
	arg_3_0.moveAction = 0
end

function WorldMapTownView.blockZoomInOut(arg_4_0)
	if TutorialGuide:isPlayingTutorial() then
		return true
	end
end

function WorldMapTownView.create(arg_5_0, arg_5_1)
	arg_5_0.owner = arg_5_1
	
	local var_5_0 = cc.Layer:create()
	
	arg_5_0.base_layer = var_5_0
	
	local var_5_1 = cc.Layer:create()
	
	arg_5_0.layer = var_5_1
	
	arg_5_0.layer:ignoreAnchorPointForPosition(false)
	arg_5_0.base_layer:addChild(var_5_1)
	
	arg_5_0.scaleAccumulate = 0
	
	if PLATFORM == "win32" then
		local var_5_2 = var_5_1:getEventDispatcher()
		local var_5_3 = cc.EventListenerMouse:create()
		
		var_5_3:registerScriptHandler(function(arg_6_0, arg_6_1)
			if arg_5_0:blockZoomInOut() then
				return 
			end
			
			arg_5_0:townScale(arg_6_0)
			arg_5_0.owner:updateEventNavigator()
			arg_5_0.owner:updateFocusDir()
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_5_2:addEventListenerWithSceneGraphPriority(var_5_3, var_5_1)
	end
	
	return var_5_1, var_5_0
end

function WorldMapTownView.getZoomMaxScale(arg_7_0)
	return arg_7_0.maxScale / TOWN_MIN_SCALE
end

function WorldMapTownView.calcInitScaleAccumulate(arg_8_0, arg_8_1)
	arg_8_0.scaleAccumulate = arg_8_1 - arg_8_0.originZoomScale
end

function WorldMapTownView.townScale(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1:getCursorX()
	local var_9_1 = arg_9_1:getCursorY()
	local var_9_2, var_9_3, var_9_4, var_9_5 = arg_9_0:getAnchorAndPostiion_FromTouchPosition(var_9_0, var_9_1)
	
	arg_9_0.layer:setAnchorPoint(var_9_2, var_9_3)
	arg_9_0.layer:setPosition(var_9_4, var_9_5)
	
	if arg_9_1:getScrollY() > 0 then
		local var_9_6, var_9_7, var_9_8, var_9_9 = arg_9_0:getAnchorBoundaryCheck(true)
		
		arg_9_0.layer:setAnchorPoint(var_9_6, var_9_7)
		arg_9_0.layer:setPosition(var_9_8, var_9_9)
		
		if arg_9_0.layer:getScale() - arg_9_0.scaleDelta < arg_9_0.maxScale then
			arg_9_0.scaleAccumulate = arg_9_0.maxScale - arg_9_0.originZoomScale
		else
			arg_9_0.scaleAccumulate = arg_9_0.scaleAccumulate - arg_9_0.scaleDelta
		end
	elseif arg_9_0.layer:getScale() < arg_9_0.maxScale / TOWN_MIN_SCALE then
		arg_9_0.scaleAccumulate = arg_9_0.scaleAccumulate + arg_9_0.scaleDelta
	end
	
	arg_9_0.layer:setScale(arg_9_0.originZoomScale + arg_9_0.scaleAccumulate)
	arg_9_0.owner:scrollScale()
end

function WorldMapTownView.look(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_0.mapContentSize.height - arg_10_2
	arg_10_1 = arg_10_1 * -1
	arg_10_2 = arg_10_2 * -1
	
	arg_10_0.layer:setAnchorPoint(0, 0)
	arg_10_0.layer:setPosition(arg_10_1 * arg_10_0.layer:getScale() * arg_10_0.MAP_SCALE + VIEW_WIDTH / 2, arg_10_2 * arg_10_0.layer:getScale() * arg_10_0.MAP_SCALE + VIEW_HEIGHT / 2)
	
	local var_10_0, var_10_1, var_10_2, var_10_3 = arg_10_0:getAnchorBoundaryCheck()
	
	arg_10_0.layer:setAnchorPoint(var_10_0, var_10_1)
	arg_10_0.layer:setPosition(var_10_2, var_10_3)
end

function WorldMapTownView.getPositionFromAnchorAndScale(arg_11_0)
	return {
		x = arg_11_0.layer:getAnchorPoint().x * arg_11_0.WIDTH * arg_11_0.layer:getScale(),
		y = arg_11_0.layer:getAnchorPoint().y * arg_11_0.HEIGHT * arg_11_0.layer:getScale()
	}
end

function WorldMapTownView.getPositionFromAnchor(arg_12_0)
	return {
		x = arg_12_0.layer:getAnchorPoint().x * arg_12_0.WIDTH,
		y = arg_12_0.layer:getAnchorPoint().y * arg_12_0.HEIGHT
	}
end

function WorldMapTownView.getPosition(arg_13_0)
	return {
		x = arg_13_0.layer:getPositionX() * -1,
		y = arg_13_0.layer:getPositionY() * -1
	}
end

function WorldMapTownView.getAnchorBoundaryCheck(arg_14_0, arg_14_1)
	local var_14_0 = 0
	
	if arg_14_1 then
		var_14_0 = arg_14_0.layer:getScale() - arg_14_0.scaleDelta
	else
		var_14_0 = arg_14_0.layer:getScale()
	end
	
	local var_14_1 = arg_14_0:getPositionFromAnchor().x * var_14_0
	local var_14_2 = arg_14_0:getPositionFromAnchor().y * var_14_0
	local var_14_3 = arg_14_0.layer:getAnchorPoint().x
	local var_14_4 = arg_14_0.layer:getAnchorPoint().y
	local var_14_5 = arg_14_0.layer:getPositionX()
	local var_14_6 = arg_14_0.layer:getPositionY()
	
	if arg_14_0:getPosition().x + var_14_1 <= 0 then
		var_14_3 = 0
		var_14_5 = 0
	elseif arg_14_0:getPosition().x + var_14_1 > arg_14_0.WIDTH * var_14_0 - VIEW_WIDTH then
		var_14_3 = 1
		var_14_5 = VIEW_WIDTH
	end
	
	if arg_14_0:getPosition().y + var_14_2 > arg_14_0.HEIGHT * var_14_0 - VIEW_HEIGHT then
		var_14_4 = 1
		var_14_6 = VIEW_HEIGHT
	elseif arg_14_0:getPosition().y + var_14_2 <= 0 then
		var_14_4 = 0
		var_14_6 = 1
	end
	
	return var_14_3, var_14_4, var_14_5, var_14_6
end

function WorldMapTownView.getAnchorAndPostiion_FromTouchPosition(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.layer:getAnchorPoint().x
	local var_15_1 = arg_15_0.layer:getAnchorPoint().y
	local var_15_2 = arg_15_0.layer:getScale()
	local var_15_3 = arg_15_0.layer:getPositionX() * -1
	local var_15_4 = arg_15_0.layer:getPositionY() * -1
	local var_15_5 = arg_15_1 + var_15_3 + var_15_0 * arg_15_0.WIDTH * arg_15_0.layer:getScale()
	local var_15_6 = arg_15_2 + var_15_4 + var_15_1 * arg_15_0.HEIGHT * arg_15_0.layer:getScale()
	local var_15_7 = var_15_5 / (arg_15_0.WIDTH * arg_15_0.layer:getScale())
	local var_15_8 = var_15_6 / (arg_15_0.HEIGHT * arg_15_0.layer:getScale())
	local var_15_9, var_15_10 = arg_15_0:getPositionFromChangeAnchor(var_15_7, var_15_8)
	
	return var_15_7, var_15_8, var_15_9, var_15_10
end

function WorldMapTownView.getPositionFromChangeAnchor(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.layer:getPositionX()
	local var_16_1 = arg_16_0.layer:getPositionY()
	local var_16_2 = arg_16_0.layer:getAnchorPoint().x
	local var_16_3 = arg_16_0.layer:getAnchorPoint().y
	local var_16_4 = var_16_2 - arg_16_1
	local var_16_5 = var_16_3 - arg_16_2
	local var_16_6 = var_16_4 * arg_16_0.WIDTH * arg_16_0.layer:getScale()
	local var_16_7 = var_16_5 * arg_16_0.HEIGHT * arg_16_0.layer:getScale()
	local var_16_8 = var_16_0 - var_16_6
	local var_16_9 = var_16_1 - var_16_7
	
	if arg_16_1 == 0 then
		var_16_8 = 0
	elseif arg_16_1 == 1 then
		var_16_8 = VIEW_WIDTH
	end
	
	if arg_16_2 == 0 then
		var_16_9 = 0
	elseif arg_16_2 == 1 then
		var_16_9 = VIEW_HEIGHT
	end
	
	return var_16_8, var_16_9
end

function WorldMapTownView.onTouchDown(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_0.start_x, arg_17_0.start_y = SceneManager:convertLocation(arg_17_1, arg_17_2)
	arg_17_0.move_cnt = 0
	
	arg_17_3:stopPropagation()
	
	local var_17_0, var_17_1, var_17_2, var_17_3 = arg_17_0:getAnchorAndPostiion_FromTouchPosition(arg_17_1, arg_17_2)
	
	arg_17_0.layer:setAnchorPoint(var_17_0, var_17_1)
	arg_17_0.layer:setPosition(var_17_2, var_17_3)
	
	arg_17_0.delta_x = nil
	arg_17_0.delta_y = nil
	
	return true
end

function WorldMapTownView.updateMoveAction(arg_18_0)
	if arg_18_0.moveAction ~= 0 then
		arg_18_0:moveDeltaPos()
		
		arg_18_0.moveAction = arg_18_0.moveAction - 1
		
		arg_18_0.owner:updateEventNavigator()
	end
end

function WorldMapTownView.onTouchUp(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_3:stopPropagation()
	
	arg_19_0.moveAction = 10
	
	return true
end

function WorldMapTownView.onTouchMove(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if not arg_20_0.start_x then
		return 
	end
	
	arg_20_1, arg_20_2 = SceneManager:convertLocation(arg_20_1, arg_20_2)
	
	local var_20_0 = arg_20_0.start_x - arg_20_1
	local var_20_1 = arg_20_0.start_y - arg_20_2
	
	arg_20_0.start_x = arg_20_1
	arg_20_0.start_y = arg_20_2
	arg_20_0.delta_x = var_20_0
	arg_20_0.delta_y = var_20_1
	arg_20_0.move_cnt = (arg_20_0.move_cnt or 0) + 1
	
	arg_20_0:moveDeltaPos()
	arg_20_3:stopPropagation()
	
	return true
end

function WorldMapTownView.moveDeltaPos(arg_21_0, arg_21_1)
	if arg_21_0.delta_x == nil or arg_21_0.delta_y == nil then
		return 
	end
	
	local var_21_0 = arg_21_1
	
	if not arg_21_1 then
		var_21_0 = var_0_0 * (arg_21_0.layer:getScale() / TOWN_DEFAULT_SCALE)
	end
	
	local var_21_1 = arg_21_0.layer:getPositionX()
	local var_21_2 = arg_21_0.layer:getPositionY()
	local var_21_3 = var_21_1 + arg_21_0.delta_x * -1 * var_21_0
	local var_21_4 = var_21_2 + arg_21_0.delta_y * -1 * var_21_0
	local var_21_5 = arg_21_0:getPositionFromAnchorAndScale().x
	local var_21_6 = arg_21_0:getPositionFromAnchorAndScale().y
	
	if var_21_3 * -1 + VIEW_WIDTH + var_21_5 <= arg_21_0.mapContentSize.width * arg_21_0.MAP_SCALE * arg_21_0.layer:getScale() and var_21_3 * -1 + var_21_5 > 0 then
		arg_21_0.layer:setPositionX(var_21_3)
	end
	
	if var_21_4 * -1 + VIEW_HEIGHT + var_21_6 <= arg_21_0.mapContentSize.height * arg_21_0.MAP_SCALE * arg_21_0.layer:getScale() and var_21_4 * -1 + var_21_6 > 0 then
		arg_21_0.layer:setPositionY(var_21_4)
	end
end

function WorldMapTownView.onGestureZoom(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_2 - arg_22_1
	local var_22_1 = arg_22_0.maxScale
	local var_22_2 = arg_22_0.maxScale / TOWN_MIN_SCALE
	local var_22_3 = var_22_0 / VIEW_WIDTH
	
	if var_22_3 == 0 then
		return 
	end
	
	local var_22_4 = arg_22_0.layer:getScale() + var_22_3
	
	arg_22_0.scaleAccumulate = math.min(var_22_2, math.max(var_22_1, var_22_4)) - arg_22_0.originZoomScale
	
	arg_22_0.layer:setScale(arg_22_0.originZoomScale + arg_22_0.scaleAccumulate)
	
	if var_22_3 < 0 then
		local var_22_5, var_22_6, var_22_7, var_22_8 = arg_22_0:getAnchorBoundaryCheck()
		
		arg_22_0.layer:setAnchorPoint(var_22_5, var_22_6)
		arg_22_0.layer:setPosition(var_22_7, var_22_8)
	end
	
	arg_22_0.owner:scrollScale()
	arg_22_0.owner:updateEventNavigator()
	arg_22_0.owner:updateFocusDir()
end
