CustomProfileCard.shape = {}

function CustomProfileCard.shape.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.parent = arg_1_1.parent
	
	local var_1_0 = load_control("wnd/profile_custom_item.csb")
	
	arg_1_0.shape = var_1_0:getChildByName("n_unit")
	
	local var_1_1 = arg_1_0.parent:getWnd()
	
	if arg_1_0.parent and get_cocos_refid(var_1_1) then
		local var_1_2 = arg_1_1.type or arg_1_0.parent:convertNumberToType(arg_1_1.load_data[1])
		
		arg_1_0.layer_wnd = CustomProfileCard:createParentLayerNode(var_1_2)
		
		if get_cocos_refid(arg_1_0.layer_wnd) then
			var_1_0:setAnchorPoint(0.5, 0.5)
			var_1_0:setPosition(0, 0)
			arg_1_0.layer_wnd:addChild(var_1_0)
		end
		
		local var_1_3 = var_1_1:getChildByName("n_edit_on")
		
		if get_cocos_refid(var_1_3) then
			var_1_3:addChild(arg_1_0.layer_wnd)
		end
	end
	
	arg_1_0:load(arg_1_1)
	arg_1_0:createShape(arg_1_1)
end

function CustomProfileCard.shape.delete(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.layer_wnd) then
		return 
	end
	
	if not arg_2_0.edit or not get_cocos_refid(arg_2_0.edit.area_wnd) or not get_cocos_refid(arg_2_0.edit.btn_select_move) then
		return 
	end
	
	arg_2_0.parent = nil
	arg_2_0.vars = nil
	
	arg_2_0.layer_wnd:removeFromParent()
	arg_2_0.edit.area_wnd:removeFromParent()
	arg_2_0.edit.btn_select_move:removeFromParent()
	
	arg_2_0.edit = nil
end

function CustomProfileCard.shape.clone(arg_3_0)
	if not arg_3_0.parent or not arg_3_0.vars or not get_cocos_refid(arg_3_0.shape) then
		return 
	end
	
	local var_3_0 = arg_3_0:save()
	
	if not table.empty(var_3_0) and not table.empty(var_3_0[3]) then
		var_3_0[3].x = var_3_0[3].x + 5
		var_3_0[3].y = var_3_0[3].y - 5
	end
	
	return var_3_0
end

function CustomProfileCard.shape.load(arg_4_0, arg_4_1)
	if table.empty(arg_4_1.load_data) then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.order = arg_4_1.order
	arg_4_0.vars.type = arg_4_0.parent:convertNumberToType(arg_4_1.load_data[1]) or "shape"
	arg_4_0.vars.id = arg_4_1.load_data[2]
	arg_4_0.vars.pos = table.copyElement(arg_4_1.load_data[3], {
		"x",
		"y"
	})
	arg_4_0.vars.rotation = arg_4_1.load_data[4] or 0
	arg_4_0.vars.opacity_rate = arg_4_1.load_data[5] or 100
	arg_4_0.vars.size = table.copyElement(arg_4_1.load_data[6], {
		"w",
		"h"
	})
	arg_4_0.vars.color = table.copyElement(arg_4_1.load_data[7], {
		"r",
		"g",
		"b"
	})
	arg_4_0.vars.is_visible = arg_4_0.parent:convertNumberToBoolen(arg_4_1.load_data[8])
	arg_4_0.vars.is_lock = arg_4_0.parent:convertNumberToBoolen(arg_4_1.load_data[9])
end

function CustomProfileCard.shape.save(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.shape) then
		return nil
	end
	
	local var_5_0 = {
		arg_5_0.parent:convertTypeToNumber(arg_5_0.vars.type),
		arg_5_0.vars.id,
		(table.copyElement(arg_5_0.vars.pos, {
			"x",
			"y"
		}))
	}
	
	var_5_0[3].x = math.floor(var_5_0[3].x * 10) / 10
	var_5_0[3].y = math.floor(var_5_0[3].y * 10) / 10
	var_5_0[4] = math.floor(arg_5_0.vars.rotation * 10) / 10
	var_5_0[5] = arg_5_0.vars.opacity_rate
	var_5_0[6] = table.copyElement(arg_5_0.vars.size, {
		"w",
		"h"
	})
	var_5_0[6].w = math.floor(var_5_0[6].w * 10) / 10
	var_5_0[6].h = math.floor(var_5_0[6].h * 10) / 10
	var_5_0[7] = table.copyElement(arg_5_0.vars.color, {
		"r",
		"g",
		"b"
	})
	var_5_0[8] = arg_5_0.parent:convertBoolenToNumber(arg_5_0.vars.is_visible)
	var_5_0[9] = arg_5_0.parent:convertBoolenToNumber(arg_5_0.vars.is_lock)
	
	return var_5_0
end

function CustomProfileCard.shape.initDB(arg_6_0, arg_6_1)
	if arg_6_0.vars or not get_cocos_refid(arg_6_0.shape) then
		return 
	end
	
	arg_6_0.vars = {}
	arg_6_0.vars.order = arg_6_1.order
	arg_6_0.vars.type = arg_6_1.type or "shape"
	arg_6_0.vars.id = arg_6_1.id
	arg_6_0.vars.pos = {}
	arg_6_0.vars.pos.x = math.floor(arg_6_0.shape:getPositionX() * 10) / 10
	arg_6_0.vars.pos.y = math.floor(arg_6_0.shape:getPositionY() * 10) / 10
	
	local var_6_0 = arg_6_0.shape:getContentSize()
	
	arg_6_0.vars.size = {}
	arg_6_0.vars.size.w = math.floor(var_6_0.width * 10) / 10
	arg_6_0.vars.size.h = math.floor(var_6_0.height * 10) / 10
	arg_6_0.vars.rotation = math.floor(arg_6_0.shape:getRotation() * 10) / 10
	arg_6_0.vars.opacity_rate = round(arg_6_0.shape:getOpacity() / 2.55)
	arg_6_0.vars.color = arg_6_0.shape:getColor()
	arg_6_0.vars.is_visible = arg_6_0.shape:isVisible()
	arg_6_0.vars.is_lock = false
end

