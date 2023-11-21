SysAchievement = SysAchievement or {}

copy_functions(ConditionContents, SysAchievement)

function SysAchievement.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.SYS_ACHIEVEMENT
end

function SysAchievement.isValidate(arg_2_0, arg_2_1)
	return true
end

function SysAchievement.getCompleteContents(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.condition_groups or {}) do
		if iter_3_1:isDone() and iter_3_1:isDoneCount() > 0 then
			local var_3_2 = {}
			local var_3_3 = false
			
			for iter_3_2, iter_3_3 in pairs(iter_3_1:getHandlerList()) do
				if iter_3_3:isDone() then
					local var_3_4 = {
						ukey = iter_3_3:getUniqueKey(),
						score = iter_3_3:getAddCount(),
						group_ukey = iter_3_1:getUniqueKey(),
						verify = iter_3_1:getVerifyParams()
					}
					
					table.insert(var_3_1, var_3_4)
					
					var_3_3 = true
				end
			end
			
			if var_3_3 then
				var_3_2.ukey = iter_3_1:getUniqueKey()
				var_3_2.contents_type = iter_3_1:getContentsType()
				
				table.insert(var_3_0, var_3_2)
			end
		end
	end
	
	if #var_3_0 <= 0 then
		return 
	end
	
	return var_3_0, var_3_1
end

function SysAchievement.getNoti(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = arg_4_0:getCompleteContents()
	
	for iter_4_0, iter_4_1 in pairs(var_4_1 or {}) do
		local var_4_2 = iter_4_1.ukey
		
		table.insert(var_4_0, var_4_2)
	end
	
	return var_4_0
end

function SysAchievement.initConditionListner(arg_5_0)
	arg_5_0:clear()
	
	for iter_5_0 = 1, 999 do
		local var_5_0, var_5_1, var_5_2, var_5_3 = DBN("system_achievement", iter_5_0, {
			"id",
			"condition",
			"value",
			"req_acv"
		})
		
		if not var_5_0 and not var_5_1 and not var_5_2 then
			break
		end
		
		if var_5_1 and var_5_2 then
			arg_5_0:addConditionListner(var_5_0, var_5_1, var_5_2, var_5_3)
		end
	end
end

function SysAchievement.addConditionListner(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_4 and not Account:isSysAchieveCleared(arg_6_4) then
		return 
	end
	
	if UnlockSystem:isUnlockSystem(arg_6_1, {
		is_link = true
	}) then
		return 
	end
	
	local var_6_0 = Account:getSysAchieve(arg_6_1)
	local var_6_1 = arg_6_0:getScore(arg_6_1)
	local var_6_2 = var_6_0.state
	
	if var_6_0.state == 0 then
		arg_6_0:removeGroup(arg_6_1)
		
		if arg_6_0:createGroupHandler(arg_6_1, arg_6_2, arg_6_3, var_6_1) then
		else
			print("SysAchievement : undefined condition class", arg_6_2, arg_6_1)
		end
	end
end

function SysAchievement.AllClear(arg_7_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_7_0 = {}
	
	for iter_7_0 = 1, 999 do
		local var_7_1, var_7_2 = DBN("system_achievement", iter_7_0, {
			"id",
			"condition"
		})
		
		if not var_7_1 then
			break
		end
		
		if var_7_1 and var_7_2 then
			arg_7_0:forceAddUpdate(var_7_1, 99)
		end
	end
	
	ConditionContentsManager:queryUpdateConditions("f:AllClear")
	ConditionContentsManager:resetAllAdd()
	TutorialGuide:forceClearTutorials({
		UNLOCK_ID.EXCLUSIVE
	})
end

function SysAchievement.cheatClear(arg_8_0, arg_8_1)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_8_0, var_8_1 = DB("system_achievement", arg_8_1, {
		"id",
		"condition"
	})
	
	if not var_8_0 then
		Log.e("sysAchieve", "no_sys_id")
	end
	
	if var_8_0 and var_8_1 then
		arg_8_0:forceAddUpdate(arg_8_1, 99)
	end
	
	ConditionContentsManager:queryUpdateConditions("f:cheatClear")
	ConditionContentsManager:resetAllAdd()
end

function SysAchievement.update(arg_9_0, arg_9_1)
	Account:setSysAchieve(arg_9_1.achieve_id, arg_9_1.sys_achieve_doc)
	arg_9_0:setUpdateConditionCurScore(arg_9_1.achieve_id, nil, arg_9_1.sys_achieve_doc.score1)
	
	if arg_9_1.sys_achieve_doc and arg_9_1.sys_achieve_doc.state >= 1 then
		arg_9_0:removeGroup(arg_9_1.achieve_id)
		
		if arg_9_1.achieve_id == UNLOCK_ID.SICA then
			local var_9_0 = ConditionContentsManager:getAchievement()
			
			if var_9_0 then
				var_9_0:initSicaConditionListner()
			end
		else
			UnlockSystem:checkUnlockUrgentMission({
				list = arg_9_1
			})
		end
	end
	
	local var_9_1 = DB("system_achievement", arg_9_1.achieve_id, "remove_condition")
	
	if var_9_1 then
		local var_9_2 = string.split(var_9_1, ";")
		
		for iter_9_0, iter_9_1 in pairs(var_9_2) do
			arg_9_0:removeGroup(iter_9_1)
		end
	end
end

function SysAchievement.getScore(arg_10_0, arg_10_1)
	local var_10_0 = Account:getSysAchieveData()
	
	if var_10_0[arg_10_1] == nil then
		return 0
	end
	
	local var_10_1, var_10_2 = DB("system_achievement", arg_10_1, {
		"condition",
		"value"
	})
	
	return arg_10_0:getScore_datas(var_10_0, arg_10_1, var_10_1, var_10_2)
end

function SysAchievement.getConditionScore(arg_11_0, arg_11_1, arg_11_2)
	arg_11_2 = arg_11_2 or 1
	
	local var_11_0 = Account:getSysAchieveData()
	
	return arg_11_0:getConditionScore_datas(var_11_0, arg_11_1, arg_11_2)
end

function SysAchievement.exceptionalSystemUnlock(arg_12_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_12_0 = UNLOCK_ID.URGENT_MISSION
	
	if DB("system_achievement", var_12_0, {
		"condition"
	}) then
		arg_12_0:forceAddUpdate(var_12_0, 99)
		ConditionContentsManager:queryUpdateConditions("f:exceptionalSystemUnlock")
		ConditionContentsManager:resetAllAdd()
	end
end
