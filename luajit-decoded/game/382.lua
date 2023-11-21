UnitUnfold = {}

function HANDLER.unit_list_unfold(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_fold" then
		UnitUnfold:onPushBackButton()
	elseif arg_1_1 == "btn_select" then
		UnitUnfold:onSelectUnit(Account:getUnit(arg_1_0:getParent().unit_id))
	elseif arg_1_1 == "add_inven" then
		UIUtil:showIncHeroInvenDialog()
	end
end

UnitUnfold.addFilter = HeroBelt.addFilter
UnitUnfold.checkFilterValue = HeroBelt.checkFilterValue
UnitUnfold.getFilterCheckList = HeroBelt.getFilterCheckList
UnitUnfold.getFilterTable = HeroBelt.getFilterTable
UnitUnfold.getSortKey = HeroBelt.getSortKey
UnitUnfold.loadFilterValue = HeroBelt.loadFilterValue
UnitUnfold.setupFilterValue = HeroBelt.setupFilterValue
UnitUnfold.toggleShowOnlyLock = HeroBelt.toggleShowOnlyLock
UnitUnfold.toggleHideMaxUnits = HeroBelt.toggleHideMaxUnits
UnitUnfold.toggleHideMaxFav = HeroBelt.toggleHideMaxFav
UnitUnfold.toggleHideFavUnits = HeroBelt.toggleHideFavUnits
UnitUnfold.favoriteFirstSortFunc = HeroBelt.favoriteFirstSortFunc
UnitUnfold.teamFirstSortFunc = HeroBelt.teamFirstSortFunc
UnitUnfold.getSortMenus = HeroBelt.getSortMenus
UnitUnfold.getSkillFilterSetting = HeroBelt.getSkillFilterSetting
UnitUnfold.setupSkillFilterValue = HeroBelt.setupSkillFilterValue
UnitUnfold.setupCheckboxValue = HeroBelt.setupCheckboxValue

function UnitUnfold.createList(arg_2_0, arg_2_1, arg_2_2)
	arg_2_2 = arg_2_2 or {}
	arg_2_1 = arg_2_1 or SceneManager:getRunningNativeScene()
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("unit_list_unfold", true, "wnd")
	arg_2_0.vars.callback_select = arg_2_2.callback_select
	arg_2_0.vars.prev_unit = arg_2_2.unit
	
	local function var_2_0(arg_3_0, arg_3_1)
		if not arg_3_0 or type(arg_3_0) ~= "number" then
			return arg_3_1
		end
		
		return arg_3_0
	end
	
	arg_2_0.vars.sort_index = var_2_0(Account:getConfigData("unit_list_sort_index"), 2)
	arg_2_0.vars.saved_stat_index = var_2_0(Account:getConfigData("unit_list_stat_index"), 1)
	arg_2_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_2_0.vars.filters = {}
	arg_2_0.vars.hero_belt = arg_2_2.hero_belt or UnitMain:getHeroBelt()
	
	if arg_2_0.vars.hero_belt then
		local var_2_1 = arg_2_0.vars.hero_belt:getFilterSetting("Detail")
		local var_2_2 = arg_2_0.vars.hero_belt:getCheckbox()
		
		arg_2_0:setupFilterValue(var_2_1)
		arg_2_0:setupCheckboxValue(var_2_2)
	end
	
	arg_2_0.vars.sorter = Sorter:create(arg_2_0.vars.wnd:getChildByName("n_sorting"), {
		sorting_unit = true,
		stat_menu_idx = 9
	})
	arg_2_0.vars.sorters = arg_2_0:getSortMenus(arg_2_0.vars.sorter)
	
	arg_2_0.vars.sorter:setSorter({
		priority_sort_func = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			local var_4_0 = arg_2_0:teamFirstSortFunc(arg_4_0, arg_4_1, arg_4_2)
			
			if var_4_0 ~= nil then
				return var_4_0
			end
			
			return arg_2_0:favoriteFirstSortFunc(arg_4_0, arg_4_1, arg_4_2)
		end,
		default_sort_index = arg_2_0.vars.sort_index,
		default_stat_index = arg_2_0.vars.saved_stat_index,
		menus = arg_2_0.vars.sorters,
		checkboxs = arg_2_0:getCheckbox(),
		filters = arg_2_0:getFilterTable(arg_2_0.vars.filters),
		callback_sort = function(arg_5_0, arg_5_1, arg_5_2)
			arg_2_0:updateListView()
			
			arg_2_0.vars.sort_index = arg_5_1
			
			local var_5_0 = arg_5_0 ~= arg_5_1
			local var_5_1 = arg_2_0.vars.sorter:getLatestStatMenuIdx()
			
			if var_5_1 and arg_2_0.vars.saved_stat_index ~= var_5_1 then
				arg_2_0.vars.saved_stat_index = var_5_1
				var_5_0 = true
			end
			
			if var_5_0 then
				local var_5_2 = arg_2_0:getSortKey(arg_5_0)
				local var_5_3 = arg_2_0:getSortKey(arg_5_1)
				
				if var_5_2 == "Stat" or var_5_3 == "Stat" or var_5_2 == "Fav" or var_5_3 == "Fav" or var_5_2 == "DevoteGrade" or var_5_3 == "DevoteGrade" then
					arg_2_0.vars.listview:enumControls(function(arg_6_0)
						local var_6_0 = arg_6_0:getChildByName("n_unit_bar")
						
						if not var_6_0 then
							return 
						end
						
						arg_2_0:updateUnitBar(Account:getUnit(var_6_0.unit_id), var_6_0)
					end)
				end
			end
		end,
		callback_checkbox = function(arg_7_0, arg_7_1, arg_7_2)
			if arg_7_0 == "team_first" then
				arg_2_0:toggleSortTeamFirst(arg_7_2)
				arg_2_0:updateListView()
			end
			
			if arg_7_0 == "show_only_lock" then
				arg_2_0:toggleShowOnlyLock(arg_7_2)
				arg_2_0:updateListView()
			end
			
			if arg_7_0 == "hide_max" then
				arg_2_0:toggleHideMaxUnits(arg_7_2)
				arg_2_0:updateListView()
			end
			
			if arg_7_0 == "hide_favorite" then
				arg_2_0:toggleHideFavUnits(arg_7_2)
				arg_2_0:updateListView()
			end
			
			if arg_7_0 == "hide_max_fav" then
				arg_2_0:toggleHideMaxFav(arg_7_2)
				arg_2_0:updateListView()
			end
		end,
		callback_on_add_filter = function(arg_8_0, arg_8_1, arg_8_2)
			arg_2_0:addFilter(arg_8_0, arg_8_1, arg_8_2)
		end,
		callback_on_commit_filter = function()
			arg_2_0:resetData()
			arg_2_0:updateListView()
		end,
		resetDataByCall = function()
			arg_2_0:resetData()
			arg_2_0:updateListView()
		end,
		callback_filter = function(arg_11_0, arg_11_1, arg_11_2)
			arg_2_0:addFilter(arg_11_0, arg_11_1, arg_11_2)
			arg_2_0:resetData()
			arg_2_0:updateListView()
		end
	})
	
	if arg_2_0.vars.hero_belt then
		local var_2_3 = arg_2_0.vars.hero_belt:getSkillFilterSetting()
		
		arg_2_0:setupSkillFilterValue(var_2_3)
	end
	
	arg_2_0:resetData()
	arg_2_1:addChild(arg_2_0.vars.wnd)
	
	local var_2_4 = FastListView_v2:bindControl(arg_2_0.vars.wnd:getChildByName("ListView"))
	local var_2_5 = {
		onUpdate = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			if not arg_12_3 then
				return 
			end
			
			UnitUnfold:updateUnitBar(arg_12_3, arg_12_1)
			
			arg_12_1.unit_id = arg_12_3:getUID()
			
			return arg_12_2
		end
	}
	local var_2_6 = load_control("wnd/unit_bar.csb")
	
	var_2_6:setName("n_unit_bar")
	var_2_6:setScale(0.9)
	var_2_6:setContentSize(300, 95)
	var_2_6:setCascadeOpacityEnabled(true)
	Dialog:addButton(var_2_6, {
		x = 168,
		height = 95,
		width = 300,
		y = 40
	}, "btn_select")
	
	local var_2_7 = arg_2_0.vars.sorter:getSortedList()
	
	var_2_4:setListViewCascadeEnabled(true)
	var_2_4:setRenderer(var_2_6, var_2_5, 100)
	var_2_4:removeAllChildren()
	var_2_4:setDataSource(var_2_7)
	var_2_4:jumpToTop()
	var_2_4:setPositionX(660)
	
	arg_2_0.vars.listview = var_2_4
	
	if_set_visible(arg_2_0.vars.wnd, "n_info", table.count(var_2_7) == 0)
end

function UnitUnfold.onChangeResolution(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_13_0.vars.listview) then
		local var_13_0 = arg_13_0.vars.listview:getContentSize()
		
		arg_13_0.vars.listview:setContentSize(VIEW_WIDTH, var_13_0.height)
	end
end

function UnitUnfold.getCheckbox(arg_14_0)
	return {
		{
			id = "team_first",
			name = T("sort_team_first"),
			checked = arg_14_0.vars.sort_team_first
		},
		{
			id = "hide_favorite",
			is_filter = true,
			name = T("sort_hide_favorite"),
			checked = arg_14_0.vars.hide_fav_units
		},
		{
			id = "show_only_lock",
			is_filter = true,
			name = T("sort_only_lockhero"),
			checked = arg_14_0.vars.show_only_lock
		},
		{
			id = "hide_max",
			is_filter = true,
			name = T("sort_hide_maxhero"),
			checked = arg_14_0.vars.hide_max_units
		},
		{
			id = "hide_max_fav",
			is_filter = true,
			name = T("sort_hide_max_intimacy"),
			checked = arg_14_0.vars.hide_max_fav
		}
	}
end

function UnitUnfold.toggleSortTeamFirst(arg_15_0, arg_15_1)
	if arg_15_1 == nil then
		arg_15_0.vars.sort_team_first = not arg_15_0.vars.sort_team_first
	else
		arg_15_0.vars.sort_team_first = arg_15_1
	end
	
	arg_15_0.vars.sorter:sort()
end

function UnitUnfold.updateUnitBar(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_1 then
		return 
	end
	
	local var_16_0 = arg_16_0:getSortKey()
	local var_16_1 = arg_16_1:getLv()
	local var_16_2 = arg_16_1:getMaxLevel()
	local var_16_3 = var_16_0 == "Fav"
	local var_16_4 = var_16_0 == "DevoteGrade"
	local var_16_5
	
	if var_16_0 == "Stat" then
		local var_16_6 = arg_16_0.vars.sorter:getLatestStatMenu()
		
		if var_16_6 then
			var_16_5 = {
				id = var_16_6.id,
				unit_bar_opt = var_16_6.unit_bar_opt
			}
		end
	end
	
	UIUtil:updateUnitBar("Detail", arg_16_1, {
		force_update = true,
		wnd = arg_16_2,
		lv = var_16_1,
		max_lv = var_16_2,
		show_fav = var_16_3,
		show_devote = var_16_4,
		index_key = var_16_0,
		stat_opts = var_16_5
	})
end

function UnitUnfold.onCreate(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or {}
	
	function arg_17_1.callback_select(arg_18_0)
		UnitMain:setMode(arg_17_0.vars.prev_mode, {
			unit = arg_18_0
		})
	end
	
	arg_17_0:createList(UnitMain.vars.base_wnd, arg_17_1)
	if_set_visible(arg_17_0.vars.wnd, nil, false)
	if_set_visible(arg_17_0.vars.wnd, "layer_sort", false)
end

function UnitUnfold.updateHeroCount(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	arg_19_1 = arg_19_1 or table.count(arg_19_0.vars.sorter:getSortedList())
	
	if_set(arg_19_0.vars.wnd, "status", arg_19_1 .. "/" .. Account:getCurrentHeroCount())
end

function UnitUnfold.onSelectUnit(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.vars.callback_select
	
	if type(var_20_0) == "function" then
		var_20_0(arg_20_1)
	end
end

function UnitUnfold.updateListView(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if arg_21_0.vars.listview and arg_21_0.vars.sorter then
		local var_21_0 = arg_21_0.vars.sorter:getSortedList()
		
		arg_21_0.vars.listview:clearListView()
		arg_21_0.vars.listview:setDataSource(var_21_0)
		arg_21_0.vars.sorter:updateToggleButton()
		if_set_visible(arg_21_0.vars.wnd, "n_info", table.count(var_21_0) == 0)
	end
end

function UnitUnfold.resetData(arg_22_0)
	if not arg_22_0.vars or not arg_22_0.vars.sorter then
		return 
	end
	
	local var_22_0 = Account:getUnits()
	local var_22_1 = {}
	local var_22_2
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		local var_22_3 = arg_22_0:checkFilterValue(iter_22_1, arg_22_0.vars.filters)
		
		if var_22_3 and iter_22_1:isSpecialUnit() then
			var_22_3 = false
		end
		
		if var_22_3 and arg_22_0.vars.show_only_lock and not iter_22_1:isLocked() then
			var_22_3 = false
		end
		
		if var_22_3 and arg_22_0.vars.hide_max_units and iter_22_1:isMaxLevel() then
			var_22_3 = false
		end
		
		if var_22_3 and arg_22_0.vars.hide_fav_units and iter_22_1:isFavoriteUnit() then
			var_22_3 = false
		end
		
		if var_22_3 and arg_22_0.vars.hide_max_fav and iter_22_1:getFavLevel() >= 10 then
			var_22_3 = false
		end
		
		if var_22_3 and arg_22_0.vars.sorter and arg_22_0.vars.sorter:canUseBuffFilter() then
			local var_22_4 = arg_22_0.vars.sorter:getSkillFilter()
			
			if var_22_4 and not var_22_4:checkUnit(iter_22_1:getUID()) then
				var_22_3 = false
			end
		end
		
		if var_22_3 then
			var_22_1[#var_22_1 + 1] = iter_22_1
		end
	end
	
	arg_22_0.vars.sorter:setItems(var_22_1)
	arg_22_0.vars.sorter:sort()
	arg_22_0.vars.sorter:updateToggleButton()
	arg_22_0:updateHeroCount(table.count(var_22_1))
end

function UnitUnfold.onEnter(arg_23_0, arg_23_1)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	arg_23_0.vars.prev_mode = arg_23_1
	
	if_set_opacity(arg_23_0.vars.wnd, nil, 0)
	UIAction:Add(SLIDE_IN(200, -300), arg_23_0.vars.wnd, "block")
end

function UnitUnfold.onPushBackButton(arg_24_0)
	local var_24_0 = arg_24_0.vars.prev_unit
	local var_24_1 = arg_24_0.vars.sorter:getSortedList()
	local var_24_2 = table.empty(var_24_1)
	local var_24_3 = table.isInclude(var_24_1, function(arg_25_0, arg_25_1)
		if arg_25_1:getUID() == var_24_0:getUID() then
			return true
		end
	end)
	
	if not var_24_2 and not var_24_3 then
		var_24_0 = nil
	end
	
	UnitMain:setMode(arg_24_0.vars.prev_mode, {
		unit = var_24_0
	})
end

function UnitUnfold.onLeave(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.hero_belt
	
	if var_26_0 then
		var_26_0:setFilter(arg_26_0.vars.filters)
		var_26_0:setupCheckboxValue(arg_26_0:getCheckbox())
		var_26_0:changeCheckboxes()
		
		if math.abs(arg_26_0.vars.sort_index) == var_26_0:getSortIndexInMenus("Stat") then
			local var_26_1 = var_26_0:getSorter()
			
			if var_26_1 then
				var_26_1:sortByStatButton(arg_26_0.vars.saved_stat_index, arg_26_0.vars.sort_index)
			end
		else
			var_26_0:sort(arg_26_0.vars.sort_index)
		end
		
		local var_26_2 = arg_26_0:getSkillFilterSetting()
		
		var_26_0:setupSkillFilterValue(var_26_2)
	end
	
	UIAction:Add(SEQ(SLIDE_OUT(200, 300), CALL(function()
		arg_26_0.vars.wnd:removeFromParent()
		
		arg_26_0.vars = nil
	end)), arg_26_0.vars.wnd, "block")
end

function UnitUnfold.isValid(arg_28_0)
	return arg_28_0.vars and get_cocos_refid(arg_28_0.vars.wnd)
end