function CustomProfileCard.shape.createShape(arg_7_0, arg_7_1)
	if not get_cocos_refid(arg_7_0.shape) then
		return 
	end
	
	local var_7_0 = arg_7_1.id or arg_7_1.load_data[2]
	
	if var_7_0 then
		local var_7_1 = DB("item_material_profile", var_7_0, {
			"material_id"
		})
		local var_7_2 = DBT("item_material", var_7_1, {
			"ma_type",
			"ma_type2",
			"icon"
		})
		
		if table.empty(var_7_2) then
			return 
		end
		
		local var_7_3 = var_7_2.ma_type .. "/" .. var_7_2.ma_type2 .. "/" .. var_7_2.icon
		
		if_set_sprite(arg_7_0.shape, nil, var_7_3 .. ".png")
		arg_7_0.shape:setColor(cc.c3b(88, 106, 139))
		arg_7_0:initDB(arg_7_1)
		arg_7_0.shape:setPosition(arg_7_0.vars.pos.x, arg_7_0.vars.pos.y)
		arg_7_0.shape:setContentSize(arg_7_0.vars.size.w, arg_7_0.vars.size.h)
		arg_7_0.shape:setRotation(arg_7_0.vars.rotation)
		arg_7_0.shape:setOpacity(round(2.55 * arg_7_0.vars.opacity_rate))
		arg_7_0.shape:setColor(cc.c3b(arg_7_0.vars.color.r, arg_7_0.vars.color.g, arg_7_0.vars.color.b))
		arg_7_0.shape:setVisible(arg_7_0.vars.is_visible)
		arg_7_0.layer_wnd:setLocalZOrder(arg_7_0.vars.order)
		
		if arg_7_1.is_edit_mode then
			arg_7_0:createEditBox()
		end
	end
end

function CustomProfileCard.shape.setOrder(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_0.vars.order = arg_8_1
	
	if get_cocos_refid(arg_8_0.layer_wnd) then
		arg_8_0.layer_wnd:setLocalZOrder(arg_8_0.vars.order)
	end
	
	if arg_8_0.edit and get_cocos_refid(arg_8_0.edit.area_wnd) and get_cocos_refid(arg_8_0.edit.btn_select_move) then
		arg_8_0.edit.area_wnd:setLocalZOrder(arg_8_0.vars.order)
		arg_8_0.edit.btn_select_move:setLocalZOrder(arg_8_0.vars.order)
	end
end

function CustomProfileCard.shape.getOrder(arg_9_0)
	if not arg_9_0.vars then
		return nil
	end
	
	return arg_9_0.vars.order
end

function CustomProfileCard.shape.getType(arg_10_0)
	if not arg_10_0.vars then
		return nil
	end
	
	return arg_10_0.vars.type or "shape"
end

function CustomProfileCard.shape.getId(arg_11_0)
	if not arg_11_0.vars then
		return nil
	end
	
	return arg_11_0.vars.id
end

function CustomProfileCard.shape.getShapeColor(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.shape) then
		return nil
	end
	
	return arg_12_0.vars.color or arg_12_0.shape:getColor()
end

function CustomProfileCard.shape.getOpacityRate(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.shape) then
		return nil
	end
	
	return arg_13_0.vars.opacity_rate or round(arg_13_0.shape:getOpacity() / 2.55)
end

function CustomProfileCard.shape.isVisible(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.shape) then
		return false
	end
	
	return arg_14_0.vars.is_visible or arg_14_0.shape:isVisible()
end

function CustomProfileCard.shape.isLock(arg_15_0)
	if not arg_15_0.vars then
		return false
	end
	
	return arg_15_0.vars.is_lock
end

function CustomProfileCard.shape.createEditBox(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.shape) then
		return 
	end
	
	arg_16_0.edit = {}
	arg_16_0.edit.extra_size = 60
	arg_16_0.edit.min_size = {
		w = 10,
		h = 10
	}
	
	local var_16_0 = arg_16_0.shape:getContentSize()
	local var_16_1 = var_16_0.width + arg_16_0.edit.extra_size
	local var_16_2 = var_16_0.height + arg_16_0.edit.extra_size
	local var_16_3 = -(arg_16_0.edit.extra_size / 2)
	local var_16_4 = -(arg_16_0.edit.extra_size / 2)
	local var_16_5 = arg_16_0.parent:getWnd()
	local var_16_6 = var_16_5:getChildByName("n_edit_boxes")
	
	arg_16_0.edit.area_wnd = cc.DrawNode:create(1)
	
	arg_16_0.edit.area_wnd:setName("n_edit_area")
	arg_16_0.edit.area_wnd:setAnchorPoint(0.5, 0.5)
	arg_16_0.edit.area_wnd:setPosition(var_16_1 * 0.5 + var_16_3, var_16_2 * 0.5 + var_16_4)
	arg_16_0.edit.area_wnd:setContentSize(var_16_1, var_16_2)
	arg_16_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_16_1, var_16_2), cc.c4f(1, 1, 1, 1))
	arg_16_0.edit.area_wnd:setTransformParent(arg_16_0.shape)
	arg_16_0.edit.area_wnd:setLocalZOrder(arg_16_0.vars.order)
	var_16_6:addChild(arg_16_0.edit.area_wnd)
	
	local var_16_7 = var_16_5:getChildByName("n_select_boxes")
	
	arg_16_0.edit.btn_select_move = ccui.Button:create()
	
	arg_16_0.edit.btn_select_move:setName("btn_select_move")
	arg_16_0.edit.btn_select_move:setAnchorPoint(0.5, 0.5)
	arg_16_0.edit.btn_select_move:setTouchEnabled(true)
	arg_16_0.edit.btn_select_move:ignoreContentAdaptWithSize(false)
	arg_16_0.edit.btn_select_move:setPosition(var_16_1 * 0.5, var_16_2 * 0.5)
	arg_16_0.edit.btn_select_move:setContentSize(var_16_1, var_16_2)
	arg_16_0.edit.btn_select_move:setTransformParent(arg_16_0.edit.area_wnd)
	arg_16_0.edit.btn_select_move:setLocalZOrder(arg_16_0.vars.order)
	arg_16_0.edit.btn_select_move:setVisible(not arg_16_0.vars.is_lock)
	var_16_7:addChild(arg_16_0.edit.btn_select_move)
	
	local var_16_8 = load_control("wnd/custom_edit_control.csb")
	
	var_16_8:setName("n_side_btns")
	arg_16_0.edit.area_wnd:addChild(var_16_8)
	
	local var_16_9 = load_control("wnd/custom_edit_control.csb")
	
	var_16_9:setName("n_corner_btns")
	arg_16_0.edit.area_wnd:addChild(var_16_9)
	
	local var_16_10 = {
		side_btns = var_16_8,
		corner_btns = var_16_9
	}
	
	for iter_16_0, iter_16_1 in pairs(var_16_10) do
		if_set_visible(iter_16_1, "n_crop", false)
		if_set_visible(iter_16_1, "n_side", false)
		if_set_visible(iter_16_1, "n_fixed", false)
		if_set_visible(iter_16_1, "n_multi", false)
		
		if iter_16_0 == "side_btns" then
			local var_16_11 = iter_16_1:getChildByName("n_side")
			
			var_16_11:setVisible(true)
			if_set_visible(var_16_11, "n_north", true)
			if_set_visible(var_16_11, "n_south", true)
			if_set_visible(var_16_11, "n_west", true)
			if_set_visible(var_16_11, "n_east", true)
			
			arg_16_0.edit.btn_scale_y_top = var_16_11:getChildByName("n_north")
			
			if get_cocos_refid(arg_16_0.edit.btn_scale_y_top) then
				arg_16_0.edit.btn_scale_y_top:setPosition(var_16_1 * 0.5, var_16_2)
			end
			
			arg_16_0.edit.btn_scale_y_bottom = var_16_11:getChildByName("n_south")
			
			if get_cocos_refid(arg_16_0.edit.btn_scale_y_bottom) then
				arg_16_0.edit.btn_scale_y_bottom:setPosition(var_16_1 * 0.5, 0)
			end
			
			arg_16_0.edit.btn_scale_x_left = var_16_11:getChildByName("n_west")
			
			if get_cocos_refid(arg_16_0.edit.btn_scale_x_left) then
				arg_16_0.edit.btn_scale_x_left:setPosition(0, var_16_2 * 0.5)
			end
			
			arg_16_0.edit.btn_scale_x_right = var_16_11:getChildByName("n_east")
			
			if get_cocos_refid(arg_16_0.edit.btn_scale_x_right) then
				arg_16_0.edit.btn_scale_x_right:setPosition(var_16_1, var_16_2 * 0.5)
			end
		else
			local var_16_12 = iter_16_1:getChildByName("n_multi")
			
			var_16_12:setVisible(true)
			if_set_visible(var_16_12, "n_ratio", true)
			if_set_visible(var_16_12, "n_rotate", true)
			if_set_visible(var_16_12, "n_off", true)
			
			arg_16_0.edit.btn_rotate = var_16_12:getChildByName("n_rotate")
			
			if get_cocos_refid(arg_16_0.edit.btn_rotate) then
				arg_16_0.edit.btn_rotate:setPosition(0, 0)
			end
			
			arg_16_0.edit.btn_delete = var_16_12:getChildByName("n_off")
			
			if get_cocos_refid(arg_16_0.edit.btn_delete) then
				arg_16_0.edit.btn_delete:setPosition(var_16_1, var_16_2)
			end
			
			arg_16_0.edit.btn_corner_scale_left = var_16_12:getChildByName("n_ratio")
			
			if get_cocos_refid(arg_16_0.edit.btn_corner_scale_left) then
				arg_16_0.edit.btn_corner_scale_left:setPosition(0, var_16_2)
			end
			
			arg_16_0.edit.btn_corner_scale_right = arg_16_0.edit.btn_corner_scale_left:clone()
			
			var_16_12:addChild(arg_16_0.edit.btn_corner_scale_right)
			
			if get_cocos_refid(arg_16_0.edit.btn_corner_scale_right) then
				arg_16_0.edit.btn_corner_scale_right:setPosition(var_16_1, 0)
			end
		end
	end
	
	arg_16_0:activeEditorBox(false)
	arg_16_0:addTouchEventListener()
