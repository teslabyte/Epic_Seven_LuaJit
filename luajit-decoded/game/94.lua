SUBSTORY_CUSTOM_MISSION_STATE = {}
SUBSTORY_CUSTOM_MISSION_STATE.INACTIVE = -1
SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE = 0
SUBSTORY_CUSTOM_MISSION_STATE.CLEAR = 1
SUBSTORY_CUSTOM_MISSION_STATE.REWARDED = 2
SubStoryCustomMission = SubStoryCustomMission or {}

copy_functions(SubstoryConditionContents, SubStoryCustomMission)

function SubStoryCustomMission.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.SUBSTORY_CUSTOM_MISSION
end

function SubStoryCustomMission.clear(arg_2_0)
	arg_2_0:removeExpire()
end

function SubStoryCustomMission.createMissoin(arg_3_0, arg_3_1)
	arg_3_0:clear()
	
	if SubStoryCustom:isLinearProgress(arg_3_1) then
		arg_3_0:createLinearMissoin(arg_3_1)
	else
		arg_3_0:createCommonMissoin(arg_3_1)
	end
end

function SubStoryCustomMission.createCommonMissoin(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	for iter_4_0 = 1, 999 do
		local var_4_0 = arg_4_1 .. string.format("_%03d", iter_4_0)
		local var_4_1 = (SubStoryCustom:getMissionInfo(var_4_0) or {}).state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
		
		if tonumber(var_4_1) < tonumber(SUBSTORY_CUSTOM_MISSION_STATE.CLEAR) then
			local var_4_2, var_4_3, var_4_4, var_4_5 = DB("substory_custom_mission", var_4_0, {
				"id",
				"condition",
				"value"
			})
			
			if not var_4_2 then
				break
			end
			
			if var_4_3 and var_4_4 then
				local var_4_6 = arg_4_0:createGroupHandler(var_4_2, var_4_3, var_4_4)
				
				if var_4_6 then
					var_4_6:setSubStoryID(arg_4_1)
				end
			end
		end
	end
end

function SubStoryCustomMission.createLinearMissoin(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0
	
	for iter_5_0 = 1, 999 do
		local var_5_1 = arg_5_1 .. string.format("_%03d", iter_5_0)
		local var_5_2 = SubStoryCustom:getMissionInfo(var_5_1) or {}
		local var_5_3 = var_5_0 == nil or tonumber(var_5_0) == tonumber(SUBSTORY_CUSTOM_MISSION_STATE.REWARDED)
		local var_5_4 = var_5_2.state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
		
		if var_5_3 and tonumber(var_5_4) == tonumber(SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE) then
			local var_5_5, var_5_6, var_5_7 = DB("substory_custom_mission", var_5_1, {
				"id",
				"condition",
				"value"
			})
			
			if not var_5_5 then
				break
			end
			
			if var_5_6 and var_5_7 then
				local var_5_8 = arg_5_0:createGroupHandler(var_5_5, var_5_6, var_5_7)
				
				if var_5_8 then
					var_5_8:setSubStoryID(arg_5_1)
				end
			end
		end
		
		var_5_0 = var_5_4
	end
end

function SubStoryCustomMission.update(arg_6_0, arg_6_1)
	Account:updateSubStoryCustomMission(arg_6_1.contents_id, arg_6_1.mission_info)
	arg_6_0:setUpdateConditionCurScore(arg_6_1.contents_id, nil, arg_6_1.mission_info.score1)
	
	if arg_6_1.state == SUBSTORY_CUSTOM_MISSION_STATE.CLEAR then
		arg_6_0:removeGroup(arg_6_1.contents_id)
	end
end

function SubStoryCustomMission.isCleared(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	
	local var_7_0 = arg_7_0:getState(arg_7_1)
	
	if tonumber(var_7_0) >= tonumber(SUBSTORY_CUSTOM_MISSION_STATE.CLEAR) then
		return true
	end
	
	return false
end

function SubStoryCustomMission.isRewarded(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or {}
	
	local var_8_0 = arg_8_0:getState(arg_8_1)
	
	if tonumber(var_8_0) >= tonumber(SUBSTORY_CUSTOM_MISSION_STATE.REWARDED) then
		return true
	end
	
	return false
end

function SubStoryCustomMission.getScore(arg_9_0, arg_9_1)
	return SubStoryCustom:getMissionInfo(arg_9_1).score1 or 0
end

function SubStoryCustomMission.getState(arg_10_0, arg_10_1)
	return SubStoryCustom:getMissionInfo(arg_10_1).state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE
end

function SubStoryCustomMission.getConditionScore(arg_11_0, arg_11_1, arg_11_2)
	return arg_11_0:getScore(arg_11_1)
end

function SubStoryCustomMission.getNotifierControl(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.contents_id
	local var_12_1 = SubStoryCustom:getMissionInfo(var_12_0)
	local var_12_2
	
	if (var_12_1.state or SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE) == SUBSTORY_CUSTOM_MISSION_STATE.ACTIVE then
		local var_12_3 = string.split(var_12_0, "_")[1]
		local var_12_4 = DB("substory_main", var_12_3, {
			"banner_icon"
		})
		local var_12_5, var_12_6, var_12_7 = DB("substory_custom_mission", var_12_0, {
			"id",
			"name",
			"desc"
		})
		
		var_12_2 = arg_12_0:createNotifyControl(#arg_12_1, var_12_6, var_12_7, var_12_4)
		
		local var_12_8 = {}
		
		table.insert(var_12_8, var_12_6)
		table.insert(var_12_8, var_12_7)
		table.insert(var_12_8, var_12_4)
		
		var_12_2.args = var_12_8
		
		if var_12_2 then
			table.insert(arg_12_1, var_12_2)
		end
	end
	
	return var_12_2
end

function SubStoryCustomMission.createNotifyControl(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = cc.CSLoader:createNode("wnd/achievement_complete_story.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_13_0)
	var_13_0:setAnchorPoint(0, 0)
	var_13_0:setName("achivnoti_" .. arg_13_1)
	var_13_0:setGlobalZOrder(999999)
	var_13_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_13_0, T(arg_13_2), T(arg_13_3))
	if_set_visible(var_13_0, "spr_icon", false)
	if_set_visible(var_13_0, "img_achieve", true)
	
	if arg_13_4 then
		if_set_sprite(var_13_0, "img_achieve", "img/" .. arg_13_4 .. ".png")
	end
	
	return var_13_0
end
