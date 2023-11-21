UnitEquipSetFilter = {}

function UnitEquipSetFilter.onHandler(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = string.sub(arg_1_2, -1)
	
	arg_1_0.Data:onHandler(arg_1_1, arg_1_2)
	arg_1_0.UI:updateList(arg_1_0.Data:getSelectedList())
	
	if arg_1_2 == "btn_cancel" then
		arg_1_0:close()
	elseif string.starts(arg_1_2, "btn_sort") then
		local var_1_1, var_1_2 = arg_1_0.Data:getFilterList()
		
		Inventory:updateButtonSetFxList(var_1_1, var_1_2)
	end
end

function UnitEquipSetFilter.open(arg_2_0)
	arg_2_0.UI:setVisible(true)
	
	arg_2_0.vars.open = true
	
	local var_2_0, var_2_1 = arg_2_0.Data:getFilterList()
	
	Inventory:updateButtonSetFxList(var_2_0, var_2_1)
end

function UnitEquipSetFilter.close(arg_3_0)
	arg_3_0.UI:setVisible(false)
	Inventory:ResetItems()
	
	local var_3_0, var_3_1 = arg_3_0.Data:getFilterList()
	
	Inventory:setButtonSetFxList(var_3_0, var_3_1)
	
	arg_3_0.vars.open = false
end

function UnitEquipSetFilter.isOpen(arg_4_0)
	return arg_4_0.vars.open
end

function UnitEquipSetFilter.addSetFxCount(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.Data:addSetFxCount(arg_5_1, arg_5_2)
end

function UnitEquipSetFilter.clearSetFxCount(arg_6_0)
	arg_6_0.Data:clearSetFxCount()
end

function UnitEquipSetFilter.updateSetFxCountUI(arg_7_0)
	arg_7_0.UI:updateSetFxCount(arg_7_0.Data:getSetFxCountTable(), arg_7_0.Data:getSetFxLists())
end

function UnitEquipSetFilter.clear(arg_8_0, arg_8_1)
	arg_8_0.Data:clear()
	arg_8_0.UI:updateList(arg_8_0.Data:getSelectedList())
end

function UnitEquipSetFilter.create(arg_9_0, arg_9_1)
	local var_9_0 = {}
	local var_9_1 = table.clone(UnitEquipSetFilter)
	
	var_9_1.Data:init()
	
	local var_9_2 = var_9_1.Data:getSetFxLists()
	local var_9_3 = table.count(var_9_2)
	
	var_9_1.UI:init(arg_9_1, var_9_3)
	var_9_1.UI:setSortText(var_9_2)
	var_9_1.Data:clear()
	var_9_1.UI:updateList(var_9_1.Data:getSelectedList())
	
	var_9_1.vars = {}
	
	return var_9_1
end

UnitEquipSetFilter.UI = {}

function UnitEquipSetFilter.UI.onHandler(arg_10_0, arg_10_1, arg_10_2)
end

function UnitEquipSetFilter.UI.setVisible(arg_11_0, arg_11_1)
	if_set_visible(arg_11_0.vars.node_set_box, nil, arg_11_1)
end

function UnitEquipSetFilter.UI.setCursor(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	UnitEquipFilterUtil:setCursor(arg_12_1, arg_12_2, arg_12_3)
end

function UnitEquipSetFilter.UI.setSortText(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or arg_13_0.vars.node_set_box
	
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		if iter_13_1 ~= "all" then
			local var_13_0 = DB("item_set", iter_13_1, {
				"name"
			})
			local var_13_1 = arg_13_2:getChildByName("btn_sort" .. iter_13_0)
			
			if var_13_1 == nil then
				break
			end
			
			if_set(var_13_1, "txt_sort" .. iter_13_0, T(var_13_0))
		end
	end
end

function UnitEquipSetFilter.UI.updateSetFxCount(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_3 = arg_14_3 or arg_14_0.vars.node_set_box
	
	for iter_14_0, iter_14_1 in pairs(arg_14_2) do
		local var_14_0 = arg_14_1[iter_14_1]
		local var_14_1 = arg_14_3:findChildByName("btn_sort" .. iter_14_0)
		
		if not var_14_1 then
			Log.e("NOT FIND btn_sort INDEX WAS : ", iter_14_0)
		end
		
		if_set(var_14_1, "txt_amount" .. iter_14_0, arg_14_1[iter_14_1])
	end
end

function UnitEquipSetFilter.UI.updateList(arg_15_0, arg_15_1, arg_15_2)
	arg_15_2 = arg_15_2 or arg_15_0.vars.node_set_box
	
	if arg_15_0.vars.update_count then
		local var_15_0 = arg_15_0.vars.update_count
		
		UnitEquipFilterUtil:updateListUI(var_15_0, arg_15_1, arg_15_2)
	end
end

function UnitEquipSetFilter.UI.init(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.vars = {}
	arg_16_0.vars.node_set_box = arg_16_1
	arg_16_0.vars.update_count = arg_16_2
end

UnitEquipSetFilter.Data = {}

function UnitEquipSetFilter.Data.onHandler(arg_17_0, arg_17_1, arg_17_2)
	if string.starts(arg_17_2, "btn_sort") then
		local var_17_0 = UnitEquipFilterUtil:getSortIndex(arg_17_2)
		
		if var_17_0 ~= 1 then
			local var_17_1 = arg_17_0.vars.selected_list[var_17_0]
			
			arg_17_0.vars.selected_list[var_17_0] = not var_17_1
		else
			arg_17_0:clear()
		end
		
		arg_17_0:updateAllSelectButton()
	end
end

function UnitEquipSetFilter.Data.updateAllSelectButton(arg_18_0)
	UnitEquipFilterUtil:updateAllSelectButton(arg_18_0.vars.selected_list)
end

function UnitEquipSetFilter.Data.clear(arg_19_0)
	UnitEquipFilterUtil:clear(arg_19_0.vars.selected_list)
end

function UnitEquipSetFilter.Data.getSetFxLists(arg_20_0)
	return arg_20_0.vars.set_item_list
end

function UnitEquipSetFilter.Data.getSetFxCountTable(arg_21_0)
	return arg_21_0.vars.set_fx_count
end

function UnitEquipSetFilter.Data.getSelectedList(arg_22_0)
	return arg_22_0.vars.selected_list
end

function UnitEquipSetFilter.Data.addSetFxCount(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars.set_fx_count[arg_23_1] then
		Log.e("self.vars.set_fx_count[set_fx] NOT EXISTS!", arg_23_1)
		
		return 
	end
	
	local var_23_0 = arg_23_2 or 0
	local var_23_1 = arg_23_0.vars.set_fx_count[arg_23_1]
	local var_23_2 = arg_23_0.vars.set_fx_count.all
	
	arg_23_0.vars.set_fx_count[arg_23_1] = var_23_1 + var_23_0
	arg_23_0.vars.set_fx_count.all = var_23_2 + var_23_0
end

function UnitEquipSetFilter.Data.clearSetFxCount(arg_24_0)
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.set_fx_count) do
		arg_24_0.vars.set_fx_count[iter_24_0] = 0
	end
end

function UnitEquipSetFilter.Data.getUsableFilter(arg_25_0)
	return UnitEquipFilterUtil:getUsableFilter(arg_25_0.vars.selected_list, arg_25_0.vars.set_item_list)
end

function UnitEquipSetFilter.Data.getFilterList(arg_26_0)
	return UnitEquipFilterUtil:getFilterList(arg_26_0.vars.selected_list, arg_26_0.vars.set_item_list)
end

function UnitEquipSetFilter.Data.init(arg_27_0)
	arg_27_0.vars = {}
	arg_27_0.vars.set_item_list = UIUtil:getSetItemListExtention(true)
	arg_27_0.vars.selected_list = {}
	arg_27_0.vars.set_fx_count = {}
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.set_item_list) do
		arg_27_0.vars.set_fx_count[iter_27_1] = 0
	end
end
