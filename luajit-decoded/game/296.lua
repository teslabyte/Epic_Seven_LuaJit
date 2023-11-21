TutorialGuide = {}
TutorialGuide.vars = {}
TutorialGuide.dirty_tutorial = {}
TEST_TUTORIAL = TEST_TUTORIAL or false

function MsgHandler.tutorial_complete(arg_1_0)
	local var_1_0 = string.sub(arg_1_0.tid, 1, -4)
	
	Singular:tutorialEndEvent(var_1_0)
	
	local var_1_1 = DB("tutorial_guide", arg_1_0.tid, "substory_id")
	
	if var_1_1 then
		Account:setSubStoryTutorialState(var_1_1, var_1_0, 1)
	else
		SAVE:saveTutorialGuide(var_1_0)
	end
	
	if (SubstoryManager:getInfo() or {}).id ~= var_1_1 and not SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.DESCENT) then
		Log.e("tutorial_complete", "invalid_substory_id" .. "." .. var_1_0)
	end
	
	if arg_1_0.rewards then
		local var_1_2 = {
			title = T("tutorial_reward_complete"),
			desc = T("tutorial_reward_desc")
		}
		
		for iter_1_0, iter_1_1 in pairs(TutorialGuide.Guides[var_1_0]) do
			if iter_1_1.item_title and iter_1_1.item_text then
				var_1_2.title = iter_1_1.item_title
				var_1_2.desc = iter_1_1.item_text
				
				break
			end
		end
		
		Account:addReward(arg_1_0.rewards, {
			play_reward_data = var_1_2,
			handler = function()
				TutorialGuide:onAddRewardCallback(var_1_0)
			end
		})
	end
end

function MsgHandler.tutorial_complete_list(arg_3_0)
	for iter_3_0, iter_3_1 in pairs(arg_3_0.tid) do
		local var_3_0 = string.sub(iter_3_1, 1, -4)
		
		SAVE:saveTutorialGuide(var_3_0)
		Singular:tutorialEndEvent(var_3_0)
	end
	
	if not arg_3_0.rewards then
		return 
	end
	
	local var_3_1 = {
		title = T("tutorial_reward_complete"),
		desc = T("tutorial_reward_desc")
	}
	
	Account:addReward(arg_3_0.rewards, {
		play_reward_data = var_3_1
	})
end

