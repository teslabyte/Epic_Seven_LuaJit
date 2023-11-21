SkillProc = {}
SkillProc.effs = {}
SkillProc.state_conds = {}

function SkillProc.onAfterAllEffect(arg_1_0, arg_1_1)
	if arg_1_1.turn_vars.transferred_cs then
		for iter_1_0, iter_1_1 in pairs(arg_1_1.turn_vars.transferred_cs) do
			iter_1_0:setValid(false)
			
			if arg_1_1.states:canRemoveStateInfo(iter_1_0) then
				iter_1_0:removeState(arg_1_0)
			end
		end
		
		arg_1_1:calc()
	end
end

function SkillProc.procEffect(arg_2_0, arg_2_1)
	if arg_2_1.state then
		arg_2_1.giver_status = arg_2_1.state.giver_status
	end
	
	arg_2_1.from = arg_2_1.giver or arg_2_1.owner or arg_2_1.attacker
	
	if not CS_Util.isApplyStateOnlyHeroByEff(arg_2_1.eff, arg_2_1.pow, arg_2_1.eff_target) then
		return 
	end
	
	local var_2_0, var_2_1 = arg_2_1.eff_target:isImmuneEff(arg_2_1.eff)
	local var_2_2, var_2_3 = arg_2_1.eff_target:isBlock_Eff(arg_2_1.eff)
	
	if var_2_0 or var_2_2 then
		if var_2_1 ~= "y" and var_2_3 ~= "y" then
			table.insert(arg_2_0, {
				type = "immune",
				target = arg_2_1.eff_target
			})
		end
		
		return true
	end
	
	local var_2_4 = SkillProc.effs[arg_2_1.eff]
	
	if string.starts(arg_2_1.eff, "CS_ADD_SHIELD") then
		var_2_4 = SkillProc.effs.CS_ADD_SHIELD
	end
	
	if not var_2_4 then
		return 
	end
	
	if not DB("skill_immune", tostring(arg_2_1.eff), "id") and PLATFORM == "win32" and not IS_TOOL_MODE then
		Log.e(string.format("면역 등록되어있지 않은 스킬 효과. : %s", arg_2_1.eff))
		__G__TRACKBACK__("unregistered immune Eff :" .. arg_2_1.eff)
	end
	
	local var_2_5 = var_2_4(arg_2_0, arg_2_1)
	
	if var_2_5 then
		table.insert(arg_2_0, {
			type = "skill_eff",
			eff = arg_2_1.eff,
			target = arg_2_1.eff_target
		})
	end
	
	return var_2_5
end

function SkillProc.effs.HPUP_TARGET_MAXHP(arg_3_0, arg_3_1)
	local var_3_0 = math.max(1, math.floor(arg_3_1.pow * arg_3_1.eff_target:getMaxHP()))
	local var_3_1 = arg_3_1.eff_target:heal(var_3_0)
	
	if var_3_1 > 0 then
		table.insert(arg_3_0, {
			type = "heal",
			from = arg_3_1.from,
			target = arg_3_1.eff_target,
			heal = var_3_1
		})
		
		return true
	end
end

function SkillProc.effs.HPUP_TARGET_MAXHP_ABSOLUTE(arg_4_0, arg_4_1)
	local var_4_0 = math.max(1, math.floor(arg_4_1.pow * arg_4_1.eff_target:getMaxHP()))
	local var_4_1 = arg_4_1.eff_target:heal(var_4_0, true)
	
	if var_4_1 > 0 then
		table.insert(arg_4_0, {
			type = "heal",
			from = arg_4_1.from,
			target = arg_4_1.eff_target,
			heal = var_4_1
		})
		
		return true
	end
end

function SkillProc.effs.AB_UP_SKADDEFFCOUNT(arg_5_0, arg_5_1)
	if not arg_5_1.attacker then
		return 
	end
	
	local var_5_0 = args_to_hash(arg_5_1.pow)
	local var_5_1 = tonumber(string.sub(var_5_0.abup, 1, -2)) / 100 * MAX_UNIT_TICK
	local var_5_2 = to_n(arg_5_1.attacker.turn_vars.eff_counts[tonumber(string.sub(var_5_0.effid, -1, -1))]) * var_5_1
	
	return arg_5_1.eff_target:modifyElapsedTime(arg_5_0, var_5_2, arg_5_1.attacker)
end

function SkillProc.effs.AB_UP_STATUS_DIFFERENCE(arg_6_0, arg_6_1)
	local var_6_0 = totable(arg_6_1.pow)
	local var_6_1 = var_6_0.ability
	local var_6_2 = arg_6_1.eff_target.logic:pickUnits(arg_6_1.eff_target, ENEMY)
	local var_6_3 = table.clone(arg_6_1.eff_target:getStatus())
	local var_6_4 = 0
	
	for iter_6_0, iter_6_1 in pairs(var_6_2) do
		local var_6_5 = iter_6_1:skillDamageTag(arg_6_1.attacker)
		
		if var_6_5 and arg_6_1.skill_id and arg_6_1.skill_id == var_6_5.skill_id then
			local var_6_6 = table.clone(iter_6_1:getStatus())
			
			if var_6_6 then
				local var_6_7 = 0
				local var_6_8
				local var_6_9
				
				if var_6_0.type == "enemy_high" then
					var_6_8 = SkillProc.get_target_value(iter_6_1, var_6_6, var_6_1)
					var_6_9 = SkillProc.get_target_value(arg_6_1.attacker, var_6_3, var_6_1)
				elseif var_6_0.type == "self_high" then
					var_6_8 = SkillProc.get_target_value(arg_6_1.attacker, var_6_3, var_6_1)
					var_6_9 = SkillProc.get_target_value(iter_6_1, var_6_6, var_6_1)
				end
				
				if var_6_8 and var_6_9 then
					local var_6_10 = var_6_8 - var_6_9
					local var_6_11 = var_6_0.rate or 0
					
					if var_6_0.max then
						var_6_7 = math.clamp(var_6_10 * var_6_11, 0, var_6_0.max)
					else
						var_6_7 = math.max(0, var_6_10 * var_6_11)
					end
					
					var_6_4 = var_6_4 + var_6_7
				end
			end
		end
	end
	
	local var_6_12 = var_6_4 * MAX_UNIT_TICK
	
	return arg_6_1.eff_target:modifyElapsedTime(arg_6_0, var_6_12, arg_6_1.from)
end

function SkillProc.effs.AB_UP_DAMAGE_RATE(arg_7_0, arg_7_1)
	local var_7_0 = (1 - arg_7_1.eff_target:getHPRatio()) * to_n(arg_7_1.pow) * MAX_UNIT_TICK
	
	return arg_7_1.eff_target:modifyElapsedTime(arg_7_0, var_7_0, arg_7_1.from)
end

function SkillProc.effs.DEBUFF_REMOVE(arg_8_0, arg_8_1)
	if arg_8_1.eff_target.states:canRemove() then
		local var_8_0, var_8_1 = arg_8_1.eff_target.states:removeStates(arg_8_1.pow, function(arg_9_0)
			return arg_9_0.db.cs_type == "debuff" and arg_9_0:canRemove()
		end)
		
		if var_8_0 and #var_8_0 > 0 then
			table.add(arg_8_0, var_8_0)
		end
		
		if var_8_1 and #var_8_1 > 0 then
			table.insert(arg_8_0, {
				type = "remove_debuffs",
				from = arg_8_1.attacker,
				target = arg_8_1.eff_target
			})
			
			return true
		elseif arg_8_1.eff_con_flags and arg_8_1.eff_idx then
			arg_8_1.eff_con_flags[arg_8_1.eff_idx] = false
		end
	elseif arg_8_1.eff_con_flags and arg_8_1.eff_idx then
		arg_8_1.eff_con_flags[arg_8_1.eff_idx] = false
	end
end

function SkillProc.effs.BUFF_REMOVE(arg_10_0, arg_10_1)
	if arg_10_1.eff_target.states:canRemove() then
		local var_10_0, var_10_1 = arg_10_1.eff_target.states:removeStates(arg_10_1.pow, function(arg_11_0)
			return arg_11_0.db.cs_type == "buff" and arg_11_0:canRemove()
		end)
		
		if var_10_0 and #var_10_0 > 0 then
			table.add(arg_10_0, var_10_0)
		end
		
		if var_10_1 and #var_10_1 > 0 then
			table.insert(arg_10_0, {
				type = "remove_buffs",
				from = arg_10_1.attacker,
				target = arg_10_1.eff_target
			})
			
			return true
		elseif arg_10_1.eff_con_flags and arg_10_1.eff_idx then
			arg_10_1.eff_con_flags[arg_10_1.eff_idx] = false
		end
	elseif arg_10_1.eff_con_flags and arg_10_1.eff_idx then
		arg_10_1.eff_con_flags[arg_10_1.eff_idx] = false
	end
end

function SkillProc.effs.BUFF_TRANSMUTE(arg_12_0, arg_12_1)
	if arg_12_1.eff_target.states:canRemove() then
		local var_12_0 = totable(arg_12_1.pow)
		local var_12_1 = to_n(var_12_0.amount)
		local var_12_2 = {}
		
		if type(var_12_0.csid) == "table" then
			var_12_2 = table.clone(var_12_0.csid)
		else
			var_12_2 = {
				var_12_0.csid
			}
		end
		
		local var_12_3, var_12_4 = arg_12_1.eff_target.states:removeStates(var_12_1, function(arg_13_0)
			return arg_13_0.db.cs_type == "buff" and arg_13_0:canRemove()
		end)
		local var_12_5 = math.min(var_12_1, table.count(var_12_4))
		
		for iter_12_0, iter_12_1 in pairs(var_12_4) do
			local var_12_6 = iter_12_1.state
			local var_12_7 = arg_12_1.eff_target.logic.random:get(1, table.count(var_12_2))
			local var_12_8 = var_12_2[var_12_7]
			
			table.remove(var_12_2, var_12_7)
			
			if var_12_8 then
				SkillProc.addStateToTarget(arg_12_0, SkillProc.getDefaultStateOption(arg_12_1), arg_12_1.attacker, arg_12_1.eff_target, var_12_8, var_12_6.turn, arg_12_1.skill_id)
			end
		end
		
		if var_12_4 and #var_12_4 > 0 then
			table.insert(arg_12_0, {
				type = "remove_buffs",
				from = arg_12_1.attacker,
				target = arg_12_1.eff_target
			})
			
			return true
		elseif arg_12_1.eff_con_flags and arg_12_1.eff_idx then
			arg_12_1.eff_con_flags[arg_12_1.eff_idx] = false
		end
	elseif arg_12_1.eff_con_flags and arg_12_1.eff_idx then
		arg_12_1.eff_con_flags[arg_12_1.eff_idx] = false
	end
end

function SkillProc.effs.COUNTER(arg_14_0, arg_14_1)
	if arg_14_1.attacker:getSkillDB(arg_14_1.skill_id, {
		"ignore_counter"
	}) == "y" then
		return false
	end
	
	arg_14_1.eff_target.turn_vars.invoke_counter_attack = true
	
	if arg_14_1.pow and arg_14_1.pow ~= 0 then
		arg_14_1.eff_target.turn_vars.counter_attack_skill_idx = arg_14_1.pow
	end
	
	return true
end

function SkillProc.effs.COUNTER_PRINT_CSNAME(arg_15_0, arg_15_1)
	if arg_15_1.attacker:getSkillDB(arg_15_1.skill_id, {
		"ignore_counter"
	}) == "y" then
		return true
	end
	
	arg_15_1.eff_target.turn_vars.invoke_counter_attack = true
	
	if arg_15_1.pow and arg_15_1.pow ~= 0 then
		arg_15_1.eff_target.turn_vars.counter_attack_skill_idx = arg_15_1.pow
	end
	
	return true
end

function SkillProc.effs.RESOURCE_MP_UP(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.eff_target:getSPName()
	
	if var_16_0 == "mp" then
		arg_16_1.eff_target:addSPRatio(arg_16_1.pow, var_16_0)
		table.insert(arg_16_0, {
			type = "sp_heal",
			from = arg_16_1.attacker,
			target = arg_16_1.eff_target,
			rate = arg_16_1.pow,
			sp_heal = math.floor(arg_16_1.pow * arg_16_1.eff_target:getMaxSP(var_16_0))
		})
		
		return true
	end
end

function SkillProc.effs.RESOURCE_BP_UP(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.eff_target:getSPName()
	
	if var_17_0 == "bp" then
		arg_17_1.eff_target:addSPRatio(arg_17_1.pow, var_17_0)
		table.insert(arg_17_0, {
			type = "sp_heal",
			from = arg_17_1.attacker,
			target = arg_17_1.eff_target,
			rate = arg_17_1.pow,
			sp_heal = math.floor(arg_17_1.pow * arg_17_1.eff_target:getMaxSP(var_17_0))
		})
		
		return true
	end
end

function SkillProc.effs.RESOURCE_CP_UP(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.eff_target:getSPName()
	
	if var_18_0 == "cp" then
		arg_18_1.eff_target:addSPRatio(arg_18_1.pow, var_18_0)
		table.insert(arg_18_0, {
			type = "sp_heal",
			from = arg_18_1.attacker,
			target = arg_18_1.eff_target,
			rate = arg_18_1.pow,
			sp_heal = math.floor(arg_18_1.pow * arg_18_1.eff_target:getMaxSP(var_18_0))
		})
		
		return true
	end
end

function SkillProc.effs.TARGET_DEAD(arg_19_0, arg_19_1)
	if arg_19_1.eff_target:isDead() then
		return false
	end
	
	local var_19_0, var_19_1, var_19_2 = arg_19_1.eff_target:decHP(arg_19_0, arg_19_1.eff_target:getRawMaxHP(), {
		ignore_guard = true,
		ignore_shield = true
	})
	
	return true
end

function SkillProc.effs.HPDOWN_FIXED(arg_20_0, arg_20_1)
	if arg_20_1.eff_target:isDead() then
		return false
	end
	
	local var_20_0 = math.max(1, math.floor(to_n(arg_20_1.pow)))
	local var_20_1 = SkillProc.getFixDamageDecrease(arg_20_1)
	local var_20_2 = SkillProc.getAdditionalDamageDecrease(arg_20_1)
	local var_20_3 = SkillProc.CalcEffectDamage(var_20_0, 0, var_20_1 + var_20_2)
	local var_20_4, var_20_5, var_20_6 = arg_20_1.eff_target:decHP(arg_20_0, var_20_3)
	
	table.insert(arg_20_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_20_1.from,
		target = arg_20_1.eff_target,
		damage = var_20_4,
		shield = var_20_5,
		dec_hp = var_20_6
	})
	
	return true
end

function SkillProc.effs.HPDOWN_FIXED_DHP(arg_21_0, arg_21_1)
	if arg_21_1.eff_target:isDead() then
		return false
	end
	
	local var_21_0 = totable(arg_21_1.pow)
	
	if not var_21_0.dmg or not var_21_0.dhp_limit then
		return false
	end
	
	var_21_0.dmg = to_n(var_21_0.dmg)
	var_21_0.dhp_limit = math.min(to_n(var_21_0.dhp_limit), 0.5)
	
	local var_21_1 = math.max(1, math.floor(var_21_0.dmg))
	local var_21_2 = SkillProc.getFixDamageDecrease(arg_21_1)
	local var_21_3 = SkillProc.getAdditionalDamageDecrease(arg_21_1)
	local var_21_4 = SkillProc.CalcEffectDamage(var_21_1, 0, var_21_2 + var_21_3)
	local var_21_5, var_21_6, var_21_7 = arg_21_1.eff_target:decHP(arg_21_0, var_21_4)
	
	table.insert(arg_21_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_21_1.from,
		target = arg_21_1.eff_target,
		damage = var_21_5,
		shield = var_21_6,
		dec_hp = var_21_7
	})
	
	if to_n(var_21_7) > 0 then
		local var_21_8 = arg_21_1.eff_target:getRawMaxHP() * var_21_0.dhp_limit
		
		if var_21_7 < var_21_8 then
			var_21_8 = var_21_7
		end
		
		local var_21_9 = arg_21_1.eff_target:increaseBrokenHP(var_21_8)
		
		table.insert(arg_21_0, {
			type = "dhp_inc",
			from = arg_21_1.from,
			target = arg_21_1.eff_target,
			dhp = var_21_9
		})
	end
	
	return true
end

function SkillProc.effs.HPDOWN_PROPORTIONAL_DMG(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1.eff_target:skillDamageTag(arg_22_1.giver)
	
	if var_22_0 then
		local var_22_1 = arg_22_1.eff_target:firstSkillDamageTag(arg_22_1.giver)
		
		if var_22_0.source == "hidden" and var_22_1 then
			var_22_0 = var_22_1
		end
		
		local var_22_2 = math.max(1, math.floor(var_22_0.damage * arg_22_1.pow))
		local var_22_3 = SkillProc.getAdditionalDamageIncrease(arg_22_1)
		local var_22_4 = SkillProc.getAdditionalDamageDecrease(arg_22_1)
		local var_22_5 = SkillProc.CalcEffectDamage(var_22_2, var_22_3, var_22_4)
		local var_22_6, var_22_7, var_22_8 = arg_22_1.eff_target:decHP(arg_22_0, var_22_5)
		
		table.insert(arg_22_0, {
			cur_hit = 1,
			tot_hit = 1,
			type = "attack",
			from = arg_22_1.giver,
			target = arg_22_1.eff_target,
			damage = var_22_6,
			shield = var_22_7,
			dec_hp = var_22_8
		})
	end
end

function SkillProc.effs.HPDOWN_TARGET_DHP(arg_23_0, arg_23_1)
	if arg_23_1.eff_target:isDead() then
		return false
	end
	
	local var_23_0 = arg_23_1.eff_target:getBrokenHP()
	local var_23_1 = math.floor(arg_23_1.pow * var_23_0)
	
	if var_23_1 < 1 then
		return false
	end
	
	local var_23_2 = math.max(1, var_23_1)
	local var_23_3 = SkillProc.getAdditionalDamageIncrease(arg_23_1)
	local var_23_4 = SkillProc.getAdditionalDamageDecrease(arg_23_1)
	local var_23_5 = SkillProc.CalcEffectDamage(var_23_2, var_23_3, var_23_4)
	local var_23_6, var_23_7, var_23_8 = arg_23_1.eff_target:decHP(arg_23_0, var_23_5)
	
	table.insert(arg_23_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_23_1.from,
		target = arg_23_1.eff_target,
		damage = var_23_6,
		shield = var_23_7,
		dec_hp = var_23_8
	})
	
	return true
end

function SkillProc.effs.HPDOWN_TARGET_MAXHP(arg_24_0, arg_24_1)
	if arg_24_1.eff_target:isDead() then
		return false
	end
	
	local var_24_0 = math.max(1, math.floor(arg_24_1.pow * arg_24_1.eff_target:getMaxHP()))
	local var_24_1 = SkillProc.getAdditionalDamageIncrease(arg_24_1)
	local var_24_2 = SkillProc.getAdditionalDamageDecrease(arg_24_1)
	local var_24_3 = SkillProc.CalcEffectDamage(var_24_0, var_24_1, var_24_2)
	local var_24_4, var_24_5, var_24_6 = arg_24_1.eff_target:decHP(arg_24_0, var_24_3)
	
	table.insert(arg_24_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_24_1.from,
		target = arg_24_1.eff_target,
		damage = var_24_4,
		shield = var_24_5,
		dec_hp = var_24_6
	})
	
	return true
end

function SkillProc.effs.HPDOWN_TARGET_MAXHP_EVENT(arg_25_0, arg_25_1)
	if arg_25_1.eff_target:isDead() then
		return false
	end
	
	local var_25_0 = math.max(1, math.floor(arg_25_1.pow * arg_25_1.eff_target:getMaxHP()))
	local var_25_1 = SkillProc.getAdditionalDamageIncrease(arg_25_1)
	local var_25_2 = SkillProc.getAdditionalDamageDecrease(arg_25_1)
	local var_25_3 = SkillProc.CalcEffectDamage(var_25_0, var_25_1, var_25_2)
	local var_25_4, var_25_5, var_25_6 = arg_25_1.eff_target:decHP(arg_25_0, var_25_3)
	
	table.insert(arg_25_0, {
		type = "gauge_update",
		target = arg_25_1.eff_target
	})
	
	return true
end

function SkillProc.effs.HPDOWN_TARGET_MAXHP_DHP(arg_26_0, arg_26_1)
	if arg_26_1.eff_target:isDead() then
		return false
	end
	
	local var_26_0 = math.max(1, math.floor(arg_26_1.pow * arg_26_1.eff_target:getMaxHP()))
	local var_26_1, var_26_2, var_26_3 = arg_26_1.eff_target:decHP(arg_26_0, var_26_0)
	
	table.insert(arg_26_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_26_1.from,
		target = arg_26_1.eff_target,
		damage = var_26_1,
		shield = var_26_2,
		dec_hp = var_26_3
	})
	
	if to_n(var_26_3) > 0 then
		local var_26_4 = arg_26_1.eff_target:increaseBrokenHP(var_26_3)
		
		table.insert(arg_26_0, {
			type = "dhp_inc",
			from = arg_26_1.from,
			target = arg_26_1.eff_target,
			dhp = var_26_4
		})
	end
	
	return true
end

function SkillProc.effs.HPUP_CASTER_ATT(arg_27_0, arg_27_1)
	local var_27_0 = math.floor(arg_27_1.from.status.att * arg_27_1.pow)
	local var_27_1 = arg_27_1.eff_target:heal(var_27_0)
	
	if var_27_1 > 0 then
		table.insert(arg_27_0, {
			type = "heal",
			from = arg_27_1.from,
			target = arg_27_1.eff_target,
			heal = var_27_1
		})
		
		return true
	end
end

function SkillProc.effs.HPUP_CASTER_MAXHP(arg_28_0, arg_28_1)
	local var_28_0 = math.floor(arg_28_1.from:getMaxHP() * arg_28_1.pow)
	local var_28_1 = arg_28_1.eff_target:heal(var_28_0)
	
	if var_28_1 > 0 then
		table.insert(arg_28_0, {
			type = "heal",
			from = arg_28_1.from,
			target = arg_28_1.eff_target,
			heal = var_28_1
		})
		
		return true
	end
end

function SkillProc.effs.HPDOWN_TARGET_NOWHPRATE(arg_29_0, arg_29_1)
	local var_29_0 = math.floor(arg_29_1.eff_target.inst.hp * arg_29_1.pow)
	local var_29_1, var_29_2, var_29_3 = arg_29_1.eff_target:decHP(arg_29_0, var_29_0)
	
	table.insert(arg_29_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_29_1.from,
		target = arg_29_1.eff_target,
		damage = var_29_1,
		shield = var_29_2,
		dec_hp = var_29_3
	})
	
	return true
end

function SkillProc.effs.HPDOWN_TARGET_NOWHPRATE_EVENT(arg_30_0, arg_30_1)
	local var_30_0 = math.floor(arg_30_1.eff_target.inst.hp * arg_30_1.pow)
	local var_30_1, var_30_2, var_30_3 = arg_30_1.eff_target:decHP(arg_30_0, var_30_0)
	
	table.insert(arg_30_0, {
		type = "gauge_update",
		target = arg_30_1.eff_target
	})
	
	return true
end

