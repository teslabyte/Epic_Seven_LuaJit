local var_0_0 = -170
local var_0_1 = 130
local var_0_2 = 1000

function HANDLER_BEFORE.story_v2(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_next_nosound" and STORY_ACTION_MANAGER:_canSkip() and STORY_ACTION_MANAGER:isStartAction() and not arg_1_0.touch_tick then
		arg_1_0.touch_tick = systick()
	end
end

function HANDLER_CANCEL.story_v2(arg_2_0, arg_2_1)
end

function HANDLER.story_v2(arg_3_0, arg_3_1)
	local var_3_0 = false or get_cocos_refid((STORY.childs or {}).movie)
	
	var_3_0 = var_3_0 or get_cocos_refid((STORY.childs or {}).choice_ui)
	
	if var_3_0 then
		if get_cocos_refid((STORY.childs or {}).choice_ui) and arg_3_1 == "btn_storylog" then
			StoryViewer:show()
		end
		
		local var_3_1 = (STORY.childs or {}).movie
		
		if get_cocos_refid(var_3_1) then
			check_cool_time(var_3_1, "skip_video", 2000, function()
				var_3_1:executeVideoSkip(T("movie_skip_toast"))
			end, function()
				balloon_message_with_sound("movie_skip_toast")
			end, true)
		end
		
		STORY.double_speed = nil
		
		return 
	end
	
	if arg_3_1 == "btn_next_nosound" then
		if STORY_ACTION_MANAGER:isStartAction() and systick() - to_n(arg_3_0.touch_tick) > 800 then
			_DEBUG_SKIP_CUR_STORY_ACTION()
			
			arg_3_0.touch_tick = nil
			
			return 
		elseif STORY_ACTION_MANAGER:activePortTextOnTouch() then
			return 
		end
		
		if StoryAction:Find("block") then
			return 
		end
		
		StoryAction:Remove("story_port_auto_next")
		
		if not STORY_ACTION_MANAGER:isStartAction() then
			step_next()
			
			return 
		end
	end
	
	if arg_3_1 == "btn_return_dict" then
		STORY_ACTION_MANAGER:setAllModelAnim(true)
		
		STORY.active_popup_dlg = Dialog:msgBox(T("dic_story_out_desc"), {
			yesno = true,
			title = T("dic_story_out_title"),
			cancel_handler = function()
				STORY_ACTION_MANAGER:setAllModelAnim(false)
			end,
			handler = function()
				exit_story()
			end
		})
	end
	
	if arg_3_1 == "btn_storylog" and STORY_ACTION_MANAGER:_canOpenStoryLogPopup() then
		StoryViewer:show()
	end
	
	if arg_3_1 == "btn_play" then
		if STORY_ACTION_MANAGER:isStartAction() then
			return 
		end
		
		local var_3_2 = (STORY.AUTO_STORY_SPEED or 0) > 0 and 0 or SAVE:get("app.story_auto_speed", STORY_AUTO_DEFAULT_SPEED)
		
		set_auto_story_speed(var_3_2, true)
		update_auto_play()
	end
	
	if arg_3_1 == "btn_speed" then
		toggle_auto_story_speed()
	end
	
	if arg_3_1 == "btn_pause" then
		if STORY.is_moonlight_th then
			open_story_esc()
		end
		
		return 
	end
end

function _build_value_table(arg_8_0, arg_8_1)
	if not arg_8_0 or not arg_8_1 then
		return 
	end
	
	if arg_8_0 == "move" then
		local var_8_0 = string.split(arg_8_1, ";")
		local var_8_1 = string.split(var_8_0[1], ",")
		local var_8_2 = var_8_1[1]
		local var_8_3 = var_8_1[2]
		local var_8_4 = var_8_0[2] or "run"
		local var_8_5 = var_8_0[3] or "idle"
		
		return tonumber(var_8_2), tonumber(var_8_3), var_8_4, var_8_5
	elseif arg_8_0 == "ca_move" then
		if string.find(arg_8_1, ",") then
			local var_8_6 = string.split(arg_8_1, ",")
			local var_8_7 = var_8_6[1]
			local var_8_8 = var_8_6[2]
			
			return nil, tonumber(var_8_7), tonumber(var_8_8)
		else
			return arg_8_1
		end
	elseif arg_8_0 == "fade_color" then
		local var_8_9 = string.split(arg_8_1, ",")
		
		return tonumber(var_8_9[1]), tonumber(var_8_9[2]), tonumber(var_8_9[3])
	elseif arg_8_0 == "animate" then
		if string.find(arg_8_1, ";") then
			local var_8_10, var_8_11 = string.gsub(arg_8_1, ";", "")
			
			if var_8_11 == 1 then
				local var_8_12 = string.split(arg_8_1, ";")
				local var_8_13 = var_8_12[1] or "idle"
				local var_8_14 = var_8_12[2] and var_8_12[2] == "y"
				
				return {}, var_8_13, var_8_14
			elseif var_8_11 == 2 then
				local var_8_15 = string.split(arg_8_1, ";")
				local var_8_16 = var_8_15[2] or "idle"
				local var_8_17 = string.split(var_8_15[1], ",")
				local var_8_18 = var_8_15[3] and var_8_15[3] == "y"
				
				return var_8_17, var_8_16, var_8_18
			end
		else
			return false
		end
	elseif arg_8_0 == "text" then
		if string.find(arg_8_1, ",") then
			local var_8_19 = string.split(arg_8_1, ",")
			
			return nil, tonumber(var_8_19[1]), tonumber(var_8_19[2]) * 10
		else
			return arg_8_1
		end
	elseif arg_8_0 == "effect_value" then
		if string.find(arg_8_1, ";") then
			local var_8_20 = string.split(arg_8_1, ";")
			
			return var_8_20[1], var_8_20[2] and var_8_20[2] == "y"
		else
			return arg_8_1, nil
		end
	elseif arg_8_0 == "effect_target" then
		local var_8_21 = string.split(arg_8_1, ",")
		
		return tonumber(var_8_21[1]), tonumber(var_8_21[2]) * 10
	elseif arg_8_0 == "zoom" then
		if string.find(arg_8_1, ",") then
			local var_8_22 = string.split(arg_8_1, ",")
			
			return nil, tonumber(var_8_22[1]), tonumber(var_8_22[2]) * 10
		else
			return arg_8_1, nil, nil
		end
	elseif arg_8_0 == "shake" then
		local var_8_23 = string.split(arg_8_1, ",")
		
		return tonumber(var_8_23[1]), tonumber(var_8_23[2])
	elseif arg_8_0 == "skill" then
		local var_8_24 = string.split(arg_8_1, ";")
		local var_8_25 = tonumber(var_8_24[1]) or 1
		local var_8_26 = var_8_24[3] and var_8_24[3] == "y"
		local var_8_27
		
		if var_8_24[2] then
			var_8_27 = string.split(var_8_24[2], ",")
		else
			var_8_27 = {}
		end
		
		return var_8_25, var_8_27, var_8_26
	end
end

local function var_0_3(arg_9_0, arg_9_1)
	if DEBUG.CAN_SKIP_STORY_ACTION then
		return 
	end
	
	if arg_9_1 then
		STORY.childs.n_skip:setVisible(arg_9_0)
		STORY.childs.n_skip:setVisible(arg_9_0)
		if_set_visible(STORY.childs.dlg, "n_return_dict", arg_9_0)
		STORY.childs.dlg:setVisible(arg_9_0)
	end
	
	if not SAVE:isTutorialFinished() then
		if_set_visible(STORY.childs.dlg, "n_return_dict", false)
	end
	
	if STORY.is_moonlight_th then
		STORY.childs.n_skip:setVisible(false)
	end
end

local function var_0_4(arg_10_0)
	if not is_playing_story() or not STORY.childs or not get_cocos_refid(STORY.childs.cursor) then
		return 
	end
	
	STORY.cursor_hide = not arg_10_0
	
	STORY.childs.cursor:setVisible(arg_10_0)
	
	if arg_10_0 then
		show_cursor()
	end
end

function test_story_v2(arg_11_0, arg_11_1)
	SceneManager:nextScene("lobby")
	SceneManager:resetSceneFlow()
	
	DEBUG.STOP_STA_AUTO_NEXT = arg_11_0
	
	local var_11_0 = arg_11_1 or "CH00_001"
	
	BattleAction:Add(SEQ(DELAY(1000), CALL(function()
		Cheat:start_battle("test003")
	end), DELAY(2000), CALL(function()
		test_story(var_11_0)
	end)), test_story_v2)
end

function story_action_on_action_scene(arg_14_0, arg_14_1, arg_14_2)
	DEBUG.STOP_STA_AUTO_NEXT = arg_14_0
	
	local var_14_0 = arg_14_1 or "test_CH00_001"
	
	if SceneManager:getCurrentSceneName() == "story_action" then
		play_curtain(SceneManager:getRunningNativeScene(), 0, 150, 250, 150, "story_action_change", nil, nil, nil, cc.c3b(0, 0, 0))
		UIAction:Add(SEQ(DELAY(400), CALL(function()
			test_story(var_14_0, arg_14_2)
		end)), SceneManager:getRunningNativeScene(), "block")
	else
		SceneManager:cancelReseveResetSceneFlow()
		SceneManager:nextScene("story_action", {
			story_id = var_14_0,
			opts = arg_14_2
		})
	end
end

local function var_0_5(arg_16_0)
	if not arg_16_0 then
		return 
	end
	
	local var_16_0 = arg_16_0.n_talk_node
	local var_16_1 = arg_16_0.n_talk
	local var_16_2 = arg_16_0.x
	local var_16_3 = var_16_0:getChildByName("talk_bg")
	local var_16_4 = 100
	local var_16_5 = var_16_2 or 0
	local var_16_6 = arg_16_0.balloon_dir
	local var_16_7 = arg_16_0.parent_direction
	local var_16_8 = arg_16_0.start_parent_dir
	local var_16_9 = math.abs(var_16_1:getScaleX())
	
	if var_16_7 < 0 then
		var_16_1:setScaleX(var_16_9 * -1)
	else
		var_16_1:setScaleX(var_16_9)
	end
	
	local var_16_10 = math.abs(var_16_3:getScaleX())
	local var_16_11 = var_16_3:getContentSize().width
	
	if var_16_6 * var_16_7 > 0 then
		var_16_5 = var_16_5 + var_16_10 * var_16_11 / 2 + var_16_4
	else
		var_16_5 = var_16_5 - var_16_10 * var_16_11 / 2 - var_16_4
	end
	
	var_16_1:setPositionX(var_16_5)
end

local function var_0_6()
	if not STORY.story or not STORY.index then
		return {}
	end
	
	return STORY.story[STORY.index] or {}
end

function check_using_story_action(arg_18_0)
	if not arg_18_0 then
		return 
	end
	
	local var_18_0, var_18_1, var_18_2 = DB("story_action_main", arg_18_0, {
		"id",
		"bg",
		"bg_offset"
	})
	
	if not var_18_0 then
		set_using_story_v2(false)
		
		return 
	end
	
	set_using_story_v2(true)
	
	STORY.is_fadeout = false
end

function set_using_story_v2(arg_19_0)
	STORY_ACTION_MANAGER.STORY_ACTION = arg_19_0
end

function is_using_story_v2()
	return STORY_ACTION_MANAGER.STORY_ACTION
end

local var_0_7

STORY_ACTION_MANAGER = {}

function STORY_ACTION_MANAGER.storyActionInit(arg_21_0, arg_21_1)
	if not is_playing_story() or get_cocos_refid(arg_21_0.layer) then
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		var_0_7 = getenv("time_scale")
		
		setenv("time_scale", 1.2)
	end
	
	set_scene_fps(60)
	
	arg_21_0.layer = nil
	arg_21_0.vars = {}
	arg_21_0.vars.models_id = {}
	arg_21_0.vars.world_talks = {}
	arg_21_0.vars.sounds = {}
	arg_21_0.vars.story_id = arg_21_1
	arg_21_0.vars.ready_actions = {}
	arg_21_0.vars.ready_port_text_actions = {}
	arg_21_0.vars.port_text_actions = {}
	arg_21_0.vars.actions = {}
	arg_21_0.vars._d = 0
	arg_21_0.vars.story_port_texts = {}
	
	arg_21_0:createBg()
	STORY_ACTION_MANAGER:test_story_v2_story_init()
	STORY_ACTION_MANAGER:test_story_v2_story_build()
	LuaEventDispatcher:removeEventListenerByKey("STORY_ACTION_MANAGER")
	
	if SceneManager:getCurrentSceneName() == "battle" then
		LuaEventDispatcher:pauseSendEventToListenerByKey("spine.ani", "battle")
		LuaEventDispatcher:pauseSendEventToListenerByKey("battle.event", "battle")
	end
	
	LuaEventDispatcher:addEventListener("spine.ani", LISTENER(STORY_ACTION_MANAGER.onAniEvent), "STORY_ACTION_MANAGER")
	LuaEventDispatcher:addEventListener("battle.event", LISTENER(STORY_ACTION_MANAGER.onEvent), "STORY_ACTION_MANAGER")
end

function STORY_ACTION_MANAGER.createBg(arg_22_0)
	local var_22_0, var_22_1, var_22_2, var_22_3, var_22_4, var_22_5, var_22_6, var_22_7 = DB("story_action_main", arg_22_0.vars.story_id, {
		"id",
		"character_l",
		"character_r",
		"monster_l",
		"monster_r",
		"bg",
		"ambient_color",
		"bg_offset"
	})
	local var_22_8 = string.split(var_22_7, ",")
	local var_22_9 = tonumber(var_22_8[1]) or 0
	local var_22_10 = tonumber(var_22_8[2]) or 0
	local var_22_11 = var_22_5 or "final2"
	local var_22_12 = false
	local var_22_13 = BattleField:create("story")
	local var_22_14 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_22_14:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_22_13:addChild(var_22_14)
	var_22_14:setPositionX(VIEW_BASE_LEFT)
	BattleField:addTestField(var_22_11, DESIGN_WIDTH * 4, false, {
		additional_bgi_mode = "story"
	})
	
	arg_22_0.layer = BGIManager:getBGI().main.layer
	arg_22_0.vars.n_bg = var_22_13
	
	BattleLayout:init()
	BattleLayout:setDirection(1)
	
	arg_22_0.vars.pivot = cc.Node:create()
	
	arg_22_0.vars.pivot:retain()
	arg_22_0.vars.pivot:setName("pivot")
	STORY.layer:getParent():addChild(arg_22_0.vars.pivot)
	arg_22_0.vars.n_bg:retain()
	arg_22_0.vars.n_bg:removeFromParent()
	arg_22_0.vars.pivot:addChild(arg_22_0.vars.n_bg)
	
	if var_22_6 then
		arg_22_0.vars.ambient_color = var_22_6
	end
	
	BattleLayout:setFieldPosition(var_22_9)
	BattleLayout:setFieldPositionY(var_22_10)
	BattleLayout:updatePose()
	BattleLayout:updateModelPose()
	CameraManager:playCamera("default")
	arg_22_0:_createModels(var_22_1, "left")
	arg_22_0:_createModels(var_22_2, "right")
	arg_22_0:_createModels(var_22_3, "left", true)
	arg_22_0:_createModels(var_22_4, "right", true)
	
	if not arg_22_0.vars.n_portrait then
		local var_22_15 = STORY.layer:getChildByName("n_portrait")
		
		arg_22_0.vars.n_portrait = var_22_15:clone()
		
		var_22_15:getParent():addChild(arg_22_0.vars.n_portrait)
		arg_22_0.vars.n_portrait:setPosition(var_22_15:getPosition())
		arg_22_0.vars.n_portrait:setAnchorPoint(var_22_15:getPosition())
		arg_22_0.vars.n_portrait:setVisible(false)
		
		local var_22_16 = STORY.layer:findChildByName("n_return_dict")
		local var_22_17 = STORY.layer:findChildByName("n_pause")
		
		if get_cocos_refid(var_22_16) and get_cocos_refid(var_22_17) then
			var_22_16:bringToFront()
			var_22_17:bringToFront()
		end
		
		arg_22_0.vars.n_port_dim = load_control("wnd/story_dim.csb")
		
		var_22_15:getParent():addChild(arg_22_0.vars.n_port_dim)
		arg_22_0.vars.n_port_dim:setVisible(false)
		arg_22_0.vars.n_port_dim:setLocalZOrder(-10)
	else
		arg_22_0.vars.n_portrait:removeAllChildren()
	end
end

function STORY_ACTION_MANAGER.setPortTextUI(arg_23_0, arg_23_1)
	if not arg_23_0.vars or not arg_23_0.vars.n_portrait or not arg_23_0.vars.n_port_dim then
		return 
	end
	
	arg_23_0.vars.n_portrait:setVisible(arg_23_1)
	arg_23_0.vars.n_port_dim:setVisible(arg_23_1)
end

function STORY_ACTION_MANAGER.getPortParent(arg_24_0)
	return arg_24_0.vars.n_portrait
end

function STORY_ACTION_MANAGER.getPortDim(arg_25_0)
	return arg_25_0.vars.n_port_dim
end

function STORY_ACTION_MANAGER.setPrevPortID(arg_26_0, arg_26_1)
	arg_26_0.vars.prev_port_id = arg_26_1
end

function STORY_ACTION_MANAGER.getPrevPortID(arg_27_0)
	return arg_27_0.vars.prev_port_id
end

function STORY_ACTION_MANAGER.getAmbientColor(arg_28_0)
	if not arg_28_0.vars then
		return 
	end
	
	return arg_28_0.vars.ambient_color
end

function STORY_ACTION_MANAGER._createModels(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if not arg_29_0.vars or not arg_29_0.vars.n_bg or not arg_29_1 then
		return 
	end
	
	local var_29_0 = 0
	local var_29_1 = 0
	local var_29_2 = arg_29_2 == "left" and 1 or -1
	local var_29_3 = {}
	
	arg_29_1 = string.split(arg_29_1, ";")
	
	if arg_29_3 then
		for iter_29_0, iter_29_1 in pairs(arg_29_1) do
			local var_29_4 = string.split(iter_29_1, ",")
			local var_29_5 = {
				id = var_29_4[1],
				uid = var_29_4[2],
				x = tonumber(var_29_4[3]) or var_29_0,
				y = tonumber(var_29_4[4]) or var_29_1
			}
			
			table.insert(var_29_3, var_29_5)
		end
	else
		for iter_29_2, iter_29_3 in pairs(arg_29_1) do
			local var_29_6 = string.split(iter_29_3, ",")
			local var_29_7 = {
				id = var_29_6[1],
				uid = var_29_6[1],
				x = tonumber(var_29_6[2]) or var_29_0,
				y = tonumber(var_29_6[3]) or var_29_1
			}
			
			table.insert(var_29_3, var_29_7)
		end
	end
	
	for iter_29_4, iter_29_5 in pairs(var_29_3) do
		local var_29_8 = iter_29_5.id
		local var_29_9 = iter_29_5.uid
		local var_29_10 = iter_29_5.x
		local var_29_11 = iter_29_5.y
		
		STORY_V2_ACTIONS._s_spawn(var_29_9, var_29_8, 1, var_29_2, var_29_10, var_29_11, 0, 0, 0, true)
	end
end

function STORY_ACTION_MANAGER.activePortTextOnTouch(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:getPortText() or {}
	local var_30_1 = var_30_0[arg_30_0:getActivePortText_id()]
	
	if table.empty(var_30_0) or not var_30_1 then
		return 
	end
	
	if not STORY_ACTION_MANAGER:_canSkip() then
		return 
	end
	
	if not arg_30_0.vars.next_port_touch_tick then
		arg_30_0.vars.next_port_touch_tick = systick()
	end
	
	if arg_30_1 then
		arg_30_0.vars.next_port_touch_tick = systick()
		
		arg_30_0:activePortText()
		
		return 
	end
	
	if 500 > systick() - arg_30_0.vars.next_port_touch_tick then
		if systick() - arg_30_0.vars.next_port_touch_tick > 150 then
			STORY_ACTION_MANAGER:onUpdatePortActions(99999)
		end
	else
		arg_30_0.vars.next_port_touch_tick = systick()
		
		arg_30_0:activePortText()
		
		return true
	end
	
	return true
end

function STORY_ACTION_MANAGER.activePortText(arg_31_0)
	if not arg_31_0.vars or not arg_31_0:getActivePortText_id() then
		return 
	end
	
	local var_31_0 = false
	local var_31_1 = arg_31_0:getPortText()
	local var_31_2 = var_31_1[arg_31_0:getActivePortText_id()]
	
	if not var_31_1 or table.empty(var_31_1) or not var_31_2 then
		return 
	end
	
	for iter_31_0, iter_31_1 in pairs(var_31_2) do
		STORY_V2_SUB_ACTIONS:updatePortText_UI(iter_31_1, false)
		arg_31_0:settingPortActions()
		
		var_31_0 = true
		
		if not DEBUG.STOP_STA_AUTO_NEXT and not StoryAction:Find("story_v2.auto_play") and not StoryAction:Find("story_port_auto_next") then
			StoryAction:Add(SEQ(DELAY(arg_31_0.vars._d + 100), CALL(function()
				if arg_31_0.vars.prev_action_id then
					arg_31_0:story_action_step_next_bt_action_id(arg_31_0.vars.prev_action_id)
				else
					arg_31_0:story_action_step_next_on_touch()
				end
			end)), STORY_ACTION_MANAGER, "story_port_auto_next")
		end
		
		break
	end
	
	table.remove(var_31_2, 1)
	
	if var_31_0 then
		return var_31_0
	end
	
	if table.empty(var_31_2) and not StoryAction:Find("story_v2.auto_play") and not StoryAction:Find("story_port_auto_next") then
		arg_31_0:setActivePortText(nil)
		
		arg_31_0.vars.next_port_touch_tick = nil
		
		local var_31_3 = arg_31_0:getPortParent()
		
		if get_cocos_refid(var_31_3) then
			var_31_3:removeAllChildren()
		end
		
		StoryAction:Add(SEQ(DELAY(arg_31_0.vars._d + 100), CALL(function()
			if arg_31_0.vars.prev_action_id then
				arg_31_0:story_action_step_next_bt_action_id(arg_31_0.vars.prev_action_id)
			else
				arg_31_0:story_action_step_next_on_touch()
			end
		end)), STORY_ACTION_MANAGER, "story_port_auto_next")
		
		return 
	end
	
	return var_31_0
end

function STORY_ACTION_MANAGER.setActivePortText(arg_34_0, arg_34_1)
	arg_34_0.vars.active_port_text_id = arg_34_1
end

function STORY_ACTION_MANAGER.getActivePortText_id(arg_35_0)
	return arg_35_0.vars.active_port_text_id
end

function STORY_ACTION_MANAGER.endPortText(arg_36_0)
	arg_36_0.vars.active_port_text_id = nil
end

function STORY_ACTION_MANAGER.addPortText(arg_37_0, arg_37_1, arg_37_2)
	arg_37_0.vars.story_port_texts[arg_37_1] = arg_37_2
end

function STORY_ACTION_MANAGER.getPortText(arg_38_0)
	return arg_38_0.vars.story_port_texts
end

function STORY_ACTION_MANAGER.setAllModelAnim(arg_39_0, arg_39_1)
	if not arg_39_0.vars or not is_using_story_v2() then
		return 
	end
	
	local var_39_0 = arg_39_0:getModelIds() or {}
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		local var_39_1 = _getTargetNodeModel(iter_39_1)
		
		if get_cocos_refid(var_39_1) then
			if arg_39_1 then
				var_39_1:pauseAnimation()
			else
				var_39_1:resumeAnimation()
			end
		end
	end
end

function STORY_ACTION_MANAGER.setModelIds(arg_40_0, arg_40_1)
	arg_40_0.vars.models_id = arg_40_1
end

function STORY_ACTION_MANAGER.getModelIds(arg_41_0)
	return arg_41_0.vars.models_id
end

function STORY_ACTION_MANAGER.addWorldTalks(arg_42_0, arg_42_1)
	table.insert(arg_42_0.vars.world_talks, arg_42_1)
end

function STORY_ACTION_MANAGER.getWorldTalks(arg_43_0)
	if not arg_43_0.vars then
		return {}
	end
	
	return arg_43_0.vars.world_talks
end

function STORY_ACTION_MANAGER.updateTextNodePosition(arg_44_0)
	if not arg_44_0.vars then
		return 
	end
	
	local var_44_0 = arg_44_0:getWorldTalks()
	
	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		if get_cocos_refid(iter_44_1) and iter_44_1.n_target and get_cocos_refid(iter_44_1.n_target) and iter_44_1.n_target:isVisible() then
			local var_44_1, var_44_2 = iter_44_1.n_target:getPosition()
			
			if iter_44_1.m_x then
				var_44_1 = var_44_1 + iter_44_1.m_x
			end
			
			if iter_44_1.m_y then
				var_44_2 = var_44_2 + iter_44_1.m_y
			end
			
			iter_44_1:setPosition(var_44_1 + var_0_0, var_44_2 + var_0_1)
		elseif get_cocos_refid(iter_44_1) then
			iter_44_1:setVisible(false)
		end
	end
end

function STORY_ACTION_MANAGER.removeCheckWorldTalks(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	local var_45_0 = arg_45_0:getWorldTalks()
	
	for iter_45_0 = table.count(var_45_0), 1, -1 do
		if not get_cocos_refid(var_45_0[iter_45_0]) then
			table.remove(var_45_0, iter_45_0)
		end
	end
end

function STORY_ACTION_MANAGER.stopAllSounds(arg_46_0)
	if not arg_46_0.vars or not arg_46_0.vars.sounds then
		return 
	end
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0.vars.sounds) do
		if get_cocos_refid(iter_46_1) then
			iter_46_1:stop()
		end
	end
	
	arg_46_0.vars.sounds = {}
end

function STORY_ACTION_MANAGER.addSounds(arg_47_0, arg_47_1)
	if not arg_47_1 then
		return 
	end
	
	table.insert(arg_47_0.vars.sounds, arg_47_1)
end

function STORY_ACTION_MANAGER.getSounds(arg_48_0)
	return arg_48_0.vars.sounds
end

function STORY_ACTION_MANAGER._debug_draw_position()
	var_0_3(false)
	
	local var_49_0 = STORY_ACTION_MANAGER:getLayer()
	local var_49_1 = 0
	local var_49_2 = 0
	
	for iter_49_0 = 1, 10 do
		for iter_49_1 = 1, 50 do
			local var_49_3 = 1
			local var_49_4 = 24
			local var_49_5 = ccui.Text:create()
			
			var_49_5:setContentSize({
				width = 150,
				height = 100
			})
			var_49_5:setFontName("font/daum.ttf")
			var_49_5:setColor(cc.c3b(255, 255, 200), cc.c3b(255, 255, 200))
			var_49_5:enableOutline(cc.c3b(0, 0, 0), var_49_3)
			var_49_5:setFontSize(var_49_4)
			var_49_5:setString("(" .. var_49_1 .. "," .. var_49_2 .. ")")
			var_49_0:addChild(var_49_5)
			var_49_5:setPosition(var_49_1, var_49_2)
			
			var_49_1 = var_49_1 + 100
		end
		
		var_49_2 = var_49_2 + 50
		var_49_1 = 0
	end
end

function STORY_ACTION_MANAGER.distroy(arg_50_0)
	if not is_using_story_v2() or not arg_50_0 or not arg_50_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_50_0.layer) then
		arg_50_0.layer:removeFromParent()
		
		arg_50_0.layer = nil
		
		if get_cocos_refid(arg_50_0.vars.pivot) then
			arg_50_0.vars.pivot:removeFromParent()
			
			arg_50_0.vars.pivot = nil
		end
		
		if get_cocos_refid(arg_50_0.vars.n_portrait) then
			arg_50_0.vars.n_portrait:removeFromParent()
			
			arg_50_0.vars.n_portrait = nil
		end
		
		BGIManager:removeBGI("story")
		
		if SceneManager:getCurrentSceneName() == "battle" then
			BattleField:init("battle")
			
			if BGI and get_cocos_refid(BGI.game_layer) then
				BGI.game_layer:setVisible(true)
			end
		end
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		LuaEventDispatcher:resumeSendEventToListenerByKey("spine.ani", "battle")
		LuaEventDispatcher:resumeSendEventToListenerByKey("battle.event", "battle")
	else
		BattleField:clear()
	end
	
	LuaEventDispatcher:removeEventListenerByKey("STORY_ACTION_MANAGER")
	
	arg_50_0.vars = nil
	
	if var_0_7 then
		setenv("time_scale", var_0_7)
		
		var_0_7 = nil
	end
end

function STORY_ACTION_MANAGER.onAniEvent(arg_51_0)
	if not is_using_story_v2() or not STORY_ACTION_MANAGER:is_playing_skill() then
		return 
	end
	
	EffectManager:onAniEvent(arg_51_0)
	StageStateManager:onAniEvent(arg_51_0)
end

function STORY_ACTION_MANAGER.onEvent(arg_52_0, arg_52_1, ...)
	if not is_using_story_v2() or not STORY_ACTION_MANAGER:is_playing_skill() then
		return 
	end
	
	local var_52_0 = {
		...
	}
	
	if arg_52_1.sender == "state.hit" then
		STORY_ACTION_MANAGER:onDoHit(arg_52_1)
		
		return 
	end
	
	if arg_52_1.sender == "state.fire" then
		return 
	end
end

function STORY_ACTION_MANAGER.onDoHit(arg_53_0, arg_53_1)
	arg_53_0.hitCount = (arg_53_0.hitCount or 0) + 1
	
	local var_53_0 = arg_53_1.unit
	local var_53_1 = arg_53_0:getAttackInfo(var_53_0)
	local var_53_2 = true
	
	arg_53_0.show_hit_effect = true
	
	if var_53_1 and arg_53_0.show_hit_effect then
		for iter_53_0, iter_53_1 in pairs(var_53_1.d_units) do
			if not StageStateManager:hasStateActionFlagsByActor(var_53_0.model, "ignore_default_motion") and get_cocos_refid(iter_53_1.model) then
				BattleAction:Finish("battle.damage_motion" .. iter_53_0)
				BattleAction:Add(SEQ(DMOTION(500, "attacked", false), DELAY(60), Battle:getIdleAction(iter_53_1)), iter_53_1.model, "battle.damage_motion" .. iter_53_0)
			end
		end
	else
		print("HIT!", arg_53_0.hitCount)
	end
	
	if var_53_2 then
		Battle:onFireEffect(var_53_1, {
			attacker = var_53_0,
			targets = var_53_1.d_units,
			eff_info = arg_53_1.info
		})
	end
end

function STORY_ACTION_MANAGER.getAttackInfo(arg_54_0, arg_54_1)
	if not arg_54_1 or not arg_54_0.att_info_map then
		return 
	end
	
	return arg_54_0.att_info_map[arg_54_1]
end

function STORY_ACTION_MANAGER.setAttackInfo(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0.att_info = arg_55_2
	
	if not arg_55_0.att_info_map then
		arg_55_0.att_info_map = {}
	end
	
	arg_55_0.att_info_map[arg_55_1] = arg_55_2
end

function STORY_ACTION_MANAGER.getLayer(arg_56_0)
	return arg_56_0.layer
end

function STORY_ACTION_MANAGER.isEmptyStoryQueue(arg_57_0)
	if not arg_57_0.vars or not arg_57_0.vars.story_queue then
		return 
	end
	
	return table.empty(arg_57_0.vars.story_queue)
end

function STORY_ACTION_MANAGER.needShowCursor(arg_58_0)
	if not arg_58_0.vars or not is_using_story_v2() then
		return 
	end
	
	local var_58_0 = var_0_6()
	
	for iter_58_0, iter_58_1 in pairs(var_58_0) do
		if iter_58_1.talker and iter_58_1.talker == "NARRATION" then
			return true
		end
	end
	
	if not arg_58_0:isStartAction() then
		return true
	end
end

function STORY_ACTION_MANAGER.test_story_v2_story_init(arg_59_0)
	arg_59_0.vars.story_queue = {}
	arg_59_0.vars.story_action_id = nil
	
	for iter_59_0, iter_59_1 in pairs(STORY.story) do
		for iter_59_2, iter_59_3 in pairs(iter_59_1) do
			local var_59_0
			
			if iter_59_3.story_action then
				if not arg_59_0.vars.story_queue[iter_59_3.story_action] then
					arg_59_0.vars.story_queue[iter_59_3.story_action] = {}
				end
				
				arg_59_0.vars.story_action_id = iter_59_3.story_action
				var_59_0 = {}
				
				local var_59_1 = false
				
				for iter_59_4 = 1, 9999999 do
					local var_59_2 = string.format("%s_%02d", arg_59_0.vars.story_action_id, iter_59_4)
					local var_59_3 = DBT("story_action_list", var_59_2, {
						"id",
						"action",
						"target",
						"value",
						"time",
						"after"
					})
					
					if not var_59_3 or not var_59_3.id then
						break
					end
					
					if var_59_3.action and (var_59_3.action == "animate" or var_59_3.action == "use_skill") and var_59_3.value and string.starts(var_59_3.value, "mute;") then
						var_59_3.mute = true
						var_59_3.value = string.gsub(var_59_3.value, "mute;", "")
					end
					
					local var_59_4 = string.format("%s_%02d", arg_59_0.vars.story_action_id, iter_59_4 + 1)
					local var_59_5 = DBT("story_action_list", var_59_4, {
						"id",
						"after"
					})
					local var_59_6 = var_59_5 and var_59_5.id and var_59_5.after and true or false
					
					if var_59_3.time then
						var_59_3.time = tonumber(var_59_3.time) * 1.2
					else
						var_59_3.time = 0
					end
					
					table.insert(var_59_0, var_59_3)
					
					if not var_59_6 then
						table.insert(arg_59_0.vars.story_queue[arg_59_0.vars.story_action_id], var_59_0)
						
						var_59_0 = {}
					end
				end
			end
		end
	end
end

STORY_V2_ACTIONS = {}

function STORY_ACTION_MANAGER.test_story_v2_story_build(arg_60_0)
	if not arg_60_0.vars or table.empty(arg_60_0.vars.story_queue) then
		return 
	end
	
	for iter_60_0, iter_60_1 in pairs(arg_60_0.vars.story_queue) do
		for iter_60_2, iter_60_3 in pairs(iter_60_1) do
			for iter_60_4, iter_60_5 in pairs(iter_60_3) do
				if iter_60_5.action == "text" or iter_60_5.action == "portrait_text" then
					iter_60_5.sub_action_data = STORY_ACTION_MANAGER:_get_sub_action_datas(iter_60_5.action, iter_60_5.value)
				elseif iter_60_5.action == "effect" then
					local var_60_0 = string.split(iter_60_5.value, ";")
					local var_60_1 = var_60_0[1]
					local var_60_2 = var_60_0[2] and var_60_0[2] == "y" or false
					
					var_60_1 = var_60_1 and string.split(var_60_1, ",")
					iter_60_5.sub_action_data = {
						effect_path = iter_60_5.target,
						x = var_60_1[1],
						y = var_60_1[2],
						flip = var_60_2
					}
				end
			end
		end
	end
end

function STORY_ACTION_MANAGER._get_sub_action_datas(arg_61_0, arg_61_1, arg_61_2)
	if not arg_61_1 or not arg_61_2 then
		return 
	end
	
	local var_61_0 = {}
	
	arg_61_2 = tostring(arg_61_2)
	
	if arg_61_1 == "text" then
		var_61_0 = DBT("story_action_text", arg_61_2, {
			"id",
			"position",
			"scale",
			"voice",
			"name",
			"face_id",
			"face_icon"
		})
		
		if not var_61_0 or not var_61_0.id then
			Log.e("STORY_V2 Err, Not Found Text Id: ", arg_61_2)
			
			return 
		end
	elseif arg_61_1 == "portrait_text" then
		local var_61_1 = DBT("story_action_portrait", arg_61_2, {
			"id",
			"portrait_id",
			"name",
			"portrait_position",
			"zoom",
			"portrait_offset",
			"face_id",
			"voice"
		})
		
		if not var_61_1 or not var_61_1.id then
			Log.e("Err: no portrait text data: ", arg_61_2)
			
			return 
		end
		
		table.insert(var_61_0, var_61_1)
	end
	
	if arg_61_1 == "text" and var_61_0.position then
		if var_61_0.position then
			local var_61_2 = string.split(var_61_0.position, ",")
			
			var_61_0.x = var_61_2[1]
			var_61_0.y = var_61_2[2]
		else
			var_61_0.x = 0
			var_61_0.y = 0
		end
		
		if var_61_0.time then
			var_61_0.time = tonumber(var_61_0.time) * 1.2
		end
	end
	
	if arg_61_1 == "portrait_text" then
		({})[arg_61_2] = var_61_0
		
		STORY_ACTION_MANAGER:addPortText(arg_61_2, var_61_0)
	end
	
	return var_61_0
end

function STORY_ACTION_MANAGER.onUpdate(arg_62_0, arg_62_1)
	if not arg_62_0.vars or not arg_62_0.vars.actions or table.empty(arg_62_0.vars.actions) then
		return 
	end
	
	if STORY == nil then
		return 
	end
	
	if STORY.actions == nil then
		return 
	end
	
	if not STORY_ACTION_MANAGER:isNotPausedStoryAction() then
		return 
	end
	
	for iter_62_0 = 1, table.count(arg_62_0.vars.actions) do
		local var_62_0 = arg_62_0.vars.actions[iter_62_0]
		local var_62_1
		
		if var_62_0 then
			if type(var_62_0.TARGET) == "table" or get_cocos_refid(var_62_0.TARGET) then
				if var_62_0.finished then
					var_62_0.removed = true
				else
					var_62_1 = xpcall(var_62_0.Update, __G__TRACKBACK__, var_62_0, nil, arg_62_1)
				end
			else
				var_62_0.removed = true
			end
			
			if not var_62_1 then
				var_62_0.removed = true
			end
		end
	end
	
	if arg_62_0.vars.actions == nil or table.empty(arg_62_0.vars.actions) then
		return 
	end
	
	for iter_62_1 = table.count(arg_62_0.vars.actions), 1, -1 do
		local var_62_2 = arg_62_0.vars.actions[iter_62_1]
		
		if var_62_2 and var_62_2.removed then
			table.remove(arg_62_0.vars.actions, iter_62_1)
		end
	end
end

function STORY_ACTION_MANAGER.onUpdatePortActions(arg_63_0, arg_63_1)
	if not arg_63_0.vars or not arg_63_0.vars.port_text_actions or table.empty(arg_63_0.vars.port_text_actions) then
		return 
	end
	
	if STORY == nil then
		return 
	end
	
	if STORY.actions == nil then
		return 
	end
	
	if not STORY_ACTION_MANAGER:isNotPausedStoryAction() then
		return 
	end
	
	for iter_63_0 = 1, table.count(arg_63_0.vars.port_text_actions) do
		local var_63_0 = arg_63_0.vars.port_text_actions[iter_63_0]
		local var_63_1
		
		if var_63_0 then
			if type(var_63_0.TARGET) == "table" or get_cocos_refid(var_63_0.TARGET) then
				if var_63_0.finished then
					var_63_0.removed = true
				else
					var_63_1 = xpcall(var_63_0.Update, __G__TRACKBACK__, var_63_0, nil, arg_63_1)
				end
			else
				var_63_0.removed = true
			end
			
			if not var_63_1 then
				var_63_0.removed = true
			end
		end
	end
	
	if arg_63_0.vars.port_text_actions == nil or table.empty(arg_63_0.vars.port_text_actions) then
		return 
	end
	
	for iter_63_1 = table.count(arg_63_0.vars.port_text_actions), 1, -1 do
		local var_63_2 = arg_63_0.vars.port_text_actions[iter_63_1]
		
		if var_63_2 and var_63_2.removed then
			table.remove(arg_63_0.vars.port_text_actions, iter_63_1)
		end
	end
end

function STORY_ACTION_MANAGER.settingActions(arg_64_0)
	if not arg_64_0.vars.ready_actions or table.empty(arg_64_0.vars.ready_actions) then
		return 
	end
	
	arg_64_0.vars.actions = {
		StoryAction:create(SPAWN(table.unpack(arg_64_0.vars.ready_actions)), STORY_ACTION_MANAGER)
	}
	arg_64_0.vars.ready_actions = {}
end

function STORY_ACTION_MANAGER.settingPortActions(arg_65_0)
	if not arg_65_0.vars.ready_port_text_actions or table.empty(arg_65_0.vars.ready_port_text_actions) then
		return 
	end
	
	table.insert(arg_65_0.vars.port_text_actions, StoryAction:create(SPAWN(table.unpack(arg_65_0.vars.ready_port_text_actions)), STORY_ACTION_MANAGER))
	
	arg_65_0.vars.ready_port_text_actions = {}
end

function STORY_ACTION_MANAGER.story_action_step_next_on_touch(arg_66_0)
	if not is_using_story_v2() then
		return 
	end
	
	if StoryAction:Find("story_v2.auto_play") then
		if not arg_66_0.vars.next_touch_tick then
			arg_66_0.vars.next_touch_tick = systick()
		end
		
		if 2000 > systick() - arg_66_0.vars.next_touch_tick then
		else
			arg_66_0.vars.next_touch_tick = systick()
			
			STORY_ACTION_MANAGER:stopAllSounds()
		end
	end
	
	if StoryAction:Find("story_v2.auto_play") then
		return 
	end
	
	local var_66_0
	local var_66_1 = var_0_6()
	
	for iter_66_0, iter_66_1 in pairs(var_66_1) do
		if iter_66_1.story_action then
			var_66_0 = iter_66_1.story_action
			
			break
		end
	end
	
	if var_66_0 then
		STORY_ACTION_MANAGER:story_v2_story_step_action_by_id(var_66_0)
	else
		if arg_66_0.vars.prev_action_id then
			STORY_ACTION_MANAGER:setVisibleStoryTalkUI(true)
			STORY_ACTION_MANAGER:setPortTextUI(false)
		end
		
		if step_next() then
			stop_story()
			
			return 
		end
	end
end

function STORY_ACTION_MANAGER.story_action_step_next_bt_action_id(arg_67_0, arg_67_1)
	if not is_using_story_v2() or not arg_67_1 then
		return 
	end
	
	if not STORY_ACTION_MANAGER:_canSkip() then
		return 
	end
	
	STORY_ACTION_MANAGER:story_v2_story_step_action_by_id(arg_67_1)
end

function STORY_ACTION_MANAGER._story_v2_story_step_action_by_data(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_1 then
		return 
	end
	
	local var_68_0 = arg_68_2 or false
	local var_68_1 = 0
	local var_68_2 = false
	
	if var_68_0 then
		arg_68_1.time = 0
		
		if string.find(arg_68_1.action, "remove") then
			arg_68_1.animation = "remove"
		end
	end
	
	if not arg_68_1.action then
		Log.e("Err: no main action", arg_68_1.id)
		
		return 
	end
	
	if arg_68_1 and arg_68_1.id then
	end
	
	local var_68_3 = arg_68_1.action
	local var_68_4 = STORY_V2_ACTIONS["_s_" .. var_68_3]
	
	if var_68_3 == "empty" then
		var_68_1 = var_68_4()
	elseif var_68_3 == "fadein" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "fadeout" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "use_skill" then
		STORY_ACTION_MANAGER:set_playing_skill(true)
		
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.mute, arg_68_1.time, var_68_0)
		var_68_1 = var_68_1 or 0
		var_68_1 = var_68_1 - var_0_2 * 2.4
		
		if arg_68_1.id and arg_68_1.id == "tot001_c_08" then
			var_68_1 = var_68_1 - 500
		end
	elseif var_68_3 == "animate" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.mute, arg_68_1.time, arg_68_1.id, var_68_0)
	elseif var_68_3 == "ca_move" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "remove" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "move" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "flip" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "zoom_reset" then
		var_68_1 = var_68_4(arg_68_1.time, var_68_0)
	elseif var_68_3 == "delay" then
		var_68_1 = var_68_4(arg_68_1.time, var_68_0)
	elseif var_68_3 == "shake" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "zoom" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "portrait_text" then
		var_68_1, var_68_2 = STORY_V2_SUB_ACTIONS:show_portrait_text(arg_68_1.target, arg_68_1.sub_action_data, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "text" then
		var_68_1 = STORY_V2_SUB_ACTIONS:SHOW(arg_68_1.target, arg_68_1.sub_action_data, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "effect" then
		var_68_1 = STORY_V2_SUB_ACTIONS:PLAY(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	elseif var_68_3 == "sound_effect" then
		var_68_1 = var_68_4(arg_68_1.target, arg_68_1.value, arg_68_1.time, var_68_0)
	else
		Log.e("Err: wrong_actor_list: ", arg_68_1.id, arg_68_1.main_action)
	end
	
	var_68_1 = var_68_1 or 0
	
	if var_68_3 ~= "portrait_text" then
		STORY_ACTION_MANAGER:setPortTextUI(false)
	end
	
	return var_68_1, var_68_2
end

local var_0_8

function STORY_ACTION_MANAGER.setVisibleStoryTalkUI(arg_69_0, arg_69_1, arg_69_2)
	if not arg_69_0.vars or not get_cocos_refid(STORY.layer) then
		return 
	end
	
	if not arg_69_2 then
		STORY.childs.n_talk:setVisible(false)
	end
	
	STORY.layer:getChildByName("n_portrait"):setVisible(arg_69_1)
	STORY.layer:getChildByName("n_bg"):setVisible(arg_69_1)
	
	if arg_69_1 then
		arg_69_0.vars.start_action = false
		
		local var_69_0 = STORY.PREV_AUTO_STORY_SPEED or 0
		
		set_auto_story_speed(var_69_0, false)
		STORY.layer:getChildByName("btn_play"):setVisible(true)
		update_auto_play()
	end
end

function STORY_ACTION_MANAGER.isStartAction(arg_70_0)
	if not arg_70_0.vars then
		return 
	end
	
	return arg_70_0.vars.start_action
end

function STORY_ACTION_MANAGER.story_v2_story_step_action_by_id(arg_71_0, arg_71_1)
	if not arg_71_0.vars or not arg_71_0.vars.story_queue or not arg_71_1 then
		return 
	end
	
	if table.empty(arg_71_0.vars.story_queue) then
		STORY_ACTION_MANAGER:setVisibleStoryTalkUI(true)
		STORY_ACTION_MANAGER:setPortTextUI(false)
		
		if step_next() then
			stop_story()
			
			return 
		end
		
		return 
	end
	
	if not arg_71_0.vars.start_action then
		clear_character("left")
		clear_character("mid")
		clear_character("right")
		
		arg_71_0.vars.start_action = true
		
		STORY.layer:getChildByName("btn_play"):setVisible(false)
		STORY.childs.btn_speed:setVisible(false)
		
		STORY.PREV_AUTO_STORY_SPEED = STORY.AUTO_STORY_SPEED
		
		set_auto_story_speed(0, false)
		update_auto_play()
	end
	
	STORY_ACTION_MANAGER:setVisibleStoryTalkUI(false)
	var_0_4(false)
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0.vars.story_queue) do
		if arg_71_1 == iter_71_0 then
			if table.empty(iter_71_1) then
				arg_71_0.vars.story_queue[iter_71_0] = nil
				arg_71_0.vars.prev_action_id = nil
				
				STORY_ACTION_MANAGER:setPortTextUI(false)
				STORY_ACTION_MANAGER:setVisibleStoryTalkUI(true, true)
				
				local var_71_0 = step_next()
				local var_71_1 = true
				local var_71_2 = STORY.index or 0
				
				if STORY.story[var_71_2] and STORY.story[var_71_2][1] then
					local var_71_3 = STORY.story[var_71_2][1]
					
					if var_71_3.movie or var_71_3.story_action then
						var_71_1 = false
					end
				end
				
				if var_71_1 then
					var_0_4(true)
				else
					var_0_4(false)
				end
				
				if var_71_0 then
					stop_story()
					
					return 
				end
				
				return 
			end
			
			for iter_71_2, iter_71_3 in pairs(iter_71_1) do
				local var_71_4 = 0
				local var_71_5 = 0
				local var_71_6 = false
				
				STORY_ACTION_MANAGER:setCurActionData(iter_71_3)
				
				for iter_71_4, iter_71_5 in pairs(iter_71_3) do
					local var_71_7 = 0
					local var_71_8 = iter_71_5.id
					local var_71_9 = iter_71_5.action
					local var_71_10 = iter_71_5.target
					local var_71_11 = iter_71_5.value
					local var_71_12 = iter_71_5.time
					local var_71_13 = iter_71_5.sub_action_data
					local var_71_14 = false
					local var_71_15, var_71_16 = arg_71_0:_story_v2_story_step_action_by_data(iter_71_5)
					
					if not var_71_6 and var_71_16 then
						var_71_6 = true
					end
					
					var_71_4 = math.max(var_71_4, var_71_15)
					var_0_8 = iter_71_5.id
				end
				
				arg_71_0.vars.prev_action_id = iter_71_0
				
				local var_71_17 = var_71_4 + var_0_2
				
				arg_71_0.vars._d = var_71_17 or 0
				
				if not var_71_6 and not DEBUG.STOP_STA_AUTO_NEXT then
					StoryAction:Remove("story_v2.auto_play")
					StoryAction:Add(SEQ(DELAY(var_71_17), CALL(function()
						STORY_ACTION_MANAGER:story_v2_story_step_action_by_id(arg_71_1)
					end)), STORY_ACTION_MANAGER, "story_v2.auto_play")
				else
					StoryAction:Add(SEQ(DELAY(var_71_17)), STORY_ACTION_MANAGER, "block")
				end
				
				table.remove(iter_71_1, 1)
				STORY_ACTION_MANAGER:settingActions()
				
				return 
			end
		end
	end
end

function STORY_ACTION_MANAGER.canUseBackBtn(arg_73_0)
	return is_using_story_v2() and STORY_ACTION_MANAGER:is_playing_skill()
end

function STORY_ACTION_MANAGER.is_playing_skill(arg_74_0)
	if not arg_74_0.vars then
		return 
	end
	
	return arg_74_0.vars.is_playing_skill
end

function STORY_ACTION_MANAGER.set_playing_skill(arg_75_0, arg_75_1)
	if not arg_75_0.vars then
		return 
	end
	
	arg_75_0.vars.is_playing_skill = arg_75_1
end

function STORY_ACTION_MANAGER.isNotPausedStoryAction(arg_76_0)
	if not arg_76_0.vars then
		return true
	end
	
	if StoryViewer:isActive() then
		return 
	end
	
	if get_cocos_refid(STORY.skip_popup) then
		return 
	end
	
	if get_cocos_refid(STORY.active_popup_dlg) then
		return 
	end
	
	if StoryEsc:isOpen() then
		return 
	end
	
	if UIAction:Find("block") then
		return 
	end
	
	if NetWaiting:isWaiting() == true then
		return 
	end
	
	return true
end

function STORY_ACTION_MANAGER.skipStoryAction(arg_77_0)
	if not is_using_story_v2() or not arg_77_0.vars or not arg_77_0.vars.story_queue or not STORY.story_id or not STORY_ACTION_MANAGER:isStartAction() then
		return 
	end
	
	local var_77_0 = var_0_6()
	
	if var_77_0 and var_77_0[1] and var_77_0[1].story_action and arg_77_0.vars.story_queue[var_77_0[1].story_action] then
		StoryAction:RemoveAll()
		
		arg_77_0.vars.story_queue[var_77_0[1].story_action] = nil
		arg_77_0.vars.story_port_texts = {}
	end
	
	if get_cocos_refid(arg_77_0.vars.n_portrait) then
		arg_77_0.vars.n_portrait:removeFromParent()
		
		arg_77_0.vars.n_portrait = nil
	end
	
	arg_77_0.vars.actions = {}
	arg_77_0.vars.port_text_actions = {}
	
	STORY_ACTION_MANAGER:setVisibleStoryTalkUI(true)
	STORY_ACTION_MANAGER:setPortTextUI(false)
	STORY_ACTION_MANAGER:stopAllSounds()
end

function STORY_ACTION_MANAGER._canSkip(arg_78_0)
	if arg_78_0:is_playing_skill() then
		return 
	end
	
	return true
end

function STORY_ACTION_MANAGER._canOpenStoryLogPopup(arg_79_0)
	return arg_79_0:_canSkip()
end

function STORY_ACTION_MANAGER.setCurActionData(arg_80_0, arg_80_1)
	arg_80_0.vars.cur_action_data = arg_80_1
end

function STORY_ACTION_MANAGER.getCurActionData(arg_81_0)
	if not arg_81_0.vars then
		return 
	end
	
	return arg_81_0.vars.cur_action_data
end

function STORY_ACTION_MANAGER.setBGSpeed(arg_82_0, arg_82_1)
	arg_82_0.vars.bg_speed = arg_82_1
end

function STORY_ACTION_MANAGER.getBGSpeed(arg_83_0)
	if not arg_83_0.vars then
		return 
	end
	
	return arg_83_0.vars.bg_speed or 0
end

function STORY_ACTION_MANAGER._activate_sub_action(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
	if not arg_84_1 or not arg_84_2 or table.empty(arg_84_2) then
		return 
	end
	
	local var_84_0 = 0
	
	if arg_84_1 == "text" then
		var_84_0 = STORY_V2_SUB_ACTIONS:SHOW(arg_84_2, arg_84_3)
	elseif arg_84_1 == "effect" then
		var_84_0 = STORY_V2_SUB_ACTIONS:PLAY(arg_84_2, arg_84_3)
	else
		Log.e("Wrong Sub Action Type: ", arg_84_1, arg_84_2.id)
	end
	
	return var_84_0 or 0
end

function STORY_ACTION_MANAGER.getTextSubActionByActionID(arg_85_0, arg_85_1)
	if not arg_85_0.vars or not arg_85_0.vars.story_queue or not arg_85_1 then
		return 
	end
	
	local var_85_0 = {}
	
	for iter_85_0, iter_85_1 in pairs(arg_85_0.vars.story_queue) do
		if iter_85_0 == arg_85_1 then
			for iter_85_2, iter_85_3 in pairs(iter_85_1) do
				for iter_85_4, iter_85_5 in pairs(iter_85_3) do
					if iter_85_5.action == "text" then
						local var_85_1 = iter_85_5.value
						local var_85_2, var_85_3, var_85_4, var_85_5, var_85_6 = DB("story_action_text", var_85_1, {
							"id",
							"face_id",
							"name",
							"face_icon",
							"position"
						})
						
						if var_85_2 then
							local var_85_7 = var_85_2
							local var_85_8 = DB("character", var_85_3, {
								"name"
							})
							
							table.insert(var_85_0, {
								code = var_85_3,
								text = var_85_7,
								name = var_85_8
							})
						end
					elseif iter_85_5.action == "portrait_text" then
						local var_85_9 = iter_85_5.value
						local var_85_10, var_85_11, var_85_12 = DB("story_action_portrait", var_85_9, {
							"id",
							"portrait_id",
							"name"
						})
						
						if var_85_10 then
							local var_85_13 = var_85_10
							
							table.insert(var_85_0, {
								code = var_85_11,
								text = var_85_13,
								name = var_85_12
							})
						end
					end
				end
			end
		end
	end
	
	return var_85_0
end

function STORY_ACTION_MANAGER._debugUpdatePositionLabel(arg_86_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_86_0.vars then
		return 
	end
	
	local var_86_0 = STORY_ACTION_MANAGER:getModelIds()
	
	if not var_86_0 or table.empty(var_86_0) then
		return 
	end
	
	for iter_86_0, iter_86_1 in pairs(var_86_0) do
		local var_86_1 = _getTargetNodeModel(iter_86_1)
		local var_86_2 = _getTargetLayout(iter_86_1)
		local var_86_3 = BattleLayout:getStoryLayoutUnit(iter_86_1)
		
		if var_86_2 and get_cocos_refid(var_86_1) and var_86_1.t_pos and var_86_3 and var_86_3.mover then
			if DEBUG.SHOW_STORYV2_POSITION then
				local var_86_4, var_86_5 = var_86_2:getPosition()
				
				var_86_1.t_pos:setString(iter_86_1 .. "(" .. var_86_4 .. "/" .. var_86_5 .. ")")
				var_86_1.t_pos:setVisible(true)
				
				if var_86_1:getScaleX() < 0 then
					var_86_1.t_pos:setScaleX(-1)
				else
					var_86_1.t_pos:setScaleX(1)
				end
			else
				var_86_1.t_pos:setVisible(false)
			end
		end
	end
end

function STORY_ACTION_MANAGER._debugUpdatePositionOnConsole(arg_87_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_87_0.vars then
		return 
	end
	
	local var_87_0 = STORY_ACTION_MANAGER:getModelIds()
	
	if not var_87_0 or table.empty(var_87_0) then
		return 
	end
	
	print("--------------------- story_action_position ---------------------")
	
	for iter_87_0, iter_87_1 in pairs(var_87_0) do
		local var_87_1 = _getTargetNodeModel(iter_87_1)
		local var_87_2 = _getTargetLayout(iter_87_1)
		local var_87_3 = BattleLayout:getStoryLayoutUnit(iter_87_1)
		
		if var_87_2 and get_cocos_refid(var_87_1) and var_87_3 and var_87_3.mover then
			local var_87_4, var_87_5 = var_87_2:getPosition()
			
			print("uid: " .. iter_87_1, "//", "x: " .. var_87_4, "y: " .. var_87_5)
		end
	end
end

function _DEBUG_SKIP_CUR_STORY_ACTION()
	local var_88_0 = STORY_ACTION_MANAGER:getCurActionData()
	
	if not var_88_0 then
		Log.e("Err: no current action Data")
		
		return 
	end
	
	if not STORY_ACTION_MANAGER:_canSkip() then
		return 
	end
	
	if StoryAction:Find("story_v2.proc_next") then
		return 
	end
	
	DEBUG.STOP_STA_AUTO_NEXT = true
	
	StoryAction:RemoveAll()
	STORY_ACTION_MANAGER:stopAllSounds()
	STORY_ACTION_MANAGER:activePortTextOnTouch(true)
	
	STORY_ACTION_MANAGER.vars.actions = {}
	
	local var_88_1 = {
		"use_skill",
		"shake",
		"sound_effect",
		"effect",
		"flip",
		"portrait_text",
		"text"
	}
	local var_88_2 = 99999
	local var_88_3 = 2000
	local var_88_4 = 999999
	
	for iter_88_0, iter_88_1 in pairs(var_88_0) do
		local var_88_5 = iter_88_1
		local var_88_6 = 0
		
		if var_88_5.action then
			if table.find(var_88_1, var_88_5.action) then
				var_88_5.action = "empty"
			elseif var_88_5.action == "animate" then
				local var_88_7, var_88_8 = _build_value_table("animate", var_88_5.value)
				local var_88_9 = string.split(var_88_5.value, ";")
				local var_88_10 = var_88_9[table.count(var_88_9)]
				
				var_88_5.value = var_88_8 .. ";" .. var_88_10
			elseif var_88_5.action == "ca_move" then
				var_88_5.time = 0
			end
		end
		
		if var_88_5.action then
			var_88_6 = STORY_ACTION_MANAGER:_story_v2_story_step_action_by_data(var_88_5, true)
		else
			Log.e("Wrong data, check data again: ", id, iter_88_1.id)
		end
		
		var_88_6 = var_88_6 or 0
		var_88_3 = math.max(var_88_3, var_88_6)
	end
	
	local var_88_11 = STORY_ACTION_MANAGER:getModelIds()
	
	if var_88_11 and not table.empty(var_88_11) then
		for iter_88_2, iter_88_3 in pairs(var_88_11) do
			local var_88_12 = _getTargetNodeModel(iter_88_3)
			
			if get_cocos_refid(var_88_12) then
				local var_88_13 = var_88_12:getChildByName("talk_" .. iter_88_3)
				
				if get_cocos_refid(var_88_13) then
					var_88_13:setVisible(false)
					var_88_13:removeFromParent()
				end
			end
		end
	end
	
	local var_88_14 = STORY_ACTION_MANAGER:getWorldTalks()
	
	for iter_88_4, iter_88_5 in pairs(var_88_14) do
		if get_cocos_refid(iter_88_5) then
			iter_88_5:removeFromParent()
		end
	end
	
	STORY_ACTION_MANAGER:onUpdate(var_88_4)
	
	local var_88_15 = 100
	
	StoryAction:Add(SEQ(DELAY(var_88_15 + 100), CALL(function()
		if STORY_ACTION_MANAGER.vars and STORY_ACTION_MANAGER.vars.prev_action_id then
			DEBUG.STOP_STA_AUTO_NEXT = false
			
			STORY_ACTION_MANAGER:story_action_step_next_bt_action_id(STORY_ACTION_MANAGER.vars.prev_action_id)
		end
	end)), STORY_ACTION_MANAGER, "story_v2.proc_next")
end

function _DEBUG_STORY_ACTION_GOTO(arg_90_0)
	if not arg_90_0 then
		return 
	end
	
	local var_90_0 = false
	
	for iter_90_0, iter_90_1 in pairs(STORY.story) do
		for iter_90_2, iter_90_3 in pairs(iter_90_1) do
			if iter_90_3.story_action then
				local var_90_1 = iter_90_3.story_action
				local var_90_2, var_90_3 = DB("story_v2_list", var_90_1, {
					"id",
					"actions"
				})
				
				if var_90_2 and var_90_3 then
					var_90_0 = true
					
					break
				end
			end
		end
		
		if var_90_0 then
			break
		end
	end
	
	if not var_90_0 then
		Log.e("Err: no Exist sub_id: ", arg_90_0)
		
		return 
	end
	
	STORY_ACTION_MANAGER:test_story_v2_story_init()
	
	if not self.vars.story_action_id then
		Log.e("Err: cannot find story_action ID")
		
		return 
	end
	
	STORY_ACTION_MANAGER:test_story_v2_story_build()
end

function _getBgPivotLayer()
	if not get_cocos_refid(STORY.layer) or not STORY_ACTION_MANAGER.vars then
		return 
	end
	
	return STORY_ACTION_MANAGER.vars.pivot
end

function _getBgLayer()
	if not get_cocos_refid(STORY.layer) or not STORY_ACTION_MANAGER.vars then
		return 
	end
	
	return STORY_ACTION_MANAGER.vars.n_bg
end

function _getTargetLayout(arg_93_0)
	if not arg_93_0 then
		return 
	end
	
	return BattleLayout:getStoryLayout(arg_93_0)
end

function _getTargetNodeModel(arg_94_0)
	if not arg_94_0 then
		return 
	end
	
	return BattleLayout:getStoryLayoutModel(arg_94_0)
end

function _setTargetSpeed(arg_95_0, arg_95_1)
	if not arg_95_0 or not arg_95_1 then
		return 
	end
	
	BattleLayout:setStoryLayoutMoverSpeed(arg_95_0, arg_95_1)
end

function _setAnimation(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	if not arg_96_0 or not arg_96_2 then
		return 
	end
	
	if not arg_96_0.setAnimation then
		arg_96_0 = arg_96_0.model
	end
	
	if not arg_96_0 then
		return 
	end
	
	local var_96_0
	
	var_96_0 = arg_96_1 or 0
	
	StoryAction:Add(MOTION(arg_96_2, arg_96_3), arg_96_0)
end

function STORY_V2_ACTIONS._s_sound_effect(arg_97_0, arg_97_1, arg_97_2, arg_97_3)
	if not arg_97_1 then
		return 
	end
	
	local var_97_0 = 0
	local var_97_1 = "event:/" .. arg_97_1
	
	if arg_97_3 then
		local var_97_2 = SoundEngine:play(var_97_1)
		
		STORY_ACTION_MANAGER:addSounds(var_97_2)
	else
		local var_97_3 = {}
		local var_97_4 = TARGET(STORY_V2_ACTIONS, SEQ(DELAY(var_97_0), CALL(function()
			local var_98_0 = SoundEngine:play(var_97_1)
			
			STORY_ACTION_MANAGER:addSounds(var_98_0)
		end)))
		
		table.add(var_97_3, var_97_4)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_97_3
		})
	end
	
	return var_97_0
end

function STORY_V2_ACTIONS._s_fadein(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	local var_99_0, var_99_1, var_99_2 = _build_value_table("fade_color", arg_99_1)
	local var_99_3 = arg_99_2 or 0
	
	STORY.childs.curtain:setColor(cc.c3b(var_99_0, var_99_1, var_99_2))
	
	if arg_99_3 then
		StoryAction:Add(SEQ(SHOW(true), FADE_IN(var_99_3)), STORY.childs.curtain)
	else
		local var_99_4 = {}
		local var_99_5 = TARGET(STORY.childs.curtain, SEQ(SHOW(true), FADE_IN(var_99_3)))
		
		table.add(var_99_4, var_99_5)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_99_4
		})
	end
	
	return var_99_3
end

function STORY_V2_ACTIONS._s_fadeout(arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	local var_100_0, var_100_1, var_100_2 = _build_value_table("fade_color", arg_100_1)
	local var_100_3 = arg_100_2 or 0
	
	if not var_100_0 then
		var_100_0 = 0
		var_100_1 = 0
		var_100_2 = 0
	end
	
	STORY.childs.curtain:setColor(cc.c3b(var_100_0, var_100_1, var_100_2))
	
	if arg_100_3 then
		StoryAction:Add(SEQ(SHOW(true), FADE_OUT(var_100_3), SHOW(false)), STORY.childs.curtain)
	else
		local var_100_4 = {}
		local var_100_5 = TARGET(STORY.childs.curtain, SEQ(SHOW(true), FADE_OUT(var_100_3), SHOW(false)))
		
		table.add(var_100_4, var_100_5)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_100_4
		})
	end
	
	return var_100_3
end

local var_0_9 = 1

function STORY_V2_ACTIONS._s_spawn(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8, arg_101_9)
	local var_101_0 = arg_101_8 or 0
	local var_101_1 = arg_101_0
	local var_101_2 = arg_101_1
	local var_101_3
	
	var_101_3 = arg_101_2 or 1
	
	local var_101_4 = arg_101_3 or 1
	local var_101_5 = arg_101_4 or 0
	local var_101_6 = arg_101_5 or 0
	local var_101_7
	
	var_101_7 = arg_101_6 or 1
	
	local var_101_8 = (arg_101_7 or 0) + var_101_0
	
	if not var_101_2 or not DB("character", var_101_2, "id") then
		Log.e("Err: not Exist Character ", var_101_2)
		
		return 
	elseif get_cocos_refid(BattleLayout:getStoryLayoutModel(var_101_1)) then
		Log.e("Err: same uid character is already exist ", var_101_1)
		
		return 
	end
	
	local var_101_9 = string.starts(var_101_2, "s000")
	local var_101_10 = UNIT:create({
		exp = 0,
		lv = 1,
		code = var_101_2
	}, false, true, true)
	
	if not var_101_10 then
		return 
	end
	
	local var_101_11 = STORY_ACTION_MANAGER:getLayer()
	local var_101_12 = {
		var_101_10
	}
	
	local function var_101_13(arg_102_0, arg_102_1)
		arg_102_0 = arg_102_0 or {}
		
		local var_102_0 = {}
		
		for iter_102_0, iter_102_1 in pairs(arg_102_0) do
			local var_102_1 = iter_102_1.unit
			
			if not var_102_1 and iter_102_1.id then
				var_102_1 = UNIT:create({
					exp = 0,
					lv = 1,
					code = iter_102_1.id,
					skin_code = iter_102_1.skin_code
				}, false, true, true)
			end
			
			if var_102_1 then
				var_102_1.uid = var_101_1
				var_102_1.inst.show = false
				var_102_1.inst.pos = iter_102_1.pos or var_0_9
				var_0_9 = var_0_9 + 1
				var_102_1.x = 0
				var_102_1.y = 0
				var_102_1.inst.ally = arg_102_1
				var_102_1.inst.ani_id = iter_102_1.ani or "idle"
				var_102_1.totatt_dmg = iter_102_1.power
				var_102_1.curatt_dmg = 0
				var_102_1.party = iter_102_1.party or 1
				
				table.insert(var_102_0, var_102_1)
			end
		end
		
		return var_102_0
	end
	
	local function var_101_14(arg_103_0, arg_103_1)
		if not arg_103_0 or table.count(arg_103_0) == 0 then
			return 
		end
		
		local var_103_0 = StoryUnitLayout:build(arg_103_0)
		
		if not var_103_0 then
			return 
		end
		
		for iter_103_0 = 1, table.count(var_103_0) do
			local var_103_1 = var_103_0[iter_103_0].unit
			
			if not get_cocos_refid(var_103_1.model) then
				local var_103_2 = var_103_1.db.model_id
				local var_103_3 = var_103_1.db.skin
				local var_103_4 = var_103_1.db.atlas
				
				if var_103_2 then
					local var_103_5 = CACHE:getModel(var_103_2, var_103_3, var_103_1.inst.ani_id, var_103_4)
					
					if var_103_1.db and var_103_1.db.model_opt then
						var_103_5:loadOption("model/" .. var_103_1.db.model_opt)
					end
					
					var_103_5.code = var_101_2
					var_103_5.uid = var_101_1
					var_103_1.model = var_103_5
					
					var_103_1.model:setLuaTag({
						unit = var_103_1
					})
					
					local var_103_6 = var_103_5:createShadow(var_101_11)
					
					var_103_6:setGlobalZOrder(0)
					var_103_6:setLocalZOrder(-10)
					var_103_5:loadTexture()
				end
			end
			
			if get_cocos_refid(var_103_1.model) then
				var_103_1.model:ejectFromParent()
				var_103_1.model:resetTimeline()
				var_103_1.model:setVisible(true)
				
				if arg_103_1 then
					local var_103_7 = tonumber(string.sub(arg_103_1, 1, 2), 16)
					local var_103_8 = tonumber(string.sub(arg_103_1, 3, 4), 16)
					local var_103_9 = tonumber(string.sub(arg_103_1, 5, 6), 16)
					local var_103_10 = cc.c3b(var_103_7, var_103_8, var_103_9)
					
					var_103_1.model:setColor(var_103_10)
				end
				
				var_101_11:addChild(var_103_1.model)
			end
		end
		
		return arg_103_0, var_103_0
	end
	
	local var_101_15 = STORY_ACTION_MANAGER:getAmbientColor()
	local var_101_16 = {}
	local var_101_17
	
	for iter_101_0, iter_101_1 in pairs(var_101_12) do
		local var_101_18 = iter_101_1.party or 1
		local var_101_19 = iter_101_1.pos or 1
		local var_101_20 = (var_101_18 - 1) * 4 + var_101_19
		
		table.insert(var_101_16, {
			uid = var_101_1,
			id = iter_101_1.db.code,
			power = iter_101_1.inst.power,
			pos = var_101_20,
			party = var_101_18,
			skin_code = iter_101_1.inst.skin_code
		})
	end
	
	local var_101_21 = FRIEND
	local var_101_22 = var_101_13(var_101_16, var_101_21)
	local var_101_23, var_101_24 = var_101_14(var_101_22, var_101_15)
	local var_101_25 = var_101_24
	
	if not var_101_23 then
		return 
	end
	
	local var_101_26 = BattleLayout:addStoryUnitLayoutData(var_101_25, var_101_21, var_101_1, var_101_4)
	
	var_101_26:setPosition(var_101_5, var_101_6)
	var_101_26:setDirection(var_101_4)
	BattleLayout:updatePoseStory()
	BattleLayout:updateModelPoseStory()
	
	local var_101_27 = BattleLayout:getStoryLayoutModel(var_101_1)
	
	if not get_cocos_refid(var_101_27) then
		Log.e("Err: wrong Empty model")
		
		return 
	end
	
	var_101_27:setVisible(false)
	
	if arg_101_9 then
		if var_101_9 then
			var_101_27:setVisible(false)
		else
			var_101_27:setVisible(true)
		end
		
		StoryAction:Add(SEQ(SHOW(true), CALL(function()
			if var_101_9 then
				var_101_27:setVisible(false)
			end
		end)), var_101_27)
		table.insert(STORY_ACTION_MANAGER:getModelIds(), var_101_1)
	else
		local var_101_28 = {}
		local var_101_29 = TARGET(var_101_27, SEQ(DELAY(var_101_8), SHOW(true), CALL(function()
			if var_101_9 then
				var_101_27:setVisible(false)
			end
		end)))
		
		table.add(var_101_28, var_101_29)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_101_28
		})
		table.insert(STORY_ACTION_MANAGER:getModelIds(), var_101_1)
	end
	
	if not PRODUCTION_MODE then
		local var_101_30 = ccui.Text:create()
		
		var_101_30:setFontName("font/daum.ttf")
		var_101_30:setColor(cc.c3b(241, 241, 241))
		var_101_30:enableOutline(cc.c3b(0, 0, 0), 1)
		var_101_30:setFontSize(48)
		var_101_30:setString(T("loading_saved_data"))
		var_101_30:setString("(" .. var_101_5 .. "/" .. var_101_6 .. ")")
		var_101_30:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
		var_101_30:setLocalZOrder(1000000)
		var_101_27:addChild(var_101_30)
		
		var_101_27.t_pos = var_101_30
		
		if not DEBUG.SHOW_STORYV2_POSITION then
			var_101_30:setVisible(false)
		end
	end
	
	return var_101_8 + 1000
end

function STORY_V2_ACTIONS._s_move(arg_106_0, arg_106_1, arg_106_2, arg_106_3)
	local var_106_0 = arg_106_0
	local var_106_1 = tonumber(arg_106_2) or 0
	local var_106_2 = _getTargetNodeModel(var_106_0)
	local var_106_3 = _getTargetLayout(var_106_0)
	
	if not get_cocos_refid(var_106_2) or not var_106_3 then
		Log.e("Err: no character, ", var_106_0)
		
		return 
	end
	
	_setTargetSpeed(var_106_0, var_106_1)
	var_106_2:setScaleX(var_106_2:getScaleX())
	
	local var_106_4, var_106_5, var_106_6, var_106_7 = _build_value_table("move", arg_106_1)
	local var_106_8 = BattleLayout:getStoryLayoutUnit(var_106_0)
	
	if var_106_8 and var_106_8.mover then
		var_106_8.mover:setAniStateOnStory(var_106_6)
		var_106_8.mover:setIdleAniStateOnStory(var_106_7)
	end
	
	var_106_3:setFuturePosition(var_106_4, var_106_5)
	
	if arg_106_3 then
		StoryAction:Add(SEQ(CALL(function()
			var_106_3:setPosition(var_106_4, var_106_5)
		end)), var_106_3)
	else
		local var_106_9 = {}
		local var_106_10 = TARGET(var_106_3, SEQ(CALL(function()
			var_106_3:setPosition(var_106_4, var_106_5)
		end)))
		
		table.add(var_106_9, var_106_10)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_106_9
		})
	end
	
	return var_106_1 + 600
