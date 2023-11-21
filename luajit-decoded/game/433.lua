PetSkill = PetSkill or {}
SKILL_CONDITION = {
	ENHANCE_EQUIP_EXP = "enhance_equip_exp",
	ENHANCE_HERO_EXP = "enhance_hero_exp",
	EQUIP_UPGRADE_GOLD_DOWN = "equip_upgrade_gold_down",
	EQUIP_SELL_GOLD_UP = "equip_sell_gold_up"
}

local var_0_0 = 5

function PetSkill.getSkillDB(arg_1_0, arg_1_1)
	if not arg_1_1 then
		return {}
	end
	
	return (DBT("pet_skill", arg_1_1, {
		"id",
		"name",
		"skill_group",
		"skill_condition",
		"condition_add",
		"skill_aff_1",
		"skill_aff_2",
		"skill_aff_3",
		"skill_aff_4",
		"skill_aff_5",
		"skill_aff_6",
		"calc_type"
	}))
end

function PetSkill.getAffectionEffectDB(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return {}
	end
	
	return (DBT("pet_affection_effect", arg_2_1, {
		"id",
		"value_1",
		"value_2",
		"value_3",
		"value_4",
		"value_5",
		"value_6"
	}))
end

function PetSkill.calcValue(arg_3_0, arg_3_1, arg_3_2)
	return arg_3_2 + arg_3_0:getAddCalcValue(arg_3_1, arg_3_2)
end

function PetSkill.getEffectDBValue(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0:getAffectionEffectDB(arg_4_2)
	local var_4_1 = arg_4_1:getFavLevel()
	
	return var_4_0["value_" .. var_4_1]
end

function PetSkill.getValueByIdx(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 or not arg_5_2 then
		return 
	end
	
	local var_5_0 = arg_5_1:getSkillID(arg_5_2)
	local var_5_1 = arg_5_1:getSkillRank(arg_5_2)
	
	return arg_5_0:getValueBySkillId(arg_5_1, var_5_0, var_5_1)
end

function PetSkill.getValueBySkillId(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_1 or not arg_6_2 or not arg_6_3 then
		return 
	end
	
	local var_6_0 = arg_6_0:getSkillDB(arg_6_2)
	local var_6_1 = var_6_0["skill_aff_" .. arg_6_3]
	local var_6_2 = arg_6_0:getEffectDBValue(arg_6_1, var_6_1)
	
	return var_6_0, var_6_2
end

function PetSkill.getEffectiveDBValue(arg_7_0, arg_7_1)
	local var_7_0 = os.time()
	local var_7_1 = Account:getLobbyPet()
	local var_7_2 = 0
	
	for iter_7_0 = 1, var_0_0 do
		local var_7_3, var_7_4 = arg_7_0:getValueByIdx(var_7_1, iter_7_0)
		
		if var_7_3 and var_7_4 and var_7_3.skill_condition == arg_7_1 then
			var_7_2 = var_7_2 + var_7_4
		end
	end
	
	return var_7_2
end

function PetSkill.getSkillFixIdList(arg_8_0, arg_8_1)
	local var_8_0 = DB("pet_character", arg_8_1, {
		"skill_id_fix"
	})
	
	if var_8_0 then
		return (string.split(var_8_0, ","))
	end
end

function PetSkill.getSkillFixRankList(arg_9_0, arg_9_1)
	local var_9_0 = DB("pet_character", arg_9_1, {
		"skill_rank_fix"
	})
	
	if var_9_0 then
		return (string.split(var_9_0, ","))
	end
end

function PetSkill.getSkilFixData(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:getSkillFixIdList(arg_10_1)
	local var_10_1 = arg_10_0:getSkillFixRankList(arg_10_1) or {}
	local var_10_2 = {}
	
	if not var_10_0 then
		return 
	end
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		table.insert(var_10_2, {
			id = iter_10_1,
			rank = var_10_1[iter_10_0] or 0
		})
	end
	
	if table.count(var_10_2) <= 0 then
		return 
	end
	
	return var_10_2
end

function PetSkill.getLobbyAddCalcValue(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = os.time()
	local var_11_1 = Account:getLobbyPet()
	local var_11_2 = 0
	
	for iter_11_0 = 1, var_0_0 do
		local var_11_3, var_11_4 = arg_11_0:getValueByIdx(var_11_1, iter_11_0)
		
		if var_11_3 and var_11_4 and var_11_3.skill_condition == arg_11_1 then
			if var_11_3.calc_type == "multiply" then
				var_11_2 = var_11_2 + arg_11_2 * var_11_4
			elseif var_11_3.calc_type == "sum" then
				var_11_2 = var_11_2 + var_11_4
			end
		end
	end
	
	return (math.floor(var_11_2))
end
