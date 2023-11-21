SubWorldMapUI = SubWorldMapUI or {}

copy_functions(WorldMapUICommon, SubWorldMapUI)

function SubWorldMapUI.create(arg_1_0, arg_1_1)
	arg_1_0.controller = arg_1_1
	
	local var_1_0 = arg_1_0:initUI()
	
	arg_1_0:_createTopbar(var_1_0)
	
	arg_1_0.navi = SubMissionNavigator
	
	arg_1_0.navi:init(arg_1_0.RIGHT, arg_1_0.controller, arg_1_0)
	arg_1_0.navi:updateQuest()
	arg_1_0:updateNotifier()
	
	return var_1_0
end

function SubWorldMapUI._createTopbar(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return 
	end
	
	local var_2_0 = SubstoryManager:getInfo() or {}
	local var_2_1 = false
	local var_2_2 = var_2_0.help_id or "infosubs"
	local var_2_3 = arg_2_0.controller:getContinentID()
	local var_2_4 = {
		"crystal",
		"gold",
		"stamina"
	}
	
	for iter_2_0 = 1, 3 do
		if var_2_0["token_id" .. iter_2_0] then
			var_2_1 = true
			
			table.insert(var_2_4, var_2_0["token_id" .. iter_2_0])
		end
	end
	
	local var_2_5, var_2_6 = DB("level_world_2_continent", var_2_3, {
		"name",
		"topbar_name"
	})
	
	if var_2_6 then
		var_2_5 = var_2_6
	end
	
	TopBarNew:create(T("map_world"), arg_2_1, function()
		arg_2_0:onBackButton()
	end, var_2_4, nil, var_2_2)
	TopBarNew:setTitleName(T(var_2_5), var_2_2, var_2_1)
	TopBarNew:setCurrencyIconsSize()
end

function SubWorldMapUI.createQuestNPC(arg_4_0, arg_4_1)
	local var_4_0 = SubstoryManager:getInfo()
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = var_4_0.id
	
	local function var_4_2(arg_5_0)
		local var_5_0 = SubstoryManager:getSubStoryAchieveData(arg_5_0, {
			check_unlock = true
		})
		
		if not arg_5_0 or var_5_0.id == nil then
			return 
		end
		
		if (var_5_0.state or SUBSTORY_ACHIEVE_STATE.ACTIVE) == SUBSTORY_ACHIEVE_STATE.ACTIVE then
			return true
		end
	end
	
	arg_4_0:hideNPC()
	
	local function var_4_3(arg_6_0)
		local var_6_0 = false
		
		if not arg_6_0.type or not arg_6_0.value then
			Log.e("level_guide_npc empty type or value data", db_id)
		elseif arg_6_0.type == "substory_quest" and SubstoryManager:isActiveQuest(arg_6_0.value) then
			var_6_0 = true
		elseif arg_6_0.type == "substory_achievement" and var_4_2(arg_6_0.value) then
			var_6_0 = true
		end
		
		if not var_6_0 then
			if arg_6_0.type == "substory_quest" and SubstoryManager:isClearedSubStoryQuest(arg_6_0.value) then
				return "next"
			elseif arg_6_0.type == "substory_achievement" and Account:isClearedSubStoryAchievement(arg_6_0.value) then
				return "next"
			end
		end
		
		if var_6_0 and not DEBUG.IGNORE_NPC or DEBUG.SHOW_NPC_GUIDE then
			local var_6_1 = false
			
			if arg_6_0 and arg_6_0.world_chapter_id and arg_4_1 then
				if arg_6_0.world_chapter_id == arg_4_1 then
					var_6_1 = true
				end
			else
				var_6_1 = true
			end
			
			if DEBUG.SHOW_NPC_GUIDE == true then
				var_6_1 = DEBUG.SHOW_NPC_GUIDE
			end
			
			if var_6_1 then
				return true, arg_6_0.npc_id, arg_6_0.npc_baloon_id, arg_6_0.npc_data, arg_6_0.npc_baloon_data, arg_6_0.use_custom and arg_6_0.use_custom == "vae2aa"
			end
		end
	end
	
	for iter_4_0 = 1, 9999 do
		local var_4_4 = var_4_1 .. "_" .. string.format("%02d", iter_4_0)
		local var_4_5 = DBT("level_guide_npc", var_4_4, {
			"id",
			"npc_id",
			"npc_data",
			"npc_baloon_data",
			"npc_baloon_id",
			"type",
			"value",
			"use_custom",
			"world_chapter_id"
		})
		
		if not var_4_5 or table.empty(var_4_5) then
			break
		end
		
		local var_4_6, var_4_7, var_4_8, var_4_9, var_4_10, var_4_11 = var_4_3(var_4_5)
		
		if var_4_6 and var_4_6 == "next" then
		else
			if var_4_6 == true and var_4_7 then
				arg_4_0:showNPC(var_4_7, var_4_8, var_4_9, var_4_10, var_4_11)
			end
			
			break
		end
		
		if false then
			break
		end
	end
end

function SubWorldMapUI.setEnableContentsUI(arg_7_0)
	local var_7_0 = (SubstoryManager:getWorldMapContentsDB() or {}).star_mission_hide
	
	if_set_visible(arg_7_0.wnd, "n_star_rewards", var_7_0 ~= "y")
	WorldMapUIButtons:setSubstoryEnableUI()
end

function SubWorldMapUI.updateContentButtons(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if (SubstoryManager:getWorldMapContentsDB() or {}).worldmap_button_hide and arg_8_1 == "LAND" then
		if_set_visible(arg_8_0.wnd, "n_content", false)
	else
		if_set_visible(arg_8_0.wnd, "n_content", true)
	end
end

function SubWorldMapUI.setCustomItemUI(arg_9_0)
	if SubstoryManager:canShowSubCusUI() then
		SubstoryCustomItemPopup:init(arg_9_0.wnd)
	end
end

function SubWorldMapUI.createQuestNavi(arg_10_0)
	local var_10_0 = arg_10_0.wnd:getChildByName("n_quest_navi")
	
	var_10_0:setVisible(true)
	var_10_0:removeAllChildren()
	
	local var_10_1 = SubstoryManager:getCurrentQuestData()
	
	if arg_10_0.controller:getMode() == "TOWN" and var_10_1 and not SubstoryManager:isActiveQuestInChapter(arg_10_0.controller:getMapKey()) then
		local var_10_2 = UIUtil:makeNavigatorAni({
			scale = 0.55
		})
		
		var_10_0:addChild(var_10_2)
	end
end

function SubWorldMapUI.updateNotifier(arg_11_0)
	if not arg_11_0.wnd or not get_cocos_refid(arg_11_0.wnd) then
		return 
	end
	
	WorldMapUIButtons:updateSubstoryNotifier()
end

function SubWorldMapUI.setMapMagnifier(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.controller:getZoomContentsType()
	
	if var_12_0 == WORLDMAP_LIMIT_ZOOM_TYPE.CHAPTER then
		if_set_visible(arg_12_0.wnd, "btn_zoom_out", false)
		
		return 
	end
	
	if_set_visible(arg_12_0.wnd, "btn_zoom_out", true)
	arg_12_0:setVisibleDefault()
	
	if var_12_0 == WORLDMAP_LIMIT_ZOOM_TYPE.CONTINENT then
		if arg_12_1 == "TOWN" then
			if_set_opacity(arg_12_0.wnd, "btn_zoom_out", 255)
		elseif arg_12_1 == "LAND" then
			if_set_opacity(arg_12_0.wnd, "btn_zoom_out", 80)
		end
	end
	
	if var_12_0 == WORLDMAP_LIMIT_ZOOM_TYPE.WORLD then
		if arg_12_1 == "TOWN" then
			if_set_opacity(arg_12_0.wnd, "btn_zoom_out", 255)
		elseif arg_12_1 == "LAND" then
			if_set_opacity(arg_12_0.wnd, "btn_zoom_out", 255)
		else
			if_set_opacity(arg_12_0.wnd, "btn_zoom_out", 80)
		end
	end
	
	if arg_12_1 == "LAND" then
		local var_12_1 = arg_12_0.wnd:getChildByName("n_npc_info")
		
		if get_cocos_refid(var_12_1) then
			var_12_1:setVisible(false)
		end
	end
end

function aspea_illust_tutorial_handler(arg_13_0)
	do return  end
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0) do
		if iter_13_1 and iter_13_1.code == "ma_vae2aa_5" then
			TutorialGuide:startGuide("vae2aa_lobbyillust")
			
			return 
		end
	end
end

function MsgHandler.get_reward_substory_quest(arg_14_0)
	Account:setSubStoryQuest(arg_14_0.doc_quest)
	
	local var_14_0 = SubstoryManager:getContentsController():getWorldMapNavi()
	
	var_14_0:updateQuestMissionList({
		no_reward_eff = true
	})
	var_14_0:updateQuest()
	
	local var_14_1 = {
		title = T("quest_reward_title"),
		desc = T("quest_reward_msg")
	}
	
	Account:addReward(arg_14_0.rewards, {
		play_reward_data = var_14_1,
		handler = function()
			local var_15_0 = (arg_14_0.rewards or {}).new_items or {}
			
			aspea_illust_tutorial_handler(var_15_0)
		end
	})
	
	local var_14_2 = WorldMapManager:getController()
	
	if var_14_2 then
		var_14_2:refreshAllLocalIcons()
	end
end

function MsgHandler.get_substory_quest_chapter_reward(arg_16_0)
	Account:setSubStory(arg_16_0.substory_id, arg_16_0.substory_doc)
	
	local var_16_0 = SubstoryManager:getContentsController():getWorldMapNavi()
	
	var_16_0:unsetTouchHandler()
	var_16_0:updateQuestMissionList()
	var_16_0:updateQuest()
	
	local var_16_1 = {
		title = T("quest_chapter_reward_title"),
		desc = T("quest_chapter_reward_msg")
	}
	
	Account:addReward(arg_16_0.rewards, {
		force_character_effect_handler = true,
		play_reward_data = var_16_1
	})
	
	local var_16_2 = WorldMapManager:getController()
	
	if var_16_2 then
		var_16_2:refreshAllLocalIcons()
	end
end

function MsgHandler.get_reward_substory_quest_all(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.infos) do
		Account:setSubStoryQuest(iter_17_1)
	end
	
	local var_17_0 = SubstoryManager:getContentsController():getWorldMapNavi()
	
	var_17_0:updateQuestMissionList({
		no_reward_eff = true
	})
	var_17_0:updateQuest()
	
	local var_17_1 = Account:addReward(arg_17_0.rewards, {
		no_rtn_reward_randombox = true
	})
	
	Dialog:msgScrollRewards(T("quest_reward_popup_desc"), {
		open_effect = true,
		title = T("quest_reward_popup_title"),
		rewards = {
			new_items = var_17_1.rewards
		},
		handler = function()
			local var_18_0 = (arg_17_0.rewards or {}).new_items or {}
			
			aspea_illust_tutorial_handler(var_18_0)
		end
	})
	
	local var_17_2 = WorldMapManager:getController()
	
	if var_17_2 then
		var_17_2:refreshAllLocalIcons()
	end
end

SubMissionNavigator = SubMissionNavigator or {}

copy_functions(MissionNavigatorCommon, SubMissionNavigator)

function SubMissionNavigator.init(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_0:initUI(arg_19_1, arg_19_2, arg_19_3)
	UnlockSystem:setUnlockUIState(arg_19_0.ui_icon_list.URGENT, "btn_time", UNLOCK_ID.URGENT_MISSION, {
		icon_name = "icon_lock_time",
		no_color = true
	})
	
	local var_19_0 = arg_19_0.wnd:getChildByName("btn_shop")
	local var_19_1 = SubstoryManager:getWorldMapContentsDB()
	
	if var_19_1 and var_19_1.chapter_shop ~= nil then
		UnlockSystem:setUnlockUIState(arg_19_0.ui_icon_list.SHOP, "btn_shop", UNLOCK_ID.LOCAL_SHOP, {
			icon_name = "icon_lock_shop",
			no_color = true
		})
	else
		var_19_0:setOpacity(76.5)
		var_19_0:setEnabled(false)
		if_set_visible(arg_19_0.wnd, "icon_lock_shop", false)
	end
	
	if not Account:isMapCleared("tae010") and not DEBUG.MAP_DEBUG then
		local var_19_2 = arg_19_0.wnd:getChildByName("n_ep_")
		
		if_set_visible(var_19_2, "btn_ep_sel_icon", false)
		if_set_visible(var_19_2, "bar", false)
		
		local var_19_3 = arg_19_0.wnd:getChildByName("n_btns")
		
		var_19_3:setPositionY(var_19_3:getPositionY() - 65)
	end
	
	arg_19_0:playEffectChapterReward()
	SubStoryFestivalUIUtil:updateFestivalDateUI(arg_19_0.wnd)
end

function SubMissionNavigator.updateStarRewardUI(arg_20_0)
end

function SubMissionNavigator.setEnableContentsUI(arg_21_0)
	if SubstoryManager:getInfo().quest_flag == nil then
		if_set_opacity(arg_21_0.wnd, "btn_quest", 76.5)
		if_set_opacity(arg_21_0.wnd, "txt_title1", 76.5)
		if_set_enabled(arg_21_0.wnd, "btn_quest", false)
	end
end

function SubMissionNavigator.queryRewardQuestAll(arg_22_0)
	local var_22_0 = SubstoryManager:getInfo()
	
	query("get_reward_substory_quest_all", {
		substory_id = var_22_0.id
	})
end

function SubMissionNavigator.playEffectChapterReward(arg_23_0)
	local var_23_0 = SubstoryManager:getInfo().id
	local var_23_1 = Account:getSubStory(var_23_0).quest_reward_state or SUBSTORY_QUEST_STATE.ACTIVE
	
	if tonumber(var_23_1) == SUBSTORY_QUEST_STATE.CLEAR then
		local var_23_2 = arg_23_0.wnd:getChildByName("n_talk_guide")
		
		if var_23_2 then
			var_23_2:setVisible(true)
			if_set(var_23_2, "txt_title", T("complete_all_quest_title_substory"))
			if_set(var_23_2, "txt_disc", T("complete_all_quest_desc_substory"))
			UIAction:Add(SEQ(DELAY(3500), FADE_OUT(500)), var_23_2, "chapter_reward_guide")
		end
	end
end

function SubMissionNavigator.setHeader_quest(arg_24_0)
	local var_24_0 = SubstoryManager:getInfo().id
	local var_24_1, var_24_2, var_24_3, var_24_4, var_24_5, var_24_6, var_24_7, var_24_8, var_24_9, var_24_10, var_24_11 = DB("substory_main", var_24_0, {
		"quest_chapter_name",
		"quest_chapter_desc",
		"quest_chapter_icon",
		"reward_id1",
		"reward_count1",
		"grade_rate1",
		"set_drop_rate_id1",
		"reward_id2",
		"reward_count2",
		"grade_rate2",
		"set_drop_rate_id2"
	})
	local var_24_12 = arg_24_0.header_quest_wnd:getChildByName("n_contents")
	local var_24_13 = arg_24_0.header_quest_wnd:getChildByName("n_character_story")
	local var_24_14 = var_24_12
	
	if var_24_8 and var_24_9 then
		var_24_14 = var_24_13
	end
	
	if_set(var_24_14, "txt_chapter", T(var_24_1))
	if_set(var_24_14, "txt_title", T(var_24_2))
	if_set_sprite(arg_24_0.header_quest_wnd, "img_tmp", var_24_3)
	
	local var_24_15 = Account:getSubStory(var_24_0).quest_reward_state or SUBSTORY_QUEST_STATE.ACTIVE
	
	if not SubstoryManager:getCurrentQuestData() and var_24_15 == SUBSTORY_QUEST_STATE.REWARDED then
		if_set(arg_24_0.wnd, "txt_desc_0", T("sub_quest_chapter_ui_title"))
		if_set(arg_24_0.quest_ui, "txt_desc", T("sub_mission_no_ep"))
		if_set_visible(arg_24_0.quest_ui, "btn_questreward", false)
		if_set_visible(arg_24_0.quest_ui, "t", false)
		if_set_visible(arg_24_0.quest_ui, "n_item_reward", false)
	end
	
	local var_24_16 = SubstoryManager:getClearQuestCount()
	local var_24_17 = #(arg_24_0.ScrollViewItems or {})
	local var_24_18 = var_24_14:getChildByName("progress")
	
	var_24_18:setPercent(math.min(var_24_16 / var_24_17, 1) * 100)
	if_set(var_24_14, "txt_progress", T("quest_progress", {
		score = var_24_16,
		max = var_24_17
	}))
	
	if var_24_16 == var_24_17 then
		var_24_18:setColor(cc.c3b(107, 193, 27))
	else
		var_24_18:setColor(cc.c3b(146, 109, 62))
	end
	
	if var_24_8 and var_24_9 then
		var_24_14:setVisible(true)
		var_24_12:setVisible(false)
		
		local var_24_19 = var_24_14:getChildByName("n_reward1")
		local var_24_20 = {
			tooltip_x = -300,
			tooltip_y = -300,
			skill_preview = true,
			scale = 1.3,
			parent = var_24_19:getChildByName("icon"),
			set_drop = var_24_7,
			grade_rate = var_24_6
		}
		local var_24_21 = UIUtil:getRewardIcon(var_24_5, var_24_4, var_24_20)
		
		table.insert(arg_24_0.rewardIcons, var_24_21)
		
		local var_24_22 = var_24_4 and string.starts(var_24_4, "ef")
		
		if_set_visible(var_24_14, "bg_reward", not var_24_22)
		
		local var_24_23 = var_24_14:getChildByName("n_reward2")
		local var_24_24 = {
			tooltip_x = -300,
			tooltip_y = -300,
			skill_preview = true,
			scale = 1.3,
			parent = var_24_23:getChildByName("icon"),
			set_drop = var_24_7,
			grade_rate = var_24_6
		}
		local var_24_25 = UIUtil:getRewardIcon(var_24_9, var_24_8, var_24_24)
		
		table.insert(arg_24_0.rewardIcons, var_24_25)
		
		if var_24_17 <= var_24_16 then
			var_24_21:setOpacity(255)
			var_24_25:setOpacity(255)
		else
			var_24_21:setOpacity(76.5)
			var_24_25:setOpacity(76.5)
		end
	else
		var_24_14:setVisible(true)
		var_24_13:setVisible(false)
		
		local var_24_26 = var_24_4 and string.starts(var_24_4, "ef")
		
		if_set_visible(var_24_14, "bg_reward", not var_24_26)
		
		local var_24_27 = {
			tooltip_x = -300,
			tooltip_y = -300,
			skill_preview = true,
			scale = 1.3,
			parent = var_24_14:getChildByName("icon"),
			set_drop = var_24_7,
			grade_rate = var_24_6
		}
		local var_24_28 = UIUtil:getRewardIcon(var_24_5, var_24_4, var_24_27)
		
		table.insert(arg_24_0.rewardIcons, var_24_28)
		
		if var_24_17 <= var_24_16 then
			var_24_28:setOpacity(255)
		else
			var_24_28:setOpacity(76.5)
		end
	end
	
	return {}
end

function SubMissionNavigator.updateQuestMissionList(arg_25_0, arg_25_1)
	arg_25_1 = arg_25_1 or {}
	
	if arg_25_0.mode ~= "QUEST" then
		return 
	end
	
	if not arg_25_0.wnd then
		return 
	end
	
	local var_25_0 = SubstoryManager:getSubStoryQuestDatas()
	local var_25_1 = {
		[SUBSTORY_QUEST_STATE.REWARDED] = 0,
		[SUBSTORY_QUEST_STATE.INACTIVE + 4] = 1,
		[SUBSTORY_QUEST_STATE.ACTIVE] = 2,
		[SUBSTORY_QUEST_STATE.CLEAR] = 3
	}
	
	table.sort(var_25_0, function(arg_26_0, arg_26_1)
		local var_26_0 = arg_26_0.state or SUBSTORY_QUEST_STATE.INACTIVE
		
		if var_26_0 < 0 then
			var_26_0 = var_26_0 + 4
		end
		
		local var_26_1 = arg_26_1.state or SUBSTORY_QUEST_STATE.INACTIVE
		
		if var_26_1 < 0 then
			var_26_1 = var_26_1 + 4
		end
		
		if var_26_0 == var_26_1 then
			return arg_26_0.sort < arg_26_1.sort
		else
			return var_25_1[var_26_0] > var_25_1[var_26_1]
		end
	end)
	arg_25_0:createScrollViewItems(var_25_0)
	arg_25_0:setHeader_quest()
	
	local var_25_2 = SubstoryManager:getInfo().id
	local var_25_3 = Account:getSubStory(var_25_2).quest_reward_state or SUBSTORY_QUEST_STATE.ACTIVE
	
	if SubstoryManager:getClearQuestNotiCount() > 0 then
		local var_25_4 = arg_25_0.wnd:getChildByName("scrollview")
		
		var_25_4:setContentSize(600, 347)
		var_25_4:scrollToTop(0, false)
		var_25_4:setPositionY(arg_25_0.wnd:getChildByName("scroll_pos_2"):getPositionY())
		if_set_visible(arg_25_0.wnd, "n_clear", false)
		
		local var_25_5 = arg_25_0.wnd:getChildByName("n_all_reward")
		
		var_25_5:setVisible(true)
		if_set(var_25_5, "txt_title", T("substory_quest_chapter_ui_title2"))
		if_set(var_25_5, "txt_desc", T("substory_quest_chapter_ui_desc2"))
		
		local var_25_6 = var_25_5:getChildByName("n_eff")
		
		var_25_6:setVisible(true)
		arg_25_0:playQuestRewardEffect(var_25_6, "quest", arg_25_1)
	elseif tonumber(var_25_3) == SUBSTORY_QUEST_STATE.ACTIVE then
		if_set_visible(arg_25_0.wnd, "n_clear", false)
		if_set_opacity(arg_25_0.wnd, "n_clear", 255)
		if_set_visible(arg_25_0.wnd, "n_all_reward", false)
		
		local var_25_7 = arg_25_0.wnd:getChildByName("scrollview")
		
		var_25_7:setPositionY(arg_25_0.wnd:getChildByName("scroll_pos_1"):getPositionY())
		var_25_7:setContentSize(600, 450)
		var_25_7:scrollToTop(0, false)
	else
		if_set_visible(arg_25_0.wnd, "n_clear", true)
		
		if tonumber(var_25_3) == SUBSTORY_QUEST_STATE.CLEAR then
			local var_25_8 = arg_25_0.wnd:getChildByName("scrollview")
			
			var_25_8:setContentSize(600, 347)
			var_25_8:scrollToTop(0, false)
			var_25_8:setPositionY(arg_25_0.wnd:getChildByName("scroll_pos_2"):getPositionY())
			
			local var_25_9 = arg_25_0.wnd:getChildByName("n_clear")
			
			var_25_9:setVisible(true)
			var_25_9:setOpacity(255)
			if_set_visible(arg_25_0.wnd, "n_all_reward", false)
			if_set(arg_25_0.wnd, "txt_desc_0", T("sub_quest_chapter_ui_title"))
			if_set(arg_25_0.wnd, "txt_desc", T("substory_quest_chapter_ui_desc"))
			if_set(arg_25_0.wnd, "btn_questreward_label", T("mission_clear_prize"))
			arg_25_0.wnd:getChildByName("btn_questreward"):setVisible(true)
			
			local var_25_10 = var_25_9:getChildByName("n_eff")
			
			var_25_10:setVisible(true)
			arg_25_0:playQuestRewardEffect(var_25_10, "chapter", arg_25_1)
		elseif tonumber(var_25_3) == SUBSTORY_QUEST_STATE.REWARDED then
			arg_25_0.wnd:getChildByName("scrollview"):setVisible(false)
			arg_25_0.wnd:getChildByName("btn_questreward"):setVisible(false)
			if_set_visible(arg_25_0.wnd, "n_clear", true)
			if_set_opacity(arg_25_0.wnd, "n_clear", 255)
			if_set_visible(arg_25_0.wnd, "n_all_reward", false)
			if_set(arg_25_0.wnd, "txt_desc_0", T("sub_quest_chapter_ui_title"))
			if_set(arg_25_0.wnd, "txt_desc", T("sub_mission_no_ep"))
			if_set(arg_25_0.wnd, "btn_questreward_label", T("mission_next_ch"))
			
			local var_25_11 = arg_25_0.wnd:getChildByName("n_clear")
			
			if get_cocos_refid(var_25_11) then
				local var_25_12 = var_25_11:getChildByName("n_eff")
				
				if get_cocos_refid(var_25_12) then
					var_25_12:setVisible(false)
				end
			end
		end
	end
	
	if false then
	end
end

function SubMissionNavigator.getScrollViewItem(arg_27_0, arg_27_1)
	local var_27_0 = load_dlg("mission_item", true, "wnd")
	
	var_27_0.parent = arg_27_0
	
	arg_27_0:updateItem(var_27_0, arg_27_1)
	
	return var_27_0
end

function SubMissionNavigator.shortcut(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	if arg_28_2 == SUBSTORY_ACHIEVE_STATE.ACTIVE or arg_28_2 == "active" then
		SoundEngine:play("event:/ui/ok")
		arg_28_0:backNavi()
		print("이 여정으로 바로가기!")
		movetoPath(arg_28_4)
	elseif arg_28_2 == SUBSTORY_ACHIEVE_STATE.CLEAR then
		SoundEngine:play("event:/ui/price_clear")
		query("get_reward_substory_quest", {
			contents_id = arg_28_1
		})
	elseif arg_28_2 == SUBSTORY_ACHIEVE_STATE.REWARDED then
		balloon_message_with_sound("quest_chapter_after_clear")
	else
		balloon_message_with_sound("quest_not_yet_unexecutable")
	end
end

function SubMissionNavigator.updateQuest(arg_29_0)
	local var_29_0 = SubstoryManager:getClearQuestNotiCount()
	
	if get_cocos_refid(arg_29_0.wnd) then
		local var_29_1 = arg_29_0.wnd:getChildByName("btn_quest")
		
		if get_cocos_refid(var_29_1) then
			if_set_visible(var_29_1, "icon_new", var_29_0 > 0)
			if_set(var_29_1, "label_icon_new", var_29_0)
		end
	end
end

function SubMissionNavigator.test(arg_30_0)
end

function SubMissionNavigator.updateItem(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0.mode == "QUEST" then
		local var_31_0, var_31_1, var_31_2, var_31_3, var_31_4, var_31_5, var_31_6, var_31_7, var_31_8, var_31_9, var_31_10, var_31_11 = DB("substory_quest", arg_31_2.id or arg_31_2, {
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
			"set_drop_rate_id1",
			"state_id"
		})
		local var_31_12 = ConditionContentsManager:getSubStoryQuest()
		local var_31_13 = arg_31_2.state
		local var_31_14 = arg_31_1:getChildByName("n_urgent")
		
		var_31_14.contents_state = var_31_11
		
		if var_31_13 == SUBSTORY_QUEST_STATE.ACTIVE or var_31_13 == SUBSTORY_QUEST_STATE.CLEAR then
			var_31_14:setOpacity(255)
		else
			var_31_14:setOpacity(63.75)
		end
		
		if not var_31_13 or var_31_13 == SUBSTORY_QUEST_STATE.INACTIVE then
			if_set(var_31_14, "txt_name", T("mission_name_unlock"))
			if_set(var_31_14, "txt_desc", T("mission_name_desc2"))
			if_set(var_31_14, "txt_title", T("mission_name_desc"))
			
			var_31_3 = "m0000"
		else
			if_set(var_31_14, "txt_name", T(var_31_0))
			if_set(var_31_14, "txt_desc", T(var_31_2) or "")
			if_set(var_31_14, "txt_title", T(var_31_1))
		end
		
		local var_31_15 = var_31_12:getScore(arg_31_2.id)
		local var_31_16 = totable(var_31_6).count or "1"
		
		var_31_14:getChildByName("progress"):setPercent(var_31_15 / var_31_16 * 100)
		if_set(var_31_14, "txt_progress", var_31_15 .. "/" .. var_31_16)
		
		local var_31_17 = var_31_14:getChildByName("txt_title")
		
		var_31_17:setPositionX(var_31_17:getPositionX() - 20)
		var_31_17:setVisible(true)
		if_set_visible(var_31_14, "txt_time_title", false)
		if_set_visible(var_31_14, "cm_icon_etctime_b_16", false)
		if_set_sprite(var_31_14, "img_face", "face/" .. var_31_3 .. "_s.png")
		
		local var_31_18 = var_31_14:getChildByName("icon")
		local var_31_19 = {
			tooltip_x = -170,
			skill_preview = true,
			parent = var_31_14:getChildByName("icon"),
			set_drop = var_31_10,
			grade_rate = var_31_9
		}
		local var_31_20 = UIUtil:getRewardIcon(var_31_5, var_31_4, var_31_19)
		
		table.insert(arg_31_0.rewardIcons, var_31_20)
		
		local var_31_21 = var_31_14:getChildByName("btn_place_go")
		
		var_31_21.mission_id = arg_31_2.id
		var_31_21.mission_state = var_31_13
		var_31_21.map_id = var_31_7
		var_31_21.short_cut = var_31_8
		
		local var_31_22 = var_31_14:getChildByName("btn_detail")
		
		if get_cocos_refid(var_31_22) then
			var_31_22.quest_id = arg_31_2.id
		end
		
		local var_31_23 = arg_31_1:getChildByName("n_complet")
		
		UIUtil:setColorRewardButtonState(var_31_13, arg_31_1, var_31_21, {
			add_x_clear = 0
		})
		arg_31_0:updateQuestItemLockControl(var_31_14, arg_31_2.id, var_31_13)
		if_set_visible(var_31_21, nil, var_31_13 ~= SUBSTORY_ACHIEVE_STATE.REWARDED)
		if_set_visible(var_31_23, nil, var_31_13 == SUBSTORY_ACHIEVE_STATE.REWARDED)
	elseif arg_31_0.mode == "URGENT" then
		local var_31_24, var_31_25, var_31_26, var_31_27, var_31_28, var_31_29, var_31_30, var_31_31, var_31_32, var_31_33, var_31_34 = DB("mission_data", arg_31_2.id or arg_31_2, {
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
		local var_31_35
		local var_31_36 = arg_31_1:getChildByName("n_urgent")
		
		if_set(var_31_36, "txt_name", T(var_31_24))
		if_set(var_31_36, "txt_desc", T(var_31_26) or "")
		
		local var_31_37 = ConditionContentsManager:getUrgentMissions()
		local var_31_38 = var_31_37:getScore(arg_31_2)
		local var_31_39 = var_31_37:getMaxCount(arg_31_2)
		
		var_31_36:getChildByName("progress"):setPercent(var_31_38 / var_31_39 * 100)
		if_set(var_31_36, "txt_progress", var_31_38 .. "/" .. var_31_39)
		if_set_visible(var_31_36, "txt_time_title", true)
		if_set_visible(var_31_36, "txt_title", false)
		
		local var_31_40 = var_31_37:getRemainTime(arg_31_2)
		
		if var_31_40 < 0 then
			if_set(var_31_36, "txt_time_title", T("urgent_time_expire"))
		else
			if_set(var_31_36, "txt_time_title", T("remain_time_urgent", {
				time = sec_to_full_string(var_31_40, true)
			}))
		end
		
		if_set_sprite(var_31_36, "img_face", "face/" .. var_31_27 .. "_s.png")
		if_set_visible(var_31_36, "n_locked", false)
		
		local var_31_41 = {
			tooltip_x = -170,
			parent = var_31_36:getChildByName("icon"),
			set_drop = var_31_34,
			grade_rate = var_31_33
		}
		local var_31_42 = UIUtil:getRewardIcon(var_31_29, var_31_28, var_31_41)
		
		table.insert(arg_31_0.rewardIcons, var_31_42)
		
		local var_31_43 = var_31_36:getChildByName("btn_place_go")
		
		var_31_43.mission_id = arg_31_2
		var_31_43.mission_state = "active"
		var_31_43.map_id = var_31_31
		var_31_43.short_cut = var_31_32
		var_31_43.urgent_mission = true
		
		local var_31_44 = arg_31_1:getChildByName("n_complet")
		
		if_set_visible(var_31_44, nil, false)
		if_set_visible(var_31_43, nil, true)
	end
end

function SubMissionNavigator.updateQuestItemLockControl(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_1.contents_state then
		local var_32_0 = ConditionContentsState:getClearData(arg_32_1.contents_state)
		local var_32_1 = var_32_0.is_cleared
		
		if_set_visible(arg_32_1, "n_locked", not var_32_1)
		if_set_visible(arg_32_1, "btn_place_go", var_32_1)
		if_set_visible(arg_32_1, "txt_desc", var_32_1)
		if_set_visible(arg_32_1, "btn_label", var_32_1)
		
		if var_32_0 and not var_32_0.is_cleared then
			if_set(arg_32_1, "txt_title", T("quest_lock_title"))
			if_set(arg_32_1, "txt_name", T("quest_lock_desc"))
		end
		
		local var_32_2 = arg_32_1:getChildByName("txt_desc_locked")
		
		if not arg_32_3 or arg_32_3 == SUBSTORY_QUEST_STATE.INACTIVE then
			var_32_2:setTextColor(cc.c3b(0, 0, 0))
		else
			var_32_2:enableOutline(cc.c3b(253, 252, 250), 1)
			var_32_2:setTextColor(cc.c3b(96, 61, 42))
		end
	else
		if_set_visible(arg_32_1, "n_locked", false)
	end
end

CustomWorldMapUI = CustomWorldMapUI or {}

copy_functions(SubWorldMapUI, CustomWorldMapUI)

function CustomWorldMapUI.create(arg_33_0, arg_33_1)
	arg_33_0.controller = arg_33_1
	
	local var_33_0 = arg_33_0:initUI()
	
	arg_33_0:_createTopbar(var_33_0)
	
	arg_33_0.navi = CustomMissionNavigator
	
	arg_33_0.navi:init(arg_33_0.RIGHT, arg_33_0.controller, arg_33_0)
	arg_33_0.navi:updateQuest()
	arg_33_0:updateNotifier()
	
	return var_33_0
end

CustomMissionNavigator = CustomMissionNavigator or {}

copy_functions(SubMissionNavigator, CustomMissionNavigator)

function HANDLER.map_stage_unlock(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	if arg_34_1 == "btn_cancel" then
		Dialog:close("map_stage_unlock")
	elseif arg_34_1 == "btn_open" or arg_34_1 == "btn_open2" then
		SubstoryEnterLockPopup:unlock()
	end
end

function MsgHandler.unlock_substory_dungeon(arg_35_0)
	if arg_35_0.result then
		Account:addReward(arg_35_0.result)
	end
	
	if arg_35_0.property_info then
		SubstoryManager:setDungeonProperty(arg_35_0.property_info)
	end
	
	SubstoryEnterLockPopup:res_unlock(arg_35_0)
end

SubstoryEnterLockPopup = SubstoryEnterLockPopup or {}

function SubstoryEnterLockPopup.show(arg_36_0, arg_36_1, arg_36_2)
	Dialog:close("map_stage_unlock")
	
	arg_36_1 = arg_36_1 or SceneManager:getRunningPopupScene()
	
	local var_36_0 = Dialog:open("wnd/map_stage_unlock", arg_36_0)
	local var_36_1 = SubstoryManager:getDungeonPropertyDB(arg_36_2)
	
	arg_36_0.vars = {}
	arg_36_0.vars.property_db = var_36_1
	arg_36_0.vars.wnd = var_36_0
	
	local var_36_2
	
	if var_36_1.hide_count then
		if_set_visible(arg_36_0.vars.wnd, "btn_open", false)
		if_set_visible(arg_36_0.vars.wnd, "btn_open2", true)
		
		var_36_2 = var_36_0:getChildByName("btn_open2")
	else
		if_set(var_36_0, "txt_price", arg_36_0.vars.property_db.unlock_count)
		
		var_36_2 = var_36_0:getChildByName("btn_open")
	end
	
	local var_36_3 = var_36_2:getChildByName("icon_item")
	
	if arg_36_0.vars.property_db.unlock_icon then
		if_set_sprite(var_36_0, "icon_stage_lock", "img/" .. arg_36_0.vars.property_db.unlock_icon .. ".png")
	end
	
	if arg_36_0.vars.property_db.unlock_popup_title then
		if_set(var_36_0, "txt_title", T(arg_36_0.vars.property_db.unlock_popup_title))
	end
	
	if arg_36_0.vars.property_db.unlock_popup_desc then
		if_set(var_36_0, "txt_info", T(arg_36_0.vars.property_db.unlock_popup_desc))
	end
	
	if arg_36_0.vars.property_db.unlock_popup_btn then
		if_set(var_36_2, "txt_open", T(arg_36_0.vars.property_db.unlock_popup_btn))
	end
	
	UIUtil:getRewardIcon(nil, arg_36_0.vars.property_db.unlock_material, {
		icon_scale = 1,
		no_tooltip = true,
		no_bg = true,
		parent = var_36_3
	})
	
	arg_36_0.vars.show_eff = var_36_1.unlock_popup_effect
	
	arg_36_1:addChild(var_36_0)
end

function SubstoryEnterLockPopup.res_unlock(arg_37_0, arg_37_1)
	SoundEngine:play("event:/ui/popup/btn_stage_unlock")
	
	if arg_37_0.vars.show_eff then
		local var_37_0 = 5000
		local var_37_1 = arg_37_0.vars.wnd
		
		UIAction:Add(SEQ(CALL(function()
			EffectManager:Play({
				pivot_x = 640,
				pivot_y = 350,
				pivot_z = 99998,
				fn = arg_37_0.vars.show_eff .. ".cfx",
				layer = var_37_1
			})
		end), DELAY(var_37_0), CALL(function()
			Dialog:close("map_stage_unlock")
			
			local var_39_0 = WorldMapManager:getController():getTown()
			local var_39_1 = var_39_0:getMapInfo(arg_37_1.map)
			
			if var_39_1 then
				var_39_0:showMapDialog(var_39_1)
				var_39_0:updateLock(nil, arg_37_1.map)
			else
				Log.e("unlock_substory_dungeon", "no_map_info")
			end
		end)), SubstoryEnterLockPopup, "block")
	else
		UIAction:Add(SEQ(DELAY(500), CALL(function()
			Dialog:close("map_stage_unlock")
			
			local var_40_0 = WorldMapManager:getController():getTown()
			local var_40_1 = var_40_0:getMapInfo(arg_37_1.map)
			
			if var_40_1 then
				var_40_0:showMapDialog(var_40_1)
				var_40_0:updateLock(nil, arg_37_1.map)
			else
				Log.e("unlock_substory_dungeon", "no_map_info")
			end
		end)), SubstoryEnterLockPopup, "block")
	end
end

function SubstoryEnterLockPopup.unlock(arg_41_0)
	if not arg_41_0.vars then
		return 
	end
	
	if not arg_41_0.vars.property_db then
		return 
	end
	
	if Account:getItemCount(arg_41_0.vars.property_db.unlock_material) < arg_41_0.vars.property_db.unlock_count then
		balloon_message_with_sound("req_stage_lock")
		
		return 
	end
	
	local var_41_0 = SubstoryManager:getInfo()
	
	query("unlock_substory_dungeon", {
		enter_id = arg_41_0.vars.property_db.id,
		substory_id = var_41_0.id
	})
end

SubstoryResetItemPopup = {}

function HANDLER.map_custom_reset(arg_42_0, arg_42_1)
	if arg_42_1 == "btn_ok" then
		SubstoryResetItemPopup:resetCustomItem()
	elseif arg_42_1 == "btn_cancel" then
		SubstoryResetItemPopup:close()
	end
end

function MsgHandler.reset_substory_custom_item_story(arg_43_0)
	SubstoryManager:setDungeonProperty(arg_43_0.property_info)
	
	local var_43_0 = arg_43_0.item_infos or {}
	
	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		Account:setItemCount(iter_43_1.code, iter_43_1.c)
	end
	
	if arg_43_0.property_info and arg_43_0.property_info.substory_id then
		Account:setSubStoryStories(arg_43_0.property_info.substory_id, {
			clear_count = {}
		})
	end
	
	if arg_43_0.map then
		local var_43_1 = WorldMapManager:getController():getTown()
		local var_43_2 = var_43_1:getMapInfo(arg_43_0.map)
		
		if var_43_2 then
			var_43_1:showMapDialog(var_43_2)
			var_43_1:updateLock(nil, arg_43_0.map)
		else
			Log.e("unlock_substory_dungeon", "no_map_info")
		end
	end
	
	SubstoryResetItemPopup:saveLastTown()
	SubstoryResetItemPopup:close()
	SubstoryCustomItemPopup:updateCustomItemUI(true)
end

function SubstoryResetItemPopup.show(arg_44_0, arg_44_1, arg_44_2)
	if not arg_44_2 then
		return 
	end
	
	local var_44_0 = arg_44_1 or SceneManager:getRunningPopupScene()
	local var_44_1 = SubstoryManager:getDungeonPropertyDB(arg_44_2)
	
	arg_44_0.vars = {}
	arg_44_0.vars.enter_id = arg_44_2
	arg_44_0.vars.property_db = var_44_1
	arg_44_0.vars.substory_info = SubstoryManager:getInfo() or {}
	arg_44_0.vars.wnd = load_dlg("map_custom_reset", true, "wnd")
	
	if_set(arg_44_0.vars.wnd, "txt_disc", T(arg_44_0.vars.property_db.reset_popup_desc))
	if_set(arg_44_0.vars.wnd, "txt_title", T(arg_44_0.vars.property_db.reset_popup_title))
	if_set(arg_44_0.vars.wnd, "txt_warn", T(arg_44_0.vars.property_db.reset_popup_warning))
	if_set(arg_44_0.vars.wnd:getChildByName("btn_cancel"), "label", T("ui_msgbox_cancel"))
	if_set(arg_44_0.vars.wnd:getChildByName("btn_ok"), "label", T("ui_msgbox_ok"))
	var_44_0:addChild(arg_44_0.vars.wnd)
end

function SubstoryResetItemPopup.saveLastTown(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	local var_45_0 = WorldMapManager:getController()
	
	if var_45_0 and arg_45_0.vars.enter_id then
		var_45_0:saveLastTown(arg_45_0.vars.enter_id)
	end
end

function SubstoryResetItemPopup.resetCustomItem(arg_46_0)
	if not arg_46_0.vars then
		return 
	end
	
	query("reset_substory_custom_item_story", {
		substory_id = arg_46_0.vars.substory_info.id,
		enter_id = arg_46_0.vars.property_db.id
	})
end

function SubstoryResetItemPopup.close(arg_47_0)
	if not arg_47_0.vars then
		return 
	end
	
	arg_47_0.vars.wnd:removeFromParent()
	
	arg_47_0.vars = {}
end

SubstoryCustomItemPopup = {}

function SubstoryCustomItemPopup.init(arg_48_0, arg_48_1)
	if not arg_48_1 then
		return 
	end
	
	arg_48_0.vars = {}
	arg_48_0.vars.parent_wnd = arg_48_1
	arg_48_0.vars.isFold = false
	
	local var_48_0 = SubstoryManager:getInfo() or {}
	local var_48_1 = var_48_0.id
	
	arg_48_0.vars.subCusList = SubStoryUtil:getSubCusItemList(var_48_1)
	
	if not arg_48_0.vars.subCusList or table.empty(arg_48_0.vars.subCusList) then
		return 
	end
	
	arg_48_0.vars.custom_item_title = var_48_0.custom_item_title or "temp_title"
	
	if_set(arg_48_0.vars.parent_wnd:getChildByName("n_spread"), "txt_title", T(arg_48_0.vars.custom_item_title))
	if_set(arg_48_0.vars.parent_wnd:getChildByName("n_fold"), "txt_title", T(arg_48_0.vars.custom_item_title))
	if_set_visible(arg_48_1, "n_star_rewards", false)
	if_set_visible(arg_48_1, "n_custom", true)
	if_set_visible(arg_48_1, "n_spread", not arg_48_0.vars.isFold)
	if_set_visible(arg_48_1, "n_fold", arg_48_0.vars.isFold)
	
	if table.count(arg_48_0.vars.subCusList) >= 5 then
		local var_48_2 = arg_48_1:getChildByName("n_spread")
		
		if var_48_2 and not var_48_2.origin_height then
			local var_48_3 = var_48_2:getContentSize()
			
			var_48_2:setContentSize(var_48_3.width, var_48_3.height + 43)
		end
	end
	
	arg_48_0:updateCustomItemUI()
	
	local var_48_4 = NOTCH_WIDTH
	local var_48_5 = arg_48_1:getChildByName("n_custom")
	
	if var_48_4 > 0 and var_48_5 and not var_48_5.origin_x and not NotchStatus:isLeft() then
		var_48_5.origin_x = var_48_5:getPositionX()
		
		var_48_5:setPositionX(var_48_5.origin_x + var_48_4 / 2)
	end
end

function SubstoryCustomItemPopup.toggleCustomItemUI(arg_49_0)
	if not arg_49_0.vars or not arg_49_0.vars.parent_wnd or table.empty(arg_49_0.vars.subCusList) then
		return 
	end
	
	arg_49_0.vars.isFold = not arg_49_0.vars.isFold
	
	if_set_visible(arg_49_0.vars.parent_wnd, "n_spread", not arg_49_0.vars.isFold)
	if_set_visible(arg_49_0.vars.parent_wnd, "n_fold", arg_49_0.vars.isFold)
end

function SubstoryCustomItemPopup.updateCustomItemUI(arg_50_0, arg_50_1)
	if not arg_50_0.vars or not arg_50_0.vars.parent_wnd or table.empty(arg_50_0.vars.subCusList) then
		return 
	end
	
	if arg_50_1 then
		for iter_50_0, iter_50_1 in pairs(arg_50_0.vars.subCusList) do
			iter_50_1.count = Account:getItemCount(iter_50_1.id) or 0
		end
	end
	
	local var_50_0 = arg_50_0.vars.parent_wnd:getChildByName("n_spread")
	local var_50_1 = var_50_0:getChildByName("n_reward")
	local var_50_2 = arg_50_0.vars.parent_wnd:getChildByName("n_fold"):getChildByName("n_reward")
	local var_50_3 = table.count(arg_50_0.vars.subCusList) % 2 == 1
	local var_50_4 = false
	
	for iter_50_2, iter_50_3 in pairs(arg_50_0.vars.subCusList) do
		local var_50_5 = var_50_1:getChildByName("n_" .. iter_50_2)
		
		if not var_50_5 then
			break
		end
		
		var_50_5:setVisible(true)
		UIUtil:getRewardIcon(nil, iter_50_3.id, {
			parent = var_50_5:getChildByName("n_item" .. iter_50_2)
		})
		if_set(var_50_5, "txt_name" .. iter_50_2, T(iter_50_3.name))
		if_set(var_50_5, "txt_count" .. iter_50_2, iter_50_3.count)
		
		if iter_50_2 == 5 then
			var_50_4 = true
		end
	end
	
	if var_50_4 and not var_50_0.move_pos then
		var_50_0:setPositionY(var_50_0:getPositionY() + 43)
		
		local var_50_6 = var_50_0:getChildByName("bar")
		
		var_50_6:setPositionY(var_50_6:getPositionY() - 43)
		
		var_50_0.move_pos = true
	end
	
	if_set_visible(var_50_2, "n_odd", var_50_3)
	if_set_visible(var_50_2, "n_even", not var_50_3)
	
	local var_50_7
	
	if var_50_3 then
		var_50_7 = var_50_2:getChildByName("n_odd")
	else
		var_50_7 = var_50_2:getChildByName("n_even")
	end
	
	for iter_50_4, iter_50_5 in pairs(arg_50_0.vars.subCusList) do
		local var_50_8 = var_50_7:getChildByName("n_" .. iter_50_4)
		
		if not var_50_8 then
			break
		end
		
		var_50_8:setVisible(true)
		UIUtil:getRewardIcon(nil, iter_50_5.id, {
			parent = var_50_8:getChildByName("n_item" .. iter_50_4)
		})
		if_set(var_50_8, "txt_name" .. iter_50_4, T(iter_50_5.name))
		if_set(var_50_8, "txt_count" .. iter_50_4, iter_50_5.count)
	end
end
