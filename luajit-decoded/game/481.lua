SkillFactory = SkillFactory or {}

function SkillFactory.create(arg_1_0, arg_1_1)
	local var_1_0
	local var_1_1 = DB("skill", arg_1_0, {
		"skill_type"
	})
	
	if var_1_1 == "resource" then
		var_1_0 = ResourceSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "random" then
		var_1_0 = RandomSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "self_cs" then
		var_1_0 = CasterHaveCSSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "enemy_cs" then
		var_1_0 = EnemyHaveCSSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "ally_cs" then
		var_1_0 = AllyHaveCSSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "self_hp" then
		var_1_0 = CasterHpSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "self_debuff" then
		var_1_0 = CasterDebuffCountSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "self_buff" then
		var_1_0 = CasterBuffCountSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "turn_self_buff" then
		var_1_0 = CasterOwnTurnBuffCountSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "turn_self" then
		var_1_0 = CasterOwnTurnSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "turn_self_random" then
		var_1_0 = CasterOwnTurnRandomSkill(arg_1_1, arg_1_0)
	elseif var_1_1 == "turn_self_cs" then
		var_1_0 = CasterOwnTurnHaveCSIDSkill(arg_1_1, arg_1_0)
	else
		var_1_0 = BaseSkill(arg_1_1, arg_1_0)
	end
	
	var_1_0:loadDB()
	
	return var_1_0
end

SkillBundle = ClassDef()

function SkillBundle.constructor(arg_2_0, arg_2_1)
	arg_2_0._unit = arg_2_1
	arg_2_0._slot = {}
end

function SkillBundle.load(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._slot[arg_3_1] = SkillFactory.create(arg_3_2, arg_3_0._unit)
end

function SkillBundle.unload(arg_4_0, arg_4_1)
	arg_4_0._slot[arg_4_1] = nil
end

function SkillBundle.clone(arg_5_0, arg_5_1)
	local var_5_0 = SkillBundle(arg_5_1)
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0._slot) do
		var_5_0:load(iter_5_0, iter_5_1._skill_id)
	end
	
	return var_5_0
end

function SkillBundle.indexOf(arg_6_0, arg_6_1)
	for iter_6_0, iter_6_1 in pairs(arg_6_0._slot) do
		if type(arg_6_1) == "table" then
			if arg_6_1 == iter_6_1 then
				return iter_6_0
			end
		else
			local var_6_0 = iter_6_1:getSkillSet2SkillId()
			
			if var_6_0 then
				if table.isInclude(var_6_0, arg_6_1) then
					return iter_6_0
				end
			elseif arg_6_1 == iter_6_1:getSkillId() then
				return iter_6_0
			end
		end
	end
end

function SkillBundle.bySkill(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:indexOf(arg_7_1)
	
	if not var_7_0 then
		return 
	end
	
	return arg_7_0:slot(var_7_0), var_7_0
end

function SkillBundle.get(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:indexOf(arg_8_1)
	
	if not var_8_0 then
		return 
	end
	
	return arg_8_0:slot(var_8_0), var_8_0
end

function SkillBundle.slot(arg_9_0, arg_9_1)
	if not arg_9_1 or arg_9_1 > table.count(arg_9_0._slot) or arg_9_0._slot[arg_9_1] == nil then
		return BaseSkill(nil, nil)
	end
	
	return arg_9_0._slot[arg_9_1]
end

function SkillBundle.initTurn(arg_10_0)
	for iter_10_0, iter_10_1 in pairs(arg_10_0._slot) do
		iter_10_1:initTurn()
	end
end

function SkillBundle.toSkills(arg_11_0)
	local var_11_0 = {}
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0._slot) do
		if iter_11_1:assigned() then
			table.insert(var_11_0, iter_11_0, iter_11_1)
		end
	end
	
	return var_11_0
end

function SkillBundle.toSkillIds(arg_12_0)
	local var_12_0 = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0._slot) do
		if iter_12_1:assigned() then
			table.insert(var_12_0, iter_12_0, iter_12_1:getSkillId())
		end
	end
	
	return var_12_0
end

function SkillBundle.select(arg_13_0, arg_13_1)
	local var_13_0 = SkillBundle(arg_13_0._unit)
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0._slot) do
		if iter_13_1:assigned() and arg_13_1(iter_13_0, iter_13_1) then
			table.insert(var_13_0._slot, iter_13_0, iter_13_1)
		end
	end
	
	return var_13_0