function HANDLER.guide_talk(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_guide_bg" then
		if is_playing_story() then
			if not TutorialGuide:isStoryType() then
				TutorialGuide:procGuide()
			end
		else
			TutorialGuide:procGuide()
		end
	elseif arg_4_1 == "btn_guide_skip" then
		TutorialGuide:skipGuide(true)
	end
end

function HANDLER.guide_summary(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		TutorialGuide:procGuide()
	end
end

function HANDLER.guide_reward(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" then
		TutorialGuide:procGuide()
	end
end

function HANDLER.guide_select(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_cancel_tutorial" then
		TutorialGuide:skipGuide(true)
	elseif arg_7_1 == "btn_start_tutorial" then
		TutorialGuide:procGuide()
	end
end

local function var_0_0(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not get_cocos_refid(arg_8_0) then
		return 
	end
	
	if arg_8_2 < arg_8_3 then
		return 
	end
	
	if arg_8_0:getName() == arg_8_1 then
		return arg_8_0
	end
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0:getChildren()) do
		local var_8_0 = var_0_0(iter_8_1, arg_8_1, arg_8_2, arg_8_3 + 1)
		
		if var_8_0 ~= nil then
			return var_8_0
		end
	end
	
	return nil
end

local function var_0_1(arg_9_0, arg_9_1, arg_9_2)
	return var_0_0(arg_9_0, arg_9_1, arg_9_2, 0)
end

local function var_0_2()
	local var_10_0
	
	if UnitMain:isValid() then
		var_10_0 = "UnitMain"
	end
	
	return HeroBelt:getInst(var_10_0)
end

local function var_0_3()
	local var_11_0
	
	if UnitEquip:isVisible() then
		var_11_0 = "UnitEquip"
	end
	
	return EquipBelt:getInst(var_11_0)
end

local var_0_4 = {
	TOUCH_BLOCK = function()
		return nil
	end,
	LEFT = function()
		return TutorialGuide.guide_info.wnd:getChildByName("n_LEFT")
	end,
	RIGHT = function()
		return TutorialGuide.guide_info.wnd:getChildByName("n_RIGHT")
	end,
	CENTER = function()
		return TutorialGuide.guide_info.wnd:getChildByName("n_CENTER")
	end,
	BOX_NORMAL = function()
		local var_16_0 = BattleField:getRoadEventFieldModelByName("model/box_normal.scsp")
		
		if var_16_0 then
			return var_16_0
		end
	end,
	CHAOS_GATE = function()
		local var_17_0 = BattleField:getRoadEventFieldModelByName("model/chaosgate.scsp")
		
		if var_17_0 then
			return var_17_0
		end
	end,
	HERO_BELT_SELECT = function(arg_18_0, arg_18_1)
		arg_18_0 = arg_18_0 and string.trim(arg_18_0)
		arg_18_1 = arg_18_1 and string.trim(arg_18_1)
		
		local var_18_0 = var_0_2()
		
		for iter_18_0, iter_18_1 in ipairs(var_18_0:getItems()) do
			if iter_18_1.db.code == arg_18_0 or iter_18_1.db.code == arg_18_1 then
				var_18_0.dock:jumpToIndex(iter_18_0)
				
				return var_18_0:getControl(iter_18_1):getChildByName("add")
			end
		end
	end,
	HERO_BELT_SELECT_WEAPON_EQUIPPED = function()
		local var_19_0 = var_0_2()
		
		for iter_19_0, iter_19_1 in ipairs(var_19_0:getItems()) do
			for iter_19_2, iter_19_3 in pairs(iter_19_1.equips) do
				if iter_19_3.db.type == "weapon" then
					var_19_0.dock:jumpToIndex(iter_19_0)
					
					return var_19_0:getControl(iter_19_1):getChildByName("add")
				end
			end
		end
	end,
	HERO_BELT_UPGRADE_UNIT = function(arg_20_0)
		local var_20_0 = var_0_2()
		
		for iter_20_0, iter_20_1 in ipairs(var_20_0:getItems()) do
			if iter_20_1.db.code == arg_20_0 then
				var_20_0.dock:jumpToIndex(iter_20_0)
				
				return var_20_0:getParentControl(iter_20_1)
			end
		end
	end,
	DESTINY_FIRST = function()
		if DestinyAchieveList.vars and DestinyAchieveList.vars.data and DestinyAchieveList.vars.itemView and #DestinyAchieveList.vars.data > 0 then
			return DestinyAchieveList.vars.itemView:getControl(DestinyAchieveList.vars.data[1]):getChildByName("btn_go")
		end
	end,
	SUMMON_ARKASUS = function()
		for iter_22_0, iter_22_1 in ipairs(SummonUI.ScrollViewItems) do
			if iter_22_1.item.code == "s0001" then
				return iter_22_1.control:getChildByName("btn_toggle")
			end
		end
	end,
	BATTLE_LIST_SELECT = function(arg_23_0)
		return DungeonList:getBattleModeControl(arg_23_0)
	end,
	BATTLE_DUNGEON_SELECT_FIRST = function(arg_24_0)
		local var_24_0 = DungeonList:getCurDungeonObj()
		
		if var_24_0 and var_24_0.getFirstDungeonControl then
			if arg_24_0 then
				return var_24_0:getFirstDungeonControl():getChildByName(arg_24_0)
			else
				return var_24_0:getFirstDungeonControl()
			end
		end
	end,
	BATTLE_DUNGEON_SELECT_INDEX = function(arg_25_0, arg_25_1)
		local var_25_0 = DungeonList:getCurDungeonObj()
		
		if var_25_0 and var_25_0.getDungeonControl then
			local var_25_1 = var_25_0:getDungeonControl(tonumber(arg_25_0))
			
			if var_25_1 then
				if var_25_0.scrollToIndex then
					var_25_0:scrollToIndex(tonumber(arg_25_0), 0.5)
				end
				
				if arg_25_1 then
					return var_25_1:getChildByName(arg_25_1)
				else
					return var_25_1
				end
			end
		end
	end,
	BATTLE_DUNGEON_SELECT_ID = function(arg_26_0, arg_26_1)
		local var_26_0 = DungeonList:getCurDungeonObj()
		
		if var_26_0 and var_26_0.getControlAndIndexByID then
			local var_26_1, var_26_2 = var_26_0:getControlAndIndexByID(arg_26_0)
			
			if var_26_1 then
				if var_26_0.scrollToIndex then
					var_26_0:scrollToIndex(tonumber(var_26_2), 0.5)
				end
				
				if arg_26_1 then
					return var_26_1:getChildByName(arg_26_1)
				else
					return var_26_1
				end
			end
		end
	end,
	ABYSS_CHALLENGE_READY = function()
		return DungeonHell:getReadyBtn()
	end,
	ABYSS_CHALLENGE_MISSION = function()
		return BattleReady:getMissionList()
	end,
	ABYSS_CHALLENGE_ENEMY = function()
		return BattleReady:getEnemyList()
	end,
	ABYSS_CHALLENGE_ROLE = function()
		return BattleReady:getAbyssChallengeInfo()
	end,
	CRAFT_EQUIP_MADE_BUTTON = function()
		return SanctuaryCraftMain:get_equip_made_button()
	end,
	CRAFT_EQUIP_REFORGE_BUTTON = function()
		return SanctuaryCraftMain:get_equip_reforging_button()
	end,
	ALCHEMIST_SELECT_LIST_FIRST = function()
		return SanctuaryArchemist:getFirstScrollView()
	end,
	VIEW_SUBSTORY_MAIN = function(arg_34_0)
		return (SubStoryList:getDungeonControlBySubstoryID(arg_34_0))
	end,
	VIEW_SUBSTORY_MAIN_SELECT = function(arg_35_0, arg_35_1)
		local var_35_0 = SubStoryList:getDungeonControlBySubstoryID(arg_35_0)
		
		if var_35_0 and arg_35_1 then
			return var_35_0:getChildByName(arg_35_1)
		end
	end,
	ORIGIN_TREE_FIRST_RESEARCH = function(arg_36_0)
		return OriginTree:getFirstScrollViewItemForTuto()
	end,
	ORIGIN_TREE_BUTTON_NODE = function(arg_37_0)
		local var_37_0 = WorldMapManager:getController()
		
		if not var_37_0 or not var_37_0.vars or not var_37_0.vars.worldmapUI or not var_37_0.vars.worldmapUI.navi then
			return 
		end
		
		return var_37_0.vars.worldmapUI.navi:getTreeNodeForTutorial()
	end,
	WORLDMAP_ICON = function(arg_38_0)
		return WorldMapManager:getController():getTownIcon(arg_38_0)
	end,
	WORLDMAP_WORLD = function(arg_39_0)
		return WorldMapManager:getController():getWorldIcon(arg_39_0)
	end,
	WORLDMAP_CONTINENT = function(arg_40_0)
		return WorldMapManager:getController():getContinentIcon(arg_40_0)
	end,
	BATTLE_HOME = function(arg_41_0)
		local var_41_0 = DungeonHome:getDungeonItemControl(arg_41_0)
		
		return var_41_0 and var_41_0:getChildByName("dim")
	end,
	BATTLE_HOME_SELECT = function(arg_42_0)
		local var_42_0 = DungeonHome:getDungeonItemControl(arg_42_0)
		
		return var_42_0 and var_42_0.c.btn_select
	end,
	EQUIP_BELT_TOP_WEAPON = function(arg_43_0)
		local var_43_0 = var_0_3()
		
		if arg_43_0 then
			local var_43_1 = var_43_0:getTopWeaponControl()
			
			return var_43_1 and var_43_1:getChildByName(arg_43_0)
		else
			return var_43_0:getTopWeaponControl()
		end
	end,
	EQUIP_BELT_SELECT = function(arg_44_0)
		local var_44_0 = var_0_3()
		local var_44_1 = "ef311"
		
		if arg_44_0 then
			local var_44_2 = var_44_0:getEquipItemControl(var_44_1)
			
			return var_44_2 and var_44_2:getChildByName(arg_44_0)
		else
			return (var_44_0:getEquipItemControl(var_44_1))
		end
	end,
	GROWTH_BOOST_LV_NODE = function(arg_45_0)
		return GrowthBoostUI:getTutorialTargetNodeByIdx(arg_45_0)
	end,
	EQUIP_BELT_SELECT_BTN = function(arg_46_0)
		local var_46_0 = var_0_3()
		local var_46_1 = "ef311"
		
		if arg_46_0 then
			local var_46_2 = var_46_0:getEquipItemControl(var_46_1)
			
			return var_46_2 and var_46_2:getChildByName(arg_46_0)
		else
			return var_46_0:getEquipItemControl(var_46_1):getChildByName("btn_select")
		end
	end,
	TOPBAR_INVENTORY_OPEN = function()
		return TopBarNew:getInveontoryBtn()
	end,
	GROWTH_GUIDE_UNIT = function()
		return GrowthGuideBase.quest_ui:getMainUnit()
	end,
	GROWTH_GUIDE_REWARD = function()
		return GrowthGuideBase.quest_ui:getCurrentReward()
	end,
	INVENTORY_FIRST_ITEM = function()
		return Inventory:getListViewFirstItem():getChildByName("btn_select")
	end,
	INVENTORY_FIRST_SELECT_BOX_ITEM = function()
		return Inventory:getListViewFirstSelectBoxItem():getChildByName("btn_select")
	end,
	CLAN_BATTLE_CATEGORY = function(arg_52_0)
		if arg_52_0 == "clan_war" then
			return ClanBattleList.ClanWar:getControl()
		end
	end,
	CLAN_BATTLE_CATEGORY_ITEM = function(arg_53_0)
		if arg_53_0 == "clan_war" then
			return ClanBattleList.ClanWar:getControl():getChildByName("btn")
		end
	end,
	RESULT_GUIDE_BUTTON = function()
		if not ClearResult.vars or not get_cocos_refid(ClearResult.vars.wnd) then
			return 
		end
		
		local var_54_0
		local var_54_1 = ClearResult.vars.wnd:getChildByName("n_lose")
		local var_54_2 = ClearResult:_can_use_failuer_guide()
		
		if get_cocos_refid(var_54_1) and var_54_2 then
			var_54_0 = var_54_1:getChildByName("n_failure_guide"):getChildByName("n_lose_guide")
		else
			local var_54_3 = not GrowthGuide:isEnable()
			
			var_54_0 = var_54_1:getChildByName(var_54_3 and "n_normal" or "n_growth_guide"):getChildByName("n_lose_guide")
		end
		
		return var_54_0
	end,
	FIRST_TRAVEL_COMPLETE = function()
		return SubStoryTravelMap_v2:getFirstReceivableTargetIcon():getChildByName("selected")
	end,
	FIRST_PIECE_BOARD = function()
		return SubstoryPieceBoardList:getFirstScrollItem()
	end,
	FIRST_PIECE_BOARD_SELECT = function()
		return SubstoryPieceBoardList:getFirstScrollItem():getChildByName("btn_select")
	end,
	EXPEDITION_FIND_ROOM = function()
		return CoopMission:getTutorialTargetFindRoom(true)
	end,
	EXPEDITION_FIND_TARGET_EVENT_ROOM = function()
		return CoopMission:getTutorialTargetFindRoom()
	end,
	EXPEDITION_WANTED_FIRST = function()
		return CoopMission:getTutorialWantedFirstItem()
	end,
	EXPEDITION_WANTED_FIRST_TARGET = function()
		return CoopMission:getTutorialWantedFirstItem()
	end,
	ADIN_AWAKE_MISSION_BTN = function()
		return EpisodeAdinUI:getChapterNode(1):getChildByName("btn_quest_open")
	end,
	ADIN_AWAKE_MISSION_CENTER = function()
		return EpisodeAdinUI:getMissionCenterNode()
	end,
	ADIN_AWAKE_CORE_REWARD = function()
		return EpisodeAdinUI:getChapterNode(1):getChildByName("btn_reward")
	end,
	ADIN_AWAKE_MAIN_FOLD_2 = function()
		return EpisodeAdinUI:getChapterNode(2):getChildByName("btn_adin")
	end,
	ADIN_PROCHANGE_BTN = function()
		return EpisodeAdinUI.vars.character_popup:getChildByName("btn_prochange")
	end,
	ZODIAC_MIX_BUTTON = function(arg_67_0)
		local var_67_0 = UnitZodiac:getWindos()
		
		if not get_cocos_refid(var_67_0) then
			return 
		end
		
		local var_67_1
		
		if IS_PUBLISHER_ZLONG then
			var_67_1 = var_67_0:getChildByName("n_item_mix1")
		else
			var_67_1 = var_67_0:getChildByName("n_item_mix2")
		end
		
		if not get_cocos_refid(var_67_1) then
			return 
		end
		
		return var_67_1:getChildByName(arg_67_0)
	end,
	AWAKE_STONE = function(arg_68_0)
		return UnitZodiac:getAwakeStone(to_n(arg_68_0))
	end,
	ATMT_HEAL_ICON = function()
		return BattleReady:getAutomatonHealIcon()
	end,
	HERO_TAP_EQUIP = function()
		UnitDetail:setMode("Equip")
		
		return UnitDetail:getCurModeTab()
	end
}
local var_0_5 = {
	get_soul_1 = function()
		Battle.logic:addTeamRes(FRIEND, "soul_piece", GAME_STATIC_VARIABLE.max_soul_point * 1)
		
		if BattleUI.soul_gauge then
			BattleUI.soul_gauge:updateSoulPiece()
		end
	end,
	get_soul_8 = function()
		Battle.logic:setTeamRes(FRIEND, "soul_piece", GAME_STATIC_VARIABLE.max_soul_point * 8)
		
		if BattleUI.soul_gauge then
			BattleUI.soul_gauge:updateSoulPiece()
		end
	end,
	block_scroll_character_reward = function()
		DestinyCategory:setTouchEnabled(false)
		DestinyAchieveList:setTouchEnabled(false)
	end,
	block_scroll_herobelt = function()
		var_0_2():setScrollEnabled(false)
	end,
	close_msg_box = function()
		Dialog:forced_closeMsgbox()
	end,
	block_scroll_equipbelt = function()
		var_0_3():setTouchEnabled(false)
	end,
	block_scroll_ready = function()
		BattleReadyFriends:setTouchEnabled(false)
		BattleReady:setTouchEnabled(false)
	end,
	block_abyss_scroll = function()
		DungeonHell:getAbyssScrollView():setTouchEnabled(false)
	end,
	block_scroll_subtask = function()
		SubTaskList:setTouchEnabled(false)
	end,
	block_scroll_craft = function()
		SanctuaryCraft:setTouchEnabled(false)
		SanctuaryCraftCategories:setTouchEnabled(false)
	end,
	block_scroll_archemist = function()
		SanctuaryArchemist:setTouchEnabled(false)
		SanctuaryArchemistCategories:setTouchEnabled(false)
	end,
	block_scroll_pvp = function()
		PvpSAVS:setTouchEnabled(false)
		PvpNPC:setTouchEnabled(false)
	end,
	move_scene = function(arg_83_0)
		if SceneManager:getCurrentSceneName() ~= arg_83_0 then
			SceneManager:nextScene(arg_83_0)
		end
	end,
	move_worldmap = function(arg_84_0)
		movetoPath(arg_84_0)
	end,
	field_pause = function()
		BattleLayout:setPause(true)
	end,
	equip_belt_sort_uid = function()
		var_0_3():sortUID()
	end,
	substory_help_output = function()
		TutorialGuide:openSubstoryHelpGuide()
	end,
	focus_worldmap_town = function(arg_88_0)
		WorldMapManager:getController():setCurTown(arg_88_0)
	end,
	view_worldmap_town = function(arg_89_0)
		WorldMapManager:getController():lookEnter(arg_89_0)
	end,
	enter_worldmap_world = function(arg_90_0)
		local var_90_0 = WorldMapManager:getController()
		local var_90_1 = var_90_0.vars.world:getChildByKeyContinent(arg_90_0)
		
		if arg_90_0 and var_90_1 then
			local var_90_2 = var_90_0:getLinkDB().key_continent[arg_90_0]
			
			var_90_0.vars.world:enterContinent(var_90_2.world_id, var_90_1)
		end
	end,
	enter_worldmap_continent = function(arg_91_0)
		local var_91_0 = WorldMapManager:getController()
		local var_91_1 = var_91_0.vars.land:getChildByContinentID(arg_91_0)
		
		if arg_91_0 and var_91_1 then
			var_91_0.vars.land:enterChapter(arg_91_0, var_91_1.key_normal, var_91_1)
		end
	end,
	move_worldmap_focus_town = function(arg_92_0)
		local var_92_0 = string.split(arg_92_0, ",")
		local var_92_1 = var_92_0[1]
		local var_92_2 = var_92_0[2]
		local var_92_3
		
		if SubstoryManager:getInfo() then
			var_92_3 = SubstoryManager:getContentsController()
		else
			var_92_3 = AdvWorldMapController
		end
		
		var_92_3:shortCutTown(var_92_1)
		var_92_3:setCurTown(var_92_2)
	end,
	enter_gacha_select = function()
		if SceneManager:getCurrentSceneName() ~= "gacha_unit" then
			return 
		end
		
		GachaUnit:enterGachaSelect()
	end
}
local var_0_6 = {
	block_scroll_character_reward = function()
		DestinyCategory:setTouchEnabled(true)
		DestinyAchieveList:setTouchEnabled(true)
	end,
	block_scroll_herobelt = function()
		var_0_2():setScrollEnabled(true)
	end,
	block_scroll_equipbelt = function()
		var_0_3():setTouchEnabled(true)
	end,
	block_scroll_ready = function()
		BattleReadyFriends:setTouchEnabled(true)
		BattleReady:setTouchEnabled(true)
	end,
	block_abyss_scroll = function()
		DungeonHell:getAbyssScrollView():setTouchEnabled(true)
	end,
	block_scroll_subtask = function()
		SubTaskList:setTouchEnabled(true)
	end,
	block_scroll_craft = function()
		SanctuaryCraft:setTouchEnabled(true)
		SanctuaryCraftCategories:setTouchEnabled(true)
	end,
	block_scroll_archemist = function()
		SanctuaryArchemist:setTouchEnabled(true)
		SanctuaryArchemistCategories:setTouchEnabled(true)
	end,
	block_scroll_pvp = function()
		PvpSAVS:setTouchEnabled(true)
		PvpNPC:setTouchEnabled(true)
	end,
	field_pause = function()
		BattleLayout:setPause(false)
	end
}
local var_0_7 = {
	enter_old_lobby = function()
		if SAVE:getKeep("custom_lobby.mode", "default") ~= "default" then
			CustomLobby:setAsDefaultLobby()
			SceneManager:reload()
		end
	end
}
local var_0_8 = {
	first_dungeon = function()
		return DungeonWeekly:getFirstDungeonControl()
	end,
	hunt_dungeon = function()
		return DungeonList:getBattleModeControl("Hunt")
	end,
	hell_dungeon = function()
		return DungeonList:getBattleModeControl("Hell")
	end,
	raid_dungeon = function()
		return DungeonList:getBattleModeControl("Raid")
	end,
	pvp_dungeon = function()
		return DungeonList:getBattleModeControl("PvP")
	end,
	maze_dungeon = function()
		return DungeonList:getBattleModeControl("Maze")
	end,
	check_sinsu = function()
		return SummonUI:isShow()
	end,
	check_sell_unit = function()
		return UnitMain:getMode() == "Sell"
	end,
	maze_dir = function()
		return BattleMapManager:getTutorialObject()
	end,
	proc_story = function()
		local var_114_0 = var_0_2()
		
		if not var_114_0:getCurrentItem():check_relationUI() then
			for iter_114_0, iter_114_1 in pairs(var_114_0:getItems()) do
				if iter_114_1:check_relationUI() then
					var_114_0:scrollToUnit(iter_114_1)
					
					break
				end
			end
		end
	end,
	skip_sanc_forest = function()
		return (((AccountData.sanc_lv or {})[2] or {})[2] or 0) >= 3
	end
}
local var_0_9 = {
	if_scene = function(arg_116_0)
		if arg_116_0 == SceneManager:getCurrentSceneName() then
			return true
		end
	end
}

function TutorialGuide.resetGuideData(arg_117_0)
	arg_117_0.Guides = nil
end

function TutorialGuide.makeGuideData(arg_118_0)
	local function var_118_0(arg_119_0)
		if not arg_119_0 then
			return ""
		end
		
		if DB("text", arg_119_0, "text") then
			return T(arg_119_0)
		end
		
		if string.find(arg_119_0, ",") then
			return arg_119_0
		end
		
		return ""
	end
	
	local var_118_1 = {}
	
	for iter_118_0 = 1, 9999 do
		local var_118_2 = {}
		
		var_118_2.id, var_118_2.type, var_118_2.scene, var_118_2.target, var_118_2.target_event, var_118_2.target_touch, var_118_2.target_arrow, var_118_2.arrow_scale, var_118_2.arrow_offset, var_118_2.arrow_rotation, var_118_2.target_effect, var_118_2.effect_scale, var_118_2.effect_offset, var_118_2.effect_loop, var_118_2.delay, var_118_2.touch_delay, var_118_2.dim, var_118_2.dim_offset, var_118_2.npc_icon, var_118_2.npc_name, var_118_2.message, var_118_2.talkbox_l, var_118_2.eff, var_118_2.sound, var_118_2.active_time, var_118_2.talk_image, var_118_2.s_title, var_118_2.s_image, var_118_2.s_text, var_118_2.item_id, var_118_2.item_value, var_118_2.item_title, var_118_2.item_text, var_118_2.skip_btn, var_118_2.mode, var_118_2.proc, var_118_2.func, var_118_2.skip_if, var_118_2.story_id = DBN("tutorial_guide", iter_118_0, {
			"id",
			"type",
			"scene",
			"target",
			"target_event",
			"target_touch",
			"target_arrow",
			"arrow_scale",
			"arrow_offset",
			"arrow_rotation",
			"target_effect",
			"effect_scale",
			"effect_offset",
			"effect_loop",
			"delay",
			"touch_delay",
			"dim",
			"dim_offset",
			"npc_icon",
			"npc_name",
			"message",
			"talkbox_l",
			"eff",
			"sound",
			"active_time",
			"talk_image",
			"s_title",
			"s_image",
			"s_text",
			"item_id",
			"item_value",
			"item_title",
			"item_text",
			"skip_btn",
			"mode",
			"proc",
			"func",
			"skip_if",
			"story_id"
		})
		var_118_2.npc_name = var_118_0(var_118_2.npc_name)
		var_118_2.message = var_118_0(var_118_2.message)
		var_118_2.s_title = var_118_0(var_118_2.s_title)
		var_118_2.s_text = var_118_0(var_118_2.s_text)
		var_118_2.item_title = var_118_0(var_118_2.item_title)
		var_118_2.item_text = var_118_0(var_118_2.item_text)
		
		if not var_118_2.id then
			break
		end
		
		local var_118_3 = string.sub(var_118_2.id, 1, -4)
		
		if tonumber(string.sub(var_118_2.id, -2, -1)) == 1 then
			var_118_1[var_118_3] = {}
		end
		
		if var_118_2.target and string.starts(var_118_2.target, "*") then
			local var_118_4 = string.sub(var_118_2.target, 2, -1)
			local var_118_5 = string.split(var_118_4, "(")
			
			var_118_2.target = var_0_4[var_118_5[1]]
			var_118_2.target_func_name = var_118_5[1]
			
			if var_118_5[2] then
				var_118_2.target_params = string.split(string.sub(var_118_5[2], 1, -2), ",")
			end
		end
		
		if var_118_2.target_event and string.starts(var_118_2.target_event, "*") then
			local var_118_6 = string.sub(var_118_2.target_event, 2, -1)
			local var_118_7 = string.split(var_118_6, "(")
			
			var_118_2.target_event = var_0_4[var_118_7[1]]
			
			if var_118_7[2] then
				var_118_2.target_event_params = string.split(string.sub(var_118_7[2], 1, -2), ",")
			end
		end
		
		if var_118_2.proc and string.starts(var_118_2.proc, "*") then
			local var_118_8 = string.sub(var_118_2.proc, 2, -1)
			local var_118_9 = string.split(var_118_8, "(")
			
			var_118_2.proc = var_0_5[var_118_9[1]]
			var_118_2.de_proc = var_0_6[var_118_9[1]]
			var_118_2.after_release_de_proc = var_0_7[var_118_9[1]]
			
			if var_118_9[2] then
				var_118_2.proc_param = string.sub(var_118_9[2], 1, -2)
			end
		end
		
		if var_118_2.mode and string.starts(var_118_2.mode, "*") then
			var_118_2.mode = var_0_8[string.sub(var_118_2.mode, 2, -1)]
		end
		
		if var_118_2.skip_if and string.starts(var_118_2.skip_if, "*") then
			local var_118_10 = string.sub(var_118_2.skip_if, 2, -1)
			local var_118_11 = string.split(var_118_10, "(")
			
			var_118_2.skip_if = var_0_9[var_118_11[1]]
			
			if var_118_11[2] then
				var_118_2.skip_if_param = string.sub(var_118_11[2], 1, -2)
			end
		end
		
		if var_118_1[var_118_3] then
			table.push(var_118_1[var_118_3], var_118_2)
		else
			Log.e("tutorial", "error invalid starting id .. please xxxx_01 " .. var_118_2.id)
			error("error invalid starting id .. please xxxx_01 ")
		end
	end
	
	return var_118_1
end

function TutorialGuide.makeCustomData(arg_120_0)
	local var_120_0 = {}
	
	for iter_120_0 = 1, 9999 do
		local var_120_1 = {}
		
		var_120_1.id, var_120_1.first_enter_type, var_120_1.first_enter_value, var_120_1.req_stage_clear, var_120_1.req_subachive_clear = DBN("tutorial_custom", iter_120_0, {
			"id",
			"first_enter_type",
			"first_enter_value",
			"req_stage_clear",
			"req_subachive_clear"
		})
		
		if not var_120_1.id then
			break
		end
		
		if not var_120_0[var_120_1.first_enter_type] then
			var_120_0[var_120_1.first_enter_type] = {}
		end
		
		if not var_120_0[var_120_1.first_enter_type][var_120_1.first_enter_value] then
			var_120_0[var_120_1.first_enter_type][var_120_1.first_enter_value] = {}
		end
		
		if var_120_1.req_stage_clear then
			var_120_1.req_stage_clear = string.split(var_120_1.req_stage_clear, ";")
		end
		
		if var_120_1.req_subachive_clear then
			var_120_1.req_subachive_clear = string.split(var_120_1.req_subachive_clear, ";")
		end
		
		table.insert(var_120_0[var_120_1.first_enter_type][var_120_1.first_enter_value], var_120_1)
	end
	
	return var_120_0
end

function TutorialGuide.startCustomTutorial(arg_121_0, arg_121_1, arg_121_2)
	if not arg_121_0.custom_tutorial then
		arg_121_0.custom_tutorial = arg_121_0:makeCustomData() or {}
	end
	
	local var_121_0 = arg_121_0.custom_tutorial[arg_121_1] and arg_121_0.custom_tutorial[arg_121_1][arg_121_2]
	
	if not var_121_0 then
		return 
	end
	
	for iter_121_0, iter_121_1 in pairs(var_121_0) do
		if arg_121_0:checkCustomCondition(iter_121_1) and arg_121_0:_startGuideFromCallback(iter_121_1.id) then
			return true
		end
	end
end

function TutorialGuide.checkCustomCondition(arg_122_0, arg_122_1)
	if not arg_122_1 then
		return false
	end
	
	local var_122_0 = arg_122_1.req_stage_clear or {}
	local var_122_1 = arg_122_1.req_subachive_clear or {}
	
	for iter_122_0, iter_122_1 in ipairs(var_122_0) do
		if not Account:isMapCleared(iter_122_1) then
			return false
		end
	end
	
	for iter_122_2, iter_122_3 in ipairs(var_122_1) do
		if not Account:isClearedSubStoryAchievement(iter_122_3) then
			return false
		end
	end
	
	return true
end

function TutorialGuide.onAddRewardCallback(arg_123_0, arg_123_1)
	if arg_123_1 == "system_059" and not GrowthGuide:isClearedTutorial() then
		SceneManager:nextScene("lobby")
	end
	
	if arg_123_1 == "growth_boost" and GrowthBoostUI:isValid() then
		GrowthBoost:checkGrowthLevelup()
		
		return 
	end
end

function TutorialGuide.ifStartGuide(arg_124_0, arg_124_1, arg_124_2)
	if not arg_124_2 and not TutorialCondition:isEnable(arg_124_1) then
		return false
	end
	
	return arg_124_0:startGuide(arg_124_1, arg_124_2)
end

function TutorialGuide.startGuide(arg_125_0, arg_125_1, arg_125_2, arg_125_3)
	if not arg_125_1 then
		return 
	end
	
	if not arg_125_0.Guides then
		arg_125_0.Guides = arg_125_0:makeGuideData()
	end
	
	if arg_125_0:isPlayingTutorial() then
		return 
	end
	
	arg_125_3 = arg_125_3 or {}
	arg_125_2 = arg_125_2 or TEST_TUTORIAL
	
	if not string.starts(arg_125_1, "intro_") and SAVE:getTutorialGuide(arg_125_1) and not arg_125_2 then
		return 
	end
	
	if DEBUG.SKIP_TUTO then
		return 
	end
	
	local var_125_0 = 1
	
	if type(arg_125_2) == "number" then
		var_125_0 = arg_125_2
	end
	
	local var_125_1 = getChildByPath(SceneManager:getRunningPopupScene(), "msgbox/window_frame/n_rewards/text")
	
	if get_cocos_refid(var_125_1) and var_125_1:getString() == T("tutorial_reward_desc") then
		return 
	end
	
	arg_125_0.vars = {}
	
	if arg_125_0.Guides[arg_125_1] then
		if not arg_125_0.Guides[arg_125_1][var_125_0] then
			return 
		end
		
		local var_125_2 = string.split(arg_125_0.Guides[arg_125_1][var_125_0].scene, ",")
		
		if arg_125_0.Guides[arg_125_1][var_125_0].scene ~= "*" and not arg_125_0:checkScene(var_125_2) then
			return 
		end
	else
		return 
	end
	
	arg_125_0.vars.started_guide = arg_125_0.Guides[arg_125_1]
	arg_125_0.vars.started_guide_id = arg_125_1
	arg_125_0.vars.cur_guide_idx = var_125_0
	arg_125_0.vars.force_front = arg_125_3.force_front
	
	if not arg_125_0.vars.started_guide or not arg_125_0.vars.started_guide[var_125_0] then
		arg_125_0.vars = {}
		
		return 
	end
	
	print("TutorialGuide.startGuide : " .. arg_125_1)
	Singular:tutorialStartEvent(arg_125_1)
	arg_125_0:stop_repeatBattle()
	TutorialGuide:closeMiniMap()
	LuaEventDispatcher:dispatchEvent("invite.event", "hide")
	arg_125_0:procGuide()
	
	return true
end

local function var_0_10()
	for iter_126_0, iter_126_1 in pairs(Account.equips) do
		if iter_126_1.exp ~= 0 then
			return true
		end
	end
	
	return false
end

local function var_0_11()
	return Account:getItemCount("ma_est2w") ~= 0
end

local function var_0_12()
	for iter_128_0, iter_128_1 in pairs(Account:getUnits()) do
		for iter_128_2, iter_128_3 in pairs(iter_128_1.equips) do
			if iter_128_3.db.type == "weapon" then
				return true
			end
		end
	end
	
	return false
end

local function var_0_13()
	for iter_129_0, iter_129_1 in pairs(Account:getUnits()) do
		for iter_129_2, iter_129_3 in pairs(iter_129_1.equips) do
			if iter_129_3.db.type == "weapon" or iter_129_3.db.type == "armor" or iter_129_3.db.type == "neck" or iter_129_3.db.type == "helm" or iter_129_3.db.type == "boot" or iter_129_3.db.type == "ring" then
				return true
			end
		end
	end
	
	return false
end

local function var_0_14()
	for iter_130_0, iter_130_1 in pairs(Account.equips) do
		if iter_130_1.db.type == "weapon" then
			return true
		end
	end
	
	return false
end

function TutorialGuide.startEquipInstallGuide(arg_131_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.TUTORIAL_EQUIP) then
		return 
	end
	
	if TutorialGuide:isClearedTutorial("equip_install") then
		return 
	end
	
	if var_0_14() and not var_0_10() and not var_0_13() and var_0_11() then
		TutorialGuide:startGuide("equip_install")
	end
end

function TutorialGuide.startEquipGuide(arg_132_0)
	arg_132_0:startEquipInstallGuide()
end

function TutorialGuide.stop_repeatBattle(arg_133_0)
	if SceneManager:getCurrentSceneName() == "battle" and BattleRepeat:isPlayingRepeatPlay() then
		BattleRepeat:stop_repeatPlay()
	end
end

function TutorialGuide.skipGuide(arg_134_0, arg_134_1)
	TutorialGuide:clearGuide()
	TutorialGuide:onFinishTutorial(arg_134_0.vars.cur_guide, arg_134_1)
	
	arg_134_0.vars = {}
end

function TutorialGuide.checkFinish(arg_135_0)
	if arg_135_0.vars.started_guide and not arg_135_0.vars.started_guide[arg_135_0.vars.cur_guide_idx] then
		return true
	else
		return false
	end
end

function TutorialGuide.getCurrentGuideType(arg_136_0)
	if arg_136_0.vars.cur_guide then
		return arg_136_0.vars.cur_guide.type
	end
end

function TutorialGuide.onFinishTutorial(arg_137_0, arg_137_1, arg_137_2)
	if arg_137_0.vars then
		TutorialNotice:detachTutorialIndicators(arg_137_0.vars.started_guide_id)
	end
	
	if arg_137_0.vars.on_finish_func then
		arg_137_0.vars.on_finish_func()
	end
	
	print("onFinishTutorialGuide : " .. tostring(arg_137_0.vars.started_guide_id), type(arg_137_1))
	
	if arg_137_0.vars.started_guide_id and arg_137_1 and not string.starts(arg_137_0.vars.started_guide_id, "intro_") then
		arg_137_0:saveTutorial(arg_137_1, arg_137_2)
	end
	
	UIAction:Add(SEQ(DELAY(500), CALL(function()
		LuaEventDispatcher:dispatchEvent("invite.event", "reload")
	end)), arg_137_0, "invite.event.delay")
	
	local var_137_0 = arg_137_0.vars.started_guide and arg_137_0.vars.started_guide[arg_137_0.vars.cur_guide_idx] ~= nil
	local var_137_1 = arg_137_0.vars.started_guide_id
	
	arg_137_0.vars = {}
	
	if var_137_1 == "memorization" then
		UnitUpgrade:setTouchEnabledSliderBtn(true)
	end
	
	if var_137_0 and (var_137_1 == "system_059" or var_137_1 == "c3026_destiny") then
		SceneManager:nextScene("lobby")
	end
end

local function var_0_15(arg_139_0)
	if not get_cocos_refid(arg_139_0) then
		return nil
	end
	
	local var_139_0 = arg_139_0:getParent()
	
	if not get_cocos_refid(var_139_0) then
		return nil
	end
	
	if tolua.type(var_139_0) == "ccui.ScrollView" then
		return var_139_0
	end
	
	return var_0_15(var_139_0)
end

function TutorialGuide._lockScrollView(arg_140_0, arg_140_1)
	if not get_cocos_refid(arg_140_1) then
		return 
	end
	
	local var_140_0 = var_0_15(arg_140_1)
	
	if not var_140_0 then
		return 
	end
	
	if not get_cocos_refid(var_140_0) then
		return 
	end
	
	if not var_140_0:isTouchEnabled() then
		return 
	end
	
	var_140_0:setTouchEnabled(false)
	arg_140_0:_unlockScrollView()
	
	arg_140_0.vars.locked_scroll_view = var_140_0
end

function TutorialGuide._unlockScrollView(arg_141_0)
	if not get_cocos_refid(arg_141_0.vars.locked_scroll_view) then
		return 
	end
	
	arg_141_0.vars.locked_scroll_view:setTouchEnabled(true)
	
	arg_141_0.vars.locked_scroll_view = nil
end

function TutorialGuide.procGuide(arg_142_0, arg_142_1, arg_142_2)
	if not arg_142_0.vars.started_guide then
		return 
	end
	
	if arg_142_1 and arg_142_1 ~= arg_142_0.vars.started_guide_id then
		return 
	end
	
	if arg_142_1 == nil and arg_142_2 and table.find(arg_142_2, arg_142_0.vars.started_guide_id) then
		return 
	end
	
	print("procGuide : ", arg_142_0.vars.started_guide_id, arg_142_0.vars.started_guide[arg_142_0.vars.cur_guide_idx] and arg_142_0.vars.started_guide[arg_142_0.vars.cur_guide_idx].id)
	arg_142_0:clearGuide()
	
	if arg_142_0:checkFinish() then
		arg_142_0:onFinishTutorial(arg_142_0.vars.cur_guide)
		
		return 
	end
	
	local var_142_0 = arg_142_0.vars.started_guide[arg_142_0.vars.cur_guide_idx]
	
	if not var_142_0 then
		arg_142_0:onFinishTutorial(arg_142_0.vars.cur_guide)
		
		return 
	end
	
	if var_142_0.skip_if and (type(var_142_0.skip_if) == "function" and var_142_0.skip_if(var_142_0.skip_if_param) or var_142_0.skip_if == true) then
		arg_142_0.vars.cur_guide_idx = arg_142_0.vars.cur_guide_idx + 1
		
		arg_142_0:procGuide()
		
		return 
	end
	
	local var_142_1 = string.split(var_142_0.scene, ",")
	
	if var_142_0.scene ~= "*" and not arg_142_0:checkScene(var_142_1) then
		return 
	end
	
	if var_142_0.mode and type(var_142_0.mode) == "function" and not var_142_0.mode() then
		return 
	end
	
	if var_142_0.func then
		loadstring(var_142_0.func)()
	end
	
	if var_142_0.proc and type(var_142_0.proc) == "function" then
		var_142_0.proc(var_142_0.proc_param)
	end
	
	arg_142_0.guide_info = {}
	
	local function var_142_2(arg_143_0, arg_143_1)
	end
	
	if var_142_0.type == "talkbox" then
		arg_142_0.guide_info.wnd = load_dlg("guide_talk", true, "wnd")
		var_142_2 = arg_142_0.setGuide_talkbox
	elseif var_142_0.type == "summary" then
		arg_142_0.guide_info.wnd = load_dlg("guide_summary", true, "wnd")
		var_142_2 = arg_142_0.setGuide_summary
	elseif var_142_0.type == "summary_large" then
		arg_142_0.guide_info.wnd = load_dlg("guide_summary", true, "wnd")
		var_142_2 = arg_142_0.setGuide_summary_large
	elseif var_142_0.type == "mark" then
		arg_142_0.guide_info.wnd = load_dlg("guide_talk", true, "wnd")
		var_142_2 = arg_142_0.setGuide_mark
	elseif var_142_0.type == "select" then
		arg_142_0.guide_info.wnd = load_dlg("guide_select", true, "wnd")
		var_142_2 = arg_142_0.setGuide_select
	elseif var_142_0.type == "block" then
		arg_142_0.guide_info.wnd = load_dlg("guide_block", true, "wnd")
		var_142_2 = arg_142_0.setGuide_block
	elseif var_142_0.type == "story" then
		arg_142_0.guide_info.wnd = cc.Layer:create()
		var_142_2 = arg_142_0.setGuide_story
	else
		Log.e("Tutorial undefined type : " .. tostring(var_142_0.id) .. tostring(var_142_0.type))
		
		arg_142_0.guide_info.error = true
	end
	
	if arg_142_0.guide_info.error then
		arg_142_0:clearGuide()
		
		arg_142_0.vars = {}
		
		return 
	end
	
	set_high_fps_tick(1000)
	
	if arg_142_0.guide_info.wnd then
		SceneManager:getRunningPopupScene():addChild(arg_142_0.guide_info.wnd)
		arg_142_0.guide_info.wnd:setLocalZOrder(1000000001)
		
		if var_142_0.delay or var_142_0.touch_delay then
			if var_142_0.delay then
				arg_142_0.guide_info.wnd:setVisible(false)
				UIAction:Add(SEQ(DELAY(var_142_0.delay or 0), CALL(function()
					var_142_2(arg_142_0, var_142_0)
					arg_142_0.guide_info.wnd:bringToFront()
				end), SHOW(true), DELAY(var_142_0.touch_delay or 0)), arg_142_0.guide_info.wnd, "block")
			else
				arg_142_0.guide_info.wnd:setVisible(true)
				var_142_2(arg_142_0, var_142_0)
				UIAction:Add(SEQ(DELAY(var_142_0.touch_delay or 0)), arg_142_0.guide_info.wnd, "block")
			end
		else
			var_142_2(arg_142_0, var_142_0)
		end
	else
		var_142_2(arg_142_0, var_142_0)
	end
	
	if var_142_0.skip_btn ~= "y" then
		arg_142_0:_updateSkipButton(3000)
	end
	
	local var_142_3 = var_142_0.talk_image
	
	arg_142_0.vars.cur_guide = var_142_0
	arg_142_0.vars.cur_guide_idx = arg_142_0.vars.cur_guide_idx + 1
	
	if arg_142_0.vars.started_guide[arg_142_0.vars.cur_guide_idx] then
		arg_142_0.vars.started_guide[arg_142_0.vars.cur_guide_idx].prev_talk_image = var_142_3
	end
	
	if arg_142_0.vars.force_front then
		arg_142_0.guide_info.wnd:bringToFront()
	end
	
	return true
end

function TutorialGuide._turnOnSkipButton(arg_145_0)
	TutorialGuide:_updateSkipButton(0)
end

function TutorialGuide._updateSkipButton(arg_146_0, arg_146_1)
	arg_146_1 = arg_146_1 or 3000
	
	local var_146_0 = var_0_1(arg_146_0.guide_info.wnd, "n_reward", 1)
	
	if get_cocos_refid(var_146_0) then
		UIAction:Add(SEQ(DELAY(arg_146_1), SHOW(false)), var_146_0)
	end
	
	local var_146_1 = arg_146_0.guide_info.wnd:getChildByName("btn_guide_skip")
	
	if not get_cocos_refid(var_146_1) then
		return 
	end
	
	local var_146_2 = var_146_1:getChildByName("btn_guide_skip")
	
	if not get_cocos_refid(var_146_2) then
		return 
	end
	
	local var_146_3 = var_146_2:getContentSize()
	
	EffectManager:Play({
		fn = "ui_tuto_skip_fx.cfx",
		layer = var_146_1,
		x = -(var_146_3.width * 0.5) - 5,
		y = -(var_146_3.height * 0.5) - 5
	})
	UIAction:Add(SEQ(DELAY(arg_146_1), SHOW(true)), var_146_1)
end

function TutorialGuide._updateTargetPosition(arg_147_0)
	if not arg_147_0.guide_info then
		return 
	end
	
	if not arg_147_0.guide_info.target_control or not get_cocos_refid(arg_147_0.guide_info.target_control) then
		return 
	end
	
	local var_147_0 = arg_147_0.guide_info.wnd:getChildByName("n_tap")
	local var_147_1 = arg_147_0.guide_info.target_control:getContentSize()
	local var_147_2 = calcWorldScaleX(arg_147_0.guide_info.target_control)
	local var_147_3 = calcWorldScaleY(arg_147_0.guide_info.target_control)
	
	local function var_147_4()
		local var_148_0 = arg_147_0.guide_info.clone_target:getAnchorPoint()
		
		arg_147_0.guide_info.clone_target:setPosition((var_148_0.x - 0.5) * var_147_1.width * var_147_2, (var_148_0.y - 0.5) * var_147_1.height * var_147_3)
	end
	
	local var_147_5 = SceneManager:convertToSceneSpace(arg_147_0.guide_info.target_control, {
		x = 0.5 * var_147_1.width,
		y = 0.5 * var_147_1.height
	})
	local var_147_6, var_147_7 = var_147_0:getPosition()
	
	if var_147_5.x ~= var_147_6 or var_147_5.y ~= var_147_7 then
		var_147_0:setPosition(var_147_5.x, var_147_5.y)
	end
	
	if arg_147_0.guide_info.clone_target then
		if arg_147_0.guide_info.clone_target:isVisible() ~= arg_147_0.guide_info.target_control:isVisible() then
			arg_147_0.guide_info.clone_target:setVisible(arg_147_0.guide_info.target_control:isVisible())
		end
		
		if arg_147_0.guide_info.clone_target:getOpacity() ~= arg_147_0.guide_info.target_control:getOpacity() then
			arg_147_0.guide_info.clone_target:setOpacity(arg_147_0.guide_info.target_control:getOpacity())
		end
		
		if arg_147_0.guide_info.clone_target:getScaleX() ~= var_147_2 then
			arg_147_0.guide_info.clone_target:setScaleX(var_147_2)
			var_147_4()
		end
		
		if arg_147_0.guide_info.clone_target:getScaleY() ~= var_147_3 then
			arg_147_0.guide_info.clone_target:setScaleY(var_147_3)
			var_147_4()
		end
	end
end

local function var_0_16(arg_149_0, arg_149_1, arg_149_2)
	local var_149_0 = SceneManager:getRunningRootScene()
	local var_149_1 = arg_149_2.wnd:getChildByName("n_tap")
	
	local function var_149_2(arg_150_0, arg_150_1, arg_150_2)
		arg_150_1:setVisible(true)
		arg_150_1:setOpacity(0)
		UIAction:Add(SEQ(LOG(FADE_IN(100))), arg_150_1, "block")
		arg_150_1:setPosition(0, 0)
		
		local var_150_0 = arg_150_1:getChildByName("n_arrow")
		
		if arg_149_1.target_arrow == "y" then
			local var_150_1 = arg_149_1.arrow_scale or 1
			local var_150_2 = 0
			local var_150_3 = 0
			
			if arg_149_1.arrow_offset then
				local var_150_4 = string.split(arg_149_1.arrow_offset, ",")
				
				var_150_2 = tonumber(var_150_4[1] or 0)
				var_150_3 = tonumber(var_150_4[2] or 0)
			end
			
			if arg_149_1.arrow_rotation then
				var_150_0:setRotation(tonumber(arg_149_1.arrow_rotation))
				
				if arg_149_1.arrow_rotation < 0 then
					var_150_0:getChildByName("game_hud_arrow"):setScaleX(-1)
				end
			end
			
			local var_150_5 = var_150_0:getChildByName("game_hud_arrow")
			
			var_150_5:setOpacity(0)
			UIAction:Add(SEQ(FADE_IN(100), LOOP(SEQ(LOG(MOVE_TO(500, 0, 240)), RLOG(MOVE_TO(500, 0, 150))))), var_150_5)
			var_150_0:setPosition(var_150_2, var_150_3)
			var_150_0:setScale(var_150_1)
			var_150_0:setVisible(true)
		else
			var_150_0:setVisible(false)
		end
		
		if arg_149_1.target_effect == "y" then
			local var_150_6 = 1
			local var_150_7 = 1
			local var_150_8 = 0
			local var_150_9 = 0
			
			if arg_149_1.effect_scale then
				local var_150_10 = string.split(arg_149_1.effect_scale, ",")
				
				var_150_6 = tonumber(var_150_10[1] or 0)
				var_150_7 = tonumber(var_150_10[2] or 0)
			end
			
			if arg_149_1.effect_offset then
				local var_150_11 = string.split(arg_149_1.effect_offset, ",")
				
				var_150_8 = tonumber(var_150_11[1] or 0)
				var_150_9 = tonumber(var_150_11[2] or 0)
			end
			
			if arg_149_1.effect_loop == "y" then
				set_high_fps_tick(4000)
				EffectManager:Play({
					fn = "ui_tuto_hilight_loop.cfx",
					delay = 500,
					pivot_z = 0,
					layer = arg_149_2.wnd:getChildByName("n_effect_pos"),
					pivot_x = var_150_8,
					pivot_y = var_150_9,
					scaleX = var_150_6,
					scaleY = var_150_7
				})
			else
				set_high_fps_tick(15000)
				EffectManager:Play({
					fn = "ui_tuto_hilight_normal.cfx",
					delay = 500,
					pivot_z = 0,
					layer = arg_149_2.wnd:getChildByName("n_effect_pos"),
					pivot_x = var_150_8,
					pivot_y = var_150_9,
					scaleX = var_150_6,
					scaleY = var_150_7
				})
			end
		end
		
		arg_149_2.clone_target = arg_150_2:clone()
		
		local var_150_12 = {}
		
		if not table.empty(arg_150_2:getChildren()) then
			for iter_150_0, iter_150_1 in pairs(arg_150_2:getChildren()) do
				if tolua.type(iter_150_1) == "ccui.RichText" then
					var_150_12[iter_150_0] = cloneRichLabel(iter_150_1)
				end
			end
		end
		
		if not table.empty(var_150_12) then
			for iter_150_2, iter_150_3 in pairs(arg_149_2.clone_target:getChildren()) do
				if tolua.type(iter_150_3) == "ccui.Widget" and var_150_12[iter_150_2] then
					local var_150_13 = iter_150_3:getParent()
					
					if get_cocos_refid(var_150_13) then
						local var_150_14, var_150_15 = iter_150_3:getPosition()
						
						iter_150_3:removeFromParent()
						var_150_13:addChild(var_150_12[iter_150_2])
						var_150_12[iter_150_2]:setPosition(var_150_14, var_150_15)
					end
				end
			end
		end
		
		local function var_150_16(arg_151_0)
			if arg_151_0.setTouchEnabled then
				arg_151_0:setTouchEnabled(false)
			end
		end
		
		enumerateNodeRecursive(arg_149_2.clone_target, var_150_16)
		
		local var_150_17 = arg_149_2.clone_target:getAnchorPoint()
		local var_150_18 = arg_149_2.clone_target:getContentSize()
		local var_150_19, var_150_20 = arg_149_2.clone_target:getPosition()
		
		arg_149_2.clone_target:setPosition((var_150_17.x - 0.5) * var_150_18.width, (var_150_17.y - 0.5) * var_150_18.height)
		arg_149_2.wnd:getChildByName("n_target_control"):addChild(arg_149_2.clone_target)
		
		arg_149_2.target_control = arg_150_2
		
		arg_150_0:_updateTargetPosition()
	end
	
	local function var_149_3(arg_152_0, arg_152_1)
		local var_152_0
		
		if arg_152_1 == "unit_top" then
			var_152_0 = TopBarNew.vars and TopBarNew.vars.top_left
		end
		
		var_152_0 = var_152_0 or arg_152_0:getChildByName(arg_152_1)
		
		return var_152_0
	end
	
	if arg_149_1.target then
		local var_149_4
		
		if type(arg_149_1.target) == "function" then
			var_149_4 = arg_149_1.target(arg_149_1.target_params and arg_149_1.target_params[1], arg_149_1.target_params and arg_149_1.target_params[2])
		else
			local var_149_5 = var_149_0
			local var_149_6 = arg_149_1.target
			local var_149_7 = string.split(arg_149_1.target, ".")
			
			if var_149_7[3] then
				var_149_5 = var_149_3(var_149_0, var_149_7[1])
				
				if var_149_5 then
					var_149_5 = var_149_3(var_149_5, var_149_7[2])
					var_149_6 = var_149_7[3]
				else
					Log.e("TutorialGuide. can not found target parent : " .. arg_149_1.id .. " - " .. var_149_7[1])
					
					arg_149_2.error = true
				end
			elseif var_149_7[2] then
				var_149_5 = var_149_3(var_149_5, var_149_7[1])
				var_149_6 = var_149_7[2]
			end
			
			if not var_149_5 then
				Log.e("TutorialGuide. can not found target parent : " .. arg_149_1.id .. " - " .. arg_149_1.target)
				
				arg_149_2.error = true
			else
				var_149_4 = var_149_5:getChildByName(var_149_6)
			end
			
			if not var_149_4 then
				Log.e("TutorialGuide. can not found target : " .. arg_149_1.id .. " - " .. arg_149_1.target)
				
				arg_149_2.error = true
			end
		end
		
		if get_cocos_refid(var_149_4) then
			var_149_2(arg_149_0, var_149_1, var_149_4)
			
			if arg_149_1.target_event then
				if type(arg_149_1.target_event) == "function" then
					arg_149_2.target_event_control = arg_149_1.target_event(arg_149_1.target_event_params and arg_149_1.target_event_params[1], arg_149_1.target_event_params and arg_149_1.target_event_params[2])
				else
					local var_149_8 = var_149_0
					local var_149_9 = arg_149_1.target_event
					local var_149_10 = string.split(arg_149_1.target_event, ".")
					
					if var_149_10[3] then
						var_149_8 = var_149_3(var_149_0, var_149_10[1])
						
						if var_149_8 then
							var_149_8 = var_149_3(var_149_8, var_149_10[2])
							var_149_9 = var_149_10[3]
						else
							Log.e("TutorialGuide. can not found target parent : " .. arg_149_1.id .. " - " .. var_149_10[1])
							
							arg_149_2.error = true
						end
					elseif var_149_10[2] then
						var_149_8 = var_149_3(var_149_0, var_149_10[1])
						var_149_9 = var_149_10[2]
					end
					
					if not var_149_8 then
						Log.e("TutorialGuide. can not found target Event parent : " .. arg_149_1.id .. " - " .. arg_149_1.target_event)
					else
						arg_149_2.target_event_control = var_149_8:getChildByName(var_149_9)
					end
					
					if not arg_149_2.target_event_control then
						Log.e("TutorialGuide. can not found target Event: " .. arg_149_1.id .. " - " .. arg_149_1.target)
						
						arg_149_2.error = true
					end
				end
			else
				arg_149_2.target_event_control = var_149_4
			end
		else
			Log.e("Error TutorialGuide. target ui control is not exist : " .. arg_149_1.id .. " - " .. tostring(arg_149_1.target))
			arg_149_0:_turnOnSkipButton()
			
			arg_149_2.error = true
		end
		
		arg_149_0:_lockScrollView(arg_149_2.target_event_control)
		
		arg_149_2.target_touch = arg_149_1.target_touch == "y"
		
		if_set_visible(arg_149_2.wnd, "btn_guide_bg", not arg_149_2.target_touch)
	else
		var_149_1:setVisible(false)
	end
end

local function var_0_17(arg_153_0, arg_153_1)
	local var_153_0 = arg_153_1.wnd:getChildByName("n_talk")
	
	if arg_153_0.npc_icon then
		var_153_0:setVisible(true)
		var_153_0:setOpacity(0)
		SpriteCache:resetSprite(var_153_0:getChildByName("talk_face"), "face/" .. arg_153_0.npc_icon .. ".png")
		if_set(var_153_0, "talk_name", arg_153_0.npc_name)
		
		local var_153_1 = var_153_0:getChildByName("txt_disc")
		local var_153_2 = var_153_1:getContentSize()
		
		if_set(var_153_0, "txt_disc", string.gsub(arg_153_0.message, "%\\n", "\n"))
		
		local var_153_3 = var_153_1:getContentSize()
		
		if getUserLanguage() ~= "ja" or not string.find(arg_153_0.message, "\n") then
			local var_153_4 = VIEW_WIDTH * 0.78
			local var_153_5 = 100
			
			if var_153_4 < var_153_3.width then
				local var_153_6 = var_153_1:getLineHeight()
				local var_153_7 = math.ceil(var_153_3.width / var_153_4)
				local var_153_8 = var_153_3.width / var_153_7 + var_153_5
				
				var_153_1:setTextAreaSize({
					width = var_153_8,
					height = var_153_6 * var_153_7
				})
				var_153_1:setTextAreaSize({
					width = var_153_8,
					height = var_153_6 * var_153_1:getStringNumLines()
				})
				
				var_153_3 = var_153_1:getContentSize()
			end
		end
		
		var_153_0:getChildByName("box_bg"):setContentSize(var_153_3.width + 80, var_153_3.height + 100)
		
		local var_153_9 = var_153_1:getContentSize()
		local var_153_10 = {
			x = var_153_9.width - var_153_2.width,
			y = var_153_9.height - var_153_2.height
		}
		local var_153_11 = var_153_0:getContentSize()
		
		var_153_11.width = var_153_11.width + var_153_10.x
		var_153_11.height = var_153_11.height + var_153_10.y
		
		local var_153_12 = var_153_0:getChildByName("n_talk_box")
		
		var_153_12:setPositionY(var_153_12:getPositionY() + var_153_10.y * 0.5)
		
		if arg_153_0.talkbox_l then
			local var_153_13 = string.split(arg_153_0.talkbox_l, ",")
			local var_153_14 = var_153_13[1]
			local var_153_15 = var_153_13[2] or 0
			local var_153_16 = var_153_13[3] or 0
			
			if var_153_14 == "right" then
				local var_153_17 = math.max(VIEW_BASE_LEFT, VIEW_BASE_RIGHT - var_153_11.width - var_153_15)
				local var_153_18 = math.min(var_153_16, VIEW_HEIGHT - var_153_11.height)
				
				var_153_0:setPosition(var_153_17 + (var_153_11.width + 200), var_153_18)
				UIAction:Add(SPAWN(FADE_IN(50), LOG(MOVE_TO(100, var_153_17, var_153_18))), var_153_0, "block")
				set_high_fps_tick(3000)
			elseif var_153_14 == "left" then
				local var_153_19 = math.min(VIEW_BASE_LEFT + var_153_15, VIEW_BASE_RIGHT - var_153_11.width)
				local var_153_20 = math.min(var_153_16, VIEW_HEIGHT - var_153_11.height)
				
				var_153_0:setPosition(var_153_19 - (var_153_11.width + 200), var_153_20)
				UIAction:Add(SPAWN(FADE_IN(50), LOG(MOVE_TO(100, var_153_19, var_153_20))), var_153_0, "block")
				set_high_fps_tick(3000)
			elseif var_153_14 == "center" then
				local var_153_21 = 640 - var_153_11.width * 0.5
				local var_153_22 = 360 - var_153_11.height * 0.5
				local var_153_23 = math.max(VIEW_BASE_LEFT, math.min(var_153_21 + var_153_15, VIEW_BASE_RIGHT - var_153_11.width))
				local var_153_24 = math.min(var_153_22 + var_153_16, VIEW_HEIGHT - var_153_11.height)
				
				var_153_0:setPosition(var_153_23, var_153_24)
				UIAction:Add(SEQ(LOG(SPAWN(SCALE(100, 0, 1), FADE_IN(100)))), var_153_0, "block")
				set_high_fps_tick(3000)
			else
				Log.e("Error TutorialGuide. undefined talkbox_l : " .. arg_153_0.id)
				TutorialGuide:_turnOnSkipButton()
			end
		end
		
		if arg_153_0.eff == "shake" then
			UIAction:Add(SEQ(DELAY(100), SHAKE_UI(400, 50)), var_153_0)
		end
	else
		var_153_0:setVisible(false)
	end
end

local function var_0_18(arg_154_0, arg_154_1)
	if arg_154_0.sound then
		UIAction:Add(SEQ(DELAY(200), CALL(function()
			SoundEngine:play("event:/" .. arg_154_0.sound)
		end)), arg_154_1.wnd)
	end
end

local function var_0_19(arg_156_0, arg_156_1)
	local var_156_0 = var_0_1(arg_156_1.wnd, "n_reward", 1)
	
	if arg_156_0.item_id then
		if_set_visible(var_156_0, nil, true)
		if_set(arg_156_1.wnd, "reward_count", tostring(arg_156_0.item_value))
		
		if not arg_156_0.item_value then
			Log.e("Error TutorialGuide DB. item_value is empty : " .. arg_156_0.id)
			
			arg_156_0.item_value = 0
		end
		
		local var_156_1 = UIUtil:getRewardIcon(arg_156_0.item_value, arg_156_0.item_id, {
			parent = arg_156_1.wnd:getChildByName("n_reward_icon")
		})
	else
		if_set_visible(var_156_0, nil, false)
	end
end

local function var_0_20(arg_157_0, arg_157_1)
	local var_157_0 = arg_157_1.wnd:getChildByName("btn_guide_skip")
	
	if not get_cocos_refid(var_157_0) then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial("boss_guide") then
		var_157_0._origin_pos_y = var_157_0._origin_pos_y or var_157_0:getPositionY()
		
		var_157_0:setPositionY(var_157_0._origin_pos_y - 50)
	end
	
	if arg_157_0.skip_btn == "y" then
		if_set_visible(var_157_0, nil, true)
	else
		if_set_visible(var_157_0, nil, false)
	end
end

local function var_0_21(arg_158_0, arg_158_1)
	if arg_158_0.talk_image then
		local var_158_0 = arg_158_1.wnd:getChildByName("image_frame")
		
		var_158_0:setVisible(true)
		
		if arg_158_0.talk_image ~= arg_158_0.prev_talk_image then
			var_158_0:setOpacity(0)
			UIAction:Add(RLOG(FADE_IN(100)), var_158_0, "block")
		end
		
		SpriteCache:resetSprite(var_158_0:getChildByName("talk_image"), "tutorial/" .. arg_158_0.talk_image .. ".png")
	else
		if_set_visible(arg_158_1.wnd, "image_frame", false)
	end
end

local function var_0_22(arg_159_0, arg_159_1)
	if_set_visible(arg_159_1.wnd, "dim", false)
	if_set_visible(arg_159_1.wnd, "n_hole", false)
	if_set_visible(arg_159_1.wnd, "n_hole_rect", false)
	
	if arg_159_0.dim then
		local var_159_0
		
		if arg_159_0.dim == "hole" then
			var_159_0 = arg_159_1.wnd:getChildByName("n_hole")
			
			var_159_0:setVisible(true)
		elseif arg_159_0.dim == "hole_enemy" then
			var_159_0 = arg_159_1.wnd:getChildByName("n_hole_rect")
			
			var_159_0:setVisible(true)
			
			if Battle:getStageMode() == STAGE_MODE.EVENT then
				BattleUIAction:Add(LOOP(SEQ(DELAY(2000), CALL(function()
					BattleUI:showGuideFocusRing(ENEMY)
				end), DELAY(1000), CALL(function()
					BattleUI:GuideFocusRingRemoveAction()
				end))), arg_159_1.wnd, "battle.guide")
			end
		elseif arg_159_0.dim == "hole_friend" then
			var_159_0 = arg_159_1.wnd:getChildByName("n_hole_rect")
			
			var_159_0:setVisible(true)
			var_159_0:setPositionX(280)
		elseif arg_159_0.dim == "hole_object" then
			var_159_0 = arg_159_1.wnd:getChildByName("n_hole_rect")
			
			var_159_0:setVisible(true)
			var_159_0:setPositionX(640)
			var_159_0:setPositionY(390)
			var_159_0:setScaleX(5)
			var_159_0:setScaleY(0.95)
		elseif string.starts(arg_159_0.dim, "hole_target_x") then
			var_159_0 = arg_159_1.wnd:getChildByName("n_hole")
			
			var_159_0:setVisible(true)
			
			if arg_159_1.target_control then
				local var_159_1 = arg_159_1.target_control:getContentSize()
				local var_159_2 = SceneManager:convertToSceneSpace(arg_159_1.target_control, {
					x = var_159_1.width / 2,
					y = var_159_1.height / 2
				})
				
				var_159_0:setPosition(var_159_2)
				
				local var_159_3 = tonumber(string.sub(arg_159_0.dim, 14, -1))
				
				var_159_0:setScale(var_159_3)
			end
		else
			var_159_0 = arg_159_1.wnd:getChildByName("dim")
			
			var_159_0:setVisible(true)
			var_159_0:setOpacity((arg_159_0.dim or 0) * 255)
			
			var_159_0 = nil
		end
		
		if arg_159_0.dim_offset and var_159_0 then
			local var_159_4 = 0
			local var_159_5 = 0
			local var_159_6 = string.split(arg_159_0.dim_offset, ",")
			local var_159_7 = tonumber(var_159_6[1] or 0)
			local var_159_8 = tonumber(var_159_6[2] or 0)
			
			var_159_0:setPosition(var_159_0:getPositionX() + var_159_7, var_159_0:getPositionY() + var_159_8)
		end
	end
end

function TutorialGuide.setGuide_talkbox(arg_162_0, arg_162_1)
	var_0_16(arg_162_0, arg_162_1, arg_162_0.guide_info)
	var_0_17(arg_162_1, arg_162_0.guide_info)
	var_0_18(arg_162_1, arg_162_0.guide_info)
	var_0_19(arg_162_1, arg_162_0.guide_info)
	var_0_20(arg_162_1, arg_162_0.guide_info)
	var_0_21(arg_162_1, arg_162_0.guide_info)
	var_0_22(arg_162_1, arg_162_0.guide_info)
end

function TutorialGuide.setGuide_block(arg_163_0, arg_163_1)
	arg_163_0.guide_info.is_block_type = true
end

function TutorialGuide.setGuide_story(arg_164_0, arg_164_1)
	start_new_story(nil, arg_164_1.story_id, {
		on_finish = function()
			TutorialGuide:procGuide()
			SubStoryLobbyUIBurning:updateBGM()
		end
	})
end

function TutorialGuide.setGuide_summary(arg_166_0, arg_166_1)
	local var_166_0 = arg_166_0.guide_info.wnd:getChildByName("Popup_frame")
	
	var_166_0:setVisible(true)
	var_166_0:setOpacity(0)
	UIAction:Add(SEQ(RLOG(FADE_IN(100))), var_166_0, "block")
	
	local var_166_1 = arg_166_0.guide_info.wnd:getChildByName("btn_close")
	
	var_166_1:setVisible(true)
	var_166_1:setOpacity(0)
	UIAction:Add(SEQ(RLOG(FADE_IN(50))), var_166_1, "block")
	
	if arg_166_1.s_title then
		if_set(var_166_0, "summary_title", arg_166_1.s_title)
	end
	
	if arg_166_1.s_image then
		SpriteCache:resetSprite(var_166_0:getChildByName("summary_image"), "tutorial/" .. arg_166_1.s_image .. ".png")
	end
	
	if arg_166_1.s_text then
		if_set(var_166_0, "summary_disc", string.gsub(arg_166_1.s_text, "%\\n", "\n"))
	end
end

function TutorialGuide.setGuide_summary_large(arg_167_0, arg_167_1)
	arg_167_0.guide_info.wnd:getChildByName("Popup_frame"):setVisible(false)
	
	local var_167_0 = arg_167_0.guide_info.wnd:getChildByName("Popup_frame_large")
	
	var_167_0:setVisible(true)
	var_167_0:setOpacity(0)
	UIAction:Add(SEQ(RLOG(FADE_IN(100))), var_167_0, "block")
	
	local var_167_1 = arg_167_0.guide_info.wnd:getChildByName("btn_close")
	
	var_167_1:setVisible(true)
	var_167_1:setOpacity(0)
	UIAction:Add(SEQ(RLOG(FADE_IN(50))), var_167_1, "block")
	
	if arg_167_1.s_title then
		local var_167_2 = string.split(arg_167_1.s_title, ",") or {}
		
		if_set(var_167_0, "summary_title", T(table.remove(var_167_2, 1)))
		
		for iter_167_0, iter_167_1 in ipairs(var_167_2) do
			if_set(var_167_0, "summary_title" .. iter_167_0, T(iter_167_1))
		end
	end
	
	if arg_167_1.s_text then
		local var_167_3 = string.split(arg_167_1.s_text, ",") or {}
		
		for iter_167_2, iter_167_3 in ipairs(var_167_3) do
			if_set(var_167_0, "summary_disc" .. iter_167_2, string.gsub(T(iter_167_3), "%\\n", "\n"))
		end
	end
	
	if arg_167_1.s_image then
		local var_167_4 = string.split(arg_167_1.s_image, ",") or {}
		
		for iter_167_4, iter_167_5 in ipairs(var_167_4) do
			if_set_sprite(var_167_0:getChildByName("n_insert_image" .. iter_167_4), "image", "tutorial/" .. iter_167_5 .. ".png")
		end
	end
end

function TutorialGuide.setGuide_select(arg_168_0, arg_168_1)
	arg_168_0.guide_info.is_select_type = true
	
	local var_168_0 = arg_168_0.guide_info.wnd:getChildByName("n_select")
	local var_168_1 = arg_168_0.guide_info.wnd:getChildByName("dim")
	
	var_168_0:setOpacity(0)
	UIAction:Add(SEQ(LOG(SPAWN(SCALE(100, 0, 1), FADE_IN(100)))), var_168_0, "block")
	
	if arg_168_1.skip_btn == "n" then
		var_168_1:setVisible(true)
		var_168_1:setOpacity((arg_168_1.dim or 0.5) * 255)
		if_set_visible(arg_168_0.guide_info.wnd, "btn_bg_select", true)
	else
		var_168_1:setVisible(false)
		if_set_visible(arg_168_0.guide_info.wnd, "btn_bg_select", false)
	end
	
	if arg_168_1.active_time then
		set_high_fps_tick(arg_168_1.active_time + 600)
		
		local function var_168_2()
			arg_168_0:skipGuide()
		end
		
		UIAction:Add(SEQ(DELAY(arg_168_1.active_time), FADE_OUT(500), CALL(var_168_2)), arg_168_0.guide_info.wnd)
	end
	
	local var_168_3 = arg_168_0.guide_info.wnd:getChildByName("txt_disc")
	
	if arg_168_1.npc_icon then
		var_168_0:setVisible(true)
		
		if arg_168_1.eff == "shake" then
			UIAction:Add(SEQ(DELAY(400), SHAKE_UI(400, 50)), var_168_0)
		end
		
		if_set(arg_168_0.guide_info.wnd, "txt_name", arg_168_1.npc_name)
		UIUtil:setTextAndReturnHeight(var_168_3, string.gsub(arg_168_1.message, "%\\n", "\n"), 483)
		SpriteCache:resetSprite(arg_168_0.guide_info.wnd:getChildByName("spr_face"), "face/" .. arg_168_1.npc_icon .. ".png")
		
		if arg_168_1.talkbox_l then
			local var_168_4 = string.split(arg_168_1.talkbox_l, ",")
			local var_168_5 = var_168_4[1]
			local var_168_6 = var_168_4[2] or 0
			local var_168_7 = var_168_4[3] or 0
			
			if var_168_5 == "right" then
				local var_168_8 = var_168_0:getContentSize()
				local var_168_9 = math.max(VIEW_BASE_LEFT, VIEW_BASE_RIGHT - var_168_8.width - var_168_6)
				local var_168_10 = math.min(var_168_7, VIEW_HEIGHT - var_168_8.height)
				
				var_168_0:setPosition(var_168_9, var_168_10)
			elseif var_168_5 == "left" then
				local var_168_11 = var_168_0:getContentSize()
				local var_168_12 = math.min(VIEW_BASE_LEFT + var_168_6, VIEW_BASE_RIGHT - var_168_11.width)
				local var_168_13 = math.min(var_168_7, VIEW_HEIGHT - var_168_11.height)
				
				var_168_0:setPosition(var_168_12, var_168_13)
			elseif var_168_5 == "center" then
				local var_168_14 = var_168_0:getContentSize()
				local var_168_15 = 640 - var_168_14.width * 0.5
				local var_168_16 = 360 - var_168_14.height * 0.5
				local var_168_17 = math.max(VIEW_BASE_LEFT, math.min(var_168_15 + var_168_6, VIEW_BASE_RIGHT - var_168_14.width))
				local var_168_18 = math.min(var_168_16 + var_168_7, VIEW_HEIGHT - var_168_14.height)
				
				var_168_0:setPosition(var_168_17, var_168_18)
			else
				Log.e("Error TutorialGuide. undefined talkbox_l : " .. arg_168_1.id)
				arg_168_0:_turnOnSkipButton()
			end
		end
	else
		Log.e("Error TutorialGuide. undefined npc_icon : " .. arg_168_1.id)
		var_168_0:setVisible(false)
	end
	
	local var_168_19 = arg_168_0.guide_info.wnd:getChildByName("talk")
	local var_168_20 = arg_168_0.guide_info.wnd:getChildByName("txt_name")
	local var_168_21 = arg_168_0.guide_info.wnd:getChildByName("cm_talk_title")
	local var_168_22 = arg_168_0.guide_info.wnd:getChildByName("arrow_t_0")
	local var_168_23 = arg_168_0.guide_info.wnd:getChildByName("face_ally")
	local var_168_24 = var_168_19:getContentSize().width
	local var_168_25 = var_168_19:getContentSize().height
	
	if var_168_19 and get_cocos_refid(var_168_19) and var_168_3 and get_cocos_refid(var_168_3) then
		var_168_19:setContentSize(math.max(var_168_24, var_168_19:getContentSize().width), math.max(var_168_25, var_168_3:getContentSize().height + 80))
		var_168_21:setPositionY(var_168_19:getContentSize().height - 15)
		var_168_20:setPositionY(var_168_19:getContentSize().height - 10)
		var_168_3:setPositionY(var_168_19:getContentSize().height - 40)
		var_168_22:setPositionY(var_168_19:getContentSize().height - 74)
		var_168_23:setPositionY(var_168_19:getContentSize().height - 78)
	end
	
	if arg_168_1.sound then
		UIAction:Add(SEQ(DELAY(600), CALL(function()
			SoundEngine:play("event:/" .. arg_168_1.sound)
		end)), arg_168_0.guide_info.wnd)
	end
end

function TutorialGuide.setGuide_mark(arg_171_0, arg_171_1)
	if arg_171_1.active_time then
		set_high_fps_tick(arg_171_1.active_time + 1000)
		UIAction:Add(SEQ(DELAY(arg_171_1.active_time), LOG(FADE_OUT(500)), CALL(function()
			arg_171_0:procGuide()
		end)), arg_171_0.guide_info.wnd:getChildByName("n_talk"))
	end
	
	var_0_16(arg_171_0, arg_171_1, arg_171_0.guide_info)
	var_0_17(arg_171_1, arg_171_0.guide_info)
	var_0_18(arg_171_1, arg_171_0.guide_info)
	var_0_19(arg_171_1, arg_171_0.guide_info)
	var_0_20(arg_171_1, arg_171_0.guide_info)
	var_0_21(arg_171_1, arg_171_0.guide_info)
	var_0_22(arg_171_1, arg_171_0.guide_info)
	if_set_visible(arg_171_0.guide_info.wnd, "btn_guide_bg", false)
end

function TutorialGuide.forceProcGuide(arg_173_0)
	arg_173_0:procGuide()
end

function TutorialGuide.setOnFinish(arg_174_0, arg_174_1)
	if not arg_174_0.vars then
		return 
	end
	
	if tolua.type(arg_174_1) ~= "function" then
		return 
	end
	
	arg_174_0.vars.on_finish_func = arg_174_1
end

function TutorialGuide.clearGuide(arg_175_0, arg_175_1)
	if not arg_175_0.guide_info then
		return 
	end
	
	arg_175_0:_unlockScrollView()
	
	if arg_175_0.vars.cur_guide and arg_175_0.vars.cur_guide.de_proc then
		arg_175_0.vars.cur_guide.de_proc(arg_175_0.vars.cur_guide.proc_param)
	end
	
	if get_cocos_refid(arg_175_0.guide_info.wnd) then
		arg_175_0.guide_info.wnd:removeFromParent()
	end
	
	arg_175_0.guide_info = nil
	
	if arg_175_0.vars.cur_guide and arg_175_0.vars.cur_guide.after_release_de_proc then
		arg_175_0.vars.cur_guide.after_release_de_proc(arg_175_0.vars.cur_guide.proc_param)
	end
end

function TutorialGuide.isClearedTutorial(arg_176_0, arg_176_1)
	if SAVE:getTutorialGuide(arg_176_1) then
		return true
	end
	
	return false
end

function TutorialGuide.checkScene(arg_177_0, arg_177_1)
	for iter_177_0, iter_177_1 in pairs(arg_177_1) do
		if iter_177_1 == SceneManager:getCurrentSceneName() then
			return true
		end
	end
	
	return false
end

function TutorialGuide.getPlayingTutorialID(arg_178_0)
	if not arg_178_0:isPlayingTutorial() then
		return "tutorial is not playing"
	end
	
	return arg_178_0.vars.started_guide_id
end

function TutorialGuide.isPlayingTutorial(arg_179_0, arg_179_1)
	if arg_179_0.vars.started_guide and #arg_179_0.vars.started_guide > 0 then
		if arg_179_1 then
			return arg_179_0.vars.started_guide_id == arg_179_1
		end
		
		return true
	end
	
	return false
end

function TutorialGuide.isNeedActiveSkillForced(arg_180_0)
	if not arg_180_0:isPlayingTutorial() then
		return 
	end
	
	local var_180_0 = arg_180_0:getPlayingTutorialID()
	
	if not var_180_0 or var_180_0 ~= "intro_1_battle" then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return 
	end
	
	Battle:playAutoSelectTargetForced(Battle.logic:getTurnOwner())
	
	return true
end

function TutorialGuide.isNeedSelectSkill(arg_181_0, arg_181_1)
	if not arg_181_0:isPlayingTutorial() then
		return 
	end
	
	local var_181_0 = arg_181_0:getPlayingTutorialID()
	
	if not var_181_0 or var_181_0 ~= "intro_1_battle" then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return 
	end
	
	local var_181_1 = arg_181_1 or 3
	
	Battle:onTouchSkill(var_181_1)
	
	return true
end

function TutorialGuide.isNeedAutoMove(arg_182_0)
	if is_playing_story() or arg_182_0:isPlayingTutorial() then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return 
	end
	
	if not Battle.logic or not Battle.logic.map or not Battle.logic.map.enter then
		return 
	end
	
	if Battle.logic:getTurnState() then
		return 
	end
	
	return not arg_182_0:isClearedTutorial("intro_1_battle") and Battle.logic.map.enter == "tot001"
end

function TutorialGuide.isSkipable(arg_183_0)
	if arg_183_0.guide_info and get_cocos_refid(arg_183_0.guide_info.wnd) then
		local var_183_0 = arg_183_0.guide_info.wnd:getChildByName("btn_guide_skip")
		
		if var_183_0 then
			return var_183_0:isVisible()
		end
	end
	
	return false
end

function TutorialGuide.saveTutorial(arg_184_0, arg_184_1, arg_184_2)
	arg_184_2 = arg_184_2 and true or false
	
	if not SAVE:getTutorialGuide(arg_184_0.vars.started_guide_id) then
		local var_184_0 = SubstoryManager:getInfo() or {}
		
		query("tutorial_complete", {
			tv = 1,
			tid = arg_184_1.id,
			substory_id = var_184_0.id,
			is_skip_by_user = arg_184_2
		})
	end
end

function TutorialGuide.forceClearTutorials(arg_185_0, arg_185_1, arg_185_2)
	local var_185_0 = {}
	
	for iter_185_0, iter_185_1 in pairs(arg_185_1) do
		if not SAVE:getTutorialGuide(iter_185_1) then
			if not arg_185_0.Guides then
				arg_185_0.Guides = arg_185_0:makeGuideData()
			end
			
			if arg_185_0.Guides and arg_185_0.Guides[iter_185_1] then
				local var_185_1 = arg_185_0.Guides[iter_185_1][#arg_185_0.Guides[iter_185_1]]
				
				table.insert(var_185_0, var_185_1.id)
			end
		end
	end
	
	if table.empty(var_185_0) then
		return 
	end
	
	local var_185_2
	
	if arg_185_2 and arg_185_1[1] then
		var_185_2 = arg_185_1[1]
	end
	
	query("tutorial_complete_list", {
		tv = 1,
		tid = array_to_json(var_185_0),
		log_tutorial_id = var_185_2
	})
end

function TutorialGuide._isBlockTouch(arg_186_0)
	if arg_186_0:isPlayingTutorial() then
		if arg_186_0.vars.cur_guide and arg_186_0.vars.cur_guide.target_touch == "y" then
			return true
		elseif arg_186_0.guide_info and arg_186_0.guide_info.is_block_type then
			return true
		end
	end
	
	return false
end

function TutorialGuide.isAllowEvent(arg_187_0, arg_187_1)
	if arg_187_0.guide_info then
		if arg_187_0.guide_info.is_select_type then
			if arg_187_1 and arg_187_1:getName() ~= "btn_start_tutorial" and arg_187_1:getName() ~= "btn_cancel_tutorial" then
				if arg_187_1:getName() == "block_touch" then
					return false
				elseif arg_187_1:getName() == "btn_bg_select" then
					balloon_message_with_sound("select_touch_need")
					
					return false
				else
					arg_187_0:skipGuide()
				end
			end
			
			return true
		elseif arg_187_0.guide_info.is_block_type then
			return false
		elseif arg_187_0.guide_info.target_touch then
			if not arg_187_1 then
				return false
			end
			
			if arg_187_0.guide_info.target_event_control == arg_187_1 then
				return true
			end
			
			if arg_187_1:getName() == "btn_guide_bg" then
				return true
			end
			
			if arg_187_1:getName() == "btn_guide_skip" then
				return true
			end
			
			if get_cocos_refid(arg_187_0.guide_info.target_event_control) then
				print("TutorialGuide target : " .. arg_187_0.guide_info.target_event_control:getName() .. "  control : " .. arg_187_1:getName())
			else
				print("TutorialGuide target : " .. "nil" .. "  control : " .. arg_187_1:getName())
			end
			
			return false
		end
	end
	
	return true
end

function TutorialGuide.checkBlockFieldEvent(arg_188_0, arg_188_1)
	if arg_188_0:_isBlockTouch() then
		if arg_188_0.vars.cur_guide.dim and string.starts(arg_188_0.vars.cur_guide.dim, "hole") and (not string.starts(arg_188_0.vars.cur_guide.dim, "hole_target") or arg_188_0:isPlayingTutorial("chaosgate")) then
			return false
		end
		
		return true
	else
		return false
	end
end

function TutorialGuide.checkBlockSkillButton(arg_189_0, arg_189_1, arg_189_2)
	if arg_189_0:_isBlockTouch() then
		if arg_189_0.vars.started_guide_id == "intro_1_skill" and arg_189_0.vars.cur_guide and arg_189_0.vars.cur_guide.target and type(arg_189_0.vars.cur_guide.target) == "string" and string.starts(arg_189_0.vars.cur_guide.target, "n_skill") and string.sub(arg_189_0.vars.cur_guide.target, -1, -1) == tostring(arg_189_2) then
			arg_189_0:procGuide()
			
			return false
		end
		
		return true
	else
		return false
	end
end

function TutorialGuide.checkBlockSoulburnButton(arg_190_0, arg_190_1)
	if arg_190_0:_isBlockTouch() then
		if arg_190_0.vars.cur_guide.id == "ije002_soulburn_02" then
			arg_190_0:procGuide()
			
			return false
		else
			return true
		end
	end
	
	return false
end

function TutorialGuide.checkBlockDungeonList(arg_191_0, arg_191_1)
	if arg_191_0:_isBlockTouch() then
		if arg_191_1 and arg_191_1.item and arg_191_1.item.mode == arg_191_0.vars.cur_guide.target_params then
			return false
		end
		
		return true
	end
end

function TutorialGuide.checkBlockDungeonPeriodList(arg_192_0, arg_192_1)
	if arg_192_0:_isBlockTouch() then
		if arg_192_1 and arg_192_1.control and arg_192_0.guide_info and (arg_192_0.guide_info.target_control == arg_192_1.control or arg_192_0.guide_info.target_event_control == arg_192_1.control) then
			return false
		end
		
		return true
	end
end

function TutorialGuide.checkBlockBattleReadyScrollView(arg_193_0)
	if arg_193_0:_isBlockTouch() and arg_193_0.vars.cur_guide and arg_193_0.vars.cur_guide.proc == var_0_5.block_scroll_ready then
		return true
	end
end

function TutorialGuide.checkBlockWorldmapController(arg_194_0)
	if arg_194_0:_isBlockTouch() then
		if arg_194_0.vars.cur_guide and arg_194_0.vars.cur_guide.target_func_name == "WORLDMAP_ICON" then
			return false
		end
		
		return true
	end
end

function TutorialGuide.isStoryType(arg_195_0)
	if not arg_195_0.vars or not arg_195_0.vars.cur_guide then
		return 
	end
	
	return (arg_195_0.vars.cur_guide.type or "") == "story"
end

function TutorialGuide._startGuideFromCallback(arg_196_0, arg_196_1, arg_196_2)
	if not arg_196_0.dirty_tutorial[arg_196_1] then
		local var_196_0 = arg_196_0:startGuide(arg_196_1, arg_196_2)
		
		if var_196_0 and not arg_196_2 then
			arg_196_0.dirty_tutorial[arg_196_1] = true
		end
		
		return var_196_0
	end
end

function TutorialGuide._isBossStage(arg_197_0, arg_197_1)
	for iter_197_0, iter_197_1 in pairs(arg_197_1.enemies) do
		if iter_197_1:isBoss() then
			return true
		end
	end
	
	return false
end

function TutorialGuide._calcStageCount(arg_198_0, arg_198_1)
	local var_198_0 = 0
	local var_198_1 = 0
	local var_198_2 = Battle.logic:getCurrentRoadEventObjectList()
	
	if var_198_2 then
		for iter_198_0, iter_198_1 in pairs(var_198_2) do
			if iter_198_1:isBattleType() then
				var_198_1 = var_198_1 + 1
				
				if Battle.logic:isCompletedRoadEvent(iter_198_1.event_id) then
					var_198_0 = var_198_0 + 1
				end
			end
		end
	end
	
	return math.min(var_198_0 + 1, var_198_1)
end

local function var_0_23()
	local var_199_0 = Account:getUnits()
	local var_199_1 = true
	
	if #var_199_0 > 0 then
		for iter_199_0, iter_199_1 in pairs(var_199_0) do
			local var_199_2 = iter_199_1.equips
			
			for iter_199_2, iter_199_3 in pairs(var_199_2) do
				if iter_199_3.db.type == "weapon" then
					return false
				end
			end
		end
	end
	
	local var_199_3 = false
	
	for iter_199_4, iter_199_5 in pairs(Account.equips) do
		if iter_199_5.db.type == "weapon" then
			var_199_3 = true
		end
	end
	
	if not var_199_3 then
		var_199_1 = false
	end
	
	return var_199_1
end

local function var_0_24()
	local var_200_0 = Account:getTeam(11)
	
	if var_200_0 then
		if table.count(var_200_0) > 0 then
			return false
		else
			return true
		end
	else
		return true
	end
end

function TutorialGuide.onCharacterResult(arg_201_0, arg_201_1)
end

function TutorialGuide.onEquipResult(arg_202_0, arg_202_1)
end

function TutorialGuide.onEnterSubstory(arg_203_0)
	local var_203_0 = SubstoryManager:getInfo() or {}
	
	if var_203_0.id then
		if var_203_0.id == "vyupia" and not arg_203_0:isClearedTutorial("hiden_stage") and (Account:getItemCount("ma_vyupia_1") > 0 or Account:getItemCount("ma_vyupia_2") > 0 or Account:getItemCount("ma_vyupia_3") > 0) then
			arg_203_0:_startGuideFromCallback("hiden_stage")
			
			return 
		end
		
		if var_203_0.id == "vyupib" and not arg_203_0:isClearedTutorial("hiden_stage") and (Account:getItemCount("ma_vyupib1") > 0 or Account:getItemCount("ma_vyupib2") > 0 or Account:getItemCount("ma_vyupib3") > 0) then
			arg_203_0:_startGuideFromCallback("vyupib_piece")
			
			return 
		end
		
		if var_203_0.id == "vewrda" then
			arg_203_0:ifStartGuide("bkazran_start")
			
			return 
		end
		
		if var_203_0.id == "vma1ba" then
			if SubstoryFestivalInn:isSchedulable(var_203_0) then
				arg_203_0:_startGuideFromCallback("tuto_vma1ba_nextday")
			else
				arg_203_0:_startGuideFromCallback("tuto_vma1ba_first")
			end
			
			return 
		end
	end
	
	if var_203_0.id and var_203_0.id == "vtutod" and not arg_203_0:isClearedTutorial("new_substory_lobby") then
		arg_203_0:_startGuideFromCallback("new_substory_lobby")
		
		return 
	end
	
	if var_203_0.id and var_203_0.id == "vfm0ba" and SubstoryManager:findContentsTypeColumn(SUBSTORY_CONTENTS_TYPE.PIECE_BOARD) and SubstoryPiece:startTutorial() then
		return 
	end
	
	if var_203_0.contents_type_2 and var_203_0.contents_type_2 == "content_travel" and var_203_0.id and SubStoryTravel:needToStartTutorial(var_203_0.id) and arg_203_0:_startGuideFromCallback("travel") then
		return 
	end
	
	if var_203_0.contents_type_2 and var_203_0.contents_type_2 == "content_board" and var_203_0.id and var_203_0.id == "vae2aa" and Account:isMapCleared("vae2aa010") and SubStoryControlBoardUtil:isAlreadyGetRewardedBefore(var_203_0.id) == false and arg_203_0:_startGuideFromCallback("tuto_board_a") then
		return 
	end
	
	if var_203_0.contents_type and var_203_0.contents_type == "substory_descent" and SubStoryUtil:getEventState(var_203_0.start_time, var_203_0.end_time) == SUBSTORY_CONSTANTS.STATE_OPEN and TutorialGuide:startGuide("descent_substory") then
		return 
	end
	
	if var_203_0.contents_type and var_203_0.contents_type == "substory_burning" and var_203_0.id and var_203_0.id == "vsu3aa" and not SubStoryLobbyUIBurning:isCloseSoon() then
		if TutorialGuide:startGuide("summer2023_intro") then
			function arg_203_0.vars.on_finish_func()
				if not SubStoryBurningStory:isValid() then
					SubStoryLobbyUIBurning:updateBGM()
				end
			end
			
			return 
		end
		
		if Account:isBurningStoryCleared("vsu3aa_c1", 8) and TutorialGuide:startGuide("summer2023_contents") then
			return 
		elseif SubStoryLobbyUIBurning:isNextChapterEnterable() and TutorialGuide:startGuide("summer2023_curtain") then
			return 
		end
	end
	
	if arg_203_0:startCustomTutorial("substory_lobby", var_203_0.id) then
		return 
	end
end

function TutorialGuide.checkAsepaTutorial(arg_205_0)
	do return  end
	
	if Lobby:isAlternativeLobby() and SAVE:getKeep("custom_lobby.mode") == "illust" and not arg_205_0:isClearedTutorial("vae2aa_lobby") then
		local var_205_0 = CustomLobbyIllust.Data:loadIllustSettingData()
		
		if var_205_0 and var_205_0.illust_id == "sub_vae2aa_5" then
			arg_205_0:_startGuideFromCallback("vae2aa_lobby")
		end
	end
end

function TutorialGuide.onEnterLobby(arg_206_0)
	if arg_206_0:isPlayingTutorial() and arg_206_0.vars.cur_guide then
		if arg_206_0.vars.cur_guide.proc == var_0_5.move_scene then
			arg_206_0:procGuide()
		end
		
		return 
	end
	
	if not arg_206_0:isClearedTutorial("lobby_adventure") then
		arg_206_0:_startGuideFromCallback("lobby_adventure")
		
		return 
	end
	
	if TutorialCondition:isEnable("system_059") then
		arg_206_0:_startGuideFromCallback("system_059")
		
		return 
	end
	
	if arg_206_0:isClearedTutorial("system_059") and not GrowthGuide:isClearedTutorial() and arg_206_0:_startGuideFromCallback("guide_quest") then
		return 
	end
	
	if not arg_206_0:isClearedTutorial("c3026_destiny") and Account:isMapCleared("rai002") and not Account:getCollectionUnit("c3026") then
		if Lobby:isAlternativeLobby() then
			if not arg_206_0:isClearedTutorial("c3026_destiny_new_lobby") then
				arg_206_0:_startGuideFromCallback("c3026_destiny_new_lobby")
				
				return 
			end
		else
			arg_206_0:_startGuideFromCallback("c3026_destiny")
			
			return 
		end
	end
	
	if AccountData and AccountData.clan_id and arg_206_0:isClearedTutorial(UNLOCK_ID.CLAN_MAIN) and not ContentDisable:byAlias("clan_war") and #(Account:getUnits() or {}) >= 2 then
		local var_206_0 = table.count(Account:getTeam(CLAN_TEAM_DEF_F) or {})
		local var_206_1 = table.count(Account:getTeam(CLAN_TEAM_DEF_B) or {})
		
		if (var_206_0 == 0 or var_206_1 == 0) and arg_206_0:_startGuideFromCallback("clanwar_formation") then
			return 
		end
	end
	
	arg_206_0:checkAsepaTutorial()
	arg_206_0:ifStartGuide("episode1_clear")
	arg_206_0:ifStartGuide("tuto_merc_lobby")
	arg_206_0:ifStartGuide("tuto_merc_end")
	arg_206_0:ifStartGuide("adin_artifact_start")
	arg_206_0:ifStartGuide("system_203")
end

function TutorialGuide.onEnterCoopLobby(arg_207_0)
	if CoopMission:isStartCoopCallTutorial() and arg_207_0:_startGuideFromCallback("expedition_join") then
		return 
	end
	
	if CoopMission:isRewardReceivable("current") then
		if CoopMission:isPremiumSeason() then
			if arg_207_0:_startGuideFromCallback("expedition_reward_new") then
				return 
			end
		elseif arg_207_0:_startGuideFromCallback("expedition_reward") then
			return 
		end
	end
	
	if CoopMission:isStartCoopWantedTutorial() and arg_207_0:_startGuideFromCallback("expedition_wanted") then
		return 
	end
end

function TutorialGuide.onEnterCoopReady(arg_208_0)
	local var_208_0 = CoopMission:getCurrentRoom()
	
	if not var_208_0 then
		return 
	end
	
	if var_208_0:isMyRoom() and arg_208_0:_startGuideFromCallback("expedition_invite") then
		return 
	end
end

function TutorialGuide.isSkipOpenEffect(arg_209_0, arg_209_1)
	if arg_209_1 == "vale2_move_1" then
		return true
	end
	
	return false
end

function TutorialGuide.onClearStoryMap(arg_210_0)
	print("TutorialGuide.onClearStoryMap : ")
	
	local var_210_0 = SubstoryManager:getInfo()
	
	if var_210_0 and var_210_0.id and var_210_0.id == "vfm0ba" then
		if Account:isMapCleared("vfm0bc003") and arg_210_0:_startGuideFromCallback("vfm0ba_defense") then
			return 
		end
		
		if Account:isMapCleared("vfm0bc021") and arg_210_0:_startGuideFromCallback("vfm0ba_epichell") then
			return 
		end
	end
	
	if var_210_0 and var_210_0.id and var_210_0.id == "vfm0ax" and Account:isMapCleared("vfm0az020") and arg_210_0:_startGuideFromCallback("vfm0ax_epichell") then
		WorldMapManager:getController():clearRunRoad()
		
		return 
	end
	
	if var_210_0 and var_210_0.id == "vch1ba" and Account:isMapCleared("vch1ba017") and arg_210_0:_startGuideFromCallback("substory_vch1ba_3rd") then
		return 
	end
	
	local var_210_2
	
	if var_210_0 and var_210_0.id and var_210_0.id == "vva1xa" and not TutorialGuide:isClearedTutorial("vva1xa_lucy") then
		local var_210_1 = Account:getSubStoryStories(var_210_0.id)
		
		if var_210_1 and not table.empty(var_210_1) and not table.empty(var_210_1.clear_count) then
			var_210_2 = {
				"sc_val2021a_001_1a"
			}
			
			for iter_210_0, iter_210_1 in pairs(var_210_1.clear_count) do
				if table.isInclude(var_210_2, iter_210_0) and arg_210_0:_startGuideFromCallback("vva1xa_lucy") then
					return 
				end
			end
		end
	end
	
	if var_210_0 and var_210_0.id == "vvalxa" then
		local var_210_4
		
		if not TutorialGuide:isClearedTutorial("vvalxa_hidden_ending") then
			if Account:isMapCleared("vvalxi004") or Account:isMapCleared("vvalxi003") then
				if arg_210_0:_startGuideFromCallback("vvalxa_hidden_ending") then
					return 
				end
			elseif Account:isMapCleared("vvalxi002") then
				local var_210_3 = Account:getSubStoryStories(var_210_0.id)
				
				if var_210_3 and not table.empty(var_210_3) and not table.empty(var_210_3.clear_count) then
					var_210_4 = {
						"sc_vvalea_033_2c"
					}
					
					for iter_210_2, iter_210_3 in pairs(var_210_3.clear_count) do
						if table.isInclude(var_210_4, iter_210_2) and arg_210_0:_startGuideFromCallback("vvalxa_hidden_ending") then
							return 
						end
					end
				end
			end
		end
		
		if Account:isMapCleared("vvalxa003") and arg_210_0:_startGuideFromCallback("vvalxa_move_after") then
			return 
		end
	end
	
	if var_210_0 and var_210_0.id == "vfa2aa" and Account:isMapCleared("vfa2aa003") and arg_210_0:_startGuideFromCallback("vfa2aa_material_guide") then
		return 
	end
	
	if var_210_0 and var_210_0.id == "vva3aa" then
		if Account:isMapCleared("vva3aa008") and arg_210_0:_startGuideFromCallback("vva3aa_memory") then
			return 
		end
		
		if Account:isMapCleared("vva3ab007") and arg_210_0:_startGuideFromCallback("vva3ab_memory") then
			return 
		end
		
		if Account:isMapCleared("vva3ac008") and arg_210_0:_startGuideFromCallback("vva3ac_memory") then
			return 
		end
	end
end

local function var_0_25()
	if Inventory:isShow() then
		Inventory:close()
	end
end

function TutorialGuide.onEnterWorldMapTown(arg_212_0, arg_212_1)
	local var_212_0 = SceneManager:getCurrentSceneName()
	local var_212_1 = DB("level_world_3_chapter", arg_212_1, "world_id")
	
	if to_n(var_212_1) == 5 and arg_212_0:ifStartGuide("tuto_adin_awake_1") then
		var_0_25()
		
		return 
	end
	
	if var_212_0 == "worldmap_scene" and arg_212_1 == "sab" and Account:isMapCleared("sab007") and arg_212_0:_startGuideFromCallback("sab004_guide") then
		var_0_25()
		
		return 
	end
	
	if var_212_0 == "worldmap_scene" and Account:isMapCleared("poe010") and arg_212_0:_startGuideFromCallback("natalon_start") then
		var_0_25()
		
		return 
	end
	
	if arg_212_1 == "vfm0ac" and Account:isMapCleared("vfm0ac003") and arg_212_0:_startGuideFromCallback("vfm0aa_defense") then
		var_0_25()
		
		return 
	end
	
	if arg_212_1 == "vva1ad" and SubstoryManager:isActiveSchedule("vva1aa_1") and arg_212_0:_startGuideFromCallback("vva1aa_new1") then
		return 
	end
	
	if arg_212_1 == "vva1ag" and SubstoryManager:isActiveSchedule("vva1aa_2") and arg_212_0:_startGuideFromCallback("vva1aa_new2") then
		return 
	end
	
	if arg_212_1 == "vdienx" and Account:isMapCleared("vdienx006") and arg_212_0:_startGuideFromCallback("vdienx_defense_dlc") then
		var_0_25()
		
		return 
	end
	
	if var_212_0 == "world_custom" and arg_212_1 == "wrd_rehas" and Account:isMapCleared("wrd_rehas007") and arg_212_0:_startGuideFromCallback("bkazran_get") then
		var_0_25()
		
		return 
	end
	
	if arg_212_1 == "vsu2ba" and arg_212_0:_startGuideFromCallback("vsu2ba_diary") then
		var_0_25()
		
		return 
	end
	
	if arg_212_1 == "vha0ba" and Account:isClearedSubStoryAchievement("vha0ba_ach_01") and arg_212_0:_startGuideFromCallback("vha0ba_stagelock") then
		return 
	end
	
	if arg_212_1 == "vrimbb" and Account:isMapCleared("vrimbb006") and arg_212_0:_startGuideFromCallback("vrimba_beni") then
		var_0_25()
		
		return 
	end
	
	if arg_212_0:startCustomTutorial("chaptermap", arg_212_1) then
		var_0_25()
		
		return 
	end
end

function TutorialGuide.onEnterWorldMap(arg_213_0)
	arg_213_0:procGuide("lobby_adventure")
	arg_213_0:procGuide("guide_quest")
	arg_213_0:procGuide("bkazran_start")
	arg_213_0:procGuide("adin_artifact_start")
	
	local var_213_0 = WorldMapManager:getController()
	local var_213_1 = var_213_0:getWorldIDByMapKey()
	local var_213_2 = var_213_0:getMapKey()
	local var_213_3 = SceneManager:getCurrentSceneName()
	
	if UnlockSystem:checkUnlockAndPlayStory(UNLOCK_ID.URGENT_MISSION, nil, true).unlock and arg_213_0:_startGuideFromCallback("time_mission") then
		if BattleReady:isShow() then
			BattleReady:hide()
		end
		
		return true
	end
	
	local var_213_4 = SubstoryManager:getInfo()
	local var_213_5 = var_213_3 == "world_custom" or var_213_3 == "world_sub"
	
	if var_213_5 and var_213_4 and var_213_4.id == "vyupia" and arg_213_0:_startGuideFromCallback("npc_guide") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vyupix" and arg_213_0:_startGuideFromCallback("vyupix_npc_guide") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vch1ba" and Account:isMapCleared("vch1ba006") and arg_213_0:_startGuideFromCallback("substory_vch1ba_1st") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vsu1ba" then
		if Account:isMapCleared("vsu1ba003") and arg_213_0:_startGuideFromCallback("vsu1ba_volleyball") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vsu1bb003") and arg_213_0:_startGuideFromCallback("vsu1ba_supply") then
			var_0_25()
			
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vfm0ba" then
		if (Account:isMapCleared("vfm0bb007") and not Account:isMapCleared("vfm0bb009") or not Account:isMapCleared("vfm0bb007") and Account:isMapCleared("vfm0bb009")) and arg_213_0:_startGuideFromCallback("vfm0ba_story_select") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vfm0bc003") and arg_213_0:_startGuideFromCallback("vfm0ba_defense") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vfm0bc021") and arg_213_0:_startGuideFromCallback("vfm0ba_epichell") then
			var_0_25()
			
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vfm0ax" and Account:isMapCleared("vfm0az020") and arg_213_0:_startGuideFromCallback("vfm0ax_epichell") then
		var_213_0:clearRunRoad()
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vrimaa" and arg_213_0:_startGuideFromCallback("vrimaa_start") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vrimba" and arg_213_0:_startGuideFromCallback("vrimba_start") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vch0ba" then
		if Account:isMapCleared("vch0ba009") and arg_213_0:_startGuideFromCallback("vch0ba_ach1") then
			var_0_25()
			
			return true
		end
		
		if Account:isClearedSubStoryAchievement("vch0ba_ach_14") and arg_213_0:_startGuideFromCallback("vch0ba_inti") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vch0ba019") and arg_213_0:_startGuideFromCallback("vch0ba_ach2") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vch0bb011") and arg_213_0:_startGuideFromCallback("vch0ba_end") then
			var_0_25()
			
			return true
		end
	end
	
	if (var_213_3 == "world_custom" or var_213_3 == "world_sub") and var_213_4 and var_213_4.id == "vma1ba" then
		if arg_213_0:procGuide("tuto_vma1ba_first") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vma1bc011") and arg_213_0:_startGuideFromCallback("tuto_vma1ba_end") then
			var_0_25()
			
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vrasex" and Account:isMapCleared("vrasex010") and arg_213_0:_startGuideFromCallback("vrasex_hidden_achieve_dlc") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vewrda" and var_213_1 and tonumber(var_213_1) == 55 and var_213_2 and var_213_2 == "wrd_rehas" and Account:isMapCleared("wrd_rehas007") and arg_213_0:_startGuideFromCallback("bkazran_get") then
		var_0_25()
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vva2ba" and Account:isMapCleared("vva2ba001") and arg_213_0:_startGuideFromCallback("vva2ba_note") then
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vfm3aa" then
		if Account:isMapCleared("vfm3aa002") and arg_213_0:_startGuideFromCallback("vfm3aa_note") then
			return true
		end
		
		if Account:isMapCleared("vfm3aa007") and arg_213_0:_startGuideFromCallback("vfm3aa_voice") then
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vvalxa" and arg_213_0:_startGuideFromCallback("vvalxa_help") then
		TutorialGuide:procGuide("vvalxa_help")
		
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vfa2aa" and Account:isMapCleared("vfa2aa013") and arg_213_0:_startGuideFromCallback("vfa2aa_minigame_entry") then
		return true
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vha2aa" then
		if Account:isMapCleared("vha2aa004") and arg_213_0:_startGuideFromCallback("vha2aa_worldmap_move") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2aa006") and arg_213_0:_startGuideFromCallback("vha2aa_hide_achievement") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2aa008") and arg_213_0:_startGuideFromCallback("vha2aa_worldmap_end") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2ab004") and arg_213_0:_startGuideFromCallback("vha2ab_worldmap_move") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2ab006") and arg_213_0:_startGuideFromCallback("vha2ab_hide_achievement") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2ab008") and arg_213_0:_startGuideFromCallback("vha2ab_worldmap_end") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2ac004") and arg_213_0:_startGuideFromCallback("vha2ac_worldmap_move") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2ac006") and arg_213_0:_startGuideFromCallback("vha2ac_hide_achievement") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vha2ac008") and arg_213_0:_startGuideFromCallback("vha2ac_worldmap_end") then
			var_0_25()
			
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vae2aa" then
		if (Account:isClearedSubStoryAchievement("vae2aa_ach_02") or Account:isClearedSubStoryAchievement("vae2aa_ach_03")) and arg_213_0:_startGuideFromCallback("vae2aa_maybar_focus") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vae2aa010") and not SubStoryControlBoardUtil:isAlreadyGetRewardedBefore("vae2aa") and not arg_213_0:isClearedTutorial("tuto_board_a") and arg_213_0:_startGuideFromCallback("vae2aa_controlroom") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vae2ab003") and arg_213_0:_startGuideFromCallback("vae2ab_ed_focus") then
			var_0_25()
			
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vch0ax" then
		if Account:isMapCleared("vch0ax009") and arg_213_0:_startGuideFromCallback("vch0ax_ach1") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vch0ax019") and arg_213_0:_startGuideFromCallback("vch0ax_ach2") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vch0az011") and arg_213_0:_startGuideFromCallback("vch0ax_end") then
			var_0_25()
			
			return true
		end
	end
	
	if var_213_5 and var_213_4 and var_213_4.id == "vva3aa" then
		if Account:isMapCleared("vva3aa012") and not Account:isPlayedStory("sc_vva3aa_m3") and arg_213_0:_startGuideFromCallback("vva3aa_ach1") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vva3aa013") and not Account:isPlayedStory("sc_vva3aa_m4") and arg_213_0:_startGuideFromCallback("vva3aa_ach2") then
			var_0_25()
			
			return true
		end
		
		if Account:isMapCleared("vva3aa014") and not Account:isPlayedStory("sc_vva3aa_m5") and arg_213_0:_startGuideFromCallback("vva3aa_ach3") then
			var_0_25()
			
			return true
		end
		
		if var_213_2 == "vva3ab" then
			if Account:isMapCleared("vva3ab012") and not Account:isPlayedStory("sc_vva3aa_m8") and arg_213_0:_startGuideFromCallback("vva3ab_ach1") then
				var_0_25()
				
				return true
			end
			
			if Account:isMapCleared("vva3ab013") and not Account:isPlayedStory("sc_vva3aa_m10") and arg_213_0:_startGuideFromCallback("vva3ab_ach2") then
				var_0_25()
				
				return true
			end
			
			if Account:isMapCleared("vva3ab014") and not Account:isPlayedStory("sc_vva3aa_m11") and arg_213_0:_startGuideFromCallback("vva3ab_ach3") then
				var_0_25()
				
				return true
			end
		end
		
		if var_213_2 == "vva3ac" then
			if Account:isMapCleared("vva3ac012") and not Account:isPlayedStory("sc_vva3aa_m14") and arg_213_0:_startGuideFromCallback("vva3ac_ach1") then
				var_0_25()
				
				return true
			end
			
			if Account:isMapCleared("vva3ac013") and not Account:isPlayedStory("sc_vva3aa_m16") and arg_213_0:_startGuideFromCallback("vva3ac_ach2") then
				var_0_25()
				
				return true
			end
			
			if Account:isMapCleared("vva3ac014") and not Account:isPlayedStory("sc_vva3aa_m18") and arg_213_0:_startGuideFromCallback("vva3ac_ach3") then
				var_0_25()
				
				return true
			end
		end
	end
	
	if var_213_4 and var_213_5 and arg_213_0:startCustomTutorial("worldmap", var_213_2) then
		var_0_25()
		
		return true
	end
	
	if var_213_5 then
		arg_213_0:onClearStoryMap()
	end
	
	arg_213_0:ifStartGuide("tuto_merc_end")
	arg_213_0:ifStartGuide("elasia_start")
