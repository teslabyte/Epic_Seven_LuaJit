UnitSortOrder = {}
UnitSortOrder.OrderTable = {
	"Grade",
	"Level",
	"ZodiacGrade",
	"Color",
	"Role",
	"Name",
	"Point",
	"Fav",
	"DevoteGrade",
	"UID"
}
UnitSortOrder.UnOrderTable = {
	Role = 5,
	Point = 7,
	Grade = 1,
	Color = 4,
	UID = 10,
	Name = 6,
	ZodiacGrade = 3,
	Fav = 8,
	Level = 2,
	DevoteGrade = 9
}
UnitSortOrder.ROLE_SORT_ORDER = {
	manauser = 2,
	knight = 6,
	material = 1,
	assassin = 5,
	warrior = 7,
	ranger = 4,
	mage = 3
}

function UnitSortOrder.makeList(arg_1_0, arg_1_1)
	local var_1_0 = table.clone(arg_1_0.OrderTable)
	
	if arg_1_1 then
		var_1_0[arg_1_0.UnOrderTable[arg_1_1]] = nil
	end
	
	local var_1_1 = {}
	
	for iter_1_0 = 1, #arg_1_0.OrderTable do
		table.insert(var_1_1, var_1_0[iter_1_0])
	end
	
	return var_1_1
end

