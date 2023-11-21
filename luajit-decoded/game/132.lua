BurningStoryState = {
	OPEN = 2,
	CLEAR = 3,
	LOCK = 1,
	REWARDED = 4
}
SubStoryBurningStory = SubStoryBurningStory or {}

function MsgHandler.burning_story_clear(arg_1_0)
	if not arg_1_0 then
		Log.e("SubStoryBurningStory", "not received story clear result")
		
		return 
	end
	
	if arg_1_0.dec_result then
		Account:addReward(arg_1_0.dec_result)
	end
	
	if arg_1_0.substory_burning_infos then
		Account:setSubStoryBurning(arg_1_0.substory_burning_infos)
	end
	
	if DBT("substory_burning_story", arg_1_0.story_id, {
		"story_type"
	}).story_type == "story" then
		SubStoryBurningStory:_updateAfterQuery(true)
		TopBarNew:topbarUpdate(true)
	else
		ClearResult:show(Battle.logic, {
			preview = true,
			map_id = arg_1_0.enter_id
		})
	end
end

function MsgHandler.burning_reward(arg_2_0)
	if not arg_2_0 then
		Log.e("SubStoryBurningStory", "not received reward result")
		
		return 
	end
	
	if arg_2_0.hidden_rewards then
		Account:addReward(arg_2_0.hidden_rewards)
	end
	
	if arg_2_0.rewards then
		local var_2_0 = {
			title = T("ui_msgbox_rewards_title"),
			desc = T("taked_all")
		}
		
		Account:addReward(arg_2_0.rewards, {
			play_reward_data = var_2_0
		})
	end
	
	if arg_2_0.substory_burning_infos then
		Account:setSubStoryBurning(arg_2_0.substory_burning_infos)
	end
	
	SubStoryBurningStory:_updateAfterQuery(false)
end

function HANDLER.story_paradise(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_watch" then
		SubStoryBurningStory:_onClickWatchBtn(false)
	elseif arg_3_1 == "btn_watch_pay" then
		SubStoryBurningStory:_onClickWatchBtn(true)
	elseif arg_3_1 == "btn_reward" then
		SubStoryBurningStory:_onClickRewardBtn()
	end
end

function SubStoryBurningStory.show(arg_4_0, arg_4_1, arg_4_2)
	if not get_cocos_refid(arg_4_1) then
		Log.e("SubStoryBurningStory", "parent is invalid")
		
		return 
	end
	
	if string.empty(arg_4_2) then
		Log.e("SubStoryBurningStory", "substory_id is empty")
		
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.substory_id = arg_4_2
	arg_4_0.vars.substory_main_db = DBT("substory_main", arg_4_0.vars.substory_id, {
		"token_id1",
		"token_id2",
		"token_id3",
		"banner_icon"
	})
	arg_4_0.vars.wnd = load_dlg("story_paradise", true, "wnd")
	
	arg_4_1:addChild(arg_4_0.vars.wnd)
	
	local var_4_0 = SubStoryUtil:getTopbarCurrencies(arg_4_0.vars.substory_main_db, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:createFromPopup(T("burn_story_title"), arg_4_0.vars.wnd, function()
		SubStoryBurningStory:hide()
	end, var_4_0, "infosubs_1")
	arg_4_0:_initData()
	arg_4_0:_initUI()
	
	if arg_4_0.last_shown_story then
		local var_4_1 = arg_4_0.last_shown_chapter
		local var_4_2 = arg_4_0.last_shown_story
		
		arg_4_0:releaseLastShownStory()
		arg_4_0:_selectStory(var_4_1, var_4_2)
	else
		arg_4_0:_selectStory(arg_4_0:_getPriorityChapter())
	end
	
	TutorialGuide:procGuide()
end

function SubStoryBurningStory.hide(arg_6_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE(), CALL(function()
		arg_6_0.vars = nil
	end)), arg_6_0.vars.wnd, "block")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("burn_story_title"))
	SubStoryLobbyUIBurning:updateOutSide()
	TutorialGuide:onEnterSubstory()
end

