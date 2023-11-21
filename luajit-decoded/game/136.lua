EP_REWARD_STATE = {}
EP_REWARD_STATE.ACTIVE = 0
EP_REWARD_STATE.CLEAR = 1
EP_REWARD_STATE.REWARDED = 2

local var_0_0 = 1

SubStoryMoonlightTheater = SubStoryMoonlightTheater or {}

function MsgHandler.moonlight_theater_reward(arg_1_0)
	if arg_1_0 then
		if arg_1_0.change_ep_infos then
			for iter_1_0, iter_1_1 in pairs(arg_1_0.change_ep_infos) do
				Account:set_mt_ep_info(iter_1_1.episode_id, iter_1_1)
			end
		end
		
		if arg_1_0.rewards then
			local var_1_0 = "ticketspecial"
			local var_1_1 = arg_1_0.rewards[var_1_0] - Account:getPropertyCount(var_1_0)
			
			Account:addReward(arg_1_0.rewards)
			
			local var_1_2 = {
				{
					token = var_1_0,
					count = var_1_1
				}
			}
			local var_1_3 = Dialog:msgRewards(T("theater_reward_desc"), {
				rewards = var_1_2
			})
			
			if_set(var_1_3, "txt_title", T("theater_reward_title"))
		end
		
		SubStoryMoonlightTheater:res_ep_rewards(arg_1_0)
	end
end

function MsgHandler.moonlight_theater_story_clear(arg_2_0)
	local var_2_0 = false
	
	if arg_2_0 then
		var_2_0 = Account:isCleared_mlt_ep(arg_2_0.episode_id)
		
		Account:set_mt_ep_info(arg_2_0.episode_id, arg_2_0.mt_episode_info)
	end
	
	SubStoryMoonlightTheater:afterUpdateEndEpisode()
	SubStoryMoonlightTheater:onUpdateEPtime()
	SubStoryMoonlightTheater:afterUpadteEndStory(var_2_0)
	
	if not var_2_0 then
		MoonlightDestiny:onMoonlightTheaterStoryFirstClear(arg_2_0.episode_id)
	end
end

function MsgHandler.moonlight_theater_battle_clear(arg_3_0)
	local var_3_0 = {
		map_id = arg_3_0.enter_id
	}
	
	var_3_0.preview = true
	
	if arg_3_0.mt_episode_info and arg_3_0.mt_episode_id then
		Account:set_mt_ep_info(arg_3_0.mt_episode_id, arg_3_0.mt_episode_info)
	end
	
	ClearResult:show(Battle.logic, var_3_0)
end

function MsgHandler.moonlight_theater_unlock_story(arg_4_0)
	if arg_4_0 then
		Account:set_mt_ep_info(arg_4_0.mt_episode_id, arg_4_0.mt_episode_info)
		
		if arg_4_0.dec_result then
			Account:updateCurrencies(arg_4_0.dec_result)
		end
	end
	
	SubStoryMoonlightTheater:afterUpdateEndEpisode()
	SubStoryMoonlightTheater:onUpdateEPtime()
	SubStoryMoonlightTheater:req_ep_watch(true)
end

function HANDLER.story_theater_main(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_watch" then
		SubStoryMoonlightTheater:req_ep_watch()
	elseif arg_5_1 == "btn_watch_pay" then
		SubStoryMoonlightTheater:req_ep_buy()
	elseif arg_5_1 == "btn_reward" then
		SubStoryMoonlightTheater:req_ep_rewards()
	elseif arg_5_1 == "btn_casting" then
		SubStoryMoonlightTheater:showCastingBoard()
	end
end

function SubStoryMoonlightTheater.showCastingBoard(arg_6_0)
	MoonlightTheaterCastBoard:show(arg_6_0.vars.wnd, SubStoryMoonlightTheater:getId(), arg_6_0:getCurEpisode_data().story_background_img)
end

function SubStoryMoonlightTheater.show(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	if not arg_7_2 or arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	arg_7_0.vars = {}
	arg_7_0.vars.id = arg_7_2
	arg_7_0.vars.wnd = load_dlg("story_theater_main", true, "wnd")
	
	arg_7_0.vars.wnd:setPositionX(arg_7_1:getContentSize().width / 2)
	arg_7_1:addChild(arg_7_0.vars.wnd)
	
	local var_7_0 = "infosubs_9"
	
	TopBarNew:createFromPopup(T("theater_title"), arg_7_0.vars.wnd, function()
		SubStoryMoonlightTheater:close()
	end, nil, var_7_0)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"theaterticket"
	})
	arg_7_0:initData()
	
	if arg_7_4 and arg_7_5 and arg_7_6 then
		arg_7_0.vars.cur_season = arg_7_4
		arg_7_0.vars.cur_ep = arg_7_5
	else
		arg_7_0.vars.cur_season = arg_7_0.vars.latest_season_idx or 1
		arg_7_0.vars.cur_ep = arg_7_0.vars.latest_ep_idx or 1
	end
	
	arg_7_0:initUI()
	Scheduler:removeByName("SubStoryMoonlightTheater.onUpdateEPtime")
	Scheduler:addSlow(arg_7_0.vars.wnd, arg_7_0.onUpdateEPtime, arg_7_0):setName("SubStoryMoonlightTheater.onUpdateEPtime")
	arg_7_0:onUpdateEPtime()
	arg_7_0:onSelectSeason(arg_7_0.vars.cur_season, arg_7_0.vars.cur_ep)
	arg_7_0:onSelectEpisode(arg_7_0.vars.cur_ep)
	
	if arg_7_3 then
		arg_7_0.vars.scroll_ep:scrollToIndex(arg_7_0.vars.cur_ep)
	end
	
	TutorialGuide:procGuide("mltheater")
