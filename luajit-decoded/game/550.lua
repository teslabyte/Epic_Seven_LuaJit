ItemListView_v2 = {}

function ItemListView_v2.bindControl(arg_1_0, arg_1_1)
	arg_1_1.vars = {}
	
	arg_1_1:setBounceEnabled(true)
	
	if type(arg_1_1.setItemsMargin) == "function" then
		arg_1_1:setItemsMargin(0)
	end
	
	arg_1_1:removeAllChildren()
	arg_1_1:setLayoutType(ccui.LayoutType.TILED_VERTICAL)
	arg_1_1:getInnerContainer():setAutoSizeEnabled(true)
	arg_1_1:setSwallowTouches(true)
	
	if arg_1_1.STRETCH_INFO then
		function arg_1_1.scene_reload_callback()
			arg_1_1:removeAllChildren()
			
			local var_2_0 = arg_1_1:getContentSize()
			local var_2_1 = arg_1_1.vars.itemRenderer
			
			resetControlPosAndSize(var_2_1, var_2_0.width, arg_1_1.STRETCH_INFO.width_prev)
			arg_1_1:setDataSource(arg_1_1.vars.dataSource)
		end
	end
	
	copy_functions(ItemListView_v2, arg_1_1)
	
	return arg_1_1
end

function ItemListView_v2.getMaxHeight(arg_3_0)
	local var_3_0 = arg_3_0:getInnerContainerSize()
	local var_3_1 = arg_3_0:getContentSize()
	
	return var_3_0.height - var_3_1.height
end

function ItemListView_v2.setPositionVertical(arg_4_0, arg_4_1)
	arg_4_0:forceDoLayout()
	
	local var_4_0, var_4_1 = arg_4_0:getInnerSizeAndPos()
	local var_4_2 = var_4_1.height * arg_4_1
	
	var_4_0.y = math.max(-1 * arg_4_0:getMaxHeight(), var_4_2)
	
	arg_4_0:setInnerContainerPosition(var_4_0)
end

function ItemListView_v2.getInnerSizeAndPos(arg_5_0)
	local var_5_0 = arg_5_0:getInnerContainerPosition()
	local var_5_1 = arg_5_0:getInnerContainerSize()
	
	return var_5_0, var_5_1
end

function ItemListView_v2.setItemsKeepPos(arg_6_0, arg_6_1)
	local var_6_0 = false
	local var_6_1, var_6_2 = arg_6_0:getInnerSizeAndPos()
	
	if var_6_2.height < 1 then
		var_6_2.height = 1
		var_6_0 = true
	end
	
	local var_6_3 = var_6_1.y / var_6_2.height
	
	arg_6_0:removeAllChildren()
	arg_6_0:setDataSource(arg_6_1)
	
	if var_6_0 then
		arg_6_0:jumpToTop()
	else
		arg_6_0:setPositionVertical(var_6_3)
	end
end

