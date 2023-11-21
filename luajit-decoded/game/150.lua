DungeonHome = {}

local var_0_0 = true

function MsgHandler.get_exclusive_shop_item_noti(arg_1_0)
	Account:setExclusiveShopNoti(arg_1_0.set_noti or false)
	DungeonHome:setTrailExclusiveNoti()
	DungeonTrialHall:updateNewItemIcon()
end

function HANDLER_BEFORE.dungeon_home_item(arg_2_0, arg_2_1)
	DungeonHome:setTouchFlag(LAST_UI_TICK)
end

function HANDLER_CANCEL.dungeon_home_item(arg_3_0, arg_3_1)
	DungeonHome:setTouchFlag(-1)
end

function HANDLER.dungeon_home_item(arg_4_0, arg_4_1)
	if not DungeonHome:getTouchFlag() then
		return 
	end
	
	DungeonHome:setTouchFlag(false)
	
	if arg_4_1 == "btn_select" then
		local var_4_0 = getParentWindow(arg_4_0)
		
		if var_4_0.handler then
			var_4_0.handler()
			DungeonHome:savePageIdx()
		end
	end
end

function HANDLER.dungeon_home(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_back" then
		DungeonHome.vars.page_view:scrollToPercentHorizontal(0, 1.5, true)
	elseif arg_5_1 == "btn_next" then
		DungeonHome.vars.page_view:scrollToPercentHorizontal(100, 1.5, true)
	end
end

function DungeonHome.setTouchFlag(arg_6_0, arg_6_1)
	arg_6_0.vars.touch_flag = arg_6_1
end

function DungeonHome.getTouchFlag(arg_7_0)
	return arg_7_0.vars.touch_flag
end

function DungeonHome.touchCancel()
	DungeonHome:setTouchFlag(false)
end

function DungeonHome.show(arg_9_0, arg_9_1)
	local var_9_0 = Account:checkQueryEmptyDungeonData("dungeon_home.show")
	
	if not arg_9_1 and var_9_0 then
		return 
	end
	
	if arg_9_0:isVisible() then
		return 
	end
	
	arg_9_0.vars = {}
	arg_9_0.vars.wnd = load_dlg("dungeon_home", true, "wnd")
	
	local var_9_1 = SceneManager:getRunningPopupScene()
	local var_9_2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_9_2:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_9_2:setPosition(VIEW_BASE_LEFT, 0)
	var_9_2:setVisible(true)
	
	arg_9_0.vars.black_color_layer = var_9_2
	
	NotchManager:addListener(var_9_2, false, function(arg_10_0, arg_10_1, arg_10_2)
		arg_10_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		arg_10_0:setPosition(VIEW_BASE_LEFT, 0)
	end)
	var_9_1:addChild(var_9_2)
	var_9_1:addChild(arg_9_0.vars.wnd)
	arg_9_0:make()
	arg_9_0.vars.wnd:setOpacity(0)
	
	local var_9_3 = {
		arg_9_0.vars.wnd
	}
	
	table.add(var_9_3, ArenaNetNotifier:getPool() or {})
	UIAction:Add(SEQ(LOG(FADE_IN(300)), CALL(function()
		arg_9_0.vars.pv_childs = UIUtil:hideChilds(var_9_1, var_9_3)
	end), DELAY(100), CALL(DungeonHome.playUnlockCategoryEffect, DungeonHome)), arg_9_0.vars.wnd, "block")
	
	local function var_9_4()
		arg_9_0:close()
		
		return TopBarNew.BACK_BUTTON_RESULT.BACK_BUTTON_MANAGER_NEED_POP
	end
	
	TopBarNew:createFromPopup(T("quick_launch_btn_battle"), arg_9_0.vars.wnd, var_9_4)
	TutorialGuide:procGuide()
	GrowthGuideNavigator:proc()
	UIAction:Add(SEQ(DELAY(400), CALL(function()
		TutorialNotice:update("dungeon_home")
	end)), "delay")
	TopBarNew:checkhelpbuttonID("infodung")
	
	if Account:getExclusiveShopNoti() == nil then
		query("get_exclusive_shop_item_noti")
	end
	
	DungeonList:setEventListener(false)
end

function DungeonHome.playCategoryEffect(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0, var_14_1 = arg_14_2:getPosition()
	local var_14_2 = arg_14_2:getContentSize()
	local var_14_3 = 34
	local var_14_4 = "ui_battle_normal_unlock_new"
	
	EffectManager:Play({
		z = 99998,
		fn = var_14_4 .. ".cfx",
		layer = arg_14_2:getParent(),
		x = var_14_0 + var_14_2.width / 2,
		y = var_14_1 + var_14_2.height / 2 + var_14_3
	})
	SAVE:setTempConfigData("unlock_eff." .. arg_14_1, true)
end

function DungeonHome.playUnlockCategoryEffect(arg_15_0)
	set_high_fps_tick(5000)
	
	local var_15_0 = 300
	local var_15_1 = 600
	local var_15_2 = ConditionContentsManager:getAchievement()
	local var_15_3 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.items) do
		local var_15_4 = iter_15_1.unlock_id
		
		if get_cocos_refid(iter_15_1) and not iter_15_1.contents_disabled and var_15_4 and Account:isSysAchieveCleared(var_15_4) and not Account:getConfigData("unlock_eff." .. var_15_4) then
			table.insert(var_15_3, {
				item = iter_15_1,
				unlock_id = var_15_4
			})
		end
	end
	
	local var_15_5
	
	for iter_15_2, iter_15_3 in pairs(var_15_3) do
		if var_15_5 == nil and iter_15_3.item and iter_15_3.item.page_cnt then
			var_15_5 = iter_15_3.item.page_cnt
		end
		
		UIAction:Add(SEQ(DELAY(var_15_0 + var_15_1 * (iter_15_2 - 1)), CALL(DungeonHome.playCategoryEffect, arg_15_0, iter_15_3.unlock_id, iter_15_3.item)), arg_15_0, "block")
	end
	
	if var_15_5 then
		arg_15_0.vars.page_view:scrollToPercentHorizontal((var_15_5 - 1) * 100, 0.5, true)
	end
	
	local var_15_6 = #var_15_3
	
	if var_15_6 > 0 then
		local var_15_7 = ccui.Button:create()
		
		var_15_7:setTouchEnabled(true)
		var_15_7:ignoreContentAdaptWithSize(false)
		var_15_7:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_15_7:setLocalZOrder(999999)
		var_15_7:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
		arg_15_0.vars.wnd:addChild(var_15_7)
		UIAction:Add(SEQ(DELAY(var_15_0 + var_15_1 * var_15_6), CALL(function()
			SAVE:sendQueryServerConfig()
		end), REMOVE()), var_15_7, "block")
	end
end

function DungeonHome.isVisible(arg_17_0)
	return arg_17_0.vars and get_cocos_refid(arg_17_0.vars.wnd)
end

function DungeonHome.savePageIdx(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.page_view) then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.page_view:getCurrentPageIndex()
	
	if var_18_0 == -1 then
		var_18_0 = 0
	end
	
	SAVE:set("dungeon_home.last_page_idx", var_18_0)
end

function DungeonHome.close(arg_19_0)
	TutorialNotice:detachByPoint("dungeon_home")
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_19_0.vars.wnd, "block")
	UIAction:Add(SEQ(LOG(DELAY(300)), REMOVE()), arg_19_0.vars.black_color_layer, "block")
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.items) do
		UIAction:Add(LOG(OPACITY(300, iter_19_1:getOpacity() / 255, 0)), iter_19_1, "block")
	end
	
	UIUtil:showChilds(arg_19_0.vars.pv_childs)
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("quick_launch_btn_battle"))
	arg_19_0:savePageIdx()
	DungeonList:setEventListener(true)
	
	if SceneManager:getCurrentSceneName() == "DungeonList" and DungeonList:getMode() == "Crevice" and DungeonCreviceMain:isOpen() then
		DungeonCreviceMain:addTickUpdateEvent()
	end
