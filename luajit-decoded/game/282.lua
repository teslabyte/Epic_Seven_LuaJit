CollectionListBase = {}

function CollectionListBase._listViewV2Init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.vars.listView = ItemListView_v2:bindControl(arg_1_1)
	
	local var_1_0 = load_control("wnd/dict_item.csb")
	
	if arg_1_3.item_renderer_name then
		var_1_0 = load_control(arg_1_3.item_renderer_name)
	end
	
	arg_1_0.vars.listView:setRenderer(var_1_0, arg_1_2)
	
	arg_1_0.vars.show_earned_hero = true
	arg_1_0.vars.show_not_earned_hero = true
end

function CollectionListBase._groupViewInit(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.vars.listView = GroupListView:bindControl(arg_2_1)
	
	arg_2_0.vars.listView:setListViewCascadeOpacityEnabled(true)
	arg_2_0.vars.listView:setEnableMargin(true)
	
	local var_2_0 = load_control("wnd/dict_header.csb")
	local var_2_1 = {
		onUpdate = function(arg_3_0, arg_3_1, arg_3_2)
			if arg_3_2.id then
				local var_3_0, var_3_1 = DB("dic_ui", arg_3_2.id, {
					"name",
					"desc"
				})
				
				if_set(arg_3_1, "txt_name", T(var_3_0))
				if_set(arg_3_1, "txt_desc", T(var_3_1))
			else
				if_set(arg_3_1, "txt_name", arg_3_2)
			end
		end
	}
	local var_2_2 = load_control("wnd/dict_item.csb")
	
	if arg_2_3.item_renderer_name then
		var_2_2 = load_control(arg_2_3.item_renderer_name)
	end
	
	arg_2_0.vars.listView:setRenderer(var_2_0, var_2_2, var_2_1, arg_2_2)
	
	arg_2_0.vars.show_earned_hero = true
	arg_2_0.vars.show_not_earned_hero = true
end

function CollectionListBase.setCurrentDB(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars.current_db = arg_4_1
	arg_4_0.vars.current_id = arg_4_2
	arg_4_0.vars.render_db = nil
end

function CollectionListBase.getCurrentDB(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	return arg_5_0.vars.current_db
end

function CollectionListBase._scrollViewInit(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_5 = arg_6_5 or {}
	arg_6_4 = arg_6_4 or function(arg_7_0, arg_7_1)
		arg_6_0:setCurrentDB(arg_6_2[arg_7_1.item.id], arg_7_1.item.id)
		arg_6_0:updateList()
	end
	
	arg_6_1:setScrollViewForCollection(arg_6_2, arg_6_3, arg_6_4, arg_6_5.sort_order, arg_6_5.text_table, arg_6_5.icon_table)
	
	local var_6_0 = 1
	
	for iter_6_0, iter_6_1 in ipairs(arg_6_1.ScrollViewItems) do
		if iter_6_1.item.id == arg_6_5.parent_id then
			var_6_0 = iter_6_0
			
			break
		end
	end
	
	arg_6_1:setToIndex(var_6_0)
end

function CollectionListBase.listBaseInit(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	arg_8_7 = arg_8_7 or {}
	arg_8_0.vars.on_conflict_sort_bonus = arg_8_7.on_conflict_sort_bonus
	arg_8_0.vars.sort_func = arg_8_7.sort_func
	arg_8_0.vars.use_list_view = arg_8_7.use_list_view
	
	if arg_8_1 and arg_8_7.use_list_view then
		arg_8_0:_listViewV2Init(arg_8_1, arg_8_5, arg_8_7)
	elseif arg_8_1 then
		arg_8_0:_groupViewInit(arg_8_1, arg_8_5, arg_8_7)
	end
	
	if arg_8_2 then
		arg_8_0:_scrollViewInit(arg_8_2, arg_8_3, arg_8_4, arg_8_6, arg_8_7)
	end
end

function CollectionListBase._sortAtGroupData(arg_9_0, arg_9_1)
	if arg_9_0.vars.sort_func then
		table.sort(arg_9_1, arg_9_0.vars.sort_func)
	end
	
	return arg_9_1
end

function CollectionListBase._unit_list_view_update(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	if_set_visible(arg_10_1, "n_unit_card", true)
	if_set_visible(arg_10_1, "n_pet_card", false)
	if_set_visible(arg_10_1, "n_arti_card", false)
	
	local var_10_0, var_10_1, var_10_2, var_10_3, var_10_4, var_10_5, var_10_6 = DB("character", arg_10_2.id, {
		"face_id",
		"name",
		"ch_attribute",
		"moonlight",
		"role",
		"grade",
		"type"
	})
	
	arg_10_0:_setIconStar(arg_10_1, var_10_5)
	
	local var_10_7 = arg_10_1:getChildByName("txt_name")
	
	if get_cocos_refid(var_10_7) then
		local var_10_8 = get_word_wrapped_name(var_10_7, T(var_10_1))
		
		if_set_scale_fit_width_long_word(var_10_7, nil, var_10_8, 180)
		
		if arg_10_0.SHOW_CHAR_CODE then
			if_set_scale_fit_width_long_word(var_10_7, nil, var_10_8 .. "\n" .. arg_10_2.id, 180)
		end
	end
	
	local var_10_9 = Account:getCollectionUnit(arg_10_2.id)
	
	if not var_10_9 and not arg_10_3 then
		if_set_color(arg_10_1, nil, cc.c3b(136, 136, 136))
	end
	
	arg_10_0:_if_not_blank(arg_10_1, "role", "img/cm_icon_role_", var_10_4, ".png")
	
	local var_10_10 = "img/cm_icon_pro"
	
	if var_10_3 then
		var_10_10 = var_10_10 .. "m"
	end
	
	local var_10_11 = arg_10_4 and not var_10_9 and not CollectionUtil:isUnitUnlock(arg_10_2)
	
	arg_10_0:_if_not_blank(arg_10_1, "element", var_10_10, var_10_2, ".png")
	
	if var_10_11 then
		arg_10_0:_if_not_blank(arg_10_1, "face", "face/", "m0000", "_s.png")
		arg_10_0:_if_not_blank(arg_10_1, "face_bg", "img/", "_hero_s_bg_secret", ".png")
	else
		arg_10_0:_if_not_blank(arg_10_1, "face", "face/", var_10_0, "_s.png")
	end
	
	if_set_visible(arg_10_1, "role", not var_10_11)
	if_set_visible(arg_10_1, "element", not var_10_11)
	if_set_visible(arg_10_1, "star1", not var_10_11)
	
	if var_10_11 then
		if_set(var_10_7, nil, T("ui_dic_unknown"))
	end
	
	arg_10_0:_setMetadata(arg_10_1, "btn_select", arg_10_2.id, "unit", arg_10_2, var_10_11)
end

function CollectionListBase._addGroupForListView(arg_11_0, arg_11_1)
	if not arg_11_0.vars.list_view_data_source then
		arg_11_0.vars.list_view_data_source = {}
	end
	
	arg_11_1 = arg_11_0:_sortAtGroupData(arg_11_1)
	
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		table.insert(arg_11_0.vars.list_view_data_source, iter_11_1)
	end
end

function CollectionListBase.addGroupData(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0.vars.use_list_view then
		arg_12_0:_addGroupForListView(arg_12_2)
	else
		arg_12_2 = arg_12_0:_sortAtGroupData(arg_12_2)
		
		arg_12_0.vars.listView:addGroup({
			id = arg_12_1
		}, arg_12_2)
	end
end

function CollectionListBase.addGroupData_TextID(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0.vars.use_list_view then
		arg_13_0:_addGroupForListView(arg_13_2)
	else
		arg_13_2 = arg_13_0:_sortAtGroupData(arg_13_2)
		
		arg_13_0.vars.listView:addGroup(T(arg_13_1), arg_13_2)
	end
end

function CollectionListBase.finishAddGroupData(arg_14_0)
	if arg_14_0.vars.use_list_view then
		arg_14_0.vars.listView:setDataSource(arg_14_0.vars.list_view_data_source or {})
		
		arg_14_0.vars._data_source = arg_14_0.vars.list_view_data_source
		
		if arg_14_0.onUpdateList then
			arg_14_0:onUpdateList(table.count(arg_14_0.vars._data_source or {}))
		end
		
		arg_14_0.vars.list_view_data_source = nil
	end
end

function CollectionListBase.removeAllChildren(arg_15_0)
	arg_15_0.vars.listView:removeAllChildren()
end

function CollectionListBase.addTextKeys(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_2 or not arg_16_1 then
		return 
	end
	
	arg_16_0.vars.text_keys = arg_16_0.vars.text_keys or {}
	arg_16_0.vars.text_keys[arg_16_2] = arg_16_1
end

function CollectionListBase.getTextKeys(arg_17_0, arg_17_1)
	if not arg_17_0.vars.text_keys then
		return nil
	end
	
	return arg_17_0.vars.text_keys[arg_17_1]
end

function CollectionListBase.updateList(arg_18_0, arg_18_1)
	if not arg_18_0.vars.current_db then
		return 
	end
	
	local var_18_0 = {}
	local var_18_1 = 0
	local var_18_2 = -1
	local var_18_3 = arg_18_0:getTextKeys("default")
	
	if arg_18_1 then
		var_18_3 = {}
	end
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.current_db) do
		local var_18_4
		local var_18_5
		
		if type(iter_18_0) == "string" then
			local var_18_6
			
			var_18_4, var_18_6 = DB("dic_ui", iter_18_0, {
				"sort",
				"parent_id"
			})
			
			local var_18_7 = arg_18_0.vars.on_conflict_sort_bonus and arg_18_0.vars.on_conflict_sort_bonus[arg_18_0.vars.current_id]
			
			if var_18_7 then
				var_18_4 = var_18_4 + var_18_7[var_18_6]
				
				print("index", var_18_4)
			end
		else
			var_18_4 = iter_18_0
		end
		
		var_18_2 = math.max(var_18_2, var_18_4)
		
		for iter_18_2, iter_18_3 in pairs(iter_18_1) do
			if CollectionUtil:isCanShow(iter_18_3.id, arg_18_0.vars.db_type, arg_18_0.vars.show_earned_hero, arg_18_0.vars.show_not_earned_hero) then
				if not var_18_0[var_18_4] then
					var_18_0[var_18_4] = {}
				end
				
				table.insert(var_18_0[var_18_4], iter_18_3)
			end
		end
		
		if var_18_0[var_18_4] and var_18_3 and var_18_3[var_18_4] then
			var_18_0[var_18_4].data = var_18_3[var_18_4]
			var_18_1 = var_18_1 + 1
		elseif var_18_0[var_18_4] then
			var_18_0[var_18_4].key = iter_18_0
			var_18_1 = var_18_1 + 1
		end
	end
	
	arg_18_0:setListView(var_18_0, var_18_2)
	
	return var_18_1
end

function CollectionListBase._debug_show_char_code(arg_19_0)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_19_0.SHOW_CHAR_CODE = true
	
	arg_19_0:updateList()
end

function CollectionListBase.setResult(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = arg_20_4 or arg_20_0.vars.isAscending
	
	arg_20_0:removeAllChildren()
	
	if arg_20_0.vars.db_type == "p" or arg_20_0.vars.db_type == "m" then
		for iter_20_0 = arg_20_3, arg_20_2, -1 do
			if arg_20_1[iter_20_0] then
				arg_20_0:addGroupData_TextID(nil, arg_20_1[iter_20_0])
			end
		end
		
		arg_20_0:finishAddGroupData()
		
		return arg_20_1
	end
	
	local function var_20_1(arg_21_0, arg_21_1, arg_21_2)
		local var_21_0 = {}
		
		for iter_21_0 = arg_21_0, arg_21_1, arg_21_2 do
			if arg_20_1[iter_21_0] then
				for iter_21_1 = 1, #arg_20_1[iter_21_0] do
					table.insert(var_21_0, arg_20_1[iter_21_0][iter_21_1])
				end
			end
		end
		
		if #var_21_0 > 0 then
			arg_20_0:addGroupData_TextID(nil, var_21_0)
		end
		
		return var_21_0
	end
	
	if not var_20_0 then
		arg_20_1 = {
			var_20_1(arg_20_2, arg_20_3, 1)
		}
	else
		arg_20_1 = {
			var_20_1(arg_20_3, arg_20_2, -1)
		}
	end
	
	arg_20_0:finishAddGroupData()
	
	return arg_20_1
end

function CollectionListBase.setSearchResult(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if not arg_22_0.vars then
		return 
	end
	
	local var_22_0 = {}
	
	for iter_22_0, iter_22_1 in pairs(arg_22_2) do
		if not arg_22_3 or arg_22_3[iter_22_1] then
			local var_22_1 = DB("character", arg_22_1[iter_22_1].id, "grade") or DB("equip_item", arg_22_1[iter_22_1].id, "artifact_grade")
			
			var_22_1 = var_22_1 or 1
			
			if not var_22_0[var_22_1] then
				var_22_0[var_22_1] = {}
			end
			
			table.insert(var_22_0[var_22_1], arg_22_1[iter_22_1])
		end
	end
	
	if arg_22_0.vars.db_type == "p" or arg_22_0.vars.db_type == "m" then
		for iter_22_2, iter_22_3 in pairs(var_22_0) do
			arg_22_0:sortInnerTable(iter_22_3)
		end
	end
	
	return arg_22_0:setResult(var_22_0, 1, 5, arg_22_4)
end

function CollectionListBase.sortInnerTable(arg_23_0, arg_23_1)
	table.sort(arg_23_1, function(arg_24_0, arg_24_1)
		return to_n(string.match(arg_24_0.id, "%d+")) < to_n(string.match(arg_24_1.id, "%d+"))
	end)
end

function CollectionListBase.sortByName(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = "sortCache_name"
	local var_25_1 = arg_25_0.vars[var_25_0]
	
	if not var_25_1 then
		arg_25_0.vars[var_25_0] = {}
		arg_25_0.vars[var_25_0][1] = {}
		
		for iter_25_0, iter_25_1 in pairs(arg_25_1) do
			table.insert(arg_25_0.vars[var_25_0][1], iter_25_1.id)
		end
		
		table.sort(arg_25_0.vars[var_25_0][1], function(arg_26_0, arg_26_1)
			return arg_25_0:compareName(arg_26_0, arg_26_1)
		end)
		
		var_25_1 = arg_25_0.vars[var_25_0]
	end
	
	if not arg_25_0.vars[var_25_0] then
		print("SORT FAILED : Data Could`t Find : name")
		
		return 
	end
	
	if arg_25_4 then
		local var_25_2 = table.clone(var_25_1)
		
		table.reverse(var_25_2[1])
		
		var_25_1 = var_25_2
	end
	
	return arg_25_0:_setSortResult(arg_25_1, var_25_1, arg_25_0.vars.show_earned_hero, arg_25_0.vars.show_not_earned_hero, arg_25_2, arg_25_3)
end

function CollectionListBase.getSortName(arg_27_0, arg_27_1)
	if not arg_27_0.vars then
		local var_27_0 = DB("character", arg_27_1, "name")
		
		return Text and Text:getSortName(var_27_0) or T(var_27_0)
	end
	
	if not arg_27_0.vars.name_cache then
		arg_27_0.vars.name_cache = {}
	end
	
	if not arg_27_0.vars.name_cache[arg_27_1] then
		local var_27_1
		
		if arg_27_0.vars.db_type == "e" then
			var_27_1 = DB("equip_item", arg_27_1, "name")
		else
			var_27_1 = DB("character", arg_27_1, "name")
		end
		
		if not var_27_1 then
			return 
		end
		
		if Text then
			var_27_1 = Text:getSortName(var_27_1) or T(var_27_1)
		end
		
		arg_27_0.vars.name_cache[arg_27_1] = var_27_1
	end
	
	return arg_27_0.vars.name_cache[arg_27_1]
end

function CollectionListBase.compareName(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0:getSortName(arg_28_1) or ""
	local var_28_1 = arg_28_0:getSortName(arg_28_2) or ""
	
	if isLatinAccentLanguage() then
		return utf8LatinAccentCompare(var_28_0, var_28_1)
	end
	
	return string.lower(var_28_0) < string.lower(var_28_1)
end

function CollectionListBase._search(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	local var_29_0 = ""
	
	if arg_29_0.vars.mode then
		var_29_0 = arg_29_0.vars.mode
	end
	
	local var_29_1 = "searchCache_" .. arg_29_4 .. var_29_0
	
	local function var_29_2()
		arg_29_0.vars[var_29_1] = {}
		
		for iter_30_0, iter_30_1 in pairs(arg_29_1) do
			local var_30_0 = DB(arg_29_3, iter_30_0, arg_29_4)
			
			if arg_29_4 == "name" then
				var_30_0 = T(var_30_0)
			end
			
			if not arg_29_0.vars[var_29_1][var_30_0] then
				arg_29_0.vars[var_29_1][var_30_0] = {}
			end
			
			table.insert(arg_29_0.vars[var_29_1][var_30_0], iter_30_0)
		end
	end
	
	if not arg_29_0.vars[var_29_1] then
		var_29_2()
	end
	
	local var_29_3 = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0.vars[var_29_1]) do
		if string.match(iter_29_0, arg_29_2) then
			for iter_29_2, iter_29_3 in pairs(iter_29_1) do
				table.insert(var_29_3, iter_29_3)
			end
		end
	end
	
	if arg_29_6 then
		return var_29_3
	else
		return arg_29_0:setSearchResult(arg_29_1, var_29_3, arg_29_5, true)
	end
end

function CollectionListBase._setFilterList(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0.vars.column_cache then
		Log.e("self.vars.column_cache was nil.")
		
		return 
	end
	
	local var_31_0 = {}
	
	for iter_31_0, iter_31_1 in pairs(arg_31_2) do
		var_31_0[iter_31_0] = {}
		
		for iter_31_2, iter_31_3 in pairs(iter_31_1 or {}) do
			var_31_0[iter_31_0][iter_31_3] = true
		end
	end
	
	local var_31_1 = {}
	
	for iter_31_4, iter_31_5 in pairs(arg_31_1) do
		local var_31_2 = arg_31_0.vars.column_cache[iter_31_4]
		
		if not var_31_2 then
			Log.e("not column_table")
			
			return 
		end
		
		local var_31_3 = true
		
		for iter_31_6, iter_31_7 in pairs(var_31_2) do
			if var_31_0[iter_31_6] == nil or var_31_0[iter_31_6][iter_31_7] ~= true then
				var_31_3 = false
				
				break
			end
		end
		
		if var_31_3 then
			table.insert(var_31_1, iter_31_4)
		end
	end
	
	return arg_31_0:setSearchResult(arg_31_1, var_31_1, nil, true)
end

function CollectionListBase._makeFilterDB(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_0.vars.column_cache = {}
	
	for iter_32_0, iter_32_1 in pairs(arg_32_1) do
		arg_32_0.vars.column_cache[iter_32_0] = {}
		
		local var_32_0 = DBT(arg_32_2, iter_32_0, arg_32_3)
		
		arg_32_0.vars.column_cache[iter_32_0] = var_32_0
	end
end

function CollectionListBase._setSortResult(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = {}
	
	local function var_33_1(arg_34_0, arg_34_1)
		if arg_33_5 and not arg_33_5[arg_34_0] then
			return 
		end
		
		if not CollectionUtil:isCanShow(arg_34_0, arg_33_6, arg_33_3, arg_33_4) then
			return 
		end
		
		if not var_33_0[arg_34_1] then
			var_33_0[arg_34_1] = {}
		end
		
		table.insert(var_33_0[arg_34_1], arg_33_1[arg_34_0])
	end
	
	for iter_33_0 = 1, #arg_33_2 do
		for iter_33_1 = 1, #arg_33_2[iter_33_0] do
			var_33_1(arg_33_2[iter_33_0][iter_33_1], iter_33_0)
		end
	end
	
	local var_33_2 = 1
	
	for iter_33_2, iter_33_3 in pairs(var_33_0) do
		var_33_2 = math.max(var_33_2, iter_33_2)
	end
	
	return arg_33_0:setResult(var_33_0, 1, var_33_2, arg_33_7)
end

function CollectionListBase._sort(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
	local var_35_0 = "sortCache_" .. arg_35_2
	
	local function var_35_1()
		arg_35_0.vars[var_35_0] = {}
		
		for iter_36_0, iter_36_1 in pairs(arg_35_1) do
			local var_36_0 = iter_36_1[arg_35_2]
			
			if not var_36_0 then
				local var_36_1
				
				if arg_35_5 == "e" then
					var_36_1 = DB("equip_item", iter_36_1.id, arg_35_2)
				else
					var_36_1 = DB("character", iter_36_1.id, arg_35_2)
				end
				
				if not var_36_1 then
					arg_35_0.vars[var_35_0] = nil
					
					return 
				end
				
				var_36_0 = var_36_1
			end
			
			if not arg_35_0.vars[var_35_0][var_36_0] then
				arg_35_0.vars[var_35_0][var_36_0] = {}
			end
			
			table.insert(arg_35_0.vars[var_35_0][var_36_0], iter_36_1.id)
		end
		
		local var_36_2 = 1
		local var_36_3 = {}
		
		for iter_36_2, iter_36_3 in pairs(arg_35_0.vars[var_35_0]) do
			arg_35_0:sortInnerTable(iter_36_3)
			
			var_36_3[var_36_2] = iter_36_3
			var_36_3[var_36_2].comp_key = iter_36_2
			arg_35_0.vars[var_35_0][iter_36_2] = nil
			var_36_2 = var_36_2 + 1
		end
		
		arg_35_0.vars[var_35_0] = var_36_3
		
		table.sort(arg_35_0.vars[var_35_0], arg_35_3)
	end
	
	local var_35_2 = arg_35_0.vars[var_35_0]
	
	if not var_35_2 then
		var_35_1()
		
		if not arg_35_0.vars[var_35_0] then
			print("SORT FAILED : Data Could`t Find : ", arg_35_2)
			
			return 
		end
		
		var_35_2 = arg_35_0.vars[var_35_0]
	end
	
	return arg_35_0:_setSortResult(arg_35_1, var_35_2, arg_35_0.vars.show_earned_hero, arg_35_0.vars.show_not_earned_hero, arg_35_4, arg_35_5, arg_35_6)
end

function CollectionListBase.setListView(arg_37_0, arg_37_1, arg_37_2)
	arg_37_0:removeAllChildren()
	
	local function var_37_0(arg_38_0)
		if arg_37_1[arg_38_0] then
			if arg_37_1[arg_38_0].key then
				local var_38_0 = arg_37_1[arg_38_0].key
				
				arg_37_1[arg_38_0].key = nil
				
				arg_37_0:addGroupData(var_38_0, arg_37_1[arg_38_0])
			elseif arg_37_1[arg_38_0].data then
				local var_38_1 = arg_37_1[arg_38_0].data
				
				arg_37_1[arg_38_0].data = nil
				
				arg_37_0:addGroupData_TextID(var_38_1, arg_37_1[arg_38_0])
			end
		end
	end
	
	if arg_37_0.vars.isAscending then
		for iter_37_0 = arg_37_2, 1, -1 do
			var_37_0(iter_37_0)
		end
	else
		for iter_37_1 = 1, arg_37_2 do
			var_37_0(iter_37_1)
		end
	end
	
	arg_37_0:finishAddGroupData()
end

function CollectionListBase.close(arg_39_0)
	arg_39_0.vars = nil
end

function CollectionListBase.makeParentDB(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5)
	if not arg_40_1 then
		return 
	end
	
	arg_40_5 = arg_40_5 or {}
	
	local var_40_0 = arg_40_5.make_all_db
	local var_40_1 = arg_40_5.all_db_name or "all"
	
	for iter_40_0, iter_40_1 in pairs(arg_40_1) do
		local var_40_2 = DB("dic_ui", iter_40_0, "parent_id")
		
		CollectionUtil:make_tbl_key(arg_40_2, var_40_2, iter_40_0, iter_40_1)
		
		if var_40_0 then
			CollectionUtil:make_tbl_key(arg_40_2, var_40_1, iter_40_0, iter_40_1)
		end
		
		CollectionUtil:setCountDB(arg_40_3, var_40_2, arg_40_2[var_40_2][iter_40_0], arg_40_4)
		
		if var_40_0 then
			CollectionUtil:setCountDB(arg_40_3, var_40_1, arg_40_2[var_40_1][iter_40_0], arg_40_4)
		end
	end
end

function CollectionListBase._setIconStar(arg_41_0, arg_41_1, arg_41_2)
	if_set_visible(arg_41_1, "star" .. arg_41_2 + 1, false)
	
	local var_41_0 = arg_41_1:getChildByName("star1")
	
	if not var_41_0.origin_pos_x then
		var_41_0.origin_pos_x = var_41_0:getPositionX()
	end
	
	var_41_0:setPositionX(var_41_0.origin_pos_x + (5 - arg_41_2) * 10)
end

function CollectionListBase._if_not_blank(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	local var_42_0
	
	if arg_42_3 and not arg_42_4 and not arg_42_5 then
		var_42_0 = arg_42_3
	else
		var_42_0 = arg_42_4 and arg_42_3 .. arg_42_4 .. arg_42_5 or "img/_blank.png"
	end
	
	if_set_sprite(arg_42_1, arg_42_2, var_42_0)
end

function CollectionListBase._setMetadata(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	local var_43_0 = arg_43_1:getChildByName(arg_43_2)
	
	var_43_0.info = {}
	var_43_0.info.id = arg_43_3
	var_43_0.info.type = arg_43_4
	var_43_0.info.data = arg_43_5
	var_43_0.info.isCanShow = not arg_43_6
	var_43_0.info.unlock_msg = arg_43_5.locked_msg
end

function CollectionListBase.setShowEarnedHero(arg_44_0, arg_44_1)
	arg_44_0.vars.show_earned_hero = arg_44_1
end

function CollectionListBase.setShowNotEarnedHero(arg_45_0, arg_45_1)
	arg_45_0.vars.show_not_earned_hero = arg_45_1
end

function CollectionListBase.getShowEarnedHero(arg_46_0)
	return arg_46_0.vars.show_earned_hero
end

function CollectionListBase.getShowNotEarnedHero(arg_47_0)
	return arg_47_0.vars.show_not_earned_hero
end

function CollectionListBase.setAscending(arg_48_0, arg_48_1)
	if arg_48_1 == "up" then
		arg_48_0.vars.isAscending = true
	else
		arg_48_0.vars.isAscending = false
	end
end
