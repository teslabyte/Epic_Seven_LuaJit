CustomProfileCardShape = {}

function HANDLER.shape_color_plate(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_") then
		local var_1_0 = string.len("btn_")
		local var_1_1 = string.sub(arg_1_1, var_1_0 + 1, -1)
		
		CustomProfileCardShape:setShapeColor(var_1_1)
	end
end

function CustomProfileCardShape.create(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.shape_tab = arg_2_1.n_tab
	arg_2_0.vars.shape_wnd = arg_2_1.category_wnd
	arg_2_0.vars.shape_plate = load_control("wnd/profile_custom_color_plate.csb")
	
	arg_2_0.vars.shape_plate:setName("shape_color_plate")
	arg_2_0:initDB()
	arg_2_0:initUI()
end

function CustomProfileCardShape.release(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.shape_tab) or not get_cocos_refid(arg_3_0.vars.shape_wnd) or not get_cocos_refid(arg_3_0.vars.shape_plate) then
		return 
	end
	
	if not get_cocos_refid(arg_3_0.vars.listview) then
		return 
	end
	
	arg_3_0.vars.listview:removeAllChildren()
	arg_3_0.vars.listview:setDataSource(nil)
	
	arg_3_0.vars.listview = nil
	arg_3_0.vars.shape_tab = nil
	arg_3_0.vars.shape_wnd = nil
	
	arg_3_0.vars.shape_plate:removeFromParent()
	
	arg_3_0.vars.shape_plate = nil
	arg_3_0.vars = nil
end

function CustomProfileCardShape.initDB(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.shape_tab) or not get_cocos_refid(arg_4_0.vars.shape_wnd) or not get_cocos_refid(arg_4_0.vars.shape_plate) then
		return 
	end
	
	arg_4_0.vars.shape_items = {}
	
	for iter_4_0 = 1, 9999 do
		local var_4_0, var_4_1, var_4_2 = DBN("item_material_profile", iter_4_0, {
			"id",
			"material_id",
			"type"
		})
		
		if not var_4_0 then
			break
		end
		
		local var_4_3 = CustomProfileCardEditor:isNeedHideCheckLayerItem(var_4_0)
		
		if var_4_2 == "shape" and var_4_1 and (not var_4_3 or Account:getItemCount(var_4_1) > 0) then
			local var_4_4 = DBT("item_material", var_4_1, {
				"sort",
				"ma_type",
				"drop_icon",
				"desc"
			})
			
			table.insert(arg_4_0.vars.shape_items, {
				id = var_4_0,
				material_id = var_4_1,
				sort = var_4_4.sort,
				content_type = var_4_4.ma_type,
				type = var_4_2,
				icon = var_4_4.drop_icon,
				desc = var_4_4.desc
			})
		end
	end
	
	table.sort(arg_4_0.vars.shape_items, function(arg_5_0, arg_5_1)
		return arg_5_0.sort < arg_5_1.sort
	end)
	
	arg_4_0.vars.shape_color_list = {}
	
	local var_4_5 = arg_4_0.vars.shape_plate:getChildByName("n_plate")
	local var_4_6
	
	if get_cocos_refid(var_4_5) then
		var_4_6 = 1
		
		for iter_4_1, iter_4_2 in pairs(var_4_5:getChildren()) do
			if get_cocos_refid(iter_4_2) then
				local var_4_7 = iter_4_2:getChildByName("n_color_" .. var_4_6)
				
				if get_cocos_refid(iter_4_2) then
					local var_4_8 = var_4_7:getColor()
					
					table.insert(arg_4_0.vars.shape_color_list, var_4_8)
					
					var_4_6 = var_4_6 + 1
				end
			end
		end
	end
end

function CustomProfileCardShape.initUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.shape_tab) or not get_cocos_refid(arg_6_0.vars.shape_wnd) or not get_cocos_refid(arg_6_0.vars.shape_plate) then
		return 
	end
	
	if table.empty(arg_6_0.vars.shape_items) then
		return 
	end
	
	arg_6_0.vars.listview = ItemListView_v2:bindControl(arg_6_0.vars.shape_wnd:getChildByName("listview_shape"))
	
	local var_6_0 = {
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			arg_6_0:updateListViewItem(arg_7_1, arg_7_3)
			
			return arg_7_3.id
		end
	}
	local var_6_1 = load_control("wnd/profile_custom_shape_card.csb")
	
	arg_6_0.vars.listview:setRenderer(var_6_1, var_6_0)
	arg_6_0:setListItems()
	
	local var_6_2 = arg_6_0.vars.shape_wnd:getChildByName("n_plate")
	
	if get_cocos_refid(var_6_2) then
		var_6_2:addChild(arg_6_0.vars.shape_plate)
		
		local var_6_3 = arg_6_0.vars.shape_plate:getChildByName("n_plate")
		
		if get_cocos_refid(var_6_3) then
			for iter_6_0, iter_6_1 in pairs(var_6_3:getChildren()) do
				if get_cocos_refid(iter_6_1) then
					if_set_visible(iter_6_1, "n_select", false)
				end
			end
		end
	end
	
	arg_6_0.vars.shape_opacity_slider = arg_6_0.vars.shape_wnd:getChildByName("n_slider")
	
	local var_6_4 = arg_6_0.vars.shape_opacity_slider:getChildByName("slider")
	
	if get_cocos_refid(var_6_4) then
		var_6_4:addEventListener(Dialog.defaultSliderEventHandler)
		var_6_4:setPercent(100)
		var_6_4:setMaxPercent(100)
		
		var_6_4.min = 0
		var_6_4.max = 100
		
		function var_6_4.handler(arg_8_0, arg_8_1, arg_8_2)
			if CustomProfileCardEditor:getCurrnetCatrgory() ~= "shape" then
				return 
			end
			
			local var_8_0 = CustomProfileCardEditor:getFocusLayer()
			
			if var_8_0 and var_8_0:getType() == "shape" then
				if arg_8_2 == 0 then
					if not var_6_4.before then
						var_6_4.before = var_8_0:getOpacityRate()
					end
					
					if var_8_0:getOpacityRate() ~= arg_8_1 then
						var_8_0:setOpacityRate(arg_8_1)
					end
				elseif arg_8_2 == 1 then
					if not var_6_4.before then
						var_6_4.before = var_8_0:getOpacityRate()
					end
				else
					local var_8_1 = var_6_4.before
					local var_8_2 = arg_8_1
					
					CustomProfileCardEditor:getLayerCommand():pushUndo({
						layer = var_8_0,
						undo_func = bind_func(var_8_0.setOpacityRate, var_8_0, var_8_1),
						redo_func = bind_func(var_8_0.setOpacityRate, var_8_0, var_8_2)
					}, true)
					
					var_6_4.before = nil
				end
			end
			
			if_set(arg_6_0.vars.shape_opacity_slider, "txt_result", arg_8_1)
		end
		
		if_set(arg_6_0.vars.shape_opacity_slider, "txt_result", 100)
	end
end

function CustomProfileCardShape.setListItems(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.shape_wnd) or not get_cocos_refid(arg_9_0.vars.listview) then
		return 
	end
	
	if table.empty(arg_9_0.vars.shape_items) then
		return 
	end
	
	arg_9_0.vars.listview:removeAllChildren()
	table.sort(arg_9_0.vars.shape_items, function(arg_10_0, arg_10_1)
		local var_10_0, var_10_1 = CustomProfileCardEditor:checkLayerItemUnlock(arg_10_0.id)
		local var_10_2, var_10_3 = CustomProfileCardEditor:checkLayerItemUnlock(arg_10_1.id)
		
		if var_10_0 and var_10_2 then
			return arg_10_0.sort < arg_10_1.sort
		end
		
		if var_10_0 or var_10_2 then
			return var_10_0 and not var_10_2
		end
		
		return arg_10_0.sort < arg_10_1.sort
	end)
	arg_9_0.vars.listview:setDataSource(arg_9_0.vars.shape_items)
	arg_9_0.vars.listview:jumpToTop()
end

function CustomProfileCardShape.updateListViewItem(arg_11_0, arg_11_1, arg_11_2)
	if not get_cocos_refid(arg_11_1) or not arg_11_2 then
		return 
	end
	
	local var_11_0 = arg_11_2.id
	
	if var_11_0 then
		local var_11_1 = arg_11_1:getChildByName("btn_select")
		
		var_11_1.item = arg_11_2
		
		if arg_11_2.content_type and arg_11_2.type and arg_11_2.icon then
			if_set_sprite(arg_11_1, "n_shape_s", arg_11_2.content_type .. "/" .. arg_11_2.type .. "/" .. arg_11_2.icon .. ".png")
		end
		
		local var_11_2, var_11_3 = CustomProfileCardEditor:checkLayerItemUnlock(var_11_0)
		
		if var_11_2 then
			var_11_1.callback = arg_11_0.createShapeLayer
		end
		
		if_set_opacity(arg_11_1, "n_shape_s", var_11_2 and 255 or 76.5)
		if_set_visible(arg_11_1, "icon_locked", not var_11_2)
		
		if var_11_3 then
			if_set_visible(arg_11_1, "n_shop", var_11_3 == "purchase" and not var_11_2)
			
			if var_11_3 == "purchase" and not var_11_2 then
				function var_11_1.after_buy_callback()
					arg_11_0:setListItems()
				end
			end
		end
	end
end

function CustomProfileCardShape.resetUI(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.shape_tab) or not get_cocos_refid(arg_13_0.vars.shape_wnd) or not get_cocos_refid(arg_13_0.vars.shape_plate) then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.shape_opacity_slider) then
		return 
	end
	
	if_set_visible(arg_13_0.vars.shape_tab, "bg_tab", false)
	if_set_visible(arg_13_0.vars.shape_wnd, nil, false)
	if_set_visible(arg_13_0.vars.shape_wnd, "listview_shape", true)
	if_set_visible(arg_13_0.vars.shape_wnd, "n_detail", false)
	
	local var_13_0 = arg_13_0.vars.shape_plate:getChildByName("n_plate")
	
	if get_cocos_refid(var_13_0) then
		for iter_13_0, iter_13_1 in pairs(var_13_0:getChildren()) do
			if get_cocos_refid(iter_13_1) then
				if_set_visible(iter_13_1, "n_select", false)
			end
		end
	end
	
	local var_13_1 = arg_13_0.vars.shape_opacity_slider:getChildByName("slider")
	
	if get_cocos_refid(var_13_1) then
		var_13_1:addEventListener(function()
		end)
		var_13_1:setPercent(100)
		
		var_13_1.before = nil
		
		if_set(arg_13_0.vars.shape_opacity_slider, "txt_result", 100)
	end
	
	if_set_opacity(arg_13_0.vars.shape_wnd, "btn_copy", 76.5)
