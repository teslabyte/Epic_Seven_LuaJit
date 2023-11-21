StoryMap = {}

function MsgHandler.storymap_clear(arg_1_0)
	local var_1_0
	local var_1_1 = ConditionContentsManager:updateResponseConditionList(arg_1_0, true)
	local var_1_2 = DB("level_enter", arg_1_0.map_id, "substory_contents_id")
	
	if arg_1_0.played_stories then
		if var_1_2 then
			Account:mergePlayedSubstoryStories(var_1_2, arg_1_0.played_stories)
		else
			Account:mergePlayedStories(arg_1_0.played_stories)
		end
	end
	
	if arg_1_0.doc_dungeon_base then
		Account:setDungeonBaseInfo(arg_1_0.map_id, arg_1_0.doc_dungeon_base)
	end
	
	local var_1_3 = SubstoryManager:getInfo()
	local var_1_4 = WorldMapManager:getController()
	
	if arg_1_0.rewards then
		Account:addReward(arg_1_0.rewards)
	end
	
	if var_1_3 and arg_1_0.choice_info then
		Account:setSubStoryChoice(arg_1_0.choice_info)
	end
	
	if arg_1_0.custom_item_rewards and arg_1_0.custom_item_rewards.new_items then
		Account:addReward(arg_1_0.custom_item_rewards)
	end
	
	SceneManager:popScene()
	
	local var_1_5 = {}
	
	if arg_1_0.conditions and arg_1_0.conditions.clear_conditions then
		for iter_1_0, iter_1_1 in pairs(arg_1_0.conditions.clear_conditions) do
			if iter_1_1.contents_type == CONTENTS_TYPE.SYS_ACHIEVEMENT then
				table.insert(var_1_5, iter_1_1.achieve_id)
			end
		end
	end
	
	if not table.empty(var_1_5) then
		local var_1_6 = UnlockSystem:getFirstUnhideSystem(UnlockSystem:getContinentUnlockSystems(var_1_5))
		
		if var_1_6 then
			local var_1_7, var_1_8 = DB("system_achievement_effect", var_1_6.sys_id, {
				"start_land_eff",
				"next_land_eff"
			})
			local var_1_9 = WorldMapManager:getController()
			
			if var_1_9 then
				var_1_9:moveWorldMap(nil, nil, nil, {
					unlock_before_id = var_1_7,
					unlock_id = var_1_8,
					sys_id = var_1_6.sys_id
				}, true)
			end
		end
	end
end

function MsgHandler.storymap_fail(arg_2_0)
	local var_2_0 = DB("level_enter", arg_2_0.map_id, "substory_contents_id")
	
	if arg_2_0.played_stories then
		if var_2_0 then
			Account:mergePlayedSubstoryStories(var_2_0, arg_2_0.played_stories)
		else
			Account:mergePlayedStories(arg_2_0.played_stories)
		end
	end
	
	if arg_2_0.doc_dungeon_base then
		Account:setDungeonBaseInfo(arg_2_0.map_id, arg_2_0.doc_dungeon_base)
	end
	
	local var_2_1 = SubstoryManager:getInfo()
	local var_2_2 = WorldMapManager:getController()
	
	if var_2_1 and arg_2_0.choice_info then
		Account:setSubStoryChoice(arg_2_0.choice_info)
	end
	
	SceneManager:popScene()
end

