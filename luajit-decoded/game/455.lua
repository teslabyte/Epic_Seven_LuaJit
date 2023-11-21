BGSelector = {}

copy_functions(ScrollView, BGSelector)

DEBUG.BG_SHOW_ALL = nil

function HANDLER.bg_change_popup(arg_1_0, arg_1_1)
end

function BGSelector.getScrollViewItem(arg_2_0, arg_2_1)
	local var_2_0 = load_control("wnd/bg_change_popup_item.csb")
	
	if_set_visible(var_2_0, "bg_select", false)
	if_set_sprite(var_2_0, "bg_base", arg_2_1.icon)
	if_set_visible(var_2_0, "icon_new", arg_2_1.isNew)
	
	if not arg_2_1.unlock then
		if_set_opacity(var_2_0, nil, 76.5)
	end
	
	return var_2_0
end

function BGSelector.getIdxById(arg_3_0, arg_3_1)
	local var_3_0
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.items) do
		if iter_3_1.id == arg_3_1 then
			var_3_0 = iter_3_0
		end
	end
	
	return var_3_0
end

function BGSelector.setToIndex(arg_4_0, arg_4_1)
	if not arg_4_0.ScrollViewItems[arg_4_1] then
		return 
	end
	
	arg_4_0:onSelectScrollViewItem(arg_4_1, arg_4_0.ScrollViewItems[arg_4_1])
end

function BGSelector.setToID(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:getIdxById(arg_5_1)
	
	if not var_5_0 then
		return 
	end
	
	arg_5_0:callEvent(var_5_0)
	
	return var_5_0
end

function BGSelector.getIdx(arg_6_0, arg_6_1)
	local var_6_0
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.vars.items) do
		if iter_6_1.id == arg_6_1 then
			var_6_0 = iter_6_0
		end
	end
	
	return var_6_0
end

function BGSelector.callEvent(arg_7_0, arg_7_1)
	if arg_7_0.vars.event then
		arg_7_0.vars.event(arg_7_1, arg_7_0.vars.items[arg_7_1])
	end
end

function BGSelector.onSelectScrollViewItem(arg_8_0, arg_8_1, arg_8_2)
	if UIAction:Find("bg.fade") then
		return 
	end
	
	if arg_8_0.vars.event then
		arg_8_0.vars.event(arg_8_1, arg_8_2.item)
	end
	
	local var_8_0 = arg_8_2.control:getChildByName("bg_select")
	
	if not get_cocos_refid(var_8_0) then
		return 
	end
	
	if var_8_0:isVisible() and arg_8_0.vars.prv_idx == arg_8_1 then
		return 
	end
	
	if_set_visible(arg_8_2.control, "bg_select", true)
	if_set_visible(arg_8_0.vars.prv_item, "bg_select", false)
	
	arg_8_0.vars.prv_idx = arg_8_1
	arg_8_0.vars.prv_item = arg_8_2.control
end

function make_bgpack_item(arg_9_0)
	local var_9_0, var_9_1, var_9_2, var_9_3, var_9_4, var_9_5, var_9_6, var_9_7, var_9_8 = DB("item_material_bgpack", arg_9_0, {
		"id",
		"background_id",
		"bg_scale",
		"bg_position",
		"bg_scale_pet",
		"bg_position_pet",
		"bg_scale_hero",
		"bg_position_hero",
		"ambient_color"
	})
	
	if not var_9_0 then
		return 
	end
	
	local var_9_9, var_9_10, var_9_11 = DB("item_material", var_9_0, {
		"name",
		"sort",
		"desc"
	})
	
	return {
		id = var_9_0,
		bg_id = var_9_1,
		bg_scale = var_9_2,
		bg_position = var_9_3,
		bg_scale_pet = var_9_4,
		bg_position_pet = var_9_5,
		bg_scale_hero = var_9_6,
		bg_position_hero = var_9_7,
		ambient_color = var_9_8,
		name = var_9_9,
		desc = var_9_11,
		sort = var_9_10
	}
end

