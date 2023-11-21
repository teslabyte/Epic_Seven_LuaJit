LotaRankingBoardUI = {}

function HANDLER.clan_heritage_ranking_board(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaRankingBoardUI:close()
	end
	
	if arg_1_1 == "btn_floor_rank" then
		LotaRankingBoardUI:requestDetailQuery(arg_1_0, arg_1_1)
	end
	
	if arg_1_1 == "btn_get" then
		LotaRankingBoardUI:requestReward(arg_1_0, arg_1_1)
	end
	
	if arg_1_1 == "btn_show_clan_detail" and arg_1_0.clan_id then
		LotaRankingBoardUI:requestClanDetail(arg_1_0.clan_id)
	end
end

function HANDLER.clan_heritage_ranking(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		LotaRankingBoardUI:closeRankingDetail()
	end
end

function LotaRankingBoardUI.requestDetailQuery(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1.floor
	
	arg_3_0.vars.request_floor = var_3_0
	arg_3_0.vars.clicked_cont = arg_3_1
	
	if (arg_3_0.vars.last_response_tm[arg_3_0.vars.request_floor] or 0) + 60 > os.time() then
		arg_3_0:openRankingDetail(arg_3_0.vars.request_floor)
	else
		LotaNetworkSystem:sendQuery("lota_ranking_board_detail", {
			floor = var_3_0
		})
	end
end

function LotaRankingBoardUI.requestReward(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1.floor > LotaUserData:getLastRewardFloor() then
		LotaNetworkSystem:sendQuery("lota_get_reward_ranking_board")
	else
		LotaUtil:sendWIPText("이런~~ 이미 다 받아버렸어요~~")
	end
end

function LotaRankingBoardUI.onResponseBoardDetail(arg_5_0, arg_5_1)
	arg_5_0.vars.last_response[arg_5_0.vars.request_floor] = arg_5_1
	arg_5_0.vars.last_response_tm[arg_5_0.vars.request_floor] = os.time()
	
	arg_5_0:openRankingDetail(arg_5_0.vars.request_floor)
end

function LotaRankingBoardUI.onResponseRewards(arg_6_0, arg_6_1)
	LotaUserData:responseLastRewardFloor(arg_6_1.floor_reward_step)
	Account:addReward(arg_6_1.rewards, {
		single = true,
		effect = true
	})
	arg_6_0:updateUI()
	LotaEnterUI:updateUI()
end

function LotaRankingBoardUI.requestClanDetail(arg_7_0, arg_7_1)
	Clan:queryPreview(arg_7_1, "lota_ranking_preview")
end

function HANDLER.clan_heritage_ranking_item(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_show_clan_detail" and arg_8_0.clan_id then
		LotaRankingBoardUI:requestClanDetail(arg_8_0.clan_id)
	end
end

function LotaRankingBoardUI.openRankingDetail(arg_9_0, arg_9_1)
	local var_9_0 = LotaUtil:getUIDlg("clan_heritage_ranking")
	local var_9_1 = arg_9_0.vars.last_response[arg_9_1]
	
	arg_9_0.vars.ranking_detail = var_9_0
	
	if_set(arg_9_0.vars.ranking_detail, "t_title", T("ui_clanheritage_rank_tooltip_floor", {
		floor = arg_9_1
	}))
	SceneManager:getRunningNativeScene():addChild(arg_9_0.vars.ranking_detail)
	
	arg_9_0.vars.ScrollRankingDetail = {}
	
	copy_functions(ScrollView, arg_9_0.vars.ScrollRankingDetail)
	
	function arg_9_0.vars.ScrollRankingDetail.getScrollViewItem(arg_10_0, arg_10_1)
		local var_10_0 = LotaUtil:getUIControl("clan_heritage_ranking_item")
		
		arg_9_0:updateListControl(var_10_0, arg_10_1)
		
		local var_10_1 = var_10_0:findChildByName("n_toprank")
		
		if_set_visible(var_10_1, nil, arg_10_1.rank <= 3)
		if_set_visible(var_10_0, "txt_rank", arg_10_1.rank > 3)
		
		if arg_10_1.rank <= 3 then
			if_set(var_10_1, "txt_rank", T("expedition_rank", {
				rank = arg_10_1.rank
			}))
		else
			if_set(var_10_0, "txt_rank", T("expedition_rank", {
				rank = arg_10_1.rank
			}))
		end
		
		local var_10_2 = var_10_0:findChildByName("btn_show_clan_detail")
		
		if var_10_2 then
			var_10_2.clan_id = arg_10_1.clan_id
		end
		
		return var_10_0
	end
	
	local var_9_2 = {}
	
	for iter_9_0, iter_9_1 in pairs(var_9_1.rank_list) do
		local var_9_3 = table.clone(iter_9_1)
		local var_9_4 = LotaEnterUI:getCurrentSchedule()
		
		var_9_3.clear_tm = math.floor(tonumber(var_9_3.score) / 10000) - var_9_4.start_time
		var_9_2[iter_9_0] = var_9_3
	end
	
	arg_9_0.vars.ScrollRankingDetail:initScrollView(arg_9_0.vars.ranking_detail:findChildByName("ScrollView"), 420, 113)
	arg_9_0.vars.ScrollRankingDetail:createScrollViewItems(var_9_2)
	BackButtonManager:push({
		back_func = function()
			LotaRankingBoardUI:closeRankingDetail()
		end,
		dlg = arg_9_0.vars.ranking_detail
	})
end

function LotaRankingBoardUI.closeRankingDetail(arg_12_0)
	if arg_12_0.vars.ranking_detail then
		BackButtonManager:pop()
		arg_12_0.vars.ranking_detail:removeFromParent()
		
		arg_12_0.vars.ranking_detail = nil
		arg_12_0.vars.ScrollRankingDetail = nil
	end
end

function LotaRankingBoardUI.open(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.vars = {}
	arg_13_0.vars.last_response = {}
	arg_13_0.vars.last_response_tm = {}
	arg_13_0.vars.parent = arg_13_1
	arg_13_0.vars.ranker = arg_13_2.ranker
	arg_13_0.vars.ranker_data = arg_13_2.clans
	arg_13_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_ranking_board")
	
	BackButtonManager:push({
		back_func = function()
			LotaRankingBoardUI:close()
		end,
		dlg = arg_13_0.vars.dlg
	})
	arg_13_0:setupUI()
	arg_13_0:updateUI()
	arg_13_1:addChild(arg_13_0.vars.dlg)
end

function LotaRankingBoardUI.isActive(arg_15_0)
	return arg_15_0.vars and get_cocos_refid(arg_15_0.vars.dlg)
end

function LotaRankingBoardUI.updateListControl(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_2.clan_info
	local var_16_1 = arg_16_2.clear_tm
	local var_16_2 = arg_16_2.floor
	
	if_set(arg_16_1, "txt_floor_clear", T("ui_clanheritage_rank_popup_floor", {
		floor = var_16_2
	}))
	
	if not var_16_0 then
		if_set_visible(arg_16_1, "n_clear", false)
		if_set_visible(arg_16_1, "n_none", true)
		
		return 
	end
	
	if_set_visible(arg_16_1, "n_clear", true)
	if_set_visible(arg_16_1, "n_none", false)
	
	local var_16_3 = arg_16_1:findChildByName("n_clan")
	
	UIUtil:updateClanEmblem(var_16_3, var_16_0)
	UIUtil:warpping_setLevel(var_16_3:getChildByName("n_lv"), var_16_0.level, CLAN_MAX_LEVEL, 2, {
		is_clan_level = true
	})
	
	local var_16_4 = arg_16_1:findChildByName("t_clan_name")
	
	if get_cocos_refid(var_16_4) then
		UIUserData:call(var_16_4, "SINGLE_WSCALE(134)")
		if_set(var_16_4, nil, var_16_0.name)
	end
	
	if_set(var_16_3, "t_time", sec_to_full_string(var_16_1))
end

function LotaRankingBoardUI.updateListViewUpdate(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:updateListControl(arg_17_1, arg_17_2)
	
	local var_17_0 = arg_17_2.floor
	local var_17_1, var_17_2 = LotaUserData:getRankingRewardToken()
	local var_17_3 = UIUtil:getRewardIcon(var_17_2, var_17_1)
	
	arg_17_1:findChildByName("n_reward"):addChild(var_17_3)
	if_set_visible(arg_17_1, "btn_get", var_17_0 > LotaUserData:getLastRewardFloor())
	if_set_visible(arg_17_1, "n_complet", var_17_0 <= LotaUserData:getLastRewardFloor())
	if_set(arg_17_1, "t_floor", var_17_0)
	
	arg_17_1:findChildByName("btn_floor_rank").floor = var_17_0
	arg_17_1:findChildByName("btn_get").floor = var_17_0
	
	local var_17_4 = arg_17_1:findChildByName("btn_show_clan_detail")
	
	if var_17_4 then
		var_17_4.clan_id = arg_17_2.clan_id
	end
end

function LotaRankingBoardUI.setupUI(arg_18_0)
	local var_18_0 = arg_18_0.vars.dlg:findChildByName("listview")
	local var_18_1 = ItemListView_v2:bindControl(var_18_0)
	local var_18_2 = LotaUtil:getUIControl("clan_heritage_ranking_board_item")
	
	arg_18_0.vars.listview = var_18_1
	
	local var_18_3 = {
		onUpdate = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			arg_18_0:updateListViewUpdate(arg_19_1, arg_19_3)
		end
	}
	
	arg_18_0.vars.listview:setRenderer(var_18_2, var_18_3)
end

function LotaRankingBoardUI.updateUI(arg_20_0)
	local var_20_0 = arg_20_0.vars.ranker
	local var_20_1 = arg_20_0.vars.ranker_data
	local var_20_2 = {}
	
	for iter_20_0 = 1, 4 do
		local var_20_3 = var_20_0["floor_" .. iter_20_0 .. "_clan"]
		local var_20_4 = var_20_0["floor_" .. iter_20_0 .. "_tm"]
		
		if not var_20_3 or not var_20_4 then
			table.insert(var_20_2, {
				floor = iter_20_0
			})
		else
			local var_20_5 = LotaEnterUI:getCurrentSchedule()
			local var_20_6 = math.floor(tonumber(var_20_4) / 10000) - var_20_5.start_time
			
			table.insert(var_20_2, {
				floor = iter_20_0,
				clear_tm = var_20_6,
				clan_id = var_20_3,
				clan_info = var_20_1[tostring(var_20_3)]
			})
		end
	end
	
	arg_20_0.vars.listview:removeAllChildren()
	arg_20_0.vars.listview:setDataSource(var_20_2)
end

function LotaRankingBoardUI.close(arg_21_0)
	if arg_21_0.vars and get_cocos_refid(arg_21_0.vars.dlg) then
		BackButtonManager:pop()
		arg_21_0.vars.dlg:removeFromParent()
		
		arg_21_0.vars = nil
	end
end
