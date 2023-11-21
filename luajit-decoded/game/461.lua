BattleReadyVisible = {}
BattleReadyVisible._default = {
	btn_select_team = false,
	n_support = false,
	difficulty_disc = false,
	n_select_difficulty = false,
	n_select_supporter = false,
	btn_friend = false,
	n_team_formation = false,
	support_disc = false,
	n_difficulty = false
}
BattleReadyVisible.difficulty = {
	n_select_supporter = true,
	n_difficulty = true,
	btn_select_team = true,
	difficulty_disc = true
}
BattleReadyVisible.support_friend = {
	support_disc = true,
	n_support = true,
	btn_friend = true,
	n_select_difficulty = true
}
BattleReadyVisible.team_formation = {
	n_team_formation = true
}
BattleReadyVisible.opts = {}
BattleReadyVisible.opts.disable_difficulty = {
	n_select_bg = false,
	n_difficulty_enable = false,
	n_difficulty_disable = true
}
BattleReadyVisible.opts.enable_difficulty = {
	n_select_bg = true,
	n_difficulty_enable = true,
	n_difficulty_disable = false
}
BattleReadyVisible.opts.disable_support = {
	n_supporter_disable = true,
	btn_change_supporter = false,
	n_supporter_enable = false
}
BattleReadyVisible.opts.enable_support = {
	n_supporter_disable = false,
	btn_change_supporter = true,
	n_supporter_enable = true
}

function BattleReadyVisible.setVisibleOptional(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_0.opts[arg_1_2]
	
	if not var_1_0 then
		Log.e("NO FLOW! ")
		
		return 
	end
	
	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		if_set_visible(arg_1_1, iter_1_0, iter_1_1)
	end
end

function BattleReadyVisible.setVisible(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0[arg_2_2]
	
	if not var_2_0 then
		Log.e("NO FLOW! ")
		
		return 
	end
	
	for iter_2_0, iter_2_1 in pairs(arg_2_0._default) do
		if_set_visible(arg_2_1, iter_2_0, iter_2_1)
	end
	
	for iter_2_2, iter_2_3 in pairs(var_2_0) do
		if_set_visible(arg_2_1, iter_2_2, iter_2_3)
	end
end
