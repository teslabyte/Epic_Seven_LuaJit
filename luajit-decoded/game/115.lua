function MsgHandler.get_substory_dlc_info(arg_1_0)
	if arg_1_0.substory_docs then
		Account:updateSubStoryInfo(arg_1_0.substory_docs)
		SubStoryDlc:nextScene()
	end
end

function MsgHandler.enter_substory_dlc(arg_2_0)
	SubstoryManager:setInfo(arg_2_0.substory_id)
	Account:setSubStoryAchievements(arg_2_0.substory_id, arg_2_0.achievements)
	Account:setSubStoryQuests(arg_2_0.substory_id, arg_2_0.quests)
	
	if arg_2_0.played_stories then
		Account:setSubStoryStories(arg_2_0.substory_id, arg_2_0.played_stories)
	end
	
	Account:setSubStory(arg_2_0.substory_id, arg_2_0.sub_info)
	
	if arg_2_0.story_choices_infos then
		Account:setSubStoryChoices(arg_2_0.story_choices_infos)
	end
	
	if arg_2_0.d_missions_attributes then
		Account:setSubStoryDungeonMissions(arg_2_0.substory_id, arg_2_0.d_missions_attributes)
	end
	
	if arg_2_0.substory__properties then
		Account:setSubStoryDungeonProperty(arg_2_0.substory_dungeon_properties)
	end
	
	if arg_2_0.substory_dungeon_base_infos then
		Account:setSubstoryDungeonBaseInfos(arg_2_0.substory_id, arg_2_0.substory_dungeon_base_infos)
	end
	
	if arg_2_0.substory_tutorials then
		Account:setSubStoryTutorials(arg_2_0.substory_id, arg_2_0.substory_tutorials)
	end
	
	SceneManager:nextScene("substory_dlc_lobby", {
		substory_id = arg_2_0.substory_id
	})
end

function MsgHandler.end_substory_dlc(arg_3_0)
	Account:setSubStory(arg_3_0.substory_info.substory_id, arg_3_0.substory_info)
	SubStoryDlcLobby:updateUI()
	
	local var_3_0 = {
		desc = T("ui_customdlc_end_desc")
	}
	
	Account:addReward(arg_3_0.rewards, {
		play_reward_data = var_3_0
	})
end

SubStoryDlc = SubStoryDlc or {}

function SubStoryDlc.enterQuery(arg_4_0, arg_4_1)
	if ContentDisable:byAlias("substory_dlc") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_4_0.move_item_id = (arg_4_1 or {}).move_item_id or nil
	
	query("get_substory_dlc_info")
end

function SubStoryDlc.nextScene(arg_5_0)
	local var_5_0 = arg_5_0.move_item_id
	
	arg_5_0.move_item_id = nil
	
	SceneManager:nextScene("substory_dlc_main", {
		move_item_id = var_5_0
	})
end

function SubStoryDlc.queryEnterSubstoryDlc(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0, var_6_1 = BackPlayUtil:checkSubstoryInBackPlay()
	
	if not var_6_0 then
		balloon_message_with_sound(var_6_1)
		
		return 
	end
	
	local var_6_2 = Account:isRequestSubStoryStories(arg_6_1)
	local var_6_3 = Account:isRequestSubStoryDungeonMissions(arg_6_1)
	local var_6_4 = Account:isRequestSubStoryTutorials(arg_6_1)
	
	query("enter_substory_dlc", {
		substory_id = arg_6_1,
		test = arg_6_2,
		is_request_story = var_6_2,
		is_req_d_missions = var_6_3,
		is_request_tutorial = var_6_4
	})
end

function SubStoryDlc.queryEndDlc(arg_7_0, arg_7_1)
	query("end_substory_dlc", {
		substory_id = arg_7_1
	})
end