end

function SkillBundle.selectAvailable(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or 3
	
	return arg_14_0:select(function(arg_15_0, arg_15_1)
		if arg_15_0 <= arg_14_1 then
			return true
		end
	end)
end

function SkillBundle.selectActive(arg_16_0)
	return arg_16_0:select(function(arg_17_0, arg_17_1)
		if not arg_17_1:getPassive() then
			return true
		end
	end)
end

function SkillBundle.getSoulSkillId(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0._slot) do
		local var_18_0, var_18_1 = iter_18_1:getSoulBurnSkill()
		
		if var_18_0 then
			return var_18_0
		end
	end
end

BaseSkill = ClassDef()

function BaseSkill.constructor(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._unit = arg_19_1
	arg_19_0._skill_id = arg_19_2
end

function BaseSkill.loadDB(arg_20_0)
end

function BaseSkill.initTurn(arg_21_0)
end

function BaseSkill.assigned(arg_22_0)
	return arg_22_0._skill_id ~= nil
end

function BaseSkill.getOwner(arg_23_0)
	return arg_23_0._unit
end

function BaseSkill.getOriginSkillId(arg_24_0)
	return arg_24_0._skill_id
end

function BaseSkill.getSkillId(arg_25_0)
	return arg_25_0._skill_id
end

function BaseSkill.getSkillIdForSkillLevel(arg_26_0)
	return arg_26_0._skill_id
end

function BaseSkill.getSkillName(arg_27_0)
	return DB("skill", arg_27_0:getSkillId(), "name") or ""
end

function BaseSkill.getSkillNameForToolTip(arg_28_0)
	return arg_28_0:getSkillName()
end

function BaseSkill.getSkillNameForPlay(arg_29_0)
	return arg_29_0:getSkillName()
end

function BaseSkill.getSkillIcon(arg_30_0)
	return DB("skill", arg_30_0:getSkillId(), "sk_icon")
end

function BaseSkill.getTarget(arg_31_0)
	return (DB("skill", arg_31_0:getSkillId(), "target"))
end

function BaseSkill.getPointGain(arg_32_0)
	return arg_32_0._unit:getSkillDB(arg_32_0:getSkillId(), "point_gain")
end

function BaseSkill.getSoulGain(arg_33_0)
	return arg_33_0._unit:getSkillDB(arg_33_0:getSkillId(), "soul_gain")
end

function BaseSkill.getPassive(arg_34_0)
	return arg_34_0._unit:getSkillDB(arg_34_0:getSkillId(), "sk_passive")
end

function BaseSkill.getPassiveBlock(arg_35_0)
end

function BaseSkill.getBlockSkillId(arg_36_0)
	if arg_36_0._unit:isPassiveBlock() then
		local var_36_0 = arg_36_0._unit:getSkillDB(arg_36_0:getOriginSkillId(), "skillset_passiveblock")
		
		if var_36_0 then
			return var_36_0
		end
	end
	
	return nil
end

function BaseSkill.getSoulBurnSkill(arg_37_0)
	local var_37_0 = arg_37_0._unit:getSkillDB(arg_37_0:getSkillId(), "soulburn_skill")
	
	if var_37_0 then
		return var_37_0, DB("skill", var_37_0, {
			"soul_req",
			"sk_description"
		})
	end
end

function BaseSkill.getPointRequire(arg_38_0)
	return arg_38_0._unit:getSkillDB(arg_38_0:getSkillId(), "point_require")
end

function BaseSkill.getPointRate(arg_39_0)
	return arg_39_0._unit:getSkillDB(arg_39_0:getSkillId(), "point_rate")
end

function BaseSkill.getPointMax(arg_40_0)
	return arg_40_0._unit:getSkillDB(arg_40_0:getSkillId(), "point_max")
end

function BaseSkill.getTurnCool(arg_41_0)
	return arg_41_0._unit:getSkillDB(arg_41_0:getSkillId(), "turn_cool")
end

function BaseSkill.getDealDamage(arg_42_0)
	return DB("skill", arg_42_0:getSkillId(), {
		"deal_damage"
	})
end

function BaseSkill.getPassive(arg_43_0)
	return arg_43_0._unit:getSkillDB(arg_43_0:getSkillId(), {
		"sk_passive"
	})
end

function BaseSkill.getShow(arg_44_0)
	return arg_44_0._unit:getSkillDB(arg_44_0:getSkillId(), {
		"sk_show"
	})
end

function BaseSkill.getSkillSet(arg_45_0)
	local var_45_0 = DB("skill", arg_45_0._skill_id, {
		"skillset"
	})
	
	if not var_45_0 then
		return nil
	end
	
	return (string.split(var_45_0, ","))
end

function BaseSkill.getSkillSet2SkillId(arg_46_0)
	local var_46_0 = arg_46_0:getSkillSet()
	
	if not var_46_0 then
		return nil
	end
	
	local var_46_1 = {}
	
	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		local var_46_2 = DB("skillset", string.trim(iter_46_1), {
			"id"
		})
		
		table.insert(var_46_1, var_46_2)
	end
	
	return var_46_1
end

function BaseSkill.getSlotIndex(arg_47_0)
	return arg_47_0._unit:getSkillBundle():indexOf(arg_47_0:getSkillId())
end

function BaseSkill.checkUseSkill(arg_48_0)
	if not arg_48_0:assigned() then
		return false
	end
	
	local var_48_0 = arg_48_0._unit:isSkillSilence() and table.find({
		2,
		3
	}, arg_48_0:getSlotIndex())
	
	if var_48_0 then
		return false, nil, nil, true
	end
	
	if arg_48_0._unit:getProvoker() and arg_48_0:getSlotIndex() ~= 1 then
		return false
	end
	
	local var_48_1 = arg_48_0:getTurnCool()
	local var_48_2 = arg_48_0:getPointRequire()
	
	if not arg_48_0._unit:isSkillEnabled(arg_48_0._skill_id) then
		Log.d("skill_check", "조디악 스피어에서 아직 개방 안된 스킬", arg_48_0._skill_id)
		
		return false
	end
	
	var_48_2 = var_48_2 or 0
	
	local var_48_3 = arg_48_0._unit:getSkillCool(arg_48_0._skill_id) == 0
	
	if arg_48_0._unit:getSPName() ~= "none" then
		var_48_3 = var_48_3 and var_48_2 <= arg_48_0._unit:getSP()
	end
	
	local var_48_4 = #arg_48_0._unit.logic:getTargetCandidates(arg_48_0._skill_id, arg_48_0._unit)
	
	if var_48_4 == 0 then
		var_48_3 = false
	end
	
	local var_48_5 = arg_48_0._unit:getSkillCool(arg_48_0._skill_id)
	local var_48_6 = var_48_2 - arg_48_0._unit:getSP()
	
	if DEBUG.TEST_SKILL or DEBUG.DEBUG_SKILL or arg_48_0._unit.logic:isSkillPreview() then
		return true, var_48_5, var_48_6, var_48_0
	end
	
	return var_48_3, var_48_5, var_48_6, var_48_0, var_48_4
end

function BaseSkill.isTargetIn(arg_49_0, arg_49_1)
	local var_49_0 = string.split(arg_49_1, ",")
	
	table.convert(var_49_0, function(arg_50_0, arg_50_1)
		return string.trim(arg_50_1)
	end)
	
	local var_49_1 = tostring(arg_49_0:getTarget())
	
	return table.find(var_49_0, var_49_1)
end

LinkSkill = ClassDef(BaseSkill)

function LinkSkill.constructor(arg_51_0, arg_51_1, arg_51_2)
	arg_51_0._skill_set = {}
end

function LinkSkill.loadDB(arg_52_0)
	BaseSkill.loadDB(arg_52_0)
	
	local var_52_0 = DB("skill", arg_52_0._skill_id, {
		"skillset"
	})
	local var_52_1 = string.split(var_52_0, ",")
	
	for iter_52_0, iter_52_1 in ipairs(var_52_1) do
		local var_52_2, var_52_3 = DB("skillset", string.trim(iter_52_1), {
			"id",
			"set_value"
		})
		
		arg_52_0._skill_set[iter_52_0] = {}
		arg_52_0._skill_set[iter_52_0].set_id = iter_52_0
		arg_52_0._skill_set[iter_52_0].set_value = var_52_3
		arg_52_0._skill_set[iter_52_0].id = var_52_2
		arg_52_0._skill_set[iter_52_0].skill = SkillFactory.create(var_52_2, arg_52_0._unit)
	end
end

function LinkSkill.getLinkSkillId(arg_53_0)
	Log.e("skill", "LinkSkill의 child class는 getLinkSkillId()를 구현해야 합니다.")
	
	return nil
end

function LinkSkill.getSkillId(arg_54_0)
	return arg_54_0:getBlockSkillId() or arg_54_0:getLinkSkillId()
end

function LinkSkill.getSkillIdForSkillLevel(arg_55_0)
	return arg_55_0:getOriginSkillId()
end

function LinkSkill.getSkillNameForToolTip(arg_56_0)
	return DB("skill", arg_56_0:getOriginSkillId(), {
		"name"
	}) or ""
end

function LinkSkill.getTurnCool(arg_57_0)
	return arg_57_0._unit:getSkillDB(arg_57_0:getOriginSkillId(), {
		"turn_cool"
	})
end

function LinkSkill.checkUseSkill(arg_58_0)
	if not arg_58_0:assigned() then
		return false
	end
	
	if not arg_58_0:getLinkSkillId() then
		return false
	end
	
	return BaseSkill.checkUseSkill(arg_58_0)
end

function LinkSkill.getSkillValue(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0._skill_set[arg_59_1]
	local var_59_1 = var_59_0.set_value
	
	if arg_59_0._unit.states:findByEff("CSP_SET_VALUE_CHANGE") then
		local var_59_2 = arg_59_0._unit.states:findAllEffValues("CSP_SET_VALUE_CHANGE")
		
		for iter_59_0, iter_59_1 in pairs(var_59_2) do
			local var_59_3 = totable(iter_59_1)
			
			if var_59_3.id == var_59_0.id then
				return var_59_3.set_value
			end
		end
	end
	
	return var_59_1
end

ResourceSkill = ClassDef(LinkSkill)

function ResourceSkill.constructor(arg_60_0, arg_60_1, arg_60_2)
end

function ResourceSkill._getSkillSetByResource(arg_61_0, arg_61_1)
	local var_61_0
	
	for iter_61_0, iter_61_1 in ipairs(arg_61_0._skill_set) do
		local var_61_1 = arg_61_0._skill_set[iter_61_0].set_value
		
		if string.find(var_61_1, ",") == nil then
			if tonumber(var_61_1) == arg_61_1 then
				var_61_0 = iter_61_1
				
				break
			end
		else
			local var_61_2 = totable(var_61_1, "=")
			
			if arg_61_1 >= tonumber(var_61_2.min) and arg_61_1 <= tonumber(var_61_2.max) then
				var_61_0 = iter_61_1
				
				break
			end
		end
	end
	
	return var_61_0
end

function ResourceSkill.getLinkSkillId(arg_62_0)
	local var_62_0 = tonumber(arg_62_0._unit:getSP()) or 0
	local var_62_1 = arg_62_0:_getSkillSetByResource(var_62_0)
	
	if not var_62_1 then
		Log.e("skill", string.format("ResourceSkill : 조건에 맞는 연결스킬이 없음!!! skill_id : [%s], resource : [%d]", arg_62_0:getOriginSkillId(), var_62_0))
	end
	
	return var_62_1 and var_62_1.skill:getSkillId()
end

function ResourceSkill.checkUseSkill(arg_63_0)
	if not arg_63_0:assigned() then
		return false
	end
	
	if arg_63_0._unit:getSPName() ~= "none" and (arg_63_0._unit:getSkillDB(arg_63_0:getOriginSkillId(), {
		"point_require"
	}) or 0) > arg_63_0._unit:getSP() then
		return false
	end
	
	return LinkSkill.checkUseSkill(arg_63_0)
end

RandomSkill = ClassDef(LinkSkill)

function RandomSkill.constructor(arg_64_0, arg_64_1, arg_64_2)
	arg_64_0._rand_value = 1
end

function RandomSkill.initTurn(arg_65_0)
	arg_65_0._rand_value = arg_65_0._unit.logic.random:get(1, 100) / 100
end

function RandomSkill._getSkillSetByRandom(arg_66_0, arg_66_1)
	local var_66_0
	local var_66_1 = 0
	
	for iter_66_0, iter_66_1 in ipairs(arg_66_0._skill_set) do
		var_66_1 = var_66_1 + tonumber(arg_66_0:getSkillValue(iter_66_0))
		
		if arg_66_1 <= var_66_1 then
			var_66_0 = iter_66_1
			
			break
		end
	end
	
	return var_66_0
end

function RandomSkill.getLinkSkillId(arg_67_0)
	local var_67_0 = arg_67_0._rand_value
	local var_67_1 = arg_67_0:_getSkillSetByRandom(var_67_0)
	
	if not var_67_1 then
		Log.e("skill", string.format("RandomSkill : 조건에 맞는 연결스킬이 없음!!! skill_id : [%s], random : [%f]", arg_67_0:getOriginSkillId(), var_67_0))
	end
	
	return var_67_1 and var_67_1.skill:getSkillId()
end

CasterHaveCSSkill = ClassDef(LinkSkill)

function CasterHaveCSSkill.constructor(arg_68_0, arg_68_1, arg_68_2)
end

function CasterHaveCSSkill._getSkillSetByCS(arg_69_0)
	local var_69_0
	
	for iter_69_0, iter_69_1 in ipairs(arg_69_0._skill_set) do
		local var_69_1 = arg_69_0._skill_set[iter_69_0].set_value
		
		if var_69_1 then
			local var_69_2 = totable(var_69_1, "=")
			
			if var_69_2.type then
				local var_69_3 = false
				
				if var_69_2.type == "csid" then
					var_69_3 = arg_69_0._unit:checkState(var_69_2.id)
				elseif var_69_2.type == "csgroup" then
					var_69_3 = arg_69_0._unit:checkStateGroup(var_69_2.id)
				end
				
				if var_69_3 then
					var_69_0 = iter_69_1
					
					break
				end
			elseif arg_69_0._unit:checkState(var_69_1) then
				var_69_0 = iter_69_1
				
				break
			end
		else
			var_69_0 = iter_69_1
		end
	end
	
	return var_69_0
end

function CasterHaveCSSkill.getLinkSkillId(arg_70_0)
	local var_70_0 = arg_70_0:_getSkillSetByCS()
	
	if not var_70_0 then
		Log.e("skill", string.format("CasterHaveCSSkill : 조건에 맞는 연결스킬이 없음!!! skill_id : [%s]", arg_70_0:getOriginSkillId()))
	end
	
	return var_70_0 and var_70_0.skill:getSkillId()
end

EnemyHaveCSSkill = ClassDef(LinkSkill)

function EnemyHaveCSSkill.constructor(arg_71_0, arg_71_1, arg_71_2)
end

function EnemyHaveCSSkill.initTurn(arg_72_0)
end

function EnemyHaveCSSkill._getSkillSetByCS(arg_73_0)
	local var_73_0 = {}
	
	if arg_73_0._unit.logic then
		var_73_0 = arg_73_0._unit.logic.enemies
		
		if arg_73_0._unit.inst.ally == ENEMY then
			var_73_0 = arg_73_0._unit.logic.friends
		end
	end
	
	local var_73_1
	
	for iter_73_0, iter_73_1 in ipairs(arg_73_0._skill_set) do
		local var_73_2 = arg_73_0._skill_set[iter_73_0].set_value
		
		if var_73_2 then
			local var_73_3 = false
			local var_73_4
			local var_73_5 = totable(var_73_2, "=")
			local var_73_6
			
			if var_73_5.type then
				if var_73_5.type == "csid" then
					var_73_4 = UNIT.checkState
				elseif var_73_5.type == "csgroup" then
					var_73_4 = UNIT.checkStateGroup
				end
				
				var_73_6 = var_73_5.id
			else
				var_73_4 = UNIT.checkState
				var_73_6 = var_73_2
			end
			
			for iter_73_2, iter_73_3 in pairs(var_73_0) do
				if not iter_73_3:isDead() and var_73_4(iter_73_3, var_73_6) then
					var_73_1 = iter_73_1
					var_73_3 = true
					
					break
				end
			end
			
			if var_73_3 then
				break
			end
		else
			var_73_1 = iter_73_1
		end
	end
	
	return var_73_1
end

function EnemyHaveCSSkill.getLinkSkillId(arg_74_0)
	local var_74_0 = arg_74_0:_getSkillSetByCS()
	
	if not var_74_0 then
		Log.e("skill", string.format("EnemyHaveCSSkill : 조건에 맞는 연결스킬이 없음!!! skill_id : [%s]", arg_74_0:getOriginSkillId()))
	end
	
	return var_74_0 and var_74_0.skill:getSkillId()
end

CasterHpSkill = ClassDef(LinkSkill)

function CasterHpSkill.constructor(arg_75_0, arg_75_1, arg_75_2)
end

function CasterHpSkill.initTurn(arg_76_0)
end

function CasterHpSkill.getLinkSkillId(arg_77_0)
	local var_77_0 = arg_77_0:_getSkillSetByHp()
	
	if not var_77_0 then
		Log.e("CasterHpSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_77_0:getOriginSkillId()))
	end
	
	return var_77_0 and var_77_0.skill:getSkillId()
end

function CasterHpSkill._getSkillSetByHp(arg_78_0)
	local var_78_0
	local var_78_1 = arg_78_0._unit:getHPRatio() * 100
	
	for iter_78_0, iter_78_1 in ipairs(arg_78_0._skill_set) do
		local var_78_2 = arg_78_0._skill_set[iter_78_0].set_value or ""
		
		if string.find(var_78_2, ",") == nil then
			if tonumber(var_78_2) == var_78_1 then
				var_78_0 = iter_78_1
				
				break
			end
		else
			local var_78_3 = totable(var_78_2, "=")
			
			if var_78_1 >= tonumber(var_78_3.min) and var_78_1 <= tonumber(var_78_3.max) then
				var_78_0 = iter_78_1
				
				break
			end
		end
	end
	
	return var_78_0
end

CasterDebuffCountSkill = ClassDef(LinkSkill)

function CasterDebuffCountSkill.constructor(arg_79_0, arg_79_1, arg_79_2)
end

function CasterDebuffCountSkill.initTurn(arg_80_0)
end

function CasterDebuffCountSkill.getLinkSkillId(arg_81_0)
	local var_81_0 = arg_81_0:_getSkillSetByDebuff()
	
	if not var_81_0 then
		Log.e("CasterDebuffCountSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_81_0:getOriginSkillId()))
	end
	
	return var_81_0 and var_81_0.skill:getSkillId()
end

function CasterDebuffCountSkill._getSkillSetByDebuff(arg_82_0)
	local var_82_0
	
	for iter_82_0, iter_82_1 in ipairs(arg_82_0._skill_set) do
		local var_82_1 = arg_82_0._skill_set[iter_82_0].set_value
		local var_82_2 = arg_82_0._unit.states:getTypeCount("debuff")
		
		if string.find(var_82_1, ",") == nil then
			if tonumber(var_82_1) == var_82_2 then
				var_82_0 = iter_82_1
				
				break
			end
		else
			local var_82_3 = totable(var_82_1, "=")
			
			if var_82_2 >= tonumber(var_82_3.min) and var_82_2 <= tonumber(var_82_3.max) then
				var_82_0 = iter_82_1
				
				break
			end
		end
	end
	
	return var_82_0
end

CasterBuffCountSkill = ClassDef(LinkSkill)

function CasterBuffCountSkill.constructor(arg_83_0, arg_83_1, arg_83_2)
end

function CasterBuffCountSkill.initTurn(arg_84_0)
end

function CasterBuffCountSkill.getLinkSkillId(arg_85_0)
	local var_85_0 = arg_85_0:_getSkillSetByBuff()
	
	if not var_85_0 then
		Log.e("CasterBuffCountSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_85_0:getOriginSkillId()))
	end
	
	return var_85_0 and var_85_0.skill:getSkillId()
end

function CasterBuffCountSkill._getSkillSetByBuff(arg_86_0)
	local var_86_0
	
	for iter_86_0, iter_86_1 in ipairs(arg_86_0._skill_set) do
		local var_86_1 = arg_86_0._skill_set[iter_86_0].set_value or ""
		local var_86_2 = arg_86_0._unit.states:getTypeCount("buff")
		
		if string.find(var_86_1, ",") == nil then
			if to_n(var_86_1) == var_86_2 then
				var_86_0 = iter_86_1
				
				break
			end
		else
			local var_86_3 = totable(var_86_1, "=")
			
			if var_86_2 >= tonumber(var_86_3.min) and var_86_2 <= tonumber(var_86_3.max) then
				var_86_0 = iter_86_1
				
				break
			end
		end
	end
	
	return var_86_0
end

CasterOwnTurnBuffCountSkill = ClassDef(LinkSkill)

function CasterOwnTurnBuffCountSkill.constructor(arg_87_0, arg_87_1, arg_87_2)
end

function CasterOwnTurnBuffCountSkill.initTurn(arg_88_0)
end

function CasterOwnTurnBuffCountSkill.getLinkSkillId(arg_89_0)
	local var_89_0 = arg_89_0:_getSkillSetByTurnBuff()
	
	if not var_89_0 then
		Log.e("CasterOwnTurnBuffCountSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_89_0:getOriginSkillId()))
	end
	
	return var_89_0 and var_89_0.skill:getSkillId()
end

function CasterOwnTurnBuffCountSkill._getSkillSetByTurnBuff(arg_90_0)
	local var_90_0
	local var_90_1
	local var_90_2 = arg_90_0._unit.logic:getTurnOwner()
	local var_90_3 = arg_90_0._unit.states:getTypeCount("buff")
	
	for iter_90_0, iter_90_1 in ipairs(arg_90_0._skill_set) do
		local var_90_4 = arg_90_0._skill_set[iter_90_0].set_value or ""
		
		if string.find(var_90_4, ",") == nil then
			if to_n(var_90_4) == 0 then
				var_90_1 = iter_90_1
			end
			
			if to_n(var_90_4) == var_90_3 then
				var_90_0 = iter_90_1
				
				break
			end
		else
			local var_90_5 = totable(var_90_4, "=")
			
			if var_90_3 >= tonumber(var_90_5.min) and var_90_3 <= tonumber(var_90_5.max) then
				var_90_0 = iter_90_1
				
				break
			end
		end
	end
	
	if var_90_2 ~= arg_90_0._unit then
		return var_90_1
	end
	
	return var_90_0
end

CasterOwnTurnSkill = ClassDef(LinkSkill)

function CasterOwnTurnSkill.constructor(arg_91_0, arg_91_1, arg_91_2)
end

function CasterOwnTurnSkill.initTurn(arg_92_0)
end

function CasterOwnTurnSkill.getLinkSkillId(arg_93_0)
	local var_93_0 = arg_93_0:_getSkillSetByOwnTurn()
	
	if not var_93_0 then
		Log.e("CasterOwnTurnSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_93_0:getOriginSkillId()))
	end
	
	return var_93_0 and var_93_0.skill:getSkillId()
end

function CasterOwnTurnSkill._getSkillSetByOwnTurn(arg_94_0)
	local var_94_0
	local var_94_1
	local var_94_2 = arg_94_0._unit.logic:getTurnOwner()
	
	for iter_94_0, iter_94_1 in ipairs(arg_94_0._skill_set) do
		local var_94_3 = arg_94_0._skill_set[iter_94_0].set_value or ""
		
		if string.len(var_94_3) <= 0 then
			var_94_1 = iter_94_1
		elseif var_94_3 == "turn_self" then
			var_94_0 = iter_94_1
		end
	end
	
	if var_94_2 ~= arg_94_0._unit then
		return var_94_1
	end
	
	return var_94_0
end

CasterOwnTurnRandomSkill = ClassDef(LinkSkill)

function CasterOwnTurnRandomSkill.constructor(arg_95_0, arg_95_1, arg_95_2)
	arg_95_0._rand_value = 1
end

function CasterOwnTurnRandomSkill.initTurn(arg_96_0)
	arg_96_0._rand_value = arg_96_0._unit.logic.random:get(1, 100) / 100
end

function CasterOwnTurnRandomSkill.getLinkSkillId(arg_97_0)
	local var_97_0 = arg_97_0:_getRandomSkillSetByOwnTurn()
	
	if not var_97_0 then
		Log.e("CasterOwnTurnRandomSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_97_0:getOriginSkillId()))
	end
	
	return var_97_0 and var_97_0.skill:getSkillId()
end

function CasterOwnTurnRandomSkill._getRandomSkillSetByOwnTurn(arg_98_0)
	local var_98_0
	local var_98_1
	local var_98_2 = arg_98_0._unit.logic:getTurnOwner()
	local var_98_3 = 0
	local var_98_4 = arg_98_0._rand_value
	
	for iter_98_0, iter_98_1 in ipairs(arg_98_0._skill_set) do
		local var_98_5 = arg_98_0:getSkillValue(iter_98_0)
		
		if var_98_5 == "turn_other" then
			var_98_1 = iter_98_1
		else
			var_98_3 = var_98_3 + var_98_5
			
			if var_98_4 <= var_98_3 then
				var_98_0 = iter_98_1
				
				break
			end
		end
	end
	
	if var_98_2 ~= arg_98_0._unit then
		return var_98_1
	end
	
	return var_98_0
end

AllyHaveCSSkill = ClassDef(LinkSkill)

function AllyHaveCSSkill.constructor(arg_99_0, arg_99_1, arg_99_2)
end

function AllyHaveCSSkill.initTurn(arg_100_0)
end

function AllyHaveCSSkill._getSkillSetByCS(arg_101_0)
	local var_101_0 = {}
	
	if arg_101_0._unit.logic then
		var_101_0 = arg_101_0._unit.logic.friends
		
		if arg_101_0._unit.inst.ally == ENEMY then
			var_101_0 = arg_101_0._unit.logic.enemies
		end
	end
	
	local var_101_1
	
	for iter_101_0, iter_101_1 in ipairs(arg_101_0._skill_set) do
		local var_101_2 = arg_101_0._skill_set[iter_101_0].set_value
		
		if var_101_2 then
			local var_101_3 = false
			local var_101_4
			local var_101_5 = totable(var_101_2, "=")
			
			if var_101_5.type then
				if var_101_5.type == "csid" then
					var_101_4 = UNIT.checkState
				elseif var_101_5.type == "csgroup" then
					var_101_4 = UNIT.checkStateGroup
				end
				
				target_id = var_101_5.id
			else
				var_101_4 = UNIT.checkState
				target_id = var_101_2
			end
			
			for iter_101_2, iter_101_3 in pairs(var_101_0) do
				if not iter_101_3:isDead() and var_101_4(iter_101_3, target_id) then
					var_101_1 = iter_101_1
					var_101_3 = true
					
					break
				end
			end
			
			if var_101_3 then
				break
			end
		else
			var_101_1 = iter_101_1
		end
	end
	
	return var_101_1
end

function AllyHaveCSSkill.getLinkSkillId(arg_102_0)
	local var_102_0 = arg_102_0:_getSkillSetByCS()
	
	if not var_102_0 then
		Log.e("skill", string.format("AllyHaveCSSkill : 조건에 맞는 연결스킬이 없음!!! skill_id : [%s]", arg_102_0:getOriginSkillId()))
	end
	
	return var_102_0 and var_102_0.skill:getSkillId()
end

CasterOwnTurnHaveCSIDSkill = ClassDef(LinkSkill)

function CasterOwnTurnHaveCSIDSkill.constructor(arg_103_0, arg_103_1, arg_103_2)
end

function CasterOwnTurnHaveCSIDSkill.initTurn(arg_104_0)
end

function CasterOwnTurnHaveCSIDSkill.getLinkSkillId(arg_105_0)
	local var_105_0 = arg_105_0:_getSkillSetByOwnTurnHaveCS()
	
	if not var_105_0 then
		Log.e("CasterOwnTurnHaveCSIDSkill", string.format("조건에 맞는 연결스킬이 없음. skill_id : [%s]", arg_105_0:getOriginSkillId()))
	end
	
	return var_105_0 and var_105_0.skill:getSkillId()
end

function CasterOwnTurnHaveCSIDSkill._getSkillSetByOwnTurnHaveCS(arg_106_0)
	local var_106_0
	local var_106_1
	local var_106_2
	local var_106_3
	
	local function var_106_4(arg_107_0, arg_107_1)
		if arg_107_0 then
			Log.e("CasterOwnTurnHaveCSIDSkill", arg_107_1 .. "이 중복으로 있음")
		end
	end
	
	local function var_106_5(arg_108_0, arg_108_1)
		if arg_108_0 == nil then
			Log.e("CasterOwnTurnHaveCSIDSkill", arg_108_1 .. "이 없음")
		end
	end
	
	for iter_106_0, iter_106_1 in ipairs(arg_106_0._skill_set) do
		local var_106_6 = arg_106_0._skill_set[iter_106_0].set_value
		
		if var_106_6 then
			if var_106_6 == "turn_other" then
				var_106_4(var_106_2, "turn_other_set")
				
				var_106_2 = iter_106_1
			else
				var_106_4(var_106_0, "skill_set")
				
				var_106_3 = var_106_6
				var_106_0 = iter_106_1
			end
		else
			var_106_4(var_106_1, "default_set")
			
			var_106_1 = iter_106_1
		end
	end
	
	var_106_5(var_106_1, "default_set")
	var_106_5(var_106_0, "skill_set")
	var_106_5(var_106_2, "turn_other_set")
	
	if arg_106_0._unit.logic:getTurnOwner() == arg_106_0._unit then
		return arg_106_0._unit:checkState(var_106_3) and var_106_0 or var_106_1
	else
		return var_106_2
	end
end
