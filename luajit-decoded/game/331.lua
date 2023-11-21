DockFast = {}

copy_functions(Dock, DockFast)

function DockFast.fastInit(arg_1_0)
	arg_1_0.renderer_pool = {}
	arg_1_0.renderer_table = {}
	arg_1_0.monitoring_create = 0
end

function DockFast.create(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {}
	
	copy_functions(DockFast, var_2_0)
	var_2_0:init(arg_2_1, arg_2_2)
	var_2_0:fastInit()
	
	return var_2_0
end

function DockFast.makeRenderer(arg_3_0, arg_3_1)
	local var_3_0
	local var_3_1 = false
	
	if #arg_3_0.renderer_pool > 0 then
		var_3_0 = table.remove(arg_3_0.renderer_pool)
		var_3_0 = arg_3_0.opts.handler:updateControl(arg_3_0, var_3_0, arg_3_1)
		var_3_1 = true
	else
		var_3_0 = arg_3_0.opts.handler:createControl(arg_3_0, arg_3_1)
		
		table.insert(arg_3_0.renderer_table, var_3_0)
	end
	
	return var_3_0, var_3_1
end

function DockFast.addRendererToControl(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_1:setAnchorPoint(0, 0)
	arg_4_1:setPosition(0, 0)
	arg_4_2:addChild(arg_4_1)
	arg_4_2:setContentSize(arg_4_1:getContentSize())
	
	arg_4_2.renderer = arg_4_1
	arg_4_2.item = arg_4_3
	
	if arg_4_4 then
		arg_4_1:release()
	end
end

function DockFast.createControl(arg_5_0, arg_5_1)
	local var_5_0 = ccui.Widget:create()
	local var_5_1 = DOCK_DIR[arg_5_0.opts.dir]
	
	var_5_0:setAnchorPoint(var_5_1.ax, var_5_1.ay)
	var_5_0:setCascadeOpacityEnabled(true)
	
	if arg_5_0.opts.dir == "right" then
		var_5_0:setPositionX(arg_5_0.opts.width)
	elseif arg_5_0.opts.dir == "top" then
		var_5_0:setPositionY(arg_5_0.opts.height)
	end
	
	arg_5_0.controls[arg_5_1] = var_5_0
	
	arg_5_0.panel:addChild(var_5_0)
	
	return var_5_0
end

function DockFast.getControl(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.controls[arg_6_1]
	
	if not arg_6_2 or var_6_0 and var_6_0.renderer then
		local var_6_1 = var_6_0 and var_6_0.renderer or nil
		
		return var_6_0, var_6_1
	end
	
	var_6_0 = var_6_0 or arg_6_0:createControl(arg_6_1)
	
	local var_6_2, var_6_3 = arg_6_0:makeRenderer(arg_6_1)
	
	arg_6_0:addRendererToControl(var_6_2, var_6_0, arg_6_1, var_6_3)
	
	return var_6_0, var_6_0.renderer
end

function DockFast.getCurrentControl(arg_7_0)
	if arg_7_0.vars.cur_item then
		local var_7_0, var_7_1 = arg_7_0:getControl(arg_7_0.vars.cur_item)
		
		if var_7_1 ~= nil then
			return var_7_1
		end
	end
end

function DockFast.getRenderer(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.controls[arg_8_1]
	
	if not var_8_0 then
		return 
	end
	
	return var_8_0.renderer
end

function DockFast.updateRenderers(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.renderer_table) do
		if get_cocos_refid(iter_9_1) then
			arg_9_1(iter_9_1)
		end
	end
end

function DockFast.monitoring(arg_10_0)
	print("self.renderer_table", #arg_10_0.renderer_table)
end

function DockFast.returnToControlPool(arg_11_0, arg_11_1)
	arg_11_1.renderer:ejectFromParent()
	arg_11_1.renderer:retain()
	table.insert(arg_11_0.renderer_pool, arg_11_1.renderer)
	
	arg_11_1.renderer = nil
end

function DockFast.call_onControlPoolTiming(arg_12_0, arg_12_1)
	if arg_12_1 and arg_12_1.renderer then
		arg_12_0:returnToControlPool(arg_12_1)
	end
end

function DockFast.call_setControlScaleByAdjustPos(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_2 = arg_13_2.renderer
	
	arg_13_0.opts.handler:onSetControlScale(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
end

function DockFast.call_onSetControlScale(arg_14_0, arg_14_1, arg_14_2)
	arg_14_2 = arg_14_2.renderer
	
	arg_14_0.opts.handler:onSetControlScale(arg_14_0, arg_14_1, arg_14_2, 0)
end

function DockFast.call_onShowHandler(arg_15_0, arg_15_1, arg_15_2)
	arg_15_1 = arg_15_1.renderer
	
	arg_15_0.opts.handler.onShowItem(arg_15_0.opts.handler, arg_15_1, arg_15_2)
end

function DockFast.destroy(arg_16_0)
	for iter_16_0, iter_16_1 in pairs(arg_16_0.renderer_pool) do
		if get_cocos_refid(iter_16_1) then
			iter_16_1:release()
		end
	end
	
	arg_16_0:_destroy()
end
