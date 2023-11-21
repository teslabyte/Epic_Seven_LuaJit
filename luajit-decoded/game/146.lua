DungeonTrialHall_RankPopup = {}

local var_0_0 = 20

function HANDLER.trial_hall_reward(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ranking" then
		DungeonTrialHall_RankPopup:changeMode("ranking")
	elseif arg_1_1 == "btn_previous_ranking" then
		DungeonTrialHall_RankPopup:changeMode("prev_ranking")
	elseif arg_1_1 == "btn_close" then
		DungeonTrialHall_RankPopup:closeRankPopup()
	end
end

function HANDLER.dungeon_trial_rank_item(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_more" then
		if DungeonTrialHall_RankPopup:getMode() == "prev_ranking" then
			DungeonTrialHall_RankPopup:req_PrevRankingUI()
		elseif DungeonTrialHall_RankPopup:getMode() == "ranking" then
			DungeonTrialHall_RankPopup:req_curRankingUI()
		end
	elseif arg_2_1 == "btn_info" then
		Friend:preview(arg_2_0.item.user_id)
	end
end

function MsgHandler.trialhall_rank_list(arg_3_0)
	if DungeonTrialHall_RankPopup:getMode() == "prev_ranking" then
		DungeonTrialHall_RankPopup:res_PrevRankingUI(arg_3_0)
	elseif DungeonTrialHall_RankPopup:getMode() == "ranking" then
		DungeonTrialHall_RankPopup:res_curRankingUI(arg_3_0)
	end
end

copy_functions(ScrollView, DungeonTrialHall_RankPopup)

function DungeonTrialHall_RankPopup.closeRankPopup(arg_4_0)
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_4_0.vars.reward_popup, "block")
	
	arg_4_0.vars.reward_popup = nil
	
	BackButtonManager:pop("trial_hall_reward")
end

function DungeonTrialHall_RankPopup.openRankPopup(arg_5_0)
	local var_5_0 = SceneManager:getRunningNativeScene()
	
	arg_5_0.vars = {}
	arg_5_0.vars.reward_popup = load_dlg("trial_hall_reward", true, "wnd", function()
		DungeonTrialHall_RankPopup.closeRankPopup(arg_5_0)
	end)
	
	var_5_0:addChild(arg_5_0.vars.reward_popup)
	
	arg_5_0.vars.cur_rankDatas = {}
	arg_5_0.vars.cur_rankPage = 1
	arg_5_0.vars.cur_scrollview = arg_5_0.vars.reward_popup:getChildByName("n_ranking"):getChildByName("scrollview_rank")
	arg_5_0.vars.before_rankDatas = {}
	arg_5_0.vars.before_rankPage = 1
	arg_5_0.vars.before_info = arg_5_0:calcPrevSeasonInfo()
	arg_5_0.vars.before_scrollview = arg_5_0.vars.reward_popup:getChildByName("n_ranking_previous"):getChildByName("scrollview_rank")
	arg_5_0.vars.mode = "ranking"
	arg_5_0.vars.isInitCurRanking = false
	arg_5_0.vars.isInitPrevRanking = false
	
	arg_5_0:updateUI()
end

function DungeonTrialHall_RankPopup.getMode(arg_7_0)
	return arg_7_0.vars.mode
end

function DungeonTrialHall_RankPopup.changeMode(arg_8_0, arg_8_1)
	arg_8_0.vars.mode = arg_8_1
	
	arg_8_0:updateUI()
end

function DungeonTrialHall_RankPopup.updateUI(arg_9_0)
	if arg_9_0.vars.mode == "ranking" then
		arg_9_0:show_rankingUI()
	elseif arg_9_0.vars.mode == "prev_ranking" then
		arg_9_0:show_prevRankingUI()
	end
end

function DungeonTrialHall_RankPopup.show_rankingUI(arg_10_0)
	if not arg_10_0.vars.isInitCurRanking then
		arg_10_0:initScrollView(arg_10_0.vars.cur_scrollview, 932, 114)
		arg_10_0:req_curRankingUI()
	end
	
	if_set_visible(arg_10_0.vars.reward_popup, "n_reward", false)
	if_set_visible(arg_10_0.vars.reward_popup, "n_ranking", true)
	if_set_visible(arg_10_0.vars.reward_popup, "n_ranking_previous", false)
	if_set_visible(arg_10_0.vars.reward_popup:getChildByName("n_category_ranking"), "bg", true)
	if_set_visible(arg_10_0.vars.reward_popup:getChildByName("n_category_previous_ranking"), "bg", false)
end

function DungeonTrialHall_RankPopup.show_prevRankingUI(arg_11_0)
	if arg_11_0.vars.before_info then
		local var_11_0 = DB("level_battlemenu_trialhall", arg_11_0.vars.before_info.id, {
			"monster_id"
		})
		local var_11_1 = DB("character", var_11_0, {
			"name"
		})
		
		UIUtil:getRewardIcon("c", var_11_0, {
			no_popup = true,
			no_lv = true,
			no_grade = true,
			parent = arg_11_0.vars.reward_popup:getChildByName("n_face")
		})
		if_set(arg_11_0.vars.reward_popup:getChildByName("n_boss"), "txt_name", T(var_11_1))
	else
		if_set_visible(arg_11_0.vars.reward_popup, "n_boss", false)
	end
	
	if not arg_11_0.vars.isInitPrevRanking and arg_11_0.vars.before_info then
		arg_11_0:initScrollView(arg_11_0.vars.before_scrollview, 932, 114)
		arg_11_0:req_PrevRankingUI()
	end
	
	if_set_visible(arg_11_0.vars.reward_popup, "n_reward", false)
	if_set_visible(arg_11_0.vars.reward_popup, "n_ranking", false)
	if_set_visible(arg_11_0.vars.reward_popup, "n_ranking_previous", true)
	if_set_visible(arg_11_0.vars.reward_popup:getChildByName("n_category_ranking"), "bg", false)
	if_set_visible(arg_11_0.vars.reward_popup:getChildByName("n_category_previous_ranking"), "bg", true)
end

function DungeonTrialHall_RankPopup.req_curRankingUI(arg_12_0)
	query("trialhall_rank_list", {
		trial_id = Account:getActiveTrialHall().id,
		page = arg_12_0.vars.cur_rankPage,
		limit = var_0_0
	})
end

function DungeonTrialHall_RankPopup.req_PrevRankingUI(arg_13_0)
	query("trialhall_rank_list", {
		trial_id = arg_13_0.vars.before_info.id,
		page = arg_13_0.vars.before_rankPage,
		limit = var_0_0
	})
end

function DungeonTrialHall_RankPopup.res_curRankingUI(arg_14_0, arg_14_1)
	local var_14_0 = 1
	local var_14_1 = arg_14_0.vars.reward_popup:getChildByName("n_ranking")
	
	if arg_14_1.my_info then
		local var_14_2 = arg_14_1.my_info
		local var_14_3 = T("trial_hall_rank_none")
		
		if var_14_2.rank and var_14_2.rank > 0 then
			if var_14_2.rank <= 100 then
				var_14_3 = T("trial_hall_rank_point_rank", {
					rank = var_14_2.rank
				})
			else
				local var_14_4 = round(var_14_2.rank_rate, 2)
				
				if var_14_4 * 10 > 0 then
					var_14_4 = math.ceil(var_14_2.rank_rate * 100) / 100
				end
				
				var_14_3 = T("trial_hall_rank_point_per", {
					per = math.max(var_14_4 * 100, 1)
				})
			end
		end
		
		if_set(var_14_1, "txt_my_rank", var_14_3)
		
		local var_14_5 = T("trial_hall_battle_point_none")
		
		if var_14_2.score and var_14_2.score > 0 then
			var_14_5 = T("trial_hall_battle_point", {
				point = comma_value(var_14_2.score)
			})
		end
		
		if_set(var_14_1, "txt_pts", var_14_5)
	end
	
	if_set_visible(arg_14_0.vars.reward_popup:getChildByName("n_ranking"), "n_info", false)
	
	local var_14_6 = table.count(arg_14_0.vars.cur_rankDatas)
	local var_14_7
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.cur_rankDatas) do
		if iter_14_1.next_item then
			var_14_7 = iter_14_0
		end
	end
	
	if var_14_7 then
		table.remove(arg_14_0.vars.cur_rankDatas, var_14_7)
		arg_14_0:removeScrollViewItemAt(var_14_7)
	end
	
	if not arg_14_1 or not arg_14_1.rank_info or table.empty(arg_14_1.rank_info) then
		if_set_visible(arg_14_0.vars.reward_popup:getChildByName("n_ranking"), "n_info", true)
		
		return 
	end
	
	local var_14_8 = arg_14_1.rank_info
	local var_14_9 = table.count(var_14_8) >= 20 and table.count(arg_14_0.vars.cur_rankDatas) < 80
	
	for iter_14_2, iter_14_3 in pairs(var_14_8) do
		table.insert(arg_14_0.vars.cur_rankDatas, iter_14_3)
		arg_14_0:addScrollViewItem(iter_14_3)
	end
	
	if var_14_9 then
		table.insert(arg_14_0.vars.cur_rankDatas, {
			next_item = true,
			is_personal = true
		})
		arg_14_0:addScrollViewItem({
			next_item = true,
			is_personal = true
		})
	end
	
	if table.count(arg_14_0.vars.cur_rankDatas) > 1 then
		arg_14_0:jumpToIndex(var_14_6)
	end
	
	arg_14_0.vars.isInitCurRanking = true
	arg_14_0.vars.cur_rankPage = arg_14_0.vars.cur_rankPage + 1