end

function TutorialGuide.onEncounterEnemy(arg_214_0, arg_214_1)
	if arg_214_1:isTutorial() then
		return 
	end
	
	if arg_214_1.map.enter == "wrd_rehas034" then
		return 
	end
	
	arg_214_0:procGuide()
	
	if arg_214_1.map.enter == "ije001" then
		if arg_214_0:_calcStageCount(arg_214_1) == 1 then
			arg_214_0:_startGuideFromCallback("ije001_battle")
		end
		
		return 
	end
	
	if arg_214_1.map.enter == "ije004" then
		if arg_214_0:_calcStageCount(arg_214_1) == 2 and arg_214_0:_startGuideFromCallback("ije004_bosshp") and Battle:isAutoPlaying() then
			Battle:toggleAutoBattle()
		end
		
		return 
	end
	
	if arg_214_1.map.enter == "vkarix007" then
		if arg_214_0:_calcStageCount(arg_214_1) == 1 and arg_214_0:_startGuideFromCallback("vkarix_waterbreath") and Battle:isAutoPlaying() then
			Battle:toggleAutoBattle()
		end
		
		return 
	end
end

function TutorialGuide.onEnterRoad(arg_215_0, arg_215_1)
	if arg_215_1:isTutorial() then
	else
		local var_215_0 = Battle.logic:getCurrentRoadInfo()
		
		if var_215_0.road_id == "chaije00900" then
			arg_215_0:procGuide()
			arg_215_0:_startGuideFromCallback("chaosmap")
		elseif var_215_0.road_id == "ije00900" and arg_215_0.dirty_tutorial.chaosmap then
			arg_215_0:procGuide()
			arg_215_0:_startGuideFromCallback("chaosout")
		end
		
		if var_215_0.road_id == "bmrije00100" then
			local var_215_1 = "maze_base"
			
			if Battle:isAutoPlaying() and not SAVE:getTutorialGuide(var_215_1) then
				Battle:toggleAutoBattle()
			end
			
			arg_215_0:_startGuideFromCallback(var_215_1)
		end
	end