end

function DungeonHome.make(arg_20_0)
	arg_20_0.vars.page_view = arg_20_0.vars.wnd:getChildByName("scrollview")
	
	local var_20_0 = arg_20_0.vars.page_view:getContentSize()
	local var_20_1 = 0
	
	arg_20_0.vars.items = arg_20_0:getDungeonItems()
	
	local var_20_2 = 640
	local var_20_3 = 0
	local var_20_4 = 0
	
	arg_20_0:setupPages()
	arg_20_0:setupIcons()
	arg_20_0:setupSlideBar()
	arg_20_0:setTrailExclusiveNoti()
	
	if (SAVE:get("dungeon_home.last_page_idx") or 0) > 0 then
		arg_20_0.vars.page_view:jumpToRight()
	end
end

local var_0_1 = -10

local function var_0_2(arg_21_0, arg_21_1, arg_21_2)
	arg_21_2.origin_pos_x = arg_21_0
	
	arg_21_2:setPositionX(arg_21_0 + arg_21_1 * (arg_21_2:getContentSize().width + var_0_1))
	
	arg_21_2.in_layout_index = arg_21_1
	arg_21_2.guide_tag = arg_21_2.mode
end

local function var_0_3()
	return -VIEW_BASE_LEFT + 15
end

function DungeonHome.setupPages(arg_23_0)
	local var_23_0 = arg_23_0.vars.items
	local var_23_1 = var_0_3()
	
	local function var_23_2(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		var_0_2(arg_24_0, arg_24_1 - arg_24_2, arg_24_4)
		arg_24_3:addChild(arg_24_4)
		
		if arg_24_2 == 1 then
			arg_24_4.page_cnt = 1
		else
			arg_24_4.page_cnt = 2
		end
		
		arg_24_4:setOpacity(0)
		UIAction:Add(SEQ(FADE_IN(300)), arg_24_4, "block")
	end
	
	local var_23_3 = ccui.Layout:create()
	
	var_23_3:setContentSize({
		width = VIEW_WIDTH,
		height = VIEW_HEIGHT
	})
	
	for iter_23_0 = 1, 4 do
		local var_23_4 = var_23_0[iter_23_0]
		
		if not var_23_4 then
			break
		end
		
		var_23_2(var_23_1, iter_23_0, 1, var_23_3, var_23_4)
	end
	
	arg_23_0.vars.page_view:addChild(var_23_3)
	
	local var_23_5 = ccui.Layout:create()
	
	var_23_5:setContentSize({
		width = VIEW_WIDTH,
		height = VIEW_HEIGHT
	})
	
	for iter_23_1 = 5, 8 do
		local var_23_6 = var_23_0[iter_23_1]
		
		if not var_23_6 then
			break
		end
		
		var_23_2(var_23_1, iter_23_1, 5, var_23_5, var_23_6)
	end
	
	arg_23_0.vars.page_view:addChild(var_23_5)
	
	arg_23_0.vars.page_cnt = 2
	
	local var_23_7 = arg_23_0.vars.page_view:getInnerContainerSize()
	
	arg_23_0.vars.page_view.origin_width = VIEW_WIDTH + var_23_1 - var_0_1
	
	arg_23_0.vars.page_view:getInnerContainer():setContentSize({
		width = arg_23_0.vars.page_view.origin_width * arg_23_0.vars.page_cnt,
		height = var_23_7.height
	})
end

local function var_0_4()
	return not (not ContentDisable:byAlias(string.lower("crehunt")) and not table.empty(Account:getCrehuntSeasonScheduleInfo())) and "content_disable" or nil
end

function DungeonHome.setupIcons(arg_26_0)
	local var_26_0 = arg_26_0.vars.wnd:getChildByName("n_menu_icon")
	local var_26_1 = {
		"Weekly",
		"Hunt",
		"Crevice",
		"Expedition",
		"Maze",
		"Hell",
		"Trial_Hall",
		"Automaton"
	}
	local var_26_2 = {}
	local var_26_3 = {}
	local var_26_4 = {
		Weekly = UNLOCK_ID.WEEKLY,
		Hunt = UNLOCK_ID.HUNT,
		Crevice = UNLOCK_ID.CRE_HUNT,
		Expedition = UNLOCK_ID.EXPDEITION,
		Maze = UNLOCK_ID.MAZE,
		Hell = UNLOCK_ID.HELL,
		Trial_Hall = UNLOCK_ID.TRIAL_HALL,
		Automaton = UNLOCK_ID.AUTOMATON
	}
	local var_26_5 = {
		Trial_Hall = DungeonTrialHall:CheckNotification(),
		Automaton = DungeonAutomaton:CheckNotification(),
		Maze = DungeonMaze:CheckNotification(),
		Hell = DungeonHell:CheckNotification(),
		Crevice = DungeonCrevice:CheckNotification(),
		Expedition = DungeonExpedition:CheckNotification()
	}
	local var_26_6 = {
		Trial_Hall = ContentDisable:byAlias("trial_hall"),
		Automaton = ContentDisable:byAlias("automaton"),
		Expedition = ContentDisable:byAlias("expedition"),
		Crevice = var_0_4()
	}
	local var_26_7 = {
		Weekly = EVENT_BOOSTER_SUB_TYPE.RUNE_EVENT,
		Hunt = EVENT_BOOSTER_SUB_TYPE.HUNT_EVENT,
		Crevice = EVENT_BOOSTER_SUB_TYPE.CREHUNT_EVENT
	}
	
	for iter_26_0 = 1, 8 do
		local var_26_8 = var_26_0:getChildByName(tostring(iter_26_0))
		
		if not var_26_8 then
			print("what the heck?", iter_26_0)
		end
		
		local var_26_9, var_26_10 = var_26_8:getPosition()
		
		var_26_2[iter_26_0] = {
			x = var_26_9,
			y = var_26_10
		}
		var_26_8.mode = var_26_1[iter_26_0]
		
		table.insert(var_26_3, var_26_8)
		
		local var_26_11 = false
		
		if var_26_6[var_26_8.mode] ~= nil then
			var_26_11 = var_26_6[var_26_8.mode]
		end
		
		local var_26_12 = var_26_4[var_26_8.mode]
		
		if not UnlockSystem:isUnlockSystem(var_26_12) or var_26_11 then
			if_set_opacity(var_26_8, "icon_title", 127.5)
			if_set_visible(var_26_8, "img_locked", true)
		end
		
		if_set_visible(var_26_8, "noti", var_26_5[var_26_8.mode] or false)
		
		if var_26_7[var_26_8.mode] then
			local var_26_13 = Booster:isActiveBoosterSubType(var_26_7[var_26_8.mode])
			
			if_set_visible(var_26_8, "icon_event", var_26_13)
		end
	end
	
	arg_26_0:sortItemsByLevelBattleMenu(var_26_3)
	
	for iter_26_1 = 1, 8 do
		local var_26_14 = var_26_3[iter_26_1]
		
		if not var_26_14 then
			break
		end
		
		var_26_14:setPosition(var_26_2[iter_26_1].x, var_26_2[iter_26_1].y)
		var_26_14:setVisible(true)
		
		var_26_14.guide_tag = var_26_14.mode
	end
	
	arg_26_0.vars.icon_list = var_26_3
end

function DungeonHome.setupSlideBar(arg_27_0)
	local function var_27_0(arg_28_0, arg_28_1, arg_28_2)
		return arg_28_0 * (1 - arg_28_2) + arg_28_1 * arg_28_2
	end
	
	local var_27_1 = arg_27_0.vars.wnd:getChildByName("slide_bar")
	local var_27_2 = arg_27_0.vars.wnd:getChildByName("btn_next")
	local var_27_3 = arg_27_0.vars.wnd:getChildByName("btn_back")
	local var_27_4 = arg_27_0.vars.wnd:getChildByName("cursor1")
	local var_27_5 = arg_27_0.vars.wnd:getChildByName("cursor2")
	
	var_27_4:setVisible(true)
	var_27_5:setVisible(true)
	
	if not var_27_4._origin_y then
		var_27_4._origin_y = var_27_4:getPositionY()
		var_27_5._origin_y = var_27_5:getPositionY()
	end
	
	var_27_2:setVisible(true)
	var_27_3:setVisible(true)
	
	local function var_27_6(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
		if arg_29_2 <= arg_29_1 and arg_29_1 < arg_29_2 + arg_29_3 then
			arg_29_0:setOpacity(0)
		elseif arg_29_5 < arg_29_1 and arg_29_1 < arg_29_6 then
			local var_29_0 = 0
			
			if arg_29_1 - (arg_29_2 + arg_29_3) < 0 then
				var_29_0 = 1 - math.abs(arg_29_1 - arg_29_5) / arg_29_4
			else
				var_29_0 = (arg_29_1 - (arg_29_2 + arg_29_3)) / arg_29_4
			end
			
			arg_29_0:setOpacity(255 * var_29_0)
		else
			arg_29_0:setOpacity(255)
		end
	end
	
	Scheduler:add(arg_27_0.vars.page_view, function()
		if not get_cocos_refid(arg_27_0.vars.page_view) then
			return 
		end
		
		local var_30_0 = arg_27_0.vars.page_view:getInnerContainer():getPositionX()
		local var_30_1 = 414
		local var_30_2 = 226
		local var_30_3 = -var_30_0 / VIEW_WIDTH
		local var_30_4 = var_27_0(var_30_1, var_30_1 + var_30_2, -var_30_0 / VIEW_WIDTH)
		
		var_27_1:setPositionX(var_30_4)
		
		local var_30_5 = var_30_3 / 2
		local var_30_6 = 0.15
		local var_30_7 = false
		
		if var_30_3 < 0.008 or var_30_3 > 0.992 then
			var_30_7 = true
			var_30_6 = 0
			
			if var_30_3 < 0.01 then
				var_27_3:setVisible(false)
			else
				var_27_2:setVisible(false)
			end
		elseif var_30_3 < 0.08 or var_30_3 > 0.92 then
			var_27_3:setVisible(true)
			var_27_2:setVisible(true)
			
			var_30_6 = 0.05
			
			var_27_4:setPositionY(var_27_4._origin_y)
			var_27_5:setPositionY(var_27_5._origin_y)
			
			if var_30_3 < 0.08 then
				var_30_7 = true
			end
		else
			var_30_6 = not (not (var_30_3 < 0.1) and not (var_30_3 > 0.94)) and 0.1 or 0.15
		end
		
		if var_30_7 and not UIAction:Find("cursor_action") then
			local var_30_8 = var_27_4
			
			if var_30_3 > 0.5 then
				var_30_8 = var_27_5
			end
			
			if not var_30_8._origin_y then
				var_30_8._origin_y = var_30_8:getPositionY()
			end
			
			var_30_8:setPositionY(var_30_8._origin_y)
			UIAction:Add(LOOP(SEQ(MOVE_BY(300, 0, 6), MOVE_BY(300, 0, -6))), var_30_8, "cursor_action")
		elseif not var_30_7 and UIAction:Find("cursor_action") then
			UIAction:Remove("cursor_action")
		end
		
		local var_30_9 = 0.5
		local var_30_10 = var_30_5 - var_30_6
		local var_30_11 = var_30_5 + var_30_9 + var_30_6
		
		for iter_30_0 = 1, 8 do
			local var_30_12 = arg_27_0.vars.icon_list[iter_30_0]
			local var_30_13 = iter_30_0 * 0.12
			
			var_27_6(var_30_12, var_30_13, var_30_5, var_30_9, var_30_6, var_30_10, var_30_11)
		end
		
		var_27_6(var_27_3, 0.11, var_30_5, var_30_9, var_30_6, var_30_10, var_30_11)
		var_27_6(var_27_2, 0.97, var_30_5, var_30_9, var_30_6, var_30_10, var_30_11)
		var_27_6(var_27_4, 0.6, var_30_5, var_30_9, 0.07, var_30_10, var_30_11)
		var_27_6(var_27_5, 0.48, var_30_5, var_30_9, 0.07, var_30_10, var_30_11)
		
		if not UIAction:Find("block") then
			for iter_30_1 = 1, 8 do
				local var_30_14 = arg_27_0.vars.items[iter_30_1]
				
				if var_30_14 then
					local var_30_15
					local var_30_16 = iter_30_1 < 5 and 0.88 or 0.12
					local var_30_17 = var_30_14
					
					var_27_6(var_30_17, var_30_16, var_30_5, var_30_9, 0.2, var_30_10, var_30_11)
				end
			end
		end
	end)
end

function DungeonHome.updateOffsetDlg(arg_31_0)
	if not arg_31_0:isVisible() then
		return 
	end
	
	local var_31_0
	
	if arg_31_0.vars.items then
		var_31_0 = var_0_3()
		
		for iter_31_0, iter_31_1 in ipairs(arg_31_0.vars.items) do
			if get_cocos_refid(iter_31_1) then
				var_0_2(var_31_0, iter_31_1.in_layout_index, iter_31_1)
			end
		end
	end
	
	if get_cocos_refid(arg_31_0.vars.page_view) then
		local var_31_1 = arg_31_0.vars.page_view:getInnerContainerSize()
		
		arg_31_0.vars.page_view:setInnerContainerSize({
			width = arg_31_0.vars.page_view.origin_width * arg_31_0.vars.page_cnt or var_31_1.width,
			height = var_31_1.height
		})
	end
end

function DungeonHome.getDungeonItemControl(arg_32_0, arg_32_1)
	if not arg_32_0:isVisible() then
		return 
	end
	
	if arg_32_0.vars.items then
		for iter_32_0, iter_32_1 in ipairs(arg_32_0.vars.items) do
			if iter_32_1.mode == arg_32_1 then
				return iter_32_1
			end
		end
	end
end

function DungeonHome.sortItemsByLevelBattleMenu(arg_33_0, arg_33_1)
	local var_33_0 = {}
	
	for iter_33_0 = 1, 99 do
		local var_33_1, var_33_2, var_33_3 = DBN("level_battlemenu", iter_33_0, {
			"id",
			"mode",
			"sort"
		})
		
		if not var_33_1 or not var_33_2 then
			break
		end
		
		if not var_33_3 then
			Log.e("not exist sort. id : ", var_33_1, var_33_2)
			
			break
		end
		
		var_33_0[var_33_2] = var_33_3
	end
	
	table.sort(arg_33_1, function(arg_34_0, arg_34_1)
		return var_33_0[arg_34_0.mode] < var_33_0[arg_34_1.mode]
	end)
	
	return arg_33_1
end

function DungeonHome.getDungeonItems(arg_35_0)
	local var_35_0 = {}
	
	table.push(var_35_0, arg_35_0:getMazeItem())
	table.push(var_35_0, arg_35_0:getHellItem())
	table.push(var_35_0, arg_35_0:getWeeklyItem())
	table.push(var_35_0, arg_35_0:getHuntItem())
	table.push(var_35_0, arg_35_0:getAutomatonItem())
	table.push(var_35_0, arg_35_0:getTrialHallItem())
	table.push(var_35_0, arg_35_0:getCrehuntItem())
	table.push(var_35_0, arg_35_0:getExpeditionItem())
	
	return (arg_35_0:sortItemsByLevelBattleMenu(var_35_0))
end

function DungeonHome.setImageItem(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_1:getChildByName("n_title")
	local var_36_1 = arg_36_1:getChildByName("clip")
	local var_36_2 = arg_36_1:getChildByName("dim")
	local var_36_3 = arg_36_1:getChildByName("frame")
	local var_36_4 = arg_36_1:getChildByName("btn_select")
	local var_36_5 = arg_36_1:getChildByName("bg")
	local var_36_6 = arg_36_1:getChildByName("n_res")
	local var_36_7 = arg_36_1:getChildByName("n_locked")
	
	var_36_1:setContentSize({
		width = arg_36_2,
		height = arg_36_3
	})
	var_36_3:setContentSize({
		width = arg_36_2 + 30,
		height = arg_36_3 + 30
	})
	var_36_5:setContentSize({
		width = arg_36_2,
		height = arg_36_3
	})
	var_36_2:setContentSize({
		width = arg_36_2,
		height = arg_36_3
	})
	arg_36_1:setContentSize({
		width = arg_36_2 + 20,
		height = arg_36_3 + 70
	})
	var_36_4:setContentSize({
		width = arg_36_2 + 20,
		height = arg_36_3 + 70
	})
	var_36_0:setPositionY(arg_36_3)
	var_36_6:setPositionX(arg_36_2)
	var_36_7:setPositionX(arg_36_2)
end

function DungeonHome.getCommonItem(arg_37_0, arg_37_1)
	local var_37_0 = load_control("wnd/dungeon_home_item.csb")
	
	if arg_37_1.bg then
		if_set_sprite(var_37_0, "bg", arg_37_1.bg)
	end
	
	local var_37_1 = true
	
	if LOW_RESOLUTION_MODE then
		var_37_1 = false
	end
	
	local var_37_2 = false
	
	if arg_37_1.mode and arg_37_1.mode == "Weekly" and arg_37_1.dungeon_list then
		var_37_2 = true
		arg_37_1.face = false
		arg_37_1.name = nil
	end
	
	if arg_37_1.bg_effect and SAVE:getOptionData("option.fps60", var_37_1) and not var_37_2 and not var_0_0 then
		local var_37_3 = EffectManager:Play({
			fn = arg_37_1.bg_effect,
			layer = var_37_0:getChildByName("clip")
		})
		
		var_37_3:setScale(arg_37_1.bg_effect_scale or 0.75)
		var_37_3:setPosition(250, 280 + to_n(arg_37_1.bg_effect_y))
		if_set_visible(var_37_0, "bg", not arg_37_1.no_bg)
	end
	
	if false then
	end
	
	if arg_37_1.icon then
		if_set_sprite(var_37_0, "icon_title", arg_37_1.icon)
	end
	
	if arg_37_1.title then
		if_set(var_37_0, "txt_title", arg_37_1.title)
	end
	
	if arg_37_1.logo_title then
		if_set(var_37_0, "logo_title", T(arg_37_1.logo_title))
	end
	
	if arg_37_1.period then
		if_set(var_37_0, "txt_period", arg_37_1.period)
	end
	
	if arg_37_1.period_title then
		if_set(var_37_0, "txt_period_title", arg_37_1.period_title)
	end
	
	if arg_37_1.progress then
		if_set(var_37_0, "txt_progress", arg_37_1.progress)
	end
	
	if arg_37_1.name then
		if_set(var_37_0, "txt_name", arg_37_1.name)
	end
	
	if arg_37_1.emblem then
		if_set(var_37_0, "txt_etc", arg_37_1.emblem)
	end
	
	if arg_37_1.time_remain then
		if_set(var_37_0, "txt_remain", T("time_remain", {
			time = arg_37_1.time_remain
		}))
	end
	
	if_set_visible(var_37_0, "locale_logo_img", false)
	
	if arg_37_1.logo_img then
		local var_37_4 = var_37_0:getChildByName("locale_logo_img")
		local var_37_5 = cc.Sprite:create(arg_37_1.logo_img .. ".png")
		
		if get_cocos_refid(var_37_4) and get_cocos_refid(var_37_5) then
			var_37_4:getParent():addChild(var_37_5)
			var_37_5:setPosition(var_37_4:getPosition())
			var_37_5:setPositionX(var_37_5:getPositionX() + (arg_37_1.logo_offset_x or 0))
			var_37_5:setPositionY(var_37_5:getPositionY() + (arg_37_1.logo_offset_y or 0))
		end
	end
	
	if_set_visible(var_37_0, "emblem", arg_37_1.emblem ~= nil)
	if_set_visible(var_37_0, "n_face", (arg_37_1.face or arg_37_1.maze_icon) ~= nil)
	if_set_visible(var_37_0, "n_story_locked", arg_37_1.story_empty)
	
	if arg_37_1.floor then
		if_set(var_37_0, "txt_floor", arg_37_1.floor)
		if_set_visible(var_37_0, "n_info", false)
	end
	
	if arg_37_1.atm_floor then
		if_set(var_37_0, "txt_atm_floor", arg_37_1.atm_floor)
		if_set_visible(var_37_0, "n_info", false)
	end
	
	if_set_visible(var_37_0, "txt_name", arg_37_1.name ~= nil)
	if_set_visible(var_37_0, "n_hell", arg_37_1.floor ~= nil)
	if_set_visible(var_37_0, "n_automaton", arg_37_1.atm_floor ~= nil)
	if_set_visible(var_37_0, "n_story", arg_37_1.logo_title or arg_37_1.logo_img or arg_37_1.period or arg_37_1.period_title)
	if_set_visible(var_37_0, "noti", arg_37_1.noti)
	
	if arg_37_1.face or arg_37_1.maze_icon then
		var_37_0:getChildByName("n_info"):setPositionX(90)
		
		if arg_37_1.face then
			local var_37_6, var_37_7 = DB("character", arg_37_1.face, {
				"face_id",
				"ch_attribute"
			})
			
			if_set_sprite(var_37_0, "face", "face/" .. var_37_6 .. "_s.png")
			if_set_sprite(var_37_0, "color", "img/cm_icon_pro" .. var_37_7 .. ".png")
		elseif arg_37_1.maze_icon then
			if_set_sprite(var_37_0, "face", "img/" .. arg_37_1.maze_icon .. ".png")
			if_set_visible(var_37_0, "color", false)
		end
	end
	
	if arg_37_1.width then
		arg_37_0:setImageItem(var_37_0, arg_37_1.width, arg_37_1.height)
	end
	
	if arg_37_1.res1 then
		local var_37_8
		local var_37_9
		local var_37_10
		
		if arg_37_1.res_info1 then
			var_37_8 = arg_37_1.res_info1.type
			var_37_9 = arg_37_1.res_info1.set_drop
			var_37_10 = arg_37_1.res_info1.grade_rate
		end
		
		UIUtil:getRewardIcon(var_37_8, arg_37_1.res1, {
			no_frame = true,
			tooltip_delay = 300,
			hide_level = true,
			parent = var_37_0:getChildByName("n_res1"),
			tooltip_callback = arg_37_0.touchCancel,
			set_drop = var_37_9,
			grade_rate = var_37_10
		})
	end
	
	if arg_37_1.res2 then
		local var_37_11
		local var_37_12
		local var_37_13
		
		if arg_37_1.res_info2 then
			var_37_11 = arg_37_1.res_info2.type
			var_37_12 = arg_37_1.res_info2.set_drop
			var_37_13 = arg_37_1.res_info2.grade_rate
		end
		
		UIUtil:getRewardIcon(var_37_11, arg_37_1.res2, {
			no_frame = true,
			tooltip_delay = 300,
			hide_level = true,
			parent = var_37_0:getChildByName("n_res2"),
			tooltip_callback = arg_37_0.touchCancel,
			set_drop = var_37_12,
			grade_rate = var_37_13
		})
	end
	
	local var_37_14 = var_37_0:getChildByName("n_touch_block")
	
	if var_37_14 then
		if arg_37_1.res2 then
			var_37_14:setContentSize({
				width = 130,
				height = 70
			})
			if_set_visible(var_37_14, nil, true)
		elseif arg_37_1.res1 then
			var_37_14:setContentSize({
				width = 68,
				height = 70
			})
			if_set_visible(var_37_14, nil, true)
		else
			if_set_visible(var_37_14, nil, false)
		end
	end
	
	local var_37_15
	
	if arg_37_1.unlock_id then
		var_37_15 = not UnlockSystem:isUnlockSystem(arg_37_1.unlock_id)
	end
	
	if arg_37_1.unlock_id_challenge then
		if_set_visible(var_37_0, "n_locked_challenge", not UnlockSystem:isUnlockSystem(arg_37_1.unlock_id_challenge))
		if_set(var_37_0, "txt_floor_challenge", arg_37_1.floor_text_challenge)
		if_set_visible(var_37_0, "txt_floor_challenge", UnlockSystem:isUnlockSystem(arg_37_1.unlock_id_challenge))
		if_set_opacity(var_37_0, "txt_abyss_challenge", UnlockSystem:isUnlockSystem(arg_37_1.unlock_id_challenge) and 255 or 76.5)
	end
	
	if not var_37_15 and arg_37_1.contents_disabled then
		var_37_15 = true
	end
	
	if arg_37_1.booster_event_sub_type then
		local var_37_16, var_37_17 = Booster:isActiveBoosterSubType(arg_37_1.booster_event_sub_type)
		local var_37_18 = var_37_0:getChildByName("n_event")
		
		if_set_visible(var_37_18, nil, var_37_16)
		
		if var_37_16 then
			local var_37_19 = Booster:getEventBoosterValueDesc(var_37_17)
			
			if_set(var_37_18, "disc", var_37_19)
		end
	end
	
	if_set_visible(var_37_0, "n_contents", var_37_15 ~= true)
	if_set_visible(var_37_0, "n_locked", var_37_15 == true)
	
	local var_37_20 = arg_37_1.opacity
	
	if var_37_15 then
		var_37_0.c.btn_select.contents_disabled = arg_37_1.contents_disabled
		var_37_0.c.btn_select.category_unlock_id = arg_37_1.unlock_id
		var_37_20 = 127.5
	end
	
	if arg_37_1.mode == "Automaton" then
		var_37_0.c.btn_select.can_enterable = arg_37_1.can_enterable
	end
	
	local var_37_21 = var_37_0:getChildByName("n_base")
	
	if get_cocos_refid(var_37_21) and var_37_20 then
		var_37_21:setOpacity(var_37_20)
	end
	
	var_37_0.handler = arg_37_1.handler
	var_37_0.unlock_id = arg_37_1.unlock_id
	var_37_0.contents_disabled = arg_37_1.contents_disabled
	var_37_0.mode = arg_37_1.mode
	
	if var_37_2 then
		arg_37_0:_setWeeklyItemUI(var_37_0, arg_37_1.dungeon_list)
	end
	
	if arg_37_1.mode and arg_37_1.mode == "Automaton" and arg_37_1.unselect_level then
		if_set(var_37_0, "txt_automaton", T("automtn_select_level"))
	end
	
	return var_37_0
end

function DungeonHome._setWeeklyItemUI(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_2 or not arg_38_1 or not arg_38_2 then
		return 
	end
	
	local var_38_0 = {
		wed = "img/_dungeon_elementals_ice.png",
		tue = "img/_dungeon_elementals_fire.png",
		mon = "img/_dungeon_elementals_dark.png",
		all = "img/_dungeon_menu_elementals.png",
		fri = "img/_dungeon_elementals_light.png",
		thu = "img/_dungeon_elementals_wind.png"
	}
	local var_38_1 = ""
	local var_38_2 = {
		cmon = 1,
		cwed = 3,
		cfri = 5,
		ctue = 2,
		cthu = 4
	}
	
	table.sort(arg_38_2, function(arg_39_0, arg_39_1)
		return (var_38_2[arg_39_0.dungeon_id] or 0) < (var_38_2[arg_39_1.dungeon_id] or 0)
	end)
	
	local var_38_3 = ""
	
	for iter_38_0, iter_38_1 in pairs(arg_38_2) do
		if iter_38_1.dungeon_id then
			var_38_3 = string.sub(iter_38_1.dungeon_id, 2)
			
			local var_38_4 = ""
			
			if iter_38_0 < table.count(arg_38_2) then
				var_38_4 = "/"
			end
			
			var_38_1 = var_38_1 .. arg_38_0:getGenieItemName(iter_38_1.dungeon_id) .. var_38_4
		end
	end
	
	if table.count(arg_38_2) >= 5 then
		var_38_1 = arg_38_0:getGenieItemName(nil, {
			all = true
		})
	end
	
	if table.count(arg_38_2) > 1 then
		local var_38_5
		local var_38_6 = true
		
		if LOW_RESOLUTION_MODE then
			var_38_6 = false
		end
		
		if var_38_6 and var_0_0 then
			var_38_5 = EffectManager:Play({
				fn = "bettlemanu_genie.cfx",
				layer = arg_38_1:getChildByName("clip")
			})
		end
		
		if var_38_5 and SAVE:getOptionData("option.fps60", var_38_6) and var_0_0 then
			var_38_5:setScale(0.75)
			var_38_5:setPosition(250, 280)
			if_set_visible(arg_38_1, "bg", false)
		else
			if_set_sprite(arg_38_1, "bg", var_38_0.all)
		end
	elseif var_38_3 then
		if_set_sprite(arg_38_1, "bg", var_38_0[var_38_3])
	end
	
	if_set(arg_38_1, "txt_name", var_38_1)
end

function DungeonHome.getGenieItemName(arg_40_0, arg_40_1, arg_40_2)
	if (arg_40_2 or {}).all then
		return T("level_weekly_open_name_0")
	end
	
	if arg_40_1 == "cmon" then
		return T("level_weekly_open_name_1")
	elseif arg_40_1 == "ctue" then
		return T("level_weekly_open_name_2")
	elseif arg_40_1 == "cwed" then
		return T("level_weekly_open_name_3")
	elseif arg_40_1 == "cthu" then
		return T("level_weekly_open_name_4")
	elseif arg_40_1 == "cfri" then
		return T("level_weekly_open_name_5")
	end
	
	return ""
end

function DungeonHome.getWeeklyItem(arg_41_0)
	local var_41_0, var_41_1 = DungeonCommon:GetDungeonList("level_battlemenu_genie", os.time())
	
	if not var_41_0 or #var_41_0 == 0 then
		local var_41_2 = arg_41_0:getCommonItem({
			no_bg = true,
			mode = "Weekly",
			res1 = "ma_zd999",
			icon = "img/icon_menu_element.png",
			bg_effect = "ui_bg_faery.cfx",
			unlock_id = UNLOCK_ID.WEEKLY,
			title = T("level_battlemenu_name_genie"),
			etc = T("level_battlemenu_list_genie"),
			name = T("battlemenu_genie_idle_title"),
			booster_event_sub_type = EVENT_BOOSTER_SUB_TYPE.RUNE_EVENT,
			handler = function()
				SceneManager:cancelReseveResetSceneFlow()
				SceneManager:nextScene("DungeonList", {
					mode = "Weekly"
				})
			end
		})
		
		if_set(var_41_2, "txt_progress", T("battlemenu_genie_idle_desc"))
		
		return var_41_2
	end
	
	DungeonCommon:sort(var_41_0, var_41_1)
	
	quick_end_dungeon = var_41_0[1]
	
	local var_41_3 = arg_41_0:getCommonItem({
		no_bg = true,
		mode = "Weekly",
		res1 = "ma_zd999",
		icon = "img/icon_menu_element.png",
		bg_effect = "ui_bg_faery.cfx",
		unlock_id = UNLOCK_ID.WEEKLY,
		title = T("level_battlemenu_name_genie"),
		etc = T("level_battlemenu_list_genie"),
		dungeon_list = var_41_0,
		booster_event_sub_type = EVENT_BOOSTER_SUB_TYPE.RUNE_EVENT,
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Weekly"
			})
		end
	})
	
	DungeonCommon:UpdateRestTime(var_41_3, var_41_3:getChildByName("txt_progress"), quick_end_dungeon, os.time(), true)
	
	return var_41_3
end

function DungeonHome.getTrialHallItem(arg_44_0)
	local var_44_0, var_44_1 = DungeonTrialHall:getDB()
	
	if not var_44_1 then
		return 
	end
	
	local var_44_2 = Account:getActiveTrialHall() or {}
	local var_44_3 = UNLOCK_ID.TRIAL_HALL
	local var_44_4 = var_44_1.name
	local var_44_5 = sec_to_string((var_44_2.end_time or 0) - os.time())
	local var_44_6, var_44_7 = Account:isRestTimeTrialHall(var_44_2)
	
	if var_44_6 and var_44_7 and var_44_7 > 0 then
		var_44_4 = "trial_hall_rest_title"
		var_44_5 = sec_to_string(var_44_7)
	end
	
	local var_44_8 = ContentDisable:byAlias(string.lower("trial_hall")) and "msg_contents_disable_trial_hall" or nil
	local var_44_9 = arg_44_0:getCommonItem({
		mode = "Trial_Hall",
		bg_effect_x = 300,
		bg = "img/_dungeon_menu_trialhall.png",
		bg_effect_scale = 0.8,
		bg_effect_y = -50,
		res1 = "to_exclusive",
		icon = "img/icon_menu_trial_hall.png",
		bg_effect = "ui_new_training_bg.cfx",
		title = T("level_battlemenu_name_trial"),
		etc = T("level_battlemenu_list_trial"),
		unlock_id = var_44_3,
		noti = DungeonTrialHall:CheckNotification(),
		name = T(var_44_4),
		face = var_44_1.monster_id,
		contents_disabled = var_44_8,
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Trial_Hall"
			})
		end
	})
	
	if_set_visible(var_44_9, "emblem", false)
	if_set(var_44_9, "txt_progress", T("time_remain", {
		time = var_44_5
	}))
	
	local var_44_10 = 255
	
	if var_44_6 and var_44_7 and var_44_7 > 0 then
		var_44_10 = 76.5
	end
	
	if_set_opacity(var_44_9, "n_res", var_44_10)
	
	local var_44_11 = Account:getTrialHallRankInfo()
	
	if var_44_11 and not table.empty(var_44_11) then
		local var_44_12 = T("trial_hall_rank_none")
		
		if var_44_11.rank then
			if var_44_11.rank <= 100 then
				var_44_12 = T("trial_hall_rank_point_rank", {
					rank = var_44_11.rank
				})
			else
				local var_44_13 = round(var_44_11.rank_rate, 2)
				
				if var_44_13 * 10 > 0 then
					var_44_13 = math.ceil(var_44_11.rank_rate * 100) / 100
				end
				
				var_44_12 = T("trial_hall_rank_point_per", {
					per = math.max(var_44_13 * 100, 1)
				})
			end
		end
		
		if_set_visible(var_44_9, "n_ranking", true)
		if_set(var_44_9, "txt_my_rank", var_44_12)
		
		local var_44_14 = var_44_9:getChildByName("n_contents")
		
		if get_cocos_refid(var_44_14) then
			local var_44_15 = var_44_14:getChildByName("n_info")
			
			if get_cocos_refid(var_44_15) then
				local var_44_16 = var_44_15:getChildByName("txt_name")
				local var_44_17 = var_44_15:getChildByName("n_ranking")
				
				if get_cocos_refid(var_44_16) and get_cocos_refid(var_44_17) and var_44_16:getStringNumLines() > 1 then
					var_44_17:setPositionY(var_44_17:getPositionY() + (var_44_16:getStringNumLines() - 1) * 20)
				end
			end
		end
	end
	
	return var_44_9
