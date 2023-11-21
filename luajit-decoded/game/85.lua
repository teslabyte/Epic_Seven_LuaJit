GrowthGuide = {}
GrowthGuide.current_quests = {}
GrowthGuide.onGetRewardGrowthQuest = Delegate.new()
GrowthGuide.onGetRewardGrowthChapter = Delegate.new()

function MsgHandler.get_reward_growth_quest(arg_1_0)
	local var_1_0 = {
		title = T("clear_gg_quest_title"),
		desc = T("clear_gg_quest_reward_msg")
	}
	
	Account:addReward(arg_1_0.rewards, {
		play_reward_data = var_1_0,
		handler = function()
			GrowthGuide.onGetRewardGrowthQuest(arg_1_0.contents_id)
		end
	})
	Account:setGrowthGuideQuest(arg_1_0.contents_id, arg_1_0.quest_doc)
	
	if GrowthGuide:isFinish() then
		Singular:event("growth_guide_complete")
	end
end

function MsgHandler.get_reward_growth_chapter(arg_3_0)
	local var_3_0 = {
		title = T("clear_gg_chapter_title"),
		desc = T("clear_gg_chapter_reward_msg")
	}
	
	Account:addReward(arg_3_0.rewards, {
		play_reward_data = var_3_0,
		handler = function()
			GrowthGuide.onGetRewardGrowthChapter(arg_3_0.doc_group.group_id)
		end
	})
	Account:setGrowthGuideGroup(arg_3_0.doc_group.group_id, arg_3_0.doc_group)
	
	if arg_3_0.doc_group.group_id == "guidequest_011" then
		Singular:event("adventure_path_pursuer_complete")
	end
	
	if GrowthGuide:isFinish() then
		Singular:event("growth_guide_complete")
	end
end

function GrowthGuide.getGroupDB(arg_5_0, arg_5_1)
	if not arg_5_0.group_db or not arg_5_0.group_db_list then
		arg_5_0.group_db = {}
		arg_5_0.group_db_list = {}
		arg_5_0.categories = {}
		
		for iter_5_0 = 1, 99 do
			local var_5_0 = {}
			
			var_5_0.group_id, var_5_0.group_name, var_5_0.sort, var_5_0.questgroup_category, var_5_0.group_icon, var_5_0.group_unlock_condition, var_5_0.group_unlock_stage_condition, var_5_0.req_unlock_msg, var_5_0.condition_state_id, var_5_0.achv_reward_id1, var_5_0.achv_reward_count1, var_5_0.achv_reward_id2, var_5_0.achv_reward_count2, var_5_0.image, var_5_0.next_group_tracking, var_5_0.running_char, var_5_0.guide_char, var_5_0.navigator_icon = DBN("guidequest_group", iter_5_0, {
				"id",
				"group_name",
				"sort",
				"questgroup_category",
				"group_icon",
				"group_unlock_condition",
				"group_unlock_stage_condition",
				"req_unlock_msg",
				"condition_state_id",
				"achv_reward_id1",
				"achv_reward_count1",
				"achv_reward_id2",
				"achv_reward_count2",
				"image",
				"next_group_tracking",
				"running_char",
				"guide_char",
				"navigator_icon"
			})
			
			if not var_5_0.group_id then
				break
			end
			
			arg_5_0.group_db[var_5_0.group_id] = var_5_0
			
			table.insert(arg_5_0.group_db_list, var_5_0)
			
			arg_5_0.categories[var_5_0.questgroup_category] = arg_5_0.categories[var_5_0.questgroup_category] or {}
			
			table.insert(arg_5_0.categories[var_5_0.questgroup_category], var_5_0.group_id)
		end
		
		table.sort(arg_5_0.group_db_list, function(arg_6_0, arg_6_1)
			return to_n(arg_6_0.sort) < to_n(arg_6_1.sort)
		end)
		
		for iter_5_1, iter_5_2 in pairs(arg_5_0.group_db_list) do
			iter_5_2.index = iter_5_1
		end
	end
	
	if arg_5_1 then
		local var_5_1 = arg_5_0.group_db[arg_5_1]
		
		if not var_5_1 then
			Log.e("growth_guide", arg_5_1 .. " is not valid.")
			
			return nil
		end
		
		return var_5_1
	end
	
	return arg_5_0.group_db, arg_5_0.group_db_list
