if STORY == nil then
	STORY = {}
	STORY.childs = {}
end

STORY_SKIPPED_LIST = {}
STORY = {}
STORY_PLAYBACK_QUEUE = {}
STORY_AUTO_DEFAULT_SPEED = 0.4
STORY_AUTO_QUICKLY_SPEED = 1
STORY_AUTO_DEFAULT_DELAY_TM = 4000
STORY_AUTO_QUICKLY_DELAY_TM = 2500

local var_0_0 = true
local var_0_1 = 2
local var_0_2 = false

local function var_0_3()
	return STORY.current_talker == "CHAPTER" or STORY.current_talker == "NARRATION"
end

local function var_0_4(arg_2_0, arg_2_1)
	if not STORY.childs or not get_cocos_refid(STORY.childs.n_skip) then
		return 
	end
	
	if STORY.is_moonlight_th then
		STORY.childs.n_skip:setVisible(false)
		if_set_visible(STORY.childs.dlg, "bar__", false)
		
		return 
	end
	
	if arg_2_1 then
		if arg_2_0 then
			if not STORY.childs.n_skip:isVisible() then
				UIAction:Add(FADE_IN(200), STORY.childs.n_skip, "story.skip")
			end
		elseif STORY.childs.n_skip:getOpacity() >= 255 then
			UIAction:Add(FADE_OUT(200, true), STORY.childs.n_skip, "story.skip")
		end
	else
		UIAction:Remove("story.skip")
		STORY.childs.n_skip:setVisible(arg_2_0)
		STORY.childs.n_skip:setOpacity(255)
	end
end

local function var_0_5(arg_3_0)
	if not BGI then
		return 
	end
	
	if get_cocos_refid(BGI.game_layer) then
		BGI.game_layer:setVisible(arg_3_0)
	end
	
	if get_cocos_refid(BGI.ui_layer) then
		BGI.ui_layer:setVisible(arg_3_0)
	end
end

local function var_0_6()
	if not get_cocos_refid(STORY.skip_popup) then
		return 
	end
	
	BackButtonManager:pop({
		dlg = STORY.skip_popup
	})
	STORY.skip_popup:removeFromParent()
	
	STORY.skip_popup = nil
end

local function var_0_7()
	if not get_cocos_refid(STORY.scene) then
		return 
	end
	
	if not get_cocos_refid(STORY.layer) then
		return 
	end
	
	if STORY.movie_skip then
		return 
	end
	
	local var_5_0 = STORY.scene or SceneManager:getRunningPopupScene()
	local var_5_1 = STORY.layer:findChildByName("movie_front")
	
	if get_cocos_refid(var_5_1) then
		STORY.movie_skip = true
		
		if getenv("patch.status") ~= "complete" then
			PatchGauge:sideShow(true)
		end
		
		SysAction:Add(SEQ(TARGET(var_5_1, FADE_OUT(600)), TARGET(var_5_1, REMOVE()), CALL(function()
			SoundEngine:setFadeSoundOnStoryBGM(false)
		end)), var_5_0)
	end
end

function updateOffsetStory()
end

function HANDLER_BEFORE.story(arg_8_0, arg_8_1)
end

function HANDLER_CANCEL.story(arg_9_0, arg_9_1)
end

function HANDLER.story(arg_10_0, arg_10_1)
	local var_10_0 = false or get_cocos_refid((STORY.childs or {}).movie)
	
	var_10_0 = var_10_0 or get_cocos_refid((STORY.childs or {}).choice_ui)
	
	if var_10_0 then
		if get_cocos_refid((STORY.childs or {}).choice_ui) and arg_10_1 == "btn_storylog" then
			StoryViewer:show()
		end
		
		local var_10_1 = (STORY.childs or {}).movie
		
		if get_cocos_refid(var_10_1) then
			check_cool_time(var_10_1, "skip_video", 2000, function()
				var_10_1:executeVideoSkip(T("movie_skip_toast"))
			end, function()
				balloon_message_with_sound("movie_skip_toast")
			end, true)
		end
		
		STORY.double_speed = nil
		
		return 
	end
	
	if arg_10_1 == "btn_next_nosound" and step_next() then
		stop_story(true)
	end
	
	if arg_10_1 == "btn_return_dict" then
		STORY.active_popup_dlg = Dialog:msgBox(T("dic_story_out_desc"), {
			yesno = true,
			title = T("dic_story_out_title"),
			handler = function()
				exit_story()
			end
		})
	end
	
	if arg_10_1 == "btn_storylog" then
		StoryViewer:show()
	end
	
	if arg_10_1 == "btn_play" then
		local var_10_2 = (STORY.AUTO_STORY_SPEED or 0) > 0 and 0 or SAVE:get("app.story_auto_speed", STORY_AUTO_DEFAULT_SPEED)
		
		set_auto_story_speed(var_10_2, true)
		update_auto_play()
	end
	
	if arg_10_1 == "btn_speed" then
		toggle_auto_story_speed()
	end
	
	if arg_10_1 == "btn_pause" then
		open_story_esc()
		
		return 
	end
end

local var_0_8 = false
local var_0_9 = false
local var_0_10 = cc.c3b(60, 60, 60)
local var_0_11 = cc.c3b(255, 255, 255)
local var_0_12 = 0.95
local var_0_13 = 1.2
local var_0_14 = 0
local var_0_15 = -300