end

local function var_0_26(arg_216_0)
	local var_216_0, var_216_1, var_216_2 = DB("level_enter", arg_216_0, {
		"episode",
		"local_num",
		"tag_icon"
	})
	
	if not var_216_0 or not var_216_1 or not var_216_2 then
		return false
	end
	
	if var_216_0 ~= "adventure_ep1" then
		return false
	end
	
	if table.find({
		"ije",
		"rai",
		"riv"
	}, var_216_1) then
		return false
	end
	
	if not (string.find(var_216_2, "tag_boss") or string.find(var_216_2, "tag_advboss")) then
		return false
	end
	
	return true
end

local function var_0_27(arg_217_0)
	if TutorialGuide:isClearedTutorial("boss_guide") then
		return 
	end
	
	if not var_0_26(arg_217_0.map.enter) then
		return 
	end
	
	SAVE:set("TutorialGuide.failed_boss_map", true)
end

function TutorialGuide.onBattleFailed(arg_218_0, arg_218_1)
	var_0_27(arg_218_1)
end

function TutorialGuide.onBattleEnterFinished(arg_219_0, arg_219_1)
	if (arg_219_1.map.enter == "bmznet002" or arg_219_1.map.enter == "bmznet003") and arg_219_0:_startGuideFromCallback("insect_morale") then
		return 
	end
	
	if arg_219_0:startCustomTutorial("stage", arg_219_1.map.enter) then
		return 
	end
