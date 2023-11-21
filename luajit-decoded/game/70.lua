ConditionContents = ConditionContents or {}

function ConditionContents.init(arg_1_0)
end

function ConditionContents.createGroupHandler(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.condition_groups = arg_2_0.condition_groups or {}
	
	if arg_2_0.condition_groups[arg_2_1] then
		return 
	end
	
	local var_2_0 = ConditionGroup(arg_2_0, arg_2_1, arg_2_0.contents_type, arg_2_2, arg_2_3)
	
	arg_2_0.condition_groups[arg_2_1] = var_2_0
	
	local var_2_1 = var_2_0:getHandlerList()
	
	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		local var_2_2 = iter_2_1:getAcceptEvents()
		
		arg_2_0.events_map = arg_2_0.events_map or {}
		
		for iter_2_2, iter_2_3 in pairs(var_2_2) do
			if not arg_2_0.events_map[iter_2_3] then
				arg_2_0.events_map[iter_2_3] = {}
			end
			
			table.insert(arg_2_0.events_map[iter_2_3], iter_2_1)
		end
	end
	
	return var_2_0
end

function ConditionContents.checkUnlockCondition(arg_3_0)
end

function ConditionContents.getConditionGroup(arg_4_0)
	return arg_4_0.condition_groups
end

function ConditionContents.removeGroups(arg_5_0)
	for iter_5_0, iter_5_1 in pairs(arg_5_0.condition_groups) do
		arg_5_0:removeGroup(iter_5_1:getUniqueKey())
	end
end

function ConditionContents.getContentsType(arg_6_0)
	return arg_6_0.contents_type
end

function ConditionContents.getNotifierControl(arg_7_0)
end

function ConditionContents.createNotifyControl(arg_8_0)
end

function ConditionContents.forceAddUpdate(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0:getGroup(arg_9_1)
	
	if var_9_0 then
		var_9_0:forceAdd(arg_9_2)
		var_9_0:isDone()
	end
end

function ConditionContents.print(arg_10_0, arg_10_1)
	print("group=========================================================")
	table.print(arg_10_0.condition_groups[arg_10_1])
	print("events=========================================================")
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.events_map or {}) do
		for iter_10_2 = #iter_10_1, 1, -1 do
			if iter_10_1[iter_10_2]:getContentsId() == arg_10_1 then
				print("events_name = ", iter_10_0, "===============================")
				table.print(iter_10_1[iter_10_2])
				
				break
			end
		end
	end
end

function ConditionContents.removeExpire(arg_11_0)
end

function ConditionContents.removeGroup(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.condition_groups[arg_12_1]
	
	if var_12_0 then
		local var_12_1 = var_12_0:getHandlerUniqueKeyList()
		
		arg_12_0.condition_groups[arg_12_1] = nil
		
		for iter_12_0, iter_12_1 in pairs(var_12_1) do
			arg_12_0:removeHandler(iter_12_1)
		end
	end
end

function ConditionContents.removeHandler(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.events_map or {}) do
		for iter_13_2 = #iter_13_1, 1, -1 do
			if iter_13_1[iter_13_2]:getUniqueKey() == arg_13_1 then
				table.remove(iter_13_1, iter_13_2)
				
				break
			end
		end
	end
end

function ConditionContents.setConditionGroupData(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_3 = arg_14_3 or {}
	AccountData.conditions.groups[arg_14_1] = arg_14_2
	
	if not arg_14_3.ignore_condition_cur_score then
		for iter_14_0, iter_14_1 in pairs(arg_14_2.conditions or {}) do
			arg_14_0:setUpdateConditionCurScore(arg_14_1, iter_14_0, iter_14_1.score)
		end
	end
end

function ConditionContents.getConditionGroupDB(arg_15_0, arg_15_1)
	local var_15_0 = {}
	
	table.insert(var_15_0, "id")
	
	for iter_15_0 = 1, CONDITION_GROUP_COLUMN_MAX do
		table.insert(var_15_0, "condition_" .. iter_15_0)
		table.insert(var_15_0, "value_" .. iter_15_0)
		table.insert(var_15_0, "name_" .. iter_15_0)
	end
	
	return (DBT("condition_group", arg_15_1, var_15_0))
end

function ConditionContents.getConditionsCount(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0:getConditionGroupDB(arg_16_2)
	local var_16_1 = 0
	local var_16_2 = 0
	
	for iter_16_0 = 1, CONDITION_GROUP_COLUMN_MAX do
		if var_16_0["condition_" .. iter_16_0] then
			local var_16_3 = {
				count = 1
			}
			
			merge_table(totable(var_16_0["value_" .. iter_16_0]), var_16_3)
			
			local var_16_4 = arg_16_0:getConditionScore(arg_16_1, iter_16_0)
			local var_16_5 = var_16_3.count
			
			if var_16_4 >= tonumber(var_16_5) then
				var_16_2 = var_16_2 + 1
			end
			
			var_16_1 = var_16_1 + 1
		end
	end
	
	return var_16_1, var_16_2
end

function ConditionContents.getScore(arg_17_0, arg_17_1)
	if not AccountData.conditions.groups[arg_17_1] then
		return 0
	end
	
	local var_17_0 = 0
	local var_17_1 = AccountData.conditions.groups[arg_17_1].conditions
	
	for iter_17_0, iter_17_1 in pairs(var_17_1 or {}) do
		var_17_0 = var_17_0 + 1
	end
	
	if var_17_0 == 1 then
		if not AccountData.conditions.groups[arg_17_1].conditions[arg_17_1 .. "_1"] then
			return 0
		end
		
		return AccountData.conditions.groups[arg_17_1].conditions[arg_17_1 .. "_1"].score or 0
	else
		return AccountData.conditions.groups[arg_17_1].score or 0
	end
	
	return score
end

function ConditionContents.getConditionsCount_datas(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0:getConditionGroupDB(arg_18_3)
	local var_18_1 = 0
	local var_18_2 = 0
	
	for iter_18_0 = 1, CONDITION_GROUP_COLUMN_MAX do
		if var_18_0["condition_" .. iter_18_0] then
			local var_18_3 = {
				count = 1
			}
			
			merge_table(totable(var_18_0["value_" .. iter_18_0]), var_18_3)
			
			local var_18_4 = arg_18_0:getConditionScore_datas(arg_18_1, arg_18_2, iter_18_0)
			local var_18_5 = var_18_3.count
			
			if var_18_4 >= tonumber(var_18_5) then
				var_18_2 = var_18_2 + 1
			end
			
			var_18_1 = var_18_1 + 1
		end
	end
	
	return var_18_1, var_18_2
end

function ConditionContents.getScore_datas(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	if arg_19_1[arg_19_2] == nil then
		return 0
	end
	
	if arg_19_3 == "condition_group" then
		arg_19_4 = string.trim(arg_19_4)
		
		local var_19_0 = totable(arg_19_4)
		local var_19_1, var_19_2 = arg_19_0:getConditionsCount_datas(arg_19_1, arg_19_2, var_19_0.group)
		
		return var_19_2
	else
		return arg_19_1[arg_19_2].score1 or 0
	end
end

function ConditionContents.getConditionScore(arg_20_0, arg_20_1, arg_20_2)
	arg_20_2 = arg_20_2 or 1
	
	if not AccountData.conditions.groups[arg_20_1] then
		return 0
	end
	
	if not AccountData.conditions.groups[arg_20_1].conditions then
		return 0
	end
	
	if not AccountData.conditions.groups[arg_20_1].conditions[arg_20_1 .. "_" .. arg_20_2] then
		return 0
	end
	
	return AccountData.conditions.groups[arg_20_1].conditions[arg_20_1 .. "_" .. arg_20_2].score or 0
end

function ConditionContents.getConditionScore_datas(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_1[arg_21_2] == nil then
		return 0
	end
	
	if arg_21_1[arg_21_2]["score" .. arg_21_3] == nil then
		return 0
	end
	
	return arg_21_1[arg_21_2]["score" .. arg_21_3]
end

function ConditionContents.getMaxCount(arg_22_0, arg_22_1)
	if not arg_22_0.condition_groups[arg_22_1] then
		return 0
	end
	
	return arg_22_0.condition_groups[arg_22_1].db.count or 0
end

function ConditionContents.clear(arg_23_0)
	ConditionContentsManager:queryUpdateConditions("h:ConditionContents.clear")
	
	arg_23_0.events_map = {}
	arg_23_0.condition_groups = {}
	arg_23_0.lock_datas = {}
end

function ConditionContents.resetAdd(arg_24_0, arg_24_1)
	if not arg_24_0.condition_groups then
		return 
	end
	
	if arg_24_0.condition_groups[arg_24_1] then
		arg_24_0.condition_groups[arg_24_1]:resetAdd()
	else
		for iter_24_0, iter_24_1 in pairs(arg_24_0.condition_groups or {}) do
			iter_24_1:resetAdd()
		end
	end
end

function ConditionContents.resetVltTbl(arg_25_0, arg_25_1)
	if not arg_25_0.condition_groups then
		return 
	end
	
	if arg_25_0.condition_groups[arg_25_1] then
		arg_25_0.condition_groups[arg_25_1]:resetVltTbl()
	else
		for iter_25_0, iter_25_1 in pairs(arg_25_0.condition_groups or {}) do
			iter_25_1:resetVltTbl()
		end
	end
end

function ConditionContents.cleanUpVltTbl(arg_26_0, arg_26_1)
	if not arg_26_0.condition_groups then
		return 
	end
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.condition_groups or {}) do
		iter_26_1:cleanUpVltTbl(arg_26_1)
	end
end

function ConditionContents.setForceUpdateContests(arg_27_0, arg_27_1, arg_27_2)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_27_0.condition_groups then
		Log.e("condition!!!!", "pkyeesl!!!!call<<<!!!!")
	end
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.condition_groups or {}) do
		if iter_27_1:getUniqueKey() == arg_27_1 then
			iter_27_1:forceAdd(arg_27_2)
		end
	end
	
	ConditionContentsManager:queryUpdateConditions("f:setForceUpdateContests")
end

function ConditionContents.getUpdateContents(arg_28_0, arg_28_1)
	arg_28_1 = arg_28_1 or {}
	
	local var_28_0 = {}
	local var_28_1 = {}
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.condition_groups or {}) do
		if iter_28_1:isValidTime() == false then
			arg_28_0:removeGroup(iter_28_1:getUniqueKey())
		else
			local var_28_2 = false
			
			if arg_28_0.contents_type == CONTENTS_TYPE.BATTLE_MISSION then
				if iter_28_1:isDone() and iter_28_1:isDoneCount() > 0 and iter_28_1:getUpdateCount() and iter_28_1:getUpdateCount() > 0 then
					var_28_2 = true
				end
			elseif iter_28_1:getUpdateCount() and iter_28_1:getUpdateCount() > 0 then
				var_28_2 = true
			end
			
			if var_28_2 then
				local var_28_3 = {
					ukey = iter_28_1:getUniqueKey(),
					event_id = iter_28_1:getEventID(),
					contents_type = iter_28_1:getContentsType(),
					sub_story_id = iter_28_1:getSubStoryID()
				}
				
				arg_28_0:addUpdateOptions(iter_28_1, var_28_3)
				table.insert(var_28_0, var_28_3)
				arg_28_0:insertUpdateConditionList(var_28_1, iter_28_1, arg_28_1)
			end
		end
	end
	
	if #var_28_0 <= 0 then
		return 
	end
	
	return var_28_0, var_28_1
end

function ConditionContents.getCompleteContents(arg_29_0)
end

function ConditionContents.insertUpdateConditionList(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_3 = arg_30_3 or {}
	
	local var_30_0 = arg_30_2:getHandlerList()
	
	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		local var_30_1 = iter_30_1:getAddCount()
		
		if var_30_1 and tonumber(var_30_1) > 0 then
			local var_30_2 = {
				ukey = iter_30_1:getUniqueKey(),
				score = var_30_1,
				group_ukey = arg_30_2:getUniqueKey(),
				verify = arg_30_2:getVerifyParams()
			}
			
			table.insert(arg_30_1, var_30_2)
		end
	end
end

function ConditionContents.addUpdateOptions(arg_31_0, arg_31_1, arg_31_2)
end

function ConditionContents.getExportContents(arg_32_0)
	local var_32_0 = {}
	local var_32_1 = {}
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.condition_groups or {}) do
		if iter_32_1:getUpdateCount() and iter_32_1:getUpdateCount() > 0 then
			local var_32_2 = {
				ukey = iter_32_1:getUniqueKey(),
				contents_type = iter_32_1:getContentsType()
			}
			
			table.insert(var_32_0, var_32_2)
			
			for iter_32_2, iter_32_3 in pairs(iter_32_1:getHandlerList()) do
				local var_32_3 = iter_32_3:getAddCount()
				local var_32_4 = iter_32_3:getCurCount()
				local var_32_5 = iter_32_3:isDone()
				
				if var_32_3 or var_32_4 then
					local var_32_6 = {
						ukey = iter_32_3:getUniqueKey(),
						vlt_count = var_32_3 or 0,
						cur_count = var_32_4 or 0,
						_isDone = var_32_5,
						group_ukey = iter_32_1:getUniqueKey()
					}
					
					table.insert(var_32_1, var_32_6)
				end
			end
		end
	end
	
	if #var_32_0 <= 0 then
		return 
	end
	
	return var_32_0, var_32_1
end

function ConditionContents.setUpdateConditionCurScore(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	if not arg_33_0.condition_groups then
		Log.e("nil_condition_groups??????", arg_33_1)
		
		return 
	end
	
	local var_33_0 = arg_33_0.condition_groups[arg_33_1]
	
	if not var_33_0 then
		return 
	end
	
	arg_33_2 = arg_33_2 or arg_33_1 .. "_1"
	
	local var_33_1 = var_33_0:getHandler(arg_33_2)
	
	if var_33_1 then
		var_33_1.add_count = nil
		
		if DEBUG.UPDATE_CONDITION or getenv("DEBUG.UPDATE_CONDITION") == true then
			print("error?", arg_33_0.contents_type, arg_33_1, arg_33_3, to_n(var_33_1.cur_count), to_n(arg_33_3) - to_n(var_33_1.cur_count))
		end
		
		var_33_1.cur_count = arg_33_3
	end
end

function ConditionContents.setIgnoreQuery(arg_34_0, arg_34_1)
	arg_34_0.ignore_check_update = arg_34_1
end

function ConditionContents.dispatch(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0.events_map or not arg_35_0.events_map[arg_35_1] then
		return 
	end
	
	local var_35_0 = arg_35_0.events_map[arg_35_1]
	
	for iter_35_0 = #var_35_0, 1, -1 do
		local var_35_1 = var_35_0[iter_35_0]
		
		if not var_35_1:isDone() then
			var_35_1:onEvent(arg_35_1, arg_35_2)
		end
	end
	
	local var_35_2 = true
	
	if not string.starts(arg_35_1, "battle") then
		var_35_2 = false
	end
	
	if var_35_2 then
		return 
	end
	
	if not arg_35_0.ignore_check_update then
		ConditionContentsManager:queryUpdateConditions(arg_35_1 .. ":" .. SceneManager:getCurrentSceneName())
	end
end

function ConditionContents.refresh(arg_36_0, arg_36_1, arg_36_2)
end

function ConditionContents.getEvents(arg_37_0)
	return arg_37_0.events_map
end

function ConditionContents.getGroups(arg_38_0)
	return arg_38_0.condition_groups or {}
end

function ConditionContents.getGroup(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0:getGroups()
	
	if var_39_0 then
		return var_39_0[arg_39_1]
	end
end

function ConditionContents.giveQuery(arg_40_0, arg_40_1)
	if not arg_40_1 or not arg_40_1.give_code or not arg_40_1.give_code or not arg_40_1.contents_id or not arg_40_1.contents_type then
		return Log.e("destiny", "giveItem.null")
	end
	
	if Account:getPropertyCount(arg_40_1.give_code) < arg_40_1.give_count then
		balloon_message_with_sound("lack_give_currencies_count")
		
		return 
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("contents.give", {
		give = arg_40_1.contents_id
	})
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_40_0 = ConditionContentsManager:getUpdateConditions()
	
	ConditionContentsManager:resetAllAdd()
	
	if var_40_0 then
		query("give_conditon_contents", {
			contents_id = arg_40_1.contents_id,
			contents_type = arg_40_1.contents_type,
			update_condition_groups = json.encode(var_40_0)
		})
	end
	
	Dialog:close("destiny_present")
end

SubstoryConditionContents = SubstoryConditionContents or {}

copy_functions(ConditionContents, SubstoryConditionContents)

function SubstoryConditionContents.init(arg_41_0)
end

function SubstoryConditionContents.removeExpire(arg_42_0)
	local var_42_0 = SubstoryManager:getPlaySubstoryIDList()
	
	local function var_42_1(arg_43_0)
		if not arg_43_0 then
			return false
		end
		
		if table.find(var_42_0, arg_43_0) then
			return true
		end
		
		return false
	end
	
	local function var_42_2(arg_44_0)
		if not arg_44_0 then
			return false
		end
		
		local var_44_0 = arg_44_0:getSubStoryID()
		
		return var_42_1(var_44_0)
	end
	
	local var_42_3 = {}
	
	for iter_42_0, iter_42_1 in pairs(arg_42_0.condition_groups or {}) do
		if not var_42_2(iter_42_1) then
			arg_42_0:removeGroup(iter_42_0)
		end
	end
	
	for iter_42_2, iter_42_3 in pairs(arg_42_0.lock_datas or {}) do
		if not var_42_1(iter_42_3.substory_id) then
			arg_42_0.lock_datas[iter_42_2] = nil
		end
	end
end
