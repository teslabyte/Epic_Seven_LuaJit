MoonlightTheaterList = {}

local var_0_0 = 500000

copy_functions(ScrollView, MoonlightTheaterList)

local function var_0_1(arg_1_0)
	if not arg_1_0 then
		return 
	end
	
	local var_1_0 = arg_1_0 .. "_e01"
	local var_1_1 = Account:get_mt_ep_info(var_1_0) or {}
	local var_1_2 = DB("ml_theater_story", var_1_0, {
		"need_clear_theater_story"
	})
	
	if var_1_2 then
		local var_1_3 = Account:get_mt_ep_info(var_1_2) or {}
		
		if table.empty(var_1_3) or not var_1_3.clear_tm then
			return 
		end
	end
	
	return table.empty(var_1_1)
end

local function var_0_2(arg_2_0, arg_2_1)
	MoonlightTheaterList:onScrollViewEvent(arg_2_0, arg_2_1)
end

function HANDLER.story_theater_base(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_enter" then
		MoonlightTheaterList:enterWrold()
	elseif arg_3_1 == "btn_prologue" then
		play_story(GAME_STATIC_VARIABLE.ml_theater or "mltheater_prologue", {
			force = true
		})
	end
end

function MoonlightTheaterList.show(arg_4_0, arg_4_1)
	SceneManager:nextScene("moonlight_theater")
end

function MoonlightTheaterList.onShow(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.parent_wnd or SceneManager:getDefaultLayer()
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("story_theater_base", true, "wnd")
	
	var_5_0:addChild(arg_5_0.vars.wnd)
	
	local var_5_1 = "infosubs_9"
	
	TopBarNew:create(T("theater_title"), arg_5_0.vars.wnd, function()
		MoonlightTheaterList:leave()
	end, nil, nil, var_5_1)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"theaterticket"
	})
	arg_5_0:initData()
	
	arg_5_0.vars.scrollview = arg_5_0.vars.wnd:getChildByName("ScrollView")
	
	arg_5_0.vars.scrollview:setDirection(2)
	arg_5_0.vars.scrollview:setScrollBarEnabled(false)
	
	arg_5_0.vars.controls = {}
	arg_5_0.vars.panel = cc.Layer:create()
	arg_5_0.vars.layer = cc.Layer:create()
	
	arg_5_0.vars.panel:setName("th_panel")
	arg_5_0.vars.layer:setName("th_layer")
	arg_5_0.vars.layer:addChild(arg_5_0.vars.panel)
	arg_5_0.vars.wnd:addChild(arg_5_0.vars.layer)
	arg_5_0.vars.layer:setPosition(300, 355)
	
	arg_5_0.vars.initialized = true
	arg_5_0.vars.item_size = 400
	arg_5_0.vars.width = 1580
	arg_5_0.vars.height = 582
	arg_5_0.vars.item_count = table.count(arg_5_0.vars.items)
	arg_5_0.vars.scroll_ratio = 0.5
	arg_5_0.vars.selected_item_pos = 0.65
	arg_5_0.vars.item_gap = 220
	arg_5_0.vars.zoom_scale = 0.55
	arg_5_0.vars.panel_size = arg_5_0.vars.width
	
	table.reverse(arg_5_0.vars.items)
	arg_5_0:calcBasicInfos()
	arg_5_0:arrangeItems()
	arg_5_0.vars.scrollview:addEventListener(var_0_2)
	arg_5_0:registerTouchHandler()
	
	local var_5_2 = arg_5_0.vars.wnd:getChildByName("n_page_num")
	
	var_5_2:removeAllChildren()
	DotScrollManager:create(var_5_2, {
		dot_count = arg_5_0.vars.item_count,
		red_dot_idxs = arg_5_0.vars.red_dot_idxs
	})
	SoundEngine:playBGM("event:/bgm/bgm_story_dark")
	
	local var_5_3, var_5_4, var_5_5, var_5_6, var_5_7 = SubStoryMoonlightTheater:getEnterBattle()
	
	if var_5_3 then
		SubStoryMoonlightTheater:setEnterBattle(false)
		
		local var_5_8 = var_5_5 and var_5_6
		
		arg_5_0.vars.cur_item = arg_5_0:getItemByIdx(var_5_4)
		
		arg_5_0:enterWrold(var_5_8, var_5_5, var_5_6, var_5_7)
	else
		var_5_4 = MoonlightTheaterManager:getTheaterIdx()
		
		arg_5_0:check_enter_story()
	end
	
	arg_5_0:scrollToIndex(var_5_4, 1)
	
	if not Scheduler:findByName("MoonlightTheaterList.updateTime") then
		Scheduler:addSlow(arg_5_0.vars.wnd, arg_5_0.updateTime, arg_5_0):setName("MoonlightTheaterList.updateTime")
	end
end

function MoonlightTheaterList.getCurTheaterIdx(arg_7_0)
	if not arg_7_0.vars or not arg_7_0.vars.cur_item then
		return 
	end
	
	return arg_7_0.vars.cur_item.idx
end

function MoonlightTheaterList.getItemByIdx(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not arg_8_0.vars.items then
		return 
	end
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.items) do
		if iter_8_1.idx == arg_8_1 then
			return iter_8_1
		end
	end
end

function MoonlightTheaterList.check_enter_story(arg_9_0)
	local var_9_0 = "mltheater_prologue"
	
	if not TutorialGuide:isClearedTutorial("mltheater") then
		TutorialGuide:startGuide("mltheater")
		
		return 
	end
end

function MoonlightTheaterList.initData(arg_10_0)
	arg_10_0.vars.items = {}
	arg_10_0.vars.red_dot_idxs = {}
	
	arg_10_0:updateData()
end