end

function CustomProfileCardShape.setUI(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.shape_tab) or not get_cocos_refid(arg_15_0.vars.shape_wnd) or not get_cocos_refid(arg_15_0.vars.shape_plate) then
		return 
	end
	
	if not get_cocos_refid(arg_15_0.vars.shape_opacity_slider) then
		return 
	end
	
	if_set_visible(arg_15_0.vars.shape_tab, "bg_tab", true)
	if_set_visible(arg_15_0.vars.shape_wnd, nil, true)
	
	local var_15_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_15_0 and var_15_0:getType() == "shape" then
		if_set_visible(arg_15_0.vars.shape_wnd, "listview_shape", false)
		if_set_visible(arg_15_0.vars.shape_wnd, "n_detail", true)
		
		local var_15_1 = var_15_0:getId()
		local var_15_2 = var_15_0:getShapeColor()
		
		arg_15_0:setPreviewShape(var_15_1, var_15_2)
		
		local var_15_3 = arg_15_0:getColorID(var_15_2)
		
		if var_15_3 ~= nil then
			local var_15_4 = arg_15_0.vars.shape_plate:getChildByName("n_plate")
			
			if get_cocos_refid(var_15_4) then
				local var_15_5 = var_15_4:getChildByName("n_" .. var_15_3)
				
				if get_cocos_refid(var_15_5) then
					if_set_visible(var_15_5, "n_select", true)
				end
			end
		end
		
		local var_15_6 = var_15_0:getOpacityRate()
		local var_15_7 = arg_15_0.vars.shape_opacity_slider:getChildByName("slider")
		
		if get_cocos_refid(var_15_7) then
			var_15_7:setPercent(var_15_6)
			var_15_7:addEventListener(Dialog.defaultSliderEventHandler)
			if_set(arg_15_0.vars.shape_opacity_slider, "txt_result", var_15_6)
		end
		
		if_set_opacity(arg_15_0.vars.shape_wnd, "btn_copy", 255)
	else
		if_set_visible(arg_15_0.vars.shape_wnd, "listview_shape", true)
		if_set_visible(arg_15_0.vars.shape_wnd, "n_detail", false)
		if_set_opacity(arg_15_0.vars.shape_wnd, "btn_copy", 76.5)
	end
