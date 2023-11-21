CustomProfileCard.text = {}

function CustomProfileCard.text.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.parent = arg_1_1.parent
	
	arg_1_0:load(arg_1_1)
	arg_1_0:createText(arg_1_1)
end

function CustomProfileCard.text.delete(arg_2_0)
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

function CustomProfileCard.text.clone(arg_3_0)
	if not arg_3_0.parent or not arg_3_0.vars or not get_cocos_refid(arg_3_0.text) then
		return 
	end
	
	local var_3_0 = arg_3_0:save()
	
	if not table.empty(var_3_0) and not table.empty(var_3_0[2]) then
		var_3_0[2].x = var_3_0[2].x + 5
		var_3_0[2].y = var_3_0[2].y - 5
	end
	
	return var_3_0
end

function CustomProfileCard.text.load(arg_4_0, arg_4_1)
	if table.empty(arg_4_1.load_data) then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.order = arg_4_1.order
	arg_4_0.vars.type = arg_4_0.parent:convertNumberToType(arg_4_1.load_data[1]) or "text"
	arg_4_0.vars.pos = table.copyElement(arg_4_1.load_data[2], {
		"x",
		"y"
	})
	arg_4_0.vars.rotation = arg_4_1.load_data[3] or 0
	arg_4_0.vars.opacity_rate = arg_4_1.load_data[4] or 100
	arg_4_0.vars.text = Base64.decode(arg_4_1.load_data[5])
	arg_4_0.vars.font_size = arg_4_1.load_data[6]
	arg_4_0.vars.color = table.copyElement(arg_4_1.load_data[7], {
		"r",
		"g",
		"b"
	})
	arg_4_0.vars.is_bold = arg_4_0.parent:convertNumberToBoolen(arg_4_1.load_data[8])
	arg_4_0.vars.is_visible = arg_4_0.parent:convertNumberToBoolen(arg_4_1.load_data[9])
	arg_4_0.vars.is_lock = arg_4_0.parent:convertNumberToBoolen(arg_4_1.load_data[10])
end

function CustomProfileCard.text.save(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.text) then
		return nil
	end
	
	local var_5_0 = {
		arg_5_0.parent:convertTypeToNumber(arg_5_0.vars.type),
		(table.copyElement(arg_5_0.vars.pos, {
			"x",
			"y"
		}))
	}
	
	var_5_0[2].x = math.floor(var_5_0[2].x * 10) / 10
	var_5_0[2].y = math.floor(var_5_0[2].y * 10) / 10
	var_5_0[3] = math.floor(arg_5_0.vars.rotation * 10) / 10
	var_5_0[4] = arg_5_0.vars.opacity_rate
	var_5_0[5] = Base64.encode(arg_5_0.vars.text)
	var_5_0[6] = arg_5_0.vars.font_size
	var_5_0[7] = table.copyElement(arg_5_0.vars.color, {
		"r",
		"g",
		"b"
	})
	var_5_0[8] = arg_5_0.parent:convertBoolenToNumber(arg_5_0.vars.is_bold)
	var_5_0[9] = arg_5_0.parent:convertBoolenToNumber(arg_5_0.vars.is_visible)
	var_5_0[10] = arg_5_0.parent:convertBoolenToNumber(arg_5_0.vars.is_lock)
	
	return var_5_0
end

function CustomProfileCard.text.initDB(arg_6_0, arg_6_1)
	if arg_6_0.vars or not get_cocos_refid(arg_6_0.text) then
		return 
	end
	
	arg_6_0.vars = {}
	arg_6_0.vars.order = arg_6_1.order
	arg_6_0.vars.type = arg_6_1.type or "text"
	arg_6_0.vars.pos = {}
	arg_6_0.vars.pos.x = math.floor(arg_6_0.text:getPositionX() * 10) / 10
	arg_6_0.vars.pos.y = math.floor(arg_6_0.text:getPositionY() * 10) / 10
	arg_6_0.vars.rotation = math.floor(arg_6_0.text:getRotation() * 10) / 10
	arg_6_0.vars.opacity_rate = round(arg_6_0.text:getOpacity() / 2.55)
	arg_6_0.vars.text = arg_6_0.text:getString()
	arg_6_0.vars.font_size = arg_6_0.text:getFontSize()
	arg_6_0.vars.color = arg_6_0.text:getTextColor()
	arg_6_0.vars.is_bold = arg_6_1.is_bold or false
	arg_6_0.vars.is_visible = arg_6_0.text:isVisible()
	arg_6_0.vars.is_lock = false