end

function SubStoryMoonlightTheater.isValid(arg_9_0)
	return arg_9_0.vars and get_cocos_refid(arg_9_0.vars.wnd)
end

function SubStoryMoonlightTheater.getId(arg_10_0)
	return arg_10_0.vars.id
end

function SubStoryMoonlightTheater.initData(arg_11_0)
	arg_11_0.vars.season_data = {}
	
	arg_11_0:updateData()
end

function SubStoryMoonlightTheater.updateData(arg_12_0)
	local var_12_0 = 1
	local var_12_1 = 1
	
	for iter_12_0 = 1, 99999999 do
		local var_12_2 = string.format("%s_s%d", arg_12_0.vars.id, iter_12_0)
		local var_12_3 = DBT("ml_theater_season", var_12_2, {
			"id",
			"sort",
			"season_title",
			"main_category_name",
			"season_reward_id",
			"season_reward_cnt"
		})
		
		if not var_12_3 or not var_12_3.id then
			break
		end
		
		var_12_3.idx = iter_12_0
		var_12_3.ep_data = {}
		var_12_0 = iter_12_0
		
		local var_12_4 = false
		
		for iter_12_1 = 1, 9999999 do
			local var_12_5 = string.format("%s_e%02d", var_12_2, iter_12_1)
			local var_12_6 = DBT("ml_theater_story", var_12_5, {
				"id",
				"sort",
				"episode_title",
				"sub_category_name",
				"story_background_img",
				"story_bi",
				"story_desc",
				"bgm",
				"story_character",
				"story_btn_type",
				"story_btn_val",
				"need_token",
				"need_time",
				"need_clear_theater_story",
				"start_date",
				"start_hour"
			})
			
			if not var_12_6 or not var_12_6.id then
				break
			end
			
			var_12_1 = iter_12_1
			var_12_6.idx = iter_12_1
			var_12_6.is_cleared = Account:isCleared_mlt_ep(var_12_6.id)
			var_12_6.left_time = Account:get_mlt_ep_left_time(var_12_6.id)
			
			if var_12_6.need_time then
				var_12_6.need_time = var_12_6.need_time * 60
			end
			
			local var_12_7 = Account:get_mt_ep_info(var_12_6.id)
			
			var_12_6.no_data = table.empty(var_12_7)
			var_12_6.state = var_12_7.state or -1
			var_12_6.clear_tm = var_12_7.clear_tm
			var_12_6.buy_state = var_12_7.buy_state or -1
			var_12_6.rewarded = var_12_6.state == 2
			
			if var_12_6.need_clear_theater_story then
				var_12_6.is_cleared_before_ep = Account:isCleared_mlt_ep(var_12_6.need_clear_theater_story) ~= nil
				var_12_6.prev_ep_title = DB("ml_theater_story", var_12_6.need_clear_theater_story, {
					"episode_title"
				})
			elseif iter_12_1 == 1 then
				var_12_6.is_cleared_before_ep = true
			end
			
			if var_12_6.is_cleared_before_ep and not var_12_6.clear_tm then
				arg_12_0.vars.latest_season_idx = iter_12_0
				arg_12_0.vars.latest_ep_idx = iter_12_1
			end
			
			var_12_3.ep_data[iter_12_1] = var_12_6
		end
		
		table.sort(var_12_3.ep_data, function(arg_13_0, arg_13_1)
			return arg_13_0.sort < arg_13_1.sort
		end)
		
		arg_12_0.vars.season_data[iter_12_0] = var_12_3
	end
	
	if not arg_12_0.vars.latest_ep_idx or not arg_12_0.vars.latest_season_idx then
		arg_12_0.vars.latest_season_idx = var_12_0
		arg_12_0.vars.latest_ep_idx = var_12_1
	end
	
	table.sort(arg_12_0.vars.season_data, function(arg_14_0, arg_14_1)
		return arg_14_0.sort < arg_14_1.sort
	end)
end

function SubStoryMoonlightTheater.setCurSeason_idx(arg_15_0, arg_15_1)
	arg_15_0.vars.cur_season = arg_15_1
end

function SubStoryMoonlightTheater.setCurEpisode_idx(arg_16_0, arg_16_1)
	arg_16_0.vars.cur_ep = arg_16_1
end

function SubStoryMoonlightTheater.getCurSeason_idx(arg_17_0)
	return arg_17_0.vars.cur_season
