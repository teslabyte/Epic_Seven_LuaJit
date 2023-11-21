CharPreviewData = {}

function CharPreviewData.getDiscardData(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2 < 1 then
		return 
	end
	
	local var_1_0 = {}
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		table.insert(var_1_0, {
			id = iter_1_0,
			tm = iter_1_1
		})
	end
	
	table.sort(var_1_0, function(arg_2_0, arg_2_1)
		return arg_2_0.tm < arg_2_1.tm
	end)
	
	local var_1_1 = {}
	
	for iter_1_2 = 1, arg_1_2 do
		if not var_1_0[iter_1_2] then
			break
		end
		
		var_1_1[var_1_0[iter_1_2].id] = var_1_0[iter_1_2].tm
	end
	
	return var_1_1
end

function CharPreviewData.savelocalData(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = {}
	
	for iter_3_0, iter_3_1 in pairs(AccountData.char_intro_schedules) do
		local var_3_3 = os.time()
		
		if var_3_3 > iter_3_1.start_time and var_3_3 < iter_3_1.end_time then
			var_3_2[iter_3_0] = iter_3_1.start_time
		end
	end
	
	for iter_3_2, iter_3_3 in pairs(arg_3_1) do
		if not var_3_2[iter_3_2] then
			var_3_0[iter_3_2] = -1
		elseif not arg_3_3[iter_3_2] then
			var_3_0[iter_3_2] = 0
		elseif arg_3_1[iter_3_2] ~= arg_3_2[iter_3_2] and arg_3_2[iter_3_2] == nil then
			var_3_0[iter_3_2] = iter_3_3
		elseif arg_3_1[iter_3_2] ~= arg_3_2[iter_3_2] and arg_3_2[iter_3_2] ~= nil then
			var_3_1[iter_3_2] = arg_3_2[iter_3_2]
		end
	end
	
	local var_3_4 = 0
	
	for iter_3_4, iter_3_5 in pairs(arg_3_2) do
		if arg_3_2[iter_3_4] ~= arg_3_1[iter_3_4] and arg_3_1[iter_3_4] == nil then
			var_3_1[iter_3_4] = iter_3_5
			var_3_4 = var_3_4 + 1
		end
	end
	
	local var_3_5 = table.count(arg_3_1)
	local var_3_6 = 10
	local var_3_7 = arg_3_0:getDiscardData(var_3_0, var_3_4 - (var_3_6 - var_3_5))
	
	for iter_3_6, iter_3_7 in pairs(var_3_7 or {}) do
		if string.starts(iter_3_6, "intro_") then
			iter_3_7 = "null"
			
			SAVE:setTempConfigData(iter_3_6, iter_3_7)
		end
	end
	
	for iter_3_8, iter_3_9 in pairs(var_3_1) do
		SAVE:setTempConfigData(iter_3_8, iter_3_9)
	end
	
	return 0
end

function CharPreviewData._debug_remove_all(arg_4_0)
	if not arg_4_0.vars or PRODUCTION_MODE then
		return 
	end
	
	if not AccountData then
		return false
	end
	
	if not AccountData.char_intro_schedules then
		return false
	end
	
	local var_4_0 = {}
	local var_4_1 = {}
	
	for iter_4_0, iter_4_1 in pairs(Account:getConfigDatas() or {}) do
		if string.starts(iter_4_0, "intro_") then
			var_4_1[iter_4_0] = iter_4_1
		end
	end
	
	if not var_4_1 then
		return 
	end
	
	local var_4_2 = {}
	local var_4_3 = false
	local var_4_4 = arg_4_0:getIntroSchedules()
	
	for iter_4_2, iter_4_3 in pairs(var_4_4) do
		local var_4_5 = os.time()
		local var_4_6 = DEBUG.IGNORE_ACCOUNT_DATA or var_4_1[iter_4_3.id] ~= iter_4_3.start_time
		
		if (DEBUG.IGNORE_TIME or var_4_5 > iter_4_3.start_time and var_4_5 < iter_4_3.end_time) and var_4_6 then
			var_4_0[iter_4_2] = DBT("char_intro", iter_4_2, {
				"id",
				"char",
				"char_gender",
				"skin",
				"sort",
				"tag",
				"sound",
				"stage_bg",
				"summary_bg",
				"back1",
				"back2",
				"back3",
				"front1",
				"front2",
				"front3",
				"start_intro",
				"end_intro",
				"skill_number"
			})
			var_4_0[iter_4_2].id = iter_4_3.id
			var_4_0[iter_4_2].char = iter_4_3.char
			var_4_0[iter_4_2].tag = iter_4_3.tag
			var_4_0[iter_4_2].sort = iter_4_3.sort
			var_4_0[iter_4_2].start_time = iter_4_3.start_time
			var_4_0[iter_4_2].end_time = iter_4_3.end_time
			
			if not arg_4_0:verifyData(var_4_0[iter_4_2]) then
				return nil
			end
			
			var_4_2[iter_4_3.id] = var_4_0[iter_4_2].start_time
			var_4_3 = true
		end
	end
	
	if var_4_3 then
		arg_4_0:savelocalData(var_4_1, var_4_2, var_4_4)
	else
		Log.e("AccountData.char_intro_schedules count is over 10.")
	end
	
	SAVE:sendQueryServerConfig()
end

function CharPreviewData.verifyData(arg_5_0, arg_5_1)
	if not arg_5_1 then
		Log.e("Could Not Load Data.")
		
		return false
	end
	
	local var_5_0 = {
		"id",
		"char",
		"sort",
		"stage_bg",
		"summary_bg",
		"start_intro",
		"end_intro"
	}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if not arg_5_1[iter_5_1] then
			Log.e("Could Not Load : " .. iter_5_1)
			
			return false
		end
	end
	
	if not DB("character", arg_5_1.char, "id") then
		Log.e("Not A Character.")
		
		return false
	end
	
	return true
end

function CharPreviewData.getIntroSchedules(arg_6_0)
	local var_6_0 = {}
	local var_6_1 = os.time()
	
	for iter_6_0, iter_6_1 in pairs(AccountData.char_intro_schedules) do
		if DEBUG.IGNORE_TIME or var_6_1 > iter_6_1.start_time and var_6_1 < iter_6_1.end_time then
			table.insert(var_6_0, {
				id = iter_6_0,
				time = iter_6_1.start_time,
				sort = iter_6_1.sort
			})
		end
	end
	
	table.sort(var_6_0, function(arg_7_0, arg_7_1)
		if arg_7_0.time == arg_7_1.time then
			return arg_7_0.sort < arg_7_1.sort
		end
		
		return arg_7_0.time > arg_7_1.time
	end)
	
	local var_6_2 = {}
	
	for iter_6_2 = 1, 10 do
		if not var_6_0[iter_6_2] then
			break
		end
		
		local var_6_3 = var_6_0[iter_6_2].id
		
		var_6_2[var_6_3] = AccountData.char_intro_schedules[var_6_3]
	end
	
	return var_6_2
end

function CharPreviewData.loadDB(arg_8_0)
	if not AccountData then
		return false
	end
	
	if not AccountData.char_intro_schedules then
		return false
	end
	
	local var_8_0 = {}
	local var_8_1 = {}
	
	for iter_8_0, iter_8_1 in pairs(Account:getConfigDatas() or {}) do
		if string.starts(iter_8_0, "intro_") then
			var_8_1[iter_8_0] = iter_8_1
		end
	end
	
	if not var_8_1 then
		return 
	end
	
	local var_8_2 = {}
	local var_8_3 = 0
	local var_8_4 = arg_8_0:getIntroSchedules()
	
	for iter_8_2, iter_8_3 in pairs(var_8_4) do
		local var_8_5 = os.time()
		local var_8_6 = DEBUG.IGNORE_ACCOUNT_DATA or var_8_1[iter_8_3.id] ~= iter_8_3.start_time
		
		if (DEBUG.IGNORE_TIME or var_8_5 > iter_8_3.start_time and var_8_5 < iter_8_3.end_time) and var_8_6 then
			var_8_0[iter_8_2] = DBT("char_intro", iter_8_2, {
				"id",
				"char",
				"char_gender",
				"skin",
				"sort",
				"tag",
				"sound",
				"stage_bg",
				"summary_bg",
				"back1",
				"back2",
				"back3",
				"front1",
				"front2",
				"front3",
				"start_intro",
				"end_intro",
				"skill_number"
			})
			var_8_0[iter_8_2].id = iter_8_3.id
			var_8_0[iter_8_2].char = iter_8_3.char
			var_8_0[iter_8_2].tag = iter_8_3.tag
			var_8_0[iter_8_2].sort = iter_8_3.sort
			var_8_0[iter_8_2].start_time = iter_8_3.start_time
			var_8_0[iter_8_2].end_time = iter_8_3.end_time
			
			if not arg_8_0:verifyData(var_8_0[iter_8_2]) then
				return nil
			end
			
			var_8_2[iter_8_3.id] = var_8_0[iter_8_2].start_time
			var_8_3 = var_8_3 + 1
		end
	end
	
	if var_8_3 > 0 and var_8_3 <= 10 then
		return var_8_0
	elseif var_8_3 > 10 then
		Log.e("AccountData.char_intro_schedules count is over 10.")
	end
	
	return nil
end

function CharPreviewData.saveSpecificUnit(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	if not AccountData then
		return false
	end
	
	if not AccountData.char_intro_schedules then
		return false
	end
	
	local var_9_0 = {}
	local var_9_1 = {}
	
	for iter_9_0, iter_9_1 in pairs(Account:getConfigDatas() or {}) do
		if string.starts(iter_9_0, "intro_") then
			var_9_1[iter_9_0] = iter_9_1
		end
	end
	
	if not var_9_1 then
		return 
	end
	
	local var_9_2 = {}
	local var_9_3 = false
	local var_9_4 = arg_9_0:getIntroSchedules()
	
	for iter_9_2, iter_9_3 in pairs(var_9_4) do
		if arg_9_1 == iter_9_3.char then
			local var_9_5 = os.time()
			local var_9_6 = DEBUG.IGNORE_ACCOUNT_DATA or var_9_1[iter_9_3.id] ~= iter_9_3.start_time
			
			if (DEBUG.IGNORE_TIME or var_9_5 > iter_9_3.start_time and var_9_5 < iter_9_3.end_time) and var_9_6 then
				var_9_0[iter_9_2] = DBT("char_intro", iter_9_2, {
					"id",
					"char",
					"char_gender",
					"skin",
					"sort",
					"tag",
					"sound",
					"stage_bg",
					"summary_bg",
					"back1",
					"back2",
					"back3",
					"front1",
					"front2",
					"front3",
					"start_intro",
					"end_intro",
					"skill_number"
				})
				var_9_0[iter_9_2].id = iter_9_3.id
				var_9_0[iter_9_2].char = iter_9_3.char
				var_9_0[iter_9_2].tag = iter_9_3.tag
				var_9_0[iter_9_2].sort = iter_9_3.sort
				var_9_0[iter_9_2].start_time = iter_9_3.start_time
				var_9_0[iter_9_2].end_time = iter_9_3.end_time
				
				if not arg_9_0:verifyData(var_9_0[iter_9_2]) then
					return nil
				end
				
				var_9_2[iter_9_3.id] = var_9_0[iter_9_2].start_time
				var_9_3 = true
				
				break
			end
		end
	end
	
	if var_9_3 then
		arg_9_0:savelocalData(var_9_1, var_9_2, var_9_4)
	else
		Log.e("AccountData.char_intro_schedules count is over 10.")
	end
end

function CharPreviewData.isShow(arg_10_0)
	if not AccountData then
		return false
	end
	
	if not Account:isMapCleared("ije010") then
		return false
	end
	
	if not AccountData.char_intro_schedules then
		return false
	end
	
	if not SAVE:isTutorialFinished() then
		return false
	end
	
	local var_10_0 = Account:getConfigDatas()
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = 0
	
	for iter_10_0, iter_10_1 in pairs(AccountData.char_intro_schedules) do
		local var_10_2 = os.time()
		local var_10_3 = DEBUG.IGNORE_ACCOUNT_DATA or var_10_0[iter_10_1.id] ~= iter_10_1.start_time
		
		if (DEBUG.IGNORE_TIME or var_10_2 > iter_10_1.start_time and var_10_2 < iter_10_1.end_time) and var_10_3 then
			var_10_1 = var_10_1 + 1
		end
	end
	
	if var_10_1 > 0 then
		return true
	end
	
	return false
end

function CharPreviewData.init(arg_11_0, arg_11_1)
	arg_11_0.vars = {}
	
	local var_11_0 = arg_11_1
	
	arg_11_0.vars.char_list = {}
	arg_11_0.vars.units = {}
	arg_11_0.vars.code_to_key = {}
	
	local var_11_1 = {}
	
	if not var_11_0 then
		var_11_0 = arg_11_0:loadDB()
		
		if not var_11_0 then
			return 
		end
	else
		for iter_11_0, iter_11_1 in pairs(var_11_0) do
			if not arg_11_0:verifyData(iter_11_1) then
				return 
			end
		end
	end
	
	arg_11_0.vars.db = var_11_0
	
	for iter_11_2, iter_11_3 in pairs(var_11_0) do
		table.insert(arg_11_0.vars.char_list, iter_11_3.char)
		
		arg_11_0.vars.units[iter_11_3.char] = UNIT:create({
			awake = 6,
			z = 6,
			d = 7,
			exp = 0,
			code = iter_11_3.char
		})
		arg_11_0.vars.code_to_key[iter_11_3.char] = iter_11_3.id
		var_11_1[iter_11_3.char] = iter_11_3.sort
	end
	
	table.sort(arg_11_0.vars.char_list, function(arg_12_0, arg_12_1)
		return var_11_1[arg_12_0] < var_11_1[arg_12_1]
	end)
	
	return true
end

function CharPreviewData.getCharacterList(arg_13_0)
	return arg_13_0.vars.char_list
end

function CharPreviewData.getTag(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.code_to_key[arg_14_1]
	
	if arg_14_0.vars.db[var_14_0] then
		return arg_14_0.vars.db[var_14_0].tag
	end
	
	return ""
end

function CharPreviewData.getSkin(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.code_to_key[arg_15_1]
	
	if arg_15_0.vars.db[var_15_0] then
		return arg_15_0.vars.db[var_15_0].skin
	end
	
	return nil
end

function CharPreviewData.getSkillIdx(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.code_to_key[arg_16_1]
	
	if arg_16_0.vars.db[var_16_0] then
		return arg_16_0.vars.db[var_16_0].skill_number
	end
	
	return 3
end

function CharPreviewData.getUnit(arg_17_0, arg_17_1)
	return arg_17_0.vars.units[arg_17_1]
end

function CharPreviewData.getGender(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.code_to_key[arg_18_1]
	
	if arg_18_0.vars.db[var_18_0] then
		return arg_18_0.vars.db[var_18_0].char_gender
	end
	
	return ""
end

function CharPreviewData.getKey(arg_19_0, arg_19_1)
	return arg_19_0.vars.code_to_key[arg_19_1]
end

function CharPreviewData.makeEnemy(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = {}
	
	for iter_20_0 = 1, 3 do
		table.insert(var_20_0, arg_20_1[arg_20_2 .. iter_20_0] or "")
	end
	
	return var_20_0
end

function CharPreviewData.getEnemyArray(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return {}
	end
	
	local var_21_0 = arg_21_0:makeEnemy(arg_21_1, "front")
	local var_21_1 = arg_21_0:makeEnemy(arg_21_1, "back")
	
	return {
		var_21_0[1],
		var_21_0[2],
		var_21_0[3],
		var_21_1[1],
		var_21_1[2],
		var_21_1[3]
	}
end

function CharPreviewData.getEnemy(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.code_to_key[arg_22_1]
	
	if arg_22_0.vars.db[var_22_0] then
		return arg_22_0:getEnemyArray(arg_22_0.vars.db[var_22_0])
	end
	
	return {}
end

function CharPreviewData.getSummaryBG(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.vars.code_to_key[arg_23_1]
	
	if arg_23_0.vars.db[var_23_0] then
		return arg_23_0.vars.db[var_23_0].summary_bg
	end
	
	return ""
end

function CharPreviewData.getFieldData(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.code_to_key[arg_24_1]
	
	if arg_24_0.vars.db[var_24_0] then
		return arg_24_0.vars.db[var_24_0].stage_bg
	end
	
	return ""
end

function CharPreviewData.getStartTime(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.vars.code_to_key[arg_25_1]
	
	if arg_25_0.vars.db[var_25_0] then
		return arg_25_0.vars.db[var_25_0].start_intro * 1000
	end
	
	return 0
end

function CharPreviewData.getEndTime(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.vars.code_to_key[arg_26_1]
	
	if arg_26_0.vars.db[var_26_0] then
		return arg_26_0.vars.db[var_26_0].end_intro * 1000
	end
	
	return 0
end
