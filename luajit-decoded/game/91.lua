SUBSTORY_ACHIEVE_STATE = {}
SUBSTORY_ACHIEVE_STATE.ACTIVE = 0
SUBSTORY_ACHIEVE_STATE.CLEAR = 1
SUBSTORY_ACHIEVE_STATE.REWARDED = 2
SUBSTORY_QUEST_STATE = {}
SUBSTORY_QUEST_STATE.INACTIVE = -1
SUBSTORY_QUEST_STATE.ACTIVE = 0
SUBSTORY_QUEST_STATE.CLEAR = 1
SUBSTORY_QUEST_STATE.REWARDED = 2
SubStoryAchieve = SubStoryAchieve or {}

copy_functions(SubstoryConditionContents, SubStoryAchieve)

function SubStoryAchieve.init(arg_1_0)
	arg_1_0.contents_type = CONTENTS_TYPE.SUBSTORY_ACHIEVE
	arg_1_0.lock_datas = {}
	arg_1_0.clear_snapshot_queue = {}
end

function SubStoryAchieve.clear(arg_2_0)
	arg_2_0:removeExpire()
end

function SubStoryAchieve.createAchieve(arg_3_0, arg_3_1)
	arg_3_0:clear()
	
	for iter_3_0 = 1, 999 do
		local var_3_0 = arg_3_1 .. "_" .. "ach_" .. string.format("%02d", iter_3_0)
		local var_3_1 = Account:getSubStoryAchievement(var_3_0) or {}
		
		if not var_3_1.state or tonumber(var_3_1.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) < tonumber(SUBSTORY_ACHIEVE_STATE.CLEAR) then
			local var_3_2, var_3_3, var_3_4, var_3_5 = DB("substory_achievement", var_3_0, {
				"id",
				"condition",
				"value",
				"unlock_state_id"
			})
			
			if not var_3_2 then
				break
			end
			
			local var_3_6 = true
			
			if var_3_5 then
				var_3_6 = ConditionContentsState:isClearedByStateID(var_3_5)
				arg_3_0.lock_datas[var_3_2] = {
					substory_id = arg_3_1,
					condition = var_3_3,
					condition_value = var_3_4,
					unlock_state_id = var_3_5
				}
			end
			
			if var_3_3 and var_3_4 and var_3_6 == true then
				local var_3_7 = arg_3_0:createGroupHandler(var_3_2, var_3_3, var_3_4)
				
				if var_3_7 then
					var_3_7:setSubStoryID(arg_3_1)
				end
			end
		end
	end
end

function SubStoryAchieve.checkUnlockCondition(arg_4_0)
	for iter_4_0, iter_4_1 in pairs(arg_4_0.lock_datas or {}) do
		local var_4_0 = Account:getSubStoryAchievement(iter_4_0) or {}
		local var_4_1 = tonumber(var_4_0.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) < tonumber(SUBSTORY_ACHIEVE_STATE.CLEAR)
		local var_4_2 = ConditionContentsState:isClearedByStateID(iter_4_1.unlock_state_id)
		
		if iter_4_1.condition and iter_4_1.condition_value and var_4_1 and var_4_2 and not arg_4_0:getGroup(iter_4_0) then
			local var_4_3 = arg_4_0:createGroupHandler(iter_4_0, iter_4_1.condition, iter_4_1.condition_value)
			
			if var_4_3 then
				var_4_3:setSubStoryID(iter_4_1.substory_id)
			end
		end
	end
end