end

function DungeonHome.getTrainItem(arg_46_0)
	local var_46_0, var_46_1 = DungeonCommon:GetDungeonList("level_battlemenu_train", os.time())
	
	if not var_46_0 or #var_46_0 == 0 then
		local var_46_2 = arg_46_0:getCommonItem({
			bg = "img/_dungeon_menu_train.png",
			no_bg = true,
			mode = "Train",
			res1 = "ma_sample_train",
			icon = "img/icon_menu_train.png",
			unlock_id = UNLOCK_ID.TRAIN,
			title = T("level_battlemenu_name_train"),
			etc = T("level_battlemenu_list_train"),
			name = T("battlemenu_train_idle_title"),
			handler = function()
				SceneManager:cancelReseveResetSceneFlow()
				SceneManager:nextScene("DungeonList", {
					mode = "Train"
				})
			end
		})
		
		if_set(var_46_2, "txt_progress", T("battlemenu_train_idle_desc"))
		
		return var_46_2
	end
	
	local var_46_3 = arg_46_0:getCommonItem({
		bg = "img/_dungeon_menu_train.png",
		no_bg = true,
		mode = "Train",
		res1 = "ma_sample_train",
		icon = "img/icon_menu_train.png",
		unlock_id = UNLOCK_ID.TRAIN,
		title = T("level_battlemenu_name_train"),
		etc = T("level_battlemenu_list_train"),
		name = T(var_46_0[1].name),
		face = var_46_0[1].monster_id,
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Train"
			})
		end
	})
	
	DungeonCommon:UpdateRestTime(var_46_3, var_46_3:getChildByName("txt_progress"), var_46_0[1], os.time(), true)
	
	return var_46_3
