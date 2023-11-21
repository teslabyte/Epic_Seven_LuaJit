local var_0_0 = 10

if not Scene then
	Scene = {}
end

if not SceneHandler then
	SceneHandler = {}
end

if not SceneManager then
	SceneManager = {}
	SceneManager._scenes = {}
	SceneManager._sceneFlow = {}
end

function SceneHandler.create(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = SceneManager:getRegisteredScene(arg_1_1)
	
	copy_functions(SceneHandler, var_1_0)
	SceneManager:registerScene(arg_1_1, var_1_0)
	
	var_1_0._name = arg_1_1
	
	local var_1_1 = cc.Director:getInstance():getWinSize()
	
	var_1_0._winSize = var_1_1
	var_1_0._contentSize = {
		width = arg_1_2 or var_1_1.width,
		height = arg_1_3 or var_1_1.height
	}
	
	return var_1_0
end

function SceneHandler.resetBlocker(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1:findChildByName("_letter_box_blocker")
	
	if get_cocos_refid(var_2_0) then
		local var_2_1 = arg_2_1:getContentSize()
		
		var_2_0:setContentSize(var_2_1.width, var_2_1.height)
	end
end

function SceneHandler.resetLetterBox(arg_3_0)
	if not arg_3_0.letterBox then
		return 
	end
	
	if SCREEN_WIDTH / SCREEN_HEIGHT > DESIGN_WIDTH / DESIGN_HEIGHT then
		local var_3_0 = (SCREEN_WIDTH - DESIGN_WIDTH) / 2
		
		arg_3_0.letterBox[1]:setPosition(0 + VIEW_BASE_LEFT - var_3_0, 0)
		arg_3_0.letterBox[1]:setContentSize({
			width = var_3_0 * 2,
			height = SCREEN_HEIGHT
		})
		arg_3_0.letterBox[2]:setPosition(SCREEN_WIDTH - (SCREEN_WIDTH - VIEW_WIDTH) / 2, 0)
		arg_3_0.letterBox[2]:setContentSize({
			width = var_3_0 * 2,
			height = SCREEN_HEIGHT
		})
		arg_3_0:resetBlocker(arg_3_0.letterBox[1])
		arg_3_0:resetBlocker(arg_3_0.letterBox[2])
	else
		local var_3_1 = (SCREEN_HEIGHT - DESIGN_HEIGHT) / 2
		
		arg_3_0.letterBox[1]:setPosition(0, var_3_1 + DESIGN_HEIGHT)
		arg_3_0.letterBox[1]:setContentSize({
			width = SCREEN_WIDTH,
			height = var_3_1
		})
		arg_3_0.letterBox[2]:setPosition(0, 0)
		arg_3_0.letterBox[2]:setContentSize({
			width = SCREEN_WIDTH,
			height = var_3_1
		})
		arg_3_0:resetBlocker(arg_3_0.letterBox[1])
		arg_3_0:resetBlocker(arg_3_0.letterBox[2])
	end
	
	arg_3_0.letterBox[1]:setLocalZOrder(10)
	arg_3_0.letterBox[2]:setLocalZOrder(10)
end

function SceneHandler.createLetterBoxBlockerButton(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = ccui.Button:create()
	
	var_4_0:setName("_letter_box_blocker")
	var_4_0:setAnchorPoint(arg_4_2, arg_4_3)
	var_4_0:ignoreContentAdaptWithSize(false)
	arg_4_1:addChild(var_4_0)
end

function SceneHandler.addLetterBoxSprite(arg_5_0)
	if arg_5_0._in_background then
		arg_5_0._letter_box_dirty = true
		
		return 
	end
	
	arg_5_0._letter_box_dirty = nil
	
	if HEIGHT_MARGIN > 0 then
		local var_5_0 = cc.Sprite:create("img/ipda_bg_t.png")
		local var_5_1 = cc.Sprite:create("img/ipda_bg_b.png")
		
		if var_5_0 and var_5_1 then
			var_5_0:setAnchorPoint(0, 0)
			var_5_1:setAnchorPoint(0, 1)
			var_5_1:setPositionY(HEIGHT_MARGIN / 2)
			arg_5_0.letterBox[1]:addChild(var_5_0)
			arg_5_0.letterBox[2]:addChild(var_5_1)
		end
	end
end

function SceneHandler.createLetterBox(arg_6_0)
	if arg_6_0.letterBox then
		for iter_6_0, iter_6_1 in pairs(arg_6_0.letterBox) do
			if get_cocos_refid(iter_6_1) then
				iter_6_1:removeFromParent()
			end
		end
	end
	
	local var_6_0 = SCREEN_WIDTH > VIEW_WIDTH or SCREEN_HEIGHT > DESIGN_HEIGHT
	
	if arg_6_0:getName() == "title" then
		var_6_0 = false
	end
	
	if var_6_0 then
		arg_6_0.letterBox = {
			cc.LayerColor:create(cc.c4b(20, 20, 20, 255)),
			cc.LayerColor:create(cc.c4b(20, 20, 20, 255))
		}
		
		arg_6_0:createLetterBoxBlockerButton(arg_6_0.letterBox[1], 0, 0)
		arg_6_0:createLetterBoxBlockerButton(arg_6_0.letterBox[2], 0, 0)
		arg_6_0:resetLetterBox()
		arg_6_0.lboxScene:addChild(arg_6_0.letterBox[1])
		arg_6_0.lboxScene:addChild(arg_6_0.letterBox[2])
		arg_6_0:addLetterBoxSprite()
	end
end

function SceneHandler.init(arg_7_0, arg_7_1)
	local var_7_0 = cc.Director:getInstance():getWinSize()
	
	arg_7_0.layer = nil
	arg_7_0.transitionClass = nil
	arg_7_0.transitionDuration = nil
	arg_7_0.transitionArguments = nil
	arg_7_0.errorCounter = {}
	arg_7_0.touches = {}
	arg_7_0.nativeScene = cc.Node:create()
	
	arg_7_0.nativeScene:setName("nativeScene")
	arg_7_0.nativeScene:setAnchorPoint(0, 0)
	arg_7_0.nativeScene:setContentSize(arg_7_0:getContentSize())
	
	arg_7_0.uiScene = cc.Node:create()
	
	arg_7_0.uiScene:setName("uiScene")
	arg_7_0.uiScene:setAnchorPoint(0, 0)
	arg_7_0.uiScene:setContentSize(arg_7_0:getContentSize())
	arg_7_0.uiScene:setCascadeOpacityEnabled(true)
	
	arg_7_0.popupScene = cc.Node:create()
	
	arg_7_0.popupScene:setName("popupScene")
	arg_7_0.popupScene:setAnchorPoint(0, 0)
	arg_7_0.popupScene:setContentSize(arg_7_0:getContentSize())
	arg_7_0.popupScene:setCascadeOpacityEnabled(true)
	
	arg_7_0.rootScene = cc.Layer:create()
	
	arg_7_0.rootScene:setName("rootScene")
	
	arg_7_0.uiRootScene = cc.Layer:create()
	
	arg_7_0.uiRootScene:setName("uiRootScene")
	arg_7_0.uiRootScene:setCascadeOpacityEnabled(true)
	
	arg_7_0.lboxScene = cc.Layer:create()
	
	arg_7_0.lboxScene:setName("lboxScene")
	
	local var_7_1 = (var_7_0.width - arg_7_0:getContentSize().width) / 2
	local var_7_2 = (var_7_0.height - arg_7_0:getContentSize().height) / 2
	
	arg_7_0.nativeScene:setPosition(var_7_1, var_7_2)
	arg_7_0.uiScene:setPosition(var_7_1, var_7_2)
	arg_7_0.popupScene:setPosition(var_7_1, var_7_2)
	arg_7_0:createLetterBox()
	arg_7_0.lboxScene:retain()
	arg_7_0.rootScene:addChild(arg_7_0.nativeScene)
	arg_7_0.rootScene:addChild(arg_7_0.uiRootScene)
	arg_7_0.uiRootScene:addChild(arg_7_0.uiScene)
	arg_7_0.uiRootScene:addChild(arg_7_0.popupScene)
	
	arg_7_0.collector = cc.Node:create()
	
	arg_7_0.collector:setName("collector")
	arg_7_0.collector:setVisible(false)
	arg_7_0.rootScene:addChild(arg_7_0.collector)
	arg_7_0.rootScene:retain()
	
	arg_7_0._scene_args = arg_7_1
	
	NotchManager:init()
	
	arg_7_0.isAbsent = false
	arg_7_0.touchEventTime = os.time()
	
	arg_7_0:changeAbsentTime(tonumber(getenv("absent.time") or 15))
	LuaEventDispatcher:dispatchEvent("invite.event", "reload")
end

function SceneHandler.showLetterBox(arg_8_0, arg_8_1)
	if not arg_8_0.letterBox or not get_cocos_refid(arg_8_0.letterBox[1]) or not get_cocos_refid(arg_8_0.letterBox[2]) then
		return 
	end
	
	arg_8_0.letterBox[1]:setVisible(arg_8_1)
	arg_8_0.letterBox[2]:setVisible(arg_8_1)
end

function SceneHandler.getName(arg_9_0)
	return arg_9_0._name
end

function SceneHandler.clear(arg_10_0)
	arg_10_0._ext_handler = nil
	
	arg_10_0.nativeScene:removeAllChildren()
	arg_10_0.uiScene:removeAllChildren()
	arg_10_0.popupScene:removeAllChildren()
end

function SceneHandler.getContentSize(arg_11_0)
	return arg_11_0._contentSize
end

function SceneHandler.getSceneArgs(arg_12_0)
	return arg_12_0._scene_args
end

function SceneHandler.clearSceneArgs(arg_13_0)
	arg_13_0._scene_args = nil
end

function SceneHandler.setTransition(arg_14_0, arg_14_1, arg_14_2, ...)
	arg_14_0.transitionClass = arg_14_1
	arg_14_0.transitionDuration = arg_14_2
	arg_14_0.transitionArguments = {
		...
	}
	
	if arg_14_0._scene_args then
		return argument_unpack(arg_14_0._scene_args)
	end
	
	return nil
end

function SceneHandler.evcall(arg_15_0, arg_15_1, ...)
	if arg_15_0.errorCounter[arg_15_1] and arg_15_0.errorCounter[arg_15_1] > var_0_0 then
		return false
	end
	
	local var_15_0, var_15_1 = xpcall(arg_15_1, __G__TRACKBACK__, arg_15_0, ...)
	
	if not var_15_0 then
		arg_15_0.errorCounter[arg_15_1] = (arg_15_0.errorCounter[arg_15_1] or 1) + 1
		
		return false
	end
	
	arg_15_0.errorCounter[arg_15_1] = nil
	
	return var_15_1
end

function SceneHandler.load(arg_16_0)
	if arg_16_0.onLoad and arg_16_0:evcall(arg_16_0.onLoad, arg_16_0:getSceneArgs()) == false then
		return false
	end
	
	if not arg_16_0.layer then
		arg_16_0.layer = cc.Layer:create()
	end
	
	if not arg_16_0.layer:getParent() then
		arg_16_0.nativeScene:addChild(arg_16_0.layer)
	end
	
	arg_16_0._device_orientation = getenv("device.orientation")
	
	if PLATFORM == "win32" then
		arg_16_0._device_orientation = "landscape_left"
	end
end

function SceneHandler.enter(arg_17_0)
	set_high_fps_tick()
	
	arg_17_0.touchEventTime = os.time()
	
	if arg_17_0.onEnter then
		arg_17_0:evcall(arg_17_0.onEnter)
	end
end

function SceneHandler.enterFinished(arg_18_0)
	if arg_18_0.onEnterFinished then
		arg_18_0:evcall(arg_18_0.onEnterFinished)
	end
end

function SceneHandler.leave(arg_19_0)
	if arg_19_0.onLeave then
		arg_19_0:evcall(arg_19_0.onLeave)
	end
end

function SceneHandler.unload(arg_20_0)
	if arg_20_0.onUnload then
		arg_20_0:evcall(arg_20_0.onUnload)
	end
end

function SceneHandler.preDestroy(arg_21_0)
	if arg_21_0.onPreDestroy then
		arg_21_0:evcall(arg_21_0.onPreDestroy)
	end
end

function SceneHandler.destroy(arg_22_0)
	if get_cocos_refid(arg_22_0.lboxScene) then
		arg_22_0.lboxScene:release()
	end
	
	arg_22_0.lboxScene = nil
	
	if get_cocos_refid(arg_22_0.rootScene) then
		arg_22_0.rootScene:release()
	end
	
	arg_22_0.rootScene = nil
	arg_22_0.uiScene = nil
	arg_22_0.popupScene = nil
	arg_22_0.nativeScene = nil
	arg_22_0._ext_handler = nil
end

function SceneHandler.setTouchHandler(arg_23_0, arg_23_1, arg_23_2)
	if not get_cocos_refid(arg_23_1) then
		return 
	end
	
	if not arg_23_0._touchHandler then
		arg_23_0._touchHandler = {}
	end
	
	if type(arg_23_2) == "function" then
		arg_23_0._touchHandler[arg_23_1] = {
			onTouchDown = arg_23_2,
			onTouchUp = arg_23_2,
			onTouchCancelled = arg_23_2
		}
	elseif type(arg_23_2) == "table" or type(arg_23_2) == "userdata" then
		arg_23_0._touchHandler[arg_23_1] = arg_23_2
	end
end

function SceneHandler.unsetTouchHandler(arg_24_0, arg_24_1)
	if not arg_24_0._touchHandler then
		return 
	end
	
	arg_24_0._touchHandler[arg_24_1] = nil
end

function SceneHandler.fireControlTouchEvent(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if not arg_25_0._touchHandler then
		return 
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0._touchHandler) do
		if not get_cocos_refid(iter_25_0) then
			arg_25_0._touchHandler[iter_25_0] = nil
		else
			local var_25_0 = iter_25_1[arg_25_1]
			
			if var_25_0 then
				local var_25_1 = arg_25_2:getLocation()
				
				if cc.EventCode.BEGAN ~= arg_25_3:getEventCode() or checkCollision(iter_25_0, var_25_1.x, var_25_1.y) then
					xpcall(var_25_0, __G__TRACKBACK__, iter_25_0, arg_25_2, arg_25_3)
				end
			end
		end
	end
end

function SceneHandler.fireTouchEvent(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if NetWaiting:isWaiting() == true then
		print("fireTouchEvent SKIPPED - NetWaiting:isWaiting()")
		
		return 
	end
	
	arg_26_2.sender = arg_26_0
	
	local var_26_0 = arg_26_2:getCurrentTarget()
	
	if get_cocos_refid(var_26_0) and not var_26_0:isVisible() then
		return 
	end
	
	if cc.EventCode.BEGAN == arg_26_2:getEventCode() then
		arg_26_0:fireControlTouchEvent("onTouchDown", arg_26_1, arg_26_2)
		
		if arg_26_0.onTouchDown then
			arg_26_0:onTouchDown(arg_26_1, arg_26_2)
			
			return true
		end
	elseif cc.EventCode.MOVED == arg_26_2:getEventCode() then
		arg_26_0:fireControlTouchEvent("onTouchMove", arg_26_1, arg_26_2)
		
		if arg_26_0.onTouchMove then
			arg_26_0:onTouchMove(arg_26_1, arg_26_2)
			
			return true
		end
	elseif cc.EventCode.ENDED == arg_26_2:getEventCode() then
		arg_26_0:fireControlTouchEvent("onTouchUp", arg_26_1, arg_26_2)
		
		if arg_26_0.onTouchUp then
			arg_26_0:onTouchUp(arg_26_1, arg_26_2)
			
			return true
		end
	elseif cc.EventCode.CANCELLED == arg_26_2:getEventCode() then
		arg_26_0:fireControlTouchEvent("onTouchCancelled", arg_26_1, arg_26_2)
		
		if arg_26_0.onTouchCancelled then
			arg_26_0:onTouchCancelled(arg_26_1, arg_26_2)
			
			return true
		end
	end
end

function SceneHandler.deActiveTouchHandler(arg_27_0)
	if not get_cocos_refid(arg_27_0.nativeScene) then
		return 
	end
	
	arg_27_0.nativeScene:getEventDispatcher():removeEventListenersForTarget(arg_27_0.nativeScene, true)
end

function SceneHandler.activeTouchHandler(arg_28_0)
	if not get_cocos_refid(arg_28_0.nativeScene) then
		return 
	end
	
	local var_28_0 = arg_28_0.nativeScene:getEventDispatcher()
	local var_28_1 = arg_28_0["--touch_all_by_one_listener"]
	
	if get_cocos_refid(var_28_1) then
		var_28_0:removeEventListener(var_28_1)
	end
	
	local var_28_2 = cc.EventListenerTouchAllAtOnce:create()
	
	arg_28_0["--touch_all_by_one_listener"] = var_28_2
	
	local function var_28_3(arg_29_0, arg_29_1)
		if not PRODUCTION_MODE and #arg_29_0 > 2 and type(DebugConsole.show) == "function" then
			DebugConsole:show()
		end
		
		local var_29_0
		
		for iter_29_0, iter_29_1 in pairs(arg_29_0) do
			arg_28_0.touches[iter_29_1:getId() + 1] = iter_29_1
			
			if iter_29_1:getId() == 0 then
				var_29_0 = iter_29_1
				
				break
			end
		end
		
		arg_28_0:updateTouchEventTime()
		
		if TouchBlocker:isBlockingScene(arg_28_0._name, var_29_0, arg_29_1, true, arg_28_0.touches) then
			return 
		end
		
		if arg_28_0.onGestureZoom and get_cocos_refid(arg_28_0.touches[1]) and get_cocos_refid(arg_28_0.touches[2]) then
			local var_29_1 = arg_28_0.touches[1]:getStartLocationInView()
			local var_29_2 = arg_28_0.touches[1]:getLocationInView()
			local var_29_3 = arg_28_0.touches[2]:getStartLocationInView()
			local var_29_4 = arg_28_0.touches[2]:getLocationInView()
			
			if arg_29_1:getEventCode() == cc.EventCode.MOVED then
				local var_29_5 = math.sqrt(math.pow(var_29_3.x - var_29_1.x, 2) + math.pow(var_29_3.y - var_29_1.y, 2))
				local var_29_6 = math.sqrt(math.pow(var_29_4.x - var_29_2.x, 2) + math.pow(var_29_4.y - var_29_2.y, 2))
				local var_29_7 = arg_28_0.touches[1]:getLocation()
				local var_29_8 = arg_28_0.touches[2]:getLocation()
				local var_29_9 = {
					x = (var_29_7.x + var_29_8.x) * 0.5,
					y = (var_29_7.y + var_29_8.y) * 0.5
				}
				
				arg_28_0:onGestureZoom(arg_28_0._gestureFactor or var_29_6, var_29_6, var_29_9)
				
				arg_28_0._gestureFactor = var_29_6
			end
		else
			arg_28_0._gestureFactor = nil
			
			if var_29_0 then
				arg_28_0:fireTouchEvent(var_29_0, arg_29_1)
			end
		end
	end
	
	var_28_2:registerScriptHandler(var_28_3, cc.Handler.EVENT_TOUCHES_BEGAN)
	var_28_2:registerScriptHandler(var_28_3, cc.Handler.EVENT_TOUCHES_MOVED)
	var_28_2:registerScriptHandler(var_28_3, cc.Handler.EVENT_TOUCHES_ENDED)
	var_28_2:registerScriptHandler(var_28_3, cc.Handler.EVENT_TOUCHES_CANCELLED)
	var_28_0:addEventListenerWithSceneGraphPriority(var_28_2, arg_28_0.nativeScene)
end

function SceneHandler.reload(arg_30_0)
	if arg_30_0.onReload then
		return arg_30_0:onReload()
	end
end

function SceneHandler.afterUpdate(arg_31_0)
	if arg_31_0.onAfterUpdate then
		arg_31_0:evcall(arg_31_0.onAfterUpdate)
	end
	
	if arg_31_0._ext_handler then
		for iter_31_0, iter_31_1 in ipairs(arg_31_0._ext_handler) do
			if iter_31_1.onAfterUpdate then
				xpcall(iter_31_1.onAfterUpdate, __G__TRACKBACK__, iter_31_1)
			end
		end
	end
	
	if NotchManager then
		NotchManager:event()
	end
end

function SceneHandler.beforeDraw(arg_32_0)
	if arg_32_0.onbeforeDraw then
		arg_32_0:evcall(arg_32_0.onbeforeDraw)
	end
	
	if arg_32_0._ext_handler then
		for iter_32_0, iter_32_1 in ipairs(arg_32_0._ext_handler) do
			if iter_32_1.onbeforeDraw then
				xpcall(iter_32_1.onbeforeDraw, __G__TRACKBACK__, iter_32_1)
			end
		end
	end
end

function SceneHandler.afterDraw(arg_33_0)
	if arg_33_0.onAfterDraw then
		arg_33_0:evcall(arg_33_0.onAfterDraw)
	end
	
	if arg_33_0._ext_handler then
		for iter_33_0, iter_33_1 in ipairs(arg_33_0._ext_handler) do
			if iter_33_1.onAfterDraw then
				xpcall(iter_33_1.onAfterDraw, __G__TRACKBACK__, iter_33_1)
			end
		end
	end
	
	if arg_33_0.onAbsent and not arg_33_0.isAbsent and os.time() - arg_33_0.touchEventTime > arg_33_0.absentTime then
		arg_33_0:evcall(arg_33_0.onAbsent)
		
		arg_33_0.isAbsent = true
	end
end

function SceneHandler.completeDraw(arg_34_0)
	if arg_34_0.onCompleteDraw then
		arg_34_0:evcall(arg_34_0.onCompleteDraw)
	end
	
	if arg_34_0._ext_handler then
		for iter_34_0, iter_34_1 in ipairs(arg_34_0._ext_handler) do
			if iter_34_1.onCompleteDraw then
				xpcall(iter_34_1.onCompleteDraw, __G__TRACKBACK__, iter_34_1)
			end
		end
	end
end

function SceneHandler.appEnterBackground(arg_35_0)
	arg_35_0._in_background = true
	
	if arg_35_0.onAppBackground then
		arg_35_0:evcall(arg_35_0.onAppBackground)
	end
	
	if arg_35_0._ext_handler then
		for iter_35_0, iter_35_1 in ipairs(arg_35_0._ext_handler) do
			if iter_35_1.onAppBackground then
				xpcall(iter_35_1.onAppBackground, __G__TRACKBACK__, iter_35_1)
			end
		end
	end
end

function SceneHandler.appEnterForeground(arg_36_0)
	arg_36_0._in_background = false
	
	if arg_36_0.onAppForeground then
		arg_36_0:evcall(arg_36_0.onAppForeground)
	end
	
	if arg_36_0._ext_handler then
		for iter_36_0, iter_36_1 in ipairs(arg_36_0._ext_handler) do
			if iter_36_1.onAppForeground then
				xpcall(iter_36_1.onAppForeground, __G__TRACKBACK__, iter_36_1)
			end
		end
	end
	
	if arg_36_0._letter_box_dirty then
		arg_36_0:addLetterBoxSprite()
	end
end

function SceneHandler.addExtendHandler(arg_37_0, arg_37_1)
	arg_37_0._ext_handler = arg_37_0._ext_handler or {}
	
	table.insert(arg_37_0._ext_handler, arg_37_1)
end

function SceneHandler.removeExtendHandler(arg_38_0, arg_38_1)
	if not arg_38_0._ext_handler then
		return 
	end
	
	for iter_38_0 = #arg_38_0._ext_handler, 1, -1 do
		if arg_38_0._ext_handler[iter_38_0] == arg_38_1 then
			table.remove(arg_38_0._ext_handler, iter_38_0)
		end
	end
end

function SceneHandler.updateTouchEventTime(arg_39_0)
	arg_39_0.touchEventTime = os.time()
	
	if arg_39_0.onExist then
		local var_39_0 = SceneManager:getRunningUIRootScene()
		
		if arg_39_0.isAbsent then
			arg_39_0:evcall(arg_39_0.onExist)
			
			arg_39_0.isAbsent = false
		elseif UIAction:Find(var_39_0) == nil and (var_39_0:getOpacity() < 255 or not var_39_0:isVisible()) then
			var_39_0:setOpacity(255)
			var_39_0:setVisible(true)
		end
	end
end

function SceneHandler.changeAbsentTime(arg_40_0, arg_40_1)
	arg_40_0.absentTime = SAVE:getOptionData("option.view_mode", default_options.view_mode) and 31536000 or arg_40_1 or 15
end

function SceneManager.init(arg_41_0)
	arg_41_0._canNext = nil
end

function SceneManager.setCanNext(arg_42_0, arg_42_1)
	arg_42_0._canNext = arg_42_1
end

function SceneManager.getPrevSceneName(arg_43_0)
	return arg_43_0._prevSceneName
end

function SceneManager.getNextSceneName(arg_44_0)
	return arg_44_0._nextSceneName
end

function SceneManager.getCurrentSceneName(arg_45_0)
	if arg_45_0._current then
		return arg_45_0._current:getName()
	end
end

function SceneManager.getCurrentScene(arg_46_0)
	return arg_46_0._current
end

function SceneManager.getCurrentSceneTagInfo(arg_47_0)
	if arg_47_0._current and arg_47_0._current.getTagInfo then
		return arg_47_0._current:getTagInfo()
	end
end

function SceneManager.allocScene(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0._scenes[arg_48_1]
	
	if not var_48_0 then
		return 
	end
	
	local var_48_1 = {}
	
	for iter_48_0, iter_48_1 in pairs(var_48_0) do
		var_48_1[iter_48_0] = var_48_0[iter_48_0]
	end
	
	var_48_1._name = arg_48_1
	
	return var_48_1
end

function SceneManager.getRegisteredScene(arg_49_0, arg_49_1)
	return arg_49_0._scenes[arg_49_1] or {}
end

function SceneManager.registerScene(arg_50_0, arg_50_1, arg_50_2)
	arg_50_0._scenes[arg_50_1] = arg_50_2
end

function SceneManager.getRunningScene(arg_51_0)
	return arg_51_0._current
end

function SceneManager.getRunningRootScene(arg_52_0)
	if not arg_52_0._current then
		return 
	end
	
	return arg_52_0._current.rootScene
end

function SceneManager.getRunningNativeScene(arg_53_0)
	if not arg_53_0._current then
		return 
	end
	
	return arg_53_0._current.nativeScene
end

function SceneManager.getRunningUIRootScene(arg_54_0)
	if not arg_54_0._current then
		return 
	end
	
	return arg_54_0._current.uiRootScene
end

function SceneManager.getRunningUIScene(arg_55_0)
	if not arg_55_0._current then
		return 
	end
	
	return arg_55_0._current.uiScene
end

function SceneManager.getRunningPopupScene(arg_56_0, arg_56_1)
	if not arg_56_0._current then
		return 
	end
	
	local var_56_0 = {
		"lobby",
		"battle",
		"growth_guide",
		"class_change"
	}
	
	if arg_56_1 or table.find(var_56_0, arg_56_0._current:getName()) then
		return arg_56_0._current.popupScene
	end
	
	return arg_56_0._current.nativeScene
end

function SceneManager.getDefaultLayer(arg_57_0)
	if arg_57_0._current then
		return arg_57_0._current.layer
	end
end

function SceneManager.getRunningNodeCollector(arg_58_0)
	return arg_58_0._current.collector
end

function SceneManager.addChild(arg_59_0, arg_59_1, arg_59_2)
	if arg_59_0._current then
		arg_59_0._current.nativeScene:addChild(arg_59_1, arg_59_2 or 0)
	end
end

function SceneManager.getSceneState(arg_60_0, arg_60_1)
	if arg_60_1 and arg_60_1.getSceneState then
		return arg_60_1:getSceneState()
	end
	
	return {}
end

function SceneManager.reserveResetSceneFlow(arg_61_0)
	arg_61_0._reserved_reset_secene_flow = true
end

function SceneManager.cancelReseveResetSceneFlow(arg_62_0)
	arg_62_0._reserved_reset_secene_flow = nil
	
	arg_62_0:resetSceneFlow()
end

function SceneManager.resetSceneFlow(arg_63_0)
	arg_63_0._sceneFlow = {}
	
	table.push(arg_63_0._sceneFlow, {
		name = arg_63_0._current:getName()
	})
end

function SceneManager.initWithScene(arg_64_0, arg_64_1)
	print("initWithScene : ", arg_64_1)
	
	if arg_64_0._current then
		return 
	end
	
	local var_64_0 = arg_64_0:allocScene(arg_64_1)
	
	arg_64_0._current = var_64_0
	arg_64_0._cocosScene = cc.Director:getInstance():getRunningScene()
	arg_64_0._gameLayer = cc.Layer:create()
	arg_64_0._tranLayer = cc.Layer:create()
	arg_64_0._lboxLayer = cc.Layer:create()
	arg_64_0._touchLayer = cc.Layer:create()
	
	arg_64_0._gameLayer:setLocalZOrder(0)
	arg_64_0._tranLayer:setLocalZOrder(1)
	arg_64_0._lboxLayer:setLocalZOrder(2)
	arg_64_0._touchLayer:setLocalZOrder(999999)
	
	local var_64_1 = arg_64_0._cocosScene:getChildren()
	
	for iter_64_0, iter_64_1 in pairs(var_64_1) do
		if tolua.type(iter_64_1) ~= "cc.Camera" then
			iter_64_1:ejectFromParent()
			arg_64_0._gameLayer:addChild(iter_64_1)
		end
	end
	
	arg_64_0._cocosScene:addChild(arg_64_0._gameLayer)
	arg_64_0._cocosScene:addChild(arg_64_0._tranLayer)
	arg_64_0._cocosScene:addChild(arg_64_0._lboxLayer)
	arg_64_0._cocosScene:addChild(arg_64_0._touchLayer)
	arg_64_0:addTouchEffectListener(arg_64_0._touchLayer)
	arg_64_0:addMouseEventListener(arg_64_0._touchLayer)
	TransitionScreen:init(arg_64_0._tranLayer)
	SceneHandler.init(var_64_0)
	var_64_0:load()
	var_64_0:enter()
	var_64_0:activeTouchHandler()
	arg_64_0._gameLayer:addChild(var_64_0.rootScene)
	arg_64_0._lboxLayer:addChild(var_64_0.lboxScene)
end

function SceneManager.setEnabledTouchEffectListener(arg_65_0, arg_65_1)
	if not arg_65_0.touch_effect_listener then
		return 
	end
	
	arg_65_0.touch_effect_listener:setEnabled(arg_65_1)
end

function SceneManager.addTouchEffectListener(arg_66_0, arg_66_1)
	local function var_66_0(arg_67_0, arg_67_1)
		if TransitionScreen:isShow() or PAUSED then
			return 
		end
		
		EffectManager:Play({
			scale = 1,
			z = 99999,
			fn = "ui_touch_def.cfx",
			layer = arg_66_1,
			x = arg_67_0:getLocation().x,
			y = arg_67_0:getLocation().y
		})
	end
	
	local function var_66_1(arg_68_0, arg_68_1)
	end
	
	local function var_66_2(arg_69_0, arg_69_1)
	end
	
	local function var_66_3(arg_70_0, arg_70_1)
	end
	
	arg_66_0.touch_effect_listener = cc.EventListenerTouchOneByOne:create()
	
	local var_66_4 = arg_66_1:getEventDispatcher()
	
	arg_66_0.touch_effect_listener:setForceClaimed(true)
	arg_66_0.touch_effect_listener:registerScriptHandler(var_66_0, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_66_0.touch_effect_listener:registerScriptHandler(var_66_1, cc.Handler.EVENT_TOUCH_ENDED)
	arg_66_0.touch_effect_listener:registerScriptHandler(var_66_2, cc.Handler.EVENT_TOUCH_MOVED)
	arg_66_0.touch_effect_listener:registerScriptHandler(var_66_3, cc.Handler.EVENT_TOUCH_CANCELLED)
	var_66_4:addEventListenerWithSceneGraphPriority(arg_66_0.touch_effect_listener, arg_66_1)
	
	local var_66_5 = not SAVE:getOptionData("option.touch_off", false)
	
	arg_66_0:setEnabledTouchEffectListener(var_66_5)
end

function SceneManager.addMouseEventListener(arg_71_0, arg_71_1)
	if not PLATFORM == "win32" then
		return 
	end
	
	local var_71_0 = 20
	local var_71_1 = cc.Director:getInstance():getOpenGLView()
	
	listener = cc.EventListenerMouse:create()
	
	listener:registerScriptHandler(function(arg_72_0, arg_72_1)
		arg_71_0.scroll_start_time = systick()
		
		if not arg_71_0.scroll_start then
			arg_71_0.scroll_start = true
			arg_71_0.scroll_start_x = arg_72_0:getCursorX()
			arg_71_0.scroll_start_y = DEVICE_HEIGHT - arg_72_0:getCursorY()
			
			var_71_1:handleTouchBegin(arg_72_0:getCursorX(), arg_71_0.scroll_start_y)
			
			if UIAction:Find("scroll_action") then
				UIAction:Remove("scroll_action")
			end
			
			UIAction:Add(COND_LOOP(DELAY(10), function()
				if arg_71_0.scroll_start and (systick() - arg_71_0.scroll_start_time) / 1000 > 0.1 then
					arg_71_0.scroll_start = false
					
					cc.Director:getInstance():getOpenGLView():handleTouchEnd(arg_71_0.scroll_start_x, arg_71_0.scroll_start_y)
					
					return true
				end
			end), arg_71_1, "scroll_action")
		end
		
		if (systick() - arg_71_0.scroll_start_time) / 1000 < 0.1 then
			arg_71_0.scroll_start_y = arg_71_0.scroll_start_y - arg_72_0:getScrollY() * var_71_0
			
			var_71_1:handleTouchMove(arg_72_0:getCursorX(), arg_71_0.scroll_start_y)
		end
		
		return true
	end, cc.Handler.EVENT_MOUSE_SCROLL)
	arg_71_1:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, arg_71_1)
end

function SceneManager.getAlertLayer(arg_74_0)
	if not get_cocos_refid(arg_74_0._alertLayer) then
		local var_74_0 = cc.Director:getInstance():getRunningScene()
		
		arg_74_0._alertLayer = cc.Layer:create()
		
		arg_74_0._alertLayer:setLocalZOrder(3)
		arg_74_0._alertLayer:setPositionX((ORIGIN_VIEW_WIDTH - VIEW_WIDTH) / 2 - VIEW_BASE_LEFT)
		var_74_0:addChild(arg_74_0._alertLayer)
	end
	
	return arg_74_0._alertLayer
end

function SceneManager.addAlertControl(arg_75_0, arg_75_1)
	arg_75_0:getAlertLayer():addChild(arg_75_1)
end

function SceneManager.getPrevSceneName(arg_76_0)
	if #arg_76_0._sceneFlow < 1 then
		return nil
	end
	
	return arg_76_0._sceneFlow[#arg_76_0._sceneFlow].name
end

function SceneManager.getNextFlowSceneName(arg_77_0)
	if #arg_77_0._sceneFlow < 2 then
		return nil
	end
	
	return arg_77_0._sceneFlow[#arg_77_0._sceneFlow - 1].name
end

function SceneManager.popScene(arg_78_0, arg_78_1)
	print("SceneManager.popScene. #sceneFlow : ", #arg_78_0._sceneFlow)
	
	if arg_78_0._reserved_reset_secene_flow == true then
		arg_78_0._reserved_reset_secene_flow = nil
		
		arg_78_0:resetSceneFlow()
	end
	
	table.remove(arg_78_0._sceneFlow, #arg_78_0._sceneFlow)
	
	if #arg_78_0._sceneFlow == 0 then
		print("SceneManager #sceneFlow is 0. go to lobby")
		arg_78_0._current:deActiveTouchHandler()
		arg_78_0:_nextScene("lobby")
		
		return 
	end
	
	local var_78_0 = arg_78_0._sceneFlow[#arg_78_0._sceneFlow].name
	local var_78_1 = arg_78_0._sceneFlow[#arg_78_0._sceneFlow].scene_state or {}
	
	var_78_1.doAfterNextSceneLoaded = arg_78_1
	
	if var_78_1.ignore_flow then
		print("popScene - ignore flow : ", var_78_0)
		
		return arg_78_0:popScene()
	end
	
	arg_78_0._current:deActiveTouchHandler()
	arg_78_0:nextScene(var_78_0, var_78_1)
end

function SceneManager.getHistory(arg_79_0)
	return arg_79_0._history or {}
end

function SceneManager._addHistory(arg_80_0, arg_80_1, arg_80_2, arg_80_3)
	arg_80_0._history = arg_80_0._history or {}
	
	table.insert(arg_80_0._history, {
		success = arg_80_1,
		name = arg_80_2,
		time = os.date(),
		arg = arg_80_3
	})
	
	while #arg_80_0._history > 3 do
		table.remove(arg_80_0._history, 1)
	end
end

function SceneManager._nextScene(arg_81_0, arg_81_1, arg_81_2)
	UIUtil:onSceneChange()
	UIOption:clear()
	ConditionContentsManager:clearContents(arg_81_1)
	SoundEngine:stopAllAmbient()
	SoundEngine:clear()
	
	if arg_81_1 and arg_81_1 == "story_action" then
	else
		BackButtonManager:clear()
	end
	
	local function var_81_0(arg_82_0, arg_82_1, arg_82_2)
		if arg_82_1 == nil then
			return arg_82_0:popScene()
		end
		
		if arg_82_0._changeScene then
			print("[ERROR] Already running scene change")
			arg_82_0._changeScene:unload()
			arg_82_0._changeScene:destroy()
			
			arg_82_0._changeScene = nil
		end
		
		local var_82_0 = arg_82_0:allocScene(arg_82_1)
		
		if not var_82_0 then
			print("invalid scene name ", arg_82_1, debug.traceback())
			
			return false
		end
		
		arg_82_0._outScene = arg_82_0._current
		arg_82_0._current = var_82_0
		
		if Analytics.setCurScene and arg_82_0._outScene and arg_82_0._current then
			Analytics:setCurScene(arg_82_0._outScene:getName(), arg_82_0._current:getName(), arg_82_2)
		end
		
		SceneHandler.init(var_82_0, arg_82_2)
		arg_82_0._outScene:preDestroy()
		
		if var_82_0:load() == false then
			Log.e("SceneManager", "Scene Load Failed: " .. (arg_82_1 or ""))
			
			arg_82_0._current = arg_82_0._outScene
			arg_82_0._outScene = nil
			
			var_82_0:destroy()
			arg_82_0:_addHistory(false, arg_82_1, arg_82_2)
			TransitionScreen:hide()
			
			return false
		else
			arg_82_0:_addHistory(true, arg_82_1, arg_82_2)
		end
		
		if arg_82_0._outScene and #arg_82_0._sceneFlow > 0 then
			arg_82_0._sceneFlow[#arg_82_0._sceneFlow].scene_state = arg_82_0:getSceneState(arg_82_0._outScene)
		end
		
		if #arg_82_0._sceneFlow == 0 or arg_82_0._sceneFlow[#arg_82_0._sceneFlow].name ~= arg_82_1 then
			arg_82_0._sceneFlow[#arg_82_0._sceneFlow + 1] = {
				name = arg_82_1
			}
		end
		
		arg_82_0._changeScene = var_82_0
		
		if arg_82_0._outScene then
			arg_82_0._outScene:deActiveTouchHandler()
		end
		
		if arg_82_2 and arg_82_2.doAfterNextSceneLoaded then
			arg_82_2.doAfterNextSceneLoaded()
		end
	end
	
	print("SceneManager:nextScene(", arg_81_1, ")")
	
	if not arg_81_1 then
		Log.e("scene name is nil ", arg_81_1)
	end
	
	local var_81_1
	
	if arg_81_1 and arg_81_0._scenes[arg_81_1] and arg_81_0._scenes[arg_81_1].getTransitionColor then
		var_81_1 = arg_81_0._scenes[arg_81_1]:getTransitionColor()
	end
	
	if arg_81_0._current then
		arg_81_0._prevSceneName = arg_81_0._current:getName()
		arg_81_0._nextSceneName = arg_81_1
	end
	
	TransitionScreen:transition(bind_func(var_81_0, arg_81_0, arg_81_1, arg_81_2), var_81_1)
	
	if not MusicBox:isEnableScene(arg_81_1) and MusicBoxUI.vars then
		MusicBox:stop({
			is_disable_scene = true
		})
	end
	
	if MusicBoxUI:isShow() then
		MusicBoxUI:close()
	end
	
	return true
end

function SceneManager.checkChangeScene(arg_83_0)
	if arg_83_0._changeScene then
		local var_83_0 = arg_83_0._changeScene
		
		arg_83_0._changeScene = nil
		
		SceneManager:changeScene(var_83_0)
	end
end

function SceneManager.changeScene(arg_84_0, arg_84_1)
	if not arg_84_1 then
		return 
	end
	
	if arg_84_0._outScene then
		arg_84_0._pervScene = arg_84_0._outScene
		
		arg_84_0._outScene:leave()
		arg_84_0._outScene:unload()
		arg_84_0._outScene:destroy()
		
		arg_84_0._outScene = nil
	end
	
	arg_84_1:enter()
	arg_84_1:activeTouchHandler()
	
	if arg_84_0.onContentChangeScene then
		arg_84_0:onContentChangeScene()
	end
	
	local var_84_0 = cc.Director:getInstance()
	
	local function var_84_1(arg_85_0)
		if arg_85_0 == "enterTransitionFinish" then
			arg_84_0:removeUnusedCachedData()
			arg_84_1:enterFinished()
			print("scene:", arg_84_1:getName(), "enterFinished")
			TransitionScreen:hide(function()
				print("enter finish")
				LuaEventDispatcher:dispatchEvent("transion.finished")
			end)
		end
	end
	
	if not arg_84_1.rootScene then
		Log.e("SceneManager rootScene is nil")
		arg_84_0:nextScene("lobby")
		
		return 
	end
	
	arg_84_1.rootScene:registerScriptHandler(var_84_1)
	release_cocos_ref(arg_84_1.rootScene, 1)
	arg_84_0._gameLayer:removeAllChildren()
	arg_84_0._gameLayer:addChild(arg_84_1.rootScene)
	release_cocos_ref(arg_84_1.lboxScene, 1)
	arg_84_0._lboxLayer:removeAllChildren()
	arg_84_0._lboxLayer:addChild(arg_84_1.lboxScene)
	cc.DynamicAtlasCache:invalidateAll()
end

function SceneManager.checkCollect(arg_87_0)
end

function SceneManager.removeUnusedCachedData(arg_88_0)
	if get_cocos_refid(arg_88_0._alertLayer) then
		arg_88_0._alertLayer:removeAllChildren()
	end
	
	if purge_cache_db then
		purge_cache_db()
	end
	
	local var_88_0 = cc.FileUtils:getInstance()
	
	if var_88_0.purgeCachingFileData then
		var_88_0:purgeCachingFileData()
	end
	
	if var_88_0.purgeCachingValueData then
		var_88_0:purgeCachingValueData()
	end
	
	cc.Director:getInstance():removeUnusedCachedData()
	
	if sp.SkeletoneCache then
		sp.SkeletoneCache:getInstance():removeUnusedCachedData()
	end
	
	collectgarbage("collect")
end

function SceneManager.getContentSize(arg_89_0)
	if arg_89_0._current then
		arg_89_0._current:getContentSize()
	end
	
	return SceneHandler:getContentSize()
end

function SceneManager.setTouchHandler(arg_90_0, arg_90_1, arg_90_2)
	if arg_90_0._current then
		arg_90_0._current:setTouchHandler(arg_90_1, arg_90_2)
	end
end

function SceneManager.unsetTouchHandler(arg_91_0, arg_91_1)
	if arg_91_0._current then
		arg_91_0._current:unsetTouchHandler(arg_91_1)
	end
end

function SceneManager.convertLocation(arg_92_0, arg_92_1, arg_92_2)
	if arg_92_0._current then
		local var_92_0 = cc.Director:getInstance():getWinSize()
		local var_92_1 = arg_92_0._current:getContentSize()
		
		arg_92_1 = arg_92_1 - (var_92_0.width - var_92_1.width) / 2
		arg_92_2 = arg_92_2 - (var_92_0.height - var_92_1.height) / 2
		
		return arg_92_1, arg_92_2
	end
	
	return arg_92_1, arg_92_2
end

function SceneManager.convertToSceneSpace(arg_93_0, arg_93_1, arg_93_2)
	if arg_93_0._current and arg_93_0._current.nativeScene then
		local var_93_0 = arg_93_1:convertToWorldSpace(arg_93_2)
		
		return arg_93_0._current.nativeScene:convertToNodeSpace(var_93_0)
	end
	
	return arg_93_2
end

function SceneManager.dispatchGameEvent(arg_94_0, arg_94_1, arg_94_2)
	if arg_94_0._current.onGameEvent then
		arg_94_0._current.onGameEvent(arg_94_0._current, arg_94_1, arg_94_2)
	end
end

function SceneManager.reload(arg_95_0)
	if get_cocos_refid(arg_95_0._alertLayer) then
		arg_95_0._alertLayer:removeAllChildren()
	end
	
	if arg_95_0._current and not arg_95_0._current:reload() then
		arg_95_0:_nextScene(arg_95_0._current:getName(), arg_95_0._current:getSceneArgs())
	end
end

function SceneManager.doAfterUpdate(arg_96_0)
	arg_96_0:checkCollect()
	
	if arg_96_0._current then
		arg_96_0._current:afterUpdate()
	end
end

function SceneManager.doBeforeDraw(arg_97_0)
	if arg_97_0._current then
		arg_97_0._current:beforeDraw()
	end
end

function SceneManager.doAfterDraw(arg_98_0)
	arg_98_0:checkChangeScene()
	
	if arg_98_0._current then
		arg_98_0._current:afterDraw()
	end
end

function SceneManager.doCompleteDraw(arg_99_0)
	if arg_99_0._current then
		arg_99_0._current:completeDraw()
	end
end

function SceneManager.nextScene(arg_100_0, arg_100_1, arg_100_2)
	if arg_100_0._canNext and not arg_100_0._canNext(arg_100_1) then
		print("can not move to next scene!!!!", arg_100_1)
		
		return 
	end
	
	if g_UNIT_CONVIC and not table.empty(g_UNIT_CONVIC) then
		local var_100_0 = array_to_json(g_UNIT_CONVIC)
		
		query("convic_list", {
			convic = var_100_0
		})
		
		g_UNIT_CONVIC = {}
	end
	
	set_high_fps_tick()
	
	return arg_100_0:_nextScene(arg_100_1, arg_100_2)
end

function SceneManager.updateTouchEventTime(arg_101_0)
	if arg_101_0._current and arg_101_0._current.updateTouchEventTime then
		arg_101_0._current:updateTouchEventTime()
	end
end

function SceneManager.changeAbsentTime(arg_102_0, arg_102_1)
	if arg_102_0._current then
		arg_102_0._current:changeAbsentTime(arg_102_1)
	end
end

function SceneManager.isAbsent(arg_103_0)
	if arg_103_0._current then
		return arg_103_0._current.isAbsent
	end
end

function SceneManager.applicationDidEnterBackground(arg_104_0)
	if arg_104_0._current and arg_104_0._current.appEnterBackground then
		return arg_104_0._current:appEnterBackground()
	end
end

function SceneManager.applicationWillEnterForeground(arg_105_0)
	arg_105_0:updateTouchEventTime()
	
	if arg_105_0._current and arg_105_0._current.appEnterForeground then
		return arg_105_0._current:appEnterForeground()
	end
end
