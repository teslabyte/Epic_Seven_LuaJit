if not Scheduler then
	Scheduler = {}
	Scheduler._schedules = {}
end

function Scheduler.add(arg_1_0, arg_1_1, arg_1_2, ...)
	local var_1_0
	
	if not PRODUCTION_MODE then
		var_1_0 = debug.getinfo(2).func
	end
	
	local var_1_1 = {
		obj = arg_1_1,
		func = bind_func(arg_1_2, ...),
		stack = var_1_0,
		setName = function(arg_2_0, arg_2_1)
			arg_2_0.name = arg_2_1
		end,
		getName = function(arg_3_0)
			return arg_3_0.name or ""
		end
	}
	
	table.insert(arg_1_0._schedules, var_1_1)
	
	return var_1_1
end

function Scheduler.addSlow(arg_4_0, arg_4_1, arg_4_2, ...)
	return arg_4_0:addInterval(arg_4_1, 1000, arg_4_2, ...)
end

function Scheduler.addInterval(arg_5_0, arg_5_1, arg_5_2, arg_5_3, ...)
	local var_5_0 = arg_5_0:add(arg_5_1, arg_5_3, ...)
	
	var_5_0.next_tm = 0
	var_5_0.interval = arg_5_2
	
	return var_5_0
end

function Scheduler.addGlobal(arg_6_0, arg_6_1, ...)
	return arg_6_0:add(nil, arg_6_1, ...)
end

function Scheduler.addGlobalInterval(arg_7_0, arg_7_1, arg_7_2, ...)
	local var_7_0 = arg_7_0:add(nil, arg_7_2, ...)
	
	var_7_0.next_tm = 0
	var_7_0.interval = arg_7_1
	
	return var_7_0
end

function Scheduler.findByName(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_0._schedules) do
		if iter_8_1.name and iter_8_1.name == arg_8_1 then
			return iter_8_1
		end
	end
	
	return false
end

function Scheduler.removeByName(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._schedules) do
		if iter_9_1.name and iter_9_1.name == arg_9_1 then
			iter_9_1.removed = true
		end
	end
end

function Scheduler.remove(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0._schedules) do
		if iter_10_1.func["-func"] == arg_10_1 or iter_10_1 == arg_10_1 then
			iter_10_1.removed = true
		end
	end
end

function Scheduler.Poll(arg_11_0, arg_11_1)
	local var_11_0 = table.maxn(arg_11_0._schedules)
	
	for iter_11_0 = 1, var_11_0 do
		local var_11_1 = arg_11_0._schedules[iter_11_0]
		
		if not var_11_1.removed then
			if var_11_1.obj and not get_cocos_refid(var_11_1.obj) then
				var_11_1.removed = true
			elseif arg_11_1 == var_11_1.priority and (not var_11_1.next_tm or var_11_1.next_tm <= LAST_UI_TICK) then
				DEBUG_INFO.last_scheduler = var_11_1.stack
				
				xpcall(var_11_1.func, __G__TRACKBACK__)
				
				DEBUG_INFO.last_scheduler = nil
				
				if var_11_1.next_tm then
					var_11_1.next_tm = LAST_UI_TICK + var_11_1.interval
				end
			end
		end
	end
	
	for iter_11_1 = var_11_0, 1, -1 do
		if arg_11_0._schedules[iter_11_1].removed then
			table.remove(arg_11_0._schedules, iter_11_1)
		end
	end
end
