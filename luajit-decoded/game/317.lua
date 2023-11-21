function MsgHandler.gacha_temp_inventory_pull(arg_1_0)
	if arg_1_0.info.gacha_results and #arg_1_0.info.gacha_results > 0 then
		local var_1_0 = arg_1_0.info.gacha_results
		local var_1_1
		local var_1_2 = 0
		
		for iter_1_0, iter_1_1 in pairs(var_1_0) do
			if iter_1_1.gacha_type == "character" then
				local var_1_3, var_1_4 = Account:addUnit(iter_1_1.id, iter_1_1.code, iter_1_1.exp, iter_1_1.g)
				
				var_1_2 = var_1_2 + 1
				var_1_1 = "c"
			elseif iter_1_1.gacha_type == "equip" then
				local var_1_5, var_1_6 = Account:addEquip(iter_1_1)
				
				var_1_2 = var_1_2 + 1
				var_1_1 = "e"
			end
		end
		
		if var_1_2 > 0 then
			if var_1_1 == "c" then
				balloon_message_with_sound("temp_invent_pull_desc_hero2", {
					count = var_1_2
				})
			elseif var_1_1 == "e" then
				balloon_message_with_sound("temp_invent_pull_desc_artifact2", {
					count = var_1_2
				})
			end
		end
		
		if arg_1_0.update_temp_inventories then
			for iter_1_2, iter_1_3 in pairs(arg_1_0.update_temp_inventories) do
				Account:updateGachaTempInventory({
					code = iter_1_2,
					count = iter_1_3
				})
			end
		end
		
		GachaTempInventory:selectCategory(var_1_1)
		GachaUnit:updateGachaTempInventoryCount()
	else
		balloon_message_with_sound("gacha_err")
	end
end

function MsgHandler.gacha_temp_inventory_sell(arg_2_0)
	local var_2_0 = false
	
	if arg_2_0.update_temp_inventories then
		for iter_2_0, iter_2_1 in pairs(arg_2_0.update_temp_inventories) do
			Account:updateGachaTempInventory({
				code = iter_2_0,
				count = iter_2_1
			})
			
			if string.starts(iter_2_0, "c") then
				var_2_0 = true
			end
		end
	end
	
	local var_2_1 = {}
	
	if arg_2_0.currency then
		for iter_2_2, iter_2_3 in pairs(arg_2_0.currency) do
			table.push(var_2_1, {
				token = iter_2_2,
				count = to_n(iter_2_3) - Account:getPropertyCount(iter_2_2)
			})
		end
	end
	
	if arg_2_0.items then
		for iter_2_4, iter_2_5 in pairs(arg_2_0.items) do
			table.push(var_2_1, {
				token = iter_2_4,
				count = to_n(iter_2_5) - Account:getPropertyCount(iter_2_4)
			})
		end
	end
	
	if arg_2_0.currency then
		Account:updateCurrencies(arg_2_0.currency)
	end
	
	if arg_2_0.items then
		Account:updateProperties(arg_2_0.items)
	end
	
	TopBarNew:topbarUpdate(true)
	
	if var_2_0 then
		Dialog:msgRewards(T("temp_inven_popup_desc1_3"), {
			order_first_token = "to_gold",
			rewards = var_2_1,
			title = T("ui_msgbox_rewards_title")
		})
	else
		Dialog:msgRewards(T("temp_inven_popup_desc2_3"), {
			order_first_token = "to_gold",
			rewards = var_2_1,
			title = T("ui_msgbox_rewards_title")
		})
	end
	
	GachaTempInventory:selectCategory()
	GachaUnit:updateGachaTempInventoryCount()
end

GachaTempInventory = {}

copy_functions(ScrollView, GachaTempInventory)

function GachaTempInventory.showPopup(arg_3_0)
	local var_3_0 = load_dlg("gacha_inven", true, "wnd")
	
	GachaTempInventory:show(var_3_0)
	Dialog:msgBox(nil, {
		dlg = var_3_0,
		handler = function(arg_4_0, arg_4_1)
			if arg_4_1 == "btn_main_tab1" then
				GachaTempInventory:selectCategory("c")
				
				return "dont_close"
			elseif arg_4_1 == "btn_main_tab2" then
				GachaTempInventory:selectCategory("e")
				
				return "dont_close"
			elseif arg_4_1 == "btn_empty" then
				GachaTempInventory:empty()
				
				return "dont_close"
			elseif arg_4_1 == "btn_cancel2" then
				GachaTempInventory:empty()
				
				return "dont_close"
			elseif arg_4_1 == "btn_takeout" then
				GachaTempInventory:takeout()
				
				return "dont_close"
			elseif arg_4_1 == "btn_sell" then
				GachaTempInventory:sell()
				
				return "dont_close"
			elseif arg_4_1 == "btn_delete" then
				GachaTempInventory:toggleSellMode()
				GachaTempInventory:empty()
				
				return "dont_close"
			elseif arg_4_1 == "btn_delete_after" then
				GachaTempInventory:toggleSellMode()
				GachaTempInventory:empty()
				
				return "dont_close"
			elseif arg_4_1 == "btn_stack_sel" then
				GachaTempInventory:toggleStackMode()
				
				return "dont_close"
			elseif arg_4_1 == "btn_one_sel" then
				GachaTempInventory:toggleStackMode()
				
				return "dont_close"
			elseif arg_4_1 == "btn_close" then
				Analytics:closePopup()
			elseif arg_4_1 == "btn_default" then
				return 
			else
				return "dont_close"
			end
		end
	})
	Analytics:setPopup("gacha_inven")
