FastListView = {}

copy_functions(ItemListView_v2, FastListView)

function FastListView.bindControl(arg_1_0, arg_1_1)
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
	
	copy_functions(FastListView, arg_1_1)
	
	return arg_1_1
end

function FastListView.addEnterBoundUpdater(arg_3_0, arg_3_1)
	arg_3_0.vars.onEnterBound = arg_3_1
end

function FastListView.onRefresh(arg_4_0, arg_4_1)
	arg_4_0.vars.onRefresh = arg_4_1
end

function FastListView.targetUpdate(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.controls) do
		if not get_cocos_refid(iter_5_0) then
			table.insert(var_5_0, iter_5_0)
		end
	end
	
	for iter_5_2, iter_5_3 in pairs(var_5_0) do
		arg_5_0.vars.controls[iter_5_3] = nil
	end
	
	for iter_5_4, iter_5_5 in pairs(arg_5_0.vars.controls) do
		if iter_5_5.index == arg_5_1 and get_cocos_refid(iter_5_4) then
			if arg_5_2 then
				arg_5_0.vars.dataSource[arg_5_1] = arg_5_2
			end
			
			iter_5_5.updater()
			
			return true
		end
	end
	
	Log.e("FAST LIST VIEW : TARGET UPDATE NOT FOUND ")
end

