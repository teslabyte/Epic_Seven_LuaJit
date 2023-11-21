MultiPromoteSelector = {}

local var_0_0 = {
	target = {
		tera_target = function(arg_1_0)
			return arg_1_0.db.code == "m8043"
		end,
		giga_target = function(arg_2_0)
			return arg_2_0.db.code == "m8042"
		end,
		mega_target = function(arg_3_0)
			return arg_3_0.db.code == "m8041"
		end,
		base_grade2_target = function(arg_4_0)
			return arg_4_0:getBaseGrade() == 2 and arg_4_0:getType() ~= "promotion"
		end
	},
	material = {
		base_grade3_material = function(arg_5_0)
			return arg_5_0:getBaseGrade() == 3 and arg_5_0:getType() ~= "promotion"
		end,
		devoted_unit_can_material = function(arg_6_0)
			return arg_6_0:getDevote() > 0
		end
	},
	target_on_true_check_condition = {
		lock_unit_target = function(arg_7_0)
			return arg_7_0:isLocked()
		end
	}
}
local var_0_1 = {
	target = {
		lock_unit_target = false,
		giga_target = true,
		high_grade_property_target = false,
		mega_target = true,
		tera_target = true,
		base_grade2_target = true
	},
	material = {
		devoted_unit_can_material = false,
		promotion_unit_property_material = false,
		base_grade3_material = false
	}
}
local var_0_2 = {
	target = {
		giga_target = true,
		tera_target = true,
		base_grade2_target = true,
		mega_target = true
	},
	material = {
		base_grade3_material = true,
		devoted_unit_can_material = true
	}
}

function MultiPromoteSelector.init(arg_8_0)
	arg_8_0.vars = {}
	arg_8_0.vars.select_opts = table.clone(var_0_1)
end

function MultiPromoteSelector.setDataSource(arg_9_0, arg_9_1)
	arg_9_0.vars.data = arg_9_1
end

function MultiPromoteSelector.setOption(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		if arg_10_0.vars.select_opts[iter_10_0] ~= nil then
			for iter_10_2, iter_10_3 in pairs(iter_10_1) do
				if arg_10_0.vars.select_opts[iter_10_0][iter_10_2] ~= nil then
					arg_10_0.vars.select_opts[iter_10_0][iter_10_2] = iter_10_3
				end
			end
		end
	end
end

function MultiPromoteSelector.getOption(arg_11_0)
	return arg_11_0.vars.select_opts
end

function MultiPromoteSelector.findUpgradeableTargets_iteratorFunc(arg_12_0, arg_12_1)
	if not arg_12_1:isMaxLevel() then
		return false
	end
	
	if arg_12_1:getGrade() >= 5 then
		return false
	end
	
	if arg_12_1.db.type == "xpup" then
		return false
	end
	
	if arg_12_1.db.type ~= "promotion" and arg_12_1:getBaseGrade() ~= 2 then
		return false
	end
	
	if arg_12_1.db.type == "limited" or arg_12_1:isForceLockCharacter() then
		return false
	end
	
	local var_12_0 = arg_12_0.vars.select_opts.target
	
	for iter_12_0, iter_12_1 in pairs(var_0_0.target) do
		if not var_12_0[iter_12_0] and iter_12_1(arg_12_1) then
			return false
		end
	end
	
	for iter_12_2, iter_12_3 in pairs(var_0_0.target_on_true_check_condition) do
		if var_12_0[iter_12_2] and iter_12_3(arg_12_1) then
			return false
		end
	end
	
	return true
end

function MultiPromoteSelector.findUpgradeableTargets(arg_13_0)
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.data) do
		if arg_13_0:findUpgradeableTargets_iteratorFunc(iter_13_1) then
			table.insert(var_13_0, iter_13_1)
		end
	end
	
	local var_13_1 = {
		m8041 = 2,
		m8043 = 4,
		m8042 = 3
	}
	local var_13_2 = arg_13_0.vars.select_opts.target
	
	table.sort(var_13_0, function(arg_14_0, arg_14_1)
		local var_14_0 = var_13_1[arg_14_0.db.code] or 1
		local var_14_1 = var_13_1[arg_14_1.db.code] or 1
		
		if var_14_0 ~= var_14_1 then
			if var_13_2.high_grade_property_target then
				return var_14_1 < var_14_0
			else
				return var_14_0 < var_14_1
			end
		end
		
		if arg_14_0:getGrade() ~= arg_14_1:getGrade() then
			if var_13_2.high_grade_property_target then
				return arg_14_0:getGrade() > arg_14_1:getGrade()
			else
				return arg_14_0:getGrade() < arg_14_1:getGrade()
			end
		end
		
		return arg_14_0:getUID() > arg_14_1:getUID()
	end)
	
	return var_13_0
