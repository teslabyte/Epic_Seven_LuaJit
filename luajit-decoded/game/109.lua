ConditionContentsManager = ConditionContentsManager or {}

function MsgHandler.update_condition_list(arg_1_0)
	ConditionContentsManager:setIgnoreQuery(true)
	
	local var_1_0 = ConditionContentsManager:updateResponseConditionList(arg_1_0)
	
	ConditionContentsManager:setIgnoreQuery(false)
	ConditionContentsManager:queryUpdateConditions()
	
	if GrowthGuideNavigator:isNeedToResetQuestNavigator() then
		GrowthGuideNavigator:clearNavigators()
	end
	
	GrowthGuideNavigator:proc()
	ConditionContentsManager:onUpdateContentUI(var_1_0)
end

function MsgHandler.cheat_reset_condition(arg_2_0)
	Account:setConditionData(arg_2_0.conditions)
	Account:setFactions(arg_2_0.factions)
	ConditionContentsManager:getAchievement():initConditionListner()
end

function MsgHandler.check_clear_conditions(arg_3_0)
	local var_3_0 = {
		[arg_3_0.contents_type] = true
	}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.update_attributes or {}) do
		if arg_3_0.contents_type == CONTENTS_TYPE.CLASS_CHANGE_QUEST then
			Account:setClassChangeQuest(iter_3_1.contents_id, iter_3_1)
		elseif arg_3_0.contents_type == CONTENTS_TYPE.GROWTH_GUIDE_QUEST then
			Account:setGrowthGuideQuest(iter_3_1.contents_id, iter_3_1)
		elseif arg_3_0.contents_type == CONTENTS_TYPE.DESTINY then
			Account:setDestinyAchieve(iter_3_1.contents_id, iter_3_1)
		elseif arg_3_0.contents_type == CONTENTS_TYPE.EPISODE_MISSION then
			Account:updateEpisodeMission(iter_3_1)
		elseif arg_3_0.contents_type == CONTENTS_TYPE.CHAPTER_SHOP_QUEST then
			Account:setChapterShopQuest(iter_3_1.contents_id, iter_3_1)
		end
	end
	
	ConditionContentsManager:onUpdateContentUI(var_3_0)
end

function MsgHandler.give_conditon_contents(arg_4_0)
	Account:addReward(arg_4_0.result)
	
	local var_4_0 = {}
	
	if arg_4_0.conditions and arg_4_0.conditions.clear_conditions then
		for iter_4_0, iter_4_1 in pairs(arg_4_0.conditions.clear_conditions) do
			if var_4_0[iter_4_1.contents_type] == nil then
				var_4_0[iter_4_1.contents_type] = true
			end
			
			ConditionContentsManager:update(iter_4_1)
			ConditionContentsManager:setConditionGroupData(iter_4_1)
		end
	end
	
	for iter_4_2, iter_4_3 in pairs(arg_4_0.conditions.update_conditions or {}) do
		if var_4_0[iter_4_3.contents_type] == nil then
			var_4_0[iter_4_3.contents_type] = true
		end
		
		ConditionContentsManager:update(iter_4_3, arg_4_0.map)
		ConditionContentsManager:setConditionGroupData(iter_4_3)
	end
	
	ConditionContentsManager:onUpdateContentUI(var_4_0)
	balloon_message_with_sound("success_give_classchange_quest")
end

function ConditionContentsManager.init(arg_5_0)
	arg_5_0.battle_missions = DungeonMissions
	arg_5_0.urgent_missions = UrgentMissions
	arg_5_0.quest_missions = QuestMissions
	arg_5_0.achievement = Achievement
	arg_5_0.sys_achievement = SysAchievement
	arg_5_0.destiny_achievement = DestinyAchieve
	arg_5_0.clan_missions = ClanMissions
	arg_5_0.class_change_quest = ClassChangeQuest
	arg_5_0.growth_guide_quest = GrowthGuideQuest
	arg_5_0.chapter_shop_quest = ChapterShopQuest
	arg_5_0.substory_album_mission = SubStoryAlbumMisson
	arg_5_0.moonlight_achieve = MoonLightAchieve
	arg_5_0.contents_list = {
		battle_mission = arg_5_0.battle_missions,
		urgent_mission = arg_5_0.urgent_missions,
		quest_mission = arg_5_0.quest_missions,
		achievement = arg_5_0.achievement,
		sys_achievement = arg_5_0.sys_achievement,
		destiny = arg_5_0.destiny_achievement,
		clan_mission = arg_5_0.clan_missions,
		class_change_q = arg_5_0.class_change_quest,
		growth_guide_q = arg_5_0.growth_guide_quest,
		chapter_shop_q = arg_5_0.chapter_shop_quest,
		sub_album = arg_5_0.substory_album_mission,
		moonlight_achieve = arg_5_0.moonlight_achieve,
		ep_mission = EpisodeMission,
		ev_mission = EventMission,
		hidden_mission = HiddenMission,
		sub_story_q = SubStoryQuest,
		sub_story_a = SubStoryAchieve,
		sub_festival = SubStoryMissionFestival,
		sub_travel = SubStoryTravelMission,
		sub_cus_m = SubStoryCustomMission
	}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.contents_list) do
		if type(iter_5_1) == "table" and iter_5_1.init then
			iter_5_1:init()
		end
	end
	
	if not PRODUCTION_MODE then
		arg_5_0.test_missions = TestConditionMissions
	end
end

function ConditionContentsManager.initSubStory(arg_6_0)
	local var_6_0 = SubstoryManager:getInfo()
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1 = var_6_0.id
	
	ConditionContentsManager:clearSubStoryContents()
	
	if SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.TRAVEL) then
		arg_6_0:initSubStoryTravel(var_6_1)
	end
	
	if var_6_0.achieve_flag then
		arg_6_0:initSubStoryAchievement(var_6_1)
	end
	
	local var_6_2 = arg_6_0:initSubStoryQuest(var_6_1)
	
	if SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM) then
		arg_6_0:initSubStoryFestival(var_6_1)
	end
	
	ConditionContentsManager:initSubStoryCustomMission(var_6_1)
end

function ConditionContentsManager.initConditions(arg_7_0)
end