end

function STORY_V2_ACTIONS._s_animate(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5)
	local var_109_0 = arg_109_0
	local var_109_1, var_109_2, var_109_3 = _build_value_table("animate", arg_109_1)
	local var_109_4 = BattleLayout:getStoryLayout(var_109_0)
	local var_109_5 = arg_109_2 or false
	
	if not var_109_4 then
		Log.e("Err: no animation character ", var_109_0)
		
		return 
	end
	
	if not var_109_1 then
		Log.e("Err: wrong type animate", arg_109_1)
		
		return 
	end
	
	table.insert(var_109_1, var_109_2)
	
	local var_109_6 = _getTargetNodeModel(var_109_0)
	local var_109_7 = {}
	local var_109_8
	local var_109_9 = 0
	local var_109_10 = 0
	local var_109_11 = {}
	
	for iter_109_0, iter_109_1 in pairs(var_109_1) do
		local var_109_12 = (var_109_6:getAnimationDuration(iter_109_1) or 0) * 1000
		
		var_109_9 = var_109_9 + var_109_12
		
		table.insert(var_109_11, var_109_12)
	end
	
	var_109_6.anim_idx = 1
	var_109_6.end_anim_loop = var_109_3
	
	if arg_109_5 then
		if var_109_6.prev_action_id and arg_109_4 and var_109_6.prev_action_id == arg_109_4 and not var_109_3 then
			return 
		end
		
		if StoryAction:Find("debug_anim") then
			StoryAction:Remove("debug_anim")
		end
		
		StoryAction:Add(COND_LOOP(SEQ(CALL(function()
			if get_cocos_refid(var_109_6) and var_109_1[var_109_6.anim_idx] then
				local var_110_0 = false
				
				if table.count(var_109_1) == var_109_6.anim_idx then
					var_110_0 = var_109_6.end_anim_loop
				end
				
				var_109_6:setAnimation(0, var_109_1[var_109_6.anim_idx], var_110_0, var_109_5)
				var_109_6:cleanupReferencedObject()
			end
		end), DELAY(var_109_11[var_109_6.anim_idx] or 0), CALL(function()
			if get_cocos_refid(var_109_6) then
				var_109_6.anim_idx = var_109_6.anim_idx + 1
			end
		end))), function()
			if not get_cocos_refid(var_109_6) or not var_109_1[var_109_6.anim_idx] then
				return true
			end
		end, "debug_anim")
	else
		local var_109_13 = TARGET(var_109_6, COND_LOOP(SEQ(CALL(function()
			if get_cocos_refid(var_109_6) and var_109_1[var_109_6.anim_idx] then
				local var_113_0 = false
				
				if table.count(var_109_1) == var_109_6.anim_idx then
					var_113_0 = var_109_6.end_anim_loop
				end
				
				var_109_6:setAnimation(0, var_109_1[var_109_6.anim_idx], var_113_0, var_109_5)
				var_109_6:cleanupReferencedObject()
			end
		end), DELAY(var_109_11[var_109_6.anim_idx] or 0), CALL(function()
			if get_cocos_refid(var_109_6) then
				var_109_6.anim_idx = var_109_6.anim_idx + 1
			end
		end))), function()
			if not get_cocos_refid(var_109_6) or not var_109_1[var_109_6.anim_idx] then
				return true
			end
		end)
		
		table.add(var_109_7, var_109_13)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_109_7
		})
	end
	
	var_109_6.prev_action_id = arg_109_4
	
	return var_109_9
