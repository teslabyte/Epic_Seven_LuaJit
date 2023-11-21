ShopCommon = {}

function HANDLER.shop_card(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		local var_1_0 = getParentWindow(arg_1_0)
		local var_1_1
		
		if string.starts(var_1_0.info.item.type, "sp_") and DB("item_special", var_1_0.info.item.type, "type") == "devotion_select" then
			var_1_1 = var_1_0.info.item.type
		end
		
		if var_1_1 then
			ItemSelectBoxDevotion:show(var_1_1, {
				shop_item = var_1_0.info.item,
				handler = function(arg_2_0)
					var_1_0.parent_class:reqBuy(var_1_0.info.item, arg_2_0.use_count, var_1_0.info.item.shop_type, {
						item_special_id = arg_2_0.item_special_id,
						select_id = arg_2_0.select_id
					})
				end
			})
		elseif var_1_0.info.item.token == "offer_wall" then
			Stove:openCommunityUI("offer_wall")
		else
			var_1_0.parent_class:showBuyPopup(var_1_0.info)
		end
	elseif arg_1_1 == "btn_open" then
		local var_1_2 = getParentWindow(arg_1_0)
		
		var_1_2.parent_class:showSubListPopup(var_1_2.info)
	elseif arg_1_1 == "btn_open_equip" then
		local var_1_3 = getParentWindow(arg_1_0)
		
		ShopDuplEquipPopup:show(var_1_3.info)
	end
end

function HANDLER.shop_card2(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_go" then
		local var_3_0 = getParentWindow(arg_3_0)
		local var_3_1
		
		if string.starts(var_3_0.info.item.type, "sp_") and DB("item_special", var_3_0.info.item.type, "type") == "devotion_select" then
			var_3_1 = var_3_0.info.item.type
		end
		
		if var_3_1 then
			ItemSelectBoxDevotion:show(var_3_1, {
				shop_item = var_3_0.info.item,
				handler = function(arg_4_0)
					var_3_0.parent_class:reqBuy(var_3_0.info.item, arg_4_0.use_count, var_3_0.info.item.shop_type, {
						item_special_id = arg_4_0.item_special_id,
						select_id = arg_4_0.select_id
					})
				end
			})
		elseif var_3_0.info.item.token == "offer_wall" then
			Stove:openCommunityUI("offer_wall")
		else
			var_3_0.parent_class:showBuyPopup(var_3_0.info)
		end
	elseif arg_3_1 == "btn_open" then
		local var_3_2 = getParentWindow(arg_3_0)
		
		var_3_2.parent_class:showSubListPopup(var_3_2.info)
	end
end

function HANDLER.shop_card_group(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_go" then
		local var_5_0 = getParentWindow(arg_5_0)
		
		if var_5_0.info.item.token == "offer_wall" then
			Stove:openCommunityUI("offer_wall")
		else
			var_5_0.parent_class:showBuyPopup(var_5_0.info)
		end
	end
end

function HANDLER.shop_popup_buy_expand2(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_buy" then
		local var_6_0 = arg_6_0.item
		local var_6_1 = arg_6_0.multiply
		local var_6_2 = arg_6_0.parent_self
		
		if var_6_1 and var_6_0 then
			Dialog:close("shop_popup_buy_expand2")
			var_6_2:reqBuy(var_6_0, var_6_1)
		end
	elseif arg_6_1 == "btn_cancel" then
		Dialog:close("shop_popup_buy_expand2")
	end
end

function checkIapInitializeCompleteAndBalloonMessage()
	if Stove.enable then
		return StoveIap:checkInitializeCompleteAndBalloonMessage()
	elseif Zlong.enable then
		return ZlongIap:checkInitializeCompleteAndBalloonMessage()
	else
		return true
	end
end

function waitIapInitializeComplete(arg_8_0)
	if Stove.enable then
		StoveIap:waitInitializeComplete(arg_8_0)
	elseif Zlong.enable then
		ZlongIap:waitInitializeComplete(arg_8_0)
	else
		arg_8_0()
	end
end

function getIapProductInfo(arg_9_0)
	if Stove.enable then
		return StoveIap:getProductInfo(arg_9_0)
	elseif Zlong.enable then
		return ZlongIap:getProductInfo(arg_9_0)
	else
		return nil
	end
end

function getIapProductPriceString(arg_10_0, arg_10_1)
	if Stove.enable then
		return StoveIap:getProductPriceString(arg_10_0)
	elseif Zlong.enable then
		return ZlongIap:getProductPriceString(arg_10_0)
	else
		return arg_10_1
	end
end

function startIapBilling(arg_11_0)
	if Stove.enable then
		StoveIap:startBilling(arg_11_0)
	elseif Zlong.enable then
		ZlongIap:startBilling(arg_11_0)
	end
end

function makeCurrencyString(arg_12_0, arg_12_1)
	if arg_12_1 == "KRW" and getUserLanguage() == "ko" then
		return comma_value(arg_12_0) .. "원"
	elseif arg_12_1 == "EUR" then
		return comma_value(arg_12_0) .. "€"
	else
		return arg_12_1 .. " " .. comma_value(arg_12_0)
	end
end

function ShopCommon.getCategoryShopItemList(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = {}
	local var_13_1 = os.time()
	
	for iter_13_0, iter_13_1 in pairs(AccountData.shop) do
		if iter_13_0 == arg_13_1 then
			for iter_13_2, iter_13_3 in pairs(iter_13_1) do
				if arg_13_0:addShopItem(iter_13_0, iter_13_3, arg_13_2) then
					table.push(var_13_0, iter_13_3)
				end
			end
		end
	end
	
	return var_13_0
end

function ShopCommon.getCategoryShopItems(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.AllList[arg_14_1] or {}) do
		local var_14_1 = true
		
		if arg_14_2 then
			if iter_14_1.select_id == arg_14_2 then
				if iter_14_1.select_item == "y" then
					var_14_1 = false
				end
			else
				var_14_1 = false
			end
		elseif iter_14_1.select_id and iter_14_1.select_item ~= "y" then
			var_14_1 = false
		end
		
		if var_14_1 then
			table.push(var_14_0, iter_14_1)
		end
	end
	
	return var_14_0
end

function ShopCommon.updateAvailableCategorySelectItems(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0:getCategoryShopItems(arg_15_1, arg_15_2)
	local var_15_1 = 0
	local var_15_2 = os.time()
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		local var_15_3, var_15_4, var_15_5 = arg_15_0:GetRestCount(iter_15_1, var_15_2)
		
		if var_15_5 == "only_once" and var_15_4 and to_n(var_15_3) < 1 then
			iter_15_1.sold_out = true
			var_15_1 = var_15_1 + 1
			
			if iter_15_1.sort < 100000 then
				iter_15_1.sort = iter_15_1.sort + 100000
			end
		end
	end
	
	return var_15_0, var_15_1
end

function ShopCommon.isMultiPrice(arg_16_0, arg_16_1)
	local var_16_0 = string.split(tostring(arg_16_1.price), ";")
	local var_16_1 = to_n(var_16_0[#var_16_0])
	
	return #var_16_0 > 1
end

function ShopCommon.updatePayPrice(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_3 = arg_17_3 or 1
	
	local var_17_0 = string.split(tostring(arg_17_2.price), ";")
	local var_17_1 = to_n(var_17_0[#var_17_0])
	
	if #var_17_0 > 1 then
		local var_17_2 = Account:getLimitCount("sh:" .. arg_17_2.id)
		
		var_17_1 = to_n(var_17_0[math.min(#var_17_0, var_17_2 + 1)])
	end
	
	if var_17_1 == 0 then
		if_set(arg_17_1, "txt_price", T("shop_price_free"))
	else
		if_set(arg_17_1, "txt_price", comma_value(var_17_1 * arg_17_3))
	end
end

function ShopCommon.UpdatePayIcon(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_2.is_limit_button
	local var_18_1 = arg_18_1:getChildByName("n_pay_token")
	
	if_set_visible(arg_18_1, "n_group", false)
	if_set_visible(arg_18_1, "btn_go", true)
	if_set_visible(arg_18_1, "n_cost", true)
	
	arg_18_3 = arg_18_3 or 1
	
	local var_18_2 = false
	
	if arg_18_2.equip_select == "y" then
		local var_18_3 = to_n(Account:getLimitCount("ds:eqr_" .. arg_18_2.category))
		local var_18_4 = arg_18_2.equip_select_refresh_max or 30
		
		var_18_0 = false
		
		if_set_visible(arg_18_1, "btn_go", false)
		if_set_visible(arg_18_1, "n_cost", false)
		
		local var_18_5 = arg_18_1:getChildByName("n_group")
		
		var_18_5:setVisible(true)
		arg_18_1:getChildByName("btn_open"):setName("btn_open_equip")
		if_set(var_18_5, "txt_group", T("shop_char_coin_refresh", {
			num1 = math.max(var_18_4 - var_18_3, 0),
			num2 = var_18_4
		}))
		if_set(var_18_5, "txt", T("shop_char_coin_itemlist"))
	elseif arg_18_2.token == "cash" then
		var_18_2 = arg_18_2.category == "crystal"
		
		if var_18_1 then
			if_set_visible(arg_18_1, "icon_pay", false)
		end
		
		if_set(arg_18_1, "txt_price", getIapProductPriceString(arg_18_2.id, comma_value(arg_18_2.price)))
	elseif arg_18_2.token == "offer_wall" then
		if var_18_1 then
			if_set_visible(arg_18_1, "icon_pay", false)
		end
		
		if_set(arg_18_1, "txt_price", T("ui_offer_wall_token_free"))
	else
		var_18_2 = true
		
		if var_18_1 then
			if DB("item_material", arg_18_2.token, "ma_type") == "cp" then
				UIUtil:getRewardIcon(nil, arg_18_2.token, {
					no_frame = true,
					scale = 0.6,
					no_tooltip = true,
					parent = arg_18_1:getChildByName("n_pay_token")
				})
			else
				UIUtil:getRewardIcon(nil, arg_18_2.token, {
					no_frame = true,
					scale = 0.6,
					parent = arg_18_1:getChildByName("n_pay_token")
				})
			end
		end
		
		arg_18_0:updatePayPrice(arg_18_1, arg_18_2, arg_18_3)
	end
	
	if var_18_0 then
		if_set_visible(arg_18_1, "n_counter", true)
		if_set_visible(arg_18_1, "txt_count_info", true)
	else
		if_set_visible(arg_18_1, "n_counter", false)
		if_set_visible(arg_18_1, "txt_count_info", false)
		
		local var_18_6 = arg_18_1:getChildByName("btn_go")
		
		if get_cocos_refid(var_18_6) then
			local var_18_7 = var_18_6:getChildByName("txt_buy")
			
			if get_cocos_refid(var_18_7) and tolua.type(var_18_7) ~= "ccui.RichText" then
				var_18_7:setTextHorizontalAlignment(1)
			end
			
			if get_cocos_refid(var_18_7) and var_18_2 and not var_18_7.origin_x then
				var_18_7.origin_x = var_18_7:getPositionX()
				
				var_18_7:setPositionX(var_18_7.origin_x - 41)
			end
		end
	end
end

function ShopCommon.updatePayIcons(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_1:getChildByName("n_pay_token")
	
	if arg_19_2 == "cash" then
		if var_19_0 then
			if_set_visible(arg_19_1, "icon_pay", false)
		end
		
		local var_19_1 = getIapProductPriceString(item.id, T("cash_price", "\\ #price#", {
			price = comma_value(arg_19_3)
		}))
		
		if_set(arg_19_1, "txt_price", var_19_1)
	elseif arg_19_2 == "offer_wall" then
		if var_19_0 then
			if_set_visible(arg_19_1, "icon_pay", false)
		end
		
		if_set(arg_19_1, "txt_price", T("ui_offer_wall_token_free"))
	else
		if var_19_0 then
			if DB("item_material", arg_19_2, "ma_type") == "cp" then
				UIUtil:getRewardIcon(nil, arg_19_2, {
					no_frame = true,
					scale = 0.6,
					no_tooltip = true,
					parent = arg_19_1:getChildByName("n_pay_token")
				})
			else
				UIUtil:getRewardIcon(nil, arg_19_2, {
					no_frame = true,
					scale = 0.6,
					parent = arg_19_1:getChildByName("n_pay_token")
				})
			end
		end
		
		if_set(arg_19_1, "txt_price", comma_value(arg_19_3))
	end
end

function ShopCommon.UpdatePayIcon2(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2.is_limit_button
	local var_20_1 = arg_20_1:getChildByName("btn_go")
	local var_20_2 = arg_20_1:getChildByName("n_btn_counter")
	
	if arg_20_2.select_item == "y" then
		local var_20_3 = arg_20_1:getChildByName("n_group")
		
		var_20_3:setVisible(true)
		if_set_visible(arg_20_1, "n_cost", false)
		if_set_visible(arg_20_1, "n_cost2", false)
		if_set_visible(arg_20_1, "n_counter", false)
		if_set_visible(arg_20_1, "txt_count_info", false)
		var_20_1:setVisible(false)
		
		local var_20_4, var_20_5 = arg_20_0:updateAvailableCategorySelectItems(arg_20_2.category, arg_20_2.select_id)
		local var_20_6 = to_n(#var_20_4) - to_n(var_20_5)
		
		if var_20_6 < 1 then
			if_set(var_20_3, "txt_group", T("shop_package_b_purchased"))
		else
			if_set(var_20_3, "txt_group", T("shop_select_remain_count", {
				count = var_20_6
			}))
		end
	else
		if_set_visible(arg_20_1, "n_group", false)
		if_set_visible(arg_20_1, "btn_go", true)
		
		local var_20_7
		local var_20_8
		local var_20_9
		local var_20_10 = true
		
		if arg_20_2.token2 and to_n(arg_20_2.price2) > 0 then
			if_set_visible(arg_20_1, "n_cost", false)
			
			local var_20_11 = arg_20_1:getChildByName("n_cost2")
			
			var_20_11:setVisible(true)
			arg_20_0:updatePayIcons(var_20_11:getChildByName("n_token1"), arg_20_2.token, arg_20_2.price)
			arg_20_0:updatePayIcons(var_20_11:getChildByName("n_token2"), arg_20_2.token2, arg_20_2.price2)
			
			if var_20_1 and get_cocos_refid(var_20_1) then
				var_20_1:setPositionY(20)
			end
			
			if var_20_2 and get_cocos_refid(var_20_2) then
				var_20_2:setPositionY(4)
			end
		else
			if_set_visible(arg_20_1, "n_cost2", false)
			
			local var_20_12 = arg_20_1:getChildByName("n_cost")
			
			var_20_12:setVisible(true)
			arg_20_0:updatePayIcons(var_20_12:getChildByName("n_token1"), arg_20_2.token, arg_20_2.price)
			
			if var_20_1 and get_cocos_refid(var_20_1) then
				var_20_1:setPositionY(40)
			end
			
			if var_20_2 and get_cocos_refid(var_20_2) then
				var_20_2:setPositionY(24)
			end
		end
		
		if var_20_0 then
			if_set_visible(arg_20_1, "n_counter", true)
			if_set_visible(arg_20_1, "txt_count_info", true)
		else
			if_set_visible(arg_20_1, "n_counter", false)
			if_set_visible(arg_20_1, "txt_count_info", false)
			
			local var_20_13 = arg_20_1:getChildByName("btn_go")
			
			if get_cocos_refid(var_20_13) then
				local var_20_14 = var_20_13:getChildByName("txt_buy")
				
				if get_cocos_refid(var_20_14) and tolua.type(var_20_14) ~= "ccui.RichText" then
					var_20_14:setTextHorizontalAlignment(1)
				end
				
				if get_cocos_refid(var_20_14) and var_20_10 and not var_20_14.origin_x then
					var_20_14.origin_x = var_20_14:getPositionX()
					
					var_20_14:setPositionX(var_20_14.origin_x - 41)
				end
			end
		end
	end
end

function ShopCommon.makeShopItem(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_3 = arg_21_3 or {}
	
	local var_21_0 = load_control(arg_21_2)
	
	if arg_21_1.type and string.find(arg_21_1.type, "pet") then
		if_set_visible(var_21_0, "slot", false)
	end
	
	if_set_visible(var_21_0:getChildByName("n_custom_badge"), "n_shop_titlebg", false)
	
	arg_21_3.resize_name = true
	
	arg_21_0:SetItemIcon(arg_21_1, var_21_0, arg_21_3)
	arg_21_0:UpdatePayIcon(var_21_0, arg_21_1)
	
	var_21_0.parent_class = arg_21_0
	var_21_0.info = {
		item = arg_21_1,
		control = var_21_0,
		opts = arg_21_3
	}
	
	return var_21_0
end

function ShopCommon.makeShopItem2(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = load_control(arg_22_2)
	
	if_set_visible(var_22_0:getChildByName("n_custom_badge"), "n_shop_titlebg", false)
	arg_22_0:SetItemIcon(arg_22_1, var_22_0, {
		multi_currency = true,
		resize_name = true
	})
	arg_22_0:UpdatePayIcon2(var_22_0, arg_22_1)
	
	var_22_0.parent_class = arg_22_0
	var_22_0.info = {
		item = arg_22_1,
		control = var_22_0,
		opts = arg_22_3
	}
	
	return var_22_0
end

function ShopCommon.getRestCoolTime(arg_23_0, arg_23_1, arg_23_2)
	arg_23_2 = arg_23_2 or os.time()
	
	local var_23_0 = AccountData.limits["sh:ct:" .. arg_23_1]
	
	if not var_23_0 then
		return nil
	end
	
	if to_n(arg_23_0.vars.DB[arg_23_1].limit_count) > var_23_0.count then
		return nil
	end
	
	if arg_23_2 > var_23_0.expire_tm then
		AccountData.limits["sh:ct:" .. arg_23_1] = nil
		
		return nil
	end
	
	local var_23_1 = var_23_0.expire_tm
	
	if var_23_1 == nil then
		return nil
	end
	
	return var_23_1 - arg_23_2
end

function ShopCommon.getRestTime(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars then
		return nil
	end
	
	if not arg_24_0.vars.DB then
		return nil
	end
	
	arg_24_2 = arg_24_2 or os.time()
	
	local var_24_0 = AccountData.limits["sh:" .. arg_24_1]
	
	if not var_24_0 then
		return nil
	end
	
	if to_n(arg_24_0.vars.DB[arg_24_1].limit_count) > var_24_0.count then
		return nil
	end
	
	if arg_24_2 > var_24_0.expire_tm then
		AccountData.limits["sh:" .. arg_24_1] = nil
		
		return nil
	end
	
	local var_24_1 = var_24_0.expire_tm
	
	if var_24_1 == nil then
		return nil
	end
	
	return var_24_1 - arg_24_2
end

function ShopCommon.getRestClanBuffTime(arg_25_0, arg_25_1, arg_25_2)
	arg_25_2 = arg_25_2 or os.time()
	
	local var_25_0 = arg_25_1.type
	local var_25_1 = DB("item_special", var_25_0, "value")
	local var_25_2 = (Account:getActiveClanBuffs() or {})[var_25_1]
	local var_25_3 = DB("account_skill", var_25_1, "time")
	local var_25_4 = arg_25_1.limit_period_data * 60
	local var_25_5
	
	if var_25_2 then
		local var_25_6 = var_25_2.expire_time - arg_25_2
		
		if var_25_6 > 0 and var_25_4 < var_25_6 + var_25_3 * 60 then
			var_25_5 = var_25_6 + var_25_3 * 60 - var_25_4
		end
	end
	
	return var_25_5
end

function ShopCommon.showSubListPopup(arg_26_0, arg_26_1)
	if UIUtil:checkEquipInven() then
		local var_26_0, var_26_1 = arg_26_0:updateAvailableCategorySelectItems(arg_26_1.item.category, arg_26_1.item.select_id)
		
		ShopPopupShop:show(arg_26_1.item, var_26_0)
	end
end

function ShopCommon.showBuyPopup(arg_27_0, arg_27_1)
	SoundEngine:play("event:/ui/ok")
	
	if arg_27_1.item.sold_out then
		balloon_message_with_sound("sold_out")
		
		return 
	end
	
	local var_27_0
	local var_27_1
	
	if arg_27_1.item.limit_cooltime then
		var_27_1 = arg_27_0:getRestCoolTime(arg_27_1.item.id)
	elseif arg_27_1.item.limit_period == "clan_buff" then
		var_27_0 = arg_27_0:getRestClanBuffTime(arg_27_1.item)
	else
		var_27_0 = arg_27_0:getRestTime(arg_27_1.item.id)
	end
	
	if var_27_0 and var_27_0 > 0 or var_27_1 and var_27_1 > 0 then
		if arg_27_1.item.limit_period == "only_once" or arg_27_1.item.gacha_id or arg_27_1.item.buy_once then
			balloon_message_with_sound("sold_out")
		else
			balloon_message_with_sound("notyet_buy")
		end
	else
		arg_27_0:ShowConfirmDialog(arg_27_1.item, nil, arg_27_1.opts)
	end
end

function ShopCommon.ResizeItemName(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_2:getChildByName("txt_shop_type")
	
	if not get_cocos_refid(var_28_0) then
		return 
	end
	
	local var_28_1 = arg_28_2:getChildByName("txt_shop_name")
	
	if not get_cocos_refid(var_28_1) then
		return 
	end
	
	local var_28_2 = arg_28_2:getChildByName("txt_count_info")
	
	if not get_cocos_refid(var_28_2) then
		return 
	end
	
	local var_28_3 = var_28_1:getParent()
	
	if not get_cocos_refid(var_28_3) then
		return 
	end
	
	local var_28_4 = var_28_3:getParent()
	
	if not get_cocos_refid(var_28_4) then
		return 
	end
	
	local var_28_5 = 100
	
	if_set_opacity(var_28_0, nil, 0)
	UIAction:Add(LOG(FADE_IN(var_28_5)), var_28_0, "FADE_IN")
	if_set_opacity(var_28_1, nil, 0)
	UIAction:Add(LOG(FADE_IN(var_28_5)), var_28_1, "FADE_IN")
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		if get_cocos_refid(var_28_1) then
			var_28_0:setAnchorPoint(0, 1)
			var_28_1:setAnchorPoint(0, 1)
			var_28_2:setAnchorPoint(0, 1)
			var_28_2:retain()
			var_28_2:removeFromParent()
			var_28_3:addChild(var_28_2)
			var_28_2:setPositionX(var_28_1:getPositionX())
			var_28_2:release()
			
			local var_29_0 = var_28_0:getTextBoxSize().height * var_28_0:getScaleY()
			local var_29_1 = var_28_1:getTextBoxSize().height * var_28_1:getScaleY()
			local var_29_2 = (var_28_2:isVisible() and var_28_2:getTextBoxSize().height or 0) * var_28_2:getScaleY()
			local var_29_3 = 11 * var_28_0:getScaleY()
			local var_29_4 = 13 * var_28_1:getScaleY()
			local var_29_5 = var_29_0 + var_29_3 + var_29_1 + var_29_4 + var_29_2
			local var_29_6 = (var_28_2:isVisible() and 70 or 64) - var_29_5 * 0.5
			
			if var_28_4.is_random_shop then
				var_29_6 = (var_28_4:getContentSize().height - var_29_5) * 0.5 - var_28_3:getPositionY()
			end
			
			local var_29_7 = var_29_2 + var_29_6
			local var_29_8 = var_29_7 + var_29_1 + var_29_4
			local var_29_9 = var_29_8 + var_29_0 + var_29_3
			
			var_28_0:setPositionY(var_29_9)
			var_28_1:setPositionY(var_29_8)
			var_28_2:setPositionY(var_29_7)
		end
	end)), "delay")
end

function ShopCommon.ResizeItemName2(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_2:getChildByName("txt_shop_type")
	
	if not get_cocos_refid(var_30_0) then
		return 
	end
	
	local var_30_1 = arg_30_2:getChildByName("txt_shop_name")
	
	if not get_cocos_refid(var_30_1) then
		return 
	end
	
	local var_30_2 = arg_30_2:getChildByName("txt_count_info")
	
	if not get_cocos_refid(var_30_2) then
		return 
	end
	
	local var_30_3 = 100
	
	if_set_opacity(var_30_0, nil, 0)
	UIAction:Add(LOG(FADE_IN(var_30_3)), var_30_0, "FADE_IN")
	if_set_opacity(var_30_1, nil, 0)
	UIAction:Add(LOG(FADE_IN(var_30_3)), var_30_1, "FADE_IN")
	UIAction:Add(SEQ(DELAY(1), CALL(function()
		if get_cocos_refid(var_30_1) then
			var_30_0:setAnchorPoint(0, 1)
			var_30_1:setAnchorPoint(0, 1)
			var_30_2:setAnchorPoint(0, 1)
			
			local var_31_0 = var_30_1:getParent()
			
			var_30_2:retain()
			var_30_2:removeFromParent()
			var_31_0:addChild(var_30_2)
			var_30_2:setPositionX(var_30_1:getPositionX())
			var_30_2:release()
			
			local var_31_1 = var_30_0:getTextBoxSize().height * var_30_0:getScaleY()
			local var_31_2 = var_30_1:getTextBoxSize().height * var_30_1:getScaleY()
			local var_31_3 = (var_30_2:isVisible() and var_30_2:getTextBoxSize().height or 0) * var_30_2:getScaleY()
			local var_31_4 = 11 * var_30_0:getScaleY()
			local var_31_5 = 13 * var_30_1:getScaleY()
			local var_31_6 = var_31_1 + var_31_4 + var_31_2 + var_31_5 + var_31_3
			local var_31_7 = var_31_3 + (188 - var_31_6) * 0.5
			local var_31_8 = var_31_7 + var_31_2 + var_31_5
			local var_31_9 = var_31_8 + var_31_1 + var_31_4
			
			var_30_0:setPositionY(var_31_9)
			var_30_1:setPositionY(var_31_8)
			var_30_2:setPositionY(var_31_7)
		end
	end)), "delay")
end

function ShopCommon.SetItemIcon(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_3 = arg_32_3 or {}
	
	if_set_visible(arg_32_2, "n_reward_item", false)
	if_set_visible(arg_32_2, "n_item_art_icon", false)
	if_set_visible(arg_32_2, "n_mob_icon", false)
	if_set_visible(arg_32_2, "n_pet_icon", false)
	if_set_visible(arg_32_2, "flag_badge", false)
	
	if tolua:type(arg_32_2:getChildByName("txt_shop_name")) ~= "ccui.RichText" then
		upgradeLabelToRichLabel(arg_32_2, "txt_shop_name")
	end
	
	if arg_32_1.custom_tag then
		if_set_visible(arg_32_2, "n_custom_badge", true)
		
		local var_32_0 = arg_32_2:getChildByName("n_custom_badge")
		
		if var_32_0 then
			if string.starts(arg_32_1.custom_tag, "pvpseason:") then
				if_set_visible(var_32_0, "icon_badge", false)
				if_set_visible(var_32_0, "n_shop_titlebg", true)
				if_set_visible(var_32_0, "n_shop_titlebg_1line", false)
				
				local var_32_1 = string.split(arg_32_1.custom_tag, ":")
				local var_32_2 = var_32_0:getChildByName("n_shop_titlebg")
				
				if var_32_2 then
					if get_cocos_refid(var_32_2) then
						var_32_2:setPositionY(var_32_2:getPositionY() + 13)
					end
					
					local var_32_3 = arg_32_2:getChildByName("n_base")
					local var_32_4 = var_32_3:getChildByName("icon_item")
					
					if get_cocos_refid(var_32_4) then
						var_32_4:setPositionY(var_32_4:getPositionY() + 19)
					end
					
					local var_32_5 = var_32_3:getChildByName("n_reward_item")
					
					if get_cocos_refid(var_32_5) then
						var_32_5:setPositionY(var_32_5:getPositionY() + 19)
					end
					
					local var_32_6 = var_32_3:getChildByName("n_item_art_icon")
					
					if get_cocos_refid(var_32_6) then
						var_32_6:setPositionY(var_32_6:getPositionY() + 13)
					end
					
					local var_32_7 = var_32_3:getChildByName("n_mob_icon")
					
					if get_cocos_refid(var_32_7) then
						var_32_7:setPositionY(var_32_7:getPositionY() + 13)
					end
					
					local var_32_8 = var_32_3:getChildByName("n_pet_icon")
					
					if get_cocos_refid(var_32_8) then
						var_32_8:setPositionY(var_32_8:getPositionY() + 13)
					end
					
					local var_32_9
					
					if UIUtil:isChangeSeasonLabelPosition() then
						var_32_9 = var_32_2:getChildByName("n_season_2/2")
						
						var_32_9:setVisible(true)
						if_set_visible(var_32_2, "n_season_1/2", false)
					else
						var_32_9 = var_32_2:getChildByName("n_season_1/2")
						
						var_32_9:setVisible(true)
						if_set_visible(var_32_2, "n_season_2/2", false)
					end
					
					if_set(var_32_9, "txt", T(var_32_1[2]))
					if_set(var_32_9, "txt_season", T("pvp_season_label"))
					if_set_visible(var_32_0, "period_badge", false)
				end
			elseif string.starts(arg_32_1.custom_tag, "texttag") then
				if_set_visible(var_32_0, "icon_badge", false)
				if_set_visible(var_32_0, "n_shop_titlebg", false)
				if_set_visible(var_32_0, "n_shop_titlebg_1line", true)
				
				local var_32_10 = string.split(arg_32_1.custom_tag, ":")
				local var_32_11 = var_32_0:getChildByName("n_shop_titlebg_1line")
				
				if_set(var_32_11, "txt", T(var_32_10[2]))
			else
				if_set_visible(var_32_0, "icon_badge", true)
				if_set_visible(var_32_0, "n_shop_titlebg", false)
				if_set_visible(var_32_0, "n_shop_titlebg_1line", false)
				
				local var_32_12 = arg_32_2:getChildByName("n_base")
				
				if get_cocos_refid(var_32_12) then
					local var_32_13 = var_32_12:getChildByName("icon_item")
					
					if get_cocos_refid(var_32_13) and get_cocos_refid(var_32_13) then
						var_32_13:setPositionY(var_32_13:getPositionY() + 6)
					end
				end
				
				if arg_32_3.use_flag_badge then
					local var_32_14 = arg_32_2:getChildByName("flag_badge")
					
					if get_cocos_refid(var_32_14) then
						if_set_visible(var_32_14, nil, true)
						if_set_sprite(var_32_14, nil, "img/" .. arg_32_1.custom_tag .. ".png")
					end
				else
					if_set_sprite(var_32_0, "icon_badge", "img/" .. arg_32_1.custom_tag .. ".png")
				end
			end
			
			if_set_visible(var_32_0, "priceup_badge", arg_32_0:isMultiPrice(arg_32_1))
			if_set_visible(var_32_0, "period_badge", arg_32_1.is_timelimited == "y")
			if_set_visible(var_32_0, "pickup_badge", arg_32_1.gacha_id)
		end
	else
		local var_32_15 = arg_32_2:getChildByName("n_custom_badge")
		
		if var_32_15 then
			if arg_32_0:isMultiPrice(arg_32_1) then
				var_32_15:setVisible(true)
				if_set_visible(var_32_15, "icon_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg", false)
				if_set_visible(var_32_15, "priceup_badge", true)
				if_set_visible(var_32_15, "period_badge", false)
				if_set_visible(var_32_15, "pickup_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg_1line", false)
			elseif arg_32_1.is_timelimited == "y" then
				var_32_15:setVisible(true)
				if_set_visible(var_32_15, "icon_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg", false)
				if_set_visible(var_32_15, "priceup_badge", false)
				if_set_visible(var_32_15, "period_badge", true)
				if_set_visible(var_32_15, "pickup_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg_1line", false)
			elseif arg_32_1.gacha_id then
				var_32_15:setVisible(true)
				if_set_visible(var_32_15, "icon_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg", false)
				if_set_visible(var_32_15, "priceup_badge", false)
				if_set_visible(var_32_15, "period_badge", false)
				if_set_visible(var_32_15, "pickup_badge", true)
				if_set_visible(var_32_15, "n_shop_titlebg_1line", false)
			elseif arg_32_1.festival_day then
				var_32_15:setVisible(true)
				if_set_visible(var_32_15, "icon_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg", false)
				if_set_visible(var_32_15, "priceup_badge", false)
				if_set_visible(var_32_15, "period_badge", true)
				if_set_visible(var_32_15, "pickup_badge", false)
				if_set_visible(var_32_15, "n_shop_titlebg_1line", true)
				
				local var_32_16 = var_32_15:getChildByName("n_shop_titlebg_1line")
				
				if_set(var_32_16, "txt", T("fm_shop_daily"))
			else
				if_set_visible(arg_32_2, "n_custom_badge", false)
			end
		else
			if_set_visible(arg_32_2, "n_custom_badge", false)
		end
	end
	
	local var_32_17 = DB("equip_item", arg_32_1.type, "type")
	
	if arg_32_1.image and var_32_17 ~= "artifact" then
		if_set_sprite(arg_32_2, "icon_item", "shop/" .. arg_32_1.image .. ".png")
		if_set_visible(arg_32_2, "n_stars", false)
		if_set(arg_32_2, "txt_shop_name", T(arg_32_1.name))
		if_set_visible(arg_32_2, "badge_free", arg_32_1.token == "offer_wall")
		
		if arg_32_1.type and arg_32_1.type ~= "gacha_start" and not string.starts(arg_32_1.type, "gacha_story") and arg_32_1.type ~= "gacha_spdash" then
			arg_32_1.data = arg_32_1.data or {}
			
			if Material_Tooltip:isPopupExist(arg_32_1.type) and (string.starts(arg_32_1.type, "to_") or string.starts(arg_32_1.type, "ma_")) then
				WidgetUtils:setupTooltipAndPopup({
					control = arg_32_2.c.icon_item,
					creator = function(arg_33_0)
						if arg_33_0 then
							return Material_Tooltip:getMaterialTooltip(arg_32_2.c.icon_item, arg_32_1.type, {})
						else
							local var_33_0 = DB("equip_item", arg_32_1.type, "stone") == "y"
							local var_33_1 = DB("equip_item", arg_32_1.type, "type") == "artifact"
							local var_33_2
							local var_33_3
							
							if var_33_0 or var_33_1 then
								var_33_2 = arg_32_1.data.g
								var_33_3 = arg_32_1.data.op
							end
							
							return ItemTooltip:getItemTooltip({
								code = arg_32_1.type,
								grade = var_33_2,
								equip_stat = var_33_3
							})
						end
					end,
					event_name = arg_32_1.type
				})
			else
				WidgetUtils:setupTooltip({
					control = arg_32_2.c.icon_item,
					creator = function()
						local var_34_0 = DB("equip_item", arg_32_1.type, "stone") == "y"
						local var_34_1 = DB("equip_item", arg_32_1.type, "type") == "artifact"
						local var_34_2
						local var_34_3
						local var_34_4
						
						if var_34_0 or var_34_1 then
							var_34_2 = arg_32_1.data.g
							var_34_4 = arg_32_1.data.op
						end
						
						local var_34_5 = ItemTooltip:getItemTooltip({
							code = arg_32_1.type,
							grade = var_34_2,
							equip_stat = var_34_4
						})
						
						if not var_34_0 and not var_34_1 then
							local var_34_6 = var_34_5:getChildByName("txt_type")
							local var_34_7 = var_34_6:getContentSize()
							local var_34_8 = 238
							
							if var_34_8 < var_34_7.width then
								local var_34_9 = math.ceil(var_34_7.width / var_34_8)
								
								var_34_6:setTextAreaSize({
									width = var_34_8,
									height = var_34_7.height * var_34_9
								})
								var_34_6:setPositionY(35)
								var_34_5:getChildByName("txt_name"):setPositionY(32)
							end
						end
						
						return var_34_5
					end
				})
			end
		end
	else
		arg_32_1.data = arg_32_1.data or {}
		
		local var_32_18
		
		if to_n(arg_32_1.value) >= 1 and not string.starts(arg_32_1.type, "e") then
			var_32_18 = arg_32_1.value
		end
		
		local var_32_19
		
		if DB("character", arg_32_1.type, "face_id") then
			var_32_19 = arg_32_1.type
		elseif string.starts(arg_32_1.type, "sp_summon_") then
			local var_32_20 = DB("item_special", arg_32_1.type, {
				"value"
			})
			
			if DB("character", var_32_20, "face_id") then
				var_32_19 = var_32_20
			end
		end
		
		if var_32_19 then
			local var_32_21, var_32_22 = DB("character", var_32_19, {
				"name",
				"grade"
			})
			
			if_set_visible(arg_32_2, "slot", false)
			if_set_visible(arg_32_2, "txt_shop_type", false)
			if_set_visible(arg_32_2, "n_stars", false)
			if_set(arg_32_2, "txt_shop_name", T(var_32_21))
			
			local var_32_23 = UIUtil:getRewardIcon("c", var_32_19, {
				grade = var_32_22
			})
			
			var_32_23:setAnchorPoint(0.5, 0.5)
			if_set_visible(arg_32_2, "n_mob_icon", true)
			
			local var_32_24 = arg_32_2:getChildByName("n_mob_icon")
			
			if not get_cocos_refid(var_32_24) then
				if_set_visible(arg_32_2, "n_reward_item", true)
				
				var_32_24 = arg_32_2:getChildByName("n_item_pos")
			end
			
			var_32_24:setVisible(true)
			var_32_24:addChild(var_32_23)
		elseif DB("pet_character", arg_32_1.type, "id") then
			if_set_visible(arg_32_2, "n_stars", false)
			
			arg_32_1.data = arg_32_1.data or {}
			
			local var_32_25
			local var_32_26 = UIUtil:getRewardIcon(arg_32_1.value, arg_32_1.type, {
				no_resize_name = true,
				show_name = true,
				detail = true,
				grade = arg_32_1.data.g,
				count = var_32_18,
				scale = var_32_25,
				txt_name = arg_32_2:getChildByName("txt_shop_name"),
				txt_type = arg_32_2:getChildByName("txt_shop_type")
			})
			local var_32_27 = arg_32_2:getChildByName("n_pet_icon")
			
			if not get_cocos_refid(var_32_27) then
				if_set_visible(arg_32_2, "n_reward_item", true)
				
				var_32_27 = arg_32_2:getChildByName("n_item_pos")
			end
			
			var_32_27:setVisible(true)
			var_32_27:addChild(var_32_26)
		elseif ItemMaterial:isFragment(arg_32_1.type) then
			if_set_visible(arg_32_2, "n_reward_item", true)
			if_set_visible(arg_32_2, "n_stars", false)
			if_set_visible(arg_32_2, "slot", false)
			
			local var_32_28 = UIUtil:getRewardIcon(arg_32_1.value, arg_32_1.type, {
				no_resize_name = true,
				show_name = true,
				scale = 1.2,
				count = var_32_18,
				txt_name = arg_32_2:getChildByName("txt_shop_name"),
				txt_type = arg_32_2:getChildByName("txt_shop_type")
			})
			
			arg_32_2:getChildByName("n_item_pos"):addChild(var_32_28)
		else
			if_set_visible(arg_32_2, "n_stars", false)
			
			arg_32_1.data = arg_32_1.data or {}
			
			local var_32_29, var_32_30 = DB("item_material", arg_32_1.type, {
				"ma_type",
				"ma_type2"
			})
			local var_32_31
			local var_32_32 = UIUtil:getRewardIcon(arg_32_1.value, arg_32_1.type, {
				show_name = true,
				no_resize_name = true,
				equip_stat = arg_32_1.data.op,
				grade = arg_32_1.data.g,
				set_fx = arg_32_1.data.f,
				count = var_32_18,
				scale = var_32_31,
				txt_name = arg_32_2:getChildByName("txt_shop_name"),
				txt_type = arg_32_2:getChildByName("txt_shop_type"),
				shop_artifact_stone = arg_32_3.shop_artifact_stone and var_32_29 == "stone" and var_32_30 == "artifact"
			})
			local var_32_33
			
			if var_32_17 == "artifact" then
				var_32_33 = arg_32_2:getChildByName("n_item_art_icon")
			end
			
			if not get_cocos_refid(var_32_33) then
				if_set_visible(arg_32_2, "n_reward_item", true)
				
				var_32_33 = arg_32_2:getChildByName("n_item_pos")
			else
				if_set_visible(arg_32_2, "n_item_pos", false)
			end
			
			var_32_33:setVisible(true)
			var_32_33:addChild(var_32_32)
			
			if var_32_29 == "stone" and var_32_30 == "artifact" or var_32_17 == "artifact" then
				local var_32_34 = arg_32_2:getChildByName("slot")
				
				if get_cocos_refid(var_32_34) then
					var_32_34:setScale(var_32_32:getScale() + 0.03)
					SpriteCache:resetSprite(var_32_34, "img/cm_item_slot_arti.png")
				end
			end
		end
		
		if_set_visible(arg_32_2, "icon_item", false)
	end
	
	if_set(arg_32_2, "txt_shop_type", T(arg_32_1.desc))
	
	local var_32_35 = arg_32_2:getChildByName("txt_shop_type")
	
	if get_cocos_refid(var_32_35) then
		var_32_35:setTextAreaSize({
			width = var_32_35:getContentSize().width,
			height = var_32_35:getStringNumLines() * var_32_35:getLineHeight()
		})
		
		if arg_32_1.select_item == "y" then
			var_32_35:setTextColor(cc.c3b(51, 122, 195))
		end
	end
	
	if arg_32_3.resize_name then
		if arg_32_3.multi_currency then
			arg_32_0:ResizeItemName2(arg_32_1, arg_32_2)
		else
			arg_32_0:ResizeItemName(arg_32_1, arg_32_2)
		end
	end
	
	local var_32_36 = arg_32_2:getChildByName("LEFT2")
	
	if get_cocos_refid(var_32_36) then
		if_set_visible(var_32_36, "badge_hot", false)
		if_set_visible(var_32_36, "badge_limited", false)
		if_set_visible(var_32_36, "badge_new", false)
		if_set_visible(var_32_36, "badge_free", false)
	end
end

function ShopCommon.showEULA(arg_35_0)
	local var_35_0 = load_dlg("shop_buy_detail", true, "wnd")
	
	UIUtil:setScrollViewText(var_35_0:getChildByName("scrollview"), T("buy_cancel.subscription_desc_long"))
	Dialog:msgBox("", {
		dlg = var_35_0
	})
end

function ShopCommon.showMultiPrice(arg_36_0, arg_36_1)
	local var_36_0 = string.split(tostring(arg_36_1.price), ";")
	local var_36_1 = to_n(var_36_0[#var_36_0])
	
	if #var_36_0 < 2 then
		return 
	end
	
	local var_36_2 = load_dlg("priceup_tooltip", true, "wnd")
	
	if_set(var_36_2, "txt_title", T("price_change_title"))
	
	local var_36_3 = math.min(#var_36_0, 10)
	local var_36_4 = var_36_2:getChildByName("bg_tooltip")
	local var_36_5 = var_36_4:getContentSize()
	local var_36_6 = (10 - var_36_3) * 36
	
	var_36_4:setContentSize({
		width = var_36_5.width,
		height = var_36_5.height - var_36_6
	})
	
	local var_36_7 = var_36_2:getChildByName("n_info")
	
	var_36_7:setPositionY(var_36_7:getPositionY() - var_36_6)
	
	local var_36_8 = Account:getLimitCount("sh:" .. arg_36_1.id)
	local var_36_9 = arg_36_1.limit_count or 10
	
	for iter_36_0 = 1, var_36_3 do
		local var_36_10 = to_n(var_36_0[iter_36_0])
		local var_36_11 = var_36_2:getChildByName("n_item" .. iter_36_0)
		local var_36_12 = load_control("wnd/priceup_item.csb")
		
		var_36_11:addChild(var_36_12)
		
		if var_36_9 > #var_36_0 and iter_36_0 == #var_36_0 then
			if_set(var_36_12, "txt_title", T("price_change_desc2", {
				price = "",
				count = iter_36_0
			}))
		else
			if_set(var_36_12, "txt_title", T("price_change_desc", {
				price = "",
				count = iter_36_0
			}))
		end
		
		local var_36_13 = var_36_12:getChildByName("txt_title")
		local var_36_14 = var_36_13:getContentSize().width
		local var_36_15 = var_36_12:getChildByName("n_icon_token")
		
		var_36_15:setPositionX(var_36_13:getPositionX() + var_36_14 + 5)
		UIUtil:getRewardIcon(nil, arg_36_1.token, {
			no_bg = true,
			parent = var_36_15
		})
		if_set(var_36_12, "t", comma_value(var_36_10))
		if_set_visible(var_36_12, "sel_bg", var_36_8 + 1 == iter_36_0 or iter_36_0 == var_36_3 and var_36_3 <= var_36_8 + 1)
	end
	
	return var_36_2
end

function ShopCommon.shopPopupBuy(arg_37_0, arg_37_1, arg_37_2)
	if arg_37_1.token == "cash" and Account:isJPN() and getUserLanguage() == "ja" and StoveIap and StoveIap:getProductInfo(arg_37_1.id) and StoveIap:getProductInfo(arg_37_1.id).priceCurrencyCode == "JPY" then
		if to_n(AccountData.birthday) == 0 then
			ShopBuyAgeBase:show(SceneManager:getRunningPopupScene())
			
			return 
		end
		
		local var_37_0 = to_n(StoveIap:getProductInfo(arg_37_1.id).priceAmountMicros) / 1000000
		
		if var_37_0 > 0 and AccountData.birthday_limit and to_n(AccountData.birthday_limit.limit) > 0 and AccountData.birthday_limit.current + var_37_0 > AccountData.birthday_limit.limit then
			Dialog:msgBox(T("jpn_payment_error_desc"), {
				title = T("jpn_payment_error_title")
			})
			
			return 
		end
	end
	
	if arg_37_1.token == "cash" and Stove.enable and StoveIap.FSM:isCurrentState(StoveIapState.STOVE_IAP_PROBLEM) and StoveIap.vars.problem_code == 40010 then
		Stove:openAppleStoreTireErrorFAQ()
		Log.e("shopPopupBuy : " .. (StoveIap.vars.problem_message or ""))
		balloon_message(StoveIap.vars.problem_message or "")
	end
	
	local var_37_1 = load_dlg("shop_popup_buy", true, "wnd")
	local var_37_2 = var_37_1:getChildByName("n_tooltip_priceup")
	
	arg_37_2 = arg_37_2 or function(arg_38_0, arg_38_1, arg_38_2)
		if arg_38_1 == "btn_buy" then
			if (Account:isCurrencyType(arg_37_1.token) or Account:isMaterialCurrencyType(arg_37_1.token)) and UIUtil:checkCurrencyDialog(arg_37_1.token, arg_37_1.price) ~= true then
				return 
			end
			
			local var_38_0
			
			if IS_PUBLISHER_ZLONG then
				local var_38_1 = getIapProductInfo(arg_37_1.id)
				
				if var_38_1 and var_38_1.goods_register_id and string.len(tostring(var_38_1.goods_register_id)) > 0 then
					var_38_0 = var_38_1.goods_register_id
				end
				
				if not var_38_0 and not PRODUCTION_MODE and PLATFORM == "win32" then
					var_38_0 = "test_purchase"
				end
			end
			
			if arg_37_1.coupon_data and Account:getItemCount(arg_37_1.coupon_data) > 0 and var_38_0 then
				UIAction:Add(SEQ(DELAY(200), CALL(function()
					ShopCommon:couponBuyConfirm(arg_37_1, function(arg_40_0, arg_40_1, arg_40_2)
						if arg_40_1 == "btn_buy" then
							arg_37_0:reqBuy(arg_37_1)
						elseif arg_40_1 == "btn_buy_coupon_zl" then
							arg_37_0:reqBuy(arg_37_1, nil, nil, {
								use_coupon = true,
								zl_grid = var_38_0
							})
						elseif arg_40_1 == "btn_close" then
						else
							return "dont_close"
						end
					end)
				end)), arg_37_0, "block")
				
				return 
			else
				arg_37_0:reqBuy(arg_37_1)
			end
		elseif arg_38_1 == "btn_detail" then
			ShopCommon:showEULA()
			
			return "dont_close"
		elseif arg_38_1 == "btn_priceinfo" then
			return "dont_close"
		elseif string.starts(arg_38_1, "btn_rate") then
			local var_38_2 = string.split(arg_38_1, ":")
			
			if arg_37_1 and string.len(var_38_2[2] or "") > 0 then
				if arg_37_1.random_list == "stove_equip_option" then
					Stove:openEquipPackageRenewalRateInfo()
				elseif arg_37_1.id == "e7_equip_30" or arg_37_1.id == "e7_equip_50" or arg_37_1.id == "e7_int_equip_10" then
					Stove:openEquipGachaRateInfo()
				elseif arg_37_1.random_list == "ma_guer_eq85_select" or arg_37_1.random_list == "ma_guer_eq70_select" then
					Stove:openGuerrillaRateInfo()
				elseif var_38_2[2] == "rate_open" then
					if_set_visible(arg_38_0, "n_btn_rate_list", true)
				else
					if_set_visible(arg_38_0, "n_btn_rate_list", false)
					
					if var_38_2[3] == "randombox" then
						query("randombox_rate_info", {
							item = var_38_2[2]
						})
					else
						query("gacha_rate_info", {
							item = var_38_2[2]
						})
					end
				end
			end
			
			return "dont_close"
		end
	end
	
	local var_37_3 = var_37_1:getChildByName("n_add_info")
	local var_37_4 = 0
	
	if ShopCommon:setupRateInfoUI(var_37_1, arg_37_1) then
		var_37_4 = var_37_4 + 1
	end
	
	if_set_visible(var_37_1, "n_caution", false)
	
	if (arg_37_1.token == "cash" or arg_37_1.category == "promotion") and getUserLanguage() == "ko" then
		var_37_4 = var_37_4 + 1
		
		if var_37_4 < 2 then
			var_37_1:getChildByName("n_caution"):setPositionY(var_37_3:getPositionY())
		end
		
		UIAction:Add(SEQ(SHOW(true), LOG(SCALE(150, 0, 1.1)), DELAY(50), RLOG(SCALE(80, 1.1, 1))), var_37_1:getChildByName("n_caution"))
	end
	
	var_37_3:setVisible(var_37_4 > 0)
	
	local var_37_5, var_37_6, var_37_7 = DB("character", arg_37_1.type, {
		"type",
		"grade",
		"moonlight"
	})
	local var_37_8 = false
	
	if to_n(var_37_6) >= 5 then
		if var_37_5 == "limited" then
			var_37_8 = true
		elseif var_37_5 == "character" then
			local var_37_9 = Account:getCollectionUnit(arg_37_1.type)
			
			if var_37_9 and (to_n(var_37_9.ac) >= 6 or var_37_7 == "y" and to_n(var_37_9.ac) >= 1) then
				var_37_8 = true
			end
		end
	end
	
	if arg_37_0:isMultiPrice(arg_37_1) then
		local var_37_10 = var_37_1:getChildByName("btn_cancel")
		
		var_37_10:setPositionX(var_37_10:getPositionX() - 90)
		
		local var_37_11 = var_37_1:getChildByName("btn_buy")
		
		var_37_11:setPositionX(var_37_11:getPositionX() - 90)
		
		local var_37_12 = var_37_1:getChildByName("btn_priceinfo")
		
		var_37_12:setPositionX(var_37_12:getPositionX() - 90)
		var_37_12:setVisible(true)
		
		if var_37_8 then
			if_set(var_37_1, "infor", T("shop_popup_desc2_herocoin"))
		else
			if_set(var_37_1, "infor", T("shop_popup_desc2"))
		end
		
		WidgetUtils:setupTooltip({
			control = var_37_1:getChildByName("btn_priceinfo"),
			creator = function()
				return ShopCommon:showMultiPrice(arg_37_1)
			end
		})
	else
		if var_37_8 then
			if_set(var_37_1, "infor", T("shop_popup_desc_herocoin"))
		end
		
		if_set_visible(var_37_1, "btn_priceinfo", false)
	end
	
	Dialog:msgBox({
		yesno = true,
		dlg = var_37_1,
		handler = arg_37_2
	})
	
	local var_37_13 = var_37_1:getChildByName("n_caution")
	
	if IS_ANDROID_BASED_PLATFORM and getUserLanguage() == "ko" then
		if_set(var_37_13, "t_disc", T("buy_cancel.subscription_desc_short_playpoint"))
	else
		if_set(var_37_13, "t_disc", T("buy_cancel.subscription_desc_short"))
	end
	
	if arg_37_1.shop_type == "season_pass" or arg_37_1.shop_type == "substory_pass" then
		local var_37_14 = var_37_1:getChildByName("n_pass_info")
		
		UIAction:Add(SEQ(SHOW(true), LOG(SCALE(150, 0, 1.1)), DELAY(50), RLOG(SCALE(80, 1.1, 1))), var_37_14)
		if_set(var_37_14, "t_disc", T("season_buy_popup_info"))
	end
	
	if_set(var_37_1, "txt_shop_type", UIUtil:getRewardTitle(arg_37_1.type))
	ShopCommon:SetItemIcon(arg_37_1, var_37_1, {
		use_flag_badge = arg_37_1.shop_type == "normal"
	})
	ShopCommon:UpdatePayIcon(var_37_1, arg_37_1)
	ShopCommon:adjustShopNamePositionY(var_37_1)
	
	if arg_37_1.rest_count then
		if_set(var_37_1, "txt_restcount", T("shop_rest_count", {
			count = arg_37_1.rest_count
		}))
	else
		if_set_visible(var_37_1, "txt_restcount", false)
	end
	
	return var_37_1
end

function ShopCommon.adjustShopNamePositionY(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1:getChildByName("txt_shop_name")
	
	if get_cocos_refid(var_42_0) and to_n(var_42_0:getLineCount()) > 1 then
		local var_42_1 = 10
		
		var_42_0:setPositionY(var_42_0:getPositionY() + var_42_1)
		
		local var_42_2 = arg_42_1:getChildByName("txt_shop_type")
		
		if get_cocos_refid(var_42_2) then
			var_42_2:setPositionY(var_42_2:getPositionY() + var_42_1)
		end
	end
end

function ShopCommon.setupRateInfoUI(arg_43_0, arg_43_1, arg_43_2)
	if_set_visible(arg_43_1, "n_rate_info", false)
	if_set_visible(arg_43_1, "n_btn_rate_list", false)
	
	local var_43_0 = {}
	
	for iter_43_0, iter_43_1 in pairs(string.split(arg_43_2.random_list or "", ",") or {}) do
		if string.len(iter_43_1) > 0 then
			table.push(var_43_0, iter_43_1)
		end
	end
	
	local var_43_1 = true
	local var_43_2, var_43_3, var_43_4 = DB("shop_package_bonus", arg_43_2.id, {
		"item_id",
		"bonus_item_value",
		"random_list"
	})
	
	if var_43_2 and var_43_4 then
		local var_43_5, var_43_6, var_43_7 = ShopCommon:GetRestCount(arg_43_2, os.time())
		
		if var_43_5 > var_43_6 - var_43_3 then
			for iter_43_2, iter_43_3 in pairs(string.split(var_43_4 or "", ",") or {}) do
				if string.len(iter_43_3) > 0 then
					table.push(var_43_0, iter_43_3)
				end
			end
		else
			var_43_1 = false
		end
	end
	
	if var_43_1 and #var_43_0 > 0 then
		local var_43_8 = arg_43_1:getChildByName("n_rate_info")
		local var_43_9 = arg_43_1:getChildByName("n_btn_rate_list")
		local var_43_10 = var_43_8:getChildByName("btn_rate")
		
		if_set_visible(var_43_8, "n_btn_rate", true)
		if_set_visible(var_43_8, "btn_stove", false)
		
		if arg_43_2.type == "gacha_start" or string.starts(arg_43_2.type, "gacha_story") or arg_43_2.type == "gacha_spdash" then
			if_set(var_43_8, "txt_include", T("ui_randomitem_included", {
				item = T(arg_43_2.name)
			}))
			var_43_10:setName("btn_rate:" .. arg_43_2.random_list)
		else
			local var_43_11 = ""
			
			for iter_43_4, iter_43_5 in pairs(var_43_0) do
				local var_43_12
				
				if string.starts(iter_43_5, "sp_") then
					var_43_12 = DB("item_special", iter_43_5, "name")
				elseif string.starts(iter_43_5, "ma_") then
					var_43_12 = DB("item_material", iter_43_5, "name")
				end
				
				if var_43_12 then
					var_43_11 = var_43_11 .. T(var_43_12)
					
					if iter_43_4 < #var_43_0 then
						var_43_11 = var_43_11 .. "/"
					end
				end
			end
			
			if #var_43_0 > 1 then
				var_43_10:setName("btn_rate:rate_open")
				
				local var_43_13 = arg_43_1:getChildByName("ScrollView")
				local var_43_14 = ItemListView_v2:bindControl(var_43_13)
				local var_43_15 = load_control("wnd/shop_popup_buy_rate_item.csb")
				
				if var_43_13.STRETCH_INFO then
					local var_43_16 = var_43_13:getContentSize()
					
					resetControlPosAndSize(var_43_15, var_43_16.width, var_43_13.STRETCH_INFO.width_prev)
				end
				
				local var_43_17 = {
					onUpdate = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
						local var_44_0 = arg_44_1:getChildByName("btn_rate")
						local var_44_1, var_44_2, var_44_3 = DB("item_special", arg_44_3, {
							"name",
							"type",
							"value"
						})
						
						if_set(var_44_0, "label", T(var_44_1))
						
						if var_44_2 == "randombox" then
							var_44_0:setName("btn_rate:" .. arg_44_3 .. ":randombox")
						else
							var_44_0:setName("btn_rate:" .. arg_44_3)
						end
						
						return arg_44_3
					end
				}
				
				var_43_14:setRenderer(var_43_15, var_43_17)
				var_43_14:removeAllChildren()
				var_43_14:setDataSource(var_43_0)
				if_set(var_43_8, "txt_include", T("ui_randomitem_included_2"))
			elseif var_43_0[1] == "stove_equip_option" then
				if_set(var_43_8, "txt_include", T("ui_equipselectbox_included"))
				if_set_visible(var_43_8, "n_btn_rate", false)
				if_set_visible(var_43_8, "btn_stove", true)
				var_43_8:getChildByName("btn_stove"):setName("btn_rate:stove_equip_option")
			else
				local var_43_18, var_43_19, var_43_20 = DB("item_special", var_43_0[1], {
					"name",
					"type",
					"value"
				})
				
				if var_43_19 == "randombox" then
					var_43_10:setName("btn_rate:" .. var_43_0[1] .. ":randombox")
				else
					var_43_10:setName("btn_rate:" .. var_43_0[1])
				end
				
				if_set(var_43_8, "txt_include", T("ui_randomitem_included", {
					item = var_43_11
				}))
			end
		end
		
		if_set(var_43_8, "label", T("buy_cancel.subscription_detail"))
		UIAction:Add(SEQ(SHOW(true), LOG(SCALE(150, 0, 1.1)), DELAY(50), RLOG(SCALE(80, 1.1, 1))), var_43_8)
		
		if getUserLanguage() == "ko" and (arg_43_2.id == "e7_equip_30" or arg_43_2.id == "e7_equip_50") then
			if_set_sprite(arg_43_1:getChildByName("n_btn_rate"), "icon", "img/icon_quick_stove.png")
		end
		
		return true
	end
end

function ShopCommon.shopPopupBuyNameChange(arg_45_0, arg_45_1, arg_45_2)
	if not Account:checkNameChanged() then
		balloon_message_with_sound("namechange_lock_msg")
		
		return 
	end
	
	UserNickName:popupNickname(nil, nil, function(arg_46_0)
		if arg_46_0 and utf8len(arg_46_0) > 0 then
			arg_45_0.vars.nickname_changed = arg_46_0
			
			arg_45_0:reqBuy(arg_45_1, 1, nil, {
				nickname_change = arg_46_0
			})
		end
	end, true)
	
	return nil
end

function ShopCommon.shopPopupBuy2(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = load_dlg("shop_popup_buy2", true, "wnd")
	
	arg_47_2 = arg_47_2 or function(arg_48_0, arg_48_1, arg_48_2)
		if arg_48_1 == "btn_buy" then
			if (Account:isCurrencyType(arg_47_1.token) or Account:isMaterialCurrencyType(arg_47_1.token)) and UIUtil:checkCurrencyDialog(arg_47_1.token, arg_47_1.price) ~= true then
				return 
			end
			
			arg_47_0:reqBuy(arg_47_1)
		elseif arg_48_1 == "btn_detail" then
			ShopCommon:showEULA()
			
			return "dont_close"
		elseif string.starts(arg_48_1, "btn_rate") then
			local var_48_0 = string.split(arg_48_1, ":")
			
			if arg_47_1 and string.len(var_48_0[2] or "") > 0 then
				if arg_47_1.random_list == "stove_equip_option" then
					Stove:openEquipPackageRenewalRateInfo()
				elseif arg_47_1.id == "e7_equip_30" or arg_47_1.id == "e7_equip_50" or arg_47_1.id == "e7_int_equip_10" then
					Stove:openEquipGachaRateInfo()
				elseif arg_47_1.random_list == "ma_guer_eq85_select" or arg_47_1.random_list == "ma_guer_eq70_select" then
					Stove:openGuerrillaRateInfo()
				elseif var_48_0[2] == "rate_open" then
					if_set_visible(arg_48_0, "n_btn_rate_list", true)
				else
					if_set_visible(arg_48_0, "n_btn_rate_list", false)
					
					if var_48_0[3] == "randombox" then
						query("randombox_rate_info", {
							item = var_48_0[2]
						})
					else
						query("gacha_rate_info", {
							item = var_48_0[2]
						})
					end
				end
			end
			
			return "dont_close"
		end
	end
	
	ShopCommon:setupRateInfoUI(var_47_0, arg_47_1)
	Dialog:msgBox({
		yesno = true,
		dlg = var_47_0,
		handler = arg_47_2
	})
	if_set(var_47_0, "txt_shop_type", UIUtil:getRewardTitle(arg_47_1.type))
	ShopCommon:SetItemIcon(arg_47_1, var_47_0, {
		multi_currency = true,
		use_flag_badge = arg_47_1.shop_type == "normal"
	})
	ShopCommon:UpdatePayIcon2(var_47_0, arg_47_1)
	ShopCommon:adjustShopNamePositionY(var_47_0)
	
	if arg_47_1.rest_count then
		if_set(var_47_0, "txt_restcount", T("shop_rest_count", {
			count = arg_47_1.rest_count
		}))
	else
		if_set_visible(var_47_0, "txt_restcount", false)
	end
	
	return var_47_0
end

function ShopCommon.shopPopupBuyBulk(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0
	
	arg_49_3 = arg_49_3 or {}
	
	if Account:isCurrencyType(arg_49_1.token) then
		var_49_0 = Account:getCurrency(arg_49_1.token)
	elseif Account:isMaterialCurrencyType(arg_49_1.token) then
		var_49_0 = Account:getItemCount(arg_49_1.token)
	end
	
	if not var_49_0 then
		return 
	end
	
	local var_49_1 = math.min(100, math.floor(var_49_0 / arg_49_1.price))
	local var_49_2, var_49_3, var_49_4 = arg_49_0:GetRestCount(arg_49_1, os.time())
	
	if var_49_3 then
		if var_49_2 < 2 then
			return 
		end
		
		var_49_1 = math.min(var_49_1, var_49_2)
	end
	
	if arg_49_3.force_max then
		var_49_1 = math.min(var_49_1, arg_49_3.force_max)
	end
	
	local var_49_5 = load_dlg("shop_popup_buy_expand", true, "wnd")
	local var_49_6 = var_49_5:getChildByName("slider")
	
	arg_49_2 = arg_49_2 or function(arg_50_0, arg_50_1, arg_50_2)
		if arg_50_1 == "btn_buy" then
			if (Account:isCurrencyType(arg_49_1.token) or Account:isMaterialCurrencyType(arg_49_1.token)) and UIUtil:checkCurrencyDialog(arg_49_1.token, arg_50_0.require_price) ~= true then
				return 
			end
			
			local var_50_0 = to_n(arg_50_0.multiply)
			
			if var_50_0 >= 5 and not arg_49_3.no_count_confirm then
				Dialog:closeAll()
				
				local var_50_1 = Dialog:open("wnd/shop_popup_buy_expand2", arg_49_0, {
					modal = true,
					use_backbutton = true
				})
				local var_50_2 = var_50_1:getChildByName("n_contents"):getChildByName("btn_buy")
				
				var_50_2.item = arg_49_1
				var_50_2.multiply = var_50_0
				
				if arg_49_1.parent_self then
					var_50_2.parent_self = arg_49_1.parent_self
				else
					var_50_2.parent_self = arg_49_0
				end
				
				SceneManager:getRunningPopupScene():addChild(var_50_1)
				ShopCommon:SetItemIcon(arg_49_1, var_50_1)
				ShopCommon:UpdatePayIcon(var_50_1, arg_49_1, var_50_0)
				ShopCommon:adjustShopNamePositionY(var_50_1)
				
				local var_50_3 = var_50_1:getChildByName("txt_qty")
				local var_50_4 = var_50_1:getChildByName("txt_count")
				
				if_set(var_50_1, "txt_count", comma_value(var_50_0))
				
				if tolua:type(var_50_1:getChildByName("text")) ~= "ccui.RichText" then
					upgradeLabelToRichLabel(var_50_1, "text")
				end
				
				if_set(var_50_1, "text", T("shop_popup_mass_desc", {
					count = var_50_0
				}))
				
				local var_50_5 = var_50_3:getContentSize()
				local var_50_6 = var_50_3:getScaleX()
				
				var_50_4:setPositionX(var_50_3:getPositionX() + var_50_5.width * var_50_6 * 0.5 + 5)
			elseif arg_49_1.parent_self then
				arg_49_1.parent_self:reqBuy(arg_49_1, var_50_0)
			else
				arg_49_0:reqBuy(arg_49_1, var_50_0)
			end
		elseif arg_50_1 == "btn_max" then
			var_49_6:setPercent(var_49_1)
			Dialog.defaultSliderEventHandler(var_49_6, 2)
			
			return "dont_close"
		elseif arg_50_1 == "btn_min" then
			var_49_6:setPercent(1)
			Dialog.defaultSliderEventHandler(var_49_6, 2)
			
			return "dont_close"
		end
	end
	
	Dialog:msgBoxSlider({
		slider_pos = 1,
		min = 1,
		yesno = true,
		dlg = var_49_5,
		handler = arg_49_2,
		slider_handler = function(arg_51_0, arg_51_1, arg_51_2)
			local var_51_0 = math.max(math.min(to_n(arg_51_1), var_49_1), 1)
			
			if_set(arg_51_0:getChildByName("n_slider"), "t_count", var_51_0 .. "/" .. var_49_1)
			ShopCommon:UpdatePayIcon(arg_51_0, arg_49_1, var_51_0)
			
			arg_51_0.multiply = var_51_0
			arg_51_0.require_price = arg_49_1.price * var_51_0
		end,
		max = var_49_1
	})
	if_set(var_49_5, "txt_shop_type", UIUtil:getRewardTitle(arg_49_1.type))
	ShopCommon:SetItemIcon(arg_49_1, var_49_5, {
		use_flag_badge = arg_49_1.shop_type == "normal"
	})
	ShopCommon:UpdatePayIcon(var_49_5, arg_49_1)
	ShopCommon:adjustShopNamePositionY(var_49_5)
	
	if arg_49_1.rest_count then
		if_set(var_49_5, "txt_restcount", T("shop_rest_count", {
			count = arg_49_1.rest_count
		}))
	else
		if_set_visible(var_49_5, "txt_restcount", false)
	end
	
	return var_49_5
end

function ShopCommon.couponBuyConfirm(arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_1 or not arg_52_1.coupon_data then
		return 
	end
	
	local var_52_0 = load_dlg("shop_popup_buy", true, "wnd")
	
	if_set_visible(var_52_0, "btn_buy_coupon_zl", true)
	var_52_0:getChildByName("btn_cancel"):setPositionX(var_52_0:getChildByName("n_btn_cancel_c_move"):getPositionX())
	var_52_0:getChildByName("btn_buy"):setPositionX(var_52_0:getChildByName("n_btn_buy_c_move"):getPositionX())
	if_set(var_52_0, "txt_buy", T("package_coupon_buy_popup_title"))
	if_set(var_52_0, "infor", T("package_coupon_buy_popup_desc1", {
		name = T(DB("item_material", arg_52_1.coupon_data, "name"))
	}))
	
	if arg_52_1.rest_count then
		if_set(var_52_0, "txt_restcount", T("package_coupon_buy_popup_desc2", {
			num = arg_52_1.rest_count
		}))
	else
		if_set_visible(var_52_0, "txt_restcount", false)
	end
	
	local var_52_1 = var_52_0:getChildByName("btn_buy_coupon_zl")
	
	if_set(var_52_1, "label", T("package_coupon_buy_popup_btn3"))
	if_set_visible(var_52_0, "n_add_info", false)
	if_set_visible(var_52_0, "n_caution", false)
	if_set_visible(var_52_0, "n_rate_info", false)
	if_set_visible(var_52_0, "btn_priceinfo", false)
	if_set_visible(var_52_0, "n_custom_badge", false)
	if_set_visible(var_52_0, "icon_item", false)
	Dialog:msgBox({
		yesno = true,
		dlg = var_52_0,
		handler = arg_52_2
	})
	
	local var_52_2 = UIUtil:getRewardIcon(Account:getItemCount(arg_52_1.coupon_data), arg_52_1.coupon_data, {
		no_resize_name = true,
		show_name = true,
		txt_name = var_52_0:getChildByName("txt_shop_name"),
		txt_type = var_52_0:getChildByName("txt_shop_type")
	})
	
	UIUtil:getRewardIcon(nil, arg_52_1.coupon_data, {
		no_popup = true,
		no_tooltip = true,
		name = false,
		no_bg = true,
		parent = var_52_0:getChildByName("n_pay_coupon")
	})
	
	local var_52_3 = var_52_0:getChildByName("n_item_pos")
	
	var_52_3:setVisible(true)
	var_52_3:addChild(var_52_2)
	ShopCommon:UpdatePayIcon(var_52_0, arg_52_1)
	
	return var_52_0
end

function ShopCommon.ShowConfirmDialog(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	if string.starts(arg_53_1.type, "e") then
		local var_53_0 = DB("equip_item", arg_53_1.type, {
			"type"
		})
		
		if var_53_0 then
			if var_53_0 == "artifact" then
				if not UIUtil:checkArtifactInven() then
					return 
				end
			elseif not UIUtil:checkEquipInven() then
				return 
			end
		end
	end
	
	if string.starts(arg_53_1.type, "c") and not UIUtil:checkUnitInven() then
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		local var_53_1 = Account:isCurrencyType(arg_53_1.token)
		
		if var_53_1 and Account:getCurrency(var_53_1) < arg_53_1.price then
			balloon_message_with_sound("need_token")
			
			return 
		end
	end
	
	if arg_53_1.id and string.starts(arg_53_1.id, "gacha_ticketrare_") then
		local var_53_2 = Account:isCurrencyType(arg_53_1.token)
		
		if var_53_2 and Account:getCurrency(var_53_2) < arg_53_1.price and ShopPromotion:popupGachaPromotionPackages("ticketrare") then
			return 
		end
	end
	
	if arg_53_1.type == "sp_name_change" then
		return arg_53_0:shopPopupBuyNameChange(arg_53_1, arg_53_2)
	elseif arg_53_1.token2 and to_n(arg_53_1.price2) > 0 then
		return arg_53_0:shopPopupBuy2(arg_53_1, arg_53_2)
	elseif arg_53_1.bulk_purchase == "y" then
		local var_53_3 = 0
		
		if arg_53_1.token == "cash" or arg_53_1.token2 then
			var_53_3 = var_53_3 + 1
		end
		
		local var_53_4, var_53_5, var_53_6 = arg_53_0:GetRestCount(arg_53_1, os.time())
		
		if var_53_5 and var_53_4 < 2 then
			var_53_3 = var_53_3 + 1
		end
		
		local var_53_7, var_53_8 = DB("item_special", arg_53_1.type, {
			"id",
			"type"
		})
		
		if var_53_7 and var_53_8 ~= "package" and var_53_8 ~= "randombox" then
			var_53_3 = var_53_3 + 1
		elseif DB("character", arg_53_1.type, "id") then
			var_53_3 = var_53_3 + 1
		elseif DB("equip_item", arg_53_1.type, "id") then
			var_53_3 = var_53_3 + 1
		end
		
		if var_53_3 == 0 then
			return arg_53_0:shopPopupBuyBulk(arg_53_1, arg_53_2, arg_53_3)
		end
	end
	
	return arg_53_0:shopPopupBuy(arg_53_1, arg_53_2)
end

function ShopCommon.addShopItem(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	local var_54_0 = true
	local var_54_1 = os.time()
	
	if arg_54_2.start_time and var_54_1 < arg_54_2.start_time then
		var_54_0 = false
	end
	
	if arg_54_1 ~= "skin" and arg_54_2.end_time and var_54_1 > arg_54_2.end_time then
		var_54_0 = false
	end
	
	if arg_54_2.hidden_ingame == "y" then
		var_54_0 = false
	end
	
	if arg_54_2.sys_achieve and not UnlockSystem:isUnlockSystem(arg_54_2.sys_achieve) then
		var_54_0 = false
	end
	
	if arg_54_2.token == "cash" and to_n(Account:getLimitCount("sh:" .. arg_54_2.id)) > 0 then
		var_54_0 = false
	end
	
	if arg_54_2.buy_condition and not arg_54_0:isBuyCondition(arg_54_2.buy_condition) then
		var_54_0 = false
	end
	
	if arg_54_3 and arg_54_2.select_id and arg_54_2.select_item ~= "y" then
		var_54_0 = false
	end
	
	return var_54_0
end

function ShopCommon.isBuyCondition(arg_55_0, arg_55_1)
	local var_55_0 = true
	
	if not arg_55_1 then
		return var_55_0
	end
	
	local var_55_1 = totable(arg_55_1)
	
	if type(var_55_1) == "table" then
		if var_55_1.unit_require and not Account:getCollectionUnit(var_55_1.unit_require) then
			var_55_0 = false
		end
		
		if var_55_1.completed_buy and to_n(Account:getLimitCount("sh:" .. var_55_1.completed_buy)) < 1 then
			var_55_0 = false
		end
	end
	
	return var_55_0
end

function test_message()
	balloon_message_with_sound("notyet_buy")
end

function HANDLER.shop_base(arg_57_0, arg_57_1)
	if string.starts(arg_57_1, "btn_banner") then
		PromotionBanner:scrollToIndex(string.sub(arg_57_1, -1, -1))
	elseif arg_57_1 == "btn_shop_arti_info" then
		Shop:popupPowderGachaList()
	end
end

HANDLER.shop_list = HANDLER.shop_base

function ErrHandler.buy(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = SceneManager:getCurrentSceneName()
	
	if var_58_0 == "battle" then
		if arg_58_2.caller and (arg_58_2.caller == "battle_repeat" or arg_58_2.caller == "back_ground_battle_repeat") then
			balloon_message_with_sound("ui_pet_repeat_token_not")
			
			if arg_58_2.caller == "back_ground_battle_repeat" then
				BackPlayManager:endRepeatPlay()
			end
			
			BattleRepeat:set_isCounting(false)
			BattleRepeat:set_isEndRepeatPlay(true)
			if_set_visible(BattleTopBar:get_repeateControl(), "n_count", false)
			BattleTopBar:open_RepeateControlAgain()
			BattleRepeat:_debugLogErr("Err: 반복전투 or 백그라운드 재화 구매 실패!!!")
		else
			balloon_message_with_sound("need_token")
			Dialog:close("shop_popup_buy")
		end
		
		return 
	elseif arg_58_2.caller and arg_58_2.caller == "back_ground_battle_repeat" then
		balloon_message_with_sound("ui_pet_repeat_token_not")
		BackPlayManager:endRepeatPlay()
		BattleRepeat:_debugLogErr("Err: 백그라운드 재화 구매 실패!!!")
		
		return 
	elseif var_58_0 == "DungeonList" then
		if (DungeonList:getModeInfo() or {}).mode ~= "Substory" then
			return 
		end
	elseif var_58_0 ~= "shop" and var_58_0 ~= "lobby" and var_58_0 ~= "clan" and var_58_0 ~= "gacha_unit" and var_58_0 ~= "sanctuary" and var_58_0 ~= "pet_ui" and not string.starts(var_58_0, "world") then
		return 
	end
	
	Dialog:close("shop_popup_buy")
	
	arg_58_1 = arg_58_1 or ""
	
	if string.starts(arg_58_1, "no_") then
		local var_58_1 = string.sub(arg_58_1, 4, -1)
		
		if Account:isCurrencyType(var_58_1) or Account:isMaterialCurrencyType(var_58_1) then
			UIUtil:checkCurrencyDialog(var_58_1)
			
			return 
		end
		
		if DB("item_material", var_58_1, "ma_type") == "cp" then
			Dialog:msgBox(T(arg_58_1 .. ".desc"), {
				title = T("buy.no_ma_cp.title")
			})
			
			return 
		end
	end
	
	arg_58_1 = "buy." .. arg_58_1
	
	Log.e("SHOP ERR")
	Dialog:msgBox(T(arg_58_1 .. ".desc"), {
		title = T(arg_58_1 .. ".title"),
		handler = function()
			SceneManager:nextScene("lobby")
		end
	})
end

function MsgHandler.market(arg_60_0)
	AccountData.shop = arg_60_0.list
	
	if arg_60_0.shop_promotion_categories then
		AccountData.shop_promotion_categories = arg_60_0.shop_promotion_categories
	end
	
	if arg_60_0.package_limits then
		AccountData.package_limits = arg_60_0.package_limits
	end
	
	if arg_60_0.birthday_limit then
		AccountData.birthday_limit = arg_60_0.birthday_limit
	end
	
	if arg_60_0.limits then
		Account:updateLimits(arg_60_0.limits)
	end
	
	if arg_60_0.ticketed_limits then
		AccountData.ticketed_limits = arg_60_0.ticketed_limits
	end
	
	Shop.ready = true
	
	local var_60_0
	
	if arg_60_0.caller == "package_lobby" then
		ShopPromotion:popupNext(true)
		
		return 
	elseif arg_60_0.caller == "package_gacha" then
		return 
	elseif arg_60_0.caller == "gacha_customgroup" then
		GachaUnitShopPopup:show("miragecoin", "gacha_customgroup")
		
		return 
	elseif arg_60_0.caller == "gacha_customspecial" then
		GachaUnitShopPopup:show("moon_miragecoin", "gacha_customspecial")
		
		return 
	elseif arg_60_0.caller == "dungeon" then
		var_60_0 = {
			category = "dungeon",
			type = "normal"
		}
	end
	
	if SceneManager:getCurrentSceneName() ~= "shop" then
		UIUtil:closePopupModes()
		SceneManager:nextScene("shop", var_60_0)
	else
		Shop:update()
	end
end

function MsgHandler.buy(arg_61_0)
	if get_cocos_refid(ShopRandom.wnd) and ShopRandom.npc and ShopRandom.talker_key then
		local var_61_0 = ShopRandom.wnd:getChildByName(ShopRandom.npc == "lobby" and "n_lobby" or "n_dungeon")
		
		if get_cocos_refid(var_61_0) then
			UIUtil:playNPCSoundAndTextRandomly(ShopRandom.talker_key .. ".buyitem", var_61_0, "txt_balloon", nil, ShopRandom.talker_key .. ".idle")
		end
	end
	
	local var_61_1 = {}
	
	SoundEngine:play("event:/ui/shop_popup_buy/btn_buy")
	
	if arg_61_0.token then
		Account:setCurrencyTime(arg_61_0.token, arg_61_0.currency_time)
	end
	
	local var_61_2 = {
		desc = "",
		title = T("read_mail")
	}
	
	if arg_61_0.caller == "promotion" then
		var_61_2.title = T("receive_shop_package")
		var_61_2.desc = "???"
	end
	
	ConditionContentsManager:dispatch("category.buy", {
		category = arg_61_0.category
	})
	ConditionContentsManager:dispatch("shop.buy", {
		shopid = arg_61_0.item
	})
	Account:updateCurrencies(arg_61_0.update_currencies)
	
	local var_61_3 = {
		single = true,
		buy = true,
		play_reward_data = var_61_2
	}
	local var_61_4 = {}
	
	if arg_61_0.caller == "substory_shop" then
		var_61_4 = {
			force_character_effect = true
		}
	end
	
	local var_61_5 = merge_table(var_61_3, var_61_4)
	
	if arg_61_0.caller == "promotion" and ShopPromotion:getPackageHeroSelectID(arg_61_0.item) then
		var_61_5 = {}
	end
	
	if arg_61_0.caller == "promotion" and ShopPromotion:getCustomSelectPackageID(arg_61_0.item) then
		var_61_5.single = nil
		var_61_5.is_no_reward_popup = true
	end
	
	local var_61_6 = Account:addReward(arg_61_0.rewards, var_61_5)
	
	TopBarNew:topbarUpdate(true)
	
	if AccountData.random_shop ~= nil then
		for iter_61_0, iter_61_1 in pairs(AccountData.random_shop) do
			if tostring(iter_61_1.id) == tostring(arg_61_0.item) then
				iter_61_1.sold_out = true
			end
		end
	end
	
	if arg_61_0.limits then
		Account:updateLimits(arg_61_0.limits)
	end
	
	if arg_61_0.ticketed_limits then
		AccountData.ticketed_limits = arg_61_0.ticketed_limits
	end
	
	if arg_61_0.package_limits then
		AccountData.package_limits = arg_61_0.package_limits
	end
	
	if arg_61_0.birthday_limit then
		AccountData.birthday_limit = arg_61_0.birthday_limit
	end
	
	if arg_61_0.user_config then
		AccountData.user_config = arg_61_0.user_config
	end
	
	if arg_61_0.nickname_changed then
		UserNickName:nameChanged("ok", arg_61_0.nickname_changed)
	end
	
	ConditionContentsManager:dispatch("shop.buystone", {
		shopid = arg_61_0.item
	})
	print("buy caller : ", arg_61_0.caller)
	SoundEngine:play("event:/ui/gold")
	
	if arg_61_0.caller == "battle.ready" or arg_61_0.caller == "topbar" then
		BattleReady:updateButtons()
		DescentReady:updateButtons()
		SubStoryBurningStory:updateButtons()
		BurningReady:updateButtons()
		
		if SceneManager:getCurrentSceneName() == "battle" then
			ClearResult:updateRetryButton()
		elseif SceneManager:getCurrentSceneName() == "pvp" then
			UnitTeam:updatePvpKey()
		end
		
		SubStoryMoonlightTheater:updateBtnCurrency()
		balloon_message_with_sound("shop_buy_success")
	elseif arg_61_0.caller == "pvp.ready" then
		UnitTeam:updatePvpKey()
		balloon_message_with_sound("shop_buy_success")
	elseif arg_61_0.caller == "subtask.ready" then
		SubTask:updateReadyButton()
		balloon_message_with_sound("shop_buy_success")
	elseif arg_61_0.caller == "subtask.retry" then
		SubTask:updateRetryButton()
		balloon_message_with_sound("shop_buy_success")
	elseif arg_61_0.caller == "promotion" then
		ShopPromotion:onMsgBuy(arg_61_0, var_61_6)
		
		return 
	elseif arg_61_0.caller == "package_gacha" then
		GachaUnit:onMsgPackageBuy(arg_61_0)
		
		return 
	elseif arg_61_0.caller == "gacha_customgroup" then
		GachaUnit:onMsgShopBuy(arg_61_0)
		
		return 
	elseif arg_61_0.caller == "gacha_customspecial" then
		GachaUnit:onMsgShopBuy(arg_61_0)
		
		return 
	elseif arg_61_0.caller == "unitskill" then
		UnitSkill:UpdateLeftResourceCount()
	elseif arg_61_0.caller == "season_pass" then
		SeasonPassBase:onRtnBuyPackage(arg_61_0)
	elseif arg_61_0.caller == "exclusive_buy" then
		ShopExclusiveEquip_result:open_resultPopup(arg_61_0, {
			type == "buy"
		})
	elseif arg_61_0.caller == "shop_trialhall" then
		ShopExclusiveEquip:updateTrialHallItems()
	elseif arg_61_0.caller == "worldboss" then
		WorldBossReady:updateStamina()
	elseif arg_61_0.caller == "gacha_ticket" then
		if arg_61_0.item == "gacha_ticketnormal_1" then
			GachaUnit:front()
		end
	elseif arg_61_0.caller == "battle_repeat" then
		if not ArenaService:isActiveUIScene() then
			balloon_message_with_sound("ui_pet_repeat_token_on")
		end
		
		BattleRepeat:repeat_battle()
	elseif arg_61_0.caller == "back_ground_battle_repeat" then
		if not ArenaService:isActiveUIScene() then
			balloon_message_with_sound("ui_pet_repeat_token_on")
		end
		
		BackPlayManager:repeat_battle_start()
	end
	
	if arg_61_0.caller ~= "exclusive_buy" and arg_61_0.caller ~= "back_ground_battle_repeat" then
		Dialog:close("shop_popup_buy")
	end
	
	if arg_61_0.rshop then
		ShopRandom:setAniPortrait("action_00")
	end
	
	if arg_61_0.caller ~= "back_ground_battle_repeat" then
		SubstoryShop:updateBalloon(".buyitem")
		ShopChapter:updateBalloon(".buyitem")
		ShopChapterForce:updateBalloon(".buyitem")
		ShopGuerrilla:updateBalloon(".buyitem")
		LotaShopUI:updateBalloon(".buyitem")
		ShopRandom:updateSoldOutItems()
		ClanShopData:updateTimeLimitedItems()
		SubstoryShop:updateTimeLimitedItems()
		PetShop:updateTimeLimitedItems()
		
		local var_61_7 = ShopChapterUtil:getShopChatperObj()
		
		if var_61_7 and var_61_7.updateTimeLimitedItems then
			var_61_7:updateTimeLimitedItems()
		end
		
		local var_61_8 = ShopChapterUtil:getShopChatperObj(true)
		
		if var_61_8 and var_61_8.updateTimeLimitedItems then
			var_61_8:updateTimeLimitedItems()
		end
		
		ShopChapterPopupChapterList:updateScrollItems()
		ShopGuerrilla:updateTimeLimitedItems()
		ShopPopupShop:updatePopupShopList()
		ShopSkin:updateSoldOutItems()
		ShopDuplEquipPopup:updateSoldOutItems()
		LotaShopUI:updateTimeLimitedItems()
		Shop:onBuyItem(arg_61_0.item)
	end
	
	SceneManager:dispatchGameEvent("shop_buy", arg_61_0)
	
	if arg_61_0.rewards and arg_61_0.rewards.new_items then
		for iter_61_2, iter_61_3 in pairs(arg_61_0.rewards.new_items) do
			if iter_61_3.code == "ma_poe017" then
				TutorialGuide:ifStartGuide(ShopChapterForcePopup:isShow() and "tuto_merc_shop2" or "tuto_merc_shop1")
			end
		end
	end
end

Shop = Shop or {}

function Shop.getTokenCategory(arg_62_0, arg_62_1)
	if string.starts(arg_62_1, "to_") then
		arg_62_1 = string.sub(arg_62_1, 4, -1)
	end
	
	return ({
		food = "currency",
		trial = "currency",
		ticketnormal = "friendship",
		mazekey = "dungeon",
		gold = "currency",
		abysskey = "currency",
		pvpkey = "promotion",
		ticketmoon = "herocoin",
		crystal = "crystal",
		ticketice45 = "ticket",
		ticketspecial = "promotion",
		mazekey2 = "dungeon",
		ticketwind35 = "ticket",
		dlcticket = "currency",
		ticketfire45 = "ticket",
		ticketice35 = "ticket",
		stamina = "promotion",
		ticketrare = "currency",
		ticketskin = "promotion",
		ticketfire35 = "ticket",
		ticketwind45 = "ticket"
	})[arg_62_1]
end

function Shop.openTokenShop(arg_63_0, arg_63_1, arg_63_2)
	arg_63_0:open(nil, arg_63_0:getTokenCategory(arg_63_1), arg_63_2)
end

function Shop.open(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	arg_64_3 = arg_64_3 or {}
	
	if ContentDisable:byAlias("market") or ContentDisable:byButton(arg_64_2) then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_64_0.promotion_item_id = arg_64_3.promotion_item_id
	arg_64_0.tab_opts = arg_64_3.tab_opts
	
	local var_64_0 = arg_64_0:getTokenCategory(arg_64_2)
	
	if var_64_0 then
		arg_64_2 = var_64_0
	end
	
	if SceneManager:getCurrentSceneName() == "shop" then
		if MusicBoxUI:isShow() then
			MusicBoxUI:close()
		end
		
		if SubStoryEntrance:isVisible() then
			SubStoryEntrance:close()
		end
		
		if DungeonHome:isVisible() then
			DungeonHome:close()
		end
		
		arg_64_0:selectTab(arg_64_2, arg_64_3)
		
		return 
	end
	
	arg_64_3.type = arg_64_1
	arg_64_3.category = arg_64_2
	arg_64_0.open_info = arg_64_3
	
	if checkIapInitializeCompleteAndBalloonMessage() then
		query("market")
	end
end

function Shop.query(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	arg_65_3 = arg_65_3 or {}
	arg_65_3.type = arg_65_1
	arg_65_3.category = arg_65_2
	
	if SceneManager:getCurrentSceneName() == "shop" then
		arg_65_0:selectTab(arg_65_2, arg_65_3)
	else
		if arg_65_1 and arg_65_2 then
			arg_65_0.open_info = arg_65_3
		else
			arg_65_0.open_info = nil
		end
		
		if checkIapInitializeCompleteAndBalloonMessage() then
			query("market")
		end
	end
end

function Shop.onAfterUpdate(arg_66_0)
	local var_66_0 = os.time()
	
	if arg_66_0.vars.last_tick == var_66_0 then
		return 
	end
	
	arg_66_0.vars.last_tick = var_66_0
	
	arg_66_0:updateTimeLimitedItems(var_66_0)
	arg_66_0:topbarUpdate()
end

function ShopCommon.GetRestCount(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = arg_67_1.limit_count
	local var_67_1 = arg_67_1.limit_period
	local var_67_2 = var_67_0
	
	if AccountData.limits["sh:" .. arg_67_1.id] and var_67_0 then
		var_67_2 = var_67_0 - Account:getLimitCount("sh:" .. arg_67_1.id)
	end
	
	return var_67_2, var_67_0, var_67_1
end

function ShopCommon.updateTimeLimitedItems(arg_68_0, arg_68_1)
	if not arg_68_0.ScrollViewItems then
		return 
	end
	
	arg_68_1 = arg_68_1 or os.time()
	
	local var_68_0 = false
	
	for iter_68_0, iter_68_1 in pairs(arg_68_0.ScrollViewItems) do
		local var_68_1 = iter_68_1.control:getName() == "shop_card2" or iter_68_1.control:getName() == "shop_card_group" or false
		local var_68_2
		local var_68_3
		
		if iter_68_1.item.limit_cooltime then
			var_68_3 = arg_68_0:getRestCoolTime(iter_68_1.item.id, arg_68_1)
			
			if_set_visible(iter_68_1.control, "n_time", var_68_3 and var_68_3 > 0)
		elseif iter_68_1.item.limit_period == "clan_buff" then
			var_68_2 = arg_68_0:getRestClanBuffTime(iter_68_1.item)
			
			if_set_visible(iter_68_1.control, "n_time", var_68_2 and var_68_2 > 0)
		else
			var_68_2 = arg_68_0:getRestTime(iter_68_1.item.id, arg_68_1)
			
			if_set_visible(iter_68_1.control, "n_time", var_68_2 and var_68_2 > 0)
		end
		
		local var_68_4 = iter_68_1.control:getChildByName("btn_go")
		
		if var_68_2 and var_68_2 > 0 or var_68_3 and var_68_3 > 0 then
			if var_68_1 then
				if_set_opacity(iter_68_1.control, "n_badge", 76.5)
				if_set_opacity(iter_68_1.control, "RIGHT", 76.5)
			else
				if_set_opacity(iter_68_1.control, "badge_hot", 76.5)
				if_set_opacity(iter_68_1.control, "badge_limited", 76.5)
				if_set_opacity(iter_68_1.control, "badge_new", 76.5)
				if_set_opacity(iter_68_1.control, "badge_free", 76.5)
				if_set_opacity(iter_68_1.control, "n_cost", 76.5)
				if_set_opacity(iter_68_1.control, "n_right", 76.5)
			end
			
			if_set_opacity(iter_68_1.control, "n_base", 76.5)
			if_set_opacity(iter_68_1.control, "n_counter", 76.5)
			if_set_opacity(iter_68_1.control, "n_custom_badge", 76.5)
			
			iter_68_1.control.soldout = true
			var_68_0 = true
		else
			if var_68_1 then
				if_set_opacity(iter_68_1.control, "n_badge", 255)
				if_set_opacity(iter_68_1.control, "RIGHT", 255)
			else
				if_set_opacity(iter_68_1.control, "badge_hot", 255)
				if_set_opacity(iter_68_1.control, "badge_limited", 255)
				if_set_opacity(iter_68_1.control, "badge_new", 255)
				if_set_opacity(iter_68_1.control, "badge_free", 255)
				if_set_opacity(iter_68_1.control, "n_cost", 255)
				if_set_opacity(iter_68_1.control, "n_right", 255)
			end
			
			if_set_opacity(iter_68_1.control, "n_base", 255)
			if_set_opacity(iter_68_1.control, "n_custom_badge", 255)
			if_set_opacity(iter_68_1.control, "n_counter", 255)
		end
		
		local var_68_5, var_68_6, var_68_7 = arg_68_0:GetRestCount(iter_68_1.item, arg_68_1)
		
		if var_68_2 then
			if var_68_2 > 0 and var_68_7 ~= "only_once" and not iter_68_1.item.gacha_id and not iter_68_1.item.buy_once then
				if_set_visible(iter_68_1.control, "grow", true)
				if_set(iter_68_1.control, "txt_time", T("time_reset_shop", {
					time = sec_to_string(var_68_2)
				}))
			else
				if_set_visible(iter_68_1.control, "txt_time", false)
				if_set_visible(iter_68_1.control, "grow", false)
			end
		end
		
		if var_68_3 then
			if var_68_3 > 0 and var_68_7 ~= "only_once" and not iter_68_1.item.gacha_id and not iter_68_1.item.buy_once then
				if_set(iter_68_1.control, "txt_time", T("time_reset_shop", {
					time = sec_to_string(var_68_3)
				}))
				if_set_visible(iter_68_1.control, "grow", true)
			else
				if_set_visible(iter_68_1.control, "txt_time", false)
				if_set_visible(iter_68_1.control, "grow", false)
			end
		end
		
		if var_68_6 then
			if_set(iter_68_1.control, "txt_count", var_68_5 .. "/" .. var_68_6)
			
			if var_68_7 then
				if iter_68_1.item.category == "pvp" and iter_68_1.item.type == "d0005" then
					if_set(iter_68_1.control, "txt_count_info", T("shop_period_custom_rotation", {
						count = var_68_6
					}))
				else
					if_set(iter_68_1.control, "txt_count_info", T("shop_period_" .. var_68_7, "shop_period_" .. var_68_7 .. "(#count#)", {
						count = var_68_6
					}))
				end
			else
				if_set(iter_68_1.control, "txt_count_info", "")
			end
			
			set_scale_fit_width(iter_68_1.control:getChildByName("txt_count_info"), 255 + (VIEW_WIDTH - 1280))
			
			iter_68_1.item.rest_count = var_68_5
		else
			if_set_visible(iter_68_1.control, "txt_count_info", false)
		end
		
		if iter_68_1.item.token == "offer_wall" then
			if_set_opacity(iter_68_1.control, "n_btn_counter", 0)
			if_set(iter_68_1.control, "txt_buy", T("ui_offer_wall_get_free"))
			
			local var_68_8 = iter_68_1.control:getChildByName("txt_buy")
			
			if get_cocos_refid(var_68_8) and tolua.type(var_68_8) ~= "ccui.RichText" then
				var_68_8:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			end
		end
		
		if arg_68_0:isMultiPrice(iter_68_1.item) then
			arg_68_0:UpdatePayIcon(iter_68_1.control, iter_68_1.item)
		end
		
		if iter_68_1.item.equip_select == "y" then
			local var_68_9 = iter_68_1.control:getChildByName("n_group")
			
			if get_cocos_refid(var_68_9) then
				local var_68_10 = to_n(Account:getLimitCount("ds:eqr_" .. iter_68_1.item.category))
				local var_68_11 = iter_68_1.item.equip_select_refresh_max or 30
				
				if_set(var_68_9, "txt_group", T("shop_char_coin_refresh", {
					num1 = math.max(var_68_11 - var_68_10, 0),
					num2 = var_68_11
				}))
			end
		elseif iter_68_1.item.select_item == "y" then
			local var_68_12 = iter_68_1.control:getChildByName("n_group")
			
			if get_cocos_refid(var_68_12) then
				local var_68_13, var_68_14 = arg_68_0:updateAvailableCategorySelectItems(iter_68_1.item.category, iter_68_1.item.select_id)
				local var_68_15 = to_n(#var_68_13) - to_n(var_68_14)
				
				if var_68_15 < 1 then
					if_set(var_68_12, "txt_group", T("shop_package_b_purchased"))
					
					if var_68_1 then
						if_set_opacity(iter_68_1.control, "n_badge", 76.5)
						if_set_opacity(iter_68_1.control, "RIGHT", 76.5)
					else
						if_set_opacity(iter_68_1.control, "badge_hot", 76.5)
						if_set_opacity(iter_68_1.control, "badge_limited", 76.5)
						if_set_opacity(iter_68_1.control, "badge_new", 76.5)
						if_set_opacity(iter_68_1.control, "badge_free", 76.5)
						if_set_opacity(iter_68_1.control, "n_cost", 76.5)
						if_set_opacity(iter_68_1.control, "n_right", 76.5)
					end
					
					if_set_opacity(iter_68_1.control, "n_base", 76.5)
					if_set_opacity(iter_68_1.control, "n_counter", 76.5)
					if_set_opacity(iter_68_1.control, "n_custom_badge", 76.5)
					
					iter_68_1.control.soldout = true
					var_68_0 = true
				else
					if_set(var_68_12, "txt_group", T("shop_select_remain_count", {
						count = var_68_15
					}))
				end
			end
		end
	end
	
	return var_68_0
end

function Shop.onPushBackButton(arg_69_0)
	UIUtil:playNPCSoundRandomly("shop(" .. arg_69_0.vars.shop_type .. ").leave")
	
	local var_69_0 = SceneManager:getNextFlowSceneName()
	
	if var_69_0 and SubstoryManager:isRejectBackButtonNextFlowScene(var_69_0) then
		SceneManager:nextScene("lobby")
	elseif var_69_0 == "lota_lobby" then
		query("lota_enter")
		SceneManager:resetSceneFlow()
	elseif var_69_0 == "lota" then
		LotaNetworkSystem:sendQuery("lota_lobby")
		SceneManager:resetSceneFlow()
	else
		SceneManager:popScene()
	end
	
	arg_69_0.open_info = nil
end

function Shop.show(arg_70_0, arg_70_1)
	arg_70_1 = arg_70_1 or {}
	
	copy_functions(ShopCommon, Shop)
	
	if arg_70_0.open_info then
		arg_70_1.type = arg_70_1.type or arg_70_0.open_info.type
		arg_70_1.category = arg_70_1.category or arg_70_0.open_info.category
		arg_70_1.promotion_item_id = arg_70_1.promotion_item_id or arg_70_0.open_info.promotion_item_id
		arg_70_1.tab_opts = arg_70_1.tab_opts or arg_70_0.open_info.tab_opts
	end
	
	arg_70_0.promotion_item_id = arg_70_1.promotion_item_id
	arg_70_0.tab_opts = arg_70_1.tab_opts
	arg_70_1.type = arg_70_1.type or "normal"
	arg_70_0.ScrollViewItems = {}
	arg_70_0.vars = {}
	arg_70_0.vars.wnd = nil
	arg_70_0.vars.base_wnd = load_dlg("shop_base", true, "wnd")
	
	SceneManager:getDefaultLayer():addChild(arg_70_0.vars.base_wnd)
	arg_70_0.vars.base_wnd:setLocalZOrder(0)
	
	local var_70_0 = cc.Director:getInstance():getWinSize()
	
	arg_70_0:addNPC(arg_70_0.vars.base_wnd, arg_70_1.type)
	TopBarNew:create(T("shop_entrance"), arg_70_0.vars.base_wnd, function()
		Shop:onPushBackButton()
		BackButtonManager:pop("TopBarNew." .. T("shop_entrance"))
	end)
	
	if DEBUG.SHOP_DEBUG then
		arg_70_0:enter("special")
		
		return 
	end
	
	if arg_70_1.type then
		arg_70_0:enter(arg_70_1.type, arg_70_1.category, arg_70_1.skip_anim, true)
	end
	
	SoundEngine:play("event:/ui/main_hud/btn_shop")
	Scheduler:addSlow(arg_70_0.vars.base_wnd, arg_70_0.autoUpdate, arg_70_0)
	Shop:checkUnlockIcon(arg_70_0.vars.base_wnd)
	TutorialGuide:procGuide()
end

function Shop.checkUnlockIcon(arg_72_0, arg_72_1)
	local var_72_0 = arg_72_1:getChildByName("btn_enter_right")
	
	if get_cocos_refid(var_72_0) then
		local var_72_1 = UIUtil:changeBtnUnlockState(var_72_0, "img/cm_icon_etclock.png", UnlockSystem:isUnlockSystem(UNLOCK_ID.SPECIAL_SHOP), var_72_0, {
			no_world_space = true,
			opacity_full = true
		})
	end
end

function Shop.enter(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
	if arg_73_0.vars.shop_type == arg_73_1 then
		arg_73_0:selectTab(arg_73_2)
		
		return 
	end
	
	if (arg_73_1 == "normal" or arg_73_1 == nil) and arg_73_0.vars.left_girl == nil then
		arg_73_0:addLeftNPC(arg_73_0.vars.base_wnd)
	end
	
	arg_73_0.vars.shop_type = arg_73_1
	
	UIUtil:playNPCSoundRandomly("shop(" .. arg_73_0.vars.shop_type .. ").enter", 250)
	
	local var_73_0 = 300
	
	if arg_73_3 then
		var_73_0 = 0
	end
	
	if arg_73_0.vars.wnd == nil then
		arg_73_0.vars.wnd = load_dlg("shop_list", true, "wnd")
		
		if_set_visible(arg_73_0.vars.wnd, "btn_refresh", false)
		Shop:checkUnlockIcon(arg_73_0.vars.wnd)
		arg_73_0.vars.base_wnd:addChild(arg_73_0.vars.wnd)
		arg_73_0.vars.wnd:setLocalZOrder(0)
		
		arg_73_0.scrollview = arg_73_0.vars.wnd:getChildByName("n_scrollview"):getChildByName("scrollview")
	end
	
	if arg_73_0.vars.wnd_skin == nil then
		arg_73_0.vars.wnd_skin = ShopSkin:create()
		
		arg_73_0.vars.base_wnd:getChildByName("n_shop_skin"):addChild(arg_73_0.vars.wnd_skin)
		arg_73_0.vars.wnd_skin:setLocalZOrder(0)
		if_set_visible(arg_73_0.vars.base_wnd, "n_shop_skin", false)
	end
	
	if arg_73_0.vars.wnd_promotion == nil then
		arg_73_0.vars.wnd_promotion = ShopPromotion:create()
		
		arg_73_0.vars.base_wnd:getChildByName("n_shop_promotion"):addChild(arg_73_0.vars.wnd_promotion)
		arg_73_0.vars.wnd_promotion:setLocalZOrder(0)
		if_set_visible(arg_73_0.vars.base_wnd, "n_shop_promotion", false)
	end
	
	if arg_73_1 == "normal" then
		TopBarNew:setTitleName(T("shop_normal"))
	else
		TopBarNew:setTitleName(T("shop_special"))
	end
	
	UIAction:AddSmooth(LOG(MOVE(var_73_0, 30, -720, 30, 0, true), 3000), arg_73_0.vars.wnd:getChildByName("n_scrollview"), "block")
	if_set_visible(arg_73_0.vars.base_wnd, "n_left", arg_73_1 == nil)
	if_set_visible(arg_73_0.vars.base_wnd, "n_right", arg_73_1 == nil)
	if_set_visible(arg_73_0.vars.base_wnd, "bar", arg_73_1 == nil)
	arg_73_0.vars.wnd:setVisible(arg_73_1 ~= nil)
	
	if arg_73_1 then
		copy_functions(ScrollView, Shop)
		arg_73_0:clearScrollViewItems()
		arg_73_0:initScrollView(arg_73_0.scrollview, 690, 140)
		arg_73_0:updateCategories()
		
		local var_73_1 = arg_73_2 or 1
		local var_73_2 = true
		
		local function var_73_3(arg_74_0)
			local var_74_0 = arg_73_0.vars.categories[arg_74_0] or arg_74_0
			
			if var_74_0 then
				return not ContentDisable:byButton(var_74_0.id)
			end
			
			return false
		end
		
		if not var_73_3(var_73_1) then
			var_73_2 = false
			
			for iter_73_0 = 1, #arg_73_0.vars.categories do
				if var_73_3(iter_73_0) then
					var_73_1 = iter_73_0
					var_73_2 = true
					
					break
				end
			end
		end
		
		if not var_73_2 then
			Log.e("shop", "no enabled shop")
			arg_73_0:onPushBackButton()
			
			return 
		end
		
		arg_73_0:selectTab(var_73_1)
	end
end

function Shop.updateCategories(arg_75_0)
	local var_75_0 = os.time()
	
	arg_75_0.AllList = {}
	
	for iter_75_0, iter_75_1 in pairs(AccountData.shop) do
		arg_75_0.AllList[iter_75_0] = {}
		
		for iter_75_2, iter_75_3 in pairs(iter_75_1) do
			if iter_75_3.shop_type == arg_75_0.vars.shop_type and arg_75_0:addShopItem(iter_75_0, iter_75_3) then
				table.push(arg_75_0.AllList[iter_75_0], iter_75_3)
			end
		end
	end
	
	if arg_75_0.AllList.crystal and ContentDisable:byAlias("offer_wall") then
		table.delete_i(arg_75_0.AllList.crystal, function(arg_76_0, arg_76_1)
			return arg_76_1.token == "offer_wall"
		end)
	end
	
	local var_75_1 = {}
	
	arg_75_0.vars.categories = {}
	
	local function var_75_2(arg_77_0)
		local var_77_0, var_77_1, var_77_2, var_77_3, var_77_4, var_77_5, var_77_6, var_77_7 = DB("shop_category", arg_77_0, {
			"name",
			"desc",
			"sort",
			"icon",
			"topbar_currency",
			"badge",
			"option_badge",
			"option_badge_icon"
		})
		
		if not var_77_0 then
			return 
		end
		
		var_75_1[arg_77_0] = true
		
		local var_77_8 = false
		
		if arg_77_0 == "pet" then
			if UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
				var_77_8 = true
			end
		elseif arg_77_0 == "rarecoin" or arg_77_0 == "mooncoin" then
			var_77_8 = to_n(Account:getCurrency(arg_77_0)) > 0 or to_n((AccountData.currency_time or {})[arg_77_0]) > 0
		else
			var_77_8 = true
		end
		
		if var_77_8 then
			arg_75_0.vars.categories[#arg_75_0.vars.categories + 1] = {
				id = arg_77_0,
				name = var_77_0,
				desc = var_77_1,
				sort = var_77_2,
				icon = var_77_3,
				topbar_currency = var_77_4,
				badge = var_77_5,
				option_badge = var_77_6,
				option_badge_icon = var_77_7
			}
		end
	end
	
	for iter_75_4, iter_75_5 in pairs(arg_75_0.AllList) do
		if var_75_1[iter_75_4] or not (#iter_75_5 > 0) or getenv("zlong.restrict_shop", "false") == "true" and iter_75_4 == "promotion" then
		else
			var_75_2(iter_75_4)
		end
	end
	
	local var_75_3 = ShopPromotion:prepare("limitpack")
	
	if getenv("zlong.restrict_shop", "false") ~= "true" then
		var_75_2("promotion")
		
		if var_75_3 and #var_75_3 > 0 then
			var_75_2("limitpack")
		end
	end
	
	table.sort(arg_75_0.vars.categories, function(arg_78_0, arg_78_1)
		return arg_78_0.sort < arg_78_1.sort
	end)
	ShopCategories:init(arg_75_0.vars.wnd, arg_75_0.vars.categories, arg_75_0.vars.shop_type)
end

function Shop.addNPC(arg_79_0, arg_79_1, arg_79_2)
	local var_79_0 = UIUtil:getPortraitAni("npc1002", {})
	
	var_79_0:setScale(1.3)
	var_79_0:setPosition(5, -5)
	arg_79_1:getChildByName("n_portrait"):addChild(var_79_0)
	
	arg_79_0.vars.left_girl = var_79_0
end

function Shop.onBuyItem(arg_80_0, arg_80_1)
	if not AccountData.shop then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "shop" then
		return 
	end
	
	if AccountData.shop.crystal then
		for iter_80_0, iter_80_1 in pairs(AccountData.shop.crystal) do
			if iter_80_1.id == arg_80_1 then
				arg_80_0:updateCategories()
				arg_80_0:selectTab("crystal", {
					no_scroll = true
				})
				
				return 
			end
		end
	end
end

function Shop.update(arg_81_0)
	arg_81_0:updateCategories()
	arg_81_0:selectTab()
end

function Shop.selectTab(arg_82_0, arg_82_1, arg_82_2)
	arg_82_2 = arg_82_2 or {}
	
	local var_82_0 = arg_82_2.promotion_item_id or arg_82_0.promotion_item_id
	
	arg_82_0.promotion_item_id = nil
	
	local var_82_1 = arg_82_2.tab_opts or arg_82_0.tab_opts
	
	arg_82_0.tab_opts = nil
	
	if var_82_1 then
		for iter_82_0, iter_82_1 in pairs(var_82_1) do
			arg_82_2[iter_82_0] = iter_82_1
		end
	end
	
	if type(arg_82_1) == "string" then
		for iter_82_2, iter_82_3 in pairs(arg_82_0.vars.categories) do
			if iter_82_3.id == arg_82_1 then
				arg_82_1 = iter_82_2
				
				break
			end
		end
	end
	
	arg_82_1 = arg_82_1 or 1
	
	local var_82_2 = arg_82_0.vars.categories[arg_82_1]
	
	if var_82_2 == nil then
		return 
	end
	
	if var_82_2.id == "herocoin" and not arg_82_0.vars.new_boss_units then
		arg_82_0.vars.new_boss_units = arg_82_0:expireShopNewBossUnits()
	end
	
	if var_82_2.id == "limitpack" then
		local var_82_3 = ShopPromotion:prepare("limitpack")
		
		if not var_82_3 or #var_82_3 <= 0 then
			arg_82_0:updateCategories()
			arg_82_0:selectTab(1)
			Dialog:msgBox(T("limitpack_empty_desc"))
			
			return 
		end
	end
	
	arg_82_0.List = arg_82_0:getCategoryShopItems(var_82_2.id)
	
	Analytics:toggleTab(var_82_2.id)
	
	arg_82_0.vars.current_category_id = var_82_2.id
	
	ShopCategories:updateIndex(arg_82_1)
	
	if not arg_82_2.no_scroll then
		ShopCategories:scrollToIndex(arg_82_1 or 1)
	end
	
	if var_82_2.topbar_currency then
		if var_82_2.id == "crystal" then
			TopBarNew:setCurrencies(string.split(var_82_2.topbar_currency, ";"), getUserLanguage() == "ja")
		elseif var_82_2.id == "pvp" then
			local var_82_4 = string.split(var_82_2.topbar_currency, ";")
			local var_82_5 = AccountData.season_period_db.season_reward_id
			local var_82_6 = "pvphonor"
			
			if var_82_5 == "to_pvphonor" then
				var_82_6 = "pvphonor2"
			end
			
			table.deleteByValue(var_82_4, var_82_6)
			TopBarNew:setCurrencies(var_82_4)
		else
			TopBarNew:setCurrencies(string.split(var_82_2.topbar_currency, ";"))
		end
	else
		TopBarNew:setCurrencies()
	end
	
	if var_82_2.id == "skin" then
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_base", false)
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_skin", true)
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_promotion", false)
		if_set_visible(arg_82_0.vars.wnd, "n_scrollview", false)
		ShopSkin:enterSkinShop(arg_82_0.List, arg_82_2.default_skin_material_id)
	elseif var_82_2.id == "promotion" or var_82_2.id == "limitpack" then
		if ContentDisable:byAlias("market_promotion") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_base", false)
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_skin", false)
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_promotion", true)
		if_set_visible(arg_82_0.vars.wnd, "n_scrollview", false)
		ShopPromotion:enter(var_82_0, var_82_2.id)
	else
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_base", true)
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_skin", false)
		if_set_visible(arg_82_0.vars.base_wnd, "n_shop_promotion", false)
		if_set_visible(arg_82_0.vars.wnd, "n_scrollview", true)
		SAVE:setUserDefaultData("shop_copen_time_" .. var_82_2.id, os.time())
		arg_82_0:updateList(arg_82_1)
		arg_82_0.scrollview:scrollToPercentVertical(0, 0, true)
		
		local var_82_7 = arg_82_0.vars.base_wnd:getChildByName("n_time_info")
		
		if get_cocos_refid(var_82_7) then
			var_82_7:setVisible(true)
			if_set_visible(var_82_7, "n_conquest_shop_info", false)
			if_set_visible(var_82_7, "n_powder_refresh_info", false)
			if_set_visible(var_82_7, "n_powder_refresh_info_arti_pick_up", false)
			if_set_visible(var_82_7, "n_coin_info", false)
			if_set_visible(var_82_7, "n_group_info", false)
			
			if var_82_2.id == "powder" and arg_82_0.List[1] then
				arg_82_0:updateLeftTime()
			elseif var_82_2.id == "pvp" and arg_82_0.List[1] then
				arg_82_0:updateLeftTime()
			elseif var_82_2.id == "mooncoin" and arg_82_0.List[1] then
				arg_82_0:updateLeftTime()
				
				local var_82_8 = var_82_7:getChildByName("n_coin_info")
				
				if_set(var_82_8, "t_coin", T("shop_title_mooncoin"))
				if_set(var_82_8, "t_disc", T("shop_char_hero_change_info"))
				
				local var_82_9 = var_82_8:getChildByName("n_icon")
				local var_82_10 = cc.Sprite:create("img/icon_menu_mooncoin.png")
				
				if get_cocos_refid(var_82_10) then
					var_82_9:removeAllChildren()
					var_82_9:addChild(var_82_10)
				end
			elseif var_82_2.id == "rarecoin" and arg_82_0.List[1] then
				arg_82_0:updateLeftTime()
				
				local var_82_11 = var_82_7:getChildByName("n_coin_info")
				
				if_set(var_82_11, "t_coin", T("shop_title_rarecoin"))
				if_set(var_82_11, "t_disc", T("shop_char_hero_change_info"))
				
				local var_82_12 = var_82_11:getChildByName("n_icon")
				local var_82_13 = cc.Sprite:create("img/icon_menu_rarecoin.png")
				
				if get_cocos_refid(var_82_13) then
					var_82_12:removeAllChildren()
					var_82_12:addChild(var_82_13)
				end
			elseif var_82_2.id == "miragecoin" and arg_82_0.List[1] then
				arg_82_0:updateLeftTime()
				
				local var_82_14 = var_82_7:getChildByName("n_group_info")
				local var_82_15 = var_82_14:getChildByName("n_icon_gp")
				local var_82_16 = cc.Sprite:create("img/icon_menu_gpmileage.png")
				
				if get_cocos_refid(var_82_16) then
					var_82_15:removeAllChildren()
					var_82_15:addChild(var_82_16)
				end
				
				local var_82_17 = DB("item_token", "to_gpmileage1", {
					"name"
				})
				
				if_set(var_82_14, "t_gp_shop", T("shop_gpmileage_warning", {
					token_type = T(var_82_17)
				}))
				if_set(var_82_14, "t_disc_gp_shop", T("shop_gpmileage_info"))
				
				local var_82_18 = var_82_14:getChildByName("n_balloon")
				
				if to_n(arg_82_0.List[1].end_time) - 604800 < os.time() then
					if_set(var_82_18, "txt_balloon", T("shop_gpmileage_balloon_after", {
						token_type = T(var_82_17)
					}))
				else
					if_set(var_82_18, "txt_balloon", T("shop_gpmileage_balloon_during", {
						token_type = T(var_82_17)
					}))
				end
			elseif var_82_2.id == "moon_miragecoin" and arg_82_0.List[1] then
				arg_82_0:updateLeftTime()
				
				local var_82_19 = var_82_7:getChildByName("n_group_info")
				local var_82_20 = var_82_19:getChildByName("n_icon_gp")
				local var_82_21 = cc.Sprite:create("img/icon_menu_gpmileage2.png")
				
				if get_cocos_refid(var_82_21) then
					var_82_20:removeAllChildren()
					var_82_20:addChild(var_82_21)
				end
				
				local var_82_22 = DB("item_token", "to_gpmileage2", {
					"name"
				})
				
				if_set(var_82_19, "t_gp_shop", T("ui_ct_gachaspecial_shop_info", {
					token_type = T(var_82_22)
				}))
				if_set(var_82_19, "t_disc_gp_shop", T("ui_ct_gachaspecial_shop_close_info"))
				
				local var_82_23 = var_82_19:getChildByName("n_balloon")
				
				if to_n(arg_82_0.List[1].end_time) - 604800 < os.time() then
					if_set(var_82_23, "txt_balloon", T("npc_ct_gachaspecial_shop_close", {
						token_type = T(var_82_22)
					}))
				else
					if_set(var_82_23, "txt_balloon", T("npc_ct_gachaspecial_shop_open", {
						token_type = T(var_82_22)
					}))
				end
			end
		end
	end
	
	SoundEngine:play("event:/ui/btn_ok")
end

function Shop.onSelectScrollViewItem(arg_83_0, arg_83_1, arg_83_2)
end

function Shop.autoUpdate(arg_84_0)
	arg_84_0:updateLeftTime()
end

function Shop.getCurrentCategoryId(arg_85_0)
	if not arg_85_0.vars then
		return nil
	end
	
	return arg_85_0.vars.current_category_id
end

function Shop.popupPowderGachaList(arg_86_0)
	if not arg_86_0.vars or arg_86_0.vars.current_category_id ~= "powder" then
		return 
	end
	
	local var_86_0 = load_dlg("shop_arti_info", true, "wnd")
	local var_86_1 = var_86_0:getChildByName("ScrollView")
	local var_86_2 = ItemListView_v2:bindControl(var_86_1)
	local var_86_3 = load_control("wnd/shop_arti_info_item.csb")
	
	if var_86_1.STRETCH_INFO then
		local var_86_4 = var_86_1:getContentSize()
		
		resetControlPosAndSize(var_86_3, var_86_4.width, var_86_1.STRETCH_INFO.width_prev)
	end
	
	local var_86_5 = {
		onUpdate = function(arg_87_0, arg_87_1, arg_87_2, arg_87_3)
			local var_87_0 = DB("equip_item", arg_87_3.type, "name")
			
			UIUtil:getRewardIcon(nil, arg_87_3.type, {
				no_popup = true,
				name = false,
				no_tooltip = true,
				role = true,
				scale = 1,
				parent = arg_87_1:getChildByName("n_arti_icon")
			})
			
			local var_87_1 = arg_87_1:getChildByName("n_arti_info")
			
			if_set(var_87_1, "t_name", T(var_87_0))
			UIUserData:call(var_87_1:getChildByName("t_name"), "SINGLE_WSCALE(385)")
			UIUserData:call(var_87_1:getChildByName("t_period"), "SINGLE_WSCALE(385)")
			UIUserData:call(var_87_1:getChildByName("t_period_info"), "SINGLE_WSCALE(385)")
			if_set(var_87_1, "t_period_info", T("time_slash_period_y_m_d_time", timeToStringDef({
				preceding_with_zeros = true,
				start_time = arg_87_3.start_time,
				end_time = arg_87_3.end_time
			})))
			
			return arg_87_2
		end
	}
	
	var_86_2:setRenderer(var_86_3, var_86_5)
	var_86_2:removeAllChildren()
	
	local var_86_6 = {}
	
	for iter_86_0, iter_86_1 in pairs(arg_86_0.List or {}) do
		if iter_86_1.gacha_id then
			table.push(var_86_6, iter_86_1)
		end
	end
	
	var_86_2:setDataSource(var_86_6)
	Dialog:msgBox("", {
		dlg = var_86_0
	})
end

function Shop.updateLeftTime(arg_88_0)
	if arg_88_0.vars.current_category_id then
		local var_88_0 = arg_88_0.vars.base_wnd:getChildByName("n_time_info")
		
		if arg_88_0.vars.current_category_id == "powder" and arg_88_0.List[1] then
			local var_88_1 = 0
			local var_88_2
			
			for iter_88_0, iter_88_1 in pairs(arg_88_0.List) do
				if iter_88_1.gacha_id then
					var_88_1 = var_88_1 + 1
				elseif iter_88_1.end_time then
					var_88_2 = var_88_2 or iter_88_1.end_time
				end
			end
			
			if_set_visible(var_88_0, "n_powder_refresh_info", var_88_1 == 0)
			if_set_visible(var_88_0, "n_powder_refresh_info_arti_pick_up", var_88_1 > 0)
			
			if var_88_1 > 0 then
				local var_88_3 = var_88_0:getChildByName("n_powder_refresh_info_arti_pick_up")
				local var_88_4 = to_n(var_88_2) - os.time()
				
				if var_88_4 > 0 then
					if_set(var_88_3, "time", T("special_normal_remain", {
						remain_time = sec_to_full_string(var_88_4)
					}))
				else
					if_set(var_88_3, "time", T("expired"))
				end
			else
				local var_88_5 = var_88_0:getChildByName("n_powder_refresh_info")
				local var_88_6 = to_n(var_88_2) - os.time()
				
				if var_88_6 > 0 then
					if_set(var_88_5, "time", T("special_normal_remain", {
						remain_time = sec_to_full_string(var_88_6)
					}))
				else
					if_set(var_88_5, "time", T("expired"))
				end
			end
		elseif arg_88_0.vars.current_category_id == "pvp" and arg_88_0.List[1] then
			if AccountData.season_period_db then
				if_set_visible(var_88_0, "n_conquest_shop_info", true)
				
				local var_88_7 = var_88_0:getChildByName("n_conquest_shop_info")
				local var_88_8 = var_88_7:getChildByName("icon_menu")
				local var_88_9 = false
				
				if_set(var_88_8, "text_title", T(AccountData.season_period_db.shop_name))
				
				local var_88_10 = os.time()
				
				if (AccountData.season_period_db.end_time - var_88_10) / 86400 < to_n(AccountData.season_period_db.end_term) then
					local var_88_11 = timeToStringDef({
						preceding_with_zeros = true,
						time = AccountData.season_period_db.end_time
					})
					
					if_set(var_88_7, "txt_season_remaining", T("pvp_season_off", var_88_11) .. " " .. var_88_11.time)
					
					var_88_9 = true
				end
				
				if var_88_9 then
					var_88_8:setPositionY(287)
					if_set_visible(var_88_7, "txt_season_remaining", true)
				else
					var_88_8:setPositionY(260)
					if_set_visible(var_88_7, "txt_season_remaining", false)
				end
			end
		elseif arg_88_0.vars.current_category_id == "mooncoin" and arg_88_0.List[1] then
			if_set_visible(var_88_0, "n_coin_info", true)
			
			local var_88_12 = var_88_0:getChildByName("n_coin_info")
			local var_88_13 = to_n(arg_88_0.List[1].end_time) - os.time()
			
			if var_88_13 > 0 then
				if_set(var_88_12, "t_coin_time", T("shop_char_token_limit_desc", {
					time = sec_to_full_string(var_88_13)
				}))
			else
				if_set(var_88_12, "t_coin_time", T("expired"))
			end
		elseif arg_88_0.vars.current_category_id == "rarecoin" and arg_88_0.List[1] then
			if_set_visible(var_88_0, "n_coin_info", true)
			
			local var_88_14 = var_88_0:getChildByName("n_coin_info")
			local var_88_15 = to_n(arg_88_0.List[1].end_time) - os.time()
			
			if var_88_15 > 0 then
				if_set(var_88_14, "t_coin_time", T("shop_char_token_limit_desc", {
					time = sec_to_full_string(var_88_15)
				}))
			else
				if_set(var_88_14, "t_coin_time", T("expired"))
			end
		elseif arg_88_0.vars.current_category_id == "miragecoin" and arg_88_0.List[1] then
			if_set_visible(var_88_0, "n_group_info", true)
			
			local var_88_16 = var_88_0:getChildByName("n_group_info")
			local var_88_17 = to_n(arg_88_0.List[1].end_time) - os.time()
			
			if var_88_17 > 0 then
				if_set(var_88_16, "time", T("shop_gpmileage_remain_time", {
					remain_time = sec_to_full_string(var_88_17)
				}))
			else
				if_set(var_88_16, "time", T("expired"))
			end
		elseif arg_88_0.vars.current_category_id == "moon_miragecoin" and arg_88_0.List[1] then
			if_set_visible(var_88_0, "n_group_info", true)
			
			local var_88_18 = var_88_0:getChildByName("n_group_info")
			local var_88_19 = to_n(arg_88_0.List[1].end_time) - os.time()
			
			if var_88_19 > 0 then
				if_set(var_88_18, "time", T("shop_gpmileage_remain_time", {
					remain_time = sec_to_full_string(var_88_19)
				}))
			else
				if_set(var_88_18, "time", T("expired"))
			end
		end
	end
end

function Shop.updateList(arg_89_0, arg_89_1)
	arg_89_0.vars.DB = {}
	
	local var_89_0 = os.time()
	
	for iter_89_0, iter_89_1 in pairs(arg_89_0.List) do
		local var_89_1, var_89_2, var_89_3 = arg_89_0:GetRestCount(iter_89_1, var_89_0)
		local var_89_4 = 999
		
		if iter_89_1.category and iter_89_1.select_id then
			local var_89_5, var_89_6 = arg_89_0:updateAvailableCategorySelectItems(iter_89_1.category, iter_89_1.select_id)
			
			var_89_4 = to_n(#var_89_5) - to_n(var_89_6)
		end
		
		if not (var_89_3 ~= "only_once" and not iter_89_1.buy_once) and var_89_2 and to_n(var_89_1) < 1 or var_89_4 < 1 then
			iter_89_1.sold_out = true
			iter_89_1.sort = iter_89_1.sort + 100000
		end
		
		arg_89_0.vars.DB[iter_89_1.id] = iter_89_1
	end
	
	table.sort(arg_89_0.List, function(arg_90_0, arg_90_1)
		return tonumber(arg_90_0.sort) < tonumber(arg_90_1.sort)
	end)
	
	if arg_89_0.vars.current_category_id == "pvp" then
		arg_89_0:initScrollView(arg_89_0.scrollview, 690, 194)
	else
		arg_89_0:initScrollView(arg_89_0.scrollview, 690, 140)
	end
	
	arg_89_0:createScrollViewItems(arg_89_0.List)
	arg_89_0:updateTimeLimitedItems(os.time())
	arg_89_0:jumpToPercent(0)
end

function Shop.onDialogTouchDown(arg_91_0, arg_91_1, arg_91_2, arg_91_3)
end

Shop.onDialogTouchMove = Shop.onDialogTouchDown

function Shop.onTouchDown(arg_92_0, arg_92_1, arg_92_2)
	arg_92_0:onDialogTouchDown(nil, arg_92_1, arg_92_2)
	
	if arg_92_0.tabs then
		local var_92_0 = checkUIPick(arg_92_0.tabs, arg_92_1, arg_92_2)
		
		if var_92_0 then
			arg_92_0:selectTab(var_92_0)
		end
	end
end

function Shop.onTouchUp(arg_93_0, arg_93_1, arg_93_2)
end

function Shop.onTouchMove(arg_94_0, arg_94_1, arg_94_2)
	arg_94_0:onDialogTouchDown(nil, arg_94_1, arg_94_2)
end

function Shop.topbarUpdate(arg_95_0, arg_95_1)
end

ShopCategories = {}

function ShopCategories.init(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	copy_functions(ScrollView, ShopCategories)
	
	arg_96_0.vars = {}
	arg_96_0.vars.shop_type = arg_96_3
	arg_96_0.vars.idx = arg_96_4 or 1
	
	local var_96_0
	local var_96_1 = arg_96_1:getChildByName("n_shop1"):getChildByName("scrollview")
	
	arg_96_0:initScrollView(var_96_1, 210, 92, {
		fit_height = true
	})
	arg_96_0:clearScrollViewItems()
	arg_96_0:createScrollViewItems(arg_96_2)
	arg_96_0:updateIndex()
end

function ShopCategories.onSelectScrollViewItem(arg_97_0, arg_97_1, arg_97_2, arg_97_3)
	SoundEngine:play("event:/ui/category/select")
	
	if arg_97_0.vars.idx == arg_97_1 then
		return 
	end
	
	local var_97_0 = arg_97_0.ScrollViewItems[arg_97_1].item.id
	
	if ContentDisable:byButton(var_97_0) then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_97_0.vars.idx = arg_97_1
	
	arg_97_0:updateIndex()
	Shop:selectTab(arg_97_1)
end

function ShopCategories.updateIndex(arg_98_0, arg_98_1)
	if arg_98_1 then
		arg_98_0.vars.idx = arg_98_1
	end
	
	local var_98_0
	
	for iter_98_0, iter_98_1 in pairs(arg_98_0.ScrollViewItems) do
		local var_98_1 = iter_98_0 == arg_98_0.vars.idx
		
		iter_98_1.control.bg:setVisible(var_98_1)
		
		if var_98_1 and (iter_98_1.item.id == "rarecoin" or iter_98_1.item.id == "mooncoin") then
			if_set_visible(iter_98_1.control, "icon_new", false)
		end
	end
end

function ShopCategories.getScrollViewItem(arg_99_0, arg_99_1)
	local var_99_0 = cc.CSLoader:createNode("wnd/shop_bar.csb")
	
	var_99_0.desc = var_99_0:getChildByName("desc")
	var_99_0.title = var_99_0:getChildByName("title")
	var_99_0.bg = var_99_0:getChildByName("bg")
	
	UIUserData:call(var_99_0.title, "MULTI_SCALE_LONG_WORD()")
	if_set(var_99_0.title, nil, T(arg_99_1.name))
	if_set(var_99_0.desc, nil, T(arg_99_1.desc))
	
	var_99_0.guide_tag = arg_99_1.id
	
	if_set_sprite(var_99_0, "icon", "img/" .. tostring(arg_99_1.icon) .. ".png")
	if_set_visible(var_99_0, "icon_new", false)
	if_set_visible(var_99_0, "n_icon_badge", false)
	
	local var_99_1 = var_99_0:getChildByName("n_icon_badge")
	
	var_99_1:removeAllChildren()
	
	if arg_99_1.badge then
		local var_99_2 = SpriteCache:getSprite("img/" .. arg_99_1.badge .. ".png")
		
		if get_cocos_refid(var_99_2) then
			var_99_1:addChild(var_99_2)
			var_99_1:setVisible(true)
		end
	elseif arg_99_1.option_badge_icon and arg_99_1.option_badge then
		local var_99_3 = totable(arg_99_1.option_badge)
		
		if type(var_99_3) == "table" and var_99_3.all_require and type(var_99_3.all_require) == "table" then
			local var_99_4 = table.count(var_99_3.all_require)
			local var_99_5 = 0
			
			for iter_99_0, iter_99_1 in pairs(var_99_3.all_require) do
				if to_n(Account:getLimitCount("sh:" .. iter_99_1)) == 0 then
					var_99_5 = var_99_5 + 1
				end
			end
			
			if var_99_4 <= var_99_5 then
				local var_99_6 = SpriteCache:getSprite("img/" .. arg_99_1.option_badge_icon .. ".png")
				
				if get_cocos_refid(var_99_6) then
					var_99_1:addChild(var_99_6)
					var_99_1:setVisible(true)
				end
			end
		end
	end
	
	if arg_99_1.id == "rarecoin" or arg_99_1.id == "mooncoin" then
		local var_99_7 = SAVE:getUserDefaultData("shop_copen_time_" .. arg_99_1.id, 0)
		local var_99_8, var_99_9 = Account:serverTimeMonthInfo()
		
		if var_99_7 < var_99_8 then
			if_set_visible(var_99_0, "icon_new", true)
		end
	end
	
	if arg_99_1.id == "promotion" then
		if_set_visible(var_99_0, "icon_new", ShopPromotion:isNewPromotionVisibled() or ShopPromotion:canReceiveCustomPackageRewards())
	end
	
	if arg_99_1.id == "herocoin" then
		if_set_visible(var_99_0, "icon_new", Shop:isShopNewBossUnits())
	end
	
	return var_99_0
end

function Shop.getScrollViewItem(arg_100_0, arg_100_1)
	arg_100_1.is_limit_button = arg_100_0.vars.DB and arg_100_0.vars.DB[arg_100_1.id] and arg_100_0.vars.DB[arg_100_1.id].limit_count
	
	local var_100_0
	
	if arg_100_0.vars.current_category_id == "pvp" then
		var_100_0 = arg_100_0:makeShopItem2(arg_100_1, "wnd/shop_card2.csb")
	else
		var_100_0 = arg_100_0:makeShopItem(arg_100_1, "wnd/shop_card.csb")
	end
	
	if arg_100_0.vars.current_category_id == "herocoin" then
		local var_100_1 = var_100_0:getChildByName("LEFT2")
		
		if get_cocos_refid(var_100_1) and arg_100_1.buy_condition and type(arg_100_0.vars.new_boss_units) == "table" then
			local var_100_2 = totable(arg_100_1.buy_condition)
			
			if type(var_100_2) == "table" then
				if_set_visible(var_100_1, "badge_new", var_100_2.unit_require and arg_100_0.vars.new_boss_units[var_100_2.unit_require])
			end
		end
	end
	
	arg_100_0:updateTimeLimitedItems(os.time())
	
	var_100_0.guide_tag = arg_100_1.id
	
	return var_100_0
end

function Shop.reqBuy(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4)
	arg_101_3 = arg_101_3 or "normal"
	arg_101_4 = arg_101_4 or {}
	
	print("reqBuy item.id : ", arg_101_1.id, arg_101_1.token, arg_101_2)
	
	if PLATFORM ~= "win32" and arg_101_1.token == "cash" and arg_101_4.use_coupon ~= true then
		startIapBilling({
			shop = "normal",
			item_id = arg_101_1.id
		})
	else
		local var_101_0 = {
			item = arg_101_1.id,
			shop = arg_101_3,
			type = arg_101_1.type,
			multiply = arg_101_2 or 1
		}
		
		for iter_101_0, iter_101_1 in pairs(arg_101_4) do
			var_101_0[iter_101_0] = iter_101_1
		end
		
		if PLATFORM == "win32" and arg_101_1.token == "cash" then
			var_101_0.order_id = "test_" .. get_udid()
		end
		
		query("buy", var_101_0)
	end
end

function Shop.checkShopNewBossUnits(arg_102_0)
	local var_102_0 = GAME_CONTENT_VARIABLE.shop_new_boss_units or "c5004"
	local var_102_1 = string.split(var_102_0, ",")
	local var_102_2 = "shop_new_boss_units"
	local var_102_3 = SAVE:getKeep(var_102_2, {})
	local var_102_4 = 0
	
	for iter_102_0, iter_102_1 in ipairs(var_102_1) do
		if Account:getCollectionUnit(iter_102_1) and not var_102_3[iter_102_1] then
			var_102_3[iter_102_1] = 1
			var_102_4 = var_102_4 + 1
		end
	end
	
	if var_102_4 > 0 then
		SAVE:setKeep(var_102_2, var_102_3)
	end
end

function Shop.resetShopNewBossUnits(arg_103_0)
	local var_103_0 = "shop_new_boss_units"
	
	SAVE:setKeep(var_103_0, {})
end

function Shop.isShopNewBossUnits(arg_104_0)
	local var_104_0 = 0
	local var_104_1 = "shop_new_boss_units"
	local var_104_2 = SAVE:getKeep(var_104_1, {})
	
	for iter_104_0, iter_104_1 in pairs(var_104_2) do
		if to_n(iter_104_1) == 1 then
			var_104_0 = var_104_0 + 1
		end
	end
	
	return var_104_0 > 0
end

function Shop.expireShopNewBossUnits(arg_105_0)
	local var_105_0 = "shop_new_boss_units"
	local var_105_1 = SAVE:getKeep(var_105_0, {})
	local var_105_2 = 0
	local var_105_3
	
	for iter_105_0, iter_105_1 in pairs(var_105_1) do
		if to_n(iter_105_1) == 1 then
			var_105_1[iter_105_0] = 2
			var_105_2 = var_105_2 + 1
			var_105_3 = var_105_3 or {}
			var_105_3[iter_105_0] = true
		end
	end
	
	if var_105_2 > 0 then
		SAVE:setKeep(var_105_0, var_105_1)
	end
	
	return var_105_3
end

function MsgHandler.dupl_equip_shop(arg_106_0)
	ShopDuplEquipPopup:update(arg_106_0)
end

function HANDLER.shop_group_list(arg_107_0, arg_107_1)
	if arg_107_1 == "btn_close" then
		ShopDuplEquipPopup:close()
	elseif arg_107_1 == "btn_refresh" then
		ShopDuplEquipPopup:refresh()
	elseif arg_107_1 == "btn_buy" then
		ShopDuplEquipPopup:buy()
	elseif string.starts(arg_107_1, "btn_select_") then
		ShopDuplEquipPopup:select(to_n(string.split(arg_107_1, "btn_select_")[2]))
	end
end

ShopDuplEquipPopup = {}

copy_functions(ShopCommon, ShopDuplEquipPopup)

function ShopDuplEquipPopup.show(arg_108_0, arg_108_1)
	arg_108_0.vars = {}
	arg_108_0.vars.info = arg_108_1.item
	arg_108_0.vars.selected_index = nil
	
	if to_n(arg_108_0.vars.info.limit_count) <= to_n(Account:getLimitCount("sh:" .. arg_108_0.vars.info.id)) then
		balloon_message_with_sound("err_msg_cannot_buy")
		
		return 
	end
	
	local var_108_0 = {
		refresh = 0,
		category = arg_108_0.vars.info.category
	}
	
	if arg_108_0.vars.info.npc then
		var_108_0.npc = arg_108_0.vars.info.npc
	end
	
	query("dupl_equip_shop", var_108_0)
end

function ShopDuplEquipPopup.close(arg_109_0, arg_109_1)
	arg_109_0.vars = nil
	
	Dialog:close("shop_group_list")
end

function ShopDuplEquipPopup.buy(arg_110_0)
	if not arg_110_0.vars.selected_index then
		balloon_message_with_sound("err_msg_select_equip")
		
		return 
	end
	
	if to_n(arg_110_0.vars.info.limit_count) <= to_n(Account:getLimitCount("sh:" .. arg_110_0.vars.info.id)) then
		balloon_message_with_sound("err_msg_cannot_buy")
		
		return 
	end
	
	local var_110_0 = {}
	
	for iter_110_0, iter_110_1 in pairs(arg_110_0.vars.info) do
		if iter_110_0 ~= "equip_select" and iter_110_0 ~= "image" and iter_110_0 ~= "desc" then
			var_110_0[iter_110_0] = iter_110_1
		end
	end
	
	var_110_0.type = arg_110_0.vars.equip_list[arg_110_0.vars.selected_index].equip.code
	
	local var_110_1 = DB("equip_item", var_110_0.type, {
		"type"
	})
	
	var_110_0.desc = EQUIP.getGradeTitle(var_110_0.type, arg_110_0.vars.equip_list[arg_110_0.vars.selected_index].equip.g, var_110_1)
	var_110_0.data = arg_110_0.vars.equip_list[arg_110_0.vars.selected_index].equip
	var_110_0.sub_idx = arg_110_0.vars.selected_index
	
	arg_110_0:shopPopupBuy(var_110_0)
end

function ShopDuplEquipPopup.refresh(arg_111_0)
	if to_n(arg_111_0.vars.info.limit_count) <= to_n(Account:getLimitCount("sh:" .. arg_111_0.vars.info.id)) then
		balloon_message_with_sound("err_msg_cannot_refresh")
		
		return 
	end
	
	local var_111_0 = to_n(Account:getLimitCount("ds:eqr_" .. arg_111_0.vars.info.category))
	local var_111_1 = arg_111_0.vars.info.equip_select_refresh_max or 30
	
	if var_111_1 <= var_111_0 then
		balloon_message_with_sound("shop_char_equip_refresh_max")
		
		return 
	end
	
	Dialog:msgBox(T("txt_equip_refresh_desc", {
		num1 = math.max(var_111_1 - var_111_0, 0),
		num2 = var_111_1
	}), {
		yesno = true,
		handler = function()
			local var_112_0 = {
				refresh = 1,
				category = arg_111_0.vars.info.category
			}
			
			if arg_111_0.vars.info.npc then
				var_112_0.npc = arg_111_0.vars.info.npc
			end
			
			query("dupl_equip_shop", var_112_0)
		end,
		title = T("txt_equip_refresh_title")
	})
end

function ShopDuplEquipPopup.updateTokenUI(arg_113_0)
	if_set(arg_113_0.vars.wnd, "txt_token", comma_value(to_n(Account:getCurrency(arg_113_0.vars.info.token))))
	
	local var_113_0 = arg_113_0.vars.wnd:getChildByName("txt_token")
	local var_113_1 = DB("item_token", arg_113_0.vars.info.token, {
		"icon"
	})
	
	if_set_sprite(var_113_0, "token", "item/" .. (var_113_1 or "") .. ".png")
	
	local var_113_2 = arg_113_0.vars.wnd:getChildByName("n_btn"):getChildByName("btn_buy")
	
	UIUtil:getRewardIcon(nil, arg_113_0.vars.info.token, {
		no_frame = true,
		scale = 0.6,
		parent = var_113_2:getChildByName("n_pay_token")
	})
	if_set(var_113_2, "txt_price", comma_value(to_n(arg_113_0.vars.info.price)))
	
	local var_113_3 = to_n(arg_113_0.vars.info.limit_count)
	local var_113_4 = var_113_3 - to_n(Account:getLimitCount("sh:" .. arg_113_0.vars.info.id))
	
	if_set(var_113_2, "txt_count", T("event_package_buy_availability", {
		count = string.format("(%d/%d)", var_113_4, var_113_3)
	}))
end

function ShopDuplEquipPopup.update(arg_114_0, arg_114_1)
	if not arg_114_0.vars then
		return 
	end
	
	if arg_114_1 then
		if arg_114_1.updated_limit then
			Account:updateLimits(arg_114_1.updated_limit)
		end
		
		arg_114_0.vars.equip_list = arg_114_1.equip_list
	end
	
	arg_114_0.vars.selected_index = nil
	
	table.sort(arg_114_0.vars.equip_list, function(arg_115_0, arg_115_1)
		return to_n(arg_115_0.slot) < to_n(arg_115_1.slot)
	end)
	
	if not get_cocos_refid(arg_114_0.vars.wnd) then
		arg_114_0.vars.wnd = Dialog:open("wnd/shop_group_list", arg_114_0, {
			modal = true,
			use_backbutton = true
		})
		
		SceneManager:getRunningPopupScene():addChild(arg_114_0.vars.wnd)
	end
	
	if_set(arg_114_0.vars.wnd, "title", T("txt_char_shop_equip_title"))
	
	local var_114_0 = arg_114_0.vars.wnd:getChildByName("n_btn"):getChildByName("btn_refresh")
	local var_114_1 = to_n(Account:getLimitCount("ds:eqr_" .. arg_114_0.vars.info.category))
	local var_114_2 = arg_114_0.vars.info.equip_select_refresh_max or 30
	
	if_set(var_114_0, "label", T("shop_char_coin_refresh", {
		num1 = math.max(var_114_2 - var_114_1, 0),
		num2 = var_114_2
	}))
	arg_114_0:updateTokenUI()
	
	for iter_114_0, iter_114_1 in pairs(arg_114_0.vars.equip_list) do
		local var_114_3 = EQUIP:createByInfo(iter_114_1.equip)
		local var_114_4 = arg_114_0.vars.wnd:getChildByName("n_weapon_" .. iter_114_0)
		
		if_set_visible(var_114_4, "n_completed", to_n(iter_114_1.buy_time) > 0)
		
		local var_114_5 = var_114_4:getChildByName("n_item_detail_sub")
		
		var_114_5:removeAllChildren()
		var_114_5:setVisible(true)
		
		local var_114_6 = load_dlg("item_detail_sub", true, "wnd")
		
		var_114_6:setAnchorPoint(0, 0)
		var_114_6:setPosition(0, 0)
		ItemTooltip:updateItemInformation({
			detail = true,
			no_resize = true,
			wnd = var_114_6,
			equip = var_114_3
		})
		var_114_5:addChild(var_114_6)
		
		if to_n(iter_114_1.buy_time) > 0 then
			var_114_5:setOpacity(76.5)
		else
			var_114_5:setOpacity(255)
		end
	end
	
	ShopDuplEquipPopup:select(1)
end

function ShopDuplEquipPopup.updateSoldOutItems(arg_116_0)
	if not arg_116_0.vars or not get_cocos_refid(arg_116_0.vars.wnd) then
		return 
	end
	
	arg_116_0.vars.equip_list[arg_116_0.vars.selected_index].buy_time = os.time()
	
	local var_116_0 = 0
	
	for iter_116_0, iter_116_1 in pairs(arg_116_0.vars.equip_list) do
		if to_n(iter_116_1.buy_time) > 0 then
			var_116_0 = var_116_0 + 1
		end
	end
	
	if var_116_0 >= #arg_116_0.vars.equip_list then
		local var_116_1 = {
			refresh = 0,
			category = arg_116_0.vars.info.category
		}
		
		if arg_116_0.vars.info.npc then
			var_116_1.npc = arg_116_0.vars.info.npc
		end
		
		query("dupl_equip_shop", var_116_1)
	else
		arg_116_0:update()
	end
end

function ShopDuplEquipPopup.select(arg_117_0, arg_117_1)
	local var_117_0 = arg_117_0.vars.equip_list[arg_117_1] and to_n(arg_117_0.vars.equip_list[arg_117_1].buy_time) == 0
	
	if var_117_0 then
		arg_117_0.vars.selected_index = arg_117_1
	else
		arg_117_0.vars.selected_index = nil
	end
	
	for iter_117_0 = 1, 3 do
		local var_117_1 = arg_117_0.vars.wnd:getChildByName("n_weapon_" .. iter_117_0)
		
		if_set_visible(var_117_1, "select", var_117_0 and iter_117_0 == arg_117_1)
	end
end

function ShopDuplEquipPopup.reqBuy(arg_118_0, arg_118_1, arg_118_2, arg_118_3)
	arg_118_3 = arg_118_3 or arg_118_1.shop_type or "normal"
	
	local var_118_0 = {
		item = arg_118_1.id,
		shop = arg_118_3,
		type = arg_118_1.type,
		multiply = arg_118_2 or 1,
		sub_idx = arg_118_1.sub_idx
	}
	
	if arg_118_1.npc then
		var_118_0.npc = arg_118_1.npc
	end
	
	print("reqBuy item.id : ", arg_118_1.id, arg_118_1.token)
	
	if PLATFORM ~= "win32" and arg_118_1.token == "cash" then
		startIapBilling({
			shop = "normal",
			item_id = arg_118_1.id
		})
	elseif PLATFORM == "win32" and arg_118_1.token == "cash" then
		var_118_0.order_id = "test_" .. get_udid()
		
		query("buy", var_118_0)
	else
		query("buy", var_118_0)
	end
end

ShopPopupShop = {}

copy_functions(ScrollView, ShopPopupShop)
copy_functions(ShopCommon, ShopPopupShop)

function ShopPopupShop.isOpen(arg_119_0)
	return arg_119_0.vars and get_cocos_refid(arg_119_0.vars.dlg) and get_cocos_refid(arg_119_0.scrollview)
end

function ShopPopupShop.show(arg_120_0, arg_120_1, arg_120_2)
	arg_120_0.vars = {}
	arg_120_0.vars.select_group_info = arg_120_1
	arg_120_0.List = arg_120_2
	arg_120_0.vars.dlg = load_dlg("shop_group", true, "wnd")
	arg_120_0.scrollview = arg_120_0.vars.dlg:getChildByName("scrollview")
	
	arg_120_0:initScrollView(arg_120_0.scrollview, 810, 194)
	arg_120_0:updatePopupShopList(true)
	arg_120_0:jumpToPercent(0)
	Dialog:msgBox({
		yesno = true,
		dlg = arg_120_0.vars.dlg
	})
end

function ShopPopupShop.updatePopupShopList(arg_121_0, arg_121_1)
	if not arg_121_0.vars or not get_cocos_refid(arg_121_0.vars.dlg) then
		return 
	end
	
	arg_121_0.vars.DB = {}
	arg_121_0.vars.tokens = {}
	
	local var_121_0 = os.time()
	
	for iter_121_0, iter_121_1 in pairs(arg_121_0.List) do
		if iter_121_1.token then
			arg_121_0.vars.tokens[iter_121_1.token] = (arg_121_0.vars.tokens[iter_121_1.token] or 0) + 1
		end
		
		if iter_121_1.token2 then
			arg_121_0.vars.tokens[iter_121_1.token2] = (arg_121_0.vars.tokens[iter_121_1.token2] or 0) + 1
		end
		
		local var_121_1, var_121_2, var_121_3 = arg_121_0:GetRestCount(iter_121_1, var_121_0)
		
		if var_121_3 == "only_once" and var_121_2 and to_n(var_121_1) < 1 then
			iter_121_1.sold_out = true
			
			if iter_121_1.sort < 100000 then
				iter_121_1.sort = iter_121_1.sort + 100000
			end
		end
		
		arg_121_0.vars.DB[iter_121_1.id] = iter_121_1
	end
	
	table.sort(arg_121_0.List, function(arg_122_0, arg_122_1)
		return tonumber(arg_122_0.sort) < tonumber(arg_122_1.sort)
	end)
	
	if arg_121_1 then
		arg_121_0:createScrollViewItems(arg_121_0.List)
	end
	
	arg_121_0:updateTimeLimitedItems(os.time())
	
	local var_121_4 = 0
	local var_121_5 = arg_121_0.vars.dlg:getChildByName("n_window"):getChildByName("n_tokens")
	
	for iter_121_2, iter_121_3 in pairs(arg_121_0.vars.tokens) do
		var_121_4 = var_121_4 + 1
		
		if var_121_4 > 3 then
			break
		end
		
		local var_121_6 = var_121_5:getChildByName("txt_value" .. var_121_4)
		
		var_121_6:setVisible(true)
		var_121_6:setString(comma_value(Account:getCurrency(iter_121_2)))
		
		local var_121_7 = var_121_6:getChildByName("n_token" .. var_121_4)
		
		UIUtil:getRewardIcon(nil, iter_121_2, {
			no_frame = true,
			scale = 1,
			parent = var_121_7
		})
	end
	
	for iter_121_4 = var_121_4 + 1, 3 do
		if_set_visible(var_121_5, "txt_value" .. iter_121_4, false)
	end
end

function ShopPopupShop.getScrollViewItem(arg_123_0, arg_123_1)
	arg_123_1.is_limit_button = arg_123_0.vars.DB and arg_123_0.vars.DB[arg_123_1.id] and arg_123_0.vars.DB[arg_123_1.id].limit_count
	
	local var_123_0 = arg_123_0:makeShopItem2(arg_123_1, "wnd/shop_card_group.csb")
	
	var_123_0.guide_tag = arg_123_1.id
	
	return var_123_0
end

function ShopPopupShop.onSelectScrollViewItem(arg_124_0, arg_124_1, arg_124_2)
end

function ShopPopupShop.reqBuy(arg_125_0, arg_125_1, arg_125_2, arg_125_3)
	arg_125_3 = arg_125_3 or "normal"
	
	print("reqBuy item.id : ", arg_125_1.id, arg_125_1.token)
	
	if PLATFORM ~= "win32" and arg_125_1.token == "cash" then
		startIapBilling({
			shop = "normal",
			item_id = arg_125_1.id
		})
	elseif PLATFORM == "win32" and arg_125_1.token == "cash" then
		query("buy", {
			item = arg_125_1.id,
			shop = arg_125_3,
			order_id = "test_" .. get_udid(),
			type = arg_125_1.type,
			multiply = arg_125_2 or 1
		})
	else
		query("buy", {
			item = arg_125_1.id,
			shop = arg_125_3,
			type = arg_125_1.type,
			multiply = arg_125_2 or 1
		})
	end
end

function MsgHandler.randombox_rate_info(arg_126_0)
	ShopRandomboxRate:show(arg_126_0)
end

ShopRandomboxRate = {}

function ShopRandomboxRate.rateInfoItem(arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4)
	local var_127_0 = 0
	
	local function var_127_1(arg_128_0)
		if string.starts(arg_128_0, "c") then
			return T(DB("character", arg_128_0, "name"))
		elseif string.starts(arg_128_0, "e") then
			return T(DB("equip_item", arg_128_0, "name"))
		elseif string.starts(arg_128_0, "to_") then
			return T(DB("item_token", arg_128_0, "name"))
		elseif string.starts(arg_128_0, "sp_") then
			return T(DB("item_special", arg_128_0, "name"))
		elseif string.starts(arg_128_0, "ma_") then
			return T(DB("item_material", arg_128_0, "name"))
		end
	end
	
	for iter_127_0, iter_127_1 in pairs(arg_127_2) do
		var_127_0 = var_127_0 + 1
		
		local var_127_2 = load_control("wnd/gacha_info_item_bar.csb")
		
		if_set_visible(var_127_2, "n_grade", false)
		if_set_visible(var_127_2, "n_item", true)
		
		local var_127_3 = var_127_1(iter_127_1.item_id) or ""
		
		if iter_127_1.minmax and to_n(iter_127_1.minmax[2]) > 0 then
			local var_127_4 = tostring(iter_127_1.minmax[2])
			
			if to_n(iter_127_1.minmax[1]) ~= to_n(iter_127_1.minmax[2]) then
				var_127_4 = tostring(iter_127_1.minmax[1]) .. "~"
				
				tostring(iter_127_1.minmax[2])
			end
			
			if_set(var_127_2, "txt_item_name", T("txt_package_rate_detail", {
				item_id = var_127_3,
				value = var_127_4
			}))
		else
			if_set(var_127_2, "txt_item_name", var_127_3)
		end
		
		local var_127_5 = "-"
		
		if iter_127_1.ratio then
			var_127_5 = to_n(iter_127_1.ratio) * 100
		end
		
		if_set(var_127_2, "txt_item_ratio", var_127_5 .. "%")
		var_127_2:setPosition(arg_127_4, arg_127_3 - 25 * var_127_0)
		arg_127_1:addChild(var_127_2)
	end
	
	if var_127_0 < 25 then
		var_127_0 = 25
	end
	
	return 25 * var_127_0
end

function ShopRandomboxRate.show(arg_129_0, arg_129_1)
	arg_129_0.vars = arg_129_0.vars or {}
	arg_129_0.vars.isp = arg_129_1.item
	arg_129_0.vars.isp_name, arg_129_0.vars.isp_value = DB("item_special", arg_129_0.vars.isp, {
		"name",
		"value"
	})
	
	if not arg_129_0.vars.isp_name then
		return 
	end
	
	if not arg_129_1 or not arg_129_1.view_list then
		return 
	end
	
	arg_129_0.vars.view_list = arg_129_1.view_list
	arg_129_0.vars.wnd_rate_info = load_dlg("gacha_info_special", true, "wnd")
	
	if_set(arg_129_0.vars.wnd_rate_info, "txt_title", T("txt_package_rate_info", {
		item_name = T(arg_129_0.vars.isp_name)
	}))
	
	local var_129_0 = arg_129_0.vars.wnd_rate_info:getChildByName("scrollview")
	
	var_129_0:setContentSize(350, 565)
	var_129_0:setInnerContainerSize({
		width = 350,
		height = 300
	})
	
	local var_129_1 = var_129_0:getInnerContainerSize()
	local var_129_2 = table.count(arg_129_0.vars.view_list)
	
	if var_129_2 < 25 then
		var_129_2 = 25
	end
	
	local var_129_3 = 25 * var_129_2 + 110
	
	arg_129_0:rateInfoItem(var_129_0, arg_129_0.vars.view_list, var_129_3, -15)
	var_129_0:setInnerContainerSize({
		width = var_129_1.width,
		height = var_129_3
	})
	
	if arg_129_0.vars.wnd_rate_info then
		Dialog:msgBox(nil, {
			dlg = arg_129_0.vars.wnd_rate_info
		})
		SoundEngine:play("event:/ui/popup/tap")
	end
end
