CollectionUnitList = {}

copy_functions(CollectionListBase, CollectionUnitList)

function CollectionUnitList.makeRoleDB(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_2 then
		arg_1_2.all = {}
		
		for iter_1_0, iter_1_1 in pairs(arg_1_1) do
			if not arg_1_2[iter_1_1.role] then
				arg_1_2[iter_1_1.role] = {}
			end
			
			CollectionUtil:setCountDB(arg_1_3, "all", {
				iter_1_1
			}, arg_1_4)
			CollectionUtil:setCountDB(arg_1_3, iter_1_1.role, {
				iter_1_1
			}, arg_1_4)
		end
	end
end

function CollectionUnitList.sortStoryDB(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		for iter_2_2, iter_2_3 in pairs(iter_2_1) do
			table.sort(iter_2_3, function(arg_3_0, arg_3_1)
				local var_3_0 = DB("dic_data", arg_3_0.id, "sort_first") == "y"
				local var_3_1 = DB("dic_data", arg_3_1.id, "sort_first") == "y"
				local var_3_2 = DB("character", arg_3_0.id, "grade") or 1
				local var_3_3 = DB("character", arg_3_1.id, "grade") or 1
				
				if var_3_0 == var_3_1 then
					return var_3_3 < var_3_2
				else
					return var_3_0
				end
			end)
		end
	end
end

function CollectionUnitList.onItemUpdate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_unit_list_view_update(arg_4_1, arg_4_2, nil, true)
end

function CollectionUnitList.open(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if not arg_5_0.vars then
		return 
	end
	
	arg_5_0.vars.mode = arg_5_3.mode
	arg_5_0.vars.sort_mode = "story"
	arg_5_0.vars.isAscending = false
	
	CollectionUnitList.Sorter:init(CollectionMainUI:getSortUI())
	
	local var_5_0 = {
		onUpdate = function(arg_6_0, arg_6_1, arg_6_2)
			arg_5_0:onItemUpdate(arg_6_1, arg_6_2)
		end
	}
	local var_5_1
	local var_5_2
	local var_5_3
	local var_5_4 = arg_5_0.vars.character.story_DB
	local var_5_5 = arg_5_0.vars.character.count_db
	
	arg_5_0.vars.db_type = "c"
	
	arg_5_0:resetSortOption()
	arg_5_0:listBaseInit(arg_5_1, arg_5_2, var_5_4, var_5_5, var_5_0)
	
	arg_5_0.vars.scrollview = arg_5_2
	
	ConditionContentsManager:dispatch("collection.get", {
		force_type = "character"
	})
end

function CollectionUnitList.init(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.vars = {}
	arg_7_0.vars.character = {}
	arg_7_0.vars.character.pure_DB = arg_7_2
	
	arg_7_0:initCharacterDB(arg_7_1)
	
	arg_7_0.vars.sort_order = {}
	arg_7_0.vars.sort_order.role = CollectionUtil.ROLE_SORT_ORDER
	
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in pairs(CollectionUtil.ROLE_COMP_TO_KEY_DATA_STRING) do
		var_7_0[iter_7_0] = iter_7_1
	end
	
	var_7_0.all = "ui_hero_role_all"
	
	arg_7_0:resetSortOption()
	
	arg_7_0.vars.comp_key_to_data = {}
	arg_7_0.vars.comp_key_to_data.role = var_7_0
	arg_7_0.vars.comp_key_to_data.icon = CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON
end

function CollectionUnitList.resetSortOption(arg_8_0)
	arg_8_0.vars.show_earned_hero = true
	arg_8_0.vars.show_not_earned_hero = true
end

function CollectionUnitList.initCharacterDB(arg_9_0, arg_9_1)
	arg_9_0.vars.character.story_DB = {}
	arg_9_0.vars.character.role_DB = {}
	arg_9_0.vars.character.count_db = {}
	
	local function var_9_0(arg_10_0)
		return Account:getCollectionUnit(arg_10_0.id)
	end
	
	arg_9_0:makeRoleDB(arg_9_0.vars.character.pure_DB, arg_9_0.vars.character.role_DB, arg_9_0.vars.character.count_db, function(arg_11_0)
		return Account:getCollectionUnit(arg_11_0.id)
	end)
	arg_9_0:makeParentDB(arg_9_1, arg_9_0.vars.character.story_DB, arg_9_0.vars.character.count_db, var_9_0)
	arg_9_0:sortStoryDB(arg_9_0.vars.character.story_DB)
	arg_9_0:removeExceptUnit(arg_9_0.vars.character.story_DB, arg_9_0.vars.character.count_db, var_9_0)
end

function CollectionUnitList.removeExceptUnit(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not IS_PUBLISHER_ZLONG then
		return 
	end
	
	local var_12_0 = {
		"c5082",
		"c5149"
	}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		for iter_12_2, iter_12_3 in pairs(iter_12_1) do
			for iter_12_4 = #iter_12_3, 1, -1 do
				local var_12_1 = iter_12_3[iter_12_4].id
				
				if table.isInclude(var_12_0, var_12_1) then
					table.remove(iter_12_3, iter_12_4)
					
					if arg_12_3 and arg_12_3(var_12_1) then
						arg_12_2[iter_12_0].have_count = arg_12_2[iter_12_0].have_count - 1
					end
					
					arg_12_2[iter_12_0].max_count = arg_12_2[iter_12_0].max_count - 1
				end
			end
		end
	end
end

function CollectionUnitList.getPureDB(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if not arg_13_0.vars.character.pure_DB then
		Log.e("PURE DB Was NIL")
		
		return 
	end
	
	return arg_13_0.vars.character.pure_DB
end

function CollectionUnitList.resetSortMode(arg_14_0, arg_14_1)
	if arg_14_1 == "all" then
		arg_14_0.vars.sort_mode = "all"
		
		arg_14_0.vars.scrollview:setScrollViewForCollection(arg_14_0.vars.character.role_DB, arg_14_0.vars.character.count_db, function(arg_15_0, arg_15_1, arg_15_2)
			arg_14_0:resetSortOption()
			CollectionUnitList.Sorter:selectRole(arg_15_1.item.id)
		end, arg_14_0.vars.sort_order.role, arg_14_0.vars.comp_key_to_data.role, arg_14_0.vars.comp_key_to_data.icon)
		arg_14_0:resetSortOption()
		arg_14_0.vars.scrollview:setToIndex(1)
	else
		arg_14_0.vars.sort_mode = "hero"
		
		arg_14_0.vars.scrollview:setScrollViewForCollection(arg_14_0.vars.character.story_DB, arg_14_0.vars.character.count_db, function(arg_16_0, arg_16_1, arg_16_2)
			arg_14_0:setCurrentDB(arg_14_0.vars.character.story_DB[arg_16_1.item.id])
			arg_14_0:updateList()
		end)
		arg_14_0:resetSortOption()
		
		arg_14_0.vars.isAscending = false
		
		arg_14_0.vars.scrollview:setToIndex(1)
	end
end

function CollectionUnitList.getSceneStateInfo(arg_17_0)
	if not arg_17_0.vars or not arg_17_0.vars.scrollview then
		return 
	end
	
	return {
		page = arg_17_0.vars.scrollview:getIndex(),
		search_keyword = CollectionUnitList.Sorter:getSearchKeyword()
	}
end

function CollectionUnitList.search(arg_18_0, arg_18_1)
	if arg_18_1 == nil or arg_18_1 == "" then
		return false
	end
	
	return CollectionUnitList.Sorter:search(arg_18_1)
end

function CollectionUnitList.close(arg_19_0)
	CollectionUnitList.Sorter:close()
	
	arg_19_0.vars = nil
end

CollectionUnitList.Sorter = {}
CollectionUnitList.Sorter.ORDER_TABLE = {
	"Grade",
	"Color",
	"Role",
	"Name"
}
CollectionUnitList.Sorter.ORDER_UNHASH_TABLE = {
	Role = 3,
	Grade = 1,
	Name = 4,
	Color = 2
}

function CollectionUnitList.Sorter.show(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not arg_20_0.vars.sorter then
		return 
	end
	
	arg_20_0.vars.sorter:show(arg_20_1)
end

function CollectionUnitList.Sorter.init(arg_21_0, arg_21_1)
	if arg_21_0.vars then
		return 
	end
	
	arg_21_0.vars = {}
	arg_21_0.vars.dict_base = CollectionMainUI:getDictionaryBase()
	
	local var_21_0 = {}
	
	var_21_0.sorting_unit = true
	var_21_0.dict_mode = true
	var_21_0.btn_toggle_box = true
	arg_21_0.vars.sorter = Sorter:create(arg_21_1, var_21_0)
	arg_21_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_21_0.vars.filter_un_hash_tbl.star = {
		5,
		4,
		all = "all",
		[3] = 3
	}
	arg_21_0.vars.filters = {}
	
	arg_21_0:setFilterValue()
	
	arg_21_0.vars.sorters = {
		{
			key = "Grade",
			name = T("ui_unit_list_sort_1_label"),
			func = arg_21_0:makeSortFunc("Grade")
		},
		{
			key = "Color",
			name = T("ui_unit_list_sort_3_label"),
			func = arg_21_0:makeSortFunc("Color")
		},
		{
			key = "Role",
			name = T("ui_unit_list_sort_6_label"),
			func = arg_21_0:makeSortFunc("Role")
		},
		{
			key = "Name",
			name = T("ui_unit_list_sort_7_label"),
			func = arg_21_0:makeSortFunc("Name")
		}
	}
	arg_21_0.vars.sort_index = 1
	
	arg_21_0.vars.sorter:setSorter({
		default_sort_index = arg_21_0.vars.sort_index,
		menus = arg_21_0.vars.sorters,
		filters = arg_21_0:getFilterTable(),
		checkboxs = arg_21_0:getCheckbox(),
		callback_sort = function(arg_22_0, arg_22_1, arg_22_2)
			arg_21_0:updateListView()
			
			arg_21_0.vars.sort_index = arg_22_1
			
			arg_21_0:updateUI()
		end,
		callback_checkbox = function(arg_23_0, arg_23_1, arg_23_2)
			if arg_23_0 == "show_earned_hero" then
				CollectionUnitList:setShowEarnedHero(arg_23_2)
			elseif arg_23_0 == "show_not_earned_hero" then
				CollectionUnitList:setShowNotEarnedHero(arg_23_2)
			end
			
			arg_21_0:resetData()
		end,
		callback_on_add_filter = function(arg_24_0, arg_24_1, arg_24_2)
			arg_21_0:addFilter(arg_24_0, arg_24_1, arg_24_2)
		end,
		callback_on_commit_filter = function()
			arg_21_0:resetData()
		end,
		resetDataByCall = function()
			arg_21_0:resetData()
		end,
		callback_filter = function(arg_27_0, arg_27_1, arg_27_2)
			arg_21_0:addFilter(arg_27_0, arg_27_1, arg_27_2)
			arg_21_0:resetData()
		end
	})
	arg_21_0.vars.sorter:starUIDictMode(5, 3)
	arg_21_0.vars.sorter:roleUIDictMode()
	
	arg_21_0.vars.wnd = arg_21_0.vars.sorter:getWnd()
	
	local var_21_1 = arg_21_0.vars.wnd:getChildByName("btn_toggle_box")
	local var_21_2 = arg_21_0.vars.wnd:getChildByName("btn_toggle_box_active")
	
	var_21_1:removeFromParent()
	var_21_2:removeFromParent()
end

function CollectionUnitList.Sorter.getFilterCheckList(arg_28_0, arg_28_1)
	return ItemFilterUtil:getFilterCheckList(arg_28_0.vars.filter_un_hash_tbl, arg_28_1)
end

function CollectionUnitList.Sorter.addFilter(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if not arg_29_0.vars.filter_un_hash_tbl[arg_29_1][arg_29_2] then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.filter_un_hash_tbl[arg_29_1][arg_29_2]
	
	arg_29_0.vars.filters[arg_29_1][var_29_0] = arg_29_3
end

function CollectionUnitList.Sorter.checkFilterValue(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_1.grade
	
	if not arg_30_2.star[var_30_0] then
		return false
	end
	
	local var_30_1 = arg_30_1.role
	
	if not arg_30_2.role[var_30_1] then
		return false
	end
	
	local var_30_2 = arg_30_1.ch_attribute
	
	if not arg_30_2.element[var_30_2] then
		return false
	end
	
	return true
end

function CollectionUnitList.Sorter.setFilterValue(arg_31_0)
	local var_31_0 = {
		"star",
		"role",
		"element",
		"skill"
	}
	
	for iter_31_0, iter_31_1 in pairs(var_31_0) do
		arg_31_0.vars.filters[iter_31_1] = {}
		
		for iter_31_2 = 1, 10 do
			local var_31_1 = arg_31_0.vars.filter_un_hash_tbl[iter_31_1][iter_31_2]
			
			if not var_31_1 then
				break
			end
			
			arg_31_0.vars.filters[iter_31_1][var_31_1] = true
		end
	end
end

function CollectionUnitList.Sorter.getCheckbox(arg_32_0)
	return {
		{
			is_filter = true,
			id = "show_earned_hero",
			default_flag = true,
			name = T("dict_have_hero"),
			checked = CollectionUnitList:getShowEarnedHero()
		},
		{
			is_filter = true,
			id = "show_not_earned_hero",
			default_flag = true,
			name = T("dict_none_hero"),
			checked = CollectionUnitList:getShowNotEarnedHero()
		}
	}
end

function CollectionUnitList.Sorter.selectRole(arg_33_0, arg_33_1)
	arg_33_0:clearSetting()
	
	arg_33_0.vars.selected_role = arg_33_1
	
	local var_33_0
	
	if arg_33_1 ~= "all" then
		var_33_0 = arg_33_0.vars.filters.role
		
		for iter_33_0, iter_33_1 in pairs(var_33_0) do
			var_33_0[iter_33_0] = iter_33_0 == arg_33_1
		end
	end
	
	arg_33_0:resetData()
end

function CollectionUnitList.Sorter.clearSetting(arg_34_0)
	arg_34_0.vars.search_keyword = nil
	
	arg_34_0.vars.sorter:sort(1)
	arg_34_0.vars.sorter:setFilters(arg_34_0:getFilterTable())
	arg_34_0.vars.sorter:getSkillFilter():setFilterSetting()
	arg_34_0.vars.sorter:updateBuffUI()
	arg_34_0:setFilterValue()
end

function CollectionUnitList.Sorter.resetData(arg_35_0)
	if not arg_35_0.vars or not arg_35_0.vars.sorter then
		return 
	end
	
	local var_35_0 = CollectionUnitList:getPureDB() or {}
	local var_35_1 = {}
	local var_35_2 = arg_35_0.vars.sorter:getSkillFilter()
	local var_35_3 = var_35_2 and var_35_2:getSelectedBuffList()
	local var_35_4 = var_35_2 and var_35_2:getSelectedDebuffList()
	local var_35_5 = not table.empty(var_35_3 or {}) or not table.empty(var_35_4 or {})
	
	if var_35_5 and not SkillEffectFilterManagerPVP:isValid() then
		SkillEffectFilterManagerPVP:init()
	end
	
	local var_35_6
	
	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		local var_35_7 = DBT("character", iter_35_1.id, {
			"id",
			"grade",
			"role",
			"ch_attribute",
			"name"
		}) or {}
		local var_35_8 = arg_35_0:checkFilterValue(var_35_7, arg_35_0.vars.filters)
		
		if IS_PUBLISHER_ZLONG and (iter_35_1.id == "c5082" or iter_35_1.id == "c5149") then
			var_35_8 = false
		end
		
		if var_35_8 and var_35_5 then
			local var_35_9 = SkillEffectFilterManagerPVP:checkUnit(var_35_7.id, "buff", var_35_3)
			local var_35_10 = SkillEffectFilterManagerPVP:checkUnit(var_35_7.id, "debuff", var_35_4)
			
			var_35_8 = var_35_9 and var_35_10
		end
		
		var_35_8 = var_35_8 and arg_35_0:checkSearchKeyword(T(var_35_7.name))
		
		if var_35_8 then
			var_35_1[#var_35_1 + 1] = var_35_7
		end
	end
	
	arg_35_0.vars.sorter:setItems(var_35_1)
	arg_35_0.vars.sorter:sort()
	arg_35_0.vars.sorter:updateToggleButton()
	arg_35_0:updateListView()
	arg_35_0:updateUI()
end

function CollectionUnitList.Sorter.updateUI(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.dict_base) then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.dict_base:getChildByName("btn_open_sort")
	local var_36_1 = arg_36_0.vars.dict_base:getChildByName("btn_open_sort_active")
	
	if arg_36_0.vars.selected_role == "all" then
		local var_36_2 = arg_36_0.vars.sorters[math.abs(arg_36_0.vars.sort_index)].name
		
		if_set(var_36_1, "txt_sort", var_36_2)
		if_set(var_36_0, "txt_sort", var_36_2)
		
		local var_36_3 = arg_36_0.vars.sorter:getFilterActive()
		
		if_set_visible(var_36_1, nil, var_36_3)
		if_set_visible(var_36_0, nil, not var_36_3)
	else
		if_set_visible(var_36_1, nil, false)
		if_set_visible(var_36_0, nil, false)
	end
	
	CollectionMainUI:if_set_noData(CollectionUnitList:getCurrentDB())
end

function CollectionUnitList.Sorter.getFilterTable(arg_37_0)
	return {
		star = {
			id = "star",
			check_list = arg_37_0:getFilterCheckList("star")
		},
		role = {
			id = "role",
			check_list = arg_37_0:getFilterCheckList("role")
		},
		element = {
			id = "element",
			check_list = arg_37_0:getFilterCheckList("element")
		},
		skill = {
			id = "skill",
			check_list = arg_37_0:getFilterCheckList("skill")
		}
	}
end

function CollectionUnitList.Sorter.updateListView(arg_38_0)
	if not arg_38_0.vars then
		return 
	end
	
	if arg_38_0.vars.sorter then
		local var_38_0 = arg_38_0.vars.sorter:getSortedList()
		
		arg_38_0.vars.sorter:updateToggleButton()
		CollectionUnitList:setCurrentDB({
			var_38_0
		})
		CollectionUnitList:updateList()
	end
end

function CollectionUnitList.Sorter.search(arg_39_0, arg_39_1)
	arg_39_0.vars.search_keyword = arg_39_1
	
	arg_39_0:resetData()
	
	return {
		arg_39_0.vars.sorter:getSortedList()
	}
end

function CollectionUnitList.Sorter.getSearchKeyword(arg_40_0)
	return arg_40_0.vars and arg_40_0.vars.search_keyword
end

function CollectionUnitList.Sorter.checkSearchKeyword(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0:getSearchKeyword()
	
	if var_41_0 == nil then
		return true
	end
	
	return arg_41_1.find(arg_41_1, var_41_0) ~= nil
end

function CollectionUnitList.Sorter.makeSortFunc(arg_42_0, arg_42_1)
	return function(arg_43_0, arg_43_1)
		local var_43_0 = arg_42_0:makeOrderList(arg_42_1)
		
		return arg_42_0:procNext(arg_43_0, arg_43_1, var_43_0)
	end
end

function CollectionUnitList.Sorter.makeOrderList(arg_44_0, arg_44_1)
	local var_44_0 = table.clone(arg_44_0.ORDER_TABLE)
	
	var_44_0[arg_44_0.ORDER_UNHASH_TABLE[arg_44_1]] = nil
	
	local var_44_1 = {
		arg_44_1
	}
	
	for iter_44_0 = 1, #arg_44_0.ORDER_TABLE do
		table.insert(var_44_1, var_44_0[iter_44_0])
	end
	
	return var_44_1
end

function CollectionUnitList.Sorter.procNext(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = table.remove(arg_45_3, 1)
	
	if not var_45_0 then
		return arg_45_0.baseCase(arg_45_1, arg_45_2)
	end
	
	return arg_45_0["greaterThan" .. var_45_0](arg_45_1, arg_45_2, arg_45_3, arg_45_0)
end

function CollectionUnitList.Sorter.close(arg_46_0)
	if SkillEffectFilterManagerPVP:isValid() then
		SkillEffectFilterManagerPVP:close()
	end
	
	arg_46_0.vars = nil
end

function CollectionUnitList.Sorter.greaterThanGrade(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = arg_47_0.grade
	local var_47_1 = arg_47_1.grade
	
	if var_47_0 == var_47_1 then
		return arg_47_3:procNext(arg_47_0, arg_47_1, arg_47_2)
	end
	
	return var_47_1 < var_47_0
end

function CollectionUnitList.Sorter.greaterThanColor(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = CollectionUtil.ATTRIBUTE_SORT_ORDER[arg_48_0.ch_attribute]
	local var_48_1 = CollectionUtil.ATTRIBUTE_SORT_ORDER[arg_48_1.ch_attribute]
	
	if var_48_0 == var_48_1 then
		return arg_48_3:procNext(arg_48_0, arg_48_1, arg_48_2)
	end
	
	return var_48_0 < var_48_1
end

function CollectionUnitList.Sorter.greaterThanRole(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = CollectionUtil.ROLE_SORT_ORDER[arg_49_0.role]
	local var_49_1 = CollectionUtil.ROLE_SORT_ORDER[arg_49_1.role]
	
	if var_49_0 == var_49_1 then
		return arg_49_3:procNext(arg_49_0, arg_49_1, arg_49_2)
	end
	
	return var_49_0 < var_49_1
end

function CollectionUnitList.Sorter.greaterThanName(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	return CollectionUnitList:compareName(arg_50_0.id, arg_50_1.id)
end

function CollectionUnitList.Sorter.baseCase(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	return arg_51_3:greaterThanName(arg_51_0, arg_51_1)
end
