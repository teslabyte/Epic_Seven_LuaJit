Friend = {}

function MsgHandler.friend_all(arg_1_0)
	if SceneManager:getCurrentSceneName() == "friend" then
		Friend:show(arg_1_0, SceneManager:getDefaultLayer())
	else
		SceneManager:nextScene("friend", arg_1_0)
	end
end

function MsgHandler.friend_request(arg_2_0)
	if SceneManager:getCurrentSceneName() == "friend" then
		Friend:requsted(arg_2_0)
	elseif arg_2_0.res == "ok" then
		balloon_message_with_sound("friend_send")
	elseif arg_2_0.res then
		balloon_message_with_sound("friend." .. arg_2_0.res)
	else
		balloon_message_with_sound("friend_cant")
	end
end

function MsgHandler.friend_cancel_request(arg_3_0)
	Friend:friendCancelRequest(arg_3_0)
end

function MsgHandler.friend_recommend_refresh(arg_4_0)
	Friend:friendRecommendRefresh(arg_4_0)
end

function MsgHandler.friend_search(arg_5_0)
	if SceneManager:getCurrentSceneName() == "friend" then
		Friend:friendSearchResult(arg_5_0)
	end
end

function MsgHandler.friend_refuse(arg_6_0)
	Friend:friendReceivedRefuse(arg_6_0)
end

function MsgHandler.friend_accept(arg_7_0)
	Friend:friendReceivedAccept(arg_7_0)
end

function MsgHandler.friend_delete(arg_8_0)
	Friend:friendDeleted(arg_8_0)
end

function MsgHandler.friend_preview(arg_9_0)
	Friend:previewShowPopup(arg_9_0)
end

function HANDLER.friend(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_list" then
		Friend:setMode("List")
	elseif arg_10_1 == "btn_find" then
		Friend:setMode("Find")
	elseif arg_10_1 == "btn_sent" then
		Friend:setMode("Sent")
	elseif arg_10_1 == "btn_received" then
		Friend:setMode("Received")
	elseif arg_10_1 == "btn_support" then
		SceneManager:nextScene("unit_ui", {
			mode = "Support"
		})
	elseif arg_10_1 == "btn_refresh" then
		Friend:recommendRefresh()
	elseif arg_10_1 == "btn_search" then
		cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
		Friend:search()
	elseif arg_10_1 == "btn_sort" then
		Friend:toggleListSortMenus()
		
		return 
	elseif arg_10_1 == "btn_bg" then
		Friend:toggleFindSortMenus()
		
		return 
	elseif arg_10_1 == "sort_1" then
		Friend:selectSortMenu(1)
	elseif arg_10_1 == "sort_2" then
		Friend:selectSortMenu(2)
	elseif arg_10_1 == "sort_3" then
		Friend:selectSortMenu(3)
	elseif arg_10_1 == "btn_manage" then
		Friend:manageAccount()
	elseif arg_10_1 == "Image_28" and Friend and Friend.vars and get_cocos_refid(Friend.vars.wnd) then
		Friend.vars.wnd:getChildByName("input"):setTextColor(cc.c3b(107, 101, 27))
		Friend.vars.wnd:getChildByName("input"):setCursorEnabled(true)
		
		return 
	end
	
	Friend:closeToggleMenus()
end

function HANDLER.friend_card_recommend(arg_11_0, arg_11_1)
	Friend:closeToggleMenus()
	
	local var_11_0 = string.split(arg_11_1, ":")
	
	if string.starts(arg_11_1, "btn_req_friend") then
		if table.count(var_11_0) == 2 then
			query("friend_request", {
				need_friend_update = 1,
				friend_id = var_11_0[2]
			})
		end
	elseif string.starts(arg_11_1, "btn_user_info") and table.count(var_11_0) == 2 then
		Friend:preview(var_11_0[2])
	end
end

function HANDLER.friend_card_sent(arg_12_0, arg_12_1)
	Friend:closeToggleMenus()
	
	local var_12_0 = string.split(arg_12_1, ":")
	
	if string.starts(arg_12_1, "btn_cancel") then
		if table.count(var_12_0) == 2 then
			query("friend_cancel_request", {
				friend_id = var_12_0[2]
			})
		end
	elseif string.starts(arg_12_1, "btn_user_info") and table.count(var_12_0) == 2 then
		Friend:preview(var_12_0[2])
	end
end

function HANDLER.friend_card_received(arg_13_0, arg_13_1)
	Friend:closeToggleMenus()
	
	local var_13_0 = string.split(arg_13_1, ":")
	
	if string.starts(arg_13_1, "btn_user_acept") then
		if table.count(var_13_0) == 2 then
			query("friend_accept", {
				friend_id = var_13_0[2]
			})
		end
	elseif string.starts(arg_13_1, "btn_user_deny") then
		if table.count(var_13_0) == 2 then
			query("friend_refuse", {
				friend_id = var_13_0[2]
			})
		end
	elseif string.starts(arg_13_1, "btn_user_info") and table.count(var_13_0) == 2 then
		Friend:preview(var_13_0[2])
	end
end

function HANDLER.friend_card_remove(arg_14_0, arg_14_1)
	Friend:closeToggleMenus()
	
	local var_14_0 = string.split(arg_14_1, ":")
	
	if string.starts(arg_14_1, "btn_bg") then
		if table.count(var_14_0) == 2 then
			Dialog:msgBox(T("friend.delete_confirm.desc", {
				name = arg_14_0.friend_name
			}), {
				yesno = true,
				dlg = dlg,
				handler = function()
					query("friend_delete", {
						friend_id = var_14_0[2]
					})
				end,
				title = T("friend.delete_confirm.title", {
					name = arg_14_0.friend_name
				})
			})
		end
	elseif string.starts(arg_14_1, "btn_user_info") and table.count(var_14_0) == 2 then
		Friend:preview(var_14_0[2])
	end
end

function HANDLER.friend_calculate(arg_16_0, arg_16_1)
	if arg_16_1 == "btn_ok" then
		Friend:closeFriendPointCalculate()
	end
end

function HANDLER.friend_preview_user(arg_17_0, arg_17_1)
	if arg_17_1 == "btn_close" then
		Friend:closePreview()
	elseif arg_17_1 == "btn_request" then
		Friend:previewFriendRequest()
	elseif arg_17_1 == "btn_ignore_chat" then
		Friend:setIgnoreChat(true)
	elseif arg_17_1 == "btn_unlock_ignore_chat" then
		Friend:setIgnoreChat(false)
	elseif arg_17_1 == "btn_battle" then
		Friend:inviteLounge()
	elseif arg_17_1 == "btn_clan" then
		Friend:queryClanPreview()
	elseif arg_17_1 == "btn_invite" then
		Friend:inviteClan(arg_17_0)
	elseif arg_17_1 == "btn_block" then
		Friend:reportChat()
	end
end

function Friend.onGameEvent(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_1 == "friend_count" and get_cocos_refid(arg_18_0.vars.wnd) then
		Profile:open(arg_18_0.vars.wnd:getParent(), arg_18_2)
	end
end

function Friend.friend_max(arg_19_0, arg_19_1)
	arg_19_1 = arg_19_1 or Account:getLevel()
	
	return DB("acc_rank", tostring(arg_19_1), "max_friend") or 20
end

function Friend.requsted(arg_20_0, arg_20_1)
	if arg_20_1.res ~= "ok" then
		balloon_message_with_sound("friend." .. arg_20_1.res)
	else
		balloon_message_with_sound("friend.requested")
	end
	
	if arg_20_1.friend_update and arg_20_1.friend_update.sent then
		arg_20_0.vars.info.friend_data.sent = arg_20_1.friend_update.sent
		
		arg_20_0:updateRightMenu()
		arg_20_0:markRequested(arg_20_1.friend_requested)
		FriendFind:setFriendRequested(arg_20_1.friend_requested)
		
		AccountData.friend_sent_count = AccountData.friend_sent_count + 1
	end
end

function Friend.friendCancelRequest(arg_21_0, arg_21_1)
	if arg_21_1.res ~= "ok" then
		balloon_message_with_sound("friend." .. arg_21_1.res)
	else
		balloon_message_with_sound("friend.request_canceled")
	end
	
	if arg_21_1.friend_canceled then
		arg_21_0:removeCanceled(arg_21_1.friend_canceled)
	end
	
	if arg_21_1.friend_update and arg_21_1.friend_update.sent then
		arg_21_0.vars.info.friend_data.sent = arg_21_1.friend_update.sent
		
		arg_21_0:updateRightMenu()
		FriendList:update(arg_21_1.friend_update.sent)
	end
	
	AccountData.friend_sent_count = AccountData.friend_sent_count - 1
end

function Friend.friendDeleted(arg_22_0, arg_22_1)
	if arg_22_1.res ~= "ok" then
		balloon_message_with_sound("friend." .. arg_22_1.res)
	else
		balloon_message_with_sound("friend.deleted")
	end
	
	if arg_22_1.friend_deleted and arg_22_0.vars.info.friend_data.received then
		for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.info.friend_data.list) do
			if iter_22_1.ad.id == arg_22_1.friend_deleted then
				table.remove(arg_22_0.vars.info.friend_data.list, iter_22_0)
				FriendList:update(arg_22_0.vars.info.friend_data.list)
				arg_22_0:updateFriendCount()
				
				break
			end
		end
	end
end

function Friend.friendReceivedRefuse(arg_23_0, arg_23_1)
	if arg_23_1.res ~= "ok" then
		balloon_message_with_sound("friend." .. arg_23_1.res)
	else
		balloon_message_with_sound("friend.request_refused")
	end
	
	if arg_23_1.friend_refused and arg_23_0.vars.info.friend_data.received then
		for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.info.friend_data.received) do
			if iter_23_1.ad.id == arg_23_1.friend_refused then
				table.remove(arg_23_0.vars.info.friend_data.received, iter_23_0)
				FriendList:update(arg_23_0.vars.info.friend_data.received)
				
				break
			end
		end
	end
	
	arg_23_0:updateRightMenu()
	
	if arg_23_1.friend_update then
		FriendList:update(arg_23_1.friend_update.received)
	end
