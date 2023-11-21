SubstorySystemStory = SubstorySystemStory or {}

function SubstorySystemStory.isOpenSystemSubstorySchedule(arg_1_0, arg_1_1)
	local var_1_0 = Account:getSystemSubstoryOpenTimes()
	
	if not var_1_0 then
		return false
	end
	
	local var_1_1 = var_1_0[arg_1_1]
	
	if not var_1_1 then
		return true
	end
	
	if var_1_1 <= os.time() then
		return true
	end
	
	return false
end

function SubstorySystemStory.getSubstoryProgress(arg_2_0)
	return arg_2_0.substory_progress
end

function SubstorySystemStory.setSubstoryProgress(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return 
	end
	
	arg_3_0.substory_progress = arg_3_1
end

function SubstorySystemStory.updateSubstoryProgress(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 then
		return 
	end
	
	if not arg_4_2 then
		return 
	end
	
	if not arg_4_0.substory_progress then
		return 
	end
	
	arg_4_0.substory_progress[arg_4_1] = arg_4_2
end

function SubstorySystemStory.getSubstoryProgressByID(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0 = arg_5_0:getSubstoryProgress()
	
	if not var_5_0 then
		Log.e("SubstorySystemStory.getSubstoryProgressByID", "need_query")
		
		return 
	end
	
	var_5_0 = var_5_0 or {}
	
	return var_5_0[arg_5_1]
end

function SubstorySystemStory.isSubstoryCleared(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return false
	end
	
	return ((arg_6_0:getSubstoryProgressByID(arg_6_1) or {}).end_count or 0) > 0
end

function SubstorySystemStory.setPickupOpenSchedules(arg_7_0, arg_7_1)
	if table.empty(arg_7_1) then
		return 
	end
	
	arg_7_0.pickup_open_schedules = arg_7_1
end

function SubstorySystemStory.getPickupOpenScheduleByID(arg_8_0, arg_8_1)
	if not arg_8_0.pickup_open_schedules or not arg_8_1 then
		return nil
	end
	
	return arg_8_0.pickup_open_schedules[arg_8_1]
end

function SubstorySystemStory.getRemainTimeToPickup(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return nil, nil
	end
	
	if arg_9_1 <= os.time() then
		return nil, nil
	end
	
	local var_9_0 = arg_9_1 - os.time()
	local var_9_1 = 2
	
	return var_9_0, sec_to_full_string(var_9_0, false, {
		count = var_9_1
	})
end

function SubstorySystemStory.isNewCharNoti(arg_10_0)
	local var_10_0 = UnlockSystem:isUnlockSystem(UNLOCK_ID.SYSTEM_SUBSTORY)
	local var_10_1 = Account:getConfigData("sss_new_chr")
	local var_10_2 = Account:getSystemSubstory()
	local var_10_3 = SubStoryUtil:getChrCodeNewSystemSubstory()
	
	if var_10_0 and var_10_3 and var_10_3 ~= var_10_2.substory_id and var_10_1 ~= var_10_3 then
		return var_10_3
	end
end
