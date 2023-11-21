LotaShopUI = {}

copy_functions(ShopCommon, LotaShopUI)
copy_functions(ScrollView, LotaShopUI)

function LotaShopUI.open(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.wnd = load_dlg("dungeon_story_shop", true, "wnd")
	arg_1_0.vars.list = {}
	arg_1_0.vars.info = arg_1_2
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		table.push(arg_1_0.vars.list, iter_1_1)
	end
	
	local var_1_0 = LotaEnterUI:getShopSchedule()
	local var_1_1
	
	if var_1_0 then
		var_1_1 = DBT("clan_heritage_season", var_1_0.id, {
			"background_shop",
			"shop_npc_id",
			"shop_npc_info",
			"npc_balloon_id",
			"npc_balloon_info"
		})
	end
	
	if var_1_1 then
		for iter_1_2, iter_1_3 in pairs(var_1_1) do
			arg_1_2[iter_1_2] = iter_1_3
		end
	end
	
	local var_1_2
	
	if not table.empty(arg_1_2) then
		local var_1_3 = totable(arg_1_2.background_shop)
		local var_1_4 = arg_1_0.vars.wnd:getChildByName("n_bg")
		
		if get_cocos_refid(var_1_4) and var_1_3.map then
			local var_1_5, var_1_6 = FIELD_NEW:create(var_1_3.map)
			
			var_1_6:setViewPortPosition(var_1_3.scroll_x or 0, var_1_3.scroll_y or 0)
			var_1_6:updateViewport()
			var_1_5:setAnchorPoint(0.5, 0.5)
			var_1_5:setPosition(0, -(DESIGN_HEIGHT * 0.5))
			var_1_5:setScale(1)
			var_1_4:addChild(var_1_5)
			arg_1_0.vars.wnd:setLocalZOrder(1)
			
			var_1_2 = var_1_5
		end
	end
	
	if var_1_2 then
		SceneManager:getDefaultLayer():addChild(arg_1_0.vars.wnd)
	else
		SceneManager:getRunningNativeScene():addChild(arg_1_0.vars.wnd)
	end
	
	local var_1_7 = arg_1_0.vars.wnd:getChildByName("talk_bg")
	
	UIUtil:setOffsetInfo(var_1_7, arg_1_2.npc_balloon_info)
	
	arg_1_0.vars.scrollview = arg_1_0.vars.wnd:getChildByName("scroll_view")
	
	arg_1_0:initScrollView(arg_1_0.vars.scrollview, 700, 145)
	arg_1_0:updateList()
	arg_1_0:updatePortrait(arg_1_2)
	arg_1_0:updateCurrency()
	arg_1_0:updateTimeLimitedItems(os.time())
	
	local function var_1_8()
		LotaShopUI:close()
		BackButtonManager:pop("TopBarNew." .. T("ui_dungeon_story_shop"))
	end
	
	TopBarNew:createFromPopup(T("ui_dungeon_story_shop"), arg_1_0.vars.wnd, var_1_8, nil, nil, "LotaShopUI")
	TopBarNew:setCurrencies({
		"clanheritagecoin"
	})
	TopBarNew:setDisableLobbyAuto()
	
	return arg_1_0.vars.wnd
end

function LotaShopUI.updateList(arg_3_0)
	arg_3_0.vars.DB = {}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.list) do
		arg_3_0.vars.DB[iter_3_1.id] = iter_3_1
	end
	
	table.sort(arg_3_0.vars.list, function(arg_4_0, arg_4_1)
		return tonumber(arg_4_0.sort) < tonumber(arg_4_1.sort)
	end)
	arg_3_0:createScrollViewItems(arg_3_0.vars.list)
end

