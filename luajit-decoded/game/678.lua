LotaLegacyData = ClassDef()
LotaLegacyDataInterface = {
	db = {
		skill_grade = 1,
		name = "",
		id = "",
		icon = "",
		desc = ""
	},
	inst = {
		uid = 0
	}
}

local var_0_0 = -1

function create_db_lota_legacy(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = table.clone(LotaLegacyDataInterface)
	
	var_1_0.db.id = arg_1_0
	var_1_0.db.icon = arg_1_1
	var_1_0.db.desc = arg_1_2
	var_1_0.db.name = arg_1_3
	var_1_0.db.skill_grade = arg_1_4
	
	return var_1_0
end

function create_test_lota_legacy_info(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = create_db_lota_legacy(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	
	var_2_0.inst.uid = var_0_0
	var_0_0 = var_0_0 - 1
	
	return var_2_0
end

function create_test_lota_legacy_data(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	return LotaLegacyData(arg_3_0, create_test_lota_legacy_info(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4))
end

function LotaLegacyData.create(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2 = arg_4_2 or {}
	
	local var_4_0 = DBT("clan_legacy_skill_data", arg_4_1, {
		"id",
		"name",
		"desc",
		"icon",
		"start_legacy",
		"grade",
		"skill_effect",
		"value",
		"duration"
	})
	
	var_4_0.icon = var_4_0.icon or "legacy_1_01"
	var_4_0.name = var_4_0.name or ""
	var_4_0.desc = var_4_0.desc or T("temp_legacy_t_id", {
		id = var_4_0.id
	})
	
	local var_4_1 = {
		db = var_4_0,
		inst = arg_4_2
	}
	
	return (LotaLegacyData(var_4_1))
end

function LotaLegacyData.constructor(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		arg_5_0[iter_5_0] = iter_5_1
	end
end

function LotaLegacyData.isStartLegacy(arg_6_0)
	return arg_6_0.db.start_legacy == "y"
end

function LotaLegacyData.isExistDuration(arg_7_0)
	return arg_7_0.db.duration ~= nil
end

function LotaLegacyData.addUseCount(arg_8_0)
	if not arg_8_0.inst.use_count then
		arg_8_0.inst.use_count = 0
	end
	
	arg_8_0.inst.use_count = arg_8_0.inst.use_count + 1
end

function LotaLegacyData.getDuration(arg_9_0)
	if arg_9_0.db.duration then
		return tonumber(arg_9_0.db.duration)
	end
	
	return nil
end

function LotaLegacyData.getUseCount(arg_10_0)
	return arg_10_0.inst.use_count or 0
end

function LotaLegacyData.getRemainCount(arg_11_0)
	if not arg_11_0:isExistDuration() then
		return -1
	end
	
	local var_11_0 = arg_11_0:getDuration()
	local var_11_1 = arg_11_0:getUseCount()
	
	return math.max(var_11_0 - var_11_1, 0)
end

function LotaLegacyData.getID(arg_12_0)
	return arg_12_0.db.id
end

function LotaLegacyData.getName(arg_13_0)
	return arg_13_0.db.name
end

function LotaLegacyData.getGrade(arg_14_0)
	return arg_14_0.db.grade
end

function LotaLegacyData.getDesc(arg_15_0)
	return arg_15_0.db.desc
end

function LotaLegacyData.getIcon(arg_16_0)
	return arg_16_0.db.icon
end

function LotaLegacyData.getSkillEffect(arg_17_0)
	return arg_17_0.db.skill_effect
end

function LotaLegacyData.getSkillValue(arg_18_0)
	return arg_18_0.db.value
end

function LotaLegacyData.getUID(arg_19_0)
	return arg_19_0.inst.uid
end
