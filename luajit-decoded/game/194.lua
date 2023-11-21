function ErrHandler.enter(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = T(arg_1_0 .. "." .. arg_1_1)
	
	if SceneManager:getCurrentSceneName() == "battle" then
		TransitionScreen:hide()
		Dialog:msgBox(var_1_0, {
			handler = function()
				SceneManager:nextScene("lobby")
			end
		})
		
		return 
	end
	
	Dialog:msgBox(var_1_0, {
		handler = function()
			SceneManager:nextScene("lobby")
		end
	})
end

function MsgHandler.enter(arg_4_0)
	Account:setDungeonBaseInfo(arg_4_0.dungeon_base_info.enter_id, arg_4_0.dungeon_base_info)
	BattleRepeat:set_coopMissionCount(arg_4_0.coop_invite_count or 0)
	
	if arg_4_0.crevice_hunt_info then
		DungeonCreviceUtil:setSeasonInfo(arg_4_0.crevice_hunt_info.season_info)
		DungeonCreviceUtil:setBossInfo(arg_4_0.crevice_hunt_info.boss_info)
	end
	
	if not arg_4_0.is_back_ground then
		Action:RemoveAll()
		BattleReady:hide()
	end
	
	startBattleScene(arg_4_0)
end

function MsgHandler.preview_enter(arg_5_0)
	if arg_5_0.ch then
		arg_5_0.force_preview_mode = true
	end
	
	startBattleScene(arg_5_0)
end

function MsgHandler.set_hp(arg_6_0)
	if arg_6_0.hp_infos then
		Account:procHPInfos(arg_6_0.hp_infos)
	end
end

function startSkillPreview(arg_7_0)
	local var_7_0 = {
		count = 0,
		pass_event = {},
		clear_way = {},
		battle = {
			check = 0,
			enter = "skill_preview",
			team = 1,
			logic_seed = 0,
			skill_preview = true,
			battle_uid = 0,
			seed = 0,
			tm = os.time(),
			ways = {
				skill_preview001 = {
					{
						type = "battle",
						room = "1",
						stage_idx = "1",
						exp = 0,
						id = "skill_preview001_1",
						mobs = {
							{
								monster_tier = 2,
								pos = 1,
								g = 1,
								p = 4,
								code = "m9201",
								lv = 60,
								line = "front"
							},
							{
								monster_tier = 2,
								pos = 2,
								g = 1,
								p = 4,
								code = "m9201",
								lv = 60,
								line = "front"
							},
							{
								monster_tier = 2,
								pos = 3,
								g = 1,
								p = 4,
								code = "m9201",
								lv = 60,
								line = "back"
							}
						}
					}
				}
			}
		},
		dungeon_base = {
			skill_preview = {
				score = 0,
				total_event = 0,
				count = 0,
				progress = 0,
				enter_id = "skill_preview"
			}
		},
		team = {
			team_point = 0,
			level = 9,
			units = {
				{
					pos = 1,
					unit = {
						p = 2,
						z = 6,
						g = 6,
						exp = 5000000,
						code = arg_7_0
					},
					equips = {}
				}
			}
		}
	}
	
	if DB("character_reference", arg_7_0, "dummy_set") == "y" then
		local var_7_1 = {
			pos = 4,
			unit = {
				g = 6,
				z = 6,
				p = 2,
				code = "m9201",
				uid = -1,
				lv = 60,
				line = "back"
			},
			equips = {}
		}
		
		table.insert(var_7_0.team.units, var_7_1)
	end
	
	return startBattleScene(var_7_0)
end

function startBattleScene(arg_8_0)
	if arg_8_0.started_datas then
		startBattleSceneNew(arg_8_0)
		
		return 
	end
	
	if GachaUnit:isActive() and not arg_8_0.is_back_ground then
		GachaIntroduceBG:closeWithSound()
		CocosSchedulerManager:removeCustomSchForPoll()
	end
	
	if string.len(arg_8_0.token or "") > 0 then
		Account:setCurrency(arg_8_0.token, arg_8_0.remain_token)
		Account:setCurrencyTime(arg_8_0.token, arg_8_0.currency_time)
	end
	
	if arg_8_0.limits then
		Account:updateLimits(arg_8_0.limits)
	end
	
	if arg_8_0.maze_used_unit then
		Account:setMazeUsedUnit(arg_8_0.maze_used_unit)
	end
	
	local var_8_0 = arg_8_0.battle
	local var_8_1 = {}
	
	if arg_8_0.dungeon_base_info then
		var_8_1.dungeon_base = {
			[arg_8_0.dungeon_base_info.enter_id] = arg_8_0.dungeon_base_info
		}
	end
	
	if arg_8_0.pass_event then
		var_8_1.pass_event = (arg_8_0.pass_event or {})[var_8_0.enter]
		
		Account:setPassEvent(var_8_0.enter, (arg_8_0.pass_event or {})[var_8_0.enter])
	end
	
	if arg_8_0.clear_event then
		var_8_1.clear_event = arg_8_0.clear_event
		
		Account:setClearEvent(var_8_0.enter, (arg_8_0.clear_event or {})[var_8_0.enter])
	end
	
	local var_8_2 = {}
	local var_8_3 = arg_8_0.automaton or false
	
	local function var_8_4(arg_9_0, arg_9_1, arg_9_2)
		Account:setAutomatonInfo(arg_9_0.automaton)
		
		local var_9_0
		
		if arg_9_0.automaton_prev_data and arg_9_1.ways then
			var_9_0 = arg_9_0.automaton_prev_data
			
			local var_9_1 = arg_9_1.ways
			
			if var_9_0.completed_events and not table.empty(var_9_0.completed_events) then
				for iter_9_0, iter_9_1 in pairs(var_9_1) do
					for iter_9_2, iter_9_3 in pairs(iter_9_1) do
						if table.isInclude(var_9_0.completed_events, iter_9_3.id) then
							table.insert(arg_9_2, iter_9_3.id)
						end
					end
				end
			end
		end
		
		if arg_9_0.unit_hp_info then
			local var_9_2 = arg_9_0.unit_hp_info
			
			for iter_9_4, iter_9_5 in pairs(var_9_2) do
				local var_9_3 = Account:getUnit(tonumber(iter_9_4))
				
				if var_9_3 then
					var_9_3:setAutomatonHPRatio(iter_9_5)
				end
			end
		end
	end
	
	if arg_8_0.clear_way then
		var_8_1.clear_way = arg_8_0.clear_way
	end
	
	if arg_8_0.quest_m_id then
		var_8_1.quest_m_id = arg_8_0.quest_m_id
	end
	
	if arg_8_0.substory_id then
		var_8_1.substory_id = arg_8_0.substory_id
	end
	
	if arg_8_0.npcteam_id then
		var_8_1.npcteam_id = arg_8_0.npcteam_id
	end
	
	if arg_8_0.count then
		var_8_1.count = arg_8_0.count
	end
	
	if arg_8_0.practice_mode then
		var_8_1.practice_mode = arg_8_0.practice_mode
	end
	
	if arg_8_0.mt_episode_id then
		var_8_1.mt_episode_id = arg_8_0.mt_episode_id
	end
	
	if arg_8_0.burning_story_id then
		var_8_1.burning_story_id = arg_8_0.burning_story_id
	end
	
	if arg_8_0.force_preview_mode then
		var_8_1.force_preview_mode = arg_8_0.force_preview_mode
	end
	
	if arg_8_0.spl_info then
		var_8_1.spl_info = arg_8_0.spl_info
	end
	
	if DB("level_enter", var_8_0.enter, "type") ~= "abyss" then
		local var_8_5 = arg_8_0.substory_id
		
		if var_8_5 then
			var_8_1.quest_mission = table.clone(Account:getSubStoryQuestBySubstoryID(var_8_5))
			
			for iter_8_0, iter_8_1 in pairs(var_8_1.quest_mission) do
				if iter_8_1.state == SUBSTORY_QUEST_STATE.ACTIVE then
					var_8_1.quest_mission[iter_8_0].state = "active"
				elseif iter_8_1.state == SUBSTORY_QUEST_STATE.CLEAR then
					var_8_1.quest_mission[iter_8_0].state = "clear"
				elseif iter_8_1.state == SUBSTORY_QUEST_STATE.COMPLETE then
					var_8_1.quest_mission[iter_8_0].state = "clear"
				elseif iter_8_1.state == SUBSTORY_QUEST_STATE.INACTIVE then
					var_8_1.quest_mission[iter_8_0].state = nil
				end
			end
		else
			var_8_1.quest_mission = Account:getQuestMissions()
		end
		
		var_8_1.battle_mission = Account:getDungeonMissionInfo(var_8_0.enter)
	end
	
	if PLATFORM == "win32" then
		SAVE:set("game.started_battle_data", {
			map = var_8_0,
			team = arg_8_0.team,
			started_data = var_8_1
		})
	end
	
	local var_8_6 = {}
	
	if var_8_3 then
		var_8_4(arg_8_0, var_8_0, var_8_2)
		
		if arg_8_0.automaton then
			var_8_6 = arg_8_0.automaton.automaton_ally_info or {}
		end
	end
	
	local var_8_7 = arg_8_0.user_device or {}
	local var_8_8 = arg_8_0.monster_device or {}
	
	if DEBUG.USE_DEVICE_CHEAT then
		var_8_7 = Account:getAutomatonDeviceList()
	end
	
	local var_8_9 = arg_8_0.external_passive_list or {}
	local var_8_10 = arg_8_0.ignore_road_events or {}
	local var_8_11 = BattleLogic:makeLogic(var_8_0, arg_8_0.team, {
		started_data = var_8_1,
		user_device = var_8_7,
		monster_device = var_8_8,
		automaton_ally_info = var_8_6,
		external_passive_list = var_8_9,
		ignore_road_events = var_8_10
	})
	
	if var_8_3 and not table.empty(var_8_2) then
		for iter_8_2, iter_8_3 in pairs(var_8_2) do
			var_8_11:setCompleteRoadEvent(iter_8_3)
		end
	end
	
	if arg_8_0.spl_info then
		SPLSystem:releaseAllModel()
	end
	
	if arg_8_0.is_back_ground then
		BackPlayManager:play(var_8_11, {
			make_new_team = true,
			battle_state = "begin",
			start_time = os.time(),
			team_idx = arg_8_0.team.team_index,
			team_point = arg_8_0.team.team_point or 0
		})
	else
		PreLoad:beforeEnterBattle(var_8_11)
		SceneManager:nextScene("battle", {
			logic = var_8_11,
			expedition_users = arg_8_0.user_info,
			coop_sync_time = arg_8_0.coop_sync_time
		})
	end
	
	if arg_8_0.battle.enter == "jer001" then
		Singular:event("ep2ch1")
	end
	
	if string.match(arg_8_0.battle.enter, "^hun[gwbqd]%d+$") then
		local var_8_12 = string.match(arg_8_0.battle.enter, "%d+")
		
		if var_8_12 and tonumber(var_8_12) > 8 then
			Singular:event(arg_8_0.battle.enter)
		end
	end
	
	if string.match(arg_8_0.battle.enter, "^mission_%w_%d%d%d") then
		Singular:event("join_expedition")
	end
end

function startBattleSceneNew(arg_10_0)
	if GachaUnit:isActive() and not arg_10_0.is_back_ground then
		GachaIntroduceBG:closeWithSound()
		CocosSchedulerManager:removeCustomSchForPoll()
	end
	
	if string.len(arg_10_0.token or "") > 0 then
		Account:setCurrency(arg_10_0.token, arg_10_0.remain_token)
		Account:setCurrencyTime(arg_10_0.token, arg_10_0.currency_time)
	end
	
	if arg_10_0.limits then
		Account:updateLimits(arg_10_0.limits)
	end
	
	if arg_10_0.maze_used_unit then
		Account:setMazeUsedUnit(arg_10_0.maze_used_unit)
	end
	
	local var_10_0 = arg_10_0.battle
	local var_10_1 = arg_10_0.started_datas and arg_10_0.started_datas[1] and json.decode(arg_10_0.started_datas[1]) or nil
	
	if arg_10_0.pass_event then
		Account:setPassEvent(var_10_0.enter, (arg_10_0.pass_event or {})[var_10_0.enter])
	end
	
	if arg_10_0.clear_event then
		Account:setClearEvent(var_10_0.enter, (arg_10_0.clear_event or {})[var_10_0.enter])
	end
	
	if arg_10_0.automaton or false then
		Account:setAutomatonInfo(arg_10_0.automaton)
		
		if arg_10_0.unit_hp_info then
			local var_10_2 = arg_10_0.unit_hp_info
			
			for iter_10_0, iter_10_1 in pairs(var_10_2) do
				local var_10_3 = Account:getUnit(tonumber(iter_10_0))
				
				if var_10_3 then
					var_10_3:setAutomatonHPRatio(iter_10_1)
				end
			end
		end
	end
	
	var_10_1.started_data = var_10_1.started_data or {}
	
	if DB("level_enter", var_10_0.enter, "type") ~= "abyss" then
		local var_10_4 = arg_10_0.substory_id
		
		if var_10_4 then
			local var_10_5 = table.clone(Account:getSubStoryQuestBySubstoryID(var_10_4))
			
			var_10_1.started_data.quest_mission = var_10_5
			
			for iter_10_2, iter_10_3 in pairs(var_10_1.started_data.quest_mission) do
				if iter_10_3.state == SUBSTORY_QUEST_STATE.ACTIVE then
					var_10_1.started_data.quest_mission[iter_10_2].state = "active"
				elseif iter_10_3.state == SUBSTORY_QUEST_STATE.CLEAR then
					var_10_1.started_data.quest_mission[iter_10_2].state = "clear"
				elseif iter_10_3.state == SUBSTORY_QUEST_STATE.COMPLETE then
					var_10_1.started_data.quest_mission[iter_10_2].state = "clear"
				elseif iter_10_3.state == SUBSTORY_QUEST_STATE.INACTIVE then
					var_10_1.started_data.quest_mission[iter_10_2].state = nil
				end
			end
		else
			var_10_1.started_data.quest_mission = Account:getQuestMissions()
		end
		
		var_10_1.started_data.battle_mission = Account:getDungeonMissionInfo(var_10_0.enter)
	end
	
	if PLATFORM == "win32" then
		SAVE:set("game.started_battle_data", {
			map = var_10_0,
			team = arg_10_0.team,
			started_data = var_10_1.started_data
		})
	end
	
	local var_10_6 = BattleLogic:makeLogic(var_10_0, arg_10_0.team, var_10_1)
	
	if arg_10_0.spl_info then
		SPLSystem:releaseAllModel()
	end
	
	if arg_10_0.is_back_ground then
		BackPlayManager:play(var_10_6, {
			make_new_team = true,
			battle_state = "begin",
			start_time = os.time(),
			team_idx = arg_10_0.team.team_index,
			team_point = arg_10_0.team.team_point or 0
		})
	else
		PreLoad:beforeEnterBattle(var_10_6)
		SceneManager:nextScene("battle", {
			logic = var_10_6,
			expedition_users = arg_10_0.user_info,
			coop_sync_time = arg_10_0.coop_sync_time
		})
	end
	
	if arg_10_0.battle.enter == "jer001" then
		Singular:event("ep2ch1")
	end
	
	if string.match(arg_10_0.battle.enter, "^hun[gwbqd]%d+$") then
		local var_10_7 = string.match(arg_10_0.battle.enter, "%d+")
		
		if var_10_7 and tonumber(var_10_7) > 8 then
			Singular:event(arg_10_0.battle.enter)
		end
	end
	
	if string.match(arg_10_0.battle.enter, "^mission_%w_%d%d%d") then
		Singular:event("join_expedition")
	end
end

function checkGenieEnterable(arg_11_0)
	if not arg_11_0 then
		return true
	end
	
	local var_11_0, var_11_1 = DB("level_enter", arg_11_0, {
		"id",
		"type"
	})
	
	if not var_11_1 or var_11_1 ~= "genie" then
		return true
	end
	
	local var_11_2, var_11_3 = DungeonCommon:GetDungeonList("level_battlemenu_genie", os.time())
	
	var_11_2 = var_11_2 or {}
	
	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		if string.starts(arg_11_0, iter_11_1.dungeon_id) and iter_11_1:isEnterable() then
			return true
		end
	end
	
	return false
end

function startBattle(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or {}
	arg_12_1.use_friend = arg_12_1.use_friend or {}
	
	local var_12_0 = arg_12_1.practice_mode
	local var_12_1 = arg_12_1.is_already_cleared
	local var_12_2 = arg_12_1.is_back_ground
	local var_12_3 = arg_12_1.npcteam_id
	local var_12_4, var_12_5 = Account:getEnterLimitInfo(arg_12_0)
	
	if var_12_4 and var_12_4 < 1 and not var_12_0 and not var_12_1 then
		balloon_message_with_sound("battle_cant_getin")
		
		return false
	end
	
	if not checkGenieEnterable(arg_12_0) then
		balloon_message_with_sound("err_msg_enter_limit_altar")
		BattleTopBar:setDisabledBackPlayBtn()
		BackPlayManager:forceStopPlay("no_genie_enter")
		
		return 
	end
	
	if not arg_12_1.ignore_check_enter_map and not Account:checkEnterMap(arg_12_0) then
		balloon_message_with_sound("battle_cant_getin")
		
		return 
	end
	
	local var_12_6 = UIUtil:getChargeInfo(arg_12_0)
	local var_12_7 = DB("level_enter", arg_12_0, {
		"type"
	})
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		var_12_6.use_enterpoint = 0
	end
	
	if to_n(var_12_6.use_enterpoint) > 0 and var_12_6.enterable == false and not var_12_0 and not var_12_1 and not DungeonHell:isAbyssHardMap(arg_12_0) then
		balloon_message_with_sound("battle_cant_getin")
		
		return false
	end
	
	local var_12_8
	
	if arg_12_1.sub_story then
		var_12_8 = arg_12_1.sub_story.id
	end
	
	if var_12_8 and not SubstoryManager:isOpenSubstoryDefaultSchedule(var_12_8) then
		balloon_message_with_sound("err_msg_enter_limit_altar")
		BattleTopBar:setDisabledBackPlayBtn()
		BackPlayManager:forceStopPlay("substory_end")
		
		return false
	end
	
	local var_12_9
	
	PreLoad:beforeReqBattle(arg_12_0)
	
	if Account:getActiveQuestDataInBattle(arg_12_0) then
		if var_12_8 then
			var_12_9 = SubstoryManager:getCurrentQuestData(var_12_8).id
		else
			var_12_9 = ConditionContentsManager:getQuestMissions():getCurrentQuestId()
		end
	end
	
	local var_12_10 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(arg_12_0)
	
	print("긴급미션!", var_12_10)
	BattleReadyFriends:removeFriend(arg_12_1.use_friend.account_id)
	
	local var_12_11
	
	if var_12_8 then
		var_12_11 = {
			id = var_12_8
		}
		var_12_11 = json.encode(var_12_11)
	elseif arg_12_1.ignore_check_enter_map then
		local var_12_12 = DB("level_enter", arg_12_0, "substory_contents_id")
		
		if var_12_12 then
			var_12_11 = {
				id = var_12_12
			}
			var_12_11.cheat = true
			var_12_11 = json.encode(var_12_11)
		end
	end
	
	local var_12_13 = Account:saveTeamInfo(true)
	local var_12_14
	local var_12_15 = {}
	
	if arg_12_1.is_automaton then
		var_12_14 = Account:getAutomatonTeamIndex()
		
		table.insert(var_12_15, var_12_14)
	elseif arg_12_1.is_descent then
		var_12_14 = DESCENT_TEAM_IDX[1]
		var_12_15 = DESCENT_TEAM_IDX
	elseif arg_12_1.is_burning then
		var_12_14 = BURNING_TEAM_IDX[1]
		var_12_15 = BURNING_TEAM_IDX
	elseif arg_12_1.is_back_ground then
		var_12_14 = arg_12_1.back_play_team_idx
		
		table.insert(var_12_15, var_12_14)
	elseif arg_12_1.is_crehunt then
		var_12_14 = Account:getCrehuntTeamIndex()
		
		table.insert(var_12_15, var_12_14)
	else
		var_12_14 = not var_12_3 and Account:getCurrentTeamIndex() or nil
		
		table.insert(var_12_15, var_12_14)
	end
	
	if not arg_12_1.is_descent and not arg_12_1.is_burning and not arg_12_1.is_crehunt then
		Account:saveLocalTeamIndex(arg_12_0, var_12_14)
	end
	
	local var_12_16 = {}
	
	for iter_12_0, iter_12_1 in pairs(var_12_15 or {}) do
		if iter_12_1 then
			local var_12_17 = {}
			local var_12_18 = Account:getTeam(iter_12_1)
			
			for iter_12_2 = 1, 4 do
				local var_12_19 = var_12_18[iter_12_2]
				
				if var_12_19 then
					table.insert(var_12_17, {
						c = var_12_19.db.code,
						s = c_check_db(var_12_19.db.code)
					})
				end
			end
			
			table.insert(var_12_16, array_to_json(var_12_17))
		end
	end
	
	add_local_push("DAILY_CONNECT_1", DAILY_CONNECT_1_PUSH_TIME)
	add_local_push("DAILY_CONNECT_3", DAILY_CONNECT_3_PUSH_TIME)
	
	local var_12_20 = arg_12_1.trial_id
	
	if var_12_7 == "trial_hall" and not var_12_20 then
		local var_12_21 = Account:getActiveTrialHall()
		
		if var_12_21 and var_12_21.id then
			var_12_20 = var_12_21.id
		end
	end
	
	local var_12_22 = Analytics:getDatas()
	local var_12_23
	
	if SAVE:updateConfigDataByTemp() > 0 then
		var_12_23 = SAVE:getJsonConfigData()
	end
	
	local var_12_24
	
	if arg_12_1.is_automaton and DEBUG.AUTOMATON_ROATION_CHEAT then
		arg_12_1.atmt_round = AutomatonUtil:_dev_get_cheat_rotation()
	end
	
	if not PRODUCTION_MODE and ct and ct._enable_force_enter_boss_stage then
		query("test_reset_dungeon_clear", {
			enter_id = arg_12_0
		})
	end
	
	local var_12_25
	
	if not PRODUCTION_MODE and arg_12_1.job_levels then
		local var_12_26 = {
			warrior = arg_12_1.job_levels[1],
			knight = arg_12_1.job_levels[2],
			assassin = arg_12_1.job_levels[3],
			ranger = arg_12_1.job_levels[4],
			mage = arg_12_1.job_levels[5],
			manauser = arg_12_1.job_levels[6]
		}
		
		var_12_25 = json.encode(var_12_26)
	end
	
	if arg_12_1.cheat_preview_mode or DB("level_enter", arg_12_0, "type") == "preview_quest" then
		query("preview_enter", {
			map = arg_12_0,
			team = var_12_14,
			team_indices = array_to_json(var_12_15),
			npcteam_id = var_12_3,
			ch = arg_12_1.cheat_preview_mode
		})
		
		return 
	end
	
	local var_12_27
	
	if arg_12_1.spl_info then
		var_12_27 = json.encode(arg_12_1.spl_info)
	end
	
	local var_12_28 = BattleUtil:getPlayingEpisode() or {}
	
	query("enter", {
		map = arg_12_0,
		team = var_12_14,
		team_indices = array_to_json(var_12_15),
		quest_m_id = var_12_9,
		mission_id = var_12_10,
		countinue = arg_12_1.play_continue,
		update_team_info = var_12_13,
		repeat_count = arg_12_1.repeat_count,
		pet_repeat = arg_12_1.pet_repeat,
		cheat_limit = DEBUG.DEBUG_NO_ENTER_LIMIT,
		use_friend_account_id = arg_12_1.use_friend.account_id,
		use_friend_unit_uid = arg_12_1.use_friend.unit_uid,
		use_friend_npc = arg_12_1.use_friend.npc,
		substory_data = var_12_11,
		npcteam_id = var_12_3,
		atmt_round = arg_12_1.atmt_round,
		weak_lv = arg_12_1.weak_lv,
		trial_id = var_12_20,
		practice_mode = arg_12_1.practice_mode,
		coffee = array_to_json(var_12_16),
		repeat_battle = arg_12_1.repeat_battle,
		play_time_logs = var_12_22,
		config_datas = var_12_23,
		fix_event_type = arg_12_1.fix_event_type,
		monster_drop_test = arg_12_1.monster_drop_test,
		fix_drop_item = arg_12_1.fix_drop_item,
		automaton_cheat_rotation = var_12_24,
		test_descent = arg_12_1.test_descent,
		job_levels = var_12_25,
		burning_battle_id = arg_12_1.burning_battle_id,
		is_back_ground = var_12_2,
		spl_info = var_12_27,
		episode_log = json.encode(var_12_28)
	})
	
	return true
end

function goThere(arg_13_0)
	Battle:warpToRoad(arg_13_0)
end

function saveBattleInfo()
	print("!!!! save battle info ")
	
	if SceneManager:getCurrentSceneName() == "battle" then
		SAVE:set("game.restore_battle_data", {})
		
		local var_14_0 = Battle:exportCurrentBattleInfo()
		
		if var_14_0 then
			SAVE:set("game.restore_battle_data", var_14_0)
			SAVE:save()
		end
	end
end

function removeSavedBattleInfo()
	SAVE:set("game.restore_battle_data", nil)
	SAVE:save()
end

local function var_0_0(arg_16_0)
	local var_16_0 = cc.Sprite:create("img/_white.png")
	
	var_16_0:setColor(cc.c3b(0, 0, 0))
	var_16_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_16_0:setScaleX(VIEW_WIDTH / 10)
	var_16_0:setScaleY(VIEW_HEIGHT / 10)
	var_16_0:setLocalZOrder(999999)
	var_16_0:setName("bg.load")
	
	local var_16_1 = ccui.Text:create()
	
	var_16_1:setFontName("font/daum.ttf")
	var_16_1:setColor(cc.c3b(241, 241, 241))
	var_16_1:enableOutline(cc.c3b(0, 0, 0), 1)
	var_16_1:setFontSize(24)
	var_16_1:setString(T("loading_saved_data"))
	var_16_1:setPosition(VIEW_WIDTH * 0.8, DESIGN_HEIGHT * 0.1)
	var_16_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	var_16_1:setLocalZOrder(1000000)
	var_16_1:setName("nametag.load")
	arg_16_0:addChild(var_16_1)
	arg_16_0:addChild(var_16_0)
	
	return var_16_0
end

function get_restore_battle()
	local var_17_0 = SAVE:get("game.restore_battle_data")
	
	if not var_17_0 then
		return 
	end
	
	local function var_17_1(arg_18_0)
		local var_18_0 = arg_18_0.started_data
		
		arg_18_0.started_data = nil
		
		Account:selectTeam(arg_18_0.team_index or 1)
		
		return BattleLogic:makeLogic(arg_18_0.map, arg_18_0.team, {
			started_data = var_18_0,
			restore_data = arg_18_0
		})
	end
	
	local var_17_2, var_17_3 = xpcall(var_17_1, __G__TRACKBACK__, var_17_0)
	
	if var_17_2 then
		return var_17_3
	end
end

function re_enter(arg_19_0)
	TransitionScreen:show({
		on_show_before = function(arg_20_0)
			return var_0_0(arg_20_0), 200
		end
	})
	
	arg_19_0 = arg_19_0 or get_restore_battle()
	
	local var_19_0 = arg_19_0:getCurrentSubstoryID()
	
	if var_19_0 then
		SubstoryManager:setInfo(var_19_0)
	end
	
	PreLoad:beforeEnterBattle(arg_19_0)
	SceneManager:nextScene("battle", {
		logic = arg_19_0
	})
end

function MsgHandler.clear(arg_21_0)
	if arg_21_0.limits then
		Account:updateLimits(arg_21_0.limits)
	end
	
	if arg_21_0.practice_mode == true or arg_21_0.trial_cut_off == true then
		arg_21_0.map_id = arg_21_0.map
		
		ClearResult:show(Battle.logic, arg_21_0)
		
		return 
	end
	
	if arg_21_0.maze_used_unit then
		Account:setMazeUsedUnit(arg_21_0.maze_used_unit)
	end
	
	if not arg_21_0.is_back_ground then
		ConditionContentsManager:resetAllAdd()
	end
	
	if arg_21_0.add_flag then
		for iter_21_0, iter_21_1 in pairs(arg_21_0.add_flag) do
			AccountData.flags[iter_21_0] = iter_21_1
		end
	end
	
	local var_21_0 = DB("level_enter", arg_21_0.map, "substory_contents_id")
	
	if arg_21_0.map and arg_21_0.doc_dungeon_base then
		Account:setDungeonBaseInfo(arg_21_0.map, arg_21_0.doc_dungeon_base)
	end
	
	if arg_21_0.event_boosters then
		Account:setEventBoosters(arg_21_0.event_boosters)
	end
	
	if arg_21_0.clan_buffs then
		Account:setClanBuffInfos(arg_21_0.clan_buffs)
	end
	
	if arg_21_0.automaton then
		Account:setAutomatonInfo(arg_21_0.automaton)
		
		if arg_21_0.automaton.floor == 25 then
			local var_21_1 = arg_21_0.automaton.automaton_level or 0
			
			if var_21_1 == 1 then
				Singular:event("complete_automaton_tower")
			else
				Singular:event("complete_automaton_tower_lv" .. var_21_1)
			end
		end
	end
	
	local var_21_2 = {}
	local var_21_3 = {}
	local var_21_4 = {}
	local var_21_5 = {}
	local var_21_6 = {}
	
	if arg_21_0.conditions and arg_21_0.conditions.clear_conditions then
		ConditionContentsNotifier:show(arg_21_0.conditions.clear_conditions)
		GrowthGuide:updateAutoTracking(arg_21_0.conditions.clear_conditions)
		
		for iter_21_2, iter_21_3 in pairs(arg_21_0.conditions.clear_conditions) do
			ConditionContentsManager:update(iter_21_3, arg_21_0.map)
			ConditionContentsManager:setConditionGroupData(iter_21_3)
			
			if iter_21_3.contents_type == CONTENTS_TYPE.SUBSTORY_QUETS then
				table.insert(var_21_6, {
					contents_id = iter_21_3.contents_id,
					type = iter_21_3.contents_type
				})
			elseif iter_21_3.contents_type == CONTENTS_TYPE.SYS_ACHIEVEMENT then
				table.insert(var_21_6, {
					contents_id = iter_21_3.achieve_id,
					type = iter_21_3.contents_type
				})
			elseif iter_21_3.contents_type ~= CONTENTS_TYPE.BATTLE_MISSION and iter_21_3.contents_type ~= CONTENTS_TYPE.URGENT_MISSION and iter_21_3.contents_type ~= CONTENTS_TYPE.QUEST_MISSION or DB("mission_data", iter_21_3.contents_id, "hide") then
			else
				table.insert(var_21_6, {
					contents_id = iter_21_3.contents_id,
					type = iter_21_3.contents_type
				})
			end
		end
		
		for iter_21_4, iter_21_5 in pairs(arg_21_0.conditions.update_conditions or {}) do
			ConditionContentsManager:update(iter_21_5, arg_21_0.map)
			ConditionContentsManager:setConditionGroupData(iter_21_5)
		end
		
		if arg_21_0.conditions and arg_21_0.conditions.clear_conditions then
			for iter_21_6, iter_21_7 in pairs(arg_21_0.conditions.clear_conditions) do
				if iter_21_7.contents_type == CONTENTS_TYPE.BATTLE_MISSION or iter_21_7.contents_type == CONTENTS_TYPE.URGENT_MISSION then
					ConditionContentsManager:dispatch("mission.clear", {
						mission_type = iter_21_7.contents_type
					})
				end
			end
		end
	end
	
	ConditionContentsManager:dispatch("starmission.clear", {
		enter_id = arg_21_0.map
	})
	
	local var_21_7
	
	if arg_21_0.ug_mission_system then
		ConditionContentsManager:getUrgentMissions():setUpdate(arg_21_0.ug_mission_system.ug_m_list, arg_21_0.ug_mission_system.condition_group_list)
		
		var_21_7 = arg_21_0.ug_mission_system.ug_m_list
	end
	
	for iter_21_8, iter_21_9 in pairs(arg_21_0.units or {}) do
		local var_21_8 = Account:getUnit(iter_21_9.uid)
		
		if var_21_8 then
			local var_21_9 = var_21_8:getLv()
			local var_21_10 = var_21_8.inst.exp
			local var_21_11, var_21_12 = var_21_8:getExpString()
			local var_21_13, var_21_14 = var_21_8:getFavLevel()
			
			var_21_8.inst.exp = iter_21_9.exp
			var_21_8.inst.fav = iter_21_9.f
			
			local var_21_15 = var_21_8:updateLevel()
			local var_21_16, var_21_17 = var_21_8:getFavLevel()
			
			Account:onUpdateUnitLevel(var_21_8, var_21_9)
			
			local var_21_18 = iter_21_9.dist_exp or 0
			
			var_21_3[var_21_8.db.code] = {
				prev_ratio = var_21_12,
				add_exp = iter_21_9.exp - var_21_10,
				dist_exp = var_21_18
			}
			var_21_5[var_21_8.db.code] = {
				prev_exp = var_21_14,
				curr_exp = var_21_17,
				prev_lv = var_21_13,
				curr_lv = var_21_16
			}
			
			if var_21_15 then
				var_21_8:calc()
				ConditionContentsManager:dispatch("unit.levelup", {
					level = var_21_8:getLv(),
					prev_level = var_21_9,
					grade = var_21_8:getGrade(),
					chrid = var_21_8.db.code,
					unit = var_21_8,
					enter = arg_21_0.map
				})
				ConditionContentsManager:dispatch("growthboost.sync.lv")
				
				if var_21_8.db.code == "c3026" then
					ConditionContentsManager:dispatch("c3026.levelup", {
						unit = var_21_8
					})
				end
				
				var_21_2[var_21_8.db.code] = {
					prev_level = var_21_9,
					level = var_21_8:getLv()
				}
			end
			
			if var_21_13 < var_21_16 then
				var_21_4[var_21_8.db.code] = {
					prev_level = var_21_13,
					level = var_21_16
				}
				
				ConditionContentsManager:dispatch("fav.levelup", {
					level = var_21_16,
					prev_level = var_21_13,
					code = var_21_8.db.code,
					uid = var_21_8.inst.uid
				})
			end
		end
	end
	
	local var_21_19, var_21_20, var_21_21 = DB("level_enter", arg_21_0.map, {
		"type",
		"type_enterpoint",
		"use_enterpoint"
	})
	local var_21_22
	
	if var_21_20 == "to_stamina" then
		var_21_22 = var_21_21
	end
	
	Account:updateCurrencies(arg_21_0.update_currencies, {
		use_stamina = var_21_22
	})
	
	if arg_21_0.weak_use then
		Account:updateCurrencies(arg_21_0.weak_use)
	end
	
	if arg_21_0.penguin_mileage then
		Account:set_penguin_mileage(arg_21_0.penguin_mileage.penguin_mileage)
		
		if arg_21_0.penguin_mileage.rewards and arg_21_0.penguin_mileage.rewards.reward_info then
			Account:addReward(arg_21_0.penguin_mileage.rewards.reward_info)
		end
	end
	
	Account:addReward(arg_21_0.dec_rewards)
	
	local var_21_23 = Account:addReward(arg_21_0.rewards, {
		content = "battle",
		enter = arg_21_0.map,
		entertype = var_21_19
	})
	
	Account:addReward(arg_21_0.no_eff_rewards, {
		enter = arg_21_0.map
	})
	
	if arg_21_0.no_eff_get_unit then
		Account:addUnit(arg_21_0.no_eff_get_unit)
	end
	
	local var_21_24 = var_21_23.account_lv_before
	local var_21_25 = var_21_23.account_lv_after
	
	arg_21_0.first_get_units = var_21_23.new_units or {}
	
	local var_21_26 = 2
	
	for iter_21_10 = table.count(arg_21_0.first_get_units), 1, -1 do
		local var_21_27 = arg_21_0.first_get_units[iter_21_10]
		
		if var_21_27 then
			local var_21_28 = DB("character", var_21_27.code, {
				"type"
			})
			
			if var_21_27.g and var_21_26 >= var_21_27.g and var_21_28 and var_21_28 ~= "devotion" then
				table.remove(arg_21_0.first_get_units, iter_21_10)
			end
		end
	end
	
	if arg_21_0.team_modified then
		local var_21_29 = Account:getUnit(arg_21_0.team_modified.unit_uid)
		
		Account:addToTeam(var_21_29, arg_21_0.team_modified.team_idx, arg_21_0.team_modified.team_pos)
	end
	
	if DEBUG.TEST_DROP then
		print(string.format("# Stamina : %d, Gold : %d, Crystal : %d, Chaos : %d ", arg_21_0.stamina, arg_21_0.gold, arg_21_0.crystal, arg_21_0.chaos))
		
		for iter_21_11, iter_21_12 in pairs(arg_21_0.rewards.new_items) do
			print(string.format("# Item, ID : %s ( Grade : %d ), %dEA", iter_21_12.code, iter_21_12.grade, iter_21_12.count))
		end
		
		for iter_21_13, iter_21_14 in pairs(arg_21_0.rewards.new_equips) do
			print(string.format("# Equips, ID : %s ( Grade : %d ), %dEA", iter_21_14.code, iter_21_14.grade, iter_21_14.count))
		end
		
		for iter_21_15, iter_21_16 in pairs(arg_21_0.rewards.new_units) do
			print(string.format("# Character, ID : %s ( Grade : %d ), %dEA", iter_21_16.code, iter_21_16.grade, iter_21_16.count))
		end
	end
	
	Account:setCampSaveData(arg_21_0.map, nil)
	
	if arg_21_0.pkg_rank then
		AccountData.pkg_rank = arg_21_0.pkg_rank
	end
	
	if arg_21_0.hell_lv then
		AccountData.hell_lv = arg_21_0.hell_lv
		
		if string.starts(arg_21_0.map, "abyss") and arg_21_0.hell_lv >= 80 and math.mod(arg_21_0.hell_lv, 5) == 0 then
			Singular:event("Complete_Abyss_" .. arg_21_0.hell_lv)
		end
	end
	
	if arg_21_0.hell_tm then
		AccountData.hell_tm = arg_21_0.hell_tm
	end
	
	if #arg_21_0.open_land > 0 then
		Account:setLastClearLand(arg_21_0.open_land[1])
	end
	
	if arg_21_0.pass_events then
		Account:setPassEvent(arg_21_0.map, arg_21_0.pass_events)
	end
	
	if arg_21_0.clear_event then
		Account:setClearEvent(arg_21_0.map, arg_21_0.clear_event)
	end
	
	if arg_21_0.total_event then
		Account:setTotalEvent(arg_21_0.map, arg_21_0.total_event)
	end
	
	if arg_21_0.clear_way then
		Account:setClearWay(arg_21_0.map, arg_21_0.clear_way)
	end
	
	if arg_21_0.hp_infos then
		Account:procHPInfos(arg_21_0.hp_infos)
	end
	
	if arg_21_0.played_stories then
		if var_21_0 then
			Account:mergePlayedSubstoryStories(var_21_0, arg_21_0.played_stories)
		else
			Account:mergePlayedStories(arg_21_0.played_stories)
		end
	end
	
	if arg_21_0.ticketed_limits then
		Account:updateTicketedLimits(arg_21_0.ticketed_limits)
	end
	
	local var_21_30 = arg_21_0.rtn_spl_info
	
	if var_21_30 then
		SPLUserData:setSplData(var_21_30.spl_doc)
		
		for iter_21_17, iter_21_18 in pairs(var_21_30.use_object_list or {}) do
			SPLUserData:updateObjectData(iter_21_18)
		end
	end
	
	UIUtil:resetNewUnit()
	
	local var_21_31
	
	if arg_21_0.is_back_ground or BackPlayManager:isReceiveResultWait() then
		var_21_31 = BackPlayManager:getLastBattle().logic
	else
		var_21_31 = Battle.logic
	end
	
	local var_21_32 = Battle:forecastReward(var_21_31)
	
	var_21_32.equip = arg_21_0.rewards.new_equips or {}
	var_21_32.character = arg_21_0.rewards.new_units or {}
	var_21_32.items = arg_21_0.rewards.new_items or {}
	var_21_32.cp = {}
	
	local var_21_33 = {}
	
	for iter_21_19, iter_21_20 in pairs(arg_21_0.rewards.new_items or {}) do
		if DB("item_material", iter_21_20.code, "ma_type") == "cp" then
			var_21_32.cp.code = iter_21_20.code
			var_21_32.cp.value = iter_21_20.diff
		else
			table.insert(var_21_33, {
				code = iter_21_20.code,
				count = iter_21_20.diff
			})
		end
	end
	
	var_21_32.items = var_21_33
	var_21_32.drop_bouns_list = arg_21_0.drop_bouns_list or {}
	var_21_32.drop_pet_bouns_list = arg_21_0.drop_pet_bouns_list or {}
	var_21_32.first_get_units = arg_21_0.first_get_units or {}
	var_21_32.quest = {}
	var_21_32.substory_quest = {}
	var_21_32.missions = {}
	var_21_32.sys_achieve = {}
	
	for iter_21_21, iter_21_22 in pairs(var_21_6) do
		if iter_21_22.type == CONTENTS_TYPE.QUEST_MISSION then
			table.insert(var_21_32.quest, iter_21_22)
		elseif iter_21_22.type == CONTENTS_TYPE.SUBSTORY_QUETS then
			table.insert(var_21_32.substory_quest, iter_21_22)
		elseif iter_21_22.type == CONTENTS_TYPE.SYS_ACHIEVEMENT then
			table.insert(var_21_32.sys_achieve, iter_21_22.contents_id)
		else
			table.insert(var_21_32.missions, iter_21_22)
		end
	end
	
	if var_21_23 then
		var_21_32.tokens = {}
		
		for iter_21_23, iter_21_24 in pairs(var_21_23.currencies_diff or {}) do
			if iter_21_23 ~= "stamina" then
				table.insert(var_21_32.tokens, {
					t = "token",
					code = iter_21_23,
					count = iter_21_24
				})
			end
		end
	end
	
	if var_21_23 and arg_21_0.rewards_drop_stamina then
		table.insert(var_21_32.tokens, {
			code = "stamina",
			t = "token",
			count = arg_21_0.rewards_drop_stamina
		})
	end
	
	var_21_32.trial_info = arg_21_0.trial_info or {}
	
	if arg_21_0.trial_info and not arg_21_0.practice_mode then
		Account:setTrialHall(arg_21_0.trial_info.trial_id, {
			trial_id = arg_21_0.trial_info.trial_id,
			score = arg_21_0.trial_info.score
		})
	end
	
	if var_21_30 then
		var_21_32.is_spl = true
	end
	
	if arg_21_0.trial_rank_rewards and not arg_21_0.practice_mode then
		var_21_32.trial_info.trial_rank_rewards = arg_21_0.trial_rank_rewards
	end
	
	if arg_21_0.trial_bonus_rewards and not arg_21_0.practice_mode then
		var_21_32.trial_info.trial_bonus_rewards = arg_21_0.trial_bonus_rewards
	end
	
	if arg_21_0.expedition_ticket then
		var_21_32.expedition_ticket = arg_21_0.expedition_ticket
		
		local var_21_34 = Account:getCoopMissionData()
		
		table.push(var_21_34.ticket_list, arg_21_0.expedition_ticket)
		Account:setCoopMissionData(var_21_34)
	end
	
	if arg_21_0.rnd_three_device then
		var_21_32.rnd_three_device = arg_21_0.rnd_three_device
	end
	
	if arg_21_0.is_automaton_cleared then
		var_21_32.is_automaton_cleared = (Account:getAutomatonClearedFloor() or 1) >= to_n(string.sub(Battle.logic.map.enter, 7, -1)) + 1
	end
	
	if arg_21_0.custom_item_rewards then
		var_21_32.custom_item_rewards = arg_21_0.custom_item_rewards
	end
	
	if arg_21_0.penguin_mileage then
		var_21_32.penguin_mileage = arg_21_0.penguin_mileage
	end
	
	if arg_21_0.custom_item_rewards then
		Account:addReward(arg_21_0.custom_item_rewards)
	end
	
	if arg_21_0.no_eff_get_unit then
		var_21_32.no_eff_get_unit = arg_21_0.no_eff_get_unit
	end
	
	if arg_21_0.replace_unit and Account:getUnit(arg_21_0.replace_unit.id) then
		Account:replaceUnit(arg_21_0.replace_unit, {
			ignore_classchange_dispatch = true
		})
	end
	
	if arg_21_0.crevice_hunt_info then
		DungeonCreviceUtil:setSeasonInfo(arg_21_0.crevice_hunt_info.season_info)
		DungeonCreviceUtil:setBossInfo(arg_21_0.crevice_hunt_info.boss_info)
	end
	
	BattleRepeat:incWinScore(arg_21_0.is_back_ground)
	DungeonMissions:clear()
	
	if var_21_32 and (arg_21_0.is_back_ground or BattleRepeat:isPlayingRepeatPlay() or Battle:isEnterByRepeatMode()) then
		BattleRepeat:addRepeatBattleItems(var_21_32.drop_bouns_list, var_21_32.drop_pet_bouns_list, var_21_32.missions, var_21_32.tokens, var_21_32.items, var_21_32.equip, var_21_32.penguin_mileage, var_21_32.character, var_21_32.map_id)
	end
	
	if arg_21_0.is_back_ground then
		local var_21_35 = BackPlayManager:getLastBattle()
		local var_21_36 = {
			logic = var_21_35.logic,
			result = var_21_32,
			account_lv_before = var_21_24,
			account_lv_after = var_21_25,
			units_exp = var_21_3,
			units_favexp = var_21_5,
			units_levelup = var_21_2,
			fav_levelup = var_21_4,
			apper_missions = var_21_7
		}
		
		BackPlayManager:proc_next(arg_21_0, var_21_36)
		BackPlayManager:updateAccountUI()
	elseif BackPlayManager:isReceiveResultWait() then
		local var_21_37 = BackPlayManager:getLastBattle()
		local var_21_38 = {
			logic = var_21_37.logic,
			result = var_21_32,
			account_lv_before = var_21_24,
			account_lv_after = var_21_25,
			units_exp = var_21_3,
			units_favexp = var_21_5,
			units_levelup = var_21_2,
			fav_levelup = var_21_4,
			apper_missions = var_21_7
		}
		
		BackPlayManager:proc_next(arg_21_0, var_21_38)
		BackPlayManager:updateAccountUI()
	else
		Battle.vars.battle_state = "finish"
		
		Battle:onshowClearResult(Battle.logic, var_21_32, var_21_24, var_21_25, var_21_3, var_21_5, var_21_2, var_21_4, var_21_7)
	end
	
	SAVE:save()
	
	if Account:getMapClearCount(arg_21_0.map) == 1 and string.starts(arg_21_0.map, "hun") then
		Singular:event(arg_21_0.map .. "_clear")
	end
	
	SAVE:updateUserDefaultData_MainQuestClearState(Scene.lobby.END_EPISODE)
end

function MsgHandler.coop_clear(arg_22_0)
	if not CoopUtil:isValidRtn(arg_22_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	if arg_22_0.conditions and arg_22_0.conditions.clear_conditions then
		ConditionContentsNotifier:show(arg_22_0.conditions.clear_conditions)
		GrowthGuide:updateAutoTracking(arg_22_0.conditions.clear_conditions)
		
		for iter_22_0, iter_22_1 in pairs(arg_22_0.conditions.clear_conditions) do
			ConditionContentsManager:update(iter_22_1, arg_22_0.map)
			ConditionContentsManager:setConditionGroupData(iter_22_1)
		end
		
		for iter_22_2, iter_22_3 in pairs(arg_22_0.conditions.update_conditions or {}) do
			ConditionContentsManager:update(iter_22_3, arg_22_0.map)
			ConditionContentsManager:setConditionGroupData(iter_22_3)
		end
	end
	
	local var_22_0 = arg_22_0
	local var_22_1 = Account:addReward(arg_22_0.rewards, {
		condition_updates = "mh:coop_clear",
		enter = arg_22_0.map
	})
	
	if var_22_1 then
		var_22_0.tokens = {}
		
		for iter_22_4, iter_22_5 in pairs(var_22_1.currencies_diff or {}) do
			if iter_22_4 ~= "stamina" then
				table.insert(var_22_0.tokens, {
					t = "token",
					code = iter_22_4,
					count = iter_22_5
				})
			end
		end
	end
	
	if var_22_1 and arg_22_0.rewards_drop_stamina then
		table.insert(var_22_0.tokens, {
			code = "stamina",
			t = "token",
			count = arg_22_0.rewards_drop_stamina
		})
	end
	
	var_22_0.equip = arg_22_0.rewards.new_equips or {}
	var_22_0.character = arg_22_0.rewards.new_units or {}
	var_22_0.items = arg_22_0.rewards.new_items or {}
	
	local var_22_2 = {}
	
	for iter_22_6, iter_22_7 in pairs(arg_22_0.rewards.new_items or {}) do
		if DB("item_material", iter_22_7.code, "ma_type") == "cp" then
			var_22_0.cp.code = iter_22_7.code
			var_22_0.cp.value = iter_22_7.diff
		else
			table.insert(var_22_2, {
				code = iter_22_7.code,
				count = iter_22_7.diff
			})
		end
	end
	
	Battle:responseExpedition(var_22_0)
	ClearResult:show(Battle.logic, var_22_0)
end

function MsgHandler.lose(arg_23_0)
	BattleRepeat:incLoseScore(arg_23_0.is_back_ground)
	
	if arg_23_0.map_id then
		local var_23_0 = Account:getCrehuntDifficultyByEnterID(arg_23_0.map_id)
		local var_23_1 = DungeonCreviceUtil:getBossInfo(var_23_0)
		
		DungeonCreviceUtil:setBossInfo(var_23_1, true)
	end
	
	if arg_23_0.is_back_ground then
		local var_23_2 = {
			is_lota = false,
			practice_mode = false,
			is_automaton_cleared = false,
			lose = true,
			giveup = false,
			map_id = arg_23_0.map_id
		}
		
		BackPlayManager:proc_next(arg_23_0, var_23_2)
	elseif Battle.vars then
		Battle.vars.battle_state = "finish"
	end
	
	DungeonMissions:clear()
end

function ErrHandler.lose(arg_24_0, arg_24_1)
end

function MsgHandler.retry_battle(arg_25_0)
	Battle.logic.map.retry_count = arg_25_0.retry_count
	
	if ClearResult then
		ClearResult:revertPlayMissionResult()
	end
	
	if BattleUI then
		BattleUI:initActionBar()
	end
	
	if Account then
		Account:updateCurrencies(arg_25_0)
	end
	
	if Battle then
		Battle:retryPlay()
	end
end
