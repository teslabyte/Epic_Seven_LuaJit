SUBSTORY_FESTIVAL_STATE = {}
SUBSTORY_FESTIVAL_STATE.INACTIVE = -1
SUBSTORY_FESTIVAL_STATE.ACTIVE = 0
SUBSTORY_FESTIVAL_STATE.CLEAR = 1
SUBSTORY_FESTIVAL_STATE.REWARDED = 2
SubStoryMissionFestival = SubStoryMissionFestival or {}

copy_functions(SubstoryConditionContents, SubStoryMissionFestival)

function SubStoryMissionFestival.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.FESTIVAL_FM
end

function SubStoryMissionFestival.clear(arg_2_0)
	arg_2_0:removeExpire()
end

function SubStoryMissionFestival.createMissoin(arg_3_0)
	arg_3_0:clear()
	
	local var_3_0 = Account:getSubStoryFestivals() or {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		for iter_3_2 = 1, 3 do
			local var_3_1 = iter_3_1["mission_id" .. tostring(iter_3_2)]
			
			if var_3_1 then
				local var_3_2 = iter_3_1["mission_state" .. tostring(iter_3_2)] or SUBSTORY_FESTIVAL_STATE.INACTIVE
				
				if tonumber(var_3_2) == tonumber(SUBSTORY_FESTIVAL_STATE.ACTIVE) then
					local var_3_3, var_3_4, var_3_5 = DB("substory_festival_mission", var_3_1, {
						"id",
						"condition",
						"value"
					})
					
					if var_3_3 and var_3_4 and var_3_5 then
						local var_3_6 = arg_3_0:createGroupHandler(var_3_3, var_3_4, var_3_5)
						
						if var_3_6 then
							var_3_6:setSubStoryID(iter_3_0)
						end
					end
				end
			end
		end
	end
end

function SubStoryMissionFestival.update(arg_4_0, arg_4_1)
	Account:updateSubStoryFestivalMission(arg_4_1.substory_id, arg_4_1.contents_id, arg_4_1.score, arg_4_1.state)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.contents_id, nil, arg_4_1.score)
	
	if arg_4_1.state == SUBSTORY_FESTIVAL_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1.contents_id)
	end
end

function SubStoryMissionFestival.isCleared(arg_5_0, arg_5_1, arg_5_2)
	arg_5_2 = arg_5_2 or {}
	
	local var_5_0 = arg_5_0:getState()
	
	if tonumber(var_5_0) >= tonumber(SUBSTORY_FESTIVAL_STATE.CLEAR) then
		return true
	end
	
	return false
end

function SubStoryMissionFestival.isRewarded(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or {}
	
	local var_6_0 = arg_6_0:getState()
	
	if tonumber(var_6_0) >= tonumber(SUBSTORY_FESTIVAL_STATE.REWARDED) then
		return true
	end
	
	return false
end

function SubStoryMissionFestival.getScore(arg_7_0, arg_7_1)
	return (Account:getSubStoryFestivalMissionInfo(nil, arg_7_1) or {}).score or 0
end

function SubStoryMissionFestival.getState(arg_8_0, arg_8_1)
	return (Account:getSubStoryFestivalMissionInfo(nil, arg_8_1) or {}).state or SUBSTORY_FESTIVAL_STATE.INACTIVE
end

function SubStoryMissionFestival.getConditionScore(arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0:getScore(arg_9_1)
end

function SubStoryMissionFestival.getNotifierControl(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.contents_id
	local var_10_1 = arg_10_0:getState(var_10_0)
	local var_10_2
	
	if var_10_1 == SUBSTORY_FESTIVAL_STATE.ACTIVE then
		local var_10_3 = string.split(var_10_0, "_")[1]
		local var_10_4, var_10_5 = DB("substory_main", var_10_3, {
			"name",
			"banner_icon"
		})
		local var_10_6, var_10_7 = DB("substory_festival_mission", var_10_0, {
			"mission_desc",
			"value"
		})
		
		var_10_2 = arg_10_0:createNotifyControl(#arg_10_1, var_10_4, var_10_6, var_10_5, totable(var_10_7))
		
		local var_10_8 = {}
		
		table.insert(var_10_8, var_10_4)
		table.insert(var_10_8, var_10_6)
		table.insert(var_10_8, var_10_5)
		table.insert(var_10_8, totable(var_10_7))
		
		var_10_2.args = var_10_8
		
		if var_10_2 then
			table.insert(arg_10_1, var_10_2)
		end
	end
	
	return var_10_2
end

function SubStoryMissionFestival.createNotifyControl(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = cc.CSLoader:createNode("wnd/achievement_complete_story.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_11_0)
	var_11_0:setAnchorPoint(0, 0)
	var_11_0:setName("achivnoti_" .. arg_11_1)
	var_11_0:setGlobalZOrder(999999)
	var_11_0:setLocalZOrder(999999)
	
	if arg_11_5 then
		UIUtil:setNotifyTextControl(var_11_0, T(arg_11_2), T(arg_11_3, {
			count = arg_11_5.count
		}))
	else
		UIUtil:setNotifyTextControl(var_11_0, T(arg_11_2), T(arg_11_3))
	end
	
	if arg_11_4 then
		if_set_sprite(var_11_0, "spr_icon", "banner/" .. arg_11_4 .. ".png")
	end
	
	return var_11_0
end