end

function STORY_V2_ACTIONS._s_flip(arg_116_0, arg_116_1, arg_116_2, arg_116_3)
	local var_116_0 = arg_116_0
	local var_116_1 = BattleLayout:getStoryLayout(var_116_0)
	
	if not var_116_1 then
		Log.e("Err: no flip character ", var_116_0)
		
		return 
	end
	
	local var_116_2 = var_116_1:getDirection() * -1
	
	local function var_116_3()
		local var_117_0 = _getTargetNodeModel(var_116_0)
		local var_117_1 = var_117_0._talk_tbl
		local var_117_2 = var_117_1 and var_117_1.n_talk
		
		var_116_1:setDirection(var_116_2)
		
		if get_cocos_refid(var_117_2) then
			var_117_2:setVisible(false)
			
			if var_117_0._talk_tbl then
				var_117_1 = var_117_0._talk_tbl
				
				local var_117_3 = var_117_1.n_talk
				
				var_117_1.parent_direction = var_116_1:getDirection()
				var_117_1.caller = "flip"
			end
			
			var_0_5(var_117_1)
		end
	end
	
	local function var_116_4()
		local var_118_0 = _getTargetNodeModel(var_116_0)._talk_tbl
		local var_118_1 = var_118_0 and var_118_0.n_talk
		
		if get_cocos_refid(var_118_1) then
			var_118_1:setVisible(true)
		end
	end
	
	local var_116_5 = 1
	
	if arg_116_3 then
		StoryAction:Add(SEQ(CALL(function()
			var_116_3()
		end), DELAY(var_116_5), CALL(function()
			var_116_4()
		end)), var_116_1)
	else
		local var_116_6 = {}
		local var_116_7 = TARGET(var_116_1, SEQ(CALL(function()
			var_116_3()
		end), DELAY(var_116_5), CALL(function()
			var_116_4()
		end)))
		
		table.add(var_116_6, var_116_7)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_116_6
		})
	end
	
	return 500
