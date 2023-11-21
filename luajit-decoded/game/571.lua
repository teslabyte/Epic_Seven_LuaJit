ItemSelectBoxDevotion = {}

function MsgHandler.devotion_select_list(arg_1_0)
	if arg_1_0.code and arg_1_0.dv_list then
		ItemSelectBoxDevotion:update(arg_1_0.code, arg_1_0.dv_list, arg_1_0.stored_dv_codes)
	end
end

function HANDLER.inventory_open_box_p2(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" or arg_2_1 == "btn_cancel" then
		ItemSelectBoxDevotion:close()
	end
	
	if arg_2_1 == "btn_select" then
		ItemSelectBoxDevotion:onSelectItem(arg_2_0)
	end
	
	if arg_2_1 == "btn_buy" then
		ItemSelectBoxDevotion:makeConfirmPopup()
	end
	
	if arg_2_1 == "btn_min" then
		ItemSelectBoxDevotion:min()
	end
	
	if arg_2_1 == "btn_minus" then
		ItemSelectBoxDevotion:minus()
	end
	
	if arg_2_1 == "btn_plus" then
		ItemSelectBoxDevotion:plus()
	end
	
	if arg_2_1 == "btn_max" then
		ItemSelectBoxDevotion:max()
	end
	
	if arg_2_1 == "btn_toggle" or arg_2_1 == "btn_close2" or arg_2_1 == "btn_toggle_active" then
		ItemSelectBoxDevotion:toggleFilter()
	end
	
	if arg_2_1 == "checkbox_g" or arg_2_1 == "btn_checkbox_g" then
		ItemSelectBoxDevotion:selectSubFilter(1)
	end
	
	if arg_2_1 == "checkbox_sss" or arg_2_1 == "btn_checkbox_sss" then
		ItemSelectBoxDevotion:selectSubFilter(2)
	end
	
	if string.starts(arg_2_1, "btn_checkbox_") then
		ItemSelectBoxDevotion:selectFilter(arg_2_1)
	end
end

function HANDLER.confirm_devotion_inventory_open_box(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ok" then
		ItemSelectBoxDevotion:closeConfirmPopup()
		ItemSelectBoxDevotion:onConfirmItem()
	end
	
	if arg_3_1 == "btn_cancel" then
		ItemSelectBoxDevotion:closeConfirmPopup()
	end
end

local function var_0_0()
	Log.e("ItemListBox. DEAD HANDLER! ")
end

function ItemSelectBoxDevotion._makeRewardIcon(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = {
		no_count = arg_5_4,
		parent = arg_5_1
	}
	
	var_5_0.no_detail_popup = true
	var_5_0.tooltip_delay = 130
	
	UIUtil:getRewardIcon(arg_5_2.value, arg_5_2.item_id, var_5_0)
	arg_5_1:setScale(1)
end

function ItemSelectBoxDevotion.onUpdate(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1:findChildByName("bg_item")
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1 = UIUtil:getItemDisplayInfo(arg_6_3.item_id)
	
	arg_6_0:_makeRewardIcon(var_6_0, arg_6_3, var_6_1, false)
	
	local var_6_2 = arg_6_1:findChildByName("n_select")
	
	if get_cocos_refid(var_6_2) then
		var_6_2:setVisible(false)
		if_set_visible(var_6_2, "icon_check", false)
	end
	
	local var_6_3 = arg_6_1:findChildByName("btn_select")
	
	var_6_3.data = arg_6_3
	var_6_3.renderer = arg_6_1
end

function ItemSelectBoxDevotion.onSelectItem(arg_7_0, arg_7_1)
	if arg_7_0.vars.prv_renderer then
		if_set_visible(arg_7_0.vars.prv_renderer, "n_select", false)
	end
	
	local var_7_0 = arg_7_1.data
	local var_7_1 = arg_7_1.renderer
	
	if not var_7_1 or not var_7_0 then
		return 
	end
	
	if not arg_7_0.vars.prv_renderer then
		arg_7_0:toggleButtons(true)
	end
	
	arg_7_0.vars.selected_item = var_7_0
	arg_7_0.vars.prv_renderer = var_7_1
	
	local var_7_2 = DB("equip_item", var_7_0.item_id, {
		"type"
	}) or arg_7_0.vars.is_count_limit_item
	local var_7_3 = var_7_2 and math.min(10, arg_7_0.vars.max_count) or arg_7_0.vars.max_count
	
	arg_7_0.vars.is_equip_selected = var_7_2
	
	local var_7_4 = arg_7_0.vars.slider
	
	if get_cocos_refid(var_7_4) then
		var_7_4.max = var_7_3
		
		arg_7_0:min()
	end
	
	arg_7_0:updateSelectItemInfo(var_7_0)
	if_set_visible(var_7_1, "n_select", true)
end

function ItemSelectBoxDevotion.toggleButtons(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.dlg
	local var_8_1 = arg_8_0.vars.slider
	
	if_set_opacity(var_8_0, "btn_buy", arg_8_1 and 255 or 76.5)
	if_set_opacity(var_8_0, "btn_minus", arg_8_1 and 255 or 76.5)
	if_set_opacity(var_8_0, "btn_min", arg_8_1 and 255 or 76.5)
	if_set_opacity(var_8_0, "btn_plus", arg_8_1 and 255 or 76.5)
	if_set_opacity(var_8_0, "btn_max", arg_8_1 and 255 or 76.5)
	
	if get_cocos_refid(var_8_1) then
		var_8_1:setTouchEnabled(arg_8_1)
		var_8_1:setOpacity(arg_8_1 and 255 or 76.5)
	end
end

function ItemSelectBoxDevotion.makeConfirmPopup(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.dlg) then
		return 
	end
	
	local var_9_0 = arg_9_0:getLastSelectItem()
	
	if not var_9_0 then
		balloon_message_with_sound("msg_no_item_select")
		
		return 
	end
	
	if to_n(arg_9_0.vars.opts.shop_item.limit_count) <= to_n(Account:getLimitCount("sh:" .. arg_9_0.vars.opts.shop_item.id)) then
		balloon_message_with_sound("err_msg_cannot_buy")
		
		return 
	end
	
	if false and arg_9_0.vars.count >= 10 then
		local var_9_1 = Dialog:open("wnd/inventory_open_box")
		
		var_9_1:setName("confirm_devotion_inventory_open_box")
		arg_9_0.vars.dlg:addChild(var_9_1)
		
		local var_9_2 = var_9_1:getChildByName("n_get_item")
		local var_9_3 = var_9_1:getChildByName("n_use_item")
		
		ItemSelectBoxDevotion:updateSelectItemInfo(arg_9_0.vars.selected_item, var_9_2)
		ItemSelectBoxDevotion:updateSelectItemInfo({
			item_id = var_9_0.item_special_id,
			value = arg_9_0.vars.multiplier
		}, var_9_3)
		
		arg_9_0.vars.confirm_popup = var_9_1
	else
		ItemSelectBoxDevotion:onConfirmItem()
	end
end

function ItemSelectBoxDevotion.closeConfirmPopup(arg_10_0)
	Dialog:close("confirm_devotion_inventory_open_box")
	arg_10_0.vars.confirm_popup:removeFromParent()
	
	arg_10_0.vars.confirm_popup = nil
end

function ItemSelectBoxDevotion.onConfirmItem(arg_11_0)
	local var_11_0 = arg_11_0:getLastSelectItem()
	
	if arg_11_0.vars.callback then
		if (arg_11_0.vars.callback(var_11_0) or "close") ~= "dont_close" then
			arg_11_0:close()
		end
	else
		print("ItemSelectBoxDevotion : NO CALLBACK. check opts on make.")
		arg_11_0:close()
	end
end

function ItemSelectBoxDevotion.updateSelectItemInfo(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = arg_12_2 or arg_12_0.vars.dlg
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	local var_12_1 = UIUtil:getItemDisplayInfo(arg_12_1.item_id)
	local var_12_2 = var_12_1.category == "equip"
	local var_12_3 = false
	
	if Account:isCurrencyType(arg_12_1.item_id) or DB("item_material", arg_12_1.item_id, {
		"ma_type"
	}) then
		var_12_3 = true
	end
	
	if_set_visible(var_12_0, "n_item", true)
	if_set_visible(var_12_0, "n_amunt_info", true)
	if_set_visible(var_12_0, "no_select", false)
	if_set_visible(var_12_0, "t_have", var_12_3)
	if_set_visible(var_12_0, "bar_l_0", var_12_3)
	
	local var_12_4 = var_12_0:getChildByName("reward_item")
	
	var_12_4:removeAllChildren()
	arg_12_0:_makeRewardIcon(var_12_4, arg_12_1, var_12_1, true)
	
	local var_12_5 = var_12_0:getChildByName("t_name")
	local var_12_6 = var_12_0:getChildByName("n_item_kind")
	
	if_set(var_12_5, nil, T(var_12_1.title))
	
	local var_12_7 = var_12_0:getChildByName("t_have")
	
	if var_12_2 then
		local var_12_8 = DB("item_equip_grade_rate", arg_12_1.grade_rate, {
			"min"
		}) or 1
		
		if_set(var_12_6, nil, EQUIP.getGradeTitle(var_12_1.code, var_12_8, var_12_1.type))
	else
		if_set(var_12_6, nil, T(var_12_1.desc))
		
		if var_12_7 and var_12_7:isVisible() then
			local var_12_9 = Account:getPropertyCount(arg_12_1.item_id)
			
			if_set(var_12_0, "t_have", T("text_item_have_count", {
				count = comma_value(var_12_9)
			}))
		end
	end
	
	local var_12_10 = var_12_5:getTextBoxSize().height * var_12_5:getScaleY() * 0.5 + 2
	
	var_12_6:setPositionY(var_12_5:getPositionY() + var_12_10)
	if_set(var_12_0, "t_use", T("text_item_use_count", {
		count = arg_12_0.vars.count * arg_12_1.value
	}))
	if_set(var_12_0, "t_get", T("text_item_earn_count", {
		count = arg_12_0.vars.count * arg_12_1.value
	}))
	
	local var_12_11 = var_12_0:getChildByName("t_get")
	local var_12_12 = var_12_0:getChildByName("t_get_move")
	
	if get_cocos_refid(var_12_11) and get_cocos_refid(var_12_12) then
		if not var_12_11.org_x or not var_12_11.org_y then
			var_12_11.org_x, var_12_11.org_y = var_12_11:getPosition()
		end
		
		if not var_12_7 or not var_12_7:isVisible() then
			var_12_11:setPosition(var_12_12:getPosition())
		else
			var_12_11:setPosition(var_12_11.org_x, var_12_11.org_y)
		end
	end
end

function ItemSelectBoxDevotion.getLastSelectItem(arg_13_0)
	if not arg_13_0.vars.selected_item then
		return 
	end
	
	if arg_13_0.vars.ignore_select then
		return 
	end
	
	local var_13_0 = {
		shop_item_id = arg_13_0.vars.opts.shop_item.id,
		shop_type = arg_13_0.vars.opts.shop_item.shop_type,
		item_special_id = arg_13_0.vars.item_code,
		select_id = arg_13_0.vars.selected_item.item_id,
		use_count = arg_13_0.vars.count
	}
	
	if not var_13_0.shop_item_id or not var_13_0.item_special_id or not var_13_0.select_id then
		return 
	end
	
	return var_13_0
end

function ItemSelectBoxDevotion.setupDatas(arg_14_0)
	local var_14_0 = arg_14_0.vars.item_code
	local var_14_1, var_14_2, var_14_3, var_14_4 = DB("item_special", var_14_0, {
		"type",
		"value",
		"name",
		"desc"
	})
	
	if not var_14_1 == "devotion_select" or not var_14_2 then
		Log.e("NOT A DEVOTION SELECT TYPE")
		
		return false
	end
	
	local var_14_5 = {}
	
	arg_14_0.vars.multiplier = math.max(1, to_n(string.split(var_14_2, ",")[2]))
	arg_14_0.vars.title = var_14_3
	arg_14_0.vars.desc = var_14_4
	
	local var_14_6 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.dv_list) do
		local var_14_7 = "ma_dv_" .. iter_14_1
		local var_14_8 = {
			item_id = var_14_7,
			value = arg_14_0.vars.multiplier,
			code = iter_14_1
		}
		
		table.push(var_14_6, var_14_8)
	end
	
	arg_14_0.vars.datas = var_14_6
	
	return true
end

function ItemSelectBoxDevotion.setupListView(arg_15_0)
	local var_15_0 = arg_15_0.vars.dlg:getChildByName("listview_reward_bar")
	local var_15_1 = var_15_0:getContentSize()
	
	var_15_0:setContentSize(var_15_1.width, var_15_1.height - 68)
	
	arg_15_0.vars.listView = ItemListView_v2:bindControl(var_15_0)
	
	local var_15_2 = load_control("wnd/pet_auto_inventory_card.csb")
	
	var_15_2:setContentSize(102, 105)
	var_15_2:setScale(0.95)
	
	if var_15_0.STRETCH_INFO then
		local var_15_3 = var_15_0:getContentSize()
		
		resetControlPosAndSize(item_renderer, var_15_3.width, var_15_0.STRETCH_INFO.width_prev)
	end
	
	local var_15_4 = {
		onUpdate = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			ItemSelectBoxDevotion:onUpdate(arg_16_1, arg_16_2, arg_16_3)
		end
	}
	
	arg_15_0.vars.listView:setRenderer(var_15_2, var_15_4)
	arg_15_0.vars.listView:removeAllChildren()
end

function ItemSelectBoxDevotion.setupSlider(arg_17_0)
	local var_17_0 = arg_17_0.vars.dlg
	
	local function var_17_1(arg_18_0, arg_18_1, arg_18_2)
		if arg_18_2 == 2 then
			arg_18_0.balloon_flag = nil
		end
		
		if get_cocos_refid(arg_17_0.vars.confirm_popup) then
			arg_17_0.vars.slider:setPercent(arg_17_0.vars.count)
			
			return 
		end
		
		arg_17_0.vars.count = arg_18_1
		
		arg_17_0:updateSliderUI()
	end
	
	local var_17_2 = arg_17_0.vars.dlg:getChildByName("progress")
	
	var_17_2:addEventListener(ItemSelectBoxDevotion.sliderEventHandler)
	
	var_17_2.handler = var_17_1
	var_17_2.slider_pos = 1
	var_17_2.min = 1
	var_17_2.max = arg_17_0.vars.max_count
	
	var_17_2:setMaxPercent(arg_17_0.vars.max_count)
	var_17_2:setPercent(1)
	
	var_17_2.parent = var_17_0
	
	var_17_2.handler(var_17_0, 1, 0)
	
	arg_17_0.vars.slider = var_17_2
end

function ItemSelectBoxDevotion.sliderEventHandler(arg_19_0, arg_19_1)
	if arg_19_0.min and arg_19_0:getPercent() < arg_19_0.min then
		arg_19_0:setPercent(arg_19_0.min)
	end
	
	if arg_19_0.max and arg_19_0:getPercent() > arg_19_0.max then
		if arg_19_1 == 0 and ItemSelectBoxDevotion:isEquipSelected() and not arg_19_0.balloon_flag then
			balloon_message_with_sound("msg_select_box_equip_limit")
			
			arg_19_0.balloon_flag = true
		end
		
		arg_19_0:setPercent(arg_19_0.max)
	end
	
	if arg_19_0.handler then
		set_high_fps_tick()
		arg_19_0.handler(arg_19_0, arg_19_0:getPercent(), arg_19_1)
	end
end

function ItemSelectBoxDevotion.isEquipSelected(arg_20_0)
	return arg_20_0.vars and arg_20_0.vars.is_equip_selected
end

function ItemSelectBoxDevotion.initUI(arg_21_0)
	local var_21_0 = arg_21_0.vars.dlg
	
	if_set(var_21_0, "txt_title", T(arg_21_0.vars.title))
	if_set(var_21_0, "txt_info", T(arg_21_0.vars.desc))
	if_set_visible(var_21_0, "n_item", false)
	if_set_visible(var_21_0, "n_amunt_info", false)
	if_set_visible(var_21_0, "no_select", true)
	if_set_visible(var_21_0, "btn_yes", false)
	if_set_visible(var_21_0, "btn_buy", true)
	
	local var_21_1 = var_21_0:getChildByName("btn_buy")
	
	ShopCommon:updatePayIcons(var_21_1, arg_21_0.vars.opts.shop_item.token, arg_21_0.vars.opts.shop_item.price)
	if_set_visible(var_21_0, "n_filter", true)
	if_set_visible(var_21_0, "n_sort", false)
	if_set_visible(var_21_0, "btn_toggle_active", false)
	if_set_visible(var_21_0, "btn_toggle", true)
	if_set_visible(var_21_0, "n_info", false)
end

function ItemSelectBoxDevotion.updateSliderUI(arg_22_0)
	if not arg_22_0.vars or not arg_22_0.vars.dlg then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.dlg
	
	if arg_22_0.vars.selected_item then
		if_set(var_22_0, "t_get", T("text_item_earn_count", {
			count = arg_22_0.vars.count * arg_22_0.vars.selected_item.value
		}))
	end
	
	local var_22_1 = var_22_0:getChildByName("t_use_amount")
	
	if get_cocos_refid(var_22_1) then
		local var_22_2 = var_22_1:getChildByName("t_number")
		
		if get_cocos_refid(var_22_2) then
			if_set(var_22_2, nil, arg_22_0.vars.count .. "/" .. arg_22_0.vars.max_count)
			if_set_position_x(var_22_2, nil, var_22_1:getContentSize().width + 24)
			var_22_1:setPositionX((188 - var_22_2:getContentSize().width) / 4)
		end
	end
	
	local var_22_3 = var_22_0:getChildByName("btn_buy")
	
	if get_cocos_refid(var_22_3) then
		local var_22_4 = arg_22_0.vars.opts.shop_item.price * math.max(arg_22_0.vars.count, 1)
		
		ShopCommon:updatePayIcons(var_22_3, arg_22_0.vars.opts.shop_item.token, var_22_4)
	end
end

function ItemSelectBoxDevotion.plus(arg_23_0)
	if get_cocos_refid(arg_23_0.vars.confirm_popup) then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.count + 1
	
	if var_23_0 > arg_23_0.vars.max_count then
		return 
	end
	
	local var_23_1 = arg_23_0.vars.slider
	
	if not arg_23_0.vars.selected_item or not get_cocos_refid(var_23_1) then
		return 
	end
	
	if arg_23_0.vars.is_equip_selected and var_23_0 > var_23_1.max then
		balloon_message_with_sound("msg_select_box_equip_limit")
		
		return 
	end
	
	arg_23_0.vars.count = var_23_0
	
	var_23_1:setPercent(var_23_0)
	ItemSelectBoxDevotion.sliderEventHandler(var_23_1, 2)
	arg_23_0:updateSliderUI()
end

function ItemSelectBoxDevotion.minus(arg_24_0)
	if get_cocos_refid(arg_24_0.vars.confirm_popup) then
		return 
	end
	
	if arg_24_0.vars.count - 1 < 1 then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.slider
	
	if not arg_24_0.vars.selected_item or not get_cocos_refid(var_24_0) then
		return 
	end
	
	arg_24_0.vars.count = arg_24_0.vars.count - 1
	
	var_24_0:setPercent(arg_24_0.vars.count)
	ItemSelectBoxDevotion.sliderEventHandler(var_24_0, 2)
	arg_24_0:updateSliderUI()
end

function ItemSelectBoxDevotion.min(arg_25_0)
	if get_cocos_refid(arg_25_0.vars.confirm_popup) then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.slider
	
	if not arg_25_0.vars.selected_item or not get_cocos_refid(var_25_0) then
		return 
	end
	
	arg_25_0.vars.count = var_25_0.min
	
	var_25_0:setPercent(arg_25_0.vars.count)
	ItemSelectBoxDevotion.sliderEventHandler(var_25_0, 2)
	arg_25_0:updateSliderUI()
end

function ItemSelectBoxDevotion.max(arg_26_0)
	if get_cocos_refid(arg_26_0.vars.confirm_popup) then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.slider
	
	if not arg_26_0.vars.selected_item or not get_cocos_refid(var_26_0) then
		return 
	end
	
	arg_26_0.vars.count = var_26_0.max
	
	var_26_0:setPercent(arg_26_0.vars.count)
	
	if arg_26_0.vars.is_equip_selected and var_26_0.max < arg_26_0.vars.max_count then
		balloon_message_with_sound("msg_select_box_equip_limit")
	end
	
	arg_26_0:updateSliderUI()
end

function ItemSelectBoxDevotion.show(arg_27_0, arg_27_1, arg_27_2)
	arg_27_2 = arg_27_2 or {}
	
	if not arg_27_2.shop_item or not arg_27_2.shop_item.rest_count then
		return 
	end
	
	if to_n(arg_27_2.shop_item.limit_count) <= to_n(Account:getLimitCount("sh:" .. arg_27_2.shop_item.id)) then
		balloon_message_with_sound("err_msg_cannot_buy")
		
		return 
	end
	
	arg_27_0.vars = {}
	arg_27_0.vars.opts = arg_27_2
	arg_27_0.vars.item_code = arg_27_1
	arg_27_0.vars.parent = arg_27_0.vars.opts.layer or SceneManager:getRunningPopupScene()
	
	query("devotion_select_list", {
		code = arg_27_1
	})
end

function ItemSelectBoxDevotion.getDevoteGrade(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = DB("character", arg_28_1, "grade") or 3
	local var_28_1 = math.max(3, var_28_0) - 2
	local var_28_2 = arg_28_2 or arg_28_0:getDevote()
	local var_28_3 = math.min(7, var_28_2 + (var_28_1 - 1))
	
	return DB("devotion_skill_grade", tostring(var_28_3), "grade")
end

function ItemSelectBoxDevotion.update(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if not arg_29_0.vars then
		return 
	end
	
	if arg_29_0.vars.item_code ~= arg_29_1 then
		return 
	end
	
	arg_29_0.vars.stored_dv_codes = arg_29_3
	arg_29_0.vars.stored_sss_codes = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_3) do
		if arg_29_0:getDevoteGrade(iter_29_0, iter_29_1) == "SSS" then
			arg_29_0.vars.stored_sss_codes[iter_29_0] = iter_29_1
		end
	end
	
	arg_29_0.vars.dv_list = arg_29_2
	
	if not arg_29_0:setupDatas() then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.opts.shop_item
	
	arg_29_0.vars.max_count = to_n(var_29_0.rest_count)
	
	local var_29_1 = Dialog:open("wnd/inventory_open_box_p2")
	
	arg_29_0.vars.parent:addChild(var_29_1)
	
	arg_29_0.vars.dlg = var_29_1
	
	arg_29_0:setupListView()
	arg_29_0:setupSlider()
	arg_29_0:initUI()
	arg_29_0:setupFilter()
	arg_29_0:toggleButtons(false)
	arg_29_0.vars.listView:setListViewCascadeEnabled(true)
	arg_29_0:refresh()
	
	arg_29_0.vars.callback = arg_29_0.vars.opts.handler
end

function ItemSelectBoxDevotion.refresh(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_30_0.vars.listView) then
		return 
	end
	
	arg_30_0.vars.listView:removeAllChildren()
	
	local var_30_0 = {}
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.datas) do
		if arg_30_0:filterData(iter_30_1) then
			table.push(var_30_0, iter_30_1)
		end
	end
	
	if #var_30_0 > 0 then
		arg_30_0.vars.listView:setDataSource(var_30_0)
		if_set_visible(arg_30_0.vars.dlg, "n_info", false)
	else
		if_set_visible(arg_30_0.vars.dlg, "n_info", true)
	end
end

function ItemSelectBoxDevotion.close(arg_31_0)
	arg_31_0.vars.listView:removeAllChildren()
	Dialog:close("inventory_open_box_p2")
	
	arg_31_0.vars = nil
end

function ItemSelectBoxDevotion.filterData(arg_32_0, arg_32_1)
	if not arg_32_1 or not arg_32_1.code or not string.starts(arg_32_1.code, "c") then
		return false
	end
	
	local var_32_0 = arg_32_1.code
	local var_32_1 = arg_32_0.vars.filter_role or {
		"all"
	}
	local var_32_2 = arg_32_0.vars.filter_element or {
		"all"
	}
	local var_32_3, var_32_4, var_32_5 = DB("character", var_32_0, {
		"name",
		"role",
		"ch_attribute"
	})
	
	if not var_32_3 then
		return false
	end
	
	local var_32_6 = 0
	
	for iter_32_0, iter_32_1 in pairs(var_32_1) do
		if iter_32_1 == "all" or iter_32_1 == var_32_4 then
			var_32_6 = var_32_6 + 1
		end
	end
	
	for iter_32_2, iter_32_3 in pairs(var_32_2) do
		if iter_32_3 == "all" or iter_32_3 == var_32_5 then
			var_32_6 = var_32_6 + 1
		end
	end
	
	if not arg_32_0.vars.filter_have then
		var_32_6 = var_32_6 + 1
	elseif arg_32_0.vars.filter_have and arg_32_0:isHaveSameCodeUnit(var_32_0) then
		var_32_6 = var_32_6 + 1
	end
	
	if not arg_32_0.vars.filter_sss then
		var_32_6 = var_32_6 + 1
	elseif arg_32_0.vars.filter_sss then
		local var_32_7 = false
		
		if to_n(arg_32_0.vars.stored_sss_codes[var_32_0]) > 0 then
			var_32_7 = true
		end
		
		if not var_32_7 then
			local var_32_8 = Account:getUnitsByCode(var_32_0)
			
			for iter_32_4, iter_32_5 in pairs(var_32_8) do
				if iter_32_5:isMaxDevoteLevel() then
					var_32_7 = true
					
					break
				end
			end
		end
		
		if var_32_7 == false then
			var_32_6 = var_32_6 + 1
		end
	end
	
	return var_32_6 == 4
end

function ItemSelectBoxDevotion.isHaveSameCodeUnit(arg_33_0, arg_33_1)
	local var_33_0 = false
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.stored_dv_codes or {}) do
		if iter_33_0 == arg_33_1 then
			var_33_0 = true
			
			break
		end
	end
	
	local var_33_1 = false
	
	for iter_33_2, iter_33_3 in pairs(AccountData.gacha_temp_inventory) do
		if iter_33_2 == arg_33_1 and to_n(iter_33_3) > 0 then
			var_33_1 = true
			
			break
		end
	end
	
	return var_33_0 or var_33_1 or Account:isHaveSameCodeUnit(arg_33_1)
end

function ItemSelectBoxDevotion.setupFilter(arg_34_0)
	local var_34_0 = arg_34_0.vars.dlg:getChildByName("n_filter")
	
	arg_34_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_34_0.vars.filter_un_hash_tbl.star = nil
	arg_34_0.vars.filter_un_hash_tbl.skill = nil
	arg_34_0.vars.filter_un_hash_tbl.role[7] = nil
	
	if_set_visible(var_34_0, "btn_toggle_active", false)
	if_set_visible(var_34_0, "btn_toggle", true)
	arg_34_0:selectSubFilter(nil, true)
	
	local var_34_1 = arg_34_0.vars.dlg:getChildByName("n_sort")
	local var_34_2 = var_34_1:getChildByName("n_check_box")
	
	if_set(var_34_2, "txt_desc", T("ui_devotion_get_char_filter"))
	
	local var_34_3 = var_34_2:getChildByName("checkbox_g")
	
	if get_cocos_refid(var_34_3) then
		var_34_3:setSelected(false)
	end
	
	local var_34_4 = var_34_2:getChildByName("btn_checkbox_g")
	
	if get_cocos_refid(var_34_4) then
		var_34_4:setTouchEnabled(true)
	end
	
	local var_34_5 = var_34_1:getChildByName("n_check_box_sss")
	
	if_set(var_34_5, "txt_desc_sss", T("ui_dv_select_filter_sss"))
	
	local var_34_6 = var_34_5:getChildByName("checkbox_sss")
	
	if get_cocos_refid(var_34_6) then
		var_34_6:setSelected(false)
	end
	
	local var_34_7 = var_34_5:getChildByName("btn_checkbox_sss")
	
	if get_cocos_refid(var_34_7) then
		var_34_7:setTouchEnabled(true)
	end
end

function ItemSelectBoxDevotion.toggleFilter(arg_35_0)
	local var_35_0 = arg_35_0.vars.dlg:getChildByName("n_sort")
	
	if var_35_0:isVisible() then
		BackButtonManager:pop()
		if_set_visible(var_35_0, nil, false)
		
		return 
	end
	
	BackButtonManager:push({
		check_id = "ItemSelectBoxDevotion.toggleFilter",
		back_func = function()
			arg_35_0:toggleFilter()
		end
	})
	if_set_visible(var_35_0, nil, true)
	
	if not arg_35_0.vars.filter_role then
		arg_35_0.vars.filter_role = {
			"all"
		}
		
		arg_35_0:selectFilter("btn_checkbox_role_all", true)
	end
	
	if not arg_35_0.vars.filter_element then
		arg_35_0.vars.filter_element = {
			"all"
		}
		
		arg_35_0:selectFilter("btn_checkbox_element_all", true)
	end
end

function ItemSelectBoxDevotion.selectFilter(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars.filter_un_hash_tbl then
		return 
	end
	
	local var_37_0 = string.split(arg_37_1, "btn_checkbox_")
	
	if not var_37_0 or not var_37_0[2] then
		return 
	end
	
	local var_37_1 = string.split(var_37_0[2], "_")
	
	if not var_37_1[1] or not var_37_1[2] then
		return 
	end
	
	local var_37_2 = tostring(var_37_1[1])
	local var_37_3 = tostring(var_37_1[2])
	local var_37_4 = arg_37_0.vars.dlg:getChildByName("n_sort"):getChildByName("n_" .. var_37_2)
	
	if not get_cocos_refid(var_37_4) then
		return 
	end
	
	arg_37_0.vars["filter_" .. var_37_2] = {}
	
	local var_37_5 = arg_37_0.vars.filter_un_hash_tbl[var_37_2]
	local var_37_6 = false
	
	if var_37_3 == "all" then
		var_37_6 = var_37_4:getChildByName("n_check_box_all"):getChildByName("checkbox_" .. var_37_2 .. "_all"):isSelected()
		
		if arg_37_2 then
			var_37_6 = false
		end
	end
	
	local var_37_7 = 0
	
	for iter_37_0, iter_37_1 in pairs(var_37_5) do
		iter_37_0 = tostring(iter_37_0)
		
		local var_37_8 = var_37_4:getChildByName("n_check_box_" .. iter_37_0)
		local var_37_9 = var_37_8:getChildByName("checkbox_" .. var_37_2 .. "_" .. iter_37_0)
		local var_37_10 = var_37_8:getChildByName("select_bg_" .. var_37_2 .. "_" .. iter_37_0)
		
		if var_37_3 == "all" then
			if iter_37_0 == "all" then
				var_37_9:setSelected(not var_37_6)
				var_37_10:setVisible(not var_37_6)
			else
				var_37_9:setSelected(var_37_6)
				var_37_10:setVisible(var_37_6)
			end
		else
			if iter_37_0 == "all" then
				var_37_9:setSelected(false)
				var_37_10:setVisible(false)
			end
			
			if iter_37_0 == var_37_3 then
				local var_37_11 = var_37_9:isSelected()
				
				var_37_9:setSelected(not var_37_11)
				var_37_10:setVisible(not var_37_11)
			end
		end
		
		if var_37_9:isSelected() then
			var_37_7 = var_37_7 + 1
			
			table.push(arg_37_0.vars["filter_" .. var_37_2], iter_37_1)
		end
	end
	
	if var_37_7 == 0 then
		arg_37_0:selectFilter("btn_checkbox_" .. var_37_2 .. "_all", true)
	else
		arg_37_0:refresh()
	end
	
	arg_37_0:updateToggleButton()
end

function ItemSelectBoxDevotion.updateToggleButton(arg_38_0)
	local var_38_0 = arg_38_0:getFilterActive()
	local var_38_1 = arg_38_0.vars.dlg:getChildByName("n_filter")
	
	if_set_visible(var_38_1, "btn_toggle", not var_38_0)
	if_set_visible(var_38_1, "btn_toggle_active", var_38_0)
end

function ItemSelectBoxDevotion.getFilterActive(arg_39_0)
	local var_39_0 = arg_39_0.vars.filter_role or {
		"all"
	}
	local var_39_1 = arg_39_0.vars.filter_element or {
		"all"
	}
	
	if arg_39_0.vars.filter_have or arg_39_0.vars.filter_sss then
		return true
	end
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if iter_39_1 ~= "all" then
			return true
		end
	end
	
	for iter_39_2, iter_39_3 in pairs(var_39_1) do
		if iter_39_3 ~= "all" then
			return true
		end
	end
	
	return false
end

function ItemSelectBoxDevotion.selectSubFilter(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0.vars.dlg:getChildByName("n_sort")
	
	if arg_40_1 == 1 then
		arg_40_0.vars.filter_have = not arg_40_0.vars.filter_have
		
		var_40_0:getChildByName("n_check_box"):getChildByName("checkbox_g"):setSelected(arg_40_0.vars.filter_have)
	end
	
	if arg_40_1 == 2 then
		arg_40_0.vars.filter_sss = not arg_40_0.vars.filter_sss
		
		var_40_0:getChildByName("n_check_box_sss"):getChildByName("checkbox_sss"):setSelected(arg_40_0.vars.filter_sss)
	end
	
	if not arg_40_2 then
		arg_40_0:refresh()
	end
	
	arg_40_0:updateToggleButton()
end