function SubStoryBurningStory._initData(arg_8_0)
	arg_8_0.vars.chapter_data = {}
	
	for iter_8_0 = 1, 99999 do
		local var_8_0 = string.format("%s_c%d", arg_8_0.vars.substory_id, iter_8_0)
		local var_8_1 = SLOW_DB_ALL("substory_burning_chapter", var_8_0)
		
		if not var_8_1 or not var_8_1.id then
			break
		end
		
		var_8_1.story_data = {}
		
		for iter_8_1 = 1, 99999 do
			local var_8_2 = string.format("%s_s%d", var_8_1.id, iter_8_1)
			local var_8_3 = SLOW_DB_ALL("substory_burning_story", var_8_2)
			
			if not var_8_3 or not var_8_3.id then
				break
			end
			
			var_8_1.story_data[iter_8_1] = var_8_3
		end
		
		table.sort(var_8_1.story_data, function(arg_9_0, arg_9_1)
			return arg_9_0.sort < arg_9_1.sort
		end)
		
		arg_8_0.vars.chapter_data[iter_8_0] = var_8_1
	end
	
	table.sort(arg_8_0.vars.chapter_data, function(arg_10_0, arg_10_1)
		return arg_10_0.sort < arg_10_1.sort
	end)
	
	for iter_8_2, iter_8_3 in pairs(arg_8_0.vars.chapter_data) do
		iter_8_3.idx = iter_8_2
		iter_8_3.prev = arg_8_0.vars.chapter_data[iter_8_2 - 1]
		
		for iter_8_4, iter_8_5 in pairs(iter_8_3.story_data) do
			iter_8_5.idx = iter_8_4
			iter_8_5.prev = iter_8_3.story_data[iter_8_4 - 1]
			iter_8_5.chapter = iter_8_3
		end
	end
	
	SubstoryManager:setInfo(arg_8_0.vars.substory_id)
	arg_8_0:_updateData()
end

function SubStoryBurningStory._updateData(arg_11_0)
	local var_11_0 = SubstoryManager:getInfo()
	
	if not var_11_0 then
		Log.e("SubStoryBurningStory", "SubstoryManager:getInfo() is invalid")
		
		return 
	end
	
	local var_11_1 = os.time()
	local var_11_2 = var_11_0.start_time
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.chapter_data) do
		iter_11_1.is_open = var_11_1 >= arg_11_0:calcDayToSecond(iter_11_1.open_delay) + var_11_2
		iter_11_1.start_time = var_11_2
		iter_11_1.open_story_idx = -1
		
		for iter_11_2, iter_11_3 in pairs(iter_11_1.story_data) do
			iter_11_3.is_cleared = Account:isBurningStoryCleared(iter_11_1.id, iter_11_3.idx)
			iter_11_3.is_rewarded = Account:isBurningStoryRewarded(iter_11_1.id, iter_11_3.idx)
			
			local var_11_3 = BurningStoryState.LOCK
			
			if iter_11_3.is_rewarded then
				var_11_3 = BurningStoryState.REWARDED
				iter_11_1.open_story_idx = 0
			elseif iter_11_3.is_cleared then
				var_11_3 = BurningStoryState.CLEAR
				iter_11_1.open_story_idx = 0
			else
				local var_11_4 = arg_11_0:_getPrevStory(iter_11_3)
				
				if not var_11_4 or var_11_4.is_cleared then
					var_11_3 = BurningStoryState.OPEN
					iter_11_1.open_story_idx = iter_11_3.idx
				end
			end
			
			iter_11_3.state = var_11_3
		end
	end
end

function SubStoryBurningStory._getSelectedChapter(arg_12_0)
	if arg_12_0.vars.chapter_data then
		return arg_12_0.vars.chapter_data[arg_12_0.vars.selected_chapter_idx]
	end
	
	return nil
end

function SubStoryBurningStory._getPriorityChapter(arg_13_0)
	local var_13_0
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.chapter_data or {}) do
		if iter_13_1.is_open then
			if iter_13_1.open_story_idx > 0 then
				return iter_13_1
			end
			
			var_13_0 = iter_13_1
		end
	end
	
	return var_13_0
end

function SubStoryBurningStory._getSelectedStory(arg_14_0)
	local var_14_0 = arg_14_0:_getSelectedChapter()
	
	if var_14_0 and var_14_0.story_data then
		return var_14_0.story_data[arg_14_0.vars.selected_story_idx]
	end
	
	return nil