end

function TutorialGuide.onClearBattle(arg_220_0, arg_220_1)
end

function TutorialGuide.openSubstoryHelpGuide(arg_221_0)
	local var_221_0 = SubstoryManager:getInfo()
	
	if var_221_0 and not table.empty(var_221_0) and var_221_0.help_id then
		HelpGuide:open({
			contents_id = var_221_0.help_id
		})
	end
end

function TutorialGuide.onStartStage(arg_222_0, arg_222_1)
	if not arg_222_1:isTutorial() then
		arg_222_0:procGuide()
	end
end

function TutorialGuide.onShowTeamFormationBattleReady(arg_223_0, arg_223_1)
	if arg_223_1 == "vtutod001" then
		TutorialGuide:startGuide("substory_NPC")
		
		return 
	end
	
	if arg_223_0:startCustomTutorial("battle_ready", arg_223_1) then
		return 
	end
end

function TutorialGuide.onShowSoulGaugeUI(arg_224_0, arg_224_1)
	if Battle:getStageMode() ~= STAGE_MODE.EVENT then
		return 
	end
	
	if arg_224_1:isTutorial() then
		if arg_224_1.map.enter == "tot001" then
			arg_224_0:_startGuideFromCallback("intro_1_battle")
			
			return 
		end
	elseif arg_224_0:isPlayingTutorial("bkazran_use") and arg_224_1.map.enter == "wrd_rehas034" and arg_224_0:_calcStageCount(arg_224_1) == 3 then
		arg_224_0:procGuide()
	end
