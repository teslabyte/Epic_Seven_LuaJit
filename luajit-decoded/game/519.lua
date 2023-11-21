function MsgHandler.clan_market(arg_1_0)
	AccountData.clan_shop = arg_1_0.list
	
	if SceneManager:getCurrentSceneName() == "clan" then
		ClanShopData:updateAllList(true)
	end
end

function ErrHandler.clan_master_buy(arg_2_0, arg_2_1)
	if SceneManager:getCurrentSceneName() ~= "clan" then
		return 
	end
	
	Dialog:close("clan_emblem_item_popup")
	Dialog:close("shop_popup_buy")
	
	arg_2_1 = arg_2_1 or ""
	arg_2_1 = "buy." .. arg_2_1
	
	local var_2_0 = arg_2_1 == "buy.no_to_crystal" or arg_2_1 == "buy.no_to_gold"
	
	local function var_2_1()
		ClanMasterShop:show()
	end
	
	local var_2_2 = load_dlg("shop_nocurrency", true, "wnd")
	
	if not var_2_0 then
		var_2_1 = nil
	end
	
	if_set(var_2_2, T(arg_2_1 .. ".desc"))
	
	if string.starts(arg_2_1, "buy.count_over") then
		balloon_message_with_sound(arg_2_1)
	elseif string.starts(arg_2_1, "buy.buff_time_limit") then
		balloon_message_with_sound(arg_2_1)
	elseif string.starts(arg_2_1, "buy.tx_err") then
		balloon_message_with_sound("clan_grade_change.tx_err")
	else
		UIUtil:getRewardIcon(nil, string.sub(arg_2_1, 8, -1), {
			show_name = true,
			detail = true,
			parent = var_2_2:getChildByName("n_item_pos")
		})
		Dialog:msgBox(T(arg_2_1 .. ".desc"), {
			dlg = var_2_2,
			handler = var_2_1,
			yesno = var_2_0,
			title = T(arg_2_1 .. ".title"),
			txt_shop_comment = T(arg_2_1 .. ".comment")
		})
	end
end

function MsgHandler.clan_master_buy(arg_4_0)
	Dialog:close("shop_popup_buy")
	SoundEngine:play("event:/ui/shop_popup_buy/btn_buy")
	TopBarNew:topbarUpdate(true)
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.currency) do
		if DB("item_clantoken", "ct_" .. iter_4_0, "id") then
			Clan:setCurrency(iter_4_0, iter_4_1)
		end
	end
	
	if arg_4_0.buff_doc then
		Account:updateBuffInfo(arg_4_0.buff_doc)
	end
	
	for iter_4_2, iter_4_3 in pairs(arg_4_0.clan_items) do
		if DB("clan_material", iter_4_2, "id") then
			Clan:setItemCount(iter_4_2, iter_4_3)
		end
	end
	
	Clan:updateInfo(arg_4_0)
	balloon_message_with_sound("shop_buy_success", "구매에 성공했습니다.!!")
	
	if arg_4_0.caller == "emblem" then
		Dialog:close("clan_emblem_item_popup")
		
		for iter_4_4, iter_4_5 in pairs(arg_4_0.clan_items) do
			local var_4_0 = DB("clan_material", iter_4_4, "id")
			
			if var_4_0 then
				ClanEmblem:onUpdateScrollViewItemByMaId(var_4_0)
			end
		end
	elseif arg_4_0.caller == "border" then
		Dialog:close("clan_emblem_item_popup")
		
		for iter_4_6, iter_4_7 in pairs(arg_4_0.clan_items) do
			local var_4_1 = DB("clan_material", iter_4_6, "id")
			
			if var_4_1 then
				ClanEmblemBG:onUpdateScrollViewItemByMaId(var_4_1)
			end
		end
	else
		Lobby:checkMail(true)
		ClanShopData:updateTimeLimitedItems()
	end
	
	SoundEngine:play("event:/ui/gold")