end

function SubStoryBurningStory._getPrevStory(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return nil
	end
	
	if arg_15_1.prev then
		return arg_15_1.prev
	end
	
	if arg_15_1.chapter and arg_15_1.chapter.prev then
		local var_15_0 = arg_15_1.chapter.prev.story_data
		
		if var_15_0 then
			return var_15_0[#var_15_0]
		end
	end
	
	return nil
end

function SubStoryBurningStory._isExistRewardableStory(arg_16_0, arg_16_1)
	if arg_16_1 and arg_16_1.story_data then
		for iter_16_0, iter_16_1 in pairs(arg_16_1.story_data) do
			if iter_16_1.state == BurningStoryState.CLEAR then
				return true
			end
		end
	end
	
	return false
end

function SubStoryBurningStory._initUI(arg_17_0)
	if not get_cocos_refid(arg_17_0.vars.wnd) then
		Log.e("SubStoryBurningStory", "wnd is invalid")
		
		return 
	end
	
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("n_bi")
	
	if not get_cocos_refid(var_17_0) then
		Log.e("SubStoryBurningStory", "n_bi not found")
		
		return 
	end
	
	local var_17_1 = arg_17_0.vars.wnd:getChildByName("scrollview_s")
	
	if not get_cocos_refid(var_17_1) then
		Log.e("SubStoryBurningStory", "scrollview_s not found")
		
		return 
	end
	
	local var_17_2 = arg_17_0.vars.wnd:getChildByName("scrollview_ep")
	
	if not get_cocos_refid(var_17_2) then
		Log.e("SubStoryBurningStory", "scrollview_ep not found")
		
		return 
	end
	
	if arg_17_0.vars.substory_main_db and arg_17_0.vars.substory_main_db.banner_icon then
		if_set_sprite(var_17_0, "Sprite_322", "banner/" .. arg_17_0.vars.substory_main_db.banner_icon .. ".png")
	end
	
	local var_17_3 = {}
	
	copy_functions(ScrollView, var_17_3)
	
	function var_17_3.getScrollViewItem(arg_18_0, arg_18_1)
		local var_18_0 = load_control("wnd/story_paradise_main_s_item.csb")
		
		if_set(var_18_0, "title", T(arg_18_1.chapter_category_number))
		
		return var_18_0
	end
	
	function var_17_3.onSelectScrollViewItem(arg_19_0, arg_19_1, arg_19_2)
		arg_17_0:_onSelectChapter(arg_19_2.item)
	end
	
	var_17_3:initScrollView(var_17_1, 176, 78)
	var_17_3:updateScrollViewItems(arg_17_0.vars.chapter_data)
	
	arg_17_0.vars.scroll_chapter = var_17_3
	
	local var_17_4 = {}
	
	copy_functions(ScrollView, var_17_4)
	
	function var_17_4.getScrollViewItem(arg_20_0, arg_20_1)
		local var_20_0 = load_control("wnd/story_paradise_item.csb")
		
		if_set(var_20_0, "t_ep_num", T(arg_20_1.story_category_name))
		if_set(var_20_0, "t_locked", T("burning_story_nope"))
		if_set(var_20_0, "t_able", T("burning_story_yes"))
		if_set(var_20_0, "t_reward", T("buring_story_reward_nope"))
		if_set(var_20_0, "t_complete", T("buring_story_reward_yes"))
		
		return var_20_0
	end
	
	function var_17_4.onSelectScrollViewItem(arg_21_0, arg_21_1, arg_21_2)
		arg_17_0:_onSelectStory(arg_21_2.item)
	end
	
	var_17_4:initScrollView(var_17_2, 185, 86)
	
	arg_17_0.vars.scroll_story = var_17_4
end

function SubStoryBurningStory._updateUI(arg_22_0, arg_22_1)
	if not get_cocos_refid(arg_22_0.vars.wnd) then
		Log.e("SubStoryBurningStory", "wnd is invalid")
		
		return 
	end
	
	if not arg_22_0.vars.scroll_story then
		Log.e("SubStoryBurningStory", "not found scroll_story")
		
		return 
	end
	
	local var_22_0 = arg_22_0:_getSelectedChapter()
	local var_22_1 = arg_22_0:_getSelectedStory()
	
	if not var_22_0 or not var_22_1 then
		Log.e("SubStoryBurningStory", "not found selected data")
		
		return 
	end
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.scroll_story.ScrollViewItems) do
		local var_22_2 = iter_22_1.control
		local var_22_3 = iter_22_1.item
		
		if_set_visible(var_22_2, "_selected", var_22_3.idx == arg_22_0.vars.selected_story_idx)
		if_set_visible(var_22_2, "n_locked", var_22_3.state == BurningStoryState.LOCK)
		if_set_visible(var_22_2, "t_able", var_22_3.state == BurningStoryState.OPEN)
		if_set_visible(var_22_2, "t_reward", var_22_3.state == BurningStoryState.CLEAR)
		if_set_visible(var_22_2, "n_completed", var_22_3.state == BurningStoryState.REWARDED)
	end
	
	if arg_22_1 ~= true and arg_22_0.vars.showing_story == var_22_1 then
		return 
	end
	
	local var_22_4 = arg_22_0.vars.wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_22_4) then
		local var_22_5 = UIUtil:getIllustPath("story/bg/", var_22_1.story_background_img)
		local var_22_6 = var_22_4:getChildByName("sprite")
		
		if not if_set_sprite(var_22_6, nil, var_22_5) then
			var_22_6 = cc.Sprite:create(var_22_5)
			var_22_6 = var_22_6 or cc.Sprite:create("banner/ss_vms01a_poster.png")
			
			var_22_6:setName("sprite")
			var_22_6:setAnchorPoint(0.095, 0.5)
			var_22_6:setPosition(0, 0)
			var_22_6:setScale(1)
			var_22_4:removeAllChildren()
			var_22_4:addChild(var_22_6)
		end
		
		var_22_6:setContentSize(1580, 720)
	end
	
	local var_22_7 = arg_22_0.vars.wnd:getChildByName("n_center")
	
	if get_cocos_refid(var_22_7) then
		var_22_7:removeAllChildren()
		
		local var_22_8, var_22_9 = UIUtil:getPortraitAni(var_22_1.story_character)
		
		if get_cocos_refid(var_22_8) then
			if not var_22_9 then
				var_22_8:setScale(0.8)
				var_22_8:setPosition(-100, 0)
				var_22_8:setOpacity(0)
			else
				var_22_8:setPosition(-100, -400)
				var_22_8:setScale(0.8)
				var_22_8:setOpacity(0)
			end
			
			UIAction:Add(SEQ(LOG(FADE_IN(300))), var_22_8, "port_fade_in")
			var_22_7:addChild(var_22_8)
		end
	end
	
	local var_22_10 = arg_22_0.vars.wnd:getChildByName("n_title")
	
	if get_cocos_refid(var_22_10) then
		if_set(var_22_10, "txt_story_name_s", T(var_22_1.story_title))
		if_set(var_22_10, "txt_story_desc", T(var_22_1.story_desc))
		if_set(var_22_10, "txt_story_name_ep", T("burning_story_reward_pre"))
	end
	
	local var_22_11 = arg_22_0.vars.wnd:getChildByName("reward_item")
	
	if get_cocos_refid(var_22_11) then
		var_22_11:removeAllChildren()
		UIUtil:getRewardIcon(tonumber(var_22_1.reward_value), var_22_1.reward_id, {
			parent = var_22_11
		})
		var_22_11:setOpacity(var_22_1.state == BurningStoryState.REWARDED and 76.5 or 255)
	end
	
	if_set_visible(arg_22_0.vars.wnd, "icon_check", var_22_1.state == BurningStoryState.REWARDED)
	
	local var_22_12 = arg_22_0.vars.wnd:getChildByName("n_get_reward")
	
	if get_cocos_refid(var_22_12) then
		if_set(var_22_12, "txt_reward", T("burning_story_btn_reward"))
		
		local var_22_13 = arg_22_0:_isExistRewardableStory(var_22_0)
		
		var_22_12:setOpacity(var_22_13 and 255 or 76.5)
		if_set_visible(var_22_12, "icon_noti", var_22_13)
	end
	
	local var_22_14 = arg_22_0.vars.wnd:getChildByName("btn_watch")
	
	if get_cocos_refid(var_22_14) then
		if_set(var_22_14, "label", T("burning_story_btn_watch"))
		var_22_14:setVisible(var_22_1.state ~= BurningStoryState.OPEN)
		var_22_14:setOpacity(var_22_1.state == BurningStoryState.LOCK and 76.5 or 255)
	end
	
	SubStoryBurningStory:updateEnterButton()
	
	if var_22_1.bgm then
		local var_22_15 = "event:/bgm/" .. var_22_1.bgm
		
		if not SoundEngine:isPlayingBGM(var_22_15) then
			SoundEngine:playBGM(var_22_15, nil, true)
		end
	end
	
	arg_22_0.vars.showing_story = var_22_1