end

function GachaTempInventory.show(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.parent = arg_5_1
	arg_5_0.vars.mode = "c"
	arg_5_0.vars.sell_mode = false
	arg_5_0.vars.stack_mode = false
	arg_5_0.vars.unit_color_table = {
		wind = 3,
		fire = 5,
		light = 2,
		dark = 1,
		ice = 4
	}
	
	local var_5_0 = arg_5_0.vars.parent:getChildByName("n_tab1")
	local var_5_1 = arg_5_0.vars.parent:getChildByName("n_tab2")
	
	if_set_visible(var_5_0, "n_selected", true)
	if_set_visible(var_5_1, "n_selected", false)
	
	local var_5_2 = arg_5_0.vars.parent:getChildByName("n_btn_sell_mode")
	
	if_set_visible(var_5_2, "btn_delete", not arg_5_0.vars.sell_mode)
	if_set_visible(var_5_2, "btn_delete_after", arg_5_0.vars.sell_mode)
	
	local var_5_3 = arg_5_0.vars.parent:getChildByName("n_basket"):getChildByName("n_sell_mode")
	
	if_set(var_5_3, "t_sell_info", T("temp_inven_desc3"))
	
	arg_5_0.vars.scrollview = arg_5_0.vars.parent:getChildByName("scrollview")
	
	arg_5_0:initScrollView(arg_5_0.vars.scrollview, 112, 138)
	GachaTempInventoryBasket:create(arg_5_0.vars.parent)
	arg_5_0:selectCategory()
end

function GachaTempInventory.isCharacterMode(arg_6_0)
	return arg_6_0.vars.mode == "c"
end

function GachaTempInventory.toggleSellMode(arg_7_0)
	arg_7_0.vars.sell_mode = not arg_7_0.vars.sell_mode
	
	local var_7_0 = arg_7_0.vars.parent:getChildByName("n_btn_sell_mode")
	
	if_set_visible(var_7_0, "btn_delete", not arg_7_0.vars.sell_mode)
	if_set_visible(var_7_0, "btn_delete_after", arg_7_0.vars.sell_mode)
	GachaTempInventoryBasket:setSellMode(arg_7_0.vars.sell_mode)
end

function GachaTempInventory.toggleStackMode(arg_8_0)
	arg_8_0.vars.stack_mode = not arg_8_0.vars.stack_mode
	
	local var_8_0 = arg_8_0.vars.parent:getChildByName("n_btn_sell_mode")
	
	if_set_visible(var_8_0, "btn_one_sel", arg_8_0.vars.stack_mode)
	if_set_visible(var_8_0, "btn_stack_sel", not arg_8_0.vars.stack_mode)
	
	if arg_8_0.vars.stack_mode then
		balloon_message_with_sound("temp_invent_noti_all")
	else
		balloon_message_with_sound("temp_invent_noti_one")
	end
	
	GachaTempInventoryBasket:setStackMode(arg_8_0.vars.stack_mode)
end

function GachaTempInventory.isOpen(arg_9_0)
	return arg_9_0.vars and get_cocos_refid(arg_9_0.vars.scrollview)
end

function GachaTempInventory.selectCategory(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.vars.parent:getChildByName("n_tab1")
	local var_10_1 = arg_10_0.vars.parent:getChildByName("n_tab2")
	
	AccountData.gacha_temp_inventory = AccountData.gacha_temp_inventory or {}
	
	local var_10_2 = 0
	local var_10_3 = 0
	
	for iter_10_0, iter_10_1 in pairs(AccountData.gacha_temp_inventory) do
		if to_n(iter_10_1) > 0 then
			if string.starts(iter_10_0, "c") then
				var_10_2 = var_10_2 + 1
			else
				var_10_3 = var_10_3 + 1
			end
		end
	end
	
	local var_10_4 = arg_10_0.vars.mode
	
	if arg_10_1 == nil then
		if var_10_2 == 0 and var_10_3 > 0 then
			arg_10_0.vars.mode = "e"
		else
			arg_10_0.vars.mode = arg_10_1 or arg_10_0.vars.mode or "c"
		end
	else
		arg_10_0.vars.mode = arg_10_1
	end
	
	local var_10_5 = arg_10_0.vars.parent:getChildByName("n_btn_sell_mode")
	local var_10_6 = arg_10_0.vars.parent:getChildByName("n_basket"):getChildByName("n_sell_mode")
	
	if arg_10_0.vars.mode == "c" then
		if_set(arg_10_0.vars.parent, "t_basket_title", T("temp_invent_desc_hero"))
		if_set_visible(var_10_0, "n_selected", true)
		if_set_visible(var_10_1, "n_selected", false)
		if_set_visible(arg_10_0.vars.parent, "n_none", var_10_2 == 0)
		if_set(var_10_5:getChildByName("btn_delete"), "label", T("temp_inven_btn_hero_sell"))
		if_set(var_10_6, "t_sell_info", T("temp_inven_desc3"))
	else
		if_set(arg_10_0.vars.parent, "t_basket_title", T("temp_invent_desc_artifact"))
		if_set_visible(var_10_0, "n_selected", false)
		if_set_visible(var_10_1, "n_selected", true)
		if_set_visible(arg_10_0.vars.parent, "n_none", var_10_3 == 0)
		if_set(var_10_5:getChildByName("btn_delete"), "label", T("ui_inventory_btn_sell"))
		if_set(var_10_6, "t_sell_info", T("temp_inven_desc4"))
	end
	
	GachaTempInventoryBasket:empty()
	arg_10_0:buildCurrentList()
	arg_10_0:updateFreeInventory()
	arg_10_0:createScrollViewItems(arg_10_0.vars.list, nil, var_10_4 == arg_10_0.vars.mode)
end

function GachaTempInventory.buildCurrentList(arg_11_0)
	arg_11_0.vars.list = {}
	AccountData.gacha_temp_inventory = AccountData.gacha_temp_inventory or {}
	
	local var_11_0 = 0
	
	for iter_11_0, iter_11_1 in pairs(AccountData.gacha_temp_inventory) do
		if to_n(iter_11_1) > 0 then
			var_11_0 = var_11_0 + 1
			
			if string.starts(iter_11_0, arg_11_0.vars.mode) then
				local var_11_1 = 0
				
				if arg_11_0.vars.mode == "c" then
					local var_11_2, var_11_3 = DB("character", iter_11_0, {
						"grade",
						"ch_attribute"
					})
					
					var_11_1 = to_n(var_11_2) * 10000 + to_n(arg_11_0.vars.unit_color_table[var_11_3]) * 1000 + var_11_0
				else
					local var_11_4 = DB("equip_item", iter_11_0, {
						"artifact_grade"
					})
					
					var_11_1 = to_n(var_11_4) * 10000 + var_11_0
				end
				
				table.insert(arg_11_0.vars.list, {
					code = iter_11_0,
					count = iter_11_1,
					grade_attr = var_11_1
				})
			end
		end
	end
	
	table.sort(arg_11_0.vars.list, function(arg_12_0, arg_12_1)
		return arg_12_0.grade_attr > arg_12_1.grade_attr
	end)
end

function GachaTempInventory.getScrollViewItem(arg_13_0, arg_13_1)
	local var_13_0 = load_control("wnd/gacha_inven_item.csb")
	local var_13_1 = var_13_0:getChildByName("btn_select")
	
	GachaUnit:setSpecial(var_13_0, arg_13_1, {
		use_grade = true,
		use_btn_select = true,
		popup_delay = 200,
		count = arg_13_1.count,
		popup_control = var_13_1
	})
	var_13_1:setName("btn_select_left")
	
	var_13_0.datasource = arg_13_1
	
	if arg_13_0.vars.sell_mode then
		local var_13_2 = math.floor(to_n(arg_13_1.grade_attr) / 10000)
		
		if_set_color(var_13_0, nil, var_13_2 >= 5 and cc.c3b(76, 76, 76) or cc.c3b(255, 255, 255))
	end
	
	return var_13_0
end

function GachaTempInventory.empty(arg_14_0)
	arg_14_0:buildCurrentList()
	arg_14_0:createScrollViewItems(arg_14_0.vars.list, nil, true)
	GachaTempInventoryBasket:empty()
	arg_14_0:updateFreeInventory()
end

function GachaTempInventory.takeout(arg_15_0)
	local var_15_0, var_15_1 = GachaTempInventoryBasket:getSelectedList()
	
	if var_15_1 < 1 then
		return 
	end
	
	local var_15_2
	
	if arg_15_0.vars.mode == "c" then
		if UIUtil:checkUnitInven() == false then
			return 
		end
		
		var_15_2 = "temp_invent_pull_desc_hero1"
	else
		if UIUtil:checkArtifactInven() == false then
			return 
		end
		
		var_15_2 = "temp_invent_pull_desc_artifact1"
	end
	
	Dialog:msgBox(T(var_15_2, {
		count = GachaTempInventoryBasket:count()
	}), {
		yesno = true,
		title = T("temp_invent_pull_title"),
		handler = function()
			query("gacha_temp_inventory_pull", {
				pull_list = json.encode(var_15_0)
			})
		end
	})
end

function GachaTempInventory.sell(arg_17_0)
	local var_17_0, var_17_1 = GachaTempInventoryBasket:getSelectedList()
	
	if var_17_1 < 1 then
		return 
	end
	
	local var_17_2
	local var_17_3
	local var_17_4
	local var_17_5
	
	if arg_17_0.vars.mode == "c" then
		var_17_2 = "temp_inven_popup_title1"
		var_17_3 = "temp_inven_popup_desc1_1"
		var_17_5 = "temp_inven_popup_desc1_2"
	else
		var_17_2 = "temp_inven_popup_title2"
		var_17_3 = "temp_inven_popup_desc2_1"
		var_17_5 = "temp_inven_popup_desc2_2"
	end
	
	local var_17_6, var_17_7, var_17_8, var_17_9, var_17_10 = GachaTempInventoryBasket:calcSellPrices()
	local var_17_11 = load_dlg("msgbox_item_sel", true, "wnd")
	local var_17_12 = 1 + table.count(var_17_10)
	
	if var_17_9 and var_17_7 > 0 then
		var_17_12 = var_17_12 + 1
	end
	
	local var_17_13 = math.clamp(var_17_12, 1, 5)
	local var_17_14 = var_17_13 % 2 == 1
	local var_17_15 = var_17_11:getChildByName("n_item_node")
	
	if get_cocos_refid(var_17_15) then
		var_17_15:setVisible(true)
		
		local var_17_16 = var_17_15:getChildByName(var_17_14 and "n_odd" or "n_even")
		local var_17_17
		
		if get_cocos_refid(var_17_16) then
			var_17_16:setVisible(true)
			
			var_17_17 = var_17_16:getChildByName(tostring(var_17_13))
			
			if get_cocos_refid(var_17_17) then
				var_17_17:setVisible(true)
				
				for iter_17_0 = 1, var_17_13 do
					local var_17_18 = var_17_17:getChildByName("reward_item" .. tostring(iter_17_0))
					
					if iter_17_0 == 1 then
						UIUtil:getRewardIcon(var_17_6, "to_gold", {
							no_popup = true,
							parent = var_17_18
						})
					elseif iter_17_0 == 2 then
						UIUtil:getRewardIcon(var_17_7, var_17_9, {
							no_popup = true,
							parent = var_17_18
						})
					else
						local var_17_19 = 0
						
						for iter_17_1, iter_17_2 in pairs(var_17_10) do
							local var_17_20 = var_17_17:getChildByName("reward_item" .. tostring(iter_17_0 + var_17_19))
							
							UIUtil:getRewardIcon(iter_17_2, iter_17_1, {
								no_popup = true,
								parent = var_17_20
							})
							
							var_17_19 = var_17_19 + 1
						end
						
						break
					end
				end
			end
		end
	elseif var_17_9 and var_17_7 > 0 then
		UIUtil:getRewardIcon(var_17_6, "to_gold", {
			no_popup = true,
			parent = var_17_11:getChildByName("reward_item1/2")
		})
		UIUtil:getRewardIcon(var_17_7, var_17_9, {
			no_popup = true,
			parent = var_17_11:getChildByName("reward_item2/2")
		})
	else
		UIUtil:getRewardIcon(var_17_6, "to_gold", {
			no_popup = true,
			parent = var_17_11:getChildByName("reward_item1/1")
		})
	end
	
	local var_17_21
	
	if arg_17_0.vars.mode == "e" then
		var_17_21 = GachaTempInventoryBasket:gethighGradeArtiList()
	end
	
	Dialog:msgBox(T(var_17_3, {
		num = var_17_8
	}), {
		yesno = true,
		dlg = var_17_11,
		title = T(var_17_2),
		handler = function()
			Dialog:msgBox(T(var_17_5, {
				num = var_17_8
			}), {
				yesno = true,
				title = T(var_17_2),
				handler = function()
					if var_17_21 then
						local var_19_0 = Dialog:msgItems(var_17_21)
						local var_19_1 = Dialog:msgBox(T("confirm_high_grade_artifact_sell"), {
							yesno = true,
							handler = function()
								query("gacha_temp_inventory_sell", {
									sell_list = json.encode(var_17_0)
								})
							end,
							dlg = var_19_0
						})
						
						if_set(var_19_1, "txt_title", T("sell_equips_name"))
					else
						query("gacha_temp_inventory_sell", {
							sell_list = json.encode(var_17_0)
						})
					end
				end
			})
		end
	})
end

function GachaTempInventory.updateFreeInventory(arg_21_0)
	if not arg_21_0.vars.mode then
		return 
	end
	
	local var_21_0 = 0
	
	if arg_21_0.vars.mode == "c" then
		var_21_0 = math.max(Account:getRemainHeroInventoryCount() - GachaTempInventoryBasket:count(), 0)
	else
		var_21_0 = math.max(Account:getCurrentArtifactCount() - Account:getFreeArtifactCount() - GachaTempInventoryBasket:count(), 0)
	end
	
	if_set(arg_21_0.vars.parent, "t_inven_count", T("temp_inven_desc1", {
		count = var_21_0
	}))
end

function GachaTempInventory.getFreeInventory(arg_22_0)
	if not arg_22_0.vars.mode then
		return 0
	end
	
	local var_22_0 = 0
	
	if arg_22_0.vars.mode == "c" then
		var_22_0 = Account:getRemainHeroInventoryCount() - GachaTempInventoryBasket:count()
	else
		var_22_0 = Account:getCurrentArtifactCount() - Account:getFreeArtifactCount() - GachaTempInventoryBasket:count()
	end
	
	return var_22_0
end

function GachaTempInventory.isFreeInventory(arg_23_0)
	return arg_23_0:getFreeInventory() > 0
end

function GachaTempInventory.revertItem(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = {
		code = arg_24_1,
		count = arg_24_3 or 1,
		grade_attr = arg_24_2
	}
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.ScrollViewItems) do
		if iter_24_1.item.code == var_24_0.code then
			iter_24_1.item.count = iter_24_1.item.count + var_24_0.count
			
			if_set(iter_24_1.control, "txt_count", iter_24_1.item.count)
			arg_24_0:updateFreeInventory()
			
			return 
		end
	end
	
	table.push(arg_24_0.vars.list, var_24_0)
	table.sort(arg_24_0.vars.list, function(arg_25_0, arg_25_1)
		return arg_25_0.grade_attr > arg_25_1.grade_attr
	end)
	arg_24_0:createScrollViewItems(arg_24_0.vars.list, nil, true)
	arg_24_0:updateFreeInventory()
end

function GachaTempInventory.onSelectScrollViewItem(arg_26_0, arg_26_1, arg_26_2)
end

function GachaTempInventory.selectItem(arg_27_0, arg_27_1)
	if not get_cocos_refid(arg_27_1) then
		return 
	end
	
	local var_27_0 = getParentWindow(arg_27_1).datasource
	local var_27_1 = 0
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.list) do
		if iter_27_1 == var_27_0 then
			var_27_1 = iter_27_0
			
			break
		end
	end
	
	if var_27_1 > 0 and systick() - to_n(arg_27_1.touch_tick) < 180 then
		if not arg_27_0:isFreeInventory() and arg_27_0.vars.sell_mode == false then
			balloon_message_with_sound("temp_invent_err01")
			
			return 
		end
		
		if not GachaTempInventoryBasket:isFreeBasket() then
			balloon_message_with_sound("temp_invent_err02", {
				value = to_n(GAME_STATIC_VARIABLE.temp_invent_pull_limit)
			})
			
			return 
		end
		
		if math.floor(to_n(var_27_0.grade_attr) / 10000) >= 5 and arg_27_0.vars.sell_mode then
			balloon_message_with_sound("temp_inven_err03")
			
			return 
		end
		
		if arg_27_0.vars.stack_mode then
			local var_27_2 = GachaTempInventoryBasket:getFreeBasket()
			
			if not arg_27_0.vars.sell_mode then
				var_27_2 = math.min(var_27_2, arg_27_0:getFreeInventory())
			end
			
			if var_27_2 < var_27_0.count then
				var_27_0.count = var_27_0.count - var_27_2
				
				if_set(arg_27_0.ScrollViewItems[var_27_1].control, "txt_count", var_27_0.count)
				GachaTempInventoryBasket:addItem(var_27_0.code, var_27_0.grade_attr, var_27_2)
				arg_27_0:updateFreeInventory()
			else
				arg_27_0:removeWithKeepPos(var_27_1)
				table.remove(arg_27_0.vars.list, var_27_1)
				GachaTempInventoryBasket:addItem(var_27_0.code, var_27_0.grade_attr, var_27_0.count)
				arg_27_0:updateFreeInventory()
			end
		elseif var_27_0.count > 1 then
			var_27_0.count = var_27_0.count - 1
			
			if_set(arg_27_0.ScrollViewItems[var_27_1].control, "txt_count", var_27_0.count)
			GachaTempInventoryBasket:addItem(var_27_0.code, var_27_0.grade_attr)
			arg_27_0:updateFreeInventory()
		elseif var_27_0.count == 1 then
			arg_27_0:removeWithKeepPos(var_27_1)
			table.remove(arg_27_0.vars.list, var_27_1)
			GachaTempInventoryBasket:addItem(var_27_0.code, var_27_0.grade_attr)
			arg_27_0:updateFreeInventory()
		end
	end
end

GachaTempInventoryBasket = {}

copy_functions(ScrollView, GachaTempInventoryBasket)

function GachaTempInventoryBasket.create(arg_28_0, arg_28_1)
	arg_28_0.vars = {}
	arg_28_0.vars.list = {}
	arg_28_0.vars.parent_wnd = arg_28_1
	
	arg_28_0:setSellMode(false)
	
	arg_28_0.vars.scrollview = arg_28_0.vars.parent_wnd:getChildByName("scrollview_basket")
	arg_28_0.vars.origin_scrollsz = arg_28_0.vars.scrollview:getContentSize()
	
	arg_28_0:initScrollView(arg_28_0.vars.scrollview, 112, 138)
	arg_28_0:createScrollViewItems(arg_28_0.vars.list)
	arg_28_0:updateBasketCount()
end

function GachaTempInventoryBasket.setSellMode(arg_29_0, arg_29_1)
	arg_29_0.vars.sell_mode = arg_29_1
	
	if arg_29_0.vars.sell_mode then
		if_set_visible(arg_29_0.vars.parent_wnd, "n_takeout_mode", false)
		if_set_visible(arg_29_0.vars.parent_wnd, "n_sell_mode", true)
	else
		if_set_visible(arg_29_0.vars.parent_wnd, "n_takeout_mode", true)
		if_set_visible(arg_29_0.vars.parent_wnd, "n_sell_mode", false)
	end
	
	arg_29_0:updateCategoryUI()
end

function GachaTempInventoryBasket.setStackMode(arg_30_0, arg_30_1)
	arg_30_0.vars.stack_mode = arg_30_1
end

function GachaTempInventoryBasket.updateCategoryUI(arg_31_0)
	local var_31_0 = GachaTempInventory:isCharacterMode()
	
	if get_cocos_refid(arg_31_0.vars.parent_wnd) then
		local var_31_1 = arg_31_0.vars.parent_wnd:getChildByName("n_sell_mode")
		
		if get_cocos_refid(var_31_1) then
			local var_31_2 = var_31_1:getChildByName("n_cost")
			local var_31_3 = var_31_1:getChildByName("_bar")
			
			if get_cocos_refid(var_31_2) then
				if not var_31_2.origin_pos_y then
					var_31_2.origin_pos_y = var_31_2:getPositionY()
				end
				
				if var_31_0 then
					var_31_2:setPositionY(var_31_2.origin_pos_y)
				else
					var_31_2:setPositionY(var_31_2.origin_pos_y - 39)
				end
			end
			
			if get_cocos_refid(var_31_3) then
				if not var_31_3.origin_pos_y then
					var_31_3.origin_pos_y = var_31_3:getPositionY()
				end
				
				if var_31_0 then
					var_31_3:setPositionY(var_31_3.origin_pos_y)
				else
					var_31_3:setPositionY(var_31_3.origin_pos_y - 41)
				end
			end
			
			if_set_visible(var_31_1, "n_cost2", var_31_0)
		end
	end
	
	if get_cocos_refid(arg_31_0.vars.scrollview) then
		arg_31_0.vars.scrollview:setContentSize(arg_31_0.vars.origin_scrollsz.width, arg_31_0.vars.origin_scrollsz.height + (arg_31_0.vars.sell_mode and var_31_0 and -41 or 0))
	end
end

function GachaTempInventoryBasket.getSelectedList(arg_32_0)
	local var_32_0 = {}
	local var_32_1 = 0
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.list) do
		if iter_32_1.count > 0 then
			var_32_0[iter_32_1.code] = iter_32_1.count
			var_32_1 = var_32_1 + iter_32_1.count
		end
	end
	
	return var_32_0, var_32_1
