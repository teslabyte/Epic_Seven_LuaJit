EVENT_FILTER = {}
EVENT_FILTER_TIME = 200

function screen_reload_event()
	print("screen_reload_event is_enable_minimal() : ", is_enable_minimal())
	
	if SceneManager:getCurrentSceneName() == "world_sub" or SceneManager:getCurrentSceneName() == "worldmap_scene" or SceneManager:getCurrentSceneName() == "world_custom" then
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	init_resolution_constanst()
	NotchStatus:settingNotch()
	reload_scene()
	NotchManager:event(true)
end

function change_resolution(arg_2_0, arg_2_1)
	cc.Director:getInstance():getOpenGLView():setFrameSize(arg_2_0, arg_2_1)
	screen_reload_event()
end

function reload_all(arg_3_0)
	if PLATFORM == "win32" then
		Scheduler:removeByName(MusicBox.MUSIC_BOX_ACTION_NAME)
	end
	
	if not PRODUCTION_MODE and PLATFORM == "win32" then
		CharPreviewData:_debug_remove_all()
	end
	
	if getenv("mascot.hazel.use") == "true" and MascotHazel then
		MascotHazel.UIManager:clearAllWindow()
	end
	
	local var_3_0 = SkillEffectFilterManager.vars
	
	reload_scripts()
	
	if var_3_0 then
		SkillEffectFilterManager.vars = var_3_0
	end
	
	init_game_static_variable()
	
	if PLATFORM == "win32" and Account and Account.units then
		for iter_3_0, iter_3_1 in pairs(Account.units) do
			UNIT.bindFunctions(iter_3_1)
			iter_3_1:bindGameDB(iter_3_1.inst.code, iter_3_1.inst.skin_code)
			iter_3_1:updateZodiacSkills()
			iter_3_1:reset()
		end
	end
	
	if PLATFORM == "win32" and Account and Account.pets then
		for iter_3_2, iter_3_3 in pairs(Account.pets) do
			PET.bindFunctions(iter_3_3)
			iter_3_3:bindGameDB(iter_3_3.inst.code)
		end
	end
	
	if not PRODUCTION_MODE and PLATFORM == "win32" then
		local var_3_1 = getenv("app.api"):sub(1, 15)
		
		if var_3_1 == "msg://localhost" or var_3_1 == "msg://127.0.0.1" then
			query("server_lua_reload", {})
		end
	end
	
	Account:updateUnitHPs()
	Action:RemoveAll()
	BattleAction:RemoveAll()
	StoryAction:RemoveAll()
	UIAction:RemoveAll()
	reload_db()
	NetWaiting:clear()
	MatchService:clear()
	ArenaService:clear()
	DummyService:clear()
	BackPlayManager:clear()
	ConditionContentsManager:resetAllAdd()
	print("Reloaded")
	resume()
	setenv("time_scale", 1)
	SceneManager:removeUnusedCachedData()
	
	local var_3_2 = cc.FileUtils:getInstance()
	
	if var_3_2.purgeCachingFileData then
		var_3_2:purgeCachingFileData()
	end
	
	if var_3_2.purgeCachingValueData then
		var_3_2:purgeCachingValueData()
	end
	
	local var_3_3 = SceneManager:getCurrentSceneName()
	
	if arg_3_0 and var_3_3 ~= "title" then
		init_resolution_constanst()
		SceneManager:nextScene("lobby")
	else
		SceneManager:reload()
		
		if var_3_3 == "logic" then
			re_enter()
		end
	end
	
	if Account.units then
		for iter_3_4, iter_3_5 in pairs(Account.units) do
			iter_3_5:bindFunctions()
		end
	end
	
	TouchBlocker:clear()
end

function reload_master_sound()
	SoundEngine:unloadAll()
	
	for iter_4_0 = 1, 99 do
		local var_4_0 = DBN("sound_bank", iter_4_0, {
			"bank_path"
		})
		
		if not var_4_0 then
			break
		end
		
		print("load bank ", var_4_0, SoundEngine:loadBankFile(var_4_0))
	end
end

function reset_patch(arg_5_0)
	arg_5_0 = arg_5_0 or {
		"media"
	}
	
	if patchpack_rawget and patchpack_rawset then
		local var_5_0 = patchpack_rawget("@patch.attributes")
		
		print("get packattr :", tostring(var_5_0))
		
		if var_5_0 then
			local var_5_1 = string.split(var_5_0, ",")
			
			if var_5_1 then
				for iter_5_0, iter_5_1 in pairs(var_5_1) do
					for iter_5_2, iter_5_3 in pairs(arg_5_0) do
						if string.find(iter_5_1, iter_5_3) then
							var_5_1[iter_5_0] = nil
						end
					end
				end
				
				local var_5_2
				
				for iter_5_4, iter_5_5 in pairs(var_5_1) do
					if not var_5_2 then
						var_5_2 = iter_5_5
					else
						var_5_2 = var_5_2 .. "," .. iter_5_5
					end
				end
				
				print("set packattr :", tostring(var_5_2))
				
				if var_5_2 then
					patchpack_rawset("@patch.attributes", var_5_2)
				end
			end
		end
	end
end

function reg_touch_blocker(arg_6_0, arg_6_1)
	local function var_6_0(arg_7_0, arg_7_1)
		arg_7_1:stopPropagation()
		
		return true
	end
	
	local var_6_1 = cc.EventListenerTouchOneByOne:create()
	local var_6_2 = arg_6_0:getEventDispatcher()
	
	var_6_1:registerScriptHandler(var_6_0, cc.Handler.EVENT_TOUCH_BEGAN)
	var_6_2:addEventListenerWithSceneGraphPriority(var_6_1, arg_6_1)
end

function reg_keyboard_handler(arg_8_0)
	do return  end
	
	local function var_8_0(arg_9_0)
		if INPUT_HANDLER.onKeyDown ~= nil then
			INPUT_HANDLER:onKeyDown(arg_9_0)
		end
	end
	
	local var_8_1 = cc.EventListenerKeyboard:create()
	local var_8_2 = arg_8_0:getEventDispatcher()
	
	var_8_1:registerScriptHandler(var_8_0, cc.Handler.EVENT_KEYBOARD_PRESSED)
	var_8_2:addEventListenerWithSceneGraphPriority(var_8_1, arg_8_0)
end

function set_input_handler(arg_10_0)
	TOUCHED_INPUT_HANDLER = nil
	
	if arg_10_0 == nil then
		arg_10_0 = {}
	end
	
	INPUT_HANDLER = arg_10_0
	INPUT_HANDLER.TOUCHED = false
end

function reg_touch_handler(arg_11_0)
	function _onTouchDown(arg_12_0, arg_12_1)
		set_high_fps_tick()
		
		if INPUT_HANDLER.TOUCHED then
			return true
		end
		
		INPUT_HANDLER.TOUCHED = true
		TOUCHED_INPUT_HANDLER = INPUT_HANDLER
		
		local var_12_0 = arg_12_0:getLocation()
		
		if Dialog:onTouchDown(var_12_0.x, var_12_0.y) then
			arg_12_1:stopPropagation()
			
			return true
		end
		
		if INPUT_HANDLER.onTouchDown then
			INPUT_HANDLER:onTouchDown(var_12_0.x, var_12_0.y, arg_12_1)
			arg_12_1:stopPropagation()
		end
		
		return true
	end
	
	local function var_11_0(arg_13_0, arg_13_1)
		if TOUCHED_INPUT_HANDLER ~= INPUT_HANDLER then
			return 
		end
		
		INPUT_HANDLER.TOUCHED = false
		
		local var_13_0 = arg_13_0:getLocation()
		
		if Dialog:onTouchUp(var_13_0.x, var_13_0.y) then
			arg_13_1:stopPropagation()
			
			return true
		end
		
		if INPUT_HANDLER.onTouchUp ~= nil then
			INPUT_HANDLER:onTouchUp(var_13_0.x, var_13_0.y, arg_13_1)
			arg_13_1:stopPropagation()
			
			return true
		end
	end
	
	local function var_11_1(arg_14_0, arg_14_1)
		if TOUCHED_INPUT_HANDLER ~= INPUT_HANDLER then
			return 
		end
		
		local var_14_0 = arg_14_0:getLocation()
		
		if Dialog:onTouchMove(var_14_0.x, var_14_0.y) then
			arg_14_1:stopPropagation()
			
			return true
		end
		
		if INPUT_HANDLER.onTouchMove ~= nil then
			INPUT_HANDLER:onTouchMove(var_14_0.x, var_14_0.y, arg_14_1)
			arg_14_1:stopPropagation()
			
			return true
		end
	end
	
	local var_11_2 = cc.EventListenerTouchOneByOne:create()
	local var_11_3 = arg_11_0:getEventDispatcher()
	
	var_11_2:registerScriptHandler(_onTouchDown, cc.Handler.EVENT_TOUCH_BEGAN)
	var_11_2:registerScriptHandler(var_11_0, cc.Handler.EVENT_TOUCH_ENDED)
	var_11_2:registerScriptHandler(var_11_1, cc.Handler.EVENT_TOUCH_MOVED)
	var_11_3:addEventListenerWithSceneGraphPriority(var_11_2, arg_11_0)
end

function HANDLER.error(arg_15_0)
	if UIAction:Find("err_message") == nil then
		UIAction:Add(SEQ(FADE_OUT(500), REMOVE()), getParentWindow(arg_15_0), "err_message")
	end
end

function balloon_message_with_sound_raw_text(arg_16_0, arg_16_1)
	balloon_message(arg_16_0, nil, arg_16_1)
end