function FastListView._setupWidgetObject(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local function var_6_0(arg_7_0)
		if arg_7_0 == "enterInsideBounds" then
			if get_cocos_refid(arg_6_1.rendererInst) then
				if_set_visible(arg_6_1.rendererInst, nil, true)
				
				if arg_6_0.vars.onEnterBound then
					arg_6_0.vars.onEnterBound(arg_6_1.rendererInst, arg_6_4, arg_6_0.vars.dataSource[arg_6_4])
				end
				
				return 
			end
			
			local var_7_0 = arg_6_2:clone()
			
			local function var_7_1(arg_8_0)
				if get_cocos_refid(var_7_0) and (arg_8_0 or not arg_6_0.vars.onRefresh) then
					local var_8_0 = arg_6_0.vars.dataSource[arg_6_4]
					local var_8_1 = arg_6_3:onUpdate(var_7_0, arg_6_4, var_8_0)
					
					if var_8_1 then
						var_7_0:setName(var_8_1)
					end
					
					arg_6_0.vars.controls[var_7_0].index = arg_6_4
					arg_6_0.vars.controls[var_7_0].item = var_8_0
				elseif get_cocos_refid(var_7_0) and arg_6_0.vars.onRefresh then
					arg_6_0.vars.onRefresh(arg_6_1.rendererInst, arg_6_4, arg_6_0.vars.dataSource[arg_6_4])
				end
			end
			
			arg_6_0.vars.controls[var_7_0] = {
				index = arg_6_4,
				item = arg_6_0.vars.dataSource[arg_6_4],
				updater = var_7_1
			}
			
			var_7_1(true)
			arg_6_1:addChild(var_7_0)
			
			arg_6_1.rendererInst = var_7_0
		end
		
		if arg_7_0 == "exitInsideBounds" then
			if_set_visible(arg_6_1.rendererInst, nil, false)
		end
	end
	
	arg_6_1:setTag(arg_6_4)
	arg_6_1:registerScriptHandler(var_6_0)
	
	return arg_6_1
end

function __listview_test()
	local var_9_0 = SceneManager:getRunningNativeScene()
	local var_9_1 = load_dlg("unit_storage", true, "wnd")
	
	var_9_0:addChild(var_9_1)
	
	local var_9_2 = FastListView_v2:bindControl(var_9_1:getChildByName("listview"))
	local var_9_3 = {
		onUpdate = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			UIUtil:updateUnitBar("Storage", arg_10_3, {
				force_update = true,
				wnd = arg_10_1:findChildByName("n_unit_bar")
			})
			
			return arg_10_2
		end
	}
	local var_9_4 = load_control("wnd/unit_storage_item.csb")
	local var_9_5 = load_control("wnd/unit_bar.csb")
	
	var_9_4:findChildByName("n_unit_bar"):addChild(var_9_5)
	var_9_2:setRenderer(var_9_4, var_9_3, 60)
	var_9_2:removeAllChildren()
	var_9_2:setDataSource(Account:getUnits())
	var_9_2:jumpToTop()
end

FastListView_v2 = {}

copy_functions(ItemListView_v2, FastListView_v2)

function FastListView_v2.bindControl(arg_11_0, arg_11_1)
	arg_11_1.vars = {}
	
	arg_11_1:setBounceEnabled(true)
	
	if type(arg_11_1.setItemsMargin) == "function" then
		arg_11_1:setItemsMargin(0)
	end
	
	arg_11_1:removeAllChildren()
	arg_11_1:setLayoutType(ccui.LayoutType.TILED_VERTICAL)
	arg_11_1:getInnerContainer():setAutoSizeEnabled(true)
	arg_11_1:setSwallowTouches(true)
	
	if arg_11_1.STRETCH_INFO then
		function arg_11_1.scene_reload_callback()
			arg_11_1:clearListView()
			arg_11_1:setDataSource(arg_11_1.vars.dataSource)
		end
	end
	
	copy_functions(FastListView_v2, arg_11_1)
	
	return arg_11_1
end

function FastListView_v2.setRenderer(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0.vars.pool_count = arg_13_3 or 40
	arg_13_0.vars.itemRenderer = arg_13_1
	
	arg_13_0.vars.itemRenderer:retain()
	
	arg_13_0.vars.itemUpdater = arg_13_2
	arg_13_0.vars.controls = {}
	arg_13_0.vars.renderer_usable_pool = {}
	arg_13_0.vars.renderer_not_usable_pool = {}
	
	cc.AutoreleasePool:addObjectWithTarget(arg_13_0.vars.itemRenderer, arg_13_0)
	
	for iter_13_0 = 1, arg_13_0.vars.pool_count do
		local var_13_0 = arg_13_0.vars.itemRenderer:clone()
		
		var_13_0:retain()
		cc.AutoreleasePool:addObjectWithTarget(var_13_0, arg_13_0)
		
		arg_13_0.vars.renderer_usable_pool[var_13_0] = var_13_0
	end
end

function FastListView_v2.getRendererFromPool(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.renderer_usable_pool) do
		return iter_14_1
	end
	
	return nil
end

function FastListView_v2._setupWidgetObject(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local function var_15_0(arg_16_0)
		if arg_16_0 == "enterInsideBounds" then
			if get_cocos_refid(arg_15_1.rendererInst) then
				if_set_visible(arg_15_1.rendererInst, nil, true)
				
				if arg_15_0.vars.onEnterBound then
					arg_15_0.vars.onEnterBound(arg_15_1.rendererInst, arg_15_4, arg_15_0.vars.dataSource[arg_15_4])
				end
				
				return 
			end
			
			local var_16_0 = arg_15_0:getRendererFromPool()
			
			if not var_16_0 or var_16_0:getParent() ~= nil then
				print("WHAT THE...")
				
				return 
			end
			
			local function var_16_1(arg_17_0)
				if get_cocos_refid(var_16_0) and (arg_17_0 or not arg_15_0.vars.onRefresh) then
					local var_17_0 = arg_15_0.vars.dataSource[arg_15_4]
					local var_17_1 = arg_15_3:onUpdate(var_16_0, arg_15_4, var_17_0)
					
					if var_17_1 then
						var_16_0:setName(var_17_1)
					end
					
					arg_15_0.vars.controls[var_16_0].index = arg_15_4
					arg_15_0.vars.controls[var_16_0].item = var_17_0
				end
			end
			
			var_16_0:setVisible(true)
			
			arg_15_0.vars.controls[var_16_0] = {
				index = arg_15_4,
				item = arg_15_0.vars.dataSource[arg_15_4],
				updater = var_16_1
			}
			
			var_16_1(true)
			arg_15_1:addChild(var_16_0)
			
			arg_15_1.rendererInst = var_16_0
			arg_15_0.vars.renderer_usable_pool[arg_15_1.rendererInst] = nil
			arg_15_0.vars.renderer_not_usable_pool[arg_15_1.rendererInst] = arg_15_1.rendererInst
		end
		
		if arg_16_0 == "exitInsideBounds" then
			if_set_visible(arg_15_1.rendererInst, nil, false)
			
			if arg_15_1.rendererInst then
				arg_15_0.vars.renderer_usable_pool[arg_15_1.rendererInst] = arg_15_1.rendererInst
				arg_15_0.vars.renderer_not_usable_pool[arg_15_1.rendererInst] = nil
				
				arg_15_1.rendererInst:removeFromParent()
				
				arg_15_1.rendererInst = nil
			end
		end
	end
	
	arg_15_1:setTag(arg_15_4)
	arg_15_1:registerScriptHandler(var_15_0)
	
	return arg_15_1
end

function FastListView_v2.clearListView(arg_18_0)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.renderer_not_usable_pool) do
		local var_18_0 = iter_18_1:getParent()
		
		if var_18_0 then
			var_18_0.rendererInst = nil
		end
		
		arg_18_0.vars.renderer_usable_pool[iter_18_1] = iter_18_1
		arg_18_0.vars.renderer_not_usable_pool[iter_18_1] = nil
		
		iter_18_1:removeFromParent()
	end
	
	arg_18_0:removeAllChildren()
end
