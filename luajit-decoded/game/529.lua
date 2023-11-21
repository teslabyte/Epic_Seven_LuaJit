ClanWarHistory = {}

local var_0_0 = 5

function MsgHandler.get_clan_war_member_record_datas(arg_1_0)
	if arg_1_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	if arg_1_0.datas then
		ClanWar:setClanWarMemberRecords(arg_1_0.datas)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_member_record_datas then
			ClanWar.vars.onGetQueryResult.get_clan_war_member_record_datas()
			
			ClanWar.vars.onGetQueryResult.get_clan_war_member_record_datas = nil
		end
	end
end

function MsgHandler.get_clan_war_member_season_record_datas(arg_2_0)
	if arg_2_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	if arg_2_0.datas then
		ClanWar:setClanWarMemberSeasonRecords(arg_2_0.datas)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_member_season_record_datas then
			ClanWar.vars.onGetQueryResult.get_clan_war_member_season_record_datas()
			
			ClanWar.vars.onGetQueryResult.get_clan_war_member_season_record_datas = nil
		end
	end
end

function MsgHandler.get_clan_war_member_prev_season_record_datas(arg_3_0)
	if arg_3_0.res ~= "ok" then
		ClanWar.vars.query_time_secs = {}
		
		return 
	end
	
	if arg_3_0.datas then
		ClanWar:setClanWarMemberPrevSeasonRecords(var_0_0, arg_3_0.datas)
		
		if ClanWar.vars and ClanWar.vars.onGetQueryResult.get_clan_war_member_prev_season_record_datas then
			ClanWar.vars.onGetQueryResult.get_clan_war_member_prev_season_record_datas()
			
			ClanWar.vars.onGetQueryResult.get_clan_war_member_prev_season_record_datas = nil
		end
	end
end

function HANDLER.clan_war_history(arg_4_0, arg_4_1)
	if string.find(arg_4_1, "btn_tab") then
		ClanWarHistory:setTab(tonumber(string.sub(arg_4_1, -1, -1)))
	elseif arg_4_1 == "btn_close" then
		ClanWarHistory:close()
	end
end

