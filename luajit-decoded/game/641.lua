ArenaNetCardCollection = {}

function HANDLER.pvplive_lounge_draft_info(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		ArenaNetCardCollection:close()
	elseif arg_1_1 == "btn_close_search" then
		ArenaNetCardCollection:closeSearch()
	elseif arg_1_1 == "btn_open_search" then
		ArenaNetCardCollection:openSearch()
	elseif arg_1_1 == "btn_search" then
		ArenaNetCardCollection:onSearch()
		ArenaNetCardCollection:closeSearch()
	elseif arg_1_1 == "btn_select" then
		ArenaNetCardCollection:onSelectItem(arg_1_0.data)
	elseif arg_1_1 == "btn_swap" then
		ArenaNetCardCollection:swapCardMode()
	end
end

local function var_0_0()
	local var_2_0 = {}
	
	for iter_2_0 = 1, 999 do
		local var_2_1, var_2_2, var_2_3, var_2_4 = DBN(DRAFT_DB_NAME, iter_2_0, {
			"id",
			"character_id",
			"arti_id",
			"exc_id"
		})
		
		if not var_2_1 then
			break
		end
		
		table.insert(var_2_0, {
			id = var_2_1,
			code = var_2_2,
			arti_id = var_2_3,
			exc_id = var_2_4
		})
	end
	
	return var_2_0
end

ArenaNetCardCollection._setIconStar = CollectionListBase._setIconStar

function ArenaNetCardCollection.show(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	
	local var_3_0 = arg_3_1.parent or SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_3_0) then
		return 
	end
	
	local var_3_1 = load_dlg("pvplive_lounge_draft_info", true, "wnd")
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = var_3_1
	arg_3_0.vars.mode = arg_3_1.mode or "stat"
	
	BackButtonManager:push({
		check_id = "pvplive_lounge_draft_info",
		back_func = function()
			ArenaNetCardCollection:close()
		end,
		dlg = arg_3_0.vars.wnd
	})
	arg_3_0:initUI()
	
	arg_3_0.vars.listview = arg_3_0:initListView(var_3_1:getChildByName("listview"))
	
	ArenaNetCardCollection.SkillFilter:init()
	
	local var_3_2 = arg_3_0.vars.wnd:getChildByName("n_sorting_filter_unit")
	
	ArenaNetCardCollection.Sorter:init(var_3_2)
	ArenaNetCardCollection.Sorter:resetData()
	arg_3_0:closeSearch()
	arg_3_0:updateCardMode()
	var_3_0:addChild(var_3_1)
end

function ArenaNetCardCollection.getDB(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	if not arg_5_0.vars.db then
		arg_5_0.vars.db = var_0_0()
	end
	
	return arg_5_0.vars.db
end

function ArenaNetCardCollection.initUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_info")
	
	if get_cocos_refid(var_6_0) then
		var_6_0:setName("n_info_none")
		var_6_0:setVisible(true)
	end
	
	arg_6_0.vars.slider = arg_6_0.vars.wnd:getChildByName("Slider_btn")
	
	if get_cocos_refid(arg_6_0.vars.slider) then
		arg_6_0.vars.slider:addEventListener(function(arg_7_0, arg_7_1)
			if UIAction:Find("block") then
				return 
			end
			
			if arg_7_1 ~= 2 then
				return 
			end
			
			arg_6_0:swapCardMode()
		end)
	end
end

function ArenaNetCardCollection.initListView(arg_8_0, arg_8_1)
	if not get_cocos_refid(arg_8_1) then
		return 
	end
	
	arg_8_1 = ItemListView_v2:bindControl(arg_8_1)
	
	local var_8_0 = load_control("wnd/recall_choose_popup_card.csb")
	local var_8_1 = {
		onUpdate = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			arg_8_0:updateListViewItem(arg_9_1, arg_9_3)
		end
	}
	
	arg_8_1:setRenderer(var_8_0, var_8_1)
	
	return arg_8_1
end

function ArenaNetCardCollection.updateListViewItem(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_2 or not get_cocos_refid(arg_10_1) then
		return 
	end
	
	local var_10_0 = arg_10_1:getChildByName("n_mob_icon")
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	UIUtil:getRewardIcon(1, arg_10_2.id, {
		no_popup = true,
		no_tooltip = true,
		show_color_with_role = true,
		scale = 1,
		parent = var_10_0
	})
	
	local var_10_1 = arg_10_1:getChildByName("btn_select")
	
	if get_cocos_refid(var_10_1) then
		var_10_1.data = arg_10_2
	end
	
	arg_10_2.renderer = arg_10_1
	
	if_set_visible(arg_10_1, "selected", arg_10_2.selected)
end

function ArenaNetCardCollection.updateListView(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	if not arg_11_0.vars.listview then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.wnd:getChildByName("n_card")
	
	if get_cocos_refid(var_11_0) then
		var_11_0:removeAllChildren()
	end
	
	if_set_visible(arg_11_0.vars.wnd, "n_info_none", true)
	if_set_visible(arg_11_0.vars.wnd, "n_hero_none", table.empty(arg_11_1))
	
	local var_11_1
	
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		iter_11_1.renderer = nil
		
		if arg_11_0:isSelectedItem(iter_11_1) then
			var_11_1 = iter_11_1
		end
	end
	
	arg_11_0.vars.listview:setDataSource(arg_11_1)
	
	if var_11_1 then
		arg_11_0:onSelectItem(var_11_1)
	else
		arg_11_0:deselectItem()
	end
end

function ArenaNetCardCollection.onSelectItem(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		return 
	end
	
	if not arg_12_1 then
		return 
	end
	
	arg_12_0:deselectItem()
	
	arg_12_0.vars.selected_item = arg_12_1
	
	if_set_visible(arg_12_1.renderer, "selected", true)
	if_set_visible(arg_12_0.vars.wnd, "n_info_none", false)
	if_set_visible(arg_12_0.vars.wnd, "n_hero_card", true)
	
	local var_12_0 = arg_12_0.vars.wnd:getChildByName("n_card")
	
	if get_cocos_refid(var_12_0) then
		local var_12_1 = ArenaNetCard:create({
			draft_card_id = arg_12_1.card_id
		})
		
		var_12_1:updateMode(arg_12_0.vars.mode)
		
		arg_12_1.card = var_12_1
		arg_12_1.selected = true
		
		var_12_0:addChild(var_12_1)
		if_set_visible(var_12_1, "n_frame", false)
		if_set_visible(var_12_1, "btn_select", false)
	end
end

function ArenaNetCardCollection.deselectItem(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if not arg_13_0.vars.selected_item then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.selected_item
	
	if get_cocos_refid(var_13_0.card) then
		var_13_0.card:removeFromParent()
	end
	
	var_13_0.card = nil
	var_13_0.selected = false
	
	if_set_visible(var_13_0.renderer, "selected", false)
	if_set_visible(arg_13_0.vars.wnd, "n_info_none", true)
	if_set_visible(arg_13_0.vars.wnd, "n_hero_card", false)
	
	arg_13_0.vars.selected_item = nil
end

function ArenaNetCardCollection.isSelectedItem(arg_14_0, arg_14_1)
	if not arg_14_0.vars then
		return 
	end
	
	if not arg_14_0.vars.selected_item then
		return 
	end
	
	if not arg_14_1 then
		return 
	end
	
	return arg_14_0.vars.selected_item.card_id == arg_14_1.card_id
end

function ArenaNetCardCollection.swapCardMode(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.mode
	
	if var_15_0 == arg_15_1 then
		return 
	end
	
	arg_15_1 = arg_15_1 or var_15_0 == "stat" and "talent" or "stat"
	arg_15_0.vars.mode = arg_15_1
	
	arg_15_0:updateCardMode()
end

function ArenaNetCardCollection.updateCardMode(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.mode
	
	if arg_16_0.vars.selected_item and get_cocos_refid(arg_16_0.vars.selected_item.card) then
		arg_16_0.vars.selected_item.card:updateMode(var_16_0)
	end
	
	if get_cocos_refid(arg_16_0.vars.slider) then
		arg_16_0.vars.slider:setMaxPercent(var_16_0 == "talent" and 1 or 0)
		arg_16_0.vars.slider:setPercent(var_16_0 == "talent" and 1 or 0)
	end
	
	local var_16_1 = cc.c3b(148, 148, 148)
	local var_16_2 = cc.c3b(255, 189, 99)
	
	if_set_color(arg_16_0.vars.wnd, "txt_stat", var_16_0 == "stat" and var_16_2 or var_16_1)
	if_set_color(arg_16_0.vars.wnd, "txt_profile", var_16_0 == "talent" and var_16_2 or var_16_1)
end

function ArenaNetCardCollection.openSearch(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if_set(arg_17_0.vars.wnd, "input_search", "")
	if_set_visible(arg_17_0.vars.wnd, "layer_search", true)
end

function ArenaNetCardCollection.closeSearch(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	if_set_visible(arg_18_0.vars.wnd, "layer_search", false)
end

function ArenaNetCardCollection.onSearch(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.wnd:getChildByName("input_search"):getString()
	local var_19_1 = CollectionUtil:removeRegexCharacters(var_19_0)
	
	ArenaNetCardCollection.Sorter:search(var_19_1)
end

function ArenaNetCardCollection.close(arg_20_0)
	ArenaNetCardCollection.Sorter:close()
	ArenaNetCardCollection.SkillFilter:close()
	
	if not arg_20_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_20_0.vars.wnd) then
		BackButtonManager:pop({
			check_id = "pvplive_lounge_draft_info",
			dlg = arg_20_0.vars.wnd
		})
		arg_20_0.vars.wnd:removeFromParent()
		
		arg_20_0.vars.wnd = nil
	end
	
	arg_20_0.vars = nil
end

ArenaNetCardCollection.Sorter = {}

copy_functions(CollectionUnitList.Sorter, ArenaNetCardCollection.Sorter)

function ArenaNetCardCollection.Sorter.init(arg_21_0, arg_21_1)
	if not get_cocos_refid(arg_21_1) then
		return 
	end
	
	arg_21_0.vars = {}
	
	local var_21_0 = {
		sorting_unit = true,
		btn_toggle_box = true
	}
	
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
	
	local var_21_1 = {
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
	
	arg_21_0.vars.sorter:setSorter({
		menus = var_21_1,
		filters = arg_21_0:getFilterTable(),
		callback_sort = function(arg_22_0, arg_22_1, arg_22_2)
			arg_21_0:updateListView()
		end,
		callback_on_add_filter = function(arg_23_0, arg_23_1, arg_23_2)
			arg_21_0:addFilter(arg_23_0, arg_23_1, arg_23_2)
		end,
		callback_on_commit_filter = function()
			arg_21_0:resetData()
		end,
		callback_filter = function(arg_25_0, arg_25_1, arg_25_2)
			arg_21_0:addFilter(arg_25_0, arg_25_1, arg_25_2)
			arg_21_0:resetData()
		end,
		resetDataByCall = function()
			arg_21_0:resetData()
		end
	})
	arg_21_0.vars.sorter:starUIDictMode(5, 3)
	arg_21_0.vars.sorter:roleUIDictMode()
	
	return arg_21_0.vars.sorter
end

function ArenaNetCardCollection.Sorter.resetData(arg_27_0)
	if not arg_27_0.vars or not arg_27_0.vars.sorter then
		return 
	end
	
	local var_27_0 = ArenaNetCardCollection:getDB() or {}
	local var_27_1 = {}
	local var_27_2 = arg_27_0.vars.sorter:getSkillFilter()
	local var_27_3 = var_27_2 and var_27_2:getSelectedBuffList()
	local var_27_4 = var_27_2 and var_27_2:getSelectedDebuffList()
	local var_27_5 = not table.empty(var_27_3 or {}) or not table.empty(var_27_4 or {})
	local var_27_6
	
	for iter_27_0, iter_27_1 in pairs(var_27_0) do
		local var_27_7 = DBT("character", iter_27_1.code, {
			"id",
			"face_id",
			"grade",
			"role",
			"ch_attribute",
			"moonlight",
			"name"
		}) or {}
		local var_27_8 = arg_27_0:checkFilterValue(var_27_7, arg_27_0.vars.filters)
		
		if var_27_8 and var_27_5 then
			local var_27_9 = ArenaNetCardCollection.SkillFilter:checkUnit(iter_27_1.id, "buff", var_27_3)
			local var_27_10 = ArenaNetCardCollection.SkillFilter:checkUnit(iter_27_1.id, "debuff", var_27_4)
			
			var_27_8 = var_27_9 and var_27_10
		end
		
		var_27_8 = var_27_8 and arg_27_0:checkSearchKeyword(T(var_27_7.name))
		
		if var_27_8 then
			var_27_7.card_id = iter_27_1.id
			var_27_1[#var_27_1 + 1] = var_27_7
		end
	end
	
	arg_27_0.vars.sorter:setItems(var_27_1)
	arg_27_0.vars.sorter:sort()
	arg_27_0.vars.sorter:updateToggleButton()
end

function ArenaNetCardCollection.Sorter.updateListView(arg_28_0)
	if not arg_28_0.vars or not arg_28_0.vars.sorter then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.sorter:getSortedList()
	
	ArenaNetCardCollection:updateListView(var_28_0)
end

function ArenaNetCardCollection.Sorter.makeOrderList(arg_29_0, arg_29_1)
	return {
		arg_29_1,
		"Id"
	}
end

function ArenaNetCardCollection.Sorter.baseCase(arg_30_0, arg_30_1)
	return arg_30_0.card_id < arg_30_1.card_id
end

function ArenaNetCardCollection.Sorter.greaterThanName(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if arg_31_0.id == arg_31_1.id then
		return arg_31_3:procNext(arg_31_0, arg_31_1, arg_31_2)
	end
	
	return CollectionUnitList:compareName(arg_31_0.id, arg_31_1.id)
end

function ArenaNetCardCollection.Sorter.greaterThanId(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_0.id == arg_32_1.id then
		return arg_32_3:procNext(arg_32_0, arg_32_1, arg_32_2)
	end
	
	return arg_32_0.id < arg_32_1.id
end

function ArenaNetCardCollection.Sorter.close(arg_33_0)
	arg_33_0.vars = nil
end

ArenaNetCardCollection.SkillFilter = {}

copy_functions(SkillEffectFilterManagerPVP, ArenaNetCardCollection.SkillFilter)

function ArenaNetCardCollection.SkillFilter.init(arg_34_0)
	local var_34_0 = ArenaNetCardCollection:getDB()
	
	if not var_34_0 or table.empty(var_34_0) then
		return 
	end
	
	arg_34_0.vars = {}
	arg_34_0.vars.buff_eff = table.shallow_clone(SkillEffectFilterManager:getAllBuffList())
	arg_34_0.vars.debuff_eff = table.shallow_clone(SkillEffectFilterManager:getAllDebuffList())
	
	for iter_34_0, iter_34_1 in pairs(var_34_0) do
		local var_34_1 = iter_34_1.code
		
		if var_34_1 then
			local var_34_2 = UNIT:create({
				z = 6,
				code = var_34_1
			}, nil, true)
			
			if iter_34_1.exc_id then
				var_34_2:applyExclusiveSkill(iter_34_1.exc_id)
			end
			
			var_34_2.card_id = iter_34_1.id
			
			arg_34_0:addUnit(var_34_2)
		end
	end
end

function ArenaNetCardCollection.SkillFilter.setData(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_1:getExclusiveEffect(arg_35_1:getReferSkillIndex(arg_35_2)) or {}
	local var_35_1 = {}
	
	if not table.empty(var_35_0.explain) then
		var_35_1 = var_35_0.explain
	else
		var_35_1[1], var_35_1[2], var_35_1[3], var_35_1[4] = DB("skill", arg_35_2, {
			"sk_eff_explain1",
			"sk_eff_explain2",
			"sk_eff_explain3",
			"sk_eff_explain4"
		})
	end
	
	for iter_35_0, iter_35_1 in pairs(var_35_1) do
		if iter_35_1 then
			local var_35_2 = DB("skill_effectexplain", tostring(iter_35_1), {
				"type"
			})
			
			if not var_35_2 then
				break
			end
			
			local var_35_3
			local var_35_4
			
			if var_35_2 == "buff" and arg_35_0.vars.buff_eff[iter_35_1] then
				var_35_3 = arg_35_0.vars.buff_eff[iter_35_1]
			elseif var_35_2 == "debuff" and arg_35_0.vars.debuff_eff[iter_35_1] then
				var_35_3 = arg_35_0.vars.debuff_eff[iter_35_1]
			elseif var_35_2 == "common" then
			end
			
			if var_35_3 then
				if not var_35_3.unit_code_list then
					var_35_3.unit_code_list = {}
				end
				
				local var_35_5 = var_35_3.unit_code_list
				
				if not var_35_5[arg_35_1.card_id] then
					var_35_5[arg_35_1.card_id] = {}
				end
			end
		end
	end
end
