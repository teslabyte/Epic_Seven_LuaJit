function MsgHandler.select_gacha_substory_list(arg_1_0)
	GachaSubstorySelector:show(arg_1_0)
end

function MsgHandler.select_gacha_substory(arg_2_0)
	Account:addReward(arg_2_0.rewards)
	TopBarNew:topbarUpdate(true)
	
	if arg_2_0.gacha_shop_info then
		AccountData.gacha_shop_info = arg_2_0.gacha_shop_info
	end
	
	if arg_2_0.tl_doc_gacha_substory then
		AccountData.ticketed_limits["gl:gacha_substory"] = arg_2_0.tl_doc_gacha_substory
	end
	
	if arg_2_0.shop_list_powder and AccountData.shop and AccountData.shop.powder then
		AccountData.shop.powder = arg_2_0.shop_list_powder
	end
	
	GachaSubstorySelector:close()
	GachaUnit:enterGachaSubstory()
end

GachaSubstorySelector = {}

function HANDLER.choose_gacha_substory(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" or arg_3_1 == "btn_cancel" then
		GachaSubstorySelector:close()
	elseif arg_3_1 == "btn_select_list" then
		GachaSubstorySelector:selectWithUpdateLeftInfo(arg_3_0)
	elseif arg_3_1 == "btn_toggle" or arg_3_1 == "btn_toggle_close" or arg_3_1 == "btn_toggle_active" then
		GachaSubstorySelector:toggleFilter()
	elseif string.starts(arg_3_1, "btn_checkbox_") then
		GachaSubstorySelector:selectFilter(arg_3_1)
	elseif arg_3_1 == "btn_check1" then
		GachaSubstorySelector:selectSubFilter(1)
	elseif arg_3_1 == "btn_check2" then
		GachaSubstorySelector:selectSubFilter(2)
	elseif string.starts(arg_3_1, "btn_hero_") then
		GachaSubstorySelector:selectArtifactMode(false)
	elseif string.starts(arg_3_1, "btn_arti_") then
		GachaSubstorySelector:selectArtifactMode(true)
	elseif arg_3_1 == "btn_info" then
		GachaSubstorySelector:popupInfo()
	elseif arg_3_1 == "btn_move" then
		GachaSubstorySelector:moveSubstory()
	elseif arg_3_1 == "btn_choice_story_pickup" then
		GachaSubstorySelector:buyGachaSubstory()
	end
end

function GachaSubstorySelector.popupInfo(arg_4_0)
	local var_4_0 = load_dlg("shop_buy_detail", true, "wnd")
	
	if_set(var_4_0, "txt_title", T("ui_gachasubstory_select_title"))
	UIUtil:setScrollViewText(var_4_0:getChildByName("scrollview"), T("ui_gachasubstory_select_desc"))
	Dialog:msgBox("", {
		dlg = var_4_0
	})
end

function GachaSubstorySelector.show(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.artifact_mode = false
	
	if arg_5_1 then
		arg_5_0.vars.selectable_list = arg_5_1.selectable_list
		arg_5_0.vars.selectable_id = {}
		
		for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.selectable_list) do
			arg_5_0.vars.selectable_id[iter_5_1] = true
		end
		
		arg_5_0.vars.stored_codes = arg_5_1.stored_codes
		arg_5_0.vars.open_list = arg_5_1.open_list
		arg_5_0.vars.open_id = {}
		
		for iter_5_2, iter_5_3 in pairs(arg_5_0.vars.open_list) do
			arg_5_0.vars.open_id[iter_5_3] = true
		end
	else
		query("select_gacha_substory_list")
		
		return 
	end
	
	arg_5_0:popup()
end

function GachaSubstorySelector.setupFilter(arg_6_0)
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

function GachaSubstorySelector.selectArtifactMode(arg_7_0, arg_7_1)
	arg_7_0.vars.artifact_mode = arg_7_1
	arg_7_0.vars.filter_role = nil
	arg_7_0.vars.filter_element = nil
	arg_7_0.vars.filter_not_have = false
	arg_7_0.vars.filter_unlocked = false
	
	local var_7_0 = arg_7_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_top")
	
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
end

function GachaSubstorySelector.toggleFilter(arg_8_0)
	local var_8_0 = arg_8_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_toggle")
	
	if var_8_0:isVisible() then
		BackButtonManager:pop()
		if_set_visible(var_8_0, nil, false)
		
		return 
	end
	
	BackButtonManager:push({
		check_id = "GachaSubstorySelector.toggleFilter",
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

function GachaSubstorySelector.selectFilter(arg_10_0, arg_10_1, arg_10_2)
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
end

function GachaSubstorySelector.selectSubFilter(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_toggle")
	local var_11_1
	local var_11_2
	local var_11_3
	
	if arg_11_0.vars.artifact_mode then
		var_11_3 = var_11_0:getChildByName("n_sort_arti")
	else
		var_11_3 = var_11_0:getChildByName("n_sort")
	end
	
	if arg_11_1 == 1 then
		arg_11_0.vars.filter_not_have = not arg_11_0.vars.filter_not_have
		
		var_11_3:getChildByName("btn_check1"):getChildByName("checkbox1"):setSelected(arg_11_0.vars.filter_not_have)
	elseif arg_11_1 == 2 then
		arg_11_0.vars.filter_unlocked = not arg_11_0.vars.filter_unlocked
		
		var_11_3:getChildByName("btn_check2"):getChildByName("checkbox2"):setSelected(arg_11_0.vars.filter_unlocked)
	else
		for iter_11_0 = 1, 2 do
			var_11_3:getChildByName("btn_check" .. iter_11_0):getChildByName("checkbox" .. iter_11_0):setSelected(false)
		end
	end
	
	if not arg_11_2 then
		arg_11_0:refresh()
	end
	
	arg_11_0:updateToggleButton()
end

function GachaSubstorySelector.isUnlockedSubstory(arg_12_0, arg_12_1)
	return arg_12_0.vars.selectable_id[arg_12_1]
end

function GachaSubstorySelector.isUnlockedSubstoryByArtifact(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.list_by_arti[arg_13_1]
	
	if var_13_0 then
		return arg_13_0.vars.selectable_id[var_13_0.id]
	else
		return false
	end
end

function GachaSubstorySelector.isHaveSameCodeUnit(arg_14_0, arg_14_1)
	local var_14_0 = false
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.stored_codes or {}) do
		if iter_14_1 == arg_14_1 then
			var_14_0 = true
			
			break
		end
	end
	
	local var_14_1 = false
	
	for iter_14_2, iter_14_3 in pairs(AccountData.gacha_temp_inventory) do
		if iter_14_2 == arg_14_1 and to_n(iter_14_3) > 0 then
			var_14_1 = true
			
			break
		end
	end
	
	return var_14_0 or var_14_1 or Account:isHaveSameCodeUnit(arg_14_1) or Account:isHaveSameCodeArtifact(arg_14_1)
end

function GachaSubstorySelector.filterData(arg_15_0, arg_15_1)
	local var_15_0
	
	if arg_15_0.vars.artifact_mode then
		var_15_0 = arg_15_1.pid
	else
		var_15_0 = arg_15_1.id
	end
	
	if not var_15_0 then
		return false
	end
	
	local var_15_1 = arg_15_0.vars.filter_role or {
		"all"
	}
	local var_15_2 = arg_15_0.vars.filter_element or {
		"all"
	}
	local var_15_3 = arg_15_0.vars.filter_not_have
	local var_15_4 = arg_15_0.vars.filter_unlocked
	
	if string.starts(var_15_0, "c") then
		local var_15_5, var_15_6, var_15_7 = DB("character", var_15_0, {
			"name",
			"role",
			"ch_attribute"
		})
		
		if not var_15_5 then
			return false
		end
		
		local var_15_8 = 0
		
		for iter_15_0, iter_15_1 in pairs(var_15_1) do
			if iter_15_1 == "all" or iter_15_1 == var_15_6 then
				var_15_8 = var_15_8 + 1
			end
		end
		
		for iter_15_2, iter_15_3 in pairs(var_15_2) do
			if iter_15_3 == "all" or iter_15_3 == var_15_7 then
				var_15_8 = var_15_8 + 1
			end
		end
		
		if not arg_15_0.vars.filter_unlocked then
			var_15_8 = var_15_8 + 1
		elseif arg_15_0.vars.filter_unlocked and arg_15_0:isUnlockedSubstory(var_15_0) then
			var_15_8 = var_15_8 + 1
		end
		
		if not arg_15_0.vars.filter_not_have then
			var_15_8 = var_15_8 + 1
		elseif arg_15_0.vars.filter_not_have and not arg_15_0:isHaveSameCodeUnit(var_15_0) then
			var_15_8 = var_15_8 + 1
		end
		
		return var_15_8 == 4
	elseif string.starts(var_15_0, "e") then
		local var_15_9, var_15_10 = DB("equip_item", var_15_0, {
			"name",
			"role"
		})
		
		if not var_15_9 then
			return false
		end
		
		local var_15_11 = 0
		
		for iter_15_4, iter_15_5 in pairs(var_15_1) do
			if iter_15_5 == "all" or iter_15_5 == var_15_10 or iter_15_5 == nil and var_15_10 == "no_role" then
				var_15_11 = var_15_11 + 1
			end
		end
		
		if not arg_15_0.vars.filter_unlocked then
			var_15_11 = var_15_11 + 1
		elseif arg_15_0.vars.filter_unlocked and arg_15_0:isUnlockedSubstoryByArtifact(var_15_0) then
			var_15_11 = var_15_11 + 1
		end
		
		if not arg_15_0.vars.filter_not_have then
			var_15_11 = var_15_11 + 1
		elseif arg_15_0.vars.filter_not_have and not arg_15_0:isHaveSameCodeUnit(var_15_0) then
			var_15_11 = var_15_11 + 1
		end
		
		return var_15_11 == 3
	end
	
	return false
end

function GachaSubstorySelector.updateToggleButton(arg_16_0)
	local var_16_0 = arg_16_0:getFilterActive()
	local var_16_1 = arg_16_0.vars.dlg:getChildByName("cm_box")
	
	if_set_visible(var_16_1, "btn_toggle", not var_16_0)
	if_set_visible(var_16_1, "btn_toggle_active", var_16_0)
end

function GachaSubstorySelector.getFilterActive(arg_17_0)
	local var_17_0 = arg_17_0.vars.filter_role or {
		"all"
	}
	local var_17_1 = arg_17_0.vars.filter_element or {
		"all"
	}
	
	if arg_17_0.vars.filter_not_have or arg_17_0.vars.filter_unlocked then
		return true
	end
	
	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		if iter_17_1 ~= "all" then
			return true
		end
	end
	
	for iter_17_2, iter_17_3 in pairs(var_17_1) do
		if iter_17_3 ~= "all" then
			return true
		end
	end
	
	return false
end

function GachaSubstorySelector.popup(arg_18_0)
	local var_18_0 = load_dlg("choose_gacha", true, "wnd")
	
	var_18_0:setName("choose_gacha_substory")
	
	arg_18_0.vars.dlg = var_18_0
	arg_18_0.vars.filter_not_have = false
	arg_18_0.vars.filter_unlocked = false
	arg_18_0.vars.select_list = {}
	
	for iter_18_0 = 1, 9999 do
		local var_18_1 = {}
		
		var_18_1.id, var_18_1.pairing_id, var_18_1.systemsubstory_id, var_18_1.portrait_data, var_18_1.background, var_18_1.banner = DBN("gacha_substory_select_list", iter_18_0, {
			"id",
			"pairing_id",
			"systemsubstory_id",
			"portrait_data",
			"background",
			"banner"
		})
		
		if not var_18_1.id then
			break
		end
		
		if arg_18_0.vars.open_id[var_18_1.id] then
			arg_18_0.vars.select_list[var_18_1.id] = var_18_1
		end
	end
	
	local var_18_2 = arg_18_0.vars.dlg:getChildByName("cm_box")
	
	if_set_visible(var_18_2, "n_bottom", false)
	if_set_visible(var_18_2, "btn_select", false)
	if_set_visible(var_18_2, "btn_select", false)
	if_set_visible(var_18_2, "n_bottom_story_pickup", true)
	if_set_visible(var_18_2, "n_check_box", false)
	
	local var_18_3 = var_18_2:getChildByName("n_top")
	local var_18_4 = var_18_3:getChildByName("txt_title")
	
	if get_cocos_refid(var_18_4) then
		if_set(var_18_3, "txt_title", T("ui_gachasubstory_select_title"))
		
		local var_18_5 = var_18_4:getContentSize().width
		local var_18_6 = var_18_3:getChildByName("btn_info")
		
		if get_cocos_refid(var_18_6) then
			var_18_6:setPositionX(var_18_4:getPositionX() + var_18_5 * var_18_4:getScaleX() + 5)
		end
	end
	
	local var_18_7 = var_18_2:getChildByName("n_toggle")
	local var_18_8 = var_18_7:getChildByName("n_sort_arti")
	local var_18_9 = var_18_8:getChildByName("btn_check1")
	
	if_set(var_18_9, "txt_check1", T("ui_gachasubstory_select_filter1"))
	
	local var_18_10 = var_18_8:getChildByName("btn_check2")
	
	if_set(var_18_10, "txt_check2", T("ui_gachasubstory_select_filter2"))
	
	local var_18_11 = var_18_7:getChildByName("n_sort")
	local var_18_12 = var_18_11:getChildByName("btn_check1")
	
	if_set(var_18_12, "txt_check1", T("ui_gachasubstory_select_filter1"))
	
	local var_18_13 = var_18_11:getChildByName("btn_check2")
	
	if_set(var_18_13, "txt_check2", T("ui_gachasubstory_select_filter2"))
	
	if not arg_18_0:update() then
		return 
	end
	
	SceneManager:getRunningPopupScene():addChild(var_18_0)
	BackButtonManager:push({
		check_id = "GachaSubstorySelector",
		back_func = function()
			arg_18_0:close()
		end
	})
end

function GachaSubstorySelector.update(arg_20_0)
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
			
			if arg_20_0:isUnlockedSubstory(arg_21_3.id) then
				if_set_opacity(var_21_0, nil, 255)
			else
				if_set_opacity(var_21_0, nil, 127.5)
			end
			
			if_set_visible(arg_21_1, "bedge_limited", arg_21_3.limit == "y")
			if_set_visible(arg_21_1, "n_selected", false)
			if_set_color(arg_21_1, "n_hero", tocolor("#FFFFFF"))
			if_set_color(arg_21_1, "n_arti", tocolor("#FFFFFF"))
			if_set_color(arg_21_1, "bedge_limited", tocolor("#FFFFFF"))
			
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
			
			local var_21_1 = arg_21_1:getChildByName("btn_select_list")
			
			var_21_1.select_id = arg_21_3.id
			
			if arg_20_0.vars.select_id == arg_21_3.id then
				arg_20_0:select(var_21_1)
			end
		end
	}
	
	var_20_1:setRenderer(var_20_2, var_20_4)
	arg_20_0:selectArtifactMode(false)
	
	return true
end

function GachaSubstorySelector.refresh(arg_22_0)
	if not get_cocos_refid(arg_22_0.vars.itemview) then
		return 
	end
	
	arg_22_0.vars.itemview:removeAllChildren()
	
	arg_22_0.vars.last_parent_node = nil
	
	UIAction:Add(SEQ(DELAY(300)), arg_22_0, "block")
	
	arg_22_0.vars.list = {}
	arg_22_0.vars.list_by_arti = {}
	
	local var_22_0 = {}
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.select_list) do
		local var_22_1 = {
			id = iter_22_1.id,
			pid = iter_22_1.pairing_id
		}
		
		arg_22_0.vars.list[iter_22_1.id] = var_22_1
		
		if iter_22_1.pairing_id then
			arg_22_0.vars.list_by_arti[iter_22_1.pairing_id] = var_22_1
		end
		
		if arg_22_0:filterData(var_22_1) then
			table.push(var_22_0, var_22_1)
		end
	end
	
	table.sort(var_22_0, function(arg_23_0, arg_23_1)
		return arg_23_0.id < arg_23_1.id
	end)
	
	local var_22_2 = {}
	
	for iter_22_2, iter_22_3 in pairs(var_22_0) do
		if arg_22_0.vars.selectable_id[iter_22_3.id] then
			table.push(var_22_2, iter_22_3)
		end
	end
	
	for iter_22_4, iter_22_5 in pairs(var_22_0) do
		if not arg_22_0.vars.selectable_id[iter_22_5.id] then
			table.push(var_22_2, iter_22_5)
		end
	end
	
	if var_22_2[1] then
		arg_22_0.vars.select_id = var_22_2[1].id
	else
		arg_22_0.vars.select_id = nil
	end
	
	arg_22_0.vars.itemview:setDataSource(var_22_2)
	
	local var_22_3 = arg_22_0.vars.dlg:getChildByName("cm_box")
	
	if_set_visible(var_22_3, "n_no_data", #var_22_2 == 0)
	
	if #var_22_2 == 0 then
		local var_22_4 = var_22_3:getChildByName("n_no_data")
		
		if arg_22_0.vars.artifact_mode then
			if_set(var_22_4, "label", T("ui_popup_artifact_select_none_filtered"))
		else
			if_set(var_22_4, "label", T("ui_popup_hero_select_none_filtered"))
		end
	end
	
	arg_22_0:updateLeftInfo()
	arg_22_0.vars.itemview:jumpToTop()
end

function GachaSubstorySelector.updateLeftInfo(arg_24_0)
	if not arg_24_0.vars.select_id then
		return 
	end
	
	if arg_24_0.vars.select_id then
		if arg_24_0.vars.last_selected_id == arg_24_0.vars.select_id then
			return 
		end
		
		arg_24_0.vars.last_selected_id = arg_24_0.vars.select_id
	end
	
	local var_24_0 = arg_24_0.vars.dlg:getChildByName("n_detail")
	
	if not get_cocos_refid(var_24_0) then
		return 
	end
	
	var_24_0:removeAllChildren()
	
	local var_24_1 = load_control("wnd/choose_gacha_info_hero.csb")
	
	var_24_0:addChild(var_24_1)
	var_24_1:getChildByName("n_star_base"):setPositionX(0)
	
	local var_24_2, var_24_3 = DB("character", arg_24_0.vars.select_id, {
		"grade",
		"face_id"
	})
	local var_24_4 = UIUtil:getPortraitAni(var_24_3, {
		pin_sprite_position_y = true
	})
	
	arg_24_0.vars.unit_detail = UIUtil:getGachaCharacterPopup({
		review_preview = true,
		not_my_unit = true,
		hide_level = true,
		dlg = var_24_1,
		code = arg_24_0.vars.select_id,
		grade = var_24_2,
		custom_portrait = var_24_4
	})
	
	local var_24_5 = var_24_1:getChildByName("n_dedi")
	
	if_set_visible(var_24_5, "t_locked", false)
	if_set_visible(var_24_5, "icon_lock", false)
	
	local var_24_6 = var_24_1:getChildByName("n_arti_info")
	local var_24_7 = arg_24_0.vars.list[arg_24_0.vars.select_id]
	
	if_set_visible(var_24_6, "txt_type", true)
	if_set_visible(var_24_6, "txt_name_arti", true)
	
	local var_24_8 = DB("equip_item", var_24_7.pid, {
		"artifact_grade"
	})
	local var_24_9 = var_24_6:getChildByName("item_art_icon")
	
	UIUtil:getRewardIcon(nil, var_24_7.pid, {
		show_color = true,
		no_tooltip = true,
		show_name = true,
		role = true,
		no_popup = true,
		scale = 1,
		parent = var_24_9,
		txt_name = var_24_6:getChildByName("txt_name_arti"),
		txt_type = var_24_6:getChildByName("txt_type"),
		grade = var_24_8
	})
	
	local var_24_10 = EQUIP:createByInfo({
		code = var_24_7.pid
	})
	
	WidgetUtils:setupPopup({
		control = var_24_6:getChildByName("btn_art_info"),
		creator = function()
			return ItemTooltip:getItemTooltip({
				show_max_check_box = true,
				artifact_popup = true,
				code = var_24_7.pid,
				grade = var_24_8,
				equip = var_24_10,
				equip_stat = var_24_10.stats
			})
		end
	})
	arg_24_0:updateRecommendTag()
end

function GachaSubstorySelector.updateRecommendTag(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.dlg) then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.dlg:getChildByName("n_hero_tag")
	
	if get_cocos_refid(var_26_0) then
		local var_26_1 = arg_26_0.vars.dlg:getChildByName("n_hero_tag_move")
		
		if get_cocos_refid(var_26_1) then
			var_26_0:setPositionY(var_26_1:getPositionY())
		end
		
		if arg_26_0.vars.select_id then
			HeroRecommend:setRecommendTag(arg_26_0.vars.select_id, var_26_0)
		else
			var_26_0:setVisible(false)
		end
	end
end

function GachaSubstorySelector.selectWithUpdateLeftInfo(arg_27_0, arg_27_1)
	arg_27_0:select(arg_27_1)
	arg_27_0:updateLeftInfo()
end

function GachaSubstorySelector.updateSelectable(arg_28_0)
	local var_28_0 = arg_28_0.vars.dlg:getChildByName("cm_box"):getChildByName("n_bottom_story_pickup")
	local var_28_1 = var_28_0:getChildByName("n_not_selectable")
	local var_28_2 = var_28_1:getChildByName("btn_move")
	
	if_set(var_28_2, "txt_label_move", T("storypickup_heroselect_unlock_2"))
	
	if arg_28_0.vars.select_id and not arg_28_0:isUnlockedSubstory(arg_28_0.vars.select_id) then
		if_set_visible(var_28_0, "n_not_selectable", true)
		if_set_visible(var_28_0, "btn_choice_story_pickup", false)
		
		local var_28_3 = {}
		local var_28_4 = arg_28_0.vars.select_list[arg_28_0.vars.select_id]
		
		if var_28_4 and var_28_4.systemsubstory_id then
			for iter_28_0, iter_28_1 in pairs(string.split(var_28_4.systemsubstory_id, ";") or {}) do
				local var_28_5 = DB("substory_main", iter_28_1, {
					"quest_chapter_desc"
				})
				
				if var_28_5 then
					table.push(var_28_3, T(var_28_5))
				end
			end
		end
		
		local var_28_6 = var_28_1:getChildByName("n_info_story_pickup")
		
		if_set(var_28_6, "t_story_info", T("storygacha_limit_2", {
			name = string.join(var_28_3, ", ")
		}))
	else
		if_set_visible(var_28_0, "n_not_selectable", false)
		if_set_visible(var_28_0, "btn_choice_story_pickup", true)
		
		local var_28_7 = Account:getGachaShopInfo().gacha_substory
		local var_28_8 = var_28_7.use_open_token
		local var_28_9 = var_28_0:getChildByName("btn_choice_story_pickup")
		
		if to_n(var_28_7.first_select) == 1 then
			var_28_8 = 0
			
			if_set_visible(var_28_9, "cm_free_tooltip", true)
			
			local var_28_10 = var_28_9:getChildByName("cm_free_tooltip")
			
			if_set(var_28_10, "txt_free", T("ui_storypickup_bonus_info"))
		else
			if_set_visible(var_28_9, "cm_free_tooltip", false)
		end
		
		if_set(var_28_9, "label", var_28_8)
		UIUtil:getRewardIcon(nil, var_28_7.open_token, {
			no_bg = true,
			parent = var_28_9:getChildByName("n_token")
		})
	end
end

function GachaSubstorySelector.confirmGachaSubstory(arg_29_0)
	if not arg_29_0.vars.select_id then
		return 
	end
	
	if not arg_29_0:isUnlockedSubstory(arg_29_0.vars.select_id) then
		return 
	end
	
	local var_29_0 = Account:getGachaShopInfo().gacha_substory
	local var_29_1 = load_dlg("gacha_story_pickup_sel_result", true, "wnd")
	
	if_set_visible(var_29_1, "btn_banner", false)
	
	local var_29_2 = T(DB("character", arg_29_0.vars.select_id, {
		"name"
	}))
	
	if_set(var_29_1, "txt_title", T("storypickup_info_popup_title"))
	if_set(var_29_1, "txt_desc", T("storypickup_info_popup_desc", {
		name = var_29_2,
		char_name = var_29_2
	}))
	
	local var_29_3 = createGachaBanner({
		gacha_substory = true,
		gacha_substory_banner = true,
		id = arg_29_0.vars.select_id
	})
	
	if var_29_3 then
		var_29_3:setContentSize({
			width = 365,
			height = 180
		})
		if_set_visible(var_29_3, "btn_banner", false)
		var_29_1:getChildByName("n_banner"):addChild(var_29_3)
	end
	
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_29_1,
		handler = function(arg_30_0, arg_30_1, arg_30_2)
			if arg_30_1 == "btn_yes" then
				if arg_29_0:isUnlockedSubstory(arg_29_0.vars.select_id) then
					query("select_gacha_substory", {
						code = arg_29_0.vars.select_id
					})
				end
			else
				return "dont_close"
			end
		end
	})
end

function GachaSubstorySelector.buyGachaSubstory(arg_31_0)
	if not arg_31_0.vars.select_id then
		return 
	end
	
	if not arg_31_0:isUnlockedSubstory(arg_31_0.vars.select_id) then
		return 
	end
	
	local var_31_0 = Account:getGachaShopInfo().gacha_substory
	
	if to_n(var_31_0.first_select) ~= 1 and Account:getCurrency(var_31_0.open_token) < to_n(var_31_0.use_open_token) then
		balloon_message_with_sound("storypickup_notenough_mileage")
		
		return 
	end
	
	arg_31_0:confirmGachaSubstory()
end

function GachaSubstorySelector.moveSubstory(arg_32_0)
	GachaSubstorySelector:close()
	Account:showServerResUI("system_story")
end

function GachaSubstorySelector.select(arg_33_0, arg_33_1, arg_33_2)
	if not get_cocos_refid(arg_33_1) then
		return 
	end
	
	if not arg_33_0.vars.list[arg_33_1.select_id] then
		return 
	end
	
	arg_33_0.vars.select_id = arg_33_1.select_id
	
	if get_cocos_refid(arg_33_0.vars.last_parent_node) then
		if_set_visible(arg_33_0.vars.last_parent_node, "selected", false)
	end
	
	local var_33_0 = arg_33_1:getParent()
	
	if not get_cocos_refid(var_33_0) then
		return 
	end
	
	arg_33_0.vars.last_parent_node = var_33_0
	
	if_set_visible(var_33_0, "selected", true)
	arg_33_0:updateSelectable()
end

function GachaSubstorySelector.close(arg_34_0)
	if arg_34_0.vars and get_cocos_refid(arg_34_0.vars.dlg) then
		BackButtonManager:pop("GachaSubstorySelector")
		arg_34_0.vars.dlg:removeFromParent()
	end
	
	arg_34_0.vars = nil
end