end

function GachaTempInventoryBasket.addItem(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = {
		code = arg_33_1,
		count = arg_33_3 or 1,
		grade_attr = arg_33_2
	}
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.ScrollViewItems) do
		if iter_33_1.item.code == var_33_0.code then
			iter_33_1.item.count = iter_33_1.item.count + var_33_0.count
			
			if_set(iter_33_1.control, "txt_count", iter_33_1.item.count)
			arg_33_0:updateBasketCount()
			
			return 
		end
	end
	
	table.push(arg_33_0.vars.list, var_33_0)
	table.sort(arg_33_0.vars.list, function(arg_34_0, arg_34_1)
		return arg_34_0.grade_attr > arg_34_1.grade_attr
	end)
	arg_33_0:createScrollViewItems(arg_33_0.vars.list, nil, true)
	arg_33_0:updateBasketCount()
end

function GachaTempInventoryBasket.count(arg_35_0)
	local var_35_0 = 0
	
	for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.list) do
		var_35_0 = var_35_0 + iter_35_1.count
	end
	
	return var_35_0
end

function GachaTempInventoryBasket.empty(arg_36_0, arg_36_1)
	arg_36_0.vars.list = {}
	
	arg_36_0:createScrollViewItems(arg_36_0.vars.list)
	arg_36_0:updateBasketCount()
	arg_36_0:updateCategoryUI()
