DungeonList = DungeonList or {}
DUNGEON_ALIAS_LIST = {
	Crevice = "crehunt"
}

table_prevent_nil(DUNGEON_ALIAS_LIST)
copy_functions(ScrollView, DungeonList)

function HANDLER.dungeon(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	UIUtil:checkBtnTouchPos(arg_1_0, arg_1_3, arg_1_4)
	
	if arg_1_1 == "btn_top_back" then
		DungeonList:onPushBack()
		
		return 
	end
	
	if (arg_1_1 == "btn_trial_hall_1" or arg_1_1 == "btn_trial_hall_2" or arg_1_1 == "btn_trial_hall_3" or arg_1_1 == "btn_trial_hall_4") and DungeonList.vars.mode == "Trial_Hall" then
		DungeonList:enterDungeon({
			target_id = arg_1_0.target_id
		})
		
		return 
	end
	
	if arg_1_1 == "btn_trial_back" and DungeonList.vars.mode == "Trial_Hall" then
		DungeonList:onPushBack()
		
		return 
	end
	
	if arg_1_1 == "btn_expedition" then
		CoopMission.DoEnter()
		
		return 
	end
	
	if arg_1_1 == "checkbox_g" then
		return 
	end
	
	if arg_1_1 == "btn_clean" then
		DungeonHell:reqCleanHell()
		
		return 
	end
	
	if string.starts(arg_1_1, "btn_go") or arg_1_1 == "btn_hell" or arg_1_1 == "btn_pvp" or arg_1_1 == "btn_automaton" then
		if DungeonList.vars.mode == "Hell" or DungeonList.vars.mode == "Automaton" or DungeonList.vars.mode == "Weekly" or DungeonList.vars.mode == "Trial_Hall" then
			local var_1_0 = {
				mode = DungeonList.vars.mode,
				info = DungeonList.vars.info,
				stage = tonumber(string.sub(arg_1_1, -1, -1))
			}
			
			if var_1_0.mode == "Automaton" then
				DungeonList:onEndStoryCallback(var_1_0)
			end
			
			return 
		elseif DungeonList.vars.mode == "PvP" then
			UnlockSystem:isUnlockSystemAndMsg({
				exclude_story = true,
				dungeon_id = DungeonList:getCurrentDungeonId()
			}, function()
				query("pvp_sa_lobby")
			end)
			
			return 
		end
	end
	
	if arg_1_1 == "btn_exchange_private" then
		DungeonList:openExchangeEquipShop()
		
		return 
	end
	
	if arg_1_1 == "btn_story" and DungeonList.vars.mode == "Trial_Hall" then
		play_story("trial_start", {
			force = true
		})
		
		return 
	end
	
	if arg_1_1 == "btn_change_difficulty" and DungeonList.vars.mode == "Automaton" then
		if ContentDisable:byAlias(string.lower("automaton")) then
			balloon_message_with_sound("msg_contents_disable_automaton")
			
			return 
		end
		
		if AutomatonUtil:isAllFloorClear() then
			balloon_message_with_sound("automtn_level_reset_clear")
			
			return 
		end
		
		AutomatonLevelPopup:show()
		
		return 
	end
	
	if arg_1_1 == "btn_formation" and DungeonList.vars.mode == "Automaton" then
		if not UnitMain:isValid() then
			UnitMain:beginAutomatonMode(nil, DungeonAutomaton:getParentWnd(), function()
			end)
		end
		
		return 
	end
	
	if arg_1_1 == "btn_reward_train" and DungeonList.vars.mode == "Trial_Hall" then
		DungeonTrialHall_RewardPopup:open()
		
		return 
	end
	
	if arg_1_1 == "btn_rank" and DungeonList.vars.mode == "Trial_Hall" then
		DungeonTrialHall_RankPopup:openRankPopup()
		
		return 
	end
	
	if arg_1_1 == "btn_season_info" and DungeonList.vars.mode == "Automaton" then
		AutomatonSeasonInfoPopup:show()
		
		return 
	end
	
	if arg_1_1 == "btn_go_shop" then
		query("market", {
			caller = "dungeon"
		})
		
		return 
	end
	
	if (arg_1_1 == "btn_normal" or arg_1_1 == "btn_hard") and DungeonList.vars.mode == "Crevice" then
		local var_1_1 = Account:getCrehuntSeasonScheduleInfo()
		
		if ContentDisable:byAlias("crehunt") or table.empty(var_1_1) then
			balloon_message_with_sound("content_disable")
			
			return 
		end
		
		local var_1_2, var_1_3 = BackPlayUtil:checkEnterCrehuntLobbyOnBackPlaying()
		
		if not var_1_2 and var_1_3 then
			balloon_message_with_sound(var_1_3)
			
			return 
		end
		
		local var_1_4 = string.find(arg_1_1, "hard") ~= nil
		
		DungeonList:enterDungeon({
			is_hard_mode = var_1_4
		})
		
		return 
	end
	
	if arg_1_1 == "btn_enter" then
		TutorialGuide:procGuide()
		CoopMission.DoEnter()
		
		return 
	end
	
	balloon_message_with_sound("notyet_con")
end

function DungeonList.onEndStoryCallback(arg_4_0, arg_4_1)
	if arg_4_1 then
		arg_4_0:enterDungeon(arg_4_1)
	end
end

function DungeonList.isIncludeModeFilter(arg_5_0, arg_5_1)
	local var_5_0 = {
		"Hell_Challenge"
	}
	
	return table.find(var_5_0, arg_5_1)
end

function DungeonList.updateDungeonList(arg_6_0, arg_6_1)
	arg_6_0.vars.List = {}
	
	for iter_6_0 = 1, 99 do
		local var_6_0, var_6_1, var_6_2, var_6_3, var_6_4, var_6_5, var_6_6, var_6_7, var_6_8, var_6_9, var_6_10, var_6_11, var_6_12, var_6_13 = DBN("level_battlemenu", iter_6_0, {
			"id",
			"name",
			"type",
			"icon",
			"mode",
			"desc_list",
			"desc_content",
			"reward_type1",
			"reward_code1",
			"reward_type2",
			"reward_code2",
			"enter_limit",
			"system_ach_id",
			"sort"
		})
		
		if not var_6_0 then
			break
		end
		
		if not arg_6_0:isIncludeModeFilter(var_6_4) then
			local var_6_14 = false
			
			if not ContentDisable:byAlias(string.lower(DUNGEON_ALIAS_LIST[var_6_4])) then
				if Account:isSysAchieveCleared(var_6_12) then
					var_6_14 = true
				end
				
				if not var_6_12 then
					var_6_14 = true
				end
				
				if var_6_4 == "Crevice" and table.empty(Account:getCrehuntSeasonScheduleInfo()) then
					var_6_14 = false
				end
			end
			
			if var_6_1 == nil then
				break
			end
			
			local var_6_15
			
			if var_6_4 == "Weekly" then
				var_6_15 = EVENT_BOOSTER_SUB_TYPE.RUNE_EVENT
			end
			
			if var_6_4 == "Hunt" then
				var_6_15 = EVENT_BOOSTER_SUB_TYPE.HUNT_EVENT
			end
			
			if var_6_4 == "Crevice" then
				var_6_15 = EVENT_BOOSTER_SUB_TYPE.CREHUNT_EVENT
			end
			
			local var_6_16 = {
				show_counter = false,
				id = var_6_0,
				sort = var_6_13,
				unlock_condition = var_6_12,
				mode = var_6_4,
				icon = var_6_3,
				title = T(var_6_1),
				desc = T(var_6_6),
				info = T(var_6_5),
				reward_type1 = var_6_7,
				reward_code1 = var_6_8,
				reward_type2 = var_6_9,
				reward_code2 = var_6_10,
				enter_limit = var_6_11,
				unlock = var_6_14,
				booster_sub_event_type = var_6_15
			}
			
			if DEBUG.DEBUG_NO_ENTER_LIMIT then
				var_6_16.enter_limit = nil
			end
			
			table.push(arg_6_0.vars.List, var_6_16)
			
			if not arg_6_1 and not arg_6_0.vars.info then
				arg_6_0.vars.info = var_6_16
			elseif arg_6_1 and arg_6_1.mode == var_6_4 then
				arg_6_0.vars.info = var_6_16
			end
		end
	end
	
	table.sort(arg_6_0.vars.List, function(arg_7_0, arg_7_1)
		if arg_7_0.sort == arg_7_1.sort then
			return arg_7_0.id < arg_7_1.id
		end
		
		return to_n(arg_7_0.sort) < to_n(arg_7_1.sort)
	end)
	arg_6_0:createScrollViewItems(arg_6_0.vars.List)
end

function DungeonList.set_balloonBox(arg_8_0)
	local var_8_0 = arg_8_0.ScrollViewItems[3].control:getChildByName("icon"):getWorldPosition()
	local var_8_1 = math.ceil(var_8_0.x)
	local var_8_2 = math.ceil(var_8_0.y)
	
	if not arg_8_0.vars.tempIcon or not get_cocos_refid(arg_8_0.vars.tempIcon) then
		arg_8_0.vars.tempIcon = load_dlg("mail_bar", nil, "wnd")
		
		arg_8_0.vars.wnd:addChild(arg_8_0.vars.tempIcon)
		arg_8_0.vars.tempIcon:setLocalZOrder(99999)
	end
	
	arg_8_0.vars.tempIcon:setPositionX(var_8_1 - 300)
	arg_8_0.vars.tempIcon:setPositionY(var_8_2)
end

function DungeonList.show(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or {}
	arg_9_2.mode = arg_9_2.mode or "Weekly"
	
	local var_9_0 = load_dlg("dungeon", true, "wnd")
	
	arg_9_1:addChild(var_9_0)
	
	arg_9_0.vars = {}
	
	local var_9_1 = TopBarNew:create(T("quick_launch_btn_battle"), var_9_0, function()
		DungeonList:onPushBack()
	end, nil, nil, "infodung")
	
	arg_9_0.vars.top_bar_cocos_uid = get_cocos_refid(var_9_1)
	arg_9_0.vars.dungeon_list = {
		Maze = DungeonMaze,
		Hell = DungeonHell,
		Clan = DungeonClan,
		Raid = DungeonRaid,
		Weekly = DungeonWeekly,
		Trial_Hall = DungeonTrialHall,
		Hunt = DungeonHunt,
		Crevice = DungeonCrevice,
		PvP = DungeonPvP,
		Automaton = DungeonAutomaton,
		Expedition = DungeonExpedition
	}
	arg_9_0.vars.scrollview = var_9_0:getChildByName("scrollview")
	arg_9_0.vars.menu = var_9_0:getChildByName("RIGHT")
	arg_9_0.vars.left = var_9_0:getChildByName("LEFT")
	arg_9_0.vars.center = var_9_0:getChildByName("CENTER")
	arg_9_0.vars.sub_wnd = arg_9_0.vars.menu:getChildByName("n_sub")
	arg_9_0.vars.center_sub_wnd = arg_9_0.vars.center:getChildByName("n_sub")
	
	if get_cocos_refid(arg_9_0.vars.menu) then
		UIUtil:addNoise(arg_9_0.vars.menu)
	end
	
	arg_9_0:initScrollView(arg_9_0.vars.scrollview, 320, 94, {
		fit_height = true
	})
	
	arg_9_0.vars.wnd = var_9_0
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.sub_wnd:getChildren()) do
		if string.starts(iter_9_1:getName(), "sub_") then
			iter_9_1:setVisible(false)
		end
	end
	
	for iter_9_2, iter_9_3 in pairs(arg_9_0.vars.center_sub_wnd:getChildren()) do
		if string.starts(iter_9_3:getName(), "sub_") then
			iter_9_3:setVisible(false)
		end
	end
	
	local var_9_2 = 1.7777777777777777
	local var_9_3 = DEVICE_WIDTH / DEVICE_HEIGHT
	
	if var_9_2 < var_9_3 then
		if arg_9_2.mode ~= "Trial_Hall" and arg_9_2.mode ~= "Crevice" and arg_9_2.mode ~= "Expedition" then
			scale = 2 * var_9_3
			
			local var_9_4 = -300 * var_9_3
			
			arg_9_0.vars.menu:getChildByName("Image_1"):setPositionX(var_9_4)
			arg_9_0.vars.menu:getChildByName("Image_1"):setScaleX(scale)
		else
			arg_9_0.vars.menu:getChildByName("Image_1"):setPositionX(-380)
			arg_9_0.vars.menu:getChildByName("Image_1"):setScaleX(2)
		end
	end
	
	arg_9_0:updateDungeonList(arg_9_2)
	arg_9_0:updateNotification()
	arg_9_0:setMode(arg_9_2.mode, false, arg_9_2)
	
	if arg_9_2.enter then
		arg_9_0.vars.menu:setVisible(false)
		arg_9_0.vars.left:setVisible(false)
		arg_9_0:enterDungeon(arg_9_2)
	end
	
	arg_9_0:update()
	Scheduler:addSlow(arg_9_0.vars.wnd, arg_9_0.onUpdateRemainTime, arg_9_0)
	
	if not UnlockSystem:isUnlockDungeonSystem(arg_9_0:getCurrentDungeonId()) and mode ~= "Trial_Hall" then
		if_set_visible(arg_9_0.vars.sub_wnd, "sub_" .. arg_9_0.vars.mode, false)
	end
	
	for iter_9_4, iter_9_5 in pairs(arg_9_0.ScrollViewItems) do
		if get_cocos_refid(iter_9_5.control) and (iter_9_5.item or {}).is_unlock_eff then
			iter_9_5.control:removeChildByName("_img_lock")
		end
	end
	
	SoundEngine:play("event:/ui/main_hud/btn_battle")
	SceneManager:resetSceneFlow()
	
	if not TutorialGuide:isPlayingTutorial() and arg_9_2.req_open_exclusive_shop and arg_9_2.mode == "Trial_Hall" then
		arg_9_0:openExchangeEquipShop()
	end
end

function DungeonList.openExchangeEquipShop(arg_11_0)
	if not AccountData.shop_exclusive or not AccountData.shop_trialhall then
		query("get_exclusive_shop_items", {
			caller = "dungeon_list"
		})
	else
		ShopExclusiveEquip:show()
	end
end

function DungeonList.setVisibleBackground(arg_12_0, arg_12_1)
	if_set_visible(arg_12_0.vars.wnd, "n_bg", arg_12_1)
end

function DungeonList.getBattleModeControl(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.ScrollViewItems) do
		if iter_13_1.item.mode == arg_13_1 then
			return iter_13_1.control
		end
	end
end

function DungeonList.onPushBack(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if arg_14_0.vars.enter then
		if arg_14_0.vars.mode == "Crevice" then
			if DungeonCreviceMain.rune:isOpenPopup() then
				DungeonCreviceMain.rune:closePopup()
				
				return 
			elseif DungeonCreviceMain.exploit:isOpenPopup() then
				DungeonCreviceMain.exploit:closePopup()
				
				return 
			end
		end
		
		local var_14_0 = arg_14_0.vars.dungeon_list[arg_14_0.vars.mode]
		
		if var_14_0 and var_14_0.onLeave then
			if not get_cocos_refid(arg_14_0.vars.bg) then
				return 
			end
			
			var_14_0:onLeave(arg_14_0)
			TopBarNew:checkhelpbuttonID("infodung")
			UIAction:Add(SEQ(SHOW(true)), arg_14_0.vars.bg, "block")
			UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(300, NotchStatus:getNotchBaseRight()))), arg_14_0.vars.menu, "block")
			UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(300, NotchStatus:getNotchBaseLeft()))), arg_14_0.vars.left, "block")
		end
		
		arg_14_0.vars.enter = nil
		arg_14_0.vars.enter_info = nil
		arg_14_0.vars.updater = nil
		
		local var_14_1 = {}
		
		arg_14_0:setMode(arg_14_0.vars.mode, true, var_14_1)
	elseif ShopExclusiveEquip:isShow() then
		ShopExclusiveEquip:close()
		
		return 
	else
		local var_14_2 = SceneManager:getNextFlowSceneName()
		
		if var_14_2 and (var_14_2 == "world_sub" or var_14_2 == "world_custom") then
			SceneManager:nextScene("lobby")
		else
			SceneManager:popScene()
		end
	end
	
	BackButtonManager:pop("DungeonList")
