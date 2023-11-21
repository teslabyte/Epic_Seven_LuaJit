ArtiZoom = {}
ArtiZoom.ui_hide_delay = 2000
ArtiZoom.fade_time = 500

function ArtiZoom.onCreate(arg_1_0, arg_1_1)
	if not arg_1_0.vars or not get_cocos_refid(arg_1_0.vars.wnd) then
		arg_1_0:removeEventListener()
		arg_1_0:allSetVisibleFlag(false)
		arg_1_0:allSetTouchFlag(false)
		
		arg_1_0.vars = {}
		arg_1_0.vars.ui_enable = nil
		arg_1_0.vars.wnd = load_dlg("artifact_detail_zoom", true, "wnd")
		
		arg_1_0.vars.wnd:setLocalZOrder(1)
		;(arg_1_1.layer or SceneManager:getRunningNativeScene()):addChild(arg_1_0.vars.wnd)
		arg_1_0.vars.wnd:bringToFront()
		
		arg_1_0.vars.code = arg_1_1.code
		arg_1_0.vars.close_callback = arg_1_1.close_callback
		
		arg_1_0:addEventListener()
		arg_1_0:createArtifact(arg_1_1.code)
		arg_1_0:setZoomNode()
		arg_1_0:setupUI(arg_1_1.code)
	end
end

function ArtiZoom.ArtiZoomNodeAction(arg_2_0, arg_2_1)
	if get_cocos_refid(arg_2_1) then
		if UIAction:Find("n_zoom_hide") then
			UIAction:Remove("n_zoom_hide")
		end
		
		if_set_visible(arg_2_1, nil, true)
		arg_2_1:setOpacity(255)
		UIAction:Add(SEQ(DELAY(2500), FADE_OUT(500), SHOW(false)), arg_2_1, "n_zoom_hide")
	else
		Log.e("not exist n_zoom")
	end
end

function ArtiZoom.setupUI(arg_3_0, arg_3_1)
	local var_3_0 = DB("equip_item", arg_3_1, "name")
	
	TopBarNew:createFromPopup(T(var_3_0), arg_3_0.vars.wnd, function()
		arg_3_0:onRemove()
	end)
	TopBarNew:setCurrencies({})
	TopBarNew:setEnableTip(false)
	TopBarNew:forcedHelp_OnOff(false)
	TopBarNew:setVisibleTopRightButtons(false)
	TopBarNew:setPortraitMode(true)
	arg_3_0:uiEnableAction()
	
	local var_3_1 = TopBarNew.vars.top_left:getChildByName("TOP_LEFT")
	
	var_3_1:setPositionY(0)
	NotchManager:addListener(var_3_1, nil, function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
		
		arg_5_0:setPositionX(VIEW_BASE_LEFT + var_5_0 / 2)
	end)
	
	local var_3_2 = TopBarNew.vars.top_right:findChildByName("n_mail")
	
	if_set_visible(var_3_2, nil, false)
	
	local var_3_3 = arg_3_0.vars.wnd:findChildByName("n_left")
	local var_3_4 = NOTCH_WIDTH > 0
	
	if_set_visible(var_3_3, "_grow_s", not var_3_4)
	if_set_visible(var_3_3, "_grow_add", var_3_4)
end

function ArtiZoom.allSetVisibleFlag(arg_6_0, arg_6_1)
	allSceneSetVisibleFlag(arg_6_1)
end

function ArtiZoom.allSetTouchFlag(arg_7_0, arg_7_1)
	if UnitMain:isVisible() then
		UnitMain:getHeroBelt():setTouchEnabled(arg_7_1)
	end
	
	local var_7_0 = UIUtil:getPetBelts()
	
	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if iter_7_1:isValid() then
			iter_7_1:setTouchEnabled(arg_7_1)
		end
	end
end