function StoryMap.updateAfterClearStortMap(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_1 then
		return 
	end
	
	local var_3_0 = WorldMapManager:getController()
	
	if not var_3_0 then
		return 
	end
	
	local var_3_1 = var_3_0:getBGM()
	
	SoundEngine:playBGM(var_3_1)
	
	local var_3_2 = var_3_0:getTown()
	local var_3_3
	local var_3_4
	
	if var_3_2 then
		print("StoryMapProcTown Enter!!")
		
		local var_3_5
		
		var_3_5, var_3_4 = var_3_2:procNewTownEffect()
	end
	
	local var_3_6 = SceneManager:getCurrentSceneName()
	
	if var_3_2 then
		var_3_2:update_townIcon_csb_forStory(arg_3_1)
		var_3_2:updateGuideMarker()
		var_3_2:updateNavigatorTarget()
		var_3_2:updateEventNavigator()
		var_3_2:updateEnterLine(arg_3_1)
		var_3_2:updateAchievementGauge()
		var_3_2:updateTags()
		var_3_2:updateLock(nil, arg_3_1)
		var_3_2:updateTagIcon(arg_3_1)
	end
	
	local var_3_7 = var_3_0:getNavi()
	
	if var_3_7 then
		var_3_7:updateQuest()
	end
	
	local var_3_8 = var_3_0:getWorldMapUI()
	
	if var_3_8 then
		var_3_8:UpdateAfterShowTown()
	end
	
	if (var_3_6 == "world_sub" or var_3_6 == "world_custom") and (Account:getMapClearCount(arg_3_1) or 0) == 1 and SceneManager:getCurrentSceneName() == "world_custom" then
		if not var_3_4 then
			local var_3_9
			
			var_3_9, var_3_4 = var_3_2:procNewTownEffect()
		end
		
		if var_3_4 and not table.empty(var_3_4) then
			for iter_3_0, iter_3_1 in pairs(var_3_4) do
				if not DB("level_enter", iter_3_1, {
					"hide_line"
				}) then
					var_3_2:updateMapLine(iter_3_1)
				end
			end
		end
	end
	
	local var_3_10 = WorldMapManager:getController()
	
	if var_3_10 then
		var_3_10:refreshAllLocalIcons()
	end
end

function StoryMap.playStory(arg_4_0, arg_4_1)
	local var_4_0 = StoryMapUtil:getPlayStoryData(arg_4_1).story_id
	
	arg_4_0.vars = {}
	arg_4_0.vars.enter_id = arg_4_1
	arg_4_0.vars.story_id = var_4_0
	arg_4_0.vars.played_list = {}
	arg_4_0.vars.return_vars = {}
	arg_4_0.vars.choice_id_list = {}
	
	arg_4_0.addPlayList(var_4_0, arg_4_1)
	
	local var_4_1 = cc.Layer:create()
	
	arg_4_0.vars.layer = var_4_1
	
	local var_4_2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_4_2:setPositionX(VIEW_BASE_LEFT)
	var_4_1:addChild(var_4_2)
	SceneManager:getRunningPopupScene():addChild(var_4_1)
	
	local var_4_3 = Account:getSubStoryChoiceID(arg_4_1)
	local var_4_4 = WorldMapManager:getWorldMapUI()
	
	if var_4_4 then
		var_4_4:hideNPC()
	end
	
	play_story(var_4_0, {
		force = true,
		callback_choice_list = arg_4_0.addPlayList,
		on_finish = function()
			StoryMap:onLeave()
		end,
		choice_id = var_4_3,
		return_vars = arg_4_0.vars.return_vars,
		enter_id = arg_4_0.vars.enter_id
	})
end

function StoryMap.removeWnd(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.layer) then
		return 
	end
	
	arg_6_0.vars.layer:removeFromParent()
end

function StoryMap.isShow(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.layer) then
		return 
	end
	
	return true
end

function StoryMap.getEnterID(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	return arg_8_0.vars.enter_id
end

function StoryMap.addChoiceId(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return 
	end
	
	table.insert(arg_9_0.vars.choice_id_list, arg_9_1)
end

function StoryMap.onLeave(arg_10_0)
	if is_failed_story() then
		local var_10_0 = arg_10_0.vars.return_vars.choice_id
		local var_10_1
		
		if SubstoryManager:getInfo() then
			var_10_1 = SubstoryManager:getInfo().id
		end
		
		if arg_10_0.vars.choice_id_list and not table.empty(arg_10_0.vars.choice_id_list) then
			query("storymap_fail", {
				map_id = arg_10_0.vars.enter_id,
				played_stories = array_to_json(arg_10_0.vars.choice_id_list),
				substory_id = var_10_1,
				choice_id = var_10_0
			})
		end
		
		return 
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("storymap.clear", {
		enter_id = arg_10_0.vars.enter_id,
		unique_id = arg_10_0.vars.enter_id
	})
	
	local var_10_2
	
	if SubstoryManager:getInfo() then
		var_10_2 = SubstoryManager:getInfo().id
	end
	
	local var_10_3 = arg_10_0.vars.return_vars.choice_id
	local var_10_4 = STORY.return_vars.reward_choice_id
	
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_10_5 = ConditionContentsManager:getUpdateConditions() and json.encode()
	local var_10_6
	
	if STORY.choice_id == nil and var_10_4 then
		var_10_6 = {}
		
		for iter_10_0, iter_10_1 in pairs(var_10_4) do
			if DB("story_choice", iter_10_1, {
				"choice_reward"
			}) then
				table.insert(var_10_6, iter_10_1)
			end
		end
		
		if not table.empty(var_10_6) then
			var_10_6 = array_to_json(var_10_6)
		else
			var_10_6 = nil
		end
	end
	
	local var_10_7
	
	if SAVE:updateConfigDataByTemp() > 0 then
		var_10_7 = SAVE:getJsonConfigData()
	end
	
	query("storymap_clear", {
		map_id = arg_10_0.vars.enter_id,
		played_stories = array_to_json(StoryMap:getPlayList()),
		substory_id = var_10_2,
		choice_id = var_10_3,
		reward_choice_ids = var_10_6,
		update_conditions = var_10_5,
		config_datas = var_10_7
	})
end

function StoryMap.getPlayList(arg_11_0)
	if not arg_11_0.vars.played_list then
		arg_11_0.vars.played_list = {}
	end
	
	return arg_11_0.vars.played_list
end

function StoryMap.addPlayList(arg_12_0, arg_12_1)
	if not arg_12_1 then
		Log.e("StoryMap.addPlayList", "empty_enter_id")
		
		return 
	end
	
	local var_12_0 = StoryMap:getPlayList()
	
	if type(arg_12_0) == "table" then
		table.add(var_12_0, arg_12_0)
		
		for iter_12_0, iter_12_1 in pairs(arg_12_0) do
			ConditionContentsManager:dispatch("storymap.story", {
				storyid = iter_12_1,
				unique_id = arg_12_1
			})
		end
	else
		table.insert(var_12_0, arg_12_0)
		ConditionContentsManager:dispatch("storymap.story", {
			storyid = arg_12_0,
			unique_id = arg_12_1
		})
	end
end

StoryMapUtil = StoryMapUtil or {}

function StoryMapUtil.getPlayStoryData(arg_13_0, arg_13_1)
	local var_13_0 = {}
	
	for iter_13_0 = 1, 999 do
		local var_13_1 = DBT("substory_story_change", string.format("%s_%d", arg_13_1, iter_13_0), {
			"id",
			"story_title",
			"story_desc",
			"story_stage_link",
			"enter_portrait",
			"cond_mission",
			"cond_clear_type"
		})
		
		if not var_13_1.id then
			break
		end
		
		if var_13_1.story_title and var_13_1.story_desc and var_13_1.story_stage_link and var_13_1.enter_portrait then
			local var_13_2 = false
			
			if var_13_1.cond_mission and var_13_1.cond_clear_type then
				local var_13_3 = totable(var_13_1.cond_mission)
				
				for iter_13_1, iter_13_2 in pairs(var_13_3) do
					local var_13_4 = iter_13_2
					
					if type(var_13_4) == "string" then
						var_13_4 = {
							var_13_4
						}
					end
					
					for iter_13_3, iter_13_4 in pairs(var_13_4) do
						local var_13_5 = ConditionContentsManager:getContents(iter_13_1)
						
						if var_13_5 and var_13_5.isRewarded and type(var_13_5.isRewarded) == "function" and var_13_5:isRewarded(iter_13_4) then
							var_13_2 = true
							
							break
						end
						
						if var_13_2 == false then
							break
						end
					end
					
					if var_13_2 == false then
						break
					end
				end
			else
				var_13_2 = true
			end
			
			if var_13_2 == true then
				var_13_0.title = var_13_1.story_title
				var_13_0.desc = var_13_1.story_desc
				var_13_0.story_id = var_13_1.story_stage_link
				var_13_0.enter_portrait = var_13_1.enter_portrait
				
				if not Account:isPlayedStory(var_13_1.story_stage_link) then
					break
				end
			else
				break
			end
		end
	end
	
	if var_13_0.story_id then
		return var_13_0
	end
	
	local var_13_6, var_13_7, var_13_8, var_13_9 = DB("level_enter", arg_13_1, {
		"story_title",
		"story_desc",
		"story_stage_link",
		"enter_portrait"
	})
	
	var_13_0.title = var_13_6
	var_13_0.desc = var_13_7
	var_13_0.story_id = var_13_8
	var_13_0.enter_portrait = var_13_9
	
	return var_13_0
end
