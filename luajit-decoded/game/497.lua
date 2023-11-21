UnlockSystem = UnlockSystem or {}
UNLOCK_TYPE = {
	ECT = "etc",
	MAZE = "maze",
	DUNGEON = "battlemenu",
	CONTINENT = "continent"
}
UNLOCK_ID = {
	SHOP = "system_010",
	TUTORIAL_EQUIP = "system_064",
	COLLECTION_BOOK = "system_051",
	CLAN_MAIN = "system_072",
	GACHA = "system_011",
	SANC_CRAFT = "system_070",
	EQUIP_CRAFT = "system_009",
	GROWTH_BOOST_2 = "system_181",
	ENHANCE_UNIT = "system_047",
	SUBSTORY_DLC = "system_140",
	SUPPORT = "system_060",
	FOREST_UPGRADE = "system_068",
	SELECT_GACHA = "system_094",
	ZODIAC = "system_049",
	CONTINENT = "system_001",
	EQUIP_UPGRADE = "system_123",
	TUTORIAL003 = "tutorial003",
	GROWTH_BOOST_1 = "system_180",
	EXPDEITION = "system_124",
	TUTORIAL_LOBBY = "system_061",
	ALTER_DEV = "system_119",
	SANC_ORBIS = "system_067",
	EQUIP_SUB_CHANGE = "system_139",
	TOWN = "system_013",
	MOONLIGHT_DESTINY = "system_143",
	EQUIP_MANAGER = "system_144",
	SELL_UNIT = "system_048",
	ADIN_AWAKE = "system_151",
	MOONLIGHT_THEATER = "system_179",
	MUSIC_PLAYER = "system_185",
	RAID = "system_045",
	ADIN = "system_162",
	DESTINY = "system_066",
	PUB = "system_016",
	GROWTH_BOOST_3 = "system_182",
	GROWTH_BOOST_4 = "system_183",
	MULTI_PROMOTE = "system_145",
	TRIAL_HALL = "system_118",
	CHAOS_2 = "chaos_touch_2",
	WEEKLY = "system_002",
	WORLD_ARENA = "system_122",
	HELL = "system_006",
	MAZE_CHALLENGE_OPEN = "system_184",
	SANC_SUBTASK = "system_069",
	PVP = "system_008",
	FRIEND = "system_014",
	SYSTEM_SUBSTORY = "system_188",
	SUBSTORY = "system_091",
	CHAOS_1 = "chaos_touch_1",
	ORIGIN_TREE_VAM = "system_205",
	STORY = "herostory",
	MAZE_RAID = "system_097",
	PET = "system_120",
	SUBSTORY_DESCENT = "system_146",
	CRE_HUNT = "system_206",
	SANC_ALCHEMIST = "system_071",
	SPECIAL_SHOP = "system_005",
	WORLD_BOSS = "system_121",
	GACHA_SPECIAL = "system_098",
	URGENT_MISSION = "system_004",
	PVP_NPC_HELL = "system_081",
	ADVENTURE = "adventure",
	PVP_NPC_HARD = "system_080",
	LOCAL_SHOP = "system_099",
	TUTORIAL002 = "tutorial002",
	EQUIP_EXTRACT = "system_126",
	MAZE_PORTAL = "maze_portal",
	SANC_FOREST = "system_068",
	WORLD_LEVEL = "system_075",
	BISTRO = "system_050",
	SICA = "system_055",
	CLAN = "system_015",
	ORIGIN_TREE_ELF = "system_204",
	MAZE_WAY = "maze_way",
	GACHA_MOONLIGHT = "system_095",
	CLASS_CHANGE = "system_141",
	GROWTH_GUIDE = "system_101",
	GACHA_CUSTOMGROUP = "system_202",
	EXCLUSIVE = "exclusive",
	ACHIEVEMENT = "system_012",
	HELL_CHALLENGE = "system_178",
	HUNT = "system_007",
	SINSU = "system_046",
	ORBIS_UPGRADE = "system_073",
	FORMATION_UNIT = "system_059",
	AUTOMATON = "system_100",
	SOUL_BURN = "soulburn",
	MAZE = "system_003"
}

