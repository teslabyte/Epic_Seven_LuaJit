UnitEquipChangeSubList = {}

function HANDLER.item_option_change_card(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_select" then
		UnitEquipChangeSubList:onSelect(arg_1_0)
	end
end

function UnitEquipChangeSubList.onSelect(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.item_data
	
	if not var_2_0 then
		Log.e("No Item Data.")
		
		return 
	end
	
	if not arg_2_0.vars.selectable then
		balloon_message_with_sound("msg_change_option_before_error")
		
		return 
	end
	
	if var_2_0.have_count <= 0 then
		balloon_message_with_sound("msg_change_option_material_lack")
		
		return 
	end
	
	arg_2_0:unselectCurrentControl()
	
	if not arg_2_1.parent then
		Log.e("No Parent")
		
		return 
	end
	
	if arg_2_0.vars.selected_data then
		arg_2_0.vars.selected_data.select = false
	end
	
	if var_2_0 == arg_2_0.vars.selected_data then
		arg_2_0.vars.selected_data = nil
		
		UnitEquipChangeSub:onScrollViewItemSelected(nil, true)
	else
		arg_2_0.vars.selected_data = var_2_0
		arg_2_0.vars.selected_data.select = true
		
		UnitEquipChangeSub:onScrollViewItemSelected(var_2_0)
	end
	
	arg_2_0.vars.listview:lightRefresh()
end

function UnitEquipChangeSubList.unselectCurrentControl(arg_3_0)
	if arg_3_0.vars.selected_data then
		arg_3_0.vars.selected_data.select = false
		
		arg_3_0.vars.listview:lightRefresh()
	end
end

function UnitEquipChangeSubList.resetSelect(arg_4_0)
	arg_4_0:setSelectable(arg_4_0.vars.selectable)
end

function UnitEquipChangeSubList.setSelectable(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	arg_5_0.vars.selectable = arg_5_1
	
	arg_5_0:unselectCurrentControl()
	
	arg_5_0.vars.selected_data = nil
end

function UnitEquipChangeSubList.initListView(arg_6_0, arg_6_1)
	arg_6_0.vars.listview = ItemListView_v2:bindControl(arg_6_1)
	
	local var_6_0 = load_control("wnd/item_option_change_card.csb")
	
	if arg_6_1.STRETCH_INFO then
		local var_6_1 = arg_6_1:getContentSize()
		
		resetControlPosAndSize(var_6_0, var_6_1.width, arg_6_1.STRETCH_INFO.width_prev)
	end
	
	local var_6_2 = {
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			UnitEquipChangeSubList:updateListViewItem(arg_7_1, arg_7_3)
		end,
		onLightUpdate = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			UnitEquipChangeSubList:updateLightRefresh(arg_8_1, arg_8_3)
		end
	}
	
	arg_6_0.vars.listview:setRenderer(var_6_0, var_6_2)
	arg_6_0.vars.listview:removeAllChildren()
end

function UnitEquipChangeSubList.setData(arg_9_0, arg_9_1)
	arg_9_0.vars.origin_list = arg_9_1
	
	local var_9_0 = table.clone(arg_9_0.vars.origin_list)
	
	table.sort(var_9_0, function(arg_10_0, arg_10_1)
		local var_10_0 = Account:getItemCount(arg_10_0) == 0
		
		if var_10_0 ~= (Account:getItemCount(arg_10_1) == 0) then
			return not var_10_0
		end
		
		return DB("item_material", arg_10_0, "sort") > DB("item_material", arg_10_1, "sort")
	end)
	
	local var_9_1 = {}
	
	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		var_9_1[iter_9_0] = arg_9_0:getDataFromCode(iter_9_1)
	end
	
	arg_9_0.vars.list = var_9_1
	
	arg_9_0.vars.listview:setDataSource(arg_9_0.vars.list)
end

function UnitEquipChangeSubList.init(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0.vars = {}
	arg_11_0.vars.origin_list = arg_11_2
	
	arg_11_0:initListView(arg_11_1)
	arg_11_0:setData(arg_11_2)
end

function UnitEquipChangeSubList.getHaveCount(arg_12_0, arg_12_1)
	return Account:getItemCount(arg_12_1)
end

function UnitEquipChangeSubList.getDataFromCode(arg_13_0, arg_13_1)
	local var_13_0, var_13_1, var_13_2, var_13_3 = DB("item_material", arg_13_1, {
		"ma_type",
		"ma_type2",
		"icon",
		"grade"
	})
	
	if var_13_0 ~= "change" then
		Log.e("MATERIAL TYPE INVALID IN UNIT EQUIP CHANGE SUB SCROLL")
		
		return 
	end
	
	local var_13_4 = UnitEquipUtil:parsingSubStatChangeMaType2(var_13_1)
	
	if not var_13_4 then
		Log.e("SPLIT FAILED")
		
		return 
	end
	
	local var_13_5 = {
		stat_type = "",
		icon = var_13_2,
		grade = var_13_3,
		have_count = arg_13_0:getHaveCount(arg_13_1),
		sub_stat_code = var_13_4[1],
		set = var_13_4[2],
		material_id = arg_13_1
	}
	
	var_13_5.stat_type = UnitEquipChangeSub:getLogic():getStatType(var_13_5.sub_stat_code)
	
	return var_13_5
end

function UnitEquipChangeSubList.updateLightRefresh(arg_14_0, arg_14_1, arg_14_2)
	if_set_visible(arg_14_1, "select", arg_14_2.select)
end

function UnitEquipChangeSubList.updateListViewItem(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2
	
	if_set_visible(arg_15_1, "icon_pers", UNIT.is_percentage_stat(var_15_0.stat_type))
	UIUtil:setStatIcon(arg_15_1:findChildByName("icon_stat"), var_15_0.stat_type)
	
	local var_15_1 = arg_15_1:findChildByName("t_main_stat")
	
	if get_cocos_refid(var_15_1) then
		if_set(var_15_1, nil, getStatName(var_15_0.stat_type))
		UIUserData:call(var_15_1, "MULTI_SCALE_LONG_WORD(), MULTI_SCALE(2,50)", {
			origin_scale_x = 0.88
		})
	end
	
	if_set_visible(arg_15_1, "select", false)
	if_set_visible(arg_15_1, "icon_check", false)
	
	local var_15_2 = arg_15_1:findChildByName("n_count")
	
	if get_cocos_refid(var_15_2) then
		local var_15_3 = var_15_2:getChildByName("t_count")
		
		if get_cocos_refid(var_15_3) then
			if_set(var_15_3, nil, tostring(var_15_0.have_count))
			UIUserData:call(var_15_3, "SINGLE_WSCALE(91)", {
				origin_scale_x = 0.88
			})
			if_set_visible(var_15_3, nil, var_15_0.have_count ~= 0)
			if_set_visible(var_15_2, "t_none", var_15_0.have_count == 0)
		end
	end
	
	if_set_visible(arg_15_1, "equip", false)
	UIUtil:setStatIcon(arg_15_1:findChildByName("n_stat"), var_15_0.stat_type)
	UIUtil:getRewardIcon(nil, var_15_0.material_id, {
		no_count = true,
		parent = arg_15_1:findChildByName("bg_item"),
		set_fx = var_15_0.set
	})
	
	local var_15_4 = arg_15_1:findChildByName("btn_select")
	
	var_15_4.item_data = var_15_0
	var_15_4.parent = arg_15_1
	
	local var_15_5 = 255
	
	if var_15_0.have_count <= 0 then
		var_15_5 = var_15_5 * 0.3
	end
	
	if_set_opacity(arg_15_1, nil, var_15_5)
	arg_15_0:updateLightRefresh(arg_15_1, var_15_0)
end

DEBUG.SHOW_EQUIP_UPGRADE_CNT = false
UnitEquipChangeSub = {}

function HANDLER.item_option_change(arg_16_0, arg_16_1)
	if string.starts(arg_16_1, "btn_stat") then
		UnitEquipChangeSub:onSelectStat(arg_16_0)
	end
	
	if arg_16_1 == "btn_ok" then
		UnitEquipChangeSub:requestSubOptionSelect()
	end
	
	if arg_16_1 == "btn_select" then
		UnitEquipChangeSubList:onSelect(arg_16_0)
	end
end

function UnitEquipChangeSub.sendNoUIError(arg_17_0, arg_17_1)
	Log.e(" Unit Equip Change Sub Not Found :  ", arg_17_1)
end

function UnitEquipChangeSub.findNode(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_1:findChildByName(arg_18_2)
	
	if not get_cocos_refid(var_18_0) then
		arg_18_0:sendNoUIError(arg_18_3 or arg_18_2)
		
		return 
	end
	
	return var_18_0
end

function UnitEquipChangeSub.onSelectStat(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.stat_num
	
	if not var_19_0 then
		arg_19_0:sendNoUIError("variable, stat_num")
		
		return 
	end
	
	local var_19_1 = arg_19_0.vars.idx_to_sub_stat[var_19_0]
	
	if arg_19_0.vars.logic:isAlreadySubOptionChanged() and arg_19_0.vars.logic:getChangedSubOptionId() ~= var_19_1 then
		balloon_message_with_sound("msg_change_option_impossible")
		
		return 
	end
	
	local var_19_2 = arg_19_0:findNode(arg_19_0.vars.wnd, "n_sub_stat")
	
	if not var_19_2 then
		return 
	end
	
	local var_19_3 = arg_19_0:findNode(var_19_2, "n_substat" .. var_19_0)
	
	if not var_19_3 then
		return 
	end
	
	local var_19_4 = arg_19_0:findNode(var_19_3, "check_box_3")
	
	if not var_19_4 then
		return 
	end
	
	if arg_19_0.vars.selected_stat_num ~= nil and arg_19_0.vars.selected_stat_num ~= var_19_0 then
		local var_19_5 = arg_19_0:findNode(var_19_2, "n_substat" .. arg_19_0.vars.selected_stat_num)
		
		if not var_19_5 then
			return 
		end
		
		local var_19_6 = arg_19_0:findNode(var_19_5, "check_box_3")
		
		if not var_19_6 then
			return 
		end
		
		var_19_6:setSelected(false)
		if_set_visible(var_19_5, "selected", false)
		if_set_visible(var_19_5, "n_up", false)
	end
	
	var_19_4:setSelected(not var_19_4:isSelected())
	
	local var_19_7 = var_19_4:isSelected()
	
	if arg_19_0.vars.selected_stat_num then
		arg_19_0:onSelected(nil, false, arg_19_0.vars.selected_stat_num)
	else
		arg_19_0:onSelected(nil, false)
	end
	
	if var_19_7 then
		arg_19_0.vars.selected_stat_num = var_19_0
		
		UnitEquipChangeSubList:setData(arg_19_0.vars.logic:getUsableSubStatChangeMaterialsId(true, var_19_1))
	else
		arg_19_0.vars.selected_stat_num = nil
		
		UnitEquipChangeSubList:setData(arg_19_0.vars.logic:getUsableSubStatChangeMaterialsId())
	end
	
	arg_19_0.vars.selected_item_data = nil
	
	if_set_visible(var_19_3, "selected", var_19_7)
	UnitEquipChangeSubList:setSelectable(var_19_7)
end

function UnitEquipChangeSub.onSelected(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0
	
	if arg_20_2 then
		var_20_0 = arg_20_1.sub_stat_code
	end
	
	arg_20_0:updateButtonStatus(arg_20_2, var_20_0)
	
	if not arg_20_3 then
		return 
	end
	
	local var_20_1 = arg_20_0:findNode(arg_20_0.vars.wnd, "n_sub_stat")
	
	if not var_20_1 then
		return 
	end
	
	local var_20_2 = arg_20_0:findNode(var_20_1, "n_substat" .. arg_20_3)
	
	if not var_20_2 then
		return 
	end
	
	local var_20_3 = arg_20_0:findNode(var_20_2, "n_up")
	
	if not var_20_3 then
		return 
	end
	
	if_set_visible(var_20_3, nil, arg_20_2)
	
	if arg_20_2 then
		arg_20_0.vars.selected_item_data = arg_20_1
	else
		arg_20_0.vars.selected_item_data = nil
	end
	
	if not arg_20_2 then
		return 
	end
	
	local var_20_4 = arg_20_0.vars.logic:getExpectChangeSubStatRange(arg_20_1.sub_stat_code, arg_20_0.vars.idx_to_sub_stat[arg_20_3])
	
	UIUtil:setStatIcon(var_20_3:findChildByName("icon_stat"), arg_20_1.stat_type)
	if_set(var_20_3, "after_stat", to_var_str(var_20_4.min, arg_20_1.stat_type) .. "~" .. to_var_str(var_20_4.max, arg_20_1.stat_type))
end

function UnitEquipChangeSub.onScrollViewItemSelected(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0:onSelected(arg_21_1, not arg_21_2, arg_21_0.vars.selected_stat_num)
end

function MsgHandler.substat_change_equip(arg_22_0)
	UnitEquipChangeSub:procQuery(arg_22_0)
	
	if arg_22_0.stored_item and tonumber(arg_22_0.stored_item) == 1 then
		EquipStorageManage:resetUI()
	end
end

function UnitEquipChangeSub.procQuery(arg_23_0, arg_23_1)
	arg_23_0.vars.result_rtn = table.clone(arg_23_1)
	
	UIAction:Add(SEQ(SPAWN(CALL(function()
		local var_24_0 = arg_23_0.vars.wnd:findChildByName("n_target")
		
		EffectManager:Play({
			fn = "ui_item_option_change_main.cfx",
			layer = var_24_0
		})
	end), CALL(function()
		local var_25_0 = arg_23_0.vars.wnd:findChildByName("n_substat" .. arg_23_0.vars.selected_stat_num)
		
		EffectManager:Play({
			pivot_x = 206,
			fn = "ui_item_option_change_stat.cfx",
			layer = var_25_0
		})
	end)), DELAY(2666), CALL(function()
		arg_23_0:applyChange(arg_23_0.vars.result_rtn)
		
		arg_23_0.vars.result_rtn = nil
	end)), arg_23_0, "block")
end

function UnitEquipChangeSub.applyChange(arg_27_0, arg_27_1)
	for iter_27_0, iter_27_1 in pairs(arg_27_1.items) do
		Account:setItemCount(iter_27_0, iter_27_1)
	end
	
	Account:updateCurrencies(arg_27_1)
	
	local var_27_0 = tonumber(arg_27_1.target)
	
	if var_27_0 ~= arg_27_0.vars.equip:getUID() then
		local var_27_1 = tostring(var_27_0) .. " " .. arg_27_0.vars.equip:getUID()
		
		Log.e("SEND EQUIP DIFF RECIVE TARGET! " .. var_27_1)
		
		return 
	end
	
	local var_27_2
	
	if arg_27_1.stored_item and tonumber(arg_27_1.stored_item) == 1 then
		var_27_2 = Account:getEquipFromStorage(var_27_0)
	else
		var_27_2 = Account:getEquip(var_27_0)
	end
	
	if not var_27_2 then
		Log.e("EQUIP IS NIL! UID OK?", var_27_0)
		
		return 
	end
	
	local var_27_3 = UnitEquipUtil:getOptionsSumTable(var_27_2)
	
	var_27_2.op = arg_27_1.equip.op
	
	var_27_2:update()
	UnitEquipUtil:reCalcUnitStatByEquipEnhance(var_27_2)
	
	local var_27_4 = UnitEquipUtil:getOptionsSumTable(var_27_2)
	local var_27_5 = UnitEquipUtil:findDiffOption(var_27_3, var_27_4) or arg_27_0.vars.selected_stat_num
	local var_27_6 = arg_27_0.vars.wnd:findChildByName("LEFT")
	local var_27_7 = var_27_6:findChildByName("txt_sub_stat" .. var_27_5)
	
	UIUtil:startStatUpEffect(var_27_7)
	
	local var_27_8 = var_27_6:findChildByName("t_equip_point")
	
	UIUtil:startStatUpEffect(var_27_8)
	
	arg_27_0.vars.equip = var_27_2
	
	arg_27_0.vars.logic:endLogic()
	
	arg_27_0.vars.logic = UnitEquipChangeSubLogic:startLogic(var_27_2)
	
	arg_27_0:updateEquipInfo(var_27_2)
	arg_27_0:updateStatInfo(var_27_2)
	UnitEquipChangeSubList:resetSelect()
end

function UnitEquipChangeSub.sendQuery(arg_28_0)
	if not arg_28_0.vars then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.selected_item_data
	local var_28_1 = arg_28_0.vars.selected_stat_num
	local var_28_2 = arg_28_0.vars.idx_to_sub_stat
	local var_28_3 = arg_28_0.vars.equip
	local var_28_4 = arg_28_0.vars.logic
	
	if not var_28_0 or not var_28_1 or not var_28_2 or not var_28_3 or not var_28_4 then
		Log.e("SEND QUERY FAILED : NOT REQ DATAS")
		
		return 
	end
	
	local var_28_5 = var_28_2[var_28_1]
	
	if not var_28_5 then
		Log.e("NO TARGET")
		
		return 
	end
	
	local var_28_6, var_28_7 = DB("item_material", var_28_0.material_id, {
		"ma_type",
		"price"
	})
	
	if var_28_7 > Account:getCurrency("gold") then
		balloon_message_with_sound("need_gold")
		
		return 
	end
	
	if var_28_6 ~= "change" then
		Log.e("ITEM MATERIAL IS NOT CHANGE!")
		
		return 
	end
	
	if not arg_28_0.vars.logic:verifyMaterial(var_28_0.material_id, var_28_5) then
		Log.e("VERIFY FAILED")
		
		return 
	end
	
	local var_28_8 = var_28_3.list_type == "storage" and 1 or nil
	
	query("substat_change_equip", {
		material_id = var_28_0.material_id,
		target_stat = var_28_5,
		target = var_28_3:getUID(),
		stored_item = var_28_8
	})
end

function UnitEquipChangeSub.requestSubOptionSelect(arg_29_0)
	if not arg_29_0.vars.selected_item_data then
		return 
	end
	
	if arg_29_0.vars.logic:isBiggerOrSameChangeValue() then
		Dialog:msgBox(T("ui_change_popup_max_stat"), {
			ok_text = T("ui_msgbox_ok"),
			title = T("ui_change_popup_title")
		})
		
		return 
	end
	
	if not arg_29_0.vars.logic:isAlreadySubOptionChanged() then
		local var_29_0 = arg_29_0.vars.selected_item_data
		local var_29_1 = DB("item_equip_substat_change", var_29_0.sub_stat_code, "price")
		local var_29_2 = Dialog:msgBox(T("ui_change_popup_desc", {
			name = arg_29_0.vars.equip:getName()
		}), {
			token = "to_gold",
			yesno = true,
			cost = var_29_1,
			title = T("ui_change_popup_title"),
			warning = T("ui_change_popup_desc2"),
			handler = function()
				UnitEquipChangeSub:sendQuery()
			end
		})
		
		if_set(var_29_2, "txt_warning", T("ui_change_popup_desc2"))
	else
		arg_29_0:sendQuery()
	end
end

function UnitEquipChangeSub.onPushBackButton(arg_31_0)
	UIUtil:showChilds(arg_31_0.vars.parent_childs)
	TopBarNew:pop()
	BackButtonManager:pop()
	arg_31_0.vars.wnd:removeFromParent()
	arg_31_0.vars.logic:endLogic()
	
	arg_31_0.vars = nil
	
	if InventoryPopupDetail:IsOpen() then
		InventoryPopupDetail:update()
	end
	
	if UnitMain:isValid() and UnitDetail:isValid() then
		UnitDetail:updateUnitInfo()
	end
	
	if TopBarNew:isEnabledTopRight() then
		TopBarNew:setEnableTopRight()
	end
end

function UnitEquipChangeSub.updateButtonStatus(arg_32_0, arg_32_1, arg_32_2)
	if arg_32_1 and not arg_32_2 then
		Log.e("STATUS TUR BUT NOT PASS MATERIAL ID")
		
		return 
	end
	
	local var_32_0 = 255
	
	if not arg_32_1 then
		var_32_0 = var_32_0 * 0.3
	end
	
	if_set_opacity(arg_32_0.vars.wnd, "btn_ok", var_32_0)
	
	local var_32_1 = 0
	
	if arg_32_1 then
		var_32_1 = DB("item_equip_substat_change", arg_32_2, "price")
	end
	
	if_set(arg_32_0.vars.wnd, "cost", comma_value(var_32_1))
end

function UnitEquipChangeSub.updateEquipInfo(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.vars.wnd:findChildByName("n_equip_detail")
	local var_33_1 = UIUtil:makeUnitEquipItemTooltipOpts(var_33_0, arg_33_1)
	
	ItemTooltip:updateItemInformation(var_33_1)
	UIUtil:updateUnitEquipNamePosition(var_33_1)
end

function UnitEquipChangeSub.updateStatInfo(arg_34_0, arg_34_1)
	local var_34_0 = UnitEquipUtil:getEquipDetail(arg_34_1)
	local var_34_1 = arg_34_0.vars.wnd:findChildByName("n_sub_stat")
	
	if not var_34_0.is_equip then
		Log.e("NOT EQUIP, BUT ACCESS HERE.")
		
		return 
	end
	
	if not var_34_0.equip_stat then
		Log.e("NOT SUBSTAT DATA.")
		
		return 
	end
	
	for iter_34_0 = 1, 4 do
		local var_34_2 = var_34_1:findChildByName("n_substat" .. iter_34_0)
		
		if_set_visible(var_34_2, nil, false)
	end
	
	local var_34_3, var_34_4 = UnitEquipUtil:getSubStat(var_34_0)
	local var_34_5 = UnitEquipUtil:getSubStatUpgradeCount(var_34_0)
	
	arg_34_0.vars.idx_to_sub_stat = {}
	
	local var_34_6 = arg_34_0.vars.logic:isAlreadySubOptionChanged()
	local var_34_7 = arg_34_0.vars.logic:getChangedSubOptionId()
	local var_34_8
	
	for iter_34_1, iter_34_2 in pairs(var_34_3) do
		local var_34_9 = var_34_4[iter_34_1]
		local var_34_10 = var_34_1:findChildByName("n_substat" .. var_34_9)
		
		if_set_visible(var_34_10, nil, true)
		if_set_visible(var_34_10, "selected", false)
		
		local var_34_11 = var_34_10:findChildByName("check_box_3")
		
		if get_cocos_refid(var_34_11) then
			var_34_11:setSelected(false)
		end
		
		local var_34_12 = iter_34_1
		local var_34_13 = iter_34_2
		
		UIUtil:setStatIcon(var_34_10:findChildByName("icon_stat"), var_34_12)
		
		local var_34_14 = to_var_str(var_34_13, var_34_12)
		
		if DEBUG.SHOW_EQUIP_UPGRADE_CNT then
			var_34_14 = var_34_14 .. "(" .. var_34_5[iter_34_1] .. ")"
		end
		
		if_set(var_34_10, "txt_sub_stat", var_34_14)
		
		local var_34_15 = var_34_10:findChildByName("btn_stat3")
		
		if get_cocos_refid(var_34_15) then
			var_34_15.stat_num = var_34_9
		end
		
		arg_34_0.vars.idx_to_sub_stat[var_34_9] = iter_34_1
		
		if var_34_6 and iter_34_1 ~= var_34_7 then
			if_set_opacity(var_34_10, nil, 76.5)
		elseif var_34_6 and iter_34_1 == var_34_7 then
			var_34_8 = var_34_15
		end
	end
	
	arg_34_0:updateButtonStatus(false)
	
	if var_34_8 then
		arg_34_0:onSelectStat(var_34_8)
	end
end

function UnitEquipChangeSub.setCenterEquipIcon(arg_35_0, arg_35_1)
	UIUtil:getRewardIcon("equip", arg_35_1.db.code, {
		scale = 1,
		no_tooltip = true,
		equip = arg_35_1,
		parent = arg_35_0.vars.wnd:getChildByName("n_target")
	})
	if_set(arg_35_0.vars.wnd, "item_name", arg_35_1:getName())
end

function UnitEquipChangeSub.getLogic(arg_36_0)
	return arg_36_0.vars.logic
end

function UnitEquipChangeSub.setupBackgroundEffect(arg_37_0)
	local var_37_0 = arg_37_0.vars.wnd:findChildByName("bg_effect")
	
	if not var_37_0 then
		return 
	end
	
	EffectManager:Play({
		loop = true,
		fn = "ui_item_option_change_bg.cfx",
		layer = var_37_0
	})
end

function UnitEquipChangeSub.init(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_2 then
		return 
	end
	
	arg_38_0.vars = {}
	arg_38_0.vars.equip = arg_38_2
	arg_38_0.vars.logic = UnitEquipChangeSubLogic:startLogic(arg_38_0.vars.equip)
	
	if not arg_38_0.vars.logic:isCanChangeSubStat() then
		arg_38_0.vars.logic:endLogic()
		
		arg_38_0.vars = nil
		
		return 
	end
	
	arg_38_0.vars.wnd = load_dlg("item_option_change", true, "wnd")
	
	TopBarNew:createFromPopup(T("system_139_title"), arg_38_0.vars.wnd, function()
		arg_38_0:onPushBackButton()
	end)
	arg_38_0:setupBackgroundEffect()
	
	arg_38_0.vars.parent_childs = UIUtil:hideChilds(arg_38_1)
	
	arg_38_1:addChild(arg_38_0.vars.wnd)
	UnitEquipChangeSubList:init(arg_38_0.vars.wnd:findChildByName("listview"), arg_38_0.vars.logic:getUsableSubStatChangeMaterialsId())
	arg_38_0:updateEquipInfo(arg_38_0.vars.equip)
	arg_38_0:updateStatInfo(arg_38_0.vars.equip)
	arg_38_0:setCenterEquipIcon(arg_38_0.vars.equip)
	TopBarNew:setDisableTopRight()
	
	if not TutorialGuide:isClearedTutorial(UNLOCK_ID.EQUIP_SUB_CHANGE) then
		TutorialGuide:startGuide(UNLOCK_ID.EQUIP_SUB_CHANGE)
	end
	
	return true
end

local var_0_0 = 1e-07

UnitEquipChangeSubLogic = {}

function UnitEquipChangeSubLogic.startLogic(arg_40_0, arg_40_1)
	local var_40_0 = {}
	
	copy_functions(UnitEquipChangeSubLogic, var_40_0)
	
	var_40_0.vars = {}
	var_40_0.vars.equip = arg_40_1
	
	if arg_40_1 then
		var_40_0.vars.equip_detail = UnitEquipUtil:getEquipDetail(arg_40_1)
		var_40_0.vars.sub_stat_upgrade_cnt = UnitEquipUtil:getSubStatUpgradeCount(var_40_0.vars.equip_detail)
	end
	
	return var_40_0
end

function UnitEquipChangeSubLogic.isCanChangeSubStat(arg_41_0)
	local var_41_0 = arg_41_0.vars.equip
	
	return var_41_0:isMaxEnhance() and var_41_0:isBasicEquip()
end

function UnitEquipChangeSubLogic.sendError(arg_42_0, arg_42_1, arg_42_2)
	if arg_42_2 then
		return 
	end
	
	Log.e(" Change Sub Stat Logic Error, ", arg_42_1)
end

function UnitEquipChangeSubLogic.info(arg_43_0, ...)
	local var_43_0 = {
		...
	}
	local var_43_1 = ""
	
	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		var_43_1 = var_43_1 .. ", " .. tostring(iter_43_1)
	end
	
	return var_43_1
end

function UnitEquipChangeSubLogic.getChangeStat(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = DB("item_equip_substat_change", arg_44_1, "change_stat_" .. arg_44_2)
	
	if not var_44_0 then
		arg_44_0:sendError(arg_44_0:info("check_stat", var_44_0, "code", arg_44_1))
		
		return 
	end
	
	return var_44_0
end

function UnitEquipChangeSubLogic.isAlreadySubOptionChanged(arg_45_0)
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.equip.op) do
		if iter_45_0 ~= 1 and iter_45_1 and iter_45_1[3] == "c" then
			return true
		end
	end
	
	return false
end

function UnitEquipChangeSubLogic.getChangedSubOptionId(arg_46_0)
	for iter_46_0, iter_46_1 in pairs(arg_46_0.vars.equip.op) do
		if iter_46_0 ~= 1 and iter_46_1 and iter_46_1[3] == "c" then
			return iter_46_1[1]
		end
	end
end

function UnitEquipChangeSubLogic.verifySubStatDBId(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_0:getOptionsInEquip(true)[arg_47_2] then
		arg_47_0:sendError(arg_47_0:info("verify failed. EQUIP NOT HAVE THAT SUB Option", arg_47_1, arg_47_2))
		
		return 
	end
	
	local var_47_0 = arg_47_0:getUsableSubStats(true, arg_47_2)
	local var_47_1 = arg_47_0:getDBIdsFromStatType(arg_47_1)
	
	if not table.find(var_47_0, var_47_1) then
		arg_47_0:sendError(arg_47_0:info("verify failed. check sub_stats", var_47_1, arg_47_1, arg_47_2))
		
		return 
	end
	
	if arg_47_0:isAlreadySubOptionChanged() then
		local var_47_2 = arg_47_0:getChangedSubOptionId()
		
		if var_47_2 ~= arg_47_2 then
			arg_47_0:sendError(arg_47_0:info("verify failed. ALREADY CHANGED MATERIAL EXIST, BUT SELECTED IS DIFF", arg_47_2, var_47_2, arg_47_0.vars.equip.db.code))
			
			return 
		end
	end
	
	return true
end

function UnitEquipChangeSubLogic.verifyMaterial(arg_48_0, arg_48_1, arg_48_2)
	if not arg_48_0:isCanChangeSubStat() then
		arg_48_0:sendError(arg_48_0:info("equip not substat change", arg_48_1, arg_48_0.vars.equip.set_fx, arg_48_0.vars.equip.db.code))
		
		return 
	end
	
	local var_48_0, var_48_1 = DB("item_material", arg_48_1, {
		"ma_type",
		"ma_type2"
	})
	
	if var_48_0 ~= "change" then
		arg_48_0:sendError(arg_48_0:info("material type not change", arg_48_1, arg_48_0.vars.equip.set_fx, arg_48_0.vars.equip.db.code))
		
		return 
	end
	
	local var_48_2 = arg_48_0:parsingSubStatChangeMaType2(var_48_1)
	local var_48_3 = arg_48_0:getSubStatDBId(nil, var_48_2)
	
	if arg_48_0:getSetFx(nil, var_48_2) ~= arg_48_0.vars.equip.set_fx then
		arg_48_0:sendError(arg_48_0:info("verify failed. check fx", arg_48_1, arg_48_0.vars.equip.set_fx, arg_48_0.vars.equip.db.code))
		
		return 
	end
	
	return arg_48_0:verifySubStatDBId(var_48_3, arg_48_2)
end

function UnitEquipChangeSubLogic.getEquipStatId(arg_49_0, arg_49_1, arg_49_2)
	return arg_49_1 .. "_" .. arg_49_2
end

function UnitEquipChangeSubLogic.isExistEquipSubChangeItem(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0:getChangeStat(arg_50_1, 1)
	
	if not var_50_0 then
		return false
	end
	
	if not DB("equip_stat", arg_50_0:getEquipStatId(var_50_0, 1), "id") then
		arg_50_0:sendError(arg_50_0:info("check_stat_id", var_50_0, "failed check equip_stat"))
		
		return false
	end
	
	return true
end

function UnitEquipChangeSubLogic.getStatType(arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0:getChangeStat(arg_51_1, 1)
	
	if not var_51_0 then
		return false
	end
	
	local var_51_1 = DB("equip_stat", arg_51_0:getEquipStatId(var_51_0, 1), "stat_type")
	
	if not var_51_1 then
		arg_51_0:sendError(arg_51_0:info("check_stat_type_id", var_51_0, "failed get stat_type"))
		
		return 
	end
	
	return var_51_1
end

function UnitEquipChangeSubLogic.getUpgradeCnt(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0.vars.sub_stat_upgrade_cnt[arg_52_1]
	
	if not var_52_0 then
		arg_52_0:sendError(arg_52_0:info("stat_type", arg_52_1, "please stat_type check before use,"))
		
		return 
	end
	
	return var_52_0
end

function UnitEquipChangeSubLogic.isBiggerOrSameChangeValue(arg_53_0)
	if not arg_53_0.vars.last_range then
		arg_53_0:sendError(arg_53_0:info("bigger then change value get error", "please check last range. REQ get range."))
		
		return 
	end
	
	return arg_53_0.vars.last_range.bigger_or_same_change_value
end

function UnitEquipChangeSubLogic.getValues(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0, var_54_1 = DB("equip_stat", arg_54_1 .. "_" .. arg_54_2, {
		"val_min",
		"val_max"
	})
	
	if not var_54_0 or not var_54_1 then
		arg_54_0:sendError(arg_54_0:info("stat_id", arg_54_1), arg_54_3)
		
		return 
	end
	
	return {
		min = var_54_0,
		max = var_54_1
	}
end

function UnitEquipChangeSubLogic.getExpectChangeSubStatRange(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_0:isExistEquipSubChangeItem(arg_55_1) then
		return 
	end
	
	if not arg_55_0:verifySubStatDBId(arg_55_1, arg_55_2) then
		return 
	end
	
	local var_55_0 = arg_55_0:getUpgradeCnt(arg_55_2)
	
	if not var_55_0 then
		return 
	end
	
	local var_55_1 = arg_55_0:getChangeStat(arg_55_1, var_55_0)
	local var_55_2 = arg_55_0:getValues(var_55_1, 1)
	local var_55_3
	
	for iter_55_0 = 2, 99 do
		local var_55_4 = arg_55_0:getValues(var_55_1, iter_55_0, true)
		
		if not var_55_4 then
			if iter_55_0 == 2 then
				print("[WARN] Sub Logic Can't find Upgrade Option.  ")
				
				var_55_3 = var_55_2
			end
			
			break
		end
		
		var_55_3 = var_55_4
	end
	
	if not var_55_2 or not var_55_3 then
		arg_55_0:sendError(arg_55_0:info("FIND FAILED! CHECK LOGIC!", var_55_2, var_55_3))
		
		return 
	end
	
	local var_55_5 = arg_55_0:getStatType(arg_55_1)
	local var_55_6 = var_55_2.min
	local var_55_7 = var_55_3.max
	local var_55_8 = UnitEquipUtil:getOptionsSumTable(arg_55_0.vars.equip)
	local var_55_9
	
	for iter_55_1, iter_55_2 in pairs(var_55_8) do
		if iter_55_2[1] == var_55_5 and iter_55_2[1] == arg_55_2 then
			var_55_9 = iter_55_1
		end
	end
	
	local var_55_10 = UnitEquipUtil:findUpgradeOption(arg_55_0.vars.equip.code)
	
	if var_55_10 and var_55_9 then
		local var_55_11 = UnitEquipUtil:getUpgradeTagValue(arg_55_0.vars.equip, var_55_5)
		
		var_55_6 = var_55_11 + var_55_6
		var_55_7 = var_55_11 + var_55_7
	elseif var_55_10 then
		local var_55_12 = UnitEquipUtil:getEquipUpgradeStatTable(var_55_10)
		
		if not var_55_12[var_55_5] then
			arg_55_0:sendError(arg_55_0:info("NO SUB STAT TBL IN UPGRADE OPTION"))
			
			return 
		end
		
		local var_55_13 = UnitEquipUtil:get_normalize_value(var_55_5, var_55_12[var_55_5] * var_55_0 + var_0_0, var_55_5 == "speed")
		local var_55_14 = math.max(0, var_55_13)
		
		var_55_6 = var_55_14 + var_55_6
		var_55_7 = var_55_14 + var_55_7
	end
	
	local var_55_15 = false
	
	if var_55_9 and var_55_7 <= math.max(var_55_6, var_55_8[var_55_9][2]) + var_0_0 then
		var_55_15 = true
	end
	
	arg_55_0.vars.last_range = {
		min = var_55_6,
		max = var_55_7,
		stat_type = var_55_5,
		bigger_or_same_change_value = var_55_15
	}
	
	return arg_55_0.vars.last_range
end

function UnitEquipChangeSubLogic.getOptionsInEquip(arg_56_0, arg_56_1)
	local var_56_0 = {}
	
	for iter_56_0, iter_56_1 in pairs(arg_56_0.vars.equip_detail.equip_stat) do
		if arg_56_1 and iter_56_0 ~= 1 or not arg_56_1 then
			var_56_0[iter_56_1[1]] = true
		end
	end
	
	return var_56_0
end

function UnitEquipChangeSubLogic.getUsableSubStats(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = arg_57_0.vars.equip.db.type
	local var_57_1 = DB("item_equip_substat_change_pool", var_57_0, "sub_stat_pools")
	
	if not var_57_1 then
		arg_57_0:sendError(arg_57_0:info("check_equip_type", var_57_0))
		
		return 
	end
	
	local var_57_2 = string.split(var_57_1, ";")
	local var_57_3 = {}
	local var_57_4 = arg_57_0:getOptionsInEquip()
	
	for iter_57_0, iter_57_1 in pairs(var_57_2) do
		if arg_57_1 then
			if not var_57_4[iter_57_1] or arg_57_2 == iter_57_1 then
				table.insert(var_57_3, iter_57_1)
			end
		else
			table.insert(var_57_3, iter_57_1)
		end
	end
	
	return var_57_3
end

function UnitEquipChangeSubLogic.parsingSubStatChangeMaType2(arg_58_0, arg_58_1)
	local var_58_0 = UnitEquipUtil:parsingSubStatChangeMaType2(arg_58_1)
	
	if not var_58_0 then
		arg_58_0:sendError(arg_58_0:info("check_ma_type2", arg_58_1, "failed string split"))
		
		return 
	end
	
	return var_58_0
end

function UnitEquipChangeSubLogic.getSubStatDBId(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = arg_59_2 or arg_59_0:parsingSubStatChangeMaType2(arg_59_1)
	
	if not var_59_0 then
		return 
	end
	
	return var_59_0[1]
end

function UnitEquipChangeSubLogic.getSetFx(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_2 or arg_60_0:parsingSubStatChangeMaType2(arg_60_1)
	
	if not var_60_0 then
		return 
	end
	
	return var_60_0[2]
end

function UnitEquipChangeSubLogic._forEach_CheckMaterialUsable(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0, var_61_1 = DBN("item_material", arg_61_1, {
		"ma_type",
		"ma_type2"
	})
	
	if var_61_0 ~= "change" then
		return 
	end
	
	local var_61_2 = arg_61_0:parsingSubStatChangeMaType2(var_61_1)
	
	if not var_61_2 then
		return 
	end
	
	local var_61_3 = arg_61_0:getDBIdsFromStatType(arg_61_0:getSubStatDBId(nil, var_61_2))
	
	if arg_61_0.vars.equip_detail.set_fx ~= arg_61_0:getSetFx(nil, var_61_2) then
		return 
	end
	
	if not arg_61_2[var_61_3] then
		return 
	end
	
	return true
end

function UnitEquipChangeSubLogic.getUsableSubStatChangeMaterialsId(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0:getUsableSubStats(arg_62_1, arg_62_2)
	local var_62_1 = {}
	
	for iter_62_0, iter_62_1 in pairs(var_62_0) do
		var_62_1[iter_62_1] = true
	end
	
	local var_62_2 = {}
	
	for iter_62_2 = 1, 9999 do
		local var_62_3 = DBN("item_material", iter_62_2, "id")
		
		if not var_62_3 then
			break
		end
		
		if arg_62_0:_forEach_CheckMaterialUsable(iter_62_2, var_62_1) then
			table.insert(var_62_2, var_62_3)
		end
	end
	
	return var_62_2
end

function UnitEquipChangeSubLogic.getDBIdsFromStatType(arg_63_0, arg_63_1)
	if not arg_63_0.vars._db_to_sub_stat then
		arg_63_0:_generateDBToSubStat()
	end
	
	return arg_63_0.vars._db_to_sub_stat[arg_63_1]
end

function UnitEquipChangeSubLogic._generateDBToSubStat(arg_64_0)
	arg_64_0.vars._db_to_sub_stat = {}
	
	for iter_64_0 = 1, 999 do
		local var_64_0 = DBN("item_equip_substat_change", iter_64_0, "id")
		
		if not var_64_0 then
			break
		end
		
		local var_64_1 = arg_64_0:getStatType(var_64_0)
		
		arg_64_0.vars._db_to_sub_stat[var_64_0] = var_64_1
	end
end

function UnitEquipChangeSubLogic.endLogic(arg_65_0)
	arg_65_0.vars = nil
end
