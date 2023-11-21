SubstoryShop = {}

copy_functions(ShopCommon, SubstoryShop)
copy_functions(ScrollView, SubstoryShop)

function SubstoryShop.open(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.wnd = load_dlg("dungeon_story_shop", true, "wnd")
	arg_1_0.vars.list = {}
	arg_1_0.vars.info = arg_1_2
	arg_1_0.vars.festival_info = Account:getSubStoryFestivalInfo(arg_1_0.vars.info.id)
	
	if arg_1_0.vars.festival_info and table.empty(arg_1_0.vars.festival_info) then
		arg_1_0.vars.festival_info = nil
	end
	
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		if iter_1_1.sys_achieve and not UnlockSystem:isUnlockSystem(iter_1_1.sys_achieve) then
		elseif iter_1_1.substory_schedule and not SubstoryManager:isOpenSubstoryShop(iter_1_1.substory_schedule, SUBSTORY_CONSTANTS.ONE_WEEK) then
		elseif iter_1_1.festival_day then
			if arg_1_0.vars.festival_info and arg_1_0.vars.festival_info.day then
				local var_1_0 = tonumber(iter_1_1.festival_day) or 0
				local var_1_1 = tonumber(arg_1_0.vars.festival_info.day)
				
				if var_1_0 == var_1_1 or var_1_0 < var_1_1 and arg_1_0:GetRestCount(iter_1_1, os.time()) <= 0 then
					table.push(arg_1_0.vars.list, iter_1_1)
				end
			end
		else
			table.push(arg_1_0.vars.list, iter_1_1)
		end
	end
	
	if arg_1_0.vars.info.id == "vma1ba" then
		TutorialGuide:startGuide("tuto_vma1ba_shop")
	end
	
	local var_1_2
	local var_1_3 = arg_1_0.vars.wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_1_3) and arg_1_2.background_shop then
		local var_1_4 = SubstoryUIUtil:getBGInfo(arg_1_2.background_shop, arg_1_0.vars.info.id)
		
		var_1_2 = SubstoryUIUtil:addImageFromData(var_1_3, var_1_4.bg)
		
		arg_1_0.vars.wnd:setLocalZOrder(99998)
	end
	
	if var_1_2 then
		SceneManager:getDefaultLayer():addChild(arg_1_0.vars.wnd)
	else
		SceneManager:getRunningNativeScene():addChild(arg_1_0.vars.wnd)
	end
	
	if_set_visible(arg_1_0.vars.wnd, "n_info", arg_1_0.vars.festival_info)
	
	local var_1_5 = arg_1_0.vars.wnd:getChildByName("talk_bg")
	
	UIUtil:setOffsetInfo(var_1_5, arg_1_2.npc_balloon_info)
	
	arg_1_0.vars.scrollview = arg_1_0.vars.wnd:getChildByName("scroll_view")
	
	arg_1_0:initScrollView(arg_1_0.vars.scrollview, 700, 145)
	arg_1_0:updateList()
	arg_1_0:updatePortrait(arg_1_2)
	arg_1_0:updateCurrency()
	arg_1_0:updateTimeLimitedItems(os.time())
	
	local function var_1_6()
		SubstoryShop:closeStoryShop()
	end
	
	TopBarNew:createFromPopup(T("ui_dungeon_story_shop"), arg_1_0.vars.wnd, var_1_6, nil, nil, "SubstoryShop")
	
	local var_1_7 = {}
	
	for iter_1_2 = 1, 3 do
		local var_1_8 = arg_1_2["token_id" .. iter_1_2]
		
		if var_1_8 then
			table.insert(var_1_7, var_1_8)
		end
	end
	
	TopBarNew:setCurrencies(var_1_7)
	
	return arg_1_0.vars.wnd
end

function SubstoryShop.closeStoryShop(arg_3_0)
	SubstoryShop:close()
	SubStoryLobby:showBG()
	BackButtonManager:pop("TopBarNew." .. T("ui_dungeon_story_shop"))
end