end

function STORY_V2_ACTIONS._s_empty()
end

function STORY_V2_ACTIONS._s_delay(arg_124_0, arg_124_1)
	if arg_124_1 then
		arg_124_0 = 0
	end
	
	return arg_124_0
end

function STORY_V2_ACTIONS._s_ca_move(arg_125_0, arg_125_1, arg_125_2, arg_125_3)
	local var_125_0, var_125_1, var_125_2 = _build_value_table("ca_move", arg_125_0)
	local var_125_3 = tonumber(arg_125_2) or 0
	local var_125_4 = 0
	
	if var_125_0 then
		local var_125_5 = BattleLayout:getStoryLayout(var_125_0)
		
		if not var_125_5 then
			return 
		end
		
		var_125_1, var_125_2 = var_125_5:getFuturePosition()
		
		if not var_125_1 or not var_125_2 then
			var_125_1, var_125_2 = var_125_5:getPosition()
		end
		
		var_125_1 = var_125_1 - 300
	end
	
	local var_125_6 = var_125_1 * -1
	local var_125_7 = var_125_2 * -1
	
	STORY_ACTION_MANAGER:setBGSpeed(var_125_3)
	
	local var_125_8 = {}
	
	if arg_125_3 then
		StoryAction:Add(SEQ(DELAY(var_125_4), CALL(function()
			if var_125_3 == 0 then
				BattleLayout:setFieldPosition(var_125_6 * -1)
				BattleLayout:setFieldPositionY(var_125_7 * -1)
			else
				BattleLayout:moveToFieldPosition(var_125_6 * -1, var_125_7 * -1)
			end
		end)), _getBgLayer())
	else
		local var_125_9 = TARGET(_getBgLayer(), SEQ(DELAY(var_125_4), CALL(function()
			BattleLayout:moveToFieldPosition(var_125_6 * -1, var_125_7 * -1)
		end)))
		
		table.add(var_125_8, var_125_9)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_125_8
		})
	end
	
	return var_125_3
