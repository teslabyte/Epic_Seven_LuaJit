if not ChatBanUser then
	ChatBanUser = {}
end

BAN_REFRESH_TIME = 1

function ChatBanUser.init(arg_1_0, arg_1_1)
	if arg_1_0.inst and arg_1_0.inst.user_id ~= arg_1_1 then
		if arg_1_0.inst.file_name then
			collectgarbage("collect")
			delete_raw_file(arg_1_0.inst.file_name)
		end
		
		arg_1_0.inst = nil
	end
	
	if not arg_1_0.inst then
		arg_1_0.inst = {}
		arg_1_0.inst.user_id = arg_1_1
		arg_1_0.inst.file_name = "chat_" .. tostring(arg_1_1) .. ".tbuser"
		arg_1_0.inst.file_path = cc.FileUtils:getInstance():getWritablePath() .. "/" .. arg_1_0.inst.file_name
		arg_1_0.inst.start_time = os.time()
	end
	
	if not arg_1_0.vars then
		arg_1_0.vars = {}
	end
	
	arg_1_0:initDB()
end

function ChatBanUser.initDB(arg_2_0)
	arg_2_0.vars.banuser_list = {}
	
	local var_2_0 = io.open(arg_2_0.inst.file_path, "r")
	
	if var_2_0 then
		local var_2_1 = var_2_0:read("*a")
		local var_2_2 = json.decode(var_2_1 or {})
		
		if var_2_2 then
			for iter_2_0, iter_2_1 in pairs(var_2_2) do
				iter_2_0 = tonumber(iter_2_0)
				arg_2_0.vars.banuser_list[iter_2_0] = {
					banuser_id = iter_2_1.banuser_id,
					expire_tm = iter_2_1.expire_tm
				}
			end
		end
	else
		var_2_0 = io.open(arg_2_0.inst.file_path, "w")
	end
	
	var_2_0:close()
	exclude_backup_attr(arg_2_0.inst.file_path)
	arg_2_0:checkExpired()
end

function ChatBanUser.update(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	if not arg_3_0.vars.banuser_list then
		return 
	end
	
	if os.time() - arg_3_0.inst.start_time > BAN_REFRESH_TIME then
		arg_3_0.inst.start_time = os.time()
		
		arg_3_0:checkExpired()
	end
end

function ChatBanUser.checkExpired(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	if not arg_4_0.vars.banuser_list then
		return 
	end
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.banuser_list) do
		if os.time() > iter_4_1.expire_tm then
			arg_4_0:delete(iter_4_0)
		end
	end
end

function ChatBanUser.insert(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	if not arg_5_0.vars.banuser_list then
		return 
	end
	
	if not arg_5_1 then
		return 
	end
	
	arg_5_1 = tonumber(arg_5_1)
	
	local var_5_0 = os.time() + 86400
	
	arg_5_0.vars.banuser_list[arg_5_1] = {
		banuser_id = arg_5_1,
		expire_tm = var_5_0
	}
	
	local var_5_1 = io.open(arg_5_0.inst.file_path, "w")
	
	var_5_1:write(json.encode(arg_5_0.vars.banuser_list))
	var_5_1:close()
end

function ChatBanUser.delete(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	if not arg_6_0.vars.banuser_list then
		return 
	end
	
	if not arg_6_1 then
		return 
	end
	
	arg_6_1 = tonumber(arg_6_1)
	arg_6_0.vars.banuser_list[arg_6_1] = nil
	
	local var_6_0 = io.open(arg_6_0.inst.file_path, "w")
	
	var_6_0:write(json.encode(arg_6_0.vars.banuser_list))
	var_6_0:close()
end

function ChatBanUser.isBanUser(arg_7_0, arg_7_1)
	if not arg_7_0.vars or not arg_7_0.vars.banuser_list then
		return 
	end
	
	arg_7_1 = tonumber(arg_7_1)
	
	return arg_7_0.vars.banuser_list[arg_7_1]
end