end

function DungeonList.update(arg_15_0)
end

function DungeonList.getCurDungeonObj(arg_16_0)
	if arg_16_0.vars.dungeon_list then
		return arg_16_0.vars.dungeon_list[arg_16_0.vars.mode]
	end
end

function DungeonList.getMenuWnd(arg_17_0)
	return arg_17_0.vars.menu
end

function DungeonList.getLeftWnd(arg_18_0)
	return arg_18_0.vars.left
end

function DungeonList.getScrollViewItem(arg_19_0, arg_19_1)
	local var_19_0 = cc.CSLoader:createNode("wnd/dungeon_bar.csb")
	
	var_19_0.guide_tag = arg_19_1.mode
	
	var_19_0:getChildByName("bg"):setOpacity(0)
	
	var_19_0.info = arg_19_1
	
	local var_19_1 = arg_19_0.vars.dungeon_list["Dungeon" .. arg_19_1.mode]
	
	if_set(var_19_0, "title", arg_19_1.title)
	if_set(var_19_0, "desc", arg_19_1.info)
	if_set_sprite(var_19_0, "icon", "img/" .. arg_19_1.icon .. ".png")
	if_set_visible(var_19_0, "n_locked", not arg_19_1.unlock)
	if_set_opacity(var_19_0, "title", arg_19_1.unlock and 255 or 76)
	if_set_opacity(var_19_0, "icon", arg_19_1.unlock and 255 or 76)
	if_set_visible(var_19_0, "bar_n_cnt", arg_19_1.enter_limit ~= nil)
	arg_19_0:updateLimitInfo(arg_19_1.mode, var_19_0, arg_19_1.enter_limit)
	
	if arg_19_1.booster_sub_event_type then
		local var_19_2 = Booster:isActiveBoosterSubType(arg_19_1.booster_sub_event_type)
		
		if_set_visible(var_19_0, "icon_event", var_19_2)
	end
	
	if arg_19_1.mode == "Maze" then
		if_set_visible(var_19_0, "icon_new", DungeonMaze:isNew())
	end
	
	return var_19_0
