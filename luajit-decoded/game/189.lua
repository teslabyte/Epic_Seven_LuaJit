BattleStory = {}

function BattleStory.init(arg_1_0, arg_1_1)
	arg_1_0.logic = arg_1_1
	arg_1_0.vars = {}
	arg_1_0.vars.played_story_list = {}
end

function BattleStory.playEnterLevelStory(arg_2_0, arg_2_1)
	if arg_2_0.logic:getInitData().restore_data then
		return 
	end
	
	arg_2_0.vars.played_story_list = arg_2_0.vars.played_story_list or {}
	
	local var_2_0 = arg_2_0:getStoryData(arg_2_1)
	
	if var_2_0 and arg_2_0:isPlayableStory(arg_2_1, var_2_0) then
		local var_2_1 = start_new_story(nil, var_2_0, {
			is_fadeout = true,
			force = arg_2_0:isStoryMode(),
			on_finish = function()
				TutorialGuide:onBattleStoryEnd(var_2_0)
			end
		})
		
		saveBattleInfo()
		
		if var_2_1 then
			local var_2_2 = arg_2_0.logic:getBattleUID()
			
			ConditionContentsManager:dispatch("battle.story", {
				unique_id = var_2_2,
				storyid = var_2_0,
				ignore_condition = Battle:checkIgnoreCondition()
			})
			table.insert(arg_2_0.vars.played_story_list, var_2_0)
			arg_2_0.logic:addPlayedStoryList(var_2_0)
		end
	end
end

