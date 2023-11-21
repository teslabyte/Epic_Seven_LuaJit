ENHANCER = ENHANCER or {}

function ENHANCER.create(arg_1_0, arg_1_1)
	local var_1_0 = {}
	
	copy_functions(ENHANCER, var_1_0)
	
	if arg_1_1.isEquip then
		if arg_1_1:isStone() then
			return nil
		end
		
		var_1_0.equip = arg_1_1
		var_1_0.code = arg_1_1.code
		var_1_0.grade = arg_1_1.grade
		var_1_0.db = arg_1_1.db
		var_1_0.dup_pt = arg_1_1.dup_pt
	else
		if type(arg_1_1) == "table" then
			var_1_0.material_stone = arg_1_1
			arg_1_1 = arg_1_1.code
		elseif type(arg_1_1) == "string" then
			var_1_0.material_stone = Account:getStoneItem(arg_1_1)
		end
		
		if not var_1_0.material_stone then
			return nil
		end
		
		local var_1_1 = DBT("item_material", arg_1_1, {
			"id",
			"name",
			"sort",
			"attribute",
			"ma_type",
			"ma_type2",
			"limit_break",
			"att_remark",
			"thumbnail",
			"hide_own",
			"icon",
			"drop_icon",
			"skill",
			"grade",
			"price",
			"type",
			"get_xp",
			"request_count",
			"support_count",
			"reward_token",
			"reward_count",
			"desc_category",
			"quality_point",
			"background_id",
			"skin_character",
			"desc",
			"ston_not_sale"
		})
		
		if var_1_1.ma_type ~= "stone" then
			return nil
		end
		
		var_1_0.material_stone.db = var_1_1
		var_1_0.code = arg_1_1
		var_1_0.grade = var_1_1.grade
		var_1_0.db = var_1_1
		var_1_0.dup_pt = 0
	end
	
	return var_1_0
end

function ENHANCER.clone(arg_2_0)
	if arg_2_0.material_stone then
		return ENHANCER:create(arg_2_0.material_stone)
	else
		return ENHANCER:create(arg_2_0.equip)
	end
end

function ENHANCER.isEnhancer(arg_3_0)
	return true
end

function ENHANCER.isMaterialStone(arg_4_0)
	return arg_4_0.material_stone ~= nil
end

function ENHANCER.code(arg_5_0)
	if arg_5_0.material_stone then
		return arg_5_0.material_stone.code
	end
	
	return arg_5_0.equip.code
end

function ENHANCER.count(arg_6_0)
	if arg_6_0.material_stone then
		return arg_6_0.material_stone.count
	end
	
	return 1
end

function ENHANCER.setMaterialStoneCount(arg_7_0, arg_7_1)
	if arg_7_0.material_stone then
		arg_7_0.material_stone.count = arg_7_1
	end
end

function ENHANCER.incMaterialStone(arg_8_0)
	if arg_8_0.material_stone then
		arg_8_0.material_stone.count = arg_8_0.material_stone.count + 1
		
		return arg_8_0.material_stone.count
	end
end

function ENHANCER.decMaterialStone(arg_9_0)
	if arg_9_0.material_stone then
		if arg_9_0.material_stone.count < 1 then
			return nil
		end
		
		arg_9_0.material_stone.count = arg_9_0.material_stone.count - 1
		
		return arg_9_0.material_stone.count
	end
end

function ENHANCER.get_xp(arg_10_0)
	if arg_10_0.material_stone then
		return arg_10_0.material_stone.db.get_xp
	end
	
	return arg_10_0.equip.db.get_xp
end

function ENHANCER.getRewardIconCountValue(arg_11_0)
	if arg_11_0.material_stone then
		return arg_11_0.material_stone.count
	end
	
	return "equip"
end