function ConditionContentsManager.initConditionsLobbyUpdate(arg_8_0)
	if BackPlayManager:isRunning() then
		return true
	end
	
	local var_8_0 = arg_8_0:getContents(CONTENTS_TYPE.EVENT_MISSION)
	
	if var_8_0 then
		var_8_0:initConditionListner()
	end
	
	ConditionContentsManager:getAchievement():initConditionListner()
	arg_8_0:getSysAchievement():initConditionListner()
	arg_8_0:getDestinyAchievement():initConditionListner()
	arg_8_0:getClanMissions():initConditionListner()
	arg_8_0:getClassChangeQuest():initConditionListner()
	arg_8_0:getGrowthGuideQuest():initConditionListner()
	arg_8_0:getChapterShopQuest():initConditionListner()
	arg_8_0:getMoonlightAchievement():initConditionListner()
	
	local var_8_1 = arg_8_0:getContents(CONTENTS_TYPE.EPISODE_MISSION)
	
	if var_8_1 then
		var_8_1:initConditionListner()
	end
	
	local var_8_2 = arg_8_0:getContents(CONTENTS_TYPE.HIDDEN_MISSION)
	
	if var_8_2 then
		var_8_2:initConditionListner()
	end
	
	ConditionContentsManager:initSubStoryAlbumConditions()
end

function ConditionContentsManager.initSubStoryAlbumConditions(arg_9_0)
	arg_9_0:getSubStoryAlbumMission():initConditionListner()
end

function ConditionContentsManager.initSubStoryAchievement(arg_10_0, arg_10_1)
	SubStoryAchieve:clear()
	SubStoryAchieve:createAchieve(arg_10_1)
end

function ConditionContentsManager.initSubStoryQuest(arg_11_0, arg_11_1)
	SubStoryQuest:clear()
	SubStoryQuest:createQuests(arg_11_1)
end

function ConditionContentsManager.initSubStoryFestival(arg_12_0, arg_12_1)
	SubStoryMissionFestival:clear()
	SubStoryMissionFestival:createMissoin(arg_12_1)
end

function ConditionContentsManager.initSubStoryTravel(arg_13_0, arg_13_1)
	SubStoryTravelMission:clear()
	SubStoryTravelMission:createMissoin(arg_13_1)
end

function ConditionContentsManager.initSubStoryCustomMission(arg_14_0, arg_14_1)
	SubStoryCustomMission:clear()
	SubStoryCustomMission:createMissoin(arg_14_1)
end

function ConditionContentsManager.updateLobbyConditionDispatch(arg_15_0)
	arg_15_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("account.link")
	arg_15_0:setIgnoreQuery(false)
	arg_15_0:queryUpdateConditions()
end

