UnitZoom = {}
UnitZoom.ui_hide_delay = 2000
UnitZoom.fade_time = 500

function HANDLER.unit_detail_zoom(arg_1_0, arg_1_1)
	if not UnitZoom.vars.ui_enable then
		print("UnitZoom ui disabled!")
		
		return 
	end
	
	if arg_1_1 == "btn_change_bg" and not UIAction:Find("bg.fade") then
		UnitZoom:showBackgroundChangeUI()
		
		return 
	end
	
	if arg_1_1 == "btn_cancel" then
		UnitZoom:onCloseChangeBG()
		
		return 
	end
	
	if arg_1_1 == "btn_rotation" then
		UnitZoom:rotate()
		
		return 
	end
end

function UnitZoom.onCreate(arg_2_0, arg_2_1)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.wnd) then
		arg_2_0.vars = {}
		arg_2_0.vars.wnd = load_dlg("unit_detail_zoom", true, "wnd")
		
		arg_2_0.vars.wnd:setLocalZOrder(1)
		UnitMain.vars.base_wnd:addChild(arg_2_0.vars.wnd)
		arg_2_0:updateAxisUI()
	end
end

function UnitZoom.onEnter(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars.prev_mode = arg_3_1
	
	TopBarNew:setCurrencies({})
	TopBarNew:setEnableTip(false)
	TopBarNew:forcedHelp_OnOff(false)
	TopBarNew:setVisibleTopRightButtons(false)
	
	local var_3_0 = UnitMain:getWnd()
	
	if get_cocos_refid(var_3_0) then
		local var_3_1 = var_3_0:getChildByName("img")
		
		if get_cocos_refid(var_3_1) then
			arg_3_0.vars.init_bg_img_scale_x = var_3_1:getScaleX()
			arg_3_0.vars.init_bg_img_scale_y = var_3_1:getScaleY()
		end
		
		if_set_visible(var_3_0, "Sprite_1", false)
		arg_3_0:onSelectTargetUnit(arg_3_2.unit)
		
		local var_3_2 = var_3_0:getChildByName("bg")
		
		arg_3_0.vars.bg_landscape = UIBackground:create(var_3_2, 1, "bg_position_hero", "bg_scale_hero", {
			default_scale = 1.2,
			default_poses = {
				0,
				0,
				0
			}
		})
		arg_3_0.vars.bg_portrait = UIBackground:create(var_3_2, 1, "bg_position", "bg_scale")
		arg_3_0.vars.unit_node = var_3_0:getChildByName("port_pos")
		
		if_set_visible(var_3_0:getChildByName("CENTER"), nil, false)
	end
	
	arg_3_0.vars.ignore_touch_down_event = true
	
	arg_3_0:updateAxisUI("Landscape")
	UnitMain:movePortrait("Zoom")
	UIAction:Add(SEQ(DELAY(200), CALL(function()
		UnitZoom:onLandscapeMode()
		UnitZoom:addZoomMouseWheel()
		
		arg_3_0.vars.ignore_touch_down_event = false
	end)), arg_3_0.vars.wnd, "block")
	
	local var_3_3 = TopBarNew.vars.top_left:getChildByName("TOP_LEFT")
	
	if get_cocos_refid(var_3_3) then
		local function var_3_4()
			arg_3_0.vars.ui_enable = true
		end
		
		local function var_3_5()
			arg_3_0.vars.ui_enable = false
		end
		
		UIAction:Add(SEQ(FADE_IN(arg_3_0.fade_time), DELAY(arg_3_0.ui_hide_delay), FADE_OUT(arg_3_0.fade_time)), var_3_3, "ui_show_hide")
		arg_3_0.vars.wnd:setVisible(true)
		UIAction:Add(SEQ(SHOW(true), FADE_IN(arg_3_0.fade_time), CALL(var_3_4), DELAY(arg_3_0.ui_hide_delay), CALL(var_3_5), FADE_OUT(arg_3_0.fade_time), SHOW(false)), arg_3_0.vars.wnd, "ui_show_hide_2")
		NotchManager:addListener(var_3_3, nil, function(arg_7_0, arg_7_1, arg_7_2)
			local var_7_0 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
			
			arg_7_0:setPositionX(VIEW_BASE_LEFT + var_7_0 / 2)
		end)
		
		local var_3_6 = arg_3_0.vars.wnd:findChildByName("n_left")
		local var_3_7 = NOTCH_WIDTH > 0
		
		if_set_visible(var_3_6, "_grow_s", not var_3_7)
		if_set_visible(var_3_6, "_grow_add", var_3_7)
	end
	
	if call_lock_device_orientation then
		call_lock_device_orientation(true)
	end
	
	BGSelector:dataInit("UnitZoom", function(arg_8_0, arg_8_1)
		arg_3_0:onChangeBackground(arg_8_0, arg_8_1)
	end, true)
	
	local var_3_8 = SAVE:getKeep("unit_bg_" .. arg_3_0.vars.unit.inst.uid, "ma_bg_base")
	
	BGSelector:setToID(var_3_8)
end

function UnitZoom.onLandscapeMode(arg_9_0)
	arg_9_0.vars.mode = "Landscape"
	
	TopBarNew:setPortraitMode(false)
	SceneManager:getCurrentScene():showLetterBox(true)
	
	local var_9_0 = UnitMain:getWnd()
	
	if get_cocos_refid(var_9_0) then
		local var_9_1 = var_9_0:getChildByName("img")
		
		if get_cocos_refid(var_9_1) then
			var_9_1:setScaleX(arg_9_0.vars.init_bg_img_scale_x)
			var_9_1:setScaleY(arg_9_0.vars.init_bg_img_scale_y)
		end
	end
	
	if arg_9_0.vars.bg_item then
		arg_9_0:setBackground(arg_9_0.vars.bg_item)
	end
	
	if arg_9_0.vars.zoom_cont then
		arg_9_0.vars.zoom_cont:detachZoomNode()
		UnitMain:movePortrait("Zoom", true)
	end
	
	local var_9_2 = arg_9_0.vars.unit_node:getScale()
	
	arg_9_0.vars.unit_node:setScale(1)
	
	arg_9_0.vars.zoom_cont = ZoomController({
		layer = arg_9_0.vars.unit_node,
		scale = var_9_2
	})
	
	arg_9_0:updateAxisUI()
end

function UnitZoom.onPortraitMode(arg_10_0)
	arg_10_0.vars.mode = "Portrait"
	
	TopBarNew:setPortraitMode(true)
	SceneManager:getCurrentScene():showLetterBox(false)
	
	local var_10_0 = UnitMain:getWnd()
	
	if get_cocos_refid(var_10_0) then
		local var_10_1 = var_10_0:getChildByName("img")
		
		if get_cocos_refid(var_10_1) and arg_10_0.vars.init_bg_img_scale_x and arg_10_0.vars.init_bg_img_scale_y then
			local var_10_2 = 4
			
			var_10_1:setScaleX(arg_10_0.vars.init_bg_img_scale_x * var_10_2)
			var_10_1:setScaleY(arg_10_0.vars.init_bg_img_scale_y * var_10_2)
		end
	end
	
	if arg_10_0.vars.bg_item then
		arg_10_0:setBackground(arg_10_0.vars.bg_item)
	end
	
	if arg_10_0.vars.zoom_cont then
		arg_10_0.vars.zoom_cont:detachZoomNode()
		UnitMain:resetPortraitPos(true)
	end
	
	arg_10_0.vars.zoom_cont = ZoomController({
		rotate = -90,
		scale = 1.5,
		layer = arg_10_0.vars.unit_node
	})
	
	local var_10_3 = arg_10_0.vars.wnd:getChildByName("_grow_s"):getContentSize()
	
	var_10_3.width = var_10_3.width * 3
	
	arg_10_0.vars.wnd:getChildByName("_grow_s"):setContentSize(var_10_3.width, var_10_3.height)
	arg_10_0:updateAxisUI()
end

function UnitZoom.rotate(arg_11_0)
	if arg_11_0.vars.mode == "Portrait" then
		arg_11_0:onLandscapeMode()
	else
		arg_11_0:onPortraitMode()
	end
end

function UnitZoom.isValid(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	return true
end

function UnitZoom.addZoomMouseWheel(arg_13_0)
	if not arg_13_0.vars or PLATFORM ~= "win32" then
		return 
	end
	
	arg_13_0:removeEventListener()
	
	local var_13_0 = SceneManager:getCurrentScene()
	
	if var_13_0 and var_13_0.layer then
		local var_13_1 = var_13_0.layer:getEventDispatcher()
		
		arg_13_0.vars.listener = cc.EventListenerMouse:create()
		
		arg_13_0.vars.listener:registerScriptHandler(function(arg_14_0, arg_14_1)
			UnitMain:onMouseWheel(arg_14_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_13_1:addEventListenerWithSceneGraphPriority(arg_13_0.vars.listener, var_13_0.layer)
	end
end

function UnitZoom.removeEventListener(arg_15_0)
	if not arg_15_0.vars or not arg_15_0.vars.listener then
		return 
	end
	
	local var_15_0 = SceneManager:getCurrentScene()
	
	if var_15_0 and PLATFORM == "win32" and var_15_0.layer then
		var_15_0.layer:getEventDispatcher():removeEventListener(arg_15_0.vars.listener)
	end
	
	arg_15_0.vars.listener = nil
end

function UnitZoom.setBackground(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars then
		return 
	end
	
	if arg_16_0.vars.mode == "Portrait" then
		arg_16_0.vars.bg_portrait:setBackground(arg_16_1, arg_16_2, -90)
		arg_16_0.vars.bg_portrait:useRATIOScale(arg_16_1, arg_16_2)
		arg_16_0.vars.bg_landscape:offBackground()
	else
		arg_16_0.vars.bg_landscape:setBackground(arg_16_1, arg_16_2)
		arg_16_0.vars.bg_portrait:offBackground()
	end
	
	SAVE:setKeep("unit_bg_" .. arg_16_0.vars.unit.inst.uid, arg_16_1.id)
end

function UnitZoom.onChangeBackground(arg_17_0, arg_17_1, arg_17_2)
	if_set_sprite(arg_17_0.vars.bg_change, "bg_base", arg_17_2.icon)
	if_set(arg_17_0.vars.bg_change, "txt_title", T(arg_17_2.name))
	if_set(arg_17_0.vars.bg_change, "txt_desc", T(arg_17_2.desc))
	
	if arg_17_0.vars.idx ~= arg_17_1 then
		local var_17_0 = arg_17_0.vars.idx == nil and arg_17_1 == 1
		
		arg_17_0:setBackground(arg_17_2, true)
		
		if not var_17_0 then
			arg_17_0:fadeInOut()
		end
	end
	
	arg_17_0.vars.idx = arg_17_1
	arg_17_0.vars.bg_item = arg_17_2
end

function UnitZoom.fadeInOut(arg_18_0)
	local var_18_0 = arg_18_0:getUIBackground()
	
	if var_18_0 then
		var_18_0:fadeInOut()
	end
end

function UnitZoom.onCloseChangeBG(arg_19_0)
	if_set_visible(arg_19_0.vars.wnd, "btn_cancel", false)
	UIAction:Add(SEQ(RLOG(MOVE_BY(300, 0, -800)), REMOVE()), arg_19_0.vars.bg_change, "block")
	
	local var_19_0 = TopBarNew.vars.top_left:getChildByName("TOP_LEFT")
	
	if get_cocos_refid(var_19_0) then
		local function var_19_1()
			arg_19_0.vars.ui_enable = false
		end
		
		UIAction:Add(SEQ(DELAY(arg_19_0.ui_hide_delay), CALL(var_19_1), FADE_OUT(arg_19_0.fade_time)), var_19_0, "ui_show_hide")
		UIAction:Add(SEQ(DELAY(arg_19_0.ui_hide_delay), FADE_OUT(arg_19_0.fade_time), SHOW(false)), arg_19_0.vars.wnd, "ui_show_hide_2")
	end
	
	arg_19_0.vars.ignore_touch_down_event = false
	arg_19_0.vars.bg_change = nil
end

function UnitZoom.getUIBackground(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if arg_21_0.vars.mode == "Portrait" then
		return arg_21_0.vars.bg_portrait
	else
		return arg_21_0.vars.bg_landscape
	end
end

function UnitZoom.updateAxisUI(arg_22_0, arg_22_1)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	local var_22_0 = (arg_22_1 or arg_22_0.vars.mode) == "Portrait"
	
	if_set_visible(arg_22_0.vars.wnd, "n_horizontal", not var_22_0)
	if_set_visible(arg_22_0.vars.wnd, "n_vertical", var_22_0)
end

function UnitZoom.showBackgroundChangeUI(arg_23_0)
	if get_cocos_refid(arg_23_0.vars.bg_change) then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.mode == "Portrait" and "n_bg_change_popup" or "n_bg_change_popup_horizontal"
	local var_23_1 = arg_23_0.vars.wnd:getChildByName(var_23_0)
	local var_23_2 = load_control("wnd/bg_change_popup.csb")
	
	var_23_1:addChild(var_23_2)
	UIAction:Remove("ui_show_hide")
	UIAction:Remove("ui_show_hide_2")
	var_23_2:setPositionY(var_23_2:getPositionY() - 800)
	UIAction:Add(SEQ(LOG(MOVE_BY(300, 0, 800))), var_23_2, "block")
	if_set_visible(arg_23_0.vars.wnd, "btn_cancel", true)
	if_set(var_23_2, "t_bgpack_info", T("background_change_vertical"))
	
	arg_23_0.vars.ignore_touch_down_event = true
	arg_23_0.vars.bg_change = var_23_2
	
	BGSelector:init(var_23_2:getChildByName("scrollview"), function(arg_24_0, arg_24_1)
		arg_23_0:onChangeBackground(arg_24_0, arg_24_1)
	end, "UnitZoom")
	BGSelector:setToIndex(arg_23_0.vars.idx or 1)
	BGSelector:scrollToIndex(arg_23_0.vars.idx, 0.7)
end

function UnitZoom.onLeave(arg_25_0, arg_25_1)
	if not arg_25_1 then
		return 
	end
	
	if call_lock_device_orientation then
		call_lock_device_orientation(false)
	end
	
	arg_25_0.vars.ignore_touch_down_event = nil
	arg_25_0.vars.idx = nil
	arg_25_0.vars.ui_enable = nil
	
	arg_25_0.vars.bg_portrait:remove()
	arg_25_0.vars.bg_landscape:remove()
	
	if get_cocos_refid(arg_25_0.vars.bg_change) then
		arg_25_0.vars.bg_change:removeFromParent()
	end
	
	if_set_visible(arg_25_0.vars.wnd, "btn_cancel", false)
	SceneManager:getCurrentScene():showLetterBox(true)
	TopBarNew:setCurrencies()
	TopBarNew:setEnableTip(true)
	TopBarNew:setPortraitMode(false)
	TopBarNew:setVisibleTopRightButtons(true)
	
	local var_25_0 = UnitMain:getWnd()
	
	if get_cocos_refid(var_25_0) then
		local var_25_1 = var_25_0:getChildByName("img")
		
		if get_cocos_refid(var_25_1) then
			var_25_1:setScaleX(arg_25_0.vars.init_bg_img_scale_x)
			var_25_1:setScaleY(arg_25_0.vars.init_bg_img_scale_y)
		end
		
		if_set_visible(var_25_0, "Sprite_1", true)
		if_set_visible(var_25_0:getChildByName("CENTER"), nil, true)
	end
	
	if arg_25_0.vars.unit then
		UnitDetail:updateUnitInfo(arg_25_0.vars.unit)
	end
	
	arg_25_0.vars.zoom_cont:detachZoomNode()
	
	arg_25_0.vars.zoom_cont = nil
	
	UIAction:Remove("ui_show_hide")
	UIAction:Remove("ui_show_hide_2")
	
	local var_25_2 = TopBarNew.vars.top_left:getChildByName("TOP_LEFT")
	
	if get_cocos_refid(var_25_2) then
		var_25_2:setOpacity(255)
		arg_25_0.vars.wnd:setVisible(false)
		
		local var_25_3 = 0
		
		if NotchStatus:isRequireAdjustEdge() then
			var_25_3 = NotchStatus:getAdjustEdgeValue()
		end
		
		var_25_2:setPositionX(VIEW_BASE_LEFT + var_25_3)
		NotchManager:addListener(var_25_2)
	end
	
	BGSelector:remove()
	arg_25_0:removeEventListener()
end

function UnitZoom.onPushBackButton(arg_26_0)
	if not arg_26_0.vars or not arg_26_0.vars.prev_mode then
		return 
	end
	
	local var_26_0
	
	if arg_26_0.vars.prev_mode == "Detail" then
		var_26_0 = UnitDetail:getPrevDetailMode() or "Profile"
	end
	
	UnitMain:setMode(arg_26_0.vars.prev_mode, {
		unit = arg_26_0.vars.unit,
		detail_mode = var_26_0
	})
	TopBarNew:setVisibleTopRightButtons(true)
end

function UnitZoom.onSelectTargetUnit(arg_27_0, arg_27_1)
	arg_27_0.vars.unit = arg_27_1
	
	if not arg_27_1 then
		return 
	end
	
	UnitMain:changePortrait(arg_27_1)
end

function UnitZoom.onTouchDown(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0.vars.ignore_touch_down_event then
		return 
	end
	
	if not UIAction:Find("ui_show_hide") then
		local var_28_0 = TopBarNew.vars.top_left:getChildByName("TOP_LEFT")
		
		if get_cocos_refid(var_28_0) then
			local function var_28_1()
				arg_28_0.vars.ui_enable = true
			end
			
			local function var_28_2()
				arg_28_0.vars.ui_enable = false
			end
			
			UIAction:Add(SEQ(FADE_IN(arg_28_0.fade_time), DELAY(arg_28_0.ui_hide_delay), FADE_OUT(arg_28_0.fade_time)), var_28_0, "ui_show_hide")
			UIAction:Add(SEQ(SHOW(true), FADE_IN(arg_28_0.fade_time), CALL(var_28_1), DELAY(arg_28_0.ui_hide_delay), CALL(var_28_2), FADE_OUT(arg_28_0.fade_time), SHOW(false)), arg_28_0.vars.wnd, "ui_show_hide_2")
		end
	end
	
	return arg_28_0.vars.zoom_cont:onTouchDown(arg_28_1, arg_28_2)
end

function UnitZoom.onTouchUp(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0.vars.ignore_touch_down_event then
		return 
	end
	
	return arg_31_0.vars.zoom_cont:onTouchUp(arg_31_1, arg_31_2)
end

function UnitZoom.onTouchMove(arg_32_0, arg_32_1, arg_32_2)
	if arg_32_0.vars.ignore_touch_down_event then
		return 
	end
	
	return arg_32_0.vars.zoom_cont:onTouchMove(arg_32_1, arg_32_2)
end

function UnitZoom.onGestureZoom(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	if arg_33_0.vars.ignore_touch_down_event then
		return 
	end
	
	arg_33_0.vars.zoom_cont:onGestureZoom(arg_33_1, arg_33_2, arg_33_3)
end

function UnitZoom.onMouseWheel(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.vars.zoom_cont:onMouseWheel(arg_34_1)
end