function SubstoryShop.updateList(arg_4_0)
	arg_4_0.vars.DB = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.list) do
		arg_4_0.vars.DB[iter_4_1.id] = iter_4_1
	end
	
	table.sort(arg_4_0.vars.list, function(arg_5_0, arg_5_1)
		return tonumber(arg_5_0.sort) < tonumber(arg_5_1.sort)
	end)
	arg_4_0:createScrollViewItems(arg_4_0.vars.list)
end

function SubstoryShop.updatePortrait(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_portrait")
	
	if get_cocos_refid(var_6_0) and arg_6_1.shop_npc_id then
		local var_6_1 = UIUtil:getPortraitAni(arg_6_1.shop_npc_id, {
			pin_sprite_position_y = false
		})
		
		var_6_0:addChild(var_6_1)
		UIUtil:setOffsetInfo(var_6_1, arg_6_1.shop_npc_info)
		
		arg_6_0.vars.portrait = var_6_1
	end
	
	arg_6_0.talker_key = arg_6_1.npc_balloon_id
	
	arg_6_0:updateBalloon(".enter")
end

function SubstoryShop.updateBalloon(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	if not arg_7_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	if arg_7_0.talker_key then
		local var_7_0 = arg_7_0.vars.wnd:getChildByName("talk_bg")
		
		if get_cocos_refid(var_7_0) then
			var_7_0:setScale(0)
			UIUtil:playNPCSoundAndTextRandomly(arg_7_0.talker_key .. arg_7_1, var_7_0, "disc", 300, arg_7_0.talker_key .. ".idle", arg_7_0.vars.portrait)
		end
	end
	
	if_set_visible(arg_7_0.vars.wnd, "talk_bg", arg_7_0.talker_key ~= nil)
end

function SubstoryShop.updateCurrency(arg_8_0)
	local var_8_0 = SubstoryManager:getInfo()
	
	for iter_8_0 = 1, 3 do
		local var_8_1 = arg_8_0.vars.wnd:getChildByName("n_token_" .. iter_8_0)
		local var_8_2 = arg_8_0.vars.wnd:getChildByName("txt_have_" .. iter_8_0)
		
		if get_cocos_refid(var_8_1) then
			local var_8_3 = var_8_0["token_id" .. iter_8_0]
			
			if var_8_3 then
				local var_8_4 = Account:isCurrencyType(var_8_3) ~= nil
				local var_8_5
				
				if var_8_4 then
					var_8_5 = Account:getCurrency(var_8_3)
				else
					var_8_5 = Account:getItemCount(var_8_3)
				end
				
				if_set(var_8_1, "txt_have_" .. iter_8_0, T("ui_dungeon_shop_have", {
					have = comma_value(var_8_5)
				}))
				if_set_sprite(var_8_1, "img_token_" .. iter_8_0, UIUtil:getIconPath(var_8_3))
				
				local var_8_6 = var_8_1:getChildByName("txt_have_" .. iter_8_0)
				local var_8_7 = 40
				
				if get_cocos_refid(var_8_6) then
					var_8_1:setPositionX(-(var_8_6:getContentSize().width + var_8_7))
				end
			else
				var_8_2:setVisible(false)
			end
		end
	end
end

function SubstoryShop.close(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(600), CALL(function()
		if not arg_9_0.vars then
			return 
		end
		
		if arg_9_0.vars and get_cocos_refid(arg_9_0.vars.wnd) then
			arg_9_0.vars.wnd:removeFromParent()
			TopBarNew:pop()
		end
		
		arg_9_0.vars.wnd = nil
		arg_9_0.vars = nil
		
		SubStoryLobby:updateUI()
	end)), arg_9_0.vars.wnd, "block")
end

function SubstoryShop.getScrollViewItem(arg_11_0, arg_11_1)
	local var_11_0, var_11_1, var_11_2 = arg_11_0:GetRestCount(arg_11_1, os.time())
	
	arg_11_1.is_limit_button = var_11_0 ~= nil
	
	local var_11_3 = arg_11_0:makeShopItem(arg_11_1, "wnd/shop_card.csb")
	
	if_set_visible(var_11_3, "res", false)
	
	return var_11_3
end

function SubstoryShop.reqBuy(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_0.vars then
		arg_12_0.vars.old_pos = arg_12_0.scrollview:getInnerContainerPosition()
	end
	
	query("buy", {
		caller = "substory_shop",
		shop = "story",
		item = arg_12_1.id,
		type = arg_12_1.type,
		multiply = arg_12_2 or 1
	})
end

function SubstoryShop.sortingItems(arg_13_0)
	if not arg_13_0.vars or not arg_13_0.ScrollViewItems then
		return 
	end
	
	local function var_13_0(arg_14_0, arg_14_1)
		if arg_14_0.control.soldout and not arg_14_1.control.soldout then
			return false
		end
		
		if not arg_14_0.control.soldout and arg_14_1.control.soldout then
			return true
		end
		
		return tonumber(arg_14_0.item.sort) < tonumber(arg_14_1.item.sort)
	end
	
	table.sort(arg_13_0.ScrollViewItems, var_13_0)
	
	local var_13_1 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.ScrollViewItems) do
		table.insert(var_13_1, iter_13_1.item)
	end
	
	arg_13_0:setScrollViewItems(var_13_1)
	
	if arg_13_0.vars.old_pos then
		arg_13_0.scrollview:setInnerContainerPosition(arg_13_0.vars.old_pos)
	end
end

function SubstoryShop.updateTimeLimitedItems(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	local var_15_0 = false
	local var_15_1 = os.time()
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.ScrollViewItems) do
		if get_cocos_refid(iter_15_1.control) then
			local var_15_2
			local var_15_3
			
			if iter_15_1.item.limit_cooltime then
				var_15_3 = arg_15_0:getRestCoolTime(iter_15_1.item.id, var_15_1)
				
				if_set_visible(iter_15_1.control, "n_time", var_15_3 and var_15_3 > 0)
			else
				var_15_2 = arg_15_0:getRestTime(iter_15_1.item.id, var_15_1)
				
				if_set_visible(iter_15_1.control, "n_time", var_15_2 and var_15_2 > 0)
			end
			
			local var_15_4 = iter_15_1.control:getChildByName("btn_go")
			
			if var_15_2 and var_15_2 > 0 or var_15_3 and var_15_3 > 0 then
				if_set_opacity(iter_15_1.control, "n_base", 76.5)
				if_set_opacity(iter_15_1.control, "n_cost", 76.5)
				if_set_opacity(iter_15_1.control, "n_right", 76.5)
				if_set_opacity(iter_15_1.control, "n_btn_counter", 76.5)
				if_set_opacity(iter_15_1.control, "n_custom_badge", 76.5)
				
				iter_15_1.control.soldout = true
				var_15_0 = true
			else
				if_set_opacity(iter_15_1.control, "n_right", 255)
				if_set_opacity(iter_15_1.control, "n_btn_counter", 255)
				if_set_opacity(iter_15_1.control, "n_custom_badge", 255)
			end
			
			if_set(iter_15_1.control, "txt_count_info", "")
			if_set_visible(iter_15_1.control, "txt_count_info", false)
			if_set_visible(iter_15_1.control, "grow", false)
			if_set(iter_15_1.control, "txt_time", "")
			
			if var_15_2 and var_15_2 > 0 then
				if_set(iter_15_1.control, "txt_count_info", T("sold_out"))
				if_set_visible(iter_15_1.control, "grow", true)
				if_set_visible(iter_15_1.control, "txt_count_info", true)
			end
			
			if var_15_3 and var_15_3 > 0 then
				if_set(iter_15_1.control, "txt_count_info", T("sold_out"))
				if_set_visible(iter_15_1.control, "grow", true)
				if_set_visible(iter_15_1.control, "txt_count_info", true)
			end
			
			local var_15_5, var_15_6, var_15_7 = arg_15_0:GetRestCount(iter_15_1.item, var_15_1)
			
			if var_15_6 then
				if_set(iter_15_1.control, "txt_count", var_15_5 .. "/" .. var_15_6)
				
				iter_15_1.item.rest_count = var_15_5
				iter_15_1.item.sold_out = var_15_5 < 1
			end
			
			ShopCommon:ResizeItemName(iter_15_1.item, iter_15_1.control)
		end
	end
	
	if var_15_0 then
		arg_15_0:sortingItems()
	end
end