function SubStoryAchieve.update(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.contents_id
	
	Account:setSubStoryAchievement(arg_5_1.sub_achieve_doc_attri)
	arg_5_0:setUpdateConditionCurScore(var_5_0, nil, arg_5_1.sub_achieve_doc_attri.score1)
	
	if arg_5_1.sub_achieve_doc_attri.state == SUBSTORY_ACHIEVE_STATE.CLEAR then
		arg_5_0:removeGroup(var_5_0)
	end
end

function SubStoryAchieve.isCleared(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or {}
	
	local var_6_0 = Account:getSubStoryAchievement(arg_6_1) or {}
	
	if tonumber(var_6_0.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) >= tonumber(SUBSTORY_ACHIEVE_STATE.CLEAR) then
		return true
	end
	
	return false
end

function SubStoryAchieve.isRewarded(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	
	local var_7_0 = Account:getSubStoryAchievement(arg_7_1) or {}
	
	if tonumber(var_7_0.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) >= tonumber(SUBSTORY_ACHIEVE_STATE.REWARDED) then
		return true
	end
	
	return false
end

function SubStoryAchieve.getScore(arg_8_0, arg_8_1)
	local var_8_0 = Account:getSubStoryAchievement(arg_8_1)
	
	if var_8_0 == nil or var_8_0 == {} then
		return 0
	end
	
	return var_8_0.score1 or 0
end

function SubStoryAchieve.getConditionScore(arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0:getScore(arg_9_1)
end

function SubStoryAchieve.getNotifierControl(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.contents_id
	local var_10_1 = Account:getSubStoryAchievement(var_10_0) or {}
	local var_10_2
	
	if (var_10_1.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) == SUBSTORY_ACHIEVE_STATE.ACTIVE then
		local var_10_3 = string.split(var_10_0, "_")[1]
		local var_10_4 = DB("substory_main", var_10_3, {
			"banner_icon"
		})
		local var_10_5, var_10_6, var_10_7 = DB("substory_achievement", var_10_0, {
			"id",
			"name",
			"desc"
		})
		
		var_10_2 = arg_10_0:createNotifyControl(#arg_10_1, var_10_6, var_10_7, var_10_4)
		
		local var_10_8 = {}
		
		table.insert(var_10_8, var_10_6)
		table.insert(var_10_8, var_10_7)
		table.insert(var_10_8, var_10_4)
		
		var_10_2.args = var_10_8
		
		if var_10_2 then
			table.insert(arg_10_1, var_10_2)
		end
	end
	
	return var_10_2
end

function SubStoryAchieve.createNotifyControl(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = cc.CSLoader:createNode("wnd/achievement_complete_story.csb")
	
	SceneManager:getRunningPopupScene():addChild(var_11_0)
	var_11_0:setAnchorPoint(0, 0)
	var_11_0:setName("achivnoti_" .. arg_11_1)
	var_11_0:setGlobalZOrder(999999)
	var_11_0:setLocalZOrder(999999)
	UIUtil:setNotifyTextControl(var_11_0, T(arg_11_2), T(arg_11_3))
	
	if arg_11_4 then
		if_set_sprite(var_11_0, "spr_icon", "banner/" .. arg_11_4 .. ".png")
	end
	
	return var_11_0
end

function SubStoryAchieve.verifyConditionExist(arg_12_0, arg_12_1)
	local var_12_0 = {}
	
	for iter_12_0 = 1, 999 do
		local var_12_1 = arg_12_1 .. "_" .. "ach_" .. string.format("%02d", iter_12_0)
		local var_12_2 = Account:getSubStoryAchievement(var_12_1) or {}
		
		if not var_12_2.state or tonumber(var_12_2.state) < tonumber(SUBSTORY_ACHIEVE_STATE.CLEAR) then
			local var_12_3, var_12_4, var_12_5, var_12_6 = DB("substory_achievement", var_12_1, {
				"id",
				"condition",
				"value",
				"unlock_state_id"
			})
			
			if not var_12_3 then
				break
			end
			
			local var_12_7 = true
			
			if var_12_6 then
				var_12_7 = ConditionContentsState:isClearedByStateID(var_12_6)
			end
			
			if var_12_4 and var_12_5 and var_12_7 == true then
				table.insert(var_12_0, var_12_3)
			end
		end
	end
	
	if table.count(var_12_0) > 0 then
		for iter_12_1, iter_12_2 in pairs(arg_12_0:getGroups()) do
			if table.find(var_12_0, iter_12_1) then
				return true
			end
		end
		
		return false
	end
	
	return true
end

function SubStoryAchieve.sendVerifyFailReport(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	Log.e("[created] :", os.time(), "[substory_id] :", arg_13_1, "[enter_id] :", arg_13_2, "[is_back_ground] :", arg_13_3 and true or false)
	Log.e("[back_map_id] :", BackPlayManager:getRunningMapId() or "empty", "[back_battle] :", BackPlayManager:hasBattle(), "[back_last_battle] :", BackPlayManager:hasLastBattle())
	Log.e("[playing_subs_ids] :", table.toCommaStr(SubstoryManager:getPlaySubstoryIDList()), "[can_box_open] :", BackPlayControlBox:canOpen())
	
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0:getGroups()) do
		table.insert(var_13_0, iter_13_0)
	end
	
	Log.e("[mission_ids] :", table.toCommaStr(var_13_0))
	
	for iter_13_2, iter_13_3 in pairs(arg_13_0.clear_snapshot_queue) do
		Log.e("[snapshot" .. iter_13_2 .. "]  :", json.encode(iter_13_3))
	end
	
	REPORT_COUNT = 0
	
	__G__TRACKBACK__("found #99034 issue situation. ( conditions of SubStoryAchieve not exist )")
end

SubStoryQuest = SubStoryQuest or {}

copy_functions(SubstoryConditionContents, SubStoryQuest)

function SubStoryQuest.init(arg_14_0)
	arg_14_0.contents_type = CONTENTS_TYPE.SUBSTORY_QUETS
	arg_14_0.lock_datas = {}
end

function SubStoryQuest.clear(arg_15_0)
	arg_15_0:removeExpire()
end

function SubStoryQuest.createQuests(arg_16_0, arg_16_1)
	arg_16_0:clear()
	
	if not (DB("substory_main", arg_16_1, "quest_flag") == "y") then
		return 
	end
	
	for iter_16_0 = 1, 99 do
		local var_16_0 = arg_16_1 .. "_" .. "quest_" .. string.format("%02d", iter_16_0)
		local var_16_1 = Account:getSubStoryQuest(var_16_0) or {}
		local var_16_2, var_16_3, var_16_4, var_16_5 = DB("substory_quest", var_16_0, {
			"id",
			"condition",
			"value",
			"state_id"
		})
		
		if not var_16_2 then
			break
		end
		
		local var_16_6 = true
		
		if var_16_5 then
			var_16_6 = ConditionContentsState:isClearedByStateID(var_16_5)
			arg_16_0.lock_datas[var_16_2] = {
				condition = var_16_3,
				condition_value = var_16_4,
				unlock_state_id = var_16_5
			}
		end
		
		if (not var_16_1.state or var_16_1.state == SUBSTORY_QUEST_STATE.ACTIVE) and var_16_3 and var_16_4 then
			if var_16_6 == true then
				local var_16_7 = arg_16_0:createGroupHandler(var_16_2, var_16_3, var_16_4)
				
				if var_16_7 then
					var_16_7:setSubStoryID(arg_16_1)
				end
			end
			
			break
		end
	end
end

function SubStoryQuest.checkUnlockCondition(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.lock_datas or {}) do
		local var_17_0 = Account:getSubStoryQuest(iter_17_0) or {}
		local var_17_1 = tonumber(var_17_0.state or SUBSTORY_QUEST_STATE.ACTIVE) < tonumber(SUBSTORY_QUEST_STATE.CLEAR)
		local var_17_2 = ConditionContentsState:isClearedByStateID(iter_17_1.unlock_state_id)
		
		if iter_17_1.condition and iter_17_1.condition_value and var_17_1 and var_17_2 and not arg_17_0:getGroup(iter_17_0) then
			local var_17_3 = arg_17_0:createGroupHandler(iter_17_0, iter_17_1.condition, iter_17_1.condition_value)
			
			if var_17_3 then
				var_17_3:setSubStoryID(iter_17_1.substory_id)
			end
		end
	end
end

function SubStoryQuest.getCurrentQuest(arg_18_0, arg_18_1)
	for iter_18_0 = 1, 99 do
		local var_18_0 = arg_18_1 .. "_" .. "quest_" .. string.format("%02d", iter_18_0)
		local var_18_1 = Account:getSubStoryQuest(var_18_0) or {}
		local var_18_2, var_18_3, var_18_4 = DB("substory_quest", var_18_0, {
			"id",
			"condition",
			"value"
		})
		
		if not var_18_2 then
			break
		end
		
		if (not var_18_1.state or var_18_1.state == SUBSTORY_QUEST_STATE.ACTIVE) and var_18_3 and var_18_4 then
			return var_18_0
		end
	end
end

function SubStoryQuest.update(arg_19_0, arg_19_1)
	Account:setSubStoryQuest(arg_19_1.sub_quest_doc_attri)
	
	if arg_19_1.sub_story_doc then
		Account:updateSubStory(arg_19_1.sub_story_doc.substory_id, arg_19_1.sub_story_doc)
	end
	
	if arg_19_1.next_doc_quest_attri then
		Account:setSubStoryQuest(arg_19_1.next_doc_quest_attri)
	end
	
	arg_19_0:setUpdateConditionCurScore(arg_19_1.sub_quest_doc_attri.contents_id, nil, arg_19_1.sub_quest_doc_attri.score1)
	arg_19_0:createQuests(arg_19_1.sub_quest_doc_attri.substory_id)
end

function SubStoryQuest.isCleared(arg_20_0, arg_20_1, arg_20_2)
	arg_20_2 = arg_20_2 or {}
	
	local var_20_0 = Account:getSubStoryQuest(arg_20_1) or {}
	
	if tonumber(var_20_0.state or SUBSTORY_QUEST_STATE.ACTIVE) >= tonumber(SUBSTORY_QUEST_STATE.CLEAR) then
		return true
	end
	
	return false
end

function SubStoryQuest.isRewarded(arg_21_0, arg_21_1, arg_21_2)
	arg_21_2 = arg_21_2 or {}
	
	local var_21_0 = Account:getSubStoryQuest(arg_21_1) or {}
	
	if tonumber(var_21_0.state or SUBSTORY_QUEST_STATE.ACTIVE) >= tonumber(SUBSTORY_QUEST_STATE.REWARDED) then
		return true
	end
	
	return false
end

function SubStoryQuest.setUIQuest(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	arg_22_3 = arg_22_3 or {}
	
	local var_22_0 = arg_22_1:getChildByName("txt_name")
	local var_22_1 = arg_22_1:getChildByName("txt_title")
	
	if_set(var_22_0, nil, T(arg_22_2.db_name))
	if_set(var_22_1, nil, T(arg_22_2.db_desc) or "")
	if_set_sprite(arg_22_1, "img_face", "face/" .. arg_22_2.face_icon .. "_s.png")
	
	local var_22_2 = totable(arg_22_2.condition_value).count or "1"
	local var_22_3 = arg_22_0:getScore(arg_22_2.quest_id)
	local var_22_4 = arg_22_1:getChildByName("bg_progress")
	
	if var_22_4 then
		local var_22_5 = var_22_4:getChildByName("progress")
		
		if var_22_5 then
			var_22_5:setPercent(var_22_3 / var_22_2 * 100)
			if_set(var_22_4, "txt_progress", var_22_3 .. "/" .. var_22_2)
		end
	end
	
	local var_22_6 = {
		parent = arg_22_1:getChildByName("icon"),
		scale = arg_22_3.reward_scale,
		set_drop = arg_22_2.set_drop_id,
		grade_rate = arg_22_2.grade_rate
	}
	local var_22_7 = UIUtil:getRewardIcon(arg_22_2.reward_count, arg_22_2.reward_id, var_22_6)
end

function SubStoryQuest.setUIChapter(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_3 = arg_23_3 or {}
	
	local var_23_0 = arg_23_1:getChildByName("title")
	local var_23_1 = arg_23_1:getChildByName("txt_chapter")
	
	if_set(var_23_0, nil, T(arg_23_2.chapter_name))
	if_set(var_23_1, nil, T(arg_23_2.chapter_desc))
	
	if var_23_0 and var_23_0:getStringNumLines() == 2 then
		local function var_23_2(arg_24_0)
			if not get_cocos_refid(arg_24_0) then
				return 
			end
			
			if not arg_24_0._origin_pos_x then
				arg_24_0._origin_pos_x, arg_24_0._origin_pos_y = arg_24_0:getPosition()
			end
			
			arg_24_0:setPosition(arg_24_0._origin_pos_x, arg_24_0._origin_pos_y - 12)
		end
		
		local var_23_3 = getChildByPath(arg_23_1, "CENTER/window_frame/n_center/txt_name")
		local var_23_4 = arg_23_1:getChildByName("txt_title")
		
		var_23_2(var_23_3)
		var_23_2(var_23_4)
	end
	
	local var_23_5 = SubstoryManager:getClearQuestCount()
	local var_23_6 = arg_23_1:getChildByName("exp")
	
	if var_23_6 then
		local var_23_7 = var_23_6:getChildByName("progress")
		local var_23_8 = arg_23_0:getCountInChapter()
		
		var_23_7:setPercent((var_23_5 - 1) / var_23_8 * 100)
		
		if var_23_6 then
			var_23_6:getChildByName("progress_up"):setPercent(var_23_5 / var_23_8 * 100)
			if_set(var_23_6, "txt_progress", T("quest_num", {
				score = var_23_5,
				count = var_23_8
			}))
		end
		
		if arg_23_3 and arg_23_3.gauge_action then
			UIAction:Add(LOG(PROGRESS(1500, (var_23_5 - 1) / var_23_8, var_23_5 / var_23_8)), var_23_7, "progress")
		end
	end
end

function SubStoryQuest.getScore(arg_25_0, arg_25_1)
	local var_25_0 = Account:getSubStoryQuest(arg_25_1)
	
	if var_25_0 == nil or var_25_0 == {} then
		return 0
	end
	
	return var_25_0.score1 or 0
end

function SubStoryQuest.getConditionScore(arg_26_0, arg_26_1, arg_26_2)
	return arg_26_0:getScore(arg_26_1)
end
