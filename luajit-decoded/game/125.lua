function HANDLER.dungeon_story_achieve_hint(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		Dialog:close("dungeon_story_achieve_hint")
	end
end

function HANDLER.dungeon_story_achieve_pre(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		Dialog:close("dungeon_story_achieve_pre")
	end
	
	if arg_2_1 == "btn_go" then
		if SubstoryManager:checkEndEvent() == true then
			balloon_message_with_sound("substory_wait_msg")
			
			return 
		end
		
		if arg_2_0.state == SUBSTORY_ACHIEVE_STATE.ACTIVE and arg_2_0.move then
			local var_2_0 = SceneManager:getCurrentSceneName()
			local var_2_1 = SubstoryManager:getContentsController()
			
			if SubstoryManager:isWorldMapTypeContents() and SubstoryManager:isSubstoryLobbyScene(var_2_0) == false and var_2_0 ~= "substory_dlc_lobby" then
				local var_2_2 = var_2_1:getWorldMapNavi()
				
				if var_2_2.isOpen then
					var_2_2:backNavi()
				end
				
				Dialog:close("dungeon_story_achieve_pre")
			end
			
			movetoPath(arg_2_0.move)
			
			return 
		elseif arg_2_0.state == SUBSTORY_ACHIEVE_STATE.CLEAR then
			query("get_reward_substory_achievement", {
				contents_id = arg_2_0.contents_id
			})
		end
	end
	
	if arg_2_1 == "btn_get" then
		if arg_2_0.is_reward then
			query("get_reward_all_achievement", {
				substory_id = arg_2_0.substory_id
			})
		else
			balloon_message_with_sound("substory_achieve_no_complete")
			
			return 
		end
	end
end

function HANDLER.dungeon_story_achieve(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Dialog:close("dungeon_story_achieve")
		UIAction:Add(DELAY(100), SceneManager:getDefaultLayer(), "block")
	end
	
	if arg_3_1 == "btn_go" then
		SubstoryAchievePopup:onBtnGoEvent(arg_3_0)
	end
	
	if arg_3_1 == "btn_get" then
		if arg_3_0.is_reward then
			query("get_reward_all_achievement", {
				substory_id = arg_3_0.substory_id
			})
		else
			balloon_message_with_sound("substory_achieve_no_complete")
			
			return 
		end
	end
	
	if arg_3_1 == "btn_all" then
		SubstoryAchievePopup:queryReceiveAllReward()
	end
end

function MsgHandler.receive_substory_achieve_all_reward(arg_4_0)
	if arg_4_0.sub_doc then
		Account:setSubStory(arg_4_0.sub_doc.substory_id, arg_4_0.sub_doc)
	end
	
	local var_4_0
	
	if arg_4_0.achieve_attributes then
		for iter_4_0, iter_4_1 in pairs(arg_4_0.achieve_attributes) do
			Account:setSubStoryAchievement(iter_4_1)
			SubstoryAchievePopup:updateState(iter_4_0, iter_4_1.state)
			SubstoryQuestLinkAchieve:updateState(iter_4_0, iter_4_1.state)
			
			local var_4_1, var_4_2 = DB("substory_achievement", iter_4_0, {
				"id",
				"hide_reward_id1"
			})
			
			if var_4_1 and var_4_2 then
				var_4_0 = var_4_0 or {}
				
				table.insert(var_4_0, var_4_2)
			end
		end
	end
	
	local var_4_3 = Account:addReward(arg_4_0.rewards, {
		no_rtn_reward_randombox = true,
		hide_reward_id = var_4_0
	})
	
	Dialog:msgScrollRewards(T("substory_achieve_reward_get"), {
		open_effect = true,
		title = T("ui_msgbox_rewards_title"),
		rewards = {
			new_items = var_4_3.rewards
		}
	})
	SubstoryAchievePopup:sort()
	SubstoryAchievePopup:refreshListView()
	SubstoryQuestLinkAchieve:sort()
	SubstoryQuestLinkAchieve:refreshListView()
	SubStoryLobby:updateUI()
	SubStoryDlcLobby:updateUI()
	SubstoryAchievePopup:updateUI()
	SubstoryManager:updateNotifierContentsUI()
	ShopExclusiveEquip_result:open_resultPopup(arg_4_0, {
		type = "substory_achievement"
	})
end

function MsgHandler.get_reward_substory_achievement(arg_5_0)
	Account:setSubStoryAchievement(arg_5_0.doc_achieve)
	SubstoryAchievePopup:updateState(arg_5_0.contents_id, arg_5_0.doc_achieve.state)
	SubstoryQuestLinkAchieve:updateState(arg_5_0.contents_id, arg_5_0.doc_achieve.state)
	
	local var_5_0 = {
		title = T("quest_chapter_reward_title"),
		desc = T("substroy_achievement_reward_desc")
	}
	local var_5_1
	local var_5_2, var_5_3 = DB("substory_achievement", arg_5_0.contents_id, {
		"id",
		"hide_reward_id1"
	})
	
	if var_5_2 and var_5_3 then
		var_5_1 = var_5_1 or {}
		
		table.insert(var_5_1, var_5_3)
	end
	
	local var_5_4 = Account:addReward(arg_5_0.rewards, {
		force_character_effect_handler = true,
		play_reward_data = var_5_0,
		hide_reward_id = var_5_1,
		handler = function()
			local var_6_0 = SubstoryManager:getInfo()
			local var_6_1 = SceneManager:getCurrentSceneName()
			local var_6_2 = var_6_1 == "world_custom" or var_6_1 == "world_sub" or var_6_1 == "substory_dlc_lobby"
			
			if var_6_0 and var_6_0.id and var_6_2 and arg_5_0 and arg_5_0.contents_id and arg_5_0.contents_id == "vrasex_ach_26" and Account:isClearedSubStoryAchievement("vrasex_ach_26") and TutorialGuide:startGuide("vrasex_skin_buy_dlc") then
				return 
			end
		end
	})
	
	SubstoryAchievePopup:sort()
	SubstoryAchievePopup:refreshListView()
	SubstoryQuestLinkAchieve:sort()
	SubstoryQuestLinkAchieve:refreshListView()
	SubStoryLobby:updateUI()
	SubStoryDlcLobby:updateUI()
	SubstoryManager:updateNotifierContentsUI()
	SubstoryAchievePopup:updateUI()
	ShopExclusiveEquip_result:open_resultPopup(arg_5_0, {
		type = "substory_achievement"
	})
	
	local var_5_5 = WorldMapManager:getController()
	
	if var_5_5 then
		var_5_5:refreshAllLocalIcons()
	end
end

function MsgHandler.get_reward_all_achievement(arg_7_0)
	if arg_7_0.sub_doc then
		Account:setSubStory(arg_7_0.sub_doc.substory_id, arg_7_0.sub_doc)
	end
	
	local var_7_0 = {
		title = T("substory_ach_complete_rewrad_title"),
		desc = T("substory_ach_complete_rewrad_desc")
	}
	
	Account:addReward(arg_7_0.result, {
		play_reward_data = var_7_0
	})
	SubstoryAchievePopup:updateUI()
	SubStoryLobby:updateUI()
	SubStoryDlcLobby:updateUI()
	SubstoryManager:updateNotifierContentsUI()
	
	local var_7_1 = WorldMapManager:getController()
	
	if var_7_1 then
		var_7_1:refreshAllLocalIcons()
	end
end

SubstoryAchievePopup = SubstoryAchievePopup or {}

function SubstoryAchievePopup.updateState(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars or not arg_8_0.vars.data then
		return 
	end
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.data or {}) do
		if iter_8_1.id == arg_8_1 then
			iter_8_1.state = arg_8_2
			
			break
		end
	end
end

function SubstoryAchievePopup.sort(arg_9_0)
	if not arg_9_0.vars or not arg_9_0.vars.data then
		return 
	end
	
	local var_9_0 = {
		[SUBSTORY_ACHIEVE_STATE.CLEAR] = 2,
		[SUBSTORY_ACHIEVE_STATE.ACTIVE] = 1,
		[SUBSTORY_ACHIEVE_STATE.REWARDED] = 0
	}
	
	table.sort(arg_9_0.vars.data, function(arg_10_0, arg_10_1)
		local var_10_0 = arg_10_0.state
		local var_10_1 = arg_10_1.state
		
		if var_10_0 == var_10_1 then
			return arg_10_0.sort < arg_10_1.sort
		else
			return var_9_0[var_10_0] > var_9_0[var_10_1]
		end
	end)
end

local function var_0_0(arg_11_0)
	local var_11_0 = {}
	
	var_11_0.id, var_11_0.condition, var_11_0.value, var_11_0.name, var_11_0.desc, var_11_0.icon, var_11_0.reward_id1, var_11_0.reward_count1, var_11_0.grade_rate1, var_11_0.set_drop_rate_id1, var_11_0.btn_move, var_11_0.sort, var_11_0.hide, var_11_0.enter_stage, var_11_0.enter_story, var_11_0.hidden, var_11_0.hint_desc, var_11_0.hint_icon, var_11_0.unlock_state_id = DB("substory_achievement", arg_11_0, {
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
		"enter_stage",
		"enter_story",
		"hidden",
		"hint_desc",
		"hint_icon",
		"unlock_state_id"
	})
	
	return var_11_0
end

function SubstoryAchievePopup.setDataSource(arg_12_0)
	local var_12_0 = SubstoryManager:getInfo().id
	
	arg_12_0.vars.data = {}
	
	for iter_12_0 = 1, 999 do
		local var_12_1 = var_12_0 .. "_" .. "ach_" .. string.format("%02d", iter_12_0)
		local var_12_2 = var_0_0(var_12_1)
		
		if not var_12_2.id then
			break
		end
		
		var_12_2.state = (Account:getSubStoryAchievement(var_12_1) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE
		
		local var_12_3 = var_12_2.unlock_state_id == nil or ConditionContentsState:isClearedByStateID(var_12_2.unlock_state_id)
		
		if not var_12_2.hide and var_12_3 then
			table.insert(arg_12_0.vars.data, var_12_2)
		end
	end
	
	arg_12_0:sort()
	arg_12_0.vars.listView:setDataSource(arg_12_0.vars.data)
end

function SubstoryAchievePopup.show(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or {}
	
	if SubstoryManager:checkEndEvent() == true then
		balloon_message_with_sound("substory_wait_msg")
		
		return 
	end
	
	ConditionContentsManager:dispatch("subachieve.clear")
	
	arg_13_0.vars = {}
	arg_13_0.vars.opts = arg_13_2
	arg_13_1 = arg_13_1 or SceneManager:getDefaultLayer()
	arg_13_0.vars.wnd = Dialog:open("wnd/dungeon_story_achieve", arg_13_0)
	
	arg_13_1:addChild(arg_13_0.vars.wnd)
	if_set_visible(arg_13_0.vars.wnd, "btn_all", true)
	
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("listview")
	
	arg_13_0.vars.listView = ItemListView_v2:bindControl(var_13_0)
	
	local var_13_1 = load_control("wnd/dungeon_story_achieve_item.csb")
	
	if var_13_0.STRETCH_INFO then
		local var_13_2 = var_13_0:getContentSize()
		
		resetControlPosAndSize(var_13_1, var_13_2.width, var_13_0.STRETCH_INFO.width_prev)
	end
	
	local var_13_3 = {
		onUpdate = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			SubstoryAchievePopup:updateItem(arg_14_1, arg_14_3)
			
			return arg_14_3.id
		end
	}
	
	arg_13_0.vars.listView:setRenderer(var_13_1, var_13_3)
	arg_13_0.vars.listView:removeAllChildren()
	
	local var_13_4 = arg_13_0.vars.listView:getInnerContainerPosition()
	
	arg_13_0.vars.listView:setInnerContainerPosition({
		x = var_13_4.x,
		y = var_13_4.y - 15
	})
	arg_13_0:setDataSource()
	arg_13_0:updateUI()
end

function SubstoryAchievePopup.canReceiveItems(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	if not arg_15_0.vars.data then
		return 
	end
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.data) do
		if iter_15_1.hide == nil and iter_15_1.reward_id1 and iter_15_1.state == SUBSTORY_ACHIEVE_STATE.CLEAR then
			return true
		end
	end
	
	local var_15_0 = SubstoryManager:getInfo()
	local var_15_1 = Account:getSubStory(var_15_0.id)
	local var_15_2 = var_15_0.condition_state_id
	
	if (ConditionContentsState:getClearData(var_15_2) or {}).is_cleared and var_15_1.ach_reward_state ~= 2 then
		return true
	end
	
	return false
end

function SubstoryAchievePopup.queryReceiveAllReward(arg_16_0)
	if not arg_16_0:canReceiveItems() then
		balloon_message_with_sound("substory_achieve_reward_false")
		
		return 
	end
	
	local var_16_0 = SubstoryManager:getInfo()
	
	if not var_16_0 then
		return 
	end
	
	query("receive_substory_achieve_all_reward", {
		substory_id = var_16_0.id
	})
end

function SubstoryAchievePopup.enterBattle(arg_17_0, arg_17_1)
	BattleReady:show({
		npc_text_change = true,
		enter_id = arg_17_1.enter_stage,
		callback = ClassChangeQuestList
	})
end

function SubstoryAchievePopup.refreshListView(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.listView) then
		return 
	end
	
	arg_18_0.vars.listView:refresh()
end

function SubstoryAchievePopup.isShow(arg_19_0)
	if arg_19_0.vars and arg_19_0.vars.wnd and get_cocos_refid(arg_19_0.vars.wnd) and arg_19_0.vars.wnd:isVisible() == true then
		return true
	end
	
	return false
end

function SubstoryAchievePopup.close(arg_20_0)
	if arg_20_0.vars and arg_20_0.vars.wnd and get_cocos_refid(arg_20_0.vars.wnd) then
		Dialog:close("dungeon_story_achieve")
	end
end

function SubstoryAchievePopup.updateUI(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_21_0.vars.wnd) then
		return 
	end
	
	local var_21_0 = 0
	local var_21_1 = SubstoryManager:getInfo().condition_state_id
	local var_21_2 = SubstoryManager:getInfo().ac_reward_id
	local var_21_3 = SubstoryManager:getInfo().ac_reward_count
	local var_21_4 = ConditionContentsState:getClearData(var_21_1) or {}
	local var_21_5 = SubstoryManager:getInfo()
	
	if_set(arg_21_0.vars.wnd, "txt_progress", T("ui_dungeon_archieve_progress"))
	if_set(arg_21_0.vars.wnd, "txt_progress_count", var_21_4.clear_cnt .. "/" .. var_21_4.total_cnt)
	
	local var_21_6 = cc.c3b(100, 186, 37)
	local var_21_7 = cc.c3b(255, 255, 255)
	local var_21_8 = 255
	
	if var_21_4.is_cleared then
		var_21_7 = var_21_6
	else
		var_21_8 = 76.5
	end
	
	if_set_color(arg_21_0.vars.wnd, "txt_progress_count", var_21_7)
	
	local var_21_9 = var_21_5.id
	local var_21_10 = Account:getSubStory(var_21_9)
	local var_21_11 = arg_21_0.vars.wnd:getChildByName("btn_get")
	
	var_21_11.is_reward = var_21_10.ach_reward_state ~= 2 and var_21_4.is_cleared
	var_21_11.substory_id = var_21_9
	
	if_set_opacity(arg_21_0.vars.wnd, "btn_get", var_21_8)
	if_set_visible(arg_21_0.vars.wnd, "btn_get", var_21_10.ach_reward_state ~= 2)
	if_set_visible(arg_21_0.vars.wnd, "icon_noti", var_21_10.ach_reward_state == 1 and var_21_4.is_cleared)
	if_set_visible(arg_21_0.vars.wnd, "n_complet", var_21_10.ach_reward_state == 2)
	
	local var_21_12 = arg_21_0.vars.wnd:getChildByName("n_down")
	
	if var_21_2 and var_21_3 then
		local var_21_13 = UIUtil:getRewardIcon(var_21_3, var_21_2, {
			parent = var_21_12:getChildByName("n_item")
		})
		
		if var_21_4.is_cleared and var_21_10 and var_21_10.ach_reward_state == 2 then
			var_21_13:setOpacity(76.5)
			if_set_opacity(arg_21_0.vars.wnd, "txt_reward", 76.5)
		end
	end
	
	if not arg_21_0:canReceiveItems() then
		if_set_opacity(arg_21_0.vars.wnd, "btn_all", 76.5)
	end
	
	if arg_21_0.vars and arg_21_0.vars.opts and type(arg_21_0.vars.opts.callback_update) == "function" then
		arg_21_0.vars.opts.callback_update()
	end
end

function SubstoryAchievePopup.onBtnGoEvent(arg_22_0, arg_22_1)
	if SubstoryManager:checkEndEvent() == true then
		balloon_message_with_sound("substory_wait_msg")
		
		return 
	end
	
	if arg_22_1.state == SUBSTORY_ACHIEVE_STATE.ACTIVE then
		if arg_22_1.enter_stage then
			arg_22_0:enterBattle(arg_22_1)
		elseif arg_22_1.enter_story then
			arg_22_0:close()
			StoryReady:show({
				enter_id = arg_22_1.enter_story
			})
		elseif arg_22_1.hidden then
			arg_22_0:showHint(nil, arg_22_1.hint_icon, arg_22_1.hint_desc)
		elseif arg_22_1.move then
			local var_22_0 = SceneManager:getCurrentSceneName()
			
			if SubstoryManager:isWorldMapTypeContents() and WorldMapManager:isSubstoryWorldMapScene(var_22_0) then
				local var_22_1 = WorldMapManager:getController():getWorldMapNavi()
				
				if var_22_1.isOpen then
					var_22_1:backNavi()
				end
				
				Dialog:close("dungeon_story_achieve")
			end
			
			movetoPath(arg_22_1.move)
			
			return 
		end
	elseif arg_22_1.state == SUBSTORY_ACHIEVE_STATE.CLEAR then
		query("get_reward_substory_achievement", {
			contents_id = arg_22_1.contents_id
		})
	end
end

function SubstoryAchievePopup.showHint(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_1 = arg_23_1 or SceneManager:getDefaultLayer()
	
	local var_23_0 = Dialog:open("wnd/dungeon_story_achieve_hint", arg_23_0)
	
	arg_23_1:addChild(var_23_0)
	
	local var_23_1 = UIUtil:getRewardIcon(nil, arg_23_2, {
		no_popup = true,
		scale = 1,
		no_grade = true,
		parent = var_23_0:getChildByName("mob_icon")
	})
	
	if_set(var_23_0, "hint_text", T(arg_23_3))
	if_set_arrow(var_23_0)
end

function SubstoryAchievePopup.updateItem(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0
	local var_24_1
	
	if arg_24_2.state == SUBSTORY_ACHIEVE_STATE.ACTIVE and arg_24_2.hidden then
		var_24_0 = T("sub_ach_hidden_name")
	end
	
	if arg_24_2.state == SUBSTORY_ACHIEVE_STATE.ACTIVE and arg_24_2.hidden then
		var_24_1 = T("sub_ach_hidden_desc")
	end
	
	if_set(arg_24_1, "txt_title", var_24_0 or T(arg_24_2.name))
	
	if DEBUG.DEBUG_MAP_ID then
		if_set(arg_24_1, "txt_name", arg_24_2.id)
	else
		if_set(arg_24_1, "txt_name", var_24_1 or T(arg_24_2.desc))
	end
	
	local var_24_2 = arg_24_1:getChildByName("txt_name")
	
	if var_24_2 then
		UIUserData:call(var_24_2, "MULTI_SCALE(2, 60)")
	end
	
	if_set_visible(arg_24_1, "btn_detail", false)
	if_set_visible(arg_24_1, "txt_time", false)
	if_set_visible(arg_24_1, "time_icon", false)
	
	if arg_24_2.state == SUBSTORY_ACHIEVE_STATE.ACTIVE and arg_24_2.hint_icon then
		if_set_sprite(arg_24_1, "img_face", "img/cm_icon_etcunknown.png")
	else
		if_set_sprite(arg_24_1, "img_face", "face/" .. arg_24_2.icon .. "_s.png")
	end
	
	local var_24_3 = arg_24_1:getChildByName("btn_go")
	
	var_24_3.move = arg_24_2.btn_move
	
	local var_24_4 = SubstoryManager:getAchievements():getScore(arg_24_2.id)
	local var_24_5 = tonumber(totable(arg_24_2.value).count)
	
	var_24_3.state = arg_24_2.state
	var_24_3.contents_id = arg_24_2.id
	var_24_3.enter_stage = arg_24_2.enter_stage
	var_24_3.enter_story = arg_24_2.enter_story
	var_24_3.hidden = arg_24_2.hidden
	var_24_3.hint_icon = arg_24_2.hint_icon
	var_24_3.hint_desc = arg_24_2.hint_desc
	
	if_set_percent(arg_24_1, "progress", var_24_4 / var_24_5)
	
	local var_24_6 = comma_value(math.min(var_24_4, var_24_5))
	local var_24_7 = comma_value(var_24_5)
	
	if_set(arg_24_1, "txt_progress", var_24_6 .. " / " .. var_24_7)
	
	local var_24_8 = {
		is_achieve = true,
		battle = arg_24_2.enter_stage,
		hidden = arg_24_2.hidden
	}
	
	if arg_24_2.enter_stage or arg_24_2.enter_story then
		var_24_8.active_text = T("sub_ach_level_btn")
	elseif arg_24_2.hidden then
		var_24_8.active_text = T("sub_ach_hint_btn")
	end
	
	UIUtil:setColorRewardButtonState(arg_24_2.state, arg_24_1, var_24_3, var_24_8)
	if_set_visible(arg_24_1, "n_no_detail", false)
	
	if not arg_24_2.btn_move and (arg_24_2.state == 0 or arg_24_2.state == "active") then
		if arg_24_2.hidden and arg_24_2.hint_icon and arg_24_2.hint_desc or arg_24_2.enter_stage or arg_24_2.enter_story then
			if_set_visible(arg_24_1, "btn_go", true)
			if_set_visible(arg_24_1, "n_no_detail", false)
		else
			if_set_visible(arg_24_1, "btn_go", false)
			if_set_visible(arg_24_1, "n_no_detail", true)
		end
	end
	
	local var_24_9 = tonumber(arg_24_2.state) >= tonumber(SUBSTORY_ACHIEVE_STATE.REWARDED)
	local var_24_10 = 255
	local var_24_11 = arg_24_1:getChildByName("n_reward")
	
	if arg_24_2.reward_id1 then
		if arg_24_2.state == SUBSTORY_ACHIEVE_STATE.ACTIVE and arg_24_2.hidden then
			UIUtil:getRewardIcon(nil, "ma_unknown", {
				icon_scale = 1,
				no_tooltip = true,
				parent = var_24_11
			})
		else
			local var_24_12 = {
				icon_scale = 1,
				grade_max = true,
				parent = var_24_11,
				set_drop = arg_24_2.set_drop_rate_id1,
				grade_rate = arg_24_2.grade_rate1
			}
			
			UIUtil:getRewardIcon(tonumber(arg_24_2.reward_count1) or 1, arg_24_2.reward_id1, var_24_12)
		end
	end
	
	if var_24_9 then
		local var_24_13 = arg_24_1:getChildByName("n_normal")
		
		if_set_opacity(var_24_13, nil, 76.5)
		if_set_opacity(arg_24_1, "bg", 76.5)
		if_set_opacity(arg_24_1, "img_face", 76.5)
		if_set_opacity(arg_24_1, "cm_hero_cirfrm1", 76.5)
	end
end

SubstoryQuestLinkAchieve = {}

copy_functions(SubstoryAchievePopup, SubstoryQuestLinkAchieve)

function SubstoryQuestLinkAchieve.updateState(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars or not arg_25_0.vars.data then
		return 
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.data or {}) do
		if iter_25_1.id == arg_25_1 then
			iter_25_1.state = arg_25_2
			
			break
		end
	end
end

function SubstoryQuestLinkAchieve.show(arg_26_0, arg_26_1, arg_26_2)
	if SubstoryManager:checkEndEvent() == true then
		balloon_message_with_sound("substory_wait_msg")
		
		return 
	end
	
	if not arg_26_2 then
		return 
	end
	
	ConditionContentsManager:dispatch("subachieve.clear")
	
	local var_26_0, var_26_1, var_26_2, var_26_3, var_26_4 = DB("substory_quest", arg_26_2, {
		"reward_id1",
		"reward_count1",
		"state_id",
		"grade_rate1",
		"set_drop_rate_id1"
	})
	
	arg_26_0.vars = {}
	arg_26_1 = arg_26_1 or SceneManager:getDefaultLayer()
	arg_26_0.vars.wnd = Dialog:open("wnd/dungeon_story_achieve_pre", arg_26_0)
	
	arg_26_1:addChild(arg_26_0.vars.wnd)
	
	local var_26_5 = arg_26_0.vars.wnd:getChildByName("listview")
	
	arg_26_0.vars.listView = ItemListView_v2:bindControl(var_26_5)
	
	local var_26_6 = SubstoryManager:getInfo().id
	local var_26_7 = {
		parent = arg_26_0.vars.wnd:getChildByName("n_item"),
		set_drop = var_26_4,
		grade_rate = var_26_3
	}
	local var_26_8 = UIUtil:getRewardIcon(var_26_1, var_26_0, var_26_7)
	
	arg_26_0.vars.data = {}
	
	local var_26_9 = ConditionContentsState:getClearData(var_26_2) or {}
	
	for iter_26_0, iter_26_1 in pairs(var_26_9.contents_ids or {}) do
		local var_26_10 = iter_26_1
		local var_26_11 = var_0_0(var_26_10)
		
		if not var_26_11.id then
			break
		end
		
		var_26_11.state = (Account:getSubStoryAchievement(var_26_10) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE
		
		if not var_26_11.hide then
			table.insert(arg_26_0.vars.data, var_26_11)
		end
	end
	
	arg_26_0:sort()
	
	local var_26_12 = load_control("wnd/dungeon_story_achieve_item_pre.csb")
	
	if var_26_5.STRETCH_INFO then
		local var_26_13 = var_26_5:getContentSize()
		
		resetControlPosAndSize(var_26_12, var_26_13.width, var_26_5.STRETCH_INFO.width_prev)
	end
	
	local var_26_14 = {
		onUpdate = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			SubstoryAchievePopup:updateItem(arg_27_1, arg_27_3)
			
			return arg_27_3.id
		end
	}
	
	arg_26_0.vars.listView:setRenderer(var_26_12, var_26_14)
	arg_26_0.vars.listView:removeAllChildren()
	arg_26_0.vars.listView:setDataSource(arg_26_0.vars.data)
	arg_26_0:updateUI()
end

function SubstoryQuestLinkAchieve.updateUI(arg_28_0)
	local var_28_0 = #(arg_28_0.vars.data or {})
	local var_28_1 = SubstoryManager:getInfo().condition_state_id
	local var_28_2 = SubstoryManager:getInfo().ac_reward_id
	local var_28_3 = SubstoryManager:getInfo().ac_reward_count
	local var_28_4 = ConditionContentsState:getClearData(var_28_1) or {}
	
	if_set(arg_28_0.vars.wnd, "txt_progress", T("ui_dungeon_archieve_progress"))
	
	local var_28_5 = cc.c3b(100, 186, 37)
	local var_28_6 = cc.c3b(255, 255, 255)
	local var_28_7 = 255
	
	if var_28_4.is_cleared then
		var_28_6 = var_28_5
	else
		local var_28_8 = 76.5
	end
	
	if_set_color(arg_28_0.vars.wnd, "txt_progress_count", var_28_6)
	
	local var_28_9 = SubstoryManager:getInfo().id
	local var_28_10 = Account:getSubStory(var_28_9)
end
