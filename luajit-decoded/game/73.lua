QuestMissions = QuestMissions or {}

function MsgHandler.set_force_quest(arg_1_0)
	ConditionContentsManager:getQuestMissions():setQuestsAccountData(arg_1_0.quests, arg_1_0.chapter_q, arg_1_0.episode_q)
	
	if arg_1_0.cur_quest_id then
		ConditionContentsManager:getQuestMissions():setQuestAccountData({
			cur_quest = arg_1_0.cur_quest_id
		})
	end
	
	ConditionContentsManager:getQuestMissions():clear()
	ConditionContentsManager:getQuestMissions():updateQuestMissions()
end

copy_functions(ConditionContents, QuestMissions)

function QuestMissions.init(arg_2_0)
	arg_2_0.contents_type = CONTENTS_TYPE.QUEST_MISSION
	arg_2_0.quest_m_id = nil
	arg_2_0.chapter_m_id = nil
	arg_2_0.ep_m_id = nil
	arg_2_0.chapter_key = nil
	arg_2_0.ep_key = nil
	
	arg_2_0:initDBData()
	arg_2_0:updateQuestMissions()
end

function QuestMissions.clear(arg_3_0)
	arg_3_0.quest_m_id = nil
	arg_3_0.chapter_m_id = nil
	arg_3_0.ep_m_id = nil
	arg_3_0.chapter_key = nil
	arg_3_0.ep_key = nil
	arg_3_0.events_map = {}
	arg_3_0.condition_groups = {}
end

function QuestMissions.update(arg_4_0, arg_4_1)
	if arg_4_1 then
		if arg_4_1.next_quest then
			arg_4_0:setQuestAccountData({
				mission_id = arg_4_1.next_key,
				quest = arg_4_1.next_quest
			})
		elseif not arg_4_1.next_key then
			AccountData.quests.quest_m_id = nil
		end
		
		if arg_4_1.quest then
			arg_4_0:setQuestAccountData({
				mission_id = arg_4_1.contents_id,
				quest = arg_4_1.quest
			})
			
			if arg_4_1.quest.state == "clear" then
				arg_4_0:removeGroup(arg_4_1.contents_id)
			end
		end
		
		if arg_4_1.chapter_key then
			arg_4_0:setQuestAccountData({
				mission_id = arg_4_1.chapter_key,
				chapter_q = arg_4_1.chapter
			})
		end
		
		if arg_4_1.cur_quest_id then
			arg_4_0:setQuestAccountData({
				cur_quest = arg_4_1.cur_quest_id
			})
		end
		
		if arg_4_1.next_chapter then
			arg_4_0:setQuestAccountData({
				mission_id = arg_4_1.next_chapter_id,
				chapter_q = arg_4_1.next_chapter
			})
		end
		
		if arg_4_1.episode_attr then
			Account:setEpisodeQuests(arg_4_1.episode_attr)
		end
		
		if arg_4_1.chapter and arg_4_1.chapter.state == "clear" then
			Singular:event(arg_4_1.chapter.chapter_id)
		end
		
		if arg_4_1.quest and arg_4_1.quest.state == "clear" and arg_4_1.quest.quest_id == "ep1_1_1" then
			Singular:event(arg_4_1.quest.quest_id)
		end
	end
	
	arg_4_0:updateQuestMissions()
end

