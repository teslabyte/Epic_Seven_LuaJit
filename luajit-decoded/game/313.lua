GachaUnitShopPopup = {}

copy_functions(ScrollView, GachaUnitShopPopup)
copy_functions(ShopCommon, GachaUnitShopPopup)

function HANDLER.gacha_popup_shop(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		GachaUnitShopPopup:close()
	end
end

function GachaUnitShopPopup.close(arg_2_0)
	Dialog:close("gacha_popup_shop")
	
	arg_2_0.vars = nil
end

function GachaUnitShopPopup.show(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars = {}
	arg_3_0.vars.shop_category = arg_3_1
	arg_3_0.vars.gacha_mode = arg_3_2
	arg_3_0.vars.list = arg_3_0:getCategoryShopItemList(arg_3_1, true)
	
	if table.count(arg_3_0.vars.list) == 0 then
		return 
	end
	
	arg_3_0.vars.token_id = nil
	
	if arg_3_0.vars.gacha_mode == "gacha_customgroup" then
		arg_3_0.vars.token_id = "to_gpmileage1"
	elseif arg_3_0.vars.gacha_mode == "gacha_customspecial" then
		arg_3_0.vars.token_id = "to_gpmileage2"
	end
	
	if not arg_3_0.vars.token_id then
		return 
	end
	
	arg_3_0.vars.dlg = Dialog:open("wnd/gacha_popup_shop", arg_3_0, {
		modal = true,
		use_backbutton = true
	})
	arg_3_0.vars.scrollview = arg_3_0.vars.dlg:getChildByName("scrollview")
	
	arg_3_0:initScrollView(arg_3_0.vars.scrollview, 690, 140)
	arg_3_0:updatePopupShopList(true)
	arg_3_0:jumpToPercent(0)
	
	local var_3_0 = arg_3_0.vars.dlg:getChildByName("n_left_npc")
	local var_3_1, var_3_2 = UIUtil:getPortraitAni("npc1002", {
		pin_sprite_position_y = true
	})
	
	if var_3_1 then
		var_3_0:getChildByName("n_portrait"):addChild(var_3_1)
		var_3_1:setScale(1.3)
		var_3_1:setPosition(20, -150)
	end
	
	arg_3_0.vars.portrait = var_3_1
	
	local var_3_3 = DB("item_token", arg_3_0.vars.token_id, {
		"name"
	})
	local var_3_4 = var_3_0:getChildByName("n_info")
	
	if arg_3_0.vars.token_id == "to_gpmileage2" then
		if_set(var_3_4, "t_gp_shop", T("ui_ct_gachaspecial_shop_info", {
			token_type = T(var_3_3)
		}))
		if_set_sprite(var_3_4, "n_icon", "img/icon_menu_gpmileage2.png")
		if_set(var_3_4, "t_disc_gp_shop", T("ui_ct_gachaspecial_shop_close_info"))
	else
		if_set(var_3_4, "t_gp_shop", T("shop_gpmileage_warning", {
			token_type = T(var_3_3)
		}))
		if_set_sprite(var_3_4, "n_icon", "img/icon_menu_gpmileage.png")
		if_set(var_3_4, "t_disc_gp_shop", T("shop_gpmileage_info"))
	end
	
	if_set(var_3_4, "label", T("ui_gacha_popup_buy_desc"))
	
	if arg_3_0.vars.list and arg_3_0.vars.list[1] then
		local var_3_5 = var_3_0:getChildByName("n_balloon")
		
		if to_n(arg_3_0.vars.list[1].end_time) - 604800 < os.time() then
			if arg_3_0.vars.token_id == "to_gpmileage2" then
				if_set(var_3_5, "txt_balloon", T("npc_ct_gachaspecial_shop_close", {
					token_type = T(var_3_3)
				}))
			else
				if_set(var_3_5, "txt_balloon", T("shop_gpmileage_balloon_after", {
					token_type = T(var_3_3)
				}))
			end
		elseif arg_3_0.vars.token_id == "to_gpmileage2" then
			if_set(var_3_5, "txt_balloon", T("npc_ct_gachaspecial_shop_open", {
				token_type = T(var_3_3)
			}))
		else
			if_set(var_3_5, "txt_balloon", T("shop_gpmileage_balloon_during", {
				token_type = T(var_3_3)
			}))
		end
	else
		if_set_visible(var_3_0, "n_balloon", false)
	end
	
	arg_3_0:updateLeftTime()
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.dlg)
	Scheduler:addSlow(arg_3_0.vars.dlg, arg_3_0.updateLeftTime, arg_3_0)
end

function GachaUnitShopPopup.updateLeftTime(arg_4_0)
	local var_4_0 = arg_4_0.vars.dlg:getChildByName("n_left_npc"):getChildByName("n_info")
	local var_4_1
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.list) do
		if iter_4_1.end_time and not var_4_1 then
			var_4_1 = iter_4_1.end_time
			
			break
		end
	end
	
	local var_4_2 = to_n(var_4_1) - os.time()
	
	if var_4_2 > 0 then
		if_set(var_4_0, "time", T("shop_gpmileage_remain_time", {
			remain_time = sec_to_full_string(var_4_2)
		}))
	else
		if_set(var_4_0, "time", T("expired"))
	end