end

function CustomProfileCardShape.getColorID(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.shape_plate) or table.empty(arg_16_0.vars.shape_color_list) or table.empty(arg_16_1) then
		return nil
	end
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.shape_color_list) do
		local var_16_0 = true
		
		if arg_16_1.r and iter_16_1.r and arg_16_1.r ~= iter_16_1.r then
			var_16_0 = false
		end
		
		if arg_16_1.g and iter_16_1.g and arg_16_1.g ~= iter_16_1.g then
			var_16_0 = false
		end
		
		if arg_16_1.b and iter_16_1.b and arg_16_1.b ~= iter_16_1.b then
			var_16_0 = false
		end
		
		if var_16_0 then
			return iter_16_0
		end
	end
	
	return nil
end

function CustomProfileCardShape.createShapeLayer(arg_17_0, arg_17_1)
	if table.empty(arg_17_1) or not arg_17_1.type or arg_17_1.type ~= "shape" or not arg_17_1.id then
		return 
	end
	
	CustomProfileCardEditor:createLayer({
		type = arg_17_1.type,
		id = arg_17_1.id
	})
end

function CustomProfileCardShape.setPreviewShape(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.shape_wnd) then
		return 
	end
	
	if not arg_18_1 or type(arg_18_1) ~= "string" or table.empty(arg_18_2) then
		return 
	end
	
	if table.empty(arg_18_0.vars.shape_items) then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.shape_wnd:getChildByName("icon_shape")
	
	if get_cocos_refid(var_18_0) then
		for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.shape_items) do
			if iter_18_1.id == arg_18_1 and iter_18_1.content_type and iter_18_1.type and iter_18_1.icon then
				if_set_sprite(var_18_0, nil, iter_18_1.content_type .. "/" .. iter_18_1.type .. "/" .. iter_18_1.icon .. ".png")
				var_18_0:setColor(cc.c3b(arg_18_2.r, arg_18_2.g, arg_18_2.b))
				
				return 
			end
		end
	end