end

function STORY_V2_ACTIONS._s_zoom(arg_128_0, arg_128_1, arg_128_2, arg_128_3)
	local var_128_0 = 0
	local var_128_1 = tonumber(arg_128_2) or 0
	local var_128_2 = 0 + var_128_0
	local var_128_3 = tonumber(arg_128_1)
	local var_128_4, var_128_5, var_128_6 = _build_value_table("zoom", arg_128_0)
	
	if var_128_4 then
		if arg_128_3 then
			StoryAction:Add(SEQ(DELAY(var_128_2), CALL(function()
				var_0_3(false)
				CameraManager:zoomTargetOnStory(var_128_4, var_128_1, var_128_3)
			end), DELAY(var_128_1), CALL(function()
				var_0_3(true)
			end)), STORY_V2_ACTIONS)
		else
			local var_128_7 = {}
			local var_128_8 = SEQ(DELAY(var_128_2), CALL(function()
				var_0_3(false)
				CameraManager:zoomTargetOnStory(var_128_4, var_128_1, var_128_3)
			end), DELAY(var_128_1), CALL(function()
				var_0_3(true)
			end))
			
			table.add(var_128_7, var_128_8)
			table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
				var_128_7
			})
		end
	else
		local var_128_9 = STORY_ACTION_MANAGER:getLayer()
		local var_128_10 = cc.Node:create()
		
		var_128_9:addChild(var_128_10)
		var_128_10:setPosition(var_128_5, var_128_6)
		
		if arg_128_3 then
			StoryAction:Add(SEQ(DELAY(var_128_2), CALL(function()
				var_0_3(false)
				CameraManager:zoomAreaOnStory(var_128_10, var_128_1, var_128_3)
			end), DELAY(var_128_1 + 100), CALL(function()
				var_0_3(true)
				
				if get_cocos_refid(var_128_10) then
					var_128_10:removeFromParent()
				end
			end)), STORY_V2_ACTIONS)
		else
			local var_128_11 = {}
			local var_128_12 = SEQ(DELAY(var_128_2), CALL(function()
				var_0_3(false)
				CameraManager:zoomAreaOnStory(var_128_10, var_128_1, var_128_3)
			end), DELAY(var_128_1 + 100), CALL(function()
				var_0_3(true)
				
				if get_cocos_refid(var_128_10) then
					var_128_10:removeFromParent()
				end
			end))
			
			table.add(var_128_11, var_128_12)
			table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
				var_128_11
			})
		end
	end
	
	return var_128_1 + var_128_2