function SkillProc.effs.HP_AVERAGE(arg_31_0, arg_31_1)
	if arg_31_1.attacker.turn_vars.hp_average then
		return 
	end
	
	local var_31_0 = arg_31_1.attacker.logic:getTargetCandidates(arg_31_1.skill_id, arg_31_1.attacker, arg_31_1.eff_target)
	local var_31_1 = 0
	local var_31_2 = 0
	
	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		if not iter_31_1:isDead() and not iter_31_1:isEmptyHP() then
			local var_31_3 = iter_31_1:getHP()
			local var_31_4 = iter_31_1:getMaxHP()
			
			var_31_1 = var_31_1 + var_31_3
			var_31_2 = var_31_2 + var_31_4
		end
	end
	
	local var_31_5 = var_31_1 / var_31_2
	
	for iter_31_2, iter_31_3 in pairs(var_31_0) do
		if not iter_31_3:isDead() and not iter_31_3:isEmptyHP() then
			local var_31_6 = iter_31_3:getHP()
			
			iter_31_3.inst.hp = math.max(1, math.floor(iter_31_3:getMaxHP() * var_31_5))
			
			local var_31_7 = iter_31_3.inst.hp - var_31_6
			
			table.insert(arg_31_0, {
				type = "gauge_update",
				target = iter_31_3
			})
		end
	end
	
	arg_31_1.attacker.turn_vars.hp_average = var_31_5
	
	return true
end

function SkillProc.effs.HPDOWN_FIXED_CS_COUNT(arg_32_0, arg_32_1)
	local var_32_0 = totable(arg_32_1.pow)
	local var_32_1 = var_32_0.type
	local var_32_2 = 0
	
	if var_32_0.target == "both" or var_32_0.target == "ally" then
		for iter_32_0, iter_32_1 in pairs(arg_32_1.eff_target.logic:pickUnits(arg_32_1.eff_target, FRIEND)) do
			local var_32_3 = iter_32_1.states:getTypeCount(var_32_1)
			
			var_32_2 = var_32_2 + to_n(var_32_3)
		end
	end
	
	if var_32_0.target == "both" or var_32_0.target == "enemy" then
		for iter_32_2, iter_32_3 in pairs(arg_32_1.eff_target.logic:pickUnits(arg_32_1.eff_target, ENEMY)) do
			local var_32_4 = iter_32_3.states:getTypeCount(var_32_1)
			
			var_32_2 = var_32_2 + to_n(var_32_4)
		end
	end
	
	if var_32_2 > 0 then
		local var_32_5 = to_n(var_32_0.min)
		local var_32_6 = to_n(var_32_0.max)
		local var_32_7 = to_n(var_32_0.rate)
		local var_32_8 = math.max(var_32_5, math.min(var_32_6, var_32_7 * var_32_2))
		local var_32_9 = SkillProc.getFixDamageDecrease(arg_32_1)
		local var_32_10 = SkillProc.getAdditionalDamageDecrease(arg_32_1)
		local var_32_11 = SkillProc.CalcEffectDamage(var_32_8, 0, var_32_9 + var_32_10)
		local var_32_12, var_32_13, var_32_14 = arg_32_1.eff_target:decHP(arg_32_0, var_32_11)
		
		table.insert(arg_32_0, {
			type = "attack",
			from = arg_32_1.giver,
			target = arg_32_1.eff_target,
			damage = var_32_12,
			shield = var_32_13,
			dec_hp = var_32_14
		})
		
		return true
	end
end

function SkillProc.effs.HPDOWN_FIXED_TARGET_CS_COUNT(arg_33_0, arg_33_1)
	local var_33_0 = totable(arg_33_1.pow)
	local var_33_1 = var_33_0.type
	local var_33_2 = arg_33_1.eff_target.states:getTypeCount(var_33_1)
	
	if var_33_2 > 0 then
		local var_33_3 = to_n(var_33_0.min)
		local var_33_4 = to_n(var_33_0.max)
		local var_33_5 = to_n(var_33_0.rate)
		local var_33_6 = math.max(var_33_3, math.min(var_33_4, var_33_5 * var_33_2))
		local var_33_7 = SkillProc.getFixDamageDecrease(arg_33_1)
		local var_33_8 = SkillProc.getAdditionalDamageDecrease(arg_33_1)
		local var_33_9 = SkillProc.CalcEffectDamage(var_33_6, 0, var_33_7 + var_33_8)
		local var_33_10, var_33_11, var_33_12 = arg_33_1.eff_target:decHP(arg_33_0, var_33_9)
		
		table.insert(arg_33_0, {
			type = "attack",
			from = arg_33_1.giver,
			target = arg_33_1.eff_target,
			damage = var_33_10,
			shield = var_33_11,
			dec_hp = var_33_12
		})
		
		return true
	end
end

function SkillProc.effs.AB_UP(arg_34_0, arg_34_1)
	if arg_34_1.eff_target.logic:getTurnOwner() == arg_34_1.eff_target and arg_34_1.eff_target.logic.turn_info.state == "pending_start" then
		return false
	end
	
	local var_34_0 = arg_34_1.pow * MAX_UNIT_TICK
	
	return arg_34_1.eff_target:modifyElapsedTime(arg_34_0, var_34_0, arg_34_1.attacker)
end

