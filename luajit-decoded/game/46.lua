Account = Account or {
	healing_units = {}
}

if not AccountData then
	AccountData = nil
end

local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	if ignore_crc32 then
		return 
	end
	
	if not bit then
		return 
	end
	
	if not bit.bxor64 then
		return 
	end
	
	if not bit.bhash64 then
		return 
	end
	
	local var_1_0 = math.random(268435456, 4294967295)
	
	local function var_1_1(arg_2_0, arg_2_1)
		if not arg_2_1 then
			return 
		end
		
		var_0_0[arg_2_0] = var_0_0[arg_2_0] or math.random(1, 1000)
		
		return bit.bhash64(arg_2_1 + var_0_0[arg_2_0])
	end
	
	local function var_1_2(arg_3_0, arg_3_1)
		if not arg_3_0 then
			return 
		end
		
		if arg_3_1 then
			if not arg_3_0 then
				return 
			end
			
			return bit.bxor64(arg_3_0[1] or 0, arg_3_0[2])
		end
		
		return {
			bit.bxor64(arg_3_0, var_1_0),
			var_1_0
		}
	end
	
	local function var_1_3(arg_4_0)
		local var_4_0 = {
			__index = function(arg_5_0, arg_5_1)
				local var_5_0 = getmetatable(arg_5_0)
				local var_5_1 = var_5_0.hash[arg_5_1]
				
				if var_5_1 then
					local var_5_2 = var_1_2(var_5_0.enval[arg_5_1], true)
					local var_5_3 = var_1_1(arg_5_1, var_5_2)
					
					if var_5_3 == var_5_1 then
					elseif not var_5_0.error[arg_5_1] then
						var_5_0.error[arg_5_1] = true
						
						if #g_UNIT_CONVIC < 5 then
							local var_5_4 = var_5_0.enval[arg_5_1] and var_5_0.enval[arg_5_1][1]
							local var_5_5 = var_5_0.enval[arg_5_1] and var_5_0.enval[arg_5_1][2]
							
							table.insert(g_UNIT_CONVIC, {
								reason = "mem." .. tostring(arg_5_1),
								k0 = arg_5_1,
								k1 = var_5_4,
								k2 = var_5_5,
								v0 = var_5_2,
								c0 = var_5_1,
								c1 = var_5_3
							})
						end
					end
					
					return var_5_2
				end
				
				return rawget(arg_5_0, arg_5_1)
			end,
			__newindex = function(arg_6_0, arg_6_1, arg_6_2)
				local var_6_0 = getmetatable(arg_6_0)
				
				if var_6_0.hash[arg_6_1] then
					var_6_0.enval[arg_6_1] = var_1_2(arg_6_2)
					var_6_0.hash[arg_6_1] = var_1_1(arg_6_1, arg_6_2)
					
					return 
				else
					rawset(arg_6_0, arg_6_1, arg_6_2)
				end
			end,
			__pairs = function(arg_7_0)
				local function var_7_0(arg_8_0, arg_8_1)
					local var_8_0
					local var_8_1
					
					arg_8_1, var_8_1 = next(arg_8_0, arg_8_1)
					
					if var_8_1 then
						return arg_8_1, var_8_1
					end
				end
				
				local var_7_1
				local var_7_2
				local var_7_3 = {}
				
				repeat
					local var_7_4
					
					var_7_1, var_7_4 = next(arg_7_0, var_7_1)
					
					if var_7_1 then
						var_7_3[var_7_1] = var_7_4
					end
				until not var_7_4
				
				local var_7_5 = getmetatable(arg_7_0)
				local var_7_6
				
				repeat
					local var_7_7
					
					var_7_6, var_7_7 = next(var_7_5.enval, var_7_6)
					
					if var_7_6 then
						var_7_3[var_7_6] = var_1_2(var_7_7, true)
					end
				until not var_7_7
				
				return var_7_0, var_7_3, nil
			end
		}
		
		if getmetatable(arg_4_0) then
			return arg_4_0
		end
		
		local var_4_1 = {}
		local var_4_2 = {}
		local var_4_3 = {}
		
		for iter_4_0, iter_4_1 in pairs(arg_4_0) do
			if type(iter_4_1) == "number" then
				var_4_3[iter_4_0] = var_1_2(iter_4_1)
				var_4_2[iter_4_0] = var_1_1(iter_4_0, iter_4_1)
			else
				var_4_1[iter_4_0] = iter_4_1
			end
		end
		
		var_4_0.error = {}
		var_4_0.enval = var_4_3
		var_4_0.hash = var_4_2
		
		setmetatable(var_4_1, var_4_0)
		
		return var_4_1
	end
	
	local function var_1_4(arg_9_0)
		local var_9_0 = getmetatable(arg_9_0, nil)
		
		setmetatable(arg_9_0, nil)
		
		if var_9_0 and var_9_0.enval then
			for iter_9_0, iter_9_1 in pairs(var_9_0.enval) do
				arg_9_0[iter_9_0] = var_1_2(iter_9_1, true)
			end
		end
		
		return arg_9_0
	end
	
	if arg_1_1 then
		arg_1_0(var_1_3)
	else
		arg_1_0(var_1_4)
	end
end

local function var_0_2(arg_10_0, arg_10_1)
	local var_10_0 = math.random(268435456, 4294967295)
	
	local function var_10_1(arg_11_0, arg_11_1)
		return crc32_string(tostring(arg_11_0), arg_11_1)
	end
	
	local function var_10_2(arg_12_0, arg_12_1)
		if not arg_12_0 then
			return 
		end
		
		if arg_12_1 then
			if not arg_12_0 then
				return 
			end
			
			local var_12_0, var_12_1 = math.modf(tonumber(arg_12_0[2]) or 0)
			
			return crc32_xxor(arg_12_0[1] or 0, arg_12_0[3]) + var_12_1
		end
		
		local var_12_2, var_12_3 = math.modf(arg_12_0)
		
		return {
			crc32_xxor(var_12_2, var_10_0),
			var_12_3,
			var_10_0
		}
	end
	
	local function var_10_3(arg_13_0)
		local var_13_0 = {
			__index = function(arg_14_0, arg_14_1)
				local var_14_0 = getmetatable(arg_14_0)
				local var_14_1 = var_14_0.crc32[arg_14_1]
				
				if var_14_1 then
					local var_14_2 = var_10_2(var_14_0.enval[arg_14_1], true)
					
					if var_10_1(arg_14_1, var_14_2) == var_14_1 then
					elseif not var_14_0.error[arg_14_1] then
						var_14_0.error[arg_14_1] = true
						
						if #g_UNIT_CONVIC < 5 then
							if var_14_0.enval[arg_14_1] then
								local var_14_3 = var_14_0.enval[arg_14_1][1]
							end
							
							if var_14_0.enval[arg_14_1] then
								local var_14_4 = var_14_0.enval[arg_14_1][2]
							end
							
							if var_14_0.enval[arg_14_1] then
								local var_14_5 = var_14_0.enval[arg_14_1][3]
							end
						end
					end
					
					return var_14_2
				end
				
				return rawget(arg_14_0, arg_14_1)
			end,
			__newindex = function(arg_15_0, arg_15_1, arg_15_2)
				local var_15_0 = getmetatable(arg_15_0)
				
				if var_15_0.crc32[arg_15_1] then
					var_15_0.enval[arg_15_1] = var_10_2(arg_15_2)
					var_15_0.crc32[arg_15_1] = var_10_1(arg_15_1, arg_15_2)
					
					return 
				end
				
				rawset(arg_15_0, arg_15_1, arg_15_2)
			end,
			__pairs = function(arg_16_0)
				local function var_16_0(arg_17_0, arg_17_1)
					local var_17_0
					local var_17_1
					
					arg_17_1, var_17_1 = next(arg_17_0, arg_17_1)
					
					if var_17_1 then
						return arg_17_1, var_17_1
					end
				end
				
				local var_16_1
				local var_16_2
				local var_16_3 = {}
				
				repeat
					local var_16_4
					
					var_16_1, var_16_4 = next(arg_16_0, var_16_1)
					
					if var_16_1 then
						var_16_3[var_16_1] = var_16_4
					end
				until not var_16_4
				
				local var_16_5 = getmetatable(arg_16_0)
				local var_16_6
				
				repeat
					local var_16_7
					
					var_16_6, var_16_7 = next(var_16_5.enval, var_16_6)
					
					if var_16_6 then
						var_16_3[var_16_6] = var_10_2(var_16_7, true)
					end
				until not var_16_7
				
				return var_16_0, var_16_3, nil
			end
		}
		
		if getmetatable(arg_13_0) then
			return arg_13_0
		end
		
		local var_13_1 = {}
		local var_13_2 = {}
		local var_13_3 = {}
		local var_13_4 = {}
		
		for iter_13_0, iter_13_1 in pairs(arg_13_0) do
			if type(iter_13_1) == "number" then
				var_13_4[iter_13_0] = var_10_2(iter_13_1)
				var_13_2[iter_13_0] = var_10_1(iter_13_0, iter_13_1)
			else
				var_13_1[iter_13_0] = iter_13_1
			end
		end
		
		var_13_0.error = {}
		var_13_0.enval = var_13_4
		var_13_0.crc32 = var_13_2
		
		setmetatable(var_13_1, var_13_0)
		
		return var_13_1
	end
	
	local function var_10_4(arg_18_0)
		local var_18_0 = getmetatable(arg_18_0, nil)
		
		setmetatable(arg_18_0, nil)
		
		if var_18_0 and var_18_0.enval then
			for iter_18_0, iter_18_1 in pairs(var_18_0.enval) do
				arg_18_0[iter_18_0] = var_10_2(iter_18_1, true)
			end
		end
		
		return arg_18_0
	end
	
	if AccountData and AccountData.currency then
		if arg_10_1 then
			AccountData.currency = var_10_3(AccountData.currency)
		else
			AccountData.currency = var_10_4(AccountData.currency)
		end
	end
end

function Account.loadConfig(arg_19_0)
end

function Account.getConfigDatas(arg_20_0)
	if not AccountData.config_datas then
		AccountData.config_datas = {}
	end
	
	if type(AccountData.config_datas) ~= "table" then
		Log.e("AccountData.config_datas is not table : ", AccountData.config_datas)
		
		AccountData.config_datas = {}
	end
	
	return AccountData.config_datas
end

function Account.setConfigDatas(arg_21_0, arg_21_1)
	AccountData.config_datas = arg_21_1 or {}
end

