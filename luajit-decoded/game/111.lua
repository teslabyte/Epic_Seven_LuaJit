SubstoryManager = SubstoryManager or {}
SUBSTORY_CONTENTS_TYPE = {}
SUBSTORY_CONTENTS_TYPE.SUBSTORY_WORLD = "substory_world_sub"
SUBSTORY_CONTENTS_TYPE.CUSTOM_WORLD = "substory_world_custom"
SUBSTORY_CONTENTS_TYPE.TOURNAMENT = "content_tournament"
SUBSTORY_CONTENTS_TYPE.PIECE_BOARD = "content_piece"
SUBSTORY_CONTENTS_TYPE.CHALLENGE = "content_challenge"
SUBSTORY_CONTENTS_TYPE.DESCENT = "substory_descent"
SUBSTORY_CONTENTS_TYPE.BURNING = "substory_burning"
SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM = "substory_festival_fm"
SUBSTORY_CONTENTS_TYPE.TRAVEL = "content_travel"
SUBSTORY_CONTENTS_TYPE.VILLAGE = "content_village"
SUBSTORY_CONTENTS_TYPE.INFERENCE = "content_inference"
SUBSTORY_CONTENTS_TYPE.CONTROL_BOARD = "content_board"
SUBSTORY_CONTENTS_TYPE.TILE_SPL = "substory_tile"
SUBSTORY_INFO_VALID_SCENE = {}
SUBSTORY_INFO_VALID_SCENE.SUBSTORY_LOBBY = "substory_lobby"
SUBSTORY_INFO_VALID_SCENE.SUBSTORY_WORLD = "world_sub"
SUBSTORY_INFO_VALID_SCENE.CUSTOM_WORLD = "world_custom"
SUBSTORY_INFO_VALID_SCENE.BATTLE = "battle"
SUBSTORY_INFO_VALID_SCENE.STORYMAP = "storymap"
SUBSTORY_INFO_VALID_SCENE.TOURNAMENT = "tournament"
SUBSTORY_INFO_VALID_SCENE.SUBSTORY_DLC_LOBBY = "substory_dlc_lobby"
SUBSTORY_INFO_VALID_SCENE.VOLLEY_BALL = "mini_volley_ball"
SUBSTORY_INFO_VALID_SCENE.COOK = "mini_cook"
SUBSTORY_INFO_VALID_SCENE.REPAIR = "mini_repair"
SUBSTORY_INFO_VALID_SCENE.ARCADE = "mini_defence"
SUBSTORY_INFO_VALID_SCENE.CINEMA = "cinema"
SUBSTORY_INFO_VALID_SCENE.EXORCIST = "mini_exorcist"
SUBSTORY_INFO_VALID_SCENE.MOONLIGHT_DESTINY = "moonlight_destiny"
SUBSTORY_INFO_VALID_SCENE.SUBSTORY_SPL = "spl"
SUBSTORY_INFO_VALID_SCENE.SUBSTORY_RUMBLE = "rumble"
SUBSTORY_HOME_BACK_LOBBY_SCENE = {}
SUBSTORY_HOME_BACK_LOBBY_SCENE.SUBSTORY_LOBBY = "substory_lobby"
SUBSTORY_HOME_BACK_LOBBY_SCENE.SUBSTORY_DLC_LOBBY = "substory_dlc_lobby"
SUBSTORY_HOME_BACK_LOBBY_SCENE.SUBSTORY_DLC_MAIN = "substory_dlc_main"
SUBSTORY_HOME_BACK_LOBBY_SCENE.SUBSTORY_ALBUM = "substory_album"
SUBSTORY_HOME_BACK_LOBBY_SCENE.SUBSTORY_COLLECTION = "collection"
SUBSTORY_HOME_BACK_LOBBY_SCENE.SUBSTORY_THEATER = "moonlight_theater"
SUBSTORY_LOBBY_SCENE = {}
SUBSTORY_LOBBY_SCENE.DEFAULT = "substory_lobby"
SUBSTORY_LOBBY_SCENE.DLC = "substory_dlc_lobby"
SUBSTORY_CONSTANTS = {}
SUBSTORY_CONSTANTS.ONE_WEEK = 604800
SUBSTORY_CONSTANTS.STATE_OPEN = "open"
SUBSTORY_CONSTANTS.STATE_CLOSE_SOON = "close_soon"
SUBSTORY_CONSTANTS.STATE_CLOSE = "close"
SUBSTORY_CONSTANTS.STATE_READY = "ready"

local var_0_0 = 2

function MsgHandler.enter_sub_story(arg_1_0)
	if arg_1_0.s_event_state == "ready" then
	else
		Account:setSubStoryAchievements(arg_1_0.substory_id, arg_1_0.achievements)
		Account:setSubStoryQuests(arg_1_0.substory_id, arg_1_0.quests)
		Account:setSubStory(arg_1_0.substory_id, arg_1_0.substory)
		
		if arg_1_0.updated_limits then
			Account:updateLimits(arg_1_0.updated_limits)
		end
		
		if arg_1_0.substory_pass_data then
			Account:setSubstoryPassData(arg_1_0.substory_pass_data)
		end
		
		if arg_1_0.substory_pass_info then
			Account:setSubstoryPassInfo(arg_1_0.substory_pass_info)
		end
		
		SeasonPass:initSubstoryData(arg_1_0.substory_pass_reward_infos)
		
		if arg_1_0.tournament_docs then
			Tournament:setTournametInfos(arg_1_0.tournament_docs)
		end
		
		if arg_1_0.npc_list then
			Tournament:setNpcList(arg_1_0.npc_list)
		end
		
		if arg_1_0.played_stories then
			Account:setSubStoryStories(arg_1_0.substory_id, arg_1_0.played_stories)
		end
		
		if arg_1_0.story_choices_infos then
			Account:setSubStoryChoices(arg_1_0.story_choices_infos)
		end
		
		if arg_1_0.substory_piece_infos then
			Account:setSubStoryPieceBoardInfos(arg_1_0.substory_id, arg_1_0.substory_piece_infos)
		end
		
		if arg_1_0.d_missions_attributes then
			Account:setSubStoryDungeonMissions(arg_1_0.substory_id, arg_1_0.d_missions_attributes)
		end
		
		if arg_1_0.substory_dungeon_properties then
			Account:setSubStoryDungeonProperty(arg_1_0.substory_dungeon_properties)
		end
		
		if arg_1_0.substory_tutorials then
			Account:setSubStoryTutorials(arg_1_0.substory_id, arg_1_0.substory_tutorials)
		end
		
		if arg_1_0.substory_dungeon_base_infos then
			Account:setSubstoryDungeonBaseInfos(arg_1_0.substory_id, arg_1_0.substory_dungeon_base_infos)
		end
		
		if arg_1_0.teams then
			Account:setTeams(arg_1_0.teams)
		end
		
		if arg_1_0.festival_info then
			Account:setSubStoryFestivals(arg_1_0.substory_id, arg_1_0.festival_info)
		end
		
		SPLUserData:setData(arg_1_0.spl_data)
		Account:setSubStoryTravelMissions(arg_1_0.substory_travel_missions)
		Account:setSubStoryControlBoard(arg_1_0.substory_travel_control_board)
		Account:setSubStoryRumble(arg_1_0.substory_rumble)
		Account:setSubStoryCustomMissions(arg_1_0.substory_custom_missions)
		Account:setSubStoryBurning(arg_1_0.substory_burning_infos)
		SubstoryManager:setShopItemList(arg_1_0.shop_item_list)
	end
	
	SubstoryManager:after_enter_call()
	SceneManager:nextScene("substory_lobby", {
		substory_id = arg_1_0.substory_id,
		pathParams = arg_1_0.pathParams,
		s_event_state = arg_1_0.s_event_state
	})
