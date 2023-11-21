MissionNavigatorCommon = MissionNavigatorCommon or {}

local var_0_0 = {
	MONSTER = 2,
	INFOMATION = 1
}

function MsgHandler.get_quest_chapter_reward(arg_1_0)
	if arg_1_0.cur_chapter_quest then
		local var_1_0 = ConditionContentsManager:getQuestMissions()
		
		var_1_0:setQuestAccountData({
			mission_id = arg_1_0.cur_chapter_key,
			chapter_q = arg_1_0.cur_chapter_quest
		})
		var_1_0:setQuestAccountData({
			mission_id = arg_1_0.next_chapter_key,
			chapter_q = arg_1_0.chapter_quest
		})
		
		if arg_1_0.cur_ep_id and arg_1_0.cur_ep_quest then
			var_1_0:setQuestAccountData({
				mission_id = arg_1_0.cur_ep_id,
				episode_q = arg_1_0.cur_ep_quest
			})
		end
	end
	
	popup_data = {}
	
	ConditionContentsManager:getQuestMissions():updateQuestMissions()
	AdvMissionNavigator:unsetTouchHandler()
	AdvMissionNavigator:updateData()
	AdvMissionNavigator:updateQuestMissionList({
		no_header = true
	})
	
	if ConditionContentsManager:getQuestMissions():hasNextQuest() or ConditionContentsManager:getQuestMissions():isAllReceivedRewards() == false then
		AdvMissionNavigator:onActionChapterOpen()
		
		popup_data.delay = 4000
	end
	
	AdvMissionNavigator:updateQuest()
	
	popup_data.title = T("quest_chapter_reward_title")
	popup_data.desc = T("quest_chapter_reward_msg")
	
	Account:addReward(arg_1_0.rewards, {
		play_reward_data = popup_data
	})
	Singular:event(arg_1_0.cur_chapter_key .. "_reward")
end

function MsgHandler.get_reward_quest(arg_2_0)
	ConditionContentsManager:getQuestMissions():setQuestAccountData({
		mission_id = arg_2_0.quest_key,
		quest = arg_2_0.quest
	})
	AdvMissionNavigator:updateQuestMissionList({
		no_reward_eff = true
	})
	AdvMissionNavigator:updateQuest()
	TutorialGuide:onReceivedQuest(arg_2_0.quest_key)
	
	local var_2_0 = {
		title = T("quest_reward_title"),
		desc = T("quest_reward_msg")
	}
	
	if arg_2_0.rewards and arg_2_0.rewards.new_units then
		for iter_2_0, iter_2_1 in pairs(arg_2_0.rewards.new_units) do
			if DB("character", iter_2_1.code, "type") == "summon" then
				var_2_0 = nil
				
				local var_2_1 = SceneManager:getDefaultLayer()
				
				UnitSummonResult:ShowCharGet(iter_2_1.code, var_2_1, nil, {
					is_summon = true
				})
			end
		end
	end
	
	Account:addReward(arg_2_0.rewards, {
		play_reward_data = var_2_0
	})
end

function MsgHandler.get_reward_quest_all(arg_3_0)
	ConditionContentsManager:getQuestMissions():setQuestInfos(arg_3_0.infos)
	AdvMissionNavigator:updateQuestMissionList({
		no_reward_eff = true
	})
	AdvMissionNavigator:updateQuest()
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.infos or {}) do
		if TutorialGuide:onReceivedQuest(iter_3_0) then
			break
		end
	end
	
	if arg_3_0.rewards and arg_3_0.rewards.new_units then
		for iter_3_2, iter_3_3 in pairs(arg_3_0.rewards.new_units) do
			if DB("character", iter_3_3.code, "type") == "summon" then
				popup_data = nil
				
				local var_3_0 = SceneManager:getDefaultLayer()
				
				UnitSummonResult:ShowCharGet(iter_3_3.code, var_3_0, nil, {
					is_summon = true
				})
				
				break
			end
		end
	end
	
	local var_3_1 = Account:addReward(arg_3_0.rewards)
	
	Dialog:msgScrollRewards(T("quest_reward_popup_desc"), {
		open_effect = true,
		title = T("quest_reward_popup_title"),
		rewards = {
			new_items = var_3_1.rewards
		}
	})
end

