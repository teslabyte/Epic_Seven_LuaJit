GROWTH_GUIDE_QUEST = {}
GROWTH_GUIDE_QUEST.INACTIVE = -1
GROWTH_GUIDE_QUEST.ACTIVE = 0
GROWTH_GUIDE_QUEST.CLEAR = 1
GROWTH_GUIDE_QUEST.REWARDED = 2
GrowthGuideQuest = GrowthGuideQuest or {}

copy_functions(ConditionContents, GrowthGuideQuest)

function GrowthGuideQuest.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.GROWTH_GUIDE_QUEST
end

function GrowthGuideQuest.isValidate(arg_2_0, arg_2_1)
	return true
end

function GrowthGuideQuest.initConditionListner(arg_3_0)
	arg_3_0:clear()
	
	for iter_3_0 = 1, 99 do
		local var_3_0, var_3_1, var_3_2 = DBN("guidequest_group", iter_3_0, {
			"id",
			"group_unlock_condition",
			"group_unlock_stage_condition"
		})
		
		if not var_3_0 then
			break
		end
		
		local var_3_3
		
		if var_3_1 or var_3_2 then
			if var_3_2 and Account:isMapCleared(var_3_2) then
				var_3_3 = true
			elseif var_3_1 and GrowthGuide:isClearAllQuests(var_3_1) then
				var_3_3 = true
			end
		else
			var_3_3 = true
		end
		
		if var_3_3 then
			for iter_3_1 = 1, 999 do
				local var_3_4 = string.format("%s_%02d", var_3_0, iter_3_1)
				local var_3_5 = arg_3_0:isCleared(var_3_4)
				local var_3_6, var_3_7, var_3_8, var_3_9 = DB("guidequest_mission", var_3_4, {
					"id",
					"condition",
					"value",
					"unknown_type_jpn"
				})
				
				if not var_3_6 then
					break
				end
				
				local var_3_10 = Account:isJPN()
				local var_3_11 = not var_3_10 or var_3_10 and not var_3_9
				
				if var_3_7 and var_3_8 and not var_3_5 and var_3_11 then
					arg_3_0:addConditionListner(var_3_6, var_3_7, var_3_8)
				end
			end
		end
	end
end

function GrowthGuideQuest.addConditionListner(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0:getScore(arg_4_1)
	
	arg_4_0:removeGroup(arg_4_1)
	
	if arg_4_0:createGroupHandler(arg_4_1, arg_4_2, arg_4_3, var_4_0) then
	else
		print("GrowthGuideQuest : undefined condition class", arg_4_2, arg_4_1)
	end
end

function GrowthGuideQuest.isCheckState(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Account:getGrowthGuideQuest(arg_5_1)
	
	if var_5_0 and arg_5_2 <= var_5_0.state then
		return true
	end
	
	return false
end

function GrowthGuideQuest.isCleared(arg_6_0, arg_6_1)
	return arg_6_0:isCheckState(arg_6_1, GROWTH_GUIDE_QUEST.CLEAR)
end

function GrowthGuideQuest.isRewarded(arg_7_0, arg_7_1)
	return arg_7_0:isCheckState(arg_7_1, GROWTH_GUIDE_QUEST.REWARDED)
end

function GrowthGuideQuest.createNotifyControl(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = cc.CSLoader:createNode("wnd/achievement_complete.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_8_0)
	var_8_0:setAnchorPoint(0, 0)
	var_8_0:setName("achivnoti_" .. arg_8_1)
	var_8_0:setGlobalZOrder(999999)
	var_8_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_8_0, T(arg_8_2), T(arg_8_3))
	
	if arg_8_4 then
		if_set_sprite(var_8_0, "n_faction", "img/" .. arg_8_4 .. ".png")
	end
	
	return var_8_0
end

function GrowthGuideQuest.getNotifierControl(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.contents_id
	local var_9_1 = Account:getGrowthGuideQuest(var_9_0).state or 0
	local var_9_2
	local var_9_3 = false
	local var_9_4 = GrowthGuide:getGroupDB()
	
	for iter_9_0, iter_9_1 in pairs(var_9_4) do
		if var_9_0 == GrowthGuide:getCurrentQuestIDByGroupID(iter_9_0) then
			var_9_3 = true
			
			break
		end
	end
	
	if var_9_1 == 0 and var_9_3 then
		local var_9_5, var_9_6 = DB("guidequest_group", arg_9_2.quest_doc.group_id, {
			"group_icon",
			"group_name"
		})
		local var_9_7 = DB("guidequest_mission", var_9_0, {
			"quest_name"
		})
		
		var_9_2 = arg_9_0:createNotifyControl(#arg_9_1, var_9_6, var_9_7, var_9_5)
		
		local var_9_8 = {}
		
		table.insert(var_9_8, var_9_6)
		table.insert(var_9_8, var_9_7)
		table.insert(var_9_8, var_9_5)
		
		var_9_2.args = var_9_8
		
		if var_9_2 then
			table.insert(arg_9_1, var_9_2)
		end
	end
	
	return var_9_2
end

function GrowthGuideQuest.update(arg_10_0, arg_10_1)
	Account:setGrowthGuideQuest(arg_10_1.contents_id, arg_10_1.quest_doc)
	arg_10_0:setUpdateConditionCurScore(arg_10_1.contents_id, nil, arg_10_1.quest_doc.score1)
	
	if arg_10_1.quest_doc and arg_10_1.quest_doc.state >= 1 then
		arg_10_0:removeGroup(arg_10_1.contents_id)
	end
end

function GrowthGuideQuest.checkState(arg_11_0, arg_11_1)
	local var_11_0 = {}
	local var_11_1 = arg_11_1.db_data
	
	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		local var_11_2 = arg_11_0:getScore(iter_11_1.id)
		local var_11_3 = totable(iter_11_1.value).count
		local var_11_4 = Account:getGrowthGuideQuest(iter_11_1.id).state
		
		if to_n(var_11_2) >= to_n(var_11_3) and var_11_4 == GROWTH_GUIDE_QUEST.ACTIVE then
			table.insert(var_11_0, {
				id = iter_11_1.id
			})
		end
	end
	
	return var_11_0
end

function GrowthGuideQuest.getScore(arg_12_0, arg_12_1)
	local var_12_0 = Account:getGrowthGuideQuests()
	
	if var_12_0[arg_12_1] == nil then
		return 0
	end
	
	local var_12_1, var_12_2 = DB("guidequest_mission", arg_12_1, {
		"condition",
		"value"
	})
	
	return arg_12_0:getScore_datas(var_12_0, arg_12_1, var_12_1, var_12_2)
end

function GrowthGuideQuest.getConditionScore(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or 1
	
	local var_13_0 = Account:getGrowthGuideQuests()
	
	return arg_13_0:getConditionScore_datas(var_13_0, arg_13_1, arg_13_2)
end
