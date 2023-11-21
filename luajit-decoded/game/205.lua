PvpSA = {}

copy_functions(ScrollView, PvpSA)

function MsgHandler.pvp_sa_lobby(arg_1_0)
	AccountData.max_pvp_league = arg_1_0.max_pvp_league
	
	SceneManager:nextScene("pvp", arg_1_0)
end

function MsgHandler.pvp_sa_vs_refresh(arg_2_0)
	PvpSA:refreshVSlist(arg_2_0)
end

function ErrHandler.pvp_sa_vs_refresh(arg_3_0, arg_3_1)
	local var_3_0 = "buy." .. arg_3_1
	local var_3_1 = var_3_0 == "buy.no_to_crystal" or var_3_0 == "buy.no_to_gold"
	
	local function var_3_2()
		Shop:open("normal", string.sub(var_3_0, 11, -1))
	end
	
	local var_3_3 = load_dlg("shop_nocurrency", true, "wnd")
	
	if not var_3_1 then
		var_3_2 = nil
	end
	
	if_set(var_3_3, T(var_3_0 .. ".desc"))
	UIUtil:getRewardIcon(nil, string.sub(var_3_0, 8, -1), {
		show_name = true,
		detail = true,
		parent = var_3_3:getChildByName("n_item_pos")
	})
	Dialog:msgBox(T(var_3_0 .. ".desc"), {
		dlg = var_3_3,
		handler = var_3_2,
		yesno = var_3_1,
		title = T(var_3_0 .. ".title"),
		txt_shop_comment = T(var_3_0 .. ".comment")
	})
end

function MsgHandler.pvp_sa_enter(arg_5_0)
	PvpSA:startBattle(arg_5_0)
end

function ErrHandler.pvp_sa_enter(arg_6_0, arg_6_1, arg_6_2)
	SceneManager:popScene()
	
	local var_6_0
	
	if arg_6_1 == "pvp_sa_rest_time" then
		var_6_0 = T("pvp_sa_lobby.pvp_sa_rest_time")
	else
		var_6_0 = T(arg_6_0 .. "." .. arg_6_1)
	end
	
	Dialog:msgBox(var_6_0)
end

function MsgHandler.pvp_npc_enter(arg_7_0)
	PvpSA:startBattle(arg_7_0)
end

function ErrHandler.pvp_npc_enter(arg_8_0, arg_8_1, arg_8_2)
	SceneManager:popScene()
	
	local var_8_0
	
	if arg_8_1 == "pvp_sa_rest_time" then
		var_8_0 = T("pvp_sa_lobby.pvp_sa_rest_time")
	else
		var_8_0 = T(arg_8_0 .. "." .. arg_8_1)
	end
	
	Dialog:msgBox(var_8_0)
end

function MsgHandler.pvp_sa_clear(arg_9_0)
	PvpSA:battleClear(arg_9_0)
end

function MsgHandler.pvp_npc_clear(arg_10_0)
	PvpNPC:battleClear(arg_10_0)
end

function MsgHandler.pvp_sa_total_ranking(arg_11_0)
	PvpSATL:update(arg_11_0)
end

function MsgHandler.pvp_sa_last_week_ranking(arg_12_0)
	PvpSALW:update(arg_12_0)
end

function MsgHandler.pvp_sa_season_ranking(arg_13_0)
	PvpSASL:update(arg_13_0)
end

function MsgHandler.pvp_sa_my_ranking(arg_14_0)
	PvpSAMyRanking:update(arg_14_0)
end

function MsgHandler.pvp_hall_of_fame(arg_15_0)
	PvpSAHOF:update(arg_15_0)
	ConditionContentsManager:dispatch("pvp.fame", {
		seasons = arg_15_0.hall_of_fame
	})
end

function MsgHandler.pvp_sa_battle_log(arg_16_0)
	PvpSABattleLog:update(arg_16_0)
end

function MsgHandler.pvp_story(arg_17_0)
	if arg_17_0.story_id then
		AccountData.last_pvp_story = arg_17_0.story_id
	end
	
	if SceneManager:getCurrentSceneName() == "pvp" then
		PvpSA:open()
	end
end

function MsgHandler.pvp_sa_record_history(arg_18_0)
	PvpSARecordInfo:update(arg_18_0)
end

function MsgHandler.pvp_sa_revenge_ready(arg_19_0)
	PvpSA:pvpRevengeReady(arg_19_0)
end

function pvp_sa_rest_time_func(arg_20_0, arg_20_1, arg_20_2)
	Dialog:msgBox(T("pvp_sa_lobby." .. arg_20_1), {
		handler = function()
			if SceneManager:getCurrentSceneName() ~= "lobby" then
				SceneManager:nextScene("lobby")
			end
		end
	})
end

function MsgHandler.pvp_sa_exchange_weekly_reward(arg_22_0)
	if arg_22_0 and arg_22_0.rewards then
		Account:addReward(arg_22_0.rewards, {
			single = true
		})
		TopBarNew:topbarUpdate(true)
	end
end

ErrHandler.pvp_sa_lobby = pvp_sa_rest_time_func
ErrHandler.pvp_sa_vs_refresh = pvp_sa_rest_time_func
ErrHandler.pvp_sa_league_ranking = pvp_sa_rest_time_func
ErrHandler.pvp_sa_total_ranking = pvp_sa_rest_time_func
ErrHandler.pvp_sa_battle_log = pvp_sa_rest_time_func
ErrHandler.pvp_sa_clear = pvp_sa_rest_time_func
ErrHandler.pvp_sa_record_history = pvp_sa_rest_time_func
ErrHandler.pvp_sa_revenge_ready = pvp_sa_rest_time_func
ErrHandler.pvp_hall_of_fame = pvp_sa_rest_time_func
ErrHandler.pvp_sa_my_ranking = pvp_sa_rest_time_func
ErrHandler.pvp_sa_season_ranking = pvp_sa_rest_time_func
ErrHandler.pvp_sa_last_week_ranking = pvp_sa_rest_time_func
ErrHandler.pvp_sa_last_season_ranking = pvp_sa_rest_time_func

function HANDLER.pvp_base(arg_23_0, arg_23_1)
	if arg_23_1 == "btn_go" then
		PvpSA:queryRefreshVSList()
	elseif arg_23_1 == "btn_formation" then
		PvpSA:defTeamSetup()
	elseif arg_23_1 == "btn_reward" then
		PvpSA:showArenaInfoPopup()
	elseif arg_23_1 == "btn_tab_1" then
		PvpSA:rightMenu("main")
	elseif arg_23_1 == "btn_tab_2" then
		PvpSA:rightMenu("hall_of_fame")
	elseif arg_23_1 == "btn_tab_3" then
		PvpSA:rightMenu("ranking")
	elseif arg_23_1 == "btn_tab_4" then
		PvpSA:rightMenu("battle_log")
	elseif arg_23_1 == "btn_tab_5" then
		PvpSA:rightMenu("npc_match")
	elseif arg_23_1 == "btn_tab_6" then
		PvpSA:rightMenu("arena_story")
	elseif arg_23_1 == "btn_normal" then
		PvpNPC:selectDifficulty(1)
	elseif arg_23_1 == "btn_hard" then
		PvpNPC:selectDifficulty(2)
	elseif arg_23_1 == "btn_hell" then
		PvpNPC:selectDifficulty(3)
	elseif arg_23_1 == "btn_pvp_select" or arg_23_1 == "btn_pvp_retry" then
		if PvpSA:getCurrentMenu() == "npc_match" then
			PvpNPC:select({
				item = arg_23_0.item
			})
		end
	elseif arg_23_1 == "btn_more" then
		arg_23_0.parent:nextPage()
	elseif arg_23_1 == "btn_view_story" or arg_23_1 == "btn_again_story" then
		if PvpSA:getCurrentMenu() == "arena_story" then
			PvpSAArenaStory:select({
				item = arg_23_0.item
			})
		end
	elseif arg_23_1 == "btn_movie" then
		if arg_23_0.link then
			movetoPath(arg_23_0.link)
		end
	elseif arg_23_1 == "btn_revenge" then
		PvpSABattleLog:revenge(arg_23_0.revenge_id)
	elseif arg_23_1 == "btn_ranking_category_season" then
		PvpSASL:show()
	elseif arg_23_1 == "btn_ranking_category_total" then
		PvpSATL:show()
	elseif arg_23_1 == "btn_ranking_category_lastweek" then
		PvpSALW:show()
	elseif arg_23_1 == "btn_my_ranking" then
		PvpSAMyRanking:show("season")
	elseif arg_23_1 == "btn_blind_info" then
		PvpSA:updateMainBlindUI()
	end
end

function HANDLER.pvp_reward(arg_24_0, arg_24_1)
	if arg_24_1 == "btn_close" then
	end
end

function HANDLER.pvp_bar(arg_25_0, arg_25_1)
	local var_25_0 = getParentWindow(arg_25_0)
	
	if PvpSA:getCurrentMenu() == "main" then
		PvpSAVS:select({
			item = var_25_0.item
		})
	end
end

function HANDLER.pvp_season_change2(arg_26_0, arg_26_1)
	if arg_26_1 == "btn_ok" then
		PvpSA:closePopupSeasonChange2()
	else
		return "dont_close"
	end
end

function HANDLER.pvp_season_reward_choose(arg_27_0, arg_27_1)
	return "dont_close"
end

local function var_0_0(arg_28_0)
	if UnitTeam.vars then
		local var_28_0 = 0
		
		for iter_28_0, iter_28_1 in pairs(arg_28_0) do
			var_28_0 = var_28_0 + UNIT:create({
				code = iter_28_1.unit.code,
				g = iter_28_1.unit.g,
				exp = iter_28_1.unit.exp
			}):getPoint()
		end
		
		UnitTeam.vars.enemy_point = var_28_0
	end
end

function PvpSA.getLeagueList(arg_29_0)
	if arg_29_0.LEAGUE_LIST then
		return arg_29_0.LEAGUE_LIST
	end
	
	arg_29_0.LEAGUE_LIST = {}
	
	local var_29_0 = {
		"legend",
		"champion",
		"challenger",
		"master",
		"gold",
		"silver",
		"bronze"
	}
	local var_29_1 = 0
	
	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		for iter_29_2 = 1, 10 do
			local var_29_2 = DB("pvp_sa", iter_29_1 .. "_" .. iter_29_2, "id")
			
			if var_29_2 then
				var_29_1 = var_29_1 + 1
				arg_29_0.LEAGUE_LIST[var_29_2] = var_29_1
				arg_29_0.LEAGUE_LIST[var_29_1] = var_29_2
			end
		end
	end
	
	return arg_29_0.LEAGUE_LIST
end

function PvpSA.defTeamSetup(arg_30_0)
	SceneManager:nextScene("pvp_team", {
		mode = "defend_mode"
	})
end

function PvpSA.startBattle(arg_31_0, arg_31_1)
	if arg_31_1.update_currency then
		Singular:event("join_arena")
		Account:updateCurrencies(arg_31_1.update_currency)
	end
	
	UnitMain:endPVPMode()
	
	if PLATFORM == "win32" then
		SAVE:set("game.started_battle_data", {
			map = arg_31_1.battle.map,
			team = arg_31_1.my_team,
			started_data = {
				mode = "pvp"
			}
		})
	end
	
	local var_31_0 = BattleLogic:makeLogic(arg_31_1.battle.map, arg_31_1.my_team, {
		mode = "pvp"
	})
	
	var_31_0.enemy_uid = arg_31_1.enemy_uid
	
	local var_31_1 = string.split(arg_31_1.enemy_uid, ":")
	
	if var_31_1[1] == "sa" then
		if arg_31_0:isCurrentBlind() then
			var_31_0.enemy_name = T("pvp_blind_name")
		else
			var_31_0.enemy_name = arg_31_1.enemy_info.name
			var_31_0.enemy_clan = arg_31_1.enemy_info.clan
		end
	elseif var_31_1[1] == "npc" then
		local var_31_2 = DB("pvp_npcbattle", var_31_1[3], "name")
		
		var_31_0.enemy_name = T(var_31_2)
	end
	
	StoryLogger:destroyWithViewer()
	PreLoad:beforeEnterBattle(var_31_0)
	SceneManager:nextScene("battle", {
		logic = var_31_0
	})
end

function PvpSA.showArenaInfoPopup(arg_32_0)
	local var_32_0 = load_dlg("pvp_reward", true, "wnd", function()
		Dialog:closeAll()
		BackButtonManager:pop("pvp_reward")
	end)
	
	PvpSAArenaInfo:show(var_32_0, arg_32_0.vars.lobby_info)
	Dialog:msgBox(nil, {
		no_back_button = true,
		dlg = var_32_0,
		handler = function(arg_34_0, arg_34_1)
			if arg_34_1 == "btn_close" then
				Analytics:closePopup()
				
				return 
			elseif arg_34_1 == "btn_category_myinfo" then
				PvpSAArenaInfo:show(var_32_0, arg_32_0.vars.lobby_info)
			elseif arg_34_1 == "btn_category_myinfo" then
				PvpSAArenaInfo:show(var_32_0, arg_32_0.vars.lobby_info)
			elseif arg_34_1 == "btn_category_league" then
				PvpSAReward:show(var_32_0)
			elseif arg_34_1 == "btn_category_record" or arg_34_1 == "btn_record" then
				PvpSARecordInfo:show(var_32_0)
			end
			
			return "dont_close"
		end
	})
	Analytics:setPopup("pvp_reward")
end

function PvpSA.queryRefreshVSList(arg_35_0)
	local var_35_0 = arg_35_0.vars.lobby_info.refresh_day_limit or 30
	local var_35_1 = arg_35_0.vars.lobby_info.info.vs_refresh_day_count or 0
	local var_35_2 = load_dlg("pvp_refresh", true, "wnd")
	local var_35_3 = arg_35_0.vars.lobby_info.match_interval_sec - (os.time() - arg_35_0.vars.lobby_info.info.vs_refresh_time)
	
	if var_35_3 > 0 then
		if var_35_0 <= var_35_1 then
			balloon_message_with_sound("pvp_refresh_end_desc")
			
			return 
		end
		
		if_set_visible(var_35_2, "n_normal", false)
		if_set_visible(var_35_2, "n_limit", true)
		
		local var_35_4 = var_35_2:getChildByName("n_limit")
		local var_35_5 = math.max(var_35_0 - var_35_1, 0)
		
		if_set(var_35_4, "txt_limit", T("pvp_refresh_remain", {
			current = var_35_5,
			max = var_35_0
		}))
		ShopCommon:UpdatePayIcon(var_35_2:getChildByName("btn_buy"), {
			token = "to_gold",
			price = arg_35_0.vars.lobby_info.match_refresh.price
		})
	else
		if_set_visible(var_35_2, "n_normal", true)
		if_set_visible(var_35_2, "n_limit", false)
		ShopCommon:UpdatePayIcon(var_35_2:getChildByName("btn_buy"), {
			price = 0,
			token = "to_gold"
		})
	end
	
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_35_2,
		handler = function(arg_36_0, arg_36_1)
			if arg_36_1 == "btn_close" then
				return 
			elseif arg_36_1 == "btn_buy" then
				if var_35_3 > 0 then
					if UIUtil:checkCurrencyDialog("to_gold", arg_35_0.vars.lobby_info.match_refresh.price) then
						query("pvp_sa_vs_refresh")
					end
				else
					query("pvp_sa_vs_refresh", {
						cf = 1
					})
				end
				
				return 
			end
			
			return "dont_close"
		end
	})
end

function PvpSA.pvpReady(arg_37_0, arg_37_1)
	arg_37_0.vars.pvp_team_layer = cc.Layer:create()
	
	arg_37_0.vars.parent:addChildLast(arg_37_0.vars.pvp_team_layer)
	
	local var_37_0
	
	if arg_37_1.item.slot and arg_37_1.item.enemy_info.cv then
		var_37_0 = string.format("sa:%d:%s", arg_37_1.item.slot, arg_37_1.item.enemy_info.cv)
	elseif arg_37_1.item.enemy_info.npc_id then
		var_37_0 = string.format("npc:%d:%s", arg_37_1.item.enemy_info.difficulty, arg_37_1.item.enemy_info.npc_id)
	end
	
	PvpSATeam:show({
		mode = "pvp_ready",
		my_info = {
			battle_count = arg_37_0.vars.lobby_info.info.battle_count,
			score = arg_37_0.vars.lobby_info.info.score,
			league = arg_37_0.vars.lobby_info.info.league,
			repeat_reward_period = arg_37_0.vars.lobby_info.repeat_reward_period,
			repeat_reward_type_max = arg_37_0.vars.lobby_info.repeat_reward_type_max,
			continuous_victory = arg_37_0.vars.lobby_info.info.continuous_victory
		},
		enemy_uid = var_37_0,
		enemy_score = arg_37_1.item.score,
		enemy_info = arg_37_1.item.enemy_info
	}, {
		parent = arg_37_0.vars.pvp_team_layer,
		hide_layer = arg_37_0.vars.base_wnd
	})
end

function PvpSA.pvpRevengeReady(arg_38_0, arg_38_1)
	if arg_38_1 then
		arg_38_0.vars.pvp_team_layer = cc.Layer:create()
		
		arg_38_0.vars.parent:addChildLast(arg_38_0.vars.pvp_team_layer)
		
		local var_38_0 = string.format("sa:%d:%s", "-1", arg_38_1.revenge_id)
		
		PvpSATeam:show({
			mode = "pvp_ready",
			my_info = {
				battle_count = arg_38_0.vars.lobby_info.info.battle_count,
				score = arg_38_0.vars.lobby_info.info.score,
				league = arg_38_0.vars.lobby_info.info.league,
				repeat_reward_period = arg_38_0.vars.lobby_info.repeat_reward_period,
				repeat_reward_type_max = arg_38_0.vars.lobby_info.repeat_reward_type_max
			},
			revenge_id = arg_38_1.revenge_id,
			revenge_count = arg_38_1.revenge_count,
			enemy_uid = var_38_0,
			enemy_score = arg_38_1.revenge_info.score,
			enemy_info = arg_38_1.revenge_info.enemy_info
		}, {
			parent = arg_38_0.vars.pvp_team_layer,
			hide_layer = arg_38_0.vars.base_wnd
		})
	end
end

function PvpSA.checkTeam(arg_39_0, arg_39_1)
	if Account:getTeamMemberCount(arg_39_1, true) < 4 then
		return false, "pvp_team_warning2"
	end
	
	local var_39_0 = Account:getTeam(arg_39_1)
	local var_39_1 = 0
	local var_39_2 = math.huge
	local var_39_3 = false
	local var_39_4 = {}
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if iter_39_1.is_unit then
			if iter_39_1:isPromotionUnit() then
				return false, "pvp_team_warning1"
			end
			
			if not iter_39_1:isSummon() then
				local var_39_5 = iter_39_1:getLv()
				
				if iter_39_1:isGrowthBoostRegistered() then
					var_39_5 = iter_39_1:getGrowthBoostLv()
				end
				
				if var_39_1 < var_39_5 then
					var_39_1 = var_39_5
				end
				
				if var_39_5 < var_39_2 then
					var_39_2 = var_39_5
				end
				
				if iter_39_1.getEquipByIndex then
					for iter_39_2 = 1, 7 do
						if not iter_39_1:getEquipByIndex(iter_39_2) then
							table.insert(var_39_4, iter_39_1)
							
							var_39_3 = true
							
							break
						end
					end
				end
			end
		end
	end
	
	if var_39_2 < var_39_1 * 0.7 then
		return false, "pvp_team_warning3"
	end
	
	if var_39_3 and not table.empty(var_39_4) then
		return false, "pvp_team_warning4", var_39_4
	end
	
	return true
end