function UnlockSystem.getJustInfoIDs(arg_1_0, arg_1_1)
	local var_1_0 = {}
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		if not DB("system_achievement", iter_1_1, {
			"hide"
		}) then
			local var_1_1, var_1_2, var_1_3, var_1_4 = DB("system_achievement_effect", iter_1_1, {
				"id",
				"effect_desc",
				"effect_icon",
				"comp_move"
			})
			
			if var_1_1 and var_1_2 and var_1_3 and not var_1_4 then
				table.insert(var_1_0, iter_1_1)
			end
		end
	end
	
	return var_1_0
end

function UnlockSystem.getCompMoveInfoIDs(arg_2_0, arg_2_1)
	local var_2_0 = {}
	
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		local var_2_1, var_2_2, var_2_3, var_2_4 = DB("system_achievement_effect", iter_2_1, {
			"id",
			"effect_desc",
			"effect_icon",
			"comp_move"
		})
		
		if var_2_1 and var_2_2 and var_2_3 and var_2_4 then
			table.insert(var_2_0, iter_2_1)
		end
	end
	
	return var_2_0
end

function UnlockSystem.isMoveToLobby(arg_3_0, arg_3_1)
	return DB("system_achievement_effect", arg_3_1, {
		"comp_move"
	})
end

function UnlockSystem.getPrioritySceneMoveID(arg_4_0, arg_4_1)
	local var_4_0
	local var_4_1 = arg_4_0:getFirstUnhideSystem(arg_4_1)
	
	if var_4_1 then
		return var_4_1
	end
	
	local var_4_2 = arg_4_0:getFirstUnhideSystem(arg_4_1)
	
	if var_4_2 then
		return var_4_2
	end
end

