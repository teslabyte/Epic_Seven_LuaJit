CustomProfileCard.badge = {}

function CustomProfileCard.badge.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.parent = arg_1_1.parent
	
	local var_1_0 = load_control("wnd/profile_custom_item.csb")
	
	arg_1_0.badge = var_1_0:getChildByName("n_unit")
	
	local var_1_1 = arg_1_0.parent:getWnd()
	
	if arg_1_0.parent and get_cocos_refid(var_1_1) then
		local var_1_2 = arg_1_1.type or arg_1_0.parent:convertNumberToType(arg_1_1.load_data[1])
		
		arg_1_0.layer_wnd = CustomProfileCard:createParentLayerNode(var_1_2)
		
		if get_cocos_refid(arg_1_0.layer_wnd) then
			var_1_0:setAnchorPoint(0.5, 0.5)
			var_1_0:setPosition(0, 0)
			arg_1_0.layer_wnd:addChild(var_1_0)
			
			local var_1_3 = var_1_1:getChildByName("n_edit_on")
			
			if get_cocos_refid(var_1_3) then
				var_1_3:addChild(arg_1_0.layer_wnd)
			end
		end
	end
	
	arg_1_0:load(arg_1_1)
	arg_1_0:createBadge(arg_1_1)
end

function CustomProfileCard.badge.delete(arg_2_0)
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

function CustomProfileCard.badge.load(arg_3_0, arg_3_1)
	if table.empty(arg_3_1.load_data) then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.order = arg_3_1.order
	arg_3_0.vars.type = arg_3_0.parent:convertNumberToType(arg_3_1.load_data[1]) or "badge"
	arg_3_0.vars.id = arg_3_1.load_data[2]
	arg_3_0.vars.pos = table.copyElement(arg_3_1.load_data[3], {
		"x",
		"y"
	})
	arg_3_0.vars.is_visible = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[4])
	arg_3_0.vars.is_lock = arg_3_0.parent:convertNumberToBoolen(arg_3_1.load_data[5])
end

function CustomProfileCard.badge.save(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.badge) then
		return nil
	end
	
	local var_4_0 = {
		arg_4_0.parent:convertTypeToNumber(arg_4_0.vars.type),
		arg_4_0.vars.id,
		(table.copyElement(arg_4_0.vars.pos, {
			"x",
			"y"
		}))
	}
	
	var_4_0[3].x = math.floor(var_4_0[3].x * 10) / 10
	var_4_0[3].y = math.floor(var_4_0[3].y * 10) / 10
	var_4_0[4] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_visible)
	var_4_0[5] = arg_4_0.parent:convertBoolenToNumber(arg_4_0.vars.is_lock)
	
	return var_4_0
end

function CustomProfileCard.badge.initDB(arg_5_0, arg_5_1)
	if arg_5_0.vars or not get_cocos_refid(arg_5_0.badge) then
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.order = arg_5_1.order
	arg_5_0.vars.type = arg_5_1.type or "badge"
	arg_5_0.vars.id = arg_5_1.id
	arg_5_0.vars.pos = {}
	arg_5_0.vars.pos.x = math.floor(arg_5_0.badge:getPositionX() * 10) / 10
	arg_5_0.vars.pos.y = math.floor(arg_5_0.badge:getPositionY() * 10) / 10
	arg_5_0.vars.is_visible = arg_5_0.badge:isVisible()
	arg_5_0.vars.is_lock = false
end

function CustomProfileCard.badge.createBadge(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}
	
	local var_6_0 = arg_6_1.id or arg_6_1.load_data[2]
	
	if var_6_0 then
		local var_6_1 = DB("item_material_profile", var_6_0, {
			"material_id"
		})
		local var_6_2 = DBT("item_material", var_6_1, {
			"ma_type",
			"ma_type2",
			"icon"
		})
		
		if table.empty(var_6_2) then
			return 
		end
		
		local var_6_3 = var_6_2.ma_type .. "/" .. var_6_2.ma_type2 .. "/" .. var_6_2.icon
		
		if_set_sprite(arg_6_0.badge, nil, var_6_3 .. ".png")
		arg_6_0:initDB(arg_6_1)
		arg_6_0.badge:setPosition(arg_6_0.vars.pos.x, arg_6_0.vars.pos.y)
		arg_6_0.badge:setVisible(arg_6_0.vars.is_visible)
		arg_6_0.layer_wnd:setLocalZOrder(arg_6_0.vars.order)
		
		if arg_6_1.is_edit_mode then
			arg_6_0:createEditBox()
		end
	end