function ConditionContentsManager.updateConditionDispatch(arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or {}
	
	arg_16_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("collection.get", {
		force_type = "character"
	})
	ConditionContentsManager:dispatch("collection.get", {
		force_type = "monster"
	})
	ConditionContentsManager:dispatch("collection.get", {
		force_type = "summon"
	})
	ConditionContentsManager:dispatch("collectionequip.get", {
		force_type = "artifact"
	})
	ConditionContentsManager:dispatch("collectionpet.get", {
		force_type = "pet"
	})
	ConditionContentsManager:dispatch("user.levelup", {
		level = Account:getLevel()
	})
	ConditionContentsManager:dispatch("sync.destiny")
	ConditionContentsManager:dispatch("gacha.select")
	ConditionContentsManager:dispatch("sync.battle_max")
	ConditionContentsManager:dispatch("factionpoint.get")
	ConditionContentsManager:dispatch("pvp.league")
	ConditionContentsManager:dispatch("sync.fav")
	
	if arg_16_1.growth_guide then
		ConditionContentsManager:growthGuideForceUpdateConditions()
	end
	
	ConditionContentsManager:dispatch("shop.buystone")
	arg_16_0:setIgnoreQuery(false)
	arg_16_0:queryUpdateConditions()
end

function ConditionContentsManager.updateEventMissionConditionDispatch(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or {}
	
	arg_17_0:setIgnoreQuery(true)
	
	if not arg_17_1.ignore_migration then
		ConditionContentsManager:dispatch("user.levelup", {
			level = Account:getLevel()
		})
		ConditionContentsManager:dispatch("sync.battle_max")
	end
	
	local var_17_0 = Account:getEventTickets()
	
	if var_17_0 then
		for iter_17_0, iter_17_1 in pairs(var_17_0) do
			ConditionContentsManager:dispatch("login.ev_mission", {
				event_id = iter_17_0,
				login_cnt = iter_17_1.day_count
			})
		end
	end
	
	arg_17_0:setIgnoreQuery(false)
	arg_17_0:queryUpdateConditions()
end

function ConditionContentsManager.factionCategoryForceUpdateConditoins(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0:setIgnoreQuery(true)
	
	local var_18_0 = arg_18_0:getAchievement()
	local var_18_1 = {}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_2 or {}) do
		if not iter_18_1.hold and iter_18_1.value_data and not iter_18_1.value_data.group then
			local var_18_2 = Account:getFactionGroupInfo(iter_18_1.faction_id, iter_18_1.group_id) or {}
			local var_18_3 = var_18_0:getScore(iter_18_1.group_id) or 0
			local var_18_4 = iter_18_1.value_data.count or 1
			
			if (var_18_2.state or 0) == 0 and var_18_3 >= tonumber(var_18_4) then
				table.insert(var_18_1, iter_18_1.group_id)
			end
		end
	end
	
	if table.count(var_18_1) > 0 then
		query("force_clear_achievement", {
			faction_id = arg_18_1,
			datas = array_to_json(var_18_1)
		})
	end
	
	arg_18_0:setIgnoreQuery(false)
	arg_18_0:queryUpdateConditions()
end

function ConditionContentsManager.sicaForceUpdateConditions(arg_19_0)
end

function ConditionContentsManager.classChangeForceUpdateConditions(arg_20_0)
	arg_20_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("sync.fav.chr")
	arg_20_0:setIgnoreQuery(false)
	arg_20_0:queryUpdateConditions()
end

function ConditionContentsManager.adinForceUpdateConditions(arg_21_0)
	arg_21_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("sync.adin")
	arg_21_0:setIgnoreQuery(false)
	arg_21_0:queryUpdateConditions()
end

function ConditionContentsManager.destinyForceUpdateConditions(arg_22_0)
	arg_22_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("sync.fav.chr")
	ConditionContentsManager:dispatch("sync.force_credit")
	arg_22_0:setIgnoreQuery(false)
	arg_22_0:queryUpdateConditions()
end

function ConditionContentsManager.growthGuideForceUpdateConditions(arg_23_0)
	local var_23_0 = Account:getUnitsByCode("c3026")
	
	if table.count(var_23_0) > 0 then
		local var_23_1
		local var_23_2
		local var_23_3
		local var_23_4
		local var_23_5
		local var_23_6 = 0
		local var_23_7
		
		for iter_23_0, iter_23_1 in pairs(var_23_0) do
			local var_23_8 = iter_23_1:getZodiacGrade()
			local var_23_9 = iter_23_1:getLv()
			local var_23_10 = iter_23_1:getGrade()
			local var_23_11 = iter_23_1:getDevote()
			local var_23_12, var_23_13 = iter_23_1:getDevoteGrade(var_23_11)
			local var_23_14 = 0
			
			for iter_23_2, iter_23_3 in pairs(iter_23_1.inst.skill_lv or {}) do
				var_23_14 = var_23_14 + iter_23_3
			end
			
			if var_23_1 == nil or var_23_1 and var_23_8 > var_23_1:getZodiacGrade() then
				var_23_1 = iter_23_1
			end
			
			if var_23_2 == nil or var_23_2 and var_23_9 > var_23_2:getLv() then
				var_23_2 = iter_23_1
			end
			
			if var_23_3 == nil or var_23_3 and var_23_10 > var_23_3:getGrade() then
				var_23_3 = iter_23_1
			end
			
			if var_23_5 == nil or var_23_6 < var_23_14 then
				var_23_6 = var_23_14
				var_23_5 = iter_23_1
			end
			
			local var_23_15
			
			if var_23_4 then
				local var_23_16 = var_23_4:getDevote()
				local var_23_17
				
				var_23_17, var_23_15 = iter_23_1:getDevoteGrade(var_23_16)
			end
			
			if var_23_4 == nil or var_23_4 and var_23_15 and var_23_15 < var_23_13 then
				var_23_4 = iter_23_1
			end
			
			if var_23_7 == nil and iter_23_1:getUnitOptionValue("imprint_focus") == 2 then
				var_23_7 = iter_23_1
			end
		end
		
		ConditionContentsManager:dispatch("c3026.zodiac", {
			unit = var_23_1
		})
		ConditionContentsManager:dispatch("c3026.levelup", {
			unit = var_23_2
		})
		ConditionContentsManager:dispatch("c3026.skillup", {
			unit = var_23_5
		})
		ConditionContentsManager:dispatch("c3026.evo.grade", {
			unit = var_23_3
		})
		ConditionContentsManager:dispatch("c3026.dvt.grade", {
			unit = var_23_4
		})
		ConditionContentsManager:dispatch("c3026.dvt.self", {
			unit = var_23_7
		})
	end
	
	local var_23_18
	local var_23_19 = Account:getEquipsByCode("efw15")
	
	for iter_23_4, iter_23_5 in pairs(var_23_19) do
		local var_23_20 = iter_23_5:getDupPoint()
		
		if var_23_18 == nil or var_23_18 and var_23_20 > var_23_18:getDupPoint() then
			var_23_18 = iter_23_5
		end
	end
	
	if var_23_18 then
		ConditionContentsManager:dispatch("efw15.skilllevelup", {
			equip = var_23_18
		})
	end
	
	ConditionContentsManager:dispatch("battle.clear.sync")
	ConditionContentsManager:dispatch("sync.classchange")
end

function ConditionContentsManager.tournamentForceUpdateConditions(arg_24_0)
	arg_24_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("sync.tournament")
	arg_24_0:setIgnoreQuery(false)
	arg_24_0:queryUpdateConditions()
end

function ConditionContentsManager.substoryEnterForceUpdateConditions(arg_25_0)
	local var_25_0 = SubstoryManager:getInfo()
	
	if not var_25_0 then
		return 
	end
	
	ConditionContentsManager:dispatch("substory.star.reward", {
		substory_id = var_25_0.id
	})
end

function ConditionContentsManager.achievementClearForceUpdateConditions(arg_26_0, arg_26_1, arg_26_2)
	if arg_26_2 == "phantom_036" then
		ConditionContentsManager:dispatch("pvp.league")
	end
end

function ConditionContentsManager.moonlightDestinyQuestForceUpdateConditions(arg_27_0)
	arg_27_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("pvp.league")
	ConditionContentsManager:dispatch("battle.clear.sync", {
		content = "moonlight_destiny"
	})
	arg_27_0:setIgnoreQuery(false)
	arg_27_0:queryUpdateConditions()
end

function ConditionContentsManager.customProfileForceUpdateConditions(arg_28_0)
	arg_28_0:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("user.levelup", {
		level = Account:getLevel()
	})
	ConditionContentsManager:dispatch("sync.classchange")
	ConditionContentsManager:dispatch("battle.clear.sync", {
		content = "profile"
	})
	arg_28_0:setIgnoreQuery(false)
	arg_28_0:queryUpdateConditions()
end

function ConditionContentsManager.dispatch(arg_29_0, arg_29_1, arg_29_2)
	arg_29_2 = arg_29_2 or {}
	
	if not SAVE:isTutorialFinished() and is_enable_minimal() then
		return 
	end
	
	if arg_29_2.ignore_condition then
		print("ignore condition")
		
		return 
	end
	
	if DEBUG.UPDATE_CONDITION and arg_29_1 ~= "battle.cs" then
		print("dispatch??", arg_29_1)
	end
	
	if ContentDisable:byAlias("background_achievement") and string.starts(arg_29_1, "battle.") and arg_29_2.unique_id then
		local var_29_0 = BackPlayManager:getBattles()
		
		for iter_29_0, iter_29_1 in pairs(var_29_0) do
			if iter_29_1.logic:getBattleUID() == arg_29_2.unique_id then
				return 
			end
		end
	end
	
	for iter_29_2, iter_29_3 in pairs(arg_29_0.contents_list) do
		iter_29_3:dispatch(arg_29_1, arg_29_2)
	end
	
	if not PRODUCTION_MODE and arg_29_0.test_missions then
		arg_29_0.test_missions:dispatch(arg_29_1, arg_29_2)
	end
end

function ConditionContentsManager.update(arg_30_0, arg_30_1, arg_30_2)
	for iter_30_0, iter_30_1 in pairs(arg_30_0.contents_list) do
		if iter_30_0 == "battle_mission" and iter_30_1:getContentsType() == arg_30_1.contents_type then
			iter_30_1:update(arg_30_1.contents_id, arg_30_1.state, arg_30_2)
		elseif iter_30_1:getContentsType() == arg_30_1.contents_type then
			iter_30_1:update(arg_30_1)
		end
	end
	
	if table.count(arg_30_0.contents_list or {}) > 0 then
		arg_30_0:checkUnlockCondition()
	end
end

function ConditionContentsManager.updateResponseConditionList(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = {}
	
	if arg_31_1.conditions and arg_31_1.conditions.clear_conditions then
		if arg_31_2 then
			ConditionContentsNotifier:processPendingNotifications(arg_31_1.conditions.clear_conditions)
		else
			ConditionContentsNotifier:show(arg_31_1.conditions.clear_conditions)
		end
		
		GrowthGuide:updateAutoTracking(arg_31_1.conditions.clear_conditions)
		
		for iter_31_0, iter_31_1 in pairs(arg_31_1.conditions.clear_conditions) do
			if var_31_0[iter_31_1.contents_type] == nil then
				var_31_0[iter_31_1.contents_type] = true
			end
			
			ConditionContentsManager:update(iter_31_1, arg_31_1.map)
			ConditionContentsManager:setConditionGroupData(iter_31_1)
		end
		
		for iter_31_2, iter_31_3 in pairs(arg_31_1.conditions.update_conditions or {}) do
			if var_31_0[iter_31_3.contents_type] == nil then
				var_31_0[iter_31_3.contents_type] = true
			end
			
			ConditionContentsManager:update(iter_31_3, arg_31_1.map)
			ConditionContentsManager:setConditionGroupData(iter_31_3)
		end
	end
	
	if var_31_0[CONTENTS_TYPE.SUBSTORY_ACHIEVE] then
		ConditionContentsManager:dispatch("subachieve.clear")
	end
	
	return var_31_0
end

function ConditionContentsManager.checkUnlockCondition(arg_32_0)
	for iter_32_0, iter_32_1 in pairs(arg_32_0.contents_list) do
		iter_32_1:checkUnlockCondition()
	end
end

function ConditionContentsManager.isMissionCleared(arg_33_0, arg_33_1, arg_33_2)
	if AccountData.conditions.groups[arg_33_1] then
		arg_33_0.achievement:isCleared(arg_33_1)
	else
		if arg_33_0.battle_missions:isCleared(arg_33_1, arg_33_2) then
			return true
		end
		
		if arg_33_2 and arg_33_2.inbattle and arg_33_0.battle_missions:isMissionClearExpected(arg_33_1) then
			return true
		end
		
		if arg_33_0.quest_missions:isCleared(arg_33_1) then
			return true
		end
	end
	
	return false
end

function ConditionContentsManager.setIgnoreCheckConditionOption(arg_34_0, arg_34_1)
end

function ConditionContentsManager.setIgnoreQuery(arg_35_0, arg_35_1)
	for iter_35_0, iter_35_1 in pairs(arg_35_0.contents_list) do
		iter_35_1:setIgnoreQuery(arg_35_1)
	end
end

function ConditionContentsManager.resetAllAdd(arg_36_0)
	for iter_36_0, iter_36_1 in pairs(arg_36_0.contents_list or {}) do
		iter_36_1:resetAdd()
	end
end

function ConditionContentsManager.cleanUpVltTbl(arg_37_0)
	local var_37_0 = Battle:getPlayingBattleUID()
	
	if StoryMap:isShow() then
		local var_37_1 = StoryMap:getEnterID()
		
		if var_37_1 then
			table.insert(var_37_0, var_37_1)
		end
	end
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.contents_list or {}) do
		iter_37_1:cleanUpVltTbl(var_37_0)
	end
end

function ConditionContentsManager.clearContents(arg_38_0, arg_38_1)
	if SubstoryManager:isValidScene(arg_38_1) == false then
		arg_38_0:clearSubStoryContents()
	end
end

function ConditionContentsManager.clearSubStoryContents(arg_39_0)
	if not arg_39_0.contents_list then
		return 
	end
	
	for iter_39_0, iter_39_1 in pairs(SUBSTORY_COND_CONTENTS_TYPE) do
		if arg_39_0.contents_list[iter_39_1] then
			arg_39_0.contents_list[iter_39_1]:clear()
		end
	end
end

function ConditionContentsManager.setConditionGroupData(arg_40_0, arg_40_1)
	for iter_40_0, iter_40_1 in pairs(arg_40_0.contents_list) do
		if iter_40_0 == "quest_mission" and arg_40_1.contents_type == iter_40_1:getContentsType() then
			iter_40_1:resetAdd(arg_40_1.cur_quest_id)
		elseif iter_40_0 == "achievement" and arg_40_1.contents_type == iter_40_1:getContentsType() then
			iter_40_1:setConditionGroupData(arg_40_1.group_id, arg_40_1.group)
			iter_40_1:resetAdd(arg_40_1.group_id)
		elseif arg_40_1.contents_type == iter_40_1:getContentsType() then
			iter_40_1:resetAdd(arg_40_1.contents_id)
		end
	end
end

function ConditionContentsManager.checkUpdateConditions(arg_41_0, arg_41_1)
end

function ConditionContentsManager.queryUpdateConditions(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0:getUpdateConditions({
		no_battle_mission = true
	})
	
	print("update_conditon_groups", var_42_0)
	
	if var_42_0 then
		if DEBUG.UPDATE_CONDITION or getenv("DEBUG.UPDATE_CONDITION") == true then
			print(debug.traceback())
			print("error log! update_condition_list", arg_42_1)
		end
		
		query("update_condition_list", {
			update_condition_groups = json.encode(var_42_0),
			log_title = arg_42_1
		})
	end
end

function ConditionContentsManager.restoreUpdateConditions(arg_43_0, arg_43_1)
	if not arg_43_1 then
		return 
	end
	
	for iter_43_0, iter_43_1 in pairs(arg_43_1) do
		if arg_43_0.contents_list[iter_43_0] then
			arg_43_0.contents_list[iter_43_0]:restore(iter_43_1.group, iter_43_1.conditions)
		end
	end
end

function ConditionContentsManager.getBattleUpdateConditions(arg_44_0, arg_44_1)
	arg_44_1 = arg_44_1 or {}
	arg_44_1.is_battle = true
	
	arg_44_0:getUpdateConditions(arg_44_1)
end

function ConditionContentsManager.getUpdateConditions(arg_45_0, arg_45_1)
	local var_45_0
	local var_45_1 = 22372633
	
	arg_45_1 = arg_45_1 or {}
	
	if not arg_45_0.contents_list then
		return 
	end
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.contents_list) do
		local var_45_2, var_45_3 = iter_45_1:getUpdateContents(arg_45_1)
		
		if var_45_2 and var_45_3 then
			var_45_0 = var_45_0 or {}
			var_45_0[iter_45_0] = {}
			var_45_0[iter_45_0].group, var_45_0[iter_45_0].conditions = var_45_2, var_45_3
		end
	end
	
	for iter_45_2, iter_45_3 in pairs(var_45_0 or {}) do
		for iter_45_4, iter_45_5 in pairs(iter_45_3.conditions or {}) do
			if iter_45_5.ukey and iter_45_5.score then
				var_45_1 = var_45_1 + string_hash(tostring(iter_45_5.ukey .. tostring(iter_45_5.score)))
			end
		end
	end
	
	if var_45_0 then
		var_45_0.condition_value = var_45_1
	end
	
	if not arg_45_1.no_reset then
		ConditionContentsManager:resetAllAdd()
	end
	
	return var_45_0
end

function ConditionContentsManager.getExportConditions(arg_46_0, arg_46_1)
	local var_46_0
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0.contents_list) do
		local var_46_1
		local var_46_2
		
		if iter_46_0 == "battle_mission" then
			var_46_1, var_46_2 = iter_46_1:getExportContents()
		elseif iter_46_0 == "urgent_mission" then
			if arg_46_1 and arg_46_1.enter_id then
				var_46_1, var_46_2 = iter_46_1:getInBattleMissions(arg_46_1.enter_id)
			else
				var_46_1, var_46_2 = iter_46_1:getExportContents()
			end
		else
			var_46_1, var_46_2 = iter_46_1:getExportContents()
		end
		
		if var_46_1 and var_46_2 then
			var_46_0 = var_46_0 or {}
			var_46_0[iter_46_0] = {}
			var_46_0[iter_46_0].group, var_46_0[iter_46_0].conditions = var_46_1, var_46_2
		end
	end
	
	return var_46_0
end

function ConditionContentsManager.getDungeonMissions(arg_47_0)
	return arg_47_0.battle_missions
end

function ConditionContentsManager.getUrgentMissions(arg_48_0)
	return arg_48_0.urgent_missions
end

function ConditionContentsManager.getQuestMissions(arg_49_0)
	return arg_49_0.quest_missions
end

function ConditionContentsManager.getAchievement(arg_50_0)
	return arg_50_0.achievement
end

function ConditionContentsManager.getSysAchievement(arg_51_0)
	return arg_51_0.sys_achievement
end

function ConditionContentsManager.getDestinyAchievement(arg_52_0)
	return arg_52_0.destiny_achievement
end

function ConditionContentsManager.getClanMissions(arg_53_0)
	return arg_53_0.clan_missions
end

function ConditionContentsManager.getSubStoryAchievement(arg_54_0)
	return arg_54_0:getContents(CONTENTS_TYPE.SUBSTORY_ACHIEVE)
end

function ConditionContentsManager.getSubStoryQuest(arg_55_0)
	return arg_55_0:getContents(CONTENTS_TYPE.SUBSTORY_QUETS)
end

function ConditionContentsManager.getClassChangeQuest(arg_56_0)
	return arg_56_0.class_change_quest
end

function ConditionContentsManager.getGrowthGuideQuest(arg_57_0)
	return arg_57_0.growth_guide_quest
end

function ConditionContentsManager.getChapterShopQuest(arg_58_0)
	return arg_58_0.chapter_shop_quest
end

function ConditionContentsManager.getSubStoryAlbumMission(arg_59_0)
	return arg_59_0.substory_album_mission
end

function ConditionContentsManager.getMoonlightAchievement(arg_60_0)
	return arg_60_0.moonlight_achieve
end

function ConditionContentsManager.getContents(arg_61_0, arg_61_1)
	if not arg_61_0.contents_list then
		return 
	end
	
	return arg_61_0.contents_list[arg_61_1]
end

function ConditionContentsManager.getNotifierControl(arg_62_0, arg_62_1)
	local var_62_0 = {}
	
	for iter_62_0, iter_62_1 in pairs(arg_62_1) do
		local var_62_1 = ConditionContentsManager:getContents(iter_62_1.contents_type)
		
		if var_62_1 then
			var_62_1:getNotifierControl(var_62_0, iter_62_1)
		end
	end
	
	return var_62_0
end

CM = CM or {}

function CM.festival_score(arg_63_0, arg_63_1, arg_63_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager:getContents(CONTENTS_TYPE.SUBSTORY_FESTIVAL):setForceUpdateContests(arg_63_1, arg_63_2)
end

function CM.travel_score(arg_64_0, arg_64_1, arg_64_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager:getContents(CONTENTS_TYPE.SUBSTORY_TRAVEL):setForceUpdateContests(arg_64_1, arg_64_2)
end

function CM.ep_m_score(arg_65_0, arg_65_1, arg_65_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager:getContents(CONTENTS_TYPE.EPISODE_MISSION):setForceUpdateContests(arg_65_1, arg_65_2)
end

function CM.sc_m_score(arg_66_0, arg_66_1, arg_66_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager:getContents(CONTENTS_TYPE.SUBSTORY_CUSTOM_MISSION):setForceUpdateContests(arg_66_1, arg_66_2)
end

function CM.e_m_score(arg_67_0, arg_67_1, arg_67_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager:getContents(CONTENTS_TYPE.EVENT_MISSION):setForceUpdateContests(arg_67_1, arg_67_2)
end

function CM.h_m_score(arg_68_0, arg_68_1, arg_68_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager:getContents(CONTENTS_TYPE.HIDDEN_MISSION):setForceUpdateContests(arg_68_1, arg_68_2)
end

function CM.add_condition(arg_69_0, arg_69_1, arg_69_2)
	if PRODUCTION_MODE then
		return 
	end
	
	ConditionContentsManager.test_missions:addMission(arg_69_1, arg_69_2)
end

function CM.print_vlt_tbl(arg_70_0, arg_70_1, arg_70_2)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_70_0 = ConditionContentsManager:getContents(arg_70_1)
	
	if not var_70_0 then
		Log.e("CM.print_vlt_tbl , contents_type is nil")
		
		return 
	end
	
	local var_70_1 = var_70_0:getGroup(arg_70_2)
	
	if not var_70_1 then
		Log.e("CM.print_vlt_tbl , group is nil")
		
		return 
	end
	
	if var_70_1.condition_list == nil or var_70_1.condition_list[1] == nil then
		Log.e("CM.print_vlt_tbl , condition_list is nil")
		
		return 
	end
	
	local var_70_2 = var_70_1.condition_list[1]:getVltTblAll()
	
	if var_70_2 then
		table.print(var_70_2)
	else
		Log.e("CM.print_vlt_tbl , getVltTblAll is nil")
		
		return 
	end
	
	print(var_70_1.contents_type, var_70_1.condition_list[1].condition, var_70_1.condition_list[1].value)
end

function CM.print_vlt_all(arg_71_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_71_0 = ConditionContentsManager:getContentsList()
	
	for iter_71_0, iter_71_1 in pairs(var_71_0 or {}) do
		local var_71_1 = iter_71_1:getGroups()
		
		for iter_71_2, iter_71_3 in pairs(var_71_1) do
			if iter_71_3.condition_list then
				for iter_71_4, iter_71_5 in pairs(iter_71_3.condition_list or {}) do
					local var_71_2 = iter_71_5:getVltTblAll()
					
					for iter_71_6, iter_71_7 in pairs(var_71_2 or {}) do
						if iter_71_7.count then
							print("error vlt_count id", iter_71_3.contents_id, iter_71_3.contents_type, "vlt_count: ", iter_71_7.count, "condition: ", iter_71_5.condition, "value: ", iter_71_5.value)
						end
						
						if table.count(iter_71_7.vars or {}) > 0 then
							print("error vlt_vars cond_", iter_71_3.contents_id, iter_71_3.contents_type, "vlt_count : ", iter_71_7.count, "cur_count:", iter_71_5:getCurCount(), "condition: ", iter_71_5.condition, "value:", iter_71_5.value)
							
							for iter_71_8, iter_71_9 in pairs(iter_71_7.vars) do
								print("error vlt_vars key:", iter_71_8, "value:", iter_71_9)
							end
						end
					end
				end
			end
		end
	end
end

function CM.test_cond_clear(arg_72_0)
	ConditionContentsManager.test_missions:clear()
end

function CM.print_conditions(arg_73_0, arg_73_1, arg_73_2)
	if PRODUCTION_MODE then
		return 
	end
	
	print("*************************************")
	
	for iter_73_0, iter_73_1 in pairs(ConditionContentsManager.test_missions:getGroups()) do
		print("cond_", iter_73_0)
		
		for iter_73_2, iter_73_3 in pairs(iter_73_1.condition_list) do
			if arg_73_1 then
				print(iter_73_3.condition)
				print(iter_73_3.value)
			end
			
			if arg_73_2 then
				local var_73_0 = iter_73_3:getVltTblAll()
				
				if table.count(var_73_0) > 0 then
					print("==vlt_tbl==")
					table.print(var_73_0)
				end
			end
			
			local var_73_1 = 0
			
			for iter_73_4, iter_73_5 in pairs(iter_73_3:getVltTblAll()) do
				var_73_1 = var_73_1 + iter_73_3:getVltCount(iter_73_4)
			end
			
			print("vlt_count : ", var_73_1)
			print("add_count : ", iter_73_3.add_count or 0)
			print("*************************************")
		end
	end
end

function CM.print_ev(arg_74_0)
	if PRODUCTION_MODE then
		return 
	end
	
	table.print(ConditionContentsManager.test_missions:getEvents(), 1)
end

function ConditionContentsManager.onUpdateContentUI(arg_75_0, arg_75_1)
	local var_75_0 = {
		[CONTENTS_TYPE.SUBSTROY_ALBUM] = SubstoryAlbumMain,
		[CONTENTS_TYPE.ACHIEVEMENT] = AchievementBase,
		[CONTENTS_TYPE.CLASS_CHANGE_QUEST] = ClassChangeQuestList,
		[CONTENTS_TYPE.GROWTH_GUIDE_QUEST] = GrowthGuideBase,
		[CONTENTS_TYPE.DESTINY] = DestinyAchieveList,
		[CONTENTS_TYPE.MOONLIHGT_ACHIEVE] = MoonlightDestinyQuest,
		[CONTENTS_TYPE.SUBSTORY_FESTIVAL] = SubStoryFestival,
		[CONTENTS_TYPE.EPISODE_MISSION] = EpisodeAdinUI,
		[CONTENTS_TYPE.SUBSTORY_CUSTOM_MISSION] = SubStoryCustom,
		[CONTENTS_TYPE.SYS_ACHIEVEMENT] = GrowthBoostUI,
		[CONTENTS_TYPE.EVENT_MISSION] = WebEventNoti,
		[CONTENTS_TYPE.CHAPTER_SHOP_QUEST] = ShopChapterUtil,
		[CONTENTS_TYPE.HIDDEN_MISSION] = CustomProfileCardEditor
	}
	
	for iter_75_0, iter_75_1 in pairs(arg_75_1) do
		if var_75_0[iter_75_0] and var_75_0[iter_75_0].onUpdateUI then
			var_75_0[iter_75_0]:onUpdateUI()
		end
	end
end

function ConditionContentsManager.getContentsList(arg_76_0)
	return arg_76_0.contents_list
end

local function var_0_0(arg_77_0)
	local var_77_0 = ""
	
	for iter_77_0 = 1, 99 do
		local var_77_1 = string.format("%s_ach_%02d", arg_77_0, iter_77_0)
		local var_77_2, var_77_3 = DB("substory_achievement", var_77_1, {
			"id",
			"ignore_complete_cond"
		})
		
		if not var_77_2 then
			break
		end
		
		if not var_77_3 then
			if iter_77_0 ~= 1 then
				var_77_0 = var_77_0 .. ";"
			end
			
			var_77_0 = var_77_0 .. var_77_2
		end
	end
	
	return var_77_0
end

function ConditionContentsManager.checkState(arg_78_0, arg_78_1, arg_78_2)
	local var_78_0 = {}
	
	for iter_78_0, iter_78_1 in pairs(arg_78_0.contents_list) do
		if iter_78_1:getContentsType() == arg_78_1 and iter_78_1.checkState then
			var_78_0 = iter_78_1:checkState(arg_78_2)
			
			break
		end
	end
	
	if var_78_0 and type(var_78_0) == "table" and #var_78_0 > 0 then
		query("check_clear_conditions", {
			contents_type = arg_78_1,
			clear_list = array_to_json(var_78_0)
		})
	end
end

ConditionContentsState = ConditionContentsState or {}

function ConditionContentsState.getClearData(arg_79_0, arg_79_1)
	local var_79_0 = DBT("condition_state", arg_79_1, {
		"contents_type_1",
		"value_1",
		"condition_check_type"
	})
	local var_79_1 = {
		is_cleared = true,
		db = var_79_0,
		contents_ids = {}
	}
	
	var_79_1.is_cleared, var_79_1.clear_cnt, var_79_1.total_cnt = arg_79_0:isClearedByStateID(arg_79_1, var_79_0)
	
	for iter_79_0 = 1, 10 do
		local var_79_2 = var_79_0["contents_type_" .. iter_79_0]
		local var_79_3 = var_79_0["value_" .. iter_79_0]
		
		if not var_79_2 or not var_79_3 then
			break
		end
		
		if var_79_0.condition_check_type == "all_clear" then
			var_79_3 = var_0_0(var_79_3)
		end
		
		local var_79_4 = string.split(var_79_3, ";")
		
		table.add(var_79_1.contents_ids, var_79_4)
		
		return var_79_1
	end
end

function ConditionContentsState.isClearedByStateID(arg_80_0, arg_80_1, arg_80_2)
	arg_80_2 = arg_80_2 or DBT("condition_state", arg_80_1, {
		"contents_type_1",
		"value_1",
		"condition_check_type"
	})
	
	if not arg_80_2 or not arg_80_2.contents_type_1 or not arg_80_2.value_1 then
		return false
	end
	
	if not PRODUCTION_MODE and DEBUG.CLEAR_CONDITION_STATE then
		return true
	end
	
	local var_80_0 = true
	local var_80_1 = 0
	local var_80_2 = 0
	
	for iter_80_0 = 1, 10 do
		local var_80_3 = arg_80_2["contents_type_" .. iter_80_0]
		local var_80_4 = arg_80_2["value_" .. iter_80_0]
		
		if not var_80_3 or not var_80_4 then
			break
		end
		
		if arg_80_2.condition_check_type == "reward_receive" then
			local var_80_5, var_80_6, var_80_7 = arg_80_0:isRewarded(var_80_3, var_80_4)
			
			if var_80_0 == true and var_80_5 == false then
				var_80_0 = false
			end
			
			var_80_1 = var_80_1 + var_80_7
			var_80_2 = var_80_2 + var_80_6
		elseif arg_80_2.condition_check_type == "clear" then
			local var_80_8, var_80_9, var_80_10 = arg_80_0:isCleared(var_80_3, var_80_4)
			
			if var_80_0 == true and var_80_8 == false then
				var_80_0 = false
			end
			
			var_80_1 = var_80_1 + var_80_10
			var_80_2 = var_80_2 + var_80_9
		elseif arg_80_2.condition_check_type == "all_clear" then
			if var_80_3 ~= CONTENTS_TYPE.SUBSTORY_ACHIEVE then
				var_80_0 = false
				
				Log.e("invalid_type", "all_clear")
				
				break
			end
			
			local var_80_11 = DB("substory_main", var_80_4, "id")
			
			if not var_80_11 then
				var_80_0 = false
				
				break
			end
			
			local var_80_12 = var_0_0(var_80_11)
			local var_80_13, var_80_14, var_80_15 = arg_80_0:isCleared(var_80_3, var_80_12)
			
			if var_80_0 == true and var_80_13 == false then
				var_80_0 = false
			end
			
			var_80_1 = var_80_1 + var_80_15
			var_80_2 = var_80_2 + var_80_14
		end
	end
	
	return var_80_0, var_80_2, var_80_1
end

function ConditionContentsState.isCleared(arg_81_0, arg_81_1, arg_81_2)
	local var_81_0 = ConditionContentsManager:getContents(arg_81_1)
	local var_81_1 = 0
	local var_81_2 = 0
	
	if not var_81_0 then
		Log.e("err_condition_state_iscleared", "type: " .. arg_81_1 .. ", value: " .. arg_81_2)
		print(debug.traceback())
		
		return false
	end
	
	local var_81_3 = string.split(arg_81_2, ";")
	
	for iter_81_0, iter_81_1 in pairs(var_81_3) do
		var_81_1 = var_81_1 + 1
		
		if var_81_0:isCleared(iter_81_1) then
			var_81_2 = var_81_2 + 1
		end
	end
	
	return var_81_1 <= var_81_2, var_81_2, var_81_1
end

function ConditionContentsState.isRewarded(arg_82_0, arg_82_1, arg_82_2)
	local var_82_0 = ConditionContentsManager:getContents(arg_82_1)
	local var_82_1 = 0
	local var_82_2 = 0
	
	if not var_82_0 then
		Log.e("err_condition_state_isRewarded", "type: " .. arg_82_1 .. ", value: " .. arg_82_2)
		print(debug.traceback())
		
		return false
	end
	
	local var_82_3 = string.split(arg_82_2, ";")
	
	for iter_82_0, iter_82_1 in pairs(var_82_3) do
		var_82_1 = var_82_1 + 1
		
		if var_82_0:isRewarded(iter_82_1) then
			var_82_2 = var_82_2 + 1
		end
	end
	
	return var_82_1 <= var_82_2, var_82_2, var_82_1
end

ConditionContentsNotifier = ConditionContentsNotifier or {}

function ConditionContentsNotifier.show(arg_83_0, arg_83_1, arg_83_2)
	if UIAction:Find("ConditionContentsNotifier") or UIAction:Find("ConditionContentsNotifier.delay.expire") then
		arg_83_0:addWaitList(arg_83_1, arg_83_2)
		
		return 
	end
	
	if not UIAction:Find("ConditionContentsNotifier") and not UIAction:Find("ConditionContentsNotifier.delay") and not UIAction:Find("ConditionContentsNotifier.delay.expire") then
		arg_83_0:expire()
	end
	
	arg_83_0.noti_list = arg_83_0.noti_list or {}
	
	arg_83_0:pushWaitListToNoti()
	
	if arg_83_1 or arg_83_2 then
		local var_83_0 = arg_83_2 or ConditionContentsManager:getNotifierControl(arg_83_1)
		
		if #var_83_0 <= 0 then
			return 
		end
		
		for iter_83_0, iter_83_1 in pairs(var_83_0) do
			arg_83_0:push(iter_83_1)
		end
	end
	
	if not UIAction:Find("ConditionContentsNotifier.delay") and #arg_83_0.noti_list > 0 then
		UIAction:Add(SEQ(DELAY(500), CALL(ConditionContentsNotifier.action, arg_83_0)), arg_83_0, "ConditionContentsNotifier.delay")
	end
end

function ConditionContentsNotifier.processPendingNotifications(arg_84_0, arg_84_1)
	local var_84_0 = {}
	
	for iter_84_0, iter_84_1 in pairs(arg_84_1) do
		local var_84_1 = iter_84_1.contents_type
		local var_84_2 = ConditionContentsManager:getContents(var_84_1)
		
		if var_84_2 then
			local var_84_3 = var_84_2:getNotifierControl(var_84_0, iter_84_1)
			
			if get_cocos_refid(var_84_3) then
				var_84_3:setVisible(false)
			end
			
			local var_84_4 = var_84_3 and var_84_3.args
			
			if var_84_4 then
				if not arg_84_0.pending_noti_list then
					arg_84_0.pending_noti_list = {}
				end
				
				if not arg_84_0.pending_noti_list[var_84_1] then
					arg_84_0.pending_noti_list[var_84_1] = {}
				end
				
				table.insert(arg_84_0.pending_noti_list[var_84_1], var_84_4)
			end
		end
	end
end

function ConditionContentsNotifier.playPendingNotifications(arg_85_0)
	if table.empty(arg_85_0.pending_noti_list) then
		return 
	end
	
	local var_85_0 = 1
	
	for iter_85_0, iter_85_1 in pairs(arg_85_0.pending_noti_list) do
		local var_85_1 = ConditionContentsManager:getContents(iter_85_0)
		
		for iter_85_2, iter_85_3 in pairs(iter_85_1) do
			if var_85_1 then
				local var_85_2 = var_85_1:createNotifyControl(var_85_0, iter_85_3[1], iter_85_3[2], iter_85_3[3], iter_85_3[4], iter_85_3[5])
				
				ConditionContentsNotifier:addWaitControl(var_85_2)
				
				var_85_0 = var_85_0 + 1
			end
		end
	end
	
	arg_85_0:show()
	arg_85_0:resetPendingNotifications()
end

function ConditionContentsNotifier.resetPendingNotifications(arg_86_0)
	arg_86_0.pending_noti_list = nil
end

function ConditionContentsNotifier.addWaitControl(arg_87_0, arg_87_1)
	if not get_cocos_refid(arg_87_1) then
		return 
	end
	
	arg_87_0.wait_list = arg_87_0.wait_list or {}
	
	arg_87_1:setVisible(false)
	table.insert(arg_87_0.wait_list, arg_87_1)
end

function ConditionContentsNotifier.addWaitList(arg_88_0, arg_88_1, arg_88_2)
	if not arg_88_1 and not arg_88_2 then
		return 
	end
	
	arg_88_0.wait_list = arg_88_0.wait_list or {}
	
	local var_88_0 = arg_88_2 or ConditionContentsManager:getNotifierControl(arg_88_1)
	
	if #var_88_0 <= 0 then
		return 
	end
	
	for iter_88_0, iter_88_1 in pairs(var_88_0) do
		iter_88_1:setVisible(false)
	end
	
	table.add(arg_88_0.wait_list, var_88_0)
end

function ConditionContentsNotifier.pushWaitListToNoti(arg_89_0)
	if arg_89_0.wait_list and #arg_89_0.wait_list > 0 then
		for iter_89_0, iter_89_1 in pairs(arg_89_0.wait_list) do
			arg_89_0:push(iter_89_1)
		end
	end
	
	arg_89_0.wait_list = {}
end

local function var_0_1(arg_90_0)
	if NOTCH_WIDTH > 0 and not NotchStatus:isLeft() then
		return arg_90_0
	end
	
	return 0
end

function ConditionContentsNotifier.push(arg_91_0, arg_91_1)
	arg_91_0.noti_list = arg_91_0.noti_list or {}
	
	if arg_91_1 and get_cocos_refid(arg_91_1) then
		local var_91_0 = var_0_1(DESIGN_HEIGHT * 0.13)
		
		arg_91_1:setPosition(-arg_91_1:getContentSize().width + VIEW_BASE_LEFT, DESIGN_HEIGHT * 0.07 + var_91_0)
		arg_91_1:setVisible(true)
		table.insert(arg_91_0.noti_list, arg_91_1)
	end
end

function ConditionContentsNotifier.action(arg_92_0)
	arg_92_0.noti_list = arg_92_0.noti_list or {}
	
	local function var_92_0(arg_93_0)
		EffectManager:Play({
			fn = "ui_achieve_bar_glow.cfx",
			pivot_z = 99998,
			scale = 1,
			layer = arg_93_0,
			pivot_x = arg_93_0:getContentSize().width / 2 - 12,
			pivot_y = arg_93_0:getContentSize().height / 2 + 3
		})
	end
	
	local var_92_1 = 0
	local var_92_2 = DESIGN_HEIGHT * 0.5
	local var_92_3 = {}
	
	for iter_92_0 = #arg_92_0.noti_list, 1, -1 do
		local var_92_4 = arg_92_0.noti_list[iter_92_0]
		
		if get_cocos_refid(var_92_4) then
			local var_92_5 = var_92_2 - 300
			local var_92_6 = var_0_1(NOTCH_WIDTH / 2)
			local var_92_7 = var_92_4:getContentSize().width + var_92_6
			
			UIAction:Add(SEQ(DELAY(iter_92_0 * 800), CALL(var_92_0, var_92_4), MOVE_BY(330, var_92_7, 0), DELAY(200), CALL(ConditionContentsNotifier.moveAll, arg_92_0, iter_92_0)), var_92_4, "ConditionContentsNotifier")
		end
	end
	
	UIAction:Add(SEQ(arg_92_0:wait(), DELAY(2000), CALL(ConditionContentsNotifier.expire, ConditionContentsNotifier), CALL(ConditionContentsNotifier.showWaitList, ConditionContentsNotifier)), arg_92_0, "ConditionContentsNotifier.delay.expire")
end

function ConditionContentsNotifier.moveAll(arg_94_0, arg_94_1)
	for iter_94_0 = #arg_94_0.noti_list, 1, -1 do
		if iter_94_0 <= arg_94_1 and (#arg_94_0.noti_list <= 4 or arg_94_1 ~= #arg_94_0.noti_list) then
			local var_94_0 = arg_94_0.noti_list[iter_94_0]
			
			UIAction:Add(LOG(MOVE_BY(600, 0, var_94_0:getContentSize().height)), var_94_0, "ConditionContentsNotifier")
		end
	end
end

function ConditionContentsNotifier.wait(arg_95_0)
	return COND_LOOP(SEQ(DELAY(200)), function()
		if not UIAction:Find("ConditionContentsNotifier") then
			return true
		end
	end)
end

function ConditionContentsNotifier.expire(arg_97_0, arg_97_1)
	print("ConditionContentsNotifier.expire!")
	
	for iter_97_0 = #(arg_97_0.noti_list or {}), 1, -1 do
		local var_97_0 = arg_97_0.noti_list[iter_97_0]
		
		UIAction:Add(SEQ(OPACITY(300, 1, 0), REMOVE()), var_97_0, "ConditionContentsNotifier.expire")
	end
	
	UIAction:Remove("ConditionContentsNotifier")
	UIAction:Remove("ConditionContentsNotifier.delay")
	UIAction:Remove("ConditionContentsNotifier.delay.expire")
	
	arg_97_0.noti_list = {}
end

function ConditionContentsNotifier.showWaitList(arg_98_0)
	if arg_98_0.wait_list and #arg_98_0.wait_list > 0 then
		arg_98_0:show()
	end
end

function ConditionContentsNotifier.test(arg_99_0, arg_99_1)
	local var_99_0 = {}
	
	for iter_99_0 = 1, arg_99_1 or 1 do
		local var_99_1 = ConditionContentsManager:getAchievement():createNotifyControl(iter_99_0, "name", "desc")
		
		var_99_1:setVisible(false)
		table.insert(var_99_0, var_99_1)
	end
	
	arg_99_0:show(nil, var_99_0)
end
