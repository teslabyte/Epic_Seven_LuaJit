UserNickName = UserNickName or {}

function MsgHandler.check_nickname(arg_1_0)
	UserNickName:onCheckedNickname(arg_1_0.res, arg_1_0.name)
end

function MsgHandler.set_name(arg_2_0)
	UserNickName:nameChanged(arg_2_0.res, arg_2_0.name)
	Friend:setNameUI()
end

function UserNickName.isVisible(arg_3_0)
	if not arg_3_0.vars then
		return false
	end
	
	if not get_cocos_refid(arg_3_0.vars.popup_nickname) then
		return false
	end
	
	return true
end

function UserNickName.getInputNickErrorTextID(arg_4_0, arg_4_1)
	if arg_4_1 == nil or arg_4_1 == "" then
		return "nickname.forbidden_word"
	end
	
	if string.match(arg_4_1, " ") ~= nil then
		return "nickname.cannot_use_space"
	end
	
	if AccountData.name == arg_4_1 then
		return "nickname.equal_current"
	end
	
	local var_4_0 = utf8len(arg_4_1)
	local var_4_1 = var_4_0 == string.len(arg_4_1)
	
	if var_4_0 < (var_4_1 and 4 or 2) then
		return "nickname.more_words"
	end
	
	if var_4_0 > (var_4_1 and 12 or 8) then
		return "nickname.too_long"
	end
	
	if os.time() < (arg_4_0.vars.time_nickname or 0) + 2 then
		return "nickname.check_wait_seconds"
	end
end

function UserNickName.isContainInvalidCharacter(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return true
	end
	
	if check_abuse_filter and check_abuse_filter(arg_5_1, ABUSE_FILTER.NAME) then
		return true
	end
	
	if UIUtil:checkInvalidCharacter(arg_5_1, false) then
		return true
	end
	
	return false
end

function UserNickName.btnCheckNickName(arg_6_0)
	if not arg_6_0.vars.input_nickname then
		return 
	end
	
	local var_6_0 = arg_6_0:getInputNickErrorTextID(arg_6_0.vars.input_nickname)
	
	if var_6_0 then
		balloon_message_with_sound(var_6_0)
		
		return 
	end
	
	if arg_6_0:isContainInvalidCharacter(arg_6_0.vars.input_nickname) then
		Dialog:msgBox(T("cant_use_character"), {
			title = T("invalid_character")
		})
		
		return 
	end
	
	if get_cocos_refid(arg_6_0.vars.txt_nickname) and arg_6_0.vars.txt_nickname.isTextInAtlas and not arg_6_0.vars.txt_nickname:isTextInAtlas() then
		Dialog:msgBox(T("cant_use_character"), {
			title = T("invalid_character")
		})
		
		return 
	end
	
	arg_6_0.vars.time_nickname = os.time()
	
	query("check_nickname", {
		name = arg_6_0.vars.input_nickname
	})
end

function UserNickName.openConfirmChangeMessageBox(arg_7_0)
	local function var_7_0()
		if not Account:checkNameChanged() then
			return T("nickname_change_check")
		end
		
		if arg_7_0.vars.is_buy_mode then
			return T("nickname_change_item_check")
		end
		
		return T("nickname_change_coupon_check")
	end
	
	local var_7_1 = load_dlg("user_profile_nickname_msgbox", true, "wnd")
	
	if_set(var_7_1, "txt_disc", var_7_0())
	if_set(var_7_1, "txt_title", T("nickname_change_title"))
	if_set(var_7_1, "txt_green", arg_7_0.vars.input_nickname)
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_7_1,
		green = arg_7_0.vars.input_nickname,
		handler = function(arg_9_0, arg_9_1)
			if arg_9_1 == "btn_yes" then
				if arg_7_0.vars.postbox_change_callback then
					arg_7_0.vars.postbox_change_callback(arg_7_0.vars.input_nickname)
					
					return 
				end
				
				query("set_name", {
					name = arg_7_0.vars.input_nickname
				})
			end
		end
	})
end

function UserNickName.btnChangeNickName(arg_10_0)
	if not arg_10_0.vars.input_nickname then
		return 
	end
	
	if arg_10_0.vars.is_buy_mode and to_n(GAME_CONTENT_VARIABLE.buy_nickname_change_cost_crystal or 1200) > Account:getCurrency("crystal") then
		balloon_message_with_sound("buy.no_crystal")
		
		return 
	end
	
	if not Stove:checkStandbyAndBalloonMessage() then
		return 
	end
	
	if not arg_10_0.vars.verified_nickname then
		balloon_message_with_sound("nickname.verify_first")
		
		return 
	end
	
	if arg_10_0.vars.verified_nickname ~= arg_10_0.vars.input_nickname then
		arg_10_0.vars.verified_nickname = nil
		
		if_set_visible(n_check, "btn_check", true)
		if_set_visible(n_check, "n_verified", false)
		balloon_message_with_sound("nickname.verify_first")
		
		return 
	end
	
	arg_10_0:openConfirmChangeMessageBox()
end

function UserNickName.nickNameWndHandler(arg_11_0, arg_11_1)
	cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
	
	if arg_11_1 == "btn_ignore" then
		return 
	end
	
	if arg_11_1 == "btn_check" then
		arg_11_0:btnCheckNickName()
		
		return 
	end
	
	if arg_11_1 == "btn_yes" then
		arg_11_0:btnChangeNickName()
		
		return 
	end