end

function Friend.friendReceivedAccept(arg_24_0, arg_24_1)
	if arg_24_1.res ~= "ok" then
		balloon_message_with_sound("friend." .. arg_24_1.res)
	else
		balloon_message_with_sound("friend.accepted")
	end
	
	if arg_24_1.friend_accepted and arg_24_0.vars.info.friend_data.received then
		for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.info.friend_data.received) do
			if iter_24_1.ad.id == arg_24_1.friend_accepted then
				table.remove(arg_24_0.vars.info.friend_data.received, iter_24_0)
				FriendList:update(arg_24_0.vars.info.friend_data.received)
				
				break
			end
		end
	end
	
	arg_24_0:updateRightMenu()
	
	if arg_24_1.friend_update and arg_24_1.friend_update.list then
		arg_24_0.vars.info.friend_data.list = arg_24_1.friend_update.list
		
		arg_24_0:updateFriendCount()
	end
	
	ConditionContentsManager:dispatch("friend.add", {
		count = #arg_24_0.vars.info.friend_data.list
	})
end

function Friend.friendRecommendRefresh(arg_25_0, arg_25_1)
	if arg_25_1.friend_update then
		arg_25_0.vars.info.friend_data.recommend = arg_25_1.friend_update.recommend
		
		FriendFind:update(arg_25_1.friend_update.recommend, "Recommend")
	end
end

function Friend.friendSearchResult(arg_26_0, arg_26_1)
	if arg_26_1.friend_update then
		arg_26_0.vars.info.friend_data.find = arg_26_1.friend_update.find
		
		FriendFind:update(arg_26_1.friend_update.find, "Find")
	end
end

function Friend.removeCanceled(arg_27_0, arg_27_1)
	if arg_27_0.vars.info.friend_data.recommend then
		for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.info.friend_data.recommend) do
			if iter_27_1.id == arg_27_1 then
				table.remove(arg_27_0.vars.info.friend_data.recommend, iter_27_0)
				FriendFind:update(arg_27_0.vars.info.friend_data.recommend)
				
				break
			end
		end
	end
	
	if arg_27_0.vars.info.friend_data.find then
		for iter_27_2, iter_27_3 in pairs(arg_27_0.vars.info.friend_data.find) do
			if iter_27_3.id == arg_27_1 then
				table.remove(arg_27_0.vars.info.friend_data.find, iter_27_2)
				FriendFind:update(arg_27_0.vars.info.friend_data.find)
				
				break
			end
		end
	end
end

function Friend.markRequested(arg_28_0, arg_28_1)
	if arg_28_0.vars.info.friend_data.recommend then
		for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.info.friend_data.recommend) do
			if iter_28_1.id == arg_28_1 then
				iter_28_1.mark_requested = true
			end
		end
	end
	
	if arg_28_0.vars.info.friend_data.find then
		for iter_28_2, iter_28_3 in pairs(arg_28_0.vars.info.friend_data.find) do
			if iter_28_3.id == arg_28_1 then
				iter_28_3.mark_requested = true
			end
		end
	end
end

function Friend.search(arg_29_0)
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("input"):getString()
	
	if arg_29_0.vars.sort_menu_find_index == 1 then
		if var_29_0 == nil or utf8len(var_29_0) < 2 then
			balloon_message_with_sound("search_two_words")
			
			return 
		end
	elseif arg_29_0.vars.sort_menu_find_index == 2 and (var_29_0 == nil or utf8len(var_29_0) < 1) then
		balloon_message_with_sound("friend_search_id")
		
		return 
	end
	
	if (arg_29_0.vars.time_search or 0) + 2 > os.time() then
		balloon_message_with_sound("nickname.check_wait_seconds")
		
		return 
	end
	
	arg_29_0.vars.time_search = os.time()
	
	query("friend_search", {
		type = arg_29_0.vars.sort_menu_find_index,
		search = var_29_0
	})
end

function Friend.recommendRefresh(arg_30_0)
	if (arg_30_0.vars.time_search or 0) + 2 > os.time() then
		balloon_message_with_sound("nickname.check_wait_seconds")
		
		return 
	end
	
	arg_30_0.vars.time_search = os.time()
	
	query("friend_recommend_refresh")
end

function Friend.selectSortMenu(arg_31_0, arg_31_1)
	if arg_31_0.vars.mode == "Find" then
		arg_31_0.vars.sort_menu_find_index = arg_31_1
		
		arg_31_0:toggleFindSortMenus(false)
		arg_31_0.vars.wnd:getChildByName("input"):setString("")
	else
		if arg_31_0.vars.sort_menu_list_index == arg_31_1 then
			arg_31_0.vars.sort_menu_list_order = not arg_31_0.vars.sort_menu_list_order
		else
			arg_31_0.vars.sort_menu_list_order = true
		end
		
		arg_31_0.vars.sort_menu_list_index = arg_31_1
		
		arg_31_0:toggleListSortMenus(false)
		FriendList:update()
	end
end

function Friend.manageAccount(arg_32_0)
	if (arg_32_0.preview_open_time or 0) + 2 > os.time() then
		balloon_message_with_sound("nickname.check_wait_seconds")
	else
		arg_32_0.preview_open_time = os.time()
		
		query("friend_count", {
			friend_id = AccountData.id
		})
	end
end

function Friend.toggleFindSortMenus(arg_33_0, arg_33_1)
	if arg_33_1 == nil then
		arg_33_0.vars.sort_menu_find_toggle = not arg_33_0.vars.sort_menu_find_toggle
	else
		arg_33_0.vars.sort_menu_find_toggle = arg_33_1
	end
	
	if_set_visible(arg_33_0.vars.wnd, "n_layer_sort_search", arg_33_0.vars.sort_menu_find_toggle)
	
	local var_33_0 = arg_33_0.vars.wnd:getChildByName("btn_sort_search")
	local var_33_1 = arg_33_0.vars.wnd:getChildByName("n_layer_sort_search")
	local var_33_2 = var_33_1:getChildByName("sort_" .. arg_33_0.vars.sort_menu_find_index)
	local var_33_3 = var_33_2:getChildByName("label")
	
	if_set(var_33_0, "txt_sort_search", var_33_3:getString())
	
	if arg_33_0.vars.sort_menu_find_toggle then
		local var_33_4, var_33_5 = var_33_2:getPosition()
		
		var_33_1:getChildByName("sort_cursor"):setPosition(var_33_4, var_33_5)
		var_33_1:getChildByName("icon_order"):setPositionY(var_33_5)
	end
end

function Friend.toggleListSortMenus(arg_34_0, arg_34_1)
	if arg_34_1 == nil then
		arg_34_0.vars.sort_menu_list_toggle = not arg_34_0.vars.sort_menu_list_toggle
	else
		arg_34_0.vars.sort_menu_list_toggle = arg_34_1
	end
	
	if_set_visible(arg_34_0.vars.wnd, "n_layer_sort_friend", arg_34_0.vars.sort_menu_list_toggle)
	
	local var_34_0 = arg_34_0.vars.wnd:getChildByName("btn_sort")
	local var_34_1 = arg_34_0.vars.wnd:getChildByName("n_layer_sort_friend")
	local var_34_2 = var_34_1:getChildByName("sort_" .. arg_34_0.vars.sort_menu_list_index)
	local var_34_3 = var_34_2:getChildByName("label")
	
	if_set(var_34_0, "txt_sort", var_34_3:getString())
	
	local var_34_4 = var_34_0:getChildByName("txt_sort"):getContentSize()
	
	if arg_34_0.vars.sort_menu_list_toggle then
		local var_34_5, var_34_6 = var_34_2:getPosition()
		local var_34_7 = var_34_1:getChildByName("sort_cursor")
		
		if get_cocos_refid(var_34_7) then
			var_34_7:setPosition(var_34_5, var_34_6)
		end
		
		local var_34_8 = var_34_1:getChildByName("n_updown")
		
		if get_cocos_refid(var_34_8) then
			var_34_8:setPositionY(var_34_6)
			if_set_visible(var_34_8, "btn_up", not arg_34_0.vars.sort_menu_list_order)
			if_set_visible(var_34_8, "btn_down", arg_34_0.vars.sort_menu_list_order)
		end
	end