end

function GrowthGuide.getQuestDB(arg_7_0, arg_7_1)
	if not arg_7_0.quest_db or not arg_7_0.quest_db_list then
		arg_7_0.quest_db = {}
		arg_7_0.quest_db_list = {}
		arg_7_0.quests_by_group_id = {}
		arg_7_0.quests_by_group_id_list = {}
		
		local var_7_0 = {}
		local var_7_1 = {
			"id",
			"unknown_type",
			"unknown_type_jpn",
			"group_id",
			"quest_name",
			"desc",
			"condition",
			"value",
			"reward_id1",
			"reward_count1",
			"grade_rate1",
			"set_drop_rate_id1",
			"reward_id2",
			"reward_count2",
			"grade_rate2",
			"set_drop_rate_id2",
			"btn_move",
			"sort",
			"quest_navigator",
			"detail",
			"npc_balloon",
			"guide_char"
		}
		
		for iter_7_0 = 1, 9999 do
			local var_7_2 = DBNFields("guidequest_mission", iter_7_0, var_7_1)
			
			if not var_7_2.id then
				break
			end
			
			arg_7_0.quest_db[var_7_2.id] = var_7_2
			
			table.insert(arg_7_0.quest_db_list, var_7_2)
			
			if not arg_7_0.quests_by_group_id_list[var_7_2.group_id] then
				arg_7_0.quests_by_group_id_list[var_7_2.group_id] = {}
			end
			
			arg_7_0.quests_by_group_id_list[var_7_2.group_id][var_7_2.id] = var_7_2
			
			if not arg_7_0.quests_by_group_id[var_7_2.group_id] then
				arg_7_0.quests_by_group_id[var_7_2.group_id] = {}
			end
			
			table.insert(arg_7_0.quests_by_group_id[var_7_2.group_id], var_7_2)
			
			var_7_0[var_7_2.group_id] = var_7_2.group_id
		end
		
		for iter_7_1, iter_7_2 in pairs(var_7_0) do
			table.sort(arg_7_0.quests_by_group_id[iter_7_2], function(arg_8_0, arg_8_1)
				return to_n(arg_8_0.sort) < to_n(arg_8_1.sort)
			end)
			
			for iter_7_3, iter_7_4 in pairs(arg_7_0.quests_by_group_id[iter_7_2]) do
				iter_7_4.index = iter_7_3
			end
		end
	end
	
	if arg_7_1 then
		return arg_7_0.quest_db[arg_7_1]
	end
	
	return arg_7_0.quest_db, arg_7_0.quest_db_list
end

function GrowthGuide.getDBQuestListByGroupID(arg_9_0, arg_9_1)
	if not arg_9_0.quests_by_group_id then
		arg_9_0:getQuestDB()
	end
	
	return arg_9_0.quests_by_group_id[arg_9_1], arg_9_0.quests_by_group_id_list[arg_9_1]
end