end

function DungeonTrialHall_RankPopup.res_PrevRankingUI(arg_15_0, arg_15_1)
	local var_15_0 = 1
	local var_15_1 = arg_15_0.vars.reward_popup:getChildByName("n_ranking_previous")
	
	if arg_15_1.my_info then
		local var_15_2 = arg_15_1.my_info
		local var_15_3 = T("trial_hall_rank_none")
		
		if var_15_2.rank and var_15_2.rank > 0 then
			if var_15_2.rank <= 100 then
				var_15_3 = T("trial_hall_rank_point_rank", {
					rank = var_15_2.rank
				})
			else
				local var_15_4 = round(var_15_2.rank_rate, 2)
				
				if var_15_4 * 10 > 0 then
					var_15_4 = math.ceil(var_15_2.rank_rate * 100) / 100
				end
				
				var_15_3 = T("trial_hall_rank_point_per", {
					per = math.max(var_15_4 * 100, 1)
				})
			end
		end
		
		if_set(var_15_1, "txt_my_rank", var_15_3)
		
		local var_15_5 = T("trial_hall_battle_point_none")
		
		if var_15_2.score and var_15_2.score > 0 then
			var_15_5 = T("trial_hall_battle_point", {
				point = comma_value(var_15_2.score)
			})
		end
		
		if_set(var_15_1, "txt_pts", var_15_5)
	end
	
	if_set_visible(arg_15_0.vars.reward_popup:getChildByName("n_ranking_previous"), "n_info", false)
	
	local var_15_6 = table.count(arg_15_0.vars.before_rankDatas)
	local var_15_7
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.before_rankDatas) do
		if iter_15_1.next_item then
			var_15_7 = iter_15_0
		end
	end
	
	if var_15_7 then
		table.remove(arg_15_0.vars.before_rankDatas, var_15_7)
		arg_15_0:removeScrollViewItemAt(var_15_7)
	end
	
	if not arg_15_1 or not arg_15_1.rank_info or table.empty(arg_15_1.rank_info) then
		if_set_visible(arg_15_0.vars.reward_popup:getChildByName("n_ranking_previous"), "n_info", true)
		
		return 
	end
	
	local var_15_8 = arg_15_1.rank_info
	local var_15_9 = table.count(var_15_8) >= 20 and table.count(arg_15_0.vars.before_rankDatas) < 80
	
	for iter_15_2, iter_15_3 in pairs(var_15_8) do
		table.insert(arg_15_0.vars.before_rankDatas, iter_15_3)
		arg_15_0:addScrollViewItem(iter_15_3)
	end
	
	if var_15_9 then
		table.insert(arg_15_0.vars.before_rankDatas, {
			next_item = true,
			is_personal = true
		})
		arg_15_0:addScrollViewItem({
			next_item = true,
			is_personal = true
		})
	end
	
	if table.count(arg_15_0.vars.before_rankDatas) > 1 then
		arg_15_0:jumpToIndex(var_15_6)
	end
	
	arg_15_0.vars.isInitPrevRanking = true
	arg_15_0.vars.before_rankPage = arg_15_0.vars.before_rankPage + 1
