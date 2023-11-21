UnitEquipGradeFilter = {}

function UnitEquipGradeFilter.onHandler(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2 == "btn_cancel" then
		arg_1_0:close()
	end
	
	if string.starts(arg_1_2, "btn_sort") then
		arg_1_0.Data:onHandler(arg_1_2)
		arg_1_0.UI:updateList(arg_1_0.Data:getSelectedList())
		
		local var_1_0, var_1_1 = arg_1_0.Data:getFilterList()
		
		Inventory:updateButtonGradeList(var_1_0, var_1_1)
		arg_1_0:close()
	end
end

function UnitEquipGradeFilter.open(arg_2_0)
	arg_2_0.UI:setVisible(true)
	
	arg_2_0.vars.open = true
	
	local var_2_0, var_2_1 = arg_2_0.Data:getFilterList()
	
	Inventory:updateButtonGradeList(var_2_0, var_2_1)
end

function UnitEquipGradeFilter.close(arg_3_0)
	arg_3_0.UI:setVisible(false)
	Inventory:ResetItems()
	
	local var_3_0, var_3_1 = arg_3_0.Data:getFilterList()
	
	Inventory:setButtonGradeList(var_3_0, var_3_1)
	
	arg_3_0.vars.open = false
end

function UnitEquipGradeFilter.isOpen(arg_4_0)
	return arg_4_0.vars.open
end

function UnitEquipGradeFilter.addSetFxCount(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.Data:addSetFxCount(arg_5_1, arg_5_2)
end

function UnitEquipGradeFilter.clear(arg_6_0, arg_6_1)
	arg_6_0.Data:clear()
	arg_6_0.UI:updateList(arg_6_0.Data:getSelectedList())
end

function UnitEquipGradeFilter.create(arg_7_0, arg_7_1)
	local var_7_0 = {}
	local var_7_1 = table.clone(UnitEquipGradeFilter)
	
	var_7_1.Data:init()
	var_7_1.UI:init(arg_7_1)
	var_7_1.Data:clear()
	var_7_1.UI:updateList(var_7_1.Data:getSelectedList())
	
	var_7_1.vars = {}
	
	return var_7_1
end

UnitEquipGradeFilter.UI = {}

function UnitEquipGradeFilter.UI.onHandler(arg_8_0, arg_8_1, arg_8_2)
end

function UnitEquipGradeFilter.UI.setVisible(arg_9_0, arg_9_1)
	if_set_visible(arg_9_0.vars.node_set_box, nil, arg_9_1)
end

function UnitEquipGradeFilter.UI.setCursor(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	UnitEquipFilterUtil:setCursor(arg_10_1, arg_10_2, arg_10_3)
end

function UnitEquipGradeFilter.UI.updateList(arg_11_0, arg_11_1, arg_11_2)
	arg_11_2 = arg_11_2 or arg_11_0.vars.node_set_box
	
	UnitEquipFilterUtil:updateListUI(3, arg_11_1, arg_11_2)
end

function UnitEquipGradeFilter.UI.init(arg_12_0, arg_12_1)
	arg_12_0.vars = {}
	arg_12_0.vars.node_set_box = arg_12_1
end

UnitEquipGradeFilter.Data = {}

function UnitEquipGradeFilter.Data.onHandler(arg_13_0, arg_13_1)
	if string.starts(arg_13_1, "btn_sort") then
		local var_13_0 = UnitEquipFilterUtil:getSortIndex(arg_13_1)
		
		if var_13_0 ~= 1 then
			local var_13_1 = arg_13_0.vars.selected_list[var_13_0]
			
			arg_13_0.vars.selected_list[var_13_0] = not var_13_1
			
			arg_13_0:moveSelect(var_13_0)
		else
			arg_13_0:clear()
		end
		
		arg_13_0:updateAllSelectButton()
	end
end

function UnitEquipGradeFilter.Data.moveSelect(arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.selected_list) do
		if iter_14_0 ~= 1 and arg_14_1 ~= iter_14_0 and arg_14_0.vars.selected_list[iter_14_0] == true then
			arg_14_0.vars.selected_list[iter_14_0] = false
		end
	end
end

function UnitEquipGradeFilter.Data.updateAllSelectButton(arg_15_0)
	UnitEquipFilterUtil:updateAllSelectButton(arg_15_0.vars.selected_list)
end

function UnitEquipGradeFilter.Data.clear(arg_16_0)
	UnitEquipFilterUtil:clear(arg_16_0.vars.selected_list)
end

function UnitEquipGradeFilter.Data.getSetFxLists(arg_17_0)
	return arg_17_0.vars.grade_item_list
end

function UnitEquipGradeFilter.Data.getSelectedList(arg_18_0)
	return arg_18_0.vars.selected_list
end

function UnitEquipGradeFilter.Data.getUsableFilter(arg_19_0)
	return UnitEquipFilterUtil:getUsableFilter(arg_19_0.vars.selected_list, arg_19_0.vars.grade_item_list)
end

function UnitEquipGradeFilter.Data.getFilterList(arg_20_0)
	return UnitEquipFilterUtil:getFilterList(arg_20_0.vars.selected_list, arg_20_0.vars.grade_item_list)
end

function UnitEquipGradeFilter.Data.init(arg_21_0)
	arg_21_0.vars = {}
	arg_21_0.vars.grade_item_list = {
		"all",
		"ext_4",
		"ext_3"
	}
	arg_21_0.vars.selected_list = {}
end
