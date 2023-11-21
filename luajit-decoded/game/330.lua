Dock = {}

local var_0_0 = 0.75

DOCK_DIR = {
	left = {
		ax = 0,
		dir = 1,
		ay = 0.5,
		x = 0,
		y = DESIGN_HEIGHT / 2
	},
	right = {
		ax = 1,
		dir = 1,
		ay = 0.5,
		x = DESIGN_WIDTH,
		y = DESIGN_HEIGHT / 2
	},
	top = {
		ax = 0.5,
		dir = 2,
		ay = 1,
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT
	},
	bottom = {
		y = 0,
		ax = 0.5,
		dir = 2,
		ay = 0,
		x = DESIGN_WIDTH / 2
	},
	center = {
		ax = 0.5,
		dir = 2,
		ay = 0.5,
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	}
}

function dockEventHandler(arg_1_0, arg_1_1)
	arg_1_0.dock:onScrollViewEvent(arg_1_1)
end

function Dock.onScrollViewEvent(arg_2_0, arg_2_1)
	if arg_2_0.vars.skip_event then
		return 
	end
	
	if not arg_2_0.items or not arg_2_0.vars.initialized then
		return 
	end
	
	if arg_2_1 == 9 then
		arg_2_0:arrangeItems()
	elseif arg_2_1 == 10 then
		arg_2_0:arrangeItems()
	end
	
	if false then
	end
	
	arg_2_0.scroll_event_tick = uitick()
	
	if arg_2_0.opts.handler.onScroll then
		arg_2_0.opts.handler:onScroll(arg_2_0, arg_2_1)
	end
end

function Dock.updateScrollIndex(arg_3_0)
	if arg_3_0.opts.vertical then
		arg_3_0.offset = arg_3_0.scroll:getInnerContainerPosition().y
	else
		arg_3_0.offset = arg_3_0.scroll:getInnerContainerPosition().x
	end
	
	if arg_3_0.item_count <= 1 then
		arg_3_0.f_index = 1
		
		return 
	end
	
	arg_3_0.f_index = (arg_3_0.opts.item_size * arg_3_0.item_count + arg_3_0.offset * arg_3_0.opts.scroll_ratio) / arg_3_0.opts.item_size
end

function Dock.getControlInfo(arg_4_0, arg_4_1)
	local var_4_0 = 1
	local var_4_1 = arg_4_0.f_index
	
	if var_4_1 < -1 then
		var_4_1 = -1
	end
	
	if var_4_1 > arg_4_0.item_count + 0.5 then
		var_4_1 = arg_4_0.item_count + 0.5
	end
	
	local var_4_2 = 1
	
	if arg_4_0.opts.selected_item_pos == 0 then
		var_4_2 = 0
	end
	
	local var_4_3 = math.max(var_4_2, math.floor(arg_4_0.opts.display_count * arg_4_0.opts.selected_item_pos))
	local var_4_4 = arg_4_0.opts.display_count - var_4_3
	
	if arg_4_1 < var_4_1 - var_4_3 - 1 or arg_4_1 > var_4_1 + var_4_4 + 2 then
		return nil
	end
	
	if arg_4_1 < var_4_1 - var_4_3 then
		var_4_0 = 1 - math.min(0.7, var_4_1 - var_4_3 - arg_4_1)
	end
	
	if arg_4_1 > var_4_1 + var_4_4 + 1 then
		var_4_0 = 1 - (arg_4_1 - (var_4_1 + var_4_4 + 1))
	end
	
	local var_4_5 = math.abs(var_4_1 - arg_4_1)
	
	if var_4_5 > 3 then
		return arg_4_0.opts.zoom_scale, var_4_0
	end
	
	return math.max(arg_4_0.opts.zoom_scale, 1 - (1 - arg_4_0.opts.zoom_scale) * (var_4_5 / 3)), var_4_0
end

