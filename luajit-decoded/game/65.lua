ShopSkin = {}

copy_functions(ScrollView, ShopSkin)

function HANDLER.shop_skin_base(arg_1_0, arg_1_1)
	if ShopSkin.vars and ShopSkin.vars.selected_skin then
		if arg_1_1 == "btn_preview" then
			ShopSkin:skillPreview()
		elseif arg_1_1 == "btn_buy" then
			ShopSkin:requestBuy()
		end
	end
end

function ShopSkin.create(arg_2_0)
	arg_2_0.vars = {}
	arg_2_0.vars.skin_list = {}
	arg_2_0.vars.wnd_skin = load_dlg("shop_skin_base", true, "wnd")
	
	return arg_2_0.vars.wnd_skin
end

function ShopSkin.skillPreview(arg_3_0)
	if arg_3_0.vars and arg_3_0.vars.selected_skin then
		startSkillPreview(arg_3_0.vars.selected_skin)
	end
end

function ShopSkin.requestBuy(arg_4_0)
	local var_4_0 = os.time()
	
	if var_4_0 < to_n(arg_4_0.vars.selected_item.start_time) or var_4_0 > to_n(arg_4_0.vars.selected_item.end_time) then
		balloon_message_with_sound("buy.invalid_sell_period.desc")
		
		return 
	end
	
	if not UIUtil:checkCurrencyDialog(arg_4_0.vars.selected_item.token, to_n(arg_4_0.vars.selected_item.price), {
		promotion_item_id = "e7_skin_50"
	}) then
		return 
	end
	
	Shop:ShowConfirmDialog(arg_4_0.vars.selected_item)
end

function ShopSkin.updateList(arg_5_0, arg_5_1)
	arg_5_0.vars.skin_list = arg_5_1
end

