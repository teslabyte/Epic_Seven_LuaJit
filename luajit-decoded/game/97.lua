SUBSTORY_ALBUM_STATE = {}
SUBSTORY_ALBUM_STATE.ACTIVE = 0
SUBSTORY_ALBUM_STATE.CLEAR = 1
SubStoryAlbumMisson = SubStoryAlbumMisson or {}

copy_functions(ConditionContents, SubStoryAlbumMisson)

function SubStoryAlbumMisson.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.SUBSTROY_ALBUM
end

function SubStoryAlbumMisson.createGroupHandler(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0.condition_groups = arg_2_0.condition_groups or {}
	
	if arg_2_0.condition_groups[arg_2_1] then
		return 
	end
	
	local var_2_0 = ConditionGroup(arg_2_0, arg_2_1, arg_2_0.contents_type, arg_2_2, arg_2_3)
	
	var_2_0.substory_id = arg_2_4
	arg_2_0.condition_groups[arg_2_1] = var_2_0
	
	local var_2_1 = var_2_0:getHandlerList()
	
	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		local var_2_2 = iter_2_1:getAcceptEvents()
		
		arg_2_0.events_map = arg_2_0.events_map or {}
		
		for iter_2_2, iter_2_3 in pairs(var_2_2) do
			if not arg_2_0.events_map[iter_2_3] then
				arg_2_0.events_map[iter_2_3] = {}
			end
			
			table.insert(arg_2_0.events_map[iter_2_3], iter_2_1)
		end
	end
	
	return var_2_0
end

function SubStoryAlbumMisson.initConditionListner(arg_3_0)
	arg_3_0:clear()
	
	local var_3_0 = Account:getSubStoryAlbumMissions()
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		for iter_3_2 = 1, 3 do
			if iter_3_1["mission_id" .. tostring(iter_3_2)] and iter_3_1["piece" .. tostring(iter_3_2)] then
				local var_3_1 = iter_3_1["mission_id" .. tostring(iter_3_2)]
				local var_3_2 = GlobalSubstoryManager:isActiveSchedule(iter_3_0)
				local var_3_3 = iter_3_1["mission_state" .. tostring(iter_3_2)]
				
				if var_3_1 and var_3_2 and tonumber(var_3_3 or SUBSTORY_ALBUM_STATE.ACTIVE) < tonumber(SUBSTORY_ALBUM_STATE.CLEAR) then
					local var_3_4, var_3_5, var_3_6 = DB("substory_album_mission", var_3_1, {
						"id",
						"condition",
						"value"
					})
					
					if var_3_4 and var_3_5 and var_3_6 then
						local var_3_7 = arg_3_0:createGroupHandler(var_3_4, var_3_5, var_3_6, iter_3_0)
						local var_3_8 = SubstoryManager:getScheduleExpireTime(iter_3_0)
						
						var_3_7:setExpireTime(var_3_8)
						var_3_7:setSubStoryID(iter_3_0)
					end
				end
			end
		end
	end
end

function SubStoryAlbumMisson.update(arg_4_0, arg_4_1)
	Account:updateSubStoryAlbumMission(arg_4_1.substory_id, arg_4_1.contents_id, arg_4_1.score, arg_4_1.state)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.contents_id, nil, arg_4_1.score)
	
	if arg_4_1.state == SUBSTORY_ALBUM_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1.contents_id)
	end
end

function SubStoryAlbumMisson.isCleared(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_3 = arg_5_3 or {}
	
	local var_5_0 = Account:getSubStoryAlbumMissions()
	
	if not var_5_0 then
		Log.e("SubStoryAlbumMisson.isCleared", "no_data")
		
		return 
	end
	
	local var_5_1 = var_5_0[arg_5_1]
	
	for iter_5_0 = 1, 3 do
		if var_5_1["mission_id" .. tostring(iter_5_0)] == arg_5_2 then
			local var_5_2 = var_5_1["mission_state" .. tostring(iter_5_0)]
			
			if tonumber(var_5_2 or SUBSTORY_ALBUM_STATE.ACTIVE) >= tonumber(SUBSTORY_ALBUM_STATE.CLEAR) then
				return true
			end
		end
	end
	
	return false
end

function SubStoryAlbumMisson.getScore(arg_6_0, arg_6_1)
	return Account:getSubStoryAlbumMissionInfoData("score", nil, arg_6_1)
end

function SubStoryAlbumMisson.getState(arg_7_0, arg_7_1)
	return Account:getSubStoryAlbumMissionInfoData("state", nil, arg_7_1)
end

function SubStoryAlbumMisson.getConditionScore(arg_8_0, arg_8_1, arg_8_2)
	return arg_8_0:getScore(arg_8_1)
end

function SubStoryAlbumMisson.getNotifierControl(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.contents_id
	local var_9_1 = arg_9_0:getState(var_9_0)
	local var_9_2
	
	if (var_9_1 or SUBSTORY_ALBUM_STATE.ACTIVE) == SUBSTORY_ALBUM_STATE.ACTIVE then
		local var_9_3 = arg_9_2.substory_id
		local var_9_4, var_9_5 = DB("substory_main", var_9_3, {
			"name",
			"banner_icon"
		})
		local var_9_6, var_9_7, var_9_8 = DB("substory_album_mission", var_9_0, {
			"id",
			"mission_desc",
			"value"
		})
		
		var_9_2 = arg_9_0:createNotifyControl(#arg_9_1, var_9_4, var_9_7, var_9_5, var_9_8)
		
		local var_9_9 = {}
		
		table.insert(var_9_9, var_9_4)
		table.insert(var_9_9, var_9_7)
		table.insert(var_9_9, var_9_5)
		table.insert(var_9_9, var_9_8)
		
		var_9_2.args = var_9_9
		
		if var_9_2 then
			table.insert(arg_9_1, var_9_2)
		end
	end
	
	return var_9_2
end

function SubStoryAlbumMisson.createNotifyControl(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if not arg_10_4 then
		return 
	end
	
	local var_10_0 = cc.CSLoader:createNode("wnd/achievement_complete_story.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_10_0)
	var_10_0:setAnchorPoint(0, 0)
	var_10_0:setName("achivnoti_" .. arg_10_1)
	var_10_0:setGlobalZOrder(999999)
	var_10_0:setLocalZOrder(999999)
	
	local var_10_1 = totable(arg_10_5)
	
	UIUtil:setNotifyTextControl(var_10_0, T(arg_10_2), T(arg_10_3, {
		count = comma_value(var_10_1.count)
	}))
	if_set_sprite(var_10_0, "spr_icon", "banner/" .. arg_10_4 .. ".png")
	
	return var_10_0
end
