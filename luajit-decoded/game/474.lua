ClearResult = {}

local function var_0_0(arg_1_0)
	local var_1_0 = string.sub(arg_1_0, #"hun" + 1, #"hun" + 1)
	
	if var_1_0 then
		local var_1_1 = ({
			g = "2",
			d = "5",
			w = "1",
			q = "4",
			b = "3"
		})[var_1_0]
		
		if var_1_1 then
			local var_1_2 = string.sub(arg_1_0, #"hun" + 2, -1)
			
			if var_1_2 then
				Stove:openHuntGuidePage(var_1_1, tonumber(var_1_2))
			end
		end
	end
end

local function var_0_1(arg_2_0)
	local var_2_0 = DungeonHell:isAbyssHardMap(arg_2_0)
	local var_2_1 = var_2_0 and "abysshard" or "abyss"
	local var_2_2 = tonumber(string.sub(arg_2_0, #var_2_1 + 1, #var_2_1 + 3))
	
	if var_2_2 then
		Stove:openHellGuidePage(var_2_2, var_2_0)
	end
end

function HANDLER_BEFORE.result_reward_card(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "btn_select" then
		arg_3_0.touch_tick = systick()
	end
end

function HANDLER.result_reward_card(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_select" and systick() - to_n(arg_4_0.touch_tick) < 180 then
		ClearResult:selectItem(arg_4_0.item)
	end
end

DEBUG.LOTA_RESULT = nil

function HANDLER.result_base(arg_5_0, arg_5_1)
	if BattleRepeat:block_buttons(arg_5_1) then
		return 
	end
	
	if ClearResult:checkAutomatonWeekChange() then
		return 
	end
	
	if arg_5_1 == "btn_back" then
		if ClearResult.vars.result and ClearResult.vars.result.is_lota then
			LotaNetworkSystem:sendQuery("lota_lobby")
			SceneManager:resetSceneFlow()
			ClearResult:hide()
			
			return 
		end
		
		ClearResult:backPlayMissionResult()
	elseif arg_5_1 == "btn_lobby" then
		if SubStoryBurningDungeon:getEnterDungeonBattle() then
			SubStoryBurningDungeon:setEnterDungeonBattle(false)
		end
		
		ClearResult:lobbyPlayMissionResult()
	elseif arg_5_1 == "btn_list" then
		SceneManager:nextScene("coop", {
			caller = "battle",
			btn_list = true,
			info = ClearResult.vars.expedition_info
		})
	elseif arg_5_1 == "btn_again" or arg_5_1 == "btn_lose_again" or arg_5_1 == "btn_next" then
		ClearResult:playAgain(arg_5_1)
	elseif arg_5_1 == "btn_practice_again" then
		ClearResult:playPracticeAgain()
	elseif arg_5_1 == "btn_lose_revert" then
		ClearResult:revertDungeon()
	elseif arg_5_1 == "btn_next_battle" then
		ClearResult:playNextDungeon()
	elseif arg_5_1 == "btn_hero_upgrade" then
		SceneManager:nextScene("unit_ui")
		SceneManager:resetSceneFlow()
		ClearResult:hide()
	elseif arg_5_1 == "btn_stat" then
		if Battle:isReplayMode() then
			if not BattleUI:getReplayController() or not BattleUI:getReplayController():isVisible() then
				ClearResult:showResultStatUI()
			end
		else
			ClearResult:showResultStatUI()
		end
	elseif arg_5_1 == "btn_clanwar_stat" then
	elseif arg_5_1 == "btn_hell_back" then
		ClearResult:hellBackPlayMissionResult()
	elseif arg_5_1 == "btn_tower_back" then
		ClearResult:automatonBackPlayMissionResult()
	elseif arg_5_1 == "btn_tower_next" or arg_5_1 == "btn_hell_next" then
		ClearResult:playNextDungeon()
	elseif arg_5_1 == "btn_hell_clear" then
		local var_5_0 = DungeonHell:isAbyssHardMap(ClearResult.vars.result.map_id) and "abyss_hard_clear_title" or "abyss_clear_title"
		
		Dialog:msgRewards("", {
			txt_title = T(var_5_0),
			letter = T("abyss_clear_desc"),
			handler = function()
				SceneManager:nextScene("DungeonList", {
					mode = "Hell"
				})
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			end
		})
	elseif arg_5_1 == "btn_conquest" then
		Dialog:msgRewards("", {
			txt_title = T("automtn_clear_pop_title"),
			letter = T("automtn_clear_pop_desc"),
			handler = function()
				SceneManager:nextScene("DungeonList", {
					mode = "Automaton"
				})
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			end
		})
	elseif arg_5_1 == "btn_story_ok" then
		local var_5_1 = SceneManager:getCurrentScene().story_data
		local var_5_2 = Account:getUnit(var_5_1.target)
		
		Action:Add(SEQ(CALL(SceneManager.nextScene, SceneManager, "unit_ui", {
			mode = "Story",
			skip_ani = true,
			start_mode = "Main",
			unit = var_5_2
		}), COND_LOOP(SEQ(DELAY(10)), function()
			if UnitMain.vars then
				return true
			end
		end), CALL(SoundEngine.playBGM, SoundEngine, "event:/bgm/default"), CALL(TopBarNew.setTitleName, TopBarNew, var_5_2.db.name), CALL(query, "clear_relation_story", {
			code = var_5_2.db.code,
			story_id = var_5_1.story_id
		})), UnitStory, "block")
	elseif arg_5_1 == "btn_clanwar_ok" then
		query("clan_war_enter")
	elseif arg_5_1 == "btn_pvp_ok" or arg_5_1 == "btn_pvplive_ok" then
		if Battle:isReplayMode() then
			if not BattleUI:getReplayController() or not BattleUI:getReplayController():isVisible() then
				ClearResult:addPvpNextResult()
			end
		else
			ClearResult:addPvpNextResult()
		end
	elseif arg_5_1 == "btn_pvp_next_ok" then
		ClearResult:addPvpNextResult2()
	elseif arg_5_1 == "btn_go" then
		if not ClearResult.vars.seq:isEmpty() then
			ClearResult:nextSeq()
		end
		
		if ClearResult.vars and ClearResult.vars.is_coop then
			local var_5_3 = ClearResult.vars.expedition_info
			
			if var_5_3.last_hp > 0 and not var_5_3.clear_tm then
				SceneManager:nextScene("coop", {
					btn_go = true,
					caller = "battle",
					boss_id = ClearResult.vars.boss_id,
					info = var_5_3
				})
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			else
				Dialog:msgBox(T("expedition_result_win_desc"), {
					title = T("expedition_result_win_title"),
					handler = function()
						SceneManager:nextScene("coop", {
							caller = "battle",
							btn_list = true,
							info = var_5_3
						})
						SceneManager:resetSceneFlow()
						ClearResult:hide()
					end
				})
			end
		end
		
		if ClearResult.vars and ClearResult.vars.is_lota_with_coop then
			LotaNetworkSystem:sendQuery("lota_lobby")
			SceneManager:resetSceneFlow()
			ClearResult:hide()
		end
		
		if ClearResult.vars and ClearResult.vars.is_trial then
			SceneManager:nextScene("DungeonList", {
				mode = "Trial_Hall"
			})
			SceneManager:resetSceneFlow()
			ClearResult:hide()
		end
		
		if ClearResult.vars and ClearResult.vars.result and ClearResult.vars.result.crehunt then
			local var_5_4 = Account:getCrehuntDifficultyByEnterID(ClearResult.vars.result.map_id)
			
			if var_5_4 then
				SceneManager:nextScene("DungeonList", {
					mode = "Crevice",
					enter = true,
					no_act = true,
					is_hard_mode = var_5_4 == 1
				})
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			end
		end
	elseif arg_5_1 == "btn_ok" then
		LotaNetworkSystem:sendQuery("lota_lobby")
		SceneManager:resetSceneFlow()
		ClearResult:hide()
	elseif arg_5_1 == "btn_delete" or arg_5_1 == "btn_delete_after" then
		ClearResult:toggleResultSellMode()
	elseif arg_5_1 == "btn_sell" or arg_5_1 == "btn_sell_jpn" then
		ClearResult:sellItems(1)
	elseif arg_5_1 == "btn_extract" then
		ClearResult:sellItems(2)
	elseif arg_5_1 == "btn_booster" then
		BoosterUI:show()
	elseif arg_5_1 == "btn_lose_guide" then
		HelpGuide:open({
			auto = "lose",
			menu = "growth",
			show_move_btn = true,
			map_id = ClearResult.vars.result.map_id
		})
	elseif arg_5_1 == "btn_growth_guide" then
		Dialog:msgBox(T("fail_guide_move_popup_desc"), {
			yesno = true,
			title = T("fail_guide_move_popup_title"),
			handler = function()
				SceneManager:nextScene("growth_guide")
			end
		})
	elseif arg_5_1 == "btn_discussion" then
		local var_5_5 = ClearResult.vars.result.map_id
		local var_5_6 = DB("level_enter", var_5_5, "type")
		
		print("Discussion map id : ", var_5_5)
		
		if var_5_6 == "hunt" then
			var_0_0(var_5_5)
		elseif var_5_6 == "abyss" then
			var_0_1(var_5_5)
		end
	elseif arg_5_1 == "btn_limit" and get_cocos_refid(arg_5_0:getParent()) and arg_5_0:getParent():getName() == "talk_bg_count" and arg_5_0.fade_out == nil then
		UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false)), arg_5_0:getParent())
		
		arg_5_0.fade_out = true
	elseif string.starts(arg_5_1, "btn_move") and arg_5_0.character_data and arg_5_0.move_idx then
		ClearResult:lose_guide_quick_move(arg_5_0.character_data, arg_5_0.move_idx)
	elseif arg_5_1 == "btn_replay" and not BattleUIAction:Find("battle.replay.begin") then
		ClearResult:toggleReplayController()
	end
end

function HANDLER.unlock_system_open(arg_11_0, arg_11_1)
	if arg_11_1 == "btn_close" and arg_11_0.go then
		arg_11_0.go()
	end
end

function HANDLER.map_quest_fin(arg_12_0, arg_12_1)
	if arg_12_1 == "btn_ok" then
		ClearResult:mapQuestFinOK()
	end
end

function HANDLER.result_intimacy(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_close" then
		local var_13_0 = arg_13_0:getParent()
		local var_13_1 = var_13_0.isPVP or false
		local var_13_2 = var_13_0.isLast or false
		
		var_13_0:removeFromParent()
		
		if var_13_1 then
			if not var_13_2 then
				ClearResult:nextSeq()
			end
		elseif not var_13_0.isIntimacyPresent then
			ClearResult:nextSeq()
			BackButtonManager:pop()
		end
	end
end

function HANDLER.result_story_unlocked(arg_14_0, arg_14_1)
	if arg_14_1 == "btn_close" then
		ClearResult:closePopupUnlockSystemSubstory()
	end
end

function ClearResult.mapQuestFinOK()
	if_set_visible(ClearResult.vars.wnd, "map_quest_fin", false)
	ClearResult:nextSeq()
	BackButtonManager:pop("ClearResult")
end

function ClearResult.moveTutorial(arg_16_0, arg_16_1)
	if DEBUG.SKIP_TUTO then
		return false
	end
	
	if not UnlockSystem:isMoveToLobby(arg_16_1) then
		return false
	end
	
	if arg_16_1 == UNLOCK_ID.TRIAL_HALL and ContentDisable:byAlias("trial_hall") then
		return false
	end
	
	ClearResult:stopNextDungeonSound()
	SceneManager:nextScene("lobby", {
		unlock_id = arg_16_1
	})
	
	return true
end

function ClearResult.show(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
	arg_17_1 = arg_17_1 or {}
	arg_17_2 = arg_17_2 or {
		map_id = "",
		gold = 231,
		honor = 3,
		crystal = 20,
		pvp = true,
		grade = 3,
		units = {
			Account.units[1],
			Account.units[2],
			Account.units[3],
			Account.units[4]
		},
		equip = {
			{
				g = 5,
				code = "ecg6w",
				t = "equip"
			},
			{
				g = 5,
				code = "efw02",
				t = "equip"
			}
		},
		pvp_result = {
			revenge_count = 1,
			win = true,
			before = {
				score = 315,
				league = "bronze_5",
				rank = 5
			},
			after = {
				score = 1250,
				rank = 6,
				acquired_point = 11,
				continuous_victory = 3,
				league = "bronze_4",
				bonus_point = 5
			}
		},
		pvp_reward = {
			battle = {
				reward_id = "to_pvpgold",
				is_boost = true,
				reward_count = 550
			},
			rankup = {
				reward_id = "to_gold",
				reward_count = 350
			},
			repeats = {
				reward_id = "to_gold",
				reward_count = 250
			},
			continuous_victory = {
				reward_id = "to_pvpgold",
				reward_count = 10
			}
		},
		tournament_result = {
			is_win = true
		},
		quest = {
			{
				contents_id = "ep1_1_1"
			}
		},
		clanwar_result = {
			destroy_score = 10,
			result = 2
		}
	}
	
	local var_17_0 = arg_17_2.map_id or ""
	local var_17_1, var_17_2, var_17_3 = DB("level_enter", var_17_0, {
		"type",
		"contents_type",
		"sub_type"
	})
	
	var_17_1 = var_17_1 or ""
	var_17_2 = var_17_2 or ""
	
	local var_17_4
	
	var_17_4 = var_17_3 or ""
	arg_17_2.hell = string.starts(var_17_0, "abyss")
	arg_17_2.automaton = string.starts(var_17_0, "autom")
	arg_17_2.clan_war = string.starts(var_17_0, "clan") or arg_17_1.clan_war
	arg_17_2.pvp = string.starts(var_17_0, "pvp") and not arg_17_2.clan_war
	
	if arg_17_1.isTournament then
		arg_17_2.tournament = string.starts(var_17_0, "tournament") or arg_17_1:isTournament()
	end
	
	arg_17_2.story = string.starts(var_17_0, "sb")
	arg_17_2.maze = string.starts(var_17_1, "dungeon")
	arg_17_2.trial = string.starts(var_17_1, "trial_hall")
	arg_17_2.descent = string.starts(var_17_1, "descent")
	arg_17_2.burning = string.starts(var_17_1, "burning")
	arg_17_2.coop = arg_17_2.coop_info ~= nil
	arg_17_2.lota = arg_17_2.is_lota ~= nil
	arg_17_2.tutorial = var_17_1 == "tutorial"
	arg_17_2.character = arg_17_2.character or {}
	arg_17_2.equip = arg_17_2.equip or {}
	arg_17_2.items = arg_17_2.items or {}
	arg_17_2.missions = arg_17_2.missions or {}
	arg_17_2.sys_achieve = arg_17_2.sys_achieve or {}
	arg_17_2.units_exp = arg_17_5 or {}
	arg_17_2.units_favexp = arg_17_6 or arg_17_2.units_favexp or {}
	arg_17_2.units_levelup = arg_17_7 or {}
	arg_17_2.fav_levelup = arg_17_8 or arg_17_2.fav_levelup or {}
	arg_17_2.penguin_mileage = arg_17_2.penguin_mileage or {}
	arg_17_2.apper_missions = arg_17_9
	arg_17_2.giveup = arg_17_2.giveup
	arg_17_2.preview = arg_17_2.preview
	arg_17_2.spl = arg_17_2.is_spl
	arg_17_2.substory_id = arg_17_1 and arg_17_1.getCurrentSubstoryID and arg_17_1:getCurrentSubstoryID()
	arg_17_2.crehunt = string.starts(var_17_2, "crehunt")
	
	if arg_17_2.clan_war and arg_17_2.units then
	elseif arg_17_2.descent then
		arg_17_2.units = {}
		
		for iter_17_0, iter_17_1 in pairs(DESCENT_TEAM_IDX) do
			local var_17_5 = Account:getTeam(tonumber(iter_17_1))
			
			for iter_17_2, iter_17_3 in pairs(var_17_5) do
				if not iter_17_3.isPet then
					table.insert(arg_17_2.units, iter_17_3)
				end
			end
		end
	elseif arg_17_2.burning then
		arg_17_2.units = {}
		
		for iter_17_4, iter_17_5 in pairs(BURNING_TEAM_IDX) do
			local var_17_6 = Account:getTeam(tonumber(iter_17_5))
			
			for iter_17_6, iter_17_7 in pairs(var_17_6) do
				if not iter_17_7.isPet then
					table.insert(arg_17_2.units, iter_17_7)
				end
			end
		end
	elseif arg_17_1 and arg_17_1.starting_friends then
		arg_17_2.units = arg_17_1.starting_friends
	else
		arg_17_2.units = Account:getBattleTeam().units
	end
	
	arg_17_2.friends = arg_17_1.friends
	arg_17_0.vars = {
		blockInput = false,
		result = arg_17_2,
		seq = Sequencer:init(nil, BattleRepeat:isPlayingRepeatPlay()),
		wnd = load_dlg("result_base", true, "wnd")
	}
	
	local var_17_7 = arg_17_0.vars.result.map_id
	local var_17_8, var_17_9, var_17_10 = DB("level_enter", var_17_7, {
		"type",
		"contents_type",
		"sub_type"
	})
	
	if var_17_9 == "adventure" then
		local var_17_11, var_17_12 = DB("level_enter", var_17_7, {
			"type",
			"episode"
		})
		
		if var_17_11 and var_17_12 and var_17_11 == "extra_quest" and var_17_12 == "adventure_ep5" then
			arg_17_0.vars.is_tree = true
		end
	end
	
	arg_17_0.childs = {}
	
	local var_17_13 = arg_17_0.vars.wnd:getChildren()
	
	for iter_17_8, iter_17_9 in pairs(var_17_13) do
		arg_17_0.childs[iter_17_9:getName()] = iter_17_9
	end
	
	Dialog:closeAll()
	InBattleEsc:close()
	BattleTopBar:hideRTAPenalyTooltip()
	BattleUI:hideReplayController(true)
	
	if DeviceInventory:isOpenDeviceInventory() then
		DeviceInventory:closeDeviceInventory()
	end
	
	local var_17_14 = BattleTopBar:get_repeateControl()
	
	if get_cocos_refid(var_17_14) then
		if PetHelper:isshow() then
			PetHelper:close_petSetting()
		end
		
		BattleRepeatPopup:closeItemListPopup()
		BattleTopBarUrgentPopup:close_urgentMissionPopup()
		BattleTopBarCoopPopup:hide()
	end
	
	arg_17_0.vars.seq:getLayer():addChild(arg_17_0.vars.wnd)
	arg_17_0:hideAllNodes()
	
	if arg_17_3 ~= arg_17_4 then
		arg_17_0:addRankUpResult(arg_17_3, arg_17_4)
	end
	
	if arg_17_2.automaton then
		ClearResult:checkAutomatonWeekChange()
	end
	
	if arg_17_2.lose then
		arg_17_0:addLoseResult()
		
		if ClearResult.vars.result and ClearResult.vars.result.is_lota then
			BackButtonManager:push({
				check_id = "ClearResult.playMissionResult",
				back_func = function()
					ClearResult:lotaBackPlayMissionResult()
				end
			})
		else
			BackButtonManager:push({
				check_id = "ClearResult.playMissionResult",
				back_func = function()
					ClearResult:backPlayMissionResult()
				end
			})
		end
	elseif arg_17_2.preview then
		arg_17_0:addPreviewResult()
	elseif arg_17_2.spl then
		arg_17_0:addSplResult()
	elseif arg_17_2.net_pvp then
		arg_17_0:addNetPvpResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:addPvpNextResult()
			end
		})
	elseif arg_17_2.pvp then
		arg_17_0:addPvPResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:addPvpNextResult()
			end
		})
	elseif arg_17_2.clan_war then
		arg_17_0:addClanWarResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:backPlayMissionResult()
			end
		})
	elseif arg_17_2.tournament then
		arg_17_0:addTournamentResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:backPlayMissionResult()
			end
		})
	elseif arg_17_2.hell then
		arg_17_0:addHellResult(arg_17_2.practice_mode or DungeonHell:isAbyssHardMap(arg_17_2.map_id) and Account:getMapClearCount(arg_17_2.map_id) > 1)
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:hellBackPlayMissionResult()
			end
		})
	elseif arg_17_2.story then
		local var_17_15 = SceneManager:getCurrentScene().story_data or {
			story_id = "chsl_c1007_03",
			story_title = "chsl_c1007_03_tl",
			target = Account.units[1]:getUID()
		}
		
		arg_17_0:addStoryResult(var_17_15)
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:backPlayMissionResult()
			end
		})
	elseif arg_17_2.maze then
		arg_17_0:addMazeResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:backPlayMissionResult()
			end
		})
	elseif arg_17_2.automaton then
		arg_17_0:addAutomatonResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:automatonBackPlayMissionResult()
			end
		})
	elseif arg_17_2.trial then
		if arg_17_2.practice_mode then
			arg_17_2.trial_info.practice_mode = arg_17_2.practice_mode
		else
			arg_17_2.trial_info.practice_mode = false
		end
		
		arg_17_2.trial_info.trial_cut_off = arg_17_2.trial_cut_off
		
		arg_17_0:addTrialResult(arg_17_2.trial_info)
		
		arg_17_0.vars.is_trial = true
		
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:backPlayMissionResult()
			end
		})
	elseif arg_17_2.coop then
		arg_17_0:addCoopResult(arg_17_2)
		
		arg_17_0.vars.is_coop = true
		
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:coopBackPlayMissionResult()
			end
		})
	elseif arg_17_2.lota then
		arg_17_0.vars.is_lota = true
		arg_17_0.vars.lota_users = arg_17_2.lota_users
		arg_17_0.vars.is_lota_with_coop = arg_17_2.is_lota_with_coop
		
		arg_17_0:addLotaResult(arg_17_2)
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:lotaBackPlayMissionResult()
			end
		})
	else
		arg_17_0:addDungeonResult()
		BackButtonManager:push({
			check_id = "ClearResult.playMissionResult",
			back_func = function()
				ClearResult:backPlayMissionResult()
			end
		})
	end
	
	arg_17_0.vars.seq:play()
	
	if arg_17_2.test then
		arg_17_0.vars.result.sys_achieve = {}
		
		table.insert(arg_17_0.vars.result.sys_achieve, UNLOCK_ID.ENHANCE_UNIT)
	end
	
	if get_cocos_refid(var_17_14) then
		var_17_14:ejectFromParent()
		arg_17_0.vars.seq:getLayer():addChild(var_17_14)
		var_17_14:bringToFront()
	end
	
	if Battle.viewer and Battle.viewer:checkSaveLocalReplay(arg_17_2.net_pvp_result) then
		Battle.viewer:saveReplay(arg_17_2.net_pvp_result.replay_data, true)
	end
	
	arg_17_0:initSystemSubstoryDB()
end

function _convertTime(arg_32_0, arg_32_1)
	local var_32_0 = math.floor(arg_32_1 / 100)
	local var_32_1 = arg_32_1 % 100
	local var_32_2 = {
		min = var_32_1,
		hour = var_32_0,
		day = arg_32_0 % 100,
		month = math.floor(arg_32_0 / 100) % 100,
		year = 2000 + math.floor(arg_32_0 / 10000)
	}
	
	return os.time(var_32_2)
end

function ClearResult.initSystemSubstoryDB(arg_33_0)
	if not arg_33_0.vars or not arg_33_0.vars.result or not arg_33_0.vars.result.map_id then
		return 
	end
	
	local var_33_0 = arg_33_0.vars.result.map_id
	local var_33_1 = {}
	
	for iter_33_0 = 1, 9999 do
		local var_33_2, var_33_3, var_33_4, var_33_5, var_33_6 = DBN("substory_system_main", iter_33_0, {
			"id",
			"unlock_stage",
			"sort",
			"systemsub_open_date",
			"systemsub_open_time"
		})
		
		if not var_33_2 then
			break
		end
		
		if var_33_3 == var_33_0 then
			local var_33_7 = false
			
			if var_33_5 and var_33_6 then
				if os.time() >= _convertTime(var_33_5, var_33_6) then
					var_33_7 = true
				end
			else
				var_33_7 = true
			end
			
			if var_33_7 then
				local var_33_8 = {
					id = var_33_2,
					unlock_stage = var_33_3,
					db_sort = var_33_4
				}
				
				table.insert(var_33_1, var_33_8)
			end
		end
	end
	
	if table.count(var_33_1) >= 2 then
		table.sort(var_33_1, function(arg_34_0, arg_34_1)
			return arg_34_0.db_sort < arg_34_1.db_sort
		end)
	end
	
	arg_33_0.vars.system_substory_list = var_33_1
end

function ClearResult.isShow(arg_35_0)
	return arg_35_0.vars and get_cocos_refid(arg_35_0.vars.wnd)
end

function ClearResult.update(arg_36_0)
	if arg_36_0.vars and get_cocos_refid(arg_36_0.vars.wnd) then
		BoosterUI:update(arg_36_0.vars.wnd)
	end
	
	if arg_36_0.vars and get_cocos_refid(arg_36_0.vars.wnd) then
		local var_36_0 = true
		
		BoosterUI:updateBoosterPercent(arg_36_0.vars.wnd, var_36_0)
	end
	
	if arg_36_0.vars and get_cocos_refid(arg_36_0.vars.wnd) then
		ConditionContentsManager:getUrgentMissions():setNotiTimeUpdate()
	end
end

function ClearResult.hideAll_btns(arg_37_0, arg_37_1)
	if not get_cocos_refid(arg_37_0.vars.wnd) or BackPlayManager:isRunning() or BattleRepeat:get_isEndRepeatPlay() then
		return 
	end
	
	if arg_37_1 then
		local var_37_0 = arg_37_0.vars.wnd:getChildByName("n_lose")
		
		if_set_opacity(var_37_0, "btn_lobby", 76.5)
		if_set_opacity(var_37_0, "btn_back", 76.5)
		if_set_opacity(var_37_0, "btn_hero_upgrade", 76.5)
		if_set_opacity(var_37_0, "btn_discussion", 76.5)
		if_set_opacity(var_37_0, "btn_lose_again", 76.5)
		
		local var_37_1 = TutorialGuide:isPlayingTutorial() or not GrowthGuide:isEnable()
		local var_37_2 = var_37_0:getChildByName(var_37_1 and "n_normal" or "n_growth_guide")
		
		if_set_opacity(var_37_2, "btn_lose_guide", 76.5)
		if_set_opacity(var_37_2, "btn_growth_guide", 76.5)
		
		local var_37_3 = var_37_0:getChildByName("n_failure_guide")
		local var_37_4 = arg_37_0:_can_use_failuer_guide()
		
		if get_cocos_refid(var_37_3) and var_37_4 then
			if_set_opacity(var_37_3, "btn_lose_guide", 76.5)
			if_set_opacity(var_37_3, "btn_growth_guide", 76.5)
			arg_37_0:setOnFail_allUnitIconOpacity(76.5)
		end
	else
		local var_37_5 = getChildByPath(arg_37_0.vars.wnd, "n_reward")
		
		if_set_opacity(var_37_5, "btn_stat", 76.5)
		if_set_opacity(var_37_5, "btn_go", 76.5)
		if_set_opacity(var_37_5, "btn_delete", 76.5)
	end
end

function ClearResult.showAll_btns(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	if arg_38_0.vars.result.lose then
		local var_38_0 = arg_38_0.vars.wnd:getChildByName("n_lose")
		
		if_set_opacity(var_38_0, "btn_lobby", 255)
		if_set_opacity(var_38_0, "btn_back", 255)
		if_set_opacity(var_38_0, "btn_hero_upgrade", 255)
		if_set_opacity(var_38_0, "btn_discussion", 255)
		if_set_opacity(var_38_0, "btn_lose_again", 255)
		
		local var_38_1 = TutorialGuide:isPlayingTutorial() or not GrowthGuide:isEnable()
		local var_38_2 = var_38_0:getChildByName(var_38_1 and "n_normal" or "n_growth_guide")
		
		if_set_opacity(var_38_2, "btn_lose_guide", 255)
		if_set_opacity(var_38_2, "btn_growth_guide", 255)
		
		local var_38_3 = var_38_0:getChildByName("n_failure_guide")
		local var_38_4 = arg_38_0:_can_use_failuer_guide()
		
		if get_cocos_refid(var_38_3) and var_38_4 then
			if_set_opacity(var_38_3, "btn_lose_guide", 255)
			if_set_opacity(var_38_3, "btn_growth_guide", 255)
			arg_38_0:setOnFail_allUnitIconOpacity(255)
		end
	else
		local var_38_5 = getChildByPath(arg_38_0.vars.wnd, "n_reward")
		
		if_set_opacity(var_38_5, "btn_stat", 255)
		if_set_opacity(var_38_5, "btn_go", 255)
		if_set_opacity(var_38_5, "btn_delete", 255)
	end
end

function ClearResult.setOnFail_allUnitIconOpacity(arg_39_0, arg_39_1)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.wnd) or not arg_39_0.vars.fail_result_unit_icons or table.empty(arg_39_0.vars.fail_result_unit_icons) or not arg_39_1 then
		return 
	end
	
	for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.fail_result_unit_icons) do
		if get_cocos_refid(iter_39_1) and iter_39_1.setOpacity then
			iter_39_1:setOpacity(arg_39_1)
		end
	end
end

function ClearResult.hideAllNodes(arg_40_0)
	for iter_40_0, iter_40_1 in pairs(arg_40_0.childs) do
		if string.starts(iter_40_0, "n_") then
			iter_40_1:setOpacity(0)
			iter_40_1:setVisible(false)
		end
	end
	
	SceneManager:getRunningPopupScene():removeChildByName("util.character.popup")
end

function ClearResult.hide(arg_41_0)
	if arg_41_0.vars and get_cocos_refid(arg_41_0.vars.wnd) then
		UIAction:Add(FADE_OUT(200), arg_41_0.vars.wnd, "block")
	end
	
	ClearResult:stopNextDungeonSound()
end

function ClearResult.removeAll(arg_42_0)
	if arg_42_0.vars and get_cocos_refid(arg_42_0.vars.wnd) then
		UIAction:Add(SEQ(FADE_OUT(200), CALL(function()
			arg_42_0.vars.seq:deinit()
		end)), arg_42_0.vars.wnd, "block")
	end
	
	ClearResult:stopNextDungeonSound()
end

function ClearResult.onLeave(arg_44_0)
	BattleAction:Remove("manual.move")
end

function ClearResult.addPreviewResult(arg_45_0)
	arg_45_0.vars.seq:add(arg_45_0.playClearEffect, arg_45_0)
	arg_45_0.vars.seq:add(function()
		SceneManager:popScene()
	end, arg_45_0)
end

function ClearResult.addSplResult(arg_47_0)
	arg_47_0.vars.seq:add(arg_47_0.playClearEffect, arg_47_0)
	arg_47_0.vars.seq:add(function()
		SPLSystem:showCurtain(function()
			SceneManager:popScene()
		end)
	end, arg_47_0)
end

function ClearResult.addDungeonResult(arg_50_0)
	for iter_50_0 = 1, 3 do
		local var_50_0 = arg_50_0.vars.result.map_id
		
		if DB("level_enter", var_50_0, "mission" .. iter_50_0) then
			arg_50_0.vars.has_mission = true
			
			break
		end
	end
	
	if arg_50_0.vars.has_mission then
		arg_50_0.vars.seq:addAsync(arg_50_0.playClearEffect, arg_50_0)
		arg_50_0:addMissionResult()
		arg_50_0.vars.seq:addAsync(arg_50_0.clearMissionResult, arg_50_0)
	elseif arg_50_0.vars.result and arg_50_0.vars.result.crehunt and Battle.logic:getCreviceReturn() then
	else
		arg_50_0.vars.seq:add(arg_50_0.playClearEffect, arg_50_0)
	end
	
	if arg_50_0.vars.result.tutorial then
		arg_50_0.vars.seq:addAsync(TutorialBattle.onClearTutorialBattle, TutorialBattle)
	else
		arg_50_0:addRewardResult()
	end
end

function ClearResult.addTrialResult(arg_51_0, arg_51_1)
	arg_51_0.vars.seq:add(arg_51_0.playTrialRewardWindow, arg_51_0, arg_51_1)
end

function ClearResult.addCoopResult(arg_52_0, arg_52_1)
	arg_52_0.vars.seq:add(arg_52_0.playCoopResult, arg_52_0, arg_52_1)
end

function ClearResult.addLotaResult(arg_53_0, arg_53_1)
	arg_53_0.vars.seq:add(arg_53_0.playLotaResult, arg_53_0, arg_53_1)
end

function ClearResult.addCoopTicketResult(arg_54_0, arg_54_1)
	arg_54_0.vars.seq:add(arg_54_0.playCoopTicketResult, arg_54_0, arg_54_1)
end

function ClearResult._can_use_failuer_guide(arg_55_0)
	if not arg_55_0.vars or not arg_55_0.vars.result or not arg_55_0.vars.result.map_id then
		return 
	end
	
	if Battle.logic and Battle.logic:isNPCTeam() then
		return 
	end
	
	if arg_55_0.vars.result.is_lota then
		return 
	end
	
	local var_55_0 = arg_55_0.vars.result.map_id
	local var_55_1, var_55_2, var_55_3 = DB("level_enter", var_55_0, {
		"type",
		"contents_type",
		"sub_type"
	})
	
	if not var_55_1 and not var_55_2 then
		return 
	end
	
	local var_55_4 = {
		"substory",
		"adventure",
		"abyss",
		"automaton",
		"abyss_hard"
	}
	local var_55_5 = {
		"genie",
		"hunt",
		"dungeon",
		"descent",
		"burning"
	}
	
	if var_55_1 and table.isInclude(var_55_5, var_55_1) or var_55_2 and table.isInclude(var_55_4, var_55_2) then
		return true
	end
end

function ClearResult.showLoseUI(arg_56_0)
	if arg_56_0.vars.result.giveup then
		return 
	end
	
	if arg_56_0.vars.result and not arg_56_0.vars.result.is_lota then
		TutorialGuide:startGuide("battle_lose")
	end
	
	if arg_56_0:_can_use_failuer_guide() then
		if_set_visible(arg_56_0.childs.n_lose, "n_failure_guide", true)
		if_set_visible(arg_56_0.childs.n_lose, "n_normal", false)
		if_set_visible(arg_56_0.childs.n_lose, "n_growth_guide", false)
		if_set_visible(arg_56_0.childs.n_lose, "g", false)
		arg_56_0:init_lose_failuer_guide()
		
		local var_56_0 = not GrowthGuide:isEnable()
		local var_56_1 = arg_56_0.childs.n_lose:getChildByName("n_growth_guide2")
		
		if get_cocos_refid(var_56_1) then
			if_set_visible(var_56_1, "n_growth_guide", not var_56_0)
			
			if var_56_0 then
				if_set(var_56_1, "txt_tip", T("result_base_nlose_desc"))
			end
		end
	else
		if_set_visible(arg_56_0.childs.n_lose, "n_failure_guide", false)
		
		local var_56_2 = not GrowthGuide:isEnable()
		
		if_set_visible(arg_56_0.childs.n_lose, "n_normal", var_56_2)
		if_set_visible(arg_56_0.childs.n_lose, "n_growth_guide", not var_56_2)
	end
	
	UIAction:Add(SEQ(FADE_IN(300)), arg_56_0.childs.n_lose, "block")
	
	if arg_56_0.vars.result and not arg_56_0.vars.result.is_lota then
		arg_56_0:addRetryEffect(arg_56_0.childs.n_lose, "btn_lose_again", arg_56_0.vars.result.map_id, true)
	end
	
	if arg_56_0.vars.result and arg_56_0.vars.result.is_lota then
		if_set_visible(arg_56_0.childs.n_lose, "btn_lobby", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_lose_again", false)
		if_set_visible(arg_56_0.childs.n_lose, "n_count_info", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_discussion", false)
		if_set_visible(arg_56_0.childs.n_lose, "n_revert_info", false)
		if_set_visible(arg_56_0.childs.n_lose, "n_normal", false)
		if_set_visible(arg_56_0.childs.n_lose, "n_tip_only", true)
		if_set_visible(arg_56_0.childs.n_lose, "n_normal", false)
		if_set_visible(arg_56_0.childs.n_lose, "n_growth_guide", false)
	end
	
	if arg_56_0.vars.result.preview then
		if_set_visible(arg_56_0.childs.n_lose, "btn_lose_again", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_lobby", false)
	end
	
	if arg_56_0.vars.result.spl then
		if_set_visible(arg_56_0.childs.n_lose, "btn_lose_again", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
		if_set_visible(arg_56_0.childs.n_lose, "btn_lobby", false)
	end
	
	if arg_56_0.vars.result and arg_56_0.vars.result.automaton then
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
	end
	
	if arg_56_0.vars.result and arg_56_0.vars.result.descent then
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
	end
	
	if arg_56_0.vars.result and arg_56_0.vars.result.burning then
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
	end
	
	if arg_56_0.vars.result and arg_56_0.vars.result.crehunt then
		if_set_visible(arg_56_0.childs.n_lose, "btn_hero_upgrade", false)
	end
end

function ClearResult.showResultStatUI(arg_57_0, arg_57_1)
	function sort_reverse(arg_58_0)
		local var_58_0 = arg_57_0.vars.result.net_pvp_result
		
		if tostring(var_58_0.away_user_end_info.id) == MatchService.arena_uid then
			table.sort(arg_58_0.infos, function(arg_59_0, arg_59_1)
				if arg_59_0.ally ~= arg_59_1.ally then
					return arg_59_0.ally == ENEMY
				end
				
				return arg_59_0.all_contribution > arg_59_1.all_contribution
			end)
			
			return true
		end
		
		return false
	end
	
	local var_57_0 = arg_57_1 or {}
	
	if var_57_0.result then
		var_57_0.result_stat = var_57_0.result.result_stat
		var_57_0.is_reverse = sort_reverse(var_57_0.result_stat)
	elseif arg_57_0.vars.result.net_pvp_result then
		var_57_0.result_stat = arg_57_0.vars.result.net_pvp_result.result_stat
		var_57_0.is_reverse = sort_reverse(var_57_0.result_stat)
	else
		var_57_0.core = Battle.logic.result_stat
	end
	
	var_57_0.mvp_uid_infos = arg_57_0.vars.mvp_uid_infos
	
	ResultStatUI:show(nil, var_57_0)
end

function ClearResult._is_inlcude_unit(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_1 or not arg_60_2 then
		return 
	end
	
	if arg_60_2.isNPC and arg_60_2:isNPC() then
		return 
	end
	
	if arg_60_2:isSummon() then
		return 
	end
	
	local var_60_0 = false
	
	if arg_60_1 == 1 then
		local var_60_1 = UnitLevelUp:get_all_penguin_count() or 0
		
		var_60_0 = not arg_60_2:isMaxLevel() and var_60_1 > 0
	elseif arg_60_1 == 2 then
		if arg_60_2:isLockUpgrade6() then
			var_60_0 = false
		else
			var_60_0 = arg_60_0:_check_unit_promotable(arg_60_2)
		end
	elseif arg_60_1 == 3 and UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC) then
		if arg_60_2:isLockZodiacUpgrade5() then
			var_60_0 = false
		else
			var_60_0 = arg_60_0:_check_unit_zodiac_upgradable(arg_60_2)
		end
	elseif arg_60_1 == 4 and UnlockSystem:isUnlockSystem(UNLOCK_ID.TUTORIAL_EQUIP) then
		for iter_60_0 = 1, 7 do
			if not arg_60_2:getEquipByIndex(iter_60_0) and #UnitEquip:GetItems(arg_60_2, EQUIP:getEquipPositionByIndex(iter_60_0), {
				ignore_stone = true
			}) >= 1 then
				var_60_0 = true
				
				break
			end
		end
	elseif arg_60_1 == 5 and UnlockSystem:isUnlockSystem(UNLOCK_ID.TUTORIAL_EQUIP) then
		for iter_60_1 = 1, 7 do
			local var_60_2 = arg_60_2:getEquipByIndex(iter_60_1)
			
			if var_60_2 and not var_60_2:isMaxEnhance() then
				for iter_60_2, iter_60_3 in pairs(Account:getStoneItems(var_60_2.db.type)) do
					if iter_60_3 and to_n(iter_60_3.count) > 0 then
						var_60_0 = true
						
						break
					end
				end
				
				if var_60_0 then
					break
				end
			end
		end
	elseif arg_60_1 == 6 then
		if arg_60_2:isLockSkillUpgrade() then
			var_60_0 = false
		else
			var_60_0 = arg_60_0:_check_unit_skill_upgradable(arg_60_2)
		end
	elseif arg_60_1 == 7 and UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE) then
		if arg_60_2:getLv() >= 30 then
			local var_60_3, var_60_4 = DB("classchange_category", "cc_" .. arg_60_2.db.code, {
				"char_id",
				"char_id_cc"
			})
			
			if var_60_3 then
				var_60_0 = true
			end
		end
	elseif arg_60_1 == 8 then
		var_60_0 = arg_60_0:_check_skill_tree_upgradable(arg_60_2)
	end
	
	return var_60_0
end

function ClearResult._check_unit_skill_upgradable(arg_61_0, arg_61_1)
	local function var_61_0(arg_62_0, arg_62_1, arg_62_2)
		local var_62_0 = arg_62_0:getMaxSkillLevelByIndex(arg_62_2)
		local var_62_1 = tonumber(arg_62_0.db.grade) or 1
		local var_62_2 = "g3"
		
		if var_62_1 == 4 then
			var_62_2 = "g4"
		elseif var_62_1 > 4 then
			var_62_2 = "g5"
		end
		
		local var_62_3 = var_62_2 .. "_" .. tostring(var_62_0) .. "_" .. tostring(arg_62_1)
		
		if not DB("skill_upgrade", var_62_3, "id") then
			var_62_3 = tostring(var_62_0) .. "_" .. tostring(arg_62_1)
		end
		
		local var_62_4 = SLOW_DB_ALL("skill_upgrade", var_62_3)
		local var_62_5 = var_62_4.res0
		local var_62_6 = var_62_4.res_count0
		local var_62_7 = var_62_4.res1
		local var_62_8 = var_62_4.res_count1
		local var_62_9 = var_62_4["res2_" .. arg_62_0.db.zodiac]
		local var_62_10 = var_62_4.res_count2
		
		return var_62_5, var_62_6, var_62_7, var_62_8, var_62_9, var_62_10
	end
	
	if not (arg_61_1:isSpecialUnit() or arg_61_1:isPromotionUnit() or arg_61_1:isDevotionUnit()) then
		local var_61_1 = arg_61_1:isSkillUpgradable()
		local var_61_2 = DB("character", arg_61_1.inst.code, "grade") or 3
		local var_61_3 = 3
		
		if var_61_2 <= 2 then
			var_61_3 = 2
		end
		
		for iter_61_0 = 1, var_61_3 do
			if arg_61_1:getSkillLevelByIndex(iter_61_0) ~= arg_61_1:getMaxSkillLevelByIndex(iter_61_0) then
				local var_61_4 = arg_61_1:getSkillLevelByIndex(iter_61_0) + 1
				local var_61_5, var_61_6, var_61_7, var_61_8, var_61_9, var_61_10 = var_61_0(arg_61_1, var_61_4, iter_61_0)
				local var_61_11 = 0
				
				if var_61_5 then
					var_61_11 = var_61_11 + 1
				end
				
				if var_61_7 then
					var_61_11 = var_61_11 + 1
				end
				
				if var_61_9 then
					var_61_11 = var_61_11 + 1
				end
				
				local var_61_12 = 0
				
				if var_61_5 and var_61_6 <= Account:getPropertyCount(var_61_5) then
					var_61_12 = var_61_12 + 1
				end
				
				if var_61_7 and var_61_8 <= Account:getPropertyCount(var_61_7) then
					var_61_12 = var_61_12 + 1
				end
				
				if var_61_9 and var_61_10 <= Account:getPropertyCount(var_61_9) then
					var_61_12 = var_61_12 + 1
				end
				
				if var_61_11 == var_61_12 then
					return true
				end
			end
		end
	end
end

function ClearResult._check_unit_promotable(arg_63_0, arg_63_1)
	local var_63_0, var_63_1
	
	if arg_63_1:isUpgradable() then
		var_63_0 = arg_63_1:getGrade()
		var_63_1 = 0
		
		local var_63_2 = Account:getUnits()
		
		if var_63_2 and not table.empty(var_63_2) then
			for iter_63_0, iter_63_1 in pairs(var_63_2) do
				if iter_63_1:isPromotionUnit() and iter_63_1:getGrade() == arg_63_1:getGrade() or arg_63_1:getGrade() == 2 and iter_63_1:getGrade() == 2 then
					var_63_1 = var_63_1 + 1
				end
				
				if var_63_1 == var_63_0 then
					return true
				end
			end
		end
	end
end

function ClearResult._check_unit_zodiac_upgradable(arg_64_0, arg_64_1)
	if not arg_64_1 then
		return 
	end
	
	local function var_64_0(arg_65_0, arg_65_1, arg_65_2)
		arg_65_2 = arg_65_2 or arg_65_0:getZodiacGrade()
		
		return DB("rune_req", arg_65_0:getRuneDBKey(), "req" .. arg_65_2 + 1 .. "_" .. arg_65_1)
	end
	
	local function var_64_1(arg_66_0, arg_66_1, arg_66_2)
		arg_66_2 = arg_66_2 or arg_66_0:getZodiacGrade()
		
		return to_n(DB("rune_req", arg_66_0:getRuneDBKey(), "count" .. arg_66_2 + 1 .. "_" .. arg_66_1))
	end
	
	if arg_64_1:isZodiacUpgradable() then
		local var_64_2 = arg_64_1:getZodiacGrade()
		
		if var_64_2 < 6 then
			local var_64_3 = var_64_2 + 1
			
			if not (var_64_3 > arg_64_1:getGrade() + 1) and (not (arg_64_1:getLv() < var_64_3 * 10) or not (var_64_3 > 1)) then
				local var_64_4 = 0
				local var_64_5 = 0
				local var_64_6 = var_64_0(arg_64_1, 1)
				
				if var_64_6 then
					var_64_4 = Account:getItemCount(var_64_6)
				end
				
				local var_64_7 = var_64_0(arg_64_1, 2)
				
				if var_64_7 then
					var_64_5 = Account:getItemCount(var_64_7)
				end
				
				local var_64_8 = var_64_1(arg_64_1, 1)
				local var_64_9 = var_64_1(arg_64_1, 2)
				
				if var_64_8 <= var_64_4 and var_64_9 <= var_64_5 then
					return true
				end
			end
		end
	end
end

function ClearResult._check_skill_tree_upgradable(arg_67_0, arg_67_1)
	for iter_67_0 = 1, 9999 do
		local var_67_0, var_67_1 = DBN("classchange_category", iter_67_0, {
			"char_id",
			"char_id_cc"
		})
		
		if not var_67_0 then
			break
		end
		
		if arg_67_1.db.code == var_67_1 then
			local var_67_2, var_67_3 = arg_67_0:_makeSkillTreeData(arg_67_1)
			
			if var_67_2 and var_67_3 then
				for iter_67_1 = 1, 10 do
					if arg_67_0:getEnhancable(arg_67_1, iter_67_1, var_67_3) then
						return true
					end
				end
			end
			
			break
		end
	end
end

local var_0_2 = 5
local var_0_3 = 3

function ClearResult._makeSkillTreeData(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_1
	local var_68_1 = string.format("st_%s_", var_68_0.db.code)
	local var_68_2 = {}
	local var_68_3 = {}
	local var_68_4 = true
	local var_68_5 = 0
	
	for iter_68_0 = 1, var_0_2 do
		local var_68_6 = {}
		local var_68_7 = var_68_1 .. iter_68_0
		local var_68_8 = DBT("skill_tree", var_68_7, {
			"id",
			"skill_point",
			"pos_1",
			"req_1",
			"pos_2",
			"req_2",
			"pos_3",
			"req_3"
		})
		
		if not var_68_8.id then
			var_68_4 = false
			
			break
		end
		
		var_68_6.id = var_68_7
		var_68_6.skill_point = var_68_8.skill_point
		var_68_6.childs = {}
		var_68_6.line_num = iter_68_0
		
		for iter_68_1 = 1, var_0_3 do
			local var_68_9 = {
				id = var_68_8["pos_" .. iter_68_1],
				req = var_68_8["req_" .. iter_68_1],
				pos = iter_68_0 .. "_" .. iter_68_1,
				index = (iter_68_0 - 1) * var_0_3 + iter_68_1,
				line_num = iter_68_0
			}
			
			if var_68_9.id then
				var_68_5 = var_68_5 + 1
				var_68_9.num = var_68_5
				var_68_9.opts = {}
				
				for iter_68_2 = 0, 99 do
					local var_68_10 = {}
					local var_68_11 = var_68_9.id .. "_" .. iter_68_2
					local var_68_12 = DBT("skill_tree_rune", var_68_11, {
						"id",
						"name",
						"type",
						"icon_rune",
						"icon_mark",
						"stat",
						"value",
						"skill_number",
						"skill_lv",
						"tooltip",
						"tooltip_up",
						"tooltip_value",
						"tooltip_up_value"
					})
					
					if not var_68_12.id then
						break
					end
					
					table.merge(var_68_10, var_68_12)
					table.insert(var_68_9.opts, var_68_10)
				end
			end
			
			table.insert(var_68_6.childs, iter_68_1, var_68_9)
		end
		
		var_68_6.next_num = var_68_5
		
		table.insert(var_68_3, var_68_6)
	end
	
	local var_68_13 = var_68_3
	
	return var_68_4, var_68_13
end

function ClearResult.getEnhancable(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	if not arg_69_1 or not arg_69_2 then
		return 
	end
	
	local var_69_0 = arg_69_3 or {}
	
	local function var_69_1(arg_70_0)
		local var_70_0 = arg_70_0
		local var_70_1 = var_70_0:getSTreeTotalPoint() + 1
		local var_70_2
		
		if EpisodeAdin:isAdinCode(var_70_0.db.code) then
			var_70_2 = var_70_0.db.code .. "_" .. var_70_1
		else
			var_70_2 = var_70_0:getColor() .. "_" .. var_70_1
		end
		
		return (DBT("skill_tree_material", var_70_2, {
			"res1",
			"res1_count",
			"res2",
			"res2_count",
			"reset_token",
			"reset_count"
		}))
	end
	
	local function var_69_2(arg_71_0, arg_71_1)
		if not var_69_0 then
			return 
		end
		
		local var_71_0 = arg_71_1 or "id"
		
		if var_71_0 == "index" or var_71_0 == "num" then
			arg_71_0 = tonumber(arg_71_0)
		end
		
		if not arg_71_0 then
			return 
		end
		
		for iter_71_0, iter_71_1 in pairs(var_69_0) do
			for iter_71_2, iter_71_3 in pairs(iter_71_1.childs or {}) do
				if arg_71_0 == iter_71_3[var_71_0] then
					return iter_71_3
				end
			end
		end
	end
	
	local var_69_3 = var_69_1(arg_69_1)
	
	if not table.empty(var_69_3) then
		local var_69_4 = #{
			var_69_3.res1,
			var_69_3.res2
		}
		
		for iter_69_0 = 1, 2 do
			local var_69_5 = var_69_3["res" .. iter_69_0]
			
			if var_69_5 then
				local var_69_6 = var_69_3["res" .. iter_69_0 .. "_count"]
				
				if to_n(var_69_6) > Account:getItemCount(var_69_5) then
					return false
				end
			end
		end
	end
	
	local var_69_7 = var_69_2(arg_69_2, "num")
	
	if var_69_7.req then
		local var_69_8 = var_69_2(var_69_7.req)
		
		if var_69_8.num and arg_69_1:getSTreeLevel(var_69_8.num) <= 0 then
			return false
		end
	end
	
	local var_69_9 = arg_69_1:getSTreeLevel(var_69_7.num)
	
	if var_69_7.opts and var_69_9 >= #var_69_7.opts - 1 then
		return false
	end
	
	local var_69_10 = arg_69_1:getSTreeTotalPoint()
	local var_69_11 = var_69_7.line_num
	
	if var_69_0 then
		for iter_69_1, iter_69_2 in pairs(var_69_0) do
			if iter_69_2.line_num and iter_69_2.line_num == var_69_11 and iter_69_2.skill_point and var_69_10 < iter_69_2.skill_point then
				return false
			end
		end
	end
	
	return true
end

function ClearResult.init_lose_failuer_guide(arg_72_0)
	if not arg_72_0.vars or not get_cocos_refid(arg_72_0.vars.wnd) then
		return 
	end
	
	local var_72_0 = arg_72_0.childs.n_lose:getChildByName("n_failure_guide")
	local var_72_1 = var_72_0:getChildByName("port_pos")
	local var_72_2 = arg_72_0.vars.result.units
	local var_72_3 = Battle.logic:getKeySlotUnit()
	
	if get_cocos_refid(var_72_0) then
		local var_72_7, var_72_8, var_72_10
		
		if var_72_2 then
			local var_72_4 = {}
			
			for iter_72_0, iter_72_1 in pairs(var_72_2) do
				local var_72_5 = Account:getUnit(iter_72_1:getUID())
				
				if var_72_5 then
					table.insert(var_72_4, var_72_5)
				end
			end
			
			if table.empty(var_72_4) then
				return 
			end
			
			if var_72_3 then
				local var_72_6 = table.find(var_72_4, function(arg_73_0, arg_73_1)
					return var_72_3:getUID() == arg_73_1:getUID()
				end)
				
				if var_72_6 then
					table.remove(var_72_4, var_72_6)
				end
			end
			
			var_72_2 = var_72_4
			var_72_7 = var_72_2[math.random(1, table.count(var_72_2))]
			
			if var_72_7 then
				local var_72_9
				
				var_72_8, var_72_9 = UIUtil:getPortraitAni(var_72_7.db.face_id, {
					parent_pos_y = var_72_1:getPositionY()
				})
				
				if not var_72_9 then
					var_72_8:setAnchorPoint(0.5, 0.15)
				end
				
				var_72_8:setScale(0.8)
				var_72_1:addChild(var_72_8)
				
				var_72_10 = var_72_7:getEmotion_id()
				
				if var_72_10 then
					for iter_72_2 = 1, 10 do
						local var_72_11 = DB("character_intimacy_level", var_72_10 .. "_" .. iter_72_2, {
							"emotion"
						})
						
						if var_72_11 and var_72_11 == "sad" then
							UnitMain:setPortraitEmotion(var_72_7, var_72_8, var_72_11)
						end
					end
				end
			end
		end
		
		local var_72_12 = "fail_guide_desc_0%d"
		local var_72_13 = 8
		local var_72_14 = {}
		
		for iter_72_3 = 1, var_72_13 do
			local var_72_15 = {}
			
			for iter_72_4, iter_72_5 in pairs(var_72_2) do
				if arg_72_0:_is_inlcude_unit(iter_72_3, iter_72_5) then
					table.insert(var_72_15, iter_72_5)
				end
			end
			
			if not table.empty(var_72_15) then
				table.insert(var_72_14, {
					id = iter_72_3,
					text = string.format(var_72_12, iter_72_3),
					units = var_72_15
				})
			end
		end
		
		local var_72_16 = table.empty(var_72_14)
		
		if_set_visible(var_72_0, "n_guide_img", var_72_16)
		if_set_visible(var_72_0, "n_growth_list", not var_72_16)
		
		if var_72_16 then
			local var_72_17 = var_72_0:getChildByName("n_guide_img")
			local var_72_18 = math.random(1, 3)
			local var_72_19 = string.format("tutorial/growtip_00%d.png", var_72_18)
			local var_72_20 = string.format("fail_guide_img_title_0%d", var_72_18)
			local var_72_21 = string.format("fail_guide_img_desc_0%d", var_72_18)
			
			if_set(var_72_17, "txt_title", T(var_72_20))
			if_set(var_72_17, "txt_desc", T(var_72_21))
			
			local var_72_22 = cc.Sprite:create(var_72_19)
			
			if var_72_22 then
				var_72_17:getChildByName("n_tip_img"):addChild(var_72_22)
				var_72_22:setAnchorPoint(0, 0)
				var_72_22:setPosition(0, 0)
			end
		else
			local var_72_23 = var_72_0:getChildByName("n_growth_list"):getChildByName("list_grow_move")
			
			if var_72_23 then
				local var_72_24 = BattleRepeat:isPlayingRepeatPlay()
				
				arg_72_0.vars.fail_result_unit_icons = {}
				
				local var_72_25 = {
					"img/icon_menu_rolematerial.png",
					"img/icon_menu_rolematerial_up.png",
					"img/icon_menu_awake.png",
					"img/icon_menu_equipment.png",
					"img/icon_menu_equipment_up.png",
					"img/icon_menu_mura.png",
					"img/icon_menu_classchange.png",
					"img/icon_menu_classchange_up.png"
				}
				
				arg_72_0.vars.list_grow_move = ItemListView:bindControl(var_72_23)
				
				local var_72_26 = {
					onUpdate = function(arg_74_0, arg_74_1, arg_74_2)
						local var_74_0 = arg_74_1:getChildByName("n_mob_icon")
						local var_74_1 = arg_74_2.units
						
						if_set_sprite(arg_74_1, "n_icon", var_72_25[arg_74_2.id])
						if_set(arg_74_1, "txt_title", T(arg_74_2.text))
						
						local var_74_2 = arg_74_1:getChildByName("n_guide")
						local var_74_3 = arg_74_1:getChildByName("txt_title"):getStringNumLines()
						
						if not var_74_2.orign_y and var_74_3 >= 2 then
							var_74_2.orign_y = var_74_2:getPositionY()
							
							var_74_2:setPositionY(var_74_2.orign_y + 10)
						end
						
						if var_74_0 and not table.empty(var_74_1) then
							for iter_74_0 = 1, 4 do
								local var_74_4 = var_74_1[iter_74_0]
								
								if var_74_4 then
									local var_74_5 = var_74_0:getChildByName("n_mob" .. iter_74_0)
									local var_74_6 = {
										name = false,
										role = true,
										no_popup = true,
										no_lv = false,
										no_grade = false,
										parent = var_74_5:getChildByName("n_face" .. iter_74_0),
										border_code = var_74_4.border_code,
										zodiac = var_74_4:getZodiacGrade(),
										s = var_74_4.s
									}
									local var_74_7 = UIUtil:getUserIcon(var_74_4, var_74_6)
									
									if var_72_24 and var_74_7 then
										var_74_7:setOpacity(76.5)
									end
									
									if get_cocos_refid(var_74_7) then
										table.insert(arg_72_0.vars.fail_result_unit_icons, var_74_7)
									elseif var_74_4 and var_74_4.db and var_74_4.db.code then
										Log.e("Err: no user icon // " .. var_74_4.db.code)
									end
									
									local var_74_8 = var_74_5:getChildByName("btn_move" .. iter_74_0)
									
									if var_74_8 then
										var_74_8.character_data = var_74_4
										var_74_8.move_idx = arg_74_2.id
									end
								else
									if_set_visible(var_74_0, "n_mob" .. iter_74_0, false)
								end
							end
						end
					end
				}
				
				arg_72_0.vars.list_grow_move:setRenderer(load_control("wnd/hero_grow_guide_item.csb"), var_72_26)
				arg_72_0.vars.list_grow_move:setItems(var_72_14)
			end
		end
	end
end

function ClearResult.lose_guide_quick_move(arg_75_0, arg_75_1, arg_75_2)
	if not arg_75_1 or not arg_75_2 or not arg_75_0.vars or not get_cocos_refid(arg_75_0.vars.wnd) or not arg_75_0.vars.result then
		return 
	end
	
	if not arg_75_1.getUID then
		return 
	end
	
	local var_75_0 = arg_75_2 or 1
	local var_75_1 = arg_75_1:getUID()
	
	if not var_75_1 then
		return 
	end
	
	local var_75_2
	local var_75_3 = {
		"epic7://unit_ui?mode=LevelUp&unit_uid=" .. var_75_1,
		"epic7://unit_ui?mode=Upgrade&unit_uid=" .. var_75_1,
		"epic7://unit_ui?mode=Zodiac&unit_uid=" .. var_75_1,
		"epic7://unit_ui?mode=Detail&detail_mode=Equip&unit_uid=" .. var_75_1,
		"epic7://unit_ui?mode=Detail&unlock=system_064&unit_uid=" .. var_75_1,
		"epic7://unit_ui?mode=Skill&unit_uid=" .. var_75_1,
		"epic7://class_change",
		"epic7://unit_ui?mode=Zodiac&enter_mode=Rune&unit_uid=" .. var_75_1
	}
	
	if var_75_0 == 8 then
		local var_75_4 = {
			"classchange_fire",
			"classchange_ice",
			"classchange_wind",
			"classchange_light",
			"classchange_dark"
		}
		local var_75_5 = false
		
		for iter_75_0, iter_75_1 in pairs(var_75_4) do
			if TutorialGuide:isClearedTutorial(iter_75_1) then
				var_75_5 = true
				
				break
			end
		end
		
		if not var_75_5 then
			var_75_0 = 3
		end
	end
	
	local var_75_6 = var_75_3[var_75_0]
	
	if not var_75_6 then
		return 
	end
	
	Dialog:msgBox(T("fail_guide_move_popup_desc2"), {
		yesno = true,
		title = T("fail_guide_move_popup_title2"),
		handler = function()
			SceneManager:resetSceneFlow()
			movetoPath(var_75_6)
		end
	})
end

function ClearResult.addLoseResult(arg_77_0)
	arg_77_0.vars.seq:addAsync(arg_77_0.playFailedEffect, arg_77_0)
	arg_77_0:showLoseUI()
	
	if BattleRepeat:isPlayingRepeatPlay() then
		BattleRepeat:repeat_battle({
			lose = true
		})
	else
		BattleTopBar:open_RepeateControlAgain()
	end
end

function ClearResult.isVisibleDiscussion(arg_78_0)
	if not IS_PUBLISHER_STOVE then
		return false
	end
	
	if type == "hunt" and not ContentDisable:byAlias("hunt_guide") then
		return true
	end
	
	if type == "abyss" and not ContentDisable:byAlias("abyss_guide") and contents_type ~= "automaton" then
		return true
	end
	
	return false
end

function ClearResult.addRetryEffect(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
	local var_79_0 = DB("level_enter", arg_79_0.vars.result.map_id, {
		"achievement_link"
	})
	local var_79_1, var_79_2 = DB("level_enter", arg_79_3, {
		"type",
		"contents_type"
	})
	local var_79_3 = var_79_1 == "dungeon" and arg_79_4
	
	if_set_visible(arg_79_1, "btn_lose_revert", var_79_3)
	if_set_visible(arg_79_1, "n_revert_info", var_79_3)
	if_set_visible(arg_79_1, "btn_discussion", arg_79_0:isVisibleDiscussion())
	
	local var_79_4 = arg_79_1:getChildByName("n_count_info")
	
	var_79_4:setVisible(false)
	
	if var_79_0 then
		UIUtil:showSubstoryAchievementBalloon(var_79_4, var_79_0)
	end
	
	arg_79_0:updateDifficultyButton(arg_79_1, arg_79_3)
	UIUtil:setButtonEnterInfo(arg_79_1:getChildByName(arg_79_2), arg_79_3, {
		automaton_free_enter = arg_79_0.vars.result.is_automaton_cleared
	})
	arg_79_0:showFreeTipUI()
	
	if string.find(arg_79_0.vars.result.map_id, "hard") ~= nil and Account:getMapClearCount(arg_79_3) > 0 then
		if_set_visible(arg_79_1, "btn_lose_again", false)
		if_set_visible(arg_79_1, "btn_practice_again", true)
		TopBarNew:setCurrencies({
			"crystal",
			"gold",
			"abysskey",
			"stigma"
		})
	else
		if_set_visible(arg_79_1, "btn_lose_again", arg_79_0.vars.result.practice_mode ~= true)
		if_set_visible(arg_79_1, "btn_practice_again", arg_79_0.vars.result.practice_mode == true)
	end
	
	if var_79_3 then
		local var_79_5 = Battle.logic.map.retry_count and Battle.logic.map.retry_count < 1
		local var_79_6 = var_79_5 and T("shop_price_free") or tostring(GAME_STATIC_VARIABLE.retry_crystal_cost)
		local var_79_7 = arg_79_1:getChildByName("btn_lose_revert")
		
		if_set(var_79_7, "cost", var_79_6)
		
		local var_79_8 = arg_79_1:getChildByName("btn_lose_again")
		
		if get_cocos_refid(var_79_8) then
			var_79_8:setPositionX(var_79_7:getPositionX() - var_79_8:getContentSize().width)
		end
		
		local var_79_9 = arg_79_1:getChildByName("n_revert_info")
		
		if get_cocos_refid(var_79_9) then
			local var_79_10 = var_79_9:getChildByName("txt")
			
			if get_cocos_refid(var_79_10) then
				local var_79_11 = var_79_9:getChildByName("talk_bg")
				
				if get_cocos_refid(var_79_11) then
					local var_79_12 = var_79_5 and T("retry_balloon_free") or T("retry_balloon_normal")
					
					var_79_10:setString(var_79_12)
					
					local var_79_13 = var_79_5 and cc.c3b(118, 94, 64) or cc.c3b(25, 107, 0)
					
					var_79_10:setColor(var_79_13)
					
					local var_79_14 = var_79_10:getContentSize()
					local var_79_15 = var_79_11:getContentSize()
					
					var_79_11:setContentSize(var_79_14.width * var_79_10:getScaleX() + 40, var_79_15.height)
				end
			end
		end
	end
end

function ClearResult.showFreeTipUI(arg_80_0)
	if not arg_80_0.vars or not get_cocos_refid(arg_80_0.vars.wnd) or not arg_80_0.vars.result or not arg_80_0.vars.result.is_automaton_cleared then
		return 
	end
	
	local var_80_0 = arg_80_0.vars.wnd:getChildByName("n_free_tip")
	
	if_set_visible(arg_80_0.vars.wnd, "n_free_tip", true)
	if_set(var_80_0, "txt_free_info", T("automtn_enter_free"))
	
	if var_80_0 then
		UIAction:Add(SEQ(DELAY(3000), LOG(FADE_OUT(500)), REMOVE()), var_80_0)
	end
end

function ClearResult.addRankUpResult(arg_81_0, arg_81_1, arg_81_2)
	arg_81_0.vars.seq:add(function()
	end)
	arg_81_0.childs.n_rankup:setVisible(true)
	arg_81_0.childs.n_rankup:setOpacity(255)
	Rankup:open(arg_81_1, arg_81_2, arg_81_0.childs.n_rankup, function()
		arg_81_0:nextSeq()
	end)
	BackButtonManager:pop()
	arg_81_0.vars.seq:addClearAsync("n_rankup")
end

function ClearResult.addClanWarResult(arg_84_0)
	arg_84_0.vars.seq:addAsync(arg_84_0.playClanWarEffect, arg_84_0, arg_84_0.vars.result.clanwar_result, arg_84_0.vars.result.reward_info)
	arg_84_0:addPvPClanWarResultFavPopUp()
	arg_84_0.childs.n_pvp:setVisible(true)
	arg_84_0.childs.n_pvp:setOpacity(0)
end

function ClearResult.addTournamentResult(arg_85_0)
	local var_85_0
	
	if arg_85_0.vars.result.tournament_id then
		if arg_85_0.vars.result.tournament_result.is_win then
			var_85_0 = DB("substory_tournament", arg_85_0.vars.result.tournament_id, "story_win")
		else
			var_85_0 = DB("substory_tournament", arg_85_0.vars.result.tournament_id, "story_lose")
		end
	end
	
	if var_85_0 then
		arg_85_0.vars.seq:add(start_new_story, nil, var_85_0, {
			force = true,
			on_finish = function()
				arg_85_0:nextSeq()
			end
		})
	end
	
	arg_85_0.vars.seq:addAsync(arg_85_0.playTournamentEffect, arg_85_0, arg_85_0.vars.result.pvp_result)
	arg_85_0.childs.n_pvp:setVisible(true)
	arg_85_0.childs.n_pvp:setOpacity(0)
end

function ClearResult.addPvPResult(arg_87_0)
	local var_87_0 = arg_87_0.vars.result.npc_id
	local var_87_1
	
	if var_87_0 then
		if arg_87_0.vars.result.pvp_result.win then
			var_87_1 = DB("pvp_npcbattle", var_87_0, "story_win")
		else
			var_87_1 = DB("pvp_npcbattle", var_87_0, "story_lose")
		end
	end
	
	if var_87_1 then
		arg_87_0.vars.seq:add(start_new_story, nil, var_87_1, {
			force = true,
			on_finish = function()
				arg_87_0:nextSeq()
			end
		})
	end
	
	if var_87_0 then
		arg_87_0.vars.seq:addAsync(arg_87_0.playPvpNpcEffect, arg_87_0, arg_87_0.vars.result.pvp_result.win)
	else
		arg_87_0.vars.seq:addAsync(arg_87_0.playPvpEffect, arg_87_0, arg_87_0.vars.result.pvp_result.win)
	end
	
	arg_87_0:addPvPClanWarResultFavPopUp()
	arg_87_0.childs.n_pvp:setVisible(true)
	arg_87_0.childs.n_pvp:setOpacity(0)
end

function ClearResult.addPvPClanWarResultFavPopUp(arg_89_0)
	if not arg_89_0.vars or not arg_89_0.vars.result or not arg_89_0.vars.result.units then
		return 
	end
	
	local var_89_0, var_89_1
	
	if arg_89_0.vars.result.units then
		var_89_0 = {}
		
		for iter_89_0, iter_89_1 in pairs(arg_89_0.vars.result.units) do
			if DB("character", iter_89_1.db.code, "emotion_id") and (DEBUG.TEST_FAVUP or iter_89_1:getBaseGrade() > 2 and arg_89_0.vars.result.fav_levelup[iter_89_1.db.code]) then
				table.insert(var_89_0, iter_89_1)
			end
		end
		
		var_89_1 = true
		
		for iter_89_2, iter_89_3 in pairs(var_89_0) do
			arg_89_0.vars.seq:addRaw(arg_89_0.addPopupFavLevelUp, arg_89_0, iter_89_3, var_89_1, true, iter_89_2 == table.count(var_89_0))
			
			var_89_1 = false
		end
	end
end

function ClearResult.uiActionIntimacyProgress(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	local var_90_0 = math.max(arg_90_3.curr_lv - arg_90_3.prev_lv, 0)
	local var_90_1 = arg_90_3.curr_exp + var_90_0
	
	UIAction:Add(SEQ(DELAY(400), COND_LOOP(DELAY(100), function()
		arg_90_2.progress_var = arg_90_2.progress_var or arg_90_3.prev_exp
		
		if var_90_1 <= arg_90_2.progress_var then
			arg_90_2.fav_prog[1]:setPercentage(arg_90_3.curr_exp * 100)
			arg_90_2.fav_prog[2]:setPercentage(arg_90_3.curr_exp * 100)
			
			return true
		end
		
		arg_90_2.progress_var = arg_90_2.progress_var + var_90_1 / 100
		
		arg_90_2.fav_prog[1]:setPercentage(arg_90_2.progress_var < var_90_0 and 100 or arg_90_3.curr_exp * 100)
		arg_90_2.fav_prog[2]:setPercentage(arg_90_2.progress_var * 100 % 100)
	end)), arg_90_2.fav_prog[2], "fav_add")
	
	for iter_90_0 = 1, 2 do
		UIAction:Add(SEQ(DELAY((arg_90_1 - 1) * 85), SHOW(true), FADE_IN(300)), arg_90_2.fav_prog[iter_90_0], "block")
	end
end

function ClearResult.uiActionIntimacy(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = arg_92_1:getChildByName("intimacy")
	
	if not get_cocos_refid(var_92_0) then
		return 
	end
	
	local var_92_1 = NONE()
	
	if arg_92_2.prev_lv < arg_92_2.curr_lv then
		var_92_1 = SEQ(DELAY(460), CALL(function()
			local var_93_0 = arg_92_2.prev_lv > 7 and 3 or arg_92_2.prev_lv > 4 and 2 or 1
			local var_93_1 = string.format("img/hero_love_icon_%d.png", var_93_0)
			
			if_set_sprite(arg_92_1, "hero_love_icon", var_93_1)
			if_set(arg_92_1, "t_lv", arg_92_2.curr_lv)
		end))
	end
	
	UIAction:Add(SEQ(DELAY(400), CALL(function()
		EffectManager:Play({
			fn = "ui_result_love.cfx",
			y = -40,
			delay = 340,
			scale = 0.8,
			layer = var_92_0
		})
	end), var_92_1), var_92_0, "fav_change")
end

function ClearResult.getMvpUnit(arg_95_0)
	local var_95_0, var_95_1 = Battle.logic.result_stat:SelectMVP()
	local var_95_2
	
	for iter_95_0, iter_95_1 in pairs(var_95_1 or {}) do
		if iter_95_1.is_mvp then
			var_95_2 = iter_95_0
		end
	end
	
	if not var_95_2 then
		return arg_95_0.vars.result.units[math.random(1, #arg_95_0.vars.result.units)]
	end
	
	return var_95_1[var_95_2].unit
end

function ClearResult.addResultFavorite(arg_96_0, arg_96_1)
	if not arg_96_0.vars or not arg_96_0.vars.result then
		return 
	end
	
	if not get_cocos_refid(arg_96_1) then
		Log.e("ClearResult.addResultFavorite", "n_pvp is invalid")
		
		return 
	end
	
	local var_96_0 = arg_96_0.vars.result.units_favexp or {}
	
	if table.empty(var_96_0) then
		return 
	end
	
	local var_96_1 = arg_96_0.vars.result.units or {}
	
	if table.empty(var_96_1) then
		return 
	end
	
	local var_96_2 = (table.count(var_96_1) or 0) % 2 == 0
	local var_96_3 = arg_96_1:getChildByName(var_96_2 and "n_intimacy_even" or "n_intimacy_odd")
	
	if not get_cocos_refid(var_96_3) then
		Log.e("ClearResult.addResultFavorite", "n_intimacy is invalid")
		
		return 
	end
	
	if_set_visible(arg_96_1, "n_intimacy", true)
	if_set_visible(arg_96_1, "n_intimacy_even", var_96_2)
	if_set_visible(arg_96_1, "n_intimacy_odd", not var_96_2)
	
	local var_96_4 = arg_96_0:getMvpUnit()
	local var_96_5 = 0
	
	for iter_96_0, iter_96_1 in pairs(var_96_1) do
		if iter_96_1 then
			local var_96_6 = var_96_3:getChildByName("n_" .. iter_96_0)
			
			if not get_cocos_refid(var_96_6) then
				break
			end
			
			local var_96_7 = arg_96_0:getCharacterWindow(iter_96_1, {
				isPVP = true
			})
			
			if not get_cocos_refid(var_96_7) then
				break
			end
			
			var_96_5 = var_96_5 + 1
			
			var_96_6:addChild(var_96_7)
			if_set_visible(var_96_7, "progress_white", false)
			if_set_visible(var_96_7, "progress_orange", false)
			if_set_visible(var_96_7, "n_mvp", iter_96_1 == var_96_4)
			if_set_visible(var_96_6, "Node_156", false)
			var_96_7:setOpacity(0)
			
			arg_96_0.childs["char" .. var_96_5] = var_96_7
			
			UIAction:Add(SEQ(DELAY((var_96_5 - 1) * 85), SLIDE_IN(300, 600)), var_96_7, "block")
			
			if get_cocos_refid(var_96_7.fav) then
				UIAction:Add(SEQ(SHOW(false), OPACITY(0, 0, 0), DELAY(400), SLIDE_IN_Y(600, 600), DELAY(2000), FADE_OUT(600)), var_96_7.fav, "fav_add")
			end
			
			local var_96_8 = var_96_0[iter_96_1.db.code]
			
			if var_96_8 and var_96_7.fav_prog and var_96_7.fav_prog[2] then
				arg_96_0:uiActionIntimacyProgress(var_96_5, var_96_7, var_96_8)
				arg_96_0:uiActionIntimacy(var_96_7, var_96_8)
			end
		end
	end
	
	for iter_96_2 = var_96_5 + 1, 10 do
		local var_96_9 = var_96_3:getChildByName("n_" .. iter_96_2)
		
		if not get_cocos_refid(var_96_9) then
			break
		end
		
		var_96_9:setVisible(false)
	end
end

function getNetUserEndInfo(arg_97_0, arg_97_1)
	if arg_97_0.home_user_end_info and arg_97_0.away_user_end_info then
		if tostring(arg_97_0.home_user_end_info.id) == arg_97_1 then
			return arg_97_0.home_user_end_info
		else
			return arg_97_0.away_user_end_info
		end
	end
	
	return nil
end

function getNetOtherUserEndInfo(arg_98_0, arg_98_1)
	if arg_98_0.home_user_end_info and arg_98_0.away_user_end_info then
		if tostring(arg_98_0.home_user_end_info.id) ~= arg_98_1 then
			return arg_98_0.home_user_end_info
		else
			return arg_98_0.away_user_end_info
		end
	end
	
	return nil
end

function ClearResult.actLeagueUp(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	UIAction:Add(SEQ(FADE_OUT(250), REMOVE()), arg_99_0.childs.pvp_result_eff)
	arg_99_0:hideAllNodes()
	arg_99_0.childs.n_pvp_next:setVisible(true)
	arg_99_0.childs.n_pvp_next:setOpacity(0)
	
	local var_99_0 = cc.Sprite:create("emblem/" .. arg_99_3 .. ".png")
	
	if var_99_0 then
		var_99_0:setAnchorPoint(0.5, 0.5)
		var_99_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2 + 130)
		var_99_0:setScale(1.8)
		var_99_0:setOpacity(0)
		arg_99_0.childs.n_pvp_next:addChild(var_99_0)
	end
	
	arg_99_0.vars.result_pvp_emblem = var_99_0
	arg_99_0.vars.result_pvp_emblem_c = 0
	arg_99_0.vars.result_pvp_emblem_s = 1.9
	
	if_set(arg_99_0.childs.n_pvp_next, "new_rank", T(arg_99_2))
	if_set(arg_99_0.childs.n_pvp_next, "txt_rank1", T(arg_99_1))
	if_set(arg_99_0.childs.n_pvp_next, "txt_rank2", T(arg_99_2))
	
	if false then
		arg_99_0.childs.n_pvp_next:getChildByName("n_rank_change"):setColor(cc.c3b(51, 122, 195))
	end
	
	UIAction:Add(SEQ(DELAY(500), COND_LOOP(SEQ(DELAY(10), CALL(function()
		arg_99_0.vars.result_pvp_emblem_c = arg_99_0.vars.result_pvp_emblem_c + 1
		
		if arg_99_0.vars.result_pvp_emblem_c < 23 then
			arg_99_0.vars.result_pvp_emblem_s = arg_99_0.vars.result_pvp_emblem_s + 0.03
		else
			arg_99_0.vars.result_pvp_emblem_s = arg_99_0.vars.result_pvp_emblem_s - 0.02
		end
		
		if arg_99_0.vars.result_pvp_emblem_s < 1.8 then
			arg_99_0.vars.result_pvp_emblem_s = 1.8
		end
		
		arg_99_0.vars.result_pvp_emblem:setScale(arg_99_0.vars.result_pvp_emblem_s)
	end)), function()
		return arg_99_0.vars.result_pvp_emblem_c > 76
	end)), arg_99_0.vars.result_pvp_emblem)
	UIAction:Add(SEQ(DELAY(500), FADE_IN(300), CALL(function()
		arg_99_0.vars.result_pvp_emblem:setOpacity(255)
		
		local var_102_0 = CACHE:getEffect("ui_pvp_rankup.cfx")
		
		var_102_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2 + 130)
		var_102_0:start()
		SoundEngine:play("event:/ui/pvp/rankup")
		
		arg_99_0.childs.pvp_rankup_eff = var_102_0
		
		arg_99_0.vars.wnd:addChild(var_102_0, 500)
	end)), arg_99_0.childs.n_pvp_next, "block")
end

function ClearResult.actBatchFinish(arg_103_0, arg_103_1)
	local var_103_0 = load_dlg("pvplive_tier_placement_p", true, "wnd")
	
	if_set(var_103_0, "txt_user_rank", "")
	if_set(var_103_0, "txt_rating", "")
	SpriteCache:resetSprite(var_103_0:getChildByName("icon_league"), "emblem/" .. ARENA_UNRANK_ICON)
	
	local function var_103_1()
		if not get_cocos_refid(var_103_0) then
			return 
		end
		
		local var_104_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_104_0:setGlobalZOrder(1)
		var_104_0:setOpacity(0)
		var_104_0:setVisible(true)
		
		local var_104_1 = cc.Sequence:create(cc.FadeIn:create(0.5), cc.DelayTime:create(2), cc.FadeOut:create(1))
		
		var_104_0:runAction(var_104_1)
		var_103_0:getChildByName("icon_league"):addChild(var_104_0)
	end
	
	local function var_103_2()
		if not get_cocos_refid(var_103_0) then
			return 
		end
		
		local var_105_0 = CACHE:getEffect("ui_rank_rating_f.cfx")
		
		var_105_0:setAnchorPoint(0.5, 0.5)
		var_105_0:setPosition(100, 90)
		var_105_0:start()
		var_103_0:getChildByName("icon_league"):addChild(var_105_0)
	end
	
	local function var_103_3()
		if not get_cocos_refid(var_103_0) then
			return 
		end
		
		local var_106_0 = CACHE:getEffect("ui_rank_ratin_b.cfx")
		
		var_106_0:setAnchorPoint(0.5, 0.5)
		var_106_0:setPosition(var_103_0:getChildByName("icon_league"):getPosition())
		var_106_0:start()
		var_103_0:getChildByName("n_contents"):addChild(var_106_0)
		var_106_0:bringToFront()
	end
	
	local function var_103_4()
		if not get_cocos_refid(var_103_0) then
			return 
		end
		
		local var_107_0, var_107_1 = getArenaNetRankInfo(arg_103_0.vars.result.net_pvp_season, arg_103_1.league_id)
		
		if_set(var_103_0, "txt_user_rank", T(var_107_0))
		if_set(var_103_0, "txt_rating", T("pvp_point", {
			point = comma_value(arg_103_1.new_score)
		}))
		SpriteCache:resetSprite(var_103_0:getChildByName("icon_league"), "emblem/" .. var_107_1 .. ".png")
	end
	
	UIAction:Add(SEQ(SPAWN(CALL(var_103_2), CALL(var_103_3)), DELAY(1200), CALL(var_103_4)), arg_103_0, "act.batch.finish")
	Dialog:msgBox(T(""), {
		dlg = var_103_0,
		handler = function()
			if arg_103_0:isReplayMode() then
				if Battle.viewer:getReplayFromSceneName() ~= "arena_net_lobby" then
					SceneManager:nextScene("lobby")
					SceneManager:resetSceneFlow()
					ClearResult:hide()
				else
					MatchService:query("arena_net_enter_lobby", nil, function(arg_109_0)
						SceneManager:nextScene("arena_net_lobby", arg_109_0)
						SceneManager:resetSceneFlow()
					end)
				end
			else
				MatchService:query("arena_net_enter_lobby", nil, function(arg_110_0)
					SceneManager:nextScene("arena_net_lobby", arg_110_0)
					SceneManager:resetSceneFlow()
					ClearResult:hide()
				end)
			end
		end
	})
end

function ClearResult.addPvpNextResult(arg_111_0)
	if arg_111_0.vars.result.tournament then
		if arg_111_0.vars.result.first_get_units and #arg_111_0.vars.result.first_get_units > 0 then
			UIUtil:playNewUnitEffect(ClearResult.vars.wnd, function()
				SceneManager:popScene()
				ClearResult:hide()
			end, arg_111_0.vars.result.first_get_units)
		else
			SceneManager:popScene()
			ClearResult:hide()
		end
		
		return 
	elseif arg_111_0.vars.result.net_pvp_result then
		local var_111_0 = getNetUserEndInfo(arg_111_0.vars.result.net_pvp_result, MatchService.arena_uid)
		local var_111_1 = false
		local var_111_2 = false
		
		if var_111_0 then
			local var_111_3, var_111_4, var_111_5 = getArenaNetRankInfo(arg_111_0.vars.result.net_pvp_season, var_111_0.old_league_id)
			local var_111_6, var_111_7, var_111_8 = getArenaNetRankInfo(arg_111_0.vars.result.net_pvp_season, var_111_0.league_id)
			local var_111_9 = (var_111_0.win or 0) + (var_111_0.draw or 0) + (var_111_0.lose or 0)
			
			if var_111_9 <= ARENA_MATCH_BATCH_COUNT then
				if ArenaService:getMatchMode() == "net_rank" and var_111_9 == ARENA_MATCH_BATCH_COUNT then
					arg_111_0:actBatchFinish(var_111_0)
					
					var_111_2 = true
				else
					arg_111_0:addPvpNextResult2()
				end
			elseif var_111_5 < var_111_8 then
				local var_111_10 = getArenaNetRankInfo(arg_111_0.vars.result.net_pvp_season, var_111_0.old_league_id)
				local var_111_11, var_111_12 = getArenaNetRankInfo(arg_111_0.vars.result.net_pvp_season, var_111_0.league_id)
				
				var_111_1 = true
				
				arg_111_0:actLeagueUp(var_111_10, var_111_11, var_111_12)
			else
				arg_111_0:addPvpNextResult2()
			end
		else
			arg_111_0:addPvpNextResult2()
		end
		
		BackButtonManager:pop("ClearResult.playMissionResult")
		
		if var_111_1 then
			BackButtonManager:push({
				check_id = "ClearResult.rankupPopup",
				back_func = function()
					arg_111_0:addPvpNextResult2()
				end
			})
		end
		
		if var_111_2 then
			BackButtonManager:push({
				check_id = "ClearResult.batchFinishPopup",
				back_func = function()
					arg_111_0:addPvpNextResult2()
				end
			})
		end
	else
		local var_111_13 = PvpSA:getLeagueList()
		local var_111_14 = var_111_13[arg_111_0.vars.result.pvp_result.before.league]
		local var_111_15 = var_111_13[arg_111_0.vars.result.pvp_result.after.league]
		
		if not arg_111_0.vars.result.npc_id and var_111_15 < var_111_14 then
			local var_111_16 = DB("pvp_sa", arg_111_0.vars.result.pvp_result.before.league, "name")
			local var_111_17, var_111_18 = DB("pvp_sa", arg_111_0.vars.result.pvp_result.after.league, {
				"name",
				"emblem"
			})
			
			arg_111_0:actLeagueUp(var_111_16, var_111_17, var_111_18)
		else
			arg_111_0:addPvpNextResult2()
		end
		
		BackButtonManager:pop("ClearResult.playMissionResult")
	end
end

function ClearResult.addPvpNextResult2(arg_115_0, arg_115_1)
	if arg_115_0.vars.result.net_pvp_result then
		if arg_115_0:isReplayMode() then
			if Battle.viewer:getReplayFromSceneName() ~= "arena_net_lobby" then
				SceneManager:nextScene("lobby")
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			else
				MatchService:query("arena_net_enter_lobby", nil, function(arg_116_0)
					SceneManager:nextScene("arena_net_lobby", arg_116_0)
					SceneManager:resetSceneFlow()
				end)
			end
		elseif ArenaService:getMatchMode() == "net_friend" then
			if arg_115_1 and arg_115_1.finish then
				SceneManager:nextScene("arena_net_round_result", {
					result = arg_115_0.vars.result.net_pvp_result,
					match_info = ArenaService:getMatchInfo()
				})
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			else
				ArenaService:changeState("TRANS", {
					offscreen = true
				})
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			end
		elseif ArenaService:getMatchMode() == "net_event_rank" then
			ArenaService:changeState("TRANS", {
				offscreen = true
			})
			SceneManager:resetSceneFlow()
			ClearResult:hide()
		else
			MatchService:query("arena_net_enter_lobby", nil, function(arg_117_0)
				SceneManager:nextScene("arena_net_lobby", arg_117_0)
				SceneManager:resetSceneFlow()
				ClearResult:hide()
			end)
		end
	elseif arg_115_0.vars.result.pvp_reward.rankup and arg_115_0.vars.result.pvp_reward.rankup.reward_id then
		local var_115_0 = load_dlg("dlg_pvp_reward", true, "wnd")
		
		UIUtil:getRewardIcon(arg_115_0.vars.result.pvp_reward.rankup.reward_count, arg_115_0.vars.result.pvp_reward.rankup.reward_id, {
			show_small_count = true,
			show_name = true,
			scale = 0.8,
			detail = true,
			parent = var_115_0:getChildByName("n_item_pos")
		})
		
		local var_115_1 = DB("pvp_sa", arg_115_0.vars.result.pvp_result.after.league, "name")
		
		Dialog:msgBox(T("advance_prize_league", {
			name = T(var_115_1)
		}), {
			dlg = var_115_0,
			title = T("advance_prize"),
			handler = function()
				ClearResult:moveToPvpScene()
			end
		})
	else
		arg_115_0:addPopupUnlockSystem({
			pvp = true
		})
	end
end

function ClearResult.addStoryResult(arg_119_0, arg_119_1)
	arg_119_0.vars.seq:addAsync(arg_119_0.playClearEffect, arg_119_0)
	arg_119_0.childs.n_story:setVisible(true)
	arg_119_0.childs.n_story:setOpacity(0)
	
	local var_119_0 = Account:getUnit(arg_119_1.target)
	local var_119_1 = arg_119_1.story_id
	local var_119_2 = arg_119_1.story_title
	
	if_set(arg_119_0.childs.n_story, "txt_char_name", T(var_119_0.db.name))
	
	local var_119_3 = arg_119_0.childs.n_story:getChildByName("txt_episode_title")
	
	UIAction:Remove(var_119_3)
	var_119_3:setString("")
	UIAction:Add(SEQ(SOUND_TEXT(T(var_119_2), true, 120)), var_119_3)
	UIAction:Add(SEQ(FADE_IN(300)), arg_119_0.childs.n_story, "block")
end

function ClearResult.addNetPvpResult(arg_120_0)
	if ArenaService:isSpectator() then
		arg_120_0.vars.seq:addAsync(arg_120_0.playNetPvpWatchEffect, arg_120_0)
		arg_120_0.childs.n_pvplive_watch:setVisible(true)
		arg_120_0.childs.n_pvplive_watch:setOpacity(0)
	elseif arg_120_0:isReplayMode() then
		local var_120_0 = Battle:getReplayPlayer():getMatchInfo()
		
		arg_120_0.vars.seq:addAsync(arg_120_0.playNetPvpEffect, arg_120_0, var_120_0)
		arg_120_0.childs.n_pvp:setVisible(true)
		arg_120_0.childs.n_pvp:setOpacity(0)
	else
		local var_120_1 = ArenaService:getMatchInfo() or {
			user_info = {},
			enemy_user_info = {}
		}
		
		arg_120_0.vars.seq:addAsync(arg_120_0.playNetPvpEffect, arg_120_0, var_120_1)
		arg_120_0.childs.n_pvp:setVisible(true)
		arg_120_0.childs.n_pvp:setOpacity(0)
	end
end

function ClearResult.addMazeResult(arg_121_0)
	arg_121_0.vars.seq:addAsync(arg_121_0.playClearEffect, arg_121_0)
	arg_121_0:addMissionResult(true)
	arg_121_0:addMazeProgressResult()
	arg_121_0.vars.seq:addAsync(function()
		arg_121_0:clearMissionResult()
		arg_121_0:clearMazeResult()
	end)
	arg_121_0:addRewardResult()
end

function ClearResult.addMazeProgressResult(arg_123_0)
	arg_123_0.vars.seq:add(arg_123_0.playMazeResult, arg_123_0)
end

function ClearResult.playMazeResult(arg_124_0)
	arg_124_0.childs.n_maze:setVisible(true)
	arg_124_0.childs.n_maze:setOpacity(0)
	
	local var_124_0 = math.floor(arg_124_0.vars.result.prev_pass_way_percent or 0)
	local var_124_1 = math.floor(Account:getExplore(arg_124_0.vars.result.map_id))
	
	if var_124_1 > 100 then
		var_124_1 = 100
	end
	
	local var_124_2, var_124_3 = DB("level_enter", arg_124_0.vars.result.map_id, {
		"name",
		"local"
	})
	
	if_set(arg_124_0.childs.n_maze, "txt_conti", T(var_124_3))
	if_set(arg_124_0.childs.n_maze, "txt_title", T(var_124_2))
	
	local var_124_4 = arg_124_0.childs.n_maze:getChildByName("txt_floor_exp")
	local var_124_5 = arg_124_0.childs.n_maze:getChildByName("exp_gauge")
	
	var_124_5:setPercent(var_124_0 / 100)
	var_124_4:setString(var_124_0)
	UIAction:Add(LOG(INC_NUMBER(1000, var_124_1)), arg_124_0.childs.n_maze:getChildByName("txt_floor_exp"), "block")
	UIAction:Add(LOG(PROGRESS(1000, var_124_0 / 100, var_124_1 / 100)), var_124_5, "block")
	UIAction:Add(SEQ(FADE_IN(300)), arg_124_0.childs.n_maze, "block")
end

function ClearResult.clearMazeResult(arg_125_0)
	UIAction:Add(SEQ(FADE_OUT(300)), arg_125_0.childs.n_maze, "block")
end

function ClearResult.addHellResult(arg_126_0, arg_126_1)
	if string.find(arg_126_0.vars.result.map_id, "hard") then
		for iter_126_0 = 1, 3 do
			local var_126_0 = arg_126_0.vars.result.map_id
			
			if DB("level_enter", var_126_0, "mission" .. iter_126_0) then
				arg_126_0.vars.has_mission = true
				
				break
			end
		end
	end
	
	arg_126_0.vars.seq:addAsync(arg_126_0.playClearEffect, arg_126_0)
	
	if arg_126_0.vars.has_mission then
		arg_126_0:addMissionResult()
		arg_126_0.vars.seq:addAsync(arg_126_0.clearMissionResult, arg_126_0)
	end
	
	arg_126_0:addHellRewardResult(arg_126_1)
	arg_126_0:addPvPClanWarResultFavPopUp()
end

function ClearResult.addHellRewardResult(arg_127_0, arg_127_1)
	arg_127_0.vars.seq:addAsync(arg_127_0.playHellRewardWindow, arg_127_0, arg_127_1)
end

function ClearResult.addAutomatonResult(arg_128_0)
	arg_128_0.vars.seq:addAsync(arg_128_0.playClearEffect, arg_128_0)
	arg_128_0.vars.seq:addAsync(arg_128_0.playAutomatonRewardWindow, arg_128_0)
end

function ClearResult.addMissionResult(arg_129_0, arg_129_1, arg_129_2)
	if not arg_129_0.vars.result then
		arg_129_0.vars.seq:add(function()
		end)
		
		return 
	end
	
	arg_129_0.childs.n_mission:setVisible(true)
	arg_129_0.childs.n_mission:setOpacity(0)
	
	if arg_129_1 then
		arg_129_0.vars.seq:addAsync(arg_129_0.playMissionResult, arg_129_0)
	else
		arg_129_0.vars.seq:add(arg_129_0.playMissionResult, arg_129_0)
	end
end

function ClearResult.addMissionToResultMissions(arg_131_0, arg_131_1)
	table.insert(arg_131_0.vars.result.missions, arg_131_1)
end

function ClearResult.coopBackPlayMissionResult(arg_132_0)
	local var_132_0 = arg_132_0.vars.expedition_info
	
	SceneManager:nextScene("coop", {
		caller = "battle",
		btn_list = true,
		info = var_132_0
	})
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.lotaBackPlayMissionResult(arg_133_0)
	LotaNetworkSystem:sendQuery("lota_lobby")
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.backPlayMissionResult(arg_134_0, arg_134_1)
	SceneManager:popScene(arg_134_1)
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.lobbyPlayMissionResult(arg_135_0)
	SceneManager:nextScene("lobby")
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.hellBackPlayMissionResult(arg_136_0)
	SceneManager:nextScene("DungeonList", {
		mode = "Hell",
		enter = true,
		is_hard_mode = DungeonHell:isAbyssHardMap(arg_136_0.vars.result.map_id)
	})
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.automatonBackPlayMissionResult(arg_137_0)
	SceneManager:nextScene("DungeonList", {
		enter = true,
		mode = "Automaton"
	})
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.moveToUnitInven(arg_138_0)
	SceneManager:nextScene("unit_ui", {
		mode = "Detail"
	})
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.moveToEquipInven(arg_139_0)
	SceneManager:nextScene("lobby", {
		doAfterNextSceneLoaded = function()
			Inventory:open(SceneManager:getRunningPopupScene(true))
		end
	})
	SceneManager:resetSceneFlow()
	ClearResult:hide()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.revertPlayMissionResult(arg_141_0)
	ClearResult:removeAll()
	BackButtonManager:pop("ClearResult.playMissionResult")
end

function ClearResult.playMissionResult(arg_142_0)
	UIAction:Add(FADE_IN(250), arg_142_0.childs.n_mission, "block")
	
	local var_142_0 = arg_142_0.childs.n_mission:getChildByName("n_items")
	local var_142_1 = 0
	
	local function var_142_2(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5)
		if arg_143_2 then
			local var_143_0 = {
				scale = 0.9,
				grade_max = true,
				parent = arg_143_0,
				target = arg_143_1,
				set_drop = arg_143_4,
				grade_rate = arg_143_5
			}
			
			UIUtil:getRewardIcon(arg_143_3, arg_143_2, var_143_0)
		end
	end
	
	local var_142_3 = 0
	
	for iter_142_0 = 1, 3 do
		local var_142_4 = arg_142_0.vars.result.map_id
		local var_142_5 = DB("level_enter", var_142_4, "mission" .. iter_142_0)
		
		if not var_142_5 then
			local var_142_6 = var_142_0:getChildByName("mission" .. iter_142_0 - 1)
			
			if get_cocos_refid(var_142_6) then
				if_set_visible(var_142_6, "bar", false)
			end
			
			break
		end
		
		local var_142_7 = load_dlg("result_mission_item", true, "wnd")
		local var_142_8 = 255
		local var_142_9
		
		if_set_visible(var_142_7, "already_take", false)
		if_set_visible(var_142_7, "icon_check", true)
		
		local var_142_10, var_142_11, var_142_12, var_142_13, var_142_14, var_142_15, var_142_16, var_142_17, var_142_18, var_142_19 = DB("mission_data", var_142_5, {
			"icon",
			"name",
			"reward_id1",
			"reward_count1",
			"reward_id2",
			"reward_count2",
			"grade_rate1",
			"grade_rate2",
			"set_drop_rate_id1",
			"set_drop_rate_id2"
		})
		
		if table.isInclude(arg_142_0.vars.result.missions, function(arg_144_0, arg_144_1)
			if arg_144_1.contents_id == var_142_5 then
				return true
			end
		end) then
			var_142_2(var_142_7, "n_item1", var_142_12, var_142_13, var_142_18, var_142_16)
			var_142_2(var_142_7, "n_item2", var_142_14, var_142_15, var_142_19, var_142_17)
			
			var_142_9 = "clear"
		elseif false and ConditionContentsManager:isMissionCleared(var_142_5, {
			inbattle = true,
			enter_id = var_142_4
		}) then
			if_set_visible(var_142_7, "already_take", true)
			
			var_142_9 = "already"
		else
			var_142_8 = 76
			
			var_142_2(var_142_7, "n_item1", var_142_12, var_142_13, var_142_18, var_142_16)
			var_142_2(var_142_7, "n_item2", var_142_14, var_142_15, var_142_19, var_142_17)
			if_set_visible(var_142_7, "icon_check", false)
			
			var_142_9 = "yet"
		end
		
		if_set(var_142_7, "txt_type", T("mission_stage"))
		if_set(var_142_7, "txt_desc", T(var_142_11))
		
		local var_142_20 = var_142_7:getContentSize().width
		
		var_142_1 = var_142_1 + var_142_20
		
		var_142_7:setPosition((iter_142_0 - 1) * var_142_20, 0)
		var_142_7:setAnchorPoint(0, 0)
		var_142_7:setOpacity(0)
		var_142_7:setName("mission" .. iter_142_0)
		var_142_0:addChild(var_142_7)
		UIAction:Add(SEQ(DELAY((iter_142_0 - 1) * 85), SLIDE_IN(300, -600, nil, var_142_8)), var_142_7, "block")
		
		if var_142_9 == "clear" then
			EffectManager:Play({
				fn = "ui_mission_reward.cfx",
				y = 80,
				x = 128,
				layer = var_142_7,
				delay = 300 + iter_142_0 * 85
			})
		end
		
		var_142_3 = var_142_3 + 1
	end
	
	for iter_142_1, iter_142_2 in pairs(arg_142_0.vars.result.missions) do
		if iter_142_2.type == CONTENTS_TYPE.URGENT_MISSION then
			arg_142_0.vars.clear_urgent_mission = iter_142_2.contents_id
			
			break
		end
	end
	
	if arg_142_0.vars.clear_urgent_mission then
		local var_142_21 = load_dlg("result_mission_item", true, "wnd")
		
		if_set_visible(var_142_0, "bar3", true)
		if_set_visible(var_142_21, "already_take", false)
		if_set_visible(var_142_21, "icon_check", true)
		if_set_visible(var_142_0, "bar3", true)
		
		local var_142_22, var_142_23, var_142_24, var_142_25, var_142_26, var_142_27, var_142_28, var_142_29, var_142_30, var_142_31 = DB("mission_data", arg_142_0.vars.clear_urgent_mission, {
			"icon",
			"name",
			"reward_id1",
			"reward_count1",
			"reward_id2",
			"reward_count2",
			"grade_rate1",
			"grade_rate2",
			"set_drop_rate_id1",
			"set_drop_rate_id2"
		})
		
		var_142_2(var_142_21, "n_item1", var_142_24, var_142_25, var_142_30, var_142_28)
		var_142_2(var_142_21, "n_item2", var_142_26, var_142_27, var_142_31, var_142_29)
		if_set(var_142_21, "txt_type", T("mission_base_urgent_title"))
		if_set(var_142_21, "txt_desc", T(var_142_23))
		
		local var_142_32 = var_142_21:getContentSize().width
		
		var_142_1 = var_142_1 + var_142_32
		
		var_142_21:setPosition(var_142_3 * var_142_32, 0)
		var_142_21:setAnchorPoint(0, 0)
		var_142_21:setOpacity(0)
		var_142_21:setName("mission" .. var_142_3)
		var_142_0:addChild(var_142_21)
		UIAction:Add(SEQ(DELAY((var_142_3 - 1) * 85), SLIDE_IN(300, -600, nil, 255)), var_142_21, "block")
		EffectManager:Play({
			fn = "ui_mission_reward.cfx",
			y = 80,
			x = 128,
			layer = var_142_21,
			delay = 300 + var_142_3 * 85
		})
	else
		if_set_visible(var_142_0, "bar3", false)
	end
	
	var_142_0:setPositionX(40 + (DESIGN_WIDTH - var_142_1) / 2)
end

function ClearResult.clearMissionResult(arg_145_0)
	local var_145_0
	
	for iter_145_0 = 1, 5 do
		local var_145_1 = arg_145_0.childs.n_mission:getChildByName("mission" .. iter_145_0)
		
		if not var_145_1 then
			break
		end
		
		var_145_0 = true
		
		UIAction:Add(SEQ(DELAY((iter_145_0 - 1) * 85), SLIDE_OUT(250, -600), REMOVE()), var_145_1)
	end
	
	if var_145_0 then
		UIAction:Add(FADE_OUT(300), arg_145_0.childs.n_mission, "block")
	end
end

function ClearResult.addMenuResult(arg_146_0)
	arg_146_0:addRetryEffect(arg_146_0.childs.n_buttons, "btn_again", arg_146_0.vars.result.map_id, false)
	
	local var_146_0 = arg_146_0:getNextDungeon(arg_146_0.vars.result.map_id)
	
	if_set_visible(arg_146_0.childs.n_buttons, "btn_next_battle", false)
	
	local var_146_1 = arg_146_0.childs.n_buttons:getChildByName("btn_move_next")
	
	if var_146_0 then
		var_146_1:addTouchEventListener(function(arg_147_0, arg_147_1, arg_147_2)
			if TutorialGuide:checkBlockFieldEvent() then
				return 
			end
			
			if arg_146_0.vars.blockInput then
				return 
			end
			
			arg_147_2 = arg_147_2 - (cc.Director:getInstance():getWinSize().width - DESIGN_WIDTH) / 2
			arg_147_2 = arg_147_2 + (BattleLayout:getFocusPosition() - DESIGN_WIDTH / 2)
			
			if arg_147_1 == 0 then
				BattleLayout:setDirection(arg_147_2 - BattleLayout:getFieldPosition(), true)
				BattleLayout:setWalking(not BattleLayout:isWalking())
				
				arg_146_0.vars.touch_tick = systick()
			elseif arg_147_1 == 1 then
				BattleLayout:setDirection(arg_147_2 - BattleLayout:getFieldPosition(), true)
			elseif arg_147_1 == 2 then
				BattleAction:Remove("MoveButton.Press")
				BattleAction:Remove("manual.move")
				
				if not USE_AUTO_WALKING then
					BattleLayout:setWalking(false)
				elseif systick() - to_n(arg_146_0.vars.touch_tick or 0) > 500 then
					BattleLayout:setWalking(false)
				end
			end
		end)
		
		for iter_146_0 = 1, 4 do
			if get_cocos_refid(arg_146_0.childs["char" .. iter_146_0]) then
				arg_146_0.childs["char" .. iter_146_0]:setVisible(false)
			end
		end
	else
		local var_146_2 = DB("level_enter", arg_146_0.vars.result.map_id, {
			"type"
		})
		
		if var_146_2 and var_146_2 ~= "hunt" and var_146_2 ~= "genie" then
			var_146_1:addTouchEventListener(function(arg_148_0, arg_148_1)
				if arg_148_1 == 2 then
					balloon_message_with_sound("battle_cant_move_next_stage")
				end
			end)
		end
	end
	
	UIAction:Add(FADE_IN(200), arg_146_0.childs.n_buttons, "block")
	UIAction:Add(FADE_OUT(200), arg_146_0.childs.dim, "block")
	TutorialGuide:onResultUIDone(Battle.logic)
	arg_146_0:nextSeq()
end

function ClearResult.addRewardResult(arg_149_0)
	arg_149_0.vars.seq:addAsync(arg_149_0.removeClearEffectTop, arg_149_0)
	arg_149_0.vars.seq:addAsync(arg_149_0.removeClearEffectBottom, arg_149_0)
	
	local var_149_0 = 0
	
	for iter_149_0, iter_149_1 in pairs(arg_149_0.vars.result.tokens or {}) do
		if iter_149_1.code == "stone" then
			var_149_0 = var_149_0 + iter_149_1.count
		end
	end
	
	if var_149_0 > 0 then
		arg_149_0:addGainOrbis(var_149_0)
	end
	
	arg_149_0.vars.seq:addAsync(arg_149_0.playRewardWindow, arg_149_0)
	
	local var_149_1 = true
	
	for iter_149_2, iter_149_3 in pairs(arg_149_0.vars.result.units) do
		if DB("character", iter_149_3.db.code, "emotion_id") and (DEBUG.TEST_FAVUP or iter_149_3:getBaseGrade() > 2 and arg_149_0.vars.result.fav_levelup[iter_149_3.db.code]) then
			arg_149_0.vars.seq:addRaw(arg_149_0.addPopupFavLevelUp, arg_149_0, iter_149_3, var_149_1)
			
			var_149_1 = false
		end
	end
	
	if not BattleRepeat:isPlayingRepeatPlay() then
		arg_149_0.vars.seq:setAutoNext(false)
	end
	
	if arg_149_0.vars.result.expedition_ticket then
		arg_149_0:addCoopTicketResult(arg_149_0.vars.result.expedition_ticket)
	end
	
	if BattleRepeat:isPlayingRepeatPlay() and not Battle.logic:isTutorial() and Battle:isAutoPlayableStage() then
		BattleRepeat:set_isCounting(true)
	end
	
	arg_149_0.vars.seq:addRaw(arg_149_0.addPopupClearQuest, arg_149_0)
	
	if BattleRepeat:isPlayingRepeatPlay() and arg_149_0.vars.result.expedition_ticket then
		local function var_149_2(arg_150_0)
			UIAction:Add(SEQ(DELAY(1800), CALL(function()
				Dialog:closeAll()
			end)), arg_150_0.vars.wnd, "closeAll")
		end
		
		if BattleRepeat:get_repeatCount() > 0 then
			arg_149_0.vars.seq:addRaw(var_149_2, arg_149_0)
		end
	end
	
	arg_149_0.vars.seq:addRaw(arg_149_0.addNewBooster, arg_149_0)
	arg_149_0.vars.seq:addRaw(arg_149_0.friendRequest, arg_149_0)
	
	if arg_149_0:_is_tutorial_exist() then
		arg_149_0.vars.seq:addRaw(arg_149_0.play_reward_wnd_tutorial, arg_149_0)
	end
	
	if BattleRepeat:isPlayingRepeatPlay() then
		arg_149_0.vars.seq:addRaw(arg_149_0.repeatBattle, arg_149_0)
		
		if arg_149_0.vars.result.apper_missions and #arg_149_0.vars.result.apper_missions > 0 then
			BattleRepeat:set_urgentMissionNotiCount(table.count(arg_149_0.vars.result.apper_missions))
		end
		
		BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
	end
	
	if not BattleRepeat:isPlayingRepeatPlay() then
		BattleTopBar:open_RepeateControlAgain()
	end
	
	arg_149_0:initResultSellMode()
	arg_149_0.vars.seq:add(arg_149_0.charRewardWindow, arg_149_0)
	arg_149_0.vars.seq:add(arg_149_0.unlockSystemSubtory, arg_149_0)
	arg_149_0.vars.seq:add(arg_149_0.addCredits, arg_149_0)
	arg_149_0.vars.seq:add(arg_149_0.addHeroGet, arg_149_0)
	arg_149_0.vars.seq:add(arg_149_0.unlockSeq, arg_149_0)
	arg_149_0.vars.seq:add(arg_149_0.addMenuResult, arg_149_0)
	arg_149_0.vars.seq:addRaw(arg_149_0.addAppearUrgentMission, arg_149_0)
end

function ClearResult._is_tutorial_exist(arg_152_0)
	if DEBUG.SKIP_TUTO then
		return false
	end
	
	if not TutorialGuide:isClearedTutorial("system_142") and arg_152_0:is_penguin_tutorial_exist() then
		return true
	end
end

function ClearResult.play_reward_wnd_tutorial(arg_153_0)
	if not arg_153_0.vars or not get_cocos_refid(arg_153_0.vars.wnd) or DEBUG.SKIP_TUTO then
		return 
	end
	
	if not TutorialGuide:isClearedTutorial("system_142") and arg_153_0:is_penguin_tutorial_exist() then
		TutorialGuide:startGuide("system_142", true)
		Dialog:closeAll()
		
		return 
	end
end

function ClearResult.is_penguin_tutorial_exist(arg_154_0)
	if not arg_154_0.vars or not arg_154_0.vars.result then
		return 
	end
	
	return arg_154_0.vars.result.penguin_mileage and not table.empty(arg_154_0.vars.result.penguin_mileage)
end

function ClearResult.repeatBattle(arg_155_0)
	arg_155_0.vars.seq:setAutoNext(false)
	Dialog:close("result_friend_request")
	BattleRepeat:repeat_battle()
end

function ClearResult.unlockSystemSubtory(arg_156_0)
	arg_156_0:addPopupUnlockSystemSubstory()
end

function ClearResult._makeLastQuestIdsCache(arg_157_0)
	if not arg_157_0.cached then
		arg_157_0.cached = {}
	end
	
	if not arg_157_0.cached.last_quest_ids then
		arg_157_0.cached.last_quest_ids = {}
		
		for iter_157_0 = 1, 9999 do
			local var_157_0, var_157_1 = DBN("quest_episode", iter_157_0, {
				"last_chapter",
				"last_quest"
			})
			
			if not var_157_0 then
				break
			end
			
			table.push(arg_157_0.cached.last_quest_ids, var_157_1)
		end
	end
end

function ClearResult._isLastQuestIdOfEp(arg_158_0, arg_158_1)
	arg_158_0:_makeLastQuestIdsCache()
	
	if not table.empty(arg_158_0.cached.last_quest_ids) then
		return table.isInclude(arg_158_0.cached.last_quest_ids, arg_158_1)
	end
	
	return false
end

function ClearResult.addCredits(arg_159_0)
	local var_159_0 = Battle.logic:getQuestMissionId()
	
	if arg_159_0:_isLastQuestIdOfEp(var_159_0) then
		SceneManager:nextScene("credits", {
			quest_id = var_159_0
		})
		
		return 
	end
	
	arg_159_0:nextSeq()
end

function ClearResult.friendRequest(arg_160_0)
	local var_160_0 = BattleReadyFriends:getLastUseFriend(arg_160_0.vars.result.map_id)
	local var_160_1 = DB("acc_rank", tostring(Account:getLevel()), "max_friend") or 20
	local var_160_2 = arg_160_0:_is_tutorial_exist()
	
	if not var_160_0 or var_160_0.friend_data or Account:getFriendCount() == var_160_1 or Account:getFriendSentCount() == 30 then
		if var_160_2 then
			arg_160_0:nextSeq()
		end
		
		return 
	end
	
	local var_160_3 = Dialog:open("wnd/result_friend_request", arg_160_0)
	
	BackButtonManager:push({
		check_id = "result_friend_request",
		back_func = function()
			Dialog:close("result_friend_request")
			BackButtonManager:pop({
				check_id = "result_friend_request"
			})
		end
	})
	
	local var_160_4 = var_160_3:getChildByName("n_friend")
	
	if_set(var_160_4, "txt_friend_name", var_160_0.account_data.name)
	UIUtil:setLevel(var_160_4:getChildByName("n_friend_lv"), var_160_0.account_data.level, MAX_ACCOUNT_LEVEL, 2)
	
	if var_160_0.account_data.level <= 9 then
		local var_160_5 = var_160_3:getChildByName("n_lv_num")
		
		var_160_5:setPositionX(var_160_5:getPositionX() - 18)
	end
	
	if_set(var_160_4, "last_time", T("time_before", {
		time = sec_to_string(os.time() - var_160_0.account_data.login_tm)
	}))
	
	local var_160_6 = var_160_0.account_data.intro_msg or T("friend.default_intro_msg")
	local var_160_7 = var_160_4:getChildByName("talk_small_bg")
	
	if var_160_6 then
		if utf8len(var_160_6) > 45 then
			var_160_6 = utf8sub(var_160_6, 1, 45) .. "..."
		end
		
		if_set(var_160_7, "disc", var_160_6)
		
		local var_160_8 = var_160_7:getChildByName("disc")
		local var_160_9 = var_160_7:getContentSize()
		
		var_160_7:setContentSize(var_160_8:getContentSize().width * var_160_8:getScaleX() + 35, var_160_9.height)
	else
		var_160_7:setVisible(false)
	end
	
	UIUtil:getUserIcon(var_160_0.unit, {
		parent = var_160_4:getChildByName("n_friend_face"),
		border_code = var_160_0.account_data.border_code
	})
	
	local function var_160_10()
		BattleReadyFriends:clearLastUseFriend(arg_160_0.vars.result.map_id)
		BackButtonManager:pop({
			check_id = "ClearResult",
			dlg = var_160_3
		})
		var_160_3:removeFromParent()
		
		var_160_3 = nil
	end
	
	Dialog:msgBox(nil, {
		arg = "dont_close",
		yesno = true,
		dlg = var_160_3,
		handler = function(arg_163_0, arg_163_1)
			if arg_163_1 == "btn_yes" then
				query("friend_request", {
					friend_id = var_160_0.account_data.id
				})
				
				AccountData.friend_sent_count = AccountData.friend_sent_count + 1
				
				var_160_10()
			elseif arg_163_1 == "btn_user_info" then
				Friend:preview(var_160_0.account_data.id, var_160_3, {
					no_request = true
				})
			end
		end,
		cancel_handler = function(arg_164_0, arg_164_1)
			var_160_10()
		end
	})
	
	if var_160_2 then
		arg_160_0:nextSeq()
	end
end

function ClearResult.isForcePopScene(arg_165_0)
	local var_165_0, var_165_1 = DB("level_enter", arg_165_0.vars.result.map_id, {
		"type",
		"force_popscene"
	})
	
	if var_165_0 == "dungeon" then
		return true
	end
	
	if var_165_0 == "dungeon_quest" then
		return true
	end
	
	if var_165_1 then
		return true
	end
	
	return false
end

function ClearResult.isWorldMapEffect(arg_166_0)
	if not arg_166_0.vars then
		return nil
	end
	
	return arg_166_0.vars.next_worldmap_eff
end

function ClearResult.clearVars(arg_167_0)
	if not arg_167_0.vars then
		return 
	end
	
	arg_167_0.vars.next_worldmap_eff = nil
end

function ClearResult.setFavLoveUI(arg_168_0, arg_168_1, arg_168_2)
	local var_168_0 = Account:getUnit(arg_168_2.inst.uid)
	
	UIUtil:setFavoriteDetail(arg_168_1, var_168_0)
	
	local var_168_1 = arg_168_0.vars.result.units_favexp[var_168_0.db.code]
	
	if not var_168_1 then
		return 
	end
	
	local var_168_2 = {}
	
	for iter_168_0 = 1, 2 do
		local var_168_3 = WidgetUtils:createCircleProgress("img/hero_love_progress_large.png")
		
		var_168_3:setScale(pivot_gauge:getScale())
		var_168_3:setOpacity(pivot_gauge:getOpacity())
		var_168_3:setPosition(pivot_gauge:getPosition())
		var_168_3:setAnchorPoint(pivot_gauge:getAnchorPoint())
		var_168_3:setReverseDirection(false)
		
		local var_168_4 = iter_168_0 == 1 and var_168_1.curr_exp or var_168_1.prev_exp
		
		var_168_3:setPercentage(var_168_4 * 100)
		var_168_3:setLocalZOrder(pivot_gauge:getLocalZOrder() + 1)
		var_168_3:setName("@progress_gauge" .. iter_168_0)
		pivot_gauge:getParent():addChild(var_168_3)
		var_168_3:setVisible(false)
		
		var_168_2[iter_168_0] = var_168_3
	end
	
	var_168_2[2]:setColor(cc.c3b(255, 120, 0))
	
	arg_168_1.fav_prog = var_168_2
	
	if_set(arg_168_1, "t_lv", var_168_1.prev_lv)
	
	local var_168_5 = var_168_1.prev_lv > 7 and 3 or var_168_1.prev_lv > 4 and 2 or 1
	local var_168_6 = string.format("img/hero_love_icon_%d.png", var_168_5)
	
	if_set_sprite(arg_168_1, "hero_love_icon", var_168_6)
end

function ClearResult.getHeroWindow(arg_169_0, arg_169_1, arg_169_2, arg_169_3)
	local var_169_0 = Account:getUnit(arg_169_2.inst.uid)
	
	if not var_169_0 then
		Log.e("ClearResult.getHeroWindow", string.format("unit_obj is invalid, unit uid: %d", arg_169_2 and arg_169_2.inst and arg_169_2.inst.uid))
		
		return arg_169_1
	end
	
	local var_169_1 = arg_169_3.addExp and arg_169_3.addExp > 0
	
	if_set_visible(arg_169_1, "exp", var_169_1)
	if_set_visible(arg_169_1, "exp_none", not var_169_1)
	
	local var_169_2 = arg_169_1:getChildByName(var_169_1 and "exp" or "exp_none")
	
	if get_cocos_refid(var_169_2) then
		UIUtil:setUnitAllInfo(var_169_2, var_169_0, {
			exp_percent = true
		})
		UIUtil:setLevelDetail(var_169_2, var_169_0:getLv(), math.min(60, arg_169_2:getMaxLevel()))
		
		local var_169_3 = var_169_2:findChildByName("txt_name")
		
		if get_cocos_refid(var_169_3) then
			if_set_scale_fit_width_long_word(var_169_3, nil, get_word_wrapped_name(var_169_3, var_169_3:getString()), 150)
			
			if var_169_3:getStringNumLines() > 3 then
				UIUserData:call(var_169_3, "MULTI_SCALE(3, 20)")
			end
		end
	end
	
	if var_169_2 and var_169_1 then
		local var_169_4, var_169_5 = var_169_0:getExpString()
		
		print(arg_169_3.prev_ratio or 0, var_169_5)
		EXPBar:Set(var_169_2, arg_169_3.prev_ratio or 0, var_169_5, arg_169_3.addExp, arg_169_3.isLvUp, true, 14, -20, arg_169_3.distExp, true)
	end
	
	if not var_169_0.db.face_id then
		Log.e("ClearResult.getHeroWindow", "nil_unit_obj.db.face_id." .. var_169_0.db.code)
	end
	
	if_set_sprite(arg_169_1, "face", "face/" .. var_169_0.db.face_id .. "_s.png")
	
	local var_169_6 = arg_169_1:getChildByName("progress_bg")
	
	if not get_cocos_refid(var_169_6) then
		return arg_169_1
	end
	
	UIUtil:setFavoriteDetail(arg_169_1, var_169_0)
	
	local var_169_7 = arg_169_0.vars.result.units_favexp[var_169_0.db.code]
	
	if not var_169_7 then
		return arg_169_1
	end
	
	local var_169_8 = {}
	
	for iter_169_0 = 1, 2 do
		local var_169_9 = WidgetUtils:createCircleProgress("img/hero_love_progress_large.png")
		
		var_169_9:setScale(var_169_6:getScale())
		var_169_9:setOpacity(var_169_6:getOpacity())
		var_169_9:setPosition(var_169_6:getPosition())
		var_169_9:setAnchorPoint(var_169_6:getAnchorPoint())
		var_169_9:setReverseDirection(false)
		
		local var_169_10 = iter_169_0 == 1 and var_169_7.curr_exp or var_169_7.prev_exp
		
		var_169_9:setPercentage(var_169_10 * 100)
		var_169_9:setLocalZOrder(var_169_6:getLocalZOrder() + 1)
		var_169_9:setName("@progress_gauge" .. iter_169_0)
		var_169_6:getParent():addChild(var_169_9)
		var_169_9:setVisible(false)
		
		var_169_8[iter_169_0] = var_169_9
	end
	
	var_169_8[2]:setColor(cc.c3b(255, 120, 0))
	
	arg_169_1.fav_prog = var_169_8
	
	if_set(arg_169_1, "t_lv", var_169_7.prev_lv)
	
	local var_169_11 = var_169_7.prev_lv > 7 and 3 or var_169_7.prev_lv > 4 and 2 or 1
	local var_169_12 = string.format("img/hero_love_icon_%d.png", var_169_11)
	
	if_set_sprite(arg_169_1, "hero_love_icon", var_169_12)
	
	return arg_169_1
end

function ClearResult.getNpcWindow(arg_170_0, arg_170_1, arg_170_2)
	local var_170_0 = arg_170_1:getChildByName("exp_none")
	
	if_set_visible(arg_170_1, "exp_none", true)
	if_set_visible(arg_170_1, "exp", false)
	UIUtil:setUnitAllInfo(var_170_0, arg_170_2, {
		exp_percent = true
	})
	UIUtil:setLevelDetail(var_170_0, arg_170_2:getLv(), math.min(60, arg_170_2:getMaxLevel()))
	if_set_scale_fit_width(var_170_0, "txt_name", 120)
	
	if not arg_170_2.db.face_id then
		Log.e("ClearResult.getHeroWindow", "nil_unit.db.face_id." .. arg_170_2.db.code)
	end
	
	if_set_sprite(arg_170_1, "face", "face/" .. arg_170_2.db.face_id .. "_s.png")
	if_set_visible(arg_170_1, "n_love", false)
	if_set_visible(arg_170_1, "intimacy", false)
	
	return arg_170_1
end

function ClearResult.getCharacterWindow(arg_171_0, arg_171_1, arg_171_2, arg_171_3)
	local var_171_0 = arg_171_3 or {}
	
	arg_171_2 = arg_171_2 or {}
	
	local var_171_1 = arg_171_2.isPVP and "result_character2" or "result_character"
	local var_171_2 = var_171_0.wnd or load_dlg(var_171_1, true, "wnd")
	
	if not var_171_0.ignore_pos then
		var_171_2:setPosition(0, 0)
		var_171_2:setAnchorPoint(0, 0)
	end
	
	if_set_visible(var_171_2, "n_conn", false)
	
	if arg_171_1:isNPC() then
		return arg_171_0:getNpcWindow(var_171_2, arg_171_1)
	end
	
	return arg_171_0:getHeroWindow(var_171_2, arg_171_1, arg_171_2)
end

function ClearResult.playHellRewardWindow(arg_172_0, arg_172_1)
	if_set(arg_172_0.childs.n_hell, "txt_floor", T(DB("level_enter", arg_172_0.vars.result.map_id, "name")))
	
	local var_172_0
	
	if DungeonHell:isAbyssHardMap(arg_172_0.vars.result.map_id) then
		var_172_0 = arg_172_0:getRewardTableForAbyssChallenge()
	else
		var_172_0 = arg_172_0:getRewardTable()
	end
	
	local var_172_1 = 0
	
	for iter_172_0, iter_172_1 in pairs(var_172_0) do
		if iter_172_0 > 2 then
			break
		end
		
		if iter_172_1.code ~= "to_abysskey" then
			var_172_1 = var_172_1 + 1
			
			local var_172_2 = {
				parent = arg_172_0.childs.n_hell,
				target = "n_item" .. var_172_1,
				set_fx = iter_172_1.set_fx,
				equip_stat = iter_172_1.equip_stat,
				g = iter_172_1.g,
				set_drop = iter_172_1.set_drop,
				show_small_count = iter_172_1.show_small_count,
				add_bonus = iter_172_1.add_bonus,
				add_pet_bonus = iter_172_1.add_pet_bonus,
				reward_info = {
					account_skill_bonus = iter_172_1.add_bonus and iter_172_1.add_bonus > 0 and true,
					pet_skill_bonus = iter_172_1.add_pet_bonus and iter_172_1.add_pet_bonus > 0 and true
				}
			}
			local var_172_3 = UIUtil:getRewardIcon(iter_172_1.count, iter_172_1.code, var_172_2)
		end
	end
	
	if var_172_1 == 1 then
		local var_172_4 = arg_172_0.childs.n_hell:getChildByName("n_items")
		
		childs(arg_172_0.childs.n_hell)
		var_172_4:setPositionX(0)
	end
	
	local var_172_5 = string.sub(arg_172_0.vars.result.map_id, 1, -4)
	local var_172_6 = to_n(string.sub(arg_172_0.vars.result.map_id, -3, -1))
	local var_172_7
	
	if DungeonHell:isAbyssHardMap(arg_172_0.vars.result.map_id) then
		var_172_7 = var_172_6 >= DungeonHell:getMaxChallengeFloor()
	else
		var_172_7 = var_172_6 + 1 > DungeonHell:getMaxFloor()
	end
	
	if_set_visible(arg_172_0.childs.n_hell, "txt_abyss", true)
	
	local var_172_8 = DB("level_enter", arg_172_0.vars.result.map_id, "local_num")
	
	if_set(arg_172_0.childs.n_hell, "txt_abyss", T(DB("level_world_3_chapter", var_172_8, "name")))
	
	if arg_172_1 then
		if_set_visible(arg_172_0.childs.n_hell, "n_btns_finished", false)
		if_set_visible(arg_172_0.childs.n_hell, "n_btns_normal", true)
		if_set_visible(arg_172_0.childs.n_hell, "btn_hell_next", false)
		if_set_visible(arg_172_0.childs.n_hell, "n_bars", false)
		if_set_visible(arg_172_0.childs.n_hell, "txt_desc", false)
	else
		if_set_visible(arg_172_0.childs.n_hell, "txt_desc", true)
		if_set_visible(arg_172_0.childs.n_hell, "n_bars", true)
		if_set_visible(arg_172_0.childs.n_hell, "btn_hell_next", not var_172_7)
		if_set_visible(arg_172_0.childs.n_hell, "n_btns_normal", not var_172_7)
		if_set_visible(arg_172_0.childs.n_hell, "n_btns_finished", var_172_7 == true)
		
		local var_172_9 = (DungeonHell:isAbyssHardMap(arg_172_0.vars.result.map_id) and "abysshard" or "abyss") .. string.format("%03d", var_172_6 + 1)
		
		if not var_172_7 then
			local var_172_10 = arg_172_0.vars.wnd:getChildByName("btn_hell_next")
			
			if get_cocos_refid(var_172_10) then
				UIUtil:setButtonEnterInfo(var_172_10, arg_172_0.vars.result.map_id, {
					next_floor = var_172_9
				})
			end
		end
	end
	
	UIAction:Add(SEQ(FADE_IN(200), CALL(function()
		arg_172_0:addResultFavorite(arg_172_0.childs.n_hell)
	end)), arg_172_0.childs.n_hell, "block")
end

function ClearResult.playAutomatonRewardWindow(arg_174_0)
	if_set(arg_174_0.childs.n_tower, "txt_floor", T(DB("level_enter", arg_174_0.vars.result.map_id, "name")))
	
	local var_174_0 = arg_174_0:getRewardTable()
	local var_174_1 = 0
	
	for iter_174_0, iter_174_1 in pairs(var_174_0) do
		if iter_174_0 > 2 then
			break
		end
		
		var_174_1 = var_174_1 + 1
		
		local var_174_2 = UIUtil:getRewardIcon(iter_174_1.count, iter_174_1.code, {
			parent = arg_174_0.childs.n_tower,
			target = "n_item" .. var_174_1,
			set_fx = iter_174_1.set_fx,
			equip_stat = iter_174_1.equip_stat,
			g = iter_174_1.g,
			set_drop = iter_174_1.set_drop,
			show_small_count = iter_174_1.show_small_count,
			add_bonus = iter_174_1.add_bonus,
			add_pet_bonus = iter_174_1.add_pet_bonus
		})
	end
	
	if var_174_1 == 1 then
		arg_174_0.childs.n_tower:getChildByName("n_items"):setPositionX(0)
	end
	
	local var_174_3 = string.sub(arg_174_0.vars.result.map_id, 1, -4)
	local var_174_4 = to_n(string.sub(arg_174_0.vars.result.map_id, -3, -1))
	local var_174_5 = string.sub(arg_174_0.vars.result.map_id, -3, -1)
	local var_174_6 = string.format("%03d", to_n(var_174_5) + 1)
	local var_174_7 = string.gsub(arg_174_0.vars.result.map_id, var_174_5, var_174_6)
	local var_174_8 = DB("level_automaton", var_174_7, "id") == nil
	
	if_set_visible(arg_174_0.childs.n_tower, "btn_tower_back", not var_174_8)
	if_set_visible(arg_174_0.childs.n_tower, "btn_tower_next", not var_174_8)
	if_set_visible(arg_174_0.childs.n_tower, "btn_conquest", var_174_8 == true)
	
	local var_174_9
	
	var_174_9 = (Account:getAutomatonClearedFloor() or 1) >= to_n(var_174_5) and var_174_1 == 0
	
	if_set_visible(arg_174_0.childs.n_tower, "n_none", var_174_1 == 0)
	UIAction:Add(FADE_IN(200), arg_174_0.childs.n_tower, "block")
	
	local var_174_10 = false
	
	if not var_174_8 then
		local var_174_11 = arg_174_0.vars.wnd:getChildByName("btn_tower_next")
		
		if get_cocos_refid(var_174_11) then
			UIUtil:setButtonEnterInfo(var_174_11, var_174_7, {
				automaton_free_enter = arg_174_0.vars.result.is_automaton_cleared
			})
			
			var_174_10 = true
		end
	end
	
	local var_174_12 = false
	
	for iter_174_2, iter_174_3 in pairs(var_174_0) do
		if DB("item_material", iter_174_3.code, "ma_type") == "special" then
			var_174_12 = true
		end
	end
	
	arg_174_0:showDeviceSelect({
		floor = var_174_4,
		selectable_buff_list = arg_174_0.vars.result.rnd_three_device,
		show_reward_tutorial = var_174_12,
		show_result_free_tip = var_174_10
	})
	
	if arg_174_0.vars.result.rnd_three_device == nil then
		arg_174_0:playAutomatonResultFavorite()
	end
end

function ClearResult.playAutomatonResultFavorite(arg_175_0)
	if not arg_175_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_175_0.vars.wnd) then
		return 
	end
	
	if not arg_175_0.vars.result then
		return 
	end
	
	if not get_cocos_refid(arg_175_0.childs.n_tower) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_IN(200), CALL(function()
		arg_175_0:addResultFavorite(arg_175_0.childs.n_tower)
	end)), arg_175_0.childs.n_tower, "block")
	arg_175_0:addPvPClanWarResultFavPopUp()
end

function ClearResult.showDeviceSelect(arg_177_0, arg_177_1)
	local var_177_0 = arg_177_1 or {}
	local var_177_1 = Account:getAutomatonLevel()
	
	Account:setAutomatonClearedFloor(tonumber(var_177_0.floor))
	DeviceSelector:showDeviceSelector(arg_177_0.vars.wnd, {
		device_infos = var_177_0.selectable_buff_list,
		floor = tonumber(var_177_0.floor),
		floor_level = var_177_1,
		show_reward_tutorial = var_177_0.show_reward_tutorial,
		show_result_free_tip = var_177_0.show_result_free_tip
	})
end

function ClearResult.playTrialRewardWindow(arg_178_0, arg_178_1)
	if arg_178_1 == nil then
		Log.e("결과값없음")
	end
	
	arg_178_0.vars.trial_wnd = arg_178_0.vars.wnd:getChildByName("n_trial")
	arg_178_0.vars.practice_mode = arg_178_1.practice_mode
	arg_178_0.vars.trial_cut_off = arg_178_1.trial_cut_off
	arg_178_0.vars.delay_time = 1500
	arg_178_0.vars.show_time = 200
	arg_178_0.vars.add_time = 800
	
	if_set_visible(arg_178_0.vars.wnd, "n_trial", true)
	
	arg_178_0.vars.RIGHT = arg_178_0.vars.trial_wnd:getChildByName("RIGHT")
	arg_178_0.vars.txt_title = arg_178_0.vars.trial_wnd:getChildByName("txt_title")
	arg_178_0.vars.txt_point = arg_178_0.vars.trial_wnd:getChildByName("txt_point")
	arg_178_0.vars.txt_bonus1 = arg_178_0.vars.trial_wnd:getChildByName("txt_bonus1")
	arg_178_0.vars.txt_bonus2 = arg_178_0.vars.trial_wnd:getChildByName("txt_bonus2")
	arg_178_0.vars.n_score_font = arg_178_0.vars.trial_wnd:getChildByName("n_score_font")
	arg_178_0.vars.rank_raid = arg_178_0.vars.trial_wnd:getChildByName("rank_raid")
	arg_178_0.vars.txt_title2 = arg_178_0.vars.trial_wnd:getChildByName("txt_title2")
	arg_178_0.vars.bar1 = arg_178_0.vars.trial_wnd:getChildByName("bar1")
	
	arg_178_0.vars.txt_point:setColor(tocolor("#888888"))
	arg_178_0.vars.txt_bonus1:setColor(tocolor("#ff7800"))
	arg_178_0.vars.txt_bonus2:setColor(tocolor("#ff7800"))
	
	if arg_178_1.clear then
		arg_178_0.vars.is_clear = true
		
		local var_178_0 = arg_178_1.total - arg_178_1.clear
		local var_178_1 = 10
		
		if arg_178_1.pet and arg_178_1.pet > 0 then
			arg_178_0.vars.petBonus = true
			var_178_0 = var_178_0 - arg_178_1.pet
			
			if_set(arg_178_0.vars.txt_bonus2, nil, T("ui_trial_hall_pet_point", {
				point = comma_value(arg_178_1.pet)
			}))
			
			var_178_1 = 0
		end
		
		if var_178_0 > 0 then
			var_178_1 = 0
		end
		
		if_set(arg_178_0.vars.txt_point, nil, T("ui_trial_hall_result_point", {
			point = comma_value(var_178_0)
		}))
		if_set(arg_178_0.vars.txt_bonus1, nil, T("ui_trial_hall_clear_point", {
			point = comma_value(arg_178_1.clear)
		}))
		arg_178_0.vars.txt_point:setPositionY(arg_178_0.vars.txt_point:getPositionY() - var_178_1)
		arg_178_0.vars.txt_bonus1:setPositionY(arg_178_0.vars.txt_bonus1:getPositionY() - var_178_1)
	else
		arg_178_0.vars.is_clear = false
		
		local var_178_2 = arg_178_1.total
		local var_178_3 = 20
		
		if arg_178_1.pet and arg_178_1.pet > 0 then
			arg_178_0.vars.petBonus = true
			var_178_3 = 10
			var_178_2 = var_178_2 - arg_178_1.pet
			
			if_set(arg_178_0.vars.txt_bonus1, nil, T("ui_trial_hall_pet_point", {
				point = comma_value(arg_178_1.pet)
			}))
			arg_178_0.vars.txt_bonus1:setPositionY(arg_178_0.vars.txt_bonus1:getPositionY() - var_178_3)
		end
		
		if_set(arg_178_0.vars.txt_point, nil, T("ui_trial_hall_result_point", {
			point = comma_value(var_178_2)
		}))
		arg_178_0.vars.txt_point:setPositionY(arg_178_0.vars.txt_point:getPositionY() - var_178_3)
	end
	
	arg_178_0.vars.trial_reward_count = 0
	
	if_set_visible(arg_178_0.vars.trial_wnd, "n_practice_info", arg_178_0.vars.practice_mode)
	
	local var_178_9
	
	if arg_178_0.vars.practice_mode then
		if_set_visible(arg_178_0.vars.trial_wnd, "n_cut_off_info", false)
	else
		if_set_visible(arg_178_0.vars.trial_wnd, "n_cut_off_info", arg_178_1.trial_cut_off)
		
		if not arg_178_1.trial_cut_off then
			local var_178_4 = {}
			local var_178_5 = arg_178_1.trial_rank_rewards
			local var_178_6 = arg_178_1.trial_bonus_rewards
			
			if var_178_5 then
				for iter_178_0, iter_178_1 in pairs(var_178_5) do
					if var_178_4[iter_178_0] then
						var_178_4[iter_178_0] = var_178_4[iter_178_0] + iter_178_1
					else
						var_178_4[iter_178_0] = iter_178_1
					end
				end
			end
			
			if var_178_6 then
				for iter_178_2, iter_178_3 in pairs(var_178_6) do
					for iter_178_4, iter_178_5 in pairs(iter_178_3) do
						local var_178_7 = iter_178_5.count or iter_178_5.c
						local var_178_8 = iter_178_5.code
						
						if var_178_4[var_178_8] then
							var_178_4[var_178_8] = var_178_4[var_178_8] + var_178_7
						else
							var_178_4[var_178_8] = var_178_7
						end
					end
				end
			end
			
			arg_178_0.vars.trial_reward_count = table.count(var_178_4)
			var_178_9 = 1
			
			for iter_178_6, iter_178_7 in pairs(var_178_4) do
				local var_178_10 = arg_178_0.vars.trial_wnd:getChildByName("n_item" .. var_178_9 .. "/" .. arg_178_0.vars.trial_reward_count)
				
				if not get_cocos_refid(var_178_10) then
					break
				end
				
				UIUtil:getRewardIcon(iter_178_7, iter_178_6, {
					show_small_count = true,
					parent = var_178_10
				})
				var_178_10:setVisible(false)
				
				var_178_9 = var_178_9 + 1
			end
		end
	end
	
	if_set_visible(arg_178_0.vars.trial_wnd, "n_reward_node", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "RIGHT", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "txt_title", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "txt_point", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "txt_bonus1", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "txt_bonus2", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "n_score_font", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "rank_raid", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "txt_title2", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "bar1", false)
	if_set_visible(arg_178_0.vars.trial_wnd, "score_rank", false)
	UIAction:Add(SEQ(APPEAR(600)), arg_178_0.vars.trial_wnd:getChildByName("score_rank"), "block")
	EffectManager:Play({
		fn = "ui_new_training_result.cfx",
		layer = arg_178_0.vars.trial_wnd,
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = DESIGN_HEIGHT / 2
	}):setLocalZOrder(-999)
	UIAction:Add(FADE_IN(arg_178_0.vars.show_time), arg_178_0.vars.trial_wnd, "block")
	UIAction:Add(SEQ(DELAY(arg_178_0.vars.delay_time), FADE_IN(arg_178_0.vars.show_time)), arg_178_0.vars.txt_title, "block")
	UIAction:Add(SEQ(DELAY(arg_178_0.vars.delay_time), SLIDE_IN(arg_178_0.vars.show_time), CALL(function()
		SoundEngine:play("event:/ui/trial_hall_clear_1")
	end)), arg_178_0.vars.txt_point, "earning_point")
	arg_178_0:addDelay()
	
	if arg_178_0.vars.is_clear then
		UIAction:Add(SEQ(DELAY(arg_178_0.vars.delay_time), SLIDE_IN(arg_178_0.vars.show_time)), arg_178_0.vars.txt_bonus1, "block")
		arg_178_0:addDelay()
		
		if arg_178_0.vars.petBonus then
			UIAction:Add(SEQ(DELAY(arg_178_0.vars.delay_time), SLIDE_IN(arg_178_0.vars.show_time)), arg_178_0.vars.txt_bonus2, "block")
			arg_178_0:addDelay()
		end
	end
	
	UIAction:Add(SEQ(DELAY(arg_178_0.vars.delay_time), FADE_IN(arg_178_0.vars.show_time)), arg_178_0.vars.n_score_font, "score_font")
	arg_178_0:addDelay()
	
	local var_178_11 = comma_value(0)
	local var_178_12 = cc.Label:createWithBMFont("font/score.fnt", var_178_11)
	
	var_178_12:setName("score")
	var_178_12:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
	var_178_12:setAnchorPoint(0, 0)
	arg_178_0.vars.trial_wnd:getChildByName("n_score_font"):addChild(var_178_12)
	
	arg_178_0.vars.score_lbl = var_178_12
	
	arg_178_0.vars.score_lbl:setString(comma_value(0))
	
	arg_178_0.vars.result_score = arg_178_1.total
	arg_178_0.vars.increase_time = 5000
	
	for iter_178_8 = 12, 1, -1 do
		local var_178_13 = "trialhall_rank_" .. iter_178_8
		local var_178_14, var_178_15 = DB("challenge_rank", var_178_13, {
			"rank",
			"rank_point"
		})
		
		if var_178_14 and var_178_15 <= arg_178_0.vars.result_score then
			local var_178_16 = string.replace(var_178_14, "+", "_plus")
			
			SpriteCache:resetSprite(arg_178_0.vars.trial_wnd:getChildByName("rank_raid"), "img/rank_raid_" .. var_178_16 .. ".png")
			
			break
		end
	end
	
	local var_178_17 = false
	
	UIAction:Add(SEQ(INC_NUMBER(arg_178_0.vars.increase_time, arg_178_0.vars.result_score), CALL(function()
		var_178_17 = true
	end)), arg_178_0.vars.score_lbl, "block")
	UIAction:Add(COND_LOOP(DELAY(0), function()
		if not UIAction:Find("score_font") then
			SoundEngine:play("event:/ui/trial_hall_clear_2")
			SoundEngine:play("event:/ui/trial_hall_clear_2")
		end
		
		if var_178_17 then
			ClearResult:show_trialReward()
			
			return true
		end
	end), arg_178_0, "slotMachineSound")
end

function ClearResult.addDelay(arg_182_0, arg_182_1)
	if arg_182_1 then
		arg_182_0.vars.delay_time = arg_182_0.vars.delay_time + arg_182_0.vars.add_time + arg_182_1
	else
		arg_182_0.vars.delay_time = arg_182_0.vars.delay_time + arg_182_0.vars.add_time
	end
end

function ClearResult.show_trialReward(arg_183_0)
	UIAction:Add(SEQ(APPEAR(arg_183_0.vars.show_time), CALL(function()
		SoundEngine:play("event:/ui/trial_hall_clear_3")
	end)), arg_183_0.vars.rank_raid, "block")
	
	if not arg_183_0.vars.trial_cut_off then
		local var_183_0 = arg_183_0.vars.rank_raid:getContentSize()
		
		EffectManager:Play({
			z = 1,
			fn = "ui_worldboss_result_grade_eff.cfx",
			layer = arg_183_0.vars.rank_raid,
			x = var_183_0.width / 2,
			y = var_183_0.height / 2
		})
	end
	
	arg_183_0.vars.delay_time = 500
	arg_183_0.vars.show_time = 200
	arg_183_0.vars.add_time = 800
	
	arg_183_0:addDelay()
	UIAction:Add(SEQ(DELAY(arg_183_0.vars.delay_time), FADE_IN(arg_183_0.vars.show_time)), arg_183_0.vars.txt_title2, "block")
	UIAction:Add(SEQ(DELAY(arg_183_0.vars.delay_time), FADE_IN(arg_183_0.vars.show_time)), arg_183_0.vars.bar1, "block")
	arg_183_0:addDelay()
	arg_183_0:setTrial_resultItems()
	UIAction:Add(SEQ(DELAY(arg_183_0.vars.delay_time), FADE_IN(arg_183_0.vars.show_time)), arg_183_0.vars.RIGHT, "block")
end

function ClearResult.setTrial_resultItems(arg_185_0)
	if not arg_185_0.vars or not get_cocos_refid(arg_185_0.vars.trial_wnd) or arg_185_0.vars.practice_mode or arg_185_0.vars.trial_cut_off or arg_185_0.vars.trial_reward_count == 0 then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(arg_185_0.vars.delay_time), FADE_IN(arg_185_0.vars.show_time)), arg_185_0.vars.trial_wnd:getChildByName("n_reward_node"), "block")
	
	for iter_185_0 = 1, arg_185_0.vars.trial_reward_count do
		local var_185_0 = "n_item" .. iter_185_0 .. "/" .. arg_185_0.vars.trial_reward_count
		
		if_set_visible(arg_185_0.vars.trial_wnd, var_185_0, true)
	end
end

function ClearResult.getMapId(arg_186_0)
	if not arg_186_0.vars or not arg_186_0.vars.result then
		return 
	end
	
	return arg_186_0.vars.result.map_id
end

function ClearResult.getMyData(arg_187_0)
	local var_187_0 = CoopUtil:getRankList(CoopUtil:makeCoopMemberArray(Battle:getExpeditionUserList()))
	local var_187_1 = Account:getUserId()
	
	for iter_187_0 = 1, table.count(var_187_0) do
		if var_187_0[iter_187_0].uid == var_187_1 then
			return iter_187_0, var_187_0[iter_187_0]
		end
	end
	
	return nil
end

function ClearResult.playCoopTicketResult(arg_188_0, arg_188_1)
	UIAction:Add(SEQ(DELAY(1500), CALL(function()
		local var_189_0 = Dialog:msgboxGetCoopMission(arg_188_1)
		
		if BattleRepeat:isPlayingRepeatPlay() then
			if_set_opacity(var_189_0, "btn_move", 76.5)
			BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
		end
	end)), arg_188_0.vars.wnd, "block")
end

function ClearResult.playCoopResult(arg_190_0, arg_190_1)
	arg_190_0.vars.coop_wnd = arg_190_0.vars.wnd:findChildByName("n_expedition")
	
	arg_190_0.vars.coop_wnd:setVisible(true)
	
	arg_190_0.vars.show_tm = 750
	arg_190_0.vars.appear_tm = 600
	arg_190_0.vars.expedition_info = arg_190_1.expedition_info
	arg_190_0.vars.boss_id = arg_190_1.expedition_info.boss_id
	
	local var_190_0 = arg_190_0.vars.coop_wnd:findChildByName("CENTER")
	local var_190_1 = var_190_0:findChildByName("txt_my_rank")
	local var_190_2 = var_190_0:findChildByName("txt_rank")
	local var_190_3 = var_190_0:findChildByName("txt_my_participation")
	local var_190_4 = var_190_0:findChildByName("txt_participation")
	local var_190_5, var_190_6 = arg_190_0:getMyData()
	
	if_set(var_190_2, nil, tostring(var_190_5 or -1))
	
	local var_190_7 = var_190_6.count
	local var_190_8 = CoopUtil:getConfigDBValue("expedition_enter_limit")
	local var_190_9 = to_n(var_190_8) - to_n(var_190_7)
	
	if_set(var_190_4, nil, var_190_9 .. "/" .. var_190_8)
	if_set_visible(var_190_2, nil, false)
	if_set_opacity(var_190_2, nil, 0)
	EffectManager:Play({
		fn = "ui_new_training_result.cfx",
		layer = arg_190_0.vars.coop_wnd,
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = DESIGN_HEIGHT / 2
	}):setLocalZOrder(-999)
	
	local var_190_10 = var_190_0:findChildByName("n_score_font"):findChildByName("bitmap_font_label")
	
	if not arg_190_1.coop_info then
		Log.e("!NO COOP INFO!")
	end
	
	arg_190_0.vars.increase_time = 1500
	
	UIAction:Add(SEQ(INC_NUMBER(arg_190_0.vars.increase_time, var_190_6.total_score)), var_190_10, "block")
	UIAction:Add(SEQ(DELAY(arg_190_0.vars.increase_time), CALL(function()
		SoundEngine:play("event:/ui/trial_hall_clear_2")
		SoundEngine:play("event:/ui/trial_hall_clear_2")
	end)), arg_190_0, "sound")
	UIAction:Add(FADE_IN(arg_190_0.vars.show_tm), arg_190_0.vars.coop_wnd, "block")
	UIAction:Add(SEQ(DELAY(arg_190_0.vars.show_tm), APPEAR(arg_190_0.vars.appear_tm)), var_190_1, "block")
	UIAction:Add(SEQ(DELAY(arg_190_0.vars.show_tm), APPEAR(arg_190_0.vars.appear_tm)), var_190_2, "block")
	UIAction:Add(SEQ(DELAY(arg_190_0.vars.show_tm + arg_190_0.vars.appear_tm), APPEAR(arg_190_0.vars.appear_tm)), var_190_3, "block")
	UIAction:Add(SEQ(DELAY(arg_190_0.vars.show_tm + arg_190_0.vars.appear_tm), APPEAR(arg_190_0.vars.appear_tm)), var_190_4, "block")
	
	local var_190_11 = arg_190_0.vars.coop_wnd:findChildByName("n_reward_node")
	local var_190_12 = table.count(arg_190_1.tokens or {})
	local var_190_13 = 1
	local var_190_14 = arg_190_1.add_bonus_drops or {}
	
	for iter_190_0, iter_190_1 in pairs(arg_190_1.tokens or {}) do
		local var_190_15 = var_190_11:findChildByName("n_item" .. var_190_12 .. "/" .. var_190_13)
		
		if not var_190_15 then
			break
		end
		
		local var_190_16 = {
			show_small_count = true,
			parent = var_190_15
		}
		
		if var_190_14["to_" .. iter_190_1.code] then
			var_190_16.add_bonus = var_190_14["to_" .. iter_190_1.code]
		end
		
		UIUtil:getRewardIcon(iter_190_1.count, "to_" .. iter_190_1.code, var_190_16)
		if_set_visible(var_190_15, nil, false)
		UIAction:Add(SEQ(DELAY(arg_190_0.vars.increase_time), APPEAR(arg_190_0.vars.appear_tm)), var_190_15, "block")
		
		var_190_13 = var_190_13 + 1
	end
end

function ClearResult.playLotaResult(arg_192_0, arg_192_1)
	arg_192_0.vars.heritage_wnd = arg_192_0.vars.wnd:findChildByName("n_heritage")
	
	arg_192_0.vars.heritage_wnd:setVisible(true)
	
	arg_192_0.vars.show_tm = 750
	arg_192_0.vars.appear_tm = 600
	
	if not arg_192_0.vars.is_lota_with_coop then
		arg_192_0:playLotaNormalResult(arg_192_1)
	else
		arg_192_0:playLotaBossResult(arg_192_1)
	end
end

function ClearResult.playLotaNormalResult(arg_193_0, arg_193_1)
	local var_193_0 = arg_193_0.vars.wnd:findChildByName("n_heritage_normal")
	
	if_set_visible(var_193_0, nil, true)
	UIAction:Add(FADE_IN(arg_193_0.vars.show_tm), var_193_0, "block")
	
	local var_193_1 = CACHE:getEffect("stageclear_base_top")
	
	arg_193_0.childs.clear_eff_top = var_193_1
	
	var_193_1:setScale(1.5)
	var_193_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.65)
	var_193_1:setAnimation(0, "animation", false)
	var_193_1:setLocalZOrder(2000)
	var_193_1:setOpacity(0)
	SoundEngine:play("event:/effect/stageclear_base")
	arg_193_0.vars.wnd:addChild(var_193_1)
	UIAction:Add(LOG(FADE_IN(500), 100), var_193_1, "block")
	
	local var_193_2 = arg_193_0:getRewardTable()
	local var_193_3 = #var_193_2 % 2 == 1
	local var_193_4 = var_193_0:findChildByName("n_items")
	
	if var_193_3 then
		var_193_4 = var_193_0:findChildByName("n_items_odd")
		
		var_193_4:setVisible(true)
	end
	
	for iter_193_0, iter_193_1 in pairs(var_193_2) do
		local var_193_5 = {
			parent = var_193_4,
			target = "n_item" .. tostring(iter_193_0),
			set_fx = iter_193_1.set_fx,
			equip_stat = iter_193_1.equip_stat,
			g = iter_193_1.g,
			set_drop = iter_193_1.set_drop,
			show_small_count = iter_193_1.show_small_count,
			add_bonus = iter_193_1.add_bonus,
			add_pet_bonus = iter_193_1.add_pet_bonus,
			lota_arti_bonus = iter_193_1.lota_arti_bonus
		}
		
		UIUtil:getRewardIcon(iter_193_1.count, iter_193_1.code, var_193_5)
	end
end

function ClearResult.playLotaBossResult(arg_194_0, arg_194_1)
	local var_194_0 = arg_194_0.vars.wnd:findChildByName("n_heritage")
	
	if_set_visible(var_194_0, nil, true)
	EffectManager:Play({
		fn = "ui_new_ancient_result.cfx",
		layer = var_194_0,
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = DESIGN_HEIGHT / 2
	}):setLocalZOrder(-999)
	
	local var_194_1, var_194_2 = arg_194_0:getMyData()
	local var_194_3 = var_194_0:findChildByName("txt_my_rank")
	local var_194_4 = var_194_0:findChildByName("txt_rank")
	local var_194_5 = var_194_0:findChildByName("txt_my_participation")
	local var_194_6 = var_194_0:findChildByName("txt_participation")
	
	if_set(var_194_4, nil, tostring(var_194_1 or -1))
	
	local var_194_7 = var_194_2.count
	local var_194_8 = CoopUtil:getConfigDBValue("expedition_enter_limit")
	local var_194_9 = to_n(var_194_8) - to_n(var_194_7)
	
	if_set(var_194_6, nil, var_194_7)
	UIAction:Add(FADE_IN(arg_194_0.vars.show_tm), var_194_0, "block")
	if_set_visible(var_194_4, nil, false)
	if_set_opacity(var_194_4, nil, 0)
	
	local var_194_10 = var_194_0:findChildByName("n_score_font"):findChildByName("bitmap_font_label")
	
	arg_194_0.vars.increase_time = 1500
	
	UIAction:Add(SEQ(INC_NUMBER(arg_194_0.vars.increase_time, var_194_2.total_score)), var_194_10, "block")
	UIAction:Add(SEQ(DELAY(arg_194_0.vars.increase_time), CALL(function()
		SoundEngine:play("event:/ui/trial_hall_clear_2")
		SoundEngine:play("event:/ui/trial_hall_clear_2")
	end)), arg_194_0, "sound")
	UIAction:Add(FADE_IN(arg_194_0.vars.show_tm), var_194_0, "block")
	UIAction:Add(SEQ(DELAY(arg_194_0.vars.show_tm), APPEAR(arg_194_0.vars.appear_tm)), var_194_3, "block")
	UIAction:Add(SEQ(DELAY(arg_194_0.vars.show_tm), APPEAR(arg_194_0.vars.appear_tm)), var_194_4, "block")
	UIAction:Add(SEQ(DELAY(arg_194_0.vars.show_tm + arg_194_0.vars.appear_tm), APPEAR(arg_194_0.vars.appear_tm)), var_194_5, "block")
	UIAction:Add(SEQ(DELAY(arg_194_0.vars.show_tm + arg_194_0.vars.appear_tm), APPEAR(arg_194_0.vars.appear_tm)), var_194_6, "block")
	
	local var_194_11 = arg_194_0:getRewardTable()
	local var_194_12
	
	var_194_12 = #var_194_11 % 2 == 1
	
	local var_194_13 = var_194_0:findChildByName("n_item")
	
	for iter_194_0, iter_194_1 in pairs(var_194_11) do
		local var_194_14 = {
			parent = var_194_13,
			set_fx = iter_194_1.set_fx,
			equip_stat = iter_194_1.equip_stat,
			g = iter_194_1.g,
			set_drop = iter_194_1.set_drop,
			show_small_count = iter_194_1.show_small_count,
			add_bonus = iter_194_1.add_bonus,
			add_pet_bonus = iter_194_1.add_pet_bonus
		}
		
		UIUtil:getRewardIcon(iter_194_1.count, iter_194_1.code, var_194_14)
	end
end

function ClearResult.charRewardWindow(arg_196_0)
	if BattleRepeat:isPlayingRepeatPlay() then
		Dialog:close("result_friend_request")
	end
	
	BattleField:clearOverlay()
	UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), arg_196_0.childs.n_reward, "block")
	
	if arg_196_0.vars.result.first_get_units and #arg_196_0.vars.result.first_get_units > 0 and BattleRepeat:isPlayingRepeatPlay() == false then
		UIUtil:playNewUnitEffect(ClearResult.vars.wnd, function()
			arg_196_0:nextSeq()
		end, arg_196_0.vars.result.first_get_units)
	else
		arg_196_0:nextSeq()
	end
end

function ClearResult.nextSeq(arg_198_0)
	if arg_198_0.vars and arg_198_0.vars.seq then
		if not arg_198_0.vars.seq.vars then
			Log.e("ClearResult.nextSeq", "nil_seq_vars")
		elseif not arg_198_0.vars.seq.vars.queue then
			print(debug.traceback())
			Log.e("ClearResult.nextSeq", "nil_seq_vars_queue")
		end
		
		arg_198_0.vars.seq:next(true, true)
	end
end

function ClearResult.unlockSeq(arg_199_0)
	arg_199_0:nextSeq()
	print("unlockSeq!!!!!!!!!!")
	arg_199_0:addPopupUnlockSystem()
end

function ClearResult.addHeroGet(arg_200_0)
	if not arg_200_0.vars.result then
		arg_200_0:nextSeq()
		
		return 
	end
	
	local var_200_0 = arg_200_0.vars.result.map_id
	
	if Account:getMapClearCount(var_200_0) ~= 1 then
		arg_200_0:nextSeq()
		
		return 
	end
	
	if var_200_0 == "ije007" and arg_200_0.vars.result.no_eff_get_unit and arg_200_0.vars.result.no_eff_get_unit.code == "c1005" then
		play_story("c1005_get_01", {
			on_finish = function()
				HeroGet:open({
					code = "c1005",
					callback_ok_btn = function()
						arg_200_0:nextSeq()
					end
				})
				
				local var_201_0 = Account:getUnitByCode("c1005")
				
				if var_201_0 then
					local var_201_1 = Account:getTeam(1)
					local var_201_2
					
					if var_201_1 then
						for iter_201_0, iter_201_1 in pairs({
							4,
							2,
							3,
							1
						}) do
							if not var_201_1[iter_201_1] then
								var_201_2 = iter_201_1
								
								break
							end
						end
					end
					
					if var_201_2 then
						Account:addToTeam(var_201_0, 1, var_201_2)
					end
				end
			end
		})
		
		return 
	end
	
	if var_200_0 == "rai002" then
		SceneManager:nextScene("lobby")
		SceneManager:resetSceneFlow()
		
		return 
	end
	
	arg_200_0:nextSeq()
end

copy_functions(ScrollView, ClearResult)

function ClearResult.getScrollViewItem(arg_203_0, arg_203_1)
	if not arg_203_1.idx then
		Log.e("ClearResult.getScrollViewItem", "nil_data.idx")
	end
	
	local var_203_0 = {
		x = 0,
		zero = true,
		y = 0,
		scale = 0.85,
		set_fx = arg_203_1.set_fx,
		equip_stat = arg_203_1.equip_stat,
		g = arg_203_1.g,
		set_drop = arg_203_1.set_drop,
		show_small_count = arg_203_1.show_small_count,
		add_bonus = arg_203_1.add_bonus,
		add_pet_bonus = arg_203_1.add_pet_bonus,
		dlg_name = ".reward_icon" .. arg_203_1.idx
	}
	local var_203_1 = string.starts(arg_203_1.code, "e")
	local var_203_2 = string.starts(arg_203_1.code, "m") or string.starts(arg_203_1.code, "c")
	local var_203_3 = var_203_1 and DB("equip_item", arg_203_1.code, "type") == "artifact"
	
	if var_203_3 then
		var_203_0.scale = 0.66
		arg_203_1.op = arg_203_1.equip_stat
		var_203_0.equip = EQUIP:createByInfo(arg_203_1)
	end
	
	if arg_203_1.star_reward or Account:isFirstReward(arg_203_0.vars.result.map_id, arg_203_1.code) or arg_203_1.add_bonus or arg_203_1.add_pet_bonus or arg_203_1.goldbox_reward then
		var_203_0.reward_info = {}
		
		if arg_203_1.star_reward then
			var_203_0.reward_info.stage_mission = true
		end
		
		if Account:isFirstReward(arg_203_0.vars.result.map_id, arg_203_1.code) then
			var_203_0.reward_info.first_reward = true
		end
		
		if arg_203_1.add_bonus and arg_203_1.add_bonus > 0 then
			var_203_0.reward_info.account_skill_bonus = true
		end
		
		if arg_203_1.add_pet_bonus and arg_203_1.add_pet_bonus > 0 then
			var_203_0.reward_info.pet_skill_bonus = true
		end
		
		if arg_203_1.goldbox_reward then
			var_203_0.reward_info.goldbox_reward = true
		end
	end
	
	arg_203_1.count = tonumber(arg_203_1.count or "")
	
	local var_203_4 = UIUtil:getRewardIcon(arg_203_1.count, arg_203_1.code, var_203_0)
	
	IconUtil.setIcon(var_203_4).addStar(arg_203_1.star_reward).addFirstReward(Account:isFirstReward(arg_203_0.vars.result.map_id, arg_203_1.code)).addGoldBox(arg_203_1.goldbox_reward).done()
	UIAction:Add(SEQ(DELAY(100 + arg_203_1.idx * 70), CALL(UIUtil.regIconSpotPlayEffect, UIUtil, var_203_4), CALL(SoundEngine.play, SoundEngine, "event:/effect/clear_reward")), var_203_4, "block")
	
	if arg_203_1.not_exist then
		var_203_4:setOpacity(76.5)
	end
	
	local var_203_5 = load_control("wnd/result_reward_card.csb")
	local var_203_6 = var_203_5:getChildByName("bg_item")
	
	if var_203_6 then
		var_203_6:addChild(var_203_4)
		var_203_4:setPosition(0, 0)
		var_203_4:setAnchorPoint(0.5, 0.5)
		
		if var_203_3 then
			var_203_4:setScale(0.8)
		elseif var_203_2 then
			var_203_4:setScale(1.05)
		else
			var_203_4:setScale(1)
		end
		
		var_203_5:getChildByName("btn_select").item = arg_203_1
		
		return var_203_5
	end
	
	return var_203_4
end

function ClearResult.getRewardTableForAbyssChallenge(arg_204_0)
	local var_204_0 = {}
	local var_204_1 = arg_204_0.vars.result.map_id
	local var_204_2 = Account:getMapClearCount(var_204_1)
	
	if var_204_2 == 1 or var_204_2 == 0 then
		local var_204_3 = DB("level_enter", var_204_1, {
			"show_first_clear_reward"
		})
		local var_204_4 = var_204_3 ~= nil and totable(var_204_3) or nil
		
		if var_204_4 then
			for iter_204_0, iter_204_1 in pairs(var_204_4) do
				table.insert(var_204_0, {
					show_small_count = true,
					first_reward = true,
					idx = #var_204_0,
					code = iter_204_1[1],
					count = to_n(iter_204_1[2])
				})
			end
		end
	end
	
	return var_204_0
end

function ClearResult.getRewardTable(arg_205_0, arg_205_1)
	if not Battle.logic then
		return 
	end
	
	arg_205_1 = arg_205_1 or {}
	
	local var_205_0 = {}
	local var_205_1 = arg_205_0.vars.result.drop_bouns_list or {}
	local var_205_2 = arg_205_0.vars.result.drop_pet_bouns_list or {}
	local var_205_3 = {}
	
	for iter_205_0, iter_205_1 in pairs(arg_205_0.vars.result.missions or {}) do
		local var_205_4, var_205_5 = DB("mission_data", iter_205_1.contents_id, {
			"reward_id1",
			"reward_count1"
		})
		
		if var_205_4 and Account:isDungeonMissionClearedByMissionId(arg_205_0.vars.result.map_id, iter_205_1.contents_id) then
			var_205_3[iter_205_1.contents_id] = {
				reward_id = var_205_4,
				reward_count = var_205_5
			}
		end
	end
	
	for iter_205_2, iter_205_3 in pairs(arg_205_0.vars.result.character) do
		local var_205_6 = false
		
		if arg_205_0.vars.is_tree then
			for iter_205_4, iter_205_5 in pairs(var_205_3 or {}) do
				if iter_205_5.reward_id == iter_205_3.code then
					var_205_6 = true
					
					break
				end
			end
		end
		
		table.insert(var_205_0, {
			idx = #var_205_0,
			code = iter_205_3.code,
			count = iter_205_3.count,
			star_reward = var_205_6
		})
	end
	
	local var_205_7 = table.clone(arg_205_0.vars.result.equip or {})
	local var_205_8 = table.clone(arg_205_0.vars.result.tokens or {})
	local var_205_9 = DungeonMaze:getGoldChestItems(Battle.logic.map.enter, Battle.logic) or {}
	local var_205_10 = {}
	local var_205_11 = {}
	
	for iter_205_6, iter_205_7 in pairs(var_205_7 or {}) do
		local var_205_12 = {}
		
		for iter_205_8, iter_205_9 in pairs(var_205_9 or {}) do
			if iter_205_7.code == iter_205_9[1] and iter_205_9.is_first_clear == true then
				table.insert(var_205_0, {
					goldbox_reward = true,
					idx = #var_205_0,
					id = iter_205_7.id,
					code = iter_205_7.code,
					count = iter_205_7.count,
					set_fx = iter_205_7.f,
					equip_stat = iter_205_7.op,
					g = iter_205_7.g
				})
				
				var_205_10[iter_205_6] = iter_205_6
				var_205_12[iter_205_8] = iter_205_8
			end
		end
		
		for iter_205_10, iter_205_11 in pairs(var_205_12) do
			var_205_9[iter_205_10] = nil
		end
	end
	
	for iter_205_12, iter_205_13 in pairs(var_205_8 or {}) do
		local var_205_13 = {}
		
		for iter_205_14, iter_205_15 in pairs(var_205_9 or {}) do
			if Account:isCurrencyType(iter_205_13.code) == Account:isCurrencyType(iter_205_15[1]) and to_n(iter_205_13.count) >= to_n(iter_205_15[2]) and iter_205_15.is_first_clear == true then
				local var_205_14 = string.starts(iter_205_13.code, "to_") == true and iter_205_13.code or "to_" .. iter_205_13.code
				
				table.insert(var_205_0, {
					show_small_count = true,
					goldbox_reward = true,
					idx = #var_205_0,
					code = var_205_14,
					count = iter_205_15[2]
				})
				
				iter_205_13.count = iter_205_13.count - iter_205_15[2]
				var_205_13[iter_205_14] = iter_205_14
				
				if iter_205_13.count <= 0 then
					var_205_11[iter_205_12] = to_n(var_205_11[iter_205_12]) + iter_205_13.count
				end
			end
		end
		
		for iter_205_16, iter_205_17 in pairs(var_205_13) do
			var_205_9[iter_205_16] = nil
		end
	end
	
	for iter_205_18, iter_205_19 in pairs(var_205_10) do
		var_205_7[iter_205_18] = nil
	end
	
	for iter_205_20, iter_205_21 in pairs(var_205_11) do
		if var_205_8[iter_205_20] and var_205_8[iter_205_20].count then
			var_205_8[iter_205_20].count = to_n(var_205_8[iter_205_20].count) - iter_205_21
			
			if var_205_8[iter_205_20].count <= 0 then
				var_205_8[iter_205_20] = nil
			end
		end
	end
	
	for iter_205_22, iter_205_23 in pairs(var_205_8 or {}) do
		if not iter_205_23.code then
			Log.e("ClearResult.getRewardTable", "nil_v.code")
		end
		
		local var_205_15 = "to_" .. iter_205_23.code
		local var_205_16 = var_205_1[var_205_15]
		local var_205_17 = var_205_2[var_205_15]
		local var_205_18 = iter_205_23.count - (var_205_16 or 0)
		local var_205_19 = iter_205_23.count
		
		for iter_205_24, iter_205_25 in pairs(var_205_3 or {}) do
			if iter_205_25.reward_id == var_205_15 then
				table.insert(var_205_0, {
					star_reward = true,
					idx = #var_205_0,
					code = iter_205_25.reward_id,
					count = iter_205_25.reward_count
				})
				
				var_205_19 = var_205_19 - iter_205_25.reward_count
			end
		end
		
		if var_205_19 > 0 then
			table.insert(var_205_0, {
				idx = #var_205_0,
				code = "to_" .. iter_205_23.code,
				count = var_205_19,
				add_bonus = var_205_16,
				add_pet_bonus = var_205_17,
				lota_arti_bonus = iter_205_23.lota_arti_bonus
			})
		end
	end
	
	local var_205_20 = table.clone(var_205_1)
	
	for iter_205_26, iter_205_27 in pairs(var_205_7 or {}) do
		for iter_205_28, iter_205_29 in pairs(var_205_20) do
			if iter_205_28 == iter_205_27.code and var_205_20[iter_205_28] and type(var_205_20[iter_205_28]) == "number" and var_205_20[iter_205_28] > 0 then
				var_205_20[iter_205_28] = var_205_20[iter_205_28] - 1
				iter_205_27.add_bonus = 1
				
				break
			end
		end
		
		local var_205_21 = var_205_2.equips or {}
		local var_205_22
		
		for iter_205_30, iter_205_31 in pairs(var_205_21) do
			if iter_205_31.id == iter_205_27.id then
				var_205_22 = iter_205_31.count
				iter_205_27.add_pet_bonus = var_205_22
				
				break
			end
		end
		
		local var_205_23 = not Account:getEquip(iter_205_27.id)
		
		if not var_205_23 then
			table.insert(var_205_0, {
				idx = #var_205_0,
				id = iter_205_27.id,
				code = iter_205_27.code,
				count = iter_205_27.count,
				set_fx = iter_205_27.f,
				equip_stat = iter_205_27.op,
				g = iter_205_27.g,
				add_pet_bonus = var_205_22,
				not_exist = var_205_23,
				add_bonus = iter_205_27.add_bonus
			})
		end
		
		TutorialGuide:onEquipResult(iter_205_27.code)
	end
	
	for iter_205_32, iter_205_33 in pairs(arg_205_0.vars.result.items or {}) do
		if not iter_205_33.count then
			print("LOTA REPORT :: V COUNT WAS NIL.")
			table.print(arg_205_0.vars.result.items)
		end
		
		local var_205_24 = false
		local var_205_25 = iter_205_33.code
		local var_205_26 = var_205_1[var_205_25]
		local var_205_27 = var_205_2[var_205_25]
		local var_205_28 = (var_205_2.drop_items or {})[var_205_25]
		
		if var_205_28 then
			var_205_27 = (var_205_27 or 0) + var_205_28
		end
		
		local var_205_29 = iter_205_33.count - (var_205_26 or 0)
		local var_205_30 = Account:isFirstReward(ClearResult.vars.result.map_id, iter_205_33.code)
		local var_205_31
		
		for iter_205_34, iter_205_35 in pairs(var_205_9 or {}) do
			if iter_205_33.code == iter_205_35[1] then
				var_205_31 = true
				
				break
			end
		end
		
		if arg_205_0.vars.is_tree then
			for iter_205_36, iter_205_37 in pairs(var_205_3 or {}) do
				if iter_205_37.reward_id == var_205_25 then
					var_205_24 = true
					
					break
				end
			end
		end
		
		table.insert(var_205_0, {
			show_small_count = true,
			idx = #var_205_0,
			code = var_205_25,
			count = iter_205_33.count,
			add_bonus = var_205_26,
			add_pet_bonus = var_205_27,
			first_reward = var_205_30,
			goldbox_reward = var_205_31,
			lota_arti_bonus = iter_205_33.lota_arti_bonus,
			star_reward = var_205_24
		})
	end
	
	if arg_205_0.vars.result.penguin_mileage and not table.empty(arg_205_0.vars.result.penguin_mileage) then
		local var_205_32 = arg_205_0.vars.result.penguin_mileage
		
		if var_205_32 and var_205_32.rewards then
			if var_205_32.rewards.reward_info and var_205_32.rewards.reward_info.new_items then
				for iter_205_38, iter_205_39 in pairs(var_205_32.rewards.reward_info.new_items) do
					table.insert(var_205_0, {
						show_small_count = true,
						idx = #var_205_0,
						code = iter_205_39.code,
						count = iter_205_39.diff
					})
				end
			end
			
			if Account:isCurrencyType(var_205_32.rewards.code) then
				local var_205_33 = var_205_32.rewards.code
				local var_205_34 = to_n(var_205_32.rewards.count)
				local var_205_35 = false
				
				for iter_205_40, iter_205_41 in pairs(var_205_0) do
					if iter_205_41.code == var_205_33 then
						iter_205_41.count = iter_205_41.count + var_205_34
						var_205_35 = true
						
						break
					end
				end
				
				if not var_205_35 then
					table.insert(var_205_0, {
						show_small_count = true,
						idx = #var_205_0,
						code = var_205_33,
						count = var_205_34
					})
				end
			end
		end
	end
	
	return var_205_0
end

function ClearResult.refreshEquipRewardTable(arg_206_0, arg_206_1)
	if not arg_206_0.vars or not arg_206_0.vars.result or not arg_206_0.vars.result.equip or not arg_206_1 then
		return 
	end
	
	if not (arg_206_0.vars.result.drop_pet_bouns_list or {}).equips then
		local var_206_0 = {}
	end
	
	for iter_206_0, iter_206_1 in pairs(arg_206_1) do
		for iter_206_2, iter_206_3 in pairs(arg_206_0.vars.result.equip or {}) do
			if iter_206_3.id and iter_206_3.id == iter_206_1 then
				arg_206_0.vars.result.equip[iter_206_2] = nil
			end
		end
	end
end

function ClearResult.settingPlayerExp(arg_207_0)
	local var_207_0 = arg_207_0.childs.n_reward:getChildByName("LEFT")
	
	if not var_207_0 then
		return 
	end
	
	if_set_visible(var_207_0, nil, true)
	
	local var_207_1 = Account:clearAccountLastExp()
	local var_207_2 = Account:getExp()
	local var_207_3 = Account:getAccountExpPercent()
	local var_207_4 = 0
	local var_207_5 = var_207_3 * 100
	
	if var_207_1 and var_207_2 ~= var_207_1 then
		local var_207_6 = Account:getIncAccountExpPercent(var_207_1)
		
		if_set(var_207_0, "add_exp", tostring(var_207_2 - var_207_1))
		
		var_207_4 = var_207_3
		var_207_3 = var_207_3 - var_207_6
	end
	
	if arg_207_0.vars.result and (arg_207_0.vars.result.descent or arg_207_0.vars.result.burning) or not var_207_1 then
		if_set_visible(var_207_0, "n_add_exp_pos", false)
	end
	
	if_set_percent(var_207_0, "exp_bar", var_207_3)
	if_set_percent(var_207_0, "exp_white", var_207_4)
	if_set(var_207_0, "t_percent", string.format("%0.1f%%", var_207_5))
	UIUtil:setLevel(var_207_0:getChildByName("n_lv"), AccountData.level, MAX_ACCOUNT_LEVEL, 3, false, nil, 19)
	if_set_sprite(var_207_0, "face", "face/" .. DB("character", Account:getMainUnitCode(), "face_id") .. "_s.png")
	if_set_sprite(var_207_0, "frame", "item/" .. DB("item_material", Account:getBorderCode(), "icon") .. ".png")
	if_set_effect(var_207_0, "frame", DB("item_material", Account:getBorderCode(), "frame_effect"))
end

function ClearResult.playRewardWindow(arg_208_0)
	local var_208_0 = UIUtil:sortDisplayItems(arg_208_0:getRewardTable(), arg_208_0.vars.result.map_id)
	
	if arg_208_0.vars.result.maze then
		if_set_visible(arg_208_0.childs.n_reward, "btn_shop", false)
	end
	
	arg_208_0:settingPlayerExp()
	
	local var_208_1 = arg_208_0.vars.result.cp.value
	local var_208_2 = UnlockSystem:isUnlockSystem(UNLOCK_ID.LOCAL_SHOP)
	local var_208_3 = arg_208_0.vars.result.cp.value and arg_208_0.vars.result.cp.code and var_208_2
	
	arg_208_0.vars.is_view_get_cp = var_208_3
	
	local var_208_4 = arg_208_0.vars.result.drop_pet_bouns_list[arg_208_0.vars.result.cp.code]
	local var_208_5 = arg_208_0.vars.result.drop_bouns_list[arg_208_0.vars.result.cp.code]
	
	if_set_visible(arg_208_0.childs.n_reward, "contr_point", var_208_3)
	
	if var_208_3 then
		local var_208_6 = DB("item_material", arg_208_0.vars.result.cp.code, "name")
		
		if_set(arg_208_0.childs.n_reward, "title_contr_point", T(var_208_6))
		
		local var_208_7 = DB("level_enter", arg_208_0.vars.result.map_id, "local_num")
		
		if_set(arg_208_0.childs.n_reward, "count_cp", "")
		
		if var_208_7 then
			local var_208_8 = DB("level_world_3_chapter", var_208_7, "shop_cp_category")
			
			if var_208_8 then
				local var_208_9 = DB("shop_chapter_category", var_208_8, {
					"material"
				})
				
				if var_208_9 then
					if_set(arg_208_0.childs.n_reward, "count_cp", T("mission_base_cpshop_cp_value", {
						value = Account:getItemCount(var_208_9)
					}))
					if_set_visible(arg_208_0.childs.n_reward, "stat_up", true)
					if_set(arg_208_0.childs.n_reward, "txt_stat_up", var_208_1)
				end
			end
		end
		
		local var_208_10 = var_208_4 and var_208_4 > 0
		local var_208_11 = var_208_5 and var_208_5 > 0
		
		if_set_visible(arg_208_0.childs.n_reward, "_contr_bonus_pet", var_208_10)
		if_set_visible(arg_208_0.childs.n_reward, "_contr_bonus_hottime", var_208_11)
		
		local var_208_12 = arg_208_0.childs.n_reward:getChildByName("count_cp")
		local var_208_13 = arg_208_0.childs.n_reward:getChildByName("_contr_bonus_hottime")
		local var_208_14 = arg_208_0.childs.n_reward:getChildByName("_contr_bonus_pet")
		
		if var_208_10 and var_208_11 and get_cocos_refid(var_208_12) then
			var_208_12:setPositionX(var_208_12:getPositionX() - 25)
		end
		
		if not var_208_10 and var_208_11 and get_cocos_refid(var_208_13) then
			local var_208_15 = 36
			
			if var_208_1 <= 9 then
				var_208_15 = 51
			end
			
			var_208_13:setPositionX(var_208_13:getPositionX() - var_208_15)
		elseif not var_208_11 and var_208_10 and var_208_1 <= 9 then
			var_208_14:setPositionX(var_208_14:getPositionX() - 15)
		end
	end
	
	local var_208_16 = arg_208_0.childs.n_reward:getChildByName("scrollview_item")
	
	if get_cocos_refid(var_208_16) then
		if arg_208_0.vars.result and arg_208_0.vars.result.crehunt then
			local var_208_17 = var_208_16:getContentSize()
			
			var_208_16:setContentSize(var_208_17.width, 209)
		end
		
		arg_208_0:initScrollView(arg_208_0.childs.n_reward:getChildByName("scrollview_item"), 84, 83)
	end
	
	arg_208_0:setScrollViewItems(var_208_0)
	if_set(arg_208_0.childs.n_reward, "txt_reward_count", "+" .. #var_208_0)
	
	if arg_208_0.vars.result.custom_item_rewards and SubstoryManager:canShowSubCusUI(arg_208_0.vars.result.substory_id) then
		local var_208_18 = arg_208_0.childs.n_reward:getChildByName("n_custom")
		local var_208_19 = arg_208_0.vars.result.custom_item_rewards.new_items
		local var_208_20 = arg_208_0.vars.result.substory_id or (SubstoryManager:getInfo() or {}).id
		
		if var_208_18 and var_208_19 and var_208_20 then
			arg_208_0.vars.isSubCusExist = true
			
			local var_208_21 = SubStoryUtil:getSubCusItemList(var_208_20)
			
			if not var_208_21 or table.empty(var_208_21) then
				return 
			end
			
			var_208_18:setVisible(true)
			
			local var_208_22 = 1
			
			for iter_208_0, iter_208_1 in pairs(var_208_21) do
				local var_208_23 = var_208_18:getChildByName("n_" .. var_208_22)
				
				if not var_208_23 then
					break
				end
				
				var_208_23:setVisible(true)
				UIUtil:getRewardIcon(nil, iter_208_1.id, {
					parent = var_208_23:getChildByName("n_item" .. var_208_22)
				})
				if_set(var_208_23, "txt_name" .. var_208_22, T(iter_208_1.name))
				if_set(var_208_23, "txt_count" .. var_208_22, iter_208_1.count)
				
				local var_208_24 = 0
				local var_208_25 = false
				
				for iter_208_2, iter_208_3 in pairs(var_208_19) do
					if iter_208_3.code == iter_208_1.id then
						var_208_24 = tonumber(iter_208_3.diff or 0)
						var_208_25 = true
					end
				end
				
				if var_208_25 then
					if_set_visible(var_208_23:getChildByName("n_result"), "n_up", true)
					if_set(var_208_23, "t_count_up", var_208_24)
				else
					if_set_visible(var_208_23:getChildByName("n_result"), "n_keep", true)
					if_set(var_208_23, "t_count_keep", var_208_24)
				end
				
				var_208_22 = var_208_22 + 1
			end
			
			local var_208_26 = table.count(var_208_21)
			local var_208_27 = 0
			
			if var_208_26 >= 4 then
				var_208_27 = (var_208_26 - 3) * 36
				
				local var_208_28 = var_208_18:getChildByName("n_custom_box")
				local var_208_29 = var_208_18:getChildByName("_grow")
				
				if var_208_28 and var_208_29 then
					local var_208_30 = var_208_28:getContentSize()
					
					var_208_28:setContentSize(var_208_30.width, var_208_30.height + var_208_27)
					
					local var_208_31 = var_208_29:getContentSize()
					
					var_208_29:setContentSize(var_208_31.width, var_208_31.height + var_208_27)
				end
			end
			
			local var_208_32 = arg_208_0.childs.n_reward:getChildByName("scrollview_item")
			local var_208_33 = var_208_32:getContentSize()
			
			var_208_32:setContentSize(var_208_33.width, var_208_33.height - (147 + var_208_27))
		end
	end
	
	BattleField:overlay(arg_208_0.childs.n_reward)
	UIAction:Add(FADE_IN(200), arg_208_0.childs.n_reward, "block")
	
	if arg_208_0.vars.result and arg_208_0.vars.result.descent then
		if_set_visible(arg_208_0.childs.n_reward, "n_common", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_key_slot", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_challenge", true)
		if_set_visible(arg_208_0.childs.n_reward, "n_crevice", false)
		arg_208_0:setMultiTeamReward_ui()
	elseif arg_208_0.vars.result and arg_208_0.vars.result.burning then
		if_set_visible(arg_208_0.childs.n_reward, "n_common", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_key_slot", true)
		if_set_visible(arg_208_0.childs.n_reward, "n_challenge", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_crevice", false)
		arg_208_0:setBurningTeamReward_ui()
	elseif arg_208_0.vars.result and arg_208_0.vars.result.crehunt then
		if_set_visible(arg_208_0.childs.n_reward, "n_common", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_key_slot", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_challenge", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_crevice", true)
		arg_208_0:setCrehuntReward_ui()
	else
		if_set_visible(arg_208_0.childs.n_reward, "n_common", true)
		if_set_visible(arg_208_0.childs.n_reward, "n_key_slot", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_challenge", false)
		if_set_visible(arg_208_0.childs.n_reward, "n_crevice", false)
		arg_208_0:setCommonReward_ui()
	end
	
	local var_208_34 = arg_208_0.childs.n_reward:getChildByName("LEFT"):findChildByName("n_btn_booster")
	local var_208_35 = var_208_34:findChildByName("btn_booster")
	local var_208_36 = Booster:hasHotTimeBooster()
	
	if var_208_36 then
		var_208_35:setPositionX(var_208_35:getPositionX() + 89)
	end
	
	if_set_visible(var_208_34, "n_btn_hottime_nodata", var_208_36)
	
	if BattleRepeat:getConfigRepeatPlay() and BattleRepeat:get_repeatCount() > 0 then
		arg_208_0:hideAll_btns()
	end
	
	if arg_208_0.vars.result and arg_208_0.vars.result.crehunt then
		if_set_add_position_y(arg_208_0.childs.n_reward, "n_none_item", 142)
	end
	
	if_set_visible(arg_208_0.childs.n_reward, "n_none_item", #var_208_0 <= 0)
	
	if arg_208_0.vars.result.penguin_mileage and not table.empty(arg_208_0.vars.result.penguin_mileage) then
		arg_208_0:setPenguin_ui()
	end
end

function ClearResult.setMultiTeamReward_ui(arg_209_0)
	if_set_visible(arg_209_0.childs.n_reward, "booster_2", false)
	
	local var_209_0 = {}
	local var_209_1 = 1
	local var_209_2
	
	if arg_209_0.vars.result.descent then
		var_209_2 = DESCENT_TEAM_IDX
	end
	
	local var_209_3 = table.count(var_209_2)
	
	for iter_209_0, iter_209_1 in pairs(var_209_2) do
		local var_209_4 = Account:getTeam(tonumber(iter_209_1))
		
		for iter_209_2, iter_209_3 in pairs(var_209_4) do
			if not var_209_0[var_209_1] then
				var_209_0[var_209_1] = {}
			end
			
			if not iter_209_3.isPet then
				table.insert(var_209_0[var_209_1], iter_209_3)
			end
		end
		
		var_209_1 = var_209_1 + 1
	end
	
	local var_209_5 = {}
	local var_209_6 = Battle.logic.result_stat:SelectMVP_multi()
	local var_209_7 = {}
	
	arg_209_0.vars.mvp_uid_infos = var_209_6
	
	if var_209_6 and not table.empty(var_209_6) then
		for iter_209_4 = 1, var_209_3 do
			local var_209_8 = var_209_6[iter_209_4]
			
			if var_209_8 then
				local var_209_9 = Account:getUnit(var_209_8)
				
				table.insert(var_209_7, var_209_9)
			else
				local var_209_10 = table.count(var_209_0[iter_209_4])
				
				table.insert(var_209_7, var_209_0[iter_209_4][math.random(1, var_209_10)])
			end
		end
	else
		for iter_209_5 = 1, var_209_3 do
			local var_209_11 = table.count(var_209_0[iter_209_5])
			
			table.insert(var_209_7, var_209_0[iter_209_5][math.random(1, var_209_11)])
		end
	end
	
	local var_209_12 = arg_209_0.childs.n_reward:getChildByName("n_challenge")
	
	for iter_209_6, iter_209_7 in pairs(var_209_0) do
		local var_209_13 = 0
		local var_209_14 = 1
		local var_209_15 = var_209_12:getChildByName("stat" .. iter_209_6)
		local var_209_16 = var_209_15:getChildByName("n_upgrade")
		
		if_set(var_209_15, "txt_mvp", T("ui_battle_ready_challenge_formation_team", {
			team = iter_209_6
		}))
		if_set_visible(var_209_16, "n_1", table.count(iter_209_7) >= 2)
		if_set_visible(var_209_16, "n_2", table.count(iter_209_7) >= 3)
		
		for iter_209_8, iter_209_9 in pairs(iter_209_7) do
			local var_209_17 = var_209_16:getChildByName("n_" .. var_209_14)
			
			if var_209_15 and var_209_16 then
				local var_209_18 = {}
				local var_209_19 = table.find(var_209_7, iter_209_9)
				local var_209_20 = arg_209_0:getCharacterWindow(iter_209_9, var_209_18, {
					ignore_pos = true,
					wnd = var_209_17
				})
				
				if var_209_20 and not var_209_19 then
					var_209_13 = var_209_13 + 1
					var_209_14 = var_209_14 + 1
					
					var_209_20:setOpacity(0)
					UIAction:Add(SEQ(DELAY((var_209_13 - 1) * 85), SLIDE_IN(300, 600)), var_209_20, "block")
					
					if get_cocos_refid(var_209_20.fav) then
						var_209_20.fav:setVisible(false)
					end
					
					if_set_visible(var_209_17, "progress_bg", false)
					if_set_visible(var_209_17, "progress_white", false)
					if_set_visible(var_209_17, "progress_orange", false)
					if_set_visible(var_209_17, "intimacy", false)
				end
			end
		end
	end
	
	if var_209_7 then
		for iter_209_10, iter_209_11 in pairs(var_209_7) do
			local var_209_21 = var_209_12:getChildByName("stat" .. iter_209_10)
			local var_209_22 = var_209_21:getChildByName("n_mvp" .. iter_209_10)
			local var_209_23 = var_209_21:getChildByName("n_mvp_stat1")
			local var_209_24 = var_209_12:getChildByName("n_mvp_portrait" .. iter_209_10)
			local var_209_25 = var_209_21:getChildByName("n_upgrade")
			
			if get_cocos_refid(var_209_22) and get_cocos_refid(var_209_24) and get_cocos_refid(var_209_23) then
				local var_209_26, var_209_27 = UIUtil:getPortraitAni(iter_209_11.db.face_id, {
					parent_pos_y = var_209_24:getPositionY()
				})
				
				if var_209_26 then
					UnitMain:setPortraitEmotion(iter_209_11, var_209_26)
					
					if not var_209_27 then
						var_209_26:setAnchorPoint(0.5, 0.15)
					end
					
					var_209_26:setScale(0.8)
					var_209_24:addChild(var_209_26)
					var_209_26:setPositionX(0 + VIEW_BASE_LEFT - VIEW_WIDTH * 0.5 - DESIGN_WIDTH * 0.3)
					UIAction:Add(LOG(MOVE_TO(300, 0)), var_209_26, "block")
				end
				
				if not iter_209_11.db.face_id then
					Log.e("ClearResult.playRewardWindow", "mvp_unit.db.face_id." .. iter_209_11.db.code)
				end
				
				local var_209_28 = "event:/voc/character/" .. iter_209_11.db.face_id .. "/evt/win"
				
				table.insert(var_209_5, var_209_28)
				
				local var_209_29 = var_209_22:getChildByName("txt_mvp_name")
				local var_209_30 = get_word_wrapped_name(var_209_29, T(iter_209_11.db.name))
				
				if_set(var_209_22, "txt_mvp_name", var_209_30)
				var_209_22:setOpacity(0)
				UIAction:Add(SEQ(DELAY(300), LOG(FADE_IN(300))), var_209_22, "block")
				var_209_22:setPositionY(var_209_22:getPositionY() - 46)
				
				if var_209_29:getStringNumLines() == 1 then
					var_209_22:setPositionY(var_209_22:getPositionY() - 40)
				end
				
				local var_209_31 = var_209_25:getChildByName("n_3")
				local var_209_32 = var_209_25:getChildByName("n_3_none")
				
				if get_cocos_refid(var_209_31) and get_cocos_refid(var_209_32) then
					local var_209_33 = Account:getUnit(iter_209_11.inst.uid)
					
					var_209_31:setVisible(false)
					var_209_32:setVisible(true)
					UIUtil:setLevelDetail(var_209_32, var_209_33:getLv(), math.min(60, iter_209_11:getMaxLevel()))
				end
			end
			
			if #var_209_5 > 0 then
				local var_209_34 = table.shuffle(var_209_5)[1]
				
				SoundEngine:play(var_209_34)
			end
		end
	end
end

function ClearResult.setBurningTeamReward_ui(arg_210_0)
	local var_210_0 = {}
	local var_210_1 = 1
	local var_210_2 = BURNING_TEAM_IDX
	local var_210_3 = table.count(var_210_2)
	
	for iter_210_0, iter_210_1 in pairs(var_210_2) do
		local var_210_4 = Account:getTeam(tonumber(iter_210_1))
		
		for iter_210_2, iter_210_3 in pairs(var_210_4) do
			if not var_210_0[var_210_1] then
				var_210_0[var_210_1] = {}
			end
			
			if not iter_210_3.isPet then
				table.insert(var_210_0[var_210_1], iter_210_3)
			end
		end
		
		var_210_1 = var_210_1 + 1
	end
	
	local var_210_5 = {}
	local var_210_6 = Battle.logic.result_stat:SelectMVP_multi()
	local var_210_7 = arg_210_0.childs.n_reward:getChildByName("n_key_slot")
	local var_210_8 = Battle.logic:getKeySlotUnit()
	local var_210_9
	
	if var_210_6 then
		var_210_9 = Account:getUnit(var_210_6[1])
	end
	
	for iter_210_4, iter_210_5 in pairs(var_210_0) do
		local var_210_10 = 0
		local var_210_11 = 1
		local var_210_12 = var_210_7:getChildByName("team_0" .. tostring(iter_210_4))
		
		if_set(var_210_12, "txt_mvp", T("ui_clan_worldboss_formation_team", {
			team_number = iter_210_4
		}))
		
		for iter_210_6, iter_210_7 in pairs(iter_210_5) do
			local var_210_13 = var_210_12:getChildByName("hero_0" .. tostring(iter_210_6))
			
			if var_210_13 then
				local var_210_14 = {}
				local var_210_15 = arg_210_0:getCharacterWindow(iter_210_7, var_210_14)
				
				if var_210_15 then
					var_210_10 = var_210_10 + 1
					var_210_11 = var_210_11 + 1
					
					if get_cocos_refid(var_210_15.fav) then
						var_210_15.fav:setVisible(false)
					end
					
					if_set_visible(var_210_13, "progress_bg", false)
					if_set_visible(var_210_13, "progress_white", false)
					if_set_visible(var_210_13, "progress_orange", false)
					if_set_visible(var_210_15, "intimacy", false)
					if_set_visible(var_210_15, "key_slot_icon", var_210_8 and var_210_8.inst.code == iter_210_7.inst.code or false)
					if_set_visible(var_210_15, "n_mvp", iter_210_7 == var_210_9)
					var_210_13:addChild(var_210_15)
				end
			end
		end
	end
	
	if var_210_9 then
		local var_210_16 = var_210_7:getChildByName("n_mvp1")
		local var_210_17 = var_210_7:getChildByName("n_mvp_portrait1")
		
		if get_cocos_refid(var_210_16) and get_cocos_refid(var_210_17) then
			local var_210_18, var_210_19 = UIUtil:getPortraitAni(var_210_9.db.face_id, {
				parent_pos_y = var_210_17:getPositionY()
			})
			
			if var_210_18 then
				UnitMain:setPortraitEmotion(var_210_9, var_210_18)
				
				if not var_210_19 then
					var_210_18:setAnchorPoint(0.5, 0.15)
				end
				
				var_210_18:setScale(0.8)
				var_210_17:addChild(var_210_18)
			end
			
			if not var_210_9.db.face_id then
				Log.e("ClearResult.playRewardWindow", "mvp_unit.db.face_id." .. _mvp_unit.db.code)
			end
			
			local var_210_20 = "event:/voc/character/" .. var_210_9.db.face_id .. "/evt/win"
			
			table.insert(var_210_5, var_210_20)
			
			local var_210_21 = var_210_16:getChildByName("txt_mvp_name")
			local var_210_22 = get_word_wrapped_name(var_210_21, T(var_210_9.db.name))
			
			if_set(var_210_16, "txt_mvp_name", var_210_22)
			var_210_16:setOpacity(0)
			UIAction:Add(SEQ(DELAY(300), LOG(FADE_IN(600))), var_210_16, "block")
			var_210_16:setPositionY(var_210_16:getPositionY() - 46)
			
			if var_210_21:getStringNumLines() == 1 then
				var_210_16:setPositionY(var_210_16:getPositionY() - 40)
			end
		end
		
		if #var_210_5 > 0 then
			local var_210_23 = table.shuffle(var_210_5)[1]
			
			SoundEngine:play(var_210_23)
		end
	end
end

function ClearResult.setCommonReward_ui(arg_211_0)
	local var_211_0 = {}
	local var_211_1 = 0
	local var_211_2, var_211_3, var_211_4 = Battle.logic.result_stat:SelectMVP()
	local var_211_5
	
	if var_211_4 then
		for iter_211_0, iter_211_1 in pairs(arg_211_0.vars.result.units) do
			if iter_211_1:getUID() == var_211_4 then
				var_211_5 = iter_211_1
			end
		end
	else
		local var_211_6 = {}
		
		for iter_211_2, iter_211_3 in pairs(arg_211_0.vars.result.units) do
			if iter_211_3.db.code ~= "cleardummy" then
				table.insert(var_211_6, iter_211_3)
			end
		end
		
		var_211_5 = var_211_6[math.random(1, #var_211_6)]
	end
	
	for iter_211_4, iter_211_5 in pairs(arg_211_0.vars.result.units) do
		if iter_211_5 and iter_211_5.db.code ~= "cleardummy" then
			if iter_211_5:isContentEnhance() and iter_211_5.contetns_origins and not table.empty(iter_211_5.contetns_origins) then
				iter_211_5.inst.lv = iter_211_5.contetns_origins.lv or 50
				iter_211_5.inst.grade = iter_211_5.contetns_origins.grade or 5
				iter_211_5.inst.zodiac = iter_211_5.contetns_origins.zodiac or 0
			end
			
			local var_211_7 = {}
			
			if arg_211_0.vars.result.units_exp[iter_211_5.db.code] then
				var_211_7.addExp = arg_211_0.vars.result.units_exp[iter_211_5.db.code].add_exp
				var_211_7.prev_ratio = arg_211_0.vars.result.units_exp[iter_211_5.db.code].prev_ratio
				var_211_7.distExp = arg_211_0.vars.result.units_exp[iter_211_5.db.code].dist_exp
			end
			
			if arg_211_0.vars.result.units_levelup[iter_211_5.db.code] then
				var_211_7.isLvUp = true
			end
			
			if arg_211_0.vars.result.fav_levelup[iter_211_5.db.code] then
				var_211_7.isFavLvUp = true
			end
			
			local var_211_8 = arg_211_0:getCharacterWindow(iter_211_5, var_211_7)
			
			if var_211_8 then
				if_set_visible(var_211_8, "n_mvp", iter_211_5 == var_211_5)
				
				var_211_1 = var_211_1 + 1
				
				arg_211_0.childs.n_reward:getChildByName("n_pos" .. var_211_1):addChild(var_211_8)
				
				arg_211_0.childs["char" .. var_211_1] = var_211_8
				
				var_211_8:setOpacity(0)
				UIAction:Add(SEQ(DELAY((var_211_1 - 1) * 85), SLIDE_IN(300, 600)), var_211_8, "block")
				
				if get_cocos_refid(var_211_8.fav) then
					UIAction:Add(SEQ(SHOW(false), OPACITY(0, 0, 0), DELAY(400), SLIDE_IN_Y(600, 600), DELAY(2000), FADE_OUT(600)), var_211_8.fav, "fav_add")
				end
				
				local var_211_9 = arg_211_0.vars.result.units_favexp[iter_211_5.db.code]
				
				if var_211_9 and var_211_8.fav_prog and var_211_8.fav_prog[2] then
					local var_211_10 = math.max(var_211_9.curr_lv - var_211_9.prev_lv, 0)
					local var_211_11 = var_211_9.curr_exp + var_211_10
					
					UIAction:Add(SEQ(DELAY(400), COND_LOOP(DELAY(100), function()
						var_211_8.progress_var = var_211_8.progress_var or var_211_9.prev_exp
						
						if var_211_11 <= var_211_8.progress_var then
							var_211_8.fav_prog[1]:setPercentage(var_211_9.curr_exp * 100)
							var_211_8.fav_prog[2]:setPercentage(var_211_9.curr_exp * 100)
							
							return true
						end
						
						var_211_8.progress_var = var_211_8.progress_var + var_211_11 / 100
						
						local var_212_0 = var_211_8.progress_var
						
						var_211_8.fav_prog[1]:setPercentage(var_212_0 < var_211_10 and 100 or var_211_9.curr_exp * 100)
						var_211_8.fav_prog[2]:setPercentage(var_212_0 * 100 % 100)
					end)), var_211_8.fav_prog[2], "fav_add")
					
					for iter_211_6 = 1, 2 do
						UIAction:Add(SEQ(DELAY((var_211_1 - 1) * 85), SHOW(true), FADE_IN(300)), var_211_8.fav_prog[iter_211_6], "block")
					end
					
					local var_211_12 = var_211_8:getChildByName("intimacy")
					
					if get_cocos_refid(var_211_12) then
						local var_211_13 = NONE()
						
						if var_211_9.curr_lv > var_211_9.prev_lv then
							var_211_13 = SEQ(DELAY(460), CALL(function()
								local var_213_0 = string.format("img/hero_love_icon_%d.png", var_211_9.prev_lv > 7 and 3 or var_211_9.prev_lv > 4 and 2 or 1)
								
								if_set_sprite(var_211_8, "hero_love_icon", var_213_0)
								if_set(var_211_8, "t_lv", var_211_9.curr_lv)
							end))
						end
						
						UIAction:Add(SEQ(DELAY(400), CALL(function()
							EffectManager:Play({
								fn = "ui_result_love.cfx",
								y = -40,
								delay = 340,
								scale = 0.8,
								layer = var_211_12
							})
						end), var_211_13), var_211_12, "fav_change")
					end
				end
			end
		end
	end
	
	if var_211_5 then
		local var_211_14 = arg_211_0.childs.n_reward:getChildByName("n_mvp_portrait")
		local var_211_15, var_211_16 = UIUtil:getPortraitAni(var_211_5.db.face_id, {
			parent_pos_y = var_211_14:getPositionY()
		})
		
		if not var_211_16 then
			var_211_15:setAnchorPoint(0.5, 0.15)
		end
		
		if var_211_15 then
			UnitMain:setPortraitEmotion(var_211_5, var_211_15)
			var_211_15:setScale(0.8)
			var_211_14:addChild(var_211_15)
			var_211_15:setPositionX(0 + VIEW_BASE_LEFT - VIEW_WIDTH * 0.5 - DESIGN_WIDTH * 0.3)
			UIAction:Add(LOG(MOVE_TO(300, 0)), var_211_15, "block")
		end
		
		if not var_211_5.db.face_id then
			Log.e("ClearResult.playRewardWindow", "mvp_unit.db.face_id." .. var_211_5.db.code)
		end
		
		local var_211_17 = "event:/voc/character/" .. var_211_5.db.face_id .. "/evt/win"
		
		table.insert(var_211_0, var_211_17)
		
		local var_211_18 = arg_211_0.childs.n_reward:getChildByName("n_mvp")
		local var_211_19 = var_211_18:getChildByName("txt_mvp_name")
		local var_211_20 = get_word_wrapped_name(var_211_19, T(var_211_5.db.name))
		
		if_set(var_211_18, "txt_mvp_name", var_211_20)
		var_211_18:setOpacity(0)
		UIAction:Add(SEQ(DELAY(300), LOG(FADE_IN(300))), var_211_18, "block")
	end
	
	if_set_visible(arg_211_0.childs.n_reward, "n_mvp", var_211_5 ~= nil)
	
	if #var_211_0 > 0 then
		local var_211_21 = table.shuffle(var_211_0)[1]
		
		SoundEngine:play(var_211_21)
	end
end

function ClearResult.setCrehuntReward_ui(arg_215_0)
	if not arg_215_0.vars or not get_cocos_refid(arg_215_0.childs.n_reward) then
		return 
	end
	
	local var_215_0 = getChildByPath(arg_215_0.childs.n_reward, "n_crevice")
	local var_215_1, var_215_5
	
	if get_cocos_refid(var_215_0) then
		var_215_0:setVisible(true)
		arg_215_0:setCrehuntBoss_ui()
		
		var_215_1 = 0
		
		local var_215_2, var_215_3, var_215_4 = Battle.logic.result_stat:SelectMVP()
		
		var_215_5 = nil
		
		if var_215_4 then
			for iter_215_0, iter_215_1 in pairs(arg_215_0.vars.result.units) do
				if iter_215_1:getUID() == var_215_4 then
					var_215_5 = iter_215_1
				end
			end
		end
		
		for iter_215_2, iter_215_3 in pairs(arg_215_0.vars.result.units) do
			if iter_215_3 and iter_215_3.db.code ~= "cleardummy" then
				if iter_215_3:isContentEnhance() and iter_215_3.contetns_origins and not table.empty(iter_215_3.contetns_origins) then
					iter_215_3.inst.lv = iter_215_3.contetns_origins.lv or 50
					iter_215_3.inst.grade = iter_215_3.contetns_origins.grade or 5
					iter_215_3.inst.zodiac = iter_215_3.contetns_origins.zodiac or 0
				end
				
				local var_215_6 = {}
				
				if arg_215_0.vars.result.units_exp[iter_215_3.db.code] then
					var_215_6.addExp = arg_215_0.vars.result.units_exp[iter_215_3.db.code].add_exp
					var_215_6.prev_ratio = arg_215_0.vars.result.units_exp[iter_215_3.db.code].prev_ratio
					var_215_6.distExp = arg_215_0.vars.result.units_exp[iter_215_3.db.code].dist_exp
				end
				
				if arg_215_0.vars.result.units_levelup[iter_215_3.db.code] then
					var_215_6.isLvUp = true
				end
				
				if arg_215_0.vars.result.fav_levelup[iter_215_3.db.code] then
					var_215_6.isFavLvUp = true
				end
				
				local var_215_7 = arg_215_0:getCharacterWindow(iter_215_3, var_215_6)
				
				if var_215_7 then
					if_set_visible(var_215_7, "n_mvp", iter_215_3 == var_215_5)
					
					var_215_1 = var_215_1 + 1
					
					arg_215_0.childs.n_reward:getChildByName("n_" .. var_215_1):addChild(var_215_7)
					
					arg_215_0.childs["char" .. var_215_1] = var_215_7
					
					var_215_7:setOpacity(0)
					UIAction:Add(SEQ(DELAY((var_215_1 - 1) * 85), SLIDE_IN(300, 600)), var_215_7, "block")
					
					if get_cocos_refid(var_215_7.fav) then
						UIAction:Add(SEQ(SHOW(false), OPACITY(0, 0, 0), DELAY(400), SLIDE_IN_Y(600, 600), DELAY(2000), FADE_OUT(600)), var_215_7.fav, "fav_add")
					end
					
					local var_215_8 = arg_215_0.vars.result.units_favexp[iter_215_3.db.code]
					
					if var_215_8 and var_215_7.fav_prog and var_215_7.fav_prog[2] then
						local var_215_9 = math.max(var_215_8.curr_lv - var_215_8.prev_lv, 0)
						local var_215_10 = var_215_8.curr_exp + var_215_9
						
						UIAction:Add(SEQ(DELAY(400), COND_LOOP(DELAY(100), function()
							var_215_7.progress_var = var_215_7.progress_var or var_215_8.prev_exp
							
							if var_215_10 <= var_215_7.progress_var then
								var_215_7.fav_prog[1]:setPercentage(var_215_8.curr_exp * 100)
								var_215_7.fav_prog[2]:setPercentage(var_215_8.curr_exp * 100)
								
								return true
							end
							
							var_215_7.progress_var = var_215_7.progress_var + var_215_10 / 100
							
							local var_216_0 = var_215_7.progress_var
							
							var_215_7.fav_prog[1]:setPercentage(var_216_0 < var_215_9 and 100 or var_215_8.curr_exp * 100)
							var_215_7.fav_prog[2]:setPercentage(var_216_0 * 100 % 100)
						end)), var_215_7.fav_prog[2], "fav_add")
						
						for iter_215_4 = 1, 2 do
							UIAction:Add(SEQ(DELAY((var_215_1 - 1) * 85), SHOW(true), FADE_IN(300)), var_215_7.fav_prog[iter_215_4], "block")
						end
						
						local var_215_11 = var_215_7:getChildByName("intimacy")
						
						if get_cocos_refid(var_215_11) then
							local var_215_12 = NONE()
							
							if var_215_8.curr_lv > var_215_8.prev_lv then
								var_215_12 = SEQ(DELAY(460), CALL(function()
									local var_217_0 = string.format("img/hero_love_icon_%d.png", var_215_8.prev_lv > 7 and 3 or var_215_8.prev_lv > 4 and 2 or 1)
									
									if_set_sprite(var_215_7, "hero_love_icon", var_217_0)
									if_set(var_215_7, "t_lv", var_215_8.curr_lv)
								end))
							end
							
							UIAction:Add(SEQ(DELAY(400), CALL(function()
								EffectManager:Play({
									fn = "ui_result_love.cfx",
									y = -40,
									delay = 340,
									scale = 0.8,
									layer = var_215_11
								})
							end), var_215_12), var_215_11, "fav_change")
						end
					end
				end
			end
		end
	end
	
	local var_215_13 = arg_215_0.childs.n_reward:getChildByName("RIGHT")
	
	if get_cocos_refid(var_215_13) then
		local var_215_14 = var_215_13:getChildByName("n_crevice")
		
		if get_cocos_refid(var_215_14) then
			var_215_14:setVisible(true)
			
			local var_215_15
			local var_215_16
			local var_215_17 = arg_215_0.vars.result.drop_pet_bouns_list or {}
			
			if var_215_17.crehunt then
				var_215_15 = var_215_17.crehunt.score
				var_215_16 = var_215_17.crehunt.energy
			end
			
			local var_215_18 = var_215_14:getChildByName("n_accrue")
			
			if get_cocos_refid(var_215_18) then
				if_set(var_215_18, "txt_title", T("ui_crevicehunt_season_score_result"))
				
				local var_215_19 = DungeonCreviceUtil:getExploitPoint()
				local var_215_20 = DungeonCreviceUtil:getDiffExploitPoint()
				local var_215_21 = GAME_CONTENT_VARIABLE.crevicehunt_season_score_max or 2000
				local var_215_22 = var_215_21 <= var_215_19
				
				if_set_visible(var_215_18, "count_cp", not var_215_22)
				if_set_add_position_x(var_215_18, "count_cp", var_215_20 <= 0 and 15 or 0)
				if_set_visible(var_215_18, "stat_up", not var_215_22)
				if_set_visible(var_215_18, "_contr_bonus_pet", var_215_15)
				if_set_visible(var_215_18, "count_cp_max", var_215_22)
				
				if var_215_19 < var_215_21 then
					if_set(var_215_18, "count_cp", var_215_19)
					if_set(var_215_18, "txt_stat_up", var_215_20)
					if_set_visible(var_215_18, "stat_up", var_215_20 > 0)
				end
			end
			
			local var_215_23 = var_215_14:getChildByName("n_runestone")
			
			if get_cocos_refid(var_215_23) then
				local var_215_24 = DungeonCreviceUtil:getRuneExp()
				local var_215_25 = DungeonCreviceUtil:getLevelInfoByExp(var_215_24)
				local var_215_26 = DungeonCreviceUtil:getPreRuneExp()
				local var_215_27 = DungeonCreviceUtil:getLevelInfoByExp(var_215_26)
				local var_215_28 = GAME_CONTENT_VARIABLE.crevicehunt_runstone_maxlv or 21
				
				UIUtil:setLevel(var_215_23:getChildByName("n_lv"), var_215_27, var_215_28, 2, false, nil, 18)
				
				local var_215_29 = var_215_28 <= var_215_27
				
				if_set_visible(var_215_23, "txt_exp_result", not var_215_29)
				if_set_visible(var_215_23, "_contr_bonus_pet", var_215_16)
				if_set_visible(var_215_23, "gauge_white", not var_215_29)
				if_set_visible(var_215_23, "gauge", not var_215_29)
				if_set_visible(var_215_23, "gauge_max", var_215_29)
				if_set_color(var_215_23, "gauge_max", tocolor("#6BC11B"))
				
				if not var_215_29 then
					local var_215_30, var_215_31 = DungeonCreviceUtil:getLevelUpInfoByExp(var_215_24)
					local var_215_32, var_215_33 = DungeonCreviceUtil:getLevelUpInfoByExp(var_215_26)
					local var_215_34 = DungeonCreviceUtil:getDiffRuneExp()
					
					if_set_percent(var_215_23, "gauge", var_215_33 / var_215_32)
					if_set_percent(var_215_23, "gauge_white", var_215_33 / var_215_32)
					
					local var_215_35 = 1000
					local var_215_36 = {}
					
					if var_215_27 ~= var_215_25 then
						if_set(var_215_23, "t_percent", tostring(var_215_33) .. "/" .. tostring(var_215_32))
						
						local var_215_37 = {}
						local var_215_38 = true
						
						for iter_215_5 = var_215_27, var_215_25 do
							if DungeonCreviceUtil:checkLevelUP(iter_215_5, var_215_24) then
								table.insert(var_215_37, {
									to = 1,
									level = iter_215_5,
									from = var_215_33 / var_215_32
								})
							elseif iter_215_5 < var_215_28 then
								table.insert(var_215_37, {
									from = 0,
									level = iter_215_5,
									to = var_215_31 / var_215_30
								})
							end
						end
						
						local var_215_39 = var_215_25 - var_215_27
						
						if var_215_25 < var_215_28 then
							var_215_39 = var_215_39 + 1
						end
						
						local var_215_40 = var_215_35 / math.pow(var_215_39, 2)
						local var_215_41 = (var_215_35 * 2 / var_215_39 - var_215_40 * (var_215_39 - 1)) / 2
						
						for iter_215_6, iter_215_7 in pairs(var_215_37) do
							table.insert(var_215_36, PROGRESS(var_215_41 + var_215_40 * (iter_215_6 - 1), iter_215_7.from, iter_215_7.to))
							
							if iter_215_7.level and iter_215_7.to >= 1 then
								table.insert(var_215_36, CALL(function()
									local var_219_0 = iter_215_7.level + 1
									
									UIUtil:setLevel(var_215_23:getChildByName("n_lv"), var_219_0, var_215_28, 2, false, nil, 18)
									if_set_visible(var_215_23, "gauge", false)
									
									local var_219_1 = "Max"
									local var_219_2, var_219_3 = DungeonCreviceUtil:getCurrentLevelInfo(var_219_0, var_215_24)
									
									if var_219_2 and var_219_3 then
										var_219_1 = tostring(var_219_3) .. "/" .. tostring(var_219_2)
									else
										if_set_visible(var_215_23, "gauge_max", true)
									end
									
									if_set(var_215_23, "t_percent", var_219_1)
								end))
							end
						end
					else
						if_set(var_215_23, "t_percent", tostring(var_215_31) .. "/" .. tostring(var_215_30))
						table.insert(var_215_36, PROGRESS(var_215_35, var_215_33 / var_215_30, var_215_31 / var_215_30))
					end
					
					local var_215_42 = var_215_23:getChildByName("gauge_white")
					
					UIAction:Add(SEQ_LIST(var_215_36), var_215_42, "block")
					if_set(var_215_23, "txt_exp_result", var_215_34)
					if_set_visible(var_215_23, "txt_exp_result", var_215_34 > 0)
				else
					if_set(var_215_23, "t_percent", "Max")
				end
			end
		end
	end
end

function ClearResult.setCrehuntBoss_ui(arg_220_0)
	if not arg_220_0.vars or not get_cocos_refid(arg_220_0.childs.n_reward) then
		return 
	end
	
	local var_220_0 = getChildByPath(arg_220_0.childs.n_reward, "n_crevice")
	
	if get_cocos_refid(var_220_0) then
		local var_220_1 = var_220_0:getChildByName("n_boss_hp")
		
		if get_cocos_refid(var_220_1) then
			local var_220_2 = Account:getCrehuntDifficultyByEnterID(arg_220_0.vars.result.map_id)
			local var_220_3 = DungeonCreviceUtil:getBossInfo(var_220_2)
			
			if not table.empty(var_220_3) then
				local var_220_4 = load_control("wnd/result_boss_hp.csb")
				
				var_220_1:addChild(var_220_4)
				
				local var_220_5 = DungeonCreviceUtil:getBossFuPath(var_220_3.boss_code)
				
				if_set_sprite(var_220_4, "n_fu", var_220_5)
				
				local var_220_6 = 1
				
				if var_220_3.last_hp and var_220_3.max_hp and var_220_3.max_hp ~= 0 then
					var_220_6 = var_220_3.last_hp / var_220_3.max_hp
				end
				
				local var_220_7 = 1
				local var_220_8 = DungeonCreviceUtil:getPreBossLastHp(var_220_2)
				
				if var_220_8 and var_220_3.max_hp and var_220_3.max_hp ~= 0 then
					var_220_7 = var_220_8 / var_220_3.max_hp
				end
				
				local var_220_9 = 1000
				local var_220_10 = var_220_1:getChildByName("progress_hp")
				
				if get_cocos_refid(var_220_10) then
					if_set_percent(var_220_10, nil, var_220_7)
					UIAction:Add(PROGRESS(var_220_9, var_220_7, var_220_6), var_220_10, "block")
				end
				
				local var_220_11 = var_220_1:getChildByName("txt_hp")
				
				if get_cocos_refid(var_220_11) then
					if_set(var_220_11, nil, tostring(var_220_7 * 100) .. "%")
					UIAction:Add(INC_NUMBER(var_220_9, var_220_6 * 100, "%", var_220_7 * 100), var_220_11, "block")
				end
				
				local var_220_12 = GAME_CONTENT_VARIABLE.crevicehunt_maxtrycount or 5
				local var_220_13 = var_220_3.enter_count or 0
				local var_220_14 = arg_220_0.childs.n_reward:getChildByName("RIGHT")
				
				if get_cocos_refid(var_220_14) then
					local var_220_15 = var_220_14:getChildByName("btn_next")
					
					if get_cocos_refid(var_220_15) then
						var_220_15:setVisible(var_220_13 < var_220_12)
						
						if var_220_15:isVisible() then
							local var_220_16 = arg_220_0.vars.result.map_id
							
							UIUtil:setButtonEnterInfo(var_220_15, var_220_16, {
								use_icon_res = true
							})
							if_set_visible(var_220_14, "n_bar", false)
						end
					end
				end
				
				if var_220_3.last_hp <= 0 and var_220_3.state == 2 then
					local var_220_17 = var_220_4:getChildByName("n_fu")
					local var_220_18 = cc.GLProgramCache:getInstance():getGLProgram("sprite_grayscale")
					
					if var_220_18 then
						local var_220_19 = cc.GLProgramState:create(var_220_18)
						
						if var_220_19 then
							var_220_19:setUniformFloat("u_ratio", 1)
							var_220_17:setDefaultGLProgramState(var_220_19)
							var_220_17:setGLProgramState(var_220_19)
						end
					end
					
					if_set_color(var_220_17, nil, tocolor("#888888"))
					
					local var_220_20 = var_220_4:getChildByName("n_eff")
					
					if get_cocos_refid(var_220_20) then
						var_220_20:setVisible(true)
						
						local var_220_21 = 500
						local var_220_22 = 20
						
						local function var_220_23()
							UIAction:Add(SPAWN(SCALE(10 * var_220_22, 0.7, 1), OPACITY(10 * var_220_22, 0, 1)), var_220_20:getChildByName("crevice_eff_g"))
						end
						
						local function var_220_24()
							UIAction:Add(OPACITY(5 * var_220_22, 0, 1), var_220_20:getChildByName("crevice_eff_b"))
						end
						
						local function var_220_25()
							UIAction:Add(SEQ(SPAWN(SCALE(10 * var_220_22, 3, 1), OPACITY(10 * var_220_22, 0, 1)), OPACITY(10 * var_220_22, 1, 0.4), OPACITY(45 * var_220_22, 0.4, 0)), var_220_20:getChildByName("crevice_eff_b_l"))
						end
						
						local function var_220_26()
							local var_224_0 = var_220_20:getChildByName("n_c")
							
							UIAction:Add(LOG(MOVE_BY_SMOOTH(40 * var_220_22, nil, -6)), var_224_0)
						end
						
						local function var_220_27()
							UIAction:Add(OPACITY(30 * var_220_22, 0, 1), var_220_20:getChildByName("crevice_eff_c"))
						end
						
						local function var_220_28()
							UIAction:Add(SEQ(SPAWN(SCALE(30 * var_220_22, 1, 1.03), OPACITY(30 * var_220_22, 0, 1)), SPAWN(SCALE(35 * var_220_22, 1.03, 1), OPACITY(35 * var_220_22, 1, 0))), var_220_20:getChildByName("crevice_eff_c_l"))
						end
						
						local function var_220_29()
							local var_227_0 = var_220_20:getChildByName("n_r")
							
							UIAction:Add(LOG(MOVE_BY_SMOOTH(40 * var_220_22, -5, nil)), var_227_0)
						end
						
						local function var_220_30()
							UIAction:Add(OPACITY(20 * var_220_22, 0, 1), var_220_20:getChildByName("crevice_eff_r"))
						end
						
						local function var_220_31()
							UIAction:Add(SEQ(OPACITY(20 * var_220_22, 0, 1), OPACITY(45 * var_220_22, 1, 0)), var_220_20:getChildByName("crevice_eff_r_l"))
						end
						
						local function var_220_32()
							local var_230_0 = var_220_20:getChildByName("n_l")
							
							UIAction:Add(LOG(MOVE_BY_SMOOTH(40 * var_220_22, 5, nil)), var_230_0)
						end
						
						local function var_220_33()
							UIAction:Add(OPACITY(20 * var_220_22, 0, 1), var_220_20:getChildByName("crevice_eff_l"))
						end
						
						local function var_220_34()
							UIAction:Add(SEQ(OPACITY(20 * var_220_22, 0, 1), OPACITY(45 * var_220_22, 1, 0)), var_220_20:getChildByName("crevice_eff_l_l"))
						end
						
						local function var_220_35()
							UIAction:Add(SPAWN(SEQ(SCALE(5 * var_220_22, 0.8, 1), SCALE(5 * var_220_22, 1, 1.6667), SCALE(25 * var_220_22, 1.6667, 5)), SEQ(OPACITY(5 * var_220_22, 0, 1), OPACITY(5 * var_220_22, 1, 0.25), OPACITY(25 * var_220_22, 0.25, 0))), var_220_20:getChildByName("crevice_eff_all_l"))
						end
						
						local function var_220_36()
							UIAction:Add(SPAWN(SEQ(SPAWN(SCALE_TO_X(25 * var_220_22, 0.5054), SCALE_TO_Y(25 * var_220_22, 2.21)), SPAWN(SCALE_TO_X(15 * var_220_22, 1.585), SCALE_TO_Y(15 * var_220_22, 3.17)), SPAWN(SCALE_TO_X(20 * var_220_22, 1.6), SCALE_TO_Y(20 * var_220_22, 3.2))), SEQ(OPACITY(25 * var_220_22, 0, 0.5), OPACITY(15 * var_220_22, 0.5, 0))), var_220_20:getChildByName("crevice_eff"))
						end
						
						UIAction:Add(SEQ(DELAY(var_220_9 + var_220_21), SPAWN(CALL(function()
							SoundEngine:play("event:/ui/ui_crevicehunt_kill")
							var_220_23()
							var_220_26()
							var_220_29()
							var_220_30()
							var_220_31()
							var_220_32()
							var_220_33()
							var_220_34()
						end), SEQ(DELAY(35 * var_220_22), CALL(function()
							var_220_24()
						end)), SEQ(DELAY(25 * var_220_22), CALL(function()
							var_220_25()
							var_220_35()
						end)), SEQ(DELAY(10 * var_220_22), CALL(function()
							var_220_27()
							var_220_28()
						end)), SEQ(DELAY(5 * var_220_22), CALL(function()
							var_220_36()
						end)))), var_220_20, "block")
					end
				end
			end
		end
	end
end

function ClearResult.setPenguin_ui(arg_240_0)
	local var_240_0 = arg_240_0.childs.n_reward:getChildByName("n_penguin")
	local var_240_1 = arg_240_0.vars.result.penguin_mileage
	local var_240_2 = var_240_0:getChildByName("n_eff")
	
	if get_cocos_refid(var_240_0) and get_cocos_refid(var_240_2) then
		var_240_0:setVisible(true)
		
		local var_240_3 = GAME_CONTENT_VARIABLE.get_mileage_per_stigma or 45
		local var_240_4 = var_240_1.penguin_mileage or 0
		local var_240_5 = var_240_1.add_mileage or 0
		local var_240_6 = var_240_4 % var_240_3 / var_240_3 * 100
		local var_240_7 = (var_240_4 - var_240_5) % var_240_3 / var_240_3 * 100
		local var_240_8 = var_240_4 / var_240_3 >= 1
		
		if var_240_6 < var_240_7 then
			var_240_8 = true
		end
		
		if_set_percent(var_240_0:getChildByName("n_exp"), "gauge", var_240_8 and 0 or var_240_7 / 100)
		if_set_percent(var_240_0:getChildByName("n_exp"), "gauge_white", var_240_6 / 100)
		if_set(var_240_0, "t_percent", string.format("%0.1f%%", var_240_6))
		if_set(var_240_0, "txt_exp_result", var_240_5)
		
		if arg_240_0.vars.result.penguin_mileage.rewards and arg_240_0.vars.result.penguin_mileage.rewards.new_items then
			for iter_240_0, iter_240_1 in pairs(arg_240_0.vars.result.penguin_mileage.rewards.new_items) do
				local var_240_9 = iter_240_1.code
				local var_240_10 = iter_240_1.diff
				
				Dialog:ShowRareDrop({
					code = var_240_9,
					count = var_240_10
				})
			end
			
			EffectManager:Play({
				fn = "ui_result_base_penguin_comlpete.cfx",
				layer = var_240_2
			})
		else
			EffectManager:Play({
				fn = "ui_result_base_penguin.cfx",
				layer = var_240_2
			})
		end
	end
end

function ClearResult.addPopupFavLevelUp(arg_241_0, arg_241_1, arg_241_2, arg_241_3, arg_241_4, arg_241_5)
	arg_241_5 = arg_241_5 or {}
	
	if BattleRepeat:isPlayingRepeatPlay() then
		Dialog:close("result_intimacy")
	end
	
	local var_241_0 = (arg_241_5.units_favexp or arg_241_0.vars.result.units_favexp)[arg_241_1.db.code]
	
	if not var_241_0 then
		return 
	end
	
	local var_241_1 = SceneManager:getRunningNativeScene()
	local var_241_2 = Dialog:open("wnd/result_intimacy", arg_241_0)
	local var_241_3 = 0
	local var_241_4 = DB("character", arg_241_1:getDisplayCode(), "face_id")
	local var_241_5, var_241_6 = DB("character", arg_241_1:getDisplayCode(), {
		"emotion_id",
		"grade"
	})
	local var_241_7 = 0
	local var_241_8 = 0
	
	for iter_241_0 = var_241_0.prev_lv + 1, var_241_0.curr_lv do
		local var_241_9, var_241_10, var_241_11 = DB("character_intimacy_level", var_241_5 .. "_" .. iter_241_0, {
			"emotion",
			"voice_id",
			"lock"
		})
		
		if var_241_9 and string.starts(var_241_9, "special") then
			var_241_3 = var_241_3 + 1
		end
		
		if var_241_9 then
			var_241_7 = var_241_7 + 1
		end
		
		if var_241_10 and not var_241_11 then
			var_241_8 = var_241_8 + 1
		end
	end
	
	local var_241_12 = {}
	
	if var_241_7 > 0 then
		var_241_12.face = true
	end
	
	if var_241_8 > 0 then
		var_241_12.voice = true
	end
	
	if UnitInfosUtil:isExistUnitProfileUnlock(arg_241_1, "intimacy", {
		pre_fav = var_241_0.prev_lv
	}) then
		var_241_12.profile = true
	end
	
	local var_241_13 = table.count(var_241_12 or {})
	local var_241_14 = var_241_13 >= 1
	local var_241_15 = arg_241_5.cur_exp and arg_241_5.cur_exp and arg_241_5.units_favexp and arg_241_5.units_favexp[arg_241_1.db.code].curr_lv > arg_241_5.units_favexp[arg_241_1.db.code].prev_lv
	local var_241_16 = table.count(arg_241_5) == 0
	
	if not var_241_15 and var_241_16 then
		var_241_15 = true
	end
	
	if var_241_15 and not var_241_14 and var_241_0.curr_lv < 10 then
		var_241_2:getChildByName("CENTER"):removeFromParent()
		if_set_visible(var_241_2, "CENTER_small", true)
		if_set_arrow(var_241_2:getChildByName("CENTER_small"))
	else
		if_set_arrow(var_241_2:getChildByName("CENTER"))
	end
	
	local var_241_17 = {}
	
	table.insert(var_241_17, {
		wnd = var_241_2:getChildByName("n_love_before"),
		fav_lv = var_241_0.prev_lv,
		fav_exp = var_241_0.prev_exp
	})
	table.insert(var_241_17, {
		wnd = var_241_2:getChildByName("n_love_after"),
		fav_lv = var_241_0.curr_lv,
		fav_exp = var_241_0.curr_exp
	})
	var_241_2:setOpacity(0)
	var_241_2:setLocalZOrder(99999)
	var_241_1:addChild(var_241_2)
	
	if arg_241_5.units_favexp then
		var_241_2:bringToFront()
	end
	
	local var_241_18 = var_241_2:getChildByName("n_portrait")
	
	if var_241_4 then
		local var_241_19, var_241_20 = UIUtil:getPortraitAni(var_241_4, {
			parent_pos_y = var_241_18:getPositionY()
		})
		
		if var_241_19 then
			var_241_18:removeAllChildren()
			var_241_18:addChild(var_241_19)
			
			if not var_241_20 then
				var_241_19:setAnchorPoint(0.5, 0.15)
			end
			
			var_241_19:setScale(0.8)
		end
	end
	
	for iter_241_1, iter_241_2 in pairs(var_241_17) do
		local var_241_21 = iter_241_2.wnd
		local var_241_22 = iter_241_2.fav_lv
		local var_241_23 = iter_241_2.fav_exp
		
		if_set(var_241_21, "t_lv", var_241_22)
		
		if not var_241_22 then
			Log.e("ClearResult.addPopupFavLevelUp", "nil_fav_lv." .. arg_241_1.db.code)
		end
		
		if_set(var_241_21, "t_disc", T("inttl_" .. var_241_22))
		
		local var_241_24 = string.format("img/hero_love_icon_%d.png", var_241_22 > 7 and 3 or var_241_22 > 4 and 2 or 1)
		
		if_set_sprite(var_241_21, "hero_love_icon", var_241_24)
		
		local var_241_25 = var_241_21:getChildByName("progress")
		local var_241_26 = WidgetUtils:createCircleProgress("img/hero_love_progress.png")
		
		var_241_26:setScale(var_241_25:getScale())
		var_241_26:setOpacity(var_241_25:getOpacity())
		var_241_25:setVisible(false)
		var_241_26:setReverseDirection(false)
		var_241_26:setPercentage(var_241_23 * 100)
		var_241_26:setName("@progress")
		var_241_21:addChild(var_241_26)
	end
	
	if not var_241_5 then
		Log.e("ClearResult.addPopupFavLevelUp", "nil_emotion_id." .. arg_241_1.db.code)
	end
	
	if not var_241_0.curr_lv then
		Log.e("ClearResult.addPopupFavLevelUp", "nil_fav_info.curr_lv." .. arg_241_1.db.code)
	end
	
	local var_241_27 = var_241_2:getChildByName("n_unlock_con")
	
	if var_241_0.curr_lv > var_241_0.prev_lv and get_cocos_refid(var_241_27) and var_241_14 then
		if var_241_13 >= 2 then
			local var_241_28 = var_241_2:getChildByName("n_unlock_con_move" .. var_241_13)
			
			if get_cocos_refid(var_241_28) then
				var_241_27:setPosition(var_241_28:getPosition())
			end
		end
		
		local var_241_29 = {}
		
		for iter_241_3 = 1, 3 do
			local var_241_30 = var_241_27:getChildByName("n_" .. iter_241_3)
			
			if get_cocos_refid(var_241_30) then
				var_241_30:setVisible(false)
				
				var_241_30.origin_pos_x = var_241_30:getPositionX()
				var_241_30.origin_pos_y = var_241_30:getPositionY()
				
				table.insert(var_241_29, var_241_30)
			end
		end
		
		local var_241_31 = {
			"face",
			"voice",
			"profile"
		}
		local var_241_32 = 0
		
		if not table.empty(var_241_29) and not table.empty(var_241_12) then
			for iter_241_4, iter_241_5 in pairs(var_241_29) do
				if get_cocos_refid(iter_241_5) and var_241_31[iter_241_4] then
					local var_241_33 = var_241_12[var_241_31[iter_241_4]]
					
					iter_241_5:setVisible(var_241_33)
					
					iter_241_5.is_can_change = not var_241_33
					
					if var_241_33 then
						if iter_241_4 >= 2 then
							local var_241_34 = iter_241_4 - 1
							
							for iter_241_6 = 1, var_241_34 do
								local var_241_35 = var_241_29[iter_241_6]
								
								if get_cocos_refid(var_241_35) and var_241_35.is_can_change then
									iter_241_5.is_can_change = not iter_241_5.is_can_change
									
									iter_241_5:setPosition(var_241_35.origin_pos_x or var_241_35:getPositionX(), var_241_35.origin_pos_y or var_241_35:getPositionY())
									
									var_241_35.is_can_change = false
									
									break
								end
							end
						end
						
						local var_241_36 = 0
						
						if var_241_31[iter_241_4] == "face" then
							var_241_36 = var_241_7
							
							if var_241_7 >= 4 then
								var_241_32 = var_241_7 - 2
							end
						elseif var_241_31[iter_241_4] == "voice" then
							var_241_36 = var_241_8
						end
						
						if var_241_36 == 2 then
							local var_241_37 = iter_241_5:getChildByName("n_icon")
							local var_241_38 = iter_241_5:getChildByName("n_icon_even_move")
							
							if get_cocos_refid(var_241_37) and get_cocos_refid(var_241_38) then
								var_241_37:setPosition(var_241_38:getPosition())
							end
						end
					end
				end
			end
			
			local var_241_39 = 0
			local var_241_40 = 0
			local var_241_41 = 0
			
			for iter_241_7 = var_241_0.prev_lv + 1, var_241_0.curr_lv do
				local var_241_42, var_241_43, var_241_44 = DB("character_intimacy_level", var_241_5 .. "_" .. iter_241_7, {
					"emotion",
					"voice_id",
					"lock"
				})
				
				if var_241_42 then
					if string.starts(var_241_42, "special") and var_241_3 > 1 then
						var_241_41 = var_241_41 + 1
						var_241_42 = "special" .. var_241_41
					end
					
					if var_241_7 == 1 then
						if_set_sprite(var_241_29[1], "icon_expression2", "img/cm_icon_face_" .. var_241_42 .. ".png")
						if_set_visible(var_241_29[1], "icon_expression2", true)
					else
						var_241_39 = var_241_39 + 1
						
						local var_241_45 = 3
						
						if var_241_32 > 0 then
							if_set(var_241_29[1], "t_count_add", "+" .. tostring(var_241_32))
							
							var_241_45 = 2
						end
						
						if var_241_39 <= var_241_45 then
							if_set_sprite(var_241_29[1], "icon_expression" .. var_241_39, "img/cm_icon_face_" .. var_241_42 .. ".png")
							if_set_visible(var_241_29[1], "icon_expression" .. var_241_39, true)
						end
					end
				end
				
				if var_241_43 and not var_241_44 then
					if var_241_43 == "camping" then
						var_241_43 = "campingtalk"
					end
					
					if var_241_8 == 1 then
						if_set_sprite(var_241_29[2], "icon_voice2", "img/cm_icon_etc" .. var_241_43 .. ".png")
						if_set_visible(var_241_29[2], "icon_voice2", true)
					else
						var_241_40 = var_241_40 + 1
						
						if_set_sprite(var_241_29[2], "icon_voice" .. var_241_40, "img/cm_icon_etc" .. var_241_43 .. ".png")
						if_set_visible(var_241_29[2], "icon_voice" .. var_241_40, true)
					end
				end
			end
			
			if_set_visible(var_241_2, "txt_desc_bottom", false)
			if_set_visible(var_241_2, "n_fav_pivot", false)
		end
	end
	
	local var_241_46 = var_241_0.curr_lv and var_241_0.curr_lv >= 10 and var_241_6 > 3 or arg_241_5.force
	local var_241_47 = var_241_2:getChildByName("n_intimacy10")
	
	if arg_241_1.db.code == "c3026" then
		var_241_46 = false
	end
	
	if var_241_46 then
		local var_241_48 = var_241_2:getChildByName("n_center")
		local var_241_49, var_241_50 = var_241_2:getChildByName("n_center_move"):getPosition()
		
		var_241_48:setPosition(var_241_49, var_241_50)
		if_set_sprite(var_241_47, "item", "item/ma_skillpoint.png")
		if_set(var_241_47, "t_count", "3")
		if_set_visible(var_241_47, "item", true)
		if_set_visible(var_241_47, "t_count", true)
		var_241_2:getChildByName("n_unlock"):setPositionY(var_241_2:getChildByName("n_unlock_move"):getPositionY())
	end
	
	local var_241_51 = var_241_2:getChildByName("n_effect")
	
	if not var_241_46 and get_cocos_refid(var_241_51) then
		var_241_51:setPositionY(var_241_2:getChildByName("n_fav_pivot"):getPositionY())
	end
	
	var_241_2.isPVP = arg_241_3 or false
	var_241_2.isLast = arg_241_4 or false
	var_241_2.isIntimacyPresent = arg_241_5
	
	UIAction:Add(SEQ(DELAY(arg_241_2 and 900 or 0), FADE_IN(300), CALL(function()
		if get_cocos_refid(var_241_51) then
			EffectManager:Play({
				fn = "ui_intimacy_eff.cfx",
				layer = var_241_51
			})
		end
	end), DELAY(200), CALL(function()
		if_set_visible(var_241_2, "n_fav_pivot", true)
	end), DELAY(200)), var_241_2, "block")
	
	if var_241_46 then
		UIAction:Add(SEQ(DELAY(arg_241_2 and 900 or 0), DELAY(500), FADE_IN(300), DELAY(200)), var_241_47, "block")
	end
end

function ClearResult.playUnitWinVoc(arg_244_0)
	if not arg_244_0.vars then
		return 
	end
	
	if not arg_244_0.vars.result then
		return 
	end
	
	local var_244_0 = {}
	
	for iter_244_0, iter_244_1 in pairs(arg_244_0.vars.result.friends or {}) do
		if not iter_244_1:isDead() then
			if not iter_244_1.db.model_id then
				Log.e("ClearResult.playUnitWinVoc", "nil_v.db.model_id." .. iter_244_1.db.code)
			end
			
			local var_244_1 = "event:/voc/character/" .. iter_244_1.db.model_id .. "/evt/win"
			
			table.insert(var_244_0, var_244_1)
		end
	end
	
	if #var_244_0 > 0 then
		local var_244_2 = table.shuffle(var_244_0)[1]
		
		SoundEngine:play(var_244_2)
	end
end

function ClearResult.playNextDungeonSound(arg_245_0)
	local var_245_0 = DB("level_enter", arg_245_0.vars.result.map_id, "type")
	
	if arg_245_0:getNextDungeon() and not string.starts(var_245_0 or "", "dungeon") then
		SoundEngine:playAmbient("event:/effect/next_dungeon_loop", SoundEngine.AMB_MUSIC_TRACK_1)
	end
end

function ClearResult.revertDungeon(arg_246_0)
	local var_246_0 = load_dlg("result_revert_p", true, "wnd")
	
	if not get_cocos_refid(var_246_0) then
		return false
	end
	
	local var_246_1 = Battle.logic.map.retry_count
	local var_246_2 = GAME_STATIC_VARIABLE.retry_crystal_cost or 10
	local var_246_3 = var_246_1 < 1
	local var_246_4 = var_246_3 and T("pop_dungeon_retry_desc_free") or T("pop_dungeon_retry_desc")
	
	if_set(var_246_0, "txt_title", T("pop_dungeon_retry_title"))
	if_set(var_246_0, "txt_disc", var_246_4)
	if_set(var_246_0, "txt_info", T("it_count", {
		count = comma_value(Account:getCurrency("crystal"))
	}))
	if_set(var_246_0, "txt_type", T("item_category_gold"))
	if_set(var_246_0, "txt_name", T("crystal_name"))
	if_set(var_246_0, "label_0", var_246_3 and T("shop_price_free") or comma_value(var_246_2))
	Dialog:msgBox(var_246_4, {
		yesno = true,
		dlg = var_246_0,
		handler = function(arg_247_0, arg_247_1)
			if arg_247_1 == "btn_yes" then
				if not var_246_3 and Account:getCurrency("crystal") < var_246_2 then
					balloon_message_with_sound("need_token")
					
					return 
				end
				
				query("retry_battle", {
					battle_uid = Battle.logic:getBattleUID()
				})
			end
		end
	})
end

function ClearResult.stopNextDungeonSound(arg_248_0)
	SoundEngine:stopAmbient(SoundEngine.AMB_MUSIC_TRACK_1)
end

function ClearResult.addPopupClearQuest(arg_249_0)
	if BattleRepeat:isPlayingRepeatPlay() and not arg_249_0.vars.result.expedition_ticket then
		Dialog:closeAll()
	end
	
	if arg_249_0.vars.result.quest and #arg_249_0.vars.result.quest > 0 then
		local var_249_0 = arg_249_0.vars.wnd
		
		for iter_249_0, iter_249_1 in pairs(arg_249_0.vars.result.quest) do
			if iter_249_1.contents_id then
				local var_249_1 = load_dlg("map_quest_fin", true, "wnd")
				
				var_249_1:setName("map_quest_fin")
				var_249_1:setOpacity(0)
				var_249_0:addChild(var_249_1)
				BackButtonManager:push({
					check_id = "ClearResult",
					back_func = function()
						ClearResult.mapQuestFinOK()
					end
				})
				UIAction:Add(SEQ(FADE_IN(300), DELAY(400)), var_249_1, "block")
				if_set_arrow(var_249_1)
				
				local var_249_2 = ConditionContentsManager:getQuestMissions()
				local var_249_3 = {}
				local var_249_4, var_249_5, var_249_6, var_249_7, var_249_8, var_249_9, var_249_10, var_249_11 = DB("mission_data", iter_249_1.contents_id, {
					"name",
					"desc",
					"icon",
					"condition_value",
					"reward_id1",
					"reward_count1",
					"grade_rate1",
					"set_drop_rate_id1"
				})
				
				var_249_3.quest_id = iter_249_1.contents_id
				var_249_3.db_name = var_249_4
				var_249_3.db_desc = var_249_5
				var_249_3.face_icon = var_249_6
				var_249_3.condition_value = var_249_7
				var_249_3.reward_id = var_249_8
				var_249_3.reward_count = var_249_9
				var_249_3.grade_rate = var_249_10
				var_249_3.set_drop_id = var_249_11
				
				local var_249_12 = {}
				local var_249_13 = var_249_2:getChapterMissionIdInDB(iter_249_1.contents_id)
				local var_249_14 = var_249_13.mission_id
				local var_249_15 = var_249_13.key_mission
				local var_249_16, var_249_17 = DB("mission_data", var_249_14, {
					"name",
					"name2"
				})
				
				var_249_12.chapter_id = var_249_14
				var_249_12.key_mission = var_249_15
				var_249_12.chapter_name = var_249_16
				var_249_12.chapter_desc = var_249_17
				
				var_249_2:setUIQuest(var_249_1, var_249_3, {
					reward_scale = 0.8
				})
				var_249_2:setUIChapter(var_249_1, var_249_12, {
					gauge_action = true
				})
			end
		end
	elseif arg_249_0.vars.result.substory_quest and #arg_249_0.vars.result.substory_quest > 0 then
		local var_249_18 = arg_249_0.vars.wnd
		
		for iter_249_2, iter_249_3 in pairs(arg_249_0.vars.result.substory_quest) do
			if iter_249_3.contents_id then
				local var_249_19 = load_dlg("map_quest_fin", true, "wnd")
				
				var_249_19:setName("map_quest_fin")
				var_249_19:setOpacity(0)
				var_249_18:addChild(var_249_19)
				BackButtonManager:push({
					check_id = "ClearResult",
					back_func = function()
						ClearResult.mapQuestFinOK()
					end
				})
				if_set(var_249_19, "txt_disc", T("ui_map_substory_quest_fin_desc"))
				UIAction:Add(SEQ(FADE_IN(300), DELAY(400)), var_249_19, "block")
				if_set_arrow(var_249_19)
				
				local var_249_20 = ConditionContentsManager:getSubStoryQuest()
				local var_249_21 = SubstoryManager:getSubStoryQuestData(arg_249_0.vars.result.substory_id, iter_249_3.contents_id)
				local var_249_22 = {}
				local var_249_23, var_249_24, var_249_25, var_249_26, var_249_27, var_249_28, var_249_29, var_249_30 = DB("mission_data", iter_249_3.contents_id, {
					"name",
					"desc",
					"icon",
					"condition_value",
					"reward_id1",
					"reward_count1",
					"grade_rate1",
					"set_drop_rate_id1"
				})
				
				var_249_22.quest_id = iter_249_3.contents_id
				var_249_22.db_name = var_249_21.name
				var_249_22.db_desc = var_249_21.desc
				var_249_22.face_icon = var_249_21.icon
				var_249_22.condition_value = var_249_21.condition_value
				var_249_22.reward_id = var_249_21.reward_id1
				var_249_22.reward_count = var_249_21.reward_count1
				var_249_22.grade_rate = var_249_21.grade_rate1
				var_249_22.set_drop_id = var_249_21.set_drop_rate_id1
				
				local var_249_31 = {}
				local var_249_32, var_249_33 = DB("substory_main", arg_249_0.vars.result.substory_id, {
					"name",
					"name2"
				})
				
				var_249_31.chapter_name = var_249_32
				var_249_31.chapter_desc = var_249_33
				
				var_249_20:setUIQuest(var_249_19, var_249_22, {
					reward_scale = 0.8
				})
				var_249_20:setUIChapter(var_249_19, var_249_31, {
					gauge_action = true
				})
			end
		end
	else
		arg_249_0:nextSeq()
	end
end

function ClearResult.addAppearUrgentMission(arg_252_0)
	local var_252_0
	
	if arg_252_0.vars.result.apper_missions and #arg_252_0.vars.result.apper_missions > 0 then
		var_252_0 = arg_252_0.vars.wnd
		
		for iter_252_0, iter_252_1 in pairs(arg_252_0.vars.result.apper_missions) do
			for iter_252_2, iter_252_3 in pairs(iter_252_1) do
				ConditionContentsManager:getUrgentMissions():showNoti(var_252_0, iter_252_2)
				
				break
			end
		end
	end
end

function ClearResult.addNewBooster(arg_253_0)
	if Booster:hasNewBooster() then
		BoosterUI:show()
	else
		arg_253_0:nextSeq()
	end
end

function ClearResult.btnGoUnlockInfoDialog(arg_254_0, arg_254_1)
	arg_254_0.vars.wnd:removeChildByName("unlock_system_open")
	arg_254_0:playNextDungeonSound()
	
	if not arg_254_1 then
		return 
	end
	
	if arg_254_1 == UNLOCK_ID.SINSU then
		local var_254_0 = Account:getSummonByCode("s0001")
		local var_254_1 = Account:getCurrentTeamIndex()
		
		if var_254_0 and var_254_1 then
			Account:addToTeam(var_254_0, var_254_1, 5, true)
		end
		
		return 
	end
	
	local function var_254_2()
		if arg_254_1 == UNLOCK_ID.DESTINY then
			HeroGet:open({
				code = "c1018",
				callback_ok_btn = function()
					SceneManager:nextScene("lobby")
					SceneManager:resetSceneFlow()
				end
			})
			
			return 
		end
		
		if arg_254_0:moveTutorial(arg_254_1) then
			return 
		end
		
		if arg_254_0.vars.result.pvp_result then
			arg_254_0:moveToPvpScene()
			
			return 
		end
	end
	
	local var_254_3 = DB("system_achievement_effect", arg_254_1, {
		"effect_after_story"
	})
	
	if var_254_3 then
		start_new_story(SceneManager:getDefaultLayer(), var_254_3, {
			force = true,
			on_finish = function()
				var_254_2()
			end
		})
	else
		var_254_2()
	end
end

function ClearResult.popupUnlockInfoDialog(arg_258_0, arg_258_1)
	local var_258_0, var_258_1, var_258_2, var_258_3 = DB("system_achievement_effect", arg_258_1, {
		"id",
		"effect_title",
		"effect_desc",
		"effect_icon"
	})
	
	if not var_258_0 or not var_258_2 or not var_258_3 then
		return false
	end
	
	local var_258_4 = UIUtil:popupUnlockInfoDialog(arg_258_0.vars.wnd, var_258_1, var_258_2, var_258_3)
	
	if var_258_4 then
		local var_258_5 = var_258_4:getChildByName("btn_close")
		
		if get_cocos_refid(var_258_5) then
			function var_258_5.go()
				arg_258_0:btnGoUnlockInfoDialog(arg_258_1)
				arg_258_0:popUnlockFunc()
			end
		end
	end
	
	return true
end

function ClearResult.pushUnlockFunc(arg_260_0, arg_260_1)
	table.push(arg_260_0.vars.unlock_queue, arg_260_1)
end

function ClearResult.popUnlockFunc(arg_261_0)
	if #arg_261_0.vars.unlock_queue < 1 then
		return 
	end
	
	local var_261_0 = arg_261_0.vars.unlock_queue[1]
	
	table.remove(arg_261_0.vars.unlock_queue, 1)
	var_261_0()
end

function ClearResult.addPopupUnlockSystemSubstory(arg_262_0)
	if not arg_262_0.vars or table.empty(arg_262_0.vars.system_substory_list) or Account:getMapClearCount(arg_262_0.vars.result.map_id) > 1 or arg_262_0.vars.result.map_id == "tae010" then
		arg_262_0:nextSeq()
		
		return 
	end
	
	local var_262_0 = load_dlg("result_story_unlocked", true, "wnd", function()
		arg_262_0:closePopupUnlockSystemSubstory()
	end)
	
	if_set(var_262_0, "txt_title", T("systemsubstory_unlock_popup_title"))
	
	local var_262_1 = table.count(arg_262_0.vars.system_substory_list)
	local var_262_11
	
	if var_262_1 <= 3 and var_262_1 % 2 == 1 then
		local var_262_2 = var_262_0:getChildByName("n_story_bi_odd")
		
		if get_cocos_refid(var_262_2) then
			var_262_2:setVisible(true)
			
			if var_262_1 == 1 then
				local var_262_3 = arg_262_0.vars.system_substory_list[var_262_1]
				
				if not var_262_3 then
					return 
				end
				
				local var_262_4 = var_262_3.id
				local var_262_5 = T(DB("substory_main", var_262_4, "name"))
				
				if_set(var_262_0, "txt_desc", T_KR("systemsubstory_unlock_popup_desc", {
					substory_name = var_262_5
				}))
				
				local var_262_6 = var_262_2:getChildByName("n_story_bi2")
				
				if get_cocos_refid(var_262_6) and var_262_4 then
					local var_262_7 = SubstoryUIUtil:getBGInfo(var_262_4 .. "_sum", var_262_4)
					
					SubstoryUIUtil:setLayoutData(var_262_2, "n_story_bi2", var_262_7.logo, "img")
				end
			else
				if_set(var_262_0, "txt_desc", T("systemsubstory_unlock_popup_desc2"))
				
				for iter_262_0, iter_262_1 in pairs(arg_262_0.vars.system_substory_list) do
					local var_262_8 = var_262_2:getChildByName("n_story_bi" .. iter_262_0)
					local var_262_9 = iter_262_1.id
					
					if get_cocos_refid(var_262_8) and var_262_9 then
						local var_262_10 = SubstoryUIUtil:getBGInfo(var_262_9 .. "_sum", var_262_9)
						
						SubstoryUIUtil:setLayoutData(var_262_2, "n_story_bi" .. iter_262_0, var_262_10.logo, "img")
					end
				end
			end
		end
	elseif var_262_1 >= 5 or var_262_1 % 2 == 0 then
		var_262_11 = var_262_0:getChildByName("n_story_bi_even")
		
		if_set(var_262_0, "txt_desc", T("systemsubstory_unlock_popup_desc2"))
		
		if get_cocos_refid(var_262_11) then
			var_262_11:setVisible(true)
			
			if var_262_1 == 2 then
				for iter_262_2, iter_262_3 in pairs(arg_262_0.vars.system_substory_list) do
					local var_262_12 = iter_262_2 + 1
					local var_262_13 = var_262_11:getChildByName("n_story_bi" .. var_262_12)
					local var_262_14 = iter_262_3.id
					
					if get_cocos_refid(var_262_13) and var_262_14 then
						local var_262_15 = SubstoryUIUtil:getBGInfo(var_262_14 .. "_sum", var_262_14)
						
						SubstoryUIUtil:setLayoutData(var_262_11, "n_story_bi" .. var_262_12, var_262_15.logo, "img")
					end
				end
			else
				for iter_262_4, iter_262_5 in pairs(arg_262_0.vars.system_substory_list) do
					if iter_262_4 == 5 then
						break
					end
					
					local var_262_16 = var_262_11:getChildByName("n_story_bi" .. iter_262_4)
					local var_262_17 = iter_262_5.id
					
					if get_cocos_refid(var_262_16) and var_262_17 then
						local var_262_18 = SubstoryUIUtil:getBGInfo(var_262_17 .. "_sum", var_262_17)
						
						SubstoryUIUtil:setLayoutData(var_262_11, "n_story_bi" .. iter_262_4, var_262_18.logo, "img")
					end
				end
			end
		end
	end
	
	SceneManager:getRunningNativeScene():addChild(var_262_0)
end

function ClearResult.closePopupUnlockSystemSubstory(arg_264_0)
	if not arg_264_0.vars or not get_cocos_refid(arg_264_0.vars.wnd) then
		return 
	end
	
	SceneManager:getRunningNativeScene():removeChildByName("result_story_unlocked")
	arg_264_0:nextSeq()
end

function ClearResult.addPopupUnlockSystem(arg_265_0, arg_265_1)
	arg_265_1 = arg_265_1 or {}
	
	local var_265_0 = arg_265_0.vars.result.sys_achieve
	local var_265_1 = UnlockSystem:getJustInfoIDs(var_265_0)
	
	arg_265_0.vars.unlock_queue = {}
	
	for iter_265_0, iter_265_1 in pairs(var_265_1) do
		arg_265_0:pushUnlockFunc(function()
			arg_265_0:popupUnlockInfoDialog(iter_265_1)
		end)
	end
	
	arg_265_0:pushUnlockFunc(function()
		local function var_267_0(arg_268_0)
			arg_265_0:stopNextDungeonSound()
			arg_265_0.vars.seq:deinit()
			
			local var_268_0, var_268_1 = DB("system_achievement_effect", arg_268_0, {
				"start_land_eff",
				"next_land_eff"
			})
			
			arg_265_0.vars.next_worldmap_eff = true
			
			SceneManager:popScene()
			BackButtonManager:pop("ClearResult.playMissionResult")
			WorldMapManager:getController():moveWorldMap(nil, nil, nil, {
				unlock_before_id = var_268_0,
				unlock_id = var_268_1,
				sys_id = arg_268_0
			})
		end
		
		local function var_267_1(arg_269_0, arg_269_1)
			arg_265_0:stopNextDungeonSound()
			arg_265_0.vars.seq:deinit()
			
			arg_265_0.vars.next_worldmap_eff = true
			
			WorldMapManager:getController():moveWorldMap(nil, nil, nil, {
				maze = arg_269_1,
				sys_id = arg_269_0
			})
		end
		
		local function var_267_2(arg_270_0)
			arg_265_0.vars.seq:deinit()
			
			if arg_265_0:moveTutorial(UnlockSystem:getFirstUnhideUnlockID(arg_270_0)) then
				return 
			end
			
			arg_265_0:stopNextDungeonSound()
			SceneManager:popScene()
			ClearResult:hide()
		end
		
		local var_267_3 = UnlockSystem:getFirstUnhideSystem(UnlockSystem:getContinentUnlockSystems(var_265_0))
		
		if var_267_3 then
			var_267_0(var_267_3.sys_id)
			
			return 
		end
		
		local var_267_4 = UnlockSystem:getFirstUnhideSystem(UnlockSystem:getMazeUnlockSystems(var_265_0))
		
		if var_267_4 then
			var_267_1(var_267_4.sys_id, var_267_4.maze)
			
			return 
		end
		
		local var_267_5 = UnlockSystem:getFirstUnhideUnlockID(UnlockSystem:getCompMoveInfoIDs(var_265_0))
		
		if var_267_5 then
			arg_265_0:popupUnlockInfoDialog(var_267_5)
			
			return 
		end
		
		if arg_265_1.pvp then
			ClearResult:moveToPvpScene()
			
			return 
		end
		
		if arg_265_0:isForcePopScene() then
			var_267_2(var_265_0)
			
			return 
		end
		
		ClearResult:playNextDungeonSound()
	end)
	arg_265_0:popUnlockFunc()
end

function ClearResult.moveToPvpScene(arg_271_0)
	if ClearResult.vars.result.popup_mode == 1 then
		SceneManager:nextScene("pvp_npc")
	else
		query("pvp_sa_lobby")
	end
end

function ClearResult.playFailedEffect(arg_272_0)
	local var_272_0 = arg_272_0.vars.seq:getLayer()
	local var_272_1 = CACHE:getEffect("ui_stagefailed")
	
	arg_272_0.childs.clear_eff_top = var_272_1
	
	local var_272_2 = arg_272_0:_can_use_failuer_guide()
	
	if not var_272_2 then
		var_272_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.55 + (GrowthGuide:isEnable() and 43 or 0))
	end
	
	var_272_1:setLocalZOrder(2000)
	var_272_1:start()
	SoundEngine:play("event:/effect/stageclear_fail")
	
	if var_272_2 then
		local var_272_3 = arg_272_0.childs.n_lose
		local var_272_4 = var_272_3:getChildByName("n_failure_guide")
		
		var_272_3:getChildByName("n_lose_eff"):addChild(var_272_1)
	else
		arg_272_0.vars.wnd:addChild(var_272_1)
	end
	
	if (function()
		if BattleRepeat:isPlayingRepeatPlay() and BattleRepeat:getRepeaatLose() and BattleRepeat:get_repeatCount() > 0 then
			return true
		end
		
		return false
	end)() then
		arg_272_0:hideAll_btns(true)
	end
end

function ClearResult.playPvpNpcEffect(arg_274_0, arg_274_1)
	local var_274_0 = arg_274_0.vars.seq:getLayer()
	
	if_set_visible(arg_274_0.childs.n_pvp, "n_pvp_rewards", false)
	if_set_visible(arg_274_0.childs.n_pvp, "n_npc_rewards", true)
	if_set_visible(arg_274_0.childs.n_pvp, "n_clanwar_rewards", false)
	
	local var_274_1 = arg_274_0.childs.n_pvp:getChildByName("n_npc_rewards")
	local var_274_2 = var_274_1:getChildByName("n_reward_win")
	local var_274_3 = var_274_1:getChildByName("n_reward_lose")
	local var_274_4 = var_274_1:getChildByName("n_reward_repeat")
	local var_274_5 = var_274_1:getChildByName("n_pos_reward_repeat")
	
	var_274_2:setVisible(false)
	var_274_3:setVisible(false)
	
	if arg_274_1 then
		var_274_2:setVisible(true)
		
		for iter_274_0, iter_274_1 in pairs(arg_274_0.vars.result.pvp_reward.npc) do
			local var_274_6 = var_274_2:getChildByName("n_item" .. iter_274_0)
			
			if arg_274_0.vars.result.pvp_reward.npc[iter_274_0] then
				local var_274_7 = arg_274_0.vars.result.pvp_reward.npc[iter_274_0].reward_id
				local var_274_8 = arg_274_0.vars.result.pvp_reward.npc[iter_274_0].reward_count
				local var_274_9 = UIUtil:getRewardIcon(var_274_8, var_274_7, {
					scale = 1,
					effect = false,
					parent = var_274_2,
					target = "n_item" .. iter_274_0
				})
				
				if iter_274_0 == 1 then
					local var_274_10 = var_274_7 == "to_pvpgold" and (arg_274_0.vars.result.pvp_reward.pvpgold_boost_add_count or 0) > 0
					
					if_set_visible(var_274_2, "icon_bonus", var_274_10)
					
					if var_274_10 then
						local var_274_11 = var_274_9:getChildByName("txt_small_count")
						
						if get_cocos_refid(var_274_11) then
							var_274_11:setColor(cc.c3b(255, 120, 0))
						end
					end
				end
				
				var_274_6:setVisible(true)
			else
				var_274_6:setVisible(false)
			end
		end
		
		if arg_274_0.vars.result.pvp_reward.repeats then
			var_274_2:setPositionX(var_274_5:getPositionX() - 40)
			
			local var_274_12 = arg_274_0.vars.result.pvp_reward.repeats.reward_id
			local var_274_13 = arg_274_0.vars.result.pvp_reward.repeats.reward_count
			
			UIUtil:getRewardIcon(var_274_13, var_274_12, {
				scale = 1,
				target = "n_item2",
				effect = false,
				parent = var_274_4
			})
		else
			var_274_4:setVisible(false)
		end
	else
		var_274_3:setVisible(true)
		
		local var_274_14 = var_274_3:getChildByName("n_item1")
		
		if arg_274_0.vars.result.pvp_reward.npc[1] then
			local var_274_15 = arg_274_0.vars.result.pvp_reward.npc[1].reward_id
			local var_274_16 = arg_274_0.vars.result.pvp_reward.npc[1].reward_count
			local var_274_17 = UIUtil:getRewardIcon(var_274_16, var_274_15, {
				scale = 1,
				target = "n_item1",
				effect = false,
				parent = var_274_3
			})
			local var_274_18 = var_274_15 == "to_pvpgold" and (arg_274_0.vars.result.pvp_reward.pvpgold_boost_add_count or 0) > 0
			
			if_set_visible(var_274_3, "icon_bonus", var_274_18)
			
			if var_274_18 then
				local var_274_19 = var_274_17:getChildByName("txt_small_count")
				
				if get_cocos_refid(var_274_19) then
					var_274_19:setColor(cc.c3b(255, 120, 0))
				end
			end
			
			var_274_14:setVisible(true)
		else
			var_274_14:setVisible(false)
			if_set_visible(var_274_3, "icon_bonus", false)
		end
		
		if arg_274_0.vars.result.pvp_reward.repeats then
			var_274_3:setPositionX(var_274_5:getPositionX() + 5)
			
			local var_274_20 = arg_274_0.vars.result.pvp_reward.repeats.reward_id
			local var_274_21 = arg_274_0.vars.result.pvp_reward.repeats.reward_count
			
			UIUtil:getRewardIcon(var_274_21, var_274_20, {
				scale = 1,
				target = "n_item2",
				effect = false,
				parent = var_274_4
			})
		else
			var_274_4:setVisible(false)
		end
	end
	
	arg_274_0.childs.n_pvp:setLocalZOrder(500)
	UIAction:Add(SEQ(DELAY(3300), FADE_IN(300), CALL(function()
		arg_274_0:addResultFavorite(arg_274_0.childs.n_pvp)
	end)), arg_274_0.childs.n_pvp, "block")
	
	local var_274_22
	
	if arg_274_1 == true then
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_274_22 = CACHE:getEffect("ui_pvp_result_win.cfx")
		
		arg_274_0:playUnitWinVoc()
	else
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_274_22 = CACHE:getEffect("ui_pvp_result_lose.cfx")
	end
	
	var_274_22:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_274_22:start()
	
	arg_274_0.childs.pvp_result_eff = var_274_22
	
	arg_274_0.vars.wnd:addChild(var_274_22)
end

function ClearResult.playTournamentEffect(arg_276_0, arg_276_1)
	local var_276_0 = arg_276_0.vars.seq:getLayer()
	
	if_set_visible(arg_276_0.childs.n_pvp, "n_pvp_rewards", true)
	if_set_visible(arg_276_0.childs.n_pvp, "n_npc_rewards", false)
	if_set_visible(arg_276_0.childs.n_pvp, "n_clanwar_rewards", false)
	if_set_visible(arg_276_0.childs.n_pvp, "n_point", false)
	if_set_visible(arg_276_0.childs.n_pvp, "n_consecutive", false)
	if_set_visible(arg_276_0.childs.n_pvp, "n_reward_conse", false)
	if_set_visible(arg_276_0.childs.n_pvp, "n_reward_repeat", false)
	if_set_visible(arg_276_0.childs.n_pvp, "n_reward_battle", false)
	
	local var_276_1 = arg_276_0.childs.n_pvp:getChildByName("n_pvp_rewards")
	
	if_set_visible(var_276_1, "n_reward_node", true)
	
	local var_276_2 = var_276_1:getChildByName("n_reward_node")
	local var_276_3 = UIUtil:setTextAndReturnHeight(var_276_1:getChildByName("text"), T("result_tournament_desc"), 419)
	local var_276_4 = var_276_1:getChildByName("text"):getPositionY()
	
	var_276_1:getChildByName("cm_icon_etcinfor"):setPositionY(var_276_4 + var_276_3 + 15)
	
	if arg_276_0.vars.result.tournament_result.is_win then
		local var_276_5 = #arg_276_0.vars.result.tournament_reward
		
		for iter_276_0, iter_276_1 in pairs(arg_276_0.vars.result.tournament_reward) do
			local var_276_6 = var_276_2:getChildByName("n_view" .. iter_276_0 .. "/" .. var_276_5)
			
			if arg_276_0.vars.result.tournament_reward[iter_276_0] then
				local var_276_7 = arg_276_0.vars.result.tournament_reward[iter_276_0].reward_id
				local var_276_8 = arg_276_0.vars.result.tournament_reward[iter_276_0].reward_count
				
				UIUtil:getRewardIcon(var_276_8, var_276_7, {
					hero_multiply_scale = 1.12,
					artifact_multiply_scale = 0.75,
					effect = false,
					scale = 1,
					parent = var_276_6
				})
				var_276_6:setVisible(true)
			end
		end
	else
		var_276_2:setVisible(false)
	end
	
	arg_276_0.childs.n_pvp:setLocalZOrder(500)
	UIAction:Add(SEQ(DELAY(3300), FADE_IN(300)), arg_276_0.childs.n_pvp, "block")
	
	local var_276_9
	
	if arg_276_0.vars.result.tournament_result.is_win == true then
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_276_9 = CACHE:getEffect("ui_pvp_result_win.cfx")
		
		arg_276_0:playUnitWinVoc()
	else
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_276_9 = CACHE:getEffect("ui_pvp_result_lose.cfx")
	end
	
	var_276_9:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_276_9:start()
	
	arg_276_0.childs.pvp_result_eff = var_276_9
	
	arg_276_0.vars.wnd:addChild(var_276_9)
end

function ClearResult.playClanWarEffect(arg_277_0, arg_277_1, arg_277_2)
	local var_277_0 = arg_277_1 or {}
	local var_277_1 = arg_277_2 or {}
	local var_277_2 = var_277_0.result or 0
	local var_277_3 = var_277_0.destroy_score or 0
	local var_277_4 = arg_277_0.vars.seq:getLayer()
	
	if_set_visible(arg_277_0.childs.n_pvp, "n_clanwar_rewards", true)
	if_set_visible(arg_277_0.childs.n_pvp, "n_pvp_rewards", false)
	if_set_visible(arg_277_0.childs.n_pvp, "n_npc_rewards", false)
	
	local var_277_5 = arg_277_0.childs.n_pvp:getChildByName("n_clanwar_rewards")
	
	if_set_visible(var_277_5, "n_reward_repeat", false)
	if_set_visible(var_277_5, "n_reward_win", false)
	if_set_visible(var_277_5, "n_reward_lose", false)
	
	local var_277_6
	local var_277_7
	local var_277_8
	
	if var_277_2 < 2 then
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_277_6 = CACHE:getEffect("ui_clanpvp_battle_defeat.cfx")
		var_277_8 = "txt_war_point_up"
		var_277_7 = "txt_war_point_down"
	elseif var_277_2 == 2 then
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_277_6 = CACHE:getEffect("ui_clanpvp_battle_draw.cfx")
		var_277_8 = "txt_war_point_down"
		var_277_7 = "txt_war_point_up"
	else
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_277_6 = CACHE:getEffect("ui_clanpvp_battle_victory.cfx")
		
		arg_277_0:playUnitWinVoc()
		
		var_277_8 = "txt_war_point_down"
		var_277_7 = "txt_war_point_up"
	end
	
	if_set_visible(var_277_5, var_277_7, true)
	if_set_visible(var_277_5, var_277_8, false)
	if_set(var_277_5, var_277_7, var_277_3)
	
	local var_277_9 = var_277_5:getChildByName("n_item1")
	
	if get_cocos_refid(var_277_9) and var_277_1.battle then
		local var_277_10 = var_277_1.battle.reward_id
		local var_277_11 = var_277_1.battle.reward_count
		
		UIUtil:getRewardIcon(var_277_11, var_277_10, {
			scale = 1,
			detail = false,
			parent = var_277_9
		})
	end
	
	if get_cocos_refid(var_277_6) then
		var_277_6:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_277_6:start()
		
		arg_277_0.childs.pvp_result_eff = var_277_6
		
		arg_277_0.vars.wnd:addChild(var_277_6)
	end
	
	if_set_visible(var_277_5, "btn_clanwar_stat", false)
	arg_277_0.childs.n_pvp:setLocalZOrder(500)
	UIAction:Add(SEQ(DELAY(3300), FADE_IN(300), CALL(function()
		arg_277_0:addResultFavorite(arg_277_0.childs.n_pvp)
	end)), arg_277_0.childs.n_pvp, "block")
end

function ClearResult.playPvpEffect(arg_279_0, arg_279_1)
	local var_279_0 = arg_279_0.vars.seq:getLayer()
	
	if_set_visible(arg_279_0.childs.n_pvp, "n_pvp_rewards", true)
	if_set_visible(arg_279_0.childs.n_pvp, "n_npc_rewards", false)
	if_set_visible(arg_279_0.childs.n_pvp, "n_clanwar_rewards", false)
	
	local var_279_1 = arg_279_0.childs.n_pvp:getChildByName("n_pvp_rewards")
	local var_279_2 = to_n(arg_279_0.vars.result.pvp_result.before.score)
	local var_279_3 = to_n(arg_279_0.vars.result.pvp_result.after.score)
	local var_279_4 = to_n(arg_279_0.vars.result.pvp_result.after.acquired_point or var_279_3 - var_279_2) + to_n(arg_279_0.vars.result.pvp_result.after.bonus_point)
	local var_279_5 = var_279_1:getChildByName("txt_diff")
	local var_279_6 = var_279_1:getChildByName("diff_icon")
	
	if var_279_4 < 0 then
		local var_279_7 = cc.c3b(51, 122, 195)
		
		var_279_5:setTextColor(var_279_7)
		var_279_6:setColor(var_279_7)
	end
	
	UIAction:Add(INC_NUMBER(800, var_279_3, false, 0), var_279_1:getChildByName("txt_pvp_point"), "block")
	
	if to_n(arg_279_0.vars.result.pvp_result.after.bonus_point) > 0 then
		if_set(var_279_1, "txt_diff", var_279_4 .. " " .. T("pvp_acquired_point_with_bonus", {
			bonus_point = arg_279_0.vars.result.pvp_result.after.bonus_point
		}))
	else
		if_set(var_279_1, "txt_diff", var_279_4)
	end
	
	if var_279_4 > 0 then
		if_set_visible(var_279_1, "diff_icon", true)
	elseif var_279_4 < 0 then
		var_279_1:getChildByName("diff_icon"):setRotation(180)
		var_279_1:getChildByName("diff_icon"):setColor(cc.c3b(0, 120, 255))
		if_set_visible(var_279_1, "diff_icon", true)
	else
		if_set_visible(var_279_1, "txt_diff", false)
	end
	
	if_set_visible(var_279_1, "n_reward_node", false)
	
	if to_n(arg_279_0.vars.result.pvp_result.revenge_count) > 3 then
		if_set_visible(var_279_1, "n_point", false)
		if_set_visible(var_279_1, "n_revenge_over", true)
		if_set_visible(var_279_1, "n_consecutive", false)
		if_set_visible(var_279_1, "txt_diff", false)
		
		local var_279_8 = var_279_1:getChildByName("n_revenge_over")
		local var_279_9 = UIUtil:setTextAndReturnHeight(var_279_8:getChildByName("text"), T("ui_result_base_revenge_info"), 419)
		local var_279_10 = var_279_8:getChildByName("text"):getPositionY()
		
		var_279_8:getChildByName("cm_icon_etcinfor"):setPositionY(var_279_10 + var_279_9 + 15)
	else
		if_set_visible(var_279_1, "n_point", true)
		
		if to_n(arg_279_0.vars.result.pvp_result.after.continuous_victory) >= 2 and to_n(arg_279_0.vars.result.pvp_result.revenge_count) == 0 then
			if_set_visible(var_279_1, "n_consecutive", true)
			if_set(var_279_1:getChildByName("n_consecutive"), "txt_consecutive", T("result_base_streak", {
				streak_count = arg_279_0.vars.result.pvp_result.after.continuous_victory
			}))
			
			local var_279_11 = var_279_1:getChildByName("txt_consecutive")
			
			EffectManager:Play({
				delay = 3300,
				y = 20,
				fn = "ui_reward_popup_eff.cfx",
				layer = var_279_11
			})
		else
			if_set_visible(var_279_1, "n_consecutive", false)
		end
		
		if_set_visible(var_279_1, "n_revenge_over", false)
	end
	
	if arg_279_0.vars.result.pvp_reward then
		if_set_visible(var_279_1, "n_reward_node", true)
		
		local var_279_12 = var_279_1:getChildByName("n_reward_node")
		local var_279_13 = var_279_12:getChildByName("n_reward_battle")
		local var_279_14 = var_279_12:getChildByName("n_reward_repeat")
		local var_279_15 = var_279_12:getChildByName("n_reward_conse")
		local var_279_16 = 0
		
		if arg_279_0.vars.result.pvp_reward.battle then
			var_279_16 = var_279_16 + 1
		end
		
		if arg_279_0.vars.result.pvp_reward.repeats then
			var_279_16 = var_279_16 + 1
		end
		
		if arg_279_0.vars.result.pvp_reward.continuous_victory then
			var_279_16 = var_279_16 + 1
		end
		
		local var_279_17 = 0
		
		if arg_279_0.vars.result.pvp_reward.battle then
			var_279_17 = var_279_17 + 1
			
			local var_279_18 = arg_279_0.vars.result.pvp_reward.battle.reward_id
			local var_279_19 = arg_279_0.vars.result.pvp_reward.battle.reward_count
			
			if_set_visible(var_279_13, "t_reward_repeat", false)
			if_set_visible(var_279_13, "icon_bonus", false)
			var_279_13:setPositionX(var_279_12:getChildByName("n_view" .. var_279_17 .. "/" .. var_279_16):getPositionX())
			
			local var_279_20 = UIUtil:getRewardIcon(var_279_19, var_279_18, {
				effect = true,
				scale = 1,
				effect_delay = 3300,
				target = "n_item1",
				parent = var_279_13
			})
			local var_279_21 = var_279_18 == "to_pvpgold" and (arg_279_0.vars.result.pvp_reward.pvpgold_boost_add_count or 0) > 0
			
			if_set_visible(n_reward_win, "icon_bonus", var_279_21)
			
			if var_279_21 then
				local var_279_22 = var_279_20:getChildByName("txt_small_count")
				
				if get_cocos_refid(var_279_22) then
					var_279_22:setColor(cc.c3b(255, 120, 0))
				end
			end
			
			if_set_visible(var_279_13, "icon_bonus", var_279_21)
		else
			var_279_13:setVisible(false)
		end
		
		if arg_279_0.vars.result.pvp_reward.continuous_victory then
			var_279_17 = var_279_17 + 1
			
			local var_279_23 = arg_279_0.vars.result.pvp_reward.continuous_victory.reward_id
			local var_279_24 = arg_279_0.vars.result.pvp_reward.continuous_victory.reward_count
			
			var_279_15:setPositionX(var_279_12:getChildByName("n_view" .. var_279_17 .. "/" .. var_279_16):getPositionX())
			UIUtil:getRewardIcon(var_279_24, var_279_23, {
				effect = true,
				scale = 1,
				effect_delay = 3300,
				target = "n_item",
				parent = var_279_15
			})
		else
			var_279_15:setVisible(false)
		end
		
		if arg_279_0.vars.result.pvp_reward.repeats then
			local var_279_25 = var_279_17 + 1
			local var_279_26 = arg_279_0.vars.result.pvp_reward.repeats.reward_id
			local var_279_27 = arg_279_0.vars.result.pvp_reward.repeats.reward_count
			
			var_279_14:setPositionX(var_279_12:getChildByName("n_view" .. var_279_25 .. "/" .. var_279_16):getPositionX())
			UIUtil:getRewardIcon(var_279_27, var_279_26, {
				effect = true,
				scale = 1,
				effect_delay = 3300,
				target = "n_item2",
				parent = var_279_14
			})
		else
			var_279_14:setVisible(false)
		end
	end
	
	arg_279_0.childs.n_pvp:setLocalZOrder(500)
	UIAction:Add(SEQ(DELAY(3300), FADE_IN(300), CALL(function()
		arg_279_0:addResultFavorite(arg_279_0.childs.n_pvp)
	end)), arg_279_0.childs.n_pvp, "block")
	
	local var_279_28
	
	if arg_279_1 == true then
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_279_28 = CACHE:getEffect("ui_pvp_result_win.cfx")
		
		arg_279_0:playUnitWinVoc()
	else
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_279_28 = CACHE:getEffect("ui_pvp_result_lose.cfx")
	end
	
	var_279_28:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_279_28:start()
	
	arg_279_0.childs.pvp_result_eff = var_279_28
	
	arg_279_0.vars.wnd:addChild(var_279_28)
end

function ClearResult.playNetPvpEffect(arg_281_0, arg_281_1)
	local var_281_0 = arg_281_0.vars.seq:getLayer()
	local var_281_1 = getNetUserEndInfo(arg_281_0.vars.result.net_pvp_result, arg_281_1.user_info.uid) or {}
	local var_281_2 = arg_281_0.vars.result.net_pvp_result.winner
	local var_281_3 = arg_281_0.vars.result.net_pvp_result.reason
	local var_281_4 = arg_281_0.vars.result.net_pvp_result.round_info
	
	if_set_visible(arg_281_0.childs.n_pvp, "n_pvp_rewards", true)
	if_set_visible(arg_281_0.childs.n_pvp, "n_npc_rewards", false)
	if_set_visible(arg_281_0.childs.n_pvp, "n_clanwar_rewards", false)
	if_set_visible(arg_281_0.childs.n_pvp, "btn_stat", not ArenaNetReady:isShow())
	if_set_visible(arg_281_0.childs.n_pvp, "n_consecutive", false)
	if_set_visible(arg_281_0.childs.n_pvp, "n_revenge_over", false)
	if_set_visible(arg_281_0.childs.n_pvp, "n_reward_repeat", false)
	if_set_visible(arg_281_0.childs.n_pvp, "n_reward_conse", false)
	if_set_visible(arg_281_0.childs.n_pvp, "n_pvplive_info", false)
	
	if arg_281_0:isReplayMode() then
		arg_281_0.childs.n_replay:setVisible(true)
		arg_281_0.childs.n_replay:setOpacity(255)
	end
	
	local var_281_5 = arg_281_0.childs.n_pvp:getChildByName("n_pvp_rewards")
	local var_281_6 = (var_281_1.win or 0) + (var_281_1.draw or 0) + (var_281_1.lose or 0)
	
	if var_281_1 then
		local var_281_7 = ArenaService:getMatchMode()
		local var_281_14, var_281_15
		
		if var_281_7 == "net_rank" and var_281_6 <= ARENA_MATCH_BATCH_COUNT then
			if_set_visible(arg_281_0.childs.n_pvp, "n_pvplive_tier_placement", true)
			if_set_visible(arg_281_0.childs.n_pvp, "n_point", false)
			if_set_visible(arg_281_0.childs.n_pvp, "n_reward_node", false)
			if_set_visible(arg_281_0.childs.n_pvp, "n_clanwar_rewards", false)
			if_set(arg_281_0.childs.n_pvp, "txt_count", tostring(var_281_6) .. "/" .. tostring(ARENA_MATCH_BATCH_COUNT))
		elseif var_281_7 == "net_friend" then
			if_set_visible(arg_281_0.childs.n_pvp, "n_pvplive_tier_placement", true)
			if_set_visible(arg_281_0.childs.n_pvp, "n_point", false)
			if_set_visible(arg_281_0.childs.n_pvp, "n_reward_node", false)
			if_set_visible(arg_281_0.childs.n_pvp, "n_clanwar_rewards", false)
			if_set_visible(arg_281_0.childs.n_pvp, "txt_count", false)
			if_set(arg_281_0.childs.n_pvp, "txt_tier_placement", T("pvp_rta_mock_nopoint"))
		elseif var_281_7 == "net_event_rank" then
			if_set_visible(arg_281_0.childs.n_pvp, "n_pvplive_tier_placement", true)
			if_set_visible(arg_281_0.childs.n_pvp, "n_point", false)
			if_set_visible(arg_281_0.childs.n_pvp, "n_reward_node", false)
			if_set_visible(arg_281_0.childs.n_pvp, "n_clanwar_rewards", false)
			if_set_visible(arg_281_0.childs.n_pvp, "txt_count", false)
			if_set(arg_281_0.childs.n_pvp, "txt_tier_placement", "")
		else
			if_set_visible(arg_281_0.childs.n_pvp, "n_pvplive_tier_placement", false)
			
			local var_281_8 = to_n(var_281_1.old_score)
			local var_281_9 = to_n(var_281_1.new_score)
			local var_281_10 = to_n(arg_281_0.vars.result.net_pvp_result.acquired_point or var_281_9 - var_281_8)
			local var_281_11 = var_281_5:getChildByName("txt_diff")
			local var_281_12 = var_281_5:getChildByName("diff_icon")
			
			if var_281_10 < 0 then
				local var_281_13 = cc.c3b(51, 122, 195)
				
				var_281_11:setTextColor(var_281_13)
				var_281_12:setColor(var_281_13)
			end
			
			UIAction:Add(INC_NUMBER(800, var_281_9, false, 0), var_281_5:getChildByName("txt_pvp_point"), "block")
			
			if to_n(arg_281_0.vars.result.net_pvp_result.bonus_point) > 0 then
				if_set(var_281_5, "txt_diff", var_281_10 .. " " .. T("pvp_acquired_point_with_bonus", {
					bonus_point = arg_281_0.vars.result.net_pvp_result.bonus_point
				}))
			else
				if_set(var_281_5, "txt_diff", var_281_10)
			end
			
			if var_281_10 > 0 then
				if_set_visible(var_281_5, "diff_icon", true)
			elseif var_281_10 < 0 then
				var_281_5:getChildByName("diff_icon"):setRotation(180)
				var_281_5:getChildByName("diff_icon"):setColor(cc.c3b(0, 120, 255))
				if_set_visible(var_281_5, "diff_icon", true)
			else
				if_set_visible(var_281_5, "txt_diff", false)
			end
			
			if var_281_1.rewards then
				if_set_visible(var_281_5, "n_reward_node", true)
				
				var_281_14 = var_281_5:getChildByName("n_reward_node")
				var_281_15 = table.count(var_281_1.rewards)
				
				for iter_281_0, iter_281_1 in pairs(var_281_1.rewards) do
					local var_281_16 = iter_281_1.id
					local var_281_17 = iter_281_1.count
					local var_281_18 = var_281_14:getChildByName("n_view" .. iter_281_0 .. "/" .. var_281_15)
					
					UIUtil:getRewardIcon(var_281_17, var_281_16, {
						effect = true,
						scale = 1,
						effect_delay = 3300,
						parent = var_281_18
					})
				end
			end
		end
	else
		local var_281_19 = arg_281_0.childs.n_pvp:getChildByName("n_pvp_rewards")
		
		if_set_visible(var_281_19, "n_point", false)
	end
	
	if var_281_3 ~= 1 then
		local var_281_20 = arg_281_0.childs.n_pvp:getChildByName("n_pvplive_info")
		local var_281_21 = var_281_20:getChildByName("text")
		local var_281_22 = arg_281_0.vars.result.net_pvp_result
		
		if var_281_3 == 2 and var_281_2 == arg_281_1.user_info.uid then
			var_281_20:setVisible(true)
			var_281_21:setString(T("rta_match_err_desc1"))
		elseif (var_281_3 == 3 or var_281_3 == 7) and var_281_2 == arg_281_1.user_info.uid then
			var_281_20:setVisible(true)
			var_281_21:setString(T("rta_match_err_desc3"))
		elseif (var_281_3 == 3 or var_281_3 == 7) and var_281_2 == arg_281_1.enemy_user_info.uid then
			var_281_20:setVisible(true)
			var_281_21:setString(T("rta_match_err_desc2"))
		elseif var_281_3 == 4 then
			var_281_20:setVisible(true)
			var_281_21:setString(T("rta_match_err_desc2"))
		elseif var_281_3 == 6 then
			var_281_20:setVisible(true)
			var_281_21:setString(T("rta_match_err_desc4"))
		elseif var_281_3 == 8 then
			var_281_20:setVisible(true)
			var_281_21:setString(T("pvp_rta_mock_battle_admin_end"))
		elseif var_281_3 == 9 then
			var_281_20:setVisible(true)
			var_281_21:setString(T("pvp_rta_mock_battle_admin_end"))
		elseif var_281_3 == "season_over" then
			var_281_20:setVisible(true)
			var_281_21:setString(T("pvp_rta_season_changed"))
		end
	end
	
	arg_281_0.childs.n_pvp:setLocalZOrder(500)
	UIAction:Add(SEQ(DELAY(3300), FADE_IN(300), CALL(function()
		if_set_visible(arg_281_0.vars.wnd, "btn_replay", arg_281_0:isReplayMode())
	end)), arg_281_0.childs.n_pvp, "block")
	
	local var_281_23
	
	if var_281_2 == "invalid" then
	elseif var_281_2 == "draw" then
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_281_23 = CACHE:getEffect("ui_clanpvp_battle_draw.cfx")
	elseif var_281_2 == "terminate" then
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_281_23 = CACHE:getEffect("ui_pvp_result_win.cfx")
	elseif var_281_2 == arg_281_1.user_info.uid then
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_281_23 = CACHE:getEffect("ui_pvp_result_win.cfx")
		
		arg_281_0:playUnitWinVoc()
	else
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_281_23 = CACHE:getEffect("ui_pvp_result_lose.cfx")
	end
	
	if var_281_23 then
		var_281_23:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_281_23:start()
		
		arg_281_0.childs.pvp_result_eff = var_281_23
		
		arg_281_0.vars.wnd:addChild(var_281_23)
	end
	
	if var_281_4 and not arg_281_0:isReplayMode() then
		if_set_visible(arg_281_0.vars.wnd, "btn_pvp_ok", false)
		if_set_visible(arg_281_0.vars.wnd, "btn_pvplive_ok", false)
		if_set_visible(arg_281_0.vars.wnd, "btn_pvp_next_ok", false)
		if_set_visible(arg_281_0.childs.n_pvp, "btn_stat", false)
		UIAction:Add(SEQ(DELAY(6000), CALL(function()
			arg_281_0:addPvpNextResult2(var_281_4)
		end)), arg_281_0.childs.n_pvp, "block")
	end
end

function ClearResult.playNetPvpWatchEffect(arg_284_0)
	local var_284_0 = ArenaService:getMatchInfo() or {
		user_info = {},
		enemy_user_info = {}
	}
	local var_284_1 = arg_284_0.vars.result.net_pvp_result.winner
	local var_284_2 = arg_284_0.vars.result.net_pvp_result.reason
	local var_284_3 = arg_284_0.childs.n_pvplive_watch:getChildByName("n_pvplive_info")
	local var_284_4 = arg_284_0.vars.result.net_pvp_result.round_info
	local var_284_5 = var_284_3:getChildByName("text")
	local var_284_6
	
	if var_284_0.user_info.uid == var_284_1 then
		var_284_6 = var_284_0.user_info
	elseif var_284_0.enemy_user_info.uid == var_284_1 then
		var_284_6 = var_284_0.enemy_user_info
	end
	
	if var_284_2 == 8 or var_284_2 == 9 and not var_284_6 then
		arg_284_0.childs.n_pvplive_watch:setLocalZOrder(500)
		UIAction:Add(SEQ(DELAY(3300), FADE_IN(300)), arg_284_0.childs.n_pvplive_watch, "block")
		if_set_visible(arg_284_0.childs.n_pvplive_watch, "n_common", false)
		var_284_3:setVisible(true)
		var_284_5:setString(T("pvp_rta_mock_battle_admin_end"))
	else
		var_284_6 = var_284_6 or {}
		
		local var_284_7 = (var_284_6.win or 0) + (var_284_6.draw or 0) + (var_284_6.lose or 0) <= ARENA_MATCH_BATCH_COUNT
		
		arg_284_0.childs.n_pvplive_watch:setLocalZOrder(500)
		UIAction:Add(SEQ(DELAY(3300), FADE_IN(300)), arg_284_0.childs.n_pvplive_watch, "block")
		UIUtil:getUserIcon(var_284_6.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_284_0.childs.n_pvplive_watch:getChildByName("n_face"),
			border_code = var_284_6.border_code
		})
		if_set_visible(arg_284_0.childs.n_pvplive_watch, "n_common", true)
		
		if var_284_7 then
			SpriteCache:resetSprite(arg_284_0.childs.n_pvplive_watch:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
		else
			local var_284_8, var_284_9 = getArenaNetRankInfo(arg_284_0.vars.result.net_pvp_season, var_284_6.league_id)
			
			SpriteCache:resetSprite(arg_284_0.childs.n_pvplive_watch:getChildByName("emblem"), "emblem/" .. var_284_9 .. ".png")
		end
		
		if_set(arg_284_0.childs.n_pvplive_watch, "t_arinagerfy", var_284_6.name)
		if_set(arg_284_0.childs.n_pvplive_watch, "txt_nation", getRegionText(var_284_6.world))
	end
	
	local var_284_10
	
	if var_284_1 == "invalid" then
	elseif var_284_1 == "draw" then
		SoundEngine:play("event:/ui/pvp/result_lose")
		
		var_284_10 = CACHE:getEffect("ui_clanpvp_battle_draw.cfx")
	elseif var_284_1 == "terminate" then
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_284_10 = CACHE:getEffect("ui_pvp_result_win.cfx")
	else
		SoundEngine:play("event:/ui/pvp/result_win")
		
		var_284_10 = CACHE:getEffect("ui_pvp_result_win.cfx")
		
		arg_284_0:playUnitWinVoc()
	end
	
	if var_284_10 then
		var_284_10:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_284_10:start()
		
		arg_284_0.childs.pvp_result_eff = var_284_10
		
		arg_284_0.vars.wnd:addChild(var_284_10)
	end
	
	if var_284_4 then
		if_set_visible(arg_284_0.vars.wnd, "btn_pvp_ok", false)
		if_set_visible(arg_284_0.vars.wnd, "btn_pvplive_ok", false)
		if_set_visible(arg_284_0.vars.wnd, "btn_pvp_next_ok", false)
		if_set_visible(arg_284_0.childs.n_pvp, "btn_stat", false)
		UIAction:Add(SEQ(DELAY(6000), CALL(function()
			arg_284_0:addPvpNextResult2(var_284_4)
		end)), arg_284_0.childs.n_pvp, "block")
	end
end

function ClearResult.playClearEffect(arg_286_0, arg_286_1)
	local var_286_0 = 0
	local var_286_1 = 0
	local var_286_2 = 0
	
	for iter_286_0 = 1, 3 do
		local var_286_3 = arg_286_0.vars.result.map_id
		local var_286_4 = DB("level_enter", var_286_3, "mission" .. iter_286_0)
		
		if table.isInclude(arg_286_0.vars.result.missions, function(arg_287_0, arg_287_1)
			if arg_287_1.contents_id == var_286_4 then
				return true
			end
		end) then
			var_286_1 = var_286_1 + 1
		elseif ConditionContentsManager:isMissionCleared(var_286_4, {
			inbattle = true,
			enter_id = var_286_3
		}) then
			var_286_0 = var_286_0 + 1
		end
	end
	
	local var_286_5 = var_286_0 + var_286_1
	local var_286_6 = arg_286_0.vars.seq:getLayer()
	local var_286_7 = {
		"one",
		"two",
		"three",
		"finish_one",
		"finish_two",
		"finish_three"
	}
	local var_286_8 = CACHE:getEffect("stageclear_base_top")
	
	arg_286_0.childs.clear_eff_top = var_286_8
	
	var_286_8:setScale(1.5)
	var_286_8:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.65)
	var_286_8:setAnimation(0, "animation", false)
	var_286_8:setLocalZOrder(2000)
	var_286_8:setOpacity(0)
	SoundEngine:play("event:/effect/stageclear_base")
	arg_286_0.vars.wnd:addChild(var_286_8)
	UIAction:Add(LOG(FADE_IN(500), 100), var_286_8, "block")
	
	arg_286_0.childs.stars = {}
	
	if arg_286_0.vars.has_mission then
		local var_286_9 = CACHE:getEffect("stageclear_base_bottom")
		
		arg_286_0.childs.clear_eff_bottom = var_286_9
		
		var_286_9:setScale(1.5)
		var_286_9:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.65)
		
		local var_286_10 = DB("level_enter", arg_286_0.vars.result.map_id, "type")
		local var_286_11 = var_286_10 ~= "quest" and var_286_10 ~= "extra_quest" and not string.starts(var_286_10, "dungeon") and var_286_10 ~= "defense_quest"
		
		if var_286_11 and string.starts(arg_286_0.vars.result.map_id, "abysshard") then
			var_286_11 = false
		end
		
		local var_286_12 = var_286_1
		
		if var_286_11 then
			var_286_12 = 3
		elseif var_286_0 > 0 then
			var_286_12 = 3 + var_286_0
		end
		
		if var_286_7[var_286_12] then
			var_286_9:setAnimation(0, var_286_7[var_286_12], false)
		else
			Log.e("INVALID_CLEAR_GRADE", var_286_12)
		end
		
		var_286_9:setLocalZOrder(2000)
		var_286_9:setOpacity(0)
		UIAction:Add(LOG(FADE_IN(500), 100), var_286_9, "block")
		arg_286_0.vars.wnd:addChild(var_286_9)
		
		if var_286_11 then
			for iter_286_1 = 1, 3 do
				local var_286_13 = CACHE:getEffect("stageclear_star" .. iter_286_1)
				
				var_286_13:setScale(1.5)
				var_286_13:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.65)
				var_286_13:start()
				var_286_13:setLocalZOrder(2000)
				arg_286_0.vars.wnd:addChild(var_286_13)
				
				arg_286_0.childs.stars[iter_286_1] = var_286_13
			end
		elseif var_286_5 > 0 then
			for iter_286_2 = 1, 3 do
				if var_286_0 < iter_286_2 and iter_286_2 <= var_286_5 then
					local var_286_14 = CACHE:getEffect("stageclear_star" .. iter_286_2)
					
					var_286_14:setScale(1.5)
					var_286_14:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.65)
					var_286_14:start()
					var_286_14:setLocalZOrder(2000)
					arg_286_0.vars.wnd:addChild(var_286_14)
					
					arg_286_0.childs.stars[iter_286_2] = var_286_14
				end
			end
		end
	end
	
	SoundEngine:playBGM("event:/bgm/bgm_stage_clear_loop")
end

function ClearResult.removeClearEffectBottom(arg_288_0)
	if arg_288_0.vars.has_mission and arg_288_0.childs.clear_eff_bottom then
		UIAction:Add(SEQ(FADE_OUT(250)), arg_288_0.childs.clear_eff_bottom)
	end
	
	if arg_288_0.childs.stars then
		for iter_288_0, iter_288_1 in pairs(arg_288_0.childs.stars) do
			UIAction:Add(SEQ(FADE_OUT(250)), iter_288_1)
		end
	end
end

function ClearResult.removeClearEffectTop(arg_289_0)
	if arg_289_0.childs.clear_eff_top then
		UIAction:Add(SEQ(FADE_OUT(250)), arg_289_0.childs.clear_eff_top)
	end
	
	if arg_289_0.childs.clear_eff_bottom then
		UIAction:Add(SEQ(FADE_OUT(250)), arg_289_0.childs.clear_eff_bottom)
	end
end

function ClearResult.playAgain(arg_290_0, arg_290_1)
	local var_290_0 = arg_290_0.vars.result.map_id
	local var_290_1 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(var_290_0)
	local var_290_2
	local var_290_3 = DB("level_enter", var_290_0, {
		"contents_type"
	})
	
	if arg_290_1 == "btn_next" then
		if arg_290_0.vars.next_difficulty_info then
			var_290_2 = arg_290_0.vars.next_difficulty_info.difficulty_level
		end
		
		if arg_290_0.vars.hunt_ginie_next_map_id then
			var_290_0 = arg_290_0.vars.hunt_ginie_next_map_id
		end
		
		if arg_290_0.vars.next_difficulty_info and arg_290_0.vars.next_difficulty_info.difficulty_enter_id then
			local var_290_4 = Account:getEnterLimitInfo(arg_290_0.vars.next_difficulty_info.difficulty_enter_id)
			
			if var_290_4 and var_290_4 <= 0 then
				balloon_message_with_sound("enter_limit_full_custom_expire")
				
				return 
			end
			
			local var_290_5 = DB("level_enter", arg_290_0.vars.next_difficulty_info.difficulty_enter_id, {
				"type"
			})
			
			if var_290_5 == "descent" then
				DescentReady:show({
					enter_id = arg_290_0.vars.next_difficulty_info.difficulty_enter_id,
					callback = arg_290_0
				})
				
				return 
			elseif var_290_5 == "burning" then
				BurningReady:show({
					enter_id = arg_290_0.vars.next_difficulty_info.difficulty_enter_id,
					callback = arg_290_0,
					burning_battle_id = SubStoryBurningDungeon:getBattleID()
				})
				
				return 
			end
		end
	end
	
	if arg_290_0.vars.result.descent then
		DescentReady:show({
			enter_id = var_290_0
		})
	elseif arg_290_0.vars.result.burning then
		BurningReady:show({
			enter_id = var_290_0,
			callback = arg_290_0,
			burning_battle_id = SubStoryBurningDungeon:getBattleID()
		})
	elseif arg_290_0.vars.result.crehunt then
		BattleReady:show({
			hide_open_difficulty = true,
			enter_id = var_290_0,
			callback = arg_290_0,
			urgent_mission_id = var_290_1,
			difficulty_level = var_290_2
		})
	else
		BattleReady:show({
			hide_open_difficulty = true,
			enter_id = var_290_0,
			callback = arg_290_0,
			urgent_mission_id = var_290_1,
			difficulty_level = var_290_2
		})
	end
end

function ClearResult.playPracticeAgain(arg_291_0)
	local var_291_0 = arg_291_0.vars.result.map_id
	local var_291_1
	
	if Account:getMapClearCount(var_291_0) > 0 and DungeonHell:isAbyssHardMap(var_291_0) then
		var_291_1 = {
			"crystal",
			"gold",
			"abysskey",
			"stigma"
		}
	end
	
	BattleReady:show({
		practice_mode = true,
		enter_id = var_291_0,
		callback = arg_291_0,
		currencies = var_291_1
	})
end

function ClearResult.getNextDungeon(arg_292_0, arg_292_1)
	arg_292_1 = arg_292_1 or arg_292_0.vars.result.map_id
	
	local var_292_0
	local var_292_1, var_292_2, var_292_3 = DB("level_enter", arg_292_1, {
		"type",
		"road",
		"contents_type"
	})
	
	if var_292_1 == "dungeon" then
		local var_292_4 = string.sub(arg_292_1, -3, -1)
		local var_292_5 = string.format("%03d", to_n(var_292_4) + 1)
		
		var_292_0 = string.gsub(arg_292_1, var_292_4, var_292_5)
	elseif var_292_2 then
		var_292_0 = string.split(var_292_2, ",")[1]
	elseif var_292_1 == "dungeon_quest" then
		return nil
	elseif var_292_1 == "abyss" then
		local var_292_6 = string.sub(arg_292_1, -3, -1)
		local var_292_7 = DungeonHell:isAbyssHardMap(arg_292_1) and DungeonHell:getMaxChallengeFloor() or DungeonHell:getMaxFloor()
		
		if var_292_3 == "automaton" then
			var_292_7 = DungeonAutomaton:getMaxFloor()
		elseif var_292_3 == "abyss_hard" then
			var_292_7 = DungeonHell:getMaxChallengeFloor()
		end
		
		if var_292_7 > to_n(var_292_6) then
			local var_292_8 = string.format("%03d", to_n(var_292_6) + 1)
			
			var_292_0 = string.gsub(arg_292_1, var_292_6, var_292_8)
			
			print(arg_292_1, var_292_8, var_292_6, var_292_0)
		end
	else
		return nil
	end
	
	local var_292_9, var_292_10, var_292_11 = DB("level_enter", var_292_0, {
		"id",
		"type",
		"change_enter"
	})
	
	if var_292_10 == "portal" then
		return 
	end
	
	if var_292_10 == "story" then
		return 
	end
	
	if var_292_10 == "cook" then
		return 
	end
	
	if var_292_10 == "volleyball" then
		return 
	end
	
	if var_292_10 == "village" then
		return 
	end
	
	if var_292_10 == "arcade" then
		return 
	end
	
	if var_292_10 == "repair" then
		return 
	end
	
	if var_292_10 == "exorcist" then
		return 
	end
	
	if var_292_11 then
		local var_292_12 = totable(var_292_11)
		
		return WorldMapTown:getChangeEnterID(var_292_12.id) or var_292_9
	end
	
	return var_292_9
end

function ClearResult.getNextDungeonId_SkipPortal(arg_293_0, arg_293_1)
	local var_293_0, var_293_1 = DB("level_enter", arg_293_1, {
		"type",
		"portal"
	})
	
	if var_293_0 == "portal" then
		local var_293_2 = string.split(var_293_1, "=")
		local var_293_3 = DB("level_enter", var_293_2[3], {
			"road"
		})
		
		return string.split(var_293_3, ",")[1]
	else
		return arg_293_1
	end
end

function ClearResult.playNextDungeon(arg_294_0, arg_294_1)
	local var_294_0 = arg_294_0:getNextDungeon(arg_294_0.vars.result.map_id)
	local var_294_1 = {}
	
	if not var_294_0 then
		balloon_message_with_sound("no_more_next_dungeon")
		Battle:onClickNextButton(false)
		
		return 
	elseif arg_294_0.vars.result.substory_id and not SubstoryManager:isUnlockDungeon(arg_294_0.vars.result.substory_id, var_294_0) then
		local var_294_2, var_294_3 = DB("level_substory_enter_property", var_294_0, {
			"id",
			"unlock_toast_msg"
		})
		
		if var_294_3 then
			balloon_message_with_sound(var_294_3)
		end
		
		Battle:onClickNextButton(false)
		
		return 
	end
	
	if not Account:checkEnterMap(var_294_0, var_294_1) then
		local var_294_4 = UIUtil:setMsgCheckEnterMapErr(var_294_0, var_294_1)
		
		balloon_message_with_sound_raw_text(var_294_4)
		Battle:onClickNextButton(false)
		
		return 
	end
	
	if not BattleReady:canUseReadyUI(var_294_0) then
		return 
	end
	
	local var_294_5 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(var_294_0)
	
	if Action:Find("battle_ready.show") then
		return 
	end
	
	local var_294_6 = string.find(var_294_0, "auto")
	local var_294_7 = SceneManager:getRunningNativeScene()
	
	Action:Add(SEQ(DELAY(arg_294_1), CALL(function()
		BattleReady:show({
			enter_id = var_294_0,
			callback = arg_294_0,
			urgent_mission_id = var_294_5,
			is_automaton = var_294_6
		})
	end)), var_294_7, "battle_ready.show")
	
	return true
end

function ClearResult.checkAutomatonWeekChange(arg_296_0)
	if not arg_296_0.vars or not get_cocos_refid(arg_296_0.vars.wnd) or not arg_296_0.vars.result or not arg_296_0.vars.result.automaton then
		return 
	end
	
	return DungeonAutomaton:checkAutomatonWeekChange()
end

function ClearResult.addFriendRequest(arg_297_0)
	BattleReadyFriends:afterBattleFriend(arg_297_0.vars.wnd)
end

function ClearResult.addGainOrbis(arg_298_0, arg_298_1)
	arg_298_0.vars.seq:add(arg_298_0.playGainOrbis, arg_298_0, {
		parent = arg_298_0.vars.wnd:getChildByName("n_orbis")
	})
	arg_298_0.childs.n_orbis:setVisible(true)
	arg_298_0.childs.n_orbis:setOpacity(255)
	arg_298_0.vars.seq:addClearAsync("n_orbis")
end

function ClearResult.playGainOrbis(arg_299_0)
	local var_299_0 = load_dlg("gain_orbis", true, "wnd")
	
	arg_299_0.vars.wnd:getChildByName("n_orbis"):addChild(var_299_0)
	EffectManager:Play({
		fn = "ui_get_orbis_eff.cfx",
		layer = var_299_0:getChildByName("n_orbis"),
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	if_set(var_299_0, "txt_title", T("stone_name"))
	if_set(var_299_0, "txt_desc", T("orbis_stone_get_adv"))
	var_299_0:getChildByName("n_text"):setOpacity(0)
	UIAction:Add(SEQ(DELAY(2500), OPACITY(333, 0, 1)), var_299_0:getChildByName("n_text"), "block")
end

function ClearResult.onStartBattle(arg_300_0, arg_300_1)
	local var_300_0 = arg_300_1.enter_id
	
	Thread("move_next", function()
		if get_cocos_refid(arg_300_0.vars.wnd) then
			local var_301_0 = arg_300_0.vars.wnd:getChildByName("btn_move_next")
			
			if get_cocos_refid(var_301_0) then
				var_301_0:setTouchEnabled(false)
			end
		end
		
		ClearResult:hide()
		Battle:playMoveNext()
		
		local var_301_1 = LAST_TICK
		
		while LAST_TICK - var_301_1 < 100 do
			coroutine.yield()
		end
		
		local var_301_2 = UIUtil:getScreenTransNode()
		local var_301_3 = 0
		
		if HEIGHT_MARGIN > 0 then
			var_301_3 = HEIGHT_MARGIN / 2
		end
		
		TransitionScreen:show({
			on_show_before = function(arg_302_0)
				arg_302_0:addChild(var_301_2)
				UIAction:Add(SEQ(MOVE_TO(0, VIEW_WIDTH * 2, DESIGN_HEIGHT / 2 + var_301_3), SHOW(true), MOVE_TO(600, VIEW_WIDTH / 2, DESIGN_HEIGHT / 2 + var_301_3)), var_301_2, "block")
				
				return var_301_2, 800
			end,
			on_hide_before = function(arg_303_0)
				UIAction:Add(SEQ(MOVE_TO(600, -VIEW_WIDTH, DESIGN_HEIGHT / 2 + var_301_3), REMOVE()), var_301_2, "block")
				
				return var_301_2, 800
			end,
			on_show = function()
				if not startBattle(var_300_0, arg_300_1) then
					ClearResult:stopNextDungeonSound()
					SceneManager:nextScene("lobby")
					SceneManager:resetSceneFlow()
				end
			end
		})
	end)
end

function ClearResult.setInputLock(arg_305_0, arg_305_1)
	arg_305_0.vars.blockInput = arg_305_1
end

function ClearResult.onCloseBattleReadyDialog(arg_306_0)
	if Battle then
		Battle:backToRoad()
	end
end

function ClearResult.updateDifficultyButton(arg_307_0, arg_307_1, arg_307_2)
	local var_307_0 = arg_307_1:getChildByName("btn_next")
	
	if get_cocos_refid(var_307_0) then
		if_set_visible(var_307_0, nil, false)
		
		local var_307_1 = arg_307_0:_check_next_level_hunt_ginie(arg_307_2)
		
		if var_307_1 and Account:checkEnterMap(var_307_1) then
			arg_307_0.vars.hunt_ginie_next_map_id = var_307_1
			
			if_set_visible(var_307_0, nil, true)
			UIUtil:setButtonEnterInfo(var_307_0, var_307_1)
		else
			local var_307_2 = DB("level_enter", arg_307_2, "difficulty_id")
			
			if var_307_2 then
				local var_307_3 = get_max_difficulty_level(var_307_2)
				local var_307_4 = enter_id_to_difficulty_level(arg_307_2, var_307_2, var_307_3)
				local var_307_5 = var_307_4 < var_307_3
				local var_307_6 = get_difficulty_id(var_307_2, var_307_4 + 1)
				
				if var_307_5 and var_307_6 and Account:checkEnterMap(var_307_6) then
					if_set_visible(var_307_0, nil, true)
					
					arg_307_0.vars.next_difficulty_info = {
						difficulty_id = var_307_2,
						difficulty_enter_id = var_307_6,
						difficulty_level = var_307_4 + 1,
						enter_id = arg_307_2
					}
					
					UIUtil:setButtonEnterInfo(var_307_0, var_307_6, arg_307_0.vars.next_difficulty_info)
					
					local var_307_7 = Account:getEnterLimitInfo(var_307_6)
					
					if var_307_7 and var_307_7 <= 0 then
						if_set_color(var_307_0, nil, cc.c3b(136, 136, 136))
						if_set_visible(arg_307_1, "n_limit", true)
					else
						if_set_visible(arg_307_1, "n_limit", false)
					end
				end
			end
		end
	end
end

function ClearResult._check_next_level_hunt_ginie(arg_308_0, arg_308_1)
	if not arg_308_1 then
		return 
	end
	
	local var_308_0, var_308_1 = DB("level_enter", arg_308_1, {
		"id",
		"type"
	})
	
	if not var_308_0 or not var_308_1 or var_308_1 ~= "hunt" and var_308_1 ~= "genie" then
		return 
	end
	
	local var_308_2 = string.sub(arg_308_1, string.len(arg_308_1) - 2, string.len(arg_308_1))
	local var_308_3 = tonumber(var_308_2)
	local var_308_4 = string.gsub(arg_308_1, var_308_2, "")
	local var_308_5
	
	if var_308_3 then
		local var_308_6 = var_308_3 + 1
		
		var_308_5 = string.format(var_308_4 .. "%03d", var_308_6)
	end
	
	if var_308_5 then
		local var_308_7, var_308_8 = DB("level_enter", var_308_5, {
			"id",
			"type"
		})
		
		if var_308_7 and var_308_8 and (var_308_8 == "hunt" or var_308_8 == "genie") then
			return var_308_5
		end
	end
end

function ClearResult.updateRetryButton(arg_309_0)
	if not arg_309_0.vars or not get_cocos_refid(arg_309_0.vars.wnd) then
		return 
	end
	
	local var_309_0 = arg_309_0.vars.wnd:getChildByName("btn_again")
	
	if get_cocos_refid(var_309_0) then
		UIUtil:setButtonEnterInfo(var_309_0, arg_309_0.vars.result.map_id)
	end
	
	arg_309_0:updateDifficultyButton(arg_309_0.vars.wnd, arg_309_0.vars.result.map_id)
	
	local var_309_1 = arg_309_0.vars.wnd:getChildByName("btn_tower_next")
	
	if get_cocos_refid(var_309_1) then
		UIUtil:setButtonEnterInfo(var_309_1, arg_309_0.vars.result.map_id, {
			automaton_free_enter = arg_309_0.vars.result.is_automaton_cleared
		})
		arg_309_0:showFreeTipUI()
	end
	
	local var_309_2 = arg_309_0.vars.wnd:getChildByName("btn_hell_next")
	
	if get_cocos_refid(var_309_2) then
		UIUtil:setButtonEnterInfo(var_309_2, arg_309_0.vars.result.map_id)
	end
end

function ClearResult.initResultSellMode(arg_310_0)
	if not arg_310_0.vars or not arg_310_0.childs or not get_cocos_refid(arg_310_0.childs.n_reward) then
		return 
	end
	
	arg_310_0.vars.n_reward = arg_310_0.childs.n_reward
	arg_310_0.vars.sellItems = {}
	arg_310_0.vars.sellMode = false
	
	if_set_visible(arg_310_0.childs.n_reward, "n_btn_delete", true)
	if_set_visible(arg_310_0.childs.n_reward, "btn_delete", true)
	if_set_visible(arg_310_0.childs.n_reward, "btn_delete_after", false)
	if_set_visible(arg_310_0.childs.n_reward, "n_sell_mode", false)
end

function ClearResult.offSellMode(arg_311_0)
	if not arg_311_0.vars or arg_311_0.vars.sellMode == nil then
		return 
	end
	
	if arg_311_0.vars.sellMode and arg_311_0.childs and get_cocos_refid(arg_311_0.childs.n_reward) then
		ClearResult:toggleResultSellMode(false)
	end
end

function ClearResult.toggleResultSellMode(arg_312_0, arg_312_1)
	if not arg_312_0.vars or not arg_312_0.childs or not get_cocos_refid(arg_312_0.childs.n_reward) then
		return 
	end
	
	if arg_312_1 == nil then
		arg_312_1 = not arg_312_0.vars.sellMode
	end
	
	if arg_312_0.vars.isSubCusExist then
		if_set_visible(arg_312_0.childs.n_reward, "n_custom", not arg_312_1)
	end
	
	if_set_visible(arg_312_0.childs.n_reward, "btn_delete", not arg_312_1)
	if_set_visible(arg_312_0.childs.n_reward, "btn_delete_after", arg_312_1)
	if_set_visible(arg_312_0.childs.n_reward, "n_sell_mode", arg_312_1)
	if_set_visible(arg_312_0.childs.n_reward, "btn_stat", not arg_312_1)
	if_set_visible(arg_312_0.childs.n_reward, "btn_go", not arg_312_1)
	
	if arg_312_0.vars.result and arg_312_0.vars.result.crehunt then
		local var_312_0 = arg_312_0.childs.n_reward:getChildByName("RIGHT")
		
		if_set_visible(var_312_0, "n_crevice", not arg_312_1)
		if_set_visible(var_312_0, "btn_next", not arg_312_1)
	end
	
	if arg_312_0.vars.is_view_get_cp then
		if_set_visible(arg_312_0.childs.n_reward, "contr_point", not arg_312_1)
	end
	
	if_set(arg_312_0.childs.n_reward, "txt_sell_price", 0)
	arg_312_0:toggleAllIcons(arg_312_1)
	
	if not arg_312_0.vars.n_scrollview then
		arg_312_0.vars.n_scrollview = arg_312_0.childs.n_reward:getChildByName("scrollview_item")
		arg_312_0.vars.scrollOriginSize = arg_312_0.vars.n_scrollview:getContentSize()
	end
	
	if not arg_312_1 then
		arg_312_0:resetSelectItems()
		arg_312_0:setSize(arg_312_0.vars.scrollOriginSize.width, arg_312_0.vars.scrollOriginSize.height, true, false)
	else
		arg_312_0:setSize(arg_312_0.vars.scrollOriginSize.width, arg_312_0.vars.scrollOriginSize.height - 40, true, false)
	end
	
	arg_312_0:jumpToPercent(0)
	
	arg_312_0.vars.sellMode = arg_312_1
end

function ClearResult.toggleAllIcons(arg_313_0, arg_313_1)
	if not arg_313_0.ScrollViewItems then
		return 
	end
	
	if arg_313_1 == nil then
		arg_313_1 = not arg_313_0.vars.sellMode
	end
	
	local var_313_0 = arg_313_1 and 76.5 or 255
	
	for iter_313_0, iter_313_1 in pairs(arg_313_0.ScrollViewItems) do
		local var_313_1 = iter_313_1.item.code and string.starts(iter_313_1.item.code, "e")
		local var_313_2 = var_313_1
		
		if var_313_1 then
			local var_313_3 = Account:getEquip(iter_313_1.item.id)
			
			if var_313_3 then
				var_313_2 = var_313_2 and not var_313_3:isForceLock()
			end
		end
		
		if_set_opacity(iter_313_1.control, nil, var_313_2 and 255 or var_313_0)
		
		if not arg_313_1 then
			if_set_visible(iter_313_1.control, "n_select", false)
			if_set_visible(iter_313_1.control, "icon_dont", false)
		end
	end
	
	if arg_313_1 then
		arg_313_0:updateResultSellMode()
	end
end

function ClearResult.selectItem(arg_314_0, arg_314_1)
	if not arg_314_0.vars or not arg_314_0.vars.sellMode or not arg_314_1 then
		return 
	end
	
	if not arg_314_1.id or arg_314_1.code and not string.starts(arg_314_1.code, "e") then
		balloon_message_with_sound("equip_sell_error")
		arg_314_0:toggleResultSellMode(false)
		
		return 
	end
	
	local var_314_0 = Account:getEquip(arg_314_1.id)
	
	if not var_314_0 or not var_314_0.isEquip or var_314_0.isArtifact and var_314_0:isArtifact() then
		balloon_message_with_sound("equip_sell_error")
		arg_314_0:toggleResultSellMode(false)
		
		return 
	end
	
	if var_314_0 and var_314_0.isForceLock and var_314_0:isForceLock() then
		balloon_message_with_sound("err_cannot_sell_equip")
		arg_314_0:toggleResultSellMode(false)
		
		return 
	end
	
	var_314_0.isSelected = not var_314_0.isSelected
	
	arg_314_0:setIconSelect(var_314_0, var_314_0.isSelected)
	
	if var_314_0.isSelected then
		table.insert(arg_314_0.vars.sellItems, var_314_0)
	else
		local var_314_1
		
		for iter_314_0, iter_314_1 in pairs(arg_314_0.vars.sellItems) do
			if iter_314_1.id == var_314_0.id then
				var_314_1 = iter_314_0
				
				break
			end
		end
		
		if var_314_1 then
			table.remove(arg_314_0.vars.sellItems, var_314_1)
		end
	end
	
	arg_314_0:updateResultSellMode()
end

function ClearResult.sellItems(arg_315_0, arg_315_1)
	if not arg_315_0.vars or not arg_315_0.vars.sellMode or table.empty(arg_315_0.vars.sellItems) or not arg_315_1 then
		return 
	end
	
	local var_315_0 = {}
	
	if arg_315_1 == 1 then
		for iter_315_0, iter_315_1 in pairs(arg_315_0.vars.sellItems) do
			table.insert(var_315_0, iter_315_1:getUID())
		end
		
		local var_315_1 = arg_315_0:calcPrice()
		
		GlobalGetSellDialog(var_315_1, nil, var_315_0, "result", function()
			if BattleRepeat:getPetRepeatItems() then
				BattleRepeat:refreshItems(var_315_0)
			else
				arg_315_0:refreshAfterSellItems(var_315_0)
			end
		end)
	elseif arg_315_1 == 2 then
		for iter_315_2, iter_315_3 in pairs(arg_315_0.vars.sellItems) do
			if iter_315_3:isExtractable() then
				table.insert(var_315_0, iter_315_3:getUID())
			end
		end
		
		Inventory:extractUtil(arg_315_0.vars.sellItems, "result", function()
			if BattleRepeat:getPetRepeatItems() then
				BattleRepeat:refreshItems(var_315_0)
			else
				arg_315_0:refreshAfterSellItems(var_315_0)
			end
		end)
	end
end

function ClearResult.MSG_sell_equips(arg_318_0, arg_318_1)
	if arg_318_1.total_powder and arg_318_1.total_powder > 0 then
		balloon_message_with_sound("equip_sell_gold2", {
			price = comma_value(arg_318_1.total_price),
			price2 = comma_value(arg_318_1.total_powder)
		})
	else
		balloon_message_with_sound("equip_sell_gold", {
			price = comma_value(arg_318_1.total_price)
		})
	end
end

function ClearResult.refreshAfterSellItems(arg_319_0, arg_319_1)
	if not arg_319_0.vars or not get_cocos_refid(arg_319_0.vars.wnd) then
		return 
	end
	
	arg_319_0:refreshEquipRewardTable(arg_319_1)
	arg_319_0:initScrollView(arg_319_0.childs.n_reward:getChildByName("scrollview_item"), 84, 83)
	
	local var_319_0 = UIUtil:sortDisplayItems(arg_319_0:getRewardTable(), arg_319_0.vars.result.map_id)
	
	arg_319_0:setScrollViewItems(var_319_0)
	arg_319_0:toggleResultSellMode(false)
	if_set(arg_319_0.childs.n_reward, "txt_reward_count", "+" .. #var_319_0 or 0)
end

function ClearResult.resetSelectItems(arg_320_0)
	for iter_320_0, iter_320_1 in pairs(arg_320_0.vars.sellItems) do
		iter_320_1.isSelected = false
	end
	
	arg_320_0.vars.sellItems = {}
end

function ClearResult.setIconSelect(arg_321_0, arg_321_1, arg_321_2)
	if not arg_321_1 or arg_321_2 == nil then
		return 
	end
	
	for iter_321_0, iter_321_1 in pairs(arg_321_0.ScrollViewItems) do
		if iter_321_1.item.id and iter_321_1.item.id == arg_321_1.id then
			if_set_visible(iter_321_1.control, "n_select", arg_321_2)
			
			if arg_321_2 and Account:isUnlockExtract() then
				if_set_visible(iter_321_1.control, "icon_dont", not arg_321_1:isExtractable())
				
				break
			end
			
			if_set_visible(iter_321_1.control, "icon_dont", false)
			
			break
		end
	end
end

function ClearResult.updateResultSellMode(arg_322_0)
	local var_322_0 = table.count(arg_322_0.vars.sellItems)
	local var_322_1 = Inventory:checkExtractItemList(arg_322_0.vars.sellItems)
	local var_322_2 = var_322_0 > 0 and var_322_1 and Account:isUnlockExtract()
	local var_322_3 = arg_322_0.childs.n_reward:getChildByName("btn_sell")
	
	if not Account:isUnlockExtract() then
		if_set_enabled(arg_322_0.childs.n_reward, "btn_extract", false)
		if_set_visible(arg_322_0.childs.n_reward, "btn_extract", false)
		if_set_visible(arg_322_0.childs.n_reward, "btn_sell", false)
		if_set_visible(arg_322_0.childs.n_reward, "btn_sell_jpn", true)
		
		var_322_3 = arg_322_0.childs.n_reward:getChildByName("btn_sell_jpn")
	else
		if_set_opacity(arg_322_0.childs.n_reward, "btn_extract", var_322_2 and 255 or 76.5)
		if_set_visible(arg_322_0.childs.n_reward, "btn_extract", true)
		if_set_visible(arg_322_0.childs.n_reward, "btn_sell", true)
		if_set_visible(arg_322_0.childs.n_reward, "btn_sell_jpn", false)
	end
	
	if_set_opacity(var_322_3, nil, table.count(arg_322_0.vars.sellItems) <= 0 and 76.5 or 255)
	if_set(arg_322_0.childs.n_reward, "t_selected", T("ui_extraction_select_inventory", {
		count = var_322_0
	}))
	
	local var_322_4 = var_322_0 > 0 and "#AB8759" or "#666666"
	local var_322_5 = arg_322_0.childs.n_reward:getChildByName("t_selected")
	
	if get_cocos_refid(var_322_5) then
		var_322_5:setTextColor(tocolor(var_322_4))
	end
end

function ClearResult.calcFavInfosUtil(arg_323_0, arg_323_1)
	local var_323_0 = arg_323_1 or {}
	local var_323_1 = {}
	local var_323_2 = {}
	
	for iter_323_0, iter_323_1 in pairs(var_323_0.units or {}) do
		local var_323_3 = Account:getUnit(iter_323_1.uid)
		
		if var_323_3 then
			local var_323_4, var_323_5 = var_323_3:getFavLevel()
			
			var_323_3.inst.fav = iter_323_1.f
			
			local var_323_6, var_323_7 = var_323_3:getFavLevel()
			
			var_323_2[var_323_3.db.code] = {
				prev_exp = var_323_5,
				curr_exp = var_323_7,
				prev_lv = var_323_4,
				curr_lv = var_323_6
			}
			
			if var_323_4 < var_323_6 then
				var_323_1[var_323_3.db.code] = {
					prev_level = var_323_4,
					level = var_323_6
				}
				
				ConditionContentsManager:dispatch("fav.levelup", {
					level = var_323_6,
					prev_level = var_323_4,
					code = var_323_3.db.code,
					uid = var_323_3.inst.uid
				})
			end
		end
	end
	
	return var_323_1, var_323_2
end

function ClearResult.calcPrice(arg_324_0)
	if not arg_324_0.vars or not arg_324_0.vars.sellItems then
		return 
	end
	
	local var_324_0 = 0
	
	for iter_324_0, iter_324_1 in pairs(arg_324_0.vars.sellItems) do
		if iter_324_1.isEquip then
			local var_324_1 = iter_324_1
			
			if not var_324_1:isArtifact() then
				var_324_0 = var_324_0 + calcEquipSellPrice(var_324_1)
			end
		end
	end
	
	return var_324_0 + (PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_324_0) or 0)
end

function ClearResult.isReplayMode(arg_325_0)
	if not arg_325_0.vars or not arg_325_0.vars.result then
		return 
	end
	
	return arg_325_0.vars.result.is_replay
end

function ClearResult.getReplayController(arg_326_0)
	return arg_326_0.vars.replay_controller
end

function ClearResult.toggleReplayController(arg_327_0)
	if not arg_327_0.vars then
		return 
	end
	
	if not arg_327_0.vars.replay_controller then
		arg_327_0.vars.replay_controller = UIReplayController(arg_327_0.vars.wnd, Battle.viewer, "result")
	end
	
	arg_327_0.vars.replay_controller:toggle()
end

function ClearResult.showReplayController(arg_328_0, arg_328_1)
	if not arg_328_0.vars then
		return 
	end
	
	if not arg_328_0.vars.replay_controller then
		arg_328_0.vars.replay_controller = UIReplayController(arg_328_0.vars.wnd, Battle.viewer, "result")
	end
	
	arg_328_0.vars.replay_controller:show(arg_328_1)
end

function ClearResult.hideReplayController(arg_329_0, arg_329_1)
	if not arg_329_0.vars then
		return 
	end
	
	arg_329_0.vars.replay_controller:hide(arg_329_1)
end
