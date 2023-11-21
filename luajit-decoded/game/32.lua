BACK_PLAY_RESTORE_DELAY_TIME = 8
BackPlayBattle = ClassDef()

function BackPlayBattle.constructor(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or {}
	arg_1_0.logic = arg_1_1
	arg_1_0.started = false
	arg_1_0.start_time = arg_1_2.start_time
	arg_1_0.team_idx = arg_1_2.team_idx
	arg_1_0.team_point = arg_1_2.team_point
	arg_1_0.ignore_lack_currency = arg_1_2.ignore_lack_currency
	arg_1_0.init_delay = arg_1_2.init_delay or 0
	arg_1_0.delay_times = {}
	arg_1_0.speed = 0.25
	arg_1_0.cur_pos = arg_1_2.cur_pos or 100
	arg_1_0.road_info = arg_1_0.logic:getCurrentRoadInfo()
	arg_1_0.road_field_info = arg_1_2.road_field_info
	arg_1_0.road_sector_object_list = arg_1_0.logic:getRoadSectorObjectList(arg_1_0.road_info.road_id)
	arg_1_0.current_sector_field_info = arg_1_2.current_sector_field_info
	arg_1_0.start_tick = systick()
	
	if arg_1_2.auto_flags then
		for iter_1_0, iter_1_1 in pairs(arg_1_0.logic.group_teams or {}) do
			for iter_1_2, iter_1_3 in pairs(iter_1_1.units or {}) do
				iter_1_3:setAutoSkillFlag(arg_1_2.auto_flags[iter_1_3:getUID()])
			end
		end
	end
end

function BackPlayBattle.start(arg_2_0)
	arg_2_0.started = true
	
	if table.empty(arg_2_0.road_info) then
		arg_2_0.logic:command({
			cmd = "EnterRoad"
		})
		arg_2_0.logic:procinfos(true, {
			battle_instance = arg_2_0
		})
		ConditionContentsManager:dispatch("battle.party", {
			unique_id = arg_2_0.logic:getBattleUID(),
			entertype = arg_2_0.logic.type,
			friends = arg_2_0.logic.units
		})
	end
end

function BackPlayBattle.command(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "@enter_road" then
		arg_3_0.cur_pos = 100
		arg_3_0.road_info = arg_3_0.logic:getCurrentRoadInfo()
		arg_3_0.road_field_info = BattleField:createRoadFieldInfo(arg_3_0.logic, arg_3_0.road_info)
		arg_3_0.road_sector_object_list = arg_3_0.logic:getRoadSectorObjectList(arg_3_0.road_info.road_id)
	end
end

function BackPlayBattle.restore(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or {}
	
	if arg_4_1.auto_flags then
		for iter_4_0, iter_4_1 in pairs(arg_4_0.logic.group_teams or {}) do
			for iter_4_2, iter_4_3 in pairs(iter_4_1.units or {}) do
				Account:setUnitAutoSkillFlag(iter_4_3:getUID(), arg_4_1.auto_flags[iter_4_3:getUID()])
				iter_4_3:setAutoSkillFlag(arg_4_1.auto_flags[iter_4_3:getUID()])
			end
		end
	end
	
	local var_4_0 = {
		road_field_info = arg_4_0.road_field_info,
		current_sector_field_info = arg_4_0.current_sector_field_info
	}
	
	return arg_4_0.logic, var_4_0
end

function BackPlayBattle.update(arg_5_0, arg_5_1)
	local var_5_0 = systick() % 10000
	local var_5_1 = (arg_5_0.prev_tick or systick()) % 10000
	local var_5_2 = math.clamp(var_5_0 - var_5_1, 0, 100)
	local var_5_3 = DEBUG.APPLY_TIME_SCALE or not ContentDisable:byAlias("battle_speed") or false
	
	arg_5_0.prev_tick = var_5_0
	
	if arg_5_0.init_delay > 0 then
		arg_5_0.init_delay = arg_5_0.init_delay - var_5_2
		
		return 
	end
	
	arg_5_0:decreaseTime(var_5_2 * (var_5_3 and GET_SKILL_TIME_SCALE() or 1))
	
	local var_5_4 = arg_5_0.logic.logger:popAll()
	
	for iter_5_0, iter_5_1 in pairs(var_5_4 or {}) do
		arg_5_0.logic:procInfo(iter_5_1, nil, {
			battle_instance = arg_5_0
		})
		
		local var_5_5 = arg_5_0.logic:getProcInfoDelay(iter_5_1)
		
		if iter_5_1.type and var_5_5 > 0 then
			arg_5_0:increaseTime(iter_5_1.type, var_5_5)
		end
	end
	
	if not arg_5_0:isPlayingBattleAction() then
		if arg_5_0.logic.road_event_run_info.state_name == "running" then
			arg_5_0.logic:processRoadEvent()
		elseif not table.empty(arg_5_0.logic.road_event_run_info.pending_list) then
			arg_5_0.logic:executeRoadEvent()
		else
			local var_5_6 = math.clamp(arg_5_1 or var_5_2, 0, 100)
			
			arg_5_0:updateMoveProcess(var_5_6 * (var_5_3 and GET_MOVE_TIME_SCALE() or 1))
		end
	end
end

function BackPlayBattle.finish(arg_6_0)
	Log.i("전투 종료", arg_6_0.logic:getFinalResult(), (systick() - arg_6_0.start_tick) / 1000)
	
	if arg_6_0.logic:getFinalResult() then
		if arg_6_0.logic:getFinalResult() == "win" then
			Battle:onClear(arg_6_0.logic, arg_6_0:getClearData())
		else
			Battle:onFailed(arg_6_0.logic, nil, nil, arg_6_0:getFailedData())
		end
	end
end

function BackPlayBattle.getClearData(arg_7_0)
	local var_7_0 = {}
	
	var_7_0.is_back_ground = true
	var_7_0.ignore_lack_currency = arg_7_0.ignore_lack_currency
	var_7_0.battle_tick = arg_7_0.logic:getElapsedTick()
	var_7_0.start_time = arg_7_0.start_time
	var_7_0.team_index = arg_7_0.team_idx
	var_7_0.team_point = arg_7_0.team_point
	
	return var_7_0
end

function BackPlayBattle.getFailedData(arg_8_0)
	local var_8_0 = {}
	
	var_8_0.is_back_ground = true
	var_8_0.ignore_lack_currency = arg_8_0.ignore_lack_currency
	var_8_0.battle_tick = arg_8_0.logic:getElapsedTick()
	var_8_0.start_time = arg_8_0.start_time
	
	return var_8_0
end

function BackPlayBattle.updateMoveProcess(arg_9_0, arg_9_1)
	if not arg_9_0.road_field_info then
		return 
	end
	
	local var_9_0 = arg_9_0.logic:getCurrentRoadInfo()
	local var_9_1 = arg_9_0.road_field_info
	local var_9_2 = arg_9_0.prev_pos
	local var_9_3 = arg_9_0.cur_pos
	
	if arg_9_0.current_sector_field_info and var_9_0.road_id ~= arg_9_0.current_sector_field_info.road_id then
		arg_9_0.current_sector_field_info = nil
	end
	
	local function var_9_4(arg_10_0, arg_10_1)
		local var_10_0 = var_9_2 or var_9_3
		local var_10_1 = var_9_3
		
		return var_10_0 <= arg_10_1 and arg_10_0 <= var_10_1
	end
	
	local function var_9_5(arg_11_0)
		if not arg_11_0 then
			return 
		end
		
		if var_9_0.road_id ~= arg_11_0.road_id then
			return 
		end
		
		return arg_11_0.is_single_sector or var_9_4(arg_11_0.bounds_sector_left, arg_11_0.bounds_sector_right)
	end
	
	local function var_9_6(arg_12_0)
		if not arg_12_0 then
			return 
		end
		
		if var_9_0.road_id ~= arg_12_0.road_id then
			return 
		end
		
		return arg_12_0.is_single_sector or var_9_4(arg_12_0.trigger_event_left, arg_12_0.trigger_event_right)
	end
	
	local function var_9_7(arg_13_0)
		if not arg_13_0 then
			return 
		end
		
		if var_9_0.road_id ~= arg_13_0.road_id then
			return 
		end
		
		return arg_13_0.is_single_sector or var_9_4(arg_13_0.pet_recognize_left, arg_13_0.pet_recognize_right)
	end
	
	local function var_9_8()
		if arg_9_0.logic:getCurrentRoadType() == "goblin" then
			arg_9_0.logic:command({
				cmd = "ReturnRoad"
			})
		end
	end
	
	if not var_9_5(arg_9_0.current_sector_field_info) then
		for iter_9_0, iter_9_1 in pairs(arg_9_0.road_sector_object_list) do
			local var_9_9 = arg_9_0.road_field_info.sector_field_info_tbl[iter_9_1]
			
			if not var_9_9.ignore and not var_9_9.closed and var_9_9.position then
				local var_9_10 = false
				
				if var_9_5(var_9_9) then
					arg_9_0.current_sector_field_info = var_9_9
					arg_9_0.current_sector_field_info.excuted_event = false
					
					local var_9_11 = iter_9_1.sector_id
					
					arg_9_0.logic:command({
						cmd = "EnterRoadSector",
						road_sector_id = var_9_11
					})
					
					break
				end
			end
		end
	end
	
	if var_9_6(arg_9_0.current_sector_field_info) and not arg_9_0.current_sector_field_info.excuted_event then
		arg_9_0.current_sector_field_info.excuted_event = true
		
		arg_9_0.logic:command({
			cmd = "ExecuteRoadEvent"
		})
	end
	
	if var_9_7(arg_9_0.current_sector_field_info) and not arg_9_0.current_sector_field_info.pet_recognize then
		arg_9_0.current_sector_field_info.pet_recognize = true
		
		arg_9_0.logic:command({
			cmd = "PetRecognizeRoadEvent"
		})
	end
	
	if var_9_1.moveable_left and var_9_3 < var_9_1.moveable_left then
		var_9_8()
	elseif var_9_1.moveable_right and var_9_3 > var_9_1.moveable_right then
		var_9_8()
	end
	
	arg_9_0.prev_pos = arg_9_0.cur_pos
	arg_9_0.cur_pos = arg_9_0.cur_pos + arg_9_0.speed * arg_9_1
end

function BackPlayBattle.isStarted(arg_15_0)
	return arg_15_0.started
end

function BackPlayBattle.isFinished(arg_16_0)
	return arg_16_0.logic:isEnded() and arg_16_0.logic.logger:isEmpty() and not arg_16_0:isPlayingBattleAction()
end

function BackPlayBattle.isPlayingBattleAction(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.delay_times or {}) do
		if arg_17_0.delay_times[iter_17_0] > 0 then
			return true
		end
	end
	
	return false
end

BACK_PLAY_DEBUG_TIME = nil

function BackPlayBattle.increaseTime(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0.delay_times[arg_18_1] = arg_18_0.delay_times[arg_18_1] or 0
	
	if arg_18_2 > arg_18_0.delay_times[arg_18_1] then
		arg_18_0.delay_times[arg_18_1] = BACK_PLAY_DEBUG_TIME or arg_18_2
	end
end

function BackPlayBattle.decreaseTime(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.delay_times or {}) do
		if arg_19_0.delay_times[iter_19_0] > 0 then
			arg_19_0.delay_times[iter_19_0] = math.max(arg_19_0.delay_times[iter_19_0] - arg_19_1, 0)
		end
	end
end

BackPlayManager = BackPlayManager or {}

function BackPlayManager.init(arg_20_0)
	if arg_20_0.vars then
		return 
	end
	
	arg_20_0.vars = {}
	arg_20_0.vars.battles = {}
	arg_20_0.vars.logs = {}
	arg_20_0.vars.scheduler = Scheduler:add(nil, arg_20_0.update, arg_20_0)
	
	LuaEventDispatcher:removeEventListenerByKey("info_log")
	LuaEventDispatcher:addEventListener("proc.info.log", LISTENER(BackPlayManager.onEvent, arg_20_0), "info_log")
end

function BackPlayManager.clear(arg_21_0)
	if arg_21_0.vars and arg_21_0.vars.scheduler then
		Scheduler:remove(arg_21_0.vars.scheduler)
	end
	
	arg_21_0.vars = nil
	arg_21_0.map_id = nil
	arg_21_0.team_idx = nil
	arg_21_0.logic = nil
	arg_21_0.last_battle = nil
	arg_21_0.check_next_battle = nil
	arg_21_0.isRunning_val = nil
end

function BackPlayManager.isActive(arg_22_0)
	return true
end

function BackPlayManager.isInBackPlayTeam(arg_23_0, arg_23_1)
	if not arg_23_0:isRunning() or not arg_23_1 then
		return 
	end
	
	if arg_23_0.logic:isBurning() then
		for iter_23_0, iter_23_1 in pairs(BURNING_TEAM_IDX) do
			if Account:isInTeam(arg_23_1, iter_23_1) then
				return true
			end
		end
	end
	
	return arg_23_0.logic:getUnit(arg_23_1)
end

function BackPlayManager.isDescent(arg_24_0)
	if not arg_24_0.logic then
		return 
	end
	
	return arg_24_0.logic:isDescent()
end

function BackPlayManager.isBurning(arg_25_0)
	if not arg_25_0.logic then
		return 
	end
	
	return arg_25_0.logic:isBurning()
end

function BackPlayManager.getSubstoryId(arg_26_0)
	if not arg_26_0.logic then
		return 
	end
	
	return arg_26_0.logic:getCurrentSubstoryID()
end

function BackPlayManager.getRunningTeamIdxRaw(arg_27_0)
	return arg_27_0.team_idx
end

function BackPlayManager.getRunningTeamIdx(arg_28_0)
	if not arg_28_0:isRunning() then
		return 
	end
	
	return arg_28_0.team_idx
end

function BackPlayManager.isRunningTeamPet(arg_29_0, arg_29_1)
	if not arg_29_0:isRunning() or not arg_29_1 then
		return 
	end
	
	return arg_29_1 == arg_29_0:getRunningTeamPetUID(1)
end

function BackPlayManager.getRunningTeamPetUID(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:getRunningTeamIdx(arg_30_1)
	
	if not var_30_0 then
		return 
	end
	
	local var_30_1 = Account:getPetInTeam(var_30_0)
	
	if not var_30_1 then
		return 
	end
	
	return var_30_1:getUID()
end

function BackPlayManager.getRunningMapId(arg_31_0)
	if not arg_31_0:isRunning() then
		return 
	end
	
	return arg_31_0.map_id
end

function BackPlayManager.isReceiveResultWait(arg_32_0)
	if arg_32_0.vars then
		return arg_32_0.vars.is_receive_result_wait
	end
end

function BackPlayManager.checkIgnoreCurrency(arg_33_0)
	if arg_33_0.vars and arg_33_0.vars.battles[1] then
		arg_33_0.vars.battles[1].ignore_lack_currency = true
	end
end

function BackPlayManager.setRunning(arg_34_0, arg_34_1)
	BackPlayManager.isRunning_val = arg_34_1
	
	if arg_34_1 then
		UIOption:UpdateScreenOnState(SAVE:getOptionData("option.prevent_off_while_battle", true))
	else
		UIOption:UpdateScreenOnState()
	end
end

function BackPlayManager.isRunning(arg_35_0)
	return BackPlayManager.isRunning_val
end

function BackPlayManager.update(arg_36_0)
	if not arg_36_0:isRunning() then
		return 
	end
	
	if arg_36_0.check_restore_delay and os.time() > arg_36_0.check_restore_delay then
		arg_36_0.check_restore_delay = nil
	end
	
	if arg_36_0.check_next_battle then
		if os.time() > arg_36_0.check_next_battle then
			arg_36_0.check_next_battle = nil
			
			BattleRepeat:req_startBattle(function()
				BattleRepeat:repeat_battle_start(true, {
					back_ground_team_idx = arg_36_0.back_ground_team_idx
				})
			end)
		end
		
		return 
	end
	
	local var_36_0 = {}
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0.vars.battles or {}) do
		if not iter_36_1:isStarted() then
			iter_36_1:start()
		end
		
		iter_36_1:update()
		
		if iter_36_1:isFinished() then
			iter_36_1:finish()
			table.insert(var_36_0, 1, iter_36_0)
		end
	end
	
	for iter_36_2, iter_36_3 in ipairs(var_36_0) do
		arg_36_0.last_battle = arg_36_0.vars.battles[iter_36_3]
		
		table.remove(arg_36_0.vars.battles, iter_36_3)
	end
end

function BackPlayManager.play(arg_38_0, arg_38_1, arg_38_2)
	local function var_38_0(arg_39_0, arg_39_1)
		local var_39_0, var_39_1 = Battle:startSkillWithoutMotion(arg_38_1, arg_39_0, arg_39_1)
		
		if not arg_39_1.tot_hit then
			local var_39_2 = DB("character", arg_39_0:getDisplayCode(), "skin_check") or "hit_count"
			
			if arg_38_1.getTotalHitCount then
				arg_39_1.tot_hit = arg_38_1:getTotalHitCount(arg_39_1.skill_id, var_39_2)
			else
				arg_39_1.tot_hit = DB("action_data_ext", arg_39_1.skill_id, {
					var_39_2
				})
				
				if not arg_39_1.tot_hit then
					arg_39_1.tot_hit = arg_39_1.cur_hit + 1
				end
			end
		end
		
		for iter_39_0 = arg_39_1.cur_hit + 1, arg_39_1.tot_hit do
			arg_38_1:command({
				cmd = "HitEvent",
				unit_uid = arg_39_0:getUID(),
				tot_hit = arg_39_1.tot_hit
			})
		end
		
		return var_39_1 or 0
	end
	
	arg_38_2 = arg_38_2 or {}
	
	if table.count(arg_38_0.vars.battles) > 0 then
		return 
	end
	
	arg_38_0:setRunning(true)
	
	arg_38_0.map_id = arg_38_1.map.enter
	arg_38_0.logic = arg_38_1
	
	if arg_38_2.make_new_team then
		arg_38_0.team = table.shallow_clone(Account:getTeam(arg_38_2.team_idx))
		arg_38_0.team_idx = arg_38_2.team_idx
	end
	
	if arg_38_2.is_first_enter then
		arg_38_0.last_battle = nil
	end
	
	if arg_38_2.from_battle_scene then
		arg_38_0.auto_flags = {}
		
		for iter_38_0, iter_38_1 in pairs(arg_38_0.logic.group_teams or {}) do
			for iter_38_2, iter_38_3 in pairs(iter_38_1.units or {}) do
				arg_38_0.auto_flags[iter_38_3:getUID()] = iter_38_3:getAutoSkillFlag()
			end
		end
		
		local var_38_1 = arg_38_1:getTurnInfoSkillHistory()
		
		for iter_38_4, iter_38_5 in pairs(var_38_1 or {}) do
			local var_38_2 = iter_38_5.attacker
			local var_38_3 = iter_38_5.att_info
			
			if var_38_2 and var_38_3 and (not var_38_3.tot_hit or var_38_3.cur_hit < var_38_3.tot_hit) then
				local var_38_4 = var_38_0(var_38_2, var_38_3)
				
				arg_38_2.init_delay = var_38_4
				
				Log.i("전투 위임 남은 히트 처리", var_38_2:getName(), var_38_3.skill_id, var_38_3.cur_hit, var_38_3.tot_hit, var_38_4)
			end
		end
		
		arg_38_0.check_restore_delay = os.time() + BACK_PLAY_RESTORE_DELAY_TIME
	end
	
	arg_38_2.auto_flags = arg_38_0.auto_flags
	
	if arg_38_2.battle_state == "begin" then
		arg_38_1.is_back_ground = true
		
		table.insert(arg_38_0.vars.battles, BackPlayBattle(arg_38_1, arg_38_2))
		
		if not arg_38_2.from_battle_scene then
			local var_38_5 = ConditionContentsManager:getDungeonMissions()
			
			if var_38_5 then
				var_38_5:startMissions(arg_38_0.map_id, arg_38_0.logic:getCurrentSubstoryID())
			end
		end
	elseif arg_38_2.battle_state == "sended" then
		arg_38_0.last_battle = BackPlayBattle(arg_38_1, arg_38_2)
		arg_38_0.vars.is_receive_result_wait = true
	elseif arg_38_2.battle_state == "finish" then
		arg_38_0:proc_next({
			back_ground_team_idx = arg_38_2.team_idx,
			lose = arg_38_2.lose
		})
	else
		Log.e("invalid backplay battle state")
	end
	
	ConditionContentsManager:cleanUpVltTbl()
end

function BackPlayManager.hasBattle(arg_40_0)
	if not arg_40_0.vars then
		return 
	end
	
	return not table.empty(arg_40_0.vars.battles)
end

function BackPlayManager.getBattles(arg_41_0)
	if not arg_41_0.vars then
		return {}
	end
	
	return arg_41_0.vars.battles or {}
end

function BackPlayManager.canRestore(arg_42_0)
	if not arg_42_0.vars then
		return 
	end
	
	if table.empty(arg_42_0.vars.battles) then
		return 
	end
	
	if arg_42_0.check_restore_delay then
		return 
	end
	
	return arg_42_0.vars.battles[1].init_delay <= 0
end

function BackPlayManager.getLastBattle(arg_43_0)
	return arg_43_0.last_battle
end

function BackPlayManager.hasLastBattle(arg_44_0)
	return arg_44_0.last_battle ~= nil
end

function BackPlayManager.getLastResult(arg_45_0)
	if arg_45_0.last_battle then
		return arg_45_0.last_battle.logic:getFinalResult() or ""
	end
	
	return ""
end

function BackPlayManager.stop(arg_46_0)
	arg_46_0:setRunning(false)
	UIAction:Remove("repeat.delay")
	
	if not table.empty(arg_46_0.vars.battles) then
		table.remove(arg_46_0.vars.battles, 1)
	end
end

function BackPlayManager.updateAccountUI(arg_47_0)
	TopBarNew:updateAccountUI()
	Friend:updateAccountUI()
end

function BackPlayManager.showResultUI(arg_48_0, arg_48_1)
	if not arg_48_0.vars or not arg_48_1 then
		return 
	end
	
	if arg_48_1.lose then
		ClearResult:show(arg_48_1.logic, arg_48_1)
	else
		ClearResult:show(arg_48_1.logic, arg_48_1.result, arg_48_1.account_lv_before, arg_48_1.account_lv_after, arg_48_1.units_exp, arg_48_1.units_favexp, arg_48_1.units_levelup, arg_48_1.fav_levelup, arg_48_1.apper_missions)
	end
end

function BackPlayManager.proc_next(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_2 or {}
	
	arg_49_0.vars.is_receive_result_wait = false
	
	if arg_49_0.last_battle and not arg_49_0.last_battle.last_result then
		arg_49_0.last_battle.last_result = arg_49_1
		arg_49_0.last_battle.last_result.result_values = var_49_0
	end
	
	arg_49_0.back_ground_team_idx = arg_49_1.back_ground_team_idx
	
	local var_49_1, var_49_2 = BattleRepeat:canRepeatPlayContinue({
		no_dialog = true,
		caller = "back_ground_battle_repeat",
		is_back_play = true,
		lose = var_49_0.lose,
		back_ground_disable = arg_49_1.back_ground_disable
	})
	
	if not var_49_1 then
		if var_49_2 and var_49_2 == "buy_req" then
			BattleRepeat:_debugLogErr("Err: 백그라운드 전투 스테미나 재화 구매요청")
		else
			arg_49_0:endRepeatPlay(var_49_2)
			
			if arg_49_1.back_ground_disable then
				balloon_message(T("content_disable"))
			end
		end
		
		return 
	end
	
	arg_49_0:repeat_battle_start()
end

function BackPlayManager.endRepeatPlay(arg_50_0, arg_50_1)
	if arg_50_1 then
		BattleRepeat:_debugLogErr("Err: 백그라운드 반복전투 종료!    사유: " .. arg_50_1)
	else
		BattleRepeat:_debugLogErr("Err: 백그라운드 반복전투 종료!, 상단 에러메세지에 사유가 나와있습니다.")
	end
	
	BattleRepeatPopup:closeItemListPopup()
	BattleRepeat:set_isEndRepeatPlay(true)
	BackPlayManager:setRunning(false)
	BackPlayControlBox:setState("finished")
	BackPlayControlBox:setEndBattleUI(arg_50_1)
end

function BackPlayManager.repeat_battle_start(arg_51_0)
	arg_51_0.check_next_battle = os.time() + 5
end

function BackPlayManager.end_repeatPlay(arg_52_0, arg_52_1)
	BackPlayControlBox:setEndBattleUI(arg_52_1)
end

function BackPlayManager.restore(arg_53_0)
	local var_53_0 = false
	
	BackPlayManager:setRunning(false)
	
	if arg_53_0.team_idx then
		Account:selectTeam(arg_53_0.team_idx)
	end
	
	if not table.empty(arg_53_0.vars.battles) then
		local var_53_1, var_53_2 = arg_53_0.vars.battles[1]:restore({
			auto_flags = arg_53_0.auto_flags
		})
		local var_53_3 = arg_53_0.vars.battles[1].ignore_lack_currency
		
		table.remove(arg_53_0.vars.battles, 1)
		Action:RemoveAll()
		PreLoad:beforeEnterBattle(var_53_1)
		SceneManager:nextScene("battle", {
			restored = true,
			logic = var_53_1,
			restore_info = var_53_2,
			ignore_lack_currency = var_53_3
		})
		SceneManager:reserveResetSceneFlow()
	elseif arg_53_0.last_battle then
		local var_53_4, var_53_5 = arg_53_0.last_battle:restore({
			auto_flags = arg_53_0.auto_flags
		})
		
		Action:RemoveAll()
		PreLoad:beforeEnterBattle(var_53_4)
		SceneManager:nextScene("battle", {
			restored = true,
			logic = var_53_4,
			restore_info = var_53_5,
			restore_last_result = arg_53_0.last_battle.last_result
		})
		SceneManager:reserveResetSceneFlow()
		
		arg_53_0.last_battle = nil
		var_53_0 = true
	end
	
	return var_53_0
end

function BackPlayManager.summary(arg_54_0)
end

function BackPlayManager.isRestoreDelayTime(arg_55_0)
	return arg_55_0.check_restore_delay
end

function BackPlayManager.getCurrentTeam(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	return arg_56_0.team
end

function BackPlayManager.getCurrentRoadType(arg_57_0)
	if not table.empty(arg_57_0.vars.battles) then
		return arg_57_0.vars.battles[1].logic:getCurrentRoadType()
	end
end

function BackPlayManager.checkBackGroundPlayableMap(arg_58_0, arg_58_1)
	if not arg_58_1 or arg_58_0:isRunning() then
		return false
	end
	
	return BackPlayUtil:checkPlayableMap(arg_58_1)
end

function BackPlayManager.forceStopPlay(arg_59_0, arg_59_1, arg_59_2)
	if not BackPlayManager:isRunning() then
		return 
	end
	
	BackPlayControlBox:endBattle()
	BackPlayManager:endRepeatPlay(arg_59_1)
	
	if arg_59_2 then
		BackPlayControlBox:close()
	else
		BackPlayControlBox:setForceEndPlay()
	end
end

function BackPlayManager.onEvent(arg_60_0, arg_60_1, arg_60_2)
	if PRODUCTION_MODE or PLATFORM ~= "win32" then
		return 
	end
	
	arg_60_0.vars.logs[arg_60_1] = arg_60_0.vars.logs[arg_60_1] or {}
	arg_60_2.tick = systick()
	
	if arg_60_1 == "battle.real" then
		table.insert(arg_60_0.vars.logs[arg_60_1], arg_60_2)
	elseif arg_60_1 == "battle.replay" then
		table.insert(arg_60_0.vars.logs[arg_60_1], arg_60_2)
		Log.i("battle.replay", arg_60_2.type, (arg_60_2.tick - arg_60_0.vars.logs[arg_60_1][1].tick) / 1000, arg_60_2.skill_id, arg_60_2.is_coop, arg_60_2.is_hidden, arg_60_2.is_counter, arg_60_2.X1, arg_60_2.X2)
	end
end

function BackPlayManager.calc(arg_61_0, arg_61_1)
	local var_61_0 = BattleLogic:makeLogic(arg_61_1.map, arg_61_1.team_data, arg_61_1.init_data)
	
	arg_61_0:play(var_61_0, {
		team_point = 0,
		battle_state = "begin",
		start_time = os.time()
	})
end

function back_calc()
	BackPlayManager:clear()
	BackPlayManager:init()
	BackPlayManager:calc(Battle.logic)
end

BackPlayUtil = BackPlayUtil or {}

function BackPlayUtil.getPlayableTypeList(arg_63_0)
	return {
		"hunt",
		"genie",
		"adventure",
		"substory"
	}
end

function BackPlayUtil.isPlayableContentSwitch(arg_64_0, arg_64_1)
	if ContentDisable:byAlias("battle_background") then
		return false
	end
	
	local var_64_0 = arg_64_0:getContentTypeAndEnterType(arg_64_1)
	
	if (var_64_0 == "adventure" or var_64_0 == "substory") and ContentDisable:byAlias("background_adventure") then
		return false
	end
	
	return true
end

function BackPlayUtil.checkPlayableMap(arg_65_0, arg_65_1)
	if not arg_65_0:isPlayableContentSwitch(arg_65_1) then
		return false, "content_disable"
	end
	
	local var_65_0 = arg_65_0:getContentTypeAndEnterType(arg_65_1)
	
	if not var_65_0 then
		return false
	end
	
	if table.isInclude(arg_65_0:getPlayableTypeList(), var_65_0) then
		return true
	end
	
	return false, "invaild_type"
end

function BackPlayUtil.getContentTypeAndEnterType(arg_66_0, arg_66_1)
	local var_66_0, var_66_1, var_66_2 = DB("level_enter", arg_66_1, {
		"id",
		"type",
		"contents_type"
	})
	
	if not var_66_0 then
		return nil
	end
	
	if var_66_1 == "hunt" or var_66_1 == "genie" then
		return var_66_1
	elseif var_66_2 == "adventure" or var_66_2 == "substory" then
		return var_66_2
	end
end

function BackPlayUtil.checkAdventureInBackPlay(arg_67_0)
	if not BackPlayManager:isRunning() then
		return true
	end
	
	local var_67_0 = BackPlayManager:getRunningMapId()
	
	if not var_67_0 then
		return true
	end
	
	if arg_67_0:getContentTypeAndEnterType(var_67_0) == "adventure" then
		return false, "msg_bgbattle_sametypebattle_error"
	end
	
	return true
end

function BackPlayUtil.checkSubstoryInBackPlay(arg_68_0)
	if not BackPlayManager:isRunning() then
		return true
	end
	
	local var_68_0 = BackPlayManager:getRunningMapId()
	
	if not var_68_0 then
		return true
	end
	
	if arg_68_0:getContentTypeAndEnterType(var_68_0) == "substory" then
		return false, "msg_bgbattle_sametypebattle_error"
	end
	
	return true
end

function BackPlayUtil.checkEnterableMapOnBackPlaying(arg_69_0, arg_69_1)
	if not arg_69_1 then
		return false
	end
	
	if not BackPlayManager:isRunning() then
		return true
	end
	
	local var_69_0 = arg_69_0:getContentTypeAndEnterType(arg_69_1)
	local var_69_1 = BackPlayManager:getRunningMapId()
	local var_69_2 = arg_69_0:getContentTypeAndEnterType(var_69_1)
	
	if var_69_1 == arg_69_1 then
		return false
	end
	
	if var_69_0 == var_69_2 then
		return false, "msg_bgbattle_sametypebattle_error"
	end
	
	return true
end

function BackPlayUtil.checkEnterCrehuntLobbyOnBackPlaying(arg_70_0)
	if not BackPlayManager:isRunning() then
		return true
	end
	
	local var_70_0 = BackPlayManager:getRunningMapId()
	
	if not var_70_0 then
		return true
	end
	
	if DB("level_enter", var_70_0, "contents_type") == "crehunt" then
		return false, "msg_bgbattle_crevicehunt_error"
	end
	
	return true
end
