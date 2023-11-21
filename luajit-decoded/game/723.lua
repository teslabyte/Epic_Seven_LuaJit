LotaNotiPopupUI = {}

local var_0_0 = 380

function LotaNotiPopupUI.handler(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_2 == "btn_cancel" then
		LotaNotiPopupUI:closeNoticePopup()
	elseif arg_1_2 == "btn_yes" then
		LotaNotiPopupUI:saveNotice()
	elseif arg_1_2 == "btn_close" then
		LotaNotiPopupUI:closeNoticePopup()
	end
end

function LotaNotiPopupUI.isActive(arg_2_0)
	return arg_2_0.vars and get_cocos_refid(arg_2_0.vars.wnd)
end

function LotaNotiPopupUI.openNoticePopup(arg_3_0)
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("clan_war_noti_popup", true, "wnd", function()
		LotaNotiPopupUI:closeNoticePopup()
	end)
	
	local var_3_0 = SceneManager:getRunningPopupScene()
	
	arg_3_0.vars.wnd:setLocalZOrder(999999)
	var_3_0:addChild(arg_3_0.vars.wnd)
	
	arg_3_0.vars.orig_noti = LotaEnterUI:getNoticeOnlyMsgOnClanInfo()
	arg_3_0.vars.n_text = nil
	
	local var_3_1, var_3_2 = LotaEnterUI:isEditable()
	
	if var_3_2 == "need_user_info" then
		balloon_message_with_sound("msg_clanheritage_order_member_error")
	end
	
	if var_3_1 then
		if_set(arg_3_0.vars.wnd, "title", T("ui_clan_heritage_order_modify_title"))
		
		arg_3_0.vars.n_text = arg_3_0.vars.wnd:getChildByName("txt_notice")
		
		local var_3_3 = arg_3_0.vars.wnd:findChildByName("n_edit")
		
		if_set_visible(var_3_3, nil, true)
		if_set_visible(arg_3_0.vars.wnd, "n_view", false)
		arg_3_0.vars.n_text:setMaxLength(var_0_0)
		arg_3_0.vars.n_text:setPlaceHolder(T("ui_clan_heritage_order_default"))
		arg_3_0.vars.n_text:setMaxLengthEnabled(true)
		arg_3_0.vars.n_text:setCursorEnabled(true)
		arg_3_0.vars.n_text:setTextColor(tocolor("#603d2a"))
		if_set(var_3_3, "t_disc", T("ui_clan_heritage_order_max_text"))
		
		local var_3_4 = tolua.cast(arg_3_0.vars.n_text:getVirtualRenderer(), "cc.Label")
		
		arg_3_0.vars.n_text:addEventListener(function(arg_5_0, arg_5_1)
			UIUtil:updateTextWrapMode(var_3_4, arg_3_0.vars.n_text:getString())
			
			if arg_5_1 == ccui.TextFiledEventType.insert_text and utf8len(arg_3_0.vars.n_text:getString()) >= var_0_0 then
			end
		end)
	else
		if_set(arg_3_0.vars.wnd, "title", T("ui_clan_heritage_order_title"))
		if_set_visible(arg_3_0.vars.wnd, "n_edit", false)
		if_set_visible(arg_3_0.vars.wnd, "n_view", true)
		if_set_visible(arg_3_0.vars.wnd, "scrollview", false)
		
		arg_3_0.vars.n_text = arg_3_0.vars.wnd:getChildByName("t_noti")
	end
	
	UIUtil:updateTextWrapMode(arg_3_0.vars.n_text, arg_3_0.vars.orig_noti)
	arg_3_0.vars.n_text:setString(arg_3_0.vars.orig_noti)
end

function LotaNotiPopupUI.saveNotice(arg_6_0)
	if arg_6_0.vars.n_text:getString() == arg_6_0.vars.orig_noti then
		balloon_message_with_sound("clanwar_notice_popup_error1")
		arg_6_0:closeNoticePopup()
		
		return 
	end
	
	local var_6_0 = arg_6_0.vars.n_text:getString()
	local var_6_1 = string.trim(var_6_0)
	
	if check_abuse_filter(var_6_1, ABUSE_FILTER.CHAT) then
		balloon_message_with_sound("invalid_input_word")
		
		return 
	end
	
	if var_6_1 == nil or utf8len(var_6_1) < 5 then
		balloon_message_with_sound("msg_clanheritage_order_text_error_min")
		arg_6_0:closeNoticePopup()
		
		return 
	end
	
	BackButtonManager:pop("clan_war_noti_popup")
	LotaNetworkSystem:sendQuery("lota_edit_notice", {
		msg = var_6_1
	})
end

function LotaNotiPopupUI.closeNoticePopup(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	arg_7_0.vars.wnd:removeFromParent()
	
	arg_7_0.vars = nil
	
	BackButtonManager:pop("clan_war_noti_popup")
end