function get_material_bgpack_data(arg_10_0, arg_10_1)
	local var_10_0 = {}
	local var_10_1 = {
		ma_bg_lobby3 = true,
		ma_bg_lobby2 = true,
		ma_bg_lobby4 = true,
		ma_bg_lobby1 = true
	}
	
	for iter_10_0 = 1, 999 do
		local var_10_2, var_10_3, var_10_4, var_10_5, var_10_6, var_10_7, var_10_8, var_10_9, var_10_10 = DBN("item_material_bgpack", iter_10_0, {
			"id",
			"background_id",
			"bg_scale",
			"bg_position",
			"bg_scale_pet",
			"bg_position_pet",
			"bg_scale_hero",
			"bg_position_hero",
			"ambient_color"
		})
		
		if not var_10_2 then
			break
		end
		
		local var_10_11, var_10_12, var_10_13 = DB("item_material", var_10_2, {
			"name",
			"sort",
			"desc"
		})
		local var_10_14 = UIUtil:getIconPath(var_10_2)
		local var_10_15 = Account:getItemCount(var_10_2) > 0 or DEBUG.BG_SHOW_ALL
		
		if var_10_2 == "ma_bg_base_old" then
			var_10_3 = "bgpack/bg_base_old.png"
		end
		
		if var_10_2 == "ma_bg_base_old" and arg_10_1 ~= "UnitZoom" and arg_10_1 ~= "UnitInfos" then
			var_10_15 = false
		end
		
		if var_10_2 == "ma_bg_base" and (arg_10_1 == "UnitZoom" or arg_10_1 == "UnitInfos") then
			var_10_15 = true
			var_10_3 = "lobby"
		elseif DEBUG.BG_SHOW_ALL and var_10_2 == "ma_bg_base" and arg_10_1 ~= "UnitZoom" and arg_10_1 ~= "UnitInfos" then
			var_10_15 = false
		end
		
		if var_10_2 == "ma_bg_pet_base" and arg_10_1 == "PetHouse" then
			var_10_15 = true
		elseif DEBUG.BG_SHOW_ALL and var_10_2 == "ma_bg_pet_base" and arg_10_1 ~= "PetHouse" then
			var_10_15 = false
		end
		
		if arg_10_1 == "CustomLobby" and var_10_1[var_10_2] then
			var_10_15 = true
		elseif DEBUG.BG_SHOW_ALL and var_10_1[var_10_2] and arg_10_1 ~= "CustomLobby" then
			var_10_15 = false
		end
		
		if not var_10_12 then
			var_10_15 = false
		end
		
		if var_10_15 then
			local var_10_16 = SAVE:getUserDefaultData("zoom_newCheck_data_" .. AccountData.id .. "_" .. var_10_2, true)
			local var_10_17 = {
				id = var_10_2,
				bg_id = var_10_3,
				bg_scale = var_10_4,
				bg_position = var_10_5,
				bg_scale_pet = var_10_6,
				bg_position_pet = var_10_7,
				bg_scale_hero = var_10_8,
				bg_position_hero = var_10_9,
				ambient_color = var_10_10,
				name = var_10_11,
				desc = var_10_13,
				icon = var_10_14,
				unlock = var_10_15,
				sort = var_10_12,
				isNew = var_10_16
			}
			
			table.insert(var_10_0, var_10_17)
			
			if not arg_10_0 then
				SAVE:setUserDefaultData("zoom_newCheck_data_" .. AccountData.id .. "_" .. var_10_2, false)
			end
		end
	end
	
	return var_10_0
end

function BGSelector.createData(arg_11_0, arg_11_1)
	local var_11_0 = get_material_bgpack_data(arg_11_1, arg_11_0.vars.mode)
	
	table.sort(var_11_0, function(arg_12_0, arg_12_1)
		return arg_12_0.sort < arg_12_1.sort
	end)
	
	arg_11_0.vars.items = var_11_0
end

function BGSelector.dataInit(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0.vars = {}
	arg_13_0.vars.mode = arg_13_1
	arg_13_0.vars.event = arg_13_2
	
	arg_13_0:createData(arg_13_3)
end

function BGSelector.init(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if arg_14_3 == "PetHouse" then
		arg_14_1:setContentSize(arg_14_1:getContentSize().width, 366)
	end
	
	arg_14_0:initScrollView(arg_14_1, 134, 133)
	
	if not arg_14_0.vars or arg_14_0.vars.mode ~= arg_14_3 then
		arg_14_0.vars = {}
		arg_14_0.vars.event = arg_14_2
		arg_14_0.vars.mode = arg_14_3
	end
	
	arg_14_0:createData()
	arg_14_0:setScrollViewItems(arg_14_0.vars.items)
	
	if arg_14_4 then
		arg_14_0:setToIndex(arg_14_4)
	end
end

function BGSelector.close(arg_15_0)
	arg_15_0.vars.prv_idx = nil
	arg_15_0.vars.prv_item = nil
end

function BGSelector.remove(arg_16_0)
	arg_16_0.vars = nil
end