function HANDLER.mission_item(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_place_go" then
		if arg_4_0.urgent_mission then
			UrgentMissionMove:showReady(arg_4_0.map_id)
		else
			getParentWindow(arg_4_0).parent:shortcut(arg_4_0.mission_id, arg_4_0.mission_state, arg_4_0.map_id, arg_4_0.short_cut)
		end
	elseif arg_4_1 == "btn_detail" then
		SubstoryQuestLinkAchieve:show(nil, arg_4_0.quest_id)
	end
end

function HANDLER.mission_base(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_worldmap_block" then
		getParentWindow(arg_5_0).parent:backNavi()
	end
	
	if arg_5_1 == "btn_quest" then
		getParentWindow(arg_5_0).parent:openNavi("QUEST")
	end
	
	if arg_5_1 == "btn_all_quest" then
		local var_5_0 = getParentWindow(arg_5_0).parent
		
		if var_5_0 and var_5_0.queryRewardQuestAll then
			var_5_0:queryRewardQuestAll()
		end
	end
	
	if arg_5_1 == "btn_time" and getParentWindow(arg_5_0).parent:openNavi("URGENT") then
		TutorialGuide:procGuide()
	end
	
	if arg_5_1 == "btn_vampire" then
		if arg_5_0.is_blocked then
			balloon_message_with_sound("ep5_tree_err_00")
		else
			getParentWindow(arg_5_0).parent:openNavi("VAM")
			getParentWindow(arg_5_0).parent:backNavi()
		end
	end
	
	if arg_5_1 == "btn_elf" then
		if arg_5_0.is_blocked then
			balloon_message_with_sound("ep5_tree_err_00")
		else
			getParentWindow(arg_5_0).parent:openNavi("S_ELF")
			getParentWindow(arg_5_0).parent:backNavi()
		end
	end
	
	if arg_5_1 == "btn_info" then
		getParentWindow(arg_5_0).parent:openNavi("INFO")
	end
	
	if arg_5_1 == "btn_shop" then
		if EpisodeForce:getForceID() then
			ShopChapterForce:query()
			
			return 
		else
			ShopChapter:query()
			TutorialGuide:startGuide("system_099")
			
			return 
		end
	end
	
	if arg_5_1 == "btn_questreward" then
		if getParentWindow(arg_5_0).parent.controller.vars.type == WORLDMAP_TYPE.ADV then
			local var_5_1 = ConditionContentsManager:getQuestMissions()
			local var_5_2 = var_5_1:getUIChapterMissionId()
			local var_5_3 = var_5_1:getChapterData(var_5_2)
			
			if var_5_3 and var_5_3.state == "received" then
				balloon_message_with_sound("mission_last_ch")
			elseif var_5_1:isAllReceivedQuestReward() then
				query("get_quest_chapter_reward", {
					mission_id = ConditionContentsManager:getQuestMissions():getUIChapterMissionId()
				})
			else
				balloon_message_with_sound("quest_chapter_fail")
			end
		elseif getParentWindow(arg_5_0).parent.controller.vars.type == WORLDMAP_TYPE.SUB_STORY or getParentWindow(arg_5_0).parent.controller.vars.type == WORLDMAP_TYPE.CUSTOM then
			if SubstoryManager:isAllReceivedQuestReward() then
				query("get_substory_quest_chapter_reward", {
					substory_id = SubstoryManager:getInfo().id
				})
			else
				balloon_message_with_sound("quest_chapter_fail")
			end
		end
	end
	
	if arg_5_1 == "btn_quest_list" then
		balloon_message_with_sound("notyet_dev")
	end
	
	if arg_5_1 == "btn_main_tab1" then
		getParentWindow(arg_5_0).parent:selectInfoMainTab(var_0_0.INFOMATION)
	end
	
	if arg_5_1 == "btn_main_tab2" then
		getParentWindow(arg_5_0).parent:selectInfoMainTab(var_0_0.MONSTER)
	end
	
	if arg_5_1 == "btn_move" then
		movetoPath(arg_5_0.btn_move)
		getParentWindow(arg_5_0).parent:backNavi()
	end
	
	if arg_5_1 == "btn_cshop_go" then
		ShopChapter:onBtnGo(arg_5_0)
	end
	
	if (arg_5_1 == "btn_ep" or arg_5_1 == "btn_ep_sel_icon") and not BattleReady:isShow() then
		getParentWindow(arg_5_0).parent:backNavi()
		WorldMapEpisodeList:show()
		
		return 
	end
	
	if arg_5_1 == "btn_change" then
		local var_5_4 = ShopChapterUtil:getShopChatperObj(true)
		
		if var_5_4 then
			var_5_4:query()
		end
		
		return 
	end
	
	if arg_5_1 == "btn_rare_catalyst" then
		ShopChapter:epilogue_set_mode("rare")
	elseif arg_5_1 == "btn_legendary_catalyst" then
		ShopChapter:epilogue_set_mode("legendary")
	end
	
	if arg_5_1 == "btn_vampire" then
	elseif arg_5_1 == "btn_elf" then
	end
end

function MissionNavigatorCommon.getWnd(arg_6_0)
	return arg_6_0.wnd
end

function MissionNavigatorCommon.isOpenNavi(arg_7_0)
	return arg_7_0.isOpen
end

function MissionNavigatorCommon.backNavi(arg_8_0)
	if arg_8_0.isOpen then
		SoundEngine:play("event:/ui/slide_close")
	end
	
	MissionNavigatorMonsterInfo:hide()
	UIAction:Add(SEQ(MOVE_TO(50, DESIGN_WIDTH - VIEW_BASE_LEFT + NotchStatus:getNotchSafeRight())), arg_8_0.parent.RIGHT, "block")
	
	arg_8_0.isOpen = false
	
	arg_8_0:unsetTouchHandler()
	
	arg_8_0.mode = "NONE"
	
	local var_8_0 = arg_8_0.wnd:getChildByName("btn_questreward")
	
	while get_cocos_refid(var_8_0:getChildByName("@UI_CHAPTER_REWARD")) do
		var_8_0:removeChildByName("@UI_CHAPTER_REWARD")
	end
	
	if_set_visible(arg_8_0.parent_ui, "dim_img", false)
	if_set_visible(arg_8_0.parent.RIGHT, "n_right_back", false)
	
	if arg_8_0.controller and arg_8_0.controller:canOpenAdin() then
		if_set_visible(arg_8_0.parent.RIGHT, "n_adin", true)
	end
	
	arg_8_0:touchIgnore(false)
	arg_8_0.parent:setVisibleWorldMapUI(true)
	arg_8_0.parent:setVisibleDefault()
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.ui_list) do
		iter_8_1:setVisible(false)
	end
	
	arg_8_0:setVisiblePortrait(false)
	arg_8_0:setVisibleForceUI(false)
	
	for iter_8_2, iter_8_3 in pairs(arg_8_0.ui_cursor_list) do
		iter_8_3:setVisible(false)
	end
	
	BackButtonManager:pop({
		check_id = "MissionNavigatorCommon",
		dlg = arg_8_0.wnd
	})
end

local var_0_1 = DESIGN_WIDTH - 630 - VIEW_BASE_LEFT + NotchStatus:getNotchSafeRight()

function MissionNavigatorCommon.setVisiblePortrait(arg_9_0, arg_9_1)
	if arg_9_0.n_npc_portrait:isVisible() == arg_9_1 then
		return 
	end
	
	if arg_9_1 and EpisodeForce:getForceID() and arg_9_1 == true then
		return 
	end
	
	arg_9_0.n_npc_portrait:setVisible(arg_9_1)
end

function MissionNavigatorCommon.setVisibleForceUI(arg_10_0, arg_10_1)
	if arg_10_1 and EpisodeForce:getForceID() == nil then
		arg_10_0.n_force:setVisible(false)
		arg_10_0.n_npc_force:setVisible(false)
		
		return 
	end
	
	arg_10_0.n_force:setVisible(arg_10_1)
	arg_10_0.n_npc_force:setVisible(arg_10_1)
end

function MissionNavigatorCommon.openNavi(arg_11_0, arg_11_1)
	if get_cocos_refid(arg_11_0.controller.vars.cloud_effect) then
		return false
	end
	
	if arg_11_0.isOpen and arg_11_0.mode == arg_11_1 then
		return false
	end
	
	if not arg_11_0.isOpen then
		SoundEngine:play("event:/ui/slide_open")
	end
	
	arg_11_0:unsetTouchHandler()
	arg_11_0:show(arg_11_1)
	arg_11_0:updateInfomation_open()
	
	local var_11_0 = var_0_1
	
	if arg_11_1 == "SHOP" then
		var_11_0 = var_0_1 - 70
	end
	
	if arg_11_1 == "S_ELF" or arg_11_1 == "VAM" then
		var_11_0 = DESIGN_WIDTH - VIEW_BASE_LEFT + NotchStatus:getNotchSafeRight()
	end
	
	if not arg_11_0.isOpen then
		NotchManager:setActionResetOriginPos(arg_11_0.parent.RIGHT, true)
		UIAction:Add(SEQ(MOVE_TO(80, var_11_0), DELAY(100), CALL(function()
			arg_11_0:updateInfomation_openEnd()
		end)), arg_11_0.parent.RIGHT, "block")
		BackButtonManager:push({
			check_id = "MissionNavigatorCommon",
			back_func = function()
				arg_11_0:backNavi()
			end,
			dlg = arg_11_0.wnd
		})
	else
		arg_11_0:updateInfomation_openEnd()
	end
	
	if_set_visible(arg_11_0.parent.RIGHT, "n_right_back", true)
	if_set_visible(arg_11_0.parent_ui, "n_adin", false)
	if_set_visible(arg_11_0.parent_ui, "dim_img", true)
	
	arg_11_0.isOpen = true
	
	arg_11_0.parent:setVisibleWorldMapUI(false)
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		TutorialNotice:update("worldmap_scene")
	end)), "delay")
	
	return true
end

copy_functions(ScrollView, MissionNavigatorCommon)

