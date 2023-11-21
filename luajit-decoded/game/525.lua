ClanWarReady = {}

local var_0_0 = 10

function HANDLER.clan_war_ready(arg_1_0, arg_1_1)
	if ClanWarTeam:isShow() then
		return 
	end
	
	if arg_1_1 == "btn_go" then
		ClanWarReady:beginClanPVP()
	end
	
	if arg_1_1 == "btn_member_status" then
		ClanWarStatusMain:open()
	end
	
	if arg_1_1 == "btn_back" then
		ClanWarMain:onPushBackButton()
	end
	
	if arg_1_1 == "btn_loading_more" then
		ClanWarReady:nextPage()
	end
	
	if arg_1_1 == "btn_log" and arg_1_0.index then
		ClanWarReady:openHistoryPopup(arg_1_0.index)
	end
	
	if arg_1_1 == "btn_filter" or arg_1_1 == "btn_toggle" or arg_1_1 == "btn_filter_active" then
		ClanWarReady:toggleFilter()
	end
	
	if string.find(arg_1_1, "btn_sort") then
		ClanWarReady:setFilter(tonumber(string.sub(arg_1_1, -1, -1)))
		ClanWarReady:toggleFilter()
	end
end

function ClanWarReady.beginClanPVP(arg_2_0)
	local function var_2_0(arg_3_0, arg_3_1)
		for iter_3_0, iter_3_1 in pairs(arg_3_1) do
			local var_3_0 = UNIT:create(iter_3_1.unit)
			
			for iter_3_2, iter_3_3 in pairs(iter_3_1.equips) do
				if iter_3_3.p == iter_3_1.unit.id then
					local var_3_1 = EQUIP:createByInfo(iter_3_3)
					
					if var_3_1 then
						var_3_0:addEquip(var_3_1, true)
					end
				end
			end
			
			var_3_0:calc()
			
			arg_3_0[iter_3_1.pos] = var_3_0
		end
	end
	
	local var_2_1 = #ClanWar:getSubTowerAttackers(arg_2_0.vars.tower_info.slot, arg_2_0.vars.is_enemy)
	local var_2_2 = ClanWarMain:getTowerHP(arg_2_0.vars.tower_info.slot, true)
	
	local function var_2_3()
		if var_2_1 >= 3 then
			balloon_message_with_sound("war_ui_0054")
			
			return 
		end
		
		local var_4_0 = {}
		local var_4_1 = {}
		
		var_2_0(var_4_0, arg_2_0.vars.tower_info.defense_info1.units)
		var_2_0(var_4_1, arg_2_0.vars.tower_info.defense_info2.units)
		
		local var_4_2 = {
			clan_pvp_mode = true,
			enemy_info = arg_2_0.vars.tower_info,
			enemy_team1 = var_4_0,
			enemy_team2 = var_4_1
		}
		
		ClanWarTeam:show({
			mode = "clan_pvp_ready",
			parent = SceneManager:getRunningNativeScene(),
			pvp_info = var_4_2
		})
	end
	
	if Account:getCurrency("clanpvpkey") < 1 then
		Dialog:msgBox(T("war_err_msg002", {
			name = UIUtil:getTokenName("to_clanpvpkey")
		}))
		
		return 
	end
	
	local var_2_4, var_2_5 = ClanWarMain:canAttack(arg_2_0.vars.tower_info.slot, arg_2_0.vars.is_enemy)
	
	if not var_2_4 then
		balloon_message_with_sound("war_err_msg004")
		
		return 
	end
	
	local var_2_6
	
	if var_2_2 <= 0 then
		var_2_6 = T("war_ui_0087")
	end
	
	if var_2_6 ~= nil then
		Dialog:msgBox(var_2_6, {
			yesno = true,
			handler = var_2_3
		})
	else
		var_2_3()
	end
end

