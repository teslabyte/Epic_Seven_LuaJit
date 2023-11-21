ConditionGroup = ClassDef()
CONDITION_GROUP_COLUMN_MAX = 8

function ConditionGroup.constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = {}
	
	table.insert(var_1_0, "id")
	
	for iter_1_0 = 1, CONDITION_GROUP_COLUMN_MAX do
		table.insert(var_1_0, "condition_" .. iter_1_0)
		table.insert(var_1_0, "value_" .. iter_1_0)
	end
	
	arg_1_0.db = {
		count = 1
	}
	arg_1_0.condition = arg_1_4
	arg_1_0.contents_type = arg_1_3
	arg_1_0.value = arg_1_5
	arg_1_0.parent_contents = arg_1_1
	arg_1_0.contents_id = arg_1_2
	arg_1_0.unique_key = arg_1_2
	
	merge_table(totable(arg_1_5), arg_1_0.db)
	
	arg_1_0.condition_list = {}
	
	if arg_1_0.db.group and arg_1_4 == "condition_group_count" then
		local var_1_1 = DBT("condition_group", arg_1_0.db.group, var_1_0)
		
		for iter_1_1 = 1, CONDITION_GROUP_COLUMN_MAX do
			if var_1_1["condition_" .. iter_1_1] then
				local var_1_2 = g_CONDITION_CLASS[var_1_1["condition_" .. iter_1_1]]
				
				if var_1_2 then
					local var_1_3 = var_1_2(arg_1_0, arg_1_0.parent_contents, arg_1_3, arg_1_2, var_1_1["condition" .. iter_1_1], var_1_1["value_" .. iter_1_1], iter_1_1)
					
					table.insert(arg_1_0.condition_list, var_1_3)
				end
			else
				break
			end
		end
	else
		local var_1_4 = g_CONDITION_CLASS[arg_1_4]
		
		if var_1_4 then
			local var_1_5 = var_1_4(arg_1_0, arg_1_0.parent_contents, arg_1_3, arg_1_2, arg_1_4, arg_1_5, 1)
			
			table.insert(arg_1_0.condition_list, var_1_5)
		end
	end
	
	if #arg_1_0.condition_list <= 0 then
	end
end

function ConditionGroup.setLinkQuest(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0.condition_list or {}) do
		iter_2_1:setLinkQuest(arg_2_1)
	end
end

function ConditionGroup.setAreaEnterID(arg_3_0, arg_3_1)
	for iter_3_0, iter_3_1 in pairs(arg_3_0.condition_list or {}) do
		iter_3_1:setAreaEnterID(arg_3_1)
	end
end

function ConditionGroup.getAreaEnterID(arg_4_0)
	for iter_4_0, iter_4_1 in pairs(arg_4_0.condition_list or {}) do
		return iter_4_1:getAreaEnterID()
	end
end

function ConditionGroup.setEventID(arg_5_0, arg_5_1)
	arg_5_0.event_id = arg_5_1
end

function ConditionGroup.getEventID(arg_6_0, arg_6_1)
	return arg_6_0.event_id
end

function ConditionGroup.setSubStoryID(arg_7_0, arg_7_1)
	arg_7_0.substory_id = arg_7_1
end

function ConditionGroup.getSubStoryID(arg_8_0, arg_8_1)
	return arg_8_0.substory_id
end

function ConditionGroup.setExpireTime(arg_9_0, arg_9_1)
	arg_9_0.expire_time = arg_9_1
end

function ConditionGroup.getExpireTime(arg_10_0)
	return arg_10_0.expire_time
end

function ConditionGroup.isValidTime(arg_11_0)
	local var_11_0 = os.time()
	
	if arg_11_0.expire_time and var_11_0 >= arg_11_0.expire_time then
		return false
	end
	
	return true
end

function ConditionGroup.isDone(arg_12_0)
	local var_12_0 = true
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0:getHandlerList()) do
		if not iter_12_1:isDone() then
			var_12_0 = nil
			
			break
		end
	end
	
	return var_12_0
end

function ConditionGroup.isDoneCount(arg_13_0)
	local var_13_0 = 0
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0:getHandlerList()) do
		if iter_13_1:isDone() then
			var_13_0 = var_13_0 + 1
			
			break
		end
	end
	
	return var_13_0
end

function ConditionGroup.isDoneExpectedCount(arg_14_0, arg_14_1)
	local var_14_0 = 0
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0:getHandlerList()) do
		if iter_14_1:isDoneExpected(arg_14_1) then
			var_14_0 = var_14_0 + 1
			
			break
		end
	end
	
	return var_14_0
end

function ConditionGroup.forceAdd(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_0:getHandlerList()) do
		iter_15_1:setAddCount(arg_15_1)
	end
end

function ConditionGroup.resetVltTbl(arg_16_0)
	for iter_16_0, iter_16_1 in pairs(arg_16_0:getHandlerList()) do
		iter_16_1:resetVltTbl()
	end