end

function SubStoryMoonlightTheater.getCurEpisode_idx(arg_18_0)
	return arg_18_0.vars.cur_ep
end

function SubStoryMoonlightTheater.getSeason_data(arg_19_0, arg_19_1)
	if not arg_19_0.vars then
		return 
	end
	
	return arg_19_0.vars.season_data[arg_19_1]
end

function SubStoryMoonlightTheater.getCurSeason_data(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	return arg_20_0.vars.season_data[arg_20_0.vars.cur_season]
end

function SubStoryMoonlightTheater.getPrevAndLatestEpData(arg_21_0)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.vars.wnd) then
		return 
	end
	
	local var_21_0 = arg_21_0:getCurSeason_data()
	
	if not var_21_0 or not var_21_0.ep_data then
		return 
	end
	
	local var_21_1 = var_21_0.ep_data
	local var_21_2
	
	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		if iter_21_1.clear_tm then
			var_21_2 = iter_21_0
		end
	end
	
	if not var_21_2 then
		return 
	end
	
	local var_21_3 = var_21_1[var_21_2]
	local var_21_4 = var_21_1[var_21_2 + 1]
	
	return var_21_3, var_21_4
end

function SubStoryMoonlightTheater.getPrevEpisode_data(arg_22_0)
	if not arg_22_0.vars or not arg_22_0.vars.cur_ep or arg_22_0.vars.cur_ep - 1 <= 0 then
		return 
	end
	
	return arg_22_0:getCurSeason_data().ep_data[arg_22_0.vars.cur_ep - 1]
end

function SubStoryMoonlightTheater.getCurEpisode_data(arg_23_0)
	return arg_23_0:getCurSeason_data().ep_data[arg_23_0.vars.cur_ep]
end

function SubStoryMoonlightTheater.initUI(arg_24_0)
	arg_24_0.vars.n_scrollview_ep = arg_24_0.vars.wnd:getChildByName("scrollview_ep")
	arg_24_0.vars.n_scrollview_s = arg_24_0.vars.wnd:getChildByName("scrollview_s")
	arg_24_0.vars.scroll_s = {}
	
	copy_functions(ScrollView, arg_24_0.vars.scroll_s)
	
	function arg_24_0.vars.scroll_s.getScrollViewItem(arg_25_0, arg_25_1)
		local var_25_0 = load_control("wnd/story_theater_main_s_item.csb")
		
		if_set_visible(var_25_0, "_selected", arg_25_1.idx == SubStoryMoonlightTheater:getCurSeason_idx())
		if_set(var_25_0, "title", T(arg_25_1.main_category_name))
		if_set_visible(var_25_0, "n_locked", false)
		var_25_0:getChildByName("bg"):setOpacity(0)
		if_set_visible(var_25_0, "cm_icon_noti", MoonlightTheaterManager:getSeasonReceivableRewardExist(arg_25_1.id))
		
		return var_25_0
	end
	
	function arg_24_0.vars.scroll_s.onSelectScrollViewItem(arg_26_0, arg_26_1, arg_26_2)
		SubStoryMoonlightTheater:onSelectSeason(arg_26_1)
	end
	
	arg_24_0.vars.scroll_s:initScrollView(arg_24_0.vars.n_scrollview_s, 176, 78)
	
	arg_24_0.vars.scroll_ep = {}
	
	copy_functions(ScrollView, arg_24_0.vars.scroll_ep)
	
	function arg_24_0.vars.scroll_ep.getScrollViewItem(arg_27_0, arg_27_1)
		local var_27_0 = load_control("wnd/story_theater_main_ep_item.csb")
		
		if_set_visible(var_27_0, "_selected", arg_27_1.idx == SubStoryMoonlightTheater:getCurEpisode_idx())
		if_set(var_27_0, "t_ep_num", T(arg_27_1.sub_category_name))
		
		local var_27_1 = not arg_27_1.is_cleared and arg_27_1.left_time and arg_27_1.left_time > 0
		
		if_set_visible(var_27_0, "n_completed", arg_27_1.is_cleared and arg_27_1.rewarded)
		if_set_visible(var_27_0, "t_reward", arg_27_1.is_cleared and not arg_27_1.rewarded)
		
		if not arg_27_1.need_token then
			var_27_1 = false
		end
		
		if_set_visible(var_27_0, "n_time", var_27_1)
		
		if (not arg_27_1.need_time or not arg_27_1.need_token) and not arg_27_1.is_cleared and arg_27_1.is_cleared_before_ep then
			if_set_visible(var_27_0, "t_able", true)
			
			local var_27_2, var_27_3 = Account:checkEnterable_MLT_schedule(arg_27_1.id)
			
			if not var_27_2 and var_27_3 then
				if_set(var_27_0, "t_able", T("theater_state_5"))
			else
				if_set(var_27_0, "t_able", T("theater_state_2"))
			end
		else
			if_set_visible(var_27_0, "t_able", false)
		end
		
		if_set_visible(var_27_0, "n_locked", not arg_27_1.is_cleared and not arg_27_1.is_cleared_before_ep)
		
		arg_27_1.cont = var_27_0
		
		return var_27_0
	end
	
	function arg_24_0.vars.scroll_ep.onSelectScrollViewItem(arg_28_0, arg_28_1, arg_28_2)
		SubStoryMoonlightTheater:onSelectEpisode(arg_28_1, true)
	end
	
	arg_24_0.vars.scroll_ep:initScrollView(arg_24_0.vars.n_scrollview_ep, 185, 86)
	arg_24_0:updateUI()