end

ClanShopData = {}

function ClanShopData.open(arg_5_0, arg_5_1)
	query("clan_market")
end

function ClanShopData.updateAllList(arg_6_0, arg_6_1)
	if SceneManager:getCurrentSceneName() ~= "clan" then
		return 
	end
	
	arg_6_0.AllList = {}
	
	for iter_6_0, iter_6_1 in pairs(AccountData.clan_shop) do
		arg_6_0.AllList[iter_6_0] = {}
		
		for iter_6_2, iter_6_3 in pairs(iter_6_1) do
			table.push(arg_6_0.AllList[iter_6_0], iter_6_3)
		end
	end
	
	if ClanBase:getMode() == "clanshop" then
		ClanShop:setDB()
		
		local var_6_0 = arg_6_0.AllList[ClanBase:getMode()]
		
		for iter_6_4, iter_6_5 in pairs(var_6_0) do
			local var_6_1, var_6_2, var_6_3 = ClanShop:GetRestCount(iter_6_5)
			
			if var_6_2 and var_6_1 < 1 and iter_6_5.sort and iter_6_5.sort < 100000 then
				iter_6_5.sort = iter_6_5.sort + 100000
			end
		end
		
		table.sort(var_6_0, function(arg_7_0, arg_7_1)
			return arg_7_0.sort < arg_7_1.sort
		end)
		ClanShop:createScrollViewItems(var_6_0)
	else
		ClanMasterShop:setDB()
		
		local var_6_4 = arg_6_0.AllList[ClanBase:getMode()]
		
		table.sort(var_6_4, function(arg_8_0, arg_8_1)
			return arg_8_0.sort < arg_8_1.sort
		end)
		ClanMasterShop:createScrollViewItems(var_6_4)
	end
	
	arg_6_0:updateTimeLimitedItems()
end

local function var_0_0(arg_9_0)
	if VIEW_WIDTH ~= DESIGN_WIDTH or not arg_9_0 or table.empty(arg_9_0) then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0) do
		if get_cocos_refid(iter_9_1.control) and not iter_9_1.control.move_positionX then
			iter_9_1.control.move_positionX = iter_9_1.control:getPositionX() - 17
			
			iter_9_1.control:setPositionX(iter_9_1.control.move_positionX)
		else
			iter_9_1.control:setPositionX(iter_9_1.control.move_positionX)
		end
	end
end

function ClanShopData.updateTimeLimitedItems(arg_10_0)
	if SceneManager:getCurrentSceneName() ~= "clan" then
		return 
	end
	
	if ClanBase:getMode() == "clanshop" then
		ClanShop:updateTimeLimitedItems(os.time())
		var_0_0(ClanShop.ScrollViewItems)
	else
		ClanMasterShop:updateTimeLimitedItems(os.time())
		var_0_0(ClanMasterShop.ScrollViewItems)
	end
end

function ClanShopData.getAllList(arg_11_0)
	return arg_11_0.AllList
end

function ClanShopData.getClanMasterShopList(arg_12_0)
	return arg_12_0.AllList.clanmastershop
end

function ClanShopData.getClanShopList(arg_13_0)
	return arg_13_0.AllList.clanshop
end

ClanShop = {}

copy_functions(ShopCommon, ClanShop)
copy_functions(ScrollView, ClanShop)

local function var_0_1(arg_14_0, arg_14_1)
	if not arg_14_0.STRETCH_INFO then
		return 
	end
	
	local var_14_0 = (VIEW_WIDTH - NOTCH_WIDTH) / DESIGN_WIDTH * arg_14_1
	local var_14_1 = arg_14_0:getContentSize()
	
	arg_14_0.STRETCH_INFO.width_after = var_14_0 + arg_14_0.STRETCH_INFO.width_after
	arg_14_0.STRETCH_INFO.stretch_ratio = arg_14_0.STRETCH_INFO.stretch_ratio + arg_14_1 / arg_14_0.STRETCH_INFO.width_prev
	
	arg_14_0:setContentSize({
		width = arg_14_0.STRETCH_INFO.width_after,
		height = var_14_1.height
	})
	
	local var_14_2 = var_14_0 / 2
	
	arg_14_0:setPositionX(arg_14_0:getPositionX() - var_14_2)
	NotchManager:adjustOriginPos(arg_14_0, -var_14_2)