end

function TutorialGuide.onEndStage(arg_225_0, arg_225_1)
	if Battle.logic:isEnded() then
		return 
	end
	
	if Battle.logic.map.enter == "bmznet001" and (not arg_225_0:isClearedTutorial("insect_elite") or TEST_TUTORIAL) and (arg_225_1 == "bmcnet00124_1" or arg_225_1 == "bmcnet00144_1") then
		arg_225_0:_startGuideFromCallback("insect_elite")
	end
end

function TutorialGuide.onBattleStoryEnd(arg_226_0, arg_226_1)
	if arg_226_1 == "CH01_007_1_new" then
		if Battle:isAutoPlaying() and not TutorialGuide:isClearedTutorial("ije006_auto") then
			Battle:toggleAutoBattle()
		end
		
		arg_226_0:_startGuideFromCallback("ije006_auto")
	end
	
	if arg_226_1 == "dije01_clear" then
		arg_226_0:_startGuideFromCallback("maze_elson")
		
		return 
	end
end

function TutorialGuide.onReceivedQuest(arg_227_0, arg_227_1)
	if arg_227_1 == "ep1_1_10" then
		local var_227_0 = Account:getUnitsByCode("c1001")
		local var_227_1 = false
		
		for iter_227_0, iter_227_1 in pairs(var_227_0) do
			if iter_227_1:hasArtifact() then
				var_227_1 = true
				
				break
			end
		end
		
		if not var_227_1 then
			return arg_227_0:startGuide("artifact_install")
		end
	end
