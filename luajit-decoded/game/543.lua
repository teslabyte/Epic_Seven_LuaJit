UIOption = {}
UIOption.vars = {}
default_options = {
	blur_off = false,
	push_forest = true,
	prevent_off_while_battle = true,
	push_operating = true,
	push_stamina = true,
	popupskip = false,
	fps60 = false,
	profile_off = false,
	push_subtask = true,
	push_connect = true,
	high_def = false,
	push_orbis = true,
	haptic_vib = false,
	skip_5 = true,
	touch_off = false,
	gacha_bro_off = false,
	push_daily = true,
	always_on = false,
	view_mode = false,
	skip_4 = true,
	battle_end_vib = false,
	push_night = true,
	adaptive_fps = true
}

local var_0_0 = 0

local function var_0_1()
	local var_1_0 = getenv("allow.language")
	
	if var_1_0 then
		local var_1_1 = string.split(var_1_0, ",")
		
		if table.find(var_1_1, "ja") then
			return true
		end
	end
end

function remove_all_local_push()
	for iter_2_0, iter_2_1 in pairs(LOCAL_PUSH_IDS) do
		cancel_local_push(iter_2_1)
	end
end

local function var_0_2()
	return SceneManager:getCurrentSceneName() == "battle" or SceneManager:getCurrentSceneName() == "world_boss" or SceneManager:getCurrentSceneName() == "rumble" or SceneManager:getCurrentSceneName() == "mini_volley_ball" or SceneManager:getCurrentSceneName() == "mini_cook" or SceneManager:getCurrentSceneName() == "mini_repair" or UIOption:isStoryMode()
end