local var_0_0 = {
	"item_grade_1",
	"item_grade_2",
	"item_grade_3",
	"item_grade_4",
	"item_grade_5"
}
local var_0_1 = {
	"weapon",
	"helm",
	"neck",
	"armor",
	"boot",
	"ring",
	"artifact",
	"equip",
	"jewellery"
}
local var_0_2 = {
	weapon = 1,
	neck = 4,
	jewellery = 9,
	boot = 6,
	helm = 3,
	artifact = 7,
	equip = 8,
	armor = 2,
	ring = 5
}
local var_0_3 = {
	"item_type_weapon",
	"item_type_helm",
	"item_type_neck",
	"item_type_armor",
	"item_type_boot",
	"item_type_ring",
	"item_type_artifact",
	"item_type_equip",
	"item_type_jewellery"
}

function ENHANCER.getName(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0.material_stone then
		return T(arg_12_0.material_stone.db.name)
	else
		arg_12_2 = T(arg_12_2 or arg_12_0 and arg_12_0.db and arg_12_0.db.name)
		
		if arg_12_1 and arg_12_0 and arg_12_0.enhance > 0 then
			arg_12_2 = "+" .. arg_12_0.enhance .. " " .. arg_12_2
		end
		
		return arg_12_2
	end
end

function ENHANCER.isSetItem(arg_13_0, arg_13_1)
	if arg_13_0.material_stone then
		return false
	end
	
	return arg_13_0.equip:isSetItem(arg_13_1)
end

function ENHANCER.getSetTitle(arg_14_0, arg_14_1)
	if arg_14_0.material_stone then
		return ""
	end
	
	return arg_14_0.equip:getSetTitle(arg_14_1)
end

function ENHANCER.getSetDetail(arg_15_0, arg_15_1)
	if arg_15_0.material_stone then
		return ""
	end
	
	return arg_15_0.equip:getSetDetail(arg_15_1)
end

function ENHANCER.getSetItemTotalCount(arg_16_0, arg_16_1)
	if arg_16_0.material_stone then
		return 0
	end
	
	return arg_16_0.equip:getSetItemTotalCount(arg_16_1)
end

function ENHANCER.getSetItemIconPath(arg_17_0, arg_17_1)
	if arg_17_0.material_stone then
		return ""
	end
	
	return arg_17_0.equip:getSetItemIconPath(arg_17_1)
end

function ENHANCER.getEquipPositionIndex(arg_18_0, arg_18_1)
	if arg_18_0.material_stone then
		arg_18_1 = arg_18_1 or arg_18_0.db.ma_type2
		
		for iter_18_0, iter_18_1 in pairs(var_0_1) do
			if iter_18_1 == arg_18_1 then
				return iter_18_0
			end
		end
		
		return nil
	end
	
	return arg_18_0.equip:getEquipPositionIndex(arg_18_1)
end

function ENHANCER.getEquipPositionName(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0.material_stone then
		return ""
	end
	
	return arg_19_0.equip:getEquipPositionName(arg_19_1, arg_19_2)
end

function ENHANCER.getEquipPositionByIndex(arg_20_0, arg_20_1)
	return var_0_1[arg_20_1]
end

function ENHANCER.getEquipPositionNameByIndex(arg_21_0, arg_21_1)
	return T(var_0_3[arg_21_1] or "all")
end

function ENHANCER.getGradeText(arg_22_0, arg_22_1)
	if arg_22_0.equip then
		arg_22_1 = arg_22_1 or arg_22_0.equip.grade
	end
	
	return T(var_0_0[arg_22_1])
end

function ENHANCER.getGradeTitle(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if type(arg_23_0) == "string" then
		if string.starts(arg_23_0, "ma_") then
			local var_23_0, var_23_1 = DB("item_material", arg_23_0, {
				"ma_type2",
				"ma_type"
			})
			
			if var_23_1 == "stone" then
				arg_23_3 = "y"
			end
			
			arg_23_2 = var_23_0
		else
			arg_23_2, arg_23_3 = DB("equip_item", arg_23_0, {
				"type",
				"stone"
			})
		end
	end
	
	if arg_23_0.equip.isEquip then
		arg_23_1 = arg_23_1 or arg_23_0.equip.grade
	end
	
	return T("item_title", {
		grade = T(var_0_0[arg_23_1]),
		name = ENHANCER.getEquipPositionName(arg_23_0, arg_23_2, arg_23_3)
	})
end

function ENHANCER.getEnhance(arg_24_0)
	if arg_24_0.material_stone then
		return 0
	end
	
	return arg_24_0.equip:getEnhance()
end

function ENHANCER.getExp(arg_25_0)
	if arg_25_0.material_stone then
		return 0
	end
	
	return arg_25_0.equip:getExp()
end

function ENHANCER.getEXPString(arg_26_0, arg_26_1)
	if arg_26_0.material_stone then
		return ""
	end
	
	return arg_26_0.equip:getEXPString(arg_26_1)
end

function ENHANCER.getMaxExp(arg_27_0, arg_27_1)
	if arg_27_0.material_stone then
		return 0
	end
	
	return arg_27_0.equip:getMaxExp(arg_27_1)
end

function ENHANCER.getEXPRatio(arg_28_0, arg_28_1)
	if arg_28_0.material_stone then
		return 0
	end
	
	return arg_28_0.equip:getEXPRatio(arg_28_1)
end

function ENHANCER.getNextExp(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0.material_stone then
		return 0
	end
	
	return arg_29_0.equip:getNextExp(arg_29_1, arg_29_2)
end

function ENHANCER.isMaxEnhance(arg_30_0)
	if arg_30_0.material_stone then
		return true
	end
	
	return arg_30_0.equip:isMaxEnhance()
end

function ENHANCER.isRecallArtifactStone(arg_31_0)
	if arg_31_0.material_stone then
		return arg_31_0.material_stone.db.att_remark == "y" and arg_31_0:isArtifact() and arg_31_0:isStone()
	end
	
	return arg_31_0.equip:isRecallArtifactStone()
end

function ENHANCER.getMaxEnhance(arg_32_0, arg_32_1)
	if arg_32_0.material_stone then
		return 0
	end
	
	return arg_32_0.equip:getMaxEnhance(arg_32_1)
end

function ENHANCER.getDupPoint(arg_33_0)
	if arg_33_0.material_stone then
		return 0
	end
	
	return arg_33_0.equip:getDupPoint()
end

function ENHANCER.getSkillId(arg_34_0)
	if arg_34_0.material_stone then
		return nil
	end
	
	return arg_34_0.equip:getSkillId()
end

function ENHANCER.getEquip(arg_35_0)
	if arg_35_0.material_stone then
		return nil
	end
	
	return arg_35_0.equip
end

function ENHANCER.isEquip(arg_36_0)
	if arg_36_0.material_stone then
		return false
	else
		return true
	end
end

function ENHANCER.isArtifact(arg_37_0)
	if arg_37_0.material_stone then
		return arg_37_0.material_stone.db.ma_type2 == "artifact"
	else
		return arg_37_0.equip.db.type == "artifact"
	end
end

function ENHANCER.isExclusive(arg_38_0)
	if arg_38_0.material_stone then
		return arg_38_0.material_stone.db.ma_type2 == "exclusive"
	else
		return arg_38_0.equip.db.type == "exclusive"
	end
end

function ENHANCER.isCompatibleCategoryStone(arg_39_0, arg_39_1)
	local var_39_0
	
	if arg_39_0.material_stone then
		var_39_0 = arg_39_0.material_stone.db.ma_type2
	else
		var_39_0 = arg_39_0.equip.db.type
	end
	
	if var_39_0 == "equip" and (arg_39_1 == "weapon" or arg_39_1 == "helm" or arg_39_1 == "armor" or arg_39_1 == "boot") then
		return true
	elseif var_39_0 == "jewellery" and (arg_39_1 == "neck" or arg_39_1 == "ring") then
		return true
	end
	
	return false
end

function ENHANCER.compareCompatibleCategoryStone(arg_40_0, arg_40_1)
	if arg_40_0 == "equip" and (arg_40_1 == "weapon" or arg_40_1 == "helm" or arg_40_1 == "armor" or arg_40_1 == "boot") then
		return true
	elseif arg_40_0 == "jewellery" and (arg_40_1 == "neck" or arg_40_1 == "ring") then
		return true
	end
	
	return false
end

function ENHANCER.getMainStat(arg_41_0)
	if arg_41_0.material_stone then
		return 0, ""
	end
	
	return arg_41_0.equip:getMainStat()
end

function ENHANCER.getSkillLevel(arg_42_0, arg_42_1)
	if arg_42_0.material_stone then
		return 0
	end
	
	return arg_42_0.equip:getSkillLevel(arg_42_1)
end

function ENHANCER.getMaxSkillLevel(arg_43_0)
	if arg_43_0.material_stone then
		return 0
	end
	
	return arg_43_0.equip:getMaxSkillLevel()
end

function ENHANCER.getOptionCount(arg_44_0, arg_44_1)
	if arg_44_0.material_stone then
		return 0
	end
	
	return arg_44_0.equip:getOptionCount(arg_44_1)
end

function ENHANCER.getOptLevel(arg_45_0)
	if arg_45_0.material_stone then
		return 0
	end
	
	return arg_45_0.equip:getOptLevel()
end

function ENHANCER.greaterThanExp(arg_46_0, arg_46_1)
	if arg_46_0.material_stone and not arg_46_1.material_stone then
		return true
	end
	
	if not arg_46_0.material_stone and arg_46_1.material_stone then
		return false
	end
	
	if arg_46_0.material_stone and arg_46_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_46_0, arg_46_1)
	end
	
	if arg_46_0.equip.exp == arg_46_1.equip.exp then
		return ENHANCER.greaterThanGrade(arg_46_0, arg_46_1)
	end
	
	return arg_46_0.equip.exp > arg_46_1.equip.exp
end

function ENHANCER.greaterThanEnhance(arg_47_0, arg_47_1)
	if arg_47_0.material_stone and not arg_47_1.material_stone then
		return true
	end
	
	if not arg_47_0.material_stone and arg_47_1.material_stone then
		return false
	end
	
	if arg_47_0.material_stone and arg_47_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_47_0, arg_47_1)
	end
	
	if arg_47_0.equip.enhance == arg_47_1.equip.enhance then
		return ENHANCER.greaterThanGrade(arg_47_0, arg_47_1)
	end
	
	return arg_47_0.equip.enhance > arg_47_1.equip.enhance
end

function ENHANCER.greaterThanTier(arg_48_0, arg_48_1)
	if arg_48_0.material_stone and not arg_48_1.material_stone then
		return true
	end
	
	if not arg_48_0.material_stone and arg_48_1.material_stone then
		return false
	end
	
	return ENHANCER.greaterThanItemLevel(arg_48_0, arg_48_1)
end

function ENHANCER.greaterThanItemLevel(arg_49_0, arg_49_1)
	if arg_49_0.material_stone and not arg_49_1.material_stone then
		return true
	end
	
	if not arg_49_0.material_stone and arg_49_1.material_stone then
		return false
	end
	
	if arg_49_0.material_stone and arg_49_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_49_0, arg_49_1)
	end
	
	if arg_49_0.equip.db.item_level == arg_49_1.equip.db.item_level then
		return ENHANCER.greaterThanGrade(arg_49_0, arg_49_1)
	end
	
	return arg_49_0.equip.db.item_level > arg_49_1.equip.db.item_level
end

function ENHANCER.greaterThanUID(arg_50_0, arg_50_1)
	if arg_50_0.material_stone and not arg_50_1.material_stone then
		return true
	end
	
	if not arg_50_0.material_stone and arg_50_1.material_stone then
		return false
	end
	
	if arg_50_0.material_stone and arg_50_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_50_0, arg_50_1)
	end
	
	return arg_50_0.equip.id > arg_50_1.equip.id
