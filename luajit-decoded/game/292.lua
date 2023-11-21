PreBanUnitList = {}

copy_functions(CollectionListBase, PreBanUnitList)

function HANDLER.pvplive_ready_pre_ben(arg_1_0, arg_1_1)
	if ArenaNetPreBanPopup:isInputLock() then
		return 
	end
	
	if arg_1_1 == "btn_ben" then
		ArenaNetPreBanPopup:ban()
	elseif arg_1_1 == "btn_select" then
		ArenaNetPreBanPopup:select(arg_1_0, {
			with_intro = true
		})
	elseif arg_1_1 == "btn_search" then
		ArenaNetPreBanPopup:search()
	elseif arg_1_1 == "btn_open_search" then
		ArenaNetPreBanPopup:openSearch()
	elseif arg_1_1 == "btn_close_search" then
		ArenaNetPreBanPopup:closeSearch()
	elseif arg_1_1 == "btn_cancel_search" then
		ArenaNetPreBanPopup:cancelSearch()
	end
end

function PreBanUnitList.makeRoleDB(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 then
		arg_2_2.all = {}
		
		for iter_2_0, iter_2_1 in pairs(arg_2_1) do
			local var_2_0 = DB("character", iter_2_1.id, "grade")
			
			CollectionUtil:make_tbl(arg_2_2.all, var_2_0, iter_2_1)
		end
	end
end

function PreBanUnitList.onUpdateList(arg_3_0, arg_3_1)
	ArenaNetPreBanPopup:onUpdateList(arg_3_1)
end

function PreBanUnitList.search(arg_4_0, arg_4_1)
	if arg_4_1 == nil or arg_4_1 == "" then
		return false
	end
	
	local var_4_0 = arg_4_0:_search(arg_4_0.vars.character.pure_DB, arg_4_1, "character", "name", nil, nil)
	
	arg_4_0:setCurrentDB(var_4_0)
	arg_4_0.vars.sorter:sort(1)
	
	return true
end

function PreBanUnitList.reset(arg_5_0)
	arg_5_0:setCurrentDB(arg_5_0.vars.character.role_DB.all)
	arg_5_0:updateList()
end

function PreBanUnitList.setFilter(arg_6_0, arg_6_1)
	local var_6_0 = {
		role = "role",
		element = "ch_attribute",
		star = "grade",
		skill = "skill"
	}
	local var_6_1 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		var_6_1[var_6_0[iter_6_0]] = {}
		
		for iter_6_2, iter_6_3 in pairs(iter_6_1) do
			if iter_6_3 == true then
				table.insert(var_6_1[var_6_0[iter_6_0]], iter_6_2)
			end
		end
	end
	
	local var_6_2 = {}
	local var_6_3 = arg_6_0.vars.sorter:getSkillFilter()
	
	for iter_6_4, iter_6_5 in pairs(arg_6_0.vars.current_db or {}) do
		for iter_6_6, iter_6_7 in pairs(iter_6_5) do
			if var_6_3 then
				local var_6_4 = var_6_3:getSelectedBuffList()
				local var_6_5 = var_6_3:getSelectedDebuffList()
				local var_6_6 = SkillEffectFilterManagerPVP:checkUnit(iter_6_7.item_id, "buff", var_6_4)
				local var_6_7 = SkillEffectFilterManagerPVP:checkUnit(iter_6_7.item_id, "debuff", var_6_5)
				
				if var_6_6 and var_6_7 then
					var_6_2[iter_6_7.item_id] = iter_6_7
				end
			else
				var_6_2[iter_6_7.item_id] = iter_6_7
			end
		end
	end
	
	arg_6_0:_setFilterList(var_6_2, var_6_1)
	arg_6_0:sort(arg_6_0.vars.last_index, arg_6_0.vars.last_sort_data)
	
	return true
end

function PreBanUnitList.sort(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.column
	local var_7_1 = {}
	
	if table.count(arg_7_0.vars._data_source or {}) <= 0 then
		return 
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars._data_source) do
		var_7_1[iter_7_1.id] = iter_7_1.id
	end
	
	local var_7_2 = arg_7_0.vars.sort_order[var_7_0]
	
	arg_7_0.vars.last_index = arg_7_1
	arg_7_0.vars.last_sort_data = arg_7_2
	
	return arg_7_0:_sort(arg_7_0.vars.character.pure_DB, var_7_0, function(arg_8_0, arg_8_1)
		return var_7_2[arg_8_0.comp_key] > var_7_2[arg_8_1.comp_key]
	end, var_7_1, "c", arg_7_1 > 0)
end

function PreBanUnitList.setSorter(arg_9_0, arg_9_1)
	arg_9_0.vars.sorter = arg_9_1
	
	arg_9_0.vars.sorter:setItems({})
	arg_9_0.vars.sorter:sort(1)
end

function PreBanUnitList.setInputLock(arg_10_0, arg_10_1)
	arg_10_0.vars.sorter:setInputLock(arg_10_1)
end

function PreBanUnitList.updateListView(arg_11_0)
	arg_11_0:updateList()
end

function PreBanUnitList.onItemUpdate(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0:_unit_list_view_update(arg_12_1, arg_12_2, true)
	ArenaNetPreBanPopup:onItemUpdate(arg_12_1, arg_12_2)
end

function PreBanUnitList.open(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = {
		onUpdate = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
			arg_13_0:onItemUpdate(arg_14_1, arg_14_3)
		end
	}
	
	arg_13_0.vars.db_type = "c"
	
	arg_13_0:listBaseInit(arg_13_1, nil, arg_13_0.vars.character.role_DB, nil, var_13_0, nil, {
		use_list_view = true,
		item_renderer_name = "wnd/pvplive_ready_pre_ben_item.csb"
	})
	arg_13_0:setCurrentDB(arg_13_0.vars.character.role_DB.all)
	arg_13_0:updateList()
end

function PreBanUnitList.init(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.vars = {}
	arg_15_0.vars.character = {}
	arg_15_0.vars.show_earned_hero = true
	arg_15_0.vars.show_not_earned_hero = true
	arg_15_0.vars.character.pure_DB = table.clone(arg_15_2)
	
	arg_15_0:initCharacterDB(arg_15_1)
	
	arg_15_0.vars.sort_order = {}
	arg_15_0.vars.sort_order.grade = CollectionUtil.GRADE_SORT_ORDER
	arg_15_0.vars.sort_order.ch_attribute = CollectionUtil.ATTRIBUTE_SORT_ORDER
	arg_15_0.vars.sort_order.role = CollectionUtil.ROLE_SORT_ORDER
end

function PreBanUnitList.initCharacterDB(arg_16_0, arg_16_1)
	arg_16_0.vars.character.role_DB = {}
	
	arg_16_0:makeRoleDB(arg_16_0.vars.character.pure_DB, arg_16_0.vars.character.role_DB)
	arg_16_0:_makeFilterDB(arg_16_0.vars.character.pure_DB, "character", {
		"grade",
		"role",
		"ch_attribute"
	})
end

function PreBanUnitList.sortInnerTable(arg_17_0, arg_17_1)
	table.sort(arg_17_1, function(arg_18_0, arg_18_1)
		return to_n(string.match(arg_18_0, "%d+")) < to_n(string.match(arg_18_1, "%d+"))
	end)
end

ArenaNetPreBanPopup = {}

function ArenaNetPreBanPopup.getMenus(arg_19_0)
	return {
		{
			column = "grade",
			name = T("ui_unit_list_sort_1_label"),
			func = UnitSortOrder.greaterThanGrade
		},
		{
			column = "ch_attribute",
			name = T("ui_unit_list_sort_3_label"),
			func = UnitSortOrder.greaterThanColor
		},
		{
			column = "role",
			name = T("ui_unit_list_sort_6_label"),
			func = UnitSortOrder.greaterThanRole
		}
	}
end

function ArenaNetPreBanPopup.getFilterCheckList(arg_20_0, arg_20_1)
	return ItemFilterUtil:getFilterCheckList(arg_20_0.vars.filter_un_hash_tbl, arg_20_1)
end

function ArenaNetPreBanPopup.addFilter(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_0.vars.filter_un_hash_tbl[arg_21_1][arg_21_2]
	
	arg_21_0.vars.filters[arg_21_1][var_21_0] = arg_21_3
end

function ArenaNetPreBanPopup.getFilterTable(arg_22_0)
	return {
		star = {
			id = "star",
			check_list = arg_22_0:getFilterCheckList("star")
		},
		role = {
			id = "role",
			check_list = arg_22_0:getFilterCheckList("role")
		},
		element = {
			id = "element",
			check_list = arg_22_0:getFilterCheckList("element")
		},
		skill = {
			id = "skill",
			check_list = arg_22_0:getFilterCheckList("skill")
		}
	}
end

function ArenaNetPreBanPopup.onUpdateList(arg_23_0, arg_23_1)
	if not arg_23_0.vars then
		return 
	end
	
	if_set_visible(arg_23_0.vars.wnd, "n_hero_none", not (arg_23_1 > 0))
end

function ArenaNetPreBanPopup.setFilterValue(arg_24_0)
	local var_24_0 = {
		"star",
		"role",
		"element",
		"skill"
	}
	
	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		arg_24_0.vars.filters[iter_24_1] = {}
		
		for iter_24_2 = 1, 10 do
			local var_24_1 = arg_24_0.vars.filter_un_hash_tbl[iter_24_1][iter_24_2]
			
			if not var_24_1 then
				break
			end
			
			arg_24_0.vars.filters[iter_24_1][var_24_1] = true
		end
	end
end

function ArenaNetPreBanPopup.init(arg_25_0, arg_25_1)
	arg_25_1 = arg_25_1 or {}
	
	if ClearResult:isShow() then
		arg_25_1.cbFinish()
		
		return 
	end
	
	CollectionDB:init({
		only_use_pre_ban = true,
		callbackDisableUnit = function(arg_26_0)
			return ArenaService:isInGlobalBanUnit({
				db = {
					code = arg_26_0
				}
			})
		end
	})
	PreBanUnitList:init(CollectionDB:getModeDB("hero"))
	SkillEffectFilterManagerPVP:init()
	
	local var_25_0 = arg_25_1.parent or SceneManager:getRunningPopupScene()
	local var_25_1 = load_dlg("pvplive_ready_pre_ben", true, "wnd")
	
	arg_25_0.vars = {}
	arg_25_0.vars.wnd = var_25_1
	arg_25_0.vars.user_id = arg_25_1.user_id
	arg_25_0.vars.preban_count = arg_25_1.preban_count
	arg_25_0.vars.callbackFinish = arg_25_1.cbFinish
	arg_25_0.vars.is_spectator = arg_25_1.is_spectator
	arg_25_0.vars._debug_opts = arg_25_1._debug_opts
	arg_25_0.vars.recent_nodes = {}
	arg_25_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_25_0.vars.filters = {}
	arg_25_0.vars.select_infos = {}
	arg_25_0.vars.accumulate_arr = arg_25_1.accumulate_preban_arr or {}
	arg_25_0.vars.accumulate_group_arr = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.accumulate_arr) do
		local var_25_2 = UNIT:create({
			code = iter_25_1
		})
		
		if var_25_2.db.set_group then
			table.insert(arg_25_0.vars.accumulate_group_arr, var_25_2.db.set_group)
		end
	end
	
	arg_25_0.vars.list_view = arg_25_0.vars.wnd:findChildByName("ListView")
	arg_25_0.vars.time_node = arg_25_0.vars.wnd:getChildByName("n_time")
	arg_25_0.vars.n_sel_node = arg_25_0.vars.wnd:getChildByName("n_sel")
	arg_25_0.vars.n_no_sel_node = arg_25_0.vars.wnd:getChildByName("n_sel_none")
	
	arg_25_0:setFilterValue()
	
	local var_25_3 = {
		btn_toggle_box = true,
		use_on_pre_ban = true,
		sorting_unit = true
	}
	local var_25_4 = Sorter:create(var_25_1:findChildByName("n_sorting_filter_unit"), var_25_3)
	
	var_25_4:setSorter({
		menus = arg_25_0:getMenus(),
		filters = arg_25_0:getFilterTable(),
		callback_on_add_filter = function(arg_27_0, arg_27_1, arg_27_2)
			arg_25_0:addFilter(arg_27_0, arg_27_1, arg_27_2)
		end,
		callback_on_commit_filter = function()
			PreBanUnitList:setFilter(arg_25_0.vars.filters)
		end,
		callback_sort = function(arg_29_0, arg_29_1, arg_29_2)
			PreBanUnitList:sort(arg_29_1, arg_29_2)
		end,
		resetDataByCall = function()
			PreBanUnitList:setFilter(arg_25_0.vars.filters)
		end
	})
	arg_25_0:updateRecents(arg_25_1.recent_list)
	arg_25_0:updateSelectedHeroList()
	arg_25_0:updateAccumulatePreban()
	if_set(arg_25_0.vars.time_node, "t_time", "")
	if_set_visible(var_25_1, "n_hero_none", false)
	if_set_visible(var_25_1, "layer_search", false)
	if_set_visible(var_25_1, "btn_toggle_box", false)
	if_set_visible(var_25_1, "n_firstpick", arg_25_1.is_first_pick)
	var_25_0:addChild(var_25_1)
	PreBanUnitList:open(arg_25_0.vars.list_view)
	PreBanUnitList:setSorter(var_25_4)
	
	arg_25_0.vars.listerer = LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetPreBanPopup.onResponse, arg_25_0), "arena.service.ready")
	
	if arg_25_0.vars.is_spectator then
		arg_25_0.vars.wnd:setVisible(false)
	else
		UIUtil:slideOpen(arg_25_0.vars.wnd, arg_25_0.vars.wnd.c.n_window, true, true, 500)
	end
end

function ArenaNetPreBanPopup.close(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	arg_31_0.vars.wnd:setVisible(false)
	arg_31_0.vars.callbackFinish(arg_31_1)
	LuaEventDispatcher:removeEventListener(arg_31_0.vars.listerer)
	SkillEffectFilterManagerPVP:close()
	CollectionDB:close()
end

function ArenaNetPreBanPopup.onResponse(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = table.count(arg_32_2 or {})
	
	if not arg_32_0.vars or var_32_0 == 0 or not arg_32_1 then
		return 
	end
	
	local var_32_1 = "on" .. string.ucfirst(arg_32_1)
	
	if arg_32_0[var_32_1] then
		arg_32_0[var_32_1](arg_32_0, arg_32_2, arg_32_3)
	end
end

function ArenaNetPreBanPopup.onPreban(arg_33_0, arg_33_1)
end

function ArenaNetPreBanPopup.onWatch(arg_34_0, arg_34_1)
	arg_34_0:checkFinished(arg_34_1.result)
	arg_34_0:changeSequence(arg_34_1.seqinfo, arg_34_1.prebaninfo)
	arg_34_0:updateTimeInfo(arg_34_1.timeinfo)
	InBattleEsc:update(arg_34_1.envinfo)
end

function ArenaNetPreBanPopup.setInputLock(arg_35_0, arg_35_1)
	arg_35_0.vars.input_lock = arg_35_1
	
	PreBanUnitList:setInputLock(arg_35_1)
end

function ArenaNetPreBanPopup.isInputLock(arg_36_0)
	return arg_36_0.vars.input_lock or false
end

function ArenaNetPreBanPopup.ban(arg_37_0)
	if table.count(arg_37_0.vars.select_infos) < arg_37_0.vars.preban_count then
		balloon_message_with_sound("pvp_rta_not_selected_preban_hero")
		
		return 
	end
	
	if_set_color(arg_37_0.vars.wnd, "btn_ben", cc.c3b(80, 80, 80))
	arg_37_0:setInputLock(true)
	
	local var_37_0 = {}
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.select_infos) do
		local var_37_1 = {
			code = iter_37_1.data.id
		}
		
		table.insert(var_37_0, var_37_1)
	end
	
	ArenaNetReady.vars.service:query("command", {
		type = "preban",
		units = var_37_0
	}, nil, {
		retry = 3
	})
end

function ArenaNetPreBanPopup.select(arg_38_0, arg_38_1, arg_38_2)
	arg_38_2 = arg_38_2 or {}
	
	if arg_38_0:checkAccumulatePrebanList(arg_38_1.info.data.id) then
		balloon_message_with_sound("pvp_rta_already_banned_hero")
		
		return 
	end
	
	local var_38_0 = table.count(arg_38_0.vars.select_infos)
	local var_38_1
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.select_infos) do
		if iter_38_1.data.id == arg_38_1.info.data.id then
			var_38_1 = iter_38_0
			
			break
		elseif iter_38_1.data.set_group then
			local var_38_2 = UNIT:create({
				code = arg_38_1.info.data.id
			})
			
			if iter_38_1.data.set_group == var_38_2.db.set_group then
				var_38_1 = iter_38_0
				
				break
			end
		end
	end
	
	local var_38_7
	
	if var_38_1 then
		local var_38_3 = arg_38_0.vars.select_infos[var_38_1]
		
		UIAction:Remove("ban.select.action")
		
		var_38_3.data.selected = false
		
		table.remove(arg_38_0.vars.select_infos, var_38_1)
		arg_38_0:updateSelectedHeroList()
		arg_38_0.vars.list_view:refresh()
		
		local var_38_4
		
		if arg_38_1.is_recent_view then
			arg_38_0:itemUpdate(arg_38_1, {
				removed = true
			})
		else
			var_38_4 = UNIT:create({
				code = arg_38_1.info.data.id
			})
			
			for iter_38_2, iter_38_3 in pairs(arg_38_0.vars.recent_nodes or {}) do
				if iter_38_3.info.data.id == arg_38_1.info.data.id or var_38_4.db.set_group and iter_38_3.info.data.set_group == var_38_4.db.set_group then
					arg_38_0:itemUpdate(iter_38_3, {
						is_recent_view = true,
						removed = true
					})
				end
			end
		end
	elseif var_38_0 >= arg_38_0.vars.preban_count then
		balloon_message_with_sound("pvp_rta_cannot_select_more")
	else
		local var_38_5 = {
			data = arg_38_1.info.data
		}
		
		var_38_5.data.selected = true
		
		local var_38_6 = UNIT:create({
			code = var_38_5.data.id
		})
		
		var_38_5.data.set_group = var_38_6.db.set_group
		arg_38_1.with_intro = true
		arg_38_1.is_recent_view = arg_38_2.is_recent_view
		
		table.insert(arg_38_0.vars.select_infos, var_38_5)
		arg_38_0:updateSelectedHeroList()
		arg_38_0.vars.list_view:refresh()
		
		if arg_38_1.is_recent_view then
			arg_38_0:itemUpdate(arg_38_1)
		else
			var_38_7 = UNIT:create({
				code = arg_38_1.info.data.id
			})
			
			for iter_38_4, iter_38_5 in pairs(arg_38_0.vars.recent_nodes or {}) do
				if iter_38_5.info.data.id == arg_38_1.info.data.id or var_38_7.db.set_group and iter_38_5.info.data.set_group == var_38_7.db.set_group then
					arg_38_0:itemUpdate(iter_38_5, {
						with_intro = true,
						is_recent_view = true
					})
				end
			end
		end
	end
end

function ArenaNetPreBanPopup.itemUpdate(arg_39_0, arg_39_1, arg_39_2)
	arg_39_2 = arg_39_2 or {}
	
	local var_39_0 = not (not arg_39_1.is_recent_view and not arg_39_2.is_recent_view) and 0 or 48
	local var_39_1 = not (not arg_39_1.is_recent_view and not arg_39_2.is_recent_view) and 0 or 45
	local var_39_2 = not (not arg_39_1.is_recent_view and not arg_39_2.is_recent_view) and 1.5 or 1
	
	if arg_39_2.is_accumulated then
		arg_39_1:getParent():getChildByName("mob_icon"):setOpacity(127.5)
	end
	
	local function var_39_3()
		if not get_cocos_refid(arg_39_1) then
			return 
		end
		
		if not arg_39_1:getParent():getChildByName("ui_pre_banned_intro") then
			local var_40_0 = CACHE:getEffect("ui_pre_banned_intro")
			
			var_40_0:setAnchorPoint(0.5, 0.5)
			var_40_0:setPosition(var_39_0, var_39_1)
			var_40_0:setScale(var_39_2)
			var_40_0:start()
			arg_39_1:getParent():addChild(var_40_0)
		end
	end
	
	local function var_39_4()
		if not get_cocos_refid(arg_39_1) then
			return 
		end
		
		if not arg_39_1:getParent():getChildByName("ui_pre_banned_loop") then
			local var_41_0 = CACHE:getEffect("ui_pre_banned_loop")
			
			var_41_0:setAnchorPoint(0.5, 0.5)
			var_41_0:setPosition(var_39_0, var_39_1)
			var_41_0:setScale(var_39_2)
			var_41_0:start()
			arg_39_1:getParent():addChild(var_41_0)
		end
	end
	
	if arg_39_2.removed then
		arg_39_1:getParent():removeChildByName("ui_pre_banned_intro")
		arg_39_1:getParent():removeChildByName("ui_pre_banned_loop")
	elseif arg_39_1.with_intro then
		arg_39_1.with_intro = nil
		
		UIAction:Add(SEQ(CALL(var_39_3), DELAY(350), CALL(var_39_4)), arg_39_0, "ban.select.action")
	else
		UIAction:Add(SEQ(CALL(var_39_4)), arg_39_0, "ban.select.action")
	end
	
	local var_39_5 = DB("character", arg_39_1.info.data.id, "grade")
	
	arg_39_1:getParent():getChildByName("star1"):setPositionX(-46 + 10 * (5 - var_39_5))
end

function ArenaNetPreBanPopup.onItemUpdate(arg_42_0, arg_42_1, arg_42_2)
	if arg_42_2 then
		arg_42_2.accumulated = arg_42_0:checkAccumulatePrebanList(arg_42_2.id)
		arg_42_2.group_selected = arg_42_0:checkSetGroupPrebanList(arg_42_2.id)
	end
	
	if arg_42_2 and arg_42_2.accumulated then
		arg_42_0:itemUpdate(arg_42_1:getChildByName("btn_select"), {
			is_accumulated = arg_42_2.accumulated
		})
	elseif arg_42_2 and arg_42_2.selected then
		arg_42_0:itemUpdate(arg_42_1:getChildByName("btn_select"))
	elseif arg_42_2 and arg_42_2.group_selected then
		arg_42_0:itemUpdate(arg_42_1:getChildByName("btn_select"))
	else
		arg_42_0:itemUpdate(arg_42_1:getChildByName("btn_select"), {
			removed = true
		})
	end
end

function ArenaNetPreBanPopup.search(arg_43_0)
	local var_43_0 = arg_43_0.vars.wnd:getChildByName("input_search"):getString()
	local var_43_1 = CollectionUtil:removeRegexCharacters(var_43_0)
	
	if PreBanUnitList:search(var_43_1) then
		if_set_visible(arg_43_0.vars.wnd, "btn_open_search", false)
		if_set_visible(arg_43_0.vars.wnd, "btn_cancel_search", true)
	end
	
	arg_43_0:closeSearch()
end

function ArenaNetPreBanPopup.openSearch(arg_44_0)
	arg_44_0.vars.wnd:getChildByName("input_search"):setString("")
	if_set_visible(arg_44_0.vars.wnd, "layer_search", true)
end

function ArenaNetPreBanPopup.closeSearch(arg_45_0)
	if_set_visible(arg_45_0.vars.wnd, "layer_search", false)
end

function ArenaNetPreBanPopup.cancelSearch(arg_46_0)
	PreBanUnitList:reset()
	if_set_visible(arg_46_0.vars.wnd, "btn_open_search", true)
	if_set_visible(arg_46_0.vars.wnd, "btn_cancel_search", false)
end

function ArenaNetPreBanPopup.updateSelectedHeroList(arg_47_0)
	if table.empty(arg_47_0.vars.select_infos) then
		arg_47_0.vars.n_sel_node:setVisible(false)
		arg_47_0.vars.n_no_sel_node:setVisible(true)
		if_set_visible(arg_47_0.vars.n_sel_node, "face_icon", false)
	else
		arg_47_0.vars.n_sel_node:setVisible(true)
		arg_47_0.vars.n_no_sel_node:setVisible(false)
		
		for iter_47_0 = 1, 3 do
			local var_47_0 = arg_47_0.vars.select_infos[iter_47_0]
			local var_47_1 = arg_47_0.vars.n_sel_node:getChildByName("face_icon" .. tostring(iter_47_0))
			
			if var_47_0 and var_47_1 then
				var_47_1:setVisible(true)
				
				local var_47_2, var_47_3, var_47_4, var_47_5, var_47_6, var_47_7, var_47_8 = DB("character", var_47_0.data.id, {
					"face_id",
					"name",
					"ch_attribute",
					"moonlight",
					"role",
					"grade",
					"type"
				})
				local var_47_9 = "img/cm_icon_pro"
				
				if var_47_5 then
					var_47_9 = var_47_9 .. "m"
				end
				
				SpriteCache:resetSprite(var_47_1:getChildByName("role"), "img/cm_icon_role_" .. var_47_6 .. ".png")
				SpriteCache:resetSprite(var_47_1:getChildByName("face"), "face/" .. var_47_2 .. "_s.png")
				SpriteCache:resetSprite(var_47_1:getChildByName("element"), var_47_9 .. var_47_4 .. ".png")
				
				local var_47_10 = var_47_1:findChildByName("star1")
				local var_47_11 = var_47_10:getContentSize().width * var_47_10:getScale()
				
				if not var_47_10.origin_position then
					var_47_10.origin_position = var_47_10:getPositionX()
				end
				
				var_47_10:setPositionX(var_47_10.origin_position + var_47_11 * (5 - var_47_7) / 2)
				UIUtil:setStars(var_47_10, var_47_7, 0)
			else
				var_47_1:setVisible(false)
			end
		end
		
		if_set(arg_47_0.vars.n_sel_node, "desc", T("pvp_rta_preban_count", {
			count = table.count(arg_47_0.vars.select_infos),
			max = arg_47_0.vars.preban_count
		}))
	end
end

function ArenaNetPreBanPopup.checkFinished(arg_48_0, arg_48_1)
	if not arg_48_1 or table.empty(arg_48_1) then
		return 
	end
	
	if ArenaService:getMatchMode() == "net_rank" then
		ArenaService:reset()
	end
	
	ArenaService:battleClear(arg_48_1, arg_48_0.vars.is_spectator)
end

function ArenaNetPreBanPopup.checkAccumulatePrebanList(arg_49_0, arg_49_1)
	if table.find(arg_49_0.vars.accumulate_arr, arg_49_1) then
		return true
	elseif not table.empty(arg_49_0.vars.accumulate_group_arr) then
		local var_49_0 = UNIT:create({
			code = arg_49_1
		})
		
		return table.find(arg_49_0.vars.accumulate_group_arr, var_49_0.db.set_group)
	else
		return false
	end
end

function ArenaNetPreBanPopup.checkSetGroupPrebanList(arg_50_0, arg_50_1)
	local var_50_0 = UNIT:create({
		code = arg_50_1
	})
	
	if not var_50_0 or not var_50_0.db.set_group then
		return false
	end
	
	for iter_50_0, iter_50_1 in pairs(arg_50_0.vars.select_infos or {}) do
		if iter_50_1.data.set_group and iter_50_1.data.set_group == var_50_0.db.set_group then
			return true
		end
	end
	
	return false
end

function ArenaNetPreBanPopup.changeSequence(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0.vars then
		return 
	end
	
	if not arg_51_1 then
		return 
	end
	
	if arg_51_1.seq ~= arg_51_0.vars.current_seq then
		arg_51_0.vars.current_seq = arg_51_1.seq
		
		if arg_51_1.seq ~= "PRE_BAN" then
			arg_51_0:close(arg_51_2)
		end
	end
end

function ArenaNetPreBanPopup.updateTimeInfo(arg_52_0, arg_52_1)
	if not arg_52_0.vars then
		return 
	end
	
	if arg_52_0.vars.current_seq ~= "PRE_BAN" then
		return 
	end
	
	local var_52_0 = arg_52_1[arg_52_0.vars.user_id]
	
	if not var_52_0 then
		return 
	end
	
	local var_52_1 = var_52_0.total_time or 0
	local var_52_2 = var_52_0.wait_time or 0
	local var_52_3 = math.clamp(var_52_1 - var_52_2, 0, 30)
	
	arg_52_0.vars.time_node:removeChildByName("pre_ban_time")
	
	local var_52_4 = cc.Label:createWithBMFont("font/score.fnt", var_52_3)
	
	var_52_4:setName("pre_ban_time")
	var_52_4:setScale(0.8)
	var_52_4:setAnchorPoint(1, 0.5)
	var_52_4:setPosition(arg_52_0.vars.time_node:getChildByName("t_time"):getPosition())
	arg_52_0.vars.time_node:addChild(var_52_4)
	
	if var_52_3 <= 2 and not table.empty(arg_52_0.vars.select_infos) then
		local var_52_5 = {}
		
		for iter_52_0, iter_52_1 in pairs(arg_52_0.vars.select_infos) do
			local var_52_6 = {
				code = iter_52_1.data.id
			}
			
			table.insert(var_52_5, var_52_6)
		end
		
		ArenaNetReady.vars.service:query("command", {
			type = "change",
			units = var_52_5
		})
	end
end

function ArenaNetPreBanPopup.updateRecents(arg_53_0, arg_53_1)
	local function var_53_0(arg_54_0)
		local var_54_0 = {}
		local var_54_1 = {}
		
		for iter_54_0, iter_54_1 in pairs(arg_54_0 or {}) do
			if iter_54_1.code then
				local var_54_2 = UNIT:create({
					code = iter_54_1.code
				})
				
				if var_54_2 and var_54_2.db and var_54_2:getBaseGrade() > 2 then
					if not var_54_2.db.set_group then
						table.insert(var_54_0, iter_54_1)
					elseif var_54_2.db.set_group and not var_54_1[var_54_2.db.set_group] then
						var_54_1[var_54_2.db.set_group] = true
						
						table.insert(var_54_0, iter_54_1)
					end
				end
			end
		end
		
		return var_54_0
	end
	
	local var_53_1 = arg_53_0.vars.wnd:getChildByName("n_recent")
	
	if not var_53_1 then
		return 
	end
	
	local var_53_2 = arg_53_1 or ArenaNetReady:loadRecentList() or {}
	
	table.reverse(var_53_2)
	
	local var_53_3 = var_53_0(var_53_2)
	
	if_set_visible(var_53_1, "n_recent_none", table.empty(var_53_3))
	
	for iter_53_0 = 1, 4 do
		local var_53_4 = var_53_1:getChildByName("face_icon" .. tonumber(iter_53_0))
		
		if var_53_4 then
			if var_53_3 and var_53_3[iter_53_0] then
				local var_53_5 = var_53_3[iter_53_0].id or var_53_3[iter_53_0].code
				
				if var_53_5 then
					local var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12 = DB("character", var_53_5, {
						"face_id",
						"name",
						"ch_attribute",
						"moonlight",
						"role",
						"grade",
						"type"
					})
					
					if var_53_6 and var_53_10 then
						local var_53_13 = "img/cm_icon_pro"
						
						if var_53_9 then
							var_53_13 = var_53_13 .. "m"
						end
						
						SpriteCache:resetSprite(var_53_4:getChildByName("role"), "img/cm_icon_role_" .. var_53_10 .. ".png")
						SpriteCache:resetSprite(var_53_4:getChildByName("face"), "face/" .. var_53_6 .. "_s.png")
						SpriteCache:resetSprite(var_53_4:getChildByName("element"), var_53_13 .. var_53_8 .. ".png")
						
						local var_53_14 = var_53_4:getChildByName("star1")
						
						UIUtil:setStars(var_53_14, var_53_11, 0)
						var_53_14:setPositionX(-46 + 10 * (5 - var_53_11))
						
						if arg_53_0:checkAccumulatePrebanList(var_53_5) then
							for iter_53_1, iter_53_2 in pairs({
								"face_bg",
								"face",
								"frame",
								"star1",
								"role",
								"element"
							}) do
								if_set_opacity(var_53_4, iter_53_2, 127.5)
							end
							
							local var_53_15 = CACHE:getEffect("ui_pre_banned_loop")
							
							var_53_15:setAnchorPoint(0.5, 0.5)
							var_53_15:setPosition(0, 0)
							var_53_15:setScale(1.5)
							var_53_15:start()
							var_53_4:addChild(var_53_15)
						end
						
						local var_53_16 = ccui.Button:create()
						
						var_53_16:setTouchEnabled(true)
						var_53_16:ignoreContentAdaptWithSize(false)
						var_53_16:setContentSize(90, 90)
						var_53_16:setName("btn_face_" .. tostring(iter_53_0))
						
						local var_53_17 = UNIT:create({
							code = var_53_5
						})
						
						var_53_16.info = {}
						var_53_16.info.data = {
							id = var_53_5,
							set_group = var_53_17.db.set_group
						}
						
						var_53_16:addTouchEventListener(function(arg_55_0, arg_55_1)
							if arg_55_1 ~= 2 then
								return 
							end
							
							if arg_53_0:isInputLock() then
								return 
							end
							
							arg_53_0:select(arg_55_0, {
								with_intro = true,
								is_recent_view = true
							})
						end)
						var_53_4:addChild(var_53_16)
						table.insert(arg_53_0.vars.recent_nodes, var_53_16)
					end
				end
			else
				var_53_4:removeAllChildren()
			end
		end
	end
end

function ArenaNetPreBanPopup.updateAccumulatePreban(arg_56_0)
	if table.empty(arg_56_0.vars.accumulate_arr) then
		return 
	end
	
	local var_56_0 = arg_56_0.vars.wnd:getChildByName("n_pre_ban")
	
	var_56_0:setVisible(true)
	
	local var_56_1 = arg_56_0.vars.list_view:getContentSize()
	
	arg_56_0.vars.list_view:setContentSize({
		width = var_56_1.width,
		height = var_56_1.height - 86
	})
	
	for iter_56_0, iter_56_1 in pairs(arg_56_0.vars.accumulate_arr) do
		local var_56_2 = var_56_0:getChildByName("mob_icon" .. tostring(iter_56_0))
		
		if var_56_2 then
			UIUtil:getUserIcon(iter_56_1, {
				no_popup = true,
				name = false,
				no_role = true,
				no_lv = true,
				scale = 1,
				no_grade = true,
				parent = var_56_2
			})
		end
	end
end

function execute_pre_ban_list_open()
	ArenaNetPreBanPopup:init({
		_debug_opts = true,
		preban_count = 3,
		accumulate_preban_arr = {},
		recent_list = {
			{
				code = "c1019"
			},
			{
				code = "c4023"
			}
		}
	})
end