function Dock.getControl(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.controls[arg_5_1]
	
	if not var_5_0 and arg_5_2 then
		var_5_0 = arg_5_0.opts.handler:createControl(arg_5_0, arg_5_1)
		var_5_0.item = arg_5_1
		
		local var_5_1 = DOCK_DIR[arg_5_0.opts.dir]
		
		var_5_0:setAnchorPoint(var_5_1.ax, var_5_1.ay)
		
		if arg_5_0.opts.dir == "right" then
			var_5_0:setPositionX(arg_5_0.opts.width)
		elseif arg_5_0.opts.dir == "top" then
			var_5_0:setPositionY(arg_5_0.opts.height)
		end
		
		arg_5_0.panel:addChild(var_5_0)
		
		arg_5_0.controls[arg_5_1] = var_5_0
	end
	
	return var_5_0
end

function Dock.init(arg_6_0, arg_6_1, arg_6_2)
	arg_6_1 = arg_6_1 or {}
	arg_6_1.width = arg_6_1.width or 350
	arg_6_1.height = arg_6_1.height or 550
	arg_6_1.selected_item_pos = arg_6_1.selected_item_pos or 0.1
	arg_6_1.item_size = arg_6_1.item_size or 100
	arg_6_1.item_gap = arg_6_1.item_gap or 20
	arg_6_1.zoom_scale = arg_6_1.zoom_scale or var_0_0
	arg_6_1.scroll_ratio = arg_6_1.scroll_ratio or 1
	arg_6_1.collision_opts = arg_6_1.collision_opts or {}
	arg_6_0.items = {}
	arg_6_0.controls = {}
	arg_6_0.vars = {}
	arg_6_0.vars.garbages = {}
	arg_6_0.item_count = 0
	
	if DEBUG.HERO_DOCK then
		arg_6_0.wnd = cc.LayerColor:create(cc.c3b(100, 50, 50))
	else
		arg_6_0.wnd = cc.Layer:create()
	end
	
	arg_6_0.wnd:setContentSize(arg_6_1.width, arg_6_1.height)
	arg_6_0.wnd:ignoreAnchorPointForPosition(false)
	
	arg_6_0.panel = cc.Layer:create()
	
	arg_6_0.wnd:addChild(arg_6_0.panel)
	
	if arg_6_2 then
		arg_6_0.scroll = arg_6_2
		
		local var_6_0 = arg_6_2:getContentSize()
		
		arg_6_1.width = var_6_0.width
		arg_6_1.height = var_6_0.height
	else
		arg_6_0.scroll = ccui.ScrollView:create()
		
		arg_6_0.scroll:setContentSize(arg_6_1.width, arg_6_1.height)
		arg_6_0.scroll:setBounceEnabled(true)
		arg_6_0.scroll:setPosition(0, 0)
		arg_6_0.scroll:setAnchorPoint(0, 0)
		arg_6_0.wnd:addChild(arg_6_0.scroll)
	end
	
	arg_6_0.collision_opts = arg_6_1.collision_opts
	
	arg_6_0.scroll:addEventListener(dockEventHandler)
	
	arg_6_0.scroll.dock = arg_6_0
	
	arg_6_0:registerTouchHandler()
	
	arg_6_1.dir = arg_6_1.dir or "right"
	
	local var_6_1 = DOCK_DIR[arg_6_1.dir]
	
	arg_6_1.vertical = var_6_1.dir == 1
	
	arg_6_0.scroll:setDirection(var_6_1.dir)
	
	if arg_6_2 then
		arg_6_0.wnd:setAnchorPoint(arg_6_2:getAnchorPoint())
		arg_6_0.wnd:setPosition(arg_6_2:getPosition())
	else
		arg_6_0.wnd:setAnchorPoint(var_6_1.ax, var_6_1.ay)
		arg_6_0.wnd:setPosition(var_6_1.x, var_6_1.y)
	end
	
	if arg_6_1.vertical then
		arg_6_1.panel_size = arg_6_1.height
	else
		arg_6_1.panel_size = arg_6_1.width
	end
	
	arg_6_0.opts = arg_6_1
	
	arg_6_0:calcBasicInfos()
	Scheduler:add(arg_6_0.wnd, arg_6_0.update, arg_6_0)
end

function Dock.create(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {}
	
	copy_functions(Dock, var_7_0)
	var_7_0:init(arg_7_1, arg_7_2)
	
	return var_7_0
end

function Dock.getGarbages(arg_8_0)
	return arg_8_0.vars.garbages
end

function Dock._destroy(arg_9_0)
	if get_cocos_refid(arg_9_0.scroll) then
		arg_9_0.scroll:removeFromParent()
	end
	
	arg_9_0.scroll = nil
	
	if get_cocos_refid(arg_9_0.wnd) then
		arg_9_0.wnd:removeFromParent()
	end
	
	arg_9_0.wnd = nil
end

function Dock.destroy(arg_10_0)
	arg_10_0:_destroy()
end

function Dock.calcBasicInfos(arg_11_0, arg_11_1)
	arg_11_1 = arg_11_0.item_count == #arg_11_0.items
	arg_11_0.item_count = #arg_11_0.items
	arg_11_0.opts.display_count = math.floor(2.5 + (arg_11_0.opts.panel_size - arg_11_0.opts.item_size * 3) / arg_11_0.opts.item_gap)
	
	arg_11_0.scroll:setScrollStep(arg_11_0.opts.item_size / arg_11_0.opts.scroll_ratio)
	
	if not arg_11_1 then
		arg_11_0:updateInnerSize()
	end
	
	arg_11_0:updateScrollIndex()
end

function Dock.updateInnerSize(arg_12_0)
	arg_12_0.opts.inner_sz = {
		width = arg_12_0.opts.width,
		height = arg_12_0.opts.height
	}
	
	if arg_12_0.opts.vertical then
		arg_12_0.opts.inner_sz.height = arg_12_0.opts.item_size * (arg_12_0.item_count - 1) / arg_12_0.opts.scroll_ratio + arg_12_0.opts.height
	else
		arg_12_0.opts.inner_sz.width = arg_12_0.opts.item_size * (arg_12_0.item_count - 1) / arg_12_0.opts.scroll_ratio + arg_12_0.opts.width
	end
	
	arg_12_0.vars.skip_event = true
	
	arg_12_0.scroll:setInnerContainerSize(arg_12_0.opts.inner_sz)
	
	arg_12_0.vars.skip_event = nil
end

function Dock._setData(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0.vars.garbages = arg_13_2 or {}
	arg_13_0.items = table.shallow_clone(arg_13_1)
	
	arg_13_0:calcBasicInfos()
	
	if DEBUG.HERO_DOCK then
		local var_13_0 = cc.Sprite:create("story/bg/land_bg.jpg")
		local var_13_1 = var_13_0:getScale()
		
		var_13_0:setScale(arg_13_0.opts.inner_sz.width / var_13_0:getContentSize().width, arg_13_0.opts.inner_sz.height / var_13_0:getContentSize().height)
		var_13_0:setAnchorPoint(0, 0)
		var_13_0:setPosition(0, 0)
		arg_13_0.scroll:addChild(var_13_0)
	end
	
	arg_13_0.vars.initialized = true
end

function Dock.setData(arg_14_0, arg_14_1, arg_14_2)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.controls) do
		iter_14_1:setVisible(false)
	end
	
	arg_14_0:_setData(arg_14_1, arg_14_2)
end

function Dock.changeItemGap(arg_15_0, arg_15_1)
	arg_15_0.vars.item_gap_begin = arg_15_0.opts.item_gap
	arg_15_0.vars.item_gap_end = arg_15_1
	arg_15_0.vars.item_gap_begin_time = uitick()
end

function Dock.update(arg_16_0)
	if not arg_16_0.scroll then
		return 
	end
	
	if arg_16_0.scroll:getScrollPower() > 0 and arg_16_0.vars.power ~= arg_16_0.scroll:getScrollPower() then
		arg_16_0.vars.power = arg_16_0.scroll:getScrollPower()
	end
	
	if arg_16_0.vars.item_gap_end then
		local var_16_0 = uitick()
		
		if var_16_0 > arg_16_0.vars.item_gap_begin_time + 300 then
			arg_16_0.opts.item_gap = arg_16_0.vars.item_gap_end
			arg_16_0.vars.item_gap_end = nil
			arg_16_0.vars.item_gap_begin = nil
			arg_16_0.vars.item_gap_begin_time = nil
		else
			local var_16_1 = (var_16_0 - arg_16_0.vars.item_gap_begin_time) / 300
			local var_16_2 = math.log(1 + var_16_1 * 4, 5) / 1
			local var_16_3 = arg_16_0.vars.item_gap_begin + (arg_16_0.vars.item_gap_end - arg_16_0.vars.item_gap_begin) * var_16_2
			
			arg_16_0.opts.item_gap = var_16_3
		end
		
		arg_16_0:calcBasicInfos(true)
		arg_16_0:arrangeItems()
	end
end

function Dock.clearGarbageItems(arg_17_0)
	arg_17_0.vars.garbages = {}
end

function Dock.removeFromGarbage(arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.garbages) do
		if iter_18_1 == arg_18_1 then
			table.removeByValue(arg_18_0.vars.garbages, iter_18_1)
		end
	end
end

function Dock.revertGarbageItem(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.index
	
	if arg_19_1 == nil then
		table.join(arg_19_0.items, arg_19_0.vars.garbages)
		
		arg_19_0.vars.garbages = {}
	else
		for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.garbages) do
			if iter_19_1 == arg_19_1 then
				table.push(arg_19_0.items, iter_19_1)
				table.removeByValue(arg_19_0.vars.garbages, iter_19_1)
				
				break
			end
		end
	end
	
	if arg_19_0.vars.sort_func then
		arg_19_0.vars.sort_func()
	end
	
	arg_19_0:calcBasicInfos()
	
	if arg_19_0.opts.handler.onChangeCurrentItem then
		arg_19_0.opts.handler:onChangeCurrentItem(arg_19_0, arg_19_0.vars.cur_item, nil)
	end
	
	arg_19_0:jumpToIndex(var_19_0)
end

function Dock._removeItemOnExistIdx(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	if arg_20_0.vars.cur_item == arg_20_1 then
		arg_20_0.vars.cur_item = nil
	end
	
	table.remove(arg_20_0.items, arg_20_2)
	
	arg_20_0.item_count = arg_20_0.item_count - 1
	
	arg_20_0:updateInnerSize()
	arg_20_0:arrangeItems()
	arg_20_0:jumpToIndex(arg_20_3)
	
	if arg_20_4 then
		table.push(arg_20_0.vars.garbages, arg_20_1)
	end
end

function Dock._removeItemMulti(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_0.vars.cur_item == arg_21_1 then
		arg_21_0.vars.cur_item = nil
	end
	
	table.remove(arg_21_0.items, arg_21_2)
	
	arg_21_0.item_count = arg_21_0.item_count - 1
	
	if arg_21_3 then
		table.push(arg_21_0.vars.garbages, arg_21_1)
	end
end

function Dock.endRemoveSafely(arg_22_0)
	arg_22_0:updateInnerSize()
	arg_22_0:arrangeItems()
end

function Dock.removeItem(arg_23_0, arg_23_1, arg_23_2)
	arg_23_1 = arg_23_1 or arg_23_0.vars.cur_item
	
	local var_23_0 = arg_23_0.index
	local var_23_1 = arg_23_0.controls[arg_23_1]
	local var_23_2
	
	if var_23_1 then
		var_23_2 = var_23_1.idx
		arg_23_0.controls[arg_23_1] = nil
		
		arg_23_0:call_onControlPoolTiming(var_23_1)
		var_23_1:removeFromParent()
	end
	
	if not var_23_2 then
		for iter_23_0, iter_23_1 in pairs(arg_23_0.items) do
			if iter_23_1 == arg_23_1 then
				var_23_2 = iter_23_0
				
				break
			end
		end
	end
	
	if not var_23_2 then
		return 
	end
	
	arg_23_0:_removeItemOnExistIdx(arg_23_1, var_23_2, var_23_0, arg_23_2)
end

function Dock.removeSafely(arg_24_0, arg_24_1)
	arg_24_1 = arg_24_1 or arg_24_0.vars.cur_item
	
	local var_24_0
	local var_24_1 = arg_24_0.controls[arg_24_1]
	
	if var_24_1 then
		arg_24_0.controls[arg_24_1] = nil
		
		arg_24_0:call_onControlPoolTiming(var_24_1)
		var_24_1:removeFromParent()
	end
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.items) do
		if iter_24_1 == arg_24_1 then
			var_24_0 = iter_24_0
			
			break
		end
	end
	
	if not var_24_0 then
		return 
	end
	
	arg_24_0:_removeItemMulti(arg_24_1, var_24_0, true)
end

function Dock.removeItems(arg_25_0, arg_25_1, arg_25_2)
	if table.empty(arg_25_1) then
		return 
	end
	
	local var_25_0
	
	for iter_25_0, iter_25_1 in pairs(arg_25_1) do
		local var_25_1 = arg_25_0.controls[iter_25_1]
		
		if var_25_1 then
			arg_25_0.controls[iter_25_1] = nil
			
			arg_25_0:call_onControlPoolTiming(var_25_1)
			var_25_1:removeFromParent()
		end
		
		for iter_25_2, iter_25_3 in pairs(arg_25_0.items) do
			if iter_25_1 == iter_25_3 then
				if arg_25_0.vars.cur_item == iter_25_3 then
					arg_25_0.vars.cur_item = nil
				end
				
				table.remove(arg_25_0.items, iter_25_2)
			end
		end
		
		if arg_25_2 then
			table.push(arg_25_0.vars.garbages, iter_25_1)
		end
	end
	
	arg_25_0:calcBasicInfos()
	arg_25_0:arrangeItems()
end

function Dock.stopAutoScroll(arg_26_0)
	arg_26_0.scroll:stopAutoScroll()
end

function Dock.jumpToPercent(arg_27_0, arg_27_1)
	if arg_27_0.opts.vertical then
		arg_27_0.scroll:jumpToPercentVertical(arg_27_1)
	else
		arg_27_0.scroll:jumpToPercentHorizontal(arg_27_1)
	end
end

function Dock.scrollToPercent(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0.opts.vertical then
		arg_28_0.scroll:scrollToPercentVertical(arg_28_1, arg_28_2, true)
	else
		arg_28_0.scroll:scrollToPercentHorizontal(arg_28_1, arg_28_2, true)
	end
end

function Dock.onAfterSort(arg_29_0, arg_29_1)
	if arg_29_1 then
		arg_29_0:jumpToPercent(15)
		arg_29_0:scrollToPercent(0, 0.5)
	end
end

function Dock.call_onControlPoolTiming(arg_30_0, arg_30_1)
end

function Dock.call_setControlScaleByAdjustPos(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_0.opts.handler:onSetControlScale(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
end

function Dock.call_onSetControlScale(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0.opts.handler:onSetControlScale(arg_32_0, arg_32_1, arg_32_2, 0)
end

function Dock.call_onShowHandler(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.opts.handler.onShowItem(arg_33_0.opts.handler, arg_33_1, arg_33_2)
end

function Dock._arrangeItemsOnHaveScale(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6, arg_34_7, arg_34_8, arg_34_9)
	arg_34_1.idx = arg_34_3
	
	if not arg_34_1:isVisible() then
		arg_34_1:setVisible(true)
		
		if arg_34_0.opts.handler.onShowItem then
			arg_34_0:call_onShowHandler(arg_34_1, arg_34_2)
		end
	end
	
	local var_34_0 = arg_34_1:getScaleX()
	
	if var_34_0 ~= arg_34_4 then
		arg_34_1:setScaleX(arg_34_4)
		arg_34_1:setScaleY(arg_34_4)
	end
	
	local var_34_1 = arg_34_0.opts.item_gap
	local var_34_2 = arg_34_0.item_count - arg_34_3
	
	if arg_34_4 > arg_34_0.opts.zoom_scale then
		var_34_2 = var_34_2 + arg_34_4 * 100
	end
	
	arg_34_1:setLocalZOrder(var_34_2)
	
	if arg_34_8 < var_34_2 then
		arg_34_8 = var_34_2
		arg_34_9 = arg_34_2
		arg_34_0.index = arg_34_3
	end
	
	if arg_34_4 > arg_34_0.opts.zoom_scale then
		var_34_1 = arg_34_0.opts.item_gap + (arg_34_0.opts.item_size - arg_34_0.opts.item_gap * 1.5) * ((arg_34_4 - arg_34_0.opts.zoom_scale) / (1 - arg_34_0.opts.zoom_scale))
		
		if var_34_0 ~= arg_34_4 and arg_34_0.opts.handler.onSetControlScale then
			local var_34_3 = (arg_34_4 - arg_34_0.opts.zoom_scale) / (1 - arg_34_0.opts.zoom_scale)
			
			arg_34_0:call_setControlScaleByAdjustPos(arg_34_2, arg_34_1, var_34_3)
		end
	elseif var_34_0 ~= arg_34_4 and arg_34_0.opts.handler.onSetControlScale then
		arg_34_0:call_onSetControlScale(arg_34_2, arg_34_1)
	end
	
	if arg_34_0.opts.vertical then
		arg_34_1:setPositionY(arg_34_6)
	else
		arg_34_1:setPositionX(arg_34_6)
	end
	
	arg_34_6 = arg_34_6 + var_34_1
	
	if arg_34_3 > arg_34_0.f_index then
		arg_34_7 = arg_34_7 - var_34_1
	elseif arg_34_0.f_index - arg_34_3 < 1 then
		arg_34_7 = arg_34_7 - var_34_1 * (1 - (arg_34_0.f_index - arg_34_3))
	end
	
	arg_34_1:setOpacity(255 * arg_34_5)
	
	return arg_34_6, arg_34_7, arg_34_8, arg_34_9
end

function Dock._arrangeItemsOnElse(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	if arg_35_1 then
		arg_35_1:setVisible(false)
	end
	
	arg_35_3 = arg_35_3 + arg_35_0.opts.item_gap
	
	if arg_35_2 >= arg_35_0.f_index then
		arg_35_4 = arg_35_4 - arg_35_0.opts.item_gap
	end
	
	return arg_35_3, arg_35_4
end

function Dock._arrangeItemsOnFinish(arg_36_0, arg_36_1, arg_36_2)
	arg_36_2 = arg_36_2 + arg_36_0.opts.panel_size * (1 - arg_36_0.opts.selected_item_pos)
	
	if arg_36_0.opts.vertical then
		arg_36_0.panel:setPositionY(arg_36_2)
	else
		arg_36_0.panel:setPositionX(arg_36_2)
	end
	
	if arg_36_1 and arg_36_0.vars.cur_item ~= arg_36_1 then
		if arg_36_0.opts.handler.onChangeCurrentItem then
			arg_36_0.opts.handler:onChangeCurrentItem(arg_36_0, arg_36_1, arg_36_0.vars.cur_item)
		end
		
		arg_36_0.vars.cur_item = arg_36_1
	end
	
	if arg_36_1 and arg_36_0.vars.cur_item == arg_36_1 and arg_36_0.opts.handler.onHighestItemUpdate then
		arg_36_0.opts.handler:onHighestItemUpdate(arg_36_0, arg_36_1)
	end
end

function Dock.arrangeItems(arg_37_0)
	if not arg_37_0.item_count then
		return 
	end
	
	arg_37_0:updateScrollIndex()
	
	local var_37_0 = 0
	local var_37_1 = 0
	local var_37_2 = -1
	local var_37_3
	
	for iter_37_0 = arg_37_0.item_count, 1, -1 do
		local var_37_4 = arg_37_0.items[iter_37_0]
		local var_37_5, var_37_6 = arg_37_0:getControlInfo(iter_37_0)
		local var_37_7 = arg_37_0:getControl(var_37_4, var_37_5 ~= nil)
		
		if var_37_5 then
			var_37_0, var_37_1, var_37_2, var_37_3 = arg_37_0:_arrangeItemsOnHaveScale(var_37_7, var_37_4, iter_37_0, var_37_5, var_37_6, var_37_0, var_37_1, var_37_2, var_37_3)
		else
			arg_37_0:call_onControlPoolTiming(var_37_7)
			
			var_37_0, var_37_1 = arg_37_0:_arrangeItemsOnElse(var_37_7, iter_37_0, var_37_0, var_37_1)
		end
	end
	
	arg_37_0:_arrangeItemsOnFinish(var_37_3, var_37_1)
end

function Dock.getItems(arg_38_0)
	return arg_38_0.items
end

function Dock.getItemCount(arg_39_0)
	return arg_39_0.item_count
end

function Dock.getCurrentItem(arg_40_0)
	return arg_40_0.vars.cur_item
end

function Dock.clearCurrentItem(arg_41_0)
	arg_41_0.vars.cur_item = nil
end

function Dock.getCurrentControl(arg_42_0)
	if arg_42_0.vars.cur_item then
		return arg_42_0:getControl(arg_42_0.vars.cur_item)
	end
end

function Dock.registerTouchHandler(arg_43_0)
	local function var_43_0(arg_44_0, arg_44_1)
		if UIAction:Find("block") or NetWaiting:isWaiting() then
			return false
		end
		
		return arg_43_0.onTouchBegin(arg_43_0, arg_44_0, arg_44_1)
	end
	
	local function var_43_1(arg_45_0, arg_45_1)
		if UIAction:Find("block") or NetWaiting:isWaiting() then
			arg_43_0.touched = false
			
			return false
		end
		
		return arg_43_0.onTouchEnd(arg_43_0, arg_45_0, arg_45_1)
	end
	
	arg_43_0.scroll:setSwallowTouches(false)
	
	local var_43_2 = arg_43_0.wnd:getEventDispatcher()
	
	arg_43_0.listener = cc.EventListenerTouchOneByOne:create()
	
	arg_43_0.listener:registerScriptHandler(var_43_0, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_43_0.listener:registerScriptHandler(var_43_1, cc.Handler.EVENT_TOUCH_ENDED)
	var_43_2:addEventListenerWithSceneGraphPriority(arg_43_0.listener, arg_43_0.wnd)
end

function Dock.isScrolling(arg_46_0)
	return arg_46_0.scroll_event_tick and uitick() - arg_46_0.scroll_event_tick < 60
end

function Dock.onTouchBegin(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_1:getLocation()
	
	if not checkCollisionDynamic(arg_47_0.scroll, var_47_0.x, var_47_0.y, arg_47_0.collision_opts) then
		arg_47_0.scrollview_touch_x = nil
		arg_47_0.scrollview_touch_y = nil
		
		return false
	end
	
	if arg_47_0:isScrolling() and arg_47_0.scroll:getScrollPower() > 20 then
		return false
	end
	
	arg_47_0.touched = true
	arg_47_0.scrollview_dragging = nil
	arg_47_0.scrollview_touch_x = var_47_0.x
	arg_47_0.scrollview_touch_y = var_47_0.y
	arg_47_0.scrollview_touch_tick = systick()
	
	return true
end

function Dock.getTouchedItem(arg_48_0, arg_48_1, arg_48_2)
	if not checkCollision(arg_48_0.scroll, arg_48_1, arg_48_2) or arg_48_0.scrollview_touch_x == nil then
		return false
	end
	
	if math.abs(arg_48_0.scrollview_touch_x - arg_48_1) > DESIGN_HEIGHT * 0.02 or math.abs(arg_48_0.scrollview_touch_y - arg_48_2) > DESIGN_HEIGHT * 0.02 then
		return false
	end
	
	local var_48_0
	local var_48_1
	local var_48_2 = -1
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.controls or {}) do
		if iter_48_1:isVisible() then
			local var_48_3 = iter_48_1:getLocalZOrder()
			
			if get_cocos_refid(iter_48_1) and checkCollision(iter_48_1, arg_48_1, arg_48_2) and var_48_2 < var_48_3 then
				var_48_2 = var_48_3
				
				local var_48_4 = iter_48_0
				
				var_48_1 = iter_48_1
			end
		end
	end
	
	if not var_48_1 then
		return false
	end
	
	return var_48_1.item, var_48_1
end

function Dock.onTouchEnd(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_1:getLocation()
	
	if not arg_49_0.touched then
		return true
	end
	
	arg_49_0.touched = false
	
	if arg_49_0.scrollview_touch_tick and systick() - arg_49_0.scrollview_touch_tick > 200 then
		return false
	end
	
	arg_49_0.scrollview_touch_tick = nil
	
	local var_49_1, var_49_2 = arg_49_0:getTouchedItem(var_49_0.x, var_49_0.y)
	
	if not var_49_1 then
		return false
	end
	
	if not TutorialGuide:isAllowEvent(var_49_2) then
		return false
	end
	
	arg_49_0:onSelectItem(var_49_1, var_49_2)
	
	return false
end

function Dock.scrollToIndex(arg_50_0, arg_50_1, arg_50_2)
	if arg_50_2 == nil then
		arg_50_2 = math.abs(arg_50_0.f_index - arg_50_1) / arg_50_0.item_count * 1 + 0.2
	end
	
	local var_50_0 = 100 * ((arg_50_1 - 1) / (arg_50_0.item_count - 1))
	
	arg_50_0:scrollToPercent(var_50_0, arg_50_2, true)
end

function Dock.jumpToIndex(arg_51_0, arg_51_1)
	arg_51_1 = arg_51_1 or 1
	
	local var_51_0 = 100 * ((arg_51_1 - 1) / (arg_51_0.item_count - 1))
	
	arg_51_0:jumpToPercent(var_51_0)
end

function Dock.onSelectItem(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_2.idx
	
	arg_52_0:scrollToIndex(var_52_0)
	
	if arg_52_0.opts.handler.onSelectItem then
		arg_52_0.opts.handler:onSelectItem(arg_52_0, arg_52_1, arg_52_0.vars.cur_item == arg_52_1)
	end
	
	if arg_52_0.vars.cur_item ~= arg_52_1 then
		arg_52_0.vars.selected_item = arg_52_1
	end
end

function Dock.jumpToItem(arg_53_0, arg_53_1)
	arg_53_0:scrollToItem(arg_53_1, 0)
end

function Dock.scrollToItem(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0
	
	for iter_54_0, iter_54_1 in pairs(arg_54_0.items) do
		if iter_54_1 == arg_54_1 then
			var_54_0 = iter_54_0
			
			break
		end
	end
	
	if var_54_0 then
		if arg_54_2 == 0 then
			arg_54_0:jumpToIndex(var_54_0, arg_54_2)
		else
			arg_54_0:scrollToIndex(var_54_0, arg_54_2)
		end
	end
end

function Dock.isPushed(arg_55_0)
	return arg_55_0.touched
end

function Dock.setTouchEnabled(arg_56_0, arg_56_1)
	arg_56_0:setScrollEnabled(arg_56_1)
	
	if arg_56_0.wnd then
		if arg_56_1 then
			cc.Director:getInstance():getEventDispatcher():resumeEventListenersForTarget(arg_56_0.wnd)
		else
			cc.Director:getInstance():getEventDispatcher():pauseEventListenersForTarget(arg_56_0.wnd)
		end
	end
end

function Dock.setScrollEnabled(arg_57_0, arg_57_1)
	if arg_57_0.scroll then
		if arg_57_1 then
			cc.Director:getInstance():getEventDispatcher():resumeEventListenersForTarget(arg_57_0.scroll)
		else
			cc.Director:getInstance():getEventDispatcher():pauseEventListenersForTarget(arg_57_0.scroll)
		end
	end
end