end

function CustomProfileCard.text.createText(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or {}
	
	local var_7_0 = arg_7_1.type or arg_7_0.parent:convertNumberToType(arg_7_1.load_data[1])
	
	arg_7_0.layer_wnd = CustomProfileCard:createParentLayerNode(var_7_0)
	arg_7_0.text = ccui.Text:create()
	
	arg_7_0.text:setName("n_text")
	arg_7_0.text:setFontName("font/daum.ttf")
	arg_7_0.text:setAnchorPoint(0.5, 0.5)
	arg_7_0.text:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	arg_7_0.text:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	arg_7_0.text:setString(arg_7_1.text)
	arg_7_0.text:setOpacity(round(2.55 * (arg_7_1.text_opacity_rate or 100)))
	arg_7_0.text:setFontSize(arg_7_1.font_size or 50)
	arg_7_0.text:setTextColor(arg_7_1.text_color or cc.c3b(88, 106, 139))
	arg_7_0:initDB(arg_7_1)
	arg_7_0.layer_wnd:addChild(arg_7_0.text)
	arg_7_0.layer_wnd:setLocalZOrder(arg_7_0.vars.order)
	
	local var_7_1 = arg_7_0.parent:getWnd():getChildByName("n_edit_on")
	
	if get_cocos_refid(var_7_1) then
		var_7_1:addChild(arg_7_0.layer_wnd)
	end
	
	arg_7_0.text:setPosition(arg_7_0.vars.pos.x, arg_7_0.vars.pos.y)
	arg_7_0.text:setRotation(arg_7_0.vars.rotation)
	arg_7_0.text:setOpacity(round(2.55 * arg_7_0.vars.opacity_rate))
	arg_7_0.text:setString(arg_7_0.vars.text)
	arg_7_0.text:setFontSize(arg_7_0.vars.font_size)
	arg_7_0.text:setTextColor(arg_7_0.vars.color)
	arg_7_0.text:setVisible(arg_7_0.vars.is_visible)
	
	if arg_7_0.vars.is_bold then
		local var_7_2 = arg_7_0.text:getTextColor()
		
		arg_7_0.text:enableOutline(var_7_2, 1)
	end
	
	if arg_7_1.is_edit_mode then
		arg_7_0:createEditBox()
	end
end

function CustomProfileCard.text.setOrder(arg_8_0, arg_8_1)
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

function CustomProfileCard.text.getOrder(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.text) then
		return nil
	end
	
	return arg_9_0.vars.order
end

function CustomProfileCard.text.getType(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.text) then
		return nil
	end
	
	return arg_10_0.vars.type or "text"
end

function CustomProfileCard.text.getText(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.text) then
		return nil
	end
	
	return arg_11_0.vars.text or arg_11_0.text:getString()
end

function CustomProfileCard.text.getFontSize(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.text) then
		return nil
	end
	
	return arg_12_0.vars.font_size or arg_12_0.text:getFontSize()
end

function CustomProfileCard.text.getOpacityRate(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.text) then
		return nil
	end
	
	return arg_13_0.vars.opacity_rate or round(arg_13_0.text:getOpacity() / 2.55)
end

function CustomProfileCard.text.getFontColor(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.text) then
		return nil
	end
	
	return arg_14_0.vars.color or arg_14_0.text:getTextColor()
end

function CustomProfileCard.text.isBlod(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.text) then
		return nil
	end
	
	return arg_15_0.vars.is_bold
end

function CustomProfileCard.text.isVisible(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.text) then
		return false
	end
	
	return arg_16_0.vars.is_visible or arg_16_0.text:isVisible()
end

function CustomProfileCard.text.isLock(arg_17_0)
	if not arg_17_0.vars then
		return false
	end
	
	return arg_17_0.vars.is_lock
end

function CustomProfileCard.text.createEditBox(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.text) then
		return 
	end
	
	arg_18_0.edit = {}
	arg_18_0.edit.font_size_limit = {
		min = ProfileCardConfigData.min_text_size,
		max = ProfileCardConfigData.max_text_size
	}
	arg_18_0.edit.extra_size = 20
	
	local var_18_0 = arg_18_0.text:getContentSize()
	local var_18_1 = var_18_0.width + arg_18_0.edit.extra_size
	local var_18_2 = var_18_0.height + arg_18_0.edit.extra_size
	local var_18_3 = -(arg_18_0.edit.extra_size / 2)
	local var_18_4 = -(arg_18_0.edit.extra_size / 2)
	local var_18_5 = arg_18_0.parent:getWnd()
	local var_18_6 = var_18_5:getChildByName("n_edit_boxes")
	
	arg_18_0.edit.area_wnd = cc.DrawNode:create(1)
	
	arg_18_0.edit.area_wnd:setName("n_edit_area")
	arg_18_0.edit.area_wnd:setAnchorPoint(0.5, 0.5)
	arg_18_0.edit.area_wnd:setPosition(var_18_1 * 0.5 + var_18_3, var_18_2 * 0.5 + var_18_4)
	arg_18_0.edit.area_wnd:setContentSize(var_18_1, var_18_2)
	arg_18_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_18_1, var_18_2), cc.c4f(1, 1, 1, 1))
	arg_18_0.edit.area_wnd:setTransformParent(arg_18_0.text)
	arg_18_0.edit.area_wnd:setLocalZOrder(arg_18_0.vars.order)
	var_18_6:addChild(arg_18_0.edit.area_wnd)
	
	local var_18_7 = var_18_5:getChildByName("n_select_boxes")
	
	arg_18_0.edit.btn_select_move = ccui.Button:create()
	
	arg_18_0.edit.btn_select_move:setName("btn_select_move")
	arg_18_0.edit.btn_select_move:setAnchorPoint(0.5, 0.5)
	arg_18_0.edit.btn_select_move:setTouchEnabled(true)
	arg_18_0.edit.btn_select_move:ignoreContentAdaptWithSize(false)
	arg_18_0.edit.btn_select_move:setPosition(var_18_1 * 0.5, var_18_2 * 0.5)
	arg_18_0.edit.btn_select_move:setContentSize(var_18_1, var_18_2)
	arg_18_0.edit.btn_select_move:setTransformParent(arg_18_0.edit.area_wnd)
	arg_18_0.edit.btn_select_move:setLocalZOrder(arg_18_0.vars.order)
	arg_18_0.edit.btn_select_move:setVisible(not arg_18_0.vars.is_lock)
	var_18_7:addChild(arg_18_0.edit.btn_select_move)
	
	local var_18_8 = load_control("wnd/custom_edit_control.csb")
	
	var_18_8:setName("n_corner_btns")
	arg_18_0.edit.area_wnd:addChild(var_18_8)
	if_set_visible(var_18_8, "n_crop", false)
	if_set_visible(var_18_8, "n_side", false)
	if_set_visible(var_18_8, "n_fixed", false)
	if_set_visible(var_18_8, "n_multi", true)
	
	local var_18_9 = var_18_8:getChildByName("n_multi")
	
	if_set_visible(var_18_9, "n_ratio", true)
	if_set_visible(var_18_9, "n_rotate", true)
	if_set_visible(var_18_9, "n_off", true)
	
	arg_18_0.edit.btn_rotate = var_18_9:getChildByName("n_rotate")
	
	if get_cocos_refid(arg_18_0.edit.btn_rotate) then
		arg_18_0.edit.btn_rotate:setPosition(0, 0)
	end
	
	arg_18_0.edit.btn_delete = var_18_9:getChildByName("n_off")
	
	if get_cocos_refid(arg_18_0.edit.btn_delete) then
		arg_18_0.edit.btn_delete:setPosition(var_18_1, var_18_2)
	end
	
	arg_18_0.edit.btn_corner_scale_left = var_18_9:getChildByName("n_ratio")
	
	if get_cocos_refid(arg_18_0.edit.btn_corner_scale_left) then
		arg_18_0.edit.btn_corner_scale_left:setPosition(0, var_18_2)
	end
	
	arg_18_0.edit.btn_corner_scale_right = arg_18_0.edit.btn_corner_scale_left:clone()
	
	var_18_9:addChild(arg_18_0.edit.btn_corner_scale_right)
	
	if get_cocos_refid(arg_18_0.edit.btn_corner_scale_right) then
		arg_18_0.edit.btn_corner_scale_right:setPosition(var_18_1, 0)
	end
	
	arg_18_0:activeEditorBox(false)
	arg_18_0:addTouchEventListener()
