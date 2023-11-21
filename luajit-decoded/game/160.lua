EQUIP = EQUIP or {}

function EQUIP.createByInfo(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or {}
	
	copy_functions(EQUIP, arg_1_2)
	
	arg_1_2.stats = arg_1_1.stats or {}
	arg_1_2.opts = arg_1_1.opts or {}
	arg_1_2.db = {}
	arg_1_2.id = arg_1_1.id
	arg_1_2.code = arg_1_1.code
	arg_1_2.op = arg_1_1.op
	arg_1_2.dup_pt = 0
	arg_1_2.count = arg_1_1.c or arg_1_1.count or 1
	
	if arg_1_1.s then
		arg_1_2.seed = tonumber(arg_1_1.s, 16)
	else
		arg_1_2.seed = arg_1_1.seed or math.random(0, 9999)
	end
	
	arg_1_2.db.name, arg_1_2.db.type, arg_1_2.db.exclusive_skill, arg_1_2.db.exclusive_unit, arg_1_2.db.stone, arg_1_2.db.icon, arg_1_2.db.main_stat, arg_1_2.db.sub_stat_count, arg_1_2.db.sub_stat, arg_1_2.db.price, arg_1_2.db.xp, arg_1_2.db.get_xp, arg_1_2.db.content_opts, arg_1_2.db.unique_type, arg_1_2.db.grade_min, arg_1_2.db.grade_max, arg_1_2.db.tier, arg_1_2.db.item_level, arg_1_2.db.artifact_skill, arg_1_2.db.role, arg_1_2.db.character, arg_1_2.db.character_group, arg_1_2.db.exclusive_grade, arg_1_2.db.artifact_grade, arg_1_2.db.limit_break, arg_1_2.db.breakthrough, arg_1_2.db.artifact_force_lock, arg_1_2.db.limit_break_count, arg_1_2.db.att_remark, arg_1_2.db.artifact_hiddenskill_1, arg_1_2.db.artifact_hiddenskill_2, arg_1_2.db.ston_not_sale = DB("equip_item", arg_1_2.code, {
		"name",
		"type",
		"exclusive_skill",
		"exclusive_unit",
		"stone",
		"icon",
		"main_stat",
		"sub_stat_count",
		"sub_stat",
		"price",
		"xp",
		"get_xp",
		"content_otps",
		"unique_type",
		"grade_min",
		"grade_max",
		"tier",
		"item_level",
		"artifact_skill",
		"role",
		"character",
		"character_group",
		"exclusive_grade",
		"artifact_grade",
		"limit_break",
		"breakthrough",
		"artifact_force_lock",
		"limit_break_count",
		"att_remark",
		"artifact_hiddenskill_1",
		"artifact_hiddenskill_2",
		"ston_not_sale"
	})
	
	if not arg_1_2.db.name then
		local var_1_0 = ""
		
		if SceneManager then
			local var_1_1 = SceneManager:getCurrentSceneName()
			
			var_1_0 = ".scene:" .. var_1_1
		end
		
		Log.e("Deprecated Equip : " .. tostring(arg_1_2.code) .. ".id : " .. tostring(arg_1_2.id) .. var_1_0)
		
		arg_1_2 = nil
		
		return 
	end
	
	if arg_1_2.db.content_opts then
		local var_1_2 = (function(arg_2_0)
			local var_2_0 = string.split(arg_2_0, ",")
			local var_2_1 = {}
			
			for iter_2_0, iter_2_1 in pairs(var_2_0) do
				iter_2_1 = string.split(iter_2_1, "=")
				
				if #iter_2_1 == 2 then
					local var_2_2 = string.trim(iter_2_1[1])
					local var_2_3 = string.trim(iter_2_1[2])
					
					var_2_3 = tonumber(var_2_3) and tonumber(var_2_3) or var_2_3
					var_2_1[var_2_2] = var_2_3
				end
			end
			
			return var_2_1
		end)(arg_1_2.db.content_opts)
		
		if var_1_2.level_type then
			local var_1_3 = {}
			
			for iter_1_0, iter_1_1 in pairs(string.split(var_1_2.level_type, ";")) do
				var_1_3[string.trim(iter_1_1)] = true
			end
			
			var_1_2.level_type = var_1_3
		end
		
		arg_1_2.db.content_opts = var_1_2
	end
	
	arg_1_2.grade = arg_1_1.g or arg_1_1.grade or 0
	arg_1_2.parent = arg_1_1.p or arg_1_1.parent
	arg_1_2.lock = arg_1_1.l or arg_1_1.lock
	arg_1_2.exp = arg_1_1.e or arg_1_1.exp or 0
	arg_1_2.ct = arg_1_1.ct
	
	if arg_1_2:isArtifact() then
		arg_1_2.dup_pt = arg_1_1.sk or arg_1_2.db.limit_break_count or arg_1_1.dup_pt or 0
		arg_1_2.grade = arg_1_2.db.artifact_grade
		
		if not arg_1_2.op and not arg_1_2:isStone() then
			local var_1_4 = DB("itemgrade", tostring(arg_1_2.grade), "power")
			local var_1_5 = math.floor(DB("equip_stat", arg_1_2.db.main_stat .. "_1", "val_min") * var_1_4)
			local var_1_6 = math.floor(DB("equip_stat", DB("equip_item", arg_1_2.code, "main_stat2") .. "_1", "val_min") * var_1_4)
			
			arg_1_2.op = {
				{
					"att",
					var_1_5
				},
				{
					"max_hp",
					var_1_6
				}
			}
		end
		
		if Text then
			arg_1_2.db.sort_name = Text:getSortName(arg_1_2.db.name)
		end
	else
		arg_1_2.set_fx = arg_1_1.f or arg_1_1.set_fx
		arg_1_2.set_order = DB("item_set", arg_1_2.set_fx, "sort") or 1
	end
	
	arg_1_2.db.sub_stat_count = arg_1_2.db.sub_stat_count or 0
	
	arg_1_2:update()
	
	return arg_1_2
end

function EQUIP.clone(arg_3_0)
	return EQUIP:createByInfo(arg_3_0)
end

function EQUIP.getRewardIconCountValue(arg_4_0)
	return "equip"
end

function EQUIP.getUID(arg_5_0)
	return arg_5_0.id
end

function EQUIP.setEquipStat(arg_6_0)
	if not arg_6_0.op or #arg_6_0.op <= 0 then
		return 
	end
	
	arg_6_0.stats = {}
	arg_6_0.opts = {}
	
	if arg_6_0.op then
		for iter_6_0, iter_6_1 in pairs(arg_6_0.op) do
			if iter_6_0 == 1 or iter_6_0 <= 2 and arg_6_0:isArtifact() then
				table.push(arg_6_0.stats, iter_6_1)
			else
				local var_6_0 = arg_6_0.db.exclusive_skill
				
				if var_6_0 and iter_6_1 and var_6_0 == iter_6_1[1] and to_n(iter_6_1[2]) > 0 then
					arg_6_0.exclusive_id = string.format("%s_%02d", var_6_0, to_n(iter_6_1[2]))
				end
				
				table.push(arg_6_0.opts, iter_6_1)
			end
		end
	end
end

function EQUIP.getName(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_2 = T(arg_7_2 or arg_7_0 and arg_7_0.db and arg_7_0.db.name)
	
	if arg_7_1 and arg_7_0 and arg_7_0.enhance > 0 then
		arg_7_2 = "+" .. arg_7_0.enhance .. " " .. arg_7_2
	end
	
	return arg_7_2
end

function EQUIP.isSetItem(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or arg_8_0.set_fx
	
	return arg_8_1 ~= nil
end

function EQUIP.getSetTitle(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or arg_9_0.set_fx
	
	local var_9_0
	
	if arg_9_0:isSetItem(arg_9_1) then
		var_9_0 = T(DB("item_set", arg_9_1, "name"))
	end
	
	return var_9_0 or ""
end

function EQUIP.getSetDetail(arg_10_0, arg_10_1)
	arg_10_1 = arg_10_1 or arg_10_0.set_fx
	
	local var_10_0
	
	if arg_10_0:isSetItem(arg_10_1) then
		local var_10_1 = arg_10_1 .. "_de"
		
		if DB("text", var_10_1, "text") then
			var_10_0 = T(var_10_1)
		end
	end
	
	return var_10_0 or ""
end

function EQUIP.getSetItemTotalCount(arg_11_0, arg_11_1)
	arg_11_1 = arg_11_1 or arg_11_0.set_fx
	
	local var_11_0
	
	if arg_11_0:isSetItem(arg_11_1) then
		var_11_0 = DB("item_set", arg_11_1, "set_number")
		
		if var_11_0 == 0 then
			Log.e("getSetItemTotalCount", "wt?? 000")
		end
	end
	
	return var_11_0 or 0
end

function EQUIP.getSetItemIconPath(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or arg_12_0.set_fx
	
	local var_12_0 = ""
	
	if arg_12_0:isSetItem(arg_12_1) then
		local var_12_1 = DB("item_set", arg_12_1, "icon") or ""
		
		var_12_0 = "item/" .. var_12_1 .. ".png"
	end
	
	return var_12_0
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
	"exclusive",
	"equip",
	"jewellery"
}
local var_0_2 = {
	weapon = 1,
	boot = 6,
	equip = 9,
	exclusive = 8,
	helm = 3,
	artifact = 7,
	neck = 4,
	jewellery = 10,
	armor = 2,
	ring = 5
}
local var_0_3 = {
	manauser = 1,
	knight = 5,
	assassin = 4,
	warrior = 6,
	ranger = 3,
	mage = 2
}
local var_0_4 = {
	"item_type_weapon",
	"item_type_helm",
	"item_type_neck",
	"item_type_armor",
	"item_type_boot",
	"item_type_ring",
	"item_type_artifact",
	"item_type_exclusive",
	"item_type_equip",
	"item_type_jewellery"
}

function EQUIP.getEquipPositionIndex(arg_13_0, arg_13_1)
	arg_13_1 = arg_13_1 or arg_13_0.db.type
	
	for iter_13_0, iter_13_1 in pairs(var_0_1) do
		if iter_13_1 == arg_13_1 then
			return iter_13_0
		end
	end
	
	return nil
end

function EQUIP.getEquipPositionName(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_2 and type(arg_14_0) == "table" then
		arg_14_2 = arg_14_0.db.stone
	end
	
	if arg_14_2 == "y" then
		return T("equip_category_stone")
	end
	
	arg_14_1 = arg_14_1 or arg_14_0.db.type
	
	for iter_14_0, iter_14_1 in pairs(var_0_1) do
		if iter_14_1 == arg_14_1 then
			return T(var_0_4[iter_14_0])
		end
	end
	
	return ""
end

function EQUIP.getEquipPositionByIndex(arg_15_0, arg_15_1)
	return var_0_1[arg_15_1]
end

function EQUIP.getEquipPositionNameByIndex(arg_16_0, arg_16_1)
	return T(var_0_4[arg_16_1] or "all")
end

function EQUIP.getGradeText(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or arg_17_0.grade
	
	return T(var_0_0[arg_17_1])
end

function EQUIP.getGradeTitle(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if type(arg_18_0) == "string" then
		arg_18_2, arg_18_3 = DB("equip_item", arg_18_0, {
			"type",
			"stone"
		})
	end
	
	arg_18_1 = arg_18_1 or arg_18_0.grade
	
	return T("item_title", {
		grade = T(var_0_0[arg_18_1]),
		name = EQUIP.getEquipPositionName(arg_18_0, arg_18_2, arg_18_3)
	})
end

function EQUIP.getEnhance(arg_19_0)
	return arg_19_0.enhance
end

function EQUIP.getExp(arg_20_0)
	return arg_20_0.exp or 0
end

function EQUIP.getEXPString(arg_21_0, arg_21_1)
	arg_21_1 = arg_21_1 or 0
	
	local var_21_0 = arg_21_0.exp + arg_21_1
	local var_21_1 = arg_21_0:getNextExp()
	local var_21_2 = math.min(arg_21_0:getNextExp(arg_21_0:getMaxEnhance() - 1), var_21_0)
	local var_21_3 = 0
	
	if arg_21_0.enhance > 0 then
		var_21_3 = arg_21_0:getNextExp(arg_21_0.enhance - 1)
	end
	
	local var_21_4 = math.max(0, var_21_1 - var_21_3)
	local var_21_5 = var_21_2 - var_21_3
	
	return comma_value(var_21_5) .. " / " .. comma_value(var_21_4)
end

function EQUIP.getMaxExp(arg_22_0, arg_22_1)
	return arg_22_0:getNextExp(arg_22_0:getMaxEnhance(arg_22_1) - 1)
end

function EQUIP.getEXPRatio(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or 0
	
	local var_23_0 = 0
	
	if arg_23_0.enhance > 0 then
		var_23_0 = arg_23_0:getNextExp(arg_23_0.enhance - 1)
	end
	
	local var_23_1 = arg_23_0.exp + arg_23_1
	local var_23_2 = math.min(arg_23_0:getNextExp(arg_23_0:getMaxEnhance() - 1), var_23_1)
	local var_23_3 = arg_23_0:getNextExp(arg_23_0.enhance)
	local var_23_4 = (arg_23_0.exp - var_23_0) / (var_23_3 - var_23_0)
	local var_23_5 = (var_23_2 - var_23_0) / (var_23_3 - var_23_0)
	
	return var_23_4, var_23_5
end

function EQUIP.getNextExp(arg_24_0, arg_24_1, arg_24_2)
	arg_24_1 = arg_24_1 or arg_24_0.enhance
	arg_24_2 = arg_24_2 or arg_24_0:isArtifact()
	
	if arg_24_0:isExclusive() then
		return 0
	end
	
	local var_24_0 = "exp"
	
	if arg_24_2 then
		var_24_0 = var_24_0 .. "_artifact"
	end
	
	return (math.floor(DB("itemenhance", tostring(arg_24_1), var_24_0) * to_n(arg_24_0.db.xp) * (DB("itemgrade", tostring(arg_24_0.grade), "need_xp_rate") or 0) + 0.5))
end

function EQUIP.getPassiveSkill(arg_25_0)
	return arg_25_0:getSkillId()
end

function EQUIP.isMaxEnhance(arg_26_0)
	return arg_26_0.enhance >= arg_26_0:getMaxEnhance()
end

function EQUIP.getMaxEnhance(arg_27_0, arg_27_1)
	if arg_27_0:isExclusive() then
		return 0
	end
	
	arg_27_1 = arg_27_1 or 0
	
	return math.min(30, 15 + (arg_27_0.dup_pt + arg_27_1) * 3)
end

function EQUIP.getDupPoint(arg_28_0)
	return arg_28_0.dup_pt
end

function EQUIP.setDupPoint(arg_29_0, arg_29_1)
	arg_29_0.dup_pt = arg_29_1
end

function EQUIP.getSkillId(arg_30_0)
	return arg_30_0.db.artifact_skill, arg_30_0.db.artifact_hiddenskill_1, arg_30_0.db.artifact_hiddenskill_2
end

function EQUIP.isEquip(arg_31_0)
	return true
end

function EQUIP.isArtifact(arg_32_0)
	return arg_32_0.db.type == "artifact"
end

function EQUIP.isForceLock(arg_33_0)
	if arg_33_0:isArtifact() then
		return arg_33_0.db.artifact_force_lock
	end
	
	return false
end

function EQUIP.isExclusive(arg_34_0)
	return arg_34_0.db.type == "exclusive"
end

function EQUIP.isRecallArtifactStone(arg_35_0)
	return arg_35_0.db.att_remark == "y" and arg_35_0:isArtifact() and arg_35_0:isStone()
end

function EQUIP.isCompatibleCategoryStone(arg_36_0, arg_36_1)
	if arg_36_0.db.type == "equip" and (arg_36_1 == "weapon" or arg_36_1 == "helm" or arg_36_1 == "armor" or arg_36_1 == "boot") then
		return true
	elseif arg_36_0.db.type == "jewellery" and (arg_36_1 == "neck" or arg_36_1 == "ring") then
		return true
	end
	
	return false
end

function EQUIP.calcEnhance(arg_37_0)
	arg_37_0.enhance = 0
	arg_37_0.enhance_rate = 0
	
	for iter_37_0 = 0, 29 do
		local var_37_0 = arg_37_0:getNextExp(iter_37_0)
		
		if arg_37_0.enhance >= arg_37_0:getMaxEnhance() or var_37_0 > arg_37_0.exp then
			break
		end
		
		arg_37_0.enhance = iter_37_0 + 1
	end
	
	local var_37_1, var_37_2, var_37_3 = DB("itemenhance", tostring(arg_37_0.enhance), {
		"power",
		"power_artifact",
		"add"
	})
	
	if arg_37_0:isArtifact() then
		arg_37_0.enhance_rate = var_37_2
	else
		arg_37_0.enhance_rate = var_37_1
	end
end

DEBUG = DEBUG or {}
DEBUG.SHOW_ORIGIN_EQUIP_POINT = false

function EQUIP.calcEquipPoint(arg_38_0, arg_38_1)
	arg_38_1 = arg_38_1 or {}
	
	if not arg_38_0:isBasicEquip(arg_38_1) then
		return 
	end
	
	local var_38_0 = {}
	
	for iter_38_0 = 1, 9999 do
		local var_38_1, var_38_2, var_38_3 = DBN("equipment_score", iter_38_0, {
			"id",
			"main_opt_score",
			"sub_opt_score"
		})
		
		if not var_38_1 then
			break
		end
		
		var_38_0[var_38_1] = {
			main_opt_score = var_38_2,
			sub_opt_score = var_38_3
		}
	end
	
	local var_38_4 = 0
	local var_38_5
	local var_38_6
	local var_38_7
	
	if arg_38_1.equip_stat and not table.empty(arg_38_1.equip_stat) then
		var_38_6 = arg_38_1.equip_stat[1][1]
		var_38_5 = arg_38_1.equip_stat[1][2]
		
		local var_38_8 = table.count(arg_38_1.equip_stat)
		
		var_38_7 = {}
		
		for iter_38_1 = 2, var_38_8 do
			local var_38_9 = arg_38_1.equip_stat[iter_38_1]
			
			if type(var_38_9[2]) == "table" then
				return nil
			end
			
			table.insert(var_38_7, var_38_9)
		end
	else
		var_38_5, var_38_6 = arg_38_0:getMainStat()
		var_38_7 = arg_38_0.opts
	end
	
	if var_38_6 and var_38_5 then
		if UNIT.is_percentage_stat(var_38_6) then
			var_38_5 = var_38_5 * 100
		end
		
		if var_38_0[var_38_6] and var_38_0[var_38_6].main_opt_score then
			var_38_5 = var_38_5 * var_38_0[var_38_6].main_opt_score
		end
		
		var_38_4 = var_38_4 + var_38_5
	end
	
	for iter_38_2, iter_38_3 in pairs(var_38_7) do
		local var_38_10 = iter_38_3[1]
		local var_38_11 = iter_38_3[2]
		
		if var_38_10 and var_38_11 then
			if UNIT.is_percentage_stat(var_38_10) then
				var_38_11 = var_38_11 * 100
			end
			
			if var_38_0[var_38_10] and var_38_0[var_38_10].sub_opt_score then
				var_38_11 = var_38_11 * var_38_0[var_38_10].sub_opt_score
			end
			
			var_38_4 = var_38_4 + var_38_11
		end
	end
	
	local var_38_12 = math.floor(var_38_4)
	
	if table.empty(arg_38_1) then
		arg_38_0.point = var_38_12
	end
	
	if PLATFORM == "win32" and DEBUG.SHOW_ORIGIN_EQUIP_POINT then
		arg_38_0.origin_point = var_38_4
		
		return var_38_4
	end
	
	return var_38_12
end

function EQUIP.getEquipPoint(arg_39_0)
	if PLATFORM == "win32" and DEBUG.SHOW_ORIGIN_EQUIP_POINT then
		return arg_39_0.origin_point or arg_39_0:calcEquipPoint()
	end
	
	return arg_39_0.point
end

function EQUIP.getSubStats(arg_40_0)
	local var_40_0 = {}
	
	for iter_40_0 = 2, table.count(arg_40_0.op or {}) do
		local var_40_1 = table.clone(arg_40_0.op[iter_40_0])
		
		if UNIT.is_percentage_stat(var_40_1[1]) then
			var_40_1[2] = to_var_str(var_40_1[2], var_40_1[1])
		else
			var_40_1[2] = comma_value(math.floor(var_40_1[2]))
		end
		
		table.insert(var_40_0, var_40_1)
	end
	
	return var_40_0
end

function EQUIP.getMainStat(arg_41_0)
	if arg_41_0:isStone() then
		return arg_41_0.grade / 1000, "att"
	end
	
	if not arg_41_0.stats[1] then
		return 0, "att"
	end
	
	if arg_41_0:isArtifact() and arg_41_0.stats[2] then
		local var_41_0 = arg_41_0.stats[1][1]
		local var_41_1 = arg_41_0.stats[1][2] * arg_41_0.enhance_rate
		local var_41_2 = arg_41_0.stats[2][1]
		local var_41_3 = arg_41_0.stats[2][2] * arg_41_0.enhance_rate
		
		return var_41_1, var_41_0, var_41_3, var_41_2
	end
	
	local var_41_4 = arg_41_0.stats[1][1]
	
	return arg_41_0.stats[1][2] * arg_41_0.enhance_rate, var_41_4
end

function EQUIP.update(arg_42_0)
	arg_42_0.random = getRandom(arg_42_0.seed, "equip")
	
	arg_42_0:setEquipStat()
	arg_42_0:calcEnhance()
	arg_42_0:calcEquipPoint()
	
	if arg_42_0.grade == 0 then
		arg_42_0.grade = arg_42_0.db.grade_min
	else
		arg_42_0.random:get(arg_42_0.db.grade_min, arg_42_0.db.grade_max)
	end
	
	return arg_42_0
end

function EQUIP.applyStat(arg_43_0, arg_43_1)
	arg_43_1:applyStat(arg_43_0.stats, arg_43_0.enhance_rate, {
		is_eqiuip = true
	})
	arg_43_1:applyStat(arg_43_0.opts, 1, {
		is_eqiuip = true
	})
end

function EQUIP.applyStatus(arg_44_0, arg_44_1)
	arg_44_1:applyStatus(arg_44_0.stats, arg_44_0.enhance_rate, {
		is_eqiuip = true
	})
	arg_44_1:applyStatus(arg_44_0.opts, 1, {
		is_eqiuip = true
	})
end

function EQUIP.applyExclusiveSkill(arg_45_0, arg_45_1)
	arg_45_1:applyExclusiveSkill(arg_45_0.exclusive_id)
end

function EQUIP.getSkillLevel(arg_46_0, arg_46_1)
	if not arg_46_0:isArtifact() then
		return 0
	end
	
	return math.floor(arg_46_0.enhance / 3)
end

function EQUIP.getMaxSkillLevel(arg_47_0)
	if not arg_47_0:isArtifact() then
		return 0
	end
	
	return math.floor(arg_47_0:getMaxEnhance() / 3)
end

function EQUIP.applyBooster(arg_48_0, arg_48_1)
	arg_48_1:applyBooster(arg_48_0.stats, arg_48_0.enhance_rate, {
		is_eqiuip = true
	})
	arg_48_1:applyBooster(arg_48_0.opts, 1, {
		is_eqiuip = true
	})
end

function EQUIP.getOptionCount(arg_49_0, arg_49_1)
	local var_49_0 = 0
	
	for iter_49_0, iter_49_1 in pairs(arg_49_0.opts) do
		if iter_49_1[1] == arg_49_1 then
			var_49_0 = var_49_0 + 1
		end
	end
	
	return var_49_0
end

function EQUIP.getOptLevel(arg_50_0)
	return math.min(5, #arg_50_0.opts)
end

function EQUIP.putOn(arg_51_0, arg_51_1)
	arg_51_0.parent = arg_51_1:getUID()
end

function EQUIP.putOff(arg_52_0)
	arg_52_0.parent = nil
end

if Account and Account.units then
	for iter_0_0, iter_0_1 in pairs(Account.equips or {}) do
		copy_functions(EQUIP, iter_0_1)
		iter_0_1:update()
	end
end

function EQUIP.makeDummyArtifact(arg_53_0, arg_53_1)
	local var_53_0, var_53_1 = DB("equip_stat", arg_53_0.db.main_stat .. "_1", {
		"stat_type",
		"val_min"
	})
	local var_53_2 = tonumber(var_53_1) or 0
	
	if not UNIT.is_percentage_stat(var_53_0) then
		var_53_2 = math.floor(var_53_2)
	end
	
	table.insert(arg_53_0.stats, {
		var_53_0,
		var_53_2
	})
end

function EQUIP.greaterThanExp(arg_54_0, arg_54_1)
	if arg_54_0.exp == arg_54_1.exp then
		return EQUIP.greaterThanGrade(arg_54_0, arg_54_1)
	end
	
	return arg_54_0.exp > arg_54_1.exp
end

function EQUIP.greaterThanEnhance(arg_55_0, arg_55_1)
	if arg_55_0.enhance == arg_55_1.enhance then
		return EQUIP.greaterThanGrade(arg_55_0, arg_55_1)
	end
	
	return arg_55_0.enhance > arg_55_1.enhance
end

function EQUIP.greaterThanID(arg_56_0, arg_56_1)
	local var_56_0 = string.split(arg_56_0.db.exclusive_unit, "c")
	local var_56_1 = string.split(arg_56_1.db.exclusive_unit, "c")
	
	if var_56_0[2] and var_56_1[2] then
		return var_56_0[2] > var_56_1[2]
	end
	
	return arg_56_0.db.exclusive_unit > arg_56_1.db.exclusive_unit
end

function EQUIP.greaterThanTier(arg_57_0, arg_57_1)
	return EQUIP.greaterThanItemLevel(arg_57_0, arg_57_1)
end

function EQUIP.greaterThanItemLevel(arg_58_0, arg_58_1)
	if arg_58_0.db.item_level == arg_58_1.db.item_level then
		return EQUIP.greaterThanGrade(arg_58_0, arg_58_1)
	end
	
	return (arg_58_0.db.item_level or 0) > (arg_58_1.db.item_level or 0)
end

function EQUIP.greaterThanPoint(arg_59_0, arg_59_1)
	if arg_59_0.point == arg_59_1.point then
		return EQUIP.greaterThanGrade(arg_59_0, arg_59_1)
	end
	
	return (arg_59_0.point or 0) > (arg_59_1.point or 0)
end

function EQUIP.greaterThanUID(arg_60_0, arg_60_1)
	return arg_60_0.id > arg_60_1.id
end

function EQUIP.greaterThanGrade(arg_61_0, arg_61_1)
	if arg_61_0.grade == arg_61_1.grade then
		return EQUIP.greaterThanCode(arg_61_0, arg_61_1)
	end
	
	return arg_61_0.grade > arg_61_1.grade
end

function EQUIP.greaterThanRole(arg_62_0, arg_62_1)
	if not arg_62_0:isArtifact() or not arg_62_1:isArtifact() then
		return EQUIP.greaterThanGrade(arg_62_0, arg_62_1)
	end
	
	if not arg_62_0.db.role and arg_62_1.db.role then
		return false
	end
	
	if not arg_62_1.db.role and arg_62_0.db.role then
		return true
	end
	
	if not arg_62_0.db.role and not arg_62_1.db.role then
		return nil
	end
	
	if var_0_3[arg_62_0.db.role] == var_0_3[arg_62_1.db.role] then
		return EQUIP.greaterThanGrade(arg_62_0, arg_62_1)
	end
	
	return var_0_3[arg_62_0.db.role] > var_0_3[arg_62_1.db.role]
end

function EQUIP.greaterThanName(arg_63_0, arg_63_1)
	if not arg_63_0:isArtifact() or not arg_63_1:isArtifact() then
		return EQUIP.greaterThanGrade(arg_63_0, arg_63_1)
	end
	
	if not arg_63_0.db.name and arg_63_1.db.name then
		return false
	end
	
	if not arg_63_1.db.name and arg_63_0.db.name then
		return true
	end
	
	if not arg_63_0.db.name and not arg_63_1.db.name then
		return nil
	end
	
	if arg_63_0.db.name == arg_63_1.db.name then
		return EQUIP.greaterThanGrade(arg_63_0, arg_63_1)
	end
	
	if arg_63_0.db.sort_name and arg_63_1.db.sort_name then
		return arg_63_0.db.sort_name < arg_63_1.db.sort_name
	end
	
	local var_63_0 = T(arg_63_0.db.name)
	local var_63_1 = T(arg_63_1.db.name)
	
	if getUserLanguage() == "th" then
		return var_63_0 < var_63_1
	end
	
	if isLatinAccentLanguage() then
		return utf8LatinAccentCompare(var_63_0, var_63_1)
	end
	
	return var_63_0 < var_63_1
end

function EQUIP.greaterThanCode(arg_64_0, arg_64_1)
	if arg_64_0:isArtifact() and arg_64_1:isArtifact() and arg_64_0.grade ~= arg_64_1.grade then
		return arg_64_0.grade > arg_64_1.grade
	end
	
	if arg_64_0.db.type and arg_64_1.db.type and arg_64_0.db.type ~= arg_64_1.db.type then
		return var_0_2[arg_64_0.db.type] < var_0_2[arg_64_1.db.type]
	end
	
	if arg_64_0.code == arg_64_1.code then
		if arg_64_0.exp ~= arg_64_1.exp then
			return arg_64_0.exp > arg_64_1.exp
		else
			return arg_64_0.id > arg_64_1.id
		end
	end
	
	return arg_64_0.code > arg_64_1.code
end

function EQUIP.greaterThanSet(arg_65_0, arg_65_1)
	if arg_65_0:isArtifact() and arg_65_1:isArtifact() then
		return EQUIP.greaterThanGrade(arg_65_0, arg_65_1)
	end
	
	if arg_65_0.set_fx == arg_65_1.set_fx then
		return EQUIP.greaterThanExp(arg_65_0, arg_65_1)
	end
	
	return arg_65_0.set_order > arg_65_1.set_order
end

function EQUIP.greaterThanStat(arg_66_0, arg_66_1)
	local var_66_0, var_66_1 = arg_66_0:getMainStat()
	local var_66_2, var_66_3 = arg_66_1:getMainStat()
	local var_66_4 = string.find(var_66_1, "_rate") ~= nil
	
	if var_66_4 ~= (string.find(var_66_3, "_rate") ~= nil) then
		return var_66_4
	end
	
	if var_66_0 == var_66_2 then
		return EQUIP.greaterThanCode(arg_66_0, arg_66_1)
	end
	
	return var_66_2 < var_66_0
end

function EQUIP.checkSell(arg_67_0)
	return not arg_67_0.parent and not arg_67_0.lock and not arg_67_0:isForceLock()
end

function EQUIP.ignoreStoneEnhanceGold(arg_68_0)
	return arg_68_0.db.ston_not_sale == "y"
end

function EQUIP.isStone(arg_69_0)
	return arg_69_0.db.stone == "y"
end

function EQUIP.isLimitBreak(arg_70_0)
	return arg_70_0.db.limit_break ~= nil
end

function EQUIP.isBreakThrough(arg_71_0)
	return arg_71_0.db.breakthrough ~= nil
end

function EQUIP.isCraftUpgradable(arg_72_0)
	if arg_72_0:isArtifact() or not arg_72_0:isMaxEnhance() then
		return false
	end
	
	for iter_72_0 = 1, 99 do
		local var_72_0 = DBN("item_equip_upgrade", iter_72_0, {
			"item_equip_base"
		})
		
		if not var_72_0 then
			break
		end
		
		if var_72_0 == arg_72_0.code then
			return true
		end
	end
	
	return false
end

function EQUIP.isSubStatChanged(arg_73_0)
	if not arg_73_0.op or #arg_73_0.op <= 0 then
		return false
	end
	
	for iter_73_0, iter_73_1 in pairs(arg_73_0.op) do
		if iter_73_0 ~= 1 and iter_73_1 and iter_73_1[3] == "c" then
			return true
		end
	end
	
	return false
end

function EQUIP.getResetCount(arg_74_0)
	return arg_74_0.op and arg_74_0.op[1] and arg_74_0.op[1][5] or 0
end

function EQUIP.checkLimitBreak(arg_75_0, arg_75_1)
	if not arg_75_1 then
		return false
	end
	
	if arg_75_1.code == arg_75_0.code then
		return true
	end
	
	if not arg_75_0:isLimitBreak() then
		return false
	end
	
	if arg_75_1:isBreakThrough() then
		return false
	end
	
	local var_75_0 = to_n(arg_75_0.db.limit_break)
	
	return var_75_0 > 0 and var_75_0 == to_n(arg_75_1.grade)
end

function EQUIP.isUsable(arg_76_0)
	return not arg_76_0.lock and not arg_76_0.parent
end

function EQUIP.isBasicEquip(arg_77_0, arg_77_1)
	arg_77_1 = arg_77_1 or {}
	
	local var_77_0 = arg_77_1.type or arg_77_0.db.type
	local var_77_1
	
	if arg_77_1.is_stone ~= nil then
		var_77_1 = arg_77_1.is_stone
	else
		var_77_1 = arg_77_0:isStone()
	end
	
	return table.isInclude({
		"weapon",
		"helm",
		"armor",
		"ring",
		"boot",
		"neck"
	}, var_77_0) and not var_77_1
end

function EQUIP.getConsumeExp(arg_78_0)
	local var_78_0
	
	if arg_78_0.db.item_level and table.isInclude({
		"weapon",
		"helm",
		"armor",
		"ring",
		"boot",
		"neck"
	}, arg_78_0.db.type) then
		var_78_0 = tonumber(DB("item_equip_balance", tostring(arg_78_0.db.item_level), "get_xp"))
	end
	
	var_78_0 = var_78_0 or arg_78_0.db.get_xp
	
	return var_78_0 + math.floor(arg_78_0.exp * 0.5)
end

function EQUIP.getConsumeCost(arg_79_0, arg_79_1)
	local var_79_0 = math.floor(arg_79_0:getConsumeExp() * DB("itemgrade", tostring(arg_79_1.grade), "enchant_price") * (GAME_STATIC_VARIABLE.sell_item_value or 19) * (DB("equip_item", arg_79_1.code, "enchant_gold_rdc") or 1))
	
	if arg_79_0:isStone() and not arg_79_0:ignoreStoneEnhanceGold() then
		var_79_0 = math.floor(var_79_0 * 0.6)
	end
	
	return var_79_0
end

function EQUIP.isUpgradable(arg_80_0)
	if arg_80_0:isStone() then
		return false
	end
	
	if arg_80_0:isLimitBreak() then
		return false
	end
	
	if not arg_80_0:isArtifact() and arg_80_0.enhance >= 15 then
		return false
	end
	
	if arg_80_0:isArtifact() and arg_80_0.enhance >= 30 then
		return false
	end
	
	return true
end

function EQUIP.isExtractable(arg_81_0)
	if not arg_81_0.db or arg_81_0:isArtifact() or arg_81_0:isExclusive() or arg_81_0:isStone() or not arg_81_0.db.tier or not arg_81_0.db.item_level or not arg_81_0:isUsable() then
		return false
	end
	
	if arg_81_0.db.tier >= 7 and arg_81_0.db.item_level ~= 88 and arg_81_0.db.item_level ~= 90 then
		return false
	end
	
	if arg_81_0.db.item_level < 58 then
		return false
	end
	
	return true
end

function EQUIP.getUnequipCostRatio(arg_82_0)
	local var_82_0 = 1
	local var_82_1 = os.time()
	local var_82_2 = AccountData.substory_artifact_schedule or {}
	
	if arg_82_0.code and var_82_2[arg_82_0.code] then
		local var_82_3 = var_82_2[arg_82_0.code] or {}
		
		for iter_82_0, iter_82_1 in pairs(var_82_3) do
			if var_82_1 >= to_n(iter_82_1.start_time) and var_82_1 <= to_n(iter_82_1.end_time) then
				var_82_0 = 0
				
				break
			end
		end
	end
	
	return var_82_0
end

function EQUIP.getUnequipCost(arg_83_0)
	local var_83_0 = arg_83_0:getUnequipCostRatio()
	
	if not arg_83_0.db.tier then
		arg_83_0.db.tier = 1
	end
	
	local var_83_1 = var_83_0 * DB("equip_item_undress", tostring(arg_83_0.db.tier), "cost")
	
	if var_83_1 <= 0 then
		return math.max(var_83_1, 0)
	end
	
	if not arg_83_0:isArtifact() then
		var_83_1 = var_83_1 - Booster:getAddCalcValue(BOOSTERSKILL_EFFECT_TYPE.UNDRESS_EQUIP_REDUCE, var_83_1)
	else
		var_83_1 = var_83_1 - Booster:getAddCalcValue(BOOSTERSKILL_EFFECT_TYPE.UNDRESS_ARTIFACT_REDUCE, var_83_1)
	end
	
	if var_83_1 > 0 then
		var_83_1 = var_83_1 - Booster:getAddCalcValue(BOOSTERSKILL_EFFECT_TYPE.UNDRESS_ALLEQUIP_REDUCE, var_83_1)
	end
	
	return math.max(var_83_1, 0)
end

function EQUIP.isConsumable(arg_84_0, arg_84_1, arg_84_2)
	if arg_84_0:isArtifact() and arg_84_0.dup_pt < 5 and arg_84_1:checkLimitBreak(arg_84_0) then
		return true
	end
	
	if arg_84_0:isMaxEnhance() then
		if arg_84_2 then
			if arg_84_0:isArtifact() and arg_84_0.dup_pt < 5 then
				balloon_message_with_sound("artifact_select_same")
			else
				balloon_message_with_sound("cant_upgrade_more")
			end
		end
		
		return false
	end
	
	return true
end

function EQUIP.checkExclusive(arg_85_0, arg_85_1, arg_85_2)
	if arg_85_2.db.exclusive_unit and arg_85_2.db.exclusive_unit ~= arg_85_1.db.code then
		return false
	end
	
	return true
end

function EQUIP.checkRole(arg_86_0, arg_86_1)
	if arg_86_0.db.role and arg_86_0.db.role ~= arg_86_1.db.role then
		return false
	end
	
	if arg_86_0.db.character and arg_86_0.db.character ~= arg_86_1.db.code then
		return false
	end
	
	if arg_86_0.db.character_group and arg_86_0.db.character_group ~= arg_86_1.db.set_group then
		return false
	end
	
	if arg_86_0.db.exclusive_unit and arg_86_0.db.exclusive_unit ~= arg_86_1.db.code then
		return false
	end
	
	return true
end
