MoonlightDestiny = MoonlightDestiny or {}
MoonlightDestiny.vars = {}

function MsgHandler.relation_moonlight_change(arg_1_0)
	if arg_1_0.res ~= "ok" then
		return 
	end
	
	if arg_1_0.relation_moonlight then
		Account:setRelationMoonlightSeason(arg_1_0.relation_moonlight)
	end
	
	ConditionContentsManager:getMoonlightAchievement():initConditionListner()
	
	if arg_1_0.rewards then
		local var_1_0 = {
			single = true,
			play_reward_data = {}
		}
		
		Account:addReward(arg_1_0.rewards, var_1_0)
	end
	
	MoonlightDestinyMsgBox:close()
	MoonlightDestinyHero:close()
	MoonlightDestinyQuest:open()
	ConditionContentsManager:dispatch("moonlight.change")
end

function ErrHandler.relation_moonlight_change(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == "gacha_select_not_completed" then
		Dialog:msgBox(T("character_mc_after_summon"))
		
		return 
	end
end

function MsgHandler.relation_moonlight_change_recall(arg_3_0)
	if arg_3_0.res ~= "ok" then
		return 
	end
	
	Singular:event("Moonlight_Connections_recall")
	
	if arg_3_0.relation_moonlight then
		Account:setRelationMoonlightSeason(arg_3_0.relation_moonlight)
	end
	
	ConditionContentsManager:getMoonlightAchievement():initConditionListner()
	
	if arg_3_0.use_rewards then
		Account:addReward(arg_3_0.use_rewards)
	end
	
	if arg_3_0.deleted_unit_id then
		local var_3_0 = Account:getUnit(arg_3_0.deleted_unit_id)
		
		if var_3_0 then
			Account:removeUnit(var_3_0)
		end
	end
	
	if arg_3_0.unequiped_list then
		for iter_3_0, iter_3_1 in pairs(arg_3_0.unequiped_list) do
			local var_3_1 = Account:getEquip(iter_3_1)
			
			if var_3_1 then
				local var_3_2 = Account:getUnit(var_3_1.parent)
				
				if var_3_2 then
					var_3_2:removeEquip(var_3_1)
				end
			end
		end
	end
	
	MoonlightDestinyHero:open()
	MoonlightDestinyQuest:close()
	MoonlightDestinyRecall:close()
	
	if arg_3_0.rewards then
		Account:addReward(arg_3_0.rewards, {
			ignore_get_condition = true
		})
	end
end

function MsgHandler.test_relmoon_reset(arg_4_0)
	if arg_4_0.deleted_season and AccountData.relation_moonlight then
		AccountData.relation_moonlight[arg_4_0.deleted_season] = nil
	end
	
	if arg_4_0.deleted_mission_list and AccountData.relation_moonlight_achievement then
		for iter_4_0, iter_4_1 in pairs(arg_4_0.deleted_mission_list) do
			AccountData.relation_moonlight_achievement[iter_4_1] = nil
		end
	end
	
	if arg_4_0.deleted_unit_list then
		for iter_4_2, iter_4_3 in pairs(arg_4_0.deleted_unit_list) do
			Account:removeUnit(iter_4_3)
		end
	end
	
	SceneManager:nextScene("lobby")
end

function MsgHandler.relation_moonlight_achievement_complete(arg_5_0)
	if arg_5_0.res ~= "ok" then
		return 
	end
	
	if not arg_5_0.info then
		return 
	end
	
	Account:updateRelationMoonlightAchievement(arg_5_0.info)
	
	local var_5_0 = MoonlightDestiny:questIDToIndex(arg_5_0.info.contents_id)
	
	if not var_5_0 then
		return 
	end
	
	MoonlightDestinyQuest:effectUnlockQuest(var_5_0)
	MoonlightDestinyQuest:updateQuests()
	MoonlightDestinyQuest:updateFinalLock()
	Singular:event("Moonlight_Connections_q" .. var_5_0)
end

function MsgHandler.relation_moonlight_complete(arg_6_0)
	if arg_6_0.res ~= "ok" then
		return 
	end
	
	Singular:event("Moonlight_Connections_complete")
	
	if arg_6_0.relation_moonlight then
		Account:setRelationMoonlightSeason(arg_6_0.relation_moonlight)
	end
	
	if arg_6_0.unit then
		local var_6_0 = Account:getUnit(arg_6_0.unit.id)
		
		if var_6_0 then
			var_6_0.inst.code = arg_6_0.unit.code
			var_6_0.inst.zodiac = math.min(6, arg_6_0.unit.z or 0)
			var_6_0.inst.grade = arg_6_0.unit.g
			var_6_0.inst.devote = arg_6_0.unit.d
			var_6_0.inst.stree = arg_6_0.unit.stree or {}
			var_6_0.inst.unit_option = arg_6_0.unit.opt
			
			var_6_0:setExp(arg_6_0.unit.exp)
			var_6_0:setSkillLevelInfo(arg_6_0.unit.s or {
				0,
				0,
				0
			})
			var_6_0:bindGameDB(var_6_0.inst.code, var_6_0.inst.skin_code)
			var_6_0:updateZodiacSkills()
			var_6_0:reset()
		end
	end
	
	if arg_6_0.updated_collections then
		Account:updateCollectionData(arg_6_0.updated_collections)
	end
	
	local var_6_1
	
	if arg_6_0.rewards then
		Account:addReward(arg_6_0.rewards)
		
		if arg_6_0.rewards.new_coins then
			var_6_1 = arg_6_0.rewards.new_coins[1]
		end
	end
	
	UIAction:Add(SEQ(CALL(function()
		MoonlightDestinyQuest:onComplete()
	end), DELAY(2000), CALL(function()
		GachaUnit:external_summon(arg_6_0.unit.code, 0, nil, var_6_1, SceneManager:getRunningPopupScene(), function()
			SceneManager:nextScene("lobby")
		end)
	end)), MoonlightDestinyQuest.vars.wnd, "block")
end

function MoonlightDestiny.initDataMoonlightDestinySeason(arg_10_0)
	if not arg_10_0.vars.moonlight_destiny_seasons then
		arg_10_0.vars.moonlight_destiny_seasons = {}
		arg_10_0.vars.moonlight_destiny_seasons_list = {}
		
		for iter_10_0 = 1, 9999 do
			local var_10_0 = DBNFields("moonlight_destiny_season", iter_10_0, {
				"id",
				"season",
				"lobby_name",
				"name",
				"name_2",
				"desc",
				"bg",
				"banner_bg",
				"recruit_unlock_text",
				"unlock_condition_ml_theater",
				"effect_title",
				"effect_desc",
				"effect_icon",
				"btn_lock_text"
			})
			
			if not var_10_0.id then
				break
			end
			
			arg_10_0.vars.moonlight_destiny_seasons[var_10_0.id] = var_10_0
			
			table.insert(arg_10_0.vars.moonlight_destiny_seasons_list, var_10_0)
		end
	end
	
	if table.empty(arg_10_0.vars.moonlight_destiny_seasons) then
		Log.e("MoonlightDestiny", "moonlight_destiny_season 데이타가 없습니다.")
	end
end

function MoonlightDestiny.initDataCharacterAchievement(arg_11_0)
	if not arg_11_0.vars.character_achievements then
		arg_11_0.vars.character_achievements = {}
		arg_11_0.vars.character_achievements_list = {}
		arg_11_0.vars.character_achievements_season_lists = {}
		
		for iter_11_0 = 1, 9999 do
			local var_11_0 = DBNFields("character_achievement", iter_11_0, {
				"id",
				"season",
				"condition",
				"value",
				"name",
				"desc",
				"icon",
				"icon2",
				"reward_id"
			})
			
			if not var_11_0.id then
				break
			end
			
			arg_11_0.vars.character_achievements[var_11_0.id] = var_11_0
			
			table.insert(arg_11_0.vars.character_achievements_list, var_11_0)
			
			arg_11_0.vars.character_achievements_season_lists[var_11_0.season] = arg_11_0.vars.character_achievements_season_lists[var_11_0.season] or {}
			
			table.insert(arg_11_0.vars.character_achievements_season_lists[var_11_0.season], var_11_0)
		end
		
		for iter_11_1, iter_11_2 in pairs(arg_11_0.vars.character_achievements_season_lists) do
			for iter_11_3, iter_11_4 in pairs(iter_11_2) do
				iter_11_4.index = iter_11_3
				arg_11_0.vars.character_achievements[iter_11_4.id].index = iter_11_3
			end
		end
	end
	
	if table.empty(arg_11_0.vars.character_achievements) then
		Log.e("MoonlightDestiny", "character_achievement 데이타가 없습니다.")
	end
end

function MoonlightDestiny.initDataCharacterReference(arg_12_0)
	if not arg_12_0.vars.characters then
		arg_12_0.vars.characters = {}
		arg_12_0.vars.characters_list = {}
		arg_12_0.vars.characters_season_lists = {}
		
		for iter_12_0 = 1, 9999 do
			local var_12_0 = DBNFields("character_reference", iter_12_0, {
				"id",
				"relation_character",
				"sort",
				"recommend",
				"moonlight_season"
			})
			
			if not var_12_0.id then
				break
			end
			
			if var_12_0.relation_character then
				arg_12_0.vars.characters[var_12_0.id] = var_12_0
				
				table.insert(arg_12_0.vars.characters_list, var_12_0)
				
				arg_12_0.vars.characters_season_lists[var_12_0.moonlight_season] = arg_12_0.vars.characters_season_lists[var_12_0.moonlight_season] or {}
				
				table.insert(arg_12_0.vars.characters_season_lists[var_12_0.moonlight_season], var_12_0)
			end
		end
		
		table.sort(arg_12_0.vars.characters_list, function(arg_13_0, arg_13_1)
			return to_n(arg_13_0.sort) < to_n(arg_13_1.sort)
		end)
		
		for iter_12_1, iter_12_2 in pairs(arg_12_0.vars.characters_season_lists) do
			table.sort(iter_12_2, function(arg_14_0, arg_14_1)
				return to_n(arg_14_0.sort) < to_n(arg_14_1.sort)
			end)
		end
	end
	
	if table.empty(arg_12_0.vars.characters) then
		Log.e("MoonlightDestiny", "character_reference 데이타가 없습니다.")
	end
end

function MoonlightDestiny.initData(arg_15_0)
	arg_15_0.vars.dirty_flag = false
	
	arg_15_0:initDataMoonlightDestinySeason()
	arg_15_0:initDataCharacterAchievement()
	arg_15_0:initDataCharacterReference()
end

function MoonlightDestiny.getCharacterAchievements(arg_16_0)
	if not arg_16_0.vars.character_achievements then
		arg_16_0:initData()
	end
	
	return arg_16_0.vars.character_achievements
end

function MoonlightDestiny.getCharacterAchievement(arg_17_0, arg_17_1)
	if not arg_17_0.vars.character_achievements then
		arg_17_0:initData()
	end
	
	if not arg_17_1 then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.character_achievements[arg_17_1]
	
	if not var_17_0 then
		Log.e("character_achievement", arg_17_1 .. " is not valid.")
		
		return nil
	end
	
	return var_17_0
end

function MoonlightDestiny.getCharacterAchievementsList(arg_18_0, arg_18_1)
	if not arg_18_0.vars.character_achievements_list then
		arg_18_0:initData()
	end
	
	arg_18_1 = arg_18_1 or arg_18_0:getCurrentSeasonNumber()
	
	if not arg_18_1 then
		return 
	end
	
	return arg_18_0.vars.character_achievements_season_lists[arg_18_1]
end

function MoonlightDestiny.getCharacterAchievementByIndex(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0:getCharacterAchievementsList(arg_19_2)
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = var_19_0[arg_19_1]
	
	if not var_19_1 then
		return 
	end
	
	return var_19_1
end

function MoonlightDestiny.getCharactersList(arg_20_0, arg_20_1)
	if not arg_20_0.vars.characters_season_lists then
		arg_20_0:initData()
	end
	
	arg_20_1 = arg_20_1 or arg_20_0:getCurrentSeasonNumber()
	
	if not arg_20_1 then
		return 
	end
	
	return arg_20_0.vars.characters_season_lists[arg_20_1]
end

function MoonlightDestiny.getRelationCharacterCode(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	if not arg_21_0.vars.characters then
		arg_21_0:initData()
	end
	
	local var_21_0 = arg_21_0.vars.characters[arg_21_1]
	
	if not var_21_0 then
		return 
	end
	
	return var_21_0.relation_character
end

function MoonlightDestiny.isRelationCharacterCode(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_1 then
		return false
	end
	
	if not arg_22_2 then
		return false
	end
	
	if arg_22_1 == arg_22_2 then
		return 
	end
	
	if arg_22_0:isDestinyCharacter(arg_22_1) then
		return arg_22_0:getRelationCharacterCode(arg_22_1) == arg_22_2
	end
	
	if arg_22_0:isDestinyCharacter(arg_22_2) then
		return arg_22_0:getRelationCharacterCode(arg_22_2) == arg_22_1
	end
	
	return false
end

function MoonlightDestiny.getSelectCharacterCode(arg_23_0)
	local var_23_0 = Account:getRelationMoonlightSeason()
	
	return var_23_0 and var_23_0.code or nil
end

function MoonlightDestiny.getQuestState(arg_24_0, arg_24_1)
	local var_24_0 = totable(arg_24_1.value)
	local var_24_1 = {
		is_complete = false,
		is_unlock = false,
		progress = 0,
		total_count = to_n(var_24_0.count)
	}
	
	if not AccountData.relation_moonlight_achievement then
		return var_24_1
	end
	
	local var_24_2 = AccountData.relation_moonlight_achievement[arg_24_1.id]
	
	if not var_24_2 then
		return var_24_1
	end
	
	var_24_1.progress = var_24_2.score1
	var_24_1.is_complete = var_24_2.state > 0
	var_24_1.is_unlock = var_24_2.state > 1
	
	return var_24_1
end

function MoonlightDestiny.getCurrentSeasonID(arg_25_0)
	if not arg_25_0.vars.moonlight_destiny_seasons then
		arg_25_0:initData()
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.moonlight_destiny_seasons_list) do
		if not arg_25_0:isCompleteSeason(iter_25_1.season) then
			return iter_25_1.id
		end
	end
end

function MoonlightDestiny.getCurrentSeasonNumber(arg_26_0)
	local var_26_0 = arg_26_0:getCurrentSeasonID()
	
	if not var_26_0 then
		return 
	end
	
	return arg_26_0.vars.moonlight_destiny_seasons[var_26_0].season
end

function MoonlightDestiny.getSeasonDataByID(arg_27_0, arg_27_1)
	if not arg_27_0.vars.moonlight_destiny_seasons then
		arg_27_0:initData()
	end
	
	arg_27_1 = arg_27_1 or arg_27_0:getCurrentSeasonID()
	
	if not arg_27_1 then
		Log.e("MoonlightDestiny", "season_id is nil.")
		
		return nil
	end
	
	return arg_27_0.vars.moonlight_destiny_seasons[arg_27_1]
end

function MoonlightDestiny.getSeasonDataByNumber(arg_28_0, arg_28_1)
	if not arg_28_0.vars.moonlight_destiny_seasons_list then
		arg_28_0:initData()
	end
	
	arg_28_1 = arg_28_1 or arg_28_0:getCurrentSeasonNumber()
	
	return arg_28_0.vars.moonlight_destiny_seasons_list[arg_28_1]
end

function MoonlightDestiny.getLastSeasonData(arg_29_0)
	local var_29_0 = table.count(arg_29_0.vars.moonlight_destiny_seasons_list)
	
	return arg_29_0:getSeasonDataByNumber(var_29_0)
end

function MoonlightDestiny.getSeasonTitle(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:getSeasonDataByNumber(arg_30_1)
	
	if not var_30_0 then
		return ""
	end
	
	if not var_30_0.name_2 then
		return ""
	end
	
	return T(var_30_0.name_2)
end

function MoonlightDestiny.getRecruitUnlockText(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0:getSeasonDataByNumber(arg_31_1)
	
	if not var_31_0 then
		return ""
	end
	
	if not var_31_0.recruit_unlock_text then
		return ""
	end
	
	return T(var_31_0.recruit_unlock_text)
end

function MoonlightDestiny.getRecruitDesc(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:getSeasonDataByNumber(arg_32_1)
	
	if not var_32_0 then
		return ""
	end
	
	if not var_32_0.desc then
		return ""
	end
	
	return T(var_32_0.desc)
end

function MoonlightDestiny.getBannerBackgroundImagePath(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0:getSeasonDataByNumber(arg_33_1)
	
	if not var_33_0 then
		return 
	end
	
	if not var_33_0.banner_bg then
		return 
	end
	
	return "banner/" .. var_33_0.banner_bg .. ".png"
end

function MoonlightDestiny.getBackgroundImagePath(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0:getSeasonDataByNumber(arg_34_1)
	
	if not var_34_0 then
		return 
	end
	
	if not var_34_0.bg then
		return 
	end
	
	return "banner/" .. var_34_0.bg .. ".png"
end

function MoonlightDestiny.isSelect(arg_35_0)
	if arg_35_0:getSelectCharacterCode() then
		return true
	end
	
	return false
end

function MoonlightDestiny.isUnlockSeason(arg_36_0, arg_36_1)
	arg_36_1 = arg_36_1 or arg_36_0:getCurrentSeasonNumber()
	
	if not arg_36_1 then
		return false
	end
	
	local var_36_0 = arg_36_0:getSeasonDataByNumber(arg_36_1)
	
	if not var_36_0 then
		return false
	end
	
	if arg_36_1 == 1 then
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.MOONLIGHT_DESTINY)
	end
	
	if not arg_36_0:isCompleteSeason(arg_36_1 - 1) then
		return false
	end
	
	if var_36_0.unlock_condition_ml_theater and Account:isCleared_mlt_ep(var_36_0.unlock_condition_ml_theater) then
		return true
	end
	
	return false
end

function MoonlightDestiny.isCompleteSeason(arg_37_0, arg_37_1)
	local var_37_0 = Account:getRelationMoonlightSeason(arg_37_1)
	
	if var_37_0 and to_n(var_37_0.state) > 0 then
		return true
	end
	
	return false
end

function MoonlightDestiny.isCompleteAllSeason(arg_38_0)
	local var_38_0 = arg_38_0:getLastSeasonData()
	
	if var_38_0 then
		return arg_38_0:isCompleteSeason(var_38_0.season)
	end
	
	return false
end

function MoonlightDestiny.getUnlockMessage(arg_39_0, arg_39_1)
	arg_39_1 = arg_39_1 or arg_39_0:getCurrentSeasonNumber()
	
	if arg_39_1 == 1 then
		return UnlockSystem:getSystemEnterData(UNLOCK_ID.MOONLIGHT_DESTINY)
	end
	
	local var_39_0 = arg_39_0:getSeasonDataByNumber(arg_39_1)
	
	if var_39_0 then
		return var_39_0.btn_lock_text
	end
	
	return ""
end

function MoonlightDestiny.show(arg_40_0)
	if not arg_40_0:isUnlockSeason() then
		local var_40_0 = arg_40_0:getUnlockMessage()
		
		if not string.empty(var_40_0) then
			balloon_message_with_sound(var_40_0)
		end
		
		return false
	end
	
	if SceneManager:getCurrentSceneName() == "moonlight_destiny" then
		return false
	end
	
	SceneManager:nextScene("moonlight_destiny", {})
	SoundEngine:play("event:/ui/whoosh_a")
	
	return true
end

function MoonlightDestiny.isThereAnyCompletedAchievement(arg_41_0)
	local var_41_0 = arg_41_0:getCharacterAchievementsList()
	
	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		local var_41_1 = arg_41_0:getQuestState(iter_41_1)
		
		if var_41_1.is_complete and not var_41_1.is_unlock then
			return true
		end
	end
	
	return false
end

function MoonlightDestiny.isEnableRedDot(arg_42_0)
	if not arg_42_0:isUnlockSeason() then
		return false
	end
	
	if not arg_42_0:isSelect() then
		return true
	end
	
	if arg_42_0:isThereAnyCompletedAchievement() then
		return true
	end
	
	return false
end

function MoonlightDestiny.isDestinyCharacter(arg_43_0, arg_43_1)
	return arg_43_0:getRelationCharacterCode(arg_43_1) ~= nil
end

function MoonlightDestiny.isQuestUnlocked(arg_44_0, arg_44_1)
	local var_44_0 = "character_ach_"
	local var_44_1 = arg_44_0:getCurrentSeasonNumber()
	
	if var_44_1 > 1 then
		var_44_0 = var_44_0 .. "s" .. var_44_1 .. "_"
	end
	
	local var_44_2 = var_44_0 .. string.format("%02d", arg_44_1)
	local var_44_3 = arg_44_0:getCharacterAchievement(var_44_2)
	
	if not var_44_3 then
		return false
	end
	
	local var_44_4 = arg_44_0:getQuestState(var_44_3)
	
	if not var_44_4 then
		return false
	end
	
	return var_44_4.is_unlock
end

function MoonlightDestiny.isLockWorldArena(arg_45_0, arg_45_1)
	return arg_45_0:isDestinyCharacter(arg_45_1)
end

function MoonlightDestiny.isAllSeasonQuestUnlocked(arg_46_0, arg_46_1)
	arg_46_1 = arg_46_1 or arg_46_0:getCurrentSeasonNumber()
	
	local var_46_0 = arg_46_0:getCharacterAchievementsList()
	
	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		if not arg_46_0:getQuestState(iter_46_1).is_unlock then
			return false
		end
	end
	
	return true
end

function MoonlightDestiny.isQuestCompleted(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0:getCharacterAchievement(arg_47_1)
	
	if not var_47_0 then
		return false
	end
	
	local var_47_1 = arg_47_0:getQuestState(var_47_0)
	
	if not var_47_1 then
		return false
	end
	
	return var_47_1.is_complete
end

function MoonlightDestiny.isLastSelectChance(arg_48_0)
	local var_48_0 = Account:getRelationMoonlightSeason()
	
	if var_48_0 and var_48_0.reset_count == 1 then
		return true
	end
	
	return false
end

function MoonlightDestiny.questIDToIndex(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0:getCharacterAchievement(arg_49_1)
	
	if not var_49_0 then
		return 
	end
	
	return var_49_0.index
end

function MoonlightDestiny.onMoonlightTheaterStoryFirstClear(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0:getSeasonDataByID()
	
	if var_50_0 and var_50_0.unlock_condition_ml_theater == arg_50_1 then
		arg_50_0:popupUnlockInfoDialog(var_50_0)
	end
end

function MoonlightDestiny.popupUnlockInfoDialog(arg_51_0, arg_51_1)
	if arg_51_1 then
		UIUtil:popupUnlockInfoDialog(nil, arg_51_1.effect_title, arg_51_1.effect_desc, arg_51_1.effect_icon)
	end
end

function MoonlightDestiny.__reset()
	if PRODUCTION_MODE then
		return 
	end
	
	query("test_relmoon_reset")
end

function MoonlightDestiny.__completeQuest(arg_53_0, arg_53_1, arg_53_2)
	if PRODUCTION_MODE then
		return 
	end
	
	if arg_53_1 then
		local var_53_0 = arg_53_0:getCharacterAchievementByIndex(arg_53_1, arg_53_2)
		
		if not var_53_0 then
			return 
		end
		
		ConditionContentsManager:getMoonlightAchievement():setForceUpdateContests(var_53_0.id, 999)
		
		return 
	end
	
	for iter_53_0, iter_53_1 in pairs(arg_53_0:getCharacterAchievementsList()) do
		ConditionContentsManager:getMoonlightAchievement():setForceUpdateContests(iter_53_1.id, 999)
	end
end