function ClanWarReady.show(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = "all"
	local var_5_1 = 1
	
	if arg_5_0.vars and arg_5_0.vars.filter then
		var_5_0 = arg_5_0.vars.filter
		var_5_1 = ({
			attack = 2,
			all = 1,
			defense = 3
		})[var_5_0]
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.enter_id = "clan_war_01"
	arg_5_0.vars.is_enemy = arg_5_3
	arg_5_0.vars.items = {
		{
			time = 0
		}
	}
	arg_5_0.vars.page = -1
	arg_5_0.vars.no_more_update = false
	arg_5_0.vars.tower_id = tostring(arg_5_2)
	arg_5_0.vars.filter = var_5_0
	arg_5_0.vars.wnd = load_dlg("clan_war_ready", true, "wnd")
	
	arg_5_0.vars.wnd.c.n_detail_right:setVisible(false)
	arg_5_0.vars.wnd.c.n_focus:setVisible(false)
	arg_5_0.vars.wnd.c.vignetting:setVisible(false)
	arg_5_1:addChild(arg_5_0.vars.wnd)
	eff_slide_in(arg_5_0.vars.wnd, "n_detail_right", 300, 0, false, -600)
	UIAction:Add(SEQ(DELAY(200), FADE_IN(200)), arg_5_0.vars.wnd.c.n_focus)
	UIAction:Add(SEQ(DELAY(200), FADE_IN(200)), arg_5_0.vars.wnd.c.vignetting)
	arg_5_0:updateInfos()
	
	arg_5_0.vars.local_user_id = arg_5_0.vars.defense_user_info.id
	
	arg_5_0:initListView()
	arg_5_0:requestItems(true)
	arg_5_0:updateUI()
	arg_5_0:setFilter(var_5_1)
	arg_5_0:setLeftBackButton(true)
	
	return arg_5_0.vars.wnd
end

function ClanWarReady.updateInfos(arg_6_0)
	arg_6_0.vars.tower_info = ClanWar:getBuildingMembers(arg_6_0.vars.is_enemy)[arg_6_0.vars.tower_id]
	
	if not arg_6_0.vars.tower_info then
		return 
	end
	
	arg_6_0.vars.defense_user_info = arg_6_0.vars.tower_info.defense_user_info
	
	if not arg_6_0.vars.defense_user_info then
		return 
	end
	
	arg_6_0.vars.defense_attacker_info = ClanWar:getAttackerInfos(arg_6_0.vars.is_enemy)[tostring(arg_6_0.vars.defense_user_info.id)]
	
	if arg_6_0.vars.is_enemy then
		arg_6_0.vars.defense_clan_info = ClanWar:getEnemyClanInfo()
		arg_6_0.vars.attack_clan_info = Clan:getClanInfo()
	else
		arg_6_0.vars.defense_clan_info = Clan:getClanInfo()
		arg_6_0.vars.attack_clan_info = ClanWar:getEnemyClanInfo()
	end
end

function ClanWarReady.updateUI(arg_7_0, arg_7_1)
	if not arg_7_0.vars.tower_info or not arg_7_0.vars.defense_user_info then
		return 
	end
	
	arg_7_0:setUIFocus()
	arg_7_0:setUIPlacement()
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("n_record")
	
	if_set_visible(var_7_0, "n_enemy", arg_7_0.vars.is_enemy)
	UIUtil:setButtonEnterInfo(arg_7_0.vars.wnd:getChildByName("btn_go"), "clan_war_01")
end

function ClanWarReady.refresh(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	arg_8_0:updateInfos()
	arg_8_0:updateUI()
	
	if arg_8_0.vars.defense_user_info and arg_8_0.vars.local_user_id ~= arg_8_0.vars.defense_user_info.id then
		print("USER INFO CHANGED")
		
		arg_8_0.vars.items = {
			{
				time = 0
			}
		}
		arg_8_0.vars.page = -1
		arg_8_0.vars.no_more_update = false
		arg_8_0.vars.local_user_id = arg_8_0.vars.defense_user_info.id
		
		arg_8_0:requestItems(true)
	end
end

function ClanWarReady.nextPage(arg_9_0)
	arg_9_0:requestItems()
end

function ClanWarReady.openHistoryPopup(arg_10_0, arg_10_1)
	ClanWarBuildingHistoryPopup:open(arg_10_0.vars.tower_id, arg_10_1, arg_10_0.vars.is_enemy)
end

function ClanWarReady.canUpdate(arg_11_0)
	return arg_11_0.vars.page < 5 and not arg_11_0.vars.no_more_update
end

function ClanWarReady.isFirstPage(arg_12_0)
	return arg_12_0.vars and arg_12_0.vars.page and arg_12_0.vars.page == -1
end

function ClanWarReady.requestItems(arg_13_0, arg_13_1)
	if not arg_13_0:canUpdate() then
		print("no more request")
		
		return 
	end
	
	local var_13_0 = arg_13_0.vars.defense_clan_info.clan_id
	local var_13_1 = arg_13_0.vars.tower_info.slot
	
	ClanWar:query("get_clan_war_slot_info", function(arg_14_0)
		arg_14_0 = arg_14_0 or {}
		arg_14_0.logs = arg_14_0.logs or {}
		
		if not arg_14_0.updated then
			balloon_message(T("war_err_msg009"))
			
			return 
		end
		
		arg_13_0.vars.no_more_update = #arg_14_0.logs == 0
		arg_13_0.vars.page = arg_14_0.page or 99999
		
		arg_13_0:appendsNotExist(arg_14_0.logs)
		arg_13_0:updateItems()
	end, {
		clan_id = var_13_0,
		slot = var_13_1,
		page_no = arg_13_0.vars.page + 1
	}, tostring(var_13_0) .. "_" .. tostring(var_13_1), arg_13_1)
end

function ClanWarReady.hide(arg_15_0)
	arg_15_0:setLeftBackButton(false)
	eff_slide_out(arg_15_0.vars.wnd, "n_detail_right", 300, 0, false, 600)
	UIAction:Add(FADE_OUT(100), arg_15_0.vars.wnd.c.n_focus)
	UIAction:Add(FADE_OUT(100), arg_15_0.vars.wnd.c.vignetting)
	arg_15_0:hideFilter()
end

function ClanWarReady.setLeftBackButton(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_16_0.vars.wnd, "btn_block", arg_16_1)
	if_set_visible(arg_16_0.vars.wnd, "btn_back", arg_16_1)
end

function ClanWarReady.onPushBackButton(arg_17_0)
	if not arg_17_0.vars.tower then
		ClanWarMain:focusOut()
		
		return 
	end
	
	arg_17_0:focusOut()
end

function ClanWarReady.setUIFocus(arg_18_0)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_focus")
	local var_18_1 = #ClanWar:getSubTowerAttackers(arg_18_0.vars.tower_info.slot, arg_18_0.vars.is_enemy) ~= 0
	
	if_set_visible(var_18_0, "n_ing_battle", var_18_1)
	
	if not arg_18_0.vars.is_enemy then
		if ClanWar:getMode() == CLAN_WAR_MODE.READY then
			local var_18_2 = ClanWar:isEmptyEquipUser(arg_18_0.vars.tower_info)
			
			if_set_visible(arg_18_0.vars.wnd, "talk_unequip_bg", var_18_2)
		end
		
		if_set_visible(var_18_0, "n_info", false)
		
		return 
	end
	
	local var_18_3, var_18_4 = ClanWarMain:canAttack(arg_18_0.vars.tower_info.slot, arg_18_0.vars.is_enemy)
	local var_18_5 = ""
	local var_18_6 = ""
	local var_18_7 = #ClanWar:getSubTowerAttackers(arg_18_0.vars.tower_info.slot, arg_18_0.vars.is_enemy) ~= 0
	local var_18_8 = var_18_4 == "same_enemy"
	local var_18_9 = var_18_4 == "remain_building" or var_18_4 == "remain_tower"
	
	if Account:getCurrentWarUId() >= 4 then
		var_18_9 = var_18_4 == "remain_tower"
	end
	
	local var_18_10 = var_18_4 == "observer"
	
	if var_18_7 then
		var_18_5 = T("war_ui_battlestatus_01")
		var_18_6 = T("war_ui_battlestatus_04")
	elseif var_18_8 then
		var_18_5 = T("war_ui_battlestatus_02")
		var_18_6 = T("war_ui_battlestatus_05")
	elseif var_18_9 then
		var_18_5 = T("war_ui_battlestatus_03")
		var_18_6 = T("war_ui_battlestatus_06")
	elseif var_18_10 then
		var_18_5 = T("war_ui_battlestatus_07")
		var_18_6 = T("war_ui_battlestatus_08")
	end
	
	if_set_visible(var_18_0, "n_info", var_18_5 ~= "" and var_18_6 ~= "")
	if_set(var_18_0, "t_title", var_18_5)
	if_set(var_18_0, "t_desc", var_18_6)
end

function ClanWarReady.setUIPlacement(arg_19_0)
	local var_19_0 = arg_19_0.vars.tower_info
	local var_19_1 = arg_19_0.vars.defense_user_info
	local var_19_2 = arg_19_0.vars.is_enemy
	local var_19_3 = arg_19_0.vars.defense_attacker_info or {
		win_count = 0,
		draw_count = 0,
		defeat_count = 0
	}
	local var_19_4 = var_19_2 and var_19_0.win_count + (var_19_0.win_semi_count or 0) or var_19_3.win_count
	local var_19_5 = var_19_2 and var_19_0.defeat_count + (var_19_0.defeat_semi_count or 0) or var_19_3.defeat_count
	local var_19_6 = arg_19_0.vars.wnd:getChildByName("n_Place_info")
	
	var_19_6:getChildByName("back"):setColor(var_19_2 and cc.c3b(109, 0, 0) or cc.c3b(3, 63, 6))
	
	local var_19_7 = var_19_6:getChildByName("n_defense_member")
	
	UIUtil:getRewardIcon(nil, var_19_1.leader_code, {
		no_popup = true,
		scale = 1,
		no_grade = true,
		parent = var_19_7:getChildByName("mob_icon"),
		is_enemy = arg_19_0.vars.is_enemy,
		border_code = var_19_1.border_code
	})
	if_set(var_19_7, "t_name", var_19_1.name)
	UIUtil:setLevel(getChildByPath(var_19_7, "n_lv"), var_19_1.level, MAX_ACCOUNT_LEVEL, 2)
	if_set_sprite(var_19_7, "menu_icon_kind", "img/icon_menu_" .. (var_19_2 and "def" or "att") .. ".png")
	if_set(var_19_7, "txt_title", T(var_19_2 and "war_ui_0080" or "war_ui_0072"))
	if_set(var_19_7, "t_score_draw", T("war_ui_0059", {
		value = var_19_2 and var_19_0.draw_count or var_19_3.draw_count
	}))
	if_set_sprite(var_19_7, "battle_pvp_icon1", "img/battle_pvp_icon_" .. (var_19_2 and "def" or "win") .. ".png")
	if_set_sprite(var_19_7, "battle_pvp_icon2", "img/battle_pvp_icon_" .. (var_19_2 and "defeat" or "lose") .. ".png")
	if_set(var_19_7, "t_score1", T("war_ui_0038", {
		value = var_19_4
	}))
	if_set(var_19_7, "t_score2", T("war_ui_0039", {
		value = var_19_5
	}))
	
	local var_19_8, var_19_9 = ClanWarMain:getTowerHP(var_19_0.slot, var_19_2)
	
	if_set(var_19_7, "t_percent", to_n(var_19_8) .. "/" .. to_n(var_19_9))
	if_set_percent(var_19_7, "progress_bar", var_19_8 / var_19_9)
	
	local function var_19_10(arg_20_0)
		local var_20_0 = {}
		
		arg_20_0 = arg_20_0 or {}
		
		for iter_20_0, iter_20_1 in pairs(arg_20_0) do
			local var_20_1 = UNIT:create(iter_20_1.unit)
			
			var_20_1:calc()
			
			if iter_20_1.unit.skin_code then
				var_20_1:changeSkin(iter_20_1.unit.skin_code)
			end
			
			table.insert(var_20_0, var_20_1)
		end
		
		return var_20_0
	end
	
	local var_19_11 = var_19_6:getChildByName("n_defense_team")
	
	arg_19_0:setUIDefenseTeam(var_19_11:getChildByName("n_team1"), var_19_10(var_19_0.defense_info1.units))
	arg_19_0:setUIDefenseTeam(var_19_11:getChildByName("n_team2"), var_19_10(var_19_0.defense_info2.units))
end

function ClanWarReady.setUIDefenseTeam(arg_21_0, arg_21_1, arg_21_2)
	for iter_21_0 = 1, 3 do
		local var_21_0 = arg_21_1:getChildByName("mob_icon" .. iter_21_0)
		
		if get_cocos_refid(var_21_0) then
			var_21_0:removeAllChildren()
		end
	end
	
	for iter_21_1, iter_21_2 in pairs(arg_21_2) do
		UIUtil:getRewardIcon(nil, iter_21_2:getDisplayCode(), {
			no_db_grade = true,
			role = true,
			off_power_detail = true,
			parent = arg_21_1:getChildByName("mob_icon" .. iter_21_1),
			lv = iter_21_2:getLv(),
			max_lv = iter_21_2:getMaxLevel(),
			grade = iter_21_2:getGrade(),
			zodiac = iter_21_2:getZodiacGrade(),
			awake = iter_21_2:getAwakeGrade(),
			is_enemy = arg_21_0.vars.is_enemy
		})
	end
end

function ClanWarReady.initListView(arg_22_0)
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("list_view_battle_record")
	
	arg_22_0.vars.listview_battle_record = ItemListView_v2:bindControl(var_22_0)
	
	local var_22_1 = {
		onUpdate = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			if arg_23_3.time == 0 then
				if_set_visible(arg_23_1, "n_item", false)
				if_set_visible(arg_23_1, "n_loading_more", arg_22_0:canUpdate())
				
				return 
			end
			
			if_set_visible(arg_23_1, "n_loading_more", false)
			
			local function var_23_0(arg_24_0)
				if not arg_24_0 then
					return 
				end
				
				local var_24_0 = arg_24_0:getChildByName("txt_result")
				local var_24_1 = arg_24_0:getChildByName("txt_desc")
				
				if not var_24_0 or not var_24_1 then
					return 
				end
				
				UIUserData:call(var_24_0, "SINGLE_WSCALE(153)")
				if_set(arg_24_0, "txt_result", T(ClanWarUIUtil:getResultTextID(arg_23_3.battle_type, arg_23_3.result)))
				if_set_remain_time(arg_24_0, "txt_desc", arg_23_3.time)
				var_24_1:setScaleX(0.62)
				UIUserData:call(var_24_1, "SINGLE_WSCALE(125)")
			end
			
			local var_23_1 = Clan:getClanInfo()
			local var_23_2 = arg_23_3.user_info
			local var_23_3 = arg_23_3.enemy_user_info
			local var_23_4 = getChildByPath(arg_23_1, "n_item/n_info")
			
			var_23_0(var_23_4)
			UIUtil:getUserIcon(var_23_3.leader_code, {
				no_role = true,
				no_lv = true,
				no_grade = true,
				parent = arg_23_1:getChildByName("mob_icon"),
				is_enemy = var_23_3.clan_id ~= var_23_1.clan_id,
				border_code = var_23_3.border_code
			})
			if_set(var_23_4, "t_name", var_23_3.name)
			
			local var_23_5 = var_23_4:getChildByName("t_name")
			
			if var_23_5 then
				var_23_5:setScaleX(0.79)
				UIUserData:call(var_23_5, "SINGLE_WSCALE(125)")
			end
			
			if_set_sprite(var_23_4, "icon_result_1", ClanWarUIUtil:getRoundResultIconPath(arg_23_3.battle_type, arg_23_3.round1_result))
			if_set_sprite(var_23_4, "icon_result_2", ClanWarUIUtil:getRoundResultIconPath(arg_23_3.battle_type, arg_23_3.round2_result))
			
			if Account:getCurrentWarUId() >= var_0_0 then
				local var_23_6 = arg_23_1:getChildByName("btn_log")
				local var_23_7 = ClanWarReady:isEmptyWarInfo(arg_22_0.vars.tower_id, arg_23_2, arg_22_0.vars.is_enemy)
				
				if var_23_6 and not var_23_7 then
					var_23_6:setVisible(true)
					
					var_23_6.index = arg_23_2
				end
			end
		end
	}
	
	var_22_0:setPositionY(arg_22_0.vars.is_enemy and 103 or 3)
	var_22_0:setContentSize({
		width = var_22_0:getContentSize().width,
		height = arg_22_0.vars.is_enemy and 483 or 583
	})
	arg_22_0.vars.listview_battle_record:setRenderer(load_control("wnd/clan_war_record_item.csb"), var_22_1)
end

function ClanWarReady.appendsNotExist(arg_25_0, arg_25_1)
	for iter_25_0, iter_25_1 in pairs(arg_25_1) do
		local var_25_0 = iter_25_1.clan_war_battle_uid
		
		if not table.find(arg_25_0.vars.items, function(arg_26_0, arg_26_1)
			return arg_26_1.clan_war_battle_uid == var_25_0
		end) then
			table.push(arg_25_0.vars.items, iter_25_1)
		end
	end
end

function ClanWarReady.toggleFilter(arg_27_0)
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_filter")
	
	if not get_cocos_refid(var_27_0) then
		return 
	end
	
	var_27_0:setVisible(not var_27_0:isVisible())
end

function ClanWarReady.hideFilter(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_filter")
	
	if not get_cocos_refid(var_28_0) then
		return 
	end
	
	var_28_0:setVisible(false)
end

function ClanWarReady.resetFilter(arg_29_0)
	if not arg_29_0.vars or not arg_29_0.vars.filter then
		return 
	end
	
	arg_29_0.vars.filter = nil
end

function ClanWarReady.setFilter(arg_30_0, arg_30_1)
	if arg_30_1 == 1 then
		arg_30_0.vars.filter = "all"
	elseif arg_30_1 == 2 then
		arg_30_0.vars.filter = "attack"
	elseif arg_30_1 == 3 then
		arg_30_0.vars.filter = "defense"
	end
	
	arg_30_0:setFilterUI()
	arg_30_0:updateItems()
end

function ClanWarReady.setFilterUI(arg_31_0)
	local var_31_0 = arg_31_0.vars.wnd:getChildByName("btn_filter")
	local var_31_1 = arg_31_0.vars.wnd:getChildByName("btn_filter_active")
	local var_31_2 = arg_31_0.vars.filter or "all"
	local var_31_3 = 1
	
	if var_31_2 == "attack" then
		var_31_3 = 2
	elseif var_31_2 == "defense" then
		var_31_3 = 3
	end
	
	var_31_0:setVisible(var_31_3 == 1)
	var_31_1:setVisible(var_31_3 ~= 1)
	
	local var_31_4 = var_31_3 == 1 and var_31_0 or var_31_1
	
	if_set(var_31_4, "txt_cur_sort", T("clanwar_building_info_filter" .. var_31_3))
	if_set_sprite(var_31_4, "icon", "img/icon_menu_" .. var_31_2)
	
	for iter_31_0 = 1, 3 do
		local var_31_5 = arg_31_0.vars.wnd:getChildByName("btn_sort_" .. iter_31_0)
		
		if not get_cocos_refid(var_31_5) then
			break
		end
		
		if_set_visible(var_31_5, "cursor", iter_31_0 == var_31_3)
	end
end

function ClanWarReady.getFilterValue(arg_32_0)
	if not arg_32_0.vars or not arg_32_0.vars.filter then
		return 
	end
	
	return arg_32_0.vars.filter
end

function ClanWarReady.updateItems(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = arg_33_0.vars.listview_battle_record:getDataSource() or {}
	local var_33_1 = table.count(var_33_0)
	
	arg_33_0.vars.wnd:getChildByName("n_no_record"):setVisible((not arg_33_0.vars.items[1] or not arg_33_0.vars.items[1].slot) and not arg_33_0.vars.items[2])
	table.sort(arg_33_0.vars.items, function(arg_34_0, arg_34_1)
		return arg_34_0.time > arg_34_1.time
	end)
	
	local var_33_2 = {}
	local var_33_3 = 2
	
	if arg_33_0.vars.filter == "attack" then
		var_33_3 = 0
	elseif arg_33_0.vars.filter == "defense" then
		var_33_3 = 1
	end
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.items) do
		if var_33_3 == 2 then
			table.insert(var_33_2, iter_33_1)
		elseif iter_33_1.battle_type and var_33_3 == iter_33_1.battle_type or iter_33_1.time == 0 then
			table.insert(var_33_2, iter_33_1)
		end
	end
	
	table.sort(var_33_2, function(arg_35_0, arg_35_1)
		if not arg_35_0 then
			return false
		end
		
		if not arg_35_1 then
			return true
		end
		
		if arg_35_0.time == 0 then
			return false
		end
		
		if arg_35_1.time == 0 then
			return true
		end
		
		return arg_35_0.time > arg_35_1.time
	end)
	arg_33_0.vars.listview_battle_record:removeAllChildren()
	arg_33_0.vars.listview_battle_record:setDataSource(var_33_2)
	
	if arg_33_0.vars.page == 0 then
		arg_33_0.vars.listview_battle_record:jumpToTop()
	else
		arg_33_0.vars.listview_battle_record:forceDoLayout()
		arg_33_0.vars.listview_battle_record:jumpToIndex(var_33_1)
	end
end

function ClanWarReady.isEmptyWarInfo(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	if Account:getCurrentWarUId() < var_0_0 then
		return true
	end
	
	local var_36_0 = ClanWar:getBuildingBattleLogs(arg_36_1, arg_36_3) or {}
	
	if table.empty(var_36_0) then
		return true
	end
	
	local var_36_1 = ClanWarReady:getFilterValue()
	
	if var_36_1 and var_36_1 ~= "all" then
		local var_36_2 = var_36_1 == "defense" and 1 or 0
		local var_36_3 = {}
		
		for iter_36_0, iter_36_1 in pairs(var_36_0) do
			if iter_36_1.battle_type and iter_36_1.battle_type == var_36_2 then
				table.insert(var_36_3, iter_36_1)
			end
		end
		
		var_36_0 = var_36_3
	end
	
	if table.empty(var_36_0) then
		return true
	end
	
	local var_36_4 = var_36_0[arg_36_2 or 1]
	
	if not var_36_4 or table.empty(var_36_4) then
		return true
	end
	
	local var_36_5 = var_36_4.enemy_info1
	local var_36_6 = var_36_4.enemy_info2
	
	if not var_36_5 or not var_36_6 then
		return true
	end
	
	local var_36_7 = var_36_5.e_t
	local var_36_8 = var_36_6.e_t
	local var_36_9 = var_36_5.e_d
	local var_36_10 = var_36_6.e_d
	local var_36_11 = var_36_5.m_t
	local var_36_12 = var_36_6.m_t
	local var_36_13 = var_36_5.m_d
	local var_36_14 = var_36_6.m_d
	
	if not var_36_7 or not var_36_8 or not var_36_9 or not var_36_10 then
		return true
	end
end

ClanWarBuildingHistoryPopup = {}

function HANDLER.clan_war_detail_log(arg_37_0, arg_37_1)
	if arg_37_1 == "btn_close" then
		ClanWarBuildingHistoryPopup:close()
	end
end

function ClanWarBuildingHistoryPopup.open(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	if not arg_38_1 or not arg_38_2 then
		return 
	end
	
	if Account:getCurrentWarUId() < var_0_0 then
		return 
	end
	
	arg_38_0.vars = {}
	arg_38_0.vars.tower_id = arg_38_1
	arg_38_0.vars.is_enemy = arg_38_3
	
	local var_38_0 = arg_38_2 or 1
	
	if ClanWarReady:isEmptyWarInfo(arg_38_0.vars.tower_id, var_38_0, arg_38_0.vars.is_enemy) then
		Log.e("no_record_data")
		
		return 
	end
	
	local var_38_1 = ClanWar:getBuildingBattleLogs(arg_38_0.vars.tower_id, arg_38_0.vars.is_enemy)
	
	if table.empty(var_38_1) then
		return 
	end
	
	local var_38_2 = ClanWarReady:getFilterValue()
	
	if var_38_2 and var_38_2 ~= "all" then
		local var_38_3 = var_38_2 == "defense" and 1 or 0
		local var_38_4 = {}
		
		for iter_38_0, iter_38_1 in pairs(var_38_1) do
			if iter_38_1.battle_type and iter_38_1.battle_type == var_38_3 then
				table.insert(var_38_4, iter_38_1)
			end
		end
		
		var_38_1 = var_38_4
	end
	
	if table.empty(var_38_1) then
		return 
	end
	
	arg_38_0.vars.slot_info = var_38_1[var_38_0]
	
	if not arg_38_0.vars.slot_info or table.empty(arg_38_0.vars.slot_info) then
		return 
	end
	
	arg_38_0.vars.wnd = load_dlg("clan_war_detail_log", true, "wnd")
	
	SceneManager:getRunningNativeScene():addChild(arg_38_0.vars.wnd)
	BackButtonManager:push({
		check_id = "clan_war_detail_log",
		back_func = function()
			ClanWarBuildingHistoryPopup:close()
		end
	})
	
	local var_38_5 = arg_38_0.vars.slot_info.enemy_info1
	local var_38_6 = arg_38_0.vars.slot_info.enemy_info2
	local var_38_7 = var_38_5.e_t
	local var_38_8 = var_38_6.e_t
	
	arg_38_0.vars.e_t1_units = var_38_7.units
	arg_38_0.vars.e_t2_units = var_38_8.units
	arg_38_0.vars.e_d1 = var_38_5.e_d
	arg_38_0.vars.e_d2 = var_38_6.e_d
	
	local var_38_9 = var_38_5.m_t
	local var_38_10 = var_38_6.m_t
	
	arg_38_0.vars.m_t1_units = var_38_9.units
	arg_38_0.vars.m_t2_units = var_38_10.units
	
	local var_38_11 = var_38_5.m_d
	local var_38_12 = var_38_6.m_d
	
	for iter_38_2, iter_38_3 in pairs(arg_38_0.vars.e_d1) do
		for iter_38_4, iter_38_5 in pairs(arg_38_0.vars.e_t1_units) do
			if iter_38_3 == iter_38_5.unit.id then
				iter_38_5.is_dead = true
			end
		end
	end
	
	for iter_38_6, iter_38_7 in pairs(arg_38_0.vars.e_d2) do
		for iter_38_8, iter_38_9 in pairs(arg_38_0.vars.e_t2_units) do
			if iter_38_7 == iter_38_9.unit.id then
				iter_38_9.is_dead = true
			end
		end
	end
	
	for iter_38_10, iter_38_11 in pairs(var_38_11) do
		for iter_38_12, iter_38_13 in pairs(arg_38_0.vars.m_t1_units) do
			if iter_38_11 == iter_38_13.unit.id then
				iter_38_13.is_dead = true
			end
		end
	end
	
	for iter_38_14, iter_38_15 in pairs(var_38_12) do
		for iter_38_16, iter_38_17 in pairs(arg_38_0.vars.m_t2_units) do
			if iter_38_15 == iter_38_17.unit.id then
				iter_38_17.is_dead = true
			end
		end
	end
	
	arg_38_0.vars.user_info = arg_38_0.vars.slot_info.user_info
	arg_38_0.vars.enemy_user_info = arg_38_0.vars.slot_info.enemy_user_info
	
	if arg_38_0.vars.is_enemy then
		local var_38_13 = arg_38_0.vars.wnd:getChildByName("back")
		
		if_set_color(arg_38_0.vars.wnd, "back", tocolor("#6d0000"))
	end
	
	arg_38_0:updateTopInfoUI()
	arg_38_0:updateRoundInfo()
	arg_38_0:updateHeroUI()
end

function ClanWarBuildingHistoryPopup.updateRoundInfo(arg_40_0)
	local var_40_0 = arg_40_0.vars.wnd:getChildByName("n_place_info")
	local var_40_1 = var_40_0:getChildByName("n_round1")
	local var_40_2 = var_40_0:getChildByName("n_round2")
	
	if_set_sprite(var_40_1, "icon_result", ClanWarUIUtil:getRoundResultIconPath(arg_40_0.vars.slot_info.battle_type, arg_40_0.vars.slot_info.round1_result))
	if_set_sprite(var_40_2, "icon_result", ClanWarUIUtil:getRoundResultIconPath(arg_40_0.vars.slot_info.battle_type, arg_40_0.vars.slot_info.round2_result))
	if_set(var_40_1, "txt_desc", T(ClanWarUIUtil:getRoundResultTextID(arg_40_0.vars.slot_info.round1_result)))
	if_set(var_40_2, "txt_desc", T(ClanWarUIUtil:getRoundResultTextID(arg_40_0.vars.slot_info.round2_result)))
end

function ClanWarBuildingHistoryPopup.updateTopInfoUI(arg_41_0)
	if not arg_41_0.vars.user_info or not arg_41_0.vars.enemy_user_info then
		return 
	end
	
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_place_info")
	
	if_set(var_41_0, "txt_name", arg_41_0.vars.user_info.name)
	UIUtil:getRewardIcon(nil, arg_41_0.vars.user_info.leader_code, {
		no_popup = true,
		scale = 1,
		no_grade = true,
		parent = getChildByPath(var_41_0, "mob_icon"),
		border_code = arg_41_0.vars.user_info.border_code
	})
	UIUtil:setLevel(getChildByPath(var_41_0, "n_lv"), arg_41_0.vars.user_info.level, MAX_ACCOUNT_LEVEL, 2)
	
	local var_41_1 = arg_41_0.vars.wnd:getChildByName("n_enemy_info")
	
	if_set(var_41_1, "txt_name", arg_41_0.vars.enemy_user_info.name)
	UIUtil:getRewardIcon(nil, arg_41_0.vars.enemy_user_info.leader_code, {
		no_popup = true,
		scale = 1,
		no_grade = true,
		parent = getChildByPath(var_41_1, "mob_icon"),
		border_code = arg_41_0.vars.enemy_user_info.border_code
	})
	UIUtil:setLevel(getChildByPath(var_41_1, "n_lv"), arg_41_0.vars.enemy_user_info.level, MAX_ACCOUNT_LEVEL, 2)
	if_set(arg_41_0.vars.wnd, "txt_title", T(ClanWarUIUtil:getResultTextID(arg_41_0.vars.slot_info.battle_type, arg_41_0.vars.slot_info.result)))
end

function ClanWarBuildingHistoryPopup.updateHeroUI(arg_42_0)
	local var_42_0 = arg_42_0.vars.wnd:getChildByName("n_place_info")
	local var_42_1 = var_42_0:getChildByName("n_round1")
	local var_42_2 = var_42_0:getChildByName("n_round2")
	local var_42_3 = arg_42_0.vars.wnd:getChildByName("n_enemy_info")
	local var_42_4 = var_42_3:getChildByName("n_round1")
	local var_42_5 = var_42_3:getChildByName("n_round2")
	
	local function var_42_6(arg_43_0)
		local var_43_0 = {}
		
		if arg_43_0 then
			for iter_43_0, iter_43_1 in pairs(arg_43_0) do
				var_43_0[iter_43_1[1]] = iter_43_1[2]
			end
		end
		
		return var_43_0
	end
	
	local var_42_7 = arg_42_0.vars.user_info.gb
	local var_42_8 = arg_42_0.vars.enemy_user_info.gb
	local var_42_9 = var_42_6(var_42_7)
	local var_42_10 = var_42_6(var_42_8)
	
	local function var_42_11(arg_44_0, arg_44_1, arg_44_2)
		if not get_cocos_refid(arg_44_0) then
			return 
		end
		
		if not arg_44_1 then
			return 
		end
		
		local var_44_0 = UNIT:create(arg_44_1.unit)
		
		if not var_44_0 then
			return 
		end
		
		local var_44_1 = (arg_44_2 and var_42_10 or var_42_9)[var_44_0:getUID()]
		
		if var_44_1 then
			var_44_0 = GrowthBoost:applyManual(var_44_0, var_44_1)
		end
		
		local var_44_2 = UIUtil:getRewardIcon(nil, var_44_0:getDisplayCode(), {
			no_db_grade = true,
			role = true,
			no_popup = true,
			parent = arg_44_0:getChildByName("mob_icon"),
			lv = var_44_0:getLv(),
			grade = var_44_0:getGrade(),
			zodiac = var_44_0:getZodiacGrade() or 0,
			awake = var_44_0:getAwakeGrade() or 0,
			is_enemy = arg_42_0.vars.is_enemy ~= arg_44_2
		})
		
		if arg_44_1.is_dead then
			if_set_color(var_44_2, nil, cc.c3b(136, 136, 136))
			if_set_visible(arg_44_0, "icon_coma", true)
		end
	end
	
	for iter_42_0, iter_42_1 in pairs(arg_42_0.vars.m_t1_units) do
		local var_42_12 = var_42_1:getChildByName("n_" .. iter_42_0)
		
		var_42_11(var_42_12, iter_42_1, false)
	end
	
	for iter_42_2, iter_42_3 in pairs(arg_42_0.vars.m_t2_units) do
		local var_42_13 = var_42_2:getChildByName("n_" .. iter_42_2)
		
		var_42_11(var_42_13, iter_42_3, false)
	end
	
	for iter_42_4, iter_42_5 in pairs(arg_42_0.vars.e_t1_units) do
		local var_42_14 = var_42_4:getChildByName("n_" .. iter_42_4)
		
		var_42_11(var_42_14, iter_42_5, true)
	end
	
	for iter_42_6, iter_42_7 in pairs(arg_42_0.vars.e_t2_units) do
		local var_42_15 = var_42_5:getChildByName("n_" .. iter_42_6)
		
		var_42_11(var_42_15, iter_42_7, true)
	end
end

function ClanWarBuildingHistoryPopup.close(arg_45_0)
	BackButtonManager:pop("clan_war_detail_log")
	arg_45_0.vars.wnd:removeFromParent()
	
	arg_45_0.vars = {}
end