end

function GachaTempInventoryBasket.calcSellPrices(arg_37_0)
	local var_37_0 = 0
	local var_37_1 = 0
	local var_37_2
	local var_37_3 = 0
	local var_37_4 = 0
	local var_37_5 = {}
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.list) do
		var_37_3 = var_37_3 + iter_37_1.count
		
		if GachaTempInventory:isCharacterMode() then
			local var_37_6 = UNIT:create({
				code = iter_37_1.code
			})
			local var_37_7 = var_37_6:getClampedDevote()
			local var_37_8 = DB("character", var_37_6.inst.code, "price")
			
			var_37_0 = var_37_0 + (var_37_8 + math.floor(5 * var_37_8 * 0.2)) * (var_37_7 + 1) * iter_37_1.count
			
			if not var_37_6:isFreeSaleUnit() then
				local var_37_9 = var_37_6:getBaseGrade()
				local var_37_10, var_37_11 = DB("rune_sell", tostring(var_37_9), {
					"token",
					"reward"
				})
				
				if var_37_10 == "to_hero1" and var_37_11 > 0 then
					local var_37_12 = var_37_11 * (var_37_7 + 1)
					
					var_37_2 = "to_hero1"
					var_37_1 = var_37_1 + var_37_12 * iter_37_1.count
				end
				
				local var_37_13, var_37_14 = DB("char_promotion_sell", tostring(var_37_6:getBaseGrade()), {
					"item_id",
					"reward"
				})
				
				if var_37_13 and to_n(var_37_14) > 0 then
					var_37_5[var_37_13] = to_n(var_37_5[var_37_13]) + to_n(var_37_14) * iter_37_1.count
				end
			end
		else
			local var_37_15 = EQUIP:createByInfo({
				code = iter_37_1.code
			})
			local var_37_16 = calcEquipSellPrice(var_37_15) * iter_37_1.count
			
			var_37_0 = var_37_0 + var_37_16
			var_37_4 = var_37_4 + var_37_16
			var_37_1 = var_37_1 + calcArtifactSellPowder(var_37_15) * iter_37_1.count
			
			if var_37_1 > 0 then
				var_37_2 = "to_powder"
			end
		end
	end
	
	if var_37_4 > 0 then
		var_37_0 = var_37_0 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_37_4)
	end
	
	return var_37_0, var_37_1, var_37_3, var_37_2, var_37_5
