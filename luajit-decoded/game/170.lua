BattleLogicClient = BattleLogicClient or {}

copy_functions(BattleLogic, BattleLogicClient)

function BattleLogicClient.onStartSkill(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_0:getUnit(arg_1_1)
	
	if not var_1_0 then
		Log.e("INVALID UNIT", arg_1_1)
		
		return 
	end
	
	local var_1_1 = {
		type = "skill",
		attacker = arg_1_1,
		target = arg_1_3,
		is_soul = arg_1_5,
		code = var_1_0.db.code,
		skill_idx = arg_1_4,
		skill_id = arg_1_2
	}
	
	arg_1_0.service:query("command", var_1_1, nil, {
		retry = 3
	})
end

function BattleLogicClient.isAIPlayer(arg_2_0, arg_2_1)
	return arg_2_1:getProvoker()
end

function BattleLogicClient.onSummonSkill(arg_3_0)
end

function BattleLogicClient.onSwapTagSupporter(arg_4_0)
end

function BattleLogicClient.stopBattleFSM(arg_5_0)
	print("Depends on server")
end

BattleLogicServer = BattleLogicServer or {}

copy_functions(BattleLogic, BattleLogicServer)

function BattleLogicServer.isEnableRtaPenalty(arg_6_0)
	if arg_6_0.service then
		return arg_6_0.service:isEnableRtaPenalty()
	end
	
	return true
end

function BattleLogicServer.isAIPlayer(arg_7_0, arg_7_1)
	return arg_7_1:getProvoker()
end

function BattleLogicServer.procinfos(arg_8_0)
	while arg_8_0:getFinalResult() == nil do
		arg_8_0:procState()
		
		local var_8_0 = arg_8_0.logger:popAll()
		
		if table.empty(var_8_0) then
			break
		end
		
		for iter_8_0, iter_8_1 in pairs(var_8_0) do
			arg_8_0:procInfo(iter_8_1)
		end
	end
	
	arg_8_0:execute()
end

function BattleLogicServer.sortUnitStates(arg_9_0, arg_9_1)
	arg_9_0.unit_states_counter = arg_9_0.unit_states_counter or {}
	
	local var_9_0 = false
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.allocated_unit_tbl or {}) do
		if (not arg_9_0.unit_states_counter[iter_9_0] or arg_9_0.unit_states_counter[iter_9_0] ~= (iter_9_1.states.counter or 0)) and not iter_9_1:isEmptyHP() and not iter_9_1:isDead() then
			arg_9_0.unit_states_counter[iter_9_0] = iter_9_1.states.counter or 0
			
			for iter_9_2, iter_9_3 in pairs(iter_9_1.states.List or {}) do
				iter_9_3.net_idx = nil
			end
			
			iter_9_1.states:sort()
			
			var_9_0 = true
			
			for iter_9_4, iter_9_5 in pairs(iter_9_1.states.List or {}) do
				iter_9_5.net_idx = iter_9_4
			end
		end
	end
	
	if var_9_0 then
		arg_9_0:onInfos({
			type = "sort_order"
		})
	end
end

function BattleLogicServer.procInfo(arg_10_0, arg_10_1, arg_10_2)
	local var_10_1
	
	if arg_10_1.type == "@skill_start" then
		local var_10_0 = arg_10_1.unit:getSkinCheck() or "hit_count"
		
		var_10_1 = arg_10_0:getTotalHitCount(arg_10_1.att_info.skill_id, var_10_0)
		
		for iter_10_0 = 1, var_10_1 do
			arg_10_0:command({
				cmd = "HitEvent",
				unit_uid = arg_10_1.unit.inst.uid,
				tot_hit = var_10_1
			})
		end
	end
end

function BattleLogicServer.getTotalHitCount(arg_11_0, arg_11_1, arg_11_2)
	if not CACHE_HIT_COUNT_DB[arg_11_1] then
		local var_11_0 = arena_get_global_variable(arg_11_1)
		
		CACHE_HIT_COUNT_DB[arg_11_1] = json.decode(var_11_0)
	end
	
	print("hit count", arg_11_1, arg_11_2, CACHE_HIT_COUNT_DB[arg_11_1][arg_11_2])
	
	if not CACHE_HIT_COUNT_DB[arg_11_1][arg_11_2] or CACHE_HIT_COUNT_DB[arg_11_1][arg_11_2] < 1 then
		return 1
	else
		return CACHE_HIT_COUNT_DB[arg_11_1][arg_11_2]
	end