end

function DungeonList.visibleOffIconNew(arg_20_0, arg_20_1)
	if not arg_20_0.ScrollViewItems then
		return 
	end
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.ScrollViewItems) do
		if get_cocos_refid(iter_20_1.control) then
			print(iter_20_1.item.mode)
			
			if iter_20_1.item.mode == arg_20_1 then
				if_set_visible(iter_20_1.control, "icon_new", false)
			end
		end
	end
end

function DungeonList.getModeInfo(arg_21_0, arg_21_1)
	arg_21_1 = arg_21_1 or arg_21_0.vars.mode
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.List) do
		if iter_21_1.mode == arg_21_1 then
			return iter_21_1
		end
	end
end

function DungeonList.getCurrentDungeonId(arg_22_0)
	return DungeonList.vars.info.id
end

function DungeonList.onSelectScrollViewItem(arg_23_0, arg_23_1, arg_23_2)
	set_high_fps_tick(6000)
	
	if UIAction:Find("block") then
		return 
	end
	
	if TutorialGuide:checkBlockDungeonList(arg_23_2) then
		return 
	end
	
	SoundEngine:play("event:/ui/category/select")
	
	local var_23_0 = arg_23_2.item.mode
	
	if ContentDisable:byAlias(string.lower(DUNGEON_ALIAS_LIST[var_23_0])) then
		if var_23_0 == "Trial_Hall" then
			balloon_message_with_sound("msg_contents_disable_trial_hall")
		elseif var_23_0 == "Automaton" then
			balloon_message_with_sound("msg_contents_disable_automaton")
		else
			balloon_message_with_sound("content_disable")
		end
		
		return 
	end
	
	if var_23_0 and var_23_0 == "Crevice" and table.empty(Account:getCrehuntSeasonScheduleInfo()) then
		balloon_message_with_sound("content_disable")
		
		return 
	end
	
	if arg_23_2.item.unlock then
		arg_23_0.vars.info = arg_23_2.item
		
		arg_23_0.vars.sub_wnd:setVisible(true)
		arg_23_0:setMode(var_23_0)
	else
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			dungeon_id = arg_23_2.item.id
		}, function()
			arg_23_0.vars.info = arg_23_2.item
			
			arg_23_0:setMode(var_23_0)
		end)
	end