end

function CustomProfileCard.badge.setOrder(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_0.vars.order = arg_7_1
	
	if get_cocos_refid(arg_7_0.layer_wnd) then
		arg_7_0.layer_wnd:setLocalZOrder(arg_7_0.vars.order)
	end
	
	if arg_7_0.edit and get_cocos_refid(arg_7_0.edit.area_wnd) and get_cocos_refid(arg_7_0.edit.btn_select_move) then
		arg_7_0.edit.area_wnd:setLocalZOrder(arg_7_0.vars.order)
		arg_7_0.edit.btn_select_move:setLocalZOrder(arg_7_0.vars.order)
	end
end

function CustomProfileCard.badge.getOrder(arg_8_0)
	if not arg_8_0.vars then
		return nil
	end
	
	return arg_8_0.vars.order
end

function CustomProfileCard.badge.getType(arg_9_0)
	if not arg_9_0.vars then
		return nil
	end
	
	return arg_9_0.vars.type or "badge"
end

function CustomProfileCard.badge.getId(arg_10_0)
	if not arg_10_0.vars then
		return nil
	end
	
	return arg_10_0.vars.id
end

function CustomProfileCard.badge.isVisible(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.badge) then
		return false
	end
	
	return arg_11_0.vars.is_visible or arg_11_0.badge:isVisible()
end

function CustomProfileCard.badge.isLock(arg_12_0)
	if not arg_12_0.vars then
		return false
	end
	
	return arg_12_0.vars.is_lock
end

function CustomProfileCard.badge.createEditBox(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.badge) then
		return 
	end
	
	local var_13_0 = arg_13_0.badge:getContentSize()
	local var_13_1 = var_13_0.width
	local var_13_2 = var_13_0.height
	
	arg_13_0.edit = {}
	
	local var_13_3 = arg_13_0.parent:getWnd()
	local var_13_4 = var_13_3:getChildByName("n_edit_boxes")
	
	arg_13_0.edit.area_wnd = cc.DrawNode:create(1)
	
	arg_13_0.edit.area_wnd:setName("n_edit_area")
	arg_13_0.edit.area_wnd:setAnchorPoint(0.5, 0.5)
	arg_13_0.edit.area_wnd:setPosition(var_13_1 * 0.5, var_13_2 * 0.5)
	arg_13_0.edit.area_wnd:setContentSize(var_13_1, var_13_2)
	arg_13_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_13_1, var_13_2), cc.c4f(1, 1, 1, 1))
	arg_13_0.edit.area_wnd:setTransformParent(arg_13_0.badge)
	arg_13_0.edit.area_wnd:setLocalZOrder(arg_13_0.vars.order)
	var_13_4:addChild(arg_13_0.edit.area_wnd)
	
	local var_13_5 = var_13_3:getChildByName("n_select_boxes")
	
	arg_13_0.edit.btn_select_move = ccui.Button:create()
	
	arg_13_0.edit.btn_select_move:setName("btn_select_move")
	arg_13_0.edit.btn_select_move:setAnchorPoint(0.5, 0.5)
	arg_13_0.edit.btn_select_move:setTouchEnabled(true)
	arg_13_0.edit.btn_select_move:ignoreContentAdaptWithSize(false)
	arg_13_0.edit.btn_select_move:setPosition(var_13_1 * 0.5, var_13_2 * 0.5)
	arg_13_0.edit.btn_select_move:setContentSize(var_13_1, var_13_2)
	arg_13_0.edit.btn_select_move:setTransformParent(arg_13_0.edit.area_wnd)
	arg_13_0.edit.btn_select_move:setLocalZOrder(arg_13_0.vars.order)
	arg_13_0.edit.btn_select_move:setVisible(not arg_13_0.vars.is_lock)
	var_13_5:addChild(arg_13_0.edit.btn_select_move)
	
	local var_13_6 = load_control("wnd/custom_edit_control.csb")
	
	var_13_6:setName("n_corner_btns")
	arg_13_0.edit.area_wnd:addChild(var_13_6)
	if_set_visible(var_13_6, "n_crop", false)
	if_set_visible(var_13_6, "n_side", false)
	if_set_visible(var_13_6, "n_fixed", true)
	if_set_visible(var_13_6, "n_multi", false)
	
	local var_13_7 = var_13_6:getChildByName("n_fixed")
	
	if_set_visible(var_13_7, "n_move", true)
	if_set_visible(var_13_7, "n_off", true)
	
	arg_13_0.edit.btn_move_left_top = var_13_7:getChildByName("n_move")
	
	if get_cocos_refid(arg_13_0.edit.btn_move_left_top) then
		arg_13_0.edit.btn_move_left_top:setPosition(0, var_13_2)
	end
	
	arg_13_0.edit.btn_move_left_bottom = arg_13_0.edit.btn_move_left_top:clone()
	
	var_13_7:addChild(arg_13_0.edit.btn_move_left_bottom)
	
	if get_cocos_refid(arg_13_0.edit.btn_move_left_bottom) then
		arg_13_0.edit.btn_move_left_bottom:setPosition(0, 0)
	end
	
	arg_13_0.edit.btn_move_right_bottom = arg_13_0.edit.btn_move_left_top:clone()
	
	var_13_7:addChild(arg_13_0.edit.btn_move_right_bottom)
	
	if get_cocos_refid(arg_13_0.edit.btn_move_right_bottom) then
		arg_13_0.edit.btn_move_right_bottom:setPosition(var_13_1, 0)
	end
	
	arg_13_0.edit.btn_delete = var_13_7:getChildByName("n_off")
	
	if get_cocos_refid(arg_13_0.edit.btn_delete) then
		arg_13_0.edit.btn_delete:setPosition(var_13_1, var_13_2)
	end
	
	arg_13_0:activeEditorBox(false)
	arg_13_0:addTouchEventListener()
