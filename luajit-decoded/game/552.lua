AccountSkill = AccountSkill or {}

function AccountSkill.getFactionSkillDB(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = DB("faction_level", string.format("%s_%02d", arg_1_1, arg_1_2), "account_skill")
	
	print("faction_level", arg_1_2, arg_1_1, var_1_0)
	
	if not var_1_0 then
		return 
	end
	
	return arg_1_0:getSkillDB(var_1_0)
end

function AccountSkill.classifyByEffectType(arg_2_0)
	arg_2_0.db = {}
	
	for iter_2_0 = 1, 99 do
		local var_2_0, var_2_1, var_2_2, var_2_3, var_2_4, var_2_5 = DBN("account_skill", iter_2_0, {
			"id",
			"level",
			"effect_type",
			"effect_detail",
			"value",
			"calc_type"
		})
		
		if not var_2_0 then
			break
		end
		
		local var_2_6 = {
			id = var_2_0,
			level = var_2_1,
			effect_type = var_2_2,
			effect_detail = var_2_3,
			value = var_2_4,
			calc_type = var_2_5
		}
		
		if not arg_2_0.db[var_2_2] then
			arg_2_0.db[var_2_2] = {}
		end
		
		table.insert(arg_2_0.db[var_2_2], var_2_6)
	end
end

function AccountSkill.getSkillDB(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return 
	end
	
	return (DBT("account_skill", arg_3_1, {
		"id",
		"level",
		"effect_type",
		"effect_detail",
		"effect_desc",
		"value",
		"value_desc",
		"effect_value_desc",
		"calc_type",
		"icon",
		"name"
	}))
end

function AccountSkill.getPrevSkillLevelID(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	local var_4_0 = string.split(arg_4_1, "_")
	local var_4_1 = var_4_0[1] .. "_" .. var_4_0[2]
	
	if tonumber(var_4_0[3]) <= 1 then
		return 
	end
	
	local var_4_2 = var_4_0[3] - 1
	
	return var_4_1 .. "_" .. var_4_2
end

function AccountSkill.getnextSkillLevelID(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0 = string.split(arg_5_1, "_")
	local var_5_1 = var_5_0[1] .. "_" .. var_5_0[2]
	local var_5_2 = var_5_0[3] + 1
	
	return var_5_1 .. "_" .. var_5_2
end

function AccountSkill.getSkillIDByLevelID(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return 
	end
	
	local var_6_0 = string.split(arg_6_1, "_")
	
	return var_6_0[1] .. "_" .. var_6_0[2]
end

function AccountSkill.hasSkill(arg_7_0, arg_7_1)
	if AccountData.account_skills[arg_7_1] then
		return true
	end
	
	return false
end

function AccountSkill.getAccountSkills(arg_8_0)
	return AccountData.account_skills
end

function AccountSkill.getBoosters(arg_9_0)
	local var_9_0 = {}
	
	for iter_9_0, iter_9_1 in pairs(AccountData.account_skills) do
		if iter_9_1.expire_time and iter_9_1.expire_time > os.time() then
			table.insert(var_9_0, iter_9_1)
		end
	end
	
	return var_9_0
end

function AccountSkill.updateBoosters(arg_10_0)
	for iter_10_0, iter_10_1 in pairs(AccountData.account_skills) do
		if iter_10_1.expire_time and iter_10_1.expire_time ~= 0 and os.time() > iter_10_1.expire_time then
			AccountData.account_skills[iter_10_0] = nil
		end
	end
end

function AccountSkill.getAccountSkillByLevelID(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:getSkillIDByLevelID(arg_11_1)
	
	if not var_11_0 then
		return 
	end
	
	return arg_11_0:getAccountSkill(var_11_0)
end

function AccountSkill.setAccountSkill(arg_12_0, arg_12_1, arg_12_2)
	AccountData.account_skills[arg_12_1] = arg_12_2
end

function AccountSkill.getAccountSkill(arg_13_0, arg_13_1)
	return AccountData.account_skills[arg_13_1]
end

function AccountSkill.hasSkillByLevelID(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:getSkillIDByLevelID(arg_14_1)
	
	if not var_14_0 then
		return 
	end
	
	if AccountData.account_skills[var_14_0] then
		return true
	end
	
	return false
end

function AccountSkill.getUpgradeSkillFactionGrade(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if not arg_15_3 or not arg_15_4 then
		return 
	end
	
	local var_15_0
	local var_15_1
	
	for iter_15_0 = 1, 999 do
		local var_15_2, var_15_3, var_15_4 = DBN("faction_level", iter_15_0, {
			"id",
			"level",
			"account_skill"
		})
		
		if not var_15_2 then
			break
		end
		
		if var_15_4 == arg_15_3 then
			var_15_0 = var_15_3
		end
		
		if var_15_4 == arg_15_4 then
			var_15_1 = var_15_3
		end
		
		if var_15_0 and var_15_1 then
			break
		end
	end
	
	return var_15_0, var_15_1
end

function AccountSkill.getMaxLevelByLevelID(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:getSkillIDByLevelID(arg_16_1)
	local var_16_1 = 1
	local var_16_2 = 10
	
	for iter_16_0 = 1, var_16_2 do
		if DB("account_skill", var_16_0 .. "_" .. iter_16_0, "id") then
			var_16_1 = iter_16_0
		else
			break
		end
	end
	
	return var_16_1
end

function AccountSkill.calcValue(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:updateBoosters()
	
	local var_17_0 = arg_17_0:getAccountSkills()
	local var_17_1 = 0
	
	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		local var_17_2 = arg_17_0:getSkillDB(iter_17_0 .. "_" .. iter_17_1.level)
		
		if var_17_2 then
			iter_17_0 = var_17_2.id
		end
		
		if AccountSkill:hasSkillByLevelID(iter_17_0) and var_17_2 and var_17_2.effect_type == arg_17_1 then
			if var_17_2.calc_type == "multiply" then
				var_17_1 = var_17_1 + arg_17_2 * var_17_2.value
			elseif var_17_2.calc_type == "sum" then
				var_17_1 = var_17_1 + var_17_2.value
			end
		end
	end
	
	return (math.floor(var_17_1))
end

function AccountSkill.getAddCalcValue(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0:updateBoosters()
	
	local var_18_0 = arg_18_0:getAccountSkills()
	local var_18_1 = 0
	
	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		local var_18_2 = arg_18_0:getSkillDB(iter_18_0 .. "_" .. iter_18_1.level)
		
		if var_18_2 then
			iter_18_0 = var_18_2.id
		end
		
		if AccountSkill:hasSkillByLevelID(iter_18_0) and var_18_2 and var_18_2.effect_type == arg_18_1 then
			if var_18_2.calc_type == "multiply" then
				var_18_1 = var_18_1 + arg_18_2 * var_18_2.value
			elseif var_18_2.calc_type == "sum" then
				var_18_1 = var_18_1 + var_18_2.value
			end
		end
	end
	
	return (math.floor(var_18_1))
end

function AccountSkill.getEnabledTime(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:getBoosters()
	local var_19_1 = os.time()
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		local var_19_2 = arg_19_0:getSkillDB(iter_19_1.skill_id .. "_" .. iter_19_1.level)
		
		if var_19_2 and var_19_2.effect_type == arg_19_1 and to_n(var_19_2.value) > 0 and iter_19_1.expire_time and var_19_1 < iter_19_1.expire_time then
			return {
				var_19_1,
				iter_19_1.expire_time
			}
		end
	end
	
	return nil
end

function AccountSkill.getCountActiveSkillByEffectType(arg_20_0, arg_20_1)
	arg_20_0:updateBoosters()
	
	local var_20_0 = os.time()
	local var_20_1 = 0
	local var_20_2 = arg_20_0:getAccountSkills()
	
	for iter_20_0, iter_20_1 in pairs(var_20_2) do
		if not iter_20_1.vars then
			iter_20_1.vars = {}
		end
		
		if iter_20_1.expire_time and iter_20_1.expire_time ~= 0 and iter_20_1.vars.effect_type == nil then
			local var_20_3 = arg_20_0:getSkillDB(iter_20_1.skill_id .. "_" .. tostring(iter_20_1.level))
			
			iter_20_1.vars.effect_type = var_20_3.effect_type
		end
		
		if iter_20_1.expire_time and iter_20_1.expire_time ~= 0 and iter_20_1.vars.effect_type == arg_20_1 and var_20_0 <= iter_20_1.expire_time then
			var_20_1 = var_20_1 + 1
		end
	end
	
	return var_20_1
end

function AccountSkill.isBlockConditionEquipFree(arg_21_0, arg_21_1)
	if DB("account_skill", arg_21_1, {
		"effect_type"
	}) == BOOSTERSKILL_EFFECT_TYPE.UNDRESS_ALLEQUIP_REDUCE and EventBooster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) then
		balloon_message_with_sound("check_use_equipbuff_server")
		
		return true
	end
	
	return false
end

function AccountSkill.isChangeTextEquipFree(arg_22_0, arg_22_1)
	if DB("account_skill", arg_22_1, {
		"effect_type"
	}) == BOOSTERSKILL_EFFECT_TYPE.UNDRESS_ALLEQUIP_REDUCE and AccountSkill:getCountActiveSkillByEffectType(BOOSTERSKILL_EFFECT_TYPE.UNDRESS_ALLEQUIP_REDUCE) > 0 then
		return true, T("check_user_equipbuff_self")
	end
	
	return false
end