end

function ENHANCER.greaterThanGrade(arg_51_0, arg_51_1)
	if arg_51_0.material_stone and not arg_51_1.material_stone then
		return true
	end
	
	if not arg_51_0.material_stone and arg_51_1.material_stone then
		return false
	end
	
	local var_51_0
	local var_51_1
	
	if arg_51_0.material_stone then
		var_51_0 = arg_51_0.material_stone.db.grade
	else
		var_51_0 = arg_51_0.equip.grade
	end
	
	if arg_51_1.material_stone then
		var_51_1 = arg_51_1.material_stone.db.grade
	else
		var_51_1 = arg_51_1.equip.grade
	end
	
	if var_51_0 == var_51_1 then
		return ENHANCER.greaterThanCode(arg_51_0, arg_51_1)
	end
	
	return var_51_1 < var_51_0
end

local var_0_4 = {
	manauser = 1,
	knight = 5,
	assassin = 4,
	warrior = 6,
	ranger = 3,
	mage = 2
}

function ENHANCER.greaterThanRole(arg_52_0, arg_52_1)
	if arg_52_0.material_stone and not arg_52_1.material_stone then
		return true
	end
	
	if not arg_52_0.material_stone and arg_52_1.material_stone then
		return false
	end
	
	if arg_52_0.material_stone and arg_52_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_52_0, arg_52_1)
	end
	
	if not arg_52_0.equip:isArtifact() or not arg_52_1.equip:isArtifact() then
		return ENHANCER.greaterThanGrade(arg_52_0, arg_52_1)
	end
	
	if not arg_52_0.equip.db.role and arg_52_1.equip.db.role then
		return false
	end
	
	if not arg_52_1.equip.db.role and arg_52_0.equip.db.role then
		return true
	end
	
	if not arg_52_0.equip.db.role and not arg_52_1.equip.db.role then
		return ENHANCER.greaterThanGrade(arg_52_0, arg_52_1)
	end
	
	if var_0_4[arg_52_0.equip.db.role] == var_0_4[arg_52_1.equip.db.role] then
		return ENHANCER.greaterThanGrade(arg_52_0, arg_52_1)
	end
	
	return var_0_4[arg_52_0.equip.db.role] > var_0_4[arg_52_1.equip.db.role]