end

function CustomProfileCardShape.setShapeColor(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.shape_plate) then
		return 
	end
	
	if table.empty(arg_19_0.vars.shape_color_list) or not arg_19_1 then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.shape_color_list[tonumber(arg_19_1)]
	
	if table.empty(var_19_0) then
		return 
	end
	
	local var_19_1 = CustomProfileCardEditor:getFocusLayer()
	
	if var_19_1 and var_19_1:getType() == "shape" then
		var_19_1:setColor(var_19_0)
		
		if var_19_1.sync_layer_view_callback and type(var_19_1.sync_layer_view_callback) == "function" then
			var_19_1:sync_layer_view_callback()
		end
		
		local var_19_2 = arg_19_0.vars.shape_wnd:getChildByName("icon_shape")
		
		if get_cocos_refid(var_19_2) then
			var_19_2:setColor(cc.c3b(var_19_0.r, var_19_0.g, var_19_0.b))
		end
		
		local var_19_3 = arg_19_0.vars.shape_plate:getChildByName("n_plate")
		
		if get_cocos_refid(var_19_3) then
			for iter_19_0, iter_19_1 in pairs(var_19_3:getChildren()) do
				if get_cocos_refid(iter_19_1) then
					if_set_visible(iter_19_1, "n_select", false)
				end
			end
		end
		
		local var_19_4 = var_19_3:getChildByName("n_" .. arg_19_1)
		
		if get_cocos_refid(var_19_4) then
			if_set_visible(var_19_4, "n_select", true)
		end
	end
end