function ClanWarHistory.open(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1 or SceneManager:getDefaultLayer()
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("clan_war_history", true, "wnd", function()
		arg_5_0:close()
	end)
	arg_5_0.vars.records = nil
	arg_5_0.vars.season_records = nil
	arg_5_0.vars.prev_season_records = nil
	
	if_set_visible(arg_5_0.vars.wnd, "tab3", true)
	var_5_0:addChild(arg_5_0.vars.wnd)
	arg_5_0.vars.wnd:setPositionX(arg_5_0.vars.wnd:getPositionX() - var_5_0:getPositionX())
	arg_5_0.vars.wnd:setPositionY(arg_5_0.vars.wnd:getPositionY() - var_5_0:getPositionY())
	arg_5_0:initListView()
	
	local var_5_1 = arg_5_0.vars.wnd:getChildByName("cm_tooltipbox")
	
	if_set_visible(var_5_1, "n_no_data", true)
	arg_5_0:setTab(1)
	UIUtil:slideOpen(arg_5_0.vars.wnd, var_5_1, true)
	SoundEngine:play("event:/ui/popup/tap")
end

function ClanWarHistory.req_seasonRecorde(arg_7_0)
	arg_7_0.vars.season_records = {}
	
	ClanWar:query("get_clan_war_member_season_record_datas", function()
		local var_8_0 = ClanWar:getClanWarMemberSeasonRecords(5)
		
		if_set_visible(arg_7_0.vars.wnd, "n_no_data", false)
		arg_7_0:setSeasonRecordListItems(var_8_0)
		arg_7_0:updateUI()
	end)
end

function ClanWarHistory.req_prev_seasonRecorde(arg_9_0)
	arg_9_0.vars.prev_season_records = {}
	
	ClanWar:query("get_clan_war_member_prev_season_record_datas", function()
		local var_10_0 = ClanWar:getClanWarMemberPrevSeasonRecords(var_0_0)
		
		if_set_visible(arg_9_0.vars.wnd, "n_no_data", false)
		arg_9_0:setPrevSeasonRecordListItems(var_10_0)
		arg_9_0:updateUI()
	end)
end

function ClanWarHistory.req_recorde(arg_11_0)
	arg_11_0.vars.records = {}
	
	ClanWar:query("get_clan_war_member_record_datas", function()
		local var_12_0 = ClanWar:getClanWarMemberRecords()
		
		if_set_visible(arg_11_0.vars.wnd, "n_no_data", false)
		arg_11_0:setRecordListItems(var_12_0)
		arg_11_0:updateUI()
	end)
end

function ClanWarHistory.setTab(arg_13_0, arg_13_1)
	if arg_13_1 == 1 then
		arg_13_0.vars.mode = "member_record"
	elseif arg_13_1 == 2 then
		arg_13_0.vars.mode = "member_season_record"
	elseif arg_13_1 == 3 then
		arg_13_0.vars.mode = "member_prev_season_record"
	end
	
	for iter_13_0 = 1, 5 do
		local var_13_0 = arg_13_0.vars.wnd:getChildByName("tab" .. iter_13_0)
		
		if not get_cocos_refid(var_13_0) then
			break
		end
		
		if_set_visible(var_13_0, "bg", arg_13_1 == iter_13_0)
	end
	
	arg_13_0:updateUI()
end

function ClanWarHistory.updateUI(arg_14_0)
	if arg_14_0.vars.mode == "member_record" then
		if arg_14_0.vars.records == nil then
			arg_14_0:req_recorde()
		else
			arg_14_0.vars.listview:setItems(arg_14_0.vars.records)
			if_set_visible(arg_14_0.vars.wnd, "n_no_data", table.count(arg_14_0.vars.records) == 0)
		end
		
		if_set(arg_14_0.vars.wnd, "txt_desc", T("clanwar_history_tap1_desc"))
	elseif arg_14_0.vars.mode == "member_season_record" then
		if arg_14_0.vars.season_records == nil then
			arg_14_0:req_seasonRecorde()
		else
			arg_14_0.vars.listview:setItems(arg_14_0.vars.season_records)
			if_set_visible(arg_14_0.vars.wnd, "n_no_data", table.count(arg_14_0.vars.season_records) == 0)
		end
		
		if_set(arg_14_0.vars.wnd, "txt_desc", T("clanwar_history_tap2_desc"))
	elseif arg_14_0.vars.mode == "member_prev_season_record" then
		if arg_14_0.vars.prev_season_records == nil then
			arg_14_0:req_prev_seasonRecorde()
		else
			arg_14_0.vars.listview:setItems(arg_14_0.vars.prev_season_records)
			if_set_visible(arg_14_0.vars.wnd, "n_no_data", table.count(arg_14_0.vars.prev_season_records) == 0)
		end
		
		if_set(arg_14_0.vars.wnd, "txt_desc", T("clanwar_history_tap3_desc"))
	end
	
	arg_14_0.vars.listview:jumpToTop()
end

function ClanWarHistory.initListView(arg_15_0)
	arg_15_0.vars.listview = ItemListView:bindControl(arg_15_0.vars.wnd:getChildByName("listview"))
	
	local var_15_0 = {
		onUpdate = function(arg_16_0, arg_16_1, arg_16_2)
			local var_16_0 = arg_16_1:getChildByName("n_attack")
			local var_16_1 = arg_16_1:getChildByName("n_defense")
			
			if_set(var_16_0, "t_result_1", T("war_ui_0038", {
				value = arg_16_2.attack_win_count or 0
			}))
			if_set(var_16_0, "t_result_2", T("war_ui_0039", {
				value = arg_16_2.attack_defeat_count or 0
			}))
			if_set(var_16_0, "t_result_draw", T("war_ui_0059", {
				value = arg_16_2.attack_draw_count or 0
			}))
			if_set_opacity(var_16_0, "t_result_1", arg_16_2.attack_win_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_0, "t_result_2", arg_16_2.attack_defeat_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_0, "t_result_draw", arg_16_2.attack_draw_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_0, "icon_result_1", arg_16_2.attack_win_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_0, "icon_result_2", arg_16_2.attack_defeat_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_0, "icon_result_darw", arg_16_2.attack_draw_count == 0 and 76.5 or 255)
			if_set(var_16_1, "t_result_1", T("war_ui_0038", {
				value = arg_16_2.defense_win_count or 0
			}))
			if_set(var_16_1, "t_result_2", T("war_ui_0039", {
				value = arg_16_2.defense_defeat_count or 0
			}))
			if_set(var_16_1, "t_result_draw", T("war_ui_0059", {
				value = arg_16_2.defense_draw_count or 0
			}))
			if_set_opacity(var_16_1, "t_result_1", arg_16_2.defense_win_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_1, "t_result_2", arg_16_2.defense_defeat_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_1, "t_result_draw", arg_16_2.defense_draw_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_1, "icon_result_1", arg_16_2.defense_win_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_1, "icon_result_2", arg_16_2.defense_defeat_count == 0 and 76.5 or 255)
			if_set_opacity(var_16_1, "icon_result_darw", arg_16_2.defense_draw_count == 0 and 76.5 or 255)
			
			local var_16_2 = Clan:getMemberInfoById(arg_16_2.user_id) or {}
			local var_16_3 = var_16_2.user_info or {}
			local var_16_4 = UIUtil:numberDigitToCharOffset(var_16_3.level, 1, 0)
			
			UIUtil:warpping_setLevel(arg_16_1:getChildByName("n_lv"), var_16_3.level, MAX_ACCOUNT_LEVEL, 2, {
				offset_per_char = var_16_4
			})
			
			local var_16_5 = var_16_3.leader_code or "m0000"
			
			UIUtil:getRewardIcon(nil, var_16_5, {
				no_popup = true,
				character_type = "character",
				scale = 1,
				no_grade = true,
				parent = arg_16_1:getChildByName("mob_icon"),
				border_code = var_16_3.border_code
			})
			if_set(arg_16_1, "t_name", var_16_3.name or T("ui_clan_home_notice_unknown_member"))
			if_set_visible(arg_16_1, "master", var_16_2.grade == CLAN_GRADE.master)
			if_set_visible(arg_16_1, "sub_master", var_16_2.grade == CLAN_GRADE.executives)
		end
	}
	
	arg_15_0.vars.listview:setRenderer(load_control("wnd/clan_war_history_item_battle.csb"), var_15_0)
end

function ClanWarHistory.setRecordListItems(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1 or {}
	local var_17_1 = {}
	
	if table.empty(var_17_0) then
		arg_17_0.vars.records = {}
		
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		local var_17_2 = Clan:getMemberInfoById(iter_17_1.user_id)
		local var_17_3 = 5
		local var_17_4 = 0
		
		if var_17_2 then
			iter_17_1.grade = var_17_2.grade
			iter_17_1.join_time = var_17_2.join_time
		end
		
		table.insert(arg_17_0.vars.records, iter_17_1)
		
		var_17_1[iter_17_1.user_id] = true
	end
	
	local var_17_5 = Clan:getMembers()
	
	for iter_17_2, iter_17_3 in pairs(var_17_5) do
		if not var_17_1[iter_17_3.user_id] then
			local var_17_6 = {
				attack_win_count = 0,
				defense_defeat_count = 0,
				defense_draw_count = 0,
				defense_win_count = 0,
				attack_draw_count = 0,
				attack_defeat_count = 0,
				user_id = iter_17_3.user_id,
				grade = iter_17_3.grade,
				join_time = iter_17_3.join_time
			}
			
			table.insert(arg_17_0.vars.records, var_17_6)
		end
	end
	
	arg_17_0:_setSorting(arg_17_0.vars.records)
end

function ClanWarHistory.setSeasonRecordListItems(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1 or {}
	local var_18_1 = {}
	
	if table.empty(var_18_0) then
		arg_18_0.vars.season_records = {}
		
		return 
	end
	
	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		local var_18_2 = Clan:getMemberInfoById(iter_18_1.user_id)
		local var_18_3 = 5
		local var_18_4 = 0
		
		if var_18_2 then
			iter_18_1.grade = var_18_2.grade
			iter_18_1.join_time = var_18_2.join_time
		end
		
		table.insert(arg_18_0.vars.season_records, iter_18_1)
		
		var_18_1[iter_18_1.user_id] = true
	end
	
	local var_18_5 = Clan:getMembers()
	
	for iter_18_2, iter_18_3 in pairs(var_18_5) do
		if not var_18_1[iter_18_3.user_id] then
			local var_18_6 = {
				attack_win_count = 0,
				defense_defeat_count = 0,
				defense_draw_count = 0,
				defense_win_count = 0,
				attack_draw_count = 0,
				attack_defeat_count = 0,
				user_id = iter_18_3.user_id,
				grade = iter_18_3.grade,
				join_time = iter_18_3.join_time
			}
			
			table.insert(arg_18_0.vars.season_records, var_18_6)
		end
	end
	
	arg_18_0:_setSorting(arg_18_0.vars.season_records)
end

function ClanWarHistory.setPrevSeasonRecordListItems(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1 or {}
	local var_19_1 = {}
	
	if table.empty(var_19_0) then
		arg_19_0.vars.prev_season_records = {}
		
		return 
	end
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		local var_19_2 = Clan:getMemberInfoById(iter_19_1.user_id)
		local var_19_3 = 5
		local var_19_4 = 0
		
		if var_19_2 then
			iter_19_1.grade = var_19_2.grade
			iter_19_1.join_time = var_19_2.join_time
		end
		
		table.insert(arg_19_0.vars.prev_season_records, iter_19_1)
		
		var_19_1[iter_19_1.user_id] = true
	end
	
	local var_19_5 = Clan:getMembers()
	
	for iter_19_2, iter_19_3 in pairs(var_19_5) do
		if not var_19_1[iter_19_3.user_id] then
			local var_19_6 = {
				attack_win_count = 0,
				defense_defeat_count = 0,
				defense_draw_count = 0,
				defense_win_count = 0,
				attack_draw_count = 0,
				attack_defeat_count = 0,
				user_id = iter_19_3.user_id,
				grade = iter_19_3.grade,
				join_time = iter_19_3.join_time
			}
			
			table.insert(arg_19_0.vars.prev_season_records, var_19_6)
		end
	end
	
	arg_19_0:_setSorting(arg_19_0.vars.prev_season_records)
end

function ClanWarHistory.close(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	UIUtil:slideOpen(arg_20_0.vars.wnd, arg_20_0.vars.wnd:getChildByName("cm_tooltipbox"), false)
	BackButtonManager:pop("clan_war_history")
	
	arg_20_0.vars = nil
end

function ClanWarHistory._setSorting(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1 or {}
	
	table.sort(var_21_0, function(arg_22_0, arg_22_1)
		if arg_22_0.grade == CLAN_GRADE.master then
			return true
		end
		
		if arg_22_1.grade == CLAN_GRADE.master then
			return false
		end
		
		if arg_22_0.grade == CLAN_GRADE.master and arg_22_1.grade == CLAN_GRADE.executives then
			return true
		end
		
		if arg_22_1.grade == CLAN_GRADE.master and arg_22_0.grade == CLAN_GRADE.executives then
			return false
		end
		
		if arg_22_0.grade == CLAN_GRADE.executives and arg_22_1.grade == CLAN_GRADE.member then
			return true
		end
		
		if arg_22_1.grade == CLAN_GRADE.executives and arg_22_0.grade == CLAN_GRADE.member then
			return false
		end
		
		if arg_22_0.grade == CLAN_GRADE.member and arg_22_1.grade == CLAN_GRADE.member then
			return arg_22_0.join_time < arg_22_1.join_time
		end
	end)
end
