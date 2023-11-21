ShopPromotion = {}

copy_functions(ScrollView, ShopPromotion)

function HANDLER.shop_promotion(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_buy" then
		ShopPromotion:reqBuy(arg_1_0.item)
	end
end

function HANDLER.lobby_popup_promotion_renew(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" and not ShopPromotion:isLoading() then
		ShopPromotion:popupNext()
	end
	
	if arg_2_1 == "btn_close2" then
		ShopPromotion:close()
	end
	
	if arg_2_1 == "btn_buy" then
		ShopPromotion:reqBuy(arg_2_0.item)
	end
end

function HANDLER.shop_promotion_base_renew(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_buy" then
		ShopPromotion:reqBuy(arg_3_0.item)
	end
end

function HANDLER.shop_promotion_scroll_card(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_buy" then
		ShopPromotion:reqBuy(arg_4_0.item)
	end
end

function HANDLER.shop_promotion_button(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_buy" then
		ShopPromotion:reqBuy(arg_5_0.item)
	end
end

function HANDLER.shop_promotion_rankup(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_reward_item" then
		ShopPromotion:receiveCustomizedRankupRewards(arg_6_0.item_data, arg_6_0.paid_item)
	end
	
	if arg_6_1 == "btn_get_reward" then
		ShopPromotion:receiveCustomizedRankupRewards2(arg_6_0)
	end
end

function HANDLER.shop_promotion_mura(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_get_reward" then
		ShopPromotion:receiveCustomizedMuraRewards(arg_7_0, true)
	elseif arg_7_1 == "btn_reward_item" then
		ShopPromotion:receiveCustomizedMuraRewards(arg_7_0, false)
	end
end

function HANDLER.shop_promotion_hero_sel(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_get_reward" or arg_8_1 == "btn_hero_sel" then
		ShopPromotion:viewCustomizedHeroSelect()
	end
end

function HANDLER.shop_promotion_lobby_pack(arg_9_0, arg_9_1)
	if arg_9_1 == "btn_get_reward" then
		ShopPromotion:previewLobbyTheme()
	end
end

function HANDLER.shop_promotion_noti_balloon(arg_10_0, arg_10_1)
	local var_10_0 = string.split(arg_10_1, ":")
	
	if var_10_0[1] == "btn_ballon_on" then
		ShopPromotion:toggleAddPromotionBallon(arg_10_0, var_10_0[2])
	end
end

function MsgHandler.select_custom_package_hero_select(arg_11_0)
	if arg_11_0.update_user_configs then
		Account:updateUserConfigs(arg_11_0.update_user_configs)
	end
end

function MsgHandler.select_custom_package_item_select(arg_12_0)
	if arg_12_0.update_user_configs then
		Account:updateUserConfigs(arg_12_0.update_user_configs)
	end
end

function MsgHandler.receive_rank_promotion(arg_13_0)
	local var_13_0 = {
		title = T("rank_package_title"),
		desc = T("rank_package_desc")
	}
	
	Account:addReward(arg_13_0.rewards, {
		play_reward_data = var_13_0
	})
	
	AccountData.pkg_rank = arg_13_0.pkg_rank
	
	ShopPromotion:updateCategories()
end

function MsgHandler.receive_rankpack_rewards(arg_14_0)
	if arg_14_0.updated_ticketed_limits then
		for iter_14_0, iter_14_1 in pairs(arg_14_0.updated_ticketed_limits) do
			AccountData.ticketed_limits[iter_14_0] = iter_14_1
		end
	end
	
	if arg_14_0.package_limits then
		AccountData.package_limits = arg_14_0.package_limits
	end
	
	local var_14_0 = {
		title = T("rankuppack_reward_get_title"),
		desc = T("rankuppack_reward_get_desc")
	}
	local var_14_1 = Account:addReward(arg_14_0.rewards, {
		play_reward_data = var_14_0,
		handler = function()
			ShopPromotion:popupRemainRankupRewards(arg_14_0.package_id)
		end
	})
	
	if get_cocos_refid(var_14_1.reward_dlg) then
		local var_14_2 = var_14_1.reward_dlg:getChildByName("n_top")
		
		if get_cocos_refid(var_14_2) then
			if_set(var_14_2, "txt_title", var_14_0.title)
		end
	end
	
	ShopPromotion:updateCustomizeRankup()
end

function MsgHandler.receive_custom_package_rewards(arg_16_0)
	if arg_16_0.updated_ticketed_limits then
		for iter_16_0, iter_16_1 in pairs(arg_16_0.updated_ticketed_limits) do
			AccountData.ticketed_limits[iter_16_0] = iter_16_1
		end
	end
	
	local var_16_0 = {
		title = T("ui_msgbox_rewards_title"),
		desc = T("package_reward_get_info")
	}
	local var_16_1 = Account:addReward(arg_16_0.rewards, {
		play_reward_data = var_16_0
	})
	
	if get_cocos_refid(var_16_1.reward_dlg) then
		local var_16_2 = var_16_1.reward_dlg:getChildByName("n_top")
		
		if get_cocos_refid(var_16_2) then
			if_set(var_16_2, "txt_title", var_16_0.title)
		end
	end
	
	ShopPromotion:updateMainPage()
end

function MsgHandler.receive_daily_promotion(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0) do
		if string.starts(iter_17_0, "pkg_") then
			AccountData[iter_17_0] = iter_17_1
		end
	end
	
	if arg_17_0.updated_ticketed_limits then
		for iter_17_2, iter_17_3 in pairs(arg_17_0.updated_ticketed_limits) do
			AccountData.ticketed_limits[iter_17_2] = iter_17_3
		end
	end
	
	;({
		title = T("package_reward_title"),
		desc = T("package_reward_desc2")
	}).dont_proc_tutorial = true
	
	Account:addReward(arg_17_0.rewards)
	
	if arg_17_0.mail_update then
		AccountData.mails = arg_17_0.mail_update
		
		TopBarNew:updateMailMark()
	end
	
	PackageDailyRewardPopup:open(arg_17_0.package_rewards)
end

PackageDailyRewardPopup = {}

copy_functions(ScrollView, PackageDailyRewardPopup)

function PackageDailyRewardPopup.open(arg_18_0, arg_18_1)
	if arg_18_1 == "_test_data" then
		arg_18_1 = {
			{
				rest_days = 28,
				item = "to_crystal",
				count = 30,
				shop_item_name = "ns_monthly_1",
				promotion_id = "monthly_1",
				is_mail = "n",
				shop_id = "e7_monthly_5"
			},
			{
				rest_days = 28,
				item = "sp_bfexp",
				count = 1,
				shop_item_name = "ns_monthly_1",
				promotion_id = "monthly_1",
				is_mail = "n",
				shop_id = "e7_monthly_5"
			},
			{
				rest_days = 29,
				item = "to_stamina",
				count = 70,
				shop_item_name = "ns_monthly_2",
				promotion_id = "monthly_2",
				is_mail = "y",
				shop_id = "e7_monthly_10"
			},
			{
				rest_days = 29,
				item = "sp_bf_gold2",
				count = 1,
				shop_item_name = "ns_monthly_2",
				promotion_id = "monthly_2",
				is_mail = "n",
				shop_id = "e7_monthly_10"
			},
			{
				item = "sp_gachafree_4_ticket",
				count = 1,
				shop_item_name = "ns_gacha7days_10",
				promotion_id = "gacha7days_1",
				is_mail = "n",
				rest_days = 6
			}
		}
	end
	
	if not arg_18_1 or table.count(arg_18_1) == 0 then
		return 
	end
	
	arg_18_0.vars = {}
	arg_18_0.vars.wnd = load_dlg("get_item_package", true, "wnd")
	
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("scrollview_1")
	
	arg_18_0.vars.itemView = ItemListView_v2:bindControl(var_18_0)
	
	local var_18_1 = load_control("wnd/get_item_package_item.csb")
	
	if var_18_0.STRETCH_INFO then
		local var_18_2 = var_18_0:getContentSize()
		
		resetControlPosAndSize(var_18_1, var_18_2.width, var_18_0.STRETCH_INFO.width_prev)
	end
	
	local var_18_3 = {
		onUpdate = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			arg_18_0:updateItem(arg_19_1, arg_19_3)
			
			return arg_19_3.id
		end
	}
	
	arg_18_0.vars.itemView:setRenderer(var_18_1, var_18_3)
	arg_18_0.vars.itemView:removeAllChildren()
	arg_18_0.vars.itemView:setDataSource(arg_18_1 or {})
	Dialog:msgBox(nil, {
		dont_proc_tutorial = true,
		dlg = arg_18_0.vars.wnd,
		handler = function()
			Lobby:nextNoti()
		end
	})
end

function PackageDailyRewardPopup.updateItem(arg_21_0, arg_21_1, arg_21_2)
	UIUtil:getRewardIcon(arg_21_2.count, arg_21_2.item, {
		no_resize_name = true,
		show_name = true,
		parent = arg_21_1:getChildByName("reward_item"),
		txt_name = arg_21_1:getChildByName("txt_shop_name"),
		txt_type = arg_21_1:getChildByName("txt_shop_type")
	})
	if_set(arg_21_1, "txt_time", T("package_reward_duration", {
		day = arg_21_2.rest_days
	}))
	if_set(arg_21_1, "txt_shop_type", T(arg_21_2.shop_item_name))
	
	local var_21_0 = arg_21_1:getChildByName("txt_shop_name")
	
	if get_cocos_refid(var_21_0) then
		UIUserData:call(var_21_0, "SINGLE_WSCALE(310)")
	end
	
	return arg_21_1
end

local function var_0_0(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = math.huge
	local var_22_1 = -1
	local var_22_2
	
	local function var_22_3(arg_23_0)
		if arg_22_2 and arg_22_2(arg_23_0) then
			return 
		end
		
		if arg_23_0.end_time < os.time() then
			return 
		end
		
		local var_23_0 = 0
		local var_23_1 = 0
		
		if not arg_22_1[arg_23_0.id] then
			return 
		end
		
		for iter_23_0, iter_23_1 in pairs(arg_22_1[arg_23_0.id]) do
			local var_23_2 = AccountData.package_limits[iter_23_1]
			
			if var_23_2 then
				var_23_0 = to_n(var_23_2.count) + var_23_0
				var_23_1 = to_n(var_23_2.limit_count) + var_23_1
			end
		end
		
		if var_23_1 == 0 then
			var_23_1 = 1
		end
		
		if var_23_1 <= var_23_0 then
			return 
		end
		
		local var_23_3 = var_22_0
		
		var_22_0 = math.min(var_22_0, arg_23_0.end_time)
		
		if var_22_0 == arg_23_0.end_time and (var_23_3 > var_22_0 or var_23_3 == var_22_0 and var_22_2.id > arg_23_0.id) then
			var_22_2 = arg_23_0
		end
	end
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0) do
		var_22_3(iter_22_1)
	end
	
	return var_22_2
end

function ShopPromotion.GetRestMonthlyDays(arg_24_0, arg_24_1)
	local var_24_0, var_24_1 = Account:serverTimeDayLocalDetail()
	local var_24_2 = AccountData[string.format("pkg_daily%d_e", arg_24_1)]
	
	if var_24_2 and var_24_1 <= var_24_2 then
		local var_24_3 = math.max(0, var_24_2 - var_24_1)
		
		return (math.max(0, math.floor(var_24_3 / 86400)))
	end
end

function ShopPromotion.create(arg_25_0)
	arg_25_0.vars = {}
	arg_25_0.vars.wnd = load_dlg("shop_promotion_base_renew", true, "wnd")
	arg_25_0.vars.new_package = ShopPromotion:getNewPromotionPackage()
	
	return arg_25_0.vars.wnd
end

function ShopPromotion.prepare(arg_26_0, arg_26_1)
	arg_26_0.vars.view_category = arg_26_1 or "promotion"
	
	arg_26_0:createItems()
	arg_26_0:createCategories()
	
	return arg_26_0:createCategoryMenu(true)
end

function ShopPromotion.enter(arg_27_0, arg_27_1, arg_27_2)
	if ContentDisable:byAlias("market_promotion") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if arg_27_1 == nil and arg_27_0.open_info then
		arg_27_1 = arg_27_0.open_info.item_id
	end
	
	arg_27_0.vars.view_category = arg_27_2 or "promotion"
	
	arg_27_0:initScrollView(arg_27_0.vars.wnd.c.scrollview, 312, 85)
	arg_27_0:createItems()
	arg_27_0:createCategories()
	arg_27_0:createCategoryMenu()
	
	local var_27_0 = 1
	local var_27_1 = 1
	
	if not arg_27_1 and arg_27_0.vars.category_menu_index and arg_27_0.vars.category_menu_index[1] then
		arg_27_1 = arg_27_0.vars.category_menu_index[1][1]
	end
	
	if arg_27_1 then
		for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.categories) do
			for iter_27_2 = 1, 4 do
				if not iter_27_1["package_" .. iter_27_2] then
					break
				end
				
				if iter_27_1["package_" .. iter_27_2] == arg_27_1 then
					var_27_0 = iter_27_0
					
					break
				end
			end
		end
		
		if arg_27_0.vars.category_menu_index then
			for iter_27_3, iter_27_4 in pairs(arg_27_0.vars.category_menu_index) do
				for iter_27_5 = 1, 4 do
					if not iter_27_4[iter_27_5] then
						break
					end
					
					if iter_27_4[iter_27_5] == arg_27_1 then
						var_27_1 = iter_27_3
						
						break
					end
				end
			end
		end
	end
	
	arg_27_0:selectCategory(arg_27_0.vars.categories[var_27_0], var_27_1)
	SoundEngine:play("event:/ui/lobby/btn_package")
	SAVE:setUserDefaultData("red_dot_promotion", os.time())
	
	local var_27_2 = {}
	
	for iter_27_6, iter_27_7 in pairs(AccountData.package_limits) do
		local var_27_3 = string.split(iter_27_6, ":")
		
		if var_27_3[1] == "ip" then
			var_27_2[var_27_3[2]] = {
				start_time = iter_27_7.start_time,
				end_time = iter_27_7.end_time,
				max_c = iter_27_7.max_c
			}
		end
	end
	
	SAVE:setUserDefaultData("intelli_v2", json.encode(var_27_2))
	Scheduler:addSlow(arg_27_0.vars.wnd, arg_27_0.updateRemainTime, arg_27_0)
	Analytics:setPopup("shop_promotion")
end

function ShopPromotion.isNewPromotionVisibled(arg_28_0)
	return arg_28_0.vars and arg_28_0.vars.new_package
end

function ShopPromotion.popupBaseUpdate(arg_29_0)
	set_high_fps_tick(5000)
	SoundEngine:play("event:/ui/lobby/btn_package")
	
	arg_29_0.vars.portrait = UIUtil:getPortraitAni("npc1002", {})
	
	arg_29_0.vars.portrait:setScale(1.3)
	arg_29_0.vars.portrait:setPosition(40, -160)
	arg_29_0.vars.wnd:getChildByName("n_left_npc"):getChildByName("n_portrait"):addChild(arg_29_0.vars.portrait)
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("n_balloon")
	
	arg_29_0.vars.talker_key = arg_29_0.vars.talker_key or "shop_lobby.popup"
	
	UIUtil:playNPCSoundAndTextRandomly(arg_29_0.vars.talker_key, var_29_0, "txt_balloon", 300, arg_29_0.vars.talker_key, arg_29_0.vars.portrait)
	UIAction:Add(FADE_IN(300), arg_29_0.vars.wnd, "block")
	
	local var_29_1 = arg_29_0.vars.wnd:getChildByName("n_left_npc")
	
	UIAction:Add(SEQ(MOVE_TO(0, -300, 0), LOG(MOVE_TO(500, 0, 0))), var_29_1, "block")
	
	local var_29_2 = arg_29_0.vars.wnd:getChildByName("n_panel")
	
	UIAction:Add(SEQ(MOVE_TO(0, 0, 300), LOG(MOVE_TO(500, 0, 0))), var_29_2, "block")
	
	local var_29_3 = arg_29_0.vars.wnd:getChildByName("n_loading")
	
	UIAction:Add(LOOP(SEQ(CALL(function()
		if_set_sprite(var_29_3, "loading_dot", "img/loading_dot1.png")
	end), DELAY(700), CALL(function()
		if_set_sprite(var_29_3, "loading_dot", "img/loading_dot2.png")
	end), DELAY(700), CALL(function()
		if_set_sprite(var_29_3, "loading_dot", "img/loading_dot3.png")
	end), DELAY(700))), var_29_3, "n_loading")
	if_set_visible(arg_29_0.vars.wnd, "n_popup_notice", false)
end

function ShopPromotion.showPopup(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_0.vars and get_cocos_refid(arg_33_0.vars.wnd) then
		return 
	end
	
	if getenv("zlong.restrict_shop", "false") == "true" then
		return 
	end
	
	if ContentDisable:byAlias("market_promotion") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	ShopPromotion.package_list = ShopPromotion.package_list or {}
	
	if arg_33_1 then
		if type(arg_33_1) == "table" then
			for iter_33_0, iter_33_1 in pairs(arg_33_1) do
				if arg_33_0:getPackageData(iter_33_1) then
					table.push(ShopPromotion.package_list, iter_33_1)
				end
			end
		else
			if not arg_33_0:getPackageData(arg_33_1) then
				return 
			end
			
			table.push(ShopPromotion.package_list, arg_33_1)
		end
	end
	
	if table.count(ShopPromotion.package_list) < 1 then
		return 
	end
	
	local var_33_0 = SceneManager:getRunningPopupScene()
	
	arg_33_0.vars = {}
	arg_33_0.vars.popup_mode = true
	arg_33_0.vars.talker_key = arg_33_2
	arg_33_0.vars.wnd = Dialog:open("wnd/lobby_popup_promotion_renew", arg_33_0)
	
	arg_33_0.vars.wnd:setVisible(false)
	var_33_0:addChild(arg_33_0.vars.wnd)
	if_set_visible(arg_33_0.vars.wnd, "n_loading", true)
	if_set_visible(arg_33_0.vars.wnd, "n_popup", false)
	arg_33_0:popupBaseUpdate()
	
	arg_33_0.vars.is_loading = true
	
	if_set_visible(arg_33_0.vars.wnd, "txt_close", false)
	
	if not Shop.ready then
		local var_33_1 = SAVE:updateConfigDataByTemp()
		local var_33_2
		
		if var_33_1 > 0 then
			var_33_2 = SAVE:getJsonConfigData()
		end
		
		waitIapInitializeComplete(function()
			query("market", {
				caller = "package_lobby",
				config_datas = var_33_2
			})
		end)
		
		return 
	else
		SAVE:sendQueryServerConfig()
		
		if not arg_33_0:popupNext(true, true) then
			return 
		end
	end
	
	Analytics:setPopup("shop_promotion_popup")
end

function ShopPromotion.isLoading(arg_35_0)
	return arg_35_0.vars and arg_35_0.vars.is_loading
end

function ShopPromotion.isPackagePopup(arg_36_0)
	return arg_36_0.vars and arg_36_0.vars.popup_mode
end

function ShopPromotion.popupNext(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	if arg_37_0.vars.is_closing then
		return 
	end
	
	local var_37_0
	
	if ShopPromotion.package_list then
		var_37_0 = ShopPromotion.package_list[1]
		
		if var_37_0 then
			table.remove(ShopPromotion.package_list, 1)
		end
	end
	
	print("ShopPromotion.popupNext", arg_37_1, arg_37_2, var_37_0)
	
	if not var_37_0 then
		ShopPromotion:close()
		
		return 
	end
	
	if arg_37_1 then
		arg_37_0:createItems()
		arg_37_0:createCategories()
		Scheduler:addSlow(arg_37_0.vars.wnd, arg_37_0.updateRemainTime, arg_37_0)
		
		if arg_37_2 then
			if_set_visible(arg_37_0.vars.wnd, "n_loading", false)
			if_set_visible(arg_37_0.vars.wnd, "n_popup", true)
			ShopPromotion:updatePopupNext(var_37_0)
		else
			local var_37_1 = arg_37_0.vars.wnd:getChildByName("n_loading")
			local var_37_2 = arg_37_0.vars.wnd:getChildByName("n_popup")
			
			UIAction:Add(SEQ(FADE_OUT(500), SHOW(false)), var_37_1, "block")
			UIAction:Add(SEQ(DELAY(500), CALL(function()
				ShopPromotion:updatePopupNext(var_37_0)
			end), FADE_IN(300)), var_37_2, "block")
		end
	else
		local var_37_3 = arg_37_0.vars.wnd:getChildByName("n_panel")
		
		UIAction:Add(SEQ(RLOG(FADE_OUT(300)), SHOW(false), CALL(function()
			ShopPromotion:updatePopupNext(var_37_0)
		end), LOG(FADE_IN(300))), var_37_3, "block")
	end
	
	arg_37_0.vars.is_loading = nil
	
	return true
end

function ShopPromotion.updatePopupNext(arg_40_0, arg_40_1)
	local var_40_0 = 1
	
	for iter_40_0, iter_40_1 in pairs(arg_40_0.vars.categories) do
		for iter_40_2 = 1, 4 do
			if not iter_40_1["package_" .. iter_40_2] then
				break
			end
			
			if iter_40_1["package_" .. iter_40_2] == arg_40_1 then
				var_40_0 = iter_40_0
				
				break
			end
		end
	end
	
	local var_40_1 = arg_40_0.vars.categories[var_40_0]
	
	if not var_40_1 then
		arg_40_0:close()
		
		return 
	end
	
	arg_40_0.vars.current_category = var_40_1
	
	ShopPromotion:updateMainPage()
	
	local var_40_2 = arg_40_0.vars.wnd.c.n_bg
	
	var_40_2:removeAllChildren()
	
	local var_40_3 = cc.Sprite:create("banner/" .. tostring(var_40_1.bg_image) .. ".png") or cc.Sprite:create("banner/package_banner.png")
	
	if var_40_3 then
		var_40_2:addChild(var_40_3)
	end
	
	if_set_visible(arg_40_0.vars.wnd, "txt_close", true)
	
	local var_40_4 = false
	
	if var_40_1.time_visible and var_40_1.items then
		local var_40_5 = -999999
		
		for iter_40_3 = 1, 4 do
			if var_40_1.items[iter_40_3] then
				var_40_5 = math.max(to_n(arg_40_0:getPackageRemainTime(var_40_1.items[iter_40_3].id)), var_40_5)
			end
		end
		
		if var_40_5 > 0 and var_40_5 <= 86400 then
			var_40_4 = true
			
			local var_40_6 = arg_40_0.vars.wnd:getChildByName("n_popup_notice")
			
			if_set(var_40_6, "t_popup_time", T("time_remain", {
				time = sec_to_full_string(var_40_5, false, {
					count = 2
				})
			}))
		end
	end
	
	if_set_visible(arg_40_0.vars.wnd, "n_popup_notice", var_40_4)
end

function ShopPromotion.close(arg_41_0)
	if not arg_41_0.vars then
		return 
	end
	
	arg_41_0.vars.is_closing = true
	
	print("ShopPromotion.close()")
	set_high_fps_tick(2000)
	UIAction:Add(FADE_OUT(300), arg_41_0.vars.wnd, "block")
	
	local var_41_0 = arg_41_0.vars.wnd:getChildByName("n_left_npc")
	
	UIAction:Add(SEQ(RLOG(MOVE_TO(300, -300, 0))), var_41_0, "block")
	
	local var_41_1 = arg_41_0.vars.wnd:getChildByName("n_panel")
	
	UIAction:Add(SEQ(RLOG(MOVE_TO(300, 0, 300))), var_41_1, "block")
	UIAction:Add(SEQ(DELAY(310), CALL(function()
		ShopPromotion:closeAfter()
	end)), var_41_1, "block")
end

function ShopPromotion.closeAfter(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	if arg_43_0.vars.check_monthly_item and SceneManager:getCurrentSceneName() == "lobby" then
		Lobby:createNotiSeq()
	end
	
	Dialog:close("lobby_popup_promotion_renew")
	
	arg_43_0.vars = nil
	
	Analytics:closePopup()
end

function ShopPromotion.open(arg_44_0, arg_44_1)
	if arg_44_1 then
		arg_44_0.open_info = {
			item_id = arg_44_1
		}
	else
		arg_44_0.open_info = nil
	end
	
	arg_44_0.item_id = arg_44_1
	
	if checkIapInitializeCompleteAndBalloonMessage() then
		query("market", {
			caller = "promotion"
		})
	end
end

function ShopPromotion._dev_package(arg_45_0, arg_45_1, arg_45_2)
	if arg_45_2 then
		arg_45_0.vars.current_category.bg_image = arg_45_2
	end
	
	arg_45_0.vars.current_category.bg_image_info = arg_45_1
	
	arg_45_0:updateMainPage()
end

function ShopPromotion._dev_package2(arg_46_0, arg_46_1)
	arg_46_0.vars.current_category.bg_image_info = (arg_46_0.vars.current_category.bg_image_info or "") .. "," .. arg_46_1
	
	arg_46_0:updateMainPage()
end

function ShopPromotion.updatePackageItems(arg_47_0, arg_47_1, arg_47_2)
	arg_47_2 = arg_47_2 or {}
	
	local var_47_0 = arg_47_2.current_category or arg_47_0.vars.current_category
	local var_47_1 = arg_47_2.is_chain_package
	
	for iter_47_0 = 1, 4 do
		UIAction:Remove("ap_ballon_" .. iter_47_0)
	end
	
	local var_47_2 = #var_47_0.items
	local var_47_3 = 0
	
	for iter_47_1 = 1, 4 do
		if var_47_0.items[iter_47_1] then
			if var_47_2 == 3 then
				var_47_2 = 4
			end
			
			local var_47_4 = arg_47_1.c["n_item_node_" .. var_47_2].c["n_item" .. iter_47_1 .. "/" .. var_47_2]
			
			if (arg_47_0:selectItem(var_47_4, var_47_0.items[iter_47_1], var_47_0) or {}).lock_chain then
				var_47_3 = var_47_3 + 1
			end
		end
	end
	
	if var_47_3 > 0 then
		local var_47_5 = arg_47_1:getChildByName("n_base")
		
		if get_cocos_refid(var_47_5) then
			var_47_5:setColor(tocolor("#888888"))
		end
		
		if var_47_2 == 1 then
			local var_47_6 = arg_47_1:getChildByName("icon_lock2")
			
			if get_cocos_refid(var_47_6) then
				var_47_6:setVisible(true)
			end
		elseif var_47_2 == 2 then
			local var_47_7 = arg_47_1:getChildByName("icon_lock" .. i)
			
			if get_cocos_refid(var_47_7) then
				var_47_7:setVisible(true)
			end
		end
	end
	
	if var_47_1 then
		local var_47_8 = arg_47_1:getChildByName("n_base")
		local var_47_9
		
		if var_47_0.items[1] and var_47_0.items[1].shop_package_data then
			var_47_9 = var_47_0.items[1] and var_47_0.items[1].shop_package_data.chain_info_text
		end
		
		if var_47_2 == 1 then
			if_set_visible(var_47_8, "n_1_info", true)
			
			if var_47_9 then
				if_set(var_47_8:getChildByName("n_1_info"), "txt_info", T(var_47_9))
			end
			
			if_set_visible(var_47_8, "n_2_info", false)
		elseif var_47_2 == 2 then
			if_set_visible(var_47_8, "n_1_info", false)
			if_set_visible(var_47_8, "n_2_info", true)
			
			if var_47_9 then
				if_set(var_47_8:getChildByName("n_2_info"), "txt_info", T(var_47_9))
			end
		else
			if_set_visible(var_47_8, "n_1_info", false)
			if_set_visible(var_47_8, "n_2_info", false)
		end
	end
	
	local var_47_10 = arg_47_1:getChildByName("n_extra_node")
	
	if get_cocos_refid(var_47_10) then
		var_47_10:removeAllChildren()
	end
	
	local var_47_11 = arg_47_1:getChildByName("n_item_node_1")
	
	if var_47_2 == 1 and get_cocos_refid(var_47_11) then
		var_47_11:setPositionX(0)
	end
	
	if_set_visible(arg_47_1, "n_item_node_1", var_47_2 == 1)
	if_set_visible(arg_47_1, "n_item_node_2", var_47_2 == 2)
	if_set_visible(arg_47_1, "n_item_node_4", var_47_2 == 3 or var_47_2 == 4)
	
	if var_47_2 == 3 then
		if_set_visible(arg_47_1, "n_item4/4", false)
	end
	
	local var_47_12 = arg_47_1:getChildByName("n_bg")
	
	if get_cocos_refid(var_47_12) then
		var_47_12:removeAllChildren()
	end
	
	local var_47_13
	local var_47_14
	local var_47_15 = arg_47_1:getChildByName("n_pk_character")
	
	if get_cocos_refid(var_47_15) then
		var_47_14 = var_47_15:getChildByName("n_portrait")
		
		if get_cocos_refid(var_47_14) then
			for iter_47_2 = 1, 3 do
				var_47_14:getChildByName("n_char" .. iter_47_2):removeAllChildren()
			end
		end
		
		var_47_13 = var_47_15:getChildByName("n_pk_item")
		
		var_47_13:removeAllChildren()
	end
	
	local var_47_16 = cc.Sprite:create("banner/" .. tostring(var_47_0.bg_image) .. ".png") or cc.Sprite:create("banner/package_banner.png")
	
	if var_47_16 then
		var_47_12:addChild(var_47_16)
	end
	
	local var_47_17 = {
		glow_opa = 100,
		p3_x = 0,
		p2_y = -580,
		p2_flip_x = 1,
		p1_x = 0,
		p1_skin = "normal",
		p3_scale = 1,
		p2_scale = 1,
		glow_y = 1,
		p1_scale = 1,
		p3_skin = "normal",
		p2_x = 0,
		p3_flip_x = 1,
		p1_y = -580,
		p3_y = -580,
		p2_skin = "normal",
		p1_flip_x = 1
	}
	
	if get_cocos_refid(var_47_15) then
		if var_47_0.bg_image_info then
			var_47_15:setVisible(true)
			
			for iter_47_3, iter_47_4 in pairs(string.split(var_47_0.bg_image_info, ",")) do
				local var_47_18 = string.split(string.trim(iter_47_4), "=")
				
				if var_47_18[2] then
					var_47_17[var_47_18[1]] = var_47_18[2]
				end
			end
			
			if not PRODUCTION_MODE then
				table.print(var_47_17)
			end
			
			local var_47_19 = var_47_15:getChildByName("grow_s_white")
			
			if get_cocos_refid(var_47_19) then
				var_47_19:setScaleY(to_n(var_47_17.glow_y))
				var_47_19:setOpacity(math.min(to_n(var_47_17.glow_opa) * 2.55, 255))
				
				if var_47_17.glow_tint then
					var_47_19:setColor(tocolor(var_47_17.glow_tint))
				else
					var_47_19:setColor(tocolor("#000000"))
				end
			end
			
			if get_cocos_refid(var_47_14) then
				for iter_47_5 = 1, 3 do
					local var_47_20 = "p" .. iter_47_5
					
					if var_47_17[var_47_20 .. "_code"] then
						local var_47_21 = var_47_14:getChildByName("n_char" .. iter_47_5)
						local var_47_22 = UIUtil:getPortraitAni(DB("character", var_47_17[var_47_20 .. "_code"], "face_id"))
						
						if var_47_22 then
							var_47_22:setSkin(var_47_17[var_47_20 .. "_skin"])
							var_47_22:setPosition(to_n(var_47_17[var_47_20 .. "_x"]), to_n(var_47_17[var_47_20 .. "_y"]))
							var_47_22:setScale(to_n(var_47_17[var_47_20 .. "_scale"]))
							var_47_22:setScaleX(to_n(var_47_17[var_47_20 .. "_scale"]) * to_n(var_47_17[var_47_20 .. "_flip_x"]))
							var_47_21:addChild(var_47_22)
						end
					end
				end
			end
			
			if var_47_17.pk_item then
				local var_47_23 = cc.Sprite:create("banner/" .. tostring(var_47_17.pk_item) .. ".png")
				
				if var_47_23 then
					var_47_23:setAnchorPoint(0, 0)
					var_47_13:addChild(var_47_23)
				end
			end
		else
			var_47_15:setVisible(false)
		end
	end
	
	return var_47_17
end

function ShopPromotion.updateMainPage(arg_48_0, arg_48_1)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) then
		return 
	end
	
	arg_48_1 = arg_48_1 or {}
	
	local var_48_0 = arg_48_0.vars.wnd:getChildByName("n_shop_btn")
	
	if get_cocos_refid(var_48_0) then
		var_48_0:removeAllChildren()
	end
	
	local var_48_1 = arg_48_0.vars.wnd:getChildByName("n_shop_scroll")
	
	if get_cocos_refid(var_48_1) then
		var_48_1:removeAllChildren()
	end
	
	if arg_48_0.vars.current_category.csd_condition == "chain" then
		arg_48_0:mainCustomizeChainPackage()
		
		return 
	end
	
	local var_48_2 = load_control("wnd/shop_promotion_button.csb")
	
	if_set_visible(var_48_0, nil, true)
	if_set_visible(arg_48_0.vars.wnd, "n_shop_scroll", false)
	var_48_0:addChild(var_48_2)
	
	local var_48_3 = arg_48_0:updatePackageItems(var_48_2, arg_48_1)
	
	if arg_48_0.vars.current_category.items and arg_48_0.vars.current_category.items[1] and arg_48_0.vars.current_category.items[1].type == "gacha_start" then
		arg_48_0:mainCustomizeStartGacha()
	elseif arg_48_0.vars.current_category.items and arg_48_0.vars.current_category.items[1] and (string.starts(arg_48_0.vars.current_category.items[1].type, "gacha_story") or arg_48_0.vars.current_category.items[1].type == "gacha_spdash") then
		arg_48_0:mainCustomizeStoryGacha(arg_48_1)
	elseif arg_48_0.vars.current_category.csd_condition == "pass" then
		arg_48_0:mainCustomizeRankup(var_48_3)
	elseif arg_48_0.vars.current_category.csd_condition == "custom_mora" then
		arg_48_0:mainCustomizeCustomMora(var_48_3)
	elseif arg_48_0.vars.current_category.csd_condition == "hero_select" then
		arg_48_0:mainCustomizeCustomHeroSelect(var_48_3, arg_48_0.vars.current_category.csd_condition)
	elseif arg_48_0.vars.current_category.csd_condition == "artifact_select" then
		arg_48_0:mainCustomizeCustomHeroSelect(var_48_3, arg_48_0.vars.current_category.csd_condition)
	elseif arg_48_0.vars.current_category.csd_condition == "lobby_pack" then
		arg_48_0:mainCustomizeCustomLobbyPack(var_48_3, arg_48_0.vars.current_category.csd_condition)
	elseif string.starts(arg_48_0.vars.current_category.csd_condition, "custom_select_") then
		arg_48_0:mainCustomizeCustomPackage(var_48_3, arg_48_0.vars.current_category.csd_condition)
	end
end

function HANDLER_BEFORE.shop_promotion_custom_slot(arg_49_0, arg_49_1, arg_49_2)
	if arg_49_1 == "btn_select_base" then
		arg_49_0.touch_tick = systick()
	end
end

function HANDLER.shop_promotion_custom_slot(arg_50_0, arg_50_1)
	if arg_50_1 == "btn_select_base" and systick() - to_n(arg_50_0.touch_tick) < 180 then
		ShopPromotion:popupCustomizeCustomPackage()
	end
end

function HANDLER_BEFORE.shop_promotion_custom_choose(arg_51_0, arg_51_1, arg_51_2)
	if string.starts(arg_51_1, "btn_select_item:") then
		arg_51_0.touch_tick = systick()
	end
end

function HANDLER.shop_promotion_custom_choose(arg_52_0, arg_52_1)
	if arg_52_1 == "btn_cancel" or arg_52_1 == "btn_close" then
		ShopPromotion:closePopupCustomizeCustomPackage()
	elseif arg_52_1 == "btn_yes" then
		ShopPromotion:acceptPopupCustomizeCustomPackageItems()
	elseif string.starts(arg_52_1, "btn_select_item:") and systick() - to_n(arg_52_0.touch_tick) < 180 then
		ShopPromotion:selectPopupCustomizeCustomPackageItem(arg_52_1)
	end
end

function ShopPromotion.getCustomSelectPackageID(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0:getPackageData(arg_53_1)
	
	if not var_53_0 or not var_53_0.shop_package_data then
		return 
	end
	
	return var_53_0.shop_package_data.custombox_id
end

function ShopPromotion.closePopupCustomizeCustomPackage(arg_54_0)
	Dialog:close("shop_promotion_custom_choose")
end

function ShopPromotion.acceptPopupCustomizeCustomPackageItems(arg_55_0, arg_55_1)
	if not arg_55_0.vars or not arg_55_0.vars.custom_package_slots then
		return 
	end
	
	local var_55_0 = {}
	local var_55_1 = 0
	
	for iter_55_0, iter_55_1 in pairs(arg_55_0.vars.custom_package_slots) do
		if iter_55_1.item and iter_55_1.item.id then
			var_55_0[iter_55_0] = iter_55_1.item.id
			var_55_1 = var_55_1 + 1
		end
	end
	
	if arg_55_1 then
		return accept_count > 0
	end
	
	if var_55_1 > 0 then
		arg_55_0:closePopupCustomizeCustomPackage()
		
		local var_55_2 = arg_55_0.vars.current_category.items[1].id
		local var_55_3 = Account:getUserConfigs("cp:" .. var_55_2)
		local var_55_4 = json.encode(var_55_0)
		
		if var_55_3 ~= var_55_4 then
			query("select_custom_package_item_select", {
				package_id = var_55_2,
				accept_items = var_55_4
			})
			arg_55_0:updateSelectedCustomizeCustomPackageItems(var_55_2, nil, var_55_0)
		end
	else
		balloon_message_with_sound("err_package_selection_required_itemslot_2")
	end
end

function ShopPromotion.updateSelectedCustomizeCustomPackageItems(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	if not arg_56_0.vars or not arg_56_0.vars.current_category then
		return 
	end
	
	if not get_cocos_refid(arg_56_0.vars.custom_package_cont) then
		return 
	end
	
	local var_56_0 = arg_56_0.vars.current_category.items[1]
	
	if var_56_0.id ~= arg_56_1 or not var_56_0.custom_items then
		return 
	end
	
	arg_56_3 = arg_56_3 or json.decode(Account:getUserConfigs("cp:" .. arg_56_1) or "{}")
	
	local var_56_1 = arg_56_0.vars.custom_package_no
	local var_56_2 = arg_56_2 or arg_56_0.vars.custom_package_cont:getChildByName("n_" .. var_56_1)
	local var_56_3 = 0
	local var_56_4 = {}
	
	for iter_56_0, iter_56_1 in pairs(arg_56_3) do
		var_56_3 = var_56_3 + 1
		
		for iter_56_2, iter_56_3 in pairs(var_56_0.custom_items[iter_56_0] or {}) do
			if iter_56_1 == iter_56_3.id then
				table.push(var_56_4, iter_56_3)
				
				local var_56_5
				
				if var_56_1 == 1 then
					var_56_5 = var_56_2:getChildByName("n_item")
				else
					var_56_5 = var_56_2:getChildByName("n_" .. var_56_3 .. "/4"):getChildByName("n_item")
				end
				
				var_56_5:removeAllChildren()
				
				local var_56_6 = load_control("wnd/shop_promotion_custom_item.csb")
				
				var_56_6:setAnchorPoint(0.5, 0.5)
				if_set_visible(var_56_6, "btn_select", false)
				arg_56_0:setPopupCustomizeCustomPackageIcon(var_56_6, iter_56_3)
				var_56_5:addChild(var_56_6)
			end
		end
	end
	
	return var_56_4
end

function ShopPromotion.selectPopupCustomizeCustomPackageItem(arg_57_0, arg_57_1)
	if not arg_57_0.vars or not arg_57_0.vars.custom_package_slots or not arg_57_0.vars.custom_package_select_slot then
		return 
	end
	
	local var_57_0 = arg_57_0.vars.current_category.items[1]
	
	if not var_57_0 or not var_57_0.shop_package_data or not var_57_0.shop_package_data.custombox_id or not var_57_0.custom_items then
		return 
	end
	
	local var_57_1 = arg_57_0.vars.custom_package_select_slot
	
	if not var_57_0.custom_items[var_57_1] then
		return 
	end
	
	local var_57_2 = arg_57_0.vars.custom_package_no
	local var_57_3 = string.split(arg_57_1, ":")[2]
	
	if arg_57_0.vars.custom_package_slots[arg_57_0.vars.custom_package_select_slot] then
		for iter_57_0, iter_57_1 in pairs(var_57_0.custom_items[var_57_1]) do
			if iter_57_1.id == var_57_3 then
				if_set_opacity(arg_57_0.vars.wnd_popup_custom_choose, "btn_yes", 255)
				
				arg_57_0.vars.custom_package_slots[arg_57_0.vars.custom_package_select_slot].item = iter_57_1
				
				local var_57_4 = arg_57_0.vars.custom_package_slots[arg_57_0.vars.custom_package_select_slot].slot
				
				if get_cocos_refid(var_57_4) then
					local var_57_5 = var_57_4:getChildByName("n_item")
					
					var_57_5:removeAllChildren()
					
					local var_57_6 = load_control("wnd/shop_promotion_custom_item.csb")
					
					var_57_6:setAnchorPoint(0.5, 0.5)
					if_set_visible(var_57_6, "btn_select", false)
					arg_57_0:setPopupCustomizeCustomPackageIcon(var_57_6, iter_57_1)
					var_57_5:addChild(var_57_6)
					arg_57_0:selectPopupCustomizeCustomPackage(var_57_1)
				end
			end
		end
	end
end

function ShopPromotion.popupCustomizeCustomPackage(arg_58_0)
	if not arg_58_0.vars or not arg_58_0.vars.custom_package_no then
		return 
	end
	
	local var_58_0 = arg_58_0.vars.current_category.items[1].id
	local var_58_1, var_58_2, var_58_3 = arg_58_0:getPackageRestCountByPackageId(var_58_0)
	
	if var_58_1 < 1 then
		return 
	end
	
	local var_58_4 = Dialog:open("wnd/shop_promotion_custom_choose", arg_58_0)
	local var_58_5 = arg_58_0.vars.custom_package_no
	local var_58_6 = arg_58_0.vars.current_category.items[1]
	
	if not var_58_6 or not var_58_6.custom_items or not var_58_6.shop_package_data or not var_58_6.shop_package_data.custombox_id then
		return 
	end
	
	for iter_58_0 = 1, 4 do
		if_set_visible(var_58_4, "n_" .. iter_58_0, var_58_5 == iter_58_0)
	end
	
	arg_58_0.vars.custom_package_slots = {}
	
	local var_58_7 = string.split(var_58_6.shop_package_data.custombox_id, ";")
	local var_58_8 = var_58_4:getChildByName("n_" .. var_58_5)
	
	if var_58_5 == 1 then
		local var_58_9 = load_control("wnd/shop_promotion_custom_slot.csb")
		
		if_set_visible(var_58_9, "n_select", true)
		if_set_visible(var_58_9, "n_slot_pick", true)
		if_set_visible(var_58_9, "n_slot_fix", false)
		if_set_visible(var_58_9, "n_item", true)
		if_set_visible(var_58_9, "btn_select", false)
		
		arg_58_0.vars.custom_package_slots[var_58_7[1]] = {}
		arg_58_0.vars.custom_package_slots[var_58_7[1]].slot = var_58_9
		arg_58_0.vars.custom_package_slots[var_58_7[1]].item = nil
		
		var_58_9:setAnchorPoint(0.5, 0.5)
		var_58_8:addChild(var_58_9)
		
		local var_58_10 = arg_58_0:updateSelectedCustomizeCustomPackageItems(var_58_0, var_58_8)
		
		if #var_58_10 > 0 then
			arg_58_0.vars.custom_package_slots[var_58_7[1]].item = var_58_10[1]
			
			if_set_opacity(var_58_4, "btn_yes", 255)
		else
			if_set_opacity(var_58_4, "btn_yes", 76.5)
		end
	else
		for iter_58_1 = 1, var_58_5 do
			local var_58_11 = load_control("wnd/shop_promotion_custom_slot.csb")
			local var_58_12 = var_58_8:getChildByName("n_" .. iter_58_1 .. "/4")
			
			if_set_visible(var_58_11, "n_select", iter_58_1 == 1)
			if_set_visible(var_58_11, "n_slot_pick", true)
			if_set_visible(var_58_11, "n_slot_fix", false)
			if_set_visible(var_58_11, "n_item", true)
			if_set_visible(var_58_11, "btn_select", true)
			var_58_11:getChildByName("btn_select"):setName("btn_select_" .. iter_58_1)
			var_58_11:setAnchorPoint(0.5, 0.5)
			var_58_12:addChild(var_58_11)
		end
	end
	
	local var_58_13 = var_58_4:getChildByName("n_listview")
	local var_58_14 = ItemListView_v2:bindControl(var_58_13)
	local var_58_15 = load_control("wnd/shop_promotion_custom_item.csb")
	
	if var_58_14.STRETCH_INFO then
		local var_58_16 = var_58_14:getContentSize()
		
		resetControlPosAndSize(var_58_15, var_58_16.width, var_58_14.STRETCH_INFO.width_prev)
	end
	
	local var_58_17 = {
		onUpdate = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
			arg_58_0:setPopupCustomizeCustomPackageIcon(arg_59_1, arg_59_3)
			arg_59_1:getChildByName("btn_select"):setName("btn_select_item:" .. arg_59_3.id)
			
			if arg_58_0.vars.custom_package_select_slot and arg_58_0.vars.custom_package_slots[arg_58_0.vars.custom_package_select_slot].item and arg_58_0.vars.custom_package_slots[arg_58_0.vars.custom_package_select_slot].item.id == arg_59_3.id then
				if_set_visible(arg_59_1, "n_select", true)
			else
				if_set_visible(arg_59_1, "n_select", false)
			end
		end
	}
	
	var_58_14:setRenderer(var_58_15, var_58_17)
	var_58_14:removeAllChildren()
	
	arg_58_0.vars.wnd_popup_custom_choose = var_58_4
	
	SceneManager:getRunningPopupScene():addChild(arg_58_0.vars.wnd_popup_custom_choose)
	arg_58_0:selectPopupCustomizeCustomPackage(var_58_7[1])
end

function ShopPromotion.setPopupCustomizeCustomPackageIcon(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_1 or not arg_60_2 then
		return 
	end
	
	local var_60_0 = arg_60_1:getChildByName("n_reward")
	
	if_set(var_60_0, "txt_count", arg_60_2.value)
	
	local var_60_1 = arg_60_2.data or {}
	
	if string.starts(arg_60_2.item_id, "c") or string.starts(arg_60_2.item_id, "m") then
		local var_60_2, var_60_3 = DB("character", arg_60_2.item_id, {
			"name",
			"grade"
		})
		local var_60_4 = UIUtil:getRewardIcon("c", arg_60_2.item_id, {
			tooltip_delay = 130,
			grade = var_60_3
		})
		
		var_60_4:setAnchorPoint(0.5, 0.5)
		
		local var_60_5 = var_60_0:getChildByName("n_mob")
		
		var_60_5:setVisible(true)
		var_60_5:addChild(var_60_4)
	elseif DB("pet_character", arg_60_2.item_id, "id") then
		local var_60_6 = UIUtil:getRewardIcon(nil, arg_60_2.item_id, {
			tooltip_delay = 130,
			grade = var_60_1.g
		})
		
		var_60_6:setAnchorPoint(0.5, 0.5)
		
		local var_60_7 = var_60_0:getChildByName("n_pet_icon")
		
		var_60_7:setVisible(true)
		var_60_7:addChild(var_60_6)
	else
		local var_60_8 = UIUtil:getRewardIcon(nil, arg_60_2.item_id, {
			tooltip_delay = 130,
			equip_stat = var_60_1.op,
			grade = var_60_1.g,
			set_fx = var_60_1.f
		})
		
		var_60_8:setAnchorPoint(0.5, 0.5)
		
		local var_60_9
		local var_60_10 = DB("equip_item", arg_60_2.item_id, "type")
		
		if var_60_10 and var_60_10 == "artifact" then
			var_60_9 = var_60_0:getChildByName("n_arti")
		else
			var_60_9 = var_60_0:getChildByName("n_item")
		end
		
		var_60_9:setVisible(true)
		var_60_9:addChild(var_60_8)
	end
end

function ShopPromotion.selectPopupCustomizeCustomPackage(arg_61_0, arg_61_1)
	if not arg_61_0.vars or not arg_61_0.vars.wnd_popup_custom_choose then
		return 
	end
	
	arg_61_0.vars.custom_package_select_slot = arg_61_1
	
	local var_61_0 = arg_61_0.vars.wnd_popup_custom_choose:getChildByName("n_listview")
	
	if not get_cocos_refid(var_61_0) then
		return 
	end
	
	var_61_0:setDataSource({})
	
	local var_61_1 = arg_61_0.vars.current_category.items[1]
	
	if not var_61_1 or not var_61_1.shop_package_data or not var_61_1.shop_package_data.custombox_id or not var_61_1.custom_items then
		return 
	end
	
	if not var_61_1.custom_items[arg_61_1] then
		return 
	end
	
	var_61_0:setDataSource(var_61_1.custom_items[arg_61_1])
end

function ShopPromotion.mainCustomizeCustomPackage(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = load_control("wnd/shop_promotion_custom.csb")
	local var_62_1 = arg_62_0.vars.current_category.items[1].id
	local var_62_2 = to_n(string.split(arg_62_2, "custom_select_")[2])
	
	for iter_62_0 = 1, 4 do
		if_set_visible(var_62_0, "n_" .. iter_62_0, var_62_2 == iter_62_0)
	end
	
	arg_62_0.vars.custom_package_no = var_62_2
	arg_62_0.vars.custom_package_select_slot = nil
	arg_62_0.vars.custom_package_cont = var_62_0
	
	local var_62_3 = var_62_0:getChildByName("n_" .. var_62_2)
	
	if var_62_2 == 1 then
		local var_62_4 = load_control("wnd/shop_promotion_custom_slot.csb")
		
		if_set_visible(var_62_4, "n_select", false)
		if_set_visible(var_62_4, "n_slot_pick", true)
		if_set_visible(var_62_4, "n_slot_fix", false)
		if_set_visible(var_62_4, "n_item", true)
		if_set_visible(var_62_4, "btn_select", true)
		var_62_4:getChildByName("btn_select"):setName("btn_select_base")
		var_62_4:setAnchorPoint(0.5, 0.5)
		var_62_3:addChild(var_62_4)
	else
		for iter_62_1 = 1, var_62_2 do
			local var_62_5 = load_control("wnd/shop_promotion_custom_slot.csb")
			local var_62_6 = var_62_3:getChildByName("n_" .. iter_62_1 .. "/4")
			
			if_set_visible(var_62_5, "n_select", false)
			if_set_visible(var_62_5, "n_slot_pick", true)
			if_set_visible(var_62_5, "n_slot_fix", false)
			if_set_visible(var_62_5, "n_item", true)
			if_set_visible(var_62_5, "btn_select", true)
			var_62_5:getChildByName("btn_select"):setName("btn_select_base")
			var_62_5:setAnchorPoint(0.5, 0.5)
			var_62_6:addChild(var_62_5)
		end
	end
	
	arg_62_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_62_0)
	arg_62_0:updateSelectedCustomizeCustomPackageItems(var_62_1)
end

function ShopPromotion.canReceiveCustomPackageRewardsByPackage(arg_63_0, arg_63_1)
	if not AccountData or not AccountData.ticketed_limits or not AccountData.shop_package_custom_rewards then
		return false
	end
	
	local var_63_0 = AccountData.ticketed_limits["cp:" .. arg_63_1]
	
	if not var_63_0 then
		return false
	end
	
	local var_63_1 = AccountData.shop_package_custom_rewards[arg_63_1]
	
	if not var_63_1 then
		return false
	end
	
	if to_n(var_63_0.score1) > to_n(var_63_0.score3) then
		for iter_63_0, iter_63_1 in pairs(var_63_1) do
			local var_63_2 = to_n(iter_63_1.reward_score1)
			
			if var_63_2 > to_n(var_63_0.score3) and var_63_2 <= to_n(var_63_0.score1) then
				return true
			end
		end
	end
	
	return false
end

function ShopPromotion.canReceiveCustomPackageRewards(arg_64_0, arg_64_1)
	if arg_64_0:canReceiveRankupPackageRewards(arg_64_1) then
		return true
	end
	
	if arg_64_1 then
		return arg_64_0:canReceiveCustomPackageRewardsByPackage(arg_64_1)
	else
		for iter_64_0, iter_64_1 in pairs(AccountData.shop_package_custom_rewards or {}) do
			if arg_64_0:canReceiveCustomPackageRewardsByPackage(iter_64_0) then
				return true
			end
		end
	end
	
	return false
end

function MsgHandler.test_mora_pkg_clear(arg_65_0)
	if arg_65_0.limits then
		Account:updateLimits(arg_65_0.limits)
	end
	
	if arg_65_0.ticketed_limits then
		AccountData.ticketed_limits = arg_65_0.ticketed_limits
	end
	
	SceneManager:nextScene("lobby")
end

function ShopPromotion.mainCustomizeChainPackage(arg_66_0)
	local var_66_0 = load_control("wnd/shop_promotion_scroll.csb")
	local var_66_1 = arg_66_0.vars.wnd:getChildByName("n_shop_scroll")
	
	if_set_visible(var_66_1, nil, true)
	if_set_visible(arg_66_0.vars.wnd, "n_shop_btn", false)
	var_66_1:addChild(var_66_0)
	
	arg_66_0.vars.scrollview_chain = var_66_0:getChildByName("scroll_prom")
	
	arg_66_0.vars.scrollview_chain:removeAllChildren()
	
	local var_66_2 = arg_66_0.vars.current_category.items[1].id
	local var_66_3 = arg_66_0.vars.chain_packages[var_66_2]
	
	if not var_66_3 then
		return 
	end
	
	local var_66_4 = 486
	local var_66_5 = var_66_4 * #var_66_3
	
	arg_66_0.vars.scrollview_chain:setInnerContainerSize({
		width = 732,
		height = var_66_5
	})
	
	for iter_66_0, iter_66_1 in pairs(var_66_3) do
		local var_66_6 = load_control("wnd/shop_promotion_scroll_card.csb")
		local var_66_7 = arg_66_0:updatePackageItems(var_66_6, {
			is_chain_package = true,
			current_category = iter_66_1
		})
		
		var_66_6:setPosition(0, var_66_5 - var_66_4 * iter_66_0)
		arg_66_0.vars.scrollview_chain:addChild(var_66_6)
	end
end

function ShopPromotion.previewLobbyThemeUpdate(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_0.vars.current_category.items[1]
	
	if var_67_0 == nil or var_67_0.shop_package_data == nil then
		return 
	end
	
	local var_67_1 = var_67_0.shop_package_data
	local var_67_2 = arg_67_1:getChildByName("scroll_view")
	local var_67_3
	
	if arg_67_2 then
		var_67_3 = var_67_1.lobby_theme_hero
	else
		var_67_3 = var_67_1.lobby_theme_bg
	end
	
	local var_67_4 = SpriteCache:getSprite("item/art/" .. var_67_3 .. ".png")
	
	var_67_4:setAnchorPoint(0, 0)
	
	local var_67_5 = var_67_2:getInnerContainerSize()
	local var_67_6 = var_67_2:getContentSize()
	local var_67_7 = var_67_4:getContentSize()
	
	if_set_visible(arg_67_1, "n_info", var_67_7.width > var_67_6.width)
	var_67_2:removeAllChildren()
	var_67_2:addChild(var_67_4)
	var_67_2:setInnerContainerSize({
		width = var_67_7.width,
		height = var_67_5.height
	})
	var_67_2:jumpToPercentHorizontal(50)
end

function ShopPromotion.previewLobbyTheme(arg_68_0)
	local var_68_0 = arg_68_0.vars.current_category.items[1]
	
	if var_68_0 == nil or var_68_0.shop_package_data == nil then
		return 
	end
	
	local var_68_1 = var_68_0.shop_package_data
	local var_68_2 = load_dlg("lobby_thema_preview", true, "wnd")
	local var_68_3 = false
	
	if not var_68_1.lobby_theme_hero then
		if_set_visible(var_68_2, "n_checkbox", false)
	else
		var_68_3 = var_68_2:getChildByName("check_box"):isSelected()
	end
	
	arg_68_0:previewLobbyThemeUpdate(var_68_2, var_68_3)
	Dialog:msgBox("", {
		dlg = var_68_2,
		handler = function(arg_69_0, arg_69_1, arg_69_2)
			if arg_69_1 == "btn_close" or arg_69_1 == "btn_default" then
			elseif arg_69_1 == "check_box" then
				local var_69_0 = var_68_2:getChildByName("check_box")
				
				arg_68_0:previewLobbyThemeUpdate(var_68_2, var_69_0:isSelected())
				
				return "dont_close"
			elseif arg_69_1 == "n_checkbox" then
				local var_69_1 = var_68_2:getChildByName("check_box")
				
				var_69_1:setSelected(not var_69_1:isSelected())
				arg_68_0:previewLobbyThemeUpdate(var_68_2, var_69_1:isSelected())
				
				return "dont_close"
			else
				return "dont_close"
			end
		end
	})
end

function ShopPromotion.mainCustomizeCustomLobbyPack(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = load_control("wnd/shop_promotion_hero_sel.csb")
	
	var_70_0:setName("shop_promotion_lobby_pack")
	
	local var_70_1 = arg_70_0.vars.current_category.items[1]
	
	if var_70_1 == nil or var_70_1.shop_package_data == nil then
		return 
	end
	
	local var_70_2 = var_70_1.shop_package_data
	local var_70_3 = var_70_0:getChildByName("n_hero_pack"):getChildByName("n_select")
	
	if_set_visible(var_70_3, "item_art_icon", false)
	if_set_visible(var_70_3, "mob_icon", false)
	if_set_visible(var_70_3, "shop_icon", false)
	if_set_visible(var_70_3, "btn_hero_sel", false)
	if_set_visible(var_70_3, "no_data", false)
	if_set_visible(var_70_3, "balloon", false)
	
	local var_70_4 = arg_70_0.vars.current_category.items[1].id
	
	if arg_70_0:getPackageRemainTime(var_70_4) then
		var_70_3:setPositionY(20)
	end
	
	local var_70_5 = var_70_3:getChildByName("btn_get_reward")
	
	if_set_sprite(var_70_5, "cm_icon_etcdown", "img/icon_menu_illust.png")
	if_set(var_70_5, "t_get_reward", T("ui_select_lobbypack_title"))
	arg_70_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_70_0)
end

function ShopPromotion.mainCustomizeCustomHeroSelect(arg_71_0, arg_71_1, arg_71_2)
	local var_71_0 = load_control("wnd/shop_promotion_hero_sel.csb")
	local var_71_1 = var_71_0:getChildByName("n_hero_pack")
	local var_71_2 = arg_71_0.vars.current_category.items[1].id
	local var_71_3 = var_71_1:getChildByName("n_select")
	
	if_set_visible(var_71_3, "no_data", true)
	if_set_visible(var_71_3, "mob_icon", false)
	if_set_visible(var_71_3, "item_art_icon", false)
	
	local var_71_4 = var_71_3:getChildByName("no_data")
	
	if arg_71_2 == "artifact_select" then
		if_set_visible(var_71_4, "n_hero", false)
		if_set_visible(var_71_4, "n_arti", true)
		if_set_sprite(var_71_3, "shop_icon", "shop/sp_artiselect_3.png")
		
		local var_71_5 = var_71_3:getChildByName("btn_get_reward")
		
		if_set_sprite(var_71_5, "cm_icon_etcdown", "img/icon_menu_artisel.png")
		if_set(var_71_5, "t_get_reward", T("ui_selection_package_artifact_select"))
	else
		if_set_visible(var_71_4, "n_hero", true)
		if_set_visible(var_71_4, "n_arti", false)
		if_set_sprite(var_71_3, "shop_icon", "shop/sp_herombox_3_b.png")
		
		local var_71_6 = var_71_3:getChildByName("btn_get_reward")
		
		if_set_sprite(var_71_6, "cm_icon_etcdown", "img/icon_menu_heroselect.png")
		if_set(var_71_6, "t_get_reward", T("ui_selection_package_hero_select"))
	end
	
	if arg_71_0:getPackageRemainTime(var_71_2) then
		var_71_3:setPositionY(20)
	end
	
	arg_71_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_71_0)
	arg_71_0:updateCustomizedHeroSelect()
end

function ShopPromotion.getPackageHeroSelectID(arg_72_0, arg_72_1)
	local var_72_0 = arg_72_0:getPackageData(arg_72_1)
	
	if not var_72_0 or not var_72_0.shop_package_data then
		return 
	end
	
	return var_72_0.shop_package_data.select_id
end

function ShopPromotion.viewCustomizedHeroSelect(arg_73_0)
	local var_73_0 = arg_73_0.vars.current_category.items[1].id
	local var_73_1 = arg_73_0:getPackageHeroSelectID(var_73_0)
	
	if not var_73_1 then
		return 
	end
	
	local var_73_2, var_73_3, var_73_4 = arg_73_0:getPackageRestCountByPackageId(var_73_0)
	
	if var_73_2 < 1 then
		return 
	end
	
	query("select_pool_list", {
		caller = "package_hero_select",
		ui_select_text_id = "ui_package_hero_select",
		item = var_73_1
	})
end

function ShopPromotion.updateCustomizedHeroSelect(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0.vars.wnd:getChildByName("n_extra_node")
	
	if not get_cocos_refid(var_74_0) then
		return 
	end
	
	local var_74_1 = var_74_0:getChildByName("n_hero_pack"):getChildByName("n_select")
	local var_74_2 = arg_74_0.vars.current_category.items[1].id
	local var_74_3 = arg_74_1 or Account:getUserConfigs("hs:" .. var_74_2)
	
	if var_74_3 then
		if DB("character", var_74_3, "id") then
			if_set_visible(var_74_1, "no_data", false)
			if_set_visible(var_74_1, "mob_icon", true)
			if_set_visible(var_74_1, "item_art_icon", false)
			UIUtil:getRewardIcon("c", var_74_3, {
				no_popup = true,
				name = false,
				show_color = true,
				role = true,
				scale = 1,
				parent = var_74_1:getChildByName("mob_icon")
			})
		else
			if_set_visible(var_74_1, "no_data", false)
			if_set_visible(var_74_1, "mob_icon", false)
			if_set_visible(var_74_1, "item_art_icon", true)
			UIUtil:getRewardIcon("c", var_74_3, {
				no_popup = true,
				name = false,
				show_color = true,
				role = true,
				scale = 1,
				parent = var_74_1:getChildByName("item_art_icon")
			})
		end
	end
end

function ShopPromotion.selectCustomizedHeroSelect(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_0.vars.current_category.items[1].id
	
	arg_75_0:updateCustomizedHeroSelect(arg_75_1)
	query("select_custom_package_hero_select", {
		package_id = var_75_0,
		code = arg_75_1
	})
end

function ShopPromotion.mainCustomizeCustomMora(arg_76_0, arg_76_1)
	local var_76_0 = load_control("wnd/shop_promotion_mura.csb")
	local var_76_1 = var_76_0:getChildByName("n_mura_pack"):getChildByName("scrollview_mura")
	
	arg_76_0.vars.scrollview_mura = ItemListView_v2:bindControl(var_76_1)
	
	local var_76_2 = load_control("wnd/shop_promotion_mura_item.csb")
	
	if var_76_1.STRETCH_INFO then
		local var_76_3 = var_76_1:getContentSize()
		
		resetControlPosAndSize(var_76_2, var_76_3.width, var_76_1.STRETCH_INFO.width_prev)
	end
	
	local var_76_4 = {
		onUpdate = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
			local var_77_0 = arg_76_0.vars.current_category.items[1].id
			local var_77_1 = AccountData.ticketed_limits["cp:" .. var_77_0]
			local var_77_2 = arg_77_1:getChildByName("n_item")
			local var_77_3 = var_77_2:getChildByName("reward1")
			local var_77_4 = var_77_3:getChildByName("locked")
			local var_77_5 = var_77_3:getChildByName("icon_noti")
			local var_77_6 = var_77_3:getChildByName("reward_item")
			local var_77_7 = var_77_3:getChildByName("btn_reward_item")
			local var_77_8 = to_n(arg_77_3.reward_score1)
			
			var_77_7.reward_data = {
				reward_score1 = var_77_8,
				score1 = to_n((var_77_1 or {}).score1),
				package_id = var_77_0
			}
			
			if_set(var_77_2, "t_condition", T(arg_77_3.reward_text or "", {
				count = var_77_8
			}))
			
			local var_77_9 = var_77_2:getChildByName("t_condition")
			
			if get_cocos_refid(var_77_9) then
				UIUserData:call(var_77_9, "MULTI_SCALE(2,60)")
			end
			
			local var_77_10 = arg_77_3.items[1]
			
			if var_77_10 then
				UIUtil:getRewardIcon(var_77_10.count, var_77_10.code, {
					parent = var_77_6,
					equip_stat = (var_77_10.data or {}).op,
					grade = (var_77_10.data or {}).g,
					set_fx = (var_77_10.data or {}).f
				})
			end
			
			if var_77_1 and var_77_8 <= to_n(var_77_1.score1) then
				if_set_visible(var_77_4, nil, false)
			else
				var_77_6:setOpacity(127.5)
				if_set_visible(var_77_4, nil, true)
			end
			
			if_set_visible(var_77_3, "icon_noti", false)
			
			if var_77_1 and to_n(var_77_1.score1) > to_n(var_77_1.score3) and var_77_8 > to_n(var_77_1.score3) and var_77_8 <= to_n(var_77_1.score1) then
				if_set_visible(var_77_3, "icon_noti", true)
			end
			
			if var_77_1 and var_77_8 <= to_n(var_77_1.score3) then
				var_77_6:setOpacity(127.5)
				if_set_visible(var_77_3, "icon_check", true)
			else
				if_set_visible(var_77_3, "icon_check", false)
			end
		end
	}
	
	arg_76_0.vars.scrollview_mura:setRenderer(var_76_2, var_76_4)
	arg_76_0.vars.scrollview_mura:removeAllChildren()
	arg_76_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_76_0)
	arg_76_0:updateCustomizeCustomMora()
end

function ShopPromotion.updateCustomizeCustomMora(arg_78_0)
	if not arg_78_0.vars or not get_cocos_refid(arg_78_0.vars.scrollview_mura) then
		return 
	end
	
	arg_78_0.vars.scrollview_mura:setDataSource({})
	
	local var_78_0 = arg_78_0.vars.current_category.items[1].id
	local var_78_1 = AccountData.ticketed_limits["cp:" .. var_78_0]
	local var_78_2 = (AccountData.shop_package_custom_rewards or {})[var_78_0]
	
	if not var_78_2 then
		return 
	end
	
	local var_78_3 = arg_78_0.vars.wnd:getChildByName("n_extra_node")
	
	if not get_cocos_refid(var_78_3) then
		return 
	end
	
	local var_78_4 = var_78_3:getChildByName("n_mura_pack")
	
	if not get_cocos_refid(var_78_4) then
		return 
	end
	
	arg_78_0.vars.scrollview_mura:setDataSource(var_78_2)
	
	if var_78_1 then
		if_set_visible(var_78_4, "n_before", false)
		if_set_visible(var_78_4, "n_after", true)
		
		if var_78_0 == "e7_skillupspecial1_50" then
			if_set(var_78_4:getChildByName("n_after"), "t_count", T("package_mora1_count", {
				count = to_n(var_78_1.score1)
			}))
		elseif var_78_0 == "e7_skillupspecial2_50" then
			if_set(var_78_4:getChildByName("n_after"), "t_count", T("package_mora2_count", {
				count = to_n(var_78_1.score1)
			}))
		end
	else
		if_set_visible(var_78_4, "n_before", true)
		if_set_visible(var_78_4, "n_after", false)
	end
	
	local var_78_5 = var_78_4:getChildByName("btn_get_reward")
	
	var_78_5.can_receive = arg_78_0:canReceiveCustomPackageRewardsByPackage(var_78_0)
	
	if_set_visible(var_78_5, "icon_noti", var_78_5.can_receive)
end

function ShopPromotion.isMuraPackageRewardComplete(arg_79_0, arg_79_1)
	if not AccountData or not AccountData.ticketed_limits or not AccountData.shop_package_custom_rewards then
		return true
	end
	
	local var_79_0 = AccountData.shop_package_custom_rewards[arg_79_1]
	
	if not var_79_0 then
		return true
	end
	
	local var_79_1 = AccountData.ticketed_limits["cp:" .. arg_79_1]
	
	if not var_79_1 then
		return false
	end
	
	if os.time() > to_n(var_79_1.expire_tm) then
		return true
	end
	
	local var_79_2 = 0
	
	for iter_79_0, iter_79_1 in pairs(var_79_0) do
		var_79_2 = math.max(iter_79_1.reward_score1, var_79_2)
	end
	
	if var_79_2 > to_n(var_79_1.score1) or var_79_2 > to_n(var_79_1.score3) then
		return false
	end
	
	return true
end

function ShopPromotion.receiveCustomizedMuraRewards(arg_80_0, arg_80_1, arg_80_2)
	if not get_cocos_refid(arg_80_1) then
		return 
	end
	
	if arg_80_2 and not arg_80_1.can_receive then
		balloon_message_with_sound(T("morapack_reward_fail"))
		
		return 
	end
	
	local var_80_0 = arg_80_0.vars.current_category.items[1].id
	
	if arg_80_0:canReceiveCustomPackageRewardsByPackage(var_80_0) then
		query("receive_custom_package_rewards", {
			package_id = var_80_0
		})
	elseif arg_80_1.reward_data then
		if arg_80_1.reward_data.package_id == "e7_skillupspecial1_50" then
			balloon_message_with_sound(T("package_mora1_reward_info", {
				count = arg_80_1.reward_data.reward_score1
			}))
		elseif arg_80_1.reward_data.package_id == "e7_skillupspecial2_50" then
			balloon_message_with_sound(T("package_mora2_reward_info", {
				count = arg_80_1.reward_data.reward_score1
			}))
		end
	end
end

function ShopPromotion.mainCustomizeRankup(arg_81_0, arg_81_1)
	local var_81_0 = load_control("wnd/shop_promotion_rankup.csb")
	local var_81_1 = var_81_0:getChildByName("n_rankup_pack")
	local var_81_2 = var_81_1:getChildByName("n_rank_up_img")
	
	if var_81_2 then
		var_81_2:removeAllChildren()
	end
	
	if var_81_2 and arg_81_1.rankup_img then
		local var_81_3 = cc.Sprite:create("banner/" .. tostring(arg_81_1.rankup_img) .. ".png")
		
		if var_81_3 then
			var_81_3:setAnchorPoint(0, 0)
			var_81_2:addChild(var_81_3)
		end
	end
	
	local var_81_4 = arg_81_0.vars.current_category.items[1].id
	local var_81_5 = AccountData.package_limits["ip:" .. var_81_4]
	local var_81_6 = arg_81_0:getShopPromotionNameByPackageId(var_81_4)
	local var_81_7 = var_81_1:getChildByName("n_not")
	local var_81_8 = var_81_7:getChildByName("t_not")
	
	if_set(var_81_7, "t_not", T("rankup_reward_buy_reward_info", {
		package = T(var_81_6)
	}))
	
	if arg_81_1.rankup_t_not_tint then
		var_81_8:setColor(tocolor(arg_81_1.rankup_t_not_tint))
	end
	
	if var_81_5 then
		local var_81_9 = os.time()
		local var_81_10 = var_81_5.buyable_tm - var_81_9
		
		if var_81_10 < 31536000 then
			var_81_1:setPositionY(22)
			
			if var_81_10 > 0 then
				local var_81_11 = json.decode(Account:getConfigData("popup_rankup") or "{}") or {}
				
				if not var_81_11[var_81_4] or type(var_81_11[var_81_4]) ~= "table" then
					var_81_11[var_81_4] = {
						reward = 0,
						remain = 0
					}
				end
				
				if to_n(var_81_11[var_81_4].remain) == 0 then
					Dialog:msgBox(T("rankup_limit_info_desc", {
						package = T(var_81_6),
						time = sec_to_full_string(var_81_10)
					}), {
						title = T("rankup_limit_info_title")
					})
					
					var_81_11[var_81_4].remain = var_81_9
					
					SAVE:setTempConfigData("popup_rankup", json.encode(var_81_11))
				end
			end
		end
	end
	
	local var_81_12 = var_81_1:getChildByName("scrollview_rankup")
	
	arg_81_0.vars.rankUpitemView = ItemListView_v2:bindControl(var_81_12)
	
	local var_81_13 = load_control("wnd/shop_promotion_rankup_item.csb")
	
	if var_81_12.STRETCH_INFO then
		local var_81_14 = var_81_12:getContentSize()
		
		resetControlPosAndSize(var_81_13, var_81_14.width, var_81_12.STRETCH_INFO.width_prev)
	end
	
	local var_81_15 = {
		onUpdate = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
			local var_82_0 = arg_81_0.vars.current_category.items[1].id
			local var_82_1 = AccountData.package_limits["ip:" .. var_82_0]
			local var_82_2 = false
			local var_82_3 = Account:getLevel()
			
			if var_82_1 then
				var_82_2 = to_n(var_82_1.count) == 1
			end
			
			for iter_82_0 = 1, 4 do
				local var_82_4 = arg_82_1:getChildByName("reward" .. iter_82_0)
				local var_82_5 = var_82_4:getChildByName("reward_item")
				local var_82_6 = var_82_4:getChildByName("btn_reward_item")
				local var_82_7
				
				if iter_82_0 > 2 then
					var_82_7 = arg_82_3.p[iter_82_0 - 2]
				else
					var_82_7 = arg_82_3.f[iter_82_0]
				end
				
				if var_82_7 then
					var_82_6.item_data = var_82_7
					var_82_6.paid_item = iter_82_0 > 2
					
					local var_82_8 = to_n(var_82_7.give_rank)
					
					if iter_82_0 == 1 then
						UIUtil:setLevel(arg_82_1:getChildByName("n_acc_lv"), var_82_8, MAX_ACCOUNT_LEVEL, 2)
					end
					
					var_82_4:setVisible(true)
					var_82_5:setOpacity(255)
					
					if iter_82_0 > 2 then
						local var_82_9 = false
						
						if var_82_2 ~= true or var_82_3 < var_82_8 then
							var_82_5:setOpacity(127.5)
							if_set_visible(var_82_4, "locked", true)
							
							var_82_9 = true
						else
							if_set_visible(var_82_4, "locked", false)
						end
						
						if var_82_8 <= to_n(var_82_1.score3) then
							var_82_5:setOpacity(76.5)
							if_set_visible(var_82_4, "icon_check", true)
							if_set_visible(var_82_4, "icon_noti", false)
						else
							if_set_visible(var_82_4, "icon_check", false)
							if_set_visible(var_82_4, "icon_noti", not var_82_9)
						end
					else
						local var_82_10 = false
						
						if var_82_3 < var_82_8 then
							var_82_5:setOpacity(127.5)
							if_set_visible(var_82_4, "locked", true)
							
							var_82_10 = true
						else
							if_set_visible(var_82_4, "locked", false)
						end
						
						if var_82_8 <= to_n(var_82_1.score2) then
							var_82_5:setOpacity(76.5)
							if_set_visible(var_82_4, "icon_check", true)
							if_set_visible(var_82_4, "icon_noti", false)
						else
							if_set_visible(var_82_4, "icon_check", false)
							if_set_visible(var_82_4, "icon_noti", not var_82_10)
						end
					end
					
					UIUtil:getRewardIcon(var_82_7.value, var_82_7.item_id, {
						parent = var_82_5,
						equip_stat = (var_82_7.data or {}).op,
						grade = (var_82_7.data or {}).g,
						set_fx = (var_82_7.data or {}).f
					})
				else
					var_82_4:setVisible(false)
				end
			end
		end
	}
	
	arg_81_0.vars.rankUpitemView:setRenderer(var_81_13, var_81_15)
	arg_81_0.vars.rankUpitemView:removeAllChildren()
	arg_81_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_81_0)
	arg_81_0:updateCustomizeRankup()
end

function ShopPromotion.receiveCustomizedRankupRewards(arg_83_0, arg_83_1, arg_83_2)
	if not arg_83_1 then
		return 
	end
	
	local var_83_0 = arg_83_0.vars.current_category.items[1].id
	local var_83_1 = AccountData.package_limits["ip:" .. var_83_0]
	local var_83_2 = Account:getLevel()
	local var_83_3 = to_n(AccountData.shop_rankpack_max[var_83_0])
	local var_83_4 = var_83_1 and to_n(var_83_1.count) == 1
	local var_83_5 = to_n((var_83_1 or {}).score2)
	local var_83_6 = to_n((var_83_1 or {}).score3)
	local var_83_7 = to_n((arg_83_1 or {}).give_rank)
	
	if not var_83_4 and arg_83_2 then
		local var_83_8 = arg_83_0:getShopPromotionNameByPackageId(var_83_0)
		
		balloon_message_with_sound(T("rankup_reward_buy_reward_info", {
			package = T(var_83_8)
		}))
		
		return 
	end
	
	if var_83_2 < var_83_7 then
		balloon_message_with_sound(T("package_reward_info", {
			rank = var_83_7
		}))
		
		return 
	end
	
	local var_83_9 = false
	
	if var_83_4 then
		var_83_9 = (var_83_5 < var_83_2 or var_83_6 < var_83_2) and (var_83_5 < var_83_7 or var_83_6 < var_83_7)
	else
		var_83_9 = var_83_5 < var_83_2 and var_83_5 < var_83_7
	end
	
	if var_83_9 then
		query("receive_rankpack_rewards", {
			package_id = var_83_0
		})
	end
end

function ShopPromotion.receiveCustomizedRankupRewards2(arg_84_0, arg_84_1)
	if not get_cocos_refid(arg_84_1) then
		return 
	end
	
	if not arg_84_1.can_receive then
		balloon_message_with_sound(T("reward_get_failed"))
		
		return 
	end
	
	local var_84_0 = arg_84_0.vars.current_category.items[1].id
	
	query("receive_rankpack_rewards", {
		package_id = var_84_0
	})
end

function ShopPromotion.updateCustomizeRankup(arg_85_0)
	if not arg_85_0.vars or not get_cocos_refid(arg_85_0.vars.rankUpitemView) or not AccountData.shop_rankpack then
		return 
	end
	
	arg_85_0.vars.rankUpitemView:setDataSource({})
	
	local var_85_0 = arg_85_0.vars.current_category.items[1].id
	local var_85_1 = AccountData.shop_rankpack[var_85_0]
	
	if not var_85_1 then
		return 
	end
	
	local var_85_2 = arg_85_0.vars.current_category.items[1].id
	local var_85_3 = AccountData.package_limits["ip:" .. var_85_2]
	local var_85_4 = arg_85_0.vars.wnd:getChildByName("n_extra_node")
	
	if var_85_3 then
		if_set_visible(var_85_4, "n_not", to_n(var_85_3.count) ~= 1)
	end
	
	arg_85_0.vars.rankUpitemView:setDataSource(var_85_1)
	
	if get_cocos_refid(var_85_4) then
		local var_85_5 = var_85_4:getChildByName("n_rankup_pack")
		
		if get_cocos_refid(var_85_5) then
			local var_85_6 = var_85_5:getChildByName("btn_get_reward")
			
			var_85_6.can_receive = arg_85_0:canReceiveRankupPackageRewards(var_85_2)
			
			if_set_visible(var_85_6, "icon_noti", var_85_6.can_receive)
		end
	end
end

function ShopPromotion.popupRemainRankupRewards(arg_86_0, arg_86_1)
	local var_86_0 = AccountData.package_limits["ip:" .. arg_86_1]
	
	if not var_86_0 or to_n(var_86_0.count) > 0 then
		return 
	end
	
	if to_n(AccountData.shop_rankpack_max[arg_86_1]) > to_n(var_86_0.score2) then
		return 
	end
	
	local var_86_1 = AccountData.shop_rankpack[arg_86_1]
	
	if not var_86_1 then
		return 
	end
	
	local var_86_2 = json.decode(Account:getConfigData("popup_rankup") or "{}")
	
	if not var_86_2[arg_86_1] or type(var_86_2[arg_86_1]) ~= "table" then
		var_86_2[arg_86_1] = {
			reward = 0,
			remain = 0
		}
	end
	
	if to_n(var_86_2[arg_86_1].reward) == 0 then
		var_86_2[arg_86_1].reward = os.time()
		
		SAVE:setTempConfigData("popup_rankup", json.encode(var_86_2))
	else
		return 
	end
	
	local var_86_3 = {}
	
	for iter_86_0, iter_86_1 in pairs(var_86_1) do
		if iter_86_1.p then
			for iter_86_2, iter_86_3 in pairs(iter_86_1.p) do
				var_86_3[iter_86_3.item_id] = (var_86_3[iter_86_3.item_id] or 0) + iter_86_3.value
			end
		end
	end
	
	if AccountData.shop_rankpack_items and AccountData.shop_rankpack_items[arg_86_1] then
		for iter_86_4, iter_86_5 in pairs(AccountData.shop_rankpack_items[arg_86_1]) do
			var_86_3[iter_86_4] = (var_86_3[iter_86_4] or 0) + to_n(iter_86_5)
		end
	end
	
	UIAction:Add(SEQ(DELAY(200), CALL(ShopPromotion.popupRemainRankRewardMsgBox, arg_86_0, arg_86_1, var_86_3)), arg_86_0.vars.rankUpitemView, "block")
end

function ShopPromotion.popupRemainRankRewardMsgBox(arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = load_dlg("msgbox_rewards", true, "wnd")
	
	if_set_visible(var_87_0, "txt_letter", false)
	if_set_visible(var_87_0, "txt_count", false)
	
	local var_87_1 = var_87_0:getChildByName("n_line1")
	local var_87_2 = 98
	local var_87_3 = table.count(arg_87_2)
	local var_87_4 = {
		no_reward_effect = true,
		dlg = var_87_0
	}
	local var_87_5 = var_87_0:getChildByName("text")
	local var_87_6 = var_87_0:getChildByName("text")
	
	if get_cocos_refid(var_87_6) then
		var_87_4.banner_txt_vertical_alignment = var_87_6:getTextVerticalAlignment()
	end
	
	local var_87_7 = 0
	
	for iter_87_0, iter_87_1 in pairs(arg_87_2) do
		var_87_7 = var_87_7 + 1
		
		local var_87_8 = {
			show_small_count = true,
			no_remove_prev_icon = true,
			touch_block = true,
			parent = var_87_1
		}
		local var_87_9 = UIUtil:getRewardIcon(iter_87_1, iter_87_0, var_87_8)
		
		var_87_9:setAnchorPoint(0, 0.5)
		
		local var_87_10 = var_87_7
		
		if var_87_3 < var_87_7 then
			var_87_10 = var_87_10 - var_87_3
		end
		
		var_87_9:setPositionX(var_87_2 * (var_87_10 - 1))
		
		if var_87_3 > 0 then
			var_87_1:setPositionX(0 - var_87_2 * var_87_3 / 2)
		end
	end
	
	if_set(var_87_0, "txt_title", T("rankup_package_guide_buy_title"))
	
	local var_87_11 = arg_87_0:getShopPromotionNameByPackageId(arg_87_1)
	
	Dialog:msgBox(T("rankup_package_guide_buy_desc", {
		package = T(var_87_11)
	}), var_87_4)
end

function ShopPromotion.mainCustomizeStartGacha(arg_88_0)
	arg_88_0.vars.wnd:getChildByName("n_item_node_1"):setPositionX(-181)
	
	local var_88_0 = load_control("wnd/shop_promo_dash_base.csb")
	
	if_set_sprite(var_88_0:getChildByName("n_bi"), "img_bi", "banner/pk_gacha_start_bi.png")
	
	local var_88_1 = UIUtil:getPortraitAni(DB("character", "c1005", "face_id"))
	
	if var_88_1 then
		var_88_1:setSkin("smile")
		var_88_0:getChildByName("n_pos1"):addChild(var_88_1)
		UIUtil:setPortraitPositionByFaceBone(var_88_1)
	end
	
	local var_88_2 = UIUtil:getPortraitAni(DB("character", "c1001", "face_id"))
	
	if var_88_2 then
		var_88_2:setSkin("smile")
		var_88_0:getChildByName("n_pos2"):addChild(var_88_2)
		UIUtil:setPortraitPositionByFaceBone(var_88_2)
	end
	
	local var_88_3 = var_88_0:getChildByName("n_gacha_start"):getChildren()
	
	for iter_88_0 = 1, #var_88_3 do
		local var_88_4 = var_88_3[iter_88_0]
		
		if var_88_4:getName() == "grow" then
			var_88_4:setColor(tocolor("#0e1c21"))
		end
	end
	
	if_set_sprite(var_88_0, "info_txt", "banner/gacha_info_start.png")
	arg_88_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_88_0)
end

function ShopPromotion._dev_storyui(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
	local var_89_0 = {}
	
	if tostring(arg_89_2) == "bi" then
		var_89_0.bi_img = arg_89_3
		var_89_0.bi_data = arg_89_4
	elseif to_n(arg_89_2) >= 1 and to_n(arg_89_2) <= 4 then
		var_89_0["char" .. arg_89_2 .. "_id"] = arg_89_3
		var_89_0["char" .. arg_89_2 .. "_data"] = arg_89_4
	else
		Log.e("_dev_storyui NO NOT FOUND: " .. arg_89_2)
		
		return 
	end
	
	arg_89_0:updateMainPage({
		customize_data = var_89_0
	})
end

function ShopPromotion.mainCustomizeStoryGacha(arg_90_0, arg_90_1)
	arg_90_1 = arg_90_1 or {}
	
	arg_90_0.vars.wnd:getChildByName("n_item_node_1"):setPositionX(-181)
	
	local var_90_0 = arg_90_0.vars.current_category.items[1].id
	local var_90_1 = arg_90_0:getPackageData(var_90_0)
	
	if not var_90_1 then
		return 
	end
	
	local var_90_2
	
	if var_90_1 and var_90_1.type == "gacha_story_ep999" then
		var_90_2 = load_control("wnd/shop_promo_dash_luckyweek_base.csb")
		
		if_set(var_90_2, "t_dash_info", T("gacha_festival_info"))
	elseif var_90_1 and var_90_1.type == "gacha_spdash" then
		var_90_2 = load_control("wnd/shop_promo_dash_luckyweek_base.csb")
		
		if_set(var_90_2, "t_dash_info", T("gacha_specialdash_info"))
	else
		var_90_2 = load_control("wnd/shop_promo_dash_story_base.csb")
	end
	
	local var_90_3 = arg_90_0.vars.gacha_story_ui[var_90_1.type]
	
	if arg_90_1.customize_data then
		for iter_90_0, iter_90_1 in pairs(arg_90_1.customize_data or {}) do
			var_90_3[iter_90_0] = iter_90_1
		end
	end
	
	local var_90_4 = Account:getGachaShopInfo()
	
	if var_90_4 and var_90_4.gacha_story and var_90_4.gacha_story[var_90_3.id] then
		local var_90_5 = var_90_4.gacha_story[var_90_3.id]
		
		if var_90_5.gacha_id then
			local var_90_6 = DB("gacha_ui", var_90_5.gacha_id, "info_txt")
			
			if var_90_6 then
				if_set_sprite(var_90_2, "info_txt", "banner/" .. var_90_6 .. ".png")
			end
		end
	end
	
	local var_90_7 = var_90_2:getChildByName("n_bi")
	
	if var_90_3.bi_img then
		if_set_sprite(var_90_7, "img_bi", "banner/" .. var_90_3.bi_img .. ".png")
		GachaUnit:setDataUI(var_90_7, var_90_3.bi_data)
	end
	
	for iter_90_2 = 1, 4 do
		local var_90_8 = var_90_2:getChildByName("n_pos" .. iter_90_2)
		local var_90_9 = var_90_3["char" .. iter_90_2 .. "_id"]
		
		if get_cocos_refid(var_90_8) and var_90_9 then
			local var_90_10 = DB("character", var_90_9, "face_id")
			
			if var_90_10 then
				local var_90_11 = UIUtil:getPortraitAni(var_90_10)
				
				if var_90_11 then
					var_90_8:addChild(var_90_11)
					GachaUnit:setDataUI(var_90_8, var_90_3["char" .. iter_90_2 .. "_data"], var_90_11)
				end
			end
		end
	end
	
	local var_90_12 = var_90_2:getChildByName("n_info")
	
	if var_90_3.title then
		if_set(var_90_12, "txt_info", T(var_90_3.title))
	end
	
	for iter_90_3 = 1, 4 do
		if var_90_3["text_" .. iter_90_3] then
			if_set(var_90_12, "disc" .. iter_90_3, T(var_90_3["text_" .. iter_90_3]))
		end
	end
	
	if var_90_3.grow_tint then
		if_set_color(var_90_2, "n_grow", tocolor(var_90_3.grow_tint))
	end
	
	arg_90_0.vars.wnd:getChildByName("n_extra_node"):addChild(var_90_2)
end

function ShopPromotion.selectCategory(arg_91_0, arg_91_1, arg_91_2)
	if arg_91_0.vars.current_category == arg_91_1 then
		return 
	end
	
	arg_91_0.vars.current_category = arg_91_1
	
	arg_91_0:updateCategories()
	arg_91_0:updateMainPage()
	
	if arg_91_2 then
		arg_91_0:jumpToIndex(arg_91_2)
	end
end

function ShopPromotion.getPackageRemainTime(arg_92_0, arg_92_1)
	if not arg_92_0.vars or not arg_92_0.vars.category_packages then
		return nil
	end
	
	local var_92_0 = arg_92_0.vars.category_packages[arg_92_1]
	
	if not var_92_0 then
		return nil
	end
	
	local var_92_1 = os.time()
	
	if var_92_0.intelli_package == "y" then
		for iter_92_0, iter_92_1 in pairs(var_92_0.items) do
			if iter_92_1.id == arg_92_1 then
				local var_92_2 = AccountData.package_limits["sh:" .. arg_92_1]
				
				if var_92_2 == nil or var_92_2.count > 0 then
					return nil
				else
					return to_n(var_92_2.expire_tm) - var_92_1
				end
			end
		end
	elseif var_92_0.intelli_package == "v2" then
		for iter_92_2, iter_92_3 in pairs(var_92_0.items) do
			if iter_92_3.id == arg_92_1 then
				local var_92_3 = AccountData.package_limits["ip:" .. arg_92_1]
				
				if var_92_3 then
					local var_92_4 = to_n(var_92_3.buyable_tm) - var_92_1
					
					if var_92_4 < 31536000 then
						return var_92_4
					else
						return nil
					end
				end
			end
		end
	elseif to_n(var_92_1 + 31536000) > to_n(var_92_0.end_time_from_server) then
		return var_92_0.end_time_from_server - var_92_1
	else
		return nil
	end
end

function ShopPromotion.updateRemainTime(arg_93_0)
	if arg_93_0.vars == nil or arg_93_0.vars.current_category == nil then
		return 
	end
	
	arg_93_0:updateCategories()
	
	if arg_93_0.vars.current_category.items and arg_93_0.vars.current_category.items[1].shop_package_data and arg_93_0.vars.current_category.items[1].shop_package_data.chain_group_id then
		return 
	end
	
	local var_93_0 = arg_93_0.vars.wnd:getChildByName("n_popup_notice")
	
	if get_cocos_refid(var_93_0) then
		local var_93_1 = false
		
		if arg_93_0.vars.current_category.time_visible and arg_93_0.vars.current_category.items then
			local var_93_2 = -999999
			
			for iter_93_0 = 1, 4 do
				if arg_93_0.vars.current_category.items[iter_93_0] then
					var_93_2 = math.max(to_n(arg_93_0:getPackageRemainTime(arg_93_0.vars.current_category.items[iter_93_0].id)), var_93_2)
				end
			end
			
			if var_93_2 > 0 and var_93_2 <= 86400 then
				var_93_1 = true
				
				if_set(var_93_0, "t_popup_time", T("time_remain", {
					time = sec_to_full_string(var_93_2, false, {
						count = 2
					})
				}))
			end
		end
		
		if_set_visible(arg_93_0.vars.wnd, "n_popup_notice", var_93_1)
	end
	
	for iter_93_1 = 1, 4 do
		if arg_93_0.vars.current_category.items[iter_93_1] then
			local var_93_3 = #arg_93_0.vars.current_category.items
			
			if var_93_3 == 3 then
				var_93_3 = 4
			end
			
			local var_93_4 = arg_93_0.vars.wnd.c["n_item_node_" .. var_93_3].c["n_item" .. iter_93_1 .. "/" .. var_93_3]
			local var_93_5 = arg_93_0.vars.current_category.items[iter_93_1]
			local var_93_6 = arg_93_0:getPackageRemainTime(var_93_5.id)
			local var_93_7 = var_93_4:getChildByName("n_purchased")
			
			if get_cocos_refid(var_93_7) then
				local var_93_8 = arg_93_0:getPackageRemainTime(var_93_5.id)
				
				if var_93_8 and to_n(var_93_8) < 1 then
					if_set(var_93_7, "complet_label", T("expired"))
					var_93_7:setVisible(true)
					if_set_visible(var_93_4, "btn_buy", false)
				end
			end
			
			local var_93_9 = arg_93_0.vars.category_packages[var_93_5.id]
			
			if var_93_9.intelli_package == "y" then
				if var_93_6 then
					if_set_visible(var_93_4, "n_period", true)
					
					if to_n(var_93_6) > 0 then
						if_set(var_93_4, "t_period", T("sell_period2") .. " " .. T("time_remain", {
							time = sec_to_full_string(var_93_6)
						}))
					else
						if_set(var_93_4, "t_period", T("sell_period2") .. " " .. T("expired"))
					end
				else
					if_set_visible(var_93_4, "n_period", false)
				end
			elseif var_93_9.intelli_package == "v2" then
				if var_93_6 then
					if_set_visible(var_93_4, "n_period", true)
					
					if to_n(var_93_6) > 0 then
						if_set(var_93_4, "t_period", T("sell_period2") .. " " .. T("time_remain", {
							time = sec_to_full_string(var_93_6)
						}))
					else
						if_set(var_93_4, "t_period", T("sell_period2") .. " " .. T("expired"))
					end
				else
					if_set_visible(var_93_4, "n_period", false)
				end
			end
		end
	end
end

function ShopPromotion.selectItem(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0 = os.time()
	local var_94_1, var_94_2, var_94_3 = arg_94_0:GetPackageRestCount(arg_94_2)
	
	if var_94_2 then
		arg_94_2.rest_count = var_94_1
	end
	
	local var_94_4 = arg_94_0.vars.category_packages[arg_94_2.id]
	local var_94_5 = not var_94_2 or var_94_1 >= 1
	local var_94_6 = arg_94_3.time_visible
	local var_94_7 = {}
	local var_94_8 = var_94_4.csd_condition == "chain" and var_94_4.intelli_package == "v2"
	
	if var_94_8 then
		var_94_7.is_chain_package = true
		
		if not var_94_5 and var_94_2 == 0 then
			var_94_6 = nil
			var_94_7.lock_chain = true
			var_94_2 = arg_94_2.limit_count
			var_94_1 = var_94_2
			var_94_5 = true
		end
	end
	
	if_set_visible(arg_94_1, "btn_buy", var_94_5)
	
	local var_94_9 = arg_94_2.promotion_list and string.starts(arg_94_2.promotion_list, "levelup_") or to_n(AccountData.shop_rankpack_max[arg_94_2.id]) > 0
	
	if_set_visible(arg_94_1, "n_purchased", not var_94_5 and var_94_2 and var_94_1 < 1 and not var_94_9)
	
	local var_94_10 = arg_94_1:getChildByName("n_purchased")
	
	if get_cocos_refid(var_94_10) and var_94_10:isVisible() then
		if_set(var_94_10, "complet_label", T("shop_package_b_purchased"))
	end
	
	if_set_visible(arg_94_1, "noti_new", arg_94_2.new)
	if_set_visible(arg_94_1, "noti_hot", arg_94_2.hot)
	ShopCommon:UpdatePayIcon(arg_94_1.c.btn_buy, arg_94_2)
	
	arg_94_1.c.btn_buy.item = arg_94_2
	
	if var_94_2 then
		if_set(arg_94_1, "txt_buy", T("event_package_buy_availability", {
			count = string.format("(%d/%d)", var_94_1, var_94_2)
		}))
	else
		if_set(arg_94_1, "txt_buy", T("shop_package_buy_btn"))
	end
	
	if_set_visible(arg_94_1, "n_rank_limit", false)
	if_set_visible(arg_94_1, "n_period", var_94_6)
	
	if get_cocos_refid(var_94_10) then
		local var_94_11 = arg_94_0:getPackageRemainTime(arg_94_2.id)
		
		if var_94_11 and to_n(var_94_11) < 1 then
			if_set(var_94_10, "complet_label", T("expired"))
			var_94_10:setVisible(true)
			if_set_visible(arg_94_1, "btn_buy", false)
		end
	end
	
	if var_94_4.intelli_package == "y" and not var_94_8 then
		arg_94_0:updateRemainTime()
	elseif var_94_4.intelli_package == "v2" and not var_94_8 then
		arg_94_0:updateRemainTime()
	elseif arg_94_3.time_visible and to_n(var_94_0 + 31536000) > to_n(arg_94_3.end_time_from_server) then
		if_set_visible(arg_94_1, "n_period", true)
		if_set(arg_94_1, "t_period", T("sell_period_v2", timeToStringDef({
			preceding_with_zeros = true,
			start_time = arg_94_3.start_time_from_server,
			end_time = arg_94_3.end_time_from_server
		})))
	else
		if_set_visible(arg_94_1, "n_period", false)
	end
	
	local var_94_12 = arg_94_1:getChildByName("n_ballon_on")
	
	if get_cocos_refid(var_94_12) then
		var_94_12:setVisible(false)
		var_94_12:removeAllChildren()
	end
	
	local var_94_13 = arg_94_1:getChildByName("n_ballon_off")
	
	if get_cocos_refid(var_94_13) then
		var_94_13:setVisible(false)
		var_94_13:removeAllChildren()
	end
	
	local var_94_14, var_94_15, var_94_16, var_94_17 = DB("shop_package_bonus", arg_94_2.id, {
		"item_id",
		"bonus_item_condition",
		"bonus_item_value",
		"ui_desc"
	})
	
	if get_cocos_refid(var_94_12) and get_cocos_refid(var_94_13) and var_94_14 and var_94_1 > var_94_2 - var_94_16 then
		local var_94_18 = load_control("wnd/shop_promotion_noti_balloon.csb")
		
		var_94_18:setAnchorPoint(0.5, 0.5)
		var_94_18:getChildByName("btn_ballon_on"):setName("btn_ballon_on:" .. arg_94_2.id)
		var_94_13:addChild(var_94_18)
		
		local var_94_19 = load_control("wnd/shop_promotion_balloon.csb")
		
		var_94_19:setAnchorPoint(0.5, 0.5)
		
		local var_94_20 = ""
		
		if var_94_15 == "day" then
			var_94_20 = T("add_promotion_day")
		elseif var_94_15 == "week" then
			var_94_20 = T("add_promotion_week")
		elseif var_94_15 == "month" then
			var_94_20 = T("add_promotion_month")
		elseif var_94_15 == "only_once" then
			var_94_20 = T("add_promotion_only")
		elseif var_94_15 == "package_expire_day" then
			var_94_20 = T("add_promotion_expire")
		end
		
		if arg_94_2.type == "gacha_story_ep999" then
			if_set(var_94_19, "t_add_package_title", T("package_luckyweek_bonus_tilte"))
		else
			if_set(var_94_19, "t_add_package_title", T("new_package_add_promotion_title", {
				package_name = T(arg_94_2.name),
				limit_condition = var_94_20,
				count = var_94_16
			}))
		end
		
		if_set(var_94_19, "t_add_package_disc", T(var_94_17))
		
		local var_94_21 = var_94_19:getChildByName("t_add_package_disc")
		
		if get_cocos_refid(var_94_21) then
			if var_94_21:getStringNumLines() > 4 then
				if_set_visible(var_94_19, "t_add_package_disc", false)
				if_set_visible(var_94_19, "icon_add_package", false)
				if_set_visible(var_94_19, "t_add_package_disc2", true)
				if_set(var_94_19, "t_add_package_disc2", T(var_94_17))
			else
				if_set_visible(var_94_19, "t_add_package_disc", true)
				if_set_visible(var_94_19, "icon_add_package", true)
				if_set_visible(var_94_19, "t_add_package_disc2", false)
				UIUtil:getRewardIcon(nil, var_94_14, {
					no_popup = true,
					name = false,
					no_tooltip = true,
					no_bg = true,
					scale = 1,
					parent = var_94_19:getChildByName("icon_add_package")
				})
			end
		end
		
		var_94_12:addChild(var_94_19)
		
		arg_94_0.vars.add_toggled = arg_94_0.vars.add_toggled or {}
		
		if not arg_94_0.vars.add_toggled[arg_94_2.id] then
			arg_94_0.vars.add_toggled[arg_94_2.id] = true
			
			UIAction:Add(SEQ(SHOW(false), FADE_IN(300), DELAY(2500), FADE_OUT(300), CALL(if_set_visible, var_94_13, nil, true)), var_94_12, "ap_ballon_" .. arg_94_2.id)
		else
			if_set_visible(arg_94_1, "n_ballon_off", true)
		end
	end
	
	return var_94_7
end

function ShopPromotion.toggleAddPromotionBallon(arg_95_0, arg_95_1, arg_95_2)
	local var_95_0 = arg_95_1:getParent():getParent():getParent():getParent()
	
	if get_cocos_refid(var_95_0) then
		local var_95_1 = var_95_0:getChildByName("n_ballon_on")
		
		if get_cocos_refid(var_95_1) then
			if_set_visible(var_95_0, "n_ballon_off", false)
			UIAction:Add(SEQ(SHOW(false), FADE_IN(300), DELAY(2500), FADE_OUT(300), CALL(if_set_visible, var_95_0, "n_ballon_off", true)), var_95_1, "ap_ballon_" .. arg_95_2)
		end
	end
end

function ShopPromotion.reqReceiveDailyPackage(arg_96_0)
	query("receive_daily_promotion")
	
	return true
end

function ShopPromotion.onSelectScrollViewItem(arg_97_0, arg_97_1, arg_97_2)
	SoundEngine:play("event:/ui/category/select")
	arg_97_0:selectCategory(arg_97_2.item)
end

function ShopPromotion.getScrollViewItem(arg_98_0, arg_98_1)
	local var_98_0 = load_control("wnd/shop_promotion_base_item.csb")
	
	if_set(var_98_0, "txt_title", T(arg_98_1.name))
	if_set_sprite(var_98_0, "icon_menu", "img/" .. arg_98_1.icon .. ".png")
	arg_98_0:updateCategory(var_98_0, arg_98_1)
	
	return var_98_0
end

function ShopPromotion.updateCategories(arg_99_0)
	if SceneManager:getCurrentSceneName() ~= "shop" or not arg_99_0.ScrollViewItems then
		return 
	end
	
	for iter_99_0, iter_99_1 in pairs(arg_99_0.ScrollViewItems) do
		arg_99_0:updateCategory(iter_99_1.control, iter_99_1.item)
	end
end

function ShopPromotion.chainPackageRestCount(arg_100_0, arg_100_1)
	local var_100_0 = 0
	local var_100_1 = 0
	local var_100_2 = arg_100_1.items[1].shop_package_data.chain_group_id
	
	for iter_100_0, iter_100_1 in pairs(arg_100_0.vars.chain_packages[var_100_2]) do
		for iter_100_2, iter_100_3 in pairs(iter_100_1.items) do
			local var_100_3, var_100_4, var_100_5 = arg_100_0:GetPackageRestCount(iter_100_3)
			
			var_100_0 = var_100_0 + to_n(iter_100_3.limit_count)
			var_100_1 = var_100_1 + to_n(var_100_3)
		end
	end
	
	return var_100_1, var_100_0
end

function ShopPromotion.updateCategory(arg_101_0, arg_101_1, arg_101_2)
	if arg_101_1 == nil then
		for iter_101_0, iter_101_1 in pairs(arg_101_0.ScrollViewItems) do
			if iter_101_1.item == arg_101_2 then
				arg_101_1 = iter_101_1.control
			end
		end
	end
	
	if not get_cocos_refid(arg_101_1) then
		return 
	end
	
	if_set_visible(arg_101_1, "select", arg_101_0.vars.current_category == arg_101_2)
	
	local var_101_0 = os.time()
	local var_101_1
	
	if not is_empty(arg_101_2.tag) then
		if string.find(arg_101_2.tag, ".png") then
			if_set_sprite(arg_101_1, "icon_badge", "img/" .. arg_101_2.tag)
		else
			if_set_sprite(arg_101_1, "icon_badge", "img/shop_icon_" .. arg_101_2.tag .. ".png")
		end
		
		if_set_visible(arg_101_1, "icon_badge", true)
	else
		if_set_visible(arg_101_1, "icon_badge", false)
	end
	
	local var_101_2 = arg_101_2.csd_condition == "chain" and arg_101_2.intelli_package == "v2"
	local var_101_3 = -9999999
	
	if var_101_2 then
		local var_101_4, var_101_5 = arg_101_0:chainPackageRestCount(arg_101_2)
		
		if var_101_4 > 0 then
			if_set(arg_101_1, "txt_subtitle", T("shop_package_b_left_on"))
			arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(97, 191, 255))
			
			var_101_3 = to_n(arg_101_2.end_time_from_server) - os.time()
			
			if var_101_3 < 31536000 then
				var_101_1 = true
			end
		else
			if_set(arg_101_1, "txt_subtitle", T("shop_package_b_purchased"))
			arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(255, 120, 0))
		end
	else
		for iter_101_2, iter_101_3 in pairs(arg_101_2.items) do
			if iter_101_3.promotion_list and string.starts(iter_101_3.promotion_list, "monthly_") then
				local var_101_6 = to_n(string.sub(iter_101_3.promotion_list, -1, -1))
				local var_101_7 = to_n(ShopPromotion:GetRestMonthlyDays(var_101_6))
				
				if var_101_7 > 0 then
					if_set(arg_101_1, "txt_subtitle", T("package_reward_duration", {
						day = var_101_7
					}))
					arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(255, 120, 0))
				else
					if_set(arg_101_1, "txt_subtitle", T("shop_package_b_left_on"))
					arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(97, 191, 255))
				end
			else
				local var_101_8, var_101_9, var_101_10 = arg_101_0:GetPackageRestCount(iter_101_3)
				
				if not var_101_1 and var_101_8 and var_101_8 < 1 then
					if_set(arg_101_1, "txt_subtitle", T("shop_package_b_purchased"))
					arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(255, 120, 0))
				else
					if arg_101_2.time_visible then
						if arg_101_0:getPackageRemainTime(iter_101_3.id) then
							var_101_3 = math.max(to_n(arg_101_0:getPackageRemainTime(iter_101_3.id)), var_101_3)
						else
							arg_101_2.time_visible = nil
						end
					end
					
					if_set(arg_101_1, "txt_subtitle", T("shop_package_b_left_on"))
					arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(97, 191, 255))
					
					var_101_1 = true
				end
				
				if var_101_9 then
					iter_101_3.rest_count = var_101_8
				end
			end
		end
	end
	
	if var_101_1 and arg_101_2.time_visible then
		if to_n(var_101_3) > 0 then
			if var_101_3 < 31536000 then
				if var_101_3 <= 86400 then
					arg_101_1.c.txt_subtitle:setTextColor(cc.c3b(255, 120, 0))
				end
				
				if_set(arg_101_1, "txt_subtitle", T("time_remain", {
					time = sec_to_full_string(var_101_3, false, {
						count = 2
					})
				}))
			end
		else
			if_set(arg_101_1, "txt_subtitle", T("expired"))
		end
	end
	
	if arg_101_2.items[1] and arg_101_2.items[1].id then
		if_set_visible(arg_101_1, "icon_noti", arg_101_0:canReceiveCustomPackageRewards(arg_101_2.items[1].id))
	else
		if_set_visible(arg_101_1, "icon_noti", false)
	end
	
	return arg_101_1
end

function ShopPromotion.isRankupPackageRewardComplete(arg_102_0, arg_102_1)
	if not AccountData.shop_rankpack or not AccountData.shop_rankpack_max then
		return true
	end
	
	if not AccountData.shop_rankpack[arg_102_1] then
		return true
	end
	
	local var_102_0 = AccountData.package_limits["ip:" .. arg_102_1]
	
	if not var_102_0 then
		return false
	end
	
	if os.time() > var_102_0.buyable_tm then
		return true
	end
	
	local var_102_1 = to_n(AccountData.shop_rankpack_max[arg_102_1])
	
	if var_102_1 > Account:getLevel() or var_102_1 > to_n(var_102_0.score2) or var_102_1 > to_n(var_102_0.score3) then
		return false
	end
	
	return true
end

function ShopPromotion.canReceiveRankupPackageRewards(arg_103_0, arg_103_1)
	if not AccountData or not AccountData.package_limits or not AccountData.shop_rankpack or not AccountData.shop_rankpack_max then
		return false
	end
	
	local var_103_0 = Account:getLevel()
	local var_103_1 = 0
	local var_103_2 = {}
	local var_103_3 = os.time()
	
	for iter_103_0, iter_103_1 in pairs(AccountData.shop_rankpack_max) do
		local var_103_4 = arg_103_1 or iter_103_0
		local var_103_5 = AccountData.shop_rankpack[iter_103_0]
		local var_103_6
		
		if var_103_5 and var_103_4 == iter_103_0 then
			var_103_6 = AccountData.package_limits["ip:" .. iter_103_0]
			
			for iter_103_2, iter_103_3 in pairs(var_103_5) do
				if iter_103_3.p then
					for iter_103_4, iter_103_5 in pairs(iter_103_3.p) do
						if var_103_6 and to_n(var_103_6.count) > 0 and var_103_3 < to_n(var_103_6.buyable_tm) then
							local var_103_7 = to_n(var_103_6.score3)
							
							if var_103_7 < iter_103_1 and var_103_7 < iter_103_5.give_rank and var_103_0 >= iter_103_5.give_rank and (iter_103_5.rdc == "y" or arg_103_1) then
								var_103_1 = var_103_1 + 1
								var_103_2[iter_103_5.item_id] = (var_103_2[iter_103_5.item_id] or 0) + iter_103_5.value
							end
						end
					end
				end
				
				if iter_103_3.f then
					for iter_103_6, iter_103_7 in pairs(iter_103_3.f) do
						if var_103_6 and var_103_3 < to_n(var_103_6.buyable_tm) then
							local var_103_8 = to_n((var_103_6 or {}).score2)
							
							if var_103_8 < iter_103_1 and var_103_8 < iter_103_7.give_rank and var_103_0 >= iter_103_7.give_rank and (iter_103_7.rdc == "y" or arg_103_1) then
								var_103_1 = var_103_1 + 1
								var_103_2[iter_103_7.item_id] = (var_103_2[iter_103_7.item_id] or 0) + iter_103_7.value
							end
						end
					end
				end
			end
		end
	end
	
	return var_103_1 > 0
end

function ShopPromotion.createCategories(arg_104_0, arg_104_1)
	if not arg_104_0.vars or not get_cocos_refid(arg_104_0.vars.wnd) then
		return 
	end
	
	arg_104_0.vars.except_sold_out_id = arg_104_1
	arg_104_0.vars.categories = {}
	arg_104_0.vars.category_packages = {}
	arg_104_0.vars.gacha_story_ui = {}
	arg_104_0.vars.chain_packages = {}
	
	for iter_104_0 = 1, 99 do
		local var_104_0 = {}
		
		var_104_0.id, var_104_0.char1_id, var_104_0.char1_data, var_104_0.char2_id, var_104_0.char2_data, var_104_0.char3_id, var_104_0.char3_data, var_104_0.char4_id, var_104_0.char4_data, var_104_0.bi_img, var_104_0.bi_data, var_104_0.title, var_104_0.text_1, var_104_0.text_2, var_104_0.text_3, var_104_0.text_4, var_104_0.grow_tint = DBN("gacha_story_ui", iter_104_0, {
			"id",
			"char1_id",
			"p_char1_data",
			"char2_id",
			"p_char2_data",
			"char3_id",
			"p_char3_data",
			"char4_id",
			"p_char4_data",
			"bi_img",
			"p_bi_data",
			"ui_info_text_title",
			"ui_info_text_1",
			"ui_info_text_2",
			"ui_info_text_3",
			"ui_info_text_4",
			"grow_tint"
		})
		
		if not var_104_0.id then
			break
		end
		
		arg_104_0.vars.gacha_story_ui[var_104_0.id] = var_104_0
	end
	
	local var_104_1 = os.time()
	
	for iter_104_1, iter_104_2 in pairs(AccountData.shop_promotion_categories) do
		local var_104_2 = DBT("shop_promotion_category", tostring(iter_104_2.id), {
			"id",
			"name",
			"icon",
			"sort",
			"bg_image",
			"bg_image_info",
			"sold_out",
			"before_package",
			"package_1",
			"package_2",
			"package_3",
			"package_4",
			"time_visible",
			"condition",
			"value",
			"tag",
			"add_promotion",
			"intelli_package",
			"buy_time",
			"csd_condition",
			"view_category"
		})
		
		if not var_104_2.id then
			break
		end
		
		var_104_2.items = {
			arg_104_0:getItemById(var_104_2.package_1),
			arg_104_0:getItemById(var_104_2.package_2),
			arg_104_0:getItemById(var_104_2.package_3),
			arg_104_0:getItemById(var_104_2.package_4)
		}
		
		for iter_104_3 = 1, 4 do
			local var_104_3 = var_104_2["package_" .. iter_104_3]
			
			if var_104_3 then
				arg_104_0.vars.category_packages[var_104_3] = var_104_2
			end
		end
		
		var_104_2.start_time_from_server = iter_104_2.start_time
		var_104_2.end_time_from_server = iter_104_2.end_time
		
		if not is_empty(iter_104_2.sort) then
			var_104_2.sort = iter_104_2.sort
		end
		
		var_104_2.tag = iter_104_2.tag
		var_104_2.top_priority = iter_104_2.top_priority
		
		if var_104_2.tag == "0" or var_104_2.tag == 0 then
			var_104_2.tag = ""
		end
		
		local var_104_4 = AccountData.package_limits["ip:" .. var_104_2.package_1]
		
		if var_104_4 and to_n(var_104_4.issue_end_tm) > 0 then
			var_104_2.issue_end_tm = to_n(var_104_4.issue_end_tm)
		end
		
		local var_104_5 = true
		
		if not var_104_2.items or #var_104_2.items == 0 then
			var_104_5 = false
		end
		
		local var_104_6 = var_104_2.sold_out == "y"
		local var_104_7 = arg_104_0:getItemById(var_104_2.package_1)
		local var_104_8 = var_104_2.csd_condition == "chain" and var_104_2.intelli_package == "v2"
		
		if string.starts(var_104_2.package_1, "e7_levelup") or to_n(AccountData.shop_rankpack_max[var_104_2.package_1]) > 0 then
			if AccountData.package_limits["ip:" .. var_104_2.package_1] and arg_104_0:isRankupPackageRewardComplete(var_104_2.package_1) ~= true then
				var_104_6 = nil
				
				if arg_104_0:canReceiveCustomPackageRewards(var_104_2.package_1) then
					var_104_2.sort_top = true
				end
			else
				local var_104_9 = arg_104_0:GetRankupBonusList(var_104_2.package_1)
				
				if #var_104_9 > 0 and (not AccountData.pkg_rank or AccountData.pkg_rank < var_104_9[#var_104_9].give_rank) then
					var_104_6 = nil
				end
			end
		end
		
		if string.starts(var_104_2.package_1, "e7_skillupspecial") and AccountData.ticketed_limits["cp:" .. var_104_2.package_1] and arg_104_0:isMuraPackageRewardComplete(var_104_2.package_1) ~= true then
			var_104_6 = nil
			
			if arg_104_0:canReceiveCustomPackageRewards(var_104_2.package_1) then
				var_104_2.sort_top = true
			end
		end
		
		if arg_104_1 and (arg_104_1 == var_104_2.package_1 or arg_104_1 == var_104_2.package_2 or arg_104_1 == var_104_2.package_3 or arg_104_1 == var_104_2.package_4) then
			var_104_6 = nil
		end
		
		local var_104_10 = 0
		
		for iter_104_4, iter_104_5 in pairs(var_104_2.items) do
			local var_104_11, var_104_12, var_104_13 = arg_104_0:GetPackageRestCount(var_104_2.items[iter_104_4])
			
			if var_104_12 and var_104_11 < 1 then
				var_104_10 = var_104_10 + 1
			end
		end
		
		var_104_2.can_buy = var_104_8 or var_104_10 < #var_104_2.items
		
		local var_104_14 = "e7_newmystic_60"
		local var_104_15 = var_104_14 == var_104_2.package_1 or var_104_14 == var_104_2.package_2 or var_104_14 == var_104_2.package_3 or var_104_14 == var_104_2.package_4
		
		if var_104_6 and not var_104_8 and not var_104_15 then
			var_104_5 = var_104_10 < #var_104_2.items
		end
		
		if var_104_5 and var_104_2.intelli_package == "v2" then
			local var_104_16 = 0
			local var_104_17 = 0
			
			for iter_104_6, iter_104_7 in pairs(var_104_2.items) do
				local var_104_18 = AccountData.package_limits["ip:" .. iter_104_7.id]
				
				if var_104_18 == nil or var_104_18.buyable_tm == nil or var_104_18.usable_tm == nil or var_104_1 > var_104_18.expire_tm or var_104_1 < var_104_18.usable_tm or var_104_1 > var_104_18.buyable_tm or to_n(var_104_18.count) >= to_n(var_104_18.max_c) then
					var_104_16 = var_104_16 + 1
				end
				
				var_104_17 = var_104_17 + 1
			end
			
			if var_104_6 and var_104_17 <= var_104_16 and not var_104_8 then
				var_104_5 = false
			end
		end
		
		if var_104_5 and var_104_2.before_package then
			local var_104_19 = string.split(var_104_2.before_package, ";")
			
			for iter_104_8, iter_104_9 in pairs(var_104_19) do
				local var_104_20 = arg_104_0:getItemById(iter_104_9)
				
				if var_104_20 then
					if string.starts(var_104_20.id, "e7_levelup") or to_n(AccountData.shop_rankpack_max[var_104_20.id]) > 0 then
						local var_104_21 = arg_104_0:GetRankupBonusList(iter_104_9)
						
						if #var_104_21 > 0 and to_n(AccountData.pkg_rank) < var_104_21[#var_104_21].give_rank then
							var_104_5 = false
						end
					else
						local var_104_22, var_104_23, var_104_24 = arg_104_0:GetPackageRestCount(var_104_20)
						
						if var_104_23 and var_104_22 > 0 then
							var_104_5 = false
						end
					end
				end
			end
		end
		
		if var_104_5 and var_104_2.intelli_package == "y" then
			for iter_104_10, iter_104_11 in pairs(var_104_2.items) do
				local var_104_25 = AccountData.package_limits["sh:" .. iter_104_11.id]
				
				if var_104_25 == nil or var_104_25.expire_tm < os.time() or to_n(var_104_25.limit_count) < 1 then
					var_104_5 = false
				end
			end
		end
		
		if var_104_5 and var_104_2.condition == "rank" and var_104_2.value then
			local var_104_26 = string.split(var_104_2.value, ",")
			local var_104_27 = Account:getLevel()
			
			if var_104_27 < to_n(var_104_26[1]) or var_104_27 > to_n(var_104_26[2] or 999) then
				var_104_5 = false
			end
		end
		
		if var_104_1 >= 1595480400 and (var_104_2.package_1 == "e7_levelup_30" or var_104_2.package_1 == "e7_levelup_50" or var_104_2.package_1 == "e7_levelup2_50") then
			local var_104_28, var_104_29, var_104_30 = arg_104_0:GetPackageRestCount(var_104_2.items[1])
			
			if to_n(var_104_28) > 0 then
				var_104_5 = false
			end
		end
		
		if var_104_2.issue_end_tm and var_104_1 > var_104_2.issue_end_tm then
			local var_104_31, var_104_32, var_104_33 = arg_104_0:GetPackageRestCount(var_104_2.items[1])
			
			if to_n(var_104_31) > 0 then
				var_104_5 = false
			end
		end
		
		if var_104_5 and var_104_7.shop_package_data and var_104_7.shop_package_data.chain_group_id then
			local var_104_34 = var_104_7.shop_package_data.chain_group_id
			
			arg_104_0.vars.chain_packages[var_104_34] = arg_104_0.vars.chain_packages[var_104_34] or {}
			
			if var_104_2.items[1].shop_package_data and var_104_2.items[1].shop_package_data.chain_group_sort then
				local var_104_35 = to_n(var_104_2.items[1].shop_package_data.chain_group_sort)
				
				arg_104_0.vars.chain_packages[var_104_34][var_104_35] = var_104_2
			end
		end
		
		if var_104_2.items[1] and var_104_2.items[1].hidden_ingame == "y" then
			var_104_5 = false
		end
		
		if var_104_5 then
			var_104_2.p_sort = var_104_2.sort
			
			if var_104_2.top_priority == "y" then
				var_104_2.p_sort = var_104_2.sort
			elseif var_104_2.sort_top then
				var_104_2.p_sort = var_104_2.sort + 10000
			elseif var_104_2.intelli_package == "y" then
				var_104_2.p_sort = var_104_2.sort + 1000000
			elseif var_104_2.intelli_package == "v2" then
				local var_104_36 = 0
				
				for iter_104_12, iter_104_13 in pairs(var_104_2.items) do
					local var_104_37 = AccountData.package_limits["ip:" .. iter_104_13.id]
					
					if var_104_37 then
						var_104_36 = math.max(to_n(var_104_37.usable_tm), var_104_36)
					end
				end
				
				var_104_2.p_sort = var_104_2.sort + 1000000 + math.min(var_104_1 - var_104_36, 8999999)
			else
				var_104_2.p_sort = var_104_2.sort + 10000000
			end
			
			if not var_104_2.can_buy then
				var_104_2.p_sort = var_104_2.sort + 100000000
			end
			
			table.push(arg_104_0.vars.categories, var_104_2)
		end
	end
	
	return arg_104_0.vars.categories
end

function ShopPromotion.createCategoryMenu(arg_105_0, arg_105_1)
	if not arg_105_0.vars or not get_cocos_refid(arg_105_0.vars.wnd) then
		return 
	end
	
	local var_105_0 = arg_105_0.vars.except_sold_out_id
	
	arg_105_0.vars.except_sold_out_id = nil
	
	local var_105_1 = {}
	
	for iter_105_0, iter_105_1 in pairs(arg_105_0.vars.categories) do
		local var_105_2 = true
		local var_105_3 = iter_105_1.sold_out == "y"
		
		if var_105_0 and (var_105_0 == iter_105_1.package_1 or var_105_0 == iter_105_1.package_2 or var_105_0 == iter_105_1.package_3 or var_105_0 == iter_105_1.package_4) then
			var_105_3 = nil
		end
		
		if iter_105_1.csd_condition == "chain" and iter_105_1.intelli_package == "v2" then
			local var_105_4 = iter_105_1.items[1].shop_package_data.chain_group_id
			
			if iter_105_1.items[1].id ~= var_105_4 then
				var_105_2 = false
			end
			
			if var_105_2 then
				local var_105_5, var_105_6 = arg_105_0:chainPackageRestCount(iter_105_1)
				
				if var_105_3 and var_105_5 < 1 then
					var_105_2 = false
				end
			end
		end
		
		if var_105_2 and iter_105_1.view_category ~= arg_105_0.vars.view_category then
			var_105_2 = false
		end
		
		if var_105_2 then
			table.push(var_105_1, iter_105_1)
		end
	end
	
	table.sort(var_105_1, function(arg_106_0, arg_106_1)
		return arg_106_0.p_sort < arg_106_1.p_sort
	end)
	
	arg_105_0.vars.category_menu_index = {}
	
	for iter_105_2, iter_105_3 in pairs(var_105_1) do
		arg_105_0.vars.category_menu_index[iter_105_2] = {
			iter_105_3.package_1,
			iter_105_3.package_2,
			iter_105_3.package_3,
			iter_105_3.package_4
		}
	end
	
	if not arg_105_1 then
		arg_105_0:createScrollViewItems(var_105_1)
	end
	
	return var_105_1
end

function ShopPromotion.createItems(arg_107_0)
	if AccountData.shop.promotion then
		arg_107_0.vars.items = table.clone(AccountData.shop.promotion)
	else
		AccountData.shop.promotion = {}
	end
	
	table.sort(arg_107_0.vars.items, function(arg_108_0, arg_108_1)
		if arg_108_0.can_buy ~= arg_108_1.can_buy then
			return arg_108_0.can_buy
		end
		
		if arg_108_0.sort == arg_108_1.sort then
			return arg_108_0.id < arg_108_1.id
		end
		
		return arg_108_0.sort < arg_108_1.sort
	end)
end

function ShopPromotion.buyitem(arg_109_0, arg_109_1, arg_109_2)
	if PLATFORM ~= "win32" and arg_109_1.token == "cash" then
		local var_109_0 = {
			shop = "promotion",
			item_id = arg_109_1.id,
			caller = arg_109_2 or "promotion"
		}
		
		if ShopPromotion:isPackagePopup() then
			var_109_0.buy_desc = "package_popup"
		end
		
		startIapBilling(var_109_0)
	elseif PLATFORM == "win32" and arg_109_1.token == "cash" then
		local var_109_1 = {
			shop = "promotion",
			caller = "promotion",
			item = arg_109_1.id,
			order_id = "test_" .. get_udid(),
			type = arg_109_1.type
		}
		
		if ShopPromotion:isPackagePopup() then
			var_109_1.buy_desc = "package_popup"
		end
		
		if arg_109_2 then
			var_109_1.caller = arg_109_2
		end
		
		query("buy", var_109_1)
	else
		local var_109_2 = {
			caller = "promotion",
			shop = "promotion",
			item = arg_109_1.id,
			type = arg_109_1.type
		}
		
		if ShopPromotion:isPackagePopup() then
			var_109_2.buy_desc = "package_popup"
		end
		
		if arg_109_2 then
			var_109_2.caller = arg_109_2
		end
		
		query("buy", var_109_2)
	end
end

function ShopPromotion.confirmDialog(arg_110_0, arg_110_1, arg_110_2)
	if string.starts(arg_110_1.type, "e") then
		local var_110_0 = DB("equip_item", arg_110_1.type, {
			"type"
		})
		
		if var_110_0 then
			if var_110_0 == "artifact" then
				if not UIUtil:checkArtifactInven() then
					return 
				end
			elseif not UIUtil:checkEquipInven() then
				return 
			end
		end
	end
	
	if string.starts(arg_110_1.type, "c") and not UIUtil:checkUnitInven() then
		return 
	end
	
	local var_110_1
	local var_110_2
	local var_110_3 = arg_110_0:getPackageHeroSelectID(arg_110_1.id)
	local var_110_4 = arg_110_0:getCustomSelectPackageID(arg_110_1.id)
	
	if var_110_3 then
		local var_110_5 = Account:getUserConfigs("hs:" .. arg_110_1.id)
		
		if var_110_5 then
			var_110_1 = load_dlg("shop_popup_purchase2", true, "wnd")
			var_110_2 = var_110_1:getChildByName("cm_box")
			
			local var_110_6 = var_110_2:getChildByName("n_hero_sel")
			
			var_110_6:setVisible(true)
			
			local var_110_7 = DB("item_special", var_110_3, {
				"name"
			})
			
			if_set(var_110_6, "txt_hero_sel", T(var_110_7))
			
			local var_110_8
			
			if DB("character", var_110_5, "id") then
				var_110_8 = var_110_6:getChildByName("mob_icon")
			else
				var_110_8 = var_110_6:getChildByName("item_art_icon")
			end
			
			UIUtil:getRewardIcon("c", var_110_5, {
				no_popup = true,
				name = false,
				show_color = true,
				role = true,
				no_tooltip = true,
				scale = 1,
				parent = var_110_8
			})
		else
			if arg_110_0.vars.current_category.csd_condition == "artifact_select" then
				balloon_message_with_sound("err_package_selection_required_artifact")
			else
				balloon_message_with_sound("err_package_selection_required")
			end
			
			return 
		end
	elseif var_110_4 then
		local var_110_9 = Account:getUserConfigs("cp:" .. arg_110_1.id)
		local var_110_10 = arg_110_0.vars.current_category.items[1]
		local var_110_11 = 0
		
		if var_110_9 and var_110_10 and var_110_10.custom_items then
			local var_110_12 = json.decode(var_110_9)
			
			for iter_110_0, iter_110_1 in pairs(var_110_12) do
				for iter_110_2, iter_110_3 in pairs(var_110_10.custom_items[iter_110_0] or {}) do
					if iter_110_3.id == iter_110_1 then
						var_110_11 = var_110_11 + 1
					end
				end
			end
		end
		
		if var_110_11 > 0 then
			var_110_1 = load_dlg("shop_popup_purchase", true, "wnd")
			var_110_2 = var_110_1:getChildByName("cm_box")
		else
			balloon_message_with_sound("err_package_selection_required_itemslot_1")
			
			return 
		end
	else
		var_110_1 = load_dlg("shop_popup_purchase", true, "wnd")
		var_110_2 = var_110_1:getChildByName("cm_box")
	end
	
	if arg_110_1.token == "cash" and getUserLanguage() == "ja" then
		if_set_visible(var_110_2, "n_jpn_only", true)
		
		local var_110_13 = var_110_2:getChildByName("n_jpn_only_buttons")
		local var_110_14 = load_control("wnd/jpn_only_node.csb")
		
		var_110_13:addChild(var_110_14)
	else
		if_set_visible(var_110_2, "n_jpn_only", false)
	end
	
	local var_110_15 = var_110_1:getChildByName("n_add_info")
	local var_110_16 = 0
	
	if ShopCommon:setupRateInfoUI(var_110_1, arg_110_1) then
		var_110_16 = var_110_16 + 1
	end
	
	if_set_visible(var_110_1, "n_caution", false)
	
	if arg_110_1.token == "cash" and arg_110_1.category == "promotion" and getUserLanguage() == "ko" then
		var_110_16 = var_110_16 + 1
		
		if var_110_16 < 2 then
			var_110_1:getChildByName("n_caution"):setPositionY(var_110_15:getPositionY())
		end
		
		UIAction:Add(SEQ(SHOW(true), LOG(SCALE(150, 0, 1.1)), DELAY(50), RLOG(SCALE(80, 1.1, 1))), var_110_1:getChildByName("n_caution"))
	end
	
	var_110_15:setVisible(var_110_16 > 0)
	
	local var_110_17 = var_110_1:getChildByName("CENTER")
	local var_110_18 = var_110_1:getChildByName("move_center")
	
	if get_cocos_refid(var_110_18) and get_cocos_refid(var_110_17) and var_110_16 == 0 then
		var_110_17:setPositionY(var_110_18:getPositionY())
		if_set_visible(var_110_1, "_grow", false)
		if_set_visible(var_110_1, "btn_block2", false)
		if_set_visible(var_110_1, "txt_close", true)
	end
	
	Dialog:msgBox({
		yesno = true,
		dlg = var_110_1,
		handler = arg_110_2
	})
	
	local var_110_19 = var_110_1:getChildByName("n_caution")
	
	if_set(var_110_19, "label", T("buy_cancel.subscription_detail"))
	
	if IS_ANDROID_BASED_PLATFORM and getUserLanguage() == "ko" then
		if_set(var_110_19, "t_disc", T("buy_cancel.subscription_desc_short_playpoint"))
	else
		if_set(var_110_19, "t_disc", T("buy_cancel.subscription_desc_short"))
	end
	
	if_set(var_110_1, "txt_shop_type", UIUtil:getRewardTitle(arg_110_1.type))
	ShopCommon:SetItemIcon(arg_110_1, var_110_1)
	ShopCommon:UpdatePayIcon(var_110_1, arg_110_1)
	
	if arg_110_1.rest_count then
		if_set(var_110_1, "txt_restcount", T("shop_rest_count", {
			count = arg_110_1.rest_count
		}))
	else
		if_set_visible(var_110_1, "txt_restcount", false)
	end
	
	return var_110_1
end

function ShopPromotion.reqBuy(arg_111_0, arg_111_1, arg_111_2)
	if arg_111_0.vars and arg_111_0.vars.category_packages then
		local var_111_0, var_111_1, var_111_2 = arg_111_0:GetPackageRestCount(arg_111_1)
		local var_111_3 = arg_111_0.vars.category_packages[arg_111_1.id]
		
		if var_111_3 and not (not var_111_1 or var_111_0 >= 1) then
			local var_111_5
			
			if var_111_3.csd_condition == "chain" and var_111_3.intelli_package == "v2" then
				local var_111_4 = arg_111_1.shop_package_data.chain_group_id
				
				var_111_5 = to_n(arg_111_1.shop_package_data.chain_group_sort)
				
				for iter_111_0, iter_111_1 in pairs(arg_111_0.vars.chain_packages[var_111_4]) do
					if to_n(iter_111_1.items[1].shop_package_data.chain_group_sort) == var_111_5 - 1 then
						Dialog:msgBox(T("buy_not_allowed_relaypack", {
							pre_relaypack = T(iter_111_1.items[1].name),
							relaypack = T(arg_111_1.name)
						}))
						
						break
					end
				end
			end
			
			return 
		end
	end
	
	if ContentDisable:byAlias("package_purchase") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if arg_111_1.token == "cash" and Account:isJPN() and getUserLanguage() == "ja" and StoveIap and StoveIap:getProductInfo(arg_111_1.id) and StoveIap:getProductInfo(arg_111_1.id).priceCurrencyCode == "JPY" then
		if to_n(AccountData.birthday) == 0 then
			ShopBuyAgeBase:show(SceneManager:getRunningPopupScene())
			
			return 
		end
		
		local var_111_6 = to_n(StoveIap:getProductInfo(arg_111_1.id).price)
		
		if var_111_6 > 0 and AccountData.birthday_limit and to_n(AccountData.birthday_limit.limit) > 0 and AccountData.birthday_limit.current + var_111_6 > AccountData.birthday_limit.limit then
			Dialog:msgBox(T("jpn_payment_error_desc"), {
				title = T("jpn_payment_error_title")
			})
			
			return 
		end
	end
	
	if arg_111_1.promotion_list and string.starts(arg_111_1.promotion_list, "monthly_") then
		local var_111_7 = to_n(string.sub(arg_111_1.promotion_list, -1, -1))
		local var_111_8 = ShopPromotion:GetRestMonthlyDays(var_111_7)
		local var_111_9 = GAME_STATIC_VARIABLE.max_daily_package or 50
		
		if var_111_9 <= to_n(var_111_8) then
			balloon_message_with_sound("event_package_daily_limit", {
				max = var_111_9
			})
			
			return 
		end
	end
	
	if arg_111_1.token == "cash" and Stove.enable and StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_PROBLEM) and StoveIap.vars.problem_code == 40010 then
		Stove:openAppleStoreTireErrorFAQ()
		Log.e("shopPopupBuy : " .. (StoveIap.vars.problem_message or ""))
		balloon_message(StoveIap.vars.problem_message or "")
		
		return 
	end
	
	local var_111_10 = arg_111_0:confirmDialog(arg_111_1, function(arg_112_0, arg_112_1)
		if arg_112_1 == "btn_detail" then
			ShopCommon:showEULA()
			
			return "dont_close"
		elseif string.starts(arg_112_1, "btn_rate") then
			local var_112_0 = string.split(arg_112_1, ":")
			
			if arg_111_1 and string.len(var_112_0[2] or "") > 0 then
				if arg_111_1.random_list == "stove_equip_option" then
					Stove:openEquipPackageRenewalRateInfo()
				elseif arg_111_1.id == "e7_equip_30" or arg_111_1.id == "e7_equip_50" or arg_111_1.id == "e7_int_equip_10" then
					Stove:openEquipGachaRateInfo()
				elseif arg_111_1.random_list == "ma_guer_eq85_select" or arg_111_1.random_list == "ma_guer_eq70_select" then
					Stove:openGuerrillaRateInfo()
				elseif var_112_0[2] == "rate_open" then
					if_set_visible(arg_112_0, "n_btn_rate_list", true)
				else
					if_set_visible(arg_112_0, "n_btn_rate_list", false)
					
					if var_112_0[3] == "randombox" then
						query("randombox_rate_info", {
							item = var_112_0[2]
						})
					else
						query("gacha_rate_info", {
							item = var_112_0[2]
						})
					end
				end
			end
			
			return "dont_close"
		elseif arg_112_1 == "btn_buy" then
			print("reqBuy item.id : ", arg_111_1.id, arg_111_1.token, "promotion")
			
			local var_112_1
			
			if IS_PUBLISHER_ZLONG then
				local var_112_2 = getIapProductInfo(arg_111_1.id)
				
				if var_112_2 and var_112_2.goods_register_id and string.len(tostring(var_112_2.goods_register_id)) > 0 then
					var_112_1 = var_112_2.goods_register_id
				end
				
				if not var_112_1 and not PRODUCTION_MODE and PLATFORM == "win32" then
					var_112_1 = "test_purchase"
				end
			end
			
			if arg_111_1.coupon_data and Account:getItemCount(arg_111_1.coupon_data) > 0 and var_112_1 then
				UIAction:Add(SEQ(DELAY(200), CALL(function()
					ShopCommon:couponBuyConfirm(arg_111_1, function(arg_114_0, arg_114_1, arg_114_2)
						if arg_114_1 == "btn_buy" then
							arg_111_0:buyitem(arg_111_1, arg_111_2)
						elseif arg_114_1 == "btn_buy_coupon_zl" then
							local var_114_0 = {
								use_coupon = true,
								shop = "promotion",
								caller = "promotion",
								item = arg_111_1.id,
								type = arg_111_1.type,
								zl_grid = var_112_1
							}
							
							if ShopPromotion:isPackagePopup() then
								var_114_0.buy_desc = "package_popup"
							end
							
							if arg_111_2 then
								var_114_0.caller = arg_111_2
							end
							
							query("buy", var_114_0)
						elseif arg_114_1 == "btn_close" then
						else
							return "dont_close"
						end
					end)
				end)), arg_111_0, "block")
				
				return 
			else
				arg_111_0:buyitem(arg_111_1, arg_111_2)
			end
		elseif arg_112_1 == "btn_close" then
		else
			return "dont_close"
		end
	end)
	
	if not var_111_10 then
		return 
	end
	
	local var_111_11
	local var_111_12, var_111_13, var_111_14 = arg_111_0:GetPackageRestCount(arg_111_1)
	local var_111_15, var_111_16, var_111_17, var_111_18 = DB("shop_package_bonus", arg_111_1.id, {
		"item_id",
		"bonus_item_condition",
		"bonus_item_value",
		"ui_desc"
	})
	
	if var_111_15 and var_111_12 > var_111_13 - var_111_17 then
		var_111_11 = var_111_10:getChildByName("n_add")
		
		UIUtil:getRewardIcon(nil, var_111_15, {
			no_popup = true,
			name = false,
			no_tooltip = true,
			no_bg = true,
			scale = 1,
			parent = var_111_11:getChildByName("n_icon")
		})
		
		local var_111_19 = var_111_11:getChildByName("txt_provide")
		local var_111_20 = var_111_11:getChildByName("txt_info")
		local var_111_21 = UIUtil:setTextAndReturnHeight(var_111_20, T(var_111_18))
		
		var_111_19:setPositionY(var_111_20:getPositionY() + var_111_21 / 2 + 11)
	else
		var_111_11 = var_111_10:getChildByName("n_basic")
	end
	
	if get_cocos_refid(var_111_11) then
		var_111_11:setVisible(true)
		
		if arg_111_1.type == "gacha_start" then
			if_set(var_111_11, "txt_desc", T("sp_gacha_start_de"))
		elseif string.starts(arg_111_1.type, "gacha_story") then
			if_set(var_111_11, "txt_desc", T(arg_111_1.desc))
		else
			local var_111_22 = DB("item_special", arg_111_1.type, {
				"desc"
			})
			
			if_set(var_111_11, "txt_desc", T(arg_111_1.desc or var_111_22))
		end
	end
end

function ShopPromotion.onMsgBuy(arg_115_0, arg_115_1, arg_115_2)
	for iter_115_0, iter_115_1 in pairs(arg_115_1) do
		if string.starts(iter_115_0, "pkg_") then
			AccountData[iter_115_0] = iter_115_1
		end
	end
	
	local var_115_0 = ShopPromotion:getPackageData(arg_115_1.item)
	
	if arg_115_0.vars and var_115_0 and var_115_0.promotion_list and string.starts(var_115_0.promotion_list, "monthly_") then
		arg_115_0.vars.check_monthly_item = true
	end
	
	if arg_115_0.vars and not arg_115_0.vars.popup_mode then
		arg_115_0:createCategories(arg_115_1.item)
		arg_115_0:createCategoryMenu()
	elseif SceneManager:getCurrentSceneName() == "lobby" then
		TopBarNew:closeEventPackageNotification()
		TopBarNew:checkPackageNotifications()
	end
	
	arg_115_0:updateMainPage()
	Lobby:checkMail(true)
	
	local var_115_1 = {
		{
			count = 1,
			code = var_115_0.type
		}
	}
	local var_115_2 = T("package_success_desc", {
		package_name = T(var_115_0.name)
	})
	
	if var_115_0.type == "gacha_start" then
		arg_115_0:popupResultGachaDashPackage(true, var_115_0)
	elseif string.starts(var_115_0.type, "gacha_story") then
		arg_115_0:popupResultGachaDashPackage(true, var_115_0)
	elseif string.starts(var_115_0.type, "gacha_spdash") then
		arg_115_0:popupResultGachaDashPackage(true, var_115_0)
	else
		local var_115_3
		
		if SceneManager:getCurrentSceneName() == "gacha_unit" then
			function var_115_3()
				ShopPromotion:close()
			end
		elseif SceneManager:getCurrentSceneName() == "shop" then
			if arg_115_0:getPackageHeroSelectID(arg_115_1.item) and arg_115_1.rewards then
				local var_115_4
				
				if arg_115_1.rewards.new_coins then
					var_115_4 = arg_115_1.rewards.new_coins[1]
				end
				
				local var_115_5
				
				if arg_115_1.rewards.new_units then
					var_115_5 = arg_115_1.rewards.new_units[1].code
				elseif arg_115_1.rewards.new_equips then
					var_115_5 = arg_115_1.rewards.new_equips[1].code
				end
				
				function var_115_3()
					GachaUnit:external_summon(var_115_5, 0, nil, var_115_4, SceneManager:getRunningPopupScene())
				end
			end
			
			if arg_115_0:getCustomSelectPackageID(arg_115_1.item) and arg_115_1.custom_package_selected_items then
				var_115_2 = T("custom_package_success_desc", {
					package_name = T(var_115_0.name)
				})
				var_115_1 = arg_115_2.re_popup
				
				table.insert(var_115_1, {
					count = 1,
					code = var_115_0.type
				})
			end
		end
		
		Dialog:msgRewards(var_115_2, {
			rewards = var_115_1,
			handler = var_115_3
		})
	end
end

function ShopPromotion.popupResultGachaDashPackage(arg_118_0, arg_118_1, arg_118_2)
	local var_118_0 = load_dlg("shop_buy_dash_result", true, "wnd")
	
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		layer = var_118_0:getChildByName("n_eff")
	})
	if_set_visible(var_118_0, "btn_close", true)
	
	if arg_118_1 then
		if_set_visible(var_118_0, "n_btn", true)
		if_set_visible(var_118_0, "n_below", false)
		if_set_visible(var_118_0, "btn_ignore", true)
	else
		if_set_visible(var_118_0, "n_btn", false)
		if_set_visible(var_118_0, "n_below", true)
		if_set_visible(var_118_0, "btn_ignore", false)
	end
	
	local var_118_1 = var_118_0:getChildByName("n_top")
	
	if_set(var_118_1, "txt_title", T("buy_gacha_story_title", {
		package_name = T(arg_118_2.name)
	}))
	
	if arg_118_2.type == "gacha_story_ep999" then
		if_set(var_118_1, "info", T("buy_gacha_festival_desc"))
	else
		if_set(var_118_1, "info", T("buy_gacha_story_desc", {
			package_name = T(arg_118_2.name)
		}))
	end
	
	local var_118_2
	
	if arg_118_2.type == "gacha_start" then
		var_118_2 = "gacha_start"
	elseif string.starts(arg_118_2.type, "gacha_story") or arg_118_2.type == "gacha_spdash" then
		var_118_2 = "gacha_story:" .. arg_118_2.type
	end
	
	Dialog:msgBox("", {
		dlg = var_118_0,
		yesno = arg_118_1,
		handler = function(arg_119_0, arg_119_1, arg_119_2)
			if arg_119_1 == "btn_close" then
			elseif arg_118_1 and arg_119_1 == "btn_confirm" then
				SceneManager:nextScene("gacha_unit", {
					gacha_mode = var_118_2
				})
			elseif arg_118_1 and arg_119_1 == "btn_ignore" then
				return "dont_close"
			elseif arg_118_1 and arg_119_1 == "btn_block" then
				return "dont_close"
			end
		end
	})
end

function ShopPromotion.getItemById(arg_120_0, arg_120_1)
	if arg_120_0.vars and arg_120_0.vars.items then
		for iter_120_0, iter_120_1 in pairs(arg_120_0.vars.items) do
			if iter_120_1.id == arg_120_1 then
				return iter_120_1
			end
		end
	end
end

function ShopPromotion.CanReceiveDailyPackage(arg_121_0)
	local var_121_0, var_121_1 = Account:serverTimeDayLocalDetail()
	
	for iter_121_0 = 1, 2 do
		local var_121_2 = to_n(AccountData[string.format("pkg_daily%d", iter_121_0)])
		local var_121_3 = AccountData[string.format("pkg_daily%d_e", iter_121_0)]
		
		if var_121_3 and var_121_1 <= var_121_3 and var_121_1 > to_n(var_121_2) then
			return true
		end
	end
	
	for iter_121_1, iter_121_2 in pairs(AccountData.ticketed_limits) do
		if string.split(iter_121_1, ":")[1] == "dp" and var_121_1 <= iter_121_2.expire_tm and var_121_1 >= iter_121_2.buyable_tm and to_n(iter_121_2.max_c) > to_n(iter_121_2.count) then
			return true
		end
	end
	
	return false
end

function ShopPromotion.GetPackageRestCount(arg_122_0, arg_122_1)
	local var_122_0 = arg_122_1.limit_count
	local var_122_1 = arg_122_1.limit_period
	local var_122_2 = var_122_0
	
	if AccountData.package_limits and var_122_0 then
		local var_122_3 = AccountData.package_limits["sh:" .. arg_122_1.id]
		
		if var_122_3 then
			local var_122_4 = var_122_3.expire_tm
			
			if var_122_1 == "package_expire_day" and var_122_4 >= var_122_3.start_time then
				var_122_4 = var_122_3.end_time
			end
			
			if var_122_4 >= os.time() then
				var_122_2 = var_122_0 - var_122_3.count
			end
		end
		
		local var_122_5 = AccountData.package_limits["ip:" .. arg_122_1.id]
		
		if var_122_5 then
			var_122_1 = "intelli"
			var_122_0 = to_n(var_122_5.max_c)
			
			if to_n(var_122_5.buyable_tm) >= os.time() then
				var_122_2 = var_122_0 - var_122_5.count
			end
		else
			local var_122_6 = arg_122_0:getPackageData(arg_122_1.id)
			
			if not var_122_6 or var_122_6.intelli_option then
				return 0, 0, nil
			end
		end
	end
	
	return var_122_2, var_122_0, var_122_1
end

function ShopPromotion.getPackageData(arg_123_0, arg_123_1)
	if not AccountData.shop or not AccountData.shop.promotion then
		return nil
	end
	
	for iter_123_0, iter_123_1 in pairs(AccountData.shop.promotion) do
		if iter_123_1.id == arg_123_1 then
			return iter_123_1
		end
	end
	
	return nil
end

function ShopPromotion.getPackageRestCountByPackageId(arg_124_0, arg_124_1)
	local var_124_0 = arg_124_0:getPackageData(arg_124_1)
	
	if not var_124_0 then
		return 0, 0, nil
	end
	
	return arg_124_0:GetPackageRestCount(var_124_0)
end

function ShopPromotion.GetRankupBonusList(arg_125_0, arg_125_1)
	if not arg_125_1 then
		return nil
	end
	
	local var_125_0
	
	for iter_125_0, iter_125_1 in pairs(AccountData.shop.promotion) do
		if iter_125_1.id == arg_125_1 then
			var_125_0 = iter_125_1.promotion_list
			
			break
		end
	end
	
	local var_125_1 = {}
	
	if var_125_0 then
		for iter_125_2 = 1, 99 do
			local var_125_2 = SLOW_DB_ALL("shop_promotion_list", string.format("%s_%d", var_125_0, iter_125_2))
			
			if not var_125_2 or not var_125_2.id then
				break
			end
			
			table.push(var_125_1, var_125_2)
		end
	end
	
	return var_125_1
end

function ShopPromotion.getShopPromotionNameByPackageId(arg_126_0, arg_126_1)
	for iter_126_0 = 1, 9999 do
		local var_126_0, var_126_1, var_126_2, var_126_3, var_126_4, var_126_5 = DBN("shop_promotion_category", iter_126_0, {
			"id",
			"name",
			"package_1",
			"package_2",
			"package_3",
			"package_4"
		})
		
		if not var_126_0 then
			return nil
		end
		
		if arg_126_1 == var_126_2 or arg_126_1 == var_126_3 or arg_126_1 == var_126_4 or arg_126_1 == var_126_5 then
			return var_126_1
		end
	end
end

function ShopPromotion.getShopPromotionDataByPackageId(arg_127_0, arg_127_1)
	for iter_127_0 = 1, 9999 do
		local var_127_0 = {}
		
		var_127_0.id, var_127_0.name, var_127_0.icon, var_127_0.sort, var_127_0.bg_image, var_127_0.bg_image_info, var_127_0.sold_out, var_127_0.before_package, var_127_0.package_1, var_127_0.package_2, var_127_0.package_3, var_127_0.package_4, var_127_0.time_visible, var_127_0.condition, var_127_0.value, var_127_0.tag, var_127_0.add_promotion, var_127_0.intelli_package, var_127_0.buy_time, var_127_0.csd_condition, var_127_0.view_category = DBN("shop_promotion_category", iter_127_0, {
			"id",
			"name",
			"icon",
			"sort",
			"bg_image",
			"bg_image_info",
			"sold_out",
			"before_package",
			"package_1",
			"package_2",
			"package_3",
			"package_4",
			"time_visible",
			"condition",
			"value",
			"tag",
			"add_promotion",
			"intelli_package",
			"buy_time",
			"csd_condition",
			"view_category"
		})
		
		if not var_127_0.id then
			return nil
		end
		
		if arg_127_1 == var_127_0.package_1 or arg_127_1 == var_127_0.package_2 or arg_127_1 == var_127_0.package_3 or arg_127_1 == var_127_0.package_4 then
			return var_127_0
		end
	end
end

function ShopPromotion.popupGachaPromotionPackages(arg_128_0, arg_128_1)
	if SceneManager:getCurrentSceneName() ~= "gacha_unit" then
		return false
	end
	
	if getenv("zlong.restrict_shop", "false") == "true" then
		balloon_message(T("need_token"))
		
		return true
	end
	
	if not Shop.ready then
		query("market", {
			caller = "package_gacha"
		})
		
		return false
	end
	
	if arg_128_1 == "ticketrare" then
		local var_128_0 = 0
		local var_128_1, var_128_2, var_128_3 = arg_128_0:getPackageRestCountByPackageId("e7_limited_30")
		local var_128_4 = var_128_0 + to_n(var_128_1)
		local var_128_5, var_128_6, var_128_7 = arg_128_0:getPackageRestCountByPackageId("e7_limited_60")
		
		if var_128_4 + to_n(var_128_5) > 0 then
			Dialog:closeAll()
			arg_128_0:showPopup({
				"e7_limited_60"
			}, "gacha_rare.popup")
			
			return true
		end
	elseif arg_128_1 == "ticketspecial" then
		local var_128_8 = 1645671600
		local var_128_9 = Account:getGachaShopInfo()
		
		if var_128_9 and var_128_9.gacha_special and var_128_9.gacha_special.current then
			local var_128_10 = var_128_9.gacha_special.current
			
			if var_128_10.gs4_unlock_tm then
				var_128_8 = to_n(var_128_10.gs4_unlock_tm)
			end
		end
		
		if var_128_8 <= os.time() then
			local var_128_11 = 0
			local var_128_12, var_128_13, var_128_14 = arg_128_0:getPackageRestCountByPackageId("e7_newmystic_10")
			local var_128_15 = var_128_11 + to_n(var_128_12)
			local var_128_16, var_128_17, var_128_18 = arg_128_0:getPackageRestCountByPackageId("e7_newmystic_30")
			local var_128_19 = var_128_15 + to_n(var_128_16)
			local var_128_20, var_128_21, var_128_22 = arg_128_0:getPackageRestCountByPackageId("e7_newmystic_50")
			local var_128_23 = var_128_19 + to_n(var_128_20)
			local var_128_24, var_128_25, var_128_26 = arg_128_0:getPackageRestCountByPackageId("e7_newmystic_60")
			
			if var_128_23 + to_n(var_128_24) > 0 then
				Dialog:closeAll()
				arg_128_0:showPopup({
					"e7_newmystic_60"
				}, "gacha_special.popup")
				
				return true
			end
		else
			local var_128_27 = 0
			local var_128_28, var_128_29, var_128_30 = arg_128_0:getPackageRestCountByPackageId("e7_mystic_10")
			local var_128_31 = var_128_27 + to_n(var_128_28)
			local var_128_32, var_128_33, var_128_34 = arg_128_0:getPackageRestCountByPackageId("e7_mystic_30")
			local var_128_35 = var_128_31 + to_n(var_128_32)
			local var_128_36, var_128_37, var_128_38 = arg_128_0:getPackageRestCountByPackageId("e7_mystic_50")
			local var_128_39 = var_128_35 + to_n(var_128_36)
			local var_128_40, var_128_41, var_128_42 = arg_128_0:getPackageRestCountByPackageId("e7_mystic_60")
			
			if var_128_39 + to_n(var_128_40) > 0 then
				Dialog:closeAll()
				arg_128_0:showPopup({
					"e7_mystic_60"
				}, "gacha_special.popup")
				
				return true
			end
		end
	end
	
	return false
end

function ShopPromotion.popupLobbyPackageLimits(arg_129_0, arg_129_1, arg_129_2)
	local var_129_0 = arg_129_1 or {}
	local var_129_1
	
	var_129_1 = arg_129_2 or 0
	
	local var_129_2 = os.time()
	local var_129_3 = Account:serverTimeDayLocalDetail()
	local var_129_4 = {}
	
	for iter_129_0, iter_129_1 in pairs(AccountData.package_limits or {}) do
		local var_129_5 = string.split(iter_129_0, ":")
		local var_129_6 = 0
		local var_129_7 = 0
		local var_129_8 = 0
		
		if iter_129_1.limit_count and var_129_2 <= iter_129_1.end_time and var_129_2 > iter_129_1.start_time then
			var_129_6 = iter_129_1.limit_count - iter_129_1.count
			var_129_7 = iter_129_1.limit_count
			var_129_8 = Account:serverTimeDayLocalDetail(iter_129_1.end_time) - var_129_3
		end
		
		local var_129_9 = var_129_5[1] == "ip"
		local var_129_10 = var_129_5[2]
		local var_129_11 = tostring(iter_129_1.pcid)
		local var_129_12 = tostring(iter_129_1.lobby_popup)
		
		if var_129_12 == "y" then
			var_129_12 = "only_once"
		end
		
		if not var_129_9 and var_129_12 == "intelli" then
			var_129_12 = "none"
		end
		
		local var_129_13 = iter_129_1.sort
		local var_129_14 = to_n(iter_129_1.start_time)
		local var_129_15 = to_n(iter_129_1.end_time)
		
		if var_129_10 and var_129_6 > 0 and var_129_8 <= 30 and var_129_13 and string.len(var_129_12) > 0 and var_129_12 ~= "none" and var_129_14 < var_129_2 and var_129_2 < var_129_15 then
			local var_129_16 = true
			
			if var_129_12 == "expire_day_7" and var_129_15 - os.time() > 604800 then
				var_129_16 = false
			end
			
			if var_129_16 then
				if var_129_9 then
					var_129_13 = 1000 + to_n(var_129_13)
				else
					var_129_13 = 2000 + to_n(var_129_13)
				end
				
				if not var_129_4[var_129_11] then
					var_129_4[var_129_11] = {
						pid = {
							var_129_10
						},
						pcid = var_129_11,
						st = var_129_14,
						et = var_129_15,
						vt = to_n((var_129_0[var_129_11] or {}).vt),
						lp = var_129_12,
						sr = to_n(var_129_13),
						cnt = var_129_6,
						max = var_129_7
					}
				else
					table.push(var_129_4[var_129_11].pid, var_129_10)
					
					var_129_4[var_129_11].cnt = (var_129_4[var_129_11].cnt or 0) + var_129_6
					var_129_4[var_129_11].max = (var_129_4[var_129_11].max or 0) + var_129_7
				end
			end
		end
	end
	
	for iter_129_2, iter_129_3 in pairs(var_129_4) do
		local var_129_17 = false
		
		if to_n((var_129_0[iter_129_2] or {}).max) ~= iter_129_3.max and iter_129_3.pid and iter_129_3.pid[1] then
			local var_129_18 = ShopPromotion:getPackageData(iter_129_3.pid[1])
			
			if var_129_18 and var_129_18.intelli_option then
				var_129_17 = true
			end
		end
		
		if not var_129_17 and iter_129_3.lp == "day" and Account:serverTimeDayLocalDetail(iter_129_3.vt) ~= var_129_3 then
			var_129_17 = true
		end
		
		if not var_129_17 and iter_129_3.lp == "only_once" and Account:serverTimeDayLocalDetail(iter_129_3.vt) ~= var_129_3 and var_129_2 > to_n(iter_129_3.et) - 86400 then
			var_129_17 = true
		end
		
		if var_129_17 then
			iter_129_3.vt = 0
		end
	end
	
	return var_129_4
end

function ShopPromotion.resetPopupData(arg_130_0)
	SAVE:setUserDefaultData("promotion_remain_last_day", 0)
	SAVE:setUserDefaultData("red_dot_promotion", 0)
	SAVE:setUserDefaultData("intelli_v2", json.encode({}))
	SAVE:setTempConfigData("pppackage", json.encode({}))
end

function ShopPromotion.isShowCheckReturnUserPackage(arg_131_0)
	local var_131_0 = Account:getEventTicket("7days_return")
	
	if var_131_0 and to_n(var_131_0.issued_tm) > 0 and os.time() < to_n(var_131_0.issued_tm) + 86400 then
		return false
	end
	
	return true
end

function ShopPromotion.popupLobbyPromotionPackages(arg_132_0)
	if arg_132_0:isShowCheckReturnUserPackage() ~= true then
		return 
	end
	
	local var_132_0 = os.time()
	local var_132_1 = Account:serverTimeDayLocalDetail()
	local var_132_2 = json.decode(Account:getConfigData("pppackage") or "{}")
	
	for iter_132_0, iter_132_1 in pairs(var_132_2) do
		if iter_132_0 ~= "rdp" and var_132_0 < to_n(iter_132_1.et) then
			var_132_2[iter_132_0] = iter_132_1
		end
	end
	
	local var_132_3 = var_132_2.rdp or 0
	
	var_132_2.p = nil
	var_132_2.pv, var_132_2.rdp = arg_132_0:popupLobbyPackageLimits(var_132_2.pv, var_132_3), var_132_0
	
	local var_132_4 = {}
	
	for iter_132_2, iter_132_3 in pairs(var_132_2.pv) do
		table.push(var_132_4, iter_132_3)
	end
	
	table.sort(var_132_4, function(arg_133_0, arg_133_1)
		return arg_133_0.sr < arg_133_1.sr
	end)
	
	local var_132_5 = {}
	local var_132_6 = 0
	
	for iter_132_4, iter_132_5 in pairs(var_132_4) do
		if var_132_6 >= 5 then
			break
		end
		
		if iter_132_5.pid and to_n(iter_132_5.vt) == 0 then
			iter_132_5.vt = var_132_0
			var_132_6 = var_132_6 + 1
			
			table.push(var_132_5, iter_132_5.pid[1])
		end
	end
	
	SAVE:setTempConfigData("pppackage", json.encode(var_132_2))
	
	if var_132_6 > 0 then
		if Account:getLevel() < 9 then
			SAVE:sendQueryServerConfig()
		else
			arg_132_0:showPopup(var_132_5)
			
			return true
		end
	end
end

function ShopPromotion.getNewPromotionPackage(arg_134_0)
	local var_134_0 = os.time()
	local var_134_1 = Account:serverTimeDayLocalDetail()
	local var_134_2 = SAVE:getUserDefaultData("red_dot_promotion", 0)
	local var_134_3 = SAVE:getUserDefaultData("promotion_remain_last_day", 0)
	local var_134_4 = json.decode(SAVE:getUserDefaultData("intelli_v2", "{}"))
	local var_134_5 = {}
	local var_134_6
	local var_134_7 = 0
	local var_134_8
	local var_134_9 = 0
	local var_134_10
	local var_134_11 = math.huge
	local var_134_12 = 0
	
	for iter_134_0, iter_134_1 in pairs(AccountData.package_limits or {}) do
		local var_134_13 = string.split(iter_134_0, ":")
		local var_134_14 = 0
		local var_134_15 = 0
		
		if iter_134_1.limit_count and var_134_0 <= iter_134_1.end_time and var_134_0 > iter_134_1.start_time then
			var_134_14 = iter_134_1.limit_count - iter_134_1.count
			
			local var_134_16 = Account:serverTimeDayLocalDetail(iter_134_1.end_time) - var_134_1
		end
		
		local var_134_17 = var_134_13[1]
		local var_134_18 = var_134_13[2]
		
		if var_134_18 and var_134_14 > 0 and iter_134_1.sort then
			if not string.starts(var_134_18, "e7_levelup") and not (to_n(AccountData.shop_rankpack_max[var_134_18]) > 0) then
				var_134_7 = math.max(var_134_7, to_n(iter_134_1.start_time))
				
				if var_134_2 < var_134_7 and var_134_7 == to_n(iter_134_1.start_time) then
					var_134_12 = var_134_12 + 1
					
					if iter_134_1.lobby_balloon ~= "y" then
					end
					
					if var_134_6 == nil or var_134_6 and to_n(iter_134_1.sort) < to_n(var_134_6.pkg_data.sort) then
						var_134_6 = {
							option = "new",
							package_id = var_134_18,
							pkg_type = var_134_17,
							pkg_data = iter_134_1
						}
					end
				end
			end
			
			local var_134_19 = Account:serverTimeDayLocalDetail(iter_134_1.end_time)
			
			if var_134_3 ~= var_134_1 and var_134_19 - var_134_1 <= 3 and to_n(iter_134_1.start_time) + 86400 <= to_n(iter_134_1.end_time) then
				var_134_11 = math.min(var_134_11, iter_134_1.end_time)
				
				if var_134_11 == to_n(iter_134_1.end_time) then
					var_134_10 = {
						option = "remain",
						package_id = var_134_18,
						pkg_type = var_134_17,
						pkg_data = iter_134_1
					}
				end
			end
			
			if var_134_17 == "ip" and not (to_n(AccountData.shop_rankpack_max[var_134_18]) > 0) and not string.starts(var_134_18, "e7_levelup") then
				var_134_5[var_134_18] = {
					start_time = iter_134_1.start_time,
					end_time = iter_134_1.end_time,
					max_c = iter_134_1.max_c
				}
				
				local var_134_20 = var_134_4[var_134_18] or {}
				
				if to_n(var_134_5[var_134_18].start_time) > to_n(var_134_20.start_time) then
					var_134_9 = math.max(var_134_9, to_n(iter_134_1.start_time))
					
					if var_134_9 == to_n(iter_134_1.start_time) then
						var_134_12 = var_134_12 + 1
						
						if iter_134_1.lobby_balloon == "y" and (var_134_8 == nil or var_134_8 and to_n(iter_134_1.sort) < to_n(var_134_8.pkg_data.sort)) then
							var_134_8 = {
								option = "new_add",
								package_id = var_134_18,
								pkg_type = var_134_17,
								pkg_data = iter_134_1
							}
						end
					end
				end
			end
		end
	end
	
	if var_134_6 then
		return var_134_6, var_134_12
	elseif var_134_8 then
		return var_134_8, var_134_12
	elseif var_134_10 then
		SAVE:setUserDefaultData("promotion_remain_last_day", var_134_1)
		
		return var_134_10, var_134_12
	else
		return nil, var_134_12
	end
end
