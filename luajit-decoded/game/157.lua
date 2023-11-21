State = {}
State.cache = {}
State.used_cs_lv = nil
StateList = {}

local function var_0_0()
	State.used_cs_lv = {}
	
	for iter_1_0 = 1, 9999 do
		local var_1_0 = {}
		local var_1_1 = {}
		
		for iter_1_1 = 1, 18 do
			table.insert(var_1_1, "type" .. iter_1_1)
		end
		
		var_1_0[1], var_1_0[2], var_1_0[3], var_1_0[4], var_1_0[5], var_1_0[6], var_1_0[7], var_1_0[8], var_1_0[9], var_1_0[10], var_1_0[11], var_1_0[12], var_1_0[13], var_1_0[14], var_1_0[15], var_1_0[16], var_1_0[17], var_1_0[18] = DBN("cslv", iter_1_0, var_1_1)
		
		if table.empty(var_1_0) then
			break
		end
		
		for iter_1_2, iter_1_3 in pairs(var_1_0) do
			if iter_1_3 and not table.find(State.used_cs_lv, iter_1_3) then
				table.insert(State.used_cs_lv, iter_1_3)
			end
		end
	end
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 then
		for iter_2_0, iter_2_1 in pairs(arg_2_1 or {}) do
			if type(iter_2_1) == "table" then
				if var_0_1(arg_2_0[iter_2_0], iter_2_1) then
					return true
				end
			elseif arg_2_0[iter_2_0] ~= iter_2_1 then
				return true
			end
		end
	else
		if not State.used_cs_lv then
			var_0_0()
		end
		
		for iter_2_2, iter_2_3 in pairs(State.used_cs_lv) do
			if arg_2_0[iter_2_3] ~= arg_2_1[iter_2_3] then
				return true
			end
		end
	end
end

function State.create(arg_3_0, arg_3_1, arg_3_2)
	arg_3_2 = arg_3_2 or {}
	
	local var_3_0 = {}
	local var_3_1 = State.cache[arg_3_1.id]
	
	if not var_3_1 then
		var_3_1 = SLOW_DB_ALL("cs", tostring(arg_3_1.id))
		State.cache[arg_3_1.id] = var_3_1
	end
	
	local var_3_2 = UNIT.getCSDB_All(arg_3_1.giver, var_3_1, tostring(arg_3_1.id), arg_3_1.skill_id)
	
	if arg_3_2.override_pow then
		for iter_3_0, iter_3_1 in pairs(arg_3_2.override_pow) do
			if var_3_2["cs_eff_value" .. iter_3_0] then
				var_3_2["cs_eff_value" .. iter_3_0] = iter_3_1
			end
		end
	end
	
	var_3_2.cs_eff = {
		var_3_2.cs_eff1,
		var_3_2.cs_eff2,
		var_3_2.cs_eff3,
		var_3_2.cs_eff4,
		var_3_2.cs_eff5,
		var_3_2.cs_eff6
	}
	var_3_2.cs_eff_value = {
		var_3_2.cs_eff_value1,
		var_3_2.cs_eff_value2,
		var_3_2.cs_eff_value3,
		var_3_2.cs_eff_value4,
		var_3_2.cs_eff_value5,
		var_3_2.cs_eff_value6
	}
	var_3_2.cs_eff_turn = {
		var_3_2.cs_eff_turn1,
		var_3_2.cs_eff_turn2,
		var_3_2.cs_eff_turn3,
		var_3_2.cs_eff_turn4,
		var_3_2.cs_eff_turn5,
		var_3_2.cs_eff_turn6
	}
	var_3_2.cs_eff_valuegrow = {
		var_3_2.cs_eff_valuegrow1,
		var_3_2.cs_eff_valuegrow2,
		var_3_2.cs_eff_valuegrow3,
		var_3_2.cs_eff_valuegrow4,
		var_3_2.cs_eff_valuegrow5,
		var_3_2.cs_eff_valuegrow6
	}
	var_3_2.cs_stackinc = {
		var_3_2.cs_stackinc1,
		var_3_2.cs_stackinc2,
		var_3_2.cs_stackinc3,
		var_3_2.cs_stackinc4,
		var_3_2.cs_stackinc5,
		var_3_2.cs_stackinc6
	}
	var_3_2.cs_con = {
		var_3_2.cs_con1,
		var_3_2.cs_con2,
		var_3_2.cs_con3,
		var_3_2.cs_con4
	}
	var_3_2.cs_con_value = {
		var_3_2.cs_con_value1,
		var_3_2.cs_con_value2,
		var_3_2.cs_con_value3,
		var_3_2.cs_con_value4
	}
	var_3_2.cs_con_target = {
		var_3_2.cs_con_target1,
		var_3_2.cs_con_target2,
		var_3_2.cs_con_target3,
		var_3_2.cs_con_target4
	}
	var_3_0.db = var_3_2
	var_3_0.guid = arg_3_1.guid
	var_3_0.uid = arg_3_1.uid
	var_3_0.skill_id = arg_3_1.skill_id
	var_3_0.id = arg_3_1.id
	var_3_0.lv = arg_3_1.lv or 1
	var_3_0.turn = arg_3_1.turn or var_3_0.db.cs_turn or 1
	var_3_0.cool = 0
	var_3_0.turn_proc_count = 0
	var_3_0.add_pow = 0
	var_3_0.override_pow = arg_3_2.override_pow
	var_3_0.max_cool = to_n(var_3_0.db.cs_cooltime)
	
	if var_3_0.db.cs_turngrow then
		var_3_0.turn = var_3_0.turn + math.floor(var_3_0.db.cs_turngrow * (var_3_0.lv - 1))
	end
	
	var_3_0.giver = arg_3_1.giver
	
	if arg_3_1.giver then
		var_3_0.giver_status = table.clone(arg_3_1.giver.status)
	end
	
	var_3_0.value = 0
	var_3_0.stack_count = arg_3_1.stack_count or 1
	var_3_0.proc_priority = var_3_0.db.cs_unique_rank or 0
	var_3_0.inc_value = 0
	var_3_0.dec_value = 0
	var_3_0.is_only_hero = var_3_0.db.cs_only_hero == "y"
	var_3_0.effect = var_3_0.db.cs_effect and string.split(var_3_0.db.cs_effect, ",")[1]
	var_3_0.eff_bone = string.split(var_3_0.db.cs_eff_bone, ",")[1]
	var_3_0.eff_scale = var_3_0.db.cs_effect_scale or 1
	
	if var_3_0.turn == 0 then
		var_3_0.turn = math.huge
	end
	
	var_3_0.owner = arg_3_1.owner
	
	copy_functions(State, var_3_0)
	var_3_0:init()
	
	var_3_0.start_value = var_3_0.value
	var_3_0.always_visible = false
	
	if arg_3_1.skill_id then
		var_3_0.always_visible = DB("skill", arg_3_1.skill_id, "show_effect") == "y"
	end
	
	return var_3_0
end

