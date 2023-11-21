BattleClanWar = {}
CALN_WAR_MAX_ROUND = 2

function MsgHandler.clan_war_begin(arg_1_0)
	ClanWarTeam:disableHeroList()
	set_high_fps_tick(6000)
	TransitionScreen:show({
		on_show_before = function(arg_2_0)
			SoundEngine:play("event:/ui/pvp/door_close")
			
			return EffectManager:Play({
				fn = "war_gate_close.cfx",
				pivot_z = 99998,
				layer = arg_2_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_hide_before = function(arg_3_0)
			arg_3_0:removeAllChildren()
			SoundEngine:play("event:/ui/pvp/door_open")
			
			return EffectManager:Play({
				fn = "war_gate_open.cfx",
				pivot_z = 99998,
				layer = arg_3_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_show = function()
			BattleClanWar:startBattle(arg_1_0)
		end
	})
end

function ErrHandler.clan_war_begin(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = T(arg_5_1)
	
	if arg_5_1 == "no_confirm_duplication" then
		local var_5_1 = true
		
		Dialog:msgBox(T("war_ui_0012"), {
			yesno = true,
			handler = function()
				ClanTeamReady:onBattleBegin(var_5_1)
			end
		})
		
		return 
	end
	
	if arg_5_2.err_next_scene then
		Dialog:msgBox(var_5_0, {
			handler = function()
				SceneManager:nextScene(arg_5_2.err_next_scene)
			end
		})
		
		return 
	end
	
	Dialog:msgBox(var_5_0)
end

function MsgHandler.clan_war_next(arg_8_0)
	BattleClanWar.scenechange_dirty = nil
	
	BattleClanWar:nextBattle(arg_8_0)
end

function BeforeErrHandler.clan_war_next(arg_9_0, arg_9_1, arg_9_2)
	BattleClanWar.scenechange_dirty = nil
	
	TransitionScreen:hide()
end

function MsgHandler.clan_war_end(arg_10_0)
	BattleClanWar.clan_war_end_rtn = nil
	
	BattleClanWar:battleClear(arg_10_0)
end

function ErrHandler.clan_war_end(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 and BattleClanWar.clan_war_end_rtn then
		Log.e("Err: req clan_war_end query again")
		arg_11_0("clan_war_end", BattleClanWar.clan_war_end_rtn)
		
		BattleClanWar.clan_war_end_rtn = nil
	end
end

function BattleClanWar.getRoundTeamInfo(arg_12_0, arg_12_1)
	local var_12_0 = {
		point = 0,
		team = {}
	}
	local var_12_1 = 0
	
	if arg_12_1 then
		for iter_12_0 = 1, 5 do
			if arg_12_1[iter_12_0] then
				if var_12_1 >= 3 then
					break
				end
				
				if not arg_12_1[iter_12_0]:isSummon() then
					var_12_1 = var_12_1 + 1
				end
				
				var_12_0.point = var_12_0.point + arg_12_1[iter_12_0]:getPoint()
				var_12_0.team[iter_12_0] = arg_12_1[iter_12_0].inst.uid
			end
		end
	end
	
	return var_12_0
end

function BattleClanWar.startPVP(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1 or {}
	
	arg_13_0.vars = {}
	arg_13_0.vars.team_info_1r = arg_13_0:getRoundTeamInfo(var_13_0.team1)
	arg_13_0.vars.team_info_2r = arg_13_0:getRoundTeamInfo(var_13_0.team2)
	
	local var_13_1 = var_13_0.enemy_uid
	
	arg_13_0:mapPreload(var_13_1)
	BattleRepeat:disableRepeatBattleCount()
	
	local var_13_2 = BattleUtil:getPlayingEpisode() or {}
	
	query("clan_war_begin", {
		enemy_uid = var_13_1,
		team_info_1r = json.encode(arg_13_0.vars.team_info_1r),
		confirm_duplication = var_13_0.confirm_duplication,
		episode_log = json.encode(var_13_2)
	})
end

function BattleClanWar.mapPreload(arg_14_0, arg_14_1)
	set_high_fps_tick(6000)
end

function BattleClanWar.endBattle(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0 = arg_15_2 or 0
	local var_15_1 = to_n(Battle.logic.winning_point) + var_15_0
	local var_15_2 = Battle.logic.enemy_uid
	local var_15_3 = Battle.logic.attacekr_battle_uid
	local var_15_4 = Battle.logic.defender_battle_uid
	local var_15_5 = Battle.logic:getDeadUnitUIDList()
	local var_15_6 = Battle.logic:getEnemiesDeadUnitUIDList()
	local var_15_7 = Battle.logic:getBattleReplayData()
	
	Battle.logic:removeEnemiesDeadUnitUIDList()
	
	if arg_15_1 < CALN_WAR_MAX_ROUND then
		BattleClanWar.scenechange_dirty = true
		
		UIAction:Add(COND_LOOP(SEQ(DELAY(100)), function()
			if not BattleClanWar.scenechange_dirty then
				return true
			end
		end), BattleClanWar, "block")
		
		local var_15_8 = arg_15_0.vars.team_info_2r
		
		arg_15_0:mapPreload(var_15_2)
		TransitionScreen:show({
			on_show_before = function(arg_17_0)
				SoundEngine:play("event:/ui/pvp/door_close")
				
				return EffectManager:Play({
					fn = "war_gate_close.cfx",
					pivot_z = 99998,
					layer = arg_17_0,
					pivot_x = VIEW_WIDTH / 2,
					pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
				}), 2000
			end,
			on_hide_before = function(arg_18_0)
				arg_18_0:removeAllChildren()
				SoundEngine:play("event:/ui/pvp/door_open")
				
				return EffectManager:Play({
					fn = "war_gate_open.cfx",
					pivot_z = 99998,
					layer = arg_18_0,
					pivot_x = VIEW_WIDTH / 2,
					pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
				}), 2000
			end,
			on_show = function()
				query("clan_war_next", {
					enemy_uid = var_15_2,
					result = var_15_0,
					team_info = json.encode(var_15_8),
					winning_point = var_15_1,
					dead_units = json.encode(var_15_5),
					enemy_dead_units = json.encode(var_15_6),
					attacekr_battle_uid = var_15_3,
					defender_battle_uid = var_15_4,
					stage_clear_id = arg_15_3,
					convic = arg_15_4,
					ssr_rate = Battle.logic:getRateSSR(),
					replay_data = var_15_7
				})
			end
		})
	else
		local var_15_9 = BattleUtil:getPlayingEpisode() or {}
		local var_15_10 = {
			enemy_uid = var_15_2,
			result = var_15_0,
			winning_point = var_15_1,
			dead_units = json.encode(var_15_5),
			enemy_dead_units = json.encode(var_15_6),
			attacekr_battle_uid = var_15_3,
			defender_battle_uid = var_15_4,
			stage_clear_id = arg_15_3,
			convic = arg_15_4,
			ssr_rate = Battle.logic:getRateSSR(),
			team_info_1r = json.encode(arg_15_0.vars.team_info_1r or {}),
			team_info_2r = json.encode(arg_15_0.vars.team_info_2r or {}),
			replay_data = var_15_7,
			episode_log = json.encode(var_15_9)
		}
		
		BattleClanWar.clan_war_end_rtn = var_15_10
		
		query("clan_war_end", var_15_10)
	end
end

CLAN_WAR_TIME_LIMIT = 1800

function BattleClanWar.startBattle(arg_20_0, arg_20_1)
	if arg_20_1.update_currency then
		Singular:event("join_guildwar")
		Account:updateCurrencies(arg_20_1.update_currency)
	end
	
	local var_20_0 = BattleLogic:makeLogic(arg_20_1.battle.map, arg_20_1.my_team)
	
	var_20_0.round = 1
	var_20_0.enemy_uid = arg_20_1.enemy_uid
	var_20_0.enemy_name = arg_20_1.enemy_info.name
	var_20_0.attacekr_battle_uid = arg_20_1.attacekr_battle_uid
	var_20_0.defender_battle_uid = arg_20_1.defender_battle_uid
	var_20_0.winning_point = 0
	var_20_0.limit_time = os.time() + CLAN_WAR_TIME_LIMIT
	
	PreLoad:beforeEnterBattle(var_20_0)
	SceneManager:nextScene("battle", {
		logic = var_20_0
	})
end

function BattleClanWar.nextBattle(arg_21_0, arg_21_1)
	local var_21_0 = BattleLogic:makeLogic(arg_21_1.battle.map, arg_21_1.my_team)
	
	var_21_0.round = 2
	var_21_0.enemy_uid = arg_21_1.enemy_uid
	var_21_0.enemy_name = arg_21_1.enemy_info.name
	var_21_0.attacekr_battle_uid = arg_21_1.attacekr_battle_uid
	var_21_0.defender_battle_uid = arg_21_1.defender_battle_uid
	var_21_0.winning_point = to_n(arg_21_1.winning_point)
	var_21_0.limit_time = os.time() + CLAN_WAR_TIME_LIMIT
	
	ClanWar:setDeadUnits(arg_21_1.dead_info or {})
	PreLoad:beforeEnterBattle(var_21_0)
	SceneManager:nextScene("battle", {
		logic = var_21_0
	})
end

function BattleClanWar.battleClear(arg_22_0, arg_22_1)
	if arg_22_1.update_currency then
		Account:updateCurrencies(arg_22_1.update_currency)
	end
	
	local var_22_0, var_22_1 = ClearResult:calcFavInfosUtil(arg_22_1)
	
	ClanWar:setDeadUnits(arg_22_1.dead_info or {})
	
	if UIAction:Find(BattleClanWar) then
		UIAction:Remove(BattleClanWar)
	end
	
	local var_22_2 = {}
	
	for iter_22_0, iter_22_1 in pairs(arg_22_1.units or {}) do
		table.insert(var_22_2, Account:getUnit(iter_22_1.uid))
	end
	
	ClearResult:show(Battle.logic, {
		map_id = "pvp00100",
		clanwar_result = arg_22_1.result_info,
		reward_info = arg_22_1.reward_info,
		units = var_22_2,
		units_favexp = var_22_1,
		fav_levelup = var_22_0
	})
end
