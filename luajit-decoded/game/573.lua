ItemFilterUtil = {}

function ItemFilterUtil.getFilterCheckList(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or {}
	
	local var_1_0 = {}
	local var_1_1 = ({
		role = 7,
		star = 6,
		element = 5,
		skill = 8
	})[arg_1_2]
	local var_1_2 = true
	
	for iter_1_0 = 1, var_1_1 do
		local var_1_3 = arg_1_1[arg_1_2][iter_1_0]
		
		if not var_1_3 then
			break
		end
		
		if arg_1_3[var_1_3] ~= nil then
			var_1_0[iter_1_0] = arg_1_3[var_1_3]
		else
			var_1_0[iter_1_0] = true
		end
		
		if not var_1_0[iter_1_0] then
			var_1_2 = false
		end
	end
	
	var_1_0.all = var_1_2
	
	if var_1_2 then
		for iter_1_1 = 1, var_1_1 do
			var_1_0[iter_1_1] = false
		end
	end
	
	return var_1_0
end

function ItemFilterUtil.getDefaultUnHashTable(arg_2_0)
	return {
		star = {
			6,
			5,
			4,
			3,
			2,
			1,
			all = "all"
		},
		role = {
			"warrior",
			"knight",
			"assassin",
			"ranger",
			"mage",
			"manauser",
			"material",
			all = "all"
		},
		element = {
			"fire",
			"ice",
			"wind",
			"light",
			all = "all",
			[5] = "dark"
		},
		skill = {
			all = "all"
		}
	}
end

ItemFilter = {}

function ItemFilter.create(arg_3_0, arg_3_1)
	local var_3_0 = {}
	
	copy_functions(ItemFilter, var_3_0)
	
	var_3_0.create_opts = arg_3_1
	var_3_0.vars = {}
	
	return var_3_0
end

function ItemFilter.setWnd(arg_4_0, arg_4_1)
	arg_4_0.vars.wnd = arg_4_1
end

function ItemFilter.onSetSorter(arg_5_0, arg_5_1)
	arg_5_0.vars.filter_check_flags = {}
	arg_5_0.vars.opts = arg_5_1
end

function ItemFilter.updateFilterCheckBox(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_0.create_opts.sort_off then
		return 
	end
	
	local var_6_0 = arg_6_1:findChildByName("n_check_box_" .. arg_6_2)
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1 = var_6_0:findChildByName("checkbox_" .. arg_6_3 .. "_" .. arg_6_2)
	
	if not var_6_1 then
		return 
	end
	
	local var_6_2 = arg_6_4[arg_6_2] == true
	
	var_6_1:setSelected(var_6_2)
	if_set_visible(var_6_0, "select_bg_" .. arg_6_3 .. "_" .. arg_6_2, var_6_2)
	
	if arg_6_3 == "role" or arg_6_2 == "all" then
		local var_6_3 = {
			"warrior",
			"knight",
			"assassin",
			"ranger",
			"mage",
			"manauser",
			"material",
			all = "all"
		}
		local var_6_4 = arg_6_3 == "role" and var_6_3[arg_6_2] or arg_6_2
		local var_6_5 = arg_6_2 == "all" and cc.c3b(255, 255, 255) or cc.c3b(136, 136, 136)
		
		if var_6_2 then
			var_6_5 = cc.c3b(107, 193, 27)
		end
		
		if_set_color(var_6_0, "icon_" .. var_6_4, var_6_5)
	end
	
	return true
end

function ItemFilter.setFilterCheckBoxes(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.vars.wnd:findChildByName("n_" .. arg_7_1)
	
	if not var_7_0 then
		return 
	end
	
	arg_7_0.vars.filter_check_flags[arg_7_1] = {}
	
	local function var_7_1(arg_8_0)
		if not arg_7_0:updateFilterCheckBox(var_7_0, arg_8_0, arg_7_1, arg_7_2) then
			return false
		end
		
		local var_8_0 = arg_7_2[arg_8_0]
		
		arg_7_0.vars.filter_check_flags[arg_7_1][arg_8_0] = var_8_0
		
		return true
	end
	
	var_7_1("all")
	
	for iter_7_0 = 1, 10 do
		if not var_7_1(iter_7_0) then
			break
		end
	end
end

function ItemFilter.updateFilters(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or {
		"star",
		"role",
		"element"
	}
	
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		local var_9_0 = arg_9_0.vars.filter_check_flags[iter_9_1]
		local var_9_1 = arg_9_0.vars.wnd:findChildByName("n_" .. iter_9_1)
		
		if var_9_1 then
			for iter_9_2 = 1, 10 do
				arg_9_0:updateFilterCheckBox(var_9_1, iter_9_2, iter_9_1, var_9_0)
			end
		end
	end
end

function ItemFilter.updateFilter(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_0.vars.filter_check_flags[arg_10_2][arg_10_3] = arg_10_4
	
	arg_10_0:updateFilterCheckBox(arg_10_1, arg_10_3, arg_10_2, arg_10_0.vars.filter_check_flags[arg_10_2])
end

function ItemFilter.setFilters(arg_11_0, arg_11_1)
	arg_11_0.vars.filter_check_flags = {}
	
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		arg_11_0:setFilterCheckBoxes(iter_11_1.id, iter_11_1.check_list)
	end
end

function ItemFilter.toggleAllFilter(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.vars.filter_check_flags[arg_12_1]
	local var_12_1 = arg_12_0.vars.wnd:findChildByName("n_" .. arg_12_1)
	local var_12_2 = not arg_12_0.vars.filter_check_flags[arg_12_1].all
	
	arg_12_0:updateFilter(var_12_1, arg_12_1, "all", var_12_2)
	
	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_0 ~= "all" then
			arg_12_0:updateFilter(var_12_1, arg_12_1, iter_12_0, not var_12_2)
			
			if arg_12_0.vars.opts.callback_on_add_filter then
				arg_12_0.vars.opts.callback_on_add_filter(arg_12_1, iter_12_0, true)
			end
		end
	end
	
	if arg_12_0.vars.opts.callback_on_commit_filter then
		arg_12_0.vars.opts.callback_on_commit_filter()
	end
end

function ItemFilter.revertAllFlag(arg_13_0, arg_13_1)
	if not arg_13_0.vars.filter_check_flags[arg_13_1].all then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.filter_check_flags[arg_13_1]
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		if iter_13_0 ~= "all" and arg_13_0.vars.opts.callback_on_add_filter then
			arg_13_0.vars.opts.callback_on_add_filter(arg_13_1, iter_13_0, false)
		end
	end
end

function ItemFilter.toggleNormalFilter(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.vars.wnd:findChildByName("n_" .. arg_14_2)
	
	arg_14_0:updateFilter(var_14_0, arg_14_2, arg_14_1, not arg_14_0.vars.filter_check_flags[arg_14_2][arg_14_1])
	arg_14_0:updateFilter(var_14_0, arg_14_2, "all", false)
	
	return arg_14_0.vars.filter_check_flags[arg_14_2][arg_14_1]
end

function ItemFilter.isAllOff(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.filter_check_flags[arg_15_1]) do
		if iter_15_1 then
			return false
		end
	end
	
	return true
end

function ItemFilter.toggleFilter(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_1 == "all" then
		arg_16_0:toggleAllFilter(arg_16_2)
	else
		arg_16_0:revertAllFlag(arg_16_2)
		
		local var_16_0 = arg_16_0:toggleNormalFilter(arg_16_1, arg_16_2)
		
		if arg_16_0:isAllOff(arg_16_2) then
			arg_16_0:toggleAllFilter(arg_16_2)
			
			return 
		end
		
		if arg_16_0.vars.opts.callback_on_add_filter then
			arg_16_0.vars.opts.callback_on_add_filter(arg_16_2, arg_16_1, var_16_0)
			arg_16_0.vars.opts.callback_on_commit_filter(arg_16_2, arg_16_1, var_16_0)
		end
	end
end

function ItemFilter.isFiltering(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.filter_check_flags or {}) do
		if not iter_17_1.all then
			return true
		end
	end
	
	return false
end