end

function GachaTempInventoryBasket.gethighGradeArtiList(arg_38_0)
	if GachaTempInventory:isCharacterMode() then
		return 
	end
	
	local var_38_0
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.list) do
		local var_38_1 = EQUIP:createByInfo({
			code = iter_38_1.code
		})
		
		if var_38_1 and var_38_1:isArtifact() and var_38_1.grade >= 4 then
			var_38_0 = var_38_0 or {}
			
			table.insert(var_38_0, var_38_1)
		end
	end
	
	return var_38_0
end

function GachaTempInventoryBasket.updateBasketCount(arg_39_0)
	local var_39_0 = arg_39_0.vars.parent_wnd:getChildByName("n_basket")
	
	if arg_39_0.vars.sell_mode then
		local var_39_1 = var_39_0:getChildByName("n_sell_mode")
		local var_39_2, var_39_3, var_39_4, var_39_5, var_39_6 = arg_39_0:calcSellPrices()
		
		UIUtil:getRewardIcon(nil, "to_gold", {
			no_bg = true,
			parent = var_39_1:getChildByName("icon")
		})
		if_set(var_39_1, "txt_sell_price", "+" .. comma_value(var_39_2))
		
		if GachaTempInventory:isCharacterMode() then
			UIUtil:getRewardIcon(nil, "to_hero1", {
				no_bg = true,
				parent = var_39_1:getChildByName("icon2")
			})
		else
			UIUtil:getRewardIcon(nil, "to_powder", {
				no_bg = true,
				parent = var_39_1:getChildByName("icon2")
			})
		end
		
		if_set(var_39_1, "txt_sell_price2", "+" .. comma_value(var_39_3))
		
		if GachaTempInventory:isCharacterMode() then
			if_set(var_39_1:getChildByName("btn_sell"), "label", T("sell_count2", {
				count = var_39_4
			}))
		else
			if_set(var_39_1:getChildByName("btn_sell"), "label", T("sell_count3", {
				count = var_39_4
			}))
		end
		
		if var_39_4 == 0 then
			if_set_opacity(var_39_1, "btn_cancel2", 76.5)
			if_set_opacity(var_39_1, "btn_sell", 76.5)
		else
			if_set_opacity(var_39_1, "btn_cancel2", 255)
			if_set_opacity(var_39_1, "btn_sell", 255)
		end
		
		table.print(var_39_6)
		
		local var_39_7 = var_39_1:getChildByName("n_cost2")
		
		if get_cocos_refid(var_39_7) then
			for iter_39_0 = 1, 3 do
				local var_39_8 = "ma_elemental_" .. iter_39_0
				
				if_set(var_39_7, "txt_s" .. iter_39_0, "+" .. to_n((var_39_6 or {})[var_39_8]))
				UIUtil:getRewardIcon(nil, var_39_8, {
					no_bg = true,
					parent = var_39_7:getChildByName("icon_s" .. iter_39_0)
				})
			end
		end
	else
		local var_39_9 = var_39_0:getChildByName("n_takeout_mode")
		local var_39_10 = 0
		
		for iter_39_1, iter_39_2 in pairs(arg_39_0.vars.list) do
			var_39_10 = var_39_10 + iter_39_2.count
		end
		
		local var_39_11 = to_n(GAME_STATIC_VARIABLE.temp_invent_pull_limit)
		
		if_set(var_39_9, "t_move", T("temp_inven_desc2", {
			count = var_39_10,
			max_count = var_39_11
		}))
		
		if var_39_10 == 0 then
			if_set_opacity(var_39_9, "btn_empty", 76.5)
			if_set_opacity(var_39_9, "btn_takeout", 76.5)
		else
			if_set_opacity(var_39_9, "btn_empty", 255)
			if_set_opacity(var_39_9, "btn_takeout", 255)
		end
	end