end

function SubStoryMoonlightTheater.onSelectSeason(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0:setCurSeason_idx(arg_29_1)
	
	local var_29_0 = arg_29_2 or 1
	
	arg_29_0:onSelectEpisode(var_29_0)
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.scroll_s.ScrollViewItems) do
		if_set_opacity(iter_29_1.control, "bg", iter_29_0 == arg_29_0:getCurSeason_idx() and 255 or 0)
	end
	
	arg_29_0:updateUI()
	arg_29_0:onUpdateEPtime()
	arg_29_0.vars.scroll_s.scrollview:jumpToTop()
	arg_29_0.vars.scroll_ep.scrollview:jumpToTop()
end

function SubStoryMoonlightTheater.onSelectEpisode(arg_30_0, arg_30_1, arg_30_2)
	arg_30_0:setCurEpisode_idx(arg_30_1)
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.scroll_ep.ScrollViewItems) do
		if_set_visible(iter_30_1.control, "_selected", iter_30_0 == arg_30_0:getCurEpisode_idx())
	end
	
	arg_30_0:updateUI(true, arg_30_2)
	arg_30_0:updateEp_BGM()
end

function SubStoryMoonlightTheater.updateEp_BGM(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	local var_31_0 = arg_31_0:getCurEpisode_data()
	
	if not var_31_0 or not var_31_0.bgm then
		return 
	end
	
	SoundEngine:playBGM("event:/bgm/" .. var_31_0.bgm)
end

function SubStoryMoonlightTheater._getCurSeasonReceivableReward(arg_32_0)
	local var_32_0 = arg_32_0:getCurSeason_data()
	local var_32_1 = var_32_0.ep_data
	
	if not var_32_0 or not var_32_1 then
		return 
	end
	
	local var_32_2 = 0
	local var_32_3 = var_32_0.season_reward_id
	local var_32_4 = var_32_0.season_reward_cnt
	
	for iter_32_0, iter_32_1 in pairs(var_32_1) do
		if iter_32_1.state and iter_32_1.state == EP_REWARD_STATE.CLEAR then
			var_32_2 = var_32_2 + 1
		end
	end
	
	return var_32_3, var_32_4 * var_32_2
end

function SubStoryMoonlightTheater.updateUI(arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_1 then
		arg_33_0.vars.scroll_s:updateScrollViewItems(arg_33_0.vars.season_data)
		arg_33_0.vars.scroll_ep:updateScrollViewItems(arg_33_0.vars.season_data[arg_33_0.vars.cur_season].ep_data)
	end
	
	if not arg_33_2 then
		arg_33_0.vars.scroll_ep:scrollToIndex(arg_33_0.vars.cur_ep)
	end
	
	arg_33_0:onUpdateEPtime()
	arg_33_0:updateRewardUI()
	arg_33_0:updatePlayButtonUI()
	arg_33_0:updateBG()
	arg_33_0:updateCastingBtnNoti()
	arg_33_0:updateRewardBtnNoti()
end

function SubStoryMoonlightTheater.updateRewardUI(arg_34_0)
	local var_34_0 = arg_34_0:getCurSeason_data()
	local var_34_1 = arg_34_0:getCurEpisode_data()
	
	if not var_34_0 or not var_34_1 then
		return 
	end
	
	local var_34_2 = arg_34_0.vars.wnd:getChildByName("n_get_reward")
	local var_34_3 = var_34_2:getChildByName("n_reward_item")
	
	var_34_3:removeAllChildren()
	
	local var_34_4, var_34_5 = arg_34_0:_getCurSeasonReceivableReward()
	local var_34_6 = var_34_5 == 0
	local var_34_7 = UIUtil:getRewardIcon(tonumber(var_34_5), var_34_4, {
		parent = var_34_3
	})
	
	arg_34_0.vars.no_ep_rewards = var_34_6
	
	if var_34_6 then
		if_set_visible(var_34_7, "icon_check", true)
		var_34_7:setOpacity(76.5)
	end
	
	if_set_opacity(var_34_2, "btn_reward", var_34_6 and 76.5 or 255)
end

function SubStoryMoonlightTheater.updateBG(arg_35_0)
	local var_35_0 = arg_35_0.vars.wnd:getChildByName("LEFT")
	local var_35_1 = arg_35_0.vars.wnd:getChildByName("Sprite_322")
	local var_35_2 = arg_35_0:getCurEpisode_data()
	local var_35_3 = arg_35_0:getCurSeason_data()
	local var_35_4 = var_35_2.story_bi
	local var_35_5 = var_35_2.story_background_img
	
	if_set_sprite(var_35_1, nil, "banner/" .. var_35_4 .. ".png")
	if_set(var_35_0, "txt_story_name_s", T(var_35_3.season_title))
	if_set(var_35_0, "txt_story_name_ep", T(var_35_2.episode_title))
	if_set(var_35_0, "txt_story_desc", T(var_35_2.story_desc))
	
	if not arg_35_0.vars.bg_node then
		local var_35_6 = arg_35_0.vars.wnd:getChildByName("LEFT_BG")
		
		arg_35_0.vars.bg_node = cc.Sprite:create("banner/" .. var_35_5 .. ".png")
		
		if not arg_35_0.vars.bg_node then
			arg_35_0.vars.bg_node = cc.Sprite:create("banner/ss_vms01a_poster.png")
		end
		
		if arg_35_0.vars.bg_node then
			var_35_6:getChildByName("n_bg"):addChild(arg_35_0.vars.bg_node)
			arg_35_0.vars.bg_node:setAnchorPoint(0.095, 0.5)
			arg_35_0.vars.bg_node:setPosition(0, 0)
			arg_35_0.vars.bg_node:setScale(1)
		else
			Log.e("Err: no bg data: ", var_35_5)
		end
	else
		if_set_sprite(arg_35_0.vars.bg_node, nil, "banner/" .. var_35_5 .. ".png")
	end
	
	if not var_35_2.story_character or arg_35_0.vars.prev_port_name and arg_35_0.vars.prev_port_name == var_35_2.story_character then
		return 
	end
	
	if get_cocos_refid(arg_35_0.vars.character_portrait) then
		arg_35_0.vars.character_portrait:removeFromParent()
	end
	
	local var_35_7 = DB("character", var_35_2.story_character, {
		"face_id"
	})
	
	if var_35_7 then
		arg_35_0.vars.character_portrait = UIUtil:getPortraitAni(var_35_7)
		
		arg_35_0.vars.wnd:getChildByName("CENTER"):addChild(arg_35_0.vars.character_portrait)
		arg_35_0.vars.character_portrait:setPositionY(-400)
		arg_35_0.vars.character_portrait:setPositionX(-100)
		arg_35_0.vars.character_portrait:setScale(0.8)
		
		arg_35_0.vars.prev_port_name = var_35_2.story_character
		
		arg_35_0.vars.character_portrait:setOpacity(0)
		UIAction:Add(SEQ(LOG(FADE_IN(300))), arg_35_0.vars.character_portrait, "port_fade_in")
	end
end

function SubStoryMoonlightTheater.updateCastingBtnNoti(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	local var_36_0 = false
	
	for iter_36_0 = 1, 999999999 do
		local var_36_1 = arg_36_0.vars.id .. "_slot" .. iter_36_0
		local var_36_2 = DBT("ml_theater_cast", var_36_1, {
			"id",
			"cast_char",
			"cast_reward",
			"cast_reward_val"
		})
		
		if not var_36_2 or not var_36_2.id then
			break
		end
		
		var_36_2.is_user_have = Account:getCollectionUnit(var_36_2.cast_char)
		var_36_2.is_rewarded = Account:is_received_casting_reward(var_36_2.id)
		
		if not var_36_0 and var_36_2.is_user_have and not var_36_2.is_rewarded then
			var_36_0 = true
			
			break
		end
	end
	
	local var_36_3 = arg_36_0.vars.wnd:getChildByName("btn_casting")
	
	if_set_visible(var_36_3, "icon_noti", var_36_0)
end

function SubStoryMoonlightTheater.updateRewardBtnNoti(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	local var_37_0 = arg_37_0.vars.wnd:getChildByName("btn_reward")
	
	if get_cocos_refid(var_37_0) then
		local var_37_1, var_37_2 = arg_37_0:_getCurSeasonReceivableReward()
		
		if_set_visible(var_37_0, "icon_noti", var_37_2 and var_37_2 >= 1)
	end
end

function SubStoryMoonlightTheater.req_ep_rewards(arg_38_0)
	if not arg_38_0.vars then
		return 
	end
	
	if arg_38_0.vars.no_ep_rewards then
		return 
	end
	
	local var_38_0, var_38_1 = arg_38_0:_getCurSeasonReceivableReward()
	
	if not var_38_1 or var_38_1 == 0 then
		return 
	end
	
	local var_38_2 = arg_38_0:getCurSeason_data()
	
	query("moonlight_theater_reward", {
		season_id = var_38_2.id
	})
end

function SubStoryMoonlightTheater.res_ep_rewards(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return 
	end
	
	SubStoryMoonlightTheater:afterUpdateEndEpisode()
end

function SubStoryMoonlightTheater.can_watch_ep(arg_40_0, arg_40_1)
end

function SubStoryMoonlightTheater.req_ep_watch(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0:getCurEpisode_data()
	local var_41_1 = var_41_0.story_btn_type
	local var_41_2 = var_41_0.story_btn_val
	
	if not var_41_0 then
		return 
	end
	
	local var_41_3, var_41_4 = Account:checkEnterable_MLT_schedule(var_41_0.id)
	
	if not var_41_3 then
		balloon_message_with_sound_raw_text(T("req_prev_time", {
			time = sec_to_full_string(var_41_4)
		}))
		
		return 
	end
	
	if not var_41_0.is_cleared_before_ep then
		if var_41_0.prev_ep_title then
			balloon_message_with_sound_raw_text(T("theater_err_0", {
				story_name = T(var_41_0.prev_ep_title)
			}))
		end
		
		return 
	end
	
	if var_41_1 == "story" then
		SubStoryMoonlightTheater:_onStartStory(var_41_0.id, arg_41_1)
	elseif var_41_1 == "battle" then
		SubStoryMoonlightTheater:_onStartBattle(var_41_0.id, arg_41_1)
	end
end

function SubStoryMoonlightTheater.req_ep_buy(arg_42_0)
	local var_42_0 = arg_42_0:getCurEpisode_data()
	local var_42_1, var_42_2 = Account:checkEnterable_MLT_schedule(var_42_0.id)
	
	if not var_42_1 then
		balloon_message_with_sound_raw_text(T("req_prev_time", {
			time = sec_to_full_string(var_42_2)
		}))
		
		return 
	end
	
	if not var_42_0.is_cleared_before_ep then
		balloon_message_with_sound_raw_text(T("theater_err_0", {
			story_name = T(var_42_0.prev_ep_title)
		}))
		
		return 
	end
	
	if arg_42_0:isFreeEpisode() then
		balloon_message_with_sound_raw_text(T("theater_ticket_err"))
		
		return 
	end
	
	if arg_42_0:isTimeEndForBuy() then
		balloon_message_with_sound_raw_text(T("theater_ticket_err"))
		
		return 
	end
	
	if Account:getCurrency(var_42_0.need_token) < var_0_0 then
		MoonlightTheaterUtil:openTicketBuyPopup()
		
		return 
	end
	
	local var_42_3 = sec_to_string(arg_42_0:getLeftTime())
	local var_42_4 = load_dlg("dungeon_hell_cleaning", true, "wnd")
	local var_42_5 = UIUtil:getRewardIcon(nil, "to_theaterticket", {
		no_bg = true,
		show_name = true,
		detail = true,
		parent = var_42_4:getChildByName("reward_item")
	})
	
	if_set(var_42_5, "txt_type", T("item_category_key"))
	
	local function var_42_6()
		if arg_42_0:isTimeEndForBuy() then
			balloon_message_with_sound_raw_text(T("theater_ticket_err"))
			
			return 
		end
		
		query("moonlight_theater_unlock_story", {
			episode_id = var_42_0.id
		})
	end
	
	local var_42_7 = Dialog:msgBox(T("theater_ticket_desc", {
		time = var_42_3
	}), {
		yesno = true,
		dlg = var_42_4,
		handler = var_42_6,
		title = T("theater_ticket_title")
	})
	
	if_set(var_42_7, "t_desc", T("theater_ticket_desc", {
		time = var_42_3
	}))
	if_set(var_42_7, "txt_title", T("theater_ticket_title"))
	if_set(var_42_7, "txt_have", T("have", {
		count = Account:getCurrency("to_theaterticket")
	}))
	if_set(var_42_7, "txt_caution", T("theater_ticket_desc2"))
	if_set_color(var_42_7, "txt_caution", tocolor("#f83535"))
end

function SubStoryMoonlightTheater.isFreeEpisode(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1 or arg_44_0:getCurEpisode_data()
	
	if not var_44_0 then
		return 
	end
	
	return not var_44_0.need_token and (not var_44_0.need_time or var_44_0.need_time == 0) and not var_44_0.need_clear_theater_story
end

function SubStoryMoonlightTheater.getLeftTime(arg_45_0)
	local var_45_0 = arg_45_0:getPrevEpisode_data()
	local var_45_1 = arg_45_0:getCurEpisode_data()
	
	if not var_45_1 then
		return 
	end
	
	if not var_45_0 or not var_45_0.clear_tm then
		return 
	end
	
	local var_45_2 = os.time()
	
	return (var_45_1.need_time or 0) - (var_45_2 - var_45_0.clear_tm)
end

function SubStoryMoonlightTheater.isTimeEndForBuy(arg_46_0)
	local var_46_0 = arg_46_0:getLeftTime()
	
	return var_46_0 and var_46_0 <= 0
end

function SubStoryMoonlightTheater.updatePlayButtonUI(arg_47_0)
	local var_47_0 = arg_47_0.vars.wnd:getChildByName("btn_watch")
	local var_47_1 = arg_47_0.vars.wnd:getChildByName("btn_watch_pay")
	local var_47_2 = arg_47_0:getCurEpisode_data()
	local var_47_3 = arg_47_0:getPrevEpisode_data()
	local var_47_4 = arg_47_0:isFreeEpisode()
	local var_47_5 = arg_47_0:isTimeEndForBuy()
	local var_47_6, var_47_7 = Account:checkEnterable_MLT_schedule(var_47_2.id)
	local var_47_8 = var_47_2.buy_state or -1
	local var_47_9 = (var_47_4 or var_47_8 == 1 or var_47_2.state == 1 or var_47_5) and var_47_2.is_cleared_before_ep and var_47_6
	
	var_47_0:setOpacity(255)
	var_47_1:setOpacity(255)
	
	if get_cocos_refid(var_47_0) and get_cocos_refid(var_47_1) then
		var_47_0:setVisible(var_47_9)
		var_47_1:setVisible(not var_47_9)
		
		if not var_47_9 then
			if var_47_2.need_token then
				if_set_sprite(var_47_1, "Sprite_41", "item/token_ticket_moon_cinema.png")
				
				local var_47_10 = Account:getCurrency(var_47_2.need_token)
				
				if_set(var_47_1, "label_0", var_0_0 .. "/" .. var_47_10)
			elseif var_47_2.need_clear_theater_story then
				var_47_0:setVisible(true)
				var_47_1:setVisible(false)
			end
		end
		
		if_set_opacity(var_47_1, nil, var_47_2.is_cleared_before_ep and 255 or 76.5)
		if_set_opacity(var_47_0, nil, var_47_2.is_cleared_before_ep and 255 or 76.5)
	end
	
	if not var_47_2.is_cleared_before_ep then
		if_set_visible(var_47_0, nil, true)
		if_set_visible(var_47_1, nil, false)
	end
	
	if not var_47_6 then
		var_47_0:setVisible(true)
		var_47_1:setVisible(false)
		var_47_0:setOpacity(76.5)
	end
end

function SubStoryMoonlightTheater.updateBtnCurrency(arg_48_0)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.wnd:getChildByName("btn_watch_pay")
	local var_48_1 = arg_48_0:getCurEpisode_data()
	
	if not get_cocos_refid(var_48_0) or not var_48_1 then
		return 
	end
	
	local var_48_2 = Account:getCurrency(var_48_1.need_token)
	
	if_set(var_48_0, "label_0", var_0_0 .. "/" .. var_48_2)
end

local function var_0_1(arg_49_0)
	local var_49_0 = {
		"year",
		"month",
		"day"
	}
	local var_49_1, var_49_2, var_49_3 = string.match(arg_49_0, "(%d%d)(%d%d)(%d%d)")
	local var_49_4 = tostring(to_n(var_49_1) + 2000)
	
	return {
		hour = 0,
		year = var_49_4,
		month = var_49_2,
		day = var_49_3
	}
end

local function var_0_2(arg_50_0)
	local var_50_0
	local var_50_1
	
	if arg_50_0 < 1000 then
		var_50_0, var_50_1 = string.match(arg_50_0, "(%d)(%d%d)")
	else
		var_50_0, var_50_1 = string.match(arg_50_0, "(%d%d)(%d%d)")
	end
	
	local var_50_2 = to_n(var_50_0)
	local var_50_3 = to_n(var_50_1)
	
	return var_50_2 * 60 * 60 + var_50_3 * 60
end

function SubStoryMoonlightTheater.onUpdateEPtime(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.wnd) then
		Scheduler:removeByName("SubStoryMoonlightTheater.onUpdateEPtime")
		
		return 
	end
	
	local var_51_0, var_51_1 = arg_51_0:getPrevAndLatestEpData()
	
	if not var_51_0 or not var_51_1 then
		return 
	end
	
	local var_51_2 = var_51_1.cont
	local var_51_3 = var_51_0.cont
	
	if var_51_0 and var_51_0.clear_tm and var_51_1 and var_51_1.need_time and get_cocos_refid(var_51_2) and (var_51_1.buy_state == -1 or Account:isCleared_mlt_ep(var_51_1.id) or true) then
		local var_51_4 = tonumber(var_51_0.clear_tm)
		local var_51_5 = tonumber(var_51_1.need_time) - (os.time() - var_51_4)
		local var_51_6 = var_51_1.buy_state == 1 or var_51_5 <= 0 or var_51_1.state and var_51_1.state == 1
		
		if not var_51_1.is_cleared_before_ep then
			var_51_6 = false
		end
		
		if var_51_2.prev_hide_time == nil then
			var_51_2.prev_hide_time = var_51_6
		end
		
		if_set_visible(var_51_2, "n_time", not var_51_6)
		if_set_visible(var_51_2, "t_able", var_51_6)
		
		if not var_51_6 then
			if var_51_1.start_date and var_51_1.start_hour then
				if (os.time(var_0_1(var_51_1.start_date)) or 0) + (var_0_2(var_51_1.start_hour) or 0) > os.time() then
					if_set(var_51_2:getChildByName("n_time"), "t_locked", T("theater_state_5"))
				else
					if_set(var_51_2:getChildByName("n_time"), "t_locked", T("theater_state_1", {
						time = sec_to_string(var_51_5)
					}))
				end
			else
				if_set(var_51_2:getChildByName("n_time"), "t_locked", T("theater_state_1", {
					time = sec_to_string(var_51_5)
				}))
			end
		end
		
		if var_51_6 ~= var_51_2.prev_hide_time then
			arg_51_0:updatePlayButtonUI()
		end
		
		var_51_2.prev_hide_time = var_51_6
	end
end

function SubStoryMoonlightTheater.afterUpdateEndEpisode(arg_52_0)
	SubStoryMoonlightTheater:initData()
	SubStoryMoonlightTheater:updateUI()
end

function SubStoryMoonlightTheater.afterUpadteEndStory(arg_53_0, arg_53_1)
	if arg_53_1 then
		arg_53_0.vars.cur_season = arg_53_0.vars.cur_season
		arg_53_0.vars.cur_ep = arg_53_0.vars.cur_ep
	else
		arg_53_0.vars.cur_season = arg_53_0.vars.latest_season_idx or 1
		arg_53_0.vars.cur_ep = arg_53_0.vars.latest_ep_idx or 1
	end
	
	arg_53_0:onSelectSeason(arg_53_0.vars.cur_season, arg_53_0.vars.cur_ep)
	arg_53_0:onSelectEpisode(arg_53_0.vars.cur_ep)
	arg_53_0.vars.scroll_ep:scrollToIndex(arg_53_0.vars.cur_ep)
end

function SubStoryMoonlightTheater.close(arg_54_0)
	MoonlightTheaterList:updateTimeAllControls()
	Scheduler:removeByName("SubStoryMoonlightTheater.onUpdateEPtime")
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE(), CALL(function()
		arg_54_0.vars = nil
		
		SoundEngine:playBGM("event:/bgm/bgm_story_dark")
	end)), arg_54_0.vars.wnd, "block")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("theater_title"))
end

function SubStoryMoonlightTheater._onStartStory(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = DEBUG.DEBUG_NO_ENTER_LIMIT and not PRODUCTION_MODE or false
	
	if arg_56_2 then
		arg_56_1 = arg_56_1 or "theater1_s1_e01"
		
		local var_56_1 = DBT("ml_theater_story", arg_56_1, "story_btn_val")
		
		start_new_story(nil, var_56_1.story_btn_val, {
			force = true,
			is_moonlight_th = true,
			on_finish = function()
				query("moonlight_theater_story_clear", {
					episode_id = arg_56_1,
					ignore_schedule = var_56_0
				})
			end
		})
	else
		Dialog:msgBox(T("theater_enter_desc"), {
			yesno = true,
			handler = function()
				arg_56_1 = arg_56_1 or "theater1_s1_e01"
				
				local var_58_0 = DBT("ml_theater_story", arg_56_1, "story_btn_val")
				
				start_new_story(nil, var_58_0.story_btn_val, {
					force = true,
					is_moonlight_th = true,
					on_finish = function()
						query("moonlight_theater_story_clear", {
							episode_id = arg_56_1,
							ignore_schedule = var_56_0
						})
					end
				})
			end,
			title = T("theater_enter_title")
		})
	end
end

function SubStoryMoonlightTheater._onStartBattle(arg_60_0, arg_60_1, arg_60_2)
	arg_60_1 = arg_60_1 or "theater1_s1_e02"
	
	local var_60_0 = DBT("ml_theater_story", arg_60_1, "story_btn_val")
	local var_60_1 = DB("level_enter", var_60_0.story_btn_val, {
		"npcteam_id1"
	})
	local var_60_2 = not var_60_1 and Account:getCurrentTeamIndex() or nil
	
	local function var_60_3()
		SubStoryMoonlightTheater:setEnterBattle(true)
		query("preview_enter", {
			map = var_60_0.story_btn_val,
			team = var_60_2,
			npcteam_id = var_60_1,
			mt_episode_id = arg_60_1
		})
	end
	
	if arg_60_2 then
		var_60_3()
	else
		Dialog:msgBox(T("theater_enter_desc"), {
			yesno = true,
			handler = var_60_3,
			title = T("theater_enter_title")
		})
	end
end

function SubStoryMoonlightTheater.getEnterBattle(arg_62_0)
	return arg_62_0.enter_battle, arg_62_0.cur_theater_idx, arg_62_0.cur_season_idx, arg_62_0.cur_ep_idx, arg_62_0.already_cleared
end

function SubStoryMoonlightTheater.setEnterBattle(arg_63_0, arg_63_1)
	arg_63_0.enter_battle = arg_63_1
	
	if arg_63_1 == true then
		arg_63_0.cur_theater_idx = MoonlightTheaterList:getCurTheaterIdx() or 1
		arg_63_0.cur_season_idx = arg_63_0.vars.cur_season
		arg_63_0.cur_ep_idx = arg_63_0.vars.cur_ep
		arg_63_0.already_cleared = Account:isCleared_mlt_ep(arg_63_0:getCurEpisode_data().id)
	else
		arg_63_0.enter_battle = nil
		arg_63_0.cur_theater_idx = nil
		arg_63_0.cur_season_idx = nil
		arg_63_0.cur_ep_idx = nil
		arg_63_0.already_cleared = nil
	end
end
