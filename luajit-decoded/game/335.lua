TeamNameModifyDialog = {}

function HANDLER.team_name_set_p(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ok" then
		cc.Director:getInstance():getOpenGLView():setIMEKeyboardState(false)
		TeamNameModifyDialog:setName()
	elseif arg_1_1 == "btn_close" or arg_1_1 == "btn_cancel" then
		TeamNameModifyDialog:close()
	end
end

function TeamNameModifyDialog.close(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.dlg) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(250)), REMOVE()), arg_2_0.vars.dlg, "block")
	BackButtonManager:pop("TeamNameModifiyDialog")
	
	arg_2_0.vars = nil
end

function TeamNameModifyDialog.setName(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	local var_3_0 = arg_3_0.vars.dlg:findChildByName("txt_name_input"):getString() or ""
	local var_3_1 = arg_3_0.vars.alert_1 or "ui_team_name_change_alert_1"
	local var_3_2 = arg_3_0.vars.alert_2 or "ui_team_name_change_alert_2"
	
	if string.starts(var_3_0, " ") then
		balloon_message_with_sound(var_3_2)
		
		return 
	end
	
	local var_3_3 = string.trim(var_3_0)
	
	if check_abuse_filter(var_3_3, ABUSE_FILTER.CHAT) then
		balloon_message_with_sound(var_3_1)
		
		return 
	end
	
	if UIUtil:checkInvalidCharacter(var_3_3, false) then
		balloon_message_with_sound(var_3_1)
		
		return 
	end
	
	local var_3_4 = arg_3_0.vars.len_min or 1
	local var_3_5 = arg_3_0.vars.len_max or 14
	
	if string.match(var_3_3, "^%w+") == var_3_3 or utf8len(var_3_3) == string.len(var_3_3) then
		var_3_4 = arg_3_0.vars.onebyte_len_min or 1
		var_3_5 = arg_3_0.vars.onebyte_len_max or 16
	end
	
	if var_3_4 > utf8len(var_3_3) then
		balloon_message_with_sound(var_3_2)
		
		return 
	elseif var_3_5 < utf8len(var_3_3) then
		balloon_message_with_sound(var_3_2)
		
		return 
	end
	
	if get_cocos_refid(arg_3_0.vars.control) then
		if_set(arg_3_0.vars.control, "txt_team", var_3_3)
	end
	
	if arg_3_0.vars.callback then
		arg_3_0.vars.callback(arg_3_0.vars.idx, var_3_3)
	else
		Account:setTeamName(arg_3_0.vars.idx, var_3_3)
		arg_3_0:close()
	end
end

function TeamNameModifyDialog.init(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if UIAction:Find("block") then
		return 
	end
	
	if arg_4_0.vars then
		return 
	end
	
	local var_4_0 = load_dlg("team_name_set_p", false, "wnd")
	
	arg_4_0.vars = {}
	arg_4_3 = arg_4_3 or {}
	
	SceneManager:getRunningNativeScene():addChild(var_4_0)
	BackButtonManager:push({
		check_id = "TeamNameModifiyDialog",
		back_func = function()
			TeamNameModifyDialog:close()
		end
	})
	
	arg_4_0.vars.control = arg_4_2
	arg_4_0.vars.dlg = var_4_0
	arg_4_0.vars.idx = arg_4_1
	arg_4_0.vars.len_min = arg_4_3.len_min
	arg_4_0.vars.len_max = arg_4_3.len_max
	arg_4_0.vars.onebyte_len_min = arg_4_3.onebyte_len_min
	arg_4_0.vars.onebyte_len_max = arg_4_3.onebyte_len_max
	arg_4_0.vars.callback = arg_4_3.callback
	
	if arg_4_3.name then
		if_set(arg_4_0.vars.dlg, "txt_title", T(arg_4_3.name))
	end
	
	if arg_4_3.desc then
		if_set(arg_4_0.vars.dlg, "txt_info", T(arg_4_3.desc))
	end
	
	if arg_4_3.alert_1 then
		arg_4_0.vars.alert_1 = arg_4_3.alert_1
	end
	
	if arg_4_3.alert_2 then
		arg_4_0.vars.alert_2 = arg_4_3.alert_2
	end
end