function Account.setConfigData(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0:getConfigDatas()[arg_22_1] = arg_22_2
end

function Account.getConfigData(arg_23_0, arg_23_1)
	local var_23_0 = SAVE:getTempConfigData(arg_23_1)
	
	if var_23_0 == "null" then
		return 
	end
	
	if var_23_0 == nil then
		var_23_0 = arg_23_0:getConfigDatas()[arg_23_1]
	end
	
	return var_23_0
end

function Account.getAccountNumberDescString(arg_24_0)
	if AccountData and AccountData.user_number then
		return string.format("%s: #%s", T("account_number"), tostring(AccountData and AccountData.user_number))
	elseif Stove.enable and Stove:getNickNameNo() then
		return string.format("Stove Nickname Number: #%s", tostring(Stove:getNickNameNo()))
	end
	
	return ""
end

function Account.getClearEvent(arg_25_0, arg_25_1)
	if not AccountData.clear_event then
		return 
	end
	
	return AccountData.clear_event[arg_25_1] or {}
end

function Account.setClearEvent(arg_26_0, arg_26_1, arg_26_2)
	if not AccountData.clear_event then
		AccountData.clear_event = {}
	end
	
	AccountData.clear_event[arg_26_1] = arg_26_2
end

local function var_0_3(arg_27_0, arg_27_1)
	arg_27_1 = arg_27_1 or {}
	
	if arg_27_0 == "system_story" then
		local var_27_0 = arg_27_1.backtype
		
		SubStoryEntrance:show("SYSTEM_STORY", var_27_0)
	elseif arg_27_0 == "chronicle" then
		SubStoryEntrance:show("CHRONICLE")
	elseif arg_27_0 == "collection_story" then
		CollectionController:onSelectLeftSelectBooks("story", arg_27_1)
	elseif arg_27_0 == "collection_booklist" then
		CollectionController:open()
	end
end

function MsgHandler.get_contents_data(arg_28_0)
	SubstorySystemStory:setSubstoryProgress(arg_28_0.attributes)
	SubstorySystemStory:setPickupOpenSchedules(arg_28_0.open_schedules)
	
	if arg_28_0.attributes then
		var_0_3(arg_28_0.caller, arg_28_0)
	else
		Log.e("get_contents_data", "nil_attributes")
	end
end

function Account.showServerResUI(arg_29_0, arg_29_1, arg_29_2)
	arg_29_2 = arg_29_2 or {}
	
	if not SubstorySystemStory:getSubstoryProgress() then
		local var_29_0 = arg_29_2.backtype
		
		query("get_contents_data", {
			caller = arg_29_1,
			backtype = var_29_0
		})
	else
		var_0_3(arg_29_1, arg_29_2)
	end
end

function Account.checkIncludeServerData(arg_30_0, arg_30_1)
	if arg_30_1 == "substory_progress" and not SubstorySystemStory:getSubstoryProgress() then
		local var_30_0 = SceneManager:getCurrentSceneName()
		
		Log.e("Account.checkIncludeServerData" .. arg_30_1 or "", var_30_0)
		SceneManager:nextScene("lobby")
	end
end

function Account.checkQueryEmptyDungeonData(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_2 and type(arg_31_2) ~= "table" then
		Log.e("r_values_type_err", "need_type_table")
		
		return 
	end
	
	local var_31_0
	
	if arg_31_2 then
		var_31_0 = json.encode(arg_31_2)
	end
	
	local function var_31_1()
		query("get_dungeon_all", {
			return_type = arg_31_1,
			return_values = var_31_0
		})
	end
	
	if AccountData.pass_event == nil then
		var_31_1()
		
		return true
	end
	
	if AccountData.clear_event == nil then
		var_31_1()
		
		return true
	end
	
	if AccountData.clear_way == nil then
		var_31_1()
		
		return true
	end
	
	if AccountData.worldmap_rewards == nil then
		var_31_1()
		
		return true
	end
	
	return false
end

function MsgHandler.get_dungeon_all(arg_33_0)
	if arg_33_0.account_data then
		AccountData.pass_event = arg_33_0.account_data.pass_event
		AccountData.clear_way = arg_33_0.account_data.clear_way
		AccountData.clear_event = arg_33_0.account_data.clear_event
		AccountData.worldmap_rewards = arg_33_0.account_data.worldmap_rewards
	end
	
	if AccountData.pass_event == nil or AccountData.clear_way == nil or AccountData.clear_event == nil or AccountData.worldmap_rewards == nil then
		Log.e("msghandler.get_dungeon_all", "no_data")
		
		return 
	end
	
	if arg_33_0.r_type == "dungeon_home.show" then
		DungeonHome:show(true)
	elseif arg_33_0.r_type == "substory_home.show" then
		if arg_33_0.r_value == "SYSTEM_STORY" then
			Account:showServerResUI("system_story")
		else
			SubStoryEntrance:show(arg_33_0.r_values.mode or "HOME", nil, true, arg_33_0.r_values)
		end
	elseif arg_33_0.r_type == "worldmap.nextscene" then
		WorldMapController:worldmap({
			no_check_dungeon = true
		})
	elseif arg_33_0.r_type == "movetopath" and arg_33_0.r_values and arg_33_0.r_values.path then
		movetoPath(arg_33_0.r_values.path)
	elseif arg_33_0.r_type == "collection" then
		SceneManager:nextScene("collection", arg_33_0.r_values or {})
	elseif arg_33_0.r_type == "collection.unitstory" and arg_33_0.r_values then
		CollectionController:open_unitStory(arg_33_0.r_values.code)
	elseif arg_33_0.r_type == "collection.booklist" then
		Account:showServerResUI("collection_booklist")
	elseif arg_33_0.r_type == "dungeon_list" then
		local var_33_0 = arg_33_0.r_values or {}
		
		SceneManager:nextScene("DungeonList", {
			mode = var_33_0.mode,
			req_open_exclusive_shop = var_33_0.req_open_exclusive_shop
		})
	elseif arg_33_0.r_type == "exception" then
		Log.e("msgHandler:get_dungeon_all", "exception_case")
		SceneManager:nextScene("lobby")
	elseif arg_33_0.r_type == "material_toolip" then
		local var_33_1 = Material_Tooltip:getMaterialTooltip(nil, arg_33_0.r_values.code, arg_33_0.r_values.opts)
		
		if var_33_1 then
			WidgetUtils:showPopup({
				popup = var_33_1
			})
		end
	end
end

function Account.setPassEvent(arg_34_0, arg_34_1, arg_34_2)
	if not AccountData.pass_event then
		AccountData.pass_event = {}
	end
	
	AccountData.pass_event[arg_34_1] = arg_34_2
end

function Account.addPassEvent(arg_35_0, arg_35_1, arg_35_2)
	if not AccountData.pass_event then
		AccountData.pass_event = {}
	end
	
	if not AccountData.pass_event[arg_35_1] then
		AccountData.pass_event[arg_35_1] = {}
	end
	
	AccountData.pass_event[arg_35_1][arg_35_2] = true
end

function Account.setClearWay(arg_36_0, arg_36_1, arg_36_2)
	if not AccountData.clear_way then
		Log.e("Account.setClearWay", "null_data")
		
		return 
	end
	
	if not AccountData.clear_way[arg_36_1] then
		AccountData.clear_way[arg_36_1] = {}
	end
	
	AccountData.clear_way[arg_36_1][arg_36_2] = true
end

function Account.getPassEvent(arg_37_0, arg_37_1)
	if not AccountData.pass_event then
		AccountData.pass_event = {}
	end
	
	return AccountData.pass_event[arg_37_1] or {}
end

function Account.setSysAchieves(arg_38_0, arg_38_1)
	AccountData.sys_achieve = arg_38_1
end

function Account.setTotalEvent(arg_39_0, arg_39_1, arg_39_2)
	if not AccountData.total_event then
		AccountData.total_event = {}
	end
	
	AccountData.total_event[arg_39_1] = arg_39_2
end

function Account.getTotalEvent(arg_40_0, arg_40_1)
	if not AccountData.total_event or not AccountData.total_event[arg_40_1] then
		return 0
	end
	
	return AccountData.total_event[arg_40_1]
end

function Account.getExplore(arg_41_0, arg_41_1)
	if not AccountData.total_event or not AccountData.pass_event or not AccountData.total_event[arg_41_1] or not AccountData.pass_event[arg_41_1] then
		return 0
	else
		if arg_41_0:isExpiredStage(arg_41_1) then
			return 0
		end
		
		if AccountData.total_event[arg_41_1] == 0 then
			return 0
		end
		
		local var_41_0 = 0
		
		for iter_41_0, iter_41_1 in pairs(AccountData.pass_event[arg_41_1]) do
			if iter_41_1 then
				var_41_0 = var_41_0 + 1
			end
		end
		
		local var_41_1 = var_41_0 / AccountData.total_event[arg_41_1] * 100
		
		if var_41_1 > 100 then
			var_41_1 = 100
		end
		
		return var_41_1
	end
end

function Account.getExploreRewardStep(arg_42_0, arg_42_1)
	if not AccountData.explore_reward_info then
		AccountData.explore_reward_info = {}
	end
	
	return AccountData.explore_reward_info[arg_42_1] or 0
end

function Account.setExploreRewardStep(arg_43_0, arg_43_1)
	if not arg_43_1 then
		return 
	end
	
	if not AccountData.explore_reward_info then
		AccountData.explore_reward_info = {}
	end
	
	AccountData.explore_reward_info[arg_43_1.enter_id] = arg_43_1.step
end

function Account.getMazeUsedUnit(arg_44_0, arg_44_1)
	if not AccountData.maze_used_unit then
		AccountData.maze_used_unit = {}
	end
	
	return AccountData.maze_used_unit[arg_44_1] or {}
end

function Account.setMazeUsedUnit(arg_45_0, arg_45_1)
	if not arg_45_1 then
		return 
	end
	
	if not AccountData.maze_used_unit then
		AccountData.maze_used_unit = {}
	end
	
	AccountData.maze_used_unit[arg_45_1.enter_id] = arg_45_1.unit_list
end

function Account.isMazeUsedUnit(arg_46_0, arg_46_1, arg_46_2)
	if not AccountData.maze_used_unit then
		AccountData.maze_used_unit = {}
	end
	
	if not arg_46_1 then
		return 
	end
	
	local var_46_0 = AccountData.maze_used_unit[arg_46_1] or {}
	local var_46_1, var_46_2, var_46_3 = Account:serverTimeMonthInfo()
	local var_46_4 = to_n(os.date("%Y%m", var_46_1))
	
	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		if tonumber(iter_46_0) == tonumber(arg_46_2) and var_46_4 == to_n(iter_46_1) then
			return true
		end
	end
end

function Account.isExpiredStage(arg_47_0, arg_47_1)
	local var_47_0 = os.time()
	
	if not arg_47_1 then
		return false
	end
	
	local var_47_1 = arg_47_0:getDungeonBaseInfo(arg_47_1)
	local var_47_2 = DB("level_enter", arg_47_1, "reset_term")
	
	if not var_47_1 or not var_47_2 then
		return false
	end
	
	local var_47_3 = false
	local var_47_4 = var_47_1.last_enter_time or var_47_0
	
	if var_47_2 == "week" then
		if Account:serverTimeWeekLocalDetail() > Account:serverTimeWeekLocalDetail(var_47_4) then
			var_47_3 = true
		end
	elseif var_47_2 == "day" then
		local var_47_5 = Account:serverTimeDayLocalDetail()
		
		if Account:serverTimeDayLocalDetail(var_47_4) < curr_day_id then
			var_47_3 = true
		end
	elseif var_47_2 == "month" then
		local var_47_6, var_47_7, var_47_8 = Account:serverTimeMonthInfo()
		
		if var_47_4 < var_47_6 then
			var_47_3 = true
		end
	else
		local var_47_9 = to_n(var_47_2)
		
		if var_47_9 > 0 then
			if var_47_0 - var_47_4 > var_47_9 * 60 then
				var_47_3 = true
			end
		else
			var_47_3 = false
		end
	end
	
	return var_47_3
end

function Account.resetConditonsByContentsType(arg_48_0)
	for iter_48_0, iter_48_1 in pairs(AccountData.conditions.groups) do
		if iter_48_1.contents_type == CONTENTS_TYPE.CLAN_MISSION then
			AccountData.conditions.groups[iter_48_0] = nil
		end
	end
end

function Account.updateConditions(arg_49_0, arg_49_1, arg_49_2)
	AccountData.conditions.groups[arg_49_1] = arg_49_2
end

function Account.setDungeonMissionState(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	arg_50_0:setDungeonMissionStateByMissionId(arg_50_1, arg_50_2, arg_50_3)
end

function Account.getEnterLimitInfo(arg_51_0, arg_51_1)
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		return nil
	end
	
	local var_51_0 = DB("level_enter", arg_51_1, "enter_limit")
	
	if not var_51_0 then
		return nil
	end
	
	local var_51_1, var_51_2 = DB("level_enter_limit", var_51_0, {
		"limit_count",
		"limit_period"
	})
	local var_51_3 = AccountData.limits[var_51_0]
	
	if var_51_3 == nil then
		return var_51_1, var_51_1, var_51_2, nil
	end
	
	if var_51_3.expire_tm < os.time() then
		return var_51_1, var_51_1, var_51_2, var_51_3.expire_tm
	else
		return var_51_1 - var_51_3.count, var_51_1, var_51_2, var_51_3.expire_tm
	end
end

function Account.getDungeonMissionInfo(arg_52_0, arg_52_1)
	return AccountData.dungeon_missions[arg_52_1] or {}
end

function Account.getQuestMissions(arg_53_0)
	return AccountData.quests.quests or {}
end

function Account.getChapterQuestMissions(arg_54_0)
	return AccountData.quests.chapter_quests or {}
end

function Account.getChapterQuestMission(arg_55_0, arg_55_1)
	return Account:getChapterQuestMissions()[arg_55_1] or {}
end

function Account.setEpisodeQuests(arg_56_0, arg_56_1)
	AccountData.quests.episode_quests = arg_56_1
end

function Account.setGrowthBoostInfo(arg_57_0, arg_57_1)
	AccountData.growth_boost = arg_57_1
end

function Account.getGrowthBoostInfo(arg_58_0)
	return AccountData.growth_boost
end

function Account.setDungeonMissionStateByMissionId(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	local var_59_0 = DB("level_enter", arg_59_1, "substory_contents_id")
	
	if var_59_0 then
		Account:setSubStoryDungeonMissionState(var_59_0, arg_59_1, arg_59_2, arg_59_3)
	else
		if AccountData.dungeon_missions[arg_59_1] == nil then
			AccountData.dungeon_missions[arg_59_1] = {}
		end
		
		if AccountData.dungeon_missions[arg_59_1][arg_59_2] == nil then
			AccountData.dungeon_missions[arg_59_1][arg_59_2] = {}
		end
		
		AccountData.dungeon_missions[arg_59_1][arg_59_2].state = arg_59_3
	end
end

function Account.deleteDungeonMissoins(arg_60_0, arg_60_1)
	if not arg_60_1 then
		return 
	end
	
	for iter_60_0, iter_60_1 in pairs(arg_60_1) do
		local var_60_0 = Account:getDungeonMissionInfo(iter_60_1)
		
		if var_60_0 then
			var_60_0[iter_60_0] = nil
		end
	end
end

function Account.getDungeonMissions(arg_61_0)
	return AccountData.dungeon_missions
end

function Account.getDeleteDungeonMissionTbl(arg_62_0, arg_62_1)
	local var_62_0 = {}
	local var_62_1 = 0
	
	if not AccountData.check_useless_dungeon_mission then
		AccountData.check_useless_dungeon_mission = table.clone(arg_62_0:getDungeonMissions() or {})
	end
	
	local var_62_2 = AccountData.check_useless_dungeon_mission
	
	if not var_62_2 then
		return nil
	end
	
	for iter_62_0, iter_62_1 in pairs(var_62_2) do
		local var_62_3 = false
		
		for iter_62_2, iter_62_3 in pairs(iter_62_1) do
			local var_62_4, var_62_5 = DB("mission_data", iter_62_2, {
				"id",
				"delete_flag"
			})
			
			if not var_62_4 or var_62_5 == "y" then
				var_62_0[iter_62_2] = iter_62_0
				var_62_3 = true
			end
		end
		
		if var_62_3 then
			var_62_1 = var_62_1 + 1
		end
		
		var_62_2[iter_62_0] = nil
		
		if var_62_1 >= 5 then
			break
		end
	end
	
	if table.count(var_62_0) <= 0 then
		return nil
	end
	
	return var_62_0
end

function Account.isDungeonMissionCleared(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = DB("level_enter", arg_63_1, "mission" .. arg_63_2)
	
	return arg_63_0:isDungeonMissionClearedByMissionId(arg_63_1, var_63_0)
end

function Account.isDungeonMissionClearedByMissionId(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = DB("level_enter", arg_64_1, "substory_contents_id")
	local var_64_1 = arg_64_0:isClearedDungeonMissionAdv(arg_64_1, arg_64_2)
	
	if not var_64_1 and var_64_0 then
		var_64_1 = arg_64_0:isClearedDungeonMissionSubstory(var_64_0, arg_64_1, arg_64_2)
	end
	
	return var_64_1
end

function Account.isClearedDungeonMissionAdv(arg_65_0, arg_65_1, arg_65_2)
	if AccountData.dungeon_missions[arg_65_1] == nil then
		return false
	end
	
	if AccountData.dungeon_missions[arg_65_1][arg_65_2] == nil then
		return false
	end
	
	return AccountData.dungeon_missions[arg_65_1][arg_65_2].state == DUNGEON_MISSION_STATE.CLEAR
end

function Account.isClearedDungeonMissionSubstory(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	local var_66_0 = arg_66_0:getSubStoryDungeonMissionsBySubstoryID(arg_66_1)
	
	if not var_66_0 then
		return false
	end
	
	if not var_66_0[arg_66_2] then
		return false
	end
	
	if not var_66_0[arg_66_2][arg_66_3] then
		return false
	end
	
	return var_66_0[arg_66_2][arg_66_3].state == DUNGEON_MISSION_STATE.CLEAR
end

function Account.getUrgentMissions(arg_67_0)
	return AccountData.urgent_missions or {}
end

function Account.setUrgentMission(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_1 then
		return 
	end
	
	if not arg_68_2 then
		return 
	end
	
	AccountData.urgent_missions[arg_68_1] = arg_68_2
end

function Account.setLastClearLand(arg_69_0, arg_69_1)
	AccountData.last_clear_land = arg_69_1
end

function Account.getLastClearLand(arg_70_0, arg_70_1)
	return AccountData.last_clear_land or "ije"
end

function Account.getFreeEquipCount(arg_71_0, arg_71_1)
	local var_71_0 = 0
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0.equips) do
		if not iter_71_1.parent and not iter_71_1:isStone() and iter_71_1.isArtifact and not iter_71_1:isArtifact() then
			var_71_0 = var_71_0 + 1
		end
	end
	
	return var_71_0
end

function Account.getFreeArtifactCount(arg_72_0)
	local var_72_0 = 0
	
	for iter_72_0, iter_72_1 in pairs(arg_72_0.equips) do
		if not iter_72_1.parent and not iter_72_1:isStone() and iter_72_1.isArtifact and iter_72_1:isArtifact() then
			var_72_0 = var_72_0 + 1
		end
	end
	
	return var_72_0
end

function Account.getDefaultEquipCount(arg_73_0)
	return GAME_STATIC_VARIABLE.inven_equip or 300
end

function Account.getDefaultArtifactCount(arg_74_0)
	return GAME_CONTENT_VARIABLE.inven_artifact or 300
end

function Account.getMaxEquipCount(arg_75_0)
	return GAME_STATIC_VARIABLE.inven_equip_max
end

function Account.getMaxArtifactCount(arg_76_0)
	return GAME_CONTENT_VARIABLE.inven_artifact_max
end

function Account.getCurrentEquipCount(arg_77_0)
	return AccountData.equip_inven or arg_77_0:getDefaultEquipCount()
end

function Account.getCurrentArtifactCount(arg_78_0)
	return AccountData.artifact_inven or arg_78_0:getDefaultArtifactCount()
end

function Account.getEquipStorageMaxCount(arg_79_0)
	return AccountData.storage_equip_inven or 200
end

function Account.getEquipStorageCount(arg_80_0)
	if AccountData.equip_storage then
		return table.count(AccountData.equip_storage or {})
	end
end

function Account.getDefaultHeroCount(arg_81_0)
	return GAME_STATIC_VARIABLE.inven_hero or 200
end

local function var_0_4(arg_82_0, arg_82_1)
	local var_82_0 = 0
	
	for iter_82_0 = arg_82_0, arg_82_1 do
		var_82_0 = var_82_0 + iter_82_0
	end
	
	return var_82_0
end

function Account.getIncHeroInvenCost(arg_83_0, arg_83_1)
	return arg_83_1 * GAME_STATIC_VARIABLE.inven_hero_add_price
end

function Account.getIncPetInvenCost(arg_84_0, arg_84_1)
	return arg_84_1 * GAME_STATIC_VARIABLE.inven_pet_add_price
end

function Account.getIncEquipInvenCost(arg_85_0, arg_85_1)
	return arg_85_1 * GAME_STATIC_VARIABLE.inven_equip_add_price
end

function Account.getIncArtiEquipInvenCost(arg_86_0, arg_86_1)
	return arg_86_1 * GAME_CONTENT_VARIABLE.inven_artifact_add_price
end

function Account.getMaxHeroCount(arg_87_0)
	return GAME_STATIC_VARIABLE.inven_hero_max
end

function Account.getCurrentHeroCount(arg_88_0)
	return AccountData.unit_inven or arg_88_0:getDefaultHeroCount()
end

function Account.getUsedHeroInventoryCount(arg_89_0)
	local var_89_0 = 0 + UnitLevelUp:get_unit_penguins_count()
	
	return #Account.units - var_89_0
end

function Account.getRemainHeroInventoryCount(arg_90_0)
	return Account:getCurrentHeroCount() - arg_90_0:getUsedHeroInventoryCount()
end

function Account.getMaxPetCount(arg_91_0)
	return GAME_STATIC_VARIABLE.inven_pet_max or 100
end

function Account.getDefaultPetCount(arg_92_0)
	return GAME_STATIC_VARIABLE.inven_pet or 50
end

function Account.getCurrentPetCount(arg_93_0)
	return AccountData.pet_inven or arg_93_0:getDefaultPetCount()
end

function Account.getDefaultPetCount(arg_94_0)
	return GAME_STATIC_VARIABLE.inven_pet or 50
end

function Account.getCurrentPetCount(arg_95_0)
	return AccountData.pet_inven or arg_95_0:getDefaultPetCount()
end

function Account.getStageScore(arg_96_0, arg_96_1)
	return ConditionContentsManager:getDungeonMissions():getStageScore(arg_96_1) or 0
end

function Account.isMapOpened(arg_97_0, arg_97_1)
	return SAVE:get("game.stage_open." .. arg_97_1) ~= nil
end

function Account.isMapsCleared(arg_98_0, arg_98_1)
	for iter_98_0, iter_98_1 in pairs(arg_98_1) do
		if arg_98_0:isMapCleared(iter_98_1) then
			return true
		end
	end
	
	return false
end

function Account.isMapCleared(arg_99_0, arg_99_1)
	local function var_99_0(arg_100_0)
		local var_100_0 = DB("level_enter", arg_100_0, "substory_contents_id")
		
		if var_100_0 and arg_99_0:isSubstoryMapCleared(var_100_0, arg_100_0) then
			return true
		end
		
		if not AccountData.dungeon_base[arg_100_0] then
			return false
		end
		
		if (AccountData.dungeon_base[arg_100_0].count or 0) <= 0 then
			return false
		end
		
		return true
	end
	
	local var_99_1 = DB("level_enter", arg_99_1, "change_enter_clear")
	
	if var_99_1 then
		local var_99_2 = string.split(var_99_1, ";")
		
		for iter_99_0, iter_99_1 in pairs(var_99_2) do
			if var_99_0(iter_99_1) then
				return true
			end
		end
	end
	
	return var_99_0(arg_99_1)
end

function Account.isSubstoryMapCleared(arg_101_0, arg_101_1, arg_101_2)
	if not AccountData.substory_dungeon_base then
		return false
	end
	
	local var_101_0 = AccountData.substory_dungeon_base[arg_101_1]
	
	if not var_101_0 then
		return false
	end
	
	if not var_101_0[arg_101_2] then
		return false
	end
	
	if (var_101_0[arg_101_2].count or 0) <= 0 then
		return false
	end
	
	return true
end

function Account.getMapClearCount(arg_102_0, arg_102_1)
	local var_102_0 = DB("level_enter", arg_102_1, "substory_contents_id")
	
	if var_102_0 then
		local var_102_1 = arg_102_0:getSubstoryMapClearCount(var_102_0, arg_102_1)
		
		if var_102_1 > 0 then
			return var_102_1
		end
	end
	
	if not AccountData.dungeon_base[arg_102_1] then
		return 0
	end
	
	return AccountData.dungeon_base[arg_102_1].count or 0
end

function Account.getSubstoryMapClearCount(arg_103_0, arg_103_1, arg_103_2)
	if not AccountData.substory_dungeon_base then
		return 0
	end
	
	local var_103_0 = AccountData.substory_dungeon_base[arg_103_1]
	
	if not var_103_0 then
		return 0
	end
	
	if not var_103_0[arg_103_2] then
		return 0
	end
	
	return var_103_0[arg_103_2].count or 0
end

function Account.setDungeonBaseInfo(arg_104_0, arg_104_1, arg_104_2)
	local var_104_0 = DB("level_enter", arg_104_1, "substory_contents_id")
	
	if var_104_0 and var_104_0 ~= "vewrda" then
		arg_104_0:setSubstoryDungeonBaseInfo(var_104_0, arg_104_1, arg_104_2)
		
		return 
	end
	
	AccountData.dungeon_base[arg_104_1] = arg_104_2
end

function Account.setSubstoryDungeonBaseInfo(arg_105_0, arg_105_1, arg_105_2, arg_105_3)
	if not AccountData.substory_dungeon_base then
		AccountData.substory_dungeon_base = {}
	end
	
	if not AccountData.substory_dungeon_base[arg_105_1] then
		AccountData.substory_dungeon_base[arg_105_1] = {}
	end
	
	AccountData.substory_dungeon_base[arg_105_1][arg_105_2] = arg_105_3
end

function Account.getDungeonBaseInfo(arg_106_0, arg_106_1)
	return AccountData.dungeon_base[arg_106_1]
end

function Account.getSubstoryDungeonBaseInfo(arg_107_0, arg_107_1, arg_107_2)
	if not AccountData.substory_dungeon_base then
		return nil
	end
	
	local var_107_0 = AccountData.substory_dungeon_base[arg_107_1]
	
	if not var_107_0 then
		return nil
	end
	
	return var_107_0[arg_107_2]
end

function Account.setSubstoryDungeonBaseInfos(arg_108_0, arg_108_1, arg_108_2)
	if not AccountData.substory_dungeon_base then
		AccountData.substory_dungeon_base = {}
	end
	
	AccountData.substory_dungeon_base[arg_108_1] = arg_108_2
end

function Account.removePet(arg_109_0, arg_109_1)
	for iter_109_0, iter_109_1 in pairs(arg_109_0.pets) do
		if iter_109_1:getUID() == arg_109_1 then
			table.remove(arg_109_0.pets, iter_109_0)
			
			return 
		end
	end
end

function Account.removePets(arg_110_0, arg_110_1)
	for iter_110_0, iter_110_1 in pairs(arg_110_1) do
		arg_110_0:removePet(iter_110_1)
	end
end

function Account.setUnitNoti(arg_111_0, arg_111_1, arg_111_2)
	if not arg_111_1 then
		return 
	end
	
	arg_111_2 = arg_111_2 or {}
	
	for iter_111_0, iter_111_1 in pairs(arg_111_2) do
		SAVE:setKeep(iter_111_0 .. arg_111_1.inst.uid, iter_111_1)
	end
end

function Account.removeUnit(arg_112_0, arg_112_1)
	for iter_112_0, iter_112_1 in pairs(arg_112_0.units) do
		if arg_112_1 == iter_112_1 or arg_112_1 == iter_112_1.inst.uid then
			SAVE:setKeep("unit_bg_" .. iter_112_1.inst.uid, nil)
			arg_112_0:clearEquipParent(iter_112_1.inst.uid)
			arg_112_0:setUnitNoti(iter_112_1, {})
			table.remove(arg_112_0.units, iter_112_0)
			SkillEffectFilterManager:removeUnit(iter_112_1)
			
			return 
		end
	end
end

function Account.removeUnits(arg_113_0, arg_113_1)
	for iter_113_0, iter_113_1 in pairs(arg_113_1) do
		arg_113_0:removeUnit(iter_113_1)
	end
end

function Account.initAutoSkillFlag(arg_114_0)
	arg_114_0.auto_skill_flags = nil
	arg_114_0.support_auto_skill_flag = nil
end

function Account.gettAutoSkillFlag(arg_115_0)
	return arg_115_0.auto_skill_flags, arg_115_0.support_auto_skill_flag
end

function Account.settAutoSkillFlag(arg_116_0, arg_116_1, arg_116_2)
	arg_116_0.auto_skill_flags = arg_116_1
	arg_116_0.support_auto_skill_flag = arg_116_2
end

function Account.getUnitAutoSkillFlag(arg_117_0, arg_117_1)
	if not arg_117_0.units then
		return false
	end
	
	for iter_117_0, iter_117_1 in pairs(arg_117_0.units) do
		if arg_117_1 == iter_117_1 or arg_117_1 == iter_117_1.inst.uid then
			return iter_117_1:getAutoSkillFlag()
		end
	end
	
	if to_n(arg_117_1) < 0 then
		if not arg_117_0.auto_skill_flags then
			arg_117_0.auto_skill_flags = {}
		end
		
		return arg_117_0.auto_skill_flags[tostring(arg_117_1)] == nil or arg_117_0.auto_skill_flags[tostring(arg_117_1)]
	end
	
	return arg_117_0.support_auto_skill_flag == nil or arg_117_0.support_auto_skill_flag
end

function Account.setUnitAutoSkillFlag(arg_118_0, arg_118_1, arg_118_2)
	if not arg_118_0.units then
		return 
	end
	
	for iter_118_0, iter_118_1 in pairs(arg_118_0.units) do
		if arg_118_1 == iter_118_1 or arg_118_1 == iter_118_1.inst.uid then
			query("set_unit_skill_mode", {
				uid = iter_118_1.inst.uid,
				flag = not arg_118_2
			})
			
			return iter_118_1:setAutoSkillFlag(arg_118_2)
		end
	end
	
	if type(arg_118_2) ~= "boolean" then
		arg_118_2 = nil
	end
	
	if to_n(arg_118_1) < 0 then
		if not arg_118_0.auto_skill_flags then
			arg_118_0.auto_skill_flags = {}
		end
		
		arg_118_0.auto_skill_flags[tostring(arg_118_1)] = arg_118_2
	else
		arg_118_0.support_auto_skill_flag = arg_118_2
	end
end

function Account.openMap(arg_119_0, arg_119_1)
	SAVE:set("game.stage_open." .. arg_119_1, true)
	SAVE:save()
end

function Account.checkEnterMap(arg_120_0, arg_120_1, arg_120_2)
	arg_120_2 = arg_120_2 or {}
	
	if DEBUG.MAP_DEBUG then
		return true
	end
	
	if arg_120_0:isMapCleared(arg_120_1) then
		return true
	end
	
	local function var_120_0(arg_121_0)
		if not arg_121_0 then
			return true
		end
		
		local var_121_0 = false
		local var_121_1 = string.split(arg_121_0, ";")
		
		for iter_121_0, iter_121_1 in pairs(var_121_1) do
			if not Account:isPlayedStory(iter_121_1) then
				arg_120_2.story_view = arg_120_2.story_view or {}
				
				table.push(arg_120_2.story_view, arg_121_0)
			else
				var_121_0 = true
				
				break
			end
		end
		
		return var_121_0
	end
	
	local function var_120_1(arg_122_0)
		if not arg_122_0 then
			return true
		end
		
		local var_122_0 = DB("level_enter", arg_120_1, "substory_contents_id")
		
		if not var_122_0 then
			return true
		end
		
		local var_122_1 = true
		
		if arg_122_0 ~= nil and arg_122_0 ~= "" then
			local var_122_2 = totable(arg_122_0)
			
			if var_122_2.time then
				local var_122_3 = Account:getSubStoryScheduleDBById(var_122_2.time)
				local var_122_4 = var_122_3.start_time
				local var_122_5 = var_122_3.end_time
				
				if var_122_3 and var_122_4 and var_122_5 then
					local var_122_6 = os.time()
					
					if var_122_6 < var_122_4 or var_122_5 < var_122_6 then
						var_122_1 = false
						arg_120_2.substory_time = arg_120_2.substory_time or {}
						
						table.push(arg_120_2.substory_time, var_122_4 - os.time())
					end
				end
			end
			
			local var_122_7 = var_122_2.substory_quest
			
			if var_122_7 then
				local var_122_8 = Account:getSubStoryQuest(var_122_7) or {}
				
				if var_122_8.state ~= SUBSTORY_QUEST_STATE.CLEAR and var_122_8.state ~= SUBSTORY_QUEST_STATE.REWARDED then
					var_122_1 = false
					arg_120_2.substory_quest = arg_120_2.substory_quest or {}
					
					table.push(arg_120_2.substory_quest, var_122_7)
				end
			end
			
			local var_122_9 = var_122_2.substory_achievement
			
			if var_122_9 then
				if type(var_122_9) == "string" then
					var_122_9 = {
						var_122_9
					}
				end
				
				for iter_122_0, iter_122_1 in pairs(var_122_9) do
					if ((Account:getSubStoryAchievement(iter_122_1) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE) == SUBSTORY_ACHIEVE_STATE.ACTIVE then
						var_122_1 = false
						arg_120_2.substory_achieve = arg_120_2.substory_achieve or {}
						
						table.push(arg_120_2.substory_achieve, iter_122_1)
						
						break
					end
				end
			end
			
			local var_122_10 = var_122_2.subcus
			local var_122_11 = var_122_2.count
			local var_122_12, var_122_13
			
			if var_122_10 and var_122_11 then
				var_122_12 = string.split(var_122_10, ";")
				var_122_13 = string.split(var_122_11, ";")
				
				for iter_122_2 = 1, 99 do
					if not var_122_12[iter_122_2] or not var_122_13[iter_122_2] then
						break
					end
					
					local var_122_14 = var_122_12[iter_122_2]
					local var_122_15 = tonumber(var_122_13[iter_122_2])
					local var_122_16 = DB("item_material", var_122_14, {
						"ma_type"
					})
					
					if not var_122_16 or var_122_16 ~= "subcus" then
						Log.e("err: check level_enter.db // req_map_substory", var_122_14)
						
						var_122_1 = false
						
						break
					end
					
					if var_122_15 > Account:getItemCount(var_122_14) then
						var_122_1 = false
						arg_120_2.subcus = arg_120_2.subcus or {}
						
						table.push(arg_120_2.subcus, var_122_14)
						
						break
					end
				end
			end
			
			local var_122_17 = var_122_2.festival_day
			
			if var_122_17 then
				local var_122_18 = Account:getSubStoryFestivalInfo(var_122_0)
				
				if not var_122_18 or var_122_18.day < tonumber(var_122_17) then
					var_122_1 = false
				end
			end
			
			local var_122_19 = var_122_2.complete_custom_mission
			local var_122_20
			
			if var_122_19 then
				var_122_20 = Account:getCustomMissions() or {}
				
				if type(var_122_19) == "string" then
					var_122_19 = {
						var_122_19
					}
				end
				
				for iter_122_3, iter_122_4 in pairs(var_122_19) do
					if not var_122_20[iter_122_4] or tonumber(var_122_20[iter_122_4].state) < tonumber(SUBSTORY_CUSTOM_MISSION_STATE.REWARDED) then
						var_122_1 = false
						arg_120_2.substory_custom_misison = arg_120_2.substory_custom_misison or {}
						
						table.push(arg_120_2.substory_custom_misison, iter_122_4)
						
						break
					end
				end
			end
			
			local var_122_21 = var_122_2.complete_travel
			
			if var_122_21 and not SubStoryTravel:isReceivedReward(var_122_21) then
				var_122_1 = false
			end
		end
		
		return var_122_1
	end
	
	local function var_120_2(arg_123_0)
		if not arg_123_0 then
			return true
		end
		
		local var_123_0 = true
		
		if arg_123_0 ~= nil and arg_123_0 ~= "" then
			local var_123_1 = totable(arg_123_0)
			
			if var_123_1.map then
				local var_123_2 = var_123_1.map
				
				if type(var_123_2) == "string" then
					var_123_2 = {
						var_123_2
					}
				end
				
				for iter_123_0, iter_123_1 in pairs(var_123_2) do
					if not arg_120_0:isMapCleared(iter_123_1) then
						var_123_0 = false
						arg_120_2.map_ids = arg_120_2.map_ids or {}
						
						table.push(arg_120_2.map_ids, iter_123_1)
						
						break
					end
				end
			end
			
			if var_123_1.or_map then
				local var_123_3 = var_123_1.or_map
				
				if type(var_123_3) == "string" then
					var_123_3 = {
						var_123_3
					}
				end
				
				local var_123_4 = {}
				
				var_123_0 = false
				
				for iter_123_2, iter_123_3 in pairs(var_123_3) do
					if arg_120_0:isMapCleared(iter_123_3) then
						var_123_0 = true
						
						break
					end
				end
			end
			
			if var_123_1.find_info_id then
				local var_123_5 = var_123_1.find_info_id
				
				if type(var_123_5) == "string" then
					var_123_5 = {
						var_123_5
					}
				end
				
				for iter_123_4, iter_123_5 in pairs(var_123_5) do
					local var_123_6 = string.split(iter_123_5, ".")
					local var_123_7 = var_123_6[1]
					local var_123_8 = var_123_6[2]
					
					if not (Account:getPassEvent(var_123_7) or {})[var_123_8] then
						var_123_0 = false
						
						break
					end
				end
			end
			
			if var_123_1.clear_info_id then
				local var_123_9 = var_123_1.clear_info_id
				
				if type(var_123_9) == "string" then
					var_123_9 = {
						var_123_9
					}
				end
				
				for iter_123_6, iter_123_7 in pairs(var_123_9) do
					local var_123_10 = string.split(iter_123_7, ".")
					
					if not AccountData.clear_way[var_123_10[1]] or not AccountData.clear_way[var_123_10[1]][var_123_10[2]] then
						var_123_0 = false
						arg_120_2.map_ids = arg_120_2.map_ids or {}
						
						table.push(arg_120_2.map_ids, var_123_10[1])
						
						break
					end
				end
			end
			
			if var_123_1.mission_id then
				local var_123_11 = var_123_1.mission_id
				
				if type(var_123_11) == "string" then
					var_123_11 = {
						var_123_11
					}
				end
				
				for iter_123_8, iter_123_9 in pairs(var_123_11) do
					if not ConditionContentsManager:isMissionCleared(iter_123_9) then
						var_123_0 = false
						
						break
					end
				end
			end
			
			if var_123_1.star then
				local var_123_12 = tonumber(var_123_1.star) or 0
				local var_123_13 = 0
				local var_123_14 = string.sub(arg_120_1 or "", 1, -4)
				
				if var_123_14 and string.len(var_123_14) > 0 then
					for iter_123_10 = 1, 20 do
						local var_123_15 = var_123_14 .. string.format("%03d", iter_123_10)
						
						if DB("level_enter", var_123_15, "type") then
							local var_123_16 = Account:getStageScore(var_123_15)
							
							if var_123_16 then
								var_123_13 = var_123_13 + var_123_16
							end
						end
					end
				end
				
				if var_123_13 < var_123_12 then
					var_123_0 = false
				end
			end
			
			if var_123_1.material_own then
				local var_123_17 = var_123_1.material_own
				
				if type(var_123_17) == "string" then
					var_123_17 = {
						var_123_17
					}
				end
				
				for iter_123_11, iter_123_12 in pairs(var_123_17) do
					if Account:getItemCount(iter_123_12) <= 0 then
						var_123_0 = false
						
						break
					end
				end
			end
		end
		
		return var_123_0
	end
	
	local var_120_3, var_120_4, var_120_5, var_120_6, var_120_7, var_120_8 = DB("level_enter", arg_120_1, {
		"req_map_progress",
		"or_req_map_progress",
		"or_req_map_progress2",
		"or_req_story_progress",
		"req_map_substory",
		"req_story_progress"
	})
	local var_120_9 = false
	
	if var_120_5 then
		local var_120_10 = string.split(var_120_5, "||")
		
		for iter_120_0, iter_120_1 in pairs(var_120_10) do
			if iter_120_1 and var_120_2(iter_120_1) then
				var_120_9 = true
				
				break
			end
		end
	end
	
	return var_120_0(var_120_8) and var_120_1(var_120_7) and (var_120_2(var_120_3) or var_120_4 and var_120_2(var_120_4) or var_120_5 and var_120_9 or var_120_6 and var_120_0(var_120_6))
end

function Account.getTeams(arg_124_0)
	return AccountData.teams
end

function Account.isInTeamRange(arg_125_0, arg_125_1)
	return table.find(arg_125_0:getReservedTeamSlot({
		exclude_svrteam = true
	}), arg_125_1) ~= nil
end

function Account.selectTeam(arg_126_0, arg_126_1)
	if arg_126_0:isInTeamRange(arg_126_1) then
		AccountData.teams.idx = arg_126_1
	end
end

function Account.getLobbyTeam(arg_127_0)
	local var_127_0 = arg_127_0:getTeam(arg_127_0:getLobbyTeamIdx())
	
	if not var_127_0 then
		local var_127_1 = Account:getCurrentTeamIndex()
		
		if not Account:isPublicTeam(var_127_1) then
			var_127_0 = arg_127_0:getTeam(1)
		else
			var_127_0 = arg_127_0:getTeam(var_127_1)
		end
	end
	
	return var_127_0
end

function Account.getLobbyTeamIdx(arg_128_0)
	return arg_128_0:getConfigData("lobby_team_idx") or 0
end

function Account.setLobbyTeamIdx(arg_129_0, arg_129_1)
	local var_129_0 = arg_129_1
	
	if not var_129_0 or not AccountData.teams[var_129_0] or not arg_129_0:isUnlockedTeam(var_129_0) then
		var_129_0 = 0
	end
	
	SAVE:setTempConfigData("lobby_team_idx", var_129_0)
end

function Account.getCurrentTeam(arg_130_0)
	return AccountData.teams[AccountData.teams.idx]
end

function Account.setLevel(arg_131_0, arg_131_1)
	if arg_131_1 > AccountData.level then
		ConditionContentsManager:dispatch("user.levelup", {
			level = arg_131_1
		})
	end
	
	AccountData.level = tonumber(arg_131_1) or 1
end

function Account.getLevel(arg_132_0)
	if not AccountData then
		return 0
	end
	
	return tonumber(AccountData.level) or 1
end

function Account.getTeam(arg_133_0, arg_133_1)
	arg_133_1 = arg_133_1 or AccountData.teams.idx
	
	local var_133_0, var_133_1
	
	if arg_133_1 == 29 then
		var_133_0 = Account:getCrehuntSeasonAttribute()
		
		if var_133_0 then
			var_133_1 = AccountData.teams[arg_133_1]
			
			for iter_133_0 = 1, 4 do
				if var_133_1[iter_133_0] and var_133_1[iter_133_0]:getColor() ~= var_133_0 then
					var_133_1[iter_133_0] = nil
				end
			end
		end
	end
	
	return AccountData.teams[arg_133_1]
end

function Account.buildTeamInfo(arg_134_0, arg_134_1)
	for iter_134_0, iter_134_1 in pairs(arg_134_0:getReservedTeamSlot()) do
		for iter_134_2 = 1, 7 do
			local var_134_0 = arg_134_1[tostring(iter_134_1)]
			
			if not var_134_0 then
				break
			end
			
			local var_134_1 = (var_134_0[1] or {})[iter_134_2] or 0
			
			if iter_134_1 == 11 and iter_134_2 == 5 then
				break
			end
			
			if var_134_1 > 0 then
				if iter_134_2 == PET_TEAM_IDX and iter_134_1 ~= 12 then
					local var_134_2 = arg_134_0:getPet(var_134_1)
					
					if var_134_2 then
						arg_134_0:petAddToTeam(var_134_2, iter_134_1)
					end
				else
					local var_134_3 = arg_134_0:getUnit(var_134_1)
					
					if var_134_3 then
						arg_134_0:addToTeam(var_134_3, iter_134_1, iter_134_2)
					end
				end
			end
		end
	end
end

function Account.isPublicTeam(arg_135_0, arg_135_1)
	for iter_135_0, iter_135_1 in pairs(arg_135_0:getReservedTeamSlot()) do
		if type(iter_135_0) == "number" and iter_135_1 == arg_135_1 then
			return true
		end
	end
	
	return false
end

function Account.isCoopTeam(arg_136_0, arg_136_1)
	for iter_136_0, iter_136_1 in pairs(arg_136_0:getCoopReservedTeamSlot()) do
		if iter_136_1 == arg_136_1 then
			return true
		end
	end
	
	return false
end

function Account.isUnlockedTeam(arg_137_0, arg_137_1)
	for iter_137_0, iter_137_1 in pairs(arg_137_0:getReservedTeamSlot()) do
		if type(iter_137_0) == "number" and iter_137_1 == arg_137_1 then
			return iter_137_0 <= AccountData.max_team
		end
	end
end

function Account.getMaxPublicReservedTeam(arg_138_0)
	return #arg_138_0:getPublicReservedTeamSlot()
end

function Account.getReservedTeamSlot(arg_139_0, arg_139_1)
	local var_139_0 = arg_139_1 or {}
	local var_139_1 = not var_139_0.private_only
	local var_139_2 = not var_139_0.public_only
	
	if var_139_0.public_only and var_139_0.private_only then
		var_139_1 = true
		var_139_2 = true
	end
	
	local var_139_3 = {}
	
	local function var_139_4(arg_140_0, arg_140_1, arg_140_2)
		arg_140_1 = arg_140_1 or arg_140_0
		
		for iter_140_0 = arg_140_0, arg_140_1 do
			if arg_140_2 then
				var_139_3["_" .. table.count(var_139_3) + 1] = iter_140_0
			else
				table.insert(var_139_3, iter_140_0)
			end
		end
	end
	
	local function var_139_5(arg_141_0, arg_141_1)
		var_139_4(arg_141_0, arg_141_1, true)
	end
	
	if var_139_1 then
		var_139_4(1, 10)
		var_139_4(1001, 1005)
	end
	
	if var_139_2 then
		if not var_139_0.exclude_svrteam then
			var_139_5(11)
			var_139_5(12)
		end
		
		var_139_5(13, 14)
		var_139_5(15, 16)
		var_139_5(17, 19)
		var_139_5(20)
		var_139_5(21, 22)
		var_139_5(23, 25)
		var_139_5(26)
		var_139_5(27, 28)
		var_139_5(29)
	end
	
	return var_139_3
end

function Account.getPublicReservedTeamSlot(arg_142_0)
	return arg_142_0:getReservedTeamSlot({
		public_only = true
	})
end

function Account.getCoopReservedTeamSlot(arg_143_0)
	return {
		17,
		18,
		19,
		21,
		22
	}
end

local var_0_5 = {
	[18] = 2,
	[17] = 1,
	[19] = 3,
	[21] = 4,
	[22] = 5
}

function Account.getCoopTeamIdx(arg_144_0, arg_144_1)
	return var_0_5[arg_144_1]
end

function Account.getPrivateReservedTeamSlot(arg_145_0)
	return arg_145_0:getReservedTeamSlot({
		private_only = true
	})
end

function Account.each_teams(arg_146_0, arg_146_1, ...)
	for iter_146_0, iter_146_1 in pairs(arg_146_0:getReservedTeamSlot()) do
		if arg_146_1 then
			local var_146_0 = type(iter_146_0) == "string"
			
			arg_146_1(AccountData.teams[iter_146_1], iter_146_1, var_146_0, ...)
		end
	end
end

function Account.initTeam(arg_147_0)
	AccountData.teams = {}
	
	for iter_147_0, iter_147_1 in pairs(arg_147_0:getReservedTeamSlot()) do
		AccountData.teams[iter_147_1] = {}
	end
	
	AccountData.teams.idx = 1
end

function Account.setTeams(arg_148_0, arg_148_1)
	arg_148_0:initTeam()
	arg_148_0:buildTeamInfo(arg_148_1)
end

function Account.hasTeamSameCodeUnit(arg_149_0)
	local var_149_0 = Account:getTeam()
	
	if var_149_0 then
		for iter_149_0, iter_149_1 in ipairs(var_149_0) do
			if iter_149_1 then
				for iter_149_2, iter_149_3 in ipairs(var_149_0) do
					if iter_149_3 and iter_149_0 ~= iter_149_2 and iter_149_1.db.code == iter_149_3.db.code then
						return true
					end
				end
			end
		end
	end
end

function Account.isTeamSameClassUnit(arg_150_0)
	local var_150_0 = Account:getTeam()
	local var_150_1 = {}
	
	for iter_150_0, iter_150_1 in pairs(var_150_0 or {}) do
		if not string.starts(iter_150_1.db.code, "s") then
			table.push(var_150_1, iter_150_1)
		end
	end
	
	if var_150_1 then
		for iter_150_2, iter_150_3 in pairs(var_150_1) do
			for iter_150_4, iter_150_5 in pairs(var_150_1) do
				if iter_150_2 ~= iter_150_4 and iter_150_3.db.role == iter_150_5.db.role then
					return true
				end
			end
		end
	end
end

function Account.getTeamMemberCount(arg_151_0, arg_151_1, arg_151_2)
	arg_151_1 = arg_151_1 or AccountData.teams.idx
	
	local var_151_0 = 0
	local var_151_1 = 5
	
	if arg_151_2 then
		var_151_1 = 4
	end
	
	for iter_151_0 = 1, var_151_1 do
		if AccountData.teams[arg_151_1][iter_151_0] then
			var_151_0 = var_151_0 + 1
		end
	end
	
	return var_151_0
end

function Account.getLeaderUnit(arg_152_0, arg_152_1)
	arg_152_1 = arg_152_1 or AccountData.teams.idx
	
	local var_152_0 = AccountData.teams[arg_152_1][1]
	
	if not var_152_0 then
		for iter_152_0, iter_152_1 in pairs(AccountData.teams[arg_152_1]) do
			if type(iter_152_1) == "table" then
				return iter_152_1
			end
		end
	end
	
	return var_152_0
end

function Account.getLeaderPos(arg_153_0, arg_153_1)
	arg_153_1 = arg_153_1 or AccountData.teams.idx
	
	return 1
end

function Account.getBattleTeam(arg_154_0, arg_154_1)
	arg_154_1 = arg_154_1 or AccountData.teams.idx
	
	local var_154_0 = {}
	
	for iter_154_0 = 1, 5 do
		var_154_0[iter_154_0] = AccountData.teams[arg_154_1][iter_154_0]
	end
	
	local var_154_1 = Team:makeTeamData(var_154_0)
	
	return Team:makeTeam(var_154_1)
end

function Account.getTeamRelations(arg_155_0, arg_155_1)
	local var_155_0 = {}
	
	for iter_155_0, iter_155_1 in pairs(arg_155_1 or {}) do
		if type(iter_155_1) == "table" and iter_155_1.db and iter_155_1.db.code then
			local var_155_1 = Account:getRelationUnit(iter_155_1.db.code).fx or {}
			
			var_155_0[iter_155_1.db.code] = var_155_1
		end
	end
	
	return var_155_0
end

function Account.getUnits(arg_156_0)
	return Account.units
end

function Account.isFull_Unit(arg_157_0)
	return #Account.units >= (AccountData.max_inven or 50)
end

function Account.isFull_Equip(arg_158_0)
	return #Account.equips >= (AccountData.max_equips or 50)
end

function Account.getUnit(arg_159_0, arg_159_1)
	if not Account.units then
		return 
	end
	
	local var_159_0 = #Account.units
	
	for iter_159_0 = 1, var_159_0 do
		if Account.units[iter_159_0].inst.uid == arg_159_1 then
			return Account.units[iter_159_0]
		end
	end
	
	local var_159_1 = #Account.summons
	
	for iter_159_1 = 1, var_159_1 do
		if Account.summons[iter_159_1].inst.uid == arg_159_1 then
			return Account.summons[iter_159_1]
		end
	end
	
	return nil
end

function Account.getUnitByCode(arg_160_0, arg_160_1)
	for iter_160_0, iter_160_1 in pairs(Account.units) do
		if iter_160_1.inst.code == arg_160_1 then
			return iter_160_1
		end
	end
	
	return nil
end

function Account.getUnitsByCode(arg_161_0, arg_161_1)
	local var_161_0 = #Account.units
	local var_161_1 = {}
	
	for iter_161_0 = 1, var_161_0 do
		if Account.units[iter_161_0].inst.code == arg_161_1 then
			table.insert(var_161_1, Account.units[iter_161_0])
		end
	end
	
	return var_161_1
end

function Account.getUnitsByVariationGroupCode(arg_162_0, arg_162_1)
	local var_162_0 = #Account.units
	local var_162_1 = {}
	
	for iter_162_0 = 1, var_162_0 do
		if Account.units[iter_162_0].db.variation_group == arg_162_1 then
			table.insert(var_162_1, Account.units[iter_162_0])
		end
	end
	
	return var_162_1
end

function Account.isHaveSameCodeUnit(arg_163_0, arg_163_1)
	local var_163_0 = #Account.units
	
	for iter_163_0 = 1, var_163_0 do
		if Account.units[iter_163_0].inst.code == arg_163_1 then
			return true
		end
	end
	
	return false
end

function Account.isHaveSameCodeArtifact(arg_164_0, arg_164_1)
	return arg_164_0:getEquipByCode(arg_164_1)
end

function Account.getSummonByCode(arg_165_0, arg_165_1)
	local var_165_0 = #Account.summons
	
	for iter_165_0 = 1, var_165_0 do
		if Account.summons[iter_165_0].inst.code == arg_165_1 then
			return Account.summons[iter_165_0]
		end
	end
	
	return nil
end

function Account.getPetInTeam(arg_166_0, arg_166_1)
	if not arg_166_0:canAddPetToTeam(arg_166_1) then
		return 
	end
	
	if not AccountData.teams[arg_166_1] or not AccountData.teams[arg_166_1][PET_TEAM_IDX] then
		return nil
	end
	
	return AccountData.teams[arg_166_1][PET_TEAM_IDX]
end

function Account.isPetInTeam(arg_167_0, arg_167_1, arg_167_2)
	if not arg_167_0:canAddPetToTeam(arg_167_2) then
		return 
	end
	
	if not AccountData.teams[arg_167_2] or not AccountData.teams[arg_167_2][PET_TEAM_IDX] then
		return false
	end
	
	return AccountData.teams[arg_167_2][PET_TEAM_IDX]:getUID() == arg_167_1:getUID()
end

function Account.isInCurrentTeam(arg_168_0, arg_168_1)
	return arg_168_0:isInTeam(arg_168_1, AccountData.teams.idx)
end

function Account.isPetEquip(arg_169_0, arg_169_1)
	for iter_169_0, iter_169_1 in pairs(arg_169_0:getPublicReservedTeamSlot()) do
		if arg_169_0:isPetInTeam(arg_169_1, iter_169_1) then
			return true
		end
	end
	
	if arg_169_0:isPetInTeam(arg_169_1, arg_169_0:getDescentPetTeamIdx()) then
		return true
	end
	
	if arg_169_0:isPetInTeam(arg_169_1, arg_169_0:getBurningPetTeamIdx()) then
		return true
	end
	
	return arg_169_0:isPetInLobby(arg_169_1)
end

function Account.isInTeam(arg_170_0, arg_170_1, arg_170_2)
	if not AccountData then
		return 
	end
	
	local var_170_0 = arg_170_1
	
	if type(arg_170_1) == "table" then
		var_170_0 = arg_170_1.inst.uid
	end
	
	if arg_170_2 == nil then
		for iter_170_0, iter_170_1 in pairs(arg_170_0:getReservedTeamSlot()) do
			if arg_170_0:isInTeam(var_170_0, iter_170_1) then
				return iter_170_1
			end
		end
		
		return false
	end
	
	for iter_170_2 = 1, 7 do
		if AccountData.teams[arg_170_2][iter_170_2] and AccountData.teams[arg_170_2][iter_170_2].inst.uid == var_170_0 then
			return arg_170_2
		end
	end
	
	return false
end

function Account.haveSameVariationGroupInTeam(arg_171_0, arg_171_1, arg_171_2)
	if arg_171_1 == nil or arg_171_1.db.variation_group == nil then
		return false
	end
	
	if arg_171_2 == nil then
		for iter_171_0, iter_171_1 in pairs(arg_171_0:getReservedTeamSlot({
			exclude_svrteam = true
		})) do
			if arg_171_0:haveSameVariationGroupInTeam(arg_171_1, iter_171_1) then
				return iter_171_1
			end
		end
		
		return false
	end
	
	for iter_171_2 = 1, 5 do
		if AccountData.teams[arg_171_2][iter_171_2] and AccountData.teams[arg_171_2][iter_171_2]:getUID() ~= arg_171_1:getUID() and AccountData.teams[arg_171_2][iter_171_2]:isSameVariationGroupOnlyPlayer(arg_171_1) then
			return iter_171_2
		end
	end
	
	return false
end

function Account.getTeamUnitPosByCode(arg_172_0, arg_172_1, arg_172_2, arg_172_3)
	if arg_172_2 == nil then
		for iter_172_0, iter_172_1 in pairs(arg_172_0:getReservedTeamSlot({
			exclude_svrteam = true
		})) do
			local var_172_0 = arg_172_0:isInTeamByCode(uid, iter_172_1)
			
			if var_172_0 then
				return var_172_0
			end
		end
		
		return nil
	end
	
	for iter_172_2 = 1, 5 do
		if AccountData.teams[arg_172_2][iter_172_2] and AccountData.teams[arg_172_2][iter_172_2].inst.code == arg_172_1 and (not arg_172_3 or arg_172_3 ~= AccountData.teams[arg_172_2][iter_172_2]) then
			return iter_172_2
		end
	end
end

function Account.getAutomatonTeamIndex(arg_173_0)
	return 20
end

function Account.getCrehuntTeamIndex(arg_174_0)
	return 29
end

function Account.getCurrentTeamIndex(arg_175_0)
	return AccountData.teams.idx
end

function Account.getTeamLeaderIndex(arg_176_0, arg_176_1)
	return 1
end

function Account.getTeamPoint(arg_177_0, arg_177_1)
	arg_177_1 = arg_177_1 or AccountData.teams.idx
	
	local var_177_0
	
	if type(arg_177_1) == "table" then
		var_177_0 = {}
		
		for iter_177_0 = 1, 10 do
			if arg_177_1[iter_177_0] then
				var_177_0[iter_177_0] = UNIT:create({
					code = arg_177_1[iter_177_0][1],
					exp = arg_177_1[iter_177_0][2]
				})
			end
		end
	else
		var_177_0 = arg_177_0:getBattleTeam(arg_177_1).units
	end
	
	local var_177_1 = 0
	
	for iter_177_1 = 1, 10 do
		local var_177_2 = var_177_0[iter_177_1]
		
		if var_177_2 then
			var_177_1 = var_177_1 + var_177_2:getPoint()
		end
	end
	
	return var_177_1
end

function getDungeonType(arg_178_0)
	local var_178_0 = arg_178_0
	local var_178_1, var_178_2 = DB("level_enter", arg_178_0, {
		"type",
		"contents_type"
	})
	
	if arg_178_0 == "pvp001" then
		var_178_0 = "pvp"
	elseif var_178_1 == "genie" then
		var_178_0 = string.match(arg_178_0, "^[a-zA-Z]+")
	elseif var_178_1 == "hunt" then
		if var_178_2 == "crehunt" then
			return "crehunt"
		end
		
		var_178_0 = string.match(arg_178_0, "^[a-zA-Z]+")
	elseif var_178_1 == "abyss" then
		if var_178_2 == "abyss" then
			var_178_0 = "abyss"
		elseif var_178_2 == "automaton" then
			var_178_0 = "automaton"
		end
	else
		var_178_0 = var_178_1 == "trial_hall" and "trial" or var_178_1 == "urgent" and "story" or not (var_178_2 ~= "adventure" and var_178_2 ~= "substory") and "story" or "etc"
	end
	
	return var_178_0
end

function Account.saveLocalCustomTeam(arg_179_0, arg_179_1, arg_179_2)
	local var_179_0 = {}
	
	for iter_179_0, iter_179_1 in pairs(arg_179_2) do
		local var_179_1 = tonumber(iter_179_0)
		local var_179_2 = iter_179_1:getUID()
		local var_179_3 = {
			pos = var_179_1,
			uid = var_179_2
		}
		
		table.insert(var_179_0, var_179_3)
	end
	
	SAVE:setKeep(arg_179_1, json.encode(var_179_0))
end

function Account.loadLocalCustomTeam(arg_180_0, arg_180_1)
	local var_180_0 = SAVE:getKeep(arg_180_1)
	
	if not var_180_0 then
		return {}
	end
	
	local var_180_1 = {}
	local var_180_2 = json.decode(var_180_0)
	
	for iter_180_0, iter_180_1 in pairs(var_180_2 or {}) do
		local var_180_3 = Account:getUnit(iter_180_1.uid)
		
		if var_180_3 then
			var_180_1[iter_180_1.pos] = var_180_3
		end
	end
	
	return var_180_1
end

function Account.saveLocalTeamIndex(arg_181_0, arg_181_1, arg_181_2)
	if arg_181_1 and arg_181_2 then
		local var_181_0 = tonumber(Stove:getNickNameNo()) or 0
		local var_181_1 = getDungeonType(arg_181_1)
		local var_181_2 = var_181_0 .. ":" .. var_181_1
		local var_181_3 = "local_team:" .. var_181_1
		
		SAVE:setTempConfigData(var_181_2, "null")
		
		if var_181_1 ~= "automaton" and arg_181_2 ~= arg_181_0:getAutomatonTeamIndex() then
			SAVE:setTempConfigData(var_181_3, arg_181_2)
		end
	end
end

function Account.loadLocalTeamIndex(arg_182_0, arg_182_1)
	if arg_182_1 then
		local var_182_0 = getDungeonType(arg_182_1)
		local var_182_1 = (tonumber(Stove:getNickNameNo()) or 0) .. ":" .. var_182_0
		local var_182_2 = "local_team:" .. var_182_0
		local var_182_3 = Account:getConfigData(var_182_2) or 0
		
		if var_182_3 == 0 then
			var_182_3 = Account:getConfigData(var_182_1) or 0
		end
		
		return var_182_3 > 0 and var_182_3 or nil
	end
end

function Account.resetTeam(arg_183_0, arg_183_1)
	AccountData.teams[arg_183_1] = {}
end

function Account.saveTeamInfo(arg_184_0, arg_184_1, arg_184_2)
	local var_184_0 = arg_184_2 or {}
	
	AccountData.last_team_check_point = AccountData.last_team_check_point or ""
	
	local var_184_1 = ""
	local var_184_2 = {}
	
	for iter_184_0, iter_184_1 in pairs(Account:getReservedTeamSlot()) do
		local var_184_3 = {
			point = 0,
			team = {}
		}
		local var_184_4 = Account:getTeam(iter_184_1)
		
		if var_184_4 then
			local var_184_5 = Team:makeTeamData(var_184_4)
			local var_184_6 = Team:makeTeam(var_184_5, true)
			
			for iter_184_2 = 1, 7 do
				local var_184_7
				local var_184_8
				local var_184_9 = var_184_4[iter_184_2]
				
				if var_184_9 and var_184_9.is_unit then
					var_184_7 = var_184_9
				elseif var_184_9 and var_184_9.is_pet then
					var_184_8 = var_184_9
				end
				
				if var_184_7 then
					for iter_184_3, iter_184_4 in pairs(var_184_6.units) do
						if not var_184_7:isNPC() and var_184_7:getUID() == iter_184_4:getUID() then
							var_184_7.inst.pos = iter_184_4.inst.pos
						end
					end
					
					var_184_7.apply_crc = false
					
					var_184_7:onSetupTeam(var_184_6)
					
					if var_184_7.calc then
						var_184_7:calc()
					end
					
					var_184_1 = var_184_1 .. var_184_7.inst.uid .. ","
					var_184_3.team[iter_184_2] = var_184_7.inst.uid
					var_184_3.point = var_184_3.point + var_184_7:getPoint()
					
					var_184_7:onSetupTeam(nil)
					
					var_184_7.inst.hp = nil
					var_184_7.inst.pos = nil
					var_184_7.apply_crc = true
					
					if var_184_7.calc then
						var_184_7:calc()
					end
				elseif var_184_8 then
					var_184_1 = var_184_1 .. var_184_8.inst.uid .. ","
					var_184_3.team[iter_184_2] = var_184_8.inst.uid
				else
					var_184_1 = var_184_1 .. ","
				end
			end
			
			var_184_1 = var_184_1 .. ":" .. var_184_3.point
		end
		
		var_184_1 = var_184_1 .. "-"
		var_184_2[tostring(iter_184_1)] = var_184_3
	end
	
	if var_184_1 == AccountData.last_team_check_point then
		return nil
	end
	
	AccountData.last_team_check_point = var_184_1
	
	local var_184_10 = json.encode(var_184_2)
	
	if not arg_184_1 then
		print("SAVING TEAM...")
		
		local var_184_11 = (SubstoryManager:getInfo() or {}).id
		
		query("save_team", {
			info = var_184_10,
			is_descent = var_184_0.is_descent,
			is_burning = var_184_0.is_burning,
			substory_id = var_184_11
		})
	end
	
	return var_184_10
end

function Account.copyTeam(arg_185_0, arg_185_1, arg_185_2, arg_185_3)
	AccountData.teams[arg_185_2] = {}
	
	for iter_185_0, iter_185_1 in pairs(AccountData.teams[arg_185_1]) do
		if not arg_185_3 or arg_185_3 ~= iter_185_0 then
			AccountData.teams[arg_185_2][iter_185_0] = iter_185_1
		end
	end
	
	return arg_185_0:getTeam(arg_185_2)
end

function Account.getTeamPos(arg_186_0, arg_186_1, arg_186_2)
	for iter_186_0 = 1, 7 do
		local var_186_0
		
		if tolua.type(arg_186_2) == "table" then
			var_186_0 = arg_186_2[iter_186_0]
		else
			var_186_0 = AccountData.teams[arg_186_2][iter_186_0]
		end
		
		if var_186_0 and var_186_0.inst.uid == arg_186_1.inst.uid then
			return iter_186_0
		end
	end
	
	return false
end

function Account.removeFromTeam(arg_187_0, arg_187_1, arg_187_2, arg_187_3)
	arg_187_3 = arg_187_3 or arg_187_0:getTeamPos(arg_187_1, arg_187_2)
	AccountData.teams[arg_187_2][arg_187_3] = nil
	
	arg_187_1:removeFromTeam(arg_187_2)
end

function Account.removeFromTeamByPos(arg_188_0, arg_188_1, arg_188_2)
	if AccountData.teams[arg_188_1][arg_188_2] then
		AccountData.teams[arg_188_1][arg_188_2]:removeFromTeam(arg_188_1)
		
		AccountData.teams[arg_188_1][arg_188_2] = nil
	end
end

function Account.setTeamName(arg_189_0, arg_189_1, arg_189_2)
	if not arg_189_0:isPublicTeam(arg_189_1) and not arg_189_0:isCoopTeam(arg_189_1) then
		return 
	end
	
	if not AccountData.team_names[arg_189_1] then
		AccountData.team_names[arg_189_1] = {}
		AccountData.team_names[arg_189_1].name = arg_189_2
		AccountData.team_names[arg_189_1].team_index = arg_189_1
	end
	
	AccountData.team_names[arg_189_1].name = arg_189_2
	
	query("save_team_name", {
		team_index = arg_189_1,
		team_name = arg_189_2
	})
end

function Account.getDescentPetTeamIdx(arg_190_0)
	return DESCENT_TEAM_IDX[1]
end

function Account.getBurningPetTeamIdx(arg_191_0)
	return BURNING_TEAM_IDX[1]
end

function Account.canAddPetToTeam(arg_192_0, arg_192_1)
	if not arg_192_0:isPublicTeam(arg_192_1) then
		if arg_192_0:getCrehuntTeamIndex() == arg_192_1 then
			return true
		end
		
		if DESCENT_TEAM_IDX[1] ~= arg_192_1 and BURNING_TEAM_IDX[1] ~= arg_192_1 then
			return 
		end
	end
	
	return true
end

function Account.petAddToTeam(arg_193_0, arg_193_1, arg_193_2)
	if not arg_193_0:canAddPetToTeam(arg_193_2) then
		return 
	end
	
	if arg_193_1 then
		if arg_193_1.db.type == PET_TYPE.BATTLE then
			AccountData.teams[arg_193_2][PET_TEAM_IDX] = arg_193_1
		else
			Log.e("account.petAddToTeam", "no_battle_type")
		end
	else
		AccountData.teams[arg_193_2][PET_TEAM_IDX] = nil
	end
end

function Account.addToTeam(arg_194_0, arg_194_1, arg_194_2, arg_194_3, arg_194_4)
	if DEBUG.OLD_PROMOTION_RULE and arg_194_1.db.role == "material" then
		return 
	end
	
	local var_194_0 = arg_194_0:getTeamPos(arg_194_1, arg_194_2)
	local var_194_1 = false
	
	if var_194_0 then
		if arg_194_4 and AccountData.teams[arg_194_2][var_194_0] then
			if AccountData.teams[arg_194_2][arg_194_3] then
				AccountData.teams[arg_194_2][arg_194_3]:addToTeam(arg_194_2, var_194_0)
			end
			
			AccountData.teams[arg_194_2][var_194_0] = AccountData.teams[arg_194_2][arg_194_3]
			var_194_1 = true
		else
			arg_194_0:removeFromTeam(arg_194_1, arg_194_2)
		end
	end
	
	if AccountData.teams[arg_194_2][arg_194_3] and not var_194_1 then
		AccountData.teams[arg_194_2][arg_194_3]:removeFromTeam(arg_194_2)
	end
	
	for iter_194_0 = 1, 7 do
		local var_194_2 = AccountData.teams[arg_194_2][iter_194_0]
		
		if var_194_2 and var_194_2.db.code == arg_194_1.db.code and arg_194_3 ~= iter_194_0 then
			print("duplicate unit!")
			
			return 
		end
	end
	
	AccountData.teams[arg_194_2][arg_194_3] = arg_194_1
	
	arg_194_1:addToTeam(arg_194_2, arg_194_3)
end

function Account.updateCollectionData(arg_195_0, arg_195_1)
	if not AccountData.collections or not arg_195_1 then
		return 
	end
	
	for iter_195_0, iter_195_1 in pairs(arg_195_1 or {}) do
		if iter_195_1 and iter_195_1.id then
			if DB("character", iter_195_1.id, "id") then
				AccountData.collections.units[iter_195_1.id] = iter_195_1
			elseif DB("equip_item", iter_195_1.id, "id") then
				AccountData.collections.equips[iter_195_1.id] = iter_195_1
			elseif DB("pet_character", iter_195_1.id, "id") then
				AccountData.collections.pets[iter_195_1.id] = iter_195_1
			end
		end
	end
end

function Account.getCollectionUnit(arg_196_0, arg_196_1)
	if not AccountData.collections or not AccountData.collections.units then
		return nil
	end
	
	return AccountData.collections.units[arg_196_1]
end

function Account.getCollectionEquip(arg_197_0, arg_197_1)
	if not AccountData.collections or not AccountData.collections.equips then
		return nil
	end
	
	return AccountData.collections.equips[arg_197_1]
end

function Account.getCollectionPet(arg_198_0, arg_198_1)
	if not AccountData.collections or not AccountData.collections.pets then
		return nil
	end
	
	return AccountData.collections.pets[arg_198_1]
end

function Account.addPet(arg_199_0, arg_199_1, arg_199_2, arg_199_3, arg_199_4, arg_199_5)
	arg_199_5 = arg_199_5 or {}
	
	local var_199_0
	local var_199_1
	
	if type(arg_199_1) == "table" then
		var_199_1 = PET:create(arg_199_1)
	else
		var_199_1 = PET:create({
			id = arg_199_1,
			code = arg_199_2,
			exp = arg_199_3,
			grade = arg_199_4
		})
	end
	
	table.insert(arg_199_0.pets, var_199_1)
	
	arg_199_2 = arg_199_2 or var_199_1.db.code
	
	local var_199_2
	
	if not arg_199_0:getCollectionPet(arg_199_2) then
		ConditionContentsManager:dispatch("collectionpet.get", {
			code = arg_199_2
		})
		
		var_199_2 = arg_199_2
	end
	
	arg_199_0:onAddPet(var_199_1:getCode(), var_199_1:getGrade())
	
	return var_199_1, var_199_2
end

function Account.getPets(arg_200_0)
	return arg_200_0.pets or {}
end

function Account.isHaveBattlePets(arg_201_0)
	for iter_201_0, iter_201_1 in pairs(arg_201_0.pets) do
		if iter_201_1:getType() == "battle" then
			return true
		end
	end
	
	return false
end

function Account.getPet(arg_202_0, arg_202_1)
	if not Account.pets then
		return 
	end
	
	local var_202_0 = #Account.pets
	
	for iter_202_0 = 1, var_202_0 do
		if Account.pets[iter_202_0].inst.uid == arg_202_1 then
			return Account.pets[iter_202_0]
		end
	end
	
	return nil
end

function Account.getPetsByCode(arg_203_0, arg_203_1)
	local var_203_0 = #Account.pets
	local var_203_1 = {}
	
	for iter_203_0 = 1, var_203_0 do
		if Account.pets[iter_203_0].inst.code == arg_203_1 then
			table.insert(var_203_1, Account.pets[iter_203_0])
		end
	end
	
	return var_203_1
end

function Account.isLobbyPet_exist(arg_204_0)
	for iter_204_0, iter_204_1 in pairs(Account.pets) do
		if iter_204_1:getType() == PET_TYPE.LOBBY then
			return true
		end
	end
	
	return false
end

function Account.setLobbyPetUID(arg_205_0, arg_205_1)
	AccountData.pet_slots.lobby_slot1 = arg_205_1 or nil
end

function Account.isPetInLobby(arg_206_0, arg_206_1)
	return arg_206_0:getLobbyPetUID() == arg_206_1:getUID()
end

function Account.getLobbyPet(arg_207_0)
	local var_207_0 = arg_207_0:getLobbyPetUID()
	local var_207_1 = arg_207_0:getPet(var_207_0)
	
	if var_207_1 and var_207_1:getType() == PET_TYPE.LOBBY then
		return var_207_1
	end
	
	return nil
end

function Account.getLobbyPetUID(arg_208_0)
	return AccountData.pet_slots.lobby_slot1
end

function Account.getLobbyPet_presentTime(arg_209_0)
	return AccountData.pet_slots.present_tm
end

function Account.setLobbyPet_presentTime(arg_210_0, arg_210_1)
	AccountData.pet_slots.present_tm = arg_210_1
end

function Account.setPetSlots(arg_211_0, arg_211_1)
	if not arg_211_1 then
		return 
	end
	
	AccountData.pet_slots = arg_211_1
	
	if arg_211_1.house_pets then
		arg_211_0:setInHousePets(arg_211_1.house_pets)
	end
end

function Account.getPetSlots(arg_212_0)
	return AccountData.pet_slots or {}
end

function Account.checkPet_gachafree(arg_213_0)
	if AccountData.pet_slots.gacha_free <= 0 then
		return true
	end
	
	return false
end

function Account.getPetslot_gachafree(arg_214_0)
	return AccountData.pet_slots.gacha_free
end

function Account.setPetslot_gachafree(arg_215_0, arg_215_1)
	AccountData.pet_slots.gacha_free = arg_215_1
end

function Account.addUnit(arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4, arg_216_5)
	arg_216_5 = arg_216_5 or {}
	
	local var_216_0
	local var_216_1 = arg_216_5.content
	
	if type(arg_216_1) == "table" then
		var_216_0 = UNIT:create(arg_216_1)
		var_216_1 = arg_216_1.content
		arg_216_2 = var_216_0.inst.code
		arg_216_3 = var_216_0.inst.exp
		arg_216_4 = var_216_0.inst.grade
	else
		var_216_0 = UNIT:create({
			id = arg_216_1,
			code = arg_216_2,
			exp = arg_216_3,
			g = arg_216_4
		})
	end
	
	if var_216_0:isSummon() then
		table.insert(arg_216_0.summons, var_216_0)
	else
		table.insert(arg_216_0.units, var_216_0)
	end
	
	local var_216_2
	
	if not arg_216_5.storage_takeout then
		if MusicBoxUI:isShow() then
			MusicBox:stop()
			MusicBoxUI:close()
		end
		
		ConditionContentsManager:dispatch("character.get", {
			code = arg_216_2,
			content = var_216_1
		})
		
		if not arg_216_0:getCollectionUnit(arg_216_2) then
			ConditionContentsManager:dispatch("collection.get", {
				code = arg_216_2
			})
			
			var_216_2 = arg_216_2
		end
		
		arg_216_0:onAddUnit(arg_216_2, arg_216_4)
	end
	
	arg_216_0:onUpdateUnitLevel(var_216_0, 1)
	SkillEffectFilterManager:addUnit(var_216_0)
	
	return var_216_0, var_216_2
end

function Account.getUnitTypeCount(arg_217_0)
	local var_217_0 = {}
	
	for iter_217_0, iter_217_1 in pairs(Account.units) do
		if iter_217_1 and iter_217_1.inst and iter_217_1.inst.code then
			var_217_0[iter_217_1.inst.code] = 0
		end
	end
	
	return table.nums(var_217_0)
end

function Account.unitAttributeChange(arg_218_0, arg_218_1)
	local var_218_0 = Account:getUnit(arg_218_1.id)
	
	if not var_218_0 then
		Log.e("error 잘못된 UID !?")
		
		return 
	end
	
	local var_218_1 = UNIT:create({
		code = arg_218_1.code,
		g = var_218_0.inst.grade,
		z = var_218_0.inst.zodiac
	})
	
	var_218_0.db = table.clone(var_218_1.db)
	var_218_0.inst.code = arg_218_1.code
	var_218_0.inst.stree = arg_218_1.stree
	var_218_0.inst.skill_lv = arg_218_1.s or {}
	
	var_218_0:calc()
	ConditionContentsManager:dispatch("collection.get", {
		force_type = "character"
	})
	arg_218_0:onAddUnit(arg_218_1.code, var_218_0:getGrade())
end

function Account.replaceUnit(arg_219_0, arg_219_1, arg_219_2)
	local var_219_0 = arg_219_2 or {}
	local var_219_1 = arg_219_0:getUnit(arg_219_1.id)
	local var_219_2 = var_219_1.inst.uid
	local var_219_3 = var_219_1.inst.locked
	local var_219_4 = var_219_1.inst.disable_auto
	
	if not UNIT.bindGameDB(var_219_1, arg_219_1.code, arg_219_1.skin_code) then
		return nil
	end
	
	UNIT.clearTurnVars(var_219_1)
	UNIT.makeInstData(var_219_1, arg_219_1)
	var_219_1:updateLevel(false)
	
	var_219_1.inst.uid = var_219_2
	var_219_1.inst.locked = var_219_3
	var_219_1.inst.disable_auto = var_219_4
	
	var_219_1:reset()
	
	local var_219_5 = var_219_1.db.code
	local var_219_6 = var_219_1:getGrade()
	
	if not var_219_0.ignore_classchange_dispatch then
		ConditionContentsManager:dispatch("character.get", {
			content = "class_change",
			code = var_219_5
		})
	end
	
	arg_219_0:onUpdateUnitLevel(var_219_1, 1)
	arg_219_0:onAddUnit(var_219_5, var_219_6)
	ConditionContentsManager:dispatch("collection.get", {
		force_type = "character"
	})
end

function Account.setItemCount(arg_220_0, arg_220_1, arg_220_2, arg_220_3)
	return arg_220_0:setItem({
		code = arg_220_1,
		c = arg_220_2
	}, arg_220_3)
end

function Account.setItem(arg_221_0, arg_221_1, arg_221_2)
	arg_221_2 = arg_221_2 or {}
	
	local var_221_0 = arg_221_0.items[arg_221_1.code] or 0
	
	arg_221_0.items[arg_221_1.code] = arg_221_1.c
	
	if not arg_221_2.ignore_get_condition and arg_221_1.c - var_221_0 > 0 then
		ConditionContentsManager:dispatch("material.get", {
			id = arg_221_1.code,
			count = arg_221_1.c - var_221_0,
			content = arg_221_2.content,
			enter = arg_221_2.enter
		})
	end
	
	return arg_221_1.c - var_221_0
end

function Account.addEquip(arg_222_0, arg_222_1, arg_222_2)
	arg_222_2 = arg_222_2 or {}
	
	local var_222_0 = EQUIP:createByInfo(arg_222_1)
	
	table.insert(arg_222_0.equips, var_222_0)
	
	local var_222_1
	
	if not arg_222_2.ignore_get_condition then
		if var_222_0.code and not string.ends(var_222_0.code, "_u") then
			ConditionContentsManager:dispatch("equip.get", {
				code = var_222_0.code,
				equiptype = var_222_0.db.type,
				sub_stats = table.clone(var_222_0.opts or {}),
				enter = arg_222_2.enter,
				entertype = arg_222_2.entertype
			})
		end
		
		if not arg_222_0:getCollectionEquip(var_222_0.code) then
			var_222_1 = var_222_0.code
			
			ConditionContentsManager:dispatch("collectionequip.get", {
				code = var_222_0.code
			})
		end
	end
	
	arg_222_0:onAddEquip(var_222_0.code, var_222_0.grade)
	
	return var_222_0, var_222_1
end

function Account.onAddUnit(arg_223_0, arg_223_1, arg_223_2)
	if AccountData.collections.units[arg_223_1] == nil then
		AccountData.collections.units[arg_223_1] = {
			ac = 1,
			max_lv = 1,
			ag = {
				arg_223_2
			}
		}
		
		return true
	else
		local var_223_0 = AccountData.collections.units[arg_223_1]
		
		var_223_0.ac = var_223_0.ac + 1
		
		if table.find(var_223_0.ag, arg_223_2) == nil then
			table.push(var_223_0.ag, arg_223_2)
			
			AccountData.collections.units[arg_223_1] = var_223_0
			
			return true
		end
		
		AccountData.collections.units[arg_223_1] = var_223_0
	end
	
	return false
end

function Account.onAddEquip(arg_224_0, arg_224_1, arg_224_2)
	if AccountData.collections.equips[arg_224_1] == nil then
		AccountData.collections.equips[arg_224_1] = {
			ac = 1,
			ag = {
				arg_224_2
			}
		}
		
		return true
	else
		local var_224_0 = AccountData.collections.equips[arg_224_1]
		
		var_224_0.ac = var_224_0.ac + 1
		
		if table.find(var_224_0.ag, arg_224_2) == nil then
			table.push(var_224_0.ag, arg_224_2)
			
			AccountData.collections.equips[arg_224_1] = var_224_0
			
			return true
		end
		
		AccountData.collections.equips[arg_224_1] = var_224_0
	end
	
	return false
end

function Account.onAddPet(arg_225_0, arg_225_1, arg_225_2)
	if AccountData.collections.pets[arg_225_1] == nil then
		AccountData.collections.pets[arg_225_1] = {
			ac = 1,
			max_lv = 0,
			ag = {
				arg_225_2
			}
		}
		
		return true
	else
		local var_225_0 = AccountData.collections.pets[arg_225_1]
		
		var_225_0.ac = var_225_0.ac + 1
		
		if table.find(var_225_0.ag, arg_225_2) == nil then
			table.push(var_225_0.ag, arg_225_2)
			
			AccountData.collections.pets[arg_225_1] = var_225_0
			
			return true
		end
		
		AccountData.collections.pets[arg_225_1] = var_225_0
	end
	
	return false
end

function Account.removeEquip(arg_226_0, arg_226_1)
	for iter_226_0, iter_226_1 in pairs(Account.equips) do
		if iter_226_1.id == arg_226_1 then
			table.remove(Account.equips, iter_226_0)
			
			return 
		end
	end
end

function Account.addEquipStorage(arg_227_0, arg_227_1)
	if not AccountData.equip_storage then
		return 
	end
	
	local var_227_0 = Account:getEquip(arg_227_1)
	
	var_227_0.list_type = "storage"
	AccountData.equip_storage[arg_227_1] = var_227_0
end

function Account.removeEquipStorage(arg_228_0, arg_228_1)
	if not AccountData.equip_storage then
		return 
	end
	
	for iter_228_0, iter_228_1 in pairs(AccountData.equip_storage or {}) do
		if iter_228_1.id == arg_228_1 then
			AccountData.equip_storage[iter_228_0] = nil
		end
	end
end

function Account.getSubCusItemCount(arg_229_0, arg_229_1)
	local var_229_0, var_229_1, var_229_2 = DB("item_material", arg_229_1, {
		"ma_type",
		"init_count",
		"max_count"
	})
	
	var_229_1 = var_229_1 or 0
	var_229_2 = var_229_2 or 0
	
	if not var_229_0 or var_229_0 ~= "subcus" then
		return 0
	end
	
	local var_229_3 = arg_229_0.items[arg_229_1] or 0
	
	if var_229_2 < var_229_3 then
		return var_229_2
	end
	
	if var_229_1 > var_229_3 + var_229_1 then
		return var_229_1
	end
	
	return var_229_3 + var_229_1
end

function Account.checkItemSpecialInternalItemUnitOrEquip(arg_230_0, arg_230_1, arg_230_2)
	local var_230_0 = DB("item_material", arg_230_1, {
		"ma_type2"
	})
	
	if var_230_0 then
		local var_230_1 = DB("item_special", var_230_0, {
			"id"
		})
		
		if var_230_1 then
			arg_230_1 = var_230_1
		end
	end
	
	local var_230_2, var_230_3 = DB("item_special", arg_230_1, {
		"type",
		"value"
	})
	
	if var_230_2 and string.starts(var_230_2, "gacha") then
		return true
	else
		local var_230_4 = Inventory:checkInventoryItem(arg_230_1)
		
		if var_230_4 and (var_230_4.unit or var_230_4.equip or var_230_4.artifact) then
			return true
		end
	end
	
	local function var_230_5(arg_231_0, arg_231_1, arg_231_2, arg_231_3)
		if arg_231_0 == "eq_option" then
			arg_231_0 = "option"
		end
		
		for iter_231_0, iter_231_1 in pairs(arg_231_3 or {}) do
			if iter_231_1.item_special_value == arg_231_2 and iter_231_1.item_id then
				if string.starts(iter_231_1.item_id, "e") or string.starts(iter_231_1.item_id, "c") then
					return true
				elseif string.starts(iter_231_1.item_id, "sp") and DB("item_special", iter_231_1.item_id, {
					"id"
				}) and arg_230_0:checkItemSpecialInternalItemUnitOrEquip(iter_231_1.item_id, arg_231_3) then
					return true
				end
			end
		end
		
		return false
	end
	
	if var_230_2 == "option" or var_230_2 == "randombox" or var_230_2 == "package" or var_230_2 == "eq_option" then
		local var_230_6 = var_230_2
		
		if var_230_6 == "eq_option" then
			var_230_6 = "option"
		end
		
		if not arg_230_2 then
			arg_230_2 = {}
			
			for iter_230_0 = 1, 99999 do
				local var_230_7 = {}
				
				var_230_7.id, var_230_7.item_special_value, var_230_7.item_id = DBN(var_230_6, iter_230_0, {
					"id",
					"item_special_value",
					"item_id"
				})
				
				if not var_230_7.id then
					break
				end
				
				table.push(arg_230_2, var_230_7)
			end
		end
		
		if var_230_5(var_230_2, arg_230_1, var_230_3, arg_230_2) then
			return true
		end
	end
	
	return false
end

function Account.getItemCount(arg_232_0, arg_232_1)
	local var_232_0 = arg_232_0.items[arg_232_1]
	
	if arg_232_1 and string.starts(arg_232_1, "ma_e") then
		local var_232_1 = arg_232_0:getStoneItem(arg_232_1)
		
		if var_232_1 == nil then
			return 0
		end
		
		return var_232_1.count
	elseif arg_232_1 and string.find(arg_232_1, "subcus") then
		return arg_232_0:getSubCusItemCount(arg_232_1)
	else
		if var_232_0 == nil then
			return 0
		end
		
		return var_232_0
	end
end

function Account.getStoneItem(arg_233_0, arg_233_1)
	local var_233_0 = arg_233_1
	
	if not string.starts(arg_233_1, "ma_") then
		var_233_0 = "ma_" .. arg_233_1
	elseif string.starts(arg_233_1, "ma_") then
		arg_233_1 = string.split(arg_233_1, "_")[2]
	end
	
	local var_233_1 = {
		code = var_233_0,
		count = to_n(arg_233_0.items[var_233_0]),
		equip_id = {}
	}
	
	for iter_233_0, iter_233_1 in pairs(arg_233_0.equips) do
		if iter_233_1:isStone() and iter_233_1.code == arg_233_1 then
			var_233_1.count = var_233_1.count + 1
			
			table.push(var_233_1.equip_id, iter_233_1.id)
		end
	end
	
	if var_233_1.count == 0 then
		return nil
	else
		return var_233_1
	end
end

function Account.getPetFoods(arg_234_0)
	local var_234_0 = {}
	
	for iter_234_0, iter_234_1 in pairs(arg_234_0.items) do
		local var_234_1, var_234_2 = DB("item_material", iter_234_0, {
			"ma_type",
			"ma_type2"
		})
		
		if var_234_1 == "petfood" and var_234_2 == "exp" then
			var_234_0[iter_234_0] = {
				code = iter_234_0,
				count = iter_234_1
			}
		end
	end
	
	return var_234_0
end

function Account.getIntimacyItems(arg_235_0)
	local var_235_0 = {}
	
	for iter_235_0, iter_235_1 in pairs(arg_235_0.items) do
		local var_235_1, var_235_2, var_235_3, var_235_4, var_235_5 = DB("item_material", iter_235_0, {
			"ma_type",
			"intimacy_bonus",
			"get_xp",
			"sort",
			"grade"
		})
		
		if var_235_1 == "intimacy" and iter_235_1 > 0 then
			var_235_0[iter_235_0] = {
				code = iter_235_0,
				count = iter_235_1,
				equip_id = {},
				intimacy_bonus = var_235_2,
				xp = var_235_3,
				sort = var_235_4,
				grade = var_235_5
			}
		end
	end
	
	return var_235_0
end

function Account.getStoneItems(arg_236_0, arg_236_1, arg_236_2)
	local var_236_0 = {}
	
	for iter_236_0, iter_236_1 in pairs(arg_236_0.items) do
		local var_236_1, var_236_2 = DB("item_material", iter_236_0, {
			"ma_type",
			"ma_type2"
		})
		
		if arg_236_1 == nil then
			var_236_2 = nil
		end
		
		if var_236_1 == "stone" and (arg_236_1 == nil or arg_236_1 == var_236_2 or ENHANCER.compareCompatibleCategoryStone(var_236_2, arg_236_1)) then
			var_236_0[iter_236_0] = {
				code = iter_236_0,
				count = iter_236_1,
				equip_id = {}
			}
		end
	end
	
	if arg_236_2 then
		return var_236_0
	end
	
	for iter_236_2, iter_236_3 in pairs(arg_236_0.equips) do
		if iter_236_3:isStone() then
			local var_236_3 = "ma_" .. iter_236_3.code
			local var_236_4, var_236_5 = DB("item_material", var_236_3, {
				"ma_type",
				"ma_type2"
			})
			
			if arg_236_1 == nil then
				var_236_5 = nil
			end
			
			if arg_236_1 == nil or arg_236_1 == var_236_5 or iter_236_3:isCompatibleCategoryStone(arg_236_1) then
				if var_236_0[var_236_3] then
					var_236_0[var_236_3].count = var_236_0[var_236_3].count + 1
					
					table.push(var_236_0[var_236_3].equip_id, iter_236_3.id)
				else
					var_236_0[var_236_3] = {
						count = 1,
						code = var_236_3,
						equip_id = {
							iter_236_3.id
						}
					}
				end
			end
		end
	end
	
	return var_236_0
end

function Account.getCurrencyCodes(arg_237_0)
	return {
		"stamina",
		"gold",
		"crystal",
		"stone",
		"chaos",
		"friendpoint",
		"honor",
		"dungeonkey",
		"pvpkey",
		"pvpgold",
		"pvphonor",
		"pvphonor2",
		"clanpvpkey",
		"clanpvpband",
		"food",
		"stigma",
		"clanexp",
		"mura",
		"spirit",
		"ticketnormal",
		"ticketrare",
		"ticketmoon",
		"ticketspecial",
		"hero1",
		"hero2",
		"hero3",
		"mazekey",
		"abysskey",
		"light",
		"powder",
		"mazekey2",
		"exclusive",
		"petticket",
		"petsnack",
		"ticketwind35",
		"ticketfire35",
		"ticketice35",
		"ticketdark35",
		"ticketlight35",
		"ticketwind45",
		"ticketfire45",
		"ticketice45",
		"ticketdark45",
		"ticketlight45",
		"ticketwarrior35",
		"ticketmage35",
		"ticketmanauser35",
		"ticketknight35",
		"ticketassassin35",
		"ticketranger35",
		"ticketwarrior45",
		"ticketmage45",
		"ticketmanauser45",
		"ticketknight45",
		"ticketassassin45",
		"ticketranger45",
		"ticketskin",
		"rarecoin",
		"mooncoin",
		"gpmileage1",
		"gpmileage2",
		"clanheritage",
		"clanheritagecoin",
		"dlcticket",
		"theaterticket",
		"ticketevent_aespa",
		"gacha_substory"
	}
end

function Account.isCurrencyType(arg_238_0, arg_238_1)
	if string.starts(arg_238_1, "to_") then
		arg_238_1 = string.sub(arg_238_1, 4, -1)
	end
	
	for iter_238_0, iter_238_1 in pairs(arg_238_0:getCurrencyCodes()) do
		if iter_238_1 == arg_238_1 then
			return iter_238_1
		end
	end
	
	return nil
end

function Account.isMaterialCurrencyType(arg_239_0, arg_239_1)
	local var_239_0 = DB("item_material", arg_239_1, {
		"ma_type"
	})
	
	if var_239_0 == "token" or var_239_0 == "cp" then
		return var_239_0
	end
	
	return nil
end

function Account.getMaterialType(arg_240_0, arg_240_1)
	local var_240_0 = arg_240_0:isCurrencyType(arg_240_1) or arg_240_1
	
	return (DB("item_material", var_240_0, {
		"ma_type"
	}))
end

function Account.getUserConfigs(arg_241_0, arg_241_1)
	return (AccountData.user_config or {})[arg_241_1]
end

function Account.getUserConfigsHash(arg_242_0, arg_242_1, arg_242_2)
	return ((AccountData.user_config or {})[arg_242_1] or {})[arg_242_2]
end

function Account.updateUserConfigs(arg_243_0, arg_243_1)
	AccountData.user_config = AccountData.user_config or {}
	
	for iter_243_0, iter_243_1 in pairs(arg_243_1 or {}) do
		AccountData.user_config[iter_243_0] = iter_243_1
	end
end

function Account.updateCurrencies(arg_244_0, arg_244_1, arg_244_2)
	if not arg_244_1 then
		return nil
	end
	
	local var_244_0 = {}
	local var_244_1 = arg_244_0:getCurrencyCodes()
	local var_244_2
	
	if type(arg_244_1.currency) == "table" then
		var_244_2 = arg_244_1.currency
	else
		var_244_2 = arg_244_1
	end
	
	for iter_244_0, iter_244_1 in ipairs(var_244_1) do
		local var_244_3 = tonumber(var_244_2[iter_244_1]) or tonumber(var_244_2["to_" .. iter_244_1])
		
		if var_244_3 then
			local var_244_4 = var_244_3 - arg_244_0:getCurrency(iter_244_1)
			
			if var_244_4 ~= 0 then
				var_244_0[iter_244_1] = var_244_4
			end
			
			arg_244_0:checkIgnoreCurrency(iter_244_1, var_244_3, var_244_4)
			arg_244_0:setCurrency(iter_244_1, var_244_3, arg_244_2)
		end
	end
	
	local var_244_5
	
	if type(arg_244_1.currency_time) == "table" then
		var_244_5 = arg_244_1.currency_time
		
		for iter_244_2, iter_244_3 in ipairs(var_244_1) do
			local var_244_6 = var_244_5[iter_244_3]
			
			if var_244_6 then
				arg_244_0:setCurrencyTime(iter_244_3, var_244_6)
			end
		end
	end
	
	return var_244_0
end

function Account.getCurrency(arg_245_0, arg_245_1)
	return arg_245_0:_getCurrency(arg_245_1)
end

function Account.setCurrency(arg_246_0, arg_246_1, arg_246_2, arg_246_3)
	arg_246_3 = arg_246_3 or {}
	AccountData.currency = AccountData.currency or {}
	
	local var_246_0 = AccountData.currency[arg_246_1] or 0
	local var_246_1 = to_n(arg_246_2)
	
	AccountData.currency[arg_246_1] = var_246_1
	
	if var_246_0 < var_246_1 and not arg_246_3.ignore_get_condition then
		ConditionContentsManager:dispatch("token.get", {
			tokentype = arg_246_1,
			value = var_246_1 - var_246_0,
			now_value = var_246_1,
			content = arg_246_3.content,
			enter = arg_246_3.enter
		})
	end
	
	local var_246_2 = to_n(arg_246_3.use_stamina)
	
	if var_246_2 > 0 or var_246_1 < var_246_0 then
		local var_246_3 = var_246_0 - var_246_1
		local var_246_4 = math.max(var_246_2, var_246_3)
		
		if arg_246_1 == "stamina" then
			local var_246_5 = Account:getCurrencyMax("stamina")
			
			var_246_4 = math.min(var_246_4, var_246_5)
		end
		
		ConditionContentsManager:dispatch("token.use", {
			tokentype = arg_246_1,
			value = var_246_4,
			content = arg_246_3.content,
			enter = arg_246_3.enter
		})
	end
	
	if arg_246_3.buy and var_246_0 < var_246_1 then
		ConditionContentsManager:dispatch("token.buy", {
			tokentype = arg_246_1,
			value = var_246_1 - var_246_0,
			content = arg_246_3.content
		})
	end
	
	if arg_246_1 == "stamina" then
		arg_246_0:checkStaminaLocalPush()
	end
end

function Account.addCurrency(arg_247_0, arg_247_1, arg_247_2)
	AccountData.currency = AccountData.currency or {}
	AccountData.currency[arg_247_1] = (AccountData.currency[arg_247_1] or 0) + (tonumber(arg_247_2) or 0)
end

function Account.getCurrencyTime(arg_248_0, arg_248_1)
	AccountData.currency_time = AccountData.currency_time or {}
	
	return AccountData.currency_time[arg_248_1] or os.time()
end

function Account.setCurrencyTime(arg_249_0, arg_249_1, arg_249_2)
	if not arg_249_2 then
		return 
	end
	
	AccountData.currency_time = AccountData.currency_time or {}
	AccountData.currency_time[arg_249_1] = tonumber(arg_249_2) or os.time()
	
	return AccountData.currency_time[arg_249_1]
end

function Account.checkIgnoreCurrency(arg_250_0, arg_250_1, arg_250_2, arg_250_3)
	if arg_250_1 == "stamina" and arg_250_3 < 0 then
		Battle:checkIgnoreCurrency()
		BackPlayManager:checkIgnoreCurrency()
	end
end

function Account.getTokenInfo(arg_251_0, arg_251_1)
	if not arg_251_1 then
		return 
	end
	
	AccountData.token_info = AccountData.token_info or {}
	
	local var_251_0 = AccountData.token_info[arg_251_1]
	
	if not var_251_0 then
		return 
	end
	
	return var_251_0
end

function Account.setCurrencyMaxBonus(arg_252_0, arg_252_1, arg_252_2)
	AccountData.currency_max_bonus = AccountData.currency_max_bonus or {}
	AccountData.currency_max_bonus[arg_252_1] = tonumber(arg_252_2) or 0
	
	return AccountData.currency_max_bonus[arg_252_1]
end

function Account.getCurrencyMaxBonus(arg_253_0, arg_253_1)
	AccountData.currency_max_bonus = AccountData.currency_max_bonus or {}
	
	if not AccountData.currency_max_bonus[arg_253_1] then
		AccountData.currency_max_bonus[arg_253_1] = 0
	end
	
	return AccountData.currency_max_bonus[arg_253_1]
end

function Account.getCurrencyMax(arg_254_0, arg_254_1)
	if arg_254_1 == "stamina" then
		local var_254_0 = DB("acc_rank", tostring(AccountData.level), "max_st") or GAME_STATIC_VARIABLE.to_stamina
		
		return tonumber(var_254_0) + arg_254_0:getCurrencyMaxBonus(arg_254_1)
	elseif arg_254_1 == "clanheritage" then
		return LotaUserData:getConfigMaxActionPoint()
	elseif AccountData.token_info and AccountData.token_info[arg_254_1] and AccountData.token_info[arg_254_1].max then
		return tonumber(AccountData.token_info[arg_254_1].max) + arg_254_0:getCurrencyMaxBonus(arg_254_1)
	end
end

function Account.getPropertyCount(arg_255_0, arg_255_1)
	local var_255_0 = arg_255_0:isCurrencyType(arg_255_1)
	
	if var_255_0 then
		return arg_255_0:getCurrency(var_255_0)
	else
		return arg_255_0:getItemCount(arg_255_1)
	end
end

function Account.setPropertyCount(arg_256_0, arg_256_1, arg_256_2)
	return arg_256_0:updateProperties({
		code = arg_256_1,
		count = to_n(arg_256_2)
	})
end

function Account.updateProperties(arg_257_0, arg_257_1)
	for iter_257_0, iter_257_1 in pairs(arg_257_1) do
		local var_257_0 = arg_257_0:isCurrencyType(iter_257_0)
		
		if var_257_0 then
			arg_257_0:setCurrency(var_257_0, to_n(iter_257_1))
		else
			arg_257_0:setItemCount(iter_257_0, to_n(iter_257_1))
		end
	end
end

function Account.getLimitCount(arg_258_0, arg_258_1)
	if not AccountData.limits[arg_258_1] then
		return 0
	end
	
	if AccountData.limits[arg_258_1].expire_tm < os.time() then
		return 0
	else
		return AccountData.limits[arg_258_1].count
	end
end

function Account.getLimitExpire(arg_259_0, arg_259_1)
	if not AccountData.limits[arg_259_1] then
		return 0
	end
	
	if AccountData.limits[arg_259_1].expire_tm < os.time() then
		return 0
	else
		return AccountData.limits[arg_259_1].expire_tm
	end
end

function Account.getLimit(arg_260_0, arg_260_1)
	if not AccountData.limits[arg_260_1] then
		return 0, 0
	end
	
	if AccountData.limits[arg_260_1].expire_tm < os.time() then
		return 0, 0
	else
		return AccountData.limits[arg_260_1].count, AccountData.limits[arg_260_1].expire_tm
	end
end

function Account.getTicketedLimits(arg_261_0)
	return AccountData.ticketed_limits
end

function Account.getTicketedLimit(arg_262_0, arg_262_1)
	return (arg_262_0:getTicketedLimits() or {})[arg_262_1]
end

function Account.updateTicketedLimits(arg_263_0, arg_263_1)
	for iter_263_0, iter_263_1 in pairs(arg_263_1) do
		AccountData.ticketed_limits[iter_263_0] = iter_263_1
	end
end

function Account.getEventTickets(arg_264_0)
	return AccountData.event_tickets
end

function Account.getEventTicket(arg_265_0, arg_265_1)
	return (arg_265_0:getEventTickets() or {})[arg_265_1]
end

function Account.updateEventTicket(arg_266_0, arg_266_1)
	if not arg_266_1 then
		return 
	end
	
	AccountData.event_tickets[arg_266_1.event_id] = arg_266_1
end

function Account.clearRandomShopLimits(arg_267_0)
	local var_267_0 = {}
	
	for iter_267_0, iter_267_1 in pairs(AccountData.limits) do
		if string.starts(iter_267_0, "rs:") then
			var_267_0[iter_267_0] = true
		end
	end
	
	for iter_267_2, iter_267_3 in pairs(var_267_0) do
		AccountData.limits[iter_267_2] = nil
	end
end

function Account.updateLimits(arg_268_0, arg_268_1)
	for iter_268_0, iter_268_1 in pairs(arg_268_1) do
		AccountData.limits[iter_268_0] = iter_268_1
	end
end

function Account.getSubStoryScheduleDB(arg_269_0)
	return AccountData.substory_schedule or {}
end

function Account.getSubStoryScheduleDBById(arg_270_0, arg_270_1)
	return (AccountData.substory_schedule or {})[arg_270_1]
end

function Account.getPvpClanSchedule(arg_271_0)
	return AccountData.pvp_clan_schedule
end

function Account.getLotaSchedules(arg_272_0)
	return AccountData.lota_schedules
end

function Account.updateGold(arg_273_0, arg_273_1)
	AccountData.gold = arg_273_1
end

function Account.updateStone(arg_274_0, arg_274_1)
	AccountData.stone = arg_274_1
end

function Account.updateChaos(arg_275_0, arg_275_1)
	AccountData.chaos = arg_275_1
end

function Account.updateHonor(arg_276_0, arg_276_1)
	AccountData.honor = arg_276_1
end

function Account.getMaxUidEquip(arg_277_0)
	local var_277_0 = -1
	
	for iter_277_0, iter_277_1 in pairs(arg_277_0.equips) do
		if not iter_277_1:isArtifact() then
			var_277_0 = math.max(iter_277_1:getUID(), var_277_0)
		end
	end
	
	return var_277_0
end

function Account.getMaxUidArtifact(arg_278_0)
	local var_278_0 = -1
	
	for iter_278_0, iter_278_1 in pairs(arg_278_0.equips) do
		if iter_278_1:isArtifact() then
			var_278_0 = math.max(iter_278_1:getUID(), var_278_0)
		end
	end
	
	return var_278_0
end

function Account.getEquip(arg_279_0, arg_279_1)
	for iter_279_0, iter_279_1 in pairs(arg_279_0.equips) do
		if iter_279_1.id == arg_279_1 then
			return iter_279_1, iter_279_0
		end
	end
end

function Account.getEquipFromStorage(arg_280_0, arg_280_1)
	for iter_280_0, iter_280_1 in pairs(AccountData.equip_storage or {}) do
		if iter_280_1.id == arg_280_1 then
			return iter_280_1, iter_280_0
		end
	end
end

function Account.getEquipByCode(arg_281_0, arg_281_1)
	for iter_281_0, iter_281_1 in pairs(arg_281_0.equips) do
		if iter_281_1.code == arg_281_1 then
			return iter_281_1
		end
	end
end

function Account.getEquipsByCode(arg_282_0, arg_282_1)
	local var_282_0 = {}
	
	for iter_282_0, iter_282_1 in pairs(arg_282_0.equips) do
		if iter_282_1.code == arg_282_1 then
			table.insert(var_282_0, iter_282_1)
		end
	end
	
	return var_282_0
end

function Account.updatePetByInfo(arg_283_0, arg_283_1, arg_283_2)
	local var_283_0 = arg_283_2 or {}
	
	for iter_283_0, iter_283_1 in pairs(arg_283_0.pets) do
		if iter_283_1:getUID() == arg_283_1.id then
			local var_283_1 = iter_283_1:getLv()
			
			for iter_283_2, iter_283_3 in pairs(arg_283_1) do
				iter_283_1.inst[iter_283_2] = iter_283_3
				
				if var_283_0.is_update_pet_db and iter_283_2 == "code" then
					PET.bindGameDB(iter_283_1, iter_283_3)
				end
			end
			
			iter_283_1:updateLevel()
			
			if var_283_1 ~= iter_283_1:getLv() then
				arg_283_0:onUpdatePetLevel(iter_283_1, var_283_1)
			end
		end
	end
end

function Account.onUpdatePetLevel(arg_284_0, arg_284_1, arg_284_2)
end

function Account.calcUnitStatus(arg_285_0)
	for iter_285_0, iter_285_1 in pairs(arg_285_0.units) do
		iter_285_1:calc()
		
		if not iter_285_1:isMaxHP() then
			arg_285_0.healing_units[iter_285_1] = true
		end
	end
end

function Account.updateUnitByInfo(arg_286_0, arg_286_1)
	for iter_286_0, iter_286_1 in pairs(arg_286_0.units) do
		if iter_286_1:getUID() == arg_286_1.id then
			local var_286_0 = iter_286_1:getLv()
			
			if arg_286_1.j then
				iter_286_1.inst.job = arg_286_1.j
			end
			
			if arg_286_1.exp then
				iter_286_1.inst.exp = arg_286_1.exp
			end
			
			if arg_286_1.g then
				iter_286_1.inst.g = arg_286_1.g
			end
			
			if arg_286_1.d then
				iter_286_1.inst.devote = arg_286_1.d
			end
			
			if arg_286_1.f then
				iter_286_1.inst.fav = arg_286_1.f
			end
			
			if arg_286_1.s then
				iter_286_1.inst.s = arg_286_1.s
			end
			
			iter_286_1:updateHPInfo(arg_286_1)
			
			iter_286_1.inst.subtask_end_time = arg_286_1.stet
			iter_286_1.inst.zodiac = math.min(6, arg_286_1.zodiac or arg_286_1.z or 0)
			
			iter_286_1:updateLevel()
			iter_286_1:reset()
			
			if iter_286_1:getLv() ~= var_286_0 then
				arg_286_0:onUpdateUnitLevel(iter_286_1, var_286_0)
			end
			
			return iter_286_1
		end
	end
end

function Account.onUpdateUnitLevel(arg_287_0, arg_287_1, arg_287_2)
	local var_287_0 = "game.unit." .. arg_287_1:getUID() .. ".lv"
	local var_287_1 = SAVE:get(var_287_0)
	
	if var_287_1 and var_287_1 ~= arg_287_1:getLv() then
		if math.floor(arg_287_2 / 10) ~= math.floor(arg_287_1:getLv()) and arg_287_1:getLv() <= 60 then
			SAVE:set("game.unit." .. arg_287_1:getUID() .. ".zd", true)
		end
		
		SAVE:set(var_287_0, var_287_1)
	end
	
	arg_287_0:updateUnitSummaryData(arg_287_1)
end

function Account.updateUnitSummaryData(arg_288_0, arg_288_1)
	SAVE:set("game.unit." .. arg_288_1:getUID() .. ".lv", arg_288_1:getLv())
end

function Account.checkStaminaLocalPush(arg_289_0)
	local var_289_0, var_289_1, var_289_2 = arg_289_0:getRemainCurrencyTime("stamina")
	
	if not var_289_2 and to_n(var_289_1) > 0 then
		add_local_push("STAMINA_FILL", var_289_1)
	else
		cancel_local_push(LOCAL_PUSH_IDS.STAMINA_FILL)
	end
end

function Account.isFirstReward(arg_290_0, arg_290_1, arg_290_2)
	local var_290_0, var_290_1 = DB("level_enter", arg_290_1, {
		"show_first_clear_reward_half",
		"show_first_clear_reward"
	})
	local var_290_2
	
	if var_290_0 then
		var_290_2 = totable(var_290_0)
	elseif var_290_1 then
		var_290_2 = totable(var_290_1)
	end
	
	if var_290_2 then
		if type(var_290_2["1"]) == "string" then
			var_290_2["1"] = {
				var_290_2["1"]
			}
		end
	else
		return false
	end
	
	for iter_290_0, iter_290_1 in pairs(var_290_2 or {}) do
		for iter_290_2, iter_290_3 in pairs(iter_290_1 or {}) do
			if iter_290_3 == arg_290_2 then
				return true
			end
		end
	end
	
	return false
end

function Account.getRemainCurrencyTime(arg_291_0, arg_291_1)
	local var_291_0 = arg_291_1
	local var_291_1 = AccountData.token_info[var_291_0] or {}
	local var_291_2 = arg_291_0:getCurrencyMax(var_291_0)
	local var_291_3
	local var_291_4 = var_291_2 - arg_291_0:getCurrency(var_291_0)
	
	if var_291_1.charge_type == "time" then
		local var_291_5 = 0
		
		if var_291_1.charge_info.min then
			var_291_5 = tonumber(var_291_1.charge_info.min) * 60
		elseif var_291_1.charge_info.sec then
			var_291_5 = tonumber(var_291_1.charge_info.sec)
		end
		
		local var_291_6 = var_291_2 <= arg_291_0:getCurrency(var_291_0)
		local var_291_7 = tonumber(var_291_1.charge_info.add) or 1
		local var_291_8 = math.floor((os.time() - arg_291_0:getCurrencyTime(arg_291_1)) / var_291_5) * var_291_7
		local var_291_9
		local var_291_10
		
		if var_291_6 then
			var_291_9 = var_291_5
			var_291_10 = (var_291_4 - 1) * var_291_5
		else
			var_291_9 = arg_291_0:getCurrencyTime(var_291_0) + var_291_5 * (var_291_8 + 1) - os.time()
			var_291_10 = var_291_9 + (var_291_4 - 1) * var_291_5
		end
		
		return var_291_9, var_291_10, var_291_6
	elseif var_291_1.charge_type == "day" then
		local var_291_11 = tonumber(var_291_1.charge_info.every) or 1
		
		if var_291_11 < 0 then
			var_291_11 = 1
		end
		
		local var_291_12 = 86400
		local var_291_13, var_291_14, var_291_15 = Account:serverTimeDayLocalDetail(nil, 0)
		local var_291_16 = var_291_2 <= arg_291_0:getCurrency(var_291_0)
		local var_291_17
		local var_291_18
		
		if var_291_16 then
			var_291_17 = var_291_12
			var_291_18 = (var_291_4 - 1) * var_291_12
		else
			var_291_17 = var_291_15 - os.time()
			var_291_18 = var_291_17 + (math.ceil(var_291_4 / var_291_11) - 1) * var_291_12
		end
		
		return var_291_17, var_291_18, var_291_16
	elseif var_291_1.charge_type == "week" then
		local var_291_19 = tonumber(var_291_1.charge_info.every) or 1
		
		if var_291_19 < 0 then
			var_291_19 = 1
		end
		
		local var_291_20 = 604800
		local var_291_21, var_291_22, var_291_23 = Account:serverTimeWeekLocalDetail(nil, 0)
		local var_291_24 = var_291_2 <= arg_291_0:getCurrency(var_291_0)
		local var_291_25
		local var_291_26
		
		if var_291_24 then
			var_291_25 = var_291_20
			var_291_26 = (var_291_4 - 1) * var_291_20
		else
			var_291_25 = var_291_23 - os.time()
			var_291_26 = var_291_25 + (math.ceil(var_291_4 / var_291_19) - 1) * var_291_20
		end
		
		return var_291_25, var_291_26, var_291_24
	end
end

function Account.getRemainTimeAutomaton(arg_292_0)
	return DungeonAutomaton:getResetTM() - os.time()
end

function Account.getRemainTimeTrialHall(arg_293_0)
	local var_293_0 = arg_293_0:getActiveTrialHall()
	
	if not var_293_0.id then
		return 0
	end
	
	return var_293_0.end_time - os.time()
end

function Account.getRemainTimeRaidMazeHell(arg_294_0)
	local var_294_0, var_294_1, var_294_2 = arg_294_0:serverTimeMonthInfo()
	
	if not var_294_1 then
		return 0
	end
	
	return var_294_1 - (GAME_STATIC_VARIABLE.raid_month_break_time or 5) * 3600 - os.time()
end

function Account.serverTimeDayLocalDetail(arg_295_0, arg_295_1, arg_295_2)
	if AccountData.server_time and AccountData.server_time.primal_time then
		arg_295_1 = arg_295_1 or os.time()
		
		local var_295_0 = 86400
		local var_295_1 = math.floor((arg_295_1 - AccountData.server_time.primal_time) / var_295_0) + 1
		local var_295_2 = AccountData.server_time.primal_time + var_295_0 * (var_295_1 - 1)
		local var_295_3 = var_295_2 + var_295_0 - (arg_295_2 or 1)
		
		return var_295_1, var_295_2, var_295_3
	end
end

function Account.serverTimeWeekLocalDetail(arg_296_0, arg_296_1, arg_296_2)
	if AccountData.server_time and AccountData.server_time.primal_time then
		arg_296_1 = arg_296_1 or os.time()
		
		local var_296_0 = 604800
		local var_296_1 = math.floor((arg_296_1 - AccountData.server_time.primal_time) / var_296_0) + 1
		local var_296_2 = AccountData.server_time.primal_time + var_296_0 * (var_296_1 - 1)
		local var_296_3 = var_296_2 + var_296_0 - (arg_296_2 or 1)
		
		return var_296_1, var_296_2, var_296_3
	end
end

function Account.__MonthLocalDetail(arg_297_0, arg_297_1, arg_297_2)
	if AccountData.server_time and AccountData.server_time.primal_time then
		local function var_297_0(arg_298_0, arg_298_1, arg_298_2)
			local var_298_0
			local var_298_1
			local var_298_2
			local var_298_3 = {
				31,
				28 + (arg_298_2 and 1 or 0),
				31,
				30,
				31,
				30,
				31,
				31,
				30,
				31,
				30,
				31
			}
			
			for iter_298_0, iter_298_1 in pairs(var_298_3) do
				var_298_0 = iter_298_0
				
				local var_298_4 = arg_298_1 - iter_298_1 * 86400
				
				if var_298_4 <= 0 then
					var_298_1 = arg_298_0 - arg_298_1
					var_298_2 = var_298_1 + iter_298_1 * 86400 - 1
					
					break
				end
				
				arg_298_1 = var_298_4
			end
			
			return var_298_0, var_298_1, var_298_2
		end
		
		local var_297_1 = arg_297_1 or os.time()
		local var_297_2 = var_297_1 - AccountData.server_time.primal_time
		local var_297_3 = os.date("*t", AccountData.server_time.primal_time).year
		local var_297_4
		local var_297_5
		local var_297_6
		local var_297_7 = 0
		
		while true do
			local var_297_8 = false
			
			if var_297_3 % 400 == 0 then
				var_297_8 = true
			elseif var_297_3 % 100 == 0 then
			elseif var_297_3 % 4 == 0 then
				var_297_8 = true
			end
			
			local var_297_9 = var_297_2 - (365 + (var_297_8 and 1 or 0)) * 86400
			
			if var_297_9 > 0 then
				var_297_3 = var_297_3 + 1
				var_297_7 = var_297_7 + 12
				var_297_2 = var_297_9
			else
				local var_297_10, var_297_11, var_297_12 = var_297_0(var_297_1, var_297_2, var_297_8)
				
				var_297_6 = var_297_12
				var_297_5 = var_297_11
				var_297_7 = var_297_7 + var_297_10
				
				break
			end
		end
		
		return var_297_7, var_297_5, var_297_6
	end
end

function Account.serverTimeMonthInfo(arg_299_0)
	local var_299_0 = (AccountData.server_time or {}).server_time_month
	
	if var_299_0 then
		local var_299_1 = var_299_0.start_time
		local var_299_2 = var_299_0.end_time
		local var_299_3 = var_299_0.temp_automaton_end
		
		return var_299_1, var_299_2, os.date("%m", var_299_1), var_299_3
	end
end

function Account.getDeleteUselessData(arg_300_0)
	if DEBUG.DEBUG_NO_DELETE_USELESS then
		return nil
	end
	
	local var_300_0 = {}
	local var_300_1 = Account:getDeleteDungeonMissionTbl()
	
	if var_300_1 then
		var_300_0.d_mission_tbl = var_300_1
	end
	
	if table.empty(var_300_0) then
		return nil
	end
	
	if DEBUG.DEBUG_DELETE_LOG then
		Log.e("삭제 대상 로그")
		table.print(var_300_0)
	end
	
	return json.encode(var_300_0)
end

function Account.getDeleteStoryList(arg_301_0, arg_301_1)
	if not AccountData.useless_story_data then
		return nil
	end
	
	if AccountData.is_maintenance_day then
		return nil
	end
	
	local var_301_0 = {}
	
	if not AccountData.check_delete_story then
		local var_301_1 = arg_301_0:getPlayedStories()
		
		AccountData.check_delete_story = table.clone(var_301_1.clear_count or {})
	end
	
	for iter_301_0, iter_301_1 in pairs(AccountData.check_delete_story) do
		if AccountData.useless_story_data[iter_301_0] then
			table.insert(var_301_0, iter_301_0)
		end
		
		local var_301_2, var_301_3 = DB("unused_story_id", iter_301_0, {
			"id",
			"substory_id"
		})
		
		if var_301_3 == "vewrda" then
			table.insert(var_301_0, iter_301_0)
		end
		
		AccountData.check_delete_story[iter_301_0] = nil
		
		if #var_301_0 >= 20 then
			break
		end
	end
	
	if #var_301_0 <= 0 then
		return nil
	end
	
	return var_301_0
end

function Account.calcCurrency(arg_302_0, arg_302_1, arg_302_2, arg_302_3, arg_302_4, arg_302_5)
	if arg_302_3 <= arg_302_2 then
		return arg_302_2
	end
	
	if arg_302_5 == "time" then
		local var_302_0 = 0
		
		if arg_302_4.charge_info.min then
			var_302_0 = tonumber(arg_302_4.charge_info.min) * 60
		elseif arg_302_4.charge_info.sec then
			var_302_0 = tonumber(arg_302_4.charge_info.sec)
		end
		
		local var_302_1 = tonumber(arg_302_4.charge_info.add) or 1
		
		arg_302_2 = arg_302_2 + math.floor((os.time() - arg_302_0:getCurrencyTime(arg_302_1)) / var_302_0) * var_302_1
	elseif arg_302_5 == "day" then
		local var_302_2 = tonumber(arg_302_4.charge_info.every) or 0
		local var_302_3, var_302_4, var_302_5 = Account:serverTimeDayLocalDetail()
		local var_302_6 = math.ceil((var_302_4 - arg_302_0:getCurrencyTime(arg_302_1)) / 86400)
		
		if var_302_6 > 0 then
			arg_302_2 = arg_302_2 + var_302_2 * var_302_6
		end
	end
	
	if arg_302_3 and arg_302_3 < arg_302_2 then
		return arg_302_3
	else
		return arg_302_2
	end
end

function Account._getCurrency(arg_303_0, arg_303_1)
	if arg_303_1 and string.starts(arg_303_1, "to_") then
		arg_303_1 = string.split(arg_303_1, "to_")[2]
	end
	
	if arg_303_1 == "clanheritage" then
		if not LotaUserData:isActive() then
			print("[INFO] LOTA USER DATA NOT ACTIVE, BUT REQUEST CLANHERITAGE TOKEN")
			
			return 0
		end
		
		return LotaUserData:getActionPoint()
	end
	
	local var_303_0 = tonumber((AccountData.currency or {})[arg_303_1]) or 0
	local var_303_1 = arg_303_0:getCurrencyMax(arg_303_1) or 0
	local var_303_2 = AccountData.token_info and AccountData.token_info[arg_303_1] or {}
	local var_303_3 = var_303_2.charge_type
	
	return (Account:calcCurrency(arg_303_1, var_303_0, var_303_1, var_303_2, var_303_3))
end

function Account.updateAccountExp(arg_304_0, arg_304_1)
	local var_304_0 = 1
	local var_304_1 = DB("acc_rank", tostring(GAME_STATIC_VARIABLE.max_account_level), "accum_exp")
	
	for iter_304_0 = 1, tonumber(GAME_STATIC_VARIABLE.max_account_level) do
		var_304_0 = iter_304_0
		
		if arg_304_1 < tonumber(DB("acc_rank", tostring(iter_304_0), "accum_exp")) then
			break
		end
	end
	
	if AccountData.exp ~= arg_304_1 then
		arg_304_0.account_last_exp = AccountData.exp
		arg_304_0.account_last_lv = AccountData.level
	end
	
	if var_304_0 > AccountData.level then
		ConditionContentsManager:dispatch("user.levelup", {
			level = var_304_0
		})
		
		if var_304_0 > 60 or math.mod(var_304_0, 5) == 0 then
			Singular:event("account_level_" .. var_304_0)
		end
		
		if IS_PUBLISHER_ZLONG then
			Zlong:roleLevelUp(var_304_0)
		end
	end
	
	AccountData.level = var_304_0
	AccountData.exp = math.min(arg_304_1, var_304_1)
end

function Account.calcAccountExpPercent(arg_305_0, arg_305_1, arg_305_2)
	local var_305_0 = tonumber(DB("acc_rank", tostring(arg_305_1), "accum_exp"))
	local var_305_1 = 0
	
	if arg_305_1 > 1 then
		var_305_1 = tonumber(DB("acc_rank", tostring(arg_305_1 - 1), "accum_exp"))
	end
	
	local var_305_2 = var_305_0 - var_305_1
	local var_305_3 = arg_305_2 - var_305_1
	
	if var_305_3 < 0 then
		var_305_3 = 0
	end
	
	return var_305_3 / var_305_2
end

function Account.getAccountExpPercent(arg_306_0)
	return arg_306_0:calcAccountExpPercent(AccountData.level, AccountData.exp)
end

function Account.getIncAccountExpPercent(arg_307_0, arg_307_1)
	arg_307_1 = arg_307_1 or arg_307_0.account_last_exp
	
	if not arg_307_1 then
		return 0
	end
	
	local var_307_0 = arg_307_0:getAccountExpPercent()
	
	if arg_307_0.account_last_lv ~= AccountData.level then
		return var_307_0
	end
	
	return var_307_0 - arg_307_0:calcAccountExpPercent(AccountData.level, arg_307_1 or 0)
end

function Account.updatePassive(arg_308_0, arg_308_1)
	AccountData.passive = arg_308_1 or {}
end

function Account.getPassiveValue(arg_309_0, arg_309_1)
	if not AccountData.passive then
		return 
	end
	
	return AccountData.passive[arg_309_1]
end

function Account.clearAccountLastExp(arg_310_0)
	local var_310_0 = arg_310_0.account_last_exp
	
	arg_310_0.account_last_exp = nil
	
	return var_310_0
end

function Account.getAccountLastExp(arg_311_0)
	return arg_311_0.account_last_exp
end

function Account.getExp(arg_312_0)
	return AccountData.exp
end

function Account.getHellFloor(arg_313_0)
	return math.max(1, to_n(AccountData.hell_lv) + 1)
end

function Account.getHardHellFloor(arg_314_0)
	local var_314_0 = 0
	
	for iter_314_0 = 1, 999 do
		local var_314_1 = DB("level_enter", "abysshard" .. string.format("%03d", iter_314_0), {
			"id"
		})
		
		if not var_314_1 then
			break
		end
		
		if arg_314_0:isMapCleared(var_314_1) then
			var_314_0 = var_314_0 + 1
		else
			break
		end
	end
	
	return var_314_0
end

function Account.set_last_select_floor(arg_315_0, arg_315_1)
	arg_315_0.last_select_floor = arg_315_1
end

function Account.get_last_select_floor(arg_316_0)
	return arg_316_0.last_select_floor or 0
end

function Account.get_automaton_floor(arg_317_0)
	return tonumber(AccountData.automaton.floor or 1)
end

function Account.get_automaton_week_id(arg_318_0)
	return tonumber(AccountData.automaton.week_id or 1)
end

function Account.get_automaton_last_enter_time(arg_319_0)
	if not AccountData.automaton or not AccountData.automaton.last_enter_time then
		return 1
	end
	
	return AccountData.automaton.last_enter_time or 1
end

function Account.set_automaton_last_enter_time(arg_320_0, arg_320_1)
	if not AccountData.automaton or not AccountData.automaton.last_enter_time then
		return 
	end
	
	AccountData.automaton.last_enter_time = arg_320_1
end

function Account.initAutomatonData(arg_321_0, arg_321_1)
	arg_321_0:setAutomatonInfo(arg_321_1)
	arg_321_0:updateAutomatonHPInfo()
	arg_321_0:setAutomatonDeviceList(arg_321_1.device_list_id or {})
end

function Account.getAutomatonInfo(arg_322_0)
	return AccountData.automaton
end

function Account.setAutomatonInfo(arg_323_0, arg_323_1, arg_323_2)
	if not arg_323_1 then
		return 
	end
	
	local var_323_0 = {}
	
	if not arg_323_1.device_list_id and not arg_323_2 then
		arg_323_1.automaton_device_list = AccountData.automaton.automaton_device_list
	end
	
	AccountData.automaton = arg_323_1
end

function Account.setUnitReserrectionCount(arg_324_0, arg_324_1, arg_324_2)
	if not arg_324_1 or not AccountData.automaton.unit_reserrection_count or not arg_324_2 then
		return 
	end
	
	local var_324_0 = tostring(arg_324_1)
	
	AccountData.automaton.unit_reserrection_count[var_324_0] = arg_324_2
end

function Account.getUnitReserrectionCount(arg_325_0)
	if not AccountData.automaton.unit_reserrection_count or table.empty(AccountData.automaton.unit_reserrection_count) then
		return 0
	end
	
	local var_325_0 = 0
	
	for iter_325_0, iter_325_1 in pairs(AccountData.automaton.unit_reserrection_count) do
		var_325_0 = var_325_0 + tonumber(iter_325_1)
		
		if var_325_0 >= 4 then
			return 4
		end
	end
	
	return math.min(4, var_325_0)
end

function Account.setAutomatonLevel(arg_326_0, arg_326_1)
	AccountData.automaton.automaton_level = arg_326_1
end

function Account.getAutomatonResetLevelCount(arg_327_0)
	return tonumber(AccountData.automaton.reset_count) or 0
end

function Account.isUserSelectAutomatonLevel(arg_328_0)
	if arg_328_0:needToRequestAutomatonData() then
		return false
	end
	
	return AccountData.automaton.automaton_level ~= nil and AccountData.automaton.automaton_level > 0
end

function Account.getAutomatonLevel(arg_329_0)
	return AccountData.automaton.automaton_level or nil
end

function Account.getAutomatonSchedules(arg_330_0)
	return AccountData.automaton_season_schedules
end

function Account.setCurrentAtmtSeason(arg_331_0, arg_331_1)
	AccountData.automaton_cur_season_info = arg_331_1
end

function Account.getCurrentAtmtSeason(arg_332_0)
	return AccountData.automaton_cur_season_info
end

function Account.setClearedAutomatonLevel(arg_333_0, arg_333_1)
	AccountData.automaton.max_cleared_level = arg_333_1
end

function Account.getClearedAutomatonLevel(arg_334_0)
	return AccountData.automaton.max_cleared_level or 0
end

function Account.getAutomatonFloor(arg_335_0)
	local var_335_0 = arg_335_0:getAutomatonInfo()
	
	if var_335_0 then
		return math.max(1, to_n(var_335_0.floor) + 1)
	end
	
	return 1
end

function Account.isConqueredAutomaton(arg_336_0)
	return DungeonAutomaton:getMaxFloor() < Account:getAutomatonFloor()
end

function Account.setAutomatonClearedFloor(arg_337_0, arg_337_1)
	if not AccountData.automaton or not AccountData.automaton.cleared_floor or not arg_337_1 then
		return 
	end
	
	AccountData.automaton.cleared_floor = math.max(tonumber(AccountData.automaton.cleared_floor), tonumber(arg_337_1))
end

function Account.getAutomatonClearedFloor(arg_338_0)
	if not AccountData.automaton then
		return 0
	end
	
	return AccountData.automaton.cleared_floor or 0
end

function Account.addAutomatonDevice(arg_339_0, arg_339_1, arg_339_2)
	if not AccountData.automaton.automaton_device_list then
		AccountData.automaton.automaton_device_list = {}
	end
	
	AccountData.automaton.automaton_device_list[arg_339_1] = arg_339_2
end

function Account.setAutomatonDeviceList(arg_340_0, arg_340_1)
	AccountData.automaton.automaton_device_list = arg_340_1
end

function Account.getAutomatonDeviceLevel(arg_341_0, arg_341_1)
	if not AccountData.automaton.automaton_device_list then
		AccountData.automaton.automaton_device_list = {}
	end
	
	return AccountData.automaton.automaton_device_list[arg_341_1] or 0
end

function Account.needToRequestAutomatonData(arg_342_0)
	if not AccountData.automaton or not AccountData.automaton.automaton_device_list and not AccountData.automaton.automaton_device_info then
		return true
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.AUTOMATON) or ContentDisable:byAlias(string.lower("automaton")) then
		return false
	end
	
	local var_342_0 = Account:serverTimeWeekLocalDetail()
	local var_342_1 = Account:get_automaton_week_id()
	
	if math.floor(var_342_0 / 2) % 5 + 1 ~= math.floor(var_342_1 / 2) % 5 + 1 then
		return true
	end
end

function Account.getAutomatonDeviceList(arg_343_0)
	return AccountData.automaton.automaton_device_list or {}
end

function Account.setRelations(arg_344_0, arg_344_1)
	AccountData.relation = arg_344_1 or {}
end

function Account.setRelationUnit(arg_345_0, arg_345_1, arg_345_2)
	AccountData.relation[arg_345_1] = arg_345_2
end

function Account.getRelationUnit(arg_346_0, arg_346_1)
	if not AccountData or not AccountData.relation then
		return {}
	end
	
	return AccountData.relation[arg_346_1] or {}
end

function Account.isZodiacUpgradableUnit(arg_347_0, arg_347_1, arg_347_2)
	if arg_347_1:isMoonlightDestinyUnit() then
		return false
	end
	
	if arg_347_1:isZodiacUpgradable() then
		if not SAVE:get("game.unit." .. arg_347_1:getUID() .. ".zd") then
			SAVE:set("game.unit." .. arg_347_1:getUID() .. ".zd", true)
		end
		
		return true
	end
end

function Account.updateLotaRegistration(arg_348_0, arg_348_1)
	AccountData.lota_registration_units = arg_348_1
	
	Account:updateLotaTeamInfo()
end

function Account.updateLotaTeamInfo(arg_349_0)
	local var_349_0 = {}
	
	for iter_349_0, iter_349_1 in pairs(Account:getTeam(26) or {}) do
		local var_349_1 = tostring(iter_349_1:getUID())
		
		if not arg_349_0:isLotaRegistrationUnit(var_349_1) then
			table.insert(var_349_0, iter_349_1)
		end
	end
	
	for iter_349_2, iter_349_3 in pairs(var_349_0) do
		Account:removeFromTeam(iter_349_3, 26)
	end
	
	if table.count(var_349_0) > 0 then
		Account:saveTeamInfo()
	end
end

function Account.isLotaRegistrationUnit(arg_350_0, arg_350_1)
	if not AccountData.lota_registration_units then
		return false
	end
	
	for iter_350_0, iter_350_1 in pairs(AccountData.lota_registration_units) do
		if tostring(iter_350_0) == tostring(arg_350_1) then
			return true
		end
	end
	
	return false
end

function Account.isUpgradableUnit(arg_351_0, arg_351_1, arg_351_2)
	if not arg_351_1:isUpgradable() then
		return false
	end
	
	if arg_351_1:isMoonlightDestinyUnit() then
		return false
	end
	
	if arg_351_2 then
		local var_351_0 = 0
		
		for iter_351_0, iter_351_1 in pairs(arg_351_0.units) do
			if iter_351_1:getGrade() == arg_351_1:getGrade() and iter_351_1 ~= arg_351_1 and iter_351_1:getUsableCodeList() == nil then
				var_351_0 = var_351_0 + 1
			end
		end
		
		return var_351_0 >= arg_351_1:getGrade()
	end
	
	return true
end

function Account.setFactions(arg_352_0, arg_352_1)
	arg_352_1 = arg_352_1 or {}
	AccountData.factions = arg_352_1
end

function Account.setFactionExp(arg_353_0, arg_353_1, arg_353_2)
	local var_353_0 = arg_353_0:getFactionByID(arg_353_1)
	local var_353_1 = arg_353_2 - (var_353_0.exp or 0)
	
	var_353_0.exp = arg_353_2
	
	return var_353_1
end

function Account.setConditionData(arg_354_0, arg_354_1)
	arg_354_1 = arg_354_1 or {}
	AccountData.conditions = arg_354_1
end

function Account.getFactions(arg_355_0)
	return AccountData.factions or {}
end

function Account.getFactionByID(arg_356_0, arg_356_1)
	if not arg_356_1 then
		return {}
	end
	
	if not AccountData.factions then
		AccountData.factions = {}
	end
	
	local var_356_0 = AccountData.factions
	
	if not var_356_0[arg_356_1] then
		var_356_0[arg_356_1] = {}
	end
	
	return var_356_0[arg_356_1]
end

function Account.getFactionExp(arg_357_0, arg_357_1)
	return arg_357_0:getFactionByID(arg_357_1).exp or 0
end

function Account.getFactionGroups(arg_358_0)
	return AccountData.faction_groups
end

function Account.setFactionGroups(arg_359_0, arg_359_1)
	AccountData.faction_groups = arg_359_1
end

function Account.getFactionGroupsByFactionID(arg_360_0, arg_360_1)
	local var_360_0 = arg_360_0:getFactionGroups() or {}
	local var_360_1 = {}
	
	for iter_360_0, iter_360_1 in pairs(var_360_0) do
		if iter_360_1.faction_id == arg_360_1 then
			var_360_1[iter_360_0] = iter_360_1
		end
	end
	
	return var_360_1
end

function Account.setFactionGroupInfo(arg_361_0, arg_361_1, arg_361_2, arg_361_3)
	local var_361_0 = arg_361_0:getFactionGroups() or {}
	
	if not var_361_0[arg_361_2] then
		var_361_0[arg_361_2] = {}
	end
	
	if arg_361_3.lv then
		var_361_0[arg_361_2].lv = arg_361_3.lv or var_361_0[arg_361_2].lv
	end
	
	if arg_361_3.state then
		var_361_0[arg_361_2].state = arg_361_3.state or var_361_0[arg_361_2].state
	end
	
	if arg_361_3.faction_id then
		var_361_0[arg_361_2].faction_id = arg_361_3.faction_id or var_361_0[arg_361_2].faction_id
	end
	
	if arg_361_3.group_id then
		var_361_0[arg_361_2].group_id = arg_361_3.group_id or var_361_0[arg_361_2].group_id
	end
end

function Account.getFactionGroupInfo(arg_362_0, arg_362_1, arg_362_2)
	local var_362_0 = (arg_362_0:getFactionGroups() or {})[arg_362_2]
	
	if not var_362_0 then
		return {
			lv = 1,
			state = 0
		}
	end
	
	return var_362_0
end

function Account.getFactionLevel(arg_363_0, arg_363_1)
	return (AchievementUtil:calcFactionLevel(arg_363_1, arg_363_0:getFactionExp(arg_363_1)))
end

function Account.setFactionPoint(arg_364_0, arg_364_1)
	AccountData.faction_point = arg_364_1
end

function Account.getFactionPoint(arg_365_0)
	return AccountData.faction_point or {}
end

function Account.setFactionRewardInfo(arg_366_0, arg_366_1)
	AccountData.faction_rewards[arg_366_1.reward_id] = arg_366_1
end

function Account.getFactionRewardByRewardID(arg_367_0, arg_367_1)
	if not AccountData.faction_rewards then
		return 
	end
	
	return AccountData.faction_rewards[arg_367_1]
end

function Account.getInHousePets(arg_368_0)
	return arg_368_0.pet_house_pets
end

function Account.setInHousePets(arg_369_0, arg_369_1)
	arg_369_0.pet_house_hash_tbl = {}
	
	if not arg_369_1 then
		return 
	end
	
	for iter_369_0, iter_369_1 in pairs(arg_369_1) do
		arg_369_0.pet_house_hash_tbl[iter_369_1] = true
	end
	
	arg_369_0.pet_house_pets = arg_369_1
end

function Account.isHousePet(arg_370_0, arg_370_1)
	if not arg_370_0.pet_house_hash_tbl then
		arg_370_0.pet_house_hash_tbl = {}
		
		for iter_370_0, iter_370_1 in pairs(arg_370_0.pet_house_pets) do
			arg_370_0.pet_house_hash_tbl[iter_370_1] = true
		end
	end
	
	return arg_370_0.pet_house_hash_tbl[arg_370_1]
end

function Account.removeHousePet(arg_371_0, arg_371_1)
	if table.empty(arg_371_0.pet_house_pets) then
		return 
	end
	
	for iter_371_0, iter_371_1 in pairs(arg_371_0.pet_house_pets) do
		if iter_371_1 == arg_371_1 then
			table.remove(arg_371_0.pet_house_pets, iter_371_0)
			arg_371_0:setInHousePets(arg_371_0.pet_house_pets)
			
			return 
		end
	end
end

function Account.setReserveUpdateHousePet(arg_372_0, arg_372_1)
	if not arg_372_1 then
		return 
	end
	
	if not arg_372_0.pet_reserve_update_hash_tbl then
		arg_372_0.pet_reserve_update_hash_tbl = {}
	end
	
	arg_372_0.pet_reserve_update_hash_tbl[arg_372_1] = true
end

function Account.isReserveUpdateHousePet(arg_373_0, arg_373_1)
	if table.empty(arg_373_0.pet_reserve_update_hash_tbl) or not arg_373_1 then
		return false
	end
	
	return arg_373_0.pet_reserve_update_hash_tbl[arg_373_1] or false
end

function Account.clearReserveUpdateHousePet(arg_374_0)
	arg_374_0.pet_reserve_update_hash_tbl = nil
end

function Account.getFactionGrade(arg_375_0, arg_375_1)
	return Account:getFactionLevel(arg_375_1) - 1
end

function Account.getSysAchieveData(arg_376_0)
	return AccountData.sys_achieve or {}
end

function Account.getSysAchieve(arg_377_0, arg_377_1)
	return AccountData.sys_achieve[arg_377_1] or {
		state = 0,
		progress = 0
	}
end

function Account.setSysAchieve(arg_378_0, arg_378_1, arg_378_2)
	if not arg_378_1 then
		return 
	end
	
	if not arg_378_2 then
		return 
	end
	
	AccountData.sys_achieve[arg_378_1] = arg_378_2
	
	return AccountData.sys_achieve[arg_378_1]
end

function Account.isSysAchieveCleared(arg_379_0, arg_379_1)
	return arg_379_0:getSysAchieve(arg_379_1).state > 0
end

function Account.setRelationMoonlightSeason(arg_380_0, arg_380_1)
	if arg_380_1 then
		if not AccountData.relation_moonlight then
			AccountData.relation_moonlight = {}
		end
		
		AccountData.relation_moonlight[arg_380_1.season_idx + 1] = arg_380_1
	end
end

function Account.getRelationMoonlightSeason(arg_381_0, arg_381_1)
	arg_381_1 = arg_381_1 or arg_381_0:getCurrentRelationMoonlightSeason()
	
	return AccountData.relation_moonlight and AccountData.relation_moonlight[arg_381_1] or nil
end

function Account.getCurrentRelationMoonlightSeason(arg_382_0)
	local var_382_0 = 1
	
	for iter_382_0, iter_382_1 in pairs(AccountData.relation_moonlight or {}) do
		if iter_382_1.state == 1 then
			var_382_0 = var_382_0 + 1
		end
	end
	
	return var_382_0
end

function Account.getStateRelationMoonlightAchieveByID(arg_383_0, arg_383_1)
	if not AccountData.relation_moonlight_achievement then
		return MOONLIGHT_ACHIEVE_STATE.ACTIVE
	end
	
	return (AccountData.relation_moonlight_achievement[arg_383_1] or {}).state or MOONLIGHT_ACHIEVE_STATE.ACTIVE
end

function Account.getScoreRelationMoonlightAchieveByID(arg_384_0, arg_384_1)
	if not AccountData.relation_moonlight_achievement then
		return 0
	end
	
	return (AccountData.relation_moonlight_achievement[arg_384_1] or {}).score1 or 0
end

function Account.isClearedRelationMoonlightAchieveByID(arg_385_0, arg_385_1)
	return Account:getStateRelationMoonlightAchieveByID(arg_385_1) >= MOONLIGHT_ACHIEVE_STATE.CLEAR
end

function Account.updateRelationMoonlightAchievement(arg_386_0, arg_386_1)
	if not AccountData.relation_moonlight_achievement then
		AccountData.relation_moonlight_achievement = {}
	end
	
	AccountData.relation_moonlight_achievement[arg_386_1.contents_id] = arg_386_1
end

function Account.is_received_casting_reward(arg_387_0, arg_387_1)
	if not arg_387_1 or not AccountData.moonlight_theater_casts then
		return 
	end
	
	for iter_387_0, iter_387_1 in pairs(AccountData.moonlight_theater_casts) do
		if iter_387_1.cast_id == arg_387_1 and iter_387_1.state and iter_387_1.state == 1 then
			return true
		end
	end
end

function Account.add_mlt_cast_data(arg_388_0, arg_388_1)
	if not arg_388_1 then
		return 
	end
	
	table.insert(AccountData.moonlight_theater_casts, arg_388_1)
end

function Account.get_mlt_cast_data(arg_389_0)
	return AccountData.moonlight_theater_casts
end

function Account.get_mt_ep_datas(arg_390_0)
	return AccountData.moonlight_theater_episodes
end

function Account.get_mt_ep_info(arg_391_0, arg_391_1)
	if not arg_391_1 then
		return 
	end
	
	return AccountData.moonlight_theater_episodes[arg_391_1] or {}
end

function Account.set_mt_ep_info(arg_392_0, arg_392_1, arg_392_2)
	if not arg_392_1 or not arg_392_2 then
		return 
	end
	
	AccountData.moonlight_theater_episodes[arg_392_1] = arg_392_2
end

function Account.set_mt_ep_info2(arg_393_0, arg_393_1, arg_393_2)
	if not arg_393_1 or not arg_393_2 or not AccountData.moonlight_theater_episodes[arg_393_1] then
		return 
	end
	
	AccountData.moonlight_theater_episodes[arg_393_1].clear_tm = arg_393_2.clear_tm
	AccountData.moonlight_theater_episodes[arg_393_1].state = arg_393_2.state
	AccountData.moonlight_theater_episodes[arg_393_1].buy_state = arg_393_2.buy_state
end

function Account.isCleared_mlt_ep(arg_394_0, arg_394_1)
	if not arg_394_1 or not AccountData.moonlight_theater_episodes[arg_394_1] then
		return 
	end
	
	return AccountData.moonlight_theater_episodes[arg_394_1].clear_tm
end

function Account.get_mtl_ep_cleared_tm(arg_395_0, arg_395_1)
	if not AccountData.moonlight_theater_episodes[arg_395_1] then
		return 
	end
	
	return AccountData.moonlight_theater_episodes[arg_395_1].clear_tm
end

function Account.get_mlt_ep_left_time(arg_396_0, arg_396_1)
	if not arg_396_1 then
		return 
	end
	
	local var_396_0, var_396_1, var_396_2 = DB("ml_theater_story", arg_396_1, {
		"id",
		"need_time",
		"need_clear_theater_story"
	})
	
	if not var_396_0 then
		return 
	end
	
	if not var_396_2 or not var_396_1 then
		return 0
	end
	
	if arg_396_0:isCleared_mlt_ep(arg_396_1) then
		return 0
	end
	
	local var_396_3 = arg_396_0:get_mtl_ep_cleared_tm(var_396_2)
	
	if not var_396_3 then
		return 
	end
	
	return os.time() - var_396_3 + var_396_1
end

function Account.get_mlt_ep_data(arg_397_0)
	return AccountData.moonlight_theater_episodes
end

function Account.checkEnterable_MLT_schedule(arg_398_0, arg_398_1)
	if not arg_398_1 then
		return 
	end
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT and not PRODUCTION_MODE then
		return true
	end
	
	if not AccountData.moonlight_theater_schedule or table.empty(AccountData.moonlight_theater_schedule) or not AccountData.moonlight_theater_schedule[arg_398_1] then
		return true
	end
	
	local var_398_0 = AccountData.moonlight_theater_schedule[arg_398_1]
	local var_398_1 = tonumber(var_398_0.start_time)
	local var_398_2 = os.time()
	
	return var_398_1 <= var_398_2, var_398_1 - var_398_2
end

function Account.checkReceivedTreeRewardById(arg_399_0, arg_399_1)
	if not arg_399_1 then
		return 
	end
	
	return Account:getWorldmapReward(arg_399_1) or 0
end

function Account.getAdinChapters(arg_400_0)
	return AccountData.adin_chapters
end

function Account.getSkillTreeFromExtension(arg_401_0, arg_401_1, arg_401_2, arg_401_3)
	local var_401_0 = arg_401_0:getUnitExtensions()
	
	if var_401_0 then
		if arg_401_3 then
			return {
				9,
				9,
				9,
				9,
				9,
				9,
				9,
				9,
				9,
				9
			}
		end
		
		if var_401_0[tostring(arg_401_1)] then
			return var_401_0[tostring(arg_401_1)].stree[arg_401_2] or {}
		end
	end
end

function Account.setExtensionsSkillTree(arg_402_0, arg_402_1, arg_402_2, arg_402_3)
	local var_402_0 = arg_402_0:getUnitExtensions()
	
	if var_402_0 and var_402_0[tostring(arg_402_1)] then
		var_402_0[tostring(arg_402_1)].stree[arg_402_2] = arg_402_3
	end
end

function Account.isAdinOnCollection(arg_403_0)
	local var_403_0 = string.split(GAME_CONTENT_VARIABLE.adin_character_id, ";")
	
	for iter_403_0, iter_403_1 in pairs(var_403_0 or {}) do
		if arg_403_0:getCollectionUnit(iter_403_1) then
			return true
		end
	end
	
	return false
end

function Account.getAdin(arg_404_0)
	for iter_404_0, iter_404_1 in pairs(Account.units or {}) do
		if EpisodeAdin:isAdinCode(iter_404_1.db.code) then
			return iter_404_1
		end
	end
end

function Account.getAdinChapterByID(arg_405_0, arg_405_1)
	return (arg_405_0:getAdinChapters() or {})[arg_405_1]
end

function Account.updateAdinChapter(arg_406_0, arg_406_1)
	if not AccountData.adin_chapters then
		AccountData.adin_chapters = {}
	end
	
	AccountData.adin_chapters[arg_406_1.chapter_id] = arg_406_1
end

function Account.getEpisodeMissions(arg_407_0)
	return AccountData.episode_missions
end

function Account.getEpisodeMissionByID(arg_408_0, arg_408_1)
	return (arg_408_0:getEpisodeMissions() or {})[arg_408_1]
end

function Account.updateEpisodeMission(arg_409_0, arg_409_1)
	if not AccountData.episode_missions then
		AccountData.episode_missions = {}
	end
	
	AccountData.episode_missions[arg_409_1.contents_id] = arg_409_1
end

function Account.getEventMissions(arg_410_0)
	return AccountData.event_missions
end

function Account.getEventMissionByID(arg_411_0, arg_411_1)
	return (arg_411_0:getEventMissions() or {})[arg_411_1]
end

function Account.updateEventMission(arg_412_0, arg_412_1)
	if not AccountData.event_missions then
		AccountData.event_missions = {}
	end
	
	AccountData.event_missions[arg_412_1.contents_id] = arg_412_1
end

function Account.isClearedEventMissionByID(arg_413_0, arg_413_1)
	return Account:getStateEventMissoinByID(arg_413_1) >= MOONLIGHT_ACHIEVE_STATE.CLEAR
end

function Account.getStateEventMissoinByID(arg_414_0, arg_414_1)
	return (Account:getEventMissionByID(arg_414_1) or {}).state or EVENT_MISSION_STATE.ACTIVE
end

function Account.getScoreEventMissionByID(arg_415_0, arg_415_1)
	return (Account:getEventMissionByID(arg_415_1) or {}).score1 or 0
end

function Account.getUnitExtensions(arg_416_0)
	return AccountData.unit_extensions
end

function Account.updateUnitExtension(arg_417_0, arg_417_1)
	if not AccountData.unit_extensions then
		AccountData.unit_extensions = {}
	end
	
	AccountData.unit_extensions[tostring(arg_417_1.id)] = arg_417_1
end

function Account.getDestinyAchieveData(arg_418_0)
	return AccountData.destiny_achieve or {}
end

function Account.getDestinyAchieve(arg_419_0, arg_419_1)
	return AccountData.destiny_achieve[arg_419_1] or {
		state = 0
	}
end

function Account.setDestinyAchieve(arg_420_0, arg_420_1, arg_420_2)
	if not arg_420_1 then
		return 
	end
	
	if not arg_420_2 then
		return 
	end
	
	AccountData.destiny_achieve[arg_420_1] = arg_420_2
end

function Account.getClanMissions(arg_421_0)
	return AccountData.clan_mission or {}
end

function Account.setClanMissions(arg_422_0, arg_422_1)
	AccountData.clan_mission = AccountData.clan_mission or {}
	
	local var_422_0 = false
	
	if table.count(AccountData.clan_mission) ~= table.count(arg_422_1) then
		var_422_0 = true
	else
		for iter_422_0, iter_422_1 in pairs(arg_422_1) do
			if not AccountData.clan_mission[iter_422_0] then
				var_422_0 = true
				
				break
			end
			
			if AccountData.clan_mission[iter_422_0].state ~= iter_422_1.state then
				var_422_0 = true
				
				break
			end
			
			if AccountData.clan_mission[iter_422_0].score1 ~= iter_422_1.score1 then
				var_422_0 = true
				
				break
			end
		end
	end
	
	AccountData.clan_mission = arg_422_1 or {}
	
	if var_422_0 then
		ConditionContentsManager:getClanMissions():initConditionListner()
	end
	
	return AccountData.clan_mission or {}
end

function Account.isClanMissionNoti(arg_423_0)
	local var_423_0 = arg_423_0:getClanMissions()
	local var_423_1 = arg_423_0:serverTimeWeekLocalDetail()
	
	for iter_423_0, iter_423_1 in pairs(var_423_0) do
		if iter_423_1.clan_id == arg_423_0:getClanId() and iter_423_1.state == CLAN_WEEKLY_ACHIEVE_STATE.clear and iter_423_1.week_id == var_423_1 then
			return true
		end
	end
	
	if ClanUtil:getWeekyMissionRewardableItemCnt() > 0 then
		return true
	end
	
	if Clan:isRewardablePrevClanWeeklyMission() then
		return true
	end
	
	return false
end

function Account.getClanLotaEnterDay(arg_424_0)
	local var_424_0 = SAVE:getKeep("clanlota_noti") or 0
	local var_424_1 = arg_424_0:getConfigData("clanlota_noti") or 0
	
	return math.max(var_424_0, var_424_1)
end

function Account.isClanLotaNoti(arg_425_0)
	local var_425_0 = arg_425_0:getLotaSchedules()
	local var_425_1 = arg_425_0:serverTimeDayLocalDetail()
	local var_425_2 = arg_425_0:getClanLotaEnterDay()
	
	if LotaUtil:isAvailableEnter(var_425_0) and var_425_1 ~= var_425_2 then
		return true
	end
	
	return false
end

function Account.setClanLotaEnterDay(arg_426_0)
	local var_426_0 = arg_426_0:serverTimeDayLocalDetail()
	
	SAVE:setKeep("clanlota_noti", var_426_0)
	SAVE:setTempConfigData("clanlota_noti", var_426_0)
end

function Account.clearOpenGachaDay(arg_427_0)
	SAVE:setKeep("gacha_period_warning", 0)
	SAVE:setTempConfigData("gacha_period_warning", 0)
end

function Account.saveOpenGachaDay(arg_428_0)
	local var_428_0 = arg_428_0:serverTimeDayLocalDetail()
	
	SAVE:setKeep("gacha_period_warning", var_428_0)
	SAVE:setTempConfigData("gacha_period_warning", var_428_0)
end

function Account.getOpenGachaDay(arg_429_0)
	local var_429_0 = SAVE:getKeep("gacha_period_warning") or 0
	local var_429_1 = arg_429_0:getConfigData("gacha_period_warning") or 0
	
	return math.max(var_429_0, var_429_1)
end

function Account.isRequireShowPeriodWarningCondition(arg_430_0)
	if arg_430_0:serverTimeDayLocalDetail() ~= arg_430_0:getOpenGachaDay() then
		return true
	end
	
	return false
end

function Account.getClanWeekMissionRewardInfo(arg_431_0)
	return AccountData.clan_week_mission_reward_info
end

function Account.updateClanWeekMissionRewardInfo(arg_432_0, arg_432_1)
	AccountData.clan_week_mission_reward_info = arg_432_1
end

function Account.getClanJoinNoti(arg_433_0)
	return SAVE:getKeep("clanjoin_noti")
end

function Account.setClanJoinNoti(arg_434_0, arg_434_1)
	SAVE:setKeep("clanjoin_noti", arg_434_1)
end

function Account.setClanMission(arg_435_0, arg_435_1, arg_435_2)
	if not arg_435_1 then
		return 
	end
	
	if not arg_435_2 then
		return 
	end
	
	AccountData.clan_mission[arg_435_1] = arg_435_2
	
	return AccountData.clan_mission[arg_435_1]
end

function Account.getClanMission(arg_436_0, arg_436_1)
	return AccountData.clan_mission[arg_436_1] or {
		state = 0
	}
end

function Account.isClearedAchieve(arg_437_0, arg_437_1)
	local var_437_0 = string.split(arg_437_1, "_")
	local var_437_1 = var_437_0[1]
	local var_437_2 = var_437_0[1] .. "_" .. var_437_0[2]
	local var_437_3 = tonumber(var_437_0[3])
	local var_437_4 = Account:getFactionGroupInfo(var_437_1, var_437_2)
	local var_437_5 = var_437_4.lv or 1
	
	return var_437_3 < (var_437_5 or 1) or var_437_4.state >= 1 and var_437_5 == var_437_3
end

function Account.setSubStory(arg_438_0, arg_438_1, arg_438_2)
	if not AccountData.substory then
		AccountData.substory = {}
	end
	
	if not AccountData.substory[arg_438_1] then
		AccountData.substory[arg_438_1] = {}
	end
	
	AccountData.substory[arg_438_1] = arg_438_2
end

function Account.setSubStories(arg_439_0, arg_439_1)
	AccountData.substory = arg_439_1
end

function Account.getSubStory(arg_440_0, arg_440_1)
	if not AccountData.substory then
		return {}
	end
	
	return AccountData.substory[arg_440_1] or {}
end

function Account.getSubStoryContents(arg_441_0, arg_441_1)
	if not AccountData.substory then
		return {}
	end
	
	return (AccountData.substory[arg_441_1] or {}).contents
end

function Account.getSystemSubstory(arg_442_0)
	return AccountData.system_substory or {}
end

function Account.setSystemSubstory(arg_443_0, arg_443_1)
	if not arg_443_1 then
		return 
	end
	
	AccountData.system_substory = arg_443_1
end

function Account.getSystemSubstoryOpenTimes(arg_444_0)
	return AccountData.system_substory_open_schedules
end

function Account.updateSubStoryInfo(arg_445_0, arg_445_1)
	if not AccountData.substory then
		AccountData.substory = {}
	end
	
	for iter_445_0, iter_445_1 in pairs(arg_445_1) do
		AccountData.substory[iter_445_1.substory_id] = iter_445_1
	end
end

function Account.getSubStories(arg_446_0, arg_446_1)
	return AccountData.substory or {}
end

function Account.setSubStoryAchievements(arg_447_0, arg_447_1, arg_447_2)
	if not AccountData.substory_achievements then
		AccountData.substory_achievements = {}
	end
	
	AccountData.substory_achievements[arg_447_1] = arg_447_2
end

function Account.setSubStoryAchievement(arg_448_0, arg_448_1)
	if not arg_448_1 then
		return 
	end
	
	if not AccountData.substory_achievements[arg_448_1.substory_id] then
		return 
	end
	
	AccountData.substory_achievements[arg_448_1.substory_id][arg_448_1.contents_id] = arg_448_1
end

function Account.getSubStoryAchievements(arg_449_0)
	return AccountData.substory_achievements or {}
end

function Account.getSubStoryAchievementBySubstoryID(arg_450_0, arg_450_1)
	return (Account:getSubStoryAchievements() or {})[arg_450_1] or {}
end

function Account.getSubStoryAchievement(arg_451_0, arg_451_1)
	local var_451_0 = string.split(arg_451_1, "_")[1]
	
	if not var_451_0 then
		return 
	end
	
	return arg_451_0:getSubStoryAchievementBySubstoryID(var_451_0)[arg_451_1] or {}
end

function Account.isClearedSubStoryAchievement(arg_452_0, arg_452_1)
	local var_452_0 = (arg_452_0:getSubStoryAchievement(arg_452_1) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE
	
	return tonumber(var_452_0) >= SUBSTORY_ACHIEVE_STATE.CLEAR
end

function Account.setSubStoryQuests(arg_453_0, arg_453_1, arg_453_2)
	if not AccountData.substory_quests then
		AccountData.substory_quests = {}
	end
	
	AccountData.substory_quests[arg_453_1] = arg_453_2
end

function Account.setSubStoryQuest(arg_454_0, arg_454_1)
	if not arg_454_1 then
		return 
	end
	
	if not AccountData.substory_quests[arg_454_1.substory_id] then
		return 
	end
	
	AccountData.substory_quests[arg_454_1.substory_id][arg_454_1.contents_id] = arg_454_1
end

function Account.updateSubStory(arg_455_0, arg_455_1, arg_455_2)
	if not arg_455_2 then
		return 
	end
	
	AccountData.substory[arg_455_1] = arg_455_2
end

function Account.getSubStoryQuests(arg_456_0)
	return AccountData.substory_quests or {}
end

function Account.getSubStoryQuestBySubstoryID(arg_457_0, arg_457_1)
	return (Account:getSubStoryQuests() or {})[arg_457_1] or {}
end

function Account.getSubStoryQuest(arg_458_0, arg_458_1)
	local var_458_0 = string.split(arg_458_1, "_")[1]
	
	if not var_458_0 then
		return 
	end
	
	return arg_458_0:getSubStoryQuestBySubstoryID(var_458_0)[arg_458_1] or {}
end

function Account.getSubStoryStories(arg_459_0, arg_459_1)
	if not AccountData.substory_stories then
		return {}
	end
	
	return AccountData.substory_stories[arg_459_1] or {}
end

function Account.isRequestSubStoryStories(arg_460_0, arg_460_1)
	if not AccountData.substory_stories then
		return true
	end
	
	if not AccountData.substory_stories[arg_460_1] then
		return true
	end
	
	return false
end

function Account.setSubStoryStories(arg_461_0, arg_461_1, arg_461_2)
	if not AccountData.substory_stories then
		AccountData.substory_stories = {}
	end
	
	AccountData.substory_stories[arg_461_1] = arg_461_2
end

function Account.getSubStoryDungeonMissions(arg_462_0)
	return AccountData.substory_dungeon_missions
end

function Account.getSubStoryDungeonMissionsBySubstoryID(arg_463_0, arg_463_1)
	local var_463_0 = arg_463_0:getSubStoryDungeonMissions()
	
	if not var_463_0 then
		return {}
	end
	
	return var_463_0[arg_463_1] or {}
end

function Account.isRequestSubStoryDungeonMissions(arg_464_0, arg_464_1)
	local var_464_0 = arg_464_0:getSubStoryDungeonMissions()
	
	if not var_464_0 then
		return true
	end
	
	if not var_464_0[arg_464_1] then
		return true
	end
	
	return false
end

function Account.setSubStoryDungeonMissions(arg_465_0, arg_465_1, arg_465_2)
	if not AccountData.substory_dungeon_missions then
		AccountData.substory_dungeon_missions = {}
	end
	
	AccountData.substory_dungeon_missions[arg_465_1] = arg_465_2
end

function Account.setSubStoryDungeonMissionState(arg_466_0, arg_466_1, arg_466_2, arg_466_3, arg_466_4)
	if not AccountData.substory_dungeon_missions then
		AccountData.substory_dungeon_missions = {}
	end
	
	if not AccountData.substory_dungeon_missions[arg_466_1] then
		AccountData.substory_dungeon_missions[arg_466_1] = {}
	end
	
	if not AccountData.substory_dungeon_missions[arg_466_1][arg_466_2] then
		AccountData.substory_dungeon_missions[arg_466_1][arg_466_2] = {}
	end
	
	AccountData.substory_dungeon_missions[arg_466_1][arg_466_2][arg_466_3] = {
		state = arg_466_4
	}
end

function Account.setSubStoryChoices(arg_467_0, arg_467_1)
	AccountData.substory_choices = arg_467_1
end

function Account.getSubStoryChoices(arg_468_0)
	return AccountData.substory_choices
end

function Account.setSubStoryChoice(arg_469_0, arg_469_1)
	local var_469_0 = arg_469_0:getSubStoryChoices()
	
	if not var_469_0 then
		return 
	end
	
	if not arg_469_1 then
		return 
	end
	
	var_469_0[arg_469_1.enter_id] = arg_469_1
end

function Account.getSubStoryChoiceID(arg_470_0, arg_470_1)
	local var_470_0 = arg_470_0:getSubStoryChoices()
	
	if not var_470_0 then
		return nil
	end
	
	return (var_470_0[arg_470_1] or {}).choice_id
end

function Account.getSubStoryAllPieces(arg_471_0)
	return AccountData.substory_pieces or {}
end

function Account.getSubStoryPiecesBySubstoryID(arg_472_0, arg_472_1)
	return arg_472_0:getSubStoryAllPieces()[arg_472_1] or {}
end

function Account.getSubStoryPiecesByBoardID(arg_473_0, arg_473_1, arg_473_2)
	return arg_473_0:getSubStoryPiecesBySubstoryID(arg_473_1)[arg_473_2] or {}
end

function Account.getSubStoryPiecesByPieceNum(arg_474_0, arg_474_1, arg_474_2, arg_474_3)
	return arg_474_0:getSubStoryPiecesByBoardID(arg_474_1, arg_474_2)[tostring(arg_474_3)] or {}
end

function Account.isRequestSubStoryPieces(arg_475_0, arg_475_1)
	local var_475_0 = arg_475_0:getSubStoryPiecesBySubstoryID(arg_475_1)
	
	if table.count(var_475_0) <= 0 then
		return true
	end
	
	return false
end

function Account.isRequestSubStoryPieceBoard(arg_476_0, arg_476_1, arg_476_2)
	local var_476_0 = arg_476_0:getSubStoryPiecesByBoardID(arg_476_1, arg_476_2)
	
	if table.count(var_476_0) <= 0 then
		return true
	end
	
	return false
end

function Account.getStateSubStoryPiece(arg_477_0, arg_477_1, arg_477_2, arg_477_3)
	local var_477_0 = arg_477_0:getSubStoryPiecesByPieceNum(arg_477_1, arg_477_2, arg_477_3)
	
	if not var_477_0 then
		return SubstoryPieceState.LOCK
	end
	
	return var_477_0.state
end

function Account.setSubStoryPieceBoardInfos(arg_478_0, arg_478_1, arg_478_2)
	if not AccountData.substory_pieces then
		AccountData.substory_pieces = {}
	end
	
	for iter_478_0, iter_478_1 in pairs(arg_478_2) do
		if not AccountData.substory_pieces[arg_478_1] then
			AccountData.substory_pieces[arg_478_1] = {}
		end
		
		AccountData.substory_pieces[arg_478_1][iter_478_0] = iter_478_1
	end
end

function Account.setSubStoryPieceInfo(arg_479_0, arg_479_1, arg_479_2, arg_479_3, arg_479_4)
	if not AccountData.substory_pieces then
		Log.e("substory_pieces", "no_data")
		
		return 
	end
	
	if not AccountData.substory_pieces[arg_479_1] then
		Log.e("substory_pieces_substory_id", "no_data")
		
		return 
	end
	
	if not AccountData.substory_pieces[arg_479_1][arg_479_2] then
		Log.e("substory_pieces_board_id", "no_data")
		
		return 
	end
	
	if not AccountData.substory_pieces[arg_479_1][arg_479_2][tostring(arg_479_3)] then
		Log.e("substory_pieces_piece_num", "no_data")
		
		return 
	end
	
	AccountData.substory_pieces[arg_479_1][arg_479_2][tostring(arg_479_3)] = arg_479_4
end

function Account.getGlobalSubstory(arg_480_0)
	return AccountData.global_substory
end

function Account.getGlobalSubstoryByID(arg_481_0, arg_481_1)
	return arg_481_0:getGlobalSubstory()[arg_481_1]
end

function Account.setGlobalSubstory(arg_482_0, arg_482_1)
	AccountData.global_substory[arg_482_1.substory_id] = arg_482_1
end

function Account.setSubStoryAlbumPieces(arg_483_0, arg_483_1)
	if not AccountData.substory_album_pieces then
		AccountData.substory_album_pieces = {}
	end
	
	for iter_483_0, iter_483_1 in pairs(arg_483_1) do
		AccountData.substory_album_pieces[iter_483_0] = iter_483_1
	end
end

function Account.updateSubStoryAlbumPiece(arg_484_0, arg_484_1, arg_484_2)
	if not AccountData.substory_album_pieces then
		Log.e("setSubStoryAlbumPiece", "substory_album_pieces")
		
		return 
	end
	
	if not AccountData.substory_album_pieces[arg_484_2.substory_id] then
		Log.e("substory_album_pieces", "substory_id")
		
		return 
	end
	
	if not AccountData.substory_album_pieces[arg_484_2.substory_id][tostring(arg_484_1)] then
		Log.e("substory_album_pieces", "piece_num")
		
		return 
	end
	
	AccountData.substory_album_pieces[arg_484_2.substory_id][tostring(arg_484_1)] = arg_484_2
end

function Account.getSubStoryAlbumPieces(arg_485_0)
	return AccountData.substory_album_pieces
end

function Account.getSubStoryAlbumPiecesBySubstoryID(arg_486_0, arg_486_1)
	return (arg_486_0:getSubStoryAlbumPieces() or {})[arg_486_1]
end

function Account.getSubStoryAlbumPiece(arg_487_0, arg_487_1, arg_487_2)
	return ((arg_487_0:getSubStoryAlbumPieces() or {})[arg_487_1] or {})[tostring(arg_487_2)]
end

function Account.setSubStoryAlbumMissions(arg_488_0, arg_488_1)
	if not AccountData.substory_album_missions then
		AccountData.substory_album_missions = {}
	end
	
	AccountData.substory_album_missions[arg_488_1.substory_id] = arg_488_1
end

function Account.updateSubStoryAlbumMission(arg_489_0, arg_489_1, arg_489_2, arg_489_3, arg_489_4)
	local var_489_0 = arg_489_0:getSubStoryAlbumMissions()
	
	if not var_489_0 then
		Log.e("updateSubStoryAlbumMission", "no_data")
		
		return 
	end
	
	local var_489_1 = var_489_0[arg_489_1]
	
	for iter_489_0 = 1, 3 do
		if var_489_1["mission_id" .. tostring(iter_489_0)] == arg_489_2 then
			var_489_1["mission_score" .. tostring(iter_489_0)] = arg_489_3
			var_489_1["mission_state" .. tostring(iter_489_0)] = arg_489_4
			
			break
		end
	end
end

function Account.getSubStoryAlbumMissions(arg_490_0)
	return AccountData.substory_album_missions
end

function Account.getSubStoryAlbumMissionInfo(arg_491_0, arg_491_1)
	return (arg_491_0:getSubStoryAlbumMissions() or {})[arg_491_1] or {}
end

function Account.getSubStoryAlbumMissionByPieceNum(arg_492_0, arg_492_1, arg_492_2)
	local var_492_0 = (arg_492_0:getSubStoryAlbumMissions() or {})[arg_492_1] or {}
	
	for iter_492_0 = 1, 3 do
		if var_492_0["piece" .. tostring(iter_492_0)] == tonumber(arg_492_2) then
			return {
				mission_id = var_492_0["mission_id" .. tostring(iter_492_0)],
				score = var_492_0["mission_score" .. tostring(iter_492_0)],
				state = var_492_0["mission_state" .. tostring(iter_492_0)]
			}
		end
	end
end

function Account.getSubStoryAlbumMissionInfoData(arg_493_0, arg_493_1, arg_493_2, arg_493_3)
	local function var_493_0(arg_494_0, arg_494_1)
		for iter_494_0 = 1, 3 do
			if arg_494_0["mission_id" .. tostring(iter_494_0)] == arg_494_1 then
				return arg_494_0["mission_" .. arg_493_1 .. tostring(iter_494_0)]
			end
		end
		
		return 0
	end
	
	local var_493_1 = Account:getSubStoryAlbumMissions()
	
	if not var_493_1 then
		Log.e("SubStoryAlbum.isCleared", "no_data")
		
		return 0
	end
	
	if arg_493_2 then
		local var_493_2 = var_493_1[arg_493_2]
		
		return var_493_0(var_493_2, arg_493_3)
	end
	
	for iter_493_0, iter_493_1 in pairs(var_493_1) do
		return var_493_0(iter_493_1, arg_493_3)
	end
	
	return 0
end

function Account.setSubStoryFestivals(arg_495_0, arg_495_1, arg_495_2)
	if not AccountData.substory_festivals then
		AccountData.substory_festivals = {}
	end
	
	AccountData.substory_festivals[arg_495_1] = arg_495_2
end

function Account.updateSubStoryFestivalMission(arg_496_0, arg_496_1, arg_496_2, arg_496_3, arg_496_4)
	local var_496_0 = arg_496_0:getSubStoryFestivals()
	
	if not var_496_0 then
		Log.e("updateSubStoryFestival", "no_data")
		
		return 
	end
	
	local var_496_1 = var_496_0[arg_496_1]
	
	for iter_496_0 = 1, 3 do
		if var_496_1["mission_id" .. tostring(iter_496_0)] == arg_496_2 then
			var_496_1["mission_score" .. tostring(iter_496_0)] = arg_496_3
			var_496_1["mission_state" .. tostring(iter_496_0)] = arg_496_4
			
			break
		end
	end
end

function Account.getSubStoryFestivals(arg_497_0)
	return AccountData.substory_festivals
end

function Account.getSubStoryFestivalInfo(arg_498_0, arg_498_1)
	return (arg_498_0:getSubStoryFestivals() or {})[arg_498_1] or {}
end

function Account.getSubStoryFestivalMissionInfo(arg_499_0, arg_499_1, arg_499_2)
	local function var_499_0(arg_500_0, arg_500_1)
		for iter_500_0 = 1, 3 do
			if arg_500_0["mission_id" .. tostring(iter_500_0)] == arg_500_1 then
				return {
					id = arg_500_0["mission_id" .. tostring(iter_500_0)],
					state = arg_500_0["mission_state" .. tostring(iter_500_0)],
					score = arg_500_0["mission_score" .. tostring(iter_500_0)]
				}
			end
		end
		
		return nil
	end
	
	local var_499_1 = Account:getSubStoryFestivals()
	
	if not var_499_1 then
		Log.e("getSubStoryFestivalMissionInfo", "no_data")
		
		return nil
	end
	
	if arg_499_1 then
		local var_499_2 = var_499_1[arg_499_1]
		
		return var_499_0(var_499_2, arg_499_2)
	end
	
	for iter_499_0, iter_499_1 in pairs(var_499_1) do
		return var_499_0(iter_499_1, arg_499_2)
	end
	
	return nil
end

function Account.setSubStoryRumble(arg_501_0, arg_501_1)
	AccountData.substory_rumble = arg_501_1
end

function Account.getSubStoryRumble(arg_502_0)
	return AccountData.substory_rumble
end

function Account.setSubStoryControlBoard(arg_503_0, arg_503_1)
	AccountData.substory_travel_control_board = arg_503_1
end

function Account.getSubStoryControlBoard(arg_504_0, arg_504_1)
	return AccountData.substory_travel_control_board[arg_504_1]
end

function Account.setSubStoryTravelMissions(arg_505_0, arg_505_1)
	AccountData.substory_travel_missions = arg_505_1
end

function Account.updateSubStoryTravelMission(arg_506_0, arg_506_1, arg_506_2)
	if not AccountData.substory_travel_missions then
		AccountData.substory_travel_missions = {}
	end
	
	AccountData.substory_travel_missions[arg_506_1] = arg_506_2
end

function Account.getTravelMissions(arg_507_0)
	return AccountData.substory_travel_missions or {}
end

function Account.getSubstoryBurningEquipChangeCount(arg_508_0, arg_508_1)
	if not AccountData.substory_burning_infos or not arg_508_1 then
		return 
	end
	
	return AccountData.substory_burning_infos["craft_equip_count_" .. arg_508_1]
end

function Account.setSubStoryBurning(arg_509_0, arg_509_1)
	AccountData.substory_burning_infos = arg_509_1 or {}
	
	arg_509_0:updateSubStoryBurningSoldOutItems(arg_509_1)
end

function Account.updateSubStoryBurningSoldOutItems(arg_510_0, arg_510_1)
	if not arg_510_1 then
		return 
	end
	
	if arg_510_1.gacha_items_1 then
		local var_510_0 = {}
		local var_510_1 = string.split(arg_510_1.gacha_items_1, ",")
		
		for iter_510_0, iter_510_1 in pairs(var_510_1) do
			var_510_0[iter_510_1] = 1
		end
		
		AccountData.substory_burning_infos.gacha_items_1 = var_510_0
	end
	
	if arg_510_1.gacha_items_2 then
		local var_510_2 = {}
		local var_510_3 = string.split(arg_510_1.gacha_items_2, ",")
		
		for iter_510_2, iter_510_3 in pairs(var_510_3) do
			var_510_2[iter_510_3] = 1
		end
		
		AccountData.substory_burning_infos.gacha_items_2 = var_510_2
	end
end

function Account.isBurningStoryCleared(arg_511_0, arg_511_1, arg_511_2)
	if not AccountData.substory_burning_infos or AccountData.substory_burning_infos.chapter_id == "" then
		return 
	end
	
	local var_511_0 = string.sub(arg_511_1, -1)
	local var_511_1 = string.sub(AccountData.substory_burning_infos.chapter_id, -1)
	local var_511_2 = false
	
	return (not (var_511_1 < var_511_0) or false) and (var_511_0 < var_511_1 and true or arg_511_2 <= AccountData.substory_burning_infos.story_idx and true or false)
end

function Account.isBurningStoryRewarded(arg_512_0, arg_512_1, arg_512_2)
	local var_512_0 = tonumber(string.sub(arg_512_1, -1))
	local var_512_1 = false
	
	print(var_512_0)
	
	if var_512_0 == 1 then
		var_512_1 = arg_512_2 <= AccountData.substory_burning_infos.reward_idx_1
	elseif var_512_0 == 2 then
		var_512_1 = arg_512_2 <= AccountData.substory_burning_infos.reward_idx_2
	elseif var_512_0 == 3 then
		var_512_1 = arg_512_2 <= AccountData.substory_burning_infos.reward_idx_3
	else
		var_512_1 = arg_512_2 <= AccountData.substory_burning_infos.reward_idx_4
	end
	
	return var_512_1
end

function Account.isSubstoryBurningIsSoldOutItem(arg_513_0, arg_513_1, arg_513_2)
	if not arg_513_1 or not arg_513_2 then
		return 
	end
	
	local var_513_0
	
	if arg_513_1 == 1 then
		var_513_0 = arg_513_0:getSubStoryBurning().gacha_items_1
	elseif arg_513_1 == 2 then
		var_513_0 = arg_513_0:getSubStoryBurning().gacha_items_2
	end
	
	return var_513_0[tostring(arg_513_2)]
end

function Account.getSubStoryBurning(arg_514_0)
	return AccountData.substory_burning_infos or {}
end

function Account.setSubStoryCustomMissions(arg_515_0, arg_515_1)
	AccountData.substory_custom_missions = arg_515_1
end

function Account.updateSubStoryCustomMission(arg_516_0, arg_516_1, arg_516_2)
	if not AccountData.substory_custom_missions then
		AccountData.substory_custom_missions = {}
	end
	
	AccountData.substory_custom_missions[arg_516_1] = arg_516_2
end

function Account.getCustomMissions(arg_517_0)
	return AccountData.substory_custom_missions or {}
end

function Account.getSubStoryDungeonProperty(arg_518_0)
	return AccountData.substory_dungeon_property
end

function Account.setSubStoryDungeonProperty(arg_519_0, arg_519_1)
	AccountData.substory_dungeon_property = arg_519_1
end

function Account.getHiddenMissions(arg_520_0)
	if not AccountData.hidden_missions then
		AccountData.hidden_missions = {}
	end
	
	return AccountData.hidden_missions
end

function Account.getHiddenMission(arg_521_0, arg_521_1)
	return arg_521_0:getHiddenMissions()[arg_521_1] or {}
end

function Account.setHiddenMission(arg_522_0, arg_522_1)
	if not arg_522_1 then
		return 
	end
	
	arg_522_0:getHiddenMissions()[arg_522_1.mission_id] = arg_522_1
end

function Account.updateUnitHPs(arg_523_0, arg_523_1, arg_523_2, arg_523_3)
	arg_523_3 = arg_523_3 or false
	arg_523_1 = arg_523_1 or arg_523_0.units
	
	if not arg_523_1 then
		return 
	end
	
	local var_523_0 = {}
	
	for iter_523_0, iter_523_1 in pairs(arg_523_1) do
		if not iter_523_1:isSummon() and not iter_523_1:isSupporter() then
			local var_523_1 = iter_523_1:getHPRatio(true)
			local var_523_2 = arg_523_0:getUnit(iter_523_1:getUID())
			
			if var_523_2 then
				if arg_523_2 then
					var_523_1 = math.min(var_523_1, var_523_2.inst.start_hp_r)
				end
				
				var_523_2.inst.start_hp_r = var_523_1
				var_523_0[tostring(var_523_2:getUID())] = {
					var_523_1
				}
				
				var_523_2:reset(true)
				
				if var_523_1 == 1000 then
					arg_523_0.healing_units[var_523_2] = nil
				else
					var_523_2:setBlockUpdateEating(true)
					
					arg_523_0.healing_units[var_523_2] = true
				end
			end
		end
	end
	
	if not table.empty(var_523_0) and arg_523_3 == false then
		local var_523_3 = json.encode(var_523_0)
		
		query("set_hp", {
			units = var_523_3
		})
	end
	
	return var_523_0
end

function Account.getAutomatonHPInfo(arg_524_0)
	if not AccountData.automaton then
		return {}
	end
	
	return AccountData.automaton.automaton_ally_info
end

function Account.setAutomatonHPInfo(arg_525_0, arg_525_1, arg_525_2)
	if not AccountData.automaton.automaton_ally_info then
		return 
	end
	
	local var_525_0 = tostring(arg_525_1)
	
	AccountData.automaton.automaton_ally_info[var_525_0] = arg_525_2
end

function Account.updateAutomatonHPInfo(arg_526_0)
	if not AccountData.automaton.automaton_ally_info then
		return 
	end
	
	for iter_526_0, iter_526_1 in pairs(AccountData.automaton.automaton_ally_info) do
		local var_526_0 = arg_526_0:getUnit(tonumber(iter_526_0))
		
		if var_526_0 then
			var_526_0:setAutomatonHPRatio(iter_526_1)
		end
	end
	
	if table.empty(AccountData.automaton.automaton_ally_info) then
		for iter_526_2, iter_526_3 in pairs(arg_526_0.units) do
			if iter_526_3.inst and iter_526_3.inst.automaton_hp_r then
				iter_526_3.inst.automaton_hp_r = nil
			end
		end
	end
end

function Account.setUnselectDeviceInfo(arg_527_0, arg_527_1)
	AccountData.automaton.unselect_device = arg_527_1
end

function Account.getUnselectDeviceInfo(arg_528_0)
	if not AccountData.automaton then
		return 
	end
	
	return AccountData.automaton.unselect_device
end

function Account.clearUnselectDeviceInfo(arg_529_0)
	if not AccountData.automaton then
		return 
	end
	
	AccountData.automaton.unselect_device = nil
end

function Account.updatePvpInfo(arg_530_0, arg_530_1)
	AccountData.pvp_info = arg_530_1
end

function Account.updatePvpNpcData(arg_531_0, arg_531_1)
	if not arg_531_1 or not arg_531_1.normal then
		return 
	end
	
	AccountData.pvp_npc_list = AccountData.pvp_npc_list or {}
	
	for iter_531_0, iter_531_1 in pairs(AccountData.pvp_npc_list) do
		if iter_531_1.normal and iter_531_1.normal.npc_id == arg_531_1.normal.npc_id then
			AccountData.pvp_npc_list[iter_531_0] = arg_531_1
			
			break
		end
	end
end

function Account.getAllNPC(arg_532_0)
	return AccountData.pvp_npc_list or {}
end

function Account.getPvpInfo(arg_533_0)
	return AccountData.pvp_info
end

function Account.getStoryInfos(arg_534_0)
	local var_534_0 = SubstoryManager:getPlaySubstoryIDList()
	local var_534_1 = arg_534_0:getPlayedStories() or {}
	
	if not var_534_1.clear_count then
		var_534_1.clear_count = {}
	end
	
	for iter_534_0, iter_534_1 in pairs(var_534_0) do
		local var_534_2 = arg_534_0:getSubStoryStories(iter_534_1)
		
		if var_534_2 and var_534_2.clear_count then
			table.merge(var_534_1.clear_count, var_534_2.clear_count)
		end
	end
	
	return var_534_1
end

function Account.getPlayedStories(arg_535_0)
	return AccountData.played_stories or {}
end

function Account.setPlayedStories(arg_536_0, arg_536_1)
	AccountData.played_stories = arg_536_1
end

function Account.isPlayedStory(arg_537_0, arg_537_1)
	if not arg_537_1 then
		return false, 0
	end
	
	if DB("story_list", arg_537_1, "loop") == "y" then
		return false, 0
	end
	
	local var_537_0 = (arg_537_0:getStoryInfos().clear_count or {})[arg_537_1] or 0
	
	return var_537_0 > 0, var_537_0
end

function Account.mergePlayedSubstoryStories(arg_538_0, arg_538_1, arg_538_2)
	arg_538_2 = arg_538_2 or {}
	
	local var_538_0 = arg_538_0:getSubStoryStories(arg_538_1).clear_count or {}
	
	for iter_538_0, iter_538_1 in pairs(arg_538_2.clear_count or {}) do
		var_538_0[iter_538_0] = iter_538_1
	end
end

function Account.mergePlayedStories(arg_539_0, arg_539_1)
	arg_539_1 = arg_539_1 or {}
	
	local var_539_0 = arg_539_0:getPlayedStories().clear_count or {}
	
	for iter_539_0, iter_539_1 in pairs(arg_539_1.clear_count or {}) do
		var_539_0[iter_539_0] = iter_539_1
	end
end

function Account.deletePlayedStories(arg_540_0, arg_540_1)
	if not arg_540_1 then
		return 
	end
	
	count_infos = arg_540_0:getPlayedStories().clear_count or {}
	
	for iter_540_0, iter_540_1 in pairs(arg_540_1) do
		count_infos[iter_540_1] = nil
	end
end

function Account.isLoginComplete(arg_541_0)
	return AccountData ~= nil
end

function Account.migrateDevotionItems(arg_542_0)
	if not AccountData.items_dv_migration then
		return 
	end
	
	for iter_542_0, iter_542_1 in pairs(AccountData.items_dv_migration) do
		if iter_542_1.code then
			AccountData.items[iter_542_1.code] = iter_542_1
		end
	end
end

function Account.setAccountInfo(arg_543_0, arg_543_1, arg_543_2)
	AccountData = arg_543_1
	
	arg_543_0:migrateDevotionItems()
	
	arg_543_0.additional_data = arg_543_2
	AccountData.currency = AccountData.currency or {}
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_544_0)
			AccountData.currency = arg_544_0(AccountData.currency)
		end, false)
	else
		var_0_2(arg_543_0, false)
	end
	
	for iter_543_0, iter_543_1 in pairs(arg_543_0:getCurrencyCodes()) do
		if not AccountData.currency[iter_543_1] then
			AccountData.currency[iter_543_1] = 0
		end
	end
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_545_0)
			AccountData.currency = arg_545_0(AccountData.currency)
		end, true)
	else
		var_0_2(arg_543_0, true)
	end
end

function Account.procMinimalAccountInfo(arg_546_0)
	local var_546_0 = AccountData.equips
	
	arg_546_0.equips = {}
	
	for iter_546_0, iter_546_1 in pairs(var_546_0) do
		local var_546_1 = EQUIP:createByInfo(iter_546_1)
		
		if not var_546_1 then
			print("Error: no equip : " .. tostring(iter_546_1.code))
		else
			table.insert(arg_546_0.equips, var_546_1)
			
			if iter_546_1.p then
				local var_546_2 = Account:getUnit(iter_546_1.p)
				
				if var_546_2 then
					if var_546_2:addEquip(var_546_1, true) == false then
						var_546_1.parent = nil
					end
				else
					var_546_1.parent = nil
				end
			end
		end
	end
	
	local var_546_3 = AccountData.items
	
	arg_546_0.items = {}
	
	for iter_546_2, iter_546_3 in pairs(var_546_3) do
		arg_546_0.items[iter_546_3.code] = iter_546_3.c
	end
end

function Account.procAccountInfo(arg_547_0)
	if AccountData.proceed_info then
		return 
	end
	
	AccountData.proceed_info = true
	
	local var_547_0 = AccountData.units
	local var_547_1 = AccountData.teams
	local var_547_2 = AccountData.team_names
	local var_547_3 = AccountData.equips
	local var_547_4 = AccountData.pets
	local var_547_5 = AccountData.pet_slots
	local var_547_6 = AccountData.items
	local var_547_7 = AccountData.places
	local var_547_8 = AccountData.relation
	local var_547_9 = AccountData.sys_achieve
	local var_547_10 = AccountData.calc_friend_point
	
	arg_547_0:setRelations(var_547_8)
	
	local var_547_11
	
	Account:initTeam()
	
	AccountData.team_names = {}
	AccountData.max_inven = AccountData.max_inven or 150
	AccountData.max_equips = AccountData.max_equips or 50
	AccountData.token_info = {}
	
	local var_547_12 = arg_547_0:getCurrencyCodes()
	
	for iter_547_0, iter_547_1 in pairs(var_547_12) do
		local var_547_13, var_547_14, var_547_15, var_547_16, var_547_17, var_547_18 = DB("item_token", "to_" .. iter_547_1, {
			"type",
			"name",
			"icon",
			"charge_type",
			"charge_value",
			"max"
		})
		local var_547_19 = {}
		
		if var_547_17 then
			local var_547_20 = string.split(var_547_17, ",")
			
			for iter_547_2, iter_547_3 in pairs(var_547_20) do
				local var_547_21 = string.split(iter_547_3, "=")
				
				if var_547_21[1] then
					var_547_19[var_547_21[1]] = var_547_21[2]
				end
			end
		end
		
		AccountData.token_info[iter_547_1] = {
			type = var_547_13,
			name = var_547_14,
			icon = var_547_15,
			charge_type = var_547_16,
			charge_value = var_547_17,
			max = var_547_18,
			charge_info = var_547_19
		}
	end
	
	local var_547_22 = arg_547_0:addUnitsByUnitInfos(var_547_0, true)
	
	arg_547_0.equips = {}
	
	for iter_547_4, iter_547_5 in pairs(var_547_3) do
		local var_547_23 = EQUIP:createByInfo(iter_547_5)
		
		if not var_547_23 then
			print("Error: no equip : " .. tostring(iter_547_5.code))
		else
			table.insert(arg_547_0.equips, var_547_23)
			
			if iter_547_5.p then
				local var_547_24 = Account:getUnit(iter_547_5.p)
				
				if var_547_24 then
					local var_547_25 = true
					
					if var_547_23.isExclusive and var_547_23:isExclusive() then
						var_547_25 = false
					end
					
					if var_547_24:addEquip(var_547_23, var_547_25) == false then
						var_547_23.parent = nil
					elseif var_547_25 == false then
						SkillEffectFilterManager:refreshUnit(var_547_24)
					end
				else
					var_547_23.parent = nil
				end
			end
		end
	end
	
	arg_547_0.pets = {}
	
	for iter_547_6, iter_547_7 in pairs(var_547_4 or {}) do
		local var_547_26 = PET:create(iter_547_7)
		
		if not var_547_26 then
			print("Error: no pet : " .. tostring(iter_547_7.code))
		else
			table.insert(arg_547_0.pets, var_547_26)
		end
	end
	
	arg_547_0.pet_house_pets = {}
	
	local var_547_27 = var_547_5.house_pets
	
	for iter_547_8, iter_547_9 in pairs(var_547_27 or {}) do
		arg_547_0.pet_house_pets[iter_547_8] = iter_547_9
	end
	
	AccountData.pet_inven = var_547_5.pet_inven
	
	ConditionContentsManager:init()
	Clan:create(AccountData.clan_info)
	
	local var_547_28 = SAVE:get("skin_loaded")
	
	arg_547_0.items = {}
	
	for iter_547_10, iter_547_11 in pairs(var_547_6) do
		arg_547_0.items[iter_547_11.code] = iter_547_11.c
		
		if not var_547_28 and string.starts(iter_547_11.code, "ma_") and DB("item_material", iter_547_11.code, "ma_type") == "skin" and not SAVE:get("skin:" .. iter_547_11.code) then
			SAVE:set("skin:" .. iter_547_11.code, true)
			
			var_547_22 = true
		end
	end
	
	local var_547_29 = AccountData.item_flag
	
	if var_547_29 then
		for iter_547_12 = 1, 99999 do
			local var_547_30, var_547_31 = DBN("material_flag", tostring(iter_547_12), {
				"id",
				"key"
			})
			
			if not var_547_30 then
				break
			end
			
			local var_547_32 = tonumber(var_547_31)
			local var_547_33 = math.floor((var_547_32 - 1) / 4)
			local var_547_34 = string.sub(var_547_29, var_547_33 + 1, var_547_33 + 1)
			
			if var_547_34 ~= "0" and var_547_34 ~= "" and var_547_34 ~= nil then
				local var_547_35 = tonumber(var_547_34, 16)
				local var_547_36 = 3 - (var_547_32 - 1) % 4
				
				if bit.band(var_547_35, 2^var_547_36) == 2^var_547_36 then
					arg_547_0.items[var_547_30] = 1
				end
			end
		end
	end
	
	if not var_547_28 then
		SAVE:set("skin_loaded", true)
		
		var_547_22 = true
	end
	
	arg_547_0:calcUnitStatus()
	arg_547_0:buildTeamInfo(var_547_1)
	
	for iter_547_13, iter_547_14 in pairs(var_547_2) do
		AccountData.team_names[iter_547_14.team_index] = iter_547_14
	end
	
	arg_547_0:saveTeamInfo(true)
	arg_547_0:selectTeam(1)
	
	if arg_547_0.additional_data then
	end
	
	if Login.vars.new_device then
		print("is new device : true")
	end
	
	if var_547_22 then
		SAVE:save()
	end
	
	if SAVE:get("game.restore_battle_data") then
	end
	
	if AccountData.content_switch then
		ContentDisable:resetContentSwitchMain(AccountData.content_switch)
		
		AccountData.content_switch = nil
	end
	
	DEBUG.MAP_DEBUG = SAVE:get("game.map_debug")
	
	Scheduler:addGlobalInterval(1000, arg_547_0.onUpdate, arg_547_0)
end

function Account.isIn_worldbossSupporterTeam(arg_548_0, arg_548_1)
	if not AccountData.worldboss_supporter or not arg_548_1 then
		return false
	end
	
	for iter_548_0, iter_548_1 in pairs(AccountData.worldboss_supporter) do
		for iter_548_2, iter_548_3 in pairs(iter_548_1) do
			if iter_548_3 == arg_548_1 then
				return true
			end
		end
	end
	
	return false
end

function Account.set_worldbossSupporterTeam(arg_549_0, arg_549_1)
	if not arg_549_1 then
		return 
	end
	
	if not AccountData.worldboss_supporter then
		AccountData.worldboss_supporter = {}
	end
	
	AccountData.worldboss_supporter.fire = arg_549_1.fire
	AccountData.worldboss_supporter.ice = arg_549_1.ice
	AccountData.worldboss_supporter.wind = arg_549_1.wind
	AccountData.worldboss_supporter.light = arg_549_1.light
	AccountData.worldboss_supporter.dark = arg_549_1.dark
end

function Account.get_worldbossSupporterTeam(arg_550_0)
	return AccountData.worldboss_supporter
end

function Account.reset_worldbossSupporterTeam(arg_551_0)
	AccountData.worldboss_supporter = {}
end

function Account.addUnitsByUnitInfos(arg_552_0, arg_552_1, arg_552_2)
	local var_552_0
	
	arg_552_0.units = {}
	arg_552_0.summons = {}
	
	local var_552_1 = os.time()
	
	for iter_552_0, iter_552_1 in pairs(arg_552_1) do
		if iter_552_1.cat and var_552_1 >= iter_552_1.cat then
			iter_552_1.h = nil
			iter_552_1.cat = nil
			iter_552_1.cat = nil
		end
		
		local var_552_2 = UNIT:create(iter_552_1, nil, arg_552_2)
		
		if not var_552_2 then
			print("Error: no unit : " .. tostring(iter_552_1.code))
		else
			if var_552_2:isSummon() then
				table.insert(arg_552_0.summons, var_552_2)
			else
				SkillEffectFilterManager:addUnit(var_552_2)
				table.insert(arg_552_0.units, var_552_2)
			end
			
			if not arg_552_2 and not var_552_2:isMaxHP() then
				arg_552_0.healing_units[var_552_2] = true
			end
			
			var_552_0 = arg_552_0:onAddUnit(var_552_2.inst.code, var_552_2:getGrade()) or var_552_0
			
			if SAVE:get("game.unit." .. iter_552_1.id) == nil then
				arg_552_0:updateUnitSummaryData(var_552_2)
				
				var_552_0 = true
			elseif SAVE:get("game.unit." .. iter_552_1.id .. ".lv") ~= var_552_2:getLv() then
				arg_552_0:updateUnitSummaryData(var_552_2)
				
				var_552_0 = true
			end
		end
	end
	
	return var_552_0
end

function Account.clearEquipParent(arg_553_0, arg_553_1)
	for iter_553_0, iter_553_1 in pairs(arg_553_0.equips) do
		if iter_553_1.parent == arg_553_1 then
			iter_553_1.parent = nil
		end
	end
end

function Account.setCampSaveData(arg_554_0, arg_554_1, arg_554_2)
	if not AccountData.camp_saved then
		AccountData.camp_saved = {}
	end
	
	AccountData.camp_saved[arg_554_1] = arg_554_2
end

function Account.getCampSaveData(arg_555_0, arg_555_1)
	if not AccountData.camp_saved then
		AccountData.camp_saved = {}
	end
	
	local var_555_0 = AccountData.camp_saved[arg_555_1]
	
	if var_555_0 then
		return var_555_0
	end
	
	return nil
end

function Account.getSubtaskMission(arg_556_0, arg_556_1)
	if not AccountData.subtask then
		return nil
	end
	
	return AccountData.subtask[arg_556_1]
end

function Account.deleteSubtaskMission(arg_557_0, arg_557_1)
	AccountData.subtask[arg_557_1] = nil
end

function Account.addSubtaskMission(arg_558_0, arg_558_1)
	AccountData.subtask[arg_558_1.id] = arg_558_1
end

function Account.updateAllSubtaskMission(arg_559_0, arg_559_1)
	AccountData.subtask = arg_559_1 or {}
end

function Account.isTeamInSubtaskMission(arg_560_0, arg_560_1)
	if not AccountData.subtask then
		return false
	end
	
	for iter_560_0, iter_560_1 in pairs(AccountData.subtask) do
		if iter_560_1.team_index == arg_560_1 then
			return true
		end
	end
	
	return false
end

function Account.getClanId(arg_561_0)
	return AccountData.clan_id
end

function Account.setClanId(arg_562_0, arg_562_1)
	if AccountData.clan_id ~= arg_562_1 then
		AccountData.clan_id = arg_562_1
		
		LuaEventDispatcher:dispatchEvent("clan.id", {
			clan_id = arg_562_1
		})
	end
end

function Account.setClanLeavePenalty(arg_563_0, arg_563_1)
	AccountData.clan_leave_penalty = arg_563_1
end

function Account.getClanLeavePenalty(arg_564_0)
	return AccountData.clan_leave_penalty
end

function Account.setClanLeaveTime(arg_565_0, arg_565_1)
	AccountData.clan_leave_time = arg_565_1
end

function Account.getClanLeaveTime(arg_566_0)
	return AccountData.clan_leave_time
end

function Account.setLobbyCount(arg_567_0, arg_567_1)
	AccountData.lobby_count = arg_567_1
end

function Account.getLobbyCount(arg_568_0)
	return AccountData.lobby_count or 0
end

function Account.setLobbyEnterTime(arg_569_0, arg_569_1)
	AccountData.lobby_enter_time = arg_569_1
end

function Account.getLobbyEnterTime(arg_570_0)
	return AccountData.lobby_enter_time or 0
end

function Account.isLobbyFirst(arg_571_0)
	AccountData.first_lobby_count = (AccountData.first_lobby_count or 0) + 1
	
	return AccountData.first_lobby_count == 1
end

function Account.getTeamSubtaskEndTime(arg_572_0, arg_572_1)
	if not AccountData.subtask then
		return nil
	end
	
	for iter_572_0, iter_572_1 in pairs(AccountData.subtask) do
		if iter_572_1.team_index == arg_572_1 then
			for iter_572_2, iter_572_3 in ipairs(AccountData.teams[arg_572_1]) do
				if iter_572_3 then
					return iter_572_3.inst.subtask_end_time
				end
			end
		end
	end
	
	return nil
end

function Account.getFriendRequested(arg_573_0)
	return AccountData.friend_requested_count or 0
end

function Account.updateFriendRequested(arg_574_0, arg_574_1)
	if not arg_574_1 then
		return 
	end
	
	AccountData.friend_requested_count = arg_574_1
end

function Account.updateFriendCounts(arg_575_0, arg_575_1)
	if not arg_575_1 then
		return 
	end
	
	AccountData.friend_requested_count = to_n(arg_575_1.friend_requested_count)
	AccountData.friend_sent_count = to_n(arg_575_1.friend_sent_count)
	AccountData.friend_count = to_n(arg_575_1.friend_count)
end

function Account.getMainUnitCode(arg_576_0)
	local var_576_0 = "c1001"
	local var_576_1 = arg_576_0:getMainUnit()
	
	if var_576_1 then
		var_576_0 = var_576_1.inst.skin_code or var_576_1.db.code
	end
	
	return var_576_0
end

function Account.getMainUnit(arg_577_0)
	return arg_577_0:getUnit(AccountData.main_unit)
end

function Account.getMainUnitId(arg_578_0)
	return AccountData.main_unit
end

function Account.updateMainUnitId(arg_579_0, arg_579_1)
	if not arg_579_1 then
		return 
	end
	
	local var_579_0 = AccountData.main_unit
	
	AccountData.main_unit = arg_579_1
	
	LuaEventDispatcher:dispatchEvent("change_main_unit", {
		unit_id = arg_579_1,
		old_unit_id = var_579_0
	})
	
	return var_579_0
end

function Account.acquireCalcFriendPoint(arg_580_0)
	local var_580_0 = table.clone(AccountData.calc_friend_point)
	
	AccountData.calc_friend_point.calc_data = nil
	AccountData.calc_friend_point.total_friendpoint = 0
	
	return var_580_0
end

function Account.getFriendPointData(arg_581_0, arg_581_1)
	return AccountData.friend_point_data[arg_581_1]
end

function MsgHandler.save_team(arg_582_0)
	if arg_582_0.building_info then
		ClanWar:updateBuildingMember(arg_582_0.building_info.slot, arg_582_0.building_info, false)
		ClanWarMain:updateEmtpyEquipSlotUI()
	end
end

function Account.getEvents(arg_583_0)
	return AccountData.events or {}
end

function Account.getAttendanceEventsBySubTypes(arg_584_0, ...)
	local var_584_0 = {
		...
	}
	
	if table.empty(var_584_0) then
		return {}
	end
	
	local var_584_1 = {}
	local var_584_2 = Account:getEvents().attendance or {}
	
	for iter_584_0, iter_584_1 in pairs(var_584_2) do
		if not Account:isReturnAttendance(iter_584_1.event_name) and table.isInclude(var_584_0, iter_584_1.sub_type) then
			table.insert(var_584_1, iter_584_1)
		end
	end
	
	return var_584_1
end

function Account.getReturnAttendanceEvent(arg_585_0)
	local var_585_0 = Account:getEvents().attendance or {}
	
	for iter_585_0, iter_585_1 in pairs(var_585_0) do
		if Account:isReturnAttendance(iter_585_1.event_name) then
			if iter_585_1.progress_day == 1 and iter_585_1.reward_received == true and not Singular.is_event_calendar_return_first then
				Singular.is_event_calendar_return_first = true
				
				Singular:event("calendar_return_first")
			end
			
			return iter_585_1
		end
	end
end

function Account.isReturnAttendance(arg_586_0, arg_586_1)
	return arg_586_1 == GAME_CONTENT_VARIABLE.return_calendar_id
end

function Account.getEventTime(arg_587_0, arg_587_1)
	local var_587_0 = Account:getEvents().attendance or {}
	local var_587_1
	
	for iter_587_0, iter_587_1 in pairs(var_587_0) do
		if iter_587_1.event_name == arg_587_1 then
			var_587_1 = iter_587_1
		end
	end
	
	if not var_587_1 then
		return 
	end
	
	return var_587_1.start_time, var_587_1.end_time
end

function Account.getName(arg_588_0, arg_588_1)
	if arg_588_1 then
		return AccountData.name
	elseif PLATFORM == "win32" then
		return AccountData.name .. " #" .. AccountData.user_number
	else
		return AccountData.name
	end
end

function Account.setName(arg_589_0, arg_589_1)
	local var_589_0 = AccountData.name
	
	AccountData.name = arg_589_1
	
	if IS_PUBLISHER_ZLONG then
		Zlong:setRoleName()
	end
	
	LuaEventDispatcher:dispatchEvent("change_nickname", {
		name = arg_589_1,
		old_name = var_589_0
	})
end

function Account.getIntroMsg(arg_590_0)
	return AccountData.intro_msg
end

function Account.setIntroMsg(arg_591_0, arg_591_1)
	AccountData.intro_msg = arg_591_1
end

function Account.getUserId(arg_592_0)
	return AccountData.id
end

function Account.getDestinyData(arg_593_0)
	return AccountData.destiny
end

function Account.setDestinyData(arg_594_0, arg_594_1)
	AccountData.destiny[arg_594_1] = true
end

function Account.getDestinyDataById(arg_595_0, arg_595_1)
	return AccountData.destiny[arg_595_1]
end

function Account.addReward(arg_596_0, arg_596_1, arg_596_2)
	if not arg_596_1 then
		return 
	end
	
	arg_596_2 = arg_596_2 or {}
	
	local var_596_0 = {}
	local var_596_1 = {}
	local var_596_2 = {}
	local var_596_3 = {}
	local var_596_4 = {}
	local var_596_5 = {}
	local var_596_6 = 0
	local var_596_7 = {
		new_units = {},
		new_pets = {},
		new_equips = {},
		rewards = {},
		re_popup = {}
	}
	
	if arg_596_1.acc_exp then
		var_596_7.account_lv_before = Account:getLevel()
		
		arg_596_0:updateAccountExp(arg_596_1.acc_exp)
		
		var_596_7.account_lv_after = Account:getLevel()
	end
	
	for iter_596_0, iter_596_1 in pairs(arg_596_1.new_items or {}) do
		local var_596_8 = Account:setItem(iter_596_1, {
			enter = arg_596_2.enter,
			content = arg_596_2.content,
			ignore_get_condition = arg_596_2.ignore_get_condition
		})
		
		if var_596_8 > 0 then
			iter_596_1.diff = var_596_8
		end
		
		local var_596_9 = arg_596_2.hide_reward_id and table.find(arg_596_2.hide_reward_id, iter_596_1.code)
		local var_596_10, var_596_11 = DB("item_material", iter_596_1.code, {
			"id",
			"ma_type"
		})
		
		if var_596_11 and var_596_11 == "illust" then
			var_596_8 = 1
			iter_596_1.diff = 1
		end
		
		if not var_596_9 then
			table.insert(var_596_7.rewards, {
				code = iter_596_1.code,
				count = var_596_8
			})
		end
		
		if (arg_596_2.effect or arg_596_2.play_reward_data) and not var_596_9 then
			table.insert(var_596_0, iter_596_1)
		end
	end
	
	for iter_596_2, iter_596_3 in pairs(arg_596_1.new_equips or {}) do
		local var_596_12 = Account:addEquip(iter_596_3, {
			enter = arg_596_2.enter,
			entertype = arg_596_2.entertype
		})
		
		table.insert(var_596_7.rewards, {
			code = var_596_12.code,
			item = var_596_12
		})
		
		if (arg_596_2.effect or arg_596_2.play_reward_data) and not var_596_12:isExclusive() then
			table.insert(var_596_1, var_596_12)
		end
		
		if arg_596_2.rtn_equips then
			table.insert(var_596_7.new_equips, {
				code = var_596_12.code,
				item = var_596_12
			})
		end
	end
	
	for iter_596_4, iter_596_5 in pairs(arg_596_1.new_units or {}) do
		if arg_596_2.content then
			iter_596_5.content = arg_596_2.content
		end
		
		local var_596_13, var_596_14 = Account:addUnit(iter_596_5)
		
		table.insert(var_596_7.rewards, {
			code = var_596_13.db.code,
			item = var_596_13
		})
		
		if var_596_14 then
			table.insert(var_596_7.new_units, iter_596_5)
		end
		
		if arg_596_2.effect or arg_596_2.play_reward_data then
			table.insert(var_596_2, var_596_13)
		end
	end
	
	for iter_596_6, iter_596_7 in pairs(arg_596_1.new_pets or {}) do
		if arg_596_2.content then
			iter_596_7.content = arg_596_2.content
		end
		
		local var_596_15, var_596_16 = Account:addPet(iter_596_7)
		
		table.insert(var_596_7.rewards, {
			code = var_596_15.db.code,
			item = var_596_15
		})
		
		if var_596_16 then
			table.insert(var_596_7.new_pets, iter_596_7)
		end
		
		if arg_596_2.effect or arg_596_2.play_reward_data then
			table.insert(var_596_3, var_596_15)
		end
	end
	
	for iter_596_8, iter_596_9 in pairs(arg_596_1.special_codes or {}) do
		arg_596_0:procSpecialCode(iter_596_9)
	end
	
	for iter_596_10, iter_596_11 in pairs(arg_596_1.account_skills or {}) do
		table.insert(var_596_7.rewards, {
			is_account_skills = true,
			code = iter_596_11.skill_id,
			item = iter_596_11
		})
		AccountSkill:setAccountSkill(iter_596_11.skill_id, iter_596_11)
	end
	
	for iter_596_12, iter_596_13 in pairs(arg_596_1.randomboxes or {}) do
		var_596_7.is_randombox = true
		
		if not arg_596_2.no_rtn_reward_randombox then
			table.insert(var_596_7.rewards, {
				is_randombox = true,
				code = iter_596_13.randombox,
				item = iter_596_13
			})
		end
	end
	
	for iter_596_14, iter_596_15 in pairs(arg_596_1.packages or {}) do
		var_596_7.is_package = true
		
		table.insert(var_596_7.rewards, {
			is_package = true,
			code = iter_596_15.package,
			items = iter_596_15
		})
	end
	
	local var_596_17 = {}
	
	for iter_596_16, iter_596_17 in pairs(arg_596_1.new_coins or {}) do
		var_596_17[iter_596_17.code] = (var_596_17[iter_596_17.code] or 0) + iter_596_17.count
		
		table.insert(var_596_5, iter_596_17)
	end
	
	local var_596_18 = Account:updateCurrencies(arg_596_1, {
		buy = arg_596_2.buy,
		enter = arg_596_2.enter,
		ignore_get_condition = arg_596_2.ignore_get_condition
	})
	
	var_596_7.currencies_diff = var_596_18
	
	for iter_596_18, iter_596_19 in pairs(var_596_18 or {}) do
		if Account:isCurrencyType(iter_596_18) and iter_596_19 > 0 then
			table.insert(var_596_7.rewards, {
				is_currency = true,
				code = iter_596_18,
				count = iter_596_19
			})
		end
	end
	
	if arg_596_2.play_reward_data or arg_596_2.single then
		local var_596_19 = {}
		
		for iter_596_20, iter_596_21 in pairs(var_596_18) do
			if Account:isCurrencyType(iter_596_20) and iter_596_21 > 0 then
				local var_596_20 = to_n(iter_596_21)
				
				if var_596_17[iter_596_20] then
					var_596_20 = var_596_20 - to_n(var_596_17[iter_596_20])
				end
				
				if var_596_20 > 0 then
					table.insert(var_596_19, {
						token = iter_596_20,
						count = var_596_20
					})
				end
			end
		end
		
		for iter_596_22, iter_596_23 in pairs(var_596_1) do
			table.insert(var_596_19, {
				equip = iter_596_23
			})
		end
		
		for iter_596_24, iter_596_25 in pairs(var_596_0) do
			if iter_596_25.diff then
				table.insert(var_596_19, {
					item = iter_596_25,
					count = iter_596_25.diff
				})
			end
		end
		
		for iter_596_26, iter_596_27 in pairs(var_596_2) do
			table.insert(var_596_19, {
				unit = iter_596_27
			})
		end
		
		for iter_596_28, iter_596_29 in pairs(var_596_3) do
			table.insert(var_596_19, {
				pet = iter_596_29
			})
		end
		
		for iter_596_30, iter_596_31 in pairs(arg_596_1.account_skills or {}) do
			table.insert(var_596_19, {
				account_skill = iter_596_31.skill_id .. "_" .. iter_596_31.level
			})
		end
		
		for iter_596_32, iter_596_33 in pairs(arg_596_1.promotion_list or {}) do
			if iter_596_33.isp then
				table.insert(var_596_19, {
					count = 1,
					code = iter_596_33.isp.id
				})
				
				var_596_6 = var_596_6 + 1
			end
		end
		
		local var_596_21 = 4
		
		local function var_596_22(arg_597_0)
			if var_596_19[1] and var_596_19[1].unit and var_596_19[1].unit:getGrade() >= var_596_21 then
				arg_596_2.is_new = false
				
				for iter_597_0, iter_597_1 in pairs(var_596_7.new_units) do
					if var_596_19[1].unit.db.code == iter_597_1.code then
						arg_596_2.is_new = true
					end
				end
				
				for iter_597_2, iter_597_3 in pairs(var_596_5) do
					if iter_597_3.unit_code == var_596_19[1].unit.db.code then
						arg_596_2.dupl_token = iter_597_3
						
						break
					end
				end
				
				if (arg_596_2.is_new or arg_597_0) and var_596_19[1].unit.db.role ~= "material" then
					if var_596_19[1].unit.db.type == "summon" then
						UnitSummonResult:ShowCharGet(var_596_19[1].unit.db.code, nil, nil, {
							is_new = true,
							is_summon = true
						})
					else
						UnitSummonResult:showResultOnly(var_596_19[1].unit.db.code, arg_596_2.parent, nil, arg_596_2)
					end
				else
					Dialog:ShowRareDrop(var_596_19[1], {
						parent = arg_596_2.parent
					})
				end
			else
				Dialog:ShowRareDrop(var_596_19[1], {
					parent = arg_596_2.parent
				})
			end
		end
		
		local function var_596_23()
			local var_598_0 = {}
			
			for iter_598_0, iter_598_1 in pairs(var_596_7.new_pets) do
				if var_596_19[1].pet and var_596_19[1].pet.db.code == iter_598_1.code then
					var_598_0.is_new = true
				end
			end
			
			var_598_0.show_no_btn = true
			
			GachaPet:showRewardResult(var_596_19[1].pet, var_598_0)
		end
		
		local var_596_24
		
		if arg_596_2.force_character_effect_handler and #var_596_19 == 1 and #var_596_2 > 0 then
			arg_596_2.handler = var_596_22
		end
		
		if arg_596_2.force_character_effect and #var_596_19 == 1 and #var_596_2 > 0 then
			var_596_22(arg_596_2.force_show_effect)
			
			var_596_24 = true
		end
		
		if arg_596_2.single and #var_596_19 == 1 and not var_596_24 then
			local var_596_25 = var_596_19[1]
			local var_596_26 = var_596_25 and var_596_25.unit
			local var_596_27 = var_596_25 and var_596_25.pet
			local var_596_28 = var_596_25 and var_596_25.equip
			
			if var_596_7.is_randombox and not arg_596_2.no_randombox_eff and var_596_26 and var_596_21 <= var_596_25.unit:getGrade() then
				arg_596_2.is_new = false
				
				for iter_596_34, iter_596_35 in pairs(var_596_7.new_units) do
					if iter_596_35.code == var_596_25.unit.db.code then
						arg_596_2.is_new = true
					end
				end
				
				for iter_596_36, iter_596_37 in pairs(var_596_5) do
					if iter_596_37.unit_code == var_596_25.unit.db.code then
						arg_596_2.dupl_token = iter_596_37
						
						break
					end
				end
				
				UnitSummonResult:showResultOnly(var_596_25.unit.db.code, arg_596_2.parent, nil, arg_596_2)
			elseif var_596_27 then
				var_596_23()
			elseif var_596_28 then
				GetItemPopup:show(var_596_25.equip)
			else
				Dialog:ShowRareDrop(var_596_25, {
					parent = arg_596_2.parent,
					use_drop_icon = arg_596_2.use_drop_icon
				})
			end
			
			if var_596_6 > 0 then
				Dialog:msgBox(T("gachafree_get_lobby_move_desc"), {
					handler = function()
						SceneManager:nextScene("lobby")
					end
				})
			end
		elseif arg_596_2.play_reward_data and not var_596_24 then
			local var_596_29 = arg_596_2.play_reward_data
			
			if #var_596_19 > 0 then
				local var_596_30 = {
					dlg = arg_596_2.dlg,
					handler = arg_596_2.handler,
					title = var_596_29.title,
					rewards = var_596_19,
					delay = var_596_29.delay,
					dont_proc_tutorial = var_596_29.dont_proc_tutorial,
					open_effect = var_596_29.open_effect
				}
				
				if #var_596_5 > 0 then
					function var_596_30.handler()
						Account:addRewardCoinPopup(var_596_5, {
							handler = arg_596_2.handler
						})
					end
				elseif var_596_6 > 0 then
					function var_596_30.handler()
						Dialog:msgBox(T("gachafree_get_lobby_move_desc"), {
							handler = function()
								SceneManager:nextScene("lobby")
							end
						})
					end
				end
				
				for iter_596_38, iter_596_39 in pairs(arg_596_2) do
					if string.starts(iter_596_38, "txt_") then
						var_596_30[iter_596_38] = iter_596_39
					end
				end
				
				if arg_596_2.is_no_reward_popup then
					var_596_30.desc = var_596_29.desc
					var_596_7.data_for_rewards_dlg = var_596_30
					var_596_7.re_popup = var_596_19
				else
					var_596_7.reward_dlg = Dialog:msgRewards(var_596_29.desc, var_596_30)
				end
			end
		end
	end
	
	TopBarNew:topbarUpdate(true)
	
	if #var_596_2 > 0 and HeroBelt:isValid() then
		HeroBelt:resetData(Account:getUnits())
	end
	
	ItemEventSender:dispatchEvent()
	
	return var_596_7
end

function Account.addRewardCoinPopup(arg_603_0, arg_603_1, arg_603_2)
	arg_603_2 = arg_603_2 or {}
	
	if not arg_603_1 or #arg_603_1 < 1 then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(200), CALL(Account.addRewardCoinPopupMsgBox, arg_603_0, arg_603_1, arg_603_2.handler)), arg_603_0, "block")
end

function Account.addRewardCoinPopupMsgBox(arg_604_0, arg_604_1, arg_604_2)
	if not arg_604_1 or #arg_604_1 < 1 then
		return 
	end
	
	local var_604_0 = load_dlg("token_acquisition_popup", true, "wnd")
	local var_604_1 = var_604_0:getChildByName("scrollview")
	local var_604_2 = ItemListView_v2:bindControl(var_604_1)
	local var_604_3 = load_control("wnd/token_acquisition_item.csb")
	
	if var_604_1.STRETCH_INFO then
		local var_604_4 = var_604_1:getContentSize()
		
		resetControlPosAndSize(var_604_3, var_604_4.width, var_604_1.STRETCH_INFO.width_prev)
	end
	
	local var_604_5 = {
		onUpdate = function(arg_605_0, arg_605_1, arg_605_2, arg_605_3)
			local var_605_0 = {
				base_grade = true,
				name = false,
				no_lv = true,
				no_role = true,
				no_popup = true,
				parent = arg_605_1:getChildByName("n_face")
			}
			local var_605_1 = UNIT:create({
				code = arg_605_3.unit_code
			})
			
			UIUtil:getUserIcon(var_605_1, var_605_0)
			UIUserData:call(arg_605_1:getChildByName("t_name_info"), "MULTI_SCALE_LONG_WORD()")
			if_set(arg_605_1, "t_name_info", T("popup_token_hero"))
			UIUserData:call(arg_605_1:getChildByName("t_name"), "MULTI_SCALE_LONG_WORD()")
			if_set(arg_605_1, "t_name", var_605_1:getName())
			
			local var_605_2 = arg_605_3.code
			
			if string.starts(var_605_2, "to_") then
				var_605_2 = string.sub(var_605_2, 4, -1)
			end
			
			UIUtil:getRewardIcon(arg_605_3.count, "to_" .. var_605_2, {
				parent = arg_605_1:getChildByName("n_reward_item")
			})
			
			return arg_605_2
		end
	}
	
	var_604_2:setRenderer(var_604_3, var_604_5)
	var_604_2:removeAllChildren()
	var_604_2:setDataSource(arg_604_1 or {})
	
	local var_604_6 = {}
	
	for iter_604_0, iter_604_1 in pairs(arg_604_1) do
		if not var_604_6[iter_604_1.code] then
			local var_604_7 = iter_604_1.code
			
			if string.starts(var_604_7, "to_") then
				var_604_7 = string.sub(var_604_7, 4, -1)
			end
			
			local var_604_8 = DB("item_token", "to_" .. var_604_7, {
				"name"
			})
			
			var_604_6[iter_604_1.code] = T(var_604_8)
		end
	end
	
	local var_604_9 = ""
	
	if var_604_6.rarecoin and var_604_6.mooncoin then
		var_604_9 = var_604_6.rarecoin .. ", " .. var_604_6.mooncoin
	elseif var_604_6.rarecoin then
		var_604_9 = var_604_6.rarecoin
	elseif var_604_6.mooncoin then
		var_604_9 = var_604_6.mooncoin
	end
	
	if_set(var_604_0, "txt_disc", T("popup_token_desc", {
		item = var_604_9
	}))
	
	local var_604_10 = {
		dlg = var_604_0,
		handler = arg_604_2
	}
	
	Dialog:msgBox(T("popup_token_title"), var_604_10)
end

function Account.getGachaShopInfo(arg_606_0)
	return AccountData.gacha_shop_info
end

function Account.getGachaRandList(arg_607_0)
	return AccountData.gacha_rand_list
end

function Account.updateGachaShopFreeInfo(arg_608_0, arg_608_1)
	if not AccountData.gacha_shop_info then
		return 
	end
	
	if not AccountData.gacha_shop_info.free_ticket then
		return 
	end
	
	AccountData.gacha_shop_info.free_ticket[arg_608_1.id] = arg_608_1
end

function Account.updatePickupCeilingData(arg_609_0, arg_609_1)
	if AccountData.gacha_shop_info and arg_609_1 then
		if AccountData.gacha_shop_info.pickup_ceiling == nil then
			AccountData.gacha_shop_info.pickup_ceiling = {}
		end
		
		for iter_609_0, iter_609_1 in pairs(arg_609_1) do
			AccountData.gacha_shop_info.pickup_ceiling[iter_609_0] = iter_609_1
		end
	end
end

function Account.getCurrentPetGachaId(arg_610_0)
	local var_610_0 = AccountData.pet_gacha_schedules
	local var_610_1 = os.time()
	local var_610_2
	local var_610_3
	
	for iter_610_0, iter_610_1 in pairs(var_610_0) do
		if iter_610_1.start_time and var_610_1 >= iter_610_1.start_time and (var_610_3 == nil or var_610_3 < iter_610_1.start_time) then
			var_610_3 = iter_610_1.start_time
			var_610_2 = iter_610_0
		end
	end
	
	return var_610_2
end

function Account.setWorldmapRwards(arg_611_0, arg_611_1, arg_611_2)
	if not AccountData.worldmap_rewards then
		return 
	end
	
	AccountData.worldmap_rewards[arg_611_1] = arg_611_2
end

function Account.getWorldmapReward(arg_612_0, arg_612_1)
	if not AccountData.worldmap_rewards then
		return 
	end
	
	return AccountData.worldmap_rewards[arg_612_1]
end

function Account.getTutorialState(arg_613_0, arg_613_1)
	if AccountData then
		local var_613_0 = SubstoryManager:getInfo()
		
		if var_613_0 then
			local var_613_1 = arg_613_0:getSubStoryTutorialState(var_613_0.id, arg_613_1)
			
			if var_613_1 then
				return var_613_1
			end
		end
		
		AccountData.tutorial_list = AccountData.tutorial_list or {}
		
		return AccountData.tutorial_list[arg_613_1]
	end
end

function Account.getSubStoryTutorialState(arg_614_0, arg_614_1, arg_614_2)
	if not AccountData.substory_tutorial_list then
		return nil
	end
	
	if not AccountData.substory_tutorial_list[arg_614_1] then
		return nil
	end
	
	return AccountData.substory_tutorial_list[arg_614_1][arg_614_2]
end

function Account.saveTutorialState(arg_615_0, arg_615_1, arg_615_2)
	if AccountData then
		AccountData.tutorial_list = AccountData.tutorial_list or {}
		
		if AccountData.tutorial_list[arg_615_1] ~= arg_615_2 then
			AccountData.tutorial_list[arg_615_1] = arg_615_2
		end
	end
end

function Account.setSubStoryTutorials(arg_616_0, arg_616_1, arg_616_2)
	if not AccountData.substory_tutorial_list then
		AccountData.substory_tutorial_list = {}
	end
	
	AccountData.substory_tutorial_list[arg_616_1] = arg_616_2
end

function Account.setSubStoryTutorialState(arg_617_0, arg_617_1, arg_617_2, arg_617_3)
	if not AccountData.substory_tutorial_list then
		AccountData.substory_tutorial_list = {}
	end
	
	if not AccountData.substory_tutorial_list[arg_617_1] then
		AccountData.substory_tutorial_list[arg_617_1] = {}
	end
	
	if AccountData.substory_tutorial_list[arg_617_1][arg_617_2] ~= arg_617_3 then
		AccountData.substory_tutorial_list[arg_617_1][arg_617_2] = arg_617_3
	end
end

function Account.isRequestSubStoryTutorials(arg_618_0, arg_618_1)
	if not AccountData.substory_tutorial_list then
		return true
	end
	
	if not AccountData.substory_tutorial_list[arg_618_1] then
		return true
	end
	
	return false
end

function Account.getSameUnitCount(arg_619_0, arg_619_1)
	local var_619_0 = 0
	
	for iter_619_0, iter_619_1 in pairs(arg_619_0.units) do
		if arg_619_1:isDevotionUpgradable(iter_619_1) then
			var_619_0 = var_619_0 + 1
		end
	end
	
	return var_619_0
end

function Account.procHPInfos(arg_620_0, arg_620_1)
	for iter_620_0, iter_620_1 in pairs(arg_620_1) do
		local var_620_0 = arg_620_0:getUnit(iter_620_1.id)
		
		var_620_0:updateHPInfo(iter_620_1)
		var_620_0:reset()
	end
end

function Account.getActiveQuestID(arg_621_0)
	if SubstoryManager:getInfo() then
		local var_621_0 = SubstoryManager:getCurrentQuestData()
		
		if var_621_0 then
			return var_621_0.id
		end
	else
		return ConditionContentsManager:getQuestMissions():getCurrentQuestId()
	end
	
	return nil
end

function Account.getSupportNpcs(arg_622_0, arg_622_1)
	local var_622_0 = DB("level_enter", arg_622_1, "substory_contents_id")
	
	if var_622_0 then
		local var_622_1 = SubstoryManager:getCurrentQuestData(var_622_0)
		
		if var_622_1 and SubstoryManager:isApplyQuestInBattle(var_622_1.id) then
			local var_622_2, var_622_3, var_622_4, var_622_5, var_622_6, var_622_7, var_622_8, var_622_9, var_622_10, var_622_11 = DB("substory_quest", var_622_1.id, {
				"area_enter_id",
				"supporter_1",
				"grade_s1",
				"level_s1",
				"supporter_2",
				"grade_s2",
				"level_s2",
				"supporter_3",
				"grade_s3",
				"level_s3"
			})
			
			if var_622_2 and var_622_2 == arg_622_1 and (var_622_3 or var_622_6 or var_622_9) then
				return {
					{
						code = var_622_3,
						g = var_622_4,
						lv = var_622_5
					},
					{
						code = var_622_6,
						g = var_622_7,
						lv = var_622_8
					},
					{
						code = var_622_9,
						g = var_622_10,
						lv = var_622_11
					}
				}
			end
		end
	else
		local var_622_12 = ConditionContentsManager:getQuestMissions():getCurrentQuestId()
		local var_622_13, var_622_14, var_622_15, var_622_16, var_622_17, var_622_18, var_622_19, var_622_20, var_622_21, var_622_22 = DB("mission_data", var_622_12, {
			"area_enter_id",
			"supporter_1",
			"grade_s1",
			"level_s1",
			"supporter_2",
			"grade_s2",
			"level_s2",
			"supporter_3",
			"grade_s3",
			"level_s3"
		})
		
		if var_622_13 and var_622_13 == arg_622_1 and (var_622_14 or var_622_17 or var_622_20) then
			return {
				{
					code = var_622_14,
					g = var_622_15,
					lv = var_622_16
				},
				{
					code = var_622_17,
					g = var_622_18,
					lv = var_622_19
				},
				{
					code = var_622_20,
					g = var_622_21,
					lv = var_622_22
				}
			}
		end
	end
	
	return nil
end

function Account.canUseUserSupport(arg_623_0, arg_623_1)
	arg_623_1 = arg_623_1 or arg_623_0.vars.enter_id
	
	local var_623_0 = DB("level_enter", arg_623_1, "substory_contents_id")
	
	if var_623_0 then
		local var_623_1 = SubstoryManager:getCurrentQuestData(var_623_0)
		
		if var_623_1 then
			local var_623_2, var_623_3 = DB("substory_quest", var_623_1.id, {
				"area_enter_id",
				"user_supporter"
			})
			
			if var_623_2 ~= arg_623_1 then
				return true
			end
			
			return var_623_3 == "y"
		end
	else
		local var_623_4 = ConditionContentsManager:getQuestMissions():getCurrentQuestId()
		local var_623_5, var_623_6 = DB("mission_data", var_623_4, {
			"area_enter_id",
			"user_supporter"
		})
		
		if var_623_5 ~= arg_623_1 then
			return true
		end
		
		return var_623_6 == "y"
	end
end

function Account.getActiveQuestDataInBattle(arg_624_0, arg_624_1, arg_624_2)
	arg_624_2 = arg_624_2 or {}
	
	if not arg_624_1 then
		return nil
	end
	
	local var_624_0 = false
	local var_624_1
	local var_624_2
	local var_624_3 = DB("level_enter", arg_624_1, "substory_contents_id")
	
	if var_624_3 then
		local var_624_4 = ConditionContentsManager:getSubStoryQuest()
		local var_624_5 = SubstoryManager:getCurrentQuestData(var_624_3)
		
		if var_624_5 and var_624_5.area_enter_id == arg_624_1 and SubstoryManager:isApplyQuestInBattle(var_624_5.id) then
			var_624_0 = true
			var_624_1 = var_624_5.id
			
			if arg_624_2.ui_datas then
				var_624_2 = {}
				var_624_2.title, var_624_2.desc, var_624_2.condition_value = DB("substory_quest", var_624_1, {
					"desc",
					"name",
					"value"
				})
				
				local var_624_6 = {
					count = 1
				}
				
				merge_table(totable(var_624_2.condition_value), var_624_6)
				
				var_624_2.max = var_624_6.count
				var_624_2.score = var_624_4:getScore(var_624_1)
				
				if tonumber(var_624_6.count) == 1 then
					var_624_2 = nil
				end
			end
		end
	else
		local var_624_7 = ConditionContentsManager:getQuestMissions()
		local var_624_8 = var_624_7:getActiveQuestInBattle(arg_624_1)
		
		if var_624_8 and var_624_8.state == "active" then
			var_624_0 = true
			var_624_1 = var_624_7:getCurrentQuestId()
			
			if arg_624_2.ui_datas then
				var_624_2 = {}
				var_624_2.title, var_624_2.desc, var_624_2.condition_value = DB("mission_data", var_624_1, {
					"desc",
					"name",
					"value"
				})
				
				local var_624_9 = {
					count = 1
				}
				
				merge_table(totable(var_624_2.condition_value), var_624_9)
				
				var_624_2.max = var_624_9.count
				var_624_2.score = var_624_7:getScore(var_624_1)
				
				if tonumber(var_624_9.count) == 1 then
					var_624_2 = nil
				end
			end
		end
	end
	
	return var_624_0, var_624_1, var_624_2
end

function Account.onUpdate(arg_625_0)
	arg_625_0:updateEatingUnits()
end

function Account.updateEatingUnits(arg_626_0)
	if SceneManager:getCurrentSceneName() == "battle" and not Battle:isEnded() then
		return 
	end
	
	local var_626_0 = {}
	
	for iter_626_0, iter_626_1 in pairs(arg_626_0.healing_units) do
		local var_626_1 = iter_626_0:getRestEatingEndTime()
		
		if not iter_626_0:isBlockedUpdateEating() and var_626_1 == 0 then
			iter_626_0:doneEating()
			table.push(var_626_0, iter_626_0)
		end
	end
	
	if #var_626_0 > 0 then
		arg_626_0:updateUnitHPs(var_626_0)
	end
end

function Account.setRandomShoplevel(arg_627_0, arg_627_1)
	AccountData.rshop_level = arg_627_1
end

function Account.getRandomShoplevel(arg_628_0)
	return AccountData.rshop_level or 1
end

function Account.checkMiner(arg_629_0)
	return AccountData.miner
end

function Account.checkNameChanged(arg_630_0)
	local var_630_0 = arg_630_0:getName(true)
	
	return var_630_0 and not string.starts(var_630_0, "epic7#") and not string.starts(var_630_0, "继承者#")
end

function Account.setClassChangeInfo(arg_631_0, arg_631_1)
	AccountData.cc_list = arg_631_1
end

function Account.mergeClassChangeInfo(arg_632_0, arg_632_1, arg_632_2)
	AccountData.cc_list[arg_632_1] = arg_632_2
end

function Account.getClassChangeInfo(arg_633_0)
	return AccountData.cc_list or {}
end

function Account.getClassChangeInfoByCode(arg_634_0, arg_634_1)
	return arg_634_0:getClassChangeInfo()[arg_634_1] or {}
end

function Account.getClassChangeQuests(arg_635_0)
	return AccountData.class_change_quests or {}
end

function Account.getClassChangeQuest(arg_636_0, arg_636_1)
	return Account:getClassChangeQuests()[arg_636_1] or {
		state = 0
	}
end

function Account.setClassChangeQuest(arg_637_0, arg_637_1, arg_637_2)
	if not arg_637_1 then
		return 
	end
	
	if not arg_637_2 then
		return 
	end
	
	if not AccountData.class_change_quests then
		AccountData.class_change_quests = {}
	end
	
	AccountData.class_change_quests[arg_637_1] = arg_637_2
end

function Account.getPvpClanCurrentSchedule(arg_638_0)
	local var_638_0 = arg_638_0:getPvpClanSchedule()
	
	if not var_638_0 or not var_638_0.current then
		return nil
	end
	
	return var_638_0.current.schedule
end

function Account.getCurrentWarId(arg_639_0)
	local var_639_0 = arg_639_0:getPvpClanSchedule()
	
	if not var_639_0 then
		return nil
	end
	
	local var_639_1 = Account:serverTimeDayLocalDetail()
	
	return var_639_0.current.schedule[tostring(var_639_1)].war_id
end

function Account.getCurrentWarUId(arg_640_0)
	local var_640_0 = arg_640_0:getPvpClanSchedule()
	
	if not var_640_0 then
		return nil
	end
	
	local var_640_1 = Account:serverTimeDayLocalDetail()
	
	return var_640_0.current.schedule[tostring(var_640_1)].war_uid
end

function Account.getCurrentWarSeasonInfo(arg_641_0)
	local var_641_0 = arg_641_0:getPvpClanSchedule()
	
	if not var_641_0 or not var_641_0.season or not arg_641_0:getCurrentWarUId() then
		return nil
	end
	
	local var_641_1 = arg_641_0:getCurrentWarUId() or 0
	
	return var_641_0.season[tostring(var_641_1)] or nil
end

function Account.getPrevWarSeasonInfo(arg_642_0)
	local var_642_0 = arg_642_0:getPvpClanSchedule()
	
	if not var_642_0 or not var_642_0.season or not arg_642_0:getCurrentWarUId() then
		return nil
	end
	
	local var_642_1 = (arg_642_0:getCurrentWarUId() or 0) - 1
	
	return var_642_0.season[tostring(var_642_1)] or nil
end

function Account.getPrevRegularWarSeasonInfo(arg_643_0)
	local var_643_0 = arg_643_0:getPvpClanSchedule()
	
	if not var_643_0 or not var_643_0.season or not arg_643_0:getCurrentWarUId() then
		return nil
	end
	
	local var_643_1 = arg_643_0:getCurrentWarUId() or 0
	local var_643_2
	
	for iter_643_0 = 1, 99999999 do
		local var_643_3, var_643_4, var_643_5, var_643_6 = DBN("clan_war", iter_643_0, {
			"id",
			"uid",
			"season_type",
			"previous_regular_uid"
		})
		
		if not var_643_3 then
			break
		end
		
		if var_643_1 == var_643_4 then
			if var_643_5 == "regular" then
				var_643_2 = var_643_6
				
				break
			end
			
			if var_643_5 == "free" then
				var_643_2 = var_643_1 - 1
			end
			
			break
		end
	end
	
	if not var_643_2 then
		return nil
	end
	
	return var_643_0.season[tostring(var_643_2)] or nil
end

function Account.getWarSeasonInfo(arg_644_0, arg_644_1)
	local var_644_0 = arg_644_0:getPvpClanSchedule()
	
	if not var_644_0 or not var_644_0.season then
		return nil
	end
	
	return var_644_0.season[tostring(arg_644_1)] or nil
end

function Account.getPvpScheduleToDay(arg_645_0)
	local var_645_0 = Account:serverTimeDayLocalDetail()
	local var_645_1 = Account:getPvpClanCurrentSchedule()
	
	if not var_645_1 then
		return 
	end
	
	return var_645_1[tostring(var_645_0)]
end

function Account.getPrevWarDayId(arg_646_0, arg_646_1)
	arg_646_1 = arg_646_1 or Account:getPvpScheduleToDay().war_day_id
	
	local var_646_0 = arg_646_0:getPvpClanCurrentSchedule()
	local var_646_1
	local var_646_2
	
	for iter_646_0, iter_646_1 in pairs(var_646_0) do
		if tonumber(iter_646_1.war_day_id) == tonumber(arg_646_1) then
			var_646_1 = iter_646_0
			
			break
		end
	end
	
	if not var_646_1 then
		return nil, 0, 0
	end
	
	for iter_646_2 = 1, 7 do
		if tonumber(var_646_0[tostring(tonumber(var_646_1) - iter_646_2)].war_day_id) < tonumber(arg_646_1) then
			var_646_2 = tonumber(var_646_0[tostring(tonumber(var_646_1) - iter_646_2)].war_day_id)
			
			break
		end
	end
	
	return var_646_2
end

function Account.getEventBoosters(arg_647_0)
	return AccountData.event_boosters
end

function Account.setEventBoosters(arg_648_0, arg_648_1)
	AccountData.event_boosters = arg_648_1
end

function Account.getBorderCode(arg_649_0)
	return AccountData.border_code or "ma_border1"
end

function Account.setBorderCode(arg_650_0, arg_650_1)
	AccountData.border_code = arg_650_1 or "ma_border1"
end

function Account.setBorderList(arg_651_0, arg_651_1)
	SAVE:set("game.border_list", json.encode(arg_651_1 or {}))
end

function Account.getBorderList(arg_652_0)
	local var_652_0 = SAVE:get("game.border_list")
	
	if not var_652_0 then
		local var_652_1 = {}
		
		for iter_652_0, iter_652_1 in pairs(arg_652_0.items) do
			local var_652_2 = DB("item_material", iter_652_0, "ma_type")
			
			if iter_652_1 > 0 and var_652_2 == "border" then
				table.insert(var_652_1, iter_652_0)
			end
		end
		
		arg_652_0:setBorderList(var_652_1)
		
		return var_652_1
	end
	
	return json.decode(var_652_0)
end

function Account.getMaxPvpLeague(arg_653_0)
	return AccountData.max_pvp_league
end

function Account.getCurrentBorderList(arg_654_0)
	local var_654_0 = {}
	
	for iter_654_0, iter_654_1 in pairs(arg_654_0.items) do
		local var_654_1 = DB("item_material", iter_654_0, "ma_type")
		
		if iter_654_1 > 0 and var_654_1 == "border" then
			table.insert(var_654_0, iter_654_0)
		end
	end
	
	return var_654_0
end

function Account.checkNewBorder(arg_655_0)
	local var_655_0 = arg_655_0:getBorderList()
	local var_655_1 = arg_655_0:getCurrentBorderList()
	
	if #var_655_0 ~= #var_655_1 then
		return true
	end
	
	return false
end

function Account.setChapterShopEpisodeItems(arg_656_0, arg_656_1, arg_656_2)
	if not AccountData.shop_chapter_items then
		AccountData.shop_chapter_items = {}
	end
	
	AccountData.shop_chapter_items[tostring(arg_656_1)] = arg_656_2
end

function Account.getChapterShopItems(arg_657_0, arg_657_1, arg_657_2)
	if not AccountData.shop_chapter_items then
		return {}
	end
	
	if not AccountData.shop_chapter_items[tostring(arg_657_1)] then
		return {}
	end
	
	if not AccountData.shop_chapter_items[tostring(arg_657_1)][arg_657_2] then
		return {}
	end
	
	return AccountData.shop_chapter_items[tostring(arg_657_1)][arg_657_2]
end

function Account.getChapterShopItemsByWorldID(arg_658_0, arg_658_1)
	if not AccountData.shop_chapter_items then
		return {}
	end
	
	if not AccountData.shop_chapter_items[tostring(arg_658_1)] then
		return {}
	end
	
	return AccountData.shop_chapter_items[tostring(arg_658_1)]
end

function Account.isStartChapterShopQuest(arg_659_0, arg_659_1)
	local var_659_0 = arg_659_0:getShopChapters()[arg_659_1]
	
	if var_659_0 and (var_659_0.quest_state or -1) >= 0 then
		return true
	end
	
	return false
end

function Account.isPlayingChapterShopQuest(arg_660_0, arg_660_1)
	local var_660_0 = arg_660_0:getShopChapters()[arg_660_1]
	
	if var_660_0 and (var_660_0.quest_state or -1) == 0 then
		return true
	end
	
	return false
end

function Account.isClearedChapterShopQuest(arg_661_0, arg_661_1)
	local var_661_0 = arg_661_0:getShopChapters()[arg_661_1]
	
	if var_661_0 and (var_661_0.quest_state or -1) >= 1 then
		return true
	end
	
	return false
end

function Account.isClearedChapterShopStory(arg_662_0, arg_662_1)
	return arg_662_0:isClearedChapterShopQuest(arg_662_1)
end

function Account.getChapterShopQuests(arg_663_0)
	return AccountData.chapter_shop_quests
end

function Account.getChapterShopQuest(arg_664_0, arg_664_1)
	local var_664_0 = arg_664_0:getChapterShopQuests()
	
	if not var_664_0 then
		return {}
	end
	
	return var_664_0[arg_664_1] or {
		state = CHAPTER_SHOP_QUEST.ACTIVE
	}
end

function Account.setChapterShopQuest(arg_665_0, arg_665_1, arg_665_2)
	if not arg_665_1 then
		return 
	end
	
	if not arg_665_2 then
		return 
	end
	
	AccountData.chapter_shop_quests[arg_665_1] = arg_665_2
end

function Account.setShopChapters(arg_666_0, arg_666_1)
	AccountData.shop_chapters = arg_666_1
end

function Account.setShopChapter(arg_667_0, arg_667_1)
	if not arg_667_1 then
		return 
	end
	
	if not arg_667_1.category_id then
		return 
	end
	
	AccountData.shop_chapters[arg_667_1.category_id] = arg_667_1
end

function Account.getShopChapters(arg_668_0)
	return AccountData.shop_chapters
end

function Account.getShopChapterInfo(arg_669_0, arg_669_1)
	local var_669_0 = arg_669_0:getShopChapters()
	
	if not var_669_0 then
		return 
	end
	
	return var_669_0[arg_669_1]
end

function Account.getShopChatperByID(arg_670_0, arg_670_1)
	return (arg_670_0:getShopChapters() or {})[arg_670_1] or {}
end

function Account.getGrowthGuideQuests(arg_671_0)
	return AccountData.growth_guide_quests
end

function Account.getGrowthGuideQuest(arg_672_0, arg_672_1)
	return arg_672_0:getGrowthGuideQuests()[arg_672_1] or {
		state = GROWTH_GUIDE_QUEST.ACTIVE
	}
end

function Account.setGrowthGuideQuest(arg_673_0, arg_673_1, arg_673_2)
	if not arg_673_1 then
		return 
	end
	
	if not arg_673_2 then
		return 
	end
	
	AccountData.growth_guide_quests[arg_673_1] = arg_673_2
end

function Account.getGrowthGuideGroups(arg_674_0)
	return AccountData.growth_guide_groups
end

function Account.getGrowthGuideGroup(arg_675_0, arg_675_1)
	return arg_675_0:getGrowthGuideGroups()[arg_675_1] or {
		state = 0
	}
end

function Account.setGrowthGuideGroup(arg_676_0, arg_676_1, arg_676_2)
	if not arg_676_1 then
		return 
	end
	
	if not arg_676_2 then
		return 
	end
	
	AccountData.growth_guide_groups[arg_676_1] = arg_676_2
end

function Account.setClanBuffInfos(arg_677_0, arg_677_1)
	AccountData.clan_buffs = arg_677_1
end

function Account.updateBuffInfo(arg_678_0, arg_678_1)
	if not AccountData.clan_buffs then
		AccountData.clan_buffs = {}
	end
	
	AccountData.clan_buffs[arg_678_1.skill_id] = arg_678_1
end

function Account.getClanBuffs(arg_679_0)
	return AccountData.clan_buffs or {}
end

function Account.getActiveClanBuffs(arg_680_0)
	local var_680_0 = AccountData.clan_buffs or {}
	local var_680_1 = {}
	
	for iter_680_0, iter_680_1 in pairs(var_680_0) do
		if iter_680_1.expire_time and iter_680_1.expire_time > os.time() then
			var_680_1[iter_680_0] = iter_680_1
		end
	end
	
	return var_680_1
end

function Account.getSeasonPassSchedules(arg_681_0)
	return AccountData.season_pass_schedules or {}
end

function Account.getSubstoryPassInfo(arg_682_0)
	return AccountData.substory_pass_info
end

function Account.setSubstoryPassInfo(arg_683_0, arg_683_1)
	if not arg_683_1 then
		return 
	end
	
	for iter_683_0, iter_683_1 in pairs(arg_683_1) do
		AccountData.season_pass[iter_683_0] = iter_683_1
	end
end

function Account.getSubstoryPassData(arg_684_0)
	return AccountData.substory_pass_data
end

function Account.setSubstoryPassData(arg_685_0, arg_685_1)
	AccountData.substory_pass_data = arg_685_1
end

function Account.getTrialHallSchedules(arg_686_0)
	return AccountData.trial_hall_schedules
end

function Account.getTrialHallRankInfo(arg_687_0)
	return AccountData.trial_hall_rank
end

function Account.setTrialHallRankInfo(arg_688_0, arg_688_1)
	AccountData.trial_hall_rank = arg_688_1
end

function Account.getActiveTrialHall(arg_689_0)
	local var_689_0 = os.time()
	local var_689_1 = arg_689_0:getTrialHallSchedules()
	
	for iter_689_0, iter_689_1 in pairs(var_689_1 or {}) do
		if var_689_0 >= iter_689_1.start_time and var_689_0 < iter_689_1.end_time then
			return iter_689_1
		end
	end
	
	return {}
end

function Account.isRestTimeTrialHall(arg_690_0, arg_690_1)
	local var_690_0 = os.time()
	
	if arg_690_1.rest_start_time == nil or arg_690_1.rest_end_time == nil then
		return false, 0
	end
	
	if var_690_0 >= arg_690_1.rest_start_time and var_690_0 < arg_690_1.rest_end_time then
		return true, arg_690_1.rest_end_time - var_690_0
	end
	
	return false, 0
end

function Account.getTrialHall(arg_691_0, arg_691_1)
	return AccountData.trial_halls[arg_691_1]
end

function Account.setTrialHall(arg_692_0, arg_692_1, arg_692_2)
	AccountData.trial_halls[arg_692_1] = arg_692_2
end

function Account.countGachaTempInventory(arg_693_0)
	AccountData.gacha_temp_inventory = AccountData.gacha_temp_inventory or {}
	
	local var_693_0 = 0
	
	for iter_693_0, iter_693_1 in pairs(AccountData.gacha_temp_inventory) do
		var_693_0 = var_693_0 + to_n(iter_693_1)
	end
	
	return var_693_0
end

function Account.updateGachaTempInventory(arg_694_0, arg_694_1)
	if arg_694_1 then
		AccountData.gacha_temp_inventory = AccountData.gacha_temp_inventory or {}
		
		local var_694_0 = to_n(arg_694_1.count)
		
		if var_694_0 > 0 then
			AccountData.gacha_temp_inventory[arg_694_1.code] = var_694_0
		else
			AccountData.gacha_temp_inventory[arg_694_1.code] = nil
		end
	end
end

function Account.updateGachaTempInventories(arg_695_0, arg_695_1)
	if arg_695_1 then
		AccountData.gacha_temp_inventory = AccountData.gacha_temp_inventory or {}
		
		for iter_695_0, iter_695_1 in pairs(arg_695_1) do
			local var_695_0 = to_n(iter_695_1.count)
			
			if var_695_0 > 0 then
				AccountData.gacha_temp_inventory[iter_695_1.code] = var_695_0
			else
				AccountData.gacha_temp_inventory[iter_695_1.code] = nil
			end
		end
	end
end

function Account.isIncludeGachaTempInventory(arg_696_0, arg_696_1)
	AccountData.gacha_temp_inventory = AccountData.gacha_temp_inventory or {}
	
	return AccountData.gacha_temp_inventory[arg_696_1] ~= nil
end

function Account.isAlterDbRequired(arg_697_0)
	if not AccountData then
		return false
	end
	
	if to_n(AccountData.alter_db_content) == 1 then
		return true
	end
	
	return false
end

function Account.isAlterDbLoaded(arg_698_0)
	if arg_698_0:isAlterDbRequired() and AccountData.alter_db_loaded == true then
		return true
	end
	
	return false
end

function Account.setAlterDbLoaded(arg_699_0)
	if arg_699_0:isAlterDbRequired() then
		AccountData.alter_db_loaded = true
	end
end

function Account.isJPN(arg_700_0)
	return arg_700_0:isAlterDbLoaded()
end

function Account.setUnitSkin(arg_701_0, arg_701_1)
	if not arg_701_1 then
		return 
	end
	
	arg_701_0:getUnit(arg_701_1.unit_uid):changeSkin(arg_701_1.skin_code)
end

function Account.isPublishedSkin(arg_702_0, arg_702_1)
	local var_702_0 = (AccountData.char_skin_schedules or {})[arg_702_1]
	
	if var_702_0 then
		return var_702_0.start_time < os.time()
	end
	
	return true
end

function Account.getCurrentLobbyData(arg_703_0)
	local var_703_0
	
	if not AccountData.lobby_control then
		return var_703_0
	end
	
	for iter_703_0, iter_703_1 in pairs(AccountData.lobby_control) do
		local var_703_1 = os.time()
		
		if iter_703_1.start_time and iter_703_1.end_time and var_703_1 >= iter_703_1.start_time and var_703_1 <= iter_703_1.end_time then
			var_703_0 = iter_703_1
			
			break
		end
	end
	
	return var_703_0
end

function Account.clearIapResponses(arg_704_0)
	AccountData.iap_responses = nil
	
	if IS_PUBLISHER_ZLONG then
		query("zlong_iap_purchase_clear")
	else
		query("stove_iap_purchase_clear")
	end
end

function Account.checkIapResponses(arg_705_0)
	if AccountData.iap_responses and table.count(AccountData.iap_responses) > 0 then
		local var_705_0 = {}
		
		for iter_705_0, iter_705_1 in pairs(AccountData.iap_responses) do
			if iter_705_1 and iter_705_1.item then
				local var_705_1 = getIapProductInfo(iter_705_1.item)
				
				if var_705_1 and (var_705_1.localizedTitle or var_705_1.goods_name) then
					table.push(var_705_0, var_705_1.localizedTitle or var_705_1.goods_name)
					
					if IS_PUBLISHER_ZLONG then
						local var_705_2 = tonumber(var_705_1.goods_price or 0)
						
						Zlong:gameEventLog("AD_purchaseV2", json.encode({
							price = var_705_2,
							itemId = iter_705_1.item
						}))
					end
				end
			end
		end
		
		if table.count(var_705_0) > 0 then
			Dialog:msgBox(T("package_reward_restore", {
				name = string.join(var_705_0, ", ")
			}), {
				handler = function()
					Account:clearIapResponses()
				end
			})
			
			return true
		end
	end
	
	return nil
end

function Account.get_penguin_mileage(arg_707_0)
	return AccountData.p_mileage
end

function Account.set_penguin_mileage(arg_708_0, arg_708_1)
	if not arg_708_1 then
		return 
	end
	
	AccountData.p_mileage = arg_708_1
end

function Account.isUnlockArchemistExclusive(arg_709_0)
	local var_709_0 = DB("recipe_category", "alchemy_exclusive", "unlock_condition")
	local var_709_1 = (AccountData.sanc_lv or {})[5] or {}
	
	if not var_709_1 then
		return false
	end
	
	local var_709_2 = var_709_1[2] or 0
	local var_709_3 = string.split(var_709_0, "_")[3] or 999
	
	if var_709_2 >= tonumber(var_709_3) then
		return true
	end
	
	return false
end

function Account.isUnlockExtract(arg_710_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_EXTRACT) then
		return false
	end
	
	return true
end

function Account.isUnlockSubOptionChange(arg_711_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_SUB_CHANGE) then
		return false
	end
	
	return true
end

function Account.isUnlockTabEquipMaterials(arg_712_0)
	return Account:isUnlockExtract() or Account:isUnlockSubOptionChange()
end

function Account.setExclusiveShopNoti(arg_713_0, arg_713_1)
	AccountData.exclusiveShopNoti = arg_713_1
end

function Account.getExclusiveShopNoti(arg_714_0)
	return AccountData.exclusiveShopNoti
end

function Account.isHaveExclusive(arg_715_0)
	for iter_715_0, iter_715_1 in pairs(arg_715_0.equips) do
		if iter_715_1.isExclusive and iter_715_1:isExclusive() then
			return true
		end
	end
end

function Account.canUseExclusive(arg_716_0)
	if DEBUG.SKIP_TUTO then
		return true
	end
	
	if TutorialGuide:isClearedTutorial(UNLOCK_ID.EXCLUSIVE) or arg_716_0:isHaveExclusive() then
		return true
	end
	
	return false
end

function Account.setLastNotiTime_sancForest(arg_717_0, arg_717_1)
	AccountData.lastNotiTime_sancForest = arg_717_1
end

function Account.getLastNotiTime_sancForest(arg_718_0)
	if AccountData.lastNotiTime_sancForest then
		return AccountData.lastNotiTime_sancForest
	end
	
	return false
end

function Account.setForestState(arg_719_0, arg_719_1)
	AccountData.sanc_forest = arg_719_1
end

function Account.setForestStateUseCode(arg_720_0, arg_720_1, arg_720_2)
	AccountData.sanc_forest[arg_720_1] = arg_720_2
end

function Account.getForestState(arg_721_0)
	return AccountData.sanc_forest
end

function Account.getFriendSentCount(arg_722_0)
	return AccountData.friend_sent_count
end

function Account.getFriendCount(arg_723_0)
	return AccountData.friend_count
end

function Account.getCoopMissionData(arg_724_0)
	if AccountData.coop_mission and not AccountData.coop_mission.open_lists then
		AccountData.coop_mission.open_lists = {}
	end
	
	return AccountData.coop_mission
end

function Account.getCoopListByType(arg_725_0, arg_725_1, arg_725_2)
	if not AccountData.coop_mission then
		local var_725_0 = {}
	end
	
	local var_725_1
	local var_725_2 = arg_725_2 or 1
	
	if arg_725_1 == "share" then
		var_725_1 = AccountData.coop_mission.invite_list or {}
	elseif arg_725_1 == "hand" then
		var_725_1 = AccountData.coop_mission.my_lists or {}
	elseif arg_725_1 == "open" then
		var_725_1 = (AccountData.coop_mission.open_lists or {})[var_725_2] or {}
	elseif arg_725_1 == "list" then
		var_725_1 = AccountData.coop_mission.mission_list or {}
	end
	
	return var_725_1 or {}
end

function Account.getTicketList(arg_726_0)
	local var_726_0 = arg_726_0:getCoopMissionData()
	
	if not var_726_0 then
		return 
	end
	
	return var_726_0.ticket_list
end

function Account.getCoopMissionSchedule(arg_727_0)
	local var_727_0 = arg_727_0:getCoopMissionData()
	
	if not var_727_0 or not var_727_0.coop_mission_schedule then
		return AccountData.coop_mission.coop_mission_next_schedule or nil
	end
	
	return var_727_0.coop_mission_schedule
end

function Account.getCoopMissionRemainTime(arg_728_0)
	print("getCoopMissionRemainTime?")
	
	local var_728_0 = arg_728_0:getCoopMissionData()
	
	if table.empty(var_728_0) or table.empty(var_728_0.coop_mission_schedule) then
		return nil
	end
	
	local var_728_1 = var_728_0.coop_mission_schedule.end_time
	
	if not var_728_1 then
		return nil
	end
	
	local var_728_2 = var_728_1 - os.time()
	
	if var_728_2 < 60 then
		return T("remain_min", {
			min = 0
		})
	end
	
	return sec_to_string(var_728_2)
end

function Account.getCoopMissionBosses(arg_729_0)
	local var_729_0 = arg_729_0:getCoopMissionSchedule()
	
	if not var_729_0 then
		return 
	end
	
	return var_729_0.boss
end

function Account.getCoopSeasonNumber(arg_730_0)
	local var_730_0 = arg_730_0:getCoopMissionSchedule()
	
	if not var_730_0 then
		return 
	end
	
	return var_730_0.season_number
end

function Account.getCoopSeasonData(arg_731_0)
	local var_731_0 = arg_731_0:getCoopMissionData()
	
	if not var_731_0 then
		return 
	end
	
	return var_731_0.season_data
end

function Account.getCoopCurrentSeasonPoint(arg_732_0, arg_732_1)
	local var_732_0 = arg_732_0:getCoopSeasonData()
	
	if not var_732_0 then
		return 
	end
	
	local var_732_1 = var_732_0[arg_732_1]
	
	if not var_732_1 then
		return 
	end
	
	return var_732_1.point
end

function Account.isMainStance(arg_733_0)
	local var_733_0 = arg_733_0:getCoopMissionData()
	
	return var_733_0 and var_733_0.is_maintenance
end

function Account.setCoopMissionData(arg_734_0, arg_734_1)
	if not arg_734_1.coop_mission_schedule then
		arg_734_1.is_maintenance = true
	end
	
	if not arg_734_1.coop_mission_next_schedule and AccountData.coop_mission and AccountData.coop_mission.coop_mission_next_schedule then
		arg_734_1.coop_mission_next_schedule = AccountData.coop_mission.coop_mission_next_schedule
	end
	
	AccountData.coop_mission = arg_734_1
end

function Account.setOpenLists(arg_735_0, arg_735_1, arg_735_2)
	if AccountData.coop_mission and not AccountData.coop_mission.open_lists then
		AccountData.coop_mission.open_lists = {}
	end
	
	if not AccountData.coop_mission.open_lists[arg_735_2] then
		AccountData.coop_mission.open_lists[arg_735_2] = {}
	end
	
	AccountData.coop_mission.open_lists[arg_735_2] = arg_735_1
end

function Account.updateCoopMaxDifficulty(arg_736_0, arg_736_1)
	local var_736_0 = arg_736_0:getCoopMissionData()
	
	if not var_736_0 then
		return 
	end
	
	var_736_0.max_difficulty = arg_736_1.max_difficulty
end

function Account.getEventNoticeIconInfo(arg_737_0)
	return {
		notice_event_icon_media = AccountData.notice_event_icon_media,
		notice_event_list = AccountData.notice_event_list,
		notice_event_banner = AccountData.notice_event_banner,
		notice_event_reddot = AccountData.notice_event_reddot
	}
end

function Account.addCoopPointValue(arg_738_0, arg_738_1)
	local var_738_0 = arg_738_0:getCoopMissionData()
	
	if not var_738_0 or not arg_738_1.boss_season_data then
		return 
	end
	
	local var_738_1 = arg_738_1.boss_season_data.boss_code
	local var_738_2 = var_738_0.season_data
	
	if not var_738_2 or not var_738_2[var_738_1] then
		return 
	end
	
	local var_738_3 = var_738_2[var_738_1]
	
	var_738_3.point = arg_738_1.point_value + var_738_3.point
end

function Account.getEquipMileage(arg_739_0, arg_739_1)
	if not arg_739_1 then
		return 
	end
	
	return AccountData.equip_mileages[arg_739_1] or 0
end

function Account.updateEquipMileage(arg_740_0, arg_740_1)
	if not arg_740_1 then
		return 
	end
	
	for iter_740_0, iter_740_1 in pairs(arg_740_1) do
		AccountData.equip_mileages[iter_740_0] = iter_740_1
	end
end

function Account.setUserOption(arg_741_0, arg_741_1)
	AccountData.opt = arg_741_1
end

function Account.getUserOption(arg_742_0)
	return AccountData.opt
end

function Account.setMainProfileCard(arg_743_0, arg_743_1)
	if not arg_743_1 then
		return 
	end
	
	AccountData.profile_card = arg_743_1
end

function Account.getPromotionBannerHideTime()
	return to_n(SAVE:get("ui_lobby_banner_hide", 0))
end

function Account.getPromotionBannerInfo(arg_745_0)
	local var_745_0 = {}
	
	for iter_745_0, iter_745_1 in pairs(AccountData.banners) do
		table.push(var_745_0, {
			id = iter_745_1.banner_id,
			img = iter_745_1.img,
			link = iter_745_1.link,
			indicator = iter_745_1.indicator_enable == 1,
			start_time = iter_745_1.start_time,
			end_time = iter_745_1.end_time,
			mail_expose = iter_745_1.mail_expose,
			rolling_invisible = iter_745_1.rolling_invisible
		})
	end
	
	return var_745_0
end

function Account.getPromotionBannerInfoStr(arg_746_0)
	return json.encode(arg_746_0:getPromotionBannerInfo())
end

function Account.isDiffCurrentBannerInfo()
	local var_747_0 = SAVE:get("ui_lobby_banner_hide_info", "")
	local var_747_1 = json.decode(var_747_0 or "") or {}
	local var_747_2 = Account:getPromotionBannerInfo()
	local var_747_3 = {}
	local var_747_4 = {}
	
	for iter_747_0, iter_747_1 in pairs(var_747_1) do
		var_747_3[iter_747_1.id or iter_747_1.link] = iter_747_1
	end
	
	for iter_747_2, iter_747_3 in pairs(var_747_2) do
		var_747_4[iter_747_3.id or iter_747_3.link] = iter_747_3
	end
	
	for iter_747_4, iter_747_5 in pairs(var_747_3) do
		if not var_747_4[iter_747_4] then
			return true
		else
			local var_747_5 = var_747_4[iter_747_4]
			
			if to_n(iter_747_5.start_time) ~= to_n(var_747_5.start_time) or to_n(iter_747_5.end_time) ~= to_n(var_747_5.end_time) or iter_747_5.img ~= var_747_5.img then
				return true
			end
		end
	end
	
	for iter_747_6, iter_747_7 in pairs(var_747_4) do
		if not var_747_3[iter_747_6] then
			return true
		else
			local var_747_6 = var_747_3[iter_747_6]
			
			if to_n(iter_747_7.start_time) ~= to_n(var_747_6.start_time) or to_n(iter_747_7.end_time) ~= to_n(var_747_6.end_time) or iter_747_7.img ~= var_747_6.img then
				return true
			end
		end
	end
	
	return false
end

function Account.setPromotionBannerHideTime(arg_748_0, arg_748_1)
	local var_748_0 = 86400
	
	SAVE:set("ui_lobby_banner_hide", os.time() + var_748_0)
	SAVE:set("ui_lobby_banner_hide_info", arg_748_0:getPromotionBannerInfoStr())
end

function Account.resetPromotionBannerHideTime(arg_749_0)
	SAVE:set("ui_lobby_banner_hide", 0)
	SAVE:set("ui_lobby_banner_hide_info", "")
end

function Account.getMainProfileCard(arg_750_0)
	return AccountData.profile_card
end

function Account.getMainProfileCardSlot(arg_751_0)
	if table.empty(AccountData.profile_card) then
		return nil
	end
	
	return AccountData.profile_card.slot
end

function Account.setProfileCardBanRemainTime(arg_752_0, arg_752_1)
	AccountData.profile_card_ban_tm = arg_752_1
end

function Account.getProfileCardBanState(arg_753_0)
	if not AccountData.profile_card_ban_tm or AccountData.profile_card_ban_tm == 0 then
		return false, nil
	end
	
	if AccountData.profile_card_ban_tm == -1 then
		return true, nil
	end
	
	if AccountData.profile_card_ban_tm then
		local var_753_0 = AccountData.profile_card_ban_tm - os.time()
		
		if var_753_0 < 0 then
			return false, nil
		end
		
		return true, var_753_0
	end
	
	return false, nil
end

function Account.setCrehuntSeasonScheduleInfo(arg_754_0, arg_754_1)
	if table.empty(arg_754_1) then
		return 
	end
	
	AccountData.crevice_hunt_schedules = arg_754_1
end

function Account.getCrehuntSeasonScheduleInfo(arg_755_0)
	return AccountData.crevice_hunt_schedules
end

function Account.getCrehuntSeasonScheduleID(arg_756_0)
	if table.empty(AccountData.crevice_hunt_schedules) then
		if not table.empty(AccountData.crehunt_season_info) then
			return AccountData.crehunt_season_info.season_id
		end
		
		return nil
	end
	
	return AccountData.crevice_hunt_schedules.id
end

function Account.getCrehuntSeasonAttribute(arg_757_0)
	if table.empty(AccountData.crevice_hunt_schedules) then
		return nil
	end
	
	return AccountData.crevice_hunt_schedules.attribute
end

function Account.getCrehuntSeasonName(arg_758_0)
	local var_758_0 = arg_758_0:getCrehuntSeasonScheduleID()
	
	if var_758_0 then
		return DB("level_crevicehunt", var_758_0, {
			"name"
		})
	end
	
	return nil
end

function Account.getCrehuntDifficultyByEnterID(arg_759_0, arg_759_1)
	if table.empty(AccountData.crevice_hunt_schedules) or not arg_759_1 then
		return nil
	end
	
	local var_759_0
	
	if arg_759_1 == AccountData.crevice_hunt_schedules.normal_enter_id then
		var_759_0 = 0
	elseif arg_759_1 == AccountData.crevice_hunt_schedules.hard_enter_id then
		var_759_0 = 1
	end
	
	return var_759_0
end

function Account.getCrehuntSeasonEnterIDBydifficulty(arg_760_0, arg_760_1)
	arg_760_1 = arg_760_1 or 0
	
	if table.empty(AccountData.crevice_hunt_schedules) or not arg_760_1 then
		return nil
	end
	
	local var_760_0
	
	if arg_760_1 == 0 then
		var_760_0 = AccountData.crevice_hunt_schedules.normal_enter_id
	elseif arg_760_1 == 1 then
		var_760_0 = AccountData.crevice_hunt_schedules.hard_enter_id
	end
	
	return var_760_0
end

function Account.getCrehuntRemainTimeText(arg_761_0)
	return T("ui_crevice_endtime_unknown")
end

function Account.getCrehuntSeasonInfo(arg_762_0)
	return AccountData.crehunt_season_info
end