function MissionNavigatorCommon.init(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0:initUI(arg_15_1, arg_15_2, arg_15_3)
	
	local var_15_0 = arg_15_0.wnd:getChildByName("btn_time")
	
	UIUtil:changeBtnUnlockState(var_15_0, "img/cm_icon_etclock.png", UnlockSystem:isUnlockSystem(UNLOCK_ID.URGENT_MISSION), arg_15_0.wnd, {
		lock_opacity = 0.3,
		scale = 1,
		pos_x = var_15_0:getPositionX() + 23,
		pos_y = var_15_0:getPositionY() - 2
	})
	
	local var_15_1 = arg_15_0.wnd:getChildByName("btn_shop")
	
	UIUtil:changeBtnUnlockState(var_15_1, "img/cm_icon_etclock.png", UnlockSystem:isUnlockSystem(UNLOCK_ID.LOCAL_SHOP), arg_15_0.wnd, {
		lock_opacity = 0.3,
		scale = 1,
		pos_x = var_15_1:getPositionX() + 23,
		pos_y = var_15_1:getPositionY() - 2
	})
	arg_15_0:playEffectChapterReward()
end

function MissionNavigatorCommon.initUI(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0.wnd = load_dlg("mission_base", true, "wnd")
	arg_16_0.wnd.parent = arg_16_0
	
	arg_16_1:addChild(arg_16_0.wnd)
	arg_16_0.wnd:setPosition(0, 0)
	arg_16_0.wnd:setAnchorPoint(0, 0)
	
	arg_16_0.isOpen = false
	arg_16_0.btn_worldmap_block = arg_16_0.wnd:getChildByName("btn_worldmap_block")
	
	arg_16_0.btn_worldmap_block:setLocalZOrder(-300)
	
	arg_16_0.panel_touch_ignore = arg_16_0.wnd:getChildByName("touch_ignore")
	
	arg_16_0.panel_touch_ignore:setLocalZOrder(-300)
	
	arg_16_0.quest_ui = arg_16_0.wnd:getChildByName("n_quest")
	arg_16_0.urgent_ui = arg_16_0.wnd:getChildByName("n_urgent")
	arg_16_0.infomation_ui = arg_16_0.wnd:getChildByName("n_info")
	arg_16_0.shop_ui = arg_16_0.wnd:getChildByName("n_shop")
	arg_16_0.tree_vam_ui = arg_16_0.wnd:getChildByName("n_tree_orign_vampire")
	arg_16_0.tree_s_elf_ui = arg_16_0.wnd:getChildByName("n_tree_orign_elf")
	
	arg_16_0.quest_ui:setVisible(false)
	arg_16_0.urgent_ui:setVisible(false)
	arg_16_0.infomation_ui:setVisible(false)
	arg_16_0.shop_ui:setVisible(false)
	arg_16_0.tree_vam_ui:setVisible(false)
	arg_16_0.tree_s_elf_ui:setVisible(false)
	
	arg_16_0.controller = arg_16_2
	arg_16_0.parent = arg_16_3
	arg_16_0.parent_ui = arg_16_3:getWnd()
	arg_16_0.n_npc_portrait = arg_16_0.parent_ui:getChildByName("n_npc_portrait")
	arg_16_0.n_force = arg_16_0.parent_ui:getChildByName("n_force")
	arg_16_0.n_npc_force = arg_16_0.parent_ui:getChildByName("n_npc_force")
	arg_16_0.ui_list = {}
	arg_16_0.ui_list.QUEST = arg_16_0.quest_ui
	arg_16_0.ui_list.URGENT = arg_16_0.urgent_ui
	arg_16_0.ui_list.INFO = arg_16_0.infomation_ui
	arg_16_0.ui_list.SHOP = arg_16_0.shop_ui
	arg_16_0.ui_cursor_list = {}
	arg_16_0.ui_icon_list = {}
	
	local var_16_0 = arg_16_0.wnd:getChildByName("n_quest_")
	
	arg_16_0.ui_icon_list.QUEST = var_16_0
	arg_16_0.ui_cursor_list.QUEST = var_16_0:getChildByName("cursor")
	
	local var_16_1 = arg_16_0.wnd:getChildByName("n_time_")
	
	arg_16_0.ui_icon_list.URGENT = var_16_1
	arg_16_0.ui_cursor_list.URGENT = var_16_1:getChildByName("cursor")
	
	local var_16_2 = arg_16_0.wnd:getChildByName("n_info_")
	
	arg_16_0.ui_icon_list.INFO = var_16_2
	arg_16_0.ui_cursor_list.INFO = var_16_2:getChildByName("cursor")
	
	local var_16_3 = arg_16_0.wnd:getChildByName("n_shop_")
	
	arg_16_0.ui_icon_list.SHOP = var_16_3
	arg_16_0.ui_cursor_list.SHOP = var_16_3:getChildByName("cursor")
	
	local var_16_4 = arg_16_0.wnd:getChildByName("n_tree_orign_vampire")
	
	arg_16_0.ui_icon_list.VAM = var_16_4
	arg_16_0.ui_cursor_list.VAM = var_16_4:getChildByName("cursor")
	
	local var_16_5 = arg_16_0.wnd:getChildByName("n_tree_orign_elf")
	
	arg_16_0.ui_icon_list.S_ELF = var_16_5
	arg_16_0.ui_cursor_list.S_ELF = var_16_5:getChildByName("cursor")
	
	local var_16_6 = arg_16_0.urgent_ui:getChildByName("n_header_pos")
	local var_16_7 = arg_16_0.quest_ui:getChildByName("n_header_pos")
	
	arg_16_0.header_quest_wnd = load_dlg("mission_header", true, "wnd")
	
	arg_16_0.quest_ui:addChild(arg_16_0.header_quest_wnd)
	arg_16_0.header_quest_wnd:setPosition(var_16_7:getPosition())
	if_set_visible(arg_16_0.header_quest_wnd, "n_quest", true)
	if_set_visible(arg_16_0.header_quest_wnd, "n_urgent", false)
	
	if arg_16_0.btn_worldmap_block then
		arg_16_0.btn_worldmap_block:setVisible(false)
	end
	
	arg_16_0.ug_scroll = arg_16_0.urgent_ui:getChildByName("scrollview")
	
	arg_16_0.ug_scroll:setLocalZOrder(300)
	
	arg_16_0.quest_scroll = arg_16_0.quest_ui:getChildByName("scrollview")
	
	arg_16_0.quest_scroll:setLocalZOrder(301)
	
	arg_16_0.mode = "NONE"
	arg_16_0.rewardIcons = {}
	arg_16_0.shortcut_listener = {}
	arg_16_0.data = {}
	
	arg_16_0:updateUrgentMission()
	if_set_visible(arg_16_0.wnd, "n_talk_guide", false)
	
	arg_16_0.info_tab = var_0_0.INFOMATION
	
	ChapterMonsterData:setChapterInfos()
	MissionNavigatorInfo:init(arg_16_0.infomation_ui, arg_16_0)
	MissionNavigatorMonsterInfo:init(arg_16_0.infomation_ui, arg_16_0)
	MissionNavigatorMonsterInfo:hide()
	arg_16_0:setEnableContentsUI()
end

function MissionNavigatorCommon.UpdateAfterShowTown(arg_17_0, arg_17_1)
	arg_17_0:updateLocalStoreNoti(arg_17_1)
	if_set_visible(arg_17_0.wnd, "img_noti_new", NewChapterNavigator:isNew())
	arg_17_0:updateIcons(arg_17_1)
end

function MissionNavigatorCommon.getTreeNodeForTutorial(arg_18_0)
	if not get_cocos_refid(arg_18_0.wnd) then
		return 
	end
	
	local var_18_0 = arg_18_0.wnd:getChildByName("n_tree_orign_elf")
	local var_18_1 = arg_18_0.wnd:getChildByName("n_tree_orign_vampire")
	
	if not get_cocos_refid(var_18_1) or not get_cocos_refid(var_18_0) then
		return 
	end
	
	if var_18_1:isVisible() then
		return var_18_1:getChildByName("btn_vampire")
	else
		return var_18_0:getChildByName("btn_elf")
	end
end

function MissionNavigatorCommon.updateIcons(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = DBT("level_world_3_chapter", arg_19_1, {
		"id",
		"navi_hide_info",
		"navi_hide_shop",
		"navi_extension"
	})
	
	if not var_19_0 or not var_19_0.id then
		return 
	end
	
	local var_19_1 = var_19_0.navi_hide_info and var_19_0.navi_hide_info == "y"
	local var_19_2 = var_19_0.navi_hide_shop and var_19_0.navi_hide_shop == "y"
	local var_19_3 = var_19_0.navi_extension
	
	if_set_visible(arg_19_0.wnd, "n_info_", not var_19_1)
	if_set_visible(arg_19_0.wnd, "n_shop_", not var_19_2)
	UnlockSystem:setUnlockUIState(arg_19_0.ui_icon_list.VAM, "btn_vampire", UNLOCK_ID.ORIGIN_TREE_VAM, {
		no_color = false
	})
	UnlockSystem:setUnlockUIState(arg_19_0.ui_icon_list.S_ELF, "btn_elf", UNLOCK_ID.ORIGIN_TREE_ELF, {
		no_color = false
	})
	
	local var_19_4 = 0
	
	if var_19_3 and string.starts(var_19_3, "tree") then
		local var_19_5 = string.split(var_19_3, "=")[2]
		
		if not var_19_5 then
			return 
		end
		
		if_set_visible(arg_19_0.wnd, "n_tree_orign_elf", var_19_5 == "s_elf")
		if_set_visible(arg_19_0.wnd, "n_tree_orign_vampire", var_19_5 == "vam")
		
		var_19_4 = 28
		
		arg_19_0:setTreeIcons(true)
		
		local var_19_6 = arg_19_0.wnd:getChildByName("n_tree_orign_elf")
		local var_19_7 = arg_19_0.wnd:getChildByName("n_tree_orign_vampire")
		
		if get_cocos_refid(var_19_6) and get_cocos_refid(var_19_7) then
			local var_19_8 = OriginTree:updateNotiOnMissionBaseUI(var_19_5)
			
			if_set_visible(var_19_6, "icon_noti", var_19_8)
			if_set_visible(var_19_7, "icon_noti", var_19_8)
		end
	else
		var_19_4 = 0
		
		if_set_visible(arg_19_0.wnd, "n_tree_orign_elf", false)
		if_set_visible(arg_19_0.wnd, "n_tree_orign_vampire", false)
		arg_19_0:setTreeIcons(false)
	end
	
	local var_19_9 = arg_19_0.wnd:getChildByName("n_time_")
	
	if get_cocos_refid(var_19_9) then
		if not var_19_9.origin_pos_y then
			var_19_9.origin_pos_y = var_19_9:getPositionY()
		end
		
		var_19_9:setPositionY(var_19_9.origin_pos_y - var_19_4)
	end
end

function MissionNavigatorCommon.setTreeIcons(arg_20_0, arg_20_1)
	if not get_cocos_refid(arg_20_0.wnd) then
		return 
	end
	
	local var_20_0 = arg_20_0.wnd:getChildByName("btn_vampire")
	local var_20_1 = arg_20_0.wnd:getChildByName("btn_elf")
	
	if get_cocos_refid(var_20_1) and get_cocos_refid(var_20_0) then
		var_20_0.is_blocked = not arg_20_1
		var_20_1.is_blocked = not arg_20_1
		
		if_set_opacity(var_20_0, nil, arg_20_1 and 255 or 76.5)
		if_set_opacity(var_20_1, nil, arg_20_1 and 255 or 76.5)
	end
end

function MissionNavigatorCommon.updateLocalStoreNoti(arg_21_0, arg_21_1)
	local var_21_0 = false
	local var_21_1 = ShopChapterUtil:getShopChatperObj()
	
	if var_21_1 and var_21_1.isBtnNoti and var_21_1.updatePopupBtnNoti then
		var_21_0 = var_21_1:isBtnNoti()
		
		var_21_1:updatePopupBtnNoti(var_21_0)
	end
	
	if_set_visible(arg_21_0.wnd, "local_store_noti", var_21_0)
	ShopChapterPopupChapterList:updateScrollItems()
end

function MissionNavigatorCommon.setEnableContentsUI(arg_22_0)
end

function MissionNavigatorCommon.playEffectChapterReward(arg_23_0)
	local var_23_0 = ConditionContentsManager:getQuestMissions()
	local var_23_1 = var_23_0:getUIChapterMissionId()
	local var_23_2 = var_23_0:getChapterData(var_23_1)
	
	if var_23_2 and var_23_2.state == "clear" then
		local var_23_3 = arg_23_0.wnd:getChildByName("n_talk_guide")
		
		if var_23_3 then
			var_23_3:setVisible(true)
			UIAction:Add(SEQ(DELAY(3500), FADE_OUT(500)), var_23_3, "chapter_reward_guide")
		end
	end
end

function MissionNavigatorCommon.playEff_shortcut(arg_24_0)
	arg_24_0.controller:playCloudEffect(arg_24_0.parent.layer)
	set_high_fps_tick(1000)
end

function MissionNavigatorCommon.showMapDialog(arg_25_0, arg_25_1)
	arg_25_0.controller:showMapDialog(arg_25_1[4])
end

function MissionNavigatorCommon.shortcut(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	if arg_26_2 == "active" then
		SoundEngine:play("event:/ui/ok")
		print("이 여정으로 바로가기!")
		arg_26_0:backNavi()
		movetoPath(arg_26_4)
	elseif arg_26_2 == "clear" then
		SoundEngine:play("event:/ui/price_clear")
		query("get_reward_quest", {
			mission_id = arg_26_1
		})
	elseif arg_26_2 == "received" then
		balloon_message_with_sound("quest_chapter_after_clear")
	else
		balloon_message_with_sound("quest_not_yet_unexecutable")
	end
end

function MissionNavigatorCommon.updateQuest(arg_27_0)
	local var_27_0 = 0
	local var_27_1 = ConditionContentsManager:getQuestMissions():getNotiCount()
	
	if get_cocos_refid(arg_27_0.wnd) then
		local var_27_2 = arg_27_0.wnd:getChildByName("btn_quest")
		
		if get_cocos_refid(var_27_2) then
			if_set_visible(var_27_2, "icon_new", var_27_1 > 0)
			if_set(var_27_2, "label_icon_new", var_27_1)
		end
	end
end

function MissionNavigatorCommon.updateUrgentMission(arg_28_0)
	if not get_cocos_refid(arg_28_0.wnd) then
		return 
	end
	
	local var_28_0 = ConditionContentsManager:getUrgentMissions():getActiveMissionCount()
	local var_28_1 = arg_28_0.wnd:getChildByName("btn_time")
	
	if get_cocos_refid(var_28_1) then
		if_set_visible(var_28_1, "count_bg", var_28_0 > 0)
		if_set(var_28_1, "label_count", var_28_0)
	end
end

function MissionNavigatorCommon.unsetTouchHandler(arg_29_0)
	for iter_29_0, iter_29_1 in pairs(arg_29_0.rewardIcons) do
		if iter_29_1 then
			SceneManager:unsetTouchHandler(iter_29_1)
		end
	end
end

function MissionNavigatorCommon.show(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_0.mode == arg_30_1 and not arg_30_2 then
		return 
	end
	
	if arg_30_1 == "NONE" then
		return 
	end
	
	arg_30_0.mode = arg_30_1
	
	local var_30_0 = 600
	local var_30_1 = 155
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.ui_list) do
		iter_30_1:setVisible(iter_30_0 == arg_30_0.mode)
	end
	
	for iter_30_2, iter_30_3 in pairs(arg_30_0.ui_cursor_list) do
		iter_30_3:setVisible(iter_30_2 == arg_30_0.mode)
	end
	
	local var_30_2 = false
	
	arg_30_0:touchIgnore(true)
	
	var_0_1 = DESIGN_WIDTH - 630 - VIEW_BASE_LEFT + NotchStatus:getNotchSafeRight()
	
	local var_30_3 = var_0_1
	
	if arg_30_0.mode == "QUEST" then
		arg_30_0.quest_scroll:setContentSize(600, 390)
		arg_30_0:initScrollView(arg_30_0.quest_scroll, var_30_0, var_30_1)
		arg_30_0:updateQuestMissionList()
	elseif arg_30_0.mode == "URGENT" then
		arg_30_0:initScrollView(arg_30_0.ug_scroll, var_30_0, var_30_1)
		arg_30_0:updateUrgentMissionList()
	elseif arg_30_0.mode == "INFO" then
		TutorialGuide:procGuide()
	elseif arg_30_0.mode == "SHOP" then
		var_30_3 = var_30_3 - 70
		var_30_2 = true
	elseif arg_30_0.mode == "VAM" or arg_30_0.mode == "S_ELF" then
		var_30_3 = DESIGN_WIDTH - VIEW_BASE_LEFT + NotchStatus:getNotchSafeRight()
		
		OriginTree:open(string.lower(arg_30_0.mode))
	end
	
	arg_30_0:setVisiblePortrait(var_30_2)
	arg_30_0:setVisibleForceUI(var_30_2)
	UIAction:Add(SEQ(MOVE_TO(100, var_30_3)), arg_30_0.parent.RIGHT, "block")
end

function MissionNavigatorCommon.touchIgnore(arg_31_0, arg_31_1)
	if arg_31_0.btn_worldmap_block then
		arg_31_0.btn_worldmap_block:setVisible(arg_31_1)
	end
	
	arg_31_0.panel_touch_ignore:setVisible(arg_31_1)
end

function MissionNavigatorCommon.updateData(arg_32_0)
	local var_32_0 = {}
	local var_32_1 = true
	local var_32_2 = ConditionContentsManager:getQuestMissions()
	local var_32_3 = var_32_2:getUIChapterKey()
	local var_32_4 = {
		received = 0,
		clear = 3,
		active = 2,
		ready = 1
	}
	
	for iter_32_0 = 1, 99 do
		local var_32_5 = var_32_3 .. "_" .. iter_32_0
		local var_32_6, var_32_7 = DB("mission_data", var_32_5, {
			"id",
			"value"
		})
		
		if var_32_7 then
			local var_32_8 = var_32_2:getQuestData(var_32_5) or {}
			local var_32_9 = var_32_2:getScore(var_32_5)
			
			table.insert(var_32_0, {
				id = var_32_5,
				sort = iter_32_0,
				state = var_32_8.state or "ready",
				score = var_32_9 or 0
			})
		end
		
		if not var_32_6 then
			break
		end
	end
	
	table.sort(var_32_0, function(arg_33_0, arg_33_1)
		local var_33_0 = arg_33_0.state or "received"
		local var_33_1 = arg_33_1.state or "received"
		
		if var_33_0 == var_33_1 then
			return arg_33_0.sort < arg_33_1.sort
		else
			return var_32_4[var_33_0] > var_32_4[var_33_1]
		end
	end)
	
	arg_32_0.data = var_32_0
end

function MissionNavigatorCommon.updateQuestMissionList(arg_34_0, arg_34_1)
	arg_34_1 = arg_34_1 or {}
	
	if arg_34_0.mode ~= "QUEST" then
		return 
	end
	
	if not arg_34_0.wnd then
		return 
	end
	
	local var_34_0 = ConditionContentsManager:getQuestMissions()
	local var_34_1 = var_34_0:getUIChapterKey()
	local var_34_2 = var_34_0:getUIChapterMissionId()
	
	arg_34_0:updateData()
	arg_34_0:createScrollViewItems(arg_34_0.data)
	
	if not arg_34_1.no_header then
		arg_34_0:setHeader_quest()
	end
	
	if var_34_0:isAllClearEpisode() then
		arg_34_0.wnd:getChildByName("scrollview"):setVisible(false)
	end
	
	local var_34_3 = var_34_0:getNotiCount() > 0
	local var_34_4 = var_34_0:isAllClearQuestInChapter()
	
	if not var_34_0:isClearedChapter(var_34_2) and var_34_4 == false and var_34_3 == false then
		if_set_visible(arg_34_0.wnd, "n_clear", false)
		if_set_opacity(arg_34_0.wnd, "n_clear", 255)
		if_set_visible(arg_34_0.wnd, "n_all_reward", false)
		
		local var_34_5 = arg_34_0.wnd:getChildByName("scrollview")
		
		var_34_5:setPositionY(arg_34_0.wnd:getChildByName("scroll_pos_1"):getPositionY())
		var_34_5:setContentSize(600, 450)
		var_34_5:scrollToTop(0, false)
	elseif var_34_3 then
		if_set_visible(arg_34_0.wnd, "n_clear", false)
		
		local var_34_6 = arg_34_0.wnd:getChildByName("n_all_reward")
		
		var_34_6:setVisible(true)
		
		local var_34_7 = arg_34_0.wnd:getChildByName("scrollview")
		
		var_34_7:setContentSize(600, 347)
		var_34_7:scrollToTop(0, false)
		var_34_7:setPositionY(arg_34_0.wnd:getChildByName("scroll_pos_2"):getPositionY())
		if_set(var_34_6, "txt_title", T("quest_chapter_ui_title2"))
		if_set(var_34_6, "txt_desc", T("quest_chapter_ui_desc2"))
		
		local var_34_8 = var_34_6:getChildByName("n_eff")
		
		var_34_8:setVisible(true)
		arg_34_0:playQuestRewardEffect(var_34_8, "quest", arg_34_1)
	else
		local var_34_9 = arg_34_0.wnd:getChildByName("n_clear")
		
		var_34_9:setVisible(true)
		var_34_9:setOpacity(255)
		if_set_visible(arg_34_0.wnd, "n_all_reward", false)
		
		local var_34_10 = var_34_0:getChapterData(var_34_2)
		
		if var_34_10 and var_34_10.state == "clear" then
			local var_34_11 = arg_34_0.wnd:getChildByName("scrollview")
			
			var_34_11:setContentSize(600, 347)
			var_34_11:scrollToTop(0, false)
			var_34_11:setPositionY(arg_34_0.wnd:getChildByName("scroll_pos_2"):getPositionY())
			
			local var_34_12 = var_34_0.chapter_m_id
			local var_34_13, var_34_14, var_34_15, var_34_16, var_34_17 = DB("mission_data", var_34_12, {
				"name",
				"name2",
				"desc",
				"reward_id1",
				"reward_count1"
			})
			
			if_set(arg_34_0.wnd, "txt_desc_0", T("quest_chapter_ui_title"))
			if_set(arg_34_0.wnd, "txt_desc", T("quest_chapter_ui_desc"))
			if_set(arg_34_0.wnd, "btn_questreward_label", T("mission_clear_prize"))
			arg_34_0.wnd:getChildByName("btn_questreward"):setVisible(true)
			
			local var_34_18 = var_34_9:getChildByName("n_eff")
			
			var_34_18:setVisible(true)
			arg_34_0:playQuestRewardEffect(var_34_18, "chapter", arg_34_1)
		elseif not var_34_10 or var_34_10 and var_34_10.state == "received" then
			arg_34_0.wnd:getChildByName("scrollview"):setPositionY(arg_34_0.wnd:getChildByName("scroll_pos_2"):getPositionY())
			if_set_visible(arg_34_0.wnd, "n_all_reward", false)
			if_set_visible(arg_34_0.wnd, "btn_questreward", false)
			if_set(arg_34_0.wnd, "txt_desc_0", T("quest_chapter_ui_title"))
			
			if not var_34_0:hasNextQuest() then
				if_set(arg_34_0.wnd, "txt_desc", T("mission_no_ep"))
				
				local var_34_19 = arg_34_0.wnd:getChildByName("n_clear")
				
				if get_cocos_refid(var_34_19) then
					local var_34_20 = var_34_19:getChildByName("n_eff")
					
					if get_cocos_refid(var_34_20) then
						var_34_20:setVisible(false)
					end
				end
			end
		end
	end
	
	if false then
	end
end

function MissionNavigatorCommon.playQuestRewardEffect(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if not arg_35_2 then
		return 
	end
	
	if not arg_35_3.no_reward_eff then
		while get_cocos_refid(arg_35_1:getChildByName("@UI_CHAPTER_REWARD." .. arg_35_2)) do
			arg_35_1:removeChildByName("@UI_CHAPTER_REWARD." .. arg_35_2)
		end
		
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_clear_reward.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			node_name = "@UI_CHAPTER_REWARD." .. arg_35_2,
			layer = arg_35_1
		})
	end
end

function MissionNavigatorCommon.updateUrgentMissionList(arg_36_0)
	if arg_36_0.mode ~= "URGENT" then
		return 
	end
	
	if not get_cocos_refid(arg_36_0.wnd) then
		return 
	end
	
	local var_36_0 = {}
	local var_36_1 = Account:getUrgentMissions()
	
	for iter_36_0, iter_36_1 in pairs(var_36_1) do
		if iter_36_1.state == URGENT_MISSION_STATE.ACTIVE then
			table.insert(var_36_0, iter_36_0)
		end
	end
	
	if #var_36_0 > 0 then
		if_set_visible(arg_36_0.wnd, "n_empty", false)
		arg_36_0:createScrollViewItems(var_36_0)
	else
		if_set_visible(arg_36_0.wnd, "n_empty", true)
	end
end

function MissionNavigatorCommon.getScrollViewItem(arg_37_0, arg_37_1)
	local var_37_0 = load_dlg("mission_item", true, "wnd")
	
	var_37_0.parent = arg_37_0
	
	arg_37_0:updateItem(var_37_0, arg_37_1)
	
	return var_37_0
end

function MissionNavigatorCommon.updateQuestItemLockControl(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	if_set_visible(arg_38_1, "n_locked", false)
end

function MissionNavigatorCommon.updateItem(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0, var_39_1, var_39_2, var_39_3, var_39_4, var_39_5, var_39_6, var_39_7, var_39_8, var_39_9, var_39_10 = DB("mission_data", arg_39_2.id or arg_39_2, {
		"name",
		"desc",
		"desc2",
		"icon",
		"reward_id1",
		"reward_count1",
		"value",
		"area_enter_id",
		"btn_move",
		"grade_rate1",
		"set_drop_rate_id1"
	})
	local var_39_11 = ConditionContentsManager:getQuestMissions()
	local var_39_12 = ConditionContentsManager:getUrgentMissions()
	
	if arg_39_0.mode == "QUEST" then
		local var_39_13
		local var_39_14 = arg_39_1:getChildByName("n_urgent")
		
		if var_39_11:getCurrentQuestId() ~= arg_39_2.id and arg_39_2.state ~= "clear" then
			var_39_14:setOpacity(63.75)
		end
		
		local var_39_15 = arg_39_2.state
		
		if not var_39_15 or var_39_15 ~= "active" and var_39_15 ~= "clear" and var_39_15 ~= "received" then
			if_set(var_39_14, "txt_name", T("mission_name_unlock"))
			if_set(var_39_14, "txt_desc", T("mission_name_desc2"))
			if_set(var_39_14, "txt_title", T("mission_name_desc"))
			
			var_39_3 = "m0000"
		else
			if_set(var_39_14, "txt_name", T(var_39_0))
			if_set(var_39_14, "txt_desc", T(var_39_2) or "")
			if_set(var_39_14, "txt_title", T(var_39_1))
		end
		
		local var_39_16 = arg_39_2.score or 0
		local var_39_17 = totable(var_39_6).count or "1"
		
		var_39_14:getChildByName("progress"):setPercent(var_39_16 / var_39_17 * 100)
		if_set(var_39_14, "txt_progress", var_39_16 .. "/" .. var_39_17)
		
		local var_39_18 = var_39_14:getChildByName("txt_title")
		
		var_39_18:setPositionX(var_39_18:getPositionX() - 20)
		var_39_18:setVisible(true)
		if_set_visible(var_39_14, "txt_time_title", false)
		if_set_visible(var_39_14, "cm_icon_etctime_b_16", false)
		if_set_sprite(var_39_14, "img_face", "face/" .. var_39_3 .. "_s.png")
		
		local var_39_19 = var_39_14:getChildByName("icon")
		local var_39_20 = {
			tooltip_x = -170,
			skill_preview = true,
			parent = var_39_14:getChildByName("icon"),
			set_drop = var_39_10,
			grade_rate = var_39_9
		}
		local var_39_21 = UIUtil:getRewardIcon(var_39_5, var_39_4, var_39_20)
		
		table.insert(arg_39_0.rewardIcons, var_39_21)
		
		local var_39_22 = var_39_14:getChildByName("btn_place_go")
		
		var_39_22.mission_id = arg_39_2.id
		var_39_22.mission_state = var_39_15
		var_39_22.map_id = var_39_7
		var_39_22.short_cut = var_39_8
		
		local var_39_23 = arg_39_1:getChildByName("n_complet")
		
		UIUtil:setColorRewardButtonState(var_39_15, arg_39_1, var_39_22, {
			add_x_clear = 0
		})
		if_set_visible(var_39_22, nil, var_39_15 ~= "received")
		if_set_visible(var_39_23, nil, var_39_15 == "received")
		arg_39_0:updateQuestItemLockControl(var_39_14)
	elseif arg_39_0.mode == "URGENT" then
		local var_39_24
		local var_39_25 = arg_39_1:getChildByName("n_urgent")
		
		if_set(var_39_25, "txt_name", T(var_39_0))
		if_set(var_39_25, "txt_desc", T(var_39_2) or "")
		
		local var_39_26 = var_39_12:getScore(arg_39_2)
		local var_39_27 = var_39_12:getMaxCount(arg_39_2)
		
		var_39_25:getChildByName("progress"):setPercent(var_39_26 / var_39_27 * 100)
		if_set(var_39_25, "txt_progress", var_39_26 .. "/" .. var_39_27)
		if_set_visible(var_39_25, "txt_time_title", true)
		if_set_visible(var_39_25, "txt_title", false)
		
		local var_39_28 = var_39_12:getRemainTime(arg_39_2)
		
		if var_39_28 < 0 then
			if_set(var_39_25, "txt_time_title", T("urgent_time_expire"))
		else
			if_set(var_39_25, "txt_time_title", T("remain_time_urgent", {
				time = sec_to_full_string(var_39_28, true)
			}))
		end
		
		if_set_sprite(var_39_25, "img_face", "face/" .. var_39_3 .. "_s.png")
		if_set_visible(var_39_25, "n_locked", false)
		
		local var_39_29 = {
			tooltip_x = -170,
			parent = var_39_25:getChildByName("icon"),
			set_drop = var_39_10,
			grade_rate = var_39_9
		}
		local var_39_30 = UIUtil:getRewardIcon(var_39_5, var_39_4, var_39_29)
		
		table.insert(arg_39_0.rewardIcons, var_39_30)
		
		local var_39_31 = var_39_25:getChildByName("btn_place_go")
		
		var_39_31.mission_id = arg_39_2
		var_39_31.mission_state = "active"
		var_39_31.map_id = var_39_7
		var_39_31.short_cut = var_39_8
		var_39_31.urgent_mission = true
		
		local var_39_32 = arg_39_1:getChildByName("n_complet")
		
		if_set_visible(var_39_32, nil, false)
		if_set_visible(var_39_31, nil, true)
	end
	
	if false then
	end
end

function MissionNavigatorCommon.onSelectScrollViewItem(arg_40_0, arg_40_1, arg_40_2)
	print(arg_40_1, arg_40_2, "onSelectScrollViewItem====")
end

function MissionNavigatorCommon.onInfoScrollViewItem(arg_41_0, arg_41_1, arg_41_2)
	print(arg_41_1, arg_41_2, "onInfoScrollViewItem====")
end

function MissionNavigatorCommon.update(arg_42_0)
	arg_42_0:updateUrgentMission()
	
	local var_42_0
	
	if arg_42_0.mode == "URGENT" then
		var_42_0 = ConditionContentsManager:getUrgentMissions()
		
		for iter_42_0, iter_42_1 in pairs(arg_42_0.ScrollViewItems) do
			if (var_42_0:getGroups() or {})[iter_42_1.item] then
				local var_42_1 = var_42_0:getRemainTime(iter_42_1.item)
				
				if var_42_1 < 0 then
					if_set(iter_42_1.control, "txt_time_title", T("urgent_time_expire"))
				else
					if_set(iter_42_1.control, "txt_time_title", T("remain_time_urgent", {
						time = sec_to_full_string(var_42_1, true)
					}))
				end
			else
				arg_42_0:removeScrollViewItem(iter_42_1.item)
			end
		end
	end
end

function MissionNavigatorCommon.setHeader_quest(arg_43_0)
	local var_43_0 = ConditionContentsManager:getQuestMissions()
	local var_43_1 = string.split(var_43_0.chapter_key, "_")
	local var_43_2 = var_43_0:getUIChapterMissionId() or var_43_0:getDB().last_chapter_mission_id
	local var_43_3, var_43_4, var_43_5, var_43_6, var_43_7, var_43_8, var_43_9, var_43_10, var_43_11, var_43_12 = DB("mission_data", var_43_2, {
		"name",
		"name2",
		"desc",
		"desc2",
		"icon",
		"reward_id1",
		"reward_count1",
		"value",
		"grade_rate1",
		"set_drop_rate_id1"
	})
	
	if_set(arg_43_0.header_quest_wnd, "txt_chapter", T(var_43_3))
	if_set(arg_43_0.header_quest_wnd, "txt_title", T(var_43_4))
	if_set_sprite(arg_43_0.header_quest_wnd, "img_tmp", var_43_7)
	
	local var_43_13
	
	if var_43_0:isAllClearEpisode() then
		var_43_13 = var_43_0:getDB().last_chapter_key
		
		if_set_visible(arg_43_0.quest_ui, "btn_questreward", false)
		if_set_visible(arg_43_0.quest_ui, "t", false)
		if_set_visible(arg_43_0.quest_ui, "n_item_reward", false)
	end
	
	local var_43_14 = var_43_0:getClearCountUIChapter(var_43_13)
	local var_43_15 = totable(var_43_10)
	local var_43_16 = #(arg_43_0.ScrollViewItems or {})
	local var_43_17 = arg_43_0.header_quest_wnd:getChildByName("progress")
	
	var_43_17:setPercent(math.min(var_43_14 / var_43_16, 1) * 100)
	if_set(arg_43_0.header_quest_wnd, "txt_progress", T("quest_progress", {
		score = var_43_14,
		max = var_43_16
	}))
	
	if var_43_14 == var_43_16 then
		var_43_17:setColor(cc.c3b(107, 193, 27))
	else
		var_43_17:setColor(cc.c3b(146, 109, 62))
	end
	
	local var_43_18 = var_43_8 and string.starts(var_43_8, "ef")
	
	if_set_visible(arg_43_0.header_quest_wnd, "bg_reward", not var_43_18)
	
	local var_43_19 = {
		tooltip_x = -300,
		tooltip_y = -300,
		skill_preview = true,
		scale = 1.3,
		parent = arg_43_0.header_quest_wnd:getChildByName("icon"),
		set_drop = var_43_12,
		grade_rate = var_43_11
	}
	local var_43_20 = UIUtil:getRewardIcon(var_43_9, var_43_8, var_43_19)
	
	table.insert(arg_43_0.rewardIcons, var_43_20)
	
	if var_43_16 <= var_43_14 then
		var_43_20:setOpacity(255)
	else
		var_43_20:setOpacity(76.5)
	end
	
	return {
		reward_icon = var_43_20,
		icon = var_43_7
	}
end

function MissionNavigatorCommon.setVisibleRewardIcon(arg_44_0, arg_44_1, arg_44_2)
	arg_44_1.reward_icon:setVisible(arg_44_2)
	arg_44_0.header_quest_wnd:getChildByName("bg_reward"):setVisible(arg_44_2)
end

function MissionNavigatorCommon.onActionChangeChapter(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0:setHeader_quest()
	
	arg_45_0:setVisibleRewardIcon(var_45_0, false)
	if_set_sprite(arg_45_0.header_quest_wnd, "img_tmp", var_45_0.icon)
	UIAction:Add(SEQ(DELAY(850), CALL(MissionNavigatorCommon.setVisibleRewardIcon, arg_45_0, var_45_0, true)), var_45_0.reward_icon, "chapterOpen")
	
	local var_45_1 = arg_45_0.header_quest_wnd:getChildByName("txt_chapter")
	local var_45_2 = arg_45_0.header_quest_wnd:getChildByName("txt_title")
	local var_45_3 = var_45_1:getPositionX()
	local var_45_4 = var_45_1:getPositionY()
	local var_45_5 = var_45_2:getPositionX()
	local var_45_6 = var_45_2:getPositionY()
	
	UIAction:Add(SEQ(MOVE_TO(0, var_45_3 + 208.01, var_45_4), FADE_OUT(0), DELAY(660), SPAWN(LOG(MOVE_TO(330, var_45_3, var_45_4)), LOG(FADE_IN(330)))), var_45_1, "chapterOpen")
	UIAction:Add(SEQ(MOVE_TO(0, var_45_5 + 164.15, var_45_6), FADE_OUT(0), DELAY(891), SPAWN(LOG(MOVE_TO(330, var_45_5, var_45_6)), LOG(FADE_IN(330)))), var_45_2, "chapterOpen")
	
	local var_45_7 = arg_45_0.header_quest_wnd:getChildByName("bg_progress")
	local var_45_8 = arg_45_0.header_quest_wnd:getChildByName("txt_progress")
	
	UIAction:Add(SEQ(FADE_OUT(0), DELAY(660), FADE_IN(495)), var_45_7, "chapterOpen")
	UIAction:Add(SEQ(FADE_OUT(0), DELAY(660), FADE_IN(495)), var_45_8, "chapterOpen")
end

function MissionNavigatorCommon.onActionChapterOpen(arg_46_0)
	set_high_fps_tick(1000)
	EffectManager:Play("ui_chapter_clear_eff.cfx", arg_46_0.header_quest_wnd, arg_46_0.header_quest_wnd:getContentSize().width / 2, arg_46_0.header_quest_wnd:getContentSize().height / 2, 99999)
	
	local var_46_0 = ConditionContentsManager:getQuestMissions()
	local var_46_1 = var_46_0:getNotiCount() > 0
	local var_46_2 = var_46_0:isAllClearQuestInChapter()
	local var_46_3 = arg_46_0.wnd:getChildByName("n_clear")
	
	UIAction:Add(SEQ(FADE_OUT(500), DELAY(1150), CALL(arg_46_0.onActionChangeChapter, arg_46_0), DELAY(1417), FADE_IN(0), CALL(function()
		if var_46_1 then
			if_set_visible(arg_46_0.wnd, "n_all_reward", true)
			var_46_3:setVisible(false)
		elseif var_46_2 then
			var_46_3:setVisible(true)
			if_set_visible(arg_46_0.wnd, "n_all_reward", false)
		else
			var_46_3:setVisible(false)
			if_set_visible(arg_46_0.wnd, "n_all_reward", false)
		end
	end)), var_46_3, "chapterOpen")
	
	local var_46_4 = arg_46_0.quest_scroll:getPositionX()
	local var_46_5 = arg_46_0.quest_scroll:getPositionY()
	
	UIAction:Add(SEQ(FADE_OUT(0), MOVE_TO(0, var_46_4, var_46_5 - 50), DELAY(3135), SPAWN(SHOW(), LOG(MOVE_TO(495, var_46_4, var_46_5)), LOG(FADE_IN(495))), CALL(function()
		balloon_message_with_sound("quest_chapter_reward_msg")
	end)), arg_46_0.quest_scroll, "chapterOpen")
	arg_46_0.quest_scroll:setVisible(false)
end

function MissionNavigatorCommon.selectInfoMainTab(arg_49_0, arg_49_1)
	arg_49_1 = arg_49_1 or 1
	arg_49_0.info_tab = arg_49_1
	
	arg_49_0:moveTabInfoSelector(arg_49_0.infomation_ui:getChildByName("n_main_tab"), arg_49_0.info_tab)
	arg_49_0:updateInfomation()
end

function MissionNavigatorCommon.updateInfomation_open(arg_50_0)
	if arg_50_0.mode ~= "INFO" then
		return 
	end
	
	if arg_50_0.info_tab == var_0_0.INFOMATION then
		MissionNavigatorInfo:show()
		MissionNavigatorMonsterInfo:hide()
	end
	
	if_set_visible(arg_50_0.infomation_ui, "monster_loading", arg_50_0.info_tab == var_0_0.MONSTER)
end

function MissionNavigatorCommon.updateInfomation_openEnd(arg_51_0)
	if arg_51_0.mode ~= "INFO" then
		return 
	end
	
	if arg_51_0.info_tab == var_0_0.MONSTER then
		MissionNavigatorMonsterInfo:show()
		MissionNavigatorInfo:hide()
	end
	
	if arg_51_0.info_tab == var_0_0.MONSTER then
		if_set_visible(arg_51_0.infomation_ui, "monster_loading", false)
		
		local var_51_0 = MissionNavigatorMonsterInfo:isEmptyData()
		
		if_set_visible(arg_51_0.infomation_ui, "n_no_monster", var_51_0)
	end
end

function MissionNavigatorCommon.updateInfomation(arg_52_0)
	if arg_52_0.mode ~= "INFO" then
		return 
	end
	
	arg_52_0:updateInfomation_open()
	arg_52_0:updateInfomation_openEnd()
end

function MissionNavigatorCommon.queryRewardQuestAll(arg_53_0)
	local var_53_0 = ConditionContentsManager:getQuestMissions():getUIChapterKey()
	
	query("get_reward_quest_all", {
		chapter_db_key = var_53_0
	})
end

function MissionNavigatorCommon.moveTabInfoSelector(arg_54_0, arg_54_1, arg_54_2)
	if not arg_54_1 then
		return 
	end
	
	local var_54_0 = arg_54_1:getChildByName("n_selected")
	
	if not var_54_0 then
		return 
	end
	
	local var_54_1 = arg_54_1:getChildByName("n_tab" .. arg_54_2)
	
	if var_54_1 then
		var_54_0:setPositionX(var_54_1:getPositionX())
	end
end

AdvMissionNavigator = AdvMissionNavigator or {}

copy_functions(MissionNavigatorCommon, AdvMissionNavigator)

function AdvMissionNavigator.init(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	arg_55_0:initUI(arg_55_1, arg_55_2, arg_55_3)
	UnlockSystem:setUnlockUIState(arg_55_0.ui_icon_list.URGENT, "btn_time", UNLOCK_ID.URGENT_MISSION, {
		icon_name = "icon_lock_time",
		no_color = true
	})
	UnlockSystem:setUnlockUIState(arg_55_0.ui_icon_list.SHOP, "btn_shop", UNLOCK_ID.LOCAL_SHOP, {
		icon_name = "icon_lock_shop",
		no_color = true
	})
	
	if not Account:isMapCleared("tae010") and not DEBUG.MAP_DEBUG then
		local var_55_0 = arg_55_0.wnd:getChildByName("n_ep_")
		
		if_set_visible(var_55_0, "btn_ep_sel_icon", false)
		if_set_visible(var_55_0, "bar", false)
		
		local var_55_1 = arg_55_0.wnd:getChildByName("n_btns")
		
		var_55_1:setPositionY(var_55_1:getPositionY() - 65)
	end
	
	arg_55_0:playEffectChapterReward()
end