end

function CustomProfileCard.shape.activeEditorBox(arg_17_0, arg_17_1)
	if not arg_17_0.edit or not get_cocos_refid(arg_17_0.edit.area_wnd) then
		return 
	end
	
	arg_17_0.edit.area_wnd:setVisible(arg_17_1)
end

function CustomProfileCard.shape.renderEditorBox(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.shape) then
		return 
	end
	
	if not arg_18_0.edit or not get_cocos_refid(arg_18_0.edit.area_wnd) or not arg_18_0.edit.extra_size then
		return 
	end
	
	local var_18_0 = arg_18_0.shape:getContentSize()
	local var_18_1 = var_18_0.width + arg_18_0.edit.extra_size
	local var_18_2 = var_18_0.height + arg_18_0.edit.extra_size
	local var_18_3 = -(arg_18_0.edit.extra_size / 2)
	local var_18_4 = -(arg_18_0.edit.extra_size / 2)
	
	arg_18_0.edit.area_wnd:setPosition(var_18_1 * 0.5 + var_18_3, var_18_2 * 0.5 + var_18_4)
	arg_18_0.edit.area_wnd:setContentSize(var_18_1, var_18_2)
	arg_18_0.edit.area_wnd:clear()
	arg_18_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_18_1, var_18_2), cc.c4f(1, 1, 1, 1))
	arg_18_0.edit.area_wnd:visit()
	arg_18_0.edit.btn_select_move:setPosition(var_18_1 * 0.5, var_18_2 * 0.5)
	arg_18_0.edit.btn_select_move:setContentSize(var_18_1, var_18_2)
	
	if get_cocos_refid(arg_18_0.edit.btn_scale_y_top) then
		arg_18_0.edit.btn_scale_y_top:setPosition(var_18_1 * 0.5, var_18_2)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_scale_y_bottom) then
		arg_18_0.edit.btn_scale_y_bottom:setPosition(var_18_1 * 0.5, 0)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_scale_x_left) then
		arg_18_0.edit.btn_scale_x_left:setPosition(0, var_18_2 * 0.5)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_scale_x_right) then
		arg_18_0.edit.btn_scale_x_right:setPosition(var_18_1, var_18_2 * 0.5)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_rotate) then
		arg_18_0.edit.btn_rotate:setPosition(0, 0)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_delete) then
		arg_18_0.edit.btn_delete:setPosition(var_18_1, var_18_2)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_corner_scale_left) then
		arg_18_0.edit.btn_corner_scale_left:setPosition(0, var_18_2)
	end
	
	if get_cocos_refid(arg_18_0.edit.btn_corner_scale_right) then
		arg_18_0.edit.btn_corner_scale_right:setPosition(var_18_1, 0)
	end
end

