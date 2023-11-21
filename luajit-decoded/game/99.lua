EVENT_MISSION_STATE = {}
EVENT_MISSION_STATE.ACTIVE = 0
EVENT_MISSION_STATE.CLEAR = 1
EVENT_MISSION_STATE.COMPLETE = 2
EventMission = EventMission or {}

copy_functions(ConditionContents, EventMission)

function EventMission.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.EVENT_MISSION
end

function EventMission.initConditionListner(arg_2_0)
	arg_2_0:clear()
	
	local var_2_0 = os.time()
	
	for iter_2_0 = 1, 9999 do
		local var_2_1, var_2_2, var_2_3 = DBN("event_mission_category", iter_2_0, {
			"id",
			"day",
			"d_day"
		})
		
		if not var_2_1 then
			break
		end
		
		local var_2_7
		
		if var_2_1 and var_2_2 and var_2_3 then
			local var_2_4 = Account:getEventTicket(var_2_1)
			local var_2_5 = EventMissionUtil:isForceActiveEvent(var_2_4)
			
			if var_2_4 and (var_2_5 or var_2_4.issued_count == 1) then
				local var_2_6 = var_2_4.issued_tm
				
				if (var_2_1 == "7days_new" or var_2_1 == "7days_return") and var_2_4.vi0 then
					var_2_6 = var_2_4.vi0
				end
				
				var_2_7 = var_2_6 + var_2_3 * 60 * 60 * 24
				
				if var_2_6 <= var_2_0 and var_2_0 < var_2_7 then
					for iter_2_1 = 1, 9999 do
						local var_2_8, var_2_9, var_2_10 = DB("event_mission", string.format("%s_%02d", var_2_1, iter_2_1), {
							"id",
							"condition",
							"value"
						})
						
						if not var_2_8 then
							break
						end
						
						if var_2_9 and var_2_10 then
							arg_2_0:addConditionListner(var_2_1, var_2_8, var_2_9, var_2_10, var_2_7)
						end
					end
				end
			end
		end
	end
end

function EventMission.addConditionListner(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0:getScore(arg_3_2)
	
	if arg_3_0:getState(arg_3_2) == EVENT_MISSION_STATE.ACTIVE then
		arg_3_0:removeGroup(arg_3_2)
		
		local var_3_1 = arg_3_0:createGroupHandler(arg_3_2, arg_3_3, arg_3_4, var_3_0)
		
		if var_3_1 then
			var_3_1:setEventID(arg_3_1)
			var_3_1:setExpireTime(arg_3_5)
		else
			print("EventMission : undefined condition class", arg_3_3, arg_3_2)
		end
	end
end

function EventMission.update(arg_4_0, arg_4_1)
	Account:updateEventMission(arg_4_1.mission_info)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.mission_info.contents_id, nil, arg_4_1.mission_info.score1)
	
	if arg_4_1.mission_info.state == EVENT_MISSION_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1.mission_info.contents_id)
	end
end

function EventMission.isCleared(arg_5_0, arg_5_1)
	return Account:isClearedEventMissionByID(arg_5_1)
end

function EventMission.getScore(arg_6_0, arg_6_1)
	return Account:getScoreEventMissionByID(arg_6_1)
end

function EventMission.getState(arg_7_0, arg_7_1)
	return Account:getStateEventMissoinByID(arg_7_1)
end

function EventMission.getConditionScore(arg_8_0, arg_8_1, arg_8_2)
	return arg_8_0:getScore(arg_8_1)
end

function EventMission.getNotifierControl(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.contents_id
	local var_9_1 = arg_9_0:getState(var_9_0) or EVENT_MISSION_STATE.ACTIVE
	local var_9_2
	local var_9_3 = arg_9_2.mission_info.event_id
	local var_9_4, var_9_5, var_9_6, var_9_7 = DB("event_mission", var_9_0, {
		"id",
		"day",
		"mission_name",
		"mission_desc"
	})
	local var_9_8 = DB("event_mission_category", var_9_3, "bi") or ""
	local var_9_9 = Account:getEventTicket(var_9_3) or {}
	local var_9_10 = true
	
	if var_9_5 > var_9_9.day_count then
		var_9_10 = false
	end
	
	if var_9_1 == EVENT_MISSION_STATE.ACTIVE and var_9_10 then
		var_9_2 = arg_9_0:createNotifyControl(#arg_9_1, var_9_6, var_9_7, var_9_8)
		
		local var_9_11 = {}
		
		table.insert(var_9_11, var_9_6)
		table.insert(var_9_11, var_9_7)
		table.insert(var_9_11, var_9_8)
		
		var_9_2.args = var_9_11
		
		if var_9_2 then
			table.insert(arg_9_1, var_9_2)
		end
	end
	
	return var_9_2
end

function EventMission.createNotifyControl(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = cc.CSLoader:createNode("wnd/achievement_complete_etc.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_10_0)
	var_10_0:setAnchorPoint(0, 0)
	var_10_0:setName("achivnoti_" .. arg_10_1)
	var_10_0:setGlobalZOrder(999999)
	var_10_0:setLocalZOrder(999999)
	
	local var_10_1 = var_10_0:getChildByName("n_we")
	
	if_set_visible(var_10_1, nil, true)
	UIUtil:setNotifyTextControl(var_10_1, T(arg_10_2), T(arg_10_3))
	if_set_visible(var_10_0, "bar1", false)
	if_set_visible(var_10_0, "txt_title", false)
	if_set_visible(var_10_0, "txt_desc", false)
	if_set_visible(var_10_0, "spr_emblem", false)
	if_set_visible(var_10_0, "n_face", false)
	if_set_sprite(var_10_1, "n_bi", "banner/" .. arg_10_4 .. ".png")
	
	return var_10_0
end