function LotaShopUI.updatePortrait(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.wnd:getChildByName("n_portrait")
	
	if get_cocos_refid(var_5_0) and arg_5_1.shop_npc_id then
		local var_5_1 = UIUtil:getPortraitAni(arg_5_1.shop_npc_id, {
			pin_sprite_position_y = false
		})
		
		var_5_0:addChild(var_5_1)
		UIUtil:setOffsetInfo(var_5_1, arg_5_1.shop_npc_info)
		
		arg_5_0.vars.portrait = var_5_1
	end
	
	arg_5_0.talker_key = arg_5_1.npc_balloon_id
	
	arg_5_0:updateBalloon(".enter")
end

function LotaShopUI.updateBalloon(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	if not arg_6_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	if arg_6_0.talker_key then
		local var_6_0 = arg_6_0.vars.wnd:getChildByName("talk_bg")
		
		if get_cocos_refid(var_6_0) then
			var_6_0:setScale(0)
			UIUtil:playNPCSoundAndTextRandomly(arg_6_0.talker_key .. arg_6_1, var_6_0, "disc", 300, arg_6_0.talker_key .. ".idle", arg_6_0.vars.portrait)
		end
	end
	
	if_set_visible(arg_6_0.vars.wnd, "talk_bg", arg_6_0.talker_key ~= nil)
end

function LotaShopUI.updateCurrency(arg_7_0)
	local var_7_0 = ""
	local var_7_1 = arg_7_0.vars.wnd:getChildByName("n_token_1")
	local var_7_2 = arg_7_0.vars.wnd:getChildByName("txt_have_1")
	
	if get_cocos_refid(var_7_1) then
		if var_7_0 then
			local var_7_3 = Account:isCurrencyType(var_7_0) ~= nil
			local var_7_4
			
			if var_7_3 then
				var_7_4 = Account:getCurrency(var_7_0)
			else
				var_7_4 = Account:getItemCount(var_7_0)
			end
			
			if_set(var_7_1, "txt_have_1", T("ui_dungeon_shop_have", {
				have = comma_value(var_7_4)
			}))
			if_set_sprite(var_7_1, "txt_have_1", UIUtil:getIconPath(var_7_0))
			
			local var_7_5 = var_7_1:getChildByName("txt_have_1")
			local var_7_6 = 40
			
			if get_cocos_refid(var_7_5) then
				var_7_1:setPositionX(-(var_7_5:getContentSize().width + var_7_6))
			end
		else
			var_7_2:setVisible(false)
		end
	end
end

function LotaShopUI.close(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(600), CALL(function()
		if not arg_8_0.vars then
			return 
		end
		
		if arg_8_0.vars and get_cocos_refid(arg_8_0.vars.wnd) then
			arg_8_0.vars.wnd:removeFromParent()
			TopBarNew:pop()
		end
		
		arg_8_0.vars.wnd = nil
		arg_8_0.vars = nil
	end)), arg_8_0.vars.wnd, "block")
	LotaEnterUI:show()
end

function LotaShopUI.getScrollViewItem(arg_10_0, arg_10_1)
	local var_10_0, var_10_1, var_10_2 = arg_10_0:GetRestCount(arg_10_1, os.time())
	
	arg_10_1.is_limit_button = var_10_0 ~= nil
	
	local var_10_3 = arg_10_0:makeShopItem(arg_10_1, "wnd/shop_card.csb")
	
	if_set_visible(var_10_3, "res", false)
	
	return var_10_3
end

function LotaShopUI.reqBuy(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.vars then
		arg_11_0.vars.old_pos = arg_11_0.scrollview:getInnerContainerPosition()
	end
	
	query("buy", {
		caller = "lota_shop",
		shop = "story",
		item = arg_11_1.id,
		type = arg_11_1.type,
		multiply = arg_11_2 or 1
	})
end

function LotaShopUI.sortingItems(arg_12_0)
	if not arg_12_0.vars or not arg_12_0.ScrollViewItems then
		return 
	end
	
	local function var_12_0(arg_13_0, arg_13_1)
		if arg_13_0.control.soldout and not arg_13_1.control.soldout then
			return false
		end
		
		if not arg_13_0.control.soldout and arg_13_1.control.soldout then
			return true
		end
		
		return tonumber(arg_13_0.item.sort) < tonumber(arg_13_1.item.sort)
	end
	
	table.sort(arg_12_0.ScrollViewItems, var_12_0)
	
	local var_12_1 = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.ScrollViewItems) do
		table.insert(var_12_1, iter_12_1.item)
	end
	
	arg_12_0:setScrollViewItems(var_12_1)
	
	if arg_12_0.vars.old_pos then
		arg_12_0.scrollview:setInnerContainerPosition(arg_12_0.vars.old_pos)
	end
end

function LotaShopUI.updateTimeLimitedItems(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	local var_14_0 = false
	local var_14_1 = os.time()
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.ScrollViewItems) do
		if get_cocos_refid(iter_14_1.control) then
			local var_14_2
			local var_14_3
			
			if iter_14_1.item.limit_cooltime then
				var_14_3 = arg_14_0:getRestCoolTime(iter_14_1.item.id, var_14_1)
				
				if_set_visible(iter_14_1.control, "n_time", var_14_3 and var_14_3 > 0)
			else
				var_14_2 = arg_14_0:getRestTime(iter_14_1.item.id, var_14_1)
				
				if_set_visible(iter_14_1.control, "n_time", var_14_2 and var_14_2 > 0)
			end
			
			local var_14_4 = iter_14_1.control:getChildByName("btn_go")
			
			if var_14_2 and var_14_2 > 0 or var_14_3 and var_14_3 > 0 then
				if_set_opacity(iter_14_1.control, "n_base", 76.5)
				if_set_opacity(iter_14_1.control, "n_cost", 76.5)
				if_set_opacity(iter_14_1.control, "n_right", 76.5)
				if_set_opacity(iter_14_1.control, "n_btn_counter", 76.5)
				if_set_opacity(iter_14_1.control, "n_custom_badge", 76.5)
				
				iter_14_1.control.soldout = true
				var_14_0 = true
			else
				if_set_opacity(iter_14_1.control, "n_right", 255)
				if_set_opacity(iter_14_1.control, "n_btn_counter", 255)
				if_set_opacity(iter_14_1.control, "n_custom_badge", 255)
			end
			
			if_set(iter_14_1.control, "txt_count_info", "")
			if_set_visible(iter_14_1.control, "txt_count_info", false)
			if_set_visible(iter_14_1.control, "grow", false)
			if_set(iter_14_1.control, "txt_time", "")
			
			if var_14_2 and var_14_2 > 0 then
				if_set(iter_14_1.control, "txt_count_info", T("sold_out"))
				if_set_visible(iter_14_1.control, "grow", true)
				if_set_visible(iter_14_1.control, "txt_count_info", true)
			end
			
			if var_14_3 and var_14_3 > 0 then
				if_set(iter_14_1.control, "txt_count_info", T("sold_out"))
				if_set_visible(iter_14_1.control, "grow", true)
				if_set_visible(iter_14_1.control, "txt_count_info", true)
			end
			
			local var_14_5, var_14_6, var_14_7 = arg_14_0:GetRestCount(iter_14_1.item, var_14_1)
			
			if var_14_6 then
				if_set(iter_14_1.control, "txt_count", var_14_5 .. "/" .. var_14_6)
				
				iter_14_1.item.rest_count = var_14_5
				iter_14_1.item.sold_out = var_14_5 < 1
			end
			
			ShopCommon:ResizeItemName(iter_14_1.item, iter_14_1.control)
		end
	end
	
	if var_14_0 then
		arg_14_0:sortingItems()
	end
end
