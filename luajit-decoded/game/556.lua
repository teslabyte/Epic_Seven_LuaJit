if ChatSock then
	ChatSock:close()
end

if not ChatSock then
	ChatSock = {}
end

function _delay_call(arg_1_0, arg_1_1)
	local var_1_0 = Scheduler:addGlobalInterval(arg_1_0, function()
		arg_1_1()
		Scheduler:removeByName(arg_1_1)
	end)
	
	var_1_0.name = arg_1_1
	var_1_0.next_tm = LAST_UI_TICK + var_1_0.interval
end

function ChatSock.is_started(arg_3_0)
	if arg_3_0.enable then
		return true
	end
end

local function var_0_0()
	local var_4_0 = getenv("chat.url." .. "world_" .. Login:getRegion()) or getenv("chat.url.default")
	
	setenv("chat.url", var_4_0)
	print("set chat.url : ", var_4_0)
end

function ChatSock.validate_url(arg_5_0)
	return string.trim(arg_5_0:get_chat_url() or "") ~= ""
end

function ChatSock.get_chat_url(arg_6_0)
	return getenv("chat.url." .. "world_" .. Login:getRegion()) or getenv("chat.url.default")
end

function ChatSock.start(arg_7_0)
	if arg_7_0.websocket then
		return 
	end
	
	cc.WebSocket:closeAllConnections()
	
	if not arg_7_0:validate_url() then
		return 
	end
	
	local var_7_0 = arg_7_0:get_chat_url()
	
	if var_7_0 then
		arg_7_0.vars = {}
		arg_7_0.inst = {}
		arg_7_0.vars.last_notice_seq = -1
		arg_7_0.inst.url = getenv("test.chat.url") or var_7_0
		arg_7_0.inst.report_count = 0
	end
	
	arg_7_0:connect()
end

function ChatSock.stop(arg_8_0)
	arg_8_0.enable = false
	
	arg_8_0:close()
end

function ChatSock.connect(arg_9_0)
	if not arg_9_0.inst or not arg_9_0.inst.url then
		return 
	end
	
	arg_9_0.enable = true
	
	if arg_9_0.websocket then
		arg_9_0.websocket:asyncClose()
		
		arg_9_0.websocket = nil
		
		collectgarbage("collect")
	end
	
	if cc.WebSocket.createByCAFile then
		arg_9_0.websocket = cc.WebSocket:createByCAFile(arg_9_0.inst.url, getenv("websocket.cafile"))
	else
		arg_9_0.websocket = cc.WebSocket:create(arg_9_0.inst.url)
	end
	
	arg_9_0.websocket:registerScriptHandler(function(...)
		arg_9_0:onOpen(...)
	end, cc.WEBSOCKET_OPEN)
	arg_9_0.websocket:registerScriptHandler(function(...)
		arg_9_0:onMessage(...)
	end, cc.WEBSOCKET_MESSAGE)
	arg_9_0.websocket:registerScriptHandler(function(...)
		arg_9_0:onClose(...)
	end, cc.WEBSOCKET_CLOSE)
	arg_9_0.websocket:registerScriptHandler(function(...)
		arg_9_0:onError(...)
	end, cc.WEBSOCKET_ERROR)
end

function ChatSock.close(arg_14_0)
	if arg_14_0.websocket then
		arg_14_0.websocket:asyncClose()
		
		arg_14_0.websocket = nil
	end
end

function ChatSock.is_connected(arg_15_0)
	return arg_15_0.vars and arg_15_0.vars.connected
end