end

function GachaTempInventoryBasket.getFreeBasket(arg_40_0)
	local var_40_0 = 0
	
	for iter_40_0, iter_40_1 in pairs(arg_40_0.vars.list) do
		var_40_0 = var_40_0 + iter_40_1.count
	end
	
	return to_n(GAME_STATIC_VARIABLE.temp_invent_pull_limit) - var_40_0
end

function GachaTempInventoryBasket.isFreeBasket(arg_41_0)
	return arg_41_0:getFreeBasket() > 0
end

function GachaTempInventoryBasket.getScrollViewItem(arg_42_0, arg_42_1)
	local var_42_0 = load_control("wnd/gacha_inven_item.csb")
	local var_42_1 = var_42_0:getChildByName("btn_select")
	
	GachaUnit:setSpecial(var_42_0, arg_42_1, {
		use_grade = true,
		use_btn_select = true,
		popup_delay = 200,
		count = arg_42_1.count,
		popup_control = var_42_1
	})
	var_42_1:setName("btn_select_right")
	
	var_42_0.datasource = arg_42_1
	
	return var_42_0
end

function GachaTempInventoryBasket.onSelectScrollViewItem(arg_43_0, arg_43_1, arg_43_2)
end

function GachaTempInventoryBasket.selectItem(arg_44_0, arg_44_1)
	if not get_cocos_refid(arg_44_1) then
		return 
	end
	
	local var_44_0 = getParentWindow(arg_44_1).datasource
	local var_44_1 = 0
	
	for iter_44_0, iter_44_1 in pairs(arg_44_0.vars.list) do
		if iter_44_1 == var_44_0 then
			var_44_1 = iter_44_0
			
			break
		end
	end
	
	if var_44_1 > 0 and systick() - to_n(arg_44_1.touch_tick) < 180 then
		if arg_44_0.vars.stack_mode then
			arg_44_0:removeWithKeepPos(var_44_1)
			table.remove(arg_44_0.vars.list, var_44_1)
			GachaTempInventory:revertItem(var_44_0.code, var_44_0.grade_attr, var_44_0.count)
			arg_44_0:updateBasketCount()
		elseif var_44_0.count > 1 then
			var_44_0.count = var_44_0.count - 1
			
			if_set(arg_44_0.ScrollViewItems[var_44_1].control, "txt_count", var_44_0.count)
			GachaTempInventory:revertItem(var_44_0.code, var_44_0.grade_attr)
			arg_44_0:updateBasketCount()
		elseif var_44_0.count == 1 then
			arg_44_0:removeWithKeepPos(var_44_1)
			table.remove(arg_44_0.vars.list, var_44_1)
			GachaTempInventory:revertItem(var_44_0.code, var_44_0.grade_attr)
			arg_44_0:updateBasketCount()
		end
	end
end