function QuestMissions.isValidate(arg_5_0)
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.condition_groups) do
		local var_5_1 = iter_5_1:getUniqueKey()
		
		if var_5_1 ~= arg_5_0.ep_m_id and var_5_1 ~= arg_5_0.quest_m_id and var_5_1 ~= arg_5_0.chapter_m_id then
			arg_5_0:removeGroup(var_5_1)
			table.insert(var_5_0, iter_5_0)
		end
	end
	
	if #var_5_0 > 0 then
		Log.e("ConditionContents.isValidate", #var_5_0)
	end
end

function QuestMissions.isActiveQuestInChapter(arg_6_0, arg_6_1)
	local var_6_0 = DB("mission_data", arg_6_0.quest_m_id, {
		"area_enter_id"
	})
	
	if not arg_6_1 or not var_6_0 then
		return 
	end
	
	if var_6_0 and arg_6_0:getQuestData().state == "active" and string.starts(var_6_0, arg_6_1) then
		return true
	end
end

function QuestMissions.isActiveQuestInWorld(arg_7_0, arg_7_1)
	local var_7_0 = false
	
	for iter_7_0 = 1, 9999 do
		local var_7_1 = arg_7_1 .. string.format("%03d", iter_7_0)
		local var_7_2, var_7_3 = DB("level_world_2_continent", var_7_1, {
			"id",
			"key_normal"
		})
		
		if not var_7_2 then
			break
		end
		
		if var_7_3 and arg_7_0:isActiveQuestInChapter(var_7_3) then
			var_7_0 = true
			
			return var_7_0
		end
	end
	
	return var_7_0
end

function QuestMissions.getActiveQuestInBattle(arg_8_0, arg_8_1)
	local var_8_0 = DB("mission_data", arg_8_0.quest_m_id, {
		"area_enter_id"
	})
	
	if not var_8_0 then
		return 
	end
	
	if arg_8_0:getQuestData().state == "active" and arg_8_1 == var_8_0 then
		return arg_8_0:getQuestData()
	end
end

function QuestMissions.isCleared(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:getQuestData(arg_9_1)
	
	if var_9_0 and (var_9_0.state == "clear" or var_9_0.state == "received") then
		return true
	end
end

function QuestMissions.isClearedChapter(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:getChapterData(arg_10_1)
	
	if var_10_0 and (var_10_0.state == "clear" or var_10_0.state == "received") then
		return true
	end
end

function QuestMissions.clear(arg_11_0)
	arg_11_0.quest_m_id = nil
	arg_11_0.chapter_m_id = nil
	arg_11_0.ep_m_id = nil
end

function QuestMissions.initDBData(arg_12_0)
	arg_12_0.db = {}
	arg_12_0.db.episode = {}
	arg_12_0.db.chapter = {}
	arg_12_0.db.chapter_missions = {}
	arg_12_0.db.chapter_mission_id_list = {}
	arg_12_0.db.missions = {}
	arg_12_0.db.last_ep_id = nil
	arg_12_0.db.last_ep_mission_id = nil
	arg_12_0.db.last_chapter_key = nil
	arg_12_0.db.last_chapter_mission_id = nil
	arg_12_0.db.last_quest_id = nil
	
	local var_12_0 = 1
	
	for iter_12_0 = 1, 999 do
		local var_12_1, var_12_2, var_12_3 = DBN("quest_episode", iter_12_0, {
			"id",
			"mission_id",
			"key_chapter"
		})
		
		if not var_12_1 then
			break
		end
		
		arg_12_0.db.episode[var_12_1] = {
			id = var_12_1,
			mission_id = var_12_2,
			key_chapter = var_12_3
		}
		arg_12_0.db.last_ep_id = var_12_1
		arg_12_0.db.last_ep_mission_id = var_12_2
	end
	
	for iter_12_1, iter_12_2 in pairs(arg_12_0.db.episode) do
		for iter_12_3 = 1, 999 do
			local var_12_4, var_12_5, var_12_6 = DB("quest_chapter", iter_12_2.key_chapter .. "_" .. iter_12_3, {
				"id",
				"mission_id",
				"key_mission"
			})
			
			if not var_12_4 then
				break
			end
			
			arg_12_0.db.chapter[var_12_4] = {
				id = var_12_4,
				mission_id = var_12_5,
				key_mission = var_12_6,
				episode = iter_12_2.id,
				ep_mission_id = iter_12_2.mission_id,
				sort = var_12_0
			}
			arg_12_0.db.chapter_missions[var_12_5] = {
				id = var_12_4,
				mission_id = var_12_5,
				key_mission = var_12_6,
				episode = iter_12_2.id,
				ep_mission_id = iter_12_2.mission_id,
				sort = var_12_0
			}
			
			table.insert(arg_12_0.db.chapter_mission_id_list, var_12_5)
			
			arg_12_0.db.last_chapter_key = var_12_6
			arg_12_0.db.last_chapter_mission_id = var_12_5
			var_12_0 = var_12_0 + 1
			
			for iter_12_4 = 1, 999 do
				local var_12_7 = DB("mission_data", var_12_6 .. "_" .. iter_12_4, {
					"id"
				})
				
				if not var_12_7 then
					break
				end
				
				arg_12_0.db.missions[var_12_7] = {
					mission_id = var_12_7,
					chapter = var_12_4,
					chapter_mission_id = var_12_5,
					ep_mission_id = iter_12_2.mission_id,
					episode = iter_12_2.id
				}
				arg_12_0.db.last_quest_id = var_12_7
			end
		end
	end
end

function QuestMissions.getChapterMissionIdInDB(arg_13_0, arg_13_1)
	local var_13_0 = (arg_13_0.db.missions[arg_13_1] or {}).chapter
	
	if var_13_0 then
		return DBT("quest_chapter", var_13_0, {
			"mission_id",
			"key_mission"
		})
	end
end

function QuestMissions.getDBIdAndKey(arg_14_0)
	local var_14_0
	local var_14_1
	local var_14_2
	local var_14_3
	local var_14_4
	local var_14_5
	local var_14_6
	
	for iter_14_0 = 1, 99 do
		local var_14_7, var_14_8, var_14_9 = DBN("quest_episode", iter_14_0, {
			"id",
			"mission_id",
			"key_chapter"
		})
		
		if not var_14_7 then
			break
		end
		
		if AccountData.quests.episode_quests[var_14_8] and AccountData.quests.episode_quests[var_14_8].state == "active" then
			var_14_0 = var_14_7
			var_14_1 = var_14_9
			var_14_2 = var_14_8
			
			break
		end
	end
	
	for iter_14_1 = 1, 99 do
		if not var_14_1 then
			break
		end
		
		local var_14_10, var_14_11, var_14_12 = DB("quest_chapter", var_14_1 .. "_" .. iter_14_1, {
			"id",
			"mission_id",
			"key_mission"
		})
		
		if not var_14_10 then
			break
		end
		
		if AccountData.quests.chapter_quests[var_14_11] and (AccountData.quests.chapter_quests[var_14_11].state == "active" or AccountData.quests.chapter_quests[var_14_11].state == "clear") then
			var_14_3 = var_14_10
			var_14_4 = var_14_12
			var_14_5 = var_14_11
			
			break
		end
	end
	
	local var_14_13 = Account:getChapterQuestMissions()
	
	for iter_14_2, iter_14_3 in pairs(arg_14_0.db.chapter_mission_id_list) do
		if Account:getChapterQuestMission(iter_14_3).state == "clear" then
			var_14_6 = iter_14_3
			
			break
		end
		
		if Account:getChapterQuestMission(iter_14_3).state == "active" then
			var_14_6 = iter_14_3
		end
	end
	
	return {
		id_ep = var_14_0,
		key_chapter = var_14_1,
		ep_mission = var_14_2,
		id_chapter = var_14_3,
		key_quest = var_14_4,
		chapter_mission = var_14_5,
		ui_chapter_m_id = var_14_6
	}
end

function QuestMissions.updateQuestMissions(arg_15_0)
	local var_15_0
	local var_15_1
	local var_15_2
	local var_15_3
	local var_15_4
	local var_15_5
	local var_15_6 = AccountData.quests.quest_m_id
	local var_15_7 = AccountData.quests.quests[AccountData.quests.quest_m_id]
	local var_15_8 = AccountData.quests.chapter_quests
	local var_15_9 = AccountData.quests.episode_quests
	local var_15_10 = arg_15_0:getDBIdAndKey()
	
	if not var_15_10 then
		return 
	end
	
	if arg_15_0.quest_m_id ~= var_15_6 then
		arg_15_0.quest_m_id = var_15_6
		
		local var_15_11, var_15_12 = DB("mission_data", arg_15_0.quest_m_id, {
			"condition",
			"value"
		})
		
		if var_15_11 and var_15_12 and not arg_15_0:createGroupHandler(arg_15_0.quest_m_id, var_15_11, var_15_12, arg_15_0:getScore(arg_15_0.quest_m_id)) then
			Log.e("quest_Error - function() updateQuestMissions", arg_15_0.quest_m_id, var_15_11, var_15_12)
			print(debug.traceback())
		end
	end
	
	arg_15_0.chapter_m_id = var_15_10.chapter_mission
	arg_15_0.ui_chapter_m_id = var_15_10.ui_chapter_m_id
	arg_15_0.chapter_key = var_15_10.key_quest
	arg_15_0.ep_m_id = var_15_10.ep_mission
	arg_15_0.ep_key = var_15_10.id_ep
	arg_15_0.key_quest = var_15_5
end

function QuestMissions.getDB(arg_16_0)
	return arg_16_0.db
end

function QuestMissions.getNotiCount(arg_17_0)
	local var_17_0 = 0
	
	for iter_17_0, iter_17_1 in pairs(AccountData.quests.quests) do
		local var_17_1 = arg_17_0:getUIChapterKey()
		
		if var_17_1 and string.starts(iter_17_0, var_17_1 .. "_") and iter_17_1.state == "clear" then
			var_17_0 = var_17_0 + 1
		end
	end
	
	return var_17_0
end

function QuestMissions.getClearCountUIChapter(arg_18_0)
	local var_18_0 = 0
	
	for iter_18_0, iter_18_1 in pairs(AccountData.quests.quests) do
		local var_18_1 = arg_18_0:getUIChapterKey()
		
		if var_18_1 and string.starts(iter_18_0, var_18_1 .. "_") and (iter_18_1.state == "clear" or iter_18_1.state == "received") then
			var_18_0 = var_18_0 + 1
		end
	end
	
	return var_18_0
end

function QuestMissions.getCountInChapter(arg_19_0, arg_19_1)
	arg_19_1 = arg_19_1 or arg_19_0.chapter_key
	
	local var_19_0 = 0
	
	for iter_19_0 = 1, 99 do
		if not DB("mission_data", arg_19_1 .. "_" .. iter_19_0, {
			"id"
		}) then
			break
		end
		
		var_19_0 = var_19_0 + 1
	end
	
	return var_19_0
end

function QuestMissions.getClearQuestCountInChapter(arg_20_0, arg_20_1)
	local var_20_0 = 0
	local var_20_1 = arg_20_1 or arg_20_0.chapter_key
	
	for iter_20_0, iter_20_1 in pairs(AccountData.quests.quests) do
		if string.starts(iter_20_0, var_20_1 .. "_") and (iter_20_1.state == "clear" or iter_20_1.state == "received") then
			var_20_0 = var_20_0 + 1
		end
	end
	
	return var_20_0
end

function QuestMissions.isAllClearQuestInChapter(arg_21_0)
	local var_21_0 = true
	local var_21_1 = arg_21_0:getUIChapterKey()
	
	for iter_21_0 = 1, 99 do
		local var_21_2 = DB("mission_data", var_21_1 .. "_" .. iter_21_0, {
			"id"
		})
		
		if not var_21_2 then
			break
		end
		
		if not AccountData.quests.quests[var_21_2] or AccountData.quests.quests[var_21_2] and AccountData.quests.quests[var_21_2].state ~= "clear" and AccountData.quests.quests[var_21_2].state ~= "received" then
			var_21_0 = false
		end
	end
	
	return var_21_0
end

function QuestMissions.isAllReceivedQuestReward(arg_22_0)
	local var_22_0 = true
	
	for iter_22_0, iter_22_1 in pairs(AccountData.quests.quests) do
		local var_22_1 = arg_22_0:getUIChapterKey()
		
		if var_22_1 and string.starts(iter_22_0, var_22_1 .. "_") and iter_22_1.state == "clear" then
			var_22_0 = false
		end
	end
	
	return var_22_0
end

function QuestMissions.isAllReceivedRewards(arg_23_0)
	local var_23_0 = true
	
	for iter_23_0, iter_23_1 in pairs(AccountData.quests.quests) do
		if iter_23_1.state == "clear" then
			var_23_0 = false
		end
	end
	
	for iter_23_2, iter_23_3 in pairs(AccountData.quests.chapter_quests) do
		if iter_23_3.state == "clear" then
			var_23_0 = false
		end
	end
	
	return var_23_0
end

function QuestMissions.isAllClearEpisode(arg_24_0)
	local var_24_0 = true
	
	for iter_24_0, iter_24_1 in pairs(AccountData.quests.chapter_quests) do
		if iter_24_1.state == "clear" or iter_24_1.state == "active" then
			var_24_0 = false
		end
	end
	
	return var_24_0
end

function QuestMissions.getCurrentQuestId(arg_25_0)
	return arg_25_0.quest_m_id
end

function QuestMissions.getCurrentChapterId(arg_26_0)
	return arg_26_0.chapter_m_id
end

function QuestMissions.getUIChapterMissionId(arg_27_0)
	return arg_27_0.ui_chapter_m_id
end

function QuestMissions.getUIChapterKey(arg_28_0)
	return (arg_28_0.db.chapter_missions[arg_28_0.ui_chapter_m_id] or {}).id or arg_28_0.db.last_chapter_key
end

function QuestMissions.getCurrentEpisodeId(arg_29_0)
	return arg_29_0.ep_m_id
end

function QuestMissions.hasNextQuest(arg_30_0)
	if not AccountData.quests.quest_m_id then
		return false
	end
	
	if arg_30_0.db.last_quest_id == AccountData.quests.quest_m_id and arg_30_0:getChapterData(arg_30_0.db.last_chapter_mission_id) and arg_30_0:getChapterData(arg_30_0.db.last_chapter_mission_id).state == "received" then
		return false
	end
	
	return true
end

function QuestMissions.getQuestData(arg_31_0, arg_31_1)
	if arg_31_1 then
		return AccountData.quests.quests[arg_31_1]
	end
	
	return AccountData.quests.quests[arg_31_0.quest_m_id]
end

function QuestMissions.getChapterData(arg_32_0, arg_32_1)
	if arg_32_1 then
		return AccountData.quests.chapter_quests[arg_32_1]
	end
	
	return AccountData.quests.chapter_quests[arg_32_0.chapter_m_id]
end

function QuestMissions.getEpData(arg_33_0, arg_33_1)
	if arg_33_1 then
		return AccountData.quests.episode_quests[arg_33_1]
	end
	
	return AccountData.quests.episode_quests[arg_33_0.ep_m_id]
end

function QuestMissions.setQuestsAccountData(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if arg_34_1 then
		AccountData.quests.quests = arg_34_1
	end
	
	if arg_34_2 then
		AccountData.quests.chapter_quests = arg_34_2
	end
	
	if arg_34_3 then
		AccountData.quests.episode_quests = arg_34_3
	end
end

function QuestMissions.setQuestAccountData(arg_35_0, arg_35_1)
	if arg_35_1.quest then
		AccountData.quests.quests[arg_35_1.mission_id] = arg_35_1.quest
	end
	
	if arg_35_1.chapter_q then
		AccountData.quests.chapter_quests[arg_35_1.mission_id] = arg_35_1.chapter_q
	end
	
	if arg_35_1.episode_q then
		AccountData.quests.episode_quests[arg_35_1.mission_id] = arg_35_1.episode_q
	end
	
	if arg_35_1.cur_quest then
		AccountData.quests.quest_m_id = arg_35_1.cur_quest
	end
end

function QuestMissions.setQuestInfos(arg_36_0, arg_36_1)
	for iter_36_0, iter_36_1 in pairs(arg_36_1 or {}) do
		AccountData.quests.quests[iter_36_0] = iter_36_1
	end
end

function QuestMissions.setUIQuest(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	arg_37_3 = arg_37_3 or {}
	
	if_set(arg_37_1, "txt_name", T(arg_37_2.db_name))
	if_set(arg_37_1, "txt_title", T(arg_37_2.db_desc) or "")
	if_set_sprite(arg_37_1, "img_face", "face/" .. arg_37_2.face_icon .. "_s.png")
	
	local var_37_0 = totable(arg_37_2.condition_value).count or "1"
	local var_37_1 = arg_37_0:getScore(arg_37_2.quest_id)
	local var_37_2 = arg_37_1:getChildByName("bg_progress")
	
	if var_37_2 then
		local var_37_3 = var_37_2:getChildByName("progress")
		
		if var_37_3 then
			var_37_3:setPercent(var_37_1 / var_37_0 * 100)
			if_set(var_37_2, "txt_progress", var_37_1 .. "/" .. var_37_0)
		end
	end
	
	local var_37_4 = {
		parent = arg_37_1:getChildByName("icon"),
		scale = arg_37_3.reward_scale,
		set_drop = arg_37_2.set_drop_id,
		grade_rate = arg_37_2.grade_rate
	}
	local var_37_5 = UIUtil:getRewardIcon(arg_37_2.reward_count, arg_37_2.reward_id, var_37_4)
end

function QuestMissions.setUIChapter(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	arg_38_3 = arg_38_3 or {}
	
	local var_38_0 = arg_38_1:getChildByName("title")
	local var_38_1 = arg_38_1:getChildByName("txt_chapter")
	
	if_set(var_38_0, nil, T(arg_38_2.chapter_name))
	if_set(var_38_1, nil, T(arg_38_2.chapter_desc))
	
	if var_38_0 and var_38_0:getStringNumLines() == 2 then
		local function var_38_2(arg_39_0)
			if not get_cocos_refid(arg_39_0) then
				return 
			end
			
			if not arg_39_0._origin_pos_x then
				arg_39_0._origin_pos_x, arg_39_0._origin_pos_y = arg_39_0:getPosition()
			end
			
			arg_39_0:setPosition(arg_39_0._origin_pos_x, arg_39_0._origin_pos_y - 12)
		end
		
		local var_38_3 = getChildByPath(arg_38_1, "CENTER/window_frame/n_center/txt_name")
		local var_38_4 = arg_38_1:getChildByName("txt_title")
		
		var_38_2(var_38_3)
		var_38_2(var_38_4)
	end
	
	local var_38_5 = ConditionContentsManager:getQuestMissions():getClearQuestCountInChapter(arg_38_2.key_mission)
	local var_38_6 = arg_38_1:getChildByName("exp")
	
	if var_38_6 then
		local var_38_7 = var_38_6:getChildByName("progress")
		local var_38_8 = arg_38_0:getCountInChapter()
		
		var_38_7:setPercent((var_38_5 - 1) / var_38_8 * 100)
		
		if var_38_6 then
			var_38_6:getChildByName("progress_up"):setPercent(var_38_5 / var_38_8 * 100)
			if_set(var_38_6, "txt_progress", T("quest_num", {
				score = var_38_5,
				count = var_38_8
			}))
		end
		
		if arg_38_3 and arg_38_3.gauge_action then
			UIAction:Add(LOG(PROGRESS(1500, (var_38_5 - 1) / var_38_8, var_38_5 / var_38_8)), var_38_7, "progress")
		end
	end
end

function QuestMissions.getScore(arg_40_0, arg_40_1)
	local var_40_0 = Account:getQuestMissions()
	
	if var_40_0[arg_40_1] == nil then
		return 0
	end
	
	local var_40_1, var_40_2 = DB("mission_data", arg_40_1, {
		"condition",
		"value"
	})
	
	return arg_40_0:getScore_datas(var_40_0, arg_40_1, var_40_1, var_40_2)
end

function QuestMissions.getConditionScore(arg_41_0, arg_41_1, arg_41_2)
	arg_41_2 = arg_41_2 or 1
	
	local var_41_0 = Account:getQuestMissions()
	
	return arg_41_0:getConditionScore_datas(var_41_0, arg_41_1, arg_41_2)
end