if table.push == nil then
	function table.push(arg_14_0, arg_14_1)
		arg_14_0[#arg_14_0 + 1] = arg_14_1
	end
end

StoryFace = StoryFace or {}

function StoryFace.convertFaceID(arg_15_0, arg_15_1)
	if arg_15_0.face_key == nil then
		arg_15_0.face_key = {}
		
		for iter_15_0 = 1, 999 do
			local var_15_0, var_15_1, var_15_2, var_15_3 = DBN("face", iter_15_0, {
				"id",
				"key",
				"face",
				"ani_face"
			})
			
			if not var_15_0 then
				break
			end
			
			arg_15_0.face_key[var_15_1] = var_15_0
		end
	end
	
	return arg_15_0.face_key[arg_15_1]
end

function StoryFace.getDBFace(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:convertFaceID(arg_16_1)
	local var_16_1, var_16_2 = DB("face", var_16_0, {
		"face",
		"ani_face"
	})
	
	return var_16_1, var_16_2
end

function StoryFace.getFaceAni(arg_17_0, arg_17_1)
	local var_17_0, var_17_1 = arg_17_0:getDBFace(arg_17_1)
	
	return var_17_1
end

function StoryFace.getFaceSpr(arg_18_0, arg_18_1)
	local var_18_0, var_18_1 = arg_18_0:getDBFace(arg_18_1)
	
	return var_18_0
end

function start_new_story(arg_19_0, arg_19_1, arg_19_2)
	story_log_clear()
	
	return play_story(arg_19_1, arg_19_2 or {})
end

local function var_0_16(arg_20_0)
	local var_20_0 = arg_20_0.eff1
	
	if type(var_20_0) ~= "string" then
		var_20_0 = ""
	end
	
	if arg_20_0.story_action then
		return true
	end
	
	if arg_20_0.wait then
		return true
	end
	
	if string.starts(var_20_0, "스킬") then
		return true
	end
	
	if arg_20_0.text and arg_20_0.talker ~= "LOCATION" then
		return true
	end
	
	if not arg_20_0.text and arg_20_0.talker and arg_20_0.talker ~= "LOCATION" then
		return true
	end
	
	return false
end

function story_text_locale_column()
	local var_21_0 = get_user_language()
	
	if var_21_0 == "ko" then
		return "text"
	end
	
	local var_21_1 = getenv("app.pubid")
	
	if var_21_1 then
		return "text_" .. var_21_0 .. "_" .. var_21_1
	end
	
	return "text_" .. var_21_0
end

function load_story(arg_22_0, arg_22_1)
	local var_22_0 = DB("story_main_script_1", arg_22_0, "info") or DB("story_sub_script_1", arg_22_0, "info") or DB("story_etc_script_1", arg_22_0, "info") or DB("story_special_script_1_1", arg_22_0, "info")
	
	if not var_22_0 and not PRODUCTION_MODE then
		var_22_0 = DB("story_dev_script_1", arg_22_0, "info")
	end
	
	if not var_22_0 then
		return nil
	end
	
	local var_22_1 = json.decode(var_22_0)
	local var_22_2 = {}
	local var_22_3 = getUserLanguage()
	
	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		iter_22_1.text = iter_22_1[story_text_locale_column()]
		
		if iter_22_1.text == "" then
			iter_22_1.text = nil
		end
		
		if iter_22_1.movie and iter_22_1.movie ~= "" or iter_22_1.choice_flag and iter_22_1.choice_flag ~= "" then
			iter_22_1.text = iter_22_1.text or ""
		end
	end
	
	local var_22_4 = {}
	local var_22_5 = {}
	
	for iter_22_2, iter_22_3 in pairs(var_22_1) do
		if iter_22_3.bg or iter_22_3.talker or iter_22_3.text or iter_22_3.eff1 or iter_22_3.bgm or iter_22_3.sound_effect or iter_22_3.image or iter_22_3.movie or iter_22_3.story_action then
			table.push(var_22_5, iter_22_3)
			
			if #var_22_5 and var_0_16(iter_22_3) then
				table.push(var_22_4, var_22_5)
				
				var_22_5 = {}
			end
		end
	end
	
	if not #var_22_5 or arg_22_1 and table.empty(var_22_5) then
	else
		table.push(var_22_4, var_22_5)
	end
	
	return var_22_4
end

function setup_sound(arg_23_0)
	if arg_23_0.sound_effect then
		local var_23_0 = arg_23_0.sound_effect
		
		if not string.starts(arg_23_0.sound_effect, "event:/") then
			local var_23_1 = "event:/" .. var_23_0
		end
		
		table.push(arg_23_0.actions, SOUND(arg_23_0.sound_effect))
	end
end

local function var_0_17(arg_24_0)
	if not STORY.layer or not arg_24_0 or table.empty(arg_24_0) then
		return 
	end
	
	local var_24_0 = (SubstoryManager:getInfo() or {}).id
	
	if not var_24_0 then
		return 
	end
	
	local var_24_1 = SubStoryUtil:getSubCusItemList(var_24_0)
	
	if not var_24_1 or table.empty(var_24_1) then
		return 
	end
	
	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		if arg_24_0[iter_24_1.id] then
			iter_24_1.change_value = arg_24_0[iter_24_1.id]
		else
			iter_24_1.change_value = 0
		end
	end
	
	local var_24_2 = STORY.layer:getChildByName("n_confirm_in")
	local var_24_3 = STORY.layer:getChildByName("n_confirm")
	
	if not get_cocos_refid(var_24_3) or not get_cocos_refid(var_24_2) then
		return 
	end
	
	local var_24_4 = getChildByPath(STORY.childs.dlg, "n_result")
	
	if var_24_4 then
		var_24_4:setVisible(true)
	end
	
	local var_24_5 = var_24_2:getPositionY()
	local var_24_6 = var_24_3:getPositionY()
	local var_24_7 = var_24_3:getChildByName("n_reward")
	local var_24_8 = 1
	
	for iter_24_2, iter_24_3 in pairs(var_24_1) do
		local var_24_9 = var_24_7:getChildByName("n_" .. var_24_8)
		local var_24_10 = tonumber(iter_24_3.change_value)
		
		if not get_cocos_refid(var_24_9) then
			break
		end
		
		var_24_9:setVisible(true)
		UIUtil:getRewardIcon(nil, iter_24_3.id, {
			parent = var_24_9:getChildByName("n_item" .. var_24_8)
		})
		
		local var_24_11 = var_24_9:getChildByName("n_result")
		
		if var_24_10 > 0 then
			if_set_visible(var_24_11, "n_up", true)
			if_set(var_24_11, "t_count_up", var_24_10)
		elseif var_24_10 < 0 then
			if_set_visible(var_24_11, "n_down", true)
			if_set(var_24_11, "t_count_down", var_24_10)
		else
			if_set_visible(var_24_11, "n_keep", true)
			if_set(var_24_11, "t_count_keep", var_24_10)
		end
		
		local var_24_12 = iter_24_3.count + var_24_10
		local var_24_13 = iter_24_3.init_count or 0
		local var_24_14 = iter_24_3.max_count or 0
		local var_24_15 = math.min(var_24_12, var_24_14)
		local var_24_16 = math.max(var_24_15, var_24_13)
		
		if_set(var_24_9, "txt_count" .. var_24_8, var_24_16)
		
		var_24_8 = var_24_8 + 1
	end
	
	var_24_3.origin_y = var_24_6
	
	UIAction:Add(SEQ(LOG(MOVE_TO(500, nil, var_24_5))), var_24_3, "reward_ui_slide_in")
	
	var_0_2 = true
end

local function var_0_18(arg_25_0)
	if not STORY.layer then
		return 
	end
end

local function var_0_19(arg_26_0)
	if arg_26_0 and arg_26_0.req_choice_type then
		if arg_26_0.req_choice_value then
			if arg_26_0.req_choice_type == "map" and not Account:isMapCleared(arg_26_0.req_choice_value) then
				return true
			elseif arg_26_0.req_choice_type == "substory_achievement" and ((Account:getSubStoryAchievement(arg_26_0.req_choice_value) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE) < SUBSTORY_ACHIEVE_STATE.CLEAR then
				return true
			end
		elseif arg_26_0.req_choice_type == "once" and STORY.choice_id then
			return true
		end
	end
	
	return false
end

local function var_0_20(arg_27_0)
	if arg_27_0.req_choice_type == "map" then
		local var_27_0 = DB("level_enter", arg_27_0.req_choice_value, "name")
		
		return T("req_story_choice_map", {
			enter = T(var_27_0)
		})
	elseif arg_27_0.req_choice_type == "substory_achievement" then
		local var_27_1 = DB("substory_achievement", arg_27_0.req_choice_value, "name")
		
		return T("req_story_choice_achieve", {
			achieve = T(var_27_1)
		})
	elseif arg_27_0.req_choice_type == "once" then
		return nil
	end
	
	return nil
end

function setup_choice(arg_28_0)
	local var_28_0 = arg_28_0 or {}
	
	if STORY.is_lota_event then
		STORY.childs.choice_ui = LotaEventSelectUI:open()
		STORY.double_speed = nil
		STORY.cut_opts.select_wait = true
		
		local var_28_1 = STORY.layer:getChildByName("n_portrait")
		
		var_28_1:addChild(STORY.childs.choice_ui)
		var_28_1:sortAllChildren()
		if_set_visible(STORY.layer, "n_auto", false)
		if_set_visible(STORY.layer:getParent(), "skip_front", false)
		if_set_visible(STORY.layer:getChildByName("n_return_dict"), "bar__", false)
		
		return 
	end
	
	local var_28_2 = false
	local var_28_3 = {}
	
	for iter_28_0 = 1, 3 do
		local var_28_4 = string.format("%s_%d", var_28_0.choice_flag or "", iter_28_0)
		local var_28_5 = DBT("story_choice", var_28_4, {
			"id",
			"clue_popup_btn",
			"next_story_id1",
			"next_story_id2",
			"req_choice_type",
			"req_choice_value",
			"choice_reward",
			"choice_confirm_title",
			"choice_confirm_desc",
			"choice_lock",
			"choice_life_decrease",
			"choice_voice"
		})
		
		if not table.empty(var_28_5) then
			table.insert(var_28_3, var_28_5)
			
			if var_28_5.choice_reward then
				var_28_2 = true
				var_28_5.choice_reward = totable(var_28_5.choice_reward)
			end
		end
	end
	
	local var_28_6
	
	if var_28_2 then
		var_28_6 = load_control("wnd/story_select_custom.csb")
	else
		var_28_6 = load_control("wnd/story_select.csb")
	end
	
	if STORY.use_choice_life then
		STORY.choice_life_on_nodes = {}
		STORY.choice_life_off_nodes = {}
		
		local var_28_7 = ({
			{
				1,
				2,
				3,
				4,
				6,
				7,
				8,
				9
			},
			{
				10,
				9,
				8,
				7,
				4,
				3,
				2,
				1
			},
			{
				9,
				8,
				7,
				1,
				2,
				3
			},
			{
				10,
				9,
				8,
				3,
				2,
				1
			},
			{
				9,
				8,
				2,
				1
			},
			{
				10,
				9,
				2,
				1
			},
			{
				9,
				1
			},
			{
				10,
				1
			}
		})[STORY.max_life_cnt]
		local var_28_8 = var_28_6:getChildByName("n_count")
		local var_28_9 = STORY.max_life_cnt % 2 == 1
		local var_28_10
		
		if var_28_9 then
			var_28_10 = var_28_8:getChildByName("n_odd")
		else
			var_28_10 = var_28_8:getChildByName("n_even")
		end
		
		if_set_visible(var_28_8, "n_odd", var_28_9)
		if_set_visible(var_28_8, "n_even", not var_28_9)
		
		local var_28_11
		
		if get_cocos_refid(var_28_10) then
			for iter_28_1, iter_28_2 in pairs(var_28_7) do
				if_set_visible(var_28_10, "icon_clear" .. iter_28_2, false)
				if_set_visible(var_28_10, "icon_off" .. iter_28_2, false)
			end
			
			var_28_11 = 1
			
			for iter_28_3 = 10, 1, -1 do
				if not table.find(var_28_7, iter_28_3) then
					local var_28_12 = var_28_10:getChildByName("icon_clear" .. iter_28_3)
					local var_28_13 = var_28_10:getChildByName("icon_off" .. iter_28_3)
					
					if get_cocos_refid(var_28_12) and get_cocos_refid(var_28_13) then
						var_28_12:setVisible(true)
						var_28_13:setVisible(true)
						table.insert(STORY.choice_life_on_nodes, var_28_12)
						table.insert(STORY.choice_life_off_nodes, var_28_13)
						var_28_12:setVisible(var_28_11 <= STORY.cur_life_cnt)
						
						var_28_11 = var_28_11 + 1
					end
				end
			end
		end
		
		local var_28_14 = var_28_6:getChildByName("txt_title")
		
		if get_cocos_refid(var_28_14) then
			var_28_14:setPositionY(var_28_14:getPositionY() + 56)
		end
	end
	
	local var_28_15 = STORY.layer:getChildByName("n_portrait")
	
	if get_cocos_refid(var_28_15) then
		var_28_6:setLocalZOrder(999)
		var_28_15:addChild(var_28_6)
		var_28_15:sortAllChildren()
	else
		STORY.layer:addChild(var_28_6)
		STORY.layer:sortAllChildren()
	end
	
	if table.empty(var_28_3) then
		var_28_6:removeFromParent()
		
		return 
	end
	
	STORY.childs.choice_ui = var_28_6
	STORY.double_speed = nil
	STORY.cut_opts.select_wait = true
	
	local var_28_16 = STORY.childs.mid
	
	if var_28_16 and get_cocos_refid(var_28_16.portrait) then
		local var_28_17 = var_28_16.portrait
		
		table.push(var_28_0.actions, SEQ(CALL(clear_character, "left"), CALL(clear_character, "right"), SPAWN(TARGET(var_28_17, ANCHOR(400, var_28_17:getAnchorPoint(), cc.p(0.5, var_0_14))), TARGET(var_28_17, MOVE_TO(400, DESIGN_WIDTH * 0.2, var_0_15)), TARGET(var_28_6, FADE_IN(400)))))
	end
	
	local var_28_18 = true
	local var_28_19
	
	if STORY.choice_id then
		local var_28_20 = table.find(var_28_3, function(arg_29_0, arg_29_1)
			return arg_29_1.id == STORY.choice_id
		end)
		
		if var_28_20 then
			var_28_19 = var_28_3[var_28_20]
		end
	end
	
	local function var_28_21()
		if STORY.choice_id and STORY.enter_id and (STORY.enter_id == "vva1ag001" or STORY.enter_id == "vva1ah001") then
			return true
		end
		
		return false
	end
	
	if var_28_21() and not var_28_19 and Account then
		for iter_28_4, iter_28_5 in pairs(var_28_3) do
			local var_28_22 = false
			local var_28_23 = iter_28_5.next_story_id1
			
			var_28_22 = var_28_22 or Account:isPlayedStory(var_28_23)
			
			if var_28_22 then
				var_28_19 = iter_28_5
				
				break
			end
		end
	end
	
	for iter_28_6, iter_28_7 in pairs(var_28_3) do
		if iter_28_7.clue_popup_btn then
			local var_28_24 = var_28_6:getChildByName("obtained_clues")
			
			if get_cocos_refid(var_28_24) then
				local var_28_25 = var_28_24:getChildByName("btn_obtained_clues")
				
				if_set_visible(var_28_24, nil, true)
				
				if get_cocos_refid(var_28_25) then
					var_28_25:addTouchEventListener(function(arg_31_0, arg_31_1)
						if arg_31_1 == ccui.TouchEventType.ended and STORY.enter_id then
							SubStoryCluePage:open(string.sub(STORY.enter_id, 1, -4), {
								parent_layer = STORY.layer
							})
						end
					end)
				end
			end
			
			break
		end
	end
	
	local var_28_26 = not var_0_19(var_28_19)
	local var_28_27 = var_28_6:getChildByName("n_select_conver")
	
	if var_28_2 then
		if table.count(var_28_3) % 2 == 1 then
			var_28_27 = var_28_6:getChildByName("n_odd")
		else
			var_28_27 = var_28_6:getChildByName("n_even")
		end
		
		var_28_27:setVisible(true)
	end
	
	for iter_28_8 = 1, 3 do
		if not var_28_3[iter_28_8] then
			if_set_visible(var_28_27, "balloon_" .. iter_28_8, false)
		else
			local var_28_28 = var_28_27:getChildByName("balloon_" .. iter_28_8)
			local var_28_29 = var_28_27:getChildByName("btn_choice_" .. iter_28_8)
			local var_28_30 = var_28_3[iter_28_8].choice_reward ~= nil and not table.empty(var_28_3[iter_28_8].choice_reward)
			
			if var_28_30 then
				if STORY.choice_id then
					if_set_visible(var_28_27, "n_choice", false)
					if_set_visible(var_28_27, "n_result", true)
				else
					if_set_visible(var_28_27, "n_choice", var_28_30)
					if_set_visible(var_28_27, "n_result", not var_28_30)
				end
			end
			
			TutorialGuide:onStoryChoice(var_28_3[iter_28_8].id)
			
			local var_28_31 = var_28_3[iter_28_8].choice_lock == "y" and var_0_19(var_28_3[iter_28_8])
			local var_28_32 = var_28_26 == false and var_28_3[iter_28_8].id ~= STORY.choice_id or var_28_31
			
			if get_cocos_refid(var_28_28) then
				local var_28_33 = false
				
				if var_28_3[iter_28_8] and Account then
					local var_28_34 = var_28_3[iter_28_8].next_story_id1
					
					var_28_33 = var_28_33 or Account:isPlayedStory(var_28_34)
				end
				
				if var_28_21() then
					var_28_32 = (not var_28_33 or false) and true
				end
				
				if var_28_2 then
					if var_28_30 and not STORY.choice_id then
						if_set_visible(var_28_28, "n_result", false)
						if_set_visible(var_28_28, "n_choice", true)
						
						local var_28_35 = var_28_28:getChildByName("n_choice")
						
						if_set(var_28_35, "txt_info", T(var_28_3[iter_28_8].id .. "_title"))
						
						local var_28_36 = var_28_28:getChildByName("n_reward")
						local var_28_37
						
						if get_cocos_refid(var_28_36) then
							var_28_37 = 1
							
							for iter_28_9, iter_28_10 in pairs(var_28_3[iter_28_8].choice_reward) do
								local var_28_38 = var_28_36:getChildByName("n_" .. var_28_37)
								local var_28_39 = tonumber(iter_28_10)
								
								if not get_cocos_refid(var_28_38) then
									break
								end
								
								var_28_38:setVisible(true)
								UIUtil:getRewardIcon(nil, iter_28_9, {
									parent = var_28_38:getChildByName("n_item" .. var_28_37)
								})
								
								local var_28_40 = var_28_38:getChildByName("n_expect")
								
								if var_28_39 > 0 then
									if_set_visible(var_28_40, "n_up", true)
									if_set(var_28_40, "t_count_up", var_28_39)
								elseif var_28_39 < 0 then
									if_set_visible(var_28_40, "n_down", true)
									if_set(var_28_40, "t_count_down", var_28_39)
								end
								
								var_28_37 = var_28_37 + 1
							end
						end
					else
						local var_28_41 = var_28_28:getChildByName("n_result")
						
						var_28_41:setVisible(true)
						if_set(var_28_41, "txt_info", T(var_28_3[iter_28_8].id .. "_title"))
						if_set_visible(var_28_28, "n_result", true)
						if_set_visible(var_28_28, "n_choice", false)
					end
				else
					if_set(var_28_28, "txt_info", T(var_28_3[iter_28_8].id .. "_title"))
				end
				
				if not var_28_2 and var_28_33 and not STORY.skip_chosen_opacity then
					var_28_28:setOpacity(76)
				end
				
				if not var_28_2 and var_28_33 then
					var_28_32 = false
				end
				
				if_set_visible(var_28_28, "n_locked", var_28_32)
				if_set_visible(var_28_28, "n_normal", not var_28_32)
				
				if var_28_32 then
					if_set_color(var_28_28, "btn_choice_" .. iter_28_8, cc.c3b(139, 24, 24))
					if_set_opacity(var_28_28, "btn_choice_" .. iter_28_8, 127.5)
					
					if var_28_31 then
						local var_28_42 = var_0_20(var_28_3[iter_28_8]) or T(var_28_3[iter_28_8].id .. "_title")
						
						if_set(var_28_28, "txt_locked", var_28_42)
					elseif var_28_26 == false and var_28_19 then
						local var_28_43 = var_0_20(var_28_19) or T(var_28_3[iter_28_8].id .. "_title")
						
						if_set(var_28_28, "txt_locked", var_28_43)
					end
				end
			end
			
			if get_cocos_refid(var_28_29) then
				var_28_29:addTouchEventListener(function(arg_32_0, arg_32_1)
					if arg_32_1 ~= 2 then
						return 
					end
					
					if SysAction:Find("block") then
						return 
					end
					
					if TutorialGuide:isPlayingTutorial("vva2ba_inference") then
						return 
					end
					
					if var_28_32 then
						if STORY.choice_id then
							balloon_message_with_sound("msg_story_choice_once_other")
						else
							balloon_message_with_sound("req_story_choice_balloon")
						end
						
						return 
					end
					
					local function var_32_0()
						local var_33_0 = {}
						local var_33_1 = true
						
						for iter_33_0 = 1, 3 do
							if iter_33_0 ~= iter_28_8 then
								if_set_visible(var_28_27, "balloon_" .. iter_33_0, false)
							end
						end
						
						local var_33_2 = false
						local var_33_3
						
						if STORY.use_choice_life then
							local var_33_4 = var_28_3[iter_28_8].choice_life_decrease
							local var_33_5 = var_28_3[iter_28_8].choice_voice
							local var_33_6 = STORY.cur_life_cnt
							
							if var_33_4 then
								STORY.cur_life_cnt = STORY.cur_life_cnt + var_33_4
								
								if STORY.cur_life_cnt <= 0 then
									var_33_3 = load_story(STORY.fail_story, true)
									
									if var_33_3 then
										var_33_2 = true
										STORY.is_failed_story = true
									end
								end
								
								for iter_33_1 = 1, STORY.max_life_cnt do
									local var_33_7 = STORY.choice_life_on_nodes[iter_33_1]
									
									if get_cocos_refid(var_33_7) then
										var_33_7:setVisible(iter_33_1 <= STORY.cur_life_cnt)
										
										if iter_33_1 > STORY.cur_life_cnt and iter_33_1 <= var_33_6 then
											EffectManager:Play({
												x = 12,
												y = 12,
												fn = "ui_rumble_heart_break.cfx",
												layer = STORY.choice_life_off_nodes[iter_33_1]
											})
										end
									end
								end
							end
							
							if var_28_3[iter_28_8].next_story_id1 then
								StoryMap:addChoiceId(var_28_3[iter_28_8].next_story_id1)
							end
							
							if var_33_5 then
								STORY.n_voice = SoundEngine:play("event:/voc/" .. var_33_5)
								
								if STORY.n_voice and STORY.n_voice.onStopEventListener then
									STORY.n_voice:onStopEventListener(function()
										if (STORY.double_speed or STORY.cut_opts.auto_continue) and #STORY.actions == 0 then
											step_next()
										end
									end)
								end
							end
						end
						
						for iter_33_2 = 1, 2 do
							local var_33_8 = var_28_3[iter_28_8]["next_story_id" .. iter_33_2]
							
							if var_33_8 then
								if table.empty(STORY.story[#STORY.story]) then
									table.pop(STORY.story)
								end
								
								if var_33_2 and iter_33_2 == 2 then
									break
								end
								
								local var_33_9 = load_story(var_33_8, true)
								
								if var_33_9 then
									table.add(STORY.story, var_33_9)
									table.insert(var_33_0, var_33_8)
								end
							end
						end
						
						if var_33_2 and var_33_3 then
							table.add(STORY.story, var_33_3)
							table.insert(var_33_0, STORY.fail_story)
						end
						
						if STORY.callback_choice_list and type(STORY.callback_choice_list) == "function" then
							if not is_using_story_v2() then
								StoryLogger:readSelected(T(var_28_3[iter_28_8].id .. "_title"))
							end
							
							STORY.callback_choice_list(var_33_0, STORY.enter_id)
						end
						
						if STORY.return_vars then
							STORY.return_vars.choice_id = var_28_3[iter_28_8].id
							
							if not STORY.return_vars.reward_choice_id then
								STORY.return_vars.reward_choice_id = {}
							end
							
							table.insert(STORY.return_vars.reward_choice_id, var_28_3[iter_28_8].id)
						end
						
						local var_33_10 = NONE()
						local var_33_11 = STORY.childs.mid
						
						if var_33_11 and get_cocos_refid(var_33_11.portrait) then
							local var_33_12 = var_33_11.portrait
							
							var_33_10 = TARGET(var_33_12, SPAWN(ANCHOR(400, var_33_12:getAnchorPoint(), cc.p(0.5, var_0_14)), MOVE_TO(400, DESIGN_WIDTH / 2, var_0_15)))
						end
						
						SysAction:Add(SEQ(CALL(SoundEngine.play, SoundEngine, "event:/ui/story_select"), REPEAT(3, SEQ(TARGET(var_28_28, OPACITY(400, 1, 0.3)), TARGET(var_28_28, OPACITY(400, 0.3, 1)))), SPAWN(var_33_10, FADE_OUT(300)), CALL(function()
							STORY.cut_opts.select_wait = nil
						end), CALL(step_next, {
							force = true
						}), REMOVE()), var_28_6, "block")
					end
					
					local var_32_1 = var_28_3[iter_28_8].choice_reward and not table.empty(var_28_3[iter_28_8].choice_reward)
					
					if var_28_2 and not STORY.choice_id and var_32_1 then
						local var_32_2 = var_28_3[iter_28_8].choice_confirm_title or "msg_story_select_custom_check_tl"
						local var_32_3 = var_28_3[iter_28_8].choice_confirm_desc or "msg_story_select_custom_check_desc"
						local var_32_4 = Dialog:msgBox(nil, {
							yesno = true,
							handler = function()
								var_32_0()
								var_0_17(var_28_3[iter_28_8].choice_reward)
							end,
							dlg = load_dlg("story_select_custom_check", true, "wnd"),
							title = T(var_32_2)
						})
						
						if_set(var_32_4, "txt_title", T(var_32_2))
						upgradeLabelToRichLabel(var_32_4, "txt_disc", true)
						if_set(var_32_4, "txt_disc", T(var_32_3))
						if_set(var_32_4, "txt_info", T(var_28_3[iter_28_8].id .. "_title"))
						
						if var_32_1 then
							local var_32_5 = var_32_4:getChildByName("n_reward")
							local var_32_6 = 1
							
							for iter_32_0, iter_32_1 in pairs(var_28_3[iter_28_8].choice_reward) do
								local var_32_7 = var_32_5:getChildByName("n_" .. var_32_6)
								local var_32_8 = tonumber(iter_32_1)
								
								if not get_cocos_refid(var_32_7) then
									break
								end
								
								var_32_7:setVisible(true)
								UIUtil:getRewardIcon(nil, iter_32_0, {
									parent = var_32_7:getChildByName("n_item" .. var_32_6)
								})
								
								local var_32_9 = var_32_7:getChildByName("n_expect")
								
								if var_32_8 > 0 then
									if_set_visible(var_32_9, "n_up", true)
									if_set(var_32_9, "t_count_up", var_32_8)
								elseif var_32_8 < 0 then
									if_set_visible(var_32_9, "n_down", true)
									if_set(var_32_9, "t_count_down", var_32_8)
								end
								
								var_32_6 = var_32_6 + 1
							end
						end
						
						if false then
						end
					else
						var_32_0()
					end
				end)
			end
		end
	end
end

function setup_movie(arg_37_0)
	local var_37_0 = string.split(arg_37_0.movie or "", ",")[1]
	
	print("setup_movie :", var_37_0)
	
	local var_37_1 = getUserLanguage()
	local var_37_2 = getenv("media.quality")
	local var_37_3 = var_37_0
	
	if var_37_1 == "zht" then
		if var_37_0 == "event_01.mp4" then
			var_37_3 = var_37_1 .. "/" .. var_37_2 .. "/" .. var_37_0
			var_37_0 = var_37_1 .. "/" .. var_37_0
		elseif var_37_0 == "event_03.mp4" then
			var_37_3 = getenv("cdn.url") .. "/webpubs/res/cinema/zht/" .. var_37_2 .. "/" .. var_37_0
			var_37_0 = var_37_1 .. "/" .. var_37_0
		end
		
		print("changing zht movie file name", var_37_0, "to", var_37_3)
	end
	
	if not string.starts(var_37_3, "http://") and not string.starts(var_37_3, "https://") then
		var_37_3 = "cinema/" .. var_37_3
	end
	
	if STORY.movie_name == var_37_0 then
		return 
	end
	
	if getenv("patch.status") ~= "complete" then
		PatchGauge:sideShow(false)
	end
	
	local function var_37_4()
		local var_38_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_38_0:setName("curtain")
		var_38_0:setTouchEnabled(true)
		var_38_0:setColor(cc.c3b(0, 0, 0))
		var_38_0:setOpacity(0)
		var_38_0:setPosition((DESIGN_WIDTH - MAX_VIEW_WIDTH) / 2, 0)
		var_38_0:setContentSize(MAX_VIEW_WIDTH, VIEW_HEIGHT)
		
		return var_38_0
	end
	
	local function var_37_5(arg_39_0, arg_39_1)
		if not arg_39_0 then
			return true
		end
		
		if not (arg_39_1 < arg_39_0 - (GAME_STATIC_VARIABLE.movie_playtime_error_margin or 2000)) then
			return true
		end
		
		return false
	end
	
	local var_37_6 = STORY.childs.movie
	local var_37_7
	
	if var_37_3 and var_37_3 ~= "NONE" then
		if string.find(var_37_3, ".mp4") then
			local function var_37_8(arg_40_0)
				if arg_40_0 then
					var_0_7()
				end
			end
			
			var_37_7 = create_movie_clip(var_37_3, false, var_37_8)
			var_37_7.transition_done = false
		end
	else
		var_37_7 = cc.Layer:create()
	end
	
	local var_37_9 = var_37_4()
	local var_37_10 = cc.Node:create()
	
	var_37_10:setName("movie_front")
	var_37_10:setVisible(true)
	var_37_10:addChild(var_37_9)
	var_37_10:addChild(var_37_7)
	var_37_10:setLocalZOrder(999998)
	STORY.layer:addChild(var_37_10)
	STORY.layer:sortAllChildren()
	
	STORY.movie_name = var_37_0
	STORY.childs.movie = var_37_7
	STORY.move_time = 0
	STORY.movie_skip = false
	
	if get_cocos_refid(var_37_6) then
		var_37_6:removeFromParent()
	end
	
	local var_37_11 = TARGET(var_37_9, FADE_IN(600))
	
	if STORY.index == 1 then
		var_37_9:setOpacity(255)
		
		var_37_11 = TARGET(var_37_9, CALL(function()
			print("MOVIE CURTAIN SKIPED BECAUSE STORY INDEX 1")
		end))
	end
	
	local function var_37_12()
		if not var_37_7 then
			return 
		end
		
		var_37_7._play_time = uitick()
		
		var_37_7:setOpacity(0)
		UIAction:Add(SEQ(FADE_IN(CINEMA_FI_TIME), COND_LOOP(DELAY(100), function()
			if not var_37_7 then
				return true
			end
			
			if not var_37_7:isPlaying() then
				return true
			end
			
			local var_43_0 = var_37_7:getDuration()
			
			if var_43_0 > CINEMA_FO_TIME and var_43_0 - (uitick() - var_37_7._play_time) < CINEMA_FO_TIME then
				return true
			end
		end), FADE_OUT(CINEMA_FO_TIME)), var_37_7)
		var_37_7:play()
	end
	
	table.push(arg_37_0.actions, SEQ(var_37_11, CALL(function()
		SoundEngine:setFadeSoundOnStoryBGM(true)
	end), DELAY(300), TARGET(var_37_7, SEQ(CALL(function()
		FPS_BEFORE_PLAY = CURRENT_DISPLAY_FPS
		
		set_scene_fps(30)
		
		var_37_7._start_time = os.time()
	end), CALL(function()
		if var_37_7:isPlaying() then
			return 
		end
		
		if var_37_7.getAvailableRate then
			if var_37_7.ready_to_play then
				var_37_12()
			elseif var_37_7:getAvailableRate() > MIN_DOWNLOAD_RATE then
				var_37_12()
			else
				var_37_7.transition_done = true
			end
		else
			var_37_12()
		end
	end), COND_LOOP(DELAY(200), function()
		local var_47_0 = false
		
		if var_37_7:getState() > 2 then
			var_47_0 = true
		elseif var_37_7:getState() == 1 then
			var_37_7:resume()
		end
		
		local var_47_1 = math.max(math.min(to_n(getenv("time_scale")), 1.2), 0.1)
		
		STORY.move_scale = var_47_1
		STORY.move_time = (STORY.move_time or 0) + cc.Director:getInstance():getDeltaTime() * 1000 / var_47_1
		
		if var_47_0 then
			print("story movie finished!!!", STORY.movie_name, STORY.move_time)
			set_scene_fps(FPS_BEFORE_PLAY)
			step_next({
				force = true
			})
			
			local var_47_2 = STORY.scene or SceneManager:getRunningPopupScene()
			
			SysAction:Add(SEQ(DELAY(100), CALL(function()
				SoundEngine:setFadeSoundOnStoryBGM(false)
			end), TARGET(var_37_10, FADE_OUT(600)), TARGET(var_37_10, REMOVE())), var_47_2)
			
			return true
		end
	end), REMOVE()))))
	Singular:movieStartEvent(var_37_0)
	
	if get_cocos_refid(SoundEngine.START_SOUND_NODE) then
		SoundEngine.START_SOUND_NODE:stop()
		
		SoundEngine.START_SOUND_NODE = nil
	end
end

function setup_bg(arg_49_0)
	local var_49_0 = string.split(arg_49_0.bg or "", ",")
	local var_49_1 = var_49_0[1]
	local var_49_2 = var_49_0[2]
	
	if STORY.bg_name ~= var_49_1 or is_using_story_v2() and STORY.bg_name == var_49_1 then
		local var_49_3 = STORY.childs.bg
		local var_49_4
		local var_49_5
		local var_49_6
		local var_49_7
		local var_49_8
		local var_49_9
		
		if var_49_1 and string.lower(var_49_1) ~= "none" then
			if string.find(var_49_1, ".png") or string.find(var_49_1, ".webp") then
				local var_49_10
				local var_49_11, var_49_12, var_49_13 = Path.split(var_49_1)
				
				if var_49_12 then
					var_49_10 = UIUtil:getIllustPath("story/bg/", var_49_12)
				else
					var_49_10 = UIUtil:getIllustPath("story/bg/", var_49_1)
				end
				
				var_49_7 = get_story_sprite(var_49_10)
			elseif string.starts(var_49_1, "special:") then
				local var_49_14 = string.split(var_49_1, ":")[2]
				
				var_49_7, var_49_6 = UIUtil:getSpecialIllust(var_49_14, nil, true)
				var_49_6.x = VIEW_WIDTH / 2 + VIEW_BASE_LEFT
				var_49_6.y = VIEW_HEIGHT / 2
				var_49_5 = true
			elseif string.find(var_49_1, ".cfx") then
				var_49_7 = CACHE:getEffect(var_49_1, "effect")
				var_49_6 = {
					effect = var_49_7,
					fn = var_49_1,
					x = VIEW_WIDTH / 2 + VIEW_BASE_LEFT,
					y = VIEW_HEIGHT / 2
				}
				var_49_5 = true
			else
				local var_49_15
				
				var_49_7, var_49_15 = FIELD_NEW:create(var_49_1)
				
				var_49_15:setViewPortPosition(DESIGN_WIDTH * 0.5)
				var_49_15:updateViewport()
				
				var_49_4 = true
			end
		else
			var_49_9 = string.lower(var_49_1) == "none"
			var_49_7 = cc.Layer:create()
		end
		
		if not var_49_4 and not var_49_5 then
			local var_49_16 = var_49_7:getContentSize()
			local var_49_17 = math.min(VIEW_HEIGHT / var_49_16.height, VIEW_WIDTH / var_49_16.width)
			
			if not arg_49_0.illust then
				var_49_17 = math.max(VIEW_WIDTH / var_49_16.width, VIEW_HEIGHT / var_49_16.height)
			end
			
			var_49_7:setScale(var_49_17)
			var_49_7:setAnchorPoint(0.5, 0.5)
			var_49_7:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			
			if not var_49_9 then
				local var_49_18 = cc.Sprite:create("img/_black_s.png")
				local var_49_19 = cc.Sprite:create("img/_black_s.png")
				
				var_49_19:setAnchorPoint(0, 0)
				var_49_19:setPosition(var_49_16.width, 0)
				var_49_19:setScale(VIEW_HEIGHT / 16)
				var_49_18:setAnchorPoint(1, 0)
				var_49_18:setPosition(0, 0)
				var_49_18:setScale(VIEW_HEIGHT / 16)
				var_49_7:addChild(var_49_19)
				var_49_7:addChild(var_49_18)
				
				if not get_cocos_refid(STORY.childs.black_bg) and arg_49_0.illust then
					local var_49_20 = cc.Sprite:create("img/_black_s.png")
					
					var_49_20:setAnchorPoint(0.5, 0.5)
					var_49_20:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
					var_49_20:setScale(VIEW_HEIGHT / 8)
					STORY.layer:getChildByName("n_bg"):addChild(var_49_20)
					
					STORY.childs.black_bg = var_49_20
				end
			end
		end
		
		if var_49_5 then
			var_49_7:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
		end
		
		if arg_49_0.illust then
			STORY.is_illust_show = true
		else
			STORY.is_illust_show = false
			
			setup_talk_voice_icon(arg_49_0)
		end
		
		if get_cocos_refid(STORY.childs.black_bg) and not arg_49_0.illust then
			STORY.childs.black_bg:removeFromParent()
		end
		
		var_49_7:setVisible(false)
		var_49_7:setLocalZOrder(10)
		
		local var_49_21 = STORY.layer:getChildByName("n_bg")
		
		if var_49_5 and var_49_6 then
			local var_49_22 = ccui.Layout:create()
			
			var_49_22:setContentSize(1580, 720)
			var_49_22:setAnchorPoint(0.5, 0.5)
			var_49_22:setClippingEnabled(true)
			var_49_22:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			var_49_21:addChild(var_49_22)
			
			var_49_6.x = 790
			var_49_6.y = 360
			var_49_6.layer = var_49_22
			
			EffectManager:EffectPlay(var_49_6)
		else
			var_49_21:addChild(var_49_7)
		end
		
		STORY.layer:sortAllChildren()
		
		STORY.bg_name = var_49_1
		STORY.childs.bg = var_49_7
		
		if not var_49_9 then
			BattleField:overlay(var_49_7)
		end
		
		if var_49_9 and STORY.on_bg_empty then
			STORY.on_bg_empty()
		end
		
		if var_49_3 then
			var_49_3:removeFromParent()
		end
		
		if var_49_2 then
			var_49_7:setOpacity(0)
			table.push(arg_49_0.actions, TARGET(var_49_7, SEQ(SHOW(true), FADE_IN(to_n(var_49_2)))))
			table.push(arg_49_0.actions, TARGET(var_49_3, SEQ(DELAY(var_49_2), REMOVE())))
		else
			table.push(arg_49_0.actions, TARGET(var_49_7, SHOW(true)))
		end
		
		arg_49_0:proc_obj_effs(var_49_7, false, true)
	end
end

function clear_character(arg_50_0)
	if not get_cocos_refid(STORY.childs[arg_50_0]) then
		return 
	end
	
	if STORY.talker_id == STORY.chars[arg_50_0].id then
		STORY.talker_id = nil
	end
	
	STORY.childs[arg_50_0]:removeFromParent()
	
	STORY.chars[arg_50_0] = nil
	STORY.childs[arg_50_0] = nil
end

function set_character_face(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_1.portrait
	local var_51_1 = var_51_0:getChildByName("face")
	
	if arg_51_0.face then
		if var_51_1 then
			var_51_0:removeChild(var_51_1)
		end
		
		if arg_51_2.image then
			local var_51_2, var_51_3 = StoryFace:getDBFace(arg_51_0.face)
			
			if not arg_51_2.is_ani and var_51_2 then
				local var_51_4 = cc.Sprite:create("face/" .. arg_51_2.image .. "_fu" .. var_51_2)
				
				if var_51_4 then
					local var_51_5 = var_51_0:getContentSize()
					
					var_51_4:setLocalZOrder(9999)
					var_51_4:setName("face")
					var_51_4:setAnchorPoint(0.5, 1)
					var_51_4:setPosition(var_51_5.width / 2, var_51_5.height)
					var_51_4:setColor(var_51_0:getColor())
					var_51_0:addChild(var_51_4)
				end
			elseif arg_51_2.is_ani and var_51_3 and arg_51_2.id == arg_51_0.talker then
				var_51_0:setSkin(var_51_3)
			end
		end
	end
end

function set_character_position(arg_52_0, arg_52_1)
	if arg_52_0 == nil then
		return 
	end
	
	arg_52_0 = arg_52_0.portrait
	
	if arg_52_1 == "left" then
		local var_52_0 = arg_52_0:getScaleX()
		
		if var_0_8 and var_52_0 > 0 then
			arg_52_0:setScaleX(0 - var_52_0)
			arg_52_0:setAnchorPoint(0.5, var_0_14)
		else
			arg_52_0:setAnchorPoint(0.5, var_0_14)
		end
		
		arg_52_0:setPosition(DESIGN_WIDTH * 0.2, var_0_15)
	elseif arg_52_1 == "right" then
		arg_52_0:setAnchorPoint(0.5, var_0_14)
		arg_52_0:setPosition(DESIGN_WIDTH * 0.8, var_0_15)
	elseif arg_52_1 == "mid" then
		arg_52_0:setAnchorPoint(0.5, var_0_14)
		arg_52_0:setPosition(DESIGN_WIDTH / 2, var_0_15)
	end
end

function set_character(arg_53_0, arg_53_1, arg_53_2)
	if not STORY then
		Log.e("set_character", "STORY is nil, sub_id: ", arg_53_2 and arg_53_2.sub_id)
	end
	
	if not STORY.chars then
		Log.e("set_character", "STORY.chars is nil, sub_id: ", arg_53_2 and arg_53_2.sub_id)
	end
	
	if not STORY.childs then
		Log.e("set_character", "STORY.childs is nil, sub_id: ", arg_53_2 and arg_53_2.sub_id)
	end
	
	if STORY.chars[arg_53_0] and STORY.chars[arg_53_0].id == arg_53_1 then
		set_character_position(STORY.childs[arg_53_0], arg_53_0)
		
		return 
	end
	
	if STORY.childs[arg_53_0] ~= nil then
		clear_character(arg_53_0)
	end
	
	if not arg_53_1 then
		return 
	end
	
	arg_53_1 = string.split(arg_53_1, ",")[1]
	
	local var_53_0 = DB("story_character", arg_53_1, "image")
	
	if var_53_0 and var_53_0 ~= "" then
		local var_53_1 = "face/" .. var_53_0
		
		if string.ends(var_53_0, "_fu.png") then
			var_53_0 = string.sub(var_53_0, 1, -8)
		end
		
		local var_53_2, var_53_3 = UIUtil:getPortraitAni(var_53_0)
		local var_53_4 = cc.Node:create()
		
		var_53_4:setCascadeOpacityEnabled(true)
		var_53_4:setCascadeColorEnabled(true)
		
		var_53_4.portrait = var_53_2
		
		var_53_4:addChild(var_53_2)
		
		STORY.chars[arg_53_0] = {
			id = arg_53_1,
			obj = var_53_4,
			pos = arg_53_0,
			image = var_53_0,
			is_ani = var_53_3
		}
		STORY.childs[arg_53_0] = var_53_4
		
		var_53_4:setLocalZOrder(20)
		var_53_2:setScale(var_0_13 * var_0_12)
		var_53_2:setColor(var_0_10)
		var_53_2:setCascadeOpacityEnabled(true)
		set_character_position(var_53_4, arg_53_0)
		set_character_face(arg_53_2, STORY.childs[arg_53_0], STORY.chars[arg_53_0])
		STORY.layer:getChildByName("n_portrait"):addChild(var_53_4)
	end
	
	return true
end

local function var_0_21(arg_54_0)
	for iter_54_0, iter_54_1 in pairs(STORY.chars) do
		if iter_54_1.id == arg_54_0 then
			return iter_54_1
		end
	end
end

local function var_0_22(arg_55_0, arg_55_1)
	local var_55_0 = var_0_21(arg_55_1)
	
	if not var_55_0 then
		return 
	end
	
	local var_55_1 = var_0_13
	
	if var_0_8 and var_55_0.pos == "left" then
		var_55_1 = 0 - var_0_13
	end
	
	local var_55_2 = var_55_1 * var_0_12
	local var_55_3 = var_55_0.obj.portrait:getChildByName("face")
	
	table.push(arg_55_0.actions, SPAWN(TARGET(var_55_0.obj, ZORDER(20)), TARGET(var_55_0.obj.portrait, LOG(SPAWN(FIX_MODEL_FROM_COLOR(100, var_0_10), SCALEX(100, var_55_0.obj.portrait:getScaleX(), var_55_2), SCALEY(100, var_55_0.obj.portrait:getScaleY(), var_0_13 * var_0_12)), 20)), TARGET(var_55_3, LOG(COLOR(100, var_0_10), 20))))
end

local function var_0_23(arg_56_0, arg_56_1)
	local var_56_0 = var_0_21(arg_56_1)
	
	if not var_56_0 then
		return 
	end
	
	local var_56_1 = var_0_13
	
	if var_0_8 and var_56_0.pos == "left" then
		var_56_1 = 0 - var_0_13
	end
	
	local var_56_2 = var_56_0.obj.portrait:getChildByName("face")
	
	table.push(arg_56_0.actions, SPAWN(TARGET(var_56_0.obj, ZORDER(21)), TARGET(var_56_0.obj.portrait, LOG(SPAWN(FIX_MODEL_FROM_COLOR(100, var_0_11), SCALEX(100, var_56_0.obj.portrait:getScaleX(), var_56_1), SCALEY(100, var_56_0.obj.portrait:getScaleY(), var_0_13)), 20)), TARGET(var_56_2, LOG(COLOR(100, var_0_11), 20))))
end

function setup_talk_voice_icon(arg_57_0)
	if not arg_57_0 or not get_cocos_refid(STORY.childs.n_talk_clear) then
		return 0
	end
	
	local var_57_0 = 0
	
	if arg_57_0.balloon == "clear" or arg_57_0.balloon == "clear2" then
		local var_57_1 = STORY.childs.n_talk_clear:getChildByName("txt_name")
		
		if get_cocos_refid(var_57_1) and not var_57_1.origin_x then
			var_57_1.origin_x = var_57_1:getPositionX()
		end
		
		if arg_57_0.voice and (arg_57_0.illust or STORY.is_illust_show) then
			if_set_visible(STORY.childs.n_talk_clear, "icon_sound", true)
			
			if get_cocos_refid(var_57_1) then
				var_57_0 = 36
				
				var_57_1:setPositionX(var_57_1.origin_x + var_57_0)
			end
		else
			if_set_visible(STORY.childs.n_talk_clear, "icon_sound", false)
			
			if get_cocos_refid(var_57_1) then
				var_57_1:setPositionX(var_57_1.origin_x)
			end
		end
	end
	
	return var_57_0
end

function setup_talk(arg_58_0)
	local var_58_0 = arg_58_0.talker or STORY.talker_id
	local var_58_1 = var_0_21(var_58_0)
	local var_58_2
	
	if var_58_1 and STORY.talker_id ~= var_58_0 then
		var_58_2 = STORY.talker_id
	end
	
	STORY.talker_id = var_58_0
	
	local var_58_3 = arg_58_0.text
	
	if var_58_3 then
		local var_58_4
		
		if arg_58_0.balloon == "mono" then
			var_58_4 = STORY.childs.n_talk_monologue
		elseif arg_58_0.balloon == "caption" or arg_58_0.balloon == "caption2" then
			var_58_4 = STORY.childs.n_talk_caption
		elseif arg_58_0.balloon == "clear" or arg_58_0.balloon == "clear2" then
			var_58_4 = STORY.childs.n_talk_clear
		else
			var_58_4 = STORY.childs.n_talk
		end
		
		local var_58_5 = var_58_4:getChildByName("txt_info")
		
		if arg_58_0.balloon == "clear" then
			var_58_5:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
		elseif arg_58_0.balloon == "clear2" then
			var_58_5:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		end
		
		STORY.childs.n_talk:setVisible(false)
		STORY.childs.n_talk_monologue:setVisible(false)
		STORY.childs.n_talk_caption:setVisible(false)
		STORY.childs.n_talk_clear:setVisible(false)
		
		local var_58_6 = DB("story_character", arg_58_0.name, "name") or DB("story_character", arg_58_0.talker, "name") or ""
		local var_58_7 = T(var_58_6)
		
		if_set(var_58_4, "txt_name", var_58_7)
		
		if arg_58_0.talker_nickname then
			if_set(var_58_4, "txt_alias", arg_58_0.talker_nickname)
		end
		
		local var_58_8 = setup_talk_voice_icon(arg_58_0)
		
		if_set_visible(var_58_4, "txt_alias", arg_58_0.talker_nickname ~= nil)
		if_set_visible(var_58_4, "title_bg", var_58_7 ~= nil and var_58_7 ~= " " and var_58_7 ~= "")
		if_set_width_from(var_58_4, "title_bg", "txt_name", {
			add = 100 + var_58_8,
			min = 353 + var_58_8
		})
		STORY.childs.cursor:setVisible(false)
		
		if arg_58_0.size == "b" then
			var_58_5:setScale(var_58_5.original_scale * 1.2)
			var_58_5:setContentSize({
				width = var_58_5.original_size.width * 0.82,
				height = var_58_5.original_size.height
			})
		elseif arg_58_0.size == "s" then
			var_58_5:setScale(var_58_5.original_scale * 0.83)
			var_58_5:setContentSize({
				width = var_58_5.original_size.width * 1.2,
				height = var_58_5.original_size.height
			})
		else
			var_58_5:setScale(var_58_5.original_scale)
			var_58_5:setContentSize({
				width = var_58_5.original_size.width + 10,
				height = var_58_5.original_size.height
			})
		end
		
		UIUserData:resetMultiScalePivot(var_58_5)
		
		if arg_58_0:check_eff("이탤릭") then
			var_58_5:setSkewX(10)
		else
			var_58_5:setSkewX(0)
		end
		
		local var_58_9 = 15
		
		if arg_58_0.balloon == "caption" then
			var_58_9 = 50
		elseif arg_58_0.balloon == "caption2" then
			var_58_9 = 1
		elseif arg_58_0.balloon == "clear2" then
			var_58_9 = 1
		end
		
		if isEULanguage() then
			var_58_5:setVisible(false)
			table.push(arg_58_0.actions, TARGET(var_58_5, SPAWN(TARGET(var_58_4, SHOW(true)), SHOW(true), STORY_TEXT(var_58_3, nil, var_58_9, true))))
		else
			var_58_5:setVisible(false)
			table.push(arg_58_0.actions, TARGET(var_58_5, SPAWN(TARGET(var_58_4, SHOW(true)), SHOW(true), TEXT(var_58_3, nil, var_58_9, true))))
		end
		
		STORY.current_text_control = var_58_5
		STORY.current_n_talk = var_58_4
	else
		STORY.childs.n_talk:setVisible(false)
		STORY.childs.n_talk_monologue:setVisible(false)
		STORY.childs.n_talk_caption:setVisible(false)
		STORY.childs.n_talk_clear:setVisible(false)
		table.push(arg_58_0.actions, DELAY(1000))
	end
	
	if arg_58_0.portrait_control == "모두활성" then
		for iter_58_0, iter_58_1 in pairs(STORY.chars) do
			var_0_23(arg_58_0, iter_58_1.id)
		end
	elseif arg_58_0.portrait_control == "모두비활성" then
		for iter_58_2, iter_58_3 in pairs(STORY.chars) do
			var_0_22(arg_58_0, iter_58_3.id)
		end
	elseif arg_58_0.portrait_control == nil then
	else
		error("portrait_control를 확인해주세요. DB에는 " .. tostring(arg_58_0.portrait_control) .. " 라고 적혀있었습니다.")
	end
	
	if var_58_1 then
		arg_58_0:proc_obj_effs(STORY.childs[var_58_1.pos], var_58_1.pos == "left")
		set_character_face(arg_58_0, STORY.childs[var_58_1.pos], STORY.chars[var_58_1.pos])
		set_character_position(STORY.childs[var_58_1.pos], var_58_1.pos)
		
		if arg_58_0.portrait_control == nil then
			if STORY.last_portrait_control then
				for iter_58_4, iter_58_5 in pairs(STORY.chars) do
					if var_58_0 ~= iter_58_5.id and var_58_2 ~= iter_58_5.id then
						var_0_22(arg_58_0, iter_58_5.id)
					end
				end
			end
			
			var_0_22(arg_58_0, var_58_2)
			var_0_23(arg_58_0, var_58_0)
		end
	end
	
	STORY.last_portrait_control = arg_58_0.portrait_control
end

function setup_pre_global_effs(arg_59_0)
	setup_vignetting(arg_59_0)
	STORY.childs.curtain:setVisible(true)
	
	if arg_59_0:check_eff("전체페이드인아웃") then
		STORY.childs.curtain:setColor(cc.c3b(0, 0, 0))
	elseif arg_59_0:check_eff("전체페이드아웃R") then
		STORY.childs.curtain:setColor(cc.c3b(200, 0, 0))
		
		if IS_PUBLISHER_ZLONG then
			STORY.childs.curtain:setColor(cc.c3b(240, 146, 50))
		end
	elseif arg_59_0:check_eff("전체페이드아웃W") then
		STORY.childs.curtain:setColor(cc.c3b(255, 255, 255))
	elseif arg_59_0:check_eff("전체페이드아웃") then
		STORY.childs.curtain:setColor(cc.c3b(0, 0, 0))
	elseif arg_59_0:check_eff("전체페이드인R") then
		STORY.childs.curtain:setColor(cc.c3b(200, 0, 0))
		
		if IS_PUBLISHER_ZLONG then
			STORY.childs.curtain:setColor(cc.c3b(240, 146, 50))
		end
		
		STORY.childs.curtain:setOpacity(255)
	elseif arg_59_0:check_eff("전체페이드인W") then
		STORY.childs.curtain:setColor(cc.c3b(255, 255, 255))
		STORY.childs.curtain:setOpacity(255)
	elseif arg_59_0:check_eff("전체페이드인") then
		STORY.childs.curtain:setColor(cc.c3b(0, 0, 0))
		STORY.childs.curtain:setOpacity(255)
	elseif arg_59_0:check_eff("@BATTLE_START") then
		STORY.childs.curtain:setVisible(false)
		STORY.layer:setVisible(false)
	else
		STORY.childs.curtain:setVisible(false)
	end
end

function load_story_skill_act_data(arg_60_0)
	return (DBT("story_skill_act", arg_60_0, {
		"id",
		"bg",
		"reverse_direction",
		"player1",
		"player2",
		"player3",
		"player4",
		"skin1",
		"skin2",
		"skin3",
		"skin4",
		"player_slot_number",
		"skill_number",
		"back1",
		"back2",
		"back3",
		"front1",
		"front2",
		"front3",
		"target_slot_number",
		"hit_eff_off"
	}))
end

function load_skill_eff_data(arg_61_0)
	if not arg_61_0 then
		return 
	end
	
	if arg_61_0 == "test" then
		arg_61_0 = {
			player1 = "",
			back2 = "m9201",
			skill_number = 3,
			front1 = "m9201",
			front2 = "m9201",
			target_slot_number = "back3",
			reverse_direction = "y",
			back3 = "m9201",
			player2 = "c2079",
			front3 = "m9201",
			player4 = "",
			back1 = "m9201",
			player3 = "",
			hit_eff_off = "y",
			player_slot_number = 2,
			bg = "grw_tent"
		}
	end
	
	if get_cocos_refid(STORY.skip_popup) then
		STORY.skip_popup:removeFromParent()
		
		STORY.skip_popup = nil
	end
	
	local var_61_0 = {}
	local var_61_1 = {}
	
	for iter_61_0 = 1, 4 do
		local var_61_2 = "player" .. iter_61_0
		local var_61_3 = "skin" .. iter_61_0
		
		if arg_61_0[var_61_2] ~= "" then
			var_61_0[iter_61_0] = arg_61_0[var_61_2]
			var_61_1[iter_61_0] = arg_61_0[var_61_3]
		end
	end
	
	local var_61_4 = {}
	local var_61_5 = {}
	
	for iter_61_1 = 1, 3 do
		local var_61_6 = "front" .. iter_61_1
		local var_61_7 = "back" .. iter_61_1
		
		var_61_4[iter_61_1] = arg_61_0[var_61_6]
		var_61_5[iter_61_1] = arg_61_0[var_61_7]
	end
	
	local var_61_8 = {
		var_61_4[1],
		var_61_4[2],
		var_61_4[3],
		var_61_5[1],
		var_61_5[2],
		var_61_5[3]
	}
	
	CharPreviewViewer:Init(STORY.layer:getParent(), arg_61_0.bg, arg_61_0.reverse_direction == "y", arg_61_0.hit_eff_off == "y")
	
	PRV_TIME_SCALE = getenv("time_scale")
	
	setenv("time_scale", 1.2)
	CharPreviewViewer:MakeTeamForStory(var_61_0, FRIEND, var_61_1)
	CharPreviewViewer:MakeTeam(var_61_8, ENEMY)
	CharPreviewViewer:MakeLayouts()
	
	local var_61_9 = 0
	
	if string.find(arg_61_0.target_slot_number, "back") then
		var_61_9 = 3
	end
	
	local var_61_10 = to_n(string.sub(arg_61_0.target_slot_number, -1, -1))
	
	CharPreviewViewer:UseSkill(arg_61_0.skill_number, true, arg_61_0.player_slot_number, var_61_9 + var_61_10)
end

function screen_attack_eff(arg_62_0, arg_62_1, arg_62_2)
	table.push(arg_62_0.actions, TARGET(STORY.layer, SEQ(DELAY(arg_62_0:eff_opt(arg_62_1, 0)), CALL(function()
		EffectManager:Play({
			z = 999999,
			y = 360,
			delay = 0,
			x = 640,
			fn = arg_62_2,
			layer = STORY.childs.dlg
		})
	end))))
end

function screen_focus_eff(arg_64_0, arg_64_1, arg_64_2)
	table.push(arg_64_0.actions, TARGET(STORY.layer, SEQ(DELAY(arg_64_0:eff_opt(arg_64_1, 0)), CALL(function()
		EffectManager:Play({
			z = 999999,
			y = 360,
			delay = 0,
			x = 640,
			fn = arg_64_2,
			layer = STORY.layer:findChildByName("n_portrait")
		})
	end))))
end

function setup_global_effs(arg_66_0)
	if arg_66_0:check_eff("전체페이드인아웃") then
	elseif arg_66_0:check_eff("전체페이드아웃R") then
		table.push(arg_66_0.actions, TARGET(STORY.childs.curtain, FADE_IN(arg_66_0:eff_opt("전체페이드아웃R", 1500))))
	elseif arg_66_0:check_eff("전체페이드아웃W") then
		table.push(arg_66_0.actions, TARGET(STORY.childs.curtain, FADE_IN(arg_66_0:eff_opt("전체페이드아웃W", 1500))))
	elseif arg_66_0:check_eff("전체페이드아웃") then
		table.push(arg_66_0.actions, TARGET(STORY.childs.curtain, FADE_IN(arg_66_0:eff_opt("전체페이드아웃", 1500))))
	elseif arg_66_0:check_eff("전체페이드인R") then
		table.push(arg_66_0.actions, TARGET(STORY.childs.curtain, FADE_OUT(arg_66_0:eff_opt("전체페이드인R", 1500), true)))
	elseif arg_66_0:check_eff("전체페이드인W") then
		table.push(arg_66_0.actions, TARGET(STORY.childs.curtain, FADE_OUT(arg_66_0:eff_opt("전체페이드인W", 1500), true)))
	elseif arg_66_0:check_eff("전체페이드인") then
		table.push(arg_66_0.actions, TARGET(STORY.childs.curtain, FADE_OUT(arg_66_0:eff_opt("전체페이드인", 1500), true)))
	elseif arg_66_0:check_eff("화면공격1") then
		screen_attack_eff(arg_66_0, "화면공격1", "sn_attack_01.cfx")
	elseif arg_66_0:check_eff("화면공격2") then
		screen_attack_eff(arg_66_0, "화면공격2", "sn_attack_02.cfx")
	elseif arg_66_0:check_eff("집중선W") then
		screen_focus_eff(arg_66_0, "집중선W", "sn_converging_W.cfx")
	elseif arg_66_0:check_eff("집중선") then
		screen_focus_eff(arg_66_0, "집중선", "sn_converging.cfx")
	elseif arg_66_0:check_eff("스킬") then
		local var_66_0 = arg_66_0.skill_act
		
		STORY.fade_wait = true
		STORY.next_cut_wait = true
		
		if SceneManager:getCurrentSceneName() ~= "battle" then
			StageStateManager:reset()
			BattleAction:RemoveAll()
		end
		
		UIAction:Add(SEQ(TARGET(STORY.layer, FADE_OUT(500, true)), CALL(function()
			load_skill_eff_data(load_story_skill_act_data(var_66_0))
		end), COND_LOOP(DELAY(10), function()
			if not Battle:isPlayingBattleAction() then
				return true
			end
		end), CALL(function()
			STORY.next_cut_wait = nil
			STORY.fade_wait = nil
		end), CALL(function()
			STORY.prev_story_tick = systick()
			
			step_next({
				force = true
			})
			STORY.layer:setOpacity(255)
			STORY.layer:setVisible(true)
		end), CALL(function()
			CharPreviewViewer:Destroy()
			setenv("time_scale", PRV_TIME_SCALE)
		end)), STORY, "block")
	elseif STORY.childs.title then
		local var_66_1 = STORY.childs.title:findChildByName("title_black")
		
		if STORY.request_white_title then
			var_66_1:setBackGroundColor(cc.c3b(255, 255, 255))
			
			STORY.request_white_title = nil
		else
			var_66_1:setBackGroundColor(cc.c3b(0, 0, 0))
		end
		
		table.push(arg_66_0.actions, TARGET(STORY.childs.title, FADE_OUT(500, true)))
		
		STORY.childs.title = nil
	end
	
	if arg_66_0:check_eff("전체흔들기") then
		table.push(arg_66_0.actions, TARGET(STORY.layer, SHAKE_UI(arg_66_0:eff_opt("전체흔들기", 1500), 20, true)))
	end
	
	if arg_66_0:check_eff("전체캐릭터흔들기") then
		table.push(arg_66_0.actions, TARGET(STORY.layer:findChildByName("n_portrait"), SHAKE_UI(arg_66_0:eff_opt("전체캐릭터흔들기", 1500), 20, true)))
	end
end

function setup_vignetting(arg_72_0)
	if arg_72_0:check_eff("회상") then
		STORY.childs.flashback:setColor(cc.c3b(112, 56, 23))
		STORY.childs.flashback:setOpacity(153)
		STORY.childs.flashback:setVisible(true)
		STORY.childs.vignetting:setVisible(false)
	elseif arg_72_0:check_eff("환상") then
		STORY.childs.vignetting:setColor(cc.c3b(255, 255, 255))
		STORY.childs.vignetting:setOpacity(153)
		STORY.childs.vignetting:setVisible(true)
		STORY.childs.flashback:setVisible(false)
	else
		STORY.childs.flashback:setVisible(false)
		STORY.childs.vignetting:setVisible(false)
	end
end

function setup_location(arg_73_0)
	STORY.layer:removeChildByName("location")
	
	if arg_73_0.text == "LOCATION_CLEAR" then
		return 
	end
	
	local var_73_0 = ccui.Text:create()
	
	var_73_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	var_73_0:setFontName("font/daum.ttf")
	var_73_0:setFontSize(50)
	var_73_0:enableOutline(cc.c3b(0, 0, 0), 1)
	var_73_0:setScale(0.7)
	var_73_0:setPosition(30, DESIGN_HEIGHT - 20)
	var_73_0:setLocalZOrder(999996)
	var_73_0:setAnchorPoint(0, 1)
	var_73_0:setName("location")
	STORY.layer:addChild(var_73_0)
	STORY.layer:sortAllChildren()
	table.push(arg_73_0.actions, CALL(function()
		SysAction:Add(SEQ(TEXT(arg_73_0.text, true, 50, true), DELAY(2000), FADE_OUT(500), REMOVE()), var_73_0)
	end))
end

function setup_image(arg_75_0)
	if arg_75_0.image then
		if arg_75_0.image == "empty" then
			if STORY.childs.image ~= nil then
				STORY.childs.image:removeFromParent()
				
				STORY.childs.image = nil
			end
			
			STORY.last_image = nil
		elseif STORY.last_image ~= arg_75_0.image then
			if STORY.childs.image ~= nil then
				STORY.childs.image:removeFromParent()
				
				STORY.childs.image = nil
			end
			
			STORY.last_image = arg_75_0.image
			
			local var_75_0 = "story/image/" .. arg_75_0.image
			local var_75_1 = get_story_sprite(var_75_0)
			
			STORY.childs.image = var_75_1
			
			local var_75_2 = 25
			
			if arg_75_0.add_pos == "after" then
				var_75_2 = 5
			end
			
			var_75_1:setLocalZOrder(var_75_2)
			
			if var_75_1:getContentSize().width == DESIGN_WIDTH then
				var_75_1:setScaleX(VIEW_WIDTH_RATIO)
			end
			
			var_75_1:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.6)
			var_75_1:setAnchorPoint(0.5, 0.5)
			STORY.layer:getChildByName("n_portrait"):addChild(var_75_1)
			arg_75_0:proc_obj_effs(STORY.childs.image)
		end
	end
end

function set_position_top_right_buttons(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0:findChildByName("n_skip")
	local var_76_1 = var_76_0:findChildByName("t_skip")
	local var_76_2 = arg_76_0:findChildByName("n_return_dict")
	local var_76_3 = arg_76_0:getChildByName("n_auto")
	local var_76_4 = var_76_0:getPositionX()
	local var_76_5 = var_76_2:getPositionX()
	local var_76_6 = var_76_2:getChildByName("bar__"):getPositionX()
	local var_76_7 = var_76_1:getPositionX()
	local var_76_8 = var_76_1:getContentSize()
	local var_76_9 = var_76_5 + var_76_6 - (var_76_4 + var_76_7 - var_76_8.width)
	
	if var_76_9 > 0 then
		var_76_2:setPositionX(var_76_2:getPositionX() - (var_76_9 + 34))
		var_76_3:setPositionX(var_76_3:getPositionX() - (var_76_9 + 34))
	end
	
	if arg_76_1 then
		var_76_2:setPositionX(var_76_2:getPositionX() + 90)
		var_76_3:setPositionX(var_76_3:getPositionX() + 93)
		if_set_visible(var_76_2, "icon_esc", false)
		if_set_visible(arg_76_0, "n_pause", true)
	end
end

local function var_0_24()
	if STORY.is_moonlight_th then
		return 
	end
	
	if STORY_ACTION_MANAGER:canUseBackBtn() then
		return 
	end
	
	if not is_using_story_v2() and STORY.cursor_hide then
		return 
	end
	
	if CharPreviewViewer:isActive() then
		return 
	end
	
	if is_using_story_v2() and not STORY_ACTION_MANAGER:_canSkip() then
		return 
	end
	
	return true
end

local function var_0_25()
	local var_78_0 = false or get_cocos_refid((STORY.childs or {}).choice_ui) or (STORY.cut_opts or {}).select_wait
	
	STORY.double_speed = nil
	
	if var_78_0 then
		return 
	end
	
	local var_78_1 = STORY.current_talker
	
	if UIAction:Find("skip_block") then
		return 
	end
	
	if not STORY_ACTION_MANAGER:isStartAction() and #STORY.story <= var_0_1 then
		stop_story(true)
	elseif not get_cocos_refid(STORY.skip_popup) then
		STORY_ACTION_MANAGER:setAllModelAnim(true)
		
		STORY.skip_popup = Dialog:msgBox(T("ui_story_skip_check"), {
			yesno = true,
			yes_text = T("unit_sell_yes"),
			no_text = T("unit_sell_no"),
			cancel_handler = function()
				STORY_ACTION_MANAGER:setAllModelAnim(false)
			end,
			handler = function()
				if var_0_0 then
					Dialog.MsgBoxHandlers[STORY.skip_popup] = nil
					
					if get_cocos_refid(STORY.chapter_intro_eff) then
						if get_cocos_refid(STORY.chapter_intro_eff.sd) and STORY.chapter_intro_eff.sd.stop then
							STORY.chapter_intro_eff.sd:stop()
						end
						
						STORY.chapter_intro_eff:removeFromParent()
						
						STORY.childs.title = nil
					end
					
					STORY_ACTION_MANAGER:skipStoryAction()
					STORY_ACTION_MANAGER:setAllModelAnim(false)
					stop_story(true)
				end
			end
		})
	end
end

function start_story()
	if not StoryViewer:isInited() then
		StoryViewer:init()
	end
	
	StoryViewer:procNext()
	StoryLogger:init(STORY.story_id)
	
	if not STORY.play_on_collection then
		Singular:storyStartEvent(STORY.story_id)
		
		if STORY.story_id == "CH01_001_1_new" then
			Zlong:gameEventLog(ZLONG_LOG_CODE.STORY_1_1_START)
		end
	end
	
	local var_81_0 = load_dlg("story", true, "wnd")
	
	if is_using_story_v2() then
		var_81_0:setName("story_v2")
	end
	
	var_81_0:setScale(1)
	STORY.layer:addChild(var_81_0)
	
	STORY.childs.dlg = var_81_0
	STORY.childs.n_talk = var_81_0:getChildByName("n_talk")
	STORY.childs.n_talk_monologue = var_81_0:getChildByName("n_talk_monologue")
	STORY.childs.n_talk_caption = var_81_0:getChildByName("n_talk_caption")
	STORY.childs.n_talk_clear = var_81_0:getChildByName("n_talk_clear")
	
	upgradeLabelToRichLabel(STORY.childs.n_talk, "txt_info", true)
	upgradeLabelToRichLabel(STORY.childs.n_talk_monologue, "txt_info", true)
	
	STORY.childs.n_talk:getChildByName("txt_info").original_size = STORY.childs.n_talk:getChildByName("txt_info"):getContentSize()
	STORY.childs.n_talk_monologue:getChildByName("txt_info").original_size = STORY.childs.n_talk_monologue:getChildByName("txt_info"):getContentSize()
	STORY.childs.n_talk_caption:getChildByName("txt_info").original_size = STORY.childs.n_talk_caption:getChildByName("txt_info"):getContentSize()
	STORY.childs.n_talk_clear:getChildByName("txt_info").original_size = STORY.childs.n_talk_clear:getChildByName("txt_info"):getContentSize()
	STORY.childs.n_talk:getChildByName("txt_info").original_scale = STORY.childs.n_talk:getChildByName("txt_info"):getScaleX()
	STORY.childs.n_talk_monologue:getChildByName("txt_info").original_scale = STORY.childs.n_talk_monologue:getChildByName("txt_info"):getScaleX()
	STORY.childs.n_talk_caption:getChildByName("txt_info").original_scale = STORY.childs.n_talk_caption:getChildByName("txt_info"):getScaleX()
	STORY.childs.n_talk_clear:getChildByName("txt_info").original_scale = STORY.childs.n_talk_clear:getChildByName("txt_info"):getScaleX()
	STORY.childs.vignetting = var_81_0:getChildByName("vignetting")
	
	STORY.childs.vignetting:setVisible(false)
	
	STORY.childs.flashback = var_81_0:getChildByName("flashback")
	
	STORY.childs.flashback:setVisible(false)
	
	STORY.childs.cursor = var_81_0:getChildByName("n_cursor")
	
	STORY.childs.cursor:setVisible(false)
	
	local var_81_1 = getSprite("img/_white_s.png")
	local var_81_2 = var_81_1:getContentSize()
	
	var_81_1:setOpacity(0)
	var_81_1:setScale(DESIGN_WIDTH / var_81_2.width * 2, DESIGN_HEIGHT / var_81_2.height * 2)
	var_81_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_81_1:setLocalZOrder(999995)
	
	STORY.childs.curtain = var_81_1
	
	STORY.layer:addChild(var_81_1)
	if_set_visible(var_81_0, "n_return_dict", true)
	if_set_visible(var_81_0, "btn_return_dict", STORY.play_on_collection)
	if_set_visible(var_81_0, "icon_esc", STORY.play_on_collection)
	
	if not SAVE:isTutorialFinished() then
		if_set_visible(var_81_0, "n_return_dict", false)
		if_set_visible(var_81_0, "btn_return_dict", false)
		if_set_visible(var_81_0, "icon_esc", false)
	end
	
	set_position_top_right_buttons(var_81_0, STORY.is_moonlight_th)
	
	local var_81_3 = var_81_0:findChildByName("n_skip")
	local var_81_4 = var_81_3:findChildByName("t_skip")
	local var_81_5 = var_81_3:findChildByName("btn_forward")
	
	var_81_5:setContentSize(var_81_4:getContentSize().width + 60, var_81_5:getContentSize().height)
	var_81_5:addTouchEventListener(function(arg_82_0, arg_82_1)
		local var_82_0 = arg_82_0:getName()
		
		if not var_0_24() then
			return 
		end
		
		if arg_82_1 == ccui.TouchEventType.ended then
			var_0_25()
		elseif arg_82_1 == ccui.TouchEventType.began then
			STORY.double_speed = true
			STORY.prev_story_tick = systick()
			STORY.finish_time = nil
		elseif arg_82_1 == ccui.TouchEventType.canceled then
			STORY.double_speed = nil
		end
	end)
	var_81_3:ejectFromParent()
	
	local var_81_6 = cc.Node:create()
	
	var_81_6:setName("skip_front")
	var_81_6:addChild(var_81_3)
	var_81_6:setLocalZOrder(999994)
	STORY.layer:addChild(var_81_6)
	STORY.layer:sortAllChildren()
	
	STORY.childs.n_skip = var_81_3
	
	STORY.childs.n_skip:setVisible(false)
	var_81_0:findChildByName("title_black"):addTouchEventListener(function(arg_83_0, arg_83_1)
		if arg_83_1 == ccui.TouchEventType.ended then
			var_0_4(true, true)
			
			STORY.skip_story_tick = systick()
		end
	end)
	TutorialGuide:procGuide("ije001_object")
	
	STORY.childs.n_auto = var_81_0:findChildByName("n_auto")
	STORY.childs.btn_speed = STORY.childs.n_auto:getChildByName("btn_speed")
	
	local var_81_7 = SAVE:get("app.story_auto_play_on", false)
	
	if is_using_story_v2() and STORY_ACTION_MANAGER:isStartAction() then
		var_81_7 = false
	end
	
	local var_81_8 = 0
	
	if var_81_7 then
		var_81_8 = SAVE:get("app.story_auto_speed", STORY_AUTO_DEFAULT_SPEED)
	end
	
	set_auto_story_speed(var_81_8, false)
	update_auto_play()
	
	STORY.index = STORY.index + 1
	
	setup_cuts(STORY.index)
	UIAction:Add(SEQ(DELAY(100)), STORY.childs.n_skip, "skip_block")
end

function toggle_auto_story_speed()
	if STORY.AUTO_STORY_SPEED == 0 then
		return 
	end
	
	if STORY.AUTO_STORY_SPEED > STORY_AUTO_DEFAULT_SPEED then
		STORY.AUTO_STORY_SPEED = STORY_AUTO_DEFAULT_SPEED
	else
		STORY.AUTO_STORY_SPEED = STORY_AUTO_QUICKLY_SPEED
	end
	
	SAVE:set("app.story_auto_speed", STORY.AUTO_STORY_SPEED)
	update_auto_play()
end

function update_auto_play()
	if not STORY.childs or not get_cocos_refid(STORY.childs.n_auto) then
		return 
	end
	
	local var_85_0 = STORY.childs.n_auto:getChildByName("icon_auto")
	local var_85_1 = STORY.AUTO_STORY_SPEED > 0
	
	if is_using_story_v2() and STORY_ACTION_MANAGER:isStartAction() then
		var_85_1 = false
	end
	
	if var_85_1 then
		STORY.childs.btn_speed:setVisible(true)
		
		if STORY.AUTO_STORY_SPEED == STORY_AUTO_DEFAULT_SPEED then
			SpriteCache:resetSprite(STORY.childs.btn_speed:getChildByName("icon_play"), "img/icon_menu_play.png")
		else
			SpriteCache:resetSprite(STORY.childs.btn_speed:getChildByName("icon_play"), "img/icon_menu_quickly.png")
		end
		
		Action:Add(COND_LOOP(ROTATE(2000, 0, 360), function()
			return not var_85_1
		end), var_85_0, "story.auto")
	else
		Action:Remove("story.auto")
		
		local var_85_2 = var_85_0:getRotationSkewX()
		local var_85_3 = 180
		
		if var_85_2 < var_85_3 then
			var_85_3 = 360
		end
		
		var_85_0:setRotation(var_85_3)
		STORY.childs.btn_speed:setVisible(false)
	end
end

function setup_characters(arg_87_0)
	set_character("left", arg_87_0.left, arg_87_0)
	set_character("mid", arg_87_0.mid, arg_87_0)
	set_character("right", arg_87_0.right, arg_87_0)
end

function easeInOutElastic(arg_88_0)
	local var_88_0 = 1.3962631111111112
	
	if arg_88_0 == 0 then
		return 0
	elseif arg_88_0 == 1 then
		return 1
	elseif arg_88_0 < 0.5 then
		return -(math.pow(2, 20 * arg_88_0 - 10) * math.sin((20 * arg_88_0 - 11.125) * var_88_0)) / 2
	else
		return math.pow(2, -20 * arg_88_0 + 10) * math.sin((20 * arg_88_0 - 11.125) * var_88_0) / 2 + 1
	end
end

function replace_eff_model(arg_89_0, arg_89_1)
	local var_89_0 = arg_89_1:getParent()
	
	arg_89_1:ejectFromParent()
	
	local var_89_1 = cc.RenderTexture:create(1536, 1024, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 37)
	
	var_89_1:addChild(arg_89_1)
	arg_89_1:setVisible(false)
	Scheduler:add(var_89_1, function()
		local var_90_0, var_90_1 = arg_89_1:getPosition()
		
		var_89_1:setPosition(var_90_0, var_90_1 + 500)
		arg_89_1:setPosition(768, 0)
		arg_89_1:setVisible(true)
		var_89_1:beginWithClear(0, 0, 0, 0)
		arg_89_1:visit()
		var_89_1:endToLua()
		arg_89_1:setVisible(false)
		arg_89_1:setPosition(var_90_0, var_90_1)
	end)
	arg_89_1:setPosition(768, 0)
	var_89_1:setPosition(arg_89_1:getPosition())
	var_89_0:addChild(var_89_1)
	
	arg_89_0.render_texture = var_89_1
	
	local var_89_2 = set_program(var_89_1:getSprite())
	
	arg_89_0.pst = var_89_2
	
	return var_89_2
end

function set_program(arg_91_0)
	local var_91_0 = cc.GLProgramCache:getInstance():getGLProgram("story_noise_post")
	
	print("program!!!!", var_91_0)
	
	if var_91_0 then
		print("program?", var_91_0)
		
		local var_91_1 = cc.GLProgramState:create(var_91_0)
		
		if var_91_1 then
			var_91_1:setUniformFloat("WHITE_OVERLAY", 0)
			var_91_1:setUniformFloat("BLUE_OVERLAY", 0.13)
			var_91_1:setUniformFloat("BLUR", 0)
			var_91_1:setUniformFloat("COLOR_DISTORTION", 1.022)
			var_91_1:setUniformFloat("SCANLINE_OFFSET", 0.003)
			var_91_1:setUniformFloat("NOISE_SCALE", 0)
			var_91_1:setUniformFloat("NOISE_TIME", 0)
			var_91_1:setUniformFloat("CUR_RENDER_Y", 1)
			
			local var_91_2 = 0.67
			
			UIAction:Add(LOOP(SEQ(DELAY(1000), LINEAR_CALL(200, nil, function(arg_92_0, arg_92_1)
				if not arg_92_1 then
					return 
				end
				
				arg_92_1 = easeInOutElastic(arg_92_1)
				
				var_91_1:setUniformFloat("NOISE_SCALE", arg_92_1 * var_91_2)
			end, 0, 1), LINEAR_CALL(100, nil, function(arg_93_0, arg_93_1)
				if not arg_93_1 then
					return 
				end
				
				arg_93_1 = easeInOutElastic(arg_93_1)
				
				var_91_1:setUniformFloat("NOISE_SCALE", arg_93_1 * var_91_2)
			end, 1, 0), DELAY(400), LINEAR_CALL(120, nil, function(arg_94_0, arg_94_1)
				if not arg_94_1 then
					return 
				end
				
				arg_94_1 = easeInOutElastic(arg_94_1)
				
				var_91_1:setUniformFloat("NOISE_SCALE", arg_94_1 * var_91_2 * 0.75)
			end, 0, 1), LINEAR_CALL(80, nil, function(arg_95_0, arg_95_1)
				if not arg_95_1 then
					return 
				end
				
				arg_95_1 = easeInOutElastic(arg_95_1)
				
				var_91_1:setUniformFloat("NOISE_SCALE", arg_95_1 * var_91_2 * 0.75)
			end, 1, 0), DELAY(210), LINEAR_CALL(100, nil, function(arg_96_0, arg_96_1)
				if not arg_96_1 then
					return 
				end
				
				arg_96_1 = easeInOutElastic(arg_96_1)
				
				var_91_1:setUniformFloat("NOISE_SCALE", arg_96_1 * var_91_2 * 0.51)
			end, 0, 1), LINEAR_CALL(20, nil, function(arg_97_0, arg_97_1)
				if not arg_97_1 then
					return 
				end
				
				arg_97_1 = easeInOutElastic(arg_97_1)
				
				var_91_1:setUniformFloat("NOISE_SCALE", arg_97_1 * var_91_2 * 0.51)
			end, 1, 0), DELAY(4500))), arg_91_0)
			Scheduler:add(arg_91_0, function()
				local var_98_0 = GET_LAST_TICK()
				
				set_high_fps_tick()
				var_91_1:setUniformFloat("SCANLINE_OFFSET", var_98_0 % 10000 * 5e-05)
				var_91_1:setUniformFloat("NOISE_TIME", var_98_0 / 1000 % 100)
			end)
			arg_91_0:setGLProgramState(var_91_1)
			arg_91_0:setDefaultGLProgramState(var_91_1)
			
			return var_91_1
		end
	end
end

function pow_action(arg_99_0)
	return 1 - math.pow(1 - arg_99_0, 5)
end

function cut_proc_obj_effs(arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	if arg_100_1 == nil then
		return 
	end
	
	local var_100_0 = 800
	
	local function var_100_1(arg_101_0, arg_101_1)
		if not STORY.chars then
			return 
		end
		
		local var_101_0 = {}
		local var_101_1 = {
			"left",
			"mid",
			"right"
		}
		
		for iter_101_0, iter_101_1 in pairs(var_101_1) do
			if get_cocos_refid(STORY.childs[iter_101_1]) then
				table.insert(var_101_0, TARGET(STORY.childs[iter_101_1], arg_101_0(arg_101_1)))
			end
		end
		
		return var_101_0
	end
	
	if not arg_100_3 then
		if arg_100_0:check_eff("페이드인") then
			table.push(arg_100_0.actions, TARGET(arg_100_1, FADE_IN(1000)))
		end
		
		if arg_100_0:check_eff("모든캐릭터페이드인") then
			table.push(arg_100_0.actions, SPAWN(table.unpack(var_100_1(FADE_IN, 1000))))
		end
		
		if arg_100_0:check_eff("슬라이드인L") then
			local var_100_2 = APPEAR(500, -1500, nil, true)
			
			table.push(arg_100_0.actions, TARGET(arg_100_1, var_100_2))
		elseif arg_100_0:check_eff("슬라이드인R") then
			local var_100_3 = APPEAR(500, 1500, nil, true)
			
			table.push(arg_100_0.actions, TARGET(arg_100_1, var_100_3))
		elseif arg_100_0:check_eff("슬라이드인") then
			local var_100_4 = APPEAR(500, -1500, nil, true)
			
			if arg_100_2 then
				var_100_4 = APPEAR(500, 1500, nil, true)
			end
			
			table.push(arg_100_0.actions, TARGET(arg_100_1, var_100_4))
		end
	end
	
	if arg_100_0:check_eff("흔들기") then
		if arg_100_1.portrait then
			table.push(arg_100_0.actions, TARGET(arg_100_1.portrait, SHAKE_UI(1500, 20, true)))
		else
			table.push(arg_100_0.actions, TARGET(arg_100_1, SHAKE_UI(1500, 20, true)))
		end
	end
	
	if arg_100_0:check_eff("통신중단") or arg_100_0:check_eff("통신시작") or arg_100_0:check_eff("통신종료") or arg_100_0:check_eff("통신") then
		if arg_100_0:check_eff("통신중단") then
			local var_100_5 = {}
			
			for iter_100_0, iter_100_1 in pairs(arg_100_0.effs) do
				if string.starts(iter_100_1, "통신중단") then
					local var_100_6 = string.split(iter_100_1, ",")
					
					if var_100_6 and #var_100_6 > 1 then
						table.remove(var_100_6, 1)
						
						for iter_100_2, iter_100_3 in pairs(var_100_6) do
							table.insert(var_100_5, iter_100_3)
						end
					end
				end
			end
			
			local function var_100_7(arg_102_0)
				if not arg_102_0 or not get_cocos_refid(arg_102_0.portrait) or not get_cocos_refid(arg_102_0.render_texture) then
					return 
				end
				
				arg_102_0.portrait:ejectFromParent()
				
				local var_102_0 = arg_102_0.render_texture:getParent()
				
				var_102_0:removeAllChildren()
				var_102_0:addChild(arg_102_0.portrait)
				arg_102_0.portrait:setVisible(true)
				
				arg_102_0.render_texture = nil
			end
			
			if var_100_5 then
				for iter_100_4, iter_100_5 in pairs(var_100_5) do
					local var_100_8 = iter_100_5
					local var_100_9
					
					if var_100_8 ~= "" and var_100_8 ~= nil then
						var_100_9 = STORY.childs[var_100_8]
					end
					
					if var_100_9 then
						var_100_7(var_100_9)
					end
				end
			else
				var_100_7(arg_100_1)
			end
		else
			local var_100_10 = arg_100_1
			local var_100_11 = ""
			
			for iter_100_6, iter_100_7 in pairs(arg_100_0.effs) do
				if string.starts(iter_100_7, "통신종료") then
					local var_100_12 = string.split(iter_100_7, ",")
					
					if var_100_12 and #var_100_12 > 1 then
						var_100_11 = var_100_12[2]
						
						break
					end
				end
			end
			
			if var_100_11 ~= "" and var_100_11 ~= nil then
				var_100_10 = STORY.childs[var_100_11]
			end
			
			if var_100_10.portrait and not get_cocos_refid(var_100_10.render_texture) then
				replace_eff_model(var_100_10, var_100_10.portrait)
			end
			
			local var_100_13 = var_100_10.pst
			
			if not get_cocos_refid(var_100_13) then
				return 
			end
			
			if arg_100_0:check_eff("통신시작") then
				table.push(arg_100_0.actions, TARGET(var_100_10, SPAWN(LOG(LINEAR_CALL(850, {}, function(arg_103_0, arg_103_1)
					if not arg_103_1 then
						return 
					end
					
					if not get_cocos_refid(var_100_13) then
						return 
					end
					
					var_100_13:setUniformFloat("WHITE_OVERLAY", 1 - arg_103_1)
				end, 0, 1)), LINEAR_CALL(850, {}, function(arg_104_0, arg_104_1)
					if not arg_104_1 then
						return 
					end
					
					if not get_cocos_refid(var_100_13) then
						return 
					end
					
					local var_104_0 = pow_action(arg_104_1)
					
					var_100_13:setUniformFloat("CUR_RENDER_Y", var_104_0)
				end, 0, 1))))
			elseif arg_100_0:check_eff("통신종료") then
				table.push(arg_100_0.actions, TARGET(var_100_10, SPAWN(LOG(LINEAR_CALL(250, {}, function(arg_105_0, arg_105_1)
					if not arg_105_1 then
						return 
					end
					
					if not get_cocos_refid(var_100_13) then
						return 
					end
					
					var_100_13:setUniformFloat("WHITE_OVERLAY", arg_105_1)
				end, 0, 1)), LINEAR_CALL(250, {}, function(arg_106_0, arg_106_1)
					if not arg_106_1 then
						return 
					end
					
					if not get_cocos_refid(var_100_13) then
						return 
					end
					
					local var_106_0 = pow_action(arg_106_1)
					
					var_100_13:setUniformFloat("CUR_RENDER_Y", 1 - var_106_0)
				end, 0, 1))))
			end
		end
	end
	
	if not arg_100_3 then
		if arg_100_0:check_eff("페이드아웃") then
			table.push(arg_100_0.clear_actions, TARGET(arg_100_1, FADE_OUT(1000)))
		end
		
		if arg_100_0:check_eff("모든캐릭터페이드아웃") then
			table.push(arg_100_0.clear_actions, SPAWN(table.unpack(var_100_1(FADE_OUT, 1000))))
		end
		
		if arg_100_0:check_eff("슬라이드아웃L") then
			local var_100_14 = DISAPPEAR(1000, -1500, nil, true)
			
			table.push(arg_100_0.clear_actions, TARGET(arg_100_1, var_100_14))
		elseif arg_100_0:check_eff("슬라이드아웃R") then
			local var_100_15 = DISAPPEAR(1000, 1500, nil, true)
			
			table.push(arg_100_0.clear_actions, TARGET(arg_100_1, var_100_15))
		elseif arg_100_0:check_eff("슬라이드아웃") then
			local var_100_16 = DISAPPEAR(1000, -1500, nil, true)
			
			if arg_100_2 then
				var_100_16 = DISAPPEAR(1000, 1500, nil, true)
			end
			
			table.push(arg_100_0.clear_actions, TARGET(arg_100_1, var_100_16))
		end
	end
end

function cut_check_eff(arg_107_0, arg_107_1)
	for iter_107_0, iter_107_1 in pairs(arg_107_0.effs) do
		if string.starts(iter_107_1, arg_107_1) then
			return true
		end
	end
end

function cut_eff_opt(arg_108_0, arg_108_1, arg_108_2)
	for iter_108_0, iter_108_1 in pairs(arg_108_0.effs) do
		if string.starts(iter_108_1, arg_108_1) then
			local var_108_0 = string.split(iter_108_1, ",")
			
			if #var_108_0 > 1 then
				return to_n(var_108_0[2])
			end
		end
	end
	
	return arg_108_2
end

function setup_sound_play_on_collection(arg_109_0)
	if not STORY.play_on_collection then
		return 
	end
	
	if arg_109_0.bgm then
		SoundEngine:playBGMWithFadeInOut("event:/bgm/" .. arg_109_0.bgm, 1000)
		
		STORY.prev_bgm = arg_109_0.bgm
		
		if STORY.on_bgm_played then
			STORY.on_bgm_played()
		end
	end
	
	if not STORY.prev_bgm and STORY.on_bgm_empty then
		STORY.on_bgm_empty(STORY.prev_mute)
	end
end

function setup_play_on_collection(arg_110_0)
	if not STORY.play_on_collection then
		return 
	end
	
	if STORY.childs.bg == nil and STORY.on_bg_empty then
		STORY.on_bg_empty()
	end
end

function setup_cut(arg_111_0)
	if is_using_story_v2() and STORY_ACTION_MANAGER:isStartAction() and arg_111_0.story_action then
		StoryLogger:readCutAction(arg_111_0)
	else
		StoryLogger:readCut(arg_111_0)
	end
	
	arg_111_0.check_eff = cut_check_eff
	arg_111_0.eff_opt = cut_eff_opt
	arg_111_0.proc_obj_effs = cut_proc_obj_effs
	arg_111_0.effs = {
		arg_111_0.eff1,
		arg_111_0.eff2,
		arg_111_0.eff3
	}
	arg_111_0.actions = {}
	arg_111_0.clear_actions = {}
	STORY.cut_opts = {}
	
	if STORY.current_talker ~= arg_111_0.talker then
		var_0_6()
	end
	
	STORY.current_talker = arg_111_0.talker or ""
	
	if_set_visible(STORY.layer, "n_title", false)
	setup_sound(arg_111_0)
	setup_sound_play_on_collection(arg_111_0)
	
	if get_cocos_refid(STORY.n_voice) then
		STORY.n_voice:stop()
		
		STORY.n_voice = nil
	end
	
	if string.starts(arg_111_0.talker or "", "CHAPTER") or arg_111_0.talker == "NARRATION" or arg_111_0.talker == "NARRATION2" then
		if string.starts(arg_111_0.talker or "", "CHAPTER") then
			STORY.current_talker = "CHAPTER"
		end
		
		if arg_111_0.talker == "NARRATION2" then
			arg_111_0.talker = "NARRATION"
			arg_111_0.color = arg_111_0.color or "000000"
			STORY.request_white_title = true
		end
		
		init_title(arg_111_0)
		
		local var_111_0 = systick() - STORY.skip_story_tick
		
		if var_111_0 <= 0 or var_111_0 > 3000 then
			var_0_4(false)
		end
		
		return 
	end
	
	if var_0_2 then
		if not STORY.layer then
			return 
		end
		
		local var_111_1 = STORY.layer:getChildByName("n_confirm")
		local var_111_2 = STORY.layer:getChildByName("n_confirm_in")
		
		if var_111_1 and var_111_2 and var_111_1.origin_y then
			UIAction:Remove("reward_ui_slide_in")
			UIAction:Add(SEQ(LOG(MOVE_TO(500, nil, var_111_1.origin_y))), var_111_1, "reward_ui_slide_out")
		end
		
		var_0_2 = false
	end
	
	if arg_111_0.choice_flag then
		setup_choice(arg_111_0)
		var_0_4(true)
		
		return 
	end
	
	var_0_4(true)
	
	if arg_111_0.movie and arg_111_0.moive ~= "" then
		STORY.childs.n_talk:setVisible(false)
		STORY.childs.n_talk_monologue:setVisible(false)
		STORY.childs.n_talk_caption:setVisible(false)
		STORY.childs.n_talk_clear:setVisible(false)
		setup_movie(arg_111_0)
		
		STORY.prev_bgm = nil
		STORY.current_talker = "MOVIE"
		
		return 
	end
	
	setup_pre_global_effs(arg_111_0)
	
	if arg_111_0.talker == "LOCATION" then
		setup_location(arg_111_0)
	elseif arg_111_0.talker == "RETAIN_TEXT" then
	else
		if arg_111_0.left or arg_111_0.mid or arg_111_0.right then
			setup_characters(arg_111_0)
		else
			set_character_position(STORY.childs.left, "left")
			set_character_position(STORY.childs.right, "right")
			set_character_position(STORY.childs.mid, "mid")
		end
		
		STORY.childs.n_talk:setVisible(arg_111_0.text ~= nil)
		STORY.childs.n_talk_monologue:setVisible(arg_111_0.text ~= nil)
		STORY.childs.n_talk_caption:setVisible(arg_111_0.text ~= nil)
		STORY.childs.n_talk_clear:setVisible(arg_111_0.text ~= nil)
		
		if (arg_111_0.talker or arg_111_0.text) and arg_111_0.talker ~= "LOCATION" then
			local var_111_3 = setup_talk(arg_111_0)
		end
	end
	
	if arg_111_0.bg and arg_111_0.bg ~= "" then
		setup_bg(arg_111_0)
	end
	
	if get_cocos_refid(STORY_ACTION_MANAGER:getLayer()) and arg_111_0.story_action then
		if STORY.childs and get_cocos_refid(STORY.childs.bg) then
			STORY.childs.bg:removeFromParent()
			
			STORY.childs.bg = nil
		end
		
		BattleField:clearOverlay()
	end
	
	local var_111_4 = false
	
	if STORY.prev_mute and not UIOption:isMute("bgm") then
		SoundEngine:setMute("bgm", false, true)
		
		STORY.prev_mute = nil
		var_111_4 = true
	end
	
	if arg_111_0.bgm then
		if var_111_4 then
			SoundEngine:playBGM("event:/bgm/" .. arg_111_0.bgm, true)
		else
			SoundEngine:playBGMWithFadeInOut("event:/bgm/" .. arg_111_0.bgm, 1000, STORY.prev_bgm == arg_111_0.bgm)
		end
		
		STORY.prev_bgm = arg_111_0.bgm
		
		if STORY.on_bgm_played then
			STORY.on_bgm_played()
		end
	end
	
	if arg_111_0.voice then
		STORY.n_voice = SoundEngine:play("event:/voc/" .. arg_111_0.voice)
		
		if STORY.n_voice and STORY.n_voice.onStopEventListener then
			STORY.n_voice:onStopEventListener(function()
				if (STORY.double_speed or STORY.cut_opts.auto_continue) and #STORY.actions == 0 then
					step_next()
				end
			end)
		end
	end
	
	if arg_111_0.sound_effect then
		local var_111_5 = string.split(arg_111_0.sound_effect, ",")
		
		if #var_111_5 > 3 then
			error("TOO MANY SOUND EFFECT. CHECK REDMINE #77127.")
		end
		
		for iter_111_0, iter_111_1 in pairs(var_111_5) do
			local var_111_6 = string.split(iter_111_1, ":")
			local var_111_7 = var_111_6[1]
			local var_111_8 = 0
			
			if var_111_6[2] then
				var_111_8 = to_n(var_111_6[2])
			end
			
			if var_111_8 == 0 then
				SoundEngine:play("event:/" .. var_111_7)
			else
				UIAction:Add(SEQ(DELAY(var_111_8), CALL(function()
					SoundEngine:play("event:/" .. var_111_7)
				end)), STORY)
			end
		end
	end
	
	setup_image(arg_111_0)
	setup_play_on_collection(arg_111_0)
	setup_global_effs(arg_111_0)
end

function all_fade_in_out(arg_114_0)
	for iter_114_0, iter_114_1 in pairs(arg_114_0) do
		for iter_114_2 = 1, 3 do
			local var_114_0 = iter_114_1["eff" .. iter_114_2]
			
			if var_114_0 and string.starts(var_114_0, "전체페이드인아웃") and not STORY.fade_wait then
				STORY.childs.curtain:setColor(cc.c3b(0, 0, 0))
				
				local var_114_1 = 1000
				local var_114_2 = string.split(var_114_0, ",")
				
				if #var_114_2 > 1 then
					var_114_1 = var_114_2[2]
				end
				
				STORY.fade_wait = true
				STORY.next_cut_wait = true
				
				local var_114_3 = SEQ(TARGET(STORY.childs.curtain, FADE_IN(2000)), CALL(function()
					setup_cuts(STORY.index)
					if_set_visible(STORY.childs.curtain, nil, true)
				end), TARGET(STORY.childs.curtain, DELAY(var_114_1)), CALL(function()
					STORY.next_cut_wait = nil
				end), TARGET(STORY.childs.curtain, FADE_OUT(2000)), CALL(function()
					STORY.fade_wait = nil
				end))
				
				UIAction:Add(var_114_3, STORY, "story.fade_action")
				
				return true
			elseif var_114_0 and string.starts(var_114_0, "전체UI페이드인") and not STORY.fade_wait then
				local var_114_4 = 1000
				local var_114_5 = string.split(var_114_0, ",")
				
				if #var_114_5 > 1 then
					var_114_4 = var_114_5[2]
				end
				
				STORY.fade_wait = true
				STORY.cursor_hide = true
				
				local function var_114_6()
					local var_118_0
					
					if iter_114_1.balloon == "mono" then
						var_118_0 = STORY.childs.n_talk_monologue
					elseif iter_114_1.balloon == "caption" or iter_114_1.balloon == "caption2" then
						var_118_0 = STORY.childs.n_talk_caption
					elseif iter_114_1.balloon == "clear" or iter_114_1.balloon == "clear2" then
						var_118_0 = STORY.childs.n_talk_clear
					else
						var_118_0 = STORY.childs.n_talk
					end
					
					if not get_cocos_refid(var_118_0) then
						Log.e("NOT N TALK!!! REQ NTALK VISIBLE!!! DM TO @ffdd270!!")
					end
					
					local var_118_1 = STORY.childs.vignetting
					
					if get_cocos_refid(var_118_1) and not var_118_1:isVisible() then
						var_118_1 = nil
					end
					
					local var_118_2 = STORY.layer:findChildByName("n_auto")
					local var_118_3 = STORY.layer:findChildByName("n_return_dict")
					local var_118_4 = STORY.layer:findChildByName("n_skip")
					
					return var_118_1, var_118_0, var_118_2, var_118_3, var_118_4
				end
				
				local function var_114_7(arg_119_0)
					local var_119_0, var_119_1, var_119_2, var_119_3, var_119_4 = var_114_6()
					
					return SPAWN(TARGET(var_119_0, arg_119_0), TARGET(var_119_1, arg_119_0), TARGET(var_119_2, arg_119_0), TARGET(var_119_3, arg_119_0), TARGET(var_119_4, arg_119_0))
				end
				
				local var_114_8 = STORY.layer:findChildByName("g1")
				local var_114_9 = STORY.layer:findChildByName("g2")
				
				UIAction:Add(SEQ(CALL(function()
					setup_cuts(STORY.index)
					
					local var_120_0, var_120_1, var_120_2, var_120_3, var_120_4 = var_114_6()
					local var_120_5 = {
						var_120_0,
						var_120_1,
						var_120_2,
						var_120_3,
						var_120_4,
						var_114_8,
						var_114_9
					}
					
					for iter_120_0, iter_120_1 in pairs(var_120_5) do
						if get_cocos_refid(iter_120_1) then
							iter_120_1:setOpacity(0)
						end
					end
				end), DELAY(var_114_4), SPAWN(var_114_7(FADE_IN(2000)), TARGET(var_114_8, OPACITY(2000, 0, var_114_8:getOpacity() / 255)), TARGET(var_114_9, OPACITY(2000, 0, var_114_9:getOpacity() / 255))), CALL(function()
					STORY.fade_wait = nil
					STORY.cursor_hide = nil
				end)), STORY, "story.fade_action")
				
				return true
			end
		end
	end
	
	return false
end

function setup_cuts(arg_122_0)
	local var_122_0 = STORY.story[arg_122_0]
	
	if all_fade_in_out(var_122_0) then
		return 
	end
	
	for iter_122_0, iter_122_1 in pairs(var_122_0) do
		setup_cut(iter_122_1)
	end
	
	local var_122_1 = {}
	local var_122_2 = {}
	local var_122_3
	
	for iter_122_2, iter_122_3 in pairs(var_122_0) do
		if iter_122_3.delay then
			for iter_122_4, iter_122_5 in pairs(iter_122_3.actions) do
				iter_122_3.actions[iter_122_4] = SEQ(DELAY(iter_122_3.delay), iter_122_5)
			end
		end
		
		if var_122_3 then
			for iter_122_6, iter_122_7 in pairs(iter_122_3.actions) do
				iter_122_3.actions[iter_122_6] = SEQ(DELAY(var_122_3), iter_122_7)
			end
		end
		
		if iter_122_3.story_action and iter_122_3.actions then
			iter_122_3.actions[1] = SEQ(CALL(function()
				STORY_ACTION_MANAGER:story_action_step_next_bt_action_id(iter_122_3.story_action)
			end))
		end
		
		if iter_122_3.next_delay then
			var_122_3 = iter_122_3.next_delay
		end
		
		if iter_122_3.retain_prv_text and get_cocos_refid(STORY.target_n_talk) and get_cocos_refid(STORY.target_text_control) then
			if_set_visible(STORY.target_n_talk, nil, true)
			if_set_visible(STORY.target_text_control, nil, true)
		end
		
		table.add(var_122_1, iter_122_3.actions)
		table.add(var_122_2, iter_122_3.clear_actions)
	end
	
	STORY.actions = {
		Action:create(SPAWN(table.unpack(var_122_1)), STORY)
	}
	
	if #var_122_2 > 0 then
		STORY.clear_action = SPAWN(table.unpack(var_122_2))
	else
		STORY.clear_action = nil
	end
	
	if arg_122_0 == #STORY.story then
		local var_122_4 = var_122_0[#var_122_0]
		
		if string.starts(var_122_4.eff1 or "", "전체페이드아웃") and not var_122_4.text then
			STORY.cut_opts.auto_continue = true
		end
	end
end

function init_title(arg_124_0)
	setup_characters(arg_124_0)
	STORY.childs.n_talk:setVisible(false)
	STORY.childs.n_talk_monologue:setVisible(false)
	STORY.childs.n_talk_caption:setVisible(false)
	STORY.childs.n_talk_clear:setVisible(false)
	
	local var_124_0 = STORY.layer:getChildByName("n_title")
	
	var_124_0:setVisible(true)
	
	local var_124_1 = var_124_0:getChildByName("t_narration")
	local var_124_2 = var_124_0:getChildByName("n_chapter")
	local var_124_3 = var_124_0:getChildByName("t_main_title")
	local var_124_4 = var_124_0:getChildByName("t_sub_title")
	local var_124_5 = not get_cocos_refid(var_124_3)
	
	if not var_124_5 then
		var_124_3:setString("")
		var_124_4:setString("")
	end
	
	local var_124_6 = 2400
	local var_124_7 = 0
	
	if_set_visible(STORY.layer, "n_chapter", string.starts(arg_124_0.talker or "", "CHAPTER"))
	
	STORY.childs.title = STORY.layer:getChildByName("n_title")
	
	STORY.childs.title:setOpacity(255)
	
	STORY.chapter_intro_eff = nil
	
	local var_124_8 = false
	
	if string.starts(arg_124_0.talker or "", "CHAPTER") then
		while get_cocos_refid(var_124_2:getChildByName("@CHAPTER_BG")) do
			var_124_2:removeChildByName("@CHAPTER_BG")
		end
		
		while get_cocos_refid(var_124_2:getChildByName("@CHAPTER_INTRO")) do
			var_124_2:removeChildByName("@CHAPTER_INTRO")
		end
		
		var_124_1:setLocalZOrder(0)
		
		if arg_124_0.talker == "CHAPTER" then
			var_124_7 = 1000
			STORY.chapter_intro_eff = EffectManager:Play({
				node_name = "@CHAPTER_INTRO",
				fn = "chapter_intro.cfx",
				y = 390,
				delay = 0,
				x = 640,
				layer = var_124_2
			})
			
			cc.Director:getInstance():setNextDeltaTimeZero(true)
			table.push(arg_124_0.actions, SEQ(DELAY(var_124_7)))
			
			if not var_124_5 then
				var_124_8 = true
				
				local var_124_9 = string.split(arg_124_0.text, "\n")
				
				if_set(var_124_3, nil, var_124_9[1])
				
				local var_124_10 = ""
				
				for iter_124_0 = 2, #var_124_9 do
					if var_124_9[iter_124_0] then
						var_124_9[iter_124_0] = string.trim(var_124_9[iter_124_0])
						
						if var_124_9[iter_124_0] ~= "\n" and var_124_9[iter_124_0] ~= "" then
							var_124_10 = var_124_10 == "" and var_124_9[iter_124_0] or var_124_10 .. "\n" .. var_124_9[iter_124_0]
						end
					end
				end
				
				if var_124_10 ~= "" then
					if_set(var_124_4, nil, var_124_10)
				end
			end
			
			var_124_6 = 2000
		elseif string.starts(arg_124_0.talker or "", "CHAPTER_EP") then
			var_124_1:setLocalZOrder(1)
			
			local var_124_11 = string.split(arg_124_0.talker, ",")
			local var_124_12 = (string.lower(var_124_11[1]) or "chapter_intro") .. ".cfx"
			
			STORY.chapter_intro_eff = EffectManager:Play({
				node_name = "@CHAPTER_INTRO",
				y = 340,
				delay = 1000,
				x = 640,
				fn = var_124_12,
				layer = var_124_2
			})
			var_124_7 = 2000
			
			cc.Director:getInstance():setNextDeltaTimeZero(true)
			table.push(arg_124_0.actions, SEQ(DELAY(0)))
			
			local var_124_13
			
			if not var_124_5 then
				var_124_8 = true
				var_124_13 = string.split(arg_124_0.text, "\n")
				
				if_set(var_124_3, nil, var_124_13[1])
				
				for iter_124_1 = 2, #var_124_13 do
					if string.len(var_124_13[iter_124_1] or "") > 0 then
						if_set(var_124_4, nil, var_124_13[iter_124_1])
					end
				end
			end
			
			var_124_6 = 2000
		elseif string.starts(arg_124_0.talker or "", "CHAPTER_") then
			local var_124_14 = string.split(arg_124_0.talker, ",")
			local var_124_15 = string.lower(var_124_14[1])
			local var_124_16 = tonumber(var_124_14[2]) or 4200
			local var_124_17 = cc.Sprite:create(UIUtil:getIllustPath("story/bg/", var_124_15))
			
			if get_cocos_refid(var_124_17) then
				var_124_17:setScale(VIEW_WIDTH / var_124_17:getContentSize().width, VIEW_HEIGHT / var_124_17:getContentSize().height)
				var_124_17:setPositionX(VIEW_BASE_LEFT)
				var_124_17:setAnchorPoint(0, 0)
				var_124_17:setName("@CHAPTER_BG")
				var_124_2:addChild(var_124_17)
			end
			
			if not var_124_5 then
				var_124_8 = true
				
				local var_124_18 = string.split(arg_124_0.text, "\n")
				
				if_set(var_124_3, nil, var_124_18[1])
				
				local var_124_19 = ""
				
				for iter_124_2 = 2, #var_124_18 do
					if var_124_18[iter_124_2] then
						var_124_18[iter_124_2] = string.trim(var_124_18[iter_124_2])
						
						if var_124_18[iter_124_2] ~= "\n" and var_124_18[iter_124_2] ~= "" then
							var_124_19 = var_124_19 == "" and var_124_18[iter_124_2] or var_124_19 .. "\n" .. var_124_18[iter_124_2]
						end
					end
				end
				
				if var_124_19 ~= "" then
					if_set(var_124_4, nil, var_124_19)
				end
			end
			
			STORY.chapter_intro_eff = EffectManager:Play({
				node_name = "@CHAPTER_INTRO",
				y = 360,
				delay = 0,
				x = 640,
				fn = var_124_15 .. ".cfx",
				layer = var_124_2
			})
			var_124_7 = var_124_16
			
			cc.Director:getInstance():setNextDeltaTimeZero(true)
			table.push(arg_124_0.actions, SEQ(DELAY(var_124_7)))
		elseif string.len(arg_124_0.talker or "") > 0 then
			local var_124_20 = string.lower(arg_124_0.talker)
			local var_124_21 = EffectManager:Play({
				node_name = "@CHAPTER_INTRO",
				y = 360,
				x = 640,
				fn = var_124_20 .. ".cfx",
				layer = var_124_2,
				delay = var_124_7
			})
			
			if get_cocos_refid(var_124_21) then
				cc.Director:getInstance():setNextDeltaTimeZero(true)
				
				var_124_7 = 1000
				
				table.push(arg_124_0.actions, SEQ(DELAY(var_124_7)))
				
				STORY.chapter_intro_eff = var_124_21
			end
		end
	end
	
	local var_124_22 = ""
	
	if not var_124_8 then
		var_124_22 = arg_124_0.text
	end
	
	if_set(var_124_1, nil, var_124_22)
	
	STORY.cut_opts.disable_skip = string.starts(arg_124_0.talker or "", "CHAPTER")
	STORY.cut_opts.auto_continue = true
	
	local var_124_23 = UIUtil:strToC3b(arg_124_0.color or "FFFFFF")
	
	var_124_1:setColor(var_124_23)
	
	if arg_124_0.talker ~= "NARRATION" then
		STORY.prev_mute = true
		
		SoundEngine:setMute("bgm", true)
	end
	
	var_124_1:setOpacity(0)
	
	if not var_124_5 then
		var_124_3:setOpacity(0)
		var_124_4:setOpacity(0)
	end
	
	if var_124_8 and not var_124_5 then
		var_124_3:setColor(var_124_23)
		var_124_4:setColor(var_124_23)
		
		local var_124_24 = TARGET(var_124_3, SEQ(DELAY(var_124_7), FADE_IN(900), DELAY(600), DELAY(var_124_6), FADE_OUT(167)))
		
		table.push(arg_124_0.actions, var_124_24)
		
		local var_124_25 = TARGET(var_124_4, SEQ(DELAY(var_124_7), DELAY(600), FADE_IN(1200), DELAY(var_124_6 - 300), FADE_OUT(167)))
		
		table.push(arg_124_0.actions, var_124_25)
	else
		if STORY.childs.title then
			local var_124_26 = STORY.childs.title:findChildByName("title_black")
			
			if STORY.request_white_title then
				var_124_26:setBackGroundColor(cc.c3b(255, 255, 255))
			else
				var_124_26:setBackGroundColor(cc.c3b(0, 0, 0))
			end
		end
		
		local var_124_27 = TARGET(var_124_1, SEQ(DELAY(var_124_7), FADE_IN(900), DELAY(600), DELAY(var_124_6), FADE_OUT(800)))
		
		table.push(arg_124_0.actions, var_124_27)
	end
	
	if arg_124_0.talker == string.starts(arg_124_0.talker or "", "CHAPTER") then
		var_124_2:setColor(cc.c3b(0, 0, 0))
		table.push(arg_124_0.actions, TARGET(var_124_2, SEQ(DELAY(var_124_7), COLOR(300, 255, 255, 255), DELAY(3400), COLOR(800, 0, 0, 0), DELAY(600))))
	end
end

function story_log_clear(arg_125_0)
	if SceneManager:getCurrentSceneName() ~= "battle" then
		StoryLogger:destroyWithViewer()
	end
end

function play_story(arg_126_0, arg_126_1)
	cc.Director:getInstance():setNextDeltaTimeZero(true)
	
	local function var_126_0()
		if arg_126_1.force_on_finish and arg_126_1.on_finish then
			if is_playing_story() then
				table.insert(STORY_PLAYBACK_QUEUE, arg_126_1.on_finish)
			else
				arg_126_1.on_finish()
			end
		end
	end
	
	arg_126_0 = assert(arg_126_0)
	arg_126_1 = arg_126_1 or {}
	
	if not DEBUG.DEBUG_STORY then
		if arg_126_1.force == nil and Account:isPlayedStory(arg_126_0) then
			var_126_0()
			
			return false
		end
		
		if arg_126_1.force == false then
			var_126_0()
			
			return false
		end
	end
	
	table.insert(STORY_PLAYBACK_QUEUE, {
		story_id = arg_126_0,
		opts = arg_126_1
	})
	
	if not arg_126_1.do_not_play then
		play_story_playback_queue()
	end
	
	print("play_story!!", arg_126_0, " ,force? =", arg_126_1.force)
	
	if arg_126_0 == "CH00_005" then
		SAVE:incTutorialCounter()
	end
	
	BackButtonManager:push({
		back_func = function()
			if not var_0_24() then
				return 
			end
			
			local var_128_0 = (STORY.childs or {}).movie
			
			if get_cocos_refid(var_128_0) and var_128_0:getState() <= 2 then
				check_cool_time(var_128_0, "skip_video", 2000, function()
					var_128_0:executeVideoSkip(T("movie_skip_toast"))
				end, function()
					balloon_message_with_sound("movie_skip_toast")
				end, true)
			else
				var_0_25()
			end
		end,
		check_id = "Story." .. arg_126_0,
		id = arg_126_0
	})
	LuaEventDispatcher:dispatchEvent("invite.event", "hide")
	
	return true
end

function attach_story_finished_callback(arg_131_0, arg_131_1)
	if is_playing_story() or arg_131_1 then
		table.insert(STORY_PLAYBACK_QUEUE, arg_131_0)
	else
		arg_131_0()
	end
end

function play_story_playback_queue()
	if is_using_story_v2() or SceneManager:getCurrentSceneName() == "story_action" then
		while not is_playing_story() or is_using_story_v2() do
			local var_132_0 = table.remove(STORY_PLAYBACK_QUEUE)
			
			if not var_132_0 then
				story_log_clear()
				
				if STORY.play_on_intro then
					break
				end
				
				SceneManager:popScene()
				
				break
			end
			
			if type(var_132_0) == "function" then
				var_132_0()
			else
				if var_132_0.opts and var_132_0.opts.layer then
					var_132_0.opts.layer = nil
				end
				
				local var_132_1 = DB("story_action_main", var_132_0.story_id, {
					"id"
				})
				
				if var_132_0.opts and (var_132_0.opts.play_on_collection or var_132_0.opts.play_on_intro) and var_132_1 then
					story_action_on_action_scene(nil, var_132_0.story_id, var_132_0.opts)
					
					break
				else
					test_story(var_132_0.story_id, var_132_0.opts)
				end
			end
		end
	else
		while not is_playing_story() do
			local var_132_2 = table.remove(STORY_PLAYBACK_QUEUE)
			
			if not var_132_2 then
				story_log_clear()
				
				break
			end
			
			if type(var_132_2) == "function" then
				var_132_2()
			else
				local var_132_3 = DB("story_action_main", var_132_2.story_id, {
					"id"
				})
				
				if var_132_2.opts and (var_132_2.opts.play_on_collection or var_132_2.opts.play_on_intro) and var_132_3 then
					var_132_2.opts.layer = nil
					
					story_action_on_action_scene(nil, var_132_2.story_id, var_132_2.opts)
					
					break
				else
					test_story(var_132_2.story_id, var_132_2.opts)
				end
			end
		end
	end
end

function test_story(arg_133_0, arg_133_1)
	if DEBUG.SKIP_STORY then
		return 
	end
	
	set_using_story_v2(false)
	
	local var_133_0 = CameraManager:getCamera()
	
	if is_using_story_v2() and var_133_0 then
		CameraManager:getCamera()._nextZoomObjectList = {}
		CameraManager:getCamera()._nextFocusObjectList = {}
		
		CameraManager:getCamera():update()
	end
	
	set_high_fps_tick(10000)
	
	arg_133_0 = arg_133_0 or "prologue"
	arg_133_1 = arg_133_1 or {}
	
	local var_133_1 = arg_133_1.layer or SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_133_1) then
		var_133_1 = SceneManager:getRunningPopupScene()
	end
	
	STORY = {}
	STORY.prev_story_tick = nil
	STORY.skip_story_tick = 0
	STORY.skip_popup = nil
	STORY.begin_tick = systick()
	STORY.stop = nil
	STORY.playing = true
	STORY.story_id = arg_133_0
	STORY.enter_id = arg_133_1.enter_id
	STORY.current_talker = nil
	STORY.prev_cut = nil
	STORY.chars = {}
	STORY.childs = {}
	STORY.textures = {}
	STORY.layer = cc.Layer:create()
	
	STORY.layer:setCascadeOpacityEnabled(true)
	STORY.layer:setLocalZOrder(999998)
	STORY.layer:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	
	STORY.fade = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	STORY.fade:setOpacity(0)
	STORY.fade:setVisible(false)
	STORY.fade:setLocalZOrder(999997)
	STORY.layer:addChild(STORY.fade)
	
	STORY.on_finish = arg_133_1.on_finish
	STORY.on_bg_empty = arg_133_1.on_bg_empty
	STORY.on_bgm_played = arg_133_1.on_bgm_played
	STORY.on_bgm_empty = arg_133_1.on_bgm_empty
	STORY.isBGMContinue = arg_133_1.isBGMContinue
	STORY.on_clear = arg_133_1.on_clear
	STORY.callback_choice_list = arg_133_1.callback_choice_list
	STORY.choice_id = arg_133_1.choice_id
	STORY.skip_chosen_opacity = arg_133_1.skip_chosen_opacity
	STORY.return_vars = arg_133_1.return_vars
	STORY.is_fadeout = arg_133_1.is_fadeout
	STORY.play_on_collection = arg_133_1.play_on_collection
	STORY.play_on_intro = arg_133_1.play_on_intro
	STORY.is_lota_event = arg_133_1.is_lota_event
	STORY.is_moonlight_th = arg_133_1.is_moonlight_th
	STORY.scene = var_133_1
	STORY.use_choice_life = false
	
	local var_133_2, var_133_3, var_133_4 = DB("story_choice_special", STORY.enter_id, {
		"id",
		"max_life_cnt",
		"fail_story"
	})
	
	if var_133_2 then
		STORY.use_choice_life = true
		STORY.max_life_cnt = tonumber(var_133_3)
		STORY.cur_life_cnt = STORY.max_life_cnt
		STORY.fail_story = var_133_4
	end
	
	STORY.is_failed_story = false
	DEBUG_INFO.last_story = {
		id = arg_133_0,
		story = STORY
	}
	
	if BGI and get_cocos_refid(BGI.ui_layer) then
		BGI.ui_layer:setVisible(false)
	end
	
	var_133_1:addChild(STORY.layer)
	
	STORY.story = load_story(arg_133_0)
	
	if STORY.story == nil then
		debug_message("MISSING STORY:" .. arg_133_0)
		var_133_1:removeChild(STORY.layer)
		
		return 
	end
	
	STORY.index = 0
	STORY.prev_time_scale = getenv("time_scale")
	
	setenv("time_scale", 1.2)
	Scheduler:add(STORY.layer, function()
		proc_story()
		
		if CharPreviewViewer:isActive() then
			CameraManager:update()
			BattleField:update()
		elseif is_using_story_v2() then
			CameraManager:update()
			BattleField:update()
			BattleLayout:updateOnStory()
			STORY_ACTION_MANAGER:updateTextNodePosition()
			STORY_ACTION_MANAGER:removeCheckWorldTalks()
			
			if not PRODUCTION_MODE then
				STORY_ACTION_MANAGER:_debugUpdatePositionLabel()
			end
		end
	end)
	check_using_story_action(arg_133_0)
	start_story()
	
	if is_using_story_v2() then
		STORY_ACTION_MANAGER:storyActionInit(arg_133_0)
	end
end

function set_auto_story_speed(arg_135_0, arg_135_1)
	STORY.AUTO_STORY_SPEED = arg_135_0 or 0
	
	if arg_135_1 then
		local var_135_0 = STORY.AUTO_STORY_SPEED > 0
		
		SAVE:set("app.story_auto_play_on", var_135_0)
	end
end

function is_failed_story()
	return STORY.use_choice_life and STORY.is_failed_story
end

function is_auto_story_playable()
	if StoryViewer:isActive() or get_cocos_refid(STORY.active_popup_dlg) or get_cocos_refid(STORY.skip_popup) then
		return false
	end
	
	return true
end

function proc_story()
	if PAUSED then
		return 
	end
	
	if STORY.layer == nil then
		return 
	end
	
	if STORY.prev_story_tick == nil then
		STORY.prev_story_tick = systick()
	end
	
	local var_138_0 = systick()
	
	if var_0_3() and STORY.childs.n_skip:isVisible() and var_138_0 - STORY.skip_story_tick >= 3000 then
		STORY.skip_story_tick = var_138_0
		
		var_0_4(false, true)
	end
	
	local var_138_1 = systick()
	local var_138_2 = var_138_1 - STORY.prev_story_tick
	local var_138_3
	local var_138_4
	
	if STORY.double_speed then
		var_138_2 = var_138_2 * 2
	end
	
	if not is_auto_story_playable() then
		STORY.prev_story_tick = var_138_1
		STORY.finish_time = nil
		
		return 
	end
	
	if STORY.next_cut_wait then
		STORY.finish_time = nil
		
		return 
	end
	
	local var_138_5 = STORY.AUTO_STORY_SPEED or 0
	local var_138_6 = var_138_5 > 0
	
	if var_138_6 and not STORY.cut_opts.disable_skip then
		var_138_2 = var_138_2 * var_138_5
	end
	
	local var_138_7, var_138_8 = step_story(var_138_2)
	
	if var_138_7 and (var_138_8 or var_138_6) then
		if not STORY.finish_time then
			STORY.finish_time = var_138_1
		end
		
		local var_138_9 = 100
		
		if var_138_6 and not var_138_8 then
			if var_138_5 == STORY_AUTO_QUICKLY_SPEED then
				var_138_9 = STORY_AUTO_QUICKLY_DELAY_TM
			else
				var_138_9 = STORY_AUTO_DEFAULT_DELAY_TM
			end
			
			if get_cocos_refid(STORY.n_voice) then
				return 
			end
		end
		
		if var_138_9 < var_138_1 - STORY.finish_time then
			step_next()
		end
	elseif var_138_7 and not SysAction:Find("story.cursor") then
		show_cursor()
	end
	
	STORY.prev_story_tick = var_138_1
end

function show_cursor()
	if get_cocos_refid(STORY.childs.cursor) and not STORY.cursor_hide then
		STORY.childs.cursor:setOpacity(255)
		STORY.childs.cursor:setVisible(true)
		
		local var_139_0 = STORY.childs.n_talk:isVisible()
		local var_139_1 = STORY.childs.n_talk_monologue:isVisible()
		
		if_set_visible(STORY.childs.cursor, "talk", var_139_0)
		if_set_visible(STORY.childs.cursor, "monologue", var_139_1)
		if_set_visible(STORY.childs.cursor, "normal", not var_139_0 and not var_139_1)
		
		local var_139_2
		
		if var_139_0 then
			var_139_2 = STORY.childs.cursor:getChildByName("talk"):getChildByName("move_updown")
		end
		
		if var_139_1 then
			var_139_2 = STORY.childs.cursor:getChildByName("monologue"):getChildByName("move_updown")
		end
		
		if not var_139_0 and not var_139_1 then
			var_139_2 = STORY.childs.cursor:getChildByName("normal"):getChildByName("move_updown")
		end
		
		if var_139_2 then
			if is_using_story_v2() and not STORY_ACTION_MANAGER:needShowCursor() then
				var_139_2:setVisible(false)
			else
				SysAction:Add(LOOP(SEQ(LOG(MOVE_TO(220, 20, 30)), DELAY(120), RLOG(MOVE_TO(220, 20, 12)))), var_139_2, "story.cursor")
			end
		end
	end
end

function get_story_sprite(arg_140_0)
	local var_140_0 = cc.Sprite:create(arg_140_0)
	
	if var_140_0 == nil then
		print("not found story image : ", arg_140_0)
		
		var_140_0 = cc.Sprite:create("img/404.png")
	end
	
	local var_140_1 = var_140_0:getTexture()
	
	STORY.textures[var_140_1] = true
	
	return var_140_0
end

function is_playing_story()
	return get_cocos_refid(STORY.layer)
end

function clear_story()
	if get_cocos_refid(STORY.layer) then
		if STORY.layer:getParent() then
			if not (STORY.story_id == "CH00_003" or STORY.story_id == "CH00_005") then
				STORY.layer:removeFromParent()
			end
		else
			STORY.layer:release()
		end
	end
	
	StoryAction:RemoveAll()
	CharPreviewViewer:Destroy()
	
	if is_using_story_v2() then
		STORY_ACTION_MANAGER:distroy()
		set_using_story_v2(false)
		
		local var_142_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_142_0:setName("curtain")
		var_142_0:setTouchEnabled(true)
		var_142_0:setColor(cc.c3b(0, 0, 0))
		var_142_0:setOpacity(255)
		var_142_0:setPosition((DESIGN_WIDTH - MAX_VIEW_WIDTH) / 2, 0)
		var_142_0:setContentSize(MAX_VIEW_WIDTH, VIEW_HEIGHT)
		SceneManager:getRunningNativeScene():addChild(var_142_0)
		UIAction:Add(SEQ(DELAY(200), REMOVE()), var_142_0, "block")
	end
	
	local var_142_1 = cc.Director:getInstance():getTextureCache()
	
	for iter_142_0, iter_142_1 in pairs(STORY.textures or {}) do
		var_142_1:removeTexture(iter_142_0)
	end
	
	if get_cocos_refid(STORY.n_voice) then
		STORY.n_voice:stop()
		
		STORY.n_voice = nil
	end
	
	STORY.textures = {}
	STORY.layer = nil
	STORY.actions = nil
	STORY.chars = {}
	STORY.childs = {}
	STORY.playing = nil
	DEBUG_INFO.last_story = nil
	
	SysAction:Remove("story.cursor")
	
	if BGI and get_cocos_refid(BGI.ui_layer) then
		BGI.ui_layer:setVisible(true)
	end
	
	if STORY.on_clear then
		STORY.on_clear()
	end
	
	if (not STORY.isBGMContinue or not STORY.isBGMContinue()) and not UIOption:isMute("bgm") then
		SoundEngine:setMute("bgm", false, true)
		SoundEngine:playBGM()
	end
	
	STORY.on_bg_empty = nil
	STORY.on_bgm_played = nil
	STORY.on_bgm_empty = nil
	STORY.isBGMContinue = nil
	STORY.on_clear = nil
	STORY.is_lota_event = nil
	STORY.play_on_collection = nil
	
	resume()
	
	if STORY.story_id == "CH01_001" then
		SAVE:incTutorialCounter()
	end
	
	print("clear_story!!", STORY.story_id)
	
	if not STORY.play_on_collection then
		Singular:storyEndEvent(STORY.story_id)
	end
	
	print("on_finish", STORY.on_finish)
	_run_callback_in_story()
	LuaEventDispatcher:dispatchEvent("invite.event", "reload")
	play_story_playback_queue()
end

function _run_callback_in_story(arg_143_0)
	local var_143_0 = arg_143_0 or STORY.on_finish
	
	if var_143_0 then
		if type(var_143_0) == "function" then
			var_143_0()
		elseif type(var_143_0) == "table" then
			if var_143_0.func then
				var_143_0.func(var_143_0.params)
			else
				for iter_143_0, iter_143_1 in pairs(var_143_0) do
					if iter_143_1.func then
						iter_143_1.func(iter_143_1.params)
					end
				end
			end
		end
		
		if STORY.on_finish then
			STORY.on_finish = nil
			
			UIAction:Add(DELAY(1000), STORY, "block")
		end
	end
end

function add_callback_to_story(arg_144_0)
	if not is_playing_story() then
		_run_callback_in_story(arg_144_0)
		
		return 
	end
	
	if not STORY.on_finish then
		STORY.on_finish = arg_144_0
		
		return 
	end
	
	local var_144_0 = {}
	local var_144_1 = STORY.on_finish
	
	if type(var_144_1) == "function" then
		table.insert(var_144_0, {
			func = var_144_1
		})
	elseif type(var_144_1) == "table" then
		if var_144_1.func then
			table.insert(var_144_0, var_144_1)
		else
			var_144_0 = var_144_1
		end
	end
	
	if type(arg_144_0) == "function" then
		table.insert(var_144_0, {
			func = arg_144_0
		})
	else
		table.insert(var_144_0, arg_144_0)
	end
	
	STORY.on_finish = var_144_0
end

function exit_story()
	BackButtonManager:pop({
		check_id = "Story." .. STORY.story_id,
		id = STORY.story_id
	})
	
	for iter_145_0 = 2, #STORY_PLAYBACK_QUEUE do
		BackButtonManager:pop({
			check_id = "Story." .. STORY_PLAYBACK_QUEUE[iter_145_0].story_id,
			id = STORY_PLAYBACK_QUEUE[iter_145_0].story_id
		})
		
		if STORY_PLAYBACK_QUEUE[iter_145_0].opts.on_clear then
			STORY_PLAYBACK_QUEUE[iter_145_0].opts.on_clear()
		end
		
		STORY_PLAYBACK_QUEUE[iter_145_0] = nil
	end
	
	clear_story()
end

function skip_to_story_id(arg_146_0)
	for iter_146_0, iter_146_1 in pairs(STORY.story) do
		if iter_146_0 > STORY.index then
			for iter_146_2, iter_146_3 in pairs(iter_146_1 or {}) do
				if iter_146_3.sub_id == arg_146_0 then
					skip_to_choice(iter_146_0)
					
					return 
				end
			end
		end
	end
	
	print("error : sub_id was not exist")
end

function stop_story(arg_147_0)
	if STORY.stop or STORY.layer == nil then
		return 
	end
	
	var_0_6()
	
	if STORY.current_talker == "MOVIE" and STORY.index < #STORY.story then
		step_next_index()
		
		return 
	end
	
	if UIAction:Find("story.fade_action") then
		STORY.fade_wait = nil
		STORY.next_cut_wait = nil
		
		UIAction:Remove("story.fade_action")
	end
	
	StoryViewer:skipStory(STORY.story, STORY.index)
	
	for iter_147_0, iter_147_1 in pairs(STORY.story) do
		if iter_147_0 > STORY.index then
			for iter_147_2, iter_147_3 in pairs(iter_147_1 or {}) do
				if iter_147_3.movie or iter_147_3.illust or iter_147_3.eff1 == "스킬" then
					STORY.index = iter_147_0 - 1
					
					step_next_index()
					
					return 
				elseif iter_147_3.choice_flag then
					skip_to_choice(iter_147_0)
					
					return 
				end
			end
		end
	end
	
	if not STORY_SKIPPED_LIST then
		STORY_SKIPPED_LIST = {}
	end
	
	if arg_147_0 then
		table.insert(STORY_SKIPPED_LIST, STORY.story_id)
	end
	
	print("stop story!!!!", STORY.story_id)
	BackButtonManager:pop({
		check_id = "Story." .. STORY.story_id,
		id = STORY.story_id
	})
	
	STORY.stop = true
	
	if STORY.on_finish and not STORY.is_fadeout then
		print("story on_finish!!! fade_out false!!", STORY.story_id)
		clear_story()
		
		return 
	end
	
	if STORY.is_fadeout then
		SysAction:Add(SEQ(FADE_OUT(400), CALL(clear_story)), STORY.layer)
		
		return 
	end
	
	if STORY.prev_mute and not UIOption:isMute("bgm") then
		SoundEngine:setMute("bgm", false, true)
		
		STORY.prev_mute = nil
	end
	
	setenv("time_scale", STORY.prev_time_scale or 1.2)
	clear_story()
end

function step_story(arg_148_0, arg_148_1)
	STORY_ACTION_MANAGER:onUpdate(arg_148_0)
	STORY_ACTION_MANAGER:onUpdatePortActions(arg_148_0)
	
	if STORY == nil then
		return 
	end
	
	if STORY.actions == nil then
		return 
	end
	
	STORY.cut_opts = STORY.cut_opts or {}
	
	local var_148_0 = STORY.double_speed or STORY.cut_opts.auto_continue
	
	for iter_148_0 = 1, #STORY.actions do
		local var_148_1 = STORY.actions[iter_148_0]
		
		if type(var_148_1.TARGET) == "table" or get_cocos_refid(var_148_1.TARGET) then
			if var_148_1.finished then
				var_148_1.removed = true
			else
				xpcall(var_148_1.Update, __G__TRACKBACK__, var_148_1, nil, arg_148_0)
			end
		else
			var_148_1.removed = true
		end
	end
	
	if STORY.actions == nil then
		return 
	end
	
	for iter_148_1 = #STORY.actions, 1, -1 do
		if STORY.actions[iter_148_1].removed then
			table.remove(STORY.actions, iter_148_1)
		end
	end
	
	if is_using_story_v2() and STORY_ACTION_MANAGER:isStartAction() then
		var_148_0 = false
	end
	
	return #STORY.actions == 0, var_148_0
end

function step_next(arg_149_0)
	arg_149_0 = arg_149_0 or {}
	
	set_high_fps_tick(10000)
	
	local var_149_0 = true
	
	for iter_149_0 = 1, #STORY.actions do
		if not STORY.actions[iter_149_0].finished then
			var_149_0 = nil
		end
	end
	
	if not arg_149_0.force and STORY.cut_opts.select_wait then
		return 
	end
	
	if not arg_149_0.force and STORY.fade_wait then
		return 
	end
	
	if not arg_149_0.force and not var_149_0 then
		if systick() - STORY.begin_tick < 800 then
			return 
		end
		
		if STORY.cut_opts.disable_skip then
			return 
		end
		
		step_story(999999, true)
		
		return 
	end
	
	STORY.cut_opts.auto_continue = nil
	STORY.finish_time = nil
	
	STORY.childs.cursor:setVisible(false)
	SysAction:Remove("story.cursor")
	
	if STORY.clear_action then
		local var_149_1 = Action:create(STORY.clear_action, STORY)
		
		STORY.actions = {
			var_149_1
		}
		STORY.clear_action = nil
		STORY.cut_opts.auto_continue = true
		
		return 
	end
	
	step_next_index()
end

function step_next_index()
	STORY.index = STORY.index + 1
	
	if STORY.index > #STORY.story or #STORY.story[STORY.index] == 0 then
		stop_story()
	else
		setup_cuts(STORY.index)
		step_story(0)
		
		local var_150_0 = false
		local var_150_1 = false
		local var_150_2 = false
		
		for iter_150_0, iter_150_1 in pairs(STORY.story[STORY.index]) do
			if iter_150_1.talker and iter_150_1.talker == "LOCATION" then
				var_150_0 = true
			elseif iter_150_1.talker and iter_150_1.talker == "NARRATION" then
				var_150_1 = true
			elseif iter_150_1.story_action then
				var_150_2 = true
			end
		end
		
		if not var_150_0 and not var_150_1 and not var_150_2 then
			SoundEngine:play("event:/ui/story_next")
		end
	end
end

function skip_to_choice(arg_151_0)
	STORY.double_speed = nil
	
	local var_151_0 = arg_151_0 - 1
	
	if STORY.story[var_151_0] and STORY.index ~= var_151_0 then
		local var_151_1
		local var_151_2
		local var_151_3
		local var_151_4
		local var_151_5
		local var_151_6
		
		for iter_151_0 = 1, var_151_0 - 1 do
			local var_151_7 = STORY.story[iter_151_0]
			
			for iter_151_1, iter_151_2 in pairs(var_151_7) do
				if var_151_1 ~= iter_151_2.balloon then
					var_151_6 = nil
				end
				
				var_151_2 = iter_151_2.left or var_151_2
				var_151_3 = iter_151_2.mid or var_151_3
				var_151_4 = iter_151_2.right or var_151_4
				var_151_5 = iter_151_2.bg or var_151_5
				var_151_6 = iter_151_2.talker or var_151_6
				var_151_1 = iter_151_2.balloon
			end
		end
		
		local var_151_8 = STORY.story[var_151_0][1]
		
		if var_151_8 then
			if var_151_1 ~= var_151_8.balloon then
				var_151_6 = nil
			end
			
			if not var_151_8.left then
				var_151_8.left = var_151_2
			end
			
			if not var_151_8.mid then
				var_151_8.mid = var_151_3
			end
			
			if not var_151_8.right then
				var_151_8.right = var_151_4
			end
			
			if not var_151_8.bg then
				var_151_8.bg = var_151_5
			end
			
			if not var_151_8.talker and not string.starts(var_151_6 or "", "CHAPTER") then
				var_151_8.talker = var_151_6
			end
		end
		
		print("error skip_to_choice", var_151_6)
		setup_cuts(var_151_0)
	end
	
	STORY.index = var_151_0
	
	step_story(99999, true)
	step_next_index()
end

function open_story_esc()
	if not STORY.is_moonlight_th then
		return 
	end
	
	STORY_ACTION_MANAGER:setAllModelAnim(true)
	StoryEsc:open()
end

function exit_story_no_clear()
	STORY.on_finish = nil
	STORY.on_clear = nil
	
	exit_story()
end

function story_key_release(arg_154_0, arg_154_1)
	if not is_playing_story() then
		return 
	end
	
	if (get_cocos_refid(STORY.childs.n_talk) and STORY.childs.n_talk:isVisible() or get_cocos_refid(STORY.childs.n_talk_monologue) and STORY.childs.n_talk_monologue:isVisible() or get_cocos_refid(STORY.childs.n_talk_caption) and STORY.childs.n_talk_caption:isVisible() or get_cocos_refid(STORY.childs.n_talk_clear) and STORY.childs.n_talk_clear:isVisible()) and (arg_154_0 == cc.KeyCode.KEY_ENTER or arg_154_0 == 10 or arg_154_0 == cc.KeyCode.KEY_SPACE) then
		if step_next() then
			stop_story(true)
		end
		
		return true
	end
end

StoryEsc = StoryEsc or {}

function HANDLER.story_esc(arg_155_0, arg_155_1)
	if arg_155_1 == "btn_end_view" then
		StoryEsc:giveUp()
		
		return 
	end
	
	if arg_155_1 == "btn_option" then
		UIOption:show({
			story_mode = true,
			category = "game",
			layer = SceneManager:getRunningPopupScene(),
			close_callback = function()
				if StoryEsc:isInBattle() then
					BattleTopBar:resumeBattle()
				end
			end
		})
		UIOption:bringToFront()
		
		return 
	end
	
	if arg_155_1 == "btn_restart" then
		balloon_message_with_sound("ui_inbattle_esc_restart_error")
		
		return 
	end
	
	if arg_155_1 == "btn_close" or arg_155_1 == "btn_return" then
		if StoryEsc:isInBattle() then
			BattleTopBar:resumeBattle()
		end
		
		StoryEsc:close()
		
		return 
	end
end

function StoryEsc.open(arg_157_0)
	if get_cocos_refid(arg_157_0.wnd) then
		return 
	end
	
	arg_157_0.wnd = load_dlg("inbattle_esc", true, "wnd", function()
		arg_157_0:close()
	end)
	
	arg_157_0.wnd:setName("story_esc")
	
	local var_157_0 = SceneManager:getRunningPopupScene():addChild(arg_157_0.wnd)
	
	arg_157_0.wnd:bringToFront()
	
	if not var_157_0 then
		UIAction:Add(REMOVE(), arg_157_0.wnd, "worldboss")
		
		return 
	end
	
	if_set_visible(arg_157_0.wnd, "n_story", true)
	if_set_opacity(arg_157_0.wnd, "btn_restart", 76.5)
	
	if StoryEsc:isInBattle() then
		BattleTopBar:pauseBattle()
		BattleUI:hideEmojiPanel()
	end
	
	pause()
end

function StoryEsc.isInBattle(arg_159_0)
	return SceneManager:getCurrentSceneName() == "battle"
end

function StoryEsc.giveUp(arg_160_0)
	if StoryEsc:isInBattle() then
		BattleTopBar:giveUp()
	else
		Dialog:msgBox(T("theater_story_close_desc"), {
			yesno = true,
			handler = function()
				arg_160_0:_giveUp()
			end,
			cancel_handler = function()
				if not StoryEsc:isInBattle() then
					BackButtonManager:pop("giveupDialog")
				end
			end,
			yes_text = T("msg_close")
		})
	end
end

function StoryEsc._giveUp(arg_163_0)
	BackButtonManager:pop("giveupDialog")
	Dialog:closeAll()
	arg_163_0:close()
	exit_story_no_clear()
	UIOption:setBlock(false)
	SubStoryMoonlightTheater:updateEp_BGM()
end

function StoryEsc.close(arg_164_0, arg_164_1)
	if not get_cocos_refid(arg_164_0.wnd) then
		return 
	end
	
	local var_164_0 = arg_164_1 or {}
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_164_0.wnd, "block")
	BackButtonManager:pop("story_esc")
	
	arg_164_0.wnd = nil
	
	if StoryEsc:isInBattle() then
		BattleTopBar:resumeBattle()
		Battle:setPause(false)
	end
	
	if not var_164_0.no_resume then
		resume()
	end
	
	STORY_ACTION_MANAGER:setAllModelAnim(false)
end

function StoryEsc.isOpen(arg_165_0)
	if not get_cocos_refid(arg_165_0.wnd) then
		return 
	end
	
	return true
end
