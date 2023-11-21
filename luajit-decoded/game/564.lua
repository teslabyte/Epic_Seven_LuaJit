Inventory.EquipMaterials = {}

local var_0_0 = {
	ChangeMaterials = 2,
	EquipCore = 1
}

function MsgHandler.alchemist_change_extract(arg_1_0)
	if arg_1_0.res ~= "ok" then
		return 
	end
	
	local var_1_0 = {}
	
	for iter_1_0, iter_1_1 in pairs(arg_1_0.rewards.new_items) do
		table.insert(var_1_0, {
			code = iter_1_1.code,
			count = iter_1_1.c - (Account:getItemCount(iter_1_1.code) or 0)
		})
	end
	
	local var_1_1 = Dialog:msgItems(var_1_0)
	
	if not get_cocos_refid(var_1_1) then
		return 
	end
	
	local var_1_2 = T("ui_extraction_popup_title")
	local var_1_3 = T("ui_extraction_popup_success_desc")
	
	if table.count(var_1_0) == 1 and var_1_0[1].code == "ma_change_point" then
		var_1_2 = T("ui_extraction_change_popup_title")
		var_1_3 = T("ui_extraction_change_success_desc")
	end
	
	if_set(var_1_1, "txt_title", var_1_2)
	Dialog:msgBox(var_1_3, {
		dlg = var_1_1
	})
	var_1_1:bringToFront()
	if_set_visible(var_1_1, "btn_ok", true)
	if_set_visible(var_1_1, "btn_cancel", false)
	if_set_visible(var_1_1, "btn_confirm", false)
	Account:addReward(arg_1_0.use_rewards)
	Account:addReward(arg_1_0.rewards)
	
	if Inventory.vars and Inventory.vars.wnd then
		Inventory:ResetItems(nil, false)
	end
	
	Inventory.EquipMaterials:toggleSellMode(false)
end

function Inventory.EquipMaterials.setEnableSubTab(arg_2_0, arg_2_1)
	local var_2_0 = Inventory.vars.wnd:getChildByName("n_3_menu")
	
	if not get_cocos_refid(var_2_0) then
		return 
	end
	
	if_set_visible(var_2_0, nil, arg_2_1)
	if_set_visible(var_2_0, "n_3_tab6_1", arg_2_1)
	if_set_visible(var_2_0, "n_3_tab6_2", false)
end

function Inventory.EquipMaterials.onEnter(arg_3_0)
	arg_3_0:setEnableSubTab(true)
	arg_3_0:setSubTab(var_0_0.EquipCore)
	arg_3_0:setEquipCoreDetailTab(0)
end

function Inventory.EquipMaterials.onLeave(arg_4_0)
	arg_4_0:setEnableSubTab(false)
	arg_4_0:toggleSellMode(false)
	arg_4_0:toggleSellMode(false)
end

function Inventory.EquipMaterials.setSubTab(arg_5_0, arg_5_1)
	if arg_5_0.sub_tab == arg_5_1 then
		if arg_5_0.sub_tab == var_0_0.EquipCore then
			arg_5_0:visibleExtractMaterial(false)
			arg_5_0:toggleSellMode(false)
		end
		
		return 
	end
	
	local var_5_0 = Inventory.vars.wnd:findChildByName("n_3_menu")
	
	if not get_cocos_refid(var_5_0) then
		return 
	end
	
	local var_5_1 = arg_5_0.sub_tab
	
	arg_5_0.sub_tab = arg_5_1
	
	local var_5_2 = var_5_0:findChildByName("n_3_tab6_" .. arg_5_0.sub_tab)
	
	if not get_cocos_refid(var_5_2) then
		return 
	end
	
	if_set_visible(var_5_2, nil, true)
	
	local var_5_3 = arg_5_0.sub_tab == var_0_0.ChangeMaterials
	
	if_set_visible(var_5_2, "n_filter_set", var_5_3)
	if_set_visible(var_5_2, "n_filter_stat_main", var_5_3)
	if_set_visible(var_5_2, "n_filter_grade", var_5_3)
	arg_5_0:visibleExtractMaterial(var_5_3)
	arg_5_0:toggleSellMode(false)
	
	if var_5_1 then
		if_set_visible(var_5_0, "n_3_tab6_" .. var_5_1, false)
	end
	
	Inventory:moveSubTabSelector(Inventory.vars.wnd:getChildByName("n_tab_sub" .. Inventory.vars.main_tab), arg_5_0.sub_tab)