function PvpSA.startPVP(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	if Account:hasTeamSameCodeUnit() then
		balloon_message_with_sound("already_in_team")
		
		return 
	end
	
	if Account:getTeamMemberCount(arg_40_2, true) < 1 then
		balloon_message_with_sound("no_unit")
		
		return 
	end
	
	if not arg_40_3 and not arg_40_4 then
		local var_40_0, var_40_1, var_40_2 = arg_40_0:checkTeam(arg_40_2)
		
		if not var_40_0 then
			if var_40_2 and not table.empty(var_40_2) then
				Dialog:openDailySkipPopup("PvpSA.unequip_stop_watching", {
					info = "expedition_daily_stop_desc",
					title = "pvp_unequip_character_desc",
					csd = "pvp_unequipped_hero",
					desc = var_40_1 or "pvp_team_warning",
					arg = var_40_2,
					func = function()
						arg_40_0:startPVP(arg_40_1, arg_40_2, true, true)
					end
				})
			else
				local var_40_3
				
				if var_40_1 then
					var_40_3 = var_40_1 .. "_title"
				else
					var_40_3 = "caution_battlepower_title"
				end
				
				Dialog:openDailySkipPopup(var_40_1 .. ".stop_watching", {
					info = "expedition_daily_stop_desc",
					title = var_40_3,
					desc = var_40_1 or "pvp_team_warning",
					func = function()
						arg_40_0:startPVP(arg_40_1, arg_40_2, true, true)
					end
				})
			end
			
			return 
		end
	end
	
	if not arg_40_3 then
		UnitTeam:playPvPReadyAnimation()
		UIAction:Add(SEQ(DELAY(800), CALL(PvpSA.startPVP, arg_40_0, arg_40_1, arg_40_2, true, true)), arg_40_0, "block")
		
		return 
	end
	
	BattleRepeat:disableRepeatBattleCount()
	
	if Account:getCurrency("pvpkey") < 1 then
		UIUtil:wannaBuyPvpkey("pvp.ready")
		
		return 
	end
	
	UnitTeam:updatePvpKey()
	Account:saveLocalTeamIndex("pvp001", arg_40_2)
	
	local var_40_4 = Account:saveTeamInfo(true)
	
	arg_40_0.entered_team_idx = arg_40_2
	
	local var_40_5 = {
		point = 0,
		team_idx = arg_40_2,
		team = {}
	}
	local var_40_6 = Account:getTeam(arg_40_2)
	local var_40_7 = 0
	
	if var_40_6 then
		for iter_40_0 = 1, 7 do
			if var_40_6[iter_40_0] then
				if var_40_6[iter_40_0]:getUnitType() == "unit" then
					var_40_7 = var_40_7 + 1
				end
				
				var_40_5.point = var_40_5.point + var_40_6[iter_40_0]:getPoint()
				var_40_5.team[iter_40_0] = var_40_6[iter_40_0].inst.uid
			end
		end
	end
	
	if var_40_7 == 0 then
		balloon_message_with_sound("no_unit")
		
		return 
	end
	
	UnitMain:disableUnitList()
	
	local var_40_8 = "pvp00100"
	
	PreLoad:beforeReqBattle(var_40_8)
	TransitionScreen:show({
		on_show_before = function(arg_43_0)
			SoundEngine:play("event:/ui/pvp/door_close")
			
			return EffectManager:Play({
				fn = "pvp_gate_close.cfx",
				pivot_z = 99998,
				layer = arg_43_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_hide_before = function(arg_44_0)
			arg_44_0:removeAllChildren()
			SoundEngine:play("event:/ui/pvp/door_open")
			
			return EffectManager:Play({
				fn = "pvp_gate_open.cfx",
				pivot_z = 99998,
				layer = arg_44_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_show = function()
			local var_45_0 = string.split(arg_40_1, ":")[1]
			local var_45_1 = BattleUtil:getPlayingEpisode() or {}
			
			if var_45_0 == "sa" then
				query("pvp_sa_enter", {
					enemy_uid = arg_40_1,
					team_info = json.encode(var_40_5),
					update_team_info = var_40_4,
					episode_log = json.encode(var_45_1)
				})
			elseif var_45_0 == "npc" then
				query("pvp_npc_enter", {
					enemy_uid = arg_40_1,
					team_info = json.encode(var_40_5),
					update_team_info = var_40_4,
					episode_log = json.encode(var_45_1)
				})
			end
		end
	})
end

function PvpSA.enteredTeamIndex(arg_46_0)
	return arg_46_0.entered_team_idx
end

function PvpSA.getCurrentMenu(arg_47_0)
	if not arg_47_0.vars then
		return nil
	end
	
	return arg_47_0.vars.current_menu
end

function PvpSA.getLobbyInfo(arg_48_0)
	return arg_48_0.vars.lobby_info
end

function PvpSA.getSeasonInfo(arg_49_0)
	return arg_49_0.vars.lobby_info.pvp_season_info
end

function PvpSA.rightMenu(arg_50_0, arg_50_1)
	if arg_50_0.vars.current_menu == arg_50_1 then
		return 
	end
	
	Analytics:toggleTab(arg_50_1)
	
	arg_50_0.vars.current_menu = arg_50_1
	arg_50_0.last_mode = arg_50_1
	
	local var_50_0 = {
		"main",
		"hall_of_fame",
		"ranking",
		"battle_log",
		"npc_match",
		"arena_story"
	}
	
	for iter_50_0 = 1, 6 do
		local var_50_1 = arg_50_0.vars.base_wnd:getChildByName("btn_tab_" .. iter_50_0)
		local var_50_2 = arg_50_0.vars.base_wnd:getChildByName("CENTER_" .. iter_50_0)
		
		if arg_50_0.vars.current_menu == var_50_0[iter_50_0] then
			var_50_1:getChildByName("bg"):setVisible(true)
			var_50_1:getChildByName("desc"):setColor(cc.c3b(255, 120, 0))
			var_50_2:setVisible(true)
		else
			var_50_1:getChildByName("bg"):setVisible(false)
			var_50_1:getChildByName("desc"):setColor(cc.c3b(191, 191, 191))
			var_50_2:setVisible(false)
		end
		
		if iter_50_0 == 5 then
			local var_50_3 = PvpNPC:matchableCount()
			local var_50_4 = var_50_1:getChildByName("cm_icon_npc_match")
			
			if var_50_3 > 0 then
				var_50_4:setVisible(true)
				if_set(var_50_4, "label_count", var_50_3)
			else
				var_50_4:setVisible(false)
			end
		end
		
		if iter_50_0 == 6 then
			if_set_visible(var_50_1, "icon_noti", false)
		end
	end
	
	if arg_50_0.vars.current_menu == "main" then
		arg_50_0:modeVSlist()
	elseif arg_50_0.vars.current_menu == "hall_of_fame" then
		PvpSAHOF:show(arg_50_0.vars.base_wnd:getChildByName("CENTER_2"))
	elseif arg_50_0.vars.current_menu == "ranking" then
		PvpSASL:show()
	elseif arg_50_0.vars.current_menu == "npc_match" then
		if #Account:getAllNPC() > 1 then
			arg_50_0:modeNPClist()
		else
			balloon_message_with_sound("game_connect_error")
		end
	elseif arg_50_0.vars.current_menu == "battle_log" then
		PvpSABattleLog:show(arg_50_0.vars.base_wnd:getChildByName("CENTER_4"))
	elseif arg_50_0.vars.current_menu == "arena_story" then
		PvpSAArenaStory:show(arg_50_0.vars.base_wnd:getChildByName("CENTER_6"))
	end
end

function PvpSA.getBaseWnd(arg_51_0)
	return arg_51_0.vars.base_wnd
end

function PvpSA.open(arg_52_0, arg_52_1)
	local var_52_0
	local var_52_1
	local var_52_2
	local var_52_3
	local var_52_4
	
	if TutorialGuide:isPlayingTutorial() == false and arg_52_1 and arg_52_1.pvp_season_info then
		local var_52_5 = arg_52_1.pvp_season_info
		
		if var_52_5 then
			local var_52_6 = var_52_5.season_period_db
			
			if var_52_6 and var_52_6.story_data and var_52_6.story_data.story_id then
				PvpSAArenaStory:buildStoryData()
				
				local var_52_7, var_52_8 = PvpSAArenaStory:getFirstNotViewedStory(var_52_6.story_data.story_id)
				
				if var_52_7 and var_52_8 then
					if arg_52_1.res == "ok" then
						arg_52_0.cached_info = arg_52_1
					else
						arg_52_0.cached_info = nil
					end
					
					start_new_story(nil, var_52_8, {
						force = true,
						on_finish = function()
							query("pvp_story", {
								story_id = var_52_6.story_db
							})
						end
					})
					
					return 
				end
			end
		end
	end
	
	if arg_52_1 and arg_52_1.res then
		var_52_0 = arg_52_1.season_change_info
		arg_52_1.season_change_info = nil
		var_52_1 = arg_52_1.update_currency
		arg_52_1.update_currency = nil
		var_52_2 = arg_52_1.league_changed
		arg_52_1.league_changed = nil
		var_52_3 = arg_52_1.all_clear_reward
		arg_52_1.all_clear_reward = nil
		var_52_4 = arg_52_1.last_weekly_league_reward
		arg_52_1.last_weekly_league_reward = nil
		
		if arg_52_1.res == "ok" then
			arg_52_0.cached_info = arg_52_1
		else
			arg_52_0.cached_info = nil
		end
	else
		if arg_52_0.cached_info then
			var_52_0 = arg_52_0.cached_info.season_change_info
			arg_52_0.cached_info.season_change_info = nil
			var_52_1 = arg_52_0.cached_info.update_currency
			arg_52_0.cached_info.update_currency = nil
			var_52_2 = arg_52_0.cached_info.league_changed
			arg_52_0.cached_info.league_changed = nil
			var_52_3 = arg_52_0.cached_info.all_clear_reward
			arg_52_0.cached_info.all_clear_reward = nil
			var_52_4 = arg_52_0.cached_info.last_weekly_league_reward
			arg_52_0.cached_info.last_weekly_league_reward = nil
		end
		
		arg_52_1 = arg_52_0.cached_info
	end
	
	PvpSARecordInfo.record_history = nil
	
	if TutorialGuide:isPlayingTutorial() then
		var_52_0 = nil
		var_52_1 = nil
		var_52_2 = nil
		var_52_3 = nil
		var_52_4 = nil
	end
	
	PvpSA:show(arg_52_1, {
		season_change_info = var_52_0,
		update_currency = var_52_1,
		league_changed = var_52_2,
		all_clear_reward = var_52_3,
		last_weekly_league_reward = var_52_4
	})
end

function PvpSA.setRankingCategory(arg_54_0, arg_54_1)
	if arg_54_0.vars then
		arg_54_0.vars.ranking_category = arg_54_1
	end
end

function PvpSA.getRankingCategory(arg_55_0)
	if arg_55_0.vars then
		return arg_55_0.vars.ranking_category
	end
	
	return "season"
end

function PvpSA._test_set_blind(arg_56_0, arg_56_1)
	arg_56_0._test_blind_set = arg_56_1
end

function PvpSA.isBlindDay(arg_57_0)
	if not AccountData.pvp_info or not AccountData.pvp_info.season_end_time then
		return false
	end
	
	return Account:serverTimeDayLocalDetail(AccountData.pvp_info.season_end_time) == Account:serverTimeDayLocalDetail() or arg_57_0._test_blind_set
end

function PvpSA.isBlindUser(arg_58_0)
	if not AccountData.pvp_info or not AccountData.pvp_info.league then
		return false
	end
	
	local var_58_0 = PvpSA:getLeagueList()
	
	if to_n(var_58_0[AccountData.pvp_info.league]) <= to_n(var_58_0.champion_5) or arg_58_0._test_blind_set then
		return true
	end
	
	return false
end

function PvpSA.isCurrentBlind(arg_59_0)
	if not arg_59_0.vars then
		return false
	end
	
	return arg_59_0.vars.blind_day_current
end

function PvpSA.isEnterBlind(arg_60_0)
	if not arg_60_0.vars then
		return false
	end
	
	return arg_60_0.vars.blind_day_enter
end

function PvpSA.show(arg_61_0, arg_61_1, arg_61_2)
	if not arg_61_1 then
		query("pvp_sa_lobby")
		
		return 
	end
	
	arg_61_2 = arg_61_2 or {}
	arg_61_0.vars = {}
	arg_61_0.vars.opts = arg_61_2 or {}
	arg_61_0.vars.lobby_info = arg_61_1
	arg_61_0.vars.ranking_category = "season"
	
	ConditionContentsManager:dispatch("pvp.league")
	Account:addReward(arg_61_2.update_currency)
	
	if arg_61_0.vars.lobby_info and arg_61_0.vars.lobby_info.info then
		Account:updatePvpInfo({
			season_id = arg_61_0.vars.lobby_info.pvp_season_info.season_id,
			season_start_time = arg_61_0.vars.lobby_info.pvp_season_info.season_start_time,
			season_end_time = arg_61_0.vars.lobby_info.pvp_season_info.season_end_time,
			next_season_start_time = arg_61_0.vars.lobby_info.pvp_season_info.next_season_start_time,
			score = arg_61_0.vars.lobby_info.info.score or 0,
			league = arg_61_0.vars.lobby_info.info.league
		})
	end
	
	arg_61_0.vars.parent = arg_61_0.vars.opts.parent or SceneManager:getDefaultLayer()
	arg_61_0.vars.base_wnd = load_dlg("pvp_base", true, "wnd")
	
	arg_61_0.vars.parent:addChild(arg_61_0.vars.base_wnd)
	
	arg_61_0.vars.blind_day_current = arg_61_0:isBlindUser()
	arg_61_0.vars.blind_day_enter = arg_61_0:isBlindUser()
	
	local var_61_0 = {
		"crystal",
		"gold",
		"pvpgold",
		"pvpkey"
	}
	
	if AccountData.season_period_db and AccountData.season_period_db.season_reward_id then
		table.push(var_61_0, string.sub(AccountData.season_period_db.season_reward_id, 4, -1))
	end
	
	TopBarNew:create(T("arena"), arg_61_0.vars.parent, nil, var_61_0, nil, "infoaren")
	PvpSAVS:clear()
	PvpSATL:clear()
	PvpSALW:clear()
	PvpSASL:clear()
	PvpSAMyRanking:clear()
	PvpSAHOF:clear()
	PvpNPC:clear()
	PvpSABattleLog:clear()
	PvpSAArenaStory:clear()
	
	arg_61_2.mode = arg_61_2.mode or arg_61_0.last_mode or "main"
	
	arg_61_0:rightMenu(arg_61_2.mode)
	Action:Add(SEQ(DELAY(2000), CALL(arg_61_0.startAutoUpdate, arg_61_0)), arg_61_0.vars.base_wnd)
	
	if arg_61_1.res == "ok" then
		if not TutorialGuide:isPlayingTutorial("system_008") then
			TutorialGuide:forceClearTutorials({
				"system_008"
			})
		end
		
		local var_61_1 = arg_61_0.vars.lobby_info.info
		local var_61_2 = arg_61_0.vars.lobby_info.pvp_season_info
		local var_61_3 = {}
		
		if var_61_2 then
			var_61_3 = var_61_2.season_period_db
		end
		
		local var_61_4 = var_61_1.league
		local var_61_5, var_61_6, var_61_7 = DB("pvp_sa", var_61_4, {
			"name",
			"emblem",
			"name_league"
		})
		
		if_set(arg_61_0.vars.base_wnd, "txt_season_title", T(var_61_3.name))
		if_set(arg_61_0.vars.base_wnd, "txt_rank", T(var_61_5))
		if_set(arg_61_0.vars.base_wnd, "txt_score", T("pvp_point", {
			point = comma_value(var_61_1.score or 0)
		}))
		if_set(arg_61_0.vars.base_wnd, "txt_count_win", T("pvp_win_count", {
			count = comma_value(var_61_1.win_count or 0)
		}))
		if_set(arg_61_0.vars.base_wnd, "txt_count_conti_win", T("pvp_win_rapid", {
			count = comma_value(var_61_1.continuous_victory or 0)
		}))
		if_set(arg_61_0.vars.base_wnd, "txt_total_rank", T("pvp_my_rank", {
			rank = arg_61_0.vars.lobby_info.league_rank
		}))
		if_set(arg_61_0.vars.base_wnd, "txt_league_rank", T("pvp_league", {
			name = T(var_61_7)
		}))
		
		local var_61_8 = arg_61_0.vars.base_wnd:getChildByName("n_percent")
		
		if var_61_8 then
			local var_61_9 = to_n(var_61_1.pvp_count)
			
			if var_61_9 > 0 then
				if_set(var_61_8, "t_att_per", string.format("%.1f", to_n(var_61_1.win_count) / var_61_9 * 100) .. "%")
			else
				if_set(var_61_8, "t_att_per", "0.0%")
			end
			
			local var_61_10 = to_n(var_61_1.def_count)
			
			if var_61_10 > 0 then
				if_set(var_61_8, "t_def_per", string.format("%.1f", to_n(var_61_1.def_win_count) / var_61_10 * 100) .. "%")
			else
				if_set(var_61_8, "t_def_per", "0.0%")
			end
		end
		
		if string.len(var_61_4) > 0 then
			SAVE:setUserDefaultData("pvp_arena_league", var_61_4)
		end
		
		local var_61_11 = arg_61_0.vars.base_wnd:getChildByName("n_repeat_reward")
		
		if var_61_11 then
			local var_61_12 = math.floor(var_61_1.battle_count / arg_61_0.vars.lobby_info.repeat_reward_period) % arg_61_0.vars.lobby_info.repeat_reward_type_max + 1
			local var_61_13, var_61_14 = DB("pvp_sa", var_61_1.league, {
				"repeat_reward_id" .. var_61_12,
				"repeat_reward_count" .. var_61_12
			})
			
			UIUtil:getRewardIcon(var_61_14, var_61_13, {
				scale = 1,
				detail = false,
				parent = var_61_11:getChildByName("n_reward_item")
			})
			
			local var_61_15 = var_61_1.battle_count % arg_61_0.vars.lobby_info.repeat_reward_period
			
			if_set(var_61_11, "t_percent", var_61_15 .. "/" .. arg_61_0.vars.lobby_info.repeat_reward_period)
			var_61_11:getChildByName("progress_bar"):setPercent(100 * var_61_15 / arg_61_0.vars.lobby_info.repeat_reward_period)
		end
		
		SpriteCache:resetSprite(arg_61_0.vars.base_wnd:getChildByName("icon_league"), "emblem/" .. var_61_6 .. ".png")
		
		local var_61_16 = os.time()
		local var_61_17 = to_n(var_61_3.end_time_view) - var_61_16
		local var_61_18 = arg_61_0.vars.base_wnd:getChildByName("txt_season_title")
		
		if var_61_3 and var_61_17 / 86400 < to_n(var_61_3.end_term) then
			var_61_18:setPositionY(624)
			if_set(arg_61_0.vars.base_wnd, "txt_season_remaining", T("pvp_season_off", timeToStringDef({
				preceding_with_zeros = true,
				time = var_61_3.end_time_view
			})))
			if_set_visible(arg_61_0.vars.base_wnd, "txt_season_remaining", true)
		else
			var_61_18:setPositionY(608)
			if_set_visible(arg_61_0.vars.base_wnd, "txt_season_remaining", false)
		end
		
		if arg_61_0:isCurrentBlind() then
			if_set_visible(arg_61_0.vars.base_wnd, "n_blind", true)
			arg_61_0:updateMainBlindUI()
		else
			if_set_visible(arg_61_0.vars.base_wnd, "n_blind", false)
		end
		
		PvpSA:popupLobby(var_61_4, arg_61_2)
	else
		if_set(arg_61_0.vars.base_wnd, "txt_season_title", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_rank", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_score", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_count_win", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_count_conti_win", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_total_rank", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_league_rank", "-")
		
		local var_61_19 = arg_61_0.vars.base_wnd:getChildByName("n_percent")
		
		if_set(var_61_19, "t_att_per", "-")
		if_set(var_61_19, "t_def_per", "-")
		if_set(arg_61_0.vars.base_wnd, "txt_season_remaining", "--:--")
		SpriteCache:resetSprite(arg_61_0.vars.base_wnd:getChildByName("icon_league"), "emblem/icon_pvp_sa_league_bronze.png")
		
		local var_61_20 = arg_61_0.vars.base_wnd:getChildByName("btn_formation")
		
		if_set_visible(var_61_20, "n_face", false)
		
		arg_61_0.vars.current_menu = nil
		arg_61_0.cached_info = nil
		
		local function var_61_21()
			if arg_61_0.vars and arg_61_0.vars.lobby_info and arg_61_0.vars.lobby_info.res == "ok" then
				return 
			end
			
			if SceneManager:getCurrentSceneName() == "pvp_team" then
				return 
			end
			
			Dialog:msgBox(T("pvp_tutorial"), {
				handler = function()
					SceneManager:nextScene("pvp_team", {
						mode = "defend_mode"
					})
				end
			})
		end
		
		TutorialGuide:ifStartGuide("system_008")
		
		if TutorialGuide:isPlayingTutorial() then
			TutorialGuide:setOnFinish(var_61_21)
		else
			var_61_21()
		end
	end
end

function PvpSA.updateMainBlindUI(arg_64_0)
	if not arg_64_0.vars or not get_cocos_refid(arg_64_0.vars.base_wnd) then
		return 
	end
	
	local var_64_0 = arg_64_0.vars.base_wnd:getChildByName("n_blind")
	local var_64_1 = var_64_0:getChildByName("n_blind_info")
	
	if var_64_1:isVisible() then
		return 
	end
	
	if_set_visible(arg_64_0.vars.base_wnd, "n_blind", true)
	if_set_visible(var_64_0, "btn_blind_info", true)
	if_set_visible(var_64_0, "n_blind_info", true)
	UIAction:Add(SEQ(FADE_IN(0), DELAY(2000), FADE_OUT(100), SHOW(false)), var_64_1, "blind_ballon")
end

function PvpSA.popupLobby(arg_65_0, arg_65_1, arg_65_2)
	if not arg_65_2 then
		return 
	end
	
	if arg_65_2.season_change_info then
		if arg_65_2.season_change_info.hall_of_fame then
			PvpSAHOF:popupNewSeasonPeriod(arg_65_2.season_change_info.hall_of_fame, function()
				PvpSA:popupLastSeasonReward(arg_65_2.season_change_info.last_season_period_reward, function()
					PvpSA:popupSeasonChange(arg_65_1, arg_65_2)
				end)
			end)
		elseif arg_65_2.season_change_info.new_season_point then
			PvpSA:popupNewSeasonPoint(arg_65_2.season_change_info.new_season_point, function()
				PvpSA:popupLastSeasonReward(arg_65_2.season_change_info.last_season_period_reward, function()
					PvpSA:popupSeasonChange(arg_65_1, arg_65_2)
				end)
			end)
		else
			PvpSA:popupSeasonChange(arg_65_1, arg_65_2)
		end
	elseif arg_65_2.last_weekly_league_reward then
		arg_65_0:popupWeeklyRewardChange(arg_65_2)
	else
		PvpSA:popupLeagueChanged(arg_65_1, arg_65_2, function()
			PvpSA:popupAllClearReward(arg_65_1, arg_65_2)
		end)
	end
end

function PvpSA._popuptest1(arg_71_0)
	PvpSA:popupNewSeasonPoint("test", function()
		PvpSA:popupLastSeasonReward("test", function()
			PvpSA:popupSeasonChange("silver_4")
		end)
	end)
end

function PvpSA._popuptest2(arg_74_0)
	PvpSAHOF:popupNewSeasonPeriod(nil, function()
		PvpSA:popupLastSeasonReward("test", function()
			PvpSA:popupSeasonChange("silver_3")
		end)
	end)
end

function PvpSA._popuptest3(arg_77_0)
	PvpSAHOF:popupNewSeasonPeriod(nil, function()
		PvpSA:popupLastSeasonReward("test2", function()
			PvpSA:popupSeasonChange("silver_3")
		end)
	end)
end

function PvpSA.popupNewSeasonPoint(arg_80_0, arg_80_1, arg_80_2)
	if not arg_80_1 then
		if arg_80_2 then
			arg_80_2()
		end
		
		return 
	end
	
	if arg_80_1 == "test" then
		arg_80_1 = {
			new_season_point = 3210,
			last_week_ranking = 5,
			acquired_season_point = 95
		}
	end
	
	local var_80_0 = load_dlg("pvp_season_change_rank", true, "wnd")
	
	if_set(var_80_0, "txt_rank_last", T("pvp_list_rank", {
		rank = arg_80_1.last_week_ranking
	}))
	if_set(var_80_0, "txt_point_acq", comma_value(arg_80_1.acquired_season_point or 0))
	if_set(var_80_0, "txt_point_new", comma_value(arg_80_1.new_season_point or 0))
	Dialog:msgBox(nil, {
		dlg = var_80_0,
		handler = arg_80_2
	})
end

function PvpSA.popupLastSeasonReward(arg_81_0, arg_81_1, arg_81_2)
	if arg_81_1 == "test" then
		arg_81_1 = {
			{
				reward_id = "ma_border2",
				reward_value = 1
			},
			{
				reward_id = "ma_border5",
				reward_value = 1
			}
		}
	end
	
	if arg_81_1 == "test2" then
		arg_81_1 = {
			{
				reward_id = "ma_border2",
				reward_value = 1
			}
		}
	end
	
	local var_81_0 = table.count(arg_81_1 or {})
	
	if var_81_0 < 1 then
		if arg_81_2 then
			arg_81_2()
		end
		
		return 
	end
	
	local var_81_1 = load_dlg("pvp_season_reward_p", true, "wnd")
	local var_81_2
	
	if var_81_0 == 1 then
		var_81_2 = var_81_1:getChildByName("n_contents_1")
		
		var_81_2:setVisible(true)
		if_set_visible(var_81_1, "n_contents_2", false)
	else
		var_81_2 = var_81_1:getChildByName("n_contents_2")
		
		var_81_2:setVisible(true)
		if_set_visible(var_81_1, "n_contents_1", false)
	end
	
	for iter_81_0 = 1, 2 do
		if not arg_81_1[iter_81_0] then
			break
		end
		
		local var_81_3 = var_81_2:getChildByName("n_" .. iter_81_0)
		local var_81_4, var_81_5 = DB("item_material", arg_81_1[iter_81_0].reward_id, {
			"name",
			"desc"
		})
		
		UIUtil:getRewardIcon(nil, arg_81_1[iter_81_0].reward_id, {
			parent = var_81_3:getChildByName("n_frame_icon_" .. iter_81_0)
		})
		if_set(var_81_3, "txt_frame_name", T(var_81_4))
		
		if tolua:type(var_81_3:getChildByName("txt_frame_desc")) ~= "ccui.RichText" then
			upgradeLabelToRichLabel(var_81_3, "txt_frame_desc")
		end
		
		if_set(var_81_3, "txt_frame_desc", T(var_81_5))
	end
	
	Dialog:msgBox(nil, {
		dlg = var_81_1,
		handler = arg_81_2
	})
end

function PvpSA.popupLeagueChanged(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	arg_82_2 = arg_82_2 or {
		league_changed = {
			before = "gold_2",
			is_up = true,
			def_win_count = 11,
			def_lose_count = 2,
			after = "bronze_3",
			new_rankup = {
				reward_id = "to_crystal",
				reward_count = 250
			}
		},
		all_clear_reward = {
			reward_id = "to_pvpkey",
			reward_count = 2
		}
	}
	
	if not arg_82_2.league_changed then
		if arg_82_3 then
			arg_82_3()
		end
		
		return 
	end
	
	local var_82_0 = load_dlg("pvp_league_change", true, "wnd")
	local var_82_1, var_82_2, var_82_3, var_82_4 = DB("pvp_sa", arg_82_2.league_changed.before, {
		"name",
		"emblem",
		"desc",
		"rankup_ranking"
	})
	
	SpriteCache:resetSprite(var_82_0:getChildByName("icon_before"), "emblem/" .. var_82_2 .. ".png")
	if_set(var_82_0, "txt_league_before", T(var_82_1))
	
	local var_82_5, var_82_6, var_82_7, var_82_8 = DB("pvp_sa", arg_82_2.league_changed.after, {
		"name",
		"emblem",
		"name_league",
		"rankup_ranking"
	})
	
	SpriteCache:resetSprite(var_82_0:getChildByName("icon_after"), "emblem/" .. var_82_6 .. ".png")
	if_set(var_82_0, "txt_league_after", T(var_82_5))
	
	local var_82_9 = false
	
	if var_82_4 or var_82_8 then
		var_82_9 = true
	end
	
	if var_82_9 then
		if_set(var_82_0, "txt_desc", T("pvp_battlelog_rank_pop_desc"))
	end
	
	if arg_82_2.league_changed.new_rankup and arg_82_2.league_changed.new_rankup.reward_id then
		UIUtil:getRewardIcon(arg_82_2.league_changed.new_rankup.reward_count, arg_82_2.league_changed.new_rankup.reward_id, {
			show_small_count = true,
			show_name = false,
			detail = true,
			parent = var_82_0:getChildByName("n_reward_upgrade")
		})
		if_set_visible(var_82_0, "t_disc_after", false)
		if_set_visible(var_82_0, "t_first", true)
		if_set(var_82_0, "t_first", T("pvp_battlelog_pop_desc_new", {
			name = T(var_82_5)
		}))
	else
		if_set_visible(var_82_0, "t_disc_after", true)
		if_set_visible(var_82_0, "t_first", false)
		
		local var_82_10 = ""
		local var_82_11 = arg_82_2.league_changed.is_up and (var_82_9 and "pvp_battlelog_rank_pop_desc_up" or "pvp_battlelog_pop_desc_up") or var_82_9 and "pvp_battlelog_rank_pop_desc_dn" or "pvp_battlelog_pop_desc_dn"
		
		if_set(var_82_0, "t_disc_after", T(var_82_11))
	end
	
	local var_82_12 = var_82_0:getChildByName("n_record")
	
	if_set(var_82_12, "t_count_win", T("pvp_battlelog_pop_win_count", {
		count = arg_82_2.league_changed.def_win_count
	}))
	if_set(var_82_12, "t_count_defeat", T("pvp_battlelog_pop_lose_count", {
		count = arg_82_2.league_changed.def_lose_count
	}))
	Dialog:msgBox(nil, {
		dlg = var_82_0,
		handler = arg_82_3
	})
end

function PvpSA.popupAllClearReward(arg_83_0, arg_83_1, arg_83_2)
	arg_83_2 = arg_83_2 or {
		all_clear_reward = {
			reward_id = "to_pvpkey",
			reward_count = 2
		}
	}
	
	if not arg_83_2.all_clear_reward then
		return 
	end
	
	local var_83_0 = load_dlg("result_pvp_all_win", true, "wnd")
	
	UIUtil:getRewardIcon(arg_83_2.all_clear_reward.reward_count, arg_83_2.all_clear_reward.reward_id, {
		show_small_count = true,
		show_name = false,
		detail = true,
		parent = var_83_0:getChildByName("reward_item")
	})
	Dialog:msgBox(T("ui_result_pvp_all_win_desc"), {
		dlg = var_83_0,
		title = T("ui_result_pvp_all_win_title")
	})
end

function PvpSA.popupSeasonChange(arg_84_0, arg_84_1, arg_84_2)
	arg_84_2 = arg_84_2 or {
		season_change_info = {
			last_season_league = "challenger_5",
			last_season = 44,
			last_season_reward = {
				reward_id = "to_crystal",
				reward_count2 = 42,
				reward_id2 = "to_pvpgold",
				reward_count = 450
			}
		}
	}
	
	if arg_84_2.season_change_info.last_season_league == nil or arg_84_2.season_change_info.last_season == nil then
		return 
	end
	
	if arg_84_2.last_weekly_league_reward then
		arg_84_0:popupSeasonChange2(arg_84_1, arg_84_2)
		
		return 
	end
	
	local var_84_0, var_84_1, var_84_2 = DB("pvp_sa", arg_84_1, {
		"name",
		"emblem",
		"name_league"
	})
	local var_84_3 = load_dlg("pvp_season_change", true, "wnd")
	
	if arg_84_2.season_change_info.last_season_reward then
		if arg_84_2.season_change_info.last_season_reward.reward_id then
			local var_84_4 = var_84_3:getChildByName("n_reward1")
			
			UIUtil:getRewardIcon(arg_84_2.season_change_info.last_season_reward.reward_count, arg_84_2.season_change_info.last_season_reward.reward_id, {
				show_small_count = true,
				show_name = false,
				scale = 1,
				detail = true,
				parent = var_84_4
			})
			var_84_4:setVisible(true)
		else
			if_set_visible(var_84_3, "n_reward1", false)
		end
		
		if arg_84_2.season_change_info.last_season_reward.reward_id2 then
			local var_84_5 = var_84_3:getChildByName("n_reward2")
			
			UIUtil:getRewardIcon(arg_84_2.season_change_info.last_season_reward.reward_count2, arg_84_2.season_change_info.last_season_reward.reward_id2, {
				show_small_count = true,
				show_name = false,
				scale = 1,
				detail = true,
				parent = var_84_5
			})
			var_84_5:setVisible(true)
		else
			if_set_visible(var_84_3, "n_reward2", false)
		end
	else
		if_set_visible(var_84_3, "n_reward1", false)
		if_set_visible(var_84_3, "n_reward2", false)
	end
	
	local var_84_6, var_84_7, var_84_8 = DB("pvp_sa", arg_84_2.season_change_info.last_season_league, {
		"name",
		"emblem",
		"desc"
	})
	
	SpriteCache:resetSprite(var_84_3:getChildByName("icon_season_last"), "emblem/" .. var_84_7 .. ".png")
	if_set(var_84_3, "txt_league_last", T(var_84_6))
	SpriteCache:resetSprite(var_84_3:getChildByName("icon_season_new"), "emblem/" .. var_84_1 .. ".png")
	if_set(var_84_3, "txt_league_new", T(var_84_0))
	Dialog:msgBox(nil, {
		dlg = var_84_3
	})
end

function PvpSA.popupWeeklyRewardChange(arg_85_0, arg_85_1)
	if not arg_85_1 or not arg_85_1.last_weekly_league_reward then
		return 
	end
	
	local var_85_0 = load_dlg("pvp_season_reward_choose", true, "wnd")
	
	arg_85_0.vars.pvp_season_reward_choose = var_85_0
	arg_85_0.vars.last_weekly_league_reward = arg_85_1.last_weekly_league_reward
	arg_85_0.vars.pvp_season_reward_select_index = nil
	
	local var_85_1 = 0
	
	for iter_85_0, iter_85_1 in pairs(arg_85_1.last_weekly_league_reward) do
		if string.starts(iter_85_0, "reward_id") then
			var_85_1 = var_85_1 + 1
		end
	end
	
	local var_85_2
	local var_85_3
	local var_85_4 = var_85_0:getChildByName("n_even")
	local var_85_5 = 4
	
	for iter_85_2 = 1, var_85_5 do
		local var_85_6 = var_85_4:getChildByName("n_" .. iter_85_2 .. "/" .. var_85_5)
		
		if_set_visible(var_85_6, "select_" .. iter_85_2 .. "/" .. var_85_5, false)
		if_set_visible(var_85_6, "btn_" .. iter_85_2 .. "/" .. var_85_5, false)
		if_set_visible(var_85_6, "txt_have_" .. iter_85_2 .. "/" .. var_85_5, false)
	end
	
	local var_85_7 = var_85_0:getChildByName("n_odd")
	local var_85_8 = 5
	
	for iter_85_3 = 1, var_85_8 do
		local var_85_9 = var_85_7:getChildByName("n_" .. iter_85_3 .. "/" .. var_85_8)
		
		if_set_visible(var_85_9, "select_" .. iter_85_3 .. "/" .. var_85_8, false)
		if_set_visible(var_85_9, "btn_" .. iter_85_3 .. "/" .. var_85_8, false)
		if_set_visible(var_85_9, "txt_have_" .. iter_85_3 .. "/" .. var_85_8, false)
	end
	
	local var_85_10
	
	if var_85_1 % 2 == 0 then
		var_85_7 = var_85_0:getChildByName("n_even")
		var_85_10 = 4
	else
		var_85_7 = var_85_0:getChildByName("n_odd")
		var_85_10 = 5
	end
	
	for iter_85_4 = 1, var_85_10 do
		local var_85_11 = var_85_7:getChildByName("n_" .. iter_85_4 .. "/" .. var_85_10)
		
		if iter_85_4 <= var_85_1 then
			UIUtil:getRewardIcon(arg_85_1.last_weekly_league_reward["reward_count" .. iter_85_4], arg_85_1.last_weekly_league_reward["reward_id" .. iter_85_4], {
				show_small_count = true,
				show_name = false,
				parent = var_85_11:getChildByName("n_item_" .. iter_85_4 .. "/" .. var_85_10)
			})
			if_set_visible(var_85_11, "btn_" .. iter_85_4 .. "/" .. var_85_10, true)
			if_set_visible(var_85_11, "txt_have_" .. iter_85_4 .. "/" .. var_85_10, true)
			if_set(var_85_11, "txt_have_" .. iter_85_4 .. "/" .. var_85_10, T("ui_msgbox_monster_weak_have", {
				have = Account:getPropertyCount(arg_85_1.last_weekly_league_reward["reward_id" .. iter_85_4])
			}))
		end
	end
	
	var_85_0:getChildByName("btn_ok"):setOpacity(76.5)
	BackButtonManager:clear()
	BackButtonManager:push({
		check_id = "PvpSA.lobby",
		back_func = function()
			SceneManager:nextScene("lobby")
		end
	})
	BackButtonManager:push({
		check_id = "PvpSA.pvp_season_reward_choose",
		back_func = function()
			SceneManager:nextScene("lobby")
		end
	})
	Dialog:msgBox(nil, {
		no_back_button = true,
		dlg = var_85_0,
		cancel_handler = function()
			return "dont_close"
		end,
		handler = function(arg_89_0, arg_89_1)
			if arg_89_1 == "btn_ok" then
				if to_n(arg_85_0.vars.pvp_season_reward_select_index) > 0 then
					query("pvp_sa_exchange_weekly_reward", {
						reward_index = arg_85_0.vars.pvp_season_reward_select_index
					})
					
					arg_85_0.vars.pvp_season_reward_select_index = nil
					
					return 
				end
				
				return "dont_close"
			elseif string.starts(arg_89_1, "btn_") then
				local var_89_0 = string.split(arg_89_1, "_")
				
				arg_85_0:popupWeeklyRewardChoose(var_89_0[2])
				
				return "dont_close"
			end
			
			return "dont_close"
		end
	})
end

function PvpSA.popupWeeklyRewardChoose(arg_90_0, arg_90_1)
	if not arg_90_0.vars or not get_cocos_refid(arg_90_0.vars.pvp_season_reward_choose) then
		return 
	end
	
	local var_90_0 = string.split(arg_90_1, "/")
	
	if not var_90_0 or to_n(var_90_0[1]) < 1 then
		return 
	end
	
	local var_90_1 = arg_90_0.vars.pvp_season_reward_select_index
	
	if arg_90_0.vars.pvp_season_reward_select_index == to_n(var_90_0[1]) then
		return 
	end
	
	arg_90_0.vars.pvp_season_reward_select_index = to_n(var_90_0[1])
	
	arg_90_0.vars.pvp_season_reward_choose:getChildByName("btn_ok"):setOpacity(255)
	
	local var_90_2 = arg_90_0.vars.pvp_season_reward_choose:getChildByName("select_" .. arg_90_1)
	
	if_set_visible(arg_90_0.vars.pvp_season_reward_choose, "select_" .. arg_90_1, true)
	
	if var_90_1 then
		if_set_visible(arg_90_0.vars.pvp_season_reward_choose, "select_" .. var_90_1 .. "/" .. var_90_0[2], false)
	end
end

function PvpSA.closePopupSeasonChange2(arg_91_0)
	if not arg_91_0.vars or not get_cocos_refid(arg_91_0.vars.wnd_pvp_season_change2) then
		return 
	end
	
	Dialog:close("pvp_season_change2")
	
	if arg_91_0.vars.temp_last_weekly_league_reward then
		local var_91_0 = arg_91_0.vars.temp_last_weekly_league_reward
		
		arg_91_0.vars.temp_last_weekly_league_reward = nil
		
		if var_91_0 then
			arg_91_0:popupWeeklyRewardChange({
				last_weekly_league_reward = var_91_0
			})
		end
	end
end

function PvpSA.popupSeasonChange2(arg_92_0, arg_92_1, arg_92_2)
	arg_92_2 = arg_92_2 or {
		season_change_info = {
			last_season_league = "challenger_5",
			last_season = 44,
			last_season_reward = {
				reward_id = "to_pvphonor",
				reward_count = 450
			}
		},
		last_weekly_league_reward = {
			reward_count1 = 150,
			reward_id1 = "to_crystal",
			reward_count2 = 25,
			reward_id2 = "to_ticketspecial"
		}
	}
	
	if arg_92_2 == nil or arg_92_2.season_change_info == nil or arg_92_2.season_change_info.last_season_league == nil or arg_92_2.season_change_info.last_season == nil then
		return 
	end
	
	arg_92_0.vars.temp_last_weekly_league_reward = arg_92_2.last_weekly_league_reward
	
	local var_92_0, var_92_1, var_92_2 = DB("pvp_sa", arg_92_1, {
		"name",
		"emblem",
		"name_league"
	})
	
	arg_92_0.vars.wnd_pvp_season_change2 = Dialog:open("wnd/pvp_season_change2", arg_92_0, {
		back_func = function()
			arg_92_0:closePopupSeasonChange2()
		end
	})
	
	if_set_arrow(arg_92_0.vars.wnd_pvp_season_change2)
	
	arg_92_0.vars.wnd_pvp_season_change2.opt_data = arg_92_2
	
	SceneManager:getRunningPopupScene():addChild(arg_92_0.vars.wnd_pvp_season_change2)
	
	local var_92_3 = arg_92_0.vars.wnd_pvp_season_change2
	
	if arg_92_2.season_change_info.last_season_reward then
		if arg_92_2.season_change_info.last_season_reward.reward_id then
			if_set_visible(var_92_3, "n_reward_item", true)
			
			local var_92_4 = var_92_3:getChildByName("n_reward")
			
			UIUtil:getRewardIcon(arg_92_2.season_change_info.last_season_reward.reward_count, arg_92_2.season_change_info.last_season_reward.reward_id, {
				show_small_count = true,
				show_name = false,
				scale = 1,
				detail = true,
				parent = var_92_4
			})
			var_92_4:setVisible(true)
			if_set_visible(var_92_3, "n_info", false)
		else
			if_set_visible(var_92_3, "n_reward_item", false)
			if_set_visible(var_92_3, "n_info", true)
		end
	else
		if_set_visible(var_92_3, "n_reward_item", false)
		if_set_visible(var_92_3, "n_info", true)
	end
	
	local var_92_5, var_92_6, var_92_7 = DB("pvp_sa", arg_92_2.season_change_info.last_season_league, {
		"name",
		"emblem",
		"desc"
	})
	
	SpriteCache:resetSprite(var_92_3:getChildByName("icon_season_last"), "emblem/" .. var_92_6 .. ".png")
	if_set(var_92_3, "txt_league_last", T(var_92_5))
	SpriteCache:resetSprite(var_92_3:getChildByName("icon_season_new"), "emblem/" .. var_92_1 .. ".png")
	if_set(var_92_3, "txt_league_new", T(var_92_0))
end

function PvpSA.startAutoUpdate(arg_94_0)
	Scheduler:addSlow(arg_94_0.vars.base_wnd, arg_94_0.autoUpdate, arg_94_0, true)
end

function PvpSA.autoUpdate(arg_95_0)
	if not arg_95_0.vars then
		return 
	end
	
	PvpNPC:autoUpdate()
end

function PvpSA.modeNPClist(arg_96_0, arg_96_1)
	arg_96_0.vars.npc_list_wnd = arg_96_0.vars.base_wnd:getChildByName("CENTER_5")
	
	if not arg_96_1 then
		PvpNPC:show(arg_96_0.vars.npc_list_wnd, Account:getAllNPC())
	else
		PvpNPC:refresh(Account:getAllNPC())
	end
end

function PvpSA.modeVSlist(arg_97_0, arg_97_1)
	if arg_97_0.vars.lobby_info.res == "not_init" then
		return 
	end
	
	local var_97_0 = {}
	
	for iter_97_0, iter_97_1 in pairs(arg_97_0.vars.lobby_info.enemies) do
		table.push(var_97_0, iter_97_1)
	end
	
	arg_97_0.vars.vs_list_wnd = arg_97_0.vars.base_wnd:getChildByName("CENTER_1")
	
	if not arg_97_1 then
		PvpSAVS:show(arg_97_0.vars.vs_list_wnd, var_97_0)
	else
		PvpSAVS:refresh(var_97_0)
	end
	
	local var_97_1 = arg_97_0.vars.base_wnd:getChildByName("btn_go")
	local var_97_2 = arg_97_0.vars.lobby_info.match_interval_sec - (os.time() - arg_97_0.vars.lobby_info.info.vs_refresh_time)
	
	if var_97_2 < 0 then
		var_97_2 = 0
	end
	
	if_set(var_97_1, "cost", sec_to_string(var_97_2))
	TutorialGuide:procGuide("system_008")
end

function PvpSA.getCurrentLeague(arg_98_0)
	if not arg_98_0.vars.lobby_info or not arg_98_0.vars.lobby_info.info then
		return "bronze_5"
	end
	
	return arg_98_0.vars.lobby_info.info.league
end

function PvpSA.refreshVSlist(arg_99_0, arg_99_1)
	if arg_99_1.update_currency then
		Account:updateCurrencies(arg_99_1.update_currency)
		arg_99_0:topbarUpdate(true)
	end
	
	arg_99_0.vars.lobby_info.match_refresh = arg_99_1.match_refresh
	arg_99_0.vars.lobby_info.info.vs_refresh_time = arg_99_1.vst
	arg_99_0.vars.lobby_info.info.continuous_victory = arg_99_1.continuous_victory
	arg_99_0.vars.lobby_info.enemies = arg_99_1.vsl
	arg_99_0.vars.lobby_info.info.vs_refresh_day_id = arg_99_1.vs_refresh_day_id
	arg_99_0.vars.lobby_info.info.vs_refresh_day_count = arg_99_1.vs_refresh_day_count
	arg_99_0.vars.blind_day_current = arg_99_0:isBlindUser()
	
	if_set(arg_99_0.vars.base_wnd, "txt_count_conti_win", T("pvp_win_rapid", {
		count = comma_value(arg_99_0.vars.lobby_info.info.continuous_victory or 0)
	}))
	arg_99_0:modeVSlist(true)
end

function PvpSA.topbarUpdate(arg_100_0, arg_100_1)
	TopBarNew:topbarUpdate(AccountData, arg_100_0.vars.parent, arg_100_1)
end

function PvpSA.update(arg_101_0)
	local var_101_0 = os.time()
	
	if arg_101_0.prevTick == nil then
		arg_101_0.prevTick = var_101_0
	elseif arg_101_0.prevTick == var_101_0 then
		return 
	end
	
	arg_101_0.prevTick = var_101_0
	
	if not arg_101_0.vars or not arg_101_0.vars.opts or not arg_101_0.vars.current_menu or not arg_101_0.vars.lobby_info then
		return 
	end
	
	local var_101_1 = arg_101_0.vars.lobby_info.pvp_season_info
	local var_101_2 = {}
	
	if var_101_1 then
		var_101_2 = var_101_1.season_period_db
	end
	
	if not get_cocos_refid(arg_101_0.vars.base_wnd) then
		return 
	end
	
	local var_101_3 = to_n(var_101_2.end_time_view) - var_101_0
	local var_101_4 = arg_101_0.vars.base_wnd:getChildByName("txt_season_title")
	
	if var_101_2 and var_101_3 / 86400 < to_n(var_101_2.end_term) then
		var_101_4:setPositionY(619)
		if_set(arg_101_0.vars.base_wnd, "txt_season_remaining", T("pvp_season_off", timeToStringDef({
			preceding_with_zeros = true,
			time = var_101_2.end_time_view
		})))
		if_set_visible(arg_101_0.vars.base_wnd, "txt_season_remaining", true)
	else
		var_101_4:setPositionY(606)
		if_set_visible(arg_101_0.vars.base_wnd, "txt_season_remaining", false)
	end
	
	if arg_101_0.vars.current_menu == "main" then
		local var_101_5 = arg_101_0.vars.base_wnd:getChildByName("btn_go")
		local var_101_6 = arg_101_0.vars.lobby_info.refresh_day_limit or 30
		local var_101_7 = arg_101_0.vars.lobby_info.info.vs_refresh_day_count or 0
		local var_101_8 = arg_101_0.vars.lobby_info.match_interval_sec - (os.time() - arg_101_0.vars.lobby_info.info.vs_refresh_time)
		
		if var_101_8 <= 0 then
			var_101_5:setOpacity(255)
			if_set(var_101_5, "cost", T("pvp_free"))
		else
			if var_101_6 <= var_101_7 then
				var_101_5:setOpacity(76.5)
			else
				var_101_5:setOpacity(255)
			end
			
			if_set(var_101_5, "cost", T("pvp_refresh", {
				time = sec_to_string(var_101_8)
			}))
		end
	end
end

function PvpSA.battleClear(arg_102_0, arg_102_1)
	ConditionContentsManager:dispatch("pvp.play")
	
	if arg_102_1.result_info.win then
		ConditionContentsManager:dispatch("pvp.win")
	end
	
	if arg_102_1.update_currency then
		Account:updateCurrencies(arg_102_1.update_currency)
	end
	
	local var_102_0, var_102_1 = ClearResult:calcFavInfosUtil(arg_102_1)
	
	ClearResult:show(Battle.logic, {
		map_id = "pvp00100",
		pvp_result = arg_102_1.result_info,
		pvp_reward = arg_102_1.reward_info,
		units = arg_102_1.units,
		units_favexp = var_102_1,
		fav_levelup = var_102_0
	})
end

PvpSAVS = {}

copy_functions(ScrollView, PvpSAVS)

function PvpSAVS.clear(arg_103_0)
	arg_103_0.vars = nil
end

function PvpSAVS.show(arg_104_0, arg_104_1, arg_104_2)
	if arg_104_0.vars then
		return 
	end
	
	arg_104_0.vars = {}
	arg_104_0.vars.parent = arg_104_1
	arg_104_0.vars.list = arg_104_2
	
	table.sort(arg_104_0.vars.list, function(arg_105_0, arg_105_1)
		return arg_105_0.slot < arg_105_1.slot
	end)
	
	arg_104_0.vars.scrollview = arg_104_1:getChildByName("scrollview")
	
	arg_104_0:initScrollView(arg_104_0.vars.scrollview, 690, 110)
	
	if PvpSA:isCurrentBlind() then
		table.shuffle(arg_104_0.vars.list)
	end
	
	arg_104_0:createScrollViewItems(arg_104_0.vars.list)
	
	local var_104_0 = arg_104_0.vars.parent:getChildByName("txt_title")
	local var_104_1, var_104_2 = DB("pvp_sa", PvpSA:getCurrentLeague(), {
		"clear_reward_id",
		"clear_reward_count"
	})
	
	if var_104_1 and var_104_2 then
		UIUtil:getRewardIcon(var_104_2, var_104_1, {
			scale = 1,
			detail = false,
			parent = var_104_0:getChildByName("n_reward_all")
		})
	else
		if_set_visible(var_104_0, "n_reward_all", false)
		if_set_visible(var_104_0, "txt_clear", false)
	end
end

function PvpSAVS.refresh(arg_106_0, arg_106_1)
	arg_106_0.vars.list = arg_106_1
	
	if PvpSA:isCurrentBlind() then
		table.shuffle(arg_106_0.vars.list)
	end
	
	arg_106_0:createScrollViewItems(arg_106_0.vars.list)
end

function PvpSAVS.getScrollViewItem(arg_107_0, arg_107_1)
	local var_107_0 = load_control("wnd/pvp_bar.csb")
	
	var_107_0.item = arg_107_1
	
	for iter_107_0 = 1, 4 do
		if_set_visible(var_107_0, "enemy" .. iter_107_0, false)
	end
	
	if PvpSA:isCurrentBlind() then
		table.shuffle(arg_107_1.enemy_info.units)
	end
	
	local var_107_1 = 0
	local var_107_2 = (arg_107_1.enemy_info or {}).border_code
	
	if PvpSA:isBlindUser() then
		var_107_2 = nil
	end
	
	for iter_107_1, iter_107_2 in pairs(arg_107_1.enemy_info.units) do
		if iter_107_2.pos ~= 5 then
			var_107_1 = var_107_1 + 1
			
			local var_107_3 = var_107_0:getChildByName("enemy" .. var_107_1)
			
			if var_107_3 then
				var_107_3:setVisible(true)
				
				local var_107_4 = UNIT:create(iter_107_2.unit)
				
				UIUtil:getUserIcon(var_107_4, {
					parent = var_107_3:getChildByName("n_face"),
					border_code = var_107_2
				})
				
				if get_cocos_refid(var_107_3:getChildByName("n_face"):getChildByName(".reward_icon")) then
					WidgetUtils:setupPopup({
						control = var_107_3:getChildByName("n_face"):getChildByName(".reward_icon"),
						creator = function()
							return UIUtil:getCharacterPopup({
								skill_preview = false,
								off_power_detail = true,
								code = iter_107_2.unit.skin_code or iter_107_2.unit.code,
								grade = iter_107_2.unit.g,
								lv = var_107_4.inst.lv,
								z = iter_107_2.unit.zodiac,
								awake = iter_107_2.unit.awake
							})
						end
					})
				end
			end
		end
	end
	
	local var_107_5 = var_107_0:getChildByName("n_enemy")
	
	if PvpSA:isCurrentBlind() then
		if_set_visible(var_107_5, "n_blind", true)
		if_set_visible(var_107_5, "n_common", false)
		
		local var_107_6 = var_107_5:getChildByName("n_blind")
		
		if_set_visible(var_107_6, "txt_name_unkown", true)
		if_set(var_107_6, "txt_name_unkown", T("pvp_blind_name"))
		if_set_visible(var_107_6, "txt_name", false)
		if_set(var_107_6, "txt_rating_blind", T("pvp_point", {
			point = comma_value(arg_107_1.score)
		}))
	else
		if_set_visible(var_107_5, "n_blind", false)
		if_set_visible(var_107_5, "n_common", true)
		
		local var_107_7 = var_107_5:getChildByName("n_common")
		
		if_set(var_107_7, "txt_name", arg_107_1.enemy_info.name)
		if_set(var_107_7, "txt_rating", T("pvp_point", {
			point = comma_value(arg_107_1.score)
		}))
		
		local var_107_8 = var_107_7:getChildByName("txt_rating")
		
		var_107_8:setPositionY(var_107_8:getPositionY() + 23)
		if_set_visible(var_107_7, "n_clan", false)
	end
	
	if_set_visible(var_107_0, "btn_pvp_retry", arg_107_1.result == 3)
	if_set_visible(var_107_0, "n_complet", arg_107_1.result == 2)
	if_set_visible(var_107_0, "btn_pvp_select", arg_107_1.result ~= 3 and arg_107_1.result ~= 2)
	if_set_visible(var_107_0, "n_waiting", false)
	if_set_visible(var_107_0, "n_npc", false)
	if_set_visible(var_107_0, "n_enemy", true)
	if_set_visible(var_107_0, "n_result_icon_pos", true)
	
	local var_107_9, var_107_10 = DB("pvp_sa", PvpSA:getCurrentLeague(), {
		"win_reward_id",
		"win_reward_count"
	})
	
	UIUtil:getRewardIcon(var_107_10, var_107_9, {
		scale = 1,
		detail = false,
		parent = var_107_0:getChildByName("n_result_icon_pos")
	})
	
	local var_107_11 = var_107_0:getChildByName("LEFT")
	
	if arg_107_1.result == 2 then
		var_107_11:setColor(UIUtil.DARK_GREY)
		var_107_11:setOpacity(180)
	else
		var_107_11:setColor(UIUtil.WHITE)
		var_107_11:setOpacity(255)
	end
	
	return var_107_0
end

function PvpSAVS.onSelectScrollViewItem(arg_109_0, arg_109_1, arg_109_2)
end

function PvpSAVS.select(arg_110_0, arg_110_1)
	if arg_110_1.item.result ~= 2 then
		if to_n(arg_110_1.item.battle_count) >= 2 then
			Dialog:msgBox(T("pvp_abusing_desc"), {
				yesno = true,
				handler = function()
					PvpSA:pvpReady(arg_110_1)
					SoundEngine:play("event:/ui/ok")
				end,
				title = T("pvp_abusing_title")
			})
		else
			PvpSA:pvpReady(arg_110_1)
			SoundEngine:play("event:/ui/ok")
		end
	end
end

PvpSASL = {}

copy_functions(ScrollView, PvpSASL)

function PvpSASL.clear(arg_112_0)
	arg_112_0.vars = nil
end

function PvpSASL.show(arg_113_0)
	arg_113_0.vars = {}
	arg_113_0.vars.parent = PvpSA:getBaseWnd():getChildByName("CENTER_3")
	
	local var_113_0 = arg_113_0.vars.parent:getChildByName("listview_season")
	
	if_set(arg_113_0.vars.parent, "txt_info", T("pvp_ranking_desc_season"))
	
	arg_113_0.vars.itemView = ItemListView_v2:bindControl(var_113_0)
	
	local var_113_1 = load_control("wnd/pvp_bar_seasonrank_.csb")
	
	if var_113_0.STRETCH_INFO then
		local var_113_2 = var_113_0:getContentSize()
		
		resetControlPosAndSize(var_113_1, var_113_2.width, var_113_0.STRETCH_INFO.width_prev)
	end
	
	local var_113_3 = {
		onUpdate = function(arg_114_0, arg_114_1, arg_114_2, arg_114_3)
			PvpSASL:updateItem(arg_114_1, arg_114_3)
			
			return arg_114_3.id
		end
	}
	
	arg_113_0.vars.itemView:setRenderer(var_113_1, var_113_3)
	arg_113_0.vars.itemView:removeAllChildren()
	arg_113_0.vars.itemView:setDataSource({})
	if_set_visible(arg_113_0.vars.parent, "n_lastweek_ranking", false)
	if_set_visible(arg_113_0.vars.parent, "n_season_ranking", true)
	if_set_visible(arg_113_0.vars.parent, "n_total_ranking", false)
	if_set_visible(arg_113_0.vars.parent:getChildByName("n_season_ranking"), "n_nodata", false)
	if_set_visible(arg_113_0.vars.parent:getChildByName("n_lastweek_ranking"), "n_nodata", false)
	
	local var_113_4 = arg_113_0.vars.parent:getChildByName("n_ranking_category")
	
	if var_113_4 then
		if_set_visible(var_113_4, "fg_category_total", false)
		if_set_visible(var_113_4, "fg_category_season", true)
		if_set_visible(var_113_4, "fg_category_lastweek", false)
		PvpSA:setRankingCategory("season")
	end
	
	if PvpSA:getLobbyInfo().pvp_season_info.season_period_info then
		query("pvp_sa_season_ranking", {
			page = 1
		})
	end
	
	if getUserLanguage() == "ja" then
		local var_113_5 = getChildByPath(arg_113_0.vars.parent, "n_ranking_category/category_lastweek/txt")
		
		if get_cocos_refid(var_113_5) then
			UIUserData:call(var_113_5, "MULTI_SCALE(1)")
		end
	end
end

function PvpSASL.update(arg_115_0, arg_115_1)
	if not arg_115_0.vars.league_rank_list then
		arg_115_0.vars.league_rank_list = {}
	end
	
	local var_115_0 = arg_115_0.vars.itemView:getDataSource() or {}
	local var_115_1 = table.count(var_115_0)
	
	arg_115_1.rank_list = arg_115_1.rank_list or {}
	arg_115_0.vars.league_rank_page = arg_115_1.page
	
	local var_115_2
	local var_115_3 = false
	
	if arg_115_1.page == 1 or not arg_115_0.vars.league_rank_list then
		arg_115_0.vars.league_rank_list = arg_115_1.rank_list
	else
		arg_115_0:insertItems(arg_115_1.rank_list)
		
		var_115_2 = true
	end
	
	for iter_115_0, iter_115_1 in pairs(arg_115_0.vars.league_rank_list or {}) do
		if iter_115_1.enemy_info.id == Account:getUserId() then
			iter_115_1.enemy_info.name = AccountData.name
		end
		
		iter_115_1.emblem = DB("pvp_sa", iter_115_1.league, {
			"emblem"
		})
	end
	
	local var_115_4 = PvpSA:getLobbyInfo().pvp_season_info.season_period_info
	local var_115_5 = arg_115_0.vars.parent:getChildByName("n_season_ranking")
	
	if var_115_4 then
		if to_n(var_115_4.season_no) == 0 then
			if_set(var_115_5, "txt_nodata", T("ui_pvp_base_srank_total"))
			if_set_visible(var_115_5, "n_nodata", true)
		elseif to_n(var_115_4.season_no) < 2 then
			if_set(var_115_5, "txt_nodata", T("ui_pvp_base_tab4_desc"))
			if_set_visible(var_115_5, "n_nodata", true)
		else
			if_set(var_115_5, "txt_nodata", T("ui_pvp_base_noseason"))
			if_set_visible(arg_115_0.vars.parent:getChildByName("n_season_ranking"), "n_nodata", arg_115_1.page == 1 and #arg_115_1.rank_list == 0)
			
			var_115_3 = arg_115_1.page ~= 1 or #arg_115_1.rank_list ~= 0
		end
	end
	
	if #arg_115_1.rank_list > 0 then
		table.insert(arg_115_0.vars.league_rank_list, {
			next_item = true
		})
	end
	
	local var_115_6 = arg_115_0.vars.parent:getChildByName("n_my_rank")
	
	if var_115_6 then
		if_set_visible(var_115_6, "t_count", false)
		if_set_visible(var_115_6, "icon_league", false)
		if_set_visible(var_115_6, "n_center", false)
		if_set_visible(var_115_6, "txt_score", false)
		if_set_visible(var_115_6, "txt_score_season", true)
		if_set(var_115_6, "txt_score_season", T("pvp_season_point", {
			season_point = comma_value(arg_115_1.score or "-")
		}))
		
		if var_115_3 and arg_115_1.rank and arg_115_1.score then
			if_set_visible(var_115_6, "t_tier_placement", false)
			if_set_visible(var_115_6, "keep", true)
			if_set(var_115_6, "t_rank_number", T("pvp_list_rank", {
				rank = arg_115_1.rank
			}))
		else
			if_set_visible(var_115_6, "t_tier_placement", true)
			if_set_visible(var_115_6, "keep", false)
			if_set_visible(var_115_6, "t_rank_number", false)
		end
	end
	
	arg_115_0.vars.itemView:setDataSource({})
	arg_115_0.vars.itemView:setDataSource(arg_115_0.vars.league_rank_list)
	
	if var_115_2 then
		arg_115_0.vars.itemView:forceDoLayout()
		arg_115_0.vars.itemView:jumpToIndex(var_115_1)
	end
end

function PvpSASL.nextPage(arg_116_0)
	query("pvp_sa_season_ranking", {
		page = arg_116_0.vars.league_rank_page + 1
	})
end

function PvpSASL.insertItems(arg_117_0, arg_117_1)
	local var_117_0
	
	for iter_117_0, iter_117_1 in pairs(arg_117_0.vars.league_rank_list) do
		if iter_117_1.next_item then
			var_117_0 = iter_117_0
		end
	end
	
	for iter_117_2, iter_117_3 in pairs(arg_117_1 or {}) do
		table.insert(arg_117_0.vars.league_rank_list, iter_117_3)
	end
	
	if var_117_0 then
		table.remove(arg_117_0.vars.league_rank_list, var_117_0)
	end
end

function PvpSASL.updateItem(arg_118_0, arg_118_1, arg_118_2)
	arg_118_1:getChildByName("btn_more").parent = arg_118_0
	
	if arg_118_2.next_item then
		if_set_visible(arg_118_1, "page_next", true)
		if_set_visible(arg_118_1, "txt_name", false)
		if_set_visible(arg_118_1, "txt_rating", false)
		if_set_visible(arg_118_1, "n_clan", false)
		if_set_visible(arg_118_1, "n_emblem", false)
		if_set_visible(arg_118_1, "txt_clan_name", false)
		if_set_visible(arg_118_1, "LEFT", false)
		if_set_visible(arg_118_1, "RIGHT", false)
		if_set_visible(arg_118_1, "bar1_l_0", false)
		
		return 
	end
	
	if_set_visible(arg_118_1, "page_next", false)
	if_set(arg_118_1, "txt_name", arg_118_2.enemy_info.name)
	
	if to_n(arg_118_2.season_rank) > 3 then
		if_set_visible(arg_118_1, "txt_rank", true)
		if_set_visible(arg_118_1, "n_toprank", false)
		if_set(arg_118_1, "txt_rank", T("pvp_list_rank", {
			rank = arg_118_2.season_rank
		}))
	else
		if_set_visible(arg_118_1, "txt_rank", false)
		if_set_visible(arg_118_1, "n_toprank", true)
		
		local var_118_0 = arg_118_1:getChildByName("n_toprank")
		
		if_set_visible(var_118_0, "icon_menu_rankcup", true)
		if_set_visible(var_118_0, "icon_menu_rank", false)
		if_set(var_118_0, "txt_toprank", T("pvp_list_rank", {
			rank = arg_118_2.season_rank
		}))
	end
	
	local var_118_1 = arg_118_1:getChildByName("n_season")
	
	if_set(var_118_1, "t_season_point", T("pvp_season_point", {
		season_point = comma_value(arg_118_2.season_pt)
	}))
	
	if arg_118_2.last_season_rank then
		if_set(var_118_1, "t_last_rank", T("pvp_pre_ranking", {
			rank = "#" .. tostring(arg_118_2.last_season_rank)
		}))
	else
		if_set(var_118_1, "t_last_rank", T("pvp_pre_ranking", {
			rank = "-"
		}))
	end
	
	if_set_visible(arg_118_1, "n_clan", false)
	if_set_visible(arg_118_1, "n_emblem", false)
	if_set_visible(arg_118_1, "txt_clan_name", false)
	if_set_visible(arg_118_1, "n_season", true)
	if_set_visible(arg_118_1, "n_lastweek", false)
	
	local var_118_2 = (arg_118_2.enemy_info or {}).border_code
	local var_118_3 = (arg_118_2.enemy_info or {}).leader_code or "c1001"
	local var_118_4 = UNIT:create({
		code = var_118_3
	})
	
	UIUtil:getUserIcon(var_118_4, {
		no_lv = true,
		no_grade = true,
		parent = arg_118_1:getChildByName("n_face"),
		border_code = var_118_2
	})
	
	local var_118_5 = (arg_118_2.enemy_info or {}).clan
	
	if var_118_5 and var_118_5.name then
		if_set(arg_118_1, "txt_clan_name", var_118_5.name)
		UIUtil:updateClanEmblem(arg_118_1:getChildByName("n_emblem"), var_118_5)
		if_set_visible(arg_118_1, "n_emblem", true)
	end
	
	return arg_118_1
end

PvpSALW = {}

copy_functions(ScrollView, PvpSALW)

function PvpSALW.clear(arg_119_0)
	arg_119_0.vars = nil
end

function PvpSALW.show(arg_120_0)
	arg_120_0.vars = {}
	arg_120_0.vars.parent = PvpSA:getBaseWnd():getChildByName("CENTER_3")
	
	local var_120_0 = arg_120_0.vars.parent:getChildByName("listview_lastweek")
	
	if_set(arg_120_0.vars.parent, "txt_info", T("pvp_ranking_desc_last"))
	
	arg_120_0.vars.itemView = ItemListView_v2:bindControl(var_120_0)
	
	local var_120_1 = load_control("wnd/pvp_bar_seasonrank_.csb")
	
	if var_120_0.STRETCH_INFO then
		local var_120_2 = var_120_0:getContentSize()
		
		resetControlPosAndSize(var_120_1, var_120_2.width, var_120_0.STRETCH_INFO.width_prev)
	end
	
	local var_120_3 = {
		onUpdate = function(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
			PvpSALW:updateItem(arg_121_1, arg_121_3)
			
			return arg_121_3.id
		end
	}
	
	arg_120_0.vars.itemView:setRenderer(var_120_1, var_120_3)
	arg_120_0.vars.itemView:removeAllChildren()
	arg_120_0.vars.itemView:setDataSource({})
	if_set_visible(arg_120_0.vars.parent, "n_lastweek_ranking", true)
	if_set_visible(arg_120_0.vars.parent, "n_season_ranking", false)
	if_set_visible(arg_120_0.vars.parent, "n_total_ranking", false)
	if_set_visible(arg_120_0.vars.parent:getChildByName("n_season_ranking"), "n_nodata", false)
	
	local var_120_4 = arg_120_0.vars.parent:getChildByName("n_ranking_category")
	
	if var_120_4 then
		if_set_visible(var_120_4, "fg_category_total", false)
		if_set_visible(var_120_4, "fg_category_season", false)
		if_set_visible(var_120_4, "fg_category_lastweek", true)
		PvpSA:setRankingCategory("lastweek")
	end
	
	query("pvp_sa_last_week_ranking", {
		page = 1
	})
end

function PvpSALW.update(arg_122_0, arg_122_1)
	if not arg_122_0.vars.league_rank_list then
		arg_122_0.vars.league_rank_list = {}
	end
	
	local var_122_0 = arg_122_0.vars.itemView:getDataSource() or {}
	local var_122_1 = table.count(var_122_0)
	
	arg_122_1.rank_list = arg_122_1.rank_list or {}
	arg_122_0.vars.league_rank_page = arg_122_1.page
	
	local var_122_2
	local var_122_3 = false
	
	if arg_122_1.page == 1 or not arg_122_0.vars.league_rank_list then
		arg_122_0.vars.league_rank_list = arg_122_1.rank_list
	else
		arg_122_0:insertItems(arg_122_1.rank_list)
		
		var_122_2 = true
	end
	
	for iter_122_0, iter_122_1 in pairs(arg_122_0.vars.league_rank_list or {}) do
		if iter_122_1.enemy_info.id == Account:getUserId() then
			iter_122_1.enemy_info.name = AccountData.name
		end
		
		iter_122_1.emblem = DB("pvp_sa", iter_122_1.league, {
			"emblem"
		})
	end
	
	if arg_122_1.page == 1 and #arg_122_1.rank_list == 0 then
		if_set_visible(arg_122_0.vars.parent:getChildByName("n_lastweek_ranking"), "n_nodata", true)
	else
		var_122_3 = true
	end
	
	if #arg_122_1.rank_list > 0 then
		table.insert(arg_122_0.vars.league_rank_list, {
			next_item = true
		})
	end
	
	local var_122_4 = arg_122_0.vars.parent:getChildByName("n_my_rank")
	
	if var_122_4 then
		if_set_visible(var_122_4, "txt_score", true)
		if_set_visible(var_122_4, "txt_score_season", false)
		
		if var_122_3 and arg_122_1.rank and arg_122_1.score and arg_122_1.league then
			local var_122_5, var_122_6 = DB("pvp_sa", arg_122_1.league, {
				"name",
				"emblem"
			})
			
			if_set(var_122_4, "t_rank_number", T("pvp_list_rank", {
				rank = arg_122_1.rank
			}))
			if_set(var_122_4, "t_count", T(var_122_5))
			if_set_visible(var_122_4, "n_center", true)
			if_set(var_122_4, "txt_score", T("pvp_point", {
				point = comma_value(arg_122_1.score or 0)
			}))
			SpriteCache:resetSprite(var_122_4:getChildByName("icon_league"), "emblem/" .. var_122_6 .. ".png")
			if_set_visible(var_122_4, "t_count", true)
			if_set_visible(var_122_4, "icon_league", true)
			if_set_visible(var_122_4, "t_rank_number", true)
			if_set_visible(var_122_4, "t_tier_placement", false)
			if_set_visible(var_122_4, "keep", false)
		else
			if_set(var_122_4, "txt_score", T("pvp_point", {
				point = "-"
			}))
			if_set_visible(var_122_4, "t_count", false)
			if_set_visible(var_122_4, "icon_league", false)
			if_set_visible(var_122_4, "t_rank_number", false)
			if_set_visible(var_122_4, "t_tier_placement", true)
			if_set_visible(var_122_4, "keep", true)
		end
	end
	
	arg_122_0.vars.itemView:setDataSource({})
	arg_122_0.vars.itemView:setDataSource(arg_122_0.vars.league_rank_list)
	
	if var_122_2 then
		arg_122_0.vars.itemView:forceDoLayout()
		arg_122_0.vars.itemView:jumpToIndex(var_122_1)
	end
end

function PvpSALW.nextPage(arg_123_0)
	query("pvp_sa_last_week_ranking", {
		page = arg_123_0.vars.league_rank_page + 1
	})
end

function PvpSALW.insertItems(arg_124_0, arg_124_1)
	local var_124_0
	
	for iter_124_0, iter_124_1 in pairs(arg_124_0.vars.league_rank_list) do
		if iter_124_1.next_item then
			var_124_0 = iter_124_0
		end
	end
	
	for iter_124_2, iter_124_3 in pairs(arg_124_1 or {}) do
		table.insert(arg_124_0.vars.league_rank_list, iter_124_3)
	end
	
	if var_124_0 then
		table.remove(arg_124_0.vars.league_rank_list, var_124_0)
	end
end

function PvpSALW.updateItem(arg_125_0, arg_125_1, arg_125_2)
	arg_125_1:getChildByName("btn_more").parent = arg_125_0
	
	if arg_125_2.next_item then
		if_set_visible(arg_125_1, "page_next", true)
		if_set_visible(arg_125_1, "txt_name", false)
		if_set_visible(arg_125_1, "txt_rating", false)
		if_set_visible(arg_125_1, "n_clan", false)
		if_set_visible(arg_125_1, "n_emblem", false)
		if_set_visible(arg_125_1, "txt_clan_name", false)
		if_set_visible(arg_125_1, "LEFT", false)
		if_set_visible(arg_125_1, "RIGHT", false)
		if_set_visible(arg_125_1, "bar1_l_0", false)
		
		return 
	end
	
	if_set_visible(arg_125_1, "page_next", false)
	SpriteCache:resetSprite(arg_125_1:getChildByName("icon_league"), "emblem/" .. arg_125_2.emblem .. ".png")
	if_set(arg_125_1, "txt_name", arg_125_2.enemy_info.name)
	
	if to_n(arg_125_2.rank) > 3 then
		if_set_visible(arg_125_1, "txt_rank", true)
		if_set_visible(arg_125_1, "n_toprank", false)
		if_set(arg_125_1, "txt_rank", T("pvp_list_rank", {
			rank = arg_125_2.rank
		}))
	else
		if_set_visible(arg_125_1, "txt_rank", false)
		if_set_visible(arg_125_1, "n_toprank", true)
		
		local var_125_0 = arg_125_1:getChildByName("n_toprank")
		
		if_set_visible(var_125_0, "icon_menu_rankcup", true)
		if_set_visible(var_125_0, "icon_menu_rank", false)
		if_set(var_125_0, "txt_toprank", T("pvp_list_rank", {
			rank = arg_125_2.rank
		}))
	end
	
	local var_125_1 = arg_125_1:getChildByName("txt_rating")
	
	if_set_visible(arg_125_1, "n_clan", false)
	if_set_visible(arg_125_1, "n_emblem", false)
	if_set_visible(arg_125_1, "txt_clan_name", false)
	if_set_visible(arg_125_1, "n_season", false)
	if_set_visible(arg_125_1, "n_lastweek", true)
	
	local var_125_2 = (arg_125_2.enemy_info or {}).border_code
	local var_125_3 = (arg_125_2.enemy_info or {}).leader_code or "c1001"
	local var_125_4 = UNIT:create({
		code = var_125_3
	})
	
	UIUtil:getUserIcon(var_125_4, {
		no_lv = true,
		no_grade = true,
		parent = arg_125_1:getChildByName("n_face"),
		border_code = var_125_2
	})
	
	local var_125_5 = (arg_125_2.enemy_info or {}).clan
	
	if var_125_5 and var_125_5.name then
		if_set(arg_125_1, "txt_clan_name", var_125_5.name)
		UIUtil:updateClanEmblem(arg_125_1:getChildByName("n_emblem"), var_125_5)
		if_set_visible(arg_125_1, "n_emblem", true)
	end
	
	local var_125_6 = arg_125_1:getChildByName("n_lastweek")
	
	if_set(var_125_6, "t_score", T("result_base_npvp_victorypoint"))
	if_set(var_125_6, "t_score_count", comma_value(arg_125_2.score))
	
	return arg_125_1
end

PvpSATL = {}

copy_functions(ScrollView, PvpSATL)

function PvpSATL.clear(arg_126_0)
	arg_126_0.vars = nil
end

function PvpSATL.show(arg_127_0)
	arg_127_0.vars = {}
	arg_127_0.vars.parent = PvpSA:getBaseWnd():getChildByName("CENTER_3")
	
	local var_127_0 = arg_127_0.vars.parent:getChildByName("listview")
	
	if_set(arg_127_0.vars.parent, "txt_info", T("pvp_ranking_desc_total"))
	
	arg_127_0.vars.itemView = ItemListView_v2:bindControl(var_127_0)
	
	local var_127_1 = load_control("wnd/pvp_bar2.csb")
	
	if var_127_0.STRETCH_INFO then
		local var_127_2 = var_127_0:getContentSize()
		
		resetControlPosAndSize(var_127_1, var_127_2.width, var_127_0.STRETCH_INFO.width_prev)
	end
	
	local var_127_3 = {
		onUpdate = function(arg_128_0, arg_128_1, arg_128_2, arg_128_3)
			PvpSATL:updateItem(arg_128_1, arg_128_3)
			
			return arg_128_3.id
		end
	}
	
	arg_127_0.vars.itemView:setRenderer(var_127_1, var_127_3)
	arg_127_0.vars.itemView:removeAllChildren()
	arg_127_0.vars.itemView:setDataSource({})
	if_set_visible(arg_127_0.vars.parent, "n_lastweek_ranking", false)
	if_set_visible(arg_127_0.vars.parent, "n_season_ranking", false)
	if_set_visible(arg_127_0.vars.parent, "n_total_ranking", true)
	if_set_visible(arg_127_0.vars.parent:getChildByName("n_season_ranking"), "n_nodata", false)
	if_set_visible(arg_127_0.vars.parent:getChildByName("n_lastweek_ranking"), "n_nodata", false)
	
	local var_127_4 = arg_127_0.vars.parent:getChildByName("n_ranking_category")
	
	if var_127_4 then
		if_set_visible(var_127_4, "fg_category_total", true)
		if_set_visible(var_127_4, "fg_category_season", false)
		if_set_visible(var_127_4, "fg_category_lastweek", false)
		PvpSA:setRankingCategory("total")
	end
	
	query("pvp_sa_total_ranking", {
		page = 1
	})
end

function PvpSATL.update(arg_129_0, arg_129_1)
	if not arg_129_0.vars.league_rank_list then
		arg_129_0.vars.league_rank_list = {}
	end
	
	local var_129_0 = arg_129_0.vars.itemView:getDataSource() or {}
	local var_129_1 = table.count(var_129_0)
	
	arg_129_1.rank_list = arg_129_1.rank_list or {}
	arg_129_0.vars.league_rank_page = arg_129_1.page
	
	local var_129_2
	
	if arg_129_1.page == 1 or not arg_129_0.vars.league_rank_list then
		arg_129_0.vars.league_rank_list = arg_129_1.rank_list
	else
		arg_129_0:insertItems(arg_129_1.rank_list)
		
		var_129_2 = true
	end
	
	for iter_129_0, iter_129_1 in pairs(arg_129_0.vars.league_rank_list or {}) do
		if iter_129_1.enemy_info.id == Account:getUserId() then
			iter_129_1.enemy_info.name = AccountData.name
		end
		
		iter_129_1.emblem = DB("pvp_sa", iter_129_1.league, {
			"emblem"
		})
	end
	
	if #arg_129_1.rank_list > 0 then
		table.insert(arg_129_0.vars.league_rank_list, {
			next_item = true
		})
	end
	
	local var_129_3 = arg_129_0.vars.parent:getChildByName("n_my_rank")
	local var_129_4 = (PvpSA:getLobbyInfo() or {}).info
	
	if var_129_3 and var_129_4 then
		local var_129_5, var_129_6 = DB("pvp_sa", var_129_4.league, {
			"name",
			"emblem"
		})
		
		if_set(var_129_3, "t_rank_number", T("pvp_list_rank", {
			rank = var_129_4.rank
		}))
		if_set(var_129_3, "t_count", T(var_129_5))
		if_set_visible(var_129_3, "n_center", true)
		if_set_visible(var_129_3, "txt_score", true)
		if_set_visible(var_129_3, "txt_score_season", false)
		if_set(var_129_3, "txt_score", T("pvp_point", {
			point = comma_value(var_129_4.score or 0)
		}))
		SpriteCache:resetSprite(var_129_3:getChildByName("icon_league"), "emblem/" .. var_129_6 .. ".png")
		if_set_visible(var_129_3, "t_tier_placement", false)
		if_set_visible(var_129_3, "icon_league", true)
		if_set_visible(var_129_3, "keep", false)
	end
	
	arg_129_0.vars.itemView:setDataSource({})
	arg_129_0.vars.itemView:setDataSource(arg_129_0.vars.league_rank_list)
	
	if var_129_2 then
		arg_129_0.vars.itemView:forceDoLayout()
		arg_129_0.vars.itemView:jumpToIndex(var_129_1)
	end
end

function PvpSATL.nextPage(arg_130_0)
	query("pvp_sa_total_ranking", {
		page = arg_130_0.vars.league_rank_page + 1
	})
end

function PvpSATL.insertItems(arg_131_0, arg_131_1)
	local var_131_0
	
	for iter_131_0, iter_131_1 in pairs(arg_131_0.vars.league_rank_list) do
		if iter_131_1.next_item then
			var_131_0 = iter_131_0
		end
	end
	
	for iter_131_2, iter_131_3 in pairs(arg_131_1 or {}) do
		table.insert(arg_131_0.vars.league_rank_list, iter_131_3)
	end
	
	if var_131_0 then
		table.remove(arg_131_0.vars.league_rank_list, var_131_0)
	end
end

function PvpSATL.updateItem(arg_132_0, arg_132_1, arg_132_2)
	arg_132_1:getChildByName("btn_more").parent = arg_132_0
	
	if arg_132_2.next_item then
		if_set_visible(arg_132_1, "page_next", true)
		if_set_visible(arg_132_1, "txt_name", false)
		if_set_visible(arg_132_1, "txt_rating", false)
		if_set_visible(arg_132_1, "n_clan", false)
		if_set_visible(arg_132_1, "n_emblem", false)
		if_set_visible(arg_132_1, "txt_clan_name", false)
		if_set_visible(arg_132_1, "LEFT", false)
		if_set_visible(arg_132_1, "RIGHT", false)
		if_set_visible(arg_132_1, "bar1_l_0", false)
		
		return 
	end
	
	if_set_visible(arg_132_1, "page_next", false)
	SpriteCache:resetSprite(arg_132_1:getChildByName("icon_league"), "emblem/" .. arg_132_2.emblem .. ".png")
	if_set(arg_132_1, "txt_name", arg_132_2.enemy_info.name)
	
	if to_n(arg_132_2.rank) > 3 then
		if_set_visible(arg_132_1, "txt_rank", true)
		if_set_visible(arg_132_1, "n_toprank", false)
		if_set(arg_132_1, "txt_rank", T("pvp_list_rank", {
			rank = arg_132_2.rank
		}))
	else
		if_set_visible(arg_132_1, "txt_rank", false)
		if_set_visible(arg_132_1, "n_toprank", true)
		
		local var_132_0 = arg_132_1:getChildByName("n_toprank")
		
		if_set_visible(var_132_0, "icon_menu_rankcup", true)
		if_set_visible(var_132_0, "icon_menu_rank", false)
		if_set(var_132_0, "txt_toprank", T("pvp_list_rank", {
			rank = arg_132_2.rank
		}))
	end
	
	local var_132_1 = arg_132_1:getChildByName("txt_rating")
	
	if_set_visible(arg_132_1, "n_clan", false)
	if_set_visible(arg_132_1, "n_emblem", false)
	if_set_visible(arg_132_1, "txt_clan_name", false)
	
	for iter_132_0 = 1, 4 do
		if_set_visible(arg_132_1, "enemy" .. iter_132_0, false)
	end
	
	local var_132_2 = 0
	local var_132_3 = (arg_132_2.enemy_info or {}).border_code
	
	for iter_132_1, iter_132_2 in pairs(arg_132_2.enemy_info.units) do
		if iter_132_2.pos ~= 5 then
			var_132_2 = var_132_2 + 1
			
			local var_132_4 = arg_132_1:getChildByName("enemy" .. var_132_2)
			
			if var_132_4 then
				var_132_4:setVisible(true)
				
				local var_132_5 = UNIT:create(iter_132_2.unit)
				
				UIUtil:getUserIcon(var_132_5, {
					parent = var_132_4:getChildByName("n_face"),
					border_code = var_132_3,
					blind = PvpSA:isBlindDay()
				})
			end
		end
	end
	
	if_set(arg_132_1, "txt_rating", T("pvp_point", {
		point = comma_value(arg_132_2.score)
	}))
	
	return arg_132_1
end

PvpSAReward = {}

copy_functions(ScrollView, PvpSAReward)

function PvpSAReward.show(arg_133_0, arg_133_1)
	arg_133_0.vars = {}
	arg_133_0.vars.parent = arg_133_1
	
	if_set_visible(arg_133_0.vars.parent, "n_myinfo_arena", false)
	if_set_visible(arg_133_0.vars.parent, "n_league_arena", true)
	if_set_visible(arg_133_0.vars.parent, "n_record_arena", false)
	if_set_visible(arg_133_0.vars.parent, "fg_category_myinfo", false)
	if_set_visible(arg_133_0.vars.parent, "fg_category_league", true)
	if_set_visible(arg_133_0.vars.parent, "fg_category_record", false)
	
	arg_133_0.vars.scrollview = arg_133_1:getChildByName("scrollview")
	
	arg_133_0:initScrollView(arg_133_0.vars.scrollview, 975, 420)
	arg_133_0:createScrollViewItems({
		"legend",
		"champion",
		"challenger",
		"master",
		"gold",
		"silver",
		"bronze"
	})
	
	local var_133_0 = Account:getPvpInfo()
	
	if_set(arg_133_0.vars.parent, "txt_desc", T("ui_pvp_reward_desc", timeToStringDef({
		start_time = var_133_0.season_start_time,
		end_time = var_133_0.season_end_time
	})))
end

function PvpSAReward.getScrollViewItem(arg_134_0, arg_134_1)
	local var_134_0
	
	if arg_134_1 == "legend" then
		var_134_0 = load_control("wnd/pvp_reward_item2.csb")
	else
		var_134_0 = load_control("wnd/pvp_reward_item.csb")
	end
	
	local var_134_1, var_134_2, var_134_3 = DB("pvp_sa", arg_134_1 .. "_1", {
		"name_league",
		"emblem",
		"desc"
	})
	
	if_set(var_134_0, "txt_title", T(var_134_1))
	if_set(var_134_0, "txt_point_range", T(var_134_3))
	SpriteCache:resetSprite(var_134_0:getChildByName("logo"), "emblem/" .. var_134_2 .. ".png")
	
	for iter_134_0 = 1, 6 do
		local var_134_4, var_134_5, var_134_6, var_134_7, var_134_8, var_134_9, var_134_10, var_134_11, var_134_12 = DB("pvp_sa", arg_134_1 .. "_" .. iter_134_0, {
			"name",
			"rankup_point",
			"rankup_ratio",
			"rankup_ranking",
			"rankup_reward_id",
			"rankup_reward_count",
			"season_reward_id",
			"season_reward_count",
			"season_reward_count2"
		})
		
		if var_134_4 then
			local var_134_13 = var_134_0:getChildByName("n_bar" .. iter_134_0)
			
			if_set(var_134_13, "txt_grade", T(var_134_4))
			
			if var_134_8 then
				UIUtil:getRewardIcon(var_134_9, var_134_8, {
					scale = 1,
					detail = false,
					parent = var_134_13:getChildByName("n_item1")
				})
			end
			
			local var_134_14 = AccountData.season_period_db.season_reward_id
			
			if var_134_14 then
				UIUtil:getRewardIcon(var_134_12, var_134_14, {
					scale = 1,
					detail = false,
					parent = var_134_13:getChildByName("n_item2")
				})
			end
			
			local var_134_15, var_134_16, var_134_17, var_134_18 = DB("pvp_weekly_reward", arg_134_1 .. "_" .. iter_134_0, {
				"reward_id1",
				"reward_count1",
				"reward_id2",
				"reward_count2"
			})
			
			if var_134_15 and var_134_16 then
				UIUtil:getRewardIcon(var_134_16, var_134_15, {
					scale = 1,
					detail = false,
					parent = var_134_13:getChildByName("n_item3")
				})
			end
			
			if var_134_17 and var_134_18 then
				UIUtil:getRewardIcon(var_134_18, var_134_17, {
					scale = 1,
					detail = false,
					parent = var_134_13:getChildByName("n_item4")
				})
			end
			
			local var_134_19 = 0
			local var_134_20
			
			if var_134_5 then
				var_134_20 = T("pvp_point", {
					point = var_134_5
				})
			end
			
			if var_134_7 then
				if var_134_20 then
					var_134_20 = var_134_20 .. ", " .. T("pvp_rank", {
						rank = var_134_7
					})
				else
					var_134_20 = T("pvp_rank", {
						rank = var_134_7
					})
				end
			end
			
			if_set(var_134_13, "txt_point", var_134_20)
			
			if var_134_9 then
				if_set(var_134_13, "txt_reward1", var_134_9)
			else
				if_set(var_134_13, "txt_reward1", "")
			end
			
			if var_134_11 then
				if_set(var_134_13, "txt_reward2", var_134_11)
			else
				if_set(var_134_13, "txt_reward2", "")
			end
			
			if var_134_12 then
				if_set(var_134_13, "txt_reward3", var_134_12)
			else
				if_set(var_134_13, "txt_reward3", "")
			end
		end
	end
	
	return var_134_0
end

function PvpSAReward.onSelectScrollViewItem(arg_135_0, arg_135_1, arg_135_2)
end

PvpSAArenaInfo = {}

function PvpSAArenaInfo.show(arg_136_0, arg_136_1, arg_136_2)
	arg_136_0.vars = {}
	arg_136_0.vars.parent = arg_136_1
	arg_136_0.vars.info = arg_136_2
	
	if_set_visible(arg_136_0.vars.parent, "n_myinfo_arena", true)
	if_set_visible(arg_136_0.vars.parent, "n_league_arena", false)
	if_set_visible(arg_136_0.vars.parent, "n_record_arena", false)
	if_set_visible(arg_136_0.vars.parent, "fg_category_myinfo", true)
	if_set_visible(arg_136_0.vars.parent, "fg_category_league", false)
	if_set_visible(arg_136_0.vars.parent, "fg_category_record", false)
	arg_136_0:update()
end

function PvpSAArenaInfo.update(arg_137_0)
	local var_137_0 = arg_137_0.vars.info.info
	local var_137_1 = arg_137_0.vars.info.pvp_season_info
	local var_137_2 = var_137_1.season_period_info
	local var_137_3 = {}
	
	if var_137_1 then
		var_137_3 = var_137_1.season_period_db
	end
	
	local var_137_4 = arg_137_0.vars.parent:getChildByName("n_myinfo_arena")
	
	if_set(var_137_4, "txt_season_title", T(var_137_3.name))
	
	local var_137_5, var_137_6, var_137_7 = DB("pvp_sa", var_137_0.league, {
		"name",
		"emblem",
		"name_league"
	})
	local var_137_8 = var_137_4:getChildByName("icon_pvp_league")
	
	if_set(var_137_8, "txt_league_name", T(var_137_5))
	if_set(var_137_8, "txt_ranking", T("pvp_my_rank", {
		rank = comma_value(arg_137_0.vars.info.league_rank)
	}))
	SpriteCache:resetSprite(var_137_8, "emblem/" .. var_137_6 .. ".png")
	
	if to_n(var_137_2.season_no) == 0 then
		if_set_visible(var_137_4, "n_season_ranking", false)
		if_set_visible(var_137_4, "n_preseason_ranking", true)
	else
		if_set_visible(var_137_4, "n_preseason_ranking", false)
		
		local var_137_9 = var_137_4:getChildByName("n_season_ranking")
		
		var_137_9:setVisible(true)
		
		if var_137_2 and var_137_2.season_rank then
			if_set(var_137_9, "txt_ranking", T("pvp_list_rank", {
				rank = comma_value(var_137_2.season_rank)
			}))
		else
			if_set(var_137_9, "txt_ranking", T("pvp_season_rank_no"))
		end
		
		if var_137_2 and var_137_2.season_pt then
			if_set(var_137_9, "t_season_point", T("pvp_season_point", {
				season_point = comma_value(var_137_2.season_pt)
			}))
		else
			if_set(var_137_9, "t_season_point", T("pvp_season_point", {
				season_point = 0
			}))
		end
	end
	
	local var_137_10 = var_137_4:getChildByName("n_arena_record")
	
	if_set(var_137_10, "txt_score", T("pvp_point", {
		point = comma_value(var_137_0.score or 0)
	}))
	if_set(var_137_10, "txt_count_win", "")
	if_set(var_137_10, "txt_count_win", T("pvp_win_count", {
		count = comma_value(var_137_0.win_count or 0)
	}))
	if_set(var_137_10, "txt_count_conti_win", T("pvp_win_rapid", {
		count = comma_value(var_137_0.continuous_victory or 0)
	}))
	
	local var_137_11 = os.time()
	local var_137_12 = to_n(var_137_3.end_time_view) - var_137_11
	local var_137_13 = var_137_4:getChildByName("txt_season_title")
	
	if var_137_3 and var_137_12 / 86400 < to_n(var_137_3.end_term) then
		var_137_13:setPositionY(562)
		if_set(var_137_4, "txt_season_remaining", T("pvp_season_off", timeToStringDef({
			preceding_with_zeros = true,
			time = var_137_3.end_time_view
		})))
		if_set_visible(var_137_4, "txt_season_remaining", true)
	else
		var_137_13:setPositionY(548)
		if_set_visible(var_137_4, "txt_season_remaining", false)
	end
	
	local var_137_14 = var_137_1.season_end_time - var_137_11
	
	if_set(var_137_4, "txt_week_remaining", sec_to_full_string(var_137_14))
	
	local var_137_15 = var_137_4:getChildByName("n_vic")
	local var_137_16 = to_n(var_137_0.pvp_count)
	
	if var_137_16 > 0 then
		if_set(var_137_15, "t_vic", T("my_pvp_victory_percent", {
			percent = string.format("%.1f", to_n(var_137_0.win_count) / var_137_16 * 100)
		}))
	else
		if_set(var_137_15, "t_vic", T("my_pvp_victory_percent", {
			percent = "0.0"
		}))
	end
	
	if_set(var_137_15, "t_attack_result", T("my_pvp_attack_result", {
		win = to_n(var_137_0.win_count),
		defeat = var_137_16 - to_n(var_137_0.win_count)
	}))
	
	local var_137_17 = to_n(var_137_0.def_count)
	
	if var_137_17 > 0 then
		if_set(var_137_15, "t_def", T("my_pvp_defence_percent", {
			percent = string.format("%.1f", to_n(var_137_0.def_win_count) / var_137_17 * 100)
		}))
	else
		if_set(var_137_15, "t_def", T("my_pvp_defence_percent", {
			percent = "0.0"
		}))
	end
	
	if_set(var_137_15, "t_defence_result", T("my_pvp_defence_result", {
		win = to_n(var_137_0.def_win_count),
		defeat = var_137_17 - to_n(var_137_0.def_win_count)
	}))
	
	local var_137_18 = to_n(var_137_0.continuous_victory)
	local var_137_19
	
	for iter_137_0 = 1, 999 do
		local var_137_20 = {}
		
		var_137_20.id, var_137_20.step, var_137_20.count_min, var_137_20.count_max, var_137_20.bonus_point, var_137_20.bonus_item, var_137_20.bonus_item_value = DBN("pvp_streak", iter_137_0, {
			"id",
			"step",
			"count_min",
			"count_max",
			"bonus_point",
			"bonus_item",
			"bonus_item_value"
		})
		
		if not var_137_20.id then
			break
		end
		
		var_137_19 = var_137_20
		
		if var_137_18 >= var_137_20.count_min and var_137_18 <= var_137_20.count_max then
			break
		end
	end
	
	local var_137_21 = var_137_4:getChildByName("n_bonus")
	
	if var_137_19 and (to_n(var_137_19.bonus_point) > 0 or to_n(var_137_19.bonus_item_value) > 0) then
		if_set_visible(var_137_21, "n_pts", to_n(var_137_19.bonus_point) > 0)
		
		if to_n(var_137_19.bonus_point) > 0 then
			if_set(var_137_21, "t_pts", T("pvp_streak_bonus_point", {
				bonus_point = var_137_19.bonus_point
			}))
		end
		
		if_set_visible(var_137_21, "n_con_point", to_n(var_137_19.bonus_item_value) > 0)
		
		if to_n(var_137_19.bonus_item_value) > 0 then
			UIUtil:getRewardIcon(nil, var_137_19.bonus_item, {
				show_small_count = false,
				show_name = false,
				detail = false,
				parent = var_137_21:getChildByName("n_bonus_item")
			})
			if_set(var_137_21, "txt_bonus_value", T("pvp_streak_bonus_item", {
				bonus_item = var_137_19.bonus_item_value
			}))
		end
		
		if_set_visible(var_137_21, "n_bonus_on", true)
		if_set_visible(var_137_21, "n_nodata", false)
	else
		if_set_visible(var_137_21, "n_bonus_on", false)
		if_set_visible(var_137_21, "n_nodata", true)
	end
	
	WidgetUtils:setupTooltip({
		control = var_137_21:getChildByName("btn_bonus"),
		creator = function()
			return PvpSAArenaInfo:bonus_tooltip(var_137_18)
		end
	})
end

function PvpSAArenaInfo.bonus_tooltip(arg_139_0, arg_139_1)
	local var_139_0 = load_dlg("pvp_bonus_tooltip", true, "wnd")
	local var_139_1 = to_n(arg_139_1)
	local var_139_2 = {}
	local var_139_3 = 0
	
	for iter_139_0 = 1, 999 do
		local var_139_4 = {}
		
		var_139_4.id, var_139_4.step, var_139_4.count_min, var_139_4.count_max, var_139_4.bonus_point, var_139_4.bonus_item, var_139_4.bonus_item_value = DBN("pvp_streak", iter_139_0, {
			"id",
			"step",
			"count_min",
			"count_max",
			"bonus_point",
			"bonus_item",
			"bonus_item_value"
		})
		
		if not var_139_4.id then
			break
		end
		
		var_139_3 = math.max(var_139_4.step, var_139_3)
		var_139_2[var_139_4.step] = var_139_4
	end
	
	for iter_139_1, iter_139_2 in pairs(var_139_2) do
		if iter_139_2.step == var_139_3 then
			if_set(var_139_0:getChildByName("lv_" .. iter_139_2.step), "t_value", T("ui_pvp_bonus_step_end", {
				min = iter_139_2.count_min
			}))
		else
			if_set(var_139_0:getChildByName("lv_" .. iter_139_2.step), "t_value", T("ui_pvp_bonus_step", {
				min = iter_139_2.count_min,
				max = iter_139_2.count_max
			}))
		end
		
		if iter_139_2.step > 1 then
			if_set(var_139_0:getChildByName("balloon_" .. iter_139_2.step), "disc", T("pvp_streak_bonus_point", {
				bonus_point = iter_139_2.bonus_point
			}))
			if_set(var_139_0:getChildByName("balloon_" .. iter_139_2.step), "disc_2", T("pvp_streak_bonus_item", {
				bonus_item = iter_139_2.bonus_item_value
			}))
		end
		
		if_set_visible(var_139_0, "balloon_" .. iter_139_2.step, true)
		
		if var_139_1 >= iter_139_2.count_min and var_139_1 <= iter_139_2.count_max then
			if_set_visible(var_139_0:getChildByName("lv_" .. iter_139_2.step), "bg_area", true)
		else
			if_set_visible(var_139_0:getChildByName("lv_" .. iter_139_2.step), "bg_area", false)
		end
	end
	
	return var_139_0
end

PvpSARecordInfo = {}

function PvpSARecordInfo.show(arg_140_0, arg_140_1)
	arg_140_0.vars = {}
	arg_140_0.vars.parent = arg_140_1
	
	if_set_visible(arg_140_0.vars.parent, "n_myinfo_arena", false)
	if_set_visible(arg_140_0.vars.parent, "n_league_arena", false)
	if_set_visible(arg_140_0.vars.parent, "n_record_arena", true)
	if_set_visible(arg_140_0.vars.parent, "fg_category_myinfo", false)
	if_set_visible(arg_140_0.vars.parent, "fg_category_league", false)
	if_set_visible(arg_140_0.vars.parent, "fg_category_record", true)
	
	if not arg_140_0.record_history then
		query("pvp_sa_record_history")
	else
		arg_140_0:update()
	end
end

function PvpSARecordInfo.update(arg_141_0, arg_141_1)
	if arg_141_1 then
		arg_141_0.record_history = arg_141_1
	end
	
	if not arg_141_0.record_history then
		return 
	end
	
	local var_141_0 = arg_141_0.record_history.current_week_id
	local var_141_1 = arg_141_0.vars.parent:getChildByName("n_record_arena")
	
	for iter_141_0 = 1, 5 do
		local var_141_2 = var_141_1:getChildByName("n_chart_" .. iter_141_0)
		
		var_141_2:removeAllChildren()
		
		local var_141_3 = arg_141_0:setItem(var_141_0 - (iter_141_0 - 1))
		
		if var_141_3 then
			var_141_2:addChild(var_141_3)
		end
	end
	
	if arg_141_0.record_history.max_week_id and arg_141_0.record_history.records[tostring(arg_141_0.record_history.max_week_id)] then
		local var_141_4 = to_n(arg_141_0.record_history.records[tostring(arg_141_0.record_history.max_week_id)].score)
		local var_141_5 = var_141_1:getChildByName("n_chart_top")
		
		var_141_5:removeAllChildren()
		
		local var_141_6 = arg_141_0:setItem(arg_141_0.record_history.max_week_id, true)
		
		if var_141_6 then
			var_141_5:addChild(var_141_6)
		end
	end
end

function PvpSARecordInfo.setItem(arg_142_0, arg_142_1, arg_142_2)
	if arg_142_0.record_history == nil then
		return 
	end
	
	local var_142_0 = load_control("wnd/pvp_chart_item.csb")
	local var_142_1 = arg_142_0.record_history.current_week_id - arg_142_1
	
	if var_142_1 == 0 then
		if_set_visible(var_142_0, "current", true)
		if_set_visible(var_142_0, "txt_time", false)
	elseif var_142_1 == 1 then
		if_set_visible(var_142_0, "current", false)
		if_set_visible(var_142_0, "txt_time", true)
		if_set(var_142_0, "txt_time", T("time_last_week"))
	elseif var_142_1 >= 5 then
		if_set_visible(var_142_0, "current", false)
		if_set_visible(var_142_0, "txt_time", true)
		if_set(var_142_0, "txt_time", T("time_last_week"))
	else
		if_set_visible(var_142_0, "current", false)
		if_set_visible(var_142_0, "txt_time", true)
		if_set(var_142_0, "txt_time", T("time_week_before", {
			week = var_142_1
		}))
	end
	
	local var_142_2 = arg_142_0.record_history.records[tostring(arg_142_1)]
	
	if var_142_2 then
		local var_142_3 = var_142_0:getChildByName("n_progress1")
		local var_142_4 = 0
		
		if var_142_2.pvp_count > 0 then
			var_142_4 = var_142_2.win_count / var_142_2.pvp_count
			
			if var_142_2.win_count == var_142_2.pvp_count then
				if_set(var_142_3, "t_att_per", "100%")
			else
				if_set(var_142_3, "t_att_per", string.format("%.1f", var_142_4 * 100) .. "%")
			end
		else
			if_set(var_142_3, "t_att_per", "0.0%")
		end
		
		if_set(var_142_3, "t_count", var_142_2.win_count .. "/" .. var_142_2.pvp_count)
		arg_142_0:setBarPercent(var_142_3, var_142_4)
		
		local var_142_5 = var_142_3:getChildByName("progress_bar"):getContentSize().width
		
		var_142_3:getChildByName("icon_att"):setPositionX(var_142_5 + 31)
		
		local var_142_6 = var_142_0:getChildByName("n_progress2")
		local var_142_7 = 0
		
		if var_142_2.def_count > 0 then
			var_142_7 = var_142_2.def_win_count / var_142_2.def_count
			
			if var_142_2.def_win_count == var_142_2.def_count then
				if_set(var_142_6, "t_def_per", "100%")
			else
				if_set(var_142_6, "t_def_per", string.format("%.1f", var_142_7 * 100) .. "%")
			end
		else
			if_set(var_142_6, "t_def_per", "0.0%")
		end
		
		if_set(var_142_6, "t_count", var_142_2.def_win_count .. "/" .. var_142_2.def_count)
		arg_142_0:setBarPercent(var_142_6, var_142_7)
		
		local var_142_8 = var_142_6:getChildByName("progress_bar"):getContentSize().width
		
		var_142_6:getChildByName("icon_def"):setPositionX(var_142_8 + 31)
		
		local var_142_9 = var_142_0:getChildByName("n_info")
		local var_142_10, var_142_11, var_142_12 = DB("pvp_sa", var_142_2.league, {
			"name",
			"emblem",
			"name_league"
		})
		
		if_set(var_142_9, "txt_rank", T(var_142_10))
		if_set(var_142_9, "txt_total_rank", T("pvp_point2", {
			point = var_142_2.score
		}))
		SpriteCache:resetSprite(var_142_9:getChildByName("icon_league"), "emblem/" .. var_142_11 .. ".png")
		
		if arg_142_2 then
			if var_142_1 > 0 then
				if_set_visible(var_142_0, "current", false)
				if_set_visible(var_142_0, "txt_time", true)
				if_set(var_142_0, "txt_time", T("time_slash_y_m_d", timeToStringDef({
					preceding_with_zeros = true,
					time = var_142_2.end_time
				})))
			else
				if_set_visible(var_142_0, "current", true)
				if_set_visible(var_142_0, "txt_time", false)
			end
		end
		
		if_set_visible(var_142_0, "n_progress1", true)
		if_set_visible(var_142_0, "n_progress2", true)
		if_set_visible(var_142_0, "n_info", true)
	else
		if_set_visible(var_142_0, "n_progress1", false)
		if_set_visible(var_142_0, "n_progress2", false)
		if_set_visible(var_142_0, "n_info", false)
	end
	
	return var_142_0
end

function PvpSARecordInfo.setBarPercent(arg_143_0, arg_143_1, arg_143_2)
	local var_143_0 = arg_143_1:getChildByName("progress_bar")
	local var_143_1 = var_143_0:getContentSize()
	
	var_143_0:setContentSize({
		width = var_143_1.width * arg_143_2,
		height = var_143_1.height
	})
end

PvpSAMyRanking = {}

function PvpSAMyRanking.clear(arg_144_0)
	arg_144_0.vars = nil
end

function PvpSAMyRanking.show(arg_145_0, arg_145_1)
	arg_145_0.vars = {}
	arg_145_0.vars.mode = PvpSA:getRankingCategory()
	
	if not arg_145_0.vars.mode then
		arg_145_0.vars.mode = "season"
	end
	
	arg_145_0.vars.parent = load_dlg("pvp_myrank", true, "wnd", function()
		Dialog:closeAll()
		BackButtonManager:pop("pvp_myrank")
	end)
	
	Dialog:msgBox(nil, {
		no_back_button = true,
		dlg = arg_145_0.vars.parent,
		handler = function(arg_147_0, arg_147_1)
			if arg_147_1 == "btn_close" then
				return 
			end
			
			if string.starts(arg_147_1, "btn_category_") then
				PvpSAMyRanking:changeCategory(arg_147_1)
			end
			
			return "dont_close"
		end
	})
	if_set_visible(arg_145_0.vars.parent:getChildByName("n_season_ranking"), "n_nodata", false)
	if_set_visible(arg_145_0.vars.parent:getChildByName("n_lastweek_ranking"), "n_nodata", false)
	query("pvp_sa_my_ranking", {
		ranking_type = arg_145_0.vars.mode
	})
end

function PvpSAMyRanking.changeCategory(arg_148_0, arg_148_1)
	local var_148_0 = string.split(arg_148_1, "_")[3]
	
	if var_148_0 == nil or var_148_0 == arg_148_0.vars.mode then
		return 
	end
	
	arg_148_0.vars.mode = var_148_0
	
	query("pvp_sa_my_ranking", {
		ranking_type = arg_148_0.vars.mode
	})
end

function PvpSAMyRanking.update(arg_149_0, arg_149_1)
	if arg_149_1 == nil or arg_149_1.ranking_type == nil then
		return 
	end
	
	local var_149_0 = arg_149_1.rank_list == nil
	
	arg_149_1.rank_list = arg_149_1.rank_list or {}
	
	local var_149_1 = arg_149_0.vars.parent:getChildByName("n_category")
	
	if_set_visible(var_149_1, "fg_category_season", false)
	if_set_visible(var_149_1, "fg_category_total", false)
	if_set_visible(var_149_1, "fg_category_lastweek", false)
	if_set_visible(var_149_1, "fg_category_" .. arg_149_0.vars.mode, true)
	if_set_visible(arg_149_0.vars.parent, "n_season_ranking", false)
	if_set_visible(arg_149_0.vars.parent, "n_total_ranking", false)
	if_set_visible(arg_149_0.vars.parent, "n_lastweek_ranking", false)
	
	local var_149_2 = arg_149_0.vars.parent:getChildByName("n_" .. arg_149_0.vars.mode .. "_ranking")
	
	var_149_2:setVisible(true)
	if_set_visible(var_149_2, "n_nodata", false)
	
	local var_149_3 = PvpSA:getLobbyInfo().pvp_season_info.season_period_info
	
	if var_149_3 then
		if arg_149_0.vars.mode == "season" then
			if to_n(var_149_3.season_no) == 0 then
				if_set(var_149_2, "txt_nodata", T("ui_pvp_base_srank_total"))
				if_set_visible(var_149_2, "n_nodata", true)
			elseif to_n(var_149_3.season_no) < 2 then
				if_set(var_149_2, "txt_nodata", T("ui_pvp_base_tab4_desc"))
				if_set_visible(var_149_2, "n_nodata", true)
			elseif table.count(arg_149_1.rank_list) == 0 then
				if_set(var_149_2, "txt_nodata", T("ui_pvp_base_noseason_myrank"))
				if_set_visible(var_149_2, "n_nodata", true)
			end
		elseif arg_149_0.vars.mode == "lastweek" and table.count(arg_149_1.rank_list) == 0 then
			if var_149_0 then
				if_set(var_149_2, "txt_nodata", T("pvp_no_lastweek_rank"))
			else
				if_set(var_149_2, "txt_nodata", T("ui_pvp_base_srank_total"))
			end
			
			if_set_visible(var_149_2, "n_nodata", true)
		end
	end
	
	for iter_149_0 = 1, 5 do
		local var_149_4 = var_149_2:getChildByName("n_" .. iter_149_0)
		local var_149_5 = var_149_4:getChildByName("n_item")
		
		var_149_5:removeAllChildren()
		if_set_visible(var_149_4, "bg", false)
		
		local var_149_6 = arg_149_1.rank_list[iter_149_0]
		
		if var_149_6 then
			if var_149_6.enemy_info.id == Account:getUserId() then
				var_149_6.enemy_info.name = AccountData.name
			end
			
			var_149_6.emblem = DB("pvp_sa", var_149_6.league, {
				"emblem"
			})
			
			local var_149_7 = arg_149_0:updateItem(var_149_6)
			
			if var_149_7 then
				if var_149_6.enemy_info then
					if_set_visible(var_149_4, "bg", var_149_6.enemy_info.id == AccountData.id)
				end
				
				var_149_5:addChild(var_149_7)
			end
		end
	end
end

function PvpSAMyRanking.updateItem(arg_150_0, arg_150_1)
	if not arg_150_1 then
		return nil
	end
	
	local var_150_0
	local var_150_9, var_150_10
	
	if arg_150_0.vars.mode == "season" then
		var_150_0 = load_control("wnd/pvp_bar_myrank_season.csb")
		
		if_set_visible(var_150_0, "icon_league", false)
		if_set_visible(var_150_0, "n_r", true)
		if_set_visible(var_150_0, "n_season", true)
		if_set_visible(var_150_0, "n_last_week", false)
		if_set(var_150_0, "txt_rank", T("pvp_list_rank", {
			rank = arg_150_1.season_rank
		}))
		
		local var_150_1 = (arg_150_1.enemy_info or {}).border_code
		local var_150_2 = (arg_150_1.enemy_info or {}).leader_code or "c1001"
		local var_150_3 = UNIT:create({
			code = var_150_2
		})
		
		UIUtil:getUserIcon(var_150_3, {
			no_lv = true,
			no_grade = true,
			parent = var_150_0:getChildByName("n_face"),
			border_code = var_150_1
		})
		
		local var_150_4 = var_150_0:getChildByName("n_season")
		
		if_set(var_150_4, "txt_point", comma_value(arg_150_1.season_pt))
		if_set(var_150_4, "txt_season", T("pvp_seasonpoint_name"))
	elseif arg_150_0.vars.mode == "lastweek" then
		var_150_0 = load_control("wnd/pvp_bar_myrank_season.csb")
		
		if_set_visible(var_150_0, "icon_league", true)
		if_set_visible(var_150_0, "n_r", false)
		if_set_visible(var_150_0, "n_season", false)
		if_set_visible(var_150_0, "n_last_week", true)
		
		if arg_150_1.emblem then
			SpriteCache:resetSprite(var_150_0:getChildByName("icon_league"), "emblem/" .. arg_150_1.emblem .. ".png")
		end
		
		if_set(var_150_0, "txt_rank", T("pvp_list_rank", {
			rank = arg_150_1.rank
		}))
		
		local var_150_5 = (arg_150_1.enemy_info or {}).border_code
		local var_150_6 = (arg_150_1.enemy_info or {}).leader_code or "c1001"
		local var_150_7 = UNIT:create({
			code = var_150_6
		})
		
		UIUtil:getUserIcon(var_150_7, {
			no_lv = true,
			no_grade = true,
			parent = var_150_0:getChildByName("n_face"),
			border_code = var_150_5
		})
		
		local var_150_8 = var_150_0:getChildByName("n_last_week")
		
		if_set(var_150_8, "txt_score", T("pvp_victorypoint"))
		if_set(var_150_8, "txt_score_count", comma_value(arg_150_1.score))
	else
		var_150_0 = load_control("wnd/pvp_bar_myrank_total.csb")
		
		if_set_visible(var_150_0, "icon_league", true)
		if_set_visible(var_150_0, "n_r", false)
		
		if arg_150_1.emblem then
			SpriteCache:resetSprite(var_150_0:getChildByName("icon_league"), "emblem/" .. arg_150_1.emblem .. ".png")
		end
		
		if_set(var_150_0, "txt_rank", T("pvp_list_rank", {
			rank = arg_150_1.rank
		}))
		if_set(var_150_0, "txt_rating", T("pvp_point", {
			point = comma_value(arg_150_1.score)
		}))
		
		for iter_150_0 = 1, 4 do
			if_set_visible(var_150_0, "enemy" .. iter_150_0, false)
		end
		
		var_150_9 = 0
		var_150_10 = (arg_150_1.enemy_info or {}).border_code
		
		for iter_150_1, iter_150_2 in pairs(arg_150_1.enemy_info.units) do
			if iter_150_2.pos ~= 5 then
				var_150_9 = var_150_9 + 1
				
				local var_150_11 = var_150_0:getChildByName("enemy" .. var_150_9)
				
				if var_150_11 then
					var_150_11:setVisible(true)
					
					local var_150_12 = UNIT:create(iter_150_2.unit)
					
					UIUtil:getUserIcon(var_150_12, {
						parent = var_150_11:getChildByName("n_face"),
						border_code = var_150_10,
						blind = PvpSA:isBlindDay()
					})
				end
			end
		end
	end
	
	if_set_visible(var_150_0, "page_next", false)
	if_set(var_150_0, "txt_name", arg_150_1.enemy_info.name)
	if_set_visible(var_150_0, "txt_rank", true)
	if_set_visible(var_150_0, "n_clan", false)
	if_set_visible(var_150_0, "n_emblem", false)
	if_set_visible(var_150_0, "txt_clan_name", false)
	
	return var_150_0
end

PvpSAHOF = {}

function PvpSAHOF.clear(arg_151_0)
	arg_151_0.vars = nil
end

function PvpSAHOF.show(arg_152_0, arg_152_1)
	arg_152_0.vars = {}
	arg_152_0.vars.parent = arg_152_1
	arg_152_0.vars.listview = arg_152_1:getChildByName("listview")
	
	arg_152_0.vars.listview:removeAllChildren()
	query("pvp_hall_of_fame")
end

function PvpSAHOF.setCharPort(arg_153_0, arg_153_1, arg_153_2, arg_153_3)
	local var_153_0 = ur.ModelStage:create(CACHE:getModel(arg_153_2.db))
	
	var_153_0:setScaleX(-1)
	
	if var_153_0.model.setAnimation then
		UIAction:Add(SEQ(DELAY(math.random(0, 100)), CALL(function()
			var_153_0.model:setNoSoundAniFlag("b_idle_ready", arg_153_3)
		end), MOTION("idle", true), CALL(function()
			var_153_0.model:setNoSoundAniFlag("idle", false)
		end)), var_153_0.model, "block")
	end
	
	arg_153_1:addChild(var_153_0)
end

function PvpSAHOF.setPosRankNode(arg_156_0, arg_156_1)
	local var_156_0 = arg_156_1:findChildByName("n_1") or arg_156_1:findChildByName("n_info1")
	local var_156_1 = arg_156_1:findChildByName("n_2") or arg_156_1:findChildByName("n_info2")
	local var_156_2 = arg_156_1:findChildByName("n_3") or arg_156_1:findChildByName("n_info3")
	
	if var_156_2 and not var_156_2._origin_pos_x then
		var_156_2._origin_pos_x = var_156_2:getPositionX()
	end
	
	local var_156_3 = 1580
	local var_156_4 = 283 * ((VIEW_WIDTH - DESIGN_WIDTH - NOTCH_WIDTH / 2) / (var_156_3 - DESIGN_WIDTH))
	
	var_156_2:setPositionX(var_156_2._origin_pos_x + var_156_4)
	
	local var_156_5 = var_156_0:getPositionX()
	
	var_156_1:setPositionX((var_156_2:getPositionX() - var_156_5) / 2 + var_156_5)
	if_set_position_x(arg_156_1, "n_pos1_character", var_156_5)
	if_set_position_x(arg_156_1, "n_pos2_character", var_156_1:getPositionX())
	if_set_position_x(arg_156_1, "n_pos3_character", var_156_2:getPositionX())
end

function PvpSAHOF.update(arg_157_0, arg_157_1)
	if arg_157_1.hall_of_fame == nil or table.count(arg_157_1.hall_of_fame) == 0 then
		Dialog:msgBox(T("pvp_honor_wait"), {
			title = T("pvp_honor_title"),
			handler = function()
				PvpSA:rightMenu("main")
			end
		})
		
		return 
	end
	
	local var_157_0 = {}
	local var_157_1 = 0
	
	for iter_157_0, iter_157_1 in pairs(arg_157_1.hall_of_fame) do
		var_157_0[to_n(iter_157_0)] = iter_157_1
		var_157_1 = math.max(var_157_1, to_n(iter_157_0))
	end
	
	arg_157_0.vars.hall_of_fame = var_157_0
	
	if var_157_1 == 0 then
		return 
	end
	
	local var_157_2 = var_157_0[var_157_1]
	
	if not var_157_2 then
		return 
	end
	
	local var_157_3 = PvpSA:getLobbyInfo().pvp_season_info.season_period_info
	local var_157_4 = load_dlg("hall_of_fame_card_l", true, "wnd")
	
	arg_157_0.vars.listview:addChild(var_157_4)
	
	local var_157_5
	
	if UIUtil:isChangeSeasonLabelPosition() then
		var_157_5 = var_157_4:getChildByName("n_season_2/2")
		
		var_157_5:setVisible(true)
		if_set_visible(var_157_4, "n_season_1/2", false)
	else
		var_157_5 = var_157_4:getChildByName("n_season_1/2")
		
		var_157_5:setVisible(true)
		if_set_visible(var_157_4, "n_season_2/2", false)
	end
	
	if_set(var_157_5, "txt_season_number", T(var_157_2.db.name_short))
	if_set(var_157_4, "txt_season_period", T("season_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_157_2.db.start_time,
		end_time = var_157_2.db.end_time
	})))
	
	local var_157_6 = var_157_4:getChildByName("n_season_honor")
	
	for iter_157_2 = 1, 3 do
		local var_157_7 = var_157_2.winners[iter_157_2]
		local var_157_8 = var_157_4:getChildByName("n_info" .. iter_157_2)
		
		if var_157_7 then
			var_157_8:setVisible(true)
			
			local var_157_9 = var_157_4:getChildByName("n_pos" .. iter_157_2 .. "_character")
			
			if_set(var_157_8, "txt_user_name", var_157_7.name)
			
			local var_157_10 = var_157_7.border_code
			local var_157_11 = UNIT:create({
				code = var_157_7.leader_code
			})
			
			arg_157_0:setCharPort(var_157_9, var_157_11, iter_157_2 ~= 1)
			UIUtil:getUserIcon(var_157_11, {
				no_popup = true,
				no_lv = true,
				no_role = true,
				no_grade = true,
				parent = var_157_8:getChildByName("mob_icon_" .. iter_157_2),
				border_code = var_157_10
			})
			
			if var_157_7.clan_name and var_157_7.clan_emblem then
				if_set_visible(var_157_8, "txt_clan_name", true)
				UIUtil:updateClanEmblem(var_157_8, var_157_7, {
					var_name = "clan_emblem"
				})
				if_set(var_157_8, "txt_clan_name", var_157_7.clan_name)
				
				local var_157_12 = 0.75 / var_157_8:getChildByName("txt_clan_name"):getScaleX()
				
				var_157_8:getChildByName("n_emblem"):setScaleX(0.15 * var_157_12)
			else
				if_set_visible(var_157_8, "txt_clan_name", false)
			end
		else
			var_157_8:setVisible(false)
		end
	end
	
	arg_157_0:setPosRankNode(var_157_4)
	
	if var_157_1 == 1 then
		return 
	end
	
	local var_157_13 = var_157_1 - 1
	local var_157_14 = 0
	
	for iter_157_3 = var_157_13, 1, -1 do
		local var_157_15 = var_157_0[iter_157_3]
		
		if var_157_15 then
			var_157_14 = var_157_14 + 1
			
			local var_157_16 = load_dlg("hall_of_fame_card_s", true, "wnd")
			
			if arg_157_0.vars.listview.STRETCH_INFO then
				local var_157_17 = arg_157_0.vars.listview:getContentSize()
				
				resetControlPosAndSize(var_157_16:findChildByName("bar_"), var_157_17.width, arg_157_0.vars.listview.STRETCH_INFO.width_prev)
			end
			
			arg_157_0.vars.listview:addChild(var_157_16)
			
			local var_157_18
			
			if UIUtil:isChangeSeasonLabelPosition() then
				var_157_18 = var_157_16:getChildByName("n_season_2/2")
				
				var_157_18:setVisible(true)
				if_set_visible(var_157_16, "n_season_1/2", false)
			else
				var_157_18 = var_157_16:getChildByName("n_season_1/2")
				
				var_157_18:setVisible(true)
				if_set_visible(var_157_16, "n_season_2/2", false)
			end
			
			if_set(var_157_18, "txt_season_number", T(var_157_15.db.name_short))
			if_set(var_157_16, "txt_season_period", T("season_period", timeToStringDef({
				preceding_with_zeros = true,
				start_time = var_157_15.db.start_time,
				end_time = var_157_15.db.end_time
			})))
			
			local var_157_19 = var_157_16:getChildByName("n_season_honor")
			
			for iter_157_4 = 1, 3 do
				local var_157_20 = var_157_15.winners[iter_157_4]
				local var_157_21 = var_157_16:getChildByName("n_" .. iter_157_4)
				
				if var_157_20 then
					var_157_21:setVisible(true)
					if_set(var_157_21, "txt_user_name", var_157_20.name)
					
					local var_157_22 = var_157_20.border_code
					local var_157_23 = UNIT:create({
						code = var_157_20.leader_code
					})
					
					UIUtil:getUserIcon(var_157_23, {
						no_popup = true,
						no_lv = true,
						no_role = true,
						no_grade = true,
						parent = var_157_21:getChildByName("mob_icon_" .. iter_157_4),
						border_code = var_157_22
					})
					
					if var_157_20.clan_name and var_157_20.clan_emblem then
						if_set_visible(var_157_21, "txt_clan_name", true)
						UIUtil:updateClanEmblem(var_157_21, var_157_20, {
							var_name = "clan_emblem"
						})
						if_set(var_157_21, "txt_clan_name", var_157_20.clan_name)
					else
						if_set_visible(var_157_21, "txt_clan_name", false)
					end
				else
					var_157_21:setVisible(false)
				end
			end
			
			arg_157_0:setPosRankNode(var_157_16)
		end
	end
	
	arg_157_0.vars.listview:setInnerContainerSize({
		width = 727,
		height = 473 + var_157_14 * 228
	})
end

function PvpSAHOF.popupNewSeasonPeriod(arg_159_0, arg_159_1, arg_159_2)
	arg_159_1 = arg_159_1 or arg_159_0.vars.hall_of_fame
	
	local var_159_0 = {}
	local var_159_1 = 0
	
	for iter_159_0, iter_159_1 in pairs(arg_159_1) do
		var_159_0[to_n(iter_159_0)] = iter_159_1
		var_159_1 = math.max(var_159_1, to_n(iter_159_0))
	end
	
	if var_159_1 == 0 then
		return 
	end
	
	local var_159_2 = var_159_0[var_159_1]
	
	if not var_159_2 then
		return 
	end
	
	local var_159_3 = load_dlg("pvp_season_change_honor", true, "wnd")
	
	if_set(var_159_3, "txt_title", T("pvp_season_change_heroes_title", {
		season_name = T(var_159_2.db.name)
	}))
	
	local var_159_4 = var_159_3:getChildByName("n_season_info")
	local var_159_5
	
	if UIUtil:isChangeSeasonLabelPosition() then
		var_159_5 = var_159_4:getChildByName("n_season_2/2")
		
		var_159_5:setVisible(true)
		if_set_visible(var_159_4, "n_season_1/2", false)
	else
		var_159_5 = var_159_4:getChildByName("n_season_1/2")
		
		var_159_5:setVisible(true)
		if_set_visible(var_159_4, "n_season_2/2", false)
	end
	
	if_set(var_159_5, "txt_season_number", T(var_159_2.db.name_short))
	if_set(var_159_4, "txt_season_period", T("season_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_159_2.db.start_time,
		end_time = var_159_2.db.end_time
	})))
	
	local var_159_6 = var_159_3:getChildByName("n_season_honor")
	
	for iter_159_2 = 1, 3 do
		local var_159_7 = var_159_2.winners[iter_159_2]
		local var_159_8 = var_159_3:getChildByName("n_" .. iter_159_2)
		
		if var_159_7 then
			var_159_8:setVisible(true)
			if_set(var_159_8, "txt_user_name", var_159_7.name)
			if_set(var_159_8, "txt_season_point", T("pvp_season_point", {
				season_point = comma_value(var_159_7.season_pt)
			}))
			
			local var_159_9 = var_159_7.border_code
			local var_159_10 = UNIT:create({
				code = var_159_7.leader_code
			})
			
			UIUtil:getUserIcon(var_159_10, {
				no_popup = true,
				no_lv = true,
				no_role = true,
				no_grade = true,
				parent = var_159_8:getChildByName("mob_icon_" .. iter_159_2),
				border_code = var_159_9
			})
			if_set(var_159_8, "txt_clan", var_159_7.clan_name)
			UIUtil:updateClanEmblem(var_159_8:getChildByName("n_clan"), {
				emblem = var_159_7.clan_emblem
			})
			if_set_visible(var_159_8, "n_clan", string.len(var_159_7.clan_name or "") > 0)
			
			local var_159_11 = string.len(var_159_7.clan_name or "") > 0 and 0 or 23
			
			if_set_add_position_y(var_159_8, "txt_season_point", var_159_11)
			if_set_add_position_y(var_159_8, "txt_nation", var_159_11)
			
			local var_159_12 = 0.73 / var_159_8:getChildByName("txt_clan"):getScaleX()
			
			var_159_8:getChildByName("emblem_bg"):setScaleX(0.19 * var_159_12)
		else
			var_159_8:setVisible(false)
		end
	end
	
	Dialog:msgBox(nil, {
		dlg = var_159_3,
		handler = arg_159_2
	})
end

PvpSABattleLog = {}

copy_functions(ScrollView, PvpSABattleLog)

function PvpSABattleLog.clear(arg_160_0)
	arg_160_0.vars = nil
end

function PvpSABattleLog.show(arg_161_0, arg_161_1, arg_161_2)
	if arg_161_0.vars then
		return 
	end
	
	arg_161_0.vars = {}
	arg_161_0.vars.parent = arg_161_1
	
	local var_161_0 = arg_161_1:getChildByName("listview")
	
	arg_161_0.vars.itemView = ItemListView_v2:bindControl(var_161_0)
	
	local var_161_1 = load_control("wnd/pvp_rank_bar.csb")
	
	if var_161_0.STRETCH_INFO then
		local var_161_2 = var_161_0:getContentSize()
		
		resetControlPosAndSize(var_161_1, var_161_2.width, var_161_0.STRETCH_INFO.width_prev)
	end
	
	local var_161_3 = {
		onUpdate = function(arg_162_0, arg_162_1, arg_162_2, arg_162_3)
			PvpSABattleLog:updateItem(arg_162_1, arg_162_3)
			
			return arg_162_3.id
		end
	}
	
	arg_161_0.vars.itemView:setRenderer(var_161_1, var_161_3)
	arg_161_0.vars.itemView:removeAllChildren()
	arg_161_0.vars.itemView:setDataSource({})
	query("pvp_sa_battle_log")
end

function PvpSABattleLog.update(arg_163_0, arg_163_1)
	if not arg_163_0.vars.log_list then
		arg_163_0.vars.log_list = {}
	end
	
	arg_163_0.vars.log_list = arg_163_1.logs or {}
	
	arg_163_0.vars.itemView:setDataSource(arg_163_0.vars.log_list)
end

function PvpSABattleLog.revenge(arg_164_0, arg_164_1)
	if arg_164_1 then
		query("pvp_sa_revenge_ready", {
			revenge_id = arg_164_1
		})
	else
		balloon_message_with_sound("pvp_revenge_btn_cant")
	end
end

function PvpSABattleLog.updateItem(arg_165_0, arg_165_1, arg_165_2)
	local var_165_0 = ""
	local var_165_1 = arg_165_1:getChildByName("btn_revenge")
	
	var_165_1.revenge_id = nil
	
	if arg_165_2.battle_type == 0 or arg_165_2.battle_type == 2 or arg_165_2.battle_type == 3 then
		if arg_165_2.result == 2 then
			var_165_0 = "pvp_attack_win"
			
			SpriteCache:resetSprite(arg_165_1:getChildByName("icon_result"), "img/battle_pvp_icon_win.png")
			if_set_visible(arg_165_1, "btn_revenge", true)
			if_set_visible(arg_165_1, "n_complet", false)
			if_set_visible(arg_165_1, "n_fail", false)
			var_165_1:setOpacity(125)
			var_165_1:getChildByName("label"):setOpacity(125)
			if_set(var_165_1, "label", T("pvp_revenge_cant"))
		else
			var_165_0 = "pvp_attack_lose"
			
			SpriteCache:resetSprite(arg_165_1:getChildByName("icon_result"), "img/battle_pvp_icon_lose.png")
			if_set_visible(arg_165_1, "btn_revenge", true)
			if_set_visible(arg_165_1, "n_complet", false)
			if_set_visible(arg_165_1, "n_fail", false)
			var_165_1:setOpacity(125)
			var_165_1:getChildByName("label"):setOpacity(125)
			if_set(var_165_1, "label", T("pvp_revenge_cant"))
		end
	elseif arg_165_2.battle_type == 1 then
		if arg_165_2.result == 2 then
			var_165_0 = "pvp_defence_win"
			
			SpriteCache:resetSprite(arg_165_1:getChildByName("icon_result"), "img/battle_pvp_icon_def.png")
			if_set_visible(arg_165_1, "btn_revenge", true)
			if_set_visible(arg_165_1, "n_complet", false)
			if_set_visible(arg_165_1, "n_fail", false)
			var_165_1:setOpacity(125)
			var_165_1:getChildByName("label"):setOpacity(125)
			if_set(var_165_1, "label", T("pvp_revenge_cant"))
		elseif arg_165_2.result == 4 or arg_165_2.result == 6 then
			var_165_0 = "pvp_revenge_lose"
			
			SpriteCache:resetSprite(arg_165_1:getChildByName("icon_result"), "img/battle_pvp_icon_revenge_lose.png")
			if_set_visible(arg_165_1, "btn_revenge", false)
			if_set_visible(arg_165_1, "n_complet", false)
			if_set_visible(arg_165_1, "n_fail", true)
			if_set(arg_165_1:getChildByName("n_complet"), "complet_label", T("pvp_revenge_lose"))
		elseif arg_165_2.result == 5 then
			var_165_0 = "pvp_revenge_win"
			
			SpriteCache:resetSprite(arg_165_1:getChildByName("icon_result"), "img/battle_pvp_icon_revenge_win.png")
			if_set_visible(arg_165_1, "btn_revenge", false)
			if_set_visible(arg_165_1, "n_complet", true)
			if_set_visible(arg_165_1, "n_fail", false)
			if_set(arg_165_1:getChildByName("n_complet"), "complet_label", T("pvp_revenge_win"))
		else
			var_165_0 = "pvp_defence_lose"
			
			SpriteCache:resetSprite(arg_165_1:getChildByName("icon_result"), "img/battle_pvp_icon_defeat.png")
			if_set_visible(arg_165_1, "btn_revenge", true)
			if_set_visible(arg_165_1, "n_complet", false)
			if_set_visible(arg_165_1, "n_fail", false)
			if_set(var_165_1, "label", T("pvp_revenge"))
			
			var_165_1.revenge_id = arg_165_2.pvp_battle_uid
		end
	end
	
	if_set(arg_165_1, "txt_result", T(var_165_0))
	
	local var_165_2 = os.time() - to_n(arg_165_2.time)
	local var_165_3 = T("time_just_before")
	
	if var_165_2 > 60 then
		var_165_3 = T("time_before", {
			time = sec_to_string(math.floor(var_165_2))
		})
	end
	
	if_set(arg_165_1, "txt_desc", var_165_3)
	
	for iter_165_0 = 1, 4 do
		if_set_visible(arg_165_1, "enemy" .. iter_165_0, false)
	end
	
	local var_165_4 = arg_165_2.enemy_info.npc_id
	local var_165_5, var_165_6, var_165_8
	
	if arg_165_2.enemy_info.units then
		var_165_5 = (arg_165_2.enemy_info or {}).border_code
		
		if PvpSA:isBlindUser() then
			var_165_5 = nil
		end
		
		var_165_6 = 0
		
		if not var_165_4 and PvpSA:isEnterBlind() then
			table.shuffle(arg_165_2.enemy_info.units)
		end
		
		local var_165_7 = arg_165_2.enemy_info.gb_info
		
		var_165_8 = {}
		
		if var_165_7 then
			for iter_165_1, iter_165_2 in pairs(var_165_7) do
				var_165_8[iter_165_2[1]] = iter_165_2[2]
			end
		end
		
		for iter_165_3, iter_165_4 in pairs(arg_165_2.enemy_info.units) do
			if iter_165_4.pos ~= 5 then
				var_165_6 = var_165_6 + 1
				
				local var_165_9 = arg_165_1:getChildByName("enemy" .. var_165_6)
				
				if var_165_9 then
					var_165_9:setVisible(true)
					
					local var_165_10 = UNIT:create(iter_165_4.unit)
					
					if var_165_4 then
						UIUtil:getUserIcon(var_165_10, {
							no_grade = true,
							parent = var_165_9:getChildByName("n_face")
						})
						
						if get_cocos_refid(var_165_9:getChildByName("n_face"):getChildByName(".reward_icon")) then
							WidgetUtils:setupPopup({
								control = var_165_9:getChildByName("n_face"):getChildByName(".reward_icon"),
								creator = function()
									return UIUtil:getCharacterPopup({
										hide_star = true,
										skill_preview = false,
										off_power_detail = true,
										code = iter_165_4.unit.skin_code or iter_165_4.unit.code,
										grade = iter_165_4.unit.g,
										lv = var_165_10.inst.lv,
										z = iter_165_4.unit.zodiac
									})
								end
							})
						end
					else
						local var_165_11 = var_165_8[var_165_10:getUID()]
						
						if var_165_11 then
							var_165_10 = GrowthBoost:applyManual(var_165_10, var_165_11)
						end
						
						UIUtil:getUserIcon(var_165_10, {
							parent = var_165_9:getChildByName("n_face"),
							border_code = var_165_5
						})
						
						if get_cocos_refid(var_165_9:getChildByName("n_face"):getChildByName(".reward_icon")) then
							WidgetUtils:setupPopup({
								control = var_165_9:getChildByName("n_face"):getChildByName(".reward_icon"),
								creator = function()
									return UIUtil:getCharacterPopup({
										skill_preview = false,
										off_power_detail = true,
										code = iter_165_4.unit.skin_code or iter_165_4.unit.code,
										grade = var_165_10:getGrade(),
										lv = var_165_10:getLv(),
										z = var_165_10:getZodiacGrade(),
										awake = var_165_10:getAwakeGrade()
									})
								end
							})
						end
					end
				end
			end
		end
	end
	
	if var_165_4 then
		local var_165_12 = DB("pvp_npcbattle", var_165_4, "name")
		
		if_set(arg_165_1, "txt_npc_name", T(var_165_12))
		if_set_visible(arg_165_1, "txt_name", false)
		if_set_visible(arg_165_1, "txt_npc_name", true)
		if_set_visible(arg_165_1, "txt_rating", false)
		if_set_visible(arg_165_1, "n_clan", false)
	else
		if PvpSA:isEnterBlind() then
			if_set(arg_165_1, "txt_name", T("pvp_blind_name"))
		else
			if_set(arg_165_1, "txt_name", arg_165_2.enemy_info.name)
		end
		
		if_set_visible(arg_165_1, "txt_rating", true)
		
		local var_165_13 = arg_165_1:getChildByName("txt_rating")
		
		if get_cocos_refid(var_165_13) then
			if_set(var_165_13, nil, T("pvp_point", {
				point = comma_value(arg_165_2.score)
			}))
			UIUserData:call(var_165_13, "SINGLE_WSCALE(140)")
		end
		
		if_set_visible(arg_165_1, "txt_name", true)
		if_set_visible(arg_165_1, "txt_npc_name", false)
		if_set_visible(arg_165_1, "n_clan", false)
	end
	
	return arg_165_1
end

function PvpSA.onTouchDown(arg_168_0, arg_168_1, arg_168_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchDown(arg_168_1, arg_168_2)
	end
end

function PvpSA.onTouchUp(arg_169_0, arg_169_1, arg_169_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchUp(arg_169_1, arg_169_2)
	end
end

function PvpSA.onTouchMove(arg_170_0, arg_170_1, arg_170_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchMove(arg_170_1, arg_170_2)
	end
end

function PvpSA.onPushBackground(arg_171_0)
	if UnitMain:isVisible() then
		return UnitMain:onPushBackground()
	end
end

PvpNPC = {}

copy_functions(ScrollView, PvpNPC)

function HANDLER.pvp_npc_chall(arg_172_0, arg_172_1)
	if arg_172_1 == "btn_tab_5" then
	elseif arg_172_1 == "btn_normal" then
		PvpNPC:selectDifficulty(1)
	elseif arg_172_1 == "btn_hard" then
		PvpNPC:selectDifficulty(2)
	elseif arg_172_1 == "btn_hell" then
		PvpNPC:selectDifficulty(3)
	elseif arg_172_1 == "btn_pvp_select" or arg_172_1 == "btn_pvp_retry" then
		PvpNPC:select({
			item = arg_172_0.item
		})
	else
		balloon_message_with_sound("pvp_sa_lobby.pvp_sa_rest_time_npc")
	end
end

function PvpNPC.enterSingleMode(arg_173_0)
	local var_173_0 = load_dlg("pvp_npc_chall", true, "wnd")
	
	if_set(var_173_0, "txt_season_title", T(AccountData.season_period_db.name))
	
	local var_173_1 = PvpNPC:matchableCount()
	local var_173_2 = var_173_0:getChildByName("RIGHT"):getChildByName("btn_tab_5"):getChildByName("cm_icon_npc_match")
	
	if var_173_1 > 0 then
		var_173_2:setVisible(true)
		if_set(var_173_2, "label_count", var_173_1)
	else
		var_173_2:setVisible(false)
	end
	
	arg_173_0.vars = nil
	arg_173_0.npc_parent = SceneManager:getDefaultLayer()
	
	arg_173_0.npc_parent:addChild(var_173_0)
	arg_173_0:show(arg_173_0.npc_parent, Account:getAllNPC(), true)
	Scheduler:addSlow(var_173_0, arg_173_0.autoUpdate, arg_173_0, true)
	
	local var_173_3 = {
		"crystal",
		"gold",
		"pvpgold",
		"pvpkey"
	}
	
	if AccountData.season_period_db and AccountData.season_period_db.season_reward_id then
		table.push(var_173_3, string.sub(AccountData.season_period_db.season_reward_id, 4, -1))
	end
	
	TopBarNew:create(T("arena"), arg_173_0.npc_parent, nil, var_173_3, nil, "infoaren")
end

function PvpNPC.clear(arg_174_0)
	arg_174_0.vars = nil
end

function PvpNPC.show(arg_175_0, arg_175_1, arg_175_2, arg_175_3)
	if arg_175_0.vars then
		return 
	end
	
	arg_175_0.vars = {}
	arg_175_0.vars.parent = arg_175_1
	arg_175_0.vars.npc_data = arg_175_2 or {}
	arg_175_0.vars.list = {}
	arg_175_0.vars.difficulty = Account:getConfigData("game.pvp_npc_difficulty") or 1
	arg_175_0.vars.difficulties = {
		"normal",
		"hard",
		"hell"
	}
	arg_175_0.popup_mode = arg_175_3
	arg_175_0.vars.listview = arg_175_1:getChildByName("listview")
	arg_175_0.vars.itemView = ItemListView_v2:bindControl(arg_175_0.vars.listview)
	
	arg_175_0.vars.itemView:setListViewCascadeEnabled(true)
	
	local var_175_0 = load_control("wnd/pvp_bar.csb")
	
	if arg_175_0.vars.listview.STRETCH_INFO then
		local var_175_1 = arg_175_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_175_0, var_175_1.width, arg_175_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	local var_175_2 = {
		onUpdate = function(arg_176_0, arg_176_1, arg_176_2, arg_176_3)
			PvpNPC:updateItem(arg_176_1, arg_176_3)
			
			return arg_176_3.id
		end
	}
	
	arg_175_0.vars.itemView:setRenderer(var_175_0, var_175_2)
	arg_175_0.vars.itemView:removeAllChildren()
	arg_175_0.vars.itemView:setDataSource({})
	UnlockSystem:setButtonUnlockInfo(arg_175_1, "btn_hard", UNLOCK_ID.PVP_NPC_HARD)
	UnlockSystem:setButtonUnlockInfo(arg_175_1, "btn_hell", UNLOCK_ID.PVP_NPC_HELL)
	arg_175_0:refresh()
end

function PvpNPC.isDifficultyUnlock(arg_177_0, arg_177_1)
	if not arg_177_0.vars.npc_data then
		return false
	end
	
	if arg_177_1 == 2 then
		for iter_177_0, iter_177_1 in pairs(arg_177_0.vars.npc_data) do
			if iter_177_1.normal.npc_id == "npc_10" and to_n(iter_177_1.normal.win) > 0 then
				return true
			end
		end
		
		return true
	elseif arg_177_1 == 3 then
		return true
	end
	
	return true
end

function PvpNPC.selectDifficulty(arg_178_0, arg_178_1)
	if arg_178_0:isDifficultyUnlock(arg_178_1) == false then
		balloon_message_with_sound("npc_difficulty_unlock_required_" .. arg_178_1)
		
		return 
	end
	
	arg_178_0.vars.difficulty = arg_178_1
	
	SAVE:setTempConfigData("game.pvp_npc_difficulty", arg_178_1)
	arg_178_0:refresh()
end

function PvpNPC.getDifficultyString(arg_179_0, arg_179_1)
	if not arg_179_0.vars or arg_179_1 < 1 or arg_179_1 > 3 then
		return nil
	end
	
	return arg_179_0.vars.difficulties[arg_179_1]
end

function PvpNPC.refresh(arg_180_0, arg_180_1)
	if arg_180_1 then
		arg_180_0.vars.npc_data = arg_180_1
	end
	
	arg_180_0.vars.list = {}
	
	for iter_180_0, iter_180_1 in pairs(arg_180_0.vars.npc_data) do
		local var_180_0 = arg_180_0.vars.difficulties[arg_180_0.vars.difficulty]
		local var_180_1 = DB("pvp_npcbattle", iter_180_1[var_180_0].npc_id, "unlock_id")
		
		if not var_180_1 or UnlockSystem:isUnlockSystem(var_180_1) == true then
			table.push(arg_180_0.vars.list, iter_180_1[var_180_0])
		end
	end
	
	for iter_180_2, iter_180_3 in pairs(arg_180_0.vars.difficulties) do
		if_set_visible(arg_180_0.vars.parent, "btn_" .. iter_180_3, iter_180_2 ~= arg_180_0.vars.difficulty)
		if_set_visible(arg_180_0.vars.parent, "btn_" .. iter_180_3 .. "_select", iter_180_2 == arg_180_0.vars.difficulty)
	end
	
	arg_180_0.vars.itemView:setDataSource(arg_180_0.vars.list)
end

function PvpNPC.updateItem(arg_181_0, arg_181_1, arg_181_2)
	arg_181_1:getChildByName("btn_pvp_select").item = arg_181_2
	arg_181_1:getChildByName("btn_pvp_retry").item = arg_181_2
	
	for iter_181_0 = 1, 4 do
		if_set_visible(arg_181_1, "enemy" .. iter_181_0, false)
	end
	
	local var_181_0 = DBT("pvp_npcbattle", arg_181_2.npc_id, {
		"name",
		"sort",
		"unlock_id",
		"team_leader",
		"reset_time",
		"reward1_normal",
		"count1_normal",
		"reward2_normal",
		"count2_normal",
		"reward1_hard",
		"count1_hard",
		"reward2_hard",
		"count2_hard",
		"reward1_hell",
		"count1_hell",
		"reward2_hell",
		"count2_hell"
	})
	local var_181_1 = 0
	
	for iter_181_1, iter_181_2 in pairs(arg_181_2.enemy_info.units) do
		if iter_181_2.pos == tonumber(var_181_0.team_leader) then
			var_181_1 = var_181_1 + 1
			
			local var_181_2 = arg_181_1:getChildByName("enemy" .. var_181_1)
			
			if var_181_2 then
				var_181_2:setVisible(true)
				
				local var_181_3 = UNIT:create(iter_181_2.unit)
				
				UIUtil:getUserIcon(var_181_3, {
					tier = "boss",
					no_grade = true,
					parent = var_181_2:getChildByName("n_face")
				})
				
				if get_cocos_refid(var_181_2:getChildByName("n_face"):getChildByName(".reward_icon")) then
					WidgetUtils:setupPopup({
						control = var_181_2:getChildByName("n_face"):getChildByName(".reward_icon"),
						creator = function()
							return UIUtil:getCharacterPopup({
								hide_star = true,
								skill_preview = false,
								off_power_detail = true,
								code = iter_181_2.unit.code,
								grade = iter_181_2.unit.g,
								lv = var_181_3.inst.lv,
								z = iter_181_2.unit.zodiac
							})
						end
					})
				end
			end
		end
	end
	
	for iter_181_3, iter_181_4 in pairs(arg_181_2.enemy_info.units) do
		if iter_181_4.pos ~= tonumber(var_181_0.team_leader) then
			var_181_1 = var_181_1 + 1
			
			local var_181_4 = arg_181_1:getChildByName("enemy" .. var_181_1)
			
			if var_181_4 then
				var_181_4:setVisible(true)
				
				local var_181_5 = UNIT:create(iter_181_4.unit)
				
				UIUtil:getUserIcon(var_181_5, {
					no_grade = true,
					parent = var_181_4:getChildByName("n_face")
				})
				
				if get_cocos_refid(var_181_4:getChildByName("n_face"):getChildByName(".reward_icon")) then
					WidgetUtils:setupPopup({
						control = var_181_4:getChildByName("n_face"):getChildByName(".reward_icon"),
						creator = function()
							return UIUtil:getCharacterPopup({
								hide_star = true,
								skill_preview = false,
								off_power_detail = true,
								code = iter_181_4.unit.code,
								grade = iter_181_4.unit.g,
								lv = var_181_5.inst.lv,
								z = iter_181_4.unit.zodiac
							})
						end
					})
				end
			end
		end
	end
	
	if_set_visible(arg_181_1, "n_complet", false)
	
	if to_n(arg_181_2.last_result) ~= 1 or arg_181_2.last_battle_time + to_n(var_181_0.reset_time) < os.time() then
		if tonumber(arg_181_2.last_result) == -1 then
			if_set_visible(arg_181_1, "btn_pvp_retry", true)
			if_set_visible(arg_181_1, "btn_pvp_select", false)
		else
			if_set_visible(arg_181_1, "btn_pvp_retry", false)
			if_set_visible(arg_181_1, "btn_pvp_select", true)
		end
		
		if_set_visible(arg_181_1, "n_waiting", false)
	else
		if_set_visible(arg_181_1, "btn_pvp_retry", false)
		if_set_visible(arg_181_1, "btn_pvp_select", false)
		if_set_visible(arg_181_1, "n_waiting", true)
		if_set(arg_181_1:getChildByName("n_waiting"), "txt_time", sec_to_string(arg_181_2.last_battle_time + to_n(var_181_0.reset_time) - os.time(), false, {
			hour_limit = true
		}))
	end
	
	if_set_visible(arg_181_1, "n_npc", true)
	if_set_visible(arg_181_1, "n_enemy", false)
	if_set_visible(arg_181_1, "n_result_icon_pos", false)
	
	local var_181_6 = arg_181_1:getChildByName("n_npc")
	
	if_set(var_181_6, "txt_name", T(var_181_0.name))
	
	local var_181_7 = var_181_0["reward1_" .. arg_181_0.vars.difficulties[arg_181_0.vars.difficulty]]
	local var_181_8 = var_181_0["count1_" .. arg_181_0.vars.difficulties[arg_181_0.vars.difficulty]]
	local var_181_9 = var_181_0["reward2_" .. arg_181_0.vars.difficulties[arg_181_0.vars.difficulty]]
	local var_181_10 = var_181_0["count2_" .. arg_181_0.vars.difficulties[arg_181_0.vars.difficulty]]
	
	UIUtil:getRewardIcon(var_181_8, var_181_7, {
		show_small_count = true,
		show_name = false,
		scale = 1,
		detail = true,
		parent = var_181_6:getChildByName("n_reward_icon1")
	})
	UIUtil:getRewardIcon(var_181_10, var_181_9, {
		show_small_count = true,
		show_name = false,
		scale = 1,
		detail = true,
		parent = var_181_6:getChildByName("n_reward_icon2")
	})
	
	return arg_181_1
end

function PvpNPC.matchableCount(arg_184_0)
	local var_184_0 = Account:getAllNPC()
	
	if not var_184_0 then
		return 0
	end
	
	local var_184_1 = 0
	local var_184_2 = os.time()
	
	for iter_184_0, iter_184_1 in pairs(var_184_0) do
		local var_184_3 = DBT("pvp_npcbattle", iter_184_1.normal.npc_id, {
			"name",
			"reset_time",
			"unlock_id"
		})
		
		if (not var_184_3.unlock_id or UnlockSystem:isUnlockSystem(var_184_3.unlock_id) == true) and (iter_184_1.normal.last_result ~= 1 or var_184_2 > (iter_184_1.normal.last_battle_time or 0) + var_184_3.reset_time) then
			var_184_1 = var_184_1 + 1
		end
	end
	
	return var_184_1
end

function PvpNPC.pvpReadyPopup(arg_185_0, arg_185_1)
	arg_185_0.vars.pvp_team_layer = cc.Layer:create()
	
	SceneManager:getRunningNativeScene():addChildLast(arg_185_0.vars.pvp_team_layer)
	
	local var_185_0
	
	if arg_185_1.item.slot and arg_185_1.item.enemy_info.cv then
		var_185_0 = string.format("sa:%d:%s", arg_185_1.item.slot, arg_185_1.item.enemy_info.cv)
	elseif arg_185_1.item.enemy_info.npc_id then
		var_185_0 = string.format("npc:%d:%s", arg_185_1.item.enemy_info.difficulty, arg_185_1.item.enemy_info.npc_id)
	end
	
	PvpSATeam:show({
		no_repeat = true,
		mode = "pvp_ready",
		my_info = {
			score = "-",
			league = "-",
			continuous_victory = "-",
			battle_count = "-"
		},
		enemy_uid = var_185_0,
		enemy_score = arg_185_1.item.score,
		enemy_info = arg_185_1.item.enemy_info
	}, {
		parent = arg_185_0.vars.pvp_team_layer,
		hide_layer = arg_185_0.npc_parent
	})
end

function PvpNPC.select(arg_186_0, arg_186_1)
	local var_186_0 = DB("pvp_npcbattle", arg_186_1.item.npc_id, "reset_time")
	
	if tonumber(arg_186_1.item.last_result) ~= 1 or arg_186_1.item.last_battle_time + tonumber(var_186_0) < os.time() then
		if arg_186_0.popup_mode then
			PvpNPC:pvpReadyPopup(arg_186_1)
		else
			PvpSA:pvpReady(arg_186_1)
		end
		
		SoundEngine:play("event:/ui/ok")
	end
end

function PvpNPC.battleClear(arg_187_0, arg_187_1)
	ConditionContentsManager:dispatch("pvp.play")
	
	if arg_187_1.result_info and arg_187_1.result_info.win == true then
		ConditionContentsManager:dispatch("pvp.npc", {
			npc_id = arg_187_1.npc_id,
			level = arg_187_1.npc_difficulty
		})
		ConditionContentsManager:dispatch("pvp.win")
	end
	
	if arg_187_1.update_currency then
		Account:updateCurrencies(arg_187_1.update_currency)
	end
	
	Account:updatePvpNpcData(arg_187_1.update_npc_data)
	
	local var_187_0 = ConditionContentsManager:getSysAchievement():getNoti()
	local var_187_1, var_187_2 = ClearResult:calcFavInfosUtil(arg_187_1)
	
	ClearResult:show(Battle.logic, {
		map_id = "pvp00100",
		enemy_uid = arg_187_1.enemy_uid,
		npc_id = arg_187_1.npc_id,
		popup_mode = arg_187_1.popup_mode,
		pvp_result = arg_187_1.result_info,
		pvp_reward = arg_187_1.reward_info,
		sys_achieve = var_187_0,
		units = arg_187_1.units,
		units_favexp = var_187_2,
		fav_levelup = var_187_1
	})
end

function PvpNPC.autoUpdate(arg_188_0)
	if not arg_188_0.vars then
		return 
	end
	
	if not arg_188_0.popup_mode and PvpSA:getCurrentMenu() ~= "npc_match" then
		return 
	end
	
	if not arg_188_0.vars.list then
		return 
	end
	
	for iter_188_0, iter_188_1 in pairs(arg_188_0.vars.list) do
		local var_188_0 = arg_188_0.vars.listview:getControl(iter_188_1)
		local var_188_1 = iter_188_1
		
		if var_188_1 and get_cocos_refid(var_188_0) then
			local var_188_2 = os.time()
			local var_188_3 = DB("pvp_npcbattle", var_188_1.npc_id, "reset_time")
			
			if tonumber(var_188_1.last_result) ~= 1 or var_188_2 > var_188_1.last_battle_time + tonumber(var_188_3) then
				if_set_visible(var_188_0, "btn_pvp_select", true)
				
				if tonumber(var_188_1.last_result) == -1 then
					if_set_visible(var_188_0, "btn_pvp_retry", true)
					if_set_visible(var_188_0, "btn_pvp_select", false)
				else
					if_set_visible(var_188_0, "btn_pvp_retry", false)
					if_set_visible(var_188_0, "btn_pvp_select", true)
				end
				
				if_set_visible(var_188_0, "n_waiting", false)
			else
				if_set_visible(var_188_0, "btn_pvp_retry", false)
				if_set_visible(var_188_0, "btn_pvp_select", false)
				if_set_visible(var_188_0, "n_waiting", true)
				if_set(var_188_0:getChildByName("n_waiting"), "txt_time", sec_to_string(var_188_1.last_battle_time + tonumber(var_188_3) - var_188_2))
			end
		end
	end
end

function PvpNPC.onTouchDown(arg_189_0, arg_189_1, arg_189_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchDown(arg_189_1, arg_189_2)
	end
end

function PvpNPC.onTouchUp(arg_190_0, arg_190_1, arg_190_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchUp(arg_190_1, arg_190_2)
	end
end

function PvpNPC.onTouchMove(arg_191_0, arg_191_1, arg_191_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchMove(arg_191_1, arg_191_2)
	end
end

function PvpNPC.onPushBackground(arg_192_0)
	if UnitMain:isVisible() then
		return UnitMain:onPushBackground()
	end
end

PvpSAArenaStory = {}

copy_functions(ScrollView, PvpSAArenaStory)

function PvpSAArenaStory.clear(arg_193_0)
	arg_193_0.vars = nil
end

function PvpSAArenaStory.show(arg_194_0, arg_194_1)
	if arg_194_0.vars then
		return 
	end
	
	arg_194_0.vars = {}
	arg_194_0.vars.parent = arg_194_1
	
	local var_194_0
	local var_194_1
	
	for iter_194_0, iter_194_1 in pairs(AccountData.pvp_story_season) do
		if iter_194_1.start_time <= os.time() and iter_194_1.end_time >= os.time() then
			var_194_0 = iter_194_0
			
			local var_194_2 = iter_194_1.end_time
			
			break
		end
		
		if not var_194_0 then
			var_194_0 = iter_194_0
			
			local var_194_3 = iter_194_1.end_time
		end
	end
	
	if_set_visible(arg_194_1, "txt_season", false)
	
	local var_194_4 = arg_194_1:getChildByName("listview")
	
	arg_194_0.vars.itemView = ItemListView_v2:bindControl(var_194_4)
	
	local var_194_5 = load_control("wnd/pvp_bar_story.csb")
	
	if var_194_4.STRETCH_INFO then
		local var_194_6 = var_194_4:getContentSize()
		
		resetControlPosAndSize(var_194_5, var_194_6.width, var_194_4.STRETCH_INFO.width_prev)
	end
	
	local var_194_7 = {
		onUpdate = function(arg_195_0, arg_195_1, arg_195_2, arg_195_3)
			PvpSAArenaStory:updateItem(arg_195_1, arg_195_3)
			
			return arg_195_3.id
		end
	}
	
	arg_194_0.vars.itemView:setRenderer(var_194_5, var_194_7)
	arg_194_0.vars.itemView:removeAllChildren()
	arg_194_0:update()
	var_194_4:setInnerContainerPosition({
		x = 0,
		y = -17
	})
end

function PvpSAArenaStory.isNotViewedStory(arg_196_0, arg_196_1)
	if arg_196_0.vars == nil or arg_196_0.vars.story_list == nil then
		return 
	end
	
	for iter_196_0, iter_196_1 in pairs(arg_196_0.vars.story_list) do
		if iter_196_1.story_id == arg_196_1 then
			return not iter_196_1.repeatable
		end
	end
	
	return false
end

function PvpSAArenaStory.getFirstNotViewedStory(arg_197_0, arg_197_1)
	if arg_197_0.vars == nil or arg_197_0.vars.story_list == nil then
		return 
	end
	
	for iter_197_0, iter_197_1 in pairs(arg_197_0.vars.story_list) do
		if iter_197_1.story_id == arg_197_1 and iter_197_1.repeatable == false then
			return iter_197_1.id, iter_197_1.story_id
		end
	end
	
	return nil, nil
end

function PvpSAArenaStory.buildStoryData(arg_198_0)
	if not arg_198_0.vars then
		arg_198_0.vars = {}
	end
	
	local var_198_0 = os.time()
	
	arg_198_0.vars.story_list = {}
	
	for iter_198_0, iter_198_1 in pairs(AccountData.pvp_story_season) do
		if var_198_0 > iter_198_1.start_time then
			table.push(arg_198_0.vars.story_list, {
				viewable = false,
				repeatable = false,
				id = iter_198_0,
				icon = iter_198_1.icon,
				name = iter_198_1.name,
				desc = iter_198_1.desc,
				story_id = iter_198_1.story_id,
				sort = iter_198_1.sort,
				link = iter_198_1.link,
				start_time = iter_198_1.start_time,
				end_time = iter_198_1.end_time
			})
		end
	end
	
	table.sort(arg_198_0.vars.story_list, function(arg_199_0, arg_199_1)
		return arg_199_0.sort < arg_199_1.sort
	end)
	
	local var_198_1 = 0
	
	for iter_198_2, iter_198_3 in pairs(arg_198_0.vars.story_list) do
		if AccountData.last_pvp_story == iter_198_3.id then
			var_198_1 = to_n(iter_198_3.sort)
			
			break
		end
	end
	
	for iter_198_4, iter_198_5 in pairs(arg_198_0.vars.story_list) do
		if var_198_1 >= to_n(iter_198_5.sort) then
			iter_198_5.repeatable = true
			iter_198_5.viewable = true
		end
		
		if var_198_1 + 1 == to_n(iter_198_5.sort) then
			iter_198_5.viewable = true
		end
	end
	
	if var_198_1 == 0 and arg_198_0.vars.story_list[1] then
		arg_198_0.vars.story_list[1].viewable = true
		arg_198_0.vars.story_list[1].repeatable = false
	end
	
	return arg_198_0.vars.story_list
end

function PvpSAArenaStory.update(arg_200_0)
	if not arg_200_0.vars then
		return 
	end
	
	arg_200_0:buildStoryData(AccountData.pvp_story_season)
	
	if get_cocos_refid(arg_200_0.vars.itemView) and arg_200_0.vars.story_list then
		arg_200_0.vars.itemView:setDataSource(arg_200_0.vars.story_list)
	end
end

function PvpSAArenaStory.updateItem(arg_201_0, arg_201_1, arg_201_2)
	if_set(arg_201_1, "txt_title", T(arg_201_2.name))
	if_set(arg_201_1, "txt_desc", T(arg_201_2.desc))
	if_set_visible(arg_201_1, "icon_noti", false)
	
	if arg_201_1 then
		local var_201_0 = arg_201_1:getChildByName("txt_desc")
		
		if var_201_0 then
			UIUserData:call(var_201_0, "ELLIPSIS()")
		end
	end
	
	local var_201_1 = arg_201_1:getChildByName("btn_view_story")
	local var_201_2 = arg_201_1:getChildByName("btn_again_story")
	
	if arg_201_2.viewable then
		var_201_1.item = arg_201_2
		var_201_2.item = arg_201_2
	end
	
	var_201_1:setVisible(arg_201_2.repeatable == false)
	var_201_2:setVisible(arg_201_2.repeatable == true)
	
	local var_201_3 = arg_201_1:getChildByName("btn_movie")
	
	if get_cocos_refid(var_201_3) then
		if_set_visible(var_201_3, nil, arg_201_2.link and not IS_PUBLISHER_ZLONG)
		
		var_201_3.link = arg_201_2.link
	end
	
	return arg_201_1
end

function PvpSAArenaStory.select(arg_202_0, arg_202_1)
	if arg_202_1 and arg_202_1.item and arg_202_1.item.story_id and arg_202_1.item.viewable == true then
		if os.time() < to_n(arg_202_1.item.start_time) then
			balloon_message_with_sound("msg_pvp_story_not_yet")
			
			return 
		end
		
		start_new_story(nil, arg_202_1.item.story_id, {
			force = true,
			on_finish = function()
				if arg_202_1.item.repeatable == false then
					query("pvp_story", {
						story_id = arg_202_1.item.id
					})
				end
			end
		})
	else
		balloon_message_with_sound("msg_pvp_story_unlock")
	end
end
