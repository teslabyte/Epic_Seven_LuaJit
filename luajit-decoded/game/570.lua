ItemSelectBoxDual = {}

function HANDLER.inventory_box_dual_choose(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" or arg_1_1 == "btn_cancel" then
		ItemSelectBoxDual:close()
	elseif arg_1_1 == "btn_ok" then
		ItemSelectBoxDual:select()
	elseif arg_1_1 == "btn_min" then
		ItemSelectBoxDual:min()
	elseif arg_1_1 == "btn_minus" then
		ItemSelectBoxDual:minus()
	elseif arg_1_1 == "btn_plus" then
		ItemSelectBoxDual:plus()
	elseif arg_1_1 == "btn_max" then
		ItemSelectBoxDual:max()
	end
end

function ItemSelectBoxDual.open(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if not arg_2_2 or not arg_2_3 then
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.layer = arg_2_1
	arg_2_0.vars.code = arg_2_2
	arg_2_0.vars.mode = arg_2_3 or "equip_set"
	arg_2_0.vars.callback = arg_2_4
	arg_2_0.vars.step1 = nil
	arg_2_0.vars.step2 = nil
	arg_2_0.vars.count = 1
	arg_2_0.vars.actual_count = Account:getItemCount(arg_2_2)
	arg_2_0.vars.max_count = arg_2_0.vars.actual_count
	
	if Account:checkItemSpecialInternalItemUnitOrEquip(arg_2_2) then
		arg_2_0.vars.max_count = math.min(10, arg_2_0.vars.max_count)
	end
	
	local var_2_0 = {}
	
	var_2_0.ma_type, var_2_0.ma_type2, var_2_0.select_title, var_2_0.select_desc, var_2_0.name = DB("item_material", arg_2_2, {
		"ma_type",
		"ma_type2",
		"select_title",
		"select_desc",
		"name"
	})
	arg_2_0.vars.ma_item = var_2_0
	
	if arg_2_0.vars.mode == "equip_set" then
		if not var_2_0.ma_type == "multi_eq_select" then
			Log.e("invalid_item:" .. arg_2_2)
			
			return 
		end
	elseif not var_2_0.ma_type == "multi_select" then
		Log.e("invalid_item:" .. arg_2_2)
		
		return 
	end
	
	local var_2_1 = {}
	
	var_2_1.id, var_2_1.type, var_2_1.value = DB("item_special", var_2_0.ma_type2, {
		"id",
		"type",
		"value"
	})
	
	if not var_2_1.id or var_2_1.type ~= "eq_option" then
		Log.e("item_not_found:" .. var_2_0.ma_type2)
		
		return 
	end
	
	arg_2_0.vars.item_material = var_2_1
	arg_2_0.vars.item_special = {}
	arg_2_0.vars.item_special_id = {}
	
	local var_2_2 = {}
	
	for iter_2_0 = 1, 99999 do
		local var_2_3 = {}
		
		var_2_3.id, var_2_3.item_special_value, var_2_3.item_id = DBN("option", iter_2_0, {
			"id",
			"item_special_value",
			"item_id"
		})
		
		if not var_2_3.id then
			break
		end
		
		if var_2_3.item_special_value == arg_2_0.vars.item_material.value then
			local var_2_4 = {}
			
			var_2_4.id, var_2_4.name, var_2_4.type, var_2_4.value, var_2_4.icon = DB("item_special", var_2_3.item_id, {
				"id",
				"name",
				"type",
				"value",
				"icon"
			})
			
			if not var_2_4.id then
				Log.e("item_not_found:" .. var_2_3.item_id .. " in:" .. arg_2_0.vars.item_material.value)
				
				return 
			end
			
			var_2_2[var_2_4.value] = var_2_3.item_id
			
			table.push(arg_2_0.vars.item_special_id, var_2_3.item_id)
			
			arg_2_0.vars.item_special[var_2_3.item_id] = {}
			arg_2_0.vars.item_special[var_2_3.item_id].item = var_2_4
			arg_2_0.vars.item_special[var_2_3.item_id].step2_items = {}
		end
	end
	
	for iter_2_1 = 1, 99999 do
		local var_2_5 = {}
		
		var_2_5.id, var_2_5.item_special_value, var_2_5.item_id, var_2_5.value, var_2_5.type, var_2_5.grade_rate, var_2_5.set_drop = DBN("option", iter_2_1, {
			"id",
			"item_special_value",
			"item_id",
			"value",
			"type",
			"grade_rate",
			"set_drop"
		})
		
		if not var_2_5.id then
			break
		end
		
		if var_2_2[var_2_5.item_special_value] then
			local var_2_6 = arg_2_0.vars.item_special[var_2_2[var_2_5.item_special_value]]
			
			if var_2_6 and var_2_6.step2_items then
				table.push(var_2_6.step2_items, var_2_5)
			end
		end
	end
	
	arg_2_0.vars.dlg = Dialog:open("wnd/inventory_box_dual_choose", arg_2_0, {
		modal = true,
		use_backbutton = true
	})
	
	arg_2_1:addChild(arg_2_0.vars.dlg)
	if_set(arg_2_0.vars.dlg, "txt_title", T(var_2_0.select_title))
	if_set(arg_2_0.vars.dlg, "txt_info", T(var_2_0.select_desc))
	
	local var_2_7 = arg_2_0.vars.dlg:getChildByName("n_set1")
	
	if_set(var_2_7:getChildByName("n_select1"), "txt_set1", T("txt_selectbox_1st"))
	if_set(var_2_7, "txt_set1", T("txt_selectbox_1st"))
	
	local var_2_8 = arg_2_0.vars.dlg:getChildByName("n_set2")
	
	if_set(var_2_8:getChildByName("n_select2"), "txt_set2", T("txt_selectbox_2nd"))
	if_set(var_2_8, "txt_set2", T("txt_selectbox_2nd"))
	
	local var_2_9 = arg_2_0.vars.dlg:getChildByName("n_info")
	
	if_set(var_2_9, "t_info", T("txt_selectbox_info_1"))
	arg_2_0:setupSlider()
	arg_2_0:updateSelectedTitle()
	ItemSelectBoxDualStep1:show(arg_2_0.vars)
end

function ItemSelectBoxDual.setupSlider(arg_3_0)
	local var_3_0 = arg_3_0.vars.dlg
	
	local function var_3_1(arg_4_0, arg_4_1, arg_4_2)
		if get_cocos_refid(arg_3_0.vars.confirm_popup) then
			arg_3_0.vars.slider:setPercent(arg_3_0.vars.count)
			
			return 
		end
		
		arg_3_0.vars.count = arg_4_1
		
		arg_3_0:updateSliderUI()
	end
	
	local var_3_2 = arg_3_0.vars.dlg:getChildByName("progress")
	
	var_3_2:addEventListener(Dialog.defaultSliderEventHandler)
	
	var_3_2.handler = var_3_1
	var_3_2.slider_pos = 1
	var_3_2.min = 1
	var_3_2.max = arg_3_0.vars.max_count
	
	var_3_2:setMaxPercent(arg_3_0.vars.max_count)
	var_3_2:setPercent(1)
	
	var_3_2.parent = var_3_0
	
	var_3_2.handler(var_3_0, 1, 0)
	
	arg_3_0.vars.slider = var_3_2
end

function ItemSelectBoxDual.sliderAdjust(arg_5_0)
	if not arg_5_0.vars then
		return false
	end
	
	if not arg_5_0.vars.step2 then
		arg_5_0:min()
		
		return true
	end
	
	if DB("equip_item", arg_5_0.vars.step2.item_id, "id") and arg_5_0.vars.count > 10 then
		arg_5_0.vars.count = 10
		
		arg_5_0.vars.slider:setPercent(10)
		arg_5_0:updateSliderUI()
		
		return true
	end
	
	return false
end

function ItemSelectBoxDual.plus(arg_6_0)
	if get_cocos_refid(arg_6_0.vars.confirm_popup) then
		return 
	end
	
	if arg_6_0.vars.count + 1 > arg_6_0.vars.max_count then
		return 
	end
	
	arg_6_0.vars.count = arg_6_0.vars.count + 1
	
	if arg_6_0:sliderAdjust() then
		return 
	end
	
	arg_6_0.vars.slider:setPercent(arg_6_0.vars.slider:getPercent() + 1)
	Dialog.defaultSliderEventHandler(arg_6_0.vars.slider, 2)
	arg_6_0:updateSliderUI()
end

function ItemSelectBoxDual.minus(arg_7_0)
	if get_cocos_refid(arg_7_0.vars.confirm_popup) then
		return 
	end
	
	if arg_7_0.vars.count - 1 < 1 then
		return 
	end
	
	arg_7_0.vars.count = arg_7_0.vars.count - 1
	
	if arg_7_0:sliderAdjust() then
		return 
	end
	
	arg_7_0.vars.slider:setPercent(arg_7_0.vars.slider:getPercent() - 1)
	Dialog.defaultSliderEventHandler(arg_7_0.vars.slider, 2)
	arg_7_0:updateSliderUI()
end

function ItemSelectBoxDual.min(arg_8_0)
	if get_cocos_refid(arg_8_0.vars.confirm_popup) then
		return 
	end
	
	arg_8_0.vars.count = 1
	
	arg_8_0.vars.slider:setPercent(arg_8_0.vars.slider.min)
	Dialog.defaultSliderEventHandler(arg_8_0.vars.slider, 2)
	arg_8_0:updateSliderUI()
end

function ItemSelectBoxDual.max(arg_9_0)
	if get_cocos_refid(arg_9_0.vars.confirm_popup) then
		return 
	end
	
	arg_9_0.vars.count = arg_9_0.vars.max_count
	
	if arg_9_0:sliderAdjust() then
		return 
	end
	
	arg_9_0.vars.slider:setPercent(arg_9_0.vars.slider.max)
	arg_9_0:updateSliderUI()
end

function ItemSelectBoxDual.updateSliderUI(arg_10_0)
	if not arg_10_0.vars or not arg_10_0.vars.dlg then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.dlg
	local var_10_1 = var_10_0:getChildByName("txt_amount")
	
	if get_cocos_refid(var_10_1) then
		if_set(var_10_1, "txt_number", arg_10_0.vars.count .. "/" .. arg_10_0.vars.max_count)
	end
	
	if arg_10_0.vars.step2 then
		if_set_visible(var_10_0, "txt_get", true)
		if_set_visible(var_10_0, "txt_none", false)
		if_set(var_10_0, "txt_get", T("txt_selectbox_ac_item", {
			num = arg_10_0.vars.count * arg_10_0.vars.step2.value
		}))
	else
		if_set_visible(var_10_0, "txt_get", false)
		if_set_visible(var_10_0, "txt_none", true)
	end
end

function ItemSelectBoxDual.updateSelectedTitle(arg_11_0)
	local var_11_0 = arg_11_0.vars.dlg:getChildByName("n_set1")
	local var_11_1 = arg_11_0.vars.dlg:getChildByName("n_set2")
	
	if not arg_11_0.vars.step1 then
		if_set_visible(var_11_0, "n_select1", true)
		if_set_visible(var_11_1, "n_select2", false)
		if_set_visible(arg_11_0.vars.dlg, "n_info", true)
	else
		if_set_visible(var_11_0, "n_select1", false)
		if_set_visible(var_11_1, "n_select2", true)
		if_set_visible(arg_11_0.vars.dlg, "n_info", false)
	end
	
	local var_11_2 = arg_11_0.vars.dlg:getChildByName("n_slider"):getChildByName("n_slider")
	
	if not arg_11_0.vars.step2 then
		if_set_opacity(arg_11_0.vars.dlg, "btn_ok", 76.5)
		if_set_opacity(arg_11_0.vars.dlg, "n_slider", 76.5)
		if_set_visible(arg_11_0.vars.dlg, "txt_get", false)
		var_11_2:setEnabled(false)
		arg_11_0:min()
	else
		if_set_opacity(arg_11_0.vars.dlg, "btn_ok", 255)
		if_set_opacity(arg_11_0.vars.dlg, "n_slider", 255)
		if_set_visible(arg_11_0.vars.dlg, "txt_get", true)
		var_11_2:setEnabled(true)
	end
end

function ItemSelectBoxDual.selectStep1(arg_12_0, arg_12_1)
	arg_12_0.vars.step1 = arg_12_1
	arg_12_0.vars.step2 = nil
	
	arg_12_0:updateSelectedTitle()
	ItemSelectBoxDualStep2:show(arg_12_0.vars)
end

function ItemSelectBoxDual.selectStep2(arg_13_0, arg_13_1)
	arg_13_0.vars.step2 = arg_13_1
	
	arg_13_0:updateSelectedTitle()
	arg_13_0:min()
end

function ItemSelectBoxDual.select(arg_14_0)
	if not arg_14_0.vars.step2 then
		balloon_message_with_sound("txt_selectbox_info_2")
		
		return 
	end
	
	if arg_14_0.vars.count < 1 or arg_14_0.vars.count > arg_14_0.vars.max_count then
		return 
	end
	
	arg_14_0:popupConfirmCount()
end

function ItemSelectBoxDual.callCallback(arg_15_0, arg_15_1)
	if arg_15_0.vars.callback then
		arg_15_0.vars.callback({
			material_id = arg_15_0.vars.code,
			step1_id = arg_15_0.vars.step1,
			step2_id = arg_15_0.vars.step2.item_id,
			use_count = arg_15_0.vars.count
		})
	end
	
	if not arg_15_1 then
		arg_15_0:close()
	end
end

function HANDLER.confirm_dual_inventory_open_box(arg_16_0, arg_16_1)
	if arg_16_1 == "btn_ok" then
		ItemSelectBoxDual:closePopupConfirmCount()
		ItemSelectBoxDual:callCallback()
	elseif arg_16_1 == "btn_cancel" then
		ItemSelectBoxDual:closePopupConfirmCount()
	end
end

function ItemSelectBoxDual.closePopupConfirmCount(arg_17_0)
	if get_cocos_refid(arg_17_0.vars.confirm_popup) then
		arg_17_0.vars.confirm_popup:removeFromParent()
	end
	
	arg_17_0.vars.dlg:getChildByName("n_slider"):getChildByName("n_slider"):setEnabled(true)
	
	arg_17_0.vars.confirm_popup = nil
end

function ItemSelectBoxDual.popupConfirmCount(arg_18_0)
	if arg_18_0.vars.count >= 10 then
		arg_18_0.vars.dlg:getChildByName("n_slider"):getChildByName("n_slider"):setEnabled(false)
		
		local var_18_0 = load_dlg("inventory_open_box", true, "wnd")
		
		var_18_0:setName("confirm_dual_inventory_open_box")
		
		local var_18_1 = var_18_0:getChildByName("n_use_item")
		local var_18_2 = var_18_1:getChildByName("n_item_kind")
		local var_18_3 = var_18_1:getChildByName("t_name")
		
		UIUtil:getRewardIcon(nil, arg_18_0.vars.code, {
			no_resize_name = true,
			show_name = true,
			parent = var_18_1:getChildByName("reward_item"),
			txt_type = var_18_2,
			txt_name = var_18_3
		})
		if_set(var_18_1, "t_have", T("text_item_have_count", {
			count = arg_18_0.vars.actual_count
		}))
		if_set(var_18_1, "t_use", T("text_item_use_count", {
			count = arg_18_0.vars.count
		}))
		
		local var_18_4 = var_18_3:getStringNumLines()
		
		if var_18_4 > 1 then
			var_18_2:setPositionY(var_18_2:getPositionY() + 10 * (var_18_4 - 1) + var_18_4)
			var_18_3:setPositionY(var_18_3:getPositionY() + 5 * (var_18_4 - 1))
		end
		
		local var_18_5 = var_18_0:getChildByName("n_get_item")
		local var_18_6 = var_18_5:getChildByName("n_item_kind")
		local var_18_7 = var_18_5:getChildByName("t_name")
		
		UIUtil:getRewardIcon(nil, arg_18_0.vars.step2.item_id, {
			no_resize_name = true,
			show_name = true,
			parent = var_18_5:getChildByName("reward_item"),
			txt_type = var_18_6,
			txt_name = var_18_7,
			grade_rate = arg_18_0.vars.step2.grade_rate,
			set_drop = arg_18_0.vars.step2.set_drop
		})
		if_set(var_18_5, "t_have", T("text_item_have_count", {
			count = to_n(Account:getPropertyCount(arg_18_0.vars.step2.item_id))
		}))
		if_set(var_18_5, "t_get", T("text_item_earn_count", {
			count = arg_18_0.vars.count * arg_18_0.vars.step2.value
		}))
		
		local var_18_8 = var_18_7:getStringNumLines()
		
		if var_18_8 > 1 then
			var_18_6:setPositionY(var_18_6:getPositionY() + 10 * (var_18_8 - 1) + var_18_8)
			var_18_7:setPositionY(var_18_7:getPositionY() + 5 * (var_18_8 - 1))
		end
		
		arg_18_0.vars.dlg:addChild(var_18_0)
		
		arg_18_0.vars.confirm_popup = var_18_0
	else
		arg_18_0:callCallback()
	end
end

function ItemSelectBoxDual.close(arg_19_0)
	Dialog:close("inventory_box_dual_choose")
	
	arg_19_0.vars = nil
end

ItemSelectBoxDualStep1 = {}

copy_functions(ScrollView, ItemSelectBoxDualStep1)

function ItemSelectBoxDualStep1.show(arg_20_0, arg_20_1)
	arg_20_0.vars = {}
	arg_20_0.base_vars = arg_20_1
	arg_20_0.vars.layer = arg_20_1.dlg:getChildByName("n_set1")
	arg_20_0.vars.scrollview = arg_20_0.vars.layer:getChildByName("n_list1")
	
	arg_20_0:initScrollView(arg_20_0.vars.scrollview, 472, 100)
	arg_20_0:createScrollViewItems(arg_20_0.base_vars.item_special_id)
end

function ItemSelectBoxDualStep1.getScrollViewItem(arg_21_0, arg_21_1)
	local var_21_0 = load_control("wnd/inventory_box_dual_choose_card.csb")
	
	if_set_visible(var_21_0, "n_select", false)
	if_set_visible(var_21_0, "n_item", false)
	if_set_visible(var_21_0, "n_item_have", false)
	if_set_visible(var_21_0, "n_icon", false)
	if_set_visible(var_21_0, "n_btn", false)
	
	if arg_21_0.base_vars.mode == "equip_set" then
		if_set_visible(var_21_0, "n_icon", true)
		
		local var_21_1 = var_21_0:getChildByName("n_icon")
		local var_21_2 = arg_21_0.base_vars.item_special[arg_21_1]
		
		if_set_sprite(var_21_1, "n_icon_menu", "item/" .. var_21_2.item.icon .. ".png")
		if_set(var_21_1, "txt_name", T(var_21_2.item.name))
	end
	
	if false then
	end
	
	return var_21_0
end

function ItemSelectBoxDualStep1.onSelectScrollViewItem(arg_22_0, arg_22_1, arg_22_2)
	for iter_22_0, iter_22_1 in pairs(arg_22_0.ScrollViewItems) do
		if_set_visible(iter_22_1.control, "n_select", false)
	end
	
	if_set_visible(arg_22_2.control, "n_select", true)
	ItemSelectBoxDual:selectStep1(arg_22_2.item)
end

ItemSelectBoxDualStep2 = {}

copy_functions(ScrollView, ItemSelectBoxDualStep2)

function ItemSelectBoxDualStep2.show(arg_23_0, arg_23_1)
	arg_23_0.vars = {}
	arg_23_0.base_vars = arg_23_1
	arg_23_0.vars.layer = arg_23_1.dlg:getChildByName("n_set2")
	arg_23_0.vars.scrollview = arg_23_0.vars.layer:getChildByName("n_list2")
	
	arg_23_0.vars.scrollview:removeAllChildren()
	arg_23_0:initScrollView(arg_23_0.vars.scrollview, 472, 100)
	arg_23_0:createScrollViewItems(arg_23_0.base_vars.item_special[arg_23_0.base_vars.step1].step2_items)
end

function ItemSelectBoxDualStep2.getScrollViewItem(arg_24_0, arg_24_1)
	local var_24_0 = load_control("wnd/inventory_box_dual_choose_card.csb")
	
	if_set_visible(var_24_0, "n_select", false)
	if_set_visible(var_24_0, "n_item", false)
	if_set_visible(var_24_0, "n_item_have", true)
	if_set_visible(var_24_0, "n_icon", false)
	if_set_visible(var_24_0, "n_btn", false)
	
	local var_24_1 = arg_24_1.item_id
	local var_24_2 = var_24_0:getChildByName("n_item_have")
	local var_24_3 = var_24_2:getChildByName("txt_type")
	local var_24_4 = var_24_2:getChildByName("txt_name")
	
	UIUtil:getRewardIcon(nil, var_24_1, {
		no_resize_name = true,
		show_name = true,
		parent = var_24_2:getChildByName("reward_icon"),
		txt_type = var_24_3,
		txt_name = var_24_4,
		grade_rate = arg_24_1.grade_rate,
		set_drop = arg_24_1.set_drop
	})
	
	if arg_24_1.type == "equip" then
		if_set_visible(var_24_0, "n_have", false)
	else
		if_set_visible(var_24_0, "n_have", true)
		if_set(var_24_2, "txt_count", to_n(Account:getPropertyCount(var_24_1)))
	end
	
	if var_24_4:getStringNumLines() > 1 then
		var_24_3:setPositionY(var_24_3:getPositionY() + 10)
		var_24_4:setPositionY(var_24_4:getPositionY() + 10)
	end
	
	UIUserData:call(var_24_4, "MULTI_SCALE(2,30)")
	
	local var_24_5 = var_24_2:getChildByName("n_have"):getChildByName("txt_have")
	
	UIUserData:call(var_24_5, "SINGLE_WSCALE(56)")
	
	return var_24_0
end

function ItemSelectBoxDualStep2.onSelectScrollViewItem(arg_25_0, arg_25_1, arg_25_2)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.ScrollViewItems) do
		if_set_visible(iter_25_1.control, "n_select", false)
	end
	
	if_set_visible(arg_25_2.control, "n_select", true)
	ItemSelectBoxDual:selectStep2(arg_25_2.item)
end