end

function isCanMaterialInMultiPromote(arg_15_0, arg_15_1)
	if arg_15_0:isMaxLevel() then
		return false
	end
	
	if arg_15_0:getGrade() > 4 then
		return false
	end
	
	if arg_15_0:getBaseGrade() >= 4 then
		return false
	end
	
	if arg_15_0.db.type == "xpup" then
		return false
	end
	
	if arg_15_0.db.type == "limited" or arg_15_0:isForceLockCharacter() then
		return false
	end
	
	if arg_15_0.db.type == "devotion" then
		return false
	end
	
	if arg_15_1 then
		if not arg_15_0:isCanBeMaterial(nil, "Promote", arg_15_1) then
			return false
		end
	elseif arg_15_0:getUsableCodeList() then
		return false
	end
	
	return true
end

function MultiPromoteSelector.checkMaterialOpts(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.select_opts.material
	
	for iter_16_0, iter_16_1 in pairs(var_0_0.material) do
		if not var_16_0[iter_16_0] and iter_16_1(arg_16_1) then
			return false
		end
	end
	
	return true
end

function MultiPromoteSelector.getMaterialEnableUnits(arg_17_0, arg_17_1)
	local var_17_0 = {}
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.data) do
		if isCanMaterialInMultiPromote(iter_17_1, arg_17_1) and arg_17_0:checkMaterialOpts(iter_17_1) then
			if not var_17_0[iter_17_1:getGrade()] then
				var_17_0[iter_17_1:getGrade()] = {}
			end
			
			table.insert(var_17_0[iter_17_1:getGrade()], iter_17_1)
		end
	end
	
	return var_17_0
end

function MultiPromoteSelector.getTeamHashTbl(arg_18_0)
	local var_18_0 = {}
	
	for iter_18_0, iter_18_1 in pairs(Account:getReservedTeamSlot()) do
		local var_18_1 = AccountData.teams[iter_18_1]
		
		for iter_18_2 = 1, MAX_TEAM_UNIT_COUNT do
			if var_18_1[iter_18_2] then
				var_18_0[var_18_1[iter_18_2].inst.uid] = true
			end
		end
	end
	
	return var_18_0
end