function ShopSkin.onSelectScrollViewItem(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:selectShopSkinItem(arg_6_1)
end

function ShopSkin.selectShopSkinItem(arg_7_0, arg_7_1)
	if not get_cocos_refid(arg_7_0.vars.wnd_skin) then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.skin_list[arg_7_1]
	
	if not var_7_0 then
		return 
	end
	
	arg_7_0.vars.selected_item = var_7_0
	arg_7_0.vars.selected_skin = string.split(var_7_0.type, "ma_")[2]
	arg_7_0.last_selected_skin_id = var_7_0.id
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.ScrollViewItems) do
		if var_7_0.id == iter_7_1.item.id then
			if_set_visible(iter_7_1.control, "select", true)
		else
			if_set_visible(iter_7_1.control, "select", false)
		end
	end
	
	local var_7_1 = arg_7_0.vars.wnd_skin:getChildByName("n_skin_bg")
	local var_7_2 = totable(var_7_0.bg)
	
	if var_7_2.img then
		if_set_visible(var_7_1, "image_bg", true)
		if_set_visible(var_7_1, "map_bg", false)
		if_set_sprite(var_7_1, "image_bg", var_7_2.img .. ".png")
	else
		if_set_visible(var_7_1, "image_bg", false)
		if_set_visible(var_7_1, "map_bg", true)
		
		local var_7_3, var_7_4 = FIELD_NEW:create(var_7_2.map)
		
		var_7_4:setViewPortPosition(var_7_2.scroll_x or 0, var_7_2.scroll_y or 0)
		var_7_4:updateViewport()
		var_7_3:setPositionY(-360)
		var_7_3:setLocalZOrder(-1)
		var_7_3:setName("@field_bg")
		
		local var_7_5 = var_7_1:getChildByName("map_bg")
		
		if get_cocos_refid(var_7_5) then
			var_7_5:removeAllChildren()
			var_7_5:addChild(var_7_3)
		end
	end
	
	local var_7_6 = DBT("character", arg_7_0.vars.selected_skin, {
		"name",
		"model_id",
		"face_id",
		"model_opt",
		"skin",
		"atlas",
		"model_id2"
	})
	
	if not var_7_6 then
		return 
	end
	
	local var_7_7 = arg_7_0.vars.wnd_skin:getChildByName("n_skin_portrait")
	local var_7_8, var_7_9 = UIUtil:getPortraitAni(var_7_6.face_id, {
		pin_sprite_position_y = true
	})
	
	if get_cocos_refid(var_7_8) then
		if not var_7_9 then
			var_7_8:setPositionY(var_7_8:getPositionY() + 400)
		end
		
		if get_cocos_refid(var_7_7) then
			var_7_7:removeAllChildren()
			var_7_7:addChild(var_7_8)
		end
	end
	
	local var_7_10 = arg_7_0.vars.wnd_skin:getChildByName("n_pos_character")
	local var_7_11 = CACHE:getModel(var_7_6.model_id, var_7_6.skin, "idle", var_7_6.atlas, var_7_6.model_opt)
	
	if get_cocos_refid(var_7_10) then
		var_7_10:removeAllChildren()
		var_7_10:addChild(var_7_11)
		
		if var_7_6.model_id2 then
			local var_7_12 = CACHE:getModel(var_7_6.model_id2, var_7_6.skin, "idle", var_7_6.atlas, var_7_6.model_opt)
			
			var_7_10:addChild(var_7_12)
			var_7_11:setPositionX(-30)
			var_7_12:setPositionX(30)
		end
	end
	
	local var_7_13, var_7_14, var_7_15, var_7_16, var_7_17, var_7_18 = DB("item_material", var_7_0.type, {
		"id",
		"name",
		"ma_type",
		"grade",
		"desc_category",
		"desc"
	})
	
	if_set(arg_7_0.vars.wnd_skin, "t_skin_grade", T(var_7_17))
	if_set(arg_7_0.vars.wnd_skin, "t_skin_name", T("shop_skin_hero_name", {
		hero_name = T(var_7_6.name),
		skin_name = T(var_7_14)
	}))
	if_set_color(arg_7_0.vars.wnd_skin, "t_skin_grade", UIUtil:getGradeColor(nil, var_7_16 or 1))
	if_set_visible(arg_7_0.vars.wnd_skin, "n_voice", var_7_16 == 5)
	
	if var_7_16 == 5 then
		local var_7_19 = arg_7_0.vars.wnd_skin:findChildByName("n_voice")
		local var_7_20 = arg_7_0.vars.wnd_skin:findChildByName("t_skin_name"):getStringNumLines()
		
		if not var_7_19.prv_pos_y then
			var_7_19.prv_pos_y = var_7_19:getPositionY()
		end
		
		local var_7_21 = -(var_7_20 - 1) * 40
		
		var_7_19:setPositionY(var_7_21 + var_7_19.prv_pos_y)
	end
	
	arg_7_0:updateBuyButton()
end

function ShopSkin.updateBuyButton(arg_8_0)
	if not arg_8_0.vars or not arg_8_0.vars.selected_item then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.selected_item
	local var_8_1 = arg_8_0.vars.wnd_skin:getChildByName("n_btn")
	local var_8_2 = os.time()
	local var_8_3 = Account:getItemCount(var_8_0.type) > 0 or var_8_0.sold_out == true
	
	if var_8_3 then
		if_set_visible(var_8_1, "btn_buy", false)
		if_set_visible(var_8_1, "n_purchased", true)
	elseif var_8_2 < to_n(var_8_0.start_time) or var_8_2 > to_n(var_8_0.end_time) then
		if_set_visible(var_8_1, "btn_buy", false)
		if_set_visible(var_8_1, "n_purchased", false)
	else
		if_set_visible(var_8_1, "btn_buy", true)
		if_set_visible(var_8_1, "n_purchased", false)
		UIUtil:getRewardIcon(nil, var_8_0.token, {
			no_frame = true,
			scale = 0.6,
			parent = var_8_1:getChildByName("n_pay_token")
		})
		if_set(var_8_1, "txt_price", comma_value(var_8_0.price))
	end
	
	local var_8_4 = var_8_0.time_visible == "y"
	
	if var_8_4 and var_8_3 and var_8_2 > to_n(var_8_0.end_time) then
		var_8_4 = false
	end
	
	if var_8_4 then
		if_set_visible(var_8_1, "n_period", true)
		if_set_visible(var_8_1, "n_info", true)
		if_set_visible(var_8_1, "_grow", true)
		if_set_visible(var_8_1, "_grow_no_txt", false)
		if_set(var_8_1, "t_period", T("sell_period_v2", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_8_0.start_time,
			end_time = var_8_0.end_time
		})))
	else
		if_set_visible(var_8_1, "n_period", false)
		if_set_visible(var_8_1, "n_info", false)
		if_set_visible(var_8_1, "_grow", false)
		if_set_visible(var_8_1, "_grow_no_txt", true)
	end
