ClanWarMain = {}
ClanWarNotiPopup = {}

local var_0_0 = 380

function MsgHandler.clan_war_edit_notice(arg_1_0)
	Clan:updateInfo(arg_1_0)
	ClanWarMain:updateWarNotice()
	ClanWarNotiPopup:closeWarNoticePopup()
	balloon_message_with_sound("clanwar_notice_popup_noti2")
end

function ErrHandler.clan_war_edit_notice(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_1 then
		return 
	end
	
	balloon_message_with_sound("clan_war_edit_notice." .. arg_2_1)
end

function HANDLER.clan_war_map(arg_3_0, arg_3_1)
	if ClanWarTeam:isShow() then
		return 
	end
	
	if arg_3_1 == "btn_bg" then
		ClanWarMain:zoomOut()
	end
	
	if string.starts(arg_3_1, "btn_e_") or string.starts(arg_3_1, "btn_f_") then
		ClanWarMain:focusIn(arg_3_0.tower_id, string.sub(arg_3_1, 5, -1))
	end
end

function HANDLER.clan_war_main(arg_4_0, arg_4_1)
	if ClanWarTeam:isShow() then
		return 
	end
	
	if arg_4_1 == "btn_clan_info" then
		if get_cocos_refid(arg_4_0) and arg_4_0.clan_id then
			Clan:queryPreview(arg_4_0.clan_id, "preview")
		end
		
		return 
	end
	
	if arg_4_1 == "btn_team_edit" then
		ClanWarTeam:show({
			mode = "clan_pvp_defence",
			parent = SceneManager:getRunningNativeScene(),
			completeCB = function(arg_5_0, arg_5_1)
				ClanWarMain:updateTeamData(arg_5_0, arg_5_1)
			end
		})
		
		return 
	end
	
	if arg_4_1 == "btn_member_status" then
		ClanWarStatusMain:open()
		
		return 
	end
	
	if arg_4_1 == "btn_ranking" then
		ClanWarResultDetail:open()
		
		return 
	end
	
	if arg_4_1 == "btn_noti" then
		ClanWarNotiPopup:openWarNoticePopup()
		
		return 
	end
	
	if arg_4_1 == "btn_update_my_building" then
		ClanWarMain:onUpdateMyBuildingBtn(arg_4_0)
		
		return 
	end
end

function HANDLER.clan_war_noti_popup(arg_6_0, arg_6_1)
	if LotaNotiPopupUI:isActive() then
		LotaNotiPopupUI:handler(arg_6_0, arg_6_1)
		
		return 
	end
	
	if arg_6_1 == "btn_cancel" then
		ClanWarNotiPopup:closeWarNoticePopup()
	elseif arg_6_1 == "btn_yes" then
		ClanWarNotiPopup:saveWarNotice()
	elseif arg_6_1 == "btn_close" then
		ClanWarNotiPopup:closeWarNoticePopup()
	end
end

function ClanWarMain.show(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg("clan_war_main", true, "wnd")
	arg_7_0.vars.wnd_bg = load_dlg("clan_war_map", true, "wnd")
	
	arg_7_0.vars.wnd_bg:setPosition(0, 0)
	arg_7_0.vars.wnd.c.n_bg:addChild(arg_7_0.vars.wnd_bg)
	
	local var_7_0 = cc.Sprite:create("worldmap/clanwardepth01.png")
	
	arg_7_0.vars.wnd_bg.c.n_bg:addChild(var_7_0)
	
	arg_7_0.vars.prepare_mode = ClanWar:getMode() == CLAN_WAR_MODE.READY
	arg_7_0.vars.ally_fortress = {}
	arg_7_0.vars.enemy_fortress = {}
	
	arg_7_1:addChild(arg_7_0.vars.wnd)
	arg_7_0.vars.wnd.c.n_ui_layer:setVisible(false)
	arg_7_0:loadDB()
	arg_7_0:setup()
	arg_7_0:updateUI()
	arg_7_0:initAdditionalInfos()
	arg_7_0:setLocalDefenseAbleMembers(table.clone(ClanWar:getDefenseAbleMemberList() or {}))
	ClanWar:clearData()
	TopBarNew:create(T("clan_war"), arg_7_0.vars.wnd, function()
		ClanWarMain:onPushBackButton()
	end, nil, nil, "infoclaw")
	TopBarNew:setCurrencies({
		"clanpvpkey"
	})
	
	if ClanWar:getMode() == CLAN_WAR_MODE.READY and Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_war_defence_edit") then
		TutorialGuide:startGuide("clanwar_master")
	end
	
	Analytics:setMode("clan_war_map")
	
	return arg_7_0.vars.wnd
end

function ClanWarMain.setup(arg_9_0)
	arg_9_0.vars.bg_nodes = {}
	
	for iter_9_0, iter_9_1 in pairs({
		"f",
		"e"
	}) do
		for iter_9_2 = 1, 4 do
			arg_9_0.vars.wnd.c["btn_" .. iter_9_1 .. "_" .. iter_9_2].tower_id = "tower" .. iter_9_2
			arg_9_0.vars.bg_nodes[iter_9_1 .. iter_9_2] = arg_9_0.vars.wnd.c["n_base_img_" .. iter_9_1 .. "_" .. iter_9_2]
		end
	end
	
	local var_9_0 = arg_9_0.vars.wnd_bg:getChildByName("n_my_base")
	local var_9_1 = arg_9_0.vars.wnd_bg:getChildByName("n_peer_base")
	
	if not var_9_0 or not var_9_1 then
		return 
	end
	
	arg_9_0.vars.ally_fortress = arg_9_0:setupBuildingLabel(var_9_0, false)
	arg_9_0.vars.enemy_fortress = arg_9_0:setupBuildingLabel(var_9_1, true)
	
	arg_9_0:updateEmtpyEquipSlotUI()
end

function ClanWarMain.setupBuildingLabel(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_1 then
		return 
	end
	
	local var_10_0 = {}
	
	for iter_10_0 = 1, 4 do
		local var_10_1 = (arg_10_2 and "n_base_e_" or "n_base_f_") .. tostring(iter_10_0)
		local var_10_2 = arg_10_1:getChildByName(var_10_1)
		local var_10_3 = load_control("wnd/clan_war_name.csb")
		
		var_10_3:setAnchorPoint(0.5, 0.5)
		
		if var_10_2 then
			var_10_0["tower" .. tostring(iter_10_0)] = var_10_3
			
			var_10_2:addChild(var_10_3)
		end
	end
	
	return var_10_0
end

function ClanWarMain.updateEmtpyEquipSlotUI(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.wnd_bg) then
		return 
	end
	
	if Account:getCurrentWarUId() < 12 then
		return 
	end
	
	ClanWarMain:updateEmptyEquipBalloon()
	arg_11_0:updateBuildingRefreshButton()
end

function ClanWarMain.updateEmptyEquipBalloon(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.wnd_bg) then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.wnd_bg:getChildByName("n_my_base")
	local var_12_1 = ClanWar:getMode()
	
	for iter_12_0 = 1, 4 do
		local var_12_2 = "n_base_f_" .. tostring(iter_12_0)
		local var_12_3 = var_12_0:getChildByName(var_12_2)
		
		if var_12_3 then
			local var_12_4 = "tower" .. tostring(iter_12_0)
			local var_12_5 = ClanWarMain:getCountEmptyEquipUser(var_12_4)
			local var_12_6 = var_12_3:getChildByName("balloon_" .. tostring(iter_12_0))
			
			if get_cocos_refid(var_12_6) then
				local var_12_7 = var_12_5 > 0 and var_12_1 == CLAN_WAR_MODE.READY
				
				var_12_6:setVisible(var_12_7)
				
				if var_12_7 then
					if_set(var_12_6, "t_number_" .. tostring(iter_12_0), var_12_5)
				end
			end
		end
	end
end

function ClanWarMain.updateBuildingRefreshButton(arg_13_0)
	local var_13_0 = ClanWar:getMode() == CLAN_WAR_MODE.READY
	local var_13_1 = Account:getCurrentWarUId()
	local var_13_2 = ClanWar:isBuildingMember(AccountData.id)
	
	if_set_visible(arg_13_0.vars.wnd, "btn_update_my_building", var_13_1 >= 12 and var_13_2 and var_13_0)
end

function ClanWarMain.setLocalDefenseAbleMembers(arg_14_0, arg_14_1)
	arg_14_0.vars.localDefenseAbleMembers = arg_14_1
end

function ClanWarMain.getLocalDefenseAbleMembers(arg_15_0)
	return arg_15_0.vars.localDefenseAbleMembers or {}
end

function ClanWarMain.getTotalScore(arg_16_0, arg_16_1)
	local var_16_0 = 0
	local var_16_1 = ClanWar:getAttackerInfos(arg_16_1)
	
	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		var_16_0 = var_16_0 + (iter_16_1.destroy_score or 0)
	end
	
	return var_16_0
end

function ClanWarMain.isEmptySlot(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_3 = arg_17_3 or {}
	
	local var_17_0 = (arg_17_3.infos or ClanWar:getBuildingMembers(arg_17_2) or {})[tostring(arg_17_1)] or {}
	
	return not var_17_0 or not var_17_0.user_info and not var_17_0.defense_user_info
end

local function var_0_1(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(ClanWarMain.vars.object_sub_db) do
		for iter_18_2, iter_18_3 in pairs(ClanWarMain.vars.object_sub_db[iter_18_0]) do
			if (iter_18_3.slot or -1) == arg_18_0 then
				return iter_18_0
			end
		end
	end
	
	return ""
end

local function var_0_2(arg_19_0, arg_19_1)
	local var_19_0 = var_0_1(arg_19_1)
	
	if type(arg_19_0) ~= "table" then
		return arg_19_0 == var_19_0
	else
		for iter_19_0, iter_19_1 in pairs(arg_19_0) do
			if iter_19_1 == var_19_0 then
				return true
			end
		end
		
		return false
	end
end

local function var_0_3(arg_20_0, arg_20_1)
	local var_20_0 = 0
	local var_20_1 = 0
	local var_20_2 = ClanWar:getBuildingMembers(arg_20_1) or {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_2) do
		if iter_20_1.defense_user_info and var_0_2(arg_20_0, iter_20_1.slot) then
			local var_20_3, var_20_4 = ClanWarMain:getTowerHP(iter_20_1.slot, arg_20_1)
			
			var_20_0 = var_20_0 + var_20_3
			var_20_1 = var_20_1 + var_20_4
		end
	end
	
	return var_20_0, var_20_1
end

local function var_0_4(arg_21_0, arg_21_1)
	local var_21_0 = 0
	local var_21_1 = 0
	local var_21_2 = ClanWar:getBuildingMembers(arg_21_1) or {}
	
	for iter_21_0, iter_21_1 in pairs(var_21_2) do
		if iter_21_1.defense_user_info and var_0_2(arg_21_0, iter_21_1.slot) then
			var_21_1 = var_21_1 + 1
			
			if ClanWarMain:getTowerHP(iter_21_1.slot, arg_21_1) > 0 then
				var_21_0 = var_21_0 + 1
			end
		end
	end
	
	return var_21_0, var_21_1
end

local function var_0_5(arg_22_0)
	local var_22_0 = 0
	local var_22_1 = ClanWarMain:getSubDB()
	local var_22_2 = table.count(var_22_1[tostring(arg_22_0)] or {})
	local var_22_3 = ClanWar:getBuildingMembers() or {}
	
	for iter_22_0, iter_22_1 in pairs(var_22_3) do
		if iter_22_1.defense_user_info and var_0_2(arg_22_0, iter_22_1.slot) then
			var_22_0 = var_22_0 + 1
		end
	end
	
	return var_22_0, var_22_2
end

local function var_0_6(arg_23_0, arg_23_1)
	local var_23_0 = 0
	local var_23_1 = ClanWarMain:getSubDB()
	
	for iter_23_0, iter_23_1 in pairs(var_23_1[arg_23_0]) do
		if #ClanWar:getSubTowerAttackers(iter_23_1.slot, arg_23_1) > 0 then
			var_23_0 = var_23_0 + 1
		end
	end
	
	return {
		count = var_23_0
	}
end

local function var_0_7(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = ClanWarMain:getMainDB()[arg_24_0]
	
	if var_24_0 then
		if arg_24_2 then
			if arg_24_1 > 0.5 then
				return var_24_0.e_default_icon, nil
			elseif arg_24_1 > 0 then
				return var_24_0.e_hp50_icon, var_24_0.e_hp50_effect
			else
				return var_24_0.e_hp0_icon, var_24_0.e_hp0_effect
			end
		elseif arg_24_1 > 0.5 then
			return var_24_0.f_default_icon, nil
		elseif arg_24_1 > 0 then
			return var_24_0.f_hp50_icon, var_24_0.f_hp50_effect
		else
			return var_24_0.f_hp0_icon, var_24_0.f_hp0_effect
		end
	end
	
	return nil, nil
end

local function var_0_8(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_1 then
		if_set(arg_25_0, "clan_name", arg_25_1.name)
		UIUtil:updateClanEmblem(arg_25_0, arg_25_1)
		UIUtil:warpping_setLevel(arg_25_0:getChildByName("n_lv"), arg_25_1.level, CLAN_MAX_LEVEL, 2, {
			is_clan_level = true
		})
		
		local var_25_0 = arg_25_0:getChildByName("btn_clan_info")
		
		if get_cocos_refid(var_25_0) then
			var_25_0.clan_id = arg_25_1.clan_id
		end
	end
	
	local var_25_1 = arg_25_0:getChildByName("progress_bar")
	local var_25_2 = arg_25_0:getChildByName("t_percent")
	local var_25_3 = arg_25_0:getChildByName("clan_score")
	
	if not var_25_1 or not var_25_2 or not var_25_3 then
		return 
	end
	
	if not arg_25_2 then
		local var_25_4, var_25_5 = var_0_4({
			"tower1",
			"tower2",
			"tower3",
			"tower4"
		}, arg_25_3)
		
		var_25_3:setString(T("war_ui_0030", {
			value = ClanWarMain:getTotalScore(arg_25_3)
		}))
		var_25_2:setString(string.format("%d/%d", var_25_4, var_25_5))
		
		if var_25_5 == 0 then
			var_25_5 = 1
		end
		
		var_25_1:setPercent(math.clamp(var_25_4 * 100 / var_25_5, 0, 100))
	else
		if_set_visible(arg_25_0, "progress_bg", false)
	end
	
	var_25_1:setVisible(not arg_25_2)
	var_25_2:setVisible(not arg_25_2)
	var_25_3:setVisible(not arg_25_2)
end

function ClanWarMain.updateUILeft(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.vars.wnd:getChildByName("n_main_left")
	local var_26_1 = arg_26_0.vars.wnd:getChildByName("n_main_bottom")
	local var_26_2 = var_26_0:getChildByName("n_my")
	
	var_0_8(var_26_2, arg_26_1, arg_26_0.vars.prepare_mode, false)
	
	local var_26_3 = var_26_0:getChildByName("n_enemy")
	
	if_set_visible(var_26_0, "n_preparing", arg_26_0.vars.prepare_mode)
	if_set_visible(var_26_3, nil, not arg_26_0.vars.prepare_mode)
	if_set_visible(var_26_1, "btn_defence_team", arg_26_0.vars.prepare_mode)
	if_set_visible(var_26_1, "btn_status", not arg_26_0.vars.prepare_mode)
	if_set_visible(var_26_1, "btn_team_edit", arg_26_0.vars.prepare_mode)
	var_0_8(var_26_3, ClanWar:getEnemyClanInfo(), arg_26_0.vars.prepare_mode, true)
	
	local var_26_4 = var_26_0:getChildByName("n_time")
	
	if arg_26_0.vars.prepare_mode then
		if_set(var_26_4, "txt_until", T("war_state_play"))
	else
		if_set(var_26_4, "txt_until", T("war_state_end"))
	end
	
	if_set(var_26_4, "txt_time", T("war_time_h", {
		hour = math.floor(ClanWar:getRemainTime() / 3600)
	}))
	
	local var_26_5, var_26_6 = DB("clan_war", ClanWar:getWarID(), {
		"season_type",
		"season_name"
	})
	
	if var_26_5 == "free" then
		if_set(var_26_0, "txt_season", T(var_26_6))
	else
		if_set(var_26_0, "txt_season", T("war_ui_0096", {
			name = T(var_26_6)
		}))
	end
	
	arg_26_0:updateTokenInfos()
	arg_26_0:updateIsInMatchUI()
end

function ClanWarMain.updateIsInMatchUI(arg_27_0)
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_main_left"):getChildByName("n_preparing")
	
	if ClanWar:getIsInMatchList() then
		if_set(var_27_0, "t_disc", T("war_ui_desc11"))
		
		return 
	end
	
	if_set(var_27_0, "t_disc", T("clanwar_matching_err_msg"))
end

function ClanWarMain.initAdditionalInfos(arg_28_0)
	if arg_28_0.vars.prepare_mode then
		if_set_visible(arg_28_0.vars.wnd, "btn_refresh", false)
	else
		if_set_visible(arg_28_0.vars.wnd, "btn_refresh", true)
		
		local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_notice")
		local var_28_1 = arg_28_0.vars.wnd:getChildByName("n_notice_move")
		
		var_28_0:setPosition(var_28_1:getPosition())
	end
	
	arg_28_0:updateWarNotice(Clan:getClanInfo())
end

function ClanWarMain.isInDefenseTeam(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_1 then
		return false
	end
	
	local var_29_0 = ClanWar:getBuildingMembers(arg_29_2)
	
	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		if iter_29_1.defense_user_id and tostring(arg_29_1) == tostring(iter_29_1.defense_user_id) then
			return true
		end
	end
	
	return false
end

function ClanWarMain.updateTokenInfos(arg_30_0)
	if arg_30_0.vars.prepare_mode then
		if_set_visible(arg_30_0.vars.wnd:getChildByName("n_my"), "n_token", false)
		
		return 
	end
	
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("n_my")
	local var_30_1 = arg_30_0.vars.wnd:getChildByName("n_enemy")
	local var_30_2 = (ClanWar:getWarInfo() or {}).war_day_id or 0
	local var_30_3 = 0
	local var_30_4 = 0
	local var_30_5 = ClanWar:getBuildingMembers(false)
	
	for iter_30_0, iter_30_1 in pairs(var_30_5) do
		if not ClanWarMain:isEmptySlot(iter_30_1.slot, false) then
			var_30_4 = var_30_4 + 1
		end
	end
	
	local var_30_6 = var_30_4 * 3
	
	for iter_30_2, iter_30_3 in pairs(ClanWar:getAttackerInfos(false)) do
		if arg_30_0:isInDefenseTeam(iter_30_2, false) then
			local var_30_7 = iter_30_3.today_attack_count
			
			if var_30_2 ~= iter_30_3.war_day_id then
				var_30_7 = 0
			end
			
			var_30_3 = var_30_3 + var_30_7
		end
	end
	
	if_set(var_30_0:getChildByName("n_token"), "t_count", var_30_6 - var_30_3 .. "/" .. var_30_6)
	
	local var_30_8 = 0
	local var_30_9 = 0
	local var_30_10 = ClanWar:getBuildingMembers(true)
	
	for iter_30_4, iter_30_5 in pairs(var_30_10) do
		if not ClanWarMain:isEmptySlot(iter_30_5.slot, true) then
			var_30_9 = var_30_9 + 1
		end
	end
	
	local var_30_11 = var_30_9 * 3
	
	for iter_30_6, iter_30_7 in pairs(ClanWar:getAttackerInfos(true)) do
		if arg_30_0:isInDefenseTeam(iter_30_6, true) then
			local var_30_12 = iter_30_7.today_attack_count
			
			if var_30_2 ~= iter_30_7.war_day_id then
				var_30_12 = 0
			end
			
			var_30_8 = var_30_8 + var_30_12
		end
	end
	
	if_set(var_30_1:getChildByName("n_token"), "t_count", var_30_11 - var_30_8 .. "/" .. var_30_11)
end

function ClanWarMain.updateWarNotice(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	if not (arg_31_1 or Clan:getClanInfo()) then
		return 
	end
	
	local var_31_0 = Clan:getWarNoticeOnlyText()
	local var_31_1 = arg_31_0.vars.wnd:getChildByName("txt_select_talk")
	
	UIUtil:updateTextWrapMode(var_31_1, var_31_0, 20)
	set_ellipsis_label2(var_31_1, var_31_0, 2)
	
	local var_31_2 = Clan:getClanWarNotice()
	local var_31_3 = "@^ye%"
	local var_31_4 = string.split(var_31_2, var_31_3)[2]
	local var_31_5 = Clan:getMemberInfoById(var_31_4)
	local var_31_6 = Clan:getClanMaster().user_info
	
	if var_31_4 and not var_31_5 then
		local var_31_7 = {}
		
		var_31_6 = {}
	elseif not var_31_4 then
	else
		local var_31_8 = var_31_5
		
		var_31_6 = var_31_5.user_info
	end
	
	local var_31_9 = CLAN_GRADE.master
	
	if var_31_5 and var_31_5.grade then
		var_31_9 = var_31_5.grade
	end
	
	if var_31_9 == CLAN_GRADE.master then
		if_set_color(arg_31_0.vars.wnd, "icon_leader", cc.c3b(255, 255, 255))
	else
		if_set_color(arg_31_0.vars.wnd, "icon_leader", tocolor("#2A78C3"))
	end
	
	if_set(arg_31_0.vars.wnd:getChildByName("n_noti_small"), "txt_name", var_31_6.name or T("ui_clan_home_notice_unknown_member"))
	
	local var_31_10 = var_31_6.leader_code or "m0000"
	
	UIUtil:getRewardIcon(nil, var_31_10, {
		no_popup = true,
		character_type = "character",
		scale = 1,
		no_grade = true,
		parent = arg_31_0.vars.wnd:getChildByName("mob_icon"),
		border_code = var_31_6.border_code
	})
end

function ClanWarMain.updateUIRight(arg_32_0)
	local var_32_0 = arg_32_0.vars.wnd:getChildByName("n_main_right")
	
	if arg_32_0.vars.prepare_mode then
		local var_32_1 = arg_32_0:getDefendingMemberNums()
		local var_32_2 = Clan:getClanInfo().member_count
		
		if_set(var_32_0, "txt_count_mem", T("war_ui_0000", {
			curr = var_32_1,
			max = var_32_2
		}))
		if_set_percent(var_32_0, "progress_bar", var_32_1 / var_32_2)
	end
end

function ClanWarMain.updateClanWarMap(arg_33_0, arg_33_1)
	local function var_33_0(arg_34_0, arg_34_1, arg_34_2)
		local var_34_0 = tonumber(string.sub(arg_34_0, -1, -1))
		local var_34_1 = arg_34_2 and "e" or "f"
		local var_34_2 = arg_33_0.vars.bg_nodes[var_34_1 .. var_34_0]
		
		if not var_34_2 then
			return 
		end
		
		local var_34_3, var_34_4 = var_0_7(arg_34_0, arg_34_1, arg_34_2)
		local var_34_5 = SpriteCache:getSprite("map/" .. tostring(var_34_3))
		
		var_34_2:removeChildByName("townBG")
		
		if var_34_5 then
			var_34_5:setName("townBG")
			var_34_5:setPosition(0, 0)
			var_34_5:setAnchorPoint(0.5, 0.5)
			var_34_2:addChild(var_34_5)
		end
		
		var_34_2:removeChildByName("townEffect")
		
		if var_34_4 then
			local var_34_6 = CACHE:getEffect(var_34_4)
			
			var_34_6:setName("townEffect")
			var_34_6:setPosition(0, 0)
			var_34_6:setLocalZOrder(99998)
			var_34_2:addChild(var_34_6)
			var_34_6:setVisible(true)
			var_34_6:start()
		end
	end
	
	local function var_33_1(arg_35_0)
		local var_35_0 = arg_35_0 and arg_33_0.vars.enemy_fortress or arg_33_0.vars.ally_fortress
		local var_35_1 = arg_35_0 and {
			8,
			5,
			6,
			7
		} or {
			1,
			2,
			3,
			4
		}
		
		for iter_35_0, iter_35_1 in pairs(var_35_0) do
			local var_35_2 = tonumber(string.sub(iter_35_0, -1, -1))
			local var_35_3
			local var_35_4
			
			if arg_33_0.vars.prepare_mode then
				var_35_3, var_35_4 = var_0_5(iter_35_0)
			else
				var_35_3, var_35_4 = var_0_4({
					iter_35_0
				}, arg_35_0)
			end
			
			if_set_visible(iter_35_1, "n_label_general", iter_35_0 ~= "tower1")
			if_set_visible(iter_35_1, "n_label_nexus", iter_35_0 == "tower1")
			if_set_visible(iter_35_1, "n_hp", not arg_33_0.vars.prepare_mode and var_35_4 ~= 0)
			if_set(iter_35_1, "t_count", string.format("%d/%d", var_35_3, var_35_4))
			
			local var_35_5 = T("clan_pvpp_tower" .. tostring(var_35_1[var_35_2]))
			
			if iter_35_0 ~= "tower1" then
				if_set_visible(iter_35_1, "n_nexus_info", false)
				if_set(iter_35_1, "label_name", var_35_5)
				if_set_visible(iter_35_1, "label_name", not arg_35_0)
				if_set_visible(iter_35_1, "label_bg", not arg_35_0)
				if_set(iter_35_1, "label_name_enemy", var_35_5)
				if_set_visible(iter_35_1, "label_name_enemy", arg_35_0)
				if_set_visible(iter_35_1, "label_bg_enemy", arg_35_0)
				UIUserData:proc(iter_35_1:getChildByName(arg_35_0 and "label_bg_enemy" or "label_bg"))
			else
				if_set_visible(iter_35_1, "n_nexus_info", not arg_35_0 and arg_33_0:isEmptySlot("1"))
				
				local var_35_6 = iter_35_1:getChildByName("label_name_nexus")
				
				if get_cocos_refid(var_35_6) then
					var_35_6.origin_width = var_35_6.origin_width or var_35_6:getContentSize().width
					
					if var_35_6.origin_width == var_35_6:getContentSize().width then
						if_set(var_35_6, nil, var_35_5)
					end
				end
			end
			
			local var_35_7 = iter_35_1:getChildByName("hp")
			local var_35_8 = 1
			
			if arg_33_0.vars.prepare_mode then
				var_35_7:setScaleX(var_35_8)
			else
				local var_35_9, var_35_10 = var_0_3({
					iter_35_0
				}, arg_35_0)
				
				if var_35_10 ~= 0 then
					var_35_8 = var_35_9 / var_35_10
				end
				
				var_35_7:setScaleX(math.clamp(var_35_8, 0, 1))
			end
			
			var_33_0(iter_35_0, var_35_8, arg_35_0)
			
			local var_35_11 = var_0_6(iter_35_0, arg_35_0)
			local var_35_12 = iter_35_1:getChildByName("n_ing")
			
			var_35_12:setVisible(not arg_33_0.vars.prepare_mode and var_35_11.count > 0)
			var_35_12:getChildByName("t_count"):setString(tostring(var_35_11.count))
		end
	end
	
	var_33_1(true)
	var_33_1(false)
end

function ClanWarMain.updateUI(arg_36_0)
	local var_36_0 = Clan:getClanInfo()
	local var_36_1 = ClanWar:getWarInfo()
	local var_36_2 = ClanWar:getEnemyClanInfo()
	
	if_set_visible(arg_36_0.vars.wnd, "n_main_right", arg_36_0.vars.prepare_mode)
	if_set_visible(arg_36_0.vars.wnd_bg, "n_peer_base", not arg_36_0.vars.prepare_mode)
	arg_36_0:updateUILeft(var_36_0)
	arg_36_0:updateUIRight()
	arg_36_0:updateClanWarMap()
end

function ClanWarMain.refresh(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_37_0.vars.wnd_bg) then
		return 
	end
	
	arg_37_0:updateUI()
	
	if ClanWarMain:getSelectedTowerID() then
		ClanWarDetail:refresh()
	end
end

function ClanWarMain.updateTeamData(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_38_0.vars.wnd_bg) then
		return 
	end
	
	local var_38_0 = arg_38_0.vars.localDefenseAbleMembers[tostring(arg_38_1)]
	
	if var_38_0 then
		var_38_0.team1_units = arg_38_2.team1
		var_38_0.team1_point = arg_38_2.team1_point
		var_38_0.team2_units = arg_38_2.team2
		var_38_0.team2_point = arg_38_2.team2_point
	end
end

function ClanWarMain.makeLocalTeamData(arg_39_0)
	local var_39_0 = {}
	
	local function var_39_1(arg_40_0)
		local var_40_0 = {}
		
		for iter_40_0, iter_40_1 in pairs(AccountData.teams[arg_40_0]) do
			local var_40_1 = iter_40_0
			local var_40_2 = {}
			local var_40_3 = AccountData.teams[arg_40_0][var_40_1]
			local var_40_4 = var_40_3.inst.code
			local var_40_5 = var_40_3:getUID()
			local var_40_6 = var_40_3:getEXP()
			local var_40_7 = var_40_3:getZodiacGrade()
			local var_40_8 = var_40_3:getGrade()
			local var_40_9 = {
				code = var_40_4,
				exp = var_40_6,
				id = var_40_5,
				z = var_40_7,
				g = var_40_8
			}
			
			table.insert(var_40_0, {
				pos = var_40_1,
				unit = var_40_9,
				equips = var_40_2
			})
		end
		
		return var_40_0
	end
	
	var_39_0.team1 = var_39_1(CLAN_TEAM_DEF_F)
	var_39_0.team1_point = TeamUtil:getTeamPoint(CLAN_TEAM_DEF_F, nil, {
		no_summon = true
	})
	var_39_0.team2 = var_39_1(CLAN_TEAM_DEF_B)
	var_39_0.team2_point = TeamUtil:getTeamPoint(CLAN_TEAM_DEF_B, nil, {
		no_summon = true
	})
	
	return var_39_0
end

function ClanWarMain.focusOut(arg_41_0)
	eff_slide_in(arg_41_0.vars.wnd, "n_main_left", 300, 0, false, 300)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(250, 0, 0)), CALL(function()
		arg_41_0:refresh()
	end), DELAY(200)), arg_41_0.vars.wnd.c.n_main_bottom, "block")
	
	if arg_41_0.vars.prepare_mode then
		UIAction:Add(FADE_IN(200), arg_41_0.vars.wnd.c.n_main_right.c.n_preparing, "block")
	end
	
	arg_41_0:zoomOut()
	
	arg_41_0.vars.fortress = nil
	arg_41_0.vars.selected_tower_id = nil
	
	arg_41_0:updateEmtpyEquipSlotUI()
end

function ClanWarMain.focusIn(arg_43_0, arg_43_1, arg_43_2)
	if arg_43_0.vars.prepare_mode and string.starts(arg_43_2, "e") then
		return 
	end
	
	EffectManager:Play({
		fn = "stagechange_cloud.cfx",
		delay = 160,
		pivot_z = 99998,
		layer = arg_43_0.vars.wnd_bg.c.n_cloud,
		pivot_x = VIEW_WIDTH / 2 + 90,
		pivot_y = VIEW_HEIGHT / 2
	})
	
	if arg_43_0.vars.prepare_mode then
		UIAction:Add(FADE_OUT(200), arg_43_0.vars.wnd.c.n_main_right.c.n_preparing, "block")
	end
	
	arg_43_0.vars.fortress = arg_43_2
	arg_43_0.vars.selected_tower_id = arg_43_1
	
	ClanWarDetail:show(arg_43_0.vars.wnd.c.n_ui_layer, {
		fortress = arg_43_2,
		is_nexus = arg_43_0:isNexus(arg_43_2)
	})
	eff_slide_out(arg_43_0.vars.wnd, "n_main_left", 300, 0, false, -300)
	UIAction:Add(SEQ(LOG(MOVE_TO(250, 0, -120)), SHOW(false), DELAY(200)), arg_43_0.vars.wnd.c.n_main_bottom, "block")
	arg_43_0:zoomIn(arg_43_2)
	TutorialGuide:procGuide()
end

local function var_0_9(arg_44_0)
	if arg_44_0 then
		return 
	end
	
	ClanWar:query("refresh_clan_war_info", nil, {
		cache_key = ClanWar:getCacheKey()
	})
end

function ClanWarMain.zoomIn(arg_45_0, arg_45_1)
	local var_45_0 = true
	local var_45_1 = 5
	local var_45_2, var_45_3 = arg_45_0.vars.wnd.c["n_base_" .. arg_45_1]:getPosition()
	local var_45_4 = var_45_2 - 30
	
	arg_45_0:resetAnchor(var_45_4, var_45_3)
	arg_45_0.vars.wnd.c.p_main:setPosition(var_45_4, var_45_3)
	UIAction:Add(LOG(SPAWN(SCALE(400, 1, var_45_1), MOVE_TO(400, 640, 360), SEQ(DELAY(400), SHOW(not var_45_0)))), arg_45_0.vars.wnd.c.p_main)
	arg_45_0.vars.wnd.c.n_ui_layer:setOpacity(0)
	UIAction:Add(SEQ(DELAY(150), FADE_IN(250), CALL(var_0_9, arg_45_0.vars.prepare_mode)), arg_45_0.vars.wnd.c.n_ui_layer)
end

function ClanWarMain.resetAnchor(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_1 / 1280
	local var_46_1 = arg_46_2 / 720
	
	arg_46_0.vars.focus_pt = {
		x = arg_46_1,
		y = arg_46_2
	}
	
	arg_46_0.vars.wnd.c.p_main:setAnchorPoint(var_46_0, var_46_1)
end

function ClanWarMain.zoomOut(arg_47_0)
	if not arg_47_0.vars.fortress then
		return 
	end
	
	local var_47_0 = 5
	
	arg_47_0:resetAnchor(arg_47_0.vars.focus_pt.x, arg_47_0.vars.focus_pt.y)
	arg_47_0.vars.wnd.c.p_main:setVisible(true)
	arg_47_0.vars.wnd.c.p_main:setOpacity(255)
	UIAction:Add(LOG(SPAWN(SCALE(400, var_47_0, 1), MOVE_TO(400, arg_47_0.vars.focus_pt.x, arg_47_0.vars.focus_pt.y))), arg_47_0.vars.wnd.c.p_main)
	UIAction:Add(SEQ(FADE_OUT(200), SHOW(false), DELAY(200), CALL(function()
		arg_47_0.vars.wnd.c.n_ui_layer:removeAllChildren()
	end), CALL(var_0_9, arg_47_0.vars.prepare_mode)), arg_47_0.vars.wnd.c.n_ui_layer)
	
	arg_47_0.vars.focus_pt = nil
end

function ClanWarMain.getSelectedTowerID(arg_49_0)
	return arg_49_0.vars.selected_tower_id
end

function ClanWarMain.onPushBackButton(arg_50_0)
	if arg_50_0.vars.fortress then
		ClanWarDetail:onPushBackButton()
		
		return 
	else
		ClanWarReady:resetFilter()
		SceneManager:popScene()
	end
end

function ClanWarMain.isNexus(arg_51_0, arg_51_1)
	return string.ends(arg_51_1, "1")
end

function ClanWarMain.canAttack(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0:getTowerData(arg_52_1) or {}
	local var_52_1 = var_52_0.category
	
	if ClanWar:isObserver() then
		return false, "observer"
	end
	
	if ClanWar:getRemainAttackCountPerEnemy(Account:getUserId(), arg_52_1) <= 0 then
		return false, "same_enemy"
	end
	
	if var_52_0.type == "building" then
		arg_52_0.vars.isBeforeCastle = false
		
		return true
	elseif var_52_0.type == "tower" then
		local var_52_2 = 0
		local var_52_3 = ClanWar:getBuildingMembers(arg_52_2) or {}
		
		for iter_52_0, iter_52_1 in pairs(arg_52_0.vars.object_sub_db[var_52_1] or {}) do
			local var_52_4 = not (var_52_3[tostring(iter_52_1.slot)] or {}).defense_user_info
			local var_52_5 = arg_52_0:getTowerHP(iter_52_1.slot, arg_52_2) <= 0
			local var_52_6 = iter_52_1.slot == arg_52_1
			
			if Account:getCurrentWarUId() >= 4 then
				if var_52_6 and (var_52_4 or var_52_5) then
					return false, "empty or brokne tower"
				end
			elseif not var_52_6 and not var_52_4 and not var_52_5 then
				return false, "remain_building"
			end
		end
		
		arg_52_0.vars.isBeforeCastle = false
		
		return true
	elseif var_52_0.type == "castle" then
		local var_52_7 = 0
		local var_52_8 = ClanWar:getBuildingMembers(arg_52_2) or {}
		
		for iter_52_2, iter_52_3 in pairs(arg_52_0.vars.typeToSlotCategory.tower) do
			local var_52_9 = not (var_52_8[tostring(iter_52_3.slot)] or {}).defense_user_info
			local var_52_10 = arg_52_0:getTowerHP(iter_52_3.slot, arg_52_2) <= 0
			
			if var_52_9 or var_52_10 then
				var_52_7 = var_52_7 + 1
			end
		end
		
		arg_52_0.vars.isBeforeCastle = true
		
		if var_52_7 >= 2 then
			return true
		else
			return false, "remain_tower"
		end
	elseif not arg_52_0.vars.isBeforeCastle then
		Log.e("unknown clan_pvp db dataType")
	end
	
	return false, "unknown"
end

function ClanWarMain.getMainDB(arg_53_0)
	return arg_53_0.vars.object_main_db or {}
end

function ClanWarMain.getSubDB(arg_54_0)
	return arg_54_0.vars.object_sub_db
end

function ClanWarMain.getTowerHP(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = (ClanWar:getBuildingMembers(arg_55_2) or {})[tostring(arg_55_1)] or {}
	local var_55_1 = arg_55_2 and ClanWar:getWarInfo() or ClanWar:getEnemyWarInfo() or {}
	local var_55_2 = arg_55_2 and ClanWar:getEnemyWarInfo() or ClanWar:getWarInfo() or {}
	local var_55_3 = var_55_0.win_count or 0
	local var_55_4 = var_55_0.defeat_count or 0
	local var_55_5 = var_55_0.draw_count or 0
	local var_55_6 = var_55_0.win_semi_count or 0
	local var_55_7 = var_55_0.defeat_semi_count or 0
	local var_55_8 = var_55_2.member_count
	local var_55_9 = var_55_1.member_count
	local var_55_10, var_55_11 = arg_55_0:getHP(tonumber(arg_55_1), var_55_3, var_55_4, var_55_5, var_55_6, var_55_7, var_55_8, var_55_9)
	
	return var_55_10, var_55_11
end

function ClanWarMain.getTowerHPRatio(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0, var_56_1 = arg_56_0:getTowerHP(arg_56_1, arg_56_2)
	
	return var_56_0 / var_56_1
end

function ClanWarMain.isDefendingTower(arg_57_0, arg_57_1, arg_57_2)
	return arg_57_0:getTowerHP(arg_57_1, arg_57_2) > 0
end

function ClanWarMain.getDefendingMemberNums(arg_58_0)
	local var_58_0 = Clan:getMembers()
	local var_58_1 = 0
	
	for iter_58_0, iter_58_1 in pairs(var_58_0) do
		iter_58_1.slot = ClanWar:userIdToSlot(iter_58_1.user_id)
		
		if iter_58_1.slot and arg_58_0:isDefendingTower(iter_58_1.slot) == true then
			var_58_1 = var_58_1 + 1
		end
	end
	
	return var_58_1
end

function ClanWarMain.loadDB(arg_59_0)
	arg_59_0.vars.object_main_db = {}
	arg_59_0.vars.object_sub_db = {}
	arg_59_0.vars.calibrate_db = {}
	arg_59_0.vars.slotToIDCategory = {}
	arg_59_0.vars.typeToSlotCategory = {}
	
	local var_59_0, var_59_1 = DB("clan_war", ClanWar:getWarID(), {
		"clan_war_object",
		"calibrate_id"
	})
	
	for iter_59_0 = 1, 99 do
		local var_59_2, var_59_3, var_59_4, var_59_5, var_59_6, var_59_7, var_59_8, var_59_9, var_59_10, var_59_11, var_59_12, var_59_13, var_59_14 = DBN("clan_war_object_main", iter_59_0, {
			"id",
			"desc",
			"type",
			"f_default_icon",
			"f_hp50_icon",
			"f_hp50_effect",
			"f_hp0_icon",
			"f_hp0_effect",
			"e_default_icon",
			"e_hp50_icon",
			"e_hp50_effect",
			"e_hp0_icon",
			"e_hp0_effect"
		})
		
		if not var_59_2 then
			break
		end
		
		local var_59_15 = {
			id = var_59_2,
			desc = var_59_3,
			type = var_59_4,
			f_default_icon = var_59_5,
			f_hp50_icon = var_59_6,
			f_hp50_effect = var_59_7,
			f_hp0_icon = var_59_8,
			f_hp0_effect = var_59_9,
			e_default_icon = var_59_10,
			e_hp50_icon = var_59_11,
			e_hp50_effect = var_59_12,
			e_hp0_icon = var_59_13,
			e_hp0_effect = var_59_14
		}
		
		arg_59_0.vars.object_main_db[var_59_2] = var_59_15
	end
	
	for iter_59_1 = 1, 999 do
		local var_59_16, var_59_17, var_59_18, var_59_19, var_59_20, var_59_21, var_59_22, var_59_23, var_59_24, var_59_25, var_59_26, var_59_27, var_59_28, var_59_29, var_59_30, var_59_31 = DBN(var_59_0, iter_59_1, {
			"id",
			"slot",
			"type",
			"category",
			"default_icon",
			"hp50_icon",
			"hp50_effect",
			"hp0_icon",
			"hp0_effect",
			"default_hp",
			"destroy_bonus",
			"hp_fall_attack_win",
			"hp_fall_attack_draw",
			"hp_fall_attack_lose",
			"hp_fall_attack_win_semi",
			"hp_fall_attack_lose_semi"
		})
		
		if not var_59_16 then
			break
		end
		
		local var_59_32 = {
			id = var_59_16,
			slot = var_59_17,
			type = var_59_18,
			category = var_59_19,
			default_icon = var_59_20,
			hp50_icon = var_59_21,
			hp50_effect = var_59_22,
			hp0_icon = var_59_23,
			hp0_effect = var_59_24,
			default_hp = var_59_25,
			destroy_bonus = var_59_26,
			hp_fall_attack_win = var_59_27,
			hp_fall_attack_draw = var_59_28,
			hp_fall_attack_lose = var_59_29,
			hp_fall_attack_win_semi = var_59_30,
			hp_fall_attack_lose_semi = var_59_31
		}
		
		if not arg_59_0.vars.object_sub_db[var_59_19] then
			arg_59_0.vars.object_sub_db[var_59_19] = {}
		end
		
		arg_59_0.vars.object_sub_db[var_59_19][var_59_16] = var_59_32
		
		if not arg_59_0.vars.typeToSlotCategory[var_59_18] then
			arg_59_0.vars.typeToSlotCategory[var_59_18] = {}
		end
		
		arg_59_0.vars.typeToSlotCategory[var_59_18][var_59_16] = {
			category = var_59_19,
			slot = var_59_17
		}
		arg_59_0.vars.slotToIDCategory[tostring(var_59_17)] = {
			id = var_59_16,
			category = var_59_19
		}
	end
	
	for iter_59_2 = 1, 99 do
		local var_59_33, var_59_34, var_59_35, var_59_36, var_59_37, var_59_38, var_59_39, var_59_40 = DBN(var_59_1, iter_59_2, {
			"id",
			"difference_value",
			"calibrate_hp_castle",
			"calibrate_hp_tower",
			"calibrate_hp_building",
			"calibrate_damage_attacker_win",
			"calibrate_damage_attacker_draw",
			"calibrate_damage_attacker_lose"
		})
		
		if not var_59_33 then
			break
		end
		
		arg_59_0.vars.calibrate_db[tonumber(var_59_34)] = {
			calibrate_hp_castle = var_59_35,
			calibrate_hp_tower = var_59_36,
			calibrate_hp_building = var_59_37,
			calibrate_damage_attacker_win = var_59_38,
			calibrate_damage_attacker_draw = var_59_39,
			calibrate_damage_attacker_lose = var_59_40
		}
	end
end

function ClanWarMain.getCountEmptyEquipUser(arg_60_0, arg_60_1)
	local var_60_0 = ClanWar:getClanId()
	local var_60_1 = ClanWar:getBuildingMembers()
	local var_60_2 = 0
	
	for iter_60_0, iter_60_1 in pairs(arg_60_0.vars.object_sub_db[arg_60_1]) do
		local var_60_3 = var_60_1[tostring(iter_60_1.slot)]
		
		if ClanWar:isEmptyEquipUser(var_60_3) then
			var_60_2 = var_60_2 + 1
		end
	end
	
	return var_60_2
end

function ClanWarMain.getDifferenceBonus(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = math.min(math.abs(arg_61_2), #arg_61_0.vars.calibrate_db)
	
	if arg_61_2 < 0 then
		local var_61_1 = arg_61_0.vars.calibrate_db[var_61_0]["calibrate_hp_" .. arg_61_1]
		
		if not var_61_1 then
			Log.e(" CHECK clan_war_calibrate or VALUES")
			
			return 0
		end
		
		return var_61_1
	else
		local var_61_2 = arg_61_0.vars.calibrate_db[var_61_0]
		local var_61_3 = var_61_2.calibrate_damage_attacker_win
		local var_61_4 = var_61_2.calibrate_damage_attacker_draw
		local var_61_5 = var_61_2.calibrate_damage_attacker_lose
		
		return nil, var_61_3, var_61_4, var_61_5
	end
end

function ClanWarMain.getHP(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5, arg_62_6, arg_62_7, arg_62_8)
	if not arg_62_0.vars then
		Log.e("CLAN_WAR_MODE.WAR was not Set")
		
		return -1, -1
	end
	
	local var_62_0 = arg_62_0:getTowerData(arg_62_1)
	
	if not var_62_0 then
		return -1, -1
	end
	
	if not arg_62_8 or not arg_62_7 or ClanWar:getMode() == CLAN_WAR_MODE.READY then
		return var_62_0.default_hp, var_62_0.default_hp
	end
	
	local var_62_1 = var_62_0.default_hp
	local var_62_2 = var_62_0.hp_fall_attack_win
	local var_62_3 = var_62_0.hp_fall_attack_draw
	local var_62_4 = var_62_0.hp_fall_attack_lose
	local var_62_5 = var_62_0.hp_fall_attack_win_semi
	local var_62_6 = var_62_0.hp_fall_attack_lose_semi
	local var_62_7 = arg_62_7 - arg_62_8
	
	if var_62_7 ~= 0 then
		local var_62_8, var_62_9, var_62_10, var_62_11 = arg_62_0:getDifferenceBonus(var_62_0.type, var_62_7)
		
		if var_62_7 < 0 then
			var_62_1 = var_62_1 + var_62_8
		else
			var_62_2 = var_62_9 + var_62_2
			var_62_3 = var_62_10 + var_62_3
			var_62_4 = var_62_11 + var_62_4
			var_62_5 = var_62_5 + var_62_9
			var_62_6 = var_62_6 + var_62_11
		end
	end
	
	local var_62_12 = var_62_1 - (var_62_2 * arg_62_3 + var_62_4 * arg_62_2 + var_62_3 * arg_62_4 + var_62_5 * arg_62_6 + var_62_6 * arg_62_5)
	
	return math.max(var_62_12, 0), var_62_1
end

function ClanWarMain.getTowerData(arg_63_0, arg_63_1)
	if arg_63_0.vars == nil then
		return 
	end
	
	local var_63_0 = arg_63_0.vars.slotToIDCategory[tostring(arg_63_1)]
	
	if var_63_0 == nil then
		return 
	end
	
	return arg_63_0.vars.object_sub_db[var_63_0.category][var_63_0.id]
end

function ClanWarMain.onUpdateMyBuildingBtn(arg_64_0, arg_64_1)
	Dialog:msgBox(T("clan_war_update_my_building"), {
		yesno = true,
		title = T("clan_war_update_my_building_title"),
		handler = function()
			if (arg_64_1.refresh_time or 0) + 30 < os.time() then
				query("clan_war_building_refresh")
				
				arg_64_1.refresh_time = os.time()
			else
				balloon_message_with_sound("error_try_again")
			end
		end
	})
end

function ClanWarNotiPopup.openWarNoticePopup(arg_66_0)
	arg_66_0.vars = {}
	arg_66_0.vars.wnd = load_dlg("clan_war_noti_popup", true, "wnd", function()
		ClanWarNotiPopup:closeWarNoticePopup()
	end)
	
	local var_66_0 = SceneManager:getRunningPopupScene()
	
	arg_66_0.vars.wnd:setLocalZOrder(999999)
	var_66_0:addChild(arg_66_0.vars.wnd)
	
	arg_66_0.vars.orig_noti = Clan:getWarNoticeOnlyText()
	arg_66_0.vars.n_text = nil
	
	if Clan:isClanWarEditableGrade() then
		if_set(arg_66_0.vars.wnd, "title", T("clanwar_notice_popup_title2"))
		
		arg_66_0.vars.n_text = arg_66_0.vars.wnd:getChildByName("txt_notice")
		
		if_set_visible(arg_66_0.vars.wnd, "n_edit", true)
		if_set_visible(arg_66_0.vars.wnd, "n_view", false)
		arg_66_0.vars.n_text:setMaxLength(var_0_0)
		arg_66_0.vars.n_text:setMaxLengthEnabled(true)
		arg_66_0.vars.n_text:setCursorEnabled(true)
		arg_66_0.vars.n_text:setTextColor(tocolor("#603d2a"))
		
		local var_66_1 = tolua.cast(arg_66_0.vars.n_text:getVirtualRenderer(), "cc.Label")
		
		arg_66_0.vars.n_text:addEventListener(function(arg_68_0, arg_68_1)
			UIUtil:updateTextWrapMode(var_66_1, arg_66_0.vars.n_text:getString())
			
			if arg_68_1 == ccui.TextFiledEventType.insert_text and utf8len(arg_66_0.vars.n_text:getString()) >= var_0_0 then
			end
		end)
	else
		if_set(arg_66_0.vars.wnd, "title", T("clanwar_notice_popup_title1"))
		if_set_visible(arg_66_0.vars.wnd, "n_edit", false)
		if_set_visible(arg_66_0.vars.wnd, "n_view", true)
		if_set_visible(arg_66_0.vars.wnd, "scrollview", false)
		
		arg_66_0.vars.n_text = arg_66_0.vars.wnd:getChildByName("t_noti")
	end
	
	UIUtil:updateTextWrapMode(arg_66_0.vars.n_text, arg_66_0.vars.orig_noti)
	arg_66_0.vars.n_text:setString(arg_66_0.vars.orig_noti)
end

function ClanWarNotiPopup.saveWarNotice(arg_69_0)
	if arg_69_0.vars.n_text:getString() == arg_69_0.vars.orig_noti then
		balloon_message_with_sound("clanwar_notice_popup_error1")
		arg_69_0:closeWarNoticePopup()
		
		return 
	end
	
	local var_69_0 = arg_69_0.vars.n_text:getString()
	local var_69_1 = string.trim(var_69_0)
	
	if check_abuse_filter(var_69_1, ABUSE_FILTER.CHAT) then
		balloon_message_with_sound("invalid_input_word")
		
		return 
	end
	
	if var_69_1 == nil or utf8len(var_69_1) < 5 then
		balloon_message_with_sound("clanwar_notice_popup_error2")
		
		return 
	end
	
	BackButtonManager:pop("clan_war_noti_popup")
	query("clan_war_edit_notice", {
		msg = var_69_1
	})
end

function ClanWarNotiPopup.closeWarNoticePopup(arg_70_0)
	if not arg_70_0.vars or not get_cocos_refid(arg_70_0.vars.wnd) then
		return 
	end
	
	arg_70_0.vars.wnd:removeFromParent()
	
	arg_70_0.vars = nil
	
	BackButtonManager:pop("clan_war_noti_popup")
end
