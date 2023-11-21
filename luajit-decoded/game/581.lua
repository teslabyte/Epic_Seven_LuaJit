ZoomController = ClassDef()

function ZoomController.constructor(arg_1_0, arg_1_1)
	arg_1_0.target = arg_1_1.layer or SceneManager:getDefaultLayer()
	arg_1_0.prev_pos_x = arg_1_0.target:getPositionX()
	arg_1_0.prev_pos_y = arg_1_0.target:getPositionY()
	arg_1_0.prev_rotation = arg_1_0.target:getRotation()
	arg_1_0.init_pos_x = arg_1_1.pos_x or 0
	arg_1_0.init_pos_y = arg_1_1.pos_y or 0
	arg_1_0.init_rotation = arg_1_1.rotate or 0
	arg_1_0.init_pivot_pos_x = arg_1_0.target:getPositionX()
	arg_1_0.init_pivot_pos_y = arg_1_0.target:getPositionY()
	arg_1_0.init_pivot_scale = arg_1_1.scale or 1
	
	if arg_1_1.min_x then
		arg_1_0.custom_min_x = arg_1_1.min_x
		arg_1_0.custom_min_y = arg_1_1.min_y
		arg_1_0.custom_max_x = arg_1_1.max_x
		arg_1_0.custom_max_y = arg_1_1.max_y
	end
	
	arg_1_0.min_scale = arg_1_1.min_scale or 0.8
	arg_1_0.max_scale = arg_1_1.max_scale or 8
	arg_1_0.head_line_check = arg_1_1.head_line_check
	arg_1_0.sz = arg_1_1.sz or {
		width = VIEW_WIDTH,
		height = VIEW_HEIGHT
	}
	arg_1_0.notAImage = not arg_1_1.sz
	
	arg_1_0:attachZoomNode()
	arg_1_0:init()
end

function ZoomController.init(arg_2_0)
	arg_2_0.target:setPositionX(arg_2_0.init_pos_x)
	arg_2_0.target:setPositionY(arg_2_0.init_pos_y)
	arg_2_0.target:setRotation(arg_2_0.init_rotation)
	arg_2_0.pivot:setPositionX(arg_2_0.init_pivot_pos_x)
	arg_2_0.pivot:setPositionY(arg_2_0.init_pivot_pos_y)
	arg_2_0.pivot:setScale(arg_2_0.init_pivot_scale)
end

