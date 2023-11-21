SeasonPassUnlock = SeasonPassUnlock or {}
SeasonPassUnlock.vars = {}

function HANDLER.season_pass_unlock(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		SeasonPassUnlock:close()
	end
end

function SeasonPassUnlock.close(arg_2_0)
	if arg_2_0.vars.wnd.fn_close then
		arg_2_0.vars.wnd.fn_close()
	end
	
	BackButtonManager:pop("season_pass_unlock")
	arg_2_0.vars.wnd:removeFromParent()
	
	arg_2_0.vars.wnd = nil
end

function SeasonPassUnlock.isOpen(arg_3_0)
	return get_cocos_refid(arg_3_0.vars.wnd)
end

function SeasonPassUnlock.open(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars.wnd = load_dlg("season_pass_unlock", nil, "wnd", function()
		arg_4_0:close()
	end)
	arg_4_0.vars.wnd.fn_close = arg_4_2
	
	SceneManager:getRunningPopupScene():addChild(arg_4_0.vars.wnd)
	
	local var_4_0 = SeasonPass:isModeEpic(arg_4_1.pass_id)
	local var_4_1 = T(var_4_0 and "season_success_title1" or "substory_success_title1")
	
	if_set(arg_4_0.vars.wnd, "txt_title", var_4_1)
	
	local var_4_2 = "season_pass_unlock_reward_tag_pr"
	local var_4_3 = "season_pass_unlock_reward_desc_pr"
	
	if arg_4_1.grade == 2 then
		if arg_4_1.type == "pass_upgrade" then
			var_4_2 = "season_pass_unlock_reward_tag_up"
			var_4_3 = "season_pass_unlock_reward_desc_up"
		else
			var_4_2 = "season_pass_unlock_reward_tag_sp"
			var_4_3 = "season_pass_unlock_reward_desc_sp"
		end
	end
	
	if_set(arg_4_0.vars.wnd, "txt_tag", T(var_4_2))
	upgradeLabelToRichLabel(arg_4_0.vars.wnd, "infor")
	if_set(arg_4_0.vars.wnd, "infor", T(var_4_3, {
		contents = SeasonPass:getName(arg_4_1.pass_id)
	}))
end