function CustomProfileCard.shape.addTouchEventListener(arg_19_0)
	if not arg_19_0.edit or not get_cocos_refid(arg_19_0.edit.area_wnd) then
		return 
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_select_move) then
		arg_19_0.edit.btn_select_move:addTouchEventListener(function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
			arg_19_0:shapeMoveEventHandler(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_scale_y_top) then
		arg_19_0.edit.btn_scale_y_top:getChildByName("btn"):addTouchEventListener(function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			arg_19_0:shapeScaleYEventHandler(arg_21_0, arg_21_1, arg_21_2, arg_21_3, "top")
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_scale_y_bottom) then
		arg_19_0.edit.btn_scale_y_bottom:getChildByName("btn"):addTouchEventListener(function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			arg_19_0:shapeScaleYEventHandler(arg_22_0, arg_22_1, arg_22_2, arg_22_3, "bottom")
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_scale_x_left) then
		arg_19_0.edit.btn_scale_x_left:getChildByName("btn"):addTouchEventListener(function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			arg_19_0:shapeScaleXEventHandler(arg_23_0, arg_23_1, arg_23_2, arg_23_3, "left")
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_scale_x_right) then
		arg_19_0.edit.btn_scale_x_right:getChildByName("btn"):addTouchEventListener(function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			arg_19_0:shapeScaleXEventHandler(arg_24_0, arg_24_1, arg_24_2, arg_24_3, "right")
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_corner_scale_left) then
		arg_19_0.edit.btn_corner_scale_left:getChildByName("btn"):addTouchEventListener(function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			arg_19_0:shapeCornerScaleEventHandler(arg_25_0, arg_25_1, arg_25_2, arg_25_3, "left")
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_corner_scale_right) then
		arg_19_0.edit.btn_corner_scale_right:getChildByName("btn"):addTouchEventListener(function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			arg_19_0:shapeCornerScaleEventHandler(arg_26_0, arg_26_1, arg_26_2, arg_26_3, "right")
		end)
	end
	
	if get_cocos_refid(arg_19_0.edit.btn_rotate) then
		arg_19_0.edit.btn_rotate:getChildByName("btn"):addTouchEventListener(function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			arg_19_0:shapeRotateEventHandler(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		end)
	end
	
	arg_19_0.edit.touch_move_btn_count = 0
	arg_19_0.edit.touch_corner_scale_btn_count = 0
	arg_19_0.edit.touch_scale_x_btn_count = 0
	arg_19_0.edit.touch_scale_y_btn_count = 0
	arg_19_0.edit.touch_rotate_btn_count = 0
	
	if get_cocos_refid(arg_19_0.edit.btn_delete) then
		arg_19_0.edit.btn_delete:getChildByName("btn"):addTouchEventListener(function(arg_28_0, arg_28_1)
			arg_19_0:shapeRemoveEventHandler(arg_28_0, arg_28_1)
		end)
	end
end

function CustomProfileCard.shape.shapeMoveEventHandler(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.shape) or not get_cocos_refid(arg_29_1) then
		return 
	end
	
	if not arg_29_0.edit or not get_cocos_refid(arg_29_0.edit.area_wnd) then
		return 
	end
	
	if arg_29_0.vars.is_lock then
		return 
	end
	
	if arg_29_0.edit.is_rotate or arg_29_0.edit.is_corner_scale or arg_29_0.edit.is_scale_x or arg_29_0.edit.is_scale_y then
		return 
	end
	
	if arg_29_2 == 0 then
		arg_29_0.edit.touch_move_btn_count = arg_29_0.edit.touch_move_btn_count + 1
		
		if arg_29_0.edit.touch_move_btn_count == 1 then
			if not CustomProfileCardEditor:isFocusLayer(arg_29_0) and arg_29_1:getName() == "btn_select_move" then
				CustomProfileCardEditor:setFocusLayer(arg_29_0)
			end
			
			arg_29_0.edit.is_move = true
			arg_29_0.edit.touch_begin_pos = {
				x = arg_29_3,
				y = arg_29_4
			}
			arg_29_0.edit.origin_shape_pos = {
				x = arg_29_0.shape:getPositionX(),
				y = arg_29_0.shape:getPositionY()
			}
		end
	elseif arg_29_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_29_0) then
			return 
		end
		
		if table.empty(arg_29_0.edit.touch_begin_pos) or table.empty(arg_29_0.edit.origin_shape_pos) or not arg_29_0.edit.is_move or arg_29_0.edit.touch_move_btn_count ~= 1 then
			return 
		end
		
		arg_29_0.is_move = true
		arg_29_0.edit.touch_move_pos = nil
		arg_29_0.edit.touch_move_pos = {
			x = arg_29_3,
			y = arg_29_4
		}
		
		local var_29_0 = arg_29_0.edit.touch_move_pos.x - arg_29_0.edit.touch_begin_pos.x
		local var_29_1 = arg_29_0.edit.touch_move_pos.y - arg_29_0.edit.touch_begin_pos.y
		
		arg_29_0:setPosition(arg_29_0.edit.origin_shape_pos.x + var_29_0, arg_29_0.edit.origin_shape_pos.y + var_29_1)
	else
		arg_29_0.edit.touch_move_btn_count = arg_29_0.edit.touch_move_btn_count - 1
		
		if arg_29_0.edit.touch_move_btn_count <= 0 then
			if not table.empty(arg_29_0.edit.origin_shape_pos) and not table.empty(arg_29_0.vars.pos) and (math.abs(arg_29_0.edit.origin_shape_pos.x - arg_29_0.vars.pos.x) >= 0.1 or math.abs(arg_29_0.edit.origin_shape_pos.y - arg_29_0.vars.pos.y) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_29_0,
					undo_func = bind_func(arg_29_0.setPosition, arg_29_0, arg_29_0.edit.origin_shape_pos.x, arg_29_0.edit.origin_shape_pos.y),
					redo_func = bind_func(arg_29_0.setPosition, arg_29_0, arg_29_0.vars.pos.x, arg_29_0.vars.pos.y)
				}, true)
			end
			
			arg_29_0.edit.touch_move_btn_count = 0
			arg_29_0.edit.is_move = false
			arg_29_0.edit.touch_begin_pos = nil
			arg_29_0.edit.origin_shape_pos = nil
			arg_29_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.shape.shapeCornerScaleEventHandler(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.shape) or not get_cocos_refid(arg_30_1) or not arg_30_5 then
		return 
	end
	
	if not arg_30_0.edit or not get_cocos_refid(arg_30_0.edit.area_wnd) then
		return 
	end
	
	if arg_30_0.edit.is_move or arg_30_0.edit.is_rotate or arg_30_0.edit.is_scale_x or arg_30_0.edit.is_scale_y then
		return 
	end
	
	if arg_30_2 == 0 then
		arg_30_0.edit.touch_corner_scale_btn_count = arg_30_0.edit.touch_corner_scale_btn_count + 1
		
		if arg_30_0.edit.touch_corner_scale_btn_count == 1 then
			arg_30_0.edit.is_corner_scale = true
			arg_30_0.edit.touch_begin_pos = arg_30_1:convertToWorldSpace({
				x = arg_30_1:getPositionX(),
				y = arg_30_1:getPositionY()
			})
			
			local var_30_0 = arg_30_0.shape:getContentSize()
			local var_30_1 = arg_30_0.shape:getAnchorPoint()
			local var_30_2 = {
				x = var_30_0.width * var_30_1.x,
				y = var_30_0.height * var_30_1.y
			}
			
			arg_30_0.edit.center_pos = arg_30_0.shape:convertToWorldSpace({
				x = var_30_2.x,
				y = var_30_2.y
			})
			arg_30_0.edit.origin_shape_size = var_30_0
			arg_30_0.edit.origin_shape_angle = arg_30_0.shape:getRotation()
		end
	elseif arg_30_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_30_0) then
			return 
		end
		
		if table.empty(arg_30_0.edit.touch_begin_pos) or table.empty(arg_30_0.edit.center_pos) or not arg_30_0.edit.origin_shape_angle or not arg_30_0.edit.is_corner_scale or arg_30_0.edit.touch_corner_scale_btn_count ~= 1 then
			return 
		end
		
		arg_30_0.edit.is_corner_scale = true
		arg_30_0.edit.touch_move_pos = {
			x = arg_30_3,
			y = arg_30_4
		}
		
		local var_30_3 = math.sin(math.rad(arg_30_0.edit.origin_shape_angle))
		local var_30_4 = math.cos(math.rad(arg_30_0.edit.origin_shape_angle))
		local var_30_5 = (arg_30_0.edit.touch_begin_pos.x - arg_30_0.edit.center_pos.x) * var_30_4 - (arg_30_0.edit.touch_begin_pos.y - arg_30_0.edit.center_pos.y) * var_30_3 + arg_30_0.edit.center_pos.x
		local var_30_6 = (arg_30_0.edit.touch_begin_pos.x - arg_30_0.edit.center_pos.x) * var_30_3 + (arg_30_0.edit.touch_begin_pos.y - arg_30_0.edit.center_pos.y) * var_30_4 + arg_30_0.edit.center_pos.y
		local var_30_7 = (arg_30_0.edit.touch_move_pos.x - arg_30_0.edit.center_pos.x) * var_30_4 - (arg_30_0.edit.touch_move_pos.y - arg_30_0.edit.center_pos.y) * var_30_3 + arg_30_0.edit.center_pos.x
		local var_30_8 = (arg_30_0.edit.touch_move_pos.x - arg_30_0.edit.center_pos.x) * var_30_3 + (arg_30_0.edit.touch_move_pos.y - arg_30_0.edit.center_pos.y) * var_30_4 + arg_30_0.edit.center_pos.y
		local var_30_9 = var_30_7 - var_30_5
		local var_30_10 = var_30_8 - var_30_6
		local var_30_11 = math.atan(var_30_10 / var_30_9)
		local var_30_12 = math.deg(var_30_11)
		
		if var_30_12 < 0 then
			var_30_12 = 360 + var_30_12
		elseif var_30_12 > 360 then
			var_30_12 = var_30_12 - 360
		end
		
		local var_30_13 = arg_30_0.shape:getContentSize()
		local var_30_14 = var_30_13.width
		local var_30_15 = var_30_13.height
		local var_30_16 = 1
		local var_30_17 = math.abs(var_30_7 - arg_30_0.edit.center_pos.x)
		local var_30_18 = math.abs(var_30_8 - arg_30_0.edit.center_pos.y)
		
		if arg_30_5 == "left" then
			if var_30_14 <= arg_30_0.edit.min_size.w and var_30_15 <= arg_30_0.edit.min_size.h and var_30_7 > arg_30_0.edit.center_pos.x and var_30_8 < arg_30_0.edit.center_pos.y then
				arg_30_0:setContentSize(arg_30_0.edit.min_size.w, arg_30_0.edit.min_size.h)
				
				return 
			end
			
			if var_30_5 < var_30_7 and var_30_8 < var_30_6 and var_30_12 < 360 and var_30_12 > 270 then
				if var_30_18 <= var_30_17 then
					local var_30_19 = (var_30_18 * 2 - arg_30_0.edit.extra_size) / var_30_15
					local var_30_20 = round(var_30_19, 2)
					
					var_30_15 = var_30_20 * var_30_15
					var_30_14 = var_30_20 * var_30_14
				elseif var_30_17 < var_30_18 then
					local var_30_21 = (var_30_17 * 2 - arg_30_0.edit.extra_size) / var_30_14
					local var_30_22 = round(var_30_21, 2)
					
					var_30_15 = var_30_22 * var_30_15
					var_30_14 = var_30_22 * var_30_14
				end
			elseif var_30_17 <= var_30_18 then
				local var_30_23 = (var_30_18 * 2 - arg_30_0.edit.extra_size) / var_30_15
				local var_30_24 = round(var_30_23, 2)
				
				var_30_15 = var_30_24 * var_30_15
				var_30_14 = var_30_24 * var_30_14
			elseif var_30_18 < var_30_17 then
				local var_30_25 = (var_30_17 * 2 - arg_30_0.edit.extra_size) / var_30_14
				local var_30_26 = round(var_30_25, 2)
				
				var_30_15 = var_30_26 * var_30_15
				var_30_14 = var_30_26 * var_30_14
			end
		elseif arg_30_5 == "right" then
			if var_30_14 <= arg_30_0.edit.min_size.w and var_30_15 <= arg_30_0.edit.min_size.h and var_30_7 < arg_30_0.edit.center_pos.x and var_30_8 > arg_30_0.edit.center_pos.y then
				arg_30_0:setContentSize(arg_30_0.edit.min_size.w, arg_30_0.edit.min_size.h)
				
				return 
			end
			
			if var_30_7 < var_30_5 and var_30_6 < var_30_8 and var_30_12 < 360 and var_30_12 > 270 then
				if var_30_18 <= var_30_17 then
					local var_30_27 = (var_30_18 * 2 - arg_30_0.edit.extra_size) / var_30_15
					local var_30_28 = round(var_30_27, 2)
					
					var_30_15 = var_30_28 * var_30_15
					var_30_14 = var_30_28 * var_30_14
				elseif var_30_17 < var_30_18 then
					local var_30_29 = (var_30_17 * 2 - arg_30_0.edit.extra_size) / var_30_14
					local var_30_30 = round(var_30_29, 2)
					
					var_30_15 = var_30_30 * var_30_15
					var_30_14 = var_30_30 * var_30_14
				end
			elseif var_30_17 <= var_30_18 then
				local var_30_31 = (var_30_18 * 2 - arg_30_0.edit.extra_size) / var_30_15
				local var_30_32 = round(var_30_31, 2)
				
				var_30_15 = var_30_32 * var_30_15
				var_30_14 = var_30_32 * var_30_14
			elseif var_30_18 < var_30_17 then
				local var_30_33 = (var_30_17 * 2 - arg_30_0.edit.extra_size) / var_30_14
				local var_30_34 = round(var_30_33, 2)
				
				var_30_15 = var_30_34 * var_30_15
				var_30_14 = var_30_34 * var_30_14
			end
		end
		
		arg_30_0:setContentSize(var_30_14, var_30_15)
	else
		arg_30_0.edit.touch_corner_scale_btn_count = arg_30_0.edit.touch_corner_scale_btn_count - 1
		
		if arg_30_0.edit.touch_corner_scale_btn_count <= 0 then
			if not table.empty(arg_30_0.edit.origin_shape_size) and not table.empty(arg_30_0.vars.size) and (math.abs(arg_30_0.edit.origin_shape_size.width - arg_30_0.vars.size.w) >= 0.1 or math.abs(arg_30_0.edit.origin_shape_size.height - arg_30_0.vars.size.h) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_30_0,
					undo_func = bind_func(arg_30_0.setContentSize, arg_30_0, arg_30_0.edit.origin_shape_size.width, arg_30_0.edit.origin_shape_size.height),
					redo_func = bind_func(arg_30_0.setContentSize, arg_30_0, arg_30_0.vars.size.w, arg_30_0.vars.size.h)
				}, true)
			end
			
			arg_30_0.edit.touch_corner_scale_btn_count = 0
			arg_30_0.edit.is_corner_scale = false
			arg_30_0.edit.touch_begin_pos = nil
			arg_30_0.edit.center_pos = nil
			arg_30_0.edit.origin_shape_size = nil
			arg_30_0.edit.origin_shape_angle = nil
			arg_30_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.shape.shapeScaleXEventHandler(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.shape) or not get_cocos_refid(arg_31_1) or not arg_31_5 then
		return 
	end
	
	if not arg_31_0.edit or not get_cocos_refid(arg_31_0.edit.area_wnd) then
		return 
	end
	
	if arg_31_0.edit.is_move or arg_31_0.edit.is_rotate or arg_31_0.edit.is_corner_scale or arg_31_0.edit.is_scale_y then
		return 
	end
	
	if arg_31_2 == 0 then
		arg_31_0.edit.touch_scale_x_btn_count = arg_31_0.edit.touch_scale_x_btn_count + 1
		
		if arg_31_0.edit.touch_scale_x_btn_count == 1 then
			arg_31_0.edit.is_scale_x = true
			arg_31_0.edit.touch_begin_pos = arg_31_1:convertToWorldSpace({
				x = arg_31_1:getPositionX(),
				y = arg_31_1:getPositionY()
			})
			
			local var_31_0 = arg_31_0.shape:getContentSize()
			local var_31_1 = arg_31_0.shape:getAnchorPoint()
			local var_31_2 = {
				x = var_31_0.width * var_31_1.x,
				y = var_31_0.height * var_31_1.y
			}
			
			arg_31_0.edit.center_pos = arg_31_0.shape:convertToWorldSpace({
				x = var_31_2.x,
				y = var_31_2.y
			})
			arg_31_0.edit.origin_shape_size = var_31_0
			arg_31_0.edit.origin_shape_angle = arg_31_0.shape:getRotation()
		end
	elseif arg_31_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_31_0) then
			return 
		end
		
		if table.empty(arg_31_0.edit.touch_begin_pos) or table.empty(arg_31_0.edit.center_pos) or not arg_31_0.edit.origin_shape_angle or not arg_31_0.edit.is_scale_x or arg_31_0.edit.touch_scale_x_btn_count ~= 1 then
			return 
		end
		
		arg_31_0.edit.is_scale_x = true
		arg_31_0.edit.touch_move_pos = {
			x = arg_31_3,
			y = arg_31_4
		}
		
		local var_31_3 = math.sin(math.rad(arg_31_0.edit.origin_shape_angle))
		local var_31_4 = math.cos(math.rad(arg_31_0.edit.origin_shape_angle))
		local var_31_5 = (arg_31_0.edit.touch_move_pos.x - arg_31_0.edit.center_pos.x) * var_31_4 - (arg_31_0.edit.touch_move_pos.y - arg_31_0.edit.center_pos.y) * var_31_3 + arg_31_0.edit.center_pos.x
		local var_31_6 = arg_31_0.shape:getContentSize()
		local var_31_7 = var_31_6.width
		local var_31_8 = 1
		local var_31_9 = math.abs(var_31_5 - arg_31_0.edit.center_pos.x)
		
		if arg_31_5 == "left" then
			if var_31_5 > arg_31_0.edit.center_pos.x then
				arg_31_0:setContentSize(arg_31_0.edit.min_size.w, var_31_6.height)
				
				return 
			end
		elseif arg_31_5 == "right" and var_31_5 < arg_31_0.edit.center_pos.x then
			arg_31_0:setContentSize(arg_31_0.edit.min_size.w, var_31_6.height)
			
			return 
		end
		
		local var_31_10 = (var_31_9 * 2 - arg_31_0.edit.extra_size) / var_31_7
		local var_31_11 = round(var_31_10, 2) * var_31_7
		
		arg_31_0:setContentSize(var_31_11, var_31_6.height)
	else
		arg_31_0.edit.touch_scale_x_btn_count = arg_31_0.edit.touch_scale_x_btn_count - 1
		
		if arg_31_0.edit.touch_scale_x_btn_count <= 0 then
			if not table.empty(arg_31_0.edit.origin_shape_size) and not table.empty(arg_31_0.vars.size) and math.abs(arg_31_0.edit.origin_shape_size.width - arg_31_0.vars.size.w) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_31_0,
					undo_func = bind_func(arg_31_0.setContentSize, arg_31_0, arg_31_0.edit.origin_shape_size.width, arg_31_0.edit.origin_shape_size.height),
					redo_func = bind_func(arg_31_0.setContentSize, arg_31_0, arg_31_0.vars.size.w, arg_31_0.edit.origin_shape_size.height)
				}, true)
			end
			
			arg_31_0.edit.touch_scale_x_btn_count = 0
			arg_31_0.edit.is_scale_x = false
			arg_31_0.edit.touch_begin_pos = nil
			arg_31_0.edit.center_pos = nil
			arg_31_0.edit.origin_shape_size = nil
			arg_31_0.edit.origin_shape_angle = nil
			arg_31_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.shape.shapeScaleYEventHandler(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.shape) or not get_cocos_refid(arg_32_1) or not arg_32_5 then
		return 
	end
	
	if not arg_32_0.edit or not get_cocos_refid(arg_32_0.edit.area_wnd) then
		return 
	end
	
	if arg_32_0.edit.is_move or arg_32_0.edit.is_rotate or arg_32_0.edit.is_corner_scale or arg_32_0.edit.is_scale_x then
		return 
	end
	
	if arg_32_2 == 0 then
		arg_32_0.edit.touch_scale_y_btn_count = arg_32_0.edit.touch_scale_y_btn_count + 1
		
		if arg_32_0.edit.touch_scale_y_btn_count == 1 then
			arg_32_0.edit.is_scale_y = true
			arg_32_0.edit.touch_begin_pos = arg_32_1:convertToWorldSpace({
				x = arg_32_1:getPositionX(),
				y = arg_32_1:getPositionY()
			})
			
			local var_32_0 = arg_32_0.shape:getContentSize()
			local var_32_1 = arg_32_0.shape:getAnchorPoint()
			local var_32_2 = {
				x = var_32_0.width * var_32_1.x,
				y = var_32_0.height * var_32_1.y
			}
			
			arg_32_0.edit.center_pos = arg_32_0.shape:convertToWorldSpace({
				x = var_32_2.x,
				y = var_32_2.y
			})
			arg_32_0.edit.origin_shape_size = var_32_0
			arg_32_0.edit.origin_shape_angle = arg_32_0.shape:getRotation()
		end
	elseif arg_32_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_32_0) then
			return 
		end
		
		if table.empty(arg_32_0.edit.touch_begin_pos) or table.empty(arg_32_0.edit.center_pos) or not arg_32_0.edit.origin_shape_angle or not arg_32_0.edit.is_scale_y or arg_32_0.edit.touch_scale_y_btn_count ~= 1 then
			return 
		end
		
		arg_32_0.edit.is_scale_y = true
		arg_32_0.edit.touch_move_pos = {
			x = arg_32_3,
			y = arg_32_4
		}
		
		local var_32_3 = math.sin(math.rad(arg_32_0.edit.origin_shape_angle))
		local var_32_4 = math.cos(math.rad(arg_32_0.edit.origin_shape_angle))
		local var_32_5 = (arg_32_0.edit.touch_move_pos.x - arg_32_0.edit.center_pos.x) * var_32_3 + (arg_32_0.edit.touch_move_pos.y - arg_32_0.edit.center_pos.y) * var_32_4 + arg_32_0.edit.center_pos.y
		local var_32_6 = arg_32_0.shape:getContentSize()
		local var_32_7 = var_32_6.height
		local var_32_8 = 1
		local var_32_9 = math.abs(var_32_5 - arg_32_0.edit.center_pos.y)
		
		if arg_32_5 == "top" then
			if var_32_5 < arg_32_0.edit.center_pos.y then
				arg_32_0:setContentSize(var_32_6.width, arg_32_0.edit.min_size.h)
				
				return 
			end
		elseif arg_32_5 == "bottom" and var_32_5 > arg_32_0.edit.center_pos.y then
			arg_32_0:setContentSize(var_32_6.width, arg_32_0.edit.min_size.h)
			
			return 
		end
		
		local var_32_10 = (var_32_9 * 2 - arg_32_0.edit.extra_size) / var_32_7
		local var_32_11 = round(var_32_10, 2) * var_32_7
		
		arg_32_0:setContentSize(var_32_6.width, var_32_11)
	else
		arg_32_0.edit.touch_scale_y_btn_count = arg_32_0.edit.touch_scale_y_btn_count - 1
		
		if arg_32_0.edit.touch_scale_y_btn_count <= 0 then
			if not table.empty(arg_32_0.edit.origin_shape_size) and not table.empty(arg_32_0.vars.size) and math.abs(arg_32_0.edit.origin_shape_size.height - arg_32_0.vars.size.h) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_32_0,
					undo_func = bind_func(arg_32_0.setContentSize, arg_32_0, arg_32_0.edit.origin_shape_size.width, arg_32_0.edit.origin_shape_size.height),
					redo_func = bind_func(arg_32_0.setContentSize, arg_32_0, arg_32_0.edit.origin_shape_size.width, arg_32_0.vars.size.h)
				}, true)
			end
			
			arg_32_0.edit.touch_scale_y_btn_count = 0
			arg_32_0.edit.is_scale_y = false
			arg_32_0.edit.touch_begin_pos = nil
			arg_32_0.edit.center_pos = nil
			arg_32_0.edit.origin_shape_size = nil
			arg_32_0.edit.origin_shape_angle = nil
			arg_32_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.shape.shapeRotateEventHandler(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.shape) or not get_cocos_refid(arg_33_1) then
		return 
	end
	
	if not arg_33_0.edit or not get_cocos_refid(arg_33_0.edit.area_wnd) then
		return 
	end
	
	if arg_33_0.edit.is_move or arg_33_0.edit.is_corner_scale or arg_33_0.edit.is_scale_x or arg_33_0.edit.is_scale_y then
		return 
	end
	
	if arg_33_2 == 0 then
		arg_33_0.edit.touch_rotate_btn_count = arg_33_0.edit.touch_rotate_btn_count + 1
		
		if arg_33_0.edit.touch_rotate_btn_count == 1 then
			arg_33_0.edit.is_rotate = true
			arg_33_0.edit.touch_begin_pos = {
				x = arg_33_3,
				y = arg_33_4
			}
			
			local var_33_0 = arg_33_0.shape:getScaleX()
			local var_33_1 = arg_33_0.shape:getScaleY()
			local var_33_2 = arg_33_0.shape:getContentSize()
			local var_33_3 = arg_33_0.shape:getAnchorPoint()
			local var_33_4 = {
				x = var_33_0 * var_33_2.width * var_33_3.x,
				y = var_33_1 * var_33_2.height * var_33_3.y
			}
			
			arg_33_0.edit.center_pos = arg_33_0.shape:convertToWorldSpace({
				x = var_33_4.x,
				y = var_33_4.y
			})
			arg_33_0.edit.origin_shape_angle = arg_33_0.shape:getRotation()
		end
	elseif arg_33_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_33_0) then
			return 
		end
		
		if table.empty(arg_33_0.edit.touch_begin_pos) or table.empty(arg_33_0.edit.center_pos) or not arg_33_0.edit.is_rotate or arg_33_0.edit.touch_rotate_btn_count ~= 1 then
			return 
		end
		
		arg_33_0.edit.is_rotate = true
		arg_33_0.edit.touch_move_pos = {
			x = arg_33_3,
			y = arg_33_4
		}
		
		local var_33_5 = math.deg(math.atan2(arg_33_0.edit.touch_begin_pos.y - arg_33_0.edit.center_pos.y, arg_33_0.edit.touch_begin_pos.x - arg_33_0.edit.center_pos.x) - math.atan2(arg_33_0.edit.touch_move_pos.y - arg_33_0.edit.center_pos.y, arg_33_0.edit.touch_move_pos.x - arg_33_0.edit.center_pos.x))
		
		arg_33_0:setRotation(var_33_5 + arg_33_0.edit.origin_shape_angle)
	else
		arg_33_0.edit.touch_rotate_btn_count = arg_33_0.edit.touch_rotate_btn_count - 1
		
		if arg_33_0.edit.touch_rotate_btn_count <= 0 then
			if arg_33_0.edit.origin_shape_angle and arg_33_0.vars.rotation and math.abs(arg_33_0.edit.origin_shape_angle - arg_33_0.vars.rotation) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_33_0,
					undo_func = bind_func(arg_33_0.setRotation, arg_33_0, arg_33_0.edit.origin_shape_angle),
					redo_func = bind_func(arg_33_0.setRotation, arg_33_0, arg_33_0.vars.rotation)
				}, true)
			end
			
			arg_33_0.edit.touch_rotate_btn_count = 0
			arg_33_0.edit.is_rotate = false
			arg_33_0.edit.touch_begin_pos = nil
			arg_33_0.edit.center_pos = nil
			arg_33_0.edit.origin_shape_angle = nil
			arg_33_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.shape.shapeRemoveEventHandler(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_0.parent or not arg_34_0.vars or not get_cocos_refid(arg_34_0.layer_wnd) or not get_cocos_refid(arg_34_1) then
		return 
	end
	
	if not arg_34_0.edit or not get_cocos_refid(arg_34_0.edit.area_wnd) then
		return 
	end
	
	if arg_34_2 == 2 or arg_34_2 == 3 then
		arg_34_0.parent:deleteLayer({
			order = arg_34_0.vars.order,
			type = arg_34_0.vars.type
		})
	end
end

function CustomProfileCard.shape.setPosition(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0.vars or not arg_35_0.vars.pos or not get_cocos_refid(arg_35_0.shape) then
		return 
	end
	
	arg_35_0.vars.pos.x = arg_35_1
	arg_35_0.vars.pos.y = arg_35_2
	
	arg_35_0.shape:setPosition(arg_35_1, arg_35_2)
	arg_35_0:renderEditorBox()
end

function CustomProfileCard.shape.setContentSize(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_0.vars or not arg_36_0.vars.size or not get_cocos_refid(arg_36_0.shape) then
		return 
	end
	
	if arg_36_1 <= arg_36_0.edit.min_size.w then
		arg_36_1 = arg_36_0.edit.min_size.w
	end
	
	if arg_36_2 <= arg_36_0.edit.min_size.h then
		arg_36_2 = arg_36_0.edit.min_size.h
	end
	
	arg_36_0.vars.size.w = arg_36_1
	arg_36_0.vars.size.h = arg_36_2
	
	arg_36_0.shape:setContentSize(arg_36_1, arg_36_2)
	arg_36_0:renderEditorBox()
end

function CustomProfileCard.shape.setRotation(arg_37_0, arg_37_1)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.shape) then
		return 
	end
	
	arg_37_0.vars.rotation = arg_37_1
	
	arg_37_0.shape:setRotation(arg_37_1)
	arg_37_0:renderEditorBox()
end

function CustomProfileCard.shape.setColor(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.shape) then
		return 
	end
	
	if table.empty(arg_38_1) then
		return 
	end
	
	if arg_38_0.vars.color == arg_38_1 then
		return 
	end
	
	if not arg_38_2 then
		local var_38_0 = arg_38_0.vars.color
		local var_38_1 = arg_38_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_38_0,
			undo_func = bind_func(arg_38_0.setColor, arg_38_0, var_38_0, true),
			redo_func = bind_func(arg_38_0.setColor, arg_38_0, var_38_1, true)
		}, true)
	end
	
	arg_38_0.vars.color = arg_38_1
	
	arg_38_0.shape:setColor(cc.c3b(arg_38_1.r, arg_38_1.g, arg_38_1.b))
