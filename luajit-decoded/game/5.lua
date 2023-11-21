Thread = ClassDef()

function Thread.constructor(arg_1_0, arg_1_1, arg_1_2, ...)
	arg_1_0.name = arg_1_1 or string.format("thread%p", arg_1_0)
	arg_1_0.co = coroutine.create(arg_1_2)
	arg_1_0.handler = arg_1_2
	arg_1_0.args = {
		...
	}
	
	ThreadManager:add(arg_1_0)
	arg_1_0:resume()
end

function Thread.status(arg_2_0)
	return coroutine.status(arg_2_0.co)
end

function Thread.resume(arg_3_0)
	local var_3_0, var_3_1 = coroutine.resume(arg_3_0.co, table.unpack(arg_3_0.args))
	
	if not var_3_0 then
		print(" Thread.resume : ", var_3_1)
	end
	
	return var_3_0
end

function Thread.exit(arg_4_0)
	ThreadManager:remove(arg_4_0)
end

function Thread.wait(arg_5_0, arg_5_1)
	ThreadManager:wait(arg_5_1)
end

if not ThreadManager then
	ThreadManager = {}
	ThreadManager._routines = {}
	ThreadManager._remove_list = {}
end

function ThreadManager.getCurrent(arg_6_0)
	local var_6_0 = coroutine.running()
	
	if not var_6_0 then
		return 
	end
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0._routines) do
		if iter_6_1.co == var_6_0 then
			return iter_6_1
		end
	end
end

function ThreadManager.wait(arg_7_0, arg_7_1)
	if not coroutine.running() then
		return 
	end
	
	local var_7_0 = systick()
	local var_7_1 = arg_7_1 or 0
	
	while var_7_1 > systick() - var_7_0 do
		coroutine.yield()
	end
end

function ThreadManager.add(arg_8_0, arg_8_1)
	table.insert(arg_8_0._routines, arg_8_1)
end

function ThreadManager.remove(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_0._routines) do
		table.insert(arg_9_0._remove_list, iter_9_0)
	end
end

function ThreadManager.process(arg_10_0)
	table.sort(arg_10_0._remove_list, function(arg_11_0, arg_11_1)
		return arg_11_1 < arg_11_0
	end)
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0._remove_list) do
		table.remove(arg_10_0._routines, iter_10_1)
	end
	
	arg_10_0._remove_list = {}
	
	for iter_10_2, iter_10_3 in pairs(arg_10_0._routines) do
		local var_10_0 = false
		
		if iter_10_3:status() ~= "dead" then
			local var_10_1, var_10_2 = xpcall(iter_10_3.resume, __G__TRACKBACK__, iter_10_3)
			
			if not var_10_1 then
				var_10_0 = true
			end
		else
			var_10_0 = true
		end
		
		if var_10_0 then
			table.insert(arg_10_0._remove_list, 1, iter_10_2)
		end
	end
	
	table.sort(arg_10_0._remove_list, function(arg_12_0, arg_12_1)
		return arg_12_1 < arg_12_0
	end)
	
	for iter_10_4, iter_10_5 in pairs(arg_10_0._remove_list) do
		table.remove(arg_10_0._routines, iter_10_5)
	end
	
	arg_10_0._remove_list = {}
end

function ThreadManager.findByName(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0._routines) do
		if iter_13_1.name == arg_13_1 then
			return iter_13_1
		end
	end
end

function ThreadManager.findByHandler(arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_0._routines) do
		if iter_14_1.handler == arg_14_1 then
			return iter_14_1
		end
	end
end

function test_cofunc()
	local function var_15_0(arg_16_0, arg_16_1, arg_16_2)
		for iter_16_0 = 0, 100 do
			print("print tick ", iter_16_0, arg_16_0, arg_16_1, arg_16_2)
			Thread:wait(100)
		end
	end
	
	local var_15_1 = Thread("thread", var_15_0, "argument1", "argument2", 3)
end
