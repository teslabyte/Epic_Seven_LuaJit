PET_ENHANCER = PET_ENHANCER or {}

local var_0_0 = 0

function PET_ENHANCER.create(arg_1_0, arg_1_1)
	local var_1_0 = {}
	
	PET_ENHANCER.bindFunctions(var_1_0)
	
	if arg_1_1.is_pet then
		var_1_0.db = arg_1_1.db
		var_1_0.is_pet = arg_1_1.is_pet
	else
		local var_1_1 = var_1_0:initDB(arg_1_1.code)
		
		var_1_0.material_uid = var_0_0
		var_0_0 = var_0_0 + 1
		
		if not var_1_1 then
			Log.e("WRONG PET_FOOD MATERIAL TYPE.")
			
			return false
		end
	end
	
	var_1_0.isPet = arg_1_1.is_pet ~= nil
	var_1_0.item = arg_1_1
	
	return var_1_0
end

function PET_ENHANCER.bindFunctions(arg_2_0)
	copy_functions(PET_ENHANCER, arg_2_0)
end

function PET_ENHANCER.initDB(arg_3_0, arg_3_1)
	arg_3_0.db = DBT("item_material", arg_3_1, {
		"name",
		"ma_type",
		"ma_type2",
		"icon",
		"get_xp"
	})
	
	if not arg_3_0.db or arg_3_0.db.ma_type ~= "petfood" then
		return false
	end
	
	arg_3_0.db.code = arg_3_1
	
	return true
end

function PET_ENHANCER.getFaceID(arg_4_0)
	if arg_4_0.isPet then
		return arg_4_0.item:getFaceID()
	else
		return arg_4_0.db.icon
	end
end

function PET_ENHANCER.isLocked(arg_5_0)
	if arg_5_0.isPet then
		return arg_5_0.item:isLocked()
	else
		return false
	end
end

function PET_ENHANCER.isMaxLevel(arg_6_0)
	if arg_6_0.isPet then
		return arg_6_0.item:isMaxLevel()
	else
		return true
	end
end

function PET_ENHANCER.isPetFood(arg_7_0)
	if arg_7_0.isPet then
		return arg_7_0.item:isPetFood()
	else
		return arg_7_0.db.ma_type == "petfood"
	end
end

function PET_ENHANCER.isCanRemove(arg_8_0)
	if arg_8_0.isPet then
		return arg_8_0.item:isCanRemove()
	else
		return true
	end
end

function PET_ENHANCER.getName(arg_9_0)
	if arg_9_0.isPet then
		return arg_9_0.item:getName()
	else
		return T(arg_9_0.db.name)
	end
end

function PET_ENHANCER.getCode(arg_10_0)
	if arg_10_0.isPet then
		return arg_10_0.item:getCode()
	else
		return arg_10_0.db.code
	end
end

function PET_ENHANCER.getSortByCodeValue(arg_11_0)
	if arg_11_0.isPet then
		return arg_11_0.item:getSortByCodeValue()
	else
		return (tonumber(string.sub(arg_11_0.db.code, -1)) or -1) * 100000
	end
end

function PET_ENHANCER.getLv(arg_12_0)
	if arg_12_0.isPet then
		return arg_12_0.item:getLv()
	else
		return 1
	end
end

function PET_ENHANCER.getHighestSkillRank(arg_13_0)
	if arg_13_0.isPet then
		return arg_13_0.item:getHighestSkillRank()
	else
		return 0
	end
end

function PET_ENHANCER.getConsumeExp(arg_14_0)
	if arg_14_0.isPet then
		return arg_14_0.item:getConsumeExp()
	else
		return arg_14_0.db.get_xp
	end
end

function PET_ENHANCER.getExp(arg_15_0)
	if arg_15_0.isPet then
		return arg_15_0.item:getExp()
	else
		return 0
	end
end

function PET_ENHANCER.getMaxLevel(arg_16_0)
	if arg_16_0.isPet then
		return arg_16_0.item:getMaxLevel()
	else
		return 1
	end
end

function PET_ENHANCER.getBaseGrade(arg_17_0)
	if arg_17_0.isPet then
		return arg_17_0.item:getGrade()
	else
		return 1
	end
end

function PET_ENHANCER.getGrade(arg_18_0)
	if arg_18_0.isPet then
		return arg_18_0.item:getGrade()
	else
		return 1
	end
end

function PET_ENHANCER.getMaxGrade(arg_19_0)
	if arg_19_0.isPet then
		return arg_19_0.item:getMaxGrade()
	else
		return 5
	end
end

function PET_ENHANCER.getType(arg_20_0)
	if arg_20_0.isPet then
		return arg_20_0.item:getType()
	else
		return "food"
	end
end

function PET_ENHANCER.getHighestSkillRank(arg_21_0)
	if arg_21_0.isPet then
		return arg_21_0.item:getHighestSkillRank()
	else
		return 0
	end
end

function PET_ENHANCER.getEnhancePrice(arg_22_0)
	if arg_22_0.isPet then
		return arg_22_0.item:getEnhancePrice()
	else
		return 4 * GAME_STATIC_VARIABLE.pet_enhance_price
	end
end

function PET_ENHANCER.isFeature(arg_23_0)
	if arg_23_0.isPet then
		return arg_23_0.item:isFeature()
	else
		return false
	end
end

function PET_ENHANCER.isLimit(arg_24_0)
	if arg_24_0.isPet then
		return arg_24_0.item:isLimit()
	else
		return false
	end
end

function PET_ENHANCER.getUID(arg_25_0)
	if arg_25_0.isPet then
		return arg_25_0.item:getUID()
	else
		return -1 * arg_25_0.material_uid
	end
end