end

function CustomProfileCard.text.activeEditorBox(arg_19_0, arg_19_1)
	if not arg_19_0.edit or not get_cocos_refid(arg_19_0.edit.area_wnd) then
		return 
	end
	
	arg_19_0.edit.area_wnd:setVisible(arg_19_1)
end

function CustomProfileCard.text.renderEditorBox(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.text) then
		return 
	end
	
	if not arg_20_0.edit or not get_cocos_refid(arg_20_0.edit.area_wnd) or not arg_20_0.edit.extra_size then
		return 
	end
	
	local var_20_0 = arg_20_0.text:getContentSize()
	local var_20_1 = arg_20_0.edit.extra_size
	local var_20_2 = var_20_0.width + var_20_1
	local var_20_3 = var_20_0.height + var_20_1
	local var_20_4 = -(var_20_1 / 2)
	local var_20_5 = -(var_20_1 / 2)
	
	arg_20_0.edit.area_wnd:setPosition(var_20_2 * 0.5 + var_20_4, var_20_3 * 0.5 + var_20_5)
	arg_20_0.edit.area_wnd:setContentSize(var_20_2, var_20_3)
	arg_20_0.edit.area_wnd:clear()
	arg_20_0.edit.area_wnd:drawRect(cc.p(0, 0), cc.p(var_20_2, var_20_3), cc.c4f(1, 1, 1, 1))
	arg_20_0.edit.area_wnd:visit()
	arg_20_0.edit.btn_select_move:setPosition(var_20_2 * 0.5, var_20_3 * 0.5)
	arg_20_0.edit.btn_select_move:setContentSize(var_20_2, var_20_3)
	
	if get_cocos_refid(arg_20_0.edit.btn_rotate) then
		arg_20_0.edit.btn_rotate:setPosition(0, 0)
	end
	
	if get_cocos_refid(arg_20_0.edit.btn_delete) then
		arg_20_0.edit.btn_delete:setPosition(var_20_2, var_20_3)
	end
	
	if get_cocos_refid(arg_20_0.edit.btn_corner_scale_left) then
		arg_20_0.edit.btn_corner_scale_left:setPosition(0, var_20_3)
	end
	
	if get_cocos_refid(arg_20_0.edit.btn_corner_scale_right) then
		arg_20_0.edit.btn_corner_scale_right:setPosition(var_20_2, 0)
	end