end

local function var_0_2(arg_15_0)
	var_0_1(arg_15_0.vars.scrollview, 86)
	
	arg_15_0.item_width = arg_15_0.before_width * arg_15_0.scrollview.STRETCH_INFO.stretch_ratio
	
	arg_15_0:createScrollViewItems(arg_15_0.items or {})
	ClanShopData:updateAllList()
	
	local var_15_0 = arg_15_0.vars.scrollview:getContentSize()
	
	arg_15_0:setSize(var_15_0.width, var_15_0.height)
end

function ClanShop.show(arg_16_0, arg_16_1)
	arg_16_0.vars = {}
	arg_16_0.vars.parents = arg_16_1
	arg_16_0.vars.wnd = load_dlg("shop_list", true, "wnd")
	
	if_set_visible(arg_16_0.vars.wnd, "n_shop1", false)
	
	arg_16_0.vars.scrollview = arg_16_0.vars.wnd:getChildByName("n_scrollview"):getChildByName("scrollview")
	
	var_0_1(arg_16_0.vars.scrollview, 86)
	arg_16_0:initScrollView(arg_16_0.vars.scrollview, 690, 164)
	
	function arg_16_0.vars.scrollview.scene_reload_callback()
		var_0_2(ClanShop)
	end
	
	if not AccountData.clan_shop or not ClanShopData:getAllList() then
		ClanShopData:open()
	else
		ClanShopData:updateAllList()
	end
	
	return arg_16_0.vars.wnd
end

function ClanShop.updateTimeLimitedItems(arg_18_0, arg_18_1)
	if ShopCommon.updateTimeLimitedItems(arg_18_0, arg_18_1) then
		local var_18_0 = {}
		
		for iter_18_0, iter_18_1 in pairs(arg_18_0.ScrollViewItems) do
			table.insert(var_18_0, iter_18_1.item)
		end
		
		arg_18_0:setScrollViewItems(var_18_0)
		
		if arg_18_0.vars.old_pos then
			arg_18_0.vars.scrollview:setInnerContainerPosition(arg_18_0.vars.old_pos)
		end
	end
end

function ClanShop.setDB(arg_19_0)
	arg_19_0.vars.DB = {}
	
	for iter_19_0, iter_19_1 in pairs(ClanShopData:getClanShopList()) do
		arg_19_0.vars.DB[iter_19_1.id] = iter_19_1
	end
end

function ClanShop.getScrollViewItem(arg_20_0, arg_20_1)
	arg_20_1.is_limit_button = arg_20_0.vars.DB and arg_20_0.vars.DB[arg_20_1.id] and arg_20_0.vars.DB[arg_20_1.id].limit_count
	
	return (arg_20_0:makeShopItem(arg_20_1, "wnd/shop_card.csb"))
end

function ClanShop.reqBuy(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if arg_21_0.vars then
		arg_21_0.vars.old_pos = arg_21_0.vars.scrollview:getInnerContainerPosition()
	end
	
	arg_21_4 = arg_21_4 or {}
	
	local var_21_0 = {
		caller = "clanshop",
		item = arg_21_1.id,
		shop = arg_21_3,
		type = arg_21_1.type,
		multiply = arg_21_2 or 1
	}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_4) do
		var_21_0[iter_21_0] = iter_21_1
	end
	
	query("buy", var_21_0)
end

ClanMasterShop = {}

copy_functions(ShopCommon, ClanMasterShop)
copy_functions(ScrollView, ClanMasterShop)