end

function Friend.updateFriendCount(arg_35_0)
	local var_35_0 = 0
	
	if arg_35_0.vars.info.friend_data.list then
		var_35_0 = table.count(arg_35_0.vars.info.friend_data.list)
	end
	
	if_set(arg_35_0.vars.wnd:getChildByName("myfriends"), "txt_count", var_35_0 .. "/" .. arg_35_0:friend_max())
end

function Friend.show(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_1 or not arg_36_1.friend_data then
		query("friend_all")
		
		return 
	end
	
	arg_36_0.vars = {}
	arg_36_0.vars.info = arg_36_1
	arg_36_0.vars.sort_menu_find_toggle = false
	arg_36_0.vars.sort_menu_find_index = 1
	arg_36_0.vars.sort_menu_list_toggle = false
	arg_36_0.vars.sort_menu_list_index = 1
	arg_36_0.vars.sort_menu_list_order = true
	arg_36_0.vars.right_menu = {
		"n_list",
		"n_find",
		"n_sent",
		"n_received"
	}
	arg_36_0.vars.wnd = load_dlg("friend", true, "wnd")
	
	arg_36_2:addChild(arg_36_0.vars.wnd)
	
	local var_36_0 = arg_36_0.vars.wnd:getChildByName("input")
	
	var_36_0:setMaxLengthEnabled(true)
	var_36_0:setCursorEnabled(true)
	var_36_0:setTextColor(cc.c3b(107, 101, 27))
	arg_36_0:updateRightMenu()
	arg_36_0:setMode("List")
	arg_36_0:updateFriendCount()
	TopBarNew:create(T("system_014_title"), arg_36_0.vars.wnd, function()
		arg_36_0:onBackButton()
		BackButtonManager:pop("TopBarNew." .. T("system_014_title"))
	end)
	
	local var_36_1 = arg_36_0.vars.wnd:getChildByName("LEFT")
	
	arg_36_0.vars.left_ui = var_36_1
	
	local var_36_2 = UIUtil:numberDigitToCharOffset(AccountData.level, 1, 0)
	
	UIUtil:warpping_setLevel(var_36_1:getChildByName("n_lv"), AccountData.level, MAX_ACCOUNT_LEVEL, 2, {
		offset_per_char = var_36_2
	})
	
	local var_36_3 = arg_36_0.vars.wnd:getChildByName("n_search_list")
	
	if get_cocos_refid(var_36_3) then
		local var_36_4 = var_36_3:getChildByName("n_txt_field")
		
		if get_cocos_refid(var_36_4) then
			local var_36_5 = var_36_4:getChildByName("Image_28")
			
			if get_cocos_refid(var_36_5) and var_36_5.prv_move then
				NotchManager:addListener(var_36_5, true, function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
					var_36_5:setPositionX(var_36_5.prv_move)
				end)
			end
			
			local var_36_6 = var_36_4:getChildByName("input")
			
			if get_cocos_refid(var_36_6) and var_36_6.prv_move then
				NotchManager:addListener(var_36_6, true, function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
					var_36_6:setPositionX(var_36_6.prv_move)
				end)
			end
		end
	end
	
	arg_36_0:setNameUI()
	arg_36_0:setIntroUI()
	var_36_1:getChildByName("exp_gauge"):setPercent(Account:getAccountExpPercent() * 100)
	if_set(var_36_1, "txt_exp", string.format("exp %0.1f%%", Account:getAccountExpPercent() * 100))
	arg_36_0:updateUserIcon()
	SoundEngine:play("event:/ui/main_hud/btn_friends")
	TutorialGuide:startGuide(UNLOCK_ID.FRIEND)
	TutorialGuide:procGuide()
	ConditionContentsManager:dispatch("friend.add", {
		count = #arg_36_0.vars.info.friend_data.list
	})
end

function Friend.updateAccountUI(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.wnd:getChildByName("LEFT")
	
	var_40_0:getChildByName("exp_gauge"):setPercent(Account:getAccountExpPercent() * 100)
	if_set(var_40_0, "txt_exp", string.format("exp %0.1f%%", Account:getAccountExpPercent() * 100))
	
	local var_40_1 = UIUtil:numberDigitToCharOffset(AccountData.level, 1, 0)
	
	UIUtil:warpping_setLevel(getChildByPath(var_40_0, "n_lv"), AccountData.level, MAX_ACCOUNT_LEVEL, 2, {
		offset_per_char = var_40_1
	})
end

function Friend.updateUserIcon(arg_41_0)
	if arg_41_0.vars and get_cocos_refid(arg_41_0.vars.left_ui) then
		local var_41_0 = arg_41_0.vars.left_ui:getChildByName("n_my_face")
		
		var_41_0:removeChildByName("@char_frame")
		UIUtil:getUserIcon(Account:getMainUnitCode(), {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1.2,
			no_grade = true,
			parent = var_41_0,
			border_code = Account:getBorderCode()
		}):setName("@char_frame")
	end
end

function Friend.setNameUI(arg_42_0)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.left_ui) then
		return 
	end
	
	if_set(arg_42_0.vars.left_ui, "txt_name", AccountData.name)
end

function Friend.setIntroUI(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.left_ui) then
		return 
	end
	
	local var_43_0 = AccountData.intro_msg or T("friend.default_intro_msg")
	local var_43_1 = arg_43_0.vars.left_ui:getChildByName("txt_intro")
	local var_43_2 = arg_43_0.vars.left_ui:getChildByName("bg_intro")
	
	UIUserData:call(var_43_2, "AUTOSIZE_HEIGHT(Panel_1/txt_intro, 1, 30)")
	UIUtil:updateTextWrapMode(var_43_1, var_43_0, 20)
	if_set(var_43_1, nil, var_43_0)
	UIAction:Add(SPAWN(LOG(FADE_IN(150)), TARGET(var_43_1, SOUND_TEXT(var_43_0, true))), var_43_2, "talk_balloon")
end

function Friend.onBackButton(arg_44_0)
	SceneManager:popScene()
end

function Friend.setMode(arg_45_0, arg_45_1, arg_45_2)
	if arg_45_1 ~= "Find" and get_cocos_refid(arg_45_0.vars.wnd) and get_cocos_refid(arg_45_0.vars.wnd:getChildByName("input")) then
		arg_45_0.vars.wnd:getChildByName("input"):setString("")
	end
	
	if arg_45_0.vars.mode then
		local var_45_0 = arg_45_0["onLeave" .. arg_45_0.vars.mode .. "Mode"]
		
		if var_45_0 then
			var_45_0(arg_45_0, arg_45_1)
		end
	end
	
	local var_45_1 = arg_45_0["onEnter" .. arg_45_1 .. "Mode"]
	
	if var_45_1 then
		var_45_1(arg_45_0, arg_45_2)
	end
	
	arg_45_0.vars.mode = arg_45_1
end

function Friend.updateRightMenu(arg_46_0)
	local var_46_0 = arg_46_0.vars.wnd:getChildByName("RIGHT")
	
	if_set_visible(var_46_0, "noti_sent", false)
	if_set_visible(var_46_0, "noti_request", false)
	
	if arg_46_0.vars.info.friend_data.sent then
		local var_46_1 = table.count(arg_46_0.vars.info.friend_data.sent)
		
		if var_46_1 > 0 then
			if_set(var_46_0:getChildByName("noti_sent"), "label_count", var_46_1)
			if_set_visible(var_46_0, "noti_sent", true)
		end
	end
	
	if arg_46_0.vars.info.friend_data.received then
		local var_46_2 = table.count(arg_46_0.vars.info.friend_data.received)
		
		if var_46_2 > 0 then
			if_set(var_46_0:getChildByName("noti_request"), "label_count", var_46_2)
			if_set_visible(var_46_0, "noti_request", true)
		end
		
		Account:updateFriendRequested(var_46_2)
	end
end

function Friend.onEnterListMode(arg_47_0)
	arg_47_0.vars.wnd:getChildByName("n_search_list"):setVisible(false)
	
	local var_47_0 = arg_47_0.vars.wnd:getChildByName("n_friend_list")
	
	var_47_0:setVisible(true)
	arg_47_0:toggleListSortMenus(false)
	arg_47_0:updateRightMenuButton("n_list")
	FriendList:show(var_47_0, "List", arg_47_0.vars.info.friend_data.list)
end

function Friend.onLeaveListMode(arg_48_0)
end

function Friend.onEnterFindMode(arg_49_0)
	arg_49_0.vars.wnd:getChildByName("n_friend_list"):setVisible(false)
	
	local var_49_0 = arg_49_0.vars.wnd:getChildByName("n_search_list")
	
	var_49_0:setVisible(true)
	arg_49_0:toggleFindSortMenus(false)
	arg_49_0:updateRightMenuButton("n_find")
	FriendFind:show(var_49_0)
end

function Friend.onLeaveFindMode(arg_50_0)
end

function Friend.onEnterSentMode(arg_51_0)
	local var_51_0 = arg_51_0.vars.wnd:getChildByName("n_friend_list")
	
	var_51_0:setVisible(true)
	arg_51_0.vars.wnd:getChildByName("n_search_list"):setVisible(false)
	arg_51_0:toggleListSortMenus(false)
	arg_51_0:updateRightMenuButton("n_sent")
	FriendList:show(var_51_0, "Sent", arg_51_0.vars.info.friend_data.sent)
end

function Friend.onLeaveSentMode(arg_52_0)
end

function Friend.onEnterReceivedMode(arg_53_0)
	local var_53_0 = arg_53_0.vars.wnd:getChildByName("n_friend_list")
	
	var_53_0:setVisible(true)
	arg_53_0.vars.wnd:getChildByName("n_search_list"):setVisible(false)
	arg_53_0:toggleListSortMenus(false)
	arg_53_0:updateRightMenuButton("n_received")
	FriendList:show(var_53_0, "Received", arg_53_0.vars.info.friend_data.received)
end

function Friend.onLeaveReceivedMode(arg_54_0)
end

function Friend.updateRightMenuButton(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0.vars.wnd:getChildByName("RIGHT")
	
	var_55_0:getChildByName("bg_focus"):setPositionY(var_55_0:getChildByName(arg_55_1):getPositionY())
end

function Friend.friendPointCalculate(arg_56_0, arg_56_1)
	arg_56_0.spc_vars = {}
	arg_56_0.spc_vars.info = Account:acquireCalcFriendPoint()
	
	if not arg_56_0.spc_vars.info or not arg_56_0.spc_vars.info.calc_data then
		return false
	end
	
	if arg_56_0.spc_vars.info.total_friendpoint < 1 or table.count(arg_56_0.spc_vars.info.calc_data) < 1 then
		return false
	end
	
	arg_56_0.spc_vars.wnd = arg_56_1 or SceneManager:getDefaultLayer()
	arg_56_0.spc_vars.dlg = load_dlg("friend_calculate", true, "wnd")
	
	local var_56_0 = {}
	local var_56_1 = 0
	
	for iter_56_0, iter_56_1 in pairs(arg_56_0.spc_vars.info.calc_data) do
		if iter_56_1 then
			var_56_1 = var_56_1 + iter_56_1.friend_count + iter_56_1.guest_count
			var_56_0[tonumber(iter_56_1.unit_id)] = iter_56_1.friend_count + iter_56_1.guest_count
		end
	end
	
	if_set(arg_56_0.spc_vars.dlg, "text_main_desc", T("ui_friend_calculate_desc", {
		point_max = GAME_STATIC_VARIABLE.friend_point_retal_max
	}))
	if_set_arrow(arg_56_0.spc_vars.dlg)
	
	local var_56_2 = arg_56_0.spc_vars.dlg:getChildByName("n_sup_list")
	local var_56_3 = {
		"n_main",
		"n_warrior",
		"n_knight",
		"n_assassin",
		"n_ranger",
		"n_mage",
		"n_manauser"
	}
	
	for iter_56_2, iter_56_3 in pairs(var_56_3) do
		if_set_visible(var_56_2, iter_56_3, false)
	end
	
	local var_56_4 = {}
	local var_56_5 = Account:getTeam(12)
	
	for iter_56_4, iter_56_5 in pairs(var_56_5) do
		if iter_56_5 and var_56_0[iter_56_5.inst.uid] then
			table.push(var_56_4, {
				role = var_56_3[iter_56_4],
				unit = iter_56_5
			})
		end
	end
	
	local var_56_6 = 0
	
	for iter_56_6, iter_56_7 in pairs(var_56_4) do
		local var_56_7 = var_56_2:getChildByName(iter_56_7.role)
		
		var_56_7:setVisible(true)
		
		local var_56_8 = (#var_56_4 - 1) * -150 / 2 + (iter_56_6 - 1) * 150
		
		var_56_7:setPositionX(var_56_8)
		if_set(var_56_7, "t_many", T("friend_use", {
			count = var_56_0[iter_56_7.unit.inst.uid] or 0
		}))
		UIUtil:getUserIcon(iter_56_7.unit, {
			scale = 1.2,
			parent = var_56_7:getChildByName("n_circle_face")
		})
	end
	
	if_set(arg_56_0.spc_vars.dlg, "t_sup_before", T("friend_count_use", {
		count = var_56_1
	}))
	
	local var_56_9 = arg_56_0.spc_vars.dlg:getChildByName("n_reward_fp")
	
	if_set(var_56_9, "t_point", "+" .. arg_56_0.spc_vars.info.total_friendpoint)
	if_set(var_56_9, "t_point_remain", arg_56_0.spc_vars.info.total_friendpoint .. "/" .. GAME_STATIC_VARIABLE.friend_point_retal_max)
	
	if arg_56_0.spc_vars.info.total_friendpoint < GAME_STATIC_VARIABLE.friend_point_retal_max then
		if_set_color(var_56_9, "t_point_remain", cc.c3b(107, 193, 27))
	else
		if_set_color(var_56_9, "t_point_remain", cc.c3b(117, 1, 1))
	end
	
	UIUtil:getRewardIcon(0, "to_friendpoint", {
		no_popup = true,
		scale = 0.7,
		name = false,
		parent = var_56_9:getChildByName("n_icon")
	})
	arg_56_0.spc_vars.wnd:addChild(arg_56_0.spc_vars.dlg)
	
	return true
end

function Friend.closeFriendPointCalculate(arg_57_0)
	if arg_57_0.spc_vars and arg_57_0.spc_vars.wnd and arg_57_0.spc_vars.dlg then
		arg_57_0.spc_vars.wnd:removeChild(arg_57_0.spc_vars.dlg)
		
		arg_57_0.spc_vars = nil
	end
	
	if SceneManager:getCurrentSceneName() == "lobby" then
		Lobby:nextNoti()
	end
end

function Friend.preview(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	Friend:closePreview()
	
	arg_58_0.preview_vars = {}
	arg_58_0.preview_vars.opts = arg_58_3 or {}
	
	if arg_58_2 then
		arg_58_0.preview_vars.wnd = arg_58_2
	end
	
	if (arg_58_0.preview_open_time or 0) + 1 > os.time() then
		balloon_message_with_sound("nickname.check_wait_seconds")
	elseif arg_58_0.preview_vars.opts.preview_data then
		Friend:previewShowPopup(arg_58_3.preview_data)
		
		arg_58_0.preview_vars.opts.preview_data = nil
	elseif arg_58_1 then
		arg_58_0.preview_open_time = os.time()
		
		query("friend_preview", {
			friend_id = arg_58_1
		})
	end
end

function Friend.queryClanPreview(arg_59_0, arg_59_1)
	if not arg_59_0.preview_vars then
		return 
	end
	
	if not arg_59_0.preview_vars.info then
		return 
	end
	
	if not arg_59_0.preview_vars.info.cd then
		return 
	end
	
	if arg_59_0.preview_vars.info.cd.clan_id then
		Clan:queryPreview(arg_59_0.preview_vars.info.cd.clan_id, "preview")
	end
end

function Friend.previewShowPopup(arg_60_0, arg_60_1)
	if arg_60_1.res ~= "ok" or not arg_60_1.preview_data then
		balloon_message_with_sound("friend.invalid_friend")
		
		return 
	end
	
	Friend:closePreview()
	
	if not arg_60_0.preview_vars.wnd or not get_cocos_refid(arg_60_0.preview_vars.wnd) then
		arg_60_0.preview_vars.wnd = SceneManager:getRunningPopupScene()
	end
	
	arg_60_0.preview_vars.info = arg_60_1.preview_data
	
	if not arg_60_0.preview_vars.info.units then
		balloon_message_with_sound("friend.invalid_friend")
		
		return 
	end
	
	arg_60_0.preview_vars.dlg = load_dlg("friend_preview_user", true, "wnd", function()
		Friend:closePreview()
	end)
	
	arg_60_0:updateAccount()
	arg_60_0:updateIgnoreChat()
	
	local var_60_0 = arg_60_0.preview_vars.opts and arg_60_0.preview_vars.opts.from_chat
	local var_60_1 = arg_60_0.preview_vars.dlg:getChildByName("btn_block")
	
	var_60_1:setTouchEnabled(var_60_0)
	if_set_opacity(var_60_1, nil, var_60_0 and 255 or 76.5)
	arg_60_0:updateArena()
	arg_60_0:updateSupportTeam()
	arg_60_0:updateIntro()
	arg_60_0:updateProfileCard()
	arg_60_0:updateBottom()
	SoundEngine:play("event:/ui/popup/tap")
	arg_60_0.preview_vars.wnd:addChild(arg_60_0.preview_vars.dlg)
	arg_60_0.preview_vars.dlg:bringToFront()
end

function Friend.updateAccount(arg_62_0)
	if not arg_62_0.preview_vars or not get_cocos_refid(arg_62_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_62_0.preview_vars.info then
		return 
	end
	
	local var_62_0 = arg_62_0.preview_vars.info.ad
	
	if table.empty(var_62_0) then
		return 
	end
	
	local var_62_1 = arg_62_0.preview_vars.dlg:getChildByName("n_face")
	
	UIUtil:getUserIcon(var_62_0.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_62_1,
		border_code = var_62_0.border_code
	}):setName("@user_icon")
	
	local var_62_2 = arg_62_0.preview_vars.dlg:getChildByName("n_friend")
	
	if get_cocos_refid(var_62_2) then
		if_set(var_62_2, "txt_name", var_62_0.name)
		UIUtil:setLevel(var_62_2:getChildByName("n_lv"), var_62_0.level, MAX_ACCOUNT_LEVEL, 3, false, nil, 18)
		if_set(var_62_2, "txt_friends", T("ui_friends_user_friends", {
			num = to_n(var_62_0.friend_count),
			max = Friend:friend_max(var_62_0.level)
		}))
	end
	
	local var_62_3 = arg_62_0.preview_vars.dlg:getChildByName("n_clan")
	
	if get_cocos_refid(var_62_3) then
		local var_62_4 = arg_62_0.preview_vars.info.cd
		local var_62_5 = not table.empty(var_62_4)
		
		if_set_visible(var_62_3, "n_belong", var_62_5)
		if_set_visible(var_62_3, "n_none", not var_62_5)
		
		if var_62_5 then
			UIUtil:updateClanEmblem(var_62_3, var_62_4)
			
			local var_62_6 = var_62_3:getChildByName("txt_clan")
			
			if_set(var_62_6, nil, T("clan"))
			
			local var_62_7 = var_62_3:getChildByName("txt_clan_name")
			
			UIUtil:updateTextWrapMode(var_62_7, var_62_4.name)
			if_set(var_62_7, nil, var_62_4.name)
			
			local var_62_8 = var_62_3:getChildByName("btn_clan")
			
			if get_cocos_refid(var_62_8) then
				var_62_8:setTouchEnabled(not arg_62_0.preview_vars.opts.is_diff_server)
			end
		else
			local var_62_9 = Clan:getUserMemberInfo()
			local var_62_10 = var_62_3:getChildByName("btn_invite")
			
			if get_cocos_refid(var_62_10) then
				if (var_62_0.level or 1) < (GAME_CONTENT_VARIABLE.clan_invite_req_rank or 10) then
					var_62_10:setOpacity(76.5)
					
					var_62_10.is_lv_limit = true
				elseif var_62_9 then
					if not Clan:isExecutAbleGrade(var_62_9.grade, "clan_invite", {
						remain_time = Clan:getUserMemberInfoGradeLimitsRemainTime("clan_invite")
					}) then
						var_62_10:setOpacity(76.5)
					end
					
					var_62_10.user_id = arg_62_0.preview_vars.info.ad.id
				else
					var_62_10:setOpacity(76.5)
				end
				
				var_62_10:setTouchEnabled(not arg_62_0.preview_vars.opts.is_diff_server)
				if_set_opacity(var_62_10, nil, arg_62_0.preview_vars.opts.is_diff_server and 76.5 or 255)
			end
		end
	end
end

function Friend.updateArena(arg_63_0)
	if not arg_63_0.preview_vars or not get_cocos_refid(arg_63_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_63_0.preview_vars.info then
		return 
	end
	
	local var_63_0 = arg_63_0.preview_vars.info.ad
	
	if table.empty(var_63_0) then
		return 
	end
	
	local var_63_1 = arg_63_0.preview_vars.dlg:getChildByName("n_arena_season")
	
	if get_cocos_refid(var_63_1) then
		local var_63_2 = getExtractedUserOption(var_63_0.opt, 1) == 3
		
		if_set_visible(var_63_1, "icon_etc", false)
		if_set_visible(var_63_1, "n_pvp", false)
		if_set_visible(var_63_1, "n_pvplive", false)
		
		if var_63_2 then
			if_set_visible(var_63_1, "icon_etc", true)
		else
			local var_63_3 = var_63_1:getChildByName("n_pvp")
			
			if get_cocos_refid(var_63_3) then
				local var_63_4
				local var_63_5
				
				if_set_visible(var_63_1, "n_pvp", true)
				
				local var_63_6 = var_63_0.pvp_league
				
				if_set_visible(var_63_3, "n_normal", false)
				if_set_visible(var_63_3, "n_placement", false)
				
				if var_63_6 then
					if_set_visible(var_63_3, "n_normal", true)
					
					local var_63_7 = var_63_3:getChildByName("n_normal")
					local var_63_8 = var_63_7:getChildByName("icon_emblem")
					local var_63_9, var_63_10 = DB("pvp_sa", var_63_6, {
						"name",
						"emblem"
					})
					
					if_set(var_63_7, "txt_arena", T("arena_a_name"))
					SpriteCache:resetSprite(var_63_8, "emblem/" .. var_63_10 .. ".png")
					if_set(var_63_7, "txt_league", T(var_63_9))
				else
					if_set_visible(var_63_3, "n_placement", true)
					
					local var_63_11 = var_63_3:getChildByName("n_placement")
					local var_63_12 = var_63_11:getChildByName("icon_emblem")
					
					if_set(var_63_11, "txt_arena", T("arena_a_name"))
					if_set(var_63_11, "txt_placement", T("pvp_sa_name_bronze_5"))
				end
			end
			
			local var_63_13 = var_63_1:getChildByName("n_pvplive")
			
			if get_cocos_refid(var_63_13) then
				local var_63_14
				local var_63_15
				
				if_set_visible(var_63_1, "n_pvplive", true)
				
				local var_63_16 = var_63_0.world_pvp_league
				
				if_set_visible(var_63_13, "n_normal", false)
				if_set_visible(var_63_13, "n_placement", false)
				
				if var_63_16 then
					if var_63_16 == "draft" then
						if_set_visible(var_63_13, "n_placement", true)
						
						local var_63_17 = var_63_13:getChildByName("n_placement")
						local var_63_18 = var_63_17:getChildByName("icon_emblem")
						
						SpriteCache:resetSprite(var_63_18, "emblem/" .. ARENA_UNRANK_ICON)
						if_set(var_63_17, "txt_arena", T("arena_wa_name"))
						if_set(var_63_17, "txt_placement", T(ARENA_UNRANK_TEXT))
					else
						if_set_visible(var_63_13, "n_normal", true)
						
						local var_63_19 = var_63_13:getChildByName("n_normal")
						local var_63_20 = var_63_19:getChildByName("icon_emblem")
						local var_63_21, var_63_22 = getArenaNetRankInfo(nil, var_63_16)
						
						if var_63_21 and var_63_22 then
							SpriteCache:resetSprite(var_63_20, "emblem/" .. var_63_22 .. ".png")
							if_set(var_63_19, "txt_pvplive", T(var_63_21))
						else
							SpriteCache:resetSprite(var_63_20, "emblem/" .. ARENA_UNRANK_ICON)
							if_set(var_63_19, "txt_pvplive", "")
						end
					end
				else
					if_set_visible(var_63_13, "n_placement", true)
					
					local var_63_23 = var_63_13:getChildByName("n_placement")
					local var_63_24 = var_63_23:getChildByName("icon_emblem")
					
					SpriteCache:resetSprite(var_63_24, "emblem/" .. ARENA_UNRANK_ICON)
					if_set(var_63_23, "txt_arena", T("arena_wa_name"))
					if_set(var_63_23, "txt_placement", T(ARENA_UNRANK_TEXT))
				end
			end
		end
	end
	
	local var_63_25 = arg_63_0.preview_vars.dlg:getChildByName("n_arena_score")
	
	if get_cocos_refid(var_63_25) then
		local var_63_26 = getExtractedUserOption(var_63_0.opt, 2) == 3
		
		if_set_visible(var_63_25, "icon_etc", false)
		if_set_visible(var_63_25, "n_pvp", false)
		if_set_visible(var_63_25, "n_pvplive", false)
		
		if var_63_26 then
			if_set_visible(var_63_25, "icon_etc", true)
		else
			local var_63_27 = var_63_25:getChildByName("n_pvp")
			
			if get_cocos_refid(var_63_27) then
				local var_63_28
				local var_63_29
				
				if_set_visible(var_63_25, "n_pvp", true)
				
				local var_63_30 = var_63_0.max_pvp_league
				
				if_set_visible(var_63_27, "n_normal", false)
				if_set_visible(var_63_27, "n_placement", false)
				
				if var_63_30 then
					if_set_visible(var_63_27, "n_normal", true)
					
					local var_63_31 = var_63_27:getChildByName("n_normal")
					local var_63_32 = var_63_31:getChildByName("icon_emblem")
					local var_63_33, var_63_34 = DB("pvp_sa", var_63_30, {
						"name",
						"emblem"
					})
					
					if_set(var_63_31, "txt_arena", T("arena_a_name"))
					SpriteCache:resetSprite(var_63_32, "emblem/" .. var_63_34 .. ".png")
					if_set(var_63_31, "txt_league", T(var_63_33))
				else
					if_set_visible(var_63_27, "n_placement", true)
					
					local var_63_35 = var_63_27:getChildByName("n_placement")
					
					if_set(var_63_35, "txt_arena", T("arena_a_name"))
					if_set(var_63_35, "txt_placement", T("pvp_sa_name_bronze_5"))
				end
			end
			
			local var_63_36 = var_63_25:getChildByName("n_pvplive")
			
			if get_cocos_refid(var_63_36) then
				local var_63_37
				local var_63_38
				
				if_set_visible(var_63_25, "n_pvplive", true)
				
				local var_63_39 = var_63_0.max_rta_league
				
				if var_63_39 then
					if_set_visible(var_63_36, "n_normal", true)
					
					local var_63_40 = var_63_36:getChildByName("n_normal")
					local var_63_41 = var_63_40:getChildByName("icon_emblem")
					local var_63_42, var_63_43 = DB("pvp_rta", var_63_39, {
						"league_name",
						"emblem"
					})
					
					SpriteCache:resetSprite(var_63_41, "emblem/" .. var_63_43 .. ".png")
					if_set(var_63_40, "txt_pvplive", T(var_63_42))
				else
					if_set_visible(var_63_36, "n_placement", true)
					
					local var_63_44 = var_63_36:getChildByName("n_placement")
					local var_63_45 = var_63_44:getChildByName("icon_emblem")
					
					SpriteCache:resetSprite(var_63_45, "emblem/" .. ARENA_UNRANK_ICON)
					if_set(var_63_44, "txt_arena", T("arena_wa_name"))
					if_set(var_63_44, "txt_placement", T(ARENA_UNRANK_TEXT))
				end
			end
		end
	end
end

function Friend.updateSupportTeam(arg_64_0)
	if not arg_64_0.preview_vars or not get_cocos_refid(arg_64_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_64_0.preview_vars.info then
		return 
	end
	
	local var_64_0 = arg_64_0.preview_vars.info.units
	
	if table.empty(var_64_0) then
		return 
	end
	
	local var_64_1 = {}
	
	for iter_64_0, iter_64_1 in pairs(var_64_0) do
		if iter_64_1.unit then
			var_64_1[iter_64_1.unit.id] = iter_64_1
		end
	end
	
	local var_64_2 = arg_64_0.preview_vars.info.sd
	
	if table.empty(var_64_2) then
		return 
	end
	
	local var_64_3 = arg_64_0.preview_vars.dlg:getChildByName("n_support")
	
	for iter_64_2 = 1, 7 do
		local var_64_4 = var_64_3:getChildByName("n_pos" .. iter_64_2)
		local var_64_5 = var_64_1[var_64_2[iter_64_2]]
		
		if var_64_5 then
			var_64_4:setVisible(true)
			
			local var_64_6 = UNIT:create(var_64_5.unit)
			local var_64_7 = {
				name = false,
				mob_icon2 = true,
				no_popup = false,
				no_lv = false,
				no_grade = false,
				parent = var_64_4,
				role = iter_64_2 ~= 0,
				leader_role = iter_64_2 == 1,
				border_code = var_64_6.border_code,
				zodiac = var_64_6:getZodiacGrade(),
				content_size = {
					width = 55,
					height = 55
				},
				s = var_64_5.unit.s
			}
			
			var_64_7.no_power = true
			var_64_7.no_devote = true
			
			UIUtil:getUserIcon(var_64_6, var_64_7)
		else
			if_set_visible(var_64_3, "n_pos" .. iter_64_2, false)
		end
	end
end

function Friend.updateIntro(arg_65_0)
	if not arg_65_0.preview_vars or not get_cocos_refid(arg_65_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_65_0.preview_vars.info then
		return 
	end
	
	local var_65_0 = arg_65_0.preview_vars.info.ad
	
	if table.empty(var_65_0) then
		return 
	end
	
	local var_65_1 = arg_65_0.preview_vars.dlg:getChildByName("n_message")
	
	if get_cocos_refid(var_65_1) then
		local var_65_2 = var_65_1:getChildByName("txt_message")
		
		if get_cocos_refid(var_65_2) then
			local var_65_3 = var_65_0.intro_msg or T("friend.default_intro_msg")
			
			if_set(var_65_2, nil, var_65_3)
			UIUtil:updateTextWrapMode(var_65_2, var_65_3, 20)
		end
	end
end

function Friend.updateProfileCard(arg_66_0)
	if not arg_66_0.preview_vars or not get_cocos_refid(arg_66_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_66_0.preview_vars.info then
		return 
	end
	
	local var_66_0 = arg_66_0.preview_vars.info.ad
	
	if table.empty(var_66_0) then
		return 
	end
	
	local var_66_1 = arg_66_0.preview_vars.dlg:getChildByName("n_custom_card")
	
	if get_cocos_refid(var_66_1) then
		local var_66_2
		local var_66_3 = arg_66_0.preview_vars.info.p_c
		local var_66_4 = arg_66_0.preview_vars.info.ad_f
		
		if not var_66_3 then
			var_66_2 = CustomProfileCard:create({
				is_default = true,
				leader_code = var_66_0.leader_code,
				face_id = var_66_4 or 0
			})
		elseif SAVE:getOptionData("option.profile_off", default_options.profile_off) == true then
			var_66_2 = CustomProfileCard:create({
				is_default = true,
				leader_code = var_66_0.leader_code,
				face_id = var_66_4 or 0
			})
		else
			var_66_2 = CustomProfileCard:create({
				card_data = var_66_3
			})
		end
		
		if var_66_2 then
			local var_66_5 = var_66_2:getWnd()
			
			if get_cocos_refid(var_66_5) then
				var_66_1:addChild(var_66_5)
			end
		end
	end
end

function Friend.updateBottom(arg_67_0)
	if not arg_67_0.preview_vars or not get_cocos_refid(arg_67_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_67_0.preview_vars.info then
		return 
	end
	
	local var_67_0 = arg_67_0.preview_vars.info.ad
	
	if table.empty(var_67_0) then
		return 
	end
	
	local var_67_1 = arg_67_0.preview_vars.dlg
	
	if_set(var_67_1, "txt_last", T("friend_logout_2"))
	if_set(var_67_1, "txt_time", T("friend_logout_3", {
		time = sec_to_string(os.time() - var_67_0.login_tm)
	}))
	
	arg_67_0.preview_vars.can_ask_invite = false
	
	local var_67_2 = SceneManager:getCurrentSceneName()
	
	if var_67_2 == "arena_net_lounge" or var_67_2 == "arena_net_ready" then
		arg_67_0.preview_vars.can_ask_invite = true
		
		if ArenaService:getUserUID() ~= ArenaService:getHost() or ArenaService:isInInviteList(var_67_0.id) then
			if_set_opacity(var_67_1, "btn_battle", 76.5)
		else
			if_set_opacity(var_67_1, "btn_battle", 255)
		end
	else
		if_set_opacity(var_67_1, "btn_battle", 76.5)
	end
	
	if arg_67_0.preview_vars.opts and arg_67_0.preview_vars.opts.off_battle_btn then
		if_set_visible(var_67_1, "btn_battle", false)
	end
	
	local var_67_3 = arg_67_0.preview_vars.info.fd
	local var_67_4 = var_67_1:getChildByName("n_request")
	
	if_set_visible(var_67_4, "btn_request", true)
	if_set_visible(var_67_4, "n_fin", false)
	
	local var_67_5 = false
	local var_67_6 = var_67_3 and var_67_3.cond == "D"
	
	if var_67_3 and not var_67_6 then
		if_set_visible(var_67_4, "btn_request", false)
		if_set_visible(var_67_4, "n_fin", true)
		
		if var_67_3.cond == "F" then
			if_set(var_67_4:getChildByName("n_fin"), "txt_fin", T("my_friend"))
		elseif var_67_3.cond == "R" then
			if_set(var_67_4:getChildByName("n_fin"), "txt_fin", T("friend_req_recv"))
		elseif var_67_3.cond == "S" then
			if_set(var_67_4:getChildByName("n_fin"), "txt_fin", T("friend_req_sent"))
		else
			local var_67_7 = true
		end
	end
	
	local var_67_8 = var_67_1:getChildByName("btn_battle")
	
	if get_cocos_refid(var_67_8) then
		var_67_8:setTouchEnabled(not arg_67_0.preview_vars.opts.is_diff_server)
		if_set_opacity(var_67_8, nil, arg_67_0.preview_vars.opts.is_diff_server and 76.5 or 255)
	end
	
	local var_67_9 = var_67_1:getChildByName("btn_request")
	
	if get_cocos_refid(var_67_9) then
		var_67_9:setTouchEnabled(not arg_67_0.preview_vars.opts.is_diff_server)
		if_set_opacity(var_67_9, nil, arg_67_0.preview_vars.opts.is_diff_server and 76.5 or 255)
	end
end

function Friend.inviteClan(arg_68_0, arg_68_1)
	if not Account:getClanId() then
		balloon_message_with_sound("msg_clan_invite_no_clan_user")
	end
	
	if arg_68_1.is_lv_limit then
		balloon_message_with_sound("msg_clan_invite_req_rank")
		
		return 
	end
	
	if arg_68_1.invite_err_text then
		balloon_message_with_sound(arg_68_1.invite_err_text)
		
		return 
	end
	
	arg_68_1:setOpacity(76.5)
	
	local var_68_0 = Clan:queryInvite(arg_68_1.user_id, arg_68_1)
end

function Friend.setInviteErrText(arg_69_0, arg_69_1)
	if not arg_69_0.preview_vars then
		return 
	end
	
	if not get_cocos_refid(arg_69_0.preview_vars.dlg) then
		return 
	end
	
	local var_69_0 = arg_69_0.preview_vars.dlg:getChildByName("n_clan")
	
	if not get_cocos_refid(var_69_0) then
		return 
	end
	
	local var_69_1 = arg_69_0.preview_vars.dlg:getChildByName("btn_invite")
	
	if not get_cocos_refid(var_69_1) then
		return 
	end
	
	var_69_1.invite_err_text = arg_69_1
end

function Friend.inviteLounge(arg_70_0)
	if not arg_70_0.preview_vars.can_ask_invite then
		balloon_message_with_sound("pvp_rta_mock_need_make_room")
		
		return 
	end
	
	MatchService:inviteUser(arg_70_0.preview_vars.info.ad, function(arg_71_0)
		if not arg_70_0.preview_vars or not get_cocos_refid(arg_70_0.preview_vars.dlg) then
			return 
		end
		
		if arg_71_0 then
			if_set_color(arg_70_0.preview_vars.dlg, "btn_battle", cc.c3b(75, 75, 75))
		else
			if_set_color(arg_70_0.preview_vars.dlg, "btn_battle", cc.c3b(255, 255, 255))
		end
	end)
end

function Friend.setIgnoreChat(arg_72_0, arg_72_1)
	ChatMain:setIgnoreChatUser(arg_72_0.preview_vars.info.ad.id, arg_72_1)
	arg_72_0:updateIgnoreChat()
	
	local var_72_0 = arg_72_1 and "chat_ignore_chat_clear" or "chat_ignore_chat_cancel"
	
	balloon_message_with_sound(var_72_0)
end

function Friend.updateIgnoreChat(arg_73_0)
	if not arg_73_0.preview_vars or not get_cocos_refid(arg_73_0.preview_vars.dlg) then
		return 
	end
	
	if not arg_73_0.preview_vars.info then
		return 
	end
	
	local var_73_0 = arg_73_0.preview_vars.info.ad
	
	if table.empty(var_73_0) then
		return 
	end
	
	local var_73_1 = var_73_0.id
	local var_73_2 = arg_73_0.preview_vars.dlg
	
	if ContentDisable:byAlias("chat") or var_73_1 == Account:getUserId() then
		if_set_visible(var_73_2, "n_ignore_chat", false)
	else
		if_set_visible(var_73_2, "n_ignore_chat", true)
		
		if ChatMain:isIgnoreChatUser(var_73_1) then
			if_set_visible(var_73_2, "btn_ignore_chat", false)
			if_set_visible(var_73_2, "btn_unlock_ignore_chat", true)
		else
			if_set_visible(var_73_2, "btn_ignore_chat", true)
			if_set_visible(var_73_2, "btn_unlock_ignore_chat", false)
		end
	end
	
	local var_73_3 = var_73_2:getChildByName("btn_ignore_chat")
	
	if get_cocos_refid(var_73_3) then
		var_73_3:setTouchEnabled(not arg_73_0.preview_vars.opts.is_diff_server)
		if_set_opacity(var_73_3, nil, arg_73_0.preview_vars.opts.is_diff_server and 76.5 or 255)
	end
	
	local var_73_4 = var_73_2:getChildByName("btn_unlock_ignore_chat")
	
	if get_cocos_refid(var_73_4) then
		var_73_4:setTouchEnabled(not arg_73_0.preview_vars.opts.is_diff_server)
		if_set_opacity(var_73_4, nil, arg_73_0.preview_vars.opts.is_diff_server and 76.5 or 255)
	end
end

function Friend.previewFriendRequest(arg_74_0)
	if not arg_74_0.preview_vars or arg_74_0.preview_vars.requested then
		return 
	end
	
	arg_74_0.preview_vars.requested = true
	
	local var_74_0 = arg_74_0.preview_vars.dlg:getChildByName("n_request")
	
	if_set_visible(var_74_0, "btn_request", false)
	if_set_visible(var_74_0, "n_fin", true)
	if_set(var_74_0:getChildByName("n_fin"), "txt_fin", T("friend_req_sent"))
	
	if arg_74_0.vars and arg_74_0.vars.mode == "Find" then
		query("friend_request", {
			need_friend_update = 1,
			friend_id = arg_74_0.preview_vars.info.ad.id
		})
	else
		local var_74_1 = 1
		
		if SceneManager:getCurrentSceneName() ~= "friend" then
			var_74_1 = 0
		end
		
		query("friend_request", {
			friend_id = arg_74_0.preview_vars.info.ad.id,
			need_friend_update = var_74_1
		})
	end
end

function Friend.closePreview(arg_75_0)
	if arg_75_0.preview_vars and get_cocos_refid(arg_75_0.preview_vars.wnd) and get_cocos_refid(arg_75_0.preview_vars.dlg) then
		BackButtonManager:pop({
			dlg = arg_75_0.preview_vars.dlg
		})
		arg_75_0.preview_vars.wnd:removeChild(arg_75_0.preview_vars.dlg)
		
		arg_75_0.preview_vars.dlg = nil
		arg_75_0.preview_vars.wnd = nil
	end
end

function Friend.closeToggleMenus(arg_76_0)
	arg_76_0:toggleListSortMenus(false)
	arg_76_0:toggleFindSortMenus(false)
end

function Friend.reportChat(arg_77_0)
	Dialog:msgBox(T("chat_accuse_popup_desc_zl"), {
		yesno = true,
		title = T("chat_accuse_popup_title"),
		yes_text = T("chat_accuse_popup_ok"),
		handler = function()
			local var_78_0 = 0
			
			if IS_PUBLISHER_ZLONG and arg_77_0.preview_vars then
				var_78_0 = arg_77_0.preview_vars.info.ad.level
			end
			
			ChatMain:reportChat(var_78_0)
		end,
		cancel_handler = function()
		end
	})
end

FriendList = {}

copy_functions(ScrollView, FriendList)

function FriendList.clear(arg_80_0)
	arg_80_0.vars = nil
end

function FriendList.show(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	if arg_81_0.vars and get_cocos_refid(arg_81_0.vars.parent) then
		arg_81_0:jumpToPercent(0)
		
		arg_81_0.vars.mode = arg_81_2
		
		if arg_81_3 then
			arg_81_0:update(arg_81_3)
		end
		
		return 
	end
	
	arg_81_0.vars = {}
	arg_81_0.vars.parent = arg_81_1
	arg_81_0.vars.mode = arg_81_2
	arg_81_0.vars.scrollview = arg_81_1:getChildByName("scrollview")
	
	arg_81_0:initScrollView(arg_81_0.vars.scrollview, 700, 130)
	
	if arg_81_3 then
		arg_81_0:update(arg_81_3)
	end
	
	arg_81_0:jumpToPercent(0)
end

function FriendList.update(arg_82_0, arg_82_1)
	arg_82_0.vars.friend_list = arg_82_0.vars.friend_list or {}
	
	if arg_82_1 then
		arg_82_0.vars.friend_list = arg_82_1
	end
	
	local var_82_0 = Friend.vars.sort_menu_list_order
	
	if Friend.vars.sort_menu_list_index == 1 then
		table.sort(arg_82_0.vars.friend_list, function(arg_83_0, arg_83_1)
			if var_82_0 then
				return arg_83_0.ad.level > arg_83_1.ad.level
			end
			
			return arg_83_0.ad.level < arg_83_1.ad.level
		end)
	elseif Friend.vars.sort_menu_list_index == 2 then
		table.sort(arg_82_0.vars.friend_list, function(arg_84_0, arg_84_1)
			if var_82_0 then
				return arg_84_0.ad.login_tm > arg_84_1.ad.login_tm
			end
			
			return arg_84_0.ad.login_tm < arg_84_1.ad.login_tm
		end)
	elseif Friend.vars.sort_menu_list_index == 3 then
		table.sort(arg_82_0.vars.friend_list, function(arg_85_0, arg_85_1)
			if var_82_0 then
				return arg_85_0.fd.updated > arg_85_1.fd.updated
			end
			
			return arg_85_0.fd.updated < arg_85_1.fd.updated
		end)
	end
	
	if_set_visible(arg_82_0.vars.parent, "n_list_none", table.count(arg_82_0.vars.friend_list) < 1)
	arg_82_0:createScrollViewItems(arg_82_0.vars.friend_list)
end

function FriendList.getScrollViewItem(arg_86_0, arg_86_1)
	local var_86_0 = load_dlg("friend_card", true, "wnd")
	local var_86_1
	
	if arg_86_0.vars.mode == "List" then
		var_86_1 = load_control("wnd/friend_card_remove.csb")
		
		local var_86_2 = var_86_1:getChildByName("btn_bg")
		
		var_86_2:setName("btn_bg:" .. arg_86_1.ad.id)
		
		var_86_2.friend_name = arg_86_1.ad.name
		
		var_86_1:getChildByName("btn_user_info"):setName("btn_user_info:" .. arg_86_1.ad.id)
	elseif arg_86_0.vars.mode == "Sent" then
		var_86_1 = load_control("wnd/friend_card_sent.csb")
		
		var_86_1:getChildByName("btn_cancel"):setName("btn_cancel:" .. arg_86_1.ad.id)
		var_86_1:getChildByName("btn_user_info"):setName("btn_user_info:" .. arg_86_1.ad.id)
	elseif arg_86_0.vars.mode == "Received" then
		var_86_1 = load_control("wnd/friend_card_received.csb")
		
		var_86_1:getChildByName("btn_user_deny"):setName("btn_user_deny:" .. arg_86_1.ad.id)
		var_86_1:getChildByName("btn_user_acept"):setName("btn_user_acept:" .. arg_86_1.ad.id)
		var_86_1:getChildByName("btn_user_info"):setName("btn_user_info:" .. arg_86_1.ad.id)
	end
	
	if var_86_1 then
		var_86_0:addChild(var_86_1)
	end
	
	if_set(var_86_0, "txt_friend_name", arg_86_1.ad.name)
	
	if get_cocos_refid(var_86_0) then
		local var_86_3 = UIUtil:numberDigitToCharOffset(arg_86_1.ad.level, 1, 0)
		
		UIUtil:warpping_setLevel(var_86_0:getChildByName("n_friend_lv"), arg_86_1.ad.level, MAX_ACCOUNT_LEVEL, 2, {
			offset_per_char = var_86_3
		})
	end
	
	local var_86_4 = var_86_0:getChildByName("talk_small_bg")
	local var_86_5 = arg_86_1.ad.intro_msg or T("friend.default_intro_msg")
	
	if var_86_5 then
		if utf8len(var_86_5) > 30 then
			var_86_5 = utf8sub(var_86_5, 1, 30) .. "..."
		end
		
		if_set(var_86_4, "disc", var_86_5)
		set_width_from_node(var_86_4, var_86_4:getChildByName("disc"), {
			add = 40
		})
	else
		var_86_4:setVisible(false)
	end
	
	if_set(var_86_0, "last_time", T("time_before", {
		time = sec_to_string(math.max(os.time() - arg_86_1.ad.login_tm, 0), nil, {
			login_tm = true
		})
	}))
	UIUtil:getUserIcon(arg_86_1.ad.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1.2,
		no_grade = true,
		parent = var_86_0:getChildByName("n_friend_face"),
		border_code = arg_86_1.ad.border_code
	})
	
	return var_86_0
end

function FriendList.onSelectScrollViewItem(arg_87_0, arg_87_1, arg_87_2)
end

FriendFind = {}

copy_functions(ScrollView, FriendFind)

function FriendFind.clear(arg_88_0)
	arg_88_0.vars = nil
end

function FriendFind.show(arg_89_0, arg_89_1, arg_89_2, arg_89_3)
	if arg_89_0.vars and get_cocos_refid(arg_89_0.vars.parent) then
		arg_89_0:jumpToPercent(0)
		
		if arg_89_2 then
			arg_89_0.vars.mode = arg_89_2
		end
		
		if arg_89_3 then
			arg_89_0:update(arg_89_3)
		end
		
		return 
	end
	
	arg_89_0.vars = {}
	arg_89_0.vars.parent = arg_89_1
	
	if arg_89_2 then
		arg_89_0.vars.mode = arg_89_2
	end
	
	if not arg_89_0.vars.mode then
		arg_89_0.vars.mode = "Recommend"
	end
	
	arg_89_0.vars.scrollview = arg_89_1:getChildByName("scrollview_search")
	
	arg_89_0:initScrollView(arg_89_0.vars.scrollview, 700, 130)
	
	if arg_89_3 then
		arg_89_0:update(arg_89_3)
	elseif arg_89_0.vars.mode == "Recommend" then
		if not Friend.vars.info.friend_data.recommend then
			Friend:recommendRefresh()
			
			return 
		end
		
		arg_89_0:update(Friend.vars.info.friend_data.recommend)
	end
	
	arg_89_0:jumpToPercent(0)
end

function FriendFind.update(arg_90_0, arg_90_1, arg_90_2)
	if not arg_90_0.vars or not get_cocos_refid(arg_90_0.vars.parent) then
		return 
	end
	
	arg_90_0.vars.friend_list = arg_90_0.vars.friend_list or {}
	
	if arg_90_1 then
		arg_90_0.vars.friend_list = arg_90_1
	end
	
	if arg_90_2 then
		arg_90_0.vars.mode = arg_90_2
	end
	
	if arg_90_0.vars.mode == "Find" then
		if_set(arg_90_0.vars.parent, "sub_title", T("friend_searched"))
	else
		if_set(arg_90_0.vars.parent, "sub_title", T("friend_suggest"))
	end
	
	if_set_visible(arg_90_0.vars.parent, "n_search_none", table.count(arg_90_0.vars.friend_list) < 1)
	arg_90_0:createScrollViewItems(arg_90_0.vars.friend_list)
end

function FriendFind.getScrollViewItem(arg_91_0, arg_91_1)
	local var_91_0 = load_dlg("friend_card", true, "wnd")
	local var_91_1 = load_control("wnd/friend_card_recommend.csb")
	
	var_91_0:addChild(var_91_1)
	if_set(var_91_0, "txt_friend_name", arg_91_1.name)
	
	if get_cocos_refid(var_91_0) then
		local var_91_2 = UIUtil:numberDigitToCharOffset(arg_91_1.level, 1, 0)
		
		UIUtil:warpping_setLevel(var_91_0:getChildByName("n_friend_lv"), arg_91_1.level, MAX_ACCOUNT_LEVEL, 2, {
			offset_per_char = var_91_2
		})
	end
	
	local var_91_3 = var_91_0:getChildByName("talk_small_bg")
	local var_91_4 = arg_91_1.intro_msg or T("friend.default_intro_msg")
	
	if var_91_4 then
		if utf8len(var_91_4) > 30 then
			var_91_4 = utf8sub(var_91_4, 1, 30) .. "..."
		end
		
		if_set(var_91_3, "disc", var_91_4)
		set_width_from_node(var_91_3, var_91_3:getChildByName("disc"), {
			add = 40
		})
	else
		var_91_3:setVisible(false)
	end
	
	if_set(var_91_0, "last_time", T("time_before", {
		time = sec_to_string(os.time() - arg_91_1.login_tm)
	}))
	
	if arg_91_1.mark_requested == nil then
		if_set_visible(var_91_0, "n_fin", false)
		var_91_0:getChildByName("btn_req_friend"):setName("btn_req_friend:" .. arg_91_1.id)
	else
		if_set_visible(var_91_0, "btn_req_friend", false)
		if_set_visible(var_91_0, "n_fin", true)
	end
	
	var_91_0:getChildByName("btn_user_info"):setName("btn_user_info:" .. arg_91_1.id)
	UIUtil:getUserIcon(arg_91_1.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1.2,
		no_grade = true,
		parent = var_91_0:getChildByName("n_friend_face"),
		border_code = arg_91_1.border_code
	})
	
	return var_91_0
end

function FriendFind.setFriendRequested(arg_92_0, arg_92_1)
	for iter_92_0, iter_92_1 in pairs(arg_92_0.ScrollViewItems or {}) do
		if iter_92_1.item.id == tonumber(arg_92_1) and get_cocos_refid(iter_92_1.control:getChildByName("btn_req_friend:" .. iter_92_1.item.id)) then
			if_set_visible(iter_92_1.control, "n_fin", true)
			iter_92_1.control:getChildByName("btn_req_friend:" .. iter_92_1.item.id):setName("btn_req_friend")
			if_set_visible(iter_92_1.control, "btn_req_friend", false)
		end
	end
end

function FriendFind.onSelectScrollViewItem(arg_93_0, arg_93_1, arg_93_2)
end
