SubstoryBurningShop = {}

function MsgHandler.substory_burning_shop_get_random_equip(arg_1_0)
	if arg_1_0 then
		if arg_1_0.dec_result then
			Account:addReward(arg_1_0.dec_result)
		end
		
		local var_1_0
		
		if arg_1_0.equip then
			var_1_0 = Account:addEquip(arg_1_0.equip)
			
			local var_1_1 = DB("equip_item", arg_1_0.equip.code, "type")
			
			ConditionContentsManager:dispatch("equip.craft", {
				equiptype = var_1_1,
				code = arg_1_0.equip.code
			})
		end
		
		if arg_1_0.items then
			Account:addReward(arg_1_0.items)
		end
		
		if arg_1_0.substory_burning_infos then
			Account:setSubStoryBurning(arg_1_0.substory_burning_infos)
		end
		
		SubstoryBurningShop:resEquip(arg_1_0, var_1_0)
	end
end

function MsgHandler.substory_burning_shop_get_random_item(arg_2_0)
	if arg_2_0.dec_result then
		Account:addReward(arg_2_0.dec_result)
	end
	
	local var_2_0
	
	if arg_2_0.rewards then
		local var_2_1 = false
		
		if arg_2_0.rewards.new_items and arg_2_0.rewards.new_items[1] then
			local var_2_2 = true
		end
		
		if arg_2_0.rewards.currency_time then
			for iter_2_0, iter_2_1 in ipairs(arg_2_0.rewards.currency_time) do
				if Account:isCurrencyType(iter_2_0) then
					Account:setCurrencyTime(iter_2_0, iter_2_1)
				end
			end
			
			local var_2_3 = true
		end
		
		var_2_0 = Account:addReward(arg_2_0.rewards)
	end
	
	if arg_2_0.substory_burning_infos then
		Account:setSubStoryBurning(arg_2_0.substory_burning_infos)
	end
	
	SubstoryBurningShop:resGachaItem(arg_2_0, var_2_0)
end

function MsgHandler.substory_burning_shop_get_illust_item(arg_3_0)
	if arg_3_0.dec_result then
		Account:addReward(arg_3_0.dec_result)
	end
	
	local var_3_0
	
	if arg_3_0.rewards then
		var_3_0 = Account:addReward(arg_3_0.rewards)
	end
	
	if arg_3_0.substory_burning_infos then
		Account:setSubStoryBurning(arg_3_0.substory_burning_infos)
	end
	
	SubstoryBurningShop:resIllustItem(arg_3_0, var_3_0)
end