end

function ShopSkin.updateShopSkinItem(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = os.time()
	
	if arg_9_2.sold_out then
		if_set_visible(arg_9_1, "icon_badge", false)
		if_set_visible(arg_9_1, "icon_check", true)
		if_set_color(arg_9_1, "n_contents", cc.c3b(91, 91, 91))
	elseif var_9_0 < to_n(arg_9_2.start_time) or var_9_0 > to_n(arg_9_2.end_time) then
		if_set_visible(arg_9_1, "icon_badge", false)
		if_set_visible(arg_9_1, "icon_check", false)
		if_set_color(arg_9_1, "n_contents", cc.c3b(91, 91, 91))
	elseif not is_empty(arg_9_2.tag) then
		if string.find(arg_9_2.tag, ".png") then
			if_set_sprite(arg_9_1, "icon_badge", "img/" .. arg_9_2.tag)
		else
			if_set_sprite(arg_9_1, "icon_badge", "img/shop_icon_" .. arg_9_2.tag .. ".png")
		end
		
		if_set_visible(arg_9_1, "icon_badge", true)
	else
		if_set_visible(arg_9_1, "icon_badge", false)
	end
end

function ShopSkin.makeShopSkinItem(arg_10_0, arg_10_1)
	local var_10_0 = load_control("wnd/shop_skin_item.csb")
	
	var_10_0.parent_class = arg_10_0
	var_10_0.info = {
		item = arg_10_1,
		control = var_10_0
	}
	
	if_set_visible(var_10_0, "select", false)
	if_set_visible(var_10_0, "icon_noti", false)
	if_set_visible(var_10_0, "icon_check", false)
	
	local var_10_1 = string.split(arg_10_1.type, "ma_")[2]
	local var_10_2 = DB("character", var_10_1, {
		"name"
	})
	
	upgradeLabelToRichLabel(var_10_0, "txt_title")
	if_set(var_10_0, "txt_title", T("shop_skin_hero_name", {
		hero_name = T(var_10_2),
		skin_name = T(arg_10_1.name)
	}))
	
	local var_10_3 = var_10_0:getChildByName("n_item")
	local var_10_4, var_10_5, var_10_6 = DB("item_material", arg_10_1.type, {
		"grade",
		"icon",
		"desc_category"
	})
	
	var_10_4 = var_10_4 or 1
	
	replaceSprite(var_10_3, "face", var_10_5 .. "_s.png")
	
	local var_10_7 = UIUtil:getSkinGradeBorder(var_10_4)
	local var_10_8 = UIUtil:getSkinGradeBG(var_10_4)
	
	replaceSprite(var_10_3, "frame", "item/border/" .. var_10_7 .. ".png")
	replaceSprite(var_10_3, "frame_bg", "img/" .. var_10_8 .. ".png")
	
	local var_10_9 = var_10_0:findChildByName("txt_subtitle")
	
	if_set(var_10_9, nil, T(var_10_6))
	if_set_color(var_10_9, nil, UIUtil:getGradeColor(nil, var_10_4))
	arg_10_0:updateShopSkinItem(var_10_0, arg_10_1)
	
	return var_10_0
end

function ShopSkin.enterSkinShop(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1 then
		arg_11_0.vars.skin_list = arg_11_1
	end
	
	arg_11_1 = arg_11_1 or arg_11_0.vars.skin_list
	arg_11_0.vars.DB = {}
	arg_11_0.vars.skin_list = {}
	
	local var_11_0 = {}
	local var_11_1 = os.time()
	
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		local var_11_2, var_11_3, var_11_4 = Shop:GetRestCount(iter_11_1, var_11_1)
		
		if var_11_4 == "only_once" and var_11_3 and to_n(var_11_2) < 1 or Account:getItemCount(iter_11_1.type) > 0 then
			iter_11_1.sold_out = true
			iter_11_1.sort = iter_11_1.sort + 100000
		elseif var_11_3 and to_n(var_11_2) > 0 then
			iter_11_1.rest_count = var_11_2
		end
		
		if iter_11_1.sold_out == true or var_11_1 < to_n(iter_11_1.end_time) then
			table.push(arg_11_0.vars.skin_list, iter_11_1)
			
			arg_11_0.vars.DB[iter_11_1.id] = iter_11_1
		end
	end
	
	table.sort(arg_11_0.vars.skin_list, function(arg_12_0, arg_12_1)
		return tonumber(arg_12_0.sort) < tonumber(arg_12_1.sort)
	end)
	
	local var_11_5 = arg_11_0.vars.wnd_skin:getChildByName("scrollview")
	
	arg_11_0:initScrollView(var_11_5, 313, 97)
	arg_11_0:createScrollViewItems(arg_11_0.vars.skin_list)
	arg_11_0:jumpToPercent(0)
	
	local var_11_6 = arg_11_2 or arg_11_0.last_selected_skin_id
	
	if var_11_6 then
		for iter_11_2, iter_11_3 in pairs(arg_11_0.vars.skin_list) do
			if iter_11_3.type == var_11_6 or iter_11_3.id == var_11_6 then
				arg_11_0:selectShopSkinItem(iter_11_2)
				arg_11_0:jumpToPercent(iter_11_2 * 100 / #arg_11_0.vars.skin_list)
				
				return 
			end
		end
	end
	
	arg_11_0:selectShopSkinItem(1)
end

function ShopSkin.getScrollViewItem(arg_13_0, arg_13_1)
	arg_13_1.is_limit_button = arg_13_0.vars.DB and arg_13_0.vars.DB[arg_13_1.id] and arg_13_0.vars.DB[arg_13_1.id].limit_count
	
	local var_13_0 = arg_13_0:makeShopSkinItem(arg_13_1)
	
	var_13_0.guide_tag = arg_13_1.id
	
	return var_13_0
end

function ShopSkin.updateSoldOutItems(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd_skin) then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "shop" or Shop:getCurrentCategoryId() ~= "skin" or not arg_14_0.vars or not arg_14_0.vars.skin_list or not arg_14_0.ScrollViewItems then
		return 
	end
	
	local var_14_0 = os.time()
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.skin_list) do
		local var_14_1, var_14_2, var_14_3 = Shop:GetRestCount(iter_14_1, var_14_0)
		
		if var_14_3 == "only_once" and var_14_2 and to_n(var_14_1) < 1 or Account:getItemCount(iter_14_1.type) > 0 then
			iter_14_1.sold_out = true
			iter_14_1.sort = iter_14_1.sort + 100000
		elseif var_14_2 and to_n(var_14_1) > 0 then
			iter_14_1.rest_count = var_14_1
		end
	end
	
	for iter_14_2, iter_14_3 in pairs(arg_14_0.ScrollViewItems) do
		arg_14_0:updateShopSkinItem(iter_14_3.control, iter_14_3.item)
	end
	
	arg_14_0:updateBuyButton()
end