end

function SubStoryBurningStory._onSelectChapter(arg_23_0, arg_23_1)
	if not arg_23_1 then
		Log.e("SubStoryBurningStory", "chapter is invalid")
		
		return 
	end
	
	if not arg_23_1.is_open then
		local var_23_0 = arg_23_0:calcDayToSecond(arg_23_1.open_delay)
		local var_23_1 = (arg_23_1.start_time or 0) + var_23_0 - os.time()
		
		balloon_message_with_sound("sum23_chapter_block", {
			time = sec_to_full_string(var_23_1)
		})
		
		return 
	end
	
	arg_23_0:_selectStory(arg_23_1)
end

function SubStoryBurningStory._onSelectStory(arg_24_0, arg_24_1)
	if not arg_24_1 then
		Log.e("SubStoryBurningStory", "story is invalid")
		
		return 
	end
	
	arg_24_0:_selectStory(arg_24_1.chapter, arg_24_1)
end

function SubStoryBurningStory._selectStory(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	if not arg_25_1 then
		Log.e("SubStoryBurningStory", "chapter is invalid")
		
		return 
	end
	
	if not arg_25_0.vars.scroll_chapter or not arg_25_0.vars.scroll_story then
		Log.e("SubStoryBurningStory", "not found scroll")
		
		return 
	end
	
	local var_25_0 = arg_25_2 and arg_25_2.idx or arg_25_1.open_story_idx
	
	if var_25_0 == 0 then
		var_25_0 = arg_25_1.story_data[#arg_25_1.story_data].idx
	elseif var_25_0 == -1 then
		var_25_0 = 1
	end
	
	arg_25_4 = arg_25_4 or false
	
	if arg_25_0.vars.selected_chapter_idx ~= arg_25_1.idx then
		arg_25_4 = true
	end
	
	if arg_25_4 then
		for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.scroll_chapter.ScrollViewItems) do
			if_set_opacity(iter_25_1.control, "bg", iter_25_0 == arg_25_1.idx and 255 or 0)
		end
		
		arg_25_0.vars.selected_chapter_idx = arg_25_1.idx
		
		arg_25_0.vars.scroll_story:updateScrollViewItems(arg_25_1.story_data)
		arg_25_0.vars.scroll_story:scrollToIndex(var_25_0)
	end
	
	arg_25_0.vars.selected_story_idx = var_25_0
	
	arg_25_0:_updateUI(arg_25_3)
end

function SubStoryBurningStory._onClickWatchBtn(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0:_getSelectedStory()
	local var_26_1 = arg_26_0:_getSelectedChapter()
	
	if not var_26_0 then
		Log.e("SubStoryBurningStory", "story is invalid")
		
		return 
	end
	
	if not var_26_1 then
		Log.e("SubStoryBurningStory", "chapter is invalid")
		
		return 
	end
	
	if var_26_0.state == BurningStoryState.LOCK then
		balloon_message_with_sound("sum23_story_nope")
		
		return 
	end
	
	if arg_26_1 then
		if var_26_0.state ~= BurningStoryState.OPEN then
			return 
		end
		
		local var_26_2 = Account:getCurrency(var_26_0.token_id)
		
		if not var_26_2 or var_26_2 < tonumber(var_26_0.token_value) then
			UIUtil:wannaBuyStamina(nil)
			
			return 
		end
	elseif var_26_0.state ~= BurningStoryState.CLEAR and var_26_0.state ~= BurningStoryState.REWARDED then
		return 
	end
	
	local function var_26_3()
		arg_26_0:setLastShownStory()
		start_new_story(nil, var_26_0.story_value, {
			force = true,
			on_finish = function()
				query("burning_story_clear", {
					substory_id = arg_26_0.vars.substory_id,
					chapter_id = var_26_1.id,
					story_id = var_26_0.id
				})
			end
		})
	end
	
	local function var_26_4()
		arg_26_0:setLastShownStory()
		arg_26_0:setEnterStoryBattle(true)
		
		local var_29_0 = DB("level_enter", var_26_0.story_value, {
			"npcteam_id1"
		})
		
		query("preview_enter", {
			map = var_26_0.story_value,
			npcteam_id = var_29_0,
			burning_story_id = var_26_0.id
		})
	end
	
	if var_26_0.story_type == "story" then
		var_26_3()
	elseif var_26_0.story_type == "battle" then
		var_26_4()
	end
end

function SubStoryBurningStory._onClickRewardBtn(arg_30_0)
	if arg_30_0:_isExistRewardableStory(arg_30_0:_getSelectedChapter()) then
		query("burning_reward", {
			substory_id = arg_30_0.vars.substory_id,
			chapter_id = arg_30_0:_getSelectedChapter().id
		})
	end
end

function SubStoryBurningStory._updateAfterQuery(arg_31_0, arg_31_1)
	arg_31_0:_updateData()
	
	if arg_31_0.last_shown_story then
		local var_31_0 = arg_31_0.last_shown_chapter
		local var_31_1 = arg_31_0.last_shown_story
		
		arg_31_0:releaseLastShownStory()
		arg_31_0:_selectStory(var_31_0, var_31_1)
	else
		arg_31_0:_selectStory(arg_31_0:_getPriorityChapter(), nil, true, arg_31_1)
	end
end

function SubStoryBurningStory.calcDayToSecond(arg_32_0, arg_32_1)
	return arg_32_1 * 24 * 60 * 60
end

function SubStoryBurningStory.getEnterStoryBattle(arg_33_0)
	return arg_33_0.enter_battle
end

function SubStoryBurningStory.setEnterStoryBattle(arg_34_0, arg_34_1)
	if arg_34_1 == false then
		arg_34_0.enter_battle = nil
	else
		arg_34_0.enter_battle = arg_34_1
	end
end

function SubStoryBurningStory.setLastShownStory(arg_35_0)
	local var_35_0 = arg_35_0:_getSelectedStory()
	
	if var_35_0.state == BurningStoryState.CLEAR or var_35_0.state == BurningStoryState.REWARDED then
		arg_35_0.last_shown_story = var_35_0
		arg_35_0.last_shown_chapter = arg_35_0:_getSelectedChapter()
	end
end

function SubStoryBurningStory.releaseLastShownStory(arg_36_0)
	arg_36_0.last_shown_story = nil
	arg_36_0.last_shown_chapter = nil
end

function SubStoryBurningStory.updateButtons(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0:updateEnterButton()
end

function SubStoryBurningStory.isValid(arg_38_0)
	return arg_38_0.vars and get_cocos_refid(arg_38_0.vars.wnd)
end

function SubStoryBurningStory.updateEnterButton(arg_39_0)
	local var_39_0 = arg_39_0:_getSelectedStory()
	local var_39_1 = arg_39_0.vars.wnd:getChildByName("btn_watch_pay")
	
	if get_cocos_refid(var_39_1) then
		if_set(var_39_1, "label", T("burning_story_btn_watch"))
		
		local var_39_2 = var_39_1:getChildByName("n_token")
		
		if get_cocos_refid(var_39_2) then
			var_39_2:removeAllChildren()
			UIUtil:getRewardIcon(nil, var_39_0.token_id, {
				no_bg = true,
				no_tooltip = true,
				parent = var_39_2
			}):setScale(0.65)
		end
		
		local var_39_3 = var_39_1:getChildByName("label_0")
		
		if get_cocos_refid(var_39_3) then
			local var_39_4 = Account:getCurrency(var_39_0.token_id)
			
			if_set(var_39_1, "label_0", var_39_0.token_value .. "/" .. var_39_4)
		end
		
		var_39_1:setVisible(var_39_0.state == BurningStoryState.OPEN)
	end
end
