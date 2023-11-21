ScrollViewEx = {}

local var_0_0 = DESIGN_WIDTH / 1920

function ScrollViewEx.initScrollView(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_1:getEventDispatcher()
	
	local function var_1_1(arg_2_0, arg_2_1)
		if UIAction:Find("block") then
			return false
		end
		
		return arg_1_0.onScrollViewTouchBegin(arg_1_0, arg_2_0, arg_2_1)
	end
	
	local function var_1_2(arg_3_0, arg_3_1)
		if UIAction:Find("block") then
			return false
		end
		
		return arg_1_0.onScrollViewTouchEnd(arg_1_0, arg_3_0, arg_3_1)
	end
	
	local function var_1_3(arg_4_0, arg_4_1)
		if UIAction:Find("block") then
			return false
		end
		
		return arg_1_0.onScrollViewTouchMove(arg_1_0, arg_4_0, arg_4_1)
	end
	
	arg_1_1:setSwallowTouches(false)
	var_1_0:removeEventListener(arg_1_0.listener)
	
	arg_1_0.listener = cc.EventListenerTouchOneByOne:create()
	
	arg_1_0.listener:registerScriptHandler(var_1_1, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_1_0.listener:registerScriptHandler(var_1_3, cc.Handler.EVENT_TOUCH_MOVED)
	arg_1_0.listener:registerScriptHandler(var_1_2, cc.Handler.EVENT_TOUCH_ENDED)
	var_1_0:addEventListenerWithSceneGraphPriority(arg_1_0.listener, arg_1_1)
	
	arg_1_0.scrollview = arg_1_1
	
	arg_1_0.scrollview:setCascadeOpacityEnabled(true)
	
	arg_1_0.item_width = arg_1_2 or 295
	arg_1_0.item_height = arg_1_3 or 400
	arg_1_0.group_header_width = arg_1_4
	arg_1_0.group_header_height = arg_1_5
	
	local var_1_4 = arg_1_1:getContentSize()
	
	arg_1_0:setSize(var_1_4.width, var_1_4.height)
end

function ScrollViewEx.setSize(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_0.scrollview:setContentSize(arg_5_1, arg_5_2)
	
	arg_5_0.COL = math.floor(arg_5_1 / arg_5_0.item_width)
	arg_5_0.ROW = arg_5_2 / arg_5_0.item_height
	
	if arg_5_3 then
		arg_5_0:arrangeScrollViewItems(arg_5_4, nil, true)
	end
end

function ScrollViewEx.checkCollision(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_1 < arg_6_3.x or arg_6_2 < arg_6_3.y or arg_6_1 >= arg_6_3.x + arg_6_3.width or arg_6_2 >= arg_6_3.y + arg_6_3.height then
		return false
	end
	
	return true
end

function ScrollViewEx.onScrollViewTouchBegin(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_0.touched then
		return true
	end
	
	local var_7_0 = arg_7_1:getLocation()
	
	if not checkCollision(arg_7_0.scrollview, var_7_0.x, var_7_0.y) then
		arg_7_0.scrollview_touch_x = nil
		arg_7_0.scrollview_touch_y = nil
		
		return false
	end
	
	arg_7_0.touched = true
	arg_7_0.scrollview_dragging = nil
	arg_7_0.scrollview_touch_x = var_7_0.x
	arg_7_0.scrollview_touch_y = var_7_0.y
	arg_7_0.scrollview_touch_tick = systick()
	
	Scheduler:add(arg_7_0.scrollview, arg_7_0.onScrollViewUpdate, arg_7_0)
	
	return true
end

function ScrollViewEx.onScrollViewUpdate(arg_8_0)
	if arg_8_0.scrollview_dragging then
		return 
	end
	
	if not arg_8_0.scrollview_touch_tick then
		return 
	end
	
	if systick() - arg_8_0.scrollview_touch_tick > 300 and arg_8_0.scrollview_touch_x then
		Scheduler:remove(arg_8_0.onScrollViewUpdate)
		
		local var_8_0 = arg_8_0.scrollview_touch_x / var_0_0
		local var_8_1 = arg_8_0.scrollview_touch_y / var_0_0
		local var_8_2, var_8_3 = arg_8_0:getTouchedItem(var_8_0, var_8_1)
		
		if not var_8_2 then
			return 
		end
		
		if arg_8_0.onInfoScrollViewItem then
			arg_8_0:onInfoScrollViewItem(var_8_2, var_8_3)
		end
	end
end

function ScrollViewEx.onScrollViewTouchMove(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1:getLocation()
	local var_9_1 = var_9_0.x / var_0_0
	local var_9_2 = var_9_0.y / var_0_0
	
	if not arg_9_0.scrollview_dragging and arg_9_0.scrollview_touch_x and (math.abs(arg_9_0.scrollview_touch_x - var_9_1) > DESIGN_HEIGHT * 0.01 or math.abs(arg_9_0.scrollview_touch_y - var_9_2) > DESIGN_HEIGHT * 0.01) then
		arg_9_0.scrollview_dragging = true
		
		Scheduler:remove(arg_9_0.onScrollViewUpdate)
	end
end

function ScrollViewEx.getTouchedItem(arg_10_0, arg_10_1, arg_10_2)
	if not checkCollision(arg_10_0.scrollview, arg_10_1, arg_10_2) or arg_10_0.scrollview_touch_x == nil then
		return false
	end
	
	if math.abs(arg_10_0.scrollview_touch_x - arg_10_1) > DESIGN_HEIGHT * 0.02 or math.abs(arg_10_0.scrollview_touch_y - arg_10_2) > DESIGN_HEIGHT * 0.02 then
		return false
	end
	
	local var_10_0, var_10_1 = arg_10_0.scrollview:getInnerContainer():getPosition()
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.ScrollViewItems or {}) do
		for iter_10_2, iter_10_3 in pairs(iter_10_1) do
			if checkCollision(iter_10_3.control, arg_10_1, arg_10_2) then
				return iter_10_2, iter_10_3
			end
		end
	end
	
	return false
end

function ScrollViewEx.removeScrollViewItemAt(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.scrollview:removeChild(arg_11_0.ScrollViewItems[arg_11_1][arg_11_2].control)
	table.remove(arg_11_0.ScrollViewItems[arg_11_1], arg_11_2)
	arg_11_0:arrangeScrollViewItems()
end

function ScrollViewEx.onScrollViewTouchEnd(arg_12_0, arg_12_1, arg_12_2)
	Scheduler:remove(arg_12_0.onScrollViewUpdate)
	
	if not arg_12_0.touched then
		return true
	end
	
	arg_12_0.touched = false
	
	local var_12_0 = arg_12_1:getLocation()
	local var_12_1 = arg_12_0.scrollview
	
	while var_12_1 do
		if not var_12_1:isVisible() then
			return 
		end
		
		var_12_1 = var_12_1:getParent()
	end
	
	local var_12_2, var_12_3 = arg_12_0:getTouchedItem(var_12_0.x, var_12_0.y)
	
	if not var_12_2 then
		return false
	end
	
	SoundEngine:play("event:/ui/btn_ok")
	
	if not UIAction:Find("block") then
		arg_12_0:onSelectScrollViewItem(var_12_2, var_12_3)
	end
	
	arg_12_0.scrollview_touch_tick = nil
	
	return true
end

function ScrollViewEx.removeScrollViewItem(arg_13_0, arg_13_1, arg_13_2)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.ScrollViewItems) do
		if iter_13_0 == arg_13_1 then
			for iter_13_2, iter_13_3 in pairs(iter_13_1) do
				if iter_13_3.item == arg_13_2 then
					arg_13_0.scrollview:removeChild(arg_13_0.ScrollViewItems[iter_13_0][iter_13_2].control)
					table.remove(arg_13_0.ScrollViewItems[iter_13_0], iter_13_2)
					
					break
				end
			end
		end
	end
	
	arg_13_0:arrangeScrollViewItems()
end

function ScrollViewEx.createScrollViewItems(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0.scrollview:removeAllChildren()
	
	arg_14_0.ScrollViewItems = {}
	arg_14_0.ScrollViewGroupHeaders = {}
	arg_14_0.GroupCount = 0
	
	local var_14_0 = 1
	
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		arg_14_0.GroupCount = arg_14_0.GroupCount + 1
		
		local var_14_1 = arg_14_2[iter_14_0]
		
		if var_14_1 then
			local var_14_2 = Dialog:open(var_14_1.dialog_name)
			
			var_14_2:setAnchorPoint(0, 0)
			
			if var_14_1.text_child and var_14_1.text_replace then
				var_14_2:getChildByName(var_14_1.text_child):setString(var_14_1.text_replace)
			end
			
			arg_14_0.scrollview:addChild(var_14_2)
			
			arg_14_0.ScrollViewGroupHeaders[iter_14_0] = var_14_2
		end
		
		for iter_14_2, iter_14_3 in pairs(iter_14_1) do
			local var_14_3 = arg_14_0:getScrollViewItem(iter_14_3)
			
			if get_cocos_refid(var_14_3) then
				var_14_3:setAnchorPoint(0, 0)
				arg_14_0.scrollview:addChild(var_14_3)
				
				if not arg_14_0.ScrollViewItems[iter_14_0] then
					arg_14_0.ScrollViewItems[iter_14_0] = {}
				end
				
				table.push(arg_14_0.ScrollViewItems[iter_14_0], {
					item = iter_14_3,
					control = var_14_3
				})
			end
		end
	end
	
	arg_14_0.ScrollViewEmptyMessage = arg_14_3
	
	arg_14_0:arrangeScrollViewItems()
end

function ScrollViewEx.insertFrontScrollViewItems(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0.ScrollViewItems = arg_15_0.ScrollViewItems or {}
	
	if not arg_15_0.ScrollViewItems[arg_15_1] then
		arg_15_0.ScrollViewItems[arg_15_1] = {}
	end
	
	local var_15_0 = arg_15_0:getScrollViewItem(arg_15_2)
	
	if get_cocos_refid(var_15_0) then
		var_15_0:setAnchorPoint(0, 0)
		arg_15_0.scrollview:addChild(var_15_0)
		table.insert(arg_15_0.ScrollViewItems[arg_15_1], 1, {
			item = arg_15_2,
			control = var_15_0
		})
	end
	
	arg_15_0.ScrollViewEmptyMessage = text
	
	arg_15_0:arrangeScrollViewItems(arg_15_3)
end

function ScrollViewEx.arrangeScrollViewItems(arg_16_0, arg_16_1)
	if arg_16_0.ROW == 1 then
		arg_16_0.COL = arg_16_0.GroupCount
		arg_16_0.rows = 1
	else
		arg_16_0.rows = 0
		
		for iter_16_0, iter_16_1 in pairs(arg_16_0.ScrollViewItems) do
			local var_16_0 = math.floor(#iter_16_1 / arg_16_0.COL)
			
			if #iter_16_1 % arg_16_0.COL ~= 0 then
				var_16_0 = var_16_0 + 1
			end
			
			arg_16_0.rows = arg_16_0.rows + var_16_0
		end
		
		arg_16_0.rows = math.max(arg_16_0.ROW, arg_16_0.rows)
	end
	
	local var_16_1 = 0
	local var_16_2 = 1
	local var_16_3 = 0
	
	for iter_16_2, iter_16_3 in pairs(arg_16_0.ScrollViewItems) do
		if arg_16_0.ScrollViewGroupHeaders[iter_16_2] then
			local var_16_4, var_16_5 = arg_16_0:getScrollViewItemPosition(var_16_2, 0, var_16_1)
			
			arg_16_0.ScrollViewGroupHeaders[iter_16_2]:setPosition(var_16_4, var_16_5 + arg_16_0.item_height)
		end
		
		for iter_16_4, iter_16_5 in pairs(iter_16_3) do
			local var_16_6 = iter_16_5.control
			local var_16_7 = (iter_16_4 - 1) % arg_16_0.COL
			local var_16_8 = var_16_1 + math.floor((iter_16_4 - 1) / arg_16_0.COL)
			local var_16_9, var_16_10 = arg_16_0:getScrollViewItemPosition(var_16_2, var_16_7, var_16_8)
			
			if arg_16_1 then
				UIAction:Add(LOG(MOVE_TO(200, var_16_9, var_16_10), 300), var_16_6, "block")
			else
				var_16_6:setPosition(var_16_9, var_16_10)
			end
			
			var_16_3 = var_16_3 + 1
		end
		
		local var_16_11 = math.floor(#iter_16_3 / arg_16_0.COL)
		
		if #iter_16_3 % arg_16_0.COL ~= 0 then
			var_16_11 = var_16_11 + 1
		end
		
		var_16_1 = var_16_1 + var_16_11
		var_16_2 = var_16_2 + 1
	end
	
	arg_16_0.scrollview:setInnerContainerSize({
		width = arg_16_0.item_width * arg_16_0.COL,
		height = arg_16_0.item_height * arg_16_0.rows + arg_16_0.group_header_height * arg_16_0.GroupCount
	})
	
	if arg_16_1 then
	end
	
	local var_16_12 = arg_16_0.ScrollViewEmptyMessage
	
	if var_16_3 == 0 and var_16_12 then
		local var_16_13 = get_text(var_16_12, 25)
		local var_16_14 = arg_16_0.item_width * arg_16_0.COL / 2
		local var_16_15 = arg_16_0.item_height * arg_16_0.rows / 2
		
		arg_16_0.scrollview:addChild(var_16_13)
		var_16_13:setPosition(var_16_14, var_16_15)
	end
end

function ScrollViewEx.getScrollViewItemPosition(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = (arg_17_0.rows - arg_17_3) * arg_17_0.item_height + (arg_17_0.GroupCount - arg_17_1 - 3) * arg_17_0.group_header_height
	
	return arg_17_2 * arg_17_0.item_width, var_17_0 + (189 - arg_17_0.item_height)
end