end

function DungeonHome.getMazeItem(arg_49_0)
	local var_49_0 = {}
	
	for iter_49_0 = 1, 99 do
		local var_49_1, var_49_2, var_49_3, var_49_4, var_49_5, var_49_6, var_49_7, var_49_8 = DB("level_battlemenu_dungeon", tostring(iter_49_0), {
			"name",
			"desc",
			"mission_id",
			"image",
			"effect",
			"key_enter",
			"icon_landmark",
			"event_banner"
		})
		
		if not var_49_1 then
			break
		end
		
		if UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			no_msgbox = true,
			dungeon_id = tostring(iter_49_0),
			maze_id = tostring(iter_49_0)
		}) then
			local var_49_9, var_49_10 = DungeonMaze:GetMazeList(var_49_6)
			
			if not var_49_0.name or var_49_10 > 0 or var_49_8 then
				var_49_0.name = var_49_1
				var_49_0.image = var_49_4
				var_49_0.score = var_49_10 / #var_49_9
				var_49_0.icon = var_49_7
				var_49_0.event_banner = var_49_8
				
				if Account:isJPN() then
					var_49_0.token1 = var_49_9[1].c_type == "raid" and "ma_dungeoncoin" or "to_dungeonkey"
				else
					var_49_0.token1 = var_49_9[1].c_type == "raid" and "ma_dungeoncoin" or "to_dungeonkey"
					var_49_0.token2 = var_49_9[1].c_type == "raid" and "ma_dungeoncoin2" or nil
				end
			end
		end
	end
	
	local var_49_11 = arg_49_0:getCommonItem({
		no_bg = true,
		bg = "img/_dungeon_menu_lavyrinth.png",
		mode = "Maze",
		icon = "img/icon_menu_layrinth.png",
		bg_effect = "ui_bg_maze.cfx",
		unlock_id = UNLOCK_ID.MAZE,
		maze_icon = var_49_0.icon,
		title = T("level_battlemenu_name_maze"),
		etc = T("level_battlemenu_list_maze"),
		name = T(var_49_0.name),
		progress = T("maze_rate_total", {
			rate = math.floor(var_49_0.score or 0)
		}),
		face_image = var_49_0.image,
		res1 = var_49_0.token1,
		res2 = var_49_0.token2,
		noti = DungeonMaze:CheckNotification(),
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Maze"
			})
		end
	})
	
	DungeonCommon:setEventBanner(var_49_11, var_49_0)
	
	if DungeonMaze:isNew() then
		local var_49_12 = var_49_11:getChildByName("n_event")
		
		if_set_visible(var_49_12, nil, true)
		if_set_sprite(var_49_12, "icon_event", "img/shop_icon_new.png")
		if_set_visible(var_49_12, "n_info", false)
	else
		if_set_visible(var_49_11, "n_event", false)
	end
	
	return var_49_11
