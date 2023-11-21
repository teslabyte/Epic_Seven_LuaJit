DestinyAchieve = DestinyAchieve or {}

copy_functions(ConditionContents, DestinyAchieve)

function DestinyAchieve.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.DESTINY
end

function DestinyAchieve.initConditionListner(arg_2_0)
	arg_2_0:clear()
	
	local var_2_0 = Destiny:loadCategoryDB()
	
	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		for iter_2_2 = 1, GAME_STATIC_VARIABLE.destiny_mission_count_limit do
			local var_2_1 = string.format(iter_2_1.id .. "_%02d", iter_2_2)
			local var_2_2, var_2_3, var_2_4 = DB("destiny_mission", var_2_1, {
				"id",
				"condition",
				"value"
			})
			
			if not var_2_2 then
				break
			end
			
			if var_2_3 and var_2_4 then
				arg_2_0:addConditionListner(var_2_1, var_2_3, var_2_4)
			end
		end
	end
end

function DestinyAchieve.addConditionListner(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Account:getDestinyAchieve(arg_3_1)
	local var_3_1 = arg_3_0:getScore(arg_3_1)
	local var_3_2 = var_3_0.state
	
	if var_3_0.state == 0 then
		arg_3_0:removeGroup(arg_3_1)
		
		if arg_3_0:createGroupHandler(arg_3_1, arg_3_2, arg_3_3, var_3_1) then
		else
			print("SysAchievement : undefined condition class", arg_3_2, arg_3_1)
		end
	end
end

function DestinyAchieve.isCleared(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2 = arg_4_2 or {}
	
	local var_4_0 = Account:getDestinyAchieve(arg_4_1)
	
	if var_4_0 and var_4_0.state >= 1 then
		return true
	end
	
	return false
end

function DestinyAchieve.getNotifierControl(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.achieve_id
	local var_5_1 = string.sub(var_5_0, 1, -4)
	local var_5_2, var_5_3 = DB("destiny_category", var_5_1, {
		"con_stage",
		"char_id"
	})
	local var_5_4 = Account:getDestinyAchieve(var_5_0).state or 0
	local var_5_5 = true
	local var_5_6
	
	if var_5_2 and not DEBUG.MAP_DEBUG and not Account:isMapCleared(var_5_2) then
		var_5_5 = false
	end
	
	if var_5_5 and var_5_4 == 0 then
		local var_5_7, var_5_8 = DB("destiny_mission", var_5_0, {
			"category_name",
			"mission_name"
		})
		
		var_5_6 = arg_5_0:createNotifyControl(#arg_5_1, var_5_7, var_5_8, var_5_3)
		
		local var_5_9 = {}
		
		table.insert(var_5_9, var_5_7)
		table.insert(var_5_9, var_5_8)
		table.insert(var_5_9, var_5_3)
		
		var_5_6.args = var_5_9
		
		if var_5_6 then
			table.insert(arg_5_1, var_5_6)
		end
	end
	
	return var_5_6
end

function DestinyAchieve.createNotifyControl(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = cc.CSLoader:createNode("wnd/achievement_complete_etc.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_6_0)
	var_6_0:setAnchorPoint(0, 0)
	var_6_0:setName("achivnoti_" .. arg_6_1)
	var_6_0:setGlobalZOrder(999999)
	var_6_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_6_0, T(arg_6_2), T(arg_6_3))
	if_set_visible(var_6_0, "spr_emblem", false)
	if_set_visible(var_6_0, "n_face", true)
	UIUtil:getRewardIcon(nil, arg_6_4, {
		no_popup = true,
		no_grade = true,
		parent = var_6_0:getChildByName("n_face")
	})
	
	return var_6_0
end

function DestinyAchieve.update(arg_7_0, arg_7_1)
	Account:setDestinyAchieve(arg_7_1.achieve_id, arg_7_1.achieve_doc)
	arg_7_0:setUpdateConditionCurScore(arg_7_1.achieve_id, nil, arg_7_1.achieve_doc.score1)
	
	if arg_7_1.achieve_doc.state >= 1 then
		arg_7_0:removeGroup(arg_7_1.achieve_id)
	end
end

function DestinyAchieve.checkState(arg_8_0, arg_8_1)
	local var_8_0 = {}
	local var_8_1 = arg_8_1.db_data
	
	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		local var_8_2 = arg_8_0:getScore(iter_8_1.achieve_id)
		local var_8_3 = totable(iter_8_1.achieve_db.value).count
		local var_8_4 = Account:getDestinyAchieve(iter_8_1.achieve_id).state
		
		if to_n(var_8_2) >= to_n(var_8_3) and var_8_4 == 0 then
			table.insert(var_8_0, {
				id = iter_8_1.achieve_id
			})
		end
	end
	
	return var_8_0
end

function DestinyAchieve.getScore(arg_9_0, arg_9_1)
	local var_9_0 = Account:getDestinyAchieveData()
	
	if var_9_0[arg_9_1] == nil then
		return 0
	end
	
	local var_9_1, var_9_2 = DB("destiny_mission", arg_9_1, {
		"condition",
		"value"
	})
	
	return arg_9_0:getScore_datas(var_9_0, arg_9_1, var_9_1, var_9_2)
end

function DestinyAchieve.getConditionScore(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or 1
	
	local var_10_0 = Account:getDestinyAchieveData()
	
	return arg_10_0:getConditionScore_datas(var_10_0, arg_10_1, arg_10_2)
end