function ZoomController.resetLayer(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0:detachZoomNode()
	
	arg_3_0.target = arg_3_1
	arg_3_0.sz = arg_3_2 or {
		width = VIEW_WIDTH,
		height = VIEW_HEIGHT
	}
	arg_3_0.notAImage = not arg_3_2
	arg_3_0.init_pivot_pos_x = arg_3_3
	arg_3_0.init_pivot_pos_y = arg_3_4
	arg_3_0.init_pivot_scale = arg_3_5
	arg_3_0.min_scale = arg_3_0.init_pivot_scale
	
	arg_3_0:attachZoomNode()
	arg_3_0:init()
end

function ZoomController.attachZoomNode(arg_4_0)
	arg_4_0.pivot = cc.Node:create()
	
	arg_4_0.pivot:retain()
	arg_4_0.pivot:setName("pivot")
	arg_4_0.target:getParent():addChild(arg_4_0.pivot)
	arg_4_0.target:retain()
	arg_4_0.target:removeFromParent()
	arg_4_0.pivot:addChild(arg_4_0.target)
end

function ZoomController.detachZoomNode(arg_5_0)
	arg_5_0.target:setPositionX(arg_5_0.prev_pos_x)
	arg_5_0.target:setPositionY(arg_5_0.prev_pos_y)
	arg_5_0.target:setRotation(arg_5_0.prev_rotation)
	arg_5_0.target:removeFromParent()
	arg_5_0.pivot:getParent():addChild(arg_5_0.target)
	arg_5_0.pivot:removeFromParent()
end

function ZoomController.setHeadLineMode(arg_6_0, arg_6_1)
	arg_6_0.head_line_check = arg_6_1
end

function ZoomController.zoom(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.isZoom = true
	
	local var_7_0 = arg_7_0.pivot:convertToWorldSpace({
		x = 0,
		y = 0
	})
	local var_7_1 = arg_7_2.x - var_7_0.x
	local var_7_2 = arg_7_2.y - var_7_0.y
	local var_7_3 = var_7_1
	local var_7_4 = var_7_2
	
	arg_7_0.pivot:setPositionX(arg_7_0.pivot:getPositionX() + var_7_3)
	arg_7_0.pivot:setPositionY(arg_7_0.pivot:getPositionY() + var_7_4)
	
	local var_7_5 = arg_7_0.pivot:getScale()
	local var_7_6 = var_7_1 / var_7_5
	local var_7_7 = var_7_2 / var_7_5
	
	arg_7_0.target:setPositionX(arg_7_0.target:getPositionX() - var_7_6)
	arg_7_0.target:setPositionY(arg_7_0.target:getPositionY() - var_7_7)
	
	local var_7_8 = arg_7_0.pivot:getScale()
	
	arg_7_0.pivot:setScale(math.clamp(var_7_5 + arg_7_1, arg_7_0.min_scale, arg_7_0.max_scale))
	
	if not arg_7_0:headLineCheck(arg_7_0.pivot:getScale()) then
		arg_7_0.target:setPositionX(arg_7_0.target:getPositionX() + var_7_6)
		arg_7_0.target:setPositionY(arg_7_0.target:getPositionY() + var_7_7)
		arg_7_0.pivot:setScale(var_7_8)
		arg_7_0.pivot:setPositionX(arg_7_0.pivot:getPositionX() - var_7_3)
		arg_7_0.pivot:setPositionY(arg_7_0.pivot:getPositionY() - var_7_4)
		
		return 
	end
	
	arg_7_0:move({
		x = 0,
		y = 0
	})
end

function ZoomController.onMouseWheel(arg_8_0, arg_8_1)
	local var_8_0 = 0.1
	
	arg_8_0:zoom(-arg_8_1:getScrollY() * var_8_0, {
		x = arg_8_1:getCursorX(),
		y = arg_8_1:getCursorY()
	})
end

function ZoomController.onGestureZoom(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = (arg_9_2 - arg_9_1) * 4 / VIEW_WIDTH * arg_9_0.pivot:getScale()
	
	arg_9_0:zoom(var_9_0, arg_9_3)
end

function ZoomController.onTouchDown(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.isZoom = false
	
	if Action:Find("double_tap") then
		arg_10_0:init()
		
		return true
	end
	
	Action:Add(SEQ(DELAY(300)), arg_10_0, "double_tap")
	
	arg_10_0.touch_pos = arg_10_0:touchToScene(arg_10_1:getLocation())
	
	return true
end

function ZoomController.onTouchUp(arg_11_0, arg_11_1, arg_11_2)
	return true
end

function ZoomController.touchToScene(arg_12_0, arg_12_1)
	local var_12_0 = {}
	
	var_12_0.x, var_12_0.y = SceneManager:convertLocation(arg_12_1.x, arg_12_1.y)
	
	return var_12_0
end

function ZoomController.onTouchMove(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.touch_pos then
		return 
	end
	
	if arg_13_0.isZoom == true then
		return 
	end
	
	arg_13_0.move_cnt = (arg_13_0.move_cnt or 0) + 1
	
	local var_13_0 = arg_13_0:touchToScene(arg_13_1:getLocation())
	
	arg_13_0:move({
		x = var_13_0.x - arg_13_0.touch_pos.x,
		y = var_13_0.y - arg_13_0.touch_pos.y
	})
	
	arg_13_0.touch_pos = var_13_0
	
	return true
end

function ZoomController.headLineCheck(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0.head_line_check then
		return true
	end
	
	local var_14_0 = false
	local var_14_1 = 120
	local var_14_2 = 120
	local var_14_3 = -20
	local var_14_4 = var_14_2 / 2 + 220
	local var_14_5 = -var_14_2 / 2 + 220
	local var_14_6 = var_14_1 / 2 + var_14_3
	local var_14_7 = -var_14_1 / 2 + var_14_3
	local var_14_8 = 100
	
	if not get_cocos_refid(arg_14_0._layer_color_2) and DEBUG.CHECK_HEAD_LINE then
		arg_14_0._layer_color_2 = cc.LayerColor:create(cc.c3b(128, 255, 255))
		
		arg_14_0._layer_color_2:setAnchorPoint(0, 0)
		arg_14_0._layer_color_2:setOpacity(128)
		arg_14_0.target:addChild(arg_14_0._layer_color_2)
	end
	
	if get_cocos_refid(arg_14_0._layer_color_2) then
		arg_14_0._layer_color_2:setPosition(var_14_7, var_14_5 + var_14_8)
	end
	
	local var_14_9 = arg_14_0.pivot:getParent():convertToNodeSpace(arg_14_0.target:convertToWorldSpace({
		x = var_14_7,
		y = var_14_5 + var_14_8
	}))
	local var_14_10 = var_14_9.x
	local var_14_11 = var_14_9.y
	
	if get_cocos_refid(arg_14_0._layer_color_2) then
		arg_14_0._layer_color_2:setContentSize({
			width = var_14_6 - var_14_7,
			height = var_14_4 - var_14_5
		})
	end
	
	return var_14_11 + var_14_2 * arg_14_1 < VIEW_HEIGHT and var_14_11 > 0 and var_14_10 + var_14_1 * arg_14_1 < VIEW_WIDTH / 2 and var_14_10 > -VIEW_WIDTH / 2 and true or false
end

function ZoomController.move(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.pivot:getScale()
	local var_15_1 = arg_15_0.sz
	local var_15_2 = var_15_1.width - VIEW_WIDTH / var_15_0
	local var_15_3 = var_15_1.height - VIEW_HEIGHT / var_15_0
	local var_15_4 = (arg_15_0.init_pivot_pos_x - arg_15_0.pivot:getPositionX()) / var_15_0
	local var_15_5 = (arg_15_0.init_pivot_pos_y - arg_15_0.pivot:getPositionY()) / var_15_0
	local var_15_6 = var_15_4 - var_15_2 / 2
	local var_15_7 = var_15_4 + var_15_2 / 2
	local var_15_8 = var_15_5 - var_15_3 / 2
	local var_15_9 = var_15_5 + var_15_3 / 2
	
	if arg_15_0.notAImage then
		var_15_6 = var_15_4 - var_15_1.width / 2
		var_15_7 = var_15_4 + var_15_1.width / 2
		var_15_8 = var_15_5 - var_15_1.height / 2
		var_15_9 = var_15_5 + var_15_1.height / 2
	end
	
	if arg_15_0.custom_min_x then
		var_15_6 = var_15_4 + arg_15_0.custom_min_x / var_15_0
		var_15_7 = var_15_4 + arg_15_0.custom_max_x / var_15_0
		var_15_8 = var_15_5 + arg_15_0.custom_min_y / var_15_0
		var_15_9 = var_15_5 + arg_15_0.custom_max_y / var_15_0
	end
	
	local var_15_10 = arg_15_1.x / var_15_0
	local var_15_11 = arg_15_1.y / var_15_0
	
	arg_15_0.target:setPositionX(arg_15_0.target:getPositionX() + var_15_10)
	arg_15_0.target:setPositionY(arg_15_0.target:getPositionY() + var_15_11)
	
	if not arg_15_0:headLineCheck(var_15_0, var_15_10, var_15_11) then
		arg_15_0.target:setPositionX(arg_15_0.target:getPositionX() - var_15_10)
		arg_15_0.target:setPositionY(arg_15_0.target:getPositionY() - var_15_11)
	elseif not arg_15_0.head_line_check then
		arg_15_0.target:setPositionX(math.clamp(arg_15_0.target:getPositionX() + arg_15_1.x / var_15_0, var_15_6, var_15_7))
		arg_15_0.target:setPositionY(math.clamp(arg_15_0.target:getPositionY() + arg_15_1.y / var_15_0, var_15_8, var_15_9))
	end
end