end

function CustomProfileCard.text.addTouchEventListener(arg_21_0)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.text) or not arg_21_0.edit then
		return 
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_rotate) then
		arg_21_0.edit.btn_rotate:getChildByName("btn"):addTouchEventListener(function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
			arg_21_0:textRotateEventHandler(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_delete) then
		arg_21_0.edit.btn_delete:getChildByName("btn"):addTouchEventListener(function(arg_23_0, arg_23_1)
			arg_21_0:textRemoveEventHandler(arg_23_0, arg_23_1)
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_select_move) then
		arg_21_0.edit.btn_select_move:addTouchEventListener(function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
			arg_21_0:textMoveEventHandler(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_corner_scale_left) then
		arg_21_0.edit.btn_corner_scale_left:getChildByName("btn"):addTouchEventListener(function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			arg_21_0:textCornerScaleEventHandler(arg_25_0, arg_25_1, arg_25_2, arg_25_3, "left")
		end)
	end
	
	if get_cocos_refid(arg_21_0.edit.btn_corner_scale_right) then
		arg_21_0.edit.btn_corner_scale_right:getChildByName("btn"):addTouchEventListener(function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			arg_21_0:textCornerScaleEventHandler(arg_26_0, arg_26_1, arg_26_2, arg_26_3, "right")
		end)
	end
	
	arg_21_0.edit.touch_move_btn_count = 0
	arg_21_0.edit.touch_corner_scale_btn_count = 0
	arg_21_0.edit.touch_rotate_btn_count = 0
end

function CustomProfileCard.text.textMoveEventHandler(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.text) or not get_cocos_refid(arg_27_1) then
		return 
	end
	
	if not arg_27_0.edit or not get_cocos_refid(arg_27_0.edit.area_wnd) then
		return 
	end
	
	if arg_27_0.vars.is_lock then
		return 
	end
	
	if arg_27_0.edit.is_rotate or arg_27_0.edit.is_corner_scale then
		return 
	end
	
	if arg_27_2 == 0 then
		arg_27_0.edit.touch_move_btn_count = arg_27_0.edit.touch_move_btn_count + 1
		
		if arg_27_0.edit.touch_move_btn_count == 1 then
			if not CustomProfileCardEditor:isFocusLayer(arg_27_0) and arg_27_1:getName() == "btn_select_move" then
				CustomProfileCardEditor:setFocusLayer(arg_27_0)
			end
			
			arg_27_0.edit.is_move = true
			arg_27_0.edit.touch_begin_pos = {
				x = arg_27_3,
				y = arg_27_4
			}
			arg_27_0.edit.origin_text_pos = {
				x = arg_27_0.text:getPositionX(),
				y = arg_27_0.text:getPositionY()
			}
		end
	elseif arg_27_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_27_0) then
			return 
		end
		
		if table.empty(arg_27_0.edit.touch_begin_pos) or table.empty(arg_27_0.edit.origin_text_pos) or not arg_27_0.edit.is_move or arg_27_0.edit.touch_move_btn_count ~= 1 then
			return 
		end
		
		arg_27_0.edit.is_move = true
		arg_27_0.edit.touch_move_pos = {
			x = arg_27_3,
			y = arg_27_4
		}
		
		local var_27_0 = arg_27_0.edit.touch_move_pos.x - arg_27_0.edit.touch_begin_pos.x
		local var_27_1 = arg_27_0.edit.touch_move_pos.y - arg_27_0.edit.touch_begin_pos.y
		
		arg_27_0:setPosition(arg_27_0.edit.origin_text_pos.x + var_27_0, arg_27_0.edit.origin_text_pos.y + var_27_1)
	else
		arg_27_0.edit.touch_move_btn_count = arg_27_0.edit.touch_move_btn_count - 1
		
		if arg_27_0.edit.touch_move_btn_count <= 0 then
			if not table.empty(arg_27_0.edit.origin_text_pos) and not table.empty(arg_27_0.vars.pos) and (math.abs(arg_27_0.edit.origin_text_pos.x - arg_27_0.vars.pos.x) >= 0.1 or math.abs(arg_27_0.edit.origin_text_pos.y - arg_27_0.vars.pos.y) >= 0.1) then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_27_0,
					undo_func = bind_func(arg_27_0.setPosition, arg_27_0, arg_27_0.edit.origin_text_pos.x, arg_27_0.edit.origin_text_pos.y),
					redo_func = bind_func(arg_27_0.setPosition, arg_27_0, arg_27_0.vars.pos.x, arg_27_0.vars.pos.y)
				}, true)
			end
			
			arg_27_0.edit.touch_move_btn_count = 0
			arg_27_0.edit.is_move = false
			arg_27_0.edit.touch_begin_pos = nil
			arg_27_0.edit.origin_text_pos = nil
			arg_27_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.text.textCornerScaleEventHandler(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.text) or not get_cocos_refid(arg_28_1) or not arg_28_5 then
		return 
	end
	
	if not arg_28_0.edit or not get_cocos_refid(arg_28_0.edit.area_wnd) then
		return 
	end
	
	if arg_28_0.edit.is_move or arg_28_0.edit.is_rotate then
		return 
	end
	
	if arg_28_2 == 0 then
		arg_28_0.edit.touch_corner_scale_btn_count = arg_28_0.edit.touch_corner_scale_btn_count + 1
		
		if arg_28_0.edit.touch_corner_scale_btn_count == 1 then
			arg_28_0.edit.is_corner_scale = true
			arg_28_0.edit.touch_begin_pos = arg_28_1:convertToWorldSpace({
				x = arg_28_1:getPositionX(),
				y = arg_28_1:getPositionY()
			})
			
			local var_28_0 = arg_28_0.text:getContentSize()
			local var_28_1 = arg_28_0.text:getAnchorPoint()
			local var_28_2 = {
				x = var_28_0.width * var_28_1.x,
				y = var_28_0.height * var_28_1.y
			}
			
			arg_28_0.edit.center_pos = arg_28_0.text:convertToWorldSpace({
				x = var_28_2.x,
				y = var_28_2.y
			})
			
			local var_28_3 = arg_28_0.edit.touch_begin_pos.x - arg_28_0.edit.center_pos.x
			local var_28_4 = arg_28_0.edit.touch_begin_pos.y - arg_28_0.edit.center_pos.y
			
			arg_28_0.edit.standard_dis = math.sqrt(var_28_3 * var_28_3 + var_28_4 * var_28_4)
			arg_28_0.edit.origin_font_size = arg_28_0.text:getFontSize()
			arg_28_0.edit.origin_text_angle = arg_28_0.text:getRotation()
		end
	elseif arg_28_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_28_0) then
			return 
		end
		
		if table.empty(arg_28_0.edit.touch_begin_pos) or table.empty(arg_28_0.edit.center_pos) or not arg_28_0.edit.origin_text_angle or not arg_28_0.edit.is_corner_scale or arg_28_0.edit.touch_corner_scale_btn_count ~= 1 then
			return 
		end
		
		arg_28_0.edit.is_corner_scale = true
		arg_28_0.edit.touch_move_pos = {
			x = arg_28_3,
			y = arg_28_4
		}
		
		local var_28_5 = math.sin(math.rad(arg_28_0.edit.origin_text_angle))
		local var_28_6 = math.cos(math.rad(arg_28_0.edit.origin_text_angle))
		local var_28_7 = (arg_28_0.edit.touch_move_pos.x - arg_28_0.edit.center_pos.x) * var_28_6 - (arg_28_0.edit.touch_move_pos.y - arg_28_0.edit.center_pos.y) * var_28_5 + arg_28_0.edit.center_pos.x
		local var_28_8 = (arg_28_0.edit.touch_move_pos.x - arg_28_0.edit.center_pos.x) * var_28_5 + (arg_28_0.edit.touch_move_pos.y - arg_28_0.edit.center_pos.y) * var_28_6 + arg_28_0.edit.center_pos.y
		local var_28_9 = var_28_7 - arg_28_0.edit.center_pos.x
		local var_28_10 = var_28_8 - arg_28_0.edit.center_pos.y
		local var_28_11 = math.sqrt(var_28_9 * var_28_9 + var_28_10 * var_28_10)
		local var_28_12 = arg_28_0.text:getFontSize()
		local var_28_13 = var_28_11 / arg_28_0.edit.standard_dis
		local var_28_14 = 20
		local var_28_15 = 80
		
		if not table.empty(arg_28_0.edit.font_size_limit) then
			var_28_14 = arg_28_0.edit.font_size_limit.min
			var_28_15 = arg_28_0.edit.font_size_limit.max
		end
		
		local var_28_16 = round(var_28_12 * var_28_13)
		
		if arg_28_5 == "left" then
			if var_28_7 > arg_28_0.edit.center_pos.x and var_28_8 < arg_28_0.edit.center_pos.y then
				var_28_16 = var_28_14
			end
		elseif arg_28_5 == "right" and var_28_7 < arg_28_0.edit.center_pos.x and var_28_8 > arg_28_0.edit.center_pos.y then
			var_28_16 = var_28_14
		end
		
		if var_28_16 <= var_28_14 then
			var_28_16 = var_28_14
		end
		
		if var_28_15 <= var_28_16 then
			var_28_16 = var_28_15
		end
		
		CustomProfileCardText:setFontSizeSlider(var_28_16)
		arg_28_0:setFontSize(var_28_16)
	else
		arg_28_0.edit.touch_corner_scale_btn_count = arg_28_0.edit.touch_corner_scale_btn_count - 1
		
		if arg_28_0.edit.touch_corner_scale_btn_count <= 0 then
			if arg_28_0.edit.origin_font_size and arg_28_0.vars.font_size and arg_28_0.edit.origin_font_size ~= arg_28_0.vars.font_size then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_28_0,
					undo_func = bind_func(arg_28_0.setFontSize, arg_28_0, arg_28_0.edit.origin_font_size),
					redo_func = bind_func(arg_28_0.setFontSize, arg_28_0, arg_28_0.vars.font_size)
				}, true)
			end
			
			arg_28_0.edit.touch_corner_scale_btn_count = 0
			arg_28_0.edit.is_corner_scale = false
			arg_28_0.edit.touch_begin_pos = nil
			arg_28_0.edit.center_pos = nil
			arg_28_0.edit.origin_text_angle = nil
			arg_28_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.text.textRotateEventHandler(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.text) or not get_cocos_refid(arg_29_1) then
		return 
	end
	
	if not arg_29_0.edit or not get_cocos_refid(arg_29_0.edit.area_wnd) then
		return 
	end
	
	if arg_29_0.edit.is_move or arg_29_0.edit.is_corner_scale then
		return 
	end
	
	if arg_29_2 == 0 then
		arg_29_0.edit.touch_rotate_btn_count = arg_29_0.edit.touch_rotate_btn_count + 1
		
		if arg_29_0.edit.touch_rotate_btn_count == 1 then
			arg_29_0.edit.is_rotate = true
			arg_29_0.edit.touch_begin_pos = nil
			arg_29_0.edit.touch_begin_pos = {
				x = arg_29_3,
				y = arg_29_4
			}
			
			local var_29_0 = arg_29_0.text:getContentSize()
			local var_29_1 = arg_29_0.text:getAnchorPoint()
			local var_29_2 = {
				x = var_29_0.width * var_29_1.x,
				y = var_29_0.height * var_29_1.y
			}
			
			arg_29_0.edit.center_pos = arg_29_0.text:convertToWorldSpace({
				x = var_29_2.x,
				y = var_29_2.y
			})
			arg_29_0.edit.origin_text_angle = arg_29_0.text:getRotation()
		end
	elseif arg_29_2 == 1 then
		if not CustomProfileCardEditor:isFocusLayer(arg_29_0) then
			return 
		end
		
		if table.empty(arg_29_0.edit.touch_begin_pos) or table.empty(arg_29_0.edit.center_pos) or not arg_29_0.edit.is_rotate or arg_29_0.edit.touch_rotate_btn_count ~= 1 then
			return 
		end
		
		arg_29_0.edit.is_rotate = true
		arg_29_0.edit.touch_move_pos = {
			x = arg_29_3,
			y = arg_29_4
		}
		
		local var_29_3 = math.deg(math.atan2(arg_29_0.edit.touch_begin_pos.y - arg_29_0.edit.center_pos.y, arg_29_0.edit.touch_begin_pos.x - arg_29_0.edit.center_pos.x) - math.atan2(arg_29_0.edit.touch_move_pos.y - arg_29_0.edit.center_pos.y, arg_29_0.edit.touch_move_pos.x - arg_29_0.edit.center_pos.x))
		
		arg_29_0:setRotation(var_29_3 + arg_29_0.edit.origin_text_angle)
	else
		arg_29_0.edit.touch_rotate_btn_count = arg_29_0.edit.touch_rotate_btn_count - 1
		
		if arg_29_0.edit.touch_rotate_btn_count <= 0 then
			if arg_29_0.edit.origin_text_angle and arg_29_0.vars.rotation and math.abs(arg_29_0.edit.origin_text_angle - arg_29_0.vars.rotation) >= 0.1 then
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					layer = arg_29_0,
					undo_func = bind_func(arg_29_0.setRotation, arg_29_0, arg_29_0.edit.origin_text_angle),
					redo_func = bind_func(arg_29_0.setRotation, arg_29_0, arg_29_0.vars.rotation)
				}, true)
			end
			
			arg_29_0.edit.touch_rotate_btn_count = 0
			arg_29_0.edit.is_rotate = false
			arg_29_0.edit.touch_begin_pos = nil
			arg_29_0.edit.center_pos = nil
			arg_29_0.edit.origin_text_angle = nil
			arg_29_0.edit.touch_move_pos = nil
		end
	end
