MAX_CHAT_LINE = 50
MAX_CHAT_TEXT = 100
MAX_FILE_SAVE = 100
MAX_CHANNEL_TEXT = 4
REPORT_TYPE = {
	OPPROBRIUM = 2,
	REPEAT = 1,
	OTHER = 4,
	NICKNAME = 3
}
ChatMain = {}

function HANDLER.chat(arg_1_0, arg_1_1)
	local var_1_0 = getParentWindow(arg_1_0)
	
	if arg_1_1 == "btn_close" then
		ChatMain:hide()
	elseif arg_1_1 == "btn_favorite" then
		ChatFavorite:show()
	elseif arg_1_1 == "btn_channel" then
		ChatMain:toggleChannelLayer()
	elseif arg_1_1 == "btn_join" then
		ChatMain:changeChannel()
	elseif arg_1_1 == "btn_broadcast_setting" then
		ChatMain:showBroadcastSettingDlg()
	elseif arg_1_1 == "btn_broadcast_off" then
		ChatMain:setBroadcastOff(false)
	elseif arg_1_1 == "btn_broadcast_on" then
		ChatMain:setBroadcastOff(true)
	elseif arg_1_1 == "btn_opacity_off" then
		ChatMain:setOpacityOn(true)
	elseif arg_1_1 == "btn_opacity_on" then
		ChatMain:setOpacityOn(false)
	elseif arg_1_1 == "btn_onlychat_off" then
		ChatMain:setChatOnly(true)
		ChatMain:setSection("clan_chatonly")
	elseif arg_1_1 == "btn_onlychat_on" then
		ChatMain:setChatOnly(false)
		ChatMain:setSection("clan")
	elseif arg_1_1 == "btn_send" then
		ChatMain:send()
	elseif arg_1_1 == "btn_emoji" then
		ChatEmojiPopup:show()
	elseif arg_1_1 == "btn_list_clan" then
		if not Account:getClanId() then
			Dialog:msgBox(T("chat_guild_yet"))
			
			return 
		end
		
		ChatMain:setChatOnly(false)
		ChatMain:setSection("clan")
	elseif arg_1_1 == "btn_list_public" then
		ChatMain:setSection("public")
	elseif arg_1_1 == "btn_list_arena" then
		ChatMain:setSection("arena")
	end
end