function UnitSortOrder.procNext(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = table.remove(arg_2_3, 1)
	
	if not var_2_0 then
		return arg_2_1.inst.uid < arg_2_2.inst.uid
	end
	
	return arg_2_0["greaterThan" .. var_2_0](arg_2_1, arg_2_2, arg_2_3)
end

function UnitSortOrder.greaterThanLevel(arg_3_0, arg_3_1, arg_3_2)
	arg_3_2 = arg_3_2 or UnitSortOrder:makeList("Level")
	
	local var_3_0 = arg_3_0:getLv()
	local var_3_1 = arg_3_1:getLv()
	
	if arg_3_0:isGrowthBoostRegistered() then
		arg_3_0.gb_lv = arg_3_0.gb_lv or arg_3_0:getGrowthBoostLv()
		var_3_0 = arg_3_0.gb_lv
	end
	
	if arg_3_1:isGrowthBoostRegistered() then
		arg_3_1.gb_lv = arg_3_1.gb_lv or arg_3_1:getGrowthBoostLv()
		var_3_1 = arg_3_1.gb_lv
	end
	
	if var_3_0 == var_3_1 then
		return UnitSortOrder:procNext(arg_3_0, arg_3_1, arg_3_2)
	end
	
	return var_3_1 < var_3_0
end

function UnitSortOrder.greaterThanExp(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2 = arg_4_2 or UnitSortOrder:makeList("Exp")
	
	if arg_4_0.inst.exp == arg_4_1.inst.exp then
		return UnitSortOrder:procNext(arg_4_0, arg_4_1, arg_4_2)
	end
	
	return arg_4_0.inst.exp > arg_4_1.inst.exp
end

function UnitSortOrder.greaterThanUID(arg_5_0, arg_5_1, arg_5_2)
	return arg_5_0.inst.uid < arg_5_1.inst.uid
end

function UnitSortOrder.greaterThanGrade(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or UnitSortOrder:makeList("Grade")
	
	local var_6_0 = arg_6_0:getGrade()
	local var_6_1 = arg_6_1:getGrade()
	
	if arg_6_0:isGrowthBoostRegistered() then
		arg_6_0.gb_grade = arg_6_0.gb_grade or arg_6_0:getGrowthBoostZodiac()
		var_6_0 = arg_6_0.gb_grade
	end
	
	if arg_6_1:isGrowthBoostRegistered() then
		arg_6_1.gb_grade = arg_6_1.gb_grade or arg_6_1:getGrowthBoostZodiac()
		var_6_1 = arg_6_1.gb_grade
	end
	
	if var_6_0 == var_6_1 then
		return UnitSortOrder:procNext(arg_6_0, arg_6_1, arg_6_2)
	end
	
	return var_6_1 < var_6_0
end

function UnitSortOrder.greaterThanZodiacGrade(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or UnitSortOrder:makeList("Grade")
	
	local var_7_0 = arg_7_0:getZodiacGrade()
	local var_7_1 = arg_7_1:getZodiacGrade()
	
	if arg_7_0:isGrowthBoostRegistered() then
		arg_7_0.gb_zodiac = arg_7_0.gb_zodiac or arg_7_0:getGrowthBoostZodiac()
		var_7_0 = arg_7_0.gb_zodiac
	end
	
	if arg_7_1:isGrowthBoostRegistered() then
		arg_7_1.gb_zodiac = arg_7_1.gb_zodiac or arg_7_0:getGrowthBoostZodiac()
		var_7_1 = arg_7_1.gb_zodiac
	end
	
	local var_7_2 = var_7_0 + arg_7_0:getAwakeGrade()
	local var_7_3 = var_7_1 + arg_7_1:getAwakeGrade()
	
	if var_7_2 == var_7_3 then
		return UnitSortOrder:procNext(arg_7_0, arg_7_1, arg_7_2)
	end
	
	return var_7_3 < var_7_2
end

function UnitSortOrder.greaterThanCode(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or UnitSortOrder:makeList("Code")
	
	if arg_8_0.inst.code == arg_8_1.inst.code then
		return UnitSortOrder:procNext(arg_8_0, arg_8_1, arg_8_2)
	end
	
	return arg_8_0.inst.code > arg_8_1.inst.code
end

function UnitSortOrder.greaterThanDevoteGrade(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or UnitSortOrder:makeList("DevoteGrade")
	
	local var_9_0 = arg_9_0:getPresentDevote()
	local var_9_1 = arg_9_1:getPresentDevote()
	
	if var_9_0 == var_9_1 then
		return UnitSortOrder:procNext(arg_9_0, arg_9_1, arg_9_2)
	end
	
	return var_9_1 < var_9_0
end

local var_0_0 = {
	wind = 3,
	fire = 1,
	none = 6,
	light = 4,
	dark = 5,
	ice = 2
}

function UnitSortOrder.greaterThanColor(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or UnitSortOrder:makeList("Color")
	
	if arg_10_0.db.color == arg_10_1.db.color then
		return UnitSortOrder:procNext(arg_10_0, arg_10_1, arg_10_2)
	end
	
	return var_0_0[arg_10_0.db.color] < var_0_0[arg_10_1.db.color]
end

function UnitSortOrder.greaterThanRole(arg_11_0, arg_11_1, arg_11_2)
	arg_11_2 = arg_11_2 or UnitSortOrder:makeList("Role")
	
	if arg_11_0.db.role == arg_11_1.db.role then
		return UnitSortOrder:procNext(arg_11_0, arg_11_1, arg_11_2)
	end
	
	return UnitSortOrder.ROLE_SORT_ORDER[arg_11_0.db.role] > UnitSortOrder.ROLE_SORT_ORDER[arg_11_1.db.role]
end

function UnitSortOrder.greaterThanName(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = arg_12_2 or UnitSortOrder:makeList("Name")
	
	if arg_12_0.db.name == arg_12_1.db.name then
		return UnitSortOrder:procNext(arg_12_0, arg_12_1, arg_12_2)
	end
	
	local var_12_0 = arg_12_0.db.sort_name and arg_12_0.db.sort_name or arg_12_0:getName()
	local var_12_1 = arg_12_1.db.sort_name and arg_12_1.db.sort_name or arg_12_1:getName()
	
	if isLatinAccentLanguage() then
		return utf8LatinAccentCompare(var_12_0, var_12_1)
	end
	
	return string.lower(var_12_0) < string.lower(var_12_1)
end

function UnitSortOrder.greaterThanPoint(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or UnitSortOrder:makeList("Point")
	
	local var_13_0 = arg_13_0:getPoint()
	local var_13_1 = arg_13_1:getPoint()
	
	if arg_13_0:isGrowthBoostRegistered() then
		arg_13_0.gb_point = arg_13_0.gb_point or arg_13_0:getGrowthBoostPoint()
		var_13_0 = arg_13_0.gb_point
	end
	
	if arg_13_1:isGrowthBoostRegistered() then
		arg_13_1.gb_point = arg_13_1.gb_point or arg_13_1:getGrowthBoostPoint()
		var_13_1 = arg_13_1.gb_point
	end
	
	if var_13_0 == var_13_1 then
		return UnitSortOrder:procNext(arg_13_0, arg_13_1, arg_13_2)
	end
	
	return var_13_1 < var_13_0
end

function UnitSortOrder.greaterThanFav(arg_14_0, arg_14_1, arg_14_2)
	arg_14_2 = arg_14_2 or UnitSortOrder:makeList("Fav")
	
	if arg_14_0:getFavLevel() == arg_14_1:getFavLevel() then
		return UnitSortOrder:procNext(arg_14_0, arg_14_1, arg_14_2)
	end
	
	return arg_14_0:getFavLevel() > arg_14_1:getFavLevel()
end

function UnitSortOrder.makeGreaterThanStat(arg_15_0)
	return function(arg_16_0, arg_16_1, arg_16_2)
		arg_16_2 = arg_16_2 or UnitSortOrder:makeList()
		
		local var_16_0 = arg_16_0:getStatus()[arg_15_0]
		local var_16_1 = arg_16_1:getStatus()[arg_15_0]
		
		if arg_16_0:isGrowthBoostRegistered() then
			local var_16_2 = "gb_" .. arg_15_0
			
			arg_16_0[var_16_2] = arg_16_0[var_16_2] or arg_16_0:getGrowthBoostStatus()[arg_15_0]
			var_16_0 = arg_16_0[var_16_2]
		end
		
		if arg_16_1:isGrowthBoostRegistered() then
			local var_16_3 = "gb_" .. arg_15_0
			
			arg_16_1[var_16_3] = arg_16_1[var_16_3] or arg_16_1:getGrowthBoostStatus()[arg_15_0]
			var_16_1 = arg_16_1[var_16_3]
		end
		
		if math.equal(var_16_0, var_16_1) then
			return UnitSortOrder:procNext(arg_16_0, arg_16_1, arg_16_2)
		end
		
		return var_16_1 < var_16_0
	end
end

function UnitSortOrder.makeStatSortFuncSelector(arg_17_0)
	return function(arg_18_0, arg_18_1)
		if arg_17_0 then
			local var_18_0 = arg_17_0:getLatestStatMenuFunc()
			
			if var_18_0 then
				return var_18_0(arg_18_0, arg_18_1)
			end
		end
		
		return UnitSortOrder.greaterThanPoint(arg_18_0, arg_18_1)
	end
end