end

function GachaUnitShopPopup.updatePopupShopList(arg_5_0, arg_5_1)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.dlg) then
		return 
	end
	
	arg_5_0.vars.DB = {}
	
	local var_5_0 = os.time()
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.list) do
		local var_5_1, var_5_2, var_5_3 = arg_5_0:GetRestCount(iter_5_1, var_5_0)
		
		if (var_5_3 == "only_once" or iter_5_1.buy_once) and var_5_2 and to_n(var_5_1) < 1 then
			iter_5_1.sold_out = true
			
			if iter_5_1.sort < 100000 then
				iter_5_1.sort = iter_5_1.sort + 100000
			end
		end
		
		arg_5_0.vars.DB[iter_5_1.id] = iter_5_1
	end
	
	table.sort(arg_5_0.vars.list, function(arg_6_0, arg_6_1)
		return tonumber(arg_6_0.sort) < tonumber(arg_6_1.sort)
	end)
	
	if arg_5_1 then
		arg_5_0:createScrollViewItems(arg_5_0.vars.list)
	end
	
	arg_5_0:updateTimeLimitedItems(os.time())
	
	local var_5_4 = arg_5_0.vars.dlg:getChildByName("n_window"):getChildByName("n_top")
	
	if_set(var_5_4, "txt_gpcoin_count", comma_value(to_n(Account:getCurrency(arg_5_0.vars.token_id))))
	
	if arg_5_0.vars.token_id == "to_gpmileage2" then
		if_set(var_5_4, "t_title", T("ui_ct_gachaspecial_minishop_title"))
	else
		if_set(var_5_4, "t_title", T("shop_gpmileage_name"))
	end
	
	local var_5_5 = var_5_4:getChildByName("n_token")
	
	UIUtil:getRewardIcon(nil, arg_5_0.vars.token_id, {
		no_frame = true,
		scale = 1,
		parent = var_5_5
	})
	GachaUnit:updateMileageGroup(arg_5_0.vars.token_id)
end

function GachaUnitShopPopup.getScrollViewItem(arg_7_0, arg_7_1)
	arg_7_1.is_limit_button = arg_7_0.vars.DB and arg_7_0.vars.DB[arg_7_1.id] and arg_7_0.vars.DB[arg_7_1.id].limit_count
	
	local var_7_0 = arg_7_0:makeShopItem(arg_7_1, "wnd/shop_card.csb", {
		no_count_confirm = true
	})
	
	var_7_0.guide_tag = arg_7_1.id
	
	return var_7_0
end

function GachaUnitShopPopup.onSelectScrollViewItem(arg_8_0, arg_8_1, arg_8_2)
end

function GachaUnitShopPopup.reqBuy(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_3 = arg_9_3 or "normal"
	
	print("reqBuy item.id : ", arg_9_1.id, arg_9_1.token)
	
	if PLATFORM ~= "win32" and arg_9_1.token == "cash" then
		startIapBilling({
			shop = "normal",
			item_id = arg_9_1.id
		})
	elseif PLATFORM == "win32" and arg_9_1.token == "cash" then
		query("buy", {
			item = arg_9_1.id,
			shop = arg_9_3,
			order_id = "test_" .. get_udid(),
			type = arg_9_1.type,
			multiply = arg_9_2 or 1,
			caller = arg_9_0.vars.gacha_mode
		})
	else
		query("buy", {
			item = arg_9_1.id,
			shop = arg_9_3,
			type = arg_9_1.type,
			multiply = arg_9_2 or 1,
			caller = arg_9_0.vars.gacha_mode
		})
	end
end
