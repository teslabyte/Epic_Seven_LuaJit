Sorter = {}

function HANDLER.n_set_box(arg_1_0, arg_1_1, arg_1_2)
	SorterExtention:onClickEventExtentionFilter(arg_1_0, arg_1_1, arg_1_2)
end

function HANDLER.n_mainstat_box(arg_2_0, arg_2_1, arg_2_2)
	SorterExtention:onClickEventExtentionFilter(arg_2_0, arg_2_1, arg_2_2)
end

function HANDLER.n_substat_box(arg_3_0, arg_3_1, arg_3_2)
	SorterExtention:onClickEventExtentionFilter(arg_3_0, arg_3_1, arg_3_2)
end

function HANDLER.sorting(arg_4_0, arg_4_1, arg_4_2)
	Sorter:onClickEvent(arg_4_0, arg_4_1, arg_4_2)
end

function HANDLER.sorting_filter_equip(arg_5_0, arg_5_1, arg_5_2)
	Sorter:onClickEvent(arg_5_0, arg_5_1, arg_5_2)
	SorterExtention:onClickEventExtentionFilter(arg_5_0, arg_5_1, arg_5_2)
end

function HANDLER.sorting_filter_unit(arg_6_0, arg_6_1, arg_6_2)
	Sorter:onClickEvent(arg_6_0, arg_6_1, arg_6_2)
end

function HANDLER.sorting_filter_wearing(arg_7_0, arg_7_1, arg_7_2)
	Sorter:onClickEvent(arg_7_0, arg_7_1, arg_7_2)
end

function HANDLER.sorting_unit(arg_8_0, arg_8_1, arg_8_2)
	Sorter:onClickEvent(arg_8_0, arg_8_1, arg_8_2)
end

function HANDLER.sorting_1(arg_9_0, arg_9_1, arg_9_2)
	Sorter:onClickEvent(arg_9_0, arg_9_1, arg_9_2)
end

function HANDLER.sorting_story(arg_10_0, arg_10_1, arg_10_2)
	Sorter:onClickEvent(arg_10_0, arg_10_1, arg_10_2)
end

local var_0_0 = {
	"all",
	"att",
	"def",
	"max_hp",
	"att_rate",
	"def_rate",
	"max_hp_rate",
	"speed",
	"cri",
	"cri_dmg",
	"acc",
	"res"
}
local var_0_1 = {
	set_vampire = 10,
	set_att = 2,
	set_max_hp = 4,
	set_torrent = 19,
	set_cri_dmg = 7,
	all = 1,
	set_coop = 12,
	set_def = 3,
	set_penetrate = 15,
	set_speed = 5,
	set_acc = 8,
	set_counter = 11,
	set_res = 9,
	set_scar = 17,
	set_revenge = 16,
	set_cri = 6,
	set_immune = 13,
	set_rage = 14,
	set_shield = 18
}

