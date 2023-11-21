ClanWarResultDetail = {}

function HANDLER.clan_war_rank_reward_tip(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		ClanWarRanking:closeRewardTip()
	end
end

function HANDLER.clan_war_ranking(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_clan_info" then
		if get_cocos_refid(arg_2_0) and arg_2_0.clan_id then
			Clan:queryPreview(arg_2_0.clan_id, "preview")
		end
		
		return 
	end
	
	if arg_2_1 == "btn_close" then
		ClanWarResultDetail:close()
	end
	
	if arg_2_1 == "btn_info" then
		Clan:queryPreview(arg_2_0.clan.clan_id, arg_2_0.mode)
	end
	
	if arg_2_1 == "btn_reward_info" then
		ClanWarRanking:openRewardTip()
	end
	
	if arg_2_1 == "btn1" or arg_2_1 == "btn2" or arg_2_1 == "btn3" then
		ClanWarResultDetail:selectTab(tonumber(string.sub(arg_2_1, -1, -1)))
	end
end

function HANDLER.clan_war_ranking_hall_of_fame_card_l(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_clan_info" then
		if get_cocos_refid(arg_3_0) and arg_3_0.clan_id then
			Clan:queryPreview(arg_3_0.clan_id, "preview")
		end
		
		return 
	end
end

function HANDLER.clan_war_ranking_hall_of_fame_card_s(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_clan_info" then
		if get_cocos_refid(arg_4_0) and arg_4_0.clan_id then
			Clan:queryPreview(arg_4_0.clan_id, "preview")
		end
		
		return 
	end
end

function ClanWarResultDetail.open(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.tab = 1
	
	local var_5_0 = arg_5_1 or SceneManager:getDefaultLayer()
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("clan_war_ranking", true, "wnd", function()
		arg_5_0:close()
	end)
	
	var_5_0:addChild(arg_5_0.vars.wnd)
	arg_5_0.vars.wnd:setPositionX(arg_5_0.vars.wnd:getPositionX() - var_5_0:getPositionX())
	arg_5_0.vars.wnd:setPositionY(arg_5_0.vars.wnd:getPositionY() - var_5_0:getPositionY())
	UIUtil:slideOpen(arg_5_0.vars.wnd, arg_5_0.vars.wnd:getChildByName("cm_tooltipbox"), true)
	SoundEngine:play("event:/ui/popup/tap")
	
	arg_5_0.vars.rankingListView = arg_5_0.vars.wnd:getChildByName("listview")
	arg_5_0.vars.historyListView = arg_5_0.vars.wnd:getChildByName("listview_history")
	arg_5_0.vars.honorListView = arg_5_0.vars.wnd:getChildByName("listview_honor")
	arg_5_0.vars.isInitRanking = false
	arg_5_0.vars.isInitHistory = false
	arg_5_0.vars.isInitHonor = false
	
	arg_5_0:selectTab(1)
end

function ClanWarResultDetail.selectTab(arg_7_0, arg_7_1)
	if arg_7_1 == 3 and Account:getCurrentWarUId() < 4 then
		balloon_message_with_sound("clanwar_notyet_msg")
		
		return 
	end
	
	arg_7_0.vars.tab = arg_7_1
	
	arg_7_0:updateUI()
end

function ClanWarResultDetail.updateUI(arg_8_0)
	for iter_8_0 = 1, 3 do
		local var_8_0 = arg_8_0.vars.wnd:getChildByName("tab" .. iter_8_0)
		
		if not get_cocos_refid(var_8_0) then
			break
		end
		
		if_set_visible(var_8_0, "bg", iter_8_0 == arg_8_0.vars.tab)
	end
	
	if arg_8_0.vars.tab == 1 then
		if_set_visible(arg_8_0.vars.wnd, "listview", true)
		if_set_visible(arg_8_0.vars.wnd, "listview_history", false)
		if_set_visible(arg_8_0.vars.wnd, "listview_honor", false)
		if_set_visible(arg_8_0.vars.wnd, "n_honor", false)
		if_set_visible(arg_8_0.vars.wnd, "n_my_ranking", true)
		
		if not arg_8_0.vars.isInitRanking then
			ClanWarRanking:init()
			
			arg_8_0.vars.isInitRanking = true
		else
			if_set_visible(arg_8_0.vars.wnd, "n_no_data", ClanWarRanking:isEmtyList())
		end
	elseif arg_8_0.vars.tab == 2 then
		if_set_visible(arg_8_0.vars.wnd, "listview", false)
		if_set_visible(arg_8_0.vars.wnd, "listview_history", true)
		if_set_visible(arg_8_0.vars.wnd, "listview_honor", false)
		if_set_visible(arg_8_0.vars.wnd, "n_honor", false)
		if_set_visible(arg_8_0.vars.wnd, "n_my_ranking", false)
		
		if not arg_8_0.vars.isInitHistory then
			ClanWarResultDetail:init_history()
			
			arg_8_0.vars.isInitHistory = true
		else
			if_set_visible(arg_8_0.vars.wnd, "n_no_data", ClanWarResultDetail:isEmtyRecords())
		end
	elseif arg_8_0.vars.tab == 3 then
		if_set_visible(arg_8_0.vars.wnd, "listview", false)
		if_set_visible(arg_8_0.vars.wnd, "listview_history", false)
		if_set_visible(arg_8_0.vars.wnd, "listview_honor", true)
		if_set_visible(arg_8_0.vars.wnd, "n_honor", false)
		if_set_visible(arg_8_0.vars.wnd, "n_my_ranking", false)
		
		if not arg_8_0.vars.isInitHonor then
			arg_8_0.vars.isInitHonor = true
			
			ClanWarResultDetail:init_hallofFame()
		else
			if_set_visible(arg_8_0.vars.wnd, "n_no_data", ClanWarResultDetail:isEmtyinfo())
		end
	end
end

function ClanWarResultDetail.getWnd(arg_9_0)
	return arg_9_0.vars.wnd
end

function ClanWarResultDetail.getRankingListview(arg_10_0)
	return arg_10_0.vars.rankingListView
end

function ClanWarResultDetail.getHistoryListview(arg_11_0)
	return arg_11_0.vars.historyListView
end

function ClanWarResultDetail.getHonorListview(arg_12_0)
	return arg_12_0.vars.honorListView
end

function ClanWarResultDetail.close(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	UIUtil:slideOpen(arg_13_0.vars.wnd, arg_13_0.vars.wnd:getChildByName("cm_tooltipbox"), false)
	BackButtonManager:pop("clan_war_ranking")
end

function ClanWarResultDetail.init_history(arg_14_0)
	arg_14_0:initListView()
	
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("cm_tooltipbox")
	
	if_set_visible(var_14_0, "n_no_data", true)
	ClanWar:query("get_clan_war_result_record_list", function()
		arg_14_0.vars.records = ClanWar:getClanWarResultRecords()
		
		if_set_visible(var_14_0, "n_no_data", table.count(arg_14_0.vars.records) == 0)
		arg_14_0:setListItems(arg_14_0.vars.records)
	end)
end

function ClanWarResultDetail.isEmtyRecords(arg_16_0)
	if not arg_16_0.vars or not arg_16_0.vars.records or table.empty(arg_16_0.vars.records) then
		return true
	end
	
	return false
end

function ClanWarResultDetail.setGuildInfo(arg_17_0, arg_17_1, arg_17_2)
	UIUtil:updateClanEmblem(arg_17_1, arg_17_2)
	UIUtil:warpping_setLevel(arg_17_1:getChildByName("n_lv"), arg_17_2.level, CLAN_MAX_LEVEL, 2, {
		is_clan_level = true
	})
	
	local var_17_0 = arg_17_1:getChildByName("clan_name")
	
	UIUserData:call(var_17_0, "SINGLE_WSCALE(152)", {
		origin_scale_x = 0.83
	})
	if_set(arg_17_1, "clan_name", arg_17_2.name)
	if_set(arg_17_1, "clan_score", T("war_ui_0030", {
		value = comma_value(arg_17_2.points)
	}))
	
	local var_17_1 = arg_17_1:getChildByName("btn_clan_info")
	
	if get_cocos_refid(var_17_1) then
		var_17_1.clan_id = arg_17_2.clan_id
	end
end

function ClanWarResultDetail.initListView(arg_18_0)
	arg_18_0.vars.listview = ItemListView_v2:bindControl(ClanWarResultDetail:getHistoryListview())
	
	local var_18_0 = {
		onUpdate = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			local var_19_0 = arg_19_1:getChildByName("n_result")
			local var_19_1 = arg_19_3.win and "img/battle_pvp_icon_win_clan.png" or "img/battle_pvp_icon_lose_clan.png"
			
			if_set_sprite(var_19_0, "icon_result", var_19_1)
			if_set(var_19_0, "txt_result", T(arg_19_3.win and "war_ui_0028" or "war_ui_0029"))
			
			local var_19_2 = math.floor(os.time() - tonumber(arg_19_3.time))
			local var_19_3 = T("time_before", {
				time = sec_to_string(var_19_2, false, {
					day_floor = true
				})
			})
			
			if_set(var_19_0, "txt_desc", var_19_3)
			arg_18_0:setGuildInfo(arg_19_1:getChildByName("n_my"), arg_19_3.my)
			
			if arg_19_3.enemy.name then
				arg_18_0:setGuildInfo(arg_19_1:getChildByName("n_enemy"), arg_19_3.enemy)
				if_set_visible(arg_19_1, "n_enemy", true)
				if_set_visible(arg_19_1, "n_enemy_nodata", false)
			else
				arg_19_1:getChildByName("n_enemy"):setVisible(false)
				if_set_visible(arg_19_1, "n_enemy", false)
				
				local var_19_4 = arg_19_1:getChildByName("n_enemy_nodata")
				
				if_set_visible(var_19_4, nil, true)
				if_set(var_19_4, "label", T(arg_19_3.my.points > 0 and "war_ui_0095" or "war_ui_0094"))
			end
			
			table.print(arg_19_3.mvp_user_info)
			
			local var_19_5 = arg_19_3.mvp_user_info or {}
			
			if not table.empty(var_19_5) then
				local var_19_6 = arg_19_1:getChildByName("n_mvp_info")
				
				if_set(var_19_6, "mvp_name", var_19_5.name)
				UIUtil:getRewardIcon(nil, var_19_5.leader_code, {
					no_popup = true,
					character_type = "character",
					scale = 1,
					no_grade = true,
					parent = var_19_6:getChildByName("face_icon"),
					border_code = var_19_5.border_code
				})
				UIUserData:call(var_19_6:getChildByName("mvp_name"), "SINGLE_WSCALE(125)", {
					origin_scale_x = 0.75
				})
			else
				if_set_visible(arg_19_1, "n_mvp_info", false)
			end
			
			UIUserData:call(arg_19_1:getChildByName("txt_result"), "SINGLE_WSCALE(104)", {
				origin_scale_x = 0.55
			})
		end
	}
	
	arg_18_0.vars.listview:setRenderer(load_control("wnd/clan_war_history_item.csb"), var_18_0)
end

function ClanWarResultDetail.setListItems(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or {}
	
	local var_20_0 = {}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		var_20_0[iter_20_0] = {
			win = iter_20_1.result ~= 0,
			time = iter_20_1.time,
			my = {
				emblem = iter_20_1.clan_emblem,
				level = iter_20_1.clan_lv,
				name = iter_20_1.clan_name,
				points = iter_20_1.clan_destroy_score,
				clan_id = iter_20_1.clan_id
			},
			enemy = {
				emblem = iter_20_1.enemy_clan_emblem,
				level = iter_20_1.enemy_clan_lv,
				name = iter_20_1.enemy_clan_name,
				points = iter_20_1.enemy_clan_destroy_score,
				clan_id = iter_20_1.enemy_clan_id
			},
			mvp_user_info = iter_20_1.mvp_user_info
		}
	end
	
	arg_20_0.vars.listview:removeAllChildren()
	arg_20_0.vars.listview:setDataSource(var_20_0)
	arg_20_0.vars.listview:jumpToTop()
end

function ClanWarResultDetail.init_hallofFame(arg_21_0)
	arg_21_0:initHonorListView()
	arg_21_0:req_lists()
end

function ClanWarResultDetail.initHonorListView(arg_22_0)
	arg_22_0.vars.honorListView = ItemListView_v2:bindControl(ClanWarResultDetail:getHonorListview())
end

function ClanWarResultDetail.setHonorListItem(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_1 or not arg_23_2 then
		return 
	end
	
	local var_23_0 = Account:getWarSeasonInfo(arg_23_2[1].war_uid)
	
	if var_23_0 then
		local var_23_1 = DB("clan_war", var_23_0.id, "season_name")
		local var_23_2 = var_23_0.start_time or 0
		local var_23_3 = var_23_0.end_time or 0
		local var_23_4
		
		if UIUtil:isChangeSeasonLabelPosition() then
			var_23_4 = arg_23_1:getChildByName("n_season_2/2")
			
			var_23_4:setVisible(true)
			if_set_visible(arg_23_1, "n_season_1/2", false)
		else
			var_23_4 = arg_23_1:getChildByName("n_season_1/2")
			
			var_23_4:setVisible(true)
			if_set_visible(arg_23_1, "n_season_2/2", false)
		end
		
		if_set(var_23_4, "txt_season_number", T(var_23_1))
		if_set(arg_23_1, "txt_season_period", T("clanwar_ranking_tap3_desc3", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_23_2,
			end_time = var_23_3
		})))
	end
	
	local var_23_5 = false
	local var_23_6 = table.clone(arg_23_2)
	
	if var_23_0 and var_23_0.id == "war04" and arg_23_2[1] and arg_23_2[2] and tonumber(arg_23_2[1].clan_id) == 1103 and arg_23_2[1].name == "Deviants" and tonumber(arg_23_2[2].clan_id) == 336 and arg_23_2[2].name == "Veritas" then
		var_23_5 = true
		var_23_6[2], var_23_6[1] = var_23_6[1], var_23_6[2]
	end
	
	local var_23_7 = 1
	
	for iter_23_0 = 1, 3 do
		local var_23_8 = arg_23_1:getChildByName("n_" .. iter_23_0)
		
		if not get_cocos_refid(var_23_8) or not var_23_6[iter_23_0] then
			break
		end
		
		local var_23_9 = var_23_6[iter_23_0] or {}
		
		if_set(var_23_8, "txt_clan_name", var_23_9.name)
		UIUtil:warpping_setLevel(var_23_8:getChildByName("n_lv") or var_23_8:getChildByName("n_lv_0"), var_23_9.level, CLAN_MAX_LEVEL, 2, {
			is_clan_level = true
		})
		UIUtil:updateClanEmblem(var_23_8, var_23_9)
		
		if iter_23_0 == 2 then
			if_set_visible(var_23_8, "txt_1", var_23_5)
			if_set_visible(var_23_8, "txt_2", not var_23_5)
		end
		
		local var_23_10 = var_23_8:getChildByName("btn_clan_info")
		
		if get_cocos_refid(var_23_10) then
			var_23_10.clan_id = var_23_9.clan_id
		end
		
		var_23_7 = var_23_7 + 1
	end
	
	for iter_23_1 = var_23_7, 3 do
		if_set_visible(arg_23_1, "n_" .. iter_23_1, false)
	end
end

function ClanWarResultDetail.setHonorListInfo(arg_24_0, arg_24_1)
	local var_24_0 = {}
	local var_24_1 = {}
	
	for iter_24_0, iter_24_1 in pairs(arg_24_1) do
		if not var_24_0[iter_24_1.war_uid] then
			var_24_0[iter_24_1.war_uid] = {}
		end
		
		table.insert(var_24_0[iter_24_1.war_uid], iter_24_1)
		
		if not table.find(var_24_1, iter_24_1.war_uid) then
			table.insert(var_24_1, iter_24_1.war_uid)
		end
	end
	
	for iter_24_2, iter_24_3 in pairs(var_24_0) do
		table.sort(iter_24_3, function(arg_25_0, arg_25_1)
			return arg_25_0.rank < arg_25_1.rank
		end)
	end
	
	table.sort(var_24_1, function(arg_26_0, arg_26_1)
		return arg_26_0 < arg_26_1
	end)
	
	local var_24_2 = {}
	
	for iter_24_4, iter_24_5 in pairs(var_24_1) do
		if var_24_0[iter_24_5] then
			table.insert(var_24_2, var_24_0[iter_24_5])
		end
	end
	
	table.reverse(var_24_2)
	
	return var_24_2
end

function ClanWarResultDetail.setHonorListItems(arg_27_0, arg_27_1)
	arg_27_1 = arg_27_1 or {}
	
	arg_27_0.vars.honorListView:removeAllChildren()
	
	for iter_27_0, iter_27_1 in pairs(arg_27_1) do
		local var_27_0 = Account:getCurrentWarUId() or 4
		local var_27_1
		
		if iter_27_1[1] and iter_27_1[1].war_uid then
			if iter_27_1[1].war_uid ~= var_27_0 then
				var_27_1 = load_control("wnd/clan_war_ranking_hall_of_fame_card_s.csb")
			else
				var_27_1 = load_control("wnd/clan_war_ranking_hall_of_fame_card_l.csb")
			end
			
			arg_27_0:setHonorListItem(var_27_1, iter_27_1)
			arg_27_0.vars.honorListView:addChild(var_27_1)
		end
	end
	
	arg_27_0.vars.honorListView:jumpToTop()
end

function ClanWarResultDetail.req_lists(arg_28_0)
	ClanWar:query("get_clan_war_hall_of_fames", function()
		local var_29_0 = ClanWar:getClanWarHallOfFameInfo() or {}
		
		if_set_visible(arg_28_0.vars.wnd, "n_no_data", table.count(var_29_0) == 0)
		
		arg_28_0.vars.infos = arg_28_0:setHonorListInfo(var_29_0)
		
		arg_28_0:setHonorListItems(arg_28_0.vars.infos)
	end)
end

function ClanWarResultDetail.isEmtyinfo(arg_30_0)
	if not arg_30_0.vars or not arg_30_0.vars.infos or table.empty(arg_30_0.vars.infos) then
		return true
	end
	
	return false
end
