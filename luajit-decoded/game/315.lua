function MsgHandler.select_gacha_customgroup_list(arg_1_0)
	GachaCustomGroupSelector:show(arg_1_0)
end

function MsgHandler.select_gacha_customgroup(arg_2_0)
	if arg_2_0.select_list then
		GachaCustomGroupSelector:updateSelectedList(arg_2_0.select_list)
		GachaCustomGroupSelector:close()
	end
	
	if arg_2_0.shop_list_powder and AccountData.shop and AccountData.shop.powder then
		AccountData.shop.powder = arg_2_0.shop_list_powder
	end
end

GachaCustomGroupSelector = {}

function HANDLER.choose_gacha(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" or arg_3_1 == "btn_cancel" then
		GachaCustomGroupSelector:close()
	elseif arg_3_1 == "btn_select_list" then
		GachaCustomGroupSelector:selectWithUpdateLeftInfo(arg_3_0)
	elseif arg_3_1 == "btn_select" then
		GachaCustomGroupSelector:insertSelected()
	elseif arg_3_1 == "btn_delete" then
		GachaCustomGroupSelector:deleteSelected()
	elseif arg_3_1 == "btn_toggle" or arg_3_1 == "btn_toggle_close" or arg_3_1 == "btn_toggle_active" then
		GachaCustomGroupSelector:toggleFilter()
	elseif arg_3_1 == "btn_checkbox_g" then
		GachaCustomGroupSelector:toggletHaveFilter()
	elseif string.starts(arg_3_1, "btn_checkbox_") then
		GachaCustomGroupSelector:selectFilter(arg_3_1)
	elseif arg_3_1 == "btn_check1" then
		GachaCustomGroupSelector:selectSubFilter(1)
	elseif arg_3_1 == "btn_check2" then
		GachaCustomGroupSelector:selectSubFilter(2)
	elseif string.starts(arg_3_1, "btn_hero_") then
		GachaCustomGroupSelector:selectArtifactMode(false)
	elseif string.starts(arg_3_1, "btn_arti_") then
		GachaCustomGroupSelector:selectArtifactMode(true)
	elseif arg_3_1 == "btn_select_hero" then
		GachaCustomGroupSelector:deleteSelectedByCode(arg_3_0.select_id)
	elseif arg_3_1 == "btn_choice_complete" then
		GachaCustomGroupSelector:confirmSelected()
	elseif arg_3_1 == "btn_info" then
		GachaCustomGroupSelector:popupInfo()
	elseif arg_3_1 == "btn_not_sleect" then
		GachaCustomGroupSelector:notSelectButton()
	end
end

function GachaCustomGroupSelector.popupInfo(arg_4_0)
	local var_4_0 = load_dlg("shop_buy_detail", true, "wnd")
	
	if_set(var_4_0, "txt_title", T("gacha_customgroup_popup_title"))
	UIUtil:setScrollViewText(var_4_0:getChildByName("scrollview"), T("gacha_customgroup_popup_info"))
	Dialog:msgBox("", {
		dlg = var_4_0
	})
end

function GachaCustomGroupSelector.show(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.artifact_mode = false
	arg_5_0.vars.stored_codes = GachaUnit:getCustomData("gacha_stored_codes")
	
	if arg_5_1 then
		GachaUnit:setCustomData("gacha_stored_codes", arg_5_1.stored_codes)
		
		arg_5_0.vars.stored_codes = arg_5_1.stored_codes
	elseif not arg_5_0.vars.stored_codes then
		query("select_gacha_customgroup_list")
		
		return 
	end
	
	arg_5_0:popupCustomGacha()
end

function GachaCustomGroupSelector.setupFilter(arg_6_0)
	local var_6_0 = arg_6_0.vars.dlg:getChildByName("cm_box")
	
	if arg_6_0.vars.artifact_mode then
		arg_6_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
		arg_6_0.vars.filter_un_hash_tbl.element = nil
		arg_6_0.vars.filter_un_hash_tbl.star = nil
		arg_6_0.vars.filter_un_hash_tbl.role[7] = "no_role"
		
		if_set_visible(var_6_0, "n_toggle", false)
		
		local var_6_1 = var_6_0:getChildByName("n_toggle")
		
		if_set_visible(var_6_1, "n_sort", false)
		if_set_visible(var_6_1, "n_sort_arti", true)
		if_set_visible(var_6_0, "btn_toggle_active", false)
		if_set_visible(var_6_0, "btn_toggle", true)
	else
		arg_6_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
		arg_6_0.vars.filter_un_hash_tbl.star = nil
		arg_6_0.vars.filter_un_hash_tbl.role[7] = nil
		
		if_set_visible(var_6_0, "n_toggle", false)
		
		local var_6_2 = var_6_0:getChildByName("n_toggle")
		
		if_set_visible(var_6_2, "n_sort", true)
		if_set_visible(var_6_2, "n_sort_arti", false)
		if_set_visible(var_6_0, "btn_toggle_active", false)
		if_set_visible(var_6_0, "btn_toggle", true)
	end
	
	arg_6_0:selectSubFilter(nil, true)
	
	local var_6_3 = var_6_0:getChildByName("n_check_box"):getChildByName("checkbox_g")
	
	if get_cocos_refid(var_6_3) then
		var_6_3:setSelected(false)
	end
end

function GachaCustomGroupSelector.selectArtifactMode(arg_7_0, arg_7_1)
	arg_7_0.vars.artifact_mode = arg_7_1
	arg_7_0.vars.filter_role = nil
	arg_7_0.vars.filter_element = nil
	arg_7_0.vars.filter_limit = nil
	arg_7_0.vars.filter_not_have = false
	
	local var_7_0 = arg_7_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_top")
	local var_7_1 = var_7_0:getChildByName("txt_title")
	
	if get_cocos_refid(var_7_1) then
		if_set(var_7_0, "txt_title", T("customgroup_select_popup_title"))
		
		local var_7_2 = var_7_1:getContentSize().width
		local var_7_3 = var_7_0:getChildByName("btn_info")
		
		if get_cocos_refid(var_7_3) then
			var_7_3:setPositionX(var_7_1:getPositionX() + var_7_2 * var_7_1:getScaleX() + 5)
		end
	end
	
	if arg_7_0.vars.artifact_mode then
		if_set_visible(var_7_0, "btn_arti_on", true)
		if_set_visible(var_7_0, "btn_arti_off", false)
		if_set_visible(var_7_0, "btn_hero_on", false)
		if_set_visible(var_7_0, "btn_hero_off", true)
	else
		if_set_visible(var_7_0, "btn_arti_on", false)
		if_set_visible(var_7_0, "btn_arti_off", true)
		if_set_visible(var_7_0, "btn_hero_on", true)
		if_set_visible(var_7_0, "btn_hero_off", false)
	end
	
	arg_7_0:setupFilter()
	arg_7_0:refresh()
	arg_7_0:updateSelectButton()
end

function GachaCustomGroupSelector.toggleFilter(arg_8_0)
	local var_8_0 = arg_8_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_toggle")
	
	if var_8_0:isVisible() then
		BackButtonManager:pop()
		if_set_visible(var_8_0, nil, false)
		
		return 
	end
	
	BackButtonManager:push({
		check_id = "GachaCustomGroupSelector.toggleFilter",
		back_func = function()
			arg_8_0:toggleFilter()
		end
	})
	if_set_visible(var_8_0, nil, true)
	
	if arg_8_0.vars.artifact_mode then
		n_sort = var_8_0:getChildByName("n_sort_arti")
	else
		n_sort = var_8_0:getChildByName("n_sort")
	end
	
	if not arg_8_0.vars.filter_role then
		arg_8_0.vars.filter_role = {
			"all"
		}
		
		arg_8_0:selectFilter("btn_checkbox_role_all", true)
	end
	
	if not arg_8_0.vars.filter_element then
		arg_8_0.vars.filter_element = {
			"all"
		}
		
		arg_8_0:selectFilter("btn_checkbox_element_all", true)
	end
end

function GachaCustomGroupSelector.selectFilter(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.vars.filter_un_hash_tbl then
		return 
	end
	
	local var_10_0 = string.split(arg_10_1, "btn_checkbox_")
	
	if not var_10_0 or not var_10_0[2] then
		return 
	end
	
	local var_10_1 = string.split(var_10_0[2], "_")
	
	if not var_10_1[1] or not var_10_1[2] then
		return 
	end
	
	local var_10_2 = tostring(var_10_1[1])
	local var_10_3 = tostring(var_10_1[2])
	local var_10_4 = arg_10_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_toggle")
	local var_10_5
	
	if arg_10_0.vars.artifact_mode then
		var_10_5 = var_10_4:getChildByName("n_sort_arti")
	else
		var_10_5 = var_10_4:getChildByName("n_sort")
	end
	
	local var_10_6 = var_10_5:getChildByName("n_" .. var_10_2)
	
	if not get_cocos_refid(var_10_6) then
		return 
	end
	
	arg_10_0.vars["filter_" .. var_10_2] = {}
	
	local var_10_7 = arg_10_0.vars.filter_un_hash_tbl[var_10_2]
	local var_10_8 = false
	
	if var_10_3 == "all" then
		var_10_8 = var_10_6:getChildByName("n_check_box_all"):getChildByName("checkbox_" .. var_10_2 .. "_all"):isSelected()
		
		if arg_10_2 then
			var_10_8 = false
		end
	end
	
	local var_10_9 = 0
	
	for iter_10_0, iter_10_1 in pairs(var_10_7) do
		iter_10_0 = tostring(iter_10_0)
		
		local var_10_10 = var_10_6:getChildByName("n_check_box_" .. iter_10_0)
		local var_10_11 = var_10_10:getChildByName("checkbox_" .. var_10_2 .. "_" .. iter_10_0)
		local var_10_12 = var_10_10:getChildByName("select_bg_" .. var_10_2 .. "_" .. iter_10_0)
		
		if var_10_3 == "all" then
			if iter_10_0 == "all" then
				var_10_11:setSelected(not var_10_8)
				var_10_12:setVisible(not var_10_8)
			else
				var_10_11:setSelected(var_10_8)
				var_10_12:setVisible(var_10_8)
			end
		else
			if iter_10_0 == "all" then
				var_10_11:setSelected(false)
				var_10_12:setVisible(false)
			end
			
			if iter_10_0 == var_10_3 then
				local var_10_13 = var_10_11:isSelected()
				
				var_10_11:setSelected(not var_10_13)
				var_10_12:setVisible(not var_10_13)
			end
		end
		
		if var_10_11:isSelected() then
			var_10_9 = var_10_9 + 1
			
			table.push(arg_10_0.vars["filter_" .. var_10_2], iter_10_1)
		end
	end
	
	if var_10_9 == 0 then
		arg_10_0:selectFilter("btn_checkbox_" .. var_10_2 .. "_all", true)
	else
		arg_10_0:refresh()
	end
	
	arg_10_0:updateToggleButton()
	arg_10_0:updateSelectButton()
end

function GachaCustomGroupSelector.selectSubFilter(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_toggle")
	
	if arg_11_1 == 1 then
		if arg_11_0.vars.filter_limit == "limit" then
			arg_11_0.vars.filter_limit = nil
			arg_11_1 = nil
		else
			arg_11_0.vars.filter_limit = "limit"
		end
	elseif arg_11_1 == 2 then
		if arg_11_0.vars.filter_limit == "general" then
			arg_11_0.vars.filter_limit = nil
			arg_11_1 = nil
		else
			arg_11_0.vars.filter_limit = "general"
		end
	end
	
	local var_11_1
	
	if arg_11_0.vars.artifact_mode then
		var_11_1 = var_11_0:getChildByName("n_sort_arti")
	else
		var_11_1 = var_11_0:getChildByName("n_sort")
	end
	
	for iter_11_0 = 1, 2 do
		var_11_1:getChildByName("btn_check" .. iter_11_0):getChildByName("checkbox" .. iter_11_0):setSelected(iter_11_0 == arg_11_1)
	end
	
	if not arg_11_2 then
		arg_11_0:refresh()
	end
	
	arg_11_0:updateToggleButton()
end

function GachaCustomGroupSelector.toggletHaveFilter(arg_12_0)
	arg_12_0.vars.filter_not_have = not arg_12_0.vars.filter_not_have
	
	local var_12_0 = arg_12_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_check_box"):getChildByName("checkbox_g")
	
	if get_cocos_refid(var_12_0) then
		var_12_0:setSelected(arg_12_0.vars.filter_not_have)
	end
	
	arg_12_0:refresh()
end

function GachaCustomGroupSelector.isHaveSameCodeUnit(arg_13_0, arg_13_1)
	local var_13_0 = false
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.stored_codes or {}) do
		if iter_13_1 == arg_13_1 then
			var_13_0 = true
			
			break
		end
	end
	
	local var_13_1 = false
	
	for iter_13_2, iter_13_3 in pairs(AccountData.gacha_temp_inventory) do
		if iter_13_2 == arg_13_1 and to_n(iter_13_3) > 0 then
			var_13_1 = true
			
			break
		end
	end
	
	return var_13_0 or var_13_1 or Account:isHaveSameCodeUnit(arg_13_1) or Account:isHaveSameCodeArtifact(arg_13_1)
end

function GachaCustomGroupSelector.filterData(arg_14_0, arg_14_1)
	local var_14_0
	
	if arg_14_0.vars.artifact_mode then
		var_14_0 = arg_14_1.pid
	else
		var_14_0 = arg_14_1.id
	end
	
	if not var_14_0 then
		return false
	end
	
	local var_14_1 = arg_14_0.vars.filter_role or {
		"all"
	}
	local var_14_2 = arg_14_0.vars.filter_element or {
		"all"
	}
	local var_14_3 = arg_14_0.vars.filter_limit
	
	if string.starts(var_14_0, "c") then
		local var_14_4, var_14_5, var_14_6 = DB("character", var_14_0, {
			"name",
			"role",
			"ch_attribute"
		})
		
		if not var_14_4 then
			return false
		end
		
		local var_14_7 = 0
		
		for iter_14_0, iter_14_1 in pairs(var_14_1) do
			if iter_14_1 == "all" or iter_14_1 == var_14_5 then
				var_14_7 = var_14_7 + 1
			end
		end
		
		for iter_14_2, iter_14_3 in pairs(var_14_2) do
			if iter_14_3 == "all" or iter_14_3 == var_14_6 then
				var_14_7 = var_14_7 + 1
			end
		end
		
		if not var_14_3 then
			var_14_7 = var_14_7 + 1
		else
			local var_14_8 = arg_14_0.vars.list[var_14_0]
			
			if var_14_8 then
				if var_14_3 == "limit" and var_14_8.limit == "y" then
					var_14_7 = var_14_7 + 1
				elseif var_14_3 == "general" and var_14_8.limit ~= "y" then
					var_14_7 = var_14_7 + 1
				end
			end
		end
		
		if not arg_14_0.vars.filter_not_have then
			var_14_7 = var_14_7 + 1
		elseif arg_14_0.vars.filter_not_have and not arg_14_0:isHaveSameCodeUnit(var_14_0) then
			var_14_7 = var_14_7 + 1
		end
		
		return var_14_7 == 4
	elseif string.starts(var_14_0, "e") then
		local var_14_9, var_14_10 = DB("equip_item", var_14_0, {
			"name",
			"role"
		})
		
		if not var_14_9 then
			return false
		end
		
		local var_14_11 = 0
		
		for iter_14_4, iter_14_5 in pairs(var_14_1) do
			if iter_14_5 == "all" or iter_14_5 == var_14_10 or iter_14_5 == nil and var_14_10 == "no_role" then
				var_14_11 = var_14_11 + 1
			end
		end
		
		if not var_14_3 then
			var_14_11 = var_14_11 + 1
		else
			local var_14_12 = arg_14_0.vars.list_by_arti[var_14_0]
			
			if var_14_12 then
				if var_14_3 == "limit" and var_14_12.limit == "y" then
					var_14_11 = var_14_11 + 1
				elseif var_14_3 == "general" and var_14_12.limit ~= "y" then
					var_14_11 = var_14_11 + 1
				end
			end
		end
		
		if not arg_14_0.vars.filter_not_have then
			var_14_11 = var_14_11 + 1
		elseif arg_14_0.vars.filter_not_have and not arg_14_0:isHaveSameCodeUnit(var_14_0) then
			var_14_11 = var_14_11 + 1
		end
		
		return var_14_11 == 3
	end
	
	return false
end

function GachaCustomGroupSelector.updateToggleButton(arg_15_0)
	local var_15_0 = arg_15_0:getFilterActive()
	local var_15_1 = arg_15_0.vars.dlg:getChildByName("cm_box")
	
	if_set_visible(var_15_1, "btn_toggle", not var_15_0)
	if_set_visible(var_15_1, "btn_toggle_active", var_15_0)
end

function GachaCustomGroupSelector.getFilterActive(arg_16_0)
	local var_16_0 = arg_16_0.vars.filter_role or {
		"all"
	}
	local var_16_1 = arg_16_0.vars.filter_element or {
		"all"
	}
	
	if arg_16_0.vars.filter_limit then
		return true
	end
	
	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if iter_16_1 ~= "all" then
			return true
		end
	end
	
	for iter_16_2, iter_16_3 in pairs(var_16_1) do
		if iter_16_3 ~= "all" then
			return true
		end
	end
	
	return false
end

function GachaCustomGroupSelector.popupCustomGacha(arg_17_0)
	local var_17_0 = load_dlg("choose_gacha", true, "wnd")
	
	arg_17_0.vars.dlg = var_17_0
	arg_17_0.vars.filter_not_have = false
	
	local var_17_1 = Account:getGachaShopInfo().gacha_customgroup
	
	arg_17_0.vars.selected_list = {}
	
	for iter_17_0, iter_17_1 in pairs(var_17_1.select_list or {}) do
		table.push(arg_17_0.vars.selected_list, iter_17_1)
	end
	
	local var_17_2 = arg_17_0.vars.dlg:getChildByName("cm_box")
	local var_17_3 = var_17_2:getChildByName("n_top")
	local var_17_4 = var_17_2:getChildByName("n_bottom")
	
	if not arg_17_0:update() then
		return 
	end
	
	arg_17_0:updateSelected()
	SceneManager:getRunningPopupScene():addChild(var_17_0)
	BackButtonManager:push({
		check_id = "GachaCustomGroupSelector",
		back_func = function()
			arg_17_0:close()
		end
	})
end

function GachaCustomGroupSelector.isSelectedUnit(arg_19_0, arg_19_1)
	arg_19_1 = arg_19_1 or arg_19_0.vars.select_id
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.selected_list) do
		if iter_19_1 == arg_19_1 then
			return true
		end
	end
	
	return false
end

function GachaCustomGroupSelector.update(arg_20_0)
	local var_20_0 = arg_20_0.vars.dlg:getChildByName("cm_box"):getChildByName("card_listview")
	local var_20_1 = ItemListView_v2:bindControl(var_20_0)
	
	arg_20_0.vars.itemview = var_20_1
	
	local var_20_2 = load_control("wnd/choose_gacha_card.csb")
	
	if var_20_0.STRETCH_INFO then
		local var_20_3 = var_20_0:getContentSize()
		
		resetControlPosAndSize(var_20_2, var_20_3.width, var_20_0.STRETCH_INFO.width_prev)
	end
	
	local var_20_4 = {
		onUpdate = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			local var_21_0
			
			if arg_20_0.vars.artifact_mode then
				if_set_visible(arg_21_1, "n_hero", false)
				
				var_21_0 = arg_21_1:getChildByName("n_arti")
				
				var_21_0:setVisible(true)
			else
				if_set_visible(arg_21_1, "n_arti", false)
				
				var_21_0 = arg_21_1:getChildByName("n_hero")
				
				var_21_0:setVisible(true)
			end
			
			if_set_visible(arg_21_1, "bedge_limited", arg_21_3.limit == "y")
			if_set_visible(arg_21_1, "n_selected", false)
			if_set_color(arg_21_1, "n_hero", tocolor("#FFFFFF"))
			if_set_color(arg_21_1, "n_arti", tocolor("#FFFFFF"))
			if_set_color(arg_21_1, "bedge_limited", tocolor("#FFFFFF"))
			
			for iter_21_0 = 1, 3 do
				local var_21_1 = arg_20_0.vars.selected_list[iter_21_0]
				
				if var_21_1 and arg_21_3.id == var_21_1 then
					if_set_visible(arg_21_1, "n_selected", true)
					if_set_color(arg_21_1, "n_hero", tocolor("#505050"))
					if_set_color(arg_21_1, "n_arti", tocolor("#505050"))
					if_set_color(arg_21_1, "bedge_limited", tocolor("#505050"))
					
					break
				end
			end
			
			arg_21_1.select_id = arg_21_3.id
			
			UIUtil:getRewardIcon("c", arg_21_3.id, {
				no_popup = true,
				name = false,
				show_color = true,
				role = true,
				no_tooltip = true,
				scale = 1,
				parent = var_21_0:getChildByName("n_face")
			})
			UIUtil:getRewardIcon(nil, arg_21_3.pid, {
				no_popup = true,
				name = false,
				show_color = true,
				role = true,
				no_tooltip = true,
				scale = 1,
				parent = var_21_0:getChildByName("n_item_art_icon")
			})
			
			local var_21_2 = arg_21_1:getChildByName("btn_select_list")
			
			var_21_2.select_id = arg_21_3.id
			
			if arg_20_0.vars.select_id == arg_21_3.id then
				arg_20_0:select(var_21_2)
			end
		end
	}
	
	var_20_1:setRenderer(var_20_2, var_20_4)
	arg_20_0:selectArtifactMode(false)
	
	return true
end

function GachaCustomGroupSelector.refresh(arg_22_0)
	if not get_cocos_refid(arg_22_0.vars.itemview) then
		return 
	end
	
	arg_22_0.vars.itemview:removeAllChildren()
	
	arg_22_0.vars.last_parent_node = nil
	
	UIAction:Add(SEQ(DELAY(300)), arg_22_0, "block")
	
	arg_22_0.vars.list = {}
	arg_22_0.vars.list_by_arti = {}
	
	local var_22_0 = {}
	local var_22_1 = Account:getGachaShopInfo().gacha_customgroup
	
	for iter_22_0, iter_22_1 in pairs(var_22_1.raw_list) do
		arg_22_0.vars.list[iter_22_1.id] = iter_22_1
		
		if iter_22_1.pid then
			arg_22_0.vars.list_by_arti[iter_22_1.pid] = iter_22_1
		end
		
		if arg_22_0:filterData(iter_22_1) then
			table.push(var_22_0, iter_22_1)
		end
	end
	
	if var_22_0[1] then
		arg_22_0.vars.select_id = var_22_0[1].id
	else
		arg_22_0.vars.select_id = nil
	end
	
	arg_22_0.vars.itemview:setDataSource(var_22_0)
	
	local var_22_2 = arg_22_0.vars.dlg:getChildByName("cm_box")
	
	if_set_visible(var_22_2, "n_no_data", #var_22_0 == 0)
	
	if #var_22_0 == 0 then
		local var_22_3 = var_22_2:getChildByName("n_no_data")
		
		if arg_22_0.vars.artifact_mode then
			if_set(var_22_3, "label", T("ui_popup_artifact_select_none_filtered"))
		else
			if_set(var_22_3, "label", T("ui_popup_hero_select_none_filtered"))
		end
	end
	
	arg_22_0:updateLeftInfo()
end

function GachaCustomGroupSelector.updateLeftInfo(arg_23_0)
	if not arg_23_0.vars.select_id then
		arg_23_0:updateSelectButton()
		
		return 
	end
	
	if arg_23_0.vars.select_id then
		if arg_23_0.vars.last_selected_id == arg_23_0.vars.select_id then
			return 
		end
		
		arg_23_0.vars.last_selected_id = arg_23_0.vars.select_id
	end
	
	local var_23_0 = arg_23_0.vars.dlg:getChildByName("n_detail")
	
	if not get_cocos_refid(var_23_0) then
		return 
	end
	
	var_23_0:removeAllChildren()
	
	local var_23_1 = load_control("wnd/choose_gacha_info_hero.csb")
	
	var_23_0:addChild(var_23_1)
	var_23_1:getChildByName("n_star_base"):setPositionX(0)
	
	local var_23_2, var_23_3 = DB("character", arg_23_0.vars.select_id, {
		"grade",
		"face_id"
	})
	local var_23_4 = UIUtil:getPortraitAni(var_23_3, {
		pin_sprite_position_y = true
	})
	
	arg_23_0.vars.unit_detail = UIUtil:getGachaCharacterPopup({
		review_preview = true,
		not_my_unit = true,
		hide_level = true,
		dlg = var_23_1,
		code = arg_23_0.vars.select_id,
		grade = var_23_2,
		custom_portrait = var_23_4
	})
	
	local var_23_5 = var_23_1:getChildByName("n_dedi")
	
	if_set_visible(var_23_5, "t_locked", false)
	if_set_visible(var_23_5, "icon_lock", false)
	
	local var_23_6 = var_23_1:getChildByName("n_arti_info")
	local var_23_7 = arg_23_0.vars.list[arg_23_0.vars.select_id]
	
	if_set_visible(var_23_6, "txt_type", true)
	if_set_visible(var_23_6, "txt_name_arti", true)
	
	local var_23_8 = DB("equip_item", var_23_7.pid, {
		"artifact_grade"
	})
	local var_23_9 = var_23_6:getChildByName("item_art_icon")
	
	UIUtil:getRewardIcon(nil, var_23_7.pid, {
		show_color = true,
		no_tooltip = true,
		show_name = true,
		role = true,
		no_popup = true,
		scale = 1,
		parent = var_23_9,
		txt_name = var_23_6:getChildByName("txt_name_arti"),
		txt_type = var_23_6:getChildByName("txt_type"),
		grade = var_23_8
	})
	
	local var_23_10 = EQUIP:createByInfo({
		code = var_23_7.pid
	})
	
	WidgetUtils:setupPopup({
		control = var_23_6:getChildByName("btn_art_info"),
		creator = function()
			return ItemTooltip:getItemTooltip({
				show_max_check_box = true,
				artifact_popup = true,
				code = var_23_7.pid,
				grade = var_23_8,
				equip = var_23_10,
				equip_stat = var_23_10.stats
			})
		end
	})
	arg_23_0:updateSelectButton()
	arg_23_0:updateRecommendTag()
end

function GachaCustomGroupSelector.updateSelectButton(arg_25_0)
	local var_25_0 = arg_25_0.vars.dlg:getChildByName("cm_box")
	
	if_set_visible(var_25_0, "n_not_sleect", false)
	
	if arg_25_0:isSelectedUnit() then
		if_set_visible(var_25_0, "n_not_sleect", false)
		if_set_visible(var_25_0, "btn_select", false)
		if_set_visible(var_25_0, "btn_delete", true)
	else
		if not arg_25_0.vars.select_id or arg_25_0.vars.selected_list and #arg_25_0.vars.selected_list >= 3 then
			if_set_visible(var_25_0, "n_not_sleect", true)
			
			if arg_25_0:isSelectedUnit(arg_25_0.vars.last_selected_id) then
				if_set(var_25_0:getChildByName("n_not_sleect"), "label_not_select", T("ui_customgroup_cancel_btn"))
			else
				if_set(var_25_0:getChildByName("n_not_sleect"), "label_not_select", T("ui_customgroup_select_btn"))
			end
			
			if_set_visible(var_25_0, "btn_select", false)
		else
			if_set_visible(var_25_0, "btn_select", true)
		end
		
		if_set_visible(var_25_0, "btn_delete", false)
	end
end

function GachaCustomGroupSelector.updateRecommendTag(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.dlg) then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.dlg:getChildByName("n_hero_tag")
	
	if get_cocos_refid(var_26_0) then
		if arg_26_0.vars.select_id then
			HeroRecommend:setRecommendTag(arg_26_0.vars.select_id, var_26_0)
		else
			var_26_0:setVisible(false)
		end
	end
end

function GachaCustomGroupSelector.notSelectButton(arg_27_0)
	if not arg_27_0.vars.select_id or arg_27_0.vars.last_selected_id and arg_27_0:isSelectedUnit(arg_27_0.vars.last_selected_id) then
		balloon_message_with_sound("gacha_customgroup_select_err_filter_msg")
	else
		balloon_message_with_sound("gacha_customgroup_select_err_msg")
	end
end

function GachaCustomGroupSelector.insertSelected(arg_28_0)
	if not arg_28_0.vars.select_id then
		balloon_message_with_sound("gacha_customgroup_select_err_filter_msg")
		
		return 
	end
	
	if arg_28_0:isSelectedUnit() == true then
		return 
	end
	
	if #arg_28_0.vars.selected_list >= 3 then
		balloon_message_with_sound("gacha_customgroup_select_err_msg")
		
		return 
	end
	
	table.push(arg_28_0.vars.selected_list, arg_28_0.vars.select_id)
	arg_28_0:updateSelected()
	arg_28_0:updateSelectButton()
end

function GachaCustomGroupSelector.deleteSelected(arg_29_0)
	if not arg_29_0.vars.select_id then
		balloon_message_with_sound("gacha_customgroup_select_err_filter_msg")
		
		return 
	end
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.selected_list) do
		if iter_29_1 == arg_29_0.vars.select_id then
			table.remove(arg_29_0.vars.selected_list, iter_29_0)
			
			break
		end
	end
	
	arg_29_0:updateSelected()
	arg_29_0:updateSelectButton()
end

function GachaCustomGroupSelector.deleteSelectedByCode(arg_30_0, arg_30_1)
	local var_30_0 = false
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.selected_list) do
		if iter_30_1 == arg_30_1 then
			table.remove(arg_30_0.vars.selected_list, iter_30_0)
			
			var_30_0 = true
			
			break
		end
	end
	
	if var_30_0 then
		arg_30_0:updateSelected()
		arg_30_0:updateSelectButton()
	end
end

function GachaCustomGroupSelector.updateSelected(arg_31_0)
	local var_31_0 = arg_31_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_bottom")
	local var_31_1 = var_31_0:getChildByName("n_selected")
	
	for iter_31_0 = 1, 3 do
		local var_31_2 = var_31_1:getChildByName("n_slected_0" .. iter_31_0)
		local var_31_3 = var_31_2:getChildByName("n_face")
		local var_31_4 = var_31_2:getChildByName("n_item_art_icon")
		
		if_set_visible(var_31_2, "bedge_limited", false)
		var_31_3:removeAllChildren()
		var_31_4:removeAllChildren()
	end
	
	if_set(var_31_1, "t_selected_count", T("customgroup_selectlist_count", {
		max = 3,
		count = #arg_31_0.vars.selected_list
	}))
	
	if #arg_31_0.vars.selected_list >= 3 then
		if_set_visible(var_31_0, "n_info", false)
		if_set_visible(var_31_0, "btn_choice_complete", true)
	else
		if_set_visible(var_31_0, "n_info", true)
		if_set_visible(var_31_0, "btn_choice_complete", false)
	end
	
	for iter_31_1 = 1, 3 do
		local var_31_5 = var_31_1:getChildByName("n_slected_0" .. iter_31_1)
		local var_31_6 = var_31_5:getChildByName("n_face")
		local var_31_7 = var_31_5:getChildByName("n_item_art_icon")
		local var_31_8 = arg_31_0.vars.selected_list[iter_31_1]
		
		if var_31_8 then
			local var_31_9 = arg_31_0.vars.list[var_31_8]
			
			if var_31_9 then
				var_31_5:setVisible(true)
				if_set_visible(var_31_5, "bedge_limited", var_31_9.limit == "y")
				UIUtil:getRewardIcon("c", var_31_9.id, {
					no_popup = true,
					name = false,
					show_color = true,
					role = true,
					no_tooltip = true,
					scale = 1,
					parent = var_31_6
				})
				UIUtil:getRewardIcon(nil, var_31_9.pid, {
					no_popup = true,
					name = false,
					show_color = true,
					role = true,
					no_tooltip = true,
					scale = 1,
					parent = var_31_7
				})
				
				var_31_5:getChildByName("btn_select_hero").select_id = var_31_9.id
			end
		end
	end
	
	arg_31_0.vars.itemview:enumControls(function(arg_32_0)
		local var_32_0 = 0
		
		for iter_32_0 = 1, 3 do
			local var_32_1 = arg_31_0.vars.selected_list[iter_32_0]
			
			if var_32_1 and arg_32_0.select_id == var_32_1 then
				var_32_0 = var_32_0 + 1
			end
		end
		
		if_set_visible(arg_32_0, "n_selected", var_32_0 > 0)
		
		if var_32_0 > 0 then
			if_set_color(arg_32_0, "n_hero", tocolor("#505050"))
			if_set_color(arg_32_0, "n_arti", tocolor("#505050"))
			if_set_color(arg_32_0, "bedge_limited", tocolor("#505050"))
		else
			if_set_color(arg_32_0, "n_hero", tocolor("#FFFFFF"))
			if_set_color(arg_32_0, "n_arti", tocolor("#FFFFFF"))
			if_set_color(arg_32_0, "bedge_limited", tocolor("#FFFFFF"))
		end
	end)
end

function GachaCustomGroupSelector.selectWithUpdateLeftInfo(arg_33_0, arg_33_1)
	arg_33_0:select(arg_33_1)
	arg_33_0:updateLeftInfo()
end

function GachaCustomGroupSelector.select(arg_34_0, arg_34_1, arg_34_2)
	if not get_cocos_refid(arg_34_1) then
		return 
	end
	
	if not arg_34_0.vars.list[arg_34_1.select_id] then
		return 
	end
	
	arg_34_0.vars.select_id = arg_34_1.select_id
	
	if get_cocos_refid(arg_34_0.vars.last_parent_node) then
		if_set_visible(arg_34_0.vars.last_parent_node, "selected", false)
	end
	
	local var_34_0 = arg_34_1:getParent()
	
	if not get_cocos_refid(var_34_0) then
		return 
	end
	
	arg_34_0.vars.last_parent_node = var_34_0
	
	if_set_visible(var_34_0, "selected", true)
end

function GachaCustomGroupSelector.confirmSelected(arg_35_0)
	if #arg_35_0.vars.selected_list < 3 then
		return 
	end
	
	local var_35_0 = Account:getGachaShopInfo().gacha_customgroup
	local var_35_1 = {}
	local var_35_2 = 0
	
	for iter_35_0, iter_35_1 in pairs(var_35_0.select_list or {}) do
		var_35_1[iter_35_1] = true
	end
	
	for iter_35_2, iter_35_3 in pairs(arg_35_0.vars.selected_list) do
		if var_35_1[iter_35_3] then
			var_35_2 = var_35_2 + 1
		end
	end
	
	if var_35_2 >= 3 then
		arg_35_0:close()
		
		return 
	end
	
	query("select_gacha_customgroup", {
		select_list = array_to_json(arg_35_0.vars.selected_list)
	})
end

function GachaCustomGroupSelector.updateSelectedList(arg_36_0, arg_36_1)
	local var_36_0 = Account:getGachaShopInfo().gacha_customgroup
	
	if var_36_0 then
		var_36_0.select_list = arg_36_1
	end
	
	GachaUnit:updateGachaCustomGroupSelected()
end

function GachaCustomGroupSelector.close(arg_37_0)
	if arg_37_0.vars and get_cocos_refid(arg_37_0.vars.dlg) then
		BackButtonManager:pop("GachaCustomGroupSelector")
		arg_37_0.vars.dlg:removeFromParent()
	end
	
	arg_37_0.vars = nil
end