end

function STORY_V2_ACTIONS._s_zoom_reset(arg_137_0, arg_137_1)
	local var_137_0 = arg_137_0 or 0
	
	var_0_3(false)
	
	if arg_137_1 then
		StoryAction:Add(SEQ(CALL(function()
			var_0_3(false)
			CameraManager:resetDefaultStory(var_137_0)
		end), DELAY(var_137_0), CALL(function()
			var_0_3(true)
		end)), STORY_V2_ACTIONS)
	else
		local var_137_1 = {}
		local var_137_2 = SEQ(CALL(function()
			var_0_3(false)
			CameraManager:resetDefaultStory(var_137_0)
		end), DELAY(var_137_0), CALL(function()
			var_0_3(true)
		end))
		
		table.add(var_137_1, var_137_2)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_137_1
		})
	end
	
	if var_137_0 == 0 then
		var_137_0 = 100
	end
	
	return var_137_0
end

function STORY_V2_ACTIONS._s_shake(arg_142_0, arg_142_1, arg_142_2, arg_142_3)
	local var_142_0, var_142_1 = _build_value_table("shake", arg_142_1)
	local var_142_2 = tonumber(arg_142_2) or 0
	local var_142_3
	
	if arg_142_3 then
		StoryAction:Add(SEQ(SHAKE_CAM("story_action_shake", var_142_2, var_142_0, var_142_1, var_142_3)), STORY_V2_ACTIONS)
	else
		local var_142_4 = {}
		local var_142_5 = SEQ(SHAKE_CAM("story_action_shake", var_142_2, var_142_0, var_142_1, var_142_3))
		
		table.add(var_142_4, var_142_5)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_142_4
		})
	end
	
	return var_142_2
end

function STORY_V2_ACTIONS._s_use_skill(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4)
	local var_143_0, var_143_1, var_143_2 = _build_value_table("skill", arg_143_1)
	local var_143_3 = arg_143_0
	local var_143_4 = 1
	local var_143_5 = true
	local var_143_6 = arg_143_2 or false
	local var_143_7 = tonumber(var_143_0) or 1
	local var_143_8 = {}
	local var_143_9 = _getTargetLayout(var_143_3)
	
	if not var_143_9 then
		Log.e("Err: Empty Attack Unit", var_143_3)
		
		return 
	end
	
	local var_143_10 = var_143_9:getUnits()[1]
	
	var_143_10.model = _getTargetNodeModel(var_143_3)
	
	if var_143_10.inst then
		var_143_10.inst.ally = FRIEND
	end
	
	local var_143_11 = var_143_1[1]
	
	if not _getTargetLayout(var_143_11) then
		Log.e("Err: Empty Attack Target Unit", var_143_11)
		
		return 
	end
	
	local var_143_12 = _getTargetLayout(var_143_11):getUnits()[1]
	
	var_143_12.model = _getTargetNodeModel(var_143_11)
	
	local var_143_13 = var_143_12
	
	if var_143_12.inst then
		var_143_12.inst.ally = ENEMY
	end
	
	local var_143_14 = var_143_10:getSkillBundle():slot(var_143_7):getOriginSkillId()
	local var_143_15 = false
	
	if var_143_15 then
		var_143_14 = var_143_14 .. "s"
	end
	
	set_high_fps_tick()
	
	local var_143_16 = SEQ(CALL(CameraManager.resetReadyFocus, CameraManager), MOTION("idle", false), MOTION("idle", true), DELAY(500), DMOTION("b_idle_ready", false), MOTION("b_idle", true), DELAY(10))
	
	if var_143_5 then
		var_143_16 = SEQ(CALL(CameraManager.resetReadyFocus, CameraManager))
	end
	
	local var_143_17 = {}
	local var_143_18 = {
		var_143_13
	}
	
	if get_cocos_refid(var_143_10.model) then
		var_143_10.model:changeBodyTo()
		var_143_10.model:setAnimation(0, "b_idle", true)
	end
	
	local var_143_19 = true
	local var_143_20 = to_n(DB("skill", var_143_14, "target"))
	
	if DB("skill", var_143_14, "deal_damage") ~= "y" then
		local var_143_21 = false
	end
	
	local var_143_22
	
	var_143_22 = var_143_4 or 1
	
	if var_143_20 == 12 or var_143_20 == 16 or var_143_20 == 17 then
		for iter_143_0, iter_143_1 in pairs(STORY_ACTION_MANAGER:getModelIds()) do
			if table.find(var_143_1, iter_143_1) then
				local var_143_23 = _getTargetLayout(iter_143_1):getUnits()[1]
				
				var_143_23.inst.ally = ENEMY
				
				table.insert(var_143_18, var_143_23)
			end
		end
	elseif var_143_20 == 13 then
		var_143_18 = {}
		
		for iter_143_2, iter_143_3 in pairs(STORY_ACTION_MANAGER:getModelIds()) do
			if table.find(var_143_1, iter_143_3) then
				local var_143_24 = _getTargetLayout(iter_143_3):getUnits()[1]
				
				var_143_24.inst.ally = ENEMY
				
				table.insert(var_143_18, var_143_24)
			end
		end
	elseif var_143_20 == 14 then
		var_143_18 = {}
		
		for iter_143_4, iter_143_5 in pairs(STORY_ACTION_MANAGER:getModelIds()) do
			if table.find(var_143_1, iter_143_5) then
				local var_143_25 = _getTargetLayout(iter_143_5):getUnits()[1]
				
				var_143_25.inst.ally = ENEMY
				
				table.insert(var_143_18, var_143_25)
			end
		end
	elseif var_143_20 == 3 then
		local var_143_26 = false
		
		var_143_18 = table.shallow_clone(var_143_10)
	elseif var_143_20 == 2 or var_143_20 == 15 then
		local var_143_27 = false
		
		var_143_18 = {
			var_143_10
		}
		var_143_13 = var_143_10
	elseif var_143_20 == 1 then
		local var_143_28 = false
		
		var_143_18 = {
			var_143_10
		}
		var_143_13 = var_143_10
	end
	
	local var_143_29 = {}
	
	for iter_143_6, iter_143_7 in pairs(STORY_ACTION_MANAGER:getModelIds()) do
		if iter_143_7 ~= var_143_3 and not table.find(var_143_1, iter_143_7) then
			table.insert(var_143_29, _getTargetLayout(iter_143_7):getUnits()[1])
		end
	end
	
	local var_143_30 = {
		a_unit = var_143_10,
		d_unit = var_143_13,
		d_units = var_143_18
	}
	local var_143_31 = {
		skill_id = var_143_14,
		unit = var_143_10,
		ignore_sound = var_143_6,
		units = {
			friends = {
				var_143_10
			},
			enemies = var_143_18,
			hide_units = var_143_29
		},
		att_info = var_143_30
	}
	
	STORY_ACTION_MANAGER:setAttackInfo(var_143_10, var_143_30)
	
	STORY_ACTION_MANAGER.hitCount = 0
	
	var_0_3(false, true)
	
	local var_143_32, var_143_33, var_143_34 = STORY_V2_ACTIONS.getSkillTotalTime(var_143_14, var_143_31)
	
	BattleAction:Remove("battle.skill")
	BattleAction:Add(SEQ(var_143_16, CALL(function()
		STORY_V2_ACTIONS:hideAllTalk()
		
		var_143_30.tick = LAST_TICK
		
		local var_144_0 = StageStateManager:start(var_143_14, var_143_31)
		
		if var_144_0 then
			var_144_0:setCallback({
				onFinish = function(arg_145_0)
					var_0_3(true, true)
					STORY_ACTION_MANAGER:set_playing_skill(false)
					
					if var_143_2 and var_143_1 then
						for iter_145_0, iter_145_1 in pairs(var_143_1) do
							STORY_V2_ACTIONS._s_remove(iter_145_1, "dead1", nil, true)
						end
					end
				end,
				onDestroy = function(arg_146_0)
				end
			})
		end
	end), DELAY(var_143_33)), STORY_V2_ACTIONS, "battle.skill")
	
	return var_143_33 or -1
end

function STORY_V2_ACTIONS.hideAllTalk(arg_147_0)
	for iter_147_0, iter_147_1 in pairs(STORY_ACTION_MANAGER:getModelIds()) do
		local var_147_0 = _getTargetNodeModel(iter_147_1)
		
		if get_cocos_refid(var_147_0) then
			local var_147_1 = var_147_0:getChildByName("talk_" .. iter_147_1)
			
			if get_cocos_refid(var_147_1) then
				var_147_1:setVisible(false)
			end
		end
	end
	
	local var_147_2 = STORY_ACTION_MANAGER:getWorldTalks()
	
	for iter_147_2, iter_147_3 in pairs(var_147_2) do
		if get_cocos_refid(iter_147_3) then
			iter_147_3:setVisible(false)
		end
	end
end

function STORY_V2_ACTIONS.getSkillTotalTime(arg_148_0, arg_148_1)
	local var_148_0, var_148_1 = DB("skill", arg_148_0, {
		"skillact",
		"show_lastdamage"
	})
	local var_148_2 = arg_148_1
	local var_148_3 = var_148_2.unit
	local var_148_4 = var_148_3:getSkinCheck()
	local var_148_5 = DB("skillact", DB("skill", var_148_2.skill_id, "skillact"), var_148_4 or "action") or var_148_3.model:getBoneNode("arrow_start") and "def_range_attack" or "def_melee_attack"
	
	var_148_2.id = var_148_2.skill_id
	var_148_2.idx = var_148_3:getSkillIndex(var_148_2.skill_id)
	
	local var_148_6, var_148_7, var_148_8 = StageStateManager:getStateDocTime(var_148_5, "start", var_148_2)
	
	return var_148_6, var_148_7, var_148_8