end

function DungeonTrialHall_RankPopup.calcPrevSeasonInfo(arg_16_0)
	local var_16_0 = Account:getActiveTrialHall()
	local var_16_1
	local var_16_2 = Account:getTrialHallSchedules()
	
	if not var_16_0 or table.empty(var_16_0) then
		return 
	end
	
	local var_16_3 = 0
	local var_16_4 = 0
	
	for iter_16_0, iter_16_1 in pairs(var_16_2) do
		if var_16_0.id ~= iter_16_1.id and iter_16_1.id == DungeonTrialHall:getPrevSeasonID() and iter_16_1.start_time < var_16_0.start_time and var_16_4 < iter_16_1.start_time then
			var_16_1 = iter_16_1
			var_16_4 = iter_16_1.start_time
		end
	end
	
	if not var_16_1 then
		return 
	end
	
	return var_16_1
end

function DungeonTrialHall_RankPopup.getScrollViewItem(arg_17_0, arg_17_1)
	local var_17_0 = load_control("wnd/dungeon_trial_rank_item.csb")
	
	var_17_0:getChildByName("btn_more").parent = arg_17_0
	
	if arg_17_1.next_item then
		if_set_visible(var_17_0, "n_rank", false)
		if_set_visible(var_17_0, "n_pers", false)
		if_set_visible(var_17_0, "btn_info", false)
		if_set_visible(var_17_0, "page_next", true)
		
		var_17_0.item = arg_17_1
		
		local var_17_1 = var_17_0:getChildByName("btn_more")
		
		if var_17_1 then
			var_17_1.item = arg_17_1
		end
		
		return var_17_0
	end
	
	UIUtil:getUserIcon(arg_17_1.user_info.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		no_grade = true,
		parent = var_17_0:getChildByName("mob_icon"),
		border_code = arg_17_1.user_info.border_code
	})
	if_set(var_17_0, "t_name", arg_17_1.user_info.name)
	
	local var_17_2
	
	if arg_17_1.rank <= 3 then
		if_set_visible(var_17_0, "n_toprank", true)
		if_set_visible(var_17_0, "txt_rank", false)
		
		var_17_2 = var_17_0:getChildByName("n_toprank"):getChildByName("txt_rank")
	else
		if_set_visible(var_17_0, "n_toprank", false)
		if_set_visible(var_17_0, "txt_rank", true)
		
		var_17_2 = var_17_0:getChildByName("txt_rank")
	end
	
	if_set(var_17_2, nil, T("ui_clan_worldboss_rank_item_clan_rank", {
		clan_rank = arg_17_1.rank
	}))
	if_set(var_17_0, "t_pts", T("ui_clan_worldboss_rank_item_point", {
		point = comma_value(arg_17_1.score)
	}))
	
	local var_17_3 = UIUtil:numberDigitToCharOffset(arg_17_1.user_info.level, 1, 0)
	
	UIUtil:warpping_setLevel(var_17_0:getChildByName("n_lv_rank"), arg_17_1.user_info.level, MAX_ACCOUNT_LEVEL, 2, {
		offset_per_char = var_17_3
	})
	
	if arg_17_1.user_info.level <= 9 then
		local var_17_4 = var_17_0:getChildByName("n_lv_base")
		
		if var_17_4 then
			var_17_4:setPositionX(var_17_4:getPositionX() - 50)
		end
	end
	
	local var_17_5 = var_17_0:getChildByName("btn_info")
	
	if var_17_5 then
		var_17_5.item = arg_17_1
	end
	
	var_17_0.item = arg_17_1
	
	return var_17_0
