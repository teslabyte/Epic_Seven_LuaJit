PetSortFunc = {}

function PetSortFunc.greaterThanUID(arg_1_0, arg_1_1)
	return arg_1_0:getUID() < arg_1_1:getUID()
end

function PetSortFunc.greaterThanID(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:getSortByCodeValue()
	local var_2_1 = arg_2_1:getSortByCodeValue()
	
	if not var_2_0 or not var_2_1 then
		return PetSortFunc.greaterThanUID(arg_2_0, arg_2_1)
	end
	
	if var_2_0 == var_2_1 then
		return PetSortFunc.greaterThanUID(arg_2_0, arg_2_1)
	end
	
	return var_2_1 < var_2_0
end

function PetSortFunc.greaterThanBaseGrade(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:getBaseGrade()
	local var_3_1 = arg_3_1:getBaseGrade()
	
	if var_3_0 == var_3_1 then
		return PetSortFunc.greaterThanID(arg_3_0, arg_3_1)
	end
	
	return var_3_1 < var_3_0
end

function PetSortFunc.greaterThanGrade(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0:getGrade()
	local var_4_1 = arg_4_1:getGrade()
	
	if var_4_0 == var_4_1 then
		return PetSortFunc.greaterThanLevel(arg_4_0, arg_4_1)
	end
	
	return var_4_1 < var_4_0
end

function PetSortFunc.greaterThanExp(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:getExp()
	local var_5_1 = arg_5_1:getExp()
	
	if var_5_0 == var_5_1 then
		return PetSortFunc.greaterThanID(arg_5_0, arg_5_1)
	end
	
	return var_5_1 < var_5_0
end

function PetSortFunc.greaterThanLevel(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:getLv()
	local var_6_1 = arg_6_1:getLv()
	
	if var_6_0 == var_6_1 then
		return PetSortFunc.greaterThanBaseGrade(arg_6_0, arg_6_1)
	end
	
	return var_6_1 < var_6_0
end

PET_TYPE_SORT_TBL = {
	food = 3,
	lobby = 2,
	battle = 1
}

function PetSortFunc.greaterThanType(arg_7_0, arg_7_1)
	local var_7_0 = PET_TYPE_SORT_TBL[arg_7_0:getType()]
	local var_7_1 = PET_TYPE_SORT_TBL[arg_7_1:getType()]
	
	if var_7_0 == var_7_1 then
		return PetSortFunc.greaterThanID(arg_7_0, arg_7_1)
	end
	
	return var_7_1 < var_7_0
end

function PetSortFunc.greaterThanRank(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:getHighestSkillRank()
	local var_8_1 = arg_8_1:getHighestSkillRank()
	
	if var_8_0 == var_8_1 then
		return PetSortFunc.greaterThanGrade(arg_8_0, arg_8_1)
	end
	
	return var_8_1 < var_8_0
end
