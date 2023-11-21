PetShop = {}

function PetShop.open(arg_1_0, arg_1_1, arg_1_2)
	arg_1_1 = arg_1_1 or SceneManager:getRunningPopupScene()
	arg_1_0.vars = {}
	arg_1_0.vars.wnd = load_dlg("dungeon_story_shop", true, "wnd")
	arg_1_0.vars.list = {}
	
	local var_1_0 = DB("shop_category", "pet", {
		"topbar_currency"
	})
	
	if var_1_0 then
		var_1_0 = string.split(var_1_0, ";")
	else
		var_1_0 = {
			"crystal",
			"gold",
			"stamina",
			"stigma",
			"hero1",
			"ticketnormal"
		}
	end
	
	TopBarNew:createFromPopup(T("ui_pet_shop_btn"), arg_1_0.vars.wnd, function()
		PetShop:close()
		BackButtonManager:pop()
	end, var_1_0)
	PetShopScrollView:init(arg_1_0.vars.wnd:findChildByName("scroll_view"), arg_1_2)
	
	for iter_1_0, iter_1_1 in pairs(arg_1_2) do
		table.insert(arg_1_0.vars.list, iter_1_1)
	end
	
	local var_1_1 = arg_1_0.vars.wnd:findChildByName("n_portrait")
	local var_1_2 = UIUtil:getPortraitAni("npc1111", {
		pin_sprite_position_y = 0
	})
	
	arg_1_0.vars.portrait = var_1_2
	
	local var_1_3 = arg_1_0.vars.wnd:findChildByName("talk_bg")
	
	var_1_3:setScale(0)
	UIUtil:playNPCSoundAndTextRandomly("petshop.enter", var_1_3, "disc", nil, "petshop.idle", arg_1_0.vars.portrait)
	var_1_1:addChild(var_1_2)
	if_set_visible(arg_1_0.vars.wnd, "dim", true)
	arg_1_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(300)), arg_1_0.vars.wnd, "block")
	arg_1_1:addChild(arg_1_0.vars.wnd)
	Analytics:setPopup("pet_shop")
end

function PetShop.updateTimeLimitedItems(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	PetShopScrollView:updateTimeLimitedItems()
	
	local var_3_0 = arg_3_0.vars.wnd:findChildByName("talk_bg")
	
	UIUtil:playNPCSoundAndTextRandomly("petshop.buyitem", var_3_0, "disc", nil, "petshop.idle", arg_3_0.vars.portrait)
end

function PetShop.close(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_4_0.vars.wnd, "block")
	TopBarNew:pop()
	PetHouse:toggleUI(true)
	Analytics:closePopup()
	
	arg_4_0.vars = nil
end

PetShopScrollView = {}

copy_functions(ShopCommon, PetShopScrollView)
copy_functions(ScrollView, PetShopScrollView)

function PetShopScrollView.init(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.vars = {}
	arg_5_0.vars.list = arg_5_2
	
	arg_5_0:initScrollView(arg_5_1, 700, 145)
	arg_5_0:updateList()
	arg_5_0:updateTimeLimitedItems(os.time())
end

function PetShopScrollView.getScrollViewItem(arg_6_0, arg_6_1)
	local var_6_0, var_6_1, var_6_2 = arg_6_0:GetRestCount(arg_6_1, os.time())
	
	arg_6_1.is_limit_button = var_6_0 ~= nil
	
	local var_6_3 = arg_6_0:makeShopItem(arg_6_1, "wnd/shop_card.csb")
	
	if_set_visible(var_6_3, "res", false)
	
	return var_6_3
end

function PetShopScrollView.updateList(arg_7_0)
	arg_7_0.vars.DB = {}
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.list) do
		arg_7_0.vars.DB[iter_7_1.id] = iter_7_1
	end
	
	table.sort(arg_7_0.vars.list, function(arg_8_0, arg_8_1)
		return tonumber(arg_8_0.sort) < tonumber(arg_8_1.sort)
	end)
	arg_7_0:createScrollViewItems(arg_7_0.vars.list)
end

function PetShopScrollView.reqBuy(arg_9_0, arg_9_1, arg_9_2)
	query("buy", {
		caller = "pet_shop",
		shop = "pet",
		item = arg_9_1.id,
		type = arg_9_1.type,
		multiply = arg_9_2 or 1
	})
end
