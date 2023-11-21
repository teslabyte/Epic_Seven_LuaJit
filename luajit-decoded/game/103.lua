SeasonPassRankUpInfo = SeasonPassRankUpInfo or {}
SeasonPassRankUpInfo.vars = {}
SeasonPassRankUpInfo.scroll_view = {}

function HANDLER.season_pass_rankup_info(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		SeasonPassRankUpInfo:close()
		
		return 
	end
end

function SeasonPassRankUpInfo.close(arg_2_0)
	if not get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("season_pass_rankup_info")
	arg_2_0.vars.wnd:removeFromParent()
	
	arg_2_0.vars.wnd = nil
end

function SeasonPassRankUpInfo.show(arg_3_0, arg_3_1)
	if arg_3_0.vars.wnd then
		return 
	end
	
	local var_3_0 = SeasonPass:isModeEpic(arg_3_1)
	
	arg_3_0.vars.wnd = load_dlg("season_pass_rankup_info", true, "wnd", function()
		arg_3_0:close()
	end)
	
	if_set_visible(arg_3_0.vars.wnd, "n_costompass", not var_3_0)
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(150)), arg_3_0.vars.wnd, "block")
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.wnd)
	
	local var_3_1 = T(var_3_0 and "season_start_popup_title" or "substory_start_popup_title", {
		season_name = SeasonPass:getName(arg_3_1)
	})
	
	if_set(arg_3_0.vars.wnd, "txt_title", var_3_1)
	
	local var_3_2 = T(var_3_0 and "season_exp_popup_desc1_1" or "substory_exp_popup_desc")
	
	if_set(arg_3_0.vars.wnd, "t_disc", var_3_2)
	
	if not var_3_0 then
		return 
	end
	
	local var_3_3 = arg_3_0.vars.wnd:findChildByName("n_epicpass")
	
	if not get_cocos_refid(var_3_3) then
		return 
	end
	
	copy_functions(ScrollView, arg_3_0.scroll_view)
	
	local var_3_4 = var_3_3:findChildByName("scrollview")
	
	arg_3_0.scroll_view:initScrollView(var_3_4, 259, 80)
	
	local var_3_5 = SeasonPass:getExpDatas(arg_3_1)
	local var_3_6 = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_5) do
		var_3_6[#var_3_6 + 1] = iter_3_1
	end
	
	table.sort(var_3_6, function(arg_5_0, arg_5_1)
		return arg_5_0.sort < arg_5_1.sort
	end)
	arg_3_0.scroll_view:createScrollViewItems(var_3_6)
	arg_3_0.scroll_view.scrollview:getInnerContainer():setPosition(0, -12)
end

function SeasonPassRankUpInfo.scroll_view.getScrollViewItem(arg_6_0, arg_6_1)
	local var_6_0 = load_dlg("season_pass_rankup_item", nil, "wnd")
	local var_6_1 = UIUtil:getRewardIcon(nil, arg_6_1.value, {
		show_name = true,
		parent = var_6_0:findChildByName("n_1")
	})
	
	if_set(var_6_1, "txt_name", "x" .. arg_6_1.exp)
	if_set(var_6_1, "txt_type", T("season_exp_popup_desc1_2"))
	
	return var_6_0
end