function ArtiZoom.onRemove(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	arg_8_0:removeEventListener()
	arg_8_0:allSetVisibleFlag(true)
	arg_8_0:allSetTouchFlag(true)
	
	local var_8_0 = TopBarNew.vars.top_right:findChildByName("n_mail")
	
	if_set_visible(var_8_0, nil, true)
	TopBarNew:setCurrencies()
	TopBarNew:setEnableTip(true)
	TopBarNew:setPortraitMode(false)
	TopBarNew:setVisibleTopRightButtons(true)
	TopBarNew:pop()
	BackButtonManager:pop()
	arg_8_0.vars.zoom_cont:detachZoomNode()
	
	arg_8_0.vars.zoom_cont = nil
	
	if get_cocos_refid(arg_8_0.vars.arti_node) then
		arg_8_0.vars.arti_node:release()
	end
	
	if arg_8_0.vars.close_callback then
		arg_8_0.vars.close_callback()
	end
	
	arg_8_0.vars.wnd:removeFromParent()
	
	arg_8_0.vars.ui_enable = nil
	arg_8_0.vars = nil
end

function ArtiZoom.createArtifact(arg_9_0, arg_9_1)
	local var_9_0 = SpriteCache:getSprite("item_arti/" .. (DB("equip_item", arg_9_1, "image") or "") .. ".png")
	
	arg_9_0.vars.arti_node = var_9_0
	
	arg_9_0.vars.arti_node:setAnchorPoint(0.5, 0)
	arg_9_0.vars.wnd:findChildByName("n_vertical"):addChild(arg_9_0.vars.arti_node)
end

function ArtiZoom.addEventListener(arg_10_0)
	arg_10_0.vars.touches = {}
	
	local function var_10_0(arg_11_0, arg_11_1)
		if not arg_10_0.vars or not arg_10_0.vars.touches then
			return 
		end
		
		local var_11_0
		
		for iter_11_0, iter_11_1 in pairs(arg_11_1) do
			arg_10_0.vars.touches[iter_11_1:getId() + 1] = iter_11_1
			
			if iter_11_1:getId() == 0 then
				var_11_0 = iter_11_1
				
				break
			end
		end
		
		if arg_10_0.onGestureZoom and get_cocos_refid(arg_11_1[1]) and get_cocos_refid(arg_11_1[2]) then
			local var_11_1 = arg_11_1[1]:getStartLocationInView()
			local var_11_2 = arg_11_1[1]:getLocationInView()
			local var_11_3 = arg_11_1[2]:getStartLocationInView()
			local var_11_4 = arg_11_1[2]:getLocationInView()
			local var_11_5 = math.sqrt(math.pow(var_11_3.x - var_11_1.x, 2) + math.pow(var_11_3.y - var_11_1.y, 2))
			local var_11_6 = math.sqrt(math.pow(var_11_4.x - var_11_2.x, 2) + math.pow(var_11_4.y - var_11_2.y, 2))
			local var_11_7 = arg_11_1[1]:getLocation()
			local var_11_8 = arg_11_1[2]:getLocation()
			local var_11_9 = {
				x = (var_11_7.x + var_11_8.x) * 0.5,
				y = (var_11_7.y + var_11_8.y) * 0.5
			}
			
			arg_10_0:onGestureZoom(arg_10_0.vars._gestureFactor or var_11_6, var_11_6, var_11_9)
			
			arg_10_0.vars._gestureFactor = var_11_6
		else
			arg_10_0.vars._gestureFactor = nil
			
			if var_11_0 then
				arg_10_0:touchEventHandler(var_11_0, arg_11_0)
			end
		end
	end
	
	TouchBlocker:pushBlockingScene(SceneManager:getCurrentSceneName(), function()
		return not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd)
	end)
	TouchBlocker:pushInterrupter(SceneManager:getCurrentSceneName(), function(arg_13_0, arg_13_1, arg_13_2)
		var_10_0(arg_13_1, arg_13_2)
	end)
	arg_10_0:addZoomMouseWheel()
end

function ArtiZoom.touchEventHandler(arg_14_0, arg_14_1, arg_14_2)
	if cc.EventCode.BEGAN == arg_14_2:getEventCode() then
		if arg_14_0.onTouchDown then
			arg_14_0:onTouchDown(arg_14_1, arg_14_2)
			
			return true
		end
	elseif cc.EventCode.MOVED == arg_14_2:getEventCode() then
		if arg_14_0.onTouchMove then
			arg_14_0:onTouchMove(arg_14_1, arg_14_2)
			
			return true
		end
	elseif cc.EventCode.ENDED == arg_14_2:getEventCode() then
		if arg_14_0.onTouchUp then
			arg_14_0:onTouchUp(arg_14_1, arg_14_2)
			
			return true
		end
	elseif cc.EventCode.CANCELLED == arg_14_2:getEventCode() and arg_14_0.onTouchCancelled then
		arg_14_0:onTouchCancelled(arg_14_1, arg_14_2)
		
		return true
	end
end

