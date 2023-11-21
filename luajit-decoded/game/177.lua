BattleViewerPlayer = {}

function BattleViewerPlayer.create(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {}
	
	copy_functions(BattleViewerPlayer, var_1_0)
	var_1_0:Init(arg_1_1, arg_1_2)
	
	return var_1_0
end

function BattleViewerPlayer.Init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:reset()
	
	arg_2_0.viewer = arg_2_1
	
	LuaEventDispatcher:removeEventListenerByKey("viewer.player")
	LuaEventDispatcher:addEventListener("player.event", LISTENER(BattleViewerPlayer.onEvent, arg_2_0), "viewer.player")
	arg_2_0:execute(arg_2_2.records or {})
end

function BattleViewerPlayer.reset(arg_3_0)
	arg_3_0.viewer = nil
	arg_3_0.handle_list = {}
	arg_3_0.execute_list = {}
	arg_3_0.pause = true
	arg_3_0.root_state = nil
	arg_3_0.turn_state = nil
	arg_3_0.cur_state = nil
	
	LuaEventDispatcher:removeEventListenerByKey("viewer.player")
end

function BattleViewerPlayer.update(arg_4_0)
	if arg_4_0.pause then
		return 
	end
	
	if table.empty(arg_4_0.execute_list) then
		local var_4_0 = arg_4_0.handle_list[1]
		
		if var_4_0 then
			local var_4_1 = Battle.logic:getUnit(var_4_0.owner)
			
			Log.i("VIEW HANDLE START", var_4_0._ID, var_4_1 and var_4_1:getName() or "before start")
			BattleUI:hideArenaTimer()
			var_4_0:executeAction(var_4_0:getRoot())
			table.insert(arg_4_0.execute_list, var_4_0)
			table.remove(arg_4_0.handle_list, 1)
		end
	end
	
	local var_4_2 = {}
	
	for iter_4_0, iter_4_1 in ipairs(arg_4_0.execute_list) do
		iter_4_1:Update()
		
		if iter_4_1:IsFinished() then
			table.insert(var_4_2, 1, iter_4_0)
		end
	end
	
	for iter_4_2, iter_4_3 in ipairs(var_4_2) do
		local var_4_3 = arg_4_0.execute_list[iter_4_3]
		
		table.remove(arg_4_0.execute_list, iter_4_3)
		xpcall(var_4_3.Leave, __G__TRACKBACK__, var_4_3, arg_4_0)
	end
end

function BattleViewerPlayer.isRunning(arg_5_0)
	return not table.empty(arg_5_0.handle_list) or not table.empty(arg_5_0.execute_list)
end

function BattleViewerPlayer.onEvent(arg_6_0, arg_6_1)
	if arg_6_1.type == "EXECUTE" then
		arg_6_0:execute(arg_6_1.infos)
	end
end

function BattleViewerPlayer.addViewHandle(arg_7_0, arg_7_1)
	table.insert(arg_7_0.handle_list, arg_7_1)
end

local function var_0_0(arg_8_0)
	if arg_8_0.type == "HANDLE" or arg_8_0.type == "STATE" or arg_8_0.type == "SNAP" then
		return arg_8_0.type
	end
	
	return "ACTION"
end

function BattleViewerPlayer.execute(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_1 or {}) do
		local var_9_0 = var_0_0(iter_9_1)
		
		if var_9_0 == "HANDLE" then
			local var_9_1 = arg_9_0.viewer:createViewHandle(iter_9_1.turn_owner, iter_9_1.turn_count)
			
			arg_9_0:addViewHandle(var_9_1)
			
			local var_9_2 = arg_9_0.viewer:createViewState("ROOT")
			
			arg_9_0.root_state = var_9_2
			
			var_9_1:addChild(var_9_2)
		elseif var_9_0 == "STATE" then
			local var_9_3 = arg_9_0.viewer:createViewState(iter_9_1.state)
			
			if iter_9_1.parent == "ATTACK" then
				arg_9_0.turn_state:addChild(var_9_3)
			else
				arg_9_0.turn_state = var_9_3
				
				arg_9_0.root_state:addChild(var_9_3)
			end
			
			arg_9_0.cur_state = var_9_3
		elseif var_9_0 == "ACTION" then
			local var_9_4 = arg_9_0.viewer:createViewAction(iter_9_1)
			
			if arg_9_0.cur_state then
				arg_9_0.cur_state:addChild(var_9_4)
			end
		elseif var_9_0 == "SNAP" then
			local var_9_5 = arg_9_0.handle_list[#arg_9_0.handle_list]
			
			if var_9_5 then
				var_9_5:setSnapData(iter_9_1)
			end
		end
	end
end

function BattleViewerPlayer.play(arg_10_0, arg_10_1)
	BattleAction:Add(SEQ(DELAY(arg_10_1), CALL(function()
		arg_10_0.pause = false
	end)), arg_10_0, "viewer.player.event")
end

USE_SKIP_IMMDEIATE = false
BattleViewerReplay = BattleViewerReplay or {}

function BattleViewerReplay.create(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {}
	
	copy_functions(BattleViewerReplay, var_12_0)
	var_12_0:Init(arg_12_1, arg_12_2)
	
	return var_12_0
end

function BattleViewerReplay.Init(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.player = BattleViewerPlayer:create(arg_13_1, arg_13_2)
	arg_13_0.viewer = arg_13_1
	arg_13_0.init_record = arg_13_2.init_record
	arg_13_0.match_info = arg_13_2.match_info
	arg_13_0.version_info = arg_13_2.version_info
	arg_13_0.result_info = arg_13_2.result_info
	arg_13_0.last_emogi_ids = {}
	arg_13_0.turn_datas = arg_13_2.turn_datas or arg_13_0:makeTurnData(arg_13_2.record_data)
	arg_13_0.snap_datas = arg_13_2.snap_datas or arg_13_0:makeSnapData(arg_13_2.snap_data)
	arg_13_0.pause = true
	arg_13_0.finish = false
	arg_13_0.player.pause = false
	arg_13_0.total_turn = table.count(arg_13_0.snap_datas)
	arg_13_0.current_turn = 1
	arg_13_0.current_tick = 1
	arg_13_0.prev_tick = systick()
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.init_record) do
		if iter_13_1.type == "@ready_attack" then
			iter_13_1.skip_move_turn = true
		end
	end
end

function BattleViewerReplay.clear(arg_14_0)
	arg_14_0.pause = true
	arg_14_0.finish = true
end

function BattleViewerReplay.getMatchInfo(arg_15_0)
	return arg_15_0.match_info
end

function BattleViewerReplay.getCurrentTurn(arg_16_0)
	return arg_16_0.current_turn
end

function BattleViewerReplay.getTotalTurn(arg_17_0)
	return arg_17_0.total_turn
end

function BattleViewerReplay.makeSnapData(arg_18_0, arg_18_1)
	local function var_18_0(arg_19_0)
		if not arg_19_0 then
			return false
		end
		
		local var_19_0 = true
		
		for iter_19_0 = 1, 4 do
			if arg_19_0.unit_state[iter_19_0].hp > 0 then
				var_19_0 = false
				
				break
			end
		end
		
		local var_19_1 = true
		
		for iter_19_1 = 5, 8 do
			if arg_19_0.unit_state[iter_19_1].hp > 0 then
				var_19_1 = false
				
				break
			end
		end
		
		return var_19_0 or var_19_1
	end
	
	local var_18_1 = table.clone(arg_18_1)
	
	if var_18_0(var_18_1[#var_18_1]) then
		var_18_1[#var_18_1].result_data = arg_18_0.result_info
	elseif #var_18_1 > #arg_18_0.turn_datas then
		var_18_1[#var_18_1].result_data = arg_18_0.result_info
	else
		table.insert(var_18_1, {
			result_data = arg_18_0.result_info
		})
	end
	
	return var_18_1
end

function BattleViewerReplay.makeTurnData(arg_20_0, arg_20_1)
	local var_20_0 = {}
	local var_20_1 = 1
	local var_20_2 = {
		[arg_20_0.match_info.home_user] = {
			_id = 0
		},
		[arg_20_0.match_info.away_user] = {
			_id = 0
		}
	}
	
	table.insert(arg_20_0.last_emogi_ids, var_20_2)
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1 or {}) do
		if iter_20_1.record_info or iter_20_1.time_info then
			var_20_0[var_20_1] = var_20_0[var_20_1] or {}
			
			table.insert(var_20_0[var_20_1], iter_20_1)
		end
		
		if iter_20_1.emogi_info then
			var_20_2 = iter_20_1.emogi_info
		end
		
		if iter_20_1.record_info then
			if var_20_2 then
				table.insert(arg_20_0.last_emogi_ids, var_20_2)
			end
			
			var_20_1 = var_20_1 + 1
		end
	end
	
	if #var_20_0 > 0 then
		local var_20_3 = var_20_0[#var_20_0]
		local var_20_4 = var_20_0[#var_20_0][#var_20_3]
		
		var_20_4.is_last = true
		
		if not var_20_4.record_info then
			var_20_4.result_data = arg_20_0.result_info
		end
	end
	
	return var_20_0
end

function BattleViewerReplay.updateUnitState(arg_21_0)
	if arg_21_0.result_info and arg_21_0.result_info.net_pvp_result then
		for iter_21_0, iter_21_1 in pairs(arg_21_0.result_info.net_pvp_result.skill_info or {}) do
			local var_21_0 = Battle.logic:getUnit(iter_21_0)
			
			if var_21_0 then
				var_21_0:setSkillLevelInfo(iter_21_1)
			end
		end
	end
end

function BattleViewerReplay.update(arg_22_0)
	arg_22_0:tick()
	arg_22_0.player:update()
end

function BattleViewerReplay.tick(arg_23_0)
	if math.clamp(systick() - arg_23_0.prev_tick, 0, 1000) < 1000 then
		return 
	end
	
	arg_23_0.prev_tick = systick()
	
	if arg_23_0.pause then
		return 
	end
	
	if not arg_23_0.turn_datas[arg_23_0.current_turn] then
		return 
	end
	
	local var_23_0 = arg_23_0.turn_datas[arg_23_0.current_turn][arg_23_0.current_tick]
	
	if var_23_0 then
		local var_23_1 = var_23_0.record_info
		
		if var_23_1 then
			LuaEventDispatcher:dispatchEvent("player.event", {
				type = "EXECUTE",
				infos = var_23_1.records
			})
		end
		
		local var_23_2 = var_23_0.time_info
		
		if var_23_2 then
			BattleUI:updateArenaTimer(var_23_2)
		end
		
		local var_23_3 = var_23_0.emogi_info
		
		if var_23_3 then
			LuaEventDispatcher:dispatchEvent("arena.emogi.res", "push", var_23_3)
		end
	end
	
	if var_23_0 and var_23_0.is_last and var_23_0.result_data then
		arg_23_0:nextTurn()
	end
	
	arg_23_0.current_tick = arg_23_0.current_tick + 1
end

function BattleViewerReplay.isPlaying(arg_24_0)
	if arg_24_0.pause == nil then
		return false
	end
	
	return not arg_24_0.pause
end

function BattleViewerReplay.play(arg_25_0, arg_25_1)
	arg_25_0.pause = false
end

function BattleViewerReplay.stop(arg_26_0)
	arg_26_0.pause = true
end

function BattleViewerReplay.prevTurn(arg_27_0)
	if not Battle:isPlayingBattleAction() and not StageStateManager:isRunning() and not BattleAction:Find("battle.dead") then
		return arg_27_0:moveTurn(-1)
	end
end

function BattleViewerReplay.prev3Turn(arg_28_0)
	if not Battle:isPlayingBattleAction() and not StageStateManager:isRunning() and not BattleAction:Find("battle.dead") then
		return arg_28_0:moveTurn(-3)
	end
end

function BattleViewerReplay.nextTurn(arg_29_0)
	if not Battle:isPlayingBattleAction() and not StageStateManager:isRunning() and not BattleAction:Find("battle.dead") then
		return arg_29_0:moveTurn(1)
	end
end

function BattleViewerReplay.next3Turn(arg_30_0)
	if not Battle:isPlayingBattleAction() and not StageStateManager:isRunning() and not BattleAction:Find("battle.dead") then
		return arg_30_0:moveTurn(3)
	end
end

function BattleViewerReplay.move(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0.snap_datas[arg_31_1] then
		if not arg_31_2 and arg_31_0.snap_datas[arg_31_1] then
			BattleUI:hideArenaTimer()
			BattleAction:Remove("battle.ready")
			arg_31_0:clearForeground()
			arg_31_0.viewer:addInfo({
				immdeiate = true,
				type = "update_viewer",
				snap_data = arg_31_0.snap_datas[arg_31_1]
			})
		end
		
		if arg_31_0.snap_datas[arg_31_1].result_data then
			arg_31_0:endBattle()
		end
	end
end

function BattleViewerReplay.endBattle(arg_32_0)
	if arg_32_0.finish then
		Log.i("REPLAY ALREADY FINISH")
		
		return 
	end
	
	if not ClearResult:isShow() then
		Log.i("REPLAY END BATTLE")
		
		arg_32_0.result_info.is_replay = true
		
		ClearResult:show(Battle.logic, arg_32_0.result_info)
	end
end

function BattleViewerReplay.clearForeground(arg_33_0)
	if not USE_SKIP_IMMDEIATE then
		return 
	end
	
	ShakeManager:stop()
	
	for iter_33_0 = #arg_33_0.player.execute_list, 1, -1 do
		arg_33_0.player.execute_list[iter_33_0]:Leave()
		table.remove(arg_33_0.player.execute_list, iter_33_0)
	end
	
	for iter_33_1, iter_33_2 in pairs(StageStateManager._execute_handle_list or {}) do
		iter_33_1:Finish()
	end
end

function BattleViewerReplay.canMove(arg_34_0, arg_34_1)
	if not USE_SKIP_IMMDEIATE and (Battle:isPlayingBattleAction() or StageStateManager:isRunning()) then
		return false
	end
	
	if Battle.pause then
		return false
	end
	
	if UIBattleAttackOrder:isVisible() then
		return false
	end
	
	local var_34_0 = arg_34_0.current_turn + arg_34_1
	
	if var_34_0 <= 0 then
		return false
	end
	
	if var_34_0 > arg_34_0.total_turn then
		return false
	end
	
	return true
end

function BattleViewerReplay.moveTurn(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0, var_35_1 = arg_35_0:canMove(arg_35_1)
	
	if not var_35_0 then
		return false, var_35_1
	end
	
	arg_35_0.current_turn = arg_35_0.current_turn + arg_35_1
	arg_35_0.current_tick = 1
	
	if arg_35_0.current_turn == 1 and arg_35_1 == 0 then
		LuaEventDispatcher:dispatchEvent("player.event", {
			type = "EXECUTE",
			infos = arg_35_0.init_record
		})
	end
	
	arg_35_0:move(arg_35_0.current_turn, arg_35_2)
	
	if arg_35_0.last_emogi_ids[arg_35_0.current_turn] then
		LuaEventDispatcher:dispatchEvent("arena.emogi.res", "update_last_ids", arg_35_0.last_emogi_ids[arg_35_0.current_turn])
	end
	
	if arg_35_1 < 0 then
		ClearResult:hide()
		ClearResult:removeAll()
	end
	
	Log.i("Replay current turn", arg_35_0.current_turn)
	
	return true
end