end

function CustomProfileCard.text.textRemoveEventHandler(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_0.parent or not arg_30_0.vars or not get_cocos_refid(arg_30_0.layer_wnd) or not get_cocos_refid(arg_30_1) then
		return 
	end
	
	if not arg_30_0.edit or not get_cocos_refid(arg_30_0.edit.area_wnd) then
		return 
	end
	
	if arg_30_2 == 2 or arg_30_2 == 3 then
		arg_30_0.parent:deleteLayer({
			order = arg_30_0.vars.order,
			type = arg_30_0.vars.type
		})
	end
end

function CustomProfileCard.text.setPosition(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0.vars or not arg_31_0.vars.pos or not get_cocos_refid(arg_31_0.text) then
		return 
	end
	
	arg_31_0.vars.pos.x = arg_31_1
	arg_31_0.vars.pos.y = arg_31_2
	
	arg_31_0.text:setPosition(arg_31_1, arg_31_2)
	arg_31_0:renderEditorBox()
end

function CustomProfileCard.text.setRotation(arg_32_0, arg_32_1)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.text) then
		return 
	end
	
	arg_32_0.vars.rotation = arg_32_1
	
	arg_32_0.text:setRotation(arg_32_1)
	arg_32_0:renderEditorBox()
end

function CustomProfileCard.text.setText(arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.text) then
		return 
	end
	
	if arg_33_0.vars.text == arg_33_1 then
		return 
	end
	
	if not arg_33_2 then
		local var_33_0 = arg_33_0.vars.text
		local var_33_1 = arg_33_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_33_0,
			undo_func = bind_func(arg_33_0.setText, arg_33_0, var_33_0, true),
			redo_func = bind_func(arg_33_0.setText, arg_33_0, var_33_1, true)
		}, true)
	end
	
	arg_33_0.vars.text = arg_33_1
	
	arg_33_0.text:setString(arg_33_1)
	arg_33_0:renderEditorBox()