end

function BattleLogicServer.getFinishedBattleResult(arg_12_0)
	local var_12_0 = table.icount(arg_12_0.enemies)
	
	if arg_12_0.enemy_hidden then
		var_12_0 = var_12_0 + 1
	end
	
	local var_12_1 = countDead(arg_12_0.friends) == table.icount(arg_12_0.friends)
	local var_12_2 = countDead(arg_12_0.enemies) == var_12_0
	
	if var_12_1 and var_12_2 then
		local var_12_3 = arg_12_0:getTurnOwner()
		
		if var_12_3 then
			if var_12_3.inst.ally == FRIEND then
				return "win"
			else
				return "lose"
			end
		else
			return "lose"
		end
	elseif var_12_2 then
		return "win"
	elseif var_12_1 then
		return "lose"
	end
end

BattleLogicAIAgent = BattleLogicAIAgent or {}

copy_functions(BattleLogicServer, BattleLogicAIAgent)

function BattleLogicAIAgent.procinfos(arg_13_0)
	while arg_13_0:getFinalResult() == nil do
		arg_13_0:procState()
		
		local var_13_0 = arg_13_0.logger:popAll()
		
		if table.empty(var_13_0) then
			break
		end
		
		for iter_13_0, iter_13_1 in pairs(var_13_0) do
			arg_13_0:procInfo(iter_13_1)
		end
	end
	
	arg_13_0:execute()
end

function BattleLogicAIAgent.addSkillHistory(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_1 and arg_14_2 then
		arg_14_0.battle_info.skill_history[arg_14_1] = arg_14_0.battle_info.skill_history[arg_14_1] or {}
		arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2] = arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2] or {}
		arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].count = arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].count or 0
		arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].max_damage = arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].max_damage or 0
		arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].tot_damage = arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].tot_damage or 0
		arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].count = arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].count + 1
		
		if arg_14_3 > arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].max_damage then
			arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].max_damage = arg_14_3
		end
		
		arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].tot_damage = arg_14_0.battle_info.skill_history[arg_14_1][arg_14_2].tot_damage + arg_14_3
	end
end

BattleLogicSync = BattleLogicSync or {}

copy_functions(BattleLogic, BattleLogicSync)

function BattleLogicSync.procinfos(arg_15_0)
	while arg_15_0:getFinalResult() == nil do
		arg_15_0:procState()
		
		local var_15_0 = arg_15_0.logger:popAll()
		
		if table.empty(var_15_0) then
			break
		end
		
		for iter_15_0, iter_15_1 in pairs(var_15_0) do
			arg_15_0:procInfo(iter_15_1)
		end
	end
end

