Battle = {}
STAGE_MODE = {
	MOVE = "move",
	EVENT = "event",
	FINISHED = "finished",
	STAY = "stay"
}
USE_AUTO_WALKING = true

function Battle.clear(arg_1_0, arg_1_1)
	BattleUtil:collectClearUnits({
		force = true
	})
	
	arg_1_0.vars.arrange_skill = {}
	arg_1_0.vars.pause = nil
	arg_1_0.vars.reserved_damage = {}
	arg_1_0.vars.last_score = 0
	arg_1_0.vars.last_clear_new_missions = {}
	arg_1_0.vars.map_finished = false
	
	UIAction:Remove("battle")
	BattleAction:Remove("battle")
	BattleAction:Remove("battle.camera")
	BattleAction:Remove("battle.focus")
	BattleAction:Remove("battle.auto_target_focus")
	BattleAction:Remove("battle.ready")
	
	if arg_1_0.ui_vars.focus then
		local var_1_0 = arg_1_0.ui_vars.focus:getParent()
		
		if var_1_0 ~= nil then
			var_1_0:removeChild(arg_1_0.ui_vars.focus)
		end
		
		arg_1_0.ui_vars.focus:release()
		
		arg_1_0.ui_vars.focus = nil
	end
	
	BattleUI:hideAutoTargetFocusRing()
	
	if arg_1_0.logic then
		if arg_1_1 then
			BattleUtil:clearUnits(arg_1_0.logic.enemies, arg_1_0:isRestored())
		else
			BattleUtil:clearUnitVars(arg_1_0.logic.units, arg_1_0:isRestored())
		end
	end
	
	BattleField:clear()
	DungeonMissions:clear()
	clear_story()
end

function Battle.onAniEvent(arg_2_0, arg_2_1)
	EffectManager:onAniEvent(arg_2_1)
	StageStateManager:onAniEvent(arg_2_1)
end

function Battle.onEvent(arg_3_0, arg_3_1, ...)
	if arg_3_0:isRealtimeMode() or arg_3_0:isReplayMode() then
		return 
	end
	
	if not arg_3_0.logic then
		return 
	end
	
	if arg_3_1 == "Hit" then
		local var_3_0 = ({
			...
		})[1]
		
		if not var_3_0 or not var_3_0.unit then
			return 
		end
		
		local var_3_1 = var_3_0.unit
		
		Log.i("HitEvent", var_3_1, var_3_1.id, var_3_1.model, var_3_1.model:getName())
		
		local var_3_2 = {
			eff_info = var_3_0.info
		}
		local var_3_3 = arg_3_0.vars.skill_hit_info_map[var_3_1] or {}
		
		arg_3_0.logic:command({
			cmd = "HitEvent",
			unit_uid = var_3_0.unit.inst.uid,
			tot_hit = var_3_3.tot_hit,
			["*tag"] = var_3_2
		})
	elseif arg_3_1 == "Cutin" then
		for iter_3_0, iter_3_1 in pairs(arg_3_0.logic.units) do
			if iter_3_1 and iter_3_1.ui_vars and iter_3_1.ui_vars.gauge then
				iter_3_1.ui_vars.gauge:removeTextFromRoot()
			end
		end
	else
		Log.i("BATTLE", "unsupport event key " .. tostring(arg_3_1))
	end
end