end

function TutorialGuide.isBlockUnlockSystemMsg(arg_228_0, arg_228_1)
	if arg_228_1 == UNLOCK_ID.TUTORIAL_EQUIP and TutorialGuide:isPlayingTutorial("system_059") then
		return true
	end
end

function TutorialGuide.isBlockOpenEquipDialog(arg_229_0, arg_229_1)
	if arg_229_0:isPlayingTutorial("artifact_install") and arg_229_1 ~= 7 then
		return true
	end
	
	if arg_229_0:isPlayingTutorial("equip_install") and arg_229_1 ~= 1 then
		return true
	end
	
	if arg_229_0:isPlayingTutorial("system_059") then
		return true
	end
	
	if arg_229_0:isPlayingTutorial("system_049") then
		return true
	end
	
	if arg_229_0:isPlayingTutorial("ras_memorization") then
		return true
	end
	
	if arg_229_0:isPlayingTutorial("mer_memorization") then
		return true
	end
	
	if arg_229_0:isPlayingTutorial("memorization") then
		return true
	end
	
	return false
end

function TutorialGuide.closeMiniMap(arg_230_0)
	if BattlePopupMap:isShow() then
		BattlePopupMap:hide()
	end
end

function TutorialGuide.onStartTurn(arg_231_0, arg_231_1, arg_231_2)
	if arg_231_1:isTutorial() then
		local var_231_0 = arg_231_0:_calcStageCount(arg_231_1)
		
		if arg_231_1.map.enter == "tot001" and var_231_0 == 1 and not arg_231_0.dirty_tutorial.intro_1_skill and arg_231_1:getTurnOwner().inst.code == "c1001_t" then
			arg_231_0:_startGuideFromCallback("intro_1_skill")
		end
		
		return 
	end
	
	if arg_231_1.map.enter == "ije002" then
		if arg_231_0:_calcStageCount(arg_231_1) == 3 and arg_231_2.db.code == "c1024_lm" then
			arg_231_0:_startGuideFromCallback("ije002_soulburn")
		end
		
		return 
	end
	
	if (function()
		if arg_231_0:isClearedTutorial("boss_guide") then
			return false
		end
		
		if not SAVE:get("TutorialGuide.failed_boss_map") then
			return false
		end
		
		if not var_0_26(arg_231_1.map.enter) then
			return false
		end
		
		if not arg_231_0:_isBossStage(arg_231_1) then
			return false
		end
		
		if arg_231_2.inst.ally ~= "friend" then
			return false
		end
		
		if Battle:isAutoPlaying() then
			Battle:toggleAutoBattle()
		end
		
		arg_231_0:_startGuideFromCallback("boss_guide")
		
		return true
	end)() then
		return 
	end
