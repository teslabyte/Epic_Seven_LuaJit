HeroBelt = {}
HeroBeltEventInterface = {}

function HeroBeltEventInterface.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.listeners = {}
end

function HeroBeltEventInterface.checkInit(arg_2_0)
	if not arg_2_0.vars then
		arg_2_0:init()
	end
end

function HeroBeltEventInterface.addListener(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:checkInit()
	
	arg_3_0.vars.listeners[arg_3_1] = arg_3_2
end

function HeroBeltEventInterface.removeListener(arg_4_0, arg_4_1)
	arg_4_0:checkInit()
	
	arg_4_0.vars.listeners[arg_4_1] = nil
end

function HeroBeltEventInterface.updateListeners(arg_5_0)
	arg_5_0:checkInit()
	
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.listeners) do
		if not get_cocos_refid(iter_5_0) then
			table.insert(var_5_0, iter_5_0)
		end
	end
	
	for iter_5_2, iter_5_3 in pairs(var_5_0) do
		arg_5_0.vars.listeners[iter_5_3] = nil
	end
end

function HeroBeltEventInterface.getRootNode(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return nil
	end
	
	if arg_6_1:getName() == "unit_list" then
		return arg_6_1
	end
	
	return arg_6_0:getRootNode(arg_6_1:getParent())
end

function HeroBeltEventInterface._getListenerTable(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:getRootNode(arg_7_1)
	local var_7_1 = arg_7_0.vars.listeners[var_7_0]
	
	if not var_7_1 then
		Log.e("HeroBelt Eventer is Dead!")
		
		return 
	end
	
	return var_7_1
end

function HeroBeltEventInterface.event_onPushAddButton(arg_8_0, arg_8_1)
	arg_8_0:updateListeners()
	
	local var_8_0 = arg_8_0:_getListenerTable(arg_8_1)
	
	if not var_8_0 then
		return 
	end
	
	var_8_0:onPushAddButton()
end

function HeroBeltEventInterface.event_popItem(arg_9_0, arg_9_1)
	arg_9_0:updateListeners()
	
	local var_9_0 = arg_9_0:_getListenerTable(arg_9_1)
	
	if not var_9_0 then
		return 
	end
	
	var_9_0:popItem()
end

function HeroBeltEventInterface.event_revertGarbageItem(arg_10_0, arg_10_1)
	arg_10_0:updateListeners()
	
	local var_10_0 = arg_10_0:_getListenerTable(arg_10_1)
	
	if not var_10_0 then
		return 
	end
	
	var_10_0.dock:revertGarbageItem()
end

function HeroBeltEventInterface.event_resurrection(arg_11_0, arg_11_1)
	arg_11_0:updateListeners()
	
	local var_11_0 = arg_11_0:_getListenerTable(arg_11_1)
	
	if not var_11_0 or not var_11_0.onPushResurrectionButton then
		return 
	end
	
	var_11_0:onPushResurrectionButton()
end

function HANDLER.unit_bar(arg_12_0, arg_12_1)
	if arg_12_1 == "add" then
		HeroBeltEventInterface:event_onPushAddButton(arg_12_0)
	elseif arg_12_1 == "resurrection" then
		HeroBeltEventInterface:event_resurrection(arg_12_0)
	end
end

function HANDLER.unit_list(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_pop" then
		HeroBeltEventInterface:popItem()
	end
	
	if arg_13_1 == "btn_push" then
		HeroBeltEventInterface:revertGarbageItem()
	end
	
	if arg_13_1 == "add_inven" then
		UIUtil:showIncHeroInvenDialog()
	end
end

function HeroBelt.CanUseMultipleInstance(arg_14_0)
	if DEBUG.FORCE_USE_POPUP_MODE ~= nil then
		return DEBUG.FORCE_USE_POPUP_MODE
	end
	
	return true
end

function HeroBelt.closeToggleSorter(arg_15_0)
	if arg_15_0.vars and arg_15_0.vars.sorter then
		arg_15_0.vars.sorter:show(false)
		arg_15_0.vars.sorter:hideStatFilter()
	end
end

function HeroBelt.instant_sort(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.vars.sorter:sort(arg_16_1)
end

function HeroBelt.getSortIndexInMenus(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.sorters) do
		if iter_17_1.key == arg_17_1 then
			return iter_17_0
		end
	end
end

function HeroBelt.instant_sort_by_key(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:getSortIndexInMenus(arg_18_1)
	
	if var_18_0 then
		arg_18_0:instant_sort(var_18_0)
	end
end

function HeroBelt.sort(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.vars.sort_team_tbl = {}
	
	for iter_19_0, iter_19_1 in pairs(Account:getReservedTeamSlot()) do
		local var_19_0 = AccountData.teams[iter_19_1]
		
		for iter_19_2 = 1, MAX_TEAM_UNIT_COUNT do
			if var_19_0[iter_19_2] then
				arg_19_0.vars.sort_team_tbl[var_19_0[iter_19_2].inst.uid] = true
			end
		end
	end
	
	arg_19_0.vars.sorter:sort(arg_19_1, arg_19_2)
end

function HeroBelt.setVisible(arg_20_0, arg_20_1)
	arg_20_0.vars.wnd:setVisible(arg_20_1)
end

function HeroBelt.useDim(arg_21_0, arg_21_1)
	if get_cocos_refid(arg_21_0.vars.wnd) then
		if_set_visible(arg_21_0.vars.wnd, "grow_dim", arg_21_1)
	else
		Log.e("NO REF ERROR. ")
	end
end

function HeroBelt.resetControlColors(arg_22_0)
	for iter_22_0, iter_22_1 in pairs(arg_22_0.dock.items) do
		arg_22_0:updateControlColor(arg_22_0.dock, iter_22_1)
	end
end

function HeroBelt.createControl(arg_23_0, arg_23_1, arg_23_2)
	return (arg_23_0:updateControl(arg_23_1, nil, arg_23_2))
end

function HeroBelt.updateUnitBar(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_3 = arg_24_3 or {}
	
	local var_24_0 = arg_24_0:getSortKey()
	local var_24_1 = arg_24_1:getLv()
	local var_24_2 = arg_24_1:getMaxLevel()
	local var_24_3 = var_24_0 == "Fav"
	local var_24_4 = var_24_0 == "DevoteGrade"
	local var_24_5
	
	if var_24_0 == "Stat" then
		local var_24_6 = arg_24_0.vars.sorter:getLatestStatMenu()
		
		if var_24_6 then
			var_24_5 = {
				id = var_24_6.id,
				unit_bar_opt = var_24_6.unit_bar_opt
			}
		end
	end
	
	table.merge(arg_24_3, {
		force_update = true,
		wnd = arg_24_2,
		lv = var_24_1,
		max_lv = var_24_2,
		show_fav = var_24_3,
		show_devote = var_24_4,
		index_key = var_24_0,
		stat_opts = var_24_5
	})
	
	return UIUtil:updateUnitBar(arg_24_0.vars.sort_mode, arg_24_1, arg_24_3)
end

function HeroBelt.updateControl(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_2 = arg_25_0:updateUnitBar(arg_25_3, arg_25_2)
	
	arg_25_0:updateControlColor(arg_25_1, arg_25_3, arg_25_2)
	
	return arg_25_2
end

function HeroBelt.getItems(arg_26_0)
	if not arg_26_0.dock then
		return {}
	end
	
	return arg_26_0.dock:getItems()
end

function HeroBelt.getCurrentItem(arg_27_0)
	return arg_27_0.dock:getCurrentItem()
end

function HeroBelt.clearCurrentItem(arg_28_0)
	return arg_28_0.dock:clearCurrentItem()
end

function HeroBelt.getItemCount(arg_29_0)
	return arg_29_0.dock:getItemCount()
end

function HeroBelt.getDevotionMaterialCount(arg_30_0)
	local var_30_0 = {}
	local var_30_1 = arg_30_0.vars.except_unit
	local var_30_2 = arg_30_0.vars.sort_mode
	
	if not var_30_1 then
		return 0
	end
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.o_units) do
		local var_30_3 = var_30_1 ~= iter_30_1
		
		if not var_30_1:isDevotionUpgradable(iter_30_1) then
			var_30_3 = false
		end
		
		if table.find(arg_30_0.dock:getGarbages(), iter_30_1) then
			var_30_3 = false
		end
		
		if var_30_3 then
			var_30_0[#var_30_0 + 1] = iter_30_1
		end
	end
	
	return #var_30_0
end

function HeroBelt.getCurrentControl(arg_31_0)
	return arg_31_0.dock:getCurrentControl()
end

function HeroBelt.getControl(arg_32_0, arg_32_1)
	return arg_32_0.dock:getRenderer(arg_32_1)
end

function HeroBelt.getParentControl(arg_33_0, arg_33_1)
	return arg_33_0.dock:getControl(arg_33_1)
end

function HeroBelt.updateUnit(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_1 = arg_34_1 or arg_34_0.dock:getRenderer(arg_34_2)
	
	if not arg_34_1 then
		return 
	end
	
	arg_34_3 = arg_34_3 or {}
	
	return arg_34_0:updateUnitBar(arg_34_2, arg_34_1, arg_34_3)
end

function HeroBelt.updateCurrentViewItems(arg_35_0, arg_35_1)
	local var_35_0 = math.clamp(arg_35_0.dock.index - arg_35_1, 1, arg_35_0.dock:getItemCount())
	local var_35_1 = math.clamp(arg_35_0.dock.index + arg_35_1, 1, arg_35_0.dock:getItemCount())
	
	for iter_35_0 = var_35_0, var_35_1 do
		local var_35_2 = arg_35_0.dock.items[iter_35_0]
		
		if var_35_2 then
			arg_35_0:updateUnit(nil, var_35_2)
		end
	end
end

function HeroBelt.onSelectItem(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	TutorialGuide:procGuide()
	arg_36_0:callEventHandler("select", arg_36_2, arg_36_3)
end

function HeroBelt.callEventHandler(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if UnitMain:isValid() and UnitMain:isPopupMode() and not arg_37_0.vars.priority then
		return 
	end
	
	if arg_37_0.vars.event_handler then
		if arg_37_0.vars.event_handler_arg then
			arg_37_0.vars.event_handler(arg_37_0.vars.event_handler_arg, arg_37_1, arg_37_2, arg_37_3)
		else
			arg_37_0.vars.event_handler(arg_37_1, arg_37_2, arg_37_3)
		end
	end
end

function HeroBelt.updateSelectedControlColor(arg_38_0, arg_38_1)
	arg_38_0:updateControlColor(arg_38_0.dock, arg_38_1, nil, true)
end

function HeroBelt.updateControlColor(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	arg_39_3 = arg_39_3 or arg_39_1:getRenderer(arg_39_2)
	
	if not arg_39_3 then
		return 
	end
	
	UIUtil:updateUnitBarColor(arg_39_3, arg_39_2, arg_39_0.vars.sort_mode, arg_39_4, arg_39_0.vars.except_unit, arg_39_0.vars.story_powerup_units)
end

function HeroBelt.onHighestItemUpdate(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_1:getRenderer(arg_40_2)
	
	if var_40_0 then
		arg_40_0:updateControlColor(arg_40_1, arg_40_2, var_40_0, true)
	end
	
	arg_40_0:callEventHandler("highest_item", arg_40_2)
end

function HeroBelt.onChangeCurrentItem(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_3 then
		local var_41_0 = arg_41_1:getRenderer(arg_41_3)
		
		if var_41_0 then
			arg_41_0:updateControlColor(arg_41_1, arg_41_3, var_41_0)
		end
	end
	
	if arg_41_2 then
		local var_41_1 = arg_41_1:getRenderer(arg_41_2)
		
		if var_41_1 then
			arg_41_0:updateControlColor(arg_41_1, arg_41_2, var_41_1, true)
		end
	end
	
	SoundEngine:play("event:/ui/list_scroll", {
		gap = 100
	})
	arg_41_0:callEventHandler("change", arg_41_3, arg_41_2)
end

function HeroBelt.onScroll(arg_42_0, arg_42_1, arg_42_2)
end

function HeroBelt.onPushAddButton(arg_43_0)
	print("onPushAddButton")
	arg_43_0:callEventHandler("add", arg_43_0:getCurrentItem())
end

function HeroBelt.onPushResurrectionButton(arg_44_0)
	arg_44_0:callEventHandler("resurrection", arg_44_0:getCurrentItem())
end

function HeroBelt.onSetControlScale(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	if not arg_45_3.detail then
		return 
	end
	
	if arg_45_4 < 0.1 and arg_45_0.vars.minimized then
		arg_45_3.n_name:setOpacity(0)
	elseif arg_45_3.detail:isVisible() then
		arg_45_3.n_name:setOpacity(255)
	else
		arg_45_3.n_name:setOpacity(0)
	end
end

function HeroBelt.loadConfig(arg_46_0)
	arg_46_0.vars.minimized = SAVE:get("app.unit_list_minimize")
	arg_46_0.vars.sort_team_first = SAVE:get("app.sort_team_first")
	arg_46_0.vars.show_only_lock = false
	
	local function var_46_0(arg_47_0, arg_47_1)
		if not arg_47_0 or type(arg_47_0) ~= "number" then
			return arg_47_1
		end
		
		return arg_47_0
	end
	
	arg_46_0.vars.saved_sort_index = var_46_0(Account:getConfigData("unit_list_sort_index"), 2)
	arg_46_0.vars.saved_stat_index = var_46_0(Account:getConfigData("unit_list_stat_index"), 1)
	arg_46_0.vars.hide_max_units = false
	arg_46_0.vars.hide_max_fav = false
	arg_46_0.vars.sort_index = arg_46_0.vars.saved_sort_index or 2
end

function HeroBelt.setEventHandler(arg_48_0, arg_48_1, arg_48_2)
	arg_48_0.vars.event_handler = arg_48_1
	arg_48_0.vars.event_handler_arg = arg_48_2
end

function HeroBelt.removeEventHandler(arg_49_0)
	arg_49_0.vars.event_handler = nil
	arg_49_0.vars.event_handler_arg = nil
end

function HeroBelt.destroy(arg_50_0)
	if arg_50_0.dock then
		arg_50_0.dock:destroy()
	end
	
	if arg_50_0.vars and arg_50_0.vars.sorter then
		arg_50_0.vars.sorter:destroy()
	end
	
	if arg_50_0.vars and get_cocos_refid(arg_50_0.vars.wnd) then
		arg_50_0.vars.wnd:removeFromParent()
		HeroBeltEventInterface:removeListener(arg_50_0.vars.wnd)
	end
	
	arg_50_0.vars = nil
end

function HeroBelt.isInitialized(arg_51_0)
	return arg_51_0.vars and arg_51_0.vars.wnd ~= nil and get_cocos_refid(arg_51_0.vars.wnd)
end

function HeroBelt.setSubstoryHeroes(arg_52_0, arg_52_1)
	arg_52_0.vars.story_powerup_units = {}
	arg_52_0.vars.powerup_hero1 = {}
	arg_52_0.vars.powerup_hero2 = {}
	
	local function var_52_0(arg_53_0, arg_53_1)
		for iter_53_0, iter_53_1 in pairs(arg_53_0) do
			arg_53_1[iter_53_1] = true
		end
	end
	
	local var_52_1 = string.split(arg_52_1.powerup_hero1, ",")
	local var_52_2 = string.split(arg_52_1.powerup_hero2, ",")
	
	var_52_0(var_52_1, arg_52_0.vars.story_powerup_units)
	var_52_0(var_52_2, arg_52_0.vars.story_powerup_units)
	var_52_0(var_52_1, arg_52_0.vars.powerup_hero1)
	var_52_0(var_52_2, arg_52_0.vars.powerup_hero2)
end

function HeroBelt.addFilter(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0 = arg_54_0.vars.filter_un_hash_tbl[arg_54_1][arg_54_2]
	
	arg_54_0.vars.filters[arg_54_1][var_54_0] = arg_54_3
end

function HeroBelt.loadFilterValue(arg_55_0, arg_55_1, arg_55_2)
	arg_55_1 = arg_55_1 or {}
	arg_55_0.vars.filters[arg_55_2] = {}
	
	for iter_55_0 = 1, 10 do
		local var_55_0 = arg_55_0.vars.filter_un_hash_tbl[arg_55_2][iter_55_0]
		
		if not var_55_0 then
			break
		end
		
		if arg_55_1[var_55_0] ~= nil then
			arg_55_0.vars.filters[arg_55_2][var_55_0] = arg_55_1[var_55_0]
		else
			arg_55_0.vars.filters[arg_55_2][var_55_0] = true
		end
	end
end

function HeroBelt.getSortIndex(arg_56_0)
	return arg_56_0.vars.sort_index
end

function HeroBelt.getSortKey(arg_57_0, arg_57_1)
	arg_57_1 = arg_57_1 or arg_57_0.vars.sort_index
	
	if not arg_57_1 then
		return ""
	end
	
	arg_57_1 = math.abs(arg_57_1)
	
	return arg_57_0.vars.sorters[arg_57_1].key
end

function HeroBelt.getSorter(arg_58_0)
	return arg_58_0.vars.sorter
end

function HeroBelt.getFilterCheckList(arg_59_0, arg_59_1, arg_59_2)
	return ItemFilterUtil:getFilterCheckList(arg_59_0.vars.filter_un_hash_tbl, arg_59_1, arg_59_2)
end

function HeroBelt.setupFilterValue(arg_60_0, arg_60_1)
	arg_60_1 = arg_60_1 or {}
	arg_60_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
	arg_60_0.vars.filters = {}
	
	arg_60_0:loadFilterValue(arg_60_1.star, "star")
	arg_60_0:loadFilterValue(arg_60_1.role, "role")
	arg_60_0:loadFilterValue(arg_60_1.element, "element")
	arg_60_0:loadFilterValue(arg_60_1.skill, "skill")
end

function HeroBelt.setupCheckboxValue(arg_61_0, arg_61_1, arg_61_2)
	if not arg_61_0.vars or not arg_61_1 then
		return 
	end
	
	local var_61_0 = {
		hide_max = "hide_max_units",
		dup_mode = "minimized",
		hide_max_fav = "hide_max_fav",
		show_only_lock = "show_only_lock",
		team_first = "sort_team_first",
		hide_favorite = "hide_fav_units"
	}
	local var_61_1 = arg_61_0:getCheckbox(arg_61_2)
	
	for iter_61_0, iter_61_1 in pairs(arg_61_1) do
		if table.isInclude(var_61_1, function(arg_62_0, arg_62_1)
			if iter_61_1.id == arg_62_1.id then
				return true
			end
		end) then
			local var_61_2 = var_61_0[iter_61_1.id]
			
			if var_61_2 then
				arg_61_0.vars[var_61_2] = iter_61_1.checked
			end
		end
	end
end

function HeroBelt.setupSkillFilterValue(arg_63_0, arg_63_1)
	if not arg_63_0.vars or not arg_63_1 then
		return 
	end
	
	if not arg_63_0.vars.sorter:canUseBuffFilter() then
		return 
	end
	
	arg_63_0.vars.sorter:getSkillFilter():setFilterSetting(arg_63_1)
	arg_63_0.vars.sorter:updateBuffUI()
end

function HeroBelt.resetFilter(arg_64_0)
	if not arg_64_0.vars or not arg_64_0.vars.sorter then
		return 
	end
	
	if arg_64_0.vars.sorter:getFilterActive() then
		local var_64_0 = arg_64_0:getCheckbox(arg_64_0:getSortMode())
		
		for iter_64_0, iter_64_1 in pairs(var_64_0) do
			iter_64_1.checked = iter_64_1.checked and not iter_64_1.is_filter
		end
		
		arg_64_0:setupCheckboxValue(var_64_0)
		arg_64_0.vars.sorter:changeCheckboxes(var_64_0)
		
		if arg_64_0.vars.sorter:canUseBuffFilter() then
			arg_64_0.vars.sorter:getSkillFilter():setFilterSetting()
			arg_64_0.vars.sorter:updateBuffUI()
		end
		
		arg_64_0:setFilter()
		arg_64_0:resetDataByCall()
		balloon_message_with_sound("msg_relation_reset_filter")
	end
end

function HeroBelt.changeSorterParent(arg_65_0, arg_65_1, arg_65_2)
	if arg_65_0.vars.sorter then
		arg_65_0.vars.sorter:changeParent(arg_65_1, arg_65_2)
	end
end

function HeroBelt.getCheckbox(arg_66_0, arg_66_1)
	local var_66_0 = {
		team_first = {
			id = "team_first",
			name = T("sort_team_first"),
			checked = arg_66_0.vars.sort_team_first
		},
		dup_mode = {
			id = "dup_mode",
			name = T("sort_more_unit"),
			checked = arg_66_0.vars.minimized
		},
		hide_favorite = {
			id = "hide_favorite",
			is_filter = true,
			name = T("sort_hide_favorite"),
			checked = arg_66_0.vars.hide_fav_units
		},
		show_only_lock = {
			id = "show_only_lock",
			is_filter = true,
			name = T("sort_only_lockhero"),
			checked = arg_66_0.vars.show_only_lock
		},
		hide_max = {
			id = "hide_max",
			is_filter = true,
			name = T("sort_hide_maxhero"),
			checked = arg_66_0.vars.hide_max_units
		},
		hide_max_fav = {
			id = "hide_max_fav",
			is_filter = true,
			name = T("sort_hide_max_intimacy"),
			checked = arg_66_0.vars.hide_max_fav
		}
	}
	local var_66_1 = {}
	
	local function var_66_2(arg_67_0)
		for iter_67_0, iter_67_1 in pairs(arg_67_0) do
			var_66_1[iter_67_0] = var_66_0[iter_67_1]
		end
	end
	
	if arg_66_1 == "Enhance" or arg_66_1 == "Promote" then
		var_66_2({
			"dup_mode"
		})
	elseif arg_66_1 == "SubTask" then
		var_66_2({
			"dup_mode",
			"hide_max"
		})
		
		var_66_1[2].is_filter = false
	elseif arg_66_1 == "Storage" then
		var_66_2({
			"dup_mode",
			"show_only_lock",
			"hide_max"
		})
	else
		var_66_2({
			"team_first",
			"dup_mode",
			"hide_favorite",
			"show_only_lock",
			"hide_max",
			"hide_max_fav"
		})
	end
	
	arg_66_0.vars.checkbox_tbl = var_66_1
	
	return var_66_1
end

function HeroBelt.createInstance(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_0:CanUseMultipleInstance() then
		return arg_68_0:create(arg_68_1)
	end
	
	local var_68_0 = {}
	
	copy_functions(HeroBelt, var_68_0)
	var_68_0:create(arg_68_1)
	
	var_68_0.vars.priority = arg_68_2
	
	return var_68_0
end

function HeroBelt.getInst(arg_69_0, arg_69_1)
	if not arg_69_0:CanUseMultipleInstance() then
		return arg_69_0
	end
	
	if arg_69_1 == "UnitMain" then
		if UnitMain:isValid() then
			return UnitMain:getHeroBelt()
		end
		
		return nil
	end
	
	return arg_69_0
end

function HeroBelt.getSortMenus(arg_70_0, arg_70_1)
	return {
		{
			key = "Grade",
			name = T("ui_unit_list_sort_1_label"),
			func = UnitSortOrder.greaterThanGrade
		},
		{
			key = "Level",
			name = T("ui_unit_list_sort_2_label"),
			func = UnitSortOrder.greaterThanLevel
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
		},
		{
			key = "Fav",
			name = T("sort_intimacy"),
			func = UnitSortOrder.greaterThanFav
		},
		{
			key = "DevoteGrade",
			name = T("ui_sort_memory_inscription"),
			func = UnitSortOrder.greaterThanDevoteGrade
		},
		{
			key = "UID",
			name = T("ui_unit_list_sort_4_label"),
			func = UnitSortOrder.greaterThanUID
		},
		{
			key = "Stat",
			name = T("ui_unit_list_sort_stat_label"),
			func = UnitSortOrder.makeStatSortFuncSelector(arg_70_1)
		},
		{
			key = "SubTask",
			func = UNIT.greaterThanSubTaskPoint
		},
		{
			key = "HeroStorage",
			func = UnitSortOrder.greaterThanGrade
		}
	}
end

function HeroBelt.create(arg_71_0, arg_71_1, arg_71_2)
	arg_71_0.vars = {}
	arg_71_0.vars.wnd = load_dlg("unit_list", true, "wnd")
	
	arg_71_0:setupFilterValue()
	if_set_visible(arg_71_0.vars.wnd, "layer_sort", false)
	arg_71_0:loadConfig()
	
	arg_71_0.vars.filter_setting = {}
	arg_71_0.vars.filter_save_modes = {}
	
	local var_71_0 = 60
	
	if arg_71_0.vars.minimized then
		var_71_0 = 30
	end
	
	local var_71_1 = DockFast:create({
		selected_item_pos = 0.11,
		height = 550,
		dir = "right",
		scroll_ratio = 2,
		item_size = 90,
		width = 250,
		item_gap = var_71_0,
		collision_opts = arg_71_2,
		handler = arg_71_0
	}, arg_71_0.vars.wnd:getChildByName("scrollview"))
	
	arg_71_0.dock = var_71_1
	
	arg_71_0:resetData({}, arg_71_1, nil, true)
	
	local var_71_2 = arg_71_1 == "SubTask"
	local var_71_3
	local var_71_4 = {}
	
	if var_71_2 then
		var_71_3 = arg_71_1
		var_71_4.sorting_subtask = true
		var_71_4.sort_off = true
	else
		var_71_4.sorting_unit = true
		var_71_4.stat_menu_idx = 9
	end
	
	if arg_71_1 == "Storage" then
		var_71_3 = "Storage"
	end
	
	arg_71_0.vars.sorter = Sorter:create(arg_71_0.vars.wnd:getChildByName("n_sorting"), var_71_4)
	arg_71_0.vars.sorters = arg_71_0:getSortMenus(arg_71_0.vars.sorter)
	
	if #arg_71_0.vars.sorters - 1 < arg_71_0.vars.sort_index then
		arg_71_0.vars.sort_index = 2
	end
	
	arg_71_0.vars.sorter:setSorter({
		priority_sort_func = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
			if arg_71_0.vars.sort_mode == "Substory" then
				local var_72_0 = arg_71_0:substorySortFunc(arg_72_0, arg_72_1)
				
				if var_72_0 ~= nil then
					return var_72_0
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "Enhance" then
				local var_72_1 = arg_71_0:enhanceSortFunc(arg_72_0, arg_72_1)
				
				if var_72_1 ~= nil then
					return var_72_1
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "Promote" then
				local var_72_2 = arg_71_0:upgradeSortFunc(arg_72_0, arg_72_1)
				
				if var_72_2 ~= nil then
					return var_72_2
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "MultiPromote" then
				local var_72_3 = arg_71_0:multiUpgradeSortFunc(arg_72_0, arg_72_1)
				
				if var_72_3 ~= nil then
					return var_72_3
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "growth_boost" then
				local var_72_4 = arg_71_0:growthboostSortFunc(arg_72_0, arg_72_1)
				
				if var_72_4 ~= nil then
					return var_72_4
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "Sell" then
				local var_72_5 = arg_71_0:sellSortFunc(arg_72_0, arg_72_1)
				
				if var_72_5 ~= nil then
					return var_72_5
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "Storage" then
				local var_72_6 = arg_71_0:storageSortFunc(arg_72_0, arg_72_1)
				
				if var_72_6 ~= nil then
					return var_72_6
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "worldboss" then
				local var_72_7 = arg_71_0:worldbossSortFunc(arg_72_0, arg_72_1, arg_72_2)
				
				if var_72_7 ~= nil then
					return var_72_7
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "LotaBlessing" then
				local var_72_8 = arg_71_0:lotaBleesingSortFunc(arg_72_0, arg_72_1, arg_72_2)
				
				if var_72_8 ~= nil then
					return var_72_8
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "LotaRegistrationBelt" then
				local var_72_9 = arg_71_0:lotaRegistrationSortFunc(arg_72_0, arg_72_1, arg_72_2)
				
				if var_72_9 ~= nil then
					return var_72_9
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode == "LotaReady" or arg_71_0.vars.sort_mode == "LotaInformation" then
				local var_72_10 = arg_71_0:lotaDefaultSortFunc(arg_72_0, arg_72_1, arg_72_2)
				
				if var_72_10 ~= nil then
					return var_72_10
				end
				
				return nil
			end
			
			if arg_71_0.vars.sort_mode ~= "SubTask" then
				local var_72_11 = arg_71_0:teamFirstSortFunc(arg_72_0, arg_72_1, arg_72_2)
				
				if var_72_11 ~= nil then
					return var_72_11
				end
				
				return arg_71_0:favoriteFirstSortFunc(arg_72_0, arg_72_1, arg_72_2)
			end
		end,
		default_sort_index = arg_71_0.vars.sort_index,
		default_stat_index = arg_71_0.vars.saved_stat_index,
		menus = arg_71_0.vars.sorters,
		checkboxs = arg_71_0:getCheckbox(var_71_3),
		filters = arg_71_0:getFilterTable(),
		callback_sort = function(arg_73_0, arg_73_1, arg_73_2)
			arg_71_0.dock:onAfterSort(true)
			
			arg_71_0.vars.sort_index = arg_73_1
			
			local var_73_0 = false
			
			if arg_71_0.vars.saved_sort_index ~= arg_73_1 and arg_73_2.name then
				arg_71_0.vars.saved_sort_index = arg_73_1
				
				SAVE:setTempConfigData("unit_list_sort_index", arg_71_0.vars.saved_sort_index)
				
				var_73_0 = true
			end
			
			local var_73_1 = arg_71_0.vars.sorter:getLatestStatMenuIdx()
			
			if var_73_1 and arg_71_0.vars.saved_stat_index ~= var_73_1 then
				arg_71_0.vars.saved_stat_index = var_73_1
				
				SAVE:setTempConfigData("unit_list_stat_index", arg_71_0.vars.saved_stat_index)
				
				var_73_0 = true
			end
			
			if var_73_0 then
				local var_73_2 = arg_71_0:getSortKey(arg_73_0)
				local var_73_3 = arg_71_0:getSortKey(arg_73_1)
				
				if var_73_2 == "Stat" or var_73_3 == "Stat" or var_73_2 == "Fav" or var_73_3 == "Fav" or var_73_2 == "DevoteGrade" or var_73_3 == "DevoteGrade" then
					for iter_73_0, iter_73_1 in pairs(arg_71_0.dock.controls) do
						arg_71_0:updateUnit(iter_73_1, iter_73_0)
					end
				end
			end
		end,
		callback_checkbox = function(arg_74_0, arg_74_1, arg_74_2)
			if arg_74_0 == "dup_mode" then
				arg_71_0:toggleMinimize(arg_74_2)
			end
			
			if arg_74_0 == "team_first" then
				arg_71_0:toggleSortTeamFirst(arg_74_2)
			end
			
			if arg_74_0 == "show_only_lock" then
				arg_71_0:toggleShowOnlyLock(arg_74_2)
				arg_71_0.dock:onAfterSort(true)
			end
			
			if arg_74_0 == "hide_max" then
				arg_71_0:toggleHideMaxUnits(arg_74_2)
				arg_71_0.dock:onAfterSort(true)
			end
			
			if arg_74_0 == "hide_favorite" then
				arg_71_0:toggleHideFavUnits(arg_74_2)
				arg_71_0.dock:onAfterSort(true)
			end
			
			if arg_74_0 == "hide_max_fav" then
				arg_71_0:toggleHideMaxFav(arg_74_2)
				arg_71_0.dock:onAfterSort(true)
			end
			
			if arg_74_0 == "only_devote" then
				arg_71_0:toggleOnlyDevoteUnits(arg_74_2)
				arg_71_0.dock:onAfterSort(true)
			end
		end,
		callback_on_add_filter = function(arg_75_0, arg_75_1, arg_75_2)
			arg_71_0:addFilter(arg_75_0, arg_75_1, arg_75_2)
		end,
		callback_on_commit_filter = function()
			arg_71_0.dock:clearCurrentItem()
			arg_71_0:resetData(arg_71_0.vars.o_units, arg_71_0.vars.sort_mode, arg_71_0.vars.except_unit, arg_71_0.vars.ignore_sort, nil, arg_71_0.vars.filters)
			arg_71_0.dock:onAfterSort(true)
		end,
		resetDataByCall = function()
			arg_71_0:resetDataByCall()
		end,
		callback_filter = function(arg_78_0, arg_78_1, arg_78_2)
			arg_71_0.dock:clearCurrentItem()
			arg_71_0:addFilter(arg_78_0, arg_78_1, arg_78_2)
			arg_71_0:resetData(arg_71_0.vars.o_units, arg_71_0.vars.sort_mode, arg_71_0.vars.except_unit, arg_71_0.vars.ignore_sort, nil, arg_71_0.vars.filters)
			arg_71_0.dock:onAfterSort(true)
		end
	})
	arg_71_0.vars.wnd:getChildByName("layer_unit_bar"):addChild(var_71_1.wnd)
	Scheduler:addSlow(arg_71_0.vars.wnd, arg_71_0.updateEatingUnits, arg_71_0)
	NotchManager:addListener(arg_71_0.vars.wnd:getChildByName("RIGHT"), false, function(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
		if arg_71_0.vars.sort_mode == nil or arg_71_0.vars.sort_mode == "Substory" then
			resetPosForNotch(arg_79_0, arg_79_1, {
				isLeft = false,
				origin_x = arg_79_3
			})
		else
			resetPosForNotch(arg_79_0, arg_79_1, {
				isLeft = arg_79_2,
				origin_x = arg_79_3
			})
		end
	end)
	HeroBeltEventInterface:addListener(arg_71_0.vars.wnd, arg_71_0)
	
	return arg_71_0
end

function HeroBelt.substorySortFunc(arg_80_0, arg_80_1, arg_80_2)
	if not arg_80_0.vars or not arg_80_0.vars.powerup_hero1 or not arg_80_0.vars.story_powerup_units then
		return nil
	end
	
	if arg_80_0.vars.powerup_hero1[arg_80_1.db.code] ~= arg_80_0.vars.powerup_hero1[arg_80_2.db.code] then
		return arg_80_0.vars.powerup_hero1[arg_80_1.db.code] ~= nil
	end
	
	local var_80_0 = arg_80_0.vars.story_powerup_units[arg_80_1.db.code]
	local var_80_1 = arg_80_0.vars.story_powerup_units[arg_80_2.db.code]
	
	if var_80_0 ~= nil and var_80_1 == nil then
		return true
	end
	
	if var_80_0 == nil and var_80_1 ~= nil then
		return false
	end
	
	return nil
end

function HeroBelt.devoteSort(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	local var_81_0 = arg_81_0.vars.except_unit:isDevotionUpgradable(arg_81_1)
	local var_81_1 = arg_81_0.vars.except_unit:isDevotionUpgradable(arg_81_2)
	
	if var_81_0 and not var_81_1 then
		return true
	end
	
	if var_81_1 and not var_81_0 then
		return false
	end
	
	if var_81_0 == var_81_1 and var_81_0 == true then
		local var_81_2 = arg_81_1:isDevotionUnit()
		local var_81_3 = arg_81_2:isDevotionUnit()
		
		if var_81_2 ~= var_81_3 and arg_81_3 then
			return not var_81_2
		elseif var_81_2 ~= var_81_3 then
			return var_81_2
		end
	end
	
	return nil
end

function HeroBelt.enhanceSortFunc(arg_82_0, arg_82_1, arg_82_2)
	local var_82_0 = not arg_82_1:isCanBeMaterial(arg_82_0.vars.except_unit, nil, arg_82_0.vars.sort_team_tbl)
	local var_82_1 = not arg_82_2:isCanBeMaterial(arg_82_0.vars.except_unit, nil, arg_82_0.vars.sort_team_tbl)
	
	if var_82_0 == false and var_82_1 ~= false then
		return true
	end
	
	if var_82_0 ~= false and var_82_1 == false then
		return false
	end
	
	if arg_82_1:isExpUnit() and arg_82_2:isExpUnit() then
		local var_82_2 = to_n(arg_82_1.db.exp)
		local var_82_3 = to_n(arg_82_2.db.exp)
		
		if var_82_2 ~= var_82_3 then
			return var_82_2 < var_82_3
		end
	elseif arg_82_1:isExpUnit() ~= arg_82_2:isExpUnit() then
		return arg_82_1:isExpUnit()
	end
	
	if arg_82_0.vars.except_unit then
		local var_82_4 = arg_82_0:devoteSort(arg_82_1, arg_82_2, true)
		
		if var_82_4 ~= nil then
			return var_82_4
		end
	end
	
	local var_82_5 = arg_82_1:isPromotionUnit()
	local var_82_6 = arg_82_2:isPromotionUnit()
	
	if var_82_5 and not var_82_6 then
		return false
	end
	
	if not var_82_5 and var_82_6 then
		return true
	end
end

function HeroBelt.sellSortFunc(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = arg_83_0.vars.sort_team_tbl or {}
	local var_83_1 = not arg_83_1:isCanBeMaterial(nil, "Sell", var_83_0)
	local var_83_2 = not arg_83_2:isCanBeMaterial(nil, "Sell", var_83_0)
	
	if var_83_1 == false and var_83_2 ~= false then
		return true
	end
	
	if var_83_1 ~= false and var_83_2 == false then
		return false
	end
	
	local var_83_3 = arg_83_1:isPromotionUnit() or arg_83_1:isExpUnit()
	local var_83_4 = arg_83_2:isPromotionUnit() or arg_83_2:isExpUnit()
	
	if var_83_3 and not var_83_4 then
		return false
	end
	
	if var_83_4 and not var_83_3 then
		return true
	end
	
	return nil
end

function HeroBelt.storageSortFunc(arg_84_0, arg_84_1, arg_84_2)
	local var_84_0 = arg_84_1:getUsableCodeList(nil, "Storage")
	local var_84_1 = arg_84_2:getUsableCodeList(nil, "Storage")
	
	if var_84_0 and not var_84_1 then
		return false
	end
	
	if var_84_1 and not var_84_0 then
		return true
	end
	
	return nil
end

function HeroBelt.worldbossSortFunc(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	if not arg_85_1.isExclude and arg_85_2.isExclude then
		return true
	end
	
	if arg_85_1.isExclude and not arg_85_2.isExclude then
		return false
	end
	
	return arg_85_0:teamFirstSortFunc(arg_85_1, arg_85_2, arg_85_3)
end

function HeroBelt.lotaBleesingSortFunc(arg_86_0, arg_86_1, arg_86_2)
	local var_86_0 = LotaUserData:isUsableUnit(arg_86_1)
	local var_86_1 = LotaUserData:isUsableUnit(arg_86_2)
	
	if var_86_0 and not var_86_1 then
		return false
	end
	
	if var_86_1 and not var_86_0 then
		return true
	end
	
	return nil
end

function HeroBelt.lotaRegistrationSortFunc(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = LotaUserData:isExistRegistrationByCode(arg_87_1.db.code) or LotaUserData:isExistRegistrationByGroup(arg_87_1.db.set_group)
	local var_87_1 = LotaUserData:isExistRegistrationByCode(arg_87_2.db.code) or LotaUserData:isExistRegistrationByGroup(arg_87_2.db.set_group)
	
	if var_87_0 and not var_87_1 then
		return false
	end
	
	if var_87_1 and not var_87_0 then
		return true
	end
	
	return nil
end

function HeroBelt.lotaDefaultSortFunc(arg_88_0, arg_88_1, arg_88_2)
	local var_88_0 = LotaUserData:isUsableUnit(arg_88_1)
	local var_88_1 = LotaUserData:isUsableUnit(arg_88_2)
	
	if var_88_0 and not var_88_1 then
		return true
	end
	
	if var_88_1 and not var_88_0 then
		return false
	end
	
	return nil
end

function HeroBelt.teamFirstSortFunc(arg_89_0, arg_89_1, arg_89_2, arg_89_3)
	if arg_89_3.team_first then
		local var_89_0 = arg_89_1:isInTeam()
		
		if var_89_0 ~= arg_89_2:isInTeam() then
			return var_89_0
		end
	end
	
	return nil
end

function HeroBelt.favoriteFirstSortFunc(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	if not arg_90_3.hide_fav_units then
		local var_90_0 = arg_90_1:isFavoriteUnit()
		
		if var_90_0 ~= arg_90_2:isFavoriteUnit() then
			return var_90_0
		end
	end
	
	return nil
end

function HeroBelt.multiUpgradeSortFunc(arg_91_0, arg_91_1, arg_91_2)
	if not arg_91_0.vars.except_unit then
		return nil
	end
	
	local var_91_0 = not arg_91_1:isCanBeMaterial(arg_91_0.vars.except_unit, nil, arg_91_0.vars.sort_team_tbl)
	local var_91_1 = not arg_91_2:isCanBeMaterial(arg_91_0.vars.except_unit, nil, arg_91_0.vars.sort_team_tbl)
	
	if var_91_0 == false and var_91_1 ~= false then
		return true
	end
	
	if var_91_0 ~= false and var_91_1 == false then
		return false
	end
	
	local var_91_2 = arg_91_0.vars.except_unit:getGrade() == arg_91_1:getGrade()
	local var_91_3 = arg_91_0.vars.except_unit:getGrade() == arg_91_2:getGrade()
	
	if var_91_2 ~= false and var_91_3 == false then
		return true
	end
	
	if var_91_2 == false and var_91_3 ~= false then
		return false
	end
	
	return nil
end

function HeroBelt.growthboostSortFunc(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = GrowthBoost:isUnregisterable(arg_92_1)
	local var_92_1 = GrowthBoost:isUnregisterable(arg_92_2)
	
	if var_92_0 == false and var_92_1 ~= false then
		return true
	end
	
	if var_92_0 ~= false and var_92_1 == false then
		return false
	end
	
	return nil
end

function HeroBelt.upgradeSortFunc(arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = not arg_93_1:isCanBeMaterial(arg_93_0.vars.except_unit, nil, arg_93_0.vars.sort_team_tbl)
	local var_93_1 = not arg_93_2:isCanBeMaterial(arg_93_0.vars.except_unit, nil, arg_93_0.vars.sort_team_tbl)
	
	if var_93_0 == false and var_93_1 ~= false then
		return true
	end
	
	if var_93_0 ~= false and var_93_1 == false then
		return false
	end
	
	if arg_93_0.vars.except_unit then
		local var_93_2 = arg_93_0:devoteSort(arg_93_1, arg_93_2)
		
		if var_93_2 ~= nil then
			return var_93_2
		end
	end
	
	local var_93_3 = arg_93_1:isPromotionUnit()
	local var_93_4 = arg_93_2:isPromotionUnit()
	local var_93_5 = var_93_3 and arg_93_1:getBaseGrade() < arg_93_1:getGrade() and arg_93_1:getLv() < arg_93_1:getMaxLevel()
	local var_93_6 = var_93_4 and arg_93_2:getBaseGrade() < arg_93_2:getGrade() and arg_93_2:getLv() < arg_93_2:getMaxLevel()
	local var_93_7 = var_93_3 and arg_93_1:getLv() == arg_93_1:getMaxLevel()
	local var_93_8 = var_93_4 and arg_93_2:getLv() == arg_93_2:getMaxLevel()
	
	if var_93_7 and not var_93_8 then
		return false
	end
	
	if var_93_8 and not var_93_7 then
		return true
	end
	
	if var_93_5 and not var_93_6 then
		return true
	end
	
	if not var_93_5 and var_93_6 then
		return false
	end
	
	return nil
end

function HeroBelt.checkFilterValue(arg_94_0, arg_94_1, arg_94_2)
	local var_94_0 = arg_94_1:getGrade()
	
	if not arg_94_2.star[var_94_0] then
		return false
	end
	
	local var_94_1 = arg_94_1.db.role
	
	if not arg_94_2.role[var_94_1] then
		return false
	end
	
	local var_94_2 = arg_94_1:getColor()
	
	if not arg_94_2.element[var_94_2] then
		return false
	end
	
	return true
end

function HeroBelt.isResetData(arg_95_0, arg_95_1)
	if arg_95_0.vars.force_reset_data then
		arg_95_0.vars.force_reset_data = nil
		
		return true
	end
	
	if arg_95_1 == "Skill" or arg_95_1 == "ReadyUpgrade" or arg_95_1 == "Bistro" or arg_95_1 == "Promote" or arg_95_1 == "Enhance" or arg_95_1 == "Sell" or arg_95_1 == "SubTask" or arg_95_1 == "worldboss" or arg_95_1 == "worldbossSupporter" or arg_95_1 == "MultiPromote" or arg_95_1 == "Storage" or arg_95_1 == "growth_boost" or arg_95_0.vars.show_only_lock or arg_95_0.vars.filters then
		return true
	end
	
	return false
end

function HeroBelt.isCanHideLockUnitMode(arg_96_0, arg_96_1)
	return arg_96_1 ~= "Enhance" and arg_96_1 ~= "Promote" and arg_96_1 ~= "SubTask"
end

function HeroBelt.getFilterTable(arg_97_0, arg_97_1)
	arg_97_1 = arg_97_1 or {}
	
	return {
		star = {
			id = "star",
			check_list = arg_97_0:getFilterCheckList("star", arg_97_1.star)
		},
		role = {
			id = "role",
			check_list = arg_97_0:getFilterCheckList("role", arg_97_1.role)
		},
		element = {
			id = "element",
			check_list = arg_97_0:getFilterCheckList("element", arg_97_1.element)
		},
		skill = {
			id = "skill",
			check_list = arg_97_0:getFilterCheckList("skill", arg_97_1.skill)
		}
	}
end

function HeroBelt.tempSaveFilter(arg_98_0, arg_98_1)
	arg_98_0.vars.filter_save_modes[arg_98_1] = true
end

function HeroBelt.clearTempSaveFilter(arg_99_0, arg_99_1)
	arg_99_0.vars.filter_save_modes[arg_99_1] = false
	
	if arg_99_0.vars.filter_setting[arg_99_1] then
		arg_99_0.vars.filter_setting[arg_99_1] = nil
	end
	
	if arg_99_0.vars.sorter:canUseBuffFilter() then
		arg_99_0.vars.sorter:getSkillFilter():clearFilterSetting(arg_99_1)
	end
end

function HeroBelt.getFilterSetting(arg_100_0, arg_100_1)
	return arg_100_0.vars.filter_setting[arg_100_1]
end

function HeroBelt.getSkillFilterSetting(arg_101_0)
	if not arg_101_0.vars then
		return 
	end
	
	local var_101_0 = arg_101_0.vars.sorter:getSkillFilter()
	
	return arg_101_0.vars.sorter:canUseBuffFilter() and var_101_0:getFilterSetting()
end

function HeroBelt.changeMode(arg_102_0, arg_102_1)
	if not arg_102_1 then
		return 
	end
	
	if arg_102_0.vars.sort_mode ~= arg_102_1 then
		local var_102_0 = arg_102_0.vars.sort_mode
		
		arg_102_0.vars.sort_mode = arg_102_1
		
		if arg_102_0.vars.sorter and arg_102_0.vars.filter_save_modes[arg_102_1] then
			arg_102_0:setFilter(arg_102_0.vars.filter_setting[arg_102_1], arg_102_0.vars.except_unit, nil, var_102_0, arg_102_1)
		elseif arg_102_0.vars.sorter then
			arg_102_0:setFilter(nil, arg_102_0.vars.except_unit, nil, var_102_0, arg_102_1)
		end
	end
end

function HeroBelt.setFilter(arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5)
	arg_103_0:setupFilterValue(arg_103_1)
	
	if arg_103_4 and arg_103_5 and arg_103_4 ~= arg_103_5 then
		arg_103_0.vars.sorter:changeMode(arg_103_4, arg_103_5)
	end
	
	arg_103_0.vars.sorter:setFilters(arg_103_0:getFilterTable(arg_103_1))
	arg_103_0:resetData(arg_103_0.vars.o_units, arg_103_0.vars.sort_mode, arg_103_2, arg_103_3, nil, arg_103_0.vars.filters)
	
	if arg_103_4 and arg_103_5 and arg_103_4 ~= arg_103_5 then
		arg_103_0.vars.sorter:updateSkillFilterAllValue()
	end
end

function HeroBelt.changeCheckboxes(arg_104_0, arg_104_1)
	if not arg_104_0.vars.sorter then
		return 
	end
	
	local var_104_0 = arg_104_0:getCheckbox(arg_104_1)
	
	arg_104_0.vars.sorter:changeCheckboxes(var_104_0)
end

function HeroBelt.resetDataUseFilter(arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5)
	local var_105_0 = arg_105_0.vars.filters
	
	if arg_105_4 then
		arg_105_2 = arg_105_0.vars.sort_mode
	end
	
	if arg_105_5 then
		arg_105_0.vars.force_reset_data = arg_105_5
	end
	
	if arg_105_2 ~= arg_105_0.vars.sort_mode then
		var_105_0 = nil
	end
	
	arg_105_0:resetData(arg_105_1, arg_105_2, arg_105_3, nil, nil, var_105_0)
	
	if arg_105_5 then
		arg_105_0.vars.force_reset_data = nil
	end
end

function HeroBelt.rollbackToggle(arg_106_0)
	if arg_106_0.vars.sorter then
		arg_106_0:setToggle("hide_max", false)
		arg_106_0:setToggle("only_devote", false)
	end
end

function HeroBelt.resetDataByCall(arg_107_0)
	arg_107_0.dock:clearCurrentItem()
	arg_107_0:resetData(arg_107_0.vars.o_units, arg_107_0.vars.sort_mode, arg_107_0.vars.except_unit, arg_107_0.vars.ignore_sort, nil, arg_107_0.vars.filters)
	arg_107_0.dock:onAfterSort(true)
end

function HeroBelt.resetDataByImprintSwitch(arg_108_0)
	if arg_108_0:getSortKey() ~= "Stat" then
		return 
	end
	
	local var_108_0 = arg_108_0.dock:getCurrentItem()
	
	arg_108_0:resetData(arg_108_0.vars.o_units, arg_108_0.vars.sort_mode, arg_108_0.vars.except_unit, arg_108_0.vars.ignore_sort, nil, arg_108_0.vars.filters)
	arg_108_0.dock:jumpToItem(var_108_0)
end

function HeroBelt.resetData(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5, arg_109_6, arg_109_7)
	if DEBUG.HEROBELT and #arg_109_1 > 0 then
		Log.e("resetData begin", arg_109_2, #arg_109_1)
	end
	
	if arg_109_7 then
		local var_109_0 = arg_109_0:getSortIndexInMenus(arg_109_7)
		
		if var_109_0 then
			arg_109_5 = var_109_0
		end
	end
	
	arg_109_0.vars.o_units = arg_109_1
	
	local var_109_1 = arg_109_1
	
	if arg_109_2 ~= nil and arg_109_6 ~= nil and arg_109_0.vars.sorter ~= nil and arg_109_0.vars.filter_save_modes[arg_109_2] then
		arg_109_0.vars.filter_setting[arg_109_2] = arg_109_6
	end
	
	local var_109_2
	
	arg_109_2 = arg_109_2 or arg_109_0.vars.sort_mode
	
	local var_109_3 = arg_109_0.vars.sort_mode ~= arg_109_2
	local var_109_4 = arg_109_0.vars.sort_mode
	
	arg_109_0.vars.sort_mode = arg_109_2
	
	if var_109_3 and arg_109_0.vars.sorter then
		arg_109_0:changeCheckboxes(arg_109_2)
	end
	
	if arg_109_2 ~= nil and (arg_109_2 == "Enhance" or arg_109_2 == "Promote" or arg_109_2 == "MultiPromote") then
		arg_109_0.vars.except_unit = arg_109_3
	else
		arg_109_0.vars.except_unit = nil
	end
	
	if arg_109_2 ~= nil and var_109_3 and arg_109_0.vars.sorter and arg_109_0.vars.filter_save_modes[arg_109_2] then
		arg_109_0:setFilter(arg_109_0.vars.filter_setting[arg_109_2], arg_109_3, arg_109_4, var_109_4, arg_109_2)
		arg_109_0:rollbackToggle()
		
		return 
	elseif arg_109_2 ~= nil and var_109_3 and arg_109_0.vars.sorter then
		arg_109_0:setFilter(nil, arg_109_3, arg_109_4, var_109_4, arg_109_2)
		arg_109_0:rollbackToggle()
		
		return 
	end
	
	if arg_109_0:isResetData(arg_109_2) then
		var_109_1 = {}
		
		for iter_109_0, iter_109_1 in pairs(arg_109_1) do
			local var_109_5 = arg_109_3 ~= iter_109_1 or arg_109_2 == "Detail" and arg_109_3 == iter_109_1
			
			if var_109_5 and arg_109_6 then
				var_109_5 = arg_109_0:checkFilterValue(iter_109_1, arg_109_6)
			end
			
			if arg_109_2 == "Promote" or arg_109_2 == "Enhance" or arg_109_2 == "Sell" then
				if var_109_5 and arg_109_2 == "Promote" then
					var_109_5 = arg_109_3 and arg_109_3:isDevotionUpgradable(iter_109_1)
				end
				
				if arg_109_2 == "Sell" and iter_109_1:isDevotionUnit() and not iter_109_1:checkDevotionUnitCanSell() then
					var_109_5 = false
				end
				
				if arg_109_2 == "Promote" or arg_109_2 == "Enhance" then
					if iter_109_1:isDevotionUnit() and not arg_109_3:isDevotionUpgradable(iter_109_1) then
						var_109_5 = false
					end
					
					if var_109_5 and arg_109_0.vars.show_only_devote and arg_109_3 and not arg_109_3:isDevotionUpgradable(iter_109_1) then
						var_109_5 = false
					end
					
					local var_109_6 = DB("classchange_category", "cc_" .. arg_109_3.db.code, {
						"char_id_cc"
					}) and iter_109_1.db.code == 
					
					if arg_109_2 == "Enhance" and (iter_109_1.db.code ~= arg_109_3.db.code or var_109_6 == true) and not arg_109_3:isDevotionUpgradable(iter_109_1) then
						var_109_5 = false
					end
				end
			end
			
			if arg_109_2 == "MultiPromote" and not isCanMaterialInMultiPromote(iter_109_1) then
				var_109_5 = false
			end
			
			if (arg_109_2 == "LotaReady" or arg_109_2 == "LotaInformation" or arg_109_2 == "LotaBlessing") and not LotaUserData:isRegistration(iter_109_1) then
				var_109_5 = false
			end
			
			if (arg_109_2 == "LotaRegistration" or arg_109_2 == "LotaRegistrationBelt") and (iter_109_1:isSpecialUnit() or iter_109_1:isPromotionUnit() or iter_109_1:isDevotionUnit() or iter_109_1:isMoonlightDestinyUnit()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_0.vars.show_only_lock and arg_109_0:isCanHideLockUnitMode(arg_109_2) and not iter_109_1:isLocked() then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_0.vars.hide_max_units and arg_109_2 ~= "Enhance" and arg_109_2 ~= "Promote" and iter_109_1:isMaxLevel() then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_0.vars.hide_fav_units and iter_109_1:isFavoriteUnit() then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_0.vars.hide_max_fav and iter_109_1:getFavLevel() >= 10 then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "SubTask" and (iter_109_1:isSpecialUnit() or iter_109_1:isPromotionUnit() or iter_109_1:isDevotionUnit() or iter_109_1:isMoonlightDestinyUnit()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "Skill" and (iter_109_1:isSpecialUnit() or iter_109_1:isPromotionUnit() or iter_109_1:isDevotionUnit()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "Detail" and iter_109_1:isSpecialUnit() then
				var_109_5 = false
			end
			
			if var_109_5 and iter_109_1:isExpUnit() then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "ArenaNet" and (iter_109_1:isSpecialUnit() or iter_109_1:isDevotionUnit() or iter_109_1:isMoonlightDestinyUnit()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "Storage" and (iter_109_1:isSpecialUnit() or iter_109_1:isPromotionUnit() or iter_109_1:isDevotionUnit() or iter_109_1:isMoonlightDestinyUnit()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "Sell" and iter_109_1:isMoonlightDestinyUnit() then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "Bistro" then
				var_109_5 = iter_109_1:isEating() or iter_109_1:getHPRatio() ~= 1
			end
			
			if var_109_5 and arg_109_2 == "ReadyUpgrade" then
				var_109_5 = (iter_109_1:getLv() ~= iter_109_1:getMaxLevel() or iter_109_1:getGrade() < 6) and not iter_109_1:isSpecialUnit()
			end
			
			if var_109_5 and arg_109_2 == "Promote" and arg_109_3 and arg_109_3:getLv() == 60 then
				var_109_5 = arg_109_3:isDevotionUpgradable(iter_109_1) and iter_109_1 ~= arg_109_3
			end
			
			if table.find(arg_109_0.dock:getGarbages(), iter_109_1) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "worldbossSupporter" and (iter_109_1:isSpecialUnit() or iter_109_1:isPromotionUnit() or iter_109_1:isDevotionUnit() or iter_109_1:isMoonlightDestinyUnit() or iter_109_1:isGrowthBoostRegistered()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "worldboss" and (iter_109_1:isSpecialUnit() or iter_109_1:isPromotionUnit() or iter_109_1:isDevotionUnit() or iter_109_1:isGrowthBoostRegistered()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_2 == "growth_boost" then
			end
			
			if var_109_5 and arg_109_2 == "Support" and (iter_109_1:isMoonlightDestinyUnit() or iter_109_1:isGrowthBoostRegistered()) then
				var_109_5 = false
			end
			
			if var_109_5 and arg_109_0.vars.sorter and arg_109_0.vars.sorter:canUseBuffFilter() then
				local var_109_7 = arg_109_0.vars.sorter:getSkillFilter()
				
				if var_109_7 and not var_109_7:checkUnit(iter_109_1:getUID()) then
					var_109_5 = false
				end
			end
			
			if var_109_5 then
				var_109_1[#var_109_1 + 1] = iter_109_1
			end
		end
	end
	
	arg_109_0.dock:setData(var_109_1, arg_109_0.dock:getGarbages())
	
	if arg_109_0.vars.sorter and arg_109_2 ~= "MultiPromote" then
		arg_109_0.vars.sorter:setItems(arg_109_0.dock.items)
		arg_109_0:sort(arg_109_5, true)
	end
	
	if arg_109_2 == "Enhance" or arg_109_2 == "Promote" or arg_109_2 == "MultiPromote" then
		if arg_109_0.vars.sorter and arg_109_2 == "MultiPromote" then
			arg_109_0.vars.sorter:setItems(arg_109_0.dock.items)
			arg_109_0:sort(arg_109_5, true)
		end
	else
		arg_109_0.dock:jumpToItem(arg_109_3)
	end
	
	if not arg_109_4 then
		arg_109_0:resetControlColors()
		arg_109_0.dock:arrangeItems()
		arg_109_0:updateHeroCount()
	end
	
	if arg_109_0.vars.sorter then
		arg_109_0.vars.sorter:updateToggleButton()
	end
	
	if get_cocos_refid(arg_109_0.vars.wnd) then
		local var_109_8 = arg_109_0.vars.wnd:findChildByName("n_info")
		
		if_set_visible(var_109_8, nil, #var_109_1 == 0)
		if_set(var_109_8, "label", T("ui_unit_list_none"))
	end
	
	if DEBUG.HEROBELT and #arg_109_1 > 0 then
		Log.e("resetData end")
	end
end

function HeroBelt.onShowItem(arg_110_0, arg_110_1, arg_110_2)
	arg_110_0:updateUnit(arg_110_1, arg_110_2)
end

function HeroBelt.onRemoveUnit(arg_111_0)
	arg_111_0:updateHeroCount()
end

function HeroBelt.checkToggleValue(arg_112_0, arg_112_1)
	local var_112_0 = arg_112_0.vars.sort_mode
	local var_112_1 = arg_112_0.vars.except_unit
	
	if not arg_112_1 then
		return true
	end
	
	if var_112_0 ~= "Enhance" and var_112_0 ~= "Promote" and arg_112_0.vars.show_only_lock and not arg_112_1:isLocked() then
		return false
	end
	
	if var_112_0 ~= "Enhance" and var_112_0 ~= "Promote" and arg_112_0.vars.hide_max_units and arg_112_1:isMaxLevel() then
		return false
	end
	
	if var_112_0 ~= "Enhance" and var_112_0 ~= "Promote" and arg_112_0.vars.hide_fav_units and arg_112_1:isFavoriteUnit() then
		return false
	end
	
	if var_112_0 ~= "Enhance" and var_112_0 ~= "Promote" and arg_112_0.vars.hide_max_fav and arg_112_1:getFavLevel() >= 10 then
		return false
	end
	
	if not var_112_1 then
		return true
	end
	
	if (var_112_0 == "Enhance" or var_112_0 == "Promote") and arg_112_0.vars.show_only_devote and not var_112_1:isDevotionUpgradable(arg_112_1) then
		return false
	end
	
	return true
end

function HeroBelt.revertPoppedItem(arg_113_0, arg_113_1)
	if arg_113_1 and arg_113_0.vars.filters and (not arg_113_0:checkFilterValue(arg_113_1, arg_113_0.vars.filters) or not arg_113_0:checkToggleValue(arg_113_1)) then
		arg_113_0.dock:removeFromGarbage(arg_113_1)
		
		return 
	elseif arg_113_1 and not arg_113_0:checkToggleValue(arg_113_1) then
		arg_113_0.dock:removeFromGarbage(arg_113_1)
		
		return 
	end
	
	arg_113_0.dock:revertGarbageItem(arg_113_1)
	arg_113_0.vars.sorter:setItems(arg_113_0.dock.items)
	arg_113_0:sort(nil, true)
	arg_113_0.dock:arrangeItems()
	arg_113_0:updateHeroCount()
	arg_113_0:updateControlsOpacity()
end

function HeroBelt.clearPoppedItems(arg_114_0)
	arg_114_0.dock:clearGarbageItems()
end

function HeroBelt.popItem(arg_115_0, arg_115_1)
	arg_115_1 = arg_115_1 or arg_115_0.dock:getCurrentItem()
	
	arg_115_0.dock:removeItem(arg_115_1, true)
	arg_115_0:updateHeroCount()
end

function HeroBelt.popItems(arg_116_0, arg_116_1)
	arg_116_0.dock:removeItems(arg_116_1, true)
	arg_116_0:updateHeroCount()
end

function HeroBelt.removeItem(arg_117_0, arg_117_1)
	arg_117_1 = arg_117_1 or arg_117_0.dock:getCurrentItem()
	
	arg_117_0.dock:removeItem(arg_117_1)
	arg_117_0:updateHeroCount()
end

function HeroBelt.removeSafely(arg_118_0, arg_118_1)
	if not arg_118_1 then
		return 
	end
	
	arg_118_0.dock:removeSafely(arg_118_1)
end

function HeroBelt.endRemoveSafely(arg_119_0)
	arg_119_0.dock:endRemoveSafely()
	arg_119_0:updateHeroCount()
end

function HeroBelt.updateHeroCount(arg_120_0)
	if not arg_120_0.vars then
		return 
	end
	
	local var_120_0 = arg_120_0.vars.count_parent or arg_120_0.vars.wnd
	
	if_set(var_120_0, "status", arg_120_0.dock.item_count .. "/" .. Account:getCurrentHeroCount())
end

function HeroBelt.changeCountParent(arg_121_0, arg_121_1)
	if not arg_121_0.vars then
		return 
	end
	
	arg_121_0.vars.count_parent = arg_121_1
end

function HeroBelt.updateControls(arg_122_0)
	local var_122_0 = arg_122_0.dock:getItems()
	
	for iter_122_0, iter_122_1 in pairs(var_122_0) do
		local var_122_1 = arg_122_0.dock:getRenderer(iter_122_1)
		
		if var_122_1 then
			arg_122_0:updateControl(arg_122_0.dock, var_122_1, iter_122_1)
		end
	end
end

function HeroBelt.update(arg_123_0)
	arg_123_0:sort(nil, true)
	arg_123_0.dock:arrangeItems()
	arg_123_0:updateHeroCount()
	arg_123_0:updateControls()
	arg_123_0:updateControlsOpacity()
end

function HeroBelt.setToggle(arg_124_0, arg_124_1, arg_124_2)
	if not arg_124_0.vars or not arg_124_0.vars.sorter then
		return 
	end
	
	local var_124_0
	
	for iter_124_0, iter_124_1 in pairs(arg_124_0.vars.checkbox_tbl) do
		if iter_124_1.id == arg_124_1 then
			var_124_0 = iter_124_0
		end
	end
	
	if not var_124_0 then
		return 
	end
	
	arg_124_0.vars.sorter:setToggle(var_124_0, arg_124_2)
end

function HeroBelt.toggleSortTeamFirst(arg_125_0, arg_125_1)
	if arg_125_1 == nil then
		arg_125_0.vars.sort_team_first = not arg_125_0.vars.sort_team_first
	else
		arg_125_0.vars.sort_team_first = arg_125_1
	end
	
	arg_125_0:sort()
	
	if SAVE:get("app.sort_team_first") ~= arg_125_0.vars.sort_team_first then
		SAVE:set("app.sort_team_first", arg_125_0.vars.sort_team_first)
	end
end

function HeroBelt.toggleShowOnlyLock(arg_126_0, arg_126_1)
	if arg_126_0.vars.sort_mode == "Enhance" then
		return 
	end
	
	if arg_126_1 == nil then
		arg_126_0.vars.show_only_lock = not arg_126_0.vars.show_only_lock
	else
		arg_126_0.vars.show_only_lock = arg_126_1
	end
	
	arg_126_0:resetData(arg_126_0.vars.o_units, arg_126_0.vars.sort_mode, arg_126_0.vars.except_unit, arg_126_0.vars.ignore_sort, nil, arg_126_0.vars.filters)
end

function HeroBelt.toggleHideMaxUnits(arg_127_0, arg_127_1)
	if arg_127_1 == nil then
		arg_127_0.vars.hide_max_units = not arg_127_0.vars.hide_max_units
	else
		arg_127_0.vars.hide_max_units = arg_127_1
	end
	
	arg_127_0:resetData(arg_127_0.vars.o_units, arg_127_0.vars.sort_mode, arg_127_0.vars.except_unit, arg_127_0.vars.ignore_sort, nil, arg_127_0.vars.filters)
end

function HeroBelt.toggleHideMaxFav(arg_128_0, arg_128_1)
	if arg_128_1 == nil then
		arg_128_0.vars.hide_max_fav = not arg_128_0.vars.hide_max_fav
	else
		arg_128_0.vars.hide_max_fav = arg_128_1
	end
	
	arg_128_0:resetData(arg_128_0.vars.o_units, arg_128_0.vars.sort_mode, arg_128_0.vars.except_unit, arg_128_0.vars.ignore_sort, nil, arg_128_0.vars.filters)
end

function HeroBelt.toggleHideFavUnits(arg_129_0, arg_129_1)
	if arg_129_1 == nil then
		arg_129_0.vars.hide_fav_units = not arg_129_0.vars.hide_fav_units
	else
		arg_129_0.vars.hide_fav_units = arg_129_1
	end
	
	arg_129_0:resetData(arg_129_0.vars.o_units, arg_129_0.vars.sort_mode, arg_129_0.vars.except_unit, arg_129_0.vars.ignore_sort, nil, arg_129_0.vars.filters)
end

function HeroBelt.toggleOnlyDevoteUnits(arg_130_0, arg_130_1)
	if arg_130_1 == nil then
		arg_130_0.vars.show_only_devote = not arg_130_0.vars.show_only_devote
	else
		arg_130_0.vars.show_only_devote = arg_130_1
	end
	
	arg_130_0:resetData(arg_130_0.vars.o_units, arg_130_0.vars.sort_mode, arg_130_0.vars.except_unit, arg_130_0.vars.ignore_sort, nil, arg_130_0.vars.filters)
end

function HeroBelt.updateControlsOpacity(arg_131_0)
	arg_131_0.dock:updateRenderers(function(arg_132_0)
		arg_132_0:findChildByName("n_name"):setOpacity(255)
	end)
end

function HeroBelt.toggleMinimize(arg_133_0, arg_133_1)
	if arg_133_1 == nil then
		arg_133_0.vars.minimized = not arg_133_0.vars.minimized
	else
		arg_133_0.vars.minimized = arg_133_1
	end
	
	if arg_133_0.vars.minimized then
		arg_133_0.dock:changeItemGap(30)
	else
		arg_133_0.dock:changeItemGap(60)
	end
	
	for iter_133_0, iter_133_1 in pairs(arg_133_0.dock.controls) do
		arg_133_0:onSetControlScale(arg_133_0.dock, iter_133_0, iter_133_1, iter_133_1:getScale())
		
		if get_cocos_refid(iter_133_1.renderer) and not arg_133_0.vars.minimized then
			iter_133_1:findChildByName("n_name"):setOpacity(255)
		end
	end
	
	if SAVE:get("app.unit_list_minimize") ~= arg_133_0.vars.minimized then
		SAVE:set("app.unit_list_minimize", arg_133_0.vars.minimized)
	end
end

function HeroBelt.scrollToFirstUnit(arg_134_0, arg_134_1)
	arg_134_0.dock:scrollToItem(arg_134_0:getItems()[1], arg_134_1)
end

function HeroBelt.scrollToUnit(arg_135_0, arg_135_1, arg_135_2)
	arg_135_0.dock:scrollToItem(arg_135_1, arg_135_2)
end

function HeroBelt.updateEatingUnits(arg_136_0)
	if not arg_136_0.vars.eating_units then
		arg_136_0.vars.eating_units = {}
		
		for iter_136_0, iter_136_1 in pairs(arg_136_0.vars.o_units) do
			if iter_136_1:isEating() then
				table.push(arg_136_0.vars.eating_units, iter_136_1)
			end
		end
	end
	
	local var_136_0
	
	for iter_136_2 = #arg_136_0.vars.eating_units, 1, -1 do
		local var_136_1 = arg_136_0.vars.eating_units[iter_136_2]
		local var_136_2 = arg_136_0.dock:getRenderer(var_136_1)
		
		if var_136_2 and UIUtil:updateEatingEndTime(var_136_2, var_136_1) == 0 then
			arg_136_0:updateUnit(var_136_2, var_136_1)
			arg_136_0:updateControlColor(arg_136_0.dock, var_136_1, var_136_2)
			table.remove(arg_136_0.vars.eating_units, iter_136_2)
		end
	end
end

function HeroBelt.showSortButton(arg_137_0, arg_137_1)
	if_set_visible(arg_137_0.vars.wnd, "n_sorting", arg_137_1)
end

function HeroBelt.showAddInvenButton(arg_138_0, arg_138_1)
	if_set_visible(arg_138_0.vars.wnd, "add_inven", arg_138_1)
end

function HeroBelt.updateTeamMarkers(arg_139_0)
	for iter_139_0, iter_139_1 in pairs(arg_139_0.dock.controls) do
		if_set_visible(iter_139_1, "team", iter_139_0:isInTeam() or iter_139_0.isDoingSubTask and iter_139_0:isDoingSubTask())
	end
end

function HeroBelt.isPushed(arg_140_0)
	return arg_140_0.dock:isPushed()
end

function HeroBelt.isScrolling(arg_141_0)
	return arg_141_0.dock:isScrolling()
end

function HeroBelt.isEmpty(arg_142_0)
	return arg_142_0:getItemCount() == 0
end

function HeroBelt.setTouchEnabled(arg_143_0, arg_143_1)
	if arg_143_0.dock then
		arg_143_0.dock:setTouchEnabled(arg_143_1)
	end
end

function HeroBelt.setScrollEnabled(arg_144_0, arg_144_1)
	if arg_144_0.dock then
		arg_144_0.dock:setScrollEnabled(arg_144_1)
	end
end

function HeroBelt.getWindow(arg_145_0)
	return arg_145_0.vars.wnd
end

function HeroBelt.getSortMode(arg_146_0)
	if not arg_146_0.vars.sort_mode then
		return ""
	end
	
	return arg_146_0.vars.sort_mode
end

function HeroBelt.isValid(arg_147_0)
	return arg_147_0.vars and get_cocos_refid(arg_147_0.vars.wnd)
end

function HeroBelt.setFixFilter(arg_148_0, arg_148_1, arg_148_2)
	if table.empty(arg_148_0.vars.filter_un_hash_tbl) or not arg_148_1 or not arg_148_2 then
		return 
	end
	
	local var_148_0
	
	for iter_148_0, iter_148_1 in pairs(arg_148_0.vars.filter_un_hash_tbl[arg_148_1] or {}) do
		if iter_148_1 == arg_148_2 then
			var_148_0 = iter_148_0
			
			break
		end
	end
	
	if arg_148_0.vars.sorter then
		arg_148_0.vars.sorter:setDisabledFilter(arg_148_1)
		
		if arg_148_0.vars.sorter.filter then
			arg_148_0.vars.sorter.filter:toggleFilter(var_148_0, arg_148_1)
		end
	end
end