end

function ConditionGroup.removeVltTbl(arg_17_0, arg_17_1)
	if not arg_17_1 then
		Log.e("ConditionGroup.removeVltTbl", "invalid_unique_id")
		
		return 
	end
	
	local var_17_0 = tostring(arg_17_1)
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0:getHandlerList()) do
		iter_17_1:removeVltTbl(var_17_0)
	end
end

function ConditionGroup.cleanUpVltTbl(arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in pairs(arg_18_0:getHandlerList()) do
		iter_18_1:cleanUpVltTbl(arg_18_1)
	end
end

function ConditionGroup.resetAdd(arg_19_0)
	for iter_19_0, iter_19_1 in pairs(arg_19_0:getHandlerList()) do
		iter_19_1:resetAdd()
	end
end

function ConditionGroup.getUpdateCount(arg_20_0)
	local var_20_0 = 0
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0:getHandlerList()) do
		if iter_20_1:getAddCount() and tonumber(iter_20_1:getAddCount()) > 0 then
			var_20_0 = var_20_0 + 1
		end
	end
	
	return var_20_0
end

function ConditionGroup.getVerifyParams(arg_21_0)
	local var_21_0
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0:getHandlerList()) do
		local var_21_1 = iter_21_1:getVerifyParams()
		
		if var_21_1 and table.count(var_21_1) > 0 then
			if var_21_0 == nil then
				var_21_0 = {}
			end
			
			table.merge(var_21_0, var_21_1)
		end
	end
	
	return var_21_0
end

function ConditionGroup.getHandlerList(arg_22_0)
	return arg_22_0.condition_list
end

function ConditionGroup.getHandlerUniqueKeyList(arg_23_0)
	local var_23_0 = {}
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.condition_list) do
		table.insert(var_23_0, iter_23_1:getUniqueKey())
	end
	
	return var_23_0
end

function ConditionGroup.getUniqueKey(arg_24_0)
	return arg_24_0.unique_key
end

function ConditionGroup.getHandler(arg_25_0, arg_25_1)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.condition_list) do
		if iter_25_1:getUniqueKey() == arg_25_1 then
			return iter_25_1
		end
	end
end

function ConditionGroup.getContentsType(arg_26_0)
	return arg_26_0.contents_type
end

Condition_New = ClassDef()