function GrowthGuide.getDBCurrentQuestByGroupID(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:getCurrentQuestIDByGroupID(arg_10_1)
	
	if not var_10_0 then
		return nil
	end
	
	local var_10_1, var_10_2 = arg_10_0:getDBQuestListByGroupID(arg_10_1)
	
	return var_10_2[var_10_0]
end

function GrowthGuide.getDBCurrentQuests(arg_11_0)
	local var_11_0 = {}
	local var_11_1, var_11_2 = arg_11_0:getGroupDB()
	
	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		local var_11_3 = arg_11_0:getDBCurrentQuestByGroupID(iter_11_1.group_id)
		
		if var_11_3 and arg_11_0:isOpenQuest(var_11_3) then
			var_11_0[iter_11_1.group_id] = var_11_3
		end
	end
	
	return var_11_0
end

function GrowthGuide.getDBTrackingQuest(arg_12_0)
	local var_12_0 = arg_12_0:getTrackingGroupID()
	
	if var_12_0 == nil then
		return 
	end
	
	return arg_12_0:getDBCurrentQuestByGroupID(var_12_0)
end

function GrowthGuide.isOpenQuest(arg_13_0, arg_13_1)
	if arg_13_0:isExpectedUpdateQuest(arg_13_1) then
		return false
	end
	
	if arg_13_0:isUnknownQuest(arg_13_1) then
		return false
	end
	
	return true
end

function GrowthGuide.isExpectedUpdateQuest(arg_14_0, arg_14_1)
	if Account:isJPN() then
		return arg_14_1.unknown_type_jpn == "f"
	end
	
	return arg_14_1.unknown_type == "f"
end

function GrowthGuide.isUnknownQuest(arg_15_0, arg_15_1)
	if Account:isJPN() then
		return arg_15_1.unknown_type_jpn == "y"
	end
	
	return arg_15_1.unknown_type == "y"
end

function GrowthGuide.isCanFinishGroup(arg_16_0, arg_16_1)
	if not arg_16_0:isOpenAllGroupQuests(arg_16_1) then
		return false
	end
	
	local var_16_0 = arg_16_0:getGroupDB(arg_16_1)
	
	if not var_16_0 then
		return false
	end
	
	if var_16_0.group_unlock_stage_condition then
		return true
	end
	
	if not var_16_0.group_unlock_condition then
		return true
	end
	
	return arg_16_0:isCanFinishGroup(var_16_0.group_unlock_condition)
end

function GrowthGuide.isClearedQuest(arg_17_0, arg_17_1)
	local var_17_0 = ConditionContentsManager:getGrowthGuideQuest()
	
	if not var_17_0 then
		return false
	end
	
	return var_17_0:isCleared(arg_17_1)
end

function GrowthGuide.isClearedAndPrevQuest(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0:isClearedQuest(arg_18_2) then
		return false
	end
	
	local var_18_0 = arg_18_0:getCurrentQuestIDByGroupID(arg_18_1)
	
	if var_18_0 then
		return arg_18_2 < var_18_0
	end
	
	return arg_18_0:isClearAllQuests(arg_18_1)
end

function GrowthGuide.isClearedAndAfterQuest(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0:isClearedQuest(arg_19_2) then
		return false
	end
	
	local var_19_0 = arg_19_0:getCurrentQuestIDByGroupID(arg_19_1)
	
	if var_19_0 then
		return var_19_0 < arg_19_2
	end
	
	return arg_19_0:isClearAllQuests(arg_19_1)
end

function GrowthGuide.isRewardedQuest(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = ConditionContentsManager:getGrowthGuideQuest()
	
	if not var_20_0 then
		return nil
	end
	
	if var_20_0:isRewarded(arg_20_2) == false then
		return false
	end
	
	local var_20_1 = arg_20_0:getCurrentQuestIDByGroupID(arg_20_1)
	
	if var_20_1 then
		return arg_20_2 < var_20_1
	end
	
	return arg_20_0:isClearAllQuests(arg_20_1)
end

function GrowthGuide.isRewardableQuest(arg_21_0, arg_21_1, arg_21_2)
	return arg_21_0:isClearedAndPrevQuest(arg_21_1, arg_21_2) and not arg_21_0:isRewardedQuest(arg_21_1, arg_21_2)
end

function GrowthGuide.getCountRewardableAllQuests(arg_22_0)
	local var_22_0 = 0
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0:getGroupDB()) do
		var_22_0 = var_22_0 + arg_22_0:getCountRewardableQuests(iter_22_1.group_id)
		
		if arg_22_0:isGroupRewardableState(iter_22_1.group_id) then
			var_22_0 = var_22_0 + 1
		end
	end
	
	return var_22_0
end

function GrowthGuide.getCountRewardableQuests(arg_23_0, arg_23_1)
	if not arg_23_0.quests_by_group_id then
		arg_23_0:getQuestDB()
	end
	
	local var_23_0 = 0
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.quests_by_group_id[arg_23_1]) do
		if arg_23_0:isRewardableQuest(iter_23_1.group_id, iter_23_1.id) then
			var_23_0 = var_23_0 + 1
		end
	end
	
	return var_23_0
end

function GrowthGuide.isRewardable(arg_24_0)
	local var_24_0, var_24_1 = arg_24_0:getQuestDB()
	
	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		if arg_24_0:isRewardableQuest(iter_24_1.group_id, iter_24_1.id) then
			return true
		end
	end
	
	local var_24_2, var_24_3 = arg_24_0:getGroupDB()
	
	for iter_24_2, iter_24_3 in pairs(var_24_3) do
		if arg_24_0:isGroupRewardableState(iter_24_3.group_id) then
			return true
		end
	end
	
	return false
end

function GrowthGuide.isUnlock(arg_25_0)
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.GROWTH_GUIDE)
end

function GrowthGuide.isFinish(arg_26_0, arg_26_1)
	if not arg_26_0:isRewardedAllGroups(arg_26_1) then
		return false
	end
	
	local function var_26_0(arg_27_0)
		local var_27_0 = arg_26_0:isRewardedQuest(arg_27_0.group_id, arg_27_0.id)
		
		if not arg_26_1 and not var_27_0 then
			return false
		end
		
		if var_27_0 then
			return true
		end
		
		if not arg_26_0:isOpenQuest(arg_27_0) then
			return true
		end
		
		if not arg_26_0:isCanFinishGroup(arg_27_0.group_id) and arg_26_0:isOpenAllGroupQuests(arg_27_0.group_id) then
			return true
		end
		
		return false
	end
	
	local var_26_1, var_26_2 = arg_26_0:getQuestDB()
	
	for iter_26_0, iter_26_1 in pairs(var_26_2) do
		if not var_26_0(iter_26_1) then
			return false
		end
	end
	
	return true
end

function GrowthGuide.isEnable(arg_28_0)
	return arg_28_0:isUnlock() and not arg_28_0:isFinish(true) and (arg_28_0:isClearedTutorial() or TutorialGuide:isPlayingTutorial("guide_quest"))
end

function GrowthGuide.isOpenAllGroupQuests(arg_29_0, arg_29_1)
	if not arg_29_1 then
		return false
	end
	
	if not arg_29_0.quests_by_group_id then
		arg_29_0:getQuestDB()
	end
	
	local var_29_0 = arg_29_0.quests_by_group_id[arg_29_1]
	
	if not var_29_0 then
		return false
	end
	
	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		if not GrowthGuide:isOpenQuest(iter_29_1) then
			return false
		end
	end
	
	return true
end

function GrowthGuide.isRewardedAllGroups(arg_30_0, arg_30_1)
	local var_30_0, var_30_1 = arg_30_0:getGroupDB()
	
	for iter_30_0, iter_30_1 in pairs(var_30_1) do
		if Account:getGrowthGuideGroup(iter_30_1.group_id).state ~= 1 then
			if arg_30_1 then
				if arg_30_0:isCanFinishGroup(iter_30_1.group_id) then
					return false
				end
			else
				return false
			end
		end
	end
	
	return true
end

function GrowthGuide.isClearAllQuests(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1 then
		return false
	end
	
	if not arg_31_0.quests_by_group_id then
		arg_31_0:getQuestDB()
	end
	
	local var_31_0 = ConditionContentsManager:getGrowthGuideQuest()
	
	if not var_31_0 then
		return false
	end
	
	for iter_31_0, iter_31_1 in pairs(arg_31_0.quests_by_group_id[arg_31_1]) do
		if not var_31_0:isCleared(iter_31_1.id) then
			if not arg_31_2 then
				return false
			end
			
			if arg_31_0:isOpenQuest(iter_31_1) then
				return false
			end
		end
	end
	
	return true
end

function GrowthGuide.getHideGroupIDs(arg_32_0)
	local var_32_0 = {}
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0:getLockedCategories()) do
		table.add(var_32_0, arg_32_0.categories[iter_32_1])
	end
	
	for iter_32_2, iter_32_3 in pairs(arg_32_0:getClearCategories()) do
		table.add(var_32_0, arg_32_0.categories[iter_32_3])
	end
	
	return var_32_0
end

function GrowthGuide.getLockedCategories(arg_33_0)
	local var_33_0 = {}
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.categories) do
		if arg_33_0:isCategoryLocked(iter_33_0) then
			table.insert(var_33_0, iter_33_0)
		end
	end
	
	return var_33_0
