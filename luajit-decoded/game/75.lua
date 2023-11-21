EPISODE_MISSION_STATE = {}
EPISODE_MISSION_STATE.ACTIVE = 0
EPISODE_MISSION_STATE.CLEAR = 1
EPISODE_MISSION_STATE.COMPLETE = 2
EpisodeMission = EpisodeMission or {}

copy_functions(ConditionContents, EpisodeMission)

function EpisodeMission.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.EPISODE_MISSION
end

function EpisodeMission.initConditionListner(arg_2_0)
	arg_2_0:clear()
	
	local var_2_0 = Account:getAdinChapters() or {}
	
	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		local var_2_1
		
		if iter_2_1.state == 0 then
			var_2_1 = DB("episode_adin", iter_2_1.chapter_id, "mission_table_id")
			
			for iter_2_2 = 1, 9999 do
				if not var_2_1 then
					break
				end
				
				local var_2_2, var_2_3, var_2_4 = DB("episode_mission", string.format("%s_%d", var_2_1, iter_2_2), {
					"id",
					"condition",
					"value"
				})
				
				if not var_2_2 then
					break
				end
				
				if var_2_3 and var_2_4 then
					arg_2_0:addConditionListner(var_2_2, var_2_3, var_2_4)
				end
			end
		end
	end
end

function EpisodeMission.addConditionListner(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0:getScore(arg_3_1)
	
	if arg_3_0:getState(arg_3_1) == EPISODE_MISSION_STATE.ACTIVE then
		arg_3_0:removeGroup(arg_3_1)
		
		if arg_3_0:createGroupHandler(arg_3_1, arg_3_2, arg_3_3, var_3_0) then
		else
			print("SysAchievement : undefined condition class", arg_3_2, arg_3_1)
		end
	end
end

function EpisodeMission.update(arg_4_0, arg_4_1)
	Account:updateEpisodeMission(arg_4_1.mission_info)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.mission_info.contents_id, nil, arg_4_1.mission_info.score1)
	
	if arg_4_1.mission_info.state == EPISODE_MISSION_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1.mission_info.contents_id)
	end
end

function EpisodeMission.isCleared(arg_5_0, arg_5_1)
	return ((Account:getEpisodeMissionByID(arg_5_1) or {}).state or EPISODE_MISSION_STATE.ACTIVE) >= EPISODE_MISSION_STATE.CLEAR
end

function EpisodeMission.getScore(arg_6_0, arg_6_1)
	return (Account:getEpisodeMissionByID(arg_6_1) or {}).score1 or 0
end

function EpisodeMission.getState(arg_7_0, arg_7_1)
	return (Account:getEpisodeMissionByID(arg_7_1) or {}).state or EPISODE_MISSION_STATE.ACTIVE
end

function EpisodeMission.getConditionScore(arg_8_0, arg_8_1, arg_8_2)
	return arg_8_0:getScore(arg_8_1)
end

function EpisodeMission.getNotifierControl(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.contents_id
	local var_9_1 = arg_9_0:getState(var_9_0)
	local var_9_2
	
	if (var_9_1 or EPISODE_MISSION_STATE.ACTIVE) == EPISODE_MISSION_STATE.ACTIVE then
		local var_9_3, var_9_4, var_9_5 = DB("episode_mission", var_9_0, {
			"id",
			"name",
			"desc"
		})
		
		var_9_2 = arg_9_0:createNotifyControl(#arg_9_1, var_9_4, var_9_5)
		
		local var_9_6 = {}
		
		table.insert(var_9_6, var_9_4)
		table.insert(var_9_6, var_9_5)
		
		var_9_2.args = var_9_6
		
		if var_9_2 then
			table.insert(arg_9_1, var_9_2)
		end
	end
	
	return var_9_2
end

function EpisodeMission.createNotifyControl(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = cc.CSLoader:createNode("wnd/achievement_complete.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_10_0)
	var_10_0:setAnchorPoint(0, 0)
	var_10_0:setName("achivnoti_" .. arg_10_1)
	var_10_0:setGlobalZOrder(999999)
	var_10_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_10_0, T(arg_10_2), T(arg_10_3))
	
	local var_10_1 = var_10_0:getChildByName("n_face")
	
	if_set_visible(var_10_1, nil, true)
	UIUtil:getRewardIcon(nil, "c3143", {
		no_popup = true,
		no_grade = true,
		parent = var_10_1
	})
	
	return var_10_0
end

function EpisodeMission.checkState(arg_11_0, arg_11_1)
	local var_11_0 = {}
	local var_11_1 = arg_11_1.db_data
	
	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		local var_11_2 = Account:getEpisodeMissionByID(iter_11_1.id)
		
		if var_11_2 and iter_11_1.value and iter_11_1.value.count then
			local var_11_3 = arg_11_0:getScore(iter_11_1.id)
			local var_11_4 = iter_11_1.value.count
			
			if to_n(var_11_3) >= to_n(var_11_4) and var_11_2.state == EPISODE_MISSION_STATE.ACTIVE then
				table.insert(var_11_0, {
					id = iter_11_1.id
				})
			end
		end
	end
	
	return var_11_0
end
