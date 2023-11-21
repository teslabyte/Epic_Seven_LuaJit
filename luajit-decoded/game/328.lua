TooltipUtil = {}

function TooltipUtil.setSkillInfo(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
end

function TooltipUtil.procSkillForm(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_2
	local var_2_1 = "(%a[%a%d_:]+)"
	local var_2_2 = 1
	
	while true do
		local var_2_3, var_2_4, var_2_5 = string.find(arg_2_1, var_2_1, var_2_2)
		
		if not var_2_3 then
			break
		end
		
		local var_2_6 = 0
		local var_2_7, var_2_8 = string.find(var_2_5 or "", ":")
		
		if var_2_7 then
			var_2_0 = string.sub(var_2_5, 1, var_2_7 - 1)
			var_2_5 = string.sub(var_2_5, var_2_8 + 1, -1)
		end
		
		if var_2_5 == "LEVEL" then
			var_2_6 = arg_2_3
		elseif var_2_5 == "POW" then
			local var_2_9, var_2_10 = UNIT.getSkillDB(arg_2_3, var_2_0, {
				"pow",
				"pow_growth"
			}, arg_2_4, arg_2_5)
			
			var_2_10 = var_2_10 or 0
			var_2_6 = var_2_9 + var_2_10 * arg_2_3
		elseif var_2_5 == "BEFORE_EFF_VALUE" then
			local var_2_11, var_2_12 = UNIT.getSkillDB(arg_2_3, var_2_0, {
				"sk_before_eff_value",
				"sk_before_eff_growth"
			}, arg_2_4, arg_2_5)
			
			var_2_12 = var_2_12 or 0
			var_2_6 = var_2_11 + var_2_12 * arg_2_3
		elseif string.starts(var_2_5, "EFF_VALUE") then
			local var_2_13 = string.sub(var_2_5, -1, -1)
			local var_2_14, var_2_15 = UNIT.getSkillDB(arg_2_3, var_2_0, {
				"sk_eff_value" .. var_2_13,
				"sk_eff_growth" .. var_2_13
			}, arg_2_4, arg_2_5)
			
			var_2_15 = var_2_15 or 0
			var_2_6 = var_2_14 + var_2_15 * arg_2_3
		elseif var_2_5 == "floor" then
			var_2_6 = "math.floor"
		elseif var_2_5 == "per" then
			var_2_6 = "math.percent"
		elseif var_2_5 == "per_s" then
			var_2_6 = "string.per_to_string"
		elseif string.starts(var_2_5, "CS_EFF_VALUE") then
			local var_2_16 = string.sub(var_2_5, -2, -2)
			local var_2_17 = string.sub(var_2_5, -1, -1)
			local var_2_18 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_eff_value" .. var_2_16, arg_2_4, arg_2_5)
			local var_2_19, var_2_20 = UNIT.getCSDB(arg_2_3, tostring(var_2_18), {
				"cs_eff_value" .. var_2_17,
				"cs_eff_valuegrow" .. var_2_17
			}, {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			})
			
			var_2_20 = var_2_20 or 0
			var_2_6 = var_2_19 + var_2_20 * arg_2_3
		elseif string.starts(var_2_5, "PS_EFF_VALUE") then
			local var_2_21 = string.sub(var_2_5, -1, -1)
			local var_2_22 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_passive", arg_2_4, arg_2_5)
			local var_2_23, var_2_24 = UNIT.getCSDB(arg_2_3, tostring(var_2_22), {
				"cs_eff_value" .. var_2_21,
				"cs_eff_valuegrow" .. var_2_21
			}, {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			})
			
			var_2_24 = var_2_24 or 0
			var_2_6 = var_2_23 + var_2_24 * arg_2_3
		elseif string.starts(var_2_5, "cs1_") then
			local var_2_25 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_eff_value1", arg_2_4, arg_2_5)
			
			var_2_6 = UNIT.getCSDB(arg_2_3, tostring(var_2_25), var_2_5, {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			}) or "000"
		elseif string.starts(var_2_5, "cs2_") then
			local var_2_26 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_eff_value2", arg_2_4, arg_2_5)
			
			var_2_6 = UNIT.getCSDB(arg_2_3, tostring(var_2_26), "cs_" .. string.sub(var_2_5, 5, -1), {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			}) or "000"
		elseif string.starts(var_2_5, "cs3_") then
			local var_2_27 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_eff_value3", arg_2_4, arg_2_5)
			
			var_2_6 = UNIT.getCSDB(arg_2_3, tostring(var_2_27), "cs_" .. string.sub(var_2_5, 5, -1), {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			}) or "000"
		elseif string.starts(var_2_5, "cs4_") then
			local var_2_28 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_eff_value4", arg_2_4, arg_2_5)
			
			var_2_6 = UNIT.getCSDB(arg_2_3, tostring(var_2_28), "cs_" .. string.sub(var_2_5, 5, -1), {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			}) or "000"
		elseif string.starts(var_2_5, "cs5_") then
			local var_2_29 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_eff_value5", arg_2_4, arg_2_5)
			
			var_2_6 = UNIT.getCSDB(arg_2_3, tostring(var_2_29), "cs_" .. string.sub(var_2_5, 5, -1), {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			}) or "000"
		elseif string.starts(var_2_5, "ps_") then
			local var_2_30 = UNIT.getSkillDB(arg_2_3, var_2_0, "sk_passive", arg_2_4, arg_2_5)
			
			var_2_6 = UNIT.getCSDB(arg_2_3, tostring(var_2_30), "cs_" .. string.sub(var_2_5, 4, -1), {
				skill_id = var_2_0,
				exclusive_bonus = arg_2_5
			}) or "000"
		elseif string.starts(var_2_5, "sk_") then
			var_2_6 = UNIT.getSkillDB(arg_2_3, var_2_0, var_2_5, arg_2_4, arg_2_5) or "000"
		else
			var_2_6 = var_2_5
		end
		
		var_2_2 = var_2_3 + string.len(var_2_6)
		arg_2_1 = Text:replace(arg_2_1, var_2_3, var_2_4, tostring(var_2_6))
	end
	
	arg_2_1 = loadstring("return " .. arg_2_1)()
	
	if arg_2_1 == nil then
		arg_2_1 = "XXX"
	end
	
	return arg_2_1
end

function TooltipUtil.getSkillTooltipText(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_4 or {}
	local var_3_1 = Text:getText(var_3_0.skill_desc or DB("skill", arg_3_1, "sk_description")) or ""
	local var_3_2 = "{([%l%d -_.*/+()]+)}"
	local var_3_3
	local var_3_4
	local var_3_5
	local var_3_6
	
	while true do
		local var_3_7, var_3_8, var_3_9 = string.find(var_3_1, var_3_2)
		
		if not var_3_7 then
			break
		end
		
		local var_3_10 = arg_3_0:procSkillForm(var_3_9, arg_3_1, arg_3_2, arg_3_3, var_3_0)
		
		var_3_1 = Text:replace(var_3_1, var_3_7, var_3_8, var_3_10)
	end
	
	return var_3_1
end

function TooltipUtil.procCSForm(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = 1
	
	while true do
		local var_4_1, var_4_2, var_4_3 = string.find(arg_4_1, "(%a[%a%d_:]+)", var_4_0)
		
		if not var_4_1 then
			break
		end
		
		local var_4_4 = 0
		local var_4_5
		
		if var_4_3 == "floor" then
			var_4_5 = "math.floor"
		elseif var_4_3 == "per" then
			var_4_5 = "math.percent"
		elseif var_4_3 == "per_s" then
			var_4_5 = "string.per_to_string"
		elseif string.starts(var_4_3, "cs_") then
			var_4_5 = UNIT.getCSDB(1, tostring(arg_4_2), "cs_" .. string.sub(var_4_3, 4, -1)) or "000"
		else
			var_4_5 = var_4_3
		end
		
		var_4_0 = var_4_1 + string.len(var_4_5)
		arg_4_1 = Text:replace(arg_4_1, var_4_1, var_4_2, tostring(var_4_5))
	end
	
	arg_4_1 = loadstring("return " .. arg_4_1)()
	
	if arg_4_1 == nil then
		arg_4_1 = "XXX"
	end
	
	return arg_4_1
end

function TooltipUtil.getCSTooltipText(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1 or ""
	local var_5_1 = "{([%l%d -_.*/+()]+)}"
	local var_5_2
	local var_5_3
	local var_5_4
	local var_5_5
	
	while true do
		local var_5_6, var_5_7, var_5_8 = string.find(var_5_0, var_5_1)
		
		if not var_5_6 then
			break
		end
		
		local var_5_9 = arg_5_0:procCSForm(var_5_8, arg_5_2)
		
		var_5_0 = Text:replace(var_5_0, var_5_6, var_5_7, var_5_9)
	end
	
	return var_5_0
end
