LotaLevelInfoUI = {}

function HANDLER.clan_heritage_level_info(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaLevelInfoUI:onClose()
	end
end

function LotaLevelInfoUI.init(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_level_info")
	
	arg_2_1:addChild(arg_2_0.vars.dlg)
	BackButtonManager:push({
		check_id = "level_info_ui",
		back_func = function()
			arg_2_0:onClose()
		end,
		dlg = arg_2_0.vars.dlg
	})
	arg_2_0:createUI()
end

function LotaLevelInfoUI.createUI(arg_4_0)
	local var_4_0 = arg_4_0.vars.dlg:findChildByName("ScrollView")
	local var_4_1 = {}
	
	for iter_4_0 = 1, 99 do
		local var_4_2, var_4_3, var_4_4, var_4_5, var_4_6 = DB("clan_heritage_rank_data", tostring(iter_4_0), {
			"id",
			"max_charge_token",
			"max_hero",
			"item_value",
			"recharge_token"
		})
		
		if not var_4_2 then
			break
		end
		
		table.insert(var_4_1, {
			lv = var_4_2,
			max_charge_token = var_4_3,
			max_hero = var_4_4,
			upgrade_point = var_4_5,
			recharge_token = var_4_6
		})
	end
	
	arg_4_0.vars.ScrollView = {}
	
	copy_functions(ScrollView, arg_4_0.vars.ScrollView)
	
	function arg_4_0.vars.ScrollView.getScrollViewItem(arg_5_0, arg_5_1)
		local var_5_0 = LotaUtil:getUIControl("clan_heritage_level_info_item")
		
		LotaUtil:updateLevelIconWithLv(var_5_0, arg_5_1.lv, {
			n_expedition_level_name = "n_reward"
		})
		if_set(var_5_0, "t_reward1", arg_5_1.max_charge_token)
		if_set(var_5_0, "t_reward2", arg_5_1.max_hero)
		if_set(var_5_0, "t_reward3", arg_5_1.upgrade_point)
		
		local var_5_1 = "-"
		
		if arg_5_1.recharge_token > 0 then
			var_5_1 = tostring(arg_5_1.recharge_token)
		end
		
		if_set(var_5_0, "t_reward4", var_5_1)
		if_set_visible(var_5_0, "t_reward3_none", arg_5_1.upgrade_point == 0)
		if_set_visible(var_5_0, "n_reward3", arg_5_1.upgrade_point ~= 0)
		
		return var_5_0
	end
	
	arg_4_0.vars.ScrollView:initScrollView(var_4_0, 937, 50)
	arg_4_0.vars.ScrollView:createScrollViewItems(var_4_1)
end

function LotaLevelInfoUI.isOpen(arg_6_0)
	return arg_6_0.vars and arg_6_0.vars.dlg and get_cocos_refid(arg_6_0.vars.dlg)
end

function LotaLevelInfoUI.onClose(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.dlg) then
		return 
	end
	
	arg_7_0.vars.dlg:removeFromParent()
	BackButtonManager:pop({
		check_id = "level_info_ui",
		dlg = arg_7_0.vars.dlg
	})
end