function BattleStory.playEnterRoadStory(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0, var_4_1 = arg_4_0:getStoryData(arg_4_2)
	
	return arg_4_0:startStory(arg_4_1, var_4_1)
end

function BattleStory.playRoadEventStory(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0, var_5_1 = arg_5_0:getStoryData(arg_5_2.story_id)
	
	if arg_5_3 == "before" then
		return arg_5_0:startStory(arg_5_1, var_5_0)
	elseif arg_5_3 == "after" then
		return arg_5_0:startStory(arg_5_1, var_5_1)
	end
end

function BattleStory.isQuest(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:isStoryMode()
	
	arg_6_0.vars.played_story_list = arg_6_0.vars.played_story_list or {}
	
	if table.isInclude(arg_6_0.vars.played_story_list, function(arg_7_0, arg_7_1)
		if arg_7_1 == arg_6_1 then
			return true
		end
	end) then
		var_6_0 = false
	end
	
	return var_6_0
end

function BattleStory.isReadyToPlay(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if DEBUG.SKIP_STORY then
		return 
	end
	
	if arg_8_0.logic:getFinalResult() == "lose" then
		return 
	end
	
	return true
end

function BattleStory.isPlayableStory(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0:isReadyToPlay(arg_9_2) then
		return 
	end
	
	local var_9_0 = DEBUG.DEBUG_STORY or arg_9_0:isForceStory() or arg_9_0:isQuest(arg_9_2)
	
	if not DEBUG.DEBUG_STORY then
		if var_9_0 == nil then
			local var_9_1, var_9_2, var_9_3 = DB("level_enter", arg_9_1, {
				"id",
				"type",
				"atlas_id"
			})
			
			if not var_9_1 then
				Log.e("invalid_enter_id", "BattleStory.isPlayableStory")
			end
			
			local var_9_4 = arg_9_0.logic:getCurrentSubstoryID()
			
			if var_9_4 and var_9_4 ~= "vewrda" or var_9_3 then
				if Account:isPlayedStory(arg_9_2) then
					return 
				end
			elseif Account:isMapCleared(arg_9_1) then
				return 
			end
		end
		
		if var_9_0 == false then
			return 
		end
	end
	
	return true
end

function BattleStory.isForceStory(arg_10_0)
	local var_10_0 = DB("level_enter", arg_10_0.logic.map.enter, "force_story")
	
	return var_10_0 and var_10_0 == "y"
end

function BattleStory.startStory(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0:isReadyToPlay(arg_11_2) then
		return 
	end
	
	if not arg_11_0:isPlayableStory(arg_11_1, arg_11_2) then
		return 
	end
	
	if DEBUG.DEBUG_STORY and Battle.logic:getCurrentRoadInfo().road_id == "ije00900" then
		DEBUG.DEBUG_STORY = false
	end
	
	local var_11_0 = arg_11_0.logic:getMoonlightTheaterEpisodeID() ~= nil
	
	local function var_11_1()
		return true
	end
	
	local var_11_2
	
	if arg_11_2 == "intro_story_b" then
		var_11_2 = var_11_1
	end
	
	local var_11_3 = play_story(arg_11_2, {
		force = DEBUG.DEBUG_STORY or arg_11_0:isForceStory() or arg_11_0:isQuest(arg_11_2),
		enter_id = arg_11_0.logic.map.enter,
		is_moonlight_th = var_11_0,
		isBGMContinue = var_11_2,
		on_finish = function()
			TutorialGuide:onBattleStoryEnd(arg_11_2)
		end,
		callback_choice_list = function(arg_14_0)
			arg_11_0:addPlayList(arg_14_0)
		end
	})
	
	if var_11_3 then
		table.insert(arg_11_0.vars.played_story_list, arg_11_2)
		arg_11_0.logic:addPlayedStoryList(arg_11_2)
		
		local var_11_4 = arg_11_0.logic:getBattleUID()
		
		ConditionContentsManager:dispatch("battle.story", {
			unique_id = var_11_4,
			storyid = arg_11_2,
			ignore_condition = Battle:checkIgnoreCondition()
		})
		saveBattleInfo()
		Battle:onClickNextButton(false)
	end
	
	return var_11_3
end

function BattleStory.addPlayList(arg_15_0, arg_15_1)
	local var_15_0 = BattleStory:getPlayedList()
	
	if type(arg_15_1) == "table" then
		table.add(var_15_0, arg_15_1)
		arg_15_0.logic:setPlayedStoryList(var_15_0)
	else
		table.insert(var_15_0, arg_15_1)
		arg_15_0.logic:setPlayedStoryList(var_15_0)
	end
end

function BattleStory.isStoryMode(arg_16_0)
	if DEBUG.DEBUG_STORY_FREE then
		return false
	end
	
	return DEBUG.DEBUG_STORY or arg_16_0.logic:getQuestMissionId() or arg_16_0.story_data and arg_16_0.story_data.story_id or arg_16_0.logic:isTutorial() or nil
end

function BattleStory.getStoryData(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_1 then
		return 
	end
	
	arg_17_2 = arg_17_2 or arg_17_0:isForceStory() and arg_17_0.logic:isPreviewQuest() and "level_story" or arg_17_0:isStoryMode() and "level_story" or "level_story_free"
	
	local var_17_0
	local var_17_1
	local var_17_2 = {}
	
	for iter_17_0 = 1, 4 do
		table.insert(var_17_2, "mission" .. iter_17_0)
		table.insert(var_17_2, "mission_type" .. iter_17_0)
		table.insert(var_17_2, "story_before" .. iter_17_0)
		table.insert(var_17_2, "story_after" .. iter_17_0)
	end
	
	local var_17_3 = DBT(arg_17_2, arg_17_1, var_17_2) or {}
	
	for iter_17_1 = 1, 4 do
		local var_17_4 = var_17_3["mission" .. iter_17_1]
		local var_17_5 = false
		
		if var_17_4 then
			local var_17_6 = var_17_3["mission_type" .. iter_17_1] or CONTENTS_TYPE.BATTLE_MISSION
			local var_17_7 = string.split(var_17_6, ",")
			local var_17_8 = var_17_7[1]
			local var_17_9 = var_17_7[2]
			
			if var_17_8 == CONTENTS_TYPE.BATTLE_MISSION then
				var_17_5 = ConditionContentsManager:isMissionCleared(var_17_4, {
					inbattle = true
				})
			else
				local var_17_10 = ConditionContentsManager:getContents(var_17_8)
				
				if var_17_10 and var_17_10.isCleared and (var_17_9 == nil or var_17_9 == "clear") then
					var_17_5 = var_17_10:isCleared(var_17_4)
				elseif var_17_10 and var_17_10.isRewarded and var_17_9 == "complete" then
					var_17_5 = var_17_10:isRewarded(var_17_4)
				end
			end
		else
			var_17_5 = true
		end
		
		if DEBUG.DEBUG_STORY_FREE or var_17_5 then
			var_17_0 = var_17_3["story_before" .. iter_17_1]
			var_17_1 = var_17_3["story_after" .. iter_17_1]
			
			break
		end
	end
	
	return var_17_0, var_17_1
end

function BattleStory.setPlayedList(arg_18_0, arg_18_1)
	arg_18_0.vars.played_story_list = arg_18_1 or {}
end

function BattleStory.getPlayedList(arg_19_0)
	return arg_19_0.vars.played_story_list or {}
end
