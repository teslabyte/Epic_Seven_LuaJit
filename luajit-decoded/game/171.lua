BattleLogicSnap = {}
USE_UNIT_DIFF = true
USE_CS_DIFF = true
VIEWER_TEXT_FILTER = {
	"immune",
	"resist_cool",
	"resist_time",
	"resist_state",
	"remove_buffs",
	"remove_debuffs",
	"add_turn",
	"skill_eff",
	"toggle_cs",
	"text",
	"add_tick",
	"add_skill_cool"
}

function BattleLogicSnap.create(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {}
	
	copy_functions(BattleLogicSnap, var_1_0)
	var_1_0:init(arg_1_1, arg_1_2)
	
	return var_1_0
end

function BattleLogicSnap.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.logic = arg_2_1
end

function BattleLogicSnap.createViewDatas(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:makeViewData(arg_3_1)
	local var_3_1 = arg_3_0:makeSnapData((var_3_0 or {})._id, arg_3_1)
	local var_3_2 = {}
	
	if var_3_0 then
		var_3_2.VIEW_DATA = var_3_0
	end
	
	if var_3_1 then
		var_3_2.SNAP_DATA = var_3_1
	end
	
	return var_3_2
end

function BattleLogicSnap.makeViewData(arg_4_0, arg_4_1)
	local function var_4_0(arg_5_0)
		if arg_5_0 then
			return arg_5_0:getUID()
		end
	end
	
	local function var_4_1(arg_6_0)
		if arg_6_0 then
			return arg_6_0:getGUId()
		end
	end
	
	local function var_4_2(arg_7_0, arg_7_1)
		for iter_7_0, iter_7_1 in pairs(arg_7_1) do
			if type(iter_7_1) == "table" then
				if iter_7_1.isClassUnit then
					arg_7_0[iter_7_0] = var_4_0(iter_7_1)
				elseif iter_7_1.isClassState then
					arg_7_0[iter_7_0] = var_4_1(iter_7_1)
				else
					arg_7_0[iter_7_0] = {}
					
					var_4_2(arg_7_0[iter_7_0], iter_7_1)
				end
			else
				arg_7_0[iter_7_0] = iter_7_1
			end
		end
	end
	
	local var_4_3 = {
		type = arg_4_1.type,
		_id = arg_4_0.logic.battle_info.proc_info.counter
	}
	
	arg_4_0.logic.battle_info.proc_info.counter = arg_4_0.logic.battle_info.proc_info.counter + 1
	
	var_4_2(var_4_3, arg_4_1)
	
	if var_4_3.type == "add_state" then
		var_4_3.state_data = arg_4_1.state:exportPureData(true, true)
	elseif var_4_3.type == "remove_state" then
		var_4_3.state_data = arg_4_1.state:exportPureData(true, true)
	elseif var_4_3.type == "invoke_passive" then
		var_4_3.target = var_4_0(arg_4_1.target)
		var_4_3.state_data = arg_4_1.state:exportPureData(true, true)
		var_4_3.text = arg_4_1.text
	end
	
	return var_4_3
end

function BattleLogicSnap.getData(arg_8_0)
	return {
		stage_state = arg_8_0.cur_stage_state,
		team_state = arg_8_0.cur_team_state,
		skill_state = arg_8_0.cur_skill_state,
		unit_state = arg_8_0.cur_unit_state,
		cs_state = arg_8_0.cur_cs_state
	}
end

function BattleLogicSnap.makeSnapData(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1 then
		return 
	end
	
	local var_9_0 = {
		type = "SNAP",
		_id = arg_9_1
	}
	
	arg_9_0:makeStageSnapData(var_9_0, arg_9_2)
	arg_9_0:makeTeamSnapData(var_9_0, arg_9_2)
	arg_9_0:makeUnitSnapData(var_9_0, arg_9_2)
	arg_9_0:makeSkillSnapData(var_9_0, arg_9_2)
	arg_9_0:makeCSSnapData(var_9_0, arg_9_2)
	
	return var_9_0
end

function BattleLogicSnap.makeStageSnapData(arg_10_0, arg_10_1, arg_10_2)
	local function var_10_0()
		return {
			turn_owner = arg_10_0.logic:getTurnOwner():getUID(),
			turn_state = arg_10_0.logic:getTurnState(),
			stage_counter = arg_10_0.logic:getStageCounter(),
			final_result = arg_10_0.logic:getFinalResult(),
			battle_info = arg_10_0.logic.battle_info.completed_road_event_tbl
		}
	end
	
	local var_10_1 = {
		"@start_turn",
		"@ready_attack",
		"@end_battle",
		"all"
	}
	
	if table.find(var_10_1, arg_10_2.type) then
		arg_10_0.cur_stage_state = var_10_0()
		arg_10_1.stage_state = arg_10_0:diffStageData(arg_10_0.cur_stage_state)
	end
end

function BattleLogicSnap.makeTeamSnapData(arg_12_0, arg_12_1, arg_12_2)
	local function var_12_0()
		local var_13_0 = {
			[FRIEND] = var_13_0[FRIEND] or {},
			[ENEMY] = var_13_0[ENEMY] or {}
		}
		
		var_13_0[FRIEND].soul_piece = arg_12_0.logic:getTeamRes(FRIEND, "soul_piece") or 0
		var_13_0[ENEMY].soul_piece = arg_12_0.logic:getTeamRes(ENEMY, "soul_piece") or 0
		
		return var_13_0
	end
	
	local var_12_1 = {
		"@start_turn",
		"attack",
		"@end_turn",
		"all"
	}
	
	if table.find(var_12_1, arg_12_2.type) then
		arg_12_0.cur_team_state = var_12_0()
		arg_12_1.team_state = arg_12_0.cur_team_state
	end
end

function BattleLogicSnap.makeUnitSnapData(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.cur_unit_state = arg_14_0.cur_unit_state or {}
	
	local function var_14_0(arg_15_0)
		if not arg_15_0 then
			return 
		end
		
		local var_15_0 = {}
		
		for iter_15_0, iter_15_1 in pairs(arg_15_0) do
			local var_15_1 = iter_15_1:getUID()
			
			var_15_0[var_15_1] = iter_15_1:exportPureData()
			var_15_0[var_15_1].dead = iter_15_1:isDead()
			var_15_0[var_15_1].order = iter_15_1.inst.team_order
			var_15_0[var_15_1].resurrect_block = iter_15_1.inst.resurrect_block
			var_15_0[var_15_1].transform_vars = iter_15_1.transform_vars
		end
		
		return var_15_0
	end
	
	local var_14_1 = {
		"@start_turn",
		"@end_turn",
		"@skill_start",
		"attack",
		"heal",
		"add_state",
		"remove_state",
		"add_tick",
		"dead",
		"resurrect",
		"summon",
		"appear",
		"appear_by_tag",
		"disappear_by_tag",
		"sp_dec",
		"all"
	}
	
	if table.find(var_14_1, arg_14_2.type) then
		local var_14_2 = {}
		
		if arg_14_2.type == "add_state" or arg_14_2.type == "remove_state" or arg_14_2.type == "sp_dec" then
			local var_14_3 = arg_14_0.logic:getUnit(arg_14_2.target)
			
			if var_14_3 or arg_14_2.target then
				var_14_2 = var_14_0({
					var_14_3 or arg_14_2.target
				})
			end
		elseif arg_14_2.type == "resurrect" or arg_14_2.type == "summon" or arg_14_2.type == "appear" or arg_14_2.type == "appear_by_tag" or arg_14_2.type == "disappear_by_tag" then
			var_14_2 = var_14_0({
				arg_14_2.dead_unit
			})
		else
			var_14_2 = var_14_0(arg_14_0.logic.allocated_unit_tbl)
		end
		
		for iter_14_0, iter_14_1 in pairs(var_14_2) do
			arg_14_0.cur_unit_state[iter_14_0] = iter_14_1
		end
		
		arg_14_1.unit_state = arg_14_0:diffUnitData(var_14_2)
	end
end

function BattleLogicSnap.makeCSSnapData(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.cur_cs_state = arg_16_0.cur_cs_state or {}
	
	local function var_16_0(arg_17_0)
		if not arg_17_0 then
			return 
		end
		
		local var_17_0 = {}
		
		for iter_17_0, iter_17_1 in pairs(arg_17_0) do
			var_17_0[iter_17_1:getUID()] = iter_17_1.states:exportPureData(true)
		end
		
		return var_17_0
	end
	
	local var_16_1 = {
		"@start_turn",
		"@end_turn",
		"@skill_start",
		"attack",
		"heal",
		"add_state",
		"remove_state",
		"skill_eff",
		"sort_order",
		"all"
	}
	
	if table.find(var_16_1, arg_16_2.type) then
		local var_16_2 = {}
		
		if arg_16_2.type == "attack" then
			if arg_16_2.cur_hit ~= arg_16_2.tot_hit then
				return 
			end
			
			var_16_2 = var_16_0(arg_16_0.logic.allocated_unit_tbl)
		else
			var_16_2 = var_16_0(arg_16_0.logic.allocated_unit_tbl)
		end
		
		for iter_16_0, iter_16_1 in pairs(var_16_2) do
			arg_16_0.cur_cs_state[iter_16_0] = iter_16_1
		end
		
		arg_16_1.cs_state = arg_16_0:diffCSData(var_16_2)
	end
end

function BattleLogicSnap.makeSkillSnapData(arg_18_0, arg_18_1, arg_18_2)
	local function var_18_0(arg_19_0)
		if not arg_19_0 then
			return 
		end
		
		local var_19_0 = {}
		
		for iter_19_0, iter_19_1 in pairs(arg_19_0) do
			local var_19_1 = iter_19_1:getUID()
			
			var_19_0[var_19_1] = var_19_0[var_19_1] or {}
			
			for iter_19_2, iter_19_3 in ipairs(iter_19_1:getSkillBundle():toSkills()) do
				if iter_19_3:assigned() and iter_19_2 > 1 then
					local var_19_2 = iter_19_3:getOriginSkillId()
					local var_19_3 = iter_19_1:getSkillCool(var_19_2)
					
					var_19_0[var_19_1][var_19_2] = var_19_0[var_19_1][var_19_2] or {}
					var_19_0[var_19_1][var_19_2] = var_19_3
				end
			end
		end
		
		return var_19_0
	end
	
	local var_18_1 = {
		"@start_turn",
		"attack",
		"@end_turn",
		"skill_eff",
		"all"
	}
	
	if table.find(var_18_1, arg_18_2.type) then
		if arg_18_2.type == "attack" then
			if arg_18_2.cur_hit ~= arg_18_2.tot_hit then
				return 
			end
			
			arg_18_0.cur_skill_state = var_18_0(arg_18_0.logic.allocated_unit_tbl)
		else
			arg_18_0.cur_skill_state = var_18_0(arg_18_0.logic.allocated_unit_tbl)
		end
		
		arg_18_1.skill_state = arg_18_0.cur_skill_state
	end
end

function diffData(arg_20_0, arg_20_1)
	if not arg_20_0 then
		return arg_20_1
	end
	
	local var_20_0
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		if arg_20_1[iter_20_0] ~= arg_20_0[iter_20_0] then
			var_20_0 = var_20_0 or {}
			var_20_0[iter_20_0] = arg_20_1[iter_20_0]
		end
	end
	
	return var_20_0
end

function diffCSData(arg_21_0, arg_21_1)
	if not arg_21_0 then
		return arg_21_1
	end
	
	local var_21_0 = {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		local var_21_1 = {}
		local var_21_2
		
		if USE_STATE_COMPACT then
			var_21_2 = table.find(arg_21_0, function(arg_22_0, arg_22_1)
				return iter_21_1.a == arg_22_1.a
			end)
			var_21_1 = {
				a = iter_21_1.a
			}
		else
			var_21_2 = table.find(arg_21_0, function(arg_23_0, arg_23_1)
				return iter_21_1.guid == arg_23_1.guid
			end)
			var_21_1 = {
				guid = iter_21_1.guid
			}
		end
		
		for iter_21_2, iter_21_3 in pairs(iter_21_1) do
			if iter_21_1[iter_21_2] ~= (arg_21_0[var_21_2] or {})[iter_21_2] then
				var_21_1[iter_21_2] = iter_21_1[iter_21_2]
			end
		end
		
		table.insert(var_21_0, var_21_1)
	end
	
	return var_21_0
end

function BattleLogicSnap.diffStageData(arg_24_0, arg_24_1)
	arg_24_0.prev_stage_state = arg_24_0.prev_stage_state or {}
	
	local var_24_0 = diffData(arg_24_0.prev_stage_state, arg_24_1)
	
	arg_24_0.prev_stage_state = arg_24_1
	
	return var_24_0
end

function BattleLogicSnap.diffUnitData(arg_25_0, arg_25_1)
	arg_25_0.prev_unit_state = arg_25_0.prev_unit_state or {}
	
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_1) do
		arg_25_0.prev_unit_state[iter_25_0] = arg_25_0.prev_unit_state[iter_25_0] or {}
		var_25_0[iter_25_0] = var_25_0[iter_25_0] or {}
		var_25_0[iter_25_0] = diffData(arg_25_0.prev_unit_state[iter_25_0], iter_25_1)
	end
	
	arg_25_0.prev_unit_state = arg_25_1
	
	return var_25_0
end

function BattleLogicSnap.diffCSData(arg_26_0, arg_26_1)
	arg_26_0.prev_cs_state = arg_26_0.prev_cs_state or {}
	
	local var_26_0 = {}
	
	for iter_26_0, iter_26_1 in pairs(arg_26_1) do
		arg_26_0.prev_cs_state[iter_26_0] = arg_26_0.prev_cs_state[iter_26_0] or {}
		
		local var_26_1 = diffCSData(arg_26_0.prev_cs_state[iter_26_0].list, arg_26_1[iter_26_0].list)
		
		var_26_0[iter_26_0] = {
			counter = iter_26_1.counter,
			list = var_26_1
		}
	end
	
	arg_26_0.prev_cs_state = arg_26_1
	
	return var_26_0
end

function BattleLogicSnap.onSnapData(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_2.clearAll then
		for iter_27_0, iter_27_1 in pairs(arg_27_0.logic.units) do
			if iter_27_1 then
				iter_27_1.states:clear({
					ignore_passives = true
				})
			end
		end
	end
	
	for iter_27_2, iter_27_3 in pairs(arg_27_1) do
		if iter_27_2 == "stage_state" then
			arg_27_0:onStageState(iter_27_3)
		elseif iter_27_2 == "team_state" then
			arg_27_0:onTeamState(iter_27_3)
		elseif iter_27_2 == "unit_state" then
			arg_27_0:onUnitState(iter_27_3)
		elseif iter_27_2 == "cs_state" then
			arg_27_0:onCSState(iter_27_3)
		elseif iter_27_2 == "skill_state" then
			arg_27_0:onSkillState(iter_27_3)
		end
	end
end

function BattleLogicSnap.onStageState(arg_28_0, arg_28_1)
	arg_28_0.logic.turn_info.turn_owner = arg_28_0.logic:getUnit(tonumber(arg_28_1.turn_owner)) or arg_28_0.logic.turn_info.turn_owner
	arg_28_0.logic.turn_info.state = arg_28_1.turn_state or arg_28_0.logic.turn_info.state
	arg_28_0.logic.stage_counter = arg_28_1.stage_counter or 0
	arg_28_0.logic.last_stage_result = arg_28_1.final_result or arg_28_0.logic.last_stage_result
	arg_28_0.logic.battle_info.completed_road_event_tbl = arg_28_1.battle_info or arg_28_0.logic.battle_info.completed_road_event_tbl
end

function BattleLogicSnap.onTeamState(arg_29_0, arg_29_1)
	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		if arg_29_0.logic.map.is_reverse then
			if iter_29_0 == FRIEND then
				iter_29_0 = ENEMY
			else
				iter_29_0 = FRIEND
			end
		end
		
		for iter_29_2, iter_29_3 in pairs(iter_29_1) do
			arg_29_0.logic:setTeamRes(iter_29_0, iter_29_2, iter_29_3)
		end
	end
end

function BattleLogicSnap.onUnitState(arg_30_0, arg_30_1)
	local function var_30_0(arg_31_0, arg_31_1)
		if arg_31_0 ~= nil then
			return arg_31_0
		else
			return arg_31_1
		end
	end
	
	for iter_30_0, iter_30_1 in pairs(arg_30_1) do
		local var_30_1 = arg_30_0.logic:getUnit(tonumber(iter_30_0))
		
		if var_30_1 then
			var_30_1.status.max_hp = var_30_0(iter_30_1.max_hp, var_30_1.status.max_hp)
			var_30_1.inst.dhp = var_30_0(iter_30_1.dhp, var_30_1.inst.dhp)
			var_30_1.inst.hp = var_30_0(iter_30_1.hp, var_30_1.inst.hp)
			var_30_1.inst[var_30_1:getSPName()] = var_30_0(iter_30_1.sp, var_30_1.inst[var_30_1:getSPName()])
			var_30_1.inst.dead = iter_30_1.dead
			var_30_1.inst.resurrect_block = var_30_0(iter_30_1.resurrect_block, var_30_1.inst.resurrect_block)
			var_30_1.transform_vars = iter_30_1.transform_vars
			var_30_1.inst.team_order = var_30_0(iter_30_1.order, var_30_1.inst.team_order)
			var_30_1.inst.elapsed_ut = var_30_0(iter_30_1.et, var_30_1.inst.elapsed_ut)
		end
	end
end

function BattleLogicSnap.onCSState(arg_32_0, arg_32_1)
	local function var_32_0(arg_33_0, arg_33_1)
		if not USE_STATE_DIFF then
			return StateList:restorePureData(arg_33_1)
		end
		
		local var_33_0 = 0
		local var_33_1 = {}
		
		for iter_33_0, iter_33_1 in pairs(arg_33_0.states.List) do
			iter_33_1.mark = false
		end
		
		for iter_33_2, iter_33_3 in pairs(arg_33_1.list) do
			local var_33_2
			
			if USE_STATE_COMPACT then
				var_33_2 = table.find(arg_33_0.states.List, function(arg_34_0, arg_34_1)
					return iter_33_3.a == arg_34_1.guid
				end)
			else
				var_33_2 = table.find(arg_33_0.states.List, function(arg_35_0, arg_35_1)
					return iter_33_3.guid == arg_35_1.guid
				end)
			end
			
			if arg_33_0.states.List[var_33_2] then
				arg_33_0.states.List[var_33_2]:updatePureData(iter_33_3)
				
				arg_33_0.states.List[var_33_2].mark = true
			elseif table.count(iter_33_3) <= 1 then
			else
				local var_33_3 = State:restorePureData(arg_33_0.states.owner, iter_33_3)
				
				if var_33_3 then
					var_33_3.mark = true
					
					table.insert(arg_33_0.states.List, var_33_3)
				end
			end
			
			if false then
			end
		end
		
		for iter_33_4 = #arg_33_0.states.List, 1, -1 do
			if not arg_33_0.states.List[iter_33_4].mark then
				table.remove(arg_33_0.states.List, iter_33_4)
			end
		end
		
		arg_33_0.states.counter = arg_33_1.counter or var_33_0
	end
	
	for iter_32_0, iter_32_1 in pairs(arg_32_1) do
		local var_32_1 = arg_32_0.logic:getUnit(tonumber(iter_32_0))
		
		if var_32_1 and iter_32_1 then
			var_32_0(var_32_1, iter_32_1)
		end
	end
end

function BattleLogicSnap.onSkillState(arg_36_0, arg_36_1)
	for iter_36_0, iter_36_1 in pairs(arg_36_1) do
		local var_36_0 = arg_36_0.logic:getUnit(tonumber(iter_36_0))
		
		if var_36_0 then
			for iter_36_2, iter_36_3 in pairs(iter_36_1) do
				var_36_0.inst.skill_cool[iter_36_2] = var_36_0.inst.skill_cool[iter_36_2] or {}
				var_36_0.inst.skill_cool[iter_36_2] = iter_36_3
			end
		end
	end
end
