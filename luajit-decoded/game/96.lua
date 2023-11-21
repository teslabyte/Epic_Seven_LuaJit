CHAPTER_SHOP_QUEST = {}
CHAPTER_SHOP_QUEST.INACTIVE = -1
CHAPTER_SHOP_QUEST.ACTIVE = 0
CHAPTER_SHOP_QUEST.CLEAR = 1
CHAPTER_SHOP_QUEST.REWARDED = 2
ChapterShopQuest = ChapterShopQuest or {}

copy_functions(ConditionContents, ChapterShopQuest)

function ChapterShopQuest.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.CHAPTER_SHOP_QUEST
end

function ChapterShopQuest.isValidate(arg_2_0, arg_2_1)
	return true
end

function ChapterShopQuest.initConditionListner(arg_3_0)
	arg_3_0:clear()
	
	for iter_3_0 = 1, 9999 do
		local var_3_0, var_3_1, var_3_2 = DBN("shop_chapter_category", iter_3_0, {
			"id",
			"unlock_stage",
			"unlock_quest"
		})
		
		if not var_3_0 then
			break
		end
		
		if var_3_2 and (not var_3_2 or Account:isStartChapterShopQuest(var_3_0)) then
			for iter_3_1 = 1, 999 do
				local var_3_3 = string.format("%s_%02d", var_3_2, iter_3_1)
				local var_3_4 = arg_3_0:isCleared(var_3_3)
				local var_3_5, var_3_6, var_3_7 = DB("shop_chapter_quest", var_3_3, {
					"id",
					"condition",
					"value"
				})
				
				if not var_3_5 then
					break
				end
				
				if var_3_6 and var_3_7 and not var_3_4 then
					arg_3_0:addConditionListner(var_3_5, var_3_6, var_3_7)
				end
			end
		end
	end
	
	for iter_3_2 = 1, 99 do
		local var_3_8, var_3_9, var_3_10, var_3_11 = DBN("shop_chapter_force", iter_3_2, {
			"id",
			"group_stage_id",
			"past_group_stage_id",
			"mission_group"
		})
		
		if not var_3_8 then
			break
		end
		
		if EpisodeForce:isUnlockForceByData(var_3_9, var_3_10, var_3_11) and EpisodeForce:isStartQuest(var_3_8) then
			for iter_3_3 = 1, 999 do
				local var_3_12 = string.format("%s_%02d", var_3_11, iter_3_3)
				local var_3_13 = arg_3_0:isCleared(var_3_12)
				local var_3_14, var_3_15, var_3_16 = DB("shop_chapter_quest", var_3_12, {
					"id",
					"condition",
					"value"
				})
				
				if not var_3_14 then
					break
				end
				
				if var_3_15 and var_3_16 and not var_3_13 then
					arg_3_0:addConditionListner(var_3_14, var_3_15, var_3_16)
				end
			end
		end
	end
end

function ChapterShopQuest.addConditionListner(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0:getScore(arg_4_1)
	
	arg_4_0:removeGroup(arg_4_1)
	
	if arg_4_0:createGroupHandler(arg_4_1, arg_4_2, arg_4_3, var_4_0) then
	else
		print("ChapterShopQuest : undefined condition class", arg_4_2, arg_4_1)
	end
end

function ChapterShopQuest.isCheckState(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Account:getChapterShopQuest(arg_5_1)
	
	if var_5_0 and arg_5_2 and var_5_0.state and arg_5_2 <= var_5_0.state then
		return true
	end
	
	return false
end

function ChapterShopQuest.isCleared(arg_6_0, arg_6_1)
	return arg_6_0:isCheckState(arg_6_1, CHAPTER_SHOP_QUEST.CLEAR)
end

function ChapterShopQuest.isRewarded(arg_7_0, arg_7_1)
	return arg_7_0:isCheckState(arg_7_1, CHAPTER_SHOP_QUEST.REWARDED)
end

function ChapterShopQuest.createNotifyControl(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if not arg_8_2 or not arg_8_3 then
		return 
	end
	
	local var_8_0 = cc.CSLoader:createNode("wnd/achievement_complete_etc.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_8_0)
	var_8_0:setAnchorPoint(0, 0)
	var_8_0:setName("achivnoti_" .. arg_8_1)
	var_8_0:setGlobalZOrder(999999)
	var_8_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_8_0, T(arg_8_2), T(arg_8_3))
	if_set_visible(var_8_0, "spr_emblem", false)
	if_set_visible(var_8_0, "n_face", true)
	UIUtil:getRewardIcon(nil, arg_8_4, {
		no_popup = true,
		no_grade = true,
		parent = var_8_0:getChildByName("n_face")
	})
	
	return var_8_0
end

function ChapterShopQuest.getNotifierControl(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.contents_id
	local var_9_1 = Account:getChapterShopQuest(var_9_0).state or 0
	local var_9_2
	
	if var_9_1 == 0 then
		local var_9_3, var_9_4, var_9_5 = DB("shop_chapter_quest", var_9_0, {
			"category_name",
			"mission_name",
			"icon"
		})
		
		var_9_2 = arg_9_0:createNotifyControl(#arg_9_1, var_9_3, var_9_4, var_9_5)
		
		local var_9_6 = {}
		
		table.insert(var_9_6, var_9_3)
		table.insert(var_9_6, var_9_4)
		table.insert(var_9_6, var_9_5)
		
		var_9_2.args = var_9_6
		
		if var_9_2 then
			table.insert(arg_9_1, var_9_2)
		end
	end
	
	return var_9_2
end

function ChapterShopQuest.update(arg_10_0, arg_10_1)
	Account:setChapterShopQuest(arg_10_1.contents_id, arg_10_1.quest_doc)
	arg_10_0:setUpdateConditionCurScore(arg_10_1.contents_id, nil, arg_10_1.quest_doc.score1)
	
	if arg_10_1.quest_doc and arg_10_1.quest_doc.state >= 1 then
		arg_10_0:removeGroup(arg_10_1.contents_id)
	end
end

function ChapterShopQuest.getScore(arg_11_0, arg_11_1)
	local var_11_0 = Account:getChapterShopQuests()
	
	if var_11_0[arg_11_1] == nil then
		return 0
	end
	
	local var_11_1, var_11_2 = DB("shop_chapter_quest", arg_11_1, {
		"condition",
		"value"
	})
	
	return arg_11_0:getScore_datas(var_11_0, arg_11_1, var_11_1, var_11_2)
end

function ChapterShopQuest.getConditionScore(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = arg_12_2 or 1
	
	local var_12_0 = Account:getChapterShopQuests()
	
	return arg_12_0:getConditionScore_datas(var_12_0, arg_12_1, arg_12_2)
end

function ChapterShopQuest.checkState(arg_13_0, arg_13_1)
	local var_13_0 = {}
	local var_13_1 = arg_13_1.db_data
	
	for iter_13_0, iter_13_1 in pairs(var_13_1) do
		local var_13_2 = Account:getChapterShopQuest(iter_13_1.id)
		
		if var_13_2 and var_13_2.state == CHAPTER_SHOP_QUEST.ACTIVE and iter_13_1.value then
			local var_13_3 = arg_13_0:getScore(iter_13_1.id)
			local var_13_4 = totable(iter_13_1.value).count
			
			if to_n(var_13_3) >= to_n(var_13_4) then
				table.insert(var_13_0, {
					id = iter_13_1.id
				})
			end
		end
	end
	
	return var_13_0
end