end

function ENHANCER.greaterThanName(arg_53_0, arg_53_1)
	if arg_53_0.material_stone and not arg_53_1.material_stone then
		return true
	end
	
	if not arg_53_0.material_stone and arg_53_1.material_stone then
		return false
	end
	
	if arg_53_0.material_stone and arg_53_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_53_0, arg_53_1)
	end
	
	if not arg_53_0.equip:isArtifact() or not arg_53_1.equip:isArtifact() then
		return ENHANCER.greaterThanGrade(arg_53_0, arg_53_1)
	end
	
	if not arg_53_0.equip.db.name and arg_53_1.equip.db.name then
		return false
	end
	
	if not arg_53_1.equip.db.name and arg_53_0.equip.db.name then
		return true
	end
	
	if not arg_53_0.equip.db.name and not arg_53_1.equip.db.name then
		return nil
	end
	
	if arg_53_0.equip.db.name == arg_53_1.equip.db.name then
		return ENHANCER.greaterThanGrade(arg_53_0, arg_53_1)
	end
	
	if arg_53_0.equip.db.sort_name and arg_53_1.equip.db.sort_name then
		return arg_53_0.equip.db.sort_name < arg_53_1.equip.db.sort_name
	end
	
	local var_53_0 = T(arg_53_0.equip.db.name)
	local var_53_1 = T(arg_53_1.equip.db.name)
	
	if getUserLanguage() == "th" then
		return var_53_0 < var_53_1
	end
	
	if isLatinAccentLanguage() then
		return utf8LatinAccentCompare(var_53_0, var_53_1)
	end
	
	local var_53_2 = utf8sub(var_53_0, 1, 1) or " "
	local var_53_3 = utf8sub(var_53_1, 1, 1) or " "
	
	if var_53_2 == "@" then
		var_53_2 = " "
	end
	
	if var_53_3 == "@" then
		var_53_3 = " "
	end
	
	return var_53_2 < var_53_3
