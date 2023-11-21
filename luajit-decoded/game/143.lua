DungeonCommon = DungeonCommon or {}

function HANDLER.dungeon_period(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = getParentWindow(arg_1_0).class
	
	if var_1_0 and var_1_0.onHandler then
		var_1_0:onHandler(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	end
end

function HANDLER_BEFORE.dungeon_period(arg_2_0, arg_2_1)
	local var_2_0 = getParentWindow(arg_2_0).class
	
	if var_2_0 and var_2_0.onHandlerBefore then
		var_2_0:onHandlerBefore(arg_2_0, arg_2_1)
	end
end

function HANDLER_CANCEL.dungeon_period(arg_3_0, arg_3_1)
	local var_3_0 = getParentWindow(arg_3_0).class
	
	if var_3_0 and var_3_0.onHandlerCancel then
		var_3_0:onHandlerCancel(arg_3_0, arg_3_1)
	end
end

function HANDLER.dungeon_period_bar(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = getParentWindow(arg_4_0)
	local var_4_1 = var_4_0.info
	
	var_4_0.parent:onSelectScrollViewItem(var_4_0.idx, {
		item = var_4_1,
		control = arg_4_0
	})
end

local function var_0_0(arg_5_0, arg_5_1)
	local var_5_0 = getParentWindow(arg_5_0).class
	
	var_5_0.onScroll(var_5_0)
end

copy_functions(ScrollView, DungeonCommon)

local function var_0_1(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or os.time()
	
	local var_6_0 = math.huge
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.tm) do
		if not iter_6_1[1] then
			break
		end
		
		if arg_6_1 >= iter_6_1[1] and arg_6_1 < iter_6_1[2] then
			return iter_6_1[1], iter_6_1[2]
		end
		
		if arg_6_1 < iter_6_1[1] then
			var_6_0 = math.min(var_6_0, iter_6_1[1])
		end
	end
	
	return var_6_0, 0
end

local function var_0_2(arg_7_0, arg_7_1)
	local var_7_0 = os.time()
	local var_7_1, var_7_2 = arg_7_0:getNextEnterTimeToEnter()
	local var_7_3, var_7_4 = arg_7_1:getNextEnterTimeToEnter()
	
	if var_7_1 <= var_7_0 and var_7_3 <= var_7_0 then
		if var_7_2 == var_7_4 then
			return arg_7_0.no < arg_7_1.no
		else
			return var_7_2 < var_7_4
		end
	elseif var_7_1 < var_7_0 then
		return true
	elseif var_7_3 < var_7_0 then
		return false
	end
	
	if var_7_1 == var_7_3 then
		return arg_7_0.no < arg_7_1.no
	end
	
	return var_7_1 < var_7_3
end

local function var_0_3(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or os.time()
	
	local var_8_0, var_8_1 = arg_8_0:getNextEnterTimeToEnter(arg_8_1)
	
	return var_8_0 <= arg_8_1 and arg_8_1 < var_8_1
end

local function var_0_4(arg_9_0)
	return {
		cmon = BOOSTERSKILL_EFFECT_TYPE.OPEN_ALTAR_DARK,
		ctue = BOOSTERSKILL_EFFECT_TYPE.OPEN_ALTAR_FIRE,
		cwed = BOOSTERSKILL_EFFECT_TYPE.OPEN_ALTAR_ICE,
		cthu = BOOSTERSKILL_EFFECT_TYPE.OPEN_ALTAR_WIND,
		cfri = BOOSTERSKILL_EFFECT_TYPE.OPEN_ALTAR_LIGHT
	}
end

function DungeonCommon.getFirstDungeonControl(arg_10_0)
	return arg_10_0.ScrollViewItems[1].control
end

function DungeonCommon.getScrollViewItem(arg_11_0, arg_11_1)
	local var_11_0 = load_control("wnd/dungeon_period_bar.csb")
	
	var_11_0.parent = arg_11_0
	var_11_0.info = arg_11_1
	var_11_0.idx = #arg_11_0.ScrollViewItems + 1
	
	if_set(var_11_0, "title", T(arg_11_1.name))
	
	var_11_0.guide_tag = tostring(arg_11_1.dungeon_id)
	
	local var_11_1, var_11_2 = DB("character", arg_11_1.monster_id, {
		"face_id",
		"ch_attribute"
	})
	
	if_set_sprite(var_11_0, "face", "face/" .. var_11_1 .. "_s.png")
	if_set_sprite(var_11_0, "cm_icon_element", "img/cm_icon_pro" .. var_11_2 .. ".png")
	if_set_visible(var_11_0, "n_maze", false)
	
	local var_11_3 = DungeonCommon:UpdateRestTime(var_11_0, var_11_0:getChildByName("txt_time"), arg_11_1, os.time())
	local var_11_4 = arg_11_0:getDungeonDBName()
	local var_11_5
	
	if var_11_4 == "level_battlemenu_genie" then
		var_11_5 = arg_11_1.enter_key
		
		if_set_visible(var_11_0, "txt_progress", false)
		if_set_visible(var_11_0, "txt_time", true)
	elseif var_11_4 == "level_battlemenu_hunt" then
		var_11_5 = arg_11_1.no
		
		if_set_visible(var_11_0, "txt_progress", true)
		if_set_visible(var_11_0, "txt_time", false)
		if_set(var_11_0, "txt_progress", T(DungeonHunt:getPhase(arg_11_1.enter_key)))
	end
	
	local var_11_6 = var_11_0:getChildByName("bg")
	local var_11_7 = DB(var_11_4, tostring(var_11_5), "icon_battlemenu")
	
	if var_11_7 and get_cocos_refid(var_11_6) then
		SpriteCache:resetSprite(var_11_6, "img/" .. var_11_7 .. ".png")
	end
	
	arg_11_0:setEventBanner(var_11_0, arg_11_1)
	
	return var_11_0
end

function DungeonCommon.setEventBanner(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_2 or not arg_12_1 then
		return 
	end
	
	if arg_12_2.event_banner and type(arg_12_2.event_banner) == "string" then
		if_set_visible(arg_12_1, "n_badge", true)
		if_set_visible(arg_12_1, "bg_yellow", arg_12_2.event_banner == "new" or arg_12_2.event_banner == "limited")
		if_set_visible(arg_12_1, "bg_green", arg_12_2.event_banner == "update")
		if_set(arg_12_1, "txt_banner", T("dungeon_home_banner_" .. arg_12_2.event_banner))
	end
end

function DungeonCommon.onSelectScrollViewItem(arg_13_0, arg_13_1, arg_13_2)
	if TutorialGuide:checkBlockDungeonPeriodList(arg_13_2) then
		return 
	end
	
	SoundEngine:play("event:/ui/btn_small")
	DungeonList:enterDungeon({
		info = arg_13_2.item
	})
end

function DungeonCommon.UpdateRestTime(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0, var_14_1 = arg_14_3:getNextEnterTimeToEnter(arg_14_4)
	local var_14_2 = var_14_0 <= arg_14_4 and arg_14_4 < var_14_1
	local var_14_3 = Account:getEnterLimitInfo(arg_14_3.enter_key .. "001")
	local var_14_4 = var_14_3 and var_14_3 <= 0
	
	if var_14_2 and not var_14_4 then
		if var_14_1 == 0 then
			arg_14_2:setVisible(false)
		else
			arg_14_2:setString(T("time_remain", {
				time = sec_to_string(var_14_1 - arg_14_4)
			}))
		end
		
		if arg_14_1 then
			arg_14_1:setColor(cc.c3b(255, 255, 255))
		end
		
		if not arg_14_5 then
			arg_14_2:setColor(cc.c3b(107, 193, 27))
			arg_14_2:enableOutline(cc.c3b(34, 34, 34), 1)
		end
		
		if arg_14_1 then
			if_set_opacity(arg_14_1, "bg", 255)
			if_set_opacity(arg_14_1, "title", 255)
		end
	else
		if var_14_4 then
			arg_14_2:setString(T("ui_battlemenu_cannot_enter"))
		else
			arg_14_2:setString(T("time_wait", {
				time = sec_to_string(var_14_0 - arg_14_4)
			}))
		end
		
		if not arg_14_5 then
			arg_14_2:setColor(cc.c3b(171, 135, 89))
			arg_14_2:enableOutline(cc.c3b(10, 20, 34), 1)
		end
		
		if arg_14_1 then
			if_set_opacity(arg_14_1, "bg", 76.5)
			if_set_opacity(arg_14_1, "title", 76.5)
		end
	end
	
	arg_14_0:setEventBanner(arg_14_1, arg_14_3)
	
	return var_14_2
end

function DungeonCommon.getFloorList(arg_15_0, arg_15_1)
	local var_15_0 = {}
	
	for iter_15_0 = 1, 99 do
		local var_15_1 = {}
		
		var_15_1.enter_id, var_15_1.name, var_15_1.type = DB("level_enter", arg_15_1 .. string.format("%03d", iter_15_0), {
			"id",
			"name",
			"type"
		})
		
		if not var_15_1.enter_id then
			break
		end
		
		if BattleUtil:isEnterableFloor(var_15_1.type, iter_15_0) then
			var_15_1.isLock = not Account:checkEnterMap(var_15_1.enter_id)
			var_15_1.isClear = Account:isMapCleared(var_15_1.enter_id)
			
			if not var_15_1.isLock then
				arg_15_0.vars.start_floor = iter_15_0
			end
			
			table.push(var_15_0, var_15_1)
		end
	end
	
	return var_15_0
end

function DungeonCommon.onEnter(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars.wnd then
		arg_16_0.vars.wnd = load_dlg("dungeon_period", true, "wnd")
		arg_16_0.vars.wnd.class = arg_16_0
		
		arg_16_1:addChild(arg_16_0.vars.wnd)
	end
	
	if_set(arg_16_0.vars.wnd, "txt_title", T(arg_16_2.info.name))
	if_set(arg_16_0.vars.wnd, "txt_title_2", T(arg_16_2.info.name))
	if_set(arg_16_0.vars.wnd, "txt_desc", T(DB(arg_16_0:getDungeonDBName(), tostring(arg_16_2.info.dungeon_id), "desc")))
	if_set_visible(arg_16_0.vars.wnd, "btn_achieve", false)
	
	local var_16_0 = DungeonList:getCurrentDungeonId() == "hunt" and not ContentDisable:byAlias("hunt_guide") and IS_PUBLISHER_STOVE
	
	if_set_visible(arg_16_0.vars.wnd, "btn_discussion", var_16_0)
	
	arg_16_0.vars.floors = arg_16_0:getFloorList(arg_16_2.info.enter_key)
	arg_16_0.vars.opts = arg_16_2
	arg_16_0.vars.part_offset = 103
	arg_16_0.vars.part_count = #arg_16_0.vars.floors
	arg_16_0.vars.view_height = arg_16_0.vars.part_offset * (arg_16_0.vars.part_count + 1)
	arg_16_0.vars.scrollview = arg_16_0.vars.wnd:getChildByName("scrollview")
	
	arg_16_0.vars.scrollview:setInnerContainerSize({
		width = arg_16_0.vars.scrollview:getContentSize().width,
		height = arg_16_0.vars.view_height + arg_16_0.vars.part_offset * 4
	})
	arg_16_0.vars.scrollview:setScrollStep(arg_16_0.vars.view_height / arg_16_0.vars.part_offset)
	
	arg_16_0.vars.floor_info_node = arg_16_0.vars.wnd:getChildByName("floor_info")
	
	arg_16_0.vars.scrollview:addEventListener(var_0_0)
	arg_16_0.vars.scrollview:setScrollSpeed(7)
	
	if arg_16_0.vars.scrollview.setMovementFactor then
		arg_16_0.vars.scrollview:setMovementFactor(0.1)
	end
	
	if get_cocos_refid(arg_16_0.vars.listener) then
		arg_16_0:removeScrollEventListener(arg_16_0.vars.scrollview)
	end
	
	local var_16_1 = arg_16_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_16_1) then
		arg_16_0.vars.listener = cc.EventListenerTouchOneByOne:create()
		
		arg_16_0.vars.listener:registerScriptHandler(function(arg_17_0, arg_17_1)
			return arg_16_0:onTouchDown(arg_17_0, arg_17_1)
		end, cc.Handler.EVENT_TOUCH_BEGAN)
		arg_16_0.vars.listener:registerScriptHandler(function(arg_18_0, arg_18_1)
			return arg_16_0:onTouchUp(arg_18_0, arg_18_1)
		end, cc.Handler.EVENT_TOUCH_ENDED)
		arg_16_0.vars.listener:registerScriptHandler(function(arg_19_0, arg_19_1)
			return arg_16_0:onTouchMove(arg_19_0, arg_19_1)
		end, cc.Handler.EVENT_TOUCH_MOVED)
		
		local var_16_2 = cc.Node:create()
		
		var_16_2:setName("priority_node")
		arg_16_0.vars.scrollview:addChild(var_16_2)
		var_16_1:addEventListenerWithSceneGraphPriority(arg_16_0.vars.listener, var_16_2)
	end
	
	arg_16_0:updateFloorInfo()
	arg_16_0:onUpdateRemainTime(true)
	arg_16_0:moveToFloor(arg_16_0.vars.start_floor, true, 0.7)
	arg_16_0:onChangeFloor(arg_16_0.vars.start_floor)
	
	local var_16_3 = arg_16_0.vars.wnd:getChildByName("LEFT")
	local var_16_4 = arg_16_0.vars.wnd:getChildByName("RIGHT")
	local var_16_5 = var_16_3:getChildByName("n_expedition")
	local var_16_6 = CoopMission:isUnlocked() and DungeonList:getCurrentDungeonId() == "hunt"
	
	if get_cocos_refid(var_16_5) then
		var_16_5:setVisible(var_16_6)
		
		local var_16_7, var_16_8 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EXPEDITION_DETECT)
		local var_16_9 = var_16_3:getChildByName("n_expedition_event")
		
		if_set_visible(var_16_9, nil, var_16_6 and var_16_7)
		
		if var_16_6 and var_16_7 then
			local var_16_10, var_16_11 = var_16_3:getChildByName("n_expedition_move"):getPosition()
			
			var_16_5:setPosition(var_16_10, var_16_11)
			
			local var_16_12 = Booster:getEventBoosterUIDesc(var_16_8)
			
			if_set(var_16_9, "event_disc", var_16_12)
		end
		
		local var_16_13 = var_16_5:getChildByName("btn_expedition")
		local var_16_14 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EXPEDITION_POINT)
		
		if_set_visible(var_16_13, "icon_event", var_16_6 and var_16_14)
	end
	
	if not arg_16_2.enter then
		var_16_3:setPositionX(VIEW_BASE_LEFT - 400)
		var_16_4:setPositionX(VIEW_BASE_RIGHT + 600)
		UIAction:Add(LOG(MOVE_TO(250, NotchStatus:getNotchBaseLeft())), var_16_3, "block")
		UIAction:Add(LOG(MOVE_TO(250, NotchStatus:getNotchBaseRight(true))), var_16_4, "block")
	end
	
	local var_16_15 = arg_16_0:getDungeonDBName()
	local var_16_16 = arg_16_0.vars.wnd:getChildByName("scroll_view")
	
	if get_cocos_refid(var_16_16) then
		local var_16_17 = var_16_16:getPositionY()
		local var_16_18
		
		if var_16_15 == "level_battlemenu_genie" then
			var_16_18 = "n_remain_time"
			
			if_set_visible(arg_16_0.vars.wnd, "n_remain_time", true)
			if_set_visible(arg_16_0.vars.wnd, "n_under_bar", false)
		else
			var_16_18 = "n_under_bar"
			
			if_set_visible(arg_16_0.vars.wnd, "n_remain_time", false)
			if_set_visible(arg_16_0.vars.wnd, "n_under_bar", true)
		end
		
		local var_16_19 = arg_16_0.vars.wnd:getChildByName(var_16_18):getChildByName("ver_bar"):getPositionY()
		
		var_16_16:setContentSize(var_16_16:getContentSize().width, var_16_17 - var_16_19)
	end
	
	if get_cocos_refid(arg_16_0.vars.wnd:getChildByName("LEFT")) and get_cocos_refid(arg_16_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_expedition")) and DungeonList:getCurrentDungeonId() == "genie" then
		arg_16_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_expedition"):setVisible(false)
	end
	
	TutorialGuide:procGuide(arg_16_0.vars.wnd)
	
	if arg_16_0.onAfterEnter then
		arg_16_0:onAfterEnter()
	end
end

function DungeonCommon.removeScrollEventListener(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_20_0.vars.listener) then
		return 
	end
	
	if not get_cocos_refid(arg_20_0.vars.scrollview) then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.scrollview:getEventDispatcher()
	
	if get_cocos_refid(var_20_0) then
		var_20_0:removeEventListener(arg_20_0.vars.listener)
	end
	
	arg_20_0.vars.listener:setEnabled(false)
	
	arg_20_0.vars.listener = nil
end

function DungeonCommon.onLeave(arg_21_0)
	local var_21_0 = arg_21_0.vars.wnd:getChildByName("LEFT")
	local var_21_1 = arg_21_0.vars.wnd:getChildByName("RIGHT")
	
	UIAction:Add(RLOG(MOVE_TO(250, VIEW_BASE_LEFT - 700)), var_21_0, "block")
	UIAction:Add(RLOG(MOVE_TO(250, VIEW_BASE_RIGHT + 800)), var_21_1, "block")
	UIAction:Add(SEQ(DELAY(250), REMOVE()), arg_21_0.vars.wnd, "block")
	
	arg_21_0.vars.wnd = nil
	arg_21_0.vars.i_floor = nil
	arg_21_0.vars.scroll_pos = nil
	
	arg_21_0:removeScrollEventListener()
end

function DungeonCommon.ready(arg_22_0, arg_22_1)
	if not DEBUG.DEBUG_NO_ENTER_LIMIT then
		if not arg_22_0.vars.opts.info:isEnterable() then
			balloon_message_with_sound("battlemenu_time_error")
			
			return 
		end
		
		if arg_22_0.vars.floors[arg_22_0.vars.i_floor].isLock then
			balloon_message_with_sound("err_prev_map")
			
			return 
		end
		
		local var_22_0, var_22_1 = Account:getEnterLimitInfo(arg_22_0.vars.floors[arg_22_0.vars.i_floor].enter_id)
		
		if var_22_0 and var_22_0 <= 0 then
			balloon_message_with_sound("level_battlemenu_enter_error")
			
			return 
		end
	end
	
	local var_22_2
	
	arg_22_1 = arg_22_1 or {
		enter_id = arg_22_0.vars.floors[arg_22_0.vars.i_floor].enter_id
	}
	
	BattleReady:show({
		skip_intro = arg_22_1.enter,
		enter_id = arg_22_1.enter_id,
		callback = arg_22_0,
		enter_error_text = var_22_2,
		currencies = DungeonList:getCurrentCurrencies()
	})
	
	arg_22_0.vars.enter_id = arg_22_1.enter_id
end

function DungeonCommon.onStartBattle(arg_23_0, arg_23_1)
	startBattle(arg_23_1.enter_id)
end

function DungeonCommon.onCloseBattleReadyDialog(arg_24_0)
	if arg_24_0.vars.enter_id then
		BattleReady:hide()
		
		arg_24_0.vars.enter_id = nil
	end
end

function DungeonCommon.create(arg_25_0, arg_25_1)
	arg_25_0.vars = {}
	arg_25_0.vars.MainList, arg_25_0.vars.AllList = arg_25_0:GetDungeonList(arg_25_0:getDungeonDBName(), arg_25_0:now())
	
	arg_25_0:initScrollView(arg_25_1:getChildByName(arg_25_0:getMainWindowScrollViewName()), 250, 204)
	arg_25_0:createScrollViewItems(arg_25_0.vars.AllList)
	if_set_visible(arg_25_1, "bg_item2", true)
	
	return arg_25_0:getBackgroundLayer(arg_25_1)
end

function DungeonCommon.updateAllList(arg_26_0)
	arg_26_0.vars.MainList, arg_26_0.vars.AllList = arg_26_0:GetDungeonList(arg_26_0:getDungeonDBName(), arg_26_0:now())
	
	arg_26_0:createScrollViewItems(arg_26_0.vars.AllList)
	arg_26_0:updateDungeonInfo()
end

function DungeonCommon.updateDungeonInfo(arg_27_0)
	local var_27_0 = arg_27_0.vars.opts.info
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.AllList) do
		if iter_27_1.no == var_27_0.no then
			arg_27_0.vars.opts.info = iter_27_1
			
			break
		end
	end
end

function DungeonCommon.GetDungeonList(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = {}
	local var_28_1 = {}
	local var_28_2 = table.clone(AccountData.dungeon_weekly)
	
	if arg_28_1 == "level_battlemenu_genie" then
		local var_28_3 = Booster:getEnabledTime(BOOSTERSKILL_EFFECT_TYPE.OPEN_ALL_ALTAR)
		local var_28_4 = var_0_4()
		
		for iter_28_0, iter_28_1 in pairs(var_28_2) do
			local var_28_5 = DB(arg_28_1, tostring(iter_28_1.enter_key), {
				"id"
			})
			
			if var_28_5 then
				local var_28_6 = iter_28_1.tm
				
				if var_28_3 and #var_28_3 > 0 then
					for iter_28_2, iter_28_3 in pairs(var_28_3) do
						table.push(var_28_6, iter_28_3)
					end
				end
				
				if var_28_4[var_28_5] then
					local var_28_7 = var_28_4[var_28_5]
					local var_28_8 = Booster:getEnabledTime(var_28_7)
					
					if var_28_8 and #var_28_8 > 0 then
						table.push(var_28_6, var_28_8)
					end
				end
				
				local var_28_9 = {
					no = iter_28_1.id,
					dungeon_id = var_28_5,
					name = iter_28_1.name,
					monster_id = iter_28_1.monster_id,
					enter_key = iter_28_1.enter_key,
					tm = var_28_6,
					isEnterable = var_0_3,
					getNextEnterTimeToEnter = var_0_1
				}
				local var_28_10 = var_28_9:isEnterable()
				local var_28_11 = var_28_9:getNextEnterTimeToEnter()
				
				if var_28_6 and #var_28_6 > 0 then
					table.push(var_28_1, var_28_9)
				end
				
				if var_28_10 then
					table.push(var_28_0, var_28_9)
				end
			end
		end
	else
		for iter_28_4 = 1, 99 do
			local var_28_12, var_28_13, var_28_14, var_28_15, var_28_16, var_28_17, var_28_18, var_28_19, var_28_20 = DBN(arg_28_1, iter_28_4, {
				"name",
				"monster_id",
				"enter_key",
				"begin1",
				"end1",
				"begin2",
				"end2",
				"begin3",
				"end3"
			})
			
			if var_28_12 == nil then
				break
			end
			
			local var_28_21 = {
				{
					var_28_15,
					var_28_16
				},
				{
					var_28_17,
					var_28_18
				},
				{
					var_28_19,
					var_28_20
				}
			}
			
			if arg_28_1 == "level_battlemenu_hunt" then
				local var_28_22, var_28_23, var_28_24 = Account:serverTimeWeekLocalDetail()
				
				var_28_21 = {
					{
						var_28_23 + var_28_15,
						var_28_23 + var_28_16
					},
					{},
					{}
				}
			end
			
			local var_28_25 = {
				no = iter_28_4,
				dungeon_id = iter_28_4,
				name = var_28_12,
				monster_id = var_28_13,
				enter_key = var_28_14,
				tm = var_28_21,
				isEnterable = var_0_3,
				getNextEnterTimeToEnter = var_0_1
			}
			
			table.push(var_28_1, var_28_25)
			
			if var_28_25:isEnterable() then
				table.push(var_28_0, var_28_25)
			end
		end
	end
	
	return arg_28_0:sort(var_28_0, var_28_1)
end

function DungeonCommon.sort(arg_29_0, arg_29_1, arg_29_2)
	table.sort(arg_29_1, var_0_2)
	table.sort(arg_29_2, var_0_2)
	
	return arg_29_1, arg_29_2
end

function DungeonCommon.now(arg_30_0)
	return os.time()
end

function DungeonCommon.onAfterUpdate(arg_31_0)
	if arg_31_0.vars then
		local var_31_0 = arg_31_0:now()
		
		if arg_31_0.vars.prev_tm ~= var_31_0 then
			arg_31_0.vars.prev_tm = var_31_0
		end
	end
end

function DungeonCommon.getInfo(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	return (arg_32_0.vars.opts or {}).info
end

function DungeonCommon.getSceneState(arg_33_0)
	if not arg_33_0.vars then
		return {}
	end
	
	local var_33_0 = {
		no = arg_33_0.vars.cur_no,
		enter_id = arg_33_0.vars.enter_id,
		show_ready_dialog = arg_33_0.vars.enter_id ~= nil
	}
	
	if arg_33_0.vars.opts then
		var_33_0.enter_key = arg_33_0.vars.opts.info.enter_key
		var_33_0.info = arg_33_0.vars.opts.info
	end
	
	return var_33_0
end

function DungeonCommon.getUnlockedMaxFloor(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	if not arg_34_0.vars.floors then
		return 
	end
	
	local var_34_0 = 1
	
	for iter_34_0, iter_34_1 in ipairs(arg_34_0.vars.floors) do
		if iter_34_1.isLock == false then
			var_34_0 = math.max(var_34_0, iter_34_0)
		end
	end
	
	print("UnlockedMaxFloor : ", var_34_0)
	
	return var_34_0
end

function DungeonCommon.updateFloorInfo(arg_35_0)
	if not arg_35_0.vars or not arg_35_0.vars.scrollview then
		return 
	end
	
	if not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	local var_35_0 = arg_35_0.vars.scrollview:getInnerContainerPosition().y
	
	if arg_35_0.vars.scroll_pos == var_35_0 then
		return 
	end
	
	arg_35_0.vars.scroll_pos = var_35_0
	arg_35_0.vars.f_floor = arg_35_0.vars.part_count - ((0 - var_35_0) / (arg_35_0.vars.view_height / (arg_35_0.vars.part_count + 1)) + 1) + 0.5
	arg_35_0.vars.f_floor = math.max(1, math.min(arg_35_0.vars.f_floor, arg_35_0.vars.part_count))
	arg_35_0.vars.i_floor = math.floor(arg_35_0.vars.f_floor + 0.5)
	
	arg_35_0.vars.floor_info_node:setPositionY((arg_35_0.vars.f_floor - arg_35_0.vars.i_floor) * arg_35_0.vars.part_offset)
	
	for iter_35_0 = -3, 3 do
		local var_35_1 = iter_35_0 + arg_35_0.vars.i_floor
		local var_35_2 = arg_35_0.vars.floor_info_node:getChildByName("F" .. iter_35_0)
		
		if var_35_1 < 1 or var_35_1 > arg_35_0.vars.part_count then
			var_35_2:setVisible(false)
			
			var_35_2.guide_tag = nil
		else
			var_35_2:setVisible(true)
			
			local var_35_3 = arg_35_0.vars.floors[var_35_1]
			
			var_35_2.guide_tag = var_35_3.enter_id
			
			if var_35_2.info ~= var_35_3 then
				var_35_2.info = var_35_3
				
				if_set(var_35_2, "floor", T(var_35_3.name))
				if_set_visible(var_35_2, "n_completed", var_35_3.isClear or var_35_1 < arg_35_0.vars.start_floor)
				if_set_visible(var_35_2, "n_locked", var_35_3.isLock)
				if_set_visible(var_35_2, "lock", var_35_3.isLock)
				if_set_visible(var_35_2, "desc", false)
				
				local var_35_4 = tostring(arg_35_0.vars.i_floor)
				local var_35_5 = arg_35_0.vars.opts.info.enter_key
				local var_35_6 = ""
				
				for iter_35_1 = -2 + #var_35_4, 0 do
					var_35_6 = var_35_6 .. "0"
				end
				
				local var_35_7 = var_35_5 .. var_35_6 .. var_35_4
				
				if_set_visible(arg_35_0.vars.wnd:getChildByName("page_title"), "n_expedition", CoopMission:isUnlocked() and DB("expedition_detect", var_35_7, {
					"id"
				}))
				
				local var_35_8 = var_35_2:getChildByName("floor")
				local var_35_9 = var_35_2:getChildByName("desc")
				
				if var_35_3.isLock then
					var_35_8:setTextColor(cc.c3b(180, 180, 180))
				elseif var_35_3.isClear or var_35_1 < arg_35_0.vars.start_floor then
					var_35_8:setTextColor(cc.c3b(255, 255, 255))
				else
					var_35_8:setTextColor(cc.c3b(255, 255, 255))
					var_35_9:setVisible(true)
					var_35_9:setTextColor(cc.c3b(171, 135, 89))
					var_35_9:setOpacity(100)
					var_35_9:setString(T("can_enter"))
				end
			end
		end
	end
	
	GrowthGuideNavigator:proc()
	
	if arg_35_0.vars.i_floor ~= arg_35_0.vars.prev_i_floor then
		arg_35_0.vars.prev_i_floor = arg_35_0.vars.i_floor
		
		arg_35_0:onChangeFloor(arg_35_0.vars.i_floor)
	end
end

function DungeonCommon.refreshButtonEnterInfo(arg_36_0)
	if not arg_36_0.vars.floors then
		return 
	end
	
	if not arg_36_0.vars.i_floor then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.floors[arg_36_0.vars.i_floor]
	
	if not var_36_0 then
		return 
	end
	
	if not arg_36_0.vars.wnd or not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	local var_36_1 = arg_36_0.vars.wnd:getChildByName("btn_go")
	
	if get_cocos_refid(var_36_1) then
		var_36_1.guide_tag = var_36_0.enter_id
		
		UIUtil:setButtonEnterInfo(var_36_1, var_36_0.enter_id)
	end
end

function DungeonCommon.onChangeFloor(arg_37_0, arg_37_1)
	if not arg_37_0.vars or not arg_37_0.vars.wnd then
		return 
	end
	
	local var_37_0 = arg_37_0.vars.floors[arg_37_1]
	
	if_set(arg_37_0.vars.wnd, "txt_floor", T(var_37_0.name))
	
	local var_37_1, var_37_2 = DB("level_enter", var_37_0.enter_id, {
		"use_enterpoint",
		"type"
	})
	
	arg_37_0:refreshButtonEnterInfo()
	
	local var_37_3, var_37_4 = DB("character", arg_37_0.vars.opts.info.monster_id, {
		"face_id",
		"ch_attribute"
	})
	
	if_set_sprite(arg_37_0.vars.wnd, "face", "face/" .. var_37_3 .. "_s.png")
	if_set_sprite(arg_37_0.vars.wnd, "cm_icon_element", "img/cm_icon_pro" .. var_37_4 .. ".png")
	
	local var_37_5 = {}
	
	for iter_37_0 = 1, 40 do
		local var_37_6, var_37_7, var_37_8, var_37_9 = DB("level_enter_drops", var_37_0.enter_id, {
			"item" .. iter_37_0,
			"type" .. iter_37_0,
			"set" .. iter_37_0,
			"grade_rate" .. iter_37_0
		})
		
		if var_37_6 and not UIUtil:isHideItem(var_37_6) then
			table.push(var_37_5, {
				var_37_6,
				var_37_7,
				var_37_8,
				var_37_9
			})
		end
	end
	
	local var_37_10 = UIUtil:sortDisplayItems(var_37_5, var_37_0.enter_id, "list")
	
	if var_37_2 == "hunt" then
		var_37_10 = UIUtil:getDisplayKeyItems(var_37_10)
	end
	
	for iter_37_1 = 1, 3 do
		local var_37_11 = var_37_10[iter_37_1]
		
		if var_37_11 then
			local var_37_12 = var_37_11[1]
			local var_37_13 = var_37_11[3]
			local var_37_14 = var_37_11[4]
			local var_37_15 = DB("character", var_37_12, "id") ~= nil
			
			arg_37_0.vars.wnd:getChildByName("n_item" .. iter_37_1):setVisible(true)
			
			if var_37_15 then
				UIUtil:getRewardIcon(nil, var_37_12, {
					right_hero_name = true,
					show_name = true,
					detail = true,
					parent = arg_37_0.vars.wnd:getChildByName("n_item" .. iter_37_1)
				})
			else
				UIUtil:getRewardIcon(nil, var_37_12, {
					show_name = true,
					grade_max = true,
					detail = true,
					parent = arg_37_0.vars.wnd:getChildByName("n_item" .. iter_37_1),
					set_drop = var_37_13,
					grade_rate = var_37_14
				})
			end
		else
			arg_37_0.vars.wnd:getChildByName("n_item" .. iter_37_1):setVisible(false)
		end
	end
	
	local var_37_16 = arg_37_0.vars.floors[arg_37_0.vars.i_floor].isLock
	local var_37_17, var_37_18 = Account:getEnterLimitInfo(arg_37_0.vars.floors[arg_37_0.vars.i_floor].enter_id)
	local var_37_19 = var_37_17 == nil or var_37_17 > 0
	local var_37_20 = arg_37_0.vars.opts.info:isEnterable() and not var_37_16 and var_37_19
	
	UIUtil:changeButtonState(arg_37_0.vars.wnd:getChildByName("btn_go"), var_37_20, true)
	UIUtil:changeButtonState(arg_37_0.vars.wnd:getChildByName("btn_buy"), not var_37_16 and var_37_19, true)
	arg_37_0:updateEnterExtraButton()
	
	local var_37_21 = arg_37_0.vars.wnd:getChildByName("reward1")
	
	if get_cocos_refid(var_37_21) then
		local var_37_22 = var_37_21:getChildByName("scroll_view")
		
		if get_cocos_refid(var_37_22) then
			var_37_22:jumpToTop()
		end
	end
end

function DungeonCommon.onScroll(arg_38_0)
	arg_38_0:updateFloorInfo()
end

function DungeonCommon.moveToFloor(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	arg_39_3 = arg_39_3 or 2
	arg_39_1 = math.max(0, math.min(arg_39_0.vars.part_count, arg_39_1))
	
	local var_39_0 = (arg_39_1 - 1) * (100 / (arg_39_0.vars.part_count - 1))
	
	if arg_39_2 then
		if var_39_0 == 100 then
			var_39_0 = 101
		end
		
		arg_39_0.vars.scrollview:scrollToPercentVertical(var_39_0, arg_39_3, true)
	else
		arg_39_0.vars.scrollview:jumpToPercentVertical(var_39_0)
	end
end

function DungeonCommon.onGameEvent(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.vars then
		return 
	end
	
	if arg_40_1 == "shop_buy" or arg_40_1 == "read_mail" then
		arg_40_0:refreshButtonEnterInfo()
	end
end

function DungeonCommon.onTouchDown(arg_41_0, arg_41_1, arg_41_2)
	if UIAction:Find("block") then
		return false
	end
	
	arg_41_0.vars.touchdown_dirty = arg_41_1:getLocation()
	
	return true
end

function DungeonCommon.onTouchMove(arg_42_0, arg_42_1, arg_42_2)
	if UIAction:Find("block") then
		return false
	end
	
	if not arg_42_0.vars.touchdown_dirty then
		return 
	end
	
	if math.abs(arg_42_0.vars.touchdown_dirty.x - arg_42_1:getLocation().x) > DESIGN_HEIGHT * 0.03 or math.abs(arg_42_0.vars.touchdown_dirty.y - arg_42_1:getLocation().y) > DESIGN_HEIGHT * 0.03 then
		arg_42_0.vars.touchdown_dirty = nil
	end
	
	return true
end

function DungeonCommon.onTouchUp(arg_43_0, arg_43_1, arg_43_2)
	if UIAction:Find("block") then
		return false
	end
	
	if DungeonCommon:isOverlapped() then
		return 
	end
	
	local var_43_0
	
	if arg_43_0.vars.touchdown_dirty and get_cocos_refid(arg_43_0.vars.floor_info_node) then
		var_43_0 = arg_43_1:getLocation()
		
		for iter_43_0 = -3, 3 do
			local var_43_1 = iter_43_0 + arg_43_0.vars.i_floor
			local var_43_2 = arg_43_0.vars.floor_info_node:getChildByName("F" .. iter_43_0)
			
			if var_43_1 < 1 or var_43_1 > arg_43_0.vars.part_count then
			else
				local var_43_3 = var_43_2:getChildByName("panel")
				
				if checkCollision(var_43_3, var_43_0.x, var_43_0.y) then
					arg_43_0:moveToFloor(var_43_1)
					arg_43_2:stopPropagation()
				end
			end
		end
	end
	
	return true
end

function DungeonCommon.isOverlapped(arg_44_0)
	if TouchBlocker:isBlockingScene(SceneManager:getCurrentSceneName()) then
		return true
	end
	
	return BattleReady:isShow() or Postbox:isShow() or Inventory:isShow() or HelpGuide:isShow() or UnitEquip:isVisible() or TopBarNew:isQuickMenuOpenned() or ChatMain:isVisible() or Dialog:getMsgBoxHandlerCount() > 0 or CollectionController:isShow() or MazeRaidRewards:isShow() or UIOption:isShow() or BackPlayControlBox:getWnd()
end

function DungeonCommon.onUpdateRemainTime(arg_45_0, arg_45_1)
	if not arg_45_0.ScrollViewItems then
		return 
	end
	
	if not arg_45_0.vars or not arg_45_0.vars.i_floor then
		return 
	end
	
	local var_45_0 = os.time()
	
	if arg_45_1 then
		local var_45_1 = arg_45_0.vars.floors[arg_45_0.vars.i_floor].isLock
		local var_45_2, var_45_3 = Account:getEnterLimitInfo(arg_45_0.vars.floors[arg_45_0.vars.i_floor].enter_id)
		local var_45_4 = var_45_2 == nil or var_45_2 > 0
		local var_45_5 = arg_45_0:UpdateRestTime(nil, arg_45_0.vars.wnd:getChildByName("txt_remain_time"), arg_45_0.vars.opts.info, var_45_0) and not var_45_1 and var_45_4
		
		UIUtil:changeButtonState(arg_45_0.vars.wnd:getChildByName("btn_go"), var_45_5)
		UIUtil:changeButtonState(arg_45_0.vars.wnd:getChildByName("btn_buy"), not var_45_1 and var_45_4, true)
		arg_45_0:updateEnterExtraButton()
	else
		for iter_45_0, iter_45_1 in pairs(arg_45_0.ScrollViewItems) do
			arg_45_0:UpdateRestTime(iter_45_1.control, iter_45_1.control:getChildByName("txt_progress"), iter_45_1.item, var_45_0)
		end
	end
end

function DungeonCommon.updateEnterExtraButton(arg_46_0)
end

DungeonWeekly = {}

copy_functions(DungeonCommon, DungeonWeekly)

function DungeonWeekly.updateEnterExtraButton(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.vars.floors[arg_47_0.vars.i_floor].isLock
	local var_47_1, var_47_2 = Account:getEnterLimitInfo(arg_47_0.vars.floors[arg_47_0.vars.i_floor].enter_id)
	local var_47_3
	
	var_47_3 = var_47_1 == nil or var_47_1 > 0
	
	local var_47_4 = not arg_47_0.vars.opts.info:isEnterable()
	local var_47_5 = arg_47_0.vars.wnd:getChildByName("btn_buy")
	local var_47_6 = arg_47_0.vars.wnd:getChildByName("btn_go")
	
	if_set_visible(var_47_5, nil, arg_47_1 or var_47_4)
	if_set_visible(var_47_6, nil, not arg_47_1 and not var_47_4)
end

function DungeonWeekly.getDungeonDBName(arg_48_0)
	return "level_battlemenu_genie"
end

function DungeonWeekly.getMainWindowScrollViewName(arg_49_0)
	return "weekly_scrollview"
end

function DungeonWeekly.getBackgroundLayer(arg_50_0, arg_50_1)
	return EffectManager:Play({
		pivot_x = 0,
		fn = "ui_bg_faery.cfx",
		pivot_y = 0,
		pivot_z = 0,
		layer = arg_50_1:getChildByName("n_bg")
	}), true
end

function DungeonWeekly.onAfterEnter(arg_51_0)
	if_set_visible(arg_51_0.vars.wnd, "back_blue", false)
	if_set_visible(arg_51_0.vars.wnd, "back_green", true)
	if_set_visible(arg_51_0.vars.wnd, "back_purple", false)
	
	local var_51_0 = arg_51_0.vars.wnd:getChildByName("btn_buy")
	
	if get_cocos_refid(var_51_0) then
		local var_51_1 = var_51_0:getChildByName("txt_go")
		
		if_set(var_51_1, nil, T("ui_dungeon_spirit_buy_enter"))
		
		local var_51_2 = var_51_0:getChildByName("n_token")
		local var_51_3 = var_51_0:getChildByName("cost")
		
		UIUtil:getRewardIcon(nil, "to_crystal", {
			no_bg = true,
			no_tooltip = true,
			parent = var_51_2
		})
		if_set(var_51_3, nil, GAME_CONTENT_VARIABLE.buy_open_altar_1hour)
	end
end

function DungeonWeekly.onHandler(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	if arg_52_2 == "btn_go" then
		UIUtil:checkBtnTouchPos(arg_52_1, arg_52_4, arg_52_5)
		arg_52_0:ready()
	end
	
	if arg_52_2 == "btn_buy" then
		arg_52_0:buyBoost()
	end
end

function DungeonWeekly.buyBoost(arg_53_0)
	if arg_53_0.vars.floors[arg_53_0.vars.i_floor].isLock then
		balloon_message_with_sound("err_prev_map")
		
		return 
	end
	
	if not arg_53_0.vars.opts.info:isEnterable() then
		DungeonWeeklyOpen:show(nil, arg_53_0.vars.opts.info)
	else
		Log.e("DungeonWeekly.buyBoost", "isEnterable")
	end
end

function DungeonWeekly.ready(arg_54_0, arg_54_1)
	if not DEBUG.DEBUG_NO_ENTER_LIMIT then
		if not arg_54_0.vars.opts.info:isEnterable() then
			balloon_message_with_sound("battlemenu_time_error")
			
			return 
		end
		
		if arg_54_0.vars.floors[arg_54_0.vars.i_floor].isLock then
			balloon_message_with_sound("err_prev_map")
			
			return 
		end
		
		local var_54_0, var_54_1 = Account:getEnterLimitInfo(arg_54_0.vars.floors[arg_54_0.vars.i_floor].enter_id)
		
		if var_54_0 and var_54_0 <= 0 then
			balloon_message_with_sound("level_battlemenu_enter_error")
			
			return 
		end
	end
	
	local var_54_2
	
	arg_54_1 = arg_54_1 or {
		enter_id = arg_54_0.vars.floors[arg_54_0.vars.i_floor].enter_id
	}
	
	BattleReady:show({
		skip_intro = arg_54_1.enter,
		enter_id = arg_54_1.enter_id,
		callback = arg_54_0,
		enter_error_text = var_54_2,
		currencies = DungeonList:getCurrentCurrencies()
	})
	
	arg_54_0.vars.enter_id = arg_54_1.enter_id
end

function DungeonWeekly.buyBoosterRefresh(arg_55_0, arg_55_1)
	local var_55_0 = table.find(DungeonWeekly.vars.AllList, function(arg_56_0, arg_56_1)
		return arg_56_1.dungeon_id == arg_55_1
	end)
	local var_55_1 = DungeonWeekly.vars.AllList[var_55_0]
	local var_55_2 = var_0_4()
	
	if var_55_2[arg_55_1] then
		local var_55_3 = var_55_2[arg_55_1]
		local var_55_4 = Booster:getEnabledTime(var_55_3)
		
		if var_55_4 and #var_55_4 > 0 then
			table.push(var_55_1.tm, var_55_4)
		end
	end
	
	if not table.find(DungeonWeekly.vars.MainList, function(arg_57_0, arg_57_1)
		return arg_57_1.dungeon_id == arg_55_1
	end) then
		table.insert(DungeonWeekly.vars.MainList, var_55_1)
	end
	
	DungeonWeekly:updateAllList()
	DungeonWeekly:refreshButtonEnterInfo()
end

function HANDLER.dungeon_buy(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	if arg_58_1 == "btn_cancel" then
		Dialog:close("dungeon_buy")
	elseif arg_58_1 == "btn_buy" then
		Dialog:close("dungeon_buy")
		DungeonWeeklyOpen:query()
	end
end

function MsgHandler.buy_boost_dungeon_weekly_attribute(arg_59_0)
	Account:addReward(arg_59_0.dec_result)
	Account:addReward(arg_59_0.rewards, {
		single = true
	})
	balloon_message_with_sound("shop_buy_success")
	DungeonWeekly:buyBoosterRefresh(arg_59_0.dungeon_id)
	DungeonWeekly:updateEnterExtraButton()
end

DungeonWeeklyOpen = DungeonWeeklyOpen or {}

function DungeonWeeklyOpen.show(arg_60_0, arg_60_1, arg_60_2)
	arg_60_0.vars = {}
	arg_60_1 = arg_60_1 or SceneManager:getRunningPopupScene()
	arg_60_0.vars.wnd = Dialog:open("wnd/dungeon_buy", arg_60_0)
	
	arg_60_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_60_0.vars.wnd, "block")
	arg_60_1:addChild(arg_60_0.vars.wnd)
	
	local var_60_0 = {}
	
	var_60_0.cmon = "dark"
	var_60_0.ctue = "fire"
	var_60_0.cwed = "ice"
	var_60_0.cthu = "wind"
	var_60_0.cfri = "light"
	
	local var_60_1 = var_60_0[arg_60_2.dungeon_id]
	
	arg_60_0.vars.dungeon_id = arg_60_2.dungeon_id
	arg_60_0.vars.attribute = var_60_1
	arg_60_0.vars.info = arg_60_2
	
	local var_60_2 = arg_60_0.vars.wnd:getChildByName("n_item_pos")
	local var_60_3 = GAME_CONTENT_VARIABLE["buy_open_" .. var_60_1 .. "_altar_1hour_item"]
	
	UIUtil:getRewardIcon(1, var_60_3, {
		parent = var_60_2
	})
	
	local var_60_4, var_60_5 = DB("item_special", var_60_3, {
		"desc_category",
		"name"
	})
	
	if_set(arg_60_0.vars.wnd, "txt_shop_type", T(var_60_4))
	if_set(arg_60_0.vars.wnd, "txt_shop_name", T(var_60_5))
	
	local var_60_6 = GAME_CONTENT_VARIABLE.buy_open_altar_1hour
	local var_60_7 = arg_60_0.vars.wnd:getChildByName("n_pay_token")
	
	UIUtil:getRewardIcon(nil, "to_crystal", {
		no_bg = true,
		scale = 0.6,
		parent = var_60_7
	})
	if_set(arg_60_0.vars.wnd, "txt_price", var_60_6)
end

function DungeonWeeklyOpen.query(arg_61_0)
	local var_61_0 = os.time()
	local var_61_1, var_61_2 = arg_61_0.vars.info:getNextEnterTimeToEnter(var_61_0)
	local var_61_3 = false
	
	if var_61_1 and var_61_2 == 0 and var_61_0 > var_61_1 - 3600 then
		var_61_3 = true
	end
	
	local var_61_4 = "to_crystal"
	
	if Account:getCurrency(var_61_4) < GAME_CONTENT_VARIABLE.buy_open_altar_1hour then
		UIUtil:checkCurrencyDialog("crystal")
		
		return 
	end
	
	local function var_61_5()
		query("buy_boost_dungeon_weekly_attribute", {
			attribute = arg_61_0.vars.attribute,
			dungeon_id = arg_61_0.vars.dungeon_id
		})
	end
	
	if var_61_3 then
		Dialog:msgBox(T("open_altar_buycheck_desc"), {
			yesno = true,
			handler = var_61_5
		})
	else
		var_61_5()
	end
end