end

function CustomProfileCard.shape.setOpacityRate(arg_39_0, arg_39_1)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.shape) then
		return 
	end
	
	arg_39_0.vars.opacity_rate = arg_39_1
	
	arg_39_0.shape:setOpacity(round(2.55 * arg_39_1))
end

function CustomProfileCard.shape.setVisible(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.shape) then
		return 
	end
	
	if arg_40_0.vars.is_visible == arg_40_1 then
		return 
	end
	
	if not arg_40_2 then
		local var_40_0 = arg_40_0.vars.is_visible
		local var_40_1 = arg_40_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_40_0,
			undo_func = bind_func(arg_40_0.setVisible, arg_40_0, var_40_0, true),
			redo_func = bind_func(arg_40_0.setVisible, arg_40_0, var_40_1, true)
		}, true)
	end
	
	arg_40_0.vars.is_visible = arg_40_1
	
	arg_40_0.shape:setVisible(arg_40_1)
end

function CustomProfileCard.shape.setLock(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_0.vars or not arg_41_0.edit or not get_cocos_refid(arg_41_0.edit.btn_select_move) then
		return 
	end
	
	if arg_41_0.vars.is_lock == arg_41_1 then
		return 
	end
	
	if not arg_41_2 then
		local var_41_0 = arg_41_0.vars.is_lock
		local var_41_1 = arg_41_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_41_0,
			undo_func = bind_func(arg_41_0.setLock, arg_41_0, var_41_0, true),
			redo_func = bind_func(arg_41_0.setLock, arg_41_0, var_41_1, true)
		}, true)
	end
	
	arg_41_0.vars.is_lock = arg_41_1
	
	arg_41_0.edit.btn_select_move:setVisible(not arg_41_1)
end
