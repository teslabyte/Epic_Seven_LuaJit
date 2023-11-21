function HANDLER.shop_guerrilla(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getName()
	
	if var_1_0 == "btn_top_back" then
		ShopGuerrilla:onPushBackButton()
	end
	
	if var_1_0 == "btn_mob" then
		print(getParentWindow(arg_1_0).code)
	end
	
	if var_1_0 == "btn_Help" then
	end
end

function MsgHandler.guerrilla_shop(arg_2_0)
	if arg_2_0.shop then
		ShopGuerrilla:enterShop(arg_2_0.shop)
	else
		AccountData.guerrilla_shop = nil
	end
end

function ErrHandler.guerrilla_shop(arg_3_0, arg_3_1, arg_3_2)
	balloon_message_with_sound("ui_guerrilla_err_time_limit_lobby")
end

ShopGuerrilla = ShopGuerrilla or {}

copy_functions(ScrollView, ShopGuerrilla)
copy_functions(ShopCommon, ShopGuerrilla)

function ShopGuerrilla.open(arg_4_0)
	if not AccountData.shop_guerrilla_simple or not AccountData.shop_guerrilla_simple.id then
		return 
	end
	
	arg_4_0.ready = nil
	
	if arg_4_0:isShopPresent() then
		arg_4_0.shop_id = AccountData.shop_guerrilla_simple.id
		arg_4_0.talker_key = "guerrilla"
		
		query("guerrilla_shop", {
			npc = arg_4_0.shop_id
		})
	else
		balloon_message_with_sound("ui_guerrilla_err_time_limit_lobby")
	end
end

function ShopGuerrilla.enterShop(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0 = os.time()
	
	if var_5_0 < to_n(arg_5_1.current_shop_time) or var_5_0 >= to_n(arg_5_1.refresh_time) or var_5_0 >= to_n(arg_5_1.end_time) or var_5_0 < to_n(arg_5_1.start_time) then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	AccountData.guerrilla_shop = arg_5_1
	
	Lobby:toggleBartenderMode(true, true)
	
	arg_5_0.ready = true
end

function ShopGuerrilla.onAfterUpdate(arg_6_0)
	local var_6_0 = os.time()
	
	if arg_6_0.prevTick == nil then
		arg_6_0.prevTick = var_6_0
	elseif not arg_6_0.ready or arg_6_0.prevTick == var_6_0 then
		return 
	end
	
	if var_6_0 >= to_n(AccountData.guerrilla_shop.end_time) or var_6_0 >= to_n(AccountData.guerrilla_shop.refresh_time) or var_6_0 < to_n(AccountData.guerrilla_shop.current_shop_time) then
		arg_6_0.ready = false
		
		ShopGuerrilla:onPushBackButton()
		
		return 
	end
	
	arg_6_0:updateTimeLimitedItems()
	
	if get_cocos_refid(arg_6_0.wnd) then
		local var_6_1 = arg_6_0.wnd:getChildByName("n_guer")
		
		if_set(var_6_1, "txt_rest_time", T("guerilla_refresh_time", timeToStringDef({
			remain_time = AccountData.guerrilla_shop.refresh_time - os.time()
		})))
	end
	
	arg_6_0.prevTick = var_6_0
end

function ShopGuerrilla.isVisible(arg_7_0)
	if get_cocos_refid(arg_7_0.wnd) then
		return arg_7_0.wnd:isVisible()
	end
end

function ShopGuerrilla.show(arg_8_0, arg_8_1, arg_8_2)
	if not AccountData.guerrilla_shop then
		return 
	end
	
	arg_8_2 = arg_8_2 or {}
	
	local var_8_0 = load_dlg("shop_guerrilla", true, "wnd")
	
	arg_8_0.wnd = var_8_0
	arg_8_0.vars = {}
	arg_8_0.vars.DB = {}
	
	BackButtonManager:push({
		check_id = "GuerrillaShop",
		back_func = function()
			arg_8_0:onPushBackButton()
		end
	})
	if_set(var_8_0, "txt_top_title", T("guerrillashop"))
	arg_8_0:HelpbuttonPosition()
	if_set_visible(var_8_0, "dim", false)
	Scheduler:addSlow(arg_8_0.wnd, arg_8_0.onAfterUpdate, arg_8_0)
	
	arg_8_0.scrollview = var_8_0:getChildByName("scrollview")
	
	arg_8_0:initScrollView(arg_8_0.scrollview, 700, 145)
	arg_8_0:update(400)
	
	local var_8_1 = var_8_0:getChildByName("n_guer")
	
	var_8_1:getChildByName("n_balloon"):setScale(0)
	
	local var_8_2, var_8_3 = UIUtil:getPortraitAni("npc1033", {
		pin_sprite_position_y = true
	})
	
	if var_8_2 then
		var_8_1:getChildByName("n_portrait"):addChild(var_8_2)
		var_8_2:setScale(1)
		var_8_2:setPositionY(var_8_2:getPositionY() + (var_8_3 and -160 or 320))
	end
	
	arg_8_0.vars.portrait = var_8_2
	
	if get_cocos_refid(arg_8_1) then
		arg_8_1:addChild(var_8_0)
	end
	
	arg_8_0.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_8_0.wnd, "block")
	if_set(var_8_1, "t_period", T("time_slash_period_y_m_d_time", timeToStringDef({
		preceding_with_zeros = true,
		start_time = AccountData.guerrilla_shop.start_time,
		end_time = AccountData.guerrilla_shop.end_time
	})))
	if_set(var_8_1, "txt_rest_time", T("guerilla_refresh_time", timeToStringDef({
		remain_time = AccountData.guerrilla_shop.refresh_time - os.time()
	})))
	UIUtil:playNPCSoundAndTextRandomly(arg_8_0.talker_key .. ".enter", var_8_1, "txt_balloon", 300, arg_8_0.talker_key .. ".idle")
	if_set_visible(var_8_1, "n_event_title", false)
	
	local var_8_4 = AccountData.guerrilla_shop.is_special
	
	if var_8_4 then
		local var_8_5 = string.split(var_8_4, ":")
		
		if var_8_5[1] == "special" then
			local var_8_6 = var_8_1:getChildByName("n_event_title")
			
			var_8_6:setVisible(true)
			if_set(var_8_6, "txt", T(var_8_5[2]))
		end
	end
	
	local var_8_7 = AccountData.guerrilla_shop.id .. "_" .. AccountData.shop_guerrilla_simple.day_id
	
	if AccountData.guerrilla_shop.is_latter then
		var_8_7 = var_8_7 .. "l"
	end
	
	SAVE:set("game.guerrilla_shop_last_id", var_8_7)
	SAVE:save()
	
	return arg_8_0.wnd
end

function ShopGuerrilla.setAniPortrait(arg_10_0, arg_10_1)
	if Action:Find("portrait") then
		return 
	end
	
	if arg_10_0.vars and get_cocos_refid(arg_10_0.vars.portrait) and arg_10_0.vars.portrait.is_model then
		Action:Add(SEQ(DMOTION(arg_10_1), MOTION("idle", true)), arg_10_0.vars.portrait, "portrait")
	end
end

function ShopGuerrilla.exit(arg_11_0)
	UIAction:Add(SEQ(FADE_OUT(200), SHOW(false), DELAY(250), REMOVE(), DELAY(800)), arg_11_0.wnd, "block")
	Dialog:closeAll()
	
	arg_11_0.ScrollViewItems = nil
	arg_11_0.vars = nil
	arg_11_0.wnd = nil
	
	UIUtil:playNPCSound(arg_11_0.talker_key .. ".leave")
end

function ShopGuerrilla.updateBalloon(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		return 
	end
	
	if not arg_12_0.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.wnd) then
		return 
	end
	
	if arg_12_0.talker_key then
		local var_12_0 = arg_12_0.wnd:getChildByName("n_guer"):getChildByName("n_balloon")
		
		if get_cocos_refid(var_12_0) then
			var_12_0:setScale(0)
			UIUtil:playNPCSoundAndTextRandomly(arg_12_0.talker_key .. arg_12_1, var_12_0, "txt_balloon", 300, arg_12_0.talker_key .. ".idle", arg_12_0.vars.portrait)
		end
	end
	
	if_set_visible(arg_12_0.wnd, "n_balloon", arg_12_0.talker_key ~= nil)
end

function ShopGuerrilla.update(arg_13_0, arg_13_1)
	if not arg_13_0.vars then
		return 
	end
	
	arg_13_0:updateList(arg_13_1)
	arg_13_0:onAfterUpdate()
end

function ShopGuerrilla.updateList(arg_14_0, arg_14_1)
	if not get_cocos_refid(arg_14_0.wnd) then
		return 
	end
	
	if not AccountData.guerrilla_shop.shop_list then
		return 
	end
	
	local var_14_0 = os.time()
	
	arg_14_0.vars.DB = {}
	arg_14_0.List = {}
	
	for iter_14_0, iter_14_1 in pairs(AccountData.guerrilla_shop.shop_list) do
		local var_14_1, var_14_2, var_14_3 = arg_14_0:GetRestCount(iter_14_1, var_14_0)
		
		if (var_14_3 == "only_once" or var_14_3 == "custom_rotation") and var_14_2 and to_n(var_14_1) < 1 then
			iter_14_1.sold_out = true
			iter_14_1.sort = iter_14_1.sort + 100000
		end
		
		table.push(arg_14_0.List, iter_14_1)
		
		arg_14_0.vars.DB[iter_14_1.id] = iter_14_1
	end
	
	table.sort(arg_14_0.List, function(arg_15_0, arg_15_1)
		return to_n(arg_15_0.sort) < to_n(arg_15_1.sort)
	end)
	arg_14_0:createScrollViewItems(arg_14_0.List)
	
	for iter_14_2, iter_14_3 in pairs(arg_14_0.ScrollViewItems) do
		local var_14_4 = iter_14_3.control:getPositionY()
		local var_14_5 = -200
		
		iter_14_3.control:setPositionY(var_14_5)
		UIAction:Add(SEQ(DELAY(to_n(arg_14_1) + iter_14_2 * 80), LOG(MOVE_TO(250, 417.5, var_14_4), 200)), iter_14_3.control, "block")
	end
end

function ShopGuerrilla.onDialogTouchDown(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
end

ShopGuerrilla.onDialogTouchMove = ShopGuerrilla.onDialogTouchDown

function ShopGuerrilla.onTouchDown(arg_17_0, arg_17_1, arg_17_2)
end

function ShopGuerrilla.onTouchUp(arg_18_0, arg_18_1, arg_18_2)
end

function ShopGuerrilla.onTouchMove(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0:onDialogTouchDown(nil, arg_19_1, arg_19_2)
end

function ShopGuerrilla.getScrollViewItem(arg_20_0, arg_20_1)
	arg_20_1.is_limit_button = true
	
	local var_20_0 = arg_20_0:makeShopItem(arg_20_1, "wnd/shop_card.csb", {
		shop_artifact_stone = true
	})
	
	if var_20_0 then
		local var_20_1 = arg_20_0.scrollview:getContentSize()
		local var_20_2 = var_20_0:getContentSize()
		
		resetControlPosAndSize(var_20_0, var_20_1.width, var_20_2.width)
		NotchManager:addListener(var_20_0, nil, function(arg_21_0, arg_21_1, arg_21_2)
			resetControlPosAndSize(var_20_0, var_20_1.width, var_20_2.width)
			var_20_0:findChildByName("txt_count_info"):setPositionX(207)
		end)
	end
	
	local var_20_3 = DB("character", arg_20_1.type, "type")
	
	if var_20_3 == "monster" or var_20_3 == "character" then
		var_20_0.c.n_item_pos:setScale(1.14)
	end
	
	local var_20_4, var_20_5 = DB("item_material", arg_20_1.type, {
		"ma_type",
		"ma_type2"
	})
	
	if var_20_4 == "stone" and var_20_5 == "artifact" then
		var_20_0:getChildByName("n_reward_item"):getChildByName("slot"):setScale(0.85)
		var_20_0.c.n_item_pos:setPositionX(var_20_0.c.n_item_pos:getPositionX() + 1)
		var_20_0.c.n_item_pos:setPositionY(var_20_0.c.n_item_pos:getPositionY() - 2)
	end
	
	return var_20_0
end

function ShopGuerrilla.updateTimeLimitedItems(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		return 
	end
	
	local var_22_0 = os.time()
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.ScrollViewItems) do
		if get_cocos_refid(iter_22_1.control) then
			local var_22_1
			local var_22_2
			
			if iter_22_1.item.limit_cooltime then
				var_22_2 = arg_22_0:getRestCoolTime(iter_22_1.item.id, var_22_0)
				
				if_set_visible(iter_22_1.control, "n_time", var_22_2 and var_22_2 > 0)
			else
				var_22_1 = arg_22_0:getRestTime(iter_22_1.item.id, var_22_0)
				
				if_set_visible(iter_22_1.control, "n_time", var_22_1 and var_22_1 > 0)
			end
			
			local var_22_3 = iter_22_1.control:getChildByName("btn_go")
			
			if var_22_1 and var_22_1 > 0 or var_22_2 and var_22_2 > 0 then
				if_set_opacity(iter_22_1.control, "n_base", 76.5)
				if_set_opacity(iter_22_1.control, "n_right", 76.5)
				if_set_opacity(iter_22_1.control, "n_btn_counter", 76.5)
				if_set_opacity(iter_22_1.control, "n_custom_badge", 76.5)
				if_set_opacity(iter_22_1.control, "n_cost", 76.5)
				
				iter_22_1.control.soldout = true
			else
				if_set_opacity(iter_22_1.control, "n_right", 255)
				if_set_opacity(iter_22_1.control, "n_btn_counter", 255)
			end
			
			if iter_22_1.item.is_fixed == "y" then
				if_set(iter_22_1.control, "txt_count_info", T("guerilla_special_item"))
				if_set_visible(iter_22_1.control, "txt_count_info", true)
				if_set_visible(iter_22_1.control, "grow", true)
			else
				if_set(iter_22_1.control, "txt_count_info", "")
				if_set_visible(iter_22_1.control, "txt_count_info", false)
				if_set_visible(iter_22_1.control, "grow", false)
			end
			
			if_set(iter_22_1.control, "txt_time", "")
			
			if var_22_1 and var_22_1 > 0 then
				if_set(iter_22_1.control, "txt_count_info", T("sold_out"))
				if_set_visible(iter_22_1.control, "txt_count_info", true)
				if_set_visible(iter_22_1.control, "grow", true)
			end
			
			if var_22_2 and var_22_2 > 0 then
				if_set(iter_22_1.control, "txt_count_info", T("sold_out"))
				if_set_visible(iter_22_1.control, "txt_count_info", true)
				if_set_visible(iter_22_1.control, "grow", true)
			end
			
			local var_22_4, var_22_5, var_22_6 = arg_22_0:GetRestCount(iter_22_1.item, var_22_0)
			
			if var_22_5 then
				if_set(iter_22_1.control, "txt_count", var_22_4 .. "/" .. var_22_5)
				
				iter_22_1.item.rest_count = var_22_4
				iter_22_1.item.sold_out = var_22_4 < 1
			end
			
			if iter_22_1.item.equip_select == "y" then
				local var_22_7 = iter_22_1.control:getChildByName("n_group")
				
				if get_cocos_refid(var_22_7) then
					local var_22_8 = to_n(Account:getLimitCount("ds:eqr_" .. iter_22_1.item.category))
					local var_22_9 = iter_22_1.item.equip_select_refresh_max or 30
					
					if_set(var_22_7, "txt_group", T("shop_char_coin_refresh", {
						num1 = math.max(var_22_9 - var_22_8, 0),
						num2 = var_22_9
					}))
				end
			end
		end
	end
end

function ShopGuerrilla.reqBuy(arg_23_0, arg_23_1, arg_23_2)
	query("buy", {
		shop = "guerrilla",
		item = arg_23_1.id,
		npc = arg_23_0.shop_id,
		type = arg_23_1.type,
		multiply = arg_23_2 or 1
	})
end

function ShopGuerrilla.onPushBackButton(arg_24_0)
	Lobby:toggleBartenderMode()
	BackButtonManager:pop("GuerrillaShop")
end

function ShopGuerrilla.HelpbuttonPosition(arg_25_0)
	local var_25_0 = arg_25_0.wnd:getChildByName("txt_top_title")
	local var_25_1 = arg_25_0.wnd:getChildByName("btn_Help")
	
	if var_25_0 then
		local var_25_2 = var_25_0:getContentSize().width * var_25_0:getScaleX() + var_25_0:getPositionX()
		
		if var_25_1 then
			var_25_1:setPositionX(var_25_2 - 120)
		end
	end
end

function ShopGuerrilla.test(arg_26_0, arg_26_1)
	if arg_26_1 then
		AccountData.shop_guerrilla_simple.start_time = os.time() + 10
	end
	
	AccountData.shop_guerrilla_simple.end_time = os.time() + 20
	
	if AccountData.guerrilla_shop then
		AccountData.guerrilla_shop.end_time = os.time() + 20
	end
end

function ShopGuerrilla.isShopPresent(arg_27_0)
	if not AccountData.shop_guerrilla_simple or not AccountData.shop_guerrilla_simple.id then
		return false
	end
	
	local var_27_0 = os.time()
	
	if var_27_0 < to_n(AccountData.shop_guerrilla_simple.start_time) or var_27_0 > to_n(AccountData.shop_guerrilla_simple.end_time) then
		return false
	end
	
	return true
end

function ShopGuerrilla.isNewShop(arg_28_0)
	if not arg_28_0:isShopPresent() then
		return false
	end
	
	local var_28_0 = SAVE:get("game.guerrilla_shop_last_id", "")
	local var_28_1 = AccountData.shop_guerrilla_simple.id .. "_" .. AccountData.shop_guerrilla_simple.day_id
	
	if AccountData.shop_guerrilla_simple.is_latter then
		var_28_1 = var_28_1 .. "l"
	end
	
	if var_28_1 == var_28_0 then
		return false
	else
		return true
	end
end
