SelectUnitUI = {}

function MsgHandler.select_pool_list(arg_1_0)
	SelectUnitUI:init(arg_1_0)
end

function MsgHandler.select_gacha_special_list(arg_2_0)
	SelectUnitUI:init(arg_2_0)
end

function MsgHandler.select_gacha_customspecial_list(arg_3_0)
	SelectUnitUI:init(arg_3_0)
end

function HANDLER.recall_choose_popup(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_select" then
		SelectUnitUI:onSelectItem(arg_4_0.data)
	end
	
	if arg_4_1 == "btn_close" or arg_4_1 == "btn_cancel" then
		SelectUnitUI:close()
	end
	
	if arg_4_1 == "btn_choice_complete" then
		SelectUnitUI:onSelectComplete()
	end
	
	if arg_4_1 == "checkbox_g" then
		SelectUnitUI:updateFilteredUnits()
	end
	
	if arg_4_1 == "btn_toggle" or arg_4_1 == "btn_toggle_close" or arg_4_1 == "btn_toggle_active" then
		SelectUnitUI:toggleFilter()
	end
	
	if string.starts(arg_4_1, "btn_checkbox_") then
		SelectUnitUI:selectFilter(arg_4_1)
	end
	
	if arg_4_1 == "btn_info" or arg_4_1 == "btn_close_popup" then
		SelectUnitUI:toggleInfo()
	end
end

function SelectUnitUI.toggleInfo(arg_5_0)
	local var_5_0 = arg_5_0.vars.dlg:getChildByName("n_popup_disc")
	
	if var_5_0:isVisible() then
		BackButtonManager:pop()
		if_set_visible(var_5_0, nil, false)
		
		return 
	end
	
	BackButtonManager:push({
		check_id = "SelectUnitUI.toggleInfo",
		back_func = function()
			arg_5_0:toggleInfo()
		end
	})
	if_set_visible(var_5_0, nil, true)
end

function SelectUnitUI.toggleFilter(arg_7_0)
	local var_7_0 = arg_7_0.vars.dlg:getChildByName("n_toggle")
	
	if var_7_0:isVisible() then
		BackButtonManager:pop()
		if_set_visible(var_7_0, nil, false)
		
		return 
	end
	
	BackButtonManager:push({
		check_id = "SelectUnitUI.toggleFilter",
		back_func = function()
			arg_7_0:toggleFilter()
		end
	})
	if_set_visible(var_7_0, nil, true)
	
	local var_7_1
	
	if arg_7_0.vars.is_unit_only then
		local var_7_2 = var_7_0:getChildByName("n_sort")
	end
	
	if arg_7_0.vars.is_artifact_only then
		local var_7_3 = var_7_0:getChildByName("n_sort_arti")
	end
	
	if not arg_7_0.vars.filter_role then
		arg_7_0.vars.filter_role = {
			"all"
		}
		
		arg_7_0:selectFilter("btn_checkbox_role_all", true)
	end
	
	if not arg_7_0.vars.filter_element then
		arg_7_0.vars.filter_element = {
			"all"
		}
		
		arg_7_0:selectFilter("btn_checkbox_element_all", true)
	end
end

function SelectUnitUI.selectFilter(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars.filter_un_hash_tbl then
		return 
	end
	
	local var_9_0 = string.split(arg_9_1, "btn_checkbox_")
	
	if not var_9_0 or not var_9_0[2] then
		return 
	end
	
	local var_9_1 = string.split(var_9_0[2], "_")
	
	if not var_9_1[1] or not var_9_1[2] then
		return 
	end
	
	local var_9_2 = tostring(var_9_1[1])
	local var_9_3 = tostring(var_9_1[2])
	local var_9_4 = arg_9_0.vars.dlg:getChildByName("n_toggle")
	local var_9_5
	
	if arg_9_0.vars.is_unit_only then
		var_9_5 = var_9_4:getChildByName("n_sort")
	end
	
	if arg_9_0.vars.is_artifact_only then
		var_9_5 = var_9_4:getChildByName("n_sort_arti")
	end
	
	local var_9_6 = var_9_5:getChildByName("n_" .. var_9_2)
	
	if not get_cocos_refid(var_9_6) then
		return 
	end
	
	arg_9_0.vars["filter_" .. var_9_2] = {}
	
	local var_9_7 = arg_9_0.vars.filter_un_hash_tbl[var_9_2]
	local var_9_8 = false
	
	if var_9_3 == "all" then
		var_9_8 = var_9_6:getChildByName("n_check_box_all"):getChildByName("checkbox_" .. var_9_2 .. "_all"):isSelected()
		
		if arg_9_2 then
			var_9_8 = false
		end
	end
	
	local var_9_9 = 0
	
	for iter_9_0, iter_9_1 in pairs(var_9_7) do
		iter_9_0 = tostring(iter_9_0)
		
		local var_9_10 = var_9_6:getChildByName("n_check_box_" .. iter_9_0)
		local var_9_11 = var_9_10:getChildByName("checkbox_" .. var_9_2 .. "_" .. iter_9_0)
		local var_9_12 = var_9_10:getChildByName("select_bg_" .. var_9_2 .. "_" .. iter_9_0)
		
		if var_9_3 == "all" then
			if iter_9_0 == "all" then
				var_9_11:setSelected(not var_9_8)
				var_9_12:setVisible(not var_9_8)
			else
				var_9_11:setSelected(var_9_8)
				var_9_12:setVisible(var_9_8)
			end
		else
			if iter_9_0 == "all" then
				var_9_11:setSelected(false)
				var_9_12:setVisible(false)
			end
			
			if iter_9_0 == var_9_3 then
				local var_9_13 = var_9_11:isSelected()
				
				var_9_11:setSelected(not var_9_13)
				var_9_12:setVisible(not var_9_13)
			end
		end
		
		if var_9_11:isSelected() then
			var_9_9 = var_9_9 + 1
			
			table.push(arg_9_0.vars["filter_" .. var_9_2], iter_9_1)
		end
	end
	
	if var_9_9 == 0 then
		arg_9_0:selectFilter("btn_checkbox_" .. var_9_2 .. "_all", true)
	else
		arg_9_0:updateFilteredUnits()
	end
	
	arg_9_0:updateToggleButton()
end

function SelectUnitUI.updateToggleButton(arg_10_0)
	local var_10_0 = arg_10_0:getFilterActive()
	
	if_set_visible(arg_10_0.vars.dlg, "btn_toggle", not var_10_0)
	if_set_visible(arg_10_0.vars.dlg, "btn_toggle_active", var_10_0)
end

function SelectUnitUI.getFilterActive(arg_11_0)
	local var_11_0 = arg_11_0.vars.filter_role or {
		"all"
	}
	local var_11_1 = arg_11_0.vars.filter_element or {
		"all"
	}
	
	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		if iter_11_1 ~= "all" then
			return true
		end
	end
	
	for iter_11_2, iter_11_3 in pairs(var_11_1) do
		if iter_11_3 ~= "all" then
			return true
		end
	end
	
	return false
end

function SelectUnitUI.selection_default(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0.vars.listView
	local var_12_1 = var_12_0.vars.dataSource[arg_12_1]
	
	if not var_12_1 then
		return 
	end
	
	local var_12_2 = var_12_0:getControl(var_12_1)
	
	if var_12_2 then
		if_set_visible(var_12_2, arg_12_2, arg_12_4)
	end
	
	var_12_1[arg_12_3] = arg_12_4
	var_12_0.vars.dataSource[arg_12_1] = var_12_1
end

function SelectUnitUI.lateSelect(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0:selection_default(arg_13_1, arg_13_2, arg_13_3, true)
end

function SelectUnitUI.lateDeselect(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0:selection_default(arg_14_1, arg_14_2, arg_14_3, false)
end

function SelectUnitUI.makeDlg(arg_15_0)
	local var_15_0 = load_dlg("recall_choose_popup", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(var_15_0)
	
	arg_15_0.vars.dlg = var_15_0
	
	return var_15_0
end

function SelectUnitUI.onSelectComplete(arg_16_0)
	if not arg_16_0.vars.prv_index then
		if arg_16_0.vars.is_unit_only then
			balloon_message_with_sound("err_hero_selection_select_first")
		else
			balloon_message_with_sound("err_artifact_selection_select_first")
		end
		
		return 
	end
	
	local var_16_0 = arg_16_0.vars.datas[arg_16_0.vars.prv_index]
	
	if not var_16_0 then
		Log.e("WARNING ! NO DATA! ")
		
		return 
	end
	
	local var_16_1
	
	if var_16_0.type == "character" then
		var_16_1 = DB("character", var_16_0.code, "name")
	elseif var_16_0.type == "artifact" then
		var_16_1 = DB("equip_item", var_16_0.code, "name")
	end
	
	if arg_16_0.vars.origin_data.caller == "unit_recall" then
		arg_16_0:close()
		UnitDetailGrowth:selectRecall(var_16_0.code)
	elseif arg_16_0.vars.origin_data.caller == "postbox" then
		local var_16_2 = load_dlg("msgbox_item_sel", true, "wnd")
		
		if get_cocos_refid(var_16_2) then
			UIUtil:getRewardIcon(1, var_16_0.code, {
				no_popup = true,
				parent = var_16_2:findChildByName("reward_item1/1")
			})
			Dialog:msgBox(T("ui_hero_selection_alret", {
				name = T(var_16_1)
			}), {
				yesno = true,
				handler = function()
					UIAction:Add(SEQ(DELAY(50), CALL(function()
						SelectUnitUI:close()
						
						if Postbox.selected_mail then
							query("read_mail", {
								idx = Postbox.selected_mail,
								oid = var_16_0.code
							})
						end
					end)), arg_16_0, "block")
				end,
				dlg = var_16_2,
				title = T("ui_popup_selection_confirm_title")
			})
		end
	elseif arg_16_0.vars.origin_data.caller == "package_hero_select" then
		arg_16_0:close()
		ShopPromotion:selectCustomizedHeroSelect(var_16_0.code)
	elseif arg_16_0.vars.origin_data.caller == "gacha_special" then
		if GachaUnit:selectGachaSpecialCeiling(var_16_0.code, true) then
			arg_16_0:close()
			GachaUnit:selectGachaSpecialCeiling(var_16_0.code)
		end
	elseif arg_16_0.vars.origin_data.caller == "gacha_customspecial" then
		local var_16_3 = arg_16_0.vars.origin_data.select_idx
		
		if GachaUnit:updateGachaCustomSpecialSelectedInfo(var_16_0.code, var_16_3, true) then
			arg_16_0:close()
			GachaUnit:updateGachaCustomSpecialSelectedInfo(var_16_0.code, var_16_3)
		end
	end
end

function SelectUnitUI.updateFilteredUnits(arg_19_0)
	arg_19_0:lateDeselect(arg_19_0.vars.prv_index, "selected", "selected")
	
	arg_19_0.vars.prv_index = nil
	
	local var_19_0 = arg_19_0.vars.dlg:findChildByName("checkbox_g")
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = var_19_0:isSelected()
	
	arg_19_0.vars.listView:removeAllChildren()
	
	local var_19_2 = arg_19_0:makeDatas(arg_19_0.vars.origin_data, var_19_1)
	
	arg_19_0.vars.listView:setDataSource(var_19_2)
	
	arg_19_0.vars.datas = var_19_2
	
	local var_19_3 = arg_19_0.vars.dlg:getChildByName("n_no_data")
	
	if table.count(var_19_2) > 0 then
		arg_19_0:onSelectItem(arg_19_0.vars.datas[1], true)
		if_set_opacity(arg_19_0.vars.dlg, "btn_choice_complete", 255)
		if_set_visible(var_19_3, nil, false)
	else
		if_set_opacity(arg_19_0.vars.dlg, "btn_choice_complete", 76.5)
		if_set_visible(var_19_3, nil, true)
		
		if arg_19_0.vars.is_unit_only then
			if_set(var_19_3, "label", T("ui_popup_hero_select_none_filtered"))
		else
			if_set(var_19_3, "label", T("ui_popup_artifact_select_none_filtered"))
		end
	end
	
	return true
end

function SelectUnitUI.makeListView(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0:makeDatas(arg_20_1, arg_20_3)
	
	if not var_20_0 then
		return 
	end
	
	local var_20_1 = arg_20_2:findChildByName("card_listview")
	
	arg_20_0.vars.listView = ItemListView_v2:bindControl(var_20_1)
	
	local var_20_2 = load_control("wnd/recall_choose_popup_card.csb")
	local var_20_3 = {
		onUpdate = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			SelectUnitUI:onListViewUpdate(arg_21_1, arg_21_2, arg_21_3)
		end
	}
	
	arg_20_0.vars.listView:setRenderer(var_20_2, var_20_3)
	arg_20_0.vars.listView:setListViewCascadeEnabled(true)
	arg_20_0.vars.listView:setDataSource(var_20_0)
	
	arg_20_0.vars.datas = var_20_0
	
	return arg_20_0.vars.listView
end

function SelectUnitUI.filterData(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return false
	end
	
	local var_22_0 = arg_22_0.vars.filter_role or {
		"all"
	}
	local var_22_1 = arg_22_0.vars.filter_element or {
		"all"
	}
	local var_22_7
	
	if string.starts(arg_22_1, "c") then
		local var_22_2, var_22_3, var_22_4 = DB("character", arg_22_1, {
			"name",
			"role",
			"ch_attribute"
		})
		
		if not var_22_2 then
			return false
		end
		
		local var_22_5 = 0
		
		for iter_22_0, iter_22_1 in pairs(var_22_0) do
			if iter_22_1 == "all" or iter_22_1 == var_22_3 then
				var_22_5 = var_22_5 + 1
			end
		end
		
		for iter_22_2, iter_22_3 in pairs(var_22_1) do
			if iter_22_3 == "all" or iter_22_3 == var_22_4 then
				var_22_5 = var_22_5 + 1
			end
		end
		
		return var_22_5 == 2
	elseif string.starts(arg_22_1, "e") then
		local var_22_6
		
		var_22_6, var_22_7 = DB("equip_item", arg_22_1, {
			"name",
			"role"
		})
		
		if not var_22_6 then
			return false
		end
		
		for iter_22_4, iter_22_5 in pairs(var_22_0) do
			if iter_22_5 == "all" or iter_22_5 == var_22_7 or iter_22_5 == nil and var_22_7 == "no_role" then
				return true
			end
		end
	end
	
	return false
end

function SelectUnitUI.makeDatas(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_1 then
		return 
	end
	
	local var_23_0 = {}
	local var_23_1 = arg_23_1.view_list_sum
	
	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		var_23_0[iter_23_0] = true
	end
	
	local var_23_2 = {}
	local var_23_3 = arg_23_1.view_list
	
	local function var_23_4(arg_24_0, arg_24_1, arg_24_2)
		local var_24_0 = UIUtil:getItemDisplayInfo(arg_24_1.code)
		local var_24_1 = true
		
		if arg_24_2 and arg_23_0:isHaveSameCodeUnit(arg_24_1.code) then
			var_24_1 = false
		end
		
		if not arg_23_0:filterData(arg_24_1.code) then
			var_24_1 = false
		end
		
		if var_24_1 then
			local var_24_2 = arg_24_1
			
			var_24_2.type = var_24_0.type
			var_24_2.index = table.count(arg_24_0) + 1
			
			table.insert(arg_24_0, var_24_2)
		end
	end
	
	if arg_23_1.selected_id then
		for iter_23_2, iter_23_3 in pairs(var_23_0) do
			for iter_23_4 = 1, table.count(var_23_3[iter_23_2]) do
				local var_23_5 = var_23_3[iter_23_2][iter_23_4]
				
				if arg_23_1.selected_id == var_23_5.code then
					var_23_4(var_23_2, var_23_5, arg_23_2)
				end
			end
		end
	end
	
	for iter_23_5, iter_23_6 in pairs(var_23_0) do
		for iter_23_7 = 1, table.count(var_23_3[iter_23_5]) do
			local var_23_6 = var_23_3[iter_23_5][iter_23_7]
			
			if arg_23_1.selected_id ~= var_23_6.code then
				var_23_4(var_23_2, var_23_6, arg_23_2)
			end
		end
	end
	
	return var_23_2
end

function SelectUnitUI.isHaveSameCodeUnit(arg_25_0, arg_25_1)
	local var_25_0 = false
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.origin_data.stored_codes or {}) do
		if iter_25_1 == arg_25_1 then
			var_25_0 = true
			
			break
		end
	end
	
	local var_25_1 = false
	
	for iter_25_2, iter_25_3 in pairs(AccountData.gacha_temp_inventory) do
		if iter_25_2 == arg_25_1 and to_n(iter_25_3) > 0 then
			var_25_1 = true
			
			break
		end
	end
	
	return var_25_0 or var_25_1 or Account:isHaveSameCodeUnit(arg_25_1) or Account:isHaveSameCodeArtifact(arg_25_1)
end

function SelectUnitUI.onListViewUpdate(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0
	
	if arg_26_3.type == "character" then
		var_26_0 = "n_mob_icon"
	elseif arg_26_3.type == "artifact" then
		var_26_0 = "n_item_art_icon"
	else
		print("Please Check  : ", debug.traceback())
	end
	
	UIUtil:getRewardIcon(1, arg_26_3.code, {
		no_popup = true,
		no_tooltip = true,
		role = true,
		scale = 1,
		parent = arg_26_1,
		target = var_26_0
	})
	
	local var_26_1 = arg_26_1:findChildByName("btn_select")
	
	arg_26_3.index = arg_26_2
	var_26_1.data = arg_26_3
	
	if_set_visible(arg_26_1, "selected", arg_26_3.selected)
end

function SelectUnitUI.setupUnitDetail(arg_27_0, arg_27_1)
	if not arg_27_1 then
		return 
	end
	
	if arg_27_0.vars.last_code == arg_27_1 then
		return 
	end
	
	arg_27_0.vars.last_code = arg_27_1
	
	if not get_cocos_refid(arg_27_0.vars.unit_detail) then
		local var_27_0 = load_control("wnd/recall_choose_hero_detail_sub.csb")
		
		arg_27_0.vars.unit_detail = var_27_0
	else
		arg_27_0.vars.unit_detail:findChildByName("portrait"):removeAllChildren()
		UIUtil:removeSubTaskEventListener(arg_27_0.vars.unit_detail)
	end
	
	local var_27_1, var_27_2 = DB("character", arg_27_1, {
		"grade",
		"face_id"
	})
	local var_27_3 = UIUtil:getPortraitAni(var_27_2, {
		pin_sprite_position_y = true
	})
	
	arg_27_0.vars.unit_detail = UIUtil:getCharacterPopup({
		awake = 6,
		z = 6,
		doNotReverseSkill = true,
		use_basic_star = true,
		review_preview = true,
		hide_level = true,
		level = 1,
		dlg = arg_27_0.vars.unit_detail,
		code = arg_27_1,
		grade = var_27_1,
		custom_portrait = var_27_3
	})
	
	arg_27_0.vars.unit_detail:setName("recall_choose_hero_detail_sub")
	
	return arg_27_0.vars.unit_detail
end

function SelectUnitUI.setupArtifactDetail(arg_28_0, arg_28_1)
	if not arg_28_1 then
		return 
	end
	
	if arg_28_0.vars.last_code == arg_28_1 then
		return 
	end
	
	arg_28_0.vars.last_code = arg_28_1
	
	if not get_cocos_refid(arg_28_0.vars.arti_detail) then
		local var_28_0 = load_control("wnd/recall_choose_arti_detail_sub.csb")
		
		arg_28_0.vars.arti_detail = var_28_0
	end
	
	local var_28_1 = DB("equip_item", arg_28_1, "artifact_grade")
	local var_28_2 = EQUIP:createByInfo({
		code = arg_28_1
	})
	
	arg_28_0.vars.arti_detail = ItemTooltip:getItemTooltip({
		set_desc_richtext = true,
		wnd = arg_28_0.vars.arti_detail,
		code = arg_28_1,
		grade = var_28_1,
		equip = var_28_2,
		equip_stats = var_28_2.stats
	})
	
	return arg_28_0.vars.arti_detail
end

function SelectUnitUI.onSelectItem(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_1 or not arg_29_1.code then
		print("NO CODE! ")
		
		return 
	end
	
	if arg_29_1.index == arg_29_0.vars.prv_index and not arg_29_2 then
		return 
	end
	
	local var_29_0 = arg_29_0:setDetail(arg_29_1)
	
	arg_29_0:setVisibleItem(arg_29_1)
	arg_29_0:setRecommendTag(arg_29_1)
	
	return var_29_0
end

function SelectUnitUI.setDetail(arg_30_0, arg_30_1)
	local var_30_0 = true
	local var_30_1
	
	if arg_30_1.type == "character" then
		var_30_1 = arg_30_0:setupUnitDetail(arg_30_1.code)
	elseif arg_30_1.type == "artifact" then
		var_30_1 = arg_30_0:setupArtifactDetail(arg_30_1.code)
	else
		print("Please Check  : ", debug.traceback())
	end
	
	arg_30_0:_customSetupForPub()
	
	if not var_30_1 then
		var_30_0 = false
	else
		local var_30_2 = arg_30_0.vars.dlg:findChildByName("n_detail")
		
		if not var_30_2 then
			print("n_detail can`t find in dlg")
			
			return false
		end
		
		if get_cocos_refid(arg_30_0.vars.detail) and arg_30_0.vars.detail ~= var_30_1 then
			arg_30_0.vars.detail:removeFromParent()
		end
		
		if not arg_30_0.vars.detail then
			var_30_2:addChild(var_30_1)
		end
		
		arg_30_0.vars.detail = var_30_1
	end
	
	return var_30_0
end

function SelectUnitUI._customSetupForPub(arg_31_0)
	if get_cocos_refid(arg_31_0.vars.unit_detail) then
		local var_31_0 = arg_31_0.vars.unit_detail:getChildByName("n_hero_tag")
		
		arg_31_0.vars.n_hero_tag = var_31_0
		
		if IS_PUBLISHER_ZLONG then
			local var_31_1 = arg_31_0.vars.unit_detail:getChildByName("n_hero_tag_zl")
			
			if_set_visible(var_31_0, nil, false)
			if_set_visible(var_31_1, nil, true)
			
			arg_31_0.vars.n_hero_tag = var_31_1
		end
	end
end

function SelectUnitUI.setVisibleItem(arg_32_0, arg_32_1)
	if arg_32_0.vars.prv_index then
		arg_32_0:lateDeselect(arg_32_0.vars.prv_index, "selected", "selected")
	end
	
	arg_32_0:lateSelect(arg_32_1.index, "selected", "selected")
	
	arg_32_0.vars.prv_index = arg_32_1.index
end

function SelectUnitUI.setRecommendTag(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.dlg) then
		return 
	end
	
	if get_cocos_refid(arg_33_0.vars.n_hero_tag) then
		HeroRecommend:setRecommendTag(arg_33_1.code, arg_33_0.vars.n_hero_tag)
	end
end

function SelectUnitUI.setupFilter(arg_34_0)
	local var_34_0 = arg_34_0.vars.dlg
	
	if arg_34_0.vars.is_unit_only then
		arg_34_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
		arg_34_0.vars.filter_un_hash_tbl.star = nil
		arg_34_0.vars.filter_un_hash_tbl.role[7] = nil
		
		if_set_visible(var_34_0, "n_toggle", false)
		
		local var_34_1 = var_34_0:getChildByName("n_toggle")
		
		if_set_visible(var_34_1, "n_sort", true)
		if_set_visible(var_34_1, "n_sort_arti", false)
		if_set_visible(var_34_0, "btn_toggle_white", false)
		if_set_visible(var_34_0, "btn_toggle", true)
	end
	
	if arg_34_0.vars.is_artifact_only then
		arg_34_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
		arg_34_0.vars.filter_un_hash_tbl.element = nil
		arg_34_0.vars.filter_un_hash_tbl.star = nil
		arg_34_0.vars.filter_un_hash_tbl.role[7] = "no_role"
		
		if_set_visible(var_34_0, "n_toggle", false)
		
		local var_34_2 = var_34_0:getChildByName("n_toggle")
		
		if_set_visible(var_34_2, "n_sort", false)
		if_set_visible(var_34_2, "n_sort_arti", true)
		if_set_visible(var_34_0, "btn_toggle_white", false)
		if_set_visible(var_34_0, "btn_toggle", true)
	end
end

function SelectUnitUI.init(arg_35_0, arg_35_1)
	if arg_35_0.vars then
		return 
	end
	
	arg_35_0.vars = {}
	arg_35_0.vars.origin_data = arg_35_1
	
	BackButtonManager:push({
		check_id = "SelectUnitUI",
		back_func = function()
			arg_35_0:close()
		end
	})
	
	local var_35_0 = arg_35_0:makeDlg()
	local var_35_1, var_35_2 = DB("item_special", arg_35_1.item, {
		"name",
		"desc"
	})
	
	if arg_35_1.caller == "package_hero_select" then
		local var_35_3 = var_35_0:getChildByName("btn_choice_complete")
		
		if_set(var_35_3, "txt_label", T("ui_package_hero_select"))
	elseif arg_35_1.caller == "gacha_special" then
		var_35_1 = "ui_gacha_special_hero_select_title"
		var_35_2 = "ui_gacha_special_hero_select_info"
		
		local var_35_4 = var_35_0:getChildByName("btn_choice_complete")
		
		if_set(var_35_4, "txt_label", T("ui_package_hero_select"))
	elseif arg_35_1.caller == "gacha_customspecial" then
		if arg_35_0.vars.origin_data.select_idx % 2 == 1 then
			var_35_1 = "ui_ct_gachaspecial_5grade_title"
			var_35_2 = "ui_ct_gachaspecial_5grade_desc"
		else
			var_35_1 = "ui_ct_gachaspecial_4grade_title"
			var_35_2 = "ui_ct_gachaspecial_4grade_desc"
		end
		
		local var_35_5 = var_35_0:getChildByName("btn_choice_complete")
		
		if_set(var_35_5, "txt_label", T("ui_ct_gachaspecial_hero_select"))
	end
	
	if_set(var_35_0, "txt_title", T(var_35_1))
	if_set_visible(var_35_0, "btn_info", var_35_2 ~= nil)
	
	local var_35_6 = var_35_0:getChildByName("n_popup_disc")
	
	if get_cocos_refid(var_35_6) then
		var_35_6:setVisible(false)
		if_set(var_35_6, "t_disc", T(var_35_2))
		
		local var_35_7 = var_35_6:getChildByName("t_disc")
		
		if get_cocos_refid(var_35_7) then
			local var_35_8 = var_35_7:getStringNumLines()
			
			if to_n(var_35_8) > 8 then
				local var_35_9 = var_35_6:getChildByName("bg")
				local var_35_10 = var_35_9:getContentSize()
				
				var_35_9:setContentSize(var_35_10.width, var_35_10.height + 19 * (var_35_8 - 8))
			end
		end
	end
	
	if arg_35_1.ui_select_text_id then
		local var_35_11 = var_35_0:getChildByName("btn_choice_complete")
		
		if_set(var_35_11, "txt_label", T(arg_35_1.ui_select_text_id))
	end
	
	local var_35_12 = var_35_0:findChildByName("checkbox_g")
	
	var_35_12:setSelected(false)
	
	local var_35_13 = var_35_12:isSelected()
	
	arg_35_0:makeListView(arg_35_1, var_35_0, var_35_13)
	
	local var_35_14 = 0
	local var_35_15 = 0
	local var_35_16 = arg_35_0.vars.datas[1]
	
	for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.datas) do
		if arg_35_1.selected_id and arg_35_1.selected_id == iter_35_1.code then
			var_35_16 = iter_35_1
			var_35_16.default_select = true
		end
		
		if iter_35_1.type == "character" then
			var_35_14 = var_35_14 + 1
		elseif iter_35_1.type == "artifact" then
			var_35_15 = var_35_15 + 1
		end
	end
	
	arg_35_0.vars.is_unit_only = var_35_14 > 0 and var_35_15 == 0
	arg_35_0.vars.is_artifact_only = var_35_14 == 0 and var_35_15 > 0
	
	arg_35_0:setupFilter()
	arg_35_0:onSelectItem(var_35_16)
end

function SelectUnitUI.close(arg_37_0)
	BackButtonManager:pop("SelectUnitUI")
	HeroRecommend:close()
	
	if arg_37_0.vars and get_cocos_refid(arg_37_0.vars.dlg) then
		arg_37_0.vars.dlg:removeFromParent()
	end
	
	arg_37_0.vars = nil
end
