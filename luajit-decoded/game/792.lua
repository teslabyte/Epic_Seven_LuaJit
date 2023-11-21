RumbleSkill = ClassDef()
RumbleSkill.EffectFunc = {}
RumbleSkill.TargetFunc = {}

function RumbleSkill.constructor(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_1 then
		return 
	end
	
	arg_1_0.id = arg_1_2
	arg_1_0.unit = arg_1_1
	
	local var_1_0 = arg_1_0:loadDB()
	
	if not var_1_0 then
		return 
	end
	
	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		arg_1_0[iter_1_0] = iter_1_1
	end
	
	arg_1_0.anim = RumbleUnitAnim[arg_1_2] or {}
	
	if arg_1_0.anim.hit_info then
		arg_1_0.target = arg_1_0.target or "ENEMY"
	end
	
	arg_1_0:resetCooldown()
end

function RumbleSkill.loadDB(arg_2_0)
	local var_2_0 = {
		"id",
		"range",
		"cooldown",
		"target",
		"passive",
		"penetrate"
	}
	
	for iter_2_0 = 1, 2 do
		table.insert(var_2_0, "con_" .. iter_2_0)
		table.insert(var_2_0, "con_" .. iter_2_0 .. "_value")
	end
	
	for iter_2_1 = 1, 5 do
		table.insert(var_2_0, "eff_" .. iter_2_1)
		table.insert(var_2_0, "eff_" .. iter_2_1 .. "_value")
		table.insert(var_2_0, "eff_" .. iter_2_1 .. "_target")
		table.insert(var_2_0, "eff_" .. iter_2_1 .. "_duration")
	end
	
	return DBT("rumble_skill", arg_2_0.id, var_2_0)
end

function RumbleSkill.getId(arg_3_0)
	return arg_3_0.id
end

function RumbleSkill.fire(arg_4_0, arg_4_1)
	if not arg_4_0.unit then
		return 
	end
	
	arg_4_1 = arg_4_1 or {}
	
	if arg_4_0.anim.hit_info then
		arg_4_0.eff_1 = arg_4_0.eff_1 or "DEAL"
		arg_4_0.eff_1_value = arg_4_0.eff_1_value or 1
		arg_4_0.eff_1_target = arg_4_0.eff_1_target or "UNIT_TARGET"
		arg_4_0.anim.eff_delay = arg_4_0.anim.eff_delay or arg_4_0.anim.hit_info[1][1]
	end
	
	local var_4_0 = arg_4_1.target or arg_4_0:getMainTarget()
	
	if not var_4_0 then
		return 
	end
	
	if arg_4_0.anim.ult then
		RumbleSystem:lockUlt()
	end
	
	if arg_4_0.anim.hit_info then
		arg_4_0:playDamageAct(var_4_0)
	end
	
	local var_4_1 = {
		skill = arg_4_0,
		unit = arg_4_0.unit,
		main_target = var_4_0,
		opts = arg_4_1
	}
	
	local function var_4_2()
		local var_5_0 = {}
		
		for iter_5_0 = 1, 9 do
			local var_5_1 = arg_4_0["eff_" .. iter_5_0]
			
			if not var_5_1 then
				break
			end
			
			local var_5_2 = table.shallow_clone(var_4_1)
			
			var_5_2.eff = var_5_1
			var_5_2.value = arg_4_0["eff_" .. iter_5_0 .. "_value"]
			var_5_2.duration = arg_4_0["eff_" .. iter_5_0 .. "_duration"]
			var_5_2.target_func_name = arg_4_0["eff_" .. iter_5_0 .. "_target"]
			
			local var_5_3 = arg_4_0:procSkillEffect(var_5_2)
			
			for iter_5_1, iter_5_2 in pairs(var_5_3 or {}) do
				var_5_0[iter_5_2:getUID()] = true
			end
		end
		
		for iter_5_3, iter_5_4 in pairs(var_5_0) do
			local var_5_4 = RumbleBoard:getUnitByUID(iter_5_3)
			
			if var_5_4 then
				var_5_4:showInfoText()
			end
		end
	end
	
	if arg_4_0.anim.eff_delay then
		BattleAction:Add(SEQ(DELAY(arg_4_0.anim.eff_delay), CALL(var_4_2)), arg_4_0.unit:getModel())
	else
		var_4_2()
	end
	
	if arg_4_0.anim.eff_info then
		arg_4_0:playEffectAct(arg_4_0.unit, var_4_0)
	end
end

function RumbleSkill.calcDamage(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3.pow or arg_6_1:getStatAttack()
	local var_6_1 = arg_6_0:getPenetrate()
	local var_6_2 = arg_6_2:getStatDefense() * (1 - var_6_1)
	local var_6_3 = arg_6_3.crc or arg_6_1:getCriticalChance()
	local var_6_4 = false
	
	if var_6_3 > RumbleSystem:getRandom() then
		var_6_4 = true
	end
	
	if DEBUG.TEST_CRITICAL then
		var_6_4 = true
	end
	
	if DEBUG.TEST_NORMAL_DAMAGE or DEBUG.TEST_SMITE then
		var_6_4 = false
	end
	
	local var_6_5 = var_6_0 * 2 * (100 / (100 + var_6_2))
	local var_6_6 = arg_6_1:getBonusPower()
	
	if var_6_6 > 0 then
		var_6_5 = var_6_5 * (1 + var_6_6)
	end
	
	if var_6_4 then
		var_6_5 = var_6_5 * arg_6_1:getCriticalDamage()
	end
	
	return var_6_5, var_6_4
end

function RumbleSkill.playDamageAct(arg_7_0, arg_7_1)
	if not arg_7_0.unit then
		return 
	end
	
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in ipairs(arg_7_0.anim.hit_info) do
		local var_7_1 = SEQ(DELAY(iter_7_1[1]), CALL(function()
			if arg_7_0.unit:isDead() then
				return 
			end
			
			arg_7_0.unit:playEffect(arg_7_1, {
				0,
				"Unit_Target",
				iter_7_1[2]
			}, {
				bone = "target",
				scale = (iter_7_1[3] or 1) * 0.5
			})
		end))
		
		table.insert(var_7_0, var_7_1)
	end
	
	local var_7_2 = arg_7_1:getModel()
	
	if not get_cocos_refid(var_7_2) then
		return 
	end
	
	BattleAction:Add(SPAWN(table.unpack(var_7_0)), var_7_2)
end

function RumbleSkill.playEffectAct(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1 then
		return 
	end
	
	if not arg_9_2 then
		return 
	end
	
	local function var_9_0(arg_10_0, arg_10_1)
		return SEQ(DELAY(arg_10_0[1]), CALL(function()
			arg_9_0:procSkillAct(arg_10_1, arg_10_0)
		end))
	end
	
	local var_9_1 = {}
	
	for iter_9_0, iter_9_1 in ipairs(arg_9_0.anim.eff_info or {}) do
		if iter_9_1[4] and iter_9_1[4].target then
			local var_9_2 = arg_9_0:getSkillTarget({
				skill = arg_9_0,
				unit = arg_9_0.unit,
				target_func_name = iter_9_1[4].target
			})
			
			for iter_9_2, iter_9_3 in pairs(var_9_2) do
				table.insert(var_9_1, var_9_0(iter_9_1, iter_9_3))
			end
		else
			table.insert(var_9_1, var_9_0(iter_9_1, arg_9_2))
		end
	end
	
	local var_9_3 = arg_9_1:getModel()
	
	if not get_cocos_refid(var_9_3) then
		return 
	end
	
	BattleAction:Add(SPAWN(table.unpack(var_9_1)), var_9_3)
end

function RumbleSkill.procSkillAct(arg_12_0, arg_12_1, arg_12_2)
	if not RumbleSystem:isInBattle() then
		return 
	end
	
	local var_12_0 = arg_12_0.unit
	
	if not var_12_0 or var_12_0:isDead() then
		return 
	end
	
	local var_12_1 = var_12_0:getUnitNode()
	
	if not get_cocos_refid(var_12_1) then
		return 
	end
	
	local var_12_2 = var_12_0:getModel()
	
	if not get_cocos_refid(var_12_2) then
		return 
	end
	
	local var_12_3 = arg_12_2[2]
	
	if var_12_3 == "focus" then
		local var_12_4 = table.shallow_clone(arg_12_2[3])
		
		if var_12_4.target then
			var_12_4.targets = arg_12_0:getSkillTarget({
				skill = arg_12_0,
				unit = var_12_0,
				target_func_name = var_12_4.target
			})
		else
			var_12_4.targets = {
				arg_12_1
			}
		end
		
		RumbleSystem:useUltimateSkill(var_12_0, var_12_4)
	elseif var_12_3 == "focus_back" then
		RumbleSystem:resetFocus(arg_12_2[3])
	elseif var_12_3 == "jump" then
		local var_12_5 = table.shallow_clone(arg_12_2[3])
		local var_12_6 = var_12_5.rate or 0.5
		local var_12_7 = arg_12_1:getPosition().x * var_12_6 + var_12_0:getPosition().x * (1 - var_12_6)
		local var_12_8 = arg_12_1:getPosition().y * var_12_6 + var_12_0:getPosition().y * (1 - var_12_6)
		
		var_12_5.x, var_12_5.y = RumbleBoard:tilePosToBoardPos(var_12_7, var_12_8)
		var_12_5.style = "jump"
		
		BattleAction:Add(USER_ACT(RumbleUnitAct(var_12_1, var_12_5, {
			model = var_12_2
		})), var_12_1)
	elseif var_12_3 == "move" then
		local var_12_9 = table.shallow_clone(arg_12_2[3])
		local var_12_10 = var_12_9.rate or 1
		local var_12_11 = arg_12_1:getPosition().x * var_12_10 + var_12_0:getPosition().x * (1 - var_12_10)
		local var_12_12 = arg_12_1:getPosition().y * var_12_10 + var_12_0:getPosition().y * (1 - var_12_10)
		
		var_12_9.x, var_12_9.y = RumbleBoard:tilePosToBoardPos(var_12_11, var_12_12)
		
		BattleAction:Add(USER_ACT(RumbleUnitAct(var_12_1, var_12_9, {
			model = var_12_2
		})), var_12_1)
	elseif var_12_3 == "warp" then
		local var_12_13 = arg_12_2[3] or {}
		local var_12_14, var_12_15 = RumbleBoard:tilePosToBoardPos(var_12_0:getPosition().x, var_12_0:getPosition().y)
		
		var_12_1:setPosition(var_12_14 + to_n(var_12_13.x), var_12_15 + to_n(var_12_13.y))
	elseif var_12_3 == "position" then
		local var_12_16 = RumbleBoard:getMovableTiles(arg_12_1:getPosition(), 1)
		
		if not var_12_16 or table.empty(var_12_16) then
			return 
		end
		
		local var_12_17 = RumbleSystem:getRandom(1, #var_12_16)
		
		var_12_0:setPosition(var_12_16[var_12_17], true)
		var_12_0:updateFlipX(arg_12_1:getPosition())
		var_12_1:setLocalZOrder(var_12_0:getUnitZOrder())
	elseif var_12_3 == "anim" then
		var_12_0:setAnimation(arg_12_2[3], arg_12_2[4])
	else
		var_12_0:playEffect(arg_12_1, arg_12_2, arg_12_2[4])
	end
end

function RumbleSkill.procSkillEffect(arg_13_0, arg_13_1)
	if not RumbleSystem:isInBattle() then
		return 
	end
	
	local var_13_0 = RumbleSkill.EffectFunc[arg_13_1.eff]
	
	if type(var_13_0) == "function" then
		local var_13_1 = arg_13_0:getSkillTarget(arg_13_1) or {}
		
		for iter_13_0, iter_13_1 in pairs(var_13_1) do
			arg_13_1.target = iter_13_1
			
			var_13_0(arg_13_1)
		end
		
		return var_13_1
	end
end

function RumbleSkill.getSkillTarget(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or {
		skill = arg_14_0,
		unit = arg_14_0.unit
	}
	
	local var_14_0 = arg_14_1.target_func_name or "UNIT_TARGET"
	
	if type(RumbleSkill.TargetFunc[var_14_0]) == "function" then
		return RumbleSkill.TargetFunc[var_14_0](arg_14_1)
	end
end

function RumbleSkill.getMainTarget(arg_15_0)
	if not arg_15_0.unit then
		return 
	end
	
	local var_15_0
	local var_15_1 = arg_15_0.target or "SELF"
	
	if var_15_1 == "ENEMY" then
		var_15_0 = arg_15_0.unit:findClosestEnemy()
	elseif var_15_1 == "ALLY" then
		var_15_0 = arg_15_0.unit:findClosestAlly()
	elseif var_15_1 == "SELF" then
		return arg_15_0.unit
	end
	
	if var_15_0 and HTUtil:getTileCost(arg_15_0.unit:getPosition(), var_15_0:getPosition()) <= arg_15_0:getRange() then
		return var_15_0
	end
end

function RumbleSkill.getCurCooldown(arg_16_0)
	return arg_16_0.cur_cooldown or 0
end

function RumbleSkill.getMaxCooldown(arg_17_0)
	if not arg_17_0.cooldown then
		return 0
	end
	
	if arg_17_0.unit then
		local var_17_0 = arg_17_0.unit:getStat("sp") or 0
		
		return arg_17_0.cooldown - var_17_0
	end
end

function RumbleSkill.reduceCooldown(arg_18_0, arg_18_1)
	arg_18_1 = arg_18_1 or 1
	arg_18_0.cur_cooldown = math.max(0, arg_18_0.cur_cooldown - arg_18_1)
end

function RumbleSkill.getSPRatio(arg_19_0)
	local var_19_0 = arg_19_0:getMaxCooldown()
	
	if var_19_0 <= 0 then
		return 0
	end
	
	return (var_19_0 - arg_19_0:getCurCooldown()) / var_19_0
end

function RumbleSkill.resetCooldown(arg_20_0)
	arg_20_0.cur_cooldown = arg_20_0:getMaxCooldown()
	
	if DEBUG.DEBUG_SKILL then
		arg_20_0.cur_cooldown = 0
	end
end

function RumbleSkill.getPenetrate(arg_21_0)
	return arg_21_0.penetrate or 0
end

function RumbleSkill.getRange(arg_22_0)
	return (arg_22_0.range or 1) + (arg_22_0.unit:getBonusRange() or 0)
end

function RumbleSkill.getAnimationData(arg_23_0)
	return arg_23_0.anim
end

function RumbleSkill.isPassive(arg_24_0)
	return arg_24_0.passive or false
end

function RumbleSkill.checkCondition(arg_25_0)
	local var_25_0 = arg_25_0.unit
	
	if not var_25_0 then
		return false
	end
	
	if arg_25_0.cur_cooldown > 0 then
		return false
	end
	
	for iter_25_0 = 1, 3 do
		local var_25_1 = arg_25_0["con_" .. iter_25_0]
		local var_25_2 = arg_25_0["con_" .. iter_25_0 .. "_value"]
		
		if not var_25_1 then
			break
		end
		
		if not var_25_0:checkCondition(var_25_1, var_25_2) then
			return false
		end
	end
	
	return true
end

function RumbleSkill.EffectFunc.ADD_CS(arg_26_0)
	if not arg_26_0 or not arg_26_0.target then
		return 
	end
	
	arg_26_0.target:addBuff(arg_26_0.value, {
		duration = arg_26_0.duration,
		caster = arg_26_0.unit
	})
end

function RumbleSkill.EffectFunc.ADD_ENDURE(arg_27_0)
	if not arg_27_0 or not arg_27_0.target then
		return 
	end
	
	arg_27_0.target:addBuff("endure", {
		duration = arg_27_0.duration,
		caster = arg_27_0.unit,
		stack = arg_27_0.value
	})
end

function RumbleSkill.EffectFunc.SHIELD_CASTER_MAXHP(arg_28_0)
	if not arg_28_0 or not arg_28_0.target then
		return 
	end
	
	local var_28_0 = arg_28_0.unit:getMaxHp() * to_n(arg_28_0.value)
	
	arg_28_0.target:addBuff("shield", {
		duration = arg_28_0.duration,
		caster = arg_28_0.unit,
		shield = var_28_0
	})
end

function RumbleSkill.EffectFunc.SHIELD_CASTER_DEF(arg_29_0)
	if not arg_29_0 or not arg_29_0.target then
		return 
	end
	
	local var_29_0 = arg_29_0.unit:getStatDefense() * to_n(arg_29_0.value)
	
	arg_29_0.target:addBuff("shield", {
		duration = arg_29_0.duration,
		caster = arg_29_0.unit,
		shield = var_29_0
	})
end

function RumbleSkill.EffectFunc.SHIELD_CASTER_ATK(arg_30_0)
	if not arg_30_0 or not arg_30_0.target then
		return 
	end
	
	local var_30_0 = arg_30_0.unit:getStatAttack() * to_n(arg_30_0.value)
	
	arg_30_0.target:addBuff("shield", {
		duration = arg_30_0.duration,
		caster = arg_30_0.unit,
		shield = var_30_0
	})
end

function RumbleSkill.EffectFunc.SHIELD_TARGET_MAXHP(arg_31_0)
	if not arg_31_0 or not arg_31_0.target then
		return 
	end
	
	local var_31_0 = arg_31_0.target:getMaxHp() * to_n(arg_31_0.value)
	
	arg_31_0.target:addBuff("shield", {
		duration = arg_31_0.duration,
		caster = arg_31_0.unit,
		shield = var_31_0
	})
end

function RumbleSkill.EffectFunc.DEAL(arg_32_0)
	if not arg_32_0 or not arg_32_0.target then
		return 
	end
	
	local var_32_0 = arg_32_0.unit
	local var_32_1 = arg_32_0.target
	local var_32_2 = arg_32_0.skill
	local var_32_3 = var_32_0:getStatAttack()
	local var_32_4, var_32_5 = var_32_2:calcDamage(var_32_0, var_32_1, {
		pow = var_32_3 * to_n(arg_32_0.value),
		crc = arg_32_0.crc
	})
	
	if var_32_0:isDead() then
		return 
	end
	
	if var_32_1:isDead() then
		return 
	end
	
	local var_32_6 = {
		target = var_32_1,
		caster = var_32_0,
		damage = var_32_4,
		critical = var_32_5
	}
	
	var_32_1:damage(var_32_6)
	var_32_0:onAttack(var_32_6)
	
	if var_32_1:isDead() then
		var_32_0:onKill()
	end
end

function RumbleSkill.EffectFunc.DEAL_CRI(arg_33_0)
	if not arg_33_0 then
		return 
	end
	
	arg_33_0.crc = 1
	
	RumbleSkill.EffectFunc.DEAL(arg_33_0)
end

function RumbleSkill.EffectFunc.DEAL_PURE(arg_34_0)
	if not arg_34_0 or not arg_34_0.target then
		return 
	end
	
	local var_34_0 = arg_34_0.opts or {}
	
	arg_34_0.damage = arg_34_0.value
	arg_34_0.caster = arg_34_0.caster or arg_34_0.unit or var_34_0.caster
	arg_34_0.extra_dmg = var_34_0.extra_dmg
	
	arg_34_0.target:damage(arg_34_0)
end

function RumbleSkill.EffectFunc.DEAL_PURE_ATK(arg_35_0)
	if not arg_35_0 or not arg_35_0.target then
		return 
	end
	
	arg_35_0.value = arg_35_0.unit:getStatAttack() * arg_35_0.value
	
	RumbleSkill.EffectFunc.DEAL_PURE(arg_35_0)
end

function RumbleSkill.EffectFunc.REFLECT(arg_36_0)
	if not arg_36_0 or not arg_36_0.target then
		return 
	end
	
	local var_36_0 = arg_36_0.opts
	
	if not var_36_0 then
		return 
	end
	
	arg_36_0.value = to_n(var_36_0.damage) * arg_36_0.value
	
	RumbleSkill.EffectFunc.DEAL_PURE(arg_36_0)
end

function RumbleSkill.EffectFunc.HEAL(arg_37_0)
	if not arg_37_0 or not arg_37_0.target then
		return 
	end
	
	arg_37_0.target:heal(arg_37_0.value)
end

function RumbleSkill.EffectFunc.HEAL_CASTER_MAXHP(arg_38_0)
	if not arg_38_0 or not arg_38_0.target then
		return 
	end
	
	arg_38_0.target:heal(arg_38_0.unit:getMaxHp() * to_n(arg_38_0.value))
end

function RumbleSkill.EffectFunc.HEAL_CASTER_ATK(arg_39_0)
	if not arg_39_0 or not arg_39_0.target then
		return 
	end
	
	arg_39_0.target:heal(arg_39_0.unit:getStatAttack() * to_n(arg_39_0.value))
end

function RumbleSkill.EffectFunc.HEAL_TARGET_MAXHP(arg_40_0)
	if not arg_40_0 or not arg_40_0.target then
		return 
	end
	
	arg_40_0.target:heal(arg_40_0.target:getMaxHp() * to_n(arg_40_0.value))
end

function RumbleSkill.EffectFunc.REVIVE(arg_41_0)
	if not arg_41_0 or not arg_41_0.target then
		return 
	end
	
	arg_41_0.target:revive(arg_41_0.target:getMaxHp() * to_n(arg_41_0.value))
end

function RumbleSkill.EffectFunc.REDUCE_BUFF_TIME(arg_42_0)
	if not arg_42_0 or not arg_42_0.target then
		return 
	end
	
	if arg_42_0.target:isImmuned() then
		return 
	end
	
	local var_42_0 = arg_42_0.target:getBuffList()
	
	if not var_42_0 then
		return 
	end
	
	var_42_0:reduceBuffTime(arg_42_0.value)
end

function RumbleSkill.EffectFunc.REDUCE_COOLDOWN(arg_43_0)
	if not arg_43_0 or not arg_43_0.target then
		return 
	end
	
	arg_43_0.target:reduceCooldown(arg_43_0.value)
end

function RumbleSkill.EffectFunc.RESET_COOLDOWN(arg_44_0)
	if not arg_44_0 or not arg_44_0.target then
		return 
	end
	
	arg_44_0.target:resetCooldown()
end

function RumbleSkill.EffectFunc.REMOVE_DEBUFF(arg_45_0)
	if not arg_45_0 or not arg_45_0.target then
		return 
	end
	
	local var_45_0 = arg_45_0.target:getBuffList()
	
	if not var_45_0 then
		return 
	end
	
	var_45_0:removeByType("debuff", arg_45_0.value)
end

function RumbleSkill.EffectFunc.REMOVE_BUFF(arg_46_0)
	if not arg_46_0 or not arg_46_0.target then
		return 
	end
	
	local var_46_0 = arg_46_0.target:getBuffList()
	
	if not var_46_0 then
		return 
	end
	
	var_46_0:removeByType("buff", arg_46_0.value)
end

function RumbleSkill.EffectFunc.REMOVE_CS(arg_47_0)
	if not arg_47_0 or not arg_47_0.target then
		return 
	end
	
	local var_47_0 = arg_47_0.target:getBuffList()
	
	if not var_47_0 then
		return 
	end
	
	var_47_0:removeById(arg_47_0.value)
end

local function var_0_0(arg_48_0, arg_48_1)
	if not arg_48_0 then
		return 
	end
	
	local var_48_0 = string.split(arg_48_0.value, ";")
	
	if not var_48_0 then
		return 
	end
	
	local var_48_1 = var_48_0[1]
	local var_48_2 = var_48_0[2]
	
	if var_48_2 then
		local var_48_3 = string.split(, ",") or {
			1,
			1
		}
		local var_48_4 = var_48_3[2] + 1
		local var_48_5 = var_48_3[1] * 2 + var_48_4 % 2
		
		var_48_2 = {
			x = var_48_5,
			y = var_48_4
		}
	end
	
	RumbleSystem:spawnUnit(var_48_1, arg_48_1, var_48_2)
end

function RumbleSkill.EffectFunc.SPAWN_ALLY(arg_49_0)
	if not arg_49_0 or not arg_49_0.unit then
		return 
	end
	
	var_0_0(arg_49_0, arg_49_0.unit:getTeam())
end

function RumbleSkill.EffectFunc.SPAWN_ENEMY(arg_50_0)
	if not arg_50_0 or not arg_50_0.unit then
		return 
	end
	
	var_0_0(arg_50_0, arg_50_0.unit:getTeam() % 2 + 1)
end

local function var_0_1(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0 or arg_51_0:isDead() then
		return 
	end
	
	local var_51_0 = RumbleBoard:getCircle(arg_51_0:getPosition(), arg_51_1, true)
	
	return RumbleBoard:getUnits({
		include_hide = true,
		area = var_51_0,
		team = arg_51_2
	})
end

function RumbleSkill.TargetFunc.UNIT_SELF(arg_52_0)
	if not arg_52_0 then
		return 
	end
	
	return {
		arg_52_0.unit
	}
end

function RumbleSkill.TargetFunc.UNIT_TARGET(arg_53_0)
	if not arg_53_0 then
		return 
	end
	
	return {
		arg_53_0.main_target
	}
end

function RumbleSkill.TargetFunc.ENEMY_ALL(arg_54_0)
	if not arg_54_0 then
		return 
	end
	
	if not arg_54_0.unit then
		return 
	end
	
	local var_54_0 = arg_54_0.unit:getTeam()
	
	return RumbleBoard:getUnits({
		include_hide = true,
		team = var_54_0 % 2 + 1
	})
end

function RumbleSkill.TargetFunc.ENEMY_NEAR(arg_55_0)
	if not arg_55_0 then
		return 
	end
	
	if not arg_55_0.unit then
		return 
	end
	
	local var_55_0 = arg_55_0.unit:getTeam()
	
	return var_0_1(arg_55_0.unit, 1, var_55_0 % 2 + 1)
end

function RumbleSkill.TargetFunc.ENEMY_TARGET_NEAR(arg_56_0)
	if not arg_56_0 then
		return 
	end
	
	if not arg_56_0.unit then
		return 
	end
	
	local var_56_0 = arg_56_0.unit:getTeam()
	
	return var_0_1(arg_56_0.main_target, 1, var_56_0 % 2 + 1)
end

function RumbleSkill.TargetFunc.ENEMY_TARGET_CIRCLE(arg_57_0)
	if not arg_57_0 then
		return 
	end
	
	if not arg_57_0.unit then
		return 
	end
	
	local var_57_0 = arg_57_0.unit:getTeam()
	local var_57_1 = var_0_1(arg_57_0.main_target, 1, var_57_0 % 2 + 1) or {}
	
	table.insert(var_57_1, arg_57_0.main_target)
	
	return var_57_1
end

function RumbleSkill.TargetFunc.ALLY_ALL(arg_58_0)
	if not arg_58_0 then
		return 
	end
	
	if not arg_58_0.unit then
		return 
	end
	
	return RumbleBoard:getUnits({
		include_hide = true,
		team = arg_58_0.unit:getTeam()
	})
end

function RumbleSkill.TargetFunc.ALLY_DEAD(arg_59_0)
	local var_59_0 = RumbleBoard:getUnits({
		include_dead = true,
		exclude_creature = true,
		team = arg_59_0.unit:getTeam()
	})
	
	if not var_59_0 then
		return 
	end
	
	local var_59_1 = {}
	
	for iter_59_0, iter_59_1 in ipairs(var_59_0) do
		if iter_59_1:isDead() then
			table.insert(var_59_1, iter_59_1)
		end
	end
	
	return var_59_1
end

function RumbleSkill.TargetFunc.ALLY_NEAR(arg_60_0)
	if not arg_60_0 then
		return 
	end
	
	if not arg_60_0.unit then
		return 
	end
	
	local var_60_0 = arg_60_0.unit:getTeam()
	
	return var_0_1(arg_60_0.unit, 1, var_60_0) or {}
end

function RumbleSkill.TargetFunc.ALLY_NEAR_MINHP(arg_61_0)
	local var_61_0 = RumbleSkill.TargetFunc.ALLY_NEAR(arg_61_0)
	
	if not var_61_0 then
		return 
	end
	
	table.sort(var_61_0, function(arg_62_0, arg_62_1)
		return arg_62_0:getHPRatio() < arg_62_1:getHPRatio()
	end)
	
	return {
		var_61_0[1]
	}
end

function RumbleSkill.TargetFunc.ALLY_NEAR_MINHP_DOUBLE(arg_63_0)
	local var_63_0 = RumbleSkill.TargetFunc.ALLY_NEAR(arg_63_0)
	
	if not var_63_0 then
		return 
	end
	
	table.sort(var_63_0, function(arg_64_0, arg_64_1)
		return arg_64_0:getHPRatio() < arg_64_1:getHPRatio()
	end)
	
	return {
		var_63_0[1],
		var_63_0[2]
	}
end

function RumbleSkill.TargetFunc.ALLY_NEAR_HIGHEST_ATK(arg_65_0)
	local var_65_0 = RumbleSkill.TargetFunc.ALLY_NEAR(arg_65_0)
	
	if not var_65_0 then
		return 
	end
	
	table.sort(var_65_0, function(arg_66_0, arg_66_1)
		return arg_66_0:getStatAttack() > arg_66_1:getStatAttack()
	end)
	
	return {
		var_65_0[1]
	}
end

function RumbleSkill.TargetFunc.ALLY_NEAR_DEBUFF(arg_67_0)
	local var_67_0 = RumbleSkill.TargetFunc.ALLY_NEAR(arg_67_0)
	
	if not var_67_0 then
		return 
	end
	
	local var_67_1 = {}
	
	for iter_67_0 = #var_67_0, 1, -1 do
		local var_67_2 = var_67_0[iter_67_0]:getBuffList()
		
		if var_67_2 and var_67_2:getDebuffCount() >= 1 then
			table.insert(var_67_1, var_67_0[iter_67_0])
		end
	end
	
	return var_67_1
end

function RumbleSkill.TargetFunc.ALLY_NEAR_DEBUFF_LOWHP(arg_68_0)
	local var_68_0 = RumbleSkill.TargetFunc.ALLY_NEAR_DEBUFF(arg_68_0)
	
	if not var_68_0 then
		return 
	end
	
	table.sort(var_68_0, function(arg_69_0, arg_69_1)
		return arg_69_0:getHPRatio() < arg_69_1:getHPRatio()
	end)
	
	return {
		var_68_0[1]
	}
end

function RumbleSkill.TargetFunc.ALLY_CIRCLE(arg_70_0)
	local var_70_0 = RumbleSkill.TargetFunc.ALLY_NEAR(arg_70_0)
	
	if not var_70_0 then
		return 
	end
	
	table.insert(var_70_0, arg_70_0.unit)
	
	return var_70_0
end

function RumbleSkill.TargetFunc.ALLY_CIRCLE_HIGHEST_ATK(arg_71_0)
	local var_71_0 = RumbleSkill.TargetFunc.ALLY_CIRCLE(arg_71_0)
	
	if not var_71_0 then
		return 
	end
	
	table.sort(var_71_0, function(arg_72_0, arg_72_1)
		return arg_72_0:getStatAttack() > arg_72_1:getStatAttack()
	end)
	
	return {
		var_71_0[1]
	}
end