function HANDLER.chat_section(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_notice_close" then
		ChatMain:foldSectionNotice(true)
	end
	
	if arg_2_1 == "btn_notice_open" then
		if #ChatMain:getPublicNotices() == 0 and ChatMain:getCurSectionName() == "public" then
			balloon_message_with_sound("chat_none_notice")
			
			return 
		end
		
		ChatMain:foldSectionNotice(false)
	end
end

function HANDLER.chat_filter(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		ChatMain:closeBroadcastSetting()
	elseif arg_3_1 == "btn_public" then
		ChatMain:updateBroadcastSettingUIMode("public")
	elseif arg_3_1 == "btn_clan" then
		ChatMain:updateBroadcastSettingUIMode("clan")
	elseif arg_3_1 == "btn_keyword" then
		ChatMain:updateBroadcastSettingUIMode("keyword")
	elseif arg_3_1 == "btn_input" then
		local var_3_0 = string.sub(arg_3_0:getParent():getName(), #"n_keyword" + 1, -1)
		
		ChatMain:onInputNotiKeyword(tonumber(var_3_0))
	elseif arg_3_1 == "btn_cancel" then
		local var_3_1 = string.sub(arg_3_0:getParent():getParent():getName(), #"n_keyword" + 1, -1)
		
		ChatMain:onCancelNotikeyword(tonumber(var_3_1))
	elseif string.starts(arg_3_1, "btn_checkbox_") then
		local var_3_2 = string.sub(arg_3_1, #"btn_checkbox_" + 1, -1)
		
		if var_3_2 == "all" then
			ChatMain:toggleBroadcastFilter(-1)
		elseif tonumber(var_3_2) then
			ChatMain:toggleBroadcastFilter(tonumber(var_3_2))
		end
	end
end

function HANDLER.chat_emoji_tip(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		ChatEmojiPopup:close()
	end
end

function HANDLER.pvp_emoji_tip(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		RtaEmojiPopup:close()
	end
end

function HANDLER.chat_favorite(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" then
		ChatFavorite:close()
	elseif arg_6_1 == "btn_join" then
		ChatFavorite:changeFavorite()
	end
end

local function var_0_0(arg_7_0)
	if not arg_7_0 or not get_cocos_refid(arg_7_0) then
		return nil
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0:getChildren()) do
		return tonumber(iter_7_1:getName())
	end
	
	return nil
end

local function var_0_1(arg_8_0)
	if arg_8_0 and arg_8_0.res == "ok" then
		ChatMBox:setReplayCache(arg_8_0.replay_share_id, arg_8_0.battle_info, arg_8_0.verify_data, arg_8_0.unverify_data, arg_8_0.replay_min_version, arg_8_0.battle_recent_limit_day)
		ArenaNetBattleDetailInfo:show("RANK", arg_8_0.battle_info, {
			show_share = false,
			show_replay = true
		}, arg_8_0.replay_share_id)
		UIAction:Remove("block")
	end
end

function MsgHandler.arena_net_match_server_info(arg_9_0)
	if arg_9_0.res == "ok" then
		MatchService:init()
		MatchService:setUri(arg_9_0.arena_net_enter_info.arena_net_match_uri)
		
		local var_9_0 = ChatMBox:getReplayData(arg_9_0.replay_share_id)
		
		MatchService:query("arena_net_replay_view", var_9_0, function(arg_10_0)
			var_0_1(arg_10_0)
		end)
	end
end

local function var_0_2(arg_11_0)
	if arg_11_0 == "battle" or arg_11_0 == "world_boss" or arg_11_0 == "rumble" then
		return true
	end
	
	return false
end

local function var_0_3(arg_12_0)
	if arg_12_0 == "arena_net_ready" or arg_12_0 == "arena_net_lounge" or arg_12_0 == "arena_net_round_next" or arg_12_0 == "arena_net_round_result" then
		return true
	end
	
	if ArenaNetLobby:isLock() then
		return true
	end
	
	return false
end

function HANDLER.chat_node_replay(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_go" then
		if ContentDisable:byAlias("world_arena_replay") then
			balloon_message_with_sound("msg_pvp_rta_replay_share_contentoff")
			
			return 
		end
		
		local var_13_0 = SceneManager:getCurrentSceneName()
		
		if var_0_2(var_13_0) then
			balloon_message_with_sound("msg_pvp_rta_replay_share_playlimit")
			
			return 
		end
		
		if var_0_3(var_13_0) then
			balloon_message_with_sound("msg_pvp_rta_replay_lock_worldarena")
			
			return 
		end
		
		local var_13_1 = var_0_0(arg_13_0)
		
		if var_13_1 then
			local var_13_2 = ChatMBox:getReplayCache(var_13_1)
			
			if var_13_2 then
				ArenaNetBattleDetailInfo:show("RANK", var_13_2.battle_info, {
					show_share = false,
					show_replay = true
				}, var_13_1)
				
				return 
			end
			
			local var_13_3 = ChatMBox:getReplayData(var_13_1)
			
			if var_13_3 == nil then
				balloon_message_with_sound("msg_pvp_rta_replay_chatrefresh")
				ChatMain:hide()
				
				return 
			end
			
			if MatchService:getUri() then
				MatchService:query("arena_net_replay_view", var_13_3, function(arg_14_0)
					var_0_1(arg_14_0)
				end)
			else
				query("arena_net_match_server_info", {
					replay_share_id = var_13_1
				})
			end
			
			UIAction:Add(DELAY(0), arg_13_0, "block")
		end
	end
end

local function var_0_4(arg_15_0, arg_15_1, arg_15_2)
	return arg_15_2 and arg_15_0 or string.format("<%s>%s</>", arg_15_1, arg_15_0)
end

local function var_0_5(arg_16_0)
end

local function var_0_6(arg_17_0, arg_17_1)
	if not arg_17_0.msg_doc then
		return ""
	end
	
	if arg_17_0.msg_doc.disp_text then
		return arg_17_0.msg_doc.disp_text
	end
	
	if arg_17_0.msg_doc.text then
		local var_17_0 = arg_17_0.msg_doc.text
		local var_17_1 = utf8sub(var_17_0, 1, MAX_CHAT_TEXT)
		local var_17_2 = string.gsub(var_17_1, "<", "＜")
		local var_17_3 = string.gsub(var_17_2, ">", "＞")
		
		if arg_17_0.noti_keyword then
			local var_17_4 = arg_17_0.noti_keyword
			local var_17_5 = string.gsub(var_17_4, "<", "＜")
			
			arg_17_0.noti_keyword = string.gsub(var_17_5, ">", "＞")
		end
		
		if arg_17_0.msg_doc.ignore_filter then
			arg_17_0.msg_doc.disp_text = var_17_3
		else
			arg_17_0.msg_doc.disp_text = check_abuse_filter(var_17_3, ABUSE_FILTER.CHAT) or var_17_3
		end
		
		return arg_17_0.msg_doc.disp_text
	end
	
	local var_17_6
	local var_17_7 = arg_17_0.msg_doc.style or arg_17_0.msg_doc.type
	
	if var_17_7 == "clan_join" then
		if arg_17_0.msg_doc.user then
			var_17_6 = T("ui_char_enter_user", {
				name = arg_17_0.msg_doc.user.name
			})
		end
	elseif var_17_7 == "clan_leave" then
		if arg_17_0.msg_doc.user then
			var_17_6 = T("ui_char_out_user", {
				name = arg_17_0.msg_doc.user.name
			})
		end
	elseif var_17_7 == "clan_deport" then
		if arg_17_0.msg_doc.user then
			var_17_6 = T("ui_char_deport_user", {
				name = arg_17_0.msg_doc.user.name
			})
		end
	elseif var_17_7 == "clan_build_begin" then
		if arg_17_0.msg_doc.sender then
			var_17_6 = T("clan_war_chat_msg_009", {
				f_user_name = arg_17_0.msg_doc.sender.name
			})
		end
	elseif var_17_7 == "clan_build_saved" then
		if arg_17_0.msg_doc.user then
			var_17_6 = T("clan_war_chat_msg_010", {
				f_user_name = arg_17_0.msg_doc.user.name
			})
		end
	elseif var_17_7 == "clan_battle_begin" then
		if arg_17_0.msg_doc.user then
			var_17_6 = T("clan_war_chat_msg_005", {
				f_user_name = arg_17_0.msg_doc.user.name,
				e_user_name = arg_17_0.msg_doc.enemy_user_name or ""
			})
		end
	elseif var_17_7 == "clan_battle_end" then
		if arg_17_0.msg_doc.user and arg_17_0.msg_doc.result then
			local var_17_8 = {
				"clan_war_chat_msg_008",
				"clan_war_chat_msg_007",
				"clan_war_chat_msg_006"
			}
			
			var_17_6 = T(var_17_8[arg_17_0.msg_doc.result + 1] or "", {
				f_user_name = arg_17_0.msg_doc.user.name,
				e_user_name = arg_17_0.msg_doc.enemy_user_name
			})
		end
	elseif var_17_7 == "clan_level_up" then
		var_17_6 = T("broadcast_clan_lvup", {
			clan_lv = arg_17_0.msg_doc.level
		})
		
		return var_17_6, arg_17_0
	elseif var_17_7 == "clan_promote" then
		if arg_17_0.msg_doc.clan_name then
			local var_17_9 = var_0_4("[" .. (arg_17_0.msg_doc.clan_name or "") .. "]", "#337ac3", arg_17_1)
			
			var_17_6 = T("ui_clan_popup_promote_base", {
				clanname = var_17_9
			})
		end
	elseif var_17_7 == "notice" then
		local var_17_10 = arg_17_0.msg_doc.sender
		local var_17_11 = var_0_4(var_17_10 and var_17_10.name or arg_17_0.user_id, "#337ac3", arg_17_1)
		local var_17_12 = arg_17_0.msg_doc.contents
		
		if var_17_12.type == "gacha" then
			if var_17_12.attrs.gacha_type == "character" then
				local var_17_13 = var_0_4(T(DB("character", var_17_12.attrs.code, "name")), "#d95700", arg_17_1)
				
				var_17_6 = T_KR("broadcast_unit", {
					name = var_17_11,
					item = var_17_13
				})
			else
				local var_17_14 = var_0_4(T(DB("equip_item", var_17_12.attrs.code, "name")), "#198700", arg_17_1)
				
				var_17_6 = T_KR("broadcast_equip", {
					name = var_17_11,
					item = var_17_14
				})
			end
		elseif var_17_12.type == "equip" then
			local var_17_15, var_17_16 = DB("equip_item", var_17_12.equip.code, {
				"name",
				"type"
			})
			local var_17_17 = var_0_4(T(var_17_15), "#198700", arg_17_1)
			local var_17_18 = EQUIP:createByInfo(var_17_12.equip)
			
			var_17_6 = T_KR("broadcast_equip_share", {
				name = var_17_11,
				equip = var_17_17
			})
		elseif var_17_12.type == "unit" then
			local var_17_19 = var_0_4(T(DB("character", var_17_12.unit.code, "name")), "#d95700", arg_17_1)
			
			var_17_6 = T_KR("broadcast_hero_share", {
				name = var_17_11,
				hero = var_17_19
			})
		elseif var_17_12.type == "request_item" then
			local var_17_20 = var_17_12.item_code
			local var_17_21 = var_0_4(T(DB("item_material", var_17_20, "name")), "#198700", arg_17_1)
			
			var_17_6 = T_KR("broadcast_aid", {
				name = var_17_11,
				item = var_17_21
			})
		end
	elseif var_17_7 == "replay" then
		local var_17_22 = arg_17_0.msg_doc.sender
		local var_17_23 = var_0_4(var_17_22 and var_17_22.name or arg_17_0.user_id, "#337ac3", arg_17_1)
		local var_17_24 = var_0_4(T(var_17_7), "#d95700", arg_17_1)
		
		var_17_6 = T_KR("broadcast_share_replay", {
			name = var_17_23,
			replay = var_17_24
		})
	elseif var_17_7 == "lota" then
		local var_17_25 = arg_17_0.msg_doc.contents
		
		if var_17_25.type then
			if var_17_25.type == "ch_clan_pve_boss_clear" and var_17_25.v2 then
				local var_17_26 = DB("clan_heritage_object_data", var_17_25.v2, "map_icon_before")
				local var_17_27 = DB("character", var_17_26, "name")
				
				var_17_25.v2 = T(var_17_27)
			end
			
			var_17_6 = T_KR(DB("clan_history", var_17_25.type, "text"), {
				value1 = var_17_25.v1,
				value2 = var_17_25.v2,
				value3 = var_17_25.v3,
				value4 = var_17_25.v4
			})
		elseif var_17_25.text then
			var_17_6 = T_KR(var_17_25.text, {
				value1 = var_17_25.v1,
				value2 = var_17_25.v2,
				value3 = var_17_25.v3,
				value4 = var_17_25.v4
			})
		end
	end
	
	var_17_6 = var_17_6 or ""
	
	if not arg_17_1 then
		arg_17_0.msg_doc.disp_text = var_17_6
	end
	
	return var_17_6
end

function ChatMain.init(arg_18_0)
	arg_18_0.enable = not ContentDisable:byAlias("chat")
	
	if arg_18_0.enable then
		arg_18_0:start()
	else
		arg_18_0:stop()
	end
end

function ChatMain.start(arg_19_0)
	if ChatSock:is_started() then
		return 
	end
	
	if not ChatSock:validate_url() then
		return 
	end
	
	LuaEventDispatcher:removeEventListenerByKey("chat")
	LuaEventDispatcher:addEventListener("clan.id", LISTENER(ChatMain.onClanChangeId, ChatMain), "chat")
	LuaEventDispatcher:addEventListener("change_main_unit", LISTENER(ChatMain.onChangeUserInfo, ChatMain), "chat")
	LuaEventDispatcher:addEventListener("change_nickname", LISTENER(ChatMain.onChangeUserInfo, ChatMain), "chat")
	LuaEventDispatcher:addEventListener("change_border", LISTENER(ChatMain.onChangeUserInfo, ChatMain), "chat")
	LuaEventDispatcher:addEventListener("clan.build_start", LISTENER(ChatMain.onClanBuildStart, ChatMain), "chat")
	ChatMBox:init(AccountData.id, AccountData.clan_id)
	ChatBanUser:init(AccountData.id)
	ChatSock:start()
end

function ChatMain.stop(arg_20_0)
	ChatSock:stop()
end

function ChatMain.onClanChangeId(arg_21_0, arg_21_1)
	if arg_21_1.clan_id then
		ChatSock:send("user_info", ChatSock:getUserInfoParam())
	end
end

function ChatMain.onClanBuildStart(arg_22_0, arg_22_1)
	ChatSock:clan_build_start()
end

function ChatMain.onChangeUserInfo(arg_23_0, arg_23_1)
	ChatSock:send("user_info", ChatSock:getUserInfoParam())
end

function ChatMain.isVisible(arg_24_0)
	return arg_24_0.vars and arg_24_0.vars.dlg and get_cocos_refid(arg_24_0.vars.dlg) and arg_24_0.vars.dlg:isVisible()
end

function ChatMain.changeChannel(arg_25_0)
	local var_25_0 = to_n(arg_25_0.vars.dlg.c.input_channel:getString())
	
	if var_25_0 <= 0 or var_25_0 > 9999 then
		balloon_message_with_sound("chat_invalid_channel")
		
		return 
	end
	
	ChatSock:public_join(var_25_0)
	arg_25_0:toggleChannelLayer()
end

function ChatMain.toggleChannelLayer(arg_26_0)
	local var_26_0 = arg_26_0.vars.dlg.c.n_channel_layer
	
	var_26_0:setVisible(not var_26_0:isVisible())
	
	local var_26_1 = arg_26_0.vars.dlg.c.input_channel
	
	if get_cocos_refid(var_26_1) then
		var_26_1:setString("")
		var_26_1:detachWithIME()
	end
	
	var_26_1:setMaxLength(MAX_CHANNEL_TEXT)
	var_26_1:setMaxLengthEnabled(true)
	var_26_1:setCursorEnabled(true)
	var_26_1:setTextColor(cc.c3b(107, 101, 27))
end

function ChatMain.refreshNotice(arg_27_0)
	if not arg_27_0:isVisible() then
		return 
	end
	
	if not arg_27_0.vars.cur_section or not arg_27_0.vars.cur_section:isVisible() then
		return 
	end
	
	if arg_27_0.vars.cur_section_name == "public" then
		query("notice_chat", {})
	elseif arg_27_0.vars.cur_section_name == "clan" or arg_27_0.vars.cur_section_name == "clan_chatonly" then
		arg_27_0.clan_notice = Clan:getNoticeOnlyText()
		
		arg_27_0.vars.cur_section:setNotice(arg_27_0.clan_notice)
		arg_27_0.vars.cur_section:foldSectionNotice(arg_27_0["last_fold_notice_" .. string.sub(arg_27_0.vars.cur_section.name, 1, 4)] or false)
	end
end

function ChatMain.updatePublicNotice(arg_28_0)
	local var_28_0 = table.collect(arg_28_0.public_notices, function(arg_29_0, arg_29_1)
		return "<#FFEA59>[" .. T("ui_channel_notice") .. "]</> " .. arg_29_1
	end)
	local var_28_1 = table.toCommaStr(var_28_0, "\n")
	
	arg_28_0.vars.cur_section:setNotice(var_28_1)
end

function MsgHandler.report_chat(arg_30_0)
	if arg_30_0.res == "ok" then
		balloon_message_with_sound("chat_accuse_popup_success")
	elseif arg_30_0.res == "invalid_report_count" then
		balloon_message_with_sound("chat_accuse_day_3")
	end
end

function ErrHandler.report_chat(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_2.res == "invalid_report_count" then
		balloon_message_with_sound("chat_accuse_day_3")
	end
end

function MsgHandler.notice_chat(arg_32_0)
	local var_32_0 = arg_32_0.notice_chats or {}
	local var_32_1 = {}
	
	for iter_32_0, iter_32_1 in pairs(var_32_0.info or {}) do
		table.push(var_32_1, UIUtil:translateServerText(iter_32_1.msg))
	end
	
	ChatMain:setPublicNotices(var_32_1)
	ChatMain:updatePublicNotice()
	
	if ChatMain:getCurSectionName() == "public" then
		if #var_32_1 == 0 then
			ChatMain:foldSectionNotice(ChatMain["last_fold_notice_" .. ChatMain:getCurSectionName()] or true)
		else
			ChatMain:foldSectionNotice(ChatMain["last_fold_notice_" .. ChatMain:getCurSectionName()] or false)
		end
	end
end

function ChatMain.reportChat(arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_0:isVisible() then
		return 
	end
	
	if not arg_33_0.vars.cur_section or not arg_33_0.vars.cur_section_name or not arg_33_0.vars.cur_section:isVisible() then
		return 
	end
	
	local var_33_0 = arg_33_0.vars.cur_section_name
	local var_33_1 = ChatMBox:getHistory(var_33_0)
	
	if not var_33_1 then
		return 
	end
	
	local var_33_2 = {}
	local var_33_3 = 0
	
	for iter_33_0 = #var_33_1, 1, -1 do
		local var_33_4 = var_33_1[iter_33_0]
		
		if not var_33_4 then
			break
		end
		
		if not var_33_4.msg_doc.style and var_33_4.msg_doc.sender and var_33_4.msg_doc.sender.id and var_33_4.msg_doc.text then
			var_33_3 = var_33_3 + 1
			
			if var_33_3 > 10 then
				break
			end
			
			local var_33_5 = {
				id = var_33_4.msg_doc.sender.id,
				nick = var_33_4.msg_doc.sender.name,
				level = arg_33_1,
				text = var_33_4.msg_doc.text,
				unix_time = var_33_4.msg_tm
			}
			
			table.insert(var_33_2, var_33_5)
		end
	end
	
	if table.count(var_33_2) == 0 then
		balloon_message_with_sound("chat_accuse_popup_success")
		
		return 
	end
	
	local var_33_6 = ChatSock:getPublicChannelId()
	local var_33_7 = Account:getClanId()
	
	query("report_chat", {
		report_type = arg_33_2,
		section = var_33_0,
		channel_id = var_33_6,
		clan_id = var_33_7,
		chat_dump = json.encode(var_33_2)
	})
end

function ChatMain.foldSectionNotice(arg_34_0, arg_34_1)
	arg_34_0["last_fold_notice_" .. string.sub(arg_34_0.vars.cur_section.name, 1, 4)] = arg_34_1
	
	arg_34_0.vars.cur_section:foldSectionNotice(arg_34_1)
end

function ChatMain.updateChatNotification(arg_35_0)
	TopBarNew:checkChatNotification()
	BattleTopBar:checkChatNotification()
	ArenaNetReady:checkChatNotification()
	ArenaNetRoundNext:checkChatNotification()
end

function ChatMain.checkNotification(arg_36_0)
	return not arg_36_0:isVisible() and arg_36_0.show_noti
end

function ChatMain.resetChatNotification(arg_37_0)
	arg_37_0.show_noti = nil
	
	arg_37_0:updateChatNotification()
end

function ChatMain.getNotificationEffect(arg_38_0, arg_38_1)
	if not get_cocos_refid(arg_38_1) then
		return 
	end
	
	return EffectManager:Play({
		fn = "ui_chat_keyword.cfx",
		layer = arg_38_1
	})
end

function ChatMain.onCastToolTip(arg_39_0, arg_39_1)
	if SAVE:getOptionData("option.gacha_bro_off", default_options.gacha_bro_off) == true then
		return 
	end
	
	if arg_39_0:isIgnoreChatUser(arg_39_1.user_id) then
		return 
	end
	
	if arg_39_1 and arg_39_1.msg_doc then
		if arg_39_1.msg_doc.contents then
			if arg_39_1.msg_doc.contents.type == "gacha" then
				if arg_39_1.msg_doc.contents.attrs then
					if arg_39_1.msg_doc.contents.attrs.gacha_type == "equip" and arg_39_1.msg_doc.contents.attrs and arg_39_1.msg_doc.contents.attrs.g == 5 then
						if not arg_39_0:getBroadcastFilter("noti_arti_summon_" .. arg_39_1.section) then
							return 
						end
					elseif arg_39_1.msg_doc.contents.attrs.gacha_type == "character" and arg_39_1.msg_doc.contents.attrs and arg_39_1.msg_doc.contents.attrs.g == 5 and not arg_39_0:getBroadcastFilter("noti_hero_summon_" .. arg_39_1.section) then
						return 
					end
				end
			elseif arg_39_1.msg_doc.type == "replay" and not arg_39_0:getBroadcastFilter("noti_replay_share_" .. arg_39_1.section) then
				return 
			end
		elseif arg_39_1.msg_doc.text and not arg_39_1.msg_doc.ignore_notify then
			local var_39_0 = false
			
			for iter_39_0 = 1, 5 do
				local var_39_1 = arg_39_0:getBroadcastFilter("keyword_" .. iter_39_0)
				
				if var_39_1 and type(var_39_1) == "string" and var_39_1 ~= "" and string.find(arg_39_1.msg_doc.text, var_39_1, 1, true) then
					arg_39_1.noti_keyword = var_39_1
					var_39_0 = true
				end
				
				if var_39_0 then
					arg_39_0.show_noti = true
					
					arg_39_0:updateChatNotification()
					
					break
				end
			end
			
			if not var_39_0 and not arg_39_0:getBroadcastFilter("noti_general_chat_" .. arg_39_1.section) then
				return 
			end
		elseif arg_39_1.msg_doc and arg_39_1.msg_doc.type == "clan_promote" and not arg_39_0:getBroadcastFilter("noti_clan_promote_" .. arg_39_1.section) then
			return 
		end
	end
	
	local var_39_2 = var_0_6(arg_39_1, false)
	local var_39_3 = {
		text = var_39_2,
		opts = arg_39_1
	}
	
	if var_39_2 and var_39_2 ~= "" then
		BattleTopBar:tip(var_39_3)
		ArenaNetReady:tip(var_39_3)
		ArenaNetRoundNext:tip(var_39_3)
		TopBarNew:tip(var_39_3)
		
		return true
	end
end

function ChatMain.onCastEmoji(arg_40_0, arg_40_1, arg_40_2)
	arg_40_2 = arg_40_2 or {}
	
	if SAVE:getOptionData("option.gacha_bro_off", default_options.gacha_bro_off) == true then
		return 
	end
	
	if arg_40_0:isIgnoreChatUser(arg_40_1.user_id) then
		return 
	end
	
	if not arg_40_0:getBroadcastFilter("noti_general_chat_" .. arg_40_1.section) then
		return 
	end
	
	local var_40_0 = arg_40_1.msg_doc and arg_40_1.msg_doc.emoji
	local var_40_1 = {
		emoji = var_40_0,
		opts = arg_40_1
	}
	
	if var_40_0 then
		BattleTopBar:tipEmoji(var_40_1)
		ArenaNetReady:tipEmoji(var_40_1)
		ArenaNetRoundNext:tipEmoji(var_40_1)
		TopBarNew:tipEmoji(var_40_1)
		
		return true
	end
end

function ChatMain.send(arg_41_0, arg_41_1)
	if not arg_41_0:isVisible() then
		return 
	end
	
	local var_41_0 = arg_41_0.vars.dlg:getChildByName("input")
	
	if not get_cocos_refid(var_41_0) then
		return 
	end
	
	if (GAME_CONTENT_VARIABLE.possible_chat_rank or 10) > AccountData.level then
		var_41_0:setString("")
		balloon_message_with_sound("ui_input_chat_condition")
		
		return 
	end
	
	if ArenaNetChat:isDisabled() then
		var_41_0:setString("")
		balloon_message_with_sound("pvp_rta_cannot_chat")
		
		return 
	end
	
	local var_41_1 = var_41_0:getString()
	
	if string.len(var_41_1) < 1 then
		return 
	end
	
	local var_41_2 = arg_41_0.vars.cur_section_name
	
	if var_41_2 == "clan_chatonly" then
		var_41_2 = "clan"
	end
	
	if not arg_41_0.last_send_tick then
		arg_41_0.last_send_tick = 0
	end
	
	if systick() - arg_41_0.last_send_tick > 3000 then
		arg_41_0.last_send_tick = systick()
		
		var_41_0:setString("")
		
		local var_41_3 = utf8sub(var_41_1, 1, MAX_CHAT_TEXT)
		local var_41_4 = {
			section = var_41_2,
			text = var_41_3
		}
		
		if var_41_2 == "arena" then
			LuaEventDispatcher:dispatchEvent("arena.chat.msg", var_41_4)
		else
			ChatSock:post_chat(var_41_4)
		end
	else
		balloon_message_with_sound("chat_repeat_cooltime")
	end
end

function ChatMain.sendEmoji(arg_42_0, arg_42_1)
	if not arg_42_0:isVisible() then
		return 
	end
	
	if (GAME_CONTENT_VARIABLE.possible_chat_rank or 10) > AccountData.level then
		balloon_message_with_sound("ui_input_chat_condition")
		
		return 
	end
	
	if not arg_42_0.last_send_emoji_tick then
		arg_42_0.last_send_emoji_tick = 0
	end
	
	if systick() - arg_42_0.last_send_emoji_tick > 3000 then
		arg_42_0.last_send_emoji_tick = systick()
		
		local var_42_0 = arg_42_0.vars.cur_section_name == "clan_chatonly" and "clan" or arg_42_0.vars.cur_section_name
		local var_42_1 = {
			text = "",
			section = var_42_0,
			emoji = arg_42_1
		}
		
		if var_42_0 == "arena" then
			LuaEventDispatcher:dispatchEvent("arena.chat.msg", var_42_1)
		else
			ChatSock:post_chat(var_42_1)
		end
		
		return true
	else
		balloon_message_with_sound("chat_repeat_cooltime")
	end
end

function ChatMain.hide(arg_43_0)
	if not arg_43_0:isVisible() then
		return 
	end
	
	TopBarNew:updateNewChatCount()
	BattleTopBar:updateNewChatCount()
	
	arg_43_0.vars.cur_section_name = nil
	
	arg_43_0.vars.dlg.c.input:detachWithIME()
	BackButtonManager:pop("chat")
	Battle:setTouckBlockOnce()
	LotaSystem:setBlockCoolTime()
	arg_43_0:setRepeatMode(false)
	
	arg_43_0.last_input_text = nil
	
	arg_43_0.vars.dlg:removeFromParent()
	
	arg_43_0.vars.dlg = nil
	
	SoundEngine:play("event:/ui/top_bar/quick_menu_off")
end

function ChatMain.show(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	arg_44_3 = arg_44_3 or {}
	
	if ContentDisable:byAlias("chat") then
		return 
	end
	
	if not ChatSock:validate_url() then
		balloon_message_with_sound("notyet_con")
		
		return 
	end
	
	if arg_44_0:isVisible() and not arg_44_0:isRepeatMode() then
		return 
	end
	
	arg_44_0.vars = {}
	arg_44_1 = arg_44_1 or SceneManager:getRunningPopupScene()
	arg_44_0.vars.dlg = load_dlg("chat", true, "wnd", function()
		if arg_44_3.no_close then
			return 
		end
		
		arg_44_0:hide()
	end)
	
	arg_44_1:addChild(arg_44_0.vars.dlg)
	arg_44_0.vars.dlg:setLocalZOrder(arg_44_3.z_order or 999998)
	if_set_visible(arg_44_0.vars.dlg, "n_channel_layer", false)
	
	local var_44_0 = arg_44_0.vars.dlg:getChildByName("input")
	
	var_44_0:setMaxLength(MAX_CHAT_TEXT)
	var_44_0:setMaxLengthEnabled(true)
	var_44_0:setCursorEnabled(true)
	var_44_0:setTextColor(cc.c3b(107, 101, 27))
	
	local var_44_1 = GAME_CONTENT_VARIABLE.possible_chat_rank or 10
	local var_44_2 = var_44_1 > AccountData.level and T("ui_impossible_input_chat") or T("ui_chat_input_touch")
	
	var_44_0:setPlaceHolder(var_44_2)
	var_44_0:setEnabled(var_44_1 <= AccountData.level)
	
	if arg_44_2 and var_44_1 <= AccountData.level then
		var_44_0:attachWithIME()
		var_44_0:requestFocus()
		
		local var_44_3 = arg_44_0:isRepeatMode() and arg_44_0.last_input_text or ""
		
		var_44_0:setString(var_44_3)
		
		arg_44_0.last_input_text = nil
	end
	
	arg_44_0.vars.dlg:getChildByName("btn_send"):setOpacity(var_44_1 > AccountData.level and 76.5 or 255)
	
	local var_44_4 = tolua.cast(var_44_0:getVirtualRenderer(), "cc.Label")
	
	var_44_0:addEventListener(function(arg_46_0, arg_46_1)
		UIUtil:updateTextWrapMode(var_44_4, var_44_0:getString(), 19)
		
		if arg_46_1 == ccui.TextFiledEventType.insert_text and var_44_0:getStringLength() >= MAX_CHAT_TEXT then
			balloon_message_with_sound("chat_limit_text", {
				limit = MAX_CHAT_TEXT
			})
		end
	end)
	
	local var_44_5 = arg_44_0.vars.dlg:getChildByName("btn_inputbg")
	
	arg_44_0.vars.input = {
		numlines = 1,
		ctrl = var_44_0,
		content_size = var_44_0:getContentSize(),
		bg_ctrl = var_44_5,
		bg_content_size = var_44_5:getContentSize()
	}
	
	for iter_44_0, iter_44_1 in pairs(arg_44_0.vars.dlg:getChildByName("n_category"):getChildren()) do
		if string.starts(iter_44_1:getName(), "n_") then
			if_set_visible(iter_44_1, "n_broadcast", false)
			if_set_visible(iter_44_1, "icon_noti", false)
		end
	end
	
	local var_44_6 = arg_44_3.section == "arena"
	
	if arg_44_0.last_section == "arena" and not var_44_6 then
		arg_44_0.last_section = nil
	end
	
	if_set_visible(arg_44_0.vars.dlg, "btn_close", not arg_44_3.no_close)
	if_set_visible(arg_44_0.vars.dlg, "dim", not arg_44_3.no_close)
	if_set_visible(arg_44_0.vars.dlg.c.n_category, "n_arena", var_44_6)
	
	arg_44_0.vars.chat_content = arg_44_0.vars.dlg:getChildByName("chat_content")
	arg_44_0.vars.chat_content_arena = arg_44_0.vars.dlg:getChildByName("chat_content_arena")
	arg_44_0.vars.chat_only = false
	arg_44_0.vars.sections = {}
	
	if (arg_44_0.last_section == "clan" or arg_44_0.last_section == "clan_chatonly") and not Account:getClanId() then
		arg_44_0.last_section = nil
	end
	
	if arg_44_0.last_section == "clan_chatonly" then
		arg_44_0.last_section = "clan"
	end
	
	local var_44_7 = arg_44_3.section or arg_44_0.last_section or "public"
	
	arg_44_0:setSection(var_44_7, to_n(60))
	arg_44_0:updateBroadcastButton(true)
	arg_44_0:updateOpacityButton()
	arg_44_0:updateConnectionState()
	arg_44_0:updateChannelName()
	
	if var_44_6 then
		arg_44_0.vars.arena_node = arg_44_0.vars.dlg:getChildByName("n_arena")
	else
		eff_slide_in(arg_44_0.vars.dlg, "chat_content", 120, 0, false, -100)
		eff_slide_in(arg_44_0.vars.dlg, "n_category", 120, 0, false, -100)
		eff_slide_in(arg_44_0.vars.dlg, "n_chatview", 120, 50, false, -700)
		eff_slide_in(arg_44_0.vars.dlg, "n_closed_base", 120, 0, false, -700)
	end
	
	SoundEngine:play("event:/ui/top_bar/quick_menu_on")
	arg_44_0:resetChatNotification()
end

function ChatMain.onEnterForground(arg_47_0)
	ChatSock:onEnterForground()
end

function ChatMain.onEnterBackground(arg_48_0)
	ChatSock:onEnterBackground()
end

function ChatMain.Poll(arg_49_0)
	ChatSock:Poll()
	
	if arg_49_0:isVisible() then
		arg_49_0:updateInputTextFieldSize()
	end
	
	ChatMBox:update()
	ChatBanUser:update()
end

function ChatMain.updateInputTextFieldSize(arg_50_0)
	if arg_50_0.vars.input and get_cocos_refid(arg_50_0.vars.input.ctrl) then
		local var_50_0 = arg_50_0.vars.input.ctrl
		local var_50_1 = tolua.cast(var_50_0:getVirtualRenderer(), "cc.Label"):getStringNumLines()
		
		if arg_50_0.vars.input.numlines ~= var_50_1 then
			arg_50_0.vars.input.numlines = var_50_1
			
			local var_50_2 = table.clone(arg_50_0.vars.input.content_size)
			
			var_50_2.height = var_50_2.height + (var_50_1 - 1) * 25
			
			arg_50_0.vars.input.ctrl:setContentSize(var_50_2)
			
			local var_50_3 = table.clone(arg_50_0.vars.input.bg_content_size)
			
			var_50_3.height = var_50_3.height + (var_50_1 - 1) * 20
			
			arg_50_0.vars.input.bg_ctrl:setContentSize(var_50_3)
		end
	end
end

DEBUG.CHAT_CONNECTING_LAYER_SHOW = nil

function ChatMain.updateConnectionState(arg_51_0)
	if arg_51_0.vars and get_cocos_refid(arg_51_0.vars.dlg) then
		local var_51_0 = arg_51_0.vars.dlg:getChildByName("n_closed")
		local var_51_1 = DEBUG.CHAT_CONNECTING_LAYER_SHOW or not ChatSock:is_connected()
		
		if var_51_0 then
			var_51_0:setVisible(var_51_1)
		end
		
		if_set_visible(arg_51_0.vars.dlg, "net_waiting", var_51_1)
		
		if var_51_1 then
			if_set_color(arg_51_0.vars.dlg, "RIGHT", cc.c3b(80, 80, 80))
			
			if not UIAction:Find("chat_net_waiting1") and not UIAction:Find("chat_net_waiting2") then
				local var_51_2 = var_51_0:getChildByName("img_1")
				local var_51_3 = var_51_0:getChildByName("img_2")
				
				var_51_2:setVisible(false)
				var_51_3:setVisible(true)
				UIAction:Add(LOOP(SEQ(DELAY(500), SHOW(true), DELAY(500), SHOW(false))), var_51_2, "chat_net_waiting1")
				UIAction:Add(LOOP(SEQ(DELAY(500), SHOW(false), DELAY(500), SHOW(true))), var_51_3, "chat_net_waiting2")
			else
				UIAction:Remove("chat_net_waiting1")
				UIAction:Remove("chat_net_waiting2")
			end
		else
			if_set_color(arg_51_0.vars.dlg, "RIGHT", cc.c3b(255, 255, 255))
			UIAction:Remove("chat_net_waiting1")
			UIAction:Remove("chat_net_waiting2")
		end
	end
end

function ChatMain.setCurrentPublicChannel(arg_52_0, arg_52_1, arg_52_2)
	if arg_52_0:isVisible() then
		arg_52_0:updateChannelName()
	end
	
	print(">> chat_join_channel ", arg_52_1)
	
	if arg_52_2 then
		arg_52_0:addChatText(T("chat_join_channel", {
			channel = arg_52_1
		}), {
			section = "public",
			style = "broadcast",
			ignore_filter = true
		})
	end
end

function ChatMain.updateChannelName(arg_53_0)
	if not arg_53_0:isVisible() then
		return 
	end
	
	local var_53_0 = ChatSock:getPublicChannelId()
	
	if arg_53_0.vars.cur_section_name == "public" then
		if_set(arg_53_0.vars.dlg, "txt_cur_channel", T("ui_chat_channel_num", {
			channel = tostring(var_53_0 or "")
		}))
	elseif arg_53_0.vars.cur_section_name == "arena" then
		if_set(arg_53_0.vars.dlg, "txt_cur_channel", T("pvp_rta_mock_rta_title"))
	else
		if_set(arg_53_0.vars.dlg, "txt_cur_channel", T("ui_chat_channel_clan"))
	end
	
	if_set_visible(arg_53_0.vars.dlg, "icon_favorite", var_53_0 == ChatFavorite:getFavoriteChannel() and arg_53_0.vars.cur_section_name == "public")
end

function ChatMain.updateNewChatCount(arg_54_0)
	if not arg_54_0.vars then
		return 
	end
	
	local var_54_0 = arg_54_0.vars.cur_section_name
	local var_54_1 = ChatMBox:getUnseenMsgCount()
	
	if_set_visible(arg_54_0.vars.dlg, "noti_friends", (var_54_0 ~= "clan" or var_54_0 ~= "clan_chatonly") and var_54_1 > 0)
	if_set(arg_54_0.vars.dlg, "count_friends", var_54_1)
end

function ChatMain.updateMemberCount(arg_55_0, arg_55_1, arg_55_2)
	if arg_55_0.vars and get_cocos_refid(arg_55_0.vars.arena_node) then
		if_set(arg_55_0.vars.arena_node, "t_count", tostring(arg_55_1) .. "/" .. tostring(arg_55_2))
	end
end

function ChatMain.setSection(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0.vars then
		return 
	end
	
	if arg_56_1 == arg_56_0.vars.cur_section_name then
		return 
	end
	
	if not get_cocos_refid(arg_56_0.vars.dlg) then
		return 
	end
	
	if not arg_56_0.vars.sections[arg_56_1] then
		local var_56_0 = ChatSection:create(arg_56_0.vars.dlg, arg_56_1, arg_56_2)
		
		arg_56_0.vars.sections[arg_56_1] = var_56_0
		
		local var_56_1 = arg_56_0.vars.chat_content:getContentSize().height
		
		if arg_56_1 == "arena" then
			var_56_1 = arg_56_0.vars.chat_content_arena:getContentSize().height - 3
		end
		
		var_56_0:setHeight(var_56_1)
		
		if arg_56_1 == "clan" or arg_56_1 == "clan_chatonly" then
			var_56_0:loadCache()
		end
	end
	
	if arg_56_0.vars.cur_section then
		arg_56_0.vars.cur_section:setVisible(false)
	end
	
	arg_56_0.vars.cur_section = arg_56_0.vars.sections[arg_56_1]
	arg_56_0.vars.cur_section_name = arg_56_1
	
	arg_56_0.vars.cur_section:setVisible(true)
	arg_56_0:refreshNotice()
	
	local var_56_2 = arg_56_0.vars.dlg.c.n_category.c.selected
	local var_56_3 = arg_56_1
	
	if var_56_3 == "clan_chatonly" then
		var_56_3 = "clan"
	end
	
	var_56_2:setPositionX(arg_56_0.vars.dlg.c.n_category.c["n_" .. var_56_3]:getPositionX())
	if_set_visible(arg_56_0.vars.dlg, "btn_favorite", arg_56_1 == "public")
	if_set_visible(arg_56_0.vars.dlg, "btn_channel", arg_56_1 == "public")
	if_set_visible(arg_56_0.vars.dlg, "n_arena", arg_56_1 == "arena")
	if_set_visible(arg_56_0.vars.dlg, "n_onlychat", arg_56_0.vars.cur_section_name == "clan" or arg_56_0.vars.cur_section_name == "clan_chatonly")
	if_set_visible(arg_56_0.vars.dlg, "btn_onlychat_off", not arg_56_0.vars.chat_only)
	if_set_visible(arg_56_0.vars.dlg, "btn_onlychat_on", arg_56_0.vars.chat_only)
	
	if var_56_3 == "clan" then
		ChatMBox:resetUnseenMsgCount()
		TopBarNew:updateNewChatCount()
		BattleTopBar:updateNewChatCount()
	end
	
	arg_56_0:updateChannelName()
	arg_56_0:updateNewChatCount()
	arg_56_0:updateChatNodeOpacity()
	
	arg_56_0.last_section = arg_56_1
end

function ChatMain.arrangeSections(arg_57_0)
	local var_57_0 = 0
	local var_57_1 = arg_57_0.vars.chat_content:getContentSize().height
	local var_57_2 = 0
	local var_57_3
	
	for iter_57_0, iter_57_1 in pairs(arg_57_0.vars.sections) do
		if iter_57_1.wnd:isVisible() then
			var_57_2 = var_57_2 + iter_57_1.weight
			var_57_3 = iter_57_1
		end
	end
	
	for iter_57_2, iter_57_3 in pairs(arg_57_0.vars.sections) do
		if iter_57_3.wnd:isVisible() then
			local var_57_4 = to_n(var_57_1 * (iter_57_3.weight / var_57_2))
			
			iter_57_3.wnd:setPositionY(var_57_0)
			
			if iter_57_3.wnd:isVisible() then
				var_57_0 = var_57_0 + var_57_4
			end
			
			iter_57_3:setHeight(var_57_4, iter_57_3 ~= var_57_3)
		end
	end
end

function ChatMain.getCurSectionName(arg_58_0)
	return arg_58_0.vars.cur_section_name
end

function ChatMain.addChatText(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = {
		section = arg_59_2.section,
		msg_doc = {
			ignore_notify = true,
			section = arg_59_2.section,
			style = arg_59_2.style,
			ignore_filter = arg_59_2.ignore_filter,
			text = arg_59_1
		}
	}
	
	arg_59_0:addChatData(var_59_0)
	
	if not arg_59_0:isVisible() then
		arg_59_0:onCastToolTip(var_59_0)
	end
end

function ChatMain.addChatData(arg_60_0, arg_60_1)
	if arg_60_0:isIgnoreChatUser(arg_60_1.user_id) then
		return 
	end
	
	local var_60_0 = arg_60_1.section or "public"
	
	ChatMBox:insert(var_60_0, arg_60_1)
	
	if not arg_60_0.vars or not arg_60_0.vars.sections or not arg_60_0.vars.dlg then
		return 
	end
	
	if arg_60_0:isVisible() and (arg_60_0.vars.cur_section_name == "clan" or arg_60_0.vars.cur_section_name == "clan_chatonly") then
		ChatMBox:resetUnseenMsgCount()
	end
	
	arg_60_0:updateNewChatCount()
	
	if var_60_0 == "clan" and arg_60_0.vars.chat_only then
		var_60_0 = "clan_chatonly"
	end
	
	local var_60_1 = true
	local var_60_2 = tonumber(arg_60_1.user_id)
	
	if var_60_2 and var_60_2 == tonumber(Account:getUserId()) then
		var_60_1 = false
	end
	
	if not SysAction:Find("chat.sync_renderer") then
		SysAction:AddAsync(SEQ(DELAY(100), CALL(function()
			local var_61_0 = arg_60_0.vars.sections[var_60_0]
			
			if var_61_0 and var_61_0:isVisible() then
				var_61_0:sync(var_60_1)
			end
		end)), {}, "chat.sync_renderer")
	end
end

function ChatMain.OnKeyUp(arg_62_0, arg_62_1, arg_62_2)
	if ContentDisable:byAlias("chat") then
		return 
	end
	
	if UIAction:Find("block") then
		return 
	end
	
	if arg_62_1 == cc.KeyCode.KEY_F5 then
		return 
	end
	
	if ChatMain:isVisible() then
		if (arg_62_1 == cc.KeyCode.KEY_ENTER or arg_62_1 == 10) and arg_62_0.vars.dlg.c.input:isFocused() then
			ChatMain:send()
			
			return true
		end
	else
		local var_62_0 = SceneManager:getCurrentSceneName()
		
		if var_62_0 == "title" or var_62_0 == "battle" and Battle:isReplayMode() then
			return 
		end
		
		if SceneManager:isAbsent() then
			return 
		end
		
		if not SAVE:isTutorialFinished() then
			return 
		end
		
		if UnitMain:getMode() == "Zoom" then
			return 
		end
		
		if CollectionImageViewer:isOpen() then
			return 
		end
		
		if is_playing_story() then
			return 
		end
		
		local var_62_1 = SceneManager:getRunningRootScene()
		
		if get_cocos_refid(var_62_1) then
			if SceneManager:getCurrentSceneName() == "battle" then
				if not get_cocos_refid(var_62_1:findChildByName("inbattle_topbar")) then
					return 
				end
			elseif not get_cocos_refid(var_62_1:findChildByName("top_bar")) then
				return 
			end
		end
		
		if arg_62_1 == cc.KeyCode.KEY_ENTER or arg_62_1 == 10 then
			ChatMain:show(SceneManager:getRunningPopupScene(), true)
			
			return true
		end
	end
end

function ChatMain.setBroadcastOff(arg_63_0, arg_63_1)
	arg_63_0.gacha_bro_off = arg_63_1
	
	SAVE:setUserDefaultData("option.gacha_bro_off", arg_63_0.gacha_bro_off or false)
	arg_63_0:updateBroadcastButton()
end

function ChatMain.updateBroadcastButton(arg_64_0, arg_64_1)
	if arg_64_1 or arg_64_0.gacha_bro_off == nil then
		arg_64_0.gacha_bro_off = SAVE:getOptionData("option.gacha_bro_off", default_options.gacha_bro_off)
	end
	
	if_set_visible(arg_64_0.vars.dlg, "btn_broadcast_on", not arg_64_0.gacha_bro_off)
	if_set_visible(arg_64_0.vars.dlg, "btn_broadcast_off", arg_64_0.gacha_bro_off)
end

function ChatMain.showBroadcastSettingDlg(arg_65_0)
	if not arg_65_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_65_0.vars.setting_dlg) then
		return 
	end
	
	local var_65_0 = load_dlg("chat_filter", true, "wnd", function()
		arg_65_0:closeBroadcastSetting()
	end)
	
	arg_65_0.vars.setting_dlg = var_65_0
	
	SceneManager:getRunningPopupScene():addChild(arg_65_0.vars.setting_dlg)
	arg_65_0.vars.setting_dlg:bringToFront()
	
	arg_65_0.setting_mode = arg_65_0.setting_mode or "public"
	
	arg_65_0:updateBroadcastSettingUIMode(arg_65_0.setting_mode)
end

local function var_0_7()
	local var_67_0 = SAVE:getUserDefaultData("chat_filter_property", "")
	
	if var_67_0 and var_67_0 ~= "" then
		ChatMain.chat_filter = json.decode(var_67_0) or {}
	else
		ChatMain.chat_filter = {}
	end
end

function ChatMain.setBroadcastFilter(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_0.chat_filter then
		var_0_7()
	end
	
	if arg_68_0.chat_filter then
		arg_68_0.chat_filter[arg_68_1] = arg_68_2
		
		local var_68_0 = json.encode(arg_68_0.chat_filter)
		
		SAVE:setUserDefaultData("chat_filter_property", var_68_0)
	end
end

function ChatMain.getBroadcastFilter(arg_69_0, arg_69_1)
	if not arg_69_0.chat_filter then
		var_0_7()
	end
	
	if arg_69_0.chat_filter then
		if string.starts(arg_69_1, "keyword_") then
			return arg_69_0.chat_filter[arg_69_1]
		else
			return arg_69_0.chat_filter[arg_69_1] == nil or arg_69_0.chat_filter[arg_69_1]
		end
	end
end

function ChatMain.getFilterList(arg_70_0, arg_70_1)
	local var_70_0 = {
		hero_summon = {
			text = "chat_notice_check_5hero",
			key = "noti_hero_summon_"
		},
		arti_summon = {
			text = "chat_notice_check_5artifact",
			key = "noti_arti_summon_"
		},
		replay = {
			text = "chat_notice_share_replay",
			key = "noti_replay_share_"
		},
		clan_promote = {
			text = "chat_notice_check_clanprchat",
			key = "noti_clan_promote_"
		},
		general = {
			text = "chat_notice_check_chat",
			key = "noti_general_chat_"
		}
	}
	local var_70_1 = {}
	
	local function var_70_2(arg_71_0)
		for iter_71_0, iter_71_1 in pairs(arg_71_0) do
			var_70_1[iter_71_0] = var_70_0[iter_71_1]
		end
	end
	
	if arg_70_1 == "public" then
		var_70_2({
			"hero_summon",
			"arti_summon",
			"clan_promote",
			"general"
		})
	elseif arg_70_1 == "clan" then
		var_70_2({
			"hero_summon",
			"arti_summon",
			"replay",
			"general"
		})
	end
	
	if false then
	end
	
	return var_70_1
end

function ChatMain.toggleBroadcastFilter(arg_72_0, arg_72_1)
	if not arg_72_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_72_0.vars.setting_dlg) then
		return 
	end
	
	local var_72_0 = arg_72_0:getFilterList(arg_72_0.setting_mode)
	
	if arg_72_1 == -1 then
		local var_72_1 = arg_72_0.vars.setting_dlg:findChildByName("checkbox_all"):isSelected()
		
		for iter_72_0 = 1, #var_72_0 do
			local var_72_2 = var_72_0[iter_72_0].key .. arg_72_0.setting_mode
			
			arg_72_0:setBroadcastFilter(var_72_2, not var_72_1)
		end
	else
		if arg_72_0.setting_mode == "public" and arg_72_1 == 6 then
			arg_72_1 = arg_72_1 + 1
		end
		
		local var_72_3 = var_72_0[arg_72_1].key .. arg_72_0.setting_mode
		local var_72_4 = arg_72_0:getBroadcastFilter(var_72_3) or false
		
		arg_72_0:setBroadcastFilter(var_72_3, not var_72_4)
	end
	
	arg_72_0:updateBroadcastSettingUIMode(arg_72_0.setting_mode)
end

function ChatMain.updateBroadcastSettingUIMode(arg_73_0, arg_73_1)
	if not arg_73_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_73_0.vars.setting_dlg) then
		return 
	end
	
	arg_73_0.setting_mode = arg_73_1
	arg_73_0.vars.setting_dlg.mode = arg_73_1
	
	local var_73_0 = arg_73_0:getFilterList(arg_73_1)
	local var_73_1 = arg_73_0.vars.setting_dlg:findChildByName("n_category")
	
	if_set_visible(var_73_1:findChildByName("btn_public"), "bg_tab", arg_73_1 == "public")
	if_set_visible(var_73_1:findChildByName("btn_clan"), "bg_tab", arg_73_1 == "clan" or arg_73_1 == "clan_chatonly")
	if_set_visible(var_73_1:findChildByName("btn_keyword"), "bg_tab", arg_73_1 == "keyword")
	
	if arg_73_0.setting_mode == "keyword" then
		if_set_visible(arg_73_0.vars.setting_dlg, "n_check_box", false)
		if_set_visible(arg_73_0.vars.setting_dlg, "n_keyword", true)
		
		for iter_73_0 = 1, 5 do
			local var_73_2 = arg_73_0:getBroadcastFilter("keyword_" .. iter_73_0)
			local var_73_3 = arg_73_0.vars.setting_dlg:findChildByName("n_keyword" .. iter_73_0)
			
			if var_73_2 and var_73_2 ~= "" then
				if_set_visible(var_73_3, "btn_input", false)
				if_set_visible(var_73_3, "n_registered", true)
				if_set(var_73_3, "label_keyword", var_73_2)
			else
				if_set_visible(var_73_3, "btn_input", true)
				if_set_visible(var_73_3, "n_registered", false)
			end
		end
	elseif arg_73_0.setting_mode == "public" or arg_73_0.setting_mode == "clan" or arg_73_0.setting_mode == "clan_chatonly" then
		if_set_visible(arg_73_0.vars.setting_dlg, "n_check_box", true)
		if_set_visible(arg_73_0.vars.setting_dlg, "n_keyword", false)
		
		local var_73_4 = arg_73_0.vars.setting_dlg:findChildByName("n_check_box")
		
		local function var_73_5(arg_74_0, arg_74_1, arg_74_2)
			local var_74_0 = var_73_4:findChildByName("n_check_box_" .. arg_74_0)
			local var_74_1 = arg_74_1 and arg_73_0:getBroadcastFilter(arg_74_1)
			
			if_set(var_74_0, "label", arg_74_2)
			var_74_0:findChildByName("checkbox_" .. arg_74_0):setSelected(var_74_1)
			
			return var_74_1
		end
		
		for iter_73_1 = 1, 9 do
			local var_73_6 = var_73_4:getChildByName("n_check_box_" .. iter_73_1)
			
			if not get_cocos_refid(var_73_6) then
				break
			end
			
			var_73_6:setVisible(var_73_0[iter_73_1] ~= nil)
		end
		
		local var_73_7 = true
		local var_73_8 = 1
		
		for iter_73_2, iter_73_3 in pairs(var_73_0) do
			local var_73_9 = iter_73_3.key .. arg_73_1
			
			var_73_7 = var_73_5(var_73_8, var_73_9, T(iter_73_3.text)) and var_73_7
			var_73_8 = var_73_8 + 1
		end
		
		local var_73_10 = var_73_4:findChildByName("n_check_box_all")
		
		var_73_10:findChildByName("checkbox_all"):setSelected(var_73_7)
		if_set_visible(var_73_10, "select_all", true)
		var_73_10:findChildByName("label"):setTextColor(var_73_7 and tocolor("#64CB00") or tocolor("#888888"))
	end
end

function ChatMain.closeBroadcastSetting(arg_75_0)
	if not arg_75_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_75_0.vars.setting_dlg) then
		return 
	end
	
	BackButtonManager:pop("chat_filter")
	arg_75_0.vars.setting_dlg:removeFromParent()
	
	arg_75_0.vars.setting_dlg = nil
end

function ChatMain.onInputNotiKeyword(arg_76_0, arg_76_1)
	if not arg_76_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_76_0.vars.setting_dlg) then
		return 
	end
	
	local var_76_0 = arg_76_0:getBroadcastFilter("keyword_" .. arg_76_1) or ""
	
	arg_76_0.vars.keyword_info = {
		prev_text = var_76_0
	}
	
	local function var_76_1()
		if arg_76_0.vars.keyword_info.text == arg_76_0.vars.keyword_info.prev_text then
			return 
		end
		
		if check_abuse_filter(arg_76_0.vars.keyword_info.text, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		local var_77_0 = arg_76_0.vars.keyword_info.text
		local var_77_1 = string.trim(var_77_0)
		
		arg_76_0:setBroadcastFilter("keyword_" .. arg_76_1, var_77_1)
		arg_76_0:updateBroadcastSettingUIMode("keyword")
	end
	
	local var_76_2, var_76_3 = Dialog:openInputBox(arg_76_0, var_76_1, {
		custom_txt_input_limit = "input_default_limit_sensitive",
		max_limit = 12,
		title = T("chat_notice_keyward_input"),
		btn_yes_txt = T("ui_msgbox_ok"),
		info = arg_76_0.vars.keyword_info
	})
	
	arg_76_0.vars.setting_dlg:addChild(var_76_2)
end

function ChatMain.onCancelNotikeyword(arg_78_0, arg_78_1)
	if not arg_78_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_78_0.vars.setting_dlg) then
		return 
	end
	
	arg_78_0:setBroadcastFilter("keyword_" .. arg_78_1, "")
	arg_78_0:updateBroadcastSettingUIMode("keyword")
end

function ChatMain.setOpacityOn(arg_79_0, arg_79_1)
	arg_79_0.opacity_on = arg_79_1
	
	SAVE:setUserDefaultData("chat.opacity_on", arg_79_0.opacity_on or false)
	arg_79_0:updateOpacityButton()
	arg_79_0:updateChatNodeOpacity()
end

function ChatMain.getOpacityOn(arg_80_0)
	return arg_80_0.opacity_on
end

function ChatMain.updateOpacityButton(arg_81_0)
	if arg_81_0.opacity_on == nil then
		arg_81_0.opacity_on = SAVE:getOptionData("chat.opacity_on", false)
	end
	
	if_set_visible(arg_81_0.vars.dlg, "btn_opacity_off", not arg_81_0.opacity_on)
	if_set_visible(arg_81_0.vars.dlg, "btn_opacity_on", arg_81_0.opacity_on)
	
	local var_81_0 = ""
	local var_81_1 = arg_81_0.opacity_on and "img/_box_big_gold_50.png" or "img/_box_big_gold_90.png"
	
	if_set_sprite(arg_81_0.vars.dlg, "bg", var_81_1)
end

function ChatMain.updateChatNodeOpacity(arg_82_0)
	if not arg_82_0.vars or not arg_82_0.vars.cur_section then
		return 
	end
	
	if arg_82_0.opacity_on == nil then
		arg_82_0.opacity_on = SAVE:getOptionData("chat.opacity_on", false)
	end
	
	local var_82_0 = arg_82_0.vars.cur_section.nodes
	
	for iter_82_0, iter_82_1 in pairs(var_82_0) do
		if get_cocos_refid(iter_82_1) and type(iter_82_1.setOpacityOn) == "function" then
			iter_82_1:setOpacityOn(arg_82_0.opacity_on)
		end
	end
end

function ChatMain.setIgnoreChatUser(arg_83_0, arg_83_1, arg_83_2)
	if not arg_83_1 then
		return 
	end
	
	if not arg_83_0.vars then
		arg_83_0.vars = {}
	end
	
	if arg_83_2 then
		ChatBanUser:insert(arg_83_1)
	else
		ChatBanUser:delete(arg_83_1)
	end
end

function ChatMain.isIgnoreChatUser(arg_84_0, arg_84_1)
	return ChatBanUser:isBanUser(arg_84_1) ~= nil
end

function ChatMain.onPublicJoin(arg_85_0, arg_85_1, arg_85_2)
	arg_85_0:updateConnectionState()
	
	if arg_85_2 then
		arg_85_0:setCurrentPublicChannel(arg_85_1, true)
	end
end

function ChatMain.onClanJoin(arg_86_0, arg_86_1)
	arg_86_0:updateConnectionState()
	ChatMBox:init(AccountData.id, AccountData.clan_id)
end

function ChatMain.onVolatileMsg(arg_87_0, arg_87_1, arg_87_2)
	if arg_87_1 == "clan" then
		local var_87_0 = tostring(arg_87_2.type)
		
		if string.starts(var_87_0, "heritage") then
			LotaNetworkSystem:receiveVolatileMsg(arg_87_2)
		end
	end
	
	if false then
	end
end

function ChatMain.setPublicNotices(arg_88_0, arg_88_1)
	arg_88_0.public_notices = arg_88_1
end

function ChatMain.getPublicNotices(arg_89_0)
	return arg_89_0.public_notices
end

function ChatMain.setChatOnly(arg_90_0, arg_90_1)
	if not arg_90_0.vars then
		return 
	end
	
	arg_90_0.vars.chat_only = arg_90_1
end

function ChatMain.getLastSection(arg_91_0)
	return arg_91_0.last_section
end

function ChatMain.getLastInputText(arg_92_0)
	return arg_92_0.last_input_text
end

function ChatMain.setRepeatMode(arg_93_0, arg_93_1)
	if not arg_93_0.vars or not get_cocos_refid(arg_93_0.vars.dlg) then
		return 
	end
	
	arg_93_0.repeat_mode = arg_93_1
	
	if arg_93_0.repeat_mode then
		local var_93_0 = arg_93_0.vars.dlg:getChildByName("input")
		
		if get_cocos_refid(var_93_0) then
			arg_93_0.last_input_text = var_93_0:getString()
			
			var_93_0:detachWithIME()
		end
	end
end

function ChatMain.isRepeatMode(arg_94_0)
	return arg_94_0.repeat_mode and arg_94_0:isVisible()
end

local var_0_8 = 5

function MsgHandler.share_unit_chat(arg_95_0)
	if arg_95_0.res == "clan_not_found" then
		Dialog:msgBox(T("err_message_knights_channel_unavailable"), {
			handler = function()
				SceneManager:nextScene(arg_95_0.next_scene or "lobby")
				SceneManager:resetSceneFlow()
			end
		})
	else
		balloon_message_with_sound("msg_share_complete")
	end
end

function ChatMain.requestShareUnit(arg_97_0, arg_97_1, arg_97_2)
	if not arg_97_0.last_share_unit_uid then
		arg_97_0.last_share_unit_uid = 0
	end
	
	if not arg_97_0.share_count then
		arg_97_0.share_count = 0
	end
	
	local var_97_0, var_97_1 = arg_97_0:canShareItem(arg_97_0.last_share_unit_uid, arg_97_1)
	
	if not var_97_0 then
		return 
	end
	
	arg_97_0.share_count = arg_97_0.share_count + 1
	
	if arg_97_0.share_count >= var_0_8 then
		arg_97_0.share_count = 0
	end
	
	arg_97_0.last_share_unit_uid = arg_97_1
	
	local var_97_2
	local var_97_3 = false
	local var_97_4 = Account:getUnit(arg_97_1)
	
	if var_97_4 and var_97_4:isGrowthBoostRegistered() then
		var_97_3 = true
		
		local var_97_5 = GrowthBoost:getInfo() or {}
		
		for iter_97_0, iter_97_1 in pairs(var_97_5) do
			if iter_97_1.reg_uid and iter_97_1.reg_uid == arg_97_1 then
				var_97_2 = iter_97_1.unlock_level or 0
				
				break
			end
		end
	end
	
	print("share_unit_chat : " .. arg_97_2)
	query("share_unit_chat", {
		unit_id = arg_97_1,
		section = arg_97_2,
		stored_item = var_97_1,
		growth_boost = var_97_3,
		gb_level = var_97_2
	})
end

function MsgHandler.share_equip_chat(arg_98_0)
	if arg_98_0.res == "clan_not_found" then
		Dialog:msgBox(T("err_message_knights_channel_unavailable"), {
			handler = function()
				SceneManager:nextScene(arg_98_0.next_scene or "lobby")
				SceneManager:resetSceneFlow()
			end
		})
	else
		balloon_message_with_sound("msg_share_complete")
	end
end

function ChatMain.requestShareEquip(arg_100_0, arg_100_1, arg_100_2)
	if not arg_100_1 then
		return 
	end
	
	if not arg_100_0.last_share_equip_uid then
		arg_100_0.last_share_equip_uid = 0
	end
	
	if not arg_100_0.share_count then
		arg_100_0.share_count = 0
	end
	
	local var_100_0, var_100_1 = arg_100_0:canShareItem(arg_100_0.last_share_equip_uid, arg_100_1, true)
	
	if not var_100_0 then
		return 
	end
	
	arg_100_0.share_count = arg_100_0.share_count + 1
	
	if arg_100_0.share_count >= var_0_8 then
		arg_100_0.share_count = 0
	end
	
	arg_100_0.last_share_equip_uid = arg_100_1
	
	print("share_equip_chat : " .. arg_100_2)
	query("share_equip_chat", {
		target = arg_100_1,
		section = arg_100_2,
		stored_item = var_100_1
	})
end

function ChatMain.canShareItem(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	if Account:getLevel() < 10 then
		balloon_message_with_sound("err_msg_share_rank_limit")
		
		return 
	end
	
	if ContentDisable:byAlias("content_switch_disable_hero_equip_share") then
		balloon_message_with_sound("msg_contents_disable_hero_equip_share")
		
		return 
	end
	
	local var_101_0 = SceneManager:getCurrentSceneName() == "equip_storage" and 1 or nil
	
	if arg_101_3 then
		local var_101_1
		
		if var_101_0 then
			var_101_1 = Account:getEquipFromStorage(arg_101_2)
		else
			var_101_1 = Account:getEquip(arg_101_2)
		end
		
		if not var_101_1 then
			return 
		elseif var_101_1:isArtifact() then
			return 
		elseif var_101_1:isExclusive() then
			balloon_message_with_sound("err_msg_exclusive_equip_share_unavailable")
			
			return 
		elseif var_101_1.isEquip and var_101_1.db and var_101_1.db.item_level and var_101_1.db.item_level < 70 then
			balloon_message_with_sound("err_msg_share_equip_level_limit")
			
			return 
		end
	end
	
	if not arg_101_0.last_share_time then
		arg_101_0.last_share_time = os.time()
		arg_101_0.share_block = false
		
		return true, var_101_0
	end
	
	if arg_101_0.share_block and arg_101_0.block_start_time then
		if 180 <= os.time() - arg_101_0.block_start_time then
			arg_101_0.share_block = false
			arg_101_0.block_start_time = nil
		else
			balloon_message_with_sound("err_msg_share_spam_limit")
			
			return 
		end
	end
	
	local var_101_2 = 5
	local var_101_3 = 15
	
	if not arg_101_0.block_count then
		arg_101_0.block_count = 0
	end
	
	local var_101_4 = os.time() - arg_101_0.last_share_time
	
	if not arg_101_0.first_count or arg_101_0.share_count <= 0 then
		arg_101_0.first_count = os.time()
	end
	
	if arg_101_0.share_count >= var_0_8 - 1 then
		if os.time() - arg_101_0.first_count <= 25 then
			balloon_message_with_sound("err_msg_share_spam_limit")
			
			arg_101_0.share_block = true
			arg_101_0.block_start_time = os.time()
			
			return 
		else
			arg_101_0.first_count = os.time()
		end
	end
	
	if arg_101_1 == arg_101_2 and var_101_4 < 15 then
		balloon_message_with_sound("err_msg_share_frequent_limit")
		
		return 
	end
	
	arg_101_0.last_share_time = os.time()
	arg_101_0.share_block = false
	
	return true, var_101_0
end

ChatEmojiPopup = {}

copy_functions(ScrollView, ChatEmojiPopup)

function ChatEmojiPopup.show(arg_102_0)
	if arg_102_0:isVisible() and not arg_102_0:isRepeatMode() then
		return 
	end
	
	if (GAME_CONTENT_VARIABLE.possible_chat_rank or 10) > AccountData.level then
		balloon_message_with_sound("ui_input_chat_condition")
		
		return 
	end
	
	local var_102_0 = load_dlg("chat_emoji_tip", nil, "wnd", function()
		arg_102_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(var_102_0)
	var_102_0:setLocalZOrder(999999)
	
	arg_102_0.vars = {}
	arg_102_0.vars.wnd = var_102_0
	
	local var_102_1 = cc.CSLoader:createNode("wnd/chat_emoji_tip_item.csb"):getContentSize()
	
	arg_102_0.vars.scrollview = var_102_0:getChildByName("ScrollView")
	
	arg_102_0:initScrollView(arg_102_0.vars.scrollview, var_102_1.width, var_102_1.height)
	
	arg_102_0.vars.db = EmojiManager:getMyEmojisForChat()
	
	table.sort(arg_102_0.vars.db, function(arg_104_0, arg_104_1)
		return tonumber(arg_104_0.sort) < tonumber(arg_104_1.sort)
	end)
	arg_102_0:createScrollViewItems(arg_102_0.vars.db)
end

function ChatEmojiPopup.close(arg_105_0)
	if not arg_105_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_105_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("chat_emoji_tip")
	arg_105_0:clearScrollViewItems()
	arg_105_0.vars.wnd:removeFromParent()
	
	arg_105_0.vars = nil
end

function ChatEmojiPopup.getScrollViewItem(arg_106_0, arg_106_1)
	local var_106_0 = load_control("wnd/chat_emoji_tip_item.csb")
	
	arg_106_0:updateItemUI(var_106_0, arg_106_1)
	
	return var_106_0
end

function ChatEmojiPopup.updateItemUI(arg_107_0, arg_107_1, arg_107_2)
	if_set_sprite(arg_107_1, "icon", "emoticon_chat/" .. arg_107_2.res .. ".png")
end

function ChatEmojiPopup.getInfoById(arg_108_0, arg_108_1)
	for iter_108_0, iter_108_1 in pairs(arg_108_0.ScrollViewItems) do
		if arg_108_1 == iter_108_1.item.id then
			return iter_108_1
		end
	end
end

function ChatEmojiPopup.getIdxById(arg_109_0, arg_109_1)
	for iter_109_0, iter_109_1 in pairs(arg_109_0.ScrollViewItems) do
		if arg_109_1 == iter_109_1.item.id then
			return iter_109_0
		end
	end
end

function ChatEmojiPopup.onSelectScrollViewItem(arg_110_0, arg_110_1, arg_110_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if ChatMain:sendEmoji(arg_110_2.item.res) then
		arg_110_0:close()
	end
end

function ChatEmojiPopup.isVisible(arg_111_0)
	if not arg_111_0.vars or not get_cocos_refid(arg_111_0.vars.wnd) then
		return 
	end
	
	return arg_111_0.vars.wnd:isVisible()
end

function ChatEmojiPopup.setRepeatMode(arg_112_0, arg_112_1)
	if not arg_112_0.vars or not get_cocos_refid(arg_112_0.vars.wnd) then
		return 
	end
	
	arg_112_0.repeat_mode = arg_112_1
end

function ChatEmojiPopup.isRepeatMode(arg_113_0)
	return arg_113_0.repeat_mode and arg_113_0.vars
end

RtaEmojiPopup = {}

copy_functions(ChatEmojiPopup, RtaEmojiPopup)

function RtaEmojiPopup.show(arg_114_0)
	if arg_114_0:isVisible() and not arg_114_0:isRepeatMode() then
		return 
	end
	
	local var_114_0 = load_dlg("pvp_emoji_tip", nil, "wnd", function()
		arg_114_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(var_114_0)
	var_114_0:setLocalZOrder(999999)
	
	arg_114_0.vars = {}
	arg_114_0.vars.wnd = var_114_0
	
	arg_114_0.vars.wnd:setPositionX(arg_114_0.vars.wnd:getPositionX() - 170)
	
	local var_114_1 = cc.CSLoader:createNode("wnd/pvp_emoji_item.csb"):getContentSize()
	
	arg_114_0.vars.scrollview = var_114_0:getChildByName("ScrollView")
	
	arg_114_0:initScrollView(arg_114_0.vars.scrollview, var_114_1.width, var_114_1.height)
	
	arg_114_0.vars.db = EmojiManager:getMyEmojisForRTA()
	
	table.sort(arg_114_0.vars.db, function(arg_116_0, arg_116_1)
		return tonumber(arg_116_0.sort) < tonumber(arg_116_1.sort)
	end)
	arg_114_0:createScrollViewItems(arg_114_0.vars.db)
end

function RtaEmojiPopup.getScrollViewItem(arg_117_0, arg_117_1)
	local var_117_0 = load_control("wnd/pvp_emoji_item.csb")
	
	if_set_visible(var_117_0, "btn_emoji", false)
	arg_117_0:updateItemUI(var_117_0, arg_117_1)
	
	return var_117_0
end

function RtaEmojiPopup.updateItemUI(arg_118_0, arg_118_1, arg_118_2)
	if_set_sprite(arg_118_1, "icon_emoji", "emoticon/" .. arg_118_2.name .. ".png")
end

function RtaEmojiPopup.onSelectScrollViewItem(arg_119_0, arg_119_1, arg_119_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	LuaEventDispatcher:dispatchEvent("arena.emogi.res", "push_local", {
		id = arg_119_2.item.id,
		res = arg_119_2.item.res
	})
	arg_119_0:close()
end

ChatSection = {}

function ChatSection.setHeight(arg_120_0, arg_120_1, arg_120_2)
	arg_120_0.scrollview:setContentSize({
		width = arg_120_0.scrollview_sz.width,
		height = arg_120_1
	})
	arg_120_0:arrange(arg_120_2)
end

function ChatSection.create(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
	local var_121_0 = {
		name = arg_121_2,
		weight = arg_121_3
	}
	local var_121_1 = arg_121_1:getChildByName("chat_content")
	local var_121_2 = var_121_1:getContentSize()
	
	copy_functions(ChatSection, var_121_0)
	
	local var_121_3 = load_control("wnd/chat_section.csb", true)
	
	var_121_3:setPosition(var_121_2.width / 2, 0)
	var_121_3:setAnchorPoint(0.5, 0)
	
	local var_121_4 = var_121_3:getChildByName("scrollview")
	
	var_121_0.scrollview_sz = var_121_4:getContentSize()
	var_121_0.wnd = var_121_3
	var_121_0.wnd.section = var_121_0
	
	var_121_1:addChild(var_121_3)
	
	var_121_0.scrollview = var_121_4
	
	var_121_4:removeAllChildren()
	
	var_121_0.scale = 0.75
	var_121_0.line_height = 30 * var_121_0.scale
	var_121_0.line_gap = var_121_0.line_height * 0.6
	var_121_0.node_width = var_121_4:getContentSize().width * (1 / var_121_0.scale)
	var_121_0.nodes = {}
	
	var_121_4:getInnerContainer():setContentSize(var_121_0.scrollview_sz)
	if_set_visible(var_121_0.wnd, "n_notice", false)
	if_set_visible(var_121_0.wnd, "n_notice_public", arg_121_2 == "public")
	if_set_visible(var_121_0.wnd, "n_notice_clan", arg_121_2 == "clan" or arg_121_2 == "clan_chatonly")
	
	if arg_121_2 == "public" then
		upgradeLabelToRichLabel(var_121_0.wnd, "txt_notice_public", true)
	end
	
	if (arg_121_2 == "clan" or arg_121_2 == "clan_chatonly") and Account:getClanId() and Clan:getClanInfo() then
		UIUtil:updateClanEmblem(var_121_0.wnd, Clan:getClanInfo())
	end
	
	return var_121_0
end

function ChatSection.foldSectionNotice(arg_122_0, arg_122_1)
	if_set_visible(arg_122_0.wnd, "n_notice_off", arg_122_1)
	if_set_visible(arg_122_0.wnd, "n_notice_on", not arg_122_1)
end

function ChatSection.addChatData(arg_123_0, arg_123_1, arg_123_2)
	local var_123_0 = 1
	local var_123_1 = arg_123_0:getChatNode(arg_123_1)
	
	if not get_cocos_refid(var_123_1) then
		return 
	end
	
	table.push(arg_123_0.nodes, var_123_1)
	arg_123_0.scrollview:getInnerContainer():addChild(var_123_1)
	
	if not arg_123_2 then
		arg_123_0:arrangeChat()
	end
end

function ChatSection.loadCache(arg_124_0)
	ChatMBox:loadCache(arg_124_0.name)
end

function ChatSection.setNotice(arg_125_0, arg_125_1)
	if not get_cocos_refid(arg_125_0.wnd) then
		return 
	end
	
	arg_125_0.notice = arg_125_1
	
	if_set_visible(arg_125_0.wnd, "n_notice", true)
	
	local var_125_0 = arg_125_0.name
	
	if var_125_0 == "clan_chatonly" then
		var_125_0 = "clan"
	end
	
	local var_125_1 = arg_125_0.wnd:getChildByName("txt_notice_" .. var_125_0)
	
	if not get_cocos_refid(var_125_1) then
		return 
	end
	
	if_set(arg_125_0.wnd, "txt_notice_" .. var_125_0, arg_125_1)
	UIUtil:updateTextWrapMode(var_125_1, arg_125_1, 20)
	
	local var_125_2 = var_125_1:getTextBoxSize().height
	local var_125_3 = var_125_2 - var_125_1:getContentSize().height
	
	if var_125_3 <= 0 then
		return 
	end
	
	local var_125_4 = arg_125_0.wnd:getChildByName("n_notice_" .. var_125_0):getChildByName("btn_notice_close")
	
	if not get_cocos_refid(var_125_4) then
		return 
	end
	
	var_125_1:setContentSize({
		width = var_125_1:getContentSize().width,
		height = var_125_2
	})
	var_125_4:setContentSize({
		width = var_125_4:getContentSize().width,
		height = var_125_4:getContentSize().height + var_125_3
	})
end

function ChatSection.arrangeChat(arg_126_0, arg_126_1)
	local var_126_0 = 0
	local var_126_1 = false
	
	while #arg_126_0.nodes > MAX_CHAT_LINE do
		local var_126_2 = table.remove(arg_126_0.nodes, 1)
		
		if get_cocos_refid(var_126_2) then
			var_126_2:removeFromParent()
			
			var_126_1 = true
		end
	end
	
	local var_126_3 = #arg_126_0.nodes
	
	for iter_126_0 = 1, var_126_3 do
		local var_126_4 = var_126_3 - iter_126_0 + 1
		local var_126_5 = arg_126_0.nodes[var_126_4]
		
		var_126_5:setPositionY(var_126_0)
		
		var_126_0 = var_126_0 + var_126_5.height * var_126_5:getScaleY()
		
		if var_126_4 ~= 1 then
			var_126_0 = var_126_0 + arg_126_0.line_gap
		end
		
		arg_126_0:setChatTime(var_126_5, var_126_5.time)
	end
	
	local var_126_6 = arg_126_0.scrollview:getInnerContainer():getPositionY()
	
	arg_126_0.scrollview:setInnerContainerSize({
		width = arg_126_0.node_width,
		height = var_126_0
	})
	
	if arg_126_1 then
		local var_126_7 = arg_126_0.nodes[var_126_3]
		local var_126_8 = var_126_7.height * var_126_7:getScaleY()
		
		if not var_126_1 and var_126_6 < -50 then
			var_126_6 = var_126_6 - (var_126_8 + arg_126_0.line_gap)
		elseif var_126_1 and var_126_6 < -50 then
			if var_126_0 - arg_126_0.scrollview:getContentSize().height + (var_126_6 - var_126_8) < 0 then
				var_126_6 = -(var_126_0 - arg_126_0.scrollview:getContentSize().height)
			else
				var_126_6 = var_126_6 - (var_126_8 + arg_126_0.line_gap)
			end
		end
		
		if var_126_6 > -50 then
			var_126_6 = 0
		end
		
		arg_126_0.scrollview:getInnerContainer():setPositionY(var_126_6)
	else
		arg_126_0.scrollview:getInnerContainer():setPositionY(0)
	end
end

function ChatSection.clear(arg_127_0)
	while #arg_127_0.nodes > 0 do
		local var_127_0 = table.remove(arg_127_0.nodes, 1)
		
		if get_cocos_refid(var_127_0) then
			var_127_0:removeFromParent()
		end
	end
	
	arg_127_0.scrollview:getInnerContainer():setPositionY(0)
end

function ChatSection.arrange(arg_128_0, arg_128_1)
	arg_128_0:arrangeChat()
end

function ChatSection.getName(arg_129_0)
	return arg_129_0.name
end

function ChatSection.getClanLevelUpNode(arg_130_0, arg_130_1)
	local var_130_0 = arg_130_1.msg_doc
	
	if not var_130_0 then
		return 
	end
	
	local var_130_1, var_130_2 = var_0_6(arg_130_1)
	local var_130_3 = 600
	local var_130_4 = cc.CSLoader:createNode("wnd/chat_node_clan_log.csb")
	local var_130_5 = var_130_4:getChildByName("txt_log")
	local var_130_6 = 2 * arg_130_0.line_height
	
	var_130_4.width = var_130_3
	var_130_4.height = var_130_6 + 36
	
	local var_130_7 = ClanUtil:getEmblemBGID({
		emblem = var_130_0.emblem
	})
	local var_130_8 = ClanUtil:getEmblemID({
		emblem = var_130_0.emblem
	})
	local var_130_9 = DB("clan_emblem", tostring(var_130_8), {
		"emblem"
	}) or 1
	local var_130_10 = DB("clan_emblem", tostring(var_130_7), {
		"emblem"
	}) or 22
	
	if_set(var_130_4, "txt_log", var_130_1)
	if_set_sprite(var_130_4, "emblem", "emblem/" .. var_130_9 .. ".png")
	if_set_sprite(var_130_4, "emblem_bg", "emblem/" .. var_130_10 .. ".png")
	
	return var_130_4
end

function ChatSection.getChatNode(arg_131_0, arg_131_1)
	if not arg_131_1.msg_doc then
		return 
	end
	
	local var_131_0 = arg_131_1.msg_doc.style or arg_131_1.msg_doc.type
	local var_131_1
	
	if arg_131_1.msg_doc.emoji and arg_131_1.msg_doc.emoji ~= "" then
		var_131_1 = arg_131_0:getChatNodeEmoji(arg_131_1)
	elseif not var_131_0 then
		var_131_1 = arg_131_0:getChatNodeText(arg_131_1)
	elseif var_131_0 == "notice" then
		var_131_1 = arg_131_0:getChatNodeNotice(arg_131_1)
	elseif var_131_0 == "clan_level_up" then
		var_131_1 = arg_131_0:getClanLevelUpNode(arg_131_1)
	elseif var_131_0 == "replay" then
		var_131_1 = arg_131_0:getChatNodeReplay(arg_131_1)
	elseif var_131_0 == "clan_promote" then
		var_131_1 = arg_131_0:getChatNodeClanPR(arg_131_1)
	elseif var_131_0 == "lota" then
		var_131_1 = arg_131_0:getChatNodeLota(arg_131_1)
	end
	
	if get_cocos_refid(var_131_1) then
		var_131_1.time = arg_131_1.msg_tm
		
		return var_131_1
	end
	
	local var_131_2 = var_0_6(arg_131_1)
	local var_131_3 = cc.CSLoader:createNode("wnd/chat_node_log.csb")
	
	var_131_3.height = 30
	
	if_set(var_131_3, "txt_log", var_131_2)
	
	return var_131_3
end

function ChatSection.setChatUserFace(arg_132_0, arg_132_1, arg_132_2)
	local var_132_0 = arg_132_2.msg_doc.sender
	local var_132_1 = var_132_0 and var_132_0.name or arg_132_2.user_id
	local var_132_2 = var_132_0 and var_132_0.leader_code or "npc1003"
	local var_132_3 = var_132_0 and var_132_0.border_code or "ma_border1"
	local var_132_4 = DB("character", var_132_2, "face_id")
	local var_132_5 = tonumber(arg_132_2.user_id)
	
	if arg_132_2.msg_doc.style == "notice" then
		var_132_1 = "GM"
	end
	
	if var_132_5 and var_132_5 == tonumber(Account:getUserId()) then
		if_set_color(arg_132_1, "txt_name", tocolor("#6bc11b"))
		
		var_132_1 = var_132_1 .. "[me]"
	elseif arg_132_2.msg_doc.color then
		if_set_color(arg_132_1, "txt_name", tocolor(arg_132_2.msg_doc.color))
		
		var_132_1 = var_132_1 .. (arg_132_2.msg_doc.tag or "")
	end
	
	if_set(arg_132_1, "txt_name", tostring(var_132_1))
	if_set_sprite(arg_132_1, "face", "face/" .. var_132_4 .. "_s.png")
	
	local var_132_6, var_132_7 = DB("item_material", var_132_3, {
		"icon",
		"frame_effect"
	})
	
	if var_132_6 then
		if_set_sprite(arg_132_1, "frame", "item/" .. var_132_6 .. ".png")
		if_set_effect(arg_132_1, "frame", var_132_7)
	end
	
	local var_132_8 = arg_132_1:getChildByName("face")
	
	if var_132_8 then
		WidgetUtils:simpleTouchCallback(var_132_8, function(arg_133_0)
			if var_132_0.id == Account:getUserId() then
			elseif SceneManager:getCurrentSceneName() == "battle" then
				balloon_message_with_sound("cant_use_battle_userinfo")
			elseif arg_132_0.wnd.section.name ~= "arena" then
				Friend:preview(var_132_0.id, nil, {
					from_chat = true
				})
			end
		end)
	end
	
	if arg_132_2.section == "clan" and arg_132_2.msg_doc and arg_132_2.msg_doc.sender then
		local var_132_9 = arg_132_2.msg_doc.sender.clan_grade
		
		if var_132_9 then
			local var_132_10 = tonumber(var_132_9) >= CLAN_GRADE.executives
			local var_132_11 = tonumber(var_132_9) == CLAN_GRADE.master
			
			if_set_visible(arg_132_1, "cm_icon_etcleader_b", var_132_10)
			if_set_color(arg_132_1, "cm_icon_etcleader_b", var_132_10 and var_132_11 and tocolor("#ffffff") or tocolor("#337ac3"))
		end
	end
end

function ChatSection.getChatNodeText(arg_134_0, arg_134_1)
	if not arg_134_1.msg_doc then
		return 
	end
	
	local var_134_0 = var_0_6(arg_134_1)
	local var_134_1 = 600
	local var_134_2 = cc.CSLoader:createNode("wnd/chat_node_text.csb")
	local var_134_3 = var_134_2:getChildByName("n_msg")
	local var_134_4 = var_134_0
	local var_134_5 = createRichLabel({
		color = cc.c4b(170, 170, 170, 255),
		outline_color = cc.c4b(26, 26, 26, 255)
	})
	
	var_134_5:setContentSize({
		height = 0,
		width = var_134_1
	})
	var_134_5:setAnchorPoint(0, 0)
	UIUtil:updateTextWrapMode(var_134_5, var_134_4, 20)
	var_134_5:setString(var_134_4)
	var_134_5:setScale(arg_134_0.scale)
	var_134_5:formatText()
	
	var_134_2.width = var_134_1
	
	local var_134_6 = var_134_5:getLineCount() * arg_134_0.line_height
	
	var_134_2.height = var_134_6 + 36
	
	var_134_3:addChild(var_134_5)
	
	var_134_2.text = var_134_0
	
	local var_134_7 = var_134_3:getPositionY()
	
	if var_134_7 < var_134_6 then
		var_134_2:getChildByName("n_base"):setPositionY(var_134_6 - var_134_7)
	end
	
	arg_134_0:setChatUserFace(var_134_2, arg_134_1)
	var_134_2:setCascadeOpacityEnabled(true)
	
	return var_134_2
end

function ChatSection.getChatNodeEmoji(arg_135_0, arg_135_1)
	local var_135_0 = arg_135_1.msg_doc
	
	if not var_135_0 then
		return 
	end
	
	local var_135_1 = 600
	local var_135_2 = var_135_0.emoji
	local var_135_3 = cc.CSLoader:createNode("wnd/chat_node_emoji.csb")
	local var_135_4 = var_135_3:getChildByName("n_emoji")
	local var_135_5 = "emoticon_chat/" .. var_135_2 .. ".png"
	local var_135_6 = cc.Sprite:create()
	
	SpriteCache:resetSprite(var_135_6, var_135_5)
	
	local var_135_7 = var_135_6:getContentSize().height
	
	var_135_3.width = var_135_1
	var_135_3.height = var_135_7 + 32
	
	var_135_4:addChild(var_135_6)
	
	local var_135_8 = var_135_4:getPositionY()
	
	var_135_3:getChildByName("n_base"):setPositionY(var_135_7 - 52 - var_135_8)
	arg_135_0:setChatUserFace(var_135_3, arg_135_1)
	var_135_3:setCascadeOpacityEnabled(true)
	
	return var_135_3
end

function ChatSection.setChatTime(arg_136_0, arg_136_1, arg_136_2)
	if not arg_136_2 then
		return 
	end
	
	if arg_136_2 then
		local var_136_0 = os.time() - arg_136_2
		
		if_set(arg_136_1, "txt_time", var_136_0 < 60 and T("time_just_before") or T("time_before", {
			time = sec_to_string(var_136_0)
		}))
		
		if get_cocos_refid(arg_136_1:getChildByName("txt_name")) then
			UIUtil:alignControl(arg_136_1, "txt_name", "txt_time", 4)
		end
	else
		if_set_visible(arg_136_1, "txt_time", false)
	end
end

function ChatSection.getChatNodeNotice(arg_137_0, arg_137_1)
	local var_137_0 = arg_137_1.msg_doc.contents
	
	if not var_137_0 and arg_137_1.msg_doc.text then
		return arg_137_0:getChatNodeText(arg_137_1)
	end
	
	if var_137_0.type == "gacha" or var_137_0.type == "request_item" then
		return arg_137_0:getChatNodeReward(arg_137_1)
	elseif var_137_0.type == "equip" or var_137_0.type == "unit" then
		return arg_137_0:getChatNodeShare(arg_137_1)
	end
end

function ChatSection.getChatNodeReward(arg_138_0, arg_138_1)
	local var_138_0 = arg_138_1.msg_doc.contents
	local var_138_1 = var_0_6(arg_138_1)
	local var_138_2 = cc.CSLoader:createNode("wnd/chat_node_reward.csb")
	
	var_138_2.width = 430
	var_138_2.height = 102
	var_138_2.text = var_138_1
	
	if var_138_0.type == "gacha" then
		if var_138_0.attrs.gacha_type == "character" then
			UIUtil:getRewardIcon(nil, var_138_0.attrs.code, {
				name = false,
				parent = var_138_2:getChildByName("n_icon")
			})
		else
			UIUtil:getRewardIcon(nil, var_138_0.attrs.code, {
				name = false,
				scale = 0.7,
				parent = var_138_2:getChildByName("n_icon")
			})
		end
	elseif var_138_0.type == "request_item" then
		UIUtil:getRewardIcon(nil, var_138_0.item_code, {
			no_tooltip = true,
			name = false,
			scale = 0.7,
			parent = var_138_2:getChildByName("n_icon"),
			touch_callback = function()
				local var_139_0 = SceneManager:getCurrentSceneName()
				
				if var_139_0 == "battle" or var_139_0 == "clan" or var_139_0 == "world_boss" or var_139_0 == "arena_net_lounge" or var_139_0 == "arena_net_ready" or var_139_0 == "arena_net_round_next" then
					return 
				end
				
				SceneManager:nextScene("clan", {
					doAfterNextSceneLoaded = function()
						ClanCategory:setMode("support")
					end
				})
				SoundEngine:play("event:/ui/whoosh_a")
			end
		})
	end
	
	arg_138_0:setChatUserFace(var_138_2, arg_138_1)
	var_138_2:setCascadeOpacityEnabled(true)
	
	local function var_138_3(arg_141_0, arg_141_1)
		local var_141_0 = arg_141_0:getChildByName("n_msg")
		local var_141_1 = arg_141_0.cont_msg
		
		if get_cocos_refid(var_141_1) then
			var_141_1:removeFromParent()
		end
		
		if arg_141_1 then
			var_141_1 = createRichLabel({
				color = cc.c4b(118, 94, 64, 255),
				outline_color = cc.c4b(26, 26, 26, 255)
			})
		else
			var_141_1 = createRichLabel({
				color = cc.c4b(118, 94, 64, 255)
			})
		end
		
		var_141_1:setContentSize({
			height = 0,
			width = arg_141_0.width
		})
		var_141_1:setAnchorPoint(0, 0)
		var_141_1:setString(arg_141_0.text)
		UIUtil:updateTextWrapMode(var_141_1, arg_141_0.text, 20)
		var_141_1:setScale(arg_138_0.scale)
		var_141_1:formatText()
		
		local var_141_2 = var_141_1:getLineCount() * arg_138_0.line_height
		
		var_141_1:setPositionY((var_141_2 - 45) / 2)
		
		arg_141_0.cont_msg = var_141_1
		
		var_141_0:addChild(var_141_1)
	end
	
	function var_138_2.setOpacityOn(arg_142_0, arg_142_1)
		var_138_3(arg_142_0, arg_142_1)
		if_set_opacity(arg_142_0, "bg", arg_142_1 and 31 or 255)
	end
	
	var_138_2:setOpacityOn(ChatMain:getOpacityOn())
	
	if get_cocos_refid(var_138_2.cont_msg) and var_138_2.cont_msg:getLineCount() == 3 then
		local var_138_4 = var_138_2:findChildByName("talk_small_bg")
		
		if get_cocos_refid(var_138_4) then
			for iter_138_0, iter_138_1 in pairs(var_138_4:getChildren()) do
				iter_138_1.origin_position_y = iter_138_1.origin_position_y or iter_138_1:getPositionY()
				
				iter_138_1:setPositionY(iter_138_1.origin_position_y + 6)
			end
			
			var_138_4.origin_size = var_138_4.origin_size or var_138_4:getContentSize()
			
			var_138_4:setContentSize(var_138_4.origin_size.width, var_138_4.origin_size.height + 12)
			
			var_138_4.origin_position_y = var_138_4.origin_position_y or var_138_4:getPositionY()
			
			var_138_4:setPositionY(var_138_4.origin_position_y - 6)
		end
	end
	
	return var_138_2
end

function ChatSection.getChatNodeShare(arg_143_0, arg_143_1)
	local function var_143_0(arg_144_0)
		if not arg_144_0 or not arg_144_0.msg_doc then
			return 
		end
		
		local var_144_0 = arg_144_0.msg_doc.sender
		local var_144_1 = var_144_0 and var_144_0.name or arg_144_0.user_id
		local var_144_2 = arg_144_0.msg_doc.contents
		local var_144_3 = ""
		
		if var_144_2.type == "equip" then
			local var_144_4 = var_0_4(T(DB("equip_item", var_144_2.equip.code, "name")), "#ffffff")
			
			var_144_3 = T_KR("broadcast_equip_share", {
				name = var_144_1,
				equip = var_144_4
			})
		elseif var_144_2.type == "unit" then
			local var_144_5 = var_0_4(T(DB("character", var_144_2.unit.code, "name")), "#ffffff")
			
			var_144_3 = T_KR("broadcast_hero_share", {
				name = var_144_1,
				hero = var_144_5
			})
		end
		
		return var_144_3
	end
	
	local var_143_1 = arg_143_1.msg_doc.contents
	local var_143_2 = var_143_0(arg_143_1)
	local var_143_3 = cc.CSLoader:createNode("wnd/chat_node_share.csb")
	local var_143_4 = var_143_3:getChildByName("btn_go")
	
	var_143_3.width = 430
	var_143_3.height = 102
	var_143_3.text = var_143_2
	
	if var_143_1.type == "equip" then
		local var_143_5 = EQUIP:createByInfo(var_143_1.equip)
		
		if var_143_5 then
			UIUtil:getRewardIcon(nil, var_143_1.equip.code, {
				name = false,
				no_tooltip = true,
				parent = var_143_3:getChildByName("reward_item"),
				equip = var_143_5
			})
			WidgetUtils:setupTooltip({
				adjust_x = -650,
				control = var_143_4,
				creator = function(arg_145_0)
					local var_145_0 = ItemTooltip:getItemTooltip({
						code = var_143_1.equip.code,
						equip = var_143_5
					})
					
					RewardInfo.addRewardInfoNode(var_145_0, {})
					
					return var_145_0
				end
			})
		end
	elseif var_143_1.type == "unit" and var_143_1.unit_data then
		local var_143_6 = arg_143_1.msg_doc.sender.name
		local var_143_7 = UNIT:create(var_143_1.unit_data, false, true)
		local var_143_8 = var_143_1.unit_data.skin_code or var_143_1.unit_data.code
		local var_143_9 = arg_143_1.msg_doc.sender
		local var_143_10 = var_143_9 and var_143_9.leader_code or "npc1003"
		local var_143_11 = var_143_9 and var_143_9.border_code or "ma_border1"
		
		if var_143_1.growth_boost then
			var_143_7 = GrowthBoost:applyManual(var_143_7, var_143_1.gb_level)
		end
		
		UIUtil:getRewardIcon(nil, var_143_8, {
			name = false,
			no_db_grade = true,
			is_chat = true,
			no_popup = true,
			use_share_popup = true,
			parent = var_143_3:getChildByName("reward_item"),
			lv = var_143_7:getLv(),
			grade = var_143_7:getGrade(),
			zodiac = var_143_7:getZodiacGrade(),
			unit = var_143_7,
			share_equips = var_143_1.equips,
			user_name = var_143_6,
			share_leader_code = var_143_10,
			share_border_code = var_143_11,
			growth_boost = var_143_1.growth_boost,
			gb_level = var_143_1.gb_level,
			awake = var_143_7:getAwakeGrade()
		})
		
		if get_cocos_refid(var_143_4) then
			var_143_4.unit = var_143_7
			var_143_4.growth_boost = var_143_1.growth_boost
			var_143_4.gb_level = var_143_1.gb_level
			var_143_4.share_equips = var_143_1.equips
			var_143_4.user_name = var_143_6
			var_143_4.leader_code = var_143_10
			var_143_4.border_code = var_143_11
			
			var_143_4:addTouchEventListener(function(arg_146_0, arg_146_1)
				if UIAction:Find("block") then
					return 
				end
				
				if arg_146_1 == 2 and arg_146_0.unit then
					local var_146_0 = arg_146_0.unit
					local var_146_1 = arg_146_0.growth_boost
					local var_146_2 = arg_146_0.gb_level
					local var_146_3 = arg_146_0.share_equips
					local var_146_4 = arg_146_0.user_name
					local var_146_5 = arg_146_0.leader_code
					local var_146_6 = arg_146_0.border_code
					
					ShareUnitPopup:open(var_146_0, var_146_3, {
						is_chat = true,
						user_name = var_146_4,
						border_code = var_146_6,
						leader_code = var_146_5,
						growth_boost = var_146_1,
						gb_level = var_146_2
					})
				end
			end)
		end
	end
	
	arg_143_0:setChatUserFace(var_143_3, arg_143_1)
	arg_143_0:setChatTime(var_143_3, arg_143_1.msg_tm)
	var_143_3:setCascadeOpacityEnabled(true)
	
	local var_143_12 = var_143_3:getChildByName("n_share")
	local var_143_13 = var_143_12:getChildByName("txt_news")
	local var_143_14 = upgradeLabelToRichLabel(var_143_12, "txt_news")
	
	UIUtil:updateTextWrapMode(var_143_14, var_143_2)
	if_set(var_143_14, nil, var_143_2)
	
	function var_143_3.setOpacityOn(arg_147_0, arg_147_1)
		if_set_opacity(arg_147_0, "n_bg", arg_147_1 and 102 or 255)
	end
	
	var_143_3:setOpacityOn(ChatMain:getOpacityOn())
	
	return var_143_3
end

function ChatSection.getChatNodeReplay(arg_148_0, arg_148_1)
	if not arg_148_1.msg_doc then
		return 
	end
	
	local var_148_0 = arg_148_1.msg_doc.contents
	
	if not var_148_0 then
		return 
	end
	
	local var_148_1 = load_dlg("chat_node_replay", true, "wnd")
	
	var_148_1:setPositionX(0)
	
	var_148_1.height = 102
	
	local var_148_2 = var_148_1:getChildByName("n_share")
	local var_148_3 = var_148_2:getChildByName("txt_news")
	
	UIUtil:updateTextWrapMode(var_148_3, var_148_0.comment)
	if_set(var_148_2, "txt_news", var_148_0.comment)
	var_148_2:getChildByName("icon_replay"):setName(tostring(var_148_0.replay_share_id))
	arg_148_0:setChatUserFace(var_148_1, arg_148_1)
	
	function var_148_1.setOpacityOn(arg_149_0, arg_149_1)
		if_set_opacity(arg_149_0, "n_bg", arg_149_1 and 102 or 255)
	end
	
	return var_148_1
end

function ChatSection.getChatNodeClanPR(arg_150_0, arg_150_1)
	local var_150_0 = arg_150_1.msg_doc
	
	if not var_150_0 then
		return 
	end
	
	local var_150_1 = load_dlg("chat_node_clan_promo", true, "wnd")
	local var_150_2 = var_150_1:getChildByName("n_base")
	
	if not get_cocos_refid(var_150_2) then
		return 
	end
	
	local var_150_3 = 102
	
	var_150_1:setPositionX(0)
	
	local var_150_4 = var_150_1:getChildByName("n_msg")
	
	if get_cocos_refid(var_150_4) then
		local var_150_5 = var_0_6(arg_150_1)
		local var_150_6 = createRichLabel({
			color = cc.c4b(170, 170, 170, 255),
			outline_color = cc.c4b(26, 26, 26, 255)
		})
		
		var_150_6:setContentSize({
			width = 600,
			height = 0
		})
		var_150_6:setAnchorPoint(0, 0)
		UIUtil:updateTextWrapMode(var_150_6, var_150_5, 20)
		var_150_6:setString(var_150_5)
		var_150_6:setScale(arg_150_0.scale)
		var_150_6:formatText()
		
		local var_150_7 = var_150_6:getLineCount() * arg_150_0.line_height
		
		var_150_3 = var_150_3 + var_150_7
		
		var_150_2:setPositionY(var_150_7 - arg_150_0.line_height)
		var_150_4:addChild(var_150_6)
		
		local var_150_8 = var_150_1:getChildByName("n_clan")
		
		if get_cocos_refid(var_150_8) then
			var_150_8:setPositionY(93 - var_150_7)
		end
	end
	
	var_150_1.height = var_150_3
	
	UIUtil:updateClanEmblem(var_150_1:getChildByName("n_emblem"), {
		emblem = var_150_0.emblem
	})
	arg_150_0:setChatUserFace(var_150_1, arg_150_1)
	upgradeLabelToRichLabel(var_150_1, "txt_clan_info")
	
	local var_150_9 = var_150_1:getChildByName("txt_clan_info")
	
	if get_cocos_refid(var_150_9) then
		UIUtil:updateTextWrapMode(var_150_9, var_150_0.intro_msg)
		
		local var_150_10 = get_ellipsis(var_150_9, var_150_0.intro_msg, function()
			return utf8len(var_150_9:getString()) > 49
		end)
		
		if_set(var_150_9, nil, var_150_10)
	end
	
	local var_150_11 = var_150_1:getChildByName("btn_go")
	
	if get_cocos_refid(var_150_11) then
		var_150_11:addTouchEventListener(function(arg_152_0, arg_152_1)
			if UIAction:Find("block") then
				return 
			end
			
			if arg_152_1 == 2 then
				Clan:queryPreview(var_150_0.clan_id, "preview")
			end
		end)
	end
	
	function var_150_1.setOpacityOn(arg_153_0, arg_153_1)
		if_set_opacity(arg_153_0, "n_bg", arg_153_1 and 153 or 255)
	end
	
	return var_150_1
end

function ChatSection.getChatNodeLota(arg_154_0, arg_154_1)
	if not arg_154_1.msg_doc then
		return 
	end
	
	local var_154_0 = load_dlg("chat_node_clan_system", true, "wnd")
	local var_154_1 = var_0_6(arg_154_1)
	local var_154_2 = var_154_0:getChildByName("n_msg")
	local var_154_3 = 600
	
	var_154_0:setPositionX(0)
	
	local var_154_4 = createRichLabel({
		color = cc.c4b(170, 170, 170, 255),
		outline_color = cc.c4b(26, 26, 26, 255)
	})
	
	var_154_4:setContentSize({
		height = 0,
		width = var_154_3
	})
	var_154_4:setAnchorPoint(0, 0)
	UIUtil:updateTextWrapMode(var_154_4, var_154_1, 20)
	var_154_4:setString(var_154_1)
	var_154_4:setScale(arg_154_0.scale)
	var_154_4:formatText()
	
	local var_154_5 = var_154_4:getLineCount() * arg_154_0.line_height
	
	var_154_0.height = var_154_5 + 36
	
	var_154_2:addChild(var_154_4)
	
	local var_154_6 = var_154_2:getPositionY()
	
	if var_154_6 < var_154_5 then
		var_154_0:getChildByName("n_base"):setPositionY(var_154_5 - var_154_6)
	end
	
	if_set_visible(var_154_0, "n_face", false)
	
	return var_154_0
end

function ChatSection.sync(arg_155_0, arg_155_1)
	local var_155_0 = ChatMBox:getHistory(arg_155_0.name)
	
	if not var_155_0 then
		return 
	end
	
	local var_155_1 = var_155_0[#var_155_0]
	
	for iter_155_0, iter_155_1 in pairs(var_155_0) do
		if iter_155_1[arg_155_0.name] ~= arg_155_0 then
			arg_155_0:addChatData(iter_155_1, true)
			
			iter_155_1[arg_155_0.name] = arg_155_0
		end
	end
	
	arg_155_0:arrangeChat(arg_155_1)
end

function ChatSection.isVisible(arg_156_0)
	if not get_cocos_refid(arg_156_0.wnd) then
		return 
	end
	
	return arg_156_0.wnd:isVisible()
end

function ChatSection.setVisible(arg_157_0, arg_157_1)
	if not get_cocos_refid(arg_157_0.wnd) then
		return 
	end
	
	arg_157_0.wnd:setVisible(arg_157_1)
	
	if arg_157_1 then
		arg_157_0:sync()
	end
end

ChatFavorite = {}

function ChatFavorite.show(arg_158_0)
	local var_158_0 = load_dlg("chat_favorite", true, "wnd", function()
		arg_158_0:close()
	end)
	
	if not get_cocos_refid(var_158_0) then
		return 
	end
	
	if_set(var_158_0, "t_disc", T("ui_favoriteschannel_explain"))
	SceneManager:getRunningPopupScene():addChild(var_158_0)
	var_158_0:bringToFront()
	
	arg_158_0.vars = {}
	arg_158_0.vars.dlg = var_158_0
	arg_158_0.vars.input_channel = var_158_0:findChildByName("input_channel")
	
	arg_158_0.vars.input_channel:setMaxLength(MAX_CHANNEL_TEXT)
	arg_158_0.vars.input_channel:setMaxLengthEnabled(true)
	arg_158_0.vars.input_channel:setCursorEnabled(true)
	arg_158_0.vars.input_channel:setTextColor(cc.c3b(107, 101, 27))
	arg_158_0:updateFavoriteDesc()
end

function ChatFavorite.close(arg_160_0)
	if not arg_160_0.vars then
		return 
	end
	
	if not arg_160_0.vars.dlg then
		return 
	end
	
	arg_160_0.vars.dlg:removeFromParent()
	
	arg_160_0.vars.dlg = nil
	
	BackButtonManager:pop("chat_favorite")
end

function ChatFavorite.changeFavorite(arg_161_0)
	if not get_cocos_refid(arg_161_0.vars.input_channel) then
		return 
	end
	
	local var_161_0 = arg_161_0:getFavoriteChannel()
	local var_161_1 = to_n(arg_161_0.vars.input_channel:getString())
	
	if var_161_1 == var_161_0 then
		return 
	end
	
	if var_161_1 <= 0 or var_161_1 > 9999 then
		balloon_message_with_sound("chat_invalid_channel")
		
		return 
	end
	
	SAVE:setKeep("favorite_channel", var_161_1)
	arg_161_0:updateFavoriteDesc()
	balloon_message_with_sound("ui_favoriteschannel_set")
	ChatMain:updateChannelName()
end

function ChatFavorite.updateFavoriteDesc(arg_162_0)
	local var_162_0 = arg_162_0:getFavoriteChannel()
	local var_162_1
	
	if var_162_0 then
		var_162_1 = T("ui_favoriteschannel_num") .. " " .. T("ui_favoriteschannel_channel_num", {
			channel = var_162_0
		})
	else
		var_162_1 = T("ui_favoriteschannel_num") .. " " .. T("ui_favoriteschannel_none")
	end
	
	if_set(arg_162_0.vars.dlg, "t_favorite_channel", var_162_1)
end

function ChatFavorite.getFavoriteChannel(arg_163_0)
	local var_163_0 = SAVE:getKeep("favorite_channel")
	
	if not var_163_0 then
		local var_163_1 = SAVE:get("favorite_channel")
		
		if var_163_1 then
			var_163_0 = to_n(var_163_1)
			
			SAVE:setKeep("favorite_channel", var_163_0)
			SAVE:set("favorite_channel", nil)
		end
	end
	
	if var_163_0 and var_163_0 > 0 and var_163_0 <= 9999 then
		return var_163_0
	end
end