end

function DungeonHome.getHuntItem(arg_51_0)
	local var_51_0, var_51_1 = DungeonCommon:GetDungeonList("level_battlemenu_hunt", os.time())
	
	if not var_51_0 or #var_51_0 == 0 then
		return nil
	end
	
	local var_51_2 = arg_51_0:getCommonItem({
		name = "",
		no_bg = true,
		bg = "img/_dungeon_menu_topaz.png",
		mode = "Hunt",
		icon = "img/icon_menu_topazdun.png",
		title = T("level_battlemenu_name_hunt"),
		etc = T("level_battlemenu_list_hunt"),
		unlock_id = UNLOCK_ID.HUNT,
		booster_event_sub_type = EVENT_BOOSTER_SUB_TYPE.HUNT_EVENT,
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Hunt"
			})
		end
	})
	local var_51_3 = 0
	
	for iter_51_0 = 1, 5 do
		if not var_51_0[iter_51_0] then
			break
		end
		
		var_51_3 = var_51_3 + 1
	end
	
	local var_51_4 = var_51_2
	
	if var_51_3 == 3 then
		if_set_visible(var_51_2, "n_ja", true)
		
		var_51_4 = var_51_2:getChildByName("n_ja")
		
		if_set_sprite(var_51_2, "bg", "img/ja/_dungeon_menu_topaz.png")
	end
	
	for iter_51_1 = 1, 5 do
		if not var_51_0[iter_51_1] then
			break
		end
		
		local var_51_5, var_51_6 = DB("level_battlemenu_hunt", tostring(iter_51_1), {
			"reward1",
			"enter_key"
		})
		
		if_set(var_51_2, "n_mname" .. iter_51_1, var_51_6 and T("txt_" .. var_51_6 .. "_name") or "")
		
		if var_51_5 then
			UIUtil:getRewardIcon(nil, var_51_5, {
				no_frame = true,
				tooltip_delay = 300,
				parent = var_51_4:getChildByName("n_item" .. iter_51_1),
				tooltip_callback = arg_51_0.touchCancel
			})
		end
	end
	
	if_set(var_51_2, "txt_progress", "")
	
	return var_51_2