function MoonlightTheaterList.updateData(arg_11_0)
	for iter_11_0 = 1, 9999999 do
		local var_11_0, var_11_1, var_11_2, var_11_3 = DBN("ml_theater", iter_11_0, {
			"id",
			"btn_img",
			"btn_bi",
			"sort"
		})
		
		if not var_11_0 then
			break
		end
		
		local var_11_4 = {
			id = var_11_0,
			btn_img = var_11_1,
			btn_bi = var_11_2,
			sort = var_11_3,
			idx = var_11_3
		}
		
		var_11_4.is_new = MoonlightTheaterUtil:isNewEpisodeExist(var_11_4.id)
		var_11_4.is_free = MoonlightTheaterUtil:isFreeEpExist(var_11_4.id)
		var_11_4.is_all_clear = MoonlightTheaterManager:isAllClearedTheater(var_11_4.id)
		arg_11_0.vars.red_dot_idxs[var_11_3] = var_11_4.is_new
		arg_11_0.vars.items[var_11_3] = var_11_4
	end
end

function MoonlightTheaterList.updateTime(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) or not arg_12_0.vars.controls then
		Scheduler:removeByName("MoonlightTheaterList.updateTime")
		
		return 
	end
	
	if SubStoryMoonlightTheater:isValid() then
		return 
	end
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.items) do
		local var_12_0 = iter_12_1.is_free
		
		iter_12_1.is_free = MoonlightTheaterUtil:isFreeEpExist(iter_12_1.id)
		
		if var_12_0 ~= iter_12_1.is_free then
			local var_12_1 = arg_12_0.vars.controls[iter_12_0]
			
			arg_12_0:_onUpdateControl(var_12_1, iter_12_1)
		end
	end
end

function MoonlightTheaterList.updateTimeAllControls(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.items) do
		local var_13_0 = iter_13_1.is_free
		
		iter_13_1.is_free = MoonlightTheaterUtil:isFreeEpExist(iter_13_1.id)
		iter_13_1.is_new = MoonlightTheaterUtil:isNewEpisodeExist(iter_13_1.id)
		
		local var_13_1 = arg_13_0.vars.controls[iter_13_0]
		
		arg_13_0:_onUpdateControl(var_13_1, iter_13_1)
	end
end

