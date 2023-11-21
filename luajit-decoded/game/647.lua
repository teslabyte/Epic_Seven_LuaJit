WorldChampion = WorldChampion or {}

function WorldChampion.sort(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or AccountData.e7wc_game_schedule
	
	if not arg_1_1 then
		return 
	end
	
	table.sort(arg_1_1, function(arg_2_0, arg_2_1)
		return arg_2_0.start_time < arg_2_1.start_time
	end)
	
	return arg_1_1
end

function WorldChampion.getCurrentMatch(arg_3_0, arg_3_1, arg_3_2)
	arg_3_1 = arg_3_1 or arg_3_0:sort()
	
	if not arg_3_1 then
		return 
	end
	
	local var_3_0 = os.time()
	local var_3_1 = arg_3_2 and 43200 or 0
	
	for iter_3_0, iter_3_1 in pairs(arg_3_1 or {}) do
		if arg_3_2 then
			if var_3_0 < iter_3_1.start_time and var_3_0 >= iter_3_1.start_time - var_3_1 then
				return iter_3_1
			end
		elseif var_3_0 >= iter_3_1.start_time and var_3_0 < iter_3_1.end_time then
			return iter_3_1
		end
	end
end

function WorldChampion.isShowE7WCIcon(arg_4_0)
	local var_4_0 = AccountData.e7wc_lobby_icon_schedule
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = var_4_0.default
	
	if not var_4_1 or not var_4_1.start_time or not var_4_1.end_time then
		return 
	end
	
	local var_4_2 = os.time()
	
	return var_4_2 >= var_4_1.start_time and var_4_2 < var_4_1.end_time
end

function WorldChampion.hasStreaming(arg_5_0)
	if not arg_5_0:isShowE7WCIcon() then
		return 
	end
	
	local var_5_0 = arg_5_0:getCurrentMatch()
	
	if not var_5_0 then
		return 
	end
	
	local var_5_1 = os.time()
	
	return var_5_1 >= var_5_0.start_time and var_5_1 < var_5_0.end_time, var_5_0
end