function Sorter.onClickEvent(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = getParentWindow(arg_11_1).sorter
	
	if var_11_0:isInputLock() then
		return 
	end
	
	if string.starts(arg_11_2, "btn_toggle") then
		var_11_0:toggleMode()
	end
	
	if string.starts(arg_11_2, "btn_sort") then
		local var_11_1 = tonumber(string.sub(arg_11_2, -1, -1))
		
		if var_11_1 == var_11_0:getMenuIdx("Stat") then
			var_11_0:show(false)
			var_11_0:createOrShowStatFilter()
			
			return 
		end
		
		var_11_0:setisChangeFilter(true)
		var_11_0:sortByButton(var_11_1)
		
		return 
	end
	
	if string.starts(arg_11_2, "btn_check") then
		local var_11_2
		local var_11_3 = string.find(arg_11_2, "all") and "all" or tonumber(string.sub(arg_11_2, -1, -1))
		
		if string.find(arg_11_2, "star") then
			var_11_0:toggleFilter(var_11_3, "star")
		elseif string.find(arg_11_2, "role") then
			var_11_0:toggleFilter(var_11_3, "role")
		elseif string.find(arg_11_2, "element") then
			var_11_0:toggleFilter(var_11_3, "element")
		elseif string.find(arg_11_2, "skill") then
			var_11_0:toggleSkillFilter(var_11_3, "skill")
		else
			var_11_0:toggle(var_11_3)
		end
		
		var_11_0:updateToggleButton()
		
		return 
	end
	
	if (string.starts(arg_11_2, "btn_buff") or string.starts(arg_11_2, "btn_debuff")) and var_11_0:canUseBuffFilter() then
		var_11_0.vars.skill_filter:openUI(arg_11_2)
	end
end

function Sorter.create(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {}
	
	arg_12_2 = arg_12_2 or {}
	var_12_0.vars = {}
	var_12_0.vars.items = {}
	var_12_0.vars.check_flags = {}
	var_12_0.create_opts = arg_12_2
	
	local var_12_1 = "wnd/sorting.csb"
	
	if arg_12_2.sorting_unit and arg_12_2.sorting_unit == true then
		if arg_12_2.inventory_wearing then
			var_12_1 = "wnd/sorting_filter_wearing.csb"
		elseif arg_12_2.awake_upgrade then
			var_12_1 = "wnd/sorting_story.csb"
		else
			var_12_1 = "wnd/sorting_filter_unit.csb"
			var_12_0.vars.use_effect_filter = true
		end
		
		var_12_0.filter = ItemFilter:create(arg_12_2)
	end
	
	if arg_12_2.sorting_pet and arg_12_2.sorting_pet == true or arg_12_2.sorting_subtask and arg_12_2.sorting_subtask == true then
		var_12_1 = "wnd/sorting_unit.csb"
	end
	
	if arg_12_2.useExtention then
		var_12_1 = "wnd/sorting_filter_equip.csb"
	end
	
	if arg_12_2.use_system_substory then
		var_12_1 = "wnd/sorting_story.csb"
	end
	
	local var_12_2 = arg_12_2.csb_file or var_12_1
	
	var_12_0.vars.wnd = load_control(var_12_2)
	
	local var_12_3, var_12_4, var_12_5 = string.find(var_12_2, "wnd/([%a_]+)%.csb")
	
	var_12_0.vars.base_csb = var_12_5
	var_12_0.vars.wnd.sorter = var_12_0
	var_12_0.vars.btn_toggle_name = "btn_toggle"
	
	if arg_12_2.btn_toggle_box then
		if_set_visible(var_12_0.vars.wnd, "btn_toggle_box", true)
		
		if not arg_12_2.inventory_wearing then
			if_set_visible(var_12_0.vars.wnd, "btn_toggle", false)
		end
		
		if arg_12_2.use_on_pre_ban then
			local var_12_6 = var_12_0.vars.wnd:findChildByName("btn_toggle_box")
			local var_12_7 = var_12_0.vars.wnd:findChildByName("n_btn_move_preban")
			
			if get_cocos_refid(var_12_6) and get_cocos_refid(var_12_7) then
				var_12_6:setPosition(var_12_7:getPosition())
			end
			
			local var_12_8 = arg_12_1:getChildByName("btn_toggle_box_active")
			local var_12_9 = var_12_0.vars.wnd:getChildByName("btn_toggle_box_active")
			
			if get_cocos_refid(var_12_8) and get_cocos_refid(var_12_9) then
				var_12_9:setPosition(var_12_8:getPosition())
				var_12_9:setAnchorPoint(0.5, 0.5)
			end
		end
		
		var_12_0.vars.btn_toggle_name = "btn_toggle_box"
	end
	
	if var_12_0.filter then
		var_12_0.filter:setWnd(var_12_0.vars.wnd)
	end
	
	if arg_12_2.bg_width_x or arg_12_2.bg_height then
		local var_12_10 = var_12_0.vars.wnd:getChildByName(var_12_0.vars.btn_toggle_name)
		
		var_12_10:setContentSize(arg_12_2.bg_width_x or var_12_10:getContentSize().width, arg_12_2.bg_height or var_12_10:getContentSize().height)
	end
	
	if arg_12_2.txt_cur_sort_pos_diff_y then
		local var_12_11 = var_12_0.vars.wnd:getChildByName(var_12_0.vars.btn_toggle_name):getChildByName("txt_cur_sort")
		
		var_12_11:setPositionY(var_12_11:getPositionY() - arg_12_2.txt_cur_sort_pos_diff_y)
	end
	
	if arg_12_2.icon_pos_diff_y then
		local var_12_12 = var_12_0.vars.wnd:getChildByName("icon")
		
		var_12_12:setPositionY(var_12_12:getPositionY() - arg_12_2.icon_pos_diff_y)
	end
	
	if arg_12_2.not_use_skill_filter then
		var_12_0.vars.wnd:getChildByName("n_skill"):setVisible(false)
	end
	
	local var_12_13
	
	local function var_12_14(arg_13_0)
		local var_13_0 = var_12_0.vars.wnd:getChildByName(arg_13_0)
		
		if get_cocos_refid(var_13_0) then
			var_13_0:removeFromParent()
		end
	end
	
	if arg_12_2.dict_mode then
		var_12_14("n_checkboxs")
		var_12_14("n_equipment_level_filter")
		
		var_12_13 = var_12_0.vars.wnd:getChildByName("n_hero_checkbox")
	elseif arg_12_2.use_level_filter then
		var_12_14("n_hero_checkbox")
		var_12_14("n_checkboxs")
		
		var_12_13 = var_12_0.vars.wnd:getChildByName("n_equipment_level_filter")
	else
		var_12_14("n_hero_checkbox")
		var_12_14("n_equipment_level_filter")
		
		var_12_13 = var_12_0.vars.wnd:getChildByName("n_checkboxs")
	end
	
	if get_cocos_refid(var_12_13) then
		var_12_13:setVisible(true)
		var_12_13:setName("n_checkboxs")
	end
	
	arg_12_1:addChild(var_12_0.vars.wnd)
	
	var_12_0.vars.parent = arg_12_1
	
	copy_functions(Sorter, var_12_0)
	
	if arg_12_2.useExtention then
		var_12_0:setUseExtention(arg_12_2.useExtention)
		
		arg_12_2.sorter = var_12_0
		var_12_0.sorter_extention = {}
		
		copy_functions(SorterExtention, var_12_0.sorter_extention)
		var_12_0.sorter_extention:init(arg_12_2)
	end
	
	BackButtonManager:push({
		check_id = "soter",
		back_func = function()
			Sorter:show(false)
		end,
		dlg = var_12_0.vars.wnd
	})
	var_12_0:show(false)
	
	if var_12_0.vars.use_effect_filter then
		var_12_0.vars.skill_filter = SkillEffectFilterUI:create(var_12_0)
	end
	
	return var_12_0
end

function Sorter.canUseBuffFilter(arg_15_0)
	return arg_15_0.vars and arg_15_0.vars.use_effect_filter
end

function Sorter.changeMode(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars or not arg_16_0.vars.skill_filter then
		return 
	end
	
	arg_16_0.vars.skill_filter:changeMode(arg_16_1, arg_16_2)
	arg_16_0:updateBuffUI()
end

function Sorter.getSkillFilter(arg_17_0)
	return arg_17_0.vars.skill_filter
end

function Sorter.updateBuffUI(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) or arg_18_0.vars.base_csb ~= "sorting_filter_unit" or not arg_18_0.vars.skill_filter then
		return 
	end
	
	if not arg_18_0.create_opts or not arg_18_0.create_opts.sorting_unit then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_skill")
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	local var_18_1 = arg_18_0.vars.skill_filter:getSelectedBuffList() or {}
	local var_18_2 = arg_18_0.vars.skill_filter:getSelectedDebuffList() or {}
	local var_18_3 = var_18_0:getChildByName("n_buff")
	local var_18_4 = var_18_0:getChildByName("n_debuff")
	local var_18_5 = arg_18_0.vars.skill_filter:isSelectAllBuffList()
	local var_18_6 = arg_18_0.vars.skill_filter:isSelectAllDebuffList()
	
	arg_18_0:_updateBuffUI(var_18_3, var_18_1, var_18_5)
	arg_18_0:_updateBuffUI(var_18_4, var_18_2, var_18_6)
	
	local var_18_7 = var_18_5 or not table.empty(var_18_1)
	
	if_set_visible(var_18_3, "btn_buff", not var_18_7)
	if_set_visible(var_18_3, "btn_buff_green", var_18_7)
	
	local var_18_8 = var_18_6 or not table.empty(var_18_2)
	
	if_set_visible(var_18_4, "btn_debuff", not var_18_8)
	if_set_visible(var_18_4, "btn_debuff_green", var_18_8)
	
	if not arg_18_1 then
		arg_18_0:updateSkillFilterAllValue()
	end
end

function Sorter.updateSkillFilterAllValue(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) or arg_19_0.vars.base_csb ~= "sorting_filter_unit" or not arg_19_0.vars.skill_filter then
		return 
	end
	
	if not arg_19_0.create_opts or not arg_19_0.create_opts.sorting_unit then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.skill_filter:getSelectedBuffList() or {}
	local var_19_1 = arg_19_0.vars.skill_filter:getSelectedDebuffList() or {}
	local var_19_2 = arg_19_0.vars.skill_filter:isSelectAllList()
	local var_19_3 = arg_19_0.vars.wnd:getChildByName("checkbox_skill_all")
	
	if table.empty(var_19_0) and table.empty(var_19_1) then
		arg_19_0.vars.skill_filter:setSelectAllList(true)
		
		var_19_2 = true
	end
	
	if var_19_2 ~= var_19_3:isSelected() then
		arg_19_0:toggleFilter("all", "skill")
	end
end

function Sorter._updateBuffUI(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = table.empty(arg_20_2)
	
	if_set_visible(arg_20_1, "n_selected_icon", not var_20_0)
	if_set_visible(arg_20_1, "n_no_select", var_20_0)
	if_set_visible(arg_20_1, "n_selected_all", arg_20_3)
	
	if arg_20_3 then
		if_set_visible(arg_20_1, "n_selected_icon", false)
		if_set_visible(arg_20_1, "n_no_select", false)
	end
	
	if var_20_0 or arg_20_3 then
		return 
	end
	
	local var_20_1 = arg_20_1:getChildByName("n_buff_icon")
	
	for iter_20_0 = 1, 9 do
		local var_20_2 = var_20_1:getChildByName("n_" .. iter_20_0)
		
		if get_cocos_refid(var_20_2) then
			var_20_2:removeAllChildren()
			
			local var_20_3 = arg_20_2[iter_20_0]
			
			if var_20_3 then
				local var_20_4 = SkillEffectFilterManager:getData(var_20_3)
				
				if var_20_4 then
					local var_20_5 = cc.Sprite:create("buff/" .. var_20_4.icon .. ".png")
					
					if var_20_5 then
						var_20_2:addChild(var_20_5)
					end
				end
			end
		end
	end
end

function Sorter.destroy(arg_21_0)
	if get_cocos_refid(arg_21_0.vars.wnd) then
		BackButtonManager:pop({
			dlg = arg_21_0.vars.wnd
		})
		arg_21_0.vars.wnd:removeFromParent()
		
		arg_21_0.vars.wnd = nil
		arg_21_0.vars = nil
	end
end

function Sorter.changeParent(arg_22_0, arg_22_1, arg_22_2)
	if get_cocos_refid(arg_22_0.vars.parent) then
		arg_22_0.vars.parent:setVisible(false)
	end
	
	arg_22_0.vars.parent = arg_22_1
	
	arg_22_0.vars.wnd:ejectFromParent()
	arg_22_1:addChild(arg_22_0.vars.wnd)
	if_set_visible(arg_22_1, nil, true)
end

function Sorter.toggleMode(arg_23_0)
	arg_23_0:show(not arg_23_0.vars.show)
end

function Sorter.setItems(arg_24_0, arg_24_1)
	arg_24_0.vars.items = arg_24_1
end

function Sorter.setVisible(arg_25_0, arg_25_1)
	arg_25_0.vars.wnd:setVisible(arg_25_1)
end

function Sorter.showByCursor(arg_26_0, arg_26_1)
	if arg_26_0.vars.wnd:getChildByName("n_updown") then
		if_set_visible(arg_26_0.vars.wnd, "n_updown", true)
		if_set_visible(arg_26_0.vars.wnd, "btn_up", to_n(arg_26_0.vars.index) < 0)
		if_set_visible(arg_26_0.vars.wnd, "btn_down", not (to_n(arg_26_0.vars.index) < 0))
		
		return 
	end
end

function Sorter.showByUpDown(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_updown")
	local var_27_1 = true
	
	if to_n(arg_27_0.vars.index) < 0 then
		var_27_1 = false
	end
	
	if_set_visible(var_27_0, "btn_up", not var_27_1)
	if_set_visible(var_27_0, "btn_down", var_27_1)
end

function Sorter.updateCheckBoxs(arg_28_0, arg_28_1)
	if arg_28_1 and arg_28_0.vars.opts.checkboxs then
		for iter_28_0 = 1, 6 do
			local var_28_0 = arg_28_0.vars.wnd:getChildByName("checkbox" .. iter_28_0)
			
			if arg_28_0.vars.opts.checkboxs[iter_28_0] then
				var_28_0:setSelected(arg_28_0.vars.check_flags[arg_28_0.vars.opts.checkboxs[iter_28_0].id] == true)
			end
		end
	end
end

function Sorter.isShow(arg_29_0)
	if not arg_29_0.vars then
		return false
	end
	
	return arg_29_0.vars.show
end

function Sorter.show(arg_30_0, arg_30_1)
	if not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.show
	
	arg_30_0.vars.show = arg_30_1
	
	if_set_visible(arg_30_0.vars.wnd, "n_sort", arg_30_1)
	
	if arg_30_1 and arg_30_0:getUseExtention() then
		arg_30_0:setisChangeFilter(false)
	end
	
	if arg_30_0.create_opts.sorting_unit == true then
		arg_30_0:showByUpDown(arg_30_1)
	else
		arg_30_0:showByCursor(arg_30_1)
	end
	
	if arg_30_0.vars.index and arg_30_0.create_opts.sorting_subtask ~= true then
		local var_30_1 = arg_30_0.vars.wnd:getChildByName("n_sort_cursor")
		local var_30_2 = arg_30_0.vars.wnd:getChildByName("btn_sort" .. math.abs(arg_30_0.vars.index))
		
		if not var_30_2 then
			return 
		end
		
		var_30_1:setPositionY(var_30_2:getPositionY())
	end
	
	if arg_30_1 and arg_30_0.vars.opts.checkboxs then
		arg_30_0:updateCheckBoxs(arg_30_1)
	end
	
	if arg_30_1 and arg_30_0.vars.opts.filters then
		arg_30_0:updateFilters()
	end
	
	if arg_30_1 and arg_30_0.create_opts.stat_menu_idx then
		local var_30_3 = arg_30_0.create_opts.stat_menu_idx
		local var_30_4 = arg_30_0.vars.wnd:getChildByName("n_sort"):getChildByName("btn_sort" .. var_30_3)
		
		arg_30_0:updateStatIcon(var_30_4:getChildByName("txt_sort" .. var_30_3), var_30_4:getChildByName("n_stat_icon"))
	end
	
	if arg_30_1 and arg_30_0:getUseExtention() then
		arg_30_0.sorter_extention:openOptsFilter()
	elseif arg_30_0:getUseExtention() then
		arg_30_0.sorter_extention:closeOptsFilter()
	end
	
	if not arg_30_1 and arg_30_0.vars.opts and arg_30_0:getUseExtention() and arg_30_0:getisChangeFilter() and arg_30_0.vars.opts.close_callback then
		arg_30_0.vars.opts.close_callback()
	end
	
	if arg_30_1 and arg_30_0.vars.opts and arg_30_0.vars.opts.open_callback then
		arg_30_0.vars.opts.open_callback()
	end
	
	if arg_30_1 == true then
		BackButtonManager:push({
			check_id = "soter",
			back_func = function()
				arg_30_0:show(false)
			end,
			dlg = arg_30_0.vars.wnd
		})
	elseif arg_30_1 == false and var_30_0 ~= arg_30_1 then
		BackButtonManager:pop({
			dlg = arg_30_0.vars.wnd
		})
	end
end

function Sorter.getisChangeFilter(arg_32_0)
	return arg_32_0.vars.isChangeFilter
end

function Sorter.getSortedList(arg_33_0)
	return arg_33_0.vars.items
end

function Sorter.setisChangeFilter(arg_34_0, arg_34_1)
	arg_34_0.vars.isChangeFilter = arg_34_1
end

function Sorter.sortByStatButton(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.vars.stat_index
	
	arg_35_0.vars.stat_index = arg_35_1
	
	arg_35_0:setisChangeFilter(true)
	
	if arg_35_2 then
		arg_35_0:sort(arg_35_2)
	else
		local var_35_1 = arg_35_0:getMenuIdx("Stat")
		local var_35_2 = false
		
		if math.abs(arg_35_0.vars.index or arg_35_0.vars.default_sort_index) == var_35_1 and arg_35_1 ~= (var_35_0 or arg_35_0.vars.default_stat_index) then
			var_35_2 = true
		end
		
		arg_35_0:sortByButton(var_35_1, var_35_2)
	end
end

function Sorter.sortByButton(arg_36_0, arg_36_1, arg_36_2)
	arg_36_0:show(false)
	
	if arg_36_2 then
		arg_36_0:sort(arg_36_1)
	elseif arg_36_1 == arg_36_0.vars.index then
		arg_36_0:sort(0 - arg_36_0.vars.index)
	else
		arg_36_0:sort(arg_36_1)
	end
end

function Sorter.sort(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0.vars.index or arg_37_0.vars.default_sort_index
	
	arg_37_1 = arg_37_1 or var_37_0 or 2
	arg_37_0.vars.index = arg_37_1
	
	local var_37_1 = math.min(math.abs(arg_37_1), #arg_37_0.vars.menus)
	
	if arg_37_0.vars.opts.priority_sort_func then
		table.sort(arg_37_0.vars.items, function(arg_38_0, arg_38_1)
			local var_38_0 = arg_37_0.vars.opts.priority_sort_func(arg_38_0, arg_38_1, arg_37_0.vars.check_flags, arg_37_0.vars.opts)
			
			if var_38_0 ~= nil then
				if arg_37_1 < 0 then
					return not var_38_0
				else
					return var_38_0
				end
			end
			
			return arg_37_0.vars.menus[var_37_1].func(arg_38_0, arg_38_1)
		end)
	else
		table.sort(arg_37_0.vars.items, arg_37_0.vars.menus[var_37_1].func)
	end
	
	if arg_37_0.vars.index < 0 then
		table.reverse(arg_37_0.vars.items)
	end
	
	local var_37_2 = arg_37_0.vars.wnd:findChildByName(arg_37_0.vars.btn_toggle_name)
	local var_37_3 = arg_37_0.vars.wnd:findChildByName(arg_37_0.vars.btn_toggle_name .. "_active")
	
	if not arg_37_0.vars.menus[var_37_1].name then
		if_set(var_37_2, "txt_cur_sort", T("ui_unit_list_sort_btn_label"))
		if_set(var_37_3, "txt_cur_sort", T("ui_unit_list_sort_btn_label"))
	else
		if_set(var_37_2, "txt_cur_sort", tostring(arg_37_0.vars.menus[var_37_1].name))
		if_set(var_37_3, "txt_cur_sort", tostring(arg_37_0.vars.menus[var_37_1].name))
	end
	
	if arg_37_0.create_opts.stat_menu_idx then
		local var_37_4 = var_37_1 == arg_37_0:getMenuIdx("Stat")
		
		if_set_visible(var_37_2, "n_stat_icon", var_37_4)
		if_set_visible(var_37_3, "n_stat_icon", var_37_4)
		arg_37_0:setTextFitWidth(var_37_4 and 68 or 88)
		
		if var_37_4 then
			if get_cocos_refid(var_37_2) then
				arg_37_0:updateStatIcon(var_37_2:getChildByName("txt_cur_sort"), var_37_2:getChildByName("n_stat_icon"))
			end
			
			if get_cocos_refid(var_37_3) then
				arg_37_0:updateStatIcon(var_37_2:getChildByName("txt_cur_sort"), var_37_3:getChildByName("n_stat_icon"))
			end
		end
	end
	
	if arg_37_0:getUseExtention() then
		arg_37_0.vars.items = arg_37_0.sorter_extention:checkFilterOptionsGeneric(arg_37_0.vars.items)
	end
	
	if not arg_37_2 and arg_37_0.vars.opts.callback_sort then
		arg_37_0.vars.opts.callback_sort(var_37_0, arg_37_0.vars.index, arg_37_0.vars.menus[var_37_1])
	end
	
	return arg_37_0.vars.items
end

function Sorter.setTextFitWidth(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.vars.wnd:findChildByName(arg_39_0.vars.btn_toggle_name)
	local var_39_1 = arg_39_0.vars.wnd:findChildByName(arg_39_0.vars.btn_toggle_name .. "_active")
	
	if get_cocos_refid(var_39_0) then
		UIUserData:call(var_39_0:getChildByName("txt_cur_sort"), "SINGLE_WSCALE(" .. arg_39_1 .. ")")
	end
	
	if get_cocos_refid(var_39_1) then
		UIUserData:call(var_39_1:getChildByName("txt_cur_sort"), "SINGLE_WSCALE(" .. arg_39_1 .. ")")
	end
end

function Sorter.sortExtention(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_1 or arg_40_0.vars.items
	
	if arg_40_0.vars and arg_40_0.vars.items and arg_40_0:getUseExtention() then
		arg_40_0.vars.items = arg_40_0.sorter_extention:checkFilterOptionsGeneric(var_40_0)
		
		return arg_40_0.vars.items
	end
end

function Sorter.setUseExtention(arg_41_0, arg_41_1)
	if not arg_41_0.vars then
		return 
	end
	
	arg_41_0.vars.useExtention = arg_41_1
end

function Sorter.getUseExtention(arg_42_0)
	if not arg_42_0.vars or not arg_42_0.vars.useExtention then
		return false
	end
	
	return arg_42_0.vars.useExtention
end

function Sorter.getWnd(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	return arg_43_0.vars.wnd
end

function Sorter.getSortIndex(arg_44_0)
	return arg_44_0.vars.index
end

function Sorter.updateFilters(arg_45_0, arg_45_1)
	if arg_45_0.filter then
		arg_45_0.filter:updateFilters(arg_45_1)
	end
end

function Sorter.setFilters(arg_46_0, arg_46_1)
	if arg_46_0.filter then
		arg_46_0.filter:setFilters(arg_46_1)
	end
end

function Sorter.changeCheckboxes(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_0.vars.visible_cnt
	
	arg_47_0:setCheckboxes(arg_47_1, var_47_0)
	
	local var_47_1 = arg_47_0:getCheckBoxsHeight(arg_47_1)
	
	arg_47_0:updateContentSize(var_47_0, var_47_1)
	
	arg_47_0.vars.opts.checkboxs = arg_47_1
end

function Sorter.setSortVisibleByIdx(arg_48_0, arg_48_1, arg_48_2)
	if not arg_48_0.vars.visible_map then
		arg_48_0.vars.visible_map = {}
		
		for iter_48_0 = 1, arg_48_0.vars.visible_cnt do
			arg_48_0.vars.visible_map[iter_48_0] = true
		end
	end
	
	arg_48_0.vars.visible_map[arg_48_1] = arg_48_2
	
	if_set_visible(arg_48_0.vars.wnd, "btn_sort" .. arg_48_1, arg_48_2)
	
	local var_48_0 = 0
	
	for iter_48_1, iter_48_2 in pairs(arg_48_0.vars.visible_map) do
		if iter_48_2 then
			var_48_0 = var_48_0 + 1
		end
	end
	
	arg_48_0.vars.visible_cnt = var_48_0
	
	arg_48_0:updateContentSize(var_48_0, 0)
end

function Sorter.getCheckBoxsHeight(arg_49_0, arg_49_1)
	if table.empty(arg_49_1) then
		return 0
	end
	
	if arg_49_0.create_opts and arg_49_0.create_opts.dict_mode then
		return 0
	end
	
	local var_49_0 = arg_49_0:getCheckBoxNode()
	
	if not var_49_0 then
		return 0
	end
	
	local var_49_1 = var_49_0:getChildByName("btn_check1")
	local var_49_2 = var_49_0:getChildByName("btn_check" .. #arg_49_1)
	
	if not get_cocos_refid(var_49_1) or not get_cocos_refid(var_49_2) then
		return 0
	end
	
	local var_49_3 = var_49_1:getPositionY()
	local var_49_4 = var_49_1:getScale()
	local var_49_5 = var_49_1:getAnchorPoint().y
	local var_49_6 = var_49_1:getContentSize().height
	local var_49_7 = var_49_3 + var_49_6 * var_49_4 * (1 - var_49_5)
	local var_49_8 = var_49_3 - var_49_6 * var_49_4 * var_49_5
	local var_49_9 = var_49_2:getPositionY()
	local var_49_10 = var_49_2:getScale()
	local var_49_11 = var_49_2:getAnchorPoint().y
	local var_49_12 = var_49_2:getContentSize().height
	local var_49_13 = var_49_9 + var_49_12 * var_49_10 * (1 - var_49_11)
	local var_49_14 = var_49_7 - (var_49_9 - var_49_12 * var_49_10 * var_49_11)
	local var_49_15 = 42
	
	if #arg_49_1 == 1 then
		var_49_15 = 50
	end
	
	return var_49_14 + var_49_15
end

function Sorter.getCheckBoxNode(arg_50_0)
	if not arg_50_0.vars or not get_cocos_refid(arg_50_0.vars.wnd) then
		return 
	end
	
	return arg_50_0.vars.wnd:getChildByName("n_checkboxs")
end

function Sorter.isCheckBoxsOneColumn(arg_51_0)
	local var_51_0 = arg_51_0.create_opts and arg_51_0.create_opts.sorting_unit
	local var_51_1 = arg_51_0.create_opts and arg_51_0.create_opts.inventory_wearing
	
	return not var_51_0 or var_51_1
end

function Sorter.setCheckBoxsPosition(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0:getCheckBoxNode()
	
	if not get_cocos_refid(var_52_0) then
		return 
	end
	
	if not arg_52_0:isCheckBoxsOneColumn() then
		return 
	end
	
	if arg_52_1 == 0 then
		local var_52_1 = arg_52_0.vars.wnd:getChildByName("btn_sort1")
		local var_52_2 = var_52_1:getPositionX()
		local var_52_3 = var_52_1:getPositionY() + 46
		
		var_52_0:setPosition(var_52_2, var_52_3)
	else
		local var_52_4 = arg_52_0.vars.wnd:getChildByName("btn_sort1")
		local var_52_5 = arg_52_0.vars.wnd:getChildByName("btn_sort" .. arg_52_1)
		local var_52_6 = arg_52_0:getUseExtention() and var_52_0:getPositionX() or var_52_4:getPositionX()
		local var_52_7 = var_52_5:getPositionY()
		
		var_52_0:setPosition(var_52_6, var_52_7)
	end
end

function Sorter.setCheckBoxsName(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0:getCheckBoxNode()
	
	if not get_cocos_refid(var_53_0) then
		return 
	end
	
	for iter_53_0 = 1, 6 do
		local var_53_1 = arg_53_1[iter_53_0] ~= nil
		
		if_set_visible(var_53_0, "btn_check" .. iter_53_0, var_53_1)
		
		if var_53_1 then
			if_set(var_53_0, "txt_check" .. iter_53_0, arg_53_1[iter_53_0].name)
			
			arg_53_0.vars.check_flags[arg_53_1[iter_53_0].id] = arg_53_1[iter_53_0].checked
		end
	end
end

function Sorter.setBtnIgnore(arg_54_0)
	local var_54_0 = arg_54_0.vars.wnd:getChildByName("btn_ignore")
	
	if not get_cocos_refid(var_54_0) then
		return 
	end
	
	local var_54_1 = var_54_0:getContentSize()
	
	arg_54_0.vars.btn_ignore_origin_h = arg_54_0.vars.btn_ignore_origin_h or var_54_1.height + 52
	var_54_1.height = arg_54_0.vars.btn_ignore_origin_h
	
	var_54_0:setContentSize(var_54_1)
end

function Sorter.setMiddleBar(arg_55_0, arg_55_1)
	if arg_55_0:getUseExtention() then
		return 
	end
	
	local var_55_0 = arg_55_0.vars.wnd:getChildByName("n_bar")
	
	if not get_cocos_refid(var_55_0) or var_55_0.init_pos then
		return 
	end
	
	if arg_55_1 >= 2 and not var_55_0.init_pos then
		var_55_0.init_pos = true
		
		local var_55_1 = arg_55_1 - 1
		local var_55_2 = 26 * var_55_1
		local var_55_3 = 26 * var_55_1
		
		var_55_0:setPositionY(var_55_0:getPositionY() - var_55_2)
		
		for iter_55_0, iter_55_1 in pairs(var_55_0:getChildren() or {}) do
			local var_55_4 = iter_55_1:getContentSize()
			
			var_55_4.width = var_55_4.width + var_55_3
			
			iter_55_1:setContentSize(var_55_4)
		end
		
		return 
	end
	
	arg_55_0.vars.n_bar_y = arg_55_0.vars.n_bar_y or var_55_0:getPositionY() - 26
	
	var_55_0:setPositionY(arg_55_0.vars.n_bar_y)
	
	for iter_55_2, iter_55_3 in pairs(var_55_0:getChildren() or {}) do
		local var_55_5 = iter_55_3:getContentSize()
		
		var_55_5.width = 212
		
		iter_55_3:setContentSize(var_55_5)
	end
end

function Sorter.setCheckboxes(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = arg_56_0:getCheckBoxNode()
	
	if not get_cocos_refid(var_56_0) then
		return 
	end
	
	local var_56_1 = arg_56_1 ~= nil
	
	if_set_visible(arg_56_0.vars.wnd, nil, var_56_1)
	
	if not var_56_1 then
		return 
	end
	
	local var_56_2 = arg_56_2 == 0
	
	if_set_visible(var_56_0, "line_middle", not var_56_2)
	arg_56_0:setCheckBoxsName(arg_56_1)
	
	if not arg_56_3 then
		arg_56_0:setCheckBoxsPosition(arg_56_2)
		
		local var_56_3 = table.count(arg_56_1)
		
		if var_56_3 > 1 then
			arg_56_0:setBtnIgnore()
			arg_56_0:setMiddleBar(var_56_3)
		end
	end
end

function Sorter.updateBgContentSize(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = arg_57_0.vars.wnd:getChildByName("bg")
	
	if not get_cocos_refid(var_57_0) then
		return {
			width = 0,
			height = 0
		}
	end
	
	arg_57_1 = arg_57_0.create_opts and arg_57_0.create_opts.promote_popup and 9 or arg_57_1
	
	local var_57_1 = 48
	local var_57_2 = arg_57_0.vars.wnd:getChildByName("btn_sort1")
	
	if get_cocos_refid(var_57_2) then
		var_57_1 = var_57_2:getContentSize().height or 48
	end
	
	local var_57_3 = 0
	
	if arg_57_0:getUseExtention() then
		var_57_1 = 50
		
		if arg_57_2 == 0 then
			var_57_3 = 9
		end
	end
	
	local var_57_4 = 76 + arg_57_1 * var_57_1 + arg_57_2 + var_57_3
	local var_57_5 = arg_57_0.vars.wnd:findChildByName("n_star")
	local var_57_6 = arg_57_0.vars.wnd:findChildByName("n_element")
	
	if get_cocos_refid(var_57_5) and get_cocos_refid(var_57_6) then
		local var_57_7 = arg_57_0.create_opts and arg_57_0.create_opts.dict_mode and 502 or 512
		
		var_57_4 = math.max(var_57_7, var_57_4)
	end
	
	local var_57_8 = var_57_0:getContentSize()
	
	var_57_0.origin_height = var_57_0.origin_height or var_57_8.height
	
	if arg_57_0.create_opts and arg_57_0.create_opts.not_use_skill_filter then
		var_57_8.width = 840
	end
	
	if arg_57_0:getUseExtention() then
		local var_57_9 = 382 + arg_57_2
		
		var_57_4 = math.max(var_57_9, var_57_4)
	end
	
	local var_57_10 = 0
	
	if arg_57_0.create_opts.profile_edit_mode then
		var_57_10 = -50
	end
	
	if arg_57_0.create_opts.awake_upgrade then
		var_57_10 = -48
	end
	
	var_57_0:setContentSize({
		width = var_57_8.width,
		height = var_57_4 + var_57_10
	})
end

function Sorter.updateBtnBgSize(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0.vars.wnd:findChildByName("btn_bg")
	
	if not get_cocos_refid(var_58_0) then
		return 
	end
	
	local var_58_1 = var_58_0:getContentSize()
	
	var_58_1.height = arg_58_1.height - 50
	
	var_58_0:setContentSize(var_58_1)
end

function Sorter.updateContentSize(arg_59_0, arg_59_1, arg_59_2)
	arg_59_0:updateBgContentSize(arg_59_1, arg_59_2)
	
	local var_59_0 = arg_59_0.vars.wnd:getChildByName("bg")
	local var_59_1 = {
		width = 0,
		height = 0
	}
	
	if get_cocos_refid(var_59_0) then
		var_59_1 = var_59_0:getContentSize()
		var_59_0.origin_height = var_59_0.origin_height or var_59_1.height
	end
	
	arg_59_0:updateBtnBgSize(var_59_1)
	
	local var_59_2 = arg_59_0.vars.wnd:getChildByName("n_bar")
	
	if arg_59_0:getUseExtention() then
		if get_cocos_refid(var_59_2) then
			local var_59_3 = math.max(arg_59_1 * 48, 282) / 2
			
			if_set_position_y(var_59_2, "bar1", -1 * var_59_3 - 2)
			if_set_position_y(var_59_2, "bar2", -1 * var_59_3 - 2)
			if_set_content_size(var_59_2, "bar1", var_59_3, 17)
			if_set_content_size(var_59_2, "bar2", var_59_3, 17)
		end
	elseif get_cocos_refid(var_59_2) then
		local var_59_4 = (arg_59_1 + 1) * 0.1
		
		var_59_2:setScaleY(var_59_4)
	end
	
	if arg_59_0.vars.base_csb == "sorting_filter_unit" and arg_59_1 < 9 then
		local var_59_5 = {
			getChildByPath(arg_59_0.vars.wnd, "n_sort/n_star/bar1_l_0"),
			getChildByPath(arg_59_0.vars.wnd, "n_sort/n_role/bar1_l"),
			getChildByPath(arg_59_0.vars.wnd, "n_sort/n_element/bar1_l"),
			getChildByPath(arg_59_0.vars.wnd, "n_sort/n_skill/bar1_l")
		}
		
		for iter_59_0, iter_59_1 in pairs(var_59_5) do
			if get_cocos_refid(iter_59_1) then
				local var_59_6 = arg_59_0.create_opts and arg_59_0.create_opts.dict_mode and 27 or 16
				
				if arg_59_0.create_opts.profile_edit_mode then
					var_59_6 = var_59_6 + 50
				end
				
				iter_59_1.origin_size = iter_59_1.origin_size or iter_59_1:getContentSize()
				
				iter_59_1:setContentSize({
					width = iter_59_1.origin_size.width - var_59_6,
					height = iter_59_1.origin_size.height
				})
			end
		end
	end
	
	if arg_59_0.create_opts and arg_59_0.create_opts.sorting_unit and arg_59_0.create_opts.inventory_wearing then
		local var_59_7 = arg_59_0.vars.wnd:findChildByName("n_star")
		local var_59_8 = arg_59_0.vars.wnd:findChildByName("n_element")
		
		if get_cocos_refid(var_59_7) and get_cocos_refid(var_59_8) then
			local var_59_9 = 429 + (var_59_1.height - var_59_0.origin_height)
			local var_59_10 = var_59_8:findChildByName("bar1_l"):getContentSize()
			local var_59_11 = var_59_10.width / 2 - var_59_9 / 2
			
			var_59_7:findChildByName("bar1_r"):setPositionY(-159 + var_59_11)
			var_59_7:findChildByName("bar1_l"):setPositionY(-159 + var_59_11)
			
			var_59_10.width = var_59_9 / 2
			
			var_59_7:findChildByName("bar1_r"):setContentSize(var_59_10)
			var_59_7:findChildByName("bar1_l"):setContentSize(var_59_10)
			
			var_59_10.width = var_59_9
			
			var_59_8:findChildByName("bar1_l"):setContentSize(var_59_10)
		end
	end
	
	if arg_59_0.create_opts and arg_59_0.create_opts.awake_upgrade then
		if_set_visible(arg_59_0.vars.wnd, "bar1_r_0", false)
		if_set_visible(arg_59_0.vars.wnd, "bar1_l_1", false)
	end
end

function Sorter.starUIDictMode(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_0.vars.wnd:getChildByName("n_star")
	local var_60_1 = {}
	
	for iter_60_0 = 6, 1, -1 do
		if arg_60_1 < iter_60_0 or iter_60_0 < arg_60_2 then
			local var_60_2 = var_60_0:getChildByName("n_check_box_" .. tostring(7 - iter_60_0))
			
			table.insert(var_60_1, var_60_2)
		end
	end
	
	local var_60_3 = 1
	local var_60_4 = {}
	
	for iter_60_1 = arg_60_1, arg_60_2, -1 do
		local var_60_5 = "n_check_box_" .. tostring(7 - iter_60_1)
		local var_60_6 = "n_check_box_" .. var_60_3
		local var_60_7 = var_60_0:getChildByName(var_60_5)
		local var_60_8 = var_60_0:getChildByName(var_60_6)
		
		var_60_4[var_60_5] = {
			node = var_60_7,
			new_name = var_60_6,
			new_idx = var_60_3,
			prv_idx = tostring(7 - iter_60_1),
			x = var_60_8:getPositionX(),
			y = var_60_8:getPositionY()
		}
		var_60_3 = var_60_3 + 1
	end
	
	for iter_60_2, iter_60_3 in pairs(var_60_1) do
		if get_cocos_refid(iter_60_3) then
			iter_60_3:setVisible(false)
			iter_60_3:setName("unused_in_dict_mode")
		end
	end
	
	for iter_60_4, iter_60_5 in pairs(var_60_4) do
		iter_60_5.node:setPosition(iter_60_5.x, iter_60_5.y)
		iter_60_5.node:setName(iter_60_5.new_name)
		iter_60_5.node:getChildByName("btn_checkbox_star_" .. iter_60_5.prv_idx):setName("btn_checkbox_star_" .. iter_60_5.new_idx)
		iter_60_5.node:getChildByName("select_bg_star_" .. iter_60_5.prv_idx):setName("select_bg_star_" .. iter_60_5.new_idx)
		iter_60_5.node:getChildByName("checkbox_star_" .. iter_60_5.prv_idx):setName("checkbox_star_" .. iter_60_5.new_idx)
	end
end

function Sorter.roleUIDictMode(arg_61_0)
	local var_61_0 = arg_61_0.vars.wnd:getChildByName("n_role")
	local var_61_1 = {}
	local var_61_2 = var_61_0:getChildByName("n_check_box_7")
	
	table.insert(var_61_1, var_61_2)
	
	for iter_61_0, iter_61_1 in pairs(var_61_1) do
		if get_cocos_refid(iter_61_1) then
			iter_61_1:setVisible(false)
			iter_61_1:setName("unused_in_dict_mode")
		end
	end
end

function Sorter.updateToggleButton(arg_62_0)
	local var_62_0 = arg_62_0:getFilterActive()
	
	if_set_visible(arg_62_0.vars.wnd, arg_62_0.vars.btn_toggle_name, not var_62_0)
	if_set_visible(arg_62_0.vars.wnd, arg_62_0.vars.btn_toggle_name .. "_active", var_62_0)
end

function Sorter.setSorter(arg_63_0, arg_63_1)
	arg_63_0.vars.menus = arg_63_1.menus
	arg_63_0.vars.default_sort_index = arg_63_1.default_sort_index or 1
	arg_63_0.vars.default_stat_index = arg_63_1.default_stat_index or 1
	arg_63_0.vars.opts = arg_63_1
	arg_63_0.vars.check_flags = {}
	
	if arg_63_0.filter then
		arg_63_0.filter:onSetSorter(arg_63_1)
	end
	
	if math.abs(arg_63_0.vars.default_sort_index) > #arg_63_0.vars.menus then
		if arg_63_0.vars.default_sort_index < 0 then
			arg_63_0.vars.default_sort_index = -1
		else
			arg_63_0.vars.default_sort_index = 1
		end
	end
	
	local var_63_0 = #arg_63_0.vars.menus
	local var_63_1 = 0
	
	for iter_63_0 = 1, 9 do
		local var_63_2 = iter_63_0 <= var_63_0 and arg_63_0.vars.menus[iter_63_0] and arg_63_0.vars.menus[iter_63_0].name and not arg_63_0.create_opts.sort_off
		
		if_set_visible(arg_63_0.vars.wnd, "btn_sort" .. iter_63_0, var_63_2)
		
		if var_63_2 then
			var_63_1 = var_63_1 + 1
			
			if_set(arg_63_0.vars.wnd, "txt_sort" .. iter_63_0, arg_63_0.vars.menus[iter_63_0].name)
		end
	end
	
	if_set_visible(arg_63_0.vars.wnd, "n_sort_cursor", not arg_63_0.create_opts.sort_off)
	
	arg_63_0.vars.visible_cnt = var_63_1
	
	local var_63_3 = 0
	
	arg_63_0:getCheckBoxNode():setVisible(arg_63_1.checkboxs ~= nil)
	
	if arg_63_1.checkboxs then
		arg_63_0:setCheckboxes(arg_63_1.checkboxs, var_63_1, arg_63_1.not_update_check_boxes)
		
		var_63_3 = arg_63_0:getCheckBoxsHeight(arg_63_1.checkboxs)
		
		for iter_63_1, iter_63_2 in pairs(arg_63_1.checkboxs) do
			if iter_63_2.is_filter then
				local var_63_4 = arg_63_0.vars.wnd:getChildByName("icon_filter")
				local var_63_5 = arg_63_0.vars.wnd:getChildByName(arg_63_0.vars.btn_toggle_name)
				
				if get_cocos_refid(var_63_5) and get_cocos_refid(var_63_4) then
					if_set_visible(var_63_5, "icon", false)
					if_set_visible(var_63_5, "icon_filter", true)
				end
				
				break
			end
		end
	end
	
	if arg_63_1.filters then
		arg_63_0:setFilters(arg_63_1.filters)
	end
	
	if arg_63_0:getUseExtention() and table.count(arg_63_1.checkboxs or {}) == 1 then
		var_63_3 = var_63_3 + 10
	end
	
	if not arg_63_0:getUseExtention() and table.count(arg_63_1.checkboxs or {}) == 1 then
		var_63_3 = var_63_3 - 10
	end
	
	if not arg_63_1.not_update_content_size then
		arg_63_0:updateContentSize(var_63_1, var_63_3)
	end
end

function Sorter.revertAllFlag(arg_64_0, arg_64_1)
	if arg_64_0.filter then
		arg_64_0.filter:revertAllFlag(arg_64_1)
	end
end

function Sorter.toggleNormalFilter(arg_65_0, arg_65_1, arg_65_2)
	if arg_65_0.filter then
		arg_65_0.filter:toggleNormalFilter(arg_65_1, arg_65_2)
	end
end

function Sorter.resetDataByCall(arg_66_0)
	if arg_66_0:canUseBuffFilter() and arg_66_0.vars.opts and arg_66_0.vars.opts.resetDataByCall then
		arg_66_0.vars.opts:resetDataByCall()
	end
end

function Sorter.toggleSkillFilter(arg_67_0, arg_67_1, arg_67_2)
	if not arg_67_0.vars or not arg_67_0.vars.skill_filter then
		return 
	end
	
	if arg_67_0.vars.skill_filter:isSelectAllList() then
		return 
	end
	
	arg_67_0.vars.skill_filter:pressAllBtn()
	arg_67_0:toggleFilter(arg_67_1, arg_67_2)
end

function Sorter.toggleFilter(arg_68_0, arg_68_1, arg_68_2)
	if arg_68_0.filter then
		arg_68_0.filter:toggleFilter(arg_68_1, arg_68_2)
	end
end

function Sorter.toggle(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0.vars.opts.checkboxs[arg_69_1].id
	
	arg_69_0:setToggle(arg_69_1, not arg_69_0.vars.check_flags[var_69_0])
end

function Sorter.setVisibleIconOrder(arg_70_0, arg_70_1)
	if not arg_70_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_70_0.vars.wnd) then
		return 
	end
	
	local var_70_0 = arg_70_0.vars.wnd:getChildByName("icon_order")
	
	if not get_cocos_refid(var_70_0) then
		return 
	end
	
	var_70_0:setVisible(arg_70_1)
end

function Sorter.setToggle(arg_71_0, arg_71_1, arg_71_2)
	local var_71_0 = arg_71_0.vars.opts.checkboxs[arg_71_1].id
	
	arg_71_0.vars.check_flags[var_71_0] = arg_71_2
	
	arg_71_0:updateCheckBoxs(true)
	
	if arg_71_0.vars.opts.callback_checkbox then
		arg_71_0.vars.opts.callback_checkbox(var_71_0, arg_71_1, arg_71_0.vars.check_flags[var_71_0])
	end
end

function Sorter.setCheckBoxFlag(arg_72_0, arg_72_1, arg_72_2)
	if not arg_72_0.vars or table.empty(arg_72_0.vars.check_flags) or not arg_72_0.vars.check_flags[arg_72_1] then
		return 
	end
	
	arg_72_0.vars.check_flags[arg_72_1] = arg_72_2
	
	arg_72_0:updateCheckBoxs(true)
end

function Sorter.setInputLock(arg_73_0, arg_73_1)
	arg_73_0.vars.input_lock = arg_73_1
end

function Sorter.isInputLock(arg_74_0)
	return arg_74_0.vars.input_lock or false
end

function Sorter.getFilterActive(arg_75_0)
	if arg_75_0.filter and arg_75_0.filter:isFiltering() then
		return true
	end
	
	if arg_75_0.vars.opts and arg_75_0.vars.opts.checkboxs then
		for iter_75_0, iter_75_1 in pairs(arg_75_0.vars.opts.checkboxs) do
			if iter_75_1.is_filter and not iter_75_1.default_flag == arg_75_0.vars.check_flags[iter_75_1.id] then
				return true
			end
		end
	end
	
	return false
end

function Sorter.getMenuIdx(arg_76_0, arg_76_1)
	for iter_76_0, iter_76_1 in ipairs(arg_76_0.vars.menus or {}) do
		if iter_76_1.key == arg_76_1 then
			return iter_76_0
		end
	end
end

function Sorter.createOrShowStatFilter(arg_77_0)
	if arg_77_0.vars.stat_filter == nil then
		local var_77_0 = {
			btn_sort_callback = function(arg_78_0)
				arg_77_0:sortByStatButton(arg_78_0)
			end
		}
		
		arg_77_0.vars.stat_filter = StatFilter:create(arg_77_0.vars.wnd, var_77_0)
	end
	
	local var_77_1 = 1
	
	if math.abs(arg_77_0.vars.index or arg_77_0.vars.default_sort_index) == arg_77_0:getMenuIdx("Stat") then
		var_77_1 = arg_77_0.vars.stat_index or arg_77_0.vars.default_stat_index
	end
	
	local var_77_2 = to_n(arg_77_0.vars.index) < 0
	
	arg_77_0.vars.stat_filter:show(var_77_1, var_77_2)
end

function Sorter.hideStatFilter(arg_79_0)
	if arg_79_0.vars.stat_filter then
		arg_79_0.vars.stat_filter:hide()
	end
end

function Sorter.updateStatIcon(arg_80_0, arg_80_1, arg_80_2)
	if not get_cocos_refid(arg_80_1) or not get_cocos_refid(arg_80_2) then
		return 
	end
	
	local var_80_0 = arg_80_1:getContentSize()
	
	arg_80_2:setPositionX(arg_80_1:getPositionX() + (var_80_0.width + 16) * arg_80_1:getScaleX() + 3)
	
	if math.abs(arg_80_0.vars.index or arg_80_0.vars.default_sort_index) == arg_80_0:getMenuIdx("Stat") then
		local var_80_1 = arg_80_0.vars.stat_index or arg_80_0.vars.default_stat_index
		local var_80_2 = var_80_1 == 1
		
		if_set_visible(arg_80_2, "icon_cp", var_80_2)
		if_set_visible(arg_80_2, "icon_etc", not var_80_2)
		
		if not var_80_2 then
			local var_80_3 = StatFilter:getMenu(var_80_1)
			
			if var_80_3 then
				local var_80_4 = arg_80_2:getChildByName("icon_etc")
				
				var_80_4:removeAllChildren()
				var_80_4:addChild(SpriteCache:getSprite("img/icon_menu_" .. var_80_3.id .. ".png"))
			end
		end
	else
		if_set_visible(arg_80_2, "icon_cp", true)
		if_set_visible(arg_80_2, "icon_etc", false)
	end
end

function Sorter.getLatestStatMenu(arg_81_0)
	return StatFilter:getMenu(arg_81_0.vars.stat_index or arg_81_0.vars.default_stat_index)
end

function Sorter.getLatestStatMenuFunc(arg_82_0)
	local var_82_0 = arg_82_0:getLatestStatMenu()
	
	if var_82_0 then
		return var_82_0.func
	end
end

function Sorter.getLatestStatMenuIdx(arg_83_0)
	local var_83_0 = arg_83_0:getLatestStatMenu()
	
	if var_83_0 then
		return var_83_0.idx
	end
end

function Sorter.setDisabledFilter(arg_84_0, arg_84_1)
	if not arg_84_0.vars or not get_cocos_refid(arg_84_0.vars.wnd) or not arg_84_1 then
		return 
	end
	
	local var_84_0 = ItemFilterUtil:getDefaultUnHashTable()
	
	if table.empty(var_84_0) then
		return 
	end
	
	local var_84_1 = arg_84_0.vars.wnd:getChildByName("n_" .. arg_84_1)
	
	if get_cocos_refid(var_84_1) then
		for iter_84_0, iter_84_1 in pairs(var_84_0[arg_84_1] or {}) do
			local var_84_2 = var_84_1:getChildByName("n_check_box_" .. tostring(iter_84_0))
			
			if get_cocos_refid(var_84_2) then
				var_84_2:setOpacity(76.5)
				if_set_visible(var_84_2, "btn_checkbox_" .. arg_84_1 .. "_" .. tostring(iter_84_0), false)
			end
		end
	end
end

SorterExtention = {}

function SorterExtention.init(arg_85_0, arg_85_1)
	local var_85_0 = arg_85_1 or {}
	
	arg_85_0.vars = {}
	arg_85_0.vars.sets = UIUtil:getSetItemListExtention(true)
	arg_85_0.vars.mainstats = var_0_0
	arg_85_0.vars.substats = var_0_0
	arg_85_0.vars.mainstat = var_85_0.mainstat or "all"
	arg_85_0.vars.substat1 = var_85_0.substat1 or "all"
	arg_85_0.vars.substat2 = var_85_0.substat2 or "all"
	arg_85_0.vars.set = var_85_0.set or "all"
	
	if var_85_0.sorter then
		local var_85_1 = var_85_0.sorter
		
		arg_85_0.vars.sorter = var_85_1
		arg_85_0.vars.sorter_wnd = var_85_1.vars.wnd
		arg_85_0.vars.filterPopup = arg_85_0.vars.sorter_wnd
		
		if_set_visible(arg_85_0.vars.filterPopup, "btn_set_selected", false)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_mainstat_selected", false)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_substat1_selected", false)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_substat2_selected", false)
		
		arg_85_0.vars.n_set_box = load_control("wnd/sorting_filter_equip_set.csb")
		arg_85_0.vars.n_mainstat_box = load_control("wnd/sorting_filter_equip_stat.csb")
		arg_85_0.vars.n_substat_box = load_control("wnd/sorting_filter_equip_stat.csb")
		arg_85_0.vars.n_set_box.sorter = var_85_1
		arg_85_0.vars.n_mainstat_box.sorter = var_85_1
		arg_85_0.vars.n_substat_box.sorter = var_85_1
		
		arg_85_0.vars.n_set_box:setName("n_set_box")
		arg_85_0.vars.n_mainstat_box:setName("n_mainstat_box")
		arg_85_0.vars.n_substat_box:setName("n_substat_box")
		
		local var_85_2 = arg_85_0.vars.filterPopup:getChildByName("n_filter_set_box")
		
		if var_85_0.is_inventory_equip then
			if_set_visible(arg_85_0.vars.filterPopup, "n_filter_set_box2_r", true)
			
			var_85_2 = arg_85_0.vars.filterPopup:getChildByName("n_filter_set_box2_r")
		end
		
		if get_cocos_refid(var_85_2) then
			var_85_2:addChild(arg_85_0.vars.n_set_box)
		end
		
		arg_85_0.vars.filterPopup:getChildByName("n_filter_stat_box_main"):addChild(arg_85_0.vars.n_mainstat_box)
		arg_85_0.vars.filterPopup:getChildByName("n_filter_stat_box_sub1_up"):addChild(arg_85_0.vars.n_substat_box)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_set_sel", false)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_main_sel", false)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_substat1_sel", false)
		if_set_visible(arg_85_0.vars.filterPopup, "btn_substat2_sel", false)
		arg_85_0.vars.n_set_box:setVisible(false)
		arg_85_0.vars.n_mainstat_box:setVisible(false)
		arg_85_0.vars.n_substat_box:setVisible(false)
		
		arg_85_0.vars.setnames = {}
		
		local var_85_3 = 1
		
		for iter_85_0, iter_85_1 in pairs(arg_85_0.vars.sets) do
			local var_85_4 = arg_85_0.vars.n_set_box:getChildByName("btn_sort_" .. var_85_3)
			local var_85_5 = DB("item_set", iter_85_1, {
				"name"
			}) or "ui_equip_base_stat_filter_all"
			
			if_set(var_85_4, "txt_sort" .. var_85_3, T(var_85_5))
			
			var_85_3 = var_85_3 + 1
		end
		
		arg_85_0.vars.setnames.all = T("ui_equip_base_stat_filter_all")
		
		if var_85_0.movePosition then
			local var_85_6 = arg_85_0.vars.filterPopup:getChildByName("n_sort")
			local var_85_7 = arg_85_0.vars.filterPopup:getChildByName("n_sort_2position")
			
			var_85_6:setPosition(var_85_7:getPosition())
		end
	end
	
	arg_85_0:setAllBox()
	arg_85_0:setAll_sortButtonColors()
end

function SorterExtention.moveParent(arg_86_0, arg_86_1)
	if not arg_86_0.vars or not get_cocos_refid(arg_86_0.vars.filterPopup) then
		return 
	end
	
	local var_86_0 = arg_86_0:movePosition(arg_86_1)
	local var_86_1 = arg_86_0.vars.filterPopup:getChildByName("n_filter_stat_box_sub" .. arg_86_1 .. (var_86_0 and "_up" or ""))
	
	if get_cocos_refid(var_86_1) then
		arg_86_0.vars.n_substat_box:ejectFromParent()
		var_86_1:addChild(arg_86_0.vars.n_substat_box)
	end
end

function SorterExtention.movePosition(arg_87_0, arg_87_1)
	if not arg_87_0.vars or not get_cocos_refid(arg_87_0.vars.filterPopup) then
		return 
	end
	
	local var_87_0 = arg_87_0.vars.filterPopup:getChildByName("n_filter_stat_box_sub" .. arg_87_1)
	
	if not get_cocos_refid(var_87_0) then
		return 
	end
	
	local var_87_1 = arg_87_0.vars.n_substat_box:getChildByName("bg"):getContentSize().height - 20
	
	if math.floor(var_87_0:getWorldPosition().y) - var_87_1 < -10 then
		return true
	end
	
	return false
end

function SorterExtention.setSetStatFilter(arg_88_0, arg_88_1)
	if not arg_88_1 then
		return 
	end
	
	local var_88_0 = arg_88_0.vars.sets[arg_88_1]
	
	if not var_88_0 then
		return 
	end
	
	arg_88_0.vars.set = var_88_0
end

function SorterExtention.setMainStatFilter(arg_89_0, arg_89_1)
	if not arg_89_1 then
		return 
	end
	
	local var_89_0 = arg_89_0.vars.mainstats[arg_89_1]
	
	if not var_89_0 then
		return 
	end
	
	arg_89_0.vars.mainstat = var_89_0
end

function SorterExtention.setSubStatFilter(arg_90_0, arg_90_1, arg_90_2)
	if not arg_90_1 or not arg_90_2 then
		return 
	end
	
	local var_90_0 = arg_90_2 or 1 or 2
	local var_90_1 = arg_90_0.vars.substats[arg_90_1]
	
	if not var_90_1 then
		return 
	end
	
	if var_90_0 == 1 then
		arg_90_0.vars.substat1 = var_90_1
	else
		arg_90_0.vars.substat2 = var_90_1
	end
end

function SorterExtention.getSetStatOpt(arg_91_0)
	return arg_91_0.vars.set
end

function SorterExtention.getMainStatOpt(arg_92_0)
	return arg_92_0.vars.mainstat
end

function SorterExtention.getSubStatOpt(arg_93_0, arg_93_1)
	if not arg_93_1 then
		return 
	end
	
	if arg_93_1 == 1 then
		return arg_93_0.vars.substat1
	else
		return arg_93_0.vars.substat2
	end
end

function SorterExtention.getOrigianlList(arg_94_0)
	return arg_94_0.vars.original_list
end

function SorterExtention.setOrigianlList(arg_95_0, arg_95_1)
	if not arg_95_1 then
		return 
	end
	
	arg_95_0.vars.original_list = arg_95_1
end

function SorterExtention.checkFilterOptions(arg_96_0, arg_96_1, arg_96_2)
	if not arg_96_1 then
		return false
	end
	
	local var_96_0 = arg_96_2 or {}
	local var_96_1 = var_96_0.set or arg_96_0.vars.set
	local var_96_2 = var_96_0.mainstat or arg_96_0.vars.mainstat
	local var_96_3 = var_96_0.substat1 or arg_96_0.vars.substat1
	local var_96_4 = var_96_0.substat2 or arg_96_0.vars.substat2
	
	if var_96_1 == "all" and var_96_2 == "all" and var_96_3 == "all" and var_96_4 == "all" then
		return true
	end
	
	if arg_96_1.equip then
		arg_96_1 = arg_96_1.equip
	end
	
	if arg_96_1.isStone and arg_96_1:isStone() then
		return true
	end
	
	if var_96_1 == "all" or var_96_1 == arg_96_1.set_fx then
		local var_96_5, var_96_6 = arg_96_1:getMainStat()
		
		if var_96_2 == "all" or var_96_2 == var_96_6 then
			if var_96_3 == "all" and var_96_4 == "all" then
				return true
			end
			
			if var_96_3 == "all" or var_96_4 == "all" then
				for iter_96_0, iter_96_1 in pairs(arg_96_1.op) do
					if iter_96_0 ~= 1 and iter_96_1[1] and (iter_96_1[1] == var_96_3 or iter_96_1[1] == var_96_4) then
						return true
					end
				end
			end
			
			local var_96_7 = false
			local var_96_8 = false
			
			if var_96_3 ~= "all" and var_96_4 ~= "all" then
				for iter_96_2, iter_96_3 in pairs(arg_96_1.op) do
					if iter_96_2 ~= 1 and iter_96_3[1] then
						if iter_96_3[1] == var_96_3 then
							var_96_7 = true
						elseif iter_96_3[1] == var_96_4 then
							var_96_8 = true
						end
					end
				end
			end
			
			if var_96_7 and var_96_8 then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function SorterExtention.checkFilterOptionsGeneric(arg_97_0, arg_97_1, arg_97_2)
	if not arg_97_0.vars then
		return 
	end
	
	local var_97_0 = arg_97_0.vars.original_list or arg_97_1
	
	if not var_97_0 then
		return 
	end
	
	local var_97_1
	
	var_97_1 = arg_97_2 or {}
	
	local var_97_2 = {}
	
	for iter_97_0, iter_97_1 in pairs(var_97_0) do
		if arg_97_0:checkFilterOptions(iter_97_1) then
			table.insert(var_97_2, iter_97_1)
		end
	end
	
	return var_97_2
end

function SorterExtention.openOptsFilter(arg_98_0)
	if not arg_98_0.vars or not get_cocos_refid(arg_98_0.vars.sorter_wnd) then
		return 
	end
	
	SorterExtentionUtil:updateAllButtons(arg_98_0.vars.filterPopup, {
		isExtention = true,
		setOpt = arg_98_0.vars.set,
		mainOpt = arg_98_0.vars.mainstat,
		substat1_opt = arg_98_0.vars.substat1,
		substat2_opt = arg_98_0.vars.substat2
	})
	arg_98_0:setAll_sortButtonColors()
end

function SorterExtention.onClickEventExtentionFilter(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	if not arg_99_2 then
		return 
	end
	
	arg_99_0 = getParentWindow(arg_99_1).sorter.sorter_extention
	
	if not arg_99_0.vars or not get_cocos_refid(arg_99_0.vars.sorter_wnd) then
		return 
	end
	
	local var_99_0 = not string.find(arg_99_2, "done")
	
	if var_99_0 then
		arg_99_0:closeAll()
	end
	
	if arg_99_0.vars.sorter and not arg_99_0.vars.sorter:isShow() and (arg_99_2 == "btn_set" or arg_99_2 == "btn_set_sel" or arg_99_2 == "btn_mainstat" or arg_99_2 == "btn_mainstat_sel" or arg_99_2 == "btn_substat1" or arg_99_2 == "btn_substat1_sel" or arg_99_2 == "btn_substat2" or arg_99_2 == "btn_substat2_sel") then
		arg_99_0:closeAll()
		
		return 
	end
	
	if arg_99_2 == "btn_set" or arg_99_2 == "btn_set_sel" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
		
		arg_99_0.vars.curset = "set"
	elseif arg_99_2 == "btn_set_done" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
	elseif arg_99_2 == "btn_mainstat" or arg_99_2 == "btn_mainstat_sel" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
		
		arg_99_0.vars.curset = "mainstat"
	elseif arg_99_2 == "btn_mainstat_done" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
	elseif arg_99_2 == "btn_substat1" or arg_99_2 == "btn_substat1_sel" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
		
		arg_99_0.vars.curset = "substat1"
	elseif arg_99_2 == "btn_substat1_done" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
	elseif arg_99_2 == "btn_substat2" or arg_99_2 == "btn_substat2_sel" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
		
		arg_99_0.vars.curset = "substat2"
	elseif arg_99_2 == "btn_substat2_done" then
		arg_99_0:toggleOptsFilterBox(arg_99_2, var_99_0)
	elseif arg_99_2 == "btn_checkbox_star_all" then
		arg_99_0:reset_allFilterOpts()
	elseif arg_99_2 == "btn_cancle" then
		arg_99_0:closeAll()
	end
	
	if string.find(arg_99_2, "done") or arg_99_2 == "btn_cancle" then
		arg_99_0.vars.curset = nil
	end
	
	if string.find(arg_99_2, "btn_sort_") then
		local var_99_1 = string.split(arg_99_2, "_")[3] or 1
		
		arg_99_0:setFilterOpt(tonumber(var_99_1))
		arg_99_0.vars.sorter:setisChangeFilter(true)
	end
end

function SorterExtention.setFilterOpt(arg_100_0, arg_100_1)
	if arg_100_0.vars.curset == "set" then
		arg_100_0:setSetStatFilter(arg_100_1)
		SorterExtentionUtil:setFilterUI(arg_100_0.vars.filterPopup:getChildByName("n_set_box"), arg_100_1, table.count(arg_100_0.vars.sets))
		arg_100_0:setSortButton_color(arg_100_0.vars.filterPopup:getChildByName("n_btn_set"), arg_100_1, {
			ignore_icon = true
		})
	elseif arg_100_0.vars.curset == "mainstat" then
		arg_100_0:setMainStatFilter(arg_100_1)
		SorterExtentionUtil:setFilterUI(arg_100_0.vars.filterPopup:getChildByName("n_mainstat_box"), arg_100_1, 12)
		arg_100_0:setSortButton_color(arg_100_0.vars.filterPopup:getChildByName("n_btn_mainstat"), arg_100_1)
	elseif arg_100_0.vars.curset == "substat1" then
		arg_100_0:setSubStatFilter(arg_100_1, 1)
		SorterExtentionUtil:setFilterUI(arg_100_0.vars.filterPopup:getChildByName("n_substat_box"), arg_100_1, 12)
		arg_100_0:setSortButton_color(arg_100_0.vars.filterPopup:getChildByName("n_btn_substat1"), arg_100_1)
	elseif arg_100_0.vars.curset == "substat2" then
		arg_100_0:setSubStatFilter(arg_100_1, 2)
		SorterExtentionUtil:setFilterUI(arg_100_0.vars.filterPopup:getChildByName("n_substat_box"), arg_100_1, 12)
		arg_100_0:setSortButton_color(arg_100_0.vars.filterPopup:getChildByName("n_btn_substat2"), arg_100_1)
	end
	
	arg_100_0:setAllBox()
	arg_100_0:closeAll()
end

function SorterExtention.setSortButton_color(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	if not arg_101_1 or not arg_101_2 then
		return 
	end
	
	local var_101_0 = arg_101_3 or {}
	local var_101_1 = var_101_0.set_name or arg_101_0.vars.curset
	local var_101_2 = arg_101_1:getChildByName("btn_" .. var_101_1)
	local var_101_3 = arg_101_1:getChildByName("btn_" .. var_101_1 .. "_sel")
	
	if arg_101_2 == 1 then
		if_set_visible(arg_101_1, "select_bg_star_all_0", false)
		if_set_color(arg_101_1, "label", tocolor("#FFFFFF"))
		if_set_opacity(arg_101_1, "label", 76.5)
		if_set_color(arg_101_1, "icon_stat", tocolor("#FFFFFF"))
		
		if var_101_2 then
			var_101_2:setVisible(true)
		end
		
		if var_101_3 then
			var_101_3:setVisible(false)
		end
	else
		if_set_visible(arg_101_1, "select_bg_star_all_0", true)
		if_set_color(arg_101_1, "label", tocolor("#6BC11B"))
		if_set_opacity(arg_101_1, "label", 255)
		if_set_color(arg_101_1, "icon_stat", tocolor("#6BC11B"))
		
		if var_101_2 then
			var_101_2:setVisible(false)
		end
		
		if var_101_3 then
			var_101_3:setVisible(true)
		end
	end
	
	if var_101_0.ignore_icon then
		if_set_color(arg_101_1, "icon_stat", tocolor("#FFFFFF"))
	end
end

function SorterExtention.setAllBox(arg_102_0)
	local var_102_0 = arg_102_0:getSetStatOpt() == "all" and arg_102_0:getMainStatOpt() == "all" and arg_102_0:getSubStatOpt(1) == "all" and arg_102_0:getSubStatOpt(2) == "all" or false
	local var_102_1 = arg_102_0.vars.filterPopup:getChildByName("n_check_box_all")
	
	if_set_visible(var_102_1, "select_bg_star_all", var_102_0)
	var_102_1:getChildByName("checkbox_star_all"):setSelected(var_102_0)
end

function SorterExtention.toggleOptsFilterBox(arg_103_0, arg_103_1, arg_103_2)
	local var_103_0 = arg_103_0.vars.filterPopup
	
	if arg_103_1 == "btn_set" or arg_103_1 == "btn_set_sel" or arg_103_1 == "btn_set_done" then
		if_set_visible(var_103_0, "n_set_box", arg_103_2)
		if_set_visible(var_103_0, "btn_set", not arg_103_2)
		if_set_visible(var_103_0, "btn_set_sel", not arg_103_2)
		if_set_visible(var_103_0, "btn_set_done", arg_103_2)
	elseif arg_103_1 == "btn_mainstat" or arg_103_1 == "btn_mainstat_sel" or arg_103_1 == "btn_mainstat_done" then
		if_set_visible(var_103_0, "n_mainstat_box", arg_103_2)
		if_set_visible(var_103_0, "btn_mainstat", not arg_103_2)
		if_set_visible(var_103_0, "btn_mainstat_sel", not arg_103_2)
		if_set_visible(var_103_0, "btn_mainstat_done", arg_103_2)
	elseif arg_103_1 == "btn_substat1" or arg_103_1 == "btn_substat1_sel" or arg_103_1 == "btn_substat1_done" or arg_103_1 == "btn_substat2" or arg_103_1 == "btn_substat2_sel" or arg_103_1 == "btn_substat2_done" then
		if_set_visible(var_103_0, "n_substat_box", arg_103_2)
		
		if string.find(arg_103_1, "1") then
			arg_103_0:moveParent(1)
			if_set_visible(var_103_0, "btn_substat1", not arg_103_2)
			if_set_visible(var_103_0, "btn_substat1_sel", not arg_103_2)
			if_set_visible(var_103_0, "btn_substat1_done", arg_103_2)
		else
			arg_103_0:moveParent(2)
			if_set_visible(var_103_0, "btn_substat2", not arg_103_2)
			if_set_visible(var_103_0, "btn_substat2_sel", not arg_103_2)
			if_set_visible(var_103_0, "btn_substat2_done", arg_103_2)
		end
		
		if arg_103_2 then
			local var_103_1 = string.find(arg_103_1, "1") and 1 or 2
			
			arg_103_0:_setSubstatBox(var_103_0:getChildByName("n_substat_box"), var_103_1)
		end
	end
end

function SorterExtention._setSubstatBox(arg_104_0, arg_104_1, arg_104_2)
	if not get_cocos_refid(arg_104_1) or not arg_104_2 then
		return 
	end
	
	for iter_104_0, iter_104_1 in pairs(arg_104_0.vars.substats) do
		if iter_104_1 == arg_104_0:getSubStatOpt(arg_104_2) then
			SorterExtentionUtil:setFilterUI(arg_104_1, iter_104_0, 12)
		end
	end
end

function SorterExtention.closeAll(arg_105_0)
	local var_105_0 = arg_105_0.vars.filterPopup
	local var_105_1 = false
	
	if_set_visible(var_105_0, "n_set_box", var_105_1)
	if_set_visible(var_105_0, "n_mainstat_box", var_105_1)
	if_set_visible(var_105_0, "n_substat_box", var_105_1)
	if_set_visible(var_105_0, "btn_set", not var_105_1)
	if_set_visible(var_105_0, "btn_mainstat", not var_105_1)
	if_set_visible(var_105_0, "btn_substat1", not var_105_1)
	if_set_visible(var_105_0, "btn_substat2", not var_105_1)
	if_set_visible(var_105_0, "btn_set_done", var_105_1)
	if_set_visible(var_105_0, "btn_mainstat_done", var_105_1)
	if_set_visible(var_105_0, "btn_substat1_done", var_105_1)
	if_set_visible(var_105_0, "btn_substat2_done", var_105_1)
	SorterExtentionUtil:updateAllButtons(arg_105_0.vars.filterPopup, {
		isExtention = true,
		setOpt = arg_105_0.vars.set,
		mainOpt = arg_105_0.vars.mainstat,
		substat1_opt = arg_105_0.vars.substat1,
		substat2_opt = arg_105_0.vars.substat2
	})
	arg_105_0:setAll_sortButtonColors()
	arg_105_0:setToggleButtonColor()
end

function SorterExtention.getIconPath(arg_106_0, arg_106_1)
	local var_106_0
	
	if string.find(arg_106_1, "all") then
		return 
	end
	
	if string.find(arg_106_1, "set_") then
		var_106_0 = "item/icon_" .. arg_106_1 .. ".png"
	else
		var_106_0 = "img/icon_menu_" .. arg_106_1 .. ".png"
	end
	
	return (string.gsub(var_106_0, "_rate", ""))
end

function SorterExtention.set_allFilterOpts(arg_107_0, arg_107_1)
	local var_107_0 = arg_107_1 or {}
	local var_107_1 = var_0_1
	local var_107_2 = {
		all = 1,
		def = 3,
		def_rate = 6,
		cri = 9,
		cri_dmg = 10,
		acc = 11,
		max_hp_rate = 7,
		speed = 8,
		res = 12,
		max_hp = 4,
		att_rate = 5,
		att = 2
	}
	local var_107_3 = var_107_1[var_107_0.set] or 1
	local var_107_4 = var_107_2[var_107_0.mainstat] or 1
	local var_107_5 = var_107_2[var_107_0.substat1] or 1
	local var_107_6 = var_107_2[var_107_0.substat2] or 1
	
	arg_107_0:setSetStatFilter(var_107_3)
	SorterExtentionUtil:setFilterUI(arg_107_0.vars.filterPopup:getChildByName("n_set_box"), var_107_3, table.count(arg_107_0.vars.sets))
	arg_107_0:setMainStatFilter(var_107_4)
	SorterExtentionUtil:setFilterUI(arg_107_0.vars.filterPopup:getChildByName("n_mainstat_box"), var_107_4, 12)
	arg_107_0:setSubStatFilter(var_107_5, 1)
	SorterExtentionUtil:setFilterUI(arg_107_0.vars.filterPopup:getChildByName("n_substat_box"), var_107_5, 12)
	arg_107_0:setSubStatFilter(var_107_6, 2)
	SorterExtentionUtil:setFilterUI(arg_107_0.vars.filterPopup:getChildByName("n_substat_box"), var_107_6, 12)
	arg_107_0:closeAll()
	arg_107_0.vars.sorter:setisChangeFilter(true)
	arg_107_0:setAllBox()
end

function SorterExtention.setAll_sortButtonColors(arg_108_0)
	local var_108_0 = var_0_1
	local var_108_1 = {
		all = 1,
		def = 3,
		def_rate = 6,
		cri = 9,
		cri_dmg = 10,
		acc = 11,
		max_hp_rate = 7,
		speed = 8,
		res = 12,
		max_hp = 4,
		att_rate = 5,
		att = 2
	}
	
	arg_108_0:setSortButton_color(arg_108_0.vars.filterPopup:getChildByName("n_btn_set"), var_108_0[arg_108_0.vars.set], {
		set_name = "set",
		ignore_icon = true
	})
	arg_108_0:setSortButton_color(arg_108_0.vars.filterPopup:getChildByName("n_btn_mainstat"), var_108_1[arg_108_0.vars.mainstat], {
		set_name = "mainstat"
	})
	arg_108_0:setSortButton_color(arg_108_0.vars.filterPopup:getChildByName("n_btn_substat1"), var_108_1[arg_108_0.vars.substat1], {
		set_name = "substat1"
	})
	arg_108_0:setSortButton_color(arg_108_0.vars.filterPopup:getChildByName("n_btn_substat2"), var_108_1[arg_108_0.vars.substat2], {
		set_name = "substat2"
	})
end

function SorterExtention.reset_allFilterOpts(arg_109_0)
	if not arg_109_0.vars or not get_cocos_refid(arg_109_0.vars.filterPopup) then
		return 
	end
	
	local var_109_0 = 1
	
	arg_109_0:setSetStatFilter(var_109_0)
	SorterExtentionUtil:setFilterUI(arg_109_0.vars.filterPopup:getChildByName("n_set_box"), var_109_0, table.count(arg_109_0.vars.sets))
	arg_109_0:setMainStatFilter(var_109_0)
	SorterExtentionUtil:setFilterUI(arg_109_0.vars.filterPopup:getChildByName("n_mainstat_box"), var_109_0, 12)
	arg_109_0:setSubStatFilter(var_109_0, 1)
	SorterExtentionUtil:setFilterUI(arg_109_0.vars.filterPopup:getChildByName("n_substat_box"), var_109_0, 12)
	arg_109_0:setSubStatFilter(var_109_0, 2)
	SorterExtentionUtil:setFilterUI(arg_109_0.vars.filterPopup:getChildByName("n_substat_box"), var_109_0, 12)
	arg_109_0:setAll_sortButtonColors()
	arg_109_0:closeAll()
	arg_109_0.vars.sorter:setisChangeFilter(true)
	
	local var_109_1 = arg_109_0.vars.filterPopup:getChildByName("n_check_box_all")
	
	if_set_visible(var_109_1, "select_bg_star_all", true)
	var_109_1:getChildByName("checkbox_star_all"):setSelected(true)
end

function SorterExtention.get_setBox(arg_110_0)
	if not arg_110_0.vars then
		return 
	end
	
	return arg_110_0.vars.n_set_box
end

function SorterExtention.setToggleButtonColor(arg_111_0)
	local var_111_0 = arg_111_0:getFilterActive()
	
	if_set_visible(arg_111_0.vars.filterPopup, "btn_toggle_active", var_111_0)
	if_set_visible(arg_111_0.vars.filterPopup, "btn_toggle", not var_111_0)
end

function SorterExtention.getFilterActive(arg_112_0)
	local var_112_0 = arg_112_0.vars.set == "all" and arg_112_0.vars.mainstat == "all" and arg_112_0.vars.substat1 == "all" and arg_112_0.vars.substat2 == "all"
	
	var_112_0 = var_112_0 and not arg_112_0.vars.sorter:getFilterActive()
	
	return not var_112_0
end

function SorterExtention.closeOptsFilter(arg_113_0)
	if not arg_113_0.vars or not get_cocos_refid(arg_113_0.vars.filterPopup) then
		return 
	end
	
	arg_113_0:closeAll()
end

SorterExtentionUtil = {}

function SorterExtentionUtil.initSetUI_opts(arg_114_0, arg_114_1, arg_114_2, arg_114_3)
	if not arg_114_1 or not get_cocos_refid(arg_114_2) then
		return 
	end
	
	local var_114_0 = arg_114_3 or {}
	
	arg_114_1.sets = UIUtil:getSetItemListExtention(true)
	arg_114_1.mainstats = var_0_0
	arg_114_1.substats = var_0_0
	arg_114_1.mainstat = var_114_0.mainstat or "all"
	arg_114_1.substat1 = var_114_0.substat1 or "all"
	arg_114_1.substat2 = var_114_0.substat2 or "all"
	arg_114_1.set = var_114_0.set or "all"
	arg_114_1.n_set_box = load_control("wnd/sorting_filter_equip_set.csb")
	arg_114_1.n_mainstat_box = load_control("wnd/sorting_filter_equip_stat.csb")
	arg_114_1.n_substat_box = load_control("wnd/sorting_filter_equip_stat.csb")
	
	arg_114_1.n_set_box:setName("autosell_n_set_box")
	arg_114_1.n_mainstat_box:setName("autosell_n_mainstat_box")
	arg_114_1.n_substat_box:setName("autosell_n_substat_box")
	
	if var_114_0.is_pet_inventory then
		local var_114_1 = arg_114_2:getChildByName("n_filter_set_box2")
		
		if get_cocos_refid(var_114_1) then
			var_114_1:addChild(arg_114_1.n_set_box)
			var_114_1:setVisible(true)
		end
	else
		arg_114_2:getChildByName("n_filter_set_box"):addChild(arg_114_1.n_set_box)
	end
	
	arg_114_2:getChildByName("n_filter_stat_box_main"):addChild(arg_114_1.n_mainstat_box)
	arg_114_2:getChildByName("n_filter_stat_box_sub"):addChild(arg_114_1.n_substat_box)
	arg_114_1.n_set_box:setVisible(false)
	arg_114_1.n_mainstat_box:setVisible(false)
	arg_114_1.n_substat_box:setVisible(false)
	if_set_visible(arg_114_2, "btn_set_selected", false)
	if_set_visible(arg_114_2, "btn_mainstat_selected", false)
	if_set_visible(arg_114_2, "btn_substat1_selected", false)
	if_set_visible(arg_114_2, "btn_substat2_selected", false)
	if_set_visible(arg_114_2, "btn_set_done", false)
	if_set_visible(arg_114_2, "btn_mainstat_done", false)
	if_set_visible(arg_114_2, "btn_substat1_done", false)
	if_set_visible(arg_114_2, "btn_substat2_done", false)
	
	local var_114_2 = 1
	
	for iter_114_0, iter_114_1 in pairs(arg_114_1.sets) do
		local var_114_3 = arg_114_1.n_set_box:getChildByName("btn_sort_" .. var_114_2)
		local var_114_4 = DB("item_set", iter_114_1, {
			"name"
		}) or "ui_equip_base_stat_filter_all"
		
		if_set(var_114_3, "txt_sort" .. var_114_2, T(var_114_4))
		
		var_114_2 = var_114_2 + 1
	end
end

function SorterExtentionUtil.updateAllButtons(arg_115_0, arg_115_1, arg_115_2)
	if not get_cocos_refid(arg_115_1) then
		return 
	end
	
	local var_115_0 = arg_115_2 or {}
	local var_115_1 = var_115_0.setOpt
	local var_115_2 = var_115_0.mainOpt
	local var_115_3 = var_115_0.substat1_opt
	local var_115_4 = var_115_0.substat2_opt
	local var_115_5 = "all"
	
	if var_115_1 then
		var_115_5 = "item/icon_" .. var_115_1 .. ".png"
		var_115_5 = SorterExtention:getIconPath(var_115_1)
	end
	
	local var_115_6 = ""
	
	if var_115_0.isExtention then
		var_115_6 = "n_"
	end
	
	local var_115_7 = var_115_6 .. "btn_set"
	local var_115_8 = var_115_6 .. "btn_mainstat"
	local var_115_9 = var_115_6 .. "btn_substat1"
	local var_115_10 = var_115_6 .. "btn_substat2"
	
	if_set_sprite(arg_115_1:getChildByName(var_115_7), "icon_stat", var_115_5)
	if_set_sprite(arg_115_1:getChildByName("btn_set_done"), "icon_stat", var_115_5)
	
	if var_115_2 then
		var_115_5 = SorterExtention:getIconPath(var_115_2)
		
		if_set_visible(arg_115_1:getChildByName(var_115_8), "icon_pers", string.find(var_115_2, "rate"))
		if_set_visible(arg_115_1:getChildByName("btn_mainstat_done"), "icon_pers", string.find(var_115_2, "rate"))
	end
	
	if_set_sprite(arg_115_1:getChildByName(var_115_8), "icon_stat", var_115_5)
	if_set_sprite(arg_115_1:getChildByName("btn_mainstat_done"), "icon_stat", var_115_5)
	
	if var_115_3 then
		var_115_5 = SorterExtention:getIconPath(var_115_3)
		
		if_set_visible(arg_115_1:getChildByName(var_115_9), "icon_pers", string.find(var_115_3, "rate"))
		if_set_visible(arg_115_1:getChildByName("btn_substat1_done"), "icon_pers", string.find(var_115_3, "rate"))
	end
	
	if_set_sprite(arg_115_1:getChildByName(var_115_9), "icon_stat", var_115_5)
	if_set_sprite(arg_115_1:getChildByName("btn_substat1_done"), "icon_stat", var_115_5)
	
	if var_115_4 then
		var_115_5 = SorterExtention:getIconPath(var_115_4)
		
		if_set_visible(arg_115_1:getChildByName(var_115_10), "icon_pers", string.find(var_115_4, "rate"))
		if_set_visible(arg_115_1:getChildByName("btn_substat2_done"), "icon_pers", string.find(var_115_4, "rate"))
	end
	
	if_set_sprite(arg_115_1:getChildByName(var_115_10), "icon_stat", var_115_5)
	if_set_sprite(arg_115_1:getChildByName("btn_substat2_done"), "icon_stat", var_115_5)
	
	local var_115_11 = var_115_1 == "all"
	local var_115_12 = var_115_2 == "all"
	local var_115_13 = var_115_3 == "all"
	local var_115_14 = var_115_4 == "all"
	
	if_set_visible(arg_115_1:getChildByName(var_115_7), "icon_all", var_115_11)
	if_set_visible(arg_115_1:getChildByName(var_115_7), "icon_stat", not var_115_11)
	if_set_visible(arg_115_1:getChildByName("btn_set_done"), "icon_all", var_115_11)
	if_set_visible(arg_115_1:getChildByName("btn_set_done"), "icon_stat", not var_115_11)
	if_set_visible(arg_115_1:getChildByName(var_115_8), "icon_all", var_115_12)
	if_set_visible(arg_115_1:getChildByName(var_115_8), "icon_stat", not var_115_12)
	if_set_visible(arg_115_1:getChildByName("btn_mainstat_done"), "icon_all", var_115_12)
	if_set_visible(arg_115_1:getChildByName("btn_mainstat_done"), "icon_stat", not var_115_12)
	if_set_visible(arg_115_1:getChildByName(var_115_9), "icon_all", var_115_13)
	if_set_visible(arg_115_1:getChildByName(var_115_9), "icon_stat", not var_115_13)
	if_set_visible(arg_115_1:getChildByName("btn_substat1_done"), "icon_all", var_115_13)
	if_set_visible(arg_115_1:getChildByName("btn_substat1_done"), "icon_stat", not var_115_13)
	if_set_visible(arg_115_1:getChildByName(var_115_10), "icon_all", var_115_14)
	if_set_visible(arg_115_1:getChildByName(var_115_10), "icon_stat", not var_115_14)
	if_set_visible(arg_115_1:getChildByName("btn_substat2_done"), "icon_all", var_115_14)
	if_set_visible(arg_115_1:getChildByName("btn_substat2_done"), "icon_stat", not var_115_14)
end

function SorterExtentionUtil.setFilterUI(arg_116_0, arg_116_1, arg_116_2, arg_116_3)
	if not get_cocos_refid(arg_116_1) or not arg_116_2 or not arg_116_3 then
		return 
	end
	
	for iter_116_0 = 1, arg_116_3 do
		local var_116_0 = arg_116_1:getChildByName("btn_sort_" .. iter_116_0)
		
		if not var_116_0 then
			break
		end
		
		if iter_116_0 == arg_116_2 then
			if_set_visible(var_116_0, "cursor", true)
		else
			if_set_visible(var_116_0, "cursor", false)
		end
	end
end

function SorterExtentionUtil.set_itemSetCounts(arg_117_0, arg_117_1, arg_117_2)
	if not get_cocos_refid(arg_117_1) then
		return 
	end
	
	local var_117_0 = var_0_1
	local var_117_1 = {}
	local var_117_2 = UIUtil:getSetItemListExtention(true)
	
	for iter_117_0, iter_117_1 in pairs(var_117_2) do
		var_117_1[iter_117_1] = {}
		var_117_1[iter_117_1].count = 0
		var_117_1[iter_117_1].sort = var_117_0[iter_117_1]
	end
	
	if not arg_117_2 or table.count(arg_117_2) <= 0 then
		for iter_117_2 = 2, table.count(var_117_2) do
			local var_117_3 = "txt_amount" .. iter_117_2
			
			if_set(arg_117_1, var_117_3, 0)
		end
		
		return 
	end
	
	for iter_117_3, iter_117_4 in pairs(arg_117_2) do
		local var_117_4 = iter_117_4.set_fx
		
		if iter_117_4.equip then
			var_117_4 = iter_117_4.equip.set_fx
		end
		
		if var_117_4 and var_117_1[var_117_4] then
			var_117_1[var_117_4].count = var_117_1[var_117_4].count + 1
		end
	end
	
	for iter_117_5 = 2, table.count(var_117_2) do
		local var_117_5 = "txt_amount" .. iter_117_5
		
		if not arg_117_1:getChildByName(var_117_5) then
			break
		end
	end
	
	for iter_117_6, iter_117_7 in pairs(var_117_1) do
		if iter_117_7.sort ~= 0 then
			local var_117_6 = "txt_amount" .. iter_117_7.sort
			
			if_set(arg_117_1, var_117_6, iter_117_7.count)
		end
	end
end