end

function TutorialGuide.onStoryChoice(arg_233_0, arg_233_1)
	if not arg_233_1 then
		return 
	end
	
	if string.starts(arg_233_1, "val2022_008_1_8") then
		arg_233_0:_startGuideFromCallback("vva2ba_inference")
		
		return 
	end
end

function TutorialGuide.onShowSkillButtons(arg_234_0, arg_234_1)
	if Battle:getStageMode() ~= STAGE_MODE.EVENT then
		return 
	end
	
	if arg_234_1:isTutorial() then
		if arg_234_0:isPlayingTutorial("intro_1_skill") and arg_234_1:getTurnOwner().inst.code == "c1001_t" then
			arg_234_0:procGuide("intro_1_skill")
		end
	elseif arg_234_1.map.enter == "ije002" and arg_234_0.vars.cur_guide and arg_234_0:_calcStageCount(arg_234_1) == 3 and arg_234_0.vars.cur_guide.id == "ije002_soulburn_01" then
		arg_234_0:procGuide()
	end
end

function TutorialGuide.onSelectTarget(arg_235_0, arg_235_1, arg_235_2)
	if arg_235_0:isPlayingTutorial() and arg_235_1.map.enter == "ije002" and arg_235_0.vars.cur_guide and arg_235_0.vars.cur_guide.id == "ije002_soulburn_03" then
		arg_235_0:procGuide()
	end
end

function TutorialGuide.onSkillStart(arg_236_0, arg_236_1, arg_236_2, arg_236_3)
	if arg_236_1:isTutorial() then
		arg_236_0:procGuide()
		
		local var_236_0 = arg_236_0:_calcStageCount(arg_236_1)
	elseif arg_236_0:isPlayingTutorial("bkazran_use") and arg_236_1.map.enter == "wrd_rehas034" and arg_236_2.db.code == "s0004" then
		arg_236_0:procGuide()
	end
end

function TutorialGuide.onCoopAttack(arg_237_0, arg_237_1, arg_237_2, arg_237_3)
end

function TutorialGuide.onResultUIDone(arg_238_0, arg_238_1)
	if arg_238_1.map.enter == "ije001" then
		arg_238_0:_startGuideFromCallback("ije001_continue")
		
		return 
	end
	
	if arg_238_1.map.enter == "vtutod004" then
		arg_238_0:_startGuideFromCallback("substory_hurdle")
		
		return 
	end
	
	if arg_238_1.map.enter == "vtutoa007" then
		arg_238_0:_startGuideFromCallback("substory_end")
		
		return 
	end
end

function TutorialGuide.onEncounterRoadEvent(arg_239_0, arg_239_1, arg_239_2)
	if arg_239_1.map.enter == "wrd_rehas034" then
		if arg_239_2.event_id == "wrd_rehas03400#6" and arg_239_0:_startGuideFromCallback("bkazran_use") and Battle:isAutoPlaying() then
			Battle:toggleAutoBattle()
		end
	elseif arg_239_1.map.enter == "ije001" then
		if arg_239_2.event_id == "ije00100#1" then
			if not arg_239_0:isClearedTutorial("ije001_object") or TEST_TUTORIAL then
				arg_239_0.field_box_model = BattleField:getRoadEventFieldModelByName("model/box_normal.scsp")
			end
		elseif arg_239_0.field_box_model and arg_239_2.event_id ~= "ije00100#1" then
			arg_239_0:procGuide("ije001_object")
		end
	elseif arg_239_1.map.enter == "ije009" then
		if arg_239_2.event_id == "ije00900_2" then
			if not arg_239_0:isClearedTutorial("chaosgate") or TEST_TUTORIAL then
				arg_239_0.field_chaos_model = BattleField:getRoadEventFieldModelByName("model/chaosgate.scsp")
			end
		elseif arg_239_2.event_id == "ije00900#1" and (not arg_239_0:isClearedTutorial("chaosgate") or TEST_TUTORIAL) then
			local var_239_0 = BattleField:getRoadEventFieldModel(arg_239_2)
			
			if get_cocos_refid(var_239_0) then
				arg_239_0:procGuide("chaosgate_object")
				
				if arg_239_0:_startGuideFromCallback("chaosgate") then
					BattlePopupMap:hide()
					UIOption:close()
					
					if Battle:isAutoPlaying() then
						Battle:toggleAutoBattle()
					end
					
					BattleLayout:setWalking(false)
				end
			end
		end
	end
end

function TutorialGuide.update(arg_240_0)
	if arg_240_0:isPlayingTutorial() then
		if arg_240_0.guide_info and arg_240_0.guide_info.clone_target and arg_240_0.guide_info.target_control then
			arg_240_0:_updateTargetPosition()
		end
	elseif arg_240_0.field_box_model then
		if arg_240_0.field_pos ~= BattleLayout:getFieldPosition() then
			arg_240_0.field_pos = BattleLayout:getFieldPosition()
			
			if not arg_240_0.dirty_tutorial.ije001_object and get_cocos_refid(arg_240_0.field_box_model) and arg_240_0.field_box_model:getPositionX() - (arg_240_0.field_pos + 420 + VIEW_WIDTH / 2) < 0 and arg_240_0:_startGuideFromCallback("ije001_object") then
				BattlePopupMap:hide()
				UIOption:close()
				
				arg_240_0.field_box_model = nil
			end
		end
	elseif arg_240_0.field_chaos_model and arg_240_0.field_pos ~= BattleLayout:getFieldPosition() then
		arg_240_0.field_pos = BattleLayout:getFieldPosition()
		
		if not arg_240_0.dirty_tutorial.chaosgate_object and get_cocos_refid(arg_240_0.field_chaos_model) and arg_240_0.field_chaos_model:getPositionX() - (arg_240_0.field_pos + 420 + VIEW_WIDTH / 2) < 0 and arg_240_0:_startGuideFromCallback("chaosgate_object") then
			BattlePopupMap:hide()
			UIOption:close()
			
			arg_240_0.field_chaos_model = nil
		end
	end
end

function TutorialGuide.onBattleUpdate(arg_241_0, arg_241_1)
end

function TutorialGuide.onUpdateMoral(arg_242_0, arg_242_1, arg_242_2)
	if not arg_242_1 then
		return 
	end
	
	if is_playing_story() then
		return 
	end
	
	if Battle.logic then
		if Battle.logic:isEnded() then
			return 
		end
		
		if not Battle.logic:isDungeonType() then
			return 
		end
		
		if arg_242_1 < 0 then
			if Battle.logic.map.enter == "bmznet002" or Battle.logic.map.enter == "bmznet003" then
				if arg_242_1 < -30 and (not arg_242_0:isClearedTutorial("insect_warning") or TEST_TUTORIAL) and STAGE_MODE.MOVE == Battle:getStageMode() and not BattlePopupMap:isShow() and not (Battle.logic:getCurrentRoadInfo() and Battle.logic:getCurrentRoadInfo().is_cross) and arg_242_0:_startGuideFromCallback("insect_warning") then
					if Battle:isAutoPlaying() then
						Battle:toggleAutoBattle()
					end
					
					BattleLayout:setWalking(false)
				end
			elseif (not arg_242_0:isClearedTutorial("maze_morale") or TEST_TUTORIAL) and Battle.logic:isDungeonType() and STAGE_MODE.MOVE == Battle:getStageMode() and not BattlePopupMap:isShow() and not (Battle.logic:getCurrentRoadInfo() and Battle.logic:getCurrentRoadInfo().is_cross) and arg_242_0:_startGuideFromCallback("maze_morale") then
				if Battle:isAutoPlaying() then
					Battle:toggleAutoBattle()
				end
				
				BattleLayout:setWalking(false)
			end
		end
	end
end

function TutorialGuide.getTutorialID(arg_243_0, arg_243_1)
	return (DB("tutorial_guide", arg_243_1 .. "_01", "id"))
end
