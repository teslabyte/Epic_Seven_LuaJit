ScrollView = {}

local var_0_0 = DESIGN_WIDTH / 1920

function ScrollView.defaultScrollViewEventHandler(arg_1_0, arg_1_1)
	if arg_1_0._onScroll then
		arg_1_0._onScroll(arg_1_0._Self, arg_1_0, arg_1_1)
	end
end

function ScrollView.initScrollView(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_4 = arg_2_4 or {}
	arg_2_0.scrollview = arg_2_1
	
	arg_2_0.scrollview:removeAllChildren()
	
	arg_2_0.scrollview_opts = arg_2_4
	arg_2_0.cache = {}
	arg_2_0.ScrollViewItems = {}
	
	arg_2_0:registerTouchHandler()
	arg_2_0.scrollview:setCascadeOpacityEnabled(true)
	
	arg_2_0.fit_height = arg_2_4.fit_height
	arg_2_0.item_width = arg_2_2 or 295
	arg_2_0.item_height = arg_2_3 or 400
	
	if arg_2_0.scrollview.STRETCH_INFO then
		arg_2_0.before_width = arg_2_0.item_width
		arg_2_0.item_width = arg_2_0.item_width * arg_2_0.scrollview.STRETCH_INFO.stretch_ratio
		
		function arg_2_0.scrollview.scene_reload_callback()
			arg_2_0.item_width = arg_2_0.before_width * arg_2_0.scrollview.STRETCH_INFO.stretch_ratio
			
			arg_2_0:createScrollViewItems(arg_2_0.items or {})
			
			local var_3_0 = arg_2_0.scrollview:getContentSize()
			
			arg_2_0:setSize(var_3_0.width, var_3_0.height)
		end
	end
	
	local var_2_0 = arg_2_1:getContentSize()
	
	arg_2_0:setSize(var_2_0.width, var_2_0.height)
	
	arg_2_0.IsForceHorizontal = arg_2_4.force_horizontal
end

function ScrollView.registerTouchHandler(arg_4_0)
	local var_4_0 = arg_4_0.scrollview:getEventDispatcher()
	
	local function var_4_1(arg_5_0, arg_5_1)
		if UIAction:Find("block") then
			return false
		end
		
		return arg_4_0.onScrollViewTouchBegin(arg_4_0, arg_5_0, arg_5_1)
	end
	
	local function var_4_2(arg_6_0, arg_6_1)
		if UIAction:Find("block") then
			return false
		end
		
		return arg_4_0.onScrollViewTouchEnd(arg_4_0, arg_6_0, arg_6_1)
	end
	
	local function var_4_3(arg_7_0, arg_7_1)
		if UIAction:Find("block") then
			return false
		end
		
		return arg_4_0.onScrollViewTouchMove(arg_4_0, arg_7_0, arg_7_1)
	end
	
	arg_4_0.scrollview:setSwallowTouches(false)
	var_4_0:removeEventListener(arg_4_0.listener)
	
	arg_4_0.listener = cc.EventListenerTouchOneByOne:create()
	
	arg_4_0.listener:registerScriptHandler(var_4_1, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_4_0.listener:registerScriptHandler(var_4_3, cc.Handler.EVENT_TOUCH_MOVED)
	arg_4_0.listener:registerScriptHandler(var_4_2, cc.Handler.EVENT_TOUCH_ENDED)
	var_4_0:addEventListenerWithSceneGraphPriority(arg_4_0.listener, arg_4_0.scrollview)
	
	if arg_4_0.scrollview_opts and arg_4_0.scrollview_opts.onScroll then
		arg_4_0.scrollview._Self = arg_4_0
		arg_4_0.scrollview._onScroll = arg_4_0.scrollview_opts.onScroll
		
		arg_4_0.scrollview:addEventListener(arg_4_0.defaultScrollViewEventHandler)
	end
end

function ScrollView.setScrollViewItemHeight(arg_8_0, arg_8_1)
	arg_8_0.item_height = arg_8_1
end

function ScrollView.setSize(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_0.scrollview:setContentSize(arg_9_1, arg_9_2)
	
	arg_9_0.COL = math.max(1, math.floor(arg_9_1 / arg_9_0.item_width + 0.001))
	arg_9_0.ROW = math.max(1, arg_9_2 / arg_9_0.item_height)
	
	if arg_9_3 then
		arg_9_0:arrangeScrollViewItems(arg_9_4)
	end
end

function ScrollView.checkCollision(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_1 < arg_10_3.x or arg_10_2 < arg_10_3.y or arg_10_1 >= arg_10_3.x + arg_10_3.width or arg_10_2 >= arg_10_3.y + arg_10_3.height then
		return false
	end
	
	return true
end

function ScrollView.onScrollViewTouchBegin(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.touched then
		return true
	end
	
	local var_11_0 = arg_11_1:getLocation()
	
	if not checkCollision(arg_11_0.scrollview, var_11_0.x, var_11_0.y) then
		arg_11_0.scrollview_touch_x = nil
		arg_11_0.scrollview_touch_y = nil
		
		return false
	end
	
	arg_11_0.touched = true
	arg_11_0.scrollview_tooltip = nil
	arg_11_0.scrollview_dragging = nil
	arg_11_0.scrollview_touch_x = var_11_0.x
	arg_11_0.scrollview_touch_y = var_11_0.y
	arg_11_0.scrollview_touch_tick = systick()
	
	Scheduler:add(arg_11_0.scrollview, arg_11_0.onScrollViewUpdate, arg_11_0)
	
	if arg_11_0.onScrollViewTouchDown then
		local var_11_1
		
		for iter_11_0, iter_11_1 in pairs(arg_11_0.ScrollViewItems or {}) do
			if iter_11_1.control and get_cocos_refid(iter_11_1.control) and checkCollision(iter_11_1.control, var_11_0.x, var_11_0.y, iter_11_1.control.collision_opts) then
				var_11_1 = iter_11_0
			end
		end
		
		arg_11_0:onScrollViewTouchDown(arg_11_1, arg_11_2, var_11_1)
	end
	
	return true
end

function ScrollView.onScrollViewUpdate(arg_12_0)
	if arg_12_0.scrollview_dragging then
		return 
	end
	
	if not arg_12_0.scrollview_touch_tick then
		return 
	end
	
	if systick() - arg_12_0.scrollview_touch_tick > 300 and arg_12_0.scrollview_touch_x then
		Scheduler:remove(arg_12_0.onScrollViewUpdate)
		
		local var_12_0 = arg_12_0.scrollview_touch_x
		local var_12_1 = arg_12_0.scrollview_touch_y
		local var_12_2, var_12_3 = arg_12_0:getTouchedItem(var_12_0, var_12_1)
		
		if not var_12_2 then
			return 
		end
		
		if arg_12_0.onInfoScrollViewItem then
			arg_12_0.scrollview_tooltip = true
			
			arg_12_0:onInfoScrollViewItem(var_12_2, var_12_3)
		end
	end
end

function ScrollView.onScrollViewTouchMove(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1:getLocation()
	local var_13_1 = var_13_0.x / var_0_0
	local var_13_2 = var_13_0.y / var_0_0
	
	if not arg_13_0.scrollview_dragging and arg_13_0.scrollview_touch_x and (math.abs(arg_13_0.scrollview_touch_x - var_13_1) > DESIGN_HEIGHT * 0.01 or math.abs(arg_13_0.scrollview_touch_y - var_13_2) > DESIGN_HEIGHT * 0.01) then
		arg_13_0.scrollview_dragging = true
		
		Scheduler:remove(arg_13_0.onScrollViewUpdate)
		
		if arg_13_0.scrollview_tooltip then
			arg_13_0:onInfoScrollViewItem(nil)
			
			arg_13_0.scrollview_tooltip = nil
		end
	end
	
	if arg_13_0.onScrollViewTouchMoveEvent then
		arg_13_0:onScrollViewTouchMoveEvent(arg_13_1, arg_13_2)
	end
end

function ScrollView.getScrollViewControl(arg_14_0, arg_14_1)
	return arg_14_0.cache[arg_14_1]
end

function ScrollView.getTouchedItem(arg_15_0, arg_15_1, arg_15_2)
	if not checkCollision(arg_15_0.scrollview, arg_15_1, arg_15_2) or arg_15_0.scrollview_touch_x == nil then
		return false
	end
	
	if math.abs(arg_15_0.scrollview_touch_x - arg_15_1) > DESIGN_HEIGHT * 0.02 or math.abs(arg_15_0.scrollview_touch_y - arg_15_2) > DESIGN_HEIGHT * 0.02 then
		return false
	end
	
	local var_15_0, var_15_1 = arg_15_0.scrollview:getInnerContainer():getPosition()
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.ScrollViewItems or {}) do
		if iter_15_1.control and get_cocos_refid(iter_15_1.control) and checkCollision(iter_15_1.control, arg_15_1, arg_15_2, iter_15_1.control.collision_opts) then
			local var_15_2
			local var_15_3 = iter_15_1.control:getChildren()
			
			for iter_15_2 = #var_15_3, 1, -1 do
				if checkCollision(var_15_3[iter_15_2], arg_15_1, arg_15_2) then
					var_15_2 = var_15_3[iter_15_2]:getName()
					
					break
				end
			end
			
			return iter_15_0, iter_15_1, var_15_2
		end
	end
	
	return false
end

function ScrollView.clearScrollViewItems(arg_16_0)
	arg_16_0.scrollview:removeAllChildren()
	
	arg_16_0.cache = {}
	arg_16_0.ScrollViewItems = {}
end

function ScrollView.removeScrollViewItemAt(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0.ScrollViewItems and arg_17_0.ScrollViewItems[arg_17_1] and arg_17_0.ScrollViewItems[arg_17_1].control then
		if arg_17_2 then
			arg_17_0.ScrollViewItems[arg_17_1].control:removeFromParent()
			
			arg_17_0.cache[arg_17_0.ScrollViewItems[arg_17_1].item] = nil
		else
			arg_17_0.ScrollViewItems[arg_17_1].control:setVisible(false)
		end
	end
	
	table.remove(arg_17_0.ScrollViewItems, arg_17_1)
	arg_17_0:arrangeScrollViewItems(nil, nil, true)
end

function ScrollView.addScrollViewItem(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:_getScrollViewItem(arg_18_1)
	
	if var_18_0 then
		table.insert(arg_18_0.ScrollViewItems, {
			item = arg_18_1,
			control = var_18_0
		})
	end
	
	arg_18_0:arrangeScrollViewItems(nil, nil, true)
end

function ScrollView.onScrollViewTouchEnd(arg_19_0, arg_19_1, arg_19_2)
	Scheduler:remove(arg_19_0.onScrollViewUpdate)
	
	if not arg_19_0.touched then
		return true
	end
	
	arg_19_0.touched = false
	
	local var_19_0 = arg_19_1:getLocation()
	local var_19_1 = arg_19_0.scrollview
	
	while var_19_1 do
		if not var_19_1:isVisible() then
			return 
		end
		
		var_19_1 = var_19_1:getParent()
	end
	
	if arg_19_0.onScrollViewTouchUp and TutorialGuide:isAllowEvent() then
		arg_19_0:onScrollViewTouchUp(arg_19_1, arg_19_2)
	end
	
	local var_19_2, var_19_3, var_19_4 = arg_19_0:getTouchedItem(var_19_0.x, var_19_0.y)
	
	if not var_19_2 then
		return false
	end
	
	SoundEngine:play("event:/ui/btn_ok")
	
	if not UIAction:Find("block") and arg_19_0.onSelectScrollViewItem and not NetWaiting:isWaiting() then
		set_high_fps_tick()
		
		if TutorialGuide:isAllowEvent(var_19_3.control) then
			arg_19_0:onSelectScrollViewItem(var_19_2, var_19_3, var_19_4)
		end
	end
	
	arg_19_0.scrollview_touch_tick = nil
	
	return true
end

function ScrollView.removeScrollViewItem(arg_20_0, arg_20_1, arg_20_2)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.ScrollViewItems) do
		if iter_20_1.item == arg_20_1 then
			return arg_20_0:removeScrollViewItemAt(iter_20_0, arg_20_2)
		end
	end
end

function ScrollView._getScrollViewItem(arg_21_0, arg_21_1)
	if arg_21_0.cache[arg_21_1] then
		arg_21_0.cache[arg_21_1]:setVisible(true)
		
		return arg_21_0.cache[arg_21_1]
	end
	
	local var_21_0 = arg_21_0:getScrollViewItem(arg_21_1)
	
	if not get_cocos_refid(var_21_0) then
		return 
	end
	
	if arg_21_0.fit_height then
		arg_21_0.item_height = var_21_0:getContentSize().height
		arg_21_0.fit_height = nil
	end
	
	arg_21_0.scrollview_stretch_ratio = 1
	
	if arg_21_0.scrollview.STRETCH_INFO and arg_21_0.COL == 1 then
		local var_21_1 = var_21_0:getContentSize()
		local var_21_2 = var_21_1.width * arg_21_0.scrollview.STRETCH_INFO.stretch_ratio
		
		resetControlPosAndSize(var_21_0, var_21_2, var_21_1.width, true)
		
		var_21_0.collision_opts = {
			add_width = var_21_2 - var_21_1.width,
			add_x = (var_21_1.width - var_21_2) / 2
		}
	end
	
	arg_21_0.cache[arg_21_1] = var_21_0
	
	if not arg_21_0.scrollview_opts.skip_anchor then
		var_21_0:setAnchorPoint(0.5, 0.5)
	end
	
	arg_21_0.scrollview:addChild(var_21_0)
	
	return var_21_0
end

function ScrollView.getInnerSizeAndPos(arg_22_0)
	local var_22_0 = arg_22_0.scrollview:getInnerContainerPosition()
	local var_22_1 = arg_22_0.scrollview:getInnerContainerSize()
	
	return var_22_0, var_22_1
end

function ScrollView.setRatioVertical(arg_23_0, arg_23_1)
	local var_23_0, var_23_1 = arg_23_0:getInnerSizeAndPos()
	
	var_23_0.y = var_23_1.height * arg_23_1
	
	arg_23_0.scrollview:forceDoLayout()
	arg_23_0.scrollview:setInnerContainerPosition(var_23_0)
end

function ScrollView.setPositionVertical(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0.scrollview:forceDoLayout()
	
	local var_24_0 = arg_24_0.scrollview:getContentSize().height - arg_24_0.scrollview:getInnerContainerSize().height
	
	arg_24_1.y = arg_24_1.y + arg_24_2
	arg_24_1.y = math.max(arg_24_1.y, var_24_0)
	arg_24_1.y = math.min(arg_24_1.y, 0)
	
	arg_24_0.scrollview:setInnerContainerPosition(arg_24_1)
end

function ScrollView.createScrollViewItemsKeepPosition(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0
	local var_25_1
	local var_25_2
	local var_25_3
	
	if not arg_25_0.IsForceHorizontal then
		var_25_0 = false
		var_25_2, var_25_3 = arg_25_0:getInnerSizeAndPos()
		
		if var_25_3.height < 1 then
			var_25_3.height = 1
			var_25_0 = true
		end
		
		local var_25_4 = var_25_2.y / var_25_3.height
	end
	
	arg_25_0:clearScrollViewItems()
	arg_25_0:_createScrollViewItems(arg_25_1, arg_25_2)
	
	if not arg_25_0.IsForceHorizontal then
		if var_25_0 then
			arg_25_0.scrollview:jumpToTop()
		else
			local var_25_5, var_25_6 = arg_25_0:getInnerSizeAndPos()
			local var_25_7 = var_25_3.height - var_25_6.height
			
			arg_25_0:setPositionVertical(var_25_2, var_25_7)
			arg_25_0.scrollview:forceDoLayout()
		end
	end
end

function ScrollView.removeWithKeepPos(arg_26_0, arg_26_1)
	local var_26_0, var_26_1 = arg_26_0:getInnerSizeAndPos()
	
	arg_26_0.scrollview:removeChild(arg_26_0.ScrollViewItems[arg_26_1].control)
	table.remove(arg_26_0.ScrollViewItems, arg_26_1)
	arg_26_0:arrangeScrollViewItems(nil, nil)
	
	local var_26_2, var_26_3 = arg_26_0:getInnerSizeAndPos()
	local var_26_4 = var_26_1.height - var_26_3.height
	
	arg_26_0:setPositionVertical(var_26_0, var_26_4)
	arg_26_0.scrollview:forceDoLayout()
end

function ScrollView.createScrollViewItems(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if arg_27_3 then
		arg_27_0:createScrollViewItemsKeepPosition(arg_27_1, arg_27_2)
	else
		arg_27_0:clearScrollViewItems()
		arg_27_0:_createScrollViewItems(arg_27_1, arg_27_2)
	end
end

function ScrollView.updateScrollViewItems(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	for iter_28_0, iter_28_1 in pairs(arg_28_0.ScrollViewItems) do
		if iter_28_1.control then
			iter_28_1.control:setVisible(false)
		end
	end
	
	arg_28_0:_createScrollViewItems(arg_28_1, arg_28_2, arg_28_3)
end

function ScrollView._createScrollViewItems(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	arg_29_0.items = arg_29_1
	arg_29_0.ScrollViewItems = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		local var_29_0 = arg_29_0:_getScrollViewItem(iter_29_1)
		
		if var_29_0 then
			table.insert(arg_29_0.ScrollViewItems, {
				item = iter_29_1,
				control = var_29_0
			})
		end
	end
	
	arg_29_0.ScrollViewEmptyMessage = arg_29_2
	
	arg_29_0:arrangeScrollViewItems(false, false, arg_29_3)
end

function ScrollView.setScrollViewItems(arg_30_0, arg_30_1, arg_30_2)
	for iter_30_0 = #arg_30_0.ScrollViewItems, 1, -1 do
		local var_30_0 = arg_30_0.ScrollViewItems[iter_30_0]
		
		if not table.find(arg_30_1, var_30_0.item) and get_cocos_refid(var_30_0.control) then
			var_30_0.control:setVisible(false)
		end
	end
	
	return arg_30_0:updateScrollViewItems(arg_30_1, arg_30_2)
end

function ScrollView.insertFrontScrollViewItems(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_0.ScrollViewItems = arg_31_0.ScrollViewItems or {}
	
	local var_31_0 = arg_31_0:getScrollViewItem(arg_31_1)
	
	if get_cocos_refid(var_31_0) then
		var_31_0:setAnchorPoint(0, 0)
		arg_31_0.scrollview:addChild(var_31_0)
		table.insert(arg_31_0.ScrollViewItems, 1, {
			item = arg_31_1,
			control = var_31_0
		})
	end
	
	arg_31_0.ScrollViewEmptyMessage = text
	
	arg_31_0:arrangeScrollViewItems(arg_31_2, arg_31_3, true)
end

function ScrollView.arrangeScrollViewItems(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_0.ROW == 1 then
		arg_32_0.COL = #arg_32_0.ScrollViewItems
		arg_32_0.cols = arg_32_0.COL
		arg_32_0.rows = 1
	elseif not arg_32_0.IsForceHorizontal then
		arg_32_0.rows = math.floor(#arg_32_0.ScrollViewItems / arg_32_0.COL)
		
		if #arg_32_0.ScrollViewItems % arg_32_0.COL ~= 0 then
			arg_32_0.rows = arg_32_0.rows + 1
		end
		
		arg_32_0.rows = math.max(arg_32_0.ROW, arg_32_0.rows)
		arg_32_0.cols = arg_32_0.COL
	else
		arg_32_0.rows = math.max(arg_32_0.ROW, 1)
		arg_32_0.cols = #arg_32_0.ScrollViewItems
	end
	
	local var_32_0 = arg_32_0.scrollview:getInnerContainerPosition()
	local var_32_1 = {
		width = arg_32_0.item_width * arg_32_0.cols,
		height = arg_32_0.item_height * arg_32_0.rows
	}
	
	arg_32_0.scrollview:setInnerContainerSize(var_32_1)
	
	local var_32_2 = arg_32_0.item_width / 2
	local var_32_3 = arg_32_0.item_height / 2
	
	if arg_32_3 then
		arg_32_0.scrollview:setInnerContainerPosition(var_32_0)
	else
		arg_32_0.scrollview:scrollToTop(0, false)
	end
	
	local var_32_4 = {}
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.ScrollViewItems) do
		local var_32_5 = iter_32_1.control
		
		if var_32_5 then
			local var_32_6 = (iter_32_0 - 1) % arg_32_0.cols
			local var_32_7 = math.floor((iter_32_0 - 1) / arg_32_0.cols)
			local var_32_8, var_32_9 = arg_32_0:getScrollViewItemPosition(var_32_6, var_32_7)
			
			if arg_32_1 then
				if arg_32_2 then
					local var_32_10
					
					if arg_32_2.tail then
						var_32_10 = #arg_32_0.ScrollViewItems
					else
						var_32_10 = 1
					end
					
					if type(arg_32_2) ~= "table" then
						arg_32_2 = {}
					end
					
					if iter_32_0 == var_32_10 then
						local var_32_11 = {}
						
						if arg_32_2.insert_type == "top" then
							var_32_5:setPositionX(var_32_8)
						elseif arg_32_2.insert_type == "bot" then
							var_32_5:setPositionX(var_32_8)
							var_32_5:setPositionY(-var_32_5:getContentSize().height * 2)
						elseif arg_32_2.insert_type == "left" then
							var_32_5:setPositionY(var_32_9)
							var_32_5:setPositionX(-var_32_5:getContentSize().width)
						elseif arg_32_2.insert_type == "right" then
							var_32_5:setPositionY(var_32_9)
							var_32_5:setPositionX(var_32_5:getContentSize().width)
						elseif arg_32_2.insert_type == "center" then
							var_32_5:setPositionX(var_32_8)
							var_32_5:setPositionY(var_32_9)
							var_32_5:setOpacity(0)
							table.insert(var_32_11, OPACITY(265, 0, 1))
						end
						
						if arg_32_2.effect and type(arg_32_2.effect) == "function" then
							local var_32_12 = arg_32_0.scrollview:getPositionX() + var_32_8
							local var_32_13 = arg_32_0.scrollview:getPositionY() + var_32_9
							local var_32_14 = arg_32_0.scrollview:getParent()
							
							arg_32_2.effect(var_32_14, var_32_12, var_32_13)
						end
						
						table.insert(var_32_11, LOG(MOVE_TO(200, var_32_8, var_32_9), 300))
						UIAction:Add(SEQ(table.unpack(var_32_11)), var_32_5, "block")
					else
						local var_32_15 = TARGET(var_32_5, LOG(MOVE_TO(200, var_32_8, var_32_9), 300))
						
						table.insert(var_32_4, var_32_15)
					end
				else
					UIAction:Add(LOG(MOVE_TO(200, var_32_8, var_32_9), 300), var_32_5, "block")
				end
			elseif type(iter_32_1.item) == "table" then
				if iter_32_1.item.node ~= nil then
					var_32_5:setPosition(var_32_8, var_32_9 + 6)
				else
					var_32_5:setPosition(var_32_8, var_32_9)
				end
			else
				var_32_5:setPosition(var_32_8, var_32_9)
			end
		end
	end
	
	if arg_32_1 then
	end
	
	if #var_32_4 > 0 then
		UIAction:Add(SPAWN(table.unpack(var_32_4)), arg_32_0.scrollview, "block")
	end
	
	local var_32_16 = arg_32_0.scrollview:getContentSize()
	local var_32_17 = arg_32_0.scrollview:getInnerContainer()
	local var_32_18 = 0 - var_32_17:getContentSize().height + var_32_16.height
	
	if var_32_18 > var_32_17:getPositionY() then
		var_32_17:setPositionY(var_32_18)
	end
	
	local var_32_19 = arg_32_0.ScrollViewEmptyMessage
	
	if #arg_32_0.ScrollViewItems == 0 and var_32_19 then
		local var_32_20 = arg_32_0.scrollview:getChildByName("scroll_empty_text_ctl")
		
		if not var_32_20 then
			var_32_20 = get_text(var_32_19, 17)
			
			var_32_20:setName("scroll_empty_text_ctl")
			arg_32_0.scrollview:addChild(var_32_20)
		end
		
		local var_32_21 = arg_32_0.item_width * arg_32_0.COL / 2
		local var_32_22 = arg_32_0.item_height * arg_32_0.rows / 2
		
		var_32_20:setPosition(var_32_21, var_32_22)
		var_32_20:setVisible(true)
	else
		if_set_visible(arg_32_0.scrollview, "scroll_empty_text_ctl", false)
	end
end

function ScrollView.getScrollViewItemPosition(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = (arg_33_0.rows - arg_33_2 - 1) * arg_33_0.item_height + arg_33_0.item_height / 2
	
	return arg_33_1 * arg_33_0.item_width + arg_33_0.item_width / 2, var_33_0
end

function ScrollView.getScrollViewItemIndex(arg_34_0, arg_34_1, arg_34_2)
	return math.ceil(arg_34_1 / arg_34_0.item_width)
end

function ScrollView.setTouchEnabled(arg_35_0, arg_35_1)
	if not get_cocos_refid(arg_35_0.scrollview) then
		return 
	end
	
	arg_35_0.scrollview:setTouchEnabled(arg_35_1)
	
	if arg_35_1 then
		arg_35_0:registerTouchHandler()
	end
end

function ScrollView.jumpToPercent(arg_36_0, arg_36_1)
	if not get_cocos_refid(arg_36_0.scrollview) then
		return 
	end
	
	if not arg_36_0.IsForceHorizontal then
		arg_36_0.scrollview:jumpToPercentVertical(arg_36_1)
	else
		arg_36_0.scrollview:jumpToPercentHorizontal(arg_36_1)
	end
end

function ScrollView.jumpToIndex(arg_37_0, arg_37_1)
	local var_37_0 = table.count(arg_37_0.ScrollViewItems)
	local var_37_1 = var_37_0 <= 1 and 0 or 100 * ((arg_37_1 - 1) / (var_37_0 - 1))
	
	arg_37_0:jumpToPercent(var_37_1)
end

function ScrollView.scrollToPercent(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.IsForceHorizontal then
		arg_38_0.scrollview:scrollToPercentVertical(arg_38_1, arg_38_2, true)
	else
		arg_38_0.scrollview:scrollToPercentHorizontal(arg_38_1, arg_38_2, true)
	end
end

function ScrollView.scrollToIndex(arg_39_0, arg_39_1, arg_39_2)
	if arg_39_2 == nil then
		arg_39_2 = 0.5
	end
	
	local var_39_0 = table.count(arg_39_0.ScrollViewItems)
	local var_39_1 = var_39_0 <= 1 and 0 or 100 * ((arg_39_1 - 1) / (var_39_0 - 1))
	
	arg_39_0:scrollToPercent(var_39_1, arg_39_2)
end

function ScrollView.sort(arg_40_0, arg_40_1)
	if not arg_40_0.ScrollViewItems then
		return 
	end
	
	table.sort(arg_40_0.ScrollViewItems, arg_40_1)
	arg_40_0:arrangeScrollViewItems(nil, nil, true)
end