end

function DungeonList.updateNotification(arg_25_0)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.ScrollViewItems) do
		local var_25_0 = arg_25_0.vars.dungeon_list[iter_25_1.item.mode]
		
		if var_25_0 and var_25_0.CheckNotification then
			if_set_visible(iter_25_1.control, "cm_icon_noti", var_25_0:CheckNotification())
		else
			if_set_visible(iter_25_1.control, "cm_icon_noti", false)
		end
	end
end

function DungeonList.enterAction(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if get_cocos_refid(arg_26_1) then
		arg_26_1:setVisible(true)
		
		if arg_26_2 then
			if arg_26_3.no_action then
				arg_26_1:setPositionX(0)
				arg_26_1:setOpacity(255)
			else
				arg_26_1:setPositionX(200)
				arg_26_1:setOpacity(0)
				UIAction:Add(SPAWN(SHOW(true), FADE_IN(200), LOG(MOVE_BY(200, -200))), arg_26_1, "block")
			end
		end
	end
end

function DungeonList.leaveAction(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	if get_cocos_refid(arg_27_1) then
		if arg_27_3.item.mode == arg_27_2 and arg_27_1:isVisible() then
			UIAction:Add(SPAWN(RLOG(MOVE_BY(200, 200)), SEQ(FADE_OUT(200), SHOW(false))), arg_27_1, "block")
		else
			arg_27_1:setVisible(false)
		end
	end
end

function DungeonList.setMode(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	arg_28_3 = arg_28_3 or {}
	
	local var_28_0 = arg_28_0.vars.mode
	
	if arg_28_0.vars.mode == arg_28_1 and not arg_28_2 then
		return 
	end
	
	set_high_fps_tick()
	arg_28_0:playDungeonModeSound(arg_28_0.vars.mode, arg_28_1)
	
	if arg_28_0.vars.mode == "Trial_Hall" and arg_28_0.vars.enter then
		arg_28_0:onPushBack()
	end
	
	local var_28_1
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.ScrollViewItems) do
		local var_28_2 = arg_28_0.vars.menu:getChildByName("sub_" .. iter_28_1.item.mode)
		local var_28_3 = arg_28_0.vars.center:getChildByName("sub_" .. iter_28_1.item.mode)
		
		if iter_28_1.item.mode == arg_28_1 then
			iter_28_1.control:getChildByName("bg"):setOpacity(255)
			iter_28_1.control:getChildByName("n_cnt"):setOpacity(255)
			
			var_28_1 = iter_28_1.item
			
			arg_28_0:enterAction(var_28_2, var_28_0, arg_28_3)
			arg_28_0:enterAction(var_28_3, var_28_0, arg_28_3)
			arg_28_0:jumpToIndex(iter_28_0)
		else
			iter_28_1.control:getChildByName("bg"):setOpacity(0)
			iter_28_1.control:getChildByName("n_cnt"):setOpacity(60)
			arg_28_0:leaveAction(var_28_2, var_28_0, iter_28_1, arg_28_3)
			arg_28_0:leaveAction(var_28_3, var_28_0, iter_28_1, arg_28_3)
		end
	end
	
	if_set(arg_28_0.vars.wnd, "txt_title", var_28_1.title)
	if_set(arg_28_0.vars.wnd, "txt_desc", "")
	arg_28_0:updateLimitInfo(arg_28_1, arg_28_0.vars.wnd:getChildByName("n_title"), var_28_1.enter_limit)
	
	local var_28_4 = arg_28_1 == "Maze"
	local var_28_5 = arg_28_1 == "Automaton"
	local var_28_6 = arg_28_1 == "Trial_Hall"
	local var_28_7 = arg_28_1 == "Crevice"
	local var_28_8 = arg_28_1 == "Expedition"
	local var_28_9 = not var_28_5 and not var_28_6 and not var_28_7 and not var_28_8
	
	if_set_visible(arg_28_0.vars.left, "n_title", true)
	if_set_visible(arg_28_0.vars.left, "reward", var_28_9 and not var_28_4)
	if_set_visible(arg_28_0.vars.left, "reward_maze", var_28_4)
	if_set_visible(arg_28_0.vars.wnd, "btn_reward", false)
	
	if arg_28_1 ~= "Trial_Hall" then
		if_set_visible(arg_28_0.vars.left, "n_trial_info", false)
		if_set_visible(arg_28_0.vars.left, "btn_reward_train", false)
	end
	
	if arg_28_1 == "Weekly" then
		local var_28_10 = arg_28_0.vars.wnd:getChildByName("sub_weekly_info")
		
		if get_cocos_refid(var_28_10) then
			local var_28_11 = var_28_10:getChildByName("t_info")
			
			if get_cocos_refid(var_28_11) then
				local var_28_12 = var_28_11:getTextBoxSize().height
				
				if_set_position_y(var_28_11, "cm_icon_etcinfor", var_28_12 + 10)
			end
		end
	end
	
	if_set_visible(arg_28_0.vars.left, "n_crevice", arg_28_1 == "Crevice")
	
	if arg_28_1 ~= "Automaton" then
		if_set_visible(arg_28_0.vars.left, "n_change_difficulty", false)
	end
	
	if_set_visible(arg_28_0.vars.right, "sub_expedition", var_28_8)
	if_set_visible(arg_28_0.vars.left, "n_expedition", var_28_8)
	
	if var_28_8 then
		local var_28_13 = arg_28_0.vars.left:getChildByName("n_expedition")
		
		if_set(var_28_13, "txt_count", T("time_remain", {
			time = Account:getCoopMissionRemainTime()
		}))
	end
	
	if_set_visible(arg_28_0.vars.wnd, "n_weekly_info", arg_28_1 == "Weekly")
	UIAction:Remove("dungeon_list.text")
	
	if arg_28_1 ~= "Crevice" then
		UIAction:Add(SOUND_TEXT(var_28_1.desc, true, nil, nil, 60), arg_28_0.vars.wnd:getChildByName("txt_desc"), "dungeon_list.text")
	end
	
	if arg_28_0.vars.mode ~= arg_28_1 or arg_28_1 == "Hell" or arg_28_1 == "Automaton" or arg_28_1 == "Crevice" then
		if get_cocos_refid(arg_28_0.vars.bg) then
			arg_28_0.vars.bg:setLocalZOrder(-1)
			UIAction:Add(SEQ(SPAWN(RLOG(MOVE_TO(250, 2000)), FADE_OUT(250)), REMOVE()), arg_28_0.vars.bg, "block")
		end
		
		local var_28_14
		local var_28_15
		
		arg_28_0.vars.bg, var_28_15 = arg_28_0.vars.dungeon_list[arg_28_1]:create(arg_28_0.vars.wnd)
		
		if not var_28_15 then
			arg_28_0.vars.wnd:getChildByName("n_bg"):addChild(arg_28_0.vars.bg)
		end
		
		if var_28_9 then
			local var_28_16
			local var_28_17 = arg_28_1 == "Hell"
			
			if var_28_4 then
				var_28_16 = arg_28_0.vars.wnd:getChildByName("reward_maze")
			elseif var_28_17 then
				var_28_16 = arg_28_0.vars.wnd:getChildByName("cleanning")
			else
				var_28_16 = arg_28_0.vars.wnd:getChildByName("reward")
			end
			
			if not get_cocos_refid(var_28_16) then
				var_28_16 = arg_28_0.vars.wnd
			end
			
			local var_28_18 = var_28_17 and "n_all_clear_reward" or "n_reward"
			
			for iter_28_2 = 1, 2 do
				if var_28_1["reward_code" .. iter_28_2] then
					local var_28_19 = var_28_16:getChildByName(var_28_18 .. iter_28_2)
					
					var_28_19:removeAllChildren()
					UIUtil:getRewardIcon(var_28_1["reward_type" .. iter_28_2] or 1, var_28_1["reward_code" .. iter_28_2], {
						no_count = true,
						parent = var_28_19,
						scale = var_28_17 and 0.8
					})
				else
					arg_28_0.vars.wnd:getChildByName(var_28_18 .. iter_28_2):removeAllChildren()
				end
			end
			
			if not var_28_17 then
				local var_28_20 = arg_28_0.vars.wnd:getChildByName(var_28_18 .. "1")
				
				if var_28_1.reward_code2 then
					var_28_20:setPositionX(0)
				else
					var_28_20:setPositionX(50)
				end
			end
		end
		
		if arg_28_1 == "Crevice" then
			local var_28_21 = arg_28_0.vars.left:getChildByName("n_crevice")
			
			if get_cocos_refid(var_28_21) then
				local var_28_22 = var_28_21:getChildByName("n_reward")
				
				if get_cocos_refid(var_28_22) then
					var_28_22:removeAllChildren()
					
					local var_28_23 = string.split(var_28_1.reward_code1, ";")
					
					if not table.empty(var_28_23) then
						local var_28_24 = UIUtil:getRewardIcon(var_28_23[1], var_28_23[2], {
							parent = var_28_22,
							grade_rate = var_28_23[3],
							set_fx = var_28_23[4]
						})
						
						if get_cocos_refid(var_28_24) then
							var_28_24:setAnchorPoint(0, 0)
						end
					end
				end
			end
		end
		
		if var_28_8 then
			local var_28_25 = arg_28_0.vars.left:getChildByName("n_expedition")
			
			if get_cocos_refid(var_28_25) then
				local var_28_26 = var_28_25:getChildByName("n_reward")
				
				if get_cocos_refid(var_28_26) then
					var_28_26:removeAllChildren()
					
					local var_28_27 = UIUtil:getRewardIcon(1, var_28_1.reward_code1, {
						no_count = true,
						parent = var_28_26
					})
					
					if get_cocos_refid(var_28_27) then
						var_28_27:setAnchorPoint(0, 0)
					end
				end
			end
		end
		
		local var_28_28 = 1.7777777777777777
		local var_28_29 = DEVICE_WIDTH / DEVICE_HEIGHT
		
		if arg_28_0.vars.mode then
			arg_28_0.vars.bg:setPositionX(-2000)
			arg_28_0.vars.bg:setOpacity(0)
			arg_28_0.vars.bg:setScale(1)
			
			if var_28_28 < var_28_29 then
				if arg_28_1 ~= "Trial_Hall" and arg_28_1 ~= "Crevice" and arg_28_1 ~= "Expedition" then
					scale = 2 * var_28_29
					x = -300 * var_28_29
					
					arg_28_0.vars.menu:getChildByName("Image_1"):setPositionX(x)
					arg_28_0.vars.menu:getChildByName("Image_1"):setScaleX(scale)
				else
					arg_28_0.vars.menu:getChildByName("Image_1"):setPositionX(-380)
					arg_28_0.vars.menu:getChildByName("Image_1"):setScaleX(2)
				end
			end
			
			if var_28_28 < var_28_29 then
				if arg_28_1 == "Automaton" or arg_28_1 == "Hell" then
					UIAction:Add(SPAWN(SPAWN(LOG(MOVE_TO(250, VIEW_BASE_LEFT)), FADE_IN(250))), arg_28_0.vars.bg, "block")
				else
					UIAction:Add(SPAWN(SPAWN(LOG(MOVE_TO(250, 0)), FADE_IN(250))), arg_28_0.vars.bg, "block")
				end
			else
				UIAction:Add(SPAWN(SPAWN(LOG(MOVE_TO(250, VIEW_BASE_LEFT)), FADE_IN(250))), arg_28_0.vars.bg, "block")
			end
		elseif var_28_28 < var_28_29 then
			if arg_28_1 == "Automaton" or arg_28_1 == "Hell" then
				arg_28_0.vars.bg:setPositionX(VIEW_BASE_LEFT)
			else
				arg_28_0.vars.bg:setPositionX(0)
			end
		else
			arg_28_0.vars.bg:setPositionX(VIEW_BASE_LEFT)
		end
		
		if_set_visible(arg_28_0.vars.wnd, "n_sorry", false)
	end
	
	arg_28_0:updateNotification()
	
	arg_28_0.vars.mode = arg_28_1
	
	if arg_28_1 == "PvP" then
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"pvpgold",
			"pvpkey"
		}
	elseif arg_28_1 == "Maze" then
		if DungeonMazeMain:isRaidMazePresents() then
			arg_28_0.vars.currencies = {
				"crystal",
				"gold",
				"mazekey",
				"mazekey2"
			}
		else
			arg_28_0.vars.currencies = {
				"crystal",
				"gold",
				"mazekey"
			}
		end
	elseif arg_28_1 == "Hell" then
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"abysskey",
			"stigma"
		}
	elseif arg_28_1 == "Weekly" then
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"stamina"
		}
	elseif arg_28_1 == "Trial_Hall" then
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"exclusive"
		}
	elseif arg_28_1 == "Automaton" then
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"stamina",
			"stigma"
		}
	elseif arg_28_1 == "Hunt" then
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"stamina"
		}
	else
		arg_28_0.vars.currencies = {
			"crystal",
			"gold",
			"stamina"
		}
	end
	
	TopBarNew:setCurrencies(arg_28_0.vars.currencies)
	if_set_visible(arg_28_0.vars.left, "btn_exchange_private", var_28_6)
	if_set_visible(arg_28_0.vars.left, "btn_story", var_28_6)
	DungeonHell:updateCleaningInfo(arg_28_1 == "Hell")
	
	if arg_28_1 and arg_28_1 ~= "Trial_Hall" then
		ShopExclusiveEquip:close()
	end
	
	local function var_28_30(arg_29_0, arg_29_1)
		if TutorialGuide:isClearedTutorial(arg_29_0) then
			return 
		end
		
		if not arg_29_1 then
			return 
		end
		
		TutorialGuide:forceClearTutorials({
			arg_29_0
		})
	end
	
	if arg_28_0.vars.mode == "Weekly" then
		if Account:isMapsCleared({
			"mon001",
			"tue001",
			"wed001",
			"thu001",
			"fri001"
		}) then
			var_28_30("system_002", false)
		else
			TutorialGuide:startGuide("system_002")
		end
	elseif arg_28_0.vars.mode == "Maze" then
		TutorialGuide:ifStartGuide("system_097")
		
		if TutorialGuide:isClearedTutorial("maze_base") then
			var_28_30("system_003", false)
		else
			TutorialGuide:startGuide("system_003")
		end
	elseif arg_28_0.vars.mode == "Hunt" then
		if Account:isMapsCleared({
			"hunw001",
			"hung001",
			"hunb001",
			"hunq001"
		}) then
			var_28_30("system_007", false)
		else
			TutorialGuide:startGuide("system_007")
		end
	elseif arg_28_0.vars.mode == "Hell" then
		if Account:getHellFloor() ~= 1 then
			var_28_30("system_017", false)
		else
			TutorialGuide:startGuide("system_017")
		end
	elseif arg_28_0.vars.mode == "Automaton" then
		TutorialGuide:ifStartGuide("system_100")
	elseif arg_28_0.vars.mode == "Trial_Hall" then
		TutorialGuide:ifStartGuide("system_118_new")
	elseif arg_28_0.vars.mode == "Expedition" and UnlockSystem:isUnlockSystem(UNLOCK_ID.EXPDEITION) and not TutorialGuide:isClearedTutorial("expedition_unlock") then
		TutorialGuide:startGuide("expedition_start")
	end
	
	if arg_28_0.vars.mode == "Hell" then
		UIAction:Add(SEQ(DELAY(500), CALL(function()
			GrowthGuideNavigator:proc()
		end)), arg_28_0.vars.wnd, "block")
	end
	
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		TutorialNotice:update("DungeonList")
	end)), "delay")