local function var_0_3(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_account_center" then
		Zlong:openUserCenter()
		
		return 
	end
	
	if arg_4_1 == "btn_account_information" then
		Zlong:openGeneralWebView({
			title_flag = 1,
			action = "privacy",
			fullscreen_flag = 1
		})
		
		return 
	end
	
	if arg_4_1 == "btn_notification" then
		Zlong:openGeneralWebView({
			title_flag = 2,
			action = "notice",
			fullscreen_flag = 2
		})
		
		return 
	end
	
	if arg_4_1 == "btn_privacy" then
		Dialog:msgBox(T("account_privacy_policy_withdrawal_popup_desc"), {
			yesno = true,
			title = T("account_privacy_policy_withdrawal_popup_title"),
			handler = function()
				Zlong:cleanPrivacy()
			end
		})
		
		return 
	end
	
	if arg_4_1 == "btn_normal_account" then
		if Stove:checkStandbyAndBalloonMessage() then
			Login.FSM:changeState(LoginState.STOVE_MANAGE_ACCOUNT, {
				callback = function()
					UIOption:refreshNormalCategoryAccountInfoText()
				end
			})
		end
		
		return 
	end
	
	if arg_4_1 == "btn_disable_when_battle" then
		if UIOption:isStoryMode() then
			balloon_message_with_sound("theater_story_close_balloon")
		else
			balloon_message_with_sound("cant_use_battle")
		end
		
		return 
	end
	
	if arg_4_1 == "btn_normal_logout" then
		UIOption:proc_logout()
		
		return 
	end
	
	if arg_4_1 == "btn_normal_unregister" then
		UIOption:proc_unregister()
		
		return 
	end
	
	if arg_4_1 == "btn_normal_leave" then
		UIOption:proc_leave_account()
		
		return 
	end
	
	if arg_4_1 == "btn_support_inquiry" then
		if Zlong.enable then
			Zlong:openGeneralWebView({
				title_flag = 2,
				action = "faq",
				fullscreen_flag = 1,
				callback = function(arg_7_0)
					UIOption:updateZlongRedDot(arg_7_0)
				end
			})
		elseif Stove:checkStandbyAndBalloonMessage() then
			Login.FSM:changeState(LoginState.STOVE_CUSTOMER_SUPPORT)
		end
		
		return 
	end
	
	if arg_4_1 == "btn_google" or arg_4_1 == "btn_ios" then
		ThirdPartySocial:ShowAchievements()
		
		return 
	end
	
	if arg_4_1 == "btn_support_calendar" then
		if SceneManager:getCurrentSceneName() == "lobby" then
			local var_4_0 = Account:getEvents().attendance or {}
			
			if var_4_0[1] then
				local var_4_1 = {
					option = true
				}
				
				if table.count(var_4_0) > 1 then
					var_4_1.current = 1
					var_4_1.calendar_count = table.count(var_4_0)
				end
				
				UIOption:close()
				Lobby:showAttendanceEvent(var_4_0[1], var_4_1)
			end
		else
			balloon_message_with_sound("msg_checkinreward_btn_error")
		end
		
		return 
	end
	
	if arg_4_1 == "btn_normal_server" then
		UIOption:showSelectServer(true)
		
		return 
	end
	
	if string.starts(arg_4_1, "btn_select_server_") then
		UIOption:onSelectServer(arg_4_0.region)
		
		return 
	end
	
	if arg_4_1 == "btn_close_select_server" then
		UIOption:showSelectServer(false)
		
		return 
	end
	
	if arg_4_1 == "btn_money_info" then
		UIOption:showMoneyInfo(true)
		
		return 
	end
	
	if arg_4_1 == "btn_close_select_moneyinfo" then
		UIOption:showMoneyInfo(false)
		
		return 
	end
	
	if arg_4_1 == "btn_license" then
		query("app_license")
		
		return 
	end
	
	if arg_4_1 == "btn_copy" and Stove.user_data.user_info and Stove.user_data.user_info.user and Stove.user_data.user_info.user.memberNumber then
		local var_4_2 = tostring(Stove.user_data.user_info.user.memberNumber)
		
		if copy_to_clipboard(var_4_2) then
			balloon_message_with_sound("msg_clipboard_copy")
		end
	end
end

local function var_0_4(arg_8_0, arg_8_1)
	if string.starts(arg_8_1, "btn_none") or string.starts(arg_8_1, "btn_central") or string.starts(arg_8_1, "btn_corner") then
		UIOption:onSetNotchButton(arg_8_1)
	end
	
	if string.starts(arg_8_1, "btn_close_") then
		UIOption:onTouchDropBox(string.sub(arg_8_1, #"btn_close_" + 1, -1), false)
		
		return 
	end
	
	if arg_8_1 == "btn_sound" or arg_8_1 == "btn_mute" then
		UIOption:toggleMute(arg_8_0)
		
		return 
	end
	
	if UIOption:isStoryMode() and (arg_8_1 == "btn_basic_settings" or arg_8_1 == "btn_noti_settings" or arg_8_1 == "btn_summon_settings") then
		balloon_message_with_sound("theater_story_close_balloon")
		
		return 
	end
	
	if (SceneManager:getCurrentSceneName() == "world_boss" or SceneManager:getCurrentSceneName() == "rumble") and (arg_8_1 == "btn_basic_settings" or arg_8_1 == "btn_noti_settings" or arg_8_1 == "btn_summon_settings") then
		balloon_message_with_sound("cant_use_battle")
		
		return 
	end
	
	if string.starts(arg_8_1, "btn_") then
		local var_8_0 = string.sub(arg_8_1, #"btn_" + 1, -1)
		
		if UIOption.touch_check_boxs[var_8_0] then
			UIOption:onTouchOptionButton(var_8_0)
		elseif IS_ANDROID_PC and var_8_0 == "noti_settings" then
			balloon_message(T("msg_option_disable_push_gpg_pc"))
		else
			UIOption:onTouchDropBox(var_8_0, true)
		end
		
		return 
	end
	
	if string.starts(arg_8_1, "check_box_") then
		UIOption:onTouchCheckBox(string.sub(arg_8_1, #"check_box_" + 1, -1))
	end
end

local function var_0_5()
	return "n_select_media_all"
end

local function var_0_6(arg_10_0)
	local var_10_0 = UIOption.vars.wnd:getChildByName("language_opt")
	local var_10_1 = var_10_0:getChildByName("n_language")
	local var_10_2 = UIOption:getLanguageOptionNode()
	local var_10_3 = var_10_0:getChildByName("n_media")
	local var_10_4 = var_10_3:getChildByName(var_0_5())
	
	if get_cocos_refid(var_10_1) then
		if var_10_2:isVisible() then
			if arg_10_0 == "btn_close_select" then
				var_10_2:setVisible(false)
			elseif string.starts(arg_10_0, "btn_select_") then
				UIOption:changeLanguage(string.sub(arg_10_0, #"btn_select_" + 1, -1))
			end
		elseif var_10_4:isVisible() then
			if arg_10_0 == "btn_close_select" then
				var_10_4:setVisible(false)
			elseif string.starts(arg_10_0, "btn_select_") then
				UIOption:changeMedia(string.sub(arg_10_0, #"btn_select_" + 1, -1))
			end
		elseif arg_10_0 == "btn_disable_when_battle" then
			if UIOption:isStoryMode() then
				balloon_message_with_sound("theater_story_close_balloon")
			else
				balloon_message_with_sound("cant_use_battle")
			end
		elseif arg_10_0 == "btn_support_language" then
			var_10_1:bringToFront()
			var_10_2:setVisible(true)
		elseif arg_10_0 == "btn_support_media" then
			var_10_3:bringToFront()
			var_10_4:setVisible(true)
		end
	elseif var_10_4:isVisible() then
		if arg_10_0 == "btn_close_select" then
			var_10_4:setVisible(false)
		elseif string.starts(arg_10_0, "btn_select_") then
			UIOption:changeMedia(string.sub(arg_10_0, #"btn_select_" + 1, -1))
		end
	elseif arg_10_0 == "btn_disable_when_battle" then
		if UIOption:isStoryMode() then
			balloon_message_with_sound("theater_story_close_balloon")
		else
			balloon_message_with_sound("cant_use_battle")
		end
	elseif arg_10_0 == "btn_support_media" then
		var_10_3:bringToFront()
		var_10_4:setVisible(true)
	end
end

function HANDLER.option_select_item(arg_11_0, arg_11_1)
	var_0_6(arg_11_1)
end

function HANDLER.option(arg_12_0, arg_12_1)
	if ContentDisable:byButton(arg_12_1) then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if not PRODUCTION_MODE and arg_12_1 == "btn_close_door" then
		if var_0_0 == 7 then
			if open_cheat_scene then
				open_cheat_scene()
			end
		elseif var_0_0 == 70 and DebugConsole then
			DebugConsole:show()
		end
	end
	
	if arg_12_1 == "btn_close_door" or arg_12_1 == "btn_close" then
		UIOption:close()
		
		return 
	end
	
	if string.starts(arg_12_1, "btn_category_") then
		local var_12_0 = string.sub(arg_12_1, 14, -1)
		
		UIOption:showCategory(var_12_0)
		
		if var_12_0 == "normal" then
			var_0_0 = var_0_0 + 1
		elseif var_12_0 == "game" then
			var_0_0 = var_0_0 + 10
		end
		
		return 
	end
	
	local var_12_1 = UIOption.vars.wnd:getChildByName("normal_opt")
	local var_12_2 = UIOption.vars.wnd:getChildByName("game_opt")
	local var_12_3 = UIOption.vars.wnd:getChildByName("language_opt")
	
	if var_12_1:isVisible() then
		var_0_3(arg_12_0, arg_12_1)
		
		return 
	end
	
	if var_12_2:isVisible() then
		var_0_4(arg_12_0, arg_12_1)
		
		return 
	end
	
	if var_12_3:isVisible() then
		var_0_6(arg_12_1)
		
		return 
	end
	
	balloon_message_with_sound("notyet_dev")
end

function HANDLER.account_reset_p(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_cancel" then
		UIOption:closeUnregisterDlg()
	elseif arg_13_1 == "btn_ok" then
		if not UIOption.vars.btn_ok_unregister.isEnable then
			balloon_message_with_sound("reset_text_wrong")
			
			return 
		end
		
		Dialog:msgBox("\n\n" .. T("unregister_last_check"), {
			yesno = true,
			title = T("unregister"),
			warning = T("unregister_last_question"),
			handler = function()
				if Stove.enable then
					Login.FSM:changeState(LoginState.STOVE_SERVER_DELETE_CHARACTER)
				else
					Login.FSM:changeState(LoginState.LOGOUT)
				end
			end
		})
	end
end

function HANDLER.account_leave_p(arg_15_0, arg_15_1)
	if arg_15_1 == "btn_cancel" then
		UIOption:closeLeaveAccountDlg()
	elseif arg_15_1 == "btn_ok" then
		if not UIOption.vars.btn_ok_leave_account.isEnable then
			balloon_message_with_sound("account_cancel_text_wrong")
			
			return 
		end
		
		Dialog:msgBox("\n\n" .. T("account_cancel_confirm_desc01"), {
			yesno = true,
			title = T("account_cancel_confirm_title"),
			warning = T("account_cancel_confirm_desc02"),
			handler = function()
				if Stove.enable then
					Login.FSM:changeState(LoginState.STOVE_SERVER_UNREGISTER)
				else
					Login.FSM:changeState(LoginState.LOGOUT)
				end
			end
		})
	end
end

function MsgHandler.crystal_detail_info(arg_17_0)
	UIOption:showMoneyInfoDetail(arg_17_0)
end

function MsgHandler.app_license(arg_18_0)
	table.print(arg_18_0)
	
	if arg_18_0.app_license then
		local var_18_0
		
		if IS_ANDROID_BASED_PLATFORM then
			var_18_0 = arg_18_0.app_license.android
		elseif PLATFORM == "iphoneos" then
			var_18_0 = arg_18_0.app_license.ios
		else
			balloon_message("It doesn't work on Win32 client")
		end
		
		if var_18_0 and Stove:checkStandbyAndBalloonMessage() then
			Login.FSM:changeState(LoginState.STOVE_VIEW_URL, {
				url = var_18_0
			})
		end
	end
end

function UIOption.getLanguageOptionNode(arg_19_0)
	if IS_PUBLISHER_ZLONG then
		return 
	end
	
	if arg_19_0.vars.language_option_node then
		return arg_19_0.vars.language_option_node
	end
	
	if arg_19_0.vars.support_language_list == nil then
		return nil
	end
	
	arg_19_0.vars.language_option_node = arg_19_0.vars.wnd:getChildByName("combo_box_language")
	
	local var_19_0 = table.count(arg_19_0.vars.support_language_list)
	local var_19_1 = math.round(var_19_0 * 0.5)
	local var_19_2 = 46
	local var_19_3 = var_19_2 * math.round(var_19_0 * 0.5)
	local var_19_4 = arg_19_0.vars.language_option_node:getChildByName("bg")
	
	var_19_4:setContentSize({
		width = var_19_4:getContentSize().width,
		height = var_19_3 + 95
	})
	arg_19_0.vars.language_option_node:getChildByName("bar_l"):setContentSize({
		height = 17,
		width = var_19_3 + 11
	})
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.support_language_list or {}) do
		local var_19_5 = load_dlg("option_select_item", true, "wnd")
		
		arg_19_0.vars.language_option_node:addChild(var_19_5)
		if_set(var_19_5, "txt_sort", T("display_language_" .. iter_19_1))
		var_19_5:setAnchorPoint(0, 0)
		var_19_5:getChildByName("btn_select"):setName("btn_select_" .. iter_19_1)
		
		local var_19_6 = 6
		local var_19_7 = -(var_19_2 * iter_19_0) + 2
		
		if var_19_1 < iter_19_0 then
			var_19_6 = 268
			var_19_7 = -((iter_19_0 - var_19_1) * var_19_2) + 2
		end
		
		var_19_5:setPosition(var_19_6, var_19_7)
	end
	
	return arg_19_0.vars.language_option_node
end

function UIOption.settingNotchNodes(arg_20_0)
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("select_notch_buttons")
	local var_20_1 = {
		"none",
		"central",
		"corner"
	}
	local var_20_2 = SAVE:getOptionData("notch_setting", "none")
	
	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		if_set_visible(var_20_0, "bg_" .. iter_20_1, false)
	end
	
	if_set_visible(var_20_0, "bg_" .. var_20_2, true)
end

function UIOption.onSetNotchButton(arg_21_0, arg_21_1)
	local var_21_0 = string.sub(arg_21_1, #"btn_" + 1, -1)
	
	SAVE:setUserDefaultData("notch_setting", var_21_0)
	arg_21_0:settingNotchNodes()
	NotchStatus:settingNotch()
	reload_scene()
	NotchManager:event(true)
	arg_21_0:updateNotchUI()
end

function UIOption.onTouchDropBox(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("n_" .. arg_22_1)
	local var_22_1 = arg_22_0.vars.wnd:getChildByName("n_checkbox_" .. arg_22_1)
	
	if not var_22_0 then
		return 
	end
	
	if_set_visible(var_22_0, nil, arg_22_2)
	if_set_visible(var_22_1, nil, arg_22_2)
	
	if arg_22_1 == "select_notch" then
		arg_22_0:settingNotchNodes()
	end
end

function UIOption.updateNotchUI(arg_23_0)
	local var_23_0 = arg_23_0.vars.wnd:getChildByName("btn_none")
	local var_23_1 = arg_23_0.vars.wnd:getChildByName("btn_central")
	local var_23_2 = arg_23_0.vars.wnd:getChildByName("btn_corner")
	
	if_set(var_23_0, "label", T("ui_option_notch_setting1"))
	if_set(var_23_1, "label", T("ui_option_notch_setting2"))
	if_set(var_23_2, "label", T("ui_option_notch_setting3"))
	
	local var_23_3 = arg_23_0.vars.wnd:getChildByName("btn_select_notch")
	local var_23_4 = SAVE:getOptionData("notch_setting", "none")
	local var_23_5 = {
		corner = "ui_option_notch_setting3",
		central = "ui_option_notch_setting2",
		none = "ui_option_notch_setting1"
	}
	
	if_set(var_23_3, "label", T("ui_option_notch_btn", {
		notch_setting = T(var_23_5[var_23_4])
	}))
	
	if not var_23_3 then
		return 
	end
	
	local var_23_6 = var_23_3:getChildByName("label")
	local var_23_7 = var_23_3:getChildByName("icon_arr")
	
	if not var_23_6 or not var_23_7 then
		return 
	end
	
	local var_23_8 = var_23_6:getContentSize()
	
	var_23_7:setPositionX(var_23_8.width / 2)
	
	local var_23_9 = PLATFORM == "win32"
	
	if_set_visible(arg_23_0.vars.wnd, "btn_select_notch", var_23_9)
	if_set_visible(arg_23_0.vars.wnd, "t_title_notch", var_23_9)
end

function UIOption.updateLanguageUI(arg_24_0, arg_24_1)
	arg_24_1 = arg_24_1 or getUserLanguage() or "ko"
	
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("n_language")
	
	if not get_cocos_refid(var_24_0) then
		return 
	end
	
	local var_24_1 = var_24_0:getChildByName("btn_support_language")
	
	if not get_cocos_refid(var_24_1) then
		return 
	end
	
	local var_24_2 = var_24_1:getChildByName("label")
	
	if not get_cocos_refid(var_24_2) then
		return 
	end
	
	var_24_2:setString(T("ui_option_account_btn_language") .. ": " .. T("display_language_" .. arg_24_1))
	
	local var_24_3 = arg_24_0:getLanguageOptionNode()
	
	if not get_cocos_refid(var_24_3) then
		return 
	end
	
	local var_24_4 = "btn_select_"
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.support_language_list) do
		local var_24_5 = var_24_4 .. iter_24_1
		local var_24_6 = var_24_3:getChildByName(var_24_5)
		
		if_set_visible(var_24_6, "cursor_select", var_24_5 == var_24_4 .. arg_24_1)
	end
end

function UIOption.changeLanguage(arg_25_0, arg_25_1)
	if_set_visible(arg_25_0.vars.wnd, "combo_box_language", false)
	
	if not (getUserLanguage() ~= arg_25_1) then
		return 
	end
	
	Dialog:msgBox(T("language_change_desc"), {
		yesno = true,
		title = T("language_change_title"),
		handler = function()
			set_user_language(arg_25_1)
			invalidate_language_cache()
			restart_contents()
		end
	})
end

function UIOption.updateMediaUI(arg_27_0, arg_27_1)
	arg_27_1 = arg_27_1 or getMediaLanguage() or "ko"
	
	if arg_27_1 == "zht" then
		arg_27_1 = "en"
	end
	
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("n_media")
	
	if not get_cocos_refid(var_27_0) then
		return 
	end
	
	local var_27_1 = var_27_0:getChildByName("btn_support_media")
	
	if not get_cocos_refid(var_27_1) then
		return 
	end
	
	local var_27_2 = var_27_1:getChildByName("label")
	
	if not get_cocos_refid(var_27_2) then
		return 
	end
	
	var_27_2:setString(T("media_change_title") .. ": " .. T("display_media_language_" .. arg_27_1))
	
	local var_27_3 = var_27_1:getChildByName(var_0_5())
	
	if not get_cocos_refid(var_27_3) then
		return 
	end
	
	local var_27_4 = "btn_select_"
	local var_27_5 = "cursor_select_"
	local var_27_6 = var_27_3:getChildren()
	
	for iter_27_0, iter_27_1 in pairs(var_27_6) do
		if iter_27_1:getName():sub(1, #var_27_4) == var_27_4 then
			local var_27_7 = iter_27_1:getName():sub(1 + #var_27_4, iter_27_1:getName():len())
			
			print("button_media : ", var_27_7)
			
			local var_27_8 = var_27_5 .. var_27_7
			local var_27_9 = iter_27_1:getChildByName(var_27_8)
			
			if get_cocos_refid(var_27_9) then
				var_27_9:setVisible(var_27_8 == var_27_5 .. arg_27_1)
			end
		end
	end
end

function UIOption.changeMedia(arg_28_0, arg_28_1)
	if_set_visible(arg_28_0.vars.wnd, var_0_5(), false)
	
	local var_28_0 = getMediaLanguage()
	
	if not (var_28_0 ~= arg_28_1) then
		return 
	end
	
	if var_28_0 == "en" and arg_28_1 == "zht" or var_28_0 == "zht" and arg_28_1 == "en" then
		return 
	end
	
	Dialog:msgBox(T("media_change_desc"), {
		yesno = true,
		title = T("media_change_title"),
		handler = function()
			setenv("patch.local.lang", arg_28_1)
			invalidate_language_cache()
			reset_patch()
			restart_contents()
		end
	})
end

function UIOption.proc_logout(arg_30_0)
	if Login.FSM:isCurrentState("TICKET_WAIT") or Stove:checkStandbyAndBalloonMessage() then
		Dialog:msgBox(T("unregister_logout"), {
			yesno = true,
			title = T("logout", "STOVE LOGOUT"),
			handler = function()
				if IS_PUBLISHER_ZLONG then
					Login.FSM:changeState(LoginState.LOGOUT)
					
					return 
				end
				
				Dialog:msgBox(string.format(T("unregister_type_logout"), Stove:getStoveAccountType(true)), {
					yesno = true,
					title = T("logout", "STOVE LOGOUT"),
					handler = function()
						if Stove.enable then
							Login.FSM:changeState(LoginState.STOVE_LOGOUT)
						else
							Login.FSM:changeState(LoginState.LOGOUT)
						end
					end
				})
			end
		})
	end
end

function UIOption.closeUnregisterDlg(arg_33_0)
	if arg_33_0.vars and get_cocos_refid(arg_33_0.vars.unregister_dlg) then
		UIAction:Add(SEQ(FADE_OUT(400), REMOVE()), arg_33_0.vars.unregister_dlg, "block")
		
		arg_33_0.vars.btn_ok_unregister = nil
		
		BackButtonManager:pop("account_reset_p")
	end
end

function UIOption.proc_unregister(arg_34_0)
	if Clan:isMaster() then
		balloon_message_with_sound("cant_unregister_clanmaster")
		
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	arg_34_0.vars.unregister_dlg = load_dlg("account_reset_p", true, "wnd", function()
		UIOption:closeUnregisterDlg()
	end)
	
	if arg_34_0.vars.wnd then
		arg_34_0.vars.wnd:addChild(arg_34_0.vars.unregister_dlg)
	else
		SceneManager:getDefaultLayer():addChild(arg_34_0.vars.unregister_dlg)
	end
	
	arg_34_0.vars.unregister_dlg:bringToFront()
	if_set(arg_34_0.vars.unregister_dlg, "txt_server", T("account_reset_server", {
		server = T(Login:getRegion() .. "_server")
	}))
	if_set(arg_34_0.vars.unregister_dlg, "txt_user_name", T("account_reset_nickname", {
		nickname = Account:getName(true)
	}))
	
	local var_34_0 = arg_34_0.vars.unregister_dlg:getChildByName("txt_name_input")
	
	arg_34_0.vars.btn_ok_unregister = arg_34_0.vars.unregister_dlg:getChildByName("btn_ok")
	
	arg_34_0.vars.btn_ok_unregister:setOpacity(76.5)
	
	local function var_34_1()
		if get_cocos_refid(arg_34_0.vars.btn_ok_unregister) then
			arg_34_0.vars.btn_ok_unregister.isEnable = Account:getName(true) == string.trim(var_34_0:getString())
			
			arg_34_0.vars.btn_ok_unregister:setOpacity(arg_34_0.vars.btn_ok_unregister.isEnable and 255 or 76.5)
		end
	end
	
	var_34_1()
	Scheduler:removeByName("@unregister_update_btn")
	
	Scheduler:addInterval(arg_34_0.vars.btn_ok_unregister, 500, var_34_1).name = "@unregister_update_btn"
end

function UIOption.closeLeaveAccountDlg(arg_37_0)
	if arg_37_0.vars and get_cocos_refid(arg_37_0.vars.leave_account_dlg) then
		UIAction:Add(SEQ(FADE_OUT(400), REMOVE()), arg_37_0.vars.leave_account_dlg, "block")
		
		arg_37_0.vars.btn_ok_leave_account = nil
		
		BackButtonManager:pop("account_reset_p")
	end
end

function UIOption.proc_leave_account(arg_38_0)
	if Clan:isMaster() then
		balloon_message_with_sound("cant_unregister_clanmaster")
		
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	arg_38_0.vars.leave_account_dlg = load_dlg("account_leave_p", true, "wnd")
	
	if arg_38_0.vars.wnd then
		arg_38_0.vars.wnd:addChild(arg_38_0.vars.leave_account_dlg)
	else
		SceneManager:getDefaultLayer():addChild(arg_38_0.vars.leave_account_dlg)
	end
	
	arg_38_0.vars.leave_account_dlg:bringToFront()
	upgradeLabelToRichLabel(arg_38_0.vars.leave_account_dlg, "txt_disc")
	arg_38_0.vars.leave_account_dlg:findChildByName("txt_disc"):setAlignment(cc.TEXT_ALIGNMENT_CENTER)
	if_set(arg_38_0.vars.leave_account_dlg, "txt_disc", T("account_cancel_guide_desc"))
	
	local var_38_0 = arg_38_0.vars.leave_account_dlg:getChildByName("txt_name_input")
	
	arg_38_0.vars.btn_ok_leave_account = arg_38_0.vars.leave_account_dlg:getChildByName("btn_ok")
	
	arg_38_0.vars.btn_ok_leave_account:setOpacity(76.5)
	
	local function var_38_1()
		if get_cocos_refid(arg_38_0.vars.btn_ok_leave_account) then
			arg_38_0.vars.btn_ok_leave_account.isEnable = T("account_cancel_confirm_word") == string.trim(var_38_0:getString())
			
			arg_38_0.vars.btn_ok_leave_account:setOpacity(arg_38_0.vars.btn_ok_leave_account.isEnable and 255 or 76.5)
		end
	end
	
	var_38_1()
	Scheduler:removeByName("@account_cancel_update_btn")
	
	Scheduler:addInterval(arg_38_0.vars.btn_ok_leave_account, 500, var_38_1).name = "@account_cancel_update_btn"
end

function UIOption.close(arg_40_0)
	if arg_40_0.vars and get_cocos_refid(arg_40_0.vars.wnd) then
		UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_40_0.vars.wnd, "block")
	end
	
	if SoundEngine:getVolume("bgm") == 0.2 and SoundEngine:getVolume("battle") == 0.15 and SoundEngine:getVolume("ui") == 0.08 and SoundEngine:getVolume("voice") == 0.12 then
		_tst_cr()
	end
	
	if arg_40_0.vars.opts and arg_40_0.vars.opts.close_callback then
		arg_40_0.vars.opts.close_callback()
	end
	
	BackButtonManager:pop("Dialog.option")
	
	arg_40_0.vars = {}
end

function UIOption.clear(arg_41_0)
	arg_41_0:setBlock(false)
end

function UIOption.isVisible(arg_42_0)
	return arg_42_0.vars and get_cocos_refid(arg_42_0.vars.wnd)
end

function UIOption.bringToFront(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	arg_43_0.vars.wnd:bringToFront()
end

function UIOption.show(arg_44_0, arg_44_1)
	arg_44_1 = arg_44_1 or {}
	var_0_0 = 0
	
	if arg_44_0:isBlock() == true then
		if arg_44_1 and arg_44_1.close_callback then
			arg_44_1.close_callback()
		end
		
		balloon_message_with_sound("can_not_open_option")
		
		return 
	end
	
	local var_44_0 = arg_44_1.category or "normal"
	local var_44_1 = arg_44_1.layer or SceneManager:getRunningNativeScene()
	local var_44_2 = Dialog:open("wnd/option", arg_44_0, {
		back_func = function()
			UIOption:close()
		end
	})
	
	arg_44_0.vars = {}
	arg_44_0.vars.layer = var_44_1
	arg_44_0.vars.wnd = var_44_2
	arg_44_0.vars.opts = arg_44_1
	
	var_44_1:addChild(var_44_2)
	
	if IS_PUBLISHER_ZLONG then
		arg_44_0:replaceZlongCategory()
		arg_44_0:replaceZlongOption()
	end
	
	arg_44_0:initAccountCategory()
	arg_44_0:initGameCategory()
	arg_44_0:initLanguageCategory()
	
	if IS_PUBLISHER_ZLONG then
		arg_44_0:updateZlongRedDot(false)
		Zlong:reqIsRedDotFaq({
			repeat_limit_duration = 60,
			callback = function(arg_46_0)
				arg_44_0:updateZlongRedDot(arg_46_0)
			end
		})
	end
	
	;(function()
		if IS_PUBLISHER_ZLONG then
			return 
		end
		
		local var_47_0 = arg_44_0.vars.wnd:getChildByName("btn_support_language")
		
		if not get_cocos_refid(var_47_0) then
			return 
		end
		
		local var_47_1 = table.count(arg_44_0.vars.support_language_list) > 1
		
		var_47_0:setTouchEnabled(var_47_1)
		if_set_opacity(var_47_0, nil, var_47_1 and 255 or 76.5)
	end)()
	if_set_visible(arg_44_0.vars.wnd, "btn_help", true)
	
	local var_44_3 = arg_44_0.vars.wnd:getChildByName("normal_opt")
	
	if_set_visible(var_44_3, "n_account1", false)
	if_set_visible(var_44_3, "n_account2", true)
	
	local var_44_4 = UIOption:isStoryMode() or SceneManager:getCurrentSceneName() == "world_boss" or SceneManager:getCurrentSceneName() == "rumble"
	local var_44_5 = arg_44_0.vars.wnd:getChildByName("game_opt")
	
	if_set_opacity(var_44_5, "btn_basic_settings", var_44_4 and 76.5 or 255)
	if_set_opacity(var_44_5, "btn_noti_settings", var_44_4 and 76.5 or 255)
	if_set_opacity(var_44_5, "btn_summon_settings", var_44_4 and 76.5 or 255)
	arg_44_0:showCategory(var_44_0)
	
	if IS_ANDROID_PC then
		local var_44_6 = arg_44_0.vars.wnd:getChildByName("game_opt")
		
		if_set_opacity(var_44_6, "btn_noti_settings", 76.5)
	end
end

function UIOption.isStoryMode(arg_48_0)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) then
		return 
	end
	
	return arg_48_0.vars.opts and arg_48_0.vars.opts.story_mode
end

function UIOption.replaceZlongCategory(arg_49_0)
	local var_49_0 = arg_49_0.vars.wnd:getChildByName("category_normal")
	
	if get_cocos_refid(var_49_0) then
		var_49_0:removeFromParent()
		
		local var_49_1
	end
	
	local var_49_2 = arg_49_0.vars.wnd:getChildByName("category_normal_zl")
	
	if get_cocos_refid(var_49_2) then
		var_49_2:setName("category_normal")
		if_set_visible(var_49_2, nil, true)
	end
	
	local var_49_3 = arg_49_0.vars.wnd:getChildByName("category_language")
	
	if get_cocos_refid(var_49_3) then
		var_49_3:removeFromParent()
		
		local var_49_4
	end
	
	local var_49_5 = arg_49_0.vars.wnd:getChildByName("category_language_zl")
	
	if get_cocos_refid(var_49_5) then
		var_49_5:setName("category_language")
		if_set_visible(var_49_5, nil, true)
	end
end

function UIOption.isVisibleZlongAccountCenterButton(arg_50_0)
	if not IS_PUBLISHER_ZLONG then
		return false
	end
	
	return getenv("channel_id", "") == "1000000002"
end

function UIOption.replaceZlongOption(arg_51_0)
	local var_51_0 = arg_51_0.vars.wnd:getChildByName("normal_opt")
	
	if get_cocos_refid(var_51_0) then
		local var_51_1 = var_51_0:getChildByName("n_account")
		
		if get_cocos_refid(var_51_1) then
			var_51_1:removeFromParent()
			
			local var_51_2
		end
		
		local var_51_3 = var_51_0:getChildByName("n_account_zl")
		
		if not get_cocos_refid(var_51_3) then
			return 
		end
		
		var_51_3:setName("n_account")
		if_set_visible(var_51_3, nil, true)
		if_set_visible(var_51_3, "btn_account_center", arg_51_0:isVisibleZlongAccountCenterButton())
	end
	
	local var_51_4 = arg_51_0.vars.wnd:getChildByName("language_opt")
	
	if get_cocos_refid(var_51_4) then
		var_51_4:removeFromParent()
		
		local var_51_5
	end
	
	local var_51_6 = arg_51_0.vars.wnd:getChildByName("language_opt_zl")
	
	if get_cocos_refid(var_51_6) then
		var_51_6:setName("language_opt")
	end
end

function UIOption.updateZlongRedDot(arg_52_0, arg_52_1)
	if not arg_52_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_52_0.vars.wnd) then
		return 
	end
	
	local var_52_0 = arg_52_0.vars.wnd:getChildByName("category_normal")
	
	if_set_visible(var_52_0, "icon_noti", arg_52_1)
	
	local var_52_1 = arg_52_0.vars.wnd:getChildByName("normal_opt")
	
	if not get_cocos_refid(var_52_1) then
		return 
	end
	
	local var_52_2 = var_52_1:getChildByName("n_account")
	
	if not get_cocos_refid(var_52_2) then
		return 
	end
	
	local var_52_3 = var_52_2:getChildByName("btn_support_inquiry")
	
	if not get_cocos_refid(var_52_3) then
		return 
	end
	
	if_set_visible(var_52_3, "icon_noti", arg_52_1)
end

function UIOption.isCalenderEnable()
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		return false
	end
	
	if DungeonHome:isVisible() then
		return false
	end
	
	if ShopRandom:isVisible() then
		return false
	end
	
	if Destiny:isVisible() then
		return false
	end
	
	if Bistro:isVisible() then
		return false
	end
	
	return true
end

function UIOption.initAccountCategory(arg_54_0)
	local var_54_0 = arg_54_0.vars.wnd:getChildByName("normal_opt")
	
	if_set_visible(var_54_0, "btn_normal_server", not Stove:isGuestAccount() and getenv("is_review", "") ~= "1")
	arg_54_0:showSelectServer(false)
	if_set_visible(var_54_0, "btn_disable_when_battle", var_0_2())
	if_set_opacity(var_54_0, "btn_support_calendar", 255 * (arg_54_0:isCalenderEnable() and 1 or 0.3))
	if_set_visible(var_54_0, "btn_support_calendar", true)
	if_set_visible(var_54_0, "n_money_info", false)
	if_set_visible(var_54_0, "btn_money_info", true)
end

function UIOption.initGameCategory(arg_55_0)
	local var_55_0 = arg_55_0.vars.wnd:getChildByName("game_opt")
	local var_55_1 = var_55_0:getChildByName("master_slider")
	local var_55_2 = var_55_0:getChildByName("bgm_slider")
	local var_55_3 = var_55_0:getChildByName("battle_slider")
	local var_55_4 = var_55_0:getChildByName("ui_slider")
	local var_55_5 = var_55_0:getChildByName("voice_slider")
	
	UIUtil:initProgress(var_55_1, {
		per = SoundEngine:getVolume("master"),
		handler = function(arg_56_0, arg_56_1, arg_56_2)
			SoundEngine:setVolumeMaster(arg_56_1 / 100)
			SoundEngine:updateBGM()
			
			if arg_56_2 then
				SAVE:setUserDefaultData("sound.vol_master", arg_56_1 / 100)
			end
		end
	})
	UIUtil:initProgress(var_55_2, {
		per = SoundEngine:getVolume("bgm"),
		handler = function(arg_57_0, arg_57_1, arg_57_2)
			SoundEngine:setVolumeBGM(arg_57_1 / 100, UIOption:isStoryMode())
			
			if arg_57_2 then
				SAVE:setUserDefaultData("sound.vol_bgm", arg_57_1 / 100)
			end
		end
	})
	UIUtil:initProgress(var_55_3, {
		per = SoundEngine:getVolume("battle"),
		handler = function(arg_58_0, arg_58_1, arg_58_2)
			SoundEngine:setVolumeBattle(arg_58_1 / 100)
			
			if arg_58_2 then
				SAVE:setUserDefaultData("sound.vol_battle", arg_58_1 / 100)
			end
		end
	})
	UIUtil:initProgress(var_55_4, {
		per = SoundEngine:getVolume("ui"),
		handler = function(arg_59_0, arg_59_1, arg_59_2)
			SoundEngine:setVolumeUI(arg_59_1 / 100)
			
			if arg_59_2 then
				SAVE:setUserDefaultData("sound.vol_ui", arg_59_1 / 100)
			end
		end
	})
	UIUtil:initProgress(var_55_5, {
		per = SoundEngine:getVolume("voice"),
		handler = function(arg_60_0, arg_60_1, arg_60_2)
			SoundEngine:setVolumeVoice(arg_60_1 / 100)
			
			if arg_60_2 then
				SAVE:setUserDefaultData("sound.vol_voice", arg_60_1 / 100)
			end
		end
	})
	arg_55_0:updateNotchUI()
	arg_55_0:updateCheckboxs()
end

function UIOption.initLanguageCategory(arg_61_0)
	local var_61_0 = arg_61_0.vars.wnd:getChildByName("language_opt")
	
	if_set_visible(var_61_0, "combo_box_language", false)
	
	local var_61_1 = var_0_2()
	
	if_set_visible(var_61_0, "btn_disable_when_battle", var_61_1)
	
	local var_61_2 = string.split(getenv("allow.language", ""), ",")
	local var_61_3 = get_os_language()
	
	arg_61_0.vars.support_language_list = {
		var_61_3
	}
	
	for iter_61_0, iter_61_1 in pairs(var_61_2 or {}) do
		if iter_61_1 ~= var_61_3 then
			table.insert(arg_61_0.vars.support_language_list, iter_61_1)
		end
	end
	
	;(function()
		local var_62_0 = arg_61_0.vars.wnd:getChildByName("btn_support_language")
		
		if not get_cocos_refid(var_62_0) then
			return 
		end
		
		local var_62_1 = table.count(arg_61_0.vars.support_language_list) > 1
		
		var_62_0:setTouchEnabled(var_62_1)
		if_set_opacity(var_62_0, nil, var_62_1 and 255 or 76.5)
	end)()
	arg_61_0:updateLanguageUI()
	arg_61_0:updateMediaUI()
end

function UIOption.isShow(arg_63_0)
	if arg_63_0.vars and get_cocos_refid(arg_63_0.vars.wnd) then
		return true
	end
end

function UIOption.showMoneyInfo(arg_64_0, arg_64_1)
	if arg_64_0.vars and get_cocos_refid(arg_64_0.vars.wnd) then
		local var_64_0 = arg_64_0.vars.wnd:getChildByName("n_money_info")
		
		if arg_64_1 then
			if arg_64_0.vars.crystal_info then
				arg_64_0:showMoneyInfoDetail()
			else
				query("crystal_detail_info")
			end
		else
			var_64_0:setVisible(false)
		end
	end
end

function UIOption.showMoneyInfoDetail(arg_65_0, arg_65_1)
	if arg_65_0.vars and get_cocos_refid(arg_65_0.vars.wnd) then
		if arg_65_1 then
			arg_65_0.vars.crystal_info = arg_65_1
		end
		
		if arg_65_0.vars.crystal_info and arg_65_0.vars.crystal_info.free and arg_65_0.vars.crystal_info.paid then
			local var_65_0 = arg_65_0.vars.wnd:getChildByName("n_money_info")
			
			var_65_0:setVisible(true)
			if_set(var_65_0, "txt_paid_count", comma_value(arg_65_0.vars.crystal_info.paid))
			if_set(var_65_0, "txt_free_count", comma_value(arg_65_0.vars.crystal_info.free))
			if_set(var_65_0, "txt_total_count", comma_value(arg_65_0.vars.crystal_info.paid + arg_65_0.vars.crystal_info.free))
		end
	end
end

function UIOption.showSelectServer(arg_66_0, arg_66_1)
	local var_66_0, var_66_1
	
	if arg_66_0.vars and get_cocos_refid(arg_66_0.vars.wnd) then
		if_set_visible(arg_66_0.vars.wnd, "n_select_server_eu", false)
		
		var_66_0 = arg_66_0.vars.wnd:getChildByName("n_select_server")
		
		if var_66_0 then
			var_66_0:setVisible(arg_66_1)
			
			if arg_66_1 then
				var_66_1 = Stove:getServerList()
				
				if not arg_66_0.vars.adjust_world_select_ui then
					local var_66_2 = var_66_0:findChildByName("server_select_frame")
					
					if var_66_2 then
						local var_66_3 = var_66_2:getContentSize()
						local var_66_4 = (MAX_REGION_COUNT - table.count(var_66_1)) * 43
						
						var_66_2:setContentSize(var_66_3.width, var_66_3.height - var_66_4)
						var_66_0:setPositionY(var_66_0:getPositionY() - var_66_4)
						
						arg_66_0.vars.adjust_world_select_ui = true
					end
				end
				
				for iter_66_0 = 1, MAX_REGION_COUNT do
					local var_66_5 = var_66_1[iter_66_0]
					local var_66_6 = var_66_0:getChildByName("btn_select_server_" .. iter_66_0)
					
					if var_66_5 then
						local var_66_7 = var_66_5.region
						
						if var_66_6 then
							var_66_6:setVisible(true)
							
							var_66_6.region = var_66_7
							
							var_66_6:getChildByName("bg_select_server_" .. tostring(iter_66_0)):setVisible(Login:getRegion() == var_66_7)
							print("region text : ", var_66_7, T(var_66_7 .. "_server"))
							if_set(var_66_6, "label_select_server_" .. tostring(iter_66_0), T(var_66_7 .. "_server"))
						end
					else
						if_set_visible(var_66_6, nil, false)
					end
				end
			end
		end
	end
end

function UIOption.onSelectServer(arg_67_0, arg_67_1)
	print("onSelectServer", arg_67_1)
	
	if Login:getRegion() ~= arg_67_1 then
		Dialog:msgBox(T("question_server_change", "서버를 설정을 변경하시려면 게임을 재시작 해야 합니다.\n계속 하시겠습니까?"), {
			yesno = true,
			cancel_handler = function()
				arg_67_0:showSelectServer(false)
			end,
			handler = function()
				setenv("needChangeRegion", arg_67_1)
				SAVE:setUserDefaultData("main_quest_progress", "ep1")
				SAVE:destroy()
				delete_info()
				restart_contents()
			end
		})
	end
end

function UIOption.showNormalCategory(arg_70_0)
	if_set_visible(arg_70_0.vars.wnd, "btn_google", PLATFORM == "android")
	if_set_visible(arg_70_0.vars.wnd, "btn_ios", PLATFORM == "iphoneos")
	arg_70_0:refreshNormalCategoryAccountInfoText()
end

function UIOption.refreshNormalCategoryAccountInfoText(arg_71_0)
	if not arg_71_0.vars or not get_cocos_refid(arg_71_0.vars.wnd) then
		return 
	end
	
	local var_71_0 = arg_71_0.vars.wnd:getChildByName("n_account")
	
	if get_cocos_refid(var_71_0) then
		if_set(var_71_0, "t_account", T("account_type"))
		if_set(var_71_0, "txt_account_type", tostring(Stove:getStoveAccountType(true)))
	end
	
	local var_71_1 = arg_71_0.vars.wnd:getChildByName("n_stove")
	
	if get_cocos_refid(var_71_1) then
		if_set(var_71_1, "t_stove", T("stove_member_number"))
		
		if Stove.user_data.user_info and Stove.user_data.user_info.user and Stove.user_data.user_info.user.memberNumber then
			if_set(var_71_1, "t_stove_number", Stove.user_data.user_info.user.memberNumber)
		end
	end
	
	local var_71_2 = arg_71_0.vars.wnd:getChildByName("n_server")
	
	if get_cocos_refid(var_71_2) then
		if_set(var_71_2, "t_server", T("server"))
		
		if Login:getRegion() then
			if_set(var_71_2, "label", T(Login:getRegion() .. "_server"))
		end
	end
	
	local var_71_3 = arg_71_0.vars.wnd:getChildByName("n_server_account_number")
	
	if get_cocos_refid(var_71_3) then
		if_set(var_71_3, "t_server_account_number", T("account_number"))
		
		local var_71_4 = "#" .. AccountData.user_number
		
		if IS_PUBLISHER_ZLONG then
			var_71_4 = var_71_4 .. ":" .. Zlong:getZlongServerName()
		end
		
		if_set(var_71_3, "txt_epic7_id", var_71_4)
	end
	
	local var_71_5 = arg_71_0.vars.wnd:getChildByName("n_version")
	
	if get_cocos_refid(var_71_5) then
		local var_71_6 = T("game_version") .. string.format(": %s\n%s", getAppVersionString(), getPatchVersionString())
		
		if_set(var_71_5, "txt_version_info", var_71_6)
	end
end

function UIOption.isMute(arg_72_0, arg_72_1)
	return SAVE:getUserDefaultData("sound.mute_" .. arg_72_1, false)
end

function UIOption.setMute(arg_73_0, arg_73_1, arg_73_2)
	SoundEngine:setMute(arg_73_1, arg_73_2)
	SAVE:setUserDefaultData("sound.mute_" .. arg_73_1, arg_73_2)
end

function UIOption.toggleMute(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_1:getParent()
	
	if not get_cocos_refid(var_74_0) then
		return 
	end
	
	local var_74_1 = var_74_0:getParent()
	
	if not get_cocos_refid(var_74_1) then
		return 
	end
	
	local var_74_2 = string.split(var_74_1:getName(), "_")[1]
	
	arg_74_0:setMute(var_74_2, not arg_74_0:isMute(var_74_2))
	arg_74_0:showVolume(var_74_2)
end

function UIOption.showVolume(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_1 .. "_slider"
	local var_75_1 = arg_75_0.vars.wnd:getChildByName(var_75_0)
	
	if not get_cocos_refid(var_75_1) then
		return 
	end
	
	local var_75_2 = arg_75_0:isMute(arg_75_1)
	
	UIUtil:equalizeProgress(var_75_1, {
		reset = true,
		per = SoundEngine:getVolume(arg_75_1) * 100,
		enable = not var_75_2
	})
	if_set_visible(var_75_1, "btn_sound", not var_75_2)
	if_set_visible(var_75_1, "btn_mute", var_75_2)
end

function UIOption.showGameCategory(arg_76_0)
	arg_76_0:showVolume("master")
	arg_76_0:showVolume("bgm")
	arg_76_0:showVolume("battle")
	arg_76_0:showVolume("ui")
	arg_76_0:showVolume("voice")
	
	local var_76_0 = arg_76_0.vars.wnd:getChildByName("check_box_push_night")
	
	if getUserLanguage() ~= "ko" and var_76_0:isVisible() then
		local var_76_1 = arg_76_0.vars.wnd:getChildByName("check_box_push_connect")
		local var_76_2 = arg_76_0.vars.wnd:getChildByName("check_box_push_subtask")
		local var_76_3 = arg_76_0.vars.wnd:getChildByName("check_box_push_forest")
		local var_76_4 = arg_76_0.vars.wnd:getChildByName("check_box_push_orbis")
		local var_76_5 = arg_76_0.vars.wnd:getChildByName("check_box_push_stamina")
		
		var_76_1:setPositionY(var_76_2:getPositionY())
		var_76_2:setPositionY(var_76_3:getPositionY())
		var_76_3:setPositionY(var_76_4:getPositionY())
		var_76_4:setPositionY(var_76_5:getPositionY())
		var_76_5:setPositionY(var_76_0:getPositionY())
		var_76_0:setVisible(false)
		
		local var_76_6 = arg_76_0.vars.wnd:getChildByName("btn_push_connect")
		local var_76_7 = arg_76_0.vars.wnd:getChildByName("btn_push_subtask")
		local var_76_8 = arg_76_0.vars.wnd:getChildByName("btn_push_forest")
		local var_76_9 = arg_76_0.vars.wnd:getChildByName("btn_push_orbis")
		local var_76_10 = arg_76_0.vars.wnd:getChildByName("btn_push_stamina")
		local var_76_11 = arg_76_0.vars.wnd:getChildByName("btn_push_night")
		
		var_76_6:setPositionY(var_76_7:getPositionY())
		var_76_7:setPositionY(var_76_8:getPositionY())
		var_76_8:setPositionY(var_76_9:getPositionY())
		var_76_9:setPositionY(var_76_10:getPositionY())
		var_76_10:setPositionY(var_76_11:getPositionY())
		var_76_11:setVisible(false)
	end
end

function UIOption.showLanguageCategory(arg_77_0)
	local var_77_0 = arg_77_0.vars.wnd:getChildByName("language_opt")
	
	if not get_cocos_refid(var_77_0) then
		return 
	end
	
	local var_77_1 = getenv("patch.local.enable") == "true"
	
	if_set_visible(var_77_0, "bar1_r", var_77_1)
	if_set_visible(var_77_0, "bar1_l", var_77_1)
	if_set_visible(var_77_0, "n_media", var_77_1)
end

function UIOption.showCategory(arg_78_0, arg_78_1)
	local var_78_0 = {
		"normal",
		"game",
		"language"
	}
	
	for iter_78_0, iter_78_1 in pairs(var_78_0) do
		local var_78_1 = arg_78_1 == iter_78_1
		
		if_set_visible(arg_78_0.vars.wnd, iter_78_1 .. "_opt", var_78_1)
		if_set_visible(arg_78_0.vars.wnd, "fg_category_" .. iter_78_1, var_78_1)
	end
	
	if arg_78_1 == "normal" then
		arg_78_0:showNormalCategory()
	elseif arg_78_1 == "game" then
		arg_78_0:showGameCategory()
	elseif arg_78_1 == "language" then
		arg_78_0:showLanguageCategory()
	end
end

function UIOption.setBlock(arg_79_0, arg_79_1)
	arg_79_0.block = arg_79_1
end

function UIOption.isBlock(arg_80_0)
	return arg_80_0.block
end

function UIOption.loadCheckBoxOption(arg_81_0, arg_81_1, arg_81_2)
	local var_81_0 = SAVE:getOptionData("option." .. arg_81_1, default_options[arg_81_1])
	
	arg_81_2:setSelected(var_81_0)
end

function UIOption.saveCheckBoxOption(arg_82_0, arg_82_1, arg_82_2)
	SAVE:setUserDefaultData("option." .. arg_82_1, arg_82_2:isSelected())
end

function UIOption.setLocalPush(arg_83_0, arg_83_1, arg_83_2)
	arg_83_0:saveCheckBoxOption(arg_83_1, arg_83_2)
	arg_83_0:UpdateCheckBoxPushAll()
	
	if arg_83_2:isSelected() then
		return 
	end
	
	for iter_83_0, iter_83_1 in pairs(LOCAL_PUSH_IDS) do
		if iter_83_1.category == arg_83_1 then
			local var_83_0 = SAVE:get("t_local_push_" .. iter_83_1.id, nil)
			
			if var_83_0 then
				print("등록된 푸시 삭제 : ", iter_83_1.category, iter_83_1.id, var_83_0)
				arg_83_0:removePush(iter_83_1)
			end
		end
	end
end

UIOption.touch_check_boxs = {}
UIOption.touch_check_boxs.blur_off = UIOption.saveCheckBoxOption
UIOption.touch_check_boxs.push_stamina = UIOption.setLocalPush
UIOption.touch_check_boxs.push_orbis = UIOption.setLocalPush
UIOption.touch_check_boxs.push_forest = UIOption.setLocalPush
UIOption.touch_check_boxs.push_subtask = UIOption.setLocalPush
UIOption.touch_check_boxs.push_connect = UIOption.setLocalPush

function UIOption.touch_check_boxs.low_end_on(arg_84_0, arg_84_1, arg_84_2)
	local var_84_0 = arg_84_2:isSelected()
	local var_84_1 = var_84_0 and T("lowquality_on_desc") or T("lowquality_off_desc")
	
	Dialog:msgBox(var_84_1, {
		yesno = true,
		cancel_handler = function()
			arg_84_2:setSelected(not var_84_0)
		end,
		handler = function()
			if var_84_0 then
				if save_low_end_custom_view_height then
					save_low_end_custom_view_height()
					terminated_process()
				end
			elseif save_default_custom_view_height then
				save_default_custom_view_height()
				terminated_process()
			end
		end
	})
end

function UIOption.touch_check_boxs.touch_off(arg_87_0, arg_87_1, arg_87_2)
	arg_87_0:saveCheckBoxOption(arg_87_1, arg_87_2)
	SceneManager:setEnabledTouchEffectListener(not arg_87_2:isSelected())
end

function UIOption.touch_check_boxs.view_mode(arg_88_0, arg_88_1, arg_88_2)
	arg_88_0:saveCheckBoxOption(arg_88_1, arg_88_2)
	SceneManager:changeAbsentTime()
end

function UIOption.touch_check_boxs.fps60(arg_89_0, arg_89_1, arg_89_2)
	if IS_ANDROID_PC then
		MINIMUM_FPS = 60
		
		arg_89_2:setSelected(true)
		
		return 
	end
	
	if not arg_89_2:isSelected() then
		MINIMUM_FPS = 0
		
		arg_89_0:saveCheckBoxOption(arg_89_1, arg_89_2)
		
		return 
	end
	
	Dialog:msgBox(T("highquality_caution"), {
		yesno = true,
		title = T("popup_adv_warning_title"),
		cancel_handler = function()
			arg_89_2:setSelected(false)
		end,
		handler = function()
			MINIMUM_FPS = 60
			
			arg_89_0:saveCheckBoxOption(arg_89_1, arg_89_2)
		end
	})
end

function UIOption.touch_check_boxs.adaptive_fps(arg_92_0, arg_92_1, arg_92_2)
	if arg_92_2:isSelected() then
		ADAPTIVE_FPS_FLAG = true
		
		arg_92_0:saveCheckBoxOption(arg_92_1, arg_92_2)
		
		return 
	end
	
	Dialog:msgBox(T("highquality_caution"), {
		yesno = true,
		title = T("popup_adv_warning_title"),
		cancel_handler = function()
			arg_92_2:setSelected(true)
		end,
		handler = function()
			ADAPTIVE_FPS_FLAG = false
			
			arg_92_0:saveCheckBoxOption(arg_92_1, arg_92_2)
		end
	})
end

function UIOption.touch_check_boxs.always_on(arg_95_0, arg_95_1, arg_95_2)
	arg_95_0:saveCheckBoxOption(arg_95_1, arg_95_2)
	arg_95_0:UpdateScreenOnState()
end

function UIOption.touch_check_boxs.push_all(arg_96_0, arg_96_1, arg_96_2)
	if not get_cocos_refid(arg_96_0.vars.wnd) then
		return 
	end
	
	local var_96_0 = arg_96_0.vars.wnd:getChildByName("n_checkboxs")
	
	if not get_cocos_refid(var_96_0) then
		return 
	end
	
	local var_96_1 = arg_96_2:isSelected()
	local var_96_2 = {
		"push_operating",
		"push_night",
		"push_stamina",
		"push_orbis",
		"push_forest",
		"push_subtask",
		"push_connect"
	}
	
	for iter_96_0, iter_96_1 in pairs(var_96_2) do
		local var_96_3 = var_96_0:getChildByName("check_box_" .. iter_96_1)
		
		if get_cocos_refid(arg_96_2) and arg_96_0.touch_check_boxs[iter_96_1] then
			var_96_3:setSelected(var_96_1)
			arg_96_0.touch_check_boxs[iter_96_1](arg_96_0, iter_96_1, var_96_3)
		end
	end
	
	if getUserLanguage() == "ko" then
		local var_96_4 = ("[" .. T("epicseven") .. "] " .. T("time_dot_y_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			time = os.time()
		})) .. " ") .. " " .. (arg_96_2:isSelected() and T("game_push_all_agreement") or T("game_push_all_refusal"))
		
		balloon_message(var_96_4, nil, nil, {
			delay = 2000
		})
	end
	
	arg_96_0:UpdateCheckBoxPushAll()
end

function UIOption.touch_check_boxs.push_operating(arg_97_0, arg_97_1, arg_97_2)
	arg_97_0:saveCheckBoxOption(arg_97_1, arg_97_2)
	arg_97_0:UpdateCheckBoxPushAll()
	
	local var_97_0 = arg_97_2:isSelected()
	
	if Stove.enable then
		local var_97_1 = {
			enabledDay = arg_97_2:isSelected() and true or false
		}
		
		Login.FSM:changeState(LoginState.STOVE_UPDATE_PUSH_SETTING, {
			push_settings = var_97_1
		})
	end
	
	if not get_cocos_refid(arg_97_0.vars.wnd) then
		return 
	end
	
	local var_97_2 = arg_97_0.vars.wnd:getChildByName("check_box_push_night")
	
	if not var_97_0 and var_97_2:isSelected() then
		var_97_2:setSelected(false)
		UIOption.touch_check_boxs.push_night(arg_97_0, "push_night", var_97_2)
	end
	
	var_97_2:setOpacity(var_97_0 and 255 or 76)
	var_97_2:setEnabled(var_97_0)
	
	if getUserLanguage() == "ko" then
		local var_97_3 = ("[" .. T("epicseven") .. "] " .. T("time_dot_y_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			time = os.time()
		}))) .. " " .. (arg_97_2:isSelected() and T("game_push_operation_agreement") or T("game_push_operation_refusal"))
		
		balloon_message(var_97_3, nil, nil, {
			delay = 2000
		})
	end
end

function UIOption.removePush(arg_98_0, arg_98_1)
	cancel_local_push(arg_98_1)
end

function UIOption.touch_check_boxs.push_night(arg_99_0, arg_99_1, arg_99_2)
	arg_99_0:saveCheckBoxOption(arg_99_1, arg_99_2)
	
	if Stove.enable then
		local var_99_0 = {
			enabledNight = arg_99_2:isSelected() and true or false
		}
		
		Login.FSM:changeState(LoginState.STOVE_UPDATE_PUSH_SETTING, {
			push_settings = var_99_0
		})
	end
	
	if getUserLanguage() == "ko" then
		local var_99_1 = ("[" .. T("epicseven") .. "] " .. T("time_dot_y_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			time = os.time()
		})) .. " ") .. " " .. (arg_99_2:isSelected() and T("game_push_night_on_agreement") or T("game_push_night_on_refusal"))
		
		balloon_message(var_99_1, nil, nil, {
			delay = 2000
		})
	end
	
	if arg_99_2:isSelected() then
		return 
	end
	
	for iter_99_0, iter_99_1 in pairs(LOCAL_PUSH_IDS) do
		local var_99_2 = SAVE:get("t_local_push_" .. iter_99_1.id, nil)
		
		if is_night_time_push(var_99_2) then
			print("등록된 푸시 삭제 : ", iter_99_1.category, iter_99_1.id, var_99_2)
			arg_99_0:removePush(iter_99_1)
		end
	end
end

UIOption.touch_check_boxs.haptic_vib = UIOption.saveCheckBoxOption
UIOption.touch_check_boxs.battle_end_vib = UIOption.saveCheckBoxOption
UIOption.touch_check_boxs.popupskip = UIOption.saveCheckBoxOption
UIOption.touch_check_boxs.skip_5 = UIOption.saveCheckBoxOption
UIOption.touch_check_boxs.skip_4 = UIOption.saveCheckBoxOption

function UIOption.touch_check_boxs.high_def(arg_100_0, arg_100_1, arg_100_2)
	local var_100_0 = arg_100_2.old_state
	
	if SceneManager:getCurrentSceneName() == "battle" then
		balloon_message_with_sound("cant_use_battle")
		arg_100_2:setSelected(var_100_0)
		
		return 
	elseif UIOption:isStoryMode() then
		balloon_message_with_sound("theater_story_close_balloon")
		arg_100_2:setSelected(var_100_0)
		
		return 
	end
	
	local var_100_1 = T("msg_option_fhd_mediapack")
	
	Dialog:msgBox(var_100_1, {
		yesno = true,
		handler = function()
			local var_101_0 = arg_100_2:isSelected() and "fhd" or "sd"
			
			setenv("media.quality", var_101_0)
			reset_patch({
				"fhd",
				"sd"
			})
			restart_contents()
		end,
		cancel_handler = function()
			arg_100_2:setSelected(var_100_0)
		end
	})
end

UIOption.touch_check_boxs.profile_off = UIOption.saveCheckBoxOption

function UIOption.onTouchCheckBox(arg_103_0, arg_103_1)
	local var_103_0 = arg_103_0.vars.wnd:getChildByName("check_box_" .. arg_103_1)
	
	if not get_cocos_refid(var_103_0) then
		return 
	end
	
	if not arg_103_0.touch_check_boxs[arg_103_1] then
		return 
	end
	
	UIOption.touch_check_boxs[arg_103_1](arg_103_0, arg_103_1, var_103_0)
end

function UIOption.onTouchOptionButton(arg_104_0, arg_104_1)
	local var_104_0 = arg_104_0.vars.wnd:getChildByName("btn_" .. arg_104_1)
	
	if not get_cocos_refid(var_104_0) then
		return 
	end
	
	local var_104_1 = arg_104_0.vars.wnd:getChildByName("check_box_" .. arg_104_1)
	
	if not get_cocos_refid(var_104_1) then
		return 
	end
	
	if arg_104_1 == "low_end_on" then
		var_104_1:setSelected(not LOW_RESOLUTION_MODE)
	elseif arg_104_1 == "push_all" then
		var_104_1:setSelected(not arg_104_0:isSelectedPushAll())
	elseif arg_104_1 == "high_def" then
		var_104_1:setSelected(not var_104_1:isSelected())
	elseif Stove.enable and (arg_104_1 == "push_operating" or arg_104_1 == "push_night") then
		var_104_1:setSelected(not var_104_1:isSelected())
	elseif var_104_1:isEnabled() then
		var_104_1:setSelected(not SAVE:getOptionData("option." .. arg_104_1, default_options[arg_104_1]))
	end
	
	arg_104_0:onTouchCheckBox(arg_104_1)
end

function UIOption.isSelectedPushAll(arg_105_0)
	local var_105_0 = arg_105_0.vars.wnd:getChildByName("n_checkboxs")
	
	if not get_cocos_refid(var_105_0) then
		return false
	end
	
	local var_105_1 = var_105_0:getChildByName("check_box_push_all")
	
	if not get_cocos_refid(var_105_1) then
		return false
	end
	
	local var_105_2 = {
		"push_operating",
		"push_stamina",
		"push_orbis",
		"push_forest",
		"push_subtask",
		"push_connect"
	}
	
	for iter_105_0, iter_105_1 in pairs(var_105_2) do
		local var_105_3 = var_105_0:getChildByName("check_box_" .. iter_105_1)
		
		if get_cocos_refid(var_105_3) and not var_105_3:isSelected() then
			return false
		end
	end
	
	return true
end

function UIOption.UpdateCheckBoxPushAll(arg_106_0)
	local var_106_0 = arg_106_0.vars.wnd:getChildByName("n_checkboxs")
	
	if not get_cocos_refid(var_106_0) then
		return 
	end
	
	local var_106_1 = var_106_0:getChildByName("check_box_push_all")
	
	if not get_cocos_refid(var_106_1) then
		return 
	end
	
	local var_106_2 = arg_106_0:isSelectedPushAll()
	
	var_106_1:setSelected(var_106_2)
	if_set_visible(var_106_1:getParent(), "selected", var_106_2)
	if_set_text_color(var_106_1, "t", var_106_2 and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
end

UIOption.update_check_boxs = {}
UIOption.update_check_boxs.push_stamina = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.push_orbis = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.push_forest = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.push_subtask = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.push_connect = UIOption.loadCheckBoxOption

function UIOption.update_check_boxs.adaptive_fps(arg_107_0, arg_107_1, arg_107_2)
	if IS_ANDROID_PC then
		if_set_visible(arg_107_2:getParent(), nil, false)
		arg_107_2:setSelected(false)
	else
		if_set_visible(arg_107_2:getParent(), nil, true)
		
		local var_107_0 = SAVE:getOptionData("option." .. arg_107_1, default_options[arg_107_1])
		
		arg_107_2:setSelected(var_107_0)
	end
end

UIOption.update_check_boxs.always_on = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.popupskip = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.skip_5 = UIOption.loadCheckBoxOption
UIOption.update_check_boxs.skip_4 = UIOption.loadCheckBoxOption

function UIOption.update_check_boxs.low_end_on(arg_108_0, arg_108_1, arg_108_2)
	if IS_ANDROID_PC then
		if_set_visible(arg_108_2:getParent(), nil, false)
		arg_108_2:setSelected(false)
	elseif IS_ANDROID_BASED_PLATFORM then
		if_set_visible(arg_108_2:getParent(), nil, true)
		arg_108_2:setSelected(LOW_RESOLUTION_MODE)
	elseif PLATFORM == "iphoneos" then
		if_set_visible(arg_108_2:getParent(), nil, true)
		arg_108_2:setSelected(LOW_RESOLUTION_MODE)
	else
		if_set_visible(arg_108_2:getParent(), nil, false)
		arg_108_2:setSelected(false)
	end
end

function UIOption.update_check_boxs.fps60(arg_109_0, arg_109_1, arg_109_2)
	if IS_ANDROID_PC then
		if_set_visible(arg_109_2:getParent(), nil, true)
		arg_109_2:setSelected(true)
	elseif LOW_RESOLUTION_MODE then
		if_set_visible(arg_109_2:getParent(), nil, false)
		arg_109_2:setSelected(false)
	else
		if_set_visible(arg_109_2:getParent(), nil, true)
		
		local var_109_0 = SAVE:getOptionData("option." .. arg_109_1, default_options[arg_109_1])
		
		arg_109_2:setSelected(var_109_0)
	end
end

function UIOption.update_check_boxs.blur_off(arg_110_0, arg_110_1, arg_110_2)
	if LOW_RESOLUTION_MODE then
		if_set_visible(arg_110_2:getParent(), nil, false)
		arg_110_2:setSelected(false)
	else
		if_set_visible(arg_110_2:getParent(), nil, true)
		
		local var_110_0 = SAVE:getOptionData("option." .. arg_110_1, default_options[arg_110_1])
		
		arg_110_2:setSelected(var_110_0)
	end
end

function UIOption.update_check_boxs.touch_off(arg_111_0, arg_111_1, arg_111_2)
	if_set_visible(arg_111_2:getParent(), nil, true)
	
	local var_111_0 = SAVE:getOptionData("option." .. arg_111_1, default_options[arg_111_1])
	
	arg_111_2:setSelected(var_111_0)
end

function UIOption.update_check_boxs.view_mode(arg_112_0, arg_112_1, arg_112_2)
	if_set_visible(arg_112_2:getParent(), nil, true)
	
	local var_112_0 = SAVE:getOptionData("option." .. arg_112_1, default_options[arg_112_1])
	
	arg_112_2:setSelected(var_112_0)
end

function UIOption.update_check_boxs.push_operating(arg_113_0, arg_113_1, arg_113_2)
	if Stove.enable then
		arg_113_2:setSelected(Stove.user_data.push_settings.enabledDay)
	else
		local var_113_0 = SAVE:getOptionData("option." .. arg_113_1, default_options[arg_113_1])
		
		arg_113_2:setSelected(var_113_0)
	end
end

function UIOption.update_check_boxs.push_night(arg_114_0, arg_114_1, arg_114_2)
	if Stove.enable then
		arg_114_2:setSelected(Stove.user_data.push_settings.enabledNight)
	else
		local var_114_0 = SAVE:getOptionData("option." .. arg_114_1, default_options[arg_114_1])
		
		arg_114_2:setSelected(var_114_0)
	end
	
	if get_cocos_refid(arg_114_0.vars.wnd) then
		local var_114_1 = arg_114_0.vars.wnd:getChildByName("n_checkboxs")
		
		if get_cocos_refid(var_114_1) then
			local var_114_2 = var_114_1:getChildByName("check_box_push_operating")
			
			arg_114_2:setOpacity(var_114_2:isSelected() and 255 or 76)
			arg_114_2:setEnabled(var_114_2:isSelected())
		end
	end
end

function UIOption.update_check_boxs.haptic_vib(arg_115_0, arg_115_1, arg_115_2)
	if IS_ANDROID_PC then
		if_set_visible(arg_115_2:getParent(), nil, false)
	else
		local var_115_0 = cc.Application:getInstance():getTargetPlatform()
		
		if var_115_0 == cc.PLATFORM_OS_ANDROID or var_115_0 == cc.PLATFORM_OS_IPHONE then
			local var_115_1 = SAVE:getOptionData("option." .. arg_115_1, default_options[arg_115_1])
			
			arg_115_2:setSelected(var_115_1)
		else
			if_set_visible(arg_115_2:getParent(), nil, false)
		end
	end
end

function UIOption.update_check_boxs.battle_end_vib(arg_116_0, arg_116_1, arg_116_2)
	if IS_ANDROID_PC then
		if_set_visible(arg_116_2:getParent(), nil, false)
	else
		local var_116_0 = cc.Application:getInstance():getTargetPlatform()
		
		if var_116_0 == cc.PLATFORM_OS_ANDROID or var_116_0 == cc.PLATFORM_OS_IPHONE then
			local var_116_1 = SAVE:getOptionData("option." .. arg_116_1, default_options[arg_116_1])
			
			arg_116_2:setSelected(var_116_1)
		else
			if_set_visible(arg_116_2:getParent(), nil, false)
		end
	end
end

function UIOption.update_check_boxs.high_def(arg_117_0, arg_117_1, arg_117_2)
	if IS_ANDROID_PC then
		if_set_visible(arg_117_2:getParent(), nil, false)
	else
		if_set_visible(arg_117_2:getParent(), nil, true)
		
		local var_117_0 = getenv("media.quality") == "fhd"
		
		arg_117_2:setSelected(var_117_0)
		
		arg_117_2.old_state = var_117_0
	end
end

UIOption.update_check_boxs.profile_off = UIOption.loadCheckBoxOption

function UIOption.updateCheckboxs(arg_118_0)
	if not get_cocos_refid(arg_118_0.vars.wnd) then
		return 
	end
	
	local var_118_0 = arg_118_0.vars.wnd:getChildByName("n_checkboxs")
	
	if not get_cocos_refid(var_118_0) then
		return 
	end
	
	local var_118_1 = {
		"fps60",
		"blur_off",
		"adaptive_fps",
		"always_on",
		"low_end_on",
		"push_operating",
		"push_night",
		"push_stamina",
		"push_orbis",
		"push_forest",
		"push_subtask",
		"push_connect",
		"touch_off",
		"view_mode",
		"haptic_vib",
		"battle_end_vib",
		"popupskip",
		"skip_5",
		"skip_4",
		"high_def",
		"profile_off"
	}
	
	for iter_118_0, iter_118_1 in pairs(var_118_1) do
		local var_118_2 = var_118_0:getChildByName("check_box_" .. iter_118_1)
		
		if get_cocos_refid(var_118_2) and arg_118_0.update_check_boxs[iter_118_1] then
			arg_118_0.update_check_boxs[iter_118_1](arg_118_0, iter_118_1, var_118_2)
		end
	end
	
	arg_118_0:UpdateCheckBoxPushAll()
end

function UIOption.UpdateScreenOnState(arg_119_0, arg_119_1)
	local var_119_0 = arg_119_1 or SAVE:getOptionData("option.always_on", false)
	
	if not var_119_0 and ((SceneManager:getCurrentSceneName() == "battle" or SceneManager:getCurrentSceneName() == "world_boss") and not Battle:isEnded() or BackPlayManager:isRunning()) then
		var_119_0 = SAVE:getOptionData("option.prevent_off_while_battle", true)
	end
	
	if arg_119_0.screen_on_flag == var_119_0 then
		return 
	end
	
	cc.Device:setKeepScreenOn(var_119_0)
	
	arg_119_0.screen_on_flag = var_119_0
	
	print("DEBUG Change Screen On Option : " .. tostring(var_119_0))
end

function UIOption.do_enter(arg_120_0)
	local function var_120_0(arg_121_0, arg_121_1)
		local var_121_0 = {
			_t_name = arg_121_1
		}
		
		copy_functions(arg_121_0, var_121_0)
		
		return var_121_0
	end
	
	UIOption.base_positions = {}
	
	local var_120_1 = {
		UNIT,
		FORMULA,
		FORMULA.List,
		BattleLogic,
		SkillProc,
		State,
		StateList
	}
	local var_120_2 = {
		"UNIT",
		"FORMULA",
		"FORMULA.List",
		"BattleLogic",
		"SkillProc",
		"State",
		"StateList"
	}
	
	for iter_120_0, iter_120_1 in pairs(var_120_1) do
		table.insert(UIOption.base_positions, {
			center = var_120_0(iter_120_1, var_120_2[iter_120_0])
		})
	end
end

UIOption:do_enter()
