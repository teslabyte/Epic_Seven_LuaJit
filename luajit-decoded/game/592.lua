CustomLobbySettingHero = {}

function CustomLobbySettingHero.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.Data:init()
	arg_1_0.UI:init(arg_1_1)
	arg_1_0.Sorter:init(arg_1_0.UI:getSortingNode())
end

function CustomLobbySettingHero.show(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ListView:init(arg_2_1)
	arg_2_0.Data:setSearchString(nil)
	arg_2_0.Sorter:clearSetting()
	arg_2_0.Sorter:resetData()
end

function CustomLobbySettingHero.close(arg_3_0)
	arg_3_0.Data:close()
end

function CustomLobbySettingHero.onOpenSearch(arg_4_0)
	arg_4_0.UI:onOpenSearch()
end

function CustomLobbySettingHero.onSearch(arg_5_0)
	arg_5_0.Data:setSearchString(arg_5_0.UI:getSearchString())
	arg_5_0.Sorter:search()
end

function CustomLobbySettingHero.onClearSearchResult(arg_6_0)
	arg_6_0.Data:setSearchString(nil)
	arg_6_0.Sorter:resetData()
end

function CustomLobbySettingHero.onCloseSearch(arg_7_0)
	arg_7_0.UI:onCloseSearch()
end

function CustomLobbySettingHero.onSelectItem(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.Data:getCurrentUnit()
	
	arg_8_0.Data:setSelectedItemId(arg_8_1)
	arg_8_0.ListView:updateSelected(arg_8_1, var_8_0)
	CustomLobbySettingPreview:onSelectUnit(arg_8_1)
	CustomLobbySettingMain:updateTabStatus()
	CustomLobbySettingEmotion:setDefault()
	CustomLobbySettingSkin:setDefault()
end

CustomLobbySettingHero.Data = {}

function CustomLobbySettingHero.Data.init(arg_9_0)
	arg_9_0.vars = {}
	arg_9_0.vars.view_data_list = nil
	arg_9_0.vars.current_selected_id = nil
	arg_9_0.vars.pure_current_data_list = arg_9_0:generateCurrentDataList()
	arg_9_0.vars.current_selected_id = arg_9_0.vars.pure_current_data_list[1].db.code
end

function CustomLobbySettingHero.Data.getCurrentUnit(arg_10_0)
	return arg_10_0.vars.current_selected_id
end

function CustomLobbySettingHero.Data.setSelectedItemId(arg_11_0, arg_11_1)
	arg_11_0.vars.current_selected_id = arg_11_1
end

function CustomLobbySettingHero.Data.isSelected(arg_12_0, arg_12_1)
	return arg_12_0.vars.current_selected_id == arg_12_1
end

function CustomLobbySettingHero.Data.getCurrentDataList(arg_13_0)
	return arg_13_0.vars.pure_current_data_list
end

function CustomLobbySettingHero.Data.generateCurrentDataList(arg_14_0)
	local var_14_0 = Account:getUnits()
	local var_14_1 = {}
	
	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if not var_14_1[iter_14_1.db.code] then
			var_14_1[iter_14_1.db.code] = UNIT:create({
				code = iter_14_1.db.code,
				g = iter_14_1.db.grade
			})
		end
	end
	
	local var_14_2 = {}
	
	for iter_14_2, iter_14_3 in pairs(var_14_1) do
		table.insert(var_14_2, iter_14_3)
	end
	
	return var_14_2
end

function CustomLobbySettingHero.Data.setViewDataList(arg_15_0, arg_15_1)
	arg_15_0.vars.view_data_list = arg_15_1
end

function CustomLobbySettingHero.Data.getViewDataList(arg_16_0)
	return arg_16_0.vars.view_data_list
end

function CustomLobbySettingHero.Data.setSearchString(arg_17_0, arg_17_1)
	if arg_17_1 == nil then
		arg_17_0.vars.search_string = nil
		
		return 
	end
	
	arg_17_1 = CollectionUtil:removeRegexCharacters(arg_17_1)
	arg_17_0.vars.search_string = arg_17_1
end

function CustomLobbySettingHero.Data.getSearchString(arg_18_0)
	return arg_18_0.vars.search_string
end

function CustomLobbySettingHero.Data.checkSearchString(arg_19_0, arg_19_1)
	if arg_19_0.vars.search_string == nil then
		return true
	end
	
	local var_19_0 = T(arg_19_1.db.name)
	
	return string.find(var_19_0, arg_19_0.vars.search_string) ~= nil
end

function CustomLobbySettingHero.Data.close(arg_20_0)
	arg_20_0.vars = nil
end

CustomLobbySettingHero.UI = {}

function CustomLobbySettingHero.UI.init(arg_21_0, arg_21_1)
	arg_21_0.vars = {}
	arg_21_0.vars.parent_ui = arg_21_1
	
	if_set_visible(arg_21_0.vars.parent_ui, "btn_toggle_box", false)
	if_set_visible(arg_21_0.vars.parent_ui, "btn_toggle_box_active", false)
end

function CustomLobbySettingHero.UI.getSortingNode(arg_22_0)
	return arg_22_0.vars.parent_ui:getChildByName("n_sort")
end

function CustomLobbySettingHero.UI.onOpenSearch(arg_23_0)
	local var_23_0 = arg_23_0.vars.parent_ui
	
	if_set_visible(var_23_0, "layer_search", true)
end

function CustomLobbySettingHero.UI.onCloseSearch(arg_24_0)
	local var_24_0 = arg_24_0.vars.parent_ui
	
	if_set_visible(var_24_0, "layer_search", false)
end

function CustomLobbySettingHero.UI.getSearchString(arg_25_0)
	return arg_25_0.vars.parent_ui:getChildByName("input_search"):getString()
end

CustomLobbySettingHero.Sorter = {}

function CustomLobbySettingHero.Sorter.getFilterCheckList(arg_26_0, arg_26_1)
	return ItemFilterUtil:getFilterCheckList(arg_26_0.vars.filter_un_hash_tbl, arg_26_1)
end

function CustomLobbySettingHero.Sorter.addFilter(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if not arg_27_0.vars.filter_un_hash_tbl[arg_27_1][arg_27_2] then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.filter_un_hash_tbl[arg_27_1][arg_27_2]
	
	arg_27_0.vars.filters[arg_27_1][var_27_0] = arg_27_3
end

function CustomLobbySettingHero.Sorter.checkFilterValue(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1:getGrade()
	
	if not arg_28_2.star[var_28_0] then
		return false
	end
	
	local var_28_1 = arg_28_1.db.role
	
	if not arg_28_2.role[var_28_1] then
		return false
	end
	
	local var_28_2 = arg_28_1:getColor()
	
	if not arg_28_2.element[var_28_2] then
		return false
	end
	
	return true
end

function CustomLobbySettingHero.Sorter.setFilterValue(arg_29_0)
	local var_29_0 = {
		"star",
		"role",
		"element",
		"skill"
	}
	
	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		arg_29_0.vars.filters[iter_29_1] = {}
		
		for iter_29_2 = 1, 10 do
			local var_29_1 = arg_29_0.vars.filter_un_hash_tbl[iter_29_1][iter_29_2]
			
			if not var_29_1 then
				break
			end
			
			arg_29_0.vars.filters[iter_29_1][var_29_1] = true
		end
	end
end

function CustomLobbySettingHero.Sorter.search(arg_30_0)
	arg_30_0:resetData()
end

function CustomLobbySettingHero.Sorter.clearSetting(arg_31_0)
	arg_31_0.vars.sorter:sort(1)
	arg_31_0.vars.sorter:setFilters(arg_31_0:getFilterTable())
	arg_31_0:setFilterValue()
end

function CustomLobbySettingHero.Sorter.resetData(arg_32_0)
	if not arg_32_0.vars or not arg_32_0.vars.sorter then
		return 
	end
	
	local var_32_0 = CustomLobbySettingHero.Data:getCurrentDataList()
	local var_32_1 = {}
	local var_32_2
	
	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		local var_32_3 = arg_32_0:checkFilterValue(iter_32_1, arg_32_0.vars.filters)
		
		if var_32_3 and iter_32_1.db.grade == 1 then
			var_32_3 = false
		end
		
		if var_32_3 and iter_32_1:isMoonlightDestinyUnit() then
			var_32_3 = false
		end
		
		var_32_3 = var_32_3 and CustomLobbySettingHero.Data:checkSearchString(iter_32_1)
		
		if var_32_3 then
			var_32_1[#var_32_1 + 1] = iter_32_1
		end
	end
	
	arg_32_0.vars.sorter:setItems(var_32_1)
	arg_32_0.vars.sorter:sort()
	arg_32_0.vars.sorter:updateToggleButton()
	arg_32_0:updateListView()
end

function CustomLobbySettingHero.Sorter.getFilterTable(arg_33_0)
	return {
		star = {
			id = "star",
			check_list = arg_33_0:getFilterCheckList("star")
		},
		role = {
			id = "role",
			check_list = arg_33_0:getFilterCheckList("role")
		},
		element = {
			id = "element",
			check_list = arg_33_0:getFilterCheckList("element")
		}
	}
end

function CustomLobbySettingHero.Sorter.updateListView(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	if arg_34_0.vars.sorter then
		local var_34_0 = arg_34_0.vars.sorter:getSortedList()
		
		CustomLobbySettingHero.Data:setViewDataList(var_34_0)
		CustomLobbySettingHero.ListView:setData(var_34_0)
		arg_34_0.vars.sorter:updateToggleButton()
		if_set_visible(arg_34_0.vars.wnd, "n_info", table.count(var_34_0) == 0)
		CustomLobbySettingMain.UI:setVisibleNoData(table.count(var_34_0) == 0)
	end
end

function CustomLobbySettingHero.greaterThanGrade(arg_35_0, arg_35_1, arg_35_2)
	arg_35_2 = arg_35_2 or UnitSortOrder:makeList("Grade")
	
	local var_35_0 = arg_35_0.db.grade
	local var_35_1 = arg_35_1.db.grade
	
	if var_35_0 == var_35_1 then
		return UnitSortOrder:procNext(arg_35_0, arg_35_1, arg_35_2)
	end
	
	return var_35_1 < var_35_0
end

function CustomLobbySettingHero.Sorter.init(arg_36_0, arg_36_1)
	arg_36_0.vars = {}
	
	local var_36_0 = arg_36_1:getChildByName("btn_toggle_box")
	local var_36_1 = arg_36_1:getChildByName("btn_toggle_box_active")
	local var_36_2 = {}
	
	var_36_2.sorting_unit = true
	var_36_2.not_use_skill_filter = true
	var_36_2.btn_toggle_box = true
	arg_36_0.vars.sorter = Sorter:create(arg_36_1, var_36_2)
	arg_36_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_36_0.vars.filter_un_hash_tbl.star = {
		5,
		4,
		3,
		2,
		all = "all"
	}
	arg_36_0.vars.filters = {}
	
	arg_36_0:setFilterValue()
	
	arg_36_0.vars.sorters = {
		{
			key = "Grade",
			name = T("ui_unit_list_sort_1_label"),
			func = CustomLobbySettingHero.greaterThanGrade
		},
		{
			key = "Color",
			name = T("ui_unit_list_sort_3_label"),
			func = UnitSortOrder.greaterThanColor
		},
		{
			key = "Role",
			name = T("ui_unit_list_sort_6_label"),
			func = UnitSortOrder.greaterThanRole
		},
		{
			key = "Name",
			name = T("ui_unit_list_sort_7_label"),
			func = UnitSortOrder.greaterThanName
		}
	}
	arg_36_0.vars.sort_index = 1
	
	arg_36_0.vars.sorter:setSorter({
		priority_sort_func = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
			return nil
		end,
		default_sort_index = arg_36_0.vars.sort_index,
		menus = arg_36_0.vars.sorters,
		filters = arg_36_0:getFilterTable(arg_36_0.vars.filters),
		callback_sort = function(arg_38_0, arg_38_1, arg_38_2)
			arg_36_0:updateListView()
			
			arg_36_0.vars.sort_index = arg_38_1
		end,
		callback_on_add_filter = function(arg_39_0, arg_39_1, arg_39_2)
			arg_36_0:addFilter(arg_39_0, arg_39_1, arg_39_2)
		end,
		callback_on_commit_filter = function()
			arg_36_0:resetData()
		end,
		resetDataByCall = function()
			arg_36_0:resetData()
		end,
		callback_filter = function(arg_42_0, arg_42_1, arg_42_2)
			arg_36_0:addFilter(arg_42_0, arg_42_1, arg_42_2)
			arg_36_0:resetData()
		end
	})
	arg_36_0.vars.sorter:starUIDictMode(5, 2)
	
	local var_36_3 = arg_36_0.vars.sorter:getWnd()
	local var_36_4 = var_36_3:getChildByName("btn_toggle_box")
	local var_36_5 = var_36_3:getChildByName("btn_toggle_box_active")
	
	var_36_4:setPosition(var_36_0:getPosition())
	var_36_5:setPosition(var_36_1:getPosition())
	var_36_5:setContentSize(var_36_1:getContentSize())
end

function CustomLobbySettingHero.Sorter.setData(arg_43_0, arg_43_1)
	arg_43_0.vars.sort_data = arg_43_1
	
	arg_43_0.vars.sorter:setItems(arg_43_0.vars.sort_data)
	arg_43_0.vars.sorter:sort(arg_43_0.vars.sort_index)
end

function CustomLobbySettingHero.Sorter.getData(arg_44_0)
	return arg_44_0.vars.sort_data
end

CustomLobbySettingHero.ListView = {}

function CustomLobbySettingHero.ListView.init(arg_45_0, arg_45_1)
	arg_45_0.vars = {}
	arg_45_0.vars.listview = ItemListView_v2:bindControl(arg_45_1)
	
	local var_45_0 = {
		onUpdate = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
			arg_45_0:updateListViewItem(arg_46_1, arg_46_3)
		end
	}
	local var_45_1 = load_control("wnd/lobby_custom_hero_card.csb")
	
	if arg_45_0.vars.listview.STRETCH_INFO then
		local var_45_2 = arg_45_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_45_1, var_45_2.width, arg_45_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	arg_45_0.vars.listview:setRenderer(var_45_1, var_45_0)
	arg_45_0.vars.listview:setDataSource({})
end

function CustomLobbySettingHero.ListView._if_not_blank(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5)
	local var_47_0
	
	if arg_47_3 and not arg_47_4 and not arg_47_5 then
		var_47_0 = arg_47_3
	else
		var_47_0 = arg_47_4 and arg_47_3 .. arg_47_4 .. arg_47_5 or "img/_blank.png"
	end
	
	if_set_sprite(arg_47_1, arg_47_2, var_47_0)
end

function CustomLobbySettingHero.ListView._setIconStar(arg_48_0, arg_48_1, arg_48_2)
	for iter_48_0 = 1, 6 do
		if_set_visible(arg_48_1, "star" .. iter_48_0, true)
	end
	
	if_set_visible(arg_48_1, "star" .. arg_48_2 + 1, false)
	
	local var_48_0 = arg_48_1:getChildByName("star1")
	
	if not var_48_0._origin_x then
		var_48_0._origin_x = var_48_0:getPositionX()
	end
	
	var_48_0:setPositionX(var_48_0._origin_x + (5 - arg_48_2) * 10)
end

function CustomLobbySettingHero.ListView.updateListViewItem(arg_49_0, arg_49_1, arg_49_2)
	if_set_visible(arg_49_1, "n_unit_card", true)
	if_set_visible(arg_49_1, "n_pet_card", false)
	if_set_visible(arg_49_1, "n_arti_card", false)
	
	local var_49_0 = arg_49_2.db.face_id
	local var_49_1 = arg_49_2.db.name
	local var_49_2 = arg_49_2.db.color
	local var_49_3 = arg_49_2.db.moonlight
	local var_49_4 = arg_49_2.db.role
	local var_49_5 = arg_49_2.db.grade
	local var_49_6 = arg_49_2.db.type
	
	arg_49_0:_setIconStar(arg_49_1, var_49_5)
	
	local var_49_7 = arg_49_1:getChildByName("txt_name")
	
	if get_cocos_refid(var_49_7) then
	end
	
	arg_49_0:_if_not_blank(arg_49_1, "role", "img/cm_icon_role_", var_49_4, ".png")
	
	local var_49_8 = "img/cm_icon_pro"
	
	if var_49_3 then
		var_49_8 = var_49_8 .. "m"
	end
	
	arg_49_0:_if_not_blank(arg_49_1, "element", var_49_8, var_49_2, ".png")
	arg_49_0:_if_not_blank(arg_49_1, "face", "face/", var_49_0, "_s.png")
	if_set_visible(arg_49_1, "role", true)
	if_set_visible(arg_49_1, "element", true)
	if_set_visible(arg_49_1, "star1", true)
	
	local var_49_9 = arg_49_2.db.code
	
	if_set_visible(arg_49_1, "selected", CustomLobbySettingHero.Data:isSelected(var_49_9))
	
	arg_49_1:getChildByName("btn_select").id = var_49_9
	arg_49_1:getChildByName("btn_select").data = arg_49_2
	arg_49_1:getChildByName("btn_select")._mode = "hero"
	arg_49_1.id = var_49_9
	arg_49_1.data = arg_49_2
end

function CustomLobbySettingHero.ListView.setData(arg_50_0, arg_50_1)
	arg_50_0.vars.listview:setDataSource(arg_50_1)
end

function CustomLobbySettingHero.ListView.updateSelected(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.listview) then
		return 
	end
	
	arg_51_0.vars.listview:enumControls(function(arg_52_0)
		if arg_52_0.id == arg_51_1 or arg_52_0.id == arg_51_2 then
			arg_51_0:updateListViewItem(arg_52_0, arg_52_0.data)
		end
	end)
end
