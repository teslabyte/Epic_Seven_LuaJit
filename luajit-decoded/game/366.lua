local var_0_0 = 9

function HANDLER_BEFORE.sort_buff_ui(arg_1_0, arg_1_1, arg_1_2)
	if string.starts(arg_1_1, "btn_checkbox") then
		arg_1_0.touch_tick = systick()
	end
end

function HANDLER_BEFORE.sort_debuff_ui(arg_2_0, arg_2_1, arg_2_2)
	if string.starts(arg_2_1, "btn_checkbox") then
		arg_2_0.touch_tick = systick()
	end
end

function HANDLER.sort_buff_ui(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = getParentWindow(arg_3_0).filter
	
	if not var_3_0 then
		return 
	end
	
	if arg_3_1 == "btn_toggle" then
		var_3_0:closeBuffList()
	elseif string.starts(arg_3_1, "btn_checkbox") and systick() - to_n(arg_3_0.touch_tick) < 180 then
		var_3_0:addOne(arg_3_0, arg_3_0.id, arg_3_0.effect_id, "buff")
	end
end

function HANDLER.sort_debuff_ui(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = getParentWindow(arg_4_0).filter
	
	if not var_4_0 then
		return 
	end
	
	if arg_4_1 == "btn_toggle" then
		var_4_0:closeDeBuffList()
	elseif string.starts(arg_4_1, "btn_checkbox") and systick() - to_n(arg_4_0.touch_tick) < 180 then
		var_4_0:addOne(arg_4_0, arg_4_0.id, arg_4_0.effect_id, "debuff")
	end
end

SkillEffectFilterUI = {}

function SkillEffectFilterUI.addOne(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not arg_5_1 or not arg_5_2 or not arg_5_3 then
		return 
	end
	
	arg_5_0.vars.select_all = false
	
	local var_5_0 = arg_5_0:alreadyIn(arg_5_3, arg_5_4)
	local var_5_1 = arg_5_1.select_bg
	local var_5_2 = false
	
	if not var_5_0 then
		local var_5_3 = 0
		
		if arg_5_4 == "buff" then
			var_5_3 = table.count(arg_5_0.vars.select_buff_list)
			arg_5_0.vars.buff_dirty_check = true
		elseif arg_5_4 == "debuff" then
			var_5_3 = table.count(arg_5_0.vars.select_debuff_list)
			arg_5_0.vars.debuff_dirty_check = true
		end
		
		if var_5_3 >= var_0_0 then
			balloon_message_with_sound("ui_filter_buff_limit")
			
			if arg_5_1.setSelected then
				arg_5_1:setSelected(false)
			end
			
			return 
		end
	end
	
	local var_5_4 = false
	
	if var_5_0 then
		var_5_2 = arg_5_0:removeList({
			arg_5_2
		})
		
		arg_5_0:offAllBuffSelect(arg_5_4)
	else
		var_5_2 = arg_5_0:_addList({
			arg_5_2
		})
		
		local var_5_5 = true
		
		var_5_4 = true
	end
	
	if arg_5_1.check_box then
		arg_5_1.check_box:setSelected(not arg_5_1.check_box:isSelected())
	end
	
	if var_5_1 then
		var_5_1:setVisible(var_5_4)
	end
	
	arg_5_0:_checkAllLogic(arg_5_4)
	
	if var_5_2 then
		if arg_5_4 == "buff" then
			arg_5_0.vars.buff_dirty_check = true
		elseif arg_5_4 == "debuff" then
			arg_5_0.vars.debuff_dirty_check = true
		end
	end
end

function SkillEffectFilterUI._checkAllLogic(arg_6_0, arg_6_1)
	local var_6_0
	local var_6_1
	local var_6_2 = false
	local var_6_3
	
	if arg_6_1 == "buff" then
		local var_6_4 = arg_6_0.vars.buff_ui
		
		var_6_3 = arg_6_0.vars.select_buff_list
	elseif arg_6_1 == "debuff" then
		local var_6_5 = arg_6_0.vars.debuff_ui
		
		var_6_3 = arg_6_0.vars.select_debuff_list
	end
	
	local var_6_6 = table.empty(var_6_3)
	
	if var_6_6 then
		return 
	end
	
	if arg_6_1 == "buff" then
		arg_6_0.vars.select_all_buff = var_6_6
	elseif arg_6_1 == "debuff" then
		arg_6_0.vars.select_all_debuff = var_6_6
	end
end

function SkillEffectFilterUI._addList(arg_7_0, arg_7_1)
	if not arg_7_1 or table.empty(arg_7_1) then
		return 
	end
	
	local var_7_0 = false
	
	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		local var_7_1, var_7_2, var_7_3, var_7_4 = DB("skill_effectfilter", iter_7_1, {
			"id",
			"type",
			"sort",
			"effect_id"
		})
		
		if var_7_1 and not arg_7_0:alreadyIn(var_7_4, var_7_2) then
			if var_7_2 == "buff" then
				table.insert(arg_7_0.vars.select_buff_list, var_7_4)
				
				var_7_0 = true
			elseif var_7_2 == "debuff" then
				table.insert(arg_7_0.vars.select_debuff_list, var_7_4)
				
				var_7_0 = true
			end
		end
	end
	
	return var_7_0
end

function SkillEffectFilterUI.removeList(arg_8_0, arg_8_1)
	if not arg_8_1 or table.empty(arg_8_1) then
		return 
	end
	
	local var_8_0 = false
	local var_8_1
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		local var_8_2, var_8_3, var_8_4, var_8_5 = DB("skill_effectfilter", iter_8_1, {
			"id",
			"type",
			"sort",
			"effect_id"
		})
		local var_8_6 = arg_8_0:alreadyIn(var_8_5, var_8_3)
		
		if var_8_2 and var_8_6 then
			local var_8_7 = var_8_3
			
			if var_8_3 == "buff" then
				table.remove(arg_8_0.vars.select_buff_list, var_8_6)
				
				var_8_0 = true
			elseif var_8_3 == "debuff" then
				table.remove(arg_8_0.vars.select_debuff_list, var_8_6)
				
				var_8_0 = true
			end
		end
	end
	
	return var_8_0
end

function SkillEffectFilterUI.restList(arg_9_0)
	arg_9_0:resetFilter()
end

function SkillEffectFilterUI.checkUnit(arg_10_0, arg_10_1)
	if arg_10_0:isEmptyAll() or arg_10_0.vars.select_all then
		return true
	end
	
	if not SkillEffectFilterManager:checkUnit(arg_10_1, "buff", arg_10_0.vars.select_buff_list) then
		return 
	end
	
	if not SkillEffectFilterManager:checkUnit(arg_10_1, "debuff", arg_10_0.vars.select_debuff_list) then
		return 
	end
	
	return true
end

function SkillEffectFilterUI.isValid(arg_11_0)
	return arg_11_0.vars
end

function SkillEffectFilterUI.isEmptyAll(arg_12_0)
	return table.empty(arg_12_0.vars.select_buff_list) and table.empty(arg_12_0.vars.select_debuff_list)
end

function SkillEffectFilterUI.alreadyIn(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 then
		return 
	end
	
	if not arg_13_2 then
		return table.find(arg_13_0.vars.select_buff_list, arg_13_1) or table.find(arg_13_0.vars.select_debuff_list, arg_13_1)
	elseif arg_13_2 == "buff" then
		return table.find(arg_13_0.vars.select_buff_list, arg_13_1)
	elseif arg_13_2 == "debuff" then
		return table.find(arg_13_0.vars.select_debuff_list, arg_13_1)
	end
end

function SkillEffectFilterUI.create(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	local var_14_0 = {}
	
	copy_functions(SkillEffectFilterUI, var_14_0)
	
	var_14_0.vars = {}
	var_14_0.vars.select_buff_list = {}
	var_14_0.vars.select_debuff_list = {}
	var_14_0.vars.parent_class = arg_14_1
	var_14_0.vars.select_all = true
	var_14_0.vars.select_all_buff = false
	var_14_0.vars.select_all_debuff = false
	var_14_0.vars.buff_dirty_check = false
	var_14_0.vars.debuff_dirty_check = false
	
	var_14_0:initUI()
	
	var_14_0.vars.buff_ui.filter = var_14_0
	var_14_0.vars.debuff_ui.filter = var_14_0
	
	return var_14_0
end

function SkillEffectFilterUI.changeMode(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0:saveFilterSetting(arg_15_1)
	arg_15_0:loadFilterSetting(arg_15_2)
end

function SkillEffectFilterUI.saveFilterSetting(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	if not arg_16_0.vars.save_mode then
		arg_16_0.vars.save_mode = {}
	end
	
	arg_16_0.vars.save_mode[arg_16_1] = arg_16_0:getFilterSetting()
end

function SkillEffectFilterUI.loadFilterSetting(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	if not arg_17_0.vars.save_mode then
		arg_17_0.vars.save_mode = {}
	end
	
	arg_17_0:setFilterSetting(arg_17_0.vars.save_mode[arg_17_1])
end

function SkillEffectFilterUI.clearFilterSetting(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not arg_18_0.vars.save_mode then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.save_mode[arg_18_1]
	
	if var_18_0 and not var_18_0.select_all then
		arg_18_0.vars.save_mode[arg_18_1] = nil
	end
end

function SkillEffectFilterUI.getFilterSetting(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	return {
		select_buff_list = arg_19_0.vars.select_buff_list,
		select_debuff_list = arg_19_0.vars.select_debuff_list,
		select_all = arg_19_0.vars.select_all,
		select_all_buff = arg_19_0.vars.select_all_buff,
		select_all_debuff = arg_19_0.vars.select_all_debuff
	}
end

function SkillEffectFilterUI.setFilterSetting(arg_20_0, arg_20_1)
	if not arg_20_0.vars then
		return 
	end
	
	if arg_20_1 then
		arg_20_0.vars.select_buff_list = arg_20_1.select_buff_list
		arg_20_0.vars.select_debuff_list = arg_20_1.select_debuff_list
		arg_20_0.vars.select_all = arg_20_1.select_all
		arg_20_0.vars.select_all_buff = arg_20_1.select_all_buff
		arg_20_0.vars.select_all_debuff = arg_20_1.select_all_debuff
	else
		arg_20_0.vars.select_buff_list = {}
		arg_20_0.vars.select_debuff_list = {}
		arg_20_0.vars.select_all = true
		arg_20_0.vars.select_all_buff = false
		arg_20_0.vars.select_all_debuff = false
	end
	
	arg_20_0:refreshAllListView()
end

function SkillEffectFilterUI.initUI(arg_21_0)
	arg_21_0.vars.buff_ui = load_control("wnd/sorting_filter_unit_add.csb")
	
	arg_21_0.vars.buff_ui:setName("sort_buff_ui")
	
	arg_21_0.vars.debuff_ui = load_control("wnd/sorting_filter_unit_add.csb")
	
	arg_21_0.vars.debuff_ui:setName("sort_debuff_ui")
	
	local var_21_0 = arg_21_0.vars.buff_ui:getChildByName("ListView_1")
	local var_21_1 = arg_21_0.vars.debuff_ui:getChildByName("ListView_1")
	
	arg_21_0.vars.buff_listview = arg_21_0:_initListView(var_21_0)
	arg_21_0.vars.debuff_listview = arg_21_0:_initListView(var_21_1)
	
	local var_21_2 = SkillEffectFilterManager:getAllBuffList()
	local var_21_3 = SkillEffectFilterManager:getAllDebuffList()
	
	arg_21_0:_updateListView(arg_21_0.vars.buff_listview, var_21_2)
	arg_21_0:_updateListView(arg_21_0.vars.debuff_listview, var_21_3)
	if_set(arg_21_0.vars.buff_ui, "t_title", T("ui_unit_filter_buff"))
	if_set(arg_21_0.vars.debuff_ui, "t_title", T("ui_unit_filter_debuff"))
	
	local var_21_4 = arg_21_0.vars.parent_class.vars.wnd
	
	arg_21_0.vars.parent_layer = var_21_4
	arg_21_0.vars.eject_parent_layer = SceneManager:getRunningPopupScene()
	
	var_21_4:addChild(arg_21_0.vars.buff_ui)
	var_21_4:addChild(arg_21_0.vars.debuff_ui)
	arg_21_0.vars.buff_ui:bringToFront()
	arg_21_0.vars.debuff_ui:bringToFront()
	arg_21_0.vars.buff_ui:setVisible(false)
	arg_21_0.vars.debuff_ui:setVisible(false)
	arg_21_0.vars.buff_ui:setAnchorPoint(0.973, 0.869)
	arg_21_0.vars.debuff_ui:setAnchorPoint(0.973, 0.869)
end

function SkillEffectFilterUI._initListView(arg_22_0, arg_22_1)
	local var_22_0 = ItemListView:bindControl(arg_22_1)
	local var_22_1 = {
		onUpdate = function(arg_23_0, arg_23_1, arg_23_2)
			local var_23_0 = arg_23_2
			local var_23_1 = arg_23_1:getChildByName("n_check_box")
			local var_23_2 = var_23_1:getChildByName("n_icon")
			local var_23_3 = var_23_1:getChildByName("select_bg")
			local var_23_4 = var_23_1:getChildByName("checkbox")
			local var_23_5 = var_23_1:getChildByName("btn_checkbox")
			
			if not var_23_2.icon then
				var_23_2.icon = cc.Sprite:create("buff/" .. var_23_0.data.icon .. ".png")
				
				var_23_2:addChild(var_23_2.icon)
				
				local var_23_6 = DB("cs", tostring(var_23_0.effect_id), "cs_effectexplain")
				
				if var_23_6 then
					WidgetUtils:setupTooltip({
						delay = 100,
						control = var_23_2.icon,
						creator = function()
							return UIUtil:getSkillEffectTip(var_23_6)
						end
					})
				end
			end
			
			var_23_3:setVisible(var_23_0.is_selected)
			var_23_4:setSelected(var_23_0.is_selected)
			
			var_23_5.id = var_23_0.id
			var_23_5.effect_id = var_23_0.effect_id
			var_23_5.check_box = var_23_4
			var_23_5.select_bg = var_23_3
			var_23_4.select_bg = var_23_3
			
			var_23_4:addEventListener(function(arg_25_0, arg_25_1)
				getParentWindow(arg_25_0).filter:addOne(arg_25_0, var_23_0.id, var_23_0.effect_id, var_23_0.type)
			end)
		end
	}
	
	arg_22_1:setRenderer(load_control("wnd/sorting_filter_unit_add_item.csb"), var_22_1)
	
	return var_22_0
end

function SkillEffectFilterUI._updateListView(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {}
	
	for iter_26_0, iter_26_1 in pairs(arg_26_2) do
		local var_26_1 = SkillEffectFilterManager:getData(iter_26_1.effect_id)
		local var_26_2 = arg_26_0:alreadyIn(iter_26_1.effect_id) and true or false
		
		table.insert(var_26_0, {
			id = iter_26_1.id,
			type = iter_26_1.type,
			sort = iter_26_1.sort,
			effect_id = iter_26_1.effect_id,
			is_selected = var_26_2,
			data = var_26_1
		})
	end
	
	table.sort(var_26_0, function(arg_27_0, arg_27_1)
		return arg_27_0.sort < arg_27_1.sort
	end)
	arg_26_1:setItems(var_26_0)
end

function SkillEffectFilterUI.refreshAllListView(arg_28_0)
	local var_28_0 = SkillEffectFilterManager:getAllBuffList()
	local var_28_1 = SkillEffectFilterManager:getAllDebuffList()
	
	arg_28_0:_updateListView(arg_28_0.vars.buff_listview, var_28_0)
	arg_28_0:_updateListView(arg_28_0.vars.debuff_listview, var_28_1)
end

function SkillEffectFilterUI.updateParentUI(arg_29_0, arg_29_1)
	arg_29_0.vars.parent_class:updateBuffUI(arg_29_1)
end

function SkillEffectFilterUI.setSelectAllList(arg_30_0, arg_30_1)
	arg_30_0.vars.select_all = arg_30_1
end

function SkillEffectFilterUI.isSelectAllList(arg_31_0)
	return arg_31_0.vars.select_all
end

function SkillEffectFilterUI.isSelectAllBuffList(arg_32_0)
	return arg_32_0.vars.select_all_buff
end

function SkillEffectFilterUI.isSelectAllDebuffList(arg_33_0)
	return arg_33_0.vars.select_all_debuff
end

function SkillEffectFilterUI.getSelectedBuffList(arg_34_0)
	return arg_34_0.vars.select_buff_list
end

function SkillEffectFilterUI.getSelectedDebuffList(arg_35_0)
	return arg_35_0.vars.select_debuff_list
end

function SkillEffectFilterUI.openUI(arg_36_0, arg_36_1)
	if not arg_36_1 then
		return 
	end
	
	if string.starts(arg_36_1, "btn_buff") then
		arg_36_0:openBuffList()
	elseif string.starts(arg_36_1, "btn_debuff") then
		arg_36_0:openDeBuffList()
	end
end

function SkillEffectFilterUI.openBuffList(arg_37_0)
	if not get_cocos_refid(arg_37_0.vars.buff_ui) then
		return 
	end
	
	BackButtonManager:push({
		check_id = "buff_filter",
		back_func = function()
			arg_37_0:closeBuffList()
		end
	})
	arg_37_0.vars.buff_ui:ejectFromParent()
	arg_37_0.vars.eject_parent_layer:addChild(arg_37_0.vars.buff_ui)
	arg_37_0.vars.buff_ui:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	arg_37_0.vars.buff_ui:setAnchorPoint(0.5, 0.5)
	arg_37_0.vars.buff_ui:bringToFront()
	arg_37_0.vars.buff_ui:setVisible(true)
end

function SkillEffectFilterUI.closeBuffList(arg_39_0)
	if not get_cocos_refid(arg_39_0.vars.buff_ui) then
		return 
	end
	
	BackButtonManager:pop("buff_filter")
	arg_39_0.vars.buff_ui:ejectFromParent()
	arg_39_0.vars.parent_layer:addChild(arg_39_0.vars.buff_ui)
	arg_39_0.vars.buff_ui:setVisible(false)
	
	if arg_39_0.vars.buff_dirty_check then
		arg_39_0:operateFilter()
		arg_39_0:updateParentUI()
	end
	
	arg_39_0.vars.buff_dirty_check = false
end

function SkillEffectFilterUI.openDeBuffList(arg_40_0)
	if not get_cocos_refid(arg_40_0.vars.debuff_ui) then
		return 
	end
	
	BackButtonManager:push({
		check_id = "debuff_filter",
		back_func = function()
			arg_40_0:closeDeBuffList()
		end
	})
	arg_40_0.vars.debuff_ui:ejectFromParent()
	arg_40_0.vars.eject_parent_layer:addChild(arg_40_0.vars.debuff_ui)
	arg_40_0.vars.debuff_ui:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	arg_40_0.vars.debuff_ui:setAnchorPoint(0.5, 0.5)
	arg_40_0.vars.debuff_ui:bringToFront()
	arg_40_0.vars.debuff_ui:setVisible(true)
end

function SkillEffectFilterUI.closeDeBuffList(arg_42_0)
	if not get_cocos_refid(arg_42_0.vars.debuff_ui) then
		return 
	end
	
	BackButtonManager:pop("debuff_filter")
	arg_42_0.vars.debuff_ui:ejectFromParent()
	arg_42_0.vars.parent_layer:addChild(arg_42_0.vars.debuff_ui)
	arg_42_0.vars.debuff_ui:setVisible(false)
	
	if arg_42_0.vars.debuff_dirty_check then
		arg_42_0:operateFilter()
		arg_42_0:updateParentUI()
	end
	
	arg_42_0.vars.debuff_dirty_check = false
end

function SkillEffectFilterUI.operateFilter(arg_43_0)
	if not arg_43_0.vars.parent_class then
		return 
	end
	
	arg_43_0.vars.parent_class:resetDataByCall()
end

function SkillEffectFilterUI.offAllBuffSelect(arg_44_0, arg_44_1)
	local var_44_0
	
	if arg_44_1 == "buff" then
		local var_44_1 = arg_44_0.vars.buff_ui
		
		arg_44_0.vars.select_all_buff = false
	else
		local var_44_2 = arg_44_0.vars.debuff_ui
		
		arg_44_0.vars.select_all_debuff = false
	end
end

function SkillEffectFilterUI.resetFilter(arg_45_0)
	arg_45_0.vars.select_buff_list = {}
	arg_45_0.vars.select_debuff_list = {}
end

function SkillEffectFilterUI.pressAllBtn(arg_46_0)
	arg_46_0.vars.select_all = not arg_46_0.vars.select_all
	arg_46_0.vars.select_all_buff = not arg_46_0.vars.select_all
	arg_46_0.vars.select_all_debuff = not arg_46_0.vars.select_all
	
	local var_46_0 = SkillEffectFilterManager:getAllBuffList()
	local var_46_1 = {}
	
	for iter_46_0, iter_46_1 in pairs(var_46_0) do
		table.insert(var_46_1, iter_46_1.id)
	end
	
	arg_46_0:removeList(var_46_1)
	
	local var_46_2 = SkillEffectFilterManager:getAllDebuffList()
	local var_46_3 = {}
	
	for iter_46_2, iter_46_3 in pairs(var_46_2) do
		table.insert(var_46_3, iter_46_3.id)
	end
	
	arg_46_0:removeList(var_46_3)
	arg_46_0:refreshAllListView()
	arg_46_0:updateParentUI(true)
end

function SkillEffectFilterUI.checkAllLogic(arg_47_0)
	if arg_47_0.vars.select_all then
		arg_47_0.vars.select_all_buff = false
		arg_47_0.vars.select_all_debuff = false
	else
		arg_47_0.vars.select_all_buff = table.empty(arg_47_0.vars.select_buff_list)
		arg_47_0.vars.select_all_debuff = table.empty(arg_47_0.vars.select_debuff_list)
	end
end

SkillEffectFilterManager = {}

function SkillEffectFilterManager.addUnit(arg_48_0, arg_48_1)
	if not arg_48_0.vars then
		arg_48_0:init()
	end
	
	if arg_48_0:exceptUnit(arg_48_1) then
		return 
	end
	
	for iter_48_0 = 1, 99999 do
		local var_48_0 = arg_48_1:getSkillByIndex(iter_48_0)
		
		if not arg_48_1:getSkillLevelByIndex(iter_48_0) then
			local var_48_1 = 0
		end
		
		if not var_48_0 then
			break
		end
		
		arg_48_0:setData(arg_48_1, var_48_0)
	end
end

function SkillEffectFilterManager.setData(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_1:getUID()
	local var_49_1 = arg_49_1:getExclusiveEffect(arg_49_1:getReferSkillIndex(arg_49_2)) or {}
	local var_49_2 = {}
	
	if not table.empty(var_49_1.explain) then
		var_49_2 = var_49_1.explain
	else
		var_49_2[1], var_49_2[2], var_49_2[3], var_49_2[4] = DB("skill", arg_49_2, {
			"sk_eff_explain1",
			"sk_eff_explain2",
			"sk_eff_explain3",
			"sk_eff_explain4"
		})
	end
	
	for iter_49_0, iter_49_1 in pairs(var_49_2) do
		if iter_49_1 then
			local var_49_3 = DB("skill_effectexplain", tostring(iter_49_1), {
				"type"
			})
			
			if not var_49_3 then
				break
			end
			
			local var_49_4
			local var_49_5
			
			if var_49_3 == "buff" and arg_49_0.vars.buff_eff[iter_49_1] then
				var_49_4 = arg_49_0.vars.buff_eff[iter_49_1]
			elseif var_49_3 == "debuff" and arg_49_0.vars.debuff_eff[iter_49_1] then
				var_49_4 = arg_49_0.vars.debuff_eff[iter_49_1]
			elseif var_49_3 == "common" then
			end
			
			if var_49_4 then
				local var_49_6 = var_49_4.unit_list
				
				if not var_49_6[var_49_0] then
					var_49_6[var_49_0] = {}
				end
			end
		end
	end
end

function SkillEffectFilterManager.refreshUnit(arg_50_0, arg_50_1)
	if not arg_50_1 then
		return 
	end
	
	if arg_50_0:exceptUnit(arg_50_1) then
		return 
	end
	
	arg_50_0:removeUnit(arg_50_1)
	arg_50_0:addUnit(arg_50_1)
end

function SkillEffectFilterManager.removeUnit(arg_51_0, arg_51_1)
	if arg_51_0:exceptUnit(arg_51_1) then
		return 
	end
	
	local var_51_0 = arg_51_1:getUID()
	
	for iter_51_0, iter_51_1 in pairs(arg_51_0.vars.buff_eff) do
		if iter_51_1.unit_list and not table.empty(iter_51_1.unit_list) then
			iter_51_1.unit_list[var_51_0] = nil
		end
	end
	
	for iter_51_2, iter_51_3 in pairs(arg_51_0.vars.debuff_eff) do
		if iter_51_3.unit_list and not table.empty(iter_51_3.unit_list) then
			iter_51_3.unit_list[var_51_0] = nil
		end
	end
end

function SkillEffectFilterManager.exceptUnit(arg_52_0, arg_52_1)
	if not arg_52_1 or arg_52_1.isSummon and arg_52_1:isSummon() or arg_52_1.isSpecialUnit and arg_52_1:isSpecialUnit() then
		return 
	end
end

function SkillEffectFilterManager.checkUnit(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	if not arg_53_1 or not arg_53_2 or not arg_53_3 then
		return 
	end
	
	local var_53_0 = true
	local var_53_1
	
	if arg_53_2 == "buff" then
		var_53_1 = arg_53_0.vars.buff_eff
	elseif arg_53_2 == "debuff" then
		var_53_1 = arg_53_0.vars.debuff_eff
	end
	
	if not var_53_1 then
		return true
	end
	
	for iter_53_0, iter_53_1 in pairs(arg_53_3) do
		local var_53_2 = iter_53_1
		
		if var_53_1[iter_53_1] and var_53_1[iter_53_1].unit_list and not var_53_1[iter_53_1].unit_list[arg_53_1] then
			return false
		end
	end
	
	return var_53_0
end

function SkillEffectFilterManager.getUnitListByBuffId(arg_54_0, arg_54_1, arg_54_2)
	if not arg_54_2 then
		return 
	end
	
	local var_54_0 = arg_54_1 or Account:getUnits() or {}
	local var_54_1 = {}
	
	if table.empty(arg_54_2) then
		return var_54_0
	end
	
	for iter_54_0, iter_54_1 in pairs(arg_54_2) do
		local var_54_2
		
		if arg_54_0.vars.buff_eff[iter_54_1] then
			var_54_2 = arg_54_0.vars.buff_eff[iter_54_1].unit_list
		elseif arg_54_0.vars.debuff_eff[iter_54_1] then
			var_54_2 = arg_54_0.vars.debuff_eff[iter_54_1].unit_list
		end
		
		if var_54_2 then
			for iter_54_2, iter_54_3 in pairs(var_54_2) do
				if not table.find(var_54_1, iter_54_3) then
					table.insert(var_54_1, iter_54_3)
				end
			end
		end
	end
	
	local var_54_3 = {}
	
	for iter_54_4, iter_54_5 in pairs(var_54_1) do
		table.insert(var_54_3, Account:getUnit(iter_54_5))
	end
	
	return var_54_3
end

function SkillEffectFilterManager.init(arg_55_0)
	arg_55_0.vars = {}
	arg_55_0.vars.units = {}
	arg_55_0.vars.buff_eff = {}
	arg_55_0.vars.debuff_eff = {}
	arg_55_0.vars.datas = {}
	
	for iter_55_0 = 1, 9999999 do
		local var_55_0, var_55_1, var_55_2, var_55_3 = DBN("skill_effectfilter", iter_55_0, {
			"id",
			"type",
			"sort",
			"effect_id"
		})
		local var_55_4 = {}
		
		if not var_55_0 then
			break
		end
		
		if var_55_1 == "buff" then
			arg_55_0.vars.buff_eff[var_55_3] = {
				id = var_55_0,
				type = var_55_1,
				sort = var_55_2,
				effect_id = var_55_3,
				unit_list = var_55_4
			}
		else
			arg_55_0.vars.debuff_eff[var_55_3] = {
				id = var_55_0,
				type = var_55_1,
				sort = var_55_2,
				effect_id = var_55_3,
				unit_list = var_55_4
			}
		end
		
		local var_55_5, var_55_6, var_55_7, var_55_8, var_55_9 = DB("skill_effectexplain", tostring(var_55_3), {
			"id",
			"type",
			"icon",
			"name",
			"effect"
		})
		
		if var_55_5 then
			arg_55_0.vars.datas[var_55_5] = {
				id = var_55_5,
				type = var_55_6,
				icon = var_55_7,
				name = var_55_8,
				effect = var_55_9
			}
		end
	end
end

function SkillEffectFilterManager.getAllDebuffListCount(arg_56_0)
	return table.count(arg_56_0.vars.debuff_eff)
end

function SkillEffectFilterManager.getAllBuffListCount(arg_57_0)
	return table.count(arg_57_0.vars.buff_eff)
end

function SkillEffectFilterManager.getAllBuffList(arg_58_0)
	return arg_58_0.vars.buff_eff
end

function SkillEffectFilterManager.getAllDebuffList(arg_59_0)
	return arg_59_0.vars.debuff_eff
end

function SkillEffectFilterManager.getData(arg_60_0, arg_60_1)
	return arg_60_0.vars.datas[arg_60_1]
end

SkillEffectFilterManagerPVP = {}

function SkillEffectFilterManagerPVP.init(arg_61_0)
	arg_61_0.vars = {}
	arg_61_0.vars.buff_eff = table.shallow_clone(SkillEffectFilterManager:getAllBuffList())
	arg_61_0.vars.debuff_eff = table.shallow_clone(SkillEffectFilterManager:getAllDebuffList())
	
	local var_61_0 = CollectionDB:getModeDB("hero")
	
	if not var_61_0 or table.empty(var_61_0) then
		return 
	end
	
	for iter_61_0, iter_61_1 in pairs(var_61_0) do
		for iter_61_2, iter_61_3 in pairs(iter_61_1) do
			local var_61_1 = iter_61_3.id
			
			if iter_61_3.show then
				local var_61_2 = UNIT:create({
					z = 6,
					code = var_61_1
				}, nil, true)
				
				arg_61_0:addUnit(var_61_2)
			end
		end
	end
end

function SkillEffectFilterManagerPVP.addUnit(arg_62_0, arg_62_1)
	if not arg_62_1 then
		return 
	end
	
	for iter_62_0 = 1, 99999 do
		local var_62_0 = arg_62_1:getSkillByIndex(iter_62_0)
		
		if not arg_62_1:getSkillLevelByIndex(iter_62_0) then
			local var_62_1 = 0
		end
		
		if not var_62_0 then
			break
		end
		
		arg_62_0:setData(arg_62_1, var_62_0)
	end
end

function SkillEffectFilterManagerPVP.setData(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = arg_63_1.db.code
	local var_63_1 = arg_63_1:getExclusiveEffect(arg_63_1:getReferSkillIndex(arg_63_2)) or {}
	local var_63_2 = {}
	
	if not table.empty(var_63_1.explain) then
		var_63_2 = var_63_1.explain
	else
		var_63_2[1], var_63_2[2], var_63_2[3], var_63_2[4] = DB("skill", arg_63_2, {
			"sk_eff_explain1",
			"sk_eff_explain2",
			"sk_eff_explain3",
			"sk_eff_explain4"
		})
	end
	
	for iter_63_0, iter_63_1 in pairs(var_63_2) do
		if iter_63_1 then
			local var_63_3 = DB("skill_effectexplain", tostring(iter_63_1), {
				"type"
			})
			
			if not var_63_3 then
				break
			end
			
			local var_63_4
			local var_63_5
			
			if var_63_3 == "buff" and arg_63_0.vars.buff_eff[iter_63_1] then
				var_63_4 = arg_63_0.vars.buff_eff[iter_63_1]
			elseif var_63_3 == "debuff" and arg_63_0.vars.debuff_eff[iter_63_1] then
				var_63_4 = arg_63_0.vars.debuff_eff[iter_63_1]
			elseif var_63_3 == "common" then
			end
			
			if var_63_4 then
				if not var_63_4.unit_code_list then
					var_63_4.unit_code_list = {}
				end
				
				local var_63_6 = var_63_4.unit_code_list
				
				if not var_63_6[var_63_0] then
					var_63_6[var_63_0] = {}
				end
			end
		end
	end
end

function SkillEffectFilterManagerPVP.checkUnit(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	if not arg_64_1 or not arg_64_2 or not arg_64_3 then
		return 
	end
	
	if table.empty(arg_64_3) then
		return true
	end
	
	local var_64_0
	
	if arg_64_2 == "buff" then
		var_64_0 = arg_64_0.vars.buff_eff
	else
		var_64_0 = arg_64_0.vars.debuff_eff
	end
	
	for iter_64_0, iter_64_1 in pairs(arg_64_3) do
		if var_64_0[iter_64_1] and not (var_64_0[iter_64_1].unit_code_list or {})[arg_64_1] then
			return false
		end
	end
	
	return true
end

function SkillEffectFilterManagerPVP.isValid(arg_65_0)
	return arg_65_0.vars ~= nil
end

function SkillEffectFilterManagerPVP.close(arg_66_0)
	arg_66_0.vars = nil
end