end

function ENHANCER.greaterThanCode(arg_54_0, arg_54_1)
	if arg_54_0.material_stone and not arg_54_1.material_stone then
		return true
	end
	
	if not arg_54_0.material_stone and arg_54_1.material_stone then
		return false
	end
	
	local var_54_0
	local var_54_1
	local var_54_2
	local var_54_3
	local var_54_4
	local var_54_5
	local var_54_6
	local var_54_7
	local var_54_8
	local var_54_9
	local var_54_10
	
	if arg_54_0.material_stone then
		var_54_0 = arg_54_0.material_stone.db.grade
		var_54_2 = arg_54_0.material_stone.db.ma_type2 == "artifact"
		var_54_4 = arg_54_0.material_stone.code
		var_54_6 = arg_54_0.material_stone.db.ma_type2
		var_54_10 = 0
	else
		var_54_0 = arg_54_0.equip.grade
		var_54_2 = arg_54_0.equip:isArtifact()
		var_54_4 = arg_54_0.equip.code
		var_54_6 = arg_54_0.equip.db.type
		var_54_10 = arg_54_0.equip.exp
	end
	
	local var_54_11
	
	if arg_54_1.material_stone then
		var_54_1 = arg_54_1.material_stone.db.grade
		var_54_3 = arg_54_1.material_stone.db.ma_type2 == "artifact"
		var_54_5 = arg_54_1.material_stone.code
		var_54_7 = arg_54_1.material_stone.db.ma_type2
		var_54_11 = 0
	else
		var_54_1 = arg_54_1.equip.grade
		var_54_3 = arg_54_1.equip:isArtifact()
		var_54_5 = arg_54_1.equip.code
		var_54_7 = arg_54_1.equip.db.type
		var_54_11 = arg_54_1.equip.exp
	end
	
	if not var_54_2 and not var_54_3 and var_54_0 ~= var_54_1 then
		return var_54_0 < var_54_0
	end
	
	if not var_54_2 and not var_54_3 and var_54_6 and var_54_7 and var_54_6 ~= var_54_7 then
		return var_0_2[var_54_6] < var_0_2[var_54_7]
	end
	
	if var_54_4 == var_54_5 then
		return var_54_11 < var_54_10
	end
	
	return var_54_5 < var_54_4
