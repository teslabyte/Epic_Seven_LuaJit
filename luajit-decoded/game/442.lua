PetBelt = {}

function HANDLER.unit_pet_bar(arg_1_0, arg_1_1)
	if arg_1_1 == "add" then
		PetBelt:onPushAddButton()
	end
end

function HANDLER.unit_pet_list(arg_2_0, arg_2_1)
	if arg_2_1 == "add_inven" then
		UIUtil:showIncPetInvenDialog()
	end
end

function PetBelt.createControl(arg_3_0, arg_3_1, arg_3_2)
	return (arg_3_0:updateControl(nil, nil, arg_3_2))
end

function PetBelt.updateControl(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_2 = UIUtil:updatePetBar(arg_4_2, arg_4_0.vars.sort_mode, arg_4_3)
	
	UIUtil:updatePetBarInfo(arg_4_2, arg_4_0.vars.sort_mode, arg_4_3, arg_4_0.vars.diff_unit, nil, arg_4_0.vars.sort_opts)
	
	return arg_4_2
end

function PetBelt.clearGarbageItems(arg_5_0)
	arg_5_0.dock:clearGarbageItems()
end

function PetBelt.popItem(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or arg_6_0.dock:getCurrentItem()
	
	arg_6_0.dock:removeItem(arg_6_1, true)
	arg_6_0:updatePetCount()
end

function PetBelt.popItems(arg_7_0, arg_7_1)
	if table.empty(arg_7_1) then
		return 
	end
	
	arg_7_0.dock:removeItems(arg_7_1, true)
	arg_7_0:updatePetCount()
end

function PetBelt.revertPoppedItem(arg_8_0, arg_8_1)
	arg_8_0.dock:revertGarbageItem(arg_8_1)
	arg_8_0.vars.sorter:setItems(arg_8_0.dock.items)
	arg_8_0:sort()
	arg_8_0.dock:arrangeItems()
	arg_8_0:updatePetCount()
end

function PetBelt.onChangeCurrentItem(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_3 then
		local var_9_0 = arg_9_1:getRenderer(arg_9_3)
		
		if var_9_0 then
			arg_9_0:updateControlColor(arg_9_1, arg_9_3, var_9_0)
		end
	end
	
	if arg_9_2 then
		local var_9_1 = arg_9_1:getRenderer(arg_9_2)
		
		if var_9_1 then
			arg_9_0:updateControlColor(arg_9_1, arg_9_2, var_9_1, true)
		end
	end
	
	arg_9_0:callEventHandler("change", arg_9_3, arg_9_2)
end

function PetBelt.onSelectItem(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0:updateControlColor(arg_10_1, arg_10_2, nil, true)
	arg_10_0:callEventHandler("select", arg_10_2, arg_10_3)
end

function PetBelt.onPushAddButton(arg_11_0)
	arg_11_0:callEventHandler("add", arg_11_0:getCurrentItem())
end

function PetBelt.stopAutoScroll(arg_12_0)
	arg_12_0.dock:stopAutoScroll()
end

function PetBelt.onScroll(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0:callEventHandler("scroll", arg_13_2)
end

function PetBelt.callEventHandler(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_0.vars.event_handler then
		arg_14_0.vars.event_handler(arg_14_0.vars.event_handler_arg, arg_14_1, arg_14_2, arg_14_3)
	elseif not arg_14_0.vars.opts or not arg_14_0.vars.opts.no_event then
		Log.e("Not Have Event Handler, But Call Event Handler")
	end
end

function PetBelt.setEventHandler(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.vars.event_handler = arg_15_1
	arg_15_0.vars.event_handler_arg = arg_15_2
end

function PetBelt.removeEventHandler(arg_16_0)
	arg_16_0.vars.event_handler = nil
	arg_16_0.vars.event_handler_arg = nil
end

function PetBelt.updateControlColor(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_1 = arg_17_1 or arg_17_0.dock
	arg_17_3 = arg_17_3 or arg_17_1:getRenderer(arg_17_2)
	
	if not arg_17_3 then
		return 
	end
	
	UIUtil:updatePetBarInfo(arg_17_3, arg_17_0.vars.sort_mode, arg_17_2, arg_17_0.vars.diff_unit, arg_17_4, arg_17_0.vars.sort_opts)
end

function PetBelt.updatePet(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_1 = arg_18_1 or arg_18_0.dock:getRenderer(arg_18_2)
	
	if not arg_18_1 then
		return 
	end
	
	UIUtil:updatePetBar(arg_18_1, arg_18_0.vars.sort_mode, arg_18_2)
	UIUtil:updatePetBarInfo(arg_18_1, arg_18_0.vars.sort_mode, arg_18_2, arg_18_0.vars.diff_unit, arg_18_3, arg_18_0.vars.sort_opts)
end

function PetBelt.onShowItem(arg_19_0, arg_19_1, arg_19_2)
	UIUtil:updatePetBar(arg_19_1, arg_19_0.vars.sort_mode, arg_19_2)
end

function PetBelt.synthesisSortFunc(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1:isCanSynthesis()
	local var_20_1 = arg_20_2:isCanSynthesis()
	
	if var_20_0 == true and var_20_1 == false then
		return true
	end
	
	if var_20_0 == false and var_20_1 == true then
		return false
	end
	
	if arg_20_0.vars.sort_opts.only_max_lv then
		local var_20_2 = arg_20_1:isMaxLevel()
		local var_20_3 = arg_20_2:isMaxLevel()
		
		if var_20_2 == true and var_20_3 == false then
			return true
		end
		
		if var_20_2 == false and var_20_3 == true then
			return false
		end
	end
	
	if not arg_20_0.vars.diff_unit then
		return 
	end
	
	local var_20_4 = arg_20_1:getGrade() == arg_20_0.vars.diff_unit:getGrade() and arg_20_1:getType() == arg_20_0.vars.diff_unit:getType()
	local var_20_5 = arg_20_2:getGrade() == arg_20_0.vars.diff_unit:getGrade() and arg_20_2:getType() == arg_20_0.vars.diff_unit:getType()
	
	if var_20_4 == true and var_20_5 == false then
		return true
	end
	
	if var_20_4 == false and var_20_5 == true then
		return false
	end
	
	return nil
end

function PetBelt.transformSortFunc(arg_21_0, arg_21_1, arg_21_2)
	if arg_21_0.vars.sort_opts.only_can_remove then
		local var_21_0 = arg_21_1:isCanRemove()
		local var_21_1 = arg_21_2:isCanRemove()
		
		if var_21_0 == true and var_21_1 == false then
			return true
		end
		
		if var_21_0 == false and var_21_1 == true then
			return false
		end
	end
	
	if not arg_21_0.vars.diff_unit then
		return 
	end
	
	local var_21_2 = arg_21_1:getType() == arg_21_0.vars.diff_unit:getType() and arg_21_1:getCode() ~= arg_21_0.vars.diff_unit:getCode()
	local var_21_3 = arg_21_2:getType() == arg_21_0.vars.diff_unit:getType() and arg_21_2:getCode() ~= arg_21_0.vars.diff_unit:getCode()
	
	if var_21_2 == true and var_21_3 == false then
		return true
	end
	
	if var_21_2 == false and var_21_3 == true then
		return false
	end
	
	return nil
end

function PetBelt.transferSortFunc(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1:isCanRemove()
	local var_22_1 = arg_22_2:isCanRemove()
	
	if var_22_0 == true and var_22_1 == false then
		return true
	end
	
	if var_22_0 == false and var_22_1 == true then
		return false
	end
	
	return nil
end

function PetBelt.upgradeSortFunc(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_1:isCanRemove()
	local var_23_1 = arg_23_2:isCanRemove()
	
	if var_23_0 == false and var_23_1 ~= false then
		return false
	end
	
	if var_23_0 ~= false and var_23_1 == false then
		return true
	end
	
	local var_23_2 = arg_23_1:isPetFood()
	local var_23_3 = arg_23_2:isPetFood()
	
	if var_23_2 == false and var_23_3 ~= false then
		return false
	end
	
	if var_23_2 ~= false and var_23_3 == false then
		return true
	end
	
	return nil
end

function PetBelt.createContainer()
	local var_24_0 = {}
	
	copy_functions(PetBelt, var_24_0)
	
	return var_24_0
end

function PetBelt.create(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_0.vars and get_cocos_refid(arg_25_0.vars.wnd) then
		Log.e("DO NOT CREATE PET BELT DOUBLE!!! CHECK RELEASE.")
		
		return 
	end
	
	arg_25_0.vars = {}
	arg_25_0.vars.wnd = load_dlg("unit_pet_list", true, "wnd")
	
	local var_25_0 = DockPet:create({
		item_size = 90,
		height = 550,
		item_gap = 60,
		dir = "right",
		selected_item_pos = 0.11,
		width = 250,
		scroll_ratio = 2,
		handler = arg_25_0
	}, arg_25_0.vars.wnd:getChildByName("scrollview"))
	
	arg_25_0.vars.opts = arg_25_3 or {}
	arg_25_0.dock = var_25_0
	arg_25_0.vars.open_mode = arg_25_2
	arg_25_0.vars.sort_mode = arg_25_1
	arg_25_0.vars.sort_opts = {}
	arg_25_0.vars.sorter = Sorter:create(arg_25_0.vars.wnd:getChildByName("n_sorting"), {
		sorting_pet = true
	})
	
	local var_25_1 = {
		{
			name = T("pet_sort_gene"),
			func = PetSortFunc.greaterThanGrade
		},
		{
			name = T("pet_sort_level"),
			func = PetSortFunc.greaterThanLevel
		},
		{
			name = T("pet_sort_get"),
			func = PetSortFunc.greaterThanUID
		},
		{
			name = T("help_infopet_5_name"),
			func = PetSortFunc.greaterThanRank
		}
	}
	
	if arg_25_2 ~= "popup" then
		table.insert(var_25_1, {
			name = T("pet_sort_type"),
			func = PetSortFunc.greaterThanType
		})
	end
	
	local var_25_2 = SAVE:get("app.pet_list_sort_index", 1)
	
	arg_25_0.vars.sorter:setSorter({
		default_sort_index = var_25_2,
		priority_sort_func = function(arg_26_0, arg_26_1, arg_26_2)
			if arg_25_0.vars.sort_mode == "Synthesis" then
				return (arg_25_0:synthesisSortFunc(arg_26_0, arg_26_1))
			end
			
			if arg_25_0.vars.sort_mode == "Transform" then
				return (arg_25_0:transformSortFunc(arg_26_0, arg_26_1))
			end
			
			if arg_25_0.vars.sort_mode == "Transfer" then
				return (arg_25_0:transferSortFunc(arg_26_0, arg_26_1))
			end
		end,
		menus = var_25_1,
		callback_sort = function(arg_27_0, arg_27_1, arg_27_2)
			arg_25_0.dock:onAfterSort(true)
			
			arg_25_0.vars.sort_index = arg_27_1
			
			if arg_25_0.vars.saved_sort_index ~= arg_27_1 and arg_27_2.name then
				SAVE:set("app.pet_list_sort_index", arg_27_1)
			end
		end
	})
	arg_25_0.vars.wnd:getChildByName("layer_unit_pet_bar"):addChild(var_25_0.wnd)
	NotchManager:addListener(arg_25_0.vars.wnd:getChildByName("RIGHT"), false, function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
		if arg_25_0.vars.open_mode == "popup" then
			resetPosForNotch(arg_28_0, arg_28_1, {
				isLeft = false,
				origin_x = arg_28_3
			})
		else
			resetPosForNotch(arg_28_0, arg_28_1, {
				isLeft = arg_28_2,
				origin_x = arg_28_3
			})
		end
	end)
	
	return arg_25_0
end

function PetBelt.scrollToItem(arg_29_0, arg_29_1, arg_29_2)
	if #arg_29_0:getItems() < 1 then
		return 
	end
	
	arg_29_1 = arg_29_1 or arg_29_0:getItems()[1]
	
	arg_29_0.dock:scrollToItem(arg_29_1, arg_29_2)
end

function PetBelt.scrollToFirstItem(arg_30_0, arg_30_1)
	if #arg_30_0:getItems() < 1 then
		return 
	end
	
	arg_30_0.dock:scrollToItem(arg_30_0:getItems()[1], arg_30_1)
end

function PetBelt.getWnd(arg_31_0)
	return arg_31_0.vars.wnd
end

function PetBelt.getItems(arg_32_0)
	if not arg_32_0.dock then
		return {}
	end
	
	return arg_32_0.dock:getItems()
end

function PetBelt.isItemExist(arg_33_0, arg_33_1)
	if not arg_33_1 then
		return 
	end
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.dock:getItems() or {}) do
		if iter_33_1 == arg_33_1 then
			return true
		end
	end
	
	return false
end

function PetBelt.getCurrentItem(arg_34_0)
	return arg_34_0.dock:getCurrentItem()
end

function PetBelt.getControl(arg_35_0, arg_35_1)
	return arg_35_0.dock:getRenderer(arg_35_1)
end

function PetBelt.changeCountParent(arg_36_0, arg_36_1)
	if arg_36_0.vars then
		arg_36_0.vars.count_parent = arg_36_1
	end
end

function PetBelt.updatePetCount(arg_37_0)
	if get_cocos_refid(arg_37_0.vars.wnd) then
		local var_37_0 = arg_37_0.vars.count_parent or arg_37_0.vars.wnd
		
		if_set(var_37_0, "status", arg_37_0.dock.item_count .. "/" .. Account:getCurrentPetCount())
	end
end

function PetBelt.changeSorterParent(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_0.vars.sorter then
		arg_38_0.vars.sorter:changeParent(arg_38_1, arg_38_2)
	end
end

function PetBelt.isValid(arg_39_0)
	return arg_39_0.vars and get_cocos_refid(arg_39_0.vars.wnd)
end

function PetBelt.isAdditionalUnit(arg_40_0, arg_40_1, arg_40_2)
	if arg_40_1 ~= "Addition" then
		return false
	end
	
	if not arg_40_0.vars.addition_target_units or table.count(arg_40_0.vars.addition_target_units) ~= 2 then
		return false
	end
	
	if not arg_40_2:isCanRemove() then
		return false
	end
	
	for iter_40_0, iter_40_1 in pairs(arg_40_0.vars.addition_target_units or {}) do
		if iter_40_1:getUID() == arg_40_2:getUID() then
			return false
		end
	end
	
	if arg_40_0.vars.addition_target_units[1]:getGrade() < arg_40_2:getGrade() then
		return false
	end
	
	return true
end

function PetBelt.isAddToList(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_1 == "Upgrade" and arg_41_2:getUID() == arg_41_3:getUID() then
		return false
	end
	
	if (arg_41_1 == "Battle" or arg_41_1 == "Descent" or arg_41_1 == "Burning") and arg_41_2:getType() ~= "battle" then
		return false
	end
	
	if arg_41_1 == "Lobby" and arg_41_2:getType() ~= "lobby" then
		return false
	end
	
	if arg_41_1 == "Addition" and not arg_41_0:isAdditionalUnit(arg_41_1, arg_41_2) then
		return false
	end
	
	return true
end

function PetBelt.sort(arg_42_0)
	arg_42_0.vars.sorter:sort(nil, true)
end

function PetBelt.updateSort(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0.vars.diff_unit = arg_43_2
	arg_43_0.vars.sort_mode = arg_43_1
	arg_43_0.vars.sort_opts = arg_43_3 or {}
	
	arg_43_0:sort()
	arg_43_0:update()
	arg_43_0.dock:arrangeItems()
	
	if arg_43_1 == "Transfer" and table.empty(arg_43_0.vars.units) then
		if_set_visible(arg_43_0.vars.wnd, "n_none", true)
	else
		if_set_visible(arg_43_0.vars.wnd, "n_none", false)
	end
end

function PetBelt.setData(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	arg_44_4 = arg_44_4 or {}
	arg_44_0.vars.o_units = arg_44_1
	arg_44_0.vars.addition_target_units = nil
	
	local var_44_0 = arg_44_1
	local var_44_1 = {
		Addition = true,
		Descent = true,
		Burning = true,
		Battle = true,
		Upgrade = true,
		Lobby = true
	}
	
	if arg_44_4.addition_data then
		arg_44_0.vars.addition_target_units = table.shallow_clone(arg_44_4.addition_data)
		arg_44_4.addition_data = nil
	end
	
	if var_44_1[arg_44_2] then
		var_44_0 = {}
		
		for iter_44_0, iter_44_1 in pairs(arg_44_1) do
			if arg_44_0:isAddToList(arg_44_2, iter_44_1, arg_44_3) then
				var_44_0[#var_44_0 + 1] = iter_44_1
			end
		end
	end
	
	if arg_44_2 == "House" and #arg_44_1 == 0 then
		if_set_visible(arg_44_0.vars.wnd, "n_none", true)
	else
		if_set_visible(arg_44_0.vars.wnd, "n_none", false)
	end
	
	arg_44_0.vars.units = var_44_0
	arg_44_0.vars.diff_unit = arg_44_3
	arg_44_0.vars.sort_mode = arg_44_2
	arg_44_0.vars.sort_opts = arg_44_4 or {}
	
	arg_44_0.dock:setPetData(var_44_0, arg_44_0.dock:getGarbages())
	arg_44_0.vars.sorter:setItems(arg_44_0.dock.items)
	arg_44_0:sort()
	arg_44_0:update()
	arg_44_0.dock:arrangeItems()
	arg_44_0:updatePetCount()
end

function PetBelt.update(arg_45_0)
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.units or {}) do
		arg_45_0:updatePet(nil, iter_45_1)
	end
end

function PetBelt.destroy(arg_46_0)
	if arg_46_0.dock then
		arg_46_0.dock:destroy()
	end
	
	if get_cocos_refid(arg_46_0.vars.wnd) then
		arg_46_0.vars.wnd:removeFromParent()
	end
	
	arg_46_0.vars = nil
end

function PetBelt.ejectFromParent(arg_47_0)
	if get_cocos_refid(arg_47_0.vars.wnd) then
		arg_47_0.vars.wnd:ejectFromParent()
	end
end

function PetBelt.setTouchEnabled(arg_48_0, arg_48_1)
	if arg_48_0.dock then
		arg_48_0.dock:setTouchEnabled(arg_48_1)
	end
end

function PetBelt.setScrollEnabled(arg_49_0, arg_49_1)
	if arg_49_0.dock then
		arg_49_0.dock:setScrollEnabled(arg_49_1)
	end
end
