UnitEquipStatFilter = {}

function UnitEquipStatFilter.onHandler(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2 == "btn_cancel" then
		arg_1_0:close()
	end
	
	if string.starts(arg_1_2, "btn_sort") then
		arg_1_0.Data:onHandler(arg_1_2)
		arg_1_0.UI:updateList(arg_1_0.Data:getSelectedList())
		
		local var_1_0, var_1_1 = arg_1_0.Data:getFilterList()
		
		Inventory:updateButtonStatList(var_1_0, var_1_1)
		arg_1_0:close()
	end
end

function UnitEquipStatFilter.create(arg_2_0, arg_2_1)
	local var_2_0 = {}
	local var_2_1 = table.clone(UnitEquipStatFilter)
	
	var_2_1:init(arg_2_1)
	
	var_2_1.vars = {}
	
	return var_2_1
end

function UnitEquipStatFilter.init(arg_3_0, arg_3_1)
	arg_3_0.Data:init()
	arg_3_0.Data:clear()
	arg_3_0.UI:init(arg_3_1)
	arg_3_0.UI:updateList(arg_3_0.Data:getSelectedList())
end

function UnitEquipStatFilter.open(arg_4_0)
	arg_4_0.UI:setVisible(true)
	
	arg_4_0.vars.open = true
	
	local var_4_0, var_4_1 = arg_4_0.Data:getFilterList()
	
	Inventory:updateButtonStatList(var_4_0, var_4_1)
end

function UnitEquipStatFilter.close(arg_5_0)
	arg_5_0.UI:setVisible(false)
	Inventory:ResetItems()
	
	local var_5_0, var_5_1 = arg_5_0.Data:getFilterList()
	
	Inventory:setButtonStatList(var_5_0, var_5_1)
	
	arg_5_0.vars.open = false
end

function UnitEquipStatFilter.isOpen(arg_6_0)
	return arg_6_0.vars.open
end

UnitEquipStatFilter.UI = {}

function UnitEquipStatFilter.UI.init(arg_7_0, arg_7_1)
	arg_7_0.vars = {}
	arg_7_0.vars.n_mainstat_box = arg_7_1
end

function UnitEquipStatFilter.UI.setVisible(arg_8_0, arg_8_1)
	if_set_visible(arg_8_0.vars.n_mainstat_box, nil, arg_8_1)
end

function UnitEquipStatFilter.UI.updateList(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or arg_9_0.vars.n_mainstat_box
	
	UnitEquipFilterUtil:updateListUI(12, arg_9_1, arg_9_2)
end

function UnitEquipStatFilter.UI.setCursor(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	UnitEquipFilterUtil:setCursor(arg_10_1, arg_10_2, arg_10_3)
end

UnitEquipStatFilter.Data = {}

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

function UnitEquipStatFilter.Data.init(arg_11_0)
	arg_11_0.vars = {}
	arg_11_0.vars.selected_list = {}
	arg_11_0.vars.id_list = table.clone(var_0_0)
end

function UnitEquipStatFilter.Data.onHandler(arg_12_0, arg_12_1)
	if string.starts(arg_12_1, "btn_sort") then
		local var_12_0 = UnitEquipFilterUtil:getSortIndex(arg_12_1)
		
		if var_12_0 ~= 1 then
			local var_12_1 = arg_12_0.vars.selected_list[var_12_0]
			
			arg_12_0.vars.selected_list[var_12_0] = not var_12_1
			
			arg_12_0:moveSelect(var_12_0)
		else
			arg_12_0:clear()
		end
		
		arg_12_0:updateAllSelectButton()
	end
end

function UnitEquipStatFilter.Data.moveSelect(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.selected_list) do
		if iter_13_0 ~= 1 and arg_13_1 ~= iter_13_0 and arg_13_0.vars.selected_list[iter_13_0] == true then
			arg_13_0.vars.selected_list[iter_13_0] = false
		end
	end
end

function UnitEquipStatFilter.Data.clear(arg_14_0)
	UnitEquipFilterUtil:clear(arg_14_0.vars.selected_list)
end

function UnitEquipStatFilter.Data.updateAllSelectButton(arg_15_0)
	UnitEquipFilterUtil:updateAllSelectButton(arg_15_0.vars.selected_list)
end

function UnitEquipStatFilter.Data.getSelectedList(arg_16_0)
	return arg_16_0.vars.selected_list
end

function UnitEquipStatFilter.Data.getUsableFilter(arg_17_0)
	return UnitEquipFilterUtil:getUsableFilter(arg_17_0.vars.selected_list, arg_17_0.vars.id_list)
end

function UnitEquipStatFilter.Data.getFilterList(arg_18_0)
	return UnitEquipFilterUtil:getFilterList(arg_18_0.vars.selected_list, arg_18_0.vars.id_list)
end