end

function DungeonHome.getHellItem(arg_53_0)
	local var_53_0
	local var_53_1
	
	if Account:getHellFloor() > DungeonHell:getMaxFloor() then
		var_53_0 = T("ui_dungeon_subhell_label_txt_hell_floor2")
	else
		var_53_0 = T("hell_floor", {
			floor = DungeonHell:getNormalFloor()
		})
	end
	
	if Account:getHardHellFloor() >= DungeonHell:getMaxChallengeFloor() then
		var_53_1 = T("ui_dungeon_subhell_label_txt_hell_floor2")
	else
		var_53_1 = T("abyss_floor", {
			floor = Account:getHardHellFloor() + 1
		})
	end
	
	local var_53_2 = arg_53_0:getCommonItem({
		res2 = "to_gold",
		bg = "img/_dungeon_menu_deepabyss.png",
		mode = "Hell",
		bg_effect_y = 60,
		res1 = "to_stigma",
		icon = "img/icon_menu_deepabyss.png",
		bg_effect = "narak_eff_idle_front.cfx",
		title = T("level_battlemenu_name_abyss"),
		etc = T("level_battlemenu_list_abyss"),
		unlock_id = UNLOCK_ID.HELL,
		unlock_id_challenge = UNLOCK_ID.HELL_CHALLENGE,
		floor_text_challenge = var_53_1,
		floor = var_53_0,
		noti = DungeonHell:CheckNotification(),
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Hell"
			})
		end
	})
	
	if_set_visible(var_53_2, "emblem", false)
	
	return var_53_2