end

function ENHANCER.greaterThanSet(arg_55_0, arg_55_1)
	if arg_55_0.material_stone and not arg_55_1.material_stone then
		return true
	end
	
	if not arg_55_0.material_stone and arg_55_1.material_stone then
		return false
	end
	
	if arg_55_0.material_stone and arg_55_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_55_0, arg_55_1)
	end
	
	local var_55_0
	local var_55_1
	
	if arg_55_0.material_stone then
		var_55_0 = arg_55_0.material_stone.db.ma_type2 == "artifact"
	else
		var_55_0 = arg_55_0.equip:isArtifact()
	end
	
	if arg_55_1.material_stone then
		var_55_1 = arg_55_1.material_stone.db.ma_type2 == "artifact"
	else
		var_55_1 = arg_55_1.equip:isArtifact()
	end
	
	if var_55_0 and var_55_1 then
		return ENHANCER.greaterThanGrade(arg_55_0, arg_55_1)
	end
	
	if arg_55_0.equip.set_fx == arg_55_1.equip.set_fx then
		return ENHANCER.greaterThanExp(arg_55_0, arg_55_1)
	end
	
	return tostring(arg_55_0.equip.set_fx) > tostring(arg_55_1.equip.set_fx)
end

function ENHANCER.greaterThanStat(arg_56_0, arg_56_1)
	if arg_56_0.material_stone and not arg_56_1.material_stone then
		return true
	end
	
	if not arg_56_0.material_stone and arg_56_1.material_stone then
		return false
	end
	
	if arg_56_0.material_stone and arg_56_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_56_0, arg_56_1)
	end
	
	local var_56_0, var_56_1 = arg_56_0.equip:getMainStat()
	local var_56_2, var_56_3 = arg_56_1.equip:getMainStat()
	local var_56_4 = string.find(var_56_1, "_rate") ~= nil
	
	if var_56_4 ~= (string.find(var_56_3, "_rate") ~= nil) then
		return var_56_4
	end
	
	if var_56_0 == var_56_2 then
		return ENHANCER.greaterThanCode(arg_56_0, arg_56_1)
	end
	
	return var_56_2 < var_56_0