function balloon_message_with_sound(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_2 or DB("balloon_msg", arg_17_0, "sound")
	
	balloon_message(T(arg_17_0, arg_17_1), var_17_0, arg_17_3)
end

function balloon_message(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not arg_18_0 then
		return 
	end
	
	if DEBUG.MOVIE_MODE then
		return 
	end
	
	arg_18_3 = arg_18_3 or {}
	arg_18_3.delay = arg_18_3.delay or 1000
	
	local var_18_0 = arg_18_2 or 0
	local var_18_1 = "caution"
	local var_18_2 = cc.CSLoader:createNode("wnd/" .. var_18_1 .. ".csb", onCreateNode)
	
	if var_18_2 then
		var_18_2:setName(var_18_1)
		var_18_2:setScale(WIDGET_SCALE_FACTOR)
		var_18_2:setUserObject(get_CSB_CHECK_NODE())
		var_18_2:getChildByName("txt"):setString(arg_18_0)
		var_18_2:setLocalZOrder(9999999 - var_18_0)
		var_18_2:setAnchorPoint(0, 0)
		var_18_2:setPosition(0, var_18_0 * 70 + -180)
		
		if var_18_0 == 0 then
			UIAction:Remove("caution", nil, true)
		end
		
		if arg_18_3.layer and get_cocos_refid(arg_18_3.layer) then
			arg_18_3.layer:addChild(var_18_2)
		else
			SceneManager:addAlertControl(var_18_2)
		end
		
		UIAction:Add(SEQ(LOG(MOVE_TO(200, 0, var_18_0 * 70), 500), DELAY(arg_18_3.delay), FADE_OUT(500), REMOVE()), var_18_2, "caution")
		SoundEngine:play("event:/" .. (arg_18_1 or "ui/baloon_message"))
	end
	
	return var_18_2
end

function balloon_sprite_message(arg_19_0, arg_19_1)
	if not arg_19_0 then
		return 
	end
	
	local var_19_0 = 0
	
	if arg_19_1 and arg_19_1.step then
		var_19_0 = arg_19_1.step
	end
	
	local var_19_1 = "caution_extend_sprite"
	local var_19_2 = cc.CSLoader:createNode("wnd/" .. var_19_1 .. ".csb", onCreateNode)
	
	if var_19_2 then
		var_19_2:setName(var_19_1)
		var_19_2:setScale(WIDGET_SCALE_FACTOR)
		var_19_2:setUserObject(get_CSB_CHECK_NODE())
		var_19_2:getChildByName("txt"):setString(arg_19_0)
		var_19_2:setLocalZOrder(9999999 - var_19_0)
		var_19_2:setAnchorPoint(0, 0)
		var_19_2:setPosition(0, var_19_0 * 70 + -180)
		
		if var_19_0 == 0 then
			SysAction:Remove("caution", nil, true)
		end
		
		if arg_19_1 and arg_19_1.sprite then
			if_set_sprite(var_19_2, "img", arg_19_1.sprite)
		end
		
		SceneManager:addAlertControl(var_19_2)
		SysAction:Add(SEQ(LOG(MOVE_TO(200 + var_19_0 * 30, 0, var_19_0 * 70), 500), DELAY(1000), FADE_OUT(500), REMOVE()), var_19_2, "caution")
	end
end

function getCurrent3AMTime()
	local var_20_0 = os.time()
	local var_20_1 = tonumber(os.date("%Y", var_20_0))
	local var_20_2 = tonumber(os.date("%m", var_20_0))
	local var_20_3 = tonumber(os.date("%d", var_20_0))
	
	if tonumber(os.date("%H", var_20_0)) >= 3 then
		var_20_3 = var_20_3 + 1
	end
	
	return os.time({
		hour = 3,
		year = var_20_1,
		month = var_20_2,
		day = var_20_3
	})
end

function flash_message(arg_21_0, arg_21_1)
	if not arg_21_0 then
		return 
	end
	
	local var_21_0 = "caution_flash"
	local var_21_1 = cc.CSLoader:createNode("wnd/" .. var_21_0 .. ".csb", onCreateNode)
	
	if var_21_1 then
		var_21_1:setName(var_21_0)
		var_21_1:setScale(WIDGET_SCALE_FACTOR)
		var_21_1:setUserObject(get_CSB_CHECK_NODE())
		var_21_1:getChildByName("txt"):setString(arg_21_0)
		SceneManager:addAlertControl(var_21_1)
		
		local var_21_2 = var_21_1:getChildByName("popnoti")
		
		var_21_2:setScaleY(0)
		SysAction:Append(SEQ(TARGET(var_21_2, LOG(SCALEY(200, 0, 1), 500)), DELAY(1000), TARGET(var_21_2, SPAWN(LOG(SCALEY(500, 1, 0), 500), LOG(OPACITY(500, 1, 0), 500), SEQ(DELAY(300), LOG(SCALEX(200, 1, 2))))), REMOVE()), var_21_1, "caution.flash")
		SoundEngine:play("event:/ui/popup/unlock")
	end
end

function flash_banner(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0 then
		return 
	end
	
	local var_22_0 = "game_eff_msg"
	local var_22_1 = cc.CSLoader:createNode("wnd/" .. var_22_0 .. ".csb", onCreateNode)
	
	if var_22_1 then
		var_22_1:setName(var_22_0)
		var_22_1:setScale(WIDGET_SCALE_FACTOR)
		var_22_1:setUserObject(get_CSB_CHECK_NODE())
		
		local var_22_2 = var_22_1:getChildByName("t_normal")
		local var_22_3 = var_22_1:getChildByName("t_boss")
		local var_22_4 = ""
		
		if arg_22_1 == "normal" or arg_22_1 == "warning" then
			if_set_visible(var_22_1, "n_cs_msg2", false)
			
			local var_22_5 = var_22_1:getChildByName("n_cs_msg1")
			
			if get_cocos_refid(var_22_5) then
				var_22_5:setVisible(true)
				
				if arg_22_1 == "normal" then
					if_set_visible(var_22_5, "t_normal", true)
					if_set_visible(var_22_5, "t_boss", false)
					if_set(var_22_5, "t_normal", arg_22_0)
					
					var_22_4 = "t_normal"
				else
					if_set_visible(var_22_5, "t_normal", false)
					if_set_visible(var_22_5, "t_boss", true)
					if_set(var_22_5, "t_boss", arg_22_0)
					
					var_22_4 = "t_boss"
				end
			end
		elseif arg_22_1 == "speech" then
			if_set_visible(var_22_1, "n_cs_msg1", false)
			
			local var_22_6 = var_22_1:getChildByName("n_cs_msg2")
			
			if get_cocos_refid(var_22_6) then
				var_22_6:setVisible(true)
				if_set_visible(var_22_6, "t_speech", true)
				if_set(var_22_6, "t_speech", arg_22_0)
				
				var_22_4 = "t_speech"
			end
		else
			if_set_visible(var_22_1, "n_cs_msg1", false)
			if_set_visible(var_22_1, "n_cs_msg2", false)
		end
		
		var_22_1:setLocalZOrder(9999999)
		SceneManager:getRunningNativeScene():addChild(var_22_1)
		
		local var_22_7 = var_22_1:getChildByName("n_window")
		
		var_22_7:setVisible(false)
		
		local var_22_8 = 2
		
		var_22_8 = arg_22_2.fadein and tonumber(arg_22_2.fadein) or var_22_8
		
		local var_22_9 = 1.5
		
		var_22_9 = arg_22_2.delay and tonumber(arg_22_2.delay) or var_22_9
		
		local var_22_10 = 0.5
		
		var_22_10 = arg_22_2.fadeout and tonumber(arg_22_2.fadeout) or var_22_10
		
		local var_22_11 = 1000
		
		SysAction:Append(SEQ(TARGET(var_22_7, LOG(FADE_IN(var_22_8 * var_22_11), 500)), DELAY(var_22_9 * var_22_11), TARGET(var_22_7, FADE_OUT(var_22_10 * var_22_11)), REMOVE()), var_22_1, "banner.flash")
		SoundEngine:play("event:/ui/battle_msg/" .. var_22_4)
	end
end

function net_error(arg_23_0)
	debug_message(arg_23_0, false, nil, {
		req_next_query = true
	})
end

function debug_message(arg_24_0, arg_24_1, arg_24_2)
	print("DEBUG:" .. arg_24_0)
	
	arg_24_2 = arg_24_2 or SceneManager:getRunningNativeScene()
	
	local var_24_0 = Dialog:open("wnd/error")
	
	var_24_0:setOpacity(0)
	var_24_0:getChildByName("txt"):setString(arg_24_0)
	var_24_0:setLocalZOrder(99999999)
	
	local var_24_1 = var_24_0
	
	UIAction:Add(SEQ(FADE_IN(500), DELAY(1000)), var_24_0, "err_message")
	arg_24_2:addChild(var_24_1)
end

message = debug_message

function error_dlg(arg_25_0, arg_25_1)
	return debug_message(arg_25_0, false, arg_25_1)
end

function modal_dlg(arg_26_0)
	DIALOG_LAYER = {}
	
	local var_26_0 = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
	
	var_26_0:setTouchEnabled(true)
	var_26_0:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	
	local var_26_1 = wndload_dlg(arg_26_0)
	
	var_26_1:setScale(WIDGET_SCALE_FACTOR)
	var_26_1:setAnchorPoint(0.5, 0.5)
	var_26_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_26_0:addChild(var_26_1)
	
	DIALOG_LAYER.layer = var_26_0
	DIALOG_LAYER.prev_input_handler = INPUT_HANDLER
	
	set_input_handler(DIALOG_LAYER)
	reg_touch_handler(var_26_0, DIALOG_LAYER)
	UIAction:Add(LAYER_OPACITY(400, 0, 1), var_26_0, "err_message")
	
	function DIALOG_LAYER.onTouchDown(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
		arg_27_3:stopPropagation()
		
		return true
	end
	
	SCENE:addChild(var_26_0)
	
	return var_26_1
end

function checkUIPick(arg_28_0, arg_28_1, arg_28_2)
	for iter_28_0 = #arg_28_0, 1, -1 do
		local var_28_0 = arg_28_0[iter_28_0]
		
		if get_cocos_refid(var_28_0) and var_28_0:isVisible() then
			local var_28_1 = var_28_0:convertToNodeSpace({
				x = arg_28_1,
				y = arg_28_2
			})
			local var_28_2 = var_28_0:getContentSize()
			
			if var_28_1.x >= 0 and var_28_1.x <= var_28_2.width and var_28_1.y >= 0 and var_28_1.y <= var_28_2.height then
				return iter_28_0
			end
		end
	end
	
	return nil
end

function getParentWindow(arg_29_0)
	local var_29_0 = arg_29_0:getParent()
	
	while var_29_0 do
		if get_CSB_CHECK_NODE() and var_29_0:getUserObject() == get_CSB_CHECK_NODE() then
			return var_29_0
		end
		
		local var_29_1 = var_29_0:getParent()
		
		if var_29_1 == nil then
			break
		end
		
		var_29_0 = var_29_1
	end
	
	return var_29_0
end

function getEventHandler(arg_30_0, arg_30_1)
	local var_30_0 = getParentWindow(arg_30_0):getName()
	
	if arg_30_1 == ccui.TouchEventType.ended then
		return HANDLER[var_30_0]
	elseif arg_30_1 == ccui.TouchEventType.began then
		return HANDLER_BEFORE[var_30_0]
	elseif arg_30_1 == ccui.TouchEventType.canceled then
		return HANDLER_CANCEL[var_30_0]
	end
end

local function var_0_0(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	local var_31_0 = arg_31_1
	
	if not ccexp.SoundEngine:existsEvent(var_31_0) then
		var_31_0 = arg_31_2
	elseif not ccexp.SoundEngine:existsEvent(var_31_0) then
		var_31_0 = arg_31_3
	end
	
	if not ccexp.SoundEngine:existsEvent(var_31_0) then
		var_31_0 = string.find(arg_31_0, "close") and "event:/ui/btn_small" or string.find(arg_31_0, "cancel") and "event:/ui/btn_cancel" or "event:/ui/ok"
	end
	
	if arg_31_4 then
		print(">> require ui event name : ", arg_31_1, arg_31_2, arg_31_3)
		print(">> play event name : ", var_31_0)
	end
	
	SoundEngine:play(var_31_0)
end

local function var_0_1(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:getComponent("ComExtensionData")
	
	if not var_32_0 then
		return nil
	end
	
	local var_32_1 = var_32_0:getCustomProperty()
	
	if not arg_32_1 then
		return var_32_1
	end
	
	if not var_32_1 then
		return 
	end
	
	local var_32_2 = string.split(var_32_1, ",")
	
	for iter_32_0, iter_32_1 in ipairs(var_32_2) do
		if iter_32_1 and iter_32_1 ~= "" and string.match(iter_32_1, arg_32_1) then
			return iter_32_1
		end
	end
end

local function var_0_2(arg_33_0)
	local var_33_0 = var_0_1(arg_33_0)
	
	if var_33_0 then
		if string.find(var_33_0, "NOTCH_") then
			NotchManager:resetListener(arg_33_0)
		elseif string.find(var_33_0, "LEFT") and arg_33_0.origin_x then
			arg_33_0:setPositionX(arg_33_0.origin_x + VIEW_BASE_LEFT)
		elseif string.find(var_33_0, "RIGHT") and arg_33_0.origin_x then
			arg_33_0:setPositionX(arg_33_0.origin_x - VIEW_BASE_LEFT)
		elseif string.find(var_33_0, "STRETCH_NOTCH") then
			setting_node_stretch(arg_33_0, VIEW_BASE_LEFT, DESIGN_WIDTH, VIEW_WIDTH, {
				stretch = true,
				stretch_notch = true
			})
		elseif string.find(var_33_0, "STRETCH_HALF") then
			setting_node_stretch(arg_33_0, VIEW_BASE_LEFT, DESIGN_WIDTH, VIEW_WIDTH, {
				stretch = true,
				stretch_half = true
			})
		elseif string.find(var_33_0, "NO_STRETCH") then
			setting_node_stretch(arg_33_0, VIEW_BASE_LEFT, DESIGN_WIDTH, VIEW_WIDTH, {
				no_stretch = true
			})
		elseif string.find(var_33_0, "STRETCH") then
			setting_node_stretch(arg_33_0, VIEW_BASE_LEFT, DESIGN_WIDTH, VIEW_WIDTH, {
				stretch = true
			})
		elseif arg_33_0.STRETCH_INFO then
			setting_node_stretch(arg_33_0, VIEW_BASE_LEFT, DESIGN_WIDTH, VIEW_WIDTH)
		end
		
		if arg_33_0.scene_reload_callback then
			arg_33_0.scene_reload_callback()
			
			return 
		end
	elseif arg_33_0.STRETCH_INFO then
		rollback_stretch(arg_33_0)
		setting_node_stretch(arg_33_0, VIEW_BASE_LEFT, DESIGN_WIDTH, VIEW_WIDTH, {
			stretch = true
		})
	end
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0:getChildren()) do
		var_0_2(iter_33_1)
	end
end

function reload_scene()
	local var_34_0 = SceneManager:getRunningScene()
	
	if var_34_0 then
		local var_34_1 = cc.Director:getInstance():getWinSize()
		local var_34_2 = var_34_0:getContentSize()
		local var_34_3 = SceneManager:getRunningNativeScene()
		local var_34_4 = SceneManager:getRunningUIScene()
		local var_34_5 = SceneManager:getRunningPopupScene()
		local var_34_6 = SceneManager:getAlertLayer()
		local var_34_7 = (var_34_1.width - var_34_2.width) / 2
		local var_34_8 = (var_34_1.height - var_34_2.height) / 2
		
		var_34_3:setPosition(var_34_7, var_34_8)
		var_34_3:setContentSize(var_34_1)
		var_34_4:setPosition(var_34_7, var_34_8)
		var_34_4:setContentSize(var_34_1)
		var_34_5:setPosition(var_34_7, var_34_8)
		var_34_5:setContentSize(var_34_1)
		var_34_6:setPosition(var_34_7, var_34_8)
		var_34_6:setContentSize(var_34_1)
		var_34_0:createLetterBox()
		var_0_2(var_34_3)
		var_0_2(var_34_4)
		var_0_2(var_34_5)
		var_0_2(var_34_6)
		
		if var_34_0.onChangeResolution then
			var_34_0:onChangeResolution()
		end
	end
	
	PatchGauge:updateOffsetDlg()
	NetWaiting:updateOffsetDlg()
	TopBarNew:updateOffsetDlg()
	DungeonHome:updateOffsetDlg()
	SubStoryEntrance:updateOffsetDlg()
end

local function var_0_3(arg_35_0)
	local var_35_0 = var_0_1(arg_35_0, ".*snd=.*")
	
	if not var_35_0 then
		return ""
	end
	
	local var_35_1 = string.split(var_35_0, "=")[2]
	
	return "event:" .. var_35_1
end

function getUIControlTextData(arg_36_0)
	return var_0_1(arg_36_0, "[%l%d_]+")
end

function defaultEventEnter(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if UIAction:Find("block") or TransitionScreen:isShow() then
		return 
	end
	
	local var_37_0 = arg_37_0:getName()
	local var_37_1 = var_0_3(arg_37_0)
	local var_37_2 = string.format("event:/ui/%s/%s", getParentWindow(arg_37_0):getName(), var_37_0)
	local var_37_3 = string.format("event:/ui/#/%s", var_37_0)
	
	if DEBUG.UI_SOUND_TEST then
		var_0_0(var_37_0, var_37_1, var_37_2, var_37_3, true)
		
		return 
	end
	
	if NetWaiting:isWaiting() == true then
		print("defaultEventEnter SKIPPED - NetWaiting:isWaiting()")
		
		return 
	end
	
	if arg_37_1 == ccui.TouchEventType.began then
		arg_37_0._btn_pushed = true
	elseif arg_37_1 == ccui.TouchEventType.canceled or arg_37_1 == ccui.TouchEventType.ended then
		if not arg_37_0._btn_pushed then
			return 
		end
		
		arg_37_0._btn_pushed = nil
	end
	
	local var_37_4 = getEventHandler(arg_37_0, arg_37_1)
	
	if var_37_4 then
		local var_37_5 = SceneManager:getRunningUIRootScene()
		local var_37_6 = SceneManager:getRunningPopupScene()
		
		if var_37_5 and var_37_5:getOpacity() < 255 and var_37_6 and table.count(var_37_6:getChildren()) == 0 and SceneManager:getCurrentSceneName() == "lobby" then
			SceneManager:updateTouchEventTime()
			
			return 
		else
			SceneManager:updateTouchEventTime()
		end
		
		set_high_fps_tick()
		
		if TutorialGuide:isPlayingTutorial() and not TutorialGuide:isAllowEvent(arg_37_0) then
			print("Not allow defaultEventEnter Event for TutorialGuide : ", var_37_0)
			
			return 
		end
		
		if arg_37_1 == ccui.TouchEventType.ended then
			if EVENT_FILTER.sender_name == var_37_0 and EVENT_FILTER.event_type == arg_37_1 and EVENT_FILTER.time >= LAST_UI_TICK - EVENT_FILTER_TIME and tolua.type(arg_37_0) ~= "ccui.CheckBox" and getParentWindow(arg_37_0):getName() ~= "battle_cheat" and getParentWindow(arg_37_0):getName() ~= "cheat" and getParentWindow(arg_37_0):getName() ~= "game_cooking" and getParentWindow(arg_37_0):getName() ~= "dungeon_story_fullmetal_alchemis" and getParentWindow(arg_37_0):getName() ~= "game_aprilfool_battle" then
				print("SKIPPED!!!!!!!!!!" .. LAST_UI_TICK)
				
				return 
			end
			
			if not string.ends(var_37_0, "_nosound") and var_37_1 ~= "event:/nosnd" and not string.ends(var_37_0, "ignore") then
				var_0_0(var_37_0, var_37_1, var_37_2, var_37_3)
			end
			
			if arg_37_0.contents_disabled and not arg_37_0.can_enterable then
				balloon_message_with_sound(arg_37_0.contents_disabled)
				
				return 
			end
			
			if arg_37_0._force_open == nil and arg_37_0.category_unlock_id and not UnlockSystem:isUnlockSystemAndMsg({
				exclude_story = true,
				id = arg_37_0.category_unlock_id,
				replace_title = arg_37_0.category_unlock_replace_title
			}, function()
			end) then
				return 
			end
		end
		
		var_37_4(arg_37_0, var_37_0, arg_37_1, arg_37_2, arg_37_3)
		
		EVENT_FILTER.sender_name = var_37_0
		EVENT_FILTER.event_type = arg_37_1
		EVENT_FILTER.time = LAST_UI_TICK
		
		if PLATFORM == "win32" then
			local var_37_7 = ""
			
			if getParentWindow(arg_37_0) then
				var_37_7 = "    ui(" .. getParentWindow(arg_37_0):getName() .. ")"
			end
			
			print("UI EVENT : scene(" .. SceneManager:getCurrentSceneName() .. ")   target(" .. var_37_0 .. ")" .. var_37_7)
		end
		
		return 
	end
	
	if arg_37_1 ~= ccui.TouchEventType.ended then
		return 
	end
	
	print("no handler:", getParentWindow(arg_37_0):getName(), var_37_0)
end

function getChildByPath(arg_39_0, arg_39_1)
	if not get_cocos_refid(arg_39_0) then
		return 
	end
	
	for iter_39_0, iter_39_1 in pairs(string.split(arg_39_1, "/")) do
		if iter_39_1 == "." or iter_39_1 == "" then
		elseif iter_39_1 == ".." then
			arg_39_0 = arg_39_0:getParent()
		else
			local var_39_0 = arg_39_0
			
			arg_39_0 = nil
			
			for iter_39_2, iter_39_3 in pairs(var_39_0:getChildren()) do
				if iter_39_3:getName() == iter_39_1 then
					arg_39_0 = iter_39_3
					
					break
				end
			end
		end
		
		if not get_cocos_refid(arg_39_0) then
			Log.i("getChildByPath", arg_39_1 .. "가 유효한 경로가 아닙니다.")
			
			return nil
		end
	end
	
	return arg_39_0
end

function isEULanguage()
	local var_40_0 = getUserLanguage()
	
	return var_40_0 == "en" or var_40_0 == "de" or var_40_0 == "es" or var_40_0 == "fr" or var_40_0 == "pt"
end

function isLatinAccentLanguage()
	local var_41_0 = getUserLanguage()
	
	return var_41_0 == "de" or var_41_0 == "es" or var_41_0 == "fr" or var_41_0 == "pt"
end

function resetControlPosForNotch(arg_42_0)
	local var_42_0 = {
		"LEFT",
		"RIGHT"
	}
	local var_42_1 = {
		"TOP_LEFT",
		"BOT_RIGHT"
	}
	
	for iter_42_0 = 1, 2 do
		local var_42_2 = arg_42_0:getChildByName(var_42_0[iter_42_0])
		
		if var_42_2 then
			NotchManager:addListener(var_42_2:getChildByName(var_42_1[iter_42_0]), true)
		end
	end
end

function timeToStringDef(arg_43_0)
	if arg_43_0 == nil then
		return {}
	end
	
	local var_43_0 = {}
	local var_43_1 = "%d"
	
	if arg_43_0.preceding_with_zeros == true then
		var_43_1 = "%02d"
	end
	
	local var_43_2 = os.time() + 284012568
	
	local function var_43_3(arg_44_0)
		if arg_44_0 > var_43_2 then
			return var_43_2
		else
			return arg_44_0
		end
	end
	
	local function var_43_4(arg_45_0, arg_45_1)
		var_43_0[arg_45_1 .. "year"] = arg_45_0.year
		var_43_0[arg_45_1 .. "month"] = string.format(var_43_1, arg_45_0.month)
		var_43_0[arg_45_1 .. "day"] = string.format(var_43_1, arg_45_0.day)
		var_43_0[arg_45_1 .. "hour"] = string.format(var_43_1, arg_45_0.hour)
		var_43_0[arg_45_1 .. "min"] = string.format(var_43_1, arg_45_0.min)
		var_43_0[arg_45_1 .. "sec"] = string.format(var_43_1, arg_45_0.sec)
		var_43_0[arg_45_1 .. "time"] = string.format(var_43_1 .. ":" .. var_43_1, arg_45_0.hour, arg_45_0.min)
	end
	
	if arg_43_0.time then
		var_43_4(os.date("*t", var_43_3(arg_43_0.time)), "")
		
		return var_43_0
	end
	
	if arg_43_0.remain_time then
		local var_43_5 = arg_43_0.remain_time % 60
		local var_43_6 = math.floor(arg_43_0.remain_time / 60)
		local var_43_7 = math.floor(var_43_6 / 60)
		
		return {
			hour = string.format(var_43_1, var_43_7),
			min = string.format(var_43_1, var_43_6 % 60),
			sec = string.format(var_43_1, var_43_5)
		}
	end
	
	if arg_43_0.remain_time_with_day then
		local var_43_8 = arg_43_0.remain_time_with_day % 60
		local var_43_9 = math.floor(arg_43_0.remain_time_with_day / 60)
		local var_43_10 = math.floor(var_43_9 / 60)
		local var_43_11 = math.floor(var_43_10 / 24)
		
		return {
			day = string.format(var_43_1, var_43_11),
			hour = string.format(var_43_1, var_43_10 % 24),
			min = string.format(var_43_1, var_43_9 % 60),
			sec = string.format(var_43_1, var_43_8)
		}
	end
	
	if arg_43_0.start_time then
		var_43_4(os.date("*t", var_43_3(arg_43_0.start_time)), "start_")
	end
	
	if arg_43_0.end_time then
		var_43_4(os.date("*t", var_43_3(arg_43_0.end_time)), "end_")
	end
	
	return var_43_0
end

local function var_0_4(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6)
	local var_46_0 = arg_46_2 / 2
	
	if arg_46_3 then
		var_46_0 = 0
	end
	
	if not arg_46_5 then
		var_46_0 = var_46_0 + arg_46_4
	end
	
	if arg_46_6 then
		var_46_0 = -var_46_0
	end
	
	if arg_46_1 then
		var_46_0 = arg_46_1 + var_46_0
	end
	
	arg_46_0:setPositionX(var_46_0)
end

local function var_0_5(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0
	
	if arg_47_2 then
		var_47_0 = NotchStatus:getNotchSafeRight() / 2
	else
		var_47_0 = NotchStatus:getNotchSafeLeft() / 2
	end
	
	if arg_47_1 then
		var_47_0 = var_47_0 + arg_47_1
	end
	
	arg_47_0:setPositionX(var_47_0)
end

function isSameOrientation(arg_48_0)
	if not get_cocos_refid(arg_48_0) then
		return 
	end
	
	local var_48_0 = var_0_1(arg_48_0)
	
	if var_48_0 == "" or var_48_0 == nil then
		var_48_0 = arg_48_0.orientation
	end
	
	if not var_48_0 then
		return 
	end
	
	local var_48_1 = {
		"RIGHT",
		"LEFT"
	}
	local var_48_2 = NotchStatus:isLeft()
	local var_48_3 = var_48_2 and 1 or 2
	
	if string.find(var_48_0, var_48_1[var_48_3]) then
		return false, var_48_2, var_48_0
	end
	
	return true, var_48_2, var_48_0
end

function resetPosForNotch(arg_49_0, arg_49_1, arg_49_2)
	if not get_cocos_refid(arg_49_0) then
		return 
	end
	
	local var_49_0 = var_0_1(arg_49_0)
	
	if not var_49_0 and arg_49_2 ~= nil then
		return 
	end
	
	arg_49_2 = arg_49_2 or {}
	
	local var_49_1
	
	if arg_49_2.isLeft ~= nil then
		var_49_1 = arg_49_2.isLeft
	else
		var_49_1 = NotchStatus:isLeft()
	end
	
	if string.find(var_49_0, "NOTCH_TOP_LEFT") and NOTCH_LEFT_WIDTH > 0 then
		var_0_4(arg_49_0, arg_49_2.origin_x, NOTCH_LEFT_WIDTH, var_49_1, VIEW_BASE_LEFT, arg_49_1)
	elseif string.find(var_49_0, "NOTCH_BOT_RIGHT") and NOTCH_LEFT_WIDTH > 0 then
		var_0_4(arg_49_0, arg_49_2.origin_x, NOTCH_LEFT_WIDTH, not var_49_1, VIEW_BASE_LEFT, arg_49_1, true)
	elseif string.find(var_49_0, "NOTCH_LEFT") then
		var_0_4(arg_49_0, arg_49_2.origin_x, NOTCH_WIDTH, var_49_1, VIEW_BASE_LEFT, arg_49_1)
	elseif string.find(var_49_0, "NOTCH_RIGHT") then
		var_0_4(arg_49_0, arg_49_2.origin_x, NOTCH_WIDTH, not var_49_1, VIEW_BASE_LEFT, arg_49_1, true)
	elseif string.find(var_49_0, "NOTCH_CENTER") then
		var_0_5(arg_49_0, arg_49_2.origin_x, var_49_1)
	elseif string.find(var_49_0, "NOTCH_TOP_LEFT") then
		var_0_4(arg_49_0, arg_49_2.origin_x, 0, true, VIEW_BASE_LEFT, arg_49_1)
	elseif string.find(var_49_0, "NOTCH_BOT_RIGHT") then
		var_0_4(arg_49_0, arg_49_2.origin_x, 0, true, VIEW_BASE_LEFT, arg_49_1, true)
	elseif string.find(var_49_0, "STRETCH_NOTCH") then
		var_0_4(arg_49_0, arg_49_2.origin_x, NOTCH_WIDTH, var_49_1, VIEW_BASE_LEFT, arg_49_1, false)
	end
end

function onCreateNode(arg_50_0)
	local var_50_0 = tolua.type(arg_50_0)
	
	if var_50_0 == "ccui.Text" or var_50_0 == "ccui.TextField" then
		if DEBUG.TEST_UI_TEXT and string.len(arg_50_0:getString()) > 2 then
			arg_50_0:setString("ui:" .. arg_50_0:getName())
		end
		
		local var_50_1 = getUIControlTextData(arg_50_0)
		local var_50_2 = T(var_50_1, var_50_1)
		
		if DEBUG.TEST_UI_TEXT and var_50_1 and string.len(arg_50_0:getString()) > 2 then
			print("UI TEXT:", arg_50_0:getString(), var_50_1, var_50_2)
		end
		
		if var_50_1 then
			if var_50_0 == "ccui.TextField" then
				arg_50_0:setPlaceHolder(var_50_2)
			else
				arg_50_0:setString(var_50_2)
			end
		elseif DEBUG.TEST_UI_TEXT then
			if var_50_0 == "ccui.TextField" then
				arg_50_0:setPlaceHolder("*" .. arg_50_0:getName())
			else
				arg_50_0:setString("*" .. arg_50_0:getName())
			end
		end
	elseif var_50_0 == "ccui.Button" or var_50_0 == "ccui.CheckBox" then
		arg_50_0:addTouchEventListener(function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
			defaultEventEnter(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
		end)
	end
	
	UIUserData:parse(arg_50_0)
end

local var_0_6 = {
	"NOTCH_TOP_LEFT",
	"NOTCH_BOT_RIGHT",
	"NOTCH_LEFT",
	"NOTCH_RIGHT",
	"NOTCH_CENTER",
	"LEFT"
}

local function var_0_7(arg_52_0)
	local var_52_0 = arg_52_0:getParent()
	
	if not var_52_0 then
		return false
	end
	
	local var_52_1 = var_0_1(var_52_0)
	
	for iter_52_0, iter_52_1 in pairs(var_0_6) do
		if not var_52_1 then
			break
		end
		
		if string.find(var_52_1, iter_52_1) then
			return true, var_52_0
		end
	end
	
	if var_52_0:getParent() then
		return var_0_7(var_52_0)
	end
	
	return false
end

local function var_0_8(arg_53_0)
	local var_53_0 = arg_53_0:getParent()
	
	if not var_53_0 then
		return arg_53_0:getName()
	else
		return var_0_8(var_53_0)
	end
end

local function var_0_9(arg_54_0, arg_54_1)
	local var_54_0
	
	for iter_54_0, iter_54_1 in pairs(var_0_6) do
		if string.find(arg_54_1, iter_54_1) then
			var_54_0 = iter_54_1
			
			break
		end
	end
	
	if not var_54_0 then
		return 
	end
	
	local var_54_1, var_54_2 = var_0_7(arg_54_0)
	
	if var_54_1 then
		local var_54_3 = var_0_8(arg_54_0)
		local var_54_4 = var_0_1(var_54_2)
		
		Log.e("'" .. arg_54_1 .. "'<=> '" .. var_54_4 .. "' WAS CONFLICT. child : " .. arg_54_0:getName() .. ", parent : " .. var_54_2:getName() .. " fileName : " .. var_54_3)
	end
end

function rollback_node(arg_55_0)
	if arg_55_0.STRETCH_INFO and arg_55_0.STRETCH_INFO.ratio_before then
		arg_55_0:setScaleX(arg_55_0.STRETCH_INFO.ratio_before)
	elseif arg_55_0.STRETCH_INFO then
		local var_55_0 = arg_55_0:getContentSize()
		
		arg_55_0:setContentSize({
			width = arg_55_0.STRETCH_INFO.width_prev,
			height = var_55_0.height
		})
		
		for iter_55_0, iter_55_1 in pairs(arg_55_0:getChildren()) do
			if iter_55_1.child_origin_x then
				iter_55_1:setPositionX(iter_55_1.child_origin_x)
			end
		end
	end
	
	if arg_55_0.prv_move then
		arg_55_0:setPositionX(arg_55_0.prv_move)
	end
end

function get_stretch_ratio(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	return (arg_56_0 - NOTCH_WIDTH / 2 - (arg_56_1 - arg_56_2.width * arg_56_3)) / (arg_56_2.width * arg_56_3)
end

function setting_node_stretch(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0
	
	arg_57_4 = arg_57_4 or {}
	
	local var_57_1 = arg_57_4.stretch
	local var_57_2 = arg_57_4.stretch_notch
	local var_57_3 = arg_57_4.stretch_half
	local var_57_4 = arg_57_4.no_stretch
	
	if not arg_57_0.getScale then
		return 
	end
	
	rollback_node(arg_57_0)
	
	local var_57_5 = arg_57_0:getContentSize()
	local var_57_6 = arg_57_0:getScaleX()
	local var_57_7 = var_0_1(arg_57_0)
	
	if var_57_1 then
		if var_57_2 then
			var_57_0 = get_stretch_ratio(arg_57_3, arg_57_2, var_57_5, var_57_6)
		else
			var_57_0 = (arg_57_3 - (arg_57_2 - var_57_5.width * var_57_6)) / (var_57_5.width * var_57_6)
		end
	elseif not var_57_4 then
		var_57_1 = var_57_5.width * var_57_6 == arg_57_2
		var_57_0 = arg_57_3 / arg_57_2
	end
	
	if not var_57_1 then
		return 
	end
	
	if var_57_3 then
		var_57_0 = (var_57_0 - 1) / 2 + 1
	end
	
	local var_57_8 = tolua.type(arg_57_0)
	
	if var_57_8 ~= "cc.Sprite" and var_57_6 == 1 or var_57_8 == "ccui.Text" or var_57_8 == "ccui.TextField" then
		arg_57_0.STRETCH_INFO = {
			width_prev = var_57_5.width,
			width_after = var_57_5.width * var_57_0,
			stretch_ratio = var_57_0
		}
		
		arg_57_0:setContentSize({
			width = var_57_5.width * var_57_0,
			height = var_57_5.height
		})
		
		local var_57_9 = arg_57_0:getChildren()
		
		for iter_57_0, iter_57_1 in pairs(var_57_9) do
			iter_57_1.child_origin_x = iter_57_1:getPositionX()
			
			iter_57_1:setPositionX(iter_57_1:getPositionX() - arg_57_1)
		end
	else
		arg_57_0.STRETCH_INFO = {
			width_prev = var_57_5.width,
			ratio_before = var_57_6,
			ratio_after = var_57_0,
			width_after = var_57_5.width * var_57_0
		}
		
		arg_57_0:setScaleX(var_57_6 * var_57_0)
	end
	
	if var_57_3 and var_57_2 then
		return 
	end
	
	if string.find(var_57_7, "STRETCH_NOTCH_SIDE") then
		return 
	end
	
	if var_57_8 ~= "ccui.Text" and var_57_2 and arg_57_0.STRETCH_INFO then
		arg_57_0.prv_move = arg_57_0:getPositionX()
		
		local var_57_10 = (arg_57_0.STRETCH_INFO.width_after - arg_57_0.STRETCH_INFO.width_prev) / 2
		
		arg_57_0:setPositionX(arg_57_0:getPositionX() + var_57_10)
		NotchManager:resetOriginPos(arg_57_0, arg_57_0:getPositionX())
		NotchManager:addListener(arg_57_0)
	elseif var_57_2 then
		local var_57_11 = (var_57_6 * var_57_0 - var_57_6) / 2
		
		arg_57_0:setPositionX(arg_57_0:getPositionX() + arg_57_0:getContentSize().width * var_57_11)
		NotchManager:resetOriginPos(arg_57_0, arg_57_0:getPositionX())
		NotchManager:addListener(arg_57_0)
	end
end

DEBUG.SHOW_UI_ERROR_LOG = false

function resetNodePosAndSize(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	if arg_58_1 < arg_58_2 then
		arg_58_1 = arg_58_2
	end
	
	local var_58_0 = (arg_58_2 - arg_58_1) / 2
	local var_58_1 = var_0_1(arg_58_0)
	local var_58_2 = {}
	
	if not var_58_1 then
		return 
	end
	
	local function var_58_3(arg_59_0)
		if arg_59_0.origin_x and not arg_59_0.child_origin_x then
			arg_59_0:setPositionX(arg_59_0.origin_x)
		end
		
		arg_59_0.origin_x = arg_59_0:getPositionX()
	end
	
	if PLATFORM == "win32" and DEBUG.SHOW_UI_ERROR_LOG then
		var_0_9(arg_58_0, var_58_1)
	end
	
	if string.find(var_58_1, "NOTCH_TOP_LEFT") then
		NotchManager:addListener(arg_58_0)
	elseif string.find(var_58_1, "NOTCH_BOT_RIGHT") then
		NotchManager:addListener(arg_58_0)
	elseif string.find(var_58_1, "NOTCH_LEFT") then
		NotchManager:addListener(arg_58_0)
	elseif string.find(var_58_1, "NOTCH_RIGHT") then
		NotchManager:addListener(arg_58_0)
	elseif string.find(var_58_1, "NOTCH_CENTER") then
		NotchManager:addListener(arg_58_0)
	elseif string.find(var_58_1, "LEFT") then
		var_58_3(arg_58_0)
		
		if arg_58_3 then
			arg_58_0:setPositionX(arg_58_0:getPositionX() + var_58_0 * 1.5)
		else
			arg_58_0:setPositionX(arg_58_0:getPositionX() + var_58_0)
		end
	elseif string.find(var_58_1, "RIGHT") then
		var_58_3(arg_58_0)
		
		if arg_58_3 then
			arg_58_0:setPositionX(arg_58_0:getPositionX() - var_58_0 * 1.5)
		else
			arg_58_0:setPositionX(arg_58_0:getPositionX() - var_58_0)
		end
	elseif string.find(var_58_1, "NO_STRETCH") then
		var_58_2.no_stretch = true
	elseif string.find(var_58_1, "STRETCH_HALF_NOTCH") then
		var_58_2.stretch = true
		var_58_2.stretch_half = true
		var_58_2.stretch_notch = true
	elseif string.find(var_58_1, "STRETCH_HALF") then
		var_58_2.stretch = true
		var_58_2.stretch_half = true
	elseif string.find(var_58_1, "STRETCH_NOTCH") then
		var_58_2.stretch = true
		var_58_2.stretch_notch = true
	elseif string.find(var_58_1, "STRETCH") then
		var_58_2.stretch = true
	end
	
	setting_node_stretch(arg_58_0, var_58_0, arg_58_2, arg_58_1, var_58_2)
end

function resetControlPosAndSize(arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	if not arg_60_3 then
		resetNodePosAndSize(arg_60_0, arg_60_1, arg_60_2, arg_60_4)
	end
	
	local var_60_0 = arg_60_0:getChildren()
	
	for iter_60_0, iter_60_1 in pairs(var_60_0) do
		resetControlPosAndSize(iter_60_1, arg_60_1, arg_60_2, nil, arg_60_4)
	end
end

local var_0_10 = {
	__index = function(arg_61_0, arg_61_1)
		local var_61_0 = rawget(arg_61_0, arg_61_1)
		
		if var_61_0 then
			return var_61_0
		end
		
		local var_61_1 = arg_61_0["-p"]:getChildByName(arg_61_1)
		
		if var_61_1 and not var_61_1["-p"] then
			setup_control_childs(var_61_1)
		end
		
		return var_61_1
	end
}

function setup_control_childs(arg_62_0)
	arg_62_0.c = {
		["-p"] = arg_62_0
	}
	
	setmetatable(arg_62_0.c, var_0_10)
end

function get_CSB_CHECK_NODE()
	if not get_cocos_refid(CSB_CHECK_NODE) then
		CSB_CHECK_NODE = cc.Node:create()
		
		CSB_CHECK_NODE:setName("csbscene")
		CSB_CHECK_NODE:retain()
	end
	
	return CSB_CHECK_NODE
end

function load_control(arg_64_0, arg_64_1, arg_64_2)
	if PLATFORM == "win32" then
		print("LOADING UI : " .. arg_64_0)
	end
	
	local var_64_0 = cc.CSLoader:createNode(arg_64_0, onCreateNode)
	
	UIUserData:procAfterLoadDlg()
	
	local var_64_1 = string.split(arg_64_0, "/")
	
	var_64_0:setName(string.split(var_64_1[#var_64_1], ".")[1])
	var_64_0:setScale(WIDGET_SCALE_FACTOR)
	
	if not arg_64_2 then
		var_64_0:setUserObject(get_CSB_CHECK_NODE())
	end
	
	if arg_64_1 or var_64_0:getContentSize().width == DESIGN_WIDTH then
		resetControlPosAndSize(var_64_0, VIEW_WIDTH, DESIGN_WIDTH, true)
		resetControlPosForNotch(var_64_0)
	end
	
	setup_control_childs(var_64_0)
	
	return var_64_0
end

function tocontrol(arg_65_0, arg_65_1)
	if get_cocos_refid(arg_65_0) then
		return arg_65_0
	end
	
	if type(arg_65_0) == "string" then
		return load_control(arg_65_0, arg_65_1 or "wnd")
	end
end

function towidget(arg_66_0, arg_66_1)
	arg_66_0 = tocontrol(arg_66_0, arg_66_1)
	
	local var_66_0 = ccui.Widget:create()
	
	var_66_0:setAnchorPoint(0, 0)
	var_66_0:setContentSize(arg_66_0:getContentSize())
	
	for iter_66_0, iter_66_1 in pairs(arg_66_0:getChildren()) do
		iter_66_1:ejectFromParent()
		var_66_0:addChild(iter_66_1)
	end
	
	return var_66_0
end

function load_dlg(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = load_control(arg_67_2 .. "/" .. arg_67_0 .. ".csb")
	
	var_67_0:setLocalZOrder(99999)
	var_67_0:setAnchorPoint(0.5, 0.5)
	var_67_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	if not arg_67_1 then
		play_dlg(var_67_0)
	end
	
	if arg_67_3 then
		BackButtonManager:push({
			back_func = arg_67_3,
			dlg = var_67_0,
			check_id = arg_67_0
		})
	end
	
	return var_67_0
end

function show_ani(arg_68_0, arg_68_1, arg_68_2)
	arg_68_2 = arg_68_2 or {}
	arg_68_2.tm = arg_68_2.tm or 300
	
	if arg_68_1 then
		if arg_68_0:getOpacity() == 255 and arg_68_0:isVisible() then
			return 
		end
		
		arg_68_0:setOpacity(0)
		arg_68_0:setVisible(true)
		UIAction:Add(FADE_IN(arg_68_2.tm), arg_68_0, "block")
	else
		if arg_68_0:getOpacity() == 0 or not arg_68_0:isVisible() then
			return 
		end
		
		local var_68_0 = NONE()
		
		if arg_68_2.remove then
			var_68_0 = REMOVE(true)
		end
		
		UIAction:Add(SEQ(FADE_OUT(arg_68_2.tm), SHOW(false), var_68_0), arg_68_0, "block")
	end
end

function remove_object(arg_69_0)
	if get_cocos_refid(arg_69_0) then
		arg_69_0:removeFromParent()
	end
end

function close_dlg(arg_70_0)
	UIAction:Add(SEQ(SPAWN(LOG(SCALE(200, 1, 0)), LOG(LAYER_OPACITY(200, 1, 0))), REMOVE()), arg_70_0, "block")
end

function open_dlg(arg_71_0)
	arg_71_0:setOpacity(0)
	UIAction:Add(SEQ(SPAWN(LOG(SCALE(200, 0, 1)), LOG(OPACITY(200, 0, 1)))), arg_71_0, "block")
end

function play_dlg(arg_72_0)
	arg_72_0:setScale(0)
	arg_72_0:setOpacity(0)
	UIAction:Add(SPAWN(FADE_IN(150), SEQ(LOG(SCALE(120, 0, 1)))), arg_72_0, "ui")
end

function get_masked_sprite(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0
	
	if tolua:type(arg_73_0) ~= "string" then
		var_73_0 = arg_73_0
	else
		var_73_0 = cc.Sprite:create(arg_73_0)
	end
	
	local var_73_1
	
	if type(arg_73_1) == "string" then
		var_73_1 = cc.Sprite:create(arg_73_1)
	elseif type(arg_73_1) == "table" then
		local var_73_2 = cc.c3b(255, 255, 255)
		local var_73_3 = var_73_0:getContentSize()
		local var_73_4 = cc.DrawNode:create()
		
		var_73_4:drawPolygon(arg_73_1, 4, var_73_2, 0, var_73_2)
		var_73_4:setPosition(var_73_3.width / 2, var_73_3.height / 2)
	else
		var_73_1 = arg_73_1
	end
	
	local var_73_5 = cc.ClippingNode:create()
	
	var_73_5:setStencil(var_73_1)
	
	if arg_73_2 then
		var_73_5:setAlphaThreshold(arg_73_2)
	end
	
	var_73_5:addChild(var_73_0)
	
	return var_73_5, var_73_1
end

function get_curtain(arg_74_0)
	local var_74_0 = cc.Sprite:create("img/_white_s.png")
	
	var_74_0:setScale(20000)
	var_74_0:setPosition(BattleLayout:convertToFieldPositionX(DESIGN_WIDTH / 2), DESIGN_HEIGHT / 2)
	
	return var_74_0
end

function get_curtain_action(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4, arg_75_5, arg_75_6, arg_75_7, arg_75_8, arg_75_9, arg_75_10)
	local var_75_0 = get_curtain("white")
	
	var_75_0:setOpacity(0)
	
	arg_75_8 = arg_75_8 or 1
	
	if arg_75_7 then
		var_75_0:setLocalZOrder(arg_75_7)
	else
		var_75_0:setLocalZOrder(9999)
	end
	
	var_75_0:setGlobalZOrder(arg_75_10 or 0)
	arg_75_0:addChild(var_75_0)
	
	if arg_75_9 then
		var_75_0:setColor(arg_75_9)
	end
	
	return SEQ(DELAY(arg_75_1), OPACITY(arg_75_2, 0, arg_75_8), DELAY(arg_75_3), OPACITY(arg_75_4, arg_75_8, 0), REMOVE()), var_75_0, arg_75_5
end

function play_curtain(arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4, arg_76_5, arg_76_6, arg_76_7, arg_76_8, arg_76_9, arg_76_10)
	local var_76_0, var_76_1, var_76_2 = get_curtain_action(arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4, arg_76_5, arg_76_6, arg_76_7, arg_76_8, arg_76_9, arg_76_10)
	
	if arg_76_6 then
		Action:AddAsync(var_76_0, var_76_1, var_76_2)
	else
		Action:Add(var_76_0, var_76_1, var_76_2)
	end
end

local var_0_11 = {
	fade = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
		print("_cutin_frame_event", arg_77_1, arg_77_2, arg_77_3, arg_77_4)
		
		local var_77_0, var_77_1, var_77_2 = get_curtain_action(arg_77_0, 0, arg_77_2, arg_77_3, arg_77_4, "cutin_frame_event", false, 0, 1, tocolor(arg_77_1), 10)
		
		UIAction:AddSync(var_77_0, var_77_1, var_77_2)
	end
}

function play_cutin(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
	local var_78_0 = {
		Init = function(arg_79_0)
			SoundEngine:playBattle("event:/cut/" .. arg_78_1)
			arg_79_0.sprite:play()
			arg_79_0:ParseMetaData()
		end,
		ParseMetaData = function(arg_80_0)
			if not arg_80_0.sprite.getMetaData then
				return 
			end
			
			arg_80_0.meta = arg_80_0.sprite:getMetaData("META")
			arg_80_0.frameEvent = {}
			
			local var_80_0 = string.split(arg_80_0.meta, "\n")
			
			for iter_80_0, iter_80_1 in pairs(var_80_0) do
				local var_80_1 = string.split(string.trim(iter_80_1), "\t")
				
				for iter_80_2, iter_80_3 in pairs(var_80_1) do
					var_80_1[iter_80_2] = tonumber(iter_80_3) or iter_80_3
				end
				
				local var_80_2 = var_80_1[1]
				
				if not arg_80_0.frameEvent[var_80_2] then
					arg_80_0.frameEvent[var_80_2] = {}
				end
				
				table.insert(arg_80_0.frameEvent[var_80_2], var_80_1)
			end
		end,
		ExecFrameEvent = function(arg_81_0, arg_81_1)
			if not arg_81_0.frameEvent then
				return 
			end
			
			local var_81_0 = arg_81_0.frameEvent[arg_81_1]
			
			if not var_81_0 then
				return 
			end
			
			arg_81_0.frameEvent[arg_81_1] = nil
			
			for iter_81_0, iter_81_1 in pairs(var_81_0) do
				local var_81_1 = var_0_11[iter_81_1[2]]
				
				if var_81_1 then
					xpcall(var_81_1, __G__TRACKBACK__, arg_78_0, unpack(iter_81_1, 3, table.maxn(iter_81_1)))
				end
			end
		end,
		Update = function(arg_82_0, arg_82_1, arg_82_2)
			if PAUSED then
				arg_82_0.sprite:update(arg_82_2 / 1000)
			end
			
			if CocosSchedulerManager:isUseCustomSchForPoll() then
				arg_82_2 = CUR_PROCESS_DELTA
				
				arg_82_0.sprite:update(arg_82_2)
			end
			
			arg_82_0:ExecFrameEvent(arg_82_0.sprite:getFrameIndex())
		end
	}
	
	function StateHandle.IsFinished(arg_83_0, arg_83_1)
		return arg_83_0._finished
	end
	
	function var_78_0.IsFinished(arg_84_0)
		if not get_cocos_refid(arg_84_0.sprite) then
			return true
		end
		
		return not arg_84_0.sprite:isPlaying()
	end
	
	function var_78_0.Finish(arg_85_0)
		if type(arg_78_4) == "function" then
			arg_78_4(true)
		end
		
		arg_85_0.sprite:removeFromParent()
	end
	
	local var_78_1 = "cut/" .. arg_78_1 .. ".webp"
	local var_78_2 = true
	
	if DEBUG.MOVIE_MODE then
		var_78_2 = false
	end
	
	cc.AniSprite:createAsync(var_78_1, function(arg_86_0, arg_86_1)
		if not get_cocos_refid(arg_86_0) or not get_cocos_refid(arg_78_0) then
			if type(arg_78_4) == "function" then
				arg_78_4(false)
			end
			
			return 
		end
		
		if not arg_86_1 then
			Log.e("리소스 로드 에러", "스킬 : " .. arg_78_1, "파일경로 : " .. var_78_1)
			resume()
			
			return 
		end
		
		local var_86_0 = arg_86_0:getContentSize()
		
		if var_78_2 then
			local var_86_1 = math.floor(var_86_0.width / var_86_0.height * 100) / 100
			local var_86_2 = 1
			
			if var_86_1 <= 1.77 then
				var_86_2 = VIEW_WIDTH_RATIO * (DESIGN_WIDTH / var_86_0.width)
			else
				var_86_2 = DESIGN_HEIGHT / var_86_0.height
			end
			
			arg_86_0:setScale(var_86_2)
		else
			arg_86_0:setScale(DESIGN_HEIGHT / var_86_0.height)
			
			local var_86_3 = cc.Sprite:create("img/_black_s.png")
			local var_86_4 = cc.Sprite:create("img/_black_s.png")
			
			var_86_4:setAnchorPoint(0, 0)
			var_86_4:setPosition(var_86_0.width, 0)
			var_86_4:setScale(VIEW_HEIGHT / 16)
			var_86_3:setAnchorPoint(1, 0)
			var_86_3:setPosition(0, 0)
			var_86_3:setScale(VIEW_HEIGHT / 16)
			arg_86_0:addChild(var_86_4)
			arg_86_0:addChild(var_86_3)
		end
		
		if arg_78_2 then
			arg_86_0:setScaleX(-arg_86_0:getScaleX())
		end
		
		arg_86_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		
		local var_86_5 = arg_86_0:getPlayTime()
		
		print("cutin total_tm ", arg_78_1, var_86_5)
		
		var_78_0.sprite = arg_86_0
		var_78_0.TOTAL_TIME = math.huge
		
		UIAction:Add(SEQ(USER_ACT(var_78_0)), arg_86_0, "battle")
		
		arg_78_3 = arg_78_3 or {
			opacity = 1,
			color = cc.c3b(0, 0, 0)
		}
		
		local var_86_6 = arg_78_3.opacity or 1
		
		if var_86_6 > 0 then
			local var_86_7 = cc.Sprite:create("img/_white_s.png")
			
			var_86_7:setColor(arg_78_3.color or cc.c3b(0, 0, 0))
			var_86_7:setScaleX(DESIGN_WIDTH / 16 * VIEW_WIDTH_RATIO)
			var_86_7:setScaleY(DESIGN_HEIGHT / 16)
			var_86_7:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			var_86_7:setOpacity(0)
			UIAction:Add(SEQ(OPACITY(100, 0, var_86_6), DELAY(var_86_5 - 100), OPACITY(100, var_86_6, 0), REMOVE()), var_86_7, "battle")
			var_86_7:setLocalZOrder(999999888)
			arg_78_0:addChild(var_86_7)
		end
		
		arg_78_0:addChild(arg_86_0)
		arg_86_0:setLocalZOrder(999999888)
	end)
end

function calc_cutin_playtime(arg_87_0, arg_87_1)
	if not arg_87_0 or not arg_87_1 then
		return 
	end
	
	if arg_87_0:getValue("cutin_time_calc_sync") then
		local var_87_0 = "cut/" .. arg_87_1 .. ".webp"
		local var_87_1 = cc.AniSprite:create(var_87_0)
		
		if var_87_1 then
			local var_87_2 = arg_87_0:getValue("cutin_time") or 0
			
			arg_87_0:setValue("cutin_time", var_87_2 + var_87_1:getPlayTime())
		end
	else
		cc.AniSprite:createAsync(spr_name, function(arg_88_0, arg_88_1)
			if arg_88_1 and arg_88_0 then
				local var_88_0 = arg_88_0:getPlayTime()
			end
		end)
	end
end

function show_campos(arg_89_0)
	local var_89_0 = DESIGN_WIDTH * CAM_ANCHOR_X
	local var_89_1 = DESIGN_HEIGHT * 0.2
	local var_89_2 = cc.Layer:create()
	local var_89_3 = SpriteCache:getSprite("icon_road_horizon")
	
	var_89_3:setAnchorPoint(0.5, 0.5)
	var_89_3:setPosition(var_89_0, var_89_1)
	var_89_3:setGlobalZOrder(100)
	var_89_3:setScaleX(40)
	var_89_3:setScaleY(0.5)
	var_89_3:setOpacity(100)
	var_89_2:addChild(var_89_3)
	
	local var_89_4 = SpriteCache:getSprite("icon_road_vertical")
	
	var_89_4:setAnchorPoint(0.5, 0.5)
	var_89_4:setPosition(var_89_0, var_89_1)
	var_89_4:setGlobalZOrder(100)
	var_89_4:setScaleX(0.5)
	var_89_4:setScaleY(30)
	var_89_4:setOpacity(100)
	var_89_2:addChild(var_89_4)
	var_89_2:setName("CAMERA_POSITION")
	
	local var_89_5 = SceneManager:getRunningNativeScene()
	
	var_89_5:removeChildByName("CAMERA_POSITION")
	var_89_5:addChild(var_89_2)
end

local var_0_12

function mark_filter(arg_90_0)
	if type(arg_90_0) == "string" then
		arg_90_0 = string.split(arg_90_0, ",")
	end
	
	if type(arg_90_0) ~= "table" then
		var_0_12 = nil
		
		return 
	end
	
	var_0_12 = {}
	
	for iter_90_0, iter_90_1 in pairs(arg_90_0) do
		var_0_12[iter_90_1] = true
	end
end

function mark(arg_91_0, arg_91_1, arg_91_2, arg_91_3)
	if var_0_12 and not var_0_12[arg_91_2] then
		return 
	end
	
	local var_91_0
	local var_91_1 = arg_91_0:getContentSize()
	
	arg_91_1 = arg_91_1 or cc.c3b(255, 0, 0)
	
	if type(arg_91_1) == "table" then
		local var_91_2 = arg_91_0:getAnchorPoint()
		local var_91_3, var_91_4 = arg_91_0:getPosition()
		local var_91_5 = cc.DrawNode:create(20)
		
		var_91_5:setLocalZOrder(9999999)
		var_91_5:setPosition(0, 0)
		var_91_5:setAnchorPoint(0, 0)
		var_91_5:setName("DEBUG_FRAME")
		var_91_5:drawRect(cc.p(0, 0), cc.p(var_91_1.width, var_91_1.height), cc.c4f(arg_91_1.r / 255, arg_91_1.g / 255, arg_91_1.b / 255, 1))
		var_91_5:drawDot(cc.p(var_91_2.x * var_91_1.width, var_91_2.y * var_91_1.height), 10, cc.c4f(arg_91_1.r / 255, arg_91_1.g / 255, arg_91_1.b / 255, 1))
		var_91_5:setGlobalZOrder(10)
		var_91_5:setColor(cc.c3b(255, 0, 0))
		arg_91_0:addChild(var_91_5)
	else
		local var_91_6 = cc.Sprite:create("img/_notification.png")
		
		var_91_6:setLocalZOrder(9999999)
		var_91_6:setPosition(0, 0)
		arg_91_0:addChild(var_91_6)
		
		local var_91_7 = cc.Sprite:create("img/_notification.png")
		
		var_91_7:setLocalZOrder(9999999)
		var_91_7:setPosition(0, var_91_1.height)
		arg_91_0:addChild(var_91_7)
		
		local var_91_8 = cc.Sprite:create("img/_notification.png")
		
		var_91_8:setLocalZOrder(9999999)
		var_91_8:setPosition(var_91_1.width, var_91_1.height)
		arg_91_0:addChild(var_91_8)
		
		local var_91_9 = cc.Sprite:create("img/_notification.png")
		
		var_91_9:setLocalZOrder(9999999)
		var_91_9:setPosition(var_91_1.width, 0)
		arg_91_0:addChild(var_91_9)
		
		local var_91_10 = cc.Sprite:create("img/_notification_num.png")
		
		var_91_10:setLocalZOrder(9999999)
		var_91_10:setPosition(var_91_1.width / 2, var_91_1.height / 2)
		arg_91_0:addChild(var_91_10)
	end
end

function make_grid()
	local var_92_0 = "@EFFECTTOOL_SCREEN_GRID"
	local var_92_1 = DESIGN_WIDTH * 2
	local var_92_2 = cc.DrawNode:create()
	local var_92_3 = {
		{
			y = 0,
			x = -var_92_1
		},
		{
			y = 0,
			x = -var_92_1
		},
		{
			y = 0,
			x = var_92_1
		},
		{
			0,
			x = var_92_1
		}
	}
	local var_92_4 = {
		{
			x = 0,
			y = -var_92_1
		},
		{
			x = 0,
			y = -var_92_1
		},
		{
			x = 0,
			y = var_92_1
		},
		{
			x = 0,
			y = var_92_1
		}
	}
	local var_92_5 = 0
	local var_92_6 = 0
	local var_92_7 = 2000
	local var_92_8 = 100
	
	for iter_92_0 = var_92_8, var_92_7, var_92_8 do
		var_92_2:drawLine(cc.p(var_92_5 + iter_92_0, -var_92_7), cc.p(var_92_5 + iter_92_0, var_92_7), cc.c4f(1, 1, 0, 1))
		var_92_2:drawLine(cc.p(var_92_5 - iter_92_0, -var_92_7), cc.p(var_92_5 - iter_92_0, var_92_7), cc.c4f(1, 1, 0, 1))
		var_92_2:drawLine(cc.p(-var_92_7, var_92_6 + iter_92_0), cc.p(var_92_7, var_92_6 + iter_92_0), cc.c4f(1, 1, 0, 1))
		var_92_2:drawLine(cc.p(-var_92_7, var_92_6 - iter_92_0), cc.p(var_92_7, var_92_6 - iter_92_0), cc.c4f(1, 1, 0, 1))
	end
	
	var_92_2:drawLine(cc.p(var_92_5, -var_92_7), cc.p(var_92_5, var_92_7), cc.c4f(1, 0, 1, 1))
	var_92_2:drawLine(cc.p(-var_92_7, var_92_6), cc.p(var_92_7, var_92_6), cc.c4f(1, 0, 1, 1))
	var_92_2:setPosition(0, 0)
	var_92_2:setLineWidth(1)
	var_92_2:drawRect(cc.p(-DESIGN_WIDTH * 0.5, -DESIGN_HEIGHT * 0.2), cc.p(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.8), cc.c4f(0, 0, 1, 1))
	
	return var_92_2
end

function make_viewport_rect(arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	arg_93_0 = DESIGN_WIDTH * 0.5
	arg_93_1 = DESIGN_HEIGHT * 0.2
	arg_93_2 = arg_93_2 or DESIGN_WIDTH
	arg_93_3 = arg_93_3 or DESIGN_HEIGHT
	
	local var_93_0 = DESIGN_WIDTH * 2
	local var_93_1 = cc.DrawNode:create()
	local var_93_2 = 0
	local var_93_3 = 0
	local var_93_4 = 2000
	local var_93_5 = 100
	
	var_93_1:setContentSize(0, 0)
	var_93_1:setAnchorPoint(0, 0)
	var_93_1:drawLine(cc.p(var_93_2, -var_93_4), cc.p(var_93_2, var_93_4), cc.c4f(1, 0, 1, 1))
	var_93_1:drawLine(cc.p(-var_93_4, var_93_3), cc.p(var_93_4, var_93_3), cc.c4f(1, 0, 1, 1))
	var_93_1:setPosition(arg_93_0, arg_93_1)
	var_93_1:setLineWidth(1)
	var_93_1:drawRect(cc.p(-arg_93_2 * 0.5, -arg_93_3 * 0.2), cc.p(arg_93_2 * 0.5, arg_93_3 * 0.8), cc.c4f(0, 0, 1, 1))
	var_93_1:drawRect(cc.p(-VIEW_WIDTH * 0.5, -VIEW_HEIGHT * 0.2), cc.p(VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.8), cc.c4f(0, 0.8, 1, 1))
	
	return var_93_1
end

function draw_border(arg_94_0)
	local var_94_0 = cc.DrawNode:create()
	local var_94_1 = arg_94_0:getContentSize()
	local var_94_2 = {
		{
			x = 0,
			y = 0
		},
		{
			x = 0,
			y = var_94_1.height
		},
		{
			x = var_94_1.width,
			y = var_94_1.height
		},
		{
			0,
			x = var_94_1.width
		}
	}
	
	var_94_0:drawPolygon(var_94_2, 4, cc.c4f(0, 0, 0, 0), 3, cc.c4f(1, 0, 0, 1))
	arg_94_0:addChild(var_94_0)
end

function splash_face(arg_95_0, arg_95_1, arg_95_2)
	local var_95_0 = cc.Sprite:create("cut/" .. arg_95_1 .. ".png")
	
	if var_95_0 == nil then
		return 
	end
	
	var_95_0:setRotation(48.5)
	
	arg_95_2 = arg_95_2 or 1.25
	
	var_95_0:setScale(arg_95_2)
	var_95_0:setLocalZOrder(-1)
	
	local var_95_1 = 146 * arg_95_2
	local var_95_2 = DESIGN_HEIGHT - (DESIGN_HEIGHT - 528) * arg_95_2
	local var_95_3 = DESIGN_WIDTH
	
	var_95_0:setPosition(var_95_1 - var_95_3, var_95_2)
	arg_95_0:addChild(var_95_0)
	UIAction:Add(SEQ(LOG(MOVE_TO(150, var_95_1), 500), DELAY(500), FADE_OUT(200), REMOVE()), var_95_0)
end

function capture_texture(arg_96_0)
	arg_96_0 = arg_96_0 or 1
	
	local var_96_0 = cc.RenderTexture:create(DESIGN_WIDTH / arg_96_0, DESIGN_HEIGHT / arg_96_0, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	local var_96_1 = SceneManager:getRunningNativeScene()
	
	var_96_0:begin()
	var_96_1:visit()
	var_96_0:endToLua()
	
	return var_96_0
end

function capture()
	local var_97_0 = 0
	local var_97_1 = 1
	
	capture_texture(var_97_1):saveToFile(string.format("%02d.png", var_97_0))
	
	local var_97_2 = var_97_0 + 1
end

function capture_node(arg_98_0, arg_98_1)
	local var_98_0 = arg_98_0:getContentSize()
	local var_98_1 = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
	local var_98_2
	
	if arg_98_1 then
		var_98_2 = cc.RenderTexture:create(var_98_0.width, var_98_0.height, var_98_1, arg_98_1)
	else
		var_98_2 = cc.RenderTexture:create(var_98_0.width, var_98_0.height, var_98_1)
	end
	
	var_98_2:setKeepMatrix(false)
	var_98_2:begin()
	arg_98_0:visit()
	var_98_2:endToLua()
	force_render()
	
	return var_98_2
end

function capture_bg(arg_99_0, arg_99_1)
	arg_99_1 = arg_99_1 or 8
	
	local var_99_0 = arg_99_0:getContentSize()
	local var_99_1 = cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888
	local var_99_2 = cc.RenderTexture:create(var_99_0.width / arg_99_1, var_99_0.height / arg_99_1, var_99_1)
	local var_99_3 = arg_99_0:getScale()
	local var_99_4, var_99_5 = arg_99_0:getPosition()
	local var_99_6 = arg_99_0:getAnchorPoint()
	
	arg_99_0:setScale(var_99_3 / arg_99_1)
	arg_99_0:setPosition(0, 0)
	arg_99_0:setAnchorPoint(0, 0)
	var_99_2:setKeepMatrix(false)
	var_99_2:begin()
	arg_99_0:visit()
	var_99_2:endToLua()
	force_render()
	arg_99_0:setAnchorPoint(var_99_6.x, var_99_6.y)
	arg_99_0:setPosition(var_99_4, var_99_5)
	arg_99_0:setScale(var_99_3)
	
	local var_99_7 = cc.Sprite:createWithTexture(var_99_2:getSprite():getTexture())
	
	var_99_7:getTexture():setAntiAliasTexParameters()
	
	return var_99_7
end

local var_0_13 = {}

function vartrace(arg_100_0, arg_100_1)
	if arg_100_1 ~= var_0_13[arg_100_0] then
		print("vartrace ", arg_100_0, "=>", arg_100_1)
		
		var_0_13[arg_100_0] = arg_100_1
	end
end

function slowpick(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4)
	if not arg_101_1 then
		return 
	end
	
	arg_101_4 = arg_101_4 or {}
	
	local var_101_0 = 8
	local var_101_1 = cc.Director:getInstance():getWinSize()
	
	arg_101_2 = arg_101_2 - (var_101_1.width - DESIGN_WIDTH) / 2
	arg_101_3 = arg_101_3 - (var_101_1.height - DESIGN_HEIGHT) / 2
	
	local var_101_2 = DESIGN_HEIGHT - arg_101_3
	
	if var_101_2 < 0 or var_101_2 > DESIGN_HEIGHT then
		return 
	end
	
	local var_101_3 = cc.RenderTexture:create(DESIGN_WIDTH / var_101_0, DESIGN_HEIGHT / var_101_0, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	local var_101_4 = arg_101_0:getScale()
	local var_101_5, var_101_6 = arg_101_0:getPosition()
	
	arg_101_0:setScale(var_101_4 / var_101_0)
	arg_101_0:setPosition(var_101_5 / var_101_0, var_101_6 / var_101_0)
	
	local var_101_7 = {}
	
	for iter_101_0, iter_101_1 in pairs(arg_101_1) do
		local var_101_8 = iter_101_1
		local var_101_9 = 0
		
		if type(iter_101_1) == "table" then
			iter_101_1 = iter_101_1.spr or iter_101_1.model
		end
		
		if get_cocos_refid(iter_101_1) then
			if get_cocos_refid(iter_101_1.body) then
				iter_101_1 = iter_101_1.body
			end
			
			var_101_9 = iter_101_1:getLocalZOrder()
		end
		
		if var_101_8.inst and var_101_8.y then
			var_101_9 = 1000 - var_101_8.y
		end
		
		if get_cocos_refid(iter_101_1) then
			table.insert(var_101_7, {
				iter_101_0,
				iter_101_1,
				var_101_9,
				var_101_8
			})
		end
	end
	
	table.sort(var_101_7, function(arg_102_0, arg_102_1)
		return arg_102_0[3] > arg_102_1[3]
	end)
	
	local var_101_10
	
	for iter_101_2, iter_101_3 in ipairs(var_101_7) do
		local var_101_11 = iter_101_3[2]
		local var_101_12 = 2
		local var_101_13 = 3
		local var_101_14 = 1
		
		var_101_3:begin()
		
		local var_101_15 = cc.Camera:getVisitingCamera()
		
		var_101_15:setCameraFlag(var_101_12)
		
		local var_101_16 = var_101_11:getCameraMask()
		
		var_101_11:setCameraMask(var_101_13, false)
		arg_101_0:visit()
		var_101_11:setCameraMask(var_101_16, false)
		var_101_15:setCameraFlag(var_101_14)
		var_101_3:endToLua()
		force_render()
		
		local var_101_17 = var_101_3:newImage()
		local var_101_18, var_101_19, var_101_20, var_101_21 = get_pixel(var_101_17, arg_101_2 / var_101_0, var_101_2 / var_101_0)
		
		var_101_17:release()
		
		if var_101_21 > 0 then
			var_101_10 = iter_101_3[1]
			
			break
		end
	end
	
	arg_101_0:setScale(var_101_4)
	arg_101_0:setPosition(var_101_5, var_101_6)
	force_render()
	
	return var_101_10
end

function slowpick2(arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
	if not arg_103_1 then
		return 
	end
	
	arg_103_4 = arg_103_4 or {}
	
	local var_103_0 = 8
	local var_103_1 = cc.Director:getInstance():getWinSize()
	
	arg_103_2 = arg_103_2 - (var_103_1.width - DESIGN_WIDTH) / 2
	arg_103_3 = arg_103_3 - (var_103_1.height - DESIGN_HEIGHT) / 2
	
	local var_103_2 = DESIGN_HEIGHT - arg_103_3
	
	if var_103_2 < 0 or var_103_2 > DESIGN_HEIGHT then
		return 
	end
	
	if arg_103_2 < 0 or arg_103_2 > DESIGN_WIDTH then
		return 
	end
	
	local var_103_3 = cc.RenderTexture:create(DESIGN_WIDTH / var_103_0, DESIGN_HEIGHT / var_103_0, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	local var_103_4 = arg_103_0:getScale()
	local var_103_5, var_103_6 = arg_103_0:getPosition()
	
	arg_103_0:setScale(var_103_4 / var_103_0)
	arg_103_0:setPosition(var_103_5 / var_103_0, var_103_6 / var_103_0)
	
	local var_103_7 = {}
	
	for iter_103_0, iter_103_1 in pairs(arg_103_1) do
		local var_103_8 = iter_103_1
		local var_103_9 = 0
		
		if type(iter_103_1) == "table" then
			iter_103_1 = iter_103_1.spr or iter_103_1.model
		end
		
		if get_cocos_refid(iter_103_1) then
			if get_cocos_refid(iter_103_1.body) then
				iter_103_1 = iter_103_1.body
			end
			
			var_103_9 = iter_103_1:getLocalZOrder()
		end
		
		if var_103_8.inst and var_103_8.y then
			var_103_9 = 1000 - var_103_8.y
		end
		
		if get_cocos_refid(iter_103_1) then
			table.insert(var_103_7, {
				iter_103_0,
				iter_103_1,
				var_103_9,
				var_103_8
			})
		end
	end
	
	table.sort(var_103_7, function(arg_104_0, arg_104_1)
		return arg_104_0[3] > arg_104_1[3]
	end)
	
	local var_103_10
	
	for iter_103_2, iter_103_3 in ipairs(var_103_7) do
		local var_103_11 = iter_103_3[2]
		local var_103_12 = 2
		local var_103_13 = 3
		local var_103_14 = 1
		
		var_103_3:begin()
		
		local var_103_15 = cc.Camera:getVisitingCamera()
		
		var_103_15:setCameraFlag(var_103_12)
		
		local var_103_16 = var_103_11:getCameraMask()
		
		var_103_11:setCameraMask(var_103_13, false)
		arg_103_0:visit()
		var_103_11:setCameraMask(var_103_16, false)
		var_103_15:setCameraFlag(var_103_14)
		var_103_3:endToLua()
		force_render()
		
		local var_103_17 = var_103_3:newImage()
		local var_103_18, var_103_19, var_103_20, var_103_21 = get_pixel(var_103_17, arg_103_2 / var_103_0, var_103_2 / var_103_0)
		
		var_103_17:release()
		
		if var_103_21 > 0 then
			var_103_10 = iter_103_3[1]
			
			break
		end
	end
	
	arg_103_0:setScale(var_103_4)
	arg_103_0:setPosition(var_103_5, var_103_6)
	force_render()
	
	return var_103_10
end

function slowpick_boundbox(arg_105_0, arg_105_1, arg_105_2, arg_105_3)
	local var_105_0 = {}
	
	for iter_105_0, iter_105_1 in ipairs(arg_105_1) do
		if type(iter_105_1) == "table" then
			iter_105_1 = iter_105_1.spr or iter_105_1.model
		end
		
		if iter_105_1 then
			table.insert(var_105_0, {
				idx = iter_105_0,
				target = iter_105_1
			})
		end
	end
	
	for iter_105_2, iter_105_3 in pairs(var_105_0) do
		local var_105_1 = iter_105_3.target:getBoundingBox()
		
		table.print(var_105_1)
	end
end

function childs(arg_106_0, arg_106_1)
	for iter_106_0, iter_106_1 in pairs(arg_106_0:getChildren()) do
		if iter_106_1.getString then
			print(tolua.type(iter_106_1), iter_106_1:getName(), iter_106_1:getString())
		else
			print(tolua.type(iter_106_1), iter_106_1:getName())
		end
		
		if arg_106_1 then
			print(iter_106_1:isTouchEnabled())
		end
	end
end

function containsPoint(arg_107_0, arg_107_1, arg_107_2)
	if arg_107_1 > arg_107_0.x and arg_107_2 > arg_107_0.y and arg_107_1 < arg_107_0.x + arg_107_0.width and arg_107_2 < arg_107_0.y + arg_107_0.height then
		return true
	end
end

function bgmode()
	BGI.main.layer:setVisible(false)
	BGI.ui_layer:setVisible(false)
	BGI:setScale(1)
	setenv("time_scale", 0.2)
	BattleLayout:setWalking(true)
end

function get_text(arg_109_0, arg_109_1)
	arg_109_0 = arg_109_0 or ""
	arg_109_1 = arg_109_1 or 24
	
	local var_109_0 = 1
	
	if arg_109_1 > 24 then
		var_109_0 = 2
	end
	
	local var_109_1 = ccui.Text:create()
	
	var_109_1:setContentSize({
		width = 150,
		height = 100
	})
	var_109_1:setFontName("font/daum.ttf")
	var_109_1:setColor(cc.c3b(255, 255, 200), cc.c3b(255, 255, 200))
	var_109_1:enableOutline(cc.c3b(0, 0, 0), var_109_0)
	var_109_1:setFontSize(arg_109_1)
	var_109_1:setAnchorPoint(0.5, 0.5)
	var_109_1:setString(arg_109_0)
	
	return var_109_1
end

function show_ui(arg_110_0)
	local var_110_0 = SceneManager:getDefaultLayer()
	
	dlg = Dialog:open(arg_110_0)
	
	var_110_0:addChild(dlg)
	childs(dlg)
	
	return dlg
end

function checkCollisionDynamic(arg_111_0, arg_111_1, arg_111_2, arg_111_3)
	local var_111_0 = arg_111_0:getContentSize()
	local var_111_1 = arg_111_0:convertToNodeSpace({
		x = arg_111_1,
		y = arg_111_2
	})
	local var_111_2 = 0
	local var_111_3 = 0
	local var_111_4 = 0
	local var_111_5 = 0
	
	if arg_111_3 then
		var_111_2 = arg_111_3.left or 0
		var_111_3 = arg_111_3.right or 0
		var_111_4 = arg_111_3.top or 0
		var_111_5 = arg_111_3.bottom or 0
	end
	
	return var_111_2 <= var_111_1.x and var_111_1.x <= var_111_0.width + var_111_3 and var_111_5 <= var_111_1.y and var_111_1.y <= var_111_0.height + var_111_4
end

function checkCollision(arg_112_0, arg_112_1, arg_112_2, arg_112_3)
	local var_112_0 = arg_112_0:getContentSize()
	local var_112_1 = arg_112_0:convertToNodeSpace({
		x = arg_112_1,
		y = arg_112_2
	})
	local var_112_2 = 0
	local var_112_3 = 0
	local var_112_4 = 0
	local var_112_5 = 0
	
	if arg_112_3 and arg_112_3.add_width then
		var_112_2 = arg_112_3.add_width
	end
	
	if arg_112_3 and arg_112_3.add_height then
		var_112_3 = arg_112_3.add_height
	end
	
	return var_112_1.x + var_112_4 >= 0 and var_112_1.x + var_112_4 <= var_112_0.width + var_112_2 and var_112_1.y + var_112_5 >= 0 and var_112_1.y + var_112_5 <= var_112_0.height + var_112_3
end

function getSprite(arg_113_0, arg_113_1, arg_113_2)
	local var_113_0 = SpriteCache:getSprite(arg_113_0)
	
	if var_113_0 == nil then
		var_113_0 = SpriteCache:getSprite("img/404.png")
		
		local var_113_1 = get_text(arg_113_0)
		
		var_113_1:setScale(0.75)
		var_113_0:addChild(var_113_1)
		
		if arg_113_1 then
			local var_113_2 = arg_113_1:getContentSize()
			
			var_113_0:setScale(var_113_2.width / 229, var_113_2.height / 228)
			
			local var_113_3, var_113_4 = arg_113_1:getPosition()
			
			var_113_0:setPosition(var_113_3, var_113_4)
		else
			var_113_0:setScale(1)
		end
	end
	
	return var_113_0
end

function replaceSprite(arg_114_0, arg_114_1, arg_114_2)
	local var_114_0 = arg_114_0:getChildByName(arg_114_1)
	
	if not SpriteCache:resetSprite(var_114_0, arg_114_2) then
		SpriteCache:resetSprite(var_114_0, "ui/404.png")
	end
	
	return var_114_0
end

local var_0_14 = {
	white = cc.c3b(255, 255, 255),
	red = cc.c3b(255, 0, 0),
	green = cc.c3b(0, 255, 0),
	blue = cc.c3b(0, 0, 255),
	null = cc.c4b(0, 0, 0, 0)
}

function parse_color(arg_115_0)
	if string.sub(arg_115_0, 1, 1) == "#" then
		local var_115_0 = {}
		local var_115_1 = string.sub(arg_115_0, 2)
		
		for iter_115_0 = 1, string.len(var_115_1) - 1, 2 do
			table.insert(var_115_0, tonumber("0x" .. string.sub(var_115_1, iter_115_0, iter_115_0 + 1)) or 0)
		end
		
		if #var_115_0 < 4 then
			return cc.c3b(tonumber(var_115_0[1]) or 0, tonumber(var_115_0[2]) or 0, tonumber(var_115_0[3]) or 0)
		end
		
		return cc.c4b(tonumber(var_115_0[1]) or 0, tonumber(var_115_0[2]) or 0, tonumber(var_115_0[3]) or 0, tonumber(var_115_0[4]) or 255)
	end
	
	local var_115_2 = string.split(string.gsub(arg_115_0, " ", ""), ",")
	
	return cc.c4b(tonumber(var_115_2[1]) or 0, tonumber(var_115_2[2]) or 0, tonumber(var_115_2[3]) or 0, tonumber(var_115_2[4]) or 255)
end

function tocolor(arg_116_0)
	arg_116_0 = string.lower(arg_116_0 or "null")
	
	return var_0_14[arg_116_0] or parse_color(arg_116_0)
end

function toc4f(arg_117_0)
	return cc.c4f(arg_117_0.r / 255, arg_117_0.g / 255, arg_117_0.b / 255, (arg_117_0.a or 255) / 255)
end

function is_stopped(arg_118_0)
	return arg_118_0["-stopped"]
end

function stop_or_remove(arg_119_0, arg_119_1)
	local function var_119_0(arg_120_0)
		if not get_cocos_refid(arg_120_0) then
			return 
		end
		
		if arg_120_0.stop then
			arg_120_0:stop()
			
			arg_120_0["-stopped"] = true
			
			Scheduler:add(arg_120_0, function()
				if not arg_120_0:getParent() and not arg_120_0:isContainsPoolManager() then
					local var_121_0 = arg_120_0:getName()
					
					arg_120_0:release()
					print("--cobj:release()", var_121_0)
				end
			end)
		elseif arg_120_0:getParent() then
			arg_120_0:removeFromParent()
		else
			arg_120_0:release()
		end
	end
	
	if get_cocos_refid(arg_119_0) then
		if arg_119_0["-stop-removed"] then
			return 
		end
		
		arg_119_0["-stop-removed"] = true
		
		arg_119_0:setName("*" .. arg_119_0:getName())
		release_cocos_ref(arg_119_0, 1)
		
		arg_119_1 = tonumber(arg_119_1)
		
		if arg_119_1 then
			Action:Add(SEQ(DELAY(arg_119_1), CALL(var_119_0, arg_119_0)), arg_119_0)
		else
			var_119_0(arg_119_0)
		end
	end
end

function table_property(arg_122_0, arg_122_1)
	setmetatable(arg_122_0, {
		__index = function(arg_123_0, arg_123_1)
			local var_123_0 = rawget(arg_123_0["-prop"], arg_123_1)
			
			if var_123_0 then
				return var_123_0()
			end
		end
	})
	
	arg_122_0["-prop"] = arg_122_1
end

function table_prevent_nil(arg_124_0)
	setmetatable(arg_124_0, {
		__index = function(arg_125_0, arg_125_1)
			local var_125_0 = rawget(arg_125_0, arg_125_1)
			
			if var_125_0 then
				return var_125_0
			end
			
			return arg_125_1
		end
	})
end

function get_skillpt_id(arg_126_0)
	local var_126_0 = DB("skill", arg_126_0, "skillact")
	
	if var_126_0 == nil then
		var_126_0 = arg_126_0
	end
	
	return var_126_0
end

function get_difficulty_id(arg_127_0, arg_127_1)
	return DB("level_difficulty", arg_127_0, "difficulty_" .. tostring(arg_127_1))
end

function get_max_difficulty_level(arg_128_0)
	local var_128_0 = 0
	
	for iter_128_0 = 1, 999 do
		if not get_difficulty_id(arg_128_0, iter_128_0) then
			break
		end
		
		var_128_0 = iter_128_0
	end
	
	return var_128_0
end

function enter_id_to_difficulty_level(arg_129_0, arg_129_1, arg_129_2)
	local var_129_0 = 0
	
	for iter_129_0 = 1, arg_129_2 do
		local var_129_1 = get_difficulty_id(arg_129_1, iter_129_0)
		
		if not var_129_1 then
			break
		end
		
		if var_129_1 == arg_129_0 then
			var_129_0 = iter_129_0
			
			break
		end
	end
	
	return var_129_0
end

function sec_to_string(arg_130_0, arg_130_1, arg_130_2)
	arg_130_2 = arg_130_2 or {}
	
	local var_130_0 = math.floor(arg_130_0 / 60)
	local var_130_1 = math.floor(var_130_0 / 60)
	local var_130_2 = math.floor(var_130_1 / 24)
	local var_130_3 = math.floor(var_130_2 / 30)
	local var_130_4 = math.floor(var_130_2 / 365)
	
	if not arg_130_1 and not arg_130_2.hour_limit then
		if var_130_4 > 0 then
			return T("remain_year", {
				year = var_130_4
			})
		elseif var_130_3 > 0 then
			return T("remain_month", {
				month = var_130_3
			})
		elseif var_130_2 > 0 or arg_130_2.day_floor then
			return T("remain_day", {
				day = var_130_2
			})
		end
	end
	
	if arg_130_1 then
		return string.format("%02d:%02d:%02d", var_130_1, var_130_0 % 60, arg_130_0 % 60)
	end
	
	if var_130_1 > 0 or arg_130_1 then
		return T("remain_hour", {
			hour = var_130_1
		})
	elseif var_130_0 > 0 then
		return T("remain_min", {
			min = var_130_0
		})
	elseif arg_130_0 < 0 and arg_130_2.login_tm then
		return T("recent_login_tm_correct", "방금")
	else
		return T("remain_sec", {
			sec = arg_130_0
		})
	end
end

function sec_to_full_string(arg_131_0, arg_131_1, arg_131_2)
	arg_131_2 = arg_131_2 or {}
	
	local var_131_0 = math.floor(arg_131_0 / 86400)
	
	arg_131_0 = arg_131_0 - var_131_0 * 86400
	
	local var_131_1 = math.floor(arg_131_0 / 3600)
	
	arg_131_0 = arg_131_0 - var_131_1 * 3600
	
	local var_131_2 = math.floor(arg_131_0 / 60)
	
	arg_131_0 = arg_131_0 - var_131_2 * 60
	
	local var_131_3 = 0
	local var_131_4 = ""
	
	if var_131_0 > 0 and (not arg_131_2.count or var_131_3 < arg_131_2.count) then
		var_131_4 = var_131_4 .. " " .. T("remain_day", {
			day = var_131_0
		})
		var_131_3 = var_131_3 + 1
	end
	
	if var_131_1 > 0 and (not arg_131_2.count or var_131_3 < arg_131_2.count) then
		var_131_4 = var_131_4 .. " " .. T("remain_hour", {
			hour = var_131_1
		})
		var_131_3 = var_131_3 + 1
	end
	
	if var_131_2 > 0 and not arg_131_2.no_min and (not arg_131_2.count or var_131_3 < arg_131_2.count) then
		var_131_4 = var_131_4 .. " " .. T("remain_min", {
			min = var_131_2
		})
		var_131_3 = var_131_3 + 1
	end
	
	if not arg_131_2.no_min and var_131_1 < 1 and var_131_0 < 1 and (not arg_131_2.count or var_131_3 < arg_131_2.count) or arg_131_1 then
		var_131_4 = var_131_4 .. " " .. T("remain_sec", {
			sec = arg_131_0
		})
	end
	
	return var_131_4
end

function to_var_str(arg_132_0, arg_132_1, arg_132_2, arg_132_3)
	arg_132_2 = arg_132_2 or 0
	
	local var_132_0 = arg_132_3 and "" or "%%"
	
	if UNIT.is_percentage_stat(arg_132_1) then
		arg_132_0 = (arg_132_0 or 0) * 100
		
		if math.floor(arg_132_0) == math.ceil(arg_132_0) then
			arg_132_0 = string.format("%d" .. var_132_0, arg_132_0)
		else
			arg_132_0 = string.format("%." .. arg_132_2 .. "f" .. var_132_0, arg_132_0)
		end
	else
		arg_132_0 = math.floor(arg_132_0)
	end
	
	return comma_value(arg_132_0)
end

function load_tsv(arg_133_0, arg_133_1)
	local var_133_0 = cc.FileUtils:getInstance():getStringFromFile(arg_133_0)
	local var_133_1 = string.split(var_133_0, "\n")
	local var_133_2 = {}
	local var_133_3
	
	for iter_133_0, iter_133_1 in ipairs(var_133_1) do
		local var_133_4 = string.split(string.trim(iter_133_1), "\t")
		
		if arg_133_1 then
			table.insert(var_133_2, var_133_4)
		elseif not var_133_3 then
			var_133_3 = var_133_4
		else
			local var_133_5 = {}
			
			for iter_133_2, iter_133_3 in ipairs(var_133_3) do
				var_133_5[var_133_3[iter_133_2]] = var_133_4[iter_133_2]
			end
			
			table.insert(var_133_2, var_133_5)
		end
	end
	
	return var_133_2
end

function on_net_error(arg_134_0, arg_134_1, arg_134_2)
	local var_134_0
	
	if not arg_134_1 then
		print("ON_NET_ERROR > " .. arg_134_0)
	elseif arg_134_1 == "UserLocked" then
		var_134_0 = Dialog:msgBox(T("user_lock"))
	elseif arg_134_1 == "session_error" then
		var_134_0 = Dialog:msgBox(T("session_error"))
	elseif arg_134_1 == "access_denied" then
		var_134_0 = Dialog:msgBox(T("session_error_desc"), {
			txt_code = T("code") .. " : " .. "err_ad"
		})
	else
		if string.starts(arg_134_1, "no_") then
			local var_134_1 = string.sub(arg_134_1, 4, -1)
			
			if Account:isCurrencyType(var_134_1) then
				UIUtil:checkCurrencyDialog(var_134_1)
				
				return 
			end
		end
		
		local var_134_2 = T(arg_134_0 .. "." .. arg_134_1)
		
		if var_134_2 then
			if arg_134_2.err_next_scene then
				var_134_0 = Dialog:msgBox(var_134_2, {
					handler = function()
						SceneManager:nextScene(arg_134_2.err_next_scene)
					end
				})
			else
				var_134_0 = Dialog:msgBox(var_134_2)
			end
		end
	end
	
	if get_cocos_refid(var_134_0) then
		var_134_0:bringToFront()
	end
end

function getLankText(arg_136_0)
	local var_136_0 = {
		"st",
		"rd",
		""
	}
end

function create_label(arg_137_0)
	local var_137_0 = ccui.Text:create()
	
	var_137_0:ignoreContentAdaptWithSize(true)
	var_137_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	var_137_0:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	var_137_0:setFontSize(24)
	var_137_0:setFontName("font/daum.ttf")
	var_137_0:enableOutline(cc.c3b(0, 0, 0), 1)
	var_137_0:setString(arg_137_0)
	
	return var_137_0
end

function set_scrollview_text(arg_138_0, arg_138_1, arg_138_2, arg_138_3)
	arg_138_3 = arg_138_3 or {}
	
	local var_138_0 = arg_138_0:getContentSize()
	local var_138_1 = create_label(arg_138_1)
	local var_138_2 = 0.75
	
	var_138_1:setScale(var_138_2)
	var_138_1:setAnchorPoint(0, 1)
	var_138_1:setLocalZOrder(0)
	
	if arg_138_2 then
		var_138_1:setTextAreaSize({
			height = 0,
			width = var_138_0.width / var_138_2
		})
	end
	
	local var_138_3 = 0
	
	if arg_138_3.line_spacing then
		var_138_1:setLineSpacing(arg_138_3.line_spacing)
		
		var_138_3 = var_138_1:getStringNumLines() * (arg_138_3.line_spacing * 0.3)
	end
	
	if arg_138_3.opacity then
		var_138_1:setOpacity(arg_138_3.opacity)
	end
	
	if arg_138_3.outline_color then
		var_138_1:enableOutline(arg_138_3.outline_color, arg_138_3.outline_size or 1)
	end
	
	local var_138_4 = var_138_1:getContentSize()
	
	var_138_1:setPosition(0, math.max(var_138_0.height + var_138_3, var_138_4.height * var_138_2 + var_138_3))
	arg_138_0:addChild(var_138_1)
	arg_138_0:setInnerContainerSize({
		width = var_138_0.width,
		height = math.max(var_138_0.height + var_138_3, var_138_4.height * var_138_2 + var_138_3)
	})
	
	return var_138_1
end

function getFaceSprite(arg_139_0)
	local var_139_0 = SpriteCache:getSprite("face/" .. arg_139_0 .. "_su.png")
	
	if var_139_0 == nil then
		var_139_0 = SpriteCache:getSprite("face/no_face_su.png")
	end
	
	return var_139_0
end

function get_texture_filename(arg_140_0)
	local var_140_0 = string.gsub(arg_140_0, ".png$", ".sct")
	
	if var_140_0 ~= arg_140_0 and cc.FileUtils:getInstance():isFileExist(var_140_0) then
		return var_140_0
	end
	
	return arg_140_0
end

function get_texture_object(arg_141_0)
	return cc.Director:getInstance():getTextureCache():addImage(get_texture_filename(arg_141_0))
end

function check_cool_time(arg_142_0, arg_142_1, arg_142_2, arg_142_3, arg_142_4, arg_142_5)
	if not ccexp.VideoPlayer.getDuration and arg_142_3 then
		arg_142_3()
		
		return 
	end
	
	if UIAction:Find(arg_142_1) then
		if type(arg_142_3) == "function" then
			arg_142_3()
		end
		
		if arg_142_5 then
			UIAction:Remove(arg_142_1)
		end
		
		return true
	else
		if type(arg_142_4) == "function" then
			arg_142_4()
		end
		
		UIAction:Add(DELAY(arg_142_2), arg_142_0, arg_142_1)
		
		return false
	end
end

G_CURRENT_MOVIE_CLIP = nil

function create_movie_clip(arg_143_0, arg_143_1, arg_143_2, arg_143_3)
	local function var_143_0()
		local var_144_0 = 3
		local var_144_1 = cc.Node:create()
		
		var_144_1:setPosition(VIEW_BASE_LEFT, var_144_0)
		var_144_1:setVisible(false)
		var_144_1:setCascadeOpacityEnabled(true)
		
		local var_144_2 = cc.LayerColor:create(cc.c3b(100, 100, 100))
		
		var_144_2:setContentSize(VIEW_WIDTH, var_144_0)
		var_144_2:setPosition(0, 0)
		var_144_2:setLocalZOrder(10)
		
		local var_144_3 = cc.LayerColor:create(cc.c3b(255, 255, 255))
		
		var_144_3:setContentSize(0, var_144_0)
		var_144_3:setPosition(0, 0)
		var_144_3:setLocalZOrder(20)
		var_144_1:addChild(var_144_2)
		var_144_1:addChild(var_144_3)
		
		local var_144_4 = {
			show = function(arg_145_0, arg_145_1)
				if not arg_145_0.base then
					return 
				end
				
				if UIAction:Find("loading_bar") then
					UIAction:Remove("loading_bar")
				end
				
				arg_145_0.visible = arg_145_1
				
				if arg_145_1 then
					UIAction:Add(FADE_IN(1000), arg_145_0.base, "loading_bar")
				else
					UIAction:Add(FADE_OUT(1000, true), arg_145_0.base, "loading_bar")
				end
			end,
			update = function(arg_146_0, arg_146_1)
				if not arg_146_0.front_bar then
					return 
				end
				
				arg_146_0.front_bar:setContentSize(VIEW_WIDTH * arg_146_1, 3)
			end
		}
		
		var_144_4.visible = false
		var_144_4.base = var_144_1
		var_144_4.front_bar = var_144_3
		
		return var_144_4
	end
	
	local function var_143_1()
		local var_147_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_147_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_147_0:setPosition(VIEW_BASE_LEFT, 0)
		var_147_0:setOpacity(100)
		var_147_0:setVisible(false)
		
		local var_147_1 = ccui.Text:create()
		
		var_147_1:setFontName("font/daum.ttf")
		var_147_1:setColor(cc.c3b(241, 241, 241))
		var_147_1:enableOutline(cc.c3b(0, 0, 0), 1)
		var_147_1:setFontSize(24)
		var_147_1:setString(T("err_downloading_data"))
		var_147_1:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
		var_147_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		var_147_0:addChild(var_147_1)
		
		local var_147_2 = {
			show = function(arg_148_0, arg_148_1)
				if not arg_148_0.base then
					return 
				end
				
				if UIAction:Find("wait_label") then
					UIAction:Remove("wait_label")
				end
				
				arg_148_0.visible = arg_148_1
				
				if arg_148_1 then
					UIAction:Add(FADE_IN(1000), arg_148_0.base, "wait_label")
				else
					UIAction:Add(FADE_OUT(1000, true), arg_148_0.base, "wait_label")
				end
			end
		}
		
		var_147_2.visible = false
		var_147_2.base = var_147_0
		
		return var_147_2
	end
	
	local var_143_2 = cc.FileUtils:getInstance()
	
	if not var_143_2 then
		return 
	end
	
	local var_143_3 = var_143_2:fullPathForFilename(arg_143_0)
	local var_143_4 = ccexp.VideoPlayer:new()
	
	var_143_4:setName("movie_clip")
	var_143_4:setFileName(var_143_3)
	var_143_4:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	var_143_4:setKeepAspectRatioEnabled(true)
	var_143_4:setCascadeOpacityEnabled(true)
	var_143_4:setPosition(0, 0)
	
	local var_143_5 = UIOption:isMute("voice") and 0 or SoundEngine:getVolume("voice")
	
	var_143_4:setVolume(var_143_5)
	
	local function var_143_6()
		if not var_143_4 then
			return 
		end
		
		var_143_4._play_time = uitick()
		
		var_143_4:setOpacity(0)
		UIAction:Add(SEQ(FADE_IN(CINEMA_FI_TIME), COND_LOOP(DELAY(100), function()
			if not var_143_4 then
				return true
			end
			
			if not var_143_4:isPlaying() then
				return true
			end
			
			local var_150_0 = var_143_4:getDuration()
			
			if var_150_0 > CINEMA_FO_TIME and var_150_0 - (uitick() - var_143_4._play_time) < CINEMA_FO_TIME then
				return true
			end
		end), FADE_OUT(CINEMA_FO_TIME)), var_143_4)
		var_143_4:play()
	end
	
	if string.starts(var_143_3, "https") and var_143_2.getFileIOFromFile then
		var_143_4.wait_label = var_143_1()
		
		var_143_4:addChild(var_143_4.wait_label.base)
		
		var_143_4.loading_bar = var_143_0()
		
		var_143_4:addChild(var_143_4.loading_bar.base)
		
		local var_143_7 = 307200
		local var_143_8 = 1e-05
		local var_143_9 = -1
		local var_143_10 = false
		local var_143_11 = false
		local var_143_12 = 0
		
		local function var_143_13(arg_151_0)
			if not var_143_4 then
				return 
			end
			
			if arg_151_0 and var_143_4.loading_bar then
				var_143_4.loading_bar:show(true)
			end
			
			var_143_9 = os.time()
			var_143_4._start_time = os.time()
		end
		
		local function var_143_14(arg_152_0)
			if not var_143_4 then
				return 
			end
			
			if not var_143_4.loading_bar then
				return 
			end
			
			if not var_143_4.wait_label then
				return 
			end
			
			if not var_143_4:isPlaying() then
				if arg_152_0 >= 1 then
					if arg_143_1 then
						var_143_6()
					else
						var_143_4.ready_to_play = true
						
						if var_143_4.transition_done then
							var_143_6()
						end
					end
					
					return 
				end
				
				if not var_143_10 and os.time() - var_143_9 < 1 then
					var_143_11 = var_143_4:getBytePerSec() < var_143_7 and arg_152_0 < MIN_DOWNLOAD_RATE
					
					if var_143_11 then
						var_143_10 = true
					end
				else
					var_143_10 = true
					
					if var_143_11 then
						if arg_152_0 < MIN_DOWNLOAD_RATE then
							if var_143_4.wait_label and not var_143_4.wait_label.visible then
								var_143_4.wait_label:show(true)
							end
						else
							if var_143_4.wait_label and var_143_4.wait_label.visible then
								var_143_4.wait_label:show(false)
							end
							
							if arg_143_1 then
								var_143_6()
							else
								var_143_4.ready_to_play = true
								
								if var_143_4.transition_done then
									var_143_6()
								end
							end
						end
					elseif arg_143_1 then
						var_143_6()
					else
						var_143_4.ready_to_play = true
						
						if var_143_4.transition_done then
							var_143_6()
						end
					end
				end
			end
			
			if var_143_4.loading_bar then
				var_143_4.loading_bar:update(arg_152_0)
			end
		end
		
		local function var_143_15(arg_153_0)
			if not var_143_4 then
				return 
			end
			
			if arg_153_0 and var_143_4.loading_bar then
				var_143_4.loading_bar:show(false)
			end
		end
		
		var_143_4:load()
		
		if var_143_4:isDownloadCompleted() then
			var_143_13(false)
			var_143_14(1)
			var_143_15(false)
		else
			local var_143_16 = false
			
			UIAction:Add(COND_LOOP(DELAY(100), function()
				if not var_143_4 then
					return true
				end
				
				local var_154_0 = var_143_4:getAvailableRate()
				
				if not var_143_16 then
					var_143_16 = true
					
					var_143_13(true)
				end
				
				if var_154_0 < var_143_8 then
					if var_143_4._start_time and var_143_4._start_time + 2 <= os.time() then
						var_143_4:executeVideoSkip()
						
						return true
					else
						return false
					end
				end
				
				var_143_14(var_154_0)
				
				if var_143_16 and var_154_0 >= 1 then
					var_143_15(true)
					
					return true
				end
			end), var_143_4, "video_download")
		end
	elseif arg_143_1 and not var_143_4:isPlaying() then
		var_143_4._start_time = os.time()
		
		var_143_6()
	else
		var_143_4.ready_to_play = true
	end
	
	local var_143_17 = io.pathinfo(arg_143_0)
	local var_143_18 = getUserLanguage()
	local var_143_19 = string.format("text/%s.%s.srt", var_143_17.basename, var_143_18)
	local var_143_20 = load_subtitle(var_143_19)
	
	if table.count(var_143_20 or {}) > 0 then
		local var_143_21 = {}
		
		for iter_143_0, iter_143_1 in pairs(var_143_20) do
			local var_143_22 = ccui.Text:create()
			
			var_143_22:setFontName("font/daum.ttf")
			var_143_22:setColor(SUBTITLE_COLOR)
			var_143_22:enableOutline(SUBTITLE_OUT_LINE_COLOR, SUBTITLE_OUT_LINE_PIXEL)
			var_143_22:setScale(SUBTITLE_SCALE)
			var_143_22:setFontSize(SUBTITLE_FONT_SIZE)
			var_143_22:setLocalZOrder(999)
			var_143_22:setAnchorPoint(0.5, 0)
			var_143_22:setVisible(false)
			var_143_22:setTextHorizontalAlignment(SUBTITLE_TEXT_ALIGNMENT)
			var_143_22:setPosition(DESIGN_CENTER_X, var_143_22:getFontSize() * var_143_22:getScale() * 1.8 + SUBTITLE_FIXED_Y)
			var_143_22:setName("subtitle" .. iter_143_0)
			var_143_22:retain()
			
			var_143_22.added = false
			
			cc.AutoreleasePool:addObjectWithTarget(var_143_22, var_143_4)
			table.insert(var_143_21, var_143_22)
		end
		
		local var_143_23 = 1
		
		UIAction:Add(COND_LOOP(DELAY(100), function()
			if not var_143_4 then
				return true
			end
			
			local var_155_0 = var_143_4:getFramePosition()
			
			if var_143_23 > table.count(var_143_20) then
				return true
			end
			
			local var_155_1 = var_143_20[var_143_23]
			
			if not var_155_1 then
				return true
			end
			
			local var_155_2 = var_143_21[var_143_23]
			
			if var_155_2 and get_cocos_refid(var_155_2) then
				if var_155_0 >= var_155_1.hidepos and var_155_2.added then
					UIAction:Add(SEQ(FADE_OUT(30, true), REMOVE()), var_155_2, "subtitle_" .. var_143_23)
					
					var_143_23 = var_143_23 + 1
				elseif var_155_0 >= var_155_1.showpos and not var_155_2.added then
					var_155_2.added = true
					
					var_155_2:setString(var_155_1.text)
					var_143_4:addChild(var_155_2)
					UIAction:Add(FADE_IN(30), var_155_2, "subtitle_" .. var_143_23)
				end
			end
		end), var_143_4, "subtitle")
	end
	
	if var_143_4.addSkipListener then
		local function var_143_24()
			for iter_156_0 = 0, table.count(var_143_20 or {}) do
				if UIAction:Find("subtitle_" .. iter_156_0) then
					UIAction:Remove("subtitle_" .. iter_156_0)
					
					if get_cocos_refid(var_143_4) and get_cocos_refid(var_143_4:getChildByName("subtitle" .. iter_156_0)) then
						var_143_4:getChildByName("subtitle" .. iter_156_0):removeFromParent()
					end
				end
			end
			
			if UIAction:Find("subtitle") then
				UIAction:Remove("subtitle")
			end
			
			if UIAction:Find("video_download") then
				UIAction:Remove("video_download")
			end
			
			if arg_143_2 and type(arg_143_2) == "function" then
				arg_143_2(true)
			end
		end
		
		var_143_4:addSkipListener(var_143_24)
	end
	
	var_143_4.block_skip = arg_143_3
	
	if var_143_4.executeVideoSkip then
		local var_143_25 = ccui.Button:create()
		
		var_143_25:setTouchEnabled(true)
		var_143_25:setAnchorPoint(0, 0)
		var_143_25:setPosition(VIEW_BASE_LEFT, 0)
		var_143_25:ignoreContentAdaptWithSize(false)
		var_143_25:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_143_25:addTouchEventListener(function(arg_157_0, arg_157_1)
			if arg_157_1 == ccui.TouchEventType.ended and get_cocos_refid(var_143_4) and not var_143_4.block_skip and var_143_4._start_time and var_143_4._start_time + 2 <= os.time() then
				check_cool_time(var_143_4, "skip_video", 2000, function()
					var_143_4:executeVideoSkip(T("movie_skip_toast"))
				end, function()
					balloon_message_with_sound("movie_skip_toast")
				end, true)
			end
		end)
		var_143_4:addChild(var_143_25)
	end
	
	if file_storage_type(arg_143_0) ~= "osfs" then
		function var_143_4.getState()
			return 5
		end
	end
	
	G_CURRENT_MOVIE_CLIP = var_143_4
	
	return var_143_4
end

function parseEpic7Link(arg_161_0)
	local var_161_0 = {}
	local var_161_1 = string.split(arg_161_0, "://")
	
	var_161_0.protocol = var_161_1[1]
	
	local var_161_2 = string.split(var_161_1[2], "?")
	
	var_161_0.scene_name = var_161_2[1]
	var_161_0.options = var_161_2[2] or ""
	var_161_0.params = {}
	
	for iter_161_0, iter_161_1 in pairs(string.split(var_161_0.options, "&")) do
		local var_161_3 = string.split(iter_161_1, "=")
		local var_161_4 = var_161_3[1]
		local var_161_5 = var_161_3[2] or ""
		
		if tonumber(var_161_5) then
			var_161_5 = tonumber(var_161_5)
		elseif string.lower(var_161_5) == "true" then
			var_161_5 = true
		elseif string.lower(var_161_5) == "false" then
			var_161_5 = false
		end
		
		var_161_0.params[var_161_4] = var_161_5
	end
	
	return var_161_0
end

function movetoPath(arg_162_0)
	local var_162_0 = string.split(arg_162_0, "://")
	
	print("MOVE TO PATH:", arg_162_0)
	
	if var_162_0[1] == "http" then
		movetoPath(string.gsub(arg_162_0, "http", "https"))
	elseif var_162_0[1] == "https" then
		print("MOVE TO URL:", arg_162_0)
		openURL(arg_162_0)
	elseif var_162_0[1] == "epic7" then
		local var_162_1 = parseEpic7Link(arg_162_0)
		local var_162_2 = var_162_1.scene_name
		local var_162_3 = var_162_1.options
		local var_162_4 = var_162_1.params
		
		if (var_162_2 == "DungeonList" or var_162_2 == "substory_lobby" or string.starts(var_162_2, "world") or var_162_2 == "collection") and Account:checkQueryEmptyDungeonData("movetopath", {
			path = arg_162_0
		}) then
			return 
		end
		
		local var_162_5 = SceneManager:getCurrentSceneName()
		
		if var_162_4.unlock and not UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = var_162_4.unlock
		}) then
			return 
		end
		
		if var_162_5 == "world_sub" and var_162_2 == "world_custom" then
			Dialog:msgBox(T("wrong_scene_name.db_check"))
			
			return 
		end
		
		if var_162_5 == "world_custom" and var_162_2 == "world_sub" then
			Dialog:msgBox(T("wrong_scene_name.db_check"))
			
			return 
		end
		
		if var_162_2 == "worldmap_scene" then
			local var_162_6, var_162_7 = BackPlayUtil:checkAdventureInBackPlay()
			
			if not var_162_6 then
				balloon_message_with_sound(var_162_7)
				
				return 
			end
		end
		
		if var_162_2 == "world_sub" or var_162_2 == "world_custom" then
			local var_162_8, var_162_9 = BackPlayUtil:checkSubstoryInBackPlay()
			
			if not var_162_8 then
				balloon_message_with_sound(var_162_9)
				
				return 
			end
		end
		
		if string.starts(var_162_2, "world") then
			local var_162_10 = WorldMapManager:getControllerBySceneName(var_162_2)
			
			var_162_10:movetoPath(arg_162_0)
			UIAction:Add(SEQ(DELAY(500), CALL(function()
				var_162_10:updateWorldBGM()
			end)), SceneManager:getRunningPopupScene(), "block")
			
			return 
		end
		
		if var_162_4.substory_schedule then
			local var_162_11 = SubstoryManager:getRemainEnterTime(var_162_4.substory_schedule)
			
			if var_162_11 > 0 then
				balloon_message_with_sound("err_msg_tournament_time", {
					time = sec_to_full_string(var_162_11)
				})
				
				return 
			elseif is_time_over then
				balloon_message_with_sound("err_schedule_end")
				
				return 
			end
		end
		
		if var_162_2 == "substory_lobby" and var_162_4.substory_id then
			local var_162_12 = (SubstoryManager:getInfo() or {}).id == var_162_4.substory_id
			
			if var_162_12 and string.starts(var_162_5, "world") and var_162_4.contents then
				local var_162_13 = WorldMapManager:getController()
				
				var_162_0 = {}
				
				var_162_13:moveLocalWorldScene(var_162_4, var_162_0)
				
				return 
			elseif var_162_5 == var_162_2 and var_162_12 then
				if var_162_4 and var_162_4.contents == 1 and var_162_4.substory_id == "vewrda" then
					SubstoryManager:nextContent_type1({
						pathParams = var_162_4
					})
				end
				
				return 
			end
			
			SubstoryManager:queryEnter(var_162_4.substory_id, {
				pathParams = var_162_4
			})
			
			return 
		end
		
		if var_162_2 == "pvp" then
			UnlockSystem:isUnlockSystemAndMsg({
				exclude_story = true,
				id = UNLOCK_ID.PVP
			}, function()
				query("pvp_sa_lobby")
			end)
			
			return 
		end
		
		if var_162_2 == "stove_manual_popup" then
			local var_162_14 = var_162_4.index
			
			if var_162_14 and Stove:checkStandbyAndBalloonMessage() then
				Login.FSM:changeState(LoginState.STOVE_VIEW_MANUAL, {
					location = var_162_14
				})
			end
			
			return 
		end
		
		if var_162_2 == "stove_event_popup" then
			Stove:openCommunityUI("event")
			
			return 
		end
		
		if var_162_2 == "shop" then
			Shop:query(var_162_4.type, var_162_4.category)
			
			return 
		end
		
		if var_162_2 == "promotion" then
			ShopPromotion:open(var_162_3)
			
			return 
		end
		
		if var_162_2 == "gacha_unit" then
			local var_162_15 = {}
			
			if var_162_4.mode then
				var_162_15.gacha_mode = var_162_4.mode
			end
			
			if var_162_4.pickup_id then
				var_162_15.gacha_mode = "gacha_pickup:" .. var_162_4.pickup_id
			end
			
			SceneManager:nextScene("gacha_unit", var_162_15)
			
			return 
		end
		
		if var_162_2 == "pet_ui" and ContentDisable:byAlias("pet") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		if var_162_2 == "clan" and var_162_4.mode then
			if var_162_5 ~= "clan" then
				Log.e("no_clan_scene", "movetoPath")
				
				return 
			else
				ClanCategory:setMode(var_162_4.mode)
				
				return 
			end
		end
		
		if var_162_2 == "unit_ui" and var_162_4.unit_code and not Account:isHaveSameCodeUnit(var_162_4.unit_code) then
			balloon_message(T("err_shortcut_no_char"))
			
			return 
		end
		
		if var_162_2 == "unit_ui" and var_162_4.unit_uid then
			local var_162_16 = Account:getUnit(var_162_4.unit_uid)
			
			if not var_162_16 then
				balloon_message(T("err_shortcut_no_char"))
				
				return 
			else
				var_162_4.unit = var_162_16
			end
		end
		
		if var_162_2 == "webevent" then
			local var_162_17 = {}
			
			if var_162_4.event_mission then
				var_162_17.event_mission = var_162_4.event_mission
			elseif var_162_4.custom_event_id then
				var_162_17.custom_event_id = var_162_4.custom_event_id
			end
			
			if not WebEventPopUp:isShow() then
				WebEventPopUp:show(var_162_17)
			end
			
			if var_162_4.showRewardedVideo and var_162_4.showRewardedVideo == true then
				UIAction:Add(SEQ(DELAY(100), CALL(function()
					AdNetworks:showRewardedVideo()
				end)), "block")
			end
			
			return 
		end
		
		if var_162_2 == "event_popup" then
			local var_162_18 = {}
			
			if var_162_4.event_mission then
				var_162_18.event_mission = var_162_4.event_mission
			end
			
			if not SingleEventPopup:isShow() then
				SingleEventPopup:show(var_162_18)
			end
			
			return 
		end
		
		if var_162_2 == "coop" then
			CoopMission.DoEnter()
			
			return 
		end
		
		if var_162_4.substory_id then
			TransitionScreen:show({
				on_show_before = function(arg_166_0)
					return nil, 0
				end,
				on_hide_before = function(arg_167_0)
					arg_167_0:removeAllChildren()
					
					return EffectManager:Play({
						fn = "stagechange_cloud.cfx",
						pivot_z = 99998,
						layer = arg_167_0,
						pivot_x = VIEW_WIDTH / 2,
						pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
					}), 2000
				end,
				on_show = function()
					SceneManager:nextScene(var_162_2, var_162_4)
				end
			})
			
			return 
		end
		
		if var_162_5 == var_162_2 and callButtonEvent(var_162_4.ui_event, var_162_4.btn) then
			if var_162_4.main_tab and var_162_4.btn and var_162_4.btn == "btn_top_inventory" then
				Inventory:selectMainTab(tonumber(var_162_4.main_tab))
			end
			
			return 
		end
		
		SceneManager:nextScene(var_162_2, var_162_4)
	elseif var_162_0[1] == "stove" and string.split(var_162_0[2], "?")[1] == "setting" and Stove:checkStandbyAndBalloonMessage() then
		Login.FSM:changeState(LoginState.STOVE_MANAGE_ACCOUNT)
	end
end

function callButtonEvent(arg_169_0, arg_169_1)
	if not arg_169_0 then
		return false
	end
	
	if not arg_169_1 then
		return false
	end
	
	local var_169_0 = SceneManager:getRunningUIScene():getChildByName(arg_169_0)
	
	if not get_cocos_refid(var_169_0) then
		return false
	end
	
	local var_169_1 = var_169_0:getChildByName(arg_169_1)
	
	if not get_cocos_refid(var_169_1) then
		return false
	end
	
	HANDLER[var_169_0:getName()](var_169_1, arg_169_1)
	
	return true
end

function forEachEventerList(arg_170_0, arg_170_1, ...)
	local var_170_0 = {}
	
	for iter_170_0, iter_170_1 in pairs(arg_170_0) do
		if iter_170_1:isValid() then
			iter_170_1[arg_170_1](iter_170_1, ...)
		else
			var_170_0[iter_170_0] = true
		end
	end
	
	for iter_170_2 = #arg_170_0, 1, -1 do
		if var_170_0[iter_170_2] then
			table.remove(arg_170_0, iter_170_2)
		end
	end
end

function currency_format(arg_171_0, arg_171_1, arg_171_2, arg_171_3)
	local var_171_0
	local var_171_1
	local var_171_2
	local var_171_3
	local var_171_4
	
	arg_171_1 = arg_171_1 or ""
	arg_171_2 = arg_171_2 or ""
	arg_171_3 = arg_171_3 or "-"
	
	local var_171_5 = math.abs(round(arg_171_0, 0))
	local var_171_6 = math.floor(var_171_5)
	local var_171_7 = round(math.abs(arg_171_0) - var_171_6, 0)
	local var_171_8 = var_171_6
	
	repeat
		local var_171_9
		
		var_171_8, var_171_9 = string.gsub(var_171_8, "^(-?%d+)(%d%d%d)", "%1,%2")
	until var_171_9 == 0
	
	if arg_171_0 < 0 then
		var_171_8 = arg_171_3 .. var_171_8
	else
		var_171_8 = arg_171_2 .. var_171_8
	end
	
	return arg_171_1 .. var_171_8
end

function calcEquipSellPrice(arg_172_0)
	local var_172_0 = DB("itemgrade", tostring(arg_172_0.grade), "price")
	
	if not var_172_0 then
		Log.e("itemgrade db price is empty. grade:", tostring(arg_172_0.grade))
	end
	
	local var_172_1
	
	if arg_172_0.db.item_level and table.isInclude({
		"weapon",
		"helm",
		"armor",
		"ring",
		"boot",
		"neck"
	}, arg_172_0.db.type) then
		local var_172_2 = to_n(DB("item_equip_balance", tostring(arg_172_0.db.item_level), "price"))
		
		var_172_1 = math.floor(var_172_0 * var_172_2)
	end
	
	var_172_1 = var_172_1 or math.floor(var_172_0 * arg_172_0.db.price)
	
	if arg_172_0:isArtifact() and arg_172_0.getDupPoint then
		var_172_1 = var_172_1 * (arg_172_0:getDupPoint() + 1)
	end
	
	return var_172_1
end

function calcArtifactSellPowder(arg_173_0)
	local var_173_0 = DB("equip_item", arg_173_0.code, "limited")
	
	if var_173_0 and var_173_0 == "y" then
		return 0
	end
	
	if not DB("item_equip_artifact_sell", tostring(arg_173_0.grade), "count") then
		Log.e("item_equip_artifact_sell DB Error : row ", tostring(arg_173_0.grade), "column : count")
		
		return nil
	end
	
	local var_173_1 = 1
	
	if arg_173_0.getDupPoint then
		var_173_1 = arg_173_0:getDupPoint() + 1
	end
	
	return DB("item_equip_artifact_sell", tostring(arg_173_0.grade), "count") * var_173_1
end

function enumerateNodeRecursive(arg_174_0, arg_174_1)
	if arg_174_0 then
		arg_174_1(arg_174_0)
		
		local var_174_0 = arg_174_0:getChildren()
		
		for iter_174_0, iter_174_1 in pairs(var_174_0) do
			enumerateNodeRecursive(iter_174_1, arg_174_1)
		end
	end
end

function calcWorldRotation(arg_175_0)
	if arg_175_0:getParent() then
		return arg_175_0:getRotation() + calcWorldRotation(arg_175_0:getParent())
	else
		return arg_175_0:getRotation()
	end
end

function calcWorldScaleX(arg_176_0)
	if arg_176_0:getParent() then
		return arg_176_0:getScaleX() * calcWorldScaleX(arg_176_0:getParent())
	else
		return arg_176_0:getScaleX()
	end
end

function calcWorldScaleY(arg_177_0)
	if arg_177_0:getParent() then
		return arg_177_0:getScaleY() * calcWorldScaleY(arg_177_0:getParent())
	else
		return arg_177_0:getScaleY()
	end
end

function addLine(arg_178_0, arg_178_1, arg_178_2, arg_178_3)
	local var_178_0 = 0
	local var_178_1 = 0
	
	repeat
		local var_178_2 = cc.Sprite:create(arg_178_1)
		
		var_178_2:setPosition(0, var_178_0)
		
		if arg_178_3 then
			var_178_2:setAnchorPoint(0.5, 0)
			
			var_178_1 = var_178_2:getContentSize().width
			var_178_0 = var_178_0 + var_178_2:getContentSize().height
		else
			var_178_2:setAnchorPoint(1, 0.5)
			var_178_2:setRotation(90)
			
			var_178_1 = var_178_2:getContentSize().height
			var_178_0 = var_178_0 + var_178_2:getContentSize().width
		end
		
		arg_178_0:addChild(var_178_2)
	until arg_178_2 < var_178_0
	
	return {
		width = var_178_1,
		height = var_178_0
	}
end

function is_night_time_push(arg_179_0)
	if not arg_179_0 then
		return false
	end
	
	if arg_179_0 < os.time() then
		return false
	end
	
	local var_179_0 = os.date("*t", arg_179_0).hour
	
	if var_179_0 < 8 or var_179_0 > 21 then
		return true
	else
		return false
	end
end

function add_local_push(arg_180_0, arg_180_1, arg_180_2)
	if not arg_180_0 then
		return 
	end
	
	local var_180_0 = LOCAL_PUSH_IDS[arg_180_0]
	
	if not var_180_0 then
		return 
	end
	
	if IS_ANDROID_PC then
		return 
	end
	
	if not SAVE:getOptionData("option." .. var_180_0.category, default_options[var_180_0.category]) then
		return 
	end
	
	local var_180_1
	
	if Stove.enable and Stove.user_data and Stove.user_data.push_settings then
		var_180_1 = Stove.user_data.push_settings.enabledNight
	else
		var_180_1 = SAVE:getOptionData("option.push_night", default_options.push_night)
	end
	
	if not var_180_1 then
		print("야간 푸시 검사. 현시간 : ", os.date("%c", os.time()), "푸시 도착시간 : ", os.date("%c", os.time() + arg_180_1))
		
		if is_night_time_push(os.time() + arg_180_1) then
			print("야간 푸시 알림 꺼져서 푸시 못보넴. 도착시간 : ", os.date("*t", os.time() + arg_180_1).hour)
			
			return 
		end
	end
	
	SAVE:set("t_local_push_" .. var_180_0.id, os.time() + arg_180_1)
	cancel_push_local(var_180_0.id)
	add_push_local(var_180_0.id, arg_180_1 or 0, T(var_180_0.title), T(var_180_0.desc), arg_180_2)
	print("DEBUG 푸시 발송 예약 성공. 도착시간 : ", T(var_180_0.title), os.date("%c", os.time() + arg_180_1))
end

function cancel_local_push(arg_181_0)
	if type(arg_181_0) ~= "table" then
		return 
	end
	
	if IS_ANDROID_PC then
		return 
	end
	
	cancel_push_local(arg_181_0.id)
	SAVE:set("t_local_push_" .. arg_181_0.id, nil)
end

function terminated_process()
	Log.d("terminated_process")
	Scheduler:addGlobal(function()
		local var_183_0 = cc.Director:getInstance():getOpenGLView()
		
		var_183_0["end"](var_183_0)
	end)
end

function save_logo_files()
	local var_184_0 = getenv("title_overlap.id", "auto")
	
	if var_184_0 == "auto" then
		return 
	end
	
	local var_184_1 = getenv("allow.language")
	
	if var_184_1 then
		local var_184_2 = string.split(var_184_1, ",")
		
		for iter_184_0, iter_184_1 in pairs(var_184_2) do
			local var_184_3
			
			if iter_184_1 then
				local var_184_4 = DB("title_manager", var_184_0, "logo_" .. iter_184_1)
				
				if var_184_4 ~= var_184_3 then
					local var_184_5 = var_184_4 and "logo/" .. var_184_4 .. ".png" or "failed"
					local var_184_6 = var_184_4 .. ".png"
					
					export_title_to_file(var_184_5, var_184_6)
				end
			end
		end
	end
end

function save_title_files()
	local var_185_0 = getenv("title_overlap.id", "auto")
	
	if var_185_0 == "auto" then
		return 
	end
	
	local var_185_1, var_185_2, var_185_3 = DB("title_manager", var_185_0, {
		"bg",
		"bg_type",
		"bgm"
	})
	local var_185_4
	local var_185_5 = var_185_2 == "movie" and (LOW_RESOLUTION_MODE and "_low.mp4" or ".mp4") or ".png"
	local var_185_6 = var_185_1 and "bg/" .. var_185_1 .. var_185_5 or "failed"
	local var_185_7 = var_185_3 and "bgm/" .. var_185_3 .. ".mp3" or "failed"
	
	if not export_title_to_file(var_185_6, "current_bg" .. var_185_5) then
		return 
	end
	
	if not export_title_to_file(var_185_7, "current_bgm.mp3") then
		return 
	end
	
	save_logo_files()
end

function is_can_open_review_popup()
	if not Account:isMapCleared("ije010") then
		return false
	end
	
	if TutorialGuide:isClearedTutorial("store_review") then
		return false
	end
	
	if SAVE:getKeep("is_store_reviewed", false) then
		return false
	end
	
	if Account:getConfigData("is_store_reviewed") then
		return false
	end
	
	return true
end

function review_popup()
	SAVE:setKeep("is_store_reviewed", true)
	SAVE:setTempConfigData("is_store_reviewed", true)
	
	if PLATFORM == "win32" then
		balloon_message("In App Review. this message only windows")
		
		return 
	end
	
	if IS_PUBLISHER_ZLONG then
		Zlong:doOpenRequestReview()
		
		return 
	end
	
	if show_storereview then
		if PLATFORM == "android" then
			show_storereview()
		elseif PLATFORM == "iphoneos" then
			show_storereview("https://itunes.apple.com/app/id1322399438?action=write-review")
		end
	end
end

function load_subtitle(arg_188_0)
	local function var_188_0(arg_189_0)
		local var_189_0, var_189_1, var_189_2, var_189_3 = string.match(arg_189_0, "(%d+):(%d+):(%d+),(%d+)")
		
		return tonumber(var_189_0) * 60 * 60 * 1000 + tonumber(var_189_1) * 60 * 1000 + tonumber(var_189_2) * 1000 + tonumber(var_189_3)
	end
	
	local var_188_1 = {}
	local var_188_2 = {}
	local var_188_3
	local var_188_4 = cc.FileUtils:getInstance():getStringFromFile(arg_188_0)
	
	if var_188_4 then
		local var_188_5 = string.erase_bom(var_188_4)
		local var_188_6 = string.split(var_188_5, "\r\n")
		
		for iter_188_0, iter_188_1 in pairs(var_188_6) do
			iter_188_1 = string.trim(iter_188_1)
			
			if not var_188_3 then
				var_188_1.subid = tonumber(iter_188_1)
				
				print("subid : ", var_188_1.subid)
				
				var_188_3 = "time"
			elseif var_188_3 == "time" then
				local var_188_7 = string.split(iter_188_1, "-->")
				
				var_188_1.showpos = var_188_0(var_188_7[1])
				var_188_1.hidepos = var_188_0(var_188_7[2])
				var_188_3 = "text"
			elseif var_188_3 == "text" then
				if iter_188_1 == "" then
					table.insert(var_188_2, var_188_1)
					
					var_188_1 = {}
					var_188_3 = nil
				else
					iter_188_1 = tostring(iter_188_1)
					iter_188_1 = string.gsub(iter_188_1, "\\r", "\r")
					iter_188_1 = string.gsub(iter_188_1, "\\n", "\n")
					
					if var_188_1.text then
						var_188_1.text = var_188_1.text .. "\n" .. iter_188_1
					else
						var_188_1.text = iter_188_1
					end
				end
			end
			
			iter_188_1 = string.trim(iter_188_1)
		end
		
		if var_188_1.subid then
			table.insert(var_188_2, var_188_1)
		end
	end
	
	return var_188_2
end

function file_storage_type(arg_190_0)
	if cc.FileUtils:getInstance():fullPathForFilename(arg_190_0) == "" then
		return 
	end
	
	if string.sub(cc.FileUtils:getInstance():fullPathForFilename(arg_190_0), 1, 8) == "//@pack/" then
		return "pack"
	end
	
	return "osfs"
end

VIBRATION_TYPE = {
	Default = 0,
	Warning = 5,
	Select = 2,
	Impact = 1,
	Error = 4,
	Success = 3
}

function vibrate(arg_191_0)
	if arg_191_0 == VIBRATION_TYPE.Default then
		if SAVE:getOptionData("option." .. "battle_end_vib", default_options.battle_end_vib) and (PLATFORM == "android" or PLATFORM == "iphoneos") then
			cc.Device:vibrateByType(arg_191_0)
		end
	elseif SAVE:getOptionData("option." .. "haptic_vib", default_options.haptic_vib) and (PLATFORM == "android" or PLATFORM == "iphoneos") then
		cc.Device:vibrateByType(arg_191_0)
	end
end

function string_hash(arg_192_0)
	arg_192_0 = tostring(arg_192_0)
	
	local var_192_0 = 0
	
	for iter_192_0 = #arg_192_0, 1, -1 do
		var_192_0 = var_192_0 * 43 + string.byte(arg_192_0:sub(iter_192_0, iter_192_0))
		
		while var_192_0 > 4294967295 do
			var_192_0 = var_192_0 - 4294967295
		end
	end
	
	return var_192_0
end

Base64 = Base64 or {}
Base64.base_str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

function Base64.encode(arg_193_0)
	local function var_193_0(arg_194_0)
		local var_194_0 = ""
		local var_194_1 = arg_194_0:byte()
		
		for iter_194_0 = 8, 1, -1 do
			var_194_0 = var_194_0 .. (var_194_1 % 2^iter_194_0 - var_194_1 % 2^(iter_194_0 - 1) > 0 and "1" or "0")
		end
		
		return var_194_0
	end
	
	local function var_193_1(arg_195_0)
		if #arg_195_0 < 6 then
			return ""
		end
		
		local var_195_0 = 0
		
		for iter_195_0 = 1, 6 do
			var_195_0 = var_195_0 + (arg_195_0:sub(iter_195_0, iter_195_0) == "1" and 2^(6 - iter_195_0) or 0)
		end
		
		return Base64.base_str:sub(var_195_0 + 1, var_195_0 + 1)
	end
	
	return (arg_193_0:gsub(".", var_193_0) .. "0000"):gsub("%d%d%d?%d?%d?%d?", var_193_1) .. ({
		"",
		"==",
		"="
	})[#arg_193_0 % 3 + 1]
end

function Base64.decode(arg_196_0)
	arg_196_0 = string.gsub(arg_196_0, "[^" .. Base64.base_str .. "=]", "")
	
	local function var_196_0(arg_197_0)
		if arg_197_0 == "=" then
			return ""
		end
		
		local var_197_0 = ""
		local var_197_1 = Base64.base_str:find(arg_197_0) - 1
		
		for iter_197_0 = 6, 1, -1 do
			var_197_0 = var_197_0 .. (var_197_1 % 2^iter_197_0 - var_197_1 % 2^(iter_197_0 - 1) > 0 and "1" or "0")
		end
		
		return var_197_0
	end
	
	local function var_196_1(arg_198_0)
		if #arg_198_0 ~= 8 then
			return ""
		end
		
		local var_198_0 = 0
		
		for iter_198_0 = 1, 8 do
			var_198_0 = var_198_0 + (arg_198_0:sub(iter_198_0, iter_198_0) == "1" and 2^(8 - iter_198_0) or 0)
		end
		
		return string.char(var_198_0)
	end
	
	return (arg_196_0:gsub(".", var_196_0):gsub("%d%d%d?%d?%d?%d?%d?%d?", var_196_1))
end

KeyboardAvoidance = KeyboardAvoidance or {}

local function var_0_15(arg_199_0)
	if not get_cocos_refid(arg_199_0) then
		return nil
	end
	
	local var_199_0 = getParentWindow(arg_199_0)
	
	if tolua.type(var_199_0) ~= "ccui.Widget" then
		return arg_199_0
	end
	
	return var_0_15(var_199_0)
end

function KeyboardAvoidance.onShow(arg_200_0, arg_200_1)
	print("KeyboardAvoidance.onShow: " .. arg_200_1)
	
	if WebEventPopUp:isShowWebView() then
		return 
	end
	
	local var_200_0 = ccui.Widget:getCurrentFocusedWidget()
	
	if not get_cocos_refid(var_200_0) then
		Log.e("KeyboardAvoidance invalid focused_widget")
		
		return 
	end
	
	if tolua.type(var_200_0) ~= "ccui.TextField" then
		return 
	end
	
	arg_200_0.moving_widget = var_0_15(var_200_0)
	
	if not get_cocos_refid(arg_200_0.moving_widget) then
		Log.e("KeyboardAvoidance invalid moving_widget")
		
		return 
	end
	
	local var_200_1 = var_200_0:getWorldPosition().y
	local var_200_2 = 100
	local var_200_3 = math.min(math.max(0, arg_200_1 - var_200_1 + var_200_2), DESIGN_HEIGHT - var_200_0:getContentSize().height * var_200_0:getScaleY() - 20)
	
	arg_200_0.moving_widget.origin_pos_x = arg_200_0.moving_widget.origin_pos_x or arg_200_0.moving_widget:getPositionX()
	arg_200_0.moving_widget.origin_pos_y = arg_200_0.moving_widget.origin_pos_y or arg_200_0.moving_widget:getPositionY()
	
	UIAction:Add(LOG(MOVE_TO(250, arg_200_0.moving_widget.origin_pos_x, arg_200_0.moving_widget.origin_pos_y + var_200_3), 50), arg_200_0.moving_widget, "moving_widget")
end

function KeyboardAvoidance.onHide(arg_201_0)
	print("KeyboardAvoidance.onHide")
	
	if not get_cocos_refid(arg_201_0.moving_widget) then
		Log.e("KeyboardAvoidance invalid moving_widget")
		
		return 
	end
	
	if not arg_201_0.moving_widget.origin_pos_x then
		Log.e("KeyboardAvoidance not onShow")
		
		return 
	end
	
	UIAction:Add(LOG(MOVE_TO(250, arg_201_0.moving_widget.origin_pos_x, arg_201_0.moving_widget.origin_pos_y), 50), arg_201_0.moving_widget, "moving_widget")
end

function add_abuse_filter_list(arg_202_0)
	arg_202_0 = arg_202_0 or {}
	
	for iter_202_0, iter_202_1 in pairs(arg_202_0.chat or {}) do
		if not check_abuse_filter(iter_202_1, ABUSE_FILTER.CHAT) then
			add_abuse_filter(iter_202_1, ABUSE_FILTER.CHAT)
		end
	end
	
	for iter_202_2, iter_202_3 in pairs(arg_202_0.nick or {}) do
		if not check_abuse_filter(iter_202_3, ABUSE_FILTER.WORLD_NAME) then
			add_abuse_filter(iter_202_3, ABUSE_FILTER.WORLD_NAME)
		end
	end
end

function restore_state_from_backup_from_table(arg_203_0, arg_203_1)
	arg_203_0.vars = arg_203_0._backup[arg_203_1].vars
	
	local var_203_0 = {}
	
	for iter_203_0, iter_203_1 in pairs(arg_203_0) do
		if iter_203_0 ~= "_backup" and type(iter_203_1) ~= "function" then
			table.insert(var_203_0, iter_203_0)
		end
	end
	
	for iter_203_2, iter_203_3 in pairs(var_203_0) do
		arg_203_0[iter_203_3] = nil
	end
	
	for iter_203_4, iter_203_5 in pairs(arg_203_0._backup[arg_203_1].data) do
		arg_203_0[iter_203_4] = iter_203_5
	end
	
	arg_203_0._backup[arg_203_1] = nil
end

function get_state_back_up_from_table(arg_204_0, arg_204_1)
	if not arg_204_0._backup then
		return 
	end
	
	if not arg_204_0._backup[arg_204_1] or not arg_204_0._backup[arg_204_1].data or not get_cocos_refid(arg_204_0._backup[arg_204_1].data.root_layer) then
		arg_204_0._backup[arg_204_1] = nil
		
		return 
	end
	
	return arg_204_0._backup[arg_204_1]
end

function set_state_backup_from_table(arg_205_0, arg_205_1)
	if not arg_205_0._backup then
		arg_205_0._backup = {}
	end
	
	arg_205_0._backup[arg_205_1] = {
		vars = arg_205_0.vars,
		data = {}
	}
	
	for iter_205_0, iter_205_1 in pairs(arg_205_0) do
		if iter_205_0 ~= "_backup" and type(iter_205_1) ~= "function" then
			arg_205_0._backup[arg_205_1].data[iter_205_0] = iter_205_1
		end
	end
end

function download_file(arg_206_0, arg_206_1)
	if not arg_206_0 then
		return 
	end
	
	arg_206_1 = arg_206_1 or {}
	
	local var_206_0 = arg_206_1.OnStart
	local var_206_1 = arg_206_1.OnUpdate
	local var_206_2 = arg_206_1.OnEnd
	local var_206_3 = cc.FileUtils:getInstance():fullPathForFilename(arg_206_0)
	
	if not var_206_3 or string.len(var_206_3) == 0 then
		return 
	end
	
	local var_206_4 = cc.FileUtils:getInstance():getFileIOFromFile(var_206_3, "rb")
	
	if not var_206_4 then
		if var_206_0 then
			var_206_0(false)
		end
		
		if var_206_1 then
			var_206_1(0)
		end
		
		if var_206_2 then
			var_206_2(false)
		end
		
		return 
	end
	
	if var_206_4:isDownloadCompleted() then
		if var_206_0 then
			var_206_0(false)
		end
		
		if var_206_1 then
			var_206_1(1)
		end
		
		if var_206_2 then
			var_206_2(false)
		end
		
		return 
	end
	
	local var_206_5 = cc.Node:create()
	
	var_206_5:setUserObject(var_206_4)
	var_206_4:release()
	SceneManager:getRunningNativeScene():addChild(var_206_5)
	
	local var_206_6 = false
	
	UIAction:Add(COND_LOOP(DELAY(100), function()
		if not var_206_4 then
			return true
		end
		
		local var_207_0 = var_206_4:getAvailableRate()
		
		if not var_206_6 then
			var_206_6 = true
			
			if var_206_0 then
				var_206_0(true)
			end
		end
		
		if var_206_1 then
			var_206_1(var_207_0)
		end
		
		if var_206_6 and var_207_0 >= 1 then
			if var_206_2 then
				var_206_2(true)
			end
			
			return true
		end
	end), var_206_5, var_206_3)
	
	return var_206_5
end

function download_log()
	if not cc.FileUtils:getInstance().getFileIOFromFile then
		return 
	end
	
	local var_208_0 = "abc"
	local var_208_1 = cc.FileUtils:getInstance():getFileIOFromFile(var_208_0, "rb")
	
	if not var_208_1 then
		return 
	end
	
	local var_208_2 = cc.Node:create()
	
	var_208_2:setUserObject(var_208_1)
	var_208_1:release()
	SceneManager:getRunningNativeScene():addChild(var_208_2)
	
	if not var_208_1.getBytePerSec then
		return 
	end
	
	local var_208_3 = var_208_1:getBytePerSec()
end

function getExtractedUserOption(arg_209_0, arg_209_1)
	if not arg_209_0 then
		return nil
	end
	
	arg_209_1 = arg_209_1 or 1
	
	local var_209_0 = 1
	
	for iter_209_0 = 2, arg_209_1 do
		var_209_0 = var_209_0 * 10
	end
	
	return math.floor(arg_209_0 % (var_209_0 * 10) / var_209_0)
end
