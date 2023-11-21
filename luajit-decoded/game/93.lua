SUBSTORY_TRAVEL_STATE = {}
SUBSTORY_TRAVEL_STATE.INACTIVE = -1
SUBSTORY_TRAVEL_STATE.ACTIVE = 0
SUBSTORY_TRAVEL_STATE.CLEAR = 1
SUBSTORY_TRAVEL_STATE.REWARDED = 2
SubStoryTravelMission = SubStoryTravelMission or {}

copy_functions(SubstoryConditionContents, SubStoryTravelMission)

function SubStoryTravelMission.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.SUBSTORY_TRAVEL
end

function SubStoryTravelMission.clear(arg_2_0)
	arg_2_0:removeExpire()
end

function SubStoryTravelMission.createMissoin(arg_3_0, arg_3_1)
	arg_3_0:clear()
	
	for iter_3_0 = 1, 999 do
		local var_3_0 = arg_3_1 .. string.format("_%03d", iter_3_0)
		local var_3_1 = SubStoryTravel:getMissionInfo(var_3_0) or {}
		
		if tonumber(var_3_1.state or SUBSTORY_TRAVEL_STATE.ACTIVE) < tonumber(SUBSTORY_TRAVEL_STATE.CLEAR) then
			local var_3_2, var_3_3, var_3_4, var_3_5 = DB("substory_travel", var_3_0, {
				"id",
				"condition",
				"value",
				"unlock_state_id"
			})
			
			if not var_3_2 then
				break
			end
			
			if var_3_3 and var_3_4 then
				local var_3_6 = arg_3_0:createGroupHandler(var_3_2, var_3_3, var_3_4)
				
				if var_3_6 then
					var_3_6:setSubStoryID(arg_3_1)
				end
			end
		end
	end
end

function SubStoryTravelMission.update(arg_4_0, arg_4_1)
	Account:updateSubStoryTravelMission(arg_4_1.contents_id, arg_4_1.mission_info)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.contents_id, nil, arg_4_1.mission_info.score1)
	
	if arg_4_1.state == SUBSTORY_TRAVEL_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1.contents_id)
	end
end

function SubStoryTravelMission.isCleared(arg_5_0, arg_5_1, arg_5_2)
	arg_5_2 = arg_5_2 or {}
	
	local var_5_0 = arg_5_0:getState(arg_5_1)
	
	if tonumber(var_5_0) >= tonumber(SUBSTORY_TRAVEL_STATE.CLEAR) then
		return true
	end
	
	return false
end

function SubStoryTravelMission.isRewarded(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or {}
	
	local var_6_0 = arg_6_0:getState(arg_6_1)
	
	if tonumber(var_6_0) >= tonumber(SUBSTORY_TRAVEL_STATE.REWARDED) then
		return true
	end
	
	return false
end

function SubStoryTravelMission.getScore(arg_7_0, arg_7_1)
	return SubStoryTravel:getMissionInfo(arg_7_1).score1 or 0
end

function SubStoryTravelMission.getState(arg_8_0, arg_8_1)
	return SubStoryTravel:getMissionInfo(arg_8_1).state or SUBSTORY_TRAVEL_STATE.ACTIVE
end

function SubStoryTravelMission.getConditionScore(arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0:getScore(arg_9_1)
end

function SubStoryTravelMission.getNotifierControl(arg_10_0, arg_10_1, arg_10_2)
end