end

function DungeonHome.getAutomatonItem(arg_55_0)
	local var_55_0 = DungeonAutomaton:getResetTM()
	local var_55_1 = DungeonAutomaton:getCurrFloorReward()
	local var_55_2 = Account:getAutomatonFloor()
	local var_55_3
	local var_55_4 = (Account:getAutomatonLevel() or 0) == 0
	
	if Account:needToRequestAutomatonData() then
		var_55_1 = {}
		var_55_2 = 0
		
		local var_55_5 = 0
		
		var_55_4 = true
	end
	
	if var_55_2 > DungeonAutomaton:getMaxFloor() then
		var_55_3 = T("automtn_clear")
	elseif table.empty(var_55_1) and var_55_4 then
		var_55_3 = T("automtn_select_level_wait")
	else
		var_55_3 = T("atuomtn_floor", {
			floor = DungeonAutomaton:GetCurFloor()
		})
	end
	
	local var_55_6 = UNLOCK_ID.AUTOMATON
	local var_55_7 = ContentDisable:byAlias(string.lower("automaton")) and "msg_contents_disable_automaton" or nil
	local var_55_8 = arg_55_0:getCommonItem({
		bg_effect_scale = 0.45,
		mode = "Automaton",
		can_enterable = true,
		icon = "img/icon_menu_automaton.png",
		bg_effect = "ui_bg_automaton.cfx",
		bg = "img/_dungeon_menu_automaton.png",
		bg_effect_y = 50,
		title = T("level_battlemenu_name_automaton"),
		etc = T("various_rewards"),
		res1 = (var_55_1[1] or {}).code,
		res2 = (var_55_1[2] or {}).code,
		res_info1 = var_55_1[1],
		res_info2 = var_55_1[2],
		unlock_id = var_55_6,
		atm_floor = var_55_3,
		time_remain = sec_to_string(var_55_0 - os.time()),
		unselect_level = var_55_4,
		noti = DungeonAutomaton:CheckNotification(),
		contents_disabled = var_55_7,
		handler = function()
			SceneManager:nextScene("DungeonList", {
				mode = "Automaton"
			})
		end
	})
	
	if_set_visible(var_55_8, "emblem", false)
	
	return var_55_8