end

function Inventory.EquipMaterials.setEquipCoreDetailTab(arg_6_0, arg_6_1)
	if not arg_6_0.sub_tab then
		return 
	end
	
	if not arg_6_1 then
		return 
	end
	
	if arg_6_0.detail_tab == arg_6_1 then
		return 
	end
	
	local var_6_0 = Inventory.vars.wnd:findChildByName("n_3_tab6_" .. arg_6_0.sub_tab)
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	arg_6_0.detail_tab = arg_6_1
	
	Inventory:moveSubTabSelector(var_6_0, arg_6_0.detail_tab)
end

function Inventory.EquipMaterials.selectSubTab(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.tab = arg_7_1
	arg_7_0.tab_name = arg_7_2
	
	if not arg_7_2 then
		return 
	end
	
	if string.find(arg_7_2, "eq_ma") then
		arg_7_0:setSubTab(arg_7_1)
		
		if arg_7_0.sub_tab == var_0_0.ChangeMaterials then
			Inventory:setFilterSetEffect()
		end
		
		return 
	end
	
	if string.find(arg_7_2, "equip") then
		local var_7_0 = arg_7_1
		
		arg_7_0:setEquipCoreDetailTab(var_7_0)
		
		return 
	end
end

function Inventory.EquipMaterials.isCorrectTab(arg_8_0, arg_8_1)
	local var_8_0 = {
		stat_change_material = 2,
		equip_source = 1
	}
	
	return arg_8_0.sub_tab == var_8_0[arg_8_1]
end

function Inventory.EquipMaterials.getCurrentCategoryName(arg_9_0)
	return ({
		"equip_source",
		"stat_change_material"
	})[arg_9_0.sub_tab]
end

function Inventory.EquipMaterials.isCorrectEquipMaterialTabEquipCoreSubTab(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.detail_tab == 0 and (arg_10_2 == "alchemypoint" or arg_10_2 == "alchemychange") then
		return true
	end
	
	if arg_10_0.detail_tab == 7 and arg_10_2 == "alchemychange" then
		return true
	end
	
	local var_10_0 = ({
		"weapon",
		"helm",
		"neck",
		"armor",
		"boot",
		"ring"
	})[arg_10_0.detail_tab]
	
	if var_10_0 and string.find(arg_10_1, var_10_0) and arg_10_2 == "alchemypoint" then
		return true
	end
end

function Inventory.EquipMaterials.selectItemsEquipCore(arg_11_0)
	local var_11_0 = {}
	local var_11_1 = {
		weapon = 1,
		armor = 2,
		boot = 6,
		ring = 5,
		helm = 3,
		neck = 4
	}
	local var_11_2 = UIUtil:getSetItemSortList()
	
	for iter_11_0, iter_11_1 in pairs(Account.items) do
		local var_11_3, var_11_4, var_11_5 = DB("item_material", iter_11_0, {
			"ma_type",
			"ma_type2",
			"grade"
		})
		
		if iter_11_1 > 0 and arg_11_0:isCorrectEquipMaterialTabEquipCoreSubTab(iter_11_0, var_11_3) then
			local var_11_6 = string.split(var_11_4, ";")
			local var_11_7 = var_11_1[var_11_6[1]] or 0
			local var_11_8 = var_11_2[var_11_6[2]] or 0
			
			table.push(var_11_0, {
				code = iter_11_0,
				count = iter_11_1,
				grade = var_11_5,
				wear_order = var_11_7,
				set_order = var_11_8
			})
		end
	end
	
	table.sort(var_11_0, function(arg_12_0, arg_12_1)
		if arg_12_0.wear_order == arg_12_1.wear_order then
			return arg_12_0.set_order > arg_12_1.set_order
		end
		
		if arg_12_0.set_order == arg_12_1.set_order then
			return arg_12_0.wear_order < arg_12_1.wear_order
		end
		
		return arg_12_0.wear_order < arg_12_1.wear_order
	end)
	
	return var_11_0
end

function Inventory.EquipMaterials.selectItemsChangeMaterials(arg_13_0)
	local var_13_0 = Inventory:getFilterSetFx()
	
	if not var_13_0 then
		return {}
	end
	
	local var_13_1 = Inventory:getFilterStat()
	
	if not var_13_1 then
		return {}
	end
	
	local var_13_2 = Inventory:getFilterGrade()
	
	if not var_13_2 then
		return {}
	end
	
	local var_13_3 = {}
	local var_13_4 = UIUtil:getSetItemSortList()
	local var_13_5 = var_13_0.Data:getUsableFilter()
	
	var_13_0:clearSetFxCount()
	
	local var_13_6 = var_13_1.Data:getUsableFilter()
	local var_13_7 = var_13_2.Data:getUsableFilter()
	local var_13_8 = UnitEquipChangeSubLogic:startLogic()
	
	for iter_13_0, iter_13_1 in pairs(Account.items) do
		local var_13_9, var_13_10, var_13_11, var_13_12 = DB("item_material", iter_13_0, {
			"ma_type",
			"ma_type2",
			"grade",
			"sort"
		})
		
		var_13_11 = var_13_11 or 0
		
		if iter_13_1 > 0 and var_13_9 == "change" then
			local var_13_13 = string.split(var_13_10, ";")
			local var_13_14 = var_13_13[2]
			local var_13_15 = var_13_4[var_13_14] or 0
			
			var_13_0:addSetFxCount(var_13_14, tonumber(iter_13_1))
			
			local var_13_16 = var_13_8:getDBIdsFromStatType(var_13_8:getSubStatDBId(nil, var_13_13))
			
			if var_13_5[var_13_14] and var_13_6[var_13_16] and (var_13_7.all or var_13_7["ext_" .. var_13_11]) then
				table.push(var_13_3, {
					code = iter_13_0,
					count = iter_13_1,
					grade = var_13_11,
					set_order = var_13_15,
					sort = var_13_12 or 0
				})
			end
		end
	end
	
	var_13_0:updateSetFxCountUI()
	table.sort(var_13_3, function(arg_14_0, arg_14_1)
		return arg_14_0.sort > arg_14_1.sort
	end)
	
	return var_13_3
end

function Inventory.EquipMaterials.selectItems(arg_15_0)
	if arg_15_0.sub_tab == var_0_0.EquipCore then
		return arg_15_0:selectItemsEquipCore()
	elseif arg_15_0.sub_tab == var_0_0.ChangeMaterials then
		return arg_15_0:selectItemsChangeMaterials()
	end
end

function Inventory.EquipMaterials.visibleExtractMaterial(arg_16_0, arg_16_1)
	local var_16_0 = Inventory.vars.wnd:getChildByName("n_tab_sell_material")
	
	if not get_cocos_refid(var_16_0) then
		return 
	end
	
	if_set_visible(var_16_0, nil, arg_16_1)
	if_set_visible(var_16_0, "btn_sell_block", false)
	if_set_visible(var_16_0, "btn_delete_after", false)
	if_set_visible(var_16_0, "btn_delete", true)
	if_set_visible(var_16_0, "btn_sell", false)
	if_set_visible(var_16_0, "n_cost", false)
end

function Inventory.EquipMaterials.toggleSellMode(arg_17_0, arg_17_1)
	local var_17_0 = Inventory.vars.wnd:getChildByName("n_tab_sell_material")
	
	if not get_cocos_refid(var_17_0) then
		return 
	end
	
	if arg_17_1 ~= nil then
		arg_17_0.sell_mode = arg_17_1
	else
		arg_17_0.sell_mode = not arg_17_0.sell_mode
	end
	
	arg_17_0.selected = {}
	
	if_set(var_17_0, "txt_sell_count", T("sell_count", {
		count = 0
	}))
	if_set_opacity(var_17_0, "btn_sell", 76.5)
	if_set_visible(var_17_0, "icon", false)
	if_set_visible(var_17_0, "txt_sell_price", false)
	if_set_visible(var_17_0, "icon2", false)
	if_set_visible(var_17_0, "btn_sell", arg_17_0.sell_mode)
	if_set_visible(var_17_0, "btn_delete", not arg_17_0.sell_mode)
	if_set_visible(var_17_0, "btn_delete_after", arg_17_0.sell_mode)
	if_set_visible(var_17_0, "n_extract_mode", arg_17_0.sell_mode)
	if_set_visible(Inventory.vars.wnd, "n_tab_sub6", not arg_17_0.sell_mode)
	
	if arg_17_0.skip_count_popup == nil then
		arg_17_0.skip_count_popup = SAVE:get("mat_skip_count_popup", false)
	end
	
	local var_17_1 = var_17_0:getChildByName("n_extract_mode")
	local var_17_2
	
	if get_cocos_refid(var_17_1) then
		local var_17_3 = var_17_1:getChildByName("check_box_1")
		local var_17_4 = var_17_3:getChildByName("check_box")
		local var_17_5 = var_17_1:getChildByName("btn_check")
		
		var_17_4:addEventListener(function()
			Inventory.EquipMaterials:toggleCountPopup()
		end)
		var_17_4:setSelected(arg_17_0.skip_count_popup)
		
		if var_17_5 and not var_17_5.init_size then
			local var_17_6 = var_17_3:getContentSize()
			
			var_17_6.width = var_17_6.width * var_17_3:getScaleX()
			var_17_6.width = var_17_6.width + 45
			
			var_17_5:setContentSize({
				height = 34,
				width = var_17_6.width
			})
			
			var_17_5.init_size = true
		end
	end
	
	arg_17_0:updateExtractInfo()
	Inventory.vars.listview:refresh()
end

function Inventory.EquipMaterials.toggleCountPopup(arg_19_0, arg_19_1)
	if not arg_19_0.sell_mode then
		return 
	end
	
	arg_19_0.skip_count_popup = not arg_19_0.skip_count_popup
	
	SAVE:set("mat_skip_count_popup", arg_19_0.skip_count_popup)
	
	if arg_19_1 then
		local var_19_0 = Inventory.vars.wnd:getChildByName("n_tab_sell_material"):getChildByName("n_extract_mode")
		local var_19_1
		
		if get_cocos_refid(var_19_0) then
			var_19_0:getChildByName("check_box_1"):getChildByName("check_box"):setSelected(arg_19_0.skip_count_popup)
		end
	end
end

function Inventory.EquipMaterials.updateExtractInfo(arg_20_0)
	local var_20_0 = Inventory.vars.wnd:getChildByName("n_tab_sell_material")
	
	if not get_cocos_refid(var_20_0) then
		return 
	end
	
	arg_20_0.total_count = 0
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.selected or {}) do
		arg_20_0.total_count = arg_20_0.total_count + iter_20_1.count
	end
	
	local var_20_1 = arg_20_0.total_count ~= 0
	
	if_set_opacity(var_20_0, "btn_sell", var_20_1 and 255 or 76.5)
	if_set(var_20_0, "txt_sell_count", T("ui_extraction_btn_inventory"))
	if_set(var_20_0, "t_count", T("ui_extraction_select_inventory", {
		count = comma_value(arg_20_0.total_count)
	}))
	if_set_visible(var_20_0, "t_count", arg_20_0.sell_mode)
end

function Inventory.EquipMaterials.selectAll(arg_21_0)
	if not arg_21_0.sell_mode then
		return 
	end
	
	arg_21_0.selected = {}
	
	local var_21_0 = arg_21_0:selectItemsChangeMaterials()
	local var_21_1 = 0
	local var_21_2 = 100
	
	if var_21_0 and not table.empty(var_21_0) then
		for iter_21_0, iter_21_1 in pairs(var_21_0) do
			arg_21_0.selected[iter_21_1.code] = {
				code = iter_21_1.code,
				count = iter_21_1.count
			}
			var_21_1 = var_21_1 + 1
			
			if var_21_2 <= var_21_1 then
				balloon_message_with_sound("ui_change_alert_select", {
					count = var_21_2
				})
				
				break
			end
		end
	end
	
	Inventory.vars.listview:refresh()
	arg_21_0:updateExtractInfo()
end

function Inventory.EquipMaterials.onSelect(arg_22_0, arg_22_1)
	if not arg_22_0.sell_mode then
		return 
	end
	
	if not arg_22_1.code then
		return 
	end
	
	if arg_22_0.selected[arg_22_1.code] then
		arg_22_0.selected[arg_22_1.code] = nil
		
		Inventory.vars.listview:refresh()
		arg_22_0:updateExtractInfo()
		
		return 
	end
	
	local var_22_0 = 100
	
	if var_22_0 <= table.count(arg_22_0.selected) then
		balloon_message_with_sound("ui_change_alert_select", {
			count = var_22_0
		})
		
		return 
	end
	
	if arg_22_1.count == 1 then
		arg_22_0.selected[arg_22_1.code] = {
			count = 1,
			code = arg_22_1.code
		}
		
		Inventory.vars.listview:refresh()
		arg_22_0:updateExtractInfo()
		
		return 
	end
	
	if arg_22_0.skip_count_popup then
		arg_22_0.selected[arg_22_1.code] = {
			code = arg_22_1.code,
			count = arg_22_1.count
		}
		
		Inventory.vars.listview:refresh()
		arg_22_0:updateExtractInfo()
		
		return 
	end
	
	local var_22_1 = T("ui_item_select_slidebar_popup_inti_title")
	local var_22_2 = T("ui_item_select_slidebar_extraction")
	
	arg_22_0.count_popup = Dialog:openCountPopup({
		wnd = Inventory.vars.wnd,
		t_title = var_22_1,
		t_disc = var_22_2,
		max_count = arg_22_1.count,
		back_func = function()
			if not get_cocos_refid(arg_22_0.count_popup) then
				return 
			end
			
			BackButtonManager:pop({
				check_id = "item_select_slidebar_popup",
				dlg = arg_22_0.count_popup
			})
			arg_22_0.count_popup:removeFromParent()
		end,
		slider_func = function()
			if not get_cocos_refid(arg_22_0.count_popup) then
				return 
			end
			
			local var_24_0 = arg_22_0.count_popup:getChildByName("slider")
			
			if_set(arg_22_0.count_popup, "t_count", var_24_0:getPercent() .. "/" .. arg_22_1.count)
		end,
		button_func = function()
			if not get_cocos_refid(arg_22_0.count_popup) then
				return 
			end
			
			local var_25_0 = arg_22_0.count_popup:getChildByName("slider")
			
			arg_22_0.selected[arg_22_1.code] = {
				code = arg_22_1.code,
				count = var_25_0:getPercent()
			}
			
			BackButtonManager:pop({
				check_id = "item_select_slidebar_popup",
				dlg = arg_22_0.count_popup
			})
			arg_22_0.count_popup:removeFromParent()
			Inventory.vars.listview:refresh()
			arg_22_0:updateExtractInfo()
		end
	})
end

function Inventory.EquipMaterials.extract(arg_26_0)
	local var_26_0 = Dialog:msgItems(arg_26_0.selected)
	
	if not get_cocos_refid(var_26_0) then
		return 
	end
	
	if_set(var_26_0, "txt_title", T("ui_extraction_change_popup_title"))
	Dialog:msgBox(T("ui_extraction_change_popup_desc"), {
		yesno = true,
		dlg = var_26_0,
		handler = function()
			local var_27_0 = {}
			
			for iter_27_0, iter_27_1 in pairs(arg_26_0.selected) do
				var_27_0[iter_27_1.code] = iter_27_1.count
			end
			
			query("alchemist_change_extract", {
				item_changes = json.encode(var_27_0)
			})
		end
	})
	
	local var_26_1 = var_26_0:getChildByName("btn_confirm")
	
	if_set(var_26_1, "label", T("ui_extraction_popup_btn"))
	var_26_0:bringToFront()
end