function HANDLER.dungeon_paradise_mileage(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_exchange" then
		SubstoryBurningShop:reqTotal(arg_4_0.is_mileage, arg_4_0.is_illust)
	elseif arg_4_1 == "btn_exchange_info" then
		SubstoryBurningShopInfoPopUp:open(arg_4_0.is_mileage)
	elseif arg_4_1 == "btn_block" then
		SubStoryLobbyUIBurning:touchBalloon()
	end
end

function HANDLER.dungeon_story_piece_reward_info(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		SubstoryBurningShopInfoPopUp:close()
	end
end

function HANDLER.dungeon_paradise_mileage_info(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" then
		SubstoryBurningShopInfoPopUp:close()
	end
end

function SubstoryBurningShop.show(arg_7_0, arg_7_1)
	if arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	arg_7_1 = arg_7_1 or {}
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg("dungeon_paradise_mileage", true, "wnd")
	
	;(arg_7_1.parent or SceneManager:getRunningNativeScene()):addChild(arg_7_0.vars.wnd)
	arg_7_0.vars.wnd:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(300)), arg_7_0.vars.wnd, "block")
	
	arg_7_0.vars.id = arg_7_1.id
	arg_7_0.vars.shop_equip_id = arg_7_1.shop_equip_id
	
	local var_7_0 = SubStoryLobbyUIBurning:getInfo() or {}
	local var_7_1 = SubStoryUtil:getTopbarCurrencies(var_7_0, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:createFromPopup(T("burn_shop_title"), arg_7_0.vars.wnd, function()
		arg_7_0:leave()
	end, var_7_1, "infosubs_1")
	arg_7_0:updateData()
	arg_7_0:updateUI()
end

function SubstoryBurningShop.moveStoryIdx(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) or not arg_9_1 or not arg_9_2 then
		return 
	end
	
	arg_9_0.vars.id = arg_9_1
	arg_9_0.vars.shop_equip_id = arg_9_2
	
	arg_9_0:updateData()
	UIAction:Add(SEQ(FADE_OUT(400), CALL(function()
		arg_9_0:updateUI()
	end), FADE_IN(400)), arg_9_0.vars.wnd, "block")
end

function SubstoryBurningShop.updateData(arg_11_0)
	arg_11_0.vars.shop_data = {}
	arg_11_0.vars.shop_equip_data = {}
	arg_11_0.vars.is_sold_out_item = true
	
	local var_11_0, var_11_1, var_11_2, var_11_3, var_11_4, var_11_5, var_11_6, var_11_7, var_11_8, var_11_9, var_11_10 = DB("substory_burning_main", arg_11_0.vars.id, {
		"id",
		"shop_gift_token",
		"shop_gift_value",
		"shop_gift_ticket",
		"shop_illust",
		"shop_illust_token",
		"shop_illust_value",
		"balloon_illust",
		"shop_equip_token",
		"shop_equip_value",
		"shop_id"
	})
	
	if not var_11_0 or not var_11_10 then
		return 
	end
	
	arg_11_0.vars.shop_id = var_11_10
	arg_11_0.vars.shop_gift_token = var_11_1
	arg_11_0.vars.shop_gift_value = var_11_2
	arg_11_0.vars.shop_gift_ticket = var_11_3
	arg_11_0.vars.shop_equip_token = var_11_8
	arg_11_0.vars.shop_equip_value = var_11_9
	arg_11_0.vars.shop_illust = var_11_4
	arg_11_0.vars.shop_illust_token = var_11_5
	arg_11_0.vars.shop_illust_value = var_11_6
	arg_11_0.vars.balloon_illust = var_11_7
	arg_11_0.vars.is_illust_sold_out = Account:getItemCount(arg_11_0.vars.shop_illust) > 0
	
	local var_11_11 = string.sub(arg_11_0.vars.shop_id, -1, -1)
	
	for iter_11_0 = 1, 99999 do
		local var_11_12 = arg_11_0.vars.shop_id .. "_" .. iter_11_0
		local var_11_13 = DBT("substory_burning_shop", var_11_12, {
			"id",
			"reward_id",
			"rate",
			"balloon_check",
			"balloon_end"
		})
		
		if not var_11_13.id then
			break
		end
		
		var_11_13.is_solded = Account:isSubstoryBurningIsSoldOutItem(tonumber(var_11_11), iter_11_0)
		
		if not var_11_13.is_solded then
			arg_11_0.vars.is_sold_out_item = false
		end
		
		arg_11_0.vars.shop_data[var_11_13.id] = var_11_13
	end
	
	local var_11_14 = DBT("substory_burning_equip", arg_11_0.vars.shop_equip_id, {
		"id",
		"set_1",
		"set_2",
		"set_3",
		"set_4",
		"equip_list_1",
		"equip_list_2",
		"equip_list_3",
		"equip_list_4"
	})
	
	if not var_11_14 or not var_11_14.id then
		return 
	end
	
	arg_11_0.vars.shop_equip_data = var_11_14
end

function SubstoryBurningShop.updateUI(arg_12_0)
	arg_12_0:updateGachaInfoUI()
	arg_12_0:updateEquipInfoUI()
	arg_12_0:updateIllustInfoUI()
end

function SubstoryBurningShop.updateGachaInfoUI(arg_13_0)
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_mileage_01")
	
	if get_cocos_refid(var_13_0) then
		if_set_visible(var_13_0, "n_not_exchange", arg_13_0.vars.is_sold_out_item)
		if_set_visible(var_13_0, "n_exchange_info", not arg_13_0.vars.is_sold_out_item)
		
		var_13_0:getChildByName("btn_exchange_info").is_mileage = true
		var_13_0:getChildByName("btn_exchange").is_mileage = true
		
		if not arg_13_0.vars.is_sold_out_item then
			if_set_sprite(var_13_0, "Sprite_41", "item/" .. arg_13_0.vars.shop_gift_token .. ".png")
			if_set(var_13_0, "label_0", arg_13_0.vars.shop_gift_value)
			
			local var_13_1 = Account:getItemCount(arg_13_0.vars.shop_gift_ticket)
			
			if_set(var_13_0, "t_exchange_number", T("bshop_ticket_count", {
				count = var_13_1
			}))
		end
	end
end

function SubstoryBurningShop.updateEquipInfoUI(arg_14_0)
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("n_mileage_02")
	local var_14_1 = arg_14_0.vars.wnd:getChildByName("n_set_icons")
	local var_14_2 = arg_14_0.vars.wnd:getChildByName("n_set_icons_move")
	
	if not var_14_1.origin_x then
		var_14_1.origin_x = var_14_1:getPositionX()
		var_14_1.origin_y = var_14_1:getPositionY()
	end
	
	if get_cocos_refid(var_14_0) then
		var_14_0:getChildByName("btn_exchange").is_equip = true
		var_14_0:getChildByName("btn_exchange_info").is_equip = true
		
		local var_14_3 = string.sub(arg_14_0.vars.shop_id, -1, -1)
		local var_14_4 = Account:getSubstoryBurningEquipChangeCount(var_14_3)
		
		if_set(var_14_0, "t_exchange_number", T("bshop_equip_count", {
			count = var_14_4
		}))
		if_set_sprite(var_14_0, "Sprite_41", "item/" .. arg_14_0.vars.shop_equip_token .. ".png")
		if_set(var_14_0, "label_0", arg_14_0.vars.shop_equip_value)
		
		local var_14_5 = 0
		
		for iter_14_0 = 1, 4 do
			local var_14_6 = arg_14_0.vars.shop_equip_data["set_" .. iter_14_0]
			
			if var_14_6 then
				if_set_visible(var_14_0, "set_icon" .. iter_14_0, true)
				if_set_sprite(var_14_0, "set_icon" .. iter_14_0, "item/icon_" .. var_14_6 .. ".png")
				
				var_14_5 = var_14_5 + 1
			else
				if_set_visible(var_14_0, "set_icon" .. iter_14_0, false)
			end
		end
		
		if var_14_5 == 3 then
			var_14_1:setPosition(var_14_2:getPosition())
		else
			var_14_1:setPosition(var_14_1.origin_x, var_14_1.origin_y)
		end
	end
end

function SubstoryBurningShop.updateIllustInfoUI(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_mileage_03")
	
	if_set_visible(var_15_0, "n_not_exchange", arg_15_0.vars.is_illust_sold_out)
	if_set_visible(var_15_0, "btn_exchange", not arg_15_0.vars.is_illust_sold_out)
	if_set_visible(var_15_0, "n_illust", not arg_15_0.vars.is_illust_sold_out)
	
	if arg_15_0.vars.is_illust_sold_out then
	else
		if_set_sprite(var_15_0, "Sprite_41", "item/" .. arg_15_0.vars.shop_illust_token .. ".png")
		if_set(var_15_0, "label_0", arg_15_0.vars.shop_illust_value)
		UIUtil:getRewardIcon(nil, arg_15_0.vars.shop_illust, {
			no_bg = true,
			scale = 0.8,
			parent = var_15_0:getChildByName("n_illust")
		})
		
		local var_15_1 = DB("item_material", arg_15_0.vars.shop_illust, {
			"name"
		})
		
		if var_15_1 then
			if_set(var_15_0, "t_exchange", T(var_15_1))
		end
	end
	
	var_15_0:getChildByName("btn_exchange").is_illust = true
end

function SubstoryBurningShop.reqTotal(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_1 then
		if Account:getItemCount(arg_16_0.vars.shop_gift_token) < tonumber(arg_16_0.vars.shop_gift_value) then
			balloon_message_with_sound("need_token")
			
			return 
		end
		
		if Account:getItemCount(arg_16_0.vars.shop_gift_ticket) < 1 then
			balloon_message_with_sound("need_gift_ticket")
			
			return 
		end
		
		if arg_16_0.vars.is_sold_out_item then
			return 
		end
		
		arg_16_0:reqGachaItem()
	elseif arg_16_2 then
		if Account:getItemCount(arg_16_0.vars.shop_illust_token) < tonumber(arg_16_0.vars.shop_illust_value) then
			balloon_message_with_sound("need_token")
			
			return 
		end
		
		if arg_16_0.vars.is_illust_sold_out then
			return 
		end
		
		arg_16_0:reqIllustItem()
	else
		if Account:getItemCount(arg_16_0.vars.shop_equip_token) < tonumber(arg_16_0.vars.shop_equip_value) then
			balloon_message_with_sound("need_token")
			
			return 
		end
		
		local var_16_0 = {}
		local var_16_1 = {
			token = arg_16_0.vars.shop_equip_token,
			price = arg_16_0.vars.shop_equip_value
		}
		
		for iter_16_0 = 1, 4 do
			local var_16_2 = arg_16_0.vars.shop_equip_data["set_" .. iter_16_0]
			
			if var_16_2 then
				table.insert(var_16_0, var_16_2)
			end
		end
		
		local function var_16_3(arg_17_0)
			SubstoryBurningShop:reqEquip(arg_17_0)
		end
		
		CraftEpicPopup:openEpicPopup({
			is_burning = true,
			item = var_16_1,
			set_infos = var_16_0,
			playCraftEpicFunc = var_16_3
		})
	end
end

function SubstoryBurningShop.reqEquip(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	local var_18_0 = SubstoryManager:getInfoID()
	
	if not arg_18_1 or not var_18_0 then
		return 
	end
	
	query("substory_burning_shop_get_random_equip", {
		shop_id = arg_18_0.vars.shop_id,
		burning_id = arg_18_0.vars.id,
		substory_id = var_18_0,
		fixed_set_idx = arg_18_1,
		ignore_schedule = DEBUG.MAP_DEBUG
	})
end

function SubstoryBurningShop.resEquip(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_1 or not arg_19_2 or not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	arg_19_0:updateEquipInfoUI()
	
	local var_19_0 = arg_19_1.craft_count or 10
	local var_19_1, var_19_2 = DB("substory_burning_main", arg_19_0.vars.id, {
		"balloon_equip",
		"balloon_equip_count"
	})
	
	if var_19_0 % tonumber(var_19_2) == 0 then
		SubStoryLobbyUIBurning:shopBuyBalloon(var_19_1)
	end
	
	TopBarNew:topbarUpdate(true)
	
	arg_19_0.vars.made_equip = arg_19_2
	arg_19_0.vars.modal_dlg = load_dlg("equip_craft_result", true, "wnd", function()
		SubstoryBurningShop:closeResultDlg()
	end)
	arg_19_0.vars.sub_wnd = load_dlg("item_detail_sub", true, "wnd")
	
	SceneManager:getRunningNativeScene():addChild(arg_19_0.vars.modal_dlg)
	UIUtil:setUpEquipCraftResultDlg(arg_19_0.vars.modal_dlg, arg_19_0.vars.sub_wnd, arg_19_2)
	ItemTooltip:updateItemFrame(arg_19_0.vars.modal_dlg, arg_19_2)
	UIUtil:playBurningEquipCraftEffect(arg_19_0.vars.modal_dlg, arg_19_0.vars.sub_wnd, function()
		UIUtil:playResultStatEffect(arg_19_0.vars.sub_wnd)
	end, arg_19_0)
	if_set_visible(arg_19_0.vars.modal_dlg, "btn_extract", Account:isUnlockExtract())
	
	if not Account:isUnlockExtract() then
		local var_19_3 = arg_19_0.vars.modal_dlg:getChildByName("n_btn")
		
		if not var_19_3.originPosY then
			var_19_3.originPosY = var_19_3:getPositionY()
		end
		
		var_19_3:setPositionY(var_19_3.originPosY - 57)
	else
		if_set_opacity(arg_19_0.vars.modal_dlg, "btn_extract", arg_19_2:isExtractable() and 255 or 76.5)
	end
	
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(SubstoryBurningShop.updateEquipLock, arg_19_0), "substory_burning.equip.result.popup")
	arg_19_0:updateData()
	arg_19_0:updateUI()
end

function SubstoryBurningShop.dlgHandler(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_2 == "btn_bg" then
		SubstoryBurningShop:closeResultDlg()
	elseif arg_22_2 == "btn_lock" or arg_22_2 == "btn_lock_done" then
		SubstoryBurningShop:toggleLockResultItem(arg_22_2)
	elseif arg_22_2 == "btn_sell" then
		SubstoryBurningShop:sellResultItem()
	elseif arg_22_2 == "btn_extract" then
		SubstoryBurningShop:extractResultItem()
	end
end

function SubstoryBurningShop.sellResultItem(arg_23_0)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.modal_dlg) or not arg_23_0.vars.made_equip then
		return 
	end
	
	if arg_23_0.vars.made_equip.lock then
		balloon_message_with_sound("equip_sell_locked")
		
		return 
	end
	
	local var_23_0 = calcEquipSellPrice(arg_23_0.vars.made_equip)
	local var_23_1 = var_23_0 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_23_0)
	local var_23_2 = {}
	
	table.push(var_23_2, arg_23_0.vars.made_equip.id)
	GlobalGetSellDialog(var_23_1, nil, var_23_2, "burningEquipExtract")
end

function SubstoryBurningShop.extractResultItem(arg_24_0)
	if not arg_24_0.vars.modal_dlg or not get_cocos_refid(arg_24_0.vars.modal_dlg) or not arg_24_0.vars.made_equip then
		return 
	end
	
	if arg_24_0.vars.made_equip.lock then
		balloon_message_with_sound("equip_extract_locked")
		
		return 
	end
	
	if not arg_24_0.vars.made_equip:isExtractable() then
		balloon_message_with_sound("msg_extraction_level_error")
		
		return 
	end
	
	Inventory:extractUtil({
		arg_24_0.vars.made_equip
	}, "burningEquipExtract")
end

function SubstoryBurningShop.toggleLockResultItem(arg_25_0, arg_25_1)
	if not arg_25_0.vars or not arg_25_0.vars.made_equip then
		return 
	end
	
	if arg_25_1 == "btn_lock" then
		query("lock_equip", {
			equip = arg_25_0.vars.made_equip.id
		})
	elseif arg_25_1 == "btn_lock_done" then
		query("unlock_equip", {
			equip = arg_25_0.vars.made_equip.id
		})
	end
end

function SubstoryBurningShop.isActiveDlg(arg_26_0)
	return arg_26_0.vars and get_cocos_refid(arg_26_0.vars.modal_dlg)
end

function SubstoryBurningShop.updateEquipLock(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not arg_27_0.vars.modal_dlg or not get_cocos_refid(arg_27_0.vars.modal_dlg) or not arg_27_0.vars.made_equip then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.modal_dlg
	
	if_set_visible(var_27_0, "btn_lock", not arg_27_1)
	if_set_visible(var_27_0, "btn_lock_done", arg_27_1)
	if_set_visible(var_27_0, "locked", arg_27_1)
end

function SubstoryBurningShop.closeResultDlg(arg_28_0)
	BackButtonManager:pop("equip_craft_result")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_28_0.vars.modal_dlg, "block")
	
	arg_28_0.vars.modal_dlg = nil
	arg_28_0.vars.made_equip = nil
end

function SubstoryBurningShop.reqGachaItem(arg_29_0)
	if arg_29_0.vars.is_sold_out_item then
		return 
	end
	
	local var_29_0 = SubstoryManager:getInfoID()
	
	query("substory_burning_shop_get_random_item", {
		shop_id = arg_29_0.vars.shop_id,
		burning_id = arg_29_0.vars.id,
		substory_id = var_29_0,
		ignore_schedule = DEBUG.MAP_DEBUG
	})
end

function SubstoryBurningShop.resIllustItem(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_1 then
		return 
	end
	
	arg_30_0:updateData()
	arg_30_0:updateUI()
	SubStoryLobbyUIBurning:shopBuyBalloon(arg_30_0.vars.balloon_illust)
	
	local function var_30_0(arg_31_0)
		if arg_31_0 and arg_31_0.rewards then
			local var_31_0 = {}
			
			for iter_31_0, iter_31_1 in pairs(arg_31_0.rewards) do
				if not iter_31_1.is_randombox then
					table.insert(var_31_0, iter_31_1)
				end
			end
			
			Dialog:msgScrollRewards(T("burn_illust_popup_desc"), {
				title = T("burn_illust_popup_title"),
				rewards = var_31_0
			})
		end
	end
	
	EffectManager:Play({
		z = 99999,
		fn = "eff_burning_shop2.cfx",
		layer = SceneManager:getRunningNativeScene(),
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	
	if arg_30_2 then
		UIAction:Add(SEQ(DELAY(2000), CALL(function()
			var_30_0(arg_30_2)
		end)), arg_30_0.vars.wnd, "block")
	end
end

function SubstoryBurningShop.reqIllustItem(arg_33_0)
	if arg_33_0.vars.is_illust_sold_out then
		return 
	end
	
	local var_33_0 = SubstoryManager:getInfoID()
	
	query("substory_burning_shop_get_illust_item", {
		shop_id = arg_33_0.vars.shop_id,
		burning_id = arg_33_0.vars.id,
		substory_id = var_33_0
	})
end

function SubstoryBurningShop.resGachaItem(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_1 then
		return 
	end
	
	arg_34_0:updateData()
	arg_34_0:updateUI()
	
	if arg_34_1.item_id then
		local var_34_0 = string.sub(arg_34_0.vars.shop_id, -1, -1)
		local var_34_1, var_34_2, var_34_3 = DB("substory_burning_shop", arg_34_1.item_id, {
			"reward_eff",
			"balloon_check",
			"balloon_end"
		})
		
		if arg_34_0.vars.is_sold_out_item then
			SubStoryLobbyUIBurning:shopBuyBalloon(var_34_3)
		else
			SubStoryLobbyUIBurning:shopBuyBalloon(var_34_2)
		end
		
		EffectManager:Play({
			z = 99999,
			fn = var_34_1,
			layer = SceneManager:getRunningNativeScene(),
			x = DESIGN_WIDTH / 2,
			y = DESIGN_HEIGHT / 2
		})
	end
	
	local function var_34_4(arg_35_0)
		if arg_35_0 and arg_35_0.rewards then
			local var_35_0 = {}
			
			for iter_35_0, iter_35_1 in pairs(arg_35_0.rewards) do
				if not iter_35_1.is_randombox then
					table.insert(var_35_0, iter_35_1)
				end
			end
			
			Dialog:msgScrollRewards(T("burn_shop_popup_desc"), {
				title = T("burn_shop_popup_title"),
				rewards = var_35_0
			})
		end
	end
	
	if arg_34_2 then
		UIAction:Add(SEQ(DELAY(2000), CALL(function()
			var_34_4(arg_34_2)
		end)), arg_34_0.vars.wnd, "block")
	end
end

function SubstoryBurningShop.getShopID(arg_37_0)
	return arg_37_0.vars.shop_id
end

function SubstoryBurningShop.leave(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("dungeon_paradise_mileage")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE(), CALL(function()
		arg_38_0.vars = nil
	end)), arg_38_0.vars.wnd, "block")
	SubStoryLobbyUIBurning:setVisibleSpecificUI(true)
	SubStoryLobbyUIBurning:updateButtons()
end

SubstoryBurningShopInfoPopUp = {}

function SubstoryBurningShopInfoPopUp.open(arg_40_0, arg_40_1)
	if arg_40_0.vars and get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	opts = opts or {}
	
	local var_40_0 = "dungeon_story_piece_reward_info"
	
	if not arg_40_1 then
		var_40_0 = "dungeon_paradise_mileage_info"
	end
	
	arg_40_0.vars = {}
	arg_40_0.vars.id = SubstoryBurningShop:getShopID()
	arg_40_0.vars.shop_idx = string.sub(arg_40_0.vars.id, -1, -1)
	arg_40_0.vars.wnd = load_dlg(var_40_0, true, "wnd")
	
	;(opts.parent or SceneManager:getRunningNativeScene()):addChild(arg_40_0.vars.wnd)
	BackButtonManager:push({
		check_id = "SubstoryBurningShopInfoPopUp",
		back_func = function()
			arg_40_0:close()
		end,
		dlg = arg_40_0.vars.wnd
	})
	
	if arg_40_1 then
		local var_40_1 = arg_40_0.vars.wnd:getChildByName("listview")
		
		arg_40_0.vars.listview = ItemListView_v2:bindControl(var_40_1)
		
		local var_40_2 = load_control("wnd/dungeon_story_piece_reward_item.csb")
		
		if var_40_1.STRETCH_INFO then
			local var_40_3 = var_40_1:getContentSize()
			
			resetControlPosAndSize(var_40_2, var_40_3.width, var_40_1.STRETCH_INFO.width_prev)
		end
		
		local var_40_4 = var_40_2:getChildByName("t_available")
		local var_40_5 = var_40_2:getChildByName("t_count")
		
		if var_40_4 and var_40_5 and var_40_4:getStringNumLines() >= 2 then
			var_40_5:setPositionY(var_40_5:getPositionY() - 12)
		end
		
		local var_40_6 = {
			onUpdate = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				SubstoryBurningShopInfoPopUp:updateItem(arg_42_1, arg_42_3, arg_42_2)
				
				return arg_42_3.reward_id
			end
		}
		
		arg_40_0.vars.listview:setRenderer(var_40_2, var_40_6)
		arg_40_0:updateReward()
	end
	
	if false then
	end
end

function SubstoryBurningShopInfoPopUp.updateReward(arg_43_0)
	arg_43_0.vars.reward_data = {}
	
	for iter_43_0 = 1, 99999 do
		local var_43_0 = arg_43_0.vars.id .. "_" .. iter_43_0
		local var_43_1, var_43_2, var_43_3, var_43_4 = DB("substory_burning_shop", var_43_0, {
			"id",
			"reward_id",
			"reward_value",
			"rate"
		})
		
		if not var_43_1 then
			break
		end
		
		local var_43_5 = Account:isSubstoryBurningIsSoldOutItem(tonumber(arg_43_0.vars.shop_idx), iter_43_0) or 0
		local var_43_6 = 1
		local var_43_7 = false
		
		for iter_43_1, iter_43_2 in pairs(arg_43_0.vars.reward_data) do
			if iter_43_2.reward_id == var_43_2 and iter_43_2.reward_value == var_43_3 then
				var_43_7 = true
				iter_43_2.max_value = iter_43_2.max_value + 1
				iter_43_2.cur_value = iter_43_2.cur_value + var_43_5
			end
		end
		
		if not var_43_7 then
			table.insert(arg_43_0.vars.reward_data, {
				id = var_43_1,
				reward_id = var_43_2,
				reward_value = var_43_3,
				rate = var_43_4,
				cur_value = var_43_5,
				max_value = var_43_6
			})
		end
	end
	
	arg_43_0.vars.listview:removeAllChildren()
	arg_43_0.vars.listview:setDataSource(arg_43_0.vars.reward_data)
end

function SubstoryBurningShopInfoPopUp.updateItem(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	if_set_visible(arg_44_1, "icon_check", false)
	
	if arg_44_2.cur_value == arg_44_2.max_value then
		arg_44_1:setOpacity(76.5)
	end
	
	local var_44_0 = arg_44_1:getChildByName("reward_item")
	local var_44_1 = arg_44_1:getChildByName("txt_name")
	local var_44_2 = arg_44_1:getChildByName("txt_type")
	
	UIUtil:getRewardIcon(arg_44_2.reward_value, arg_44_2.reward_id, {
		show_small_count = true,
		hero_multiply_scale = 1.12,
		artifact_multiply_scale = 0.75,
		right_hero_name = true,
		show_name = true,
		pet_multiply_scale = 1.12,
		no_resize_name = true,
		right_hero_type = true,
		show_equip_type = true,
		detail = true,
		parent = var_44_0,
		txt_type = var_44_2,
		txt_name = var_44_1
	})
	UIUserData:call(var_44_1, "MULTI_SCALE(2, 90)")
	UIUserData:call(var_44_2, "SINGLE_WSCALE(238)")
	if_set(arg_44_1, "t_count", arg_44_2.cur_value .. "/" .. arg_44_2.max_value)
end

function SubstoryBurningShopInfoPopUp.close(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("SubstoryBurningShopInfoPopUp")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE(), CALL(function()
		arg_45_0.vars = nil
	end)), arg_45_0.vars.wnd, "block")
end