end

function ENHANCER.greaterThanPoint(arg_57_0, arg_57_1)
	if arg_57_0.material_stone and not arg_57_1.material_stone then
		return true
	end
	
	if not arg_57_0.material_stone and arg_57_1.material_stone then
		return false
	end
	
	if arg_57_0.material_stone and arg_57_1.material_stone then
		return ENHANCER.greaterThanGrade(arg_57_0, arg_57_1)
	end
	
	if arg_57_0.equip.point == arg_57_1.equip.point then
		return ENHANCER.greaterThanGrade(arg_57_0, arg_57_1)
	end
	
	return (arg_57_0.equip.point or 0) > (arg_57_1.equip.point or 0)
end

function ENHANCER.checkSell(arg_58_0)
	if arg_58_0.material_stone then
		return false
	end
	
	return arg_58_0.equip:checkSell()
end

function ENHANCER.ignoreStoneEnhanceGold(arg_59_0)
	if not arg_59_0.material_stone then
		return 
	end
	
	if arg_59_0.equip then
		return arg_59_0.equip:ignoreStoneEnhanceGold()
	else
		return arg_59_0.db.ston_not_sale == "y"
	end
end

function ENHANCER.isStone(arg_60_0)
	if arg_60_0.material_stone then
		return true
	end
	
	return arg_60_0.equip:isStone()
end

function ENHANCER.isLimitBreak(arg_61_0)
	if arg_61_0.material_stone then
		return arg_61_0.material_stone.db.limit_break ~= nil
	end
	
	return arg_61_0.equip:isLimitBreak()
end

function ENHANCER.isBreakThrough(arg_62_0)
	if arg_62_0.material_stone then
		return arg_62_0.material_stone.db.breakthrough ~= nil
	end
	
	return arg_62_0.equip:isBreakThrough()
end

function ENHANCER.checkLimitBreak(arg_63_0, arg_63_1)
	if arg_63_0.material_stone then
		if not arg_63_1 then
			return false
		end
		
		if not arg_63_0:isLimitBreak() then
			return false
		end
		
		if arg_63_1:isBreakThrough() then
			return false
		end
		
		local var_63_0 = to_n(arg_63_0.material_stone.db.limit_break)
		
		return var_63_0 > 0 and var_63_0 == to_n(arg_63_1.grade)
	else
		return arg_63_0.equip:checkLimitBreak(arg_63_1)
	end
end

function ENHANCER.isUsable(arg_64_0)
	if arg_64_0.material_stone then
		return true
	end
	
	return arg_64_0.equip:isUsable()
end

function ENHANCER.getConsumeExp(arg_65_0)
	if arg_65_0.material_stone then
		return arg_65_0.material_stone.db.get_xp
	end
	
	return arg_65_0.equip:getConsumeExp()
end

function ENHANCER.getConsumeCost(arg_66_0, arg_66_1)
	local var_66_0 = math.floor(arg_66_0:getConsumeExp() * DB("itemgrade", tostring(arg_66_1.grade), "enchant_price") * (GAME_STATIC_VARIABLE.sell_item_value or 19) * (DB("equip_item", arg_66_1.code, "enchant_gold_rdc") or 1))
	
	if arg_66_0:isStone() and not arg_66_0:ignoreStoneEnhanceGold() then
		var_66_0 = math.floor(var_66_0 * 0.6)
	end
	
	return var_66_0
end

function ENHANCER.isUpgradable(arg_67_0)
	if arg_67_0.material_stone then
		return false
	end
	
	return arg_67_0.equip:isUpgradable()
end

function ENHANCER.isConsumable(arg_68_0, arg_68_1, arg_68_2)
	if arg_68_0.material_stone then
		return false
	end
	
	return arg_68_0.equip:isConsumable(arg_68_1, arg_68_2)
end

function ENHANCER.checkRole(arg_69_0, arg_69_1)
	if arg_69_0.material_stone then
		return true
	end
	
	return arg_69_0.equip:checkRole(arg_69_1)
end