function Condition_New.constructor(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
	arg_27_0.db = {
		count = 1
	}
	arg_27_0.condition = arg_27_5
	arg_27_0.value = string.trim(arg_27_6)
	arg_27_0.group = arg_27_1
	arg_27_0.parent_contents = arg_27_2
	
	merge_table(totable(arg_27_6), arg_27_0.db)
	
	arg_27_0.add_count = nil
	arg_27_0.vlt_tbl = {}
	arg_27_0.cur_count = arg_27_0.parent_contents:getConditionScore(arg_27_4, arg_27_7)
	arg_27_0.contents_type = arg_27_3
	arg_27_0.contents_id = arg_27_4
	arg_27_0.unique_key = arg_27_4 .. "_" .. arg_27_7
end

function Condition_New.setLinkQuest(arg_28_0, arg_28_1)
	arg_28_0.link_quest = arg_28_1
end

function Condition_New.setAreaEnterID(arg_29_0, arg_29_1)
	arg_29_0.area_enter_id = arg_29_1
end

function Condition_New.getAreaEnterID(arg_30_0)
	return arg_30_0.area_enter_id
end

function Condition_New.getContentsType(arg_31_0)
	return arg_31_0.contents_type
end

function Condition_New.getContentsId(arg_32_0)
	return arg_32_0.contents_id
end

function Condition_New.checkDone(arg_33_0)
	if arg_33_0.cur_count + (arg_33_0.add_count or 0) >= tonumber(arg_33_0.db.count) then
		arg_33_0._isDone = true
	else
		arg_33_0._isDone = nil
	end
end

function Condition_New.getAcceptEvents(arg_34_0)
	return {}
end

function Condition_New.isDone(arg_35_0)
	return arg_35_0._isDone
end

function Condition_New.isDoneExpected(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0:getVltCount(arg_36_1) or 0
	
	if arg_36_0.cur_count + (arg_36_0.add_count or 0) + var_36_0 >= tonumber(arg_36_0.db.count) then
		return true
	end
	
	return false
end

function Condition_New.getVltTblVars(arg_37_0, arg_37_1)
	if not arg_37_1 then
		Log.e("Condition_New.getVltTblVars", "invalid_unique_id")
		
		return 
	end
	
	local var_37_0 = tostring(arg_37_1)
	local var_37_1 = arg_37_0:getVltTbl(var_37_0)
	
	var_37_1.vars = var_37_1.vars or {}
	
	return var_37_1.vars
end

function Condition_New.clearVltTblVars(arg_38_0, arg_38_1)
	if not arg_38_1 then
		Log.e("Condition_New.clearVltTblVars", "invalid_unique_id")
		
		return 
	end
	
	local var_38_0 = tostring(arg_38_1)
	
	arg_38_0:getVltTbl(var_38_0).vars = {}
end

function Condition_New.getVltTblAll(arg_39_0)
	return arg_39_0.vlt_tbl
end

function Condition_New.getVltCount(arg_40_0, arg_40_1)
	if not arg_40_1 then
		Log.e("Condition_New.getVltCount", "invalid_unique_id ")
		
		return 
	end
	
	local var_40_0 = tostring(arg_40_1)
	
	return arg_40_0:getVltTbl(var_40_0).count or 0
end

function Condition_New.getVltTbl(arg_41_0, arg_41_1)
	if not arg_41_1 then
		Log.e("Condition_New.getVltTbl", "invalid_unique_id ")
		
		return 
	end
	
	local var_41_0 = tostring(arg_41_1)
	
	arg_41_0.vlt_tbl[var_41_0] = arg_41_0.vlt_tbl[var_41_0] or {}
	
	return arg_41_0.vlt_tbl[var_41_0]
end

function Condition_New.doCountVlt(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_1 then
		Log.e("Condition_New.doCountVlt", "invalid_unique_id")
		
		return 
	end
	
	local var_42_0 = tostring(arg_42_1)
	local var_42_1 = arg_42_0:getVltTbl(var_42_0)
	
	var_42_1.count = (var_42_1.count or 0) + (arg_42_2 or 1)
end

function Condition_New.resetVltTbl(arg_43_0, arg_43_1)
	arg_43_0.vlt_tbl = {}
end

function Condition_New.removeVltTbl(arg_44_0, arg_44_1)
	if not arg_44_1 then
		Log.e("Condition_New.removeVltTbl", "invalid_unique_id")
		
		return 
	end
	
	local var_44_0 = tostring(arg_44_1)
	
	arg_44_0.vlt_tbl[var_44_0] = nil
end

function Condition_New.cleanUpVltTbl(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0.vlt_tbl or {}
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		if not table.isInclude(arg_45_1, iter_45_0) then
			var_45_0[iter_45_0] = nil
		end
	end
end

function Condition_New.getAddCount(arg_46_0)
	return arg_46_0.add_count
end

function Condition_New.setAddCount(arg_47_0, arg_47_1)
	arg_47_0.add_count = arg_47_1
end

function Condition_New.getCurCount(arg_48_0)
	return arg_48_0.cur_count
end

function Condition_New.getVerifyParams(arg_49_0)
	if not arg_49_0.verify_params then
		arg_49_0.verify_params = {}
	end
	
	return arg_49_0.verify_params
end

function Condition_New.getCalcCurCount(arg_50_0)
	return (arg_50_0.cur_count or 0) + (arg_50_0.add_count or 0)
end

function Condition_New.onEvent(arg_51_0, arg_51_1, arg_51_2)
end

function Condition_New.getUniqueKey(arg_52_0)
	return arg_52_0.unique_key
end

function Condition_New.getGoalCount(arg_53_0)
	return tonumber(arg_53_0.db.count) or 1
end

function Condition_New.doCountAdd(arg_54_0, arg_54_1)
	arg_54_0.add_count = (arg_54_0.add_count or 0) + (arg_54_1 or 1)
end

function Condition_New.resetAdd(arg_55_0)
	arg_55_0.add_count = nil
end

function Condition_New.doCountCur(arg_56_0, arg_56_1)
	arg_56_0.cur_count = arg_56_0.cur_count + (arg_56_1 or 1)
	
	return arg_56_0.cur_count
end

function Condition_New.doAccumulateCount(arg_57_0, arg_57_1)
	if not arg_57_1 then
		Log.e("Condition_New.doAccumulateCount", "invalid_unique_id")
		
		return 
	end
	
	local var_57_0 = tostring(arg_57_1)
	local var_57_1 = arg_57_0:getVltCount(var_57_0)
	
	if var_57_1 > 0 then
		arg_57_0:doCountAdd(var_57_1)
		
		arg_57_0.vlt_tbl[var_57_0] = nil
	end
end

function Condition_New.checkMultikey(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = false
	
	if arg_58_1 then
		if type(arg_58_1) == "table" then
			for iter_58_0, iter_58_1 in pairs(arg_58_1) do
				if iter_58_1 == arg_58_2 then
					var_58_0 = true
					
					break
				end
			end
		elseif arg_58_1 == arg_58_2 then
			var_58_0 = true
		end
	end
	
	return var_58_0
end

function Condition_New.checkWildCard(arg_59_0, arg_59_1, arg_59_2)
	if type(arg_59_1) == "table" then
		return false
	end
	
	if not arg_59_1 or not arg_59_2 or not string.find(arg_59_1, "*") then
		return 
	end
	
	local var_59_0 = string.split(arg_59_1, "*")[1]
	
	if string.starts(arg_59_2, var_59_0) then
		return true
	end
end