end

function DungeonList.getMode(arg_32_0)
	if not arg_32_0.vars then
		return ""
	end
	
	return arg_32_0.vars.mode
end

function DungeonList.getCurrentCurrencies(arg_33_0)
	return arg_33_0.vars.currencies
end

function DungeonList.getEnterLimitInfo(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0:getModeInfo(arg_34_1)
	
	if var_34_0.enter_limit then
		arg_34_2 = var_34_0.enter_limit
	end
	
	if arg_34_2 then
		local var_34_1 = DB("level_enter_limit", arg_34_2, "limit_count")
		
		return var_34_1 - Account:getLimitCount(arg_34_2), var_34_1
	end
	
	return nil
end

function DungeonList.updateLimitInfo(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0, var_35_1 = arg_35_0:getEnterLimitInfo(arg_35_1, arg_35_3)
	
	if_set_visible(arg_35_2, "n_cnt", var_35_0 ~= nil)
	
	if var_35_0 then
		if_set(arg_35_2:getChildByName("n_cnt"), "txt_cnt", tostring(var_35_0) .. "/" .. var_35_1)
	end
	
	local var_35_2 = arg_35_2:getChildByName("bg_cnt")
	
	if var_35_2 then
		if var_35_0 == 0 then
			var_35_2:setColor(cc.c3b(0, 0, 0))
			var_35_2:setOpacity(140)
		else
			var_35_2:setColor(cc.c3b(255, 120, 0))
			var_35_2:setOpacity(255)
		end
	end
end

function DungeonList.enterDungeon(arg_36_0, arg_36_1)
	if arg_36_0.vars.enter then
		return 
	end
	
	if ContentDisable:byAlias(string.lower(DUNGEON_ALIAS_LIST[arg_36_0.vars.mode])) and arg_36_0.vars.mode ~= "Automaton" then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.dungeon_list[arg_36_0.vars.mode]
	
	local function var_36_1()
		TopBarNew:checkhelpbuttonID(arg_36_0.vars.mode)
		var_36_0:onEnter(arg_36_0.vars.wnd, arg_36_1, arg_36_0.vars.info)
		
		if not arg_36_1.no_action and (arg_36_1.enter_info == nil or not arg_36_1.enter_info.no_action) then
			UIAction:Add(SEQ(RLOG(MOVE_BY(300, 800 - NotchStatus:getNotchSafeRight())), SHOW(false)), arg_36_0.vars.menu, "block")
			UIAction:Add(SEQ(RLOG(MOVE_BY(300, -600 - NotchStatus:getNotchSafeLeft())), SHOW(false)), arg_36_0.vars.left, "block")
		end
		
		arg_36_0.vars.enter = true
		arg_36_0.vars.updater = var_36_0.onAfterUpdate
		
		if not arg_36_1.enter or arg_36_1.mode ~= "Automaton" then
			TutorialGuide:procGuide()
		end
		
		BackButtonManager:push({
			check_id = "infodung",
			back_func = function()
				arg_36_0:onPushBack()
			end
		})
	end
	
	if var_36_0 and var_36_0.onEnter then
		if arg_36_0.vars.mode == "Automaton" then
			if ContentDisable:byAlias(string.lower(DUNGEON_ALIAS_LIST[arg_36_0.vars.mode])) then
				balloon_message_with_sound("msg_contents_disable_automaton")
				
				return 
			end
			
			local var_36_2 = not Account:isUserSelectAutomatonLevel()
			local var_36_3 = DungeonAutomaton:getAutomatonSelectLevel()
			
			if var_36_2 then
				if var_36_3 <= AutomatonUtil:getMaxSelectableLevel() then
					Dialog:msgBox(T("automtn_select_level_pop_desc"), {
						yesno = true,
						handler = function()
							Account:setAutomatonLevel(var_36_3)
							query("set_automaton_level", {
								level = var_36_3
							})
							var_36_1()
						end,
						title = T("automtn_select_level_pop_title", {
							level = var_36_3
						})
					})
				else
					local var_36_4 = AutomatonUtil:getLockedLevelText(var_36_3)
					
					balloon_message_with_sound(var_36_4)
				end
			elseif not var_36_2 then
				var_36_1()
			else
				Log.e("Err: unSelect automaton Level")
			end
		else
			var_36_1()
		end
	end
end

function DungeonList.onTouchDown(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
end

function DungeonList.onTouchMove(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
end

function DungeonList.onTouchUp(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
end

function DungeonList.onAfterUpdate(arg_43_0)
	if arg_43_0.vars.updater then
		arg_43_0.vars.updater(arg_43_0.vars.dungeon_list[arg_43_0.vars.mode])
	end
	
	BattleReady:update()
	
	if arg_43_0.vars and arg_43_0.vars.mode == "Trial_Hall" then
		DungeonTrialHall:onAfterUpdate()
	end
end

function DungeonList.getSceneState(arg_44_0)
	local var_44_0 = {}
	local var_44_1 = arg_44_0.vars.dungeon_list[arg_44_0.vars.mode]
	
	if var_44_1 and var_44_1.getSceneState then
		var_44_0 = var_44_1:getSceneState() or {}
	end
	
	var_44_0.mode = arg_44_0.vars.mode
	var_44_0.enter = arg_44_0.vars.enter
	var_44_0.enter_info = arg_44_0.vars.enter_info
	
	return var_44_0
end

function DungeonList.setEventListener(arg_45_0, arg_45_1)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) or not arg_45_0.vars.dungeon_list then
		return 
	end
	
	local var_45_0 = {
		"Weekly",
		"Maze",
		"Hell",
		"Automaton",
		"Hunt"
	}
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		local var_45_1 = arg_45_0.vars.dungeon_list[iter_45_1]
		
		if var_45_1 and var_45_1.vars and var_45_1.vars.listener and get_cocos_refid(var_45_1.vars.listener) and var_45_1.vars.listener.setEnabled then
			var_45_1.vars.listener:setEnabled(arg_45_1)
		end
	end
end

function DungeonList.onUpdateRemainTime(arg_46_0)
	local var_46_0 = arg_46_0.vars.dungeon_list[arg_46_0.vars.mode]
	
	if var_46_0 and var_46_0.onUpdateRemainTime then
		var_46_0:onUpdateRemainTime(arg_46_0.vars.enter)
	end
end

function DungeonList.playDungeonModeSound(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_2 then
		return 
	end
	
	local var_47_0 = string.lower(arg_47_2)
	
	SoundEngine:playAmbient("event:/effect/dungeon_" .. string.lower(var_47_0) .. "_loop")
	
	if var_47_0 == "crevice" then
		SoundEngine:playBGM("event:/bgm/bgm_crehunt_lobby")
	else
		SoundEngine:playBGM("event:/bgm/default")
	end
end

function DungeonList.CheckNotification(arg_48_0)
	return DungeonMaze:CheckNotification() or DungeonHell:CheckNotification() or DungeonAutomaton:CheckNotification() or DungeonTrialHall:CheckNotification() or DungeonCrevice:CheckNotification() or DungeonExpedition:CheckNotification()
end

function DungeonList.onGameEvent(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0.vars.dungeon_list
	
	for iter_49_0, iter_49_1 in pairs(var_49_0) do
		if iter_49_1.onGameEvent then
			iter_49_1:onGameEvent(arg_49_1, arg_49_2)
		end
	end
end

function DungeonList.getWndControl(arg_50_0, arg_50_1)
	return (arg_50_0.vars.wnd:getChildByName(arg_50_1))
end

function DungeonList.getTopBarCocosUid(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.wnd) then
		return nil
	end
	
	return arg_51_0.vars.top_bar_cocos_uid
end