function MultiPromoteSelector.findMaterials(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_1 then
		return 
	end
	
	arg_19_2 = arg_19_2 or arg_19_0:getTeamHashTbl()
	
	local var_19_0 = arg_19_0:getMaterialEnableUnits(arg_19_2)
	local var_19_1 = arg_19_0.vars.select_opts.material
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		table.sort(iter_19_1, function(arg_20_0, arg_20_1)
			local var_20_0 = arg_20_0:getType() == "promotion"
			local var_20_1 = arg_20_1:getType() == "promotion"
			
			if var_19_1.promotion_unit_property_material and var_20_0 ~= var_20_1 then
				return not var_20_0
			end
			
			if arg_20_0:getLv() ~= arg_20_1:getLv() then
				return arg_20_0:getLv() > arg_20_1:getLv()
			end
			
			return arg_20_0:getUID() > arg_20_1:getUID()
		end)
	end
	
	local var_19_2 = {}
	local var_19_3 = 0
	
	for iter_19_2 = 1, table.count(arg_19_1) do
		local var_19_4 = arg_19_1[iter_19_2]
		
		if not var_19_4 then
			break
		end
		
		local var_19_5 = var_19_0[var_19_4:getGrade()]
		
		if var_19_5 and table.count(var_19_5) >= var_19_4:getGrade() then
			var_19_2[var_19_4:getUID()] = {}
			
			for iter_19_3 = 1, var_19_4:getGrade() do
				local var_19_6 = table.pop(var_19_5)
				
				table.insert(var_19_2[var_19_4:getUID()], var_19_6)
			end
			
			var_19_3 = var_19_3 + 1
		end
		
		if var_19_3 == 10 then
			break
		end
	end
	
	return var_19_2
end

function MultiPromoteSelector.isMultiPromoteEnable(arg_21_0)
	local var_21_0 = arg_21_0.vars.select_opts
	
	arg_21_0.vars.select_opts = var_0_2
	
	local var_21_1 = arg_21_0:getTeamHashTbl()
	local var_21_2 = MultiPromoteSelector:findUpgradeableTargets()
	local var_21_3 = arg_21_0:getMaterialEnableUnits(var_21_1)
	
	arg_21_0.vars.select_opts = var_21_0
	
	for iter_21_0 = 1, table.count(var_21_2) do
		local var_21_4 = var_21_2[iter_21_0]
		
		if not var_21_4 then
			break
		end
		
		local var_21_5 = var_21_3[var_21_4:getGrade()]
		
		if var_21_5 and table.count(var_21_5) >= var_21_4:getGrade() then
			return true
		end
	end
	
	return false
end

MultiPromoteSelectorSave = {}

local var_0_3 = {
	"tera_target",
	"giga_target",
	"mega_target",
	"base_grade2_target",
	"lock_unit_target",
	"high_grade_property_target",
	"base_grade3_material",
	"promotion_unit_property_material",
	"devoted_unit_can_material"
}
local var_0_4 = {
	target = {
		"tera_target",
		"giga_target",
		"mega_target",
		"base_grade2_target",
		"lock_unit_target",
		"high_grade_property_target"
	},
	material = {
		"base_grade3_material",
		"promotion_unit_property_material",
		"devoted_unit_can_material"
	}
}

function MultiPromoteSelectorSave.save(arg_22_0, arg_22_1)
	local var_22_0 = ""
	
	for iter_22_0 = 1, table.count(var_0_4.target) do
		local var_22_1 = var_0_4.target[iter_22_0]
		
		if arg_22_1.target[var_22_1] then
			var_22_0 = var_22_0 .. "T"
		else
			var_22_0 = var_22_0 .. "F"
		end
	end
	
	for iter_22_1 = 1, table.count(var_0_4.material) do
		local var_22_2 = var_0_4.material[iter_22_1]
		
		if arg_22_1.material[var_22_2] then
			var_22_0 = var_22_0 .. "T"
		else
			var_22_0 = var_22_0 .. "F"
		end
	end
	
	return var_22_0
end

function MultiPromoteSelectorSave.load(arg_23_0, arg_23_1)
	local var_23_0 = table.count(var_0_4.target)
	local var_23_1 = table.count(var_0_4.material)
	local var_23_2 = {
		target = {},
		material = {}
	}
	
	for iter_23_0 = 1, var_23_0 do
		if string.sub(arg_23_1, iter_23_0, iter_23_0) == "T" then
			var_23_2.target[var_0_3[iter_23_0]] = true
		else
			var_23_2.target[var_0_3[iter_23_0]] = false
		end
	end
	
	for iter_23_1 = var_23_0 + 1, var_23_0 + var_23_1 do
		if string.sub(arg_23_1, iter_23_1, iter_23_1) == "T" then
			var_23_2.material[var_0_3[iter_23_1]] = true
		else
			var_23_2.material[var_0_3[iter_23_1]] = false
		end
	end
	
	return var_23_2
end