end

function STORY_V2_ACTIONS._s_remove(arg_149_0, arg_149_1, arg_149_2, arg_149_3)
	local var_149_0 = arg_149_0
	local var_149_1 = arg_149_1 or "remove"
	local var_149_2 = _getTargetLayout(var_149_0)
	
	if not var_149_2 then
		Log.e("Err: no Dead unit ", var_149_0)
		
		return 
	end
	
	local var_149_3 = var_149_2:getUnits()[1]
	local var_149_4 = var_149_3.model
	local var_149_5
	
	if var_149_1 == "dead2" then
		var_149_5 = true
	end
	
	if arg_149_3 then
		if var_149_1 == "remove" then
			if get_cocos_refid(var_149_4) then
				var_149_4:setVisible(false)
				
				if var_149_4.body and var_149_4.body.stop then
					var_149_4.body:stop()
				end
				
				BattleLayout:removeStoryLayout(nil, var_149_0)
				
				local var_149_6 = STORY_ACTION_MANAGER:getModelIds()
				
				for iter_149_0 = #var_149_6, 1, -1 do
					if var_149_6[iter_149_0] == var_149_0 then
						table.remove(var_149_6, iter_149_0)
					end
				end
				
				STORY_ACTION_MANAGER:setModelIds(var_149_6)
			end
		else
			StoryAction:Add(SEQ(CALL(function()
				local var_150_0 = CALL(function()
					if get_cocos_refid(var_149_4) then
						var_149_4:setVisible(false)
						
						if var_149_4.body and var_149_4.body.stop then
							var_149_4.body:stop()
						end
					end
					
					StoryAction:Add(SEQ(DELAY(1000), CALL(function()
						if get_cocos_refid(var_149_4) then
							BattleLayout:removeStoryLayout(nil, var_149_0)
							
							local var_152_0 = STORY_ACTION_MANAGER:getModelIds()
							
							for iter_152_0 = #var_152_0, 1, -1 do
								if var_152_0[iter_152_0] == var_149_0 then
									table.remove(var_152_0, iter_152_0)
								end
							end
							
							STORY_ACTION_MANAGER:setModelIds(var_152_0)
						end
					end)), var_149_4)
				end)
				
				STORY_V2_ACTIONS._deadEffect(var_149_2, var_149_3, var_149_3.model, var_149_5, var_150_0)
			end)), STORY_V2_SUB_ACTIONS)
		end
	else
		local var_149_7 = {}
		local var_149_8 = TARGET(STORY_V2_SUB_ACTIONS, SEQ(CALL(function()
			local var_153_0 = CALL(function()
				if get_cocos_refid(var_149_4) then
					var_149_4:setVisible(false)
					
					if var_149_4.body and var_149_4.body.stop then
						var_149_4.body:stop()
					end
				end
				
				StoryAction:Add(SEQ(DELAY(1000), CALL(function()
					if get_cocos_refid(var_149_4) then
						BattleLayout:removeStoryLayout(nil, var_149_0)
						
						local var_155_0 = STORY_ACTION_MANAGER:getModelIds()
						
						for iter_155_0 = #var_155_0, 1, -1 do
							if var_155_0[iter_155_0] == var_149_0 then
								table.remove(var_155_0, iter_155_0)
							end
						end
						
						STORY_ACTION_MANAGER:setModelIds(var_155_0)
					end
				end)), var_149_4)
			end)
			
			STORY_V2_ACTIONS._deadEffect(var_149_2, var_149_3, var_149_3.model, var_149_5, var_153_0)
		end)))
		local var_149_9
		
		if var_149_1 == "remove" then
			var_149_9 = TARGET(STORY_V2_SUB_ACTIONS, SEQ(CALL(function()
				if get_cocos_refid(var_149_4) then
					var_149_4:setVisible(false)
					
					if var_149_4.body and var_149_4.body.stop then
						var_149_4.body:stop()
					end
					
					BattleLayout:removeStoryLayout(nil, var_149_0)
					
					local var_156_0 = STORY_ACTION_MANAGER:getModelIds()
					
					for iter_156_0 = #var_156_0, 1, -1 do
						if var_156_0[iter_156_0] == var_149_0 then
							table.remove(var_156_0, iter_156_0)
						end
					end
					
					STORY_ACTION_MANAGER:setModelIds(var_156_0)
				end
			end)))
		else
			var_149_9 = TARGET(STORY_V2_SUB_ACTIONS, SEQ(CALL(function()
				local var_157_0 = CALL(function()
					if get_cocos_refid(var_149_4) then
						var_149_4:setVisible(false)
						
						if var_149_4.body and var_149_4.body.stop then
							var_149_4.body:stop()
						end
					end
					
					StoryAction:Add(SEQ(DELAY(1000), CALL(function()
						if get_cocos_refid(var_149_4) then
							BattleLayout:removeStoryLayout(nil, var_149_0)
							
							local var_159_0 = STORY_ACTION_MANAGER:getModelIds()
							
							for iter_159_0 = #var_159_0, 1, -1 do
								if var_159_0[iter_159_0] == var_149_0 then
									table.remove(var_159_0, iter_159_0)
								end
							end
							
							STORY_ACTION_MANAGER:setModelIds(var_159_0)
						end
					end)), var_149_4)
				end)
				
				STORY_V2_ACTIONS._deadEffect(var_149_2, var_149_3, var_149_3.model, var_149_5, var_157_0)
			end)))
		end
		
		table.add(var_149_7, var_149_9)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_149_7
		})
	end
	
	return 1300
end

function STORY_V2_ACTIONS._deadEffect(arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4)
	if not get_cocos_refid(arg_160_2) then
		return 
	end
	
	local var_160_0 = 300
	local var_160_1 = 1000
	local var_160_2 = arg_160_3
	local var_160_3 = DB("character_scale", arg_160_1.db.code, "die_effect")
	
	arg_160_2:setOpacity(255)
	SoundEngine:playBattle("event:/model/dead")
	SoundEngine:play("event:/voc/character/" .. arg_160_1.db.model_id .. "/evt/dead")
	
	if var_160_2 then
		var_160_3 = "death_eff_02"
	end
	
	var_160_3 = var_160_3 or "death_eff_01"
	
	local var_160_4, var_160_5 = arg_160_2:getBonePosition("target")
	local var_160_6 = arg_160_2:getLocalZOrder() + 1
	local var_160_7 = arg_160_2:getScaleX()
	local var_160_8 = FADE_OUT(var_160_1)
	
	arg_160_4 = arg_160_4 or NONE()
	
	local var_160_9 = DB("character", arg_160_1.db.code, "die_action")
	
	if arg_160_1.inst.resurrect or arg_160_1:isResurrectionReserved() then
		arg_160_2:setColor(cc.c3b(30, 30, 30))
		StoryAction:Add(SEQ(DELAY(var_160_0), OPACITY(0, 1, 1), COLOR(0, 30, 30, 30), CALL(arg_160_2.setTimeScale, arg_160_2, 0), CALL(EffectManager.Play, EffectManager, var_160_3, BGIManager:getBGI().main.layer, var_160_4, var_160_5, var_160_6, nil, var_160_7 < 0, nil, nil, true), var_160_8, arg_160_4), arg_160_2, "battle.dead")
	elseif var_160_9 == "run" then
		local var_160_10, var_160_11 = BattleLayout:getUnitFieldPosition(arg_160_1)
		local var_160_12 = var_160_10
		local var_160_13 = var_160_11
		local var_160_14 = arg_160_0:getDirection()
		local var_160_15 = var_160_12 - VIEW_WIDTH / 2 * var_160_14
		
		StoryAction:Add(SEQ(MOTION("idle", true), DELAY(var_160_0), SCALEX(0, arg_160_2:getScaleX(), -arg_160_2:getScaleX()), MOTION("run", true), MOVE_TO(1200, var_160_15, var_160_13), var_160_8, arg_160_4), arg_160_2)
	elseif var_160_9 == "idle" then
		StoryAction:Add(SEQ(MOTION("idle", true)), arg_160_2)
	else
		arg_160_2:setColor(cc.c3b(30, 30, 30))
		StoryAction:Add(SEQ(DELAY(var_160_0), OPACITY(0, 1, 1), COLOR(0, 30, 30, 30), CALL(arg_160_2.setTimeScale, arg_160_2, 0), CALL(EffectManager.Play, EffectManager, var_160_3, BGIManager:getBGI().main.layer, var_160_4, var_160_5, var_160_6, nil, var_160_7 < 0, nil, nil, true), var_160_8, arg_160_4), arg_160_2, "battle.dead")
	end
	
	return var_160_0 + var_160_1
end

STORY_V2_SUB_ACTIONS = {}

function STORY_V2_SUB_ACTIONS.PLAY(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4)
	local var_161_0 = STORY_ACTION_MANAGER:getLayer()
	local var_161_1, var_161_2 = _build_value_table("effect_target", arg_161_1)
	local var_161_3, var_161_4 = _build_value_table("effect_value", arg_161_2)
	local var_161_5 = 0
	local var_161_6 = 1
	local var_161_7 = 0
	
	if not var_161_3 then
		return 
	end
	
	local var_161_8 = {}
	local var_161_9
	
	if arg_161_4 then
		StoryAction:Add(SEQ(DELAY(var_161_5), CALL(function()
			EffectManager:Play({
				pivot_z = 99998,
				fn = var_161_3 .. ".cfx",
				layer = var_161_0,
				pivot_x = var_161_1,
				pivot_y = var_161_2,
				scale = var_161_6,
				flip_x = var_161_4
			})
		end)), STORY_V2_SUB_ACTIONS)
	else
		local var_161_10 = TARGET(STORY_V2_SUB_ACTIONS, SEQ(DELAY(var_161_5), CALL(function()
			EffectManager:Play({
				pivot_z = 99998,
				fn = var_161_3 .. ".cfx",
				layer = var_161_0,
				pivot_x = var_161_1,
				pivot_y = var_161_2,
				scale = var_161_6,
				flip_x = var_161_4
			})
		end)))
		
		table.add(var_161_8, var_161_10)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_161_8
		})
	end
	
	local var_161_11 = CACHE:getEffect(var_161_3 .. ".cfx")
	
	if var_161_11 then
		var_161_7 = var_161_11:getDuration() * 1000
	end
	
	return var_161_7
end

function STORY_V2_SUB_ACTIONS.SHOW(arg_164_0, arg_164_1, arg_164_2, arg_164_3, arg_164_4, arg_164_5)
	local var_164_0 = arg_164_2
	local var_164_1 = var_164_0.id
	local var_164_2 = var_164_0.face_icon or "left"
	local var_164_3 = var_164_0.name or "empty"
	local var_164_4 = var_164_0.face_id or "c1001"
	local var_164_5 = var_164_2 == "right" and 1 or -1
	local var_164_6 = var_164_0.x or 0
	local var_164_7 = var_164_0.y
	local var_164_8 = var_164_0.scale or 2
	local var_164_9 = arg_164_4 or 0
	local var_164_10 = var_164_0.voice
	local var_164_11 = 0
	local var_164_12, var_164_13, var_164_14 = _build_value_table("text", arg_164_1)
	
	local function var_164_15(arg_165_0)
		local var_165_0 = arg_165_0:getChildByName("mob_icon")
		local var_165_1
		
		if var_165_0 then
			local var_165_2 = cc.CSLoader:createNode("wnd/mob_icon.csb")
			
			if_set_sprite(var_165_2, "frame", "img/_hero_s_frame_ally.png")
			var_165_0:addChild(var_165_2)
			var_165_2:setPosition(0, 0)
			var_165_2:setAnchorPoint(0.5, 0.5)
			if_set_visible(var_165_2, "n_unit", false)
			if_set_visible(var_165_2, "txt_b_name", false)
			if_set_visible(var_165_2, "txt_r_name", false)
			if_set_visible(var_165_2, "txt_small_count", false)
			if_set_visible(var_165_2, "txt_r_type", false)
			if_set_visible(var_165_2, "subboss", false)
			if_set_visible(var_165_2, "boss", false)
			
			if var_164_5 == 1 then
				var_165_2:setScaleX(var_165_2:getScaleX() * -1)
			end
			
			if_set_sprite(var_165_2, "face", "face/" .. var_164_4 .. "_s.png")
		end
		
		if_set(arg_165_0, "disc", T(var_164_1))
		if_set(arg_165_0, "txt_name", T(var_164_3))
	end
	
	local function var_164_16()
		if not var_164_10 then
			return 
		end
		
		local var_166_0 = "event:/" .. var_164_10
		local var_166_1 = SoundEngine:play(var_166_0)
		
		STORY_ACTION_MANAGER:addSounds(var_166_1)
	end
	
	local var_164_17 = false
	local var_164_18
	
	if var_164_12 then
		var_164_18 = _getTargetNodeModel(var_164_12)
		
		if not get_cocos_refid(var_164_18) then
			return 
		end
		
		var_164_13, var_164_14 = var_164_18:getPosition()
		var_164_12 = nil
		var_164_14 = var_164_14 + 240
		var_164_17 = true
	end
	
	local var_164_19 = var_164_13 + var_164_6
	local var_164_20 = var_164_14 + var_164_7
	
	if false then
		if var_164_7 == 0 then
			var_164_7 = 85
		end
		
		local var_164_21 = _getTargetNodeModel(var_164_12)
		
		if not get_cocos_refid(var_164_21) then
			Log.e("Err: no text target unit ", var_164_12)
			
			return 
		end
		
		if var_164_21.n_talk and get_cocos_refid(var_164_21.n_talk) then
			var_164_21.n_talk:removeFromParent()
			
			var_164_21.n_talk = nil
		end
		
		local var_164_22, var_164_23 = var_164_21:getBonePosition("top")
		
		var_164_7 = var_164_7 + var_164_23
		
		local var_164_24 = load_control("wnd/balloon_talk.csb")
		
		var_164_24:setName("talk_" .. var_164_12)
		
		local var_164_25
		
		if_set_visible(var_164_24, "n_right_balloon", var_164_5 == 1)
		if_set_visible(var_164_24, "n_left_balloon", var_164_5 == -1)
		
		if var_164_5 == 1 then
			var_164_25 = var_164_24:getChildByName("n_right_balloon")
		elseif var_164_5 == -1 then
			var_164_25 = var_164_24:getChildByName("n_left_balloon")
		end
		
		var_164_15(var_164_25)
		
		local var_164_26 = BattleLayout:getStoryLayout(var_164_12)
		
		var_164_21:addChild(var_164_24)
		
		var_164_21.n_talk = var_164_24
		
		var_164_24:setPositionY(var_164_7)
		var_164_24:setScale(var_164_8)
		var_164_24:setVisible(false)
		
		local function var_164_27()
			local var_167_0 = {
				caller = "show",
				n_talk = var_164_24,
				n_talk_node = var_164_25,
				start_x = var_164_6,
				balloon_dir = var_164_5,
				parent_direction = var_164_26:getDirection(),
				start_parent_dir = var_164_26:getDirection()
			}
			
			var_164_21._talk_tbl = var_167_0
			
			var_0_5(var_167_0)
		end
		
		if arg_164_5 then
			StoryAction:Add(SEQ(CALL(function()
				var_164_27()
				var_164_16()
			end), SHOW(true), CALL(function()
				StoryLogger:readCutActionBySubAction(var_164_4, var_164_1, var_164_3)
			end), DELAY(var_164_9), REMOVE()), var_164_24)
		else
			local var_164_28 = {}
			local var_164_29 = TARGET(var_164_24, SEQ(CALL(function()
				var_164_27()
				var_164_16()
			end), SHOW(true), CALL(function()
				StoryLogger:readCutActionBySubAction(var_164_4, var_164_1, var_164_3)
			end), DELAY(var_164_9), REMOVE()))
			
			table.add(var_164_28, var_164_29)
			table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
				var_164_28
			})
		end
	else
		local var_164_30 = STORY_ACTION_MANAGER:getLayer()
		local var_164_31 = "world_talk_" .. var_164_0.id
		
		if get_cocos_refid(var_164_30:getChildByName("n_talk_name")) then
			return 
		end
		
		local var_164_32 = load_control("wnd/balloon_talk.csb")
		
		var_164_32:setName(var_164_31)
		
		local var_164_33
		
		if_set_visible(var_164_32, "n_right_balloon", var_164_5 == 1)
		if_set_visible(var_164_32, "n_left_balloon", var_164_5 == -1)
		
		if var_164_5 == 1 then
			var_164_33 = var_164_32:getChildByName("n_right_balloon")
		elseif var_164_5 == -1 then
			var_164_33 = var_164_32:getChildByName("n_left_balloon")
		end
		
		var_164_15(var_164_33)
		var_164_30:addChild(var_164_32)
		var_164_32:setPosition(var_164_19, var_164_20)
		var_164_32:setScale(1)
		var_164_32:setVisible(false)
		var_164_32:setLocalZOrder(9999999)
		var_164_32:setGlobalZOrder(9999999)
		
		if var_164_17 and var_164_18 then
			var_164_32.n_target = var_164_18
			var_164_32.m_x = var_164_6
			var_164_32.m_y = var_164_7
		end
		
		local function var_164_34()
			local var_172_0 = {
				caller = "show",
				n_talk = var_164_32,
				n_talk_node = var_164_33,
				start_x = var_164_6,
				balloon_dir = var_164_5,
				parent_direction = var_164_5,
				start_parent_dir = var_164_5
			}
			
			var_0_5(var_172_0)
		end
		
		if arg_164_5 then
			StoryAction:Add(SEQ(CALL(function()
				var_164_16()
			end), SHOW(true), CALL(function()
				StoryLogger:readCutActionBySubAction(var_164_4, var_164_1, var_164_3)
			end), DELAY(var_164_9), REMOVE()), var_164_32)
		else
			local var_164_35 = {}
			local var_164_36 = TARGET(var_164_32, SEQ(CALL(function()
				var_164_16()
			end), SHOW(true), CALL(function()
				StoryLogger:readCutActionBySubAction(var_164_4, var_164_1, var_164_3)
			end), DELAY(var_164_9), REMOVE()))
			
			table.add(var_164_35, var_164_36)
			table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
				var_164_35
			})
		end
		
		STORY_ACTION_MANAGER:addWorldTalks(var_164_32)
	end
	
	return var_164_9