function ClanMasterShop.show(arg_22_0, arg_22_1)
	arg_22_0.vars = {}
	arg_22_0.vars.parents = arg_22_1
	arg_22_0.vars.wnd = load_dlg("shop_list", true, "wnd")
	
	if_set_visible(arg_22_0.vars.wnd, "n_shop1", false)
	
	arg_22_0.vars.scrollview = arg_22_0.vars.wnd:getChildByName("n_scrollview"):getChildByName("scrollview")
	
	var_0_1(arg_22_0.vars.scrollview, 86)
	arg_22_0:initScrollView(arg_22_0.vars.scrollview, 690, 164)
	
	function arg_22_0.vars.scrollview.scene_reload_callback()
		var_0_2(ClanMasterShop)
	end
	
	if not AccountData.clan_shop or not ClanShopData:getAllList() then
		ClanShopData:open()
	else
		ClanShopData:updateAllList()
	end
	
	return arg_22_0.vars.wnd
end

function ClanMasterShop.getScrollViewItem(arg_24_0, arg_24_1)
	arg_24_1.is_limit_button = arg_24_0.vars.DB and arg_24_0.vars.DB[arg_24_1.id] and arg_24_0.vars.DB[arg_24_1.id].limit_count
	
	return (arg_24_0:makeShopItem(arg_24_1, "wnd/shop_card.csb"))
end

function ClanMasterShop.setDB(arg_25_0)
	arg_25_0.vars.DB = {}
	
	for iter_25_0, iter_25_1 in pairs(ClanShopData:getClanMasterShopList()) do
		arg_25_0.vars.DB[iter_25_1.id] = iter_25_1
	end
end

function ClanMasterShop.reqBuy(arg_26_0, arg_26_1, arg_26_2)
	if Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clanmaster_shop") then
		query("clan_master_buy", {
			item = arg_26_1.id,
			multiply = arg_26_2 or 1,
			caller = arg_26_1.caller or "clanmastershop"
		})
	else
		balloon_message_with_sound("no_clan_unauthorized")
	end
end

function ClanMasterShop.getRestTime(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0.vars then
		return nil
	end
	
	if not arg_27_0.vars.DB then
		return nil
	end
	
	arg_27_2 = arg_27_2 or os.time()
	
	if not Clan:getClanInfoLimits()["sh:" .. arg_27_1] then
		return nil
	end
	
	if to_n(arg_27_0.vars.DB[arg_27_1].limit_count) > #Clan:getClanInfoLimits()["sh:" .. arg_27_1] then
		return nil
	end
	
	for iter_27_0 = #Clan:getClanInfoLimits()["sh:" .. arg_27_1], 1 do
		if arg_27_2 > Clan:getClanInfoLimits()["sh:" .. arg_27_1][iter_27_0] then
			Clan:getClanInfoLimits()["sh:" .. arg_27_1][iter_27_0] = nil
		end
	end
	
	local var_27_0 = Clan:getClanInfoLimits()["sh:" .. arg_27_1][1]
	
	if var_27_0 == nil then
		return nil
	end
	
	return var_27_0 - arg_27_2
end

function ClanMasterShop.getRestCoolTime(arg_28_0, arg_28_1, arg_28_2)
	arg_28_2 = arg_28_2 or os.time()
	
	if not Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1] then
		return nil
	end
	
	if to_n(arg_28_0.vars.DB[arg_28_1].limit_count) > #Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1] then
		return nil
	end
	
	for iter_28_0 = #Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1], 1 do
		if Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1][iter_28_0] and arg_28_2 > Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1][iter_28_0] then
			Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1][iter_28_0] = nil
		end
	end
	
	local var_28_0 = Clan:getClanInfoLimits()["sh:ct:" .. arg_28_1][1]
	
	if var_28_0 == nil then
		return nil
	end
	
	return var_28_0 - arg_28_2
end