function MoonlightTheaterList.registerTouchHandler(arg_14_0)
	local function var_14_0(arg_15_0, arg_15_1)
		if UIAction:Find("block") or NetWaiting:isWaiting() then
			return false
		end
		
		return arg_14_0.onTouchBegin(arg_14_0, arg_15_0, arg_15_1)
	end
	
	local function var_14_1(arg_16_0, arg_16_1)
		if UIAction:Find("block") or NetWaiting:isWaiting() then
			arg_14_0.touched = false
			
			return false
		end
		
		return arg_14_0.onTouchEnd(arg_14_0, arg_16_0, arg_16_1)
	end
	
	arg_14_0.vars.scrollview:setSwallowTouches(false)
	
	local var_14_2 = arg_14_0.vars.panel:getEventDispatcher()
	
	arg_14_0.vars.listener = cc.EventListenerTouchOneByOne:create()
	
	arg_14_0.vars.listener:registerScriptHandler(var_14_0, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_14_0.vars.listener:registerScriptHandler(var_14_1, cc.Handler.EVENT_TOUCH_ENDED)
	var_14_2:addEventListenerWithSceneGraphPriority(arg_14_0.vars.listener, arg_14_0.vars.panel)
end

function MoonlightTheaterList.onTouchBegin(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_1:getLocation()
	
	if not checkCollisionDynamic(arg_17_0.vars.scrollview, var_17_0.x, var_17_0.y) then
		arg_17_0.vars.scrollview_touch_x = nil
		arg_17_0.vars.scrollview_touch_y = nil
		
		return false
	end
	
	if arg_17_0:isScrolling() and arg_17_0.vars.scrollview:getScrollPower() > 20 then
		return false
	end
	
	arg_17_0.touched = true
	arg_17_0.vars.scrollview_dragging = nil
	arg_17_0.vars.scrollview_touch_x = var_17_0.x
	arg_17_0.vars.scrollview_touch_y = var_17_0.y
	arg_17_0.vars.scrollview_touch_tick = systick()
	
	return true
end

function MoonlightTheaterList.onTouchEnd(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1:getLocation()
	
	if not arg_18_0.touched then
		return true
	end
	
	arg_18_0.touched = false
	
	if arg_18_0.vars.scrollview_touch_tick and systick() - arg_18_0.vars.scrollview_touch_tick > 200 then
		return false
	end
	
	arg_18_0.vars.scrollview_touch_tick = nil
	
	local var_18_1, var_18_2 = arg_18_0:getTouchedItem(var_18_0.x, var_18_0.y)
	
	if not var_18_1 then
		return false
	end
	
	if not TutorialGuide:isAllowEvent(var_18_2) then
		return false
	end
	
	arg_18_0:onSelectItem(var_18_1, var_18_2)
	
	return false
end

function MoonlightTheaterList.getTouchedItem(arg_19_0, arg_19_1, arg_19_2)
	if not checkCollision(arg_19_0.vars.scrollview, arg_19_1, arg_19_2) or arg_19_0.vars.scrollview_touch_x == nil then
		return false
	end
	
	if math.abs(arg_19_0.vars.scrollview_touch_x - arg_19_1) > DESIGN_HEIGHT * 0.02 or math.abs(arg_19_0.vars.scrollview_touch_y - arg_19_2) > DESIGN_HEIGHT * 0.02 then
		return false
	end
	
	local var_19_0
	local var_19_1
	local var_19_2 = -1
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.controls or {}) do
		if iter_19_1:isVisible() then
			local var_19_3 = iter_19_1:getLocalZOrder()
			
			if get_cocos_refid(iter_19_1) and checkCollision(iter_19_1, arg_19_1, arg_19_2) and var_19_2 < var_19_3 then
				var_19_2 = var_19_3
				
				local var_19_4 = iter_19_0
				
				var_19_1 = iter_19_1
			end
		end
	end
	
	if not var_19_1 then
		return false
	end
	
	return var_19_1.item, var_19_1
end

function MoonlightTheaterList.onSelectItem(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1.idx
	
	if arg_20_0.vars.cur_item ~= arg_20_1 then
		arg_20_0.vars.selected_item = arg_20_1
		
		arg_20_0:scrollToIndex(var_20_0)
	elseif arg_20_0.vars.cur_item == arg_20_1 then
		MoonlightTheaterList:enterWrold()
	end
end

function MoonlightTheaterList.jumpToPercent(arg_21_0, arg_21_1)
	arg_21_0.vars.scrollview:jumpToPercentHorizontal(arg_21_1)
end

function MoonlightTheaterList.scrollToPercent(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.vars.scrollview:scrollToPercentHorizontal(arg_22_1, arg_22_2, true)
end

function MoonlightTheaterList.scrollToIndex(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_1 then
		return 
	end
	
	if arg_23_2 == nil then
		arg_23_2 = math.abs(arg_23_0.f_index - arg_23_1) / arg_23_0.vars.item_count * 1 + 0.2
	end
	
	local var_23_0 = 100 * ((arg_23_1 - 1) / (arg_23_0.vars.item_count - 1))
	
	if var_23_0 == 0 then
		var_23_0 = 0.1
	end
	
	arg_23_0:scrollToPercent(var_23_0, arg_23_2, true)
end

function MoonlightTheaterList.onScrollViewEvent(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars or not arg_24_0.vars.initialized then
		return 
	end
	
	if arg_24_2 == 9 then
		arg_24_0:arrangeItems()
	elseif arg_24_2 == 10 then
		arg_24_0:arrangeItems()
	end
	
	if false then
	end
	
	arg_24_0.vars.scroll_event_tick = uitick()
end

function MoonlightTheaterList.updateInnerSize(arg_25_0)
	arg_25_0.vars.inner_sz = {
		width = arg_25_0.vars.width,
		height = arg_25_0.vars.height
	}
	arg_25_0.vars.inner_sz.width = arg_25_0.vars.item_size * (arg_25_0.vars.item_count - 1) / arg_25_0.vars.scroll_ratio + arg_25_0.vars.width
	
	arg_25_0.vars.scrollview:setInnerContainerSize(arg_25_0.vars.inner_sz)
end

function MoonlightTheaterList.calcBasicInfos(arg_26_0, arg_26_1)
	arg_26_0.vars.display_count = 100
	
	arg_26_0.vars.scrollview:setScrollStep(arg_26_0.vars.item_size / arg_26_0.vars.scroll_ratio)
	arg_26_0:updateInnerSize()
	arg_26_0:updateScrollIndex()
end

function MoonlightTheaterList.getControlInfo(arg_27_0, arg_27_1)
	local var_27_0 = 1
	local var_27_1 = arg_27_0.f_index
	
	if var_27_1 < -1 then
		var_27_1 = -1
	end
	
	if var_27_1 > arg_27_0.vars.item_count + 0.5 then
		var_27_1 = arg_27_0.vars.item_count + 0.5
	end
	
	local var_27_2 = 1
	
	if arg_27_0.vars.selected_item_pos == 0 then
		var_27_2 = 0
	end
	
	local var_27_3 = math.max(var_27_2, math.floor(arg_27_0.vars.display_count * arg_27_0.vars.selected_item_pos))
	local var_27_4 = arg_27_0.vars.display_count - var_27_3
	
	if arg_27_1 < var_27_1 - var_27_3 - 1 or arg_27_1 > var_27_1 + var_27_4 + 2 then
		return nil
	end
	
	if arg_27_1 < var_27_1 - var_27_3 then
		var_27_0 = 1 - math.min(0.7, var_27_1 - var_27_3 - arg_27_1)
	end
	
	if arg_27_1 > var_27_1 + var_27_4 + 1 then
		var_27_0 = 1 - (arg_27_1 - (var_27_1 + var_27_4 + 1))
	end
	
	local var_27_5 = math.abs(var_27_1 - arg_27_1)
	
	if var_27_5 > 3 then
		return arg_27_0.vars.zoom_scale, var_27_0
	end
	
	return math.max(arg_27_0.vars.zoom_scale, 1 - (1 - arg_27_0.vars.zoom_scale) * (var_27_5 / 3)), var_27_0
end

function MoonlightTheaterList.getControl(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_0.vars.controls[arg_28_1]
	
	if not var_28_0 and arg_28_3 then
		var_28_0 = arg_28_0:createControl(arg_28_2)
		var_28_0.item = arg_28_2
		
		local var_28_1 = "center"
		local var_28_2 = DOCK_DIR[var_28_1]
		
		var_28_0:setAnchorPoint(var_28_2.ax, var_28_2.ay)
		
		if var_28_1 == "right" then
			var_28_0:setPositionX(arg_28_0.vars.width)
		elseif var_28_1 == "top" then
			var_28_0:setPositionY(arg_28_0.vars.height)
		end
		
		arg_28_0.vars.panel:addChild(var_28_0)
		
		arg_28_0.vars.controls[arg_28_1] = var_28_0
	end
	
	return var_28_0
end

function MoonlightTheaterList.onShowItem(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0:updateUnit(arg_29_1, arg_29_2)
end

function MoonlightTheaterList.updateUnit(arg_30_0, arg_30_1, arg_30_2)
end

function MoonlightTheaterList.call_setControlScaleByAdjustPos(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_0:onSetControlScale(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
end

function MoonlightTheaterList.call_onSetControlScale(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0:onSetControlScale(arg_32_0, arg_32_1, arg_32_2, 0)
end

function MoonlightTheaterList.onSetControlScale(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	if not arg_33_3.detail then
		return 
	end
	
	if arg_33_4 < 0.1 and arg_33_0.vars.minimized then
		arg_33_3.n_name:setOpacity(0)
	elseif arg_33_3.detail:isVisible() then
		arg_33_3.n_name:setOpacity(255)
	else
		arg_33_3.n_name:setOpacity(0)
	end
end

function MoonlightTheaterList._arrangeItemsOnHaveScale(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9)
	arg_34_1.idx = arg_34_3
	
	if not arg_34_1:isVisible() then
		arg_34_1:setVisible(true)
		arg_34_0:onShowItem(arg_34_1, arg_34_2)
	end
	
	local var_34_0 = arg_34_1:getScaleX()
	
	if var_34_0 ~= arg_34_4 then
		arg_34_1:setScaleX(arg_34_4)
		arg_34_1:setScaleY(arg_34_4)
	end
	
	local var_34_1 = arg_34_0.vars.item_gap
	local var_34_2 = arg_34_0.vars.item_count - arg_34_3
	
	if arg_34_4 > arg_34_0.vars.zoom_scale then
		var_34_2 = var_34_2 + arg_34_4 * 100
	end
	
	arg_34_1:setLocalZOrder(var_34_2)
	
	if arg_34_8 < var_34_2 then
		arg_34_8 = var_34_2
		arg_34_9 = arg_34_2
		arg_34_0.index = arg_34_3
	end
	
	if arg_34_4 > arg_34_0.vars.zoom_scale then
		var_34_1 = arg_34_0.vars.item_gap + (arg_34_0.vars.item_size - arg_34_0.vars.item_gap * 1.5) * ((arg_34_4 - arg_34_0.vars.zoom_scale) / (1 - arg_34_0.vars.zoom_scale))
		
		if var_34_0 ~= arg_34_4 then
			local var_34_3 = (arg_34_4 - arg_34_0.vars.zoom_scale) / (1 - arg_34_0.vars.zoom_scale)
			
			arg_34_0:call_setControlScaleByAdjustPos(arg_34_2, arg_34_1, var_34_3)
		end
	elseif var_34_0 ~= arg_34_4 then
		arg_34_0:call_onSetControlScale(arg_34_2, arg_34_1)
	end
	
	arg_34_1:setPositionX(arg_34_6)
	
	arg_34_6 = arg_34_6 + var_34_1
	
	if arg_34_3 > arg_34_0.f_index then
		arg_34_7 = arg_34_7 - var_34_1
	elseif arg_34_0.f_index - arg_34_3 < 1 then
		arg_34_7 = arg_34_7 - var_34_1 * (1 - (arg_34_0.f_index - arg_34_3))
	end
	
	arg_34_1:setOpacity(255 * arg_34_5)
	
	if arg_34_0.vars.cur_item then
		if arg_34_0.vars.cur_item == arg_34_2 then
			if_set_color(arg_34_1, nil, tocolor("#FFFFFF"))
			DotScrollManager:onSelectDot(arg_34_2.idx)
		else
			if_set_color(arg_34_1, nil, tocolor("#7F7F7F"))
		end
	end
	
	return arg_34_6, arg_34_7, arg_34_8, arg_34_9
end

function MoonlightTheaterList._arrangeItemsOnElse(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	if arg_35_1 then
		arg_35_1:setVisible(false)
	end
	
	arg_35_3 = arg_35_3 + arg_35_0.vars.item_gap
	
	if arg_35_2 >= arg_35_0.f_index then
		arg_35_4 = arg_35_4 - arg_35_0.vars.item_gap
	end
	
	return arg_35_3, arg_35_4
end

function MoonlightTheaterList.getRenderer2(arg_36_0, arg_36_1)
	return arg_36_0.vars.controls[arg_36_1]
end

function MoonlightTheaterList._arrangeItemsOnFinish(arg_37_0, arg_37_1, arg_37_2)
	arg_37_2 = arg_37_2 + arg_37_0.vars.panel_size * (1 - arg_37_0.vars.selected_item_pos)
	arg_37_2 = arg_37_2 + 100
	
	arg_37_0.vars.panel:setPositionX(arg_37_2)
	
	if arg_37_1 and arg_37_0.vars.cur_item ~= arg_37_1 then
		arg_37_0:onChangeCurrentItem(arg_37_1, arg_37_0.vars.cur_item)
		
		arg_37_0.vars.cur_item = arg_37_1
	end
	
	if arg_37_1 and arg_37_0.vars.cur_item == arg_37_1 then
		arg_37_0:onHighestItemUpdate(arg_37_1)
	end
end

function MoonlightTheaterList.onChangeCurrentItem(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_2 then
		local var_38_0 = arg_38_0:getRenderer2(arg_38_2.idx)
		
		if var_38_0 then
			arg_38_0:updateControlColor(arg_38_2, var_38_0)
		end
	end
	
	if arg_38_1 then
		local var_38_1 = arg_38_0:getRenderer2(arg_38_1.idx)
		
		if var_38_1 then
			arg_38_0:updateControlColor(arg_38_1, var_38_1, true)
		end
	end
	
	SoundEngine:play("event:/ui/list_scroll", {
		gap = 100
	})
end

function MoonlightTheaterList.onHighestItemUpdate(arg_39_0, arg_39_1)
end

function MoonlightTheaterList.updateControlColor(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if not arg_40_2 then
		return 
	end
end

function MoonlightTheaterList.arrangeItems(arg_41_0)
	arg_41_0:updateScrollIndex()
	arg_41_0:updateScrollDotUI()
	
	local var_41_0 = 0
	local var_41_1 = 0
	local var_41_2 = -1
	local var_41_3
	
	for iter_41_0 = arg_41_0.vars.item_count, 1, -1 do
		local var_41_4 = arg_41_0.vars.items[iter_41_0]
		local var_41_5, var_41_6 = arg_41_0:getControlInfo(iter_41_0)
		local var_41_7 = arg_41_0:getControl(iter_41_0, var_41_4, var_41_5 ~= nil)
		
		if var_41_5 then
			var_41_0, var_41_1, var_41_2, var_41_3 = arg_41_0:_arrangeItemsOnHaveScale(var_41_7, var_41_4, iter_41_0, var_41_5, var_41_6, var_41_0, var_41_1, var_41_2, var_41_3)
		else
			var_41_0, var_41_1 = arg_41_0:_arrangeItemsOnElse(var_41_7, iter_41_0, var_41_0, var_41_1)
		end
	end
	
	arg_41_0:_arrangeItemsOnFinish(var_41_3, var_41_1)
end

function MoonlightTheaterList.updateScrollDotUI(arg_42_0)
end

function MoonlightTheaterList.updateScrollIndex(arg_43_0)
	local var_43_0 = arg_43_0.vars.scrollview:getInnerContainerPosition()
	
	if math.is_nan_or_inf(var_43_0.x) then
		arg_43_0.vars.scrollview:setInnerContainerPosition({
			x = 0,
			y = var_43_0.y
		})
	end
	
	local var_43_1 = arg_43_0.vars.scrollview:getInnerContainerPosition()
	
	arg_43_0.vars.offset = var_43_1.x
	arg_43_0.f_index = (arg_43_0.vars.item_size * arg_43_0.vars.item_count + arg_43_0.vars.offset * arg_43_0.vars.scroll_ratio) / arg_43_0.vars.item_size
end

function MoonlightTheaterList.isScrolling(arg_44_0)
	if not arg_44_0.vars then
		return 
	end
	
	return arg_44_0.vars.scroll_event_tick and uitick() - arg_44_0.vars.scroll_event_tick < 60
end

function MoonlightTheaterList.createControl(arg_45_0, arg_45_1)
	local var_45_0 = load_control("wnd/story_theater_card.csb")
	
	if_set_visible(var_45_0, "btn_select", false)
	
	if not var_45_0.n_banner then
		local var_45_1 = var_45_0:getChildByName("n_bi")
		
		var_45_0.n_banner = cc.Sprite:create("banner/" .. arg_45_1.btn_bi .. ".png")
		
		if not var_45_0.n_banner then
			var_45_0.n_banner = cc.Sprite:create("banner/ss_vguila_bi_kr.png")
		end
		
		if var_45_0.n_banner then
			var_45_1:addChild(var_45_0.n_banner)
			var_45_0.n_banner:setAnchorPoint(0.5, 0.5)
			var_45_0.n_banner:setPosition(0, 0)
			var_45_0.n_banner:setScale(1)
		else
			Log.e("Err: no bg data: ", story_background_img)
		end
	end
	
	arg_45_0:_onUpdateControl(var_45_0, arg_45_1)
	
	return var_45_0
end

function MoonlightTheaterList._onUpdateControl(arg_46_0, arg_46_1, arg_46_2)
	if not arg_46_1 or not arg_46_2 then
		return 
	end
	
	if_set(arg_46_1, "txt_name", arg_46_2.idx)
	
	local var_46_0 = arg_46_1:getChildByName("n_state")
	local var_46_1
	local var_46_2
	local var_46_3
	
	if arg_46_2.is_new then
		var_46_1 = T("theater_desc_new")
		var_46_3 = "#ff8920"
	else
		var_46_1 = T("theater_desc_ing")
		var_46_3 = "#FFFFFF"
	end
	
	if_set(arg_46_1, "txt_state", var_46_1)
	if_set_color(arg_46_1, "txt_state", tocolor(var_46_3))
	
	local var_46_4 = arg_46_1:getChildByName("n_badge")
	
	if_set_visible(var_46_4, nil, true)
	
	if not var_46_4.n_new_icon then
		local var_46_5 = cc.Sprite:create("img/shop_icon_new.png")
		
		var_46_4:addChild(var_46_5)
		
		var_46_4.n_new_icon = var_46_5
	end
	
	if not var_46_4.n_free_icon then
		local var_46_6 = cc.Sprite:create("img/shop_icon_free_c.png")
		
		var_46_4:addChild(var_46_6)
		
		var_46_4.n_free_icon = var_46_6
	end
	
	if arg_46_2.is_new then
		var_46_4.n_new_icon:setVisible(true)
		var_46_4.n_free_icon:setVisible(false)
	elseif arg_46_2.is_free then
		var_46_4.n_new_icon:setVisible(false)
		var_46_4.n_free_icon:setVisible(true)
	else
		var_46_4.n_new_icon:setVisible(false)
		var_46_4.n_free_icon:setVisible(false)
		if_set_visible(arg_46_1, "n_state", not arg_46_2.is_all_clear)
	end
	
	if_set_sprite(arg_46_1, "img", "theater/" .. arg_46_2.btn_img .. ".png")
	
	local var_46_7 = MoonlightTheaterManager:isCastingRewardExist(arg_46_2.id) or MoonlightTheaterManager:getSeasonReceivableRewardExistByTheaterID(arg_46_2.id)
	
	if_set_visible(arg_46_1, "icon_noti", var_46_7)
end

function MoonlightTheaterList.onSelectScrollViewItem(arg_47_0, arg_47_1, arg_47_2)
end

function MoonlightTheaterList.enterWrold(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	if not arg_48_0.vars or not arg_48_0.vars.cur_item then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.cur_item
	
	SubStoryMoonlightTheater:show(arg_48_0.vars.wnd, var_48_0.id, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
end

function MoonlightTheaterList.leave(arg_49_0)
	if not arg_49_0.vars or not get_cocos_refid(arg_49_0.vars.wnd) then
		return 
	end
	
	SceneManager:nextScene("lobby", {
		open_sub_story = {
			mode = "HOME"
		}
	})
end

DotScrollManager = {}

function DotScrollManager.create(arg_50_0, arg_50_1, arg_50_2)
	if not get_cocos_refid(arg_50_1) then
		return 
	end
	
	local var_50_0 = arg_50_2 or {}
	
	arg_50_0.vars = {}
	arg_50_0.vars.parent_layer = arg_50_1
	arg_50_0.vars.red_dot_idxs = var_50_0.red_dot_idxs
	arg_50_0.vars.dot_count = var_50_0.dot_count or 10
	arg_50_0.vars.cur_num = 0
	arg_50_0.vars.gap = 17
	arg_50_0.vars.dot_ui_list = {}
	
	arg_50_0:initUI()
	
	local var_50_1 = var_50_0.cur_num or 1
	
	arg_50_0:onSelectDot(var_50_1)
end

function DotScrollManager.initUI(arg_51_0)
	for iter_51_0 = 1, arg_51_0.vars.dot_count do
		local var_51_0 = cc.Node:create()
		local var_51_1
		local var_51_2
		
		if arg_51_0:isRedDotIdx(iter_51_0) then
			var_51_1 = cc.Sprite:create("img/main_hud_banner2_page_on.png")
			var_51_2 = cc.Sprite:create("img/main_hud_banner2_page_off.png")
		else
			var_51_1 = cc.Sprite:create("img/main_hud_banner_page_on.png")
			var_51_2 = cc.Sprite:create("img/main_hud_banner_page_off.png")
		end
		
		local var_51_3 = ccui.Button:create()
		
		var_51_3:setName("btn_dot_" .. iter_51_0)
		var_51_3:setTouchEnabled(true)
		var_51_3:ignoreContentAdaptWithSize(false)
		var_51_3:setContentSize({
			width = 15,
			height = 15
		})
		var_51_3:setPosition(0, 0)
		var_51_3:setAnchorPoint(0.5, 0.5)
		
		var_51_3.idx = iter_51_0
		
		var_51_3:addTouchEventListener(function(arg_52_0, arg_52_1)
			if arg_52_1 ~= 2 then
				return 
			end
			
			MoonlightTheaterList:scrollToIndex(arg_52_0.idx)
		end)
		var_51_0:addChild(var_51_1)
		var_51_0:addChild(var_51_2)
		var_51_0:addChild(var_51_3)
		var_51_1:setAnchorPoint(0.5, 0.5)
		var_51_2:setAnchorPoint(0.5, 0.5)
		arg_51_0.vars.parent_layer:addChild(var_51_0)
		var_51_0:setPosition(0, 0)
		var_51_0:setAnchorPoint(0.5, 0.5)
		var_51_0:setName("dot_parent" .. iter_51_0)
		
		local var_51_4 = {
			on = var_51_1,
			off = var_51_2,
			n_parent = var_51_0
		}
		
		table.insert(arg_51_0.vars.dot_ui_list, var_51_4)
	end
	
	arg_51_0:_initPosition()
end

function DotScrollManager._initPosition(arg_53_0)
	local var_53_0 = 0
	
	for iter_53_0, iter_53_1 in pairs(arg_53_0.vars.dot_ui_list) do
		local var_53_1 = iter_53_1.n_parent
		
		if var_53_1 then
			var_53_1:setPositionX(var_53_0)
		end
		
		var_53_0 = var_53_0 + arg_53_0.vars.gap
	end
end

function DotScrollManager.isRedDotIdx(arg_54_0, arg_54_1)
	return arg_54_0.vars.red_dot_idxs[arg_54_1]
end

function DotScrollManager.onSelectDot(arg_55_0, arg_55_1)
	if not arg_55_0.vars or not arg_55_1 or arg_55_0.vars.cur_num == arg_55_1 then
		return 
	end
	
	if arg_55_1 <= 0 or arg_55_1 > arg_55_0.vars.dot_count or arg_55_0.vars.cur_num == arg_55_1 then
		return 
	end
	
	arg_55_0.vars.cur_num = arg_55_1
	
	for iter_55_0, iter_55_1 in pairs(arg_55_0.vars.dot_ui_list) do
		local var_55_0 = iter_55_0 == arg_55_1
		local var_55_1 = iter_55_1.on
		local var_55_2 = iter_55_1.off
		
		var_55_1:setVisible(var_55_0)
		var_55_2:setVisible(not var_55_0)
	end
end

MoonlightTheaterUtil = {}

function MoonlightTheaterUtil.isNewEpisodeExist(arg_56_0, arg_56_1)
	if not arg_56_1 then
		return 
	end
	
	local var_56_0 = arg_56_1
	
	if not var_56_0 then
		return 
	end
	
	local var_56_1
	
	for iter_56_0 = 1, 9999999 do
		local var_56_2 = DB("ml_theater_season", var_56_0 .. "_s" .. iter_56_0, {
			"id"
		})
		
		if not var_56_2 then
			return 
		end
		
		local var_56_3 = var_0_1(var_56_2)
		
		if iter_56_0 == 1 and var_56_3 then
			return true
		elseif not var_56_1 and var_56_3 then
			return true
		end
		
		var_56_1 = var_56_3
	end
end

function MoonlightTheaterUtil.isFreeEpExist(arg_57_0, arg_57_1)
	if not arg_57_1 then
		return 
	end
	
	for iter_57_0 = 1, 999999 do
		local var_57_0 = string.format("%s_s%d", arg_57_1, iter_57_0)
		local var_57_1 = DB("ml_theater_season", var_57_0, {
			"id"
		})
		
		if not var_57_1 then
			break
		end
		
		for iter_57_1 = 1, 999999 do
			local var_57_2 = string.format("%s_e%02d", var_57_1, iter_57_1)
			local var_57_3, var_57_4, var_57_5 = DB("ml_theater_story", var_57_2, {
				"id",
				"need_time",
				"need_clear_theater_story"
			})
			
			if not var_57_3 then
				break
			end
			
			var_57_4 = var_57_4 and var_57_4 * 60
			var_57_4 = var_57_4 or 0
			
			local var_57_6 = Account:get_mt_ep_info(var_57_3) or {}
			
			if iter_57_0 == 1 and iter_57_1 == 1 and not var_57_5 and table.empty(var_57_6) then
				return true
			end
			
			local var_57_7 = Account:get_mt_ep_info(var_57_5) or {}
			
			if var_57_5 and (table.empty(var_57_7) or not var_57_7.clear_tm) then
				return 
			end
			
			if not table.empty(var_57_6) and not var_57_6.clear_tm and var_57_6.buy_state and var_57_6.buy_state == 1 then
				return true
			end
			
			if var_57_7.clear_tm and (not var_57_6 or table.empty(var_57_6) or not var_57_6.clear_tm) then
				return var_57_4 - (os.time() - var_57_7.clear_tm) <= 0
			end
		end
	end
	
	return false
end

function MoonlightTheaterUtil.openTicketBuyPopup(arg_58_0)
	local var_58_0 = {
		id = "theaterticket",
		token = "to_gold",
		bulk_purchase = "y",
		type = "to_theaterticket",
		value = 1,
		desc = "item_category_key",
		price = to_n(var_0_0),
		parent_self = arg_58_0
	}
	local var_58_1 = ShopCommon:ShowConfirmDialog(var_58_0, nil, {
		force_max = 5,
		resize_name = true
	})
	
	if_set(var_58_1, "txt_buy", T("theater_ticket_buy_title"))
	if_set(var_58_1, "infor", T("theater_ticket_buy_desc"))
end

function MoonlightTheaterUtil.reqBuy(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	query("buy", {
		caller = "topbar",
		shop = "normal",
		item = "currency_20",
		multiply = arg_59_2
	})
end

MoonlightTheaterManager = {}

function MoonlightTheaterManager.setPlayedDLCEffect(arg_60_0, arg_60_1)
	arg_60_0.dlc_effect = arg_60_1
end

function MoonlightTheaterManager.isPlayedDLCEffect(arg_61_0)
	return arg_61_0.dlc_effect
end

function MoonlightTheaterManager.getTotalRedNoti(arg_62_0)
	local var_62_0 = UNLOCK_ID.MOONLIGHT_THEATER
	
	if not UnlockSystem:isUnlockSystem(var_62_0) then
		return 
	end
	
	return arg_62_0:isWorldEpRewardExist()
end

function MoonlightTheaterManager.getFreeIconNoti(arg_63_0)
	local var_63_0 = UNLOCK_ID.MOONLIGHT_THEATER
	
	if not UnlockSystem:isUnlockSystem(var_63_0) then
		return 
	end
	
	for iter_63_0 = 1, 9999999 do
		local var_63_1 = DBN("ml_theater", iter_63_0, {
			"id"
		})
		
		if not var_63_1 then
			break
		end
		
		if MoonlightTheaterUtil:isFreeEpExist(var_63_1) then
			return true
		end
	end
end

function MoonlightTheaterManager.getNewIconNoti(arg_64_0)
	local var_64_0 = UNLOCK_ID.MOONLIGHT_THEATER
	
	if not UnlockSystem:isUnlockSystem(var_64_0) then
		return 
	end
	
	for iter_64_0 = 1, 999999 do
		local var_64_1 = DBN("ml_theater", iter_64_0, {
			"id"
		})
		
		if not var_64_1 then
			return 
		end
		
		local var_64_2
		
		for iter_64_1 = 1, 9999999 do
			local var_64_3 = DB("ml_theater_season", var_64_1 .. "_s" .. iter_64_1, {
				"id"
			})
			
			if not var_64_3 then
				return 
			end
			
			local var_64_4 = var_0_1(var_64_3)
			
			if iter_64_1 == 1 and var_64_4 then
				return true
			elseif not var_64_2 and var_64_4 then
				return true
			end
			
			var_64_2 = var_64_4
		end
	end
end

function MoonlightTheaterManager.isCastingRewardExist(arg_65_0, arg_65_1)
	if not DB("ml_theater", arg_65_1, {
		"id"
	}) then
		return 
	end
	
	for iter_65_0 = 1, 999999 do
		local var_65_0 = arg_65_1 .. "_slot" .. iter_65_0
		local var_65_1 = DBT("ml_theater_cast", var_65_0, {
			"id",
			"cast_char",
			"cast_reward",
			"cast_reward_val"
		})
		
		if not var_65_1 or not var_65_1.id then
			return 
		end
		
		var_65_1.is_user_have = Account:getCollectionUnit(var_65_1.cast_char)
		var_65_1.is_rewarded = Account:is_received_casting_reward(var_65_1.id)
		
		if var_65_1.is_user_have and not var_65_1.is_rewarded then
			return true
		end
	end
end

function MoonlightTheaterManager.isWorldCastingRewardExist(arg_66_0)
	for iter_66_0 = 1, 999999 do
		local var_66_0 = DBN("ml_theater", iter_66_0, {
			"id"
		})
		
		if not var_66_0 then
			return 
		end
		
		if arg_66_0:isCastingRewardExist(var_66_0) then
			return true
		end
	end
end

function MoonlightTheaterManager.isSeasonRewardExist(arg_67_0, arg_67_1)
	if not arg_67_1 then
		return 
	end
	
	if not DB("ml_theater_season", arg_67_1, {
		"id"
	}) then
		return 
	end
	
	for iter_67_0 = 1, 99999999 do
		local var_67_0 = string.format("%s_e%02d", arg_67_1, iter_67_0)
		local var_67_1 = DB("ml_theater_story", var_67_0, {
			"id"
		})
		
		if not var_67_1 then
			return 
		end
		
		local var_67_2 = Account:get_mt_ep_info(var_67_1)
		
		if not var_67_2 or table.empty(var_67_2) then
			return 
		end
		
		if var_67_2.clear_tm and var_67_2.state and var_67_2.state == EP_REWARD_STATE.CLEAR then
			return true
		end
	end
end

function MoonlightTheaterManager.isTheaterEpRewardExist(arg_68_0, arg_68_1)
	if not DB("ml_theater", arg_68_1, {
		"id"
	}) then
		return 
	end
	
	for iter_68_0 = 1, 999999 do
		local var_68_0 = arg_68_1 .. "_s" .. iter_68_0
		local var_68_1 = DB("ml_theater_season", var_68_0, {
			"id"
		})
		
		if not var_68_1 then
			return 
		end
		
		if arg_68_0:isSeasonRewardExist(var_68_1) then
			return true
		end
	end
end

function MoonlightTheaterManager.isWorldEpRewardExist(arg_69_0)
	for iter_69_0 = 1, 999999 do
		local var_69_0 = DBN("ml_theater", iter_69_0, {
			"id"
		})
		
		if not var_69_0 then
			return 
		end
		
		if arg_69_0:isCastingRewardExist(var_69_0) then
			return true
		end
	end
end

function MoonlightTheaterManager.getTotalSeasonReceivableRewardExist(arg_70_0)
	local var_70_0 = UNLOCK_ID.MOONLIGHT_THEATER
	
	if not UnlockSystem:isUnlockSystem(var_70_0) then
		return 
	end
	
	for iter_70_0 = 1, 9999999 do
		local var_70_1 = DBN("ml_theater_season", iter_70_0, {
			"id"
		})
		
		if not var_70_1 then
			break
		end
		
		if arg_70_0:getSeasonReceivableRewardExist(var_70_1) then
			return true
		end
	end
end

function MoonlightTheaterManager.getSeasonReceivableRewardExistByTheaterID(arg_71_0, arg_71_1)
	if not arg_71_1 then
		return 
	end
	
	for iter_71_0 = 1, 9999999 do
		local var_71_0 = string.format("%s_s%d", arg_71_1, iter_71_0)
		local var_71_1 = DB("ml_theater_season", var_71_0, {
			"id"
		})
		
		if not var_71_1 then
			break
		end
		
		if arg_71_0:getSeasonReceivableRewardExist(var_71_1) then
			return true
		end
	end
end

function MoonlightTheaterManager.getSeasonReceivableRewardExist(arg_72_0, arg_72_1)
	if not arg_72_1 then
		return 
	end
	
	local var_72_0 = DB("ml_theater_season", arg_72_1, {
		"id"
	})
	
	if not var_72_0 then
		return 
	end
	
	for iter_72_0 = 1, 99999 do
		local var_72_1 = string.format("%s_e%02d", var_72_0, iter_72_0)
		local var_72_2 = Account:get_mt_ep_info(var_72_1)
		
		if not var_72_2 or table.empty(var_72_2) then
			break
		end
		
		if var_72_2.state and var_72_2.state == EP_REWARD_STATE.CLEAR then
			return true
		end
	end
	
	return false
end

function MoonlightTheaterManager.getTheaterIdx(arg_73_0)
	local var_73_0 = 1
	
	for iter_73_0 = 1, 999999 do
		local var_73_1 = DBN("ml_theater", iter_73_0, {
			"id"
		})
		
		if not var_73_1 then
			break
		end
		
		for iter_73_1 = 1, 999999 do
			local var_73_2 = DB("ml_theater_season", var_73_1 .. "_s" .. iter_73_1, {
				"id"
			})
			
			if not var_73_2 then
				break
			end
			
			for iter_73_2 = 1, 9999999 do
				local var_73_3 = string.format("%s_e%02d", var_73_2, iter_73_2)
				local var_73_4 = DB("ml_theater_story", var_73_3, {
					"id"
				})
				
				if not var_73_4 then
					break
				end
				
				if not Account:isCleared_mlt_ep(var_73_4) then
					return iter_73_0
				end
			end
		end
		
		var_73_0 = iter_73_0
	end
	
	return var_73_0
end

function MoonlightTheaterManager.isAllClearedTheater(arg_74_0, arg_74_1)
	if not arg_74_1 then
		return 
	end
	
	arg_74_1 = DB("ml_theater", arg_74_1, {
		"id"
	})
	
	if not arg_74_1 then
		return 
	end
	
	for iter_74_0 = 1, 999999 do
		local var_74_0 = DB("ml_theater_season", arg_74_1 .. "_s" .. iter_74_0, {
			"id"
		})
		
		if not var_74_0 then
			return true
		end
		
		for iter_74_1 = 1, 9999999 do
			local var_74_1 = string.format("%s_e%02d", var_74_0, iter_74_1)
			local var_74_2 = DB("ml_theater_story", var_74_1, {
				"id"
			})
			
			if not var_74_2 then
				break
			end
			
			if not Account:isCleared_mlt_ep(var_74_2) then
				return false
			end
		end
	end
	
	return true
end