function SkillProc.effs.AB_DOWN(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_1.pow * MAX_UNIT_TICK
	
	return arg_35_1.eff_target:modifyElapsedTime(arg_35_0, 0 - var_35_0, arg_35_1.from)
end

function SkillProc.effs.AB_DOWN_RANDOM(arg_36_0, arg_36_1)
	if type(arg_36_1.pow) == "string" then
		local var_36_0 = totable(arg_36_1.pow)
		
		var_36_0.min = to_n(var_36_0.min) * 10000
		var_36_0.max = to_n(var_36_0.max) * 10000
		
		local var_36_1 = arg_36_1.eff_target.logic.random:get(var_36_0.min, var_36_0.max) / 10000 * MAX_UNIT_TICK
		
		return arg_36_1.eff_target:modifyElapsedTime(arg_36_0, 0 - var_36_1, arg_36_1.from)
	end
end

function SkillProc.effs.AB_SPECIFY(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1.pow * MAX_UNIT_TICK
	
	arg_37_1.eff_target.inst.elapsed_ut = math.max(var_37_0, 0)
	
	table.insert(arg_37_0, {
		text = "sk_actionbarspecify",
		type = "text",
		target = arg_37_1.eff_target
	})
	
	return true
end

function SkillProc.effs.AB_UP_TARGET(arg_38_0, arg_38_1)
	local var_38_0 = 0
	local var_38_1 = arg_38_1.attacker.logic:pickUnits(arg_38_1.attacker, ENEMY)
	
	for iter_38_0, iter_38_1 in pairs(var_38_1) do
		local var_38_2 = iter_38_1:skillDamageTag(arg_38_1.attacker)
		
		if var_38_2 and (not arg_38_1.skill_id or arg_38_1.skill_id == var_38_2.skill_id) then
			var_38_0 = var_38_0 + 1
		end
	end
	
	local var_38_3 = arg_38_1.pow * MAX_UNIT_TICK * var_38_0
	
	return arg_38_1.eff_target:modifyElapsedTime(arg_38_0, var_38_3, arg_38_1.attacker)
end

function SkillProc.effs.AB_DOWN_TARGET(arg_39_0, arg_39_1)
	local var_39_0 = 0
	local var_39_1 = arg_39_1.attacker.logic:pickUnits(arg_39_1.attacker, ENEMY)
	
	for iter_39_0, iter_39_1 in pairs(var_39_1) do
		local var_39_2 = iter_39_1:skillDamageTag(arg_39_1.attacker)
		
		if var_39_2 and (not arg_39_1.skill_id or arg_39_1.skill_id == var_39_2.skill_id) then
			var_39_0 = var_39_0 + 1
		end
	end
	
	local var_39_3 = arg_39_1.pow * MAX_UNIT_TICK * var_39_0
	
	return arg_39_1.eff_target:modifyElapsedTime(arg_39_0, 0 - var_39_3, arg_39_1.attacker)
end

function SkillProc.effs.CS_EXTEND(arg_40_0, arg_40_1)
	local var_40_0 = totable(arg_40_1.pow or "")
	
	if not var_40_0 or table.empty(var_40_0) then
		return false
	end
	
	local var_40_1 = arg_40_1.eff_target.states:extendStates(function(arg_41_0)
		return arg_41_0:getId() == tostring(var_40_0.cs_id)
	end, to_n(var_40_0.turn))
	
	if var_40_1 and #var_40_1 > 0 then
		table.join(arg_40_0, var_40_1)
		
		return true
	end
end

function SkillProc.effs.BUFF_EXTEND(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1.eff_target.states:extendStates(function(arg_43_0)
		return arg_43_0.db.cs_type == "buff"
	end, arg_42_1.pow)
	
	if var_42_0 and #var_42_0 > 0 then
		table.join(arg_42_0, var_42_0)
		
		return true
	end
end

function SkillProc.effs.DEBUFF_EXTEND(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1.eff_target.states:extendStates(function(arg_45_0)
		return arg_45_0.db.cs_type == "debuff" and not arg_45_0:checkCon("TURN_FINISHED")
	end, arg_44_1.pow)
	
	if var_44_0 and #var_44_0 > 0 then
		table.join(arg_44_0, var_44_0)
		
		return true
	end
end

function SkillProc.effs.DEBUFF_EXTEND_EX_STUN(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_1.eff_target.states:extendStates(function(arg_47_0)
		return arg_47_0.db.cs_type == "debuff" and not arg_47_0:checkEff("CSP_STUN") and not arg_47_0:checkCon("TURN_FINISHED")
	end, arg_46_1.pow)
	
	if var_46_0 and #var_46_0 > 0 then
		table.join(arg_46_0, var_46_0)
		
		return true
	end
end

function SkillProc.effs.BUFF_DOWN(arg_48_0, arg_48_1)
	if arg_48_1.pow > 0 then
		arg_48_1.pow = -arg_48_1.pow
	end
	
	local var_48_0 = arg_48_1.eff_target.states:extendStates(function(arg_49_0)
		return arg_49_0.db.cs_type == "buff" and arg_49_0:canRemove()
	end, arg_48_1.pow)
	
	if var_48_0 and #var_48_0 > 0 then
		table.join(arg_48_0, var_48_0)
		
		return true
	end
end

function SkillProc.effs.BUFF_COPY_ALLY(arg_50_0, arg_50_1)
	local var_50_0 = {}
	
	arg_50_1.eff_target.states:enumNormalStates(function(arg_51_0)
		if arg_51_0.db.cs_type == "buff" and arg_51_0.db.cs_remove == "y" then
			if table.count(var_50_0) >= to_n(arg_50_1.pow) then
				return 
			end
			
			table.insert(var_50_0, arg_51_0)
		end
	end)
	
	local var_50_1 = 0
	
	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		local var_50_2 = arg_50_1.attacker.logic:pickUnits(arg_50_1.attacker, FRIEND)
		
		for iter_50_2, iter_50_3 in pairs(var_50_2) do
			local var_50_3 = SkillProc.getDefaultStateOption(arg_50_1)
			
			var_50_3.override_pow = iter_50_1.override_pow
			
			if SkillProc.addStateToTarget(arg_50_0, var_50_3, arg_50_1.attacker, iter_50_3, iter_50_1.id, iter_50_1.turn) then
				var_50_1 = var_50_1 + 1
			end
		end
	end
	
	return var_50_1 > 0
end

function SkillProc.effs.DEBUFF_DOWN(arg_52_0, arg_52_1)
	if arg_52_1.pow > 0 then
		arg_52_1.pow = -arg_52_1.pow
	end
	
	local var_52_0 = arg_52_1.eff_target.states:extendStates(function(arg_53_0)
		return arg_53_0.db.cs_type == "debuff" and arg_53_0:canRemove() and not arg_53_0:checkCon("TURN_FINISHED")
	end, arg_52_1.pow)
	
	if var_52_0 and #var_52_0 > 0 then
		table.join(arg_52_0, var_52_0)
		
		return true
	end
end

function SkillProc.effs.DEBUFF_TRANSFER(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_1.pow
	local var_54_1 = {}
	
	arg_54_1.attacker.states:enumNormalStates(function(arg_55_0)
		local var_55_0 = CS_Util.isApplyStateOnlyHeroByCS(arg_55_0, arg_54_1.eff_target)
		
		if arg_55_0.db.cs_type == "debuff" and arg_55_0:canRemove() and var_55_0 then
			table.insert(var_54_1, arg_55_0)
		end
	end)
	
	local var_54_2 = 0
	
	if var_54_0 > 0 and #var_54_1 > 0 then
		arg_54_1.attacker.logic.random:shuffle(var_54_1)
		
		for iter_54_0 = 1, var_54_0 do
			if not var_54_1[iter_54_0] then
				break
			end
			
			if not arg_54_1.cs_eff_turn then
				local var_54_3 = var_54_1[iter_54_0].turn
			end
			
			local var_54_4, var_54_5 = SkillProc.addStateToTarget(arg_54_0, SkillProc.getDefaultStateOption(arg_54_1), arg_54_1.attacker, arg_54_1.eff_target, var_54_1[iter_54_0].id, var_54_1[iter_54_0].turn)
			
			if var_54_4 then
				var_54_2 = var_54_2 + 1
				arg_54_1.attacker.turn_vars.transferred_cs = arg_54_1.attacker.turn_vars.transferred_cs or {}
				arg_54_1.attacker.turn_vars.transferred_cs[var_54_1[iter_54_0]] = to_n(arg_54_1.attacker.turn_vars.transferred_cs[var_54_1[iter_54_0]]) + 1
			end
		end
	end
	
	return var_54_2 > 0
end

function SkillProc.effs.DEBUFF_TRANSFER_SEQ(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_1.pow
	local var_56_1 = {}
	
	arg_56_1.attacker.states:enumNormalStates(function(arg_57_0)
		local var_57_0 = CS_Util.isApplyStateOnlyHeroByCS(arg_57_0, arg_56_1.eff_target)
		
		if arg_57_0.db.cs_type == "debuff" and arg_57_0:canRemove() and var_57_0 then
			table.insert(var_56_1, arg_57_0)
		end
	end)
	
	local var_56_2 = 0
	local var_56_3
	
	if var_56_0 > 0 and #var_56_1 > 0 then
		arg_56_1.attacker.logic.random:shuffle(var_56_1)
		
		arg_56_1.attacker.turn_vars.transferred_cs = arg_56_1.attacker.turn_vars.transferred_cs or {}
		arg_56_1.attacker.turn_vars.transferred_cs_seq = arg_56_1.attacker.turn_vars.transferred_cs_seq or {}
		var_56_3 = arg_56_1.attacker.turn_vars.transferred_cs_seq
		
		for iter_56_0 = 1, var_56_0 do
			local var_56_4 = var_56_3[iter_56_0] or var_56_1[iter_56_0]
			
			if not var_56_4 then
				break
			end
			
			if not arg_56_1.cs_eff_turn then
				local var_56_5 = var_56_4.turn
			end
			
			local var_56_6, var_56_7 = SkillProc.addStateToTarget(arg_56_0, SkillProc.getDefaultStateOption(arg_56_1), arg_56_1.attacker, arg_56_1.eff_target, var_56_4.id, var_56_4.turn)
			
			if var_56_6 then
				var_56_2 = var_56_2 + 1
				arg_56_1.attacker.turn_vars.transferred_cs[var_56_4] = to_n(arg_56_1.attacker.turn_vars.transferred_cs[var_56_4]) + 1
				arg_56_1.attacker.turn_vars.transferred_cs_seq[iter_56_0] = var_56_4
			end
		end
	end
	
	return var_56_2 > 0
end

function SkillProc.effs.CS_TRANSFER(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_1.pow
	local var_58_1 = {}
	
	arg_58_1.from.states:enumNormalStates(function(arg_59_0)
		local var_59_0 = CS_Util.isApplyStateOnlyHeroByCS(arg_59_0, arg_58_1.eff_target)
		
		if tostring(arg_59_0.id) == tostring(var_58_0) and var_59_0 then
			table.insert(var_58_1, arg_59_0)
		end
	end)
	
	local var_58_2 = 0
	
	if #var_58_1 > 0 then
		arg_58_1.from.logic.random:shuffle(var_58_1)
		
		for iter_58_0 = 1, #var_58_1 do
			if not var_58_1[iter_58_0] then
				break
			end
			
			if not arg_58_1.cs_eff_turn then
				local var_58_3 = var_58_1[iter_58_0].turn
			end
			
			local var_58_4, var_58_5 = SkillProc.addStateToTarget(arg_58_0, SkillProc.getDefaultStateOption(arg_58_1), arg_58_1.from, arg_58_1.eff_target, var_58_1[iter_58_0].id, var_58_1[iter_58_0].turn)
			
			if var_58_4 then
				var_58_2 = var_58_2 + 1
				arg_58_1.from.turn_vars.transferred_cs = arg_58_1.from.turn_vars.transferred_cs or {}
				arg_58_1.from.turn_vars.transferred_cs[var_58_1[iter_58_0]] = to_n(arg_58_1.from.turn_vars.transferred_cs[var_58_1[iter_58_0]]) + 1
			end
		end
	end
	
	return var_58_2 > 0
end

function SkillProc.effs.CS_TRANSFER_STACK(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_1.pow
	local var_60_1 = {}
	
	arg_60_1.from.states:enumNormalStates(function(arg_61_0)
		local var_61_0 = CS_Util.isApplyStateOnlyHeroByCS(arg_61_0, arg_60_1.eff_target)
		
		if tostring(arg_61_0.id) == tostring(var_60_0) and var_61_0 then
			table.insert(var_60_1, arg_61_0)
		end
	end)
	
	local var_60_2 = 0
	
	if #var_60_1 > 0 then
		arg_60_1.from.logic.random:shuffle(var_60_1)
		
		for iter_60_0 = 1, #var_60_1 do
			if not var_60_1[iter_60_0] then
				break
			end
			
			if not arg_60_1.cs_eff_turn then
				local var_60_3 = var_60_1[iter_60_0].turn
			end
			
			local var_60_4 = SkillProc.getDefaultStateOption(arg_60_1)
			
			var_60_4.stack_count = var_60_1[iter_60_0].stack_count
			
			local var_60_5, var_60_6 = SkillProc.addStateToTarget(arg_60_0, var_60_4, arg_60_1.from, arg_60_1.eff_target, var_60_1[iter_60_0].id, var_60_1[iter_60_0].turn)
			
			if var_60_5 then
				var_60_2 = var_60_2 + 1
				arg_60_1.from.turn_vars.transferred_cs = arg_60_1.from.turn_vars.transferred_cs or {}
				arg_60_1.from.turn_vars.transferred_cs[var_60_1[iter_60_0]] = to_n(arg_60_1.from.turn_vars.transferred_cs[var_60_1[iter_60_0]]) + 1
			end
		end
	end
	
	return var_60_2 > 0
end

function SkillProc.effs.HPUP_BALANCE(arg_62_0, arg_62_1)
	local var_62_0 = arg_62_1.attacker.logic:pickUnits(arg_62_1.attacker, FRIEND)
	local var_62_1 = 0
	
	for iter_62_0, iter_62_1 in pairs(var_62_0) do
		local var_62_2 = iter_62_1:getHPRatio()
		
		if var_62_1 < var_62_2 then
			var_62_1 = var_62_2
		end
	end
	
	local var_62_3 = {
		arg_62_1.eff_target
	}
	
	for iter_62_2, iter_62_3 in pairs(var_62_3) do
		if var_62_1 > iter_62_3:getHPRatio() then
			local var_62_4 = iter_62_3.inst.hp
			
			iter_62_3.inst.hp = math.floor(iter_62_3:getMaxHP() * var_62_1)
			
			if var_62_4 ~= iter_62_3.inst.hp then
				local var_62_5 = iter_62_3.inst.hp - var_62_4
				
				table.insert(arg_62_0, {
					type = "heal",
					from = arg_62_1.attacker,
					target = iter_62_3,
					heal = var_62_5
				})
			end
		end
	end
	
	return #arg_62_0 > 0
end

function SkillProc.effs.DEBUFF_COPY(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_1.giver or arg_63_1.owner or arg_63_1.attacker or {}
	local var_63_1 = totable(arg_63_1.pow or "")
	local var_63_2 = 0
	
	for iter_63_0, iter_63_1 in pairs(var_63_0.states.List) do
		if var_63_2 >= (var_63_1.cnt or 0) then
			break
		end
		
		if iter_63_1:isValid() and iter_63_1.db.cs_type == "debuff" and iter_63_1.db.cs_remove == "y" and SkillProc.addStateToTarget(arg_63_0, SkillProc.getDefaultStateOption(arg_63_1), arg_63_1.eff_target, arg_63_1.eff_target, iter_63_1:getId(), iter_63_1:getRestTurn()) then
			var_63_2 = var_63_2 + 1
		end
	end
	
	return var_63_2 > 0
end

function SkillProc.effs.BUFF_STEAL(arg_64_0, arg_64_1)
	local var_64_0, var_64_1 = arg_64_1.eff_target.states:removeStates(arg_64_1.pow, function(arg_65_0)
		local var_65_0 = CS_Util.isApplyStateOnlyHeroByCS(arg_65_0, arg_64_1.attacker)
		
		return arg_65_0.db.cs_type == "buff" and arg_65_0.db.cs_remove == "y" and var_65_0
	end)
	
	table.join(arg_64_0, var_64_0)
	
	local var_64_2 = 0
	
	for iter_64_0, iter_64_1 in pairs(var_64_1) do
		local var_64_3 = SkillProc.getDefaultStateOption(arg_64_1)
		
		var_64_3.override_pow = iter_64_1.state.override_pow
		
		if SkillProc.addStateToTarget(arg_64_0, var_64_3, arg_64_1.attacker, arg_64_1.attacker, iter_64_1.state.id, iter_64_1.state.turn) then
			var_64_2 = var_64_2 + 1
		end
	end
	
	return var_64_2 > 0
end

function SkillProc.effs.BUFF_STEAL_ALLY(arg_66_0, arg_66_1)
	local var_66_0, var_66_1 = arg_66_1.eff_target.states:removeStates(arg_66_1.pow, function(arg_67_0)
		local var_67_0 = CS_Util.isApplyStateOnlyHeroByCS(arg_67_0, arg_66_1.attacker)
		
		return arg_67_0.db.cs_type == "buff" and arg_67_0.db.cs_remove == "y" and var_67_0
	end)
	
	table.join(arg_66_0, var_66_0)
	
	local var_66_2 = 0
	
	for iter_66_0, iter_66_1 in pairs(var_66_1) do
		local var_66_3 = arg_66_1.attacker.logic:pickUnits(arg_66_1.attacker, FRIEND)
		
		for iter_66_2, iter_66_3 in pairs(var_66_3) do
			local var_66_4 = SkillProc.getDefaultStateOption(arg_66_1)
			
			var_66_4.override_pow = iter_66_1.state.override_pow
			
			if SkillProc.addStateToTarget(arg_66_0, var_66_4, arg_66_1.attacker, iter_66_3, iter_66_1.state.id, iter_66_1.state.turn) then
				var_66_2 = var_66_2 + 1
			end
		end
	end
	
	return var_66_2 > 0
end

function SkillProc.effs.REVIVE(arg_68_0, arg_68_1)
	if arg_68_1.attacker == arg_68_1.eff_target then
		arg_68_1.attacker:reserveResurrection(0)
	else
		local var_68_0, var_68_1 = arg_68_1.attacker.logic:spawnUnit(arg_68_1.eff_target, nil, true)
		
		arg_68_1.eff_target:resurrect(0, arg_68_0)
		table.insert(arg_68_0, {
			type = "resurrect",
			dead_unit = var_68_0,
			unit = arg_68_1.eff_target,
			dead_index = var_68_1,
			from = arg_68_1.attacker
		})
	end
	
	return true
end

function SkillProc.effs.REVIVE_SELECT(arg_69_0, arg_69_1)
	if arg_69_1.attacker == arg_69_1.eff_target then
		return false
	end
	
	local var_69_0 = arg_69_1.attacker.logic:newUnit({
		code = arg_69_1.pow,
		lv = arg_69_1.eff_target:getLv(),
		ally = arg_69_1.eff_target.inst.ally
	})
	
	var_69_0:onSetupStage(arg_69_1.attacker.logic)
	
	local var_69_1, var_69_2 = arg_69_1.attacker.logic:spawnUnit(var_69_0, arg_69_1.eff_target)
	
	arg_69_1.eff_target:resurrect(0, arg_69_0)
	table.insert(arg_69_0, {
		type = "resurrect",
		dead_unit = var_69_1,
		unit = var_69_0,
		dead_index = var_69_2,
		from = arg_69_1.attacker
	})
	
	return true
end

function SkillProc.effs.SOUL_UP(arg_70_0, arg_70_1)
	arg_70_1.eff_target.logic:addTeamRes(arg_70_1.eff_target.inst.ally, "soul_piece", arg_70_1.pow or 1)
	table.insert(arg_70_0, {
		type = "gain_soul_by_field",
		object = arg_70_1.eff_target,
		count = arg_70_1.pow or 1,
		ally = arg_70_1.eff_target.inst.ally
	})
	
	return true
end

function SkillProc.effs.SOUL_DOWN(arg_71_0, arg_71_1)
	local var_71_0 = -(arg_71_1.pow or 1)
	
	if var_71_0 > 0 then
		Log.e("SkillProc", "SOUL_DOWN 음수로 입력함")
	end
	
	arg_71_1.eff_target.logic:addTeamRes(arg_71_1.eff_target.inst.ally, "soul_piece", var_71_0)
	table.insert(arg_71_0, {
		type = "gain_soul_by_field",
		object = arg_71_1.eff_target,
		count = var_71_0,
		ally = arg_71_1.eff_target.inst.ally
	})
	
	return true
end

function SkillProc.effs.SUMMON(arg_72_0, arg_72_1)
	local var_72_0 = arg_72_1.attacker.logic:newUnit({
		code = arg_72_1.pow,
		lv = arg_72_1.attacker:getLv(),
		ally = arg_72_1.attacker.inst.ally
	})
	
	var_72_0:onSetupStage(arg_72_1.attacker.logic)
	
	local var_72_1, var_72_2 = arg_72_1.attacker.logic:spawnUnit(var_72_0)
	
	table.insert(arg_72_0, {
		type = "summon",
		dead_unit = var_72_1,
		unit = var_72_0,
		dead_index = var_72_2
	})
	
	if var_72_0.inst.ally == FRIEND then
		var_72_0.inst.summon_by = arg_72_1.attacker:getUID()
	end
	
	return true
end

function SkillProc.effs.REPLACE(arg_73_0, arg_73_1)
	local var_73_0 = arg_73_1.attacker.logic:newUnit({
		code = arg_73_1.pow,
		lv = arg_73_1.attacker:getLv(),
		ally = arg_73_1.attacker.inst.ally
	})
	
	var_73_0:onSetupStage(arg_73_1.attacker.logic)
	
	local var_73_1, var_73_2 = arg_73_1.attacker.logic:spawnUnit(var_73_0, arg_73_1.attacker)
	
	var_73_1.inst.hp = 0
	
	var_73_1:setReplace(true)
	table.insert(arg_73_0, {
		type = "replace",
		dead_unit = var_73_1,
		unit = var_73_0,
		dead_index = var_73_2
	})
	
	return true
end

function SkillProc.effs.REPLACE_NOWHPRATE_KEEP(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_1.attacker.logic:newUnit({
		code = arg_74_1.pow,
		lv = arg_74_1.attacker:getLv(),
		ally = arg_74_1.attacker.inst.ally
	})
	
	var_74_0:onSetupStage(arg_74_1.attacker.logic)
	
	local var_74_1, var_74_2 = arg_74_1.attacker.logic:spawnUnit(var_74_0, arg_74_1.attacker)
	local var_74_3 = var_74_1:getHPRatio()
	
	var_74_0.inst.dhp = math.min(var_74_0:getRawMaxHP() - 1, var_74_1.inst.dhp or 0)
	var_74_0.inst.hp = var_74_0:getMaxHP() * var_74_3
	var_74_1.inst.hp = 0
	
	var_74_1:setReplace(true)
	table.insert(arg_74_0, {
		type = "replace",
		dead_unit = var_74_1,
		unit = var_74_0,
		dead_index = var_74_2
	})
	
	return true
end

function SkillProc.effs.NOWHP_RATIO_EXCHANGE(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_1.attacker
	local var_75_1 = arg_75_1.eff_target
	local var_75_2 = var_75_0:getHPRatio()
	local var_75_3 = var_75_1:getHPRatio()
	
	var_75_0.inst.hp = math.floor(var_75_0:getMaxHP() * var_75_3)
	var_75_1.inst.hp = math.floor(var_75_1:getMaxHP() * var_75_2)
	
	return true
end

function SkillProc.effs.CS_REMOVE(arg_76_0, arg_76_1)
	if arg_76_1.eff_target.states:canRemove() then
		local var_76_0 = string.split(tostring(arg_76_1.pow or ""), ",")
		local var_76_1, var_76_2 = arg_76_1.eff_target.states:removeStates(-1, function(arg_77_0)
			return (table.isInclude(var_76_0, arg_77_0.id))
		end)
		
		if var_76_1 and #var_76_1 > 0 then
			table.add(arg_76_0, var_76_1)
		end
		
		if var_76_2 and #var_76_2 > 0 then
			return true
		elseif arg_76_1.eff_con_flags and arg_76_1.eff_idx then
			arg_76_1.eff_con_flags[arg_76_1.eff_idx] = false
		end
	elseif arg_76_1.eff_con_flags and arg_76_1.eff_idx then
		arg_76_1.eff_con_flags[arg_76_1.eff_idx] = false
	end
end

function SkillProc.effs.CS_REMOVE_FORCED(arg_78_0, arg_78_1)
	local var_78_0 = string.split(tostring(arg_78_1.pow or ""), ",")
	local var_78_1, var_78_2 = arg_78_1.eff_target.states:removeStates(-1, function(arg_79_0)
		return (table.isInclude(var_78_0, arg_79_0.id))
	end)
	
	if var_78_1 and #var_78_1 > 0 then
		table.add(arg_78_0, var_78_1)
	end
	
	if var_78_2 and #var_78_2 > 0 then
		return true
	elseif arg_78_1.eff_con_flags and arg_78_1.eff_idx then
		arg_78_1.eff_con_flags[arg_78_1.eff_idx] = false
	end
end

function SkillProc.effs.AB_UP_CRICOUNT(arg_80_0, arg_80_1)
	local var_80_0 = arg_80_1.pow * to_n(arg_80_1.from.turn_vars.global_critical_count) * MAX_UNIT_TICK
	
	if var_80_0 > 0 then
		return arg_80_1.eff_target:modifyElapsedTime(arg_80_0, var_80_0, arg_80_1.from)
	end
end

function SkillProc.effs.HPUP_DAMAGE(arg_81_0, arg_81_1)
	local var_81_0 = arg_81_1.eff_target.logic:pickUnits(arg_81_1.eff_target, ENEMY)
	local var_81_1 = 0
	
	for iter_81_0, iter_81_1 in pairs(var_81_0) do
		local var_81_2 = iter_81_1:skillDamageTag(arg_81_1.attacker)
		
		if var_81_2 and (not arg_81_1.skill_id or arg_81_1.skill_id == var_81_2.skill_id) then
			var_81_1 = var_81_1 + var_81_2.damage
		end
	end
	
	if var_81_1 > 0 then
		if not arg_81_1.eff_target.turn_vars.hpup_per_damage then
			arg_81_1.eff_target.turn_vars.hpup_per_damage = {}
		end
		
		if arg_81_1.eff_target:getHPRatio() >= 1 then
			return 
		end
		
		local var_81_3 = arg_81_1.eff_target:getHpUpDamageRate()
		
		arg_81_1.eff_target.turn_vars.hpup_per_damage[arg_81_1.attacker] = to_n(arg_81_1.eff_target.turn_vars.hpup_per_damage[arg_81_1.attacker]) + arg_81_1.pow * var_81_1 * var_81_3
		
		return true
	end
end

function SkillProc.effs.HPUP_SPECIFIED(arg_82_0, arg_82_1)
	local var_82_0 = to_n(arg_82_1.pow)
	local var_82_1 = arg_82_1.eff_target:heal(var_82_0)
	
	if var_82_1 > 0 then
		table.insert(arg_82_0, {
			type = "heal",
			from = arg_82_1.from,
			target = arg_82_1.eff_target,
			heal = var_82_1
		})
		
		return true
	end
end

function SkillProc.effs.CS_RANDOM(arg_83_0, arg_83_1)
	local var_83_0 = totable(arg_83_1.pow)
	
	if var_83_0.csid and var_83_0.csid ~= "" then
		local var_83_1 = var_83_0.csid
		local var_83_2 = math.min(to_n(var_83_0.amount), table.count(var_83_1))
		local var_83_3 = false
		
		for iter_83_0 = 1, var_83_2 do
			local var_83_4 = arg_83_1.eff_target.logic.random:get(1, #var_83_1)
			local var_83_5 = var_83_1[var_83_4]
			
			table.remove(var_83_1, var_83_4)
			
			if var_83_5 then
				var_83_3 = true
				
				SkillProc.addStateToTarget(arg_83_0, SkillProc.getDefaultStateOption(arg_83_1), arg_83_1.attacker, arg_83_1.eff_target, var_83_5, arg_83_1.cs_eff_turn, arg_83_1.skill_id)
			end
		end
		
		return var_83_3
	else
		local var_83_6 = string.split(arg_83_1.pow, ",")
		local var_83_7 = var_83_6[arg_83_1.eff_target.logic.random:get(1, #var_83_6)]
		
		return SkillProc.addStateToTarget(arg_83_0, SkillProc.getDefaultStateOption(arg_83_1), arg_83_1.attacker, arg_83_1.eff_target, var_83_7, arg_83_1.cs_eff_turn, arg_83_1.skill_id)
	end
end

function SkillProc.effs.CS_BGCHANGE(arg_84_0, arg_84_1)
	local var_84_0 = arg_84_1.pow
	
	arg_84_1.attacker.logic:changeStageBG(var_84_0)
	
	return true
end

CS_Util = {}

function CS_Util.getCSID(arg_85_0, arg_85_1)
	local var_85_0 = arg_85_0 or ""
	local var_85_1 = tostring(arg_85_1) or ""
	local var_85_2 = var_85_1
	
	if string.starts(var_85_0, "CS_ADD_SHIELD") then
		var_85_2 = string.lower(string.sub(var_85_0, string.len("CS_ADD_") + 1, -1))
	elseif var_85_0 == "CS_ADD_STACK" or var_85_0 == "CS_ADD_STACK_RESOURCE" then
		var_85_2 = totable(var_85_1 or "").csid
	end
	
	return var_85_2
end

function CS_Util._isApplyStateOnlyHero(arg_86_0, arg_86_1, arg_86_2)
	if not arg_86_0 then
		return true
	end
	
	if arg_86_0 and arg_86_1 and (arg_86_1:isPVP() or arg_86_2.inst.ally == FRIEND) then
		return true
	end
	
	return false
end

function CS_Util.isApplyStateOnlyHeroByCS(arg_87_0, arg_87_1)
	local var_87_0 = arg_87_0.is_only_hero
	local var_87_1 = arg_87_1 or arg_87_0.owner or {}
	local var_87_2 = var_87_1.logic
	
	return (CS_Util._isApplyStateOnlyHero(var_87_0, var_87_2, var_87_1))
end

function CS_Util.isApplyStateOnlyHeroByCSID(arg_88_0, arg_88_1)
	local var_88_0 = DB("cs", arg_88_0, "cs_only_hero") == "y"
	
	if not arg_88_1 then
		return 
	end
	
	local var_88_1 = arg_88_1.logic
	
	return (CS_Util._isApplyStateOnlyHero(var_88_0, var_88_1, arg_88_1))
end

function CS_Util.isApplyStateOnlyHeroByEff(arg_89_0, arg_89_1, arg_89_2)
	local var_89_0 = CS_Util.getCSID(arg_89_0, arg_89_1)
	
	return CS_Util.isApplyStateOnlyHeroByCSID(var_89_0, arg_89_2)
end

function SkillProc.effs.CS_ADD(arg_90_0, arg_90_1)
	local var_90_0 = CS_Util.getCSID(arg_90_1.eff, arg_90_1.pow)
	
	return SkillProc.addStateToTarget(arg_90_0, SkillProc.getDefaultStateOption(arg_90_1), arg_90_1.from, arg_90_1.eff_target, var_90_0, arg_90_1.cs_eff_turn, arg_90_1.skill_id)
end

function SkillProc.effs.CS_ADD_FROM_OWNER(arg_91_0, arg_91_1)
	local var_91_0 = CS_Util.getCSID(arg_91_1.eff, arg_91_1.pow)
	
	return SkillProc.addStateToTarget(arg_91_0, SkillProc.getDefaultStateOption(arg_91_1), arg_91_1.owner, arg_91_1.eff_target, var_91_0, arg_91_1.cs_eff_turn, arg_91_1.skill_id)
end

function SkillProc.effs.CS_ADD_SHIELD(arg_92_0, arg_92_1)
	local var_92_0
	local var_92_1 = CS_Util.getCSID(arg_92_1.eff, arg_92_1.pow)
	local var_92_2 = SkillProc.getDefaultStateOption(arg_92_1)
	
	var_92_2.override_pow = {
		arg_92_1.pow
	}
	
	local var_92_3, var_92_4 = SkillProc.addStateToTarget(arg_92_0, var_92_2, arg_92_1.from, arg_92_1.eff_target, var_92_1, arg_92_1.cs_eff_turn, arg_92_1.skill_id)
	
	return var_92_3, var_92_4
end

function SkillProc.effs.CS_ADD_STACK(arg_93_0, arg_93_1)
	local var_93_0 = CS_Util.getCSID(arg_93_1.eff, arg_93_1.pow)
	local var_93_1 = totable(arg_93_1.pow or "")
	local var_93_2
	
	var_93_2.stack_count, var_93_2 = tonumber(var_93_1.cnt) or 1, SkillProc.getDefaultStateOption(arg_93_1)
	
	local var_93_3, var_93_4 = SkillProc.addStateToTarget(arg_93_0, var_93_2, arg_93_1.from, arg_93_1.eff_target, var_93_0, arg_93_1.cs_eff_turn, arg_93_1.skill_id)
	
	return var_93_3, var_93_4
end

function SkillProc.effs.CS_ADD_ABSOLUTE(arg_94_0, arg_94_1)
	local var_94_0 = CS_Util.getCSID(arg_94_1.eff, arg_94_1.pow)
	
	return SkillProc.addStateToTarget(arg_94_0, SkillProc.getDefaultStateOption(arg_94_1), arg_94_1.from, arg_94_1.eff_target, var_94_0, arg_94_1.cs_eff_turn, arg_94_1.skill_id, true)
end

function SkillProc.effs.CS_ADD_STACK_RESOURCE(arg_95_0, arg_95_1)
	if arg_95_1.from:getSPName() == "week_gauge" or arg_95_1.from:getSPName() == "berserk_gauge" or arg_95_1.from:getSPName() == "none" then
		return false
	end
	
	local var_95_0 = CS_Util.getCSID(arg_95_1.eff, arg_95_1.pow)
	local var_95_1 = totable(arg_95_1.pow or "")
	local var_95_2 = tonumber(var_95_1.resource) or 0
	local var_95_3 = SkillProc.getDefaultStateOption(arg_95_1)
	
	if var_95_2 ~= 0 and arg_95_1.from:getSPRatio() ~= 0 then
		var_95_3.stack_count = math.floor(arg_95_1.from:getSPRatio() / var_95_2)
	else
		var_95_3.stack_count = 0
	end
	
	local var_95_4, var_95_5 = SkillProc.addStateToTarget(arg_95_0, var_95_3, arg_95_1.from, arg_95_1.eff_target, var_95_0, arg_95_1.cs_eff_turn, arg_95_1.skill_id, true)
	
	return var_95_4, var_95_5
end

function SkillProc.effs.CS_TRANSFORM(arg_96_0, arg_96_1)
	local var_96_0 = totable(tostring(arg_96_1.pow or ""))
	local var_96_1 = var_96_0.csid
	local var_96_2 = var_96_0.to
	local var_96_3, var_96_4 = arg_96_1.eff_target.states:removeStates(1, function(arg_97_0)
		local var_97_0 = CS_Util.isApplyStateOnlyHeroByCSID(var_96_2, arg_96_1.eff_target)
		
		return arg_97_0:canRemove() and var_96_1 == arg_97_0.id and var_97_0
	end)
	
	if var_96_3 and #var_96_3 > 0 then
		table.add(arg_96_0, var_96_3)
	end
	
	if var_96_4 and #var_96_4 > 0 then
		local var_96_5, var_96_6 = SkillProc.addStateToTarget(arg_96_0, SkillProc.getDefaultStateOption(arg_96_1), arg_96_1.attacker, arg_96_1.eff_target, var_96_2, var_96_4[1].turn)
		
		if var_96_5 then
			return true
		end
	end
end

function SkillProc.effs.ADD_TURN(arg_98_0, arg_98_1)
	table.insert(arg_98_0, {
		add_more = true,
		type = "add_turn",
		target = arg_98_1.eff_target,
		pow = math.floor(arg_98_1.pow)
	})
	
	return true
end

function SkillProc.effs.CD_UP(arg_99_0, arg_99_1)
	arg_99_1.eff_target:modifySkillCool(arg_99_0, nil, arg_99_1.pow, arg_99_1.attacker, arg_99_1.state, false)
	
	return true
end

function SkillProc.effs.CD_DOWN(arg_100_0, arg_100_1)
	arg_100_1.eff_target:modifySkillCool(arg_100_0, nil, 0 - arg_100_1.pow, arg_100_1.attacker, arg_100_1.state, false)
	
	return true
end

function SkillProc.effs.CD_2_UP(arg_101_0, arg_101_1)
	arg_101_1.eff_target:modifySkillCool(arg_101_0, 2, arg_101_1.pow, arg_101_1.attacker, arg_101_1.state, false)
	
	return true
end

function SkillProc.effs.CD_2_DOWN(arg_102_0, arg_102_1)
	arg_102_1.eff_target:modifySkillCool(arg_102_0, 2, 0 - arg_102_1.pow, arg_102_1.attacker, arg_102_1.state, false)
	
	return true
end

function SkillProc.effs.CD_3_UP(arg_103_0, arg_103_1)
	arg_103_1.eff_target:modifySkillCool(arg_103_0, 3, arg_103_1.pow, arg_103_1.attacker, arg_103_1.state, false)
	
	return true
end

function SkillProc.effs.CD_3_DOWN(arg_104_0, arg_104_1)
	arg_104_1.eff_target:modifySkillCool(arg_104_0, 3, 0 - arg_104_1.pow, arg_104_1.attacker, arg_104_1.state, false)
	
	return true
end

function SkillProc.effs.CD_UP_ABSOLUTE(arg_105_0, arg_105_1)
	arg_105_1.eff_target:modifySkillCool(arg_105_0, nil, arg_105_1.pow, arg_105_1.attacker, arg_105_1.state, true)
	
	return true
end

function SkillProc.effs.CD_2_UP_ABSOLUTE(arg_106_0, arg_106_1)
	arg_106_1.eff_target:modifySkillCool(arg_106_0, 2, arg_106_1.pow, arg_106_1.attacker, arg_106_1.state, true)
	
	return true
end

function SkillProc.effs.CD_3_UP_ABSOLUTE(arg_107_0, arg_107_1)
	arg_107_1.eff_target:modifySkillCool(arg_107_0, 3, arg_107_1.pow, arg_107_1.attacker, arg_107_1.state, true)
	
	return true
end

function SkillProc.effs.RESOURCE_UP(arg_108_0, arg_108_1)
	if arg_108_1.eff_target:getSPName() ~= "none" then
		local var_108_0 = arg_108_1.eff_target:getMaxSP(arg_108_1.eff_target:getSPName()) * arg_108_1.pow
		local var_108_1 = math.floor(var_108_0 + 0.5)
		
		arg_108_1.eff_target:addRes(var_108_1, arg_108_1.eff_target:getSPName())
		table.insert(arg_108_0, {
			type = "sp_heal",
			from = arg_108_1.from,
			target = arg_108_1.eff_target,
			rate = math.floor(arg_108_1.pow),
			sp_heal = var_108_1
		})
		
		return true
	end
end

function SkillProc.effs.RESOURCE_DOWN(arg_109_0, arg_109_1)
	if arg_109_1.eff_target:getSPName() ~= "none" then
		local var_109_0 = arg_109_1.eff_target:getMaxSP(arg_109_1.eff_target:getSPName()) * arg_109_1.pow
		local var_109_1 = math.floor(var_109_0 + 0.5)
		
		arg_109_1.eff_target:addRes(-var_109_1, arg_109_1.eff_target:getSPName())
		table.insert(arg_109_0, {
			type = "sp_dec",
			from = arg_109_1.from,
			target = arg_109_1.eff_target,
			rate = math.floor(arg_109_1.pow),
			sp_dec = -var_109_1
		})
		
		return true
	end
end

function SkillProc.effs.RESOURCE_BURN(arg_110_0, arg_110_1)
	if arg_110_1.eff_target:getSPName() ~= "none" then
		local var_110_0 = arg_110_1.eff_target:getMaxSP(arg_110_1.eff_target:getSPName()) * arg_110_1.pow
		local var_110_1 = math.floor(var_110_0 + 0.5)
		
		arg_110_1.eff_target:addRes(-var_110_1, arg_110_1.eff_target:getSPName(), true)
		table.insert(arg_110_0, {
			type = "sp_dec",
			from = arg_110_1.from,
			target = arg_110_1.eff_target,
			rate = math.floor(arg_110_1.pow),
			sp_dec = -var_110_1
		})
		
		return true
	end
end

function SkillProc.effs.SKILLUSE(arg_111_0, arg_111_1)
	if arg_111_1.pow and not arg_111_1.eff_target:isStunned() then
		local var_111_0 = arg_111_1.eff_target:getSkillBundle():slot(arg_111_1.pow):getSkillId()
		
		if var_111_0 then
			arg_111_1.eff_target.logic:insertAttackOrder(arg_111_1.eff_target, nil, var_111_0, true, arg_111_1.invokers, nil, {
				trigger_eff = "SKILLUSE"
			})
			
			if arg_111_1.state then
				return true
			end
		end
	end
	
	return true
end

function SkillProc.effs.SKILLUSE_ONCE(arg_112_0, arg_112_1)
	if arg_112_1.pow and not arg_112_1.eff_target:isStunned() then
		local var_112_0 = arg_112_1.eff_target:getSkillBundle():slot(arg_112_1.pow):getSkillId()
		
		if var_112_0 and arg_112_1.eff_target.logic:insertAttackOrder(arg_112_1.eff_target, nil, var_112_0, true, arg_112_1.invokers, nil, {
			trigger_eff = "SKILLUSE_ONCE",
			unique_group = "SKILLUSE"
		}) then
			return true
		end
	end
	
	return true
end

function SkillProc.effs.SKILLUSE_RANDOMTARGET(arg_113_0, arg_113_1)
	if arg_113_1.pow and not arg_113_1.eff_target:isStunned() then
		local var_113_0 = arg_113_1.eff_target:getSkillBundle():slot(arg_113_1.pow):getSkillId()
		
		if var_113_0 then
			local var_113_1 = arg_113_1.eff_target.logic:getAttackInfo(arg_113_1.eff_target)
			local var_113_2
			local var_113_3
			
			if var_113_1 then
				var_113_2 = var_113_1.d_unit
			end
			
			if var_113_2 then
				var_113_3 = var_113_2:getAlly()
			end
			
			local function var_113_4(arg_114_0)
				return arg_114_0:isEmptyHP() or arg_114_0:isDead()
			end
			
			local var_113_5 = arg_113_1.eff_target.logic:pickRandomUnits(arg_113_1.eff_target, var_113_3 or ENEMY, 1, var_113_4)
			
			arg_113_1.eff_target.logic:insertAttackOrder(arg_113_1.eff_target, var_113_5[1], var_113_0, true, arg_113_1.invokers, nil, {
				trigger_eff = "SKILLUSE_RANDOMTARGET"
			})
			
			if arg_113_1.state then
				return true
			end
		end
	end
	
	return true
end

function SkillProc.effs.SKILLUSE_TARGET_DEAD_RANDOM(arg_115_0, arg_115_1)
	if arg_115_1.pow and not arg_115_1.eff_target:isStunned() then
		local var_115_0 = arg_115_1.eff_target:getSkillBundle():slot(arg_115_1.pow):getSkillId()
		
		if var_115_0 then
			local var_115_1 = arg_115_1.eff_target.logic:getAttackInfo(arg_115_1.eff_target)
			local var_115_2
			
			if var_115_1 then
				var_115_2 = var_115_1.d_unit
			end
			
			if var_115_2 and var_115_2:isEmptyHP() then
				local var_115_3 = var_115_2:getAlly()
				
				local function var_115_4(arg_116_0)
					return arg_116_0:isEmptyHP() or arg_116_0:isDead()
				end
				
				local var_115_5 = arg_115_1.eff_target.logic:pickRandomUnits(arg_115_1.eff_target, var_115_3 or ENEMY, 1, var_115_4)
				
				arg_115_1.eff_target.logic:insertAttackOrder(arg_115_1.eff_target, var_115_5[1], var_115_0, true, arg_115_1.invokers, nil, {
					trigger_eff = "SKILLUSE_TARGET_DEAD_RANDOM"
				})
			else
				arg_115_1.eff_target.logic:insertAttackOrder(arg_115_1.eff_target, nil, var_115_0, true, arg_115_1.invokers, nil, {
					trigger_eff = "SKILLUSE_TARGET_DEAD_RANDOM"
				})
			end
			
			if arg_115_1.state then
				return true
			end
		end
	end
	
	return true
end

function SkillProc.effs.CS_BANNER(arg_117_0, arg_117_1)
	local var_117_0 = string.split(arg_117_1.pow, ",")
	local var_117_1 = {}
	
	for iter_117_0, iter_117_1 in pairs(var_117_0) do
		local var_117_2 = string.split(iter_117_1, "=")
		
		var_117_1[var_117_2[1]] = var_117_2[2] or ""
	end
	
	table.insert(arg_117_0, {
		type = "banner",
		info = var_117_1
	})
end

function SkillProc.effs.CS_BGEFFECT(arg_118_0, arg_118_1)
	local var_118_0 = string.split(arg_118_1.pow, ",")
	local var_118_1 = {}
	
	for iter_118_0, iter_118_1 in pairs(var_118_0) do
		local var_118_2 = string.split(iter_118_1, "=")
		
		var_118_1[var_118_2[1]] = var_118_2[2] or ""
	end
	
	table.insert(arg_118_0, {
		type = "bg_effect",
		eff_info = var_118_1
	})
end

function SkillProc.effs.CSA_TEAMCHANGE(arg_119_0, arg_119_1)
	local var_119_0 = string.split(arg_119_1.pow, ",")
	local var_119_1 = {}
	
	for iter_119_0, iter_119_1 in pairs(var_119_0) do
		local var_119_2 = string.split(iter_119_1, "=")
		
		var_119_1[var_119_2[1]] = var_119_2[2] or ""
	end
	
	arg_119_1.eff_target.logic:reserveSwapTeam(var_119_1)
end

function SkillProc.effs.HPDOWN_CASTER_ATT(arg_120_0, arg_120_1)
	local var_120_0 = table.clone(arg_120_1.eff_target.status)
	
	var_120_0.def = math.floor(var_120_0.def * 0.3)
	
	local var_120_1 = math.max(1, math.floor(FORMULA.dmg(arg_120_1.giver_status, var_120_0) * arg_120_1.pow))
	local var_120_2 = SkillProc.getAdditionalDamageIncrease(arg_120_1)
	local var_120_3 = SkillProc.getAdditionalDamageDecrease(arg_120_1)
	local var_120_4 = SkillProc.CalcEffectDamage(var_120_1, var_120_2, var_120_3)
	local var_120_5, var_120_6, var_120_7 = arg_120_1.eff_target:decHP(arg_120_0, var_120_4)
	
	table.insert(arg_120_0, {
		type = "attack",
		from = arg_120_1.giver,
		target = arg_120_1.eff_target,
		damage = var_120_5,
		shield = var_120_6,
		dec_hp = var_120_7
	})
	
	return true
end

function SkillProc.effs.HPDOWN_STATUS(arg_121_0, arg_121_1)
	local var_121_0 = table.clone(arg_121_1.eff_target.status)
	
	var_121_0.def = math.floor(var_121_0.def * 0.3)
	
	local var_121_1 = totable(arg_121_1.pow)
	local var_121_2
	
	if var_121_1.target == "caster" then
		var_121_2 = arg_121_1.giver
	else
		var_121_2 = arg_121_1.owner
	end
	
	local var_121_3 = table.clone(var_121_2:getStatus())
	local var_121_4 = var_121_1.ability
	local var_121_5 = 0
	
	if var_121_4 == "max_hp" then
		var_121_5 = var_121_2:getMaxHP()
	else
		var_121_5 = var_121_3[var_121_4]
	end
	
	local var_121_6 = var_121_1.rate
	
	var_121_3.att = 0
	var_121_3.bonus_att = var_121_5 * var_121_6
	
	local var_121_7 = math.max(1, math.floor(FORMULA.dmg(var_121_3, var_121_0)))
	local var_121_8, var_121_9, var_121_10 = arg_121_1.eff_target:decHP(arg_121_0, var_121_7)
	
	table.insert(arg_121_0, {
		type = "attack",
		from = var_121_2,
		target = arg_121_1.eff_target,
		damage = var_121_8,
		shield = var_121_9,
		dec_hp = var_121_10
	})
	
	return true
end

function SkillProc.effs.HPDOWN_STATUS_FIX_DAMAMGE(arg_122_0, arg_122_1)
	local var_122_0 = table.clone(arg_122_1.eff_target.status)
	
	var_122_0.def = math.floor(var_122_0.def * 0.3)
	
	local var_122_1 = totable(arg_122_1.pow)
	local var_122_2
	
	if var_122_1.target == "caster" then
		var_122_2 = arg_122_1.giver
	else
		var_122_2 = arg_122_1.owner
	end
	
	local var_122_3 = table.clone(var_122_2:getStatus())
	local var_122_4 = var_122_1.ability
	local var_122_5 = 0
	
	if var_122_4 == "max_hp" then
		var_122_5 = var_122_2:getMaxHP()
	else
		var_122_5 = var_122_3[var_122_4]
	end
	
	local var_122_6 = var_122_1.rate
	
	var_122_3.att = 0
	var_122_3.bonus_att = var_122_5 * var_122_6
	
	local var_122_7 = math.max(1, math.floor(var_122_5 * var_122_6))
	local var_122_8, var_122_9, var_122_10 = arg_122_1.eff_target:decHP(arg_122_0, var_122_7)
	
	table.insert(arg_122_0, {
		type = "attack",
		from = var_122_2,
		target = arg_122_1.eff_target,
		damage = var_122_8,
		shield = var_122_9,
		dec_hp = var_122_10
	})
	
	return true
end

function SkillProc.effs.HPDOWN_CASTER_MAXHP(arg_123_0, arg_123_1)
	local var_123_0 = math.max(1, math.floor(arg_123_1.pow * arg_123_1.from:getMaxHP()))
	local var_123_1, var_123_2, var_123_3 = arg_123_1.eff_target:decHP(arg_123_0, var_123_0)
	
	table.insert(arg_123_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_123_1.from,
		target = arg_123_1.eff_target,
		damage = var_123_1,
		shield = var_123_2,
		dec_hp = var_123_3
	})
	
	return true
end

function SkillProc.effs.DAMAGE_FIXED(arg_124_0, arg_124_1)
	local var_124_0, var_124_1, var_124_2 = arg_124_1.eff_target:decHP(arg_124_0, arg_124_1.pow)
	
	table.insert(arg_124_0, {
		type = "attack",
		from = arg_124_1.giver,
		target = arg_124_1.eff_target,
		damage = var_124_0,
		shield = var_124_1,
		dec_hp = var_124_2
	})
	
	return true
end

function SkillProc.effs.CSA_DAMAGE_INCREASE(arg_125_0, arg_125_1)
	local var_125_0 = arg_125_1.eff_target:skillDamageTag(arg_125_1.attacker)
	
	if not var_125_0 then
		return false
	end
	
	local var_125_1 = math.floor(var_125_0.original_damage * arg_125_1.pow)
	
	var_125_0.damage = math.max(1, var_125_0.damage + var_125_1)
	
	table.insert(arg_125_0, {
		type = "dec_damage",
		target = arg_125_1.eff_target
	})
	
	return true
end

function SkillProc.effs.CSA_DAMAGE_REDUCE(arg_126_0, arg_126_1)
	local var_126_0 = arg_126_1.eff_target:skillDamageTag(arg_126_1.attacker)
	
	if not var_126_0 then
		return false
	end
	
	if var_126_0.ignore_damage_reduce then
		return false
	end
	
	local var_126_1 = math.floor(var_126_0.original_damage * arg_126_1.pow)
	
	if var_126_0.decreased_damage then
		if var_126_1 <= var_126_0.decreased_damage then
			return false
		else
			var_126_1 = var_126_1 - var_126_0.decreased_damage
		end
	end
	
	var_126_0.damage = math.max(1, var_126_0.damage - var_126_1)
	
	table.insert(arg_126_0, {
		type = "dec_damage",
		target = arg_126_1.eff_target
	})
	
	var_126_0.decreased_damage = (var_126_0.decreased_damage or 0) + var_126_1
	
	return true
end

function SkillProc.effs.CSA_DAMAGE_REDUCE_SELFMAXHP(arg_127_0, arg_127_1)
	local var_127_0 = arg_127_1.eff_target:skillDamageTag(arg_127_1.attacker)
	
	if not var_127_0 then
		return false
	end
	
	if var_127_0.ignore_damage_reduce and not var_127_0.ignore_reduce_effect_by_target then
		return false
	end
	
	local var_127_1 = math.max(1, math.floor(arg_127_1.eff_target:getMaxHP() * arg_127_1.pow))
	
	if var_127_1 >= var_127_0.original_damage then
		return 
	end
	
	local var_127_2 = var_127_0.original_damage - var_127_1
	
	if var_127_0.decreased_damage then
		if var_127_2 <= var_127_0.decreased_damage then
			return false
		else
			var_127_2 = var_127_2 - var_127_0.decreased_damage
		end
	end
	
	var_127_0.damage = math.max(1, var_127_0.damage - var_127_2)
	
	table.insert(arg_127_0, {
		type = "dec_damage",
		target = arg_127_1.eff_target
	})
	
	var_127_0.decreased_damage = (var_127_0.decreased_damage or 0) + var_127_2
	
	return true
end

function SkillProc.effs.CSA_DAMAGE_REDUCE_SELFMAXHP_FINAL_SUMMATION(arg_128_0, arg_128_1)
	local var_128_0 = arg_128_1.eff_target:skillDamageTag(arg_128_1.attacker)
	
	if not var_128_0 then
		return false
	end
	
	if var_128_0.ignore_damage_reduce and not var_128_0.ignore_reduce_effect_by_target then
		return false
	end
	
	local var_128_1 = math.max(1, math.floor(arg_128_1.eff_target:getMaxHP() * arg_128_1.pow))
	
	if var_128_1 >= var_128_0.damage then
		return 
	end
	
	local var_128_2 = var_128_0.damage - var_128_1
	
	if var_128_0.decreased_damage and var_128_2 < var_128_0.decreased_damage and math.max(1, var_128_0.damage - var_128_2) >= var_128_0.damage then
		return false
	end
	
	var_128_0.damage = math.max(1, var_128_0.damage - var_128_2)
	
	table.insert(arg_128_0, {
		type = "dec_damage",
		target = arg_128_1.eff_target
	})
	
	var_128_0.decreased_damage = (var_128_0.decreased_damage or 0) + var_128_2
	
	return true
end

function SkillProc.effs.CSA_REVIVE_SELF(arg_129_0, arg_129_1)
	if arg_129_1.eff_target:isEmptyHP() and not arg_129_1.eff_target:getResurrectBlock() then
		local var_129_0 = 0
		local var_129_1
		
		if tonumber(arg_129_1.pow) then
			var_129_0 = arg_129_1.pow
		else
			local var_129_2 = totable(arg_129_1.pow)
			local var_129_3 = tonumber(var_129_2.hp)
			
			if var_129_3 then
				var_129_0 = var_129_3
			else
				var_129_0 = (tonumber(string.sub(var_129_2.hp, 1, -2)) or 0) * 0.01
			end
			
			var_129_1 = var_129_2.csid
		end
		
		arg_129_1.eff_target:reserveResurrection(var_129_0, {
			cs = {
				var_129_1
			}
		})
		
		if arg_129_1.state then
			return true
		end
	end
end

function SkillProc.effs.CSA_DAMAGE_SOLIDARITY(arg_130_0, arg_130_1)
	local var_130_0 = arg_130_1.eff_target
	local var_130_1 = totable(arg_130_1.pow)
	local var_130_2 = to_n(var_130_1.damage)
	local var_130_3 = var_130_0.logic:pickUnits(var_130_0, FRIEND, nil, true, nil, true)
	local var_130_4 = 0
	local var_130_5
	
	if var_130_1.targetgroup then
		var_130_5 = SkillProc.getTargetGroupData(var_130_1.targetgroup)
	else
		var_130_5 = var_130_1.target
	end
	
	local var_130_6 = var_130_1.exclude_self == "y"
	
	for iter_130_0, iter_130_1 in pairs(var_130_3) do
		if var_130_6 and iter_130_1 == var_130_0 then
		else
			local var_130_7 = iter_130_1:getTargetAccumDamage(var_130_5)
			
			if var_130_7 > 0 then
				var_130_4 = var_130_4 + var_130_7
			end
		end
	end
	
	local var_130_8 = math.floor(var_130_4 * var_130_2)
	local var_130_9, var_130_10, var_130_11 = var_130_0:decHP(arg_130_0, var_130_8, {})
	
	if var_130_8 > 0 then
		table.insert(arg_130_0, {
			type = "damage_solidarity",
			target = var_130_0
		})
		table.insert(arg_130_0, {
			type = "attack",
			from = arg_130_1.giver,
			target = var_130_0,
			damage = var_130_9,
			shield = var_130_10,
			dec_hp = var_130_11
		})
	end
	
	return var_130_8 > 0
end

function SkillProc.effs.EXPLOSION_DEBUFF(arg_131_0, arg_131_1)
	local var_131_0 = arg_131_1.eff_target.states:onDebuffExplosion({
		pow = arg_131_1.pow,
		candidates = {
			"HPDOWN_TARGET_MAXHP",
			"HPDOWN_CASTER_ATT",
			"HPDOWN_TARGET_MAXHP_DHP"
		}
	})
	
	table.add(arg_131_0, var_131_0)
	
	return #var_131_0 > 0
end

function SkillProc.effs.REVIVE_BLOCK(arg_132_0, arg_132_1)
	if arg_132_1.eff_target.states:isExistEffect("CSP_IMMUNE_REVIVE_BLOCK") then
		return false
	end
	
	if arg_132_1.eff_target:isEmptyHP() or arg_132_1.eff_target:isDead() then
		arg_132_1.eff_target:setResurrectBlock(arg_132_0)
	else
		arg_132_1.eff_target:setReserveResurrectBlock()
	end
	
	return true
end

function SkillProc.effs.SHIELD_TO_DAMAGE(arg_133_0, arg_133_1)
	local var_133_0 = arg_133_1.eff_target.states:getShield()
	
	if var_133_0 > 0 then
		local var_133_1, var_133_2 = arg_133_1.eff_target.states:removeStates(-1, function(arg_134_0)
			return arg_134_0:isBarrier()
		end)
		
		if var_133_1 and #var_133_1 > 0 then
			table.add(arg_133_0, var_133_1)
		end
		
		if #var_133_2 > 0 then
			local var_133_3 = math.max(1, round(var_133_0))
			local var_133_4, var_133_5, var_133_6 = arg_133_1.eff_target:decHP(arg_133_0, var_133_3, {
				ignore_shield = true
			})
			
			table.insert(arg_133_0, {
				cur_hit = 1,
				tot_hit = 1,
				type = "attack",
				from = arg_133_1.from,
				target = arg_133_1.eff_target,
				damage = var_133_4,
				shield = var_133_5,
				dec_hp = var_133_6
			})
		end
	end
end

function SkillProc.effs.RESOURCE_UP_ENEMY_BUFF_SCALE(arg_135_0, arg_135_1)
	local var_135_0 = 0
	local var_135_1 = arg_135_1.eff_target.logic:pickUnits(arg_135_1.eff_target, ENEMY)
	
	for iter_135_0, iter_135_1 in pairs(var_135_1) do
		local var_135_2 = iter_135_1.states:getTypeCount("buff")
		
		var_135_0 = var_135_0 + to_n(var_135_2)
	end
	
	local var_135_3 = math.ceil(var_135_0 * arg_135_1.pow)
	
	arg_135_1.eff_target:addRes(var_135_3, arg_135_1.eff_target:getSPName())
	table.insert(arg_135_0, {
		type = "sp_heal",
		from = arg_135_1.from,
		target = arg_135_1.eff_target,
		rate = math.floor(arg_135_1.pow),
		sp_heal = var_135_3
	})
	
	return true
end

function SkillProc.effs.RESOURCE_UP_ALLY_DEBUFF_SCALE(arg_136_0, arg_136_1)
	local var_136_0 = 0
	local var_136_1 = arg_136_1.eff_target.logic:pickUnits(arg_136_1.eff_target, FRIEND)
	
	for iter_136_0, iter_136_1 in pairs(var_136_1) do
		local var_136_2 = iter_136_1.states:getTypeCount("debuff")
		
		var_136_0 = var_136_0 + to_n(var_136_2)
	end
	
	local var_136_3 = math.ceil(var_136_0 * arg_136_1.pow)
	
	arg_136_1.eff_target:addRes(var_136_3, arg_136_1.eff_target:getSPName())
	table.insert(arg_136_0, {
		type = "sp_heal",
		from = arg_136_1.from,
		target = arg_136_1.eff_target,
		rate = math.floor(arg_136_1.pow),
		sp_heal = var_136_3
	})
	
	return true
end

function SkillProc.effs.CASTER_HPDOWN_MAXHP(arg_137_0, arg_137_1)
	if arg_137_1.from:isDead() then
		return false
	end
	
	local var_137_0 = math.max(1, math.floor(arg_137_1.pow * arg_137_1.from:getMaxHP()))
	local var_137_1, var_137_2, var_137_3 = arg_137_1.from:decHP(arg_137_0, var_137_0)
	
	table.insert(arg_137_0, {
		cur_hit = 1,
		tot_hit = 1,
		type = "attack",
		from = arg_137_1.from,
		target = arg_137_1.from,
		damage = var_137_1,
		shield = var_137_2,
		dec_hp = var_137_3
	})
	
	return true
end

function SkillProc.effs.DHP_UP_DAMAGE(arg_138_0, arg_138_1)
	local var_138_0 = arg_138_1.eff_target:skillDamageTag(arg_138_1.attacker)
	
	if not var_138_0 then
		return false
	end
	
	local var_138_1 = var_138_0.dec_hp * arg_138_1.pow
	
	if var_138_0.dec_hp <= to_n(var_138_0.dhp) + var_138_1 then
		var_138_1 = math.min(var_138_0.dec_hp - to_n(var_138_0.dhp), var_138_1)
	end
	
	if var_138_1 > 0 then
		local var_138_2 = arg_138_1.eff_target:increaseBrokenHP(var_138_1)
		
		table.insert(arg_138_0, {
			type = "dhp_inc",
			from = arg_138_1.from,
			target = arg_138_1.eff_target,
			dhp = var_138_2
		})
		
		var_138_0.dhp = (var_138_0.dhp or 0) + var_138_2
		
		return true
	end
	
	return false
end

function SkillProc.effs.DHP_UP_DAMAGE_LIMIT(arg_139_0, arg_139_1)
	local var_139_0 = arg_139_1.eff_target:skillDamageTag(arg_139_1.attacker)
	
	if not var_139_0 then
		return false
	end
	
	local var_139_1 = arg_139_1.eff_target:getRawMaxHP() * arg_139_1.pow
	
	if var_139_1 > var_139_0.dec_hp then
		var_139_1 = var_139_0.dec_hp
	end
	
	if var_139_0.dec_hp <= to_n(var_139_0.dhp) + var_139_1 then
		var_139_1 = math.min(var_139_0.dec_hp - to_n(var_139_0.dhp), var_139_1)
	end
	
	if var_139_1 > 0 then
		local var_139_2 = arg_139_1.eff_target:increaseBrokenHP(var_139_1)
		
		table.insert(arg_139_0, {
			type = "dhp_inc",
			from = arg_139_1.from,
			target = arg_139_1.eff_target,
			dhp = var_139_2
		})
		
		var_139_0.dhp = (var_139_0.dhp or 0) + var_139_2
		
		return true
	end
	
	return false
end

function SkillProc.effs.DEBUFF_REMOVE_TO_CS_RANDOM(arg_140_0, arg_140_1)
	local var_140_0 = 0
	local var_140_1 = false
	
	if arg_140_1.eff_target.states:canRemove() then
		local var_140_2, var_140_3 = arg_140_1.eff_target.states:removeStates(-1, function(arg_141_0)
			return arg_141_0.db.cs_type == "debuff" and arg_141_0:canRemove()
		end)
		
		var_140_0 = table.count(var_140_3)
		
		if var_140_2 and table.count(var_140_2) > 0 then
			table.add(arg_140_0, var_140_2)
		end
		
		if var_140_3 and var_140_0 > 0 then
			var_140_1 = true
			
			table.insert(arg_140_0, {
				type = "remove_debuffs",
				from = arg_140_1.attacker,
				target = arg_140_1.eff_target
			})
		elseif arg_140_1.eff_con_flags and arg_140_1.eff_idx then
			arg_140_1.eff_con_flags[arg_140_1.eff_idx] = false
		end
	elseif arg_140_1.eff_con_flags and arg_140_1.eff_idx then
		arg_140_1.eff_con_flags[arg_140_1.eff_idx] = false
	end
	
	local var_140_4
	
	if var_140_0 > 0 then
		var_140_4 = string.split(arg_140_1.pow, ",")
		
		local var_140_5 = math.min(to_n(var_140_0), table.count(var_140_4))
		
		for iter_140_0 = 1, var_140_5 do
			local var_140_6 = arg_140_1.eff_target.logic.random:get(1, table.count(var_140_4))
			local var_140_7 = var_140_4[var_140_6]
			
			table.remove(var_140_4, var_140_6)
			
			if var_140_7 then
				SkillProc.addStateToTarget(arg_140_0, SkillProc.getDefaultStateOption(arg_140_1), arg_140_1.attacker, arg_140_1.eff_target, var_140_7, arg_140_1.cs_eff_turn, arg_140_1.skill_id)
			end
		end
	end
	
	return var_140_1
end

function SkillProc.getDefaultStateOption(arg_142_0)
	arg_142_0 = arg_142_0 or {}
	
	local var_142_0 = "normal"
	
	if arg_142_0.attacker then
		local var_142_1 = arg_142_0.attacker.logic:getAttackInfo(arg_142_0.attacker)
		
		if var_142_1 then
			if var_142_1.hidden then
				var_142_0 = "hidden"
			elseif (var_142_1.coop_order or 0) > 1 then
				var_142_0 = "coop"
			end
		end
	end
	
	return {
		timming = arg_142_0.timming,
		action_type = var_142_0
	}
end

function SkillProc.addStateToTarget(arg_143_0, arg_143_1, arg_143_2, arg_143_3, arg_143_4, arg_143_5, arg_143_6, arg_143_7)
	arg_143_1 = arg_143_1 or {}
	arg_143_4 = tostring(arg_143_4)
	
	local var_143_0
	local var_143_1
	local var_143_2
	
	if arg_143_3.states:isImmune(arg_143_4) or not arg_143_7 and arg_143_3.states:isBlock_CS(arg_143_4) then
		table.insert(arg_143_0, {
			text = "sk_immune",
			type = "text",
			target = arg_143_3
		})
		
		return false
	else
		local var_143_3, var_143_4
		
		var_143_3, var_143_1, var_143_4 = arg_143_3:addState(arg_143_4, 1, arg_143_2, {
			turn = arg_143_5,
			skill_id = arg_143_6,
			force_apply = arg_143_7,
			stack_count = arg_143_1.stack_count,
			override_pow = arg_143_1.override_pow
		})
		
		if var_143_3 then
			table.insert(arg_143_0, {
				type = "add_state",
				from = arg_143_2,
				target = arg_143_3,
				state = var_143_1
			})
		end
		
		local var_143_5 = false
		
		if arg_143_1.action_type == "normal" then
			if arg_143_2 and arg_143_2 == arg_143_3 then
				local var_143_6 = arg_143_3:getSkillDB(arg_143_6, {
					"sk_start_eff_value"
				})
				
				var_143_5 = var_143_6 and tostring(var_143_6) == tostring(var_143_4)
			end
			
			if arg_143_1.timming and arg_143_1.timming == 32 then
				var_143_5 = true
			end
		end
		
		if var_143_3 and arg_143_3.logic:getTurnOwner() == arg_143_3 and arg_143_3.logic:getTurnState() ~= "pending_start" and not var_143_5 then
			arg_143_3.turn_vars.no_turn_cs = arg_143_3.turn_vars.no_turn_cs or {}
			
			table.insert(arg_143_3.turn_vars.no_turn_cs, var_143_1.uid)
		end
		
		if arg_143_3:isStunned() then
			arg_143_3:onCalcExtinct("stun", arg_143_0)
		end
	end
	
	return true, var_143_1
end

function SkillProc.CalcEffectDamage(arg_144_0, arg_144_1, arg_144_2)
	arg_144_0 = math.floor(arg_144_0 * math.max(1 + (arg_144_1 - arg_144_2), 0))
	
	return arg_144_0
end

function SkillProc.getAdditionalDamageIncrease(arg_145_0)
	if not arg_145_0.state then
		return 0
	end
	
	local var_145_0 = arg_145_0.state.inc_value or 0
	
	if arg_145_0.state.owner and arg_145_0.state.owner.states:isExistEffect("CSP_CS_GROUP_DMG_UP") then
		local var_145_1 = arg_145_0.state.owner.states:findAllEffValues("CSP_CS_GROUP_DMG_UP")
		
		for iter_145_0, iter_145_1 in pairs(var_145_1) do
			local var_145_2 = totable(iter_145_1) or {}
			local var_145_3 = arg_145_0.state.db.cs_group or arg_145_0.state.db.id
			
			if var_145_3 ~= nil and tostring(var_145_3) == tostring(var_145_2.csgroup) then
				local var_145_4 = to_n(var_145_2.rate)
				
				var_145_0 = var_145_0 + math.max(var_145_4, 0)
			end
		end
	end
	
	return var_145_0
end

function SkillProc.getFixDamageDecrease(arg_146_0)
	local var_146_0 = 0
	
	if arg_146_0.from and arg_146_0.from.states:isExistEffect("CSP_HPDOWN_FIXED_DECREASE") then
		local var_146_1 = arg_146_0.from.states:getAllEffValue("CSP_HPDOWN_FIXED_DECREASE", function(arg_147_0)
			if arg_147_0:isPassiveBlocked() then
				return false
			end
			
			return true
		end)
		
		var_146_0 = math.clamp(var_146_1, 0, 1)
	end
	
	return var_146_0
end

function SkillProc.getAdditionalDamageDecrease(arg_148_0)
	local var_148_0 = 0
	
	if not arg_148_0.state then
		return var_148_0
	end
	
	local var_148_1 = arg_148_0.state.dec_value or 0
	
	if arg_148_0.state.db.cs_type == "debuff" then
		return var_148_1
	end
	
	if not arg_148_0.from then
		return var_148_1
	end
	
	local function var_148_2(arg_149_0, arg_149_1)
		return arg_149_0.states:getAllEffValue(arg_149_1, function(arg_150_0)
			if arg_150_0:isPassiveBlocked() then
				return false
			end
			
			return true
		end)
	end
	
	local function var_148_3(arg_151_0)
		if arg_151_0.db.color == "fire" or arg_151_0.db.color == "ice" or arg_151_0.db.color == "wind" then
			return true
		end
		
		return false
	end
	
	local function var_148_4(arg_152_0)
		if arg_152_0.db.color == "light" or arg_152_0.db.color == "dark" then
			return true
		end
		
		return false
	end
	
	if arg_148_0.eff_target.states:isExistEffect("CSP_IGNORE_DAMAGE_REDUCE") then
		return 0
	end
	
	if arg_148_0.eff_target.states:isExistEffect("CSP_ADDITIONAL_DAMAGE_DOWN_ATTRIBUTE") then
		local var_148_5 = IS_STRONG_COLOR_AGAINST[arg_148_0.eff_target.db.color][arg_148_0.from.db.color]
		
		if var_148_3(arg_148_0.eff_target) and var_148_5 then
			var_148_1 = var_148_1 + var_148_2(arg_148_0.eff_target, "CSP_ADDITIONAL_DAMAGE_DOWN_ATTRIBUTE")
		end
	end
	
	if arg_148_0.eff_target.states:isExistEffect("CSP_ADDITIONAL_DAMAGE_DOWN_SELF_COVENANT_ENEMY_MOONLIGHT") and var_148_3(arg_148_0.eff_target) and var_148_4(arg_148_0.from) then
		var_148_1 = var_148_1 + var_148_2(arg_148_0.eff_target, "CSP_ADDITIONAL_DAMAGE_DOWN_SELF_COVENANT_ENEMY_MOONLIGHT")
	end
	
	if arg_148_0.eff_target.states:isExistEffect("CSP_ADDITIONAL_DAMAGE_DOWN") then
		var_148_1 = var_148_1 + var_148_2(arg_148_0.eff_target, "CSP_ADDITIONAL_DAMAGE_DOWN")
	end
	
	return math.clamp(var_148_1, 0, 1)
end

function SkillProc.onPreCalcDamage_Skill(arg_153_0, arg_153_1, arg_153_2, arg_153_3, arg_153_4, arg_153_5, arg_153_6)
	local var_153_0, var_153_1, var_153_2, var_153_3, var_153_4, var_153_5 = arg_153_2:getSkillDB(arg_153_4, {
		"sk_before_con",
		"sk_before_con_target",
		"sk_before_con_value",
		"sk_before_rate",
		"sk_before_eff",
		"sk_before_eff_value"
	})
	
	if var_153_0 and not SkillProc.checkCommonCon(arg_153_2, arg_153_4, var_153_0, var_153_1, var_153_2, arg_153_3, {
		arg_153_3
	}, nil, nil, nil) then
		return 
	end
	
	if var_153_3 and var_153_3 < 1 and var_153_3 < arg_153_1:get() then
		return 
	end
	
	return SkillProc.procPreCalcDamage(arg_153_0, var_153_4, var_153_5, arg_153_2, arg_153_3, arg_153_5, arg_153_6, arg_153_4)
end

function SkillProc.procPreCalcTarget(arg_154_0, arg_154_1, arg_154_2, arg_154_3, arg_154_4, arg_154_5, arg_154_6)
	local var_154_0 = SkillProc.getImmuneDefPenSeq(arg_154_4, arg_154_1, arg_154_5, arg_154_6)
	
	if arg_154_1 == "DBF_DECREASE_DODGE" then
		arg_154_6.dodge = arg_154_6.dodge - arg_154_2
	elseif arg_154_1 == "DBF_INCREASE_DAMAGE" then
		arg_154_6.self_dmg = arg_154_6.self_dmg + arg_154_2
	elseif arg_154_1 == "DBF_DEFPEN_STATUS_DIFF" then
		local var_154_1 = SkillProc._stat_compare_rate_by_condition(arg_154_2, arg_154_3, arg_154_4, arg_154_5, arg_154_6)
		
		arg_154_6.def = arg_154_6.def * (1 - var_154_1)
	end
	
	if var_154_0.activated then
		SkillProc.aceivateImmuneDefPen(var_154_0, arg_154_5, arg_154_6)
		
		return false
	end
	
	return true
end

function SkillProc.get_target_value(arg_155_0, arg_155_1, arg_155_2)
	local var_155_0 = arg_155_1[arg_155_2] or 0
	
	if arg_155_2 == "max_hp" then
		var_155_0 = var_155_0 - arg_155_0:getBrokenHP()
	end
	
	return var_155_0
end

function SkillProc._stat_compare_rate_by_condition(arg_156_0, arg_156_1, arg_156_2, arg_156_3, arg_156_4)
	local var_156_0 = totable(arg_156_0)
	local var_156_1 = var_156_0.ability
	
	if not arg_156_4 then
		return 0
	end
	
	local var_156_2 = var_156_0.default or 0
	local var_156_3 = 0
	local var_156_4
	local var_156_5
	
	if var_156_0.type == "enemy_high" then
		var_156_4 = SkillProc.get_target_value(arg_156_2, arg_156_4, var_156_1)
		var_156_5 = SkillProc.get_target_value(arg_156_1, arg_156_3, var_156_1)
	elseif var_156_0.type == "self_high" then
		var_156_4 = SkillProc.get_target_value(arg_156_1, arg_156_3, var_156_1)
		var_156_5 = SkillProc.get_target_value(arg_156_2, arg_156_4, var_156_1)
	end
	
	if not var_156_4 or not var_156_5 then
		return 0
	end
	
	local var_156_6 = var_156_4 - var_156_5
	local var_156_7 = var_156_0.rate or 0
	local var_156_8 = math.max(0, var_156_6 * var_156_7) + var_156_2
	
	if var_156_0.max then
		var_156_3 = math.clamp(var_156_8, 0, var_156_0.max)
	else
		var_156_3 = math.max(0, var_156_8)
	end
	
	return var_156_3
end

function SkillProc.procPreCalcDamage(arg_157_0, arg_157_1, arg_157_2, arg_157_3, arg_157_4, arg_157_5, arg_157_6, arg_157_7)
	local var_157_0 = SkillProc.getImmuneDefPenSeq(arg_157_4, arg_157_1, arg_157_5, arg_157_6)
	
	if arg_157_1 == "BF_ATT_DEFPEN" then
		arg_157_6.def = arg_157_6.def * (1 - arg_157_2)
	elseif arg_157_1 == "BF_ATT_UP" then
		arg_157_5.att = arg_157_5.att * (1 + arg_157_2)
	elseif arg_157_1 == "BF_DMG_UP" then
		arg_157_5.dmg = arg_157_5.dmg + arg_157_2
	elseif arg_157_1 == "BF_DMG_UP_TARGET_LESS" then
		local var_157_1 = #arg_157_3.logic:pickEnemies(arg_157_3)
		
		if var_157_1 < 4 then
			arg_157_5.dmg = arg_157_5.dmg + (4 - var_157_1) * arg_157_2
		end
	elseif arg_157_1 == "BF_DMG_UP_TARGET_MORE" then
		local var_157_2 = #arg_157_3.logic:pickEnemies(arg_157_3)
		
		if var_157_2 > 1 then
			arg_157_5.dmg = arg_157_5.dmg + math.min(3, var_157_2 - 1) * arg_157_2
		end
	elseif arg_157_1 == "BF_DMG_UP_SELF_SHIELD" then
		local var_157_3 = arg_157_3.states:getShield() * arg_157_2 / 100
		
		arg_157_5.dmg = arg_157_5.dmg + var_157_3
	elseif arg_157_1 == "BF_DMG_UP_SELF_AB" then
		if arg_157_3.logic:getTurnOwner() ~= arg_157_3 then
			local var_157_4 = math.clamp(arg_157_3.inst.elapsed_ut, 0, MAX_UNIT_TICK) / MAX_UNIT_TICK
			
			arg_157_5.dmg = arg_157_5.dmg + var_157_4 * arg_157_2
		end
	elseif arg_157_1 == "BF_CON_UP" then
		arg_157_5.con = arg_157_5.con + arg_157_2
	elseif arg_157_1 == "BF_CON_DOWN" then
		arg_157_5.con = arg_157_5.con - arg_157_2
	elseif arg_157_1 == "BF_CRI_UP" then
		arg_157_5.cri = arg_157_5.cri + arg_157_2
	elseif arg_157_1 == "BF_CRIDMG_UP" then
		arg_157_5.cri_dmg = arg_157_5.cri_dmg + arg_157_2
	elseif arg_157_1 == "BF_IGNORE_CRITICAL" then
		arg_157_5.ignore_critical = true
	elseif arg_157_1 == "BF_IGNORE_SMITE" then
		arg_157_5.ignore_smite = true
	elseif arg_157_1 == "BF_DMG_UP_TARGET_DEBUFF" then
		local var_157_5 = arg_157_4.states:getTypeCount("debuff")
		
		arg_157_5.dmg = arg_157_5.dmg + arg_157_2 * var_157_5
	elseif arg_157_1 == "BF_DMG_UP_CASTER_RESOURCE_SAVE" then
		arg_157_5.att = arg_157_5.att * (1 + arg_157_3.skill_inst_vars.res_ratio * arg_157_2)
	elseif arg_157_1 == "BF_DMG_UP_CASTER_RESOURCE_REMOVE" then
		arg_157_5.att = arg_157_5.att * (1 + arg_157_3.skill_inst_vars.res_ratio * arg_157_2)
		arg_157_3.skill_inst_vars.clear_res = true
	elseif arg_157_1 == "BF_DMG_UP_STATUS_MUL" or arg_157_1 == "BF_BONUSATT_UP_STATUS_ADD" then
		local var_157_6 = string.split(arg_157_2, ",")
		local var_157_7 = {}
		
		for iter_157_0, iter_157_1 in pairs(var_157_6) do
			local var_157_8 = string.split(iter_157_1, "=")
			
			var_157_7[var_157_8[1]] = var_157_8[2] or ""
		end
		
		local var_157_9 = arg_157_3
		local var_157_10 = arg_157_5
		local var_157_11 = tonumber(var_157_7.rate) or 0
		
		if var_157_7.target == "target" then
			var_157_9 = arg_157_4
			var_157_10 = arg_157_6
		elseif var_157_7.target == "att_ally" then
			var_157_9 = arg_157_3
			var_157_10 = arg_157_5
			
			for iter_157_2, iter_157_3 in pairs(arg_157_3.logic:pickUnits(arg_157_3, FRIEND)) do
				if not iter_157_3:isDead() and var_157_9.status.att < iter_157_3.status.att then
					var_157_9 = iter_157_3
					var_157_10 = iter_157_3.status
				end
			end
		end
		
		if var_157_7.ability then
			local var_157_12 = var_157_7.ability
			local var_157_13 = 0
			
			if var_157_12 == "nowhp" then
				var_157_13 = var_157_9.inst.hp
			elseif var_157_12 == "nowhprate" then
				var_157_13 = var_157_9:getHPRatio()
			elseif var_157_12 == "losthp" then
				var_157_13 = math.max(0, var_157_9:getMaxHP() - var_157_9.inst.hp)
			elseif var_157_12 == "losthprate" then
				var_157_13 = 1 - var_157_9:getHPRatio()
			elseif var_157_10[var_157_12] then
				if var_157_12 == "max_hp" then
					var_157_13 = var_157_9:getMaxHP()
				else
					var_157_13 = var_157_10[var_157_12]
				end
			end
			
			if arg_157_4 and var_157_7.target == "target" and var_157_12 == "max_hp" and var_157_13 > 0 and arg_157_4.states:isExistEffect("CSP_IMMUNE_BF_TARGET_MAXHP") then
				var_157_13 = var_157_13 * (1 - arg_157_4.states:getMaxHPImmuneRate())
			end
			
			if arg_157_1 == "BF_DMG_UP_STATUS_MUL" then
				arg_157_5.dmg = arg_157_5.dmg + var_157_13 * var_157_11
			elseif arg_157_1 == "BF_BONUSATT_UP_STATUS_ADD" then
				if arg_157_3 and var_157_7.target == "self" and var_157_12 == "max_hp" and var_157_13 > 0 and arg_157_3.states:isExistEffect("CSP_SELF_MAX_HP_DMG_UP_DECREASE") then
					local var_157_14 = arg_157_3.states:getAllEffValue("CSP_SELF_MAX_HP_DMG_UP_DECREASE", function(arg_158_0)
						if arg_158_0:isPassiveBlocked() then
							return false
						end
						
						return true
					end)
					
					var_157_13 = var_157_13 * (1 - math.clamp(var_157_14, 0, 1))
				end
				
				arg_157_5.bonus_att = arg_157_5.bonus_att + var_157_13 * var_157_11
			end
		end
	elseif arg_157_1 == "BF_EXPLOSION_DEBUFF" then
		local var_157_15 = arg_157_4.states:onDebuffExplosion({
			pow = arg_157_2,
			candidates = {
				"HPDOWN_TARGET_MAXHP",
				"HPDOWN_CASTER_ATT",
				"HPDOWN_TARGET_MAXHP_DHP"
			}
		})
		
		table.add(arg_157_0, var_157_15)
	elseif arg_157_1 == "BF_DMG_UP_PARTY_POWER" then
		arg_157_5.team_pow_point_damage = to_n(arg_157_3.logic.team_data.team_point) * arg_157_2
	elseif arg_157_1 == "BF_DMG_UP_PARTY_ATT" then
		arg_157_5.team_att_point_damage = 0
		
		local var_157_16 = arg_157_3.logic:pickUnits(arg_157_3, FRIEND)
		
		for iter_157_4, iter_157_5 in pairs(var_157_16) do
			arg_157_5.team_att_point_damage = arg_157_5.team_att_point_damage + iter_157_5.status.att * arg_157_2
		end
		
		arg_157_5.team_att_point_damage = math.floor(arg_157_5.team_att_point_damage)
	elseif arg_157_1 == "BF_DMG_UP_TARGET_CS" then
		local var_157_17 = totable(arg_157_2)
		local var_157_18 = var_157_17.rate or 0
		
		var_157_17.rate = nil
		
		for iter_157_6, iter_157_7 in pairs(var_157_17 or {}) do
			if string.starts(iter_157_6, "csid") and arg_157_4.states:countById(iter_157_7) > 0 then
				arg_157_5.dmg = arg_157_5.dmg + var_157_18 * arg_157_4.states:countById(iter_157_7)
			end
		end
	elseif arg_157_1 == "BF_DMG_UP_ALLY_DEBUFF" then
		local var_157_19 = arg_157_3.logic:pickUnits(arg_157_3, FRIEND)
		local var_157_20 = 0
		
		for iter_157_8, iter_157_9 in pairs(var_157_19) do
			var_157_20 = var_157_20 + iter_157_9.states:getTypeCount("debuff")
		end
		
		arg_157_5.dmg = arg_157_5.dmg + arg_157_2 * var_157_20
	elseif arg_157_1 == "BF_DMG_UP_STATUS_MUL_DIFFERENCE" then
		local var_157_21 = SkillProc._stat_compare_rate_by_condition(arg_157_2, arg_157_3, arg_157_4, arg_157_5, arg_157_6)
		
		arg_157_5.dmg = arg_157_5.dmg + var_157_21
	elseif arg_157_1 == "BF_ATT_DEFPEN_DEBUFF_UP" then
		arg_157_5.pen_rate = arg_157_5.pen_rate + arg_157_4.states:getTypeCount("debuff") * arg_157_2
	elseif arg_157_1 == "BF_ATT_DEFPEN_STATUS_DIFF" then
		local var_157_22 = SkillProc._stat_compare_rate_by_condition(arg_157_2, arg_157_3, arg_157_4, arg_157_5, arg_157_6)
		
		arg_157_5.pen_rate = arg_157_5.pen_rate + var_157_22
	elseif arg_157_1 == "BF_DEFPEN_STATUS_DIFF" then
		local var_157_23 = SkillProc._stat_compare_rate_by_condition(arg_157_2, arg_157_3, arg_157_4, arg_157_5, arg_157_6)
		
		arg_157_6.def = arg_157_6.def * (1 - var_157_23)
	elseif arg_157_1 == "BF_GUARD_BLOCK" then
		arg_157_3.skill_inst_vars.ignore_guard = true
	elseif arg_157_1 == "BF_ATT_DEFPEN_ENEMY_MAXHP" then
		if arg_157_7 then
			local var_157_24 = {}
			local var_157_25 = arg_157_3.logic:getTargetCandidates(arg_157_7, arg_157_3, arg_157_4)
			
			if not arg_157_3.turn_vars.eff_random_target_dirty then
				for iter_157_10, iter_157_11 in pairs(var_157_25) do
					if table.empty(var_157_24) then
						table.insert(var_157_24, iter_157_11)
					else
						local var_157_26 = var_157_24[1]:getMaxHP()
						
						if var_157_26 <= iter_157_11:getMaxHP() then
							if var_157_26 < iter_157_11:getMaxHP() then
								var_157_24 = {}
							end
							
							table.insert(var_157_24, iter_157_11)
						end
					end
				end
				
				local var_157_27 = arg_157_3.logic.random:get(1, #var_157_24)
				
				arg_157_3.turn_vars.eff_random_target_dirty = var_157_24[var_157_27]
			end
			
			if arg_157_3.turn_vars.eff_random_target_dirty == arg_157_4 then
				arg_157_5.pen_rate = arg_157_5.pen_rate + arg_157_2
			end
		end
	elseif arg_157_1 == "BF_IGNORE_DAMAGE_REDUCE" then
		arg_157_3.skill_inst_vars.ignore_damage_reduce = true
	elseif arg_157_1 == "BF_IGNORE_ATTRIBUTE" then
		arg_157_3.skill_inst_vars.ignore_attribute = true
	else
		return false
	end
	
	if var_157_0.activated then
		SkillProc.aceivateImmuneDefPen(var_157_0, arg_157_5, arg_157_6)
		
		return false
	end
	
	return true
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_COLOR(arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4, arg_159_5, arg_159_6, arg_159_7, arg_159_8, arg_159_9)
	if arg_159_9 == nil then
		Log.e("State", "attacker must be assiged", arg_159_0.id, arg_159_1)
	end
	
	return arg_159_9:getColor() == arg_159_4
end

function SkillProc.state_conds.DAMAGED_MAXHP_OVER(arg_160_0, arg_160_1, arg_160_2, arg_160_3, arg_160_4, arg_160_5, arg_160_6, arg_160_7, arg_160_8, arg_160_9, arg_160_10)
	if arg_160_0.db.cs_timing ~= 7 and arg_160_0.db.cs_timing ~= 15 and arg_160_0.db.cs_timing ~= 13 and arg_160_0.db.cs_timing ~= 23 and arg_160_0.db.cs_timing ~= 26 then
		Log.e("State", "cs_timing must be 7, 13, 23, 26 or 15 when cs_con is 16", arg_160_0.id, arg_160_0.db.cs_timing)
	end
	
	for iter_160_0, iter_160_1 in pairs(arg_160_10 or {}) do
		if iter_160_1 and iter_160_1.skillDamageTag then
			local var_160_0 = iter_160_1:skillDamageTag(arg_160_9)
			
			if var_160_0 and arg_160_4 <= var_160_0.damage / iter_160_1:getMaxHP() then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_CURHP_OVER(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4, arg_161_5, arg_161_6, arg_161_7, arg_161_8, arg_161_9, arg_161_10)
	if arg_161_0.db.cs_timing ~= 7 and arg_161_0.db.cs_timing ~= 15 then
		Log.e("State", "cs_timing must be 7 or 15 when cs_con is 7", arg_161_0.id, arg_161_0.db.cs_timing)
	end
	
	if arg_161_0.owner:isInvincible() then
		return false
	end
	
	for iter_161_0, iter_161_1 in pairs(arg_161_10 or {}) do
		if iter_161_1 and iter_161_1.skillDamageTag then
			local var_161_0 = iter_161_1:skillDamageTag(arg_161_9)
			
			if var_161_0 and arg_161_4 <= var_161_0.damage / iter_161_1.inst.hp then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_CURHP_ALL_OVER(arg_162_0, arg_162_1, arg_162_2, arg_162_3, arg_162_4, arg_162_5, arg_162_6, arg_162_7, arg_162_8, arg_162_9, arg_162_10)
	if arg_162_0.db.cs_timing ~= 7 and arg_162_0.db.cs_timing ~= 15 then
		Log.e("State", "cs_timing must be 7 or 15 when cs_con is 7", arg_162_0.id, arg_162_0.db.cs_timing)
	end
	
	if arg_162_0.owner:isInvincible() then
		return false
	end
	
	for iter_162_0, iter_162_1 in pairs(arg_162_10 or {}) do
		if iter_162_1 and iter_162_1.skillDamageTag then
			local var_162_0 = iter_162_1:skillDamageTag(arg_162_9)
			
			if var_162_0 then
				local var_162_1 = iter_162_1.inst.hp + iter_162_1.states:getShield()
				
				if arg_162_4 >= var_162_0.damage / var_162_1 then
					return true
				end
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_MAXHP_LESS(arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4, arg_163_5, arg_163_6, arg_163_7, arg_163_8, arg_163_9, arg_163_10)
	if arg_163_0.db.cs_timing ~= 7 and arg_163_0.db.cs_timing ~= 15 then
		Log.e("State", "cs_timing must be 7 or 15 when cs_con is 23", arg_163_0.id, arg_163_0.db.cs_timing)
	end
	
	for iter_163_0, iter_163_1 in pairs(arg_163_10 or {}) do
		if iter_163_1 and iter_163_1.skillDamageTag then
			local var_163_0 = iter_163_1:skillDamageTag(arg_163_9)
			
			if var_163_0 and arg_163_4 >= var_163_0.damage / iter_163_1:getMaxHP() then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_CURHP_LESS(arg_164_0, arg_164_1, arg_164_2, arg_164_3, arg_164_4, arg_164_5, arg_164_6, arg_164_7, arg_164_8, arg_164_9, arg_164_10)
	if arg_164_0.db.cs_timing ~= 7 and arg_164_0.db.cs_timing ~= 15 then
		Log.e("State", "cs_timing must be 7 or 15 when cs_con is 24", arg_164_0.id, arg_164_0.db.cs_timing)
	end
	
	for iter_164_0, iter_164_1 in pairs(arg_164_10 or {}) do
		if iter_164_1 and iter_164_1.skillDamageTag then
			local var_164_0 = iter_164_1:skillDamageTag(arg_164_9)
			
			if var_164_0 and arg_164_4 >= var_164_0.damage / iter_164_1.inst.hp then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_EVASION(arg_165_0, arg_165_1, arg_165_2, arg_165_3, arg_165_4, arg_165_5, arg_165_6, arg_165_7, arg_165_8, arg_165_9, arg_165_10)
	if not table.isInclude({
		7,
		15,
		13,
		23,
		26,
		28
	}, arg_165_0.db.cs_timing) then
		Log.e("State", "cs_timing must be 7, 15, 23, 26, 28 or 13 when cs_con is 18", arg_165_0.id, arg_165_0.db.cs_timing)
	end
	
	if table.isInclude({
		13,
		23,
		26,
		28
	}, arg_165_0.db.cs_timing) then
		for iter_165_0, iter_165_1 in pairs(arg_165_10 or {}) do
			if iter_165_1 and iter_165_1.skillDamageTag then
				local var_165_0 = iter_165_1:skillDamageTag(arg_165_9)
				
				if var_165_0 and var_165_0.miss then
					return true
				end
			end
		end
	end
	
	return arg_165_6
end

function SkillProc.state_conds.ALLY_DAMAGED_CRITICAL(arg_166_0, arg_166_1, arg_166_2, arg_166_3, arg_166_4, arg_166_5, arg_166_6, arg_166_7, arg_166_8, arg_166_9)
	if arg_166_0.db.cs_timing ~= 7 and arg_166_0.db.cs_timing ~= 15 and arg_166_0.db.cs_timing ~= 13 and arg_166_0.db.cs_timing ~= 26 and arg_166_0.db.cs_timing ~= 28 and arg_166_0.db.cs_timing ~= 23 then
		Log.e("State", "cs_timing must be 7, 15, 26, 23, 28 or 13 when cs_con is 25", arg_166_0.id, arg_166_0.db.cs_timing)
	end
	
	local var_166_0 = arg_166_0.owner.logic:pickUnits(arg_166_0.owner, FRIEND)
	
	for iter_166_0, iter_166_1 in pairs(var_166_0) do
		if iter_166_1:skillDamageTag(arg_166_9) and iter_166_1:skillDamageTag(arg_166_9).critical then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.ALLY_DAMAGED_NOTCRITICAL(arg_167_0, arg_167_1, arg_167_2, arg_167_3, arg_167_4, arg_167_5, arg_167_6, arg_167_7, arg_167_8, arg_167_9)
	if arg_167_0.db.cs_timing ~= 7 and arg_167_0.db.cs_timing ~= 15 and arg_167_0.db.cs_timing ~= 13 and arg_167_0.db.cs_timing ~= 26 and arg_167_0.db.cs_timing ~= 28 and arg_167_0.db.cs_timing ~= 23 then
		Log.e("State", "cs_timing must be 7, 15, 26, 23, 28 or 13 when cs_con is 25", arg_167_0.id, arg_167_0.db.cs_timing)
	end
	
	local var_167_0 = arg_167_0.owner.logic:pickUnits(arg_167_0.owner, FRIEND)
	
	for iter_167_0, iter_167_1 in pairs(var_167_0) do
		if iter_167_1:skillDamageTag(arg_167_9) and not iter_167_1:skillDamageTag(arg_167_9).critical then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_CRITICAL(arg_168_0, arg_168_1, arg_168_2, arg_168_3, arg_168_4, arg_168_5, arg_168_6, arg_168_7, arg_168_8, arg_168_9)
	if arg_168_0.db.cs_timing ~= 7 and arg_168_0.db.cs_timing ~= 15 and arg_168_0.db.cs_timing ~= 13 and arg_168_0.db.cs_timing ~= 26 and arg_168_0.db.cs_timing ~= 28 and arg_168_0.db.cs_timing ~= 23 then
		Log.e("State", "cs_timing must be 7, 15, 26, 23, 28 or 13 when cs_con is 25", arg_168_0.id, arg_168_0.db.cs_timing)
	end
	
	return arg_168_5:skillDamageTag(arg_168_9) and arg_168_5:skillDamageTag(arg_168_9).critical
end

function SkillProc.state_conds.DAMAGED_NOTCRITICAL(arg_169_0, arg_169_1, arg_169_2, arg_169_3, arg_169_4, arg_169_5, arg_169_6, arg_169_7, arg_169_8, arg_169_9)
	if arg_169_0.db.cs_timing ~= 7 and arg_169_0.db.cs_timing ~= 15 and arg_169_0.db.cs_timing ~= 13 and arg_169_0.db.cs_timing ~= 26 and arg_169_0.db.cs_timing ~= 28 and arg_169_0.db.cs_timing ~= 23 then
		Log.e("State", "cs_timing must be 7, 15, 26, 23, 28 or 13 when cs_con is 25", arg_169_0.id, arg_169_0.db.cs_timing)
	end
	
	return arg_169_5:skillDamageTag(arg_169_9) and not arg_169_5:skillDamageTag(arg_169_9).critical
end

function SkillProc.state_conds.CS_STACK_COUNT(arg_170_0, arg_170_1, arg_170_2, arg_170_3, arg_170_4, arg_170_5, arg_170_6, arg_170_7, arg_170_8, arg_170_9)
	return arg_170_4 <= arg_170_0.stack_count
end

function SkillProc.state_conds.COUNT_LIMIT(arg_171_0, arg_171_1, arg_171_2, arg_171_3, arg_171_4, arg_171_5, arg_171_6, arg_171_7, arg_171_8, arg_171_9)
	return arg_171_5 and arg_171_5:getInvokeStackCount(arg_171_0.id) and tonumber(arg_171_5:getInvokeStackCount(arg_171_0.id)) < tonumber(arg_171_4 or 1)
end

function SkillProc.state_conds.COUNT_LIMIT_WAVE(arg_172_0, arg_172_1, arg_172_2, arg_172_3, arg_172_4, arg_172_5, arg_172_6, arg_172_7, arg_172_8, arg_172_9)
	return arg_172_5 and arg_172_5:getInvokeStackCount(arg_172_0.id) and tonumber(arg_172_5:getInvokeStackCount(arg_172_0.id)) < tonumber(arg_172_4 or 1)
end

function SkillProc.state_conds.COUNT_LIMIT_TARGET_OTHER(arg_173_0, arg_173_1, arg_173_2, arg_173_3, arg_173_4, arg_173_5, arg_173_6, arg_173_7, arg_173_8, arg_173_9)
	return arg_173_5 and arg_173_5.logic:getInvokeStackCount(arg_173_0.id) and tonumber(arg_173_5.logic:getInvokeStackCount(arg_173_0.id)) < tonumber(arg_173_4 or 1)
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET(arg_174_0, arg_174_1, arg_174_2, arg_174_3, arg_174_4, arg_174_5, arg_174_6, arg_174_7, arg_174_8, arg_174_9)
	if arg_174_9 == nil then
		Log.e("State", "attacker must be assiged", arg_174_0.id, arg_174_1)
	end
	
	return SkillFactory.create(arg_174_1, arg_174_9):isTargetIn(arg_174_4)
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_NOT(arg_175_0, arg_175_1, arg_175_2, arg_175_3, arg_175_4, arg_175_5, arg_175_6, arg_175_7, arg_175_8, arg_175_9)
	if arg_175_9 == nil then
		Log.e("State", "attacker must be assiged", arg_175_0.id, arg_175_1)
	end
	
	return not SkillFactory.create(arg_175_1, arg_175_9):isTargetIn(arg_175_4)
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_REVERSE(arg_176_0, arg_176_1, arg_176_2, arg_176_3, arg_176_4, arg_176_5, arg_176_6, arg_176_7, arg_176_8, arg_176_9, arg_176_10)
	local var_176_0 = {
		"light",
		"dark"
	}
	
	if table.isInclude(var_176_0, arg_176_9:getColor()) then
		return false
	end
	
	if table.isInclude(var_176_0, arg_176_5:getColor()) then
		return false
	end
	
	if arg_176_9 == arg_176_5 then
		return false
	end
	
	if arg_176_9:getColor() == arg_176_5:getColor() then
		return false
	end
	
	return not arg_176_9:isStrongAgainst(arg_176_5, arg_176_1)
end

function SkillProc.state_conds.ATTACK_TARGET_REVERSE(arg_177_0, arg_177_1, arg_177_2, arg_177_3, arg_177_4, arg_177_5, arg_177_6, arg_177_7, arg_177_8, arg_177_9, arg_177_10)
	if not table.isInclude({
		4,
		5,
		17,
		21,
		22
	}, arg_177_0.db.cs_timing) then
		Log.e("State", "cs_timing must be 4, 5, 17, 21, 22", arg_177_0.id, arg_177_0.db.cs_timing)
	end
	
	if arg_177_9 == arg_177_5 then
		return false
	end
	
	local var_177_0 = {
		"light",
		"dark"
	}
	
	if arg_177_4 == "covenant" then
		if table.isInclude(var_177_0, arg_177_9:getColor()) then
			return false
		end
		
		if table.isInclude(var_177_0, arg_177_5:getColor()) then
			return false
		end
	elseif arg_177_4 == "moonlight" then
		if not table.isInclude(var_177_0, arg_177_9:getColor()) then
			return false
		end
		
		if not table.isInclude(var_177_0, arg_177_5:getColor()) then
			return false
		end
	end
	
	return arg_177_9:isStrongAgainst(arg_177_5, arg_177_1)
end

function SkillProc.state_conds.COOLTIME_ON(arg_178_0, arg_178_1, arg_178_2, arg_178_3, arg_178_4, arg_178_5, arg_178_6, arg_178_7, arg_178_8, arg_178_9)
	local var_178_0 = arg_178_4
	
	return to_n(arg_178_0.owner:getSkillCool(arg_178_0.owner:getSkillBundle():slot(var_178_0):getSkillId())) == 0
end

function SkillProc.state_conds.COOLTIME_OFF(arg_179_0, arg_179_1, arg_179_2, arg_179_3, arg_179_4, arg_179_5, arg_179_6, arg_179_7, arg_179_8, arg_179_9)
	local var_179_0 = arg_179_4
	
	return to_n(arg_179_0.owner:getSkillCool(arg_179_0.owner:getSkillBundle():slot(var_179_0):getSkillId())) ~= 0
end

function SkillProc.state_conds.ALLY_SOMEONE_DEBUFF(arg_180_0, arg_180_1, arg_180_2, arg_180_3, arg_180_4, arg_180_5, arg_180_6, arg_180_7, arg_180_8, arg_180_9, arg_180_10)
	local var_180_0 = arg_180_0.owner.logic:pickUnits(arg_180_0.owner, FRIEND)
	
	for iter_180_0, iter_180_1 in pairs(var_180_0) do
		if iter_180_1.states:getTypeCount("debuff") > 0 then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.ENEMY_SOMEONE_CSGROUP(arg_181_0, arg_181_1, arg_181_2, arg_181_3, arg_181_4, arg_181_5, arg_181_6, arg_181_7, arg_181_8, arg_181_9, arg_181_10)
	local var_181_0 = totable(arg_181_4)
	local var_181_1 = arg_181_0.owner.logic:pickUnits(arg_181_0.owner, ENEMY)
	
	for iter_181_0, iter_181_1 in pairs(var_181_1) do
		local var_181_2 = iter_181_1.states:getGroupCount(var_181_0.csgroup)
		local var_181_3 = false
		
		if var_181_0.opt == "equal" then
			var_181_3 = var_181_2 == tonumber(var_181_0.cnt)
		elseif var_181_0.opt == "greater" then
			var_181_3 = var_181_2 >= tonumber(var_181_0.cnt)
		elseif var_181_0.opt == "less" then
			var_181_3 = var_181_2 <= tonumber(var_181_0.cnt)
		end
		
		if var_181_3 then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.SKILLUSE_NUMBER(arg_182_0, arg_182_1, arg_182_2, arg_182_3, arg_182_4, arg_182_5, arg_182_6, arg_182_7, arg_182_8, arg_182_9)
	local var_182_0 = arg_182_4
	
	return to_n(DB("skill", arg_182_1, "sklvup_refer")) == var_182_0 or arg_182_9:getSkillIndex(arg_182_1) == var_182_0
end

function SkillProc.state_conds.TARGET_NOWHPRATE_LESS_ATTCK_TARGET(arg_183_0, arg_183_1, arg_183_2, arg_183_3, arg_183_4, arg_183_5, arg_183_6, arg_183_7, arg_183_8, arg_183_9, arg_183_10)
	if not table.isInclude({
		4,
		5,
		17,
		21,
		22
	}, arg_183_0.db.cs_timing) then
		Log.e("State", "cs_timing must be 4, 5, 17, 21, 22", arg_183_0.id, arg_183_0.db.cs_timing)
	end
	
	local var_183_0 = arg_183_4
	local var_183_1 = arg_183_9.logic:pickUnits(arg_183_9, ENEMY)
	
	for iter_183_0, iter_183_1 in pairs(var_183_1) do
		if iter_183_1 and iter_183_1.skillDamageTag then
			local var_183_2 = iter_183_1:skillDamageTag(arg_183_9)
			
			if var_183_2 and var_183_2.damage and var_183_0 >= iter_183_1:getHPRatio() then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.TARGET_NOT_SELF(arg_184_0, arg_184_1, arg_184_2, arg_184_3, arg_184_4, arg_184_5, arg_184_6, arg_184_7, arg_184_8, arg_184_9, arg_184_10)
	return arg_184_0.giver ~= arg_184_5
end

function SkillProc.state_conds.TARGET_KEYSLOT(arg_185_0, arg_185_1, arg_185_2, arg_185_3, arg_185_4, arg_185_5, arg_185_6, arg_185_7, arg_185_8, arg_185_9, arg_185_10)
	if arg_185_5 then
		return arg_185_5.inst.pos == arg_185_5.logic:getKeySlotPos()
	else
		return false
	end
end

function SkillProc.state_conds.DAMAGED_NORMALSKILL(arg_186_0, arg_186_1, arg_186_2, arg_186_3, arg_186_4, arg_186_5, arg_186_6, arg_186_7, arg_186_8, arg_186_9, arg_186_10)
	if arg_186_0.db.cs_timing ~= 7 and arg_186_0.db.cs_timing ~= 15 and arg_186_0.db.cs_timing ~= 13 and arg_186_0.db.cs_timing ~= 26 and arg_186_0.db.cs_timing ~= 23 and arg_186_0.db.cs_timing ~= 28 then
		Log.e("State", "cs_timing must be 7, 15, 23, 28, 26 or 13", arg_186_0.id, arg_186_0.db.cs_timing)
	end
	
	for iter_186_0, iter_186_1 in pairs(arg_186_10 or {}) do
		if iter_186_1 and iter_186_1.skillDamageTag then
			local var_186_0 = iter_186_1:skillDamageTag(arg_186_9)
			
			if var_186_0 and var_186_0.is_normal then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_NORMAL_OR_COOP_SKILL(arg_187_0, arg_187_1, arg_187_2, arg_187_3, arg_187_4, arg_187_5, arg_187_6, arg_187_7, arg_187_8, arg_187_9, arg_187_10)
	if arg_187_0.db.cs_timing ~= 7 and arg_187_0.db.cs_timing ~= 15 and arg_187_0.db.cs_timing ~= 13 and arg_187_0.db.cs_timing ~= 26 and arg_187_0.db.cs_timing ~= 23 and arg_187_0.db.cs_timing ~= 28 then
		Log.e("State", "cs_timing must be 7, 15, 23, 28, 26 or 13", arg_187_0.id, arg_187_0.db.cs_timing)
	end
	
	for iter_187_0, iter_187_1 in pairs(arg_187_10 or {}) do
		if iter_187_1 and iter_187_1.skillDamageTag then
			local var_187_0 = iter_187_1:skillDamageTag(arg_187_9)
			
			if var_187_0 and (var_187_0.is_normal or var_187_0.source == "coop") then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_HIDDENSKILL(arg_188_0, arg_188_1, arg_188_2, arg_188_3, arg_188_4, arg_188_5, arg_188_6, arg_188_7, arg_188_8, arg_188_9, arg_188_10)
	if arg_188_0.db.cs_timing ~= 7 and arg_188_0.db.cs_timing ~= 15 and arg_188_0.db.cs_timing ~= 13 and arg_188_0.db.cs_timing ~= 26 and arg_188_0.db.cs_timing ~= 23 and arg_188_0.db.cs_timing ~= 28 then
		Log.e("State", "cs_timing must be 7, 15, 23, 28, 26 or 13", arg_188_0.id, arg_188_0.db.cs_timing)
	end
	
	for iter_188_0, iter_188_1 in pairs(arg_188_10 or {}) do
		if iter_188_1 and iter_188_1.skillDamageTag then
			local var_188_0 = iter_188_1:skillDamageTag(arg_188_9)
			
			if var_188_0 and not var_188_0.is_normal then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_COOPSKILL(arg_189_0, arg_189_1, arg_189_2, arg_189_3, arg_189_4, arg_189_5, arg_189_6, arg_189_7, arg_189_8, arg_189_9, arg_189_10)
	if arg_189_0.db.cs_timing ~= 7 and arg_189_0.db.cs_timing ~= 15 and arg_189_0.db.cs_timing ~= 13 and arg_189_0.db.cs_timing ~= 26 and arg_189_0.db.cs_timing ~= 23 and arg_189_0.db.cs_timing ~= 28 then
		Log.e("State", "cs_timing must be 7, 15, 23, 28, 26 or 13", arg_189_0.id, arg_189_0.db.cs_timing)
	end
	
	for iter_189_0, iter_189_1 in pairs(arg_189_10 or {}) do
		if iter_189_1 and iter_189_1.skillDamageTag then
			local var_189_0 = iter_189_1:skillDamageTag(arg_189_9)
			
			if var_189_0 and var_189_0.source == "coop" then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_ADDSKILL(arg_190_0, arg_190_1, arg_190_2, arg_190_3, arg_190_4, arg_190_5, arg_190_6, arg_190_7, arg_190_8, arg_190_9, arg_190_10)
	if arg_190_0.db.cs_timing ~= 7 and arg_190_0.db.cs_timing ~= 15 and arg_190_0.db.cs_timing ~= 13 and arg_190_0.db.cs_timing ~= 26 and arg_190_0.db.cs_timing ~= 23 and arg_190_0.db.cs_timing ~= 28 then
		Log.e("State", "cs_timing must be 7, 15, 23, 28, 26 or 13", arg_190_0.id, arg_190_0.db.cs_timing)
	end
	
	for iter_190_0, iter_190_1 in pairs(arg_190_10 or {}) do
		if iter_190_1 and iter_190_1.skillDamageTag then
			local var_190_0 = iter_190_1:skillDamageTag(arg_190_9)
			
			if var_190_0 and var_190_0.source == "hidden" then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_COUNTERSKILL(arg_191_0, arg_191_1, arg_191_2, arg_191_3, arg_191_4, arg_191_5, arg_191_6, arg_191_7, arg_191_8, arg_191_9, arg_191_10)
	if arg_191_0.db.cs_timing ~= 7 and arg_191_0.db.cs_timing ~= 15 and arg_191_0.db.cs_timing ~= 13 and arg_191_0.db.cs_timing ~= 26 and arg_191_0.db.cs_timing ~= 23 and arg_191_0.db.cs_timing ~= 28 then
		Log.e("State", "cs_timing must be 7, 15, 23, 28, 26 or 13", arg_191_0.id, arg_191_0.db.cs_timing)
	end
	
	for iter_191_0, iter_191_1 in pairs(arg_191_10 or {}) do
		if iter_191_1 and iter_191_1.skillDamageTag then
			local var_191_0 = iter_191_1:skillDamageTag(arg_191_9)
			
			if var_191_0 and var_191_0.source == "counter" then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_NOT_IGNORE_COUNTERSKILL(arg_192_0, arg_192_1, arg_192_2, arg_192_3, arg_192_4, arg_192_5, arg_192_6, arg_192_7, arg_192_8, arg_192_9, arg_192_10)
	local var_192_0 = arg_192_9:getSkillDB(arg_192_1, {
		"ignore_counter"
	})
	local var_192_1 = true
	
	if var_192_0 ~= "y" then
		return var_192_1
	end
	
	for iter_192_0, iter_192_1 in pairs(arg_192_10 or {}) do
		if iter_192_1 and iter_192_1.skillDamageTag then
			local var_192_2 = iter_192_1:skillDamageTag(arg_192_9)
			
			if var_192_2 and var_192_2.skill_id == arg_192_1 then
				var_192_1 = false
				
				break
			end
		end
	end
	
	return var_192_1
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_BOSS(arg_193_0, arg_193_1, arg_193_2, arg_193_3, arg_193_4, arg_193_5, arg_193_6, arg_193_7, arg_193_8, arg_193_9, arg_193_10)
	if arg_193_9 == nil then
		Log.e("State", "attacker must be assiged", arg_193_0.id, arg_193_1)
	end
	
	if DB("skill", arg_193_1, "monstertier_ignore") == "y" then
		return false
	end
	
	return arg_193_9.db.type == "monster" and table.isInclude({
		"elite",
		"subboss",
		"boss"
	}, arg_193_9.db.tier)
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_NORMAL(arg_194_0, arg_194_1, arg_194_2, arg_194_3, arg_194_4, arg_194_5, arg_194_6, arg_194_7, arg_194_8, arg_194_9, arg_194_10)
	if arg_194_9 == nil then
		Log.e("State", "attacker must be assiged", arg_194_0.id, arg_194_1)
	end
	
	return arg_194_9.db.type == "monster" and arg_194_9.db.tier == "normal"
end

function SkillProc.state_conds.ENEMY_ALIVE(arg_195_0, arg_195_1, arg_195_2, arg_195_3, arg_195_4, arg_195_5, arg_195_6, arg_195_7, arg_195_8, arg_195_9, arg_195_10)
	local var_195_0 = arg_195_5.logic:pickEnemies(arg_195_5, ENEMY)
	
	for iter_195_0, iter_195_1 in pairs(var_195_0) do
		if not iter_195_1:isEmptyHP() or iter_195_1:isResurrectionReserved() then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.ENEMY_BUFF_COUNT(arg_196_0, arg_196_1, arg_196_2, arg_196_3, arg_196_4, arg_196_5, arg_196_6, arg_196_7, arg_196_8, arg_196_9, arg_196_10)
	local var_196_0 = 0
	local var_196_1 = arg_196_5.logic:pickUnits(arg_196_5, ENEMY)
	
	for iter_196_0, iter_196_1 in pairs(var_196_1) do
		local var_196_2 = iter_196_1.states:getTypeCount("buff")
		
		var_196_0 = var_196_0 + to_n(var_196_2)
	end
	
	local var_196_3 = totable(arg_196_4 or "")
	local var_196_4 = to_n(var_196_3.cnt)
	
	if var_196_3.opt == "equal" then
		return var_196_0 == var_196_4
	elseif var_196_3.opt == "greater" then
		return var_196_4 <= var_196_0
	elseif var_196_3.opt == "less" then
		return var_196_0 <= var_196_4
	end
	
	return false
end

function SkillProc.state_conds.ATTACK_TARGET_CLASS(arg_197_0, arg_197_1, arg_197_2, arg_197_3, arg_197_4, arg_197_5, arg_197_6, arg_197_7, arg_197_8, arg_197_9, arg_197_10)
	if arg_197_5 == nil then
		Log.e("State", "eff_target must be assiged", arg_197_0.id, arg_197_1)
	end
	
	local var_197_0 = ""
	
	if arg_197_5 == arg_197_9 then
		var_197_0 = arg_197_5.db.role
	else
		var_197_0 = arg_197_9.db.role
	end
	
	local var_197_1 = string.split(arg_197_4 or "", ",")
	
	return table.isInclude(var_197_1, var_197_0)
end

function SkillProc.state_conds.ATTACK_SUMMON(arg_198_0, arg_198_1, arg_198_2, arg_198_3, arg_198_4, arg_198_5, arg_198_6, arg_198_7, arg_198_8, arg_198_9, arg_198_10)
	if arg_198_9 and arg_198_9:isSummon() then
		return true
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_SUMMON(arg_199_0, arg_199_1, arg_199_2, arg_199_3, arg_199_4, arg_199_5, arg_199_6, arg_199_7, arg_199_8, arg_199_9, arg_199_10)
	if arg_199_9 and arg_199_5 and arg_199_5.inst.ally ~= arg_199_9.inst.ally and arg_199_9:isSummon() then
		return true
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_CLASS(arg_200_0, arg_200_1, arg_200_2, arg_200_3, arg_200_4, arg_200_5, arg_200_6, arg_200_7, arg_200_8, arg_200_9, arg_200_10)
	if arg_200_5 == nil then
		Log.e("State", "eff_target must be assiged", arg_200_0.id, arg_200_1)
	end
	
	local var_200_0 = arg_200_9.db.role
	local var_200_1 = string.split(arg_200_4 or "", ",")
	
	return table.isInclude(var_200_1, var_200_0)
end

function SkillProc.state_conds.DAMAGED_LINE_FRONT(arg_201_0, arg_201_1, arg_201_2, arg_201_3, arg_201_4, arg_201_5, arg_201_6, arg_201_7, arg_201_8, arg_201_9, arg_201_10)
	for iter_201_0, iter_201_1 in pairs(arg_201_10 or {}) do
		if iter_201_1 and iter_201_1.inst and to_n(iter_201_1.inst.pos) == 1 then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.DAMAGED_LINE_BACK(arg_202_0, arg_202_1, arg_202_2, arg_202_3, arg_202_4, arg_202_5, arg_202_6, arg_202_7, arg_202_8, arg_202_9, arg_202_10)
	for iter_202_0, iter_202_1 in pairs(arg_202_10 or {}) do
		if iter_202_1 and iter_202_1.inst and to_n(iter_202_1.inst.pos) == 4 then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.EFFECT_TARGET_CLASS(arg_203_0, arg_203_1, arg_203_2, arg_203_3, arg_203_4, arg_203_5, arg_203_6, arg_203_7, arg_203_8, arg_203_9, arg_203_10, arg_203_11)
	local var_203_0 = SkillProc.getConditionTarget(arg_203_0.owner, arg_203_3, arg_203_5, {
		arg_203_5
	}, arg_203_10, arg_203_11, arg_203_9, arg_203_1) or arg_203_5
	local var_203_1
	
	if var_203_0 == nil then
		Log.e("State", "eff_target must be assiged", arg_203_0.id, arg_203_1)
	end
	
	if var_203_1 then
		var_203_0 = arg_203_5
	end
	
	local var_203_2 = var_203_0.db.role
	local var_203_3 = string.split(arg_203_4 or "", ",")
	
	return table.isInclude(var_203_3, var_203_2)
end

function SkillProc.state_conds.TURN_FINISHED(arg_204_0, arg_204_1, arg_204_2, arg_204_3, arg_204_4, arg_204_5, arg_204_6, arg_204_7, arg_204_8, arg_204_9, arg_204_10)
	return arg_204_0:getRestTurn() <= 1
end

function SkillProc.state_conds.ENEMY_BUFF_SCALE_PROB(arg_205_0, arg_205_1, arg_205_2, arg_205_3, arg_205_4, arg_205_5, arg_205_6, arg_205_7, arg_205_8, arg_205_9, arg_205_10)
	local var_205_0 = 0
	local var_205_1 = arg_205_5.logic:pickUnits(arg_205_5, ENEMY)
	
	for iter_205_0, iter_205_1 in pairs(var_205_1) do
		local var_205_2 = iter_205_1.states:getTypeCount("buff")
		
		var_205_0 = var_205_0 + to_n(var_205_2)
	end
	
	return var_205_0 * arg_205_4 > arg_205_5.logic.random:get()
end

function SkillProc.state_conds.ALLY_CHECK_SOUL(arg_206_0, arg_206_1, arg_206_2, arg_206_3, arg_206_4, arg_206_5, arg_206_6, arg_206_7, arg_206_8, arg_206_9, arg_206_10)
	local var_206_0 = arg_206_0.owner
	local var_206_1 = var_206_0.inst.ally
	
	if var_206_1 == ENEMY and not var_206_0.logic:isPVP() then
		return false
	end
	
	local var_206_2 = var_206_0.logic:getTeamRes(var_206_1, "soul_piece") or 0
	local var_206_3 = totable(arg_206_4 or "")
	local var_206_4 = to_n(var_206_3.cnt)
	
	if var_206_3.opt == "equal" then
		return var_206_2 == var_206_4
	elseif var_206_3.opt == "greater" then
		return var_206_4 <= var_206_2
	elseif var_206_3.opt == "less" then
		return var_206_2 <= var_206_4
	end
end

function SkillProc.state_conds.ENEMY_CHECK_SOUL(arg_207_0, arg_207_1, arg_207_2, arg_207_3, arg_207_4, arg_207_5, arg_207_6, arg_207_7, arg_207_8, arg_207_9, arg_207_10)
	local var_207_0 = arg_207_0.owner
	local var_207_1
	
	if var_207_0.inst.ally == FRIEND then
		if not var_207_0.logic:isPVP() then
			return false
		end
		
		var_207_1 = ENEMY
	else
		var_207_1 = FRIEND
	end
	
	local var_207_2 = var_207_0.logic:getTeamRes(var_207_1, "soul_piece") or 0
	local var_207_3 = totable(arg_207_4 or "")
	local var_207_4 = to_n(var_207_3.cnt)
	
	if var_207_3.opt == "equal" then
		return var_207_2 == var_207_4
	elseif var_207_3.opt == "greater" then
		return var_207_4 <= var_207_2
	elseif var_207_3.opt == "less" then
		return var_207_2 <= var_207_4
	end
end

function SkillProc.state_conds.SURVIVED_ALLY_CHECK(arg_208_0, arg_208_1, arg_208_2, arg_208_3, arg_208_4, arg_208_5, arg_208_6, arg_208_7, arg_208_8, arg_208_9, arg_208_10)
	local var_208_0 = arg_208_5 or arg_208_0.owner
	local var_208_1 = 0
	local var_208_2 = var_208_0.logic:pickUnits(var_208_0, FRIEND, var_208_0)
	
	for iter_208_0, iter_208_1 in pairs(var_208_2) do
		if iter_208_1 and not iter_208_1:isDead() then
			var_208_1 = var_208_1 + 1
		end
	end
	
	local var_208_3 = totable(arg_208_4 or "")
	local var_208_4 = to_n(var_208_3.cnt)
	
	if var_208_3.opt == "equal" then
		return var_208_1 == var_208_4
	elseif var_208_3.opt == "greater" then
		return var_208_4 <= var_208_1
	elseif var_208_3.opt == "less" then
		return var_208_1 <= var_208_4
	end
	
	return false
end

function SkillProc.state_conds.SURVIVED_ENEMY_CHECK(arg_209_0, arg_209_1, arg_209_2, arg_209_3, arg_209_4, arg_209_5, arg_209_6, arg_209_7, arg_209_8, arg_209_9, arg_209_10)
	local var_209_0 = arg_209_0.owner
	local var_209_1 = 0
	local var_209_2 = var_209_0.logic:pickUnits(var_209_0, ENEMY, var_209_0)
	
	for iter_209_0, iter_209_1 in pairs(var_209_2) do
		if iter_209_1 and not iter_209_1:isDead() then
			var_209_1 = var_209_1 + 1
		end
	end
	
	local var_209_3 = totable(arg_209_4 or "")
	local var_209_4 = to_n(var_209_3.cnt)
	
	if var_209_3.opt == "equal" then
		return var_209_1 == var_209_4
	elseif var_209_3.opt == "greater" then
		return var_209_4 <= var_209_1
	elseif var_209_3.opt == "less" then
		return var_209_1 <= var_209_4
	end
	
	return false
end

function SkillProc.state_conds.SURVIVED_CHAR_ID_CHECK(arg_210_0, arg_210_1, arg_210_2, arg_210_3, arg_210_4, arg_210_5, arg_210_6, arg_210_7, arg_210_8, arg_210_9, arg_210_10)
	local var_210_0 = arg_210_0.owner
	local var_210_1 = totable(arg_210_4 or "")
	local var_210_2 = var_210_1.target
	local var_210_3 = var_210_1.id
	
	if type(var_210_1.id) ~= "table" then
		var_210_3 = {
			var_210_1.id
		}
	end
	
	local var_210_4 = var_210_1.andor
	local var_210_5
	
	if var_210_2 == "ally" then
		var_210_5 = var_210_0.logic:pickUnits(var_210_0, FRIEND)
	elseif var_210_2 == "enemy" then
		var_210_5 = var_210_0.logic:pickUnits(var_210_0, ENEMY)
	elseif var_210_2 == "both" then
		var_210_5 = var_210_0.logic:pickUnits(var_210_0, FRIEND)
		
		table.merge(var_210_5, var_210_0.logic:pickUnits(var_210_0, ENEMY))
	else
		return false
	end
	
	if var_210_5 then
		local var_210_6 = false
		
		if table.count(var_210_3) > 0 then
			for iter_210_0, iter_210_1 in pairs(var_210_5) do
				if table.isInclude(var_210_3, iter_210_1.db.code) and not iter_210_1:isDead() then
					if var_210_4 == "or" then
						return true
					else
						table.deleteByValue(var_210_3, iter_210_1.db.code)
					end
				end
			end
		end
		
		if table.count(var_210_3) == 0 then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.CHECK_USE_SOULBURN_SKILL(arg_211_0, arg_211_1, arg_211_2, arg_211_3, arg_211_4, arg_211_5, arg_211_6, arg_211_7, arg_211_8, arg_211_9, arg_211_10, arg_211_11)
	for iter_211_0, iter_211_1 in pairs(arg_211_10) do
		if iter_211_1 == arg_211_9 then
			local var_211_0 = iter_211_1:getSkillDB(arg_211_1, "soul_req")
			
			if to_n(var_211_0) > 0 then
				return true
			end
		end
	end
	
	return false
end

function SkillProc.state_conds.CHECK_ADD_TURN(arg_212_0, arg_212_1, arg_212_2, arg_212_3, arg_212_4, arg_212_5, arg_212_6, arg_212_7, arg_212_8, arg_212_9, arg_212_10, arg_212_11)
	local var_212_0 = arg_212_0.owner
	local var_212_1 = var_212_0.logic:getTurnOwner()
	
	if var_212_0.inst.ally ~= var_212_1.inst.ally then
		return var_212_1.logic:isTurnAddMore()
	end
	
	return false
end

function SkillProc.state_conds.ATTACK_COOLTIME_OVER(arg_213_0, arg_213_1, arg_213_2, arg_213_3, arg_213_4, arg_213_5, arg_213_6, arg_213_7, arg_213_8, arg_213_9, arg_213_10)
	return arg_213_5:getSkillDB(arg_213_1, "turn_cool") >= to_n(arg_213_4)
end

function SkillProc.state_conds.ATTACK_COOLTIME_LESS(arg_214_0, arg_214_1, arg_214_2, arg_214_3, arg_214_4, arg_214_5, arg_214_6, arg_214_7, arg_214_8, arg_214_9, arg_214_10)
	return arg_214_5:getSkillDB(arg_214_1, "turn_cool") <= to_n(arg_214_4)
end

function SkillProc.state_conds.ATTACK_TARGET_GROUP(arg_215_0, arg_215_1, arg_215_2, arg_215_3, arg_215_4, arg_215_5, arg_215_6, arg_215_7, arg_215_8, arg_215_9, arg_215_10)
	local var_215_0 = DB("skill", arg_215_1, "target")
	local var_215_1 = {}
	
	for iter_215_0 = 1, 30 do
		table.insert(var_215_1, "target" .. iter_215_0)
	end
	
	local var_215_2 = SkillProc.getTargetGroupData(arg_215_4)
	
	return SkillProc.isInTargetGroup(var_215_2, var_215_0)
end

function SkillProc.state_conds.DAMAGED_ATTACK_TARGET_GROUP(arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4, arg_216_5, arg_216_6, arg_216_7, arg_216_8, arg_216_9, arg_216_10)
	local var_216_0 = DB("skill", arg_216_1, "target")
	local var_216_1 = {}
	
	for iter_216_0 = 1, 30 do
		table.insert(var_216_1, "target" .. iter_216_0)
	end
	
	local var_216_2 = SkillProc.getTargetGroupData(arg_216_4)
	local var_216_3 = arg_216_0.owner
	local var_216_4 = var_216_3.logic:pickUnits(var_216_3, FRIEND)
	
	for iter_216_1, iter_216_2 in pairs(var_216_4) do
		local var_216_5 = iter_216_2:skillDamageTag(arg_216_9)
		
		if var_216_5 and var_216_5.skill_id == arg_216_1 and SkillProc.isInTargetGroup(var_216_2, var_216_0) then
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.DEAD_NOT_SELF(arg_217_0, arg_217_1, arg_217_2, arg_217_3, arg_217_4, arg_217_5, arg_217_6, arg_217_7, arg_217_8, arg_217_9, arg_217_10)
	local var_217_0 = arg_217_0.owner:isEmptyHP()
	local var_217_1 = arg_217_0.owner:isResurrectionReserved()
	
	return not var_217_0 and not var_217_1
end

function SkillProc.state_conds.REAL_DEAD_NOT_SELF(arg_218_0, arg_218_1, arg_218_2, arg_218_3, arg_218_4, arg_218_5, arg_218_6, arg_218_7, arg_218_8, arg_218_9, arg_218_10)
	local var_218_0 = arg_218_0.owner:isDead()
	local var_218_1 = arg_218_0.owner:isResurrectionReserved()
	
	return not var_218_0 and not var_218_1
end

function SkillProc.state_conds.STORY_CHOICE_CHECK(arg_219_0, arg_219_1, arg_219_2, arg_219_3, arg_219_4, arg_219_5, arg_219_6, arg_219_7, arg_219_8, arg_219_9, arg_219_10)
	for iter_219_0, iter_219_1 in pairs(arg_219_0.owner.logic:getPlayedStoryList() or {}) do
		if iter_219_0 == arg_219_4 and not iter_219_1.activate then
			iter_219_1.activate = true
			
			return true
		end
	end
	
	return false
end

function SkillProc.state_conds.ATTACK_CRITICAL_OTHER(arg_220_0, arg_220_1, arg_220_2, arg_220_3, arg_220_4, arg_220_5, arg_220_6, arg_220_7, arg_220_8, arg_220_9, arg_220_10, arg_220_11)
	if not table.isInclude({
		17,
		25,
		33,
		22,
		35,
		37
	}, arg_220_0.db.cs_timing) then
		Log.e("State", "cs_timing must be 17, 25, 33, 22, 35, 37", arg_220_0.id, arg_220_0.db.cs_timing)
	end
	
	local var_220_0 = false
	
	for iter_220_0, iter_220_1 in pairs(arg_220_10) do
		local var_220_1 = iter_220_1.logic:pickEnemies(iter_220_1)
		
		for iter_220_2, iter_220_3 in pairs(var_220_1) do
			local var_220_2 = iter_220_3:skillDamageTag(iter_220_1)
			
			if var_220_2 and var_220_2.critical then
				var_220_0 = true
				
				break
			end
		end
	end
	
	return var_220_0
end

function SkillProc.getTargetGroupData(arg_221_0)
	local var_221_0 = {}
	
	for iter_221_0 = 1, 30 do
		table.insert(var_221_0, "target" .. iter_221_0)
	end
	
	return DBT("skill_attack_type_group", tostring(arg_221_0), var_221_0) or {}
end

function SkillProc.isInTargetGroup(arg_222_0, arg_222_1)
	for iter_222_0, iter_222_1 in pairs(arg_222_0) do
		if iter_222_1 == arg_222_1 then
			return true
		end
	end
	
	return false
end

function SkillProc.checkStateCondition(arg_223_0, arg_223_1, arg_223_2, arg_223_3, arg_223_4, arg_223_5, arg_223_6, arg_223_7, arg_223_8, arg_223_9, arg_223_10, arg_223_11)
	local var_223_0 = "!"
	
	if string.starts(tostring(arg_223_2), var_223_0) then
		local var_223_1 = string.sub(tostring(arg_223_2), string.len(var_223_0) + 1, -1)
		
		return not SkillProc.checkStateCondition(arg_223_0, arg_223_1, var_223_1, arg_223_3, arg_223_4, arg_223_5, arg_223_6, arg_223_7, arg_223_8, arg_223_9, arg_223_10, arg_223_11)
	end
	
	if SkillProc.state_conds[arg_223_2] then
		return SkillProc.state_conds[arg_223_2](arg_223_0, arg_223_1, arg_223_2, arg_223_3, arg_223_4, arg_223_5, arg_223_6, arg_223_7, arg_223_8, arg_223_9, arg_223_10, arg_223_11)
	end
	
	return SkillProc.checkCommonCon(arg_223_0.owner, arg_223_1, arg_223_2, arg_223_3, arg_223_4, arg_223_5, {
		arg_223_5
	}, arg_223_6, arg_223_7, arg_223_8, arg_223_9, arg_223_10, arg_223_11)
end

function SkillProc.checkResistDB(arg_224_0)
	local var_224_0, var_224_1 = DB("skill_resist", arg_224_0, {
		"id",
		"resist_ignore"
	})
	
	if not var_224_0 and PLATFORM == "win32" and not IS_TOOL_MODE then
		Log.e(string.format("스킬저항에 등록되어있지 않은 스킬 효과. : %s", arg_224_0))
		__G__TRACKBACK__("unregistered skill_resist DB :" .. arg_224_0)
	end
	
	return var_224_1 == "y"
end

function SkillProc.getImmuneDefPenSeq(arg_225_0, arg_225_1, arg_225_2, arg_225_3)
	if arg_225_1 and string.find(arg_225_1, "DEF_PEN") and PLATFORM == "win32" and not IS_TOOL_MODE then
		Log.e(string.format("네이밍 규칙에 어긋난 BF 혹은 DBF : %s", arg_225_1))
		__G__TRACKBACK__("BF or DBF against naming rules : " .. arg_225_1)
	end
	
	local var_225_0 = {}
	
	if arg_225_1 and arg_225_0 and arg_225_0.states:isExistEffect("CSP_IMMUNE_DEFPEN") and string.find(arg_225_1, "DEFPEN") then
		var_225_0.activated = true
		
		if arg_225_2 and arg_225_2.pen_rate then
			var_225_0.attacker_pen_rate = arg_225_2.pen_rate
		end
		
		if arg_225_3 and arg_225_3.def then
			var_225_0.target_def = arg_225_3.def
		end
	end
	
	return var_225_0
end

function SkillProc.aceivateImmuneDefPen(arg_226_0, arg_226_1, arg_226_2)
	if arg_226_0.attacker_pen_rate then
		arg_226_1.pen_rate = arg_226_0.attacker_pen_rate
	end
	
	if arg_226_0.target_def then
		arg_226_2.def = arg_226_0.target_def
	end
end

function SkillProc.getConditionTarget(arg_227_0, arg_227_1, arg_227_2, arg_227_3, arg_227_4, arg_227_5, arg_227_6, arg_227_7)
	local var_227_0
	local var_227_1 = false
	
	if arg_227_1 == 1 then
		var_227_0 = arg_227_0
	elseif arg_227_1 == 2 then
		var_227_0 = arg_227_2
	elseif arg_227_1 == 4 then
		var_227_0 = arg_227_4[1]
	elseif arg_227_1 == 5 then
		var_227_0 = arg_227_5 or arg_227_3[1]
	elseif arg_227_1 == 6 then
		var_227_0 = arg_227_6
	elseif arg_227_1 == 7 then
		local var_227_2 = {}
		local var_227_3 = arg_227_6.logic:pickUnits(arg_227_6, ENEMY)
		
		for iter_227_0, iter_227_1 in pairs(var_227_3) do
			if iter_227_1 and iter_227_1.skillDamageTag then
				local var_227_4 = iter_227_1:skillDamageTag(arg_227_6)
				
				if var_227_4 and var_227_4.skill_id == arg_227_7 then
					table.insert(var_227_2, iter_227_1)
				end
			end
		end
		
		var_227_0 = var_227_2
		var_227_1 = true
	elseif arg_227_1 == 8 then
		var_227_0 = arg_227_0.logic:getTurnOwner()
	else
		var_227_0 = arg_227_3[1]
	end
	
	return var_227_0, var_227_1
end

function SkillProc.checkCommonCon(arg_228_0, arg_228_1, arg_228_2, arg_228_3, arg_228_4, arg_228_5, arg_228_6, arg_228_7, arg_228_8, arg_228_9, arg_228_10, arg_228_11, arg_228_12)
	if not arg_228_2 then
		return true
	end
	
	local var_228_0 = "!"
	
	if string.starts(tostring(arg_228_2), var_228_0) then
		local var_228_1 = string.sub(tostring(arg_228_2), string.len(var_228_0) + 1, -1)
		
		return not SkillProc.checkCommonCon(arg_228_0, arg_228_1, var_228_1, arg_228_3, arg_228_4, arg_228_5, arg_228_6, arg_228_7, arg_228_8, arg_228_9, arg_228_10, arg_228_11, arg_228_12)
	end
	
	if PLATFORM == "win32" and SkillProc.state_conds[arg_228_2] then
		Log.e(arg_228_2 .. "효과는 지속효과 전용입니다. :" .. tostring(arg_228_1))
	end
	
	local var_228_2, var_228_3 = SkillProc.getConditionTarget(arg_228_0, arg_228_3, arg_228_5, arg_228_6, arg_228_11, arg_228_12, arg_228_10, arg_228_1)
	
	if var_228_3 then
		for iter_228_0, iter_228_1 in pairs(var_228_2) do
			if SkillProc.checkCommonCon(arg_228_0, arg_228_1, arg_228_2, 3, arg_228_4, arg_228_5, {
				iter_228_1
			}, arg_228_7, arg_228_8, arg_228_9, arg_228_10, arg_228_11, arg_228_12) then
				return true
			end
		end
		
		return false
	end
	
	if arg_228_2 == "ALWAYS" then
		return true
	end
	
	if arg_228_2 == "IGNORE_MISS" then
		return true
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_OVER_SELF" then
		return arg_228_4 <= arg_228_0:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_LESS_SELF" then
		return arg_228_4 >= arg_228_0:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_EXCESS_SELF" then
		return arg_228_4 < arg_228_0:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_BELOW_SELF" then
		return arg_228_4 > arg_228_0:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_CSID_SELF" then
		local var_228_4 = totable(arg_228_4)
		
		if not var_228_4.opt then
			return arg_228_0.states:countById(var_228_4.csid) >= tonumber(var_228_4.cnt)
		end
		
		if var_228_4.opt == "less" then
			return arg_228_0.states:countById(var_228_4.csid) <= tonumber(var_228_4.cnt)
		elseif var_228_4.opt == "equal" then
			return arg_228_0.states:countById(var_228_4.csid) == tonumber(var_228_4.cnt)
		elseif var_228_4.opt == "greater" then
			return arg_228_0.states:countById(var_228_4.csid) >= tonumber(var_228_4.cnt)
		end
	end
	
	if arg_228_2 == "ATTACK_CRITICAL" then
		return arg_228_8
	end
	
	if arg_228_2 == "ATTACK_NOTCRITICAL" then
		return not arg_228_8
	end
	
	if arg_228_2 == "ATTACK_HIT" then
		return not arg_228_7
	end
	
	if arg_228_2 == "ATTACK_EVASION" then
		return arg_228_7
	end
	
	if arg_228_2 == "ATTACK_EACH_CRITICAL" then
		return to_n(arg_228_0.turn_vars.global_critical_count) > 0
	end
	
	if arg_228_2 == "ATTACK_EACH_HIT" then
		return arg_228_0.turn_vars.global_hit_flag
	end
	
	if arg_228_2 == "ATTACK_EACH_EVASION" then
		return to_n(arg_228_0.turn_vars.global_miss_count) > 0
	end
	
	if arg_228_2 == "ATTACK_KILL" then
		return arg_228_0.turn_vars.global_kill_flag
	end
	
	if arg_228_2 == "ATTACK_KILL_OTHER" then
		local var_228_5 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
		
		for iter_228_2, iter_228_3 in pairs(var_228_5) do
			if iter_228_3 ~= arg_228_0 and iter_228_3.turn_vars.global_kill_flag then
				return true
			end
		end
		
		return false
	end
	
	if arg_228_2 == "ATTACK_KILL_FIRST" then
		local var_228_6 = arg_228_10.logic:pickUnits(arg_228_10, ENEMY)
		
		for iter_228_4, iter_228_5 in pairs(var_228_6) do
			if iter_228_5.turn_vars.global_kill_first == arg_228_0:getUID() then
				return true
			end
		end
		
		return false
	end
	
	if arg_228_2 == "ATTACK_ALIVE" then
		return not arg_228_0.turn_vars.global_kill_flag
	end
	
	if arg_228_2 == "ATTACK_NORMALSKILL" or arg_228_2 == "ATTACK_COOPSKILL" or arg_228_2 == "ATTACK_ADDSKILL" or arg_228_2 == "ATTACK_HIDDENSKILL" or arg_228_2 == "ATTACK_SOULBURN" or arg_228_2 == "ATTACK_COUNTER" then
		local var_228_7 = arg_228_10.logic:pickUnits(arg_228_10, ENEMY)
		
		for iter_228_6, iter_228_7 in pairs(var_228_7) do
			local var_228_8 = iter_228_7.turn_vars.skill_source_dirty
			
			if iter_228_7 and iter_228_7.skillDamageTag then
				local var_228_9 = iter_228_7:skillDamageTag(arg_228_10)
				
				if var_228_9 and var_228_9.skill_id == arg_228_1 then
					var_228_8 = var_228_9.source
				end
			end
			
			if arg_228_2 == "ATTACK_NORMALSKILL" then
				if var_228_8 == "normal" then
					return true
				end
			elseif arg_228_2 == "ATTACK_HIDDENSKILL" then
				if var_228_8 and var_228_8 ~= "normal" then
					return true
				end
			elseif arg_228_2 == "ATTACK_COOPSKILL" then
				if var_228_8 == "coop" then
					return true
				end
			elseif arg_228_2 == "ATTACK_ADDSKILL" then
				if var_228_8 == "hidden" then
					return true
				end
			elseif arg_228_2 == "ATTACK_SOULBURN" then
				if damage_tag then
					local var_228_10 = damage_tag.skill_id
					local var_228_11 = arg_228_10:getSkillDB(var_228_10, "soul_req")
					
					if to_n(var_228_11) > 0 then
						return true
					end
				end
			elseif arg_228_2 == "ATTACK_COUNTER" and var_228_8 == "counter" then
				return true
			end
		end
		
		return false
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_OVER_CSTIMINGTARGET" then
		return arg_228_4 <= arg_228_5:getHPRatio()
	elseif arg_228_2 == "TARGET_NOWHPRATE_LESS_CSTIMINGTARGET" then
		return arg_228_4 >= arg_228_5:getHPRatio()
	elseif arg_228_2 == "FIRST_SKILL_HIT" then
		return not arg_228_7 and arg_228_0:isMajorSkill(arg_228_1)
	elseif arg_228_2 == "RESOURCE_OVER" then
		return to_n(arg_228_4) <= arg_228_0:getSPRatio()
	elseif arg_228_2 == "DAMAGED_ATTACK_TYPE" then
		local var_228_12 = DB("skill", arg_228_1, "target")
		local var_228_13 = tostring(var_228_12)
		local var_228_14 = string.split(tostring(arg_228_4), ",")
		
		for iter_228_8, iter_228_9 in pairs(var_228_14) do
			if var_228_13 == iter_228_9 then
				return true
			end
		end
		
		return false
	end
	
	if arg_228_2 == "TARGET_CSTYPE_SELF" then
		local var_228_15 = arg_228_0
		local var_228_16 = totable(arg_228_4)
		local var_228_17 = var_228_15.states:getTypeCount(var_228_16.cstype)
		
		if var_228_16.opt == "equal" then
			return var_228_17 == tonumber(var_228_16.cnt)
		elseif var_228_16.opt == "greater" then
			return var_228_17 >= tonumber(var_228_16.cnt)
		elseif var_228_16.opt == "less" then
			return var_228_17 <= tonumber(var_228_16.cnt)
		end
	end
	
	if arg_228_2 == "TARGET_ATTRIBUTE" then
		local var_228_18 = string.split(tostring(arg_228_4), ",")
		local var_228_19 = var_228_2 or arg_228_5
		
		return table.isInclude(var_228_18, var_228_19:getColor())
	end
	
	if arg_228_2 == "TARGET_ATTRIBUTE_TARGET" then
		local var_228_20
		local var_228_21 = totable(arg_228_4)
		
		if var_228_21.target == "ally" then
			var_228_20 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
		elseif var_228_21.target == "enemy" then
			var_228_20 = arg_228_0.logic:pickUnits(arg_228_0, ENEMY)
		elseif var_228_21.target == "both" then
			var_228_20 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
			
			table.merge(var_228_20, arg_228_0.logic:pickUnits(arg_228_0, ENEMY))
		end
		
		local var_228_22 = 0
		
		for iter_228_10, iter_228_11 in pairs(var_228_20) do
			if iter_228_11:getColor() == var_228_21.attribute then
				var_228_22 = var_228_22 + 1
			end
		end
		
		if tonumber(var_228_21.cnt) then
			if var_228_21.opt == "equal" then
				return var_228_22 == tonumber(var_228_21.cnt)
			elseif var_228_21.opt == "greater" then
				return var_228_22 >= tonumber(var_228_21.cnt)
			elseif var_228_21.opt == "less" then
				return var_228_22 <= tonumber(var_228_21.cnt)
			end
		elseif var_228_21.cnt == "all" then
			return var_228_22 > 0 and var_228_22 == table.count(var_228_20)
		end
	end
	
	if arg_228_2 == "TARGET_CSIDCHECK_TARGET" then
		local var_228_23
		local var_228_24 = totable(arg_228_4)
		
		if var_228_24.target == "ally" then
			var_228_23 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
		elseif var_228_24.target == "enemy" then
			var_228_23 = arg_228_0.logic:pickUnits(arg_228_0, ENEMY)
		elseif var_228_24.target == "both" then
			var_228_23 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
			
			table.merge(var_228_23, arg_228_0.logic:pickUnits(arg_228_0, ENEMY))
		end
		
		local var_228_25 = 0
		
		for iter_228_12, iter_228_13 in pairs(var_228_23) do
			local var_228_26 = false
			
			for iter_228_14, iter_228_15 in pairs(iter_228_13.states.List) do
				if iter_228_15:isValid() and iter_228_15:getId() == var_228_24.csid then
					var_228_26 = true
				end
			end
			
			if var_228_26 then
				var_228_25 = var_228_25 + 1
			end
		end
		
		if tonumber(var_228_24.cnt) then
			if var_228_24.opt == "equal" then
				return var_228_25 == tonumber(var_228_24.cnt)
			elseif var_228_24.opt == "greater" then
				return var_228_25 >= tonumber(var_228_24.cnt)
			elseif var_228_24.opt == "less" then
				return var_228_25 <= tonumber(var_228_24.cnt)
			end
		elseif var_228_24.cnt == "all" then
			return var_228_25 > 0 and var_228_25 == table.count(var_228_23)
		end
	end
	
	if arg_228_2 == "TARGET_CSTYPECHECK_TARGET" then
		local var_228_27
		local var_228_28 = totable(arg_228_4)
		
		if var_228_28.target == "ally" then
			var_228_27 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
		elseif var_228_28.target == "enemy" then
			var_228_27 = arg_228_0.logic:pickUnits(arg_228_0, ENEMY)
		elseif var_228_28.target == "both" then
			var_228_27 = arg_228_0.logic:pickUnits(arg_228_0, FRIEND)
			
			table.merge(var_228_27, arg_228_0.logic:pickUnits(arg_228_0, ENEMY))
		end
		
		local var_228_29 = 0
		
		for iter_228_16, iter_228_17 in pairs(var_228_27) do
			local var_228_30 = false
			
			for iter_228_18, iter_228_19 in pairs(iter_228_17.states.List) do
				if iter_228_19:isValid() and iter_228_19.db.cs_type == var_228_28.cstype then
					var_228_30 = true
				end
			end
			
			if var_228_30 then
				var_228_29 = var_228_29 + 1
			end
		end
		
		if tonumber(var_228_28.cnt) then
			if var_228_28.opt == "equal" then
				return var_228_29 == tonumber(var_228_28.cnt)
			elseif var_228_28.opt == "greater" then
				return var_228_29 >= tonumber(var_228_28.cnt)
			elseif var_228_28.opt == "less" then
				return var_228_29 <= tonumber(var_228_28.cnt)
			end
		elseif var_228_28.cnt == "all" then
			return var_228_29 > 0 and var_228_29 == table.count(var_228_27)
		end
	end
	
	if arg_228_2 == "ATTRIBUTE_SELF" then
		local var_228_31 = string.split(arg_228_4 or "", ",")
		
		return table.isInclude(var_228_31, arg_228_0:getColor())
	end
	
	if not var_228_2 then
		return false
	end
	
	if arg_228_2 == "TARGET_CSID_TARGET" then
		local var_228_32 = totable(arg_228_4)
		
		if not var_228_32.opt then
			return var_228_2.states:countById(var_228_32.csid) >= tonumber(var_228_32.cnt)
		end
		
		if var_228_32.opt == "less" then
			return var_228_2.states:countById(var_228_32.csid) <= tonumber(var_228_32.cnt)
		elseif var_228_32.opt == "equal" then
			return var_228_2.states:countById(var_228_32.csid) == tonumber(var_228_32.cnt)
		elseif var_228_32.opt == "greater" then
			return var_228_2.states:countById(var_228_32.csid) >= tonumber(var_228_32.cnt)
		end
	end
	
	if arg_228_2 == "TARGET_CHAR_STAMP_TARGET" then
		local var_228_33 = totable(arg_228_4 or "")
		local var_228_34 = tonumber(var_228_33.stamp)
		
		if var_228_2 and var_228_34 and var_228_2.inst.code == var_228_33.id then
			if var_228_33.opt == "equal" then
				return var_228_2:getDevote() == var_228_34
			elseif var_228_33.opt == "greater" then
				return var_228_34 <= var_228_2:getDevote()
			elseif var_228_33.opt == "less" then
				return var_228_34 >= var_228_2:getDevote()
			end
		end
		
		return false
	end
	
	if arg_228_2 == "TARGET_CSSTACK_TARGET" then
		local var_228_35 = totable(arg_228_4 or "")
		local var_228_36 = var_228_35.csid
		local var_228_37 = tonumber(var_228_35.stack)
		
		if var_228_2 and var_228_36 and var_228_37 then
			local var_228_38 = var_228_2.states:find(var_228_36)
			
			if var_228_38 then
				if var_228_35.opt == "equal" then
					return var_228_38.stack_count == var_228_37
				elseif var_228_35.opt == "greater" then
					return var_228_37 <= var_228_38.stack_count
				elseif var_228_35.opt == "less" then
					return var_228_37 >= var_228_38.stack_count
				end
			end
		end
		
		return false
	end
	
	if arg_228_2 == "TARGET_PLAYABLE" then
		if var_228_2.logic:isPVP() or arg_228_0:getAlly() == var_228_2:getAlly() then
			return true
		end
		
		return false
	end
	
	if arg_228_2 == "SKILL_TARGET_CLASS" then
		local var_228_39 = var_228_2.db.role
		local var_228_40 = string.split(arg_228_4 or "", ",")
		
		return table.isInclude(var_228_40, var_228_39)
	end
	
	if arg_228_2 == "SELF_TURN_ATTACK" then
		return arg_228_0 == arg_228_0.logic:getTurnOwner()
	end
	
	if arg_228_2 == "TARGET_ATTRIBUTE_ID" then
		return var_228_2:checkStateAttribute(arg_228_4)
	end
	
	if arg_228_2 == "TARGET_CSTYPE_ATTRIBUTE_ID" then
		local var_228_41 = totable(arg_228_4 or "")
		local var_228_42 = var_228_41.cstype
		local var_228_43 = to_n(var_228_41.attribute)
		
		return var_228_2:checkStateAttribute(var_228_43, var_228_42)
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_OVER_TARGET" then
		return arg_228_4 <= var_228_2:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_LESS_TARGET" then
		return arg_228_4 >= var_228_2:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_EXCESS_TARGET" then
		return arg_228_4 < var_228_2:getHPRatio()
	end
	
	if arg_228_2 == "TARGET_NOWHPRATE_BELOW_TARGET" then
		return arg_228_4 > var_228_2:getHPRatio()
	end
	
	if arg_228_2 == "ATTACK_TARGET_FIRE" then
		return var_228_2:getColor() == "fire"
	end
	
	if arg_228_2 == "ATTACK_TARGET_ICE" then
		return var_228_2:getColor() == "ice"
	end
	
	if arg_228_2 == "ATTACK_TARGET_WIND" then
		return var_228_2:getColor() == "wind"
	end
	
	if arg_228_2 == "ATTACK_TARGET_LIGHT" then
		return var_228_2:getColor() == "light"
	end
	
	if arg_228_2 == "ATTACK_TARGET_DARK" then
		return var_228_2:getColor() == "dark"
	end
	
	if arg_228_2 == "ATTACK_TARGET_NOT_COLOR" then
		return var_228_2:getColor() ~= arg_228_4
	end
	
	if arg_228_2 == "TARGET_AB_OVER" then
		return var_228_2.inst.elapsed_ut >= MAX_UNIT_TICK * arg_228_4
	end
	
	if arg_228_2 == "TARGET_AB_LESS" then
		return var_228_2.inst.elapsed_ut <= MAX_UNIT_TICK * arg_228_4
	end
	
	if arg_228_2 == "SKILL_TARGET_ROLE" then
		local var_228_44 = totable(arg_228_4 or "").target or {}
		local var_228_45 = var_228_2.db.role
		
		return table.isInclude(var_228_44, var_228_45)
	end
	
	local function var_228_46(arg_229_0, arg_229_1)
		local var_229_0 = totable(arg_229_1)
		local var_229_1 = arg_229_0.states:getTypeCount(var_229_0.cstype)
		
		if var_229_0.opt == "equal" then
			return var_229_1 == tonumber(var_229_0.cnt)
		elseif var_229_0.opt == "greater" then
			return var_229_1 >= tonumber(var_229_0.cnt)
		elseif var_229_0.opt == "less" then
			return var_229_1 <= tonumber(var_229_0.cnt)
		end
	end
	
	if arg_228_2 == "TARGET_CSTYPE_TARGET" then
		local var_228_47 = var_228_2
		
		return var_228_46(var_228_47, arg_228_4)
	end
	
	if arg_228_2 == "SKILL_TARGETS_CSTYPE_TARGET" then
		if arg_228_6 then
			for iter_228_20, iter_228_21 in pairs(arg_228_6) do
				if not iter_228_21:isDead() and var_228_46(iter_228_21, arg_228_4) then
					return true
				end
			end
		end
		
		return 
	end
	
	if arg_228_2 == "TARGET_CSGROUP_SELF" then
		local var_228_48 = arg_228_0
		local var_228_49 = totable(arg_228_4)
		local var_228_50 = var_228_48.states:getGroupCount(var_228_49.csgroup)
		
		if var_228_49.opt == "equal" then
			return var_228_50 == tonumber(var_228_49.cnt)
		elseif var_228_49.opt == "greater" then
			return var_228_50 >= tonumber(var_228_49.cnt)
		elseif var_228_49.opt == "less" then
			return var_228_50 <= tonumber(var_228_49.cnt)
		end
	end
	
	if arg_228_2 == "TARGET_CSGROUP_TARGET" then
		local var_228_51 = var_228_2
		local var_228_52 = totable(arg_228_4)
		local var_228_53 = var_228_51.states:getGroupCount(var_228_52.csgroup)
		
		if var_228_52.opt == "equal" then
			return var_228_53 == tonumber(var_228_52.cnt)
		elseif var_228_52.opt == "greater" then
			return var_228_53 >= tonumber(var_228_52.cnt)
		elseif var_228_52.opt == "less" then
			return var_228_53 <= tonumber(var_228_52.cnt)
		end
	end
	
	if arg_228_2 == "ATTACK_TARGET_NORMAL" then
		return var_228_2.db.type == "monster" and var_228_2.db.tier == "normal"
	end
	
	if arg_228_2 == "ATTACK_TARGET_BOSS" or arg_228_2 == "ATTACK_TARGET_NOT_BOSS" then
		local var_228_54 = var_228_2.db.type == "monster" and table.isInclude({
			"elite",
			"subboss",
			"boss"
		}, var_228_2.db.tier)
		
		if arg_228_2 == "ATTACK_TARGET_BOSS" then
			return var_228_54
		end
		
		if arg_228_2 == "ATTACK_TARGET_NOT_BOSS" then
			return not var_228_54
		end
	end
	
	if arg_228_2 == "CS_CHECK_ALLY_ALL" or arg_228_2 == "CS_CHECK_ENEMY_ALL" then
		local var_228_55 = arg_228_2 == "CS_CHECK_ALLY_ALL" and FRIEND or ENEMY
		local var_228_56 = arg_228_0.logic:pickUnits(arg_228_0, var_228_55)
		local var_228_57 = 0
		
		for iter_228_22, iter_228_23 in pairs(var_228_56) do
			if not iter_228_23:isDead() and not iter_228_23.states:isExistEffect("CSP_CANTTARGET") then
				if not iter_228_23.states:isExistById(arg_228_4) then
					return false
				end
				
				var_228_57 = var_228_57 + 1
			end
		end
		
		if var_228_57 > 0 then
			return true
		end
		
		return false
	end
	
	if arg_228_2 == "SELF_STATUS_OVER" or arg_228_2 == "SELF_STATUS_LESS" or arg_228_2 == "TARGET_STATUS_OVER" or arg_228_2 == "TARGET_STATUS_LESS" then
		local var_228_58 = string.split(arg_228_2, "_")
		local var_228_59 = var_228_58[1] == "SELF" and arg_228_0 or var_228_2
		local var_228_60 = var_228_58[3] == "OVER" and function(arg_230_0, arg_230_1)
			return arg_230_1 <= arg_230_0
		end or function(arg_231_0, arg_231_1)
			return arg_231_0 <= arg_231_1
		end
		local var_228_61 = totable(arg_228_4)
		local var_228_62 = var_228_61.status
		local var_228_63 = string.gsub(var_228_61.value or "", "%%", "")
		local var_228_64 = {
			"con",
			"dodge",
			"cri",
			"cri_res",
			"res"
		}
		
		if table.find(var_228_64, var_228_62) then
			var_228_63 = var_228_63 / 100
		end
		
		local var_228_65 = var_228_59:getStatus()[var_228_62] or 0
		
		return var_228_60(var_228_65, tonumber(var_228_63))
	end
	
	if arg_228_2 == "TARGET_STATUS_HIGHEST" or arg_228_2 == "TARGET_STATUS_LOWEST" then
		local var_228_66 = var_228_2.logic:pickUnits(var_228_2, FRIEND, var_228_2)
		local var_228_67 = var_228_2:getStatus()[arg_228_4] or 0
		
		for iter_228_24, iter_228_25 in pairs(var_228_66) do
			if arg_228_2 == "TARGET_STATUS_HIGHEST" then
				if var_228_67 < iter_228_25:getStatus()[arg_228_4] then
					return false
				end
			elseif arg_228_2 == "TARGET_STATUS_LOWEST" and var_228_67 > iter_228_25:getStatus()[arg_228_4] then
				return false
			end
		end
		
		return true
	end
	
	if arg_228_2 == "LOCATION_NOW" then
		local var_228_68, var_228_69 = arg_228_0.logic:getContentsType()
		
		if arg_228_4 == "pvp" then
			return arg_228_0.logic:isPVP()
		elseif arg_228_4 == "pve" then
			return not arg_228_0.logic:isPVP()
		end
		
		return arg_228_4 == var_228_68
	end
	
	if arg_228_2 == "TURN_SELF" then
		return arg_228_0 == arg_228_0.logic:getTurnOwner()
	end
	
	if arg_228_2 == "TURN_OTHER" then
		return arg_228_0 ~= arg_228_0.logic:getTurnOwner()
	end
	
	if arg_228_2 == "TARGET_NOT_SELF_SKILL" then
		return arg_228_10 ~= arg_228_5
	end
	
	return nil
end
