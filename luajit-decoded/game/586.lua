ResourceCollect = ResourceCollect or {}
ResourceCollect.resources = {}
ResourceCollect.enable = false

function ResourceCollect.callback(arg_1_0)
end

function ResourceCollect.add(arg_2_0, arg_2_1, arg_2_2)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_2_0.enable then
		return 
	end
	
	if string.match(arg_2_2, ".lua") then
		return 
	end
	
	local var_2_0 = arg_2_2:match("^.+/(.+)$") or arg_2_2
	local var_2_1 = arg_2_1 .. arg_2_2
	
	arg_2_0.resources[var_2_1] = var_2_0
end

function ResourceCollect.dump(arg_3_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_3_0.enable then
		return 
	end
	
	local var_3_0 = io.open(cc.FileUtils:getInstance():getWritablePath() .. "dumped_list.txt", "w")
	
	if var_3_0 then
		var_3_0:write(json.encode(arg_3_0.resources))
		var_3_0:close()
	end
end

function ResourceCollect.send(arg_4_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if not arg_4_0.enable then
		return 
	end
	
	local var_4_0 = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.resources) do
		table.insert(var_4_0, iter_4_0)
	end
	
	local var_4_1 = {}
	
	var_4_1.mode = "reg"
	var_4_1.minimal_data = array_to_json(var_4_0)
end