end

function CustomProfileCard.badge.activeEditorBox(arg_14_0, arg_14_1)
	if not arg_14_0.edit or not get_cocos_refid(arg_14_0.edit.area_wnd) then
		return 
	end
	
	arg_14_0.edit.area_wnd:setVisible(arg_14_1)
end

function CustomProfileCard.badge.renderEditorBox(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.badge) then
		return 
	end
	
	if not arg_15_0.edit or not get_cocos_refid(arg_15_0.edit.area_wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.badge:getContentSize()
	local var_15_1 = var_15_0.width
	local var_15_2 = var_15_0.height
	
	arg_15_0.edit.area_wnd:clear()
	arg_15_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_15_1, var_15_2), cc.c4f(1, 1, 1, 1))
	arg_15_0.edit.area_wnd:visit()
end

function CustomProfileCard.badge.addTouchEventListener(arg_16_0)
	if not arg_16_0.edit or not get_cocos_refid(arg_16_0.edit.area_wnd) then
		return 
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_select_move) then
		arg_16_0.edit.btn_select_move:addTouchEventListener(function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			arg_16_0:badgeMoveEventHandler(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		end)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_move_left_top) then
		arg_16_0.edit.btn_move_left_top:getChildByName("btn"):addTouchEventListener(function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			arg_16_0:badgeMoveEventHandler(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		end)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_move_left_bottom) then
		arg_16_0.edit.btn_move_left_bottom:getChildByName("btn"):addTouchEventListener(function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			arg_16_0:badgeMoveEventHandler(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		end)
	end
	
	if get_cocos_refid(arg_16_0.edit.btn_move_right_bottom) then
		arg_16_0.edit.btn_move_right_bottom:getChildByName("btn"):addTouchEventListener(function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
			arg_16_0:badgeMoveEventHandler(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		end)
	end
	
	arg_16_0.edit.touch_move_btn_count = 0
	
	if get_cocos_refid(arg_16_0.edit.btn_delete) then
		arg_16_0.edit.btn_delete:getChildByName("btn"):addTouchEventListener(function(arg_21_0, arg_21_1)
			arg_16_0:badgeRemoveEventHandler(arg_21_0, arg_21_1)
		end)
	end
end

function CustomProfileCard.badge.badgeMoveEventHandler(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.badge) or not get_cocos_refid(arg_22_1) then
		return 
	end
	
	if not arg_22_0.edit or not get_cocos_refid(arg_22_0.edit.area_wnd) then
		return 
	end
	
	if arg_22_0.vars.is_lock then
		return 
	end
	
	if arg_22_2 == 0 then
		arg_22_0.edit.touch_move_btn_count = arg_22_0.edit.touch_move_btn_count + 1
		
		if arg_22_0.edit.touch_move_btn_count == 1 then
			if not CustomProfileCardEditor:isFocusLayer(arg_22_0) and arg_22_1:getName() == "btn_select_move" then
				CustomProfileCardEditor:setFocusLayer(arg_22_0)
			end
			
			arg_22_0.edit.touch_begin_pos = {
				x = arg_22_3,
				y = arg_22_4
			}
			arg_22_0.edit.origin_badge_pos = {
				x = arg_22_0.badge:getPositionX(),
				y = arg_22_0.badge:getPositionY()
			}
		end
	elseif arg_22_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_22_0) then
			return 
		end
		
		if table.empty(arg_22_0.edit.touch_begin_pos) or table.empty(arg_22_0.edit.origin_badge_pos) or arg_22_0.edit.touch_move_btn_count ~= 1 then
			return 
		end
		
		arg_22_0.edit.touch_move_pos = {
			x = arg_22_3,
			y = arg_22_4
		}
		
		local var_22_0 = arg_22_0.edit.touch_move_pos.x - arg_22_0.edit.touch_begin_pos.x
		local var_22_1 = arg_22_0.edit.touch_move_pos.y - arg_22_0.edit.touch_begin_pos.y
		
		arg_22_0:setPosition(arg_22_0.edit.origin_badge_pos.x + var_22_0, arg_22_0.edit.origin_badge_pos.y + var_22_1)
	else
		arg_22_0.edit.touch_move_btn_count = arg_22_0.edit.touch_move_btn_count - 1
		
		if arg_22_0.edit.touch_move_btn_count <= 0 then
			if not table.empty(arg_22_0.edit.origin_badge_pos) and not table.empty(arg_22_0.vars.pos) and (math.abs(arg_22_0.edit.origin_badge_pos.x - arg_22_0.vars.pos.x) >= 0.1 or math.abs(arg_22_0.edit.origin_badge_pos.y - arg_22_0.vars.pos.y) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_22_0,
					undo_func = bind_func(arg_22_0.setPosition, arg_22_0, arg_22_0.edit.origin_badge_pos.x, arg_22_0.edit.origin_badge_pos.y),
					redo_func = bind_func(arg_22_0.setPosition, arg_22_0, arg_22_0.vars.pos.x, arg_22_0.vars.pos.y)
				}, true)
			end
			
			arg_22_0.edit.touch_move_btn_count = 0
			arg_22_0.edit.touch_begin_pos = nil
			arg_22_0.edit.origin_badge_pos = nil
			arg_22_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.badge.badgeRemoveEventHandler(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.parent or not arg_23_0.vars or not get_cocos_refid(arg_23_0.layer_wnd) or not get_cocos_refid(arg_23_1) then
		return 
	end
	
	if not arg_23_0.edit or not get_cocos_refid(arg_23_0.edit.area_wnd) then
		return 
	end
	
	if arg_23_2 == 2 or arg_23_2 == 3 then
		arg_23_0.parent:deleteLayer({
			order = arg_23_0.vars.order,
			type = arg_23_0.vars.type
		})
	end
end

function CustomProfileCard.badge.setPosition(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars or table.empty(arg_24_0.vars.pos) or not get_cocos_refid(arg_24_0.badge) then
		return 
	end
	
	arg_24_0.vars.pos.x = arg_24_1
	arg_24_0.vars.pos.y = arg_24_2
	
	arg_24_0.badge:setPosition(arg_24_1, arg_24_2)
	arg_24_0:renderEditorBox()
end

function CustomProfileCard.badge.setVisible(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.badge) then
		return 
	end
	
	if arg_25_0.vars.is_visible == arg_25_1 then
		return 
	end
	
	if not arg_25_2 then
		local var_25_0 = arg_25_0.vars.is_visible
		local var_25_1 = arg_25_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_25_0,
			undo_func = bind_func(arg_25_0.setVisible, arg_25_0, var_25_0, true),
			redo_func = bind_func(arg_25_0.setVisible, arg_25_0, var_25_1, true)
		}, true)
	end
	
	arg_25_0.vars.is_visible = arg_25_1
	
	arg_25_0.badge:setVisible(arg_25_1)
end

function CustomProfileCard.badge.setLock(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0.vars or not arg_26_0.edit or not get_cocos_refid(arg_26_0.edit.btn_select_move) then
		return 
	end
	
	if arg_26_0.vars.is_lock == arg_26_1 then
		return 
	end
	
	if not arg_26_2 then
		local var_26_0 = arg_26_0.vars.is_lock
		local var_26_1 = arg_26_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_26_0,
			undo_func = bind_func(arg_26_0.setLock, arg_26_0, var_26_0, true),
			redo_func = bind_func(arg_26_0.setLock, arg_26_0, var_26_1, true)
		}, true)
	end
	
	arg_26_0.vars.is_lock = arg_26_1
	
	arg_26_0.edit.btn_select_move:setVisible(not arg_26_1)
end
