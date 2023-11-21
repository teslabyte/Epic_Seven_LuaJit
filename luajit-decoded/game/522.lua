ClanBattleList = {}
ClanBattleList.ClanWar = {}
ClanBattleList.WorldBoss = {}
ClanBattleList.Lota = {}

function HANDLER.clan_battle_item(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "btn" and arg_1_0.item and arg_1_0.item.obj then
		arg_1_0.item.obj:onSelectEnter()
	end
end

copy_functions(ScrollView, ClanBattleList)

function ClanBattleList.show(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = Dialog:open("wnd/clan_battle", arg_2_0, {
		use_backbutton = false
	})
	arg_2_0.vars.scrollview = arg_2_0.vars.wnd:getChildByName("scrollview")
	
	arg_2_0:initScrollView(arg_2_0.vars.scrollview, 740, 240)
	
	arg_2_0.vars.datas = {}
	
	local var_2_0 = arg_2_0:is_reqHof()
	
	query("get_clan_war_view_info", {
		req_hof = var_2_0
	})
	
	return arg_2_0.vars.wnd
end

function ClanBattleList.is_reqHof(arg_3_0)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	local var_3_0 = Account:getCurrentWarUId() or -1
	local var_3_1 = false
	
	for iter_3_0 = 1, 99 do
		local var_3_2, var_3_3 = DBN("clan_war", iter_3_0, {
			"uid",
			"season_type"
		})
		
		if not var_3_2 then
			break
		end
		
		if var_3_2 == var_3_0 and var_3_3 == "regular" then
			var_3_1 = true
			
			break
		end
	end
	
	if (Account:getConfigData("clanwar.cur_warUID") or -1) ~= var_3_0 and var_3_1 then
		SAVE:setTempConfigData("clanwar.cur_warUID", var_3_0)
		SAVE:sendQueryServerConfig()
		
		return true
	end
end

function ClanBattleList.initData(arg_4_0, arg_4_1)
	ClanBattleList.ClanWar:init()
	ClanBattleList.WorldBoss:init(arg_4_1)
	ClanBattleList.Lota:init(arg_4_1)
	
	local var_4_0 = ClanBattleList.Lota:isShopEnable()
	
	if var_4_0 then
		table.insert(arg_4_0.vars.datas, ClanBattleList.Lota:getData())
	end
	
	table.insert(arg_4_0.vars.datas, ClanBattleList.ClanWar:getData())
	table.insert(arg_4_0.vars.datas, ClanBattleList.WorldBoss:getData())
	
	if not var_4_0 then
		table.insert(arg_4_0.vars.datas, ClanBattleList.Lota:getData())
	end
	
	arg_4_0:createScrollViewItems(arg_4_0.vars.datas)
end

function ClanBattleList.getScrollViewItem(arg_5_0, arg_5_1)
	local var_5_0 = load_control("wnd/clan_battle_item.csb")
	
	if_set_visible(var_5_0, "icon_noti", false)
	if_set_visible(var_5_0, "n_worldboss", false)
	arg_5_1.obj:setUI(var_5_0, arg_5_1)
	arg_5_1.obj:setControl(var_5_0)
	
	return var_5_0
end

function ClanBattleList.checkTutorial(arg_6_0)
	local var_6_0 = table.count(Account:getTeam(CLAN_TEAM_DEF_F) or {})
	local var_6_1 = table.count(Account:getTeam(CLAN_TEAM_DEF_B) or {})
	
	if var_6_0 < 1 or var_6_0 < 1 or DEBUG_CLANWAR_TEAM_SETUP then
		TutorialGuide:procGuide()
		Dialog:msgBox(T("clanwar_need_team_setup"), {
			no_back_button = true,
			handler = function()
				TutorialGuide:procGuide("clanwar_formation")
				ClanWarTeam:show({
					mode = "clan_pvp_defence",
					is_tutorial = true,
					parent = SceneManager:getRunningNativeScene()
				})
			end
		})
		
		return true
	end
	
	return false
end

function ClanBattleList.ClanWar.init(arg_8_0)
	arg_8_0.vars = {}
	
	local var_8_0, var_8_1 = ClanWar:isCompleteWarReady()
	local var_8_2 = ClanWar:getMode()
	
	arg_8_0.vars.data = {
		battle_type = "clan_war",
		obj = arg_8_0,
		is_war_enter = var_8_0,
		enter_state = var_8_1,
		clan_war_mode = var_8_2
	}
end

function ClanBattleList.ClanWar.getData(arg_9_0)
	return arg_9_0.vars.data
end

function ClanBattleList.ClanWar.setUI(arg_10_0, arg_10_1, arg_10_2)
	if_set(arg_10_1, "txt_title", T("war_ui_0015"))
	if_set(arg_10_1, "txt_disc", T("war_ui_0016"))
	
	local var_10_0 = not arg_10_2.is_war_enter or arg_10_2.enter_state
	
	if_set_visible(arg_10_1, "n_enemy", not var_10_0)
	if_set_visible(arg_10_1, "n_no_defense", var_10_0)
	if_set_visible(arg_10_1, "n_info_lock", false)
	
	local var_10_1 = arg_10_1:getChildByName("n_vs")
	
	if_set_visible(var_10_1, "n_clan_war", true)
	if_set_visible(var_10_1, "n_worldboss", false)
	
	local var_10_2, var_10_3 = DB("clan_war", ClanWar:getWarID(), {
		"season_type",
		"season_name"
	})
	
	if var_10_2 == "free" then
		if_set(arg_10_1, "txt_season_name", T(var_10_3))
	else
		if_set(arg_10_1, "txt_season_name", T("war_ui_0096", {
			name = T(var_10_3)
		}))
	end
	
	local var_10_4 = ClanWar:isRewardAble()
	
	if_set_visible(arg_10_1, "n_compensation", var_10_4)
	arg_10_0:setWarEnterTextNodes(arg_10_1, arg_10_2.clan_war_mode, arg_10_2.enter_state)
	
	local var_10_5 = arg_10_1:getChildByName("btn")
	
	arg_10_0:setEnemyClanInfo(arg_10_1, arg_10_2)
	
	var_10_5.item = arg_10_2
end

function ClanBattleList.ClanWar.setControl(arg_11_0, arg_11_1)
	arg_11_0.vars.control = arg_11_1
end

function ClanBattleList.ClanWar.getControl(arg_12_0)
	return arg_12_0.vars.control
end

function ClanBattleList.ClanWar.setEnemyClanInfo(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = ClanWar:getEnemyClanInfo()
	
	if table.count(var_13_0) == 0 and arg_13_2.is_war_enter and not arg_13_2.enter_state then
		if_set_visible(arg_13_1, "n_vs", false)
		
		return 
	end
	
	if_set_visible(arg_13_1, "n_vs", true)
	UIUtil:updateClanEmblem(arg_13_1, var_13_0)
	if_set(arg_13_1, "txt_clan_name", var_13_0.name)
end

function ClanBattleList.ClanWar.setWorldBossUI(arg_14_0, arg_14_1, arg_14_2)
	if_set(arg_14_1, "txt_title", T("title??"))
	if_set(arg_14_1, "txt_disc", T("boss?"))
	
	local var_14_0 = arg_14_1:getChildByName("n_vs")
	
	if_set_visible(var_14_0, "n_clan_war", false)
	if_set_visible(var_14_0, "n_worldboss", true)
end

function ClanBattleList.ClanWar.setWarEnterTextNodes(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_3 == "member_count" then
		if_set(arg_15_1, "label", T("war_ui_0005"))
	elseif arg_15_3 == "time" then
		if_set(arg_15_1, "label", T("war_ui_0004"))
	elseif arg_15_3 == "ready" then
		if_set(arg_15_1, "label", T("war_ui_0006"))
	elseif arg_15_3 == "matching_failed" then
		if_set(arg_15_1, "label", T("war_ui_0063"))
	elseif arg_15_3 == "unearned_win" then
		if_set(arg_15_1, "label", T("war_ui_0064"))
	end
	
	local var_15_0 = arg_15_1:getChildByName("n_time")
	
	if arg_15_2 == CLAN_WAR_MODE.NONE or arg_15_2 == CLAN_WAR_MODE.READY then
		if_set(var_15_0, "txt_disc", T("war_state_play"))
	elseif arg_15_2 == CLAN_WAR_MODE.WAR then
		if_set(var_15_0, "txt_disc", T("war_state_end"))
	end
	
	if_set(var_15_0, "txt_time", T("war_time_h", {
		hour = math.floor(ClanWar:getRemainTime() / 3600)
	}))
end

function ClanBattleList.ClanWar.onSelectEnter(arg_16_0)
	print("onSelectEnter")
	
	if ContentDisable:byAlias("clan_war") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if ClanBattleList:checkTutorial() then
		return 
	end
	
	local var_16_0 = Clan:getUserMemberInfo()
	local var_16_1 = Account:getPvpScheduleToDay()
	local var_16_2 = Account:getPrevWarDayId(var_16_1.war_day_id)
	
	if var_16_0.reward_war_day_id == nil or tonumber(var_16_0.reward_war_day_id) < tonumber(var_16_2) then
		query("check_clan_war_reward")
	else
		arg_16_0:enter_clan_war()
	end
end

function ClanBattleList.ClanWar.enter_clan_war(arg_17_0)
	local var_17_0, var_17_1 = ClanWar:isCompleteWarReady()
	
	if var_17_1 and var_17_1 ~= "ready" then
		SceneManager:nextScene("clan_war_close", {
			state = var_17_1
		})
	elseif var_17_0 then
		query("clan_war_enter")
	else
		SceneManager:nextScene("clan_war_close", {
			state = var_17_1
		})
	end
	
	BackButtonManager:pop("TopBarNew." .. T("clan_title"))
end

function ClanBattleList.WorldBoss.init(arg_18_0, arg_18_1)
	arg_18_0.vars = {}
	arg_18_0.vars.data = {
		battle_type = "world_boss",
		obj = arg_18_0
	}
	
	if arg_18_1.wb_season_info then
		arg_18_0.vars.data.bossInfo = arg_18_1.wb_season_info
	end
	
	if arg_18_1.wb_next_info then
		arg_18_0.vars.data.nextBossInfo = arg_18_1.wb_next_info
	end
end

function ClanBattleList.WorldBoss.getData(arg_19_0)
	return arg_19_0.vars.data
end

function ClanBattleList.WorldBoss.setUI(arg_20_0, arg_20_1, arg_20_2)
	arg_20_1:getChildByName("btn").item = arg_20_2
	
	if_set_visible(arg_20_1, "n_compensation", false)
	
	local var_20_0 = arg_20_2.bossInfo
	local var_20_1 = false
	
	if not var_20_0 then
		var_20_0 = arg_20_2.nextBossInfo
		var_20_1 = true
	end
	
	if_set_visible(arg_20_1, "icon_noti", false)
	if_set_visible(arg_20_1, "txt_season_name", false)
	if_set_visible(arg_20_1, "bar1_l", false)
	if_set_visible(arg_20_1, "bar1_r", false)
	
	local var_20_2 = arg_20_1:getChildByName("LEFT")
	local var_20_3 = arg_20_1:getChildByName("RIGHT")
	
	if_set_visible(var_20_2, "n_clan_war", false)
	if_set_visible(var_20_3, "n_clan_war", false)
	if_set(arg_20_1, "txt_title", T("war_ui_0018"))
	if_set(arg_20_1, "txt_disc", T("war_ui_0019"))
	if_set_sprite(var_20_2, "icon", "img/icon_menu_raid.png")
	
	local var_20_4 = not var_20_0 or not UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_BOSS) or ContentDisable:byAlias("clan_world_boss")
	
	if var_20_1 or var_20_4 then
		if_set_opacity(arg_20_1, "bg_wb", 76.5)
		if_set_opacity(var_20_2, nil, 127.5)
		if_set_visible(arg_20_1, "n_info_lock", not UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_BOSS))
		
		if not var_20_0 or var_20_4 then
			if_set_visible(var_20_3, nil, false)
			if_set_visible(var_20_2, "n_worldboss", false)
			if_set_visible(arg_20_1, "n_time", false)
			if_set_visible(arg_20_1, "bg", false)
			if_set_visible(arg_20_1, "bg_wb", true)
			
			return 
		end
	end
	
	if_set_visible(arg_20_1, "n_info_lock", false)
	
	local var_20_5 = WorldBossUtil:getBossHP(var_20_0.start_time, var_20_0.end_time)
	
	WorldBossUtil:setHPBar(var_20_3:getChildByName("n_gauge"), var_20_5)
	
	local var_20_6
	
	if var_20_1 then
		var_20_6 = WorldBossUtil:getRemainTimeText(var_20_0.start_time - WorldBossUtil:getTime())
		
		if_set(var_20_2:getChildByName("n_time"), "txt_disc", T("ui_clan_worldboss_next_remain"))
	else
		var_20_6 = WorldBossUtil:getRemainTimeText(var_20_0.end_time - WorldBossUtil:getTime())
		
		if_set(var_20_2:getChildByName("n_time"), "txt_disc", T("ui_clan_worldboss_battle_remain"))
	end
	
	if_set(var_20_2, "txt_time", T("ui_clanworldboss_time", {
		remain_time = var_20_6
	}))
	
	local var_20_7 = WorldBossUtil:getWorldbossName(var_20_0.boss_id)
	
	if_set(var_20_3:getChildByName("n_worldboss"), "txt_name", var_20_7)
	
	local var_20_8 = DB("clan_worldboss", var_20_0.boss_id, {
		"char_id"
	})
	
	UIUtil:getUserIcon(var_20_8, {
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = var_20_3:getChildByName("mob_icon")
	})
	
	local var_20_9 = WorldBossUtil:getStrongColorIconPath(var_20_0.color)
	
	if_set_sprite(var_20_3:getChildByName("info"), "icon_element", var_20_9)
	if_set_sprite(arg_20_1:getChildByName("n_vs"), "bg", "img/cm_bg_flag_blue_s.png")
	if_set_visible(arg_20_1, "bg", false)
	if_set_visible(arg_20_1, "bg_wb", true)
	if_set_visible(arg_20_1, "icon_noti", Clan:getWorldbossEnterable())
end

function ClanBattleList.WorldBoss.onSelectEnter(arg_21_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_BOSS) then
		balloon_message_with_sound("msg_clan_wb_rank_limit")
		
		return 
	end
	
	if ContentDisable:byAlias("clan_world_boss") then
		balloon_message_with_sound("content_disable")
		
		return 
	end
	
	BackButtonManager:pop("TopBarNew." .. T("clan_title"))
	SceneManager:nextScene("world_boss_map")
end

function ClanBattleList.WorldBoss.setControl(arg_22_0, arg_22_1)
	arg_22_0.vars.control = arg_22_1
end

function ClanBattleList.Lota.init(arg_23_0, arg_23_1)
	arg_23_0.vars = {}
	arg_23_0.vars.data = {
		obj = arg_23_0,
		lota_season_info = arg_23_1.lota_season_info
	}
end

function ClanBattleList.Lota.isCurrentOpen(arg_24_0)
	if not arg_24_0.vars.data.lota_season_info then
		return 
	end
	
	return LotaUtil:isCurrentOpen(arg_24_0.vars.data.lota_season_info.schedules)
end

function ClanBattleList.Lota.isShopEnable(arg_25_0)
	if ContentDisable:byAlias("clan_heritage") then
		return 
	end
	
	if not arg_25_0.vars.data.lota_season_info then
		return 
	end
	
	return LotaUtil:isShopEnable(arg_25_0.vars.data.lota_season_info.schedules)
end

function ClanBattleList.Lota.isRequireRedDot(arg_26_0)
	return Account:isClanLotaNoti()
end

function ClanBattleList.Lota.getData(arg_27_0)
	return arg_27_0.vars.data
end

function ClanBattleList.Lota.getCurrentScheduleData(arg_28_0, arg_28_1)
	return LotaUtil:getCurrentScheduleData(arg_28_1)
end

function ClanBattleList.Lota.getMaxFloor(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.id
	
	return LotaUtil:getMaxFloor(var_29_0)
end

function ClanBattleList.Lota.isAvailableEnter(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or {}
	
	return LotaUtil:isAvailableEnter(arg_30_1.schedules, arg_30_1.clan_status)
end

function ClanBattleList.Lota.getRequireEnterCondition(arg_31_0)
	return LotaUtil:getRequireEnterCondition()
end

function ClanBattleList.Lota.setUI(arg_32_0, arg_32_1, arg_32_2)
	if_set_visible(arg_32_1, "bg", false)
	if_set_visible(arg_32_1, "bg_wb", false)
	if_set_visible(arg_32_1, "bg_ht", true)
	if_set_visible(arg_32_1, "RIGHT", not ContentDisable:byAlias("clan_heritage"))
	if_set_visible(arg_32_1, "n_time", not ContentDisable:byAlias("clan_heritage"))
	
	local var_32_0 = arg_32_1:findChildByName("LEFT")
	
	if_set(var_32_0, "txt_title", T("ui_clan_heritage"))
	if_set(var_32_0, "txt_disc", T("ui_clan_heritage_desc"))
	if_set_sprite(var_32_0, "icon", "img/icon_menu_heritage.png")
	if_set_visible(var_32_0, "icon_noti", arg_32_0:isRequireRedDot())
	
	local var_32_1 = arg_32_1:findChildByName("RIGHT")
	
	if_set_visible(var_32_1, "n_clan_war", false)
	if_set_visible(var_32_1, "n_worldboss", false)
	if_set_visible(var_32_1, "n_heritage", true)
	if_set_visible(arg_32_1, "n_info_lock", false)
	
	local var_32_2 = var_32_1:findChildByName("Panel_bg"):findChildByName("bg")
	
	SpriteCache:resetSprite(var_32_2, "img/cm_bg_flag_green_s")
	if_set_visible(arg_32_1, "n_compensation", false)
	
	local var_32_3 = arg_32_2.lota_season_info or {}
	local var_32_4 = arg_32_0:getCurrentScheduleData(var_32_3.schedules)
	local var_32_5 = arg_32_1:findChildByName("n_time")
	local var_32_6 = arg_32_1:findChildByName("n_heritage")
	
	if not var_32_4 then
		if LotaUtil:isShopEnable(var_32_3.schedules) then
			local var_32_7 = LotaUtil:getLatestScheduleData(var_32_3.schedules)
			local var_32_8 = os.time()
			local var_32_9 = var_32_7.end_time + 604800
			local var_32_10 = sec_to_full_string(var_32_9 - var_32_8)
			
			if_set(var_32_5, "txt_time", T("ui_clan_heritage_remain", {
				remain_time = var_32_10
			}))
			if_set(var_32_5, "txt_disc", T("ui_clan_heritage_state_shop_remain"))
		else
			local var_32_11 = Account:getLotaSchedules()
			
			if var_32_11 and table.count(var_32_11) > 0 then
				local var_32_12 = LotaUtil:getCurrentScheduleData(var_32_11)
				
				if var_32_12 then
					local var_32_13 = os.time()
					local var_32_14 = var_32_12.start_time
					
					if var_32_13 < var_32_14 then
						local var_32_15 = sec_to_full_string(var_32_14 - var_32_13)
						local var_32_16 = "ui_clan_heritage_state_start_remain"
						
						if_set(var_32_5, "txt_disc", T(var_32_16))
						if_set(var_32_5, "txt_time", var_32_15)
					else
						if_set(var_32_5, "txt_disc", T("ui_clan_heritage_state_start_remain"))
						if_set(var_32_5, "txt_time", T("ui_clan_heritage_open_yet"))
					end
				else
					if_set(var_32_5, "txt_disc", T("ui_clan_heritage_state_start_remain"))
					if_set(var_32_5, "txt_time", T("ui_clan_heritage_open_yet"))
				end
			else
				if_set(var_32_5, "txt_disc", T("ui_clan_heritage_state_start_remain"))
				if_set(var_32_5, "txt_time", T("ui_clan_heritage_open_yet"))
			end
		end
		
		if_set_visible(var_32_6, "txt_location_name", false)
	else
		local var_32_17 = os.time()
		local var_32_18 = var_32_4.start_time
		local var_32_19 = var_32_4.end_time
		local var_32_20
		local var_32_21
		local var_32_22
		
		if var_32_18 < var_32_17 then
			var_32_20 = sec_to_full_string(var_32_19 - var_32_17)
			var_32_22 = "ui_clan_heritage_state_end_remain"
		else
			var_32_20 = sec_to_full_string(var_32_18 - var_32_17)
			var_32_22 = "ui_clan_heritage_state_start_remain"
		end
		
		if_set(var_32_5, "txt_disc", T(var_32_22))
		if_set(var_32_5, "txt_time", var_32_20)
	end
	
	local var_32_23 = var_32_6:findChildByName("n_ing")
	local var_32_24 = var_32_6:findChildByName("n_no_admission")
	
	if var_32_4 then
		local var_32_25 = DB("clan_heritage_season", var_32_4.id, "name")
		
		if_set(var_32_6, "txt_location_name", T(var_32_25))
	end
	
	local var_32_26, var_32_27 = arg_32_0:isAvailableEnter(var_32_3)
	
	if_set_visible(var_32_23, nil, var_32_26)
	if_set_visible(var_32_24, nil, not var_32_26)
	
	if var_32_26 then
		local var_32_28 = var_32_3.clan_status or {}
		local var_32_29 = var_32_3.user_status or {}
		local var_32_30 = var_32_3.boss_dead_count or 0
		local var_32_31 = var_32_28.clan_floor or 1
		local var_32_32 = var_32_29.user_floor or 1
		local var_32_33 = arg_32_0:getMaxFloor(var_32_4)
		
		if var_32_33 <= var_32_31 and var_32_30 > 0 then
			if_set(var_32_23, "txt_clan_ing", T("ui_clan_heritage_ongoing_3"))
		else
			if_set(var_32_23, "txt_clan_ing", T("ui_clan_heritage_ongoing_1", {
				floor = var_32_31
			}))
		end
		
		if var_32_33 <= var_32_32 and var_32_30 > 0 then
			if_set(var_32_23, "txt_my_ing", T("ui_clan_heritage_ongoing_3"))
		else
			if_set(var_32_23, "txt_my_ing", T("ui_clan_heritage_ongoing_2", {
				floor1 = var_32_32
			}))
		end
	else
		local var_32_34 = ""
		local var_32_35, var_32_36 = arg_32_0:getRequireEnterCondition()
		
		if var_32_27 == "req_more_member" then
			var_32_34 = T("ui_clan_heritage_condition_yet", {
				number = var_32_35
			})
		elseif var_32_27 == "req_more_level" then
			var_32_34 = T("ui_clan_heritage_condition_rank_yet", {
				rank = var_32_36
			})
		elseif var_32_27 == "no_data" or var_32_27 == "not_open" then
			if var_32_3 then
				if LotaUtil:isShopEnable(var_32_3.schedules) then
					var_32_34 = T("ui_clan_heritage_closed_shop_open")
				else
					var_32_34 = T("ui_clan_heritage_not_open_period")
				end
			else
				var_32_34 = T("ui_clan_heritage_not_open_period")
			end
		else
			var_32_34 = T("ui_clan_heritage_not_open_period")
		end
		
		if_set(var_32_24, "label", var_32_34)
	end
	
	arg_32_1:getChildByName("btn").item = arg_32_2
end

function ClanBattleList.Lota.onSelectEnter(arg_33_0)
	print("onSelectEnter LOTA")
	
	if ContentDisable:byAlias("clan_heritage") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	query("lota_enter")
end

function ClanBattleList.Lota.setControl(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.vars.control = arg_34_1
end

function ClanBattleList.Lota.getControl(arg_35_0)
	return arg_35_0.vars.control
end
