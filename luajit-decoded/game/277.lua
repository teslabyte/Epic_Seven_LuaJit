local function var_0_0(arg_1_0)
	local var_1_0 = arg_1_0:getContentSize()
	
	var_1_0.height = 0
	
	local var_1_1 = ccui.Layout:create()
	
	var_1_1:setContentSize(var_1_0.width, var_1_0.height)
	var_1_1:setLayoutType(ccui.LayoutType.TILED_VERTICAL)
	var_1_1:setAutoSizeEnabled(true)
	
	return var_1_1
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0:getContentSize()
	
	var_2_0.height = 0
	
	local var_2_1 = ccui.Layout:create()
	
	var_2_1:setContentSize(var_2_0.width, var_2_0.height)
	var_2_1:setLayoutType(arg_2_1.layout_type or ccui.LayoutType.TILED_VERTICAL)
	
	return var_2_1
end

GroupListView = {}

function GroupListView.bindControl(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1.vars = {}
	arg_3_1.vars.opts = arg_3_2 or {}
	
	arg_3_1:setBounceEnabled(true)
	arg_3_1:setItemsMargin(0)
	copy_functions(GroupListView, arg_3_1)
	
	return arg_3_1
end

function GroupListView.setRenderer(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0.vars.headerRenderer = arg_4_1
	
	arg_4_0.vars.headerRenderer:retain()
	
	arg_4_0.vars.headerUpdater = arg_4_3
	arg_4_0.vars.itemRenderer = arg_4_2
	
	arg_4_0.vars.itemRenderer:retain()
	
	arg_4_0.vars.itemUpdater = arg_4_4
	arg_4_0.vars.itemControls = {}
	
	cc.AutoreleasePool:addObjectWithTarget(arg_4_0.vars.headerRenderer, arg_4_0)
	cc.AutoreleasePool:addObjectWithTarget(arg_4_0.vars.itemRenderer, arg_4_0)
end

function GroupListView.setListViewCascadeOpacityEnabled(arg_5_0, arg_5_1)
	arg_5_0.vars.cascade = arg_5_1
end

function GroupListView._setupWidgetObject(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local function var_6_0(arg_7_0)
		if arg_7_0 == "enterInsideBounds" then
			local var_7_0 = arg_6_2:clone()
			local var_7_1 = arg_6_3:onUpdate(var_7_0, arg_6_4)
			
			if var_7_1 then
				var_7_0:setName(var_7_1)
			end
			
			arg_6_1:addChild(var_7_0)
		end
		
		if arg_7_0 == "exitInsideBounds" then
			arg_6_1:removeAllChildren()
		end
	end
	
	arg_6_1:registerScriptHandler(var_6_0)
	
	return arg_6_1
end

function GroupListView.setEnableMargin(arg_8_0, arg_8_1)
	arg_8_0.vars.use_margin = arg_8_1
end

function GroupListView.getMarginLength(arg_9_0, arg_9_1)
	if arg_9_0.vars.use_margin then
		local var_9_0 = arg_9_1:getContentSize()
		local var_9_1 = arg_9_0.vars.itemRenderer:getContentSize()
		local var_9_2 = math.floor(var_9_0.width / var_9_1.width)
		
		return var_9_0.width % var_9_1.width / var_9_2
	end
	
	return 0
end

function GroupListView.test_show_pos(arg_10_0)
	table.print(arg_10_0:getInnerContainerPosition())
end

function GroupListView.scrollToBottom(arg_11_0)
	local var_11_0 = arg_11_0:getInnerContainerPosition()
	
	arg_11_0:forceDoLayout()
	
	var_11_0.y = 0
	
	arg_11_0:setInnerContainerPosition(var_11_0)
end

function GroupListView.createHeaderWidget(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.vars.cascade or false
	local var_12_1 = ccui.Widget:create()
	
	var_12_1:setCascadeOpacityEnabled(var_12_0)
	var_12_1:setContentSize(arg_12_0.vars.headerRenderer:getContentSize())
	arg_12_0:pushBackCustomItem(arg_12_0:_setupWidgetObject(var_12_1, arg_12_0.vars.headerRenderer, arg_12_0.vars.headerUpdater, arg_12_1))
end

function GroupListView.getItemWidget(arg_13_0)
	local var_13_0 = arg_13_0.vars.cascade or false
	local var_13_1 = ccui.Widget:create()
	
	var_13_1:setAnchorPoint(0, 0)
	var_13_1:setContentSize(arg_13_0.vars.itemRenderer:getContentSize())
	var_13_1:setCascadeOpacityEnabled(var_13_0)
	
	return var_13_1
end

function GroupListView.addGroup(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0.vars.itemUpdater.onSize then
		arg_14_0:_sizeAddGroup(arg_14_1, arg_14_2)
		
		return 
	end
	
	local var_14_0 = arg_14_0.vars.cascade or false
	
	arg_14_0:createHeaderWidget(arg_14_1)
	
	local var_14_1 = var_0_0(arg_14_0)
	
	var_14_1:setCascadeOpacityEnabled(var_14_0)
	
	local var_14_2 = arg_14_0:getItemWidget()
	local var_14_3 = arg_14_0:getMarginLength(var_14_1)
	
	for iter_14_0, iter_14_1 in pairs(arg_14_2) do
		local var_14_4 = arg_14_0:_setupWidgetObject(var_14_2:clone(), arg_14_0.vars.itemRenderer, arg_14_0.vars.itemUpdater, iter_14_1)
		
		var_14_1:addChild(var_14_4)
		var_14_4:getLayoutParameter():setMargin({
			left = var_14_3
		})
		
		arg_14_0.vars.itemControls[var_14_4] = iter_14_1
	end
	
	var_14_1:forceDoLayout()
	arg_14_0:pushBackCustomItem(var_14_1)
end

function GroupListView.jumpToIndex(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0:forceDoLayout()
	
	local var_15_0 = arg_15_0:getChildren()
	local var_15_1
	local var_15_2 = 0
	
	for iter_15_0 = 1, #var_15_0 do
		local var_15_3 = var_15_0[iter_15_0]
		
		if get_cocos_refid(var_15_3) and tolua.type(var_15_3) == "ccui.Layout" then
			var_15_2 = var_15_2 + 1
			
			if var_15_2 == arg_15_1 then
				var_15_1 = var_15_3
				
				break
			end
		end
	end
	
	if not var_15_1 then
		return 
	end
	
	local var_15_4 = var_15_1:getPositionY()
	local var_15_5 = var_15_1:getChildren()
	local var_15_6
	
	for iter_15_1 = 1, #var_15_5 do
		local var_15_7 = var_15_5[iter_15_1]
		
		if iter_15_1 == arg_15_2 then
			var_15_6 = var_15_7
		end
	end
	
	if not var_15_6 then
		return 
	end
	
	local var_15_8 = var_15_6:getPositionY()
	local var_15_9 = arg_15_0:getInnerContainerPosition()
	
	var_15_9.y = -var_15_8 - var_15_4
	
	arg_15_0:setInnerContainerPosition(var_15_9)
	
	return true
end

function GroupListView._sizeAddGroup(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.vars.cascade or false
	
	arg_16_0:createHeaderWidget(arg_16_1)
	
	local var_16_1 = var_0_1(arg_16_0, arg_16_0.vars.opts)
	
	var_16_1:setCascadeOpacityEnabled(var_16_0)
	
	local var_16_2 = arg_16_0:getItemWidget()
	local var_16_3 = arg_16_0.vars.itemRenderer:clone()
	local var_16_4 = arg_16_0:getMarginLength(var_16_1)
	local var_16_5 = 0
	
	for iter_16_0, iter_16_1 in pairs(arg_16_2) do
		local var_16_6 = arg_16_0:_setupWidgetObject(var_16_2:clone(), arg_16_0.vars.itemRenderer, arg_16_0.vars.itemUpdater, iter_16_1)
		
		if arg_16_0.vars.itemUpdater.onSize then
			arg_16_0.vars.itemUpdater:onSize(var_16_3, arg_16_0.vars.itemRenderer, var_16_6, iter_16_1)
			
			var_16_5 = var_16_5 + var_16_6:getContentSize().height
		end
		
		var_16_1:addChild(var_16_6)
		var_16_6:getLayoutParameter():setMargin({
			left = var_16_4
		})
	end
	
	local var_16_7 = var_16_1:getContentSize()
	
	var_16_1:setContentSize({
		width = var_16_7.width,
		height = var_16_5 + 30
	})
	var_16_1:forceDoLayout()
	arg_16_0:pushBackCustomItem(var_16_1)
end

function GroupListView.enumControls(arg_17_0, arg_17_1)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.itemControls) do
		if get_cocos_refid(iter_17_0) then
			arg_17_1(iter_17_0, iter_17_1)
		end
	end
end

function GroupListView.clear(arg_18_0)
	arg_18_0.vars.itemControls = {}
	
	arg_18_0:removeAllChildren()
end