end

function STORY_V2_SUB_ACTIONS.show_portrait_text(arg_177_0, arg_177_1, arg_177_2, arg_177_3, arg_177_4, arg_177_5)
	if not arg_177_2 or not arg_177_3 then
		return 
	end
	
	local var_177_0 = true
	local var_177_1 = tonumber(arg_177_4) or 3500
	
	STORY_ACTION_MANAGER:setActivePortText(arg_177_3)
	
	if arg_177_5 then
		StoryAction:Add(SEQ(CALL(function()
			STORY_ACTION_MANAGER.vars.next_port_touch_tick = systick()
			
			STORY_ACTION_MANAGER:activePortText()
		end)), STORY_V2_SUB_ACTIONS)
	else
		local var_177_2 = {}
		local var_177_3 = TARGET(STORY_V2_SUB_ACTIONS, SEQ(CALL(function()
			STORY_ACTION_MANAGER.vars.next_port_touch_tick = systick()
			
			STORY_ACTION_MANAGER:activePortText()
		end)))
		
		table.add(var_177_2, var_177_3)
		table.add(STORY_ACTION_MANAGER.vars.ready_actions, {
			var_177_2
		})
	end
	
	return var_177_1, var_177_0
end

function STORY_V2_SUB_ACTIONS.updatePortText_UI(arg_180_0, arg_180_1, arg_180_2)
	if not arg_180_1 then
		return 
	end
	
	local var_180_0 = arg_180_1
	local var_180_1 = var_180_0.id
	local var_180_2 = var_180_0.portrait_id
	local var_180_3 = var_180_0.name or "empty"
	local var_180_4 = var_180_0.portrait_position
	local var_180_5 = var_180_0.zoom
	local var_180_6 = var_180_0.portrait_offset
	local var_180_7 = var_180_0.face_id
	local var_180_8 = var_180_0.voice
	local var_180_9 = T(var_180_1)
	
	if not var_180_2 then
		return 
	end
	
	local var_180_10 = true
	local var_180_11 = STORY_ACTION_MANAGER:getPrevPortID()
	local var_180_12 = var_180_2
	local var_180_13 = STORY_ACTION_MANAGER:getPortParent()
	local var_180_14
	local var_180_15 = true
	
	local function var_180_16()
		if not var_180_8 then
			return 
		end
		
		local var_181_0 = "event:/" .. var_180_8
		local var_181_1 = SoundEngine:play(var_181_0)
		
		STORY_ACTION_MANAGER:addSounds(var_181_1)
	end
	
	if var_180_11 and var_180_11 == var_180_12 and get_cocos_refid(var_180_13) and get_cocos_refid(var_180_13.text_control) and var_180_13.portrait_position and var_180_13.portrait_position == var_180_4 and var_180_13.prev_use_clear_text == var_180_15 then
		var_180_14 = var_180_13.text_control
		
		if_set(var_180_14, nil, "")
		
		local var_180_17 = StoryFace:getFaceAni(var_180_7)
		
		if var_180_17 and get_cocos_refid(var_180_13.portrait) then
			UnitMain:setPortraitEmotion(nil, var_180_13.portrait, var_180_17)
		end
		
		var_180_16()
	else
		if get_cocos_refid(var_180_13) then
			var_180_13:removeAllChildren()
		end
		
		local var_180_18 = load_control("wnd/story_talk.csb")
		local var_180_19
		
		if_set_visible(var_180_18, "n_talk_left", var_180_4 == "left")
		if_set_visible(var_180_18, "n_talk_right", var_180_4 == "right")
		
		if var_180_4 == "left" then
			var_180_19 = var_180_18:getChildByName("n_talk_left")
		else
			var_180_19 = var_180_18:getChildByName("n_talk_right")
		end
		
		local var_180_20 = var_180_19:getChildByName("n_potrait")
		
		var_180_13.prev_use_clear_text = var_180_15
		
		if var_180_15 then
			local var_180_21 = {
				"txt_info",
				"title_bg",
				"baloon"
			}
			
			for iter_180_0, iter_180_1 in pairs(var_180_21) do
				for iter_180_2 = 1, 2 do
					local var_180_22 = var_180_18:getChildByName(iter_180_1)
					
					if var_180_22 then
						var_180_22:removeFromParent()
					end
				end
			end
			
			local var_180_23 = STORY.childs.n_talk_clear:clone()
			
			if not var_180_23 then
				return 
			end
			
			var_180_18:addChild(var_180_23)
			
			var_180_14 = var_180_23:getChildByName("txt_info")
			
			if_set(var_180_23, "txt_name", T(var_180_3))
			var_180_23:setVisible(true)
			var_180_23:setPositionY(-50)
		else
			var_180_14 = var_180_19:getChildByName("txt_info")
			
			if_set(var_180_19, "txt_name", T(var_180_3))
		end
		
		if_set(var_180_14, nil, "")
		var_180_13:addChild(var_180_18)
		var_180_18:setPositionY(50)
		
		var_180_13.text_control = var_180_14
		var_180_13.portrait_position = var_180_4
		
		local var_180_24
		local var_180_25
		local var_180_26, var_180_27 = UIUtil:getPortraitAni(var_180_2)
		
		if not var_180_26 then
			return 
		end
		
		if not var_180_27 then
			local var_180_28 = var_180_26:getContentSize()
			
			var_180_26:setLocalZOrder(9999)
			var_180_26:setName("face")
			var_180_26:setAnchorPoint(0.5, 0.5)
			var_180_26:setPosition(0, 500)
		end
		
		local var_180_29 = cc.Node:create()
		
		var_180_29:setCascadeOpacityEnabled(true)
		var_180_29:setCascadeColorEnabled(true)
		
		var_180_29.portrait = var_180_26
		var_180_13.portrait = var_180_26
		
		var_180_29:addChild(var_180_26)
		
		if var_180_4 == "right" then
			var_180_26:setScaleX(var_180_26:getScaleX() * -1)
		end
		
		var_180_29:setLocalZOrder(20)
		var_180_29:setAnchorPoint(0.5, 0.5)
		var_180_29:setPositionY(-500)
		
		local var_180_30 = StoryFace:getFaceAni(var_180_7)
		
		if var_180_30 then
			UnitMain:setPortraitEmotion(nil, var_180_26, var_180_30)
		end
		
		var_180_20:addChild(var_180_29)
	end
	
	STORY_ACTION_MANAGER:setPortTextUI(true)
	STORY_ACTION_MANAGER:setPrevPortID(var_180_2)
	
	local var_180_31 = 15
	local var_180_32 = 0
	
	if isEULanguage() then
		if arg_180_2 then
			StoryAction:Add(SEQ(SHOW(true), CALL(function()
				var_180_16()
			end), STORY_TEXT(var_180_9, nil, var_180_31, true), CALL(function()
				StoryLogger:readCutActionBySubAction(var_180_2, var_180_1, var_180_3)
			end), DELAY(0)), var_180_14, "block")
		else
			local var_180_33 = {}
			local var_180_34 = TARGET(var_180_14, SEQ(SHOW(true), CALL(function()
				var_180_16()
			end), STORY_TEXT(var_180_9, nil, var_180_31, true), CALL(function()
				StoryLogger:readCutActionBySubAction(var_180_2, var_180_1, var_180_3)
			end), DELAY(0)))
			
			table.add(var_180_33, var_180_34)
			table.add(STORY_ACTION_MANAGER.vars.ready_port_text_actions, {
				var_180_33
			})
		end
	elseif arg_180_2 then
		StoryAction:Add(SEQ(SHOW(true), CALL(function()
			var_180_16()
		end), TEXT(var_180_9, nil, var_180_31, true), CALL(function()
			StoryLogger:readCutActionBySubAction(var_180_2, var_180_1, var_180_3)
		end), DELAY(0)), var_180_14, "block")
	else
		local var_180_35 = {}
		local var_180_36 = TARGET(var_180_14, SEQ(SHOW(true), CALL(function()
			var_180_16()
		end), TEXT(var_180_9, nil, var_180_31, true), CALL(function()
			StoryLogger:readCutActionBySubAction(var_180_2, var_180_1, var_180_3)
		end), DELAY(0)))
		
		table.add(var_180_35, var_180_36)
		table.add(STORY_ACTION_MANAGER.vars.ready_port_text_actions, {
			var_180_35
		})
	end
	
	return 100, var_180_10
end

local function var_0_10(arg_190_0)
	arg_190_0:setOpacity(0)
	StoryAction:Add(SEQ(DELAY(2000), FADE_IN(3000)), arg_190_0, "logo_loop")
end

local function var_0_11()
	local var_191_0 = getUserLanguage()
	
	if ({
		zhs = 1,
		zht = 1
	})[var_191_0] then
		return var_191_0
	end
end

local function var_0_12(arg_192_0)
	local var_192_0
	local var_192_1 = var_0_11()
	
	if var_192_1 then
		var_192_0 = "ui/epic7_logo_" .. var_192_1 .. ".png"
	else
		var_192_0 = "ui/epic7_logo" .. ".png"
	end
	
	arg_192_0:setTexture(var_192_0)
end

function STORY_V2_SUB_ACTIONS.showTitleBG(arg_193_0)
	local var_193_0 = 1
	local var_193_1 = 1.6
	local var_193_2
	
	if STORY.layer then
		var_193_2 = STORY.layer:getParent()
		
		STORY_ACTION_MANAGER.vars.n_bg:setVisible(false)
	end
	
	if not get_cocos_refid(var_193_2) then
		var_193_2 = SceneManager:getRunningPopupScene()
	end
	
	local var_193_3 = var_193_2:getChildByName("default_bg")
	
	if get_cocos_refid(var_193_3) then
		var_193_3:removeFromParent()
	end
	
	local var_193_4
	local var_193_5
	local var_193_6
	local var_193_7
	local var_193_8
	local var_193_9
	
	;(function(arg_194_0)
		local var_194_0 = cc.Node:create()
		
		var_194_0:setName("default_bg")
		var_194_0:setCascadeOpacityEnabled(true)
		var_194_0:setScale(var_193_0)
		arg_194_0:addChild(var_194_0)
		var_194_0:bringToFront()
		
		var_193_4 = TitleBackground:addEffect(var_194_0, "main_sky", {
			loop = true,
			atlas = "open_renew",
			scale = var_193_1
		})
		var_193_5 = TitleBackground:addEffect(var_194_0, "main_waterfall", {
			loop = true,
			atlas = "open_renew",
			scale = var_193_1
		})
		var_193_6 = TitleBackground:addEffect(var_194_0, "main_light", {
			loop = true,
			atlas = "open_renew",
			scale = var_193_1
		})
		var_193_7 = TitleBackground:addEffect(var_194_0, "main_light2", {
			loop = true,
			atlas = "open_renew",
			scale = var_193_1
		})
		var_193_8 = TitleBackground:addEffect(var_194_0, "main_twinkle1", {
			loop = true,
			atlas = "open_renew",
			scale = var_193_1
		})
		var_193_9 = TitleBackground:addEffect(var_194_0, "main_twinkle2", {
			loop = true,
			atlas = "open_renew",
			scale = var_193_1
		})
		
		var_194_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		
		local var_194_1 = cc.Sprite:create("worldmap/clanwardepth01.png")
		
		arg_194_0:addChild(var_194_1)
		var_194_1:setAnchorPoint(0.5, 0.5)
		var_194_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2 + 52)
		var_194_1:bringToFront()
		var_0_12(var_194_1)
		var_0_10(var_194_1)
	end)(var_193_2)
	
	local var_193_10 = var_193_2:getChildByName("default_bg")
	local var_193_11 = 1
	local var_193_12 = 10
	local var_193_13 = 3000
	
	StoryAction:Add(SEQ(DELAY(var_193_12), CALL(function()
		EffectManager:Play({
			fn = "sanctuary_day_intro.cfx",
			pivot_z = 99998,
			layer = var_193_2,
			pivot_x = DESIGN_WIDTH / 2,
			pivot_y = DESIGN_HEIGHT / 2
		}):bringToFront()
	end), LOG(SCALE(var_193_13, var_193_0, 1.3 * VIEW_WIDTH / TITLE_WIDTH * 0.65))), var_193_10)
	StoryAction:Add(SEQ(DELAY(var_193_12), LOG(SCALE(var_193_13, var_193_11 * 0.8, var_193_1), 10)), var_193_4, "block")
	StoryAction:Add(SEQ(DELAY(var_193_12), LOG(SCALE(var_193_13, var_193_11 * 0.8, var_193_1), 10)), var_193_5, "block")
	StoryAction:Add(SEQ(DELAY(var_193_12), LOG(SCALE(var_193_13, var_193_11 * 0.8, var_193_1), 10)), var_193_6, "block")
	StoryAction:Add(SEQ(DELAY(var_193_12), LOG(SCALE(var_193_13, var_193_11 * 0.8, var_193_1), 10)), var_193_7, "block")
	StoryAction:Add(SEQ(DELAY(var_193_12), LOG(SCALE(var_193_13, var_193_11 * 0.8, var_193_1), 10)), var_193_8, "block")
	StoryAction:Add(SEQ(DELAY(var_193_12), LOG(SCALE(var_193_13, var_193_11 * 0.8, var_193_1), 10)), var_193_9, "block")
end

function STORY_V2_SUB_ACTIONS.removeTitleBG(arg_196_0)
end