end

function HANDLER.trial_hall_reward_info(arg_18_0, arg_18_1)
	if arg_18_1 == "btn_close" then
		DungeonTrialHall_RewardPopup:close()
	elseif arg_18_1 == "btn_reward" or arg_18_1 == "btn_rank_reward" then
		DungeonTrialHall_RewardPopup:selectTab(arg_18_1)
	end
end

DungeonTrialHall_RewardPopup = {}

function DungeonTrialHall_RewardPopup.open(arg_19_0)
	if arg_19_0.vars then
		return 
	end
	
	local var_19_0 = SceneManager:getRunningNativeScene()
	
	arg_19_0.vars = {}
	arg_19_0.vars.reward_popup = load_dlg("trial_hall_reward_info", true, "wnd", function()
		DungeonTrialHall_RewardPopup.close(arg_19_0)
	end)
	
	var_19_0:addChild(arg_19_0.vars.reward_popup)
	arg_19_0:initUI()
	arg_19_0:selectTab("btn_reward")
end

function DungeonTrialHall_RewardPopup.initUI(arg_21_0)
	arg_21_0:initRewardInfoUI()
	arg_21_0:initRewardUI()
end

function DungeonTrialHall_RewardPopup.initRewardInfoUI(arg_22_0)
	arg_22_0.vars.rank_popup = arg_22_0.vars.reward_popup:getChildByName("n_rank_reward")
	
	for iter_22_0 = 1, 99 do
		local var_22_0, var_22_1, var_22_2, var_22_3, var_22_4, var_22_5 = DB("challenge_rank_reward", tostring(iter_22_0), {
			"rank_type",
			"rank_range",
			"reward_type1",
			"reward_value1",
			"reward_type2",
			"reward_value2"
		})
		local var_22_6 = arg_22_0.vars.rank_popup:getChildByName("n_bar" .. iter_22_0)
		
		if not var_22_0 or not var_22_6 then
			break
		end
		
		local var_22_7 = "1"
		local var_22_8, var_22_9 = DB("challenge_rank_reward", tostring(iter_22_0 - 1), {
			"rank_type",
			"rank_range"
		})
		
		if var_22_8 and var_22_9 then
			if var_22_8 == "fix" then
				var_22_9 = var_22_9 + 1
				var_22_7 = var_22_9
			elseif var_22_8 == "per" then
				var_22_7 = var_22_9 * 100 .. "%"
			end
		end
		
		if var_22_0 == "per" then
			var_22_1 = var_22_1 * 100 .. "%"
		end
		
		local var_22_10 = var_22_1
		
		if_set(var_22_6, "txt_title", var_22_7 .. "-" .. var_22_10)
		
		local var_22_11 = var_22_10
		
		if_set(var_22_6, "txt_reward1", comma_value(var_22_3))
		if_set(var_22_6, "txt_reward2", comma_value(var_22_5))
		if_set_visible(var_22_6, "txt_reward1", var_22_3)
		if_set_visible(var_22_6, "txt_reward2", var_22_5)
		
		if var_22_2 then
			UIUtil:getRewardIcon(nil, var_22_2, {
				parent = var_22_6:getChildByName("reward_item1")
			})
		end
		
		if var_22_4 then
			UIUtil:getRewardIcon(nil, var_22_4, {
				parent = var_22_6:getChildByName("reward_item2")
			})
		end
	end
