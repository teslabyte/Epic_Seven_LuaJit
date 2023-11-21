SeasonPassRankUpMsgBox = SeasonPassRankUpMsgBox or {}
SeasonPassRankUpMsgBox.vars = {}

function HANDLER.season_pass_rankup_msgbox(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_default" then
		SeasonPassRankUpMsgBox:close()
		
		return 
	end
end

function SeasonPassRankUpMsgBox.close(arg_2_0)
	BackButtonManager:pop("season_pass_rankup_msgbox")
	
	if arg_2_0.vars.wnd.fn_close then
		arg_2_0.vars.wnd.fn_close()
	end
	
	arg_2_0.vars.wnd:removeFromParent()
	
	arg_2_0.vars.wnd = nil
end

function SeasonPassRankUpMsgBox.show(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0.vars.wnd = load_dlg("season_pass_rankup_msgbox", nil, "wnd", function()
		arg_3_0:close()
	end)
	arg_3_0.vars.wnd.fn_close = arg_3_4
	
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.wnd)
	
	local var_3_0 = SeasonPass:isTypeRank(arg_3_1)
	local var_3_1 = SeasonPass:isModeEpic(arg_3_1)
	local var_3_2 = var_3_1 and T("season_buy_rank_popup_title2") or var_3_0 and T("substory_buy_rank_popup_title2") or T("substory_buy_achievement_popup_title2")
	local var_3_3 = var_3_1 and T("season_buy_rank_popup_desc2_1") or var_3_0 and T("substory_buy_rank_popup_desc2_1") or T("substory_buy_achievement_popup_desc2_1")
	
	if_set_visible(arg_3_0.vars.wnd, "n_rank", var_3_0)
	if_set_visible(arg_3_0.vars.wnd, "n_achieve", not var_3_0)
	
	if var_3_0 then
		local var_3_4 = SeasonPass:getMaxRank(arg_3_1)
		
		UIUtil:setLevel(arg_3_0.vars.wnd:findChildByName("n_rank_before"), arg_3_2, var_3_4, 3, false, nil, 18)
		UIUtil:setLevel(arg_3_0.vars.wnd:findChildByName("n_rank_after"), arg_3_3, var_3_4, 3, false, nil, 18)
	else
		if_set(arg_3_0.vars.wnd:findChildByName("n_achieve_before"), "txt_point", arg_3_2)
		if_set(arg_3_0.vars.wnd:findChildByName("n_achieve_after"), "txt_point", arg_3_3)
	end
	
	if_set(arg_3_0.vars.wnd, "txt_title", var_3_2)
	if_set(arg_3_0.vars.wnd, "text", var_3_3)
	if_set_arrow(arg_3_0.vars.wnd)
	
	local var_3_5 = arg_3_0.vars.wnd:findChildByName("n_eff")
	
	EffectManager:Play({
		pivot_x = 0,
		fn = "ui_reward_popup_eff.cfx",
		pivot_y = 0,
		pivot_z = 99998,
		layer = var_3_5
	})
	UIAction:Add(DELAY(600), arg_3_0.vars.wnd, "block")
end