end

function UserNickName.popupNickname(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	arg_12_0.vars = {}
	arg_12_0.vars.callback = arg_12_2
	arg_12_0.vars.postbox_change_callback = arg_12_3
	arg_12_0.vars.force_nickname_mode = arg_12_0.vars.callback and not arg_12_0.vars.postbox_change_callback
	arg_12_0.vars.is_buy_mode = arg_12_4
	arg_12_1 = arg_12_1 or "user_profile_nickname"
	
	local var_12_0 = load_dlg(arg_12_1, true, "wnd")
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	local var_12_1 = var_12_0:getChildByName("n_check")
	
	if not var_12_1 then
		return 
	end
	
	if_set_visible(var_12_1, "btn_check", true)
	if_set_visible(var_12_1, "n_verified", false)
	
	if arg_12_0.vars.is_buy_mode then
		local var_12_2 = var_12_0:getChildByName("n_bottom")
		
		if get_cocos_refid(var_12_2) then
			local var_12_3 = var_12_2:getChildByName("btn_yes")
			
			if get_cocos_refid(var_12_3) then
				var_12_3:setName("btn_no_use")
				var_12_3:setVisible(false)
			end
			
			local var_12_4 = var_12_2:getChildByName("btn_change")
			
			if get_cocos_refid(var_12_4) then
				var_12_4:setName("btn_yes")
			end
		end
	else
		local var_12_5 = var_12_0:getChildByName("n_bottom")
		
		if get_cocos_refid(var_12_5) then
			if_set_visible(var_12_5, "btn_change", false)
		end
	end
	
	arg_12_0.vars.txt_nickname = var_12_0:getChildByName("txt_nickname")
	
	if not get_cocos_refid(arg_12_0.vars.txt_nickname) then
		return 
	end
	
	arg_12_0.vars.verified_nickname = nil
	arg_12_0.vars.popup_nickname = Dialog:msgBox(nil, {
		arg = "dont_close",
		yesno = true,
		dlg = var_12_0,
		no_back_button = arg_12_0.vars.force_nickname_mode,
		title = T("nickname.title"),
		handler = function(arg_13_0, arg_13_1)
			arg_12_0.vars.input_nickname = arg_12_0.vars.txt_nickname:getString()
			
			arg_12_0:nickNameWndHandler(arg_13_1)
		end,
		cancel_handler = function(arg_14_0, arg_14_1)
			if arg_12_0.vars.postbox_change_callback then
				arg_12_0.vars.postbox_change_callback(nil)
			end
			
			arg_12_0.vars.popup_nickname = nil
			
			var_12_0:removeFromParent()
			BackButtonManager:pop({
				id = "msgbox.popupNickname",
				dlg = var_12_0
			})
		end
	})
	
	Scheduler:addSlow(arg_12_0.vars.popup_nickname, arg_12_0.checkNicknameChanged, arg_12_0)
end

function UserNickName.onCheckedNickname(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 ~= "ok" then
		balloon_message_with_sound("nickname." .. arg_15_1)
		
		return 
	end
	
	if arg_15_0.vars.popup_nickname and get_cocos_refid(arg_15_0.vars.popup_nickname) then
		local var_15_0 = arg_15_0.vars.popup_nickname:getChildByName("n_check")
		
		if_set_visible(var_15_0, "btn_check", false)
		if_set_visible(var_15_0, "n_verified", true)
	end
	
	arg_15_0.vars.verified_nickname = arg_15_2
end

function UserNickName.closePopup(arg_16_0)
	if not get_cocos_refid(arg_16_0.vars.popup_nickname) then
		return 
	end
	
	BackButtonManager:pop({
		dlg = arg_16_0.vars.popup_nickname
	})
	arg_16_0.vars.popup_nickname:removeFromParent()
	
	arg_16_0.vars.popup_nickname = nil
	arg_16_0.vars = {}
end

function UserNickName.nameChanged(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_1 == "ok" then
		Account:setName(arg_17_2)
		TopBarNew:checkDefaultNotification()
		Profile:updateAccount()
		
		if arg_17_0.vars.callback then
			arg_17_0.vars.callback()
		end
		
		balloon_message_with_sound("nickname_chanhe_complete")
		arg_17_0:closePopup()
	else
		balloon_message_with_sound("nickname." .. arg_17_1)
		
		if arg_17_1 == "already_changed_nickname" then
			arg_17_0:closePopup()
		end
	end
end

function UserNickName.checkNicknameChanged(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	if not arg_18_0.vars.verified_nickname then
		return 
	end
	
	if not get_cocos_refid(arg_18_0.vars.popup_nickname) then
		return 
	end
	
	if not get_cocos_refid(arg_18_0.vars.txt_nickname) then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.txt_nickname:getString()
	local var_18_1 = string.trim(var_18_0)
	
	if arg_18_0.vars.verified_nickname == var_18_1 then
		return 
	end
	
	arg_18_0.vars.verified_nickname = nil
	
	local var_18_2 = arg_18_0.vars.popup_nickname:getChildByName("n_check")
	
	if_set_visible(var_18_2, "btn_check", true)
	if_set_visible(var_18_2, "n_verified", false)
end