function State.init(arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in pairs(arg_4_0.db.cs_eff) do
		if arg_4_0.giver and not arg_4_0.giver_status then
			Log.e("giver_status is nil", arg_4_0.id)
		end
		
		local var_4_0 = 0
		
		if arg_4_0.owner then
			var_4_0 = arg_4_0.owner:getShieldDecreaseRate()
		end
		
		local function var_4_1(arg_5_0, arg_5_1)
			return arg_5_0 * math.clamp(1 - arg_5_1, 0, 1)
		end
		
		if iter_4_1 == "CSP_SHIELD_CASTER_ATT" then
			local var_4_2 = arg_4_0:getPow(iter_4_0) or 1
			
			arg_4_0.value = arg_4_0.giver_status.att * var_4_1(var_4_2, var_4_0)
		end
		
		if iter_4_1 == "CSP_SHIELD_CASTER_MAXHP" then
			local var_4_3 = arg_4_0:getPow(iter_4_0) or 1
			
			arg_4_0.value = arg_4_0.giver:getMaxHP() * var_4_1(var_4_3, var_4_0)
		end
		
		if iter_4_1 == "CSP_SHIELD_TARGET_MAXHP" then
			local var_4_4 = arg_4_0:getPow(iter_4_0) or 1
			
			arg_4_0.value = arg_4_0.owner:getMaxHP() * var_4_1(var_4_4, var_4_0)
		end
		
		if iter_4_1 == "CSP_SHIELD_CASTER_DEF" then
			local var_4_5 = arg_4_0:getPow(iter_4_0) or 1
			
			arg_4_0.value = arg_4_0.giver_status.def * var_4_1(var_4_5, var_4_0)
		end
		
		if iter_4_1 == "CSP_SHIELD_CASTER_ACC" then
			local var_4_6 = arg_4_0:getPow(iter_4_0) or 1
			
			arg_4_0.value = arg_4_0.giver_status.acc * var_4_1(var_4_6, var_4_0)
		end
		
		if iter_4_1 == "CSP_SHIELD_CASTER_LEVEL" then
			local var_4_7 = arg_4_0:getPow(iter_4_0) or 1
			local var_4_8 = arg_4_0.giver:getLv()
			
			arg_4_0.value = math.min(var_4_8, GAME_STATIC_VARIABLE.monster_max_level) * var_4_1(var_4_7, var_4_0)
		end
		
		if iter_4_1 == "CSP_SHIELD_DAMAGE" then
			local var_4_9 = arg_4_0.owner.logic:pickUnits(arg_4_0.owner, ENEMY)
			local var_4_10 = 0
			
			for iter_4_2, iter_4_3 in pairs(var_4_9) do
				var_4_10 = var_4_10 + ((iter_4_3:skillDamageTag(arg_4_0.owner) or {}).damage or 0)
			end
			
			local var_4_11 = arg_4_0:getPow(iter_4_0) or 0
			
			arg_4_0.value = var_4_10 * var_4_1(var_4_11, var_4_0)
		end
		
		if iter_4_1 == "CSP_ANTI_SKILLDAMAGE" then
			arg_4_0.value = arg_4_0:getPow(iter_4_0) or 0
		end
		
		if iter_4_1 == "CSP_REF_ABILITY_UP" then
			local var_4_12 = arg_4_0:getPow(iter_4_0)
			local var_4_13 = totable(var_4_12 or {})
			local var_4_14 = var_4_13.ability
			local var_4_15 = tonumber(var_4_13.rate)
			
			arg_4_0.value = arg_4_0.giver:getStatusWithoutStates()[var_4_14] * var_4_15
		end
		
		local var_4_16, var_4_17 = arg_4_0.owner.states:getCSDecreaseEffValue(arg_4_0.id)
		
		if var_4_17 then
			arg_4_0.dec_value = var_4_16
		end
	end
	
	if arg_4_0.giver then
		local var_4_18, var_4_19 = arg_4_0.giver.states:getCSIncreaseEffValue(arg_4_0.id)
		
		if var_4_19 then
			arg_4_0.inc_value = var_4_18
		end
	end
end

function State.getGUId(arg_6_0)
	return arg_6_0.guid
end

function State.getUId(arg_7_0)
	return arg_7_0.uid
end

function State.isClassState(arg_8_0)
	return true
end

function State.getId(arg_9_0)
	return tostring(arg_9_0.db.id)
end

function State.checkRemoveWhenGiverDied(arg_10_0, arg_10_1)
	return arg_10_0.giver == arg_10_1 and (arg_10_0:checkEff("CSP_TAUNT") or arg_10_0:checkEff("CSP_GUARD"))
end

function State.checkEff(arg_11_0, arg_11_1)
	if arg_11_0.db.cs_eff[1] == arg_11_1 then
		return 1
	end
	
	if arg_11_0.db.cs_eff[2] == arg_11_1 then
		return 2
	end
	
	if arg_11_0.db.cs_eff[3] == arg_11_1 then
		return 3
	end
	
	if arg_11_0.db.cs_eff[4] == arg_11_1 then
		return 4
	end
	
	if arg_11_0.db.cs_eff[5] == arg_11_1 then
		return 5
	end
	
	if arg_11_0.db.cs_eff[6] == arg_11_1 then
		return 6
	end
	
	return false
end

function State.getEffValue(arg_12_0, arg_12_1)
	if arg_12_0.db.cs_eff[1] == arg_12_1 then
		return arg_12_0.db.cs_eff_value[1]
	end
	
	if arg_12_0.db.cs_eff[2] == arg_12_1 then
		return arg_12_0.db.cs_eff_value[2]
	end
	
	if arg_12_0.db.cs_eff[3] == arg_12_1 then
		return arg_12_0.db.cs_eff_value[3]
	end
	
	if arg_12_0.db.cs_eff[4] == arg_12_1 then
		return arg_12_0.db.cs_eff_value[4]
	end
	
	if arg_12_0.db.cs_eff[5] == arg_12_1 then
		return arg_12_0.db.cs_eff_value[5]
	end
	
	if arg_12_0.db.cs_eff[6] == arg_12_1 then
		return arg_12_0.db.cs_eff_value[6]
	end
end

function State.checkCon(arg_13_0, arg_13_1)
	for iter_13_0 = 1, 6 do
		if arg_13_0.db.cs_con[iter_13_0] == arg_13_1 then
			return true
		end
	end
end

function compact(arg_14_0)
	if not USE_STATE_COMPACT then
		return arg_14_0
	end
	
	return {
		a = arg_14_0.guid,
		b = arg_14_0.uid,
		c = arg_14_0.id,
		d = arg_14_0.lv,
		e = arg_14_0.giver_uid,
		f = arg_14_0.turn,
		g = arg_14_0.skill_id,
		h = arg_14_0.cool,
		i = arg_14_0.value,
		j = arg_14_0.start_value,
		k = arg_14_0.stack_count,
		l = arg_14_0.giver_status,
		m = arg_14_0.net_idx
	}
end

function uncompact(arg_15_0)
	if not USE_STATE_COMPACT then
		return arg_15_0
	end
	
	return {
		guid = arg_15_0.a,
		uid = arg_15_0.b,
		id = arg_15_0.c,
		lv = arg_15_0.d,
		giver_uid = arg_15_0.e,
		turn = arg_15_0.f,
		skill_id = arg_15_0.g,
		cool = arg_15_0.h,
		value = arg_15_0.i,
		start_value = arg_15_0.j,
		stack_count = arg_15_0.k,
		giver_status = arg_15_0.l,
		net_idx = arg_15_0.m
	}
end

function State.exportPureData(arg_16_0, arg_16_1, arg_16_2)
	local function var_16_0(arg_17_0)
		if arg_17_0 then
			return arg_17_0.inst.uid
		end
	end
	
	if arg_16_0:isValid() or arg_16_2 then
		local var_16_1 = {
			guid = arg_16_0.guid,
			uid = arg_16_0.uid,
			id = arg_16_0.id,
			lv = arg_16_0.lv,
			giver_uid = var_16_0(arg_16_0.giver),
			turn = arg_16_0.turn,
			skill_id = arg_16_0.skill_id,
			cool = arg_16_0.cool,
			value = arg_16_0.value,
			start_value = arg_16_0.start_value,
			stack_count = arg_16_0.stack_count,
			net_idx = arg_16_0.net_idx
		}
		
		if not arg_16_1 then
			var_16_1.giver_status = arg_16_0.giver_status
		end
		
		return compact(var_16_1)
	end
end

function State.updatePureData(arg_18_0, arg_18_1)
	local var_18_0 = uncompact(arg_18_1)
	
	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		arg_18_0[iter_18_0] = iter_18_1
	end
end

function State.restorePureData(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_2 then
		return 
	end
	
	local var_19_0 = uncompact(arg_19_2)
	
	if not var_19_0.guid or not var_19_0.uid or not var_19_0.id then
		return nil
	end
	
	var_19_0.owner = arg_19_1
	
	if var_19_0.owner.logic and var_19_0.giver_uid then
		var_19_0.giver = var_19_0.owner.logic:getUnit(var_19_0.giver_uid)
	end
	
	local var_19_1 = State:create(var_19_0)
	
	var_19_1.cool = var_19_0.cool
	var_19_1.value = var_19_0.value
	var_19_1.start_value = var_19_0.start_value
	var_19_1.stack_count = var_19_0.stack_count
	var_19_1.giver_status = var_19_0.giver_status
	var_19_1.net_idx = var_19_0.net_idx
	
	return var_19_1
end

function State.onCalcStatusStep1(arg_20_0, arg_20_1)
	if arg_20_0.db.cs_timing ~= 1 then
		return 
	end
	
	arg_20_0:_procStatusOnTargetStep1(arg_20_1)
end

function State.onCalcStatusStep_rta(arg_21_0, arg_21_1)
	if arg_21_0.db.cs_timing ~= 1 then
		return 
	end
	
	arg_21_0:_procStatusOnTargetStep_rta(arg_21_1)
end

function State.onCalcStatusStep_hp_debuff(arg_22_0, arg_22_1)
	if arg_22_0.db.cs_timing ~= 1 then
		return 
	end
	
	arg_22_0:_procStatusOnTargetStep_hp_debuff(arg_22_1)
end

function State.onCalcVariablePassiveStatus(arg_23_0, arg_23_1)
	if arg_23_0.db.cs_timing ~= 31 then
		return 
	end
	
	arg_23_0:_procVariablePassiveStatus(arg_23_1)
end

function State.onCalcStatusStep2(arg_24_0, arg_24_1)
	if arg_24_0.db.cs_timing ~= 1 then
		return 
	end
	
	arg_24_0:_procStatusOnTargetStep2(arg_24_1)
end

function State.onCalcStatusStep3(arg_25_0, arg_25_1)
	if arg_25_0.db.cs_timing ~= 1 then
		return 
	end
	
	arg_25_0:_procStatusOnTargetStep3(arg_25_1)
end

function State.onCalcStatusStep4(arg_26_0, arg_26_1)
	if arg_26_0.db.cs_timing ~= 1 then
		return 
	end
	
	arg_26_0:_procStatusOnTargetStep4(arg_26_1)
end

function State.onCalcDamage(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8)
	if arg_27_0.db.cs_timing ~= 4 then
		return 
	end
	
	if not arg_27_0:validateTimingTarget(arg_27_1) then
		return 
	end
	
	return arg_27_0:proc(arg_27_2, {
		arg_27_3
	}, true, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_1, arg_27_8)
end

function State.onDebuffExplosion(arg_28_0, arg_28_1)
	local var_28_0 = {}
	local var_28_1 = arg_28_0:getRestTurn()
	
	for iter_28_0 = 1, var_28_1 do
		arg_28_0:addPow(arg_28_1)
		
		local var_28_2 = {}
		
		if arg_28_0:checkCon("TURN_FINISHED") then
			if iter_28_0 == var_28_1 then
				var_28_2 = arg_28_0:proc()
			end
		else
			var_28_2 = arg_28_0:proc()
		end
		
		local var_28_3 = {}
		
		arg_28_0:procTurn()
		
		for iter_28_1, iter_28_2 in pairs(var_28_2 or {}) do
			if iter_28_2.type ~= "invoke_passive" then
				table.insert(var_28_3, iter_28_2)
			end
		end
		
		table.join(var_28_0, var_28_3)
	end
	
	return var_28_0
end

function State.onPreBeforeDamage(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7)
	if arg_29_0.db.cs_timing ~= 16 then
		return 
	end
	
	if not arg_29_0:validateTimingTarget(arg_29_1) then
		return 
	end
	
	return arg_29_0:proc(arg_29_2, {
		arg_29_3
	}, true, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_1)
end

function State.onBeforeDamage(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7)
	if arg_30_0.db.cs_timing ~= 7 then
		return 
	end
	
	if not arg_30_0:validateTimingTarget(arg_30_1) then
		return 
	end
	
	return arg_30_0:proc(arg_30_2, {
		arg_30_3
	}, true, arg_30_4, arg_30_5, arg_30_6, arg_30_7, arg_30_1)
end

function State.onAfterAttacked(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	if arg_31_0.db.cs_timing ~= 13 then
		return 
	end
	
	if not arg_31_0:validateTimingTarget(arg_31_1) then
		return 
	end
	
	return arg_31_0:proc(arg_31_2, {
		arg_31_3
	}, true, nil, nil, nil, arg_31_4, arg_31_1)
end

function State.onAfterAttacked_ContainDead(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	if arg_32_0.db.cs_timing ~= 26 then
		return 
	end
	
	if not arg_32_0:validateTimingTarget(arg_32_1) then
		return 
	end
	
	return arg_32_0:proc(arg_32_2, {
		arg_32_3
	}, true, nil, nil, nil, arg_32_4, arg_32_1)
end

function State.onAfterResurrect(arg_33_0, arg_33_1)
	if arg_33_0.db.cs_timing ~= 20 then
		return 
	end
	
	if not arg_33_0:validateTimingTarget(arg_33_1) then
		return 
	end
	
	return arg_33_0:proc()
end

function State.onResurrectNotify(arg_34_0, arg_34_1)
	if arg_34_0.db.cs_timing ~= 29 then
		return 
	end
	
	if not arg_34_0:validateTimingTarget(arg_34_1) then
		return 
	end
	
	return arg_34_0:proc(nil, nil, nil, nil, nil, nil, nil, arg_34_1)
end

function State.onAddUnit(arg_35_0, arg_35_1, arg_35_2)
end

function State.onRemoveUnit(arg_36_0, arg_36_1, arg_36_2)
end

function State.onBeforeModifiedDamage(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7)
	if arg_37_0.db.cs_timing ~= 15 then
		return 
	end
	
	if not arg_37_0:validateTimingTarget(arg_37_1) then
		return 
	end
	
	return arg_37_0:proc(arg_37_2, {
		arg_37_3
	}, true, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_1)
end

function State.getOnAttackCriticalDamageRatio(arg_38_0)
	if arg_38_0.db.cs_timing ~= 4 then
		return 0
	end
	
	for iter_38_0 = 1, 6 do
		if arg_38_0.db.cs_eff[iter_38_0] == 113 then
			return arg_38_0:getPow(iter_38_0)
		end
	end
	
	return 0
end

function State.onBeforeSkillDamage(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	if arg_39_0.db.cs_timing ~= 32 and arg_39_0.db.cs_timing ~= "TM_BEFORE_SKILL_DAMAGE" then
		return 
	end
	
	if not arg_39_0:validateTimingTarget(arg_39_1) then
		return 
	end
	
	return arg_39_0:proc(arg_39_2, arg_39_3, true, nil, nil, nil, arg_39_4, arg_39_1, arg_39_6)
end

function State.onAfterSkill(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5, arg_40_6)
	if DB("skill", arg_40_2, "notattack_ignore") == "y" then
		return 
	end
	
	if (not arg_40_5 or arg_40_0.db.cs_timing ~= 17) and (arg_40_5 or arg_40_0.db.cs_timing ~= 5) then
		return 
	end
	
	if not arg_40_0:validateTimingTarget(arg_40_1) then
		return 
	end
	
	return arg_40_0:proc(arg_40_2, arg_40_3, true, nil, nil, nil, arg_40_4, arg_40_1, arg_40_6)
end

function State.onAfterEffects_step_1(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6)
	if arg_41_0.db.cs_timing ~= 25 then
		return 
	end
	
	if not arg_41_0:validateTimingTarget(arg_41_1) then
		return 
	end
	
	return arg_41_0:proc(arg_41_2, arg_41_3, true, nil, nil, nil, arg_41_4, arg_41_1, arg_41_6)
end

function State.onAfterEffects_step_2(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	if (not arg_42_5 or arg_42_0.db.cs_timing ~= 33) and (arg_42_5 or arg_42_0.db.cs_timing ~= 34) then
		return 
	end
	
	if not arg_42_0:validateTimingTarget(arg_42_1) then
		return 
	end
	
	return arg_42_0:proc(arg_42_2, arg_42_3, true, nil, nil, nil, arg_42_4, arg_42_1, arg_42_6)
end

function State.onAfterEffects_step_3(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	if (not arg_43_5 or arg_43_0.db.cs_timing ~= 22) and (arg_43_5 or arg_43_0.db.cs_timing ~= 21) then
		return 
	end
	
	if not arg_43_0:validateTimingTarget(arg_43_1) then
		return 
	end
	
	return arg_43_0:proc(arg_43_2, arg_43_3, true, nil, nil, nil, arg_43_4, arg_43_1, arg_43_6)
end

function State.onAfterEffects_step_4(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5, arg_44_6)
	if (not arg_44_5 or arg_44_0.db.cs_timing ~= 35) and (arg_44_5 or arg_44_0.db.cs_timing ~= 36) then
		return 
	end
	
	if not arg_44_0:validateTimingTarget(arg_44_1) then
		return 
	end
	
	return arg_44_0:proc(arg_44_2, arg_44_3, true, nil, nil, nil, arg_44_4, arg_44_1, arg_44_6)
end

function State.onAfterEffects_step_5(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	if (not arg_45_5 or arg_45_0.db.cs_timing ~= 37) and (arg_45_5 or arg_45_0.db.cs_timing ~= 38) then
		return 
	end
	
	if not arg_45_0:validateTimingTarget(arg_45_1) then
		return 
	end
	
	return arg_45_0:proc(arg_45_2, arg_45_3, true, nil, nil, nil, arg_45_4, arg_45_1, arg_45_6)
end

function State.onSimilarDamageFinished(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6)
	if arg_46_6 then
		if arg_46_0.db.cs_timing ~= 43 then
			return 
		end
	elseif arg_46_0.db.cs_timing ~= 48 then
		return 
	end
	
	if not arg_46_0:validateTimingTarget(arg_46_1) then
		return 
	end
	
	return arg_46_0:proc(arg_46_2, arg_46_3, true, nil, nil, nil, arg_46_4, arg_46_1)
end

function State.onDamageFinished(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6)
	if arg_47_6 then
		if arg_47_0.db.cs_timing ~= 23 then
			return 
		end
	elseif arg_47_0.db.cs_timing ~= 28 then
		return 
	end
	
	if not arg_47_0:validateTimingTarget(arg_47_1) then
		return 
	end
	
	return arg_47_0:proc(arg_47_2, arg_47_3, true, nil, nil, nil, arg_47_4, arg_47_1)
end

function State.onDamageFinishedAll(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	if arg_48_0.db.cs_timing ~= 30 then
		return 
	end
	
	if not arg_48_0:validateTimingTarget(arg_48_1) then
		return 
	end
	
	return arg_48_0:proc(arg_48_2, {
		arg_48_3
	}, true, nil, nil, nil, arg_48_4, arg_48_1)
end

function State.getName(arg_49_0)
	local var_49_0 = T(arg_49_0.db.name)
	
	if arg_49_0.db.name_ignore_stack == "y" then
		return var_49_0
	end
	
	if arg_49_0.stack_count > 1 then
		var_49_0 = var_49_0 .. string.format(" x%d", arg_49_0.stack_count)
	end
	
	return var_49_0
end

function State.getRestTurn(arg_50_0)
	return arg_50_0.turn
end

function State.getId(arg_51_0)
	return arg_51_0.id
end

function State.removeState(arg_52_0, arg_52_1)
	if not arg_52_0.remove_state then
		arg_52_0.remove_state = true
		
		if arg_52_1 then
			table.insert(arg_52_1, {
				type = "remove_state",
				state = arg_52_0,
				target = arg_52_0.owner
			})
		end
	end
end

function State._removeAuraState(arg_53_0, arg_53_1)
	arg_53_1 = arg_53_1 or {}
	
	local function var_53_0(arg_54_0)
		if not arg_54_0 then
			return 
		end
		
		for iter_54_0 = 1, 6 do
			if arg_53_0.db.cs_eff[iter_54_0] == "CS_ADD" then
				local var_54_0 = arg_53_0.db.cs_eff_value[iter_54_0]
				
				Log.d(arg_53_0.name, "Remove State", var_54_0)
				arg_54_0.states:removeByCondition(arg_53_1, function(arg_55_0)
					return tostring(arg_55_0.id) == tostring(var_54_0) and (arg_55_0.giver == arg_53_0.owner or not arg_55_0.giver)
				end)
			end
		end
	end
	
	local var_53_1 = arg_53_0.db.cs_timing == 119
	local var_53_2 = arg_53_0.db.cs_timing == 119
	local var_53_3 = arg_53_0.owner.logic:pickUnits(arg_53_0.owner, FRIEND, nil, var_53_1, nil, var_53_2)
	
	for iter_53_0, iter_53_1 in pairs(var_53_3) do
		var_53_0(iter_53_1)
	end
	
	local var_53_4 = arg_53_0.owner.logic:pickUnits(arg_53_0.owner, ENEMY, nil, var_53_1, nil, var_53_2)
	
	for iter_53_2, iter_53_3 in pairs(var_53_4) do
		var_53_0(iter_53_3)
	end
	
	return arg_53_1
end

function State.removeAuraState(arg_56_0, arg_56_1, arg_56_2)
	if arg_56_2 == "before" then
		if arg_56_0.db.cs_timing ~= 119 then
			return 
		end
	elseif arg_56_2 == "after" then
		if arg_56_0.db.cs_timing ~= 19 then
			return 
		end
	elseif arg_56_0.db.cs_timing ~= 19 and arg_56_0.db.cs_timing ~= 119 then
		return 
	end
	
	arg_56_1 = arg_56_1 or {}
	
	arg_56_0:_removeAuraState(arg_56_1)
end

function State.removeAuraStateBeforeDead(arg_57_0, arg_57_1)
	if arg_57_0.db.cs_timing ~= 119 then
		return 
	end
	
	arg_57_1 = arg_57_1 or {}
	
	arg_57_0:_removeAuraState(arg_57_1)
end

function State.isValid(arg_58_0)
	return not arg_58_0.invalid
end

function State.isInvalid(arg_59_0)
	return arg_59_0.invalid
end

function State.setValid(arg_60_0, arg_60_1)
	arg_60_0.invalid = not arg_60_1
end

function State.isPreproc(arg_61_0)
	return arg_61_0.db.cs_turn ~= 0 and not arg_61_0:isPassive() and arg_61_0.db.cs_preproc == "y"
end

function State.isBarrier(arg_62_0)
	return arg_62_0:checkEff("CSP_SHIELD_CASTER_ATT") or arg_62_0:checkEff("CSP_SHIELD_CASTER_DEF") or arg_62_0:checkEff("CSP_SHIELD_CASTER_MAXHP") or arg_62_0:checkEff("CSP_SHIELD_TARGET_MAXHP") or arg_62_0:checkEff("CSP_SHIELD_DAMAGE") or arg_62_0:checkEff("CSP_SHIELD_CASTER_ACC") or arg_62_0:checkEff("CSP_SHIELD_CASTER_LEVEL")
end

function State.isAntiSkillDamage(arg_63_0)
	return arg_63_0:checkEff("CSP_ANTI_SKILLDAMAGE")
end

function State.isModelChange(arg_64_0)
	return arg_64_0:checkEff("CSP_MODELCHANGE")
end

function State.isPassive(arg_65_0)
	return arg_65_0.db.cs_type == "passive"
end

function State.isType(arg_66_0, arg_66_1)
	return arg_66_0.db.cs_type == arg_66_1
end

function State.isGroup(arg_67_0, arg_67_1)
	if not arg_67_0.db.cs_group or not arg_67_1 then
		return false
	end
	
	if tostring(arg_67_0.db.cs_group) == tostring(arg_67_1) then
		return true
	end
	
	return false
end

function State.isGood(arg_68_0)
	return arg_68_0.db.cs_good
end

function State.isPassiveBlocked(arg_69_0)
	if not arg_69_0.owner then
		return false
	end
	
	return arg_69_0.db.cs_passiveblock == "y" and arg_69_0.owner:isPassiveBlock()
end

function StateList.getImmuneStateList(arg_70_0, arg_70_1)
	local var_70_0 = {}
	local var_70_1 = arg_70_0:findAllEffValues("CSP_IMMUNE_CS", arg_70_1)
	
	for iter_70_0, iter_70_1 in pairs(var_70_1) do
		local var_70_2 = string.split(iter_70_1, ",")
		
		for iter_70_2, iter_70_3 in pairs(var_70_2) do
			if not table.find(var_70_0, iter_70_3) then
				table.push(var_70_0, iter_70_3)
			end
		end
	end
	
	return var_70_0
end

function StateList.getImmuneEffList(arg_71_0)
	local var_71_0 = {}
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0.List) do
		for iter_71_2 = 1, 6 do
			if iter_71_1.db.cs_eff[iter_71_2] == "CSP_IMMUNE" then
				local var_71_1 = string.split(iter_71_1.db.cs_eff_value[iter_71_2] or "", ",")
				
				for iter_71_3, iter_71_4 in pairs(var_71_1) do
					if not table.find(var_71_0, iter_71_4) then
						table.push(var_71_0, {
							eff = iter_71_4,
							cs = iter_71_1
						})
					end
				end
			end
		end
	end
	
	return var_71_0
end

function StateList.getDebuffBlockList_CS(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_1 or {}
	local var_72_1 = arg_72_0:findAllEffValues("CSP_DEBUFF_BLOCK", arg_72_2)
	
	for iter_72_0, iter_72_1 in pairs(var_72_1) do
		local var_72_2, var_72_3 = DB("skill_immune_group", iter_72_1, {
			"cs",
			"hide"
		})
		local var_72_4 = string.split(var_72_2 or "", ",")
		local var_72_5 = string.split(var_72_3 or "", ",")
		
		for iter_72_2, iter_72_3 in pairs(var_72_4) do
			if not table.find(var_72_0, iter_72_3) and not table.isInclude(var_72_5, iter_72_3) then
				table.push(var_72_0, iter_72_3)
			end
		end
	end
	
	return var_72_0
end

function StateList.getDebuffBlockList_Eff(arg_73_0, arg_73_1)
	local var_73_0 = arg_73_1 or {}
	
	for iter_73_0, iter_73_1 in pairs(arg_73_0.List) do
		for iter_73_2 = 1, 6 do
			local var_73_4
			
			if iter_73_1.db.cs_eff[iter_73_2] == "CSP_DEBUFF_BLOCK" then
				local var_73_1, var_73_2 = DB("skill_immune_group", iter_73_1.db.cs_eff_value[iter_73_2], {
					"eff",
					"hide"
				})
				local var_73_3 = string.split(var_73_1 or "", ",")
				
				var_73_4 = string.split(var_73_2 or "", ",")
				
				for iter_73_3, iter_73_4 in pairs(var_73_3) do
					local var_73_5 = false
					
					for iter_73_5, iter_73_6 in pairs(var_73_0) do
						if iter_73_6.eff == iter_73_4 then
							var_73_5 = true
							
							break
						end
					end
					
					if not var_73_5 then
						table.push(var_73_0, {
							eff = iter_73_4,
							cs = iter_73_1,
							hide = table.isInclude(var_73_4, iter_73_4)
						})
					end
				end
			end
		end
	end
	
	return var_73_0
end

function State.isBlock_Eff(arg_74_0, arg_74_1)
	for iter_74_0 = 1, 6 do
		if arg_74_0.db.cs_eff[iter_74_0] == "CSP_DEBUFF_BLOCK" then
			local var_74_0 = DB("skill_immune_group", arg_74_0.db.cs_eff_value[iter_74_0], "eff")
			local var_74_1 = string.split(var_74_0 or "", ",")
			
			for iter_74_1, iter_74_2 in pairs(var_74_1) do
				if iter_74_2 == arg_74_1 then
					return true, arg_74_0.db.cs_immune_hide, arg_74_0.db.system_text_hide
				end
			end
		end
	end
end

function State.isImmuneEff(arg_75_0, arg_75_1)
	for iter_75_0 = 1, 6 do
		if arg_75_0.db.cs_eff[iter_75_0] == "CSP_IMMUNE" then
			local var_75_0 = string.split(arg_75_0.db.cs_eff_value[iter_75_0] or "", ",")
			
			for iter_75_1, iter_75_2 in pairs(var_75_0) do
				if iter_75_2 == arg_75_1 then
					return true, arg_75_0.db.cs_immune_hide, arg_75_0.db.system_text_hide
				end
			end
		end
	end
end

function State.canRemove(arg_76_0)
	return arg_76_0.db.cs_remove == "y"
end

function State.getInvokeStackCount(arg_77_0)
	return arg_77_0.invoke_stack or 0
end

function State.setInvokeStackCount(arg_78_0, arg_78_1)
	arg_78_0.invoke_stack = arg_78_0.invoke_stack or 0
	arg_78_0.invoke_stack = arg_78_0.invoke_stack + (arg_78_1 or 1)
end

function State.validateTimingTarget(arg_79_0, arg_79_1)
	arg_79_0.cs_timing_targets = arg_79_0.cs_timing_targets or {}
	
	local var_79_0 = false
	
	if arg_79_0.db.cs_timing_target == 1 then
		var_79_0 = true
	elseif arg_79_0.db.cs_timing_target == 2 then
		if arg_79_0.owner == arg_79_1 then
			var_79_0 = true
		end
	elseif arg_79_0.db.cs_timing_target == 3 then
		if arg_79_0.owner.inst.ally == arg_79_1.inst.ally then
			var_79_0 = true
		end
	elseif arg_79_0.db.cs_timing_target == 4 then
		if arg_79_0.owner.inst.ally ~= arg_79_1.inst.ally then
			var_79_0 = true
		end
	elseif arg_79_0.db.cs_timing_target == 5 then
		if arg_79_0.owner ~= arg_79_1 and arg_79_0.owner.inst.ally == arg_79_1.inst.ally then
			var_79_0 = true
		end
	elseif arg_79_0.db.cs_timing_target == 6 then
		var_79_0 = true
	elseif arg_79_0.db.cs_timing_target >= 31 or arg_79_0.db.cs_timing_target <= 34 then
		if arg_79_1:getAlly() ~= arg_79_0.owner:getAlly() then
			return false
		end
		
		if to_n(arg_79_1.inst.pos) == arg_79_0.db.cs_timing_target - 30 then
			var_79_0 = true
		end
	end
	
	if var_79_0 and arg_79_1 then
		arg_79_0.cs_timing_targets[arg_79_1] = true
	end
	
	return var_79_0
end

function State.onEnterMap(arg_80_0, arg_80_1)
	if arg_80_0:isInvalid() then
		return 
	end
	
	if arg_80_0.db.cs_timing ~= 24 then
		return 
	end
	
	if not arg_80_0:validateTimingTarget(arg_80_1) then
		return 
	end
	
	return arg_80_0:proc()
end

function State.onStartStage(arg_81_0, arg_81_1, arg_81_2)
	if arg_81_0:isInvalid() then
		return 
	end
	
	local var_81_0
	local var_81_1 = arg_81_2 == "before" and 59 or 9
	
	if arg_81_0.db.cs_timing ~= var_81_1 then
		return 
	end
	
	if not arg_81_0:validateTimingTarget(arg_81_1) then
		return 
	end
	
	return arg_81_0:proc()
end

function State.onStartTurn(arg_82_0, arg_82_1, arg_82_2)
	if arg_82_0:isInvalid() then
		return 
	end
	
	local var_82_0
	local var_82_1 = arg_82_2 == "before" and 47 or arg_82_2 == "after" and 2 or 27
	
	if arg_82_0.db.cs_timing ~= var_82_1 then
		return 
	end
	
	if not arg_82_0:validateTimingTarget(arg_82_1) then
		return 
	end
	
	return arg_82_0:proc(nil, nil, nil, nil, nil, nil, nil, arg_82_1)
end

function State.onEndTurn(arg_83_0, arg_83_1)
	local var_83_0
	
	if arg_83_0:isInvalid() then
		return 
	end
	
	if arg_83_0.db.cs_timing == 3 and arg_83_0:validateTimingTarget(arg_83_1) then
		var_83_0 = arg_83_0:proc()
	end
	
	return var_83_0
end

function State.onTurnEndAfter(arg_84_0, arg_84_1)
	local var_84_0
	
	if arg_84_0:isInvalid() then
		return 
	end
	
	if arg_84_0.db.cs_timing == 103 and arg_84_0:validateTimingTarget(arg_84_1) then
		var_84_0 = arg_84_0:proc()
	end
	
	return var_84_0
end

function State.onBeforeDead(arg_85_0, arg_85_1, arg_85_2)
	if arg_85_0:isInvalid() then
		return 
	end
	
	if arg_85_0.db.cs_timing ~= 14 then
		return 
	end
	
	if not arg_85_0:validateTimingTarget(arg_85_1) then
		return 
	end
	
	return arg_85_0:proc(nil, {
		arg_85_0
	}, nil, nil, nil, nil, arg_85_2, arg_85_1)
end

function State.onSomeoneDead(arg_86_0, arg_86_1, arg_86_2)
	if arg_86_0:isInvalid() then
		return 
	end
	
	if arg_86_2 == "after" then
		if arg_86_0.db.cs_timing ~= 110 then
			return 
		end
	elseif arg_86_0.db.cs_timing ~= 10 then
		return 
	end
	
	if arg_86_1 == arg_86_0.owner then
		return 
	end
	
	if not arg_86_0:validateTimingTarget(arg_86_1) then
		return 
	end
	
	return arg_86_0:proc(nil, {
		arg_86_0
	}, nil, nil, nil, nil, nil, arg_86_1)
end

function State.onToggle(arg_87_0, arg_87_1, arg_87_2)
	if arg_87_0:isInvalid() then
		return 
	end
	
	if arg_87_0.db.cs_timing ~= 12 then
		return 
	end
	
	if not arg_87_0:validateTimingTarget(arg_87_1) then
		return 
	end
	
	return arg_87_0:procToggleOnTarget(arg_87_2)
end

function State.onConcertrateEnd(arg_88_0)
	if arg_88_0:isInvalid() then
		return 
	end
	
	if arg_88_0.db.cs_timing ~= 18 then
		return 
	end
	
	return arg_88_0:proc()
end

function State.filterLeaderSkillTarget(arg_89_0, arg_89_1)
	local var_89_0 = {}
	
	if arg_89_0.db.cs_target == 6 then
		var_89_0 = arg_89_0.owner.logic:pickUnits(arg_89_0.owner, FRIEND, nil, nil, "fire")
	elseif arg_89_0.db.cs_target == 7 then
		var_89_0 = arg_89_0.owner.logic:pickUnits(arg_89_0.owner, FRIEND, nil, nil, "ice")
	elseif arg_89_0.db.cs_target == 8 then
		var_89_0 = arg_89_0.owner.logic:pickUnits(arg_89_0.owner, FRIEND, nil, nil, "wind")
	elseif arg_89_0.db.cs_target == 9 then
		var_89_0 = arg_89_0.owner.logic:pickUnits(arg_89_0.owner, FRIEND, nil, nil, "light")
	elseif arg_89_0.db.cs_target == 10 then
		var_89_0 = arg_89_0.owner.logic:pickUnits(arg_89_0.owner, FRIEND, nil, nil, "dark")
	else
		var_89_0 = arg_89_1
	end
	
	return var_89_0
end

function State.checkActivateGroup(arg_90_0)
	if not arg_90_0.db.cs_activategroup then
		return true
	end
	
	local var_90_0 = arg_90_0.db.cs_activategroup
	local var_90_1 = to_n(arg_90_0.db.cs_activaterank)
	local var_90_2 = arg_90_0.owner.inst.pos
	local var_90_3 = arg_90_0.owner.logic:pickUnits(arg_90_0.owner, FRIEND, arg_90_0.owner)
	
	for iter_90_0, iter_90_1 in pairs(var_90_3) do
		local var_90_4
		
		if not iter_90_1:isDead() then
			var_90_4 = iter_90_1.inst.pos
			
			for iter_90_2, iter_90_3 in pairs(iter_90_1.states.List) do
				if iter_90_3.db.cs_activategroup == var_90_0 then
					local var_90_5 = to_n(iter_90_3.db.cs_activaterank)
					
					if var_90_1 < var_90_5 then
						return false
					end
					
					if var_90_5 == var_90_1 and var_90_4 < var_90_2 then
						return false
					end
				end
			end
		end
	end
	
	return true
end

function State.proc(arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4, arg_91_5, arg_91_6, arg_91_7, arg_91_8, arg_91_9)
	if not arg_91_0:checkActivateGroup() then
		return 
	end
	
	local var_91_0 = arg_91_0.cs_timing_targets
	
	arg_91_0.cs_timing_targets = {}
	
	if arg_91_0:isInvalid() then
		return 
	end
	
	if arg_91_0.cool > 0 then
		return 
	end
	
	local var_91_1 = {}
	local var_91_2 = {
		arg_91_8
	}
	local var_91_3 = arg_91_0.db.cs_target_value
	
	if type(arg_91_0.db.cs_target) == "number" then
		if arg_91_0.db.cs_target == 1 then
			var_91_1 = {
				arg_91_0.owner
			}
		elseif arg_91_0.db.cs_target == 3 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND)
		elseif arg_91_0.db.cs_target == 6 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, nil, "fire")
		elseif arg_91_0.db.cs_target == 7 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, nil, "ice")
		elseif arg_91_0.db.cs_target == 8 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, nil, "wind")
		elseif arg_91_0.db.cs_target == 9 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, nil, "light")
		elseif arg_91_0.db.cs_target == 10 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, nil, "dark")
		elseif arg_91_0.db.cs_target == 31 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, nil, "fire")
		elseif arg_91_0.db.cs_target == 32 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, nil, "ice")
		elseif arg_91_0.db.cs_target == 33 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, nil, "wind")
		elseif arg_91_0.db.cs_target == 34 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, nil, "light")
		elseif arg_91_0.db.cs_target == 35 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, nil, "dark")
		elseif arg_91_0.db.cs_target == 37 then
			local var_91_4 = arg_91_0.owner.logic:getTurnOwner()
			
			if var_91_4 ~= arg_91_0.owner then
				var_91_1 = {
					var_91_4
				}
			end
		elseif arg_91_0.db.cs_target == 13 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY)
		elseif arg_91_0.db.cs_target == 14 then
			if arg_91_7 == nil then
				Log.e("State", "attacker must be, when cs_target is 7", arg_91_1, arg_91_0.db.id)
			end
			
			var_91_1 = {
				arg_91_7
			}
		elseif arg_91_0.db.cs_target == 15 then
			var_91_1 = {}
			
			for iter_91_0, iter_91_1 in pairs(var_91_0) do
				table.push(var_91_1, iter_91_0)
			end
		elseif arg_91_0.db.cs_target == 16 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, true, nil, true)
		elseif arg_91_0.db.cs_target == 17 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, true, nil, true)
		elseif arg_91_0.db.cs_target == 18 then
			var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, 1, arg_91_0.owner)
		elseif arg_91_0.db.cs_target == 19 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, arg_91_0.owner)
		elseif arg_91_0.db.cs_target >= 21 and arg_91_0.db.cs_target <= 26 then
			if arg_91_0.db.cs_target == 21 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, 1)
			elseif arg_91_0.db.cs_target == 22 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, 2)
			elseif arg_91_0.db.cs_target == 23 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, 3)
			elseif arg_91_0.db.cs_target == 24 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, ENEMY, 1)
			elseif arg_91_0.db.cs_target == 25 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, ENEMY, 2)
			elseif arg_91_0.db.cs_target == 26 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, ENEMY, 3)
			end
		elseif arg_91_0.db.cs_target == 95 then
			var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, ENEMY, 1)
		elseif arg_91_0.db.cs_target == 43 then
			local var_91_5 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY)
			local var_91_6
			local var_91_7 = 0
			
			for iter_91_2, iter_91_3 in pairs(var_91_5) do
				if var_91_7 < iter_91_3.inst.hp then
					var_91_7 = iter_91_3.inst.hp
					var_91_6 = iter_91_3
				end
			end
			
			var_91_1 = {
				var_91_6
			}
		elseif arg_91_0.db.cs_target >= 40 and arg_91_0.db.cs_target <= 46 then
			if arg_91_0.db.cs_target == 40 or arg_91_0.db.cs_target == 44 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND)
			elseif arg_91_0.db.cs_target == 41 or arg_91_0.db.cs_target == 45 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, ENEMY)
			elseif arg_91_0.db.cs_target == 42 or arg_91_0.db.cs_target == 46 then
				var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, nil, arg_91_0.owner)
			end
			
			local var_91_8 = arg_91_0.db.cs_target_value
			
			if not var_91_8 then
				Log.e("state_proc", "현재 생명력 상황이 가장 나쁜 아군:", arg_91_0.db.cs_target)
			end
			
			while var_91_8 < #var_91_1 do
				local var_91_9 = 0
				local var_91_10
				
				for iter_91_4, iter_91_5 in pairs(var_91_1) do
					local var_91_11 = iter_91_5:getHPRatio()
					
					if var_91_9 < var_91_11 then
						var_91_9 = var_91_11
						var_91_10 = iter_91_4
					end
				end
				
				table.remove(var_91_1, var_91_10)
			end
		elseif arg_91_0.db.cs_target >= 51 and arg_91_0.db.cs_target < 54 then
			local var_91_12 = arg_91_0.db.cs_target - 50
			
			var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, var_91_12, nil, nil, function(arg_92_0)
				return arg_92_0.states:getTypeCount("debuff") > 0
			end)
			
			for iter_91_6, iter_91_7 in pairs(var_91_1) do
				Log.d("state_debuf", "악화효과에 걸린 아군:", iter_91_7.db.name)
			end
		elseif arg_91_0.db.cs_target >= 56 and arg_91_0.db.cs_target <= 60 then
			local var_91_13 = ({
				"fire",
				"ice",
				"wind",
				"light",
				"dark"
			})[arg_91_0.db.cs_target - 55]
			
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY)
			
			for iter_91_8 = #var_91_1, 1, -1 do
				if var_91_1[iter_91_8].db.color == var_91_13 then
					table.remove(var_91_1, iter_91_8)
				end
			end
		elseif arg_91_0.db.cs_target >= 61 and arg_91_0.db.cs_target < 63 then
			var_91_1 = arg_91_0.owner.logic:pickEnemies(arg_91_0.owner)
			
			table.sort(var_91_1, function(arg_93_0, arg_93_1)
				return arg_93_0.inst.elapsed_ut > arg_93_1.inst.elapsed_ut
			end)
			
			for iter_91_9 = arg_91_0.db.cs_target - 60 + 1, #var_91_1 do
				var_91_1[iter_91_9] = nil
			end
		elseif arg_91_0.db.cs_target >= 71 and arg_91_0.db.cs_target <= 78 then
			var_91_1 = arg_91_0.owner.logic:pickUnitsByStatus(arg_91_0.owner, FRIEND, arg_91_0.db.cs_target, 1)
		elseif arg_91_0.db.cs_target >= 81 and arg_91_0.db.cs_target <= 88 then
			var_91_1 = arg_91_0.owner.logic:pickUnitsByStatus(arg_91_0.owner, ENEMY, arg_91_0.db.cs_target, 1)
		elseif arg_91_0.db.cs_target >= 171 and arg_91_0.db.cs_target <= 178 then
			var_91_1 = arg_91_0.owner.logic:pickUnitsByStatus(arg_91_0.owner, FRIEND, arg_91_0.db.cs_target, 1, arg_91_0.owner)
		elseif arg_91_0.db.cs_target == 89 then
			local var_91_14 = arg_91_0.owner.logic:pickEnemies(arg_91_0.owner, nil, true, nil, true)
			
			var_91_1 = {}
			
			for iter_91_10, iter_91_11 in pairs(var_91_14) do
				if iter_91_11 and iter_91_11:isDead() then
					table.insert(var_91_1, iter_91_11)
				end
			end
		elseif arg_91_0.db.cs_target >= 101 and arg_91_0.db.cs_target <= 104 then
			local var_91_15 = arg_91_0.db.cs_target - 100
			local var_91_16 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND)
			
			for iter_91_12, iter_91_13 in pairs(var_91_16) do
				if not iter_91_13:isDead() and to_n(iter_91_13.inst.pos) == var_91_15 then
					var_91_1 = {
						iter_91_13
					}
					
					break
				end
			end
			
			var_91_1 = var_91_1 or {}
		elseif arg_91_0.db.cs_target == 105 then
			var_91_1 = {}
			
			local var_91_17 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND)
			
			for iter_91_14, iter_91_15 in pairs(var_91_17) do
				if not iter_91_15:isEmptyHP() then
					table.insert(var_91_1, iter_91_15)
				end
			end
		elseif arg_91_0.db.cs_target == 114 then
			var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND)
			
			for iter_91_16 = #var_91_1, 1, -1 do
				if var_91_1[iter_91_16] ~= arg_91_0.owner and to_n(var_91_1[iter_91_16].inst.pos) ~= 4 then
					table.remove(var_91_1, iter_91_16)
				end
			end
		elseif arg_91_0.db.cs_target == 151 then
			local var_91_18 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, arg_91_0.owner)
			local var_91_19 = {}
			
			for iter_91_17, iter_91_18 in pairs(var_91_18) do
				if iter_91_18.states:getTypeCount("debuff") > 0 then
					table.insert(var_91_19, iter_91_18)
				end
			end
			
			local var_91_20 = arg_91_0.owner.logic.random:get(1, #var_91_19)
			
			var_91_1 = {
				var_91_19[var_91_20]
			}
		else
			var_91_1 = arg_91_2
		end
	elseif arg_91_0.db.cs_target == "ALLY_ATTRIBUTE" then
		if not var_91_3 then
			Log.e("State", "invalid cs_target_value", arg_91_0.db.cs_target, var_91_3)
		end
		
		var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, nil, nil, var_91_3)
	elseif arg_91_0.db.cs_target == "ENEMY_ATTRIBUTE" then
		if not var_91_3 then
			Log.e("State", "invalid cs_target_value", arg_91_0.db.cs_target, var_91_3)
		end
		
		var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY, nil, nil, var_91_3)
	elseif arg_91_0.db.cs_target == "ALLY_EXCEPT_SELF_STATUS_HIGH" then
		local var_91_21 = {}
		local var_91_22 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, arg_91_0.owner)
		
		for iter_91_19, iter_91_20 in pairs(var_91_22) do
			if table.empty(var_91_21) then
				table.insert(var_91_21, iter_91_20)
			else
				local var_91_23 = var_91_21[1].status[var_91_3]
				
				if var_91_23 <= iter_91_20.status[var_91_3] then
					if var_91_23 < iter_91_20.status[var_91_3] then
						var_91_21 = {}
					end
					
					table.insert(var_91_21, iter_91_20)
				end
			end
		end
		
		local var_91_24 = arg_91_0.owner.logic.random:get(1, #var_91_21)
		
		var_91_1 = {
			var_91_21[var_91_24]
		}
	elseif arg_91_0.db.cs_target == "ENEMY_ALL_WITHOUT_BOSS" then
		var_91_1 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, ENEMY)
		
		for iter_91_21 = #var_91_1, 1, -1 do
			if table.isInclude({
				"elite",
				"subboss",
				"boss"
			}, var_91_1[iter_91_21].db.tier) then
				table.remove(var_91_1, iter_91_21)
			end
		end
	elseif arg_91_0.db.cs_target == "ALLY_AB_HIGHEST" then
		local var_91_25 = {}
		local var_91_26 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, arg_91_0.owner)
		
		for iter_91_22, iter_91_23 in pairs(var_91_26) do
			if table.empty(var_91_25) then
				table.insert(var_91_25, iter_91_23)
			else
				local var_91_27 = var_91_25[1].inst.elapsed_ut
				
				if var_91_27 <= iter_91_23.inst.elapsed_ut then
					if var_91_27 < iter_91_23.inst.elapsed_ut then
						var_91_25 = {}
					end
					
					table.insert(var_91_25, iter_91_23)
				end
			end
		end
		
		local var_91_28 = arg_91_0.owner.logic.random:get(1, #var_91_25)
		
		var_91_1 = {
			var_91_25[var_91_28]
		}
	elseif arg_91_0.db.cs_target == "ALL_DEAD_ALLIES" then
		local var_91_29 = arg_91_0.owner.logic:pickUnits(arg_91_0.owner, FRIEND, arg_91_0.owner, true, nil, true)
		
		var_91_1 = {}
		
		for iter_91_24, iter_91_25 in pairs(var_91_29) do
			if iter_91_25 and iter_91_25:isDead() then
				table.insert(var_91_1, iter_91_25)
			end
		end
	elseif arg_91_0.db.cs_target == "RANDOM_DEAD_ALLY" then
		var_91_1 = arg_91_0.owner.logic:pickDeadUnits(arg_91_0.owner, FRIEND, nil, arg_91_0.owner)
		
		local var_91_30 = tonumber(var_91_3) or 1
		
		while var_91_30 < #var_91_1 do
			table.remove(var_91_1, random:get(1, #var_91_1))
		end
	elseif arg_91_0.db.cs_target == "ENEMY_ALL_LESS_ATT" then
		var_91_1 = arg_91_0.owner.logic:pickEnemies(arg_91_0.owner)
		
		for iter_91_26 = #var_91_1, 1, -1 do
			if arg_91_0.owner.status.att <= var_91_1[iter_91_26].status.att then
				table.remove(var_91_1, iter_91_26)
			end
		end
	elseif arg_91_0.db.cs_target == "ENEMY_ALL_LESS_ATT_NOT" then
		var_91_1 = arg_91_0.owner.logic:pickEnemies(arg_91_0.owner)
		
		for iter_91_27 = #var_91_1, 1, -1 do
			if arg_91_0.owner.status.att > var_91_1[iter_91_27].status.att then
				table.remove(var_91_1, iter_91_27)
			end
		end
	elseif arg_91_0.db.cs_target == "ALLY_RANDOM_2_WITHOUT_SELF" then
		var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, 2, arg_91_0.owner)
	elseif arg_91_0.db.cs_target == "ALLY_RANDOM_3_WITHOUT_SELF" then
		var_91_1 = arg_91_0.owner.logic:pickRandomUnits(arg_91_0.owner, FRIEND, 3, arg_91_0.owner)
	else
		var_91_1 = arg_91_2
	end
	
	local var_91_31 = {}
	
	for iter_91_28, iter_91_29 in pairs(var_91_0 or {}) do
		table.push(var_91_31, iter_91_28)
	end
	
	local var_91_32, var_91_33 = arg_91_0:procOnTarget(arg_91_1, var_91_1, arg_91_3, arg_91_4, arg_91_5, arg_91_6, arg_91_7, var_91_2, var_91_31, arg_91_9)
	
	if not var_91_33 and #var_91_32 > 0 and arg_91_0.max_cool > arg_91_0.cool then
		arg_91_0.cool = arg_91_0.max_cool
	end
	
	return var_91_32
end

function State.procTurn(arg_94_0)
	arg_94_0.turn = arg_94_0.turn - 1
end

function State.checkStateCondition(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8)
	if arg_95_0.db.cs_unique and arg_95_0.db.cs_timing then
		local var_95_0 = arg_95_0.owner.logic:makeUniqueFlagKey(arg_95_0.db.cs_unique, arg_95_0.db.cs_timing)
		
		if not arg_95_0.owner.logic:checkUniqueFlag(var_95_0, arg_95_2) then
			return false
		end
	end
	
	for iter_95_0 = 1, 4 do
		local var_95_1 = arg_95_0.db.cs_con[iter_95_0]
		local var_95_2 = arg_95_0.db.cs_con_value[iter_95_0]
		local var_95_3 = arg_95_0.db.cs_con_target[iter_95_0]
		
		if var_95_1 and not SkillProc.checkStateCondition(arg_95_0, arg_95_1, var_95_1, var_95_3, var_95_2, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8) then
			return false
		end
	end
	
	if not table.find({
		1,
		12
	}, arg_95_0.db.cs_timing) then
		local var_95_4 = arg_95_0.owner.logic.random:get()
		local var_95_5 = arg_95_0.db.cs_con_rate + to_n(arg_95_0.db.cs_con_rategrow) * (arg_95_0.lv - 1)
		
		if not PRODUCTION_MODE and var_95_5 > 0 then
			if arg_95_0.giver then
				var_95_5 = arg_95_0.giver:getSkillRate() or var_95_5
			else
				var_95_5 = arg_95_0.owner:getSkillRate() or var_95_5
			end
		end
		
		if var_95_5 < var_95_4 then
			return false
		end
		
		local var_95_6 = true
		local var_95_7
		
		for iter_95_1 = 1, 6 do
			local var_95_8 = arg_95_0.db.cs_eff[iter_95_1]
			
			if var_95_8 then
				if SkillProc.checkResistDB(var_95_8) or arg_95_0.db.cs_eff_resist_ignore == "y" then
					if not var_95_7 then
						var_95_7 = true
					end
				else
					var_95_7 = false
					
					break
				end
			end
		end
		
		if var_95_7 then
			var_95_6 = false
		end
		
		if var_95_6 then
			local var_95_9 = true
			local var_95_10 = 0
			
			if arg_95_0.owner and arg_95_0.owner.inst.ally ~= arg_95_2.inst.ally and arg_95_0.db.cs_target == 14 then
				var_95_10 = arg_95_0.owner.status.acc
			elseif arg_95_6 then
				var_95_10 = arg_95_6.status.acc
			elseif arg_95_0.owner and arg_95_0.owner.inst.ally ~= arg_95_2.inst.ally then
				var_95_10 = arg_95_0.owner.status.acc
			end
			
			local var_95_11 = 1 + var_95_10 - arg_95_2.status.res
			local var_95_12 = 0.85
			
			if DEBUG.ABSOLUTE_RESIST_VALUE then
				var_95_12 = math.clamp(1 - DEBUG.ABSOLUTE_RESIST_VALUE, 0, 1)
			end
			
			local var_95_13, var_95_14 = math.clamp(var_95_11, 0, var_95_12), arg_95_0.owner.logic.random:get()
			
			if not (var_95_14 < var_95_13) then
				Log.d("State", "!!저항으로 cs스킬효과 피함, target:", arg_95_2.db.name, var_95_14 < var_95_13, var_95_14, var_95_13, arg_95_0.db.cs_con_rate, arg_95_2.status.res)
				
				return false, true
			end
		end
	end
	
	for iter_95_2, iter_95_3 in pairs(arg_95_0.db.cs_con) do
		if iter_95_3 == "COUNT_LIMIT" or iter_95_3 == "COUNT_LIMIT_WAVE" then
			arg_95_2:setInvokeStackCount(arg_95_0.id, 1)
		end
		
		if iter_95_3 == "COUNT_LIMIT_TARGET_OTHER" then
			arg_95_0.owner.logic:setInvokeStackCount(arg_95_0.id, 1)
		end
	end
	
	return true
end

function State.procOnTarget(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5, arg_96_6, arg_96_7, arg_96_8, arg_96_9, arg_96_10)
	if not arg_96_2 then
		print("ERROR  State.procOnTarget", arg_96_0.db.cs_timing, arg_96_0.db.cs_target, arg_96_0.db.id)
		
		return {}
	end
	
	DEBUG_INFO.cur_state = {
		state = arg_96_0,
		attacker = arg_96_7,
		eff_target = arg_96_2
	}
	
	local var_96_0 = false
	local var_96_1 = {}
	
	arg_96_0.turn_proc_count = 0
	
	local var_96_2 = false
	
	if arg_96_0:isPassiveBlocked() then
		table.insert(var_96_1, {
			type = "passive_block",
			target = arg_96_0.owner
		})
		
		var_96_2 = true
	else
		for iter_96_0, iter_96_1 in pairs(arg_96_2) do
			local var_96_3, var_96_4 = arg_96_0:checkStateCondition(arg_96_1, iter_96_1, arg_96_4, arg_96_5, arg_96_6, arg_96_7, arg_96_8, arg_96_10)
			
			if var_96_3 then
				local var_96_5 = {}
				local var_96_6 = arg_96_0:_procOnTarget(var_96_5, iter_96_1, arg_96_7, arg_96_1, arg_96_9)
				
				table.join(var_96_1, var_96_5)
				
				var_96_0 = var_96_0 or var_96_6
				
				if arg_96_0:isInvoker() then
					table.insert(var_96_1, 1, {
						type = "invoke_state_effect",
						target = iter_96_1,
						state = arg_96_0,
						effect = arg_96_0.db.cs_activate_effect,
						target_bone = arg_96_0.db.cs_activate_eff_bone,
						scale = arg_96_0.db.cs_activate_eff_scale
					})
				end
			end
			
			local var_96_7 = true
			
			for iter_96_2 = 1, 6 do
				local var_96_8 = arg_96_0.db.cs_eff[iter_96_2]
				
				if not CS_Util.isApplyStateOnlyHeroByEff(var_96_8, arg_96_0.db.cs_eff_value[iter_96_2] or 0, iter_96_1) then
					var_96_7 = false
				end
			end
			
			if var_96_4 and var_96_7 then
				arg_96_0.turn_proc_count = arg_96_0.turn_proc_count + 1
				
				table.insert(var_96_1, {
					type = "resist_state",
					target = iter_96_1
				})
			end
		end
		
		if table.empty(arg_96_2) and arg_96_0.db.cs_regardless_of_target == "y" then
			arg_96_0.turn_proc_count = arg_96_0.turn_proc_count + 1
		end
		
		if var_96_0 and arg_96_0:isInvoker() and arg_96_0.db.name then
			table.insert(var_96_1, 1, {
				type = "invoke_passive",
				target = arg_96_0.owner,
				state = arg_96_0,
				text = arg_96_0.db.name
			})
		end
		
		if arg_96_0.turn_proc_count > 0 and arg_96_0.db.cs_eliminate then
			Log.d("state", "cs_eliminate 지속효과 풀림")
			arg_96_0:setValid(false)
			
			if arg_96_0.owner.states:canRemoveStateInfo(arg_96_0) then
				arg_96_0:removeState(var_96_1)
				
				arg_96_0.owner.states.counter = arg_96_0.owner.states.counter + 1
			end
		end
		
		if #var_96_1 > 0 then
			SkillProc.onAfterAllEffect(var_96_1, arg_96_0.owner)
		end
	end
	
	DEBUG_INFO.cur_state = nil
	
	return var_96_1, var_96_2
end

function State.isInvoker(arg_97_0)
	return arg_97_0.db.cs_timing ~= 1 and arg_97_0.db.cs_timing ~= 12 and arg_97_0.db.cs_timing ~= 11
end

function State.addPow(arg_98_0, arg_98_1)
	arg_98_0.add_pow = arg_98_1 or 0
end

function State.getPow(arg_99_0, arg_99_1)
	local var_99_0 = 1
	
	if arg_99_0.db.cs_eff[arg_99_1] ~= "CS_ADD" then
		var_99_0 = 1 + arg_99_0.add_pow
	end
	
	local var_99_1 = arg_99_0.db.cs_eff_value[arg_99_1] or 0
	
	if type(var_99_1) == "string" then
		return var_99_1
	end
	
	local var_99_2 = string.split(var_99_1, ",")
	
	if arg_99_0.stack_count > 1 then
		local var_99_3 = var_99_1 + (arg_99_0.db.cs_stackinc[arg_99_1] or 0) * (arg_99_0.stack_count - 1)
		
		Log.d("cs_stack", "지속효과 중첩", arg_99_0.owner.db.name, "cs id: " .. arg_99_0.id, "stack_count: " .. arg_99_0.stack_count, "before: " .. var_99_1, "after: " .. var_99_3)
		
		var_99_1 = var_99_3
	end
	
	local var_99_4 = arg_99_0.db.cs_eff_valuegrow[arg_99_1] or 0
	
	if #var_99_2 > 1 then
		return (var_99_2[1] + var_99_4 * (arg_99_0.lv - 1)) * var_99_0
	end
	
	return (var_99_1 + var_99_4 * (arg_99_0.lv - 1)) * var_99_0
end

function State.procToggleOnTarget(arg_100_0, arg_100_1)
	arg_100_0.cs_timing_targets = {}
	
	Log.d("toggle_skill", "###### procToggleOnTarget", arg_100_0.owner.db.name, arg_100_0.id)
	Log.d("toggle_skill", "before att : ", arg_100_0.owner.status.att)
	
	local function var_100_0()
		local var_101_0 = {}
		
		for iter_101_0 = 1, 6 do
			local var_101_1 = arg_100_0.db.cs_eff[iter_101_0]
			
			if var_101_1 and (var_101_1 == "CS_ADD" or var_101_1 == "CS_ADD_ABSOLUTE") then
				local var_101_2 = arg_100_0:getPow(iter_101_0)
				local var_101_3, var_101_4 = arg_100_0.owner:addState(var_101_2, 1, arg_100_0.owner, {
					ignore_calc = true,
					turn = 0,
					force_apply = var_101_1 == "CS_ADD_ABSOLUTE"
				})
				
				if var_101_3 then
					table.push(var_101_0, var_101_4.uid)
				end
			end
		end
		
		arg_100_0.owner:calc()
		
		return var_101_0
	end
	
	local function var_100_1(arg_102_0)
		for iter_102_0, iter_102_1 in pairs(arg_102_0) do
			arg_100_0.owner.states:removeByUId(iter_102_1)
		end
		
		arg_100_0.owner:calc()
	end
	
	arg_100_0.owner.inst.toggled_cs = arg_100_0.owner.inst.toggled_cs or {}
	
	local var_100_2 = table.indexOf(arg_100_0.owner.inst.toggled_cs, function(arg_103_0, arg_103_1)
		return arg_103_1.active_uid == arg_100_0.uid
	end)
	local var_100_3, var_100_4 = arg_100_0:checkStateCondition()
	local var_100_5
	
	if arg_100_0:isPassiveBlocked() then
		var_100_3 = false
	end
	
	if var_100_3 then
		if var_100_2 > 0 then
		else
			Log.d("toggle_skill", ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			Log.d("toggle_skill", " 토글 패시브 off->ON ", arg_100_0.owner.db.name, arg_100_0.uid, arg_100_0.id)
			Log.d("toggle_skill", ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			
			local var_100_6 = var_100_0()
			
			table.push(arg_100_0.owner.inst.toggled_cs, {
				active_uid = arg_100_0.uid,
				eff_uids = var_100_6
			})
			
			var_100_5 = {
				flag = true,
				type = "toggle_cs",
				state = arg_100_0,
				target = arg_100_0.owner
			}
		end
	elseif var_100_2 > 0 then
		Log.d("toggle_skill", "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
		Log.d("toggle_skill", " 토글 패시브 on->OFF ", arg_100_0.owner.db.name, arg_100_0.uid, arg_100_0.id)
		Log.d("toggle_skill", "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
		var_100_1(arg_100_0.owner.inst.toggled_cs[var_100_2].eff_uids)
		table.delete_i(arg_100_0.owner.inst.toggled_cs, function(arg_104_0, arg_104_1)
			return arg_104_1.active_uid == arg_100_0.uid
		end)
		
		var_100_5 = {
			flag = false,
			type = "toggle_cs",
			state = arg_100_0,
			target = arg_100_0.owner
		}
	end
	
	if false then
	end
	
	Log.d("toggle_skill", "after att : ", arg_100_0.owner.status.att)
	
	if arg_100_1 then
		return 
	end
	
	return {
		var_100_5
	}
end

function State._procStatusOnTargetStep1(arg_105_0, arg_105_1)
	local var_105_0 = arg_105_0.owner
	local var_105_1 = var_105_0.status
	
	if arg_105_0:isPassiveBlocked() then
		return 
	end
	
	for iter_105_0 = 1, 6 do
		if arg_105_0.db.cs_eff[iter_105_0] and table.find({
			1,
			12
		}, arg_105_0.db.cs_timing) then
			local var_105_2 = arg_105_0:getPow(iter_105_0)
			
			arg_105_0.turn_proc_count = arg_105_0.turn_proc_count + 1
			
			if arg_105_0.db.cs_eff[iter_105_0] == "CSP_ATT_UP" then
				var_105_1.att = var_105_1.att + arg_105_1.att * var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_DEF_UP" then
				var_105_1.def = var_105_1.def + arg_105_1.def * var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_MAXHP_UP" then
				var_105_1.max_hp = var_105_1.max_hp + arg_105_1.max_hp * var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_SPEED_UP" then
				var_105_1.speed = var_105_1.speed + arg_105_1.speed * var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CON_UP" then
				var_105_1.con = var_105_1.con + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CON_DOWN" then
				var_105_1.con = var_105_1.con - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_DODGE_UP" then
				var_105_1.dodge = var_105_1.dodge + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_DODGE_DOWN" then
				var_105_1.dodge = var_105_1.dodge - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CRI_UP" then
				var_105_1.cri = var_105_1.cri + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CRI_DOWN" then
				var_105_1.cri = var_105_1.cri + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CRIRES_UP" then
				var_105_1.cri_res = var_105_1.cri_res + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CRIRES_DOWN" then
				var_105_1.cri_res = var_105_1.cri_res - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == 168 then
				var_105_1.cri_res = var_105_1.cri_res - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CRIDMG_UP" then
				var_105_1.cri_dmg = var_105_1.cri_dmg + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_CRIDMG_DOWN" then
				var_105_1.cri_dmg = var_105_1.cri_dmg - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == 115 then
				var_105_1.dmg = var_105_1.dmg + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == 121 then
				var_105_1.self_dmg = var_105_1.self_dmg + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_RES_UP" then
				var_105_1.res = var_105_1.res + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_RES_DOWN" then
				var_105_1.res = var_105_1.res - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_ACC_UP" then
				var_105_1.acc = var_105_1.acc + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_ACC_DOWN" then
				var_105_1.acc = var_105_1.acc - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_COOP_UP" then
				var_105_1.coop = var_105_1.coop + var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_COOP_DOWN" then
				var_105_1.coop = var_105_1.coop - var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_ACC_UP_RES" then
				var_105_1.acc = var_105_1.acc + var_105_1.res * var_105_2
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_REF_ABILITY_UP" then
				local var_105_3 = totable(var_105_2 or {}).ability
				
				var_105_1[var_105_3] = var_105_1[var_105_3] + arg_105_0.value
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_ATT_UP_LEVEL" then
				local var_105_4 = var_105_1.att
				local var_105_5 = math.max(0, var_105_0.inst.lv - 5)
				
				var_105_1.att = var_105_1.att + var_105_0.base_status.att * (var_105_2 * var_105_5)
				
				Log.d("state", "레벨에 따른 공격력 n% 증가", var_105_0.db.name, var_105_4 .. " -> " .. var_105_1.att, var_105_5, var_105_2)
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_MAXHP_UP_LEVEL" then
				local var_105_6 = var_105_1.max_hp
				local var_105_7 = math.max(0, var_105_0.inst.lv - 5)
				
				var_105_1.max_hp = var_105_1.max_hp + var_105_0.base_status.max_hp * (var_105_2 * var_105_7)
				
				Log.d("state", "레벨에 따른 체력 n% 증가", var_105_0.db.name, var_105_6 .. " -> " .. var_105_1.max_hp, var_105_7, var_105_2)
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_STATUS_UP_RESOURCE_MUL" then
				local var_105_8 = string.split(var_105_2, ",")
				local var_105_9 = {}
				
				for iter_105_1, iter_105_2 in pairs(var_105_8) do
					local var_105_10 = string.split(iter_105_2, "=")
					
					var_105_9[var_105_10[1]] = var_105_10[2] or ""
				end
				
				local var_105_11 = var_105_9.ability
				
				if var_105_11 then
					local var_105_12 = (var_105_0:getSPRatio() or 0) * (tonumber(var_105_9.rate) or 0)
					
					if var_105_11 == "att" then
						var_105_1.att = var_105_1.att + arg_105_1.att * var_105_12
					elseif var_105_11 == "def" then
						var_105_1.def = var_105_1.def + arg_105_1.def * var_105_12
					elseif var_105_11 == "speed" then
						var_105_1.speed = var_105_1.speed + arg_105_1.speed * var_105_12
					elseif var_105_11 == "max_hp" then
						var_105_1.max_hp = var_105_1.max_hp + arg_105_1.max_hp * var_105_12
					end
				end
			elseif arg_105_0.db.cs_eff[iter_105_0] == "CSP_STATUS_UP_RESOURCE_ADD" then
				local var_105_13 = string.split(var_105_2, ",")
				local var_105_14 = {}
				
				for iter_105_3, iter_105_4 in pairs(var_105_13) do
					local var_105_15 = string.split(iter_105_4, "=")
					
					var_105_14[var_105_15[1]] = var_105_15[2] or ""
				end
				
				local var_105_16 = var_105_14.ability
				
				if var_105_16 then
					local var_105_17 = round(var_105_0:getSPRatio() * (tonumber(var_105_14.rate) or 0), 2)
					
					if var_105_16 == "cri" then
						var_105_1.cri = var_105_1.cri + var_105_17
					elseif var_105_16 == "cri_res" then
						var_105_1.cri_res = var_105_1.cri_res + var_105_17
					elseif var_105_16 == "cri_dmg" then
						var_105_1.cri_dmg = var_105_1.cri_dmg + var_105_17
					elseif var_105_16 == "acc" then
						var_105_1.acc = var_105_1.acc + var_105_17
					elseif var_105_16 == "con" then
						var_105_1.con = var_105_1.con + var_105_17
					elseif var_105_16 == "dodge" then
						var_105_1.dodge = var_105_1.dodge + var_105_17
					end
				end
			end
		end
	end
end

function State._procStatusOnTargetStep_rta(arg_106_0, arg_106_1)
	local var_106_0 = arg_106_0.owner.status
	
	if arg_106_0:isPassiveBlocked() then
		return 
	end
	
	for iter_106_0 = 1, 6 do
		if arg_106_0.db.cs_eff[iter_106_0] and arg_106_0.db.cs_timing == 1 then
			local var_106_1 = arg_106_0:getPow(iter_106_0)
			
			arg_106_0.turn_proc_count = arg_106_0.turn_proc_count + 1
			
			if arg_106_0.db.cs_eff[iter_106_0] == "CSP_STATUS_UP_SELF_STATUS" then
				local var_106_2 = totable(var_106_1 or {})
				local var_106_3 = var_106_2.ability2
				local var_106_4 = var_106_2.ability1
				local var_106_5 = tonumber(var_106_2.rate) or 1
				
				var_106_0[var_106_4] = var_106_0[var_106_4] + arg_106_1[var_106_3] * var_106_5
				arg_106_1[var_106_4] = arg_106_1[var_106_4] + arg_106_1[var_106_3] * var_106_5
			end
		end
	end
end

function State._procVariablePassiveStatus(arg_107_0, arg_107_1)
	local var_107_0 = arg_107_0.owner
	local var_107_1 = var_107_0.status
	
	if arg_107_0:isPassiveBlocked() then
		return 
	end
	
	for iter_107_0 = 1, 6 do
		if arg_107_0.db.cs_eff[iter_107_0] and arg_107_0.db.cs_timing == 31 then
			local var_107_2 = arg_107_0:getPow(iter_107_0)
			
			arg_107_0.turn_proc_count = arg_107_0.turn_proc_count + 1
			
			if arg_107_0.db.cs_eff[iter_107_0] == "CSP_STATUS_UP_LOSTHP_RATIO" then
				local var_107_3 = totable(var_107_2 or {})
				local var_107_4 = var_107_3.status_type
				
				if not var_107_4 then
					Log.e("State", "invalid target status type", arg_107_0.db.cs_eff[iter_107_0])
				end
				
				local var_107_5 = to_n(var_107_3.grow_rate)
				local var_107_6 = 1 - var_107_0:getHPRatio()
				local var_107_7 = math.min(tonumber(var_107_3.max_ratio) or 1, math.max(tonumber(var_107_3.min_ratio) or 0, var_107_6))
				local var_107_8 = tonumber(var_107_3.min_ratio) or 0
				local var_107_9 = tonumber(var_107_3.max_ratio) or 1
				
				if var_107_7 < var_107_8 then
					var_107_7 = 0
				end
				
				if var_107_9 < var_107_7 then
					var_107_7 = var_107_9
				end
				
				if var_107_7 > 0 and var_107_1[var_107_4] then
					local var_107_10 = var_107_7 * var_107_5
					
					var_107_1[var_107_4] = var_107_1[var_107_4] + var_107_0.character_status[var_107_4] * var_107_10
				end
			elseif arg_107_0.db.cs_eff[iter_107_0] == "CSP_EQUIP_STATUS_UP_LOSTHP_RATIO" then
				local var_107_11 = totable(var_107_2 or {})
				local var_107_12 = var_107_11.status_type
				
				if not var_107_12 then
					Log.e("State", "invalid target status type", arg_107_0.db.cs_eff[iter_107_0])
				end
				
				local var_107_13 = to_n(var_107_11.grow_rate)
				local var_107_14 = 1 - var_107_0:getHPRatio()
				local var_107_15 = tonumber(var_107_11.min_ratio) or 0
				local var_107_16 = tonumber(var_107_11.max_ratio) or 1
				local var_107_17 = math.clamp(var_107_14, var_107_15, var_107_16)
				
				if var_107_17 > 0 and var_107_1[var_107_12] ~= nil then
					if var_107_12 == "cri" or var_107_12 == "cri_res" or var_107_12 == "cri_dmg" or var_107_12 == "acc" or var_107_12 == "con" or var_107_12 == "dodge" then
						local var_107_18 = round(var_107_17 * var_107_13, 2)
						
						var_107_1[var_107_12] = var_107_1[var_107_12] + (arg_107_1[var_107_12] + var_107_18)
					else
						local var_107_19 = var_107_17 * var_107_13
						
						var_107_1[var_107_12] = var_107_1[var_107_12] + arg_107_1[var_107_12] * var_107_19
					end
				end
			end
		end
	end
end

function State._procStatusOnTargetStep_hp_debuff(arg_108_0, arg_108_1)
	local var_108_0 = arg_108_0.owner.status
	
	if arg_108_0:isPassiveBlocked() then
		return 
	end
	
	for iter_108_0 = 1, 6 do
		if arg_108_0.db.cs_eff[iter_108_0] and table.find({
			1,
			12
		}, arg_108_0.db.cs_timing) then
			local var_108_1 = arg_108_0:getPow(iter_108_0)
			
			arg_108_0.turn_proc_count = arg_108_0.turn_proc_count + 1
			
			if arg_108_0.db.cs_eff[iter_108_0] == "CSP_MAXHP_DOWN" then
				local var_108_2 = arg_108_1.max_hp * var_108_1
				
				var_108_0.max_hp = var_108_0.max_hp - var_108_2
				arg_108_1.max_hp = arg_108_1.max_hp - var_108_2
			end
		end
	end
end

function State._procStatusOnTargetStep2(arg_109_0, arg_109_1)
	local var_109_0 = arg_109_0.owner.status
	
	if arg_109_0:isPassiveBlocked() then
		return 
	end
	
	for iter_109_0 = 1, 6 do
		if arg_109_0.db.cs_eff[iter_109_0] and table.find({
			1,
			12
		}, arg_109_0.db.cs_timing) then
			local var_109_1 = arg_109_0:getPow(iter_109_0)
			
			arg_109_0.turn_proc_count = arg_109_0.turn_proc_count + 1
			
			if arg_109_0.db.cs_eff[iter_109_0] == "CSP_ATT_DOWN" then
				local var_109_2 = arg_109_1.att * var_109_1
				
				var_109_0.att = math.max(1, var_109_0.att - var_109_2)
				arg_109_1.att = arg_109_1.att - var_109_2
			elseif arg_109_0.db.cs_eff[iter_109_0] == "CSP_DEF_DOWN" then
				local var_109_3 = arg_109_1.def * var_109_1
				
				var_109_0.def = math.max(0, var_109_0.def - var_109_3)
				arg_109_1.def = math.max(0, arg_109_1.def - var_109_3)
			elseif arg_109_0.db.cs_eff[iter_109_0] == "CSP_SPEED_DOWN" then
				local var_109_4 = arg_109_1.speed * var_109_1
				
				var_109_0.speed = var_109_0.speed - var_109_4
				arg_109_1.speed = arg_109_1.speed - var_109_4
			end
		end
	end
end

function State._procStatusOnTargetStep3(arg_110_0, arg_110_1)
	local var_110_0 = arg_110_0.owner.status
	
	if arg_110_0:isPassiveBlocked() then
		return 
	end
	
	for iter_110_0 = 1, 6 do
		if arg_110_0.db.cs_eff[iter_110_0] and table.find({
			1,
			12
		}, arg_110_0.db.cs_timing) then
			local var_110_1 = arg_110_0:getPow(iter_110_0)
			local var_110_2 = string.split(var_110_1, ",")
			local var_110_3 = {}
			
			if arg_110_0.db.cs_eff[iter_110_0] == "CSP_FIXED_STATUS_UP" then
				for iter_110_1, iter_110_2 in pairs(var_110_2) do
					local var_110_4 = string.split(iter_110_2, "=")
					
					var_110_3[var_110_4[1]] = var_110_4[2] or ""
				end
				
				local var_110_5 = var_110_3.ability
				local var_110_6 = var_110_3.value
				
				if var_110_5 and var_110_0[var_110_5] then
					var_110_0[var_110_5] = var_110_0[var_110_5] + to_n(var_110_6)
				end
			end
		end
	end
end

function State._procStatusOnTargetStep4(arg_111_0, arg_111_1)
	local var_111_0 = arg_111_0.owner.status
	
	if arg_111_0:isPassiveBlocked() then
		return 
	end
	
	for iter_111_0 = 1, 6 do
		if arg_111_0.db.cs_eff[iter_111_0] and table.find({
			1,
			12
		}, arg_111_0.db.cs_timing) then
			local var_111_1 = arg_111_0:getPow(iter_111_0)
			local var_111_2 = string.split(var_111_1, ",")
			local var_111_3 = {}
			
			if arg_111_0.db.cs_eff[iter_111_0] == "CSP_STATUS_FIXED" then
				for iter_111_1, iter_111_2 in pairs(var_111_2) do
					local var_111_4 = string.split(iter_111_2, "=")
					
					var_111_3[var_111_4[1]] = var_111_4[2] or ""
				end
				
				local var_111_5 = var_111_3.ability
				local var_111_6 = var_111_3.value
				
				if var_111_5 and var_111_6 and var_111_0[var_111_5] then
					var_111_0[var_111_5] = var_111_6
				end
			end
		end
	end
end

function State._procOnTarget(arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
	local var_112_0
	
	for iter_112_0 = 1, 6 do
		if arg_112_0.db.cs_eff[iter_112_0] then
			Log.d("state", "cs 효과 적용", arg_112_0.owner.db.name, "uid: " .. arg_112_0.uid, "cs_id: " .. arg_112_0.id, "index: " .. iter_112_0, "cs_eff: " .. arg_112_0.db.cs_eff[iter_112_0])
			
			if arg_112_0.db.cs_good ~= "y" and arg_112_2:isInvincible() then
				if arg_112_0.db.system_text_hide ~= "y" then
					table.insert(arg_112_1, {
						type = "immune",
						target = arg_112_2
					})
				end
			else
				local var_112_1 = arg_112_0:getPow(iter_112_0)
				
				arg_112_0.turn_proc_count = arg_112_0.turn_proc_count + 1
				
				if SkillProc.procEffect(arg_112_1, {
					attacker = arg_112_3,
					eff_target = arg_112_2,
					eff = arg_112_0.db.cs_eff[iter_112_0],
					pow = var_112_1,
					cs_eff_turn = arg_112_0.db.cs_eff_turn[iter_112_0],
					giver = arg_112_0.giver,
					owner = arg_112_0.owner,
					skill_id = arg_112_4 or arg_112_0.skill_id,
					state = arg_112_0,
					invokers = arg_112_5,
					timming = arg_112_0.db.cs_timing
				}) then
					var_112_0 = true
					
					if arg_112_0.db.cs_unique and arg_112_0.db.cs_timing then
						local var_112_2 = arg_112_0.owner.logic:makeUniqueFlagKey(arg_112_0.db.cs_unique, arg_112_0.db.cs_timing)
						
						arg_112_0.owner.logic:setUniqueFlag(var_112_2, arg_112_2)
					end
				end
			end
		end
	end
	
	return var_112_0
end

function StateList.create(arg_113_0, arg_113_1)
	local var_113_0 = {
		List = {},
		owner = arg_113_1
	}
	
	var_113_0.counter = 0
	
	copy_functions(StateList, var_113_0)
	
	return var_113_0
end

function StateList.restorePureData(arg_114_0, arg_114_1)
	if not arg_114_1 then
		return 
	end
	
	local var_114_0 = {}
	
	arg_114_0.List = {}
	
	local var_114_1 = 0
	
	for iter_114_0, iter_114_1 in pairs(arg_114_1.list or {}) do
		local var_114_2 = State:restorePureData(arg_114_0.owner, iter_114_1)
		
		if var_114_2 then
			var_114_1 = math.max(var_114_1, tonumber(var_114_2.uid))
			
			table.insert(arg_114_0.List, var_114_2)
		end
	end
	
	arg_114_0.counter = arg_114_1.counter or var_114_1
	
	return var_114_0
end

function StateList.exportPureData(arg_115_0, arg_115_1)
	local var_115_0 = {}
	
	for iter_115_0, iter_115_1 in pairs(arg_115_0.List) do
		local var_115_1 = iter_115_1:exportPureData(arg_115_1)
		
		if var_115_1 then
			table.insert(var_115_0, var_115_1)
		end
	end
	
	return {
		counter = arg_115_0.counter,
		list = var_115_0
	}
end

function StateList.enumNormalStates(arg_116_0, arg_116_1)
	for iter_116_0, iter_116_1 in pairs(arg_116_0.List) do
		if iter_116_1:isValid() and (iter_116_1.db.cs_preproc ~= "y" or cnt < 0) and not iter_116_1:isPassive() then
			arg_116_1(iter_116_1)
		end
	end
end

function StateList.resetOwner(arg_117_0, arg_117_1)
	arg_117_0.owner = arg_117_1
	
	for iter_117_0, iter_117_1 in pairs(arg_117_0.List) do
		iter_117_1.owner = arg_117_1
	end
end

function StateList.add(arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4, arg_118_5, arg_118_6, arg_118_7)
	arg_118_7 = arg_118_7 or {}
	arg_118_0.counter = arg_118_0.counter + 1
	
	local var_118_0 = arg_118_0.counter
	
	arg_118_1 = tostring(arg_118_1)
	
	local var_118_1
	local var_118_2 = {}
	local var_118_3
	local var_118_4, var_118_5
	
	var_118_4, var_118_2[1], var_118_2[2], var_118_2[3], var_118_2[4], var_118_5 = UNIT.getCSDB(arg_118_3, arg_118_1, {
		"cs_type",
		"cs_eff1",
		"cs_eff2",
		"cs_eff3",
		"cs_eff4",
		"isshow"
	}, {
		skill_id = arg_118_5
	})
	
	Log.d("state", "지속효과 추가", arg_118_0.owner.db.name, "uid: " .. var_118_0, "id: " .. arg_118_1, "turn: ", arg_118_4, "from skill_id: ", arg_118_5)
	
	if var_118_4 == "debuff" and not DB("skill_immune", arg_118_1, "id") and PLATFORM == "win32" and not IS_TOOL_MODE then
		Log.e(string.format("면역 등록되어있지 않은 지속효과. : %s, %s", arg_118_1, tostring(arg_118_5)))
		__G__TRACKBACK__("unregistered immune CS :" .. arg_118_1)
	end
	
	local function var_118_6(arg_119_0)
		for iter_119_0, iter_119_1 in pairs(var_118_2) do
			if iter_119_1 == arg_119_0 then
				return true
			end
		end
		
		return false
	end
	
	local var_118_7 = var_118_6("CSP_MODELCHANGE") or var_118_6("CSP_TRANSFORM")
	
	if var_118_4 == "buff" and arg_118_0:isExistEffect("CSP_BUFFBLOCK") and not var_118_7 and not arg_118_6 then
		Log.d("state", "!!! 강화불가 효과 안걸림", arg_118_0.owner.db.name, "cs_id: " .. arg_118_1)
		
		return false
	end
	
	if var_118_4 == "hidden" or var_118_4 == "passive" or var_118_4 == "concentration" then
	elseif arg_118_0:getCountByShowType() >= (GAME_STATIC_VARIABLE.max_cs_count or 10) and var_118_5 == "y" then
		return false
	end
	
	local var_118_8 = tostring(arg_118_0.owner:getUID()) .. "_" .. tostring(var_118_0)
	local var_118_9 = {
		guid = var_118_8,
		uid = var_118_0,
		id = arg_118_1,
		lv = arg_118_2,
		giver = arg_118_3,
		owner = arg_118_0.owner,
		turn = arg_118_4,
		skill_id = arg_118_5,
		stack_count = arg_118_7.stack_count
	}
	local var_118_10 = State:create(var_118_9, arg_118_7)
	local var_118_11 = {}
	
	if var_118_10.db.cs_attribute == 1 and arg_118_0:isExistEffect("CSP_IMMUNE_STUN") then
		Log.d("state", "!!! 군중제어(행동불가) 지속효과가 면억 패시브가 있어서 안걸림", arg_118_0.owner.db.name, "cs_id: " .. var_118_10.id)
		
		return false
	end
	
	if not CS_Util.isApplyStateOnlyHeroByCS(var_118_10) then
		return false
	end
	
	local var_118_12 = true
	local var_118_13
	local var_118_14
	
	if var_118_10.db.cs_stack then
		for iter_118_0, iter_118_1 in pairs(arg_118_0.List) do
			if iter_118_1:isValid() and iter_118_1:getId() == arg_118_1 then
				local var_118_15 = math.min(iter_118_1.db.cs_stack, iter_118_1.stack_count + (tonumber(var_118_10.stack_count) or 1))
				
				var_118_14 = var_118_15 > iter_118_1.stack_count or iter_118_1.db.cs_stack == var_118_15
				var_118_10.stack_count = var_118_15
				var_118_10.uid = arg_118_0.List[iter_118_0].uid
				arg_118_0.List[iter_118_0] = var_118_10
				
				local var_118_16 = var_118_10.db.cs_effect and string.split(var_118_10.db.cs_effect, ",") or {}
				local var_118_17 = math.min(#var_118_16, var_118_15)
				
				arg_118_0.List[iter_118_0].effect = var_118_16[var_118_17]
				
				local var_118_18 = string.split(var_118_10.db.cs_eff_bone, ",")
				local var_118_19 = math.min(#var_118_18, var_118_15)
				
				arg_118_0.List[iter_118_0].eff_bone = var_118_18[var_118_19]
				arg_118_0.List[iter_118_0].eff_scale = var_118_10.db.cs_effect_scale or 1
				
				Log.d("stack_count", "stack_count", var_118_15, "effect", arg_118_0.List[iter_118_0].effect, "eff_bone", arg_118_0.List[iter_118_0].eff_bone, "scale", arg_118_0.List[iter_118_0].eff_scale)
				
				var_118_12 = nil
				
				break
			end
		end
	end
	
	if var_118_12 then
		local function var_118_20(arg_120_0)
			for iter_120_0, iter_120_1 in pairs(arg_120_0 or {}) do
				if iter_120_1 == "COUNT_LIMIT" or iter_120_1 == "COUNT_LIMIT_WAVE" then
					return true
				end
			end
		end
		
		if var_118_10.db.cs_group then
			for iter_118_2, iter_118_3 in pairs(arg_118_0.List) do
				if iter_118_3:isValid() and iter_118_3.db.cs_group == var_118_10.db.cs_group then
					local var_118_21 = to_n(iter_118_3.db.cs_rank)
					local var_118_22 = to_n(var_118_10.db.cs_rank)
					
					if var_118_21 < var_118_22 then
						iter_118_3:setValid(false)
						table.insert(var_118_11, iter_118_3)
						Log.d("state", "cs_group 적용", var_118_10:getId(), iter_118_3.turn, var_118_10.turn)
						
						if iter_118_3.turn >= var_118_10.turn then
							var_118_10.turn = iter_118_3.turn
							var_118_13 = true
						end
					elseif var_118_21 == var_118_22 then
						if iter_118_3.turn > var_118_10.turn then
							var_118_12 = nil
						else
							iter_118_3:setValid(false)
							table.insert(var_118_11, iter_118_3)
						end
					else
						var_118_12 = nil
						
						if iter_118_3.turn <= var_118_10.turn then
							arg_118_1 = iter_118_3.id
							iter_118_3.turn = var_118_10.turn
							var_118_10.uid = iter_118_3.uid
							var_118_13 = true
						end
					end
					
					if iter_118_3:isBarrier() and var_118_10:isBarrier() then
						if iter_118_3.value < var_118_10.value then
							iter_118_3.value = var_118_10.value
							
							break
						end
						
						var_118_10.value = iter_118_3.value
					end
					
					break
				end
			end
		elseif var_118_10.db.cs_overlap then
		elseif var_118_20(var_118_10.db.cs_con) then
			for iter_118_4, iter_118_5 in pairs(arg_118_0.List) do
				if iter_118_5:isValid() and iter_118_5:getId() == arg_118_1 then
					local var_118_23 = iter_118_5:getInvokeStackCount()
					
					var_118_10.uid = arg_118_0.List[iter_118_4].uid
					arg_118_0.List[iter_118_4] = var_118_10
					
					if var_118_23 and var_118_23 > 0 then
						arg_118_0.List[iter_118_4]:setInvokeStackCount(var_118_23)
					end
					
					var_118_12 = nil
					
					break
				end
			end
		else
			for iter_118_6, iter_118_7 in pairs(arg_118_0.List) do
				if iter_118_7:isValid() and iter_118_7:getId() == arg_118_1 then
					if arg_118_0.List[iter_118_6].turn <= var_118_10.turn then
						iter_118_7.turn = var_118_10.turn
						var_118_10.uid = iter_118_7.uid
						iter_118_7.giver = var_118_10.giver
						iter_118_7.giver_status = var_118_10.giver_status
						var_118_13 = true
						var_118_12 = nil
						
						break
					end
					
					var_118_12 = nil
					
					break
				end
			end
		end
	end
	
	if var_118_12 then
		local var_118_24 = arg_118_0:getCountByShowType() - (GAME_STATIC_VARIABLE.max_cs_count or 10)
		
		if var_118_24 >= 0 and var_118_5 == "y" and (var_118_4 == "hidden" or var_118_4 == "passive" or var_118_4 == "concentration") then
			local var_118_25 = {
				{},
				{},
				{}
			}
			
			for iter_118_8, iter_118_9 in pairs(arg_118_0.List) do
				if iter_118_9:isValid() then
					if iter_118_9:isType("buff") or iter_118_9:isType("debuff") then
						if iter_118_9:canRemove() then
							table.insert(var_118_25[1], iter_118_9)
						else
							table.insert(var_118_25[2], iter_118_9)
						end
					elseif iter_118_9:isType("hidden") or iter_118_9:isType("passive") or iter_118_9:isType("concentration") then
						table.insert(var_118_25[3], iter_118_9)
					end
				end
			end
			
			local function var_118_26()
				for iter_121_0 = 1, 3 do
					local var_121_0 = table.count(var_118_25[iter_121_0])
					
					if var_121_0 > 0 then
						local var_121_1 = arg_118_0.owner.logic.random:get(1, var_121_0)
						local var_121_2 = var_118_25[iter_121_0][var_121_1]
						
						var_121_2:setValid(false)
						table.insert(var_118_11, var_121_2)
						table.remove(var_118_25[iter_121_0], var_121_1)
						
						break
					end
				end
			end
			
			for iter_118_10 = 1, var_118_24 + 1 do
				var_118_26()
			end
		end
		
		table.insert(arg_118_0.List, var_118_10)
	elseif var_118_4 == "passive" or var_118_4 == "hidden" then
		for iter_118_11, iter_118_12 in pairs(arg_118_0.List) do
			if iter_118_12:isValid() and iter_118_12:getId() == var_118_10.id and var_0_1(iter_118_12.db, var_118_10.db) then
				iter_118_12.db = var_118_10.db
			end
		end
	end
	
	return var_118_12 or var_118_13 or var_118_14, var_118_10, arg_118_1, var_118_11
end

function StateList.removeByCondition(arg_122_0, arg_122_1, arg_122_2, arg_122_3)
	arg_122_3 = arg_122_3 or {}
	arg_122_1 = arg_122_1 or {}
	
	local var_122_0 = false
	
	for iter_122_0 = #arg_122_0.List, 1, -1 do
		if arg_122_0.List[iter_122_0]:isValid() and not arg_122_0.List[iter_122_0]:isPassive() and arg_122_2(arg_122_0.List[iter_122_0]) then
			var_122_0 = true
			
			arg_122_0.List[iter_122_0]:setValid(false)
			table.insert(arg_122_3, {
				state = arg_122_0.List[iter_122_0],
				target = arg_122_0.List[iter_122_0].owner
			})
			
			if arg_122_0:canRemoveStateInfo(arg_122_0.List[iter_122_0]) then
				arg_122_0.List[iter_122_0]:removeState(arg_122_1)
			end
			
			if arg_122_0.List[iter_122_0]:checkEff("CSP_PASSIVEBLOCK") then
				arg_122_0.owner.inst.hp_revise_block = true
				
				arg_122_0.owner.logic:onRemovedPassiveBlock(arg_122_0.owner)
			end
			
			if arg_122_0.List[iter_122_0]:checkEff("CSP_CONTENT_ENHANCE") then
				arg_122_0.owner:removeContentEnhance()
			end
			
			if arg_122_0.List[iter_122_0]:checkEff("CSP_TRANSFORM") then
				arg_122_0.owner:resetTransform()
			end
		end
	end
	
	if var_122_0 then
		arg_122_0.owner:calc()
		
		arg_122_0.counter = arg_122_0.counter + 1
	end
	
	return arg_122_1, arg_122_3
end

function StateList.removePassiveById(arg_123_0, arg_123_1)
	Log.d("state", "패시브 제거 ById", arg_123_0.owner.db.name, arg_123_1)
	
	for iter_123_0 = #arg_123_0.List, 1, -1 do
		if arg_123_0.List[iter_123_0].id == arg_123_1 and arg_123_0.List[iter_123_0]:isValid() then
			arg_123_0.List[iter_123_0]:setValid(false)
		end
	end
end

function StateList.removeById(arg_124_0, arg_124_1, arg_124_2)
	Log.d("state", "지속효과 제거 ById", arg_124_0.owner.db.name, arg_124_1)
	
	return arg_124_0:removeByCondition(arg_124_2, function(arg_125_0)
		return tostring(arg_125_0.id) == tostring(arg_124_1)
	end)
end

function StateList.removeByUId(arg_126_0, arg_126_1, arg_126_2, arg_126_3)
	Log.d("state", "지속효과 제거 ByUId", arg_126_0.owner.db.name, arg_126_1)
	
	return arg_126_0:removeByCondition(arg_126_2, function(arg_127_0)
		return tostring(arg_127_0.uid) == tostring(arg_126_1)
	end, arg_126_3)
end

function StateList.isExistEffectTiming(arg_128_0, arg_128_1)
	for iter_128_0, iter_128_1 in pairs(arg_128_0.List) do
		if iter_128_1:isValid() and iter_128_1.db.cs_timing == arg_128_1 then
			return true
		end
	end
	
	return false
end

function StateList.isExistForceEffect(arg_129_0, arg_129_1)
	for iter_129_0, iter_129_1 in pairs(arg_129_0.List) do
		if iter_129_1:isValid() then
			for iter_129_2 = 1, 6 do
				if iter_129_1.db.cs_eff[iter_129_2] == arg_129_1 then
					return true, iter_129_1.db.cs_eff_value[iter_129_2]
				end
			end
		end
	end
	
	return false
end

function StateList.isExistEffect(arg_130_0, arg_130_1)
	for iter_130_0, iter_130_1 in pairs(arg_130_0.List) do
		if iter_130_1:isValid() then
			for iter_130_2 = 1, 6 do
				if iter_130_1.db.cs_eff[iter_130_2] == arg_130_1 and not iter_130_1:isPassiveBlocked() then
					return true, iter_130_1.db.cs_eff_value[iter_130_2]
				end
			end
		end
	end
	
	return false
end

function StateList.getAllEffValue(arg_131_0, arg_131_1, arg_131_2)
	local var_131_0 = 0
	
	for iter_131_0, iter_131_1 in pairs(arg_131_0.List) do
		local var_131_1
		
		if not arg_131_2 then
			var_131_1 = true
		elseif type(arg_131_2) == "function" then
			var_131_1 = arg_131_2(iter_131_1)
		end
		
		if iter_131_1:isValid() and var_131_1 then
			for iter_131_2 = 1, 6 do
				if iter_131_1.db.cs_eff[iter_131_2] == arg_131_1 then
					var_131_0 = var_131_0 + iter_131_1.db.cs_eff_value[iter_131_2]
				end
			end
		end
	end
	
	return var_131_0
end

function StateList.getCSIncreaseEffValue(arg_132_0, arg_132_1)
	local var_132_0 = 0
	local var_132_1 = false
	
	for iter_132_0, iter_132_1 in pairs(arg_132_0.List) do
		if iter_132_1:isValid() and not iter_132_1:isPassiveBlocked() then
			for iter_132_2 = 1, 6 do
				if iter_132_1.db.cs_eff[iter_132_2] == "CSP_HPDOWN_EFFVALUE_INCREASE" then
					local var_132_2 = totable(iter_132_1.db.cs_eff_value[iter_132_2] or "")
					
					if var_132_2.cs_id == arg_132_1 or type(var_132_2.cs_id) == "table" and table.isInclude(var_132_2.cs_id, arg_132_1) then
						var_132_1 = true
						var_132_0 = var_132_0 + to_n(var_132_2.value)
					end
				end
			end
		end
	end
	
	return var_132_0, var_132_1
end

function StateList.getCSDecreaseEffValue(arg_133_0, arg_133_1)
	local var_133_0 = 0
	local var_133_1 = false
	
	for iter_133_0, iter_133_1 in pairs(arg_133_0.List) do
		if iter_133_1:isValid() and not iter_133_1:isPassiveBlocked() then
			for iter_133_2 = 1, 6 do
				if iter_133_1.db.cs_eff[iter_133_2] == "CSP_CSID_DMG_DOWN" then
					local var_133_2 = totable(iter_133_1.db.cs_eff_value[iter_133_2] or "")
					
					if var_133_2.csid == arg_133_1 or type(var_133_2.csid) == "table" and table.isInclude(var_133_2.csid, arg_133_1) then
						var_133_1 = true
						var_133_0 = var_133_0 + to_n(var_133_2.value)
					end
				end
			end
		end
	end
	
	return var_133_0, var_133_1
end

function StateList.getMaxHPImmuneRate(arg_134_0)
	local var_134_0 = 0
	
	for iter_134_0, iter_134_1 in pairs(arg_134_0.List) do
		if iter_134_1:isValid() then
			for iter_134_2 = 1, 6 do
				if iter_134_1.db.cs_eff[iter_134_2] == "CSP_IMMUNE_BF_TARGET_MAXHP" then
					var_134_0 = var_134_0 + (iter_134_1.db.cs_eff_value[iter_134_2] or 1)
				end
			end
		end
	end
	
	return math.clamp(var_134_0, 0, 1)
end

function StateList.isExistAttribute(arg_135_0, arg_135_1, arg_135_2)
	for iter_135_0, iter_135_1 in pairs(arg_135_0.List) do
		if iter_135_1:isValid() and (not arg_135_2 or iter_135_1:isType(arg_135_2)) and iter_135_1.db.cs_attribute == arg_135_1 then
			return true
		end
	end
	
	return false
end

function StateList.isExistById(arg_136_0, arg_136_1)
	for iter_136_0, iter_136_1 in pairs(arg_136_0.List) do
		if tostring(iter_136_1.id) == tostring(arg_136_1) and iter_136_1:isValid() then
			return true
		end
	end
	
	return false
end

function StateList.isExistByGroupId(arg_137_0, arg_137_1)
	if tostring(arg_137_1) == "" then
		return false
	end
	
	for iter_137_0, iter_137_1 in pairs(arg_137_0.List) do
		if tostring(iter_137_1.db.cs_group) == tostring(arg_137_1) and iter_137_1:isValid() then
			return true
		end
	end
	
	return false
end

function StateList.getInvokeStackCount(arg_138_0, arg_138_1)
	for iter_138_0, iter_138_1 in pairs(arg_138_0.List) do
		if tostring(iter_138_1.id) == tostring(arg_138_1) and iter_138_1:isValid() then
			return iter_138_1:getInvokeStackCount()
		end
	end
end

function StateList.setInvokeStackCount(arg_139_0, arg_139_1, arg_139_2)
	for iter_139_0, iter_139_1 in pairs(arg_139_0.List) do
		if tostring(iter_139_1.id) == tostring(arg_139_1) and iter_139_1:isValid() then
			iter_139_1:setInvokeStackCount(arg_139_2)
		end
	end
end

function StateList.resetInvokeStackCountWave(arg_140_0)
	local function var_140_0(arg_141_0)
		for iter_141_0, iter_141_1 in pairs(arg_141_0 or {}) do
			if iter_141_1 == "COUNT_LIMIT_WAVE" then
				return true
			end
		end
	end
	
	for iter_140_0, iter_140_1 in pairs(arg_140_0.List) do
		if var_140_0(iter_140_1.db.cs_con) and iter_140_1:isValid() then
			iter_140_1.invoke_stack = 0
		end
	end
end

function StateList.isImmune(arg_142_0, arg_142_1)
	arg_142_1 = tostring(arg_142_1)
	
	local var_142_0 = arg_142_0:findAllEffValues("CSP_IMMUNE_CS")
	
	for iter_142_0, iter_142_1 in pairs(var_142_0) do
		local var_142_1 = string.split(iter_142_1, ",")
		
		if table.find(var_142_1, arg_142_1) then
			return true
		end
	end
	
	return false
end

function StateList.isBlock_CS(arg_143_0, arg_143_1)
	arg_143_1 = tostring(arg_143_1)
	
	local var_143_0 = arg_143_0:findAllEffValues("CSP_DEBUFF_BLOCK")
	
	for iter_143_0, iter_143_1 in pairs(var_143_0) do
		local var_143_1 = DB("skill_immune_group", iter_143_1, "cs")
		local var_143_2 = string.split(var_143_1 or "", ",")
		
		if table.find(var_143_2, arg_143_1) then
			return true
		end
	end
end

function StateList.isBlock_Eff(arg_144_0, arg_144_1)
	for iter_144_0, iter_144_1 in pairs(arg_144_0.List) do
		if iter_144_1:isValid() then
			local var_144_0, var_144_1, var_144_2 = iter_144_1:isBlock_Eff(arg_144_1)
			
			if var_144_0 then
				return var_144_0, var_144_2
			end
		end
	end
end

function StateList.isExistByUId(arg_145_0, arg_145_1)
	for iter_145_0, iter_145_1 in pairs(arg_145_0.List) do
		if iter_145_1.uid == arg_145_1 and iter_145_1:isValid() then
			return true
		end
	end
	
	return false
end

function StateList.countById(arg_146_0, arg_146_1)
	local var_146_0 = 0
	
	for iter_146_0, iter_146_1 in pairs(arg_146_0.List) do
		if tostring(iter_146_1.id) == tostring(arg_146_1) and iter_146_1:isValid() then
			var_146_0 = var_146_0 + 1
		end
	end
	
	return var_146_0
end

function StateList.clear(arg_147_0, arg_147_1)
	arg_147_1 = arg_147_1 or {}
	
	local var_147_0 = arg_147_1.except_eff or {}
	
	if not arg_147_1.ignore_passives then
		arg_147_0.List = {}
	else
		for iter_147_0 = #arg_147_0.List, 1, -1 do
			if not arg_147_0.List[iter_147_0]:isPassive() then
				local var_147_1 = false
				
				for iter_147_1, iter_147_2 in pairs(var_147_0) do
					if arg_147_0.List[iter_147_0]:checkEff(iter_147_2) then
						var_147_1 = true
					end
				end
				
				if arg_147_1.revive_hold and arg_147_0.List[iter_147_0].db.cs_revive_hold == "y" then
					var_147_1 = true
				end
				
				if not var_147_1 then
					arg_147_0.List[iter_147_0]:setValid(false)
					arg_147_0.List[iter_147_0]:removeState(arg_147_1.logs)
					table.remove(arg_147_0.List, iter_147_0)
				end
			end
		end
	end
	
	arg_147_0.counter = arg_147_0.counter + 1
end

function StateList.extendStates(arg_148_0, arg_148_1, arg_148_2)
	local var_148_0 = {}
	local var_148_1 = {}
	
	for iter_148_0, iter_148_1 in pairs(arg_148_0.List) do
		if arg_148_1(iter_148_1) and arg_148_0.List[iter_148_0]:isValid() and (arg_148_0.List[iter_148_0].db.cs_preproc ~= "y" or cnt < 0) and not arg_148_0.List[iter_148_0]:isPassive() then
			iter_148_1.turn = math.max(iter_148_1.turn + arg_148_2, 0)
			arg_148_0.counter = arg_148_0.counter + 1
			
			if arg_148_2 > 0 then
				table.insert(var_148_0, {
					type = "extend_state",
					target = iter_148_1.owner,
					state = iter_148_1
				})
			elseif iter_148_1.turn == 0 then
				table.insert(var_148_1, 1, iter_148_0)
			end
		end
	end
	
	for iter_148_2, iter_148_3 in pairs(var_148_1) do
		arg_148_0:removeByUId(arg_148_0.List[iter_148_3].uid, var_148_0)
	end
	
	return var_148_0
end

function StateList.removeStates(arg_149_0, arg_149_1, arg_149_2)
	arg_149_1 = arg_149_1 or 1
	
	local var_149_0 = 0
	local var_149_1 = {}
	local var_149_2 = {}
	
	for iter_149_0, iter_149_1 in pairs(arg_149_0.List) do
		if arg_149_2(iter_149_1) and arg_149_0.List[iter_149_0]:isValid() and (arg_149_0.List[iter_149_0].db.cs_preproc ~= "y" or arg_149_1 < 0) and not arg_149_0.List[iter_149_0]:isPassive() then
			table.insert(var_149_1, 1, iter_149_0)
			
			if arg_149_1 > 0 then
				var_149_0 = var_149_0 + 1
				
				if arg_149_1 <= var_149_0 then
					break
				end
			end
		end
	end
	
	local var_149_3 = {}
	
	for iter_149_2, iter_149_3 in pairs(var_149_1) do
		arg_149_0:removeByUId(arg_149_0.List[iter_149_3].uid, var_149_2, var_149_3)
	end
	
	return var_149_2, var_149_3
end

function StateList.removeAuraState(arg_150_0, arg_150_1, arg_150_2)
	for iter_150_0 = #arg_150_0.List, 1, -1 do
		arg_150_0.List[iter_150_0]:removeAuraState(arg_150_1, arg_150_2)
	end
end

function StateList.procTurn(arg_151_0, arg_151_1, arg_151_2)
	local var_151_0
	local var_151_1 = {}
	
	arg_151_1 = arg_151_1 or {}
	
	for iter_151_0 = #arg_151_0.List, 1, -1 do
		local var_151_2 = true
		
		if table.find(arg_151_1, arg_151_0.List[iter_151_0].uid) then
			var_151_2 = false
		end
		
		if var_151_2 then
			if arg_151_0.List[iter_151_0].db.cs_decreasetiming == "turn_start" then
				if arg_151_2 == false then
					var_151_2 = false
				end
			elseif arg_151_2 == true then
				var_151_2 = false
			end
		end
		
		if var_151_2 and arg_151_0.List[iter_151_0].db.cs_turn ~= 0 and not arg_151_0.List[iter_151_0]:isPassive() and arg_151_0.List[iter_151_0].db.cs_preproc ~= "y" then
			arg_151_0.List[iter_151_0]:procTurn()
			
			arg_151_0.counter = arg_151_0.counter + 1
			
			Log.d("state_turn", "지속효과 턴 감소", arg_151_0.owner.db.name, arg_151_0.List[iter_151_0].id, arg_151_0.List[iter_151_0].turn)
			
			if arg_151_0.List[iter_151_0].turn < 1 or arg_151_0.List[iter_151_0]:isInvalid() then
				arg_151_0:removeByUId(arg_151_0.List[iter_151_0].uid, var_151_1)
				
				if arg_151_0.List[iter_151_0].db.cs_finish_callback then
					local var_151_3 = string.split(arg_151_0.List[iter_151_0].db.cs_finish_callback, ",")
					
					for iter_151_1, iter_151_2 in pairs(var_151_3) do
						local var_151_4, var_151_5 = arg_151_0.owner:addState(iter_151_2, 1, arg_151_0.owner)
						
						if var_151_5 then
							table.insert(var_151_1, {
								type = "add_state",
								from = arg_151_0.owner,
								target = arg_151_0.owner,
								state = var_151_5
							})
						end
						
						local var_151_6 = var_151_5:onConcertrateEnd()
						
						table.add(var_151_1, var_151_6)
					end
				end
			end
		end
	end
	
	return var_151_1
end

function StateList.removeAfterSkill(arg_152_0, arg_152_1, arg_152_2)
	for iter_152_0, iter_152_1 in pairs(arg_152_0.List) do
		if iter_152_1:isValid() and iter_152_1.db.cs_actdepend and arg_152_2 then
			iter_152_1:setValid(false)
			
			if arg_152_0:canRemoveStateInfo(iter_152_1) then
				iter_152_1:removeState(arg_152_1)
			end
		end
	end
end

function StateList.onAddUnit(arg_153_0, arg_153_1, arg_153_2)
	for iter_153_0, iter_153_1 in pairs(arg_153_0.List) do
		if iter_153_1:isValid() then
			iter_153_1:onAddUnit(arg_153_1, arg_153_2)
		end
	end
end

function StateList.getPrioritySortedList(arg_154_0)
	local var_154_0 = {}
	
	for iter_154_0, iter_154_1 in pairs(arg_154_0.List) do
		if iter_154_1:isValid() then
			table.insert(var_154_0, iter_154_1)
		end
	end
	
	table.sort(var_154_0, function(arg_155_0, arg_155_1)
		return arg_155_0.proc_priority > arg_155_1.proc_priority
	end)
	
	return var_154_0
end

function StateList.onBeforeDead(arg_156_0, arg_156_1, arg_156_2)
	for iter_156_0, iter_156_1 in pairs(arg_156_0:getPrioritySortedList()) do
		for iter_156_2, iter_156_3 in pairs(iter_156_1:onBeforeDead(arg_156_2) or {}) do
			table.insert(arg_156_1, iter_156_3)
		end
	end
end

function StateList.onSomeoneDead(arg_157_0, arg_157_1, arg_157_2, arg_157_3)
	for iter_157_0, iter_157_1 in pairs(arg_157_0.List) do
		if not iter_157_1:isPassive() and iter_157_1:isValid() and iter_157_1:checkRemoveWhenGiverDied(arg_157_1) then
			Log.d("state", "죽어서 지속효과 풀림")
			iter_157_1:setValid(false)
			
			if arg_157_0:canRemoveStateInfo(iter_157_1) then
				iter_157_1:removeState(arg_157_3)
			end
			
			arg_157_0.counter = arg_157_0.counter + 1
		end
		
		if iter_157_1:isValid() then
			local var_157_0 = iter_157_1:onSomeoneDead(arg_157_1, arg_157_2)
			
			if var_157_0 then
				table.add(arg_157_3, var_157_0)
			end
		end
	end
end

function StateList.onCalcStatus(arg_158_0)
	local var_158_0 = table.clone(arg_158_0.owner.status)
	
	for iter_158_0, iter_158_1 in pairs(arg_158_0.List) do
		if iter_158_1:isValid() then
			iter_158_1:onCalcStatusStep1(var_158_0)
		end
	end
	
	for iter_158_2, iter_158_3 in pairs(arg_158_0.List) do
		if iter_158_3:isValid() then
			iter_158_3:onCalcStatusStep_rta(var_158_0)
		end
	end
	
	for iter_158_4, iter_158_5 in pairs(arg_158_0.List) do
		if iter_158_5:isValid() then
			iter_158_5:onCalcStatusStep_hp_debuff(var_158_0)
		end
	end
	
	for iter_158_6, iter_158_7 in pairs(arg_158_0.List) do
		if iter_158_7:isValid() then
			iter_158_7:onCalcVariablePassiveStatus(var_158_0)
		end
	end
	
	for iter_158_8, iter_158_9 in pairs(arg_158_0.List) do
		if iter_158_9:isValid() then
			iter_158_9:onCalcStatusStep2(var_158_0)
		end
	end
	
	for iter_158_10, iter_158_11 in pairs(arg_158_0.List) do
		if iter_158_11:isValid() then
			iter_158_11:onCalcStatusStep3(var_158_0)
		end
	end
	
	for iter_158_12, iter_158_13 in pairs(arg_158_0.List) do
		if iter_158_13:isValid() then
			iter_158_13:onCalcStatusStep4(var_158_0)
		end
	end
end

function StateList.canRemoveStateInfo(arg_159_0, arg_159_1)
	if not arg_159_1.effect then
		return true
	end
	
	return not table.isInclude(arg_159_0.List, function(arg_160_0, arg_160_1)
		return arg_160_1:isValid() and arg_160_1.effect == arg_159_1.effect
	end)
end

function StateList.findByEff(arg_161_0, arg_161_1)
	for iter_161_0, iter_161_1 in pairs(arg_161_0.List) do
		if iter_161_1:isValid() and iter_161_1:checkEff(arg_161_1) then
			return iter_161_1
		end
	end
end

function StateList.findByEffWithoutBlock(arg_162_0, arg_162_1)
	for iter_162_0, iter_162_1 in pairs(arg_162_0.List) do
		if iter_162_1:isValid() and iter_162_1:checkEff(arg_162_1) and not iter_162_1:isPassiveBlocked() then
			return iter_162_1
		end
	end
end

function StateList.findAllEffValues(arg_163_0, arg_163_1, arg_163_2)
	local var_163_0 = {}
	
	for iter_163_0, iter_163_1 in pairs(arg_163_0.List) do
		if iter_163_1:isValid() and (not arg_163_2 or arg_163_2 and iter_163_1.db.cs_immune_hide ~= "y") and not iter_163_1:isPassiveBlocked() then
			for iter_163_2 = 1, 6 do
				if iter_163_1.db.cs_eff[iter_163_2] == arg_163_1 then
					table.push(var_163_0, iter_163_1.db.cs_eff_value[iter_163_2])
				end
			end
		end
	end
	
	return var_163_0
end

function StateList.findBestOneByEff(arg_164_0, arg_164_1)
	local var_164_0
	local var_164_1 = 0
	
	for iter_164_0, iter_164_1 in pairs(arg_164_0.List) do
		if iter_164_1:isValid() then
			local var_164_2 = iter_164_1:checkEff(arg_164_1)
			
			if var_164_2 and not iter_164_1:isPassiveBlocked() then
				local var_164_3 = iter_164_1:getPow(var_164_2)
				
				if var_164_1 <= var_164_3 then
					var_164_0 = iter_164_1
					var_164_1 = var_164_3
				end
			end
		end
	end
	
	return var_164_0, var_164_1
end

function StateList.findBestOneByEffWithPos(arg_165_0, arg_165_1, arg_165_2)
	local var_165_0
	local var_165_1 = 0
	local var_165_2 = 999
	
	for iter_165_0, iter_165_1 in pairs(arg_165_0.List) do
		if iter_165_1:isValid() then
			local var_165_3 = iter_165_1:checkEff(arg_165_1)
			
			if var_165_3 and not iter_165_1:isPassiveBlocked() then
				local var_165_4 = iter_165_1:getPow(var_165_3)
				local var_165_5 = ((iter_165_1[arg_165_2] or {}).inst or {}).pos or 999
				
				if var_165_1 < var_165_4 or var_165_4 == var_165_1 and var_165_5 < var_165_2 then
					var_165_0 = iter_165_1
					var_165_1 = var_165_4
					var_165_2 = var_165_5
				end
			end
		end
	end
	
	return var_165_0, var_165_1
end

function StateList.getResourceRateValue(arg_166_0)
	local var_166_0 = 1
	
	for iter_166_0, iter_166_1 in pairs(arg_166_0.List) do
		if iter_166_1:isValid() and not iter_166_1:isPassiveBlocked() then
			local var_166_1 = iter_166_1:checkEff("RESOURCE_UP_INCREASE")
			local var_166_2 = iter_166_1:checkEff("RESOURCE_UP_DECREASE")
			
			if var_166_1 or var_166_2 then
				if var_166_1 then
					local var_166_3 = totable(iter_166_1:getPow(var_166_1))
					local var_166_4 = var_166_3.resource
					
					if not var_166_4 or var_166_4 == arg_166_0.owner:getSPName() then
						var_166_0 = var_166_0 + to_n(var_166_3.rate)
					end
				end
				
				if var_166_2 then
					local var_166_5 = totable(iter_166_1:getPow(var_166_2))
					local var_166_6 = var_166_5.resource
					
					if not var_166_6 or var_166_6 == arg_166_0.owner:getSPName() then
						var_166_0 = var_166_0 - to_n(var_166_5.rate)
					end
				end
			end
		end
	end
	
	return math.max(0, var_166_0)
end

function StateList.getSumEffValue(arg_167_0, arg_167_1, arg_167_2)
	local var_167_0 = 0
	
	for iter_167_0, iter_167_1 in pairs(arg_167_0.List) do
		if iter_167_1:isValid() then
			local var_167_1 = iter_167_1:checkEff(arg_167_1)
			
			if var_167_1 and not iter_167_1:isPassiveBlocked() then
				local var_167_2 = iter_167_1:getPow(var_167_1)
				
				if arg_167_2 and type(arg_167_2) == "function" then
					var_167_2 = arg_167_2(var_167_2)
				end
				
				var_167_0 = var_167_0 + to_n(var_167_2)
			end
		end
	end
	
	return var_167_0
end

function StateList.getEffValue(arg_168_0, arg_168_1)
	for iter_168_0, iter_168_1 in pairs(arg_168_0.List) do
		if iter_168_1:isValid() then
			local var_168_0 = iter_168_1:getEffValue(arg_168_1)
			
			if var_168_0 then
				return var_168_0
			end
		end
	end
end

function StateList.find(arg_169_0, arg_169_1)
	for iter_169_0, iter_169_1 in pairs(arg_169_0.List) do
		if iter_169_1:isValid() and (iter_169_1:getId() == arg_169_1 or tostring(iter_169_1:getId()) == arg_169_1) then
			return iter_169_1
		end
	end
end

function StateList.findByGUId(arg_170_0, arg_170_1)
	for iter_170_0, iter_170_1 in pairs(arg_170_0.List) do
		if iter_170_1:isValid() and iter_170_1:getGUId() == arg_170_1 then
			return iter_170_1
		end
	end
end

function StateList.findByUId(arg_171_0, arg_171_1)
	for iter_171_0, iter_171_1 in pairs(arg_171_0.List) do
		if iter_171_1:isValid() and iter_171_1:getUId() == arg_171_1 then
			return iter_171_1
		end
	end
end

function StateList.findById(arg_172_0, arg_172_1)
	for iter_172_0, iter_172_1 in pairs(arg_172_0.List) do
		if iter_172_1:isValid() and iter_172_1:getId() == arg_172_1 then
			return iter_172_1
		end
	end
end

function StateList.getCount(arg_173_0, arg_173_1)
	local var_173_0 = 0
	
	for iter_173_0, iter_173_1 in pairs(arg_173_0.List) do
		if iter_173_1:isValid() and (not iter_173_1:isPassive() or arg_173_1) then
			var_173_0 = var_173_0 + 1
		end
	end
	
	return var_173_0
end

function StateList.getCountByShowType(arg_174_0)
	local var_174_0 = 0
	
	for iter_174_0, iter_174_1 in pairs(arg_174_0.List) do
		if iter_174_1:isValid() and iter_174_1.db.isshow == "y" then
			var_174_0 = var_174_0 + 1
		end
	end
	
	return var_174_0
end

function StateList.getTypeCount(arg_175_0, arg_175_1)
	local var_175_0 = 0
	
	for iter_175_0, iter_175_1 in pairs(arg_175_0.List) do
		if iter_175_1:isValid() and iter_175_1:isType(arg_175_1) then
			var_175_0 = var_175_0 + 1
		end
	end
	
	return var_175_0
end

function StateList.getRemovableTypeCount(arg_176_0, arg_176_1)
	local var_176_0 = 0
	
	for iter_176_0, iter_176_1 in pairs(arg_176_0.List) do
		if iter_176_1:isValid() and iter_176_1:isType(arg_176_1) and iter_176_1:canRemove() then
			var_176_0 = var_176_0 + 1
		end
	end
	
	return var_176_0
end

function StateList.getGroupCount(arg_177_0, arg_177_1)
	local var_177_0 = 0
	
	for iter_177_0, iter_177_1 in pairs(arg_177_0.List) do
		if iter_177_1:isValid() and iter_177_1:isGroup(arg_177_1) then
			var_177_0 = var_177_0 + 1
		end
	end
	
	return var_177_0
end

function StateList.canRemove(arg_178_0)
	for iter_178_0, iter_178_1 in pairs(arg_178_0.List) do
		if iter_178_1:isValid() and iter_178_1:canRemove() then
			return true
		end
	end
	
	return false
end

function StateList.onToggle(arg_179_0, arg_179_1, arg_179_2)
	local var_179_0 = {}
	
	for iter_179_0, iter_179_1 in pairs(arg_179_0.List) do
		if iter_179_1:isValid() then
			local var_179_1 = iter_179_1:onToggle(arg_179_1, arg_179_2)
			
			if var_179_1 then
				table.add(var_179_0, var_179_1)
			end
		end
	end
	
	return var_179_0
end

function StateList.onEndTurn(arg_180_0, arg_180_1)
	local var_180_0 = {}
	
	for iter_180_0, iter_180_1 in pairs(arg_180_0.List) do
		if iter_180_1:isValid() then
			local var_180_1 = iter_180_1:onEndTurn(arg_180_1)
			
			if var_180_1 then
				table.add(var_180_0, var_180_1)
			end
		end
	end
	
	return var_180_0
end

function StateList.onTurnEndAfter(arg_181_0, arg_181_1)
	local var_181_0 = {}
	
	for iter_181_0, iter_181_1 in pairs(arg_181_0.List) do
		if iter_181_1:isValid() then
			local var_181_1 = iter_181_1:onTurnEndAfter(arg_181_1)
			
			if var_181_1 then
				table.add(var_181_0, var_181_1)
			end
		end
	end
	
	return var_181_0
end

function StateList.sort(arg_182_0)
	table.sort(arg_182_0.List, function(arg_183_0, arg_183_1)
		if arg_183_0.db.cs_type ~= arg_183_1.db.cs_type then
			if arg_183_0:isPassive() then
				return true
			end
			
			if arg_183_1:isPassive() then
				return false
			end
			
			if arg_183_0.db.cs_type == "buff" then
				return true
			end
			
			if arg_183_1.db.cs_type == "buff" then
				return false
			end
			
			return false
		end
		
		if arg_182_0.owner.logic:isViewPlayerActive() and arg_183_0.net_idx and arg_183_1.net_idx then
			return arg_183_0.net_idx < arg_183_1.net_idx
		end
		
		return arg_183_0:getRestTurn() > arg_183_1:getRestTurn()
	end)
end

function StateList.onEnterMap(arg_184_0, arg_184_1)
	local var_184_0 = {}
	
	for iter_184_0, iter_184_1 in pairs(arg_184_0.List) do
		if iter_184_1:isValid() then
			local var_184_1 = iter_184_1:onEnterMap(arg_184_1)
			
			if var_184_1 then
				table.add(var_184_0, var_184_1)
			end
		end
	end
	
	return var_184_0
end

function StateList.onStartStage(arg_185_0, arg_185_1, arg_185_2)
	local var_185_0 = {}
	
	for iter_185_0, iter_185_1 in pairs(arg_185_0.List) do
		if iter_185_1:isValid() then
			local var_185_1 = iter_185_1:onStartStage(arg_185_1, arg_185_2)
			
			if var_185_1 then
				table.add(var_185_0, var_185_1)
			end
		end
	end
	
	return var_185_0
end

function StateList.onStartTurn(arg_186_0, arg_186_1, arg_186_2)
	local var_186_0 = {}
	
	for iter_186_0, iter_186_1 in pairs(arg_186_0.List) do
		if iter_186_1:isValid() then
			local var_186_1 = iter_186_1:onStartTurn(arg_186_1, arg_186_2)
			
			if var_186_1 then
				table.add(var_186_0, var_186_1)
			end
		end
	end
	
	return var_186_0
end

function StateList.startTurn(arg_187_0, arg_187_1)
	local var_187_0
	
	for iter_187_0 = #arg_187_0.List, 1, -1 do
		if arg_187_0.List[iter_187_0].cool > 0 then
			arg_187_0.List[iter_187_0].cool = arg_187_0.List[iter_187_0].cool - 1
		end
		
		if arg_187_0.List[iter_187_0]:isPreproc() then
			arg_187_0.List[iter_187_0]:procTurn()
			
			if (arg_187_0.List[iter_187_0].turn < 1 or arg_187_0.List[iter_187_0]:isInvalid()) and arg_187_0.List[iter_187_0].db.cs_finish_callback then
				local var_187_1 = arg_187_0.List[iter_187_0].db.cs_preproc == "y"
				local var_187_2 = arg_187_0.List[iter_187_0].db.cs_finish_callback
				
				table.insert(arg_187_1, {
					type = "state_finish_call",
					state = arg_187_0.List[iter_187_0].id,
					target = arg_187_0.List[iter_187_0].owner,
					isPreProc = var_187_1,
					call = var_187_2,
					isValid = arg_187_0.List[iter_187_0]:isValid()
				})
			end
		end
		
		local var_187_3 = arg_187_0.List[iter_187_0].turn < 1
		
		if not arg_187_0.List[iter_187_0]:isPassive() and (var_187_3 or arg_187_0.List[iter_187_0]:isInvalid()) then
			var_187_0 = true
			
			if arg_187_0:canRemoveStateInfo(arg_187_0.List[iter_187_0]) then
				if var_187_3 then
					Log.d("state", "턴이 끝나서 지속 풀림", arg_187_0.owner.db.name, arg_187_0.List[iter_187_0].id)
					arg_187_0.List[iter_187_0]:removeState(arg_187_1)
				else
					Log.d("state", "기타 사유로 지속 풀림", arg_187_0.owner.db.name, arg_187_0.List[iter_187_0].id)
					arg_187_0.List[iter_187_0]:removeState(arg_187_1)
				end
			end
			
			table.remove(arg_187_0.List, iter_187_0)
		end
	end
	
	if var_187_0 then
		arg_187_0.owner:calc()
		
		arg_187_0.counter = arg_187_0.counter + 1
	end
	
	Log.d("state", "------------------------------------------------------------------")
	Log.d("state", "지속효과 리스트 ", arg_187_0.owner.db.name)
	
	for iter_187_1, iter_187_2 in pairs(arg_187_0.List) do
		Log.d("state", "uid: " .. iter_187_2.uid, "id: " .. iter_187_2.id, "turn: " .. iter_187_2.turn, "isPassive : ", iter_187_2:isPassive(), "stack: " .. iter_187_2.stack_count)
	end
	
	Log.d("state", "------------------------------------------------------------------")
end

function StateList.onCalcDamage(arg_188_0, arg_188_1, arg_188_2, arg_188_3, arg_188_4, arg_188_5, arg_188_6, arg_188_7, arg_188_8)
	local var_188_0 = {}
	
	for iter_188_0, iter_188_1 in pairs(arg_188_0.List) do
		if iter_188_1:isValid() then
			local var_188_1 = iter_188_1:onCalcDamage(arg_188_1, arg_188_2, arg_188_3, arg_188_4, arg_188_5, arg_188_6, arg_188_7, arg_188_8)
			
			if var_188_1 then
				table.add(var_188_0, var_188_1)
			end
		end
	end
	
	return var_188_0
end

function StateList.getShieldDecreaseRate(arg_189_0)
	local var_189_0 = 0
	
	for iter_189_0, iter_189_1 in pairs(arg_189_0.List) do
		if iter_189_1:isValid() then
			local var_189_1 = iter_189_1.db.cs_passiveblock == "y" and arg_189_0.owner:isPassiveBlock()
			local var_189_2 = iter_189_1:checkEff("CSP_SHIELD_DECREASE")
			
			if var_189_2 and not var_189_1 then
				local var_189_3 = iter_189_1:getPow(var_189_2)
				
				if var_189_0 < to_n(var_189_3) then
					var_189_0 = to_n(var_189_3)
				end
			end
		end
	end
	
	return var_189_0
end

function StateList.getShield(arg_190_0)
	local var_190_0 = 0
	
	for iter_190_0, iter_190_1 in pairs(arg_190_0.List) do
		if iter_190_1:isValid() and iter_190_1:isBarrier() then
			var_190_0 = var_190_0 + iter_190_1.value
		end
	end
	
	return var_190_0
end

function StateList.getMaxShield(arg_191_0)
	local var_191_0 = 0
	
	for iter_191_0, iter_191_1 in pairs(arg_191_0.List) do
		if iter_191_1:isValid() and iter_191_1:isBarrier() then
			var_191_0 = var_191_0 + iter_191_1.start_value
		end
	end
	
	return var_191_0
end

function StateList.decShield(arg_192_0, arg_192_1, arg_192_2, arg_192_3)
	arg_192_3 = arg_192_3 or 0
	
	local var_192_0 = arg_192_0:getShield()
	
	if var_192_0 > 0 then
		local var_192_1 = math.min(var_192_0, arg_192_2)
		local var_192_2 = var_192_1
		local var_192_3
		
		for iter_192_0 = #arg_192_0.List, 1, -1 do
			local var_192_4 = arg_192_0.List[iter_192_0]
			
			if var_192_4:isValid() and var_192_4:isBarrier() and var_192_4.value > 0 then
				local var_192_5 = math.min(var_192_2, var_192_4.value)
				
				var_192_4.value = var_192_4.value - var_192_5
				var_192_2 = var_192_2 - var_192_5
				
				table.insert(arg_192_1, {
					type = "shield",
					state = var_192_4,
					from = var_192_4.giver,
					target = var_192_4.owner,
					shield = var_192_5
				})
				
				if var_192_4.value <= 0 then
					Log.d("state", "방어막 깨져서 지속효과 풀림")
					var_192_4:setValid(false)
					
					if arg_192_0:canRemoveStateInfo(var_192_4) then
						var_192_4:removeState(arg_192_1)
					end
					
					arg_192_0.counter = arg_192_0.counter + 1
				end
				
				if var_192_2 <= 0 then
					break
				end
			end
		end
		
		return math.floor(var_192_1)
	end
	
	return nil
end

function StateList.getAntiSkillDamage(arg_193_0)
	local var_193_0 = 0
	
	for iter_193_0, iter_193_1 in pairs(arg_193_0.List) do
		if iter_193_1:isValid() and iter_193_1:isAntiSkillDamage() then
			var_193_0 = var_193_0 + iter_193_1.value
		end
	end
	
	return var_193_0
end

function StateList.decAntiDamageCount(arg_194_0, arg_194_1)
	if arg_194_0:getAntiSkillDamage() > 0 then
		local var_194_0
		
		for iter_194_0 = #arg_194_0.List, 1, -1 do
			local var_194_1 = arg_194_0.List[iter_194_0]
			
			if var_194_1:isValid() and var_194_1:isAntiSkillDamage() and var_194_1.value > 0 then
				var_194_1.value = var_194_1.value - 1
				
				table.insert(arg_194_1, {
					type = "antiskilldamage",
					state = var_194_1,
					from = var_194_1.giver,
					target = var_194_1.owner
				})
				
				if var_194_1.value <= 0 then
					Log.d("state", "스킬데미지 무효 효과 종료")
					var_194_1:setValid(false)
					
					if arg_194_0:canRemoveStateInfo(var_194_1) then
						var_194_1:removeState(arg_194_1)
					end
					
					arg_194_0.counter = arg_194_0.counter + 1
				end
			end
		end
	end
end

function StateList.onDebuffExplosion(arg_195_0, arg_195_1)
	arg_195_1 = arg_195_1 or {}
	
	local var_195_0 = {}
	local var_195_1 = totable(arg_195_1.pow or {})
	local var_195_2 = var_195_1.target
	
	if type(var_195_2) == "string" then
		var_195_2 = (string.lower(var_195_2) ~= "all" or nil) and {
			var_195_2
		}
	end
	
	local var_195_3 = var_195_1.increase or 0
	
	local function var_195_4(arg_196_0)
		if var_195_2 and not table.isInclude(var_195_2, arg_196_0:getId()) then
			return false
		end
		
		for iter_196_0, iter_196_1 in pairs(arg_195_1.candidates or {}) do
			if arg_196_0:checkEff(iter_196_1) then
				return true
			end
		end
		
		return false
	end
	
	local var_195_5 = false
	
	for iter_195_0, iter_195_1 in pairs(arg_195_0.List) do
		if iter_195_1:isValid() and var_195_4(iter_195_1) then
			local var_195_6 = iter_195_1:onDebuffExplosion(var_195_3)
			
			if var_195_6 then
				var_195_5 = true
				
				table.add(var_195_0, var_195_6)
			end
			
			arg_195_0.counter = arg_195_0.counter + 1
			
			iter_195_1:setValid(false)
			
			if arg_195_0.owner.states:canRemoveStateInfo(iter_195_1) then
				iter_195_1:removeState(var_195_0)
			end
		end
	end
	
	if var_195_5 then
		table.insert(var_195_0, {
			text = "bf_explosion_debuff",
			type = "text",
			target = arg_195_0.owner
		})
	end
	
	return var_195_0
end

function StateList.getOnAttackCriticalDamageRatio(arg_197_0)
	local var_197_0 = 0
	
	for iter_197_0, iter_197_1 in pairs(arg_197_0.List) do
		if iter_197_1:isValid() then
			var_197_0 = var_197_0 + iter_197_1:getOnAttackCriticalDamageRatio()
		end
	end
	
	return var_197_0
end

function StateList.onCalcExtinct(arg_198_0, arg_198_1, arg_198_2)
	if not arg_198_1 or arg_198_1 == "" then
		return 
	end
	
	local var_198_0
	
	for iter_198_0 = #arg_198_0.List, 1, -1 do
		local var_198_1 = arg_198_0.List[iter_198_0]
		
		if var_198_1:isValid() and var_198_1.db.cs_type ~= "passive" and var_198_1.db.cs_extinct then
			local var_198_2 = string.split(var_198_1.db.cs_extinct, ",")
			
			for iter_198_1, iter_198_2 in pairs(var_198_2 or {}) do
				if iter_198_2 == arg_198_1 then
					arg_198_2 = arg_198_2 or {}
					
					var_198_1:setValid(false)
					Log.d("state", "종료조건으로 인해 다음 시작 턴에 지속효과 풀릴 예정", var_198_1.owner.db.name, var_198_1.id, arg_198_1)
					
					if var_198_1.db.cs_stop_callback then
						local var_198_3 = string.split(var_198_1.db.cs_stop_callback, ",")
						
						for iter_198_3, iter_198_4 in pairs(var_198_3) do
							local var_198_4, var_198_5 = arg_198_0.owner:addState(iter_198_4, 1, arg_198_0.owner)
							
							if var_198_5 then
								table.insert(arg_198_2, {
									type = "add_state",
									from = arg_198_0.owner,
									target = arg_198_0.owner,
									state = var_198_5
								})
							end
							
							local var_198_6 = var_198_5:onConcertrateEnd()
							
							table.add(arg_198_2, var_198_6)
						end
					end
				end
			end
		end
	end
	
	if var_198_0 then
		arg_198_0.owner:calc()
		
		arg_198_0.counter = arg_198_0.counter + 1
	end
	
	return arg_198_2
end

function StateList.checkFinishCallback(arg_199_0, arg_199_1)
	for iter_199_0 = #arg_199_0.List, 1, -1 do
		if arg_199_0.List[iter_199_0].db.cs_turn ~= 0 and arg_199_0.List[iter_199_0].db.cs_type ~= "passive" and arg_199_0.List[iter_199_0].turn == 1 and arg_199_0.List[iter_199_0]:isValid() and arg_199_0.List[iter_199_0].db.cs_finish_callback then
			local var_199_0 = arg_199_0.List[iter_199_0].db.cs_preproc == "y"
			local var_199_1 = arg_199_0.List[iter_199_0].db.cs_finish_callback
			
			if (arg_199_1 or false) == var_199_0 then
				return {
					isPreProc = var_199_0,
					call = var_199_1
				}
			end
		end
	end
end

function StateList.onAfterDamage(arg_200_0, arg_200_1, arg_200_2)
	arg_200_2 = arg_200_2 or {}
	
	for iter_200_0, iter_200_1 in pairs(arg_200_0.List) do
		if iter_200_1:isValid() and arg_200_2.skill_id and (iter_200_1:checkEff("CSP_SLEEP") or iter_200_1:checkEff("CSP_STEALTH")) then
			arg_200_0.counter = arg_200_0.counter + 1
			
			iter_200_1:setValid(false)
			
			if arg_200_0.owner.states:canRemoveStateInfo(iter_200_1) then
				iter_200_1:removeState(arg_200_1)
			end
		end
	end
end

function StateList.onPreBeforeDamage(arg_201_0, arg_201_1, arg_201_2, arg_201_3, arg_201_4, arg_201_5, arg_201_6, arg_201_7)
	local var_201_0 = {}
	
	for iter_201_0, iter_201_1 in pairs(arg_201_0.List) do
		if iter_201_1:isValid() then
			local var_201_1 = iter_201_1:onPreBeforeDamage(arg_201_1, arg_201_2, arg_201_3, arg_201_4, arg_201_5, arg_201_6, arg_201_7)
			
			if var_201_1 then
				table.add(var_201_0, var_201_1)
			end
		end
	end
	
	return var_201_0
end

function StateList.onBeforeDamage(arg_202_0, arg_202_1, arg_202_2, arg_202_3, arg_202_4, arg_202_5, arg_202_6, arg_202_7)
	local var_202_0 = {}
	
	for iter_202_0, iter_202_1 in pairs(arg_202_0.List) do
		if iter_202_1:isValid() then
			local var_202_1 = iter_202_1:onBeforeDamage(arg_202_1, arg_202_2, arg_202_3, arg_202_4, arg_202_5, arg_202_6, arg_202_7)
			
			if var_202_1 then
				table.add(var_202_0, var_202_1)
			end
		end
	end
	
	return var_202_0
end

function StateList.onBeforeModifiedDamage(arg_203_0, arg_203_1, arg_203_2, arg_203_3, arg_203_4, arg_203_5, arg_203_6, arg_203_7)
	local var_203_0 = {}
	
	for iter_203_0, iter_203_1 in pairs(arg_203_0.List) do
		if iter_203_1:isValid() then
			local var_203_1 = iter_203_1:onBeforeModifiedDamage(arg_203_1, arg_203_2, arg_203_3, arg_203_4, arg_203_5, arg_203_6, arg_203_7)
			
			if var_203_1 then
				table.add(var_203_0, var_203_1)
			end
		end
	end
	
	return var_203_0
end

function StateList.onAfterAttacked(arg_204_0, arg_204_1, arg_204_2, arg_204_3, arg_204_4)
	local var_204_0 = {}
	
	for iter_204_0, iter_204_1 in pairs(arg_204_0.List) do
		if iter_204_1:isValid() then
			local var_204_1 = iter_204_1:onAfterAttacked(arg_204_1, arg_204_2, arg_204_3, arg_204_4)
			
			if var_204_1 then
				table.join(var_204_0, var_204_1)
			end
			
			local var_204_2 = iter_204_1:checkEff("CSP_REFLECT_DMG")
			
			if var_204_2 and arg_204_4 and arg_204_0.owner and arg_204_0.owner == arg_204_1 and arg_204_0.owner:skillDamageTag(arg_204_4) and not iter_204_1:isPassiveBlocked() then
				local var_204_3 = iter_204_1:getPow(var_204_2)
				local var_204_4 = arg_204_0.owner:skillDamageTag(arg_204_4)
				
				if iter_204_1:checkStateCondition(var_204_4.skill_id, arg_204_0.owner, var_204_4.miss, var_204_4.critical, var_204_4.smite, arg_204_4) then
					local var_204_5 = var_204_4.damage
					local var_204_6 = math.min(var_204_5 * var_204_3, arg_204_0.owner:getMaxHP())
					local var_204_7 = math.floor(var_204_6)
					local var_204_8
					local var_204_9
					local var_204_10, var_204_11, var_204_12 = arg_204_4:decHP(var_204_0, var_204_7, {
						ignore_relection = true
					})
					
					table.insert(var_204_0, {
						type = "attack",
						reflect = true,
						cur_hit = 1,
						tot_hit = 1,
						from = iter_204_1.giver,
						target = arg_204_4,
						damage = var_204_10,
						shield = var_204_11,
						dec_hp = var_204_12
					})
					table.insert(var_204_0, 1, {
						type = "invoke_passive",
						target = iter_204_1.owner,
						state = iter_204_1,
						text = iter_204_1.db.name
					})
				end
			end
		end
	end
	
	return var_204_0
end

function StateList.onAfterAttacked_ContainDead(arg_205_0, arg_205_1, arg_205_2, arg_205_3, arg_205_4)
	local var_205_0 = {}
	
	for iter_205_0, iter_205_1 in pairs(arg_205_0.List) do
		if iter_205_1:isValid() then
			local var_205_1 = iter_205_1:onAfterAttacked_ContainDead(arg_205_1, arg_205_2, arg_205_3, arg_205_4)
			
			if var_205_1 then
				table.join(var_205_0, var_205_1)
			end
		end
	end
	
	return var_205_0
end

function StateList.onBeforeSkillDamage(arg_206_0, arg_206_1, arg_206_2, arg_206_3, arg_206_4, arg_206_5, arg_206_6)
	local var_206_0 = {}
	
	for iter_206_0, iter_206_1 in pairs(arg_206_0.List) do
		if iter_206_1:isValid() then
			local var_206_1 = iter_206_1:onBeforeSkillDamage(arg_206_1, arg_206_2, arg_206_3, arg_206_4, arg_206_5, arg_206_6)
			
			if var_206_1 then
				table.join(var_206_0, var_206_1)
			end
		end
	end
	
	return var_206_0
end

function StateList.onAfterSkill(arg_207_0, arg_207_1, arg_207_2, arg_207_3, arg_207_4, arg_207_5, arg_207_6)
	local var_207_0 = {}
	
	for iter_207_0, iter_207_1 in pairs(arg_207_0.List) do
		if iter_207_1:isValid() then
			local var_207_1 = iter_207_1:onAfterSkill(arg_207_1, arg_207_2, arg_207_3, arg_207_4, arg_207_5, arg_207_6)
			
			if var_207_1 then
				table.join(var_207_0, var_207_1)
			end
		end
	end
	
	return var_207_0
end

function StateList.onAfterEffects(arg_208_0, arg_208_1, arg_208_2, arg_208_3, arg_208_4, arg_208_5, arg_208_6, arg_208_7)
	local var_208_0 = {}
	
	for iter_208_0, iter_208_1 in pairs(arg_208_0.List) do
		if iter_208_1:isValid() then
			local var_208_1 = iter_208_1["onAfterEffects_step_" .. arg_208_1]
			
			if var_208_1 then
				local var_208_2 = var_208_1(iter_208_1, arg_208_2, arg_208_3, arg_208_4, arg_208_5, arg_208_6, arg_208_7)
				
				if var_208_2 then
					table.join(var_208_0, var_208_2)
				end
			end
		end
	end
	
	return var_208_0
end

function StateList.onSimilarDamageFinished(arg_209_0, arg_209_1, arg_209_2, arg_209_3, arg_209_4, arg_209_5, arg_209_6)
	local var_209_0 = {}
	
	for iter_209_0, iter_209_1 in pairs(arg_209_0.List) do
		if iter_209_1:isValid() then
			local var_209_1 = iter_209_1:onSimilarDamageFinished(arg_209_1, arg_209_2, arg_209_3, arg_209_4, arg_209_5, arg_209_6)
			
			if var_209_1 then
				table.join(var_209_0, var_209_1)
			end
		end
	end
	
	return var_209_0
end

function StateList.onDamageFinished(arg_210_0, arg_210_1, arg_210_2, arg_210_3, arg_210_4, arg_210_5, arg_210_6)
	local var_210_0 = {}
	
	for iter_210_0, iter_210_1 in pairs(arg_210_0.List) do
		if iter_210_1:isValid() then
			local var_210_1 = iter_210_1:onDamageFinished(arg_210_1, arg_210_2, arg_210_3, arg_210_4, arg_210_5, arg_210_6)
			
			if var_210_1 then
				table.join(var_210_0, var_210_1)
			end
		end
	end
	
	return var_210_0
end

function StateList.onDamageFinishedAll(arg_211_0, arg_211_1, arg_211_2, arg_211_3, arg_211_4)
	local var_211_0 = {}
	
	for iter_211_0, iter_211_1 in pairs(arg_211_0.List) do
		if iter_211_1:isValid() then
			local var_211_1 = iter_211_1:onDamageFinishedAll(arg_211_1, arg_211_2, arg_211_3, arg_211_4)
			
			if var_211_1 then
				table.join(var_211_0, var_211_1)
			end
		end
	end
	
	return var_211_0
end

function StateList.onAfterResurrect(arg_212_0, arg_212_1)
	arg_212_1 = arg_212_1 or {}
	
	for iter_212_0, iter_212_1 in pairs(arg_212_0.List) do
		if iter_212_1:isValid() then
			local var_212_0 = iter_212_1:onAfterResurrect(arg_212_0.owner)
			
			if var_212_0 then
				table.add(arg_212_1, var_212_0)
			end
		end
	end
	
	return arg_212_1
end

function StateList.onResurrectNotify(arg_213_0, arg_213_1)
	local var_213_0 = {}
	
	for iter_213_0, iter_213_1 in pairs(arg_213_0.List) do
		if iter_213_1:isValid() then
			local var_213_1 = iter_213_1:onResurrectNotify(arg_213_1)
			
			if var_213_1 then
				table.add(var_213_0, var_213_1)
			end
		end
	end
	
	return var_213_0
end

function StateList.getPassiveSkillState(arg_214_0, arg_214_1)
	for iter_214_0, iter_214_1 in pairs(arg_214_0.List) do
		if iter_214_1:isValid() and iter_214_1.skill_id == arg_214_1 then
			return iter_214_1
		end
	end
end

function StateList.getPassiveSkillCool(arg_215_0, arg_215_1)
	local var_215_0 = arg_215_0:getPassiveSkillState(arg_215_1)
	
	if var_215_0 then
		return var_215_0.cool
	end
end

function StateList.getPassiveSkillMaxCool(arg_216_0, arg_216_1)
	local var_216_0 = arg_216_0:getPassiveSkillState(arg_216_1)
	
	if var_216_0 then
		return var_216_0.max_cool
	end
end

function StateList.setPassiveSkillCool(arg_217_0, arg_217_1, arg_217_2)
	local var_217_0 = arg_217_0:getPassiveSkillState(arg_217_1)
	
	if var_217_0 and var_217_0.db.cs_cooltimeinc == "y" then
		var_217_0.cool = arg_217_2
	end
end

function StateList.onPreCalcDamage(arg_218_0, arg_218_1, arg_218_2, arg_218_3, arg_218_4, arg_218_5, arg_218_6)
	for iter_218_0, iter_218_1 in pairs(arg_218_0.List) do
		local var_218_0 = iter_218_1:isPassiveBlocked()
		
		if iter_218_1:isValid() and not var_218_0 then
			local var_218_1 = false
			
			for iter_218_2 = 1, 6 do
				local var_218_2 = iter_218_1.db.cs_eff[iter_218_2]
				
				if var_218_2 and string.starts(var_218_2, "BF_") and iter_218_1:checkStateCondition(arg_218_3, arg_218_4, nil, nil, nil, arg_218_2) then
					local var_218_3 = iter_218_1:getPow(iter_218_2) or 1
					
					if SkillProc.procPreCalcDamage(arg_218_1, var_218_2, var_218_3, arg_218_2, arg_218_4, arg_218_5, arg_218_6, arg_218_3) then
						var_218_1 = true
					end
				end
			end
			
			if var_218_1 then
				table.insert(arg_218_1, 1, {
					type = "invoke_passive",
					target = iter_218_1.owner,
					state = iter_218_1,
					text = iter_218_1.db.name
				})
			end
		end
	end
end

function StateList.onPreCalcTarget(arg_219_0, arg_219_1, arg_219_2, arg_219_3, arg_219_4, arg_219_5, arg_219_6)
	for iter_219_0, iter_219_1 in pairs(arg_219_0.List) do
		if iter_219_1:isValid() then
			local var_219_0 = false
			
			for iter_219_2 = 1, 6 do
				local var_219_1 = iter_219_1.db.cs_eff[iter_219_2]
				
				if var_219_1 and string.starts(var_219_1, "DBF_") and iter_219_1:checkStateCondition(arg_219_3, arg_219_4, nil, nil, nil, arg_219_2) then
					local var_219_2 = iter_219_1:getPow(iter_219_2) or 1
					
					if SkillProc.procPreCalcTarget(arg_219_1, var_219_1, var_219_2, arg_219_2, arg_219_4, arg_219_5, arg_219_6) then
						var_219_0 = true
					end
				end
			end
			
			if var_219_0 then
				table.insert(arg_219_1, 1, {
					type = "invoke_passive",
					target = iter_219_1.owner,
					state = iter_219_1,
					text = iter_219_1.db.name
				})
			end
		end
	end
end

function StateList.isImmuneEff(arg_220_0, arg_220_1)
	for iter_220_0, iter_220_1 in pairs(arg_220_0.List) do
		if iter_220_1:isValid() then
			local var_220_0, var_220_1, var_220_2 = iter_220_1:isImmuneEff(arg_220_1)
			
			if var_220_0 then
				return var_220_0, var_220_2
			end
		end
	end
end