function ArtiZoom.addZoomMouseWheel(arg_15_0)
	if not arg_15_0.vars or PLATFORM ~= "win32" then
		return 
	end
	
	local var_15_0 = SceneManager:getCurrentScene()
	
	if var_15_0 and var_15_0.layer then
		local var_15_1 = var_15_0.layer:getEventDispatcher()
		
		arg_15_0._zoom_listener = cc.EventListenerMouse:create()
		
		arg_15_0._zoom_listener:registerScriptHandler(function(arg_16_0, arg_16_1)
			ArtiZoom:onMouseWheel(arg_16_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_15_1:addEventListenerWithSceneGraphPriority(arg_15_0._zoom_listener, var_15_0.layer)
	end
end

function ArtiZoom.removeEventListener(arg_17_0)
	if not arg_17_0._zoom_listener then
		return 
	end
	
	if PLATFORM == "win32" then
		cc.Director:getInstance():getEventDispatcher():removeEventListener(arg_17_0._zoom_listener)
		
		arg_17_0._zoom_listener = nil
		arg_17_0._touch_listener = nil
	end
end

function ArtiZoom.setZoomNode(arg_18_0)
	arg_18_0.vars.mode = "Portrait"
	
	if arg_18_0.vars.zoom_cont then
		arg_18_0.vars.zoom_cont:detachZoomNode()
	end
	
	local var_18_0 = arg_18_0.vars.arti_node:getContentSize()
	local var_18_1 = var_18_0.width + (VIEW_WIDTH / 2 + VIEW_BASE_LEFT) + 28.5
	local var_18_2 = var_18_0.height / 2 + 59.25
	
	arg_18_0.vars.arti_node:setPosition(var_18_1, var_18_2)
	
	arg_18_0.vars.zoom_cont = ZoomController({
		rotate = -90,
		scale = 1.55,
		layer = arg_18_0.vars.arti_node
	})
	
	arg_18_0.vars.zoom_cont.pivot:setLocalZOrder(-99999)
end

function ArtiZoom.updateAxisUI(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	local var_19_0 = (arg_19_1 or arg_19_0.vars.mode) == "Portrait"
	
	if_set_visible(arg_19_0.vars.wnd, "n_horizontal", not var_19_0)
	if_set_visible(arg_19_0.vars.wnd, "n_vertical", var_19_0)
end

function ArtiZoom.onTouchUp(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	return arg_20_0.vars.zoom_cont:onTouchUp(arg_20_1, arg_20_2)
end

function ArtiZoom.uiEnableAction(arg_21_0)
	if not TopBarNew.vars or not get_cocos_refid(TopBarNew.vars.top_left) then
		return 
	end
	
	local var_21_0 = TopBarNew.vars.top_left:getChildByName("TOP_LEFT")
	
	if get_cocos_refid(var_21_0) then
		local function var_21_1()
			arg_21_0.vars.ui_enable = true
		end
		
		local function var_21_2()
			arg_21_0.vars.ui_enable = false
		end
		
		UIAction:Add(SEQ(FADE_IN(arg_21_0.fade_time), DELAY(arg_21_0.ui_hide_delay), FADE_OUT(arg_21_0.fade_time)), var_21_0, "ui_show_hide")
		arg_21_0.vars.wnd:setVisible(true)
		
		local function var_21_3(arg_24_0)
			UIAction:Add(SEQ(SHOW(true), FADE_IN(arg_21_0.fade_time), CALL(var_21_1), DELAY(arg_21_0.ui_hide_delay), CALL(var_21_2), FADE_OUT(arg_21_0.fade_time), SHOW(false)), arg_24_0, "ui_show_hide_2")
		end
		
		var_21_3(arg_21_0.vars.wnd:findChildByName("n_left"))
		var_21_3(arg_21_0.vars.wnd:findChildByName("n_right"))
	end
end

function ArtiZoom.onTouchDown(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	if not UIAction:Find("ui_show_hide") then
		arg_25_0:uiEnableAction()
	end
	
	set_high_fps_tick()
	
	return arg_25_0.vars.zoom_cont:onTouchDown(arg_25_1, arg_25_2)
end

function ArtiZoom.onTouchMove(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	set_high_fps_tick()
	
	return arg_26_0.vars.zoom_cont:onTouchMove(arg_26_1, arg_26_2)
end

function ArtiZoom.onGestureZoom(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	set_high_fps_tick()
	arg_27_0.vars.zoom_cont:onGestureZoom(arg_27_1, arg_27_2, arg_27_3)
end

function ArtiZoom.onMouseWheel(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	set_high_fps_tick()
	arg_28_0.vars.zoom_cont:onMouseWheel(arg_28_1)
end
