ClanWarUIUtil = {}

function ClanWarUIUtil.setGuildInfo(arg_1_0, arg_1_1, arg_1_2)
	UIUtil:updateClanEmblem(arg_1_1, arg_1_2)
	UIUtil:warpping_setLevel(arg_1_1:getChildByName("n_lv"), arg_1_2.level, CLAN_MAX_LEVEL, 2, {
		is_clan_level = true
	})
	if_set(arg_1_1, "clan_name", arg_1_2.name)
	if_set(arg_1_1, "clan_score", string.format("%s %s", T("war_ui_0042"), comma_value(arg_1_2.points)))
end

function ClanWarUIUtil.getRoundResultIconPath(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 > 1 or arg_2_2 > 2 then
		return "img/battle_pvp_icon_lose.png"
	end
	
	return "img/battle_pvp_icon_" .. ({
		[0] = {
			[0] = "lose",
			"win",
			"draw"
		},
		{
			[0] = "defeat",
			"def",
			"draw"
		}
	})[arg_2_1][arg_2_2] .. ".png"
end

function ClanWarUIUtil.getRoundResultTextID(arg_3_0, arg_3_1)
	if arg_3_1 == 0 then
		return "war_ui_0099"
	elseif arg_3_1 == 1 then
		return "war_ui_0097"
	else
		return "war_ui_0098"
	end
end

function ClanWarUIUtil.getResultIconPath(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 > 1 or not (arg_4_2 > 1) or not (arg_4_2 < 5) then
		return "war_ui_battleresult_06"
	end
	
	return "img/battle_pvp_icon_" .. ({
		[0] = {
			nil,
			"win",
			"lose",
			"draw"
		},
		{
			nil,
			"def",
			"defeat",
			"draw"
		}
	})[arg_4_1][arg_4_2] .. ".png"
end

function ClanWarUIUtil.getResultTextID(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 > 1 or not (arg_5_2 > 1) or not (arg_5_2 < 5) then
		return "war_ui_battleresult_06"
	end
	
	return "war_ui_battleresult_" .. ({
		[0] = {
			nil,
			"03",
			"04",
			"06"
		},
		{
			nil,
			"01",
			"02",
			"05"
		}
	})[arg_5_1][arg_5_2]
end

ClanWarRanking = {}

function ClanWarRanking.closeRewardTip(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	if not arg_6_0.vars.reward_tip_wnd then
		return 
	end
	
	if not get_cocos_refid(arg_6_0.vars.reward_tip_wnd) then
		return 
	end
	
	BackButtonManager:pop("clan_war_rank_reward_tip")
	arg_6_0.vars.reward_tip_wnd:removeFromParent()
end

function ClanWarRanking.openRewardTip(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or SceneManager:getDefaultLayer()
	arg_7_0.vars.reward_tip_wnd = load_dlg("clan_war_rank_reward_tip", true, "wnd", function()
		arg_7_0:closeRewardTip()
	end)
	
	ClanWarResultDetail:getWnd():addChild(arg_7_0.vars.reward_tip_wnd)
	arg_7_0:setRewardTip()
end

function ClanWarRanking.setRewardTip(arg_9_0)
	local var_9_0 = arg_9_0.vars.reward_tip_wnd
	
	for iter_9_0 = 1, 5 do
		db_line = arg_9_0.vars.grade_db[iter_9_0]
		
		local var_9_1 = var_9_0:getChildByName("n_bar" .. iter_9_0)
		
		if_set(var_9_1, "txt_grade", T(db_line.grade_name))
		if_set(var_9_1, "txt_point", db_line.need_war_score)
		if_set(var_9_1, "txt_ranking", T("war_ui_0075", {
			min = db_line.min_rate,
			max = db_line.max_rate
		}))
		if_set(var_9_1, "txt_reward", T("war_ui_0076", {
			value = db_line.bonus_rate
		}))
	end
end

function ClanWarRanking.getRankGrade(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = 1
	
	for iter_10_0 = 1, 4 do
		db_line = arg_10_0.vars.grade_db[iter_10_0]
		
		if arg_10_1 >= db_line.need_war_score and arg_10_2 <= db_line.max_rate then
			return iter_10_0
		end
	end
	
	return 5
end

function ClanWarRanking.init(arg_11_0)
	arg_11_0.vars = {}
	arg_11_0.vars.grade_db = {}
	
	for iter_11_0 = 1, 5 do
		arg_11_0.vars.grade_db[iter_11_0] = DBT("clan_war_rank_grade", string.format("grade_%02d", iter_11_0), {
			"grade_name",
			"need_war_score",
			"min_rate",
			"max_rate",
			"bonus_rate"
		})
	end
	
	arg_11_0:setMyRankingInfo({})
	arg_11_0:initListView()
	
	local var_11_0 = ClanWarResultDetail:getWnd():getChildByName("cm_tooltipbox")
	
	ClanWar:query("get_clan_war_ranking", function()
		arg_11_0.vars.info = ClanWar:getClanWarRankingInfo()
		
		local var_12_0 = arg_11_0.vars.info.ranking_list or {}
		
		if_set_visible(var_11_0, "n_no_data", table.count(var_12_0) == 0)
		arg_11_0:setRankingInfo(var_12_0)
		arg_11_0:setMyRankingInfo(arg_11_0.vars.info)
	end)
end

function ClanWarRanking.isEmtyList(arg_13_0)
	if not arg_13_0.vars or not arg_13_0.vars.info or table.empty(arg_13_0.vars.info) then
		return true
	end
	
	return false
end

function ClanWarRanking.initListView(arg_14_0)
	arg_14_0.vars.listview = ItemListView_v2:bindControl(ClanWarResultDetail:getRankingListview())
	
	local var_14_0 = {
		onUpdate = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			local var_15_0 = tonumber(arg_15_3.rank) <= 3
			
			if_set_visible(arg_15_1, "txt_rank", not var_15_0)
			if_set_visible(arg_15_1, "n_toprank", var_15_0)
			if_set(var_15_0 and arg_15_1:getChildByName("n_toprank") or arg_15_1, "txt_rank", T("pvp_list_rank", {
				rank = arg_15_3.rank
			}))
			
			local var_15_1 = arg_15_1:getChildByName("n_recom")
			local var_15_2 = arg_15_3.last_rank - arg_15_3.rank
			
			if_set_visible(var_15_1, "up", var_15_2 > 0)
			if_set_visible(var_15_1, "down", var_15_2 < 0)
			if_set_visible(var_15_1, "keep", var_15_2 == 0)
			if_set(var_15_1, "t_count", var_15_2 == 0 and "" or var_15_2)
			ClanWarUIUtil:setGuildInfo(arg_15_1:getChildByName("n_clan"), arg_15_3.clan)
			
			arg_15_1:getChildByName("btn_info").clan = arg_15_3.clan
			arg_15_1:getChildByName("btn_info").mode = "ranking"
			
			local var_15_3 = arg_15_1:getChildByName("btn_clan_info")
			
			if get_cocos_refid(var_15_3) then
				var_15_3.clan_id = arg_15_3.clan.clan_id
			end
		end
	}
	
	arg_14_0.vars.listview:setRenderer(load_control("wnd/clan_war_ranking_item.csb"), var_14_0)
end

function ClanWarRanking.setMyRankingInfo(arg_16_0, arg_16_1)
	local var_16_0 = ClanWarResultDetail:getWnd():getChildByName("n_my_ranking")
	
	if_set_visible(var_16_0, "n_info", false)
	if_set_visible(var_16_0, "n_rank", true)
	if_set(var_16_0, "txt_rank_num", T("war_ui_0071", {
		rank = arg_16_1.rank or " - "
	}))
	if_set(var_16_0, "txt_point_num", arg_16_1.score or " - ")
	
	local var_16_1 = DB("clan_war_rank_grade", arg_16_1.grade_key, {
		"grade_name"
	})
	
	if_set(var_16_0, "t_title", T(var_16_1))
end

function ClanWarRanking.setRankingInfo(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or {}
	
	local var_17_0 = {}
	
	for iter_17_0, iter_17_1 in pairs(arg_17_1) do
		iter_17_1.prev_rank = iter_17_1.prev_rank or iter_17_1.rank
		
		if iter_17_1.prev_rank == 0 then
			iter_17_1.prev_rank = iter_17_1.rank
		end
		
		var_17_0[iter_17_0] = {
			rank = iter_17_1.rank,
			last_rank = iter_17_1.prev_rank,
			clan = {
				week_id = iter_17_1.clan_info.week_id,
				clan_id = iter_17_1.clan_info.clan_id,
				emblem = iter_17_1.clan_info.emblem,
				level = iter_17_1.clan_info.level,
				name = iter_17_1.clan_info.name,
				points = iter_17_1.score,
				member_count = iter_17_1.clan_info.member_count,
				contribution_score = iter_17_1.clan_info.contribution_score,
				week_support_count = iter_17_1.clan_info.week_support_count
			}
		}
	end
	
	table.sort(var_17_0, function(arg_18_0, arg_18_1)
		return arg_18_0.rank < arg_18_1.rank
	end)
	arg_17_0.vars.listview:removeAllChildren()
	arg_17_0.vars.listview:setDataSource(var_17_0)
	arg_17_0.vars.listview:jumpToTop()
end
