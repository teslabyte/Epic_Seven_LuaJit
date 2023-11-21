ClanWarClose = {}

function HANDLER.clan_war_Inability(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_defence_team" then
		if ClanWarTeam:isShow() then
			return 
		end
		
		ClanWarTeam:show({
			mode = "clan_pvp_defence",
			parent = SceneManager:getRunningNativeScene(),
			completeCB = function(arg_2_0, arg_2_1)
				ClanWarClose:updateTeamData(arg_2_0, arg_2_1)
			end
		})
	end
end

function HANDLER.clan_war_calculate(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_defence_team" then
		if ClanWarTeam:isShow() then
			return 
		end
		
		ClanWarTeam:show({
			mode = "clan_pvp_defence",
			parent = SceneManager:getRunningNativeScene()
		})
	elseif arg_3_1 == "btn_ranking" then
		ClanWarResultDetail:open()
	elseif arg_3_1 == "btn_history" then
		ClanWarHistory:open()
	end
end

function ClanWarClose.onPushBackButton(arg_4_0)
	SceneManager:popScene()
end

function ClanWarClose.setupUI(arg_5_0)
	local var_5_0 = DBT("clan_war", ClanWar:getWarID(), {
		"season_name",
		"season_type",
		"need_defense_count"
	})
	
	arg_5_0:settingCommonUI(var_5_0)
	
	if arg_5_0.vars.opts.state == "member_count" then
		arg_5_0:settingInabilityUI(var_5_0)
	else
		arg_5_0:settingCalculateUI()
	end
end

function ClanWarClose.settingCommonUI(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.season_name or ""
	
	if (arg_6_1.season_type or "") == "free" then
		if_set(arg_6_0.vars.wnd, "txt_season", T(var_6_0))
	else
		if_set(arg_6_0.vars.wnd, "txt_season", T("war_ui_0096", {
			name = T(var_6_0)
		}))
	end
	
	local var_6_1 = arg_6_0.vars.wnd:getChildByName("n_time")
	
	if ClanWar:getMode() ~= CLAN_WAR_MODE.WAR then
		if_set(var_6_1, "txt_until", T("war_state_play"))
	else
		if_set(var_6_1, "txt_until", T("war_state_end"))
	end
	
	if_set(var_6_1, "txt_time", T("war_time_h", {
		hour = math.floor(ClanWar:getRemainTime() / 3600)
	}))
end

function ClanWarClose.settingInabilityUI(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.need_defense_count or 1
	local var_7_1 = table.count(arg_7_0.vars.local_defense_data)
	
	if_set(arg_7_0.vars.wnd, "txt_disc", T("war_ui_0024", {
		defense = var_7_0
	}))
	if_set(arg_7_0.vars.wnd, "txt_count_mem", T("war_ui_0000", {
		curr = var_7_1,
		max = var_7_0
	}))
	if_set_percent(arg_7_0.vars.wnd, "progress_bar", var_7_1 / var_7_0)
end

local function var_0_0(arg_8_0)
	if arg_8_0 == "time" then
		return T("war_ui_0026"), T("war_ui_0027")
	elseif arg_8_0 == "matching_failed" then
		return T("war_ui_0060"), T("war_ui_0061")
	elseif arg_8_0 == "unearned_win" then
		return T("war_ui_desc8"), T("war_ui_desc9")
	else
		Log.e("State Was ", arg_8_0)
	end
end

function ClanWarClose.settingCalculateUI(arg_9_0)
	local var_9_0, var_9_1 = var_0_0(arg_9_0.vars.opts.state)
	
	if_set(arg_9_0.vars.wnd, "txt_title", var_9_0)
	if_set(arg_9_0.vars.wnd, "txt_disc", var_9_1)
end

function ClanWarClose.show(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0
	
	if arg_10_2.state == "member_count" then
		var_10_0 = load_dlg("clan_war_Inability", true, "wnd")
	else
		if arg_10_2.state == nil then
			Log.e("opts.state was nil.")
			SceneManager:popScene()
			
			return 
		end
		
		var_10_0 = load_dlg("clan_war_calculate", true, "wnd")
	end
	
	arg_10_0.vars = {}
	arg_10_0.vars.opts = arg_10_2
	arg_10_0.vars.wnd = var_10_0
	arg_10_0.vars.base_layer = arg_10_1
	arg_10_0.vars.local_defense_data = table.clone(ClanWar:getDefenseAbleMemberList() or {})
	
	TopBarNew:create(T("guild_arena"), arg_10_0.vars.wnd, function()
		ClanWarClose:onPushBackButton()
	end, nil, nil, "infoclaw")
	arg_10_0:setupUI()
	arg_10_1:addChild(var_10_0)
end

function ClanWarClose.updateTeamData(arg_12_0, arg_12_1, arg_12_2)
	if (function(arg_13_0)
		return table.count(arg_13_0.team1) > 0 and table.count(arg_13_0.team2) > 0
	end)(arg_12_2) then
		if not arg_12_0.vars.local_defense_data[tostring(arg_12_1)] then
			arg_12_0.vars.local_defense_data[tostring(arg_12_1)] = {}
		end
		
		arg_12_0.vars.local_defense_data[tostring(arg_12_1)].team1_units = arg_12_2.team1
		arg_12_0.vars.local_defense_data[tostring(arg_12_1)].team2_units = arg_12_2.team2
		
		local var_12_0 = DBT("clan_war", ClanWar:getWarID(), {
			"season_name",
			"need_defense_count"
		})
		
		arg_12_0:settingInabilityUI(var_12_0)
	end
end

function ClanWarClose.getSceneState(arg_14_0)
	local var_14_0 = {}
	
	if arg_14_0.vars then
		var_14_0 = arg_14_0.vars.opts
	end
	
	return var_14_0
end