end

function GrowthGuide.getClearCategories(arg_34_0)
	local var_34_0 = {}
	
	for iter_34_0, iter_34_1 in pairs(arg_34_0.categories) do
		if arg_34_0:isCategoryClear(iter_34_0) then
			table.insert(var_34_0, iter_34_0)
		end
	end
	
	return var_34_0
end

function GrowthGuide.isCategoryHide(arg_35_0, arg_35_1)
	return arg_35_0:isCategoryClear(arg_35_1) or arg_35_0:isCategoryLocked(arg_35_1)
end

function GrowthGuide.isCategoryLocked(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.categories[arg_36_1]
	
	if not var_36_0 then
		return false
	end
	
	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		if not arg_36_0:isGroupLockedByID(iter_36_1) then
			return false
		end
	end
	
	return true
end

function GrowthGuide.isCategoryClear(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.categories[arg_37_1]
	
	if not var_37_0 then
		return false
	end
	
	if var_37_0.is_clear then
		return true
	end
	
	for iter_37_0, iter_37_1 in pairs(var_37_0) do
		if not arg_37_0:isGroupClear(iter_37_1) then
			return false
		end
	end
	
	var_37_0.is_clear = true
	
	return true
end

function GrowthGuide.isGroupClear(arg_38_0, arg_38_1)
	return arg_38_0:isGroupRewarded(arg_38_1) and arg_38_0:isRewardedAllQuests(arg_38_1)
end

function GrowthGuide.isRewardedAllQuests(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return false
	end
	
	if not arg_39_0.quests_by_group_id then
		arg_39_0:getQuestDB()
	end
	
	local var_39_0 = ConditionContentsManager:getGrowthGuideQuest()
	
	if not var_39_0 then
		return false
	end
	
	local var_39_1 = arg_39_0.quests_by_group_id[arg_39_1]
	
	if not var_39_1 then
		return 
	end
	
	for iter_39_0, iter_39_1 in pairs(var_39_1) do
		if not var_39_0:isRewarded(iter_39_1.id) then
			return false
		end
	end
	
	return true
end

function GrowthGuide.isGroupRewarded(arg_40_0, arg_40_1)
	return Account:getGrowthGuideGroup(arg_40_1).state == 1
end

function GrowthGuide.isGroupRewardableState(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0:isClearAllQuests(arg_41_1)
	
	return Account:getGrowthGuideGroup(arg_41_1).state == 0 and var_41_0
end

function GrowthGuide.isRewadableState(arg_42_0, arg_42_1)
	if arg_42_0:getFirstNotRewardedQuestIDByGroupID(arg_42_1) then
		return true
	end
	
	if arg_42_0:isGroupRewardableState(arg_42_1) then
		return true
	end
	
	return false
end

function GrowthGuide.getCurrentQuestIDByGroupID(arg_43_0, arg_43_1)
	if not arg_43_1 then
		Log.e("GrowthGuide", "group_id is nil")
		
		return nil
	end
	
	if not arg_43_0.quests_by_group_id then
		arg_43_0:getQuestDB()
	end
	
	local var_43_0 = ConditionContentsManager:getGrowthGuideQuest()
	
	if not var_43_0 then
		return nil
	end
	
	if arg_43_0:isGroupLockedByID(arg_43_1) then
		return nil
	end
	
	local var_43_1 = arg_43_0.quests_by_group_id[arg_43_1]
	
	if not var_43_1 then
		return 
	end
	
	for iter_43_0, iter_43_1 in pairs(var_43_1) do
		local var_43_2 = var_43_0:isCleared(iter_43_1.id)
		
		if iter_43_1.condition and iter_43_1.value and not var_43_2 then
			return iter_43_1.id
		end
	end
	
	return nil
end

function GrowthGuide.reqRewardGrowthQuest(arg_44_0, arg_44_1)
	if not arg_44_1 then
		return false
	end
	
	query("get_reward_growth_quest", {
		contents_id = arg_44_1
	})
	
	return true
end

function GrowthGuide.reqRewardGrowthGroup(arg_45_0, arg_45_1)
	if not arg_45_1 then
		return false
	end
	
	if not arg_45_0:isGroupRewardableState(arg_45_1) then
		return false
	end
	
	query("get_reward_growth_chapter", {
		group_id = arg_45_1
	})
	
	return true
end

function GrowthGuide.getFirstNotRewardedQuestIDByGroupID(arg_46_0, arg_46_1)
	if not arg_46_0.quests_by_group_id then
		arg_46_0:getQuestDB()
	end
	
	if not ConditionContentsManager:getGrowthGuideQuest() then
		return nil
	end
	
	if arg_46_0:isGroupLockedByID(arg_46_1) then
		return nil
	end
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0.quests_by_group_id[arg_46_1]) do
		if iter_46_1.condition and iter_46_1.value and arg_46_0:isRewardableQuest(arg_46_1, iter_46_1.id) then
			return iter_46_1.id
		end
	end
	
	return nil
end

function GrowthGuide.updateAutoTracking(arg_47_0, arg_47_1)
	if not arg_47_1 then
		return 
	end
	
	if not arg_47_0:isEnable() then
		return 
	end
	
	if not arg_47_0:isTracking() then
		return 
	end
	
	local var_47_0 = (function()
		for iter_48_0, iter_48_1 in pairs(arg_47_1) do
			if iter_48_1.contents_type == "growth_guide_q" then
				for iter_48_2, iter_48_3 in pairs(arg_47_0:getDBCurrentQuests()) do
					if iter_48_1.contents_id == iter_48_3.id then
						return iter_48_3.group_id
					end
				end
			end
		end
		
		return nil
	end)()
	
	if var_47_0 == nil then
		return 
	end
	
	if arg_47_0:getTrackingGroupID() == var_47_0 then
		return 
	end
	
	arg_47_0:setTrackingGroupID(var_47_0)
end

function GrowthGuide.setTrackingGroupID(arg_49_0, arg_49_1)
	if arg_49_0:isGroupLockedByID(arg_49_1) then
		return 
	end
	
	SAVE:setTempConfigData("gg_tracking_groupid", arg_49_1 or "null")
end

function GrowthGuide.getTrackingGroupID(arg_50_0)
	local var_50_0 = "gg_tracking_groupid"
	local var_50_1 = SAVE:getTempConfigDatas()[var_50_0]
	
	if not var_50_1 then
		var_50_1 = Account:getConfigData(var_50_0)
		
		if not var_50_1 then
			return nil
		end
	end
	
	if var_50_1 == "nil" or var_50_1 == "null" then
		var_50_1 = nil
	end
	
	if arg_50_0:isClearAllQuests(var_50_1) then
		var_50_1 = arg_50_0:getGroupDB(var_50_1).next_group_tracking
		
		arg_50_0:setTrackingGroupID(var_50_1)
	end
	
	return var_50_1
end

function GrowthGuide.getTrackingNavigatorIcon(arg_51_0)
	local var_51_0 = "hero_s_frame_guide.cfx"
	local var_51_1 = arg_51_0:getGroupDB(arg_51_0:getTrackingGroupID())
	
	if not var_51_1 then
		return var_51_0
	end
	
	return var_51_1.navigator_icon or var_51_0
end

function GrowthGuide.isClearedTutorial(arg_52_0)
	if DEBUG.SKIP_TUTO then
		return true
	end
	
	if TutorialGuide:isClearedTutorial("guide_quest") then
		return true
	end
	
	if TutorialGuide:isClearedTutorial("guide_quest_2") then
		return true
	end
	
	if arg_52_0:isClearedQuest("guidequest_001_01") then
		if not TutorialGuide:isPlayingTutorial("guide_quest") then
			TutorialGuide:forceClearTutorials({
				"guide_quest"
			}, true)
		end
		
		return true
	end
	
	return false
end

function GrowthGuide.isTracking(arg_53_0)
	return arg_53_0:getTrackingGroupID() and true or false
end

function GrowthGuide.setIsOpenedUnlockGroupDialog(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = "gg_unlock_dlg_" .. arg_54_1
	
	SAVE:setTempConfigData(var_54_0, arg_54_2)
end

function GrowthGuide.isOpenedUnlockGroupDialog(arg_55_0, arg_55_1)
	if arg_55_1 == "guidequest_001" then
		return true
	end
	
	local var_55_0 = "gg_unlock_dlg_" .. arg_55_1
	local var_55_1 = SAVE:getTempConfigDatas()[var_55_0] or false
	
	var_55_1 = var_55_1 or Account:getConfigData(var_55_0) or false
	
	return var_55_1
end

function GrowthGuide.setLastClearQuestID(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = "gg_last_open_id_" .. arg_56_1
	
	SAVE:setTempConfigData(var_56_0, arg_56_2)
end

function GrowthGuide.getLastClearQuestID(arg_57_0, arg_57_1)
	local var_57_0 = "gg_last_open_id_" .. arg_57_1
	
	return SAVE:getTempConfigDatas()[var_57_0] or Account:getConfigData(var_57_0)
end

function GrowthGuide.getTrackingGroupDB(arg_58_0)
	local var_58_0, var_58_1 = arg_58_0:getGroupDB()
	
	return var_58_0[arg_58_0:getTrackingGroupID()]
end

function GrowthGuide.printState(arg_59_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_59_0 = arg_59_0:getDBTrackingQuest()
	
	if not var_59_0 then
		print("추적 안함")
		
		return 
	end
	
	print("group_id: " .. var_59_0.group_id .. ", quest_id:" .. var_59_0.id)
end

function GrowthGuide.cheatClear(arg_60_0, arg_60_1)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_60_0 = string.format("guidequest_%03d", arg_60_1)
	local var_60_1 = arg_60_0:getCurrentQuestIDByGroupID(var_60_0)
	
	ConditionContentsManager:getGrowthGuideQuest():setForceUpdateContests(var_60_1, 99)
end

function GrowthGuide.getGroupLastQuest(arg_61_0, arg_61_1)
	if not arg_61_1 then
		Log.e("invalid param group_id")
		
		return nil
	end
	
	if not arg_61_0.quests_by_group_id then
		arg_61_0:getQuestDB()
	end
	
	local var_61_0 = arg_61_0.quests_by_group_id[arg_61_1]
	
	if not var_61_0 then
		return nil
	end
	
	return var_61_0[#var_61_0]
end

function GrowthGuide.getGroupProgress(arg_62_0, arg_62_1)
	if not arg_62_0.quests_by_group_id then
		arg_62_0:getQuestDB()
	end
	
	local var_62_0 = arg_62_0.quests_by_group_id[arg_62_1]
	
	if arg_62_0:isClearAllQuests(arg_62_1) then
		return #var_62_0, #var_62_0
	end
	
	local var_62_1 = 0
	local var_62_2 = arg_62_0:getDBCurrentQuestByGroupID(arg_62_1)
	
	if var_62_2 then
		var_62_1 = var_62_2.index - 1
	end
	
	return var_62_1, #var_62_0
end

function GrowthGuide.isGroupLockedByID(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0:getGroupDB(arg_63_1)
	
	return arg_63_0:isGroupLocked(var_63_0)
end

function GrowthGuide.isGroupLocked(arg_64_0, arg_64_1)
	if not arg_64_1 then
		return false
	end
	
	local var_64_0 = arg_64_1.group_unlock_condition and not arg_64_0:isClearAllQuests(arg_64_1.group_unlock_condition) or false
	local var_64_1 = arg_64_1.group_unlock_stage_condition and not Account:isMapsCleared({
		arg_64_1.group_unlock_stage_condition
	}) or false
	
	return var_64_0 or var_64_1
end