function BattleLogicSync.procInfo(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_1.type == "@enter_road" then
	elseif arg_16_1.type == "@encounter_enemy" then
	elseif arg_16_1.type == "@ready_attack" then
		arg_16_0:procReady()
	elseif arg_16_1.type == "@end_turn" then
	elseif arg_16_1.type == "@skill_start" then
		local var_16_0 = arg_16_1.unit:getSkinCheck() or "hit_count"
		local var_16_1 = arg_16_0:getTotalHitCount(arg_16_1.att_info.skill_id, var_16_0)
		
		for iter_16_0 = 1, var_16_1 do
			arg_16_0:command({
				cmd = "HitEvent",
				unit_uid = arg_16_1.unit.inst.uid,
				tot_hit = var_16_1
			})
		end
	elseif arg_16_1.type == "set_ignore_hit_action" then
		(arg_16_1.target or arg_16_0:getUnit(arg_16_1.target_uid)):setIgnoreHitAction(arg_16_1.flag)
	elseif arg_16_1.type == "@end_road_event" then
		local var_16_2 = arg_16_0:getRoadEventObject(arg_16_1.road_event_id) or {}
		local var_16_3 = arg_16_0:getFinalResult() == "lose"
		
		if not arg_16_2 and not var_16_3 and var_16_2.is_last and arg_16_0:getCurrentRoadType() == "chaos" then
			arg_16_0:command({
				cmd = "ReturnRoad"
			})
		end
	elseif arg_16_1.type == "@end_battle" then
	end
	
	arg_16_0:procConditions(arg_16_1, arg_16_2, arg_16_3)
end

function BattleLogicSync.doAutoSkill(arg_17_0)
end

function BattleLogicSync.procReady(arg_18_0)
end

function BattleLogicSync.procConditions(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
end

function BattleLogicSync.addReplayData(arg_20_0, arg_20_1, arg_20_2)
end

BattleLogicVerify = BattleLogicVerify or {}

copy_functions(BattleLogicServer, BattleLogicVerify)

local function var_0_0(arg_21_0, arg_21_1)
	if type(arg_21_0) ~= type(arg_21_1) then
		return false, "difference type"
	end
	
	if type(arg_21_0) == "table" then
		for iter_21_0, iter_21_1 in pairs(arg_21_0) do
			if not var_0_0(iter_21_1, arg_21_1[iter_21_0]) then
				return false, "difference base client"
			end
		end
		
		for iter_21_2, iter_21_3 in pairs(arg_21_1) do
			if not var_0_0(iter_21_3, arg_21_0[iter_21_2]) then
				return false, "difference base server"
			end
		end
		
		return true
	else
		return arg_21_0 == arg_21_1
	end
end

function BattleLogicVerify.isAIPlayer(arg_22_0, arg_22_1)
	if arg_22_1:getProvoker() then
		return true
	end
	
	if arg_22_0:isDualControl() then
		return false
	end
	
	return arg_22_1.inst.ally == ENEMY
end

function BattleLogicVerify.verify(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_1 then
		return false, "no record data"
	end
	
	if not arg_23_2 then
		return false, "no verify info"
	end
	
	local var_23_0 = table.count(arg_23_1)
	local var_23_1 = 0
	
	for iter_23_0 = 1, var_23_0 do
		if arg_23_1[iter_23_0] and arg_23_1[iter_23_0][1] and arg_23_1[iter_23_0][1].cmd == "StartSkill" then
			var_23_1 = var_23_1 + 1
		end
	end
	
	Log.e("record count", var_23_0)
	Log.e("over turn", arg_23_2.over_turn)
	Log.e("limit turn", arg_23_2.limit_turn)
	
	if var_23_1 > arg_23_2.over_turn then
		Log.i("verify check success2")
		
		return true, "verify success(overturn)"
	end
	
	for iter_23_1 = var_23_0, 1, -1 do
		if arg_23_1[iter_23_1] and arg_23_1[iter_23_1][1] and arg_23_1[iter_23_1][1].cmd == "StartSkill" then
			arg_23_1[iter_23_1][1].last_skill = true
			
			break
		end
	end
	
	local var_23_2 = os.clock()
	
	for iter_23_2, iter_23_3 in pairs(arg_23_1) do
		local var_23_3 = iter_23_3[1].attacker_uid and arg_23_0:getUnit(iter_23_3[1].attacker_uid).inst.code
		local var_23_4 = iter_23_3[1].skill_id
		
		Log.e("CMD", iter_23_3[1].cmd, var_23_3, var_23_4, string.format("(%d,%d),(%d,%d)", arg_23_0.random.X1, arg_23_0.random.X2, iter_23_3[2] or -1, iter_23_3[3] or -1))
		
		local var_23_5 = arg_23_0.random.X1
		local var_23_6 = arg_23_0.random.X2
		local var_23_7 = arg_23_0:getVerifyInfo()
		
		arg_23_0:command(iter_23_3[1], false)
		
		if iter_23_3[1].cmd == "ExecuteRoadEvent" then
			arg_23_0:command({
				cmd = "PetRecognizeRoadEvent"
			}, false)
		end
		
		arg_23_0:procinfos()
		
		local var_23_8 = {
			result = arg_23_0:getFinalResult(),
			proc_turn = iter_23_2,
			total_turn = var_23_0,
			error_info = arg_23_0.error_info
		}
		
		if arg_23_2.check_seed and iter_23_3[2] and iter_23_3[3] then
			var_23_8.verify_seed_x1 = var_23_5
			var_23_8.verify_seed_x2 = var_23_6
			var_23_8.record_seed_x1 = iter_23_3[2]
			var_23_8.record_seed_x2 = iter_23_3[3]
		end
		
		if arg_23_2.check_info and iter_23_3[4] then
			var_23_8.verify_detail = var_23_7
			var_23_8.record_detail = iter_23_3[4]
		end
		
		if arg_23_0.error_info then
			return false, "verify_logic_fail", var_23_8
		elseif arg_23_2.check_seed and (not iter_23_3[2] or not iter_23_3[3]) then
			return false, "verify_seed_check_fail1", var_23_8
		elseif arg_23_2.check_seed and iter_23_3[2] and iter_23_3[3] and (not var_0_0(var_23_5, iter_23_3[2]) or not var_0_0(var_23_6, iter_23_3[3])) then
			return false, "verify_seed_check_fail2", var_23_8
		elseif arg_23_2.check_info and iter_23_3[4] and not var_0_0(var_23_7, iter_23_3[4]) then
			return false, "verify_info_check_fail", var_23_8
		elseif iter_23_3[1].cmd == "StartSkill" and not iter_23_3[1].last_skill and arg_23_0:getFinalResult() then
			return false, "verify_turn_check_fail1", var_23_8
		elseif iter_23_3[1].cmd == "StartSkill" and iter_23_3[1].last_skill and not arg_23_0:getFinalResult() then
			return false, "verify_turn_check_fail2", var_23_8
		end
		
		if arg_23_2.limit_turn and iter_23_2 >= arg_23_2.limit_turn then
			print(string.format("elapsed time: %.2f\n", os.clock() - var_23_2))
			
			return true, "verify success(limitturn)"
		end
	end
	
	if not arg_23_0:getFinalResult() then
		return false, "verify turn check fail3", verify_result_info
	else
		Log.i("verify check success")
		
		return true, "verify success(complete)"
	end
end

function BattleLogicVerify.verifyTurn(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_1 then
		return false, "no record data"
	end
	
	for iter_24_0, iter_24_1 in pairs(arg_24_1) do
		local var_24_0 = iter_24_1[1].attacker_uid and arg_24_0:getUnit(iter_24_1[1].attacker_uid).inst.code
		local var_24_1 = iter_24_1[1].skill_id
		
		Log.e("BEFORE CMD", iter_24_1[1].cmd, var_24_0, var_24_1, string.format("(%d,%d),(%d,%d)", arg_24_0.random.X1, arg_24_0.random.X2, iter_24_1[2], iter_24_1[3]))
		
		local var_24_2 = arg_24_0.random.X1
		local var_24_3 = arg_24_0.random.X2
		local var_24_4 = arg_24_0:getVerifyInfo()
		
		arg_24_0:command(iter_24_1[1], false)
		
		if iter_24_1[1].cmd == "ExecuteRoadEvent" then
			arg_24_0:command({
				cmd = "PetRecognizeRoadEvent"
			}, false)
		end
		
		arg_24_0:procinfos()
		
		if arg_24_0.owner then
		end
		
		local var_24_5 = {
			result = arg_24_0:getFinalResult(),
			proc_turn = iter_24_0,
			error_info = arg_24_0.error_info
		}
		
		if arg_24_2.check_seed and iter_24_1[2] and iter_24_1[3] then
			var_24_5.verify_seed_x1 = var_24_2
			var_24_5.verify_seed_x2 = var_24_3
			var_24_5.record_seed_x1 = iter_24_1[2]
			var_24_5.record_seed_x2 = iter_24_1[3]
		end
		
		if arg_24_2.check_info and iter_24_1[4] then
			var_24_5.verify_detail = var_24_4
			var_24_5.record_detail = iter_24_1[4]
		end
		
		if arg_24_0.error_info then
			return false, "verify logic fail", var_24_5
		elseif arg_24_2.check_seed and (not iter_24_1[2] or not iter_24_1[3]) then
			return false, "verify seed check fail1", var_24_5
		elseif arg_24_2.check_seed and iter_24_1[2] and iter_24_1[3] and (not var_0_0(var_24_2, iter_24_1[2]) or not var_0_0(var_24_3, iter_24_1[3])) then
			return false, "verify seed check fail2", var_24_5
		elseif arg_24_2.check_info and iter_24_1[4] and not var_0_0(var_24_4, iter_24_1[4]) then
			return false, "verify info check fail", var_24_5
		end
	end
	
	return true
end

function BattleLogicVerify.procInfo(arg_25_0, arg_25_1, arg_25_2)
	local var_25_1
	
	if arg_25_1.type == "@skill_start" then
		local var_25_0 = arg_25_1.unit:getSkinCheck() or "hit_count"
		
		var_25_1 = arg_25_0:getTotalHitCount(arg_25_1.att_info.skill_id, var_25_0)
		
		if arg_25_0.init_data.use_one_hit then
			Log.e("use one hit")
			
			var_25_1 = 1
		end
		
		for iter_25_0 = 1, var_25_1 do
			arg_25_0:command({
				cmd = "HitEvent",
				unit_uid = arg_25_1.unit.inst.uid,
				tot_hit = var_25_1
			})
		end
	end
end

function BattleLogicVerify.execute(arg_26_0)
end

function BattleLogicVerify.getTotalHitCount(arg_27_0, arg_27_1, arg_27_2)
	if PLATFORM == "win32" then
		if not CACHE_HIT_COUNT_DB[arg_27_1] then
			make_action_data_ext({
				skill_id = arg_27_1,
				callback = function(arg_28_0, arg_28_1)
					CACHE_HIT_COUNT_DB[arg_28_0] = arg_28_1
				end
			})
		end
		
		print("local hit count", arg_27_1, arg_27_2, CACHE_HIT_COUNT_DB[arg_27_1][arg_27_2])
		
		return CACHE_HIT_COUNT_DB[arg_27_1][arg_27_2]
	else
		local var_27_0 = DB("action_data_ext", arg_27_1, {
			arg_27_2
		})
		
		print("db hit count", arg_27_1, arg_27_2, var_27_0)
		
		if var_27_0 == nil or var_27_0 == 0 then
			error_report(string.format("no_hit_count : %s", arg_27_1))
		end
		
		return var_27_0
	end
end

function BattleLogicVerify.doAutoSkill(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0:getTurnOwner()
	
	if var_29_0 == nil then
		return false
	end
	
	if arg_29_0:isEnded() then
		return false, var_29_0
	end
	
	local var_29_1, var_29_2, var_29_3, var_29_4 = arg_29_0:AI_SelectSkillIdxAndTarget(arg_29_0.random:clone(), var_29_0)
	local var_29_5 = arg_29_0:doStartSkill(var_29_0, var_29_2, var_29_4)
	
	if table.empty(var_29_5) then
		arg_29_0:procBattleEvent("pending_end")
		
		return false, var_29_0, var_29_2
	end
	
	arg_29_0:procBattleEvent("attack")
	arg_29_0:procinfos()
	
	return true, var_29_0, var_29_2
end

function BattleLogicVerify.addReplayData(arg_30_0, arg_30_1, arg_30_2)
end

function BattleLogicVerify.makeVerifyBattleInfo(arg_31_0)
	local var_31_0 = {}
	
	for iter_31_0, iter_31_1 in pairs(arg_31_0.friends or {}) do
		local var_31_1 = "f" .. tostring(iter_31_0)
		local var_31_2 = tostring(iter_31_1.inst.code) or ""
		local var_31_3 = iter_31_1:getArtifact() and iter_31_1:getArtifact().code or ""
		
		var_31_0[var_31_1] = "[" .. var_31_2 .. "]" .. "[" .. var_31_3 .. "]"
	end
	
	return var_31_0
end

function verify_map_save()
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "battle" then
		Log.e("!!!!!!!! 실제 원하는 전투 입장 직후 사용해주세요 !!!!!!!!")
		
		return 
	end
	
	Log.e("SAVE BATTLE DATA", Battle.logic.map.enter)
	
	local var_32_0 = {
		init_data = table.shallow_clone(Battle.logic.init_data),
		team_data = Battle.logic.team_data,
		map_data = Battle.logic.map
	}
	local var_32_1 = "logic_data_" .. tostring(Battle.logic.map.enter)
	local var_32_2 = json.encode(var_32_0)
	
	io.writefile(getenv("app.data_path") .. "/" .. var_32_1, var_32_2)
	Log.i("save local replay success", var_32_1)
end

function verify_data_generate(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local function var_33_0(arg_34_0)
		local function var_34_0(arg_35_0, arg_35_1, arg_35_2)
			local var_35_0 = 1
			local var_35_1 = {}
			
			while var_35_0 <= arg_35_1 do
				local var_35_2 = {}
				
				for iter_35_0 = 0, arg_35_2 - 1 do
					if arg_35_1 >= var_35_0 + iter_35_0 then
						table.insert(var_35_2, arg_35_0[var_35_0 + iter_35_0])
					end
				end
				
				if #var_35_2 == arg_35_2 then
					table.insert(var_35_1, var_35_2)
					
					var_35_0 = var_35_0 + arg_35_2
				else
					break
				end
			end
			
			return var_35_1
		end
		
		local var_34_1 = {}
		local var_34_2 = table.clone(Account:getUnits())
		local var_34_3 = {}
		
		table.shuffle(var_34_2)
		
		for iter_34_0, iter_34_1 in pairs(var_34_2) do
			if iter_34_1:getLv() > 30 and not var_34_3[iter_34_1.inst.code] then
				table.insert(var_34_1, iter_34_1.inst.code)
				
				var_34_3[iter_34_1.inst.code] = true
			end
		end
		
		local var_34_4 = 4
		local var_34_5 = var_34_0(var_34_1, #var_34_1, var_34_4)
		
		if arg_34_0 and arg_34_0 < #var_34_5 then
			for iter_34_2 = #var_34_5, arg_34_0 + 1, -1 do
				table.remove(var_34_5, iter_34_2)
			end
		end
		
		return var_34_5
	end
	
	local function var_33_1(arg_36_0, arg_36_1)
		local var_36_0 = table.clone(arg_36_0.init_data)
		local var_36_1 = table.clone(arg_36_0.team_data)
		local var_36_2 = table.clone(arg_36_0.map_data)
		
		for iter_36_0 = 1, 4 do
			var_36_1.units[iter_36_0].unit.code = arg_36_1[iter_36_0]
		end
		
		local var_36_3 = BattleLogic:makeLogic(var_36_2, var_36_1, var_36_0)
		
		function var_36_3.getProcInfoDelay(arg_37_0)
			return -1
		end
		
		local var_36_4 = {}
		local var_36_5 = BackPlayBattle(var_36_3, var_36_4)
		
		var_36_5:start()
		
		local var_36_6 = false
		
		for iter_36_1 = 1, 999999 do
			var_36_5:update(10)
			
			if var_36_5.logic:isEnded() then
				var_36_6 = true
				
				break
			end
		end
		
		if not var_36_6 then
			return false, "verify loop error"
		end
		
		local var_36_7 = table.clone(var_36_5.logic.battle_info.replay_data)
		local var_36_8 = var_36_5.logic:verifyAll({
			use_one_hit = arg_33_2
		})
		
		return var_36_8.success, var_36_8.reason, var_36_8.info, var_36_7
	end
	
	local var_33_2 = arg_33_0 or "hunw001"
	local var_33_3 = "logic_data_" .. var_33_2
	
	Log.e("LOAD BATTLE DATA", var_33_2)
	
	local var_33_4 = getenv("app.data_path") .. "/" .. var_33_3
	local var_33_5 = io.open(var_33_4, "rb")
	local var_33_6
	
	if var_33_5 then
		local var_33_7 = var_33_5:read("*a")
		
		var_33_6 = json.decode(var_33_7)
		
		if not var_33_6 then
			return false, "file decode fail"
		end
	else
		return false, "cannot open file"
	end
	
	local var_33_8 = var_33_0(arg_33_1 or 1)
	local var_33_9 = 0
	local var_33_10 = {}
	local var_33_11 = {}
	
	for iter_33_0, iter_33_1 in pairs(var_33_8) do
		local var_33_12, var_33_13, var_33_14, var_33_15 = var_33_1(var_33_6, iter_33_1)
		
		table.insert(var_33_11, {
			init_data = table.clone(var_33_6.init_data),
			team_data = table.clone(var_33_6.team_data),
			map_data = table.clone(var_33_6.map_data),
			command_data = table.clone(var_33_15),
			unit_combination = iter_33_1
		})
		
		if not var_33_12 then
			var_33_9 = var_33_9 + 1
			
			table.insert(var_33_10, {
				idx = iter_33_0,
				reason = var_33_13,
				unit_combination = iter_33_1
			})
		end
	end
	
	Log.e("map verify fail info", table.print(var_33_10))
	Log.e("map verify summarize", string.format("success : %3d fail : %3d total : %3d", arg_33_1 - var_33_9, var_33_9, arg_33_1))
	
	if arg_33_3 and not table.empty(var_33_11) then
		local var_33_16 = "/verify_battle_data.dat"
		local var_33_17 = json.encode(var_33_11)
		
		Log.e("SAVE VERIFY FILE DATA", string.format("%s", var_33_16))
		io.writefile(getenv("app.data_path") .. var_33_16, var_33_17)
	end
	
	return true, var_33_11, var_33_10
end

function verify_data_proc(arg_38_0, arg_38_1)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	Log.e("load fail battle begin")
	
	arg_38_0 = arg_38_0 or 1
	
	local var_38_0 = "/verify_battle_data.dat"
	local var_38_1 = getenv("app.data_path") .. var_38_0
	local var_38_2 = io.open(var_38_1, "rb")
	
	if var_38_2 then
		local var_38_3 = var_38_2:read("*a")
		local var_38_4 = json.decode(var_38_3)
		
		Log.e("load fail battle data count", table.count(var_38_4 or {}))
		
		if var_38_4 then
			local var_38_5 = var_38_4[arg_38_0]
			
			if var_38_5 then
				local var_38_6 = var_38_5.init_data
				local var_38_7 = var_38_5.team_data
				local var_38_8 = var_38_5.map_data
				local var_38_9 = var_38_5.command_data
				local var_38_10 = var_38_5.unit_combination
				
				for iter_38_0 = 1, 4 do
					Log.e("data unit", var_38_10[iter_38_0])
					
					var_38_7.units[iter_38_0].unit.code = var_38_10[iter_38_0]
				end
				
				BattleLogic:makeLogic(var_38_8, var_38_7, var_38_6):verifyAll({
					command_data = var_38_9,
					use_one_hit = arg_38_1
				})
			else
				Log.e("invalid battle data")
			end
		else
			Log.e("load battle data fail")
		end
	end
end

function verify_data_to_server(arg_39_0, arg_39_1)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local var_39_0 = {
		init = function(arg_40_0, arg_40_1)
			arg_40_0.current = 0
			arg_40_0.total = arg_40_1
		end,
		next = function(arg_41_0)
			if arg_41_0.current < arg_41_0.total then
				local var_41_0 = false
				local var_41_1 = false
				local var_41_2, var_41_3 = verify_data_generate(arg_39_0, 1, var_41_1, var_41_0)
				local var_41_4 = var_41_3[1]
				local var_41_5 = table.clone(var_41_4.init_data)
				local var_41_6 = table.clone(var_41_4.team_data)
				local var_41_7 = table.clone(var_41_4.map_data)
				local var_41_8 = table.clone(var_41_4.command_data)
				local var_41_9 = var_41_4.unit_combination
				
				Log.e("proc battle info", arg_41_0.current, arg_41_0.total)
				
				for iter_41_0 = 1, 4 do
					Log.e("unit code", var_41_9[iter_41_0])
					
					var_41_6.units[iter_41_0].unit.code = var_41_9[iter_41_0]
				end
				
				local var_41_10 = {
					limit_turn = 9999,
					check_seed = true,
					over_turn = 9999,
					check_info = false
				}
				local var_41_11 = {
					init_data = var_41_5,
					map_data = var_41_7,
					team_data = var_41_6,
					replay_data = {
						replay = var_41_8
					}
				}
				
				query("proc_verify_client_data", {
					verify_info = json.encode(var_41_10),
					verify_data = json.encode(var_41_11)
				})
				
				arg_41_0.current = arg_41_0.current + 1
			else
				Log.e("verify data to server finish")
			end
		end
	}
	local var_39_1 = table.clone(var_39_0)
	
	var_39_1:init(arg_39_1)
	var_39_1:next()
	UIAction:Remove("proc_verify_server")
	
	function MsgHandler.proc_verify_client_data(arg_42_0)
		UIAction:Add(SEQ(DELAY(800), CALL(function()
			var_39_1:next()
		end)), SceneManager:getCurrentScene(), "proc_verify_server")
	end
end

function verify_local_from_server_data(arg_44_0, arg_44_1, arg_44_2)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local function var_44_0(arg_45_0, arg_45_1)
		local var_45_0 = table.clone(arg_45_1.init_data)
		local var_45_1 = table.clone(arg_45_1.team_data)
		local var_45_2 = table.clone(arg_45_1.map_data)
		
		if arg_45_0 > 1 then
			var_45_2.seed = math.random(1, 999999)
			var_45_2.logic_seed = math.random(1, 999999)
		end
		
		local var_45_3 = BattleLogic:makeLogic(var_45_2, var_45_1, var_45_0)
		
		function var_45_3.getProcInfoDelay(arg_46_0)
			return -1
		end
		
		local var_45_4 = {}
		local var_45_5 = BackPlayBattle(var_45_3, var_45_4)
		
		var_45_5:start()
		
		local var_45_6 = false
		
		for iter_45_0 = 1, 999999 do
			var_45_5:update(10)
			
			if var_45_5.logic:isEnded() then
				var_45_6 = true
				
				break
			end
		end
		
		if not var_45_6 then
			return false, "verify loop error"
		end
		
		local var_45_7 = table.clone(var_45_5.logic.battle_info.replay_data)
		local var_45_8 = var_45_5.logic:verifyAll()
		
		return var_45_8.success, var_45_8.reason, var_45_8.info, var_45_7
	end
	
	function MsgHandler.get_verify_data(arg_47_0)
		local var_47_0 = false
		local var_47_1 = {
			init_data = {},
			team_data = json.decode(arg_47_0.team_info),
			map_data = json.decode(arg_47_0.battle_data),
			replay_data = json.decode(arg_47_0.replay_data)
		}
		
		Lobby.logic_data = var_47_1
		
		if var_47_0 then
			for iter_47_0 = 1, 10 do
				if not var_44_0(iter_47_0, var_47_1) then
					Log.e("verify fail", iter_47_0)
					
					return 
				end
			end
			
			Log.e("verify success all")
		else
			BattleLogic:makeLogic(var_47_1.map_data, var_47_1.team_data):verifyAll({
				command_data = var_47_1.replay_data.replay
			})
			
			if arg_44_0 then
				local var_47_2 = BattleLogic:makeLogic(var_47_1.map_data, var_47_1.team_data)
				
				SceneManager:nextScene("battle", {
					logic = var_47_2
				})
			end
		end
	end
	
	query("get_verify_data", {
		user_id = arg_44_1,
		battle_id = arg_44_2
	})
end

function map_verify_enter(arg_48_0, arg_48_1)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local var_48_0 = arg_48_0 or "hunw001"
	local var_48_1 = "logic_data_" .. var_48_0
	
	Log.e("LOAD BATTLE DATA", var_48_0)
	
	local var_48_2 = getenv("app.data_path") .. "/" .. var_48_1
	local var_48_3 = io.open(var_48_2, "rb")
	local var_48_4
	
	if var_48_3 then
		local var_48_5 = var_48_3:read("*a")
		
		var_48_4 = json.decode(var_48_5)
		
		if not var_48_4 then
			return false, "file decode fail"
		end
	else
		return false, "cannot open file"
	end
	
	local var_48_6 = table.clone(var_48_4.init_data)
	local var_48_7 = table.clone(var_48_4.team_data)
	local var_48_8 = table.clone(var_48_4.map_data)
	
	for iter_48_0 = 1, 4 do
		var_48_7.units[iter_48_0].unit.code = arg_48_1[iter_48_0]
	end
	
	local var_48_9 = BattleLogic:makeLogic(var_48_8, var_48_7, var_48_6)
	
	SceneManager:nextScene("battle", {
		logic = var_48_9
	})
end
