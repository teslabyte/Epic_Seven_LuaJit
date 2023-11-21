if not ChatMBox then
	ChatMBox = {}
end

CHAT_DUMP_TIME = 2

function ChatMBox.init(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_0.inst and (arg_1_0.inst.user_id ~= arg_1_1 or arg_1_0.inst.clan_id ~= arg_1_2) then
		if arg_1_0.inst.file_name then
			collectgarbage("collect")
			delete_raw_file(arg_1_0.inst.file_name)
		end
		
		arg_1_0.inst = nil
		arg_1_0.vars = nil
	end
	
	if not arg_1_0.inst then
		arg_1_0.inst = {}
		arg_1_0.inst.user_id = arg_1_1
		arg_1_0.inst.clan_id = arg_1_2
		arg_1_0.inst.file_name = "chat_" .. tostring(arg_1_1) .. ".tmbx"
		arg_1_0.inst.file_path = cc.FileUtils:getInstance():getWritablePath() .. "/" .. arg_1_0.inst.file_name
		arg_1_0.inst.start_time = os.time()
		arg_1_0.inst.unseen_msg_count = 0
	end
	
	arg_1_0.vars = arg_1_0.vars or {}
	arg_1_0.vars.chat_history = {}
	arg_1_0.vars.replay_cache = {}
	
	arg_1_0:initDB()
end

function ChatMBox.initDB(arg_2_0)
	if not arg_2_0.inst.clan_id then
		return 
	end
	
	arg_2_0.vars.file_message_list = {}
	
	local var_2_0 = io.open(arg_2_0.inst.file_path, "r")
	
	if var_2_0 then
		local var_2_1 = var_2_0:read("*a")
		local var_2_2 = json.decode(var_2_1 or {})
		
		if var_2_2 then
			for iter_2_0, iter_2_1 in pairs(var_2_2) do
				table.insert(arg_2_0.vars.file_message_list, iter_2_1)
			end
			
			local var_2_3 = var_2_2[#var_2_2]
			
			arg_2_0.vars.last_message_id = var_2_3.msg_id
		else
			arg_2_0.vars.last_message_id = 0
		end
	else
		var_2_0 = io.open(arg_2_0.inst.file_path, "w")
		arg_2_0.vars.last_message_id = 0
	end
	
	var_2_0:close()
end

function ChatMBox.getLastMessageId(arg_3_0, arg_3_1)
	if not arg_3_0.vars then
		return 0
	end
	
	return arg_3_0.vars.last_message_id or 0
end

function ChatMBox._filtList(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	local var_4_0 = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		if iter_4_1.msg_doc and iter_4_1.msg_doc.contents and iter_4_1.msg_doc.contents.type and iter_4_1.msg_doc.contents.from then
			local var_4_1 = iter_4_1.msg_doc.contents.type
			local var_4_2 = iter_4_1.msg_doc.contents.from
			
			if var_4_1 == "unit" and var_4_2 == "upgrade" then
				table.insert(var_4_0, iter_4_0)
			elseif var_4_1 == "equip" and var_4_2 == "enhance" then
				table.insert(var_4_0, iter_4_0)
			end
		end
	end
	
	for iter_4_2 = #var_4_0, 1, -1 do
		table.remove(arg_4_1, var_4_0[iter_4_2])
	end
	
	return arg_4_1
end

function ChatMBox.getHistory(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return {}
	end
	
	if not arg_5_0.vars.chat_history then
		return {}
	end
	
	return arg_5_0:_filtList(arg_5_0.vars.chat_history[arg_5_1])
end

function ChatMBox.clearHistory(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	if not arg_6_0.vars.chat_history then
		return 
	end
	
	arg_6_0.vars.chat_history[arg_6_1] = {}
end

function ChatMBox.getReplayData(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return nil
	end
	
	local var_7_0 = arg_7_0:getHistory("replay_shared")
	local var_7_1 = {}
	
	if var_7_0 and not table.empty(var_7_0) then
		for iter_7_0, iter_7_1 in pairs(var_7_0) do
			if iter_7_1.msg_doc and iter_7_1.msg_doc.contents and iter_7_1.msg_doc.contents.replay_share_id == arg_7_1 then
				table.insert(var_7_1, iter_7_1)
			end
		end
	end
	
	if not table.empty(var_7_1) then
		if table.count(var_7_1) > 1 then
			table.sort(var_7_1, function(arg_8_0, arg_8_1)
				return arg_8_0.msg_tm > arg_8_1.msg_tm
			end)
		end
		
		local var_7_2 = var_7_1[1].msg_doc.contents
		
		return {
			replay_share_id = var_7_2.replay_share_id,
			secret_key = var_7_2.secret_key
		}
	end
	
	return nil
end

function ChatMBox.getReplayCache(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return nil
	end
	
	if not arg_9_0.vars.replay_cache or table.empty(arg_9_0.vars.replay_cache) then
		return nil
	end
	
	local var_9_0 = arg_9_0.vars.replay_cache[arg_9_1]
	
	if var_9_0 then
		return var_9_0
	end
	
	return nil
end

function ChatMBox.setReplayCache(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	if not arg_10_0.vars or not arg_10_0.vars.replay_cache then
		return 
	end
	
	if not arg_10_1 or not arg_10_2 or not arg_10_3 or not arg_10_4 or not arg_10_5 then
		return 
	end
	
	arg_10_0.vars.replay_cache[arg_10_1] = {
		battle_info = arg_10_2,
		verify_data = arg_10_3,
		unverify_data = arg_10_4,
		replay_min_version = arg_10_5,
		battle_recent_limit_day = arg_10_6
	}
end

function ChatMBox.insert(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not arg_11_0.vars then
		return 
	end
	
	if not arg_11_0.vars.chat_history then
		return 
	end
	
	if not arg_11_0.vars.chat_history[arg_11_1] then
		arg_11_0.vars.chat_history[arg_11_1] = {}
	end
	
	if arg_11_1 == "clan" then
		if not arg_11_0.vars.chat_history.clan_chatonly then
			arg_11_0.vars.chat_history.clan_chatonly = {}
		end
		
		if not arg_11_0.vars.chat_history.replay_shared then
			arg_11_0.vars.chat_history.replay_shared = {}
		end
	end
	
	local function var_11_0(arg_12_0)
		if not arg_12_0 then
			return 
		end
		
		local var_12_0
		
		if arg_11_2.msg_id then
			for iter_12_0 = #arg_12_0, 1, -1 do
				local var_12_1 = arg_12_0[iter_12_0]
				
				if arg_11_2.msg_id == var_12_1.msg_id then
					return 
				end
				
				if (tonumber(arg_11_2.msg_id) or 0) > (tonumber(var_12_1.msg_id) or 0) then
					var_12_0 = iter_12_0 + 1
					
					break
				end
			end
		end
		
		if var_12_0 then
			table.insert(arg_12_0, var_12_0, arg_11_2)
		else
			table.insert(arg_12_0, arg_11_2)
		end
		
		while #arg_12_0 > MAX_CHAT_LINE do
			table.remove(arg_12_0, 1)
		end
	end
	
	local function var_11_1()
		return arg_11_1 == "clan" or arg_11_1 == "clan_chatonly"
	end
	
	if var_11_1() then
		var_11_0(arg_11_0.vars.chat_history.clan)
		
		if arg_11_0:_isUserMessage(arg_11_2) then
			var_11_0(arg_11_0.vars.chat_history.clan_chatonly)
		end
		
		if arg_11_0:_isReplayMessage(arg_11_2) then
			var_11_0(arg_11_0.vars.chat_history.replay_shared)
		end
	else
		var_11_0(arg_11_0.vars.chat_history[arg_11_1])
	end
	
	if arg_11_3 ~= "load" and var_11_1() and arg_11_0.vars.file_message_list then
		table.insert(arg_11_0.vars.file_message_list, arg_11_2)
	end
	
	if arg_11_3 ~= "load" then
		ChatMain:updateChatNotification()
	end
end

function ChatMBox.update(arg_14_0)
	if not arg_14_0.inst then
		return 
	end
	
	if not arg_14_0.vars then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.file_message_list
	
	if var_14_0 and #var_14_0 > 0 then
		local var_14_1 = var_14_0[#var_14_0]
		
		if not var_14_1 then
			return 
		end
		
		if arg_14_0.vars.last_message_id ~= var_14_1.msg_id and os.time() - arg_14_0.inst.start_time >= CHAT_DUMP_TIME then
			arg_14_0.inst.start_time = os.time()
			arg_14_0.vars.last_message_id = var_14_1.msg_id
			
			arg_14_0:_dumpMessage()
		end
	end
end

function ChatMBox._dumpMessage(arg_15_0)
	local var_15_0 = arg_15_0.vars.file_message_list
	
	if not var_15_0 then
		return 
	end
	
	if #var_15_0 == 0 then
		return 
	end
	
	local var_15_1
	
	if (function()
		local var_16_0 = 0
		
		for iter_16_0, iter_16_1 in pairs(var_15_0) do
			if arg_15_0:_isUserMessage(iter_16_1) then
				var_16_0 = var_16_0 + 1
			end
		end
		
		return var_16_0
	end)() > MAX_CHAT_LINE then
		while #var_15_0 > MAX_FILE_SAVE do
			table.remove(var_15_0, 1)
		end
	else
		var_15_1 = 1
		
		while var_15_1 <= #var_15_0 and #var_15_0 > MAX_FILE_SAVE do
			if var_15_1 > #var_15_0 then
				break
			end
			
			local var_15_2 = var_15_0[var_15_1]
			
			if not var_15_2 then
				break
			end
			
			if not arg_15_0:_isUserMessage(var_15_2) then
				table.remove(var_15_0, var_15_1)
			else
				var_15_1 = var_15_1 + 1
			end
		end
	end
	
	local var_15_3 = {}
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		local var_15_4 = tonumber(iter_15_1.msg_id)
		
		if var_15_4 then
			local var_15_5 = {
				section = "clan",
				msg_id = var_15_4,
				user_id = iter_15_1.user_id,
				msg_doc = iter_15_1.msg_doc,
				msg_tm = iter_15_1.msg_tm
			}
			
			table.insert(var_15_3, var_15_5)
		end
	end
	
	local var_15_6 = io.open(arg_15_0.inst.file_path, "w")
	
	var_15_6:write(json.encode(var_15_3))
	var_15_6:close()
end

function ChatMBox.loadCache(arg_17_0, arg_17_1)
	if not arg_17_0.vars or not arg_17_0.vars.file_message_list then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.file_message_list
	
	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		local var_17_1 = tonumber(iter_17_1.msg_id)
		
		if var_17_1 then
			local var_17_2 = {
				section = "clan",
				msg_id = var_17_1,
				user_id = iter_17_1.user_id,
				msg_doc = iter_17_1.msg_doc,
				msg_tm = iter_17_1.msg_tm
			}
			
			arg_17_0:insert(arg_17_1, var_17_2, "load")
		end
	end
end

function ChatMBox.getUnseenMsgCount(arg_18_0)
	if not arg_18_0.inst then
		return 0
	end
	
	if not arg_18_0.vars then
		return 0
	end
	
	if not arg_18_0.vars.file_message_list then
		return 0
	end
	
	local var_18_0 = 0
	local var_18_1 = SAVE:getUserDefaultData("last_seen_msgid", "0")
	local var_18_2 = tonumber(var_18_1) or 0
	local var_18_3 = arg_18_0.vars.file_message_list
	local var_18_4 = var_18_3[#var_18_3]
	
	if not var_18_4 then
		return 0
	end
	
	if var_18_2 == (tonumber(var_18_4.msg_id) or 0) then
		return 0
	end
	
	for iter_18_0 = #var_18_3, 1, -1 do
		local var_18_5 = var_18_3[iter_18_0]
		local var_18_6 = tonumber(var_18_5.msg_id) or 0
		local var_18_7 = tonumber(var_18_5.user_id)
		
		if arg_18_0:_isUserMessage(var_18_5) and var_18_2 < var_18_6 and (not var_18_7 or var_18_7 ~= tonumber(Account:getUserId())) then
			var_18_0 = var_18_0 + 1
			
			if var_18_0 >= MAX_CHAT_LINE then
				break
			end
		end
	end
	
	return var_18_0
end

function ChatMBox.resetUnseenMsgCount(arg_19_0)
	if not arg_19_0.inst then
		return 
	end
	
	if not arg_19_0.vars then
		return 
	end
	
	local var_19_0 = SAVE:getUserDefaultData("last_seen_msgid", "0")
	local var_19_1 = tonumber(var_19_0) or 0
	local var_19_2 = arg_19_0.vars.chat_history.clan_chatonly
	
	if not var_19_2 or table.count(var_19_2) == 0 then
		return 
	end
	
	local var_19_3 = var_19_2[#var_19_2]
	
	if not var_19_3 then
		return 
	end
	
	local var_19_4 = tonumber(var_19_3.msg_id) or 0
	
	if var_19_1 < var_19_4 then
		local var_19_5 = tostring(var_19_4)
		
		SAVE:setUserDefaultData("last_seen_msgid", var_19_5)
	end
end

function ChatMBox._isUserMessage(arg_20_0, arg_20_1)
	if not arg_20_1 then
		return 
	end
	
	local var_20_0 = arg_20_1.msg_doc
	
	return var_20_0 and var_20_0.sender and not var_20_0.type
end

function ChatMBox._isReplayMessage(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0 = arg_21_1.msg_doc
	
	return var_21_0 and var_21_0.sender and var_21_0.type == "replay"
end
