StatFilter = {}

local var_0_0 = {
	{
		id = "unit_power",
		idx = 1,
		func = UnitSortOrder.greaterThanPoint
	},
	{
		id = "att",
		idx = 2,
		func = UnitSortOrder.makeGreaterThanStat("att")
	},
	{
		id = "def",
		idx = 3,
		func = UnitSortOrder.makeGreaterThanStat("def")
	},
	{
		id = "max_hp",
		idx = 4,
		func = UnitSortOrder.makeGreaterThanStat("max_hp")
	},
	{
		id = "speed",
		idx = 5,
		func = UnitSortOrder.makeGreaterThanStat("speed")
	},
	{
		id = "cri",
		idx = 6,
		unit_bar_opt = "percent",
		func = UnitSortOrder.makeGreaterThanStat("cri")
	},
	{
		id = "cri_dmg",
		idx = 7,
		unit_bar_opt = "percent",
		func = UnitSortOrder.makeGreaterThanStat("cri_dmg")
	},
	{
		id = "acc",
		idx = 8,
		unit_bar_opt = "percent",
		func = UnitSortOrder.makeGreaterThanStat("acc")
	},
	{
		id = "res",
		idx = 9,
		unit_bar_opt = "percent",
		func = UnitSortOrder.makeGreaterThanStat("res")
	}
}

function HANDLER.sorting_filter_stat_list(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = getParentWindow(arg_1_0).filter
	
	if string.starts(arg_1_1, "btn_sort") then
		local var_1_1 = tonumber(string.sub(arg_1_1, -1, -1))
		local var_1_2 = var_1_0:getMenu(var_1_1)
		
		if var_1_2 and var_1_0.opts.btn_sort_callback then
			var_1_0.opts.btn_sort_callback(var_1_2.idx)
			var_1_0:hide()
		end
	elseif arg_1_1 == "btn_toggle" then
		var_1_0:hide()
	end
end

function StatFilter.create(arg_2_0, arg_2_1, arg_2_2)
	if not get_cocos_refid(arg_2_1) then
		return 
	end
	
	arg_2_2 = arg_2_2 or {}
	
	local var_2_0 = {}
	
	copy_functions(StatFilter, var_2_0)
	
	local var_2_1 = load_control("wnd/sorting_filter_stat_list.csb")
	
	var_2_1.filter = var_2_0
	var_2_0.vars = {}
	var_2_0.vars.wnd = var_2_1
	var_2_0.opts = arg_2_2
	
	for iter_2_0 = 1, table.count(var_0_0) do
		local var_2_2 = var_2_0:getMenu(iter_2_0).id
		local var_2_3 = var_2_1:getChildByName("btn_sort" .. iter_2_0)
		
		if_set(var_2_3, "txt_sort" .. iter_2_0, T(var_2_2))
		
		if iter_2_0 >= 2 then
			if_set_sprite(var_2_3, "icon", "img/icon_menu_" .. var_2_2 .. ".png")
		end
	end
	
	arg_2_1:addChild(var_2_1)
	var_2_0:hide()
	
	return var_2_0
end

function StatFilter.show(arg_3_0, arg_3_1, arg_3_2)
	if not get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	local var_3_0 = arg_3_1 or 1
	local var_3_1 = arg_3_2 or false
	local var_3_2 = arg_3_0.vars.wnd:getChildByName("n_sort_cursor")
	
	for iter_3_0 = 1, table.count(var_0_0) do
		if iter_3_0 == var_3_0 then
			local var_3_3 = arg_3_0.vars.wnd:getChildByName("btn_sort" .. iter_3_0)
			
			var_3_2:setPositionY(var_3_3:getPositionY())
			
			break
		end
	end
	
	if_set_visible(var_3_2, "btn_up", var_3_1)
	if_set_visible(var_3_2, "btn_down", not var_3_1)
	if_set_visible(arg_3_0.vars.wnd, nil, true)
	BackButtonManager:push({
		id = "stat_filter",
		back_func = function()
			arg_3_0:hide()
		end
	})
end

function StatFilter.hide(arg_5_0)
	if_set_visible(arg_5_0.vars.wnd, nil, false)
	BackButtonManager:pop({
		id = "stat_filter"
	})
end

function StatFilter.getMenu(arg_6_0, arg_6_1)
	return var_0_0[arg_6_1]
end