end

function HANDLER.dungeon_story_reward_popup(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		Dialog:close("dungeon_story_reward_popup")
	end
end

function HANDLER.story_dlc_reward_popup(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("story_dlc_reward_popup")
	end
end

function SubstoryManager.initVilliageCraftManager(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	local var_4_0 = arg_4_0:getInfo() or {}
	
	if not var_4_0.contents_type_2 or var_4_0.contents_type_2 ~= "content_village" then
		return 
	end
	
	ChristmasCraftManager:init()
end

function SubstoryManager.add_after_enter_call(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_2 then
		return 
	end
	
	if not arg_5_0.after_enter_list then
		arg_5_0.after_enter_list = {}
	end
	
	table.insert(arg_5_0.after_enter_list, {
		name = arg_5_1,
		func = arg_5_2
	})
end

function SubstoryManager.after_enter_call(arg_6_0)
	if not arg_6_0.after_enter_list then
		arg_6_0.after_enter_list = {}
	end
	
	if table.empty(arg_6_0.after_enter_list) then
		return 
	end
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.after_enter_list) do
		if iter_6_1.func then
			print("call func after enter substory enter: ", iter_6_1.name)
			iter_6_1.func()
		end
	end
	
	arg_6_0.after_enter_list = {}
end

function SubstoryManager.setInfo(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		arg_7_0.vars = {}
	end
	
	if type(arg_7_1) == "string" then
		local var_7_0 = arg_7_0:makeInfo(arg_7_1)
		
		arg_7_0.vars.info = var_7_0
	else
		arg_7_0.vars.info = arg_7_1
	end
end

function SubstoryManager.makeInfo(arg_8_0, arg_8_1)
	local var_8_0 = SubStoryUtil:getSubstoryDB(arg_8_1)
	
	if var_8_0 and var_8_0.id then
		var_8_0.id = tostring(var_8_0.id)
	end
	
	local var_8_1 = Account:getSubStoryScheduleDBById(arg_8_1)
	
	if var_8_1 then
		if var_8_1.start_time then
			var_8_0.start_time = var_8_1.start_time
		end
		
		if var_8_1.end_time then
			var_8_0.end_time = var_8_1.end_time
		end
	end
	
	return var_8_0
end

function SubstoryManager.getSubStoryQuestData(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1 or (arg_9_0:getInfo() or {}).id
	
	if not var_9_0 then
		return 
	end
	
	local var_9_1 = Account:getSubStoryQuest(arg_9_2) or {}
	local var_9_2 = {}
	
	var_9_2.id, var_9_2.condition, var_9_2.condition_value, var_9_2.name, var_9_2.desc, var_9_2.desc2, var_9_2.icon, var_9_2.area_enter_id, var_9_2.reward_id1, var_9_2.reward_count1, var_9_2.grade_rate1, var_9_2.set_drop_rate_id1, var_9_2.btn_move, var_9_2.sort = DB("substory_quest", arg_9_2, {
		"id",
		"condition",
		"value",
		"name",
		"desc",
		"desc2",
		"icon",
		"area_enter_id",
		"reward_id1",
		"reward_count1",
		"grade_rate1",
		"set_drop_rate_id1",
		"btn_move",
		"sort"
	})
	
	local var_9_3 = var_9_0 .. "_" .. "quest_" .. string.format("%02d", 1)
	
	if not var_9_1.state and var_9_3 == arg_9_2 then
		var_9_1.state = SUBSTORY_QUEST_STATE.ACTIVE
	end
	
	if var_9_2.id then
		var_9_2.state = var_9_1.state
		
		return var_9_2
	end
end

function SubstoryManager.nextContent(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or {}
	arg_10_2.sub_story = SubstoryManager:getInfo()
	
	if arg_10_1 == SUBSTORY_CONTENTS_TYPE.SUBSTORY_WORLD then
		SceneManager:nextScene("world_sub", arg_10_2)
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.CUSTOM_WORLD then
		SceneManager:nextScene("world_custom", arg_10_2)
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.TOURNAMENT then
		SceneManager:nextScene("tournament")
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.PIECE_BOARD then
		SubstoryPieceBoardList:show()
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.TRAVEL then
		SubStoryTravelMap_v2:show()
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.VILLAGE then
		SubStoryChristmasVillage:show()
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.CONTROL_BOARD then
		if not SubStoryControlBoardUtil:canEnterableContents(arg_10_2.sub_story.id, true) then
			return 
		end
		
		SubStoryControlBoard:show()
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.INFERENCE then
		local var_10_0 = SubstoryManager:getContents2CommonDB()
		
		if var_10_0 and var_10_0.rumble_show_btn == "y" then
			local var_10_1 = var_10_0.unlock_clear_stage
			
			if Account:isMapCleared(var_10_1) or DEBUG.MAP_DEBUG then
				SubstoryRumble:show()
			else
				balloon_message_with_sound("rumble_open_condition")
			end
		end
	elseif arg_10_1 == SUBSTORY_CONTENTS_TYPE.TILE_SPL then
		SceneManager:nextScene("spl")
	end
end

function SubstoryManager.nextContent_type1(arg_11_0, arg_11_1)
	local var_11_0 = SubstoryManager:getInfo()
	
	arg_11_0:nextContent(var_11_0.contents_type, arg_11_1)
end

function SubstoryManager.nextContent_type2(arg_12_0, arg_12_1)
	local var_12_0 = SubstoryManager:getInfo()
	
	if var_12_0.content2_schedule then
		local var_12_1, var_12_2 = arg_12_0:getRemainEnterTime(var_12_0.content2_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
		
		if var_12_1 > 0 then
			balloon_message_with_sound("err_msg_tournament_time", {
				time = sec_to_full_string(var_12_1)
			})
			
			return 
		elseif var_12_2 then
			balloon_message_with_sound("err_schedule_end")
			
			return 
		end
	end
	
	local var_12_3 = SubstoryManager:getContents2CommonDB()
	
	if var_12_3 and var_12_3.unlock_enter_btn_condition and not Account:isClearedSubStoryAchievement(var_12_3.unlock_enter_btn_condition) then
		local var_12_4 = DB("substory_achievement", var_12_3.unlock_enter_btn_condition, {
			"name"
		})
		
		if var_12_4 then
			balloon_message_with_sound_raw_text(T("travel_enter_err", {
				achievement_name = T(var_12_4)
			}))
		end
		
		return 
	end
	
	arg_12_0:nextContent(var_12_0.contents_type_2, arg_12_1)
end

function SubstoryManager.getWorldMapContentsDB(arg_13_0)
	local var_13_0 = {
		"world_depth",
		"world_id",
		"star_mission_hide",
		"chapter_shop",
		"hide_hero_info",
		"worldmap_button_hide"
	}
	local var_13_1 = {}
	local var_13_2 = arg_13_0:findContentsTypeColumn("substory_world")
	
	if var_13_2 then
		var_13_1 = arg_13_0:getContentsDB(var_13_2, var_13_0)
	end
	
	return var_13_1
end

function SubstoryManager.findContentsTypeColumn(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0
	
	if arg_14_2 then
		var_14_0 = SubStoryUtil:getSubstoryDB(arg_14_2)
	else
		var_14_0 = SubstoryManager:getInfo()
	end
	
	if not var_14_0 then
		return nil
	end
	
	for iter_14_0 = 1, var_0_0 do
		local var_14_1 = "contents_type"
		
		if iter_14_0 ~= 1 then
			var_14_1 = "contents_type_" .. tostring(iter_14_0)
		end
		
		if var_14_0[var_14_1] and string.starts(var_14_0[var_14_1], arg_14_1) then
			return var_14_1
		end
	end
	
	return nil
end

function SubstoryManager.playPrologue(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = SceneManager:getDefaultLayer()
	local var_15_1 = arg_15_1 or SubstoryManager:getInfo()
	
	if var_15_1.prologue_story then
		start_new_story(var_15_0, var_15_1.prologue_story, {
			force = true,
			on_finish = arg_15_2,
			isBGMContinue = arg_15_3
		})
	end
end

function SubstoryManager.findContentsScheduleID(arg_16_0, arg_16_1)
	local var_16_0 = SubstoryManager:getInfo()
	
	for iter_16_0 = 1, var_0_0 do
		local var_16_1 = "contents_type"
		local var_16_2 = "content_schedule"
		
		if iter_16_0 ~= 1 then
			var_16_1 = "contents_type_" .. tostring(iter_16_0)
			var_16_2 = "content" .. tostring(iter_16_0) .. "_schedule"
		end
		
		if var_16_0[var_16_1] and string.starts(var_16_0[var_16_1], arg_16_1) then
			return var_16_0[var_16_2]
		end
	end
	
	return nil
end

function SubstoryManager.getContentsDB(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = SubstoryManager:getInfo()
	local var_17_1 = {}
	
	if var_17_0[arg_17_1] then
		var_17_1 = DBT(var_17_0[arg_17_1], var_17_0.id, arg_17_2)
	end
	
	return var_17_1 or {}
end

function SubstoryManager.getContents2CommonDB(arg_18_0, arg_18_1)
	arg_18_1 = arg_18_1 or {
		"enter_btn_icon",
		"enter_btn_text",
		"enter_btn_hide_lobby",
		"unlock_enter_btn_condition",
		"rumble_show_btn",
		"unlock_clear_stage"
	}
	
	return arg_18_0:getContentsDB("contents_type_2", arg_18_1) or {}
end

function SubstoryManager.isRejectBackButtonNextFlowScene(arg_19_0, arg_19_1)
	local var_19_0 = {
		"substory_dlc_main"
	}
	
	for iter_19_0, iter_19_1 in pairs(SUBSTORY_INFO_VALID_SCENE) do
		if not table.isInclude(var_19_0, arg_19_1) and iter_19_1 == arg_19_1 then
			return true
		end
	end
	
	return false
end

function SubstoryManager.isSubstoryLobbyScene(arg_20_0, arg_20_1)
	for iter_20_0, iter_20_1 in pairs(SUBSTORY_LOBBY_SCENE) do
		if iter_20_1 == arg_20_1 then
			return true
		end
	end
	
	return false
end

function SubstoryManager.isClearedSubStoryQuest(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0 = Account:getSubStoryQuest(arg_21_1) or {}
	
	return var_21_0.state and tonumber(var_21_0.state) >= SUBSTORY_QUEST_STATE.CLEAR
end

function SubstoryManager.getSubStoryQuestDatas(arg_22_0)
	local var_22_0 = {}
	local var_22_1
	local var_22_2 = arg_22_0:getInfo().id
	
	for iter_22_0 = 1, 99 do
		local var_22_3 = var_22_2 .. "_" .. "quest_" .. string.format("%02d", iter_22_0)
		local var_22_4 = SubstoryManager:getSubStoryQuestData(var_22_2, var_22_3)
		
		if not var_22_4 then
			break
		end
		
		if not var_22_1 and (not var_22_4.state or var_22_4.state == SUBSTORY_QUEST_STATE.ACTIVE) then
			var_22_4.state = SUBSTORY_QUEST_STATE.ACTIVE
			var_22_1 = var_22_4
		end
		
		if var_22_4.condition and var_22_4.condition_value then
			table.insert(var_22_0, var_22_4)
		end
	end
	
	return var_22_0
end

function SubstoryManager.getCurrentQuestData(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_1 or (arg_23_0:getInfo() or {}).id
	
	for iter_23_0 = 1, 99 do
		local var_23_1 = var_23_0 .. "_" .. "quest_" .. string.format("%02d", iter_23_0)
		local var_23_2 = SubstoryManager:getSubStoryQuestData(arg_23_1, var_23_1)
		
		if not var_23_2 then
			break
		end
		
		if var_23_2.state == SUBSTORY_QUEST_STATE.ACTIVE then
			return var_23_2
		end
	end
end

function SubstoryManager.isActiveQuest(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return 
	end
	
	local var_24_0 = arg_24_0:getCurrentQuestData()
	local var_24_1 = var_24_0 and var_24_0.id
	
	if not var_24_1 then
		return 
	end
	
	return arg_24_1 == var_24_1
end

function SubstoryManager.getClearQuestCount(arg_25_0)
	local var_25_0 = 0
	local var_25_1 = (arg_25_0:getInfo() or {}).id
	local var_25_2 = Account:getSubStoryQuestBySubstoryID(var_25_1)
	
	for iter_25_0, iter_25_1 in pairs(var_25_2 or {}) do
		if iter_25_1.substory_id == var_25_1 and iter_25_1.state and tonumber(iter_25_1.state) >= SUBSTORY_QUEST_STATE.CLEAR then
			var_25_0 = var_25_0 + 1
		end
	end
	
	return var_25_0
end

function SubstoryManager.isActiveAchieve(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	return ((Account:getSubStoryAchievement(arg_26_1) or {}).state or SUBSTORY_ACHIEVE.ACTIVE) == SUBSTORY_ACHIEVE_STATE.ACTIVE
end

function SubstoryManager.getClearQuestNotiCount(arg_27_0)
	local var_27_0 = 0
	local var_27_1 = (arg_27_0:getInfo() or {}).id
	local var_27_2 = Account:getSubStoryQuestBySubstoryID(var_27_1)
	
	for iter_27_0, iter_27_1 in pairs(var_27_2 or {}) do
		if iter_27_1.state and tonumber(iter_27_1.state) == SUBSTORY_QUEST_STATE.CLEAR then
			var_27_0 = var_27_0 + 1
		end
	end
	
	return var_27_0
end

function SubstoryManager.isApplyQuestInBattle(arg_28_0, arg_28_1)
	local var_28_0 = DB("substory_quest", arg_28_1, {
		"state_id"
	})
	
	if var_28_0 then
		return ConditionContentsState:getClearData(var_28_0).is_cleared
	end
	
	return true
end

function SubstoryManager.getQuestCount(arg_29_0)
	return #(arg_29_0:getSubStoryQuestDatas() or {})
end

function SubstoryManager.getNotIncludeHideAchieveDatas(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or {}
	
	local var_30_0 = arg_30_0:getSubStoryAchieveDatas(arg_30_0:getInfo().id, arg_30_1) or {}
	local var_30_1 = 0
	
	for iter_30_0, iter_30_1 in pairs(var_30_0 or {}) do
		if Account:isClearedSubStoryAchievement(iter_30_1.id) then
			var_30_1 = var_30_1 + 1
		end
	end
	
	return #var_30_0, var_30_1
end

function SubstoryManager.isAllReceivedQuestReward(arg_31_0)
	local var_31_0 = (arg_31_0:getInfo() or {}).id
	local var_31_1 = Account:getSubStoryQuestBySubstoryID(var_31_0)
	
	for iter_31_0, iter_31_1 in pairs(var_31_1 or {}) do
		if iter_31_1.state and tonumber(iter_31_1.state) <= SUBSTORY_QUEST_STATE.CLEAR then
			return false
		end
	end
	
	return true
end

function SubstoryManager.isActiveQuestInWorld(arg_32_0, arg_32_1)
	local var_32_0 = false
	
	for iter_32_0 = 1, 99 do
		local var_32_1 = arg_32_1 .. string.format("%03d", iter_32_0)
		local var_32_2, var_32_3, var_32_4 = DB("level_world_2_continent", var_32_1, {
			"id",
			"key_normal",
			"key_world"
		})
		
		if not var_32_2 then
			break
		end
		
		if var_32_3 and var_32_4 and arg_32_0:isActiveQuestInChapter(var_32_3) or arg_32_0:isActiveQuestInChapter(var_32_4) then
			var_32_0 = true
			
			return var_32_0
		end
	end
	
	return var_32_0
end

function SubstoryManager.isActiveQuestInChapter(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0:getCurrentQuestData()
	
	if not var_33_0 then
		return false
	end
	
	local var_33_1 = DB("substory_quest", var_33_0.id, {
		"area_enter_id"
	})
	
	if not arg_33_1 or not var_33_1 then
		return nil
	end
	
	if var_33_1 and string.starts(var_33_1, arg_33_1) then
		return true
	end
	
	return nil
end

function SubstoryManager.setQuests(arg_34_0)
end

function SubstoryManager.setAchievements(arg_35_0)
end

function SubstoryManager.isValidScene(arg_36_0, arg_36_1)
	local var_36_0 = false
	
	for iter_36_0, iter_36_1 in pairs(SUBSTORY_INFO_VALID_SCENE) do
		if arg_36_1 == iter_36_1 then
			var_36_0 = true
			
			break
		end
	end
	
	return var_36_0
end

function SubstoryManager.getInfo(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	if arg_37_0:isValidScene(SceneManager:getCurrentSceneName()) == false then
		SubstoryManager:clearInfo()
		ConditionContentsManager:clearSubStoryContents()
	end
	
	if not arg_37_0.vars then
		return 
	end
	
	return arg_37_0.vars.info
end

function SubstoryManager.getInfoID(arg_38_0)
	return (arg_38_0:getInfo() or {}).id
end

function SubstoryManager.initLobbyCond(arg_39_0)
	ConditionContentsManager:initSubStory()
	ConditionContentsManager:substoryEnterForceUpdateConditions()
end

function SubstoryManager.getAchievements(arg_40_0)
	return ConditionContentsManager:getSubStoryAchievement()
end

function SubstoryManager.getEventTimeInfo(arg_41_0)
	local var_41_0 = SubstoryManager:getInfo()
	
	if not var_41_0 then
		return 
	end
	
	return SubStoryUtil:getEventTimeInfo(var_41_0)
end

function SubstoryManager.getSubStoryAchieveDatas(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = {}
	local var_42_1 = arg_42_2 or {}
	
	for iter_42_0 = 1, 999 do
		local var_42_2 = {}
		local var_42_3 = arg_42_1 .. "_" .. "ach_" .. string.format("%02d", iter_42_0)
		
		var_42_2.id, var_42_2.condition, var_42_2.value, var_42_2.name, var_42_2.desc, var_42_2.icon, var_42_2.reward_id1, var_42_2.reward_count1, var_42_2.grade_rate1, var_42_2.set_drop_rate_id1, var_42_2.btn_move, var_42_2.sort, var_42_2.hide, var_42_2.unlock_state_id = DB("substory_achievement", var_42_3, {
			"id",
			"condition",
			"value",
			"name",
			"desc",
			"icon",
			"reward_id1",
			"reward_count1",
			"grade_rate1",
			"set_drop_rate_id1",
			"btn_move",
			"sort",
			"hide",
			"unlock_state_id"
		})
		
		if not var_42_2.id then
			break
		end
		
		var_42_2.state = (Account:getSubStoryAchievement(var_42_3) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE
		
		if var_42_1.check_unlock then
			if var_42_2.unlock_state_id == nil or ConditionContentsState:isClearedByStateID(var_42_2.unlock_state_id) then
				table.insert(var_42_0, var_42_2)
			end
		elseif var_42_1.hide_not_include then
			if not var_42_2.hide then
				table.insert(var_42_0, var_42_2)
			end
		else
			table.insert(var_42_0, var_42_2)
		end
	end
	
	return var_42_0
end

function SubstoryManager.getSubStoryAchieveData(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_2 or {}
	local var_43_1 = {}
	local var_43_2 = arg_43_1
	
	var_43_1.id, var_43_1.condition, var_43_1.value, var_43_1.name, var_43_1.desc, var_43_1.icon, var_43_1.reward_id1, var_43_1.reward_count1, var_43_1.grade_rate1, var_43_1.set_drop_rate_id1, var_43_1.btn_move, var_43_1.sort, var_43_1.hide, var_43_1.unlock_state_id = DB("substory_achievement", var_43_2, {
		"id",
		"condition",
		"value",
		"name",
		"desc",
		"icon",
		"reward_id1",
		"reward_count1",
		"grade_rate1",
		"set_drop_rate_id1",
		"btn_move",
		"sort",
		"hide",
		"unlock_state_id"
	})
	
	if not var_43_1.id then
		return {}
	end
	
	var_43_1.state = (Account:getSubStoryAchievement(var_43_2) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE
	
	if var_43_0.check_unlock then
		if var_43_1.unlock_state_id == nil or ConditionContentsState:isClearedByStateID(var_43_1.unlock_state_id) then
			return var_43_1
		end
	elseif var_43_0.hide_not_include then
		if not var_43_1.hide then
			return var_43_1
		end
	else
		return var_43_1
	end
	
	return {}
end

function SubstoryManager.clearInfo(arg_44_0)
	arg_44_0.vars = nil
end

function SubstoryManager.isWorldMapTypeContents(arg_45_0)
	if arg_45_0:isContentsType(SUBSTORY_CONTENTS_TYPE.SUBSTORY_WORLD) then
		return true
	end
	
	if arg_45_0:isContentsType(SUBSTORY_CONTENTS_TYPE.CUSTOM_WORLD) then
		return true
	end
end

function SubstoryManager.isContentsType(arg_46_0, arg_46_1)
	return SubStoryUtil:isContentsType(arg_46_0.vars.info, arg_46_1)
end

function SubstoryManager.getContentsController(arg_47_0)
	if arg_47_0.vars.info.contents_type == SUBSTORY_CONTENTS_TYPE.SUBSTORY_WORLD then
		return SubWorldMapController
	elseif arg_47_0.vars.info.contents_type == SUBSTORY_CONTENTS_TYPE.CUSTOM_WORLD then
		return CustomWorldMapController
	end
	
	return SubWorldMapController
end

function SubstoryManager.updateNotifierContentsUI(arg_48_0)
	if arg_48_0.vars.info.contents_type == SUBSTORY_CONTENTS_TYPE.SUBSTORY_WORLD then
		SubWorldMapUI:updateNotifier()
	elseif arg_48_0.vars.info.contents_type == SUBSTORY_CONTENTS_TYPE.CUSTOM_WORLD then
		CustomWorldMapUI:updateNotifier()
	end
end

function SubstoryManager.getArtifactBonusInfo(arg_49_0)
	local var_49_0 = {}
	local var_49_1 = arg_49_0:getInfo()
	
	if not var_49_1 then
		return {}
	end
	
	for iter_49_0 = 1, 4 do
		local var_49_2 = var_49_1["bonus_artifact" .. iter_49_0] or ""
		local var_49_3 = totable(var_49_2)
		
		if (var_49_3 and var_49_3.artifact) ~= nil then
			var_49_3.order = iter_49_0
			var_49_0[var_49_3.artifact] = var_49_3
		end
	end
	
	return var_49_0
end

function SubstoryManager.getActiveSchedules(arg_50_0, arg_50_1)
	arg_50_1 = arg_50_1 or 0
	
	local var_50_0 = Account:getSubStoryScheduleDB()
	local var_50_1 = {}
	
	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		if iter_50_1.start_time <= os.time() and iter_50_1.end_time + arg_50_1 > os.time() then
			var_50_1[iter_50_0] = iter_50_1
		end
	end
	
	return var_50_1
end

function SubstoryManager.isActiveSchedule(arg_51_0, arg_51_1, arg_51_2)
	if arg_51_0:getActiveSchedules(arg_51_2)[arg_51_1] then
		return true
	end
	
	return false
end

function SubstoryManager.isOpenSubstoryShop(arg_52_0, arg_52_1, arg_52_2)
	return arg_52_0:isActiveSchedule(arg_52_1, arg_52_2)
end

function SubstoryManager.isOpenSubstoryDefaultSchedule(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_1 or (SubstoryManager:getInfo() or {}).id
	
	if not var_53_0 then
		return false
	end
	
	if DEBUG.DEBUG_TEST then
		return false
	end
	
	return arg_53_0:isActiveSchedule(var_53_0, arg_53_2)
end

function SubstoryManager.getScheduleExpireTime(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0:getActiveSchedules(extension_close_time)
	
	if not var_54_0[arg_54_1] then
		return nil
	end
	
	return var_54_0[arg_54_1].end_time
end

function SubstoryManager.getLastOpenSchedule(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0:getActiveSchedules()
	local var_55_1
	
	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		if string.starts(iter_55_0, arg_55_1) and (var_55_1 == nil or iter_55_1.start_time > var_55_1.start_time) then
			var_55_1 = iter_55_1
		end
	end
	
	return var_55_1
end

function SubstoryManager.getRemainEnterTime(arg_56_0, arg_56_1, arg_56_2)
	arg_56_2 = arg_56_2 or 0
	
	local var_56_0 = os.time()
	local var_56_1 = Account:getSubStoryScheduleDB()[arg_56_1]
	local var_56_2 = var_56_1.start_time - os.time()
	local var_56_3 = var_56_1.end_time + arg_56_2 <= os.time()
	
	return math.max(var_56_2, 0), var_56_3
end

function SubstoryManager.isActiveEffectArtifact(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0:getActiveSchedules()
	
	for iter_57_0, iter_57_1 in pairs(var_57_0) do
		local var_57_1 = DBT("substory_main", iter_57_0, "bonus_artifact1", "bonus_artifact2", "bonus_artifact3", "bonus_artifact4")
		
		for iter_57_2 = 1, 4 do
			local var_57_2 = var_57_1["bonus_artifact" .. iter_57_2]
			
			if var_57_2 then
				local var_57_3 = totable(var_57_2)
				
				if var_57_3 and var_57_3.artifact == arg_57_1 then
					return true
				end
			end
		end
	end
	
	return false
end

function SubstoryManager.setCoreRewardIcons(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0
	
	if arg_58_2 then
		var_58_0 = SubStoryUtil:getSubstoryDB(arg_58_2)
	else
		var_58_0 = SubstoryManager:getInfo()
	end
	
	if not var_58_0 or table.empty(var_58_0) then
		return 
	end
	
	local var_58_1 = var_58_0.core_reward_summary
	local var_58_2 = totable(var_58_0.reward_equip_info or {})
	local var_58_3 = arg_58_0:getLastOpenSchedule(var_58_0.id)
	
	if not var_58_3 then
		return nil
	end
	
	local var_58_4 = var_58_3.id or arg_58_2
	local var_58_5 = {}
	local var_58_6 = totable(var_58_1)[var_58_4]
	
	if not var_58_6 then
		arg_58_1:setVisible(false)
		
		return nil
	end
	
	if type(var_58_6) == "string" then
		var_58_6 = {
			var_58_6
		}
	end
	
	arg_58_1:setVisible(true)
	if_set_visible(arg_58_1, "n_custom_frame", var_58_0.custom_type == "y" or var_58_0.custom_type == "frame")
	
	for iter_58_0 = 1, 2 do
		local var_58_7 = arg_58_1:getChildByName("n_core_reward" .. iter_58_0)
		
		if var_58_7 and var_58_6[iter_58_0] then
			local var_58_8 = {
				skill_preview = true,
				parent = var_58_7
			}
			local var_58_9
			local var_58_10
			local var_58_11 = var_58_2[var_58_6[iter_58_0]]
			
			if var_58_11 then
				local var_58_12 = var_58_11[1]
				local var_58_13 = var_58_11[2]
				
				var_58_8 = merge_table(var_58_8, {
					grade_rate = var_58_12,
					set_drop = var_58_13
				})
			end
			
			local var_58_14 = merge_table(var_58_8, table.clone(arg_58_3))
			local var_58_15 = UIUtil:getRewardIcon(nil, var_58_6[iter_58_0], var_58_14)
			
			table.insert(var_58_5, var_58_15)
		end
	end
	
	return var_58_5
end

function SubstoryManager.isArtiOpen(arg_59_0, arg_59_1, arg_59_2)
	if not arg_59_1 or not string.find(arg_59_1, arg_59_2) then
		return true
	end
	
	local var_59_0 = totable(arg_59_1)
	
	for iter_59_0, iter_59_1 in pairs(var_59_0) do
		if type(iter_59_1) == "table" then
			for iter_59_2, iter_59_3 in pairs(iter_59_1) do
				if iter_59_3 == arg_59_2 then
					return GlobalSubstoryManager:isActiveSchedule(iter_59_0)
				end
			end
		elseif iter_59_1 == arg_59_2 then
			return GlobalSubstoryManager:isActiveSchedule(iter_59_0)
		end
	end
	
	return true
end

function SubstoryManager.isHeroOpen(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_1 or not string.find(arg_60_1, arg_60_2) then
		return true
	end
	
	local var_60_0 = totable(arg_60_1)
	
	for iter_60_0, iter_60_1 in pairs(var_60_0) do
		if type(iter_60_1) == "table" then
			for iter_60_2, iter_60_3 in pairs(iter_60_1) do
				if iter_60_3 == arg_60_2 then
					return GlobalSubstoryManager:isActiveSchedule(iter_60_0)
				end
			end
		elseif iter_60_1 == arg_60_2 then
			return GlobalSubstoryManager:isActiveSchedule(iter_60_0)
		end
	end
	
	return true
end

function SubstoryManager.getDungeonProperty(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = (Account:getSubStoryDungeonProperty() or {})[arg_61_2]
	
	if not var_61_0 or var_61_0.substory_id ~= arg_61_1 then
		return nil
	end
	
	return var_61_0.property
end

function SubstoryManager.setDungeonProperty(arg_62_0, arg_62_1)
	if not AccountData.substory_dungeon_property then
		AccountData.substory_dungeon_property = {}
	end
	
	AccountData.substory_dungeon_property[arg_62_1.enter_id] = arg_62_1
end

function SubstoryManager.canShowSubCusUI(arg_63_0, arg_63_1)
	if arg_63_1 then
		local var_63_0 = SubStoryUtil:getSubstoryDB(arg_63_1)
	else
		local var_63_1 = SubstoryManager:getInfo()
	end
	
	return infos and not infos.custom_item_hide
end

function SubstoryManager.isResetSubCusItem(arg_64_0, arg_64_1)
	if arg_64_0:isInCludeDungeonPropertyType(arg_64_1, "custom_reset") then
		local var_64_0 = Account:getSubStoryDungeonProperty() or {}
		
		if table.empty(var_64_0) then
			return true
		end
		
		for iter_64_0, iter_64_1 in pairs(var_64_0) do
			if iter_64_0 == arg_64_1 then
				return ((iter_64_1.property or {}).custom_reset or 0) <= 0
			end
		end
		
		return true
	end
	
	return false
end

function SubstoryManager.checkSubCusResetData(arg_65_0, arg_65_1)
	if arg_65_0:isInCludeDungeonPropertyType(arg_65_1, "custom_reset") then
		return 
	end
	
	local var_65_0 = DB("level_enter", arg_65_1, {
		"local_num"
	})
	local var_65_1 = DB("level_world_3_chapter", var_65_0, {
		"reset_lock"
	})
	
	if var_65_1 then
		local var_65_2 = string.split(var_65_1, ";")
		
		if var_65_2 and not table.empty(var_65_2) then
			for iter_65_0, iter_65_1 in pairs(var_65_2) do
				if not arg_65_0:isInCludeDungeonPropertyType(iter_65_1, "custom_reset") then
					return true
				end
			end
		end
	end
end

function SubstoryManager.blockBeforeChapter(arg_66_0, arg_66_1)
	if not arg_66_1 then
		return false
	end
	
	local var_66_0 = DB("level_enter", arg_66_1, {
		"local_num"
	})
	
	if not var_66_0 then
		return false
	end
	
	local var_66_1 = DB("level_world_3_chapter", var_66_0, {
		"reset_lock"
	})
	
	if not var_66_1 then
		return false
	end
	
	local var_66_2 = string.split(var_66_1, ";")
	local var_66_3 = Account:getSubStoryDungeonProperty() or {}
	
	for iter_66_0, iter_66_1 in pairs(var_66_2) do
		if var_66_3[iter_66_1] then
			local var_66_4 = var_66_3[iter_66_1].property
			
			if var_66_4 and tonumber(var_66_4.custom_reset or 0) > 0 then
				return true
			end
		end
	end
	
	return false
end

function SubstoryManager.isUnlockDungeon(arg_67_0, arg_67_1, arg_67_2)
	if not arg_67_0:isInCludeDungeonPropertyType(arg_67_2, "material_lock") then
		return true
	end
	
	local var_67_0 = SubstoryManager:getInfo()
	local var_67_1 = arg_67_0:getDungeonProperty(arg_67_1 or (arg_67_0:getInfo() or {}).id, arg_67_2) or {}
	
	if tonumber(var_67_1.unlock or 0) > 0 then
		return true
	end
	
	return false
end

function SubstoryManager.isInCludeDungeonPropertyType(arg_68_0, arg_68_1, arg_68_2)
	local var_68_0 = arg_68_0:getDungeonPropertyDB(arg_68_1)
	
	if not var_68_0 then
		return false
	end
	
	if not var_68_0.id then
		return false
	end
	
	if var_68_0.id ~= arg_68_1 then
		return false
	end
	
	for iter_68_0 = 1, 2 do
		if var_68_0["type" .. tostring(iter_68_0)] and var_68_0["type" .. tostring(iter_68_0)] == arg_68_2 then
			return true
		end
	end
	
	return false
end

function SubstoryManager.getDungeonPropertyDB(arg_69_0, arg_69_1)
	return DBT("level_substory_enter_property", arg_69_1, {
		"id",
		"type1",
		"unlock_material",
		"unlock_count",
		"hide_count",
		"unlock_icon",
		"unlock_popup_title",
		"unlock_popup_desc",
		"unlock_popup_btn",
		"unlock_toast_msg",
		"unlock_popup_effect",
		"reset_popup_title",
		"reset_popup_desc",
		"reset_popup_warning"
	})
end

function SubstoryManager.showCoreRewardPopup(arg_70_0, arg_70_1, arg_70_2)
	arg_70_1 = arg_70_1 or SceneManager:getDefaultLayer()
	
	local var_70_0 = Dialog:open("wnd/dungeon_story_reward_popup", arg_70_0)
	
	arg_70_1:addChild(var_70_0)
	
	local var_70_1 = SubstoryManager:getActiveSchedules()
	local var_70_2
	
	if arg_70_2 then
		var_70_2 = SubStoryUtil:getSubstoryDB(arg_70_2)
	else
		var_70_2 = SubstoryManager:getInfo()
	end
	
	if not var_70_2 then
		return 
	end
	
	local var_70_3 = totable(var_70_2.reward_equip_info or {})
	
	for iter_70_0 = 1, 4 do
		local var_70_4 = var_70_2["core_reward_title" .. iter_70_0]
		local var_70_5 = var_70_2["core_reward" .. iter_70_0]
		
		if_set(var_70_0, "txt_core_reward" .. iter_70_0, T(var_70_4))
		if_set_visible(var_70_0, "txt_core_reward" .. iter_70_0, var_70_4 ~= nil)
		
		local var_70_7, var_70_8
		
		if var_70_5 then
			local var_70_6 = totable(var_70_5)
			
			var_70_7 = var_70_0:getChildByName("n_core_reward" .. iter_70_0)
			var_70_8 = {}
			
			for iter_70_1, iter_70_2 in pairs(var_70_6) do
				local var_70_9 = var_70_1[iter_70_1]
				
				if var_70_9 then
					if type(iter_70_2) == "table" then
						for iter_70_3, iter_70_4 in pairs(iter_70_2) do
							table.insert(var_70_8, {
								code = iter_70_4,
								start_time = var_70_9.start_time,
								idx = iter_70_3
							})
						end
					else
						table.insert(var_70_8, {
							code = iter_70_2,
							start_time = var_70_9.start_time,
							idx = iter_70_1
						})
					end
				else
					table.insert(var_70_8, {
						idx = 0,
						code = "m0000",
						start_time = 0
					})
				end
			end
			
			table.sort(var_70_8, function(arg_71_0, arg_71_1)
				return (tonumber(arg_71_0.start_time) or 999) - (arg_71_0.idx or 0) > (tonumber(arg_71_1.start_time) or 999) - (arg_71_1.idx or 0)
			end)
			
			for iter_70_5 = 1, 4 do
				local var_70_10 = var_70_7:getChildByName("n_reward" .. iter_70_5)
				
				if get_cocos_refid(var_70_10) and var_70_8[iter_70_5] then
					local var_70_11 = {
						skill_preview = true,
						parent = var_70_10
					}
					
					if var_70_8[iter_70_5].code == "m0000" then
						var_70_11 = merge_table(var_70_11, {
							no_grade = true
						})
					else
						local var_70_12
						local var_70_13
						local var_70_14 = var_70_3[var_70_8[iter_70_5].code]
						
						if var_70_14 then
							local var_70_15 = var_70_14[1]
							local var_70_16 = var_70_14[2]
							
							var_70_11 = merge_table(var_70_11, {
								grade_rate = var_70_15,
								set_drop = var_70_16
							})
						end
					end
					
					local var_70_17 = UIUtil:getRewardIcon(nil, var_70_8[iter_70_5].code, var_70_11)
				elseif get_cocos_refid(var_70_10) then
					var_70_10:setVisible(false)
				end
			end
		end
	end
end

function SubstoryManager.showDLCCoreRewardPopup(arg_72_0, arg_72_1, arg_72_2)
	arg_72_1 = arg_72_1 or SceneManager:getDefaultLayer()
	
	local var_72_0 = Dialog:open("wnd/story_dlc_reward_popup", arg_72_0)
	
	arg_72_1:addChild(var_72_0)
	
	local var_72_1 = SubstoryManager:getActiveSchedules()
	local var_72_2
	
	if arg_72_2 then
		var_72_2 = SubStoryUtil:getSubstoryDB(arg_72_2)
	else
		var_72_2 = SubstoryManager:getInfo()
	end
	
	if not var_72_2 or not var_72_2.dlc_core_reward then
		return 
	end
	
	local var_72_3 = string.split(var_72_2.dlc_core_reward, ",")
	local var_72_4 = totable(var_72_2.reward_equip_info or {})
	
	if not var_72_3 or table.empty(var_72_3) then
		return 
	end
	
	local var_72_5 = var_72_0:getChildByName("n_core_reward")
	local var_72_6 = 1
	
	for iter_72_0, iter_72_1 in pairs(var_72_3) do
		local var_72_7 = var_72_5:getChildByName("n_reward" .. var_72_6)
		local var_72_8 = {
			skill_preview = true,
			parent = var_72_7
		}
		
		if iter_72_1 == "m0000" then
			var_72_8 = merge_table(var_72_8, {
				no_grade = true
			})
		end
		
		local var_72_9
		local var_72_10
		local var_72_11 = var_72_4[iter_72_1]
		
		if var_72_11 then
			local var_72_12 = var_72_11[1]
			local var_72_13 = var_72_11[2]
			
			var_72_8 = merge_table(var_72_8, {
				grade_rate = var_72_12,
				set_drop = var_72_13
			})
		end
		
		if string.starts(iter_72_1, "c") then
			var_72_8.scale = 1.1
		end
		
		local var_72_14 = UIUtil:getRewardIcon(nil, iter_72_1, var_72_8)
		
		var_72_6 = var_72_6 + 1
	end
end

function SubstoryManager.getQuickMenuSubstoryList(arg_73_0)
	local var_73_0 = SubStoryUtil:getStoryList(true, {
		unlock_only = true
	}) or {}
	local var_73_1 = {}
	local var_73_2 = false
	
	for iter_73_0, iter_73_1 in pairs(var_73_0) do
		local var_73_3, var_73_4, var_73_5 = SubStoryUtil:getEventTimeInfo(iter_73_1)
		local var_73_6 = GlobalSubstoryManager:isContentsType(iter_73_1, GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM)
		
		if var_73_3 ~= SUBSTORY_CONSTANTS.STATE_CLOSE_SOON and table.empty(var_73_1) and var_73_6 then
			table.insert(var_73_1, iter_73_1)
			
			var_73_2 = true
			
			break
		end
	end
	
	for iter_73_2, iter_73_3 in pairs(var_73_0) do
		if table.count(var_73_1) >= 2 then
			break
		end
		
		local var_73_7, var_73_8, var_73_9 = SubStoryUtil:getEventTimeInfo(iter_73_3)
		local var_73_10 = GlobalSubstoryManager:isContentsType(iter_73_3, GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM)
		
		if var_73_7 ~= SUBSTORY_CONSTANTS.STATE_CLOSE_SOON and iter_73_3.id ~= "vewrda" and iter_73_3.id ~= "vcudlc" and not var_73_10 then
			table.insert(var_73_1, iter_73_3)
		end
	end
	
	if not var_73_2 then
		table.reverse(var_73_1)
	end
	
	return var_73_1
end

function SubstoryManager.shortcutQuickMenu(arg_74_0, arg_74_1)
	if not arg_74_1.info then
		return Log.e("SubstoryManager.setQuickMenuShortcut", "no_info")
	end
	
	local var_74_0 = arg_74_1.info.id
	
	if arg_74_1.info and GlobalSubstoryManager:isContentsType(arg_74_1.info, GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM) then
		if SubstoryAlbum:isEmptyAllMissions(var_74_0) then
			SceneManager:reserveResetSceneFlow()
			GlobalSubstoryManager:enterQuery(var_74_0)
		else
			SubStoryAlbumQuickPopup:show(var_74_0)
		end
	else
		local var_74_1 = arg_74_0:getInfo()
		
		if var_74_1 and var_74_1.id == var_74_0 then
			TopBarNew:closeQuickMenu()
			SubStoryEntrance:setBackType("close")
			SubStoryEntrance:setForceBackLobby(nil)
			SubStoryEntrance:close()
		else
			SceneManager:cancelReseveResetSceneFlow()
			movetoPath("epic7://substory_lobby?substory_id=" .. var_74_0)
		end
	end
end

function SubstoryManager.moveLastEpilogue(arg_75_0)
	local var_75_0 = WorldMapManager:getSubstoryLinkDB("vewrda")
	local var_75_1 = Account:getConfigData("last_clear_town.vewrda") or " wrd_rehas001"
	local var_75_2 = DB("level_enter", var_75_1, "local_num") or "wrd_rehas"
	local var_75_3 = var_75_0.chapter[var_75_2]
	
	if not var_75_3 then
		var_75_2 = "wrd_rehas"
		var_75_3 = var_75_0.chapter[var_75_2]
	end
	
	local var_75_4 = var_75_3.key_continent
	
	movetoPath("epic7://substory_lobby?substory_id=vewrda&contents=1&continentkey=vewrda&continent=" .. var_75_2)
end

function SubstoryManager.getChapterIDList(arg_76_0)
	local var_76_0 = {}
	
	if not arg_76_0:getInfo() then
		Log.e("no_info", "SubstoryManager.getChapterIDList")
		
		return {}
	end
	
	local var_76_1 = SubstoryManager:getWorldMapContentsDB()
	
	if not var_76_1 then
		Log.e("no_contents_db", "SubstoryManager.getChapterIDList")
		
		return {}
	end
	
	local var_76_2 = var_76_1.world_id
	
	if not var_76_2 then
		Log.e("no_world_id", "SubstoryManager.getChapterIDList")
		
		return {}
	end
	
	local var_76_3 = DB("level_world_1_world", tostring(var_76_2), "key_continent")
	
	if not var_76_3 then
		Log.e("no_key_continent", "SubstoryManager.getChapterIDList")
		
		return {}
	end
	
	for iter_76_0 = 1, 99 do
		local var_76_4 = string.format("%s%03d", var_76_3, iter_76_0)
		local var_76_5, var_76_6 = DB("level_world_2_continent", var_76_4, {
			"id",
			"key_normal"
		})
		
		if not var_76_5 then
			break
		end
		
		if var_76_6 then
			local var_76_7 = DB("level_world_3_chapter", var_76_6, {
				"id"
			})
			
			if var_76_7 then
				table.insert(var_76_0, var_76_7)
			end
		end
	end
	
	return var_76_0
end

function SubstoryManager.openStoryShop(arg_77_0)
	local var_77_0 = SubstoryManager:getInfo()
	local var_77_1 = arg_77_0:getShopItemList()
	
	SubstoryShop:open(var_77_1, var_77_0)
end

function SubstoryManager.setShopItemList(arg_78_0, arg_78_1)
	arg_78_0.shop_item_list = arg_78_1
end

function SubstoryManager.getShopItemList(arg_79_0)
	if not arg_79_0:getInfo() then
		return nil
	end
	
	return arg_79_0.shop_item_list or {}
end

function SubstoryManager.isEpilogueUI(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0 = arg_80_2 or SubstoryManager:getInfo()
	
	if not var_80_0 then
		return false
	end
	
	return var_80_0.lite_ui == "epilogue"
end

function SubstoryManager.isEndAble(arg_81_0)
	local var_81_0 = arg_81_0:getInfo()
	local var_81_1 = var_81_0.achieve_flag
	local var_81_2 = var_81_0.quest_flag
	local var_81_3 = Account:getSubStory(var_81_0.id)
	
	if var_81_2 == "y" and var_81_3.quest_reward_state < 2 then
		return false, "quest"
	end
	
	if var_81_1 == "y" and var_81_3.ach_reward_state < 2 then
		return false, "achieve_state"
	end
	
	if SubstoryManager:getWorldMapContentsDB().star_mission_hide ~= "y" then
		local var_81_4 = SubstoryManager:getChapterIDList()
		
		for iter_81_0, iter_81_1 in pairs(var_81_4) do
			if (Account:getWorldmapReward(iter_81_1) or 0) < DB("level_world_3_chapter", iter_81_1, "reward_star3") then
				return false, "star"
			end
		end
	end
	
	if var_81_1 == "y" then
		for iter_81_2 = 1, 999 do
			local var_81_5 = var_81_0.id .. "_" .. "ach_" .. string.format("%02d", iter_81_2)
			local var_81_6, var_81_7, var_81_8 = DB("substory_achievement", var_81_5, {
				"id",
				"reward_id1",
				"ignore_complete_cond"
			})
			
			if not var_81_6 then
				break
			end
			
			if var_81_7 and var_81_8 ~= "y" then
				local var_81_9 = Account:getSubStoryAchievement(var_81_6) or {}
				
				if tonumber(var_81_9.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) ~= tonumber(SUBSTORY_ACHIEVE_STATE.REWARDED) then
					return false, "achieve_reward"
				end
			end
		end
	end
	
	return true
end

function SubstoryManager.isEndStory(arg_82_0, arg_82_1)
	if not arg_82_1 then
		return 
	end
	
	return (Account:getSubStory(arg_82_1) or {}).end_dlc == 1
end

function SubstoryManager.msgEndDescentLock(arg_83_0, arg_83_1)
	if arg_83_0:isActiveDescentScheduels() then
		return false
	end
	
	for iter_83_0, iter_83_1 in pairs(arg_83_1) do
		if iter_83_1 == "descent" or iter_83_1 == "ul_descent" then
			Dialog:msgBox(T("msg_hero_used_descent"), {
				handler = function()
					SceneManager:nextScene("lobby")
				end
			})
			
			return true
		end
	end
	
	return false
end

function SubstoryManager.isActiveDescentScheduels(arg_85_0)
	local var_85_0 = AccountData.substory_schedule or {}
	
	for iter_85_0, iter_85_1 in pairs(var_85_0) do
		if DB("substory_main", iter_85_0, "contents_type") == SUBSTORY_CONTENTS_TYPE.DESCENT and arg_85_0:isActiveSchedule(iter_85_0) then
			return true
		end
	end
	
	return false
end

function SubstoryManager.queryEnter(arg_86_0, arg_86_1, arg_86_2)
	local var_86_0, var_86_1 = BackPlayUtil:checkSubstoryInBackPlay()
	
	if not var_86_0 then
		balloon_message_with_sound(var_86_1)
		
		return 
	end
	
	if SubStoryUtil:isContentsTypeByID(arg_86_1, GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM) then
		GlobalSubstoryManager:enterQuery(arg_86_1)
		
		return 
	end
	
	arg_86_2 = arg_86_2 or {}
	
	local var_86_2 = SubstoryManager:findContentsTypeColumn("content_tournament", arg_86_1)
	local var_86_3
	
	if var_86_2 and Tournament:getNpcList() == nil then
		var_86_3 = true
	end
	
	local var_86_4
	local var_86_5 = Account:getSubstoryPassData()
	
	if var_86_5 then
		var_86_4 = var_86_5.id
	end
	
	local var_86_6 = Account:isRequestSubStoryStories(arg_86_1)
	local var_86_7 = Account:isRequestSubStoryDungeonMissions(arg_86_1)
	local var_86_8 = Account:isRequestSubStoryTutorials(arg_86_1)
	local var_86_9 = json.encode(arg_86_2.pathParams)
	local var_86_10 = Account:isRequestSubStoryPieces(arg_86_1)
	
	query("enter_sub_story", {
		sub_story_id = arg_86_1,
		request_tour_npc = var_86_3,
		pass_id = var_86_4,
		is_request_story = var_86_6,
		pathParams = var_86_9,
		is_request_pieces = var_86_10,
		is_req_d_missions = var_86_7,
		is_request_tutorial = var_86_8
	})
end

function SubstoryManager.checkEndEvent(arg_87_0)
	local var_87_0, var_87_1, var_87_2 = arg_87_0:getEventTimeInfo()
	
	if var_87_0 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON or var_87_0 == SUBSTORY_CONSTANTS.STATE_CLOSE then
		return true
	end
	
	return false
end

function SubstoryManager.isNewDlc(arg_88_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SUBSTORY_DLC) then
		return false
	end
	
	if not arg_88_0.last_new_order then
		local var_88_0 = 0
		
		for iter_88_0 = 1, 999 do
			local var_88_1, var_88_2, var_88_3 = DBN("substory_main", iter_88_0, {
				"id",
				"type",
				"new_order"
			})
			
			if not var_88_1 then
				break
			end
			
			if var_88_2 == "dlc" and var_88_3 and var_88_0 <= var_88_3 then
				var_88_0 = var_88_3
			end
		end
		
		arg_88_0.last_new_order = var_88_0
	end
	
	if not arg_88_0.last_new_order then
		return false
	end
	
	if (Account:getConfigData("ss_dlc_new") or 0) < arg_88_0.last_new_order then
		return true
	end
	
	return false
end

function SubstoryManager.updateNewDlcOrder(arg_89_0)
	if not arg_89_0:isNewDlc() then
		return 
	end
	
	if not arg_89_0.last_new_order then
		return 
	end
	
	if arg_89_0.last_new_order == 0 then
		return 
	end
	
	if type(arg_89_0.last_new_order) ~= "number" then
		return 
	end
	
	SAVE:setTempConfigData("ss_dlc_new", arg_89_0.last_new_order)
end

function SubstoryManager.isSystemSubStory(arg_90_0)
	if arg_90_0:getInfo().type == "system" then
		return true
	end
	
	return false
end

function SubstoryManager.getPlaySubstoryIDList(arg_91_0)
	local var_91_0 = {}
	local var_91_1 = arg_91_0:getInfo()
	
	if var_91_1 and var_91_1.id then
		table.insert(var_91_0, var_91_1.id)
	end
	
	if Battle.logic and SceneManager:getCurrentSceneName() == "battle" then
		local var_91_2 = Battle.logic:getCurrentSubstoryID()
		
		if var_91_2 and not table.find(var_91_0, var_91_2) then
			table.insert(var_91_0, var_91_2)
		end
	end
	
	local var_91_3 = BackPlayManager:getLastBattle()
	
	if BackPlayControlBox:canOpen() and var_91_3 and var_91_3.logic then
		local var_91_4 = var_91_3.logic:getCurrentSubstoryID()
		
		if var_91_4 and not table.find(var_91_0, var_91_4) then
			table.insert(var_91_0, var_91_4)
		end
	end
	
	local var_91_5 = BackPlayManager:getBattles()
	
	for iter_91_0, iter_91_1 in pairs(var_91_5) do
		local var_91_6 = iter_91_1.logic:getCurrentSubstoryID()
		
		if iter_91_1.logic and var_91_6 and not table.find(var_91_0, var_91_6) then
			table.insert(var_91_0, var_91_6)
		end
	end
	
	local var_91_7 = BackPlayManager:getSubstoryId()
	
	if not string.empty(var_91_7) and not table.find(var_91_0, var_91_7) then
		table.insert(var_91_0, var_91_7)
	end
	
	return var_91_0
end
