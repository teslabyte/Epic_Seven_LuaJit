CLASS_CHANGE_QUEST_STATE = {}
CLASS_CHANGE_QUEST_STATE.INACTIVE = -1
CLASS_CHANGE_QUEST_STATE.ACTIVE = 0
CLASS_CHANGE_QUEST_STATE.CLEAR = 1
CLASS_CHANGE_QUEST_STATE.REWARDED = 2
ClassChangeQuest = ClassChangeQuest or {}

copy_functions(ConditionContents, ClassChangeQuest)

function ClassChangeQuest.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.CLASS_CHANGE_QUEST
end

function ClassChangeQuest.initConditionListner(arg_2_0)
	arg_2_0:clear()
	
	local var_2_0 = Account:getClassChangeInfo()
	
	for iter_2_0 = 1, 99 do
		local var_2_1, var_2_2, var_2_3 = DBN("classchange_category", iter_2_0, {
			"id",
			"char_id",
			"hide"
		})
		
		if not var_2_1 then
			break
		end
		
		local var_2_4 = Account:getClassChangeInfoByCode(var_2_2)
		
		if var_2_3 == nil and var_2_2 and var_2_4.state == 1 then
			for iter_2_1 = 1, 99 do
				local var_2_5 = string.format("%s_quest_%02d", var_2_1, iter_2_1)
				local var_2_6, var_2_7, var_2_8 = DB("classchange_quest", var_2_5, {
					"id",
					"condition",
					"value"
				})
				
				if not var_2_6 then
					break
				end
				
				local var_2_9 = Account:getClassChangeQuest(var_2_5)
				
				if var_2_6 and var_2_9.state == CLASS_CHANGE_QUEST_STATE.ACTIVE and var_2_7 and var_2_8 then
					arg_2_0:addConditionListner(var_2_6, var_2_7, var_2_8)
				end
			end
		end
	end
end

function ClassChangeQuest.addConditionListner(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0:getScore(arg_3_1)
	
	arg_3_0:removeGroup(arg_3_1)
	
	if arg_3_0:createGroupHandler(arg_3_1, arg_3_2, arg_3_3, var_3_0) then
	else
		print("ClassChangeQuest : undefined condition class", arg_3_2, arg_3_1)
	end
end

function ClassChangeQuest.update(arg_4_0, arg_4_1)
	Account:setClassChangeQuest(arg_4_1.contents_id, arg_4_1.quest_doc)
	arg_4_0:setUpdateConditionCurScore(arg_4_1.contents_id, nil, arg_4_1.quest_doc.score1)
	
	if arg_4_1.quest_doc.state == CLASS_CHANGE_QUEST_STATE.CLEAR then
		arg_4_0:removeGroup(arg_4_1.contents_id)
	end
end

function ClassChangeQuest.checkState(arg_5_0, arg_5_1)
	local var_5_0 = {}
	local var_5_1 = arg_5_1.db_data
	
	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		local var_5_2 = arg_5_0:getScore(iter_5_1.id)
		local var_5_3 = totable(iter_5_1.value).count
		local var_5_4 = Account:getClassChangeQuest(iter_5_1.id).state
		
		if to_n(var_5_2) >= to_n(var_5_3) and var_5_4 == CLASS_CHANGE_QUEST_STATE.ACTIVE then
			table.insert(var_5_0, {
				id = iter_5_1.id
			})
		end
	end
	
	return var_5_0
end

function ClassChangeQuest.getScore(arg_6_0, arg_6_1)
	local var_6_0 = Account:getClassChangeQuests()
	
	if var_6_0[arg_6_1] == nil then
		return 0
	end
	
	local var_6_1, var_6_2 = DB("classchange_quest", arg_6_1, {
		"condition",
		"value"
	})
	
	return arg_6_0:getScore_datas(var_6_0, arg_6_1, var_6_1, var_6_2)
end

function ClassChangeQuest.getConditionScore(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or 1
	
	local var_7_0 = Account:getClassChangeQuests()
	
	return arg_7_0:getConditionScore_datas(var_7_0, arg_7_1, arg_7_2)
end

function ClassChangeQuest.isCleared(arg_8_0, arg_8_1)
	local var_8_0 = Account:getClassChangeQuest(arg_8_1)
	
	if var_8_0 and var_8_0.state >= CLASS_CHANGE_QUEST_STATE.CLEAR then
		return true
	end
	
	return false
end

function ClassChangeQuest.isRewarded(arg_9_0, arg_9_1)
	local var_9_0 = Account:getClassChangeQuest(arg_9_1)
	
	if var_9_0 and var_9_0.state >= CLASS_CHANGE_QUEST_STATE.REWARDED then
		return true
	end
	
	return false
end

function ClassChangeQuest.getNotifierControl(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.contents_id
	local var_10_1 = Account:getClassChangeQuest(var_10_0).state or CLASS_CHANGE_QUEST_STATE.ACTIVE
	local var_10_2
	
	if var_10_1 == CLASS_CHANGE_QUEST_STATE.ACTIVE then
		local var_10_3, var_10_4, var_10_5 = DB("classchange_quest", var_10_0, {
			"category_name",
			"mission_name",
			"category"
		})
		local var_10_6 = DB("classchange_category", var_10_5, "char_id")
		
		var_10_2 = arg_10_0:createNotifyControl(#arg_10_1, var_10_3, var_10_4, var_10_6)
		
		local var_10_7 = {}
		
		table.insert(var_10_7, var_10_3)
		table.insert(var_10_7, var_10_4)
		table.insert(var_10_7, var_10_6)
		
		var_10_2.args = var_10_7
		
		if var_10_2 then
			table.insert(arg_10_1, var_10_2)
		end
	end
	
	return var_10_2
end

function ClassChangeQuest.createNotifyControl(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if not arg_11_2 or not arg_11_3 then
		return 
	end
	
	local var_11_0 = cc.CSLoader:createNode("wnd/achievement_complete_etc.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_11_0)
	var_11_0:setAnchorPoint(0, 0)
	var_11_0:setName("achivnoti_" .. arg_11_1)
	var_11_0:setGlobalZOrder(999999)
	var_11_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_11_0, T(arg_11_2), T(arg_11_3))
	if_set_visible(var_11_0, "spr_emblem", false)
	if_set_visible(var_11_0, "n_face", true)
	UIUtil:getRewardIcon(nil, arg_11_4, {
		no_popup = true,
		no_grade = true,
		parent = var_11_0:getChildByName("n_face")
	})
	
	return var_11_0
end
