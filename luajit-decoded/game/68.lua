FactionDailyReward = ClassDef(Condition_New)

function FactionDailyReward.constructor(arg_1_0)
end

function FactionDailyReward.getAcceptEvents(arg_2_0)
	return {
		"faction.max.daily"
	}
end

function FactionDailyReward.onEvent(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "faction.max.daily" then
		arg_3_0:doCountAdd()
		arg_3_0:checkDone()
	end
end

CharacterLevelCondition = ClassDef(Condition_New)

function CharacterLevelCondition.constructor(arg_4_0)
end

function CharacterLevelCondition.getAcceptEvents(arg_5_0)
	return {
		"unit.levelup"
	}
end

function CharacterLevelCondition.onEvent(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_1 == "unit.levelup" and tonumber(arg_6_0.db.level) <= arg_6_2.level and tonumber(arg_6_0.db.level) > arg_6_2.prev_level then
		if arg_6_0.db.grade and tonumber(arg_6_0.db.grade) ~= arg_6_2.grade then
			return 
		end
		
		if arg_6_0.db.chrid and arg_6_0.db.chrid ~= arg_6_2.chrid then
			return 
		end
		
		arg_6_0:doCountAdd()
		arg_6_0:checkDone()
	end
end

CharacterFavLevelCondition = ClassDef(Condition_New)

function CharacterFavLevelCondition.constructor(arg_7_0)
end

function CharacterFavLevelCondition.getAcceptEvents(arg_8_0)
	return {
		"fav.levelup",
		"sync.fav",
		"sync.fav.chr"
	}
end

function CharacterFavLevelCondition.onEvent(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1 == "fav.levelup" then
		if tonumber(arg_9_0.db.level) <= arg_9_2.level and tonumber(arg_9_0.db.level) > arg_9_2.prev_level then
			if not arg_9_0.db.chr then
				arg_9_0:doCountAdd()
				arg_9_0:checkDone()
			elseif arg_9_0.db.chr and arg_9_0:checkMultikey(arg_9_0.db.chr, arg_9_2.code) then
				arg_9_0:doCountAdd()
				arg_9_0:checkDone()
			end
			
			arg_9_0:getVerifyParams().uid = arg_9_2.uid
		end
	elseif arg_9_1 == "sync.fav" then
		if not arg_9_0.db.chr then
			local var_9_0 = arg_9_0:getCurCount()
			local var_9_1 = Account:getUnits()
			local var_9_2 = 0
			local var_9_3
			
			for iter_9_0, iter_9_1 in pairs(var_9_1) do
				if iter_9_1:getFavLevel() >= tonumber(arg_9_0.db.level) then
					var_9_2 = var_9_2 + 1
					var_9_3 = var_9_3 or iter_9_1
				end
			end
			
			if var_9_0 < var_9_2 then
				arg_9_0:doCountAdd(var_9_2 - var_9_0)
				arg_9_0:checkDone()
				
				if var_9_3 then
					arg_9_0:getVerifyParams().uid = var_9_3:getUID()
				end
			end
		end
	elseif arg_9_1 == "sync.fav.chr" and arg_9_0.db.chr then
		if tonumber(arg_9_0.db.count) ~= 1 then
			return 
		end
		
		if arg_9_0:getCurCount() >= 1 then
			return 
		end
		
		local var_9_4
		
		if type(arg_9_0.db.chr) == "string" then
			var_9_4 = {
				arg_9_0.db.chr
			}
		elseif type(arg_9_0.db.chr) == "table" then
			var_9_4 = arg_9_0.db.chr
		end
		
		if type(var_9_4) ~= "table" then
			return 
		end
		
		local var_9_5 = arg_9_0:getCurCount()
		local var_9_6
		local var_9_7
		
		for iter_9_2, iter_9_3 in pairs(var_9_4) do
			local var_9_8 = Account:getUnitsByCode(iter_9_3)
			
			if #var_9_8 > 0 then
				for iter_9_4, iter_9_5 in pairs(var_9_8) do
					if iter_9_5:getFavLevel() >= tonumber(arg_9_0.db.level) then
						var_9_6 = iter_9_5.inst.code
						var_9_7 = iter_9_5.inst.uid
						
						break
					end
				end
			end
			
			if var_9_6 and var_9_7 then
				break
			end
		end
		
		if var_9_6 and var_9_7 then
			arg_9_0:doCountAdd()
			arg_9_0:checkDone()
			
			arg_9_0:getVerifyParams().uid = var_9_7
		end
	end
end

AdinEvoGradeCondition = ClassDef(Condition_New)

function AdinEvoGradeCondition.constructor(arg_10_0)
end

function AdinEvoGradeCondition.getAcceptEvents(arg_11_0)
	return {
		"unit.evoGrade",
		"sync.adin"
	}
end

function AdinEvoGradeCondition.onEvent(arg_12_0, arg_12_1, arg_12_2)
	if tonumber(arg_12_0.db.count) ~= 1 then
		return 
	end
	
	if arg_12_0:getCurCount() >= 1 then
		return 
	end
	
	arg_12_2 = arg_12_2 or {}
	
	if arg_12_1 == "unit.evoGrade" and arg_12_2.chrid and arg_12_2.grade then
		local var_12_0 = arg_12_2.grade
		local var_12_1 = arg_12_2.chrid
		
		if EpisodeAdin:isAdinCode(var_12_1) and tonumber(arg_12_0.db.grade) <= tonumber(var_12_0) then
			arg_12_0:doCountAdd()
			arg_12_0:checkDone()
		end
	elseif arg_12_1 == "sync.adin" then
		local var_12_2 = Account:getAdin()
		
		if var_12_2 then
			local var_12_3 = var_12_2:getGrade()
			
			if tonumber(arg_12_0.db.grade) <= tonumber(var_12_3) then
				arg_12_0:doCountAdd()
				arg_12_0:checkDone()
			end
		end
	end
end

AdinZodiacCondition = ClassDef(Condition_New)

function AdinZodiacCondition.constructor(arg_13_0)
end

function AdinZodiacCondition.getAcceptEvents(arg_14_0)
	return {
		"unit.zodiac",
		"sync.adin"
	}
end

function AdinZodiacCondition.onEvent(arg_15_0, arg_15_1, arg_15_2)
	if tonumber(arg_15_0.db.count) ~= 1 then
		return 
	end
	
	if arg_15_1 == "unit.zodiac" and arg_15_2.unit then
		if not EpisodeAdin:isAdinCode(arg_15_2.unit.db.code) then
			return 
		end
		
		if tonumber(arg_15_0.db.level) <= tonumber(arg_15_2.level) then
			arg_15_0:doCountAdd()
			arg_15_0:checkDone()
		end
	end
	
	if arg_15_1 == "sync.adin" then
		local var_15_0 = Account:getAdin()
		
		if not var_15_0 then
			return 
		end
		
		local var_15_1 = var_15_0:getZodiacGrade()
		
		if tonumber(arg_15_0.db.level) <= tonumber(var_15_1) then
			arg_15_0:doCountAdd()
			arg_15_0:checkDone()
		end
	end
end

AdinFavLevelCondition = ClassDef(Condition_New)

function AdinFavLevelCondition.constructor(arg_16_0)
end

function AdinFavLevelCondition.getAcceptEvents(arg_17_0)
	return {
		"fav.levelup",
		"sync.adin"
	}
end

function AdinFavLevelCondition.onEvent(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_1 == "fav.levelup" then
		if tonumber(arg_18_0.db.level) <= arg_18_2.level and tonumber(arg_18_0.db.level) > arg_18_2.prev_level and EpisodeAdin:isAdinCode(arg_18_2.code) then
			arg_18_0:doCountAdd()
			arg_18_0:checkDone()
			
			arg_18_0:getVerifyParams().uid = arg_18_2.uid
		end
	elseif arg_18_1 == "sync.adin" and tonumber(arg_18_0.db.count) == 1 then
		local var_18_0 = Account:getAdin()
		
		if var_18_0 and var_18_0:getFavLevel() >= tonumber(arg_18_0.db.level) then
			arg_18_0:doCountAdd()
			arg_18_0:checkDone()
			
			arg_18_0:getVerifyParams().uid = var_18_0.uid
		end
	end
end

MaxLevelContentCondition = ClassDef(Condition_New)

function MaxLevelContentCondition.constructor(arg_19_0)
end

function MaxLevelContentCondition.getAcceptEvents(arg_20_0)
	return {
		"penguin.maxlevel"
	}
end

function MaxLevelContentCondition.onEvent(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_1 == "penguin.maxlevel" then
		local var_21_0 = arg_21_2.content
		
		if arg_21_0.db.content and arg_21_0.db.content == var_21_0 and arg_21_2.prev_level and arg_21_2.level and arg_21_2.unit and arg_21_2.unit:isMaxLevel() and tonumber(arg_21_2.prev_level) < tonumber(arg_21_2.level) then
			arg_21_0:doCountAdd()
			arg_21_0:checkDone()
		end
	end
end

CharacterDevoteCondition = ClassDef(Condition_New)

function CharacterDevoteCondition.constructor(arg_22_0)
end

function CharacterDevoteCondition.getAcceptEvents(arg_23_0)
	return {
		"devote.levelup"
	}
end

function CharacterDevoteCondition.onEvent(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_1 == "devote.levelup" and tonumber(arg_24_0.db.grade) <= tonumber(arg_24_2.devote) and tonumber(arg_24_0.db.grade) > tonumber(arg_24_2.prev_devote) then
		arg_24_0:doCountAdd()
		arg_24_0:checkDone()
		
		arg_24_0:getVerifyParams().uid = arg_24_2.uid
	end
end

CharacterEvoGradeCondition = ClassDef(Condition_New)

function CharacterEvoGradeCondition.constructor(arg_25_0)
end

function CharacterEvoGradeCondition.getAcceptEvents(arg_26_0)
	return {
		"unit.evoGrade"
	}
end

function CharacterEvoGradeCondition.onEvent(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_1 == "unit.evoGrade" then
		local var_27_0 = arg_27_0.db.grade == "all" or arg_27_2.prev_grade < tonumber(arg_27_0.db.grade) and arg_27_2.grade >= tonumber(arg_27_0.db.grade)
		
		if arg_27_0.db.chrid then
			if (arg_27_0.db.chrid == "all" or arg_27_0:checkMultikey(arg_27_0.db.chrid, arg_27_2.chrid)) and var_27_0 then
				arg_27_0:doCountAdd()
				arg_27_0:checkDone()
			end
		elseif var_27_0 then
			arg_27_0:doCountAdd()
			arg_27_0:checkDone()
		end
	end
end

ZodiacEnhanceCondition = ClassDef(Condition_New)

function ZodiacEnhanceCondition.constructor(arg_28_0)
end

function ZodiacEnhanceCondition.getAcceptEvents(arg_29_0)
	return {
		"unit.zodiac"
	}
end

function ZodiacEnhanceCondition.onEvent(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_1 == "unit.zodiac" and (arg_30_0.db.grade == "all" or arg_30_0:checkMultikey(tonumber(arg_30_0.db.grade), arg_30_2.grade)) and arg_30_2.pre_level and arg_30_2.level and tonumber(arg_30_0.db.level) > tonumber(arg_30_2.pre_level) and tonumber(arg_30_0.db.level) <= tonumber(arg_30_2.level) then
		arg_30_0:doCountAdd()
		arg_30_0:checkDone()
	end
end

CharacterUpgradeCondition = ClassDef(Condition_New)

function CharacterUpgradeCondition.constructor(arg_31_0)
end

function CharacterUpgradeCondition.getAcceptEvents(arg_32_0)
	return {
		"penguin.upgrade"
	}
end

function CharacterUpgradeCondition.onEvent(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_1 == "penguin.upgrade" then
		arg_33_0:doCountAdd(arg_33_2.count or 1)
		arg_33_0:checkDone()
	end
end

GetAchievePointCondition = ClassDef(Condition_New)

function GetAchievePointCondition.constructor(arg_34_0)
end

function GetAchievePointCondition.getAcceptEvents(arg_35_0)
	return {
		"achivepoint.get"
	}
end

function GetAchievePointCondition.onEvent(arg_36_0, arg_36_1, arg_36_2)
	if arg_36_1 == "achivepoint.get" then
		arg_36_0:doCountAdd(arg_36_2.value)
		arg_36_0:checkDone()
	end
end

GetFactionPointCondition = ClassDef(Condition_New)

function GetFactionPointCondition.constructor(arg_37_0)
end

function GetFactionPointCondition.getAcceptEvents(arg_38_0)
	return {
		"factionpoint.get"
	}
end

function GetFactionPointCondition.onEvent(arg_39_0, arg_39_1, arg_39_2)
	if arg_39_1 == "factionpoint.get" and arg_39_0.db.faction then
		local var_39_0 = Account:getFactionExp(arg_39_0.db.faction) - arg_39_0.cur_count
		
		if var_39_0 > 0 then
			arg_39_0:doCountAdd(var_39_0)
			arg_39_0:checkDone()
		end
	end
end

GetFactionPointConditionV2 = ClassDef(Condition_New)

function GetFactionPointConditionV2.constructor(arg_40_0)
end

function GetFactionPointConditionV2.getAcceptEvents(arg_41_0)
	return {
		"factionpoint.get"
	}
end

function GetFactionPointConditionV2.onEvent(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0.db.faction or not arg_42_0.db.point or to_n(arg_42_0.db.count) ~= 1 then
		Log.e("GetFactionPointConditionV2", "invalid condition value.")
		
		return 
	end
	
	if arg_42_1 == "factionpoint.get" then
		local var_42_0 = 0
		
		if type(arg_42_0.db.faction) == "table" then
			for iter_42_0, iter_42_1 in pairs(arg_42_0.db.faction) do
				var_42_0 = var_42_0 + Account:getFactionExp(iter_42_1)
			end
		else
			var_42_0 = Account:getFactionExp(arg_42_0.db.faction)
		end
		
		if var_42_0 >= to_n(arg_42_0.db.point) then
			arg_42_0:doCountAdd()
			arg_42_0:checkDone()
		end
	end
end

UserLevelUpCondition = ClassDef(Condition_New)

function UserLevelUpCondition.constructor(arg_43_0)
end

function UserLevelUpCondition.getAcceptEvents(arg_44_0)
	return {
		"user.levelup"
	}
end

function UserLevelUpCondition.onEvent(arg_45_0, arg_45_1, arg_45_2)
	if arg_45_1 == "user.levelup" then
		local var_45_0 = arg_45_0:getCurCount()
		
		if var_45_0 < arg_45_2.level then
			arg_45_0:doCountAdd(arg_45_2.level - var_45_0)
			arg_45_0:checkDone()
		end
	end
end

GetItemConditon = ClassDef(Condition_New)

function GetItemConditon.constructor(arg_46_0)
end

function GetItemConditon.getAcceptEvents(arg_47_0)
	return {
		"token.get"
	}
end

function GetItemConditon.onEvent(arg_48_0, arg_48_1, arg_48_2)
	if arg_48_0.db.tokentype == "stamina" then
		return Log.e("GetItemConditon", "no_stamina")
	end
	
	if arg_48_1 == "token.get" then
		local var_48_0 = false
		
		if arg_48_0.db.content and arg_48_0.db.content == "all" then
			var_48_0 = true
		elseif arg_48_0.db.content then
			if arg_48_2.content and arg_48_0:checkMultikey(arg_48_0.db.content, arg_48_2.content) then
				var_48_0 = true
			end
		else
			var_48_0 = true
		end
		
		if var_48_0 and (arg_48_0.db.tokentype == arg_48_2.tokentype or arg_48_0.db.tokentype == "to_" .. arg_48_2.tokentype) then
			arg_48_0:doCountAdd(arg_48_2.value)
			arg_48_0:checkDone()
		end
	end
end

HoldCurrencyCondition = ClassDef(Condition_New)

function HoldCurrencyCondition.constructor(arg_49_0)
end

function HoldCurrencyCondition.getAcceptEvents(arg_50_0)
	return {
		"token.get"
	}
end

function HoldCurrencyCondition.onEvent(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0.db.tokentype or not arg_51_0.db.tokenvalue or to_n(arg_51_0.db.count) ~= 1 then
		Log.e("HoldCurrencyCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_51_1 == "token.get" then
		if not arg_51_2.tokentype or not arg_51_2.now_value then
			Log.e("HoldCurrencyCondition:token.get", "invalid params.")
			
			return 
		end
		
		if (arg_51_2.tokentype == arg_51_0.db.tokentype or "to_" .. arg_51_2.tokentype == arg_51_0.db.tokentype) and arg_51_2.now_value >= to_n(arg_51_0.db.tokenvalue) then
			arg_51_0:doCountAdd()
			arg_51_0:checkDone()
		end
	end
end

BuyItemConditon = ClassDef(Condition_New)

function BuyItemConditon.constructor(arg_52_0)
end

function BuyItemConditon.getAcceptEvents(arg_53_0)
	return {
		"token.buy",
		"category.buy"
	}
end

function BuyItemConditon.onEvent(arg_54_0, arg_54_1, arg_54_2)
	if arg_54_1 == "token.buy" then
		local var_54_0 = false
		
		if arg_54_0.db.content and arg_54_0.db.content == "all" then
			var_54_0 = true
		elseif arg_54_0.db.content then
			if arg_54_2.content and arg_54_0:checkMultikey(arg_54_0.db.content, arg_54_2.content) then
				var_54_0 = true
			end
		else
			var_54_0 = true
		end
		
		if var_54_0 and (arg_54_0.db.tokentype == arg_54_2.tokentype or arg_54_0.db.tokentype == "to_" .. arg_54_2.tokentype) then
			arg_54_0:doCountAdd(arg_54_2.value)
			arg_54_0:checkDone()
		end
	elseif arg_54_1 == "category.buy" and arg_54_0.db.shopcategory and arg_54_0.db.shopcategory == arg_54_2.category then
		arg_54_0:doCountAdd()
		arg_54_0:checkDone()
	end
end

ShopCondition = ClassDef(Condition_New)

function ShopCondition.constructor(arg_55_0)
end

function ShopCondition.getAcceptEvents(arg_56_0)
	return {
		"shop.buy"
	}
end

function ShopCondition.onEvent(arg_57_0, arg_57_1, arg_57_2)
	if arg_57_1 == "shop.buy" and arg_57_0.db.shopid and arg_57_0:checkMultikey(arg_57_0.db.shopid, arg_57_2.shopid) then
		arg_57_0:doCountAdd()
		arg_57_0:checkDone()
	end
end

BuyStoneCondition = ClassDef(Condition_New)

function BuyStoneCondition.constructor(arg_58_0)
end

function BuyStoneCondition.getAcceptEvents(arg_59_0)
	return {
		"shop.buystone"
	}
end

function BuyStoneCondition.onEvent(arg_60_0, arg_60_1, arg_60_2)
	if arg_60_1 == "shop.buystone" and arg_60_0.db.shopid then
		if arg_60_0.db.shopid and type(arg_60_0.db.shopid) ~= "table" then
			arg_60_0.db.shopid = {
				arg_60_0.db.shopid
			}
		end
		
		local var_60_0 = 0
		
		for iter_60_0, iter_60_1 in pairs(arg_60_0.db.shopid) do
			local var_60_1 = "sh:" .. iter_60_1
			local var_60_2 = Account:getLimitCount(var_60_1)
			
			if to_n(var_60_2) > 0 then
				var_60_0 = var_60_0 + var_60_2
			end
		end
		
		local var_60_3 = arg_60_0:getCurCount()
		
		if var_60_3 < var_60_0 then
			arg_60_0:doCountAdd(var_60_0 - var_60_3)
			arg_60_0:checkDone()
		end
	end
end

UseItemConditon = ClassDef(Condition_New)

function UseItemConditon.constructor(arg_61_0)
end

function UseItemConditon.getAcceptEvents(arg_62_0)
	return {
		"token.use"
	}
end

function UseItemConditon.onEvent(arg_63_0, arg_63_1, arg_63_2)
	if arg_63_0.db.tokentype == "stamina" and arg_63_2.content == "subtask" then
		return 
	end
	
	if arg_63_1 == "token.use" and (arg_63_0.db.tokentype == arg_63_2.tokentype or arg_63_0.db.tokentype == "to_" .. arg_63_2.tokentype) then
		arg_63_0:doCountAdd(arg_63_2.value)
		arg_63_0:checkDone()
	end
end

CollectionCondition = ClassDef(Condition_New)

function CollectionCondition.constructor(arg_64_0)
end

function CollectionCondition.getAcceptEvents(arg_65_0)
	return {
		"collection.get"
	}
end

function CollectionCondition.onEvent(arg_66_0, arg_66_1, arg_66_2)
	arg_66_2 = arg_66_2 or {}
	
	if arg_66_1 == "collection.get" then
		local var_66_0, var_66_1 = DB("dic_data", arg_66_2.code, {
			"type",
			"type_detail"
		})
		local var_66_2 = 1
		
		if arg_66_2.force_type then
			var_66_1 = arg_66_2.force_type
			var_66_2 = 0
		end
		
		if var_66_1 ~= arg_66_0.db.chrtype and arg_66_0.db.chrtype ~= "all" then
			return 
		end
		
		for iter_66_0 = 1, 9999 do
			local var_66_3, var_66_4, var_66_5, var_66_6 = DBN("dic_data", iter_66_0, {
				"id",
				"type",
				"type_detail",
				"no_condition"
			})
			
			if var_66_3 == nil then
				break
			end
			
			if var_66_4 == "character" and (arg_66_0.db.chrtype == var_66_5 or arg_66_0.db.chrtype == "all") and var_66_6 ~= "y" and Account:getCollectionUnit(var_66_3) then
				var_66_2 = var_66_2 + 1
			end
		end
		
		if var_66_2 > arg_66_0:getCalcCurCount() then
			arg_66_0:doCountAdd(var_66_2 - arg_66_0:getCalcCurCount())
			arg_66_0:checkDone()
		end
	end
end

ClassChangeCondition = ClassDef(Condition_New)

function ClassChangeCondition.constructor(arg_67_0)
end

function ClassChangeCondition.getAcceptEvents(arg_68_0)
	return {
		"sync.classchange"
	}
end

function ClassChangeCondition.onEvent(arg_69_0, arg_69_1, arg_69_2)
	arg_69_2 = arg_69_2 or {}
	
	if arg_69_1 == "sync.classchange" then
		local var_69_0 = 0
		
		for iter_69_0 = 1, 9999 do
			local var_69_1, var_69_2 = DBN("classchange_category", iter_69_0, {
				"id",
				"char_id"
			})
			
			if not var_69_1 then
				break
			end
			
			local var_69_3 = Account:getClassChangeInfoByCode(var_69_2)
			
			if var_69_3 and var_69_3.state and var_69_3.state >= 2 then
				var_69_0 = var_69_0 + 1
			end
		end
		
		if var_69_0 > arg_69_0:getCalcCurCount() then
			arg_69_0:doCountAdd(var_69_0 - arg_69_0:getCalcCurCount())
			arg_69_0:checkDone()
		end
	end
end

CollectionEquipCondition = ClassDef(Condition_New)

function CollectionEquipCondition.constructor(arg_70_0)
end

function CollectionEquipCondition.getAcceptEvents(arg_71_0)
	return {
		"collectionequip.get"
	}
end

function CollectionEquipCondition.onEvent(arg_72_0, arg_72_1, arg_72_2)
	arg_72_2 = arg_72_2 or {}
	
	if arg_72_1 == "collectionequip.get" then
		local var_72_0 = 1
		local var_72_1, var_72_2 = DB("dic_data", arg_72_2.code, {
			"type",
			"type_detail"
		})
		
		if arg_72_2.force_type then
			var_72_2 = arg_72_2.force_type
			var_72_0 = 0
		end
		
		if var_72_2 ~= arg_72_0.db.equiptype and arg_72_0.db.equiptype ~= "all" then
			return 
		end
		
		for iter_72_0 = 1, 9999 do
			local var_72_3, var_72_4, var_72_5, var_72_6 = DBN("dic_data", iter_72_0, {
				"id",
				"type",
				"type_detail",
				"no_condition"
			})
			
			if var_72_3 == nil then
				break
			end
			
			if var_72_4 == "equip" and (arg_72_0.db.equiptype == var_72_5 or arg_72_0.db.equiptype == "all") and var_72_6 ~= "y" and Account:getCollectionEquip(var_72_3) then
				var_72_0 = var_72_0 + 1
			end
		end
		
		if var_72_0 > arg_72_0:getCalcCurCount() then
			arg_72_0:doCountAdd(var_72_0 - arg_72_0:getCalcCurCount())
			arg_72_0:checkDone()
		end
	end
end

CollectionPetCondition = ClassDef(Condition_New)

function CollectionPetCondition.constructor(arg_73_0)
end

function CollectionPetCondition.getAcceptEvents(arg_74_0)
	return {
		"collectionpet.get"
	}
end

function CollectionPetCondition.onEvent(arg_75_0, arg_75_1, arg_75_2)
	arg_75_2 = arg_75_2 or {}
	
	if arg_75_1 == "collectionpet.get" then
		local var_75_0, var_75_1 = DB("dic_data", arg_75_2.code, {
			"type",
			"type_detail"
		})
		local var_75_2 = 1
		
		if arg_75_2.force_type then
			var_75_1 = arg_75_2.force_type
			var_75_2 = 0
		end
		
		if var_75_1 ~= arg_75_0.db.chrtype and arg_75_0.db.chrtype ~= "all" then
			return 
		end
		
		for iter_75_0 = 1, 9999 do
			local var_75_3, var_75_4, var_75_5, var_75_6 = DBN("dic_data", iter_75_0, {
				"id",
				"type",
				"type_detail",
				"no_condition"
			})
			
			if var_75_3 == nil then
				break
			end
			
			if var_75_4 == "pet" and (arg_75_0.db.chrtype == var_75_5 or arg_75_0.db.chrtype == "all") and var_75_6 ~= "y" and Account:getCollectionPet(var_75_3) then
				var_75_2 = var_75_2 + 1
			end
		end
		
		if var_75_2 > arg_75_0:getCalcCurCount() then
			arg_75_0:doCountAdd(var_75_2 - arg_75_0:getCalcCurCount())
			arg_75_0:checkDone()
		end
	end
end

PetLevelCondition = ClassDef(Condition_New)

function PetLevelCondition.constructor(arg_76_0)
end

function PetLevelCondition.getAcceptEvents(arg_77_0)
	return {
		"pet.levelup"
	}
end

function PetLevelCondition.onEvent(arg_78_0, arg_78_1, arg_78_2)
	if arg_78_1 == "pet.levelup" and tonumber(arg_78_0.db.level) <= arg_78_2.level and tonumber(arg_78_0.db.level) > arg_78_2.prev_level then
		arg_78_0:doCountAdd()
		arg_78_0:checkDone()
	end
end

PetGachaCondition = ClassDef(Condition_New)

function PetGachaCondition.constructor(arg_79_0)
end

function PetGachaCondition.getAcceptEvents(arg_80_0)
	return {
		"pet.gacha"
	}
end

function PetGachaCondition.onEvent(arg_81_0, arg_81_1, arg_81_2)
	if arg_81_1 == "pet.gacha" then
		arg_81_0:doCountAdd(1)
		arg_81_0:checkDone()
	end
end

PetCareCondition = ClassDef(Condition_New)

function PetCareCondition.constructor(arg_82_0)
end

function PetCareCondition.getAcceptEvents(arg_83_0)
	return {
		"pet.care"
	}
end

function PetCareCondition.onEvent(arg_84_0, arg_84_1, arg_84_2)
	if arg_84_1 == "pet.care" then
		arg_84_0:doCountAdd(1)
		arg_84_0:checkDone()
	end
end

PetEnchanceCondition = ClassDef(Condition_New)

function PetEnchanceCondition.constructor(arg_85_0)
end

function PetEnchanceCondition.getAcceptEvents(arg_86_0)
	return {
		"pet.enchance"
	}
end

function PetEnchanceCondition.onEvent(arg_87_0, arg_87_1, arg_87_2)
	if arg_87_1 == "pet.enchance" then
		arg_87_0:doCountAdd(1)
		arg_87_0:checkDone()
	end
end

GetCharCondition = ClassDef(Condition_New)

function GetCharCondition.constructor(arg_88_0)
end

function GetCharCondition.getAcceptEvents(arg_89_0)
	return {
		"character.get",
		"sync.destiny"
	}
end

function GetCharCondition.onEvent(arg_90_0, arg_90_1, arg_90_2)
	if arg_90_1 == "sync.destiny" and arg_90_0.db.content == "chrrwd" then
		local var_90_0 = Account:getDestinyData()
		
		if arg_90_0.db.chrid == "all" then
			local var_90_1 = 0
			
			for iter_90_0, iter_90_1 in pairs(var_90_0) do
				if iter_90_1 == true then
					var_90_1 = var_90_1 + 1
				end
			end
			
			local var_90_2 = arg_90_0:getCurCount()
			
			if var_90_2 < var_90_1 then
				arg_90_0:doCountAdd(var_90_1 - var_90_2)
				arg_90_0:checkDone()
			end
		elseif arg_90_0.db.chrid == "c3026" then
			if arg_90_0:getCurCount() < 1 and var_90_0.de_4_c3026 then
				arg_90_0:doCountAdd()
			end
		elseif arg_90_0.db.chrid == "c1087" and arg_90_0:getCurCount() < 1 and var_90_0.de_4_c1087 then
			arg_90_0:doCountAdd()
		end
	elseif arg_90_1 == "character.get" then
		local var_90_3 = false
		
		var_90_3 = arg_90_0.db.content == "all" and true or arg_90_0.db.content and arg_90_2.content and arg_90_0:checkMultikey(arg_90_0.db.content, arg_90_2.content) and true or var_90_3
		
		if var_90_3 and (arg_90_0.db.chrid == "all" or arg_90_0:checkMultikey(arg_90_0.db.chrid, arg_90_2.code)) then
			arg_90_0:doCountAdd()
			arg_90_0:checkDone()
		end
	end
end

EquipUpgradeCondition = ClassDef(Condition_New)

function EquipUpgradeCondition.constructor(arg_91_0)
end

function EquipUpgradeCondition.getAcceptEvents(arg_92_0)
	return {
		"equip.upgrade"
	}
end

function EquipUpgradeCondition.onEvent(arg_93_0, arg_93_1, arg_93_2)
	if arg_93_1 == "equip.upgrade" and (arg_93_0.db.equiptype == "all" or arg_93_0:checkMultikey(arg_93_0.db.equiptype, arg_93_2.equiptype)) then
		arg_93_0:doCountAdd(arg_93_2.count or 1)
		arg_93_0:checkDone()
	end
end

EquipRefineCondition = ClassDef(Condition_New)

function EquipRefineCondition.constructor(arg_94_0)
end

function EquipRefineCondition.getAcceptEvents(arg_95_0)
	return {
		"equip.refine"
	}
end

function EquipRefineCondition.onEvent(arg_96_0, arg_96_1, arg_96_2)
	if arg_96_1 == "equip.refine" and arg_96_0.db.equiptype and arg_96_2.equip then
		local var_96_0 = arg_96_2.equip.db.type
		
		if arg_96_0.db.equiptype == "all" or arg_96_0:checkMultikey(arg_96_0.db.equiptype, var_96_0) then
			arg_96_0:doCountAdd(arg_96_2.count or 1)
			arg_96_0:checkDone()
		end
	end
end

EquipWearCondition = ClassDef(Condition_New)

function EquipWearCondition.constructor(arg_97_0)
end

function EquipWearCondition.getAcceptEvents(arg_98_0)
	return {
		"equip.wear"
	}
end

function EquipWearCondition.onEvent(arg_99_0, arg_99_1, arg_99_2)
	if arg_99_0:getCurCount() >= 1 then
		return 
	end
	
	if arg_99_1 == "equip.wear" and (arg_99_0.db.equiptype == "all" or arg_99_0:checkMultikey(arg_99_0.db.equiptype, arg_99_2.equiptype)) and (arg_99_0.db.chrid == "all" or arg_99_0.db.chrid == arg_99_2.charid) and (tonumber(arg_99_0.db.level) == 0 or tonumber(arg_99_0.db.level) <= tonumber(arg_99_2.level)) then
		arg_99_0:doCountAdd(arg_99_2.count or 1)
		arg_99_0:checkDone()
	end
end

EquipEnhanceCondition = ClassDef(Condition_New)

function EquipEnhanceCondition.constructor(arg_100_0)
end

function EquipEnhanceCondition.getAcceptEvents(arg_101_0)
	return {
		"equip.upgrade"
	}
end

function EquipEnhanceCondition.onEvent(arg_102_0, arg_102_1, arg_102_2)
	if arg_102_1 == "equip.upgrade" and (arg_102_0.db.equiptype == "all" or arg_102_0:checkMultikey(arg_102_0.db.equiptype, arg_102_2.equiptype)) and arg_102_2.pre_level and arg_102_2.level and tonumber(arg_102_0.db.level) > tonumber(arg_102_2.pre_level) and tonumber(arg_102_0.db.level) <= tonumber(arg_102_2.level) then
		arg_102_0:doCountAdd()
		arg_102_0:checkDone()
	end
end

CharSkillEnhanceCondition = ClassDef(Condition_New)

function CharSkillEnhanceCondition.constructor(arg_103_0)
end

function CharSkillEnhanceCondition.getAcceptEvents(arg_104_0)
	return {
		"unit.skillup"
	}
end

function CharSkillEnhanceCondition.onEvent(arg_105_0, arg_105_1, arg_105_2)
	if arg_105_1 == "unit.skillup" and (arg_105_0.db.grade == "all" or arg_105_0:checkMultikey(arg_105_0.db.grade, arg_105_2.grade)) and tonumber(arg_105_0.db.level) > arg_105_2.pre_level and tonumber(arg_105_0.db.level) <= arg_105_2.level then
		arg_105_0:doCountAdd()
		arg_105_0:checkDone()
	end
end

CharSkillEnhanceCountCondition = ClassDef(Condition_New)

function CharSkillEnhanceCountCondition.constructor(arg_106_0)
end

function CharSkillEnhanceCountCondition.getAcceptEvents(arg_107_0)
	return {
		"unit.skillup"
	}
end

function CharSkillEnhanceCountCondition.onEvent(arg_108_0, arg_108_1, arg_108_2)
	if arg_108_1 == "unit.skillup" then
		arg_108_0:doCountAdd()
		arg_108_0:checkDone()
	end
end

EquipCraftCondition = ClassDef(Condition_New)

function EquipCraftCondition.constructor(arg_109_0)
end

function EquipCraftCondition.getAcceptEvents(arg_110_0)
	return {
		"equip.craft"
	}
end

function EquipCraftCondition.onEvent(arg_111_0, arg_111_1, arg_111_2)
	if arg_111_1 == "equip.craft" then
		if arg_111_0.db.equiptype then
			if arg_111_0.db.equiptype == "all" or arg_111_0.db.equiptype and arg_111_0:checkMultikey(arg_111_0.db.equiptype, arg_111_2.equiptype) then
				local var_111_0 = arg_111_2.add_count or 1
				
				arg_111_0:doCountAdd(var_111_0)
				arg_111_0:checkDone()
			end
		elseif arg_111_0.db.equipid then
			if arg_111_0.db.equipid == "all" or arg_111_0.db.equipid and arg_111_0:checkMultikey(arg_111_0.db.equipid, arg_111_2.code) then
				local var_111_1 = arg_111_2.add_count or 1
				
				arg_111_0:doCountAdd(var_111_1)
				arg_111_0:checkDone()
			end
		else
			local var_111_2 = arg_111_2.add_count or 1
			
			arg_111_0:doCountAdd(var_111_2)
			arg_111_0:checkDone()
		end
	end
end

EquipSkillLvUpCondition = ClassDef(Condition_New)

function EquipSkillLvUpCondition.constructor(arg_112_0)
end

function EquipSkillLvUpCondition.getAcceptEvents(arg_113_0)
	return {
		"equip.skilllevelup"
	}
end

function EquipSkillLvUpCondition.onEvent(arg_114_0, arg_114_1, arg_114_2)
	if arg_114_1 == "equip.skilllevelup" and (arg_114_0.db.equiptype == "all" or arg_114_0.db.equiptype == arg_114_2.equiptype) then
		arg_114_0:doCountAdd(arg_114_2.value)
		arg_114_0:checkDone()
	end
end

MaterialGetCondition = ClassDef(Condition_New)

function MaterialGetCondition.constructor(arg_115_0)
end

function MaterialGetCondition.getAcceptEvents(arg_116_0)
	return {
		"material.get"
	}
end

function MaterialGetCondition.onEvent(arg_117_0, arg_117_1, arg_117_2)
	if arg_117_1 == "material.get" then
		local var_117_0 = false
		
		if arg_117_0.db.content and arg_117_0.db.content == "all" then
			var_117_0 = true
		elseif arg_117_0.db.content then
			if arg_117_2.content and arg_117_0:checkMultikey(arg_117_0.db.content, arg_117_2.content) then
				var_117_0 = true
			end
		else
			var_117_0 = true
		end
		
		local var_117_1 = false
		
		if arg_117_0.db.entertype and arg_117_2.enter then
			local var_117_2 = DB("level_enter", arg_117_2.enter, {
				"type"
			})
			
			if type(arg_117_0.db.entertype) == "table" then
				for iter_117_0, iter_117_1 in pairs(arg_117_0.db.entertype) do
					if iter_117_1 == var_117_2 then
						var_117_1 = true
					end
				end
			elseif arg_117_0.db.entertype == var_117_2 then
				var_117_1 = true
			end
		end
		
		local var_117_3 = DB("item_material", arg_117_2.id, "ma_type")
		
		if var_117_0 and arg_117_0.db.materialid and (arg_117_0.db.materialid == "all" or arg_117_0:checkWildCard(arg_117_0.db.materialid, arg_117_2.id) or arg_117_0:checkMultikey(arg_117_0.db.materialid, arg_117_2.id)) then
			if arg_117_0.db.enter then
				if arg_117_2.enter and arg_117_0:checkMultikey(arg_117_0.db.enter, arg_117_2.enter) then
					arg_117_0:doCountAdd(arg_117_2.count or 1)
					arg_117_0:checkDone()
				end
			elseif arg_117_0.db.entertype then
				if arg_117_2.enter and var_117_1 then
					arg_117_0:doCountAdd(arg_117_2.count or 1)
					arg_117_0:checkDone()
				end
			else
				arg_117_0:doCountAdd(arg_117_2.count or 1)
				arg_117_0:checkDone()
			end
		elseif var_117_0 and arg_117_0.db.materialtype and var_117_3 and (arg_117_0.db.materialtype == "all" or arg_117_0:checkMultikey(arg_117_0.db.materialtype, var_117_3)) then
			arg_117_0:doCountAdd(arg_117_2.count or 1)
			arg_117_0:checkDone()
		end
	end
end

ClearMissionCondition = ClassDef(Condition_New)

function ClearMissionCondition.constructor(arg_118_0)
end

function ClearMissionCondition.getAcceptEvents(arg_119_0)
	return {
		"mission.clear"
	}
end

function ClearMissionCondition.onEvent(arg_120_0, arg_120_1, arg_120_2)
	if arg_120_1 == "mission.clear" then
		local var_120_0 = "battle"
		
		if arg_120_2.mission_type == CONTENTS_TYPE.URGENT_MISSION then
			var_120_0 = "time"
		end
		
		if arg_120_0.db.missiontype == "all" or arg_120_0:checkMultikey(arg_120_0.db.missiontype, var_120_0) then
			arg_120_0:doCountAdd()
			arg_120_0:checkDone()
		end
	end
end

GachaCondition = ClassDef(Condition_New)

function GachaCondition.constructor(arg_121_0)
end

function GachaCondition.getAcceptEvents(arg_122_0)
	return {
		"gacha.buy"
	}
end

function GachaCondition.onEvent(arg_123_0, arg_123_1, arg_123_2)
	if arg_123_1 == "gacha.buy" and (arg_123_0.db.gachaid == "all" or arg_123_0:checkMultikey(arg_123_0.db.gachaid, arg_123_2.gacha_id)) then
		arg_123_0:doCountAdd(arg_123_2.count or 1)
		arg_123_0:checkDone()
	end
end

SelectGachaCondition = ClassDef(Condition_New)

function SelectGachaCondition.constructor(arg_124_0)
end

function SelectGachaCondition.getAcceptEvents(arg_125_0)
	return {
		"gacha.select"
	}
end

function SelectGachaCondition.onEvent(arg_126_0, arg_126_1, arg_126_2)
	if arg_126_1 == "gacha.select" then
		local var_126_0 = AccountData.gacha_shop_info
		local var_126_1 = 0
		
		if var_126_0 and var_126_0.select_list then
			for iter_126_0, iter_126_1 in pairs(var_126_0.select_list or {}) do
				if iter_126_1 and iter_126_0 == iter_126_1.select_id and iter_126_1.used == true then
					var_126_1 = var_126_1 + 1
				end
			end
		end
		
		if var_126_1 > 0 then
			arg_126_0:doCountAdd()
			arg_126_0:checkDone()
		end
	end
end

SubTaskCondition = ClassDef(Condition_New)

function SubTaskCondition.constructor(arg_127_0)
end

function SubTaskCondition.getAcceptEvents(arg_128_0)
	return {
		"subtask.clear"
	}
end

function SubTaskCondition.onEvent(arg_129_0, arg_129_1, arg_129_2)
	if arg_129_1 == "subtask.clear" then
		arg_129_0:doCountAdd()
		arg_129_0:checkDone()
	end
end

ClanDonateCondition = ClassDef(Condition_New)

function ClanDonateCondition.constructor(arg_130_0)
end

function ClanDonateCondition.getAcceptEvents(arg_131_0)
	return {
		"clan.donate"
	}
end

function ClanDonateCondition.onEvent(arg_132_0, arg_132_1, arg_132_2)
	arg_132_2 = arg_132_2 or {}
	
	if arg_132_1 == "clan.donate" and arg_132_2.code and arg_132_2.code == arg_132_0.db.tokentype and arg_132_2.count then
		arg_132_0:doCountAdd(arg_132_2.count)
		arg_132_0:checkDone()
	end
end

ClanSupportCondition = ClassDef(Condition_New)

function ClanSupportCondition.constructor(arg_133_0)
end

function ClanSupportCondition.getAcceptEvents(arg_134_0)
	return {
		"clan.support"
	}
end

function ClanSupportCondition.onEvent(arg_135_0, arg_135_1, arg_135_2)
	if arg_135_1 == "clan.support" then
		arg_135_0:doCountAdd()
		arg_135_0:checkDone()
	end
end

ClanAttendenceCondition = ClassDef(Condition_New)

function ClanAttendenceCondition.constructor(arg_136_0)
end

function ClanAttendenceCondition.getAcceptEvents(arg_137_0)
	return {
		"clan.attendance"
	}
end

function ClanAttendenceCondition.onEvent(arg_138_0, arg_138_1, arg_138_2)
	if arg_138_1 == "clan.attendance" then
		arg_138_0:doCountAdd()
		arg_138_0:checkDone()
	end
end

LoginCondition = ClassDef(Condition_New)

function LoginCondition.constructor(arg_139_0)
end

function LoginCondition.getAcceptEvents(arg_140_0)
	return {
		"login.accumulate"
	}
end

function LoginCondition.onEvent(arg_141_0, arg_141_1, arg_141_2)
	if arg_141_1 == "login.accumulate" then
		local var_141_0 = arg_141_0:getCalcCurCount()
		
		if var_141_0 < arg_141_2.login_cnt then
			arg_141_0:doCountAdd(arg_141_2.login_cnt - var_141_0)
			arg_141_0:checkDone()
		end
	end
end

EventMissionLoginCondition = ClassDef(Condition_New)

function EventMissionLoginCondition.constructor(arg_142_0)
end

function EventMissionLoginCondition.getAcceptEvents(arg_143_0)
	return {
		"login.ev_mission"
	}
end

function EventMissionLoginCondition.onEvent(arg_144_0, arg_144_1, arg_144_2)
	if arg_144_1 == "login.ev_mission" then
		if arg_144_0.db.eventid == nil then
			return 
		end
		
		local var_144_0 = arg_144_0:getCurCount()
		
		if arg_144_0.db.eventid == arg_144_2.event_id and var_144_0 < arg_144_2.login_cnt then
			arg_144_0:doCountAdd(arg_144_2.login_cnt - var_144_0)
			arg_144_0:checkDone()
		end
	end
end

ContinueLoginCondition = ClassDef(Condition_New)

function ContinueLoginCondition.constructor(arg_145_0)
end

function ContinueLoginCondition.getAcceptEvents(arg_146_0)
	return {
		"login.continue"
	}
end

function ContinueLoginCondition.onEvent(arg_147_0, arg_147_1, arg_147_2)
	if not arg_147_0.db.day or to_n(arg_147_0.db.count) ~= 1 then
		Log.e("ContinueLoginCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_147_1 == "login.continue" then
		if not arg_147_2.continue_login_cnt then
			Log.e("ContinueLoginCondition:login.continue", "invalid params.")
			
			return 
		end
		
		if arg_147_2.continue_login_cnt >= to_n(arg_147_0.db.day) then
			arg_147_0:doCountAdd()
			arg_147_0:checkDone()
		end
	end
end

FriendCondition = ClassDef(Condition_New)

function FriendCondition.constructor(arg_148_0)
end

function FriendCondition.getAcceptEvents(arg_149_0)
	return {
		"friend.add"
	}
end

function FriendCondition.onEvent(arg_150_0, arg_150_1, arg_150_2)
	if arg_150_1 == "friend.add" then
		local var_150_0 = arg_150_0:getCurCount()
		
		if var_150_0 < arg_150_2.count then
			arg_150_0:doCountAdd(arg_150_2.count - var_150_0)
			arg_150_0:checkDone()
		end
	end
end

GiveCondition = ClassDef(Condition_New)

function GiveCondition.constructor(arg_151_0)
end

function GiveCondition.getAcceptEvents(arg_152_0)
	return {
		"destiny.give",
		"classchange.give",
		"chaptershop.give",
		"contents.give"
	}
end

function GiveCondition.onEvent(arg_153_0, arg_153_1, arg_153_2)
	if arg_153_1 == "contents.give" or arg_153_1 == "destiny.give" or arg_153_1 == "classchange.give" or arg_153_1 == "chaptershop.give" then
		local var_153_0 = arg_153_0:getCurCount()
		
		if arg_153_0.db.give == arg_153_2.give then
			arg_153_0:doCountAdd()
			arg_153_0:checkDone()
		end
	end
end

PvpLeagueCondition = ClassDef(Condition_New)

function PvpLeagueCondition.constructor(arg_154_0)
end

function PvpLeagueCondition.getAcceptEvents(arg_155_0)
	return {
		"pvp.league"
	}
end

function PvpLeagueCondition.onEvent(arg_156_0, arg_156_1, arg_156_2)
	if arg_156_1 == "pvp.league" then
		if arg_156_0:getCurCount() >= 1 then
			return 
		end
		
		if not AccountData.max_pvp_league then
			return 
		end
		
		local var_156_0 = PvpSA:getLeagueList()
		local var_156_1 = var_156_0[AccountData.max_pvp_league]
		local var_156_2 = var_156_0[arg_156_0.db.league]
		
		if type(var_156_2) ~= "number" then
			Log.e("pvpLeagueConditionDBError", arg_156_0.db.league)
			
			return 
		end
		
		if type(var_156_1) ~= "number" then
			Log.e("pvpLeagueConditionParamsError", var_156_1)
			
			return 
		end
		
		if var_156_1 <= var_156_2 then
			arg_156_0:doCountAdd()
			arg_156_0:checkDone()
		end
	end
end

PvpFameCondition = ClassDef(Condition_New)

function PvpFameCondition.constructor(arg_157_0)
end

function PvpFameCondition.getAcceptEvents(arg_158_0)
	return {
		"pvp.fame"
	}
end

function PvpFameCondition.onEvent(arg_159_0, arg_159_1, arg_159_2)
	if to_n(arg_159_0.db.count) ~= 1 then
		Log.e("PvpFameCondition", "invalid condition value.")
		
		return 
	end
	
	local var_159_0
	
	if arg_159_1 == "pvp.fame" then
		var_159_0 = Account:getUserId()
		
		for iter_159_0, iter_159_1 in pairs(arg_159_2.seasons or {}) do
			for iter_159_2, iter_159_3 in pairs(iter_159_1.winners or {}) do
				if iter_159_3.user_id == var_159_0 then
					arg_159_0:doCountAdd()
					arg_159_0:checkDone()
					
					return 
				end
			end
		end
	end
end

PvpRtaFameCondition = ClassDef(Condition_New)

function PvpRtaFameCondition.constructor(arg_160_0)
end

function PvpRtaFameCondition.getAcceptEvents(arg_161_0)
	return {
		"pvprta.fame"
	}
end

function PvpRtaFameCondition.onEvent(arg_162_0, arg_162_1, arg_162_2)
	if to_n(arg_162_0.db.count) ~= 1 then
		Log.e("PvpRtaFameCondition", "invalid condition value.")
		
		return 
	end
	
	local var_162_0
	
	if arg_162_1 == "pvprta.fame" then
		var_162_0 = to_n(MatchService:getArenaUID())
		
		if var_162_0 > 0 then
			for iter_162_0, iter_162_1 in pairs(arg_162_2.seasons or {}) do
				for iter_162_2, iter_162_3 in pairs(iter_162_1.users or {}) do
					if to_n(iter_162_3.arena_uid) == var_162_0 then
						arg_162_0:doCountAdd()
						arg_162_0:checkDone()
						
						return 
					end
				end
			end
		end
	end
end

PvpRtaLeagueCondition = ClassDef(Condition_New)

function PvpRtaLeagueCondition.constructor(arg_163_0)
end

function PvpRtaLeagueCondition.getAcceptEvents(arg_164_0)
	return {
		"pvprta.league"
	}
end

function PvpRtaLeagueCondition.onEvent(arg_165_0, arg_165_1, arg_165_2)
	if not arg_165_0.db.league or to_n(arg_165_0.db.count) ~= 1 then
		Log.e("PvpRtaLeagueCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_165_1 == "pvprta.league" then
		local var_165_0 = DB("pvp_rta", arg_165_0.db.league, {
			"order"
		})
		
		if not var_165_0 then
			Log.e("PvpRtaLeagueCondition:" .. arg_165_1, "invalid league id.")
			
			return 
		end
		
		local var_165_1 = DB("pvp_rta", AccountData.world_pvp_league, {
			"order"
		}) or math.huge
		local var_165_2 = DB("pvp_rta", AccountData.max_rta_league, {
			"order"
		}) or math.huge
		
		if var_165_0 >= math.min(var_165_1, var_165_2) then
			arg_165_0:doCountAdd()
			arg_165_0:checkDone()
		end
	end
end

ClearStarCondition = ClassDef(Condition_New)

function ClearStarCondition.constructor(arg_166_0)
end

function ClearStarCondition.getAcceptEvents(arg_167_0)
	return {
		"starmission.clear"
	}
end

function ClearStarCondition.getClearChapterMissionCount(arg_168_0, arg_168_1)
	local var_168_0 = 0
	
	for iter_168_0 = 1, 999 do
		local var_168_1 = arg_168_1 .. string.format("%03d", iter_168_0)
		local var_168_2, var_168_3, var_168_4, var_168_5 = DB("level_enter", var_168_1, {
			"id",
			"mission1",
			"mission2",
			"mission3"
		})
		
		if not var_168_2 then
			break
		end
		
		if var_168_3 and Account:isDungeonMissionClearedByMissionId(var_168_2, var_168_3) then
			var_168_0 = var_168_0 + 1
		end
		
		if var_168_4 and Account:isDungeonMissionClearedByMissionId(var_168_2, var_168_4) then
			var_168_0 = var_168_0 + 1
		end
		
		if var_168_5 and Account:isDungeonMissionClearedByMissionId(var_168_2, var_168_5) then
			var_168_0 = var_168_0 + 1
		end
	end
	
	return var_168_0
end

function ClearStarCondition.onEvent(arg_169_0, arg_169_1, arg_169_2)
	if arg_169_1 == "starmission.clear" then
		if not arg_169_2.enter_id then
			return 
		end
		
		local var_169_0 = false
		local var_169_1 = string.sub(arg_169_2.enter_id, 1, -4)
		
		if type(arg_169_0.db.chapid) == "table" then
			for iter_169_0, iter_169_1 in pairs(arg_169_0.db.chapid) do
				if iter_169_1 == var_169_1 then
					var_169_0 = true
					
					break
				end
			end
		elseif arg_169_0.db.chapid == var_169_1 then
			var_169_0 = true
		end
		
		if not var_169_0 then
			return 
		end
		
		local var_169_2 = 0
		
		if type(arg_169_0.db.chapid) == "table" then
			for iter_169_2, iter_169_3 in pairs(arg_169_0.db.chapid) do
				var_169_2 = var_169_2 + arg_169_0:getClearChapterMissionCount(iter_169_3)
			end
		else
			var_169_2 = var_169_2 + arg_169_0:getClearChapterMissionCount(arg_169_0.db.chapid)
		end
		
		local var_169_3 = arg_169_0:getCurCount()
		
		if var_169_3 < var_169_2 then
			arg_169_0:doCountAdd(var_169_2 - var_169_3)
			arg_169_0:checkDone()
		end
	end
end

HeroAwakenOverCondition = ClassDef(Condition_New)

function HeroAwakenOverCondition.constructor(arg_170_0)
end

function HeroAwakenOverCondition.getAcceptEvents(arg_171_0)
	return {
		"hero.awaken.count"
	}
end

function HeroAwakenOverCondition.onEvent(arg_172_0, arg_172_1, arg_172_2)
	if arg_172_1 == "hero.awaken.count" then
		if arg_172_0:getCurCount() >= tonumber(arg_172_0.db.count) then
			return 
		end
		
		if tonumber(arg_172_0.db.grade) <= arg_172_2.grade and tonumber(arg_172_0.db.level) <= arg_172_2.level then
			arg_172_0:doCountAdd()
			arg_172_0:checkDone()
		end
	end
end

StarRewardCondition = ClassDef(Condition_New)

function StarRewardCondition.constructor(arg_173_0)
end

function StarRewardCondition.getAcceptEvents(arg_174_0)
	return {
		"substory.star.reward"
	}
end

function StarRewardCondition.onEvent(arg_175_0, arg_175_1, arg_175_2)
	if arg_175_1 == "substory.star.reward" then
		if not arg_175_2 or arg_175_2.substory_id == nil or arg_175_2.substory_id == "" then
			return 
		end
		
		if arg_175_2.substory_id == arg_175_0.db.substoryid then
			if arg_175_0:getCurCount() >= 1 then
				return 
			end
			
			local var_175_0 = true
			local var_175_1 = SubstoryManager:getChapterIDList() or {}
			
			for iter_175_0, iter_175_1 in pairs(var_175_1) do
				if DB("level_world_3_chapter", iter_175_1, {
					"reward_star3"
				}) > (Account:getWorldmapReward(iter_175_1) or 0) then
					var_175_0 = false
					
					break
				end
			end
			
			if var_175_0 then
				arg_175_0:doCountAdd()
				arg_175_0:checkDone()
			end
		end
	end
end

SubStoryAchieveContentsState = ClassDef(Condition_New)

function SubStoryAchieveContentsState.constructor(arg_176_0)
end

function SubStoryAchieveContentsState.getAcceptEvents(arg_177_0)
	return {
		"subachieve.clear"
	}
end

function SubStoryAchieveContentsState.onEvent(arg_178_0, arg_178_1, arg_178_2)
	if arg_178_1 == "subachieve.clear" then
		local var_178_0 = arg_178_0.db.state
		local var_178_1 = ConditionContentsState:getClearData(var_178_0)
		
		if var_178_1 and var_178_1.is_cleared then
			arg_178_0:doCountAdd()
			arg_178_0:checkDone()
		end
	end
end

StoryMapCondition = ClassDef(Condition_New)

function StoryMapCondition.constructor(arg_179_0)
end

function StoryMapCondition.getAcceptEvents(arg_180_0, arg_180_1)
	return {
		"storymap.clear",
		"storymap.story"
	}
end

function StoryMapCondition.onEvent(arg_181_0, arg_181_1, arg_181_2)
	local var_181_0 = arg_181_2.unique_id
	
	if arg_181_1 == "storymap.clear" then
		if (arg_181_0:getVltCount(var_181_0) or 0) == 0 and (arg_181_0:getCurCount() or 0) == 0 then
			if type(arg_181_0.db.storyid) == "table" then
				for iter_181_0, iter_181_1 in pairs(arg_181_0.db.storyid) do
					if Account:isPlayedStory(iter_181_1) then
						arg_181_0:doCountVlt(var_181_0)
						
						break
					end
				end
			elseif Account:isPlayedStory(arg_181_0.db.storyid) then
				arg_181_0:doCountVlt(var_181_0)
			end
		end
		
		arg_181_0:doAccumulateCount(var_181_0)
		arg_181_0:checkDone()
	elseif arg_181_1 == "storymap.story" and arg_181_0:checkMultikey(arg_181_0.db.storyid, arg_181_2.storyid) then
		arg_181_0:doCountVlt(var_181_0)
	end
end

TournamentCondition = ClassDef(Condition_New)

function TournamentCondition.constructor(arg_182_0)
end

function TournamentCondition.getAcceptEvents(arg_183_0, arg_183_1)
	return {
		"tournament.clear",
		"sync.tournament"
	}
end

function TournamentCondition.onEvent(arg_184_0, arg_184_1, arg_184_2)
	if arg_184_1 == "tournament.clear" then
		if arg_184_0.db.tournament == arg_184_2.touranment_id then
			arg_184_0:doCountAdd()
			arg_184_0:checkDone()
		end
	elseif arg_184_1 == "sync.tournament" and Tournament:isWinResult(arg_184_0.db.tournament) then
		arg_184_0:doCountAdd()
		arg_184_0:checkDone()
	end
end

PetFavorabilityCondition = ClassDef(Condition_New)

function PetFavorabilityCondition.constructor(arg_185_0)
end

function PetFavorabilityCondition.getAcceptEvents(arg_186_0)
	return {
		"pet.favorability"
	}
end

function PetFavorabilityCondition.onEvent(arg_187_0, arg_187_1, arg_187_2)
	if arg_187_1 == "pet.favorability" and arg_187_2.prev_value and arg_187_2.value and arg_187_0.db.favorability and tonumber(arg_187_0.db.favorability) > tonumber(arg_187_2.prev_value) and tonumber(arg_187_0.db.favorability) <= tonumber(arg_187_2.value) then
		arg_187_0:doCountAdd()
		arg_187_0:checkDone()
	end
end

PetSynthesisCondition = ClassDef(Condition_New)

function PetSynthesisCondition.constructor(arg_188_0)
end

function PetSynthesisCondition.getAcceptEvents(arg_189_0)
	return {
		"pet.synthesis"
	}
end

function PetSynthesisCondition.onEvent(arg_190_0, arg_190_1, arg_190_2)
	if arg_190_1 == "pet.synthesis" and arg_190_0.db.grade and arg_190_2.grade and (arg_190_0.db.grade == "all" or tonumber(arg_190_0.db.grade) <= tonumber(arg_190_2.grade)) then
		arg_190_0:doCountAdd()
		arg_190_0:checkDone()
	end
end

AccountLinkCondition = ClassDef(Condition_New)

function AccountLinkCondition.constructor(arg_191_0)
end

function AccountLinkCondition.getAcceptEvents(arg_192_0)
	return {
		"account.link"
	}
end

function AccountLinkCondition.onEvent(arg_193_0, arg_193_1, arg_193_2)
	if arg_193_1 == "account.link" then
		if IS_PUBLISHER_ZLONG and Account:isMapCleared("ije010") and arg_193_0.cur_count < 1 then
			arg_193_0:doCountAdd()
			arg_193_0:checkDone()
		elseif Stove.enable and not Stove:isGuestAccount() and Account:isMapCleared("ije010") and arg_193_0.cur_count < 1 then
			arg_193_0:doCountAdd()
			arg_193_0:checkDone()
		end
	end
end

AlchemyCondition = ClassDef(Condition_New)

function AlchemyCondition.constructor(arg_194_0)
end

function AlchemyCondition.getAcceptEvents(arg_195_0)
	return {
		"alchemy.use"
	}
end

function AlchemyCondition.onEvent(arg_196_0, arg_196_1, arg_196_2)
	if arg_196_1 == "alchemy.use" then
		arg_196_0:doCountAdd()
		arg_196_0:checkDone()
	end
end

AlchemyEquipCondition = ClassDef(Condition_New)

function AlchemyEquipCondition.constructor(arg_197_0)
end

function AlchemyEquipCondition.getAcceptEvents(arg_198_0)
	return {
		"alchemy.equip"
	}
end

function AlchemyEquipCondition.onEvent(arg_199_0, arg_199_1, arg_199_2)
	if arg_199_1 == "alchemy.equip" and arg_199_0.db.equiptype and arg_199_2.equiptype and (arg_199_0:checkMultikey(arg_199_0.db.equiptype, arg_199_2.equiptype) or arg_199_0.db.equiptype == "all") then
		arg_199_0:doCountAdd()
		arg_199_0:checkDone()
	end
end

AchieveStoryCondition = ClassDef(Condition_New)

function AchieveStoryCondition.constructor(arg_200_0)
end

function AchieveStoryCondition.getAcceptEvents(arg_201_0)
	return {
		"story.achieve"
	}
end

function AchieveStoryCondition.onEvent(arg_202_0, arg_202_1, arg_202_2)
	if arg_202_1 == "story.achieve" and arg_202_2.storyid == arg_202_0.db.storyid then
		arg_202_0:doCountAdd()
		arg_202_0:checkDone()
	end
end

ForceCreditCondition = ClassDef(Condition_New)

function ForceCreditCondition.constructor(arg_203_0)
end

function ForceCreditCondition.getAcceptEvents(arg_204_0)
	return {
		"sync.force_credit"
	}
end

function ForceCreditCondition.onEvent(arg_205_0, arg_205_1, arg_205_2)
	if tonumber(arg_205_0.db.count) ~= 1 then
		return 
	end
	
	if arg_205_1 == "sync.force_credit" and arg_205_0.db and arg_205_0.db.force and arg_205_0.db.credit then
		local var_205_0 = "force_" .. arg_205_0.db.force
		
		if tonumber(arg_205_0.db.credit) <= tonumber(EpisodeForce:getForceGrade(var_205_0)) then
			arg_205_0:doCountAdd()
			arg_205_0:checkDone()
		end
	end
end

c3026ZodiacCondition = ClassDef(Condition_New)

function c3026ZodiacCondition.constructor(arg_206_0)
end

function c3026ZodiacCondition.getAcceptEvents(arg_207_0)
	return {
		"c3026.zodiac"
	}
end

function c3026ZodiacCondition.onEvent(arg_208_0, arg_208_1, arg_208_2)
	if tonumber(arg_208_0.db.count) ~= 1 then
		return 
	end
	
	if arg_208_1 == "c3026.zodiac" and arg_208_2.unit and type(arg_208_2.unit) == "table" then
		local var_208_0 = arg_208_2.unit:getZodiacGrade()
		
		if arg_208_2.unit.db.code == "c3026" and var_208_0 >= tonumber(arg_208_0.db.level) then
			arg_208_0:doCountAdd()
			arg_208_0:checkDone()
		end
	end
end

c3026CharSkillEnhanceCondition = ClassDef(Condition_New)

function c3026CharSkillEnhanceCondition.constructor(arg_209_0)
end

function c3026CharSkillEnhanceCondition.getAcceptEvents(arg_210_0)
	return {
		"c3026.skillup"
	}
end

function c3026CharSkillEnhanceCondition.onEvent(arg_211_0, arg_211_1, arg_211_2)
	if arg_211_1 == "c3026.skillup" and arg_211_2.unit and type(arg_211_2.unit) == "table" then
		local var_211_0 = arg_211_2.unit.inst.skill_lv
		local var_211_1 = arg_211_2.unit.db.code
		local var_211_2 = var_211_0[tonumber(arg_211_0.db.skill)] or 0
		local var_211_3 = arg_211_0:getCurCount()
		
		if var_211_1 == "c3026" and var_211_3 < var_211_2 then
			arg_211_0:doCountAdd(var_211_2 - var_211_3)
			arg_211_0:checkDone()
		end
	end
end

c3026CharacterLevelCondition = ClassDef(Condition_New)

function c3026CharacterLevelCondition.constructor(arg_212_0)
end

function c3026CharacterLevelCondition.getAcceptEvents(arg_213_0)
	return {
		"c3026.levelup"
	}
end

function c3026CharacterLevelCondition.onEvent(arg_214_0, arg_214_1, arg_214_2)
	if tonumber(arg_214_0.db.count) ~= 1 then
		return 
	end
	
	if arg_214_0:getCurCount() >= 1 then
		return 
	end
	
	if arg_214_1 == "c3026.levelup" and arg_214_2.unit and type(arg_214_2.unit) == "table" then
		local var_214_0 = arg_214_2.unit:getLv()
		local var_214_1 = arg_214_0:getCurCount()
		
		if arg_214_2.unit.db.code == "c3026" and tonumber(var_214_0) >= tonumber(arg_214_0.db.level) then
			arg_214_0:doCountAdd()
			arg_214_0:checkDone()
		end
	end
end

c3026CharacterEvoGradeCondition = ClassDef(Condition_New)

function c3026CharacterEvoGradeCondition.constructor(arg_215_0)
end

function c3026CharacterEvoGradeCondition.getAcceptEvents(arg_216_0)
	return {
		"c3026.evo.grade"
	}
end

function c3026CharacterEvoGradeCondition.onEvent(arg_217_0, arg_217_1, arg_217_2)
	if tonumber(arg_217_0.db.count) ~= 1 then
		return 
	end
	
	if arg_217_0:getCurCount() >= 1 then
		return 
	end
	
	local var_217_0 = arg_217_2.unit
	
	if arg_217_1 == "c3026.evo.grade" then
		if var_217_0 and type(var_217_0) == "table" then
			local var_217_1 = var_217_0:getGrade()
			
			if var_217_0.db.code == "c3026" and tonumber(arg_217_0.db.grade) <= tonumber(var_217_1) then
				arg_217_0:doCountAdd()
				arg_217_0:checkDone()
			end
		elseif arg_217_2.grade and arg_217_2.chrid and arg_217_2.chrid == "c3026" and tonumber(arg_217_0.db.grade) <= tonumber(arg_217_2.grade) then
			arg_217_0:doCountAdd()
			arg_217_0:checkDone()
		end
	end
end

c3026DvtGradeCondition = ClassDef(Condition_New)

function c3026DvtGradeCondition.constructor(arg_218_0)
end

function c3026DvtGradeCondition.getAcceptEvents(arg_219_0)
	return {
		"c3026.dvt.grade"
	}
end

function c3026DvtGradeCondition.onEvent(arg_220_0, arg_220_1, arg_220_2)
	if tonumber(arg_220_0.db.count) ~= 1 then
		return 
	end
	
	if arg_220_0:getCurCount() >= 1 then
		return 
	end
	
	local var_220_0 = arg_220_2.unit
	
	if arg_220_1 == "c3026.dvt.grade" then
		if var_220_0 and type(var_220_0) == "table" then
			local var_220_1 = var_220_0:getDevote()
			local var_220_2, var_220_3 = var_220_0:getDevoteGrade(var_220_1)
			
			if arg_220_2.unit.db.code == "c3026" and tonumber(var_220_3) >= tonumber(arg_220_0.db.grade) then
				arg_220_0:doCountAdd()
				arg_220_0:checkDone()
			end
		elseif arg_220_2.devote and arg_220_2.chrid and arg_220_2.chrid == "c3026" and tonumber(arg_220_2.devote) >= tonumber(arg_220_0.db.grade) then
			arg_220_0:doCountAdd()
			arg_220_0:checkDone()
		end
	end
end

c3026DvtSelfCondition = ClassDef(Condition_New)

function c3026DvtSelfCondition.constructor(arg_221_0)
end

function c3026DvtSelfCondition.getAcceptEvents(arg_222_0)
	return {
		"c3026.dvt.self"
	}
end

function c3026DvtSelfCondition.onEvent(arg_223_0, arg_223_1, arg_223_2)
	if tonumber(arg_223_0.db.count) ~= 1 then
		return 
	end
	
	if arg_223_0:getCurCount() >= 1 then
		return 
	end
	
	local var_223_0 = arg_223_2.unit
	
	if arg_223_1 == "c3026.dvt.self" and var_223_0 and type(var_223_0) == "table" then
		local var_223_1 = var_223_0:getUnitOptionValue("imprint_focus") == 2
		
		if arg_223_2.unit.db.code == "c3026" and var_223_1 then
			arg_223_0:doCountAdd()
			arg_223_0:checkDone()
		end
	end
end

efw15EquipSkillLvUpCondition = ClassDef(Condition_New)

function efw15EquipSkillLvUpCondition.constructor(arg_224_0)
end

function efw15EquipSkillLvUpCondition.getAcceptEvents(arg_225_0)
	return {
		"efw15.skilllevelup"
	}
end

function efw15EquipSkillLvUpCondition.onEvent(arg_226_0, arg_226_1, arg_226_2)
	if arg_226_1 == "efw15.skilllevelup" then
		local var_226_0 = arg_226_2.equip
		
		if not var_226_0 then
			return 
		end
		
		local var_226_1 = var_226_0.code
		local var_226_2 = var_226_0:getDupPoint()
		local var_226_3 = arg_226_0:getCurCount()
		
		if var_226_1 == "efw15" and var_226_2 > 0 and var_226_3 <= var_226_2 then
			arg_226_0:doCountAdd(var_226_2 - var_226_3)
			arg_226_0:checkDone()
		end
	end
end

MoonlightDestinyCondition = ClassDef(Condition_New)

function MoonlightDestinyCondition.constructor(arg_227_0)
end

function MoonlightDestinyCondition.getAcceptEvents(arg_228_0)
	return {
		"moonlight.change"
	}
end

function MoonlightDestinyCondition.onEvent(arg_229_0, arg_229_1, arg_229_2)
	if arg_229_1 == "moonlight.change" then
		arg_229_0:doCountAdd()
		arg_229_0:checkDone()
	end
end

VillageBuildingLevelCondition = ClassDef(Condition_New)

function VillageBuildingLevelCondition.constructor(arg_230_0)
end

function VillageBuildingLevelCondition.getAcceptEvents(arg_231_0)
	return {
		"village.building.lv"
	}
end

function VillageBuildingLevelCondition.onEvent(arg_232_0, arg_232_1, arg_232_2)
	if tonumber(arg_232_0.db.count) ~= 1 then
		return 
	end
	
	if arg_232_0:getCurCount() >= 1 then
		return 
	end
	
	if arg_232_1 == "village.building.lv" and arg_232_2.buildings and ((arg_232_2.buildings[arg_232_0.db.buildingid] or {}).lv or 1) >= to_n(arg_232_0.db.lv) then
		arg_232_0:doCountAdd()
		arg_232_0:checkDone()
	end
end

GrowthBoostLvCondition = ClassDef(Condition_New)

function GrowthBoostLvCondition.constructor(arg_233_0)
end

function GrowthBoostLvCondition.getAcceptEvents(arg_234_0)
	return {
		"growthboost.sync.lv"
	}
end

function GrowthBoostLvCondition.onEvent(arg_235_0, arg_235_1, arg_235_2)
	if tonumber(arg_235_0.db.count) ~= 1 then
		return 
	end
	
	if arg_235_0:getCurCount() >= 1 then
		return 
	end
	
	if arg_235_1 == "growthboost.sync.lv" then
		local var_235_0 = to_n(arg_235_0.db.level)
		local var_235_1 = 0
		
		for iter_235_0, iter_235_1 in pairs(Account:getUnits() or {}) do
			if var_235_1 >= 3 then
				break
			elseif var_235_0 <= iter_235_1:getLv() then
				var_235_1 = var_235_1 + 1
			end
		end
		
		if var_235_1 >= 3 then
			arg_235_0:doCountAdd()
			arg_235_0:checkDone()
		end
	end
end

GrowthBoostSkLvCondition = ClassDef(Condition_New)

function GrowthBoostSkLvCondition.constructor(arg_236_0)
end

function GrowthBoostSkLvCondition.getAcceptEvents(arg_237_0)
	return {
		"growthboost.sync.sklv"
	}
end

function GrowthBoostSkLvCondition.onEvent(arg_238_0, arg_238_1, arg_238_2)
	if tonumber(arg_238_0.db.count) ~= 1 then
		return 
	end
	
	if arg_238_0:getCurCount() >= 1 then
		return 
	end
	
	local var_238_0, var_238_1
	
	if arg_238_1 == "growthboost.sync.sklv" then
		if arg_238_0:getCurCount() >= 1 then
			return 
		end
		
		var_238_0 = to_n(arg_238_0.db.basegrade)
		var_238_1 = to_n(arg_238_0.db.skillenhance)
		
		for iter_238_0, iter_238_1 in pairs(Account:getUnits() or {}) do
			if var_238_0 <= iter_238_1:getBaseGrade() and var_238_1 <= iter_238_1:getTotalSkillLevel() then
				arg_238_0:doCountAdd()
				arg_238_0:checkDone()
				
				break
			end
		end
	end
end

RumbleClearCondition = ClassDef(Condition_New)

function RumbleClearCondition.constructor(arg_239_0)
end

function RumbleClearCondition.getAcceptEvents(arg_240_0)
	return {
		"rumble.clear"
	}
end

function RumbleClearCondition.onEvent(arg_241_0, arg_241_1, arg_241_2)
	if not arg_241_0.db.round then
		Log.e("RumbleClearCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_241_1 == "rumble.clear" then
		if not arg_241_2.cleared_round then
			Log.e("RumbleClearCondition:" .. arg_241_1, "invalid params.")
			
			return 
		end
		
		if arg_241_2.cleared_round >= to_n(arg_241_0.db.round) then
			arg_241_0:doCountAdd()
			arg_241_0:checkDone()
		end
	end
end

RumbleAllClearCondition = ClassDef(Condition_New)

function RumbleAllClearCondition.constructor(arg_242_0)
end

function RumbleAllClearCondition.getAcceptEvents(arg_243_0)
	return {
		"rumble.allclear"
	}
end

function RumbleAllClearCondition.onEvent(arg_244_0, arg_244_1, arg_244_2)
	if string.find(arg_244_0.condition, "_chr") then
		if not arg_244_0.db.chr then
			Log.e("RumbleAllClearCondition", "invalid condition value.")
			
			return 
		end
	elseif string.find(arg_244_0.condition, "_synergy") and (not arg_244_0.db.synergy or not arg_244_0.db.level) then
		Log.e("RumbleAllClearCondition", "invalid condition value.")
		
		return 
	end
	
	if arg_244_1 == "rumble.allclear" then
		if not arg_244_2.battle_units or not arg_244_2.battle_synergies then
			Log.e("RumbleAllClearCondition:" .. arg_244_1, "invalid params.")
			
			return 
		end
		
		if arg_244_0.db.chr then
			local var_244_0 = true
			
			if type(arg_244_0.db.chr) == "table" then
				for iter_244_0, iter_244_1 in pairs(arg_244_0.db.chr) do
					if not table.find(arg_244_2.battle_units, iter_244_1) then
						var_244_0 = false
						
						break
					end
				end
			elseif not table.find(arg_244_2.battle_units, arg_244_0.db.chr) then
				var_244_0 = false
			end
			
			if var_244_0 then
				arg_244_0:doCountAdd()
				arg_244_0:checkDone()
			end
		elseif arg_244_0.db.synergy then
			local var_244_1 = arg_244_2.battle_synergies[arg_244_0.db.synergy]
			
			if var_244_1 and var_244_1 >= to_n(arg_244_0.db.level) then
				arg_244_0:doCountAdd()
				arg_244_0:checkDone()
			end
		end
	end
end

RumbleChampionEndCondition = ClassDef(Condition_New)

function RumbleChampionEndCondition.constructor(arg_245_0)
end

function RumbleChampionEndCondition.getAcceptEvents(arg_246_0)
	return {
		"rumble.champion.end"
	}
end

function RumbleChampionEndCondition.onEvent(arg_247_0, arg_247_1, arg_247_2)
	if arg_247_1 == "rumble.champion.end" then
		arg_247_0:doCountAdd()
		arg_247_0:checkDone()
	end
end

RumbleChampionWinCondition = ClassDef(Condition_New)

function RumbleChampionWinCondition.constructor(arg_248_0)
end

function RumbleChampionWinCondition.getAcceptEvents(arg_249_0)
	return {
		"rumble.champion.win"
	}
end

function RumbleChampionWinCondition.onEvent(arg_250_0, arg_250_1, arg_250_2)
	if arg_250_1 == "rumble.champion.win" then
		arg_250_0:doCountAdd()
		arg_250_0:checkDone()
	end
end