end

function DungeonHome.getPvPItem(arg_57_0)
	local var_57_0 = arg_57_0:getCommonItem({
		height = 270,
		width = 400,
		no_bg = true,
		bg = "img/_dungeon_menu_pvp.png",
		bg_effect_scale = 0.45,
		emblem = "img/icon_pvp_sa_league_challenger.png",
		mode = "PvP",
		icon = "img/icon_menu_battle.png",
		bg_effect = "ui_bg_battle.cfx",
		title = T("level_battlemenu_name_pvp"),
		etc = T("level_battlemenu_list_pvp"),
		unlock_id = UNLOCK_ID.PVP,
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "PvP"
			})
		end
	})
	
	DungeonPvP:UpdatePvPInfo(var_57_0, "emblem", "txt_name", "txt_progress", "-", "-")
	
	return var_57_0
end

function DungeonHome.getCrehuntItem(arg_59_0)
	local var_59_0 = var_0_4()
	local var_59_1 = arg_59_0:getCommonItem({
		no_bg = true,
		bg = "img/_dungeon_menu_crevicehunt.png",
		mode = "Crevice",
		icon = "img/icon_menu_crevice.png",
		title = T("level_battlemenu_name_crevice"),
		etc = T("level_battlemenu_list_hunt"),
		unlock_id = UNLOCK_ID.CRE_HUNT,
		noti = DungeonCrevice:CheckNotification(),
		booster_event_sub_type = EVENT_BOOSTER_SUB_TYPE.CREHUNT_EVENT,
		contents_disabled = var_59_0,
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Crevice"
			})
		end
	})
	
	if_set(var_59_1, "txt_name", T(Account:getCrehuntSeasonName()))
	
	local var_59_2 = Account:getCrehuntRemainTimeText()
	
	if_set(var_59_1, "txt_progress", var_59_2)
	
	return var_59_1
end

function DungeonHome.getExpeditionItem(arg_61_0)
	local var_61_0 = T("ui_expedition_left_text")
	local var_61_1 = ContentDisable:byAlias(string.lower("expedition")) and "content_disable" or nil
	local var_61_2 = arg_61_0:getCommonItem({
		no_bg = true,
		icon = "img/icon_menu_expedition.png",
		bg = "img/_dungeon_menu_expedition.png",
		mode = "Expedition",
		title = T("level_battlemenu_name_expedition"),
		etc = T("level_battlemenu_list_expedition"),
		unlock_id = UNLOCK_ID.EXPDEITION,
		time_remain = Account:getCoopMissionRemainTime(),
		handler = function()
			SceneManager:cancelReseveResetSceneFlow()
			SceneManager:nextScene("DungeonList", {
				mode = "Expedition"
			})
		end,
		noti = CoopUtil:isShowBattleMenuRedDot(),
		contents_disabled = var_61_1
	})
	
	if_set(var_61_2, "txt_name", var_61_0)
	if_set(var_61_2, "txt_progress", T("time_remain", {
		time = Account:getCoopMissionRemainTime()
	}))
	
	return var_61_2
end

function DungeonHome.setTrailExclusiveNoti(arg_63_0)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.wnd) then
		return 
	end
	
	local var_63_0 = arg_63_0:getDungeonItemControl("Trial_Hall")
	
	if not get_cocos_refid(var_63_0) then
		return 
	end
	
	if Account:getExclusiveShopNoti() then
		local var_63_1 = var_63_0:getChildByName("n_event")
		
		if_set_visible(var_63_1, nil, true)
		if_set_sprite(var_63_1, "icon_event", "img/shop_icon_new.png")
		if_set(var_63_1, "disc", T("trial_hall_new_equip"))
	end
	
	local var_63_2 = UNLOCK_ID.TRIAL_HALL
	
	if Account:isJPN() then
		var_63_2 = UNLOCK_ID.ALTER_DEV
	end
	
	local var_63_3 = not UnlockSystem:isUnlockSystem(var_63_2)
	
	if ContentDisable:byAlias(string.lower("trial_hall")) or var_63_3 then
		if_set_visible(var_63_0, "n_event", false)
	end
end