function Battle.onFireEffect(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2.eff_info or {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_2.targets) do
		arg_4_0:playFireEffect(var_4_0, arg_4_2.attacker, iter_4_1, 0)
		arg_4_0:playDamageColor(iter_4_1.model)
	end
end

function Battle.canMoveable(arg_5_0, arg_5_1)
	if BattleLayout:isPaused() then
		return 
	end
	
	if not arg_5_0.logic then
		return 
	end
	
	local var_5_0 = Battle.logic:getCurrentRoadInfo()
	
	if var_5_0 and var_5_0.is_cross then
		return 
	end
	
	return true
end

function Battle.onClickNextButton(arg_6_0, arg_6_1)
	if not arg_6_0.logic then
		return 
	end
	
	arg_6_0.vars.pressed_next_button = arg_6_1
	
	if not Battle:canMoveable() then
		return 
	end
	
	set_high_fps_tick()
	
	if arg_6_1 and STAGE_MODE.MOVE == arg_6_0:getStageMode() then
		if BattleUIAction:Find("Battle.Drop.AutoCollect") or BattleUIAction:Find("battle.drop.fade_end") then
			BattleUIAction:Remove("Battle.Drop.AutoCollect")
			BattleDropManager:collectDropItem(true)
		end
		
		if BattleAction:Find("MoveButton.Press") then
			return 
		end
		
		if not arg_6_0.vars.walkable then
			return 
		end
		
		BattleLayout:setWalking(true)
		
		arg_6_0.vars.lastTouchUpTime = nil
		
		BattleUI:setIndividualShow(false)
	elseif not arg_6_1 and STAGE_MODE.MOVE == arg_6_0:getStageMode() then
		BattleLayout:setWalking(false)
		
		arg_6_0.vars.lastTouchUpTime = LAST_TICK
		
		BattleUI:setIndividualShow(true)
	end
end

function Battle.showStageTitleLabel(arg_7_0, arg_7_1)
	if arg_7_0.logic:isAbyss() then
		if arg_7_1 then
			EffectManager:Play({
				scale = 1,
				z = 999,
				fn = "ui_boss_encounter.cfx",
				layer = BGI.ui_layer,
				x = DESIGN_WIDTH / 2,
				y = DESIGN_HEIGHT * 0.5,
				action = BattleAction
			})
		else
			local var_7_0 = arg_7_0.logic:getRunningRoadEventObject()
			
			if not var_7_0 then
				return 
			end
			
			local var_7_1 = math.max(1, math.min(5, to_n(var_7_0.stage_idx)))
			
			EffectManager:Play({
				scale = 1,
				z = 999999,
				fn = "encounter_wave" .. var_7_1 .. ".cfx",
				layer = BGI.ui_layer,
				x = DESIGN_WIDTH / 2,
				y = DESIGN_HEIGHT * 0.7,
				action = BattleAction
			})
		end
	end
end

function Battle.DoMoveStage(arg_8_0, arg_8_1)
	UIOption:setBlock(false)
	
	if arg_8_0.logic:isEnded() then
		arg_8_0:setStageMode(STAGE_MODE.STAY)
		
		return 
	end
	
	if arg_8_0.logic:isPVP() or arg_8_0:getAppearMode() == "jump" or arg_8_0:getAppearMode() == "defend" then
		arg_8_0:setStageMode(STAGE_MODE.STAY)
		
		return 
	end
	
	if arg_8_0.logic:isCompletedLastRoadEvent() and arg_8_0.logic:getFinalResult() == "win" then
		error("AddExp")
		arg_8_0:setStageMode(STAGE_MODE.STAY)
		
		return 
	end
	
	BattleUI:hideGauge()
	BattleUI:setVisible(false)
	
	if not arg_8_0.logic:isSkillPreview() and not arg_8_0.logic:isPVP() and arg_8_0.logic:getStageMainType() ~= "tow" and arg_8_0.logic:getStageMainType() ~= "def" and not arg_8_0.logic:isExpeditionType() then
		BattleMapManager:show(true)
	end
	
	UIAction:Add(SEQ(COND_LOOP(DELAY(100), function()
		if not arg_8_0:isPlayingBattleAction() then
			return true
		end
	end), CALL(Battle.showGuideArrow, Battle)), arg_8_0)
	
	for iter_8_0 = 1, #arg_8_0.logic.friends do
		if not arg_8_0.logic.friends[iter_8_0]:isDead() then
			Battle:playIdleAction(arg_8_0.logic.friends[iter_8_0], "battle.move_center")
		end
	end
	
	arg_8_0:setStageMode(STAGE_MODE.MOVE)
	arg_8_0:testAutoPlayingMode()
end

function Battle.skipTurn(arg_10_0)
	if arg_10_0:isPlayingBattleAction() then
		return 
	end
	
	if arg_10_0.vars.mode ~= "ReadyAttack" then
		return 
	end
	
	local var_10_0 = arg_10_0.logic:getTurnOwner()
	
	if not var_10_0 then
		return 
	end
	
	arg_10_0:playIdleAction(var_10_0)
	
	arg_10_0.vars.call_end_turn = true
end

function Battle.syncUnitInfos(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_1:isNeedToUpdateHP() and not arg_11_1:isNPCTeam() then
		return Account:updateUnitHPs(arg_11_1.starting_friends, arg_11_2, arg_11_3)
	end
end

function Battle.saveTestBattleLogData(arg_12_0, arg_12_1)
	if PLATFORM == "win32" and DEBUG.BATTLE_VERIFY then
		local var_12_0 = SAVE:get("game.started_battle_data")
		
		var_12_0.logic = arg_12_1:exportPureLogicData()
		
		local var_12_1 = json.encode(var_12_0)
		
		io.writefile("battle.json", var_12_1)
		execute_lua_scripts("script/battle/battle.txt", "battle_verify", getenv("res.path"), var_12_1)
	end
end

function Battle.onFailed(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	STORY_SKIPPED_LIST = {}
	arg_13_4 = arg_13_4 or {}
	
	local var_13_0 = 0
	
	if arg_13_4.start_time then
		var_13_0 = os.time() - arg_13_4.start_time
	end
	
	if not arg_13_4.is_back_ground then
		if arg_13_0.vars.end_battle then
			return 
		end
		
		arg_13_0.vars.battle_state = "sended"
		arg_13_0.vars.end_battle = true
	end
	
	DungeonMissions:clear()
	
	local var_13_1 = false
	
	if not arg_13_1:isPVP() and not arg_13_1:isLotaContents() and not arg_13_1:isTutorial() and not arg_13_1:isPreviewQuest() then
		local var_13_2 = {
			duration_time = var_13_0,
			battle_uid = arg_13_1:getBattleUID(),
			is_back_ground = arg_13_4.is_back_ground,
			is_restored = arg_13_0:isRestored(),
			ignore_lack_currency = arg_13_4.ignore_lack_currency and 1 or 0
		}
		
		BattleRepeat:getRepeatBattleInfo(var_13_2)
		
		if arg_13_1:isAutomaton() then
			if arg_13_0.vars and arg_13_0.vars.giveup then
				var_13_2.atmt_giveup = true
			else
				var_13_2.automaton_resume_data = json.encode(arg_13_0:getAutomatonResumeData(arg_13_1))
			end
			
			var_13_1 = (Account:getAutomatonClearedFloor() or 1) >= to_n(string.sub(arg_13_1.map.enter, 7, -1))
		end
		
		query("lose", var_13_2)
	elseif arg_13_1:isLotaContents() then
		local var_13_3 = arg_13_1:getLotaInfo()
		
		if var_13_3.event_battle then
			query("lota_lose_event_battle", {
				battle_id = var_13_3.battle_id
			})
		else
			query("lota_lose_battle", {
				battle_id = var_13_3.battle_id
			})
		end
	elseif arg_13_1:isPVP() then
		local var_13_4 = string.split(arg_13_1.enemy_uid, ":")[1]
		local var_13_5 = var_13_0 or 0
		local var_13_6 = arg_13_1.enemy_uid
		local var_13_7 = string_hash(tostring(var_13_5 + 22052913) .. tostring(var_13_6))
		
		if arg_13_1:isTournament() then
			local var_13_8 = arg_13_1:getCurrentSubstoryID()
			
			query("tournament_clear", {
				result = -1,
				enemy_uid = arg_13_1.enemy_uid,
				substory_id = var_13_8,
				tournament_id = arg_13_1:getTournamentID(),
				status_id = var_13_7
			})
		elseif var_13_4 == "sa" then
			local var_13_9 = arg_13_1:getDeadUnitUIDList()
			
			query("pvp_sa_clear", {
				result = -1,
				enemy_uid = arg_13_1.enemy_uid,
				duration_time = var_13_0,
				status_id = var_13_7,
				giveup = arg_13_3,
				dead_count = table.count(var_13_9),
				entered_team_idx = PvpSA:enteredTeamIndex(),
				zl_battle_data = arg_13_1:getZlongBattleData()
			})
		elseif var_13_4 == "npc" then
			local var_13_10 = 0
			
			if PvpNPC.popup_mode then
				var_13_10 = 1
			end
			
			query("pvp_npc_clear", {
				result = -1,
				enemy_uid = arg_13_1.enemy_uid,
				duration_time = var_13_0,
				status_id = var_13_7,
				popup_mode = var_13_10,
				entered_team_idx = PvpSA:enteredTeamIndex(),
				zl_battle_data = arg_13_1:getZlongBattleData()
			})
		elseif var_13_4 == "cw" then
			local var_13_11 = 0
			
			if Account:getCurrentWarUId() >= 4 then
				var_13_11 = arg_13_2 and 1 or 0
			end
			
			BattleClanWar:endBattle(arg_13_1.round, var_13_11)
		end
	end
	
	if not arg_13_4.is_back_ground and arg_13_0.vars.last_dead_model_id then
		SoundEngine:play("event:/voc/character/" .. arg_13_0.vars.last_dead_model_id .. "/evt/defeat")
	end
	
	arg_13_0:saveTestBattleLogData(arg_13_1)
	arg_13_0:syncUnitInfos(arg_13_1)
	
	if not arg_13_4.is_back_ground and not arg_13_0:isRestored() then
		arg_13_0.vars.map_finished = true
		
		TutorialGuide:onBattleFailed(arg_13_1)
	end
	
	if not arg_13_4.is_back_ground then
		UIOption:UpdateScreenOnState()
		
		local var_13_12 = arg_13_1:isPreviewQuest()
		
		if not arg_13_1:isPVP() and not arg_13_1:isLotaContents() then
			local var_13_13 = arg_13_0.vars and arg_13_0.vars.giveup or arg_13_3
			
			ClearResult:show(arg_13_1, {
				lose = true,
				map_id = arg_13_1.map.enter,
				practice_mode = arg_13_1:isPracticeMode(),
				is_automaton_cleared = var_13_1,
				giveup = var_13_13,
				is_lota = arg_13_1:isLotaContents(),
				preview = var_13_12,
				is_spl = arg_13_1:isSplType()
			})
		end
	end
end

function Battle.getScore(arg_14_0, arg_14_1)
	local var_14_0 = 1
	local var_14_1 = 4
	
	for iter_14_0 = 1, 4 do
		if arg_14_1.friends[iter_14_0] and arg_14_1.friends[iter_14_0]:isDead() then
			var_14_1 = var_14_1 - 1
		end
	end
	
	return var_14_1 * 100 / 4
end

function Battle.getBattleFriends(arg_15_0)
	if arg_15_0.logic.friends then
		return arg_15_0.logic.friends
	end
end

function Battle.getBattleTick(arg_16_0)
	if arg_16_0.logic.tick then
		return arg_16_0.logic.tick
	end
end

function Battle.getProcInfoState(arg_17_0)
	if arg_17_0.vars then
		return arg_17_0.vars.mode
	end
end

function Battle.saveVerifyData(arg_18_0)
end

function Battle.checkIgnoreCurrency(arg_19_0)
	if arg_19_0.vars and arg_19_0.vars.battle_state == "begin" then
		arg_19_0.vars.ignore_lack_currency = true
	end
end

function Battle.getClearData(arg_20_0)
	local var_20_0 = {
		battle_tick = arg_20_0:getBattleTick(),
		start_time = arg_20_0.vars.start_time,
		ignore_lack_currency = arg_20_0.vars.ignore_lack_currency,
		clear_way = arg_20_0.vars.clear_way
	}
	
	if not arg_20_0.logic:isPVP() and not arg_20_0.logic:isTutorial() and not arg_20_0.logic:isExpeditionType() and not arg_20_0.logic:isLotaContents() then
		var_20_0.team_index = Account:getCurrentTeamIndex()
		var_20_0.team_point = Account:getTeamPoint(var_20_0.team_index) or 0
	end
	
	return var_20_0
end

function Battle.getFailedData(arg_21_0)
	return {
		battle_tick = arg_21_0:getBattleTick(),
		start_time = arg_21_0.vars.start_time,
		ignore_lack_currency = arg_21_0.vars.ignore_lack_currency
	}
end

function Battle.onClear(arg_22_0, arg_22_1, arg_22_2)
	arg_22_2 = arg_22_2 or {}
	
	local var_22_0 = arg_22_1.map.map
	local var_22_1 = arg_22_1.map.enter
	local var_22_2 = arg_22_1.type
	local var_22_3 = arg_22_1:getCurrentSubstoryID()
	local var_22_4
	
	if arg_22_1:isPreviewQuest() then
		local var_22_5 = arg_22_1:getMoonlightTheaterEpisodeID()
		local var_22_6 = arg_22_1:getBurningStoryID()
		
		if var_22_5 then
			query("moonlight_theater_battle_clear", {
				episode_id = var_22_5,
				enter_id = var_22_1
			})
		elseif var_22_6 then
			local var_22_7 = string.split(var_22_6, "_")
			local var_22_8 = var_22_7[1]
			local var_22_9 = var_22_7[1] .. "_" .. var_22_7[2]
			
			query("burning_story_clear", {
				substory_id = var_22_8,
				chapter_id = var_22_9,
				story_id = var_22_6
			})
		else
			local var_22_10 = {
				map_id = arg_22_1.map.enter
			}
			
			var_22_10.preview = true
			
			ClearResult:show(arg_22_1, var_22_10)
		end
		
		return 
	end
	
	local var_22_11 = true
	
	if arg_22_2.is_back_ground or arg_22_0:isRestored() then
		var_22_11 = false
	end
	
	if not arg_22_2.is_back_ground then
		BattlePopupMap:hide()
		BattleUI:hideAutoPanel()
		UIOption:setBlock(true)
		
		arg_22_0.vars.last_clear_new_missions = {}
		
		if arg_22_0.vars.end_battle then
			return 
		end
		
		arg_22_0.vars.battle_state = "sended"
		arg_22_0.vars.end_battle = true
		
		UIOption:UpdateScreenOnState()
	end
	
	local var_22_12 = arg_22_1:getRoadSectorProgress()
	local var_22_13
	
	if arg_22_1.map.friend_data and arg_22_1.map.friend_data.unit then
		var_22_13 = true
	end
	
	for iter_22_0, iter_22_1 in pairs(arg_22_1.friends) do
		iter_22_1:disapplyGrowthBoost()
	end
	
	local var_22_14 = arg_22_1:getBattleUID()
	
	if not arg_22_1:isPracticeMode() then
		local var_22_15
		local var_22_16 = arg_22_1:getTrialHallInfo()
		
		if arg_22_1:isScoreType() and var_22_16 then
			local var_22_17 = DB("level_enter", var_22_1, "score_rate") or 1
			local var_22_18 = math.floor(to_n(arg_22_1:getTrialScore()) * var_22_17)
			local var_22_19 = 0
			
			if arg_22_1:getFinalResult() == "win" then
				var_22_19 = DB("level_battlemenu_trialhall", var_22_16.id, "clear_bonus")
				var_22_19 = to_n(var_22_19)
			end
			
			local var_22_20 = var_22_18 + var_22_19
			
			for iter_22_2 = 1, 12 do
				local var_22_21 = string.format("trialhall_rank_%d", iter_22_2)
				local var_22_22, var_22_23 = DB("challenge_rank", var_22_21, {
					"rank",
					"rank_point"
				})
				
				if var_22_20 < to_n(var_22_23) then
					break
				end
				
				var_22_15 = iter_22_2
				var_22_4 = var_22_22
			end
			
			ConditionContentsManager:dispatch("battle.trialhall", {
				unique_id = var_22_14,
				score = var_22_20,
				enter_id = var_22_1,
				entertype = var_22_2
			})
		end
		
		ConditionContentsManager:dispatch("battle.alive", {
			unique_id = var_22_14,
			friends = arg_22_1.units,
			entertype = var_22_2
		})
		ConditionContentsManager:dispatch("battle.clear", {
			unique_id = var_22_14,
			time = arg_22_2.battle_tick,
			enter_id = var_22_1,
			entertype = var_22_2,
			rank_idx = var_22_15,
			info_id = arg_22_2.clear_way,
			explore_rate = var_22_12,
			is_use_support = var_22_13,
			substory_id = var_22_3,
			stage_counter = arg_22_1:getStageCounter()
		})
	end
	
	local var_22_24 = arg_22_0:getScore(arg_22_1)
	
	if arg_22_2.is_back_ground then
		print("BackGroundClear " .. var_22_24)
	else
		print("ForeGroundClear " .. var_22_24)
	end
	
	if not arg_22_2.is_back_ground then
		arg_22_0.vars.last_score = var_22_24
		
		BattleUI:setVisible(false)
	end
	
	local var_22_25
	
	if arg_22_2.start_time then
		var_22_25 = os.time() - arg_22_2.start_time
	end
	
	local var_22_26 = 0
	
	if Login:getLoginResult() and Login:getLoginResult().session then
		local var_22_27 = Login:getLoginResult().session
		local var_22_28 = (function()
			local function var_23_0(arg_24_0, arg_24_1)
				for iter_24_0, iter_24_1 in pairs(arg_24_0) do
					if type(iter_24_1) == "function" and iter_24_1 ~= arg_24_1[iter_24_0] then
						return (arg_24_0._t_name or "nil") .. ":" .. iter_24_0
					end
				end
				
				return nil
			end
			
			local var_23_1 = {
				UNIT,
				FORMULA,
				FORMULA.List,
				BattleLogic,
				SkillProc,
				State,
				StateList
			}
			
			if UIOption.base_positions then
				for iter_23_0, iter_23_1 in pairs(UIOption.base_positions) do
					local var_23_2 = var_23_0(iter_23_1.center, var_23_1[iter_23_0])
					
					if var_23_2 then
						return var_23_2
					end
				end
			else
				return var_22_27 .. "93"
			end
			
			return var_22_27
		end)()
		
		var_22_26 = string.base91encode(string.base91encode(var_22_28) or "toX<5+4{:R|+kbO") or "rr+HolpX8V6ZUn!lTdWH"
	end
	
	local var_22_29 = arg_22_1:getRateSSR()
	local var_22_30, var_22_31, var_22_32 = arg_22_1:getOmegaData()
	local var_22_33 = Slapstick:comedy()
	local var_22_34 = Slapstick:tragedy()
	
	if not arg_22_1:isPVP() and not arg_22_1:isTutorial() and not arg_22_1:isExpeditionType() and not arg_22_1:isLotaContents() then
		local var_22_35, var_22_36, var_22_37 = DB("level_enter", var_22_1, {
			"type",
			"local_num",
			"difficulty_id"
		})
		local var_22_38 = DB("level_difficulty", var_22_37, {
			"id"
		}) or var_22_1
		
		if WORLDMAP_MODE_LIST[var_22_35] and not arg_22_2.is_back_ground then
			WorldMapManager:getController():saveLastTown(var_22_38)
		end
		
		local var_22_39
		local var_22_40
		local var_22_41 = 0
		local var_22_42 = 0
		local var_22_43
		local var_22_44 = arg_22_1:getEnteredRoadSectorTbl()
		
		for iter_22_3, iter_22_4 in pairs(Account:getPassEvent(arg_22_1.map.enter) or {}) do
			if iter_22_4 then
				var_22_41 = var_22_41 + 1
			end
		end
		
		for iter_22_5, iter_22_6 in pairs(var_22_44) do
			if iter_22_6 then
				var_22_42 = var_22_42 + 1
			end
		end
		
		local var_22_45
		local var_22_46 = 0
		
		if arg_22_1:getStageMainType() == "adv" then
			var_22_45 = arg_22_1:getTotalRoadSectorCount()
			
			if var_22_41 < var_22_42 then
				var_22_43 = json.encode(var_22_44)
				
				if not arg_22_2.is_back_ground then
					arg_22_0.vars.prev_pass_way_percent = var_22_41 / arg_22_1:getTotalRoadSectorCount() * 100
				end
			end
			
			var_22_46 = var_22_42 / var_22_45
			var_22_46 = math.is_nan_or_inf(var_22_46) and 0 or var_22_46
		end
		
		arg_22_0:savePassedWay(arg_22_1)
		
		local var_22_47 = AccountData.last_clear_land
		local var_22_48
		local var_22_49, var_22_50, var_22_51 = DB("level_world_3_chapter", var_22_47, {
			"clear_enter",
			"next_chapter",
			"urgent_order"
		})
		local var_22_52 = DB("level_world_3_chapter", var_22_50, {
			"urgent_order"
		})
		
		if var_22_49 == arg_22_1.map.enter and var_22_51 and var_22_52 and tonumber(var_22_51) < tonumber(var_22_52) then
			var_22_48 = var_22_50
		end
		
		local var_22_53 = ConditionContentsManager:getUpdateConditions() and json.encode()
		local var_22_54 = arg_22_1:getRoadEventResultsAll()
		local var_22_55 = not table.empty(var_22_54) and json.encode(var_22_54) or nil
		local var_22_56
		local var_22_57 = arg_22_1:getCampingData()
		
		if not table.empty(var_22_57) then
			var_22_56 = json.encode(var_22_57)
		end
		
		local var_22_58 = {}
		local var_22_59 = arg_22_2.team_index
		
		if arg_22_2.team_point <= (BattleReady:GetReqPointAndRewards(var_22_1) or 0) then
			for iter_22_7, iter_22_8 in pairs(Account:getTeam(var_22_59) or {}) do
				if iter_22_8.is_unit and iter_22_8.status then
					local var_22_60 = table.copyElement(iter_22_8.status, {
						"att",
						"acc",
						"def",
						"max_hp",
						"speed",
						"cri",
						"cri_dmg",
						"res",
						"coop"
					})
					
					var_22_60.pos = iter_22_7
					
					table.insert(var_22_58, var_22_60)
				end
			end
		end
		
		local var_22_61 = BattleUtil:getPlayingEpisode() or {}
		local var_22_62 = {
			status_id = 0,
			cs_mode = 0,
			map = arg_22_1.map.enter,
			score = var_22_24,
			open_land = var_22_48,
			cleared_events = array_to_json(arg_22_1:getOldTypeCompletedRoadEventList()),
			completed_events = array_to_json(arg_22_1:getCompletedRoadEventList(true)),
			event_results = var_22_55,
			update_conditions = var_22_53,
			pass_events = var_22_43,
			total_event = var_22_45,
			progress = var_22_46,
			status_infos = json.encode(var_22_58),
			played_stories = var_22_11 and array_to_json(BattleStory:getPlayedList()),
			camping_data = var_22_11 and var_22_56,
			duration_time = var_22_25,
			stage_clear_id = var_22_26,
			convic = array_to_json(g_UNIT_CONVIC),
			battle_uid = arg_22_1:getBattleUID(),
			ur_rate = arg_22_1:getMaxDamage(),
			ssr_rate = var_22_29,
			join_units = arg_22_1:getJoinUnitLog(),
			is_restored = arg_22_0:isRestored(),
			is_back_ground = arg_22_2.is_back_ground,
			ignore_lack_currency = arg_22_2.ignore_lack_currency and 1 or 0,
			crehunt_return = arg_22_1:getCreviceReturn(),
			crehunt_chp = arg_22_1:getCreviceLastHP(),
			episode_log = json.encode(var_22_61),
			omega_sea = var_22_30,
			omega_sm = var_22_31,
			omega_moon = var_22_32,
			slap_c = array_to_json(var_22_33),
			slap_t = array_to_json(var_22_34)
		}
		
		if var_22_11 and STORY_SKIPPED_LIST and table.count(STORY_SKIPPED_LIST) > 0 then
			var_22_62.skipped_story = array_to_json(STORY_SKIPPED_LIST)
			STORY_SKIPPED_LIST = {}
		end
		
		var_22_62.substory_id = arg_22_1:getCurrentSubstoryID()
		
		local var_22_63 = var_22_25 or 0
		local var_22_64 = arg_22_1:getBattleCheckUID()
		
		var_22_62.status_id = string_hash(var_22_63 + var_22_64 + 22053152)
		g_UNIT_CONVIC = {}
		var_22_62.clear_way = arg_22_2.clear_way
		var_22_62.rest_hps = json.encode(arg_22_0:syncUnitInfos(arg_22_1, nil, true))
		var_22_62.replay_data = arg_22_1:getBattleReplayData()
		
		if arg_22_1:isSplType() and arg_22_1:getSplInfo() then
			var_22_62.spl_info = json.encode(arg_22_1:getSplInfo())
		end
		
		local var_22_65 = arg_22_1:getMoraleVariant()
		local var_22_66 = arg_22_1:getMoraleValue("min")
		local var_22_67 = arg_22_1:getMoraleValue("max")
		
		if var_22_65 > (math.abs(var_22_66) + var_22_67) * 2 then
			var_22_62.m_variant = var_22_65
		end
		
		if arg_22_1:isScoreType() then
			local var_22_68 = arg_22_1:getTrialHallInfo()
			
			if var_22_68 and var_22_68.id then
				var_22_62.trial_id = var_22_68.id
				var_22_62.trial_rank = var_22_4
				
				local var_22_69 = DB("level_enter", var_22_1, "score_rate") or 1
				
				var_22_62.trial_score = math.floor(to_n(arg_22_1:getTrialScore()) * var_22_69)
			end
			
			if arg_22_1:getFinalResult() ~= "win" then
				var_22_62.trial_state = "failed"
			end
		end
		
		local var_22_70 = arg_22_1:getLatte()
		
		var_22_62.latte = array_to_json(var_22_70)
		var_22_62.peak_speed = arg_22_1:getPeakSpeed()
		var_22_62.mocha = array_to_json(arg_22_1:checkUnitStat())
		var_22_62.stat_list = json.encode(arg_22_1:getUnitPeakStat() or {})
		
		BattleRepeat:getRepeatBattleInfo(var_22_62)
		
		if var_22_62 and var_22_62.repeat_count and var_22_62.repeat_count == 0 then
			BattleTopBar:setDisabledBackPlayBtn()
		end
		
		if arg_22_1:isAutomaton() then
			local var_22_71 = arg_22_0:getAllysInfo(arg_22_1)
			
			var_22_62.ally_datas = json.encode(var_22_71)
			
			if DEBUG.AUTOMATON_ROATION_CHEAT then
				var_22_62.atmt_round = AutomatonUtil:_dev_get_cheat_rotation()
			end
		end
		
		query("clear", var_22_62)
		
		if not arg_22_2.is_back_ground then
			BattleMapManager:show(false)
			UIBattleGuideArrow:hide()
		end
		
		if arg_22_0:getNextDungeon(arg_22_1) and not string.starts(arg_22_1.type or "", "dungeon") and not arg_22_2.is_back_ground then
			BattleField:addWarpLine("finishToNext")
			BattleField:addWarpLine("finishToLobby")
			BattleField:lockViewPortRange(true, {
				maxOffsetX = 0,
				minOffsetX = -DESIGN_WIDTH / 2
			})
		end
	elseif arg_22_1:isLotaExpeditionType() then
		local var_22_72 = arg_22_1:getLotaInfo()
		local var_22_73 = {}
		
		for iter_22_9, iter_22_10 in pairs(arg_22_1.starting_friends) do
			table.insert(var_22_73, iter_22_10:getUID())
		end
		
		local var_22_74 = {
			battle_id = var_22_72.battle_id,
			party = json.encode(var_22_73),
			peak_speed = arg_22_1:getPeakSpeed(),
			accum_damage = arg_22_1:getExpeditionScore(),
			ur_rate = arg_22_1:getMaxDamage(),
			ssr_rate = arg_22_1:getRateSSR(),
			mocha = array_to_json(arg_22_1:checkUnitStat()),
			convic = array_to_json(g_UNIT_CONVIC),
			map = arg_22_1.map.enter
		}
		
		query("lota_clear_coop_battle", var_22_74)
	elseif arg_22_1:isExpeditionType() then
		local var_22_75 = {}
		local var_22_76 = arg_22_1:getExpeditionInfo()
		local var_22_77 = arg_22_1:getLatte()
		
		var_22_75.latte = array_to_json(var_22_77)
		var_22_75.peak_speed = arg_22_1:getPeakSpeed()
		var_22_75.mocha = array_to_json(arg_22_1:checkUnitStat())
		var_22_75.stat_list = json.encode(arg_22_1:getUnitPeakStat() or {})
		var_22_75.map = arg_22_1.map.enter
		var_22_75.boss_id = var_22_76.boss_id
		var_22_75.accum_damage = arg_22_1:getExpeditionScore()
		var_22_75.total_score = arg_22_1:getExpeditionTotalScore()
		var_22_75.battle_uid = arg_22_1:getBattleUID()
		var_22_75.convic = array_to_json(g_UNIT_CONVIC)
		var_22_75.ur_rate = arg_22_1:getMaxDamage()
		var_22_75.ssr_rate = arg_22_1:getRateSSR()
		
		local var_22_78 = arg_22_1:getExpeditionTotalScore() or 0
		
		ConditionContentsManager:dispatch("battle.expedition", {
			unique_id = arg_22_1:getBattleUID(),
			score = var_22_78,
			enter_id = var_22_1,
			entertype = arg_22_1.type
		})
		
		local var_22_79 = ConditionContentsManager:getUpdateConditions() and json.encode()
		
		var_22_75.update_conditions = var_22_79
		var_22_75.join_units = arg_22_1:getJoinUnitLog()
		
		local var_22_80 = BattleUtil:getPlayingEpisode() or {}
		
		var_22_75.episode_log = json.encode(var_22_80)
		
		query("coop_clear", var_22_75)
	elseif arg_22_1:isRealtimeMode() then
		if arg_22_0.viewer then
			ArenaService:battleClear(arg_22_0.viewer:getResult(), arg_22_0.viewer:isSpectator(), true)
			arg_22_0:getBroadCastResultData(arg_22_0.viewer:getMatchInfo(), arg_22_0.viewer:getResult())
		end
	elseif arg_22_1:isPVP() then
		local var_22_81 = string.split(arg_22_1.enemy_uid, ":")[1]
		local var_22_82 = var_22_25 or 0
		local var_22_83 = arg_22_1.enemy_uid
		local var_22_84 = string_hash(tostring(var_22_82 + 22052913) .. tostring(var_22_83))
		local var_22_85 = BattleUtil:getPlayingEpisode() or {}
		
		episode_log = json.encode(var_22_85)
		
		if arg_22_1:isTournament() then
			local var_22_86 = arg_22_1:getCurrentSubstoryID()
			
			query("tournament_clear", {
				result = 1,
				enemy_uid = arg_22_1.enemy_uid,
				duration_time = var_22_25,
				substory_id = var_22_86,
				tournament_id = arg_22_1:getTournamentID(),
				status_id = var_22_84,
				stage_clear_id = var_22_26,
				convic = array_to_json(g_UNIT_CONVIC),
				ssr_rate = var_22_29
			})
			
			g_UNIT_CONVIC = {}
		elseif var_22_81 == "sa" then
			local var_22_87 = arg_22_1:getDeadUnitUIDList()
			
			query("pvp_sa_clear", {
				result = 1,
				enemy_uid = arg_22_1.enemy_uid,
				duration_time = var_22_25,
				status_id = var_22_84,
				replay_data = arg_22_1:getBattleReplayData(),
				stage_clear_id = var_22_26,
				convic = array_to_json(g_UNIT_CONVIC),
				ssr_rate = var_22_29,
				dead_count = table.count(var_22_87),
				entered_team_idx = PvpSA:enteredTeamIndex(),
				join_units = arg_22_1:getJoinUnitLog(true),
				episode_log = episode_log,
				zl_battle_data = arg_22_1:getZlongBattleData(),
				slap_c = array_to_json(var_22_33),
				slap_t = array_to_json(var_22_34)
			})
			
			g_UNIT_CONVIC = {}
		elseif var_22_81 == "npc" then
			local var_22_88 = 0
			
			if PvpNPC.popup_mode then
				var_22_88 = 1
			end
			
			query("pvp_npc_clear", {
				result = 1,
				enemy_uid = arg_22_1.enemy_uid,
				duration_time = var_22_25,
				status_id = var_22_84,
				replay_data = arg_22_1:getBattleReplayData(),
				stage_clear_id = var_22_26,
				convic = array_to_json(g_UNIT_CONVIC),
				ssr_rate = var_22_29,
				popup_mode = var_22_88,
				entered_team_idx = PvpSA:enteredTeamIndex(),
				episode_log = episode_log,
				zl_battle_data = arg_22_1:getZlongBattleData()
			})
			
			g_UNIT_CONVIC = {}
		elseif var_22_81 == "cw" then
			BattleClanWar:endBattle(arg_22_1.round, 2, var_22_26, array_to_json(g_UNIT_CONVIC))
			
			g_UNIT_CONVIC = {}
		end
	elseif arg_22_1:isLotaContents() then
		local var_22_89 = arg_22_1:getLotaInfo()
		local var_22_90 = {}
		
		for iter_22_11, iter_22_12 in pairs(arg_22_1.starting_friends) do
			table.insert(var_22_90, iter_22_12:getUID())
		end
		
		local var_22_91 = {
			peak_speed = arg_22_1:getPeakSpeed(),
			mocha = array_to_json(arg_22_1:checkUnitStat()),
			map = arg_22_1.map.enter,
			battle_id = var_22_89.battle_id,
			party = json.encode(var_22_90)
		}
		
		if var_22_89.event_battle then
			query("lota_clear_event_battle", var_22_91)
		else
			query("lota_clear_battle", var_22_91)
		end
	end
	
	if false then
	end
	
	arg_22_0:saveTestBattleLogData(arg_22_1)
	
	if not arg_22_2.is_back_ground then
		arg_22_0.vars.map_finished = true
	end
	
	if arg_22_1:isTutorial() and not arg_22_0.vars.tutorial_clear then
		arg_22_0.vars.tutorial_clear = true
		
		TutorialBattle:onClearTutorialBattle()
	end
end

function Battle.onshowClearResult(arg_25_0, ...)
	local var_25_0 = 0
	
	if arg_25_0.logic and arg_25_0.logic:getCreviceReturn() then
		var_25_0 = 1000
	end
	
	Action:Add(SEQ(DELAY(var_25_0), CALL(ClearResult.show, ClearResult, ...)), arg_25_0, "block")
end

function Battle.getAutomatonResumeData(arg_26_0, arg_26_1)
	local var_26_0
	
	if arg_26_0:getStartTime() then
		var_26_0 = os.time() - arg_26_0:getStartTime()
	end
	
	local var_26_1 = 0
	
	if Login:getLoginResult() and Login:getLoginResult().session then
		local var_26_2 = Login:getLoginResult().session
		local var_26_3 = (function()
			local function var_27_0(arg_28_0)
				local var_28_0 = ""
				
				for iter_28_0, iter_28_1 in pairs(arg_28_0) do
					if type(iter_28_1) == "function" then
						var_28_0 = var_28_0 .. tostring(iter_28_1):sub(10)
					end
				end
				
				return crc32_string(var_28_0, 322253091)
			end
			
			local var_27_1 = {
				UNIT,
				FORMULA,
				FORMULA.List,
				BattleLogic,
				SkillProc,
				State,
				StateList
			}
			
			if UIOption.base_positions then
				for iter_27_0, iter_27_1 in pairs(UIOption.base_positions) do
					if iter_27_1.center ~= var_27_0(var_27_1[iter_27_0]) then
						return var_26_2 .. tostring(iter_27_0)
					end
				end
			else
				return var_26_2 .. "93"
			end
			
			return var_26_2 .. #var_26_2
		end)()
		
		var_26_1 = string_hash(var_26_3)
	end
	
	local var_26_4 = arg_26_1.map.map
	local var_26_5 = arg_26_1.map.enter
	local var_26_6 = arg_26_1:getRateSSR()
	local var_26_7
	local var_26_8 = 0
	local var_26_9 = 0
	local var_26_10
	local var_26_11 = arg_26_1:getEnteredRoadSectorTbl()
	
	for iter_26_0, iter_26_1 in pairs(Account:getPassEvent(arg_26_1.map.enter) or {}) do
		if iter_26_1 then
			var_26_8 = var_26_8 + 1
		end
	end
	
	for iter_26_2, iter_26_3 in pairs(var_26_11) do
		if iter_26_3 then
			var_26_9 = var_26_9 + 1
		end
	end
	
	arg_26_0:savePassedWay(arg_26_1)
	
	local var_26_12 = {}
	local var_26_13 = Account:getCurrentTeamIndex()
	
	if (Account:getTeamPoint(var_26_13) or 0) <= (BattleReady:GetReqPointAndRewards(var_26_5) or 0) then
		for iter_26_4, iter_26_5 in pairs(Account:getTeam(var_26_13) or {}) do
			if iter_26_5.is_unit and iter_26_5.status then
				local var_26_14 = table.copyElement(iter_26_5.status, {
					"att",
					"acc",
					"def",
					"max_hp",
					"speed",
					"cri",
					"cri_dmg",
					"res",
					"coop"
				})
				
				var_26_14.pos = iter_26_4
				
				table.insert(var_26_12, var_26_14)
			end
		end
	end
	
	local var_26_15
	local var_26_16 = 0
	local var_26_17 = arg_26_1:getTotalRoadSectorCount()
	
	if var_26_8 < var_26_9 then
		var_26_10 = json.encode(var_26_11)
		arg_26_0.vars.prev_pass_way_percent = var_26_8 / arg_26_1:getTotalRoadSectorCount() * 100
	end
	
	local var_26_18 = var_26_9 / var_26_17
	local var_26_19
	
	var_26_19 = math.is_nan_or_inf(var_26_18) and 0 or var_26_19
	
	local var_26_20 = {
		status_id = 0,
		map = arg_26_1.map.enter,
		cleared_events = array_to_json(arg_26_1:getOldTypeCompletedRoadEventList()),
		completed_events = array_to_json(arg_26_1:getCompletedRoadEventList(true)),
		current_sector_id = arg_26_1.battle_info.road_info.current_sector_id,
		current_event_id = arg_26_1:getRunningRoadEventObject().event_id,
		pass_events = var_26_10,
		status_infos = json.encode(var_26_12),
		duration_time = var_26_0,
		stage_clear_id = var_26_1,
		convic = array_to_json(g_UNIT_CONVIC),
		battle_uid = arg_26_1:getBattleUID(),
		ur_rate = arg_26_1:getMaxDamage(),
		ssr_rate = var_26_6
	}
	local var_26_21 = var_26_0 or 0
	local var_26_22 = arg_26_1:getBattleCheckUID()
	
	var_26_20.status_id = string_hash(var_26_21 + var_26_22 + 22053152)
	g_UNIT_CONVIC = {}
	
	if arg_26_0.vars.clear_way then
		var_26_20.clear_way = arg_26_0.vars.clear_way
	end
	
	var_26_20.rest_hps = json.encode(arg_26_0:syncUnitInfos(arg_26_1))
	var_26_20.replay_data = arg_26_1:getBattleReplayData()
	
	local var_26_23 = arg_26_1:getLatte()
	
	var_26_20.latte = array_to_json(var_26_23)
	var_26_20.peak_speed = arg_26_1:getPeakSpeed()
	var_26_20.mocha = array_to_json(arg_26_1:checkUnitStat())
	var_26_20.stat_list = json.encode(arg_26_1:getUnitPeakStat() or {})
	var_26_20.road_event_run_info = arg_26_0.road_event_run_info
	var_26_20.mobs = arg_26_0:getMobsInfo(arg_26_1)
	var_26_20.mobs = json.encode(var_26_20.mobs)
	
	local var_26_24 = arg_26_0:getAllysInfo(arg_26_1)
	
	var_26_20.ally_datas = json.encode(var_26_24)
	
	return var_26_20
end

function Battle.getMobsInfo(arg_29_0, arg_29_1)
	local var_29_0 = {}
	local var_29_1 = {
		named = 4,
		elite = 3,
		boss = 6,
		subboss = 5,
		dummy = 0,
		magic = 1,
		normal = 2
	}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_1.enemies) do
		local var_29_2 = math.floor(iter_29_1:getRawHPRatio() * 1000)
		
		while var_29_2 / 1000 * iter_29_1:getMaxHP() < iter_29_1.inst.hp do
			var_29_2 = var_29_2 + 1
		end
		
		local var_29_3 = {
			code = iter_29_1.inst.code,
			lv = iter_29_1.inst.lv,
			g = iter_29_1.inst.grade,
			p = iter_29_1.inst.power,
			pos = iter_29_1.inst.pos,
			line = iter_29_1.inst.line,
			monster_tier = var_29_1[iter_29_1.db.tier] or 2,
			h = var_29_2,
			drop = iter_29_1.drop,
			gold = iter_29_1.gold
		}
		
		if iter_29_1.inst.code == "cleardummy" then
		end
		
		table.insert(var_29_0, var_29_3)
	end
	
	return var_29_0
end

function Battle.getAllysInfo(arg_30_0, arg_30_1)
	local var_30_0 = {}
	
	for iter_30_0, iter_30_1 in pairs(arg_30_1.friends) do
		local var_30_1 = math.floor(iter_30_1:getRawHPRatio() * 1000)
		
		while var_30_1 / 1000 * iter_30_1:getMaxHP() < iter_30_1.inst.hp do
			var_30_1 = var_30_1 + 1
		end
		
		var_30_0[iter_30_1:getUID()] = var_30_1
		
		local var_30_2 = Account:getUnit(iter_30_1:getUID())
		
		if var_30_2 then
			var_30_2:setAutomatonHPRatio(var_30_1)
			Account:setAutomatonHPInfo(var_30_2:getUID(), var_30_1)
		end
	end
	
	return var_30_0
end

function Battle.isPlayingBattleAction(arg_31_0)
	return StageStateManager:isRunning() or BattleAction:Find("battle") or BattleAction:Find("battle.skill") or BattleAction:Find("battle.camera") or BattleAction:Find("battle.damage_motion") or BattleAction:Find("battle.appear") or BattleAction:Find("battle.hidden_appear") or BattleAction:Find("battle.proc_action") or BattleAction:Find("battle.change_map") or BattleAction:Find("battle.crevice_return")
end

function Battle.doWalkUpdate(arg_32_0)
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return 
	end
	
	if ShopRandom:isVisible() then
		BattleLayout:setWalking(false)
		
		return 
	end
	
	if BattleLayout:isWalking() then
		set_high_fps_tick()
	end
	
	if TutorialGuide:isNeedAutoMove() then
		BattleLayout:setDirection(1)
		BattleLayout:setWalking(true)
		
		return 
	end
	
	local var_32_0 = (arg_32_0.logic:getCurrentRoadInfo() or {}).road_reverse and -1 or 1
	
	if arg_32_0.vars.reverseMoveTime and BattleLayout:getDirection() == var_32_0 then
		arg_32_0.vars.reverseMoveTime = nil
		
		BGI.ui_layer:removeChildByName("warn_msg")
	elseif not arg_32_0.vars.reverseMoveTime and BattleLayout:getDirection() == var_32_0 * -1 then
		if not arg_32_0.vars.reverseMoveTime then
			arg_32_0.vars.reverseMoveTime = LAST_TICK
		end
		
		balloon_message_with_sound("msg_wrong_way")
	elseif arg_32_0.vars.reverseMoveTime and LAST_TICK - arg_32_0.vars.reverseMoveTime > 2000 then
		arg_32_0.vars.reverseMoveTime = LAST_TICK
		
		balloon_message_with_sound("msg_wrong_way")
	end
	
	if BattleAction:Find("battle.shotchange") then
		return 
	end
	
	if arg_32_0.vars.lastTouchUpTime then
		if arg_32_0:isAutoPlaying() then
			if LAST_TICK - arg_32_0.vars.lastTouchUpTime >= 1500 then
				arg_32_0.vars.lastTouchUpTime = nil
				arg_32_0.vars.auto_walking = true
				
				arg_32_0:startAutoBattle()
				
				return 
			end
		else
			arg_32_0.vars.lastTouchUpTime = nil
		end
	end
	
	arg_32_0.vars.move_goal = arg_32_0.vars.move_goal or 2
	
	if not arg_32_0.vars.prev_walk_anchor then
		arg_32_0.vars.prev_walk_anchor = BGI.walk_anchor
	end
	
	arg_32_0.vars.move_length = BGI.walk_anchor - arg_32_0.vars.prev_walk_anchor
	
	if DEBUG.DEBUG_MOVE then
		DEBUG.DEBUG_MOVE = nil
		
		print("self.vars.move_length >= self.vars.move_goal", arg_32_0.vars.move_length >= arg_32_0.vars.move_goal, arg_32_0.vars.move_length, arg_32_0.vars.move_goal)
	end
	
	arg_32_0.vars.walkable = true
	
	if not DEBUG.DEBUG_BG and not DEBUG.TEST_BG and arg_32_0.vars.move_length >= arg_32_0.vars.move_goal then
		if arg_32_0.logic.object and get_cocos_refid(arg_32_0.logic.object.model) then
			local var_32_1 = arg_32_0.logic.object.model:getPositionX()
			local var_32_2 = arg_32_0.logic:getWayDataByPrepend()
			
			if STAGE_MODE.MOVE == arg_32_0:getStageMode() and arg_32_0.logic:isCompletedLastRoadEvent() and (var_32_2.type == "gate_treasure" or var_32_1 < DESIGN_WIDTH / 2) then
				arg_32_0:onClickNextButton(false)
				
				arg_32_0.vars.walkable = false
			end
			
			arg_32_0:removeGuideUI()
		end
		
		arg_32_0:setStageMode(STAGE_MODE.STAY)
		
		arg_32_0.vars.prev_walk_anchor = BGI.walk_anchor
	end
end

function Battle.updateProcess(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	arg_33_0.logic:updateProcessDelta()
	
	if arg_33_0:isPlayingBattleAction() then
		set_high_fps_tick()
		
		return 
	end
	
	if ShopRandom:isVisible() then
		return 
	end
	
	if arg_33_0:getStageMode() == STAGE_MODE.MOVE then
		arg_33_0.logic:proc()
		
		if not arg_33_0.logic:isPVP() then
			BattleMapManager:updateMinimap()
			arg_33_0:doMazeUpdate()
			arg_33_0:doWalkUpdate()
			
			return 
		end
	elseif arg_33_0.logic:isPVP() and not arg_33_0.vars.walkable then
		arg_33_0.vars.walkable = true
	end
	
	if arg_33_0:isPlayingBattleAction() then
		set_high_fps_tick()
		
		return 
	else
		arg_33_0.logic:proc()
		
		if not is_playing_story() and not arg_33_0:isRealtimeMode() and not arg_33_0.logic:isEnded() and arg_33_0.logic:isExpeditionType() then
			arg_33_0:updateExpedition()
		end
	end
end

function Battle.update(arg_34_0)
	if DEBUG.TIME_SCALE_TEST_LOG and arg_34_0.vars and arg_34_0.vars.time_scale and arg_34_0.vars.prev_time_scale ~= arg_34_0.vars.time_scale then
		arg_34_0.vars.prev_time_scale = arg_34_0.vars.time_scale
		
		print("error: TimeScale Change", arg_34_0.vars.time_scale)
	end
	
	if is_playing_story() then
		return 
	end
	
	if not arg_34_0.logic or arg_34_0.pause then
		return 
	end
	
	arg_34_0.viewer:update()
	arg_34_0:procInfos()
	arg_34_0:updateProcess()
	arg_34_0:invokeAsyncProcInfos()
	BattleField:checkRoadSector(arg_34_0.logic)
	TutorialGuide:onBattleUpdate(arg_34_0.logic)
end

function Battle.getViewerMode(arg_35_0)
	if not arg_35_0.viewer then
		return 
	end
	
	return arg_35_0.viewer.mode
end

function Battle.isRealtimeMode(arg_36_0)
	if not arg_36_0.viewer then
		return false
	end
	
	return arg_36_0.viewer.mode == "net_rank" or arg_36_0.viewer.mode == "net_event_rank" or arg_36_0.viewer.mode == "net_friend" or arg_36_0.viewer.mode == "net_server" or arg_36_0.viewer.mode == "net_local_test"
end

function Battle.isReplayMode(arg_37_0)
	if not arg_37_0.viewer then
		return false
	end
	
	return arg_37_0.viewer.mode == "replay"
end

function Battle.isNetLocalTest(arg_38_0)
	if not arg_38_0.viewer then
		return false
	end
	
	return arg_38_0.viewer.mode == "net_local_test"
end

function Battle.isRestored(arg_39_0)
	if not arg_39_0.vars then
		return false
	end
	
	return arg_39_0.vars.restored
end

function Battle.getInitSnap(arg_40_0)
	if not arg_40_0.vars then
		return 
	end
	
	return arg_40_0.vars.init_snap
end

function Battle.isEnterByRepeatMode(arg_41_0)
	if not arg_41_0.vars then
		return 
	end
	
	return arg_41_0.vars.is_enter_by_repeat_mode
end

function Battle.quest_test(arg_42_0, arg_42_1)
	arg_42_0.vars.story_battle = arg_42_1 or "CH01_003_3"
end

function Battle.resetBattleTimeScale(arg_43_0, arg_43_1, arg_43_2)
	if not arg_43_0.vars then
		return 
	end
	
	arg_43_1 = arg_43_1 or arg_43_0.vars.time_scale or BATTLE_TIME_SCALE_X0
	
	if DEBUG.TEST_MOVIE_CAPTURE then
		setenv("time_scale", 1)
	elseif PRODUCTION_MODE or tonumber(getenv("time_scale")) <= BATTLE_TIME_SCALE_X2 or arg_43_2 then
		setenv("time_scale", arg_43_1)
	end
	
	arg_43_0.vars.time_scale = arg_43_1
	
	Log.d("initTimeScale", getenv("time_scale"))
end

function Battle.applyTimeScaleUp(arg_44_0)
	if not arg_44_0.vars or not arg_44_0.vars.is_time_scale_mode then
		return 
	end
	
	if not arg_44_0.logic then
		return 
	end
	
	local var_44_0
	
	if arg_44_0.vars.is_time_scale_up then
		if StageStateManager:isRunning() then
			var_44_0 = GET_SKILL_TIME_SCALE()
		elseif STAGE_MODE.MOVE == arg_44_0:getStageMode() then
			var_44_0 = GET_MOVE_TIME_SCALE()
		elseif STAGE_MODE.EVENT == arg_44_0:getStageMode() then
			var_44_0 = GET_EVENT_TIME_SCALE()
		end
	else
		var_44_0 = BATTLE_TIME_SCALE_X2
	end
	
	if not PRODUCTION_MODE and tonumber(getenv("time_scale")) > GET_MOVE_TIME_SCALE() then
		return 
	end
	
	add_callback_to_story(function()
		arg_44_0:resetBattleTimeScale(var_44_0, true)
	end)
	
	return true
end

function Battle.isSpeedPlayableStage(arg_46_0)
	if DEBUG.MAP_DEBUG then
		return true
	end
	
	if not BattleRepeat:check_cleared_ije005() then
		return false
	end
	
	return true
end

function Battle.begin(arg_47_0, arg_47_1, arg_47_2)
	STORY_SKIPPED_LIST = {}
	arg_47_0.pause = false
	arg_47_0.story_data = arg_47_2.story_data or {}
	arg_47_0.vars = {}
	arg_47_0.ui_vars = {}
	arg_47_0.vars.restored = arg_47_2.restored
	arg_47_0.vars.init_snap = arg_47_2.init_snap
	
	local var_47_0 = BattleViewer:create(arg_47_1, arg_47_2)
	
	arg_47_0.viewer = var_47_0
	
	local var_47_1 = "default"
	
	if arg_47_1:isCreviceHunt() or getDungeonType(arg_47_1.map.enter) == "crehunt" then
		var_47_1 = "crehunt"
	end
	
	BattleLayout:init(var_47_1)
	arg_47_0:resetBattleTimeScale()
	SpriteCache:loadCache()
	StageStateManager:reset()
	
	arg_47_0.logic = arg_47_1
	arg_47_0.vars.is_enter_by_repeat_mode = BattleRepeat:isPlayingRepeatPlay()
	
	arg_47_0:setExpeditionSyncTime(arg_47_2.coop_sync_time)
	arg_47_0:updateExpeditionUserList(arg_47_2.expedition_users)
	
	arg_47_0.vars.dead_units = {}
	arg_47_0.vars.skill_hit_info_map = {}
	arg_47_0.vars.battle_state = "begin"
	arg_47_0.vars.is_time_scale_mode = DEBUG.APPLY_TIME_SCALE or not arg_47_0.logic:isPVP() and not arg_47_0.logic:isSkillPreview() and not ContentDisable:byAlias("battle_speed")
	arg_47_0.vars.is_time_scale_up = SAVE:getKeep("battle.speed.up", false)
	
	if arg_47_0.vars.is_time_scale_up then
		arg_47_0.vars.is_time_scale_up = Battle:isSpeedPlayableStage()
	end
	
	ConditionContentsManager:cleanUpVltTbl()
	arg_47_0:clear()
	
	local var_47_2
	local var_47_3 = BattleField:create()
	
	BattleDropManager:clear()
	BattleTopBar:init(arg_47_1)
	BattleTopBar:updateNotifications()
	Account:initAutoSkillFlag()
	BattleUI:init(arg_47_1, var_47_0)
	BattleMapManager:init(arg_47_1)
	BattleStory:init(arg_47_1)
	ClearResult:clearVars()
	CameraManager:resetDefault()
	Battle:applyTimeScaleUp()
	
	local var_47_4 = ConditionContentsManager:getDungeonMissions()
	
	if var_47_4 then
		var_47_4:startMissions(arg_47_1.map.enter, arg_47_1:getCurrentSubstoryID())
	end
	
	local var_47_5 = arg_47_1:getInitData().restore_data
	
	if var_47_5 then
		if var_47_5.stroy_info then
			BattleStory:setPlayedList(var_47_5.stroy_info.played_story_list)
		end
		
		if var_47_5.substory then
			ConditionContentsManager:initSubStory()
		end
		
		ConditionContentsManager:restoreUpdateConditions(var_47_5.conditions_info)
	else
		ConditionContentsManager:dispatch("battle.party", {
			unique_id = arg_47_1:getBattleUID(),
			enter_id = arg_47_1.map.enter,
			entertype = arg_47_1.type,
			friends = arg_47_1.units,
			ignore_condition = Battle:checkIgnoreCondition()
		})
	end
	
	if not arg_47_0:isRealtimeMode() then
		arg_47_0.BattleCounter = arg_47_0:GetBattleCount() + 1
	end
	
	if arg_47_2.restored then
		arg_47_0.pause = true
		arg_47_0.vars.walkable = true
		arg_47_0.vars.ignore_lack_currency = arg_47_2.ignore_lack_currency
		arg_47_0.vars.restore_info = arg_47_2.restore_info
		
		arg_47_0.logic:procinfos(true)
	else
		arg_47_0.logic:command({
			cmd = "EnterRoad"
		})
	end
	
	arg_47_0.vars.restore_last_result = arg_47_2.restore_last_result
	arg_47_0.vars.start_time = os.time()
	arg_47_0.vars.override_bgm = arg_47_2.bgm_id
	
	return var_47_3
end

function Battle.setTimeScaleMode(arg_48_0, arg_48_1)
	arg_48_0.vars.is_time_scale_mode = arg_48_1
end

function Battle.isTimeScaleMode(arg_49_0)
	return arg_49_0.vars.is_time_scale_mode
end

function Battle.setTimeScaleUp(arg_50_0, arg_50_1)
	arg_50_0.vars.is_time_scale_up = arg_50_1
end

function Battle.isTimeScaleUp(arg_51_0)
	return arg_51_0.vars.is_time_scale_up
end

function Battle.getPlayingBattleUID(arg_52_0)
	local var_52_0 = {}
	local var_52_1 = BackPlayManager:getBattles() or {}
	
	for iter_52_0, iter_52_1 in pairs(var_52_1) do
		if iter_52_1.logic then
			local var_52_2 = iter_52_1.logic:getBattleUID()
			
			table.insert(var_52_0, var_52_2)
		end
	end
	
	local var_52_3 = arg_52_0.logic:getBattleUID()
	
	table.insert(var_52_0, var_52_3)
	
	return var_52_0
end

function Battle.beginAfter(arg_53_0)
	local function var_53_0(arg_54_0)
		local var_54_0 = {}
		
		for iter_54_0, iter_54_1 in pairs(arg_54_0 or {}) do
			arg_53_0:procInfo(iter_54_1, var_54_0)
		end
		
		arg_53_0:procText(var_54_0)
	end
	
	if arg_53_0:isRestored() then
		arg_53_0.vars.auto_walking = false
		arg_53_0.is_screen_restoring = true
		
		var_53_0(Battle.logic:getRestoreViewInfos())
		
		arg_53_0.is_screen_restoring = false
		
		arg_53_0.viewer:updateViewState(nil, true)
		
		arg_53_0.pause = false
		arg_53_0.vars.restore_info = nil
	end
end

function Battle.setPause(arg_55_0, arg_55_1)
	arg_55_0.pause = arg_55_1
end

function Battle.getStartTime(arg_56_0)
	return arg_56_0.vars.start_time
end

function Battle.getAppearMode(arg_57_0)
	if not arg_57_0.vars.appear_mode then
		local var_57_0 = arg_57_0.logic.map.enter
		local var_57_1 = DB("level_enter", var_57_0, "appear_type")
		
		arg_57_0.vars.appear_mode = var_57_1
	end
	
	return arg_57_0.vars.appear_mode
end

function Battle.setBattleMode(arg_58_0, arg_58_1)
	local var_58_0
	
	var_58_0 = arg_58_1 or arg_58_0.logic.map.map
	
	local var_58_1 = arg_58_0.logic.map.enter
	local var_58_2 = DB("level_enter", var_58_1, {
		"type"
	})
	
	arg_58_0.vars.battle_mode = GET_BATTLE_MODE[var_58_2]
	
	return arg_58_0.vars.battle_mode
end

function Battle.getBattleMode(arg_59_0)
	Log.e("WARRING", "DEPLICATED Battle:getBattleMode change to logic:getStageMainType() ", debug.traceback())
	
	return arg_59_0.logic:getStageMainType()
end

function Battle.usePotion(arg_60_0)
	arg_60_0.logic:command({
		cmd = "UsePotion"
	})
end

function Battle.getReplayPlayer(arg_61_0)
	if not arg_61_0.viewer or not arg_61_0.viewer.player then
		return 
	end
	
	return arg_61_0.viewer.player
end

function Battle.checkIgnoreCondition(arg_62_0)
	return arg_62_0:isRestored() or arg_62_0.logic.is_back_ground or arg_62_0:isReplayMode()
end

function Battle.showFocusRing(arg_63_0, arg_63_1)
	if not get_cocos_refid(arg_63_0.ui_vars.focus) then
		arg_63_0.ui_vars.focus = SpriteCache:getSprite("focus.png")
		
		arg_63_0.ui_vars.focus:setPosition(0, 70)
		arg_63_0.ui_vars.focus:retain()
	end
	
	local var_63_0 = arg_63_0.ui_vars.focus:getParent()
	
	if var_63_0 ~= nil then
		var_63_0:removeChild(arg_63_0.ui_vars.focus)
	end
	
	arg_63_1.model:addChild(arg_63_0.ui_vars.focus)
	
	local var_63_1 = arg_63_1.model:getAttachmentBoundingBox("turn_box", "turn_box")
	
	if var_63_1 then
		arg_63_0.ui_vars.focus:setScale(var_63_1.width / 128 * 2.7)
		arg_63_0.ui_vars.focus:setPosition((var_63_1.x + var_63_1.width / 2) / BASE_SCALE, 0)
	end
	
	arg_63_0.ui_vars.focus:setOpacity(0)
	BattleAction:Add(SEQ(DELAY(1000), FADE_IN(300), LOOP(SEQ(FADE_OUT(300), FADE_IN(300), DELAY(500)))), arg_63_0.ui_vars.focus, "battle.focus")
end

function Battle.hideFocusRing(arg_64_0)
	if not get_cocos_refid(arg_64_0.ui_vars.focus) then
		return 
	end
	
	local var_64_0 = arg_64_0.ui_vars.focus:getParent()
	
	if var_64_0 then
		BattleAction:Remove(arg_64_0.ui_vars.focus)
		var_64_0:removeChild(arg_64_0.ui_vars.focus)
	end
end

function Battle.startSkillMotion(arg_65_0, arg_65_1, arg_65_2)
	if not arg_65_0.logic then
		return 
	end
	
	local var_65_0, var_65_1 = DB("skill", arg_65_2.skill_id, {
		"skillact",
		"show_lastdamage"
	})
	local var_65_2 = {
		skill_id = arg_65_2.skill_id,
		unit = arg_65_1,
		units = {
			friends = arg_65_0.logic:pickUnits(arg_65_1, FRIEND),
			enemies = arg_65_0.logic:pickEnemies(arg_65_1, ENEMY)
		},
		att_info = arg_65_2
	}
	
	if DEBUG.TARGET_UNIT_CODE and arg_65_1.db.code == DEBUG.TARGET_UNIT_CODE then
		var_65_2.skill_id = "sk_" .. DEBUG.CHANGE_UNIT_CODE .. "_1"
	end
	
	arg_65_0:updateModelExtraInfo()
	
	local var_65_3, var_65_4 = StageStateManager:start(var_65_2.skill_id, var_65_2)
	local var_65_5 = var_65_3:isContainEntityType("NODE_ANI")
	
	for iter_65_0, iter_65_1 in pairs(arg_65_2.d_units) do
		if var_65_5 then
			local function var_65_6(arg_66_0)
				BattleAction:Add(SEQ(FADE_OUT(300), CALL(arg_66_0.setVisible, arg_66_0, false)), arg_66_0)
			end
			
			iter_65_1.model:runActionForAttachedModel(var_65_6)
		end
	end
	
	var_65_3:setCallback({
		onFinish = function(arg_67_0)
			if var_65_5 then
				for iter_67_0, iter_67_1 in pairs(arg_65_2.d_units) do
					local function var_67_0(arg_68_0)
						BattleAction:Add(SEQ(OPACITY(0, 0, 0), CALL(arg_68_0.setVisible, arg_68_0, true), FADE_IN(300)), arg_68_0)
					end
					
					iter_67_1.model:runActionForAttachedModel(var_67_0)
				end
			else
				for iter_67_2, iter_67_3 in pairs(arg_65_2.d_units) do
					iter_67_3.model:setVisibleAttachedModel(true)
				end
			end
		end,
		onDestroy = function(arg_69_0)
			if var_65_1 then
				for iter_69_0, iter_69_1 in pairs(arg_65_2.d_units) do
					BattleUI:displayDamage(iter_69_1, {
						damage = 0,
						type = "attack"
					})
				end
				
				BattleAction:Add(SEQ(DELAY(500), CALL(function()
					if arg_69_0:getEntitiesCount("HP_BAR") > 0 then
						for iter_70_0, iter_70_1 in pairs(var_65_2.units.friends or {}) do
							if iter_70_1.ui_vars.gauge and get_cocos_refid(iter_70_1.ui_vars.gauge.control) then
								iter_70_1.ui_vars.gauge:setCustomOpacity(nil)
							end
						end
						
						for iter_70_2, iter_70_3 in pairs(var_65_2.units.enemies or {}) do
							if iter_70_3.ui_vars.gauge and get_cocos_refid(iter_70_3.ui_vars.gauge.control) then
								iter_70_3.ui_vars.gauge:setCustomOpacity(nil)
							end
						end
					end
				end)), arg_65_0, "battle.skill")
			end
		end
	})
	
	local var_65_7 = var_65_3:getEntitiesCount("HIT") or 1
	
	arg_65_0.vars.skill_hit_info_map[arg_65_1] = {
		tot_hit = var_65_7
	}
	
	return var_65_3, var_65_4
end

function Battle.stopSkillMotion(arg_71_0, arg_71_1, arg_71_2)
	if arg_71_1.tmp_vars.handle_restore then
		arg_71_1.model:setOpacityByKey("banshee_queen", 255)
		BattleAction:Add(SEQ(OPACITY(1000, 0, 1)), arg_71_1.model, "handle.restore")
	end
	
	local var_71_0 = {
		unit = arg_71_1,
		units = {
			friends = arg_71_0.logic:pickUnits(arg_71_1, FRIEND),
			enemies = arg_71_0.logic:pickEnemies(arg_71_1, ENEMY)
		}
	}
	
	StageStateManager:stop(arg_71_2.skill_id, var_71_0)
end

function Battle.startSkillWithoutMotion(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
	local var_72_0, var_72_1 = DB("skill", arg_72_3.skill_id, {
		"skillact",
		"show_lastdamage"
	})
	local var_72_2 = arg_72_4 or {
		skill_id = arg_72_3.skill_id,
		unit = arg_72_2,
		units = {
			friends = arg_72_1:pickUnits(arg_72_2, FRIEND),
			enemies = arg_72_1:pickEnemies(arg_72_2, ENEMY)
		},
		att_info = arg_72_3
	}
	local var_72_3 = var_72_2.unit
	local var_72_4 = var_72_3:getSkinCheck()
	local var_72_5 = DB("skillact", DB("skill", var_72_2.skill_id, "skillact"), var_72_4 or "action") or var_72_3.model:getBoneNode("arrow_start") and "def_range_attack" or "def_melee_attack"
	
	var_72_2.id = var_72_2.skill_id
	var_72_2.idx = var_72_3:getSkillIndex(var_72_2.skill_id)
	
	local var_72_6, var_72_7, var_72_8 = StageStateManager:getStateDocTime(var_72_5, "start", var_72_2)
	
	return var_72_6, var_72_7, var_72_8
end

function Battle.getIdleAni(arg_73_0, arg_73_1)
	local var_73_0 = "idle"
	
	if is_using_story_v2() then
		return var_73_0
	end
	
	if arg_73_1:isConcentration() then
	elseif arg_73_1:isStunned() then
		var_73_0 = "groggy"
	elseif (arg_73_1:isDead() or arg_73_1:isEmptyHP()) and not DB("character", arg_73_1.db.code, "die_action") then
		var_73_0 = "groggy"
	end
	
	return var_73_0
end

function Battle.getIdleAction(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0:getIdleAni(arg_74_1)
	
	return TARGET(arg_74_1.model, MOTION(var_74_0, true))
end

function Battle.playIdleAction(arg_75_0, arg_75_1, arg_75_2)
	if arg_75_1.model and get_cocos_refid(arg_75_1.model) then
		arg_75_1.model:cleanupLocalCacheObject()
		BattleAction:Add(Battle:getIdleAction(arg_75_1), arg_75_1.model, arg_75_2)
	end
end

function Battle.updateStateMotion(arg_76_0, arg_76_1)
	if not get_cocos_refid(arg_76_1.model) then
		return 
	end
	
	local var_76_0 = arg_76_1.model:getCurrent()
	
	if var_76_0 and (var_76_0.animation == "groggy" and not arg_76_1:isStunned() or var_76_0.animation == "idle" and arg_76_1:isStunned()) then
		BattleAction:Add(Battle:getIdleAction(arg_76_1), arg_76_1.model)
	end
end

function Battle.setSoulState(arg_77_0, arg_77_1)
	arg_77_0.vars.arrange_skill.soul_state = arg_77_1
	
	BattleUI:setSoulState(arg_77_0.vars.arrange_skill.soul_state)
	arg_77_0:selectSkill({
		idx = arg_77_0.vars.arrange_skill.selected_skill_idx
	})
end

function Battle.selectSkill(arg_78_0, arg_78_1)
	arg_78_1 = arg_78_1 or {}
	
	local var_78_0 = arg_78_1.idx
	local var_78_1 = arg_78_0.logic:getTurnOwner()
	local var_78_2 = var_78_1:getSkillBundle():slot(arg_78_1.idx)
	local var_78_3 = var_78_2:getSkillId()
	
	if arg_78_0.vars.arrange_skill.soul_state == "burn" then
		local var_78_4, var_78_5 = var_78_2:getSoulBurnSkill()
		
		if var_78_4 then
			var_78_3 = var_78_4
		end
	end
	
	local var_78_6 = arg_78_0.logic:getTargetCandidates(var_78_3, var_78_1, arg_78_1.target, true)
	
	arg_78_0.vars.arrange_skill.attacker = var_78_1
	arg_78_0.vars.arrange_skill.skill_id = var_78_3
	arg_78_0.vars.arrange_skill.target_candidates = var_78_6
	
	if arg_78_1.by_touch and not VARS.EXPERT_MODE and not arg_78_0:isAutoPlaying() and var_78_1.inst.ally == FRIEND then
		arg_78_0:highlightMainAttacker(var_78_1, var_78_6)
	end
	
	if arg_78_0.vars.arrange_skill.selected_skill_idx == arg_78_1.idx and not arg_78_1.force then
		return 
	end
	
	arg_78_0.vars.arrange_skill.selected_skill_idx = arg_78_1.idx
	
	if var_78_1.inst.ally == FRIEND or Battle.logic:isDualControl() or Battle:isReplayMode() then
		BattleUI:onSelectSkill(var_78_1, arg_78_1.idx)
		BattleUI:showTargetButtons(var_78_1, var_78_6)
	end
	
	BattleUI:showAggroEffect(var_78_1, var_78_6)
	arg_78_0:showEmptyPositionTargets(true, var_78_1, var_78_6, var_78_3)
end

function Battle.highlightMainAttacker(arg_79_0, arg_79_1, arg_79_2)
	if arg_79_1 then
		for iter_79_0, iter_79_1 in pairs(arg_79_0.logic.units) do
			if get_cocos_refid(iter_79_1.model) then
				iter_79_1.model:setColor(arg_79_0.vars.disable_color)
			end
		end
		
		for iter_79_2, iter_79_3 in pairs(arg_79_2) do
			if get_cocos_refid(iter_79_3.model) then
				iter_79_3.model:setColor(arg_79_0.vars.ambient_color)
			end
		end
		
		if get_cocos_refid(arg_79_1.model) then
			arg_79_1.model:setColor(arg_79_0.vars.ambient_color)
		end
		
		if not get_cocos_refid(arg_79_0.vars.black) then
			local var_79_0 = BattleLayout:getFocusPosition()
			
			arg_79_0.vars.black = cc.Sprite:create("img/_white_s.png")
			
			arg_79_0.vars.black:setColor(cc.c3b(0, 0, 0))
			arg_79_0.vars.black:setPosition(var_79_0, DESIGN_HEIGHT / 2)
			arg_79_0.vars.black:setOpacity(125)
			arg_79_0.vars.black:setScaleX(DESIGN_WIDTH / 10)
			arg_79_0.vars.black:setScaleY(DESIGN_HEIGHT / 10)
			BGI.main.layer:addChildFirst(arg_79_0.vars.black)
		end
	elseif get_cocos_refid(arg_79_0.vars.black) then
		BattleAction:Add(SEQ(OPACITY(300, 0.5, 0), REMOVE()), arg_79_0.vars.black, "battle.curtain")
		
		arg_79_0.vars.black = nil
		
		for iter_79_4, iter_79_5 in pairs(arg_79_0.logic.units) do
			if get_cocos_refid(iter_79_5.model) then
				iter_79_5.model:setColor(arg_79_0.vars.ambient_color)
			end
		end
	end
end

function Battle.isBlockTouchEvent(arg_80_0)
	if not BGI or arg_80_0.vars.story_before or is_playing_story() or BattleAction:Find("block") or BattleUIAction:Find("block") or UIAction:Find("block") then
		return true
	end
	
	if TutorialGuide:isNeedAutoMove() then
		return true
	end
	
	if arg_80_0.once_touch_block then
		arg_80_0.once_touch_block = false
		
		return true
	end
	
	if TutorialGuide:checkBlockFieldEvent() then
		return true
	end
end

function Battle.onTouchMove(arg_81_0, arg_81_1, arg_81_2)
	if arg_81_0:isBlockTouchEvent() then
		return 
	end
	
	if arg_81_0.vars.skill_btn_touch_info and (math.abs(arg_81_0.vars.skill_btn_touch_info.sx - arg_81_1) > DESIGN_HEIGHT * 0.03 or math.abs(arg_81_0.vars.skill_btn_touch_info.sy - arg_81_2) > DESIGN_HEIGHT * 0.03) then
		arg_81_0.vars.skill_btn_touch_info = nil
		
		BattleUI:hideSkillInfo()
	end
	
	if BattleLayout:isWalking() then
		if arg_81_0.logic:getCurrentRoadType() == "goblin" or arg_81_0.logic:getCurrentRoadType() == "chaos" then
			BattleLayout:setDirection(1, true)
		else
			local var_81_0 = arg_81_0:isReverseDirection()
			
			BattleLayout:setDirection(arg_81_1 - DESIGN_WIDTH * (var_81_0 and 0.7 or 0.3), true)
		end
	end
end

function Battle.onTouchUp(arg_82_0, arg_82_1, arg_82_2)
	if not arg_82_0.logic then
		return 
	end
	
	if arg_82_0:isBlockTouchEvent() then
		return 
	end
	
	if arg_82_0.vars.skill_btn_touch_info then
		if not arg_82_0.vars.skill_btn_touch_info.tooltip_only and arg_82_0.logic:getTurnOwner():getSkillBundle():slot(arg_82_0.vars.skill_btn_touch_info.idx):checkUseSkill() then
			arg_82_0:onTouchSkill(arg_82_0.vars.skill_btn_touch_info.idx)
		end
		
		arg_82_0.vars.skill_btn_touch_info = nil
	end
	
	if STAGE_MODE.MOVE == arg_82_0:getStageMode() then
		if not USE_AUTO_WALKING then
			arg_82_0:onClickNextButton(false)
		elseif systick() - to_n(arg_82_0.vars.touch_tick or 0) > 500 then
			arg_82_0.vars.auto_walking = false
			
			arg_82_0:onClickNextButton(false)
		else
			arg_82_0.vars.auto_walking = not arg_82_0.vars.auto_walking
			
			if arg_82_0:isAutoPlaying() and BattleLayout:getDirection() == -1 then
				arg_82_0.vars.auto_walking = false
			end
			
			arg_82_0:onClickNextButton(arg_82_0.vars.auto_walking)
		end
		
		return 
	end
	
	BattleUI:hideSkillInfo()
	
	if Battle:isReplayMode() and not ClearResult:isShow() and not BattleUIAction:Find("battle.replay.begin") and not UIAction:Find("showed_tooptip") then
		BattleUI:toggleReplayController()
	end
	
	if Battle:isReadyToPickTarget() then
		if not arg_82_0.vars.pick_unit then
			return 
		end
		
		if BattleUI:checkOverlapSkillButtons(arg_82_1, arg_82_2) then
			return 
		end
		
		local var_82_0 = arg_82_0:pickSkillTarget(arg_82_1, arg_82_2)
		local var_82_1
		local var_82_2
		
		if var_82_0 and arg_82_0.vars.pick_unit == var_82_0 then
			var_82_2 = arg_82_0.logic:getTurnOwner()
			
			for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.arrange_skill.target_candidates) do
				if var_82_0 == iter_82_1 then
					if var_82_2.inst.ally ~= var_82_0.inst.ally and var_82_0:isDead() then
						return 
					end
					
					arg_82_0:onSelectTarget(var_82_0)
					
					var_82_1 = true
					
					break
				end
			end
		end
		
		if Battle.logic:isRealtimeMode() then
			return 
		end
		
		if var_82_0 and not var_82_1 and #arg_82_0.vars.arrange_skill.target_candidates > 0 then
			BattleUI:showTargetGuide(true)
		end
	end
end

function Battle.onTouchSkill(arg_83_0, arg_83_1)
	if arg_83_0:isReplayMode() then
		return 
	end
	
	local var_83_0 = arg_83_0.logic:getTurnOwner()
	
	if var_83_0:getSkillBundle():slot(arg_83_1):getPassive() then
		Log.d("skill", "패시브 스킬은 스킬 선택 기능 안함")
		
		return 
	end
	
	if var_83_0:getSkillBundle():slot(arg_83_1):checkUseSkill() then
		arg_83_0:selectSkill({
			by_touch = true,
			idx = arg_83_1
		})
		
		if not arg_83_0:isRealtimeMode() and BattleAction:Find("battle.camera") == nil and BGI:getScale() ~= CAM_READY_SCALE then
			local var_83_1 = arg_83_0.logic:getTargetCandidates(var_83_0.skill_bundle:slot(arg_83_1):getSkillId(), var_83_0, nil, true)
			
			if var_83_1 and #var_83_1 > 0 then
				CameraManager:playCamera("ready", nil, nil, var_83_1[1].inst.ally)
			end
		end
	end
	
	if not arg_83_0.vars.arrange_skill.skill_selected then
		arg_83_0.vars.arrange_skill.skill_selected = true
	end
end

function Battle.doEndBattle(arg_84_0, arg_84_1)
	arg_84_1 = arg_84_1 or {}
	
	if arg_84_1.resume then
		resume()
	end
	
	if arg_84_1.fatal_stop and not arg_84_0.logic:getFinalResult() then
		arg_84_0.logic:fatalStop()
	end
	
	if arg_84_0:isRealtimeMode() then
		UIBattleAttackOrder:hideDetail()
		BattleUI:hideSkillButtons()
		ChatMain:hide()
		ChatEmojiPopup:close()
	end
	
	removeSavedBattleInfo()
	
	if Battle:isMapFinished() then
		return 
	end
	
	if BattleAction:Find("Battle.end_reserve") then
		return 
	end
	
	if arg_84_0.vars.restore_last_result then
		arg_84_0.vars.battle_state = "finish"
	end
	
	BattleAction:Add(SEQ(COND_LOOP(DELAY(10), function()
		if not arg_84_0:isPlayingBattleAction() then
			return true
		end
	end), CALL(function()
		attach_story_finished_callback(function()
			if not arg_84_0:isTimeScaleUp() then
				setenv("time_scale", BATTLE_TIME_SCALE_X2)
			end
			
			if arg_84_0.vars.restore_last_result then
				arg_84_0.vars.end_battle = true
				arg_84_0.vars.map_finished = true
				
				BackPlayManager:showResultUI(arg_84_0.vars.restore_last_result.result_values)
			else
				if arg_84_0:isReplayMode() then
					arg_84_0.viewer.player:nextTurn()
				elseif arg_84_0.logic:getFinalResult() == "win" then
					arg_84_0:onClear(Battle.logic, arg_84_0:getClearData())
				elseif arg_84_0.logic:isScoreType() then
					arg_84_0:onClear(Battle.logic, arg_84_0:getClearData())
				elseif arg_84_0.logic:isExpeditionType() then
					arg_84_0:onClear(Battle.logic, arg_84_0:getClearData())
				elseif arg_84_0.logic:isRealtimeMode() then
					arg_84_0:onClear(Battle.logic, arg_84_0:getClearData())
				else
					arg_84_0:onFailed(Battle.logic, arg_84_1.draw, arg_84_1.giveup, arg_84_0:getFailedData())
				end
				
				if not (BattleRepeat:get_repeatCount() >= 0) or not BattleRepeat:getConfigRepeatPlay() then
					vibrate(VIBRATION_TYPE.Default)
				end
			end
		end)
	end)), arg_84_0, "Battle.end_reserve")
end

function Battle.endBattleScene(arg_88_0, arg_88_1)
	arg_88_1 = arg_88_1 or {}
	
	resume()
	
	arg_88_0.vars.end_battle = true
	
	if arg_88_1.giveup then
		arg_88_0.logic:fatalStop()
	end
	
	if arg_88_1.giveup then
		arg_88_0:syncUnitInfos(arg_88_0.logic, arg_88_1.giveup)
		
		arg_88_0.vars.giveup = arg_88_1.giveup
	end
	
	Dialog:closeAll()
	BattleAction:RemoveAll()
	UIAction:RemoveAll()
	BattleUIAction:RemoveAll()
	BattleUI:endBattleScene()
	StageStateManager:reset()
	UIOption:UpdateScreenOnState()
	
	if ClearResult:isWorldMapEffect() then
		return 
	end
	
	if not arg_88_1.skip_pop_scene then
		SceneManager:popScene(arg_88_1.doAfterNextSceneLoaded)
	end
end

function Battle.procTouchFieldModel(arg_89_0, arg_89_1, arg_89_2)
	if BattleLayout:isBlocked() then
		return 
	end
	
	local var_89_0 = BattleField:getRoadEventFieldModelList()
	
	if var_89_0 and #var_89_0 > 0 then
		local var_89_1
		
		if type(arg_89_1) ~= "number" and arg_89_1 then
			var_89_1 = arg_89_1
		else
			local var_89_2 = slowpick2(BGI.main.layer, var_89_0, arg_89_1, arg_89_2)
			
			if var_89_2 then
				var_89_1 = var_89_0[var_89_2]
			end
		end
		
		if var_89_1 then
			local var_89_3 = BattleField:getRoadEventObjectByModel(var_89_1)
			
			if var_89_3 then
				if var_89_3.tutorial_dirty then
					return 
				end
				
				if var_89_3:isTouchable() and (var_89_3:isAlwayseFire() or not arg_89_0.logic:isCompletedRoadEvent(var_89_3.event_id)) then
					arg_89_0.logic:command({
						cmd = "FireRoadEvent",
						road_event_id = var_89_3.event_id
					})
					
					return true
				end
			end
		end
	end
	
	local var_89_4 = arg_89_0.logic:getCurrentRoadInfo()
	
	if var_89_4.is_cross then
		local var_89_5
		local var_89_6
		
		if Battle:hasClearEventInMaze(var_89_4.road_id) then
			var_89_6 = "crossroad_select_portal"
		else
			local var_89_7 = BattleMapManager:getNaviData()
			
			var_89_6 = var_89_7 and var_89_7.msg_navi or "minimap_select_direction"
		end
		
		if var_89_6 then
			add_callback_to_story(function()
				balloon_message_with_sound(var_89_6)
			end)
		end
	end
end

function Battle.onTouchDown(arg_91_0, arg_91_1, arg_91_2)
	if not arg_91_0.logic then
		return 
	end
	
	arg_91_0.vars.pick_unit = nil
	arg_91_0.vars.skill_btn_touch_info = nil
	
	if arg_91_0:isBlockTouchEvent() then
		return 
	end
	
	if arg_91_0.vars.map_finished and (arg_91_0.logic:getFinalResult() ~= "win" or true) then
		if false then
		end
		
		return 
	end
	
	if arg_91_0.logic:isHiddenTurn() then
		return 
	end
	
	if not arg_91_0.logic:isPVP() and STAGE_MODE.MOVE == arg_91_0:getStageMode() then
		if arg_91_0:procTouchFieldModel(arg_91_1, arg_91_2) then
			return 
		end
		
		if Battle:canMoveable() then
			local var_91_0 = arg_91_0.logic:getCurrentRoadType() ~= "goblin" and arg_91_0.logic:getCurrentRoadType() ~= "chaos"
			local var_91_1 = BattleLayout:getDirection()
			
			if var_91_0 then
				local var_91_2 = arg_91_0:isReverseDirection()
				
				BattleLayout:setDirection(arg_91_1 - DESIGN_WIDTH * (var_91_2 and 0.7 or 0.3), true)
			else
				BattleLayout:setDirection(1, true)
			end
			
			if var_91_1 ~= BattleLayout:getDirection() then
				arg_91_0.vars.auto_walking = true
			end
		end
		
		arg_91_0.vars.touch_tick = systick()
		
		arg_91_0:onClickNextButton(true)
		
		return 
	end
	
	if arg_91_0:isAutoPlaying() then
		local var_91_3 = slowpick2(BGI.main.layer, arg_91_0.logic.enemies, arg_91_1, arg_91_2)
		
		if var_91_3 then
			arg_91_0:toggleAutoSpecifyTarget(arg_91_0.logic.enemies[var_91_3])
		end
	end
	
	if arg_91_0:isAutoPlaying() then
		return 
	end
	
	BattleUI:checkSkillPick(arg_91_1, arg_91_2)
	
	if Battle:isReadyToPickTarget() then
		arg_91_0.vars.pick_unit = arg_91_0:pickSkillTarget(arg_91_1, arg_91_2)
	end
	
	set_high_fps_tick()
end

function Battle.setTouckBlockOnce(arg_92_0)
	arg_92_0.once_touch_block = true
end

function Battle.isSelectTargetable(arg_93_0, arg_93_1)
	if not arg_93_0.vars.arrange_skill then
		return 
	end
	
	if not arg_93_0.vars.arrange_skill.attacker then
		return 
	end
	
	local var_93_0 = arg_93_0.vars.arrange_skill.attacker
	local var_93_1 = arg_93_0.logic:getTargetCandidates(arg_93_0.vars.arrange_skill.skill_id, var_93_0)
	
	for iter_93_0, iter_93_1 in pairs(var_93_1) do
		if arg_93_1 == iter_93_1 then
			return true
		end
	end
end

function Battle.pickSkillTarget(arg_94_0, arg_94_1, arg_94_2)
	local var_94_0 = slowpick2(BGI.main.layer, arg_94_0.logic.units, arg_94_1, arg_94_2)
	
	if var_94_0 then
		return arg_94_0.logic.units[var_94_0]
	end
end

function Battle.isReadyToPickTarget(arg_95_0)
	local var_95_0 = arg_95_0.logic:getTurnOwner()
	
	return arg_95_0.vars.arrange_skill and var_95_0 and arg_95_0.vars.arrange_skill.target_candidates and var_95_0.inst.ally == FRIEND
end

function Battle.showEmptyPositionTargets(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	if arg_96_2 and arg_96_2.inst.ally ~= FRIEND then
		return 
	end
	
	if arg_96_0.vars.empty_position_targets then
		for iter_96_0, iter_96_1 in pairs(arg_96_0.vars.empty_position_targets) do
			iter_96_1:cleanupReferencedObject()
			iter_96_1:removeFromParent()
		end
		
		for iter_96_2, iter_96_3 in pairs(arg_96_0.logic.units) do
			iter_96_3.spr = nil
		end
		
		arg_96_0.vars.empty_position_targets = nil
	end
	
	if arg_96_0.vars.empty_position_tags then
		for iter_96_4, iter_96_5 in pairs(arg_96_0.vars.empty_position_tags) do
			if get_cocos_refid(iter_96_5) then
				iter_96_5:removeFromParent()
			end
		end
		
		arg_96_0.vars.empty_position_tags = nil
	end
	
	if arg_96_1 then
		arg_96_0.vars.empty_position_targets = {}
		arg_96_0.vars.empty_position_tags = {}
		
		if #arg_96_3 > 0 then
			for iter_96_6, iter_96_7 in pairs(arg_96_3) do
				if iter_96_7:isDead() then
					local var_96_0
					local var_96_1 = false
					local var_96_2, var_96_3 = BattleLayout:getUnitFieldPosition(iter_96_7)
					
					if iter_96_7.inst.code == "cleardummy" then
						var_96_0 = cc.Sprite:create("img/hero_config_btn_add.png")
						
						BGI.main.layer:addChild(var_96_0)
						var_96_0:setAnchorPoint(0.5, 0)
						var_96_0:setPosition(var_96_2, var_96_3)
						var_96_0:setLocalZOrder(iter_96_7.z)
					else
						var_96_0 = CACHE:getModel(iter_96_7.db.model_id, iter_96_7.db.skin, nil, iter_96_7.db.atlas, iter_96_7.db.model_opt)
						
						var_96_0:setScale(iter_96_7.db.scale)
						var_96_0:setPosition(var_96_2, var_96_3)
						var_96_0:setLocalZOrder(iter_96_7.z)
						var_96_0:setColor(cc.c3b(255, 150, 150))
						var_96_0:setOpacity(200)
						
						local var_96_4 = BattleLayout:getDirection() * (iter_96_7.inst.ally == FRIEND and 1 or -1)
						
						var_96_0:setScaleX(var_96_0:getScaleX() * var_96_4)
						
						var_96_1 = true
					end
					
					BGI.main.layer:addChild(var_96_0)
					
					iter_96_7.spr = var_96_0
					
					table.insert(arg_96_0.vars.empty_position_targets, var_96_0)
					
					if var_96_1 then
						local var_96_5 = load_dlg("hud_order", true, "wnd")
						
						if get_cocos_refid(var_96_5) then
							if_set_sprite(var_96_5, "o", "img/itxt_revive_b.png")
							BattleField:getUILayer():addChild(var_96_5)
							var_96_5:setLocalZOrder(99999)
							
							local var_96_6 = var_96_0:getBoneNode("top"):getPositionY()
							local var_96_7 = SceneManager:convertToSceneSpace(var_96_0, {
								x = 0,
								y = var_96_6
							})
							
							var_96_5:setPosition(math.floor(var_96_7.x), math.floor(var_96_7.y) - 30)
							
							var_96_5.unit = iter_96_7
							
							table.insert(arg_96_0.vars.empty_position_tags, var_96_5)
						end
					end
				end
			end
		end
	end
end

function Battle.onSelectTarget(arg_97_0, arg_97_1)
	if arg_97_0:isPlayingBattleAction() then
		return 
	end
	
	if arg_97_0:isReplayMode() then
		return 
	end
	
	if arg_97_0.logic:getTurnState() ~= "ready" and arg_97_0.logic:getTurnState() ~= "pending_ready" then
		Log.e("Battle", "타겟 선택은 read 상태일땜나 가능합니다 지금은??", arg_97_0.logic:getTurnState())
		
		return 
	end
	
	local var_97_0 = arg_97_0.logic:getTurnOwner()
	
	if arg_97_0.vars.arrange_skill.attacker ~= var_97_0 then
		Log.e("Battle", "아직 공격자가 준비되지 않았습니다. ??", arg_97_0.logic:getTurnState())
		
		return 
	end
	
	BattleAction:Add(DELAY(100), var_97_0.model, "battle.skill")
	arg_97_0:showEmptyPositionTargets(false, var_97_0)
	set_high_fps_tick()
	BattleUI:showTargetGuide(false)
	
	if DEBUG.NO_HP_GAUGE then
		BattleUI:hideGauge()
	end
	
	if not arg_97_0.logic:isRealtimeMode() then
		arg_97_0:highlightMainAttacker()
	end
	
	arg_97_0.vars.selected_target = arg_97_1
	
	local var_97_1 = arg_97_0.logic:getTargetCandidates(arg_97_0.vars.arrange_skill.skill_id, var_97_0, arg_97_1)
	local var_97_2 = table.shallow_clone(var_97_1)
	
	table.convert(var_97_2, function(arg_98_0, arg_98_1)
		return ("%s[%d]"):format(arg_98_1.db.name, arg_98_1.inst.uid)
	end)
	Log.d("skill", "-- sk_target", table.toCommaStr(var_97_2))
	
	local var_97_3
	
	if arg_97_1 then
		var_97_3 = arg_97_1.inst.uid
	end
	
	local var_97_4 = arg_97_0.vars.arrange_skill.selected_skill_idx
	local var_97_5 = arg_97_0.vars.arrange_skill.soul_state == "burn"
	
	arg_97_0.logic:command({
		cmd = "StartSkill",
		attacker_uid = var_97_0.inst.uid,
		skill_id = arg_97_0.vars.arrange_skill.skill_id,
		target_uid = var_97_3,
		skill_idx = var_97_4,
		is_soul = var_97_5,
		ally = var_97_0:getAlly()
	})
	
	if not arg_97_0.logic:isRealtimeMode() then
		arg_97_0.vars.arrange_skill = {}
	end
end

function Battle.healAll_cheat(arg_99_0)
	for iter_99_0, iter_99_1 in pairs(arg_99_0.logic.friends) do
		iter_99_1.inst.hp = iter_99_1:getMaxHP()
	end
	
	BattleUI:update()
end

function Battle.skipStage_cheat(arg_100_0)
	if not arg_100_0.logic:getTurnOwner() then
		return 
	end
	
	local var_100_0 = arg_100_0.logic:getTurnOwner()
	
	var_100_0.model:foreachLocalCacheObject(function(arg_101_0)
		stop_or_remove(arg_101_0)
	end)
	
	local var_100_1 = arg_100_0.logic:pickEnemies(var_100_0)
	
	BattleUI:hideSkillButtons()
	BattleUI:hideTargetButtons()
	arg_100_0:hideFocusRing()
	Battle:highlightMainAttacker()
	
	local var_100_2 = {}
	
	for iter_100_0, iter_100_1 in pairs(var_100_1) do
		if not iter_100_1:isDead() then
			iter_100_1.inst.hp = 0
		end
	end
end

function Battle.updateGuideUI(arg_102_0, arg_102_1)
	if arg_102_0.vars.guide_icon and arg_102_0.vars.guide_icon.update_pos then
		arg_102_0.vars.guide_icon:update_pos(arg_102_1)
		
		if not arg_102_1.touchable then
			arg_102_1.touchable = true
		end
	end
end

function Battle.removeGuideUI(arg_103_0)
	if arg_103_0.vars.guide_icon and arg_103_0.vars.guide_icon.remove then
		arg_103_0.vars.guide_icon:remove()
	end
	
	arg_103_0.vars.guide_icon = nil
end

function Battle.upgradeSoulBurn(arg_104_0, arg_104_1)
	local var_104_0 = arg_104_0.logic:getTurnOwner()
	local var_104_1 = arg_104_0.viewer:getAttackInfo(var_104_0)
	
	if not var_104_1.skill_selected or not var_104_1.selected_skill_idx then
		return 
	end
	
	local var_104_2 = var_104_1.selected_skill_idx
	local var_104_3 = var_104_0:getSkillBundle():slot(var_104_2)
	
	if arg_104_1 then
		var_104_1.skill_id = var_104_3:getSoulBurnSkill(var_104_1.skill_id)
	else
		var_104_1.skill_id = var_104_3:getSkillId()
	end
	
	BattleUI:upgradeSoulBurn(arg_104_1)
end

function Battle.getNextDungeon(arg_105_0, arg_105_1, arg_105_2)
	arg_105_2 = arg_105_2 or arg_105_1.map.enter
	
	local var_105_0
	local var_105_1, var_105_2 = DB("level_enter", arg_105_2, {
		"type",
		"road"
	})
	
	if var_105_1 == "dungeon" then
		local var_105_3 = string.sub(arg_105_2, -3, -1)
		local var_105_4 = string.format("%03d", to_n(var_105_3) + 1)
		
		var_105_0 = string.gsub(arg_105_2, var_105_3, var_105_4)
	elseif var_105_2 then
		var_105_0 = string.split(var_105_2, ",")[1]
	elseif var_105_1 == "dungeon_quest" then
		return nil
	else
		return nil
	end
	
	local var_105_5, var_105_6 = DB("level_enter", var_105_0, {
		"id",
		"type"
	})
	
	if var_105_6 == "portal" then
		return 
	end
	
	if var_105_6 == "story" then
		return 
	end
	
	if var_105_6 == "cook" then
		return 
	end
	
	if var_105_6 == "volleyball" then
		return 
	end
	
	if var_105_6 == "arcade" then
		return 
	end
	
	if var_105_6 == "repair" then
		return 
	end
	
	if var_105_6 == "exorcist" then
		return 
	end
	
	return var_105_5
end

function Battle.playMoveNext(arg_106_0)
	for iter_106_0 = 1, 4 do
		local var_106_0 = arg_106_0.logic.friends[iter_106_0]
		
		if var_106_0 and not var_106_0:isDead() then
			BattleAction:Add(SEQ(CALL(function()
				var_106_0.model:playRunAnimation()
			end), MOVE_BY(1600, 800, 0), arg_106_0:getIdleAction(var_106_0)), var_106_0.model, "battle.move_next")
		end
	end
end

function Battle.swapSupporter(arg_108_0)
	arg_108_0.logic:command({
		cmd = "SwapTagSupporter"
	})
end

function Battle.setStageMode(arg_109_0, arg_109_1)
	arg_109_0.vars.stage_mode = arg_109_1
	
	BattleUI:setStageMode(arg_109_1)
	arg_109_0:applyTimeScaleUp()
end

function Battle.getStageMode(arg_110_0)
	return arg_110_0.vars.stage_mode
end

function Battle.summary(arg_111_0)
	for iter_111_0, iter_111_1 in pairs(arg_111_0.logic.units) do
		print(iter_111_1:summary())
	end
end

function Battle.GetBattleCount(arg_112_0)
	return to_n(arg_112_0.BattleCounter)
end

function Battle.DoEnter(arg_113_0, arg_113_1)
	arg_113_0.vars.mode = "Enter"
	
	arg_113_0:layoutFriends()
	BattleLayout:setWalking(false)
	BattleLayout:setPause(true)
	BattleDropManager:restore(arg_113_0:forecastReward(arg_113_0.logic))
	
	local function var_113_0()
		for iter_114_0 = 1, 4 do
			local var_114_0 = arg_113_0.logic.friends[iter_114_0]
			
			if var_114_0 and not var_114_0:isDead() then
				if get_cocos_refid(var_114_0.model) then
					var_114_0.model:setVisible(true)
				else
					Log.e("error ??", "왜 model이 날라갔을까? ")
				end
			end
		end
		
		if arg_113_0.logic.pet and get_cocos_refid(arg_113_0.logic.pet.model) then
			arg_113_0.logic.pet.model:setVisible(true)
		end
	end
	
	arg_113_0.vars.maze_line_end = false
	
	local var_113_1 = arg_113_0.is_screen_restoring
	
	arg_113_0:setStageMode(STAGE_MODE.MOVE)
	
	if arg_113_0.logic:isSkillPreview() or arg_113_0.logic:isPVP() or arg_113_0.logic:getStageMainType() == "tow" or arg_113_0.logic:getStageMainType() == "def" or arg_113_0.logic:isExpeditionType() then
		BattleMapManager:show(false, false)
	else
		BattleMapManager:initializeByWayInfo()
		BattleMapManager:show(true)
	end
	
	BattleLayout:moveToFieldPosition(nil)
	
	if arg_113_1.pos then
		BattleLayout:setDirection(arg_113_1.dir)
		BattleLayout:setFieldPosition(arg_113_1.pos)
	end
	
	if arg_113_1.is_cross then
		var_113_0()
		BattleLayout:updatePose()
		BattleLayout:updateModelPose(false)
	else
		BattleLayout:updatePose()
		BattleLayout:updateModelPose(false)
		
		if arg_113_1.enter_effect then
			if var_113_1 then
				arg_113_0:DoEnterAct_Defend(arg_113_1.dir)
			elseif arg_113_0:getAppearMode() == "jump" then
				arg_113_0:DoEnterAct_JumpNew(arg_113_1.dir)
			elseif arg_113_0:getAppearMode() == "defend" then
				var_113_0()
			else
				arg_113_0:DoEnterAct_RunNew(arg_113_1.dir)
			end
		else
			var_113_0()
		end
		
		BattleLayout:updatePose()
		
		if arg_113_0:getAppearMode() == "defend" then
			BattleLayout:updateModelPose(false)
		else
			BattleLayout:updateModelPose(true)
		end
	end
	
	local var_113_2 = CALL(BattleLayout.setPause, BattleLayout, false)
	
	if arg_113_1.is_cross then
		var_113_2 = NONE()
	end
	
	local function var_113_3()
		if get_cocos_refid(BGI.ui_layer) then
			local var_115_0 = BGI.ui_layer:getChildByName("bg.load")
			
			if get_cocos_refid(var_115_0) then
				BattleAction:Add(SEQ(FADE_OUT(300), SHOW(false), REMOVE()), var_115_0, "block")
			end
			
			BGI.ui_layer:removeChildByName("nametag.load")
		end
	end
	
	arg_113_0:stopWarpCurtainEffect()
	
	if var_113_1 then
		BattleField:setCheckableEvent(true)
	end
	
	BattleAction:Add(SEQ(DELAY(1000), COND_LOOP(DELAY(100), function()
		if not BattleLayout:getTeamLayout(FRIEND) then
			return 
		end
		
		if is_playing_story() then
			return 
		end
		
		if not BattleLayout:getTeamLayout(FRIEND):getTeamAniState() then
			return true
		end
	end), CALL(function()
		if not arg_113_0:isRestored() then
			BattleField:setCheckableEvent(true)
		end
	end), var_113_2, CALL(Battle.testAutoPlayingMode, arg_113_0), CALL(var_113_3), CALL(saveBattleInfo), CALL(function()
		if not var_113_1 then
			BattleUIAction:Add(SEQ(DELAY(2400), CALL(Battle.showGuideArrow, Battle)), arg_113_0)
		end
	end)), arg_113_0, "battle.enter")
	TutorialGuide:onEnterRoad(arg_113_0.logic)
	arg_113_0:preloadRoadEventResource()
end

function Battle.preloadRoadEventResource(arg_119_0)
	local var_119_0 = arg_119_0.logic:getCurrentRoadInfo()
	local var_119_1 = arg_119_0.logic:getRoadEventObjectList(var_119_0.road_id)
	
	if not var_119_1 then
		Log.e("battle", "멥이벤트 데이터가 정상적으로 수신 되지 않았습니다.!")
		
		return 
	end
	
	for iter_119_0, iter_119_1 in pairs(var_119_1) do
		if iter_119_1:isObjectType() and iter_119_1.type ~= "npc" then
			local var_119_2 = BattleField:getRoadEventModelData(iter_119_1)
			
			if var_119_2.model_id then
				local var_119_3, var_119_4 = string.gsub(var_119_2.model_id, ".scsp$", ".atlas")
				
				if var_119_4 == 1 then
					preload(var_119_2.model_id, var_119_3)
				end
			end
		end
	end
end

function Battle.addModel(arg_120_0, arg_120_1, arg_120_2, arg_120_3, arg_120_4, arg_120_5)
	arg_120_1.model = arg_120_2
	
	arg_120_1.model:setLuaTag({
		unit = arg_120_1
	})
	BattleUtil:updateModel(arg_120_1, "idle")
	arg_120_2:setVisible(false)
	arg_120_2:setPosition(arg_120_4.x, arg_120_4.y)
	arg_120_2:setLocalZOrder(arg_120_4.z)
	
	if arg_120_1.inst.ally == ENEMY and arg_120_2:getScaleX() > 0 then
		arg_120_2:setScaleX(0 - arg_120_2:getScaleX())
	end
	
	if arg_120_1.inst.ally == FRIEND and arg_120_2:getScaleX() < 0 then
		arg_120_2:setScaleX(0 - arg_120_2:getScaleX())
	end
	
	BGI.main.layer:addChild(arg_120_2)
	arg_120_2:setName("model." .. arg_120_1.inst.uid)
	arg_120_2:updateModelParent(BGI.main.layer)
	
	if arg_120_1.inst.code == "cleardummy" then
		arg_120_2:setVisible(false)
	else
		arg_120_2:loadTexture()
		arg_120_2:createShadow()
	end
	
	for iter_120_0, iter_120_1 in pairs(arg_120_1.states.List) do
		if not iter_120_1:isInvalid() then
			local var_120_0 = arg_120_5 ~= true
			
			arg_120_0:onAddState(arg_120_1, iter_120_1, true, var_120_0)
		end
	end
	
	BattleUI:register(arg_120_1, arg_120_3)
end

function GetControlCount(arg_121_0)
	local var_121_0 = 0
	
	for iter_121_0, iter_121_1 in pairs(arg_121_0:getChildren()) do
		var_121_0 = var_121_0 + GetControlCount(iter_121_1)
	end
	
	return var_121_0 + arg_121_0:getChildrenCount()
end

function Battle.layoutFriends(arg_122_0)
	local var_122_0, var_122_1 = TeamLayout:build(arg_122_0.logic.friends, true, nil, arg_122_0.logic.pet)
	local var_122_2 = BattleLayout:addTeamLayoutData(var_122_0, FRIEND, var_122_1)
	
	for iter_122_0 = 1, #var_122_0 do
		local var_122_3 = var_122_0[iter_122_0].unit
		
		if not var_122_3:isDead() and (not var_122_3.remain or arg_122_0.is_screen_restoring) and not DEBUG.DEBUG_ONLY_ENEMIES then
			local var_122_4 = var_122_3.db.model_id
			local var_122_5 = var_122_3.db.model_opt
			
			if DEBUG.DEBUG_MODEL_CODE and iter_122_0 == 1 then
				var_122_4 = DEBUG.DEBUG_MODEL_CODE
			end
			
			if DEBUG.TARGET_UNIT_CODE == var_122_3.db.code then
				var_122_4 = DB("character", DEBUG.CHANGE_UNIT_CODE, {
					"model_id"
				})
			end
			
			if var_122_5 == "spirit_dark.opt" and string.match(getenv("os_version"), "^ios ?1[2-3]") then
				var_122_5 = nil
			end
			
			local var_122_6 = var_122_3.db.skin
			
			if DEBUG.DEBUG_SKIN and iter_122_0 == 1 then
				var_122_6 = DEBUG.DEBUG_SKIN
			end
			
			local var_122_7 = var_122_3.db.atlas
			local var_122_8 = CACHE:getModel(var_122_4, var_122_6, "idle", var_122_7, var_122_5)
			
			print("load model : ", var_122_8:getName())
			var_122_8:setColor(arg_122_0.vars.ambient_color or cc.c3b(255, 255, 255))
			var_122_8:setScale(var_122_3.db.scale or 1)
			arg_122_0:addModel(var_122_3, var_122_8, iter_122_0, var_122_0[iter_122_0])
		end
	end
	
	if var_122_1 then
		local var_122_9 = var_122_1.pet
		local var_122_10 = var_122_9:getGrade()
		local var_122_11 = var_122_9:getModelID()
		local var_122_12 = var_122_9:getModelScale()
		local var_122_13 = CACHE:getModel(var_122_11, nil, "idle")
		
		var_122_9.model = var_122_13
		
		var_122_9.model:setLuaTag({
			pet = var_122_13
		})
		BattleUtil:updateModel(var_122_9, "idle")
		var_122_13:setColor(arg_122_0.vars.ambient_color or cc.c3b(255, 255, 255))
		var_122_13:setScale(var_122_12)
		var_122_13:setVisible(false)
		var_122_13:setPosition(var_122_1.x, var_122_1.y)
		var_122_13:setLocalZOrder(var_122_1.z)
		BGI.main.layer:addChild(var_122_13)
		var_122_13:loadTexture()
		var_122_13:createShadow()
	end
	
	var_122_2:updatePose()
	var_122_2:updateModelPose()
	
	return var_122_2
end

function Battle.layoutEnemies(arg_123_0, arg_123_1)
	local var_123_0 = TeamLayout:build(arg_123_0.logic.enemies, arg_123_0.logic:isPVP(), arg_123_0.logic:isPVP())
	local var_123_1 = BattleLayout:addTeamLayoutData(var_123_0, ENEMY)
	
	var_123_1:setVisible(false)
	
	local var_123_2 = BattleLayout:getTeamDistance() * BattleLayout:getDirection()
	
	var_123_1:setPosition(var_123_2, 0)
	var_123_1:setInitPosition(var_123_2, 0)
	var_123_1:setDirection(-1)
	
	if arg_123_0.is_screen_restoring and (arg_123_0.logic:isBurning() or arg_123_0.logic:isDescent()) and arg_123_0.logic:isCompletedRoadEvent(arg_123_1) then
		Log.i("강림 및 버닝 전투 복구 처리(onEncounterEnemy 2번 호출되는 현상) -- 임시로 진행 후 추후 구조적인 문제점 파악 필요")
	else
		print("==================================================================== Battle.layoutEnemiesNew ==================================================================")
		
		for iter_123_0 = 1, #var_123_0 do
			local var_123_3 = var_123_0[iter_123_0].unit
			local var_123_4 = CACHE:getModel(var_123_3.db.model_id, var_123_3.db.skin, "idle", var_123_3.db.atlas, var_123_3.db.model_opt)
			
			for iter_123_1 = 1, 10 do
				local var_123_5, var_123_6, var_123_7, var_123_8, var_123_9, var_123_10, var_123_11, var_123_12 = DB("character_model_combine", string.format("%s#%d", var_123_3.db.code, iter_123_1), {
					"combine_model_id",
					"combine_skin",
					"combine_atlas",
					"combine_model_opt",
					"combine_x",
					"combine_y",
					"combine_z",
					"combine_scale"
				})
				
				if var_123_5 then
					local var_123_13 = CACHE:getModel(var_123_5, var_123_6, "idle", var_123_7, var_123_8)
					
					if get_cocos_refid(var_123_13) then
						local var_123_14 = var_123_12 or 2
						local var_123_15 = to_n(var_123_9)
						local var_123_16 = to_n(var_123_10)
						local var_123_17 = var_123_11 or -1
						
						var_123_4:attachRelatedModel(var_123_13, {
							offset_x = var_123_15,
							offset_y = var_123_16,
							offset_z = var_123_17,
							offset_scale = var_123_14
						})
					end
				end
			end
			
			var_123_4:setScale(var_123_3.db.scale)
			var_123_4:setColor(arg_123_0.vars.ambient_color)
			arg_123_0:addModel(var_123_3, var_123_4, iter_123_0, var_123_0[iter_123_0])
			
			if var_123_3.ui_vars and var_123_3.ui_vars.gauge then
				var_123_3.ui_vars.gauge:setIndividualShow(false)
			end
			
			if DEBUG.DEBUG_MODEL_CODE and not var_123_4:getChildByName("debug_name") then
				local var_123_18 = ccui.Text:create()
				
				var_123_18:setName("debug_name")
				var_123_18:setString(var_123_3.inst.code)
				var_123_18:setFontSize(24)
				var_123_18:setScaleX(-1)
				var_123_18:setTextColor(cc.c3b(255, 0, 0))
				var_123_18:enableOutline(cc.c3b(0, 0, 0), 1)
				var_123_4:addChild(var_123_18)
			end
		end
	end
	
	return var_123_1
end

function Battle.getRoadEventMissionNewStates(arg_124_0, arg_124_1)
	local var_124_0 = {}
	local var_124_1
	
	if arg_124_1.value and arg_124_1.value.npc then
		var_124_1 = arg_124_1.value.npc
		
		local var_124_2
		local var_124_3
		
		for iter_124_0 = 1, 20 do
			local var_124_4 = string.format("%s_%d", var_124_1, iter_124_0)
			local var_124_5 = DB("level_npc", var_124_4, "mission_id")
			
			if var_124_5 and ConditionContentsManager:isMissionCleared(var_124_5, {
				inbattle = true
			}) and arg_124_0.logic:getMissionState(var_124_5) ~= "clear" then
				var_124_0[var_124_5] = "clear"
			end
		end
	end
	
	return var_124_0
end

function Battle.syncRoadMissionStates(arg_125_0, arg_125_1)
	local var_125_0 = arg_125_0.logic:getRoadObject(arg_125_1.road_id)
	local var_125_1 = {}
	
	for iter_125_0, iter_125_1 in pairs(var_125_0.event_object_list) do
		table.merge(var_125_1, arg_125_0:getRoadEventMissionNewStates(iter_125_1))
	end
	
	if table.count(var_125_1) > 0 then
		arg_125_0.logic:command({
			cmd = "MissionStates",
			mission_states = var_125_1
		})
	end
end

function Battle.layoutRoadEventModel(arg_126_0, arg_126_1)
	print("layoutRoadEventModel road_event_id = ", arg_126_1, arg_126_0.logic:isDestroyedRoadEvent(arg_126_1))
	
	if arg_126_0.logic:isDestroyedRoadEvent(arg_126_1) then
		return 
	end
	
	if arg_126_0.is_screen_restoring and arg_126_0.logic:isCompletedRoadEvent(arg_126_1) then
		return 
	end
	
	local var_126_0 = arg_126_0.logic:getRoadEventObject(arg_126_1)
	
	if not var_126_0 then
		return 
	end
	
	local var_126_1 = arg_126_0.logic:getCurrentRoadInfo()
	local var_126_2 = arg_126_0.logic:getRoadEventExtraInfo(arg_126_1)
	
	var_126_2.npc_dir = var_126_1.road_reverse and -1 or 1
	
	local var_126_3 = BattleField:makeRoadEventModel(arg_126_0.logic, var_126_0, var_126_2)
	local var_126_4 = var_126_1.road_reverse and 1 or -1
	
	if get_cocos_refid(var_126_3) then
		if string.starts(var_126_0.type or "", "npc") then
			var_126_3:setScaleX(var_126_4 * math.abs(var_126_3:getScaleX()))
			var_126_3:appearAction()
		elseif var_126_0.type == "warp" then
			var_126_3:appearAction()
		end
		
		if arg_126_0.logic:isCompletedRoadEvent(arg_126_1) and not var_126_0.always_fire then
			if var_126_3.destroy_type then
				arg_126_0.logic:command({
					cmd = "DestroyRoadEvent",
					road_event_id = arg_126_1
				})
				var_126_3:destroyAction(var_126_3:getParent())
			end
		else
			BattleUI:displayRoadEventObjectGuideUI(var_126_0, var_126_3)
		end
	end
	
	return var_126_0
end

function Battle.playAttacked(arg_127_0, arg_127_1)
	local var_127_0 = arg_127_1.target
	local var_127_1 = arg_127_1.cur_hit == arg_127_1.tot_hit
	local var_127_2
	
	UIBattleAttackOrder:updateBattleResInfo(var_127_0)
	
	local var_127_3 = arg_127_1.from
	
	if var_127_3 then
		local var_127_4 = arg_127_0.viewer:getAttackInfo(var_127_3)
		
		if var_127_4 then
			if arg_127_1.tag then
				arg_127_0:onFireEffect(var_127_4, {
					attacker = var_127_3,
					targets = {
						arg_127_1.target
					},
					eff_info = arg_127_1.tag.eff_info
				})
			end
			
			arg_127_0:playDamageSoul(var_127_3, arg_127_1, var_127_4)
		end
	end
	
	arg_127_0:playDamageMotion(var_127_0, arg_127_1)
	arg_127_0:playDamageColor(var_127_0.model, arg_127_1)
	
	if arg_127_1.critical or arg_127_1.smite then
		local var_127_5 = systick()
		
		if not arg_127_0.vars.critical_blink_tm then
			arg_127_0.vars.critical_blink_tm = 0
		end
		
		local var_127_6, var_127_7 = BattleLayout:getUnitFieldPosition(var_127_0)
		
		if var_127_5 > arg_127_0.vars.critical_blink_tm + 250 then
			if arg_127_1.critical then
				local var_127_8 = cc.LayerColor:create(cc.c3b(255, 0, 0))
				
				if IS_PUBLISHER_ZLONG then
					var_127_8:setColor(cc.c3b(240, 146, 50))
				end
				
				var_127_8:setPositionX(var_127_6)
				var_127_8:setScale(8 / BGI.main.layer:getScaleX())
				var_127_8:setOpacity(180)
				var_127_8:setLocalZOrder(-1)
				BGI.main.layer:addChild(var_127_8)
				BattleAction:Remove("battle.critical", nil, true)
				BattleAction:Add(SEQ(DELAY(40), SHOW(false), DELAY(50), SHOW(true), DELAY(50), REMOVE()), var_127_8, "battle.critical")
			elseif arg_127_1.smite then
				local var_127_9 = cc.LayerColor:create(cc.c3b(255, 0, 0))
				
				if IS_PUBLISHER_ZLONG then
					var_127_9:setColor(cc.c3b(240, 146, 50))
				end
				
				var_127_9:setPositionX(var_127_6)
				var_127_9:setScale(8 / BGI.main.layer:getScaleX())
				var_127_9:setOpacity(150)
				var_127_9:setLocalZOrder(-1)
				BGI.main.layer:addChild(var_127_9)
				BattleAction:Remove("battle.critical", nil, true)
				BattleAction:Add(SEQ(DELAY(50), REMOVE()), var_127_9, "battle.critical")
			end
			
			arg_127_0.vars.critical_blink_tm = var_127_5
		end
	end
	
	UIBattleAttackOrder:playAttacked(var_127_0)
	
	if var_127_1 then
	end
end

function Battle.playDamageMotion(arg_128_0, arg_128_1, arg_128_2)
	if not get_cocos_refid(arg_128_1.model) then
		return 
	end
	
	if arg_128_1:isIgnoreHitAction() then
		return 
	end
	
	local var_128_0 = false
	
	if arg_128_2.from and get_cocos_refid(arg_128_2.from.model) then
		var_128_0 = StageStateManager:hasStateActionFlagsByActor(arg_128_2.from.model, "ignore_default_motion")
	end
	
	if var_128_0 then
		print("ignore_default_motion", var_128_0)
		
		return 
	end
	
	local var_128_1
	local var_128_2
	local var_128_3 = BattleDelay.attack:getDelay(Battle.logic, arg_128_2)
	local var_128_4 = arg_128_2.cur_hit == arg_128_2.tot_hit
	
	if var_128_4 then
		var_128_2 = arg_128_0:getIdleAction(arg_128_1)
	else
		var_128_2 = NONE()
	end
	
	if var_128_4 and arg_128_2.fly and arg_128_0.vars.selected_target == arg_128_1 and not arg_128_2.miss then
		local var_128_5, var_128_6 = BattleLayout:getUnitFieldPosition(arg_128_1)
		local var_128_7 = 250
		local var_128_8 = DESIGN_HEIGHT * 0.3
		
		if not arg_128_1:isDead() then
			var_128_2 = SEQ(DMOTION("rise"), arg_128_0:getIdleAction(arg_128_1))
		end
		
		var_128_1 = SEQ(MOTION("flying", true), LOG(MOVE_BY(var_128_7, 0, var_128_8), 50), SEQ(DELAY(100), MOTION("down", true), RLOG(MOVE_TO(350, var_128_5, var_128_6), 500), DMOTION("knock_down")))
	elseif arg_128_2.miss or arg_128_2.damage < 1 then
		var_128_1 = DELAY(var_128_3)
	else
		local var_128_9 = false
		local var_128_10 = NONE()
		
		ShakeManager:each(function(arg_129_0)
			if arg_129_0:getName() ~= "default/damage" then
				var_128_9 = true
				
				return false
			end
		end)
		
		if not var_128_9 then
			Log.d("==================== USING default shake =======================")
			
			var_128_10 = SHAKE_CAM("default/damage", 150, 70, 35)
		end
		
		var_128_1 = SPAWN(DMOTION(var_128_3, "attacked", false), var_128_10)
	end
	
	local var_128_11
	local var_128_12 = BattleAction:Add(var_128_1, arg_128_1.model, "battle.damage_motion").TOTAL_TIME
	
	if var_128_2 then
		local var_128_13 = "battle.damage_motion_finish" .. tostring(arg_128_1:getUID())
		
		BattleAction:Add(SEQ(DELAY(var_128_12), var_128_2), arg_128_1.model, var_128_13)
	end
end

function Battle.playDamageSoul(arg_130_0, arg_130_1, arg_130_2, arg_130_3)
	if arg_130_3 then
		local var_130_0 = 0
		
		if arg_130_2.cur_hit ~= arg_130_2.tot_hit then
			return 
		end
		
		local var_130_1 = math.max(0, (arg_130_3.tot_soul or 0) - (arg_130_3.soul_cnt or 0))
		
		arg_130_3.soul_cnt = (arg_130_3.soul_cnt or 0) + (var_130_1 or 0)
		
		local var_130_2 = arg_130_0.viewer:getAttackInfo(arg_130_1).d_units
		
		if not arg_130_0.viewer:isSpectator() then
			BattleUI:gainSoulEffectByAttacker(arg_130_1, var_130_2, var_130_1)
		end
	end
end

function Battle.onCheckFinishRoadEvent(arg_131_0)
	if arg_131_0.logic:getCurrentRoadType() == "goblin" then
		local var_131_0 = arg_131_0.logic:getLastRoadEventObject()
		
		if arg_131_0.logic:isCompletedRoadEvent(var_131_0.event_id) then
			local var_131_1 = BattleField:getRoadEventObjectList()
			
			for iter_131_0, iter_131_1 in pairs(var_131_1) do
				if iter_131_1.type == "goblin_return" then
					return true
				end
			end
			
			BattleLayout:setPause(true)
			
			local var_131_2 = RoadEvent:create({
				type = "goblin_return"
			})
			local var_131_3 = BattleField:getRoadEventFieldModel(var_131_0)
			
			if get_cocos_refid(var_131_3) then
				local var_131_4 = BattleField:makeRoadEventModel(arg_131_0.logic, var_131_2, {
					position_y = 0,
					position = 1180
				})
				
				var_131_4:appearAction()
				
				local var_131_5 = ccui.Button:create()
				
				var_131_5:setTouchEnabled(true)
				var_131_5:ignoreContentAdaptWithSize(false)
				var_131_5:setContentSize(480, 800)
				var_131_5:setPosition(0, 360)
				var_131_5:addTouchEventListener(function(arg_132_0, arg_132_1)
					if arg_132_1 ~= 2 then
						return 
					end
					
					if arg_132_0:getName() == "goblin_return" then
						var_131_5:setTouchEnabled(false)
						Battle:backToField()
					end
				end)
				var_131_5:setName("goblin_return")
				var_131_4:addChild(var_131_5)
			end
			
			return true
		end
	end
end

function Battle.onReachMoveable(arg_133_0, arg_133_1, arg_133_2)
	BattleLayout:setFieldPosition(arg_133_2)
	
	if not arg_133_0:isAutoPlaying() then
		return 
	end
	
	if not PetUtil:isEnableAutoClick() then
		return 
	end
	
	local var_133_0 = BattleField:getRoadEventObjectList()
	
	for iter_133_0, iter_133_1 in pairs(var_133_0) do
		if iter_133_1.type == "goblin_return" then
			local var_133_1 = BattleField:getRoadEventFieldModel(iter_133_1)
			
			if get_cocos_refid(var_133_1) then
				local var_133_2 = var_133_1:getChildByName("goblin_return")
				
				if get_cocos_refid(var_133_2) and var_133_2:isTouchEnabled() then
					var_133_2:setTouchEnabled(false)
					Battle:backToField()
				end
			end
		end
	end
end

function Battle.onArrivedWarpLine(arg_134_0, arg_134_1)
	if not Battle:canMoveable() then
		return 
	end
	
	local function var_134_0()
		if arg_134_0.logic:isTutorial() then
			Dialog:msgBox(T("battle_giveup_tuto"))
			BattleLayout:setDirection(1)
			BattleLayout:setPause(false)
			BattleLayout:moveToFieldPosition(0)
			
			return 
		end
		
		if arg_134_0.logic:getFinalResult() == "win" then
			BattleLayout:moveToFieldPosition(BattleField.road_field_info.reach_wall_left - DESIGN_WIDTH * 0.3)
			Dialog:msgBox(T("msg_go_lobby"), {
				yesno = true,
				handler = function()
					ClearResult:stopNextDungeonSound()
					SceneManager:nextScene("lobby")
					SceneManager:resetSceneFlow()
				end,
				cancel_handler = function()
					Battle:backToRoad()
				end,
				yes_text = T("msg_go_out")
			})
		else
			Dialog:msgBox(T("battle_giveup_confirm"), {
				yesno = true,
				handler = function()
					Battle:endBattleScene({
						giveup = true
					})
				end,
				cancel_handler = function()
					BattleLayout:setDirection(1)
					BattleLayout:setPause(false)
					BattleLayout:moveToFieldPosition(0)
				end,
				yes_text = T("ui_inbattle_esc_giveup")
			})
		end
	end
	
	local function var_134_1(arg_140_0)
		return arg_140_0 == "left" or arg_140_0 == "up"
	end
	
	BattleLayout:setPause(true)
	
	if arg_134_0.logic:getStageMainType() == "adv" then
		local var_134_2 = arg_134_0.logic:getCurrentRoadInfo()
		local var_134_3 = arg_134_0.logic:getRoadMazeData(var_134_2.road_id)
		
		if var_134_3 then
			local var_134_4
			
			if var_134_1(var_134_2.road_dir) == var_134_1(arg_134_1) then
				var_134_4 = var_134_2.road_dir
			else
				var_134_4 = to_reverse_dir(var_134_2.road_dir)
			end
			
			local var_134_5 = var_134_3.dirs[var_134_4]
			
			if var_134_5 then
				arg_134_0:warpToRoad(var_134_5.goal_id)
			else
				table.print(var_134_3)
				error("maze_data dir error " .. var_134_2.road_id)
			end
		else
			if arg_134_0.logic:getCurrentRoadType() == "goblin" then
				return 
			end
			
			arg_134_0:backToField()
		end
	elseif var_134_1(arg_134_1) then
		var_134_0()
	else
		if arg_134_0.logic:getFinalResult() == "win" then
			if ClearResult:playNextDungeon(500) then
				BattleLayout:stopImmediate()
				BattleLayout:moveToFieldPosition(BattleField.road_field_info.reach_wall_right + 250)
			else
				BattleLayout:moveToFieldPosition(BattleLayout:getFieldPosition() - VIEW_WIDTH * 0.1)
				BattleLayout:setPause(false)
			end
			
			return 
		end
		
		if arg_134_0.logic:getCurrentRoadType() == "chaos" then
			BattleLayout:moveToFieldPosition(BattleLayout:getFieldPosition() + VIEW_WIDTH * 2)
			arg_134_0:backToField()
			
			return 
		end
		
		if arg_134_0.logic:getCurrentRoadType() == "goblin" then
		end
	end
end

function Battle.doStopFriends(arg_141_0)
	for iter_141_0, iter_141_1 in pairs(arg_141_0.logic.friends or {}) do
		if iter_141_1 and not iter_141_1:isDead() then
			iter_141_1.mover:stopScheduler()
		end
	end
end

function Battle.changeAmbientColor(arg_142_0, arg_142_1, arg_142_2)
	arg_142_2 = arg_142_2 or {}
	
	local var_142_0 = arg_142_2.ambient_color or arg_142_1.res.ambient_color or "FFFFFF"
	
	if DEBUG.AMBIENT_COLOR then
		var_142_0 = DEBUG.AMBIENT_COLOR
	end
	
	arg_142_0.vars.ambient_color = cc.c3b(tonumber("0x" .. var_142_0:sub(1, 2)), tonumber("0x" .. var_142_0:sub(3, 4)), tonumber("0x" .. var_142_0:sub(5, 6)))
	arg_142_0.vars.disable_color = cc.c3b(arg_142_0.vars.ambient_color.r * 0.4, arg_142_0.vars.ambient_color.g * 0.4, arg_142_0.vars.ambient_color.b * 0.4)
end

function Battle.changeBGM(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4)
	if arg_143_3 then
		if arg_143_3 == "bgm_rta_lounge2" then
			local var_143_0 = arg_143_1.res.bgm
			
			SoundEngine:playBGM("event:/bgm/" .. (var_143_0 or "map01"))
		else
			local var_143_1 = MusicBox:getSong(arg_143_3) and .streaming_id
			local var_143_2 = var_143_1 and cc.FileUtils:getInstance():fullPathForFilename("bgm_ost/" .. var_143_1)
			
			if arg_143_4 then
				SoundEngine:playBGMWithFadeInOut(var_143_1 and var_143_2 or "event:/bgm/" .. arg_143_3, 1000)
			else
				SoundEngine:playBGM(var_143_1 and var_143_2 or "event:/bgm/" .. arg_143_3, nil, true)
			end
		end
	else
		local var_143_3 = arg_143_1.res.bgm
		
		SoundEngine:playBGM("event:/bgm/" .. (var_143_3 or "map01"))
	end
end

function Battle.getBroadCastData(arg_144_0)
	local function var_144_0(arg_145_0, arg_145_1)
		if not arg_145_0 or not arg_145_1 or not arg_145_0[arg_145_1] then
			return {}
		end
		
		local var_145_0 = {}
		
		for iter_145_0, iter_145_1 in pairs(arg_145_0[arg_145_1]) do
			table.insert(var_145_0, iter_145_1.code)
		end
		
		return var_145_0
	end
	
	local function var_144_1(arg_146_0, arg_146_1, arg_146_2)
		local var_146_0 = {}
		
		arg_146_0 = arg_146_0 or {}
		
		local var_146_1 = 5
		
		if arg_146_2 and arg_146_2 >= 7 then
			var_146_1 = 7
		end
		
		for iter_146_0 = 1, var_146_1 do
			local var_146_2 = "round" .. tostring(iter_146_0) .. "Win"
			
			if arg_146_0[iter_146_0] then
				if arg_146_0[iter_146_0].state == "finish" or arg_146_0[iter_146_0].state == "benefit" then
					if arg_146_0[iter_146_0].winner == "draw" then
						var_146_0[var_146_2] = 0
					elseif arg_146_0[iter_146_0].winner == arg_146_1 then
						var_146_0[var_146_2] = 1
					else
						var_146_0[var_146_2] = -1
					end
				else
					var_146_0[var_146_2] = -2
				end
			else
				var_146_0[var_146_2] = -2
			end
		end
		
		return var_146_0
	end
	
	local function var_144_2(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
		local var_147_0 = {}
		local var_147_1 = arg_144_0.logic:getRtaPenaltyDB(arg_147_3)
		
		for iter_147_0 = 1, arg_147_1 do
			local var_147_2 = "cs_" .. arg_147_2 .. iter_147_0 .. "_value"
			local var_147_3 = {
				type = arg_147_0 + iter_147_0,
				value = var_147_1 and var_147_1[var_147_2] or 0
			}
			
			table.insert(var_147_0, var_147_3)
		end
		
		return var_147_0
	end
	
	local function var_144_3(arg_148_0)
		return {
			name = arg_148_0.name,
			world = arg_148_0.world,
			clan_name = arg_148_0.clan_name,
			user_id = tostring(arg_148_0.user_id)
		}
	end
	
	local function var_144_4(arg_149_0)
		if arg_149_0 == "cp" then
			return 1
		elseif arg_149_0 == "bp" then
			return 2
		else
			return 0
		end
	end
	
	local function var_144_5(arg_150_0, arg_150_1, arg_150_2)
		if not arg_150_2 or not arg_150_1 or not arg_150_2[arg_150_1] then
			return {}
		end
		
		local var_150_0 = {
			[arg_150_1] = {}
		}
		local var_150_1 = arg_150_0 == FRIEND and arg_144_0.logic.friends or arg_144_0.logic.enemies
		local var_150_2 = {}
		local var_150_3 = {}
		
		for iter_150_0, iter_150_1 in pairs(arg_150_2[arg_150_1]) do
			local var_150_4 = table.find(var_150_1, function(arg_151_0, arg_151_1)
				return arg_151_1.inst.code == iter_150_1.code
			end)
			
			if var_150_4 then
				if var_150_1[var_150_4]:isDead() then
					table.insert(var_150_3, iter_150_1)
				else
					table.insert(var_150_2, iter_150_1)
				end
			end
		end
		
		for iter_150_2, iter_150_3 in pairs(var_150_2 or {}) do
			table.insert(var_150_0[arg_150_1], iter_150_3)
		end
		
		for iter_150_4, iter_150_5 in pairs(var_150_3 or {}) do
			table.insert(var_150_0[arg_150_1], iter_150_5)
		end
		
		return var_144_0(var_150_0, arg_150_1)
	end
	
	local function var_144_6(arg_152_0, arg_152_1, arg_152_2)
		local var_152_0 = arg_152_0.first_pick_arena_uid
		local var_152_1 = var_152_0 == arg_152_1 and arg_152_2 or arg_152_1
		local var_152_2 = {}
		
		if arg_152_0.pickinfo and var_152_0 and var_152_1 and arg_152_0.pickinfo[var_152_0] and arg_152_0.pickinfo[var_152_1] then
			var_152_2[arg_152_0.pickinfo[var_152_0][1].code] = 1
			var_152_2[arg_152_0.pickinfo[var_152_1][1].code] = 2
			var_152_2[arg_152_0.pickinfo[var_152_1][2].code] = 3
			var_152_2[arg_152_0.pickinfo[var_152_0][2].code] = 4
			var_152_2[arg_152_0.pickinfo[var_152_0][3].code] = 5
			var_152_2[arg_152_0.pickinfo[var_152_1][3].code] = 6
			var_152_2[arg_152_0.pickinfo[var_152_1][4].code] = 7
			var_152_2[arg_152_0.pickinfo[var_152_0][4].code] = 8
			var_152_2[arg_152_0.pickinfo[var_152_0][5].code] = 9
			var_152_2[arg_152_0.pickinfo[var_152_1][5].code] = 10
		end
		
		return var_152_2
	end
	
	if not arg_144_0.vars or not arg_144_0.logic then
		return 
	end
	
	local var_144_7 = arg_144_0.viewer:getMatchInfo() or {}
	local var_144_8 = var_144_7.user_info.uid
	local var_144_9 = var_144_7.enemy_user_info.uid
	local var_144_10 = var_144_7.round_info or {}
	local var_144_11 = BroadCastHelper.make_accumulate_preban_info(var_144_10)
	local var_144_12 = arg_144_0.logic:getTurnOwner()
	local var_144_13 = var_144_6(var_144_7, var_144_8, var_144_9)
	local var_144_14 = {
		deviceID = BroadCastHelper.get_device_info(),
		header = {}
	}
	
	if var_144_10.rounds then
		var_144_14.header.cur_round = table.count(var_144_10.rounds)
	else
		var_144_14.header.cur_round = 1
	end
	
	var_144_14.header.tot_round = var_144_10.total or 1
	
	if var_144_7.game_info.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		var_144_14.header.game_type = 1
	elseif var_144_7.game_info.rule == ARENA_NET_BATTLE_RULE.DRAFT then
		var_144_14.header.game_type = 2
	end
	
	var_144_14.battleInfoPlayer1 = {}
	var_144_14.battleInfoPlayer1.playerInfo = var_144_3(var_144_7.user_info)
	var_144_14.battleInfoPlayer1.roundInfo = var_144_1(var_144_10.rounds, var_144_8, var_144_10.total)
	var_144_14.battleInfoPlayer1.pickHeroList = var_144_0(var_144_7.pickinfo, var_144_8)
	var_144_14.battleInfoPlayer1.preBanHeroList = var_144_0(var_144_7.prebaninfo, var_144_8)
	var_144_14.battleInfoPlayer1.accumulatePreBanHeroList = var_144_0(var_144_11, var_144_8)
	var_144_14.battleInfoPlayer1.banHeroList = var_144_0(var_144_7.baninfo, var_144_8)
	var_144_14.battleInfoPlayer1.battleHeroList = var_144_5(FRIEND, var_144_8, var_144_7.pickinfo)
	var_144_14.battleInfoPlayer1.soulburnCount = math.floor((arg_144_0.logic:getTeamRes(FRIEND, "soul_piece") or 0) * 0.1) or 0
	var_144_14.battleInfoPlayer2 = {}
	var_144_14.battleInfoPlayer2.playerInfo = var_144_3(var_144_7.enemy_user_info)
	var_144_14.battleInfoPlayer2.roundInfo = var_144_1(var_144_10.rounds, var_144_9, var_144_10.total)
	var_144_14.battleInfoPlayer2.pickHeroList = var_144_0(var_144_7.pickinfo, var_144_9)
	var_144_14.battleInfoPlayer2.preBanHeroList = var_144_0(var_144_7.prebaninfo, var_144_9)
	var_144_14.battleInfoPlayer2.accumulatePreBanHeroList = var_144_0(var_144_11, var_144_9)
	var_144_14.battleInfoPlayer2.banHeroList = var_144_0(var_144_7.baninfo, var_144_9)
	var_144_14.battleInfoPlayer2.battleHeroList = var_144_5(ENEMY, var_144_9, var_144_7.pickinfo)
	var_144_14.battleInfoPlayer2.soulburnCount = math.floor((arg_144_0.logic:getTeamRes(ENEMY, "soul_piece") or 0) * 0.1) or 0
	var_144_14.battleBoard = {}
	var_144_14.battleBoard.progressStatus = not arg_144_0.vars.end_battle and 1 or 0
	var_144_14.battleBoard.duration = os.time() - arg_144_0.vars.start_time
	var_144_14.battleBoard.boardHeroInfoList = {}
	
	for iter_144_0, iter_144_1 in pairs(arg_144_0.logic.allocated_unit_tbl or {}) do
		local var_144_15 = {
			code = iter_144_1.db.code,
			color = iter_144_1:getAlly() == FRIEND and 1 or 0,
			hp = iter_144_1:getHP(),
			max_hp = iter_144_1:getMaxHP(),
			sp_type = var_144_4(iter_144_1:getSPName()),
			sp = iter_144_1:getSP(),
			max_sp = iter_144_1:getMaxSP(),
			actionGauge = math.min(MAX_UNIT_TICK, iter_144_1.inst.elapsed_ut) + 0.0001
		}
		
		if var_144_12 == iter_144_1 then
			var_144_15.actionGauge = MAX_UNIT_TICK + 1
		end
		
		var_144_15.skill_info = {}
		
		for iter_144_2 = 1, 3 do
			local var_144_16 = iter_144_1:getSkillBundle():slot(iter_144_2)
			
			if var_144_16 then
				local var_144_17 = var_144_16:getSkillId()
				local var_144_18 = DB("skill", iter_144_1:getSkillByIndex(iter_144_2), {
					"sk_icon"
				})
				local var_144_19 = iter_144_1:getSkillLevel(var_144_17)
				local var_144_20, var_144_21, var_144_22, var_144_23, var_144_24 = var_144_16:checkUseSkill()
				local var_144_25 = var_144_16:getOwner() and var_144_16:getSoulBurnSkill()
				local var_144_26
				local var_144_27 = DB("skill", var_144_17, {
					"showcooltimeskill"
				})
				local var_144_28
				
				if var_144_27 then
					var_144_28 = iter_144_1:getSkillByIndex(to_n(var_144_27))
				else
					var_144_28 = var_144_17
				end
				
				if var_144_28 then
					local var_144_29 = iter_144_1:getSkillCool(var_144_28)
					local var_144_30 = iter_144_1:getSkillMaxCool(var_144_28) or SkillFactory.create(var_144_28, iter_144_1):getTurnCool() or var_144_29
					local var_144_31 = {
						usable = var_144_20,
						skill_id = var_144_17,
						skill_icon = var_144_18,
						upgradeCount = var_144_19,
						cool = var_144_29,
						max_cool = var_144_30,
						silence = var_144_23
					}
					
					if var_144_25 then
						var_144_31.soulburn_cost = var_144_26
					end
					
					table.insert(var_144_15.skill_info, var_144_31)
				end
			end
		end
		
		var_144_15.cs_info = {}
		
		for iter_144_3, iter_144_4 in pairs(iter_144_1.states.List or {}) do
			if iter_144_4:isValid() then
				local var_144_32 = iter_144_4:getId()
				local var_144_33 = iter_144_4:getUId()
				local var_144_34 = iter_144_4.db.cs_type == "buff" and 1 or 2
				local var_144_35, var_144_36 = UIUtil:getStateIconPath(var_144_32, iter_144_1)
				
				if var_144_36 then
					local var_144_37 = iter_144_1.states:findByUId(var_144_33).db.cs_turn == 0 and 0 or iter_144_1:getStateTurn(var_144_33)
					
					table.insert(var_144_15.cs_info, {
						icon = var_144_36,
						turn = var_144_37,
						effectType = var_144_34
					})
				end
			end
		end
		
		var_144_15.is_dead = iter_144_1:isDead() or false
		var_144_15.pick_order = var_144_13[var_144_15.code]
		
		table.insert(var_144_14.battleBoard.boardHeroInfoList, var_144_15)
	end
	
	local var_144_38 = {}
	local var_144_39 = {}
	
	for iter_144_5, iter_144_6 in pairs(var_144_14.battleBoard.boardHeroInfoList or {}) do
		if iter_144_6.is_dead then
			table.insert(var_144_39, iter_144_6)
		else
			table.insert(var_144_38, iter_144_6)
		end
	end
	
	table.sort(var_144_38, function(arg_153_0, arg_153_1)
		if arg_153_0.pick_order and arg_153_1.pick_order then
			return arg_153_0.pick_order < arg_153_1.pick_order
		end
	end)
	table.sort(var_144_39, function(arg_154_0, arg_154_1)
		if arg_154_0.pick_order and arg_154_1.pick_order then
			return arg_154_0.pick_order < arg_154_1.pick_order
		end
	end)
	
	for iter_144_7, iter_144_8 in pairs(var_144_39) do
		table.insert(var_144_38, iter_144_8)
	end
	
	var_144_14.battleBoard.boardHeroInfoList = var_144_38
	
	local var_144_40 = {}
	
	for iter_144_9, iter_144_10 in pairs(var_144_14.battleBoard.boardHeroInfoList or {}) do
		table.insert(var_144_40, {
			idx = iter_144_9,
			actionGauge = iter_144_10.actionGauge
		})
	end
	
	table.sort(var_144_40, function(arg_155_0, arg_155_1)
		return arg_155_0.actionGauge > arg_155_1.actionGauge
	end)
	
	for iter_144_11, iter_144_12 in pairs(var_144_40) do
		if var_144_14.battleBoard.boardHeroInfoList[iter_144_12.idx].is_dead then
			var_144_14.battleBoard.boardHeroInfoList[iter_144_12.idx].actionGaugeOrder = 99
		else
			var_144_14.battleBoard.boardHeroInfoList[iter_144_12.idx].actionGaugeOrder = iter_144_11
		end
		
		if iter_144_11 == 1 then
			var_144_14.battleBoard.boardHeroInfoList[iter_144_12.idx].actionGauge = 100
		else
			var_144_14.battleBoard.boardHeroInfoList[iter_144_12.idx].actionGauge = math.floor(iter_144_12.actionGauge * 0.1)
		end
	end
	
	var_144_14.enthusiasmBattle = {}
	var_144_14.enthusiasmBattle.level = BattleTopBar.vars.penalty_info.id or 0
	var_144_14.enthusiasmBattle.turn = BattleTopBar.vars.penalty_info.rest
	var_144_14.enthusiasmBattle.total = BattleTopBar.vars.penalty_info.total
	var_144_14.enthusiasmBattle.increaseEffectList = var_144_2(0, 2, "good", BattleTopBar.vars.penalty_info.id)
	var_144_14.enthusiasmBattle.decreaseEffectList = var_144_2(2, 3, "harm", BattleTopBar.vars.penalty_info.id)
	
	if diff_check(arg_144_0.vars.prev_broad_data or {}, var_144_14) then
		arg_144_0.vars.prev_broad_data = var_144_14
		
		ArenaWebSocket:save("/broad_cast_battle", var_144_14)
		
		return var_144_14
	end
	
	return nil
end

function Battle.getBroadCastResultData(arg_156_0, arg_156_1, arg_156_2)
	if not arg_156_1 or not arg_156_2 or not arg_156_2.home_user_end_info then
		return 
	end
	
	if arg_156_1.game_info.rule ~= ARENA_NET_BATTLE_RULE.DRAFT then
		return 
	end
	
	if not MatchService:isBroadCastMode() then
		return 
	end
	
	local var_156_0 = "draw"
	
	if arg_156_2.winner ~= "draw" then
		local var_156_1 = tostring(arg_156_2.home_user_end_info.id)
		
		var_156_0 = tostring(arg_156_2.winner) == var_156_1 and "win" or "lose"
	end
	
	local var_156_2 = ArenaNetRoundNext:getBroadCastData(arg_156_1, arg_156_2, var_156_0)
	
	if var_156_2 then
		local var_156_3 = MatchService:getBroadCastUrl("result")
		
		ArenaWebSocket:createSingleShotWebSocket({
			scene = "result",
			url = var_156_3,
			data = var_156_2
		})
	end
end

function Battle.warpToRoad(arg_157_0, arg_157_1, arg_157_2, arg_157_3)
	if arg_157_0.logic:getRunningEventState() == "running" then
		return 
	end
	
	if arg_157_0:isRunningWarpCurtainEffect() then
		return 
	end
	
	BattleLayout:setPause(true)
	arg_157_0:onClickNextButton(false)
	
	local var_157_0 = {
		before = function()
		end,
		proc = function()
			arg_157_0.logic:command({
				cmd = "EnterRoad",
				road_id = arg_157_1,
				road_event_id = arg_157_2,
				is_portal = arg_157_3
			})
		end,
		after = function()
		end
	}
	
	arg_157_0.vars.maze_line_end = false
	
	UIBattleGuideArrow:remove()
	
	local var_157_1 = arg_157_0.logic:getSideRoadDir(arg_157_1)
	
	arg_157_0:playWarpCurtainEffect(var_157_0, var_157_1)
end

function Battle.backToField(arg_161_0, arg_161_1)
	if arg_161_0:isRunningWarpCurtainEffect() then
		return 
	end
	
	BattleLayout:setPause(true)
	arg_161_0:onClickNextButton(false)
	
	local var_161_0 = {
		before = function()
		end,
		proc = function()
			arg_161_0.logic:command({
				cmd = "ReturnRoad"
			})
		end,
		after = function()
		end
	}
	
	arg_161_0.vars.maze_line_end = false
	
	arg_161_0:playWarpCurtainEffect(var_161_0)
end

function Battle.backToRoad(arg_165_0)
	if not BattleField:IsOutOfWarpLine() then
		return 
	end
	
	BattleLayout:stopImmediate()
	ClearResult:setInputLock(true)
	BattleLayout:registMoveFinishCB(function()
		ClearResult:setInputLock(false)
		BattleLayout:setPause(false)
	end)
	
	if BattleLayout:getFieldPosition() > BattleField.road_field_info.reach_wall_right then
		BattleLayout:moveToFieldPosition(BattleField.road_field_info.reach_wall_right - 200)
	else
		BattleLayout:moveToFieldPosition(BattleField.road_field_info.reach_wall_left + 200)
	end
end

function Battle.retryPlay(arg_167_0, arg_167_1)
	if arg_167_0:isRunningWarpCurtainEffect() then
		return 
	end
	
	arg_167_0.vars.battle_state = "begin"
	arg_167_0.vars.end_battle = false
	
	BattleLayout:stopImmediate()
	ClearResult:setInputLock(true)
	
	local var_167_0 = {
		before = function()
			BattleUI:setVisible(false)
		end,
		proc = function()
			arg_167_0.logic:command({
				cmd = "RetryPlay"
			})
		end,
		after = function()
			ClearResult:setInputLock(false)
			BattleLayout:setPause(false)
			
			if arg_167_0:isAutoPlaying() then
				arg_167_0:toggleAutoBattle()
			end
		end
	}
	
	if not arg_167_0:applyTimeScaleUp() then
		arg_167_0:resetBattleTimeScale()
	end
	
	arg_167_0.vars.maze_line_end = false
	
	arg_167_0:playWarpCurtainEffect(var_167_0)
end

function Battle.isRunningWarpCurtainEffect(arg_171_0)
	return arg_171_0.vars.warpCurtain and true
end

function Battle.playWarpCurtainEffect(arg_172_0, arg_172_1, arg_172_2)
	local var_172_0 = SceneManager:getRunningNativeScene()
	local var_172_1 = {}
	
	if not arg_172_2 then
		var_172_1.sprite = CACHE:getEffect("shotchange")
		
		var_172_0:addChild(var_172_1.sprite)
		
		function var_172_1.start(arg_173_0)
			arg_173_0.sprite:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			arg_173_0.sprite:setLocalZOrder(99999)
			arg_173_0.sprite:setScale(arg_173_0.sprite:getScale() * 1.5)
			arg_173_0.sprite:setVisible(false)
			BattleAction:Add(SEQ(SHOW(true), CALL(arg_172_1.before), DMOTION("in"), DELAY(200), CALL(arg_172_1.proc)), arg_173_0.sprite, "block")
		end
		
		function var_172_1.stop(arg_174_0)
			BattleAction:Add(SEQ(DELAY(200), DMOTION("out"), SHOW(false), CALL(arg_172_1.after), REMOVE()), arg_174_0.sprite, "block")
		end
	else
		local var_172_2 = arg_172_2 == "left" or arg_172_2 == "up"
		local var_172_3 = var_172_2 and -(DESIGN_WIDTH / 2 + 640) or DESIGN_WIDTH + (DESIGN_WIDTH / 2 + 640)
		local var_172_4 = DESIGN_HEIGHT / 2
		local var_172_5 = var_172_2 and DESIGN_WIDTH + (DESIGN_WIDTH / 2 + 640) or -(DESIGN_WIDTH / 2 + 640)
		local var_172_6 = DESIGN_HEIGHT / 2
		
		var_172_1.sprite = UIUtil:getScreenTransNode()
		
		var_172_0:addChild(var_172_1.sprite)
		
		function var_172_1.start(arg_175_0)
			BattleAction:Add(SEQ(MOVE_TO(0, var_172_3, var_172_4), SHOW(true), CALL(arg_172_1.before), MOVE_TO(600, DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2), CALL(arg_172_1.proc)), arg_175_0.sprite, "block")
		end
		
		function var_172_1.stop(arg_176_0)
			BattleAction:Add(SEQ(MOVE_TO(600, var_172_5, var_172_6), CALL(arg_172_1.after), REMOVE()), arg_176_0.sprite, "block")
		end
	end
	
	var_172_1:start()
	
	arg_172_0.vars.warpCurtain = var_172_1
end

function Battle.stopWarpCurtainEffect(arg_177_0)
	if arg_177_0.vars.warpCurtain then
		arg_177_0.vars.warpCurtain:stop()
		
		arg_177_0.vars.warpCurtain = nil
	end
end

function Battle.forecastReward(arg_178_0, arg_178_1, arg_178_2)
	local var_178_0 = arg_178_1:forecastReward(arg_178_2)
	
	var_178_0.tokens = var_178_0.tokens or {}
	
	local var_178_1 = {
		to_gold = var_178_0.gold,
		to_stigma = var_178_0.stigma
	}
	
	for iter_178_0, iter_178_1 in pairs(var_178_0.tokens) do
		var_178_1[iter_178_1.code] = (var_178_1[iter_178_1.code] or 0) + iter_178_1.count
	end
	
	var_178_0.tokens = {}
	
	for iter_178_2, iter_178_3 in pairs(var_178_1) do
		table.insert(var_178_0.tokens, {
			t = "token",
			code = iter_178_2,
			count = iter_178_3
		})
	end
	
	if var_178_0.items then
		local var_178_2 = {}
		
		for iter_178_4, iter_178_5 in pairs(var_178_0.items) do
			local var_178_3 = var_178_2[iter_178_5.code] or {}
			
			var_178_2[iter_178_5.code] = {
				count = (var_178_3.count or 0) + iter_178_5.count,
				t = iter_178_5.t
			}
		end
		
		var_178_0.items = {}
		
		for iter_178_6, iter_178_7 in pairs(var_178_2) do
			table.insert(var_178_0.items, {
				t = iter_178_7.t,
				code = iter_178_6,
				count = iter_178_7.count
			})
		end
	end
	
	var_178_0.map_id = arg_178_1.map.enter
	var_178_0.time = arg_178_1.tick
	var_178_0.grade = arg_178_0.vars.last_score
	var_178_0.prev_pass_way_percent = arg_178_0.vars.prev_pass_way_percent
	
	return var_178_0
end

function Battle.doMazeUpdate(arg_179_0)
	if arg_179_0.vars.maze_line_end then
		return 
	end
	
	if string.starts(arg_179_0.logic.type, "dungeon") then
		if arg_179_0:isRunningWarpCurtainEffect() then
			return 
		end
		
		local var_179_0 = arg_179_0.logic:getCurrentRoadInfo()
		
		if var_179_0.is_cross and not arg_179_0.logic:isExistBattle(var_179_0.road_id) then
			local var_179_1 = arg_179_0.logic:getOption("clear", {
				info = var_179_0.road_id
			})
			local var_179_2 = false
			
			if not table.empty(var_179_1) then
				print("#### 클리어 포탈 띄우세요")
				
				var_179_2 = true
				
				local var_179_3 = RoadEvent:create({
					type = "clear"
				})
				local var_179_4 = BattleField:makeRoadEventModel(arg_179_0.logic, var_179_3, {
					position = DESIGN_WIDTH * 0.5
				})
				
				var_179_4:appearAction()
				BattleUI:displayRoadEventObjectGuideUI(var_179_3, var_179_4)
				
				local var_179_5 = var_179_1[1] or {}
				local var_179_6 = ccui.Button:create()
				
				var_179_6:setTouchEnabled(true)
				var_179_6:ignoreContentAdaptWithSize(false)
				var_179_6:setContentSize(480, 800)
				var_179_6:setPosition(0, 360)
				var_179_6:addTouchEventListener(function(arg_180_0, arg_180_1)
					if arg_180_1 ~= 2 then
						return 
					end
					
					if arg_180_0:getName() == "clear" then
						if CampingSiteNew:isActive() then
							return 
						end
						
						TutorialGuide:procGuide(UNLOCK_ID.MAZE_PORTAL)
						
						local var_180_0 = Dialog:msgBox(T(var_179_5.pop_desc or "clear_portal_desc"), {
							yesno = true,
							handler = function()
								local var_181_0 = false
								
								if CampingSiteNew:isActive() then
									var_181_0 = true
								end
								
								if not get_cocos_refid(var_179_6) then
									var_181_0 = true
								end
								
								if arg_179_0.logic:getCurrentRoadInfo().road_id ~= var_179_0.road_id then
									var_181_0 = true
								end
								
								if var_181_0 then
									Dialog:msgBoxUIHandler(msg_box, "btn_cancel")
									
									return 
								end
								
								var_179_6:setTouchEnabled(false)
								setenv("time_scale", 1)
								removeSavedBattleInfo()
								arg_179_0.logic:command({
									cmd = "MazeClear",
									road_id = var_179_0.road_id
								})
								
								arg_179_0.vars.clear_way = var_179_0.road_id
								
								arg_179_0:onClear(Battle.logic, arg_179_0:getClearData())
							end,
							title = T(var_179_5.pop_title or "clear_portal_title"),
							yes_text = T("exit_text")
						})
					end
				end)
				var_179_6:setName("clear")
				var_179_4:addChild(var_179_6)
			end
			
			print("#### 지도 확대하세요")
			
			arg_179_0.vars.maze_line_end = true
			
			BattleMapManager:doCrossWayAction()
			
			local var_179_7
			local var_179_8
			
			if Battle:hasClearEventInMaze(var_179_0.road_id) then
				var_179_8 = "crossroad_select_portal"
			else
				local var_179_9 = BattleMapManager:getNaviData()
				
				var_179_8 = var_179_9 and var_179_9.msg_navi or "minimap_select_direction"
			end
			
			local var_179_10 = BattleStory:getStoryData(var_179_0.road_id .. "^1") and 600 or 0
			
			UIAction:Add(SEQ(DELAY(var_179_10), CALL(add_callback_to_story, function()
				balloon_message_with_sound(var_179_8)
				
				if var_179_2 and arg_179_0.logic.map.enter == "ije005" and not SAVE:getTutorialGuide(UNLOCK_ID.MAZE_PORTAL) then
					UIAction:Add(SEQ(DELAY(600), CALL(TutorialGuide.startGuide, TutorialGuide, UNLOCK_ID.MAZE_PORTAL)), arg_179_0, "block")
				end
			end)), arg_179_0)
		end
	end
end

function Battle.savePassedWay(arg_183_0, arg_183_1)
	local var_183_0 = arg_183_1:getEnteredRoadSectorTbl()
	
	Account:setPassEvent(arg_183_1.map.enter, var_183_0)
end

function Battle.hasClearEventInMaze(arg_184_0, arg_184_1)
	return not table.empty(arg_184_0.logic:getOption("clear", {
		info = arg_184_1
	}))
end

function Battle.getInfoType(arg_185_0)
	if not arg_185_0.logic:getCurrentRoadInfo() or not arg_185_0.logic:getCurrentRoadInfo().road_id then
		return 
	end
	
	return DB("level_stage_1_info", arg_185_0.logic:getCurrentRoadInfo().road_id, "type")
end

function Battle.isReverseDirection(arg_186_0, arg_186_1)
	arg_186_1 = arg_186_1 or (arg_186_0.logic:getCurrentRoadInfo() or {}).road_dir
	
	return arg_186_1 == "up" or arg_186_1 == "left"
end

function Battle.showGuideArrow(arg_187_0)
	if not arg_187_0.logic then
		return 
	end
	
	if arg_187_0.logic:isPVP() then
		return 
	end
	
	if arg_187_0.logic:getStageMainType() == "tow" then
		return 
	end
	
	if arg_187_0.logic:getStageMainType() == "def" then
		return 
	end
	
	if arg_187_0.logic:getRunningEventState() == "running" then
		return 
	end
	
	if arg_187_0:isPlayingBattleAction() then
		return 
	end
	
	local var_187_0 = arg_187_0.logic:getCurrentRoadInfo()
	
	if var_187_0.is_cross or var_187_0.road_type == "goblin" then
		return 
	end
	
	UIBattleGuideArrow:show(var_187_0.road_dir)
end

function Battle.getCompactBattleInfo(arg_188_0)
	return {
		field_position = BattleLayout:getFieldPosition(),
		field_direction = BattleLayout:getDirection(),
		shown_events = BattleMapManager:getShowIcons(),
		played_story_list = BattleStory:getPlayedList(),
		shown_events = BattleMapManager:getShowIcons(),
		conditions_info = ConditionContentsManager:getUpdateConditions({
			force_get_update = true,
			no_reset = true,
			enter_id = arg_188_0.logic.map.enter
		})
	}
end

BATTLE_SAVE_FORMAT_VER = "1.1"

function Battle.isSupportSaveFormat(arg_189_0, arg_189_1)
	if arg_189_1 and arg_189_1.fmtver == BATTLE_SAVE_FORMAT_VER then
		return true
	end
end

function Battle.exportCurrentBattleInfo(arg_190_0)
	if not arg_190_0.logic:isSavable() then
		return 
	end
	
	local var_190_0 = {
		fmtver = BATTLE_SAVE_FORMAT_VER,
		stroy_info = {
			played_story_list = BattleStory:getPlayedList()
		},
		team_index = Account:getCurrentTeamIndex(),
		conditions_info = ConditionContentsManager:getExportConditions({
			enter_id = arg_190_0.logic.map.enter
		})
	}
	
	return arg_190_0.logic:exportPureLogicData(var_190_0)
end

function Battle.getScore(arg_191_0, arg_191_1)
	arg_191_1 = arg_191_1 or arg_191_0.logic.map.enter
	
	local var_191_0 = DB("level_enter", arg_191_1, "type") or ""
	
	if var_191_0 ~= "quest" and var_191_0 ~= "extra_quest" and not string.starts(var_191_0, "dungeon") then
		return 3
	end
	
	local var_191_1 = 3
	local var_191_2 = 0
	local var_191_3 = 0
	
	for iter_191_0 = 1, var_191_1 do
		local var_191_4 = DB("level_enter", arg_191_1, "mission" .. iter_191_0)
		
		if DB("mission_data", var_191_4, "id") then
			var_191_2 = var_191_2 + 1
			
			if ConditionContentsManager:isMissionCleared(var_191_4, {
				inbattle = true,
				enter_id = arg_191_1
			}) then
				var_191_3 = var_191_3 + 1
			end
		end
	end
	
	return var_191_3
end

function Battle.doCamping(arg_192_0, arg_192_1)
	CampingSiteNew:enter(arg_192_1)
end

function Battle.isCampingComplete(arg_193_0)
	local var_193_0 = false
	
	if #arg_193_0.logic:getCampingData() > 0 then
		var_193_0 = true
	end
	
	return var_193_0
end

function Battle.isEnded(arg_194_0)
	if not arg_194_0.logic or not arg_194_0.vars then
		return true
	end
	
	return arg_194_0.logic:isEnded() and (arg_194_0.vars.end_battle or arg_194_0:isMapFinished())
end

function Battle.isMapFinished(arg_195_0)
	return arg_195_0.vars and arg_195_0.vars.map_finished
end

function Battle.changeStageBG(arg_196_0, arg_196_1)
	if not arg_196_0.logic or not arg_196_1 then
		return 
	end
	
	local var_196_0 = arg_196_0.logic.map.enter .. "00"
	local var_196_1 = DB("level_stage_1_info", var_196_0, {
		arg_196_1
	})
	
	if not var_196_1 then
		return 
	end
	
	local var_196_2 = string.split(var_196_1, ",")
	local var_196_3 = var_196_2[3]
	local var_196_4 = var_196_2[4]
	local var_196_5 = var_196_2[1]
	local var_196_6 = var_196_2[2]
	
	if not var_196_6 then
		Log.e("Err: empty map id: ", var_196_0)
		
		return 
	end
	
	UIAction:Add(SEQ(COND_LOOP(DELAY(100), function()
		if not StageStateManager:isRunning() then
			return true
		end
	end), CALL(function()
		TransitionScreen:show({
			on_show_before = function(arg_199_0)
				return EffectManager:Play({
					pivot_z = 99998,
					fn = var_196_5,
					layer = arg_199_0,
					pivot_x = VIEW_WIDTH / 2,
					pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
				}), 250
			end,
			on_hide_before = function(arg_200_0)
				return nil, 0
			end,
			on_show = function()
				local var_201_0 = arg_196_0.logic:getCurrentRoadInfo()
				local var_201_1 = arg_196_0.logic:getSelectMapData() or {}
				
				var_201_1.theme = var_196_6
				
				for iter_201_0, iter_201_1 in pairs(arg_196_0.logic.units) do
					if get_cocos_refid(iter_201_1.model) then
						iter_201_1.model:retain()
						iter_201_1.model:removeFromParent()
					end
				end
				
				local var_201_2 = BattleField:loadRoadTheme(arg_196_0.logic, var_201_0, var_201_1)
				
				if var_201_2 then
					if var_196_3 then
						var_201_1.ambient_color = var_196_3
						
						arg_196_0:changeAmbientColor(var_201_2, var_201_1)
					end
					
					if var_196_4 then
						arg_196_0:changeBGM(var_201_2, var_201_1, var_196_4)
					end
				end
				
				for iter_201_2, iter_201_3 in pairs(arg_196_0.logic.units) do
					if get_cocos_refid(iter_201_3.model) then
						BGI.main.layer:addChild(iter_201_3.model)
					end
				end
			end
		})
	end)), arg_196_0)
	BattleAction:Add(SEQ(DELAY(3000), CALL(function()
		TransitionScreen:hide()
	end)), arg_196_0, "battle.change_map")
end

function Battle.getStoryMovieNameList(arg_203_0)
	if not arg_203_0.logic then
		return 
	end
	
	local var_203_0 = arg_203_0.logic:getStoryIdList()
	local var_203_1 = {}
	
	for iter_203_0, iter_203_1 in pairs(var_203_0) do
		local var_203_2 = BattleStory:isStoryMode() and "level_story" or "level_story_free"
		
		for iter_203_2 = 1, 4 do
			local var_203_3, var_203_4 = DB(var_203_2, iter_203_1, {
				"story_before" .. iter_203_2,
				"story_after" .. iter_203_2
			})
			
			if var_203_3 then
				table.insert(var_203_1, var_203_3)
			end
			
			if var_203_4 then
				table.insert(var_203_1, var_203_4)
			end
		end
	end
	
	local var_203_5 = {}
	
	for iter_203_3, iter_203_4 in pairs(var_203_1) do
		local var_203_6 = DB("story_main_script_1", iter_203_4, "info") or DB("story_sub_script_1", iter_203_4, "info") or DB("story_etc_script_1", iter_203_4, "info")
		
		if not var_203_6 and not PRODUCTION_MODE then
			var_203_6 = DB("story_dev_script_1", iter_203_4, "info")
		end
		
		local var_203_7 = json.decode(var_203_6)
		
		if var_203_7 then
			for iter_203_5, iter_203_6 in pairs(var_203_7) do
				if iter_203_6.movie then
					table.insert(var_203_5, iter_203_6.movie)
				end
			end
		end
	end
	
	return var_203_5
end
