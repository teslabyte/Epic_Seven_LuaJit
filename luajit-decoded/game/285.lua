CollectionArtifactList = {}

copy_functions(CollectionListBase, CollectionArtifactList)

function CollectionArtifactList.makeRoleDB(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_2 then
		arg_1_2.all = {}
		
		for iter_1_0, iter_1_1 in pairs(arg_1_1) do
			local var_1_0, var_1_1 = DB("equip_item", iter_1_1.id, {
				"role",
				"artifact_grade"
			})
			
			iter_1_1.role = iter_1_1.role or var_1_0
			
			if iter_1_1.role == nil then
				iter_1_1.role = "share"
			end
			
			if not arg_1_2[iter_1_1.role] then
				arg_1_2[iter_1_1.role] = {}
			end
			
			CollectionUtil:make_tbl(arg_1_2[iter_1_1.role], var_1_1, iter_1_1)
			CollectionUtil:make_tbl(arg_1_2.all, var_1_1, iter_1_1)
		end
		
		for iter_1_2, iter_1_3 in pairs(arg_1_2) do
			for iter_1_4, iter_1_5 in pairs(iter_1_3) do
				CollectionUtil:setCountDB(arg_1_3, iter_1_2, arg_1_2[iter_1_2][iter_1_4], arg_1_4)
			end
		end
	end
end

function CollectionArtifactList.resort(arg_2_0)
	arg_2_0:sort(arg_2_0.vars.sort_column, arg_2_0.vars.show_earned_hero, arg_2_0.vars.show_not_earned_hero)
end

function CollectionArtifactList.onItemUpdate(arg_3_0, arg_3_1, arg_3_2)
	if_set_visible(arg_3_1, "n_unit_card", false)
	if_set_visible(arg_3_1, "n_arti_card", true)
	
	local var_3_0, var_3_1, var_3_2, var_3_3 = DB("equip_item", arg_3_2.id, {
		"name",
		"role",
		"artifact_grade",
		"icon"
	})
	local var_3_4 = arg_3_1:getChildByName("n_arti_card")
	local var_3_5 = not CollectionUtil:isArtifactUnlock(arg_3_2)
	local var_3_6 = var_3_4:getChildByName("txt_name")
	
	if not get_cocos_refid(var_3_6) then
		return 
	end
	
	if var_3_5 then
		var_3_0 = "ui_dic_unknown"
		
		if_set_visible(var_3_4, "role", false)
		arg_3_0:_if_not_blank(var_3_4, "icon", "item_arti/icon_art0000.png")
		arg_3_0:_setIconStar(var_3_4, 0)
	else
		arg_3_0:_if_not_blank(var_3_4, "role", "img/cm_icon_role_", var_3_1, ".png")
		arg_3_0:_if_not_blank(var_3_4, "icon", "item_arti/", var_3_3, ".png")
		arg_3_0:_setIconStar(var_3_4, var_3_2)
	end
	
	local var_3_7 = get_word_wrapped_name(var_3_6, T(var_3_0))
	
	if_set_scale_fit_width_long_word(var_3_6, nil, var_3_7, 180)
	
	if not Account:getCollectionEquip(arg_3_2.id) then
		if_set_color(arg_3_1, nil, cc.c3b(136, 136, 136))
	end
	
	arg_3_0:_setMetadata(arg_3_1, "btn_select", arg_3_2.id, "artifact", arg_3_2, var_3_5)
	
	if arg_3_0.SHOW_CHAR_CODE then
		if_set_scale_fit_width_long_word(var_3_6, nil, var_3_7 .. "\n" .. arg_3_2.id, 180)
	end
end

function CollectionArtifactList.init(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars = {}
	arg_4_0.vars.artifact_pure_DB = arg_4_2
	arg_4_0.vars.artifact_DB = {}
	arg_4_0.vars.artifact_count_DB = {}
	arg_4_0.vars.artifact_role_DB = {}
	arg_4_0.vars.sort_order = {}
	arg_4_0.vars.sort_order.artifact_grade = CollectionUtil.GRADE_SORT_ORDER
	arg_4_0.vars.sort_order.role = CollectionUtil.ROLE_SORT_ORDER
	
	arg_4_0:resetSortOption()
	
	arg_4_0.vars.comp_key_to_data_string = {}
	
	for iter_4_0, iter_4_1 in pairs(CollectionUtil.ROLE_COMP_TO_KEY_DATA_STRING) do
		arg_4_0.vars.comp_key_to_data_string[iter_4_0] = iter_4_1
	end
	
	arg_4_0.vars.comp_key_to_data_string.all = "dic_ui_check_allartifact"
	arg_4_0.vars.comp_key_to_data_icon = CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON
	
	arg_4_0:makeRoleDB(arg_4_0.vars.artifact_pure_DB, arg_4_0.vars.artifact_role_DB, arg_4_0.vars.artifact_count_DB, function(arg_5_0)
		return Account:getCollectionEquip(arg_5_0.id)
	end)
	arg_4_0:makeParentDB(arg_4_1, arg_4_0.vars.artifact_DB, arg_4_0.vars.artifact_count_DB, function(arg_6_0)
		return Account:getCollectionEquip(arg_6_0.id)
	end)
	arg_4_0:_makeFilterDB()
end

function CollectionArtifactList.resetSortMode(arg_7_0, arg_7_1)
	if arg_7_1 == "all" then
		arg_7_0.vars.isAscending = true
		arg_7_0.vars.sort_mode = "all"
		
		arg_7_0.vars.scrollview:setScrollViewForCollection(arg_7_0.vars.artifact_role_DB, arg_7_0.vars.artifact_count_DB, function(arg_8_0, arg_8_1, arg_8_2)
			arg_7_0:setCurrentDB(arg_7_0.vars.artifact_role_DB[arg_8_1.item.id], arg_8_1.item.id)
			arg_7_0:updateList()
			arg_7_0:resetSortOption()
			arg_7_0:resort()
			CollectionMainUI:onChangeRole(arg_8_1.item.id)
		end, arg_7_0.vars.sort_order.role, arg_7_0.vars.comp_key_to_data_string, arg_7_0.vars.comp_key_to_data_icon)
		arg_7_0.vars.scrollview:setToIndex(1)
	else
		arg_7_0.vars.isAscending = false
		arg_7_0.vars.sort_mode = "hero"
		
		arg_7_0.vars.scrollview:setScrollViewForCollection(arg_7_0.vars.artifact_DB, arg_7_0.vars.artifact_count_DB, function(arg_9_0, arg_9_1, arg_9_2)
			arg_7_0.vars.last_search_keyword = nil
			
			arg_7_0:setCurrentDB(arg_7_0.vars.artifact_DB[arg_9_1.item.id], arg_9_1.item.id)
			arg_7_0:updateList(true)
		end)
		arg_7_0:resetSortOption()
		
		arg_7_0.vars.isAscending = false
		
		arg_7_0.vars.scrollview:setToIndex(1)
	end
end

function CollectionArtifactList.open(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.vars then
		return 
	end
	
	local var_10_0 = {
		onUpdate = function(arg_11_0, arg_11_1, arg_11_2)
			arg_10_0:onItemUpdate(arg_11_1, arg_11_2)
		end
	}
	
	arg_10_0.vars.scrollview = arg_10_2
	
	arg_10_0:resetSortOption()
	arg_10_0:listBaseInit(arg_10_1, arg_10_2, arg_10_0.vars.artifact_role_DB, arg_10_0.vars.artifact_count_DB, var_10_0, nil, {
		sort_order = arg_10_0.vars.sort_order.role,
		text_table = arg_10_0.vars.comp_key_to_data_string,
		icon_table = arg_10_0.vars.comp_key_to_data_icon
	})
	
	arg_10_0.vars.db_type = "e"
end

function CollectionArtifactList.getPureDB(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		return 
	end
	
	if not arg_12_0.vars.artifact_pure_DB then
		Log.e("PURE DB Was NIL")
		
		return 
	end
	
	return arg_12_0.vars.artifact_pure_DB
end

function CollectionArtifactList.search(arg_13_0, arg_13_1)
	if arg_13_1 == nil or arg_13_1 == "" then
		return false
	end
	
	local var_13_0 = arg_13_0:getPureDB()
	local var_13_1 = arg_13_0:_search(var_13_0, arg_13_1, "equip_item", "name", nil)
	
	arg_13_0:setCurrentDB(var_13_1)
	arg_13_0:applyFilter()
	
	return var_13_1
end

function CollectionArtifactList.sortInnerTable(arg_14_0, arg_14_1)
	table.sort(arg_14_1, function(arg_15_0, arg_15_1)
		local var_15_0 = arg_14_0.vars.sort_order.artifact_grade
		local var_15_1 = DB("equip_item", arg_15_0, "artifact_grade")
		local var_15_2 = DB("equip_item", arg_15_1, "artifact_grade")
		
		if var_15_1 ~= var_15_2 then
			return var_15_0[var_15_1] < var_15_0[var_15_2]
		end
		
		local var_15_3 = arg_14_0.vars.sort_order.role
		local var_15_4 = DB("equip_item", arg_15_0, "role") or "share"
		local var_15_5 = DB("equip_item", arg_15_1, "role") or "share"
		
		if var_15_4 ~= var_15_5 then
			return var_15_3[var_15_4] < var_15_3[var_15_5]
		end
		
		return arg_14_0:compareName(arg_15_0, arg_15_1)
	end)
end

function CollectionArtifactList.sort(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = {}
	
	arg_16_0.vars.show_earned_hero = arg_16_2
	arg_16_0.vars.show_not_earned_hero = arg_16_3
	arg_16_0.vars.sort_column = arg_16_1
	
	local var_16_1 = arg_16_0.vars.render_db or arg_16_0.vars.current_db
	
	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		for iter_16_2, iter_16_3 in pairs(var_16_1[iter_16_0]) do
			var_16_0[iter_16_3.id] = iter_16_3.id
		end
	end
	
	if arg_16_1 == "name" then
		return arg_16_0:sortByName(arg_16_0.vars.artifact_pure_DB, var_16_0, arg_16_0.vars.db_type, not arg_16_0.vars.isAscending)
	end
	
	local var_16_2 = arg_16_0.vars.sort_order[arg_16_1]
	
	return arg_16_0:_sort(arg_16_0.vars.artifact_pure_DB, arg_16_1, function(arg_17_0, arg_17_1)
		return var_16_2[arg_17_0.comp_key] > var_16_2[arg_17_1.comp_key]
	end, var_16_0, arg_16_0.vars.db_type)
end

function CollectionArtifactList.resetSortOption(arg_18_0)
	arg_18_0.vars.show_earned_hero = true
	arg_18_0.vars.show_not_earned_hero = true
	arg_18_0.vars.sort_column = "artifact_grade"
	arg_18_0.vars.isAscending = true
	
	arg_18_0:resetFilter()
end

function CollectionArtifactList.resetFilter(arg_19_0)
	local var_19_0 = {
		"star",
		"role"
	}
	
	arg_19_0.vars.filters = {}
	
	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		arg_19_0.vars.filters[iter_19_1] = {}
	end
end

function CollectionArtifactList.setFilter(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	arg_20_0.vars.filters[arg_20_1][arg_20_2] = arg_20_3 or nil
end

function CollectionArtifactList.getFilter(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_2 then
		return arg_21_0.vars.filters[arg_21_1]
	end
	
	return arg_21_0.vars.filters[arg_21_1] and arg_21_0.vars.filters[arg_21_1][arg_21_2] == true
end

function CollectionArtifactList.isFiltering(arg_22_0, arg_22_1)
	if arg_22_1 then
		return table.count(arg_22_0.vars.filters[arg_22_1]) ~= 0
	end
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.filters) do
		if table.count(iter_22_1) ~= 0 then
			return true
		end
	end
	
	return not arg_22_0.vars.show_not_earned_hero or not arg_22_0.vars.show_earned_hero
end

function CollectionArtifactList.getFilterLength(arg_23_0, arg_23_1)
	return ({
		star = 5,
		role = 7
	})[arg_23_1]
end

function CollectionArtifactList.applyFilter(arg_24_0)
	local var_24_0 = {
		star = "artifact_grade",
		role = "role"
	}
	local var_24_1 = {
		star = {
			5,
			4,
			3,
			2,
			1
		},
		role = CollectionUtil.ARTI_ROLE_UNHASH_TABLE
	}
	local var_24_2 = {}
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.filters) do
		var_24_2[var_24_0[iter_24_0]] = {}
		
		if arg_24_0:isFiltering(iter_24_0) then
			for iter_24_2, iter_24_3 in pairs(iter_24_1) do
				if iter_24_3 == true then
					table.insert(var_24_2[var_24_0[iter_24_0]], var_24_1[iter_24_0][iter_24_2])
				end
			end
		else
			for iter_24_4, iter_24_5 in pairs(var_24_1[iter_24_0]) do
				table.insert(var_24_2[var_24_0[iter_24_0]], iter_24_5)
			end
		end
	end
	
	local var_24_3 = {}
	
	for iter_24_6, iter_24_7 in pairs(arg_24_0.vars.current_db) do
		for iter_24_8, iter_24_9 in pairs(arg_24_0.vars.current_db[iter_24_6]) do
			var_24_3[iter_24_9.id] = iter_24_9
		end
	end
	
	arg_24_0.vars.render_db = arg_24_0:_setFilterList(var_24_3, var_24_2)
	
	arg_24_0:resort()
end

function CollectionArtifactList._makeFilterDB(arg_25_0)
	arg_25_0.vars.column_cache = {}
	
	local var_25_0 = arg_25_0.vars.artifact_pure_DB
	
	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		arg_25_0.vars.column_cache[iter_25_0] = {}
		
		local var_25_1, var_25_2 = DB("equip_item", iter_25_0, {
			"role",
			"artifact_grade"
		})
		
		arg_25_0.vars.column_cache[iter_25_0] = {
			role = var_25_1 or "share",
			artifact_grade = var_25_2
		}
	end
end
