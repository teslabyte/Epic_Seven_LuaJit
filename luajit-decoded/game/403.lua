SubStoryCustom = SubStoryCustom or {}

function MsgHandler.substory_custom_mission_complete(arg_1_0)
	if arg_1_0.rewards then
		local var_1_0 = {
			desc = T("msg_substory_custom_mission_reward")
		}
		
		Account:addReward(arg_1_0.rewards, {
			play_reward_data = var_1_0,
			handler = function()
				if arg_1_0.info and arg_1_0.info.contents_id then
					SubStoryInferenceNote:show_effect_clue(arg_1_0.info.contents_id)
				end
				
				TutorialGuide:procGuide()
			end
		})
	end
	
	if arg_1_0.info then
		Account:updateSubStoryCustomMission(arg_1_0.info.contents_id, arg_1_0.info)
	end
	
	if SubStoryCustom:isLinearProgress(arg_1_0.substory_id) then
		ConditionContentsManager:initSubStoryCustomMission(arg_1_0.substory_id)
	end
	
	SubStoryInferenceNote:res_query("substory_custom_mission_complete", arg_1_0)
end

function SubStoryCustom.isClearedMission(arg_3_0, arg_3_1)
	local var_3_0 = ((Account:getCustomMissions() or {})[arg_3_1] or {}).state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
	
	return tonumber(var_3_0) >= SUBSTORY_CUSTOM_MISSION_STATE.CLEAR
end

function SubStoryCustom.isReceivedReward(arg_4_0, arg_4_1)
	local var_4_0 = ((Account:getCustomMissions() or {})[arg_4_1] or {}).state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
	
	return tonumber(var_4_0) >= SUBSTORY_CUSTOM_MISSION_STATE.REWARDED
end

function SubStoryCustom.getMissionInfo(arg_5_0, arg_5_1)
	return (Account:getCustomMissions() or {})[arg_5_1] or {}
end

function SubStoryCustom.checkNoti(arg_6_0)
	local var_6_0 = (SubstoryManager:getInfo() or {}).id
	local var_6_1 = Account:getCustomMissions()
	local var_6_2 = 0
	
	if not var_6_0 then
		return 
	end
	
	if table.empty(var_6_1) then
		local var_6_3 = string.format("%s_%03d", var_6_0, 1)
		local var_6_4, var_6_5, var_6_6 = DB("substory_custom_mission", var_6_3, {
			"id",
			"give_code",
			"give_count"
		})
		
		if var_6_4 and var_6_5 and var_6_6 and tonumber(var_6_6) <= Account:getPropertyCount(var_6_5) then
			return true
		end
	else
		for iter_6_0, iter_6_1 in pairs(var_6_1) do
			var_6_2 = var_6_2 + 1
			
			if arg_6_0:isClearedMission(iter_6_1.contents_id) and not arg_6_0:isReceivedReward(iter_6_1.contents_id) then
				return true
			end
		end
	end
	
	local var_6_7 = var_6_2 + 1
	local var_6_8 = string.format("%s_%03d", var_6_0, var_6_7)
	local var_6_9, var_6_10, var_6_11 = DB("substory_custom_mission", var_6_8, {
		"id",
		"give_code",
		"give_count"
	})
	
	if var_6_9 and var_6_10 and var_6_11 and tonumber(var_6_11) <= Account:getPropertyCount(var_6_10) then
		return true
	end
	
	if SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.INFERENCE) and SubStoryInferenceNote:checkNewNoteNoti() then
		return true
	end
end

function SubStoryCustom.isLinearProgress(arg_7_0, arg_7_1)
	return DB("substory_custom_mission", string.format("%s_001", arg_7_1), {
		"mission_linear_progress"
	}) == string.trim("y")
end

function SubStoryCustom.onUpdateUI(arg_8_0)
	SubStoryInferenceNote:onUpdateUI()
end

function SubStoryCustom.isActiveMission(arg_9_0, arg_9_1)
	local var_9_0, var_9_1 = DB("substory_custom_mission", arg_9_1, {
		"id",
		"mission_linear_progress"
	})
	
	if not var_9_0 then
		return false
	end
	
	if var_9_1 == "y" then
		local var_9_2 = string.split(arg_9_1, "_")
		
		if var_9_2[1] then
			return SubStoryCustom:getLinearActiveMission(var_9_2[1]) == arg_9_1
		end
	else
		return (arg_9_0:getMissionInfo(arg_9_1).state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE) == SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
	end
end

function SubStoryCustom.getLinearActiveMission(arg_10_0, arg_10_1)
	local var_10_0
	
	for iter_10_0 = 1, 999 do
		local var_10_1 = arg_10_1 .. string.format("_%03d", iter_10_0)
		local var_10_2 = SubStoryCustom:getMissionInfo(var_10_1) or {}
		local var_10_3 = var_10_0 == nil or tonumber(var_10_0) == tonumber(SUBSTORY_CUSTOM_MISSION_STATE.REWARDED)
		local var_10_4 = var_10_2.state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
		
		if var_10_3 and tonumber(var_10_4) == tonumber(SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE) then
			local var_10_5, var_10_6, var_10_7 = DB("substory_custom_mission", var_10_1, {
				"id",
				"condition",
				"value"
			})
			
			if not var_10_5 then
				break
			end
			
			if var_10_6 and var_10_7 then
				return var_10_1
			end
		end
		
		var_10_0 = var_10_4
	end
end
