ItemSelectBox = {}

function HANDLER.inventory_open_box_p(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" or arg_1_1 == "btn_cancel" then
		ItemSelectBox:close()
	end
	
	if arg_1_1 == "btn_select" then
		ItemSelectBox:onSelectItem(arg_1_0)
	end
	
	if arg_1_1 == "btn_yes" then
		ItemSelectBox:makeConfirmPopup()
	end
	
	if arg_1_1 == "btn_min" then
		ItemSelectBox:min()
	end
	
	if arg_1_1 == "btn_minus" then
		ItemSelectBox:minus()
	end
	
	if arg_1_1 == "btn_plus" then
		ItemSelectBox:plus()
	end
	
	if arg_1_1 == "btn_max" then
		ItemSelectBox:max()
	end
end

function HANDLER.inventory_open_box(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_ok" then
		ItemSelectBox:closeConfirmPopup()
		ItemSelectBox:onConfirmItem()
	end
	
	if arg_2_1 == "btn_cancel" then
		ItemSelectBox:closeConfirmPopup()
	end
end

local function var_0_0()
	Log.e("ItemListBox. DEAD HANDLER! ")
end

function ItemSelectBox._makeRewardIcon(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = {}
	local var_4_1 = DB("character", arg_4_2.item_id, "id") and true or false
	
	if arg_4_3.category == "equip" then
		var_4_0.grade_rate = arg_4_2.grade_rate
		var_4_0.grade_max = true
		var_4_0.show_equip_type = true
		
		local var_4_2 = DB("item_set", arg_4_2.set_drop, "id")
		
		if var_4_2 and var_4_2 ~= "" then
			var_4_0.set_fx = arg_4_2.set_drop
		else
			var_4_0.set_drop = arg_4_2.set_drop
		end
	end
	
	if not arg_4_4 then
		var_4_0.no_popup = var_4_1
	end
	
	var_4_0.parent = arg_4_1
	
	if arg_4_3.category == "artifact" then
		var_4_0.scale = 1
	end
	
	var_4_0.no_detail_popup = true
	var_4_0.tooltip_delay = 130
	
	UIUtil:getRewardIcon(arg_4_2.value, arg_4_2.item_id, var_4_0)
	
	if arg_4_3.category == "artifact" then
		arg_4_1:setScale(0.77)
	elseif var_4_1 then
		arg_4_1:setScale(1.07)
	else
		arg_4_1:setScale(1)
	end
end

function ItemSelectBox.onUpdate(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_1:findChildByName("bg_item")
	
	if not var_5_0 then
		return 
	end
	
	local var_5_1 = UIUtil:getItemDisplayInfo(arg_5_3.item_id)
	
	arg_5_0:_makeRewardIcon(var_5_0, arg_5_3, var_5_1)
	
	local var_5_2 = arg_5_1:findChildByName("n_select")
	
	if get_cocos_refid(var_5_2) then
		var_5_2:setVisible(false)
		if_set_visible(var_5_2, "icon_check", false)
	end
	
	local var_5_3 = arg_5_1:findChildByName("btn_select")
	
	var_5_3.data = arg_5_3
	var_5_3.renderer = arg_5_1
end

function ItemSelectBox.onSelectItem(arg_6_0, arg_6_1)
	if arg_6_0.vars.prv_renderer then
		if_set_visible(arg_6_0.vars.prv_renderer, "n_select", false)
	end
	
	local var_6_0 = arg_6_1.data
	local var_6_1 = arg_6_1.renderer
	
	if not var_6_1 or not var_6_0 then
		return 
	end
	
	if not arg_6_0.vars.prv_renderer then
		arg_6_0:toggleButtons(true)
	end
	
	arg_6_0.vars.selected_item = var_6_0
	arg_6_0.vars.prv_renderer = var_6_1
	
	local var_6_2 = DB("equip_item", var_6_0.item_id, {
		"type"
	}) or arg_6_0.vars.is_count_limit_item
	local var_6_3 = var_6_2 and math.min(10, arg_6_0.vars.max_count) or arg_6_0.vars.max_count
	
	arg_6_0.vars.is_equip_selected = var_6_2
	
	local var_6_4 = arg_6_0.vars.slider
	
	if get_cocos_refid(var_6_4) then
		var_6_4.max = var_6_3
		
		arg_6_0:min()
	end
	
	arg_6_0:updateSelectItemInfo(var_6_0)
	if_set_visible(var_6_1, "n_select", true)
end

function ItemSelectBox.toggleButtons(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.dlg
	local var_7_1 = arg_7_0.vars.slider
	
	if_set_opacity(var_7_0, "btn_yes", arg_7_1 and 255 or 76.5)
	if_set_opacity(var_7_0, "btn_minus", arg_7_1 and 255 or 76.5)
	if_set_opacity(var_7_0, "btn_min", arg_7_1 and 255 or 76.5)
	if_set_opacity(var_7_0, "btn_plus", arg_7_1 and 255 or 76.5)
	if_set_opacity(var_7_0, "btn_max", arg_7_1 and 255 or 76.5)
	
	if get_cocos_refid(var_7_1) then
		var_7_1:setTouchEnabled(arg_7_1)
		var_7_1:setOpacity(arg_7_1 and 255 or 76.5)
	end
end

function ItemSelectBox.makeConfirmPopup(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.dlg) then
		return 
	end
	
	local var_8_0 = arg_8_0:getLastSelectItem()
	
	if not var_8_0 then
		balloon_message_with_sound("msg_no_item_select")
		
		return 
	end
	
	if arg_8_0.vars.count >= 10 then
		local var_8_1 = Dialog:open("wnd/inventory_open_box")
		
		arg_8_0.vars.dlg:addChild(var_8_1)
		
		local var_8_2 = var_8_1:getChildByName("n_get_item")
		local var_8_3 = var_8_1:getChildByName("n_use_item")
		
		ItemSelectBox:updateSelectItemInfo(arg_8_0.vars.selected_item, var_8_2)
		ItemSelectBox:updateSelectItemInfo({
			value = 1,
			item_id = var_8_0.material_id
		}, var_8_3)
		
		arg_8_0.vars.confirm_popup = var_8_1
	else
		ItemSelectBox:onConfirmItem()
	end
end

function ItemSelectBox.closeConfirmPopup(arg_9_0)
	Dialog:close("inventory_open_box")
	
	arg_9_0.vars.confirm_popup = nil
end

function ItemSelectBox.onConfirmItem(arg_10_0)
	local var_10_0 = arg_10_0:getLastSelectItem()
	
	if arg_10_0.vars.callback then
		if (arg_10_0.vars.callback(var_10_0) or "close") ~= "dont_close" then
			arg_10_0:close()
		end
	else
		print("ItemSelectBox : NO CALLBACK. check opts on make.")
	end
end

function ItemSelectBox.updateSelectItemInfo(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.vars then
		return 
	end
	
	local var_11_0 = arg_11_2 or arg_11_0.vars.dlg
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	local var_11_1 = UIUtil:getItemDisplayInfo(arg_11_1.item_id)
	local var_11_2 = var_11_1.category == "equip"
	local var_11_3 = false
	
	if Account:isCurrencyType(arg_11_1.item_id) or DB("item_material", arg_11_1.item_id, {
		"ma_type"
	}) then
		var_11_3 = true
	end
	
	if_set_visible(var_11_0, "n_item", true)
	if_set_visible(var_11_0, "n_amunt_info", true)
	if_set_visible(var_11_0, "no_select", false)
	if_set_visible(var_11_0, "t_have", var_11_3)
	if_set_visible(var_11_0, "bar_l_0", var_11_3)
	
	local var_11_4 = var_11_0:getChildByName("reward_item")
	
	var_11_4:removeAllChildren()
	arg_11_0:_makeRewardIcon(var_11_4, arg_11_1, var_11_1, true)
	
	local var_11_5 = var_11_0:getChildByName("t_name")
	local var_11_6 = var_11_0:getChildByName("n_item_kind")
	
	if_set(var_11_5, nil, T(var_11_1.title))
	
	local var_11_7 = var_11_0:getChildByName("t_have")
	
	if var_11_2 then
		local var_11_8 = DB("item_equip_grade_rate", arg_11_1.grade_rate, {
			"min"
		}) or 1
		
		if_set(var_11_6, nil, EQUIP.getGradeTitle(var_11_1.code, var_11_8, var_11_1.type))
	else
		if_set(var_11_6, nil, T(var_11_1.desc))
		
		if var_11_7 and var_11_7:isVisible() then
			local var_11_9 = Account:getPropertyCount(arg_11_1.item_id)
			
			if_set(var_11_0, "t_have", T("text_item_have_count", {
				count = comma_value(var_11_9)
			}))
		end
	end
	
	local var_11_10 = var_11_5:getTextBoxSize().height * var_11_5:getScaleY() * 0.5 + 2
	
	var_11_6:setPositionY(var_11_5:getPositionY() + var_11_10)
	if_set(var_11_0, "t_use", T("text_item_use_count", {
		count = arg_11_0.vars.count * arg_11_1.value
	}))
	if_set(var_11_0, "t_get", T("text_item_earn_count", {
		count = arg_11_0.vars.count * arg_11_1.value
	}))
	
	local var_11_11 = var_11_0:getChildByName("t_get")
	local var_11_12 = var_11_0:getChildByName("t_get_move")
	
	if get_cocos_refid(var_11_11) and get_cocos_refid(var_11_12) then
		if not var_11_11.org_x or not var_11_11.org_y then
			var_11_11.org_x, var_11_11.org_y = var_11_11:getPosition()
		end
		
		if not var_11_7 or not var_11_7:isVisible() then
			var_11_11:setPosition(var_11_12:getPosition())
		else
			var_11_11:setPosition(var_11_11.org_x, var_11_11.org_y)
		end
	end
end

function ItemSelectBox.getLastSelectItem(arg_12_0)
	if not arg_12_0.vars.selected_item then
		return 
	end
	
	if arg_12_0.vars.ignore_select then
		return 
	end
	
	local var_12_0 = {
		material_id = arg_12_0.vars.item.code,
		option_id = arg_12_0.vars.selected_item.id,
		use_count = arg_12_0.vars.count
	}
	
	if not var_12_0.material_id or not var_12_0.option_id then
		return 
	end
	
	return var_12_0
end

function ItemSelectBox.setupDatas(arg_13_0, arg_13_1)
	local var_13_0, var_13_1 = DB("item_material", arg_13_1.code, {
		"ma_type",
		"ma_type2"
	})
	
	if not var_13_0 == "special" then
		Log.e("NOT A MATERIAL TYPE SPECIAL.")
		
		return false
	end
	
	local var_13_2 = DB("item_special", var_13_1, "value")
	
	if not var_13_2 then
		Log.e("NOT IN A ITEM SPECIAL.")
		
		return false
	end
	
	arg_13_0.vars.is_count_limit_item = Account:checkItemSpecialInternalItemUnitOrEquip(arg_13_1.code)
	arg_13_0.vars.title, arg_13_0.vars.desc = DB("item_material", arg_13_1.code, {
		"select_title",
		"select_desc"
	})
	
	local var_13_3 = {}
	
	for iter_13_0 = 1, 9999 do
		local var_13_4 = {}
		
		var_13_4.id, var_13_4.item_special_value, var_13_4.item_id, var_13_4.value, var_13_4.type, var_13_4.grade_rate, var_13_4.set_drop = DBN("option", iter_13_0, {
			"id",
			"item_special_value",
			"item_id",
			"value",
			"type",
			"grade_rate",
			"set_drop"
		})
		
		if not var_13_4.id then
			break
		end
		
		if var_13_4.item_special_value == var_13_2 then
			local var_13_5 = {}
			
			var_13_5.id, var_13_5.type, var_13_5.name, var_13_5.icon, var_13_5.value, var_13_5.desc = DB("item_special", var_13_4.item_id, {
				"id",
				"type",
				"name",
				"icon",
				"value",
				"desc"
			})
			var_13_4.item_special_db = var_13_5
			
			table.push(var_13_3, var_13_4)
		end
	end
	
	arg_13_0.vars.datas = var_13_3
	
	return true
end

function ItemSelectBox.setupListView(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.dlg:findChildByName("listview_reward_bar")
	
	arg_14_0.vars.listView = ItemListView_v2:bindControl(var_14_0)
	
	local var_14_1 = load_control("wnd/pet_auto_inventory_card.csb")
	
	var_14_1:setContentSize(102, 105)
	var_14_1:setScale(0.95)
	
	local var_14_2
	
	if arg_14_1.enable_touch then
		var_14_2 = {
			onUpdate = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				ItemSelectBox:onUpdate(arg_15_1, arg_15_2, arg_15_3)
			end
		}
	else
		arg_14_0.vars.ignore_select = true
	end
	
	arg_14_0.vars.listView:setRenderer(var_14_1, var_14_2)
	arg_14_0.vars.listView:removeAllChildren()
end

function ItemSelectBox.setupSlider(arg_16_0)
	local var_16_0 = arg_16_0.vars.dlg
	
	arg_16_0.vars.max_count = Account:getItemCount(arg_16_0.vars.item.code)
	
	local function var_16_1(arg_17_0, arg_17_1, arg_17_2)
		if arg_17_2 == 2 then
			arg_17_0.balloon_flag = nil
		end
		
		if get_cocos_refid(arg_16_0.vars.confirm_popup) then
			arg_16_0.vars.slider:setPercent(arg_16_0.vars.count)
			
			return 
		end
		
		arg_16_0.vars.count = arg_17_1
		
		arg_16_0:updateSliderUI()
	end
	
	local var_16_2 = arg_16_0.vars.dlg:getChildByName("progress")
	
	var_16_2:addEventListener(ItemSelectBox.sliderEventHandler)
	
	var_16_2.handler = var_16_1
	var_16_2.slider_pos = 1
	var_16_2.min = 1
	var_16_2.max = arg_16_0.vars.max_count
	
	var_16_2:setMaxPercent(arg_16_0.vars.max_count)
	var_16_2:setPercent(1)
	
	var_16_2.parent = var_16_0
	
	var_16_2.handler(var_16_0, 1, 0)
	
	arg_16_0.vars.slider = var_16_2
end

function ItemSelectBox.sliderEventHandler(arg_18_0, arg_18_1)
	if arg_18_0.min and arg_18_0:getPercent() < arg_18_0.min then
		arg_18_0:setPercent(arg_18_0.min)
	end
	
	if arg_18_0.max and arg_18_0:getPercent() > arg_18_0.max then
		if arg_18_1 == 0 and ItemSelectBox:isEquipSelected() and not arg_18_0.balloon_flag then
			balloon_message_with_sound("msg_select_box_equip_limit")
			
			arg_18_0.balloon_flag = true
		end
		
		arg_18_0:setPercent(arg_18_0.max)
	end
	
	if arg_18_0.handler then
		set_high_fps_tick()
		arg_18_0.handler(arg_18_0, arg_18_0:getPercent(), arg_18_1)
	end
end

function ItemSelectBox.isEquipSelected(arg_19_0)
	return arg_19_0.vars and arg_19_0.vars.is_equip_selected
end

function ItemSelectBox.initUI(arg_20_0)
	local var_20_0 = arg_20_0.vars.dlg
	
	if_set(var_20_0, "txt_title", T(arg_20_0.vars.title))
	if_set(var_20_0, "txt_info", T(arg_20_0.vars.desc))
	if_set_visible(var_20_0, "n_item", false)
	if_set_visible(var_20_0, "n_amunt_info", false)
	if_set_visible(var_20_0, "no_select", true)
end

function ItemSelectBox.updateSliderUI(arg_21_0)
	if not arg_21_0.vars or not arg_21_0.vars.dlg then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.dlg
	
	if arg_21_0.vars.selected_item then
		if_set(var_21_0, "t_get", T("text_item_earn_count", {
			count = arg_21_0.vars.count * arg_21_0.vars.selected_item.value
		}))
	end
	
	local var_21_1 = var_21_0:getChildByName("t_use_amount")
	
	if get_cocos_refid(var_21_1) then
		local var_21_2 = var_21_1:getChildByName("t_number")
		
		if get_cocos_refid(var_21_2) then
			if_set(var_21_2, nil, arg_21_0.vars.count .. "/" .. arg_21_0.vars.max_count)
			if_set_position_x(var_21_2, nil, var_21_1:getContentSize().width + 24)
			var_21_1:setPositionX((188 - var_21_2:getContentSize().width) / 4)
		end
	end
end

function ItemSelectBox.plus(arg_22_0)
	if get_cocos_refid(arg_22_0.vars.confirm_popup) then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.count + 1
	
	if var_22_0 > arg_22_0.vars.max_count then
		return 
	end
	
	local var_22_1 = arg_22_0.vars.slider
	
	if not arg_22_0.vars.selected_item or not get_cocos_refid(var_22_1) then
		return 
	end
	
	if arg_22_0.vars.is_equip_selected and var_22_0 > var_22_1.max then
		balloon_message_with_sound("msg_select_box_equip_limit")
		
		return 
	end
	
	arg_22_0.vars.count = var_22_0
	
	var_22_1:setPercent(var_22_0)
	ItemSelectBox.sliderEventHandler(var_22_1, 2)
	arg_22_0:updateSliderUI()
end

function ItemSelectBox.minus(arg_23_0)
	if get_cocos_refid(arg_23_0.vars.confirm_popup) then
		return 
	end
	
	if arg_23_0.vars.count - 1 < 1 then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.slider
	
	if not arg_23_0.vars.selected_item or not get_cocos_refid(var_23_0) then
		return 
	end
	
	arg_23_0.vars.count = arg_23_0.vars.count - 1
	
	var_23_0:setPercent(arg_23_0.vars.count)
	ItemSelectBox.sliderEventHandler(var_23_0, 2)
	arg_23_0:updateSliderUI()
end

function ItemSelectBox.min(arg_24_0)
	if get_cocos_refid(arg_24_0.vars.confirm_popup) then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.slider
	
	if not arg_24_0.vars.selected_item or not get_cocos_refid(var_24_0) then
		return 
	end
	
	arg_24_0.vars.count = var_24_0.min
	
	var_24_0:setPercent(arg_24_0.vars.count)
	ItemSelectBox.sliderEventHandler(var_24_0, 2)
	arg_24_0:updateSliderUI()
end

function ItemSelectBox.max(arg_25_0)
	if get_cocos_refid(arg_25_0.vars.confirm_popup) then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.slider
	
	if not arg_25_0.vars.selected_item or not get_cocos_refid(var_25_0) then
		return 
	end
	
	arg_25_0.vars.count = var_25_0.max
	
	var_25_0:setPercent(arg_25_0.vars.count)
	
	if arg_25_0.vars.is_equip_selected and var_25_0.max < arg_25_0.vars.max_count then
		balloon_message_with_sound("msg_select_box_equip_limit")
	end
	
	arg_25_0:updateSliderUI()
end

function ItemSelectBox.make(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not arg_26_2 then
		return 
	end
	
	arg_26_3 = arg_26_3 or {}
	arg_26_0.vars = {}
	
	if not arg_26_0:setupDatas(arg_26_2) then
		return 
	end
	
	local var_26_0 = Dialog:open("wnd/inventory_open_box_p")
	
	arg_26_1:addChild(var_26_0)
	
	arg_26_0.vars.item = arg_26_2
	arg_26_0.vars.parent = arg_26_1
	arg_26_0.vars.dlg = var_26_0
	
	arg_26_0:setupListView(arg_26_3)
	arg_26_0:setupSlider()
	arg_26_0:initUI()
	arg_26_0:toggleButtons(false)
	arg_26_0.vars.listView:setListViewCascadeEnabled(true)
	arg_26_0.vars.listView:setDataSource(arg_26_0.vars.datas)
	
	arg_26_0.vars.callback = arg_26_3.handler
end

function ItemSelectBox.close(arg_27_0)
	arg_27_0.vars.listView:removeAllChildren()
	Dialog:close("inventory_open_box_p")
	
	arg_27_0.vars = nil
end