function ItemListView_v2.setRenderer(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.vars.itemRenderer = arg_7_1
	
	arg_7_0.vars.itemRenderer:retain()
	
	arg_7_0.vars.itemUpdater = arg_7_2
	arg_7_0.vars.controls = {}
	
	cc.AutoreleasePool:addObjectWithTarget(arg_7_0.vars.itemRenderer, arg_7_0)
end

function ItemListView_v2.getTopYPosition(arg_8_0)
	return arg_8_0:getContentSize().height - arg_8_0:getInnerContainerSize().height
end

function ItemListView_v2.jumpToPercent(arg_9_0, arg_9_1)
	arg_9_0:jumpToPercentVertical(arg_9_1)
end

function ItemListView_v2.jumpToIndex(arg_10_0, arg_10_1)
	local var_10_0 = table.count(arg_10_0.vars.dataSource)
	local var_10_1 = var_10_0 <= 1 and 0 or 100 * ((arg_10_1 - 1) / (var_10_0 - 1))
	
	arg_10_0:jumpToPercent(var_10_1)
end

function ItemListView_v2.isHitTest(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_1:isVisible(true) then
		return 
	end
	
	local var_11_0 = arg_11_1:convertTouchToNodeSpace(arg_11_2)
	local var_11_1 = arg_11_1:getContentSize()
	local var_11_2 = cc.rect(0, 0, var_11_1.width, var_11_1.height)
	
	if containsPoint(var_11_2, var_11_0.x, var_11_0.y) then
		return true
	end
end

function ItemListView_v2._setupWidgetObject(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local function var_12_0(arg_13_0)
		if arg_13_0 == "enterInsideBounds" then
			local var_13_0 = arg_12_2:clone()
			
			local function var_13_1()
				if get_cocos_refid(var_13_0) then
					local var_14_0 = arg_12_0.vars.dataSource[arg_12_4]
					local var_14_1 = arg_12_3:onUpdate(var_13_0, arg_12_4, var_14_0)
					
					if var_14_1 then
						var_13_0:setName(var_14_1)
					end
					
					arg_12_0.vars.controls[var_13_0].index = arg_12_4
					arg_12_0.vars.controls[var_13_0].item = var_14_0
				end
			end
			
			arg_12_0.vars.controls[var_13_0] = {
				index = arg_12_4,
				item = arg_12_0.vars.dataSource[arg_12_4],
				updater = var_13_1
			}
			
			var_13_1()
			
			if arg_12_3.onTouchDown or arg_12_3.onTouchUp then
				var_13_0.listener = cc.EventListenerTouchOneByOne:create()
				
				var_13_0.listener:registerScriptHandler(function(arg_15_0, arg_15_1)
					if arg_12_0:isHitTest(var_13_0, arg_15_0) then
						if arg_12_3.onTouchDown then
							local var_15_0 = arg_12_0.vars.dataSource[arg_12_4]
							
							return arg_12_3:onTouchDown(arg_12_2, arg_12_4, var_15_0, {
								event = arg_15_1,
								touch = arg_15_0
							})
						end
						
						return true
					end
				end, cc.Handler.EVENT_TOUCH_BEGAN)
				var_13_0.listener:registerScriptHandler(function(arg_16_0, arg_16_1)
					if arg_12_3.onTouchUp then
						local var_16_0 = arg_12_0.vars.dataSource[arg_12_4]
						local var_16_1 = {
							event = arg_16_1,
							touch = arg_16_0,
							cancelled = not arg_12_0:isHitTest(var_13_0, arg_16_0)
						}
						
						arg_12_3:onTouchUp(arg_12_2, arg_12_4, var_16_0, var_16_1)
					end
				end, cc.Handler.EVENT_TOUCH_ENDED)
				var_13_0:getEventDispatcher():addEventListenerWithSceneGraphPriority(var_13_0.listener, var_13_0)
			end
			
			arg_12_1:addChild(var_13_0)
			
			arg_12_1.rendererInst = var_13_0
		end
		
		if arg_13_0 == "exitInsideBounds" then
			arg_12_0.vars.controls[arg_12_1.rendererInst] = nil
			arg_12_1.rendererInst = nil
			
			arg_12_1:removeAllChildren()
		end
	end
	
	arg_12_1:setTag(arg_12_4)
	arg_12_1:registerScriptHandler(var_12_0)
	
	return arg_12_1
end

function ItemListView_v2.getDataSource(arg_17_0)
	return arg_17_0.vars.dataSource
end

function ItemListView_v2.setDataSource(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return 
	end
	
	if type(arg_18_1) ~= "table" then
		error("`dataSource` is no table")
	end
	
	arg_18_0.vars.dataSource = arg_18_1
	
	arg_18_0:refresh()
end

function ItemListView_v2.setListViewCascadeEnabled(arg_19_0, arg_19_1)
	arg_19_0.vars.cascade = arg_19_1
end

function ItemListView_v2.lightRefresh(arg_20_0)
	if not arg_20_0.vars.itemUpdater or not arg_20_0.vars.itemUpdater.onLightUpdate then
		return 
	end
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.controls) do
		if get_cocos_refid(iter_20_0) then
			arg_20_0.vars.itemUpdater:onLightUpdate(iter_20_0, iter_20_1.index, iter_20_1.item)
		end
	end
end

function ItemListView_v2.refresh(arg_21_0, ...)
	local function var_21_0(arg_22_0)
		local var_22_0 = arg_22_0:getInnerContainerPosition()
		local var_22_1 = arg_22_0:getInnerContainerSize()
		
		arg_22_0:forceDoLayout()
		
		local var_22_2 = arg_22_0:getInnerContainerSize()
		
		var_22_0.y = math.min(0, var_22_0.y - (var_22_2.height - var_22_1.height))
		
		arg_22_0:setInnerContainerPosition(var_22_0)
	end
	
	local var_21_1 = 0
	
	if arg_21_0.vars.dataSource then
		var_21_1 = #arg_21_0.vars.dataSource
	end
	
	local var_21_2 = arg_21_0:getInnerContainer()
	local var_21_3 = var_21_2:getChildrenCount()
	
	if var_21_3 < var_21_1 then
		local var_21_4 = ccui.Widget:create()
		local var_21_5 = arg_21_0.vars.cascade or false
		
		var_21_4:setCascadeOpacityEnabled(var_21_5)
		var_21_4:setCascadeColorEnabled(var_21_5)
		var_21_4:setAnchorPoint(0, 0)
		var_21_4:setContentSize(arg_21_0.vars.itemRenderer:getContentSize())
		
		local var_21_6 = var_21_3 + (var_21_1 - var_21_3)
		
		for iter_21_0 = var_21_3 + 1, var_21_6 do
			var_21_2:addChildLast(arg_21_0:_setupWidgetObject(var_21_4:clone(), arg_21_0.vars.itemRenderer, arg_21_0.vars.itemUpdater, iter_21_0))
		end
		
		var_21_0(arg_21_0)
	elseif var_21_1 < var_21_3 then
		local var_21_7 = var_21_3 - (var_21_3 - var_21_1) + 1
		
		for iter_21_1 = var_21_3, var_21_7, -1 do
			var_21_2:removeChildByTag(iter_21_1)
		end
		
		var_21_0(arg_21_0)
	end
	
	local var_21_8 = {
		...
	}
	local var_21_9 = {}
	local var_21_10 = 0
	
	for iter_21_2, iter_21_3 in pairs(arg_21_0.vars.controls) do
		var_21_10 = var_21_10 + 1
		
		if get_cocos_refid(iter_21_2) then
			if #var_21_8 == 0 or table.find(var_21_8, iter_21_3.item) then
				iter_21_3.updater()
			end
		else
			var_21_9[iter_21_2] = nil
		end
	end
	
	for iter_21_4, iter_21_5 in pairs(var_21_9) do
		arg_21_0.vars.controls[iter_21_4] = nil
	end
end

function ItemListView_v2.getControl(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.controls) do
		if get_cocos_refid(iter_23_0) and iter_23_1.item == arg_23_1 then
			return iter_23_0
		end
	end
end

function ItemListView_v2.enumControls(arg_24_0, arg_24_1)
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.controls) do
		if get_cocos_refid(iter_24_0) then
			arg_24_1(iter_24_0, iter_24_1)
		end
	end
end

ItemListView = {}

local function var_0_0(arg_25_0)
	local var_25_0 = arg_25_0:getContentSize()
	
	var_25_0.height = 0
	
	local var_25_1 = ccui.Layout:create()
	
	var_25_1:setContentSize(var_25_0.width, var_25_0.height)
	var_25_1:setLayoutType(ccui.LayoutType.TILED_VERTICAL)
	var_25_1:setAutoSizeEnabled(true)
	
	return var_25_1
end

function ItemListView.bindControl(arg_26_0, arg_26_1)
	arg_26_1.vars = {
		controls = {}
	}
	
	arg_26_1:setBounceEnabled(true)
	arg_26_1:setItemsMargin(0)
	copy_functions(ItemListView, arg_26_1)
	
	if arg_26_1.STRETCH_INFO then
		function arg_26_1.scene_reload_callback()
			if arg_26_1.STRETCH_INFO then
				arg_26_1:removeAllChildren()
				
				local var_27_0 = arg_26_1:getContentSize()
				local var_27_1 = arg_26_1.vars.itemRenderer
				
				resetControlPosAndSize(var_27_1, var_27_0.width, arg_26_1.STRETCH_INFO.width_prev)
				arg_26_1:addItems(arg_26_1.vars.itemObjectList)
			end
		end
	end
	
	return arg_26_1
end

function ItemListView.setRenderer(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.vars.itemRenderer = arg_28_1
	
	arg_28_0.vars.itemRenderer:retain()
	
	arg_28_0.vars.itemUpdater = arg_28_2
	arg_28_0.vars.controls = {}
	
	cc.AutoreleasePool:addObjectWithTarget(arg_28_0.vars.itemRenderer, arg_28_0)
end

function ItemListView._setupWidgetObject(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local function var_29_0(arg_30_0)
		if arg_30_0 == "enterInsideBounds" then
			local var_30_0 = arg_29_2:clone()
			
			local function var_30_1()
				if get_cocos_refid(var_30_0) then
					local var_31_0 = arg_29_3:onUpdate(var_30_0, arg_29_4)
					
					if var_31_0 then
						var_30_0:setName(var_31_0)
					end
				end
			end
			
			var_30_1()
			arg_29_1:addChild(var_30_0)
			
			arg_29_0.vars.controls[var_30_0] = {
				updater = var_30_1,
				item = arg_29_4
			}
			arg_29_1.rendererInst = var_30_0
		end
		
		if arg_30_0 == "exitInsideBounds" then
			arg_29_0.vars.controls[arg_29_1.rendererInst] = nil
			arg_29_1.rendererInst = nil
			
			arg_29_1:removeAllChildren()
		end
	end
	
	arg_29_1:registerScriptHandler(var_29_0)
	
	return arg_29_1
end

function ItemListView.setListViewCascadeEnabled(arg_32_0, arg_32_1)
	arg_32_0.vars.cascade = arg_32_1
end

function ItemListView.getInnerSizeAndPos(arg_33_0)
	local var_33_0 = arg_33_0:getInnerContainerPosition()
	local var_33_1 = arg_33_0:getInnerContainerSize()
	
	return var_33_0, var_33_1
end

function ItemListView.getMaxHeight(arg_34_0)
	local var_34_0 = arg_34_0:getInnerContainerSize()
	local var_34_1 = arg_34_0:getContentSize()
	
	return var_34_0.height - var_34_1.height
end

function ItemListView.setPositionVertical(arg_35_0, arg_35_1)
	arg_35_0:forceDoLayout()
	
	local var_35_0, var_35_1 = arg_35_0:getInnerSizeAndPos()
	local var_35_2 = var_35_1.height * arg_35_1
	
	var_35_0.y = math.max(-1 * arg_35_0:getMaxHeight(), var_35_2)
	
	arg_35_0:setInnerContainerPosition(var_35_0)
end

function ItemListView.setItemsKeepPos(arg_36_0, arg_36_1)
	local var_36_0 = false
	local var_36_1, var_36_2 = arg_36_0:getInnerSizeAndPos()
	
	if var_36_2.height < 1 then
		var_36_2.height = 1
		var_36_0 = true
	end
	
	local var_36_3 = var_36_1.y / var_36_2.height
	
	arg_36_0:removeAllChildren()
	arg_36_0:addItems(arg_36_1)
	
	if var_36_0 then
		arg_36_0:jumpToTop()
	else
		arg_36_0:setPositionVertical(var_36_3)
	end
end

function ItemListView.setItems(arg_37_0, arg_37_1)
	arg_37_0:removeAllChildren()
	arg_37_0:addItems(arg_37_1)
end

function ItemListView.addItems(arg_38_0, arg_38_1)
	arg_38_0.vars.itemObjectList = arg_38_1
	
	local var_38_0 = var_0_0(arg_38_0)
	local var_38_1 = ccui.Widget:create()
	local var_38_2 = arg_38_0.vars.cascade or false
	
	var_38_1:setCascadeOpacityEnabled(var_38_2)
	var_38_1:setCascadeColorEnabled(var_38_2)
	var_38_1:setAnchorPoint(0, 0)
	var_38_1:setContentSize(arg_38_0.vars.itemRenderer:getContentSize())
	
	for iter_38_0, iter_38_1 in pairs(arg_38_1) do
		var_38_0:addChild(arg_38_0:_setupWidgetObject(var_38_1:clone(), arg_38_0.vars.itemRenderer, arg_38_0.vars.itemUpdater, iter_38_1))
	end
	
	var_38_0:setCascadeOpacityEnabled(var_38_2)
	var_38_0:forceDoLayout()
	arg_38_0:pushBackCustomItem(var_38_0)
end

function ItemListView.refresh(arg_39_0, arg_39_1)
	local var_39_0 = {}
	
	for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.controls) do
		if get_cocos_refid(iter_39_0) then
			if not arg_39_1 or arg_39_1 == iter_39_1.item then
				iter_39_1.updater()
			end
		else
			var_39_0[iter_39_0] = true
		end
	end
	
	for iter_39_2, iter_39_3 in pairs(var_39_0) do
		arg_39_0.vars.controls[iter_39_2] = nil
	end
end

function ItemListView.getControl(arg_40_0, arg_40_1)
	for iter_40_0, iter_40_1 in pairs(arg_40_0.vars.controls) do
		if get_cocos_refid(iter_40_0) and iter_40_1.item == arg_40_1 then
			return iter_40_0
		end
	end
end