end

function DungeonTrialHall_RewardPopup.initRewardUI(arg_23_0)
	local var_23_0 = arg_23_0.vars.reward_popup:getChildByName("n_reward")
	local var_23_1 = arg_23_0.vars.reward_popup
	local var_23_2 = var_23_1:getChildByName("n_reward")
	local var_23_3 = 0
	
	for iter_23_0 = 1, 99 do
		local var_23_4, var_23_5, var_23_6, var_23_7, var_23_8, var_23_9 = DBN("challenge_rank", iter_23_0, {
			"id",
			"rank",
			"rank_point",
			"rank_reward",
			"rank_reward_value",
			"rank_reward_bonus"
		})
		
		if not var_23_4 then
			break
		end
		
		if var_23_3 == 0 then
			var_23_3 = tonumber(var_23_8)
		else
			var_23_3 = var_23_3 + tonumber(var_23_8)
		end
		
		local var_23_10 = string.replace(var_23_5, "+", "_plus")
		local var_23_11
		
		if var_23_10 == "d" then
			local var_23_12 = var_23_2:getChildByName("n_battle_rewards_d")
			
			if_set(var_23_12, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_12, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_12:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "c" then
			local var_23_13 = var_23_2:getChildByName("n_battle_rewards_c")
			
			if_set(var_23_13, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_13, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_13:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "b" then
			local var_23_14 = var_23_2:getChildByName("n_battle_rewards_b")
			
			if_set(var_23_14, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_14, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_14:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "a" then
			local var_23_15 = var_23_2:getChildByName("n_battle_rewards_a")
			
			if_set(var_23_15, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_15, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_15:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "a_plus" then
			local var_23_16 = var_23_2:getChildByName("n_battle_rewards_a_plus")
			
			if_set(var_23_16, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_16, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_16:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "s" then
			local var_23_17 = var_23_2:getChildByName("n_battle_rewards_s")
			
			if_set(var_23_17, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_17, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_17:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "s_plus" then
			local var_23_18 = var_23_2:getChildByName("n_battle_rewards_s_plus")
			
			if_set(var_23_18, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_18, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_18:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "ss" then
			local var_23_19 = var_23_2:getChildByName("n_battle_rewards_ss")
			
			if_set(var_23_19, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_19, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_19:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "ss_plus" then
			local var_23_20 = var_23_2:getChildByName("n_battle_rewards_ss_plus")
			
			if_set(var_23_20, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_20, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_20:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "sss" then
			local var_23_21 = var_23_1:getChildByName("n_battle_rewards")
			
			if_set(var_23_21, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_21, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_21:getChildByName("n_reward_item")
			})
		elseif var_23_10 == "sss_plus" then
			local var_23_22 = var_23_2:getChildByName("n_battle_rewards_sss_plus")
			
			if_set(var_23_22, "txt_Point", T("ui_trial_hall_rank_point", {
				point = comma_value(var_23_6)
			}))
			if_set(var_23_22, "txt_reward_item", "x" .. var_23_3)
			UIUtil:getRewardIcon(nil, var_23_7, {
				no_bg = true,
				parent = var_23_22:getChildByName("n_reward_item")
			})
		end
		
		local var_23_23 = var_23_2:getChildByName("n_bonus_" .. var_23_10)
		
		if var_23_9 and get_cocos_refid(var_23_23) then
			UIUtil:getRewardIcon(nil, var_23_9, {
				no_bg = true,
				parent = var_23_23:getChildByName("n_reward")
			})
		else
			if_set_visible(var_23_2, "n_bonus_" .. var_23_10, false)
		end
	end
	
	arg_23_0:initRewardPointUI()
end

function DungeonTrialHall_RewardPopup.initRewardPointUI(arg_24_0)
	local var_24_0 = 0
	local var_24_1 = DungeonTrialHall:getCurrentInfo() or {}
	
	if not table.empty(var_24_1) and var_24_1.id then
		var_24_0 = (Account:getTrialHall(var_24_1.id) or {}).score or 0
	end
	
	local var_24_2 = arg_24_0.vars.reward_popup:getChildByName("n_my_reward")
	
	for iter_24_0 = 1, 99 do
		local var_24_3, var_24_4, var_24_5, var_24_6, var_24_7, var_24_8 = DBN("challenge_rank", iter_24_0, {
			"id",
			"rank",
			"rank_point",
			"rank_reward",
			"rank_reward_value",
			"rank_reward_bonus"
		})
		
		if not var_24_3 then
			break
		end
		
		local var_24_9 = string.replace(var_24_4, "+", "_plus")
		local var_24_10 = var_24_2:getChildByName("rank_" .. var_24_9)
		
		if not get_cocos_refid(var_24_10) then
			break
		end
		
		if var_24_5 <= var_24_0 then
			if_set_visible(var_24_10, "bg_area", true)
			if_set_visible(var_24_10, "icon_check", true)
			
			local var_24_11 = arg_24_0.vars.reward_popup:getChildByName("n_bonus_" .. var_24_9)
			
			if var_24_11 then
				if_set_visible(var_24_11, "icon_check", true)
			end
		else
			if_set_visible(var_24_10, "bg_area", false)
			if_set_visible(var_24_10, "icon_check", false)
			if_set_opacity(var_24_10, "rank_raid", 76.5)
			
			local var_24_12 = arg_24_0.vars.reward_popup:getChildByName("n_bonus_" .. var_24_9)
			
			if var_24_12 then
				if_set_visible(var_24_12, "icon_check", false)
			end
		end
	end
end

function DungeonTrialHall_RewardPopup.selectTab(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.vars.reward_popup:getChildByName("n_category")
	
	if arg_25_1 == "btn_reward" then
		if_set_visible(var_25_0:getChildByName("n_category_rewards"), "bg", true)
		if_set_visible(var_25_0:getChildByName("n_category_rank"), "bg", false)
		if_set_visible(arg_25_0.vars.reward_popup, "n_reward", true)
		if_set_visible(arg_25_0.vars.reward_popup, "n_rank_reward", false)
	elseif arg_25_1 == "btn_rank_reward" then
		if_set_visible(var_25_0:getChildByName("n_category_rewards"), "bg", false)
		if_set_visible(var_25_0:getChildByName("n_category_rank"), "bg", true)
		if_set_visible(arg_25_0.vars.reward_popup, "n_reward", false)
		if_set_visible(arg_25_0.vars.reward_popup, "n_rank_reward", true)
	end
end

function DungeonTrialHall_RewardPopup.close(arg_26_0)
	if not arg_26_0.vars then
		return 
	end
	
	arg_26_0.vars.reward_popup:removeFromParent()
	
	arg_26_0.vars = nil
	
	BackButtonManager:pop("trial_hall_reward_info")
end