end

function CustomProfileCard.text.setColor(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.text) then
		return 
	end
	
	if table.empty(arg_34_1) then
		return 
	end
	
	if arg_34_0.vars.color == arg_34_1 then
		return 
	end
	
	if not arg_34_2 then
		local var_34_0 = arg_34_0.vars.color
		local var_34_1 = arg_34_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_34_0,
			undo_func = bind_func(arg_34_0.setColor, arg_34_0, var_34_0, true),
			redo_func = bind_func(arg_34_0.setColor, arg_34_0, var_34_1, true)
		}, true)
	end
	
	arg_34_0.vars.color = arg_34_1
	
	arg_34_0.text:setTextColor(cc.c3b(arg_34_1.r, arg_34_1.g, arg_34_1.b))
	
	if arg_34_0.vars.is_bold then
		local var_34_2 = arg_34_0.text:getTextColor()
		
		arg_34_0.text:enableOutline(var_34_2, 1)
	end
end

function CustomProfileCard.text.setFontSize(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.text) then
		return 
	end
	
	if not arg_35_1 or type(arg_35_1) ~= "number" then
		return 
	end
	
	arg_35_0.vars.font_size = arg_35_1
	
	arg_35_0.text:setFontSize(arg_35_1)
	arg_35_0:renderEditorBox()
