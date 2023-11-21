SubStoryLobbyUIBurning = SubStoryLobbyUIBurning or {}

copy_functions(SubStoryLobbyCommon, SubStoryLobbyUIBurning)

local var_0_0 = 400
local var_0_1 = 1500

function HANDLER.dungeon_story_paradise_main(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_prologue" and arg_1_0.prologue_story then
		local function var_1_0()
			return true
		end
		
		SubstoryManager:playPrologue(nil, function()
			if not UIOption:isMute("bgm") then
				SoundEngine:setMute("bgm", false, true)
			end
			
			SubStoryLobbyUIBurning:updateBGM()
		end, var_1_0)
	elseif arg_1_1 == "btn_video" then
		SubstoryUIUtil:onBtnVideo(arg_1_0)
	elseif arg_1_1 == "btn_event" then
		if arg_1_0.link then
			movetoPath(arg_1_0.link)
		end
	elseif arg_1_1 == "btn_mileage" then
		if arg_1_0.is_open then
			SubStoryLobbyUIBurning:openShop()
		else
			balloon_message_with_sound_raw_text(T("burn_contents_lock", {
				name = T(arg_1_0.story_title)
			}))
		end
	elseif arg_1_1 == "btn_event_battle" then
		if arg_1_0.is_closed then
			balloon_message_with_sound("end_sub_story_event")
		elseif arg_1_0.is_open then
			SubStoryLobbyUIBurning:onEnterBurningDungeon()
		else
			balloon_message_with_sound_raw_text(T("burn_contents_lock", {
				name = T(arg_1_0.story_title)
			}))
		end
	elseif arg_1_1 == "btn_event_story" then
		if arg_1_0.is_closed then
			balloon_message_with_sound("end_sub_story_event")
		else
			SubStoryLobbyUIBurning:onEnterBurningStory()
		end
	elseif arg_1_1 == "r_arrow" then
		SubStoryLobbyUIBurning:moveStoryIdx(true)
	elseif arg_1_1 == "l_arrow" then
		SubStoryLobbyUIBurning:moveStoryIdx(false)
	elseif arg_1_1 == "btn_center" then
		SubStoryLobbyUIBurning:touchBalloon()
	elseif arg_1_1 == "btn_bonus" then
		Substory_ArtBouns:open()
	end
end

function SubStoryLobbyUIBurning.onEnterBurningDungeon(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	SubStoryBurningDungeon:show(arg_4_0.vars.wnd, arg_4_0.vars.substory_id, arg_4_0.vars.cur_data.eventbattle_id)
end

function SubStoryLobbyUIBurning.onEnterBurningStory(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	SubStoryBurningStory:show(arg_5_0.vars.wnd, arg_5_0.vars.substory_id)
end

function SubStoryLobbyUIBurning.onEnterUI(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = arg_6_1
	arg_6_0.vars.info = arg_6_2
	arg_6_0.vars.substory_id = arg_6_2.id
	arg_6_0.vars.balloon_timmer = os.time()
	arg_6_0.vars.balloon_delay = 20
	
	local var_6_0 = SubStoryUtil:getEventState(arg_6_2.start_time, arg_6_2.end_time)
	
	if_set(arg_6_0.vars.wnd, "t_boss_name", T(arg_6_2.name))
	if_set_visible(arg_6_0.vars.wnd, "n_preview", var_6_0 == SUBSTORY_CONSTANTS.STATE_READY)
	if_set_visible(arg_6_0.vars.wnd, "n_common", var_6_0 == SUBSTORY_CONSTANTS.STATE_OPEN)
	if_set_visible(arg_6_0.vars.wnd, "n_close", var_6_0 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON)
	
	local var_6_1 = arg_6_2.start_time
	local var_6_2 = arg_6_2.end_time
	
	if not arg_6_0:getContentsDB(arg_6_2.id) then
		Log.e("no_contents_db", "need_data")
	end
	
	arg_6_0:updateRemainTime()
	
	local var_6_3 = arg_6_2.shop_schedule == nil or SubstoryManager:isOpenSubstoryShop(arg_6_2.shop_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	local var_6_4 = var_6_0 ~= SUBSTORY_CONSTANTS.STATE_READY and arg_6_2.category and var_6_3
	
	if_set_visible(arg_6_0.vars.wnd, "btn_shop", var_6_4)
	if_set_visible(arg_6_0.vars.wnd, "btn_achieve", arg_6_2.achieve_flag and arg_6_2.achieve_flag == "y" and var_6_0 == SUBSTORY_CONSTANTS.STATE_OPEN)
	
	local var_6_5 = SubStoryUtil:getTopbarCurrencies(arg_6_2, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:setCurrencies(var_6_5)
	TopBarNew:checkhelpbuttonID("infosubs_1")
	
	local var_6_6 = arg_6_0.vars.info.prologue_story
	local var_6_7 = arg_6_0.vars.wnd:getChildByName("btn_prologue")
	
	if get_cocos_refid(var_6_7) then
		if var_6_6 then
			var_6_7:setVisible(true)
			
			var_6_7.prologue_story = var_6_6
		else
			var_6_7:setVisible(false)
		end
	end
	
	local var_6_8 = arg_6_0.vars.wnd:getChildByName("n_btn_blue")
	local var_6_9 = arg_6_0.vars.wnd:getChildByName("n_btn_yellow")
	
	var_6_9:setVisible(true)
	var_6_8:setVisible(true)
	
	arg_6_0.vars.btn_mileage = var_6_8:getChildByName("btn_mileage")
	arg_6_0.vars.icon_mileage_lock = var_6_8:getChildByName("icon_mileage_lock")
	arg_6_0.vars.btn_event_battle = var_6_8:getChildByName("btn_event_battle")
	arg_6_0.vars.icon_event_battle_lock = var_6_8:getChildByName("icon_event_battle_lock")
	arg_6_0.vars.btn_event_story = var_6_9:getChildByName("btn_event_story")
	
	if var_6_0 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON then
		arg_6_0.vars.btn_event_battle.is_closed = true
		arg_6_0.vars.btn_event_story.is_closed = true
	end
	
	if_set_visible(var_6_8, "btn_event_story", false)
	if_set_visible(var_6_9, "btn_mileage", false)
	if_set_visible(var_6_9, "icon_mileage_lock", false)
	if_set_visible(var_6_9, "btn_event_battle", false)
	if_set_visible(var_6_9, "icon_event_battle_lock", false)
	
	local var_6_10 = Account:getSubStoryScheduleDBById(arg_6_0.vars.substory_id)
	local var_6_11 = SubstoryUIUtil:load_link_url(var_6_10, "link")
	local var_6_12 = SubstoryUIUtil:load_link_url(var_6_10, "web_event")
	local var_6_13 = SubstoryUIUtil:setLayoutData(arg_6_0.vars.wnd, "btn_video", var_6_11, "link")
	local var_6_14 = SubstoryUIUtil:setLayoutData(arg_6_0.vars.wnd, "btn_event", var_6_12, "link")
	
	if get_cocos_refid(var_6_13) and var_6_11 and var_6_11.link then
		var_6_13:setVisible(true)
		
		arg_6_0.vars.link = var_6_11.link
	end
	
	local var_6_15 = arg_6_0.vars.wnd:getChildByName("LEFT")
	local var_6_16 = arg_6_0.vars.info.start_time
	local var_6_17 = arg_6_0.vars.info.end_time
	
	if_set(var_6_15, "t_disc", T("ui_dungeon_story_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_6_16,
		end_time = var_6_17
	})))
	
	local var_6_18 = arg_6_0.vars.wnd:getChildByName("n_bi")
	
	if var_6_18 then
		if_set_sprite(var_6_18, "Sprite_322", arg_6_0.vars.info.banner_icon .. ".png")
	end
	
	arg_6_0:initData()
	arg_6_0:updateCurData()
	
	local var_6_19 = SubStoryBurningStory:getEnterStoryBattle()
	local var_6_20, var_6_21, var_6_22 = SubStoryBurningDungeon:getEnterDungeonBattle()
	
	if Account:isBurningStoryCleared("vsu3aa_c1", 8) and not TutorialGuide:isClearedTutorial("summer2023_contents") or SubStoryLobbyUIBurning:isNextChapterEnterable() and not TutorialGuide:isClearedTutorial("summer2023_curtain") or var_6_0 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON then
		var_6_19 = false
		var_6_20 = false
		
		SubStoryBurningStory:setEnterStoryBattle(false)
		SubStoryBurningDungeon:setEnterDungeonBattle(false)
	end
	
	if var_6_19 then
		SubStoryBurningStory:setEnterStoryBattle(false)
		arg_6_0:onEnterBurningStory()
	elseif var_6_20 then
		arg_6_0.vars.substory_id = var_6_21
		arg_6_0.vars.cur_data.eventbattle_id = var_6_22
		
		SubStoryBurningDungeon:setEnterDungeonBattle(false)
		arg_6_0:onEnterBurningDungeon()
	end
	
	arg_6_0:showEnterBalloon()
end

function SubStoryLobbyUIBurning.isCloseSoon(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) or not arg_7_0.vars.info then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.info
	
	return SubStoryUtil:getEventState(var_7_0.start_time, var_7_0.end_time) == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON
end

function SubStoryLobbyUIBurning.isNextChapterEnterable(arg_8_0)
	if not arg_8_0.vars or not arg_8_0.vars.data or not arg_8_0.vars.data[2] then
		return 
	end
	
	return arg_8_0.vars.data[2].is_open
end

function SubStoryLobbyUIBurning.getInfo(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	return arg_9_0.vars.info
end

function SubStoryLobbyUIBurning.initData(arg_10_0)
	arg_10_0.vars.data = {}
	arg_10_0.vars.cur_id = nil
	arg_10_0.vars.cur_idx = 1
	arg_10_0.vars.prev_id = nil
	arg_10_0.vars.max_idx = 0
	
	local var_10_0 = SAVE:get("sb_summer_chapter_id")
	
	for iter_10_0 = 1, 99999 do
		local var_10_1 = arg_10_0:getContentsDB(arg_10_0.vars.substory_id .. "_" .. iter_10_0)
		
		if not var_10_1 or table.empty(var_10_1) then
			break
		end
		
		var_10_1.is_open = SubstoryManager:isActiveSchedule(var_10_1.schedule_id) or SubstoryManager:checkEndEvent()
		
		if var_10_1.is_open and var_10_1.open_story then
			local var_10_2 = string.split(var_10_1.open_story, "_")
			local var_10_3 = tonumber(string.sub(var_10_1.open_story, -1))
			
			var_10_1.is_open = Account:isBurningStoryCleared(var_10_2[1] .. "_" .. var_10_2[2], var_10_3)
		end
		
		if DEBUG.MAP_DEBUG then
			var_10_1.is_open = true
		end
		
		if not arg_10_0.vars.cur_id and var_10_1.is_open then
			arg_10_0.vars.cur_id = var_10_1.id
			arg_10_0.vars.cur_idx = iter_10_0
		end
		
		if var_10_1.is_open and var_10_0 and var_10_0 == var_10_1.id then
			arg_10_0.vars.cur_id = var_10_1.id
			arg_10_0.vars.cur_idx = iter_10_0
		end
		
		table.insert(arg_10_0.vars.data, var_10_1)
	end
	
	arg_10_0.vars.max_idx = table.count(arg_10_0.vars.data)
end

function SubStoryLobbyUIBurning.moveStoryIdx(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.vars.cur_idx
	
	if arg_11_1 then
		var_11_0 = var_11_0 + 1
	else
		var_11_0 = var_11_0 - 1
	end
	
	if var_11_0 < 1 or var_11_0 > arg_11_0.vars.max_idx then
		return 
	end
	
	local var_11_1 = false
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.data) do
		if iter_11_0 == var_11_0 then
			arg_11_0.vars.cur_idx = iter_11_0
			arg_11_0.vars.cur_id = iter_11_1.id
			var_11_1 = true
			
			break
		end
	end
	
	if not var_11_1 then
		return 
	end
	
	arg_11_0:updateCurData()
	arg_11_0:updateUI()
	UIAction:Remove("enter_balloon")
	UIAction:Remove("idle_balloon")
	UIAction:Remove("touch_balloon")
	arg_11_0:showEnterBalloon()
	SubstoryBurningShop:moveStoryIdx(arg_11_0.vars.cur_id, arg_11_0.vars.cur_data.shop_equip_id)
	TutorialGuide:procGuide()
end

function SubStoryLobbyUIBurning.checkArrowBtnOnEnterShop(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) or not arg_12_0.vars.data then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.data[arg_12_0.vars.cur_idx + 1]
	local var_12_1 = arg_12_0.vars.data[arg_12_0.vars.cur_idx - 1]
	
	if var_12_0 and var_12_0.contents_open then
		local var_12_2 = string.split(var_12_0.contents_open, "_")
		local var_12_3 = tonumber(string.sub(var_12_0.contents_open, -1))
		local var_12_4 = Account:isBurningStoryCleared(var_12_2[1] .. "_" .. var_12_2[2], var_12_3)
		
		if_set_visible(arg_12_0.vars.wnd, "r_arrow", var_12_4)
	end
	
	if var_12_1 and var_12_1.contents_open then
		local var_12_5 = string.split(var_12_1.contents_open, "_")
		local var_12_6 = tonumber(string.sub(var_12_1.contents_open, -1))
		local var_12_7 = Account:isBurningStoryCleared(var_12_5[1] .. "_" .. var_12_5[2], var_12_6)
		
		if_set_visible(arg_12_0.vars.wnd, "l_arrow", var_12_7)
	end
end

function SubStoryLobbyUIBurning.updateOutSide(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) or not arg_13_0.vars.data then
		return 
	end
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.data) do
		if not iter_13_1.is_open and iter_13_1.open_story then
			iter_13_1.is_open = SubstoryManager:isActiveSchedule(iter_13_1.schedule_id) or SubstoryManager:checkEndEvent()
			
			if iter_13_1.is_open then
				local var_13_0 = string.split(iter_13_1.open_story, "_")
				local var_13_1 = tonumber(string.sub(iter_13_1.open_story, -1))
				
				iter_13_1.is_open = Account:isBurningStoryCleared(var_13_0[1] .. "_" .. var_13_0[2], var_13_1)
			end
		end
	end
	
	arg_13_0:updateBGM()
	arg_13_0:updateButtons()
end

function SubStoryLobbyUIBurning.openShop(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	arg_14_0:setVisibleSpecificUI(false)
	arg_14_0:checkArrowBtnOnEnterShop()
	SubstoryBurningShop:show({
		parent = arg_14_0.vars.wnd,
		id = arg_14_0.vars.cur_id,
		shop_equip_id = arg_14_0.vars.cur_data.shop_equip_id
	})
end

function SubStoryLobbyUIBurning.setVisibleSpecificUI(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("LEFT")
	local var_15_1 = {
		"btn_prologue",
		"btn_video",
		"btn_event",
		"btn_bonus",
		"n_bi",
		"grow",
		"t_disc"
	}
	
	if not arg_15_0.vars.init_btn_opacity then
		arg_15_0.vars.init_btn_opacity = true
		
		for iter_15_0, iter_15_1 in pairs(var_15_1) do
			local var_15_2 = var_15_0:getChildByName(iter_15_1) or arg_15_0.vars.wnd:getChildByName(iter_15_1)
			
			if get_cocos_refid(var_15_2) then
				if iter_15_1 == "grow" then
					var_15_2.origin_opacity = 0.4
				else
					var_15_2.origin_opacity = 1
				end
			end
		end
	end
	
	local var_15_3 = 300
	
	if arg_15_1 then
		for iter_15_2, iter_15_3 in pairs(var_15_1) do
			local var_15_4 = var_15_0:getChildByName(iter_15_3) or arg_15_0.vars.wnd:getChildByName(iter_15_3)
			
			if get_cocos_refid(var_15_4) then
				local var_15_5 = var_15_4.origin_opacity or 255
				
				UIAction:Add(SEQ(LOG(OPACITY(var_15_3, 0, var_15_5))), var_15_4, "block")
			end
		end
		
		UIAction:Add(SEQ(FADE_IN(var_15_3)), arg_15_0.vars.wnd:getChildByName("n_btn_blue"), "block")
		UIAction:Add(SEQ(FADE_IN(var_15_3)), arg_15_0.vars.wnd:getChildByName("n_btn_yellow"), "block")
	else
		for iter_15_4, iter_15_5 in pairs(var_15_1) do
			local var_15_6 = var_15_0:getChildByName(iter_15_5) or arg_15_0.vars.wnd:getChildByName(iter_15_5)
			
			if get_cocos_refid(var_15_6) then
				local var_15_7 = var_15_6.origin_opacity or 255
				
				UIAction:Add(SEQ(LOG(OPACITY(var_15_3, var_15_7, 0))), var_15_6, "block")
			end
		end
		
		UIAction:Add(SEQ(FADE_OUT(var_15_3)), arg_15_0.vars.wnd:getChildByName("n_btn_blue"), "block")
		UIAction:Add(SEQ(FADE_OUT(var_15_3)), arg_15_0.vars.wnd:getChildByName("n_btn_yellow"), "block")
	end
end

function SubStoryLobbyUIBurning.updateCurData(arg_16_0)
	arg_16_0.vars.cur_data = arg_16_0.vars.data[arg_16_0.vars.cur_idx]
	
	if arg_16_0.vars.cur_data then
		SAVE:set("sb_summer_chapter_id", arg_16_0.vars.cur_data.id)
	end
end

function SubStoryLobbyUIBurning.updateUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	SubstoryUIUtil:updateNotifier(arg_17_0.vars.wnd)
	
	if arg_17_0.vars.prev_id == arg_17_0.vars.cur_id then
		return 
	end
	
	local var_17_0
	
	if arg_17_0.vars.prev_idx then
		var_17_0 = arg_17_0.vars.cur_idx > arg_17_0.vars.prev_idx
	end
	
	arg_17_0.vars.prev_id = arg_17_0.vars.cur_id
	arg_17_0.vars.prev_idx = arg_17_0.vars.cur_idx
	
	arg_17_0:updateBG(var_17_0)
	arg_17_0:updateButtons()
	arg_17_0:updatePortrait()
	arg_17_0:updateBGM()
end

function SubStoryLobbyUIBurning.updatePortrait(arg_18_0)
end

function SubStoryLobbyUIBurning.updateBG(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.vars.cur_data.bg
	
	if string.starts(var_19_0, "eff") then
		local var_19_1 = string.split(var_19_0, "=")[2]
		local var_19_2 = EffectManager:Play({
			pivot_x = 0,
			pivot_y = 0,
			pivot_z = 999,
			fn = var_19_1,
			layer = arg_19_0.vars.wnd:getChildByName("n_bg")
		})
		
		if not var_19_2 then
			return 
		end
		
		var_19_2:setAnchorPoint(0.5, 0.5)
		var_19_2:setPositionX(DESIGN_WIDTH / 2)
		
		arg_19_0.vars.cur_bg = var_19_2
		
		var_19_2:setVisible(false)
	end
	
	if arg_19_0.vars.prev_bg then
		arg_19_0.vars.cur_bg:setOpacity(0)
		arg_19_0.vars.prev_bg:setOpacity(255)
		
		local var_19_3 = var_0_0
		local var_19_4 = 1200
		local var_19_5 = 0
		
		if arg_19_1 == true then
			UIAction:Add(SEQ(SLIDE_OUT(var_19_3, var_19_4 * -1), REMOVE()), arg_19_0.vars.prev_bg, "block")
			UIAction:Add(SEQ(DELAY(var_19_5), SLIDE_IN(var_19_3, var_19_4 * -1)), arg_19_0.vars.cur_bg, "block")
		elseif arg_19_1 == false then
			UIAction:Add(SEQ(SLIDE_OUT(var_19_3, var_19_4 * 1), REMOVE()), arg_19_0.vars.prev_bg, "block")
			UIAction:Add(SEQ(DELAY(var_19_5), SLIDE_IN(var_19_3, var_19_4 * 1)), arg_19_0.vars.cur_bg, "block")
		end
	else
		arg_19_0.vars.cur_bg:setVisible(true)
	end
	
	arg_19_0.vars.prev_bg = arg_19_0.vars.cur_bg
end

function SubStoryLobbyUIBurning.canEnterableNext(arg_20_0)
	if not arg_20_0.vars or not arg_20_0.vars.cur_idx then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.cur_idx + 1
	
	return arg_20_0.vars.data[var_20_0] and arg_20_0.vars.data[var_20_0].is_open
end

function SubStoryLobbyUIBurning.updateButtons(arg_21_0)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.vars.wnd) then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.wnd:getChildByName("l_arrow")
	local var_21_1 = arg_21_0.vars.wnd:getChildByName("r_arrow")
	
	if_set_visible(arg_21_0.vars.wnd, "l_arrow", arg_21_0.vars.cur_idx > 1)
	
	local var_21_2 = arg_21_0:canEnterableNext()
	
	if_set_visible(arg_21_0.vars.wnd, "r_arrow", var_21_2)
	
	local var_21_3 = arg_21_0.vars.cur_data
	local var_21_4 = arg_21_0.vars.btn_mileage
	local var_21_5 = arg_21_0.vars.btn_event_battle
	local var_21_6 = arg_21_0.vars.btn_event_story
	local var_21_7 = arg_21_0.vars.icon_mileage_lock
	local var_21_8 = arg_21_0.vars.icon_event_battle_lock
	local var_21_9 = var_21_3.contents_open
	local var_21_10 = false
	local var_21_11 = false
	
	if var_21_9 then
		local var_21_12 = string.split(var_21_9, "_")
		local var_21_13 = tonumber(string.sub(var_21_9, -1))
		local var_21_14 = Account:isBurningStoryCleared(var_21_12[1] .. "_" .. var_21_12[2], var_21_13)
		
		var_21_10 = var_21_14
		var_21_11 = var_21_14
		
		local var_21_15 = DB("substory_burning_story", var_21_9, {
			"story_title"
		})
		
		var_21_4.story_title = var_21_15
		var_21_5.story_title = var_21_15
	end
	
	if_set(var_21_4, "label", T(var_21_3.shop_name))
	if_set(var_21_5, "label", T(var_21_3.eventbattle_name))
	
	if var_21_11 then
		if_set_opacity(var_21_4, nil, 255)
		if_set_visible(var_21_7, nil, false)
		
		var_21_4.is_open = true
	else
		if_set_opacity(var_21_4, nil, 76.5)
		if_set_visible(var_21_7, nil, true)
		
		var_21_4.is_open = false
	end
	
	if var_21_10 then
		if_set_opacity(var_21_5, nil, 255)
		if_set_visible(var_21_8, nil, false)
		
		var_21_5.is_open = true
	else
		if_set_opacity(var_21_5, nil, 76.5)
		if_set_visible(var_21_8, nil, true)
		
		var_21_5.is_open = false
	end
	
	if DEBUG.MAP_DEBUG then
		var_21_5.is_open = true
		var_21_4.is_open = true
	end
	
	if var_21_6.is_closed then
		var_21_6.is_open = false
		
		if_set_opacity(var_21_6, nil, 76.5)
	end
	
	if var_21_5.is_closed then
		var_21_5.is_open = false
		
		if_set_opacity(var_21_5, nil, 76.5)
	end
end

function SubStoryLobbyUIBurning.playNPCSound(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	for iter_22_0 = 1, UIUtil.NPC_BALLON_MAX_TEXT_ID_COUNT + 1 do
		local var_22_0 = math.random(1, UIUtil.NPC_BALLON_MAX_TEXT_ID_COUNT)
		local var_22_1, var_22_2 = DB("npc_balloon", arg_22_1, {
			"sound_effect_" .. var_22_0,
			"text_id_" .. var_22_0
		})
		
		if var_22_1 then
			UIAction:Add(SEQ(DELAY(arg_22_2 or 0), CALL(function()
				if arg_22_0.vars and get_cocos_refid(arg_22_0.vars.wnd) and (SubStoryLobbyUIBurning:isCloseSoon() or TutorialGuide:isClearedTutorial("summer2023_intro")) then
					arg_22_0.vars.balloon_sound = SoundEngine:play("event:/" .. var_22_1)
				end
			end)), arg_22_0)
			
			return var_22_2
		end
		
		if var_22_2 then
			return var_22_2
		end
	end
end

function SubStoryLobbyUIBurning._showIdleBalloon(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.wnd) or not arg_24_1 or not arg_24_3 or TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if SubStoryBurningDungeon:isValid() or SubStoryBurningStory:isValid() or BurningReady:isShow() or is_playing_story() or not arg_24_0.vars.n_balloon then
		return 
	end
	
	arg_24_0.vars.n_balloon:setVisible(true)
	
	local var_24_0 = arg_24_0.vars.n_balloon
	local var_24_1 = var_24_0:getChildByName("txt_balloon")
	local var_24_2 = var_24_0:getChildByName("balloon_bg")
	local var_24_3 = 1
	local var_24_4
	
	var_24_4 = arg_24_2 or 0
	
	local var_24_5
	
	var_24_5 = arg_24_4 or 0
	
	local var_24_6 = 0
	local var_24_7 = 0
	local var_24_8 = SubStoryLobbyUIBurning:playNPCSound(arg_24_1, var_24_6)
	
	if not var_24_8 then
		return 
	end
	
	local var_24_9 = T(var_24_8)
	
	if get_cocos_refid(arg_24_0.vars.balloon_sound) and arg_24_0.vars.balloon_sound.stop then
		arg_24_0.vars.balloon_sound:stop()
	end
	
	UIUserData:call(var_24_2, "AUTOSIZE_HEIGHT(../txt_balloon, 1, 80)")
	UIUtil:updateTextWrapMode(var_24_1, var_24_9, 20)
	if_set(var_24_1, nil, "")
	var_24_0:setScale(0)
	var_24_0:setOpacity(255)
	UIAction:Add(SEQ(DELAY(var_24_6), LOG(SCALE(150, 0, var_24_3 * 1.1)), DELAY(50), RLOG(SCALE(80, var_24_3 * 1.1, var_24_3)), TARGET(var_24_1, SOUND_TEXT(var_24_9, true)), DELAY(var_0_1), FADE_OUT(300), DELAY(var_24_7)), var_24_0, arg_24_3)
end

function SubStoryLobbyUIBurning.initBalloon(arg_25_0)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.cur_data
	local var_25_1 = var_25_0.balloon_position
	local var_25_2 = string.split(var_25_1, ",")
	
	arg_25_0.vars.n_balloon = arg_25_0.vars.wnd:getChildByName(var_25_0.balloon_type)
	
	if_set_visible(arg_25_0.vars.wnd, "n_balloon", false)
	if_set_visible(arg_25_0.vars.wnd, "n_balloon_2", false)
	if_set_visible(arg_25_0.vars.wnd, "n_balloon_3", false)
	
	if not get_cocos_refid(arg_25_0.vars.n_balloon) then
		return 
	end
	
	arg_25_0.vars.n_balloon:setVisible(false)
	arg_25_0.vars.n_balloon:setPosition(tonumber(var_25_2[1] or 0), tonumber(var_25_2[2] or 0))
end

function SubStoryLobbyUIBurning.showEnterBalloon(arg_26_0)
	UIAction:Remove("enter_balloon")
	UIAction:Remove("idle_balloon")
	UIAction:Remove("touch_balloon")
	UIAction:Remove("shop_balloon")
	arg_26_0:initBalloon()
	
	local var_26_0 = arg_26_0.vars.cur_data
	
	arg_26_0:_showIdleBalloon(var_26_0.balloon_enter, var_0_0 + 300, "enter_balloon", 1000)
	arg_26_0:initIdleBalloon()
end

function SubStoryLobbyUIBurning.shopBuyBalloon(arg_27_0, arg_27_1)
	if not arg_27_1 then
		return 
	end
	
	UIAction:Remove("enter_balloon")
	UIAction:Remove("idle_balloon")
	UIAction:Remove("touch_balloon")
	UIAction:Remove("shop_balloon")
	arg_27_0:_showIdleBalloon(arg_27_1, 0, "shop_balloon")
end

function SubStoryLobbyUIBurning.touchBalloon(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	if UIAction:Find("touch_balloon") or UIAction:Find("shop_balloon") then
		return 
	end
	
	UIAction:Remove("enter_balloon")
	UIAction:Remove("idle_balloon")
	UIAction:Remove("touch_balloon")
	UIAction:Remove("shop_balloon")
	
	arg_28_0.vars.balloon_timmer = os.time()
	
	local var_28_0 = arg_28_0.vars.cur_data
	
	arg_28_0:_showIdleBalloon(var_28_0.balloon_touch, 1000, "touch_balloon", 2000)
end

function SubStoryLobbyUIBurning.initIdleBalloon(arg_29_0)
	if Scheduler:findByName("idle_balloon") then
		Scheduler:removeByName("idle_balloon")
	end
	
	Scheduler:add(arg_29_0.vars.wnd, arg_29_0.showIdleBalloon, arg_29_0):setName("idle_balloon")
end

function SubStoryLobbyUIBurning.showIdleBalloon(arg_30_0)
	if UIAction:Find("enter_balloon") or UIAction:Find("idle_balloon") or UIAction:Find("touch_balloon") or UIAction:Find("shop_balloon") then
		return 
	end
	
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		Scheduler:removeByName("idle_balloon")
		
		return 
	end
	
	if not arg_30_0.vars.balloon_timmer then
		arg_30_0.vars.balloon_timmer = os.time()
	end
	
	if os.time() - arg_30_0.vars.balloon_timmer >= arg_30_0.vars.balloon_delay then
		arg_30_0.vars.balloon_timmer = os.time()
		
		local var_30_0 = arg_30_0.vars.cur_data
		
		arg_30_0:_showIdleBalloon(var_30_0.balloon_idle, var_0_0 + 200, "idle_balloon")
	end
end

function SubStoryLobbyUIBurning.updateBGM(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) or not arg_31_0.vars.cur_data then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.cur_data.bgm
	
	SoundEngine:playBGM("event:/bgm/" .. var_31_0)
end

function SubStoryLobbyUIBurning.refreshBGM(arg_32_0)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.wnd) or not arg_32_0.vars.cur_data then
		return 
	end
	
	arg_32_0:updateBGM()
	
	arg_32_0.vars.balloon_timmer = os.time()
	
	arg_32_0:initIdleBalloon()
	
	local var_32_0 = arg_32_0.vars.cur_data
	
	arg_32_0:initBalloon()
	arg_32_0:_showIdleBalloon(var_32_0.balloon_idle, var_0_0 + 200, "idle_balloon")
end

function SubStoryLobbyUIBurning.pauseSound(arg_33_0)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) then
		return 
	end
	
	if Scheduler:findByName("idle_balloon") then
		Scheduler:removeByName("idle_balloon")
	end
	
	if get_cocos_refid(arg_33_0.vars.balloon_sound) and arg_33_0.vars.balloon_sound.stop then
		arg_33_0.vars.balloon_sound:stop()
	end
end

function SubStoryLobbyUIBurning.getContentsDB(arg_34_0, arg_34_1)
	return (DBT("substory_burning_main", arg_34_1, {
		"id",
		"schedule_id",
		"bg",
		"bgm",
		"open_story",
		"balloon_enter",
		"balloon_idle",
		"balloon_touch",
		"balloon_type",
		"balloon_position",
		"eventbattle_id",
		"eventbattle_name",
		"shop_id",
		"shop_name",
		"contents_open",
		"shop_gift_token",
		"shop_gift_value",
		"shop_gift_ticket",
		"shop_equip_token",
		"shop_equip_value",
		"shop_equip_id",
		"balloon_equip",
		"balloon_equip_count",
		"eventbattle_open",
		"shop_open"
	}))
end

function SubStoryLobbyUIBurning.updateEnterQueryUI(arg_35_0, arg_35_1)
	if not arg_35_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
end

function SubStoryLobbyUIBurning.hideBG(arg_36_0)
	if Scheduler:findByName("idle_balloon") then
		Scheduler:removeByName("idle_balloon")
	end
end