function UnlockSystem.getFirstUnhideUnlockID(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(arg_5_1) do
		if not DB("system_achievement", iter_5_1, {
			"hide"
		}) then
			return iter_5_1
		end
	end
	
	return nil
end

function UnlockSystem.getFirstUnhideSystem(arg_6_0, arg_6_1)
	for iter_6_0, iter_6_1 in pairs(arg_6_1 or {}) do
		if not DB("system_achievement", iter_6_1.sys_id, {
			"hide"
		}) then
			return iter_6_1
		end
	end
	
	return nil
end

function UnlockSystem.getContinentUnlockSystems(arg_7_0, arg_7_1)
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		if DB("system_achievement_effect", iter_7_1, {
			"type"
		}) == "continent" then
			table.insert(var_7_0, {
				sys_id = iter_7_1
			})
		end
	end
	
	return var_7_0
end

function UnlockSystem.getUnlockMazeIndex(arg_8_0, arg_8_1)
	for iter_8_0 = 1, 99 do
		local var_8_0, var_8_1 = DB("level_battlemenu_dungeon", tostring(iter_8_0), {
			"system_ach_id",
			"hide_unlock_eff"
		})
		
		if var_8_0 == arg_8_1 and var_8_1 ~= "y" then
			return iter_8_0
		end
		
		if not var_8_0 then
			break
		end
	end
end

function UnlockSystem.getMazeUnlockSystems(arg_9_0, arg_9_1)
	local var_9_0 = {}
	
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		local var_9_1 = arg_9_0:getUnlockMazeIndex(iter_9_1)
		
		if var_9_1 then
			table.insert(var_9_0, {
				type = UNLOCK_TYPE.MAZE,
				maze = tostring(var_9_1),
				sys_id = iter_9_1
			})
		end
	end
	
	return var_9_0
end

function UnlockSystem.getUnlockDungeonsAchieveId(arg_10_0)
	local var_10_0 = {}
	
	for iter_10_0 = 1, 99 do
		local var_10_1, var_10_2 = DBN("level_battlemenu", tostring(iter_10_0), {
			"id",
			"system_ach_id"
		})
		
		if not var_10_1 then
			break
		end
		
		if var_10_2 and Account:isSysAchieveCleared(var_10_2) then
			table.insert(var_10_0, var_10_2)
		end
	end
	
	return var_10_0
end

function UnlockSystem.isUnlockDungeonSystem(arg_11_0, arg_11_1)
	local var_11_0 = DB("level_battlemenu", tostring(arg_11_1), {
		"system_ach_id"
	})
	
	if Account:isSysAchieveCleared(var_11_0) or not var_11_0 then
		return true
	end
end

function UnlockSystem.getUnlockIdByDungeonId(arg_12_0, arg_12_1)
	return (DB("level_battlemenu", tostring(arg_12_1), {
		"system_ach_id"
	}))
end

function UnlockSystem.isUnlockMazeSystem(arg_13_0)
	for iter_13_0 = 1, 99 do
		local var_13_0 = DB("level_battlemenu_dungeon", tostring(iter_13_0), {
			"system_ach_id"
		})
		
		if Account:isSysAchieveCleared(var_13_0) then
			return true
		end
		
		if not var_13_0 then
			break
		end
	end
end

function UnlockSystem.isUnlockMaze(arg_14_0, arg_14_1)
	local var_14_0 = DB("level_battlemenu_dungeon", tostring(arg_14_1), {
		"system_ach_id"
	})
	
	if Account:isSysAchieveCleared(var_14_0) then
		return true
	end
end

function UnlockSystem.getUnlockIdByMazeId(arg_15_0, arg_15_1)
	return (DB("level_battlemenu_dungeon", tostring(arg_15_1), {
		"system_ach_id"
	}))
end

function UnlockSystem.isUnlockSystem(arg_16_0, arg_16_1, arg_16_2)
	arg_16_2 = arg_16_2 or {}
	
	if Account:isSysAchieveCleared(arg_16_1) then
		return true
	end
	
	if arg_16_2.is_link then
		local var_16_0, var_16_1 = DB("system_achievement", arg_16_1, {
			"id",
			"or_link_clear_id"
		})
		
		if var_16_1 then
			local var_16_2 = string.split(var_16_1, ";")
			
			for iter_16_0, iter_16_1 in pairs(var_16_2) do
				if Account:isSysAchieveCleared(iter_16_1) then
					return true
				end
			end
		end
	end
	
	return false
end

function UnlockSystem.isUnlockSystemAndPlay(arg_17_0, arg_17_1, arg_17_2)
	if DEBUG.MAP_DEBUG then
		arg_17_2()
		
		return true
	end
	
	local var_17_0 = UnlockSystem:getUnlockSystemAndPlayStory({
		id = arg_17_1.id,
		dungeon_id = arg_17_1.dungeon_id,
		maze_id = arg_17_1.maze_id,
		on_finish = arg_17_2
	})
	
	if var_17_0 and var_17_0.unlock == false then
		if var_17_0.before_text then
			if var_17_0.before_text == "notyet_dev" then
				balloon_message_with_sound("notyet_dev")
			else
				Dialog:msgBox(T(var_17_0.before_text), {
					fade_in = 250,
					title = T(var_17_0.effect_title),
					image = "emblem/" .. (var_17_0.effect_icon or "system_013_icon") .. ".png"
				})
			end
			
			return false
		end
	else
		return true
	end
	
	return false
end

function UnlockSystem.setUnlockUIState(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	arg_18_4 = arg_18_4 or {}
	
	if not get_cocos_refid(arg_18_1) then
		return 
	end
	
	local var_18_0 = arg_18_1:getChildByName(arg_18_2)
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	var_18_0.category_unlock_id = arg_18_3
	var_18_0.category_unlock_replace_title = arg_18_4.replace_title
	
	if arg_18_4.force_open then
		var_18_0._force_open = true
	end
	
	local var_18_1 = arg_18_4.force_open or UnlockSystem:isUnlockSystem(arg_18_3)
	local var_18_2 = arg_18_4.icon_name or "icon_locked"
	
	if_set_visible(arg_18_1, var_18_2, not var_18_1)
	
	if not arg_18_4.no_opacity and not var_18_1 then
		var_18_0:setOpacity(76.5)
		
		if not arg_18_4.no_color then
			var_18_0:setColor(UIUtil.GREY)
		end
	end
end

function UnlockSystem.setButtonUnlockInfo(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	arg_19_4 = arg_19_4 or {}
	
	if not get_cocos_refid(arg_19_1) then
		return 
	end
	
	local var_19_0 = arg_19_1:getChildByName(arg_19_2)
	
	if not get_cocos_refid(var_19_0) then
		return 
	end
	
	var_19_0.category_unlock_id = arg_19_3
	var_19_0.category_unlock_replace_title = arg_19_4.replace_title
	
	local var_19_1 = not UnlockSystem:isUnlockSystem(arg_19_3)
	
	if arg_19_4.force_open then
		var_19_1 = false
		var_19_0._force_open = true
	end
	
	if var_19_1 then
		var_19_0:setOpacity(76.5)
		
		local var_19_2 = "_lock_icon#" .. arg_19_3 .. "@" .. arg_19_2
		local var_19_3 = arg_19_1:getChildByName(var_19_2)
		
		if var_19_3 then
			var_19_3:removeFromParent()
		end
		
		local var_19_4 = SpriteCache:getSprite("img/cm_icon_etclock.png")
		
		var_19_4:setName(var_19_2)
		var_19_0:getParent():addChild(var_19_4)
		
		local var_19_5 = arg_19_4.scale or 1
		
		var_19_4:setScale(var_19_5)
		
		local var_19_6, var_19_7 = var_19_0:getPosition()
		local var_19_8 = var_19_0:getContentSize()
		local var_19_9 = var_19_0:getAnchorPoint()
		
		if arg_19_4.right_bottom_pos then
			local var_19_10 = var_19_0:getContentSize().width * (arg_19_4.pos_x_ratio or 0.24)
			local var_19_11 = var_19_0:getContentSize().height * (arg_19_4.pos_y_ratio or 0.19)
			
			var_19_4:setPosition(var_19_6 + var_19_8.width * var_19_0:getScaleX() * (0.5 - var_19_9.x) + var_19_10, var_19_7 + var_19_8.height * var_19_0:getScaleY() * (0.5 - var_19_9.y) - var_19_11)
		elseif arg_19_4.left_bottom_pos then
			local var_19_12 = var_19_0:getContentSize().width * (arg_19_4.pos_x_ratio or 0.24)
			local var_19_13 = var_19_0:getContentSize().height * (arg_19_4.pos_y_ratio or 0.19)
			
			var_19_4:setPosition(var_19_6 + var_19_8.width * var_19_0:getScaleX() * (0.5 - var_19_9.x) - var_19_12, var_19_7 + var_19_8.height * var_19_0:getScaleY() * (0.5 - var_19_9.y) - var_19_13)
		else
			var_19_4:setPosition(var_19_6 + var_19_8.width * var_19_0:getScaleX() * (0.5 - var_19_9.x), var_19_7 + var_19_8.height * var_19_0:getScaleY() * (0.5 - var_19_9.y))
		end
	end
end

function UnlockSystem.getNameUnlockIcon(arg_20_0, arg_20_1, arg_20_2)
	return "_lock_icon#" .. arg_20_2 .. "@" .. arg_20_1
end

function UnlockSystem.isUnlockSystemAndMsg(arg_21_0, arg_21_1, arg_21_2)
	arg_21_1 = arg_21_1 or {}
	
	if TutorialGuide:isBlockUnlockSystemMsg(arg_21_1.id) then
		return false
	end
	
	local var_21_0 = UnlockSystem:getUnlockSystemAndPlayStory({
		id = arg_21_1.id,
		dungeon_id = arg_21_1.dungeon_id,
		maze_id = arg_21_1.maze_id,
		exclude_story = arg_21_1.exclude_story,
		on_finish = arg_21_2
	})
	
	if var_21_0 and var_21_0.id and not DB("system_achievement", var_21_0.id, "id") then
		balloon_message_with_sound("notyet_dev")
		
		return false
	end
	
	if var_21_0 and var_21_0.unlock == false then
		if var_21_0.before_text and not arg_21_1.no_msgbox then
			if var_21_0.before_text == "notyet_dev" then
				balloon_message_with_sound("notyet_dev")
			else
				Dialog:msgBox(T(var_21_0.before_text), {
					fade_in = 250,
					title = T(arg_21_1.replace_title or var_21_0.effect_title)
				})
			end
			
			return false
		end
		
		return false
	else
		if arg_21_2 then
			arg_21_2()
		end
		
		return true
	end
	
	return false
end

function UnlockSystem.checkUnlockAndPlayStory(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0
	local var_22_1
	local var_22_2
	local var_22_3
	
	if arg_22_1 then
		if Account:isSysAchieveCleared(arg_22_1) then
			if arg_22_3 then
				return {
					unlock = true,
					id = arg_22_1
				}
			end
			
			local var_22_4 = arg_22_0:getSystemEnterStoryId(arg_22_1)
			
			if var_22_4 then
				local var_22_5 = SceneManager:getDefaultLayer()
				
				start_new_story(var_22_5, var_22_4, {
					force_on_finish = true,
					on_finish = arg_22_2
				})
			elseif arg_22_2 then
				arg_22_2()
			end
			
			return {
				unlock = true,
				id = arg_22_1
			}
		else
			var_22_0, var_22_3, var_22_2 = arg_22_0:getSystemEnterData(arg_22_1)
		end
	end
	
	return {
		unlock = false,
		id = arg_22_1,
		before_text = var_22_0,
		effect_title = var_22_3,
		effect_icon = var_22_2
	}
end

function UnlockSystem.getUnlockSystemAndPlayStory(arg_23_0, arg_23_1)
	if arg_23_1.dungeon_id then
		if arg_23_1.maze_id then
			local var_23_0 = arg_23_0:getUnlockIdByMazeId(arg_23_1.maze_id)
			
			return arg_23_0:checkUnlockAndPlayStory(var_23_0, arg_23_1.on_finish, arg_23_1.exclude_story)
		end
		
		local var_23_1 = arg_23_0:getUnlockIdByDungeonId(arg_23_1.dungeon_id)
		
		return arg_23_0:checkUnlockAndPlayStory(var_23_1, arg_23_1.on_finish, arg_23_1.exclude_story)
	end
	
	local var_23_2 = arg_23_1.id
	
	return arg_23_0:checkUnlockAndPlayStory(var_23_2, arg_23_1.on_finish, arg_23_1.exclude_story)
end

function UnlockSystem.checkUnlockUrgentMission(arg_24_0, arg_24_1)
	for iter_24_0, iter_24_1 in pairs(arg_24_1) do
		if iter_24_1.achieve_id == UNLOCK_ID.URGENT_MISSION then
			query("open_urgent_mission_system")
			
			break
		end
	end
end

function UnlockSystem.isUnlockAchievementSystem(arg_25_0)
	local var_25_0 = UNLOCK_ID.ACHIEVEMENT
	
	return true
end

function UnlockSystem.isUnlockUrgentSystem(arg_26_0)
	local var_26_0 = UNLOCK_ID.URGENT_MISSION
	
	return Account:isSysAchieveCleared(var_26_0)
end

function UnlockSystem.getSystemEnterStoryId(arg_27_0, arg_27_1)
	local var_27_0, var_27_1 = DB("system_achievement_effect", arg_27_1, {
		"btn_after_story",
		"btn_before_text"
	})
	
	return var_27_0, var_27_1
end

function UnlockSystem.getSystemEnterData(arg_28_0, arg_28_1)
	local var_28_0, var_28_1, var_28_2 = DB("system_achievement_effect", arg_28_1, {
		"btn_before_text",
		"effect_title",
		"effect_icon"
	})
	
	return var_28_0, var_28_1, var_28_2
end

function UnlockSystem.checkStoryUnlock(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_1 == 1 then
		SceneManager:nextScene("lobby", {
			unlock_id = UNLOCK_ID.STORY
		})
	end
end