end

function CustomProfileCard.text.setOpacityRate(arg_36_0, arg_36_1)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.text) then
		return 
	end
	
	arg_36_0.vars.opacity_rate = arg_36_1
	
	arg_36_0.text:setOpacity(round(2.55 * arg_36_1))
end

function CustomProfileCard.text.setBold(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.text) then
		return 
	end
	
	if arg_37_0.vars.is_bold == arg_37_1 then
		return 
	end
	
	if not arg_37_2 then
		local var_37_0 = arg_37_0.vars.is_bold
		local var_37_1 = arg_37_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_37_0,
			undo_func = bind_func(arg_37_0.setBold, arg_37_0, var_37_0, true),
			redo_func = bind_func(arg_37_0.setBold, arg_37_0, var_37_1, true)
		}, true)
	end
	
	arg_37_0.vars.is_bold = arg_37_1
	
	if arg_37_1 then
		local var_37_2 = arg_37_0.text:getTextColor()
		
		arg_37_0.text:enableOutline(var_37_2, 1)
	else
		arg_37_0.text:disableEffect(cc.LabelEffect.OUTLINE)
	end
	
	arg_37_0:renderEditorBox()
end

function CustomProfileCard.text.setVisible(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.text) then
		return 
	end
	
	if arg_38_0.vars.is_visible == arg_38_1 then
		return 
	end
	
	if not arg_38_2 then
		local var_38_0 = arg_38_0.vars.is_visible
		local var_38_1 = arg_38_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_38_0,
			undo_func = bind_func(arg_38_0.setVisible, arg_38_0, var_38_0, true),
			redo_func = bind_func(arg_38_0.setVisible, arg_38_0, var_38_1, true)
		}, true)
	end
	
	arg_38_0.vars.is_visible = arg_38_1
	
	arg_38_0.text:setVisible(arg_38_1)
end

function CustomProfileCard.text.setLock(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_0.vars or not arg_39_0.edit or not get_cocos_refid(arg_39_0.edit.btn_select_move) then
		return 
	end
	
	if arg_39_0.vars.is_lock == arg_39_1 then
		return 
	end
	
	if not arg_39_2 then
		local var_39_0 = arg_39_0.vars.is_lock
		local var_39_1 = arg_39_1
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_39_0,
			undo_func = bind_func(arg_39_0.setLock, arg_39_0, var_39_0, true),
			redo_func = bind_func(arg_39_0.setLock, arg_39_0, var_39_1, true)
		}, true)
	end
	
	arg_39_0.vars.is_lock = arg_39_1
	
	arg_39_0.edit.btn_select_move:setVisible(not arg_39_1)
end
