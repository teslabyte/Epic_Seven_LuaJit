SubStoryTravel = SubStoryTravel or {}

function SubStoryTravel.getContentsDB(arg_1_0)
	local var_1_0 = {
		"enter_btn_icon",
		"enter_btn_text",
		"background",
		"unlock_enter_btn_condition"
	}
	local var_1_1 = {}
	local var_1_2 = SubstoryManager:findContentsTypeColumn("content_travel")
	
	if var_1_2 then
		var_1_1 = SubstoryManager:getContentsDB(var_1_2, var_1_0)
	end
	
	return var_1_1
end

function SubStoryTravel.isLocked(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_2 then
		local var_2_0 = ((Account:getTravelMissions() or {})[arg_2_1] or {}).state or SUBSTORY_TRAVEL_STATE.ACTIVE
		
		return tonumber(var_2_0) == SUBSTORY_TRAVEL_STATE.INACTIVE
	else
		local var_2_1 = Account:getTravelMissions() or {}
		
		if arg_2_2 and (not var_2_1[arg_2_2] or var_2_1[arg_2_2].state < SUBSTORY_TRAVEL_STATE.REWARDED) then
			return true
		end
	end
	
	return false
end

function SubStoryTravel.isClearedMission(arg_3_0, arg_3_1)
	local var_3_0 = ((Account:getTravelMissions() or {})[arg_3_1] or {}).state or SUBSTORY_TRAVEL_STATE.ACTIVE
	
	return tonumber(var_3_0) >= SUBSTORY_TRAVEL_STATE.CLEAR
end

function SubStoryTravel.isReceivedReward(arg_4_0, arg_4_1)
	local var_4_0 = ((Account:getTravelMissions() or {})[arg_4_1] or {}).state or SUBSTORY_TRAVEL_STATE.ACTIVE
	
	return tonumber(var_4_0) >= SUBSTORY_TRAVEL_STATE.REWARDED
end

function SubStoryTravel.canReceiveReward(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = ((Account:getTravelMissions() or {})[arg_5_1] or {}).state or SUBSTORY_TRAVEL_STATE.ACTIVE
	
	if arg_5_2 then
		var_5_0 = SUBSTORY_TRAVEL_STATE.CLEAR
	end
	
	return tonumber(var_5_0) == SUBSTORY_TRAVEL_STATE.CLEAR
end

function SubStoryTravel.canReceiveRewardQuestNoti(arg_6_0, arg_6_1)
	local var_6_0 = SubstoryManager:getInfo() or {}
	
	if not arg_6_1 or not var_6_0.contents_type_2 or var_6_0.contents_type_2 ~= "content_travel" then
		return 
	end
	
	local var_6_1 = false
	local var_6_2 = Account:getTravelMissions() or {}
	local var_6_3 = false
	
	if table.empty(var_6_2) then
		var_6_3 = true
	end
	
	for iter_6_0 = 1, 99 do
		local var_6_4 = string.format("%s_%03d", arg_6_1, iter_6_0)
		local var_6_5, var_6_6, var_6_7, var_6_8 = DB("substory_travel", var_6_4, {
			"id",
			"condition",
			"value",
			"unlock_predecessor"
		})
		
		if not var_6_5 then
			break
		end
		
		local var_6_9 = not var_6_6 and not var_6_7
		local var_6_10 = SubStoryTravel:isReceivedReward(var_6_4)
		
		var_6_1 = arg_6_0:canReceiveReward(var_6_4, var_6_9) and not var_6_10
		
		if var_6_1 and var_6_8 then
			var_6_1 = SubStoryTravel:isReceivedReward(var_6_8)
		end
		
		if var_6_1 or var_6_3 then
			break
		end
	end
	
	return var_6_1
end

function SubStoryTravel.needToStartTutorial(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = string.format("%s_%03d", arg_7_1, 1)
	
	return arg_7_0:isClearedMission(var_7_0) and not TutorialGuide:isClearedTutorial("travel")
end

function SubStoryTravel.getMissionInfo(arg_8_0, arg_8_1)
	return (Account:getTravelMissions() or {})[arg_8_1] or {}
end
