SeasonPassPromotion = SeasonPassPromotion or {}
SeasonPassPromotion.vars = {}

function HANDLER.season_pass_promotion(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_buy" then
		local var_1_0 = SeasonPassPromotion.vars.season_pass_id
		local var_1_1 = arg_1_0.package
		
		if not UIUtil:checkCurrencyDialog("crystal", var_1_1.price) then
			return 
		end
		
		local function var_1_2()
			local var_2_0 = {
				value = 1,
				token = "to_crystal",
				type = var_1_1.tooltip,
				price = var_1_1.price
			}
			local var_2_1 = ShopCommon:ShowConfirmDialog(var_2_0, function()
				if arg_1_1 == "btn_buy" then
					query("unlock_season_pass_grade", {
						event_id = var_1_0,
						buy_type = var_1_1.type
					})
				end
			end)
			
			UIUtil:getRewardIcon(var_2_0.value, var_2_0.type, {
				no_resize_name = true,
				show_name = true,
				parent = var_2_1:getChildByName("n_item_pos"),
				txt_name = var_2_1:getChildByName("txt_shop_name"),
				txt_type = var_2_1:getChildByName("txt_shop_type")
			})
		end
		
		local var_1_3 = SeasonPass:isPrevSeasonPass(var_1_0)
		local var_1_4 = SeasonPass:isExchangePeriod(var_1_0)
		
		if var_1_3 or var_1_4 then
			Dialog:msgBox(T("seasonpass_reward_period_warning_desc"), {
				title = T("seasonpass_reward_period_warning_title"),
				handler = var_1_2
			})
		else
			var_1_2()
		end
		
		return 
	end
	
	if arg_1_1 == "btn_close" then
		SeasonPassPromotion:close()
		
		return 
	end
end

function SeasonPassPromotion.close(arg_4_0)
	if not get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "season_pass_promotion",
		dlg = arg_4_0.vars.wnd
	})
	arg_4_0.vars.wnd:removeFromParent()
	
	arg_4_0.vars.wnd = nil
end

function SeasonPassPromotion.isShow(arg_5_0)
	return get_cocos_refid(arg_5_0.vars.wnd)
end

function SeasonPassPromotion.show(arg_6_0, arg_6_1)
	if arg_6_0:isShow() then
		return 
	end
	
	arg_6_0.vars = {}
	arg_6_0.vars.season_pass_id = arg_6_1
	arg_6_0.vars.wnd = load_dlg("season_pass_promotion", nil, "wnd", function()
		arg_6_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_6_0.vars.wnd)
	
	local var_6_0 = SeasonPass:isModeEpic(arg_6_0.vars.season_pass_id)
	local var_6_1 = arg_6_0.vars.wnd:findChildByName("n_top")
	
	if_set(var_6_1, "txt_title", T(var_6_0 and "ui_season_pass_promotion_title" or "ui_substory_pass_promotion_title"))
	if_set(var_6_1, "t_disc", T(var_6_0 and "ui_season_pass_promotion_desc" or "ui_substory_pass_promotion_desc"))
	
	local var_6_2 = arg_6_0.vars.wnd:findChildByName("n_item_node_1")
	local var_6_3 = arg_6_0.vars.wnd:findChildByName("n_item_node_2")
	local var_6_4, var_6_5 = SeasonPass:getBuyPackages(arg_6_0.vars.season_pass_id)
	
	if_set_visible(var_6_2, nil, not var_6_5)
	if_set_visible(var_6_3, nil, var_6_5)
	
	if var_6_5 then
		arg_6_0:setBuyPackageUI(var_6_3:findChildByName("clip1"), var_6_3:findChildByName("n_btn1"), var_6_4)
		arg_6_0:setBuyPackageUI(var_6_3:findChildByName("clip2"), var_6_3:findChildByName("n_btn2"), var_6_5)
	else
		arg_6_0:setBuyPackageUI(var_6_2:findChildByName("clip1"), var_6_2:findChildByName("n_btn1"), var_6_4)
	end
end

function SeasonPassPromotion.reqBuyPackage(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	query("unlock_season_pass_grade", {
		event_id = arg_8_0.vars.season_pass_id,
		buy_type = arg_8_1.type
	})
end

function SeasonPassPromotion.setBuyPackageUI(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if_set_visible(arg_9_2, "n_purchased", false)
	if_set_visible(arg_9_2, "n_period_0", false)
	
	local var_9_0 = arg_9_2:findChildByName("btn_buy")
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	var_9_0.package = arg_9_3
	
	UIUtil:getRewardIcon(nil, "to_crystal", {
		no_frame = true,
		scale = 0.6,
		parent = var_9_0:getChildByName("n_pay_token")
	})
	if_set(var_9_0, "txt_price", comma_value(arg_9_3.price))
	
	local var_9_1 = arg_9_1:findChildByName("n_bg")
	
	if not get_cocos_refid(var_9_1) then
		return 
	end
	
	var_9_1:removeAllChildren()
	
	local var_9_2 = cc.Sprite:create("banner/" .. arg_9_3.banner .. ".png") or cc.Sprite:create("banner/package_banner.png")
	
	if var_9_2 then
		var_9_1:addChild(var_9_2)
	end
end