function ChatSock.getPublicChannelId(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	return arg_16_0.vars.public_channel_id
end

function ChatSock.send(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0.websocket then
		arg_17_0.seqnum = (arg_17_0.seqnum or 0) + 1
		
		if table.empty(arg_17_2) then
			arg_17_2 = nil
		end
		
		local var_17_0 = {
			cmd = arg_17_1,
			seq = arg_17_0.seqnum,
			params = arg_17_2
		}
		
		Log.d("CHAT", "request", arg_17_1)
		
		if DEBUG.CHAT then
			print("DEBUG ChatSock.send ")
			table.print(var_17_0)
		end
		
		local var_17_1 = MSGPack.pack(var_17_0)
		
		arg_17_0.websocket:sendBinary(var_17_1)
		
		return arg_17_0.seqnum
	end
end

function ChatSock.Poll(arg_18_0)
	if not arg_18_0.enable or arg_18_0.background then
		return 
	end
	
	if systick() - (arg_18_0.last_poll_tick or 0) > 2000 then
		arg_18_0.last_poll_tick = systick()
		
		if arg_18_0.enable and not arg_18_0.websocket then
			arg_18_0:connect()
		end
	end
end

function ChatSock.onEnterForground(arg_19_0)
	arg_19_0.background = nil
	
	if arg_19_0.enable and not arg_19_0.websocket then
		arg_19_0:connect()
	end
end

function ChatSock.onEnterBackground(arg_20_0)
	arg_20_0.background = true
	
	arg_20_0:close()
end

function ChatSock.onOpen(arg_21_0)
	local var_21_0 = Login:getLoginResult()
	
	if var_21_0 and var_21_0.id then
		arg_21_0.vars.connected = true
		arg_21_0.vars.state = "login"
		
		arg_21_0:send("svstate", {})
	else
		arg_21_0:close()
	end
end

function ChatSock.onMessage(arg_22_0, arg_22_1)
	local function var_22_0(arg_23_0)
		local var_23_0 = {}
		
		for iter_23_0, iter_23_1 in ipairs(arg_23_0) do
			local var_23_1 = iter_23_1 < 0 and 255 + iter_23_1 + 1 or iter_23_1
			
			table.insert(var_23_0, string.char(var_23_1))
		end
		
		return table.concat(var_23_0)
	end
	
	local var_22_1
	
	if type(arg_22_1) == "table" then
		var_22_1 = MSGPack.unpack(var_22_0(arg_22_1))
	else
		var_22_1 = MSGPack.unpack(arg_22_1)
	end
	
	if var_22_1 then
		arg_22_0:onResponseMsgPack(var_22_1)
	end
end

function ChatSock.onClose(arg_24_0)
	arg_24_0.last_poll_tick = systick()
	arg_24_0.vars.connected = false
	arg_24_0.websocket = nil
end

function ChatSock.onError(arg_25_0)
	arg_25_0.vars.connected = false
	
	print("DEBUG Error")
end

function ChatSock.getUserInfoParam(arg_26_0)
	local var_26_0 = Login:getLoginResult()
	local var_26_1 = {
		_ct = os.time(),
		user_id = var_26_0.id,
		clan_id = Account:getClanId(),
		clan_grade = Clan:getMemberGrade(),
		leader_code = Account:getMainUnitCode(),
		border_code = Account:getBorderCode(),
		name = Account:getName(true),
		session = var_26_0.session,
		favorite_channel = ChatFavorite:getFavoriteChannel()
	}
	
	if IS_PUBLISHER_ZLONG then
		if Zlong and Zlong.vars then
			var_26_1.zlong_id = Zlong.vars.zlong_id
			var_26_1.zlong_channel_id = Zlong.vars.channel_id
		end
		
		var_26_1.device_uid = get_udid()
	end
	
	return var_26_1
end

ChatSock._RESMSG = {}

function ChatSock._RESMSG.svstate(arg_27_0, arg_27_1)
	if arg_27_1.state == "running" then
		arg_27_0:send("login", arg_27_0:getUserInfoParam())
	else
		_delay_call(2000, function()
			if arg_27_0.vars.connected then
				arg_27_0:send("svstate")
			end
		end)
	end
end

function ChatSock._RESMSG.echo(arg_29_0, arg_29_1)
end

function ChatSock._RESMSG.login(arg_30_0, arg_30_1)
	arg_30_0.vars.login = true
	
	local var_30_0 = arg_30_1.public_channel_id
	
	if var_30_0 then
		local var_30_1 = arg_30_0.vars.public_channel_id ~= var_30_0
		
		if var_30_1 then
			arg_30_0.vars.public_channel_id = var_30_0
		end
		
		ChatMain:onPublicJoin(var_30_0, var_30_1)
	end
	
	local var_30_2 = arg_30_1.clan_id or arg_30_1.clan_channel_id
	
	if var_30_2 then
		ChatMain:onClanJoin(var_30_2)
		arg_30_0:request_MsgList("clan")
	end
end

function ChatSock._RESMSG.relogin(arg_31_0, arg_31_1)
	arg_31_0.vars.login = false
	
	arg_31_0:send("svstate")
end

function ChatSock._RESMSG.user_info(arg_32_0, arg_32_1)
	if arg_32_1.clan_change then
		arg_32_0:clan_join()
	end
end

function ChatSock._RESMSG.public_join(arg_33_0, arg_33_1)
	if arg_33_1.res ~= "ok" then
		balloon_message_with_sound("chat_" .. tostring(arg_33_1.res))
		
		return 
	end
	
	local var_33_0 = arg_33_1.public_channel_id
	local var_33_1 = arg_33_0.vars.public_channel_id ~= var_33_0
	
	if var_33_1 then
		arg_33_0.vars.public_channel_id = var_33_0
	end
	
	ChatMain:onPublicJoin(var_33_0, var_33_1)
end

function ChatSock._RESMSG.clan_join(arg_34_0, arg_34_1)
	arg_34_0.vars.clan_channel_id = arg_34_1.clan_channel_id
	
	ChatMain:onClanJoin(arg_34_1.clan_channel_id)
	arg_34_0:request_MsgList("clan")
end

function ChatSock._RESMSG.clan_leave(arg_35_0, arg_35_1)
	ChatMain:setSection("public")
end

function ChatSock._RESMSG.clan_level_up(arg_36_0, arg_36_1)
	ChatMain:setSection("public")
end

function ChatSock._RESMSG.clan_deport(arg_37_0, arg_37_1)
	ChatMain:setSection("public")
end

function ChatSock._RESMSG.volatile(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_1.params
	
	ChatMain:onVolatileMsg(var_38_0.section, var_38_0.msg_doc)
end

function ChatSock._RESMSG.get_msglist(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return 
	end
	
	local var_39_0 = json.decode(arg_39_1.msglist)
	
	if not var_39_0 then
		return 
	end
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if type(iter_39_1.msg_doc) == "string" then
			iter_39_1.msg_doc = json.decode(iter_39_1.msg_doc)
			iter_39_1.section = arg_39_1.section
		end
		
		ChatMain:addChatData(iter_39_1)
	end
end

function ChatSock._RESMSG.msg(arg_40_0, arg_40_1)
	ChatMain:addChatData(arg_40_1.params)
	
	if arg_40_1.params and arg_40_1.params.msg_doc and not ChatMain:isVisible() then
		if arg_40_1.params.msg_doc.notice_seq then
			local var_40_0 = arg_40_1.params.msg_doc.notice_seq
			
			if var_40_0 ~= arg_40_0.vars.last_notice_seq and arg_40_1.params.user_id ~= Account:getUserId() and ChatMain:onCastToolTip(arg_40_1.params) then
				arg_40_0.vars.last_notice_seq = var_40_0
			end
		elseif not arg_40_1.params.msg_doc.emoji then
			ChatMain:onCastToolTip(arg_40_1.params)
		else
			ChatMain:onCastEmoji(arg_40_1.params)
		end
	end
end

function ChatSock._RESMSG.mbox_ready(arg_41_0, arg_41_1)
	arg_41_0:request_MsgList("clan")
end

function ChatSock._RESMSG.post_chat(arg_42_0, arg_42_1)
	if arg_42_1.res == "user_chat_ban" then
		local var_42_0 = os.time()
		local var_42_1 = arg_42_1.end_time - var_42_0
		local var_42_2 = arg_42_1.reason
		local var_42_3 = T("chat_block_cooltime", {
			time = sec_to_full_string(var_42_1, false)
		})
		
		if var_42_2 and string.len(var_42_2) > 0 then
			var_42_3 = var_42_3 .. "(" .. var_42_2 .. ")"
		end
		
		balloon_message_with_sound(var_42_3)
	elseif arg_42_1.res == "user_chat_mute" then
		ChatMain:addChatData(arg_42_1.params)
	end
end

function ChatSock._RESMSG.report_chat(arg_43_0, arg_43_1)
	arg_43_0.inst.report_count = arg_43_1.count
	
	if arg_43_1.res == "ok" then
		balloon_message_with_sound("chat_accuse_popup_success")
	elseif arg_43_1.res == "invalid_report_count" then
		balloon_message_with_sound("chat_accuse_day_3")
	end
	
	if false then
	end
end

function ChatSock._RESMSG.world_arena_invite_ask(arg_44_0, arg_44_1)
	Log.i("chat_invite_ask", table.print(arg_44_1))
	LuaEventDispatcher:dispatchEvent("invite.event", "push", arg_44_1)
end

function ChatSock._RESMSG.world_arena_invite_cancel(arg_45_0, arg_45_1)
	Log.i("chat_invite_cancel", table.print(arg_45_1))
	LuaEventDispatcher:dispatchEvent("invite.event", "pop", arg_45_1)
end

function ChatSock._RESMSG.replay_share(arg_46_0, arg_46_1)
	if arg_46_1.res == "ok" then
		balloon_message_with_sound("msg_pvp_rta_replay_share_success")
	elseif arg_46_1.res == "user_chat_ban" then
		local var_46_0 = os.time()
		local var_46_1 = arg_46_1.end_time - var_46_0
		
		Dialog:msgBox(T("chat_block_cooltime", {
			time = sec_to_full_string(var_46_1, false)
		}), {
			handler = function()
				SceneManager:nextScene(arg_46_1.next_scene or "lobby")
				SceneManager:resetSceneFlow()
			end
		})
	elseif arg_46_1.res == "channel_not_found" then
		Dialog:msgBox(T("msg_pvp_rta_replay_lock_clanban"), {
			handler = function()
				SceneManager:nextScene(arg_46_1.next_scene or "lobby")
				SceneManager:resetSceneFlow()
			end
		})
	end
end

function ChatSock.onResponseMsgPack(arg_49_0, arg_49_1)
	Log.d("CHAT", "response", arg_49_1.res_cmd)
	
	local var_49_0 = tonumber(arg_49_1.res_seq)
	
	if var_49_0 and arg_49_0.vars then
		arg_49_0.vars.last_res_seqnum = var_49_0
	end
	
	if DEBUG.CHAT then
		print("====================================== ", var_49_0)
		print("DEBUG ChatSock.send ")
		table.print(arg_49_1)
	end
	
	local var_49_1 = arg_49_0._RESMSG[arg_49_1.res_cmd]
	
	if not var_49_1 then
		return 
	end
	
	var_49_1(arg_49_0, arg_49_1)
end

function ChatSock.request_MsgList(arg_50_0, arg_50_1)
	arg_50_0:send("get_msglist", {
		section = arg_50_1,
		last_msg_id = ChatMBox:getLastMessageId(arg_50_1)
	})
end

function ChatSock.post_chat(arg_51_0, arg_51_1)
	arg_51_0:send("post_chat", arg_51_1)
end

function ChatSock.replay_share(arg_52_0, arg_52_1)
	arg_52_0:send("replay_share", arg_52_1)
end

function ChatSock.clan_join(arg_53_0)
	if not Account:getClanId() then
		return 
	end
	
	arg_53_0:send("clan_join", {})
end

function ChatSock.clan_build_start(arg_54_0, arg_54_1)
	if not Account:getClanId() then
		return 
	end
	
	ChatSock:post_chat({
		type = "clan_build_begin",
		section = "clan"
	})
end

function ChatSock.public_join(arg_55_0, arg_55_1)
	if arg_55_0.vars.public_channel_id == arg_55_1 then
		return 
	end
	
	arg_55_0:send("public_join", {
		channel_id = arg_55_1
	})
end

function ChatSock.report_chat(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0.inst or not arg_56_0.inst.report_count then
		return 
	end
	
	if arg_56_0.inst.report_count >= 3 then
		balloon_message_with_sound("chat_accuse_day_3")
		
		return 
	end
	
	arg_56_0:send("report_chat", {
		section = arg_56_1,
		report_type = arg_56_2
	})
end
