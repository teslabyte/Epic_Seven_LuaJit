RumbleBuffList = ClassDef()

function RumbleBuffList.constructor(arg_1_0, arg_1_1)
	arg_1_0.list = {}
	arg_1_0.owner = arg_1_1
end

function RumbleBuffList.add(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.list then
		return 
	end
	
	local var_2_0 = {
		shield = RumbleShield,
		blaze = RumbleBlaze,
		endure = RumbleEndure,
		stun = RumbleStun
	}
	
	local function var_2_1(arg_3_0)
		if arg_2_0:isImmuned() and arg_3_0:getType() == "debuff" then
			return false
		end
		
		if arg_2_0:isBuffBlocked() and arg_3_0:getType() == "buff" then
			return false
		end
		
		return true
	end
	
	local var_2_2 = arg_2_0:getBuff(arg_2_1)
	
	if var_2_2 and not var_2_2:isAllowDuplicate() then
		if not var_2_1(var_2_2) then
			return 
		end
		
		var_2_2:stackBuff(arg_2_2)
	else
		arg_2_2 = arg_2_2 or {}
		arg_2_2.id = arg_2_1
		arg_2_2.owner = arg_2_0.owner
		
		local var_2_3 = var_2_0[arg_2_1] and var_2_0[arg_2_1](arg_2_2) or RumbleBuff(arg_2_2)
		
		if not var_2_3 then
			return 
		end
		
		if not var_2_1(var_2_3) then
			return 
		end
		
		table.insert(arg_2_0.list, var_2_3)
		var_2_3:playEffect()
	end
	
	arg_2_0:onUpdateList()
end

function RumbleBuffList.remove(arg_4_0, arg_4_1)
	if not arg_4_0.list then
		return 
	end
	
	local var_4_0 = table.remove(arg_4_0.list, arg_4_1)
	
	if var_4_0 then
		var_4_0:removeEffect()
	end
end

function RumbleBuffList.removeById(arg_5_0, arg_5_1)
	if not arg_5_0.list then
		return 
	end
	
	for iter_5_0, iter_5_1 in ipairs(arg_5_0.list) do
		if iter_5_1.id == arg_5_1 then
			arg_5_0:remove(iter_5_0)
			arg_5_0:onUpdateList()
			
			return true
		end
	end
end

function RumbleBuffList.removeByType(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_0.list then
		return 
	end
	
	arg_6_2 = arg_6_2 or 9999
	
	local var_6_0 = false
	
	for iter_6_0 = #arg_6_0.list, 1, -1 do
		local var_6_1 = arg_6_0.list[iter_6_0]
		
		if var_6_1 and var_6_1:getType() == arg_6_1 then
			arg_6_0:remove(iter_6_0)
			
			var_6_0 = true
			arg_6_2 = arg_6_2 - 1
			
			if arg_6_2 <= 0 then
				break
			end
		end
	end
	
	if var_6_0 then
		arg_6_0:onUpdateList()
	end
end

function RumbleBuffList.isExist(arg_7_0, arg_7_1)
	return arg_7_0:getBuff(arg_7_1) ~= nil
end

function RumbleBuffList.isExistHide(arg_8_0)
	return arg_8_0:isExist("hide")
end

function RumbleBuffList.isImmuned(arg_9_0)
	return arg_9_0:isExist("immune")
end

function RumbleBuffList.isBuffBlocked(arg_10_0)
	return arg_10_0:isExist("buffblock")
end

function RumbleBuffList.isInvincible(arg_11_0)
	return arg_11_0:isExist("invincible")
end

function RumbleBuffList.getEndure(arg_12_0)
	return arg_12_0:getBuff("endure")
end

function RumbleBuffList.getShield(arg_13_0)
	return arg_13_0:getBuff("shield")
end

function RumbleBuffList.getBuff(arg_14_0, arg_14_1)
	if not arg_14_0.list then
		return 
	end
	
	for iter_14_0, iter_14_1 in ipairs(arg_14_0.list) do
		if iter_14_1.id == arg_14_1 then
			return iter_14_1
		end
	end
end

function RumbleBuffList.update(arg_15_0, arg_15_1)
	if not arg_15_0.list then
		return 
	end
	
	local var_15_0 = false
	
	for iter_15_0 = #arg_15_0.list, 1, -1 do
		local var_15_1 = arg_15_0.list[iter_15_0]
		
		if var_15_1 then
			var_15_1:update(arg_15_1)
			
			if not var_15_1:isValid() then
				arg_15_0:remove(iter_15_0)
				
				var_15_0 = true
			end
		end
	end
	
	if var_15_0 then
		arg_15_0:onUpdateList()
	end
end

local function var_0_0(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0 then
		return 
	end
	
	for iter_16_0 = #arg_16_0, 1, -1 do
		local var_16_0 = arg_16_0[iter_16_0]
		
		if var_16_0 and var_16_0:isValid() then
			var_16_0:procEvent(arg_16_1, arg_16_2)
		end
	end
end

function RumbleBuffList.onKill(arg_17_0)
	var_0_0(arg_17_0.list, "kill")
end

function RumbleBuffList.onDead(arg_18_0)
	var_0_0(arg_18_0.list, "dead")
end

function RumbleBuffList.onBattleStart(arg_19_0)
	var_0_0(arg_19_0.list, "start")
end

function RumbleBuffList.onBattleEnd(arg_20_0)
	var_0_0(arg_20_0.list, "end")
end

function RumbleBuffList.onPreBattle(arg_21_0)
	var_0_0(arg_21_0.list, "prepare")
end

function RumbleBuffList.onDamage(arg_22_0, arg_22_1)
	var_0_0(arg_22_0.list, "damage")
end

function RumbleBuffList.onHit(arg_23_0, arg_23_1)
	if arg_23_1.extra_dmg then
		return 
	end
	
	local var_23_0 = {
		extra_dmg = true,
		caster = arg_23_0.owner,
		target = arg_23_1.caster,
		damage = arg_23_1.damage
	}
	
	var_0_0(arg_23_0.list, "hit", var_23_0)
end

function RumbleBuffList.onAttack(arg_24_0, arg_24_1)
	var_0_0(arg_24_0.list, "attack", arg_24_1)
	
	if arg_24_1.critical then
		var_0_0(arg_24_0.list, "critical", arg_24_1)
	end
end

function RumbleBuffList.clear(arg_25_0)
	if not arg_25_0.list then
		return 
	end
	
	for iter_25_0 = #arg_25_0.list, 1, -1 do
		arg_25_0:remove(iter_25_0)
	end
	
	arg_25_0:onUpdateList()
end

function RumbleBuffList.onUpdateList(arg_26_0)
	arg_26_0:updateBonusStats()
	
	if arg_26_0.owner then
		arg_26_0.owner:onUpdateBuff()
	end
end

function RumbleBuffList.updateBonusStats(arg_27_0)
	if not arg_27_0.list then
		return 
	end
	
	local var_27_0 = {}
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.list) do
		local var_27_1 = iter_27_1:getBonusStat() or {}
		
		for iter_27_2, iter_27_3 in pairs(var_27_1) do
			var_27_0[iter_27_2] = (var_27_0[iter_27_2] or 0) + iter_27_3
		end
	end
	
	arg_27_0.bonus_stats = var_27_0
end

function RumbleBuffList.getBonusStats(arg_28_0)
	return arg_28_0.bonus_stats
end

function RumbleBuffList.getBonusStat(arg_29_0, arg_29_1)
	return to_n(arg_29_0.bonus_stats and arg_29_0.bonus_stats[arg_29_1])
end

function RumbleBuffList.getShowBuffList(arg_30_0)
	if not arg_30_0.list then
		return 
	end
	
	local var_30_0 = {}
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.list) do
		if iter_30_1:getIcon() then
			table.insert(var_30_0, iter_30_1)
		end
	end
	
	return var_30_0
end

function RumbleBuffList.getTypeCount(arg_31_0, arg_31_1)
	if not arg_31_0.list then
		return 
	end
	
	local var_31_0 = 0
	
	for iter_31_0, iter_31_1 in pairs(arg_31_0.list) do
		if iter_31_1:getType() == arg_31_1 then
			var_31_0 = var_31_0 + 1
		end
	end
	
	return var_31_0
end

function RumbleBuffList.getBuffCount(arg_32_0)
	return arg_32_0:getTypeCount("buff")
end

function RumbleBuffList.getDebuffCount(arg_33_0)
	return arg_33_0:getTypeCount("debuff")
end

function RumbleBuffList.reduceBuffTime(arg_34_0, arg_34_1)
	if not arg_34_0.list then
		return 
	end
	
	for iter_34_0, iter_34_1 in ipairs(arg_34_0.list) do
		if iter_34_1:getType() == "buff" then
			iter_34_1:update(arg_34_1)
			
			if not iter_34_1:isValid() then
				table.remove(arg_34_0.list, iter_34_0)
			end
		end
	end
	
	arg_34_0:onUpdateList()
end

RumbleBuff = ClassDef()

function RumbleBuff.constructor(arg_35_0, arg_35_1)
	if not arg_35_1 then
		return 
	end
	
	arg_35_0.id = arg_35_1.id
	arg_35_0.owner = arg_35_1.owner
	arg_35_0.caster = arg_35_1.caster
	arg_35_0.duration = arg_35_1.duration
	arg_35_0.elapsed_time = 0
	arg_35_0.stack = 1
	arg_35_0.db = arg_35_0:loadDB()
end

function RumbleBuff.loadDB(arg_36_0)
	return (DBT("rumble_cs", arg_36_0.id, {
		"cs_type",
		"cs_icon",
		"stack",
		"remove_timing",
		"fx",
		"fx_bone",
		"allow_duplicate",
		"stat_1",
		"value_1",
		"stat_2",
		"value_2",
		"con_1",
		"con_1_value",
		"con_2",
		"con_2_value",
		"skill_1_id",
		"skill_1_timing",
		"skill_2_id",
		"skill_2_timing"
	}))
end

function RumbleBuff.playEffect(arg_37_0)
	if not arg_37_0.db or not arg_37_0.db.fx then
		return 
	end
	
	local var_37_0 = arg_37_0:getOwner()
	
	if not var_37_0 or var_37_0:isDead() then
		return 
	end
	
	var_37_0:playBuffEffect(arg_37_0.db.fx, arg_37_0.db.fx_bone)
end

function RumbleBuff.removeEffect(arg_38_0)
	if not arg_38_0.db or not arg_38_0.db.fx then
		return 
	end
	
	local var_38_0 = arg_38_0:getOwner()
	
	if not var_38_0 then
		return 
	end
	
	var_38_0:removeBuffEffect(arg_38_0.db.fx)
end

function RumbleBuff.update(arg_39_0, arg_39_1)
	arg_39_0.elapsed_time = arg_39_0.elapsed_time + arg_39_1
end

function RumbleBuff.stackBuff(arg_40_0, arg_40_1)
	if not arg_40_1 then
		return 
	end
	
	local var_40_0 = to_n(arg_40_1.duration)
	
	if var_40_0 >= arg_40_0:getTimeRemain() then
		arg_40_0.duration = var_40_0
		arg_40_0.elapsed_time = 0
	end
	
	arg_40_0.stack = math.min(arg_40_0.stack + 1, arg_40_0:getStackLimit())
end

function RumbleBuff.procEvent(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_0.db then
		return 
	end
	
	if not arg_41_0:checkCondition() then
		return 
	end
	
	for iter_41_0 = 1, 2 do
		local var_41_0 = arg_41_0.db["skill_" .. iter_41_0 .. "_id"]
		local var_41_1 = arg_41_0.db["skill_" .. iter_41_0 .. "_timing"]
		
		if not var_41_0 then
			break
		end
		
		if var_41_1 == arg_41_1 then
			RumbleSkill(arg_41_0.owner, var_41_0):fire(arg_41_2)
		end
	end
	
	if arg_41_0.db.remove_timing == arg_41_1 then
		arg_41_0:invalidate()
	end
end

function RumbleBuff.getTimeRemain(arg_42_0)
	if not arg_42_0.duration then
		return 9999
	end
	
	return arg_42_0.duration - arg_42_0.elapsed_time
end

function RumbleBuff.isValid(arg_43_0)
	if arg_43_0.expired then
		return false
	end
	
	if arg_43_0:getTimeRemain() <= 0 then
		return false
	end
	
	return true
end

function RumbleBuff.invalidate(arg_44_0)
	arg_44_0.expired = true
end

function RumbleBuff.getBonusStat(arg_45_0)
	if not arg_45_0.db then
		return 
	end
	
	if not arg_45_0:checkCondition() then
		return 
	end
	
	local var_45_0 = {}
	
	for iter_45_0 = 1, 3 do
		local var_45_1 = arg_45_0.db["stat_" .. iter_45_0]
		local var_45_2 = arg_45_0.db["value_" .. iter_45_0]
		
		if not var_45_1 or not var_45_2 then
			break
		end
		
		var_45_0[var_45_1] = var_45_2 * arg_45_0.stack
	end
	
	return var_45_0
end

function RumbleBuff.getOwner(arg_46_0)
	return arg_46_0.owner
end

function RumbleBuff.getIcon(arg_47_0)
	return arg_47_0.db and arg_47_0.db.cs_icon
end

function RumbleBuff.getStack(arg_48_0)
	return arg_48_0.stack
end

function RumbleBuff.getStackLimit(arg_49_0)
	return arg_49_0.db and arg_49_0.db.stack or 1
end

function RumbleBuff.isMaxStack(arg_50_0)
	return arg_50_0:getStack() >= arg_50_0:getStackLimit()
end

function RumbleBuff.getType(arg_51_0)
	return arg_51_0.db and arg_51_0.db.cs_type or "hidden"
end

function RumbleBuff.isAllowDuplicate(arg_52_0)
	return arg_52_0.db and arg_52_0.db.allow_duplicate
end

function RumbleBuff.checkCondition(arg_53_0)
	local var_53_0 = arg_53_0:getOwner()
	
	if not var_53_0 then
		return false
	end
	
	for iter_53_0 = 1, 3 do
		local var_53_1 = arg_53_0.db["con_" .. iter_53_0]
		local var_53_2 = arg_53_0.db["con_" .. iter_53_0 .. "_value"]
		
		if not var_53_1 then
			break
		end
		
		if not var_53_0:checkCondition(var_53_1, var_53_2) then
			return false
		end
	end
	
	return true
end

RumbleShield = ClassDef(RumbleBuff)

function RumbleShield.constructor(arg_54_0, arg_54_1)
	arg_54_0.shield = math.floor(to_n(arg_54_1.shield))
end

function RumbleShield.isValid(arg_55_0)
	if arg_55_0.expired then
		return false
	end
	
	if arg_55_0:getTimeRemain() <= 0 then
		return false
	end
	
	if arg_55_0:getShieldAmount() <= 0 then
		return false
	end
	
	return true
end

function RumbleShield.damage(arg_56_0, arg_56_1)
	arg_56_0.shield = arg_56_0.shield - arg_56_1
end

function RumbleShield.getShieldAmount(arg_57_0)
	return to_n(arg_57_0.shield)
end

function RumbleShield.stackBuff(arg_58_0, arg_58_1)
	if not arg_58_1 then
		return 
	end
	
	local var_58_0 = to_n(arg_58_1.shield)
	
	arg_58_0.shield = math.max(arg_58_0.shield, var_58_0)
	
	local var_58_1 = to_n(arg_58_1.duration)
	
	if var_58_1 >= arg_58_0:getTimeRemain() then
		arg_58_0.duration = var_58_1
		arg_58_0.elapsed_time = 0
	end
end

RumbleBlaze = ClassDef(RumbleBuff)

function RumbleBlaze.constructor(arg_59_0, arg_59_1)
	if not arg_59_1 or not arg_59_1.caster then
		return 
	end
	
	arg_59_0.pow = arg_59_1.caster:getStatAttack() * 0.3
	arg_59_0.blaze_tick = 0
end

function RumbleBlaze.update(arg_60_0, arg_60_1)
	if not arg_60_0.owner or arg_60_0.owner:isDead() then
		return 
	end
	
	arg_60_0.elapsed_time = arg_60_0.elapsed_time + arg_60_1
	
	if arg_60_0.elapsed_time >= (arg_60_0.blaze_tick + 1) * 1000 then
		arg_60_0.blaze_tick = arg_60_0.blaze_tick + 1
		
		arg_60_0.owner:damage({
			extra_dmg = true,
			caster = arg_60_0.caster,
			damage = arg_60_0.pow
		})
		arg_60_0.owner:showInfoText()
		arg_60_0:playEffect()
	end
end

RumbleEndure = ClassDef(RumbleBuff)

function RumbleEndure.constructor(arg_61_0, arg_61_1)
	if not arg_61_1 then
		return 
	end
	
	arg_61_0.stack = to_n(arg_61_1.stack) or 1
end

function RumbleEndure.isValid(arg_62_0)
	if arg_62_0.expired then
		return false
	end
	
	if arg_62_0.stack <= 0 then
		return false
	end
	
	return true
end

function RumbleEndure.damage(arg_63_0, arg_63_1)
	arg_63_0.stack = arg_63_0.stack - 1
end

function RumbleEndure.getIcon(arg_64_0)
	if not arg_64_0.db then
		return 
	end
	
	if not arg_64_0.db.cs_icon then
		return 
	end
	
	if not arg_64_0:isValid() then
		return 
	end
	
	return arg_64_0.db.cs_icon .. "_" .. arg_64_0.stack
end

RumbleStun = ClassDef(RumbleBuff)

function RumbleStun.constructor(arg_65_0, arg_65_1)
end

function RumbleStun.playEffect(arg_66_0)
	local var_66_0 = arg_66_0:getOwner()
	
	if not var_66_0 or var_66_0:isDead() then
		return 
	end
	
	var_66_0:stun()
	
	if arg_66_0.db then
		var_66_0:playBuffEffect(arg_66_0.db.fx, arg_66_0.db.fx_bone)
	end
end

function RumbleStun.removeEffect(arg_67_0)
	local var_67_0 = arg_67_0:getOwner()
	
	if not var_67_0 then
		return 
	end
	
	var_67_0:recover()
	
	if arg_67_0.db then
		var_67_0:removeBuffEffect(arg_67_0.db.fx)
	end
end
