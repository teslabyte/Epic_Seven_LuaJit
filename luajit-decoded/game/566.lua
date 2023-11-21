Inventory.Etc = {}

local var_0_0 = {
	All = 1,
	Fragment = 3,
	Enhancement = 5,
	Catalyst = 4,
	Consumable = 7,
	Crafting = 6,
	Currency = 2
}

function Inventory.Etc.getSelectItem(arg_1_0, arg_1_1)
	if not arg_1_0.select_items then
		return nil
	end
	
	return arg_1_0.select_items[arg_1_1]
end

function Inventory.Etc.getTotalSelectItemsCount(arg_2_0)
	return arg_2_0.total_count or 0
end

function Inventory.Etc.getTotalSelectItemsPrice(arg_3_0)
	return arg_3_0.total_price or 0
end

function Inventory.Etc.setSelectItem(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.select_items = arg_4_0.select_items or {}
	
	if arg_4_2 == 0 then
		arg_4_0.select_items[arg_4_1] = nil
	else
		local var_4_0 = (DB("item_material", arg_4_1, "price") or 0) * arg_4_2
		
		arg_4_0.select_items[arg_4_1] = {
			code = arg_4_1,
			price = var_4_0,
			count = arg_4_2
		}
	end
	
	arg_4_0.total_count = 0
	arg_4_0.total_price = 0
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0:getSelectItems()) do
		arg_4_0.total_count = arg_4_0.total_count + iter_4_1.count
		arg_4_0.total_price = arg_4_0.total_price + iter_4_1.price
	end
	
	Inventory.vars.listview:refresh()
	arg_4_0:updateSellButton()
end

function Inventory.Etc.getSelectItemCount(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:getSelectItem(arg_5_1)
	
	if not var_5_0 then
		return 0
	end
	
	return var_5_0.count or 0
end

function Inventory.Etc.getSelectItems(arg_6_0)
	return arg_6_0.select_items or {}
end

function Inventory.Etc.isSelected(arg_7_0)
	return table.count(arg_7_0:getSelectItems()) ~= 0
end

function Inventory.Etc.sellPenguins(arg_8_0)
	local var_8_0 = 0
	local var_8_1 = UnitLevelUp:get_sorted_penguin_table() or {}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0:getSelectItems()) do
		local var_8_2
		
		for iter_8_2, iter_8_3 in pairs(var_8_1) do
			if iter_8_3.id == iter_8_0 then
				var_8_2 = iter_8_3
			end
		end
		
		if not var_8_2 then
			print("error cant found ", iter_8_0, " in get_sorted_penguin_table!")
			
			return 
		end
		
		local var_8_3 = var_8_2.id
		local var_8_4 = var_8_2.grade
		local var_8_5, var_8_6 = DB("rune_sell", tostring(var_8_4), {
			"token",
			"reward"
		})
		
		if var_8_3 ~= "ma_m8021" and var_8_5 and var_8_6 > 0 then
			var_8_0 = var_8_0 + var_8_6 * arg_8_0:getSelectItemCount(iter_8_0)
		end
	end
	
	local var_8_7 = {}
	
	for iter_8_4, iter_8_5 in pairs(arg_8_0:getSelectItems()) do
		var_8_7[tonumber(DB("item_material", iter_8_4, {
			"grade"
		}))] = iter_8_5.count
	end
	
	local var_8_8, var_8_9 = UnitLevelUp:get_penguin_sell_data(var_8_7)
	local var_8_10 = load_dlg("msgbox_item_sel", true, "wnd")
	
	if get_cocos_refid(var_8_10) then
		if var_8_0 and var_8_0 > 0 then
			UIUtil:getRewardIcon(arg_8_0:getTotalSelectItemsPrice(), "to_gold", {
				parent = var_8_10:getChildByName("reward_item1/2")
			})
			UIUtil:getRewardIcon(var_8_0, "to_hero1", {
				parent = var_8_10:getChildByName("reward_item2/2")
			})
		else
			UIUtil:getRewardIcon(arg_8_0:getTotalSelectItemsPrice(), "to_gold", {
				parent = var_8_10:getChildByName("reward_item1/1")
			})
		end
		
		Dialog:msgBox(T("sell_equips", {
			count = comma_value(arg_8_0:getTotalSelectItemsCount())
		}), {
			yesno = true,
			dlg = var_8_10,
			title = T("sell_equips_name"),
			parent = Inventory.vars.wnd,
			handler = function()
				query("sell_items", {
					p_units = json.encode(var_8_9),
					s_items = json.encode(var_8_8)
				})
			end
		})
	end
end

function Inventory.Etc.sellFragments(arg_10_0)
	local var_10_0 = arg_10_0:getTotalSelectItemsPrice()
	local var_10_1 = {}
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0:getSelectItems()) do
		table.insert(var_10_1, {
			iter_10_0,
			iter_10_1.count
		})
	end
	
	local var_10_2 = load_dlg("msgbox_item_sel", true, "wnd")
	
	if get_cocos_refid(var_10_2) then
		UIUtil:getRewardIcon(var_10_0, "to_gold", {
			parent = var_10_2:getChildByName("reward_item1/1")
		})
		Dialog:msgBox(T("sell_equips", {
			count = comma_value(arg_10_0:getTotalSelectItemsCount())
		}), {
			yesno = true,
			dlg = var_10_2,
			title = T("sell_equips_name"),
			parent = Inventory.vars.wnd,
			handler = function()
				query("sell_items", {
					s_items = json.encode(var_10_1)
				})
			end
		})
	end
end

function Inventory.Etc.sell(arg_12_0)
	if not arg_12_0:isSelected() then
		return 
	end
	
	if arg_12_0.tab == var_0_0.Enhancement then
		arg_12_0:sellPenguins()
	elseif arg_12_0.tab == var_0_0.Fragment then
		arg_12_0:sellFragments()
	end
end

function Inventory.Etc.toggleSellMode(arg_13_0, arg_13_1)
	local var_13_0 = Inventory.vars.wnd:getChildByName("n_tab_sell_stuff")
	
	if not arg_13_0.sell_mode then
		arg_13_0.sell_mode = true
	else
		arg_13_0.sell_mode = false
	end
	
	arg_13_0.select_items = {}
	
	if arg_13_1 ~= nil then
		arg_13_0.sell_mode = arg_13_1
	end
	
	if_set(var_13_0, "txt_sell_count", T("sell_count", {
		count = 0
	}))
	if_set_opacity(var_13_0, "btn_sell", 76.5)
	if_set_visible(var_13_0, "icon", false)
	if_set_visible(var_13_0, "txt_sell_price", false)
	if_set_visible(var_13_0, "icon2", false)
	if_set_visible(var_13_0, "btn_sell", arg_13_0.sell_mode)
	if_set_visible(var_13_0, "btn_delete", not arg_13_0.sell_mode)
	if_set_visible(var_13_0, "btn_delete_after", arg_13_0.sell_mode)
	if_set_visible(var_13_0, "btn_sell_block", false)
	Inventory.vars.listview:refresh()
end

function Inventory.Etc.getSellPenguinsInfo(arg_14_0)
	local var_14_0 = 0
	local var_14_1 = UnitLevelUp:get_sorted_penguin_table()
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0:getSelectItems()) do
		local var_14_2
		
		for iter_14_2, iter_14_3 in pairs(var_14_1 or {}) do
			if iter_14_3.id == iter_14_0 then
				var_14_2 = iter_14_3
			end
		end
		
		if not var_14_2 then
			print("error cant found ", iter_14_0, " in get_sorted_penguin_table!")
			
			return 
		end
		
		local var_14_3 = var_14_2.id
		local var_14_4 = var_14_2.grade
		local var_14_5, var_14_6 = DB("rune_sell", tostring(var_14_4), {
			"token",
			"reward"
		})
		
		if var_14_3 ~= "ma_m8021" and var_14_5 and var_14_6 > 0 then
			local var_14_7 = var_14_6 * arg_14_0:getSelectItemCount(iter_14_0)
			
			if string.starts(var_14_5, "to_hero") then
				var_14_0 = var_14_0 + var_14_7
			end
		end
	end
	
	return var_14_0
end

function Inventory.Etc.updateSellButton(arg_15_0)
	local var_15_0 = Inventory.vars.wnd:getChildByName("n_tab_sell_stuff")
	
	if not get_cocos_refid(var_15_0) then
		return 
	end
	
	if_set(var_15_0, "txt_sell_count", T("sell_count", {
		count = comma_value(arg_15_0:getTotalSelectItemsCount())
	}))
	if_set_visible(var_15_0, "icon", arg_15_0:isSelected())
	
	local var_15_1 = arg_15_0:getTotalSelectItemsPrice()
	local var_15_2 = 0
	
	if arg_15_0.tab == var_0_0.Enhancement then
		var_15_2 = arg_15_0:getSellPenguinsInfo()
	end
	
	if_set(var_15_0, "txt_sell_price", "+" .. comma_value(var_15_1))
	if_set_visible(var_15_0, "txt_sell_price", arg_15_0:isSelected())
	
	local var_15_3 = var_15_2 > 0
	
	if var_15_3 then
		if_set_sprite(var_15_0, "icon2", "item/token_hero1.png")
		if_set(var_15_0, "txt_sell_price2", "+" .. var_15_2)
	end
	
	if_set_visible(var_15_0, "txt_sell_price2", var_15_3)
	if_set_visible(var_15_0, "icon2", var_15_3)
	if_set_opacity(var_15_0, "btn_sell", arg_15_0:isSelected() and 255 or 76.5)
end

function Inventory.Etc.onSelect(arg_16_0, arg_16_1)
	if not arg_16_0.sell_mode then
		return 
	end
	
	if not arg_16_1.code then
		return 
	end
	
	if not Inventory:isSellableItem(arg_16_1.code) then
		return 
	end
	
	if arg_16_0:getSelectItem(arg_16_1.code) then
		arg_16_0:setSelectItem(arg_16_1.code, 0)
		
		return 
	end
	
	if arg_16_1.count == 1 then
		arg_16_0:setSelectItem(arg_16_1.code, 1)
		
		return 
	end
	
	arg_16_0.count_popup = Dialog:openCountPopup({
		wnd = Inventory.vars.wnd,
		t_title = T("ui_item_select_slidebar_popup_inti_title"),
		t_disc = T("ui_item_select_slidebar_popup_desc"),
		max_count = arg_16_1.count,
		back_func = function()
			if get_cocos_refid(arg_16_0.count_popup) then
				BackButtonManager:pop("item_select_slidebar_popup")
				arg_16_0.count_popup:removeFromParent()
			end
		end,
		slider_func = function()
			if not get_cocos_refid(arg_16_0.count_popup) then
				return 
			end
			
			if_set(arg_16_0.count_popup, "t_count", arg_16_0.count_popup:getChildByName("slider"):getPercent() .. "/" .. arg_16_1.count)
		end,
		button_func = function()
			local var_19_0 = arg_16_0.count_popup:getChildByName("slider"):getPercent()
			
			arg_16_0:setSelectItem(arg_16_1.code, var_19_0)
			BackButtonManager:pop("item_select_slidebar_popup")
			arg_16_0.count_popup:removeFromParent()
		end
	})
end

function Inventory.Etc.onEnter(arg_20_0)
end

function Inventory.Etc.saveSpecialItemList(arg_21_0)
	Inventory:setNoticeBoxItem(false)
	
	local var_21_0 = arg_21_0:getSpecialItemList()
	local var_21_1 = {}
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		if iter_21_1 == 0 then
			var_21_1[iter_21_0] = true
		end
	end
	
	for iter_21_2, iter_21_3 in pairs(var_21_1) do
		var_21_0[iter_21_2] = nil
	end
	
	local var_21_2 = json.encode(var_21_0)
	
	SAVE:set("inventory.special_item_list", var_21_2)
end

function Inventory.Etc.saveGradeJumpItemList(arg_22_0)
	Inventory:setNoticeBoxItem(false)
	
	local var_22_0 = arg_22_0:getGradeJumpItemList()
	local var_22_1 = {}
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if iter_22_1 == 0 then
			var_22_1[iter_22_0] = true
		end
	end
	
	for iter_22_2, iter_22_3 in pairs(var_22_1) do
		var_22_0[iter_22_2] = nil
	end
	
	local var_22_2 = json.encode(var_22_0)
	
	SAVE:set("inventory.gradejump_item_list", var_22_2)
end

function Inventory.Etc.saveAwakeJumpItemList(arg_23_0)
	Inventory:setNoticeBoxItem(false)
	
	local var_23_0 = arg_23_0:getAwakeJumpItemList()
	local var_23_1 = {}
	
	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		if iter_23_1 == 0 then
			var_23_1[iter_23_0] = true
		end
	end
	
	for iter_23_2, iter_23_3 in pairs(var_23_1) do
		var_23_0[iter_23_2] = nil
	end
	
	local var_23_2 = json.encode(var_23_0)
	
	SAVE:set("inventory.awakejump_item_list", var_23_2)
end

function Inventory.Etc.selectSubTab(arg_24_0, arg_24_1)
	if arg_24_1 == var_0_0.Consumable then
		TutorialGuide:ifStartGuide("itemselection")
	end
	
	local var_24_0 = Inventory:isEtcTab()
	local var_24_1 = arg_24_1 == var_0_0.Fragment or arg_24_1 == var_0_0.Enhancement
	
	if var_24_0 and var_24_1 then
		if Inventory.vars.listview then
			Inventory.vars.listview:removeAllChildren()
		end
		
		Inventory.vars.listview = Inventory.vars.listview_eq_material
	elseif var_24_0 and not var_24_1 then
		if Inventory.vars.listview then
			Inventory.vars.listview:removeAllChildren()
		end
		
		Inventory.vars.listview = Inventory.vars.listview_normal
	end
	
	if_set_visible(Inventory.vars.wnd, "n_tab_sell_stuff", var_24_1)
	
	local var_24_2 = Inventory.vars.wnd:getChildByName("n_tab_sell_stuff")
	
	if_set(var_24_2, "txt_sell_count", T("sell_count", {
		count = 0
	}))
	if_set_visible(var_24_2, "icon", false)
	if_set_visible(var_24_2, "txt_sell_price", false)
	if_set_visible(var_24_2, "icon2", false)
	if_set_visible(var_24_2, "btn_sell", false)
	if_set_visible(var_24_2, nil, var_24_0 and var_24_1)
	Inventory.vars.listview_normal:setVisible(var_24_0 and not var_24_1)
	Inventory.vars.listview_eq_material:setVisible(var_24_0 and var_24_1)
	
	if arg_24_0.sell_mode then
		arg_24_0:toggleSellMode()
	end
	
	if arg_24_1 == var_0_0.Enhancement then
		if_set_visible(var_24_2, "btn_delete", true)
		if_set_visible(var_24_2, "btn_delete_after", false)
	end
	
	if arg_24_0.tab == var_0_0.Consumable then
		arg_24_0:saveSpecialItemList()
		arg_24_0:saveGradeJumpItemList()
		arg_24_0:saveAwakeJumpItemList()
	end
	
	arg_24_0.tab = arg_24_1
end

local var_0_1 = {
	promotion = 14,
	multi_eq_select = 12,
	gradejump = 13,
	stone = 11,
	expendable = 15,
	petfood = 3,
	token = 2,
	intimacy = 1,
	reforge = 10,
	essence = 6,
	xpup = 15,
	material = 7,
	catalyst = 9,
	rune = 8,
	fragment = 4,
	special = 12,
	devotion = 4,
	skillup = 5
}

local function var_0_2(arg_25_0)
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(Account.items) do
		if iter_25_1 > 0 then
			local var_25_1, var_25_2, var_25_3 = DB("item_material", iter_25_0, {
				"ma_type",
				"grade",
				"sort"
			})
			
			if table.contains(arg_25_0, var_25_1) then
				table.push(var_25_0, {
					code = iter_25_0,
					count = iter_25_1,
					type = var_25_1,
					grade = var_25_2,
					sort = var_25_3,
					priority = var_0_1[var_25_1]
				})
			end
		end
	end
	
	return var_25_0
end

function Inventory.Etc.getCurrencyItems(arg_26_0)
	local var_26_0 = {}
	
	AccountData.currency = AccountData.currency or {}
	
	for iter_26_0, iter_26_1 in pairs(Account:getCurrencyCodes()) do
		if (AccountData.currency[iter_26_1] or 0) > 0 then
			local var_26_1 = "to_" .. iter_26_1
			local var_26_2, var_26_3 = DB("item_token", var_26_1, {
				"grade",
				"hide"
			})
			
			if not var_26_3 then
				table.push(var_26_0, {
					code = var_26_1,
					count = AccountData.currency[iter_26_1],
					priority = var_0_1.token,
					grade = var_26_2
				})
			end
		end
	end
	
	for iter_26_2, iter_26_3 in pairs(Account.items) do
		local var_26_4, var_26_5, var_26_6 = DB("item_material", iter_26_2, {
			"ma_type",
			"grade",
			"ma_type2"
		})
		
		if iter_26_3 > 0 and (var_26_4 == "token" or var_26_4 == "coupon") then
			table.push(var_26_0, {
				code = iter_26_2,
				count = iter_26_3,
				priority = var_0_1[var_26_4],
				grade = var_26_5
			})
		elseif iter_26_3 > 0 and var_26_4 == "adin" and var_26_6 == "change_attr" then
			table.push(var_26_0, {
				code = iter_26_2,
				count = iter_26_3,
				priority = var_0_1[var_26_4],
				grade = var_26_5
			})
		end
	end
	
	return var_26_0
end

function Inventory.Etc.getEnhancementItems(arg_27_0)
	local var_27_0 = var_0_2({
		"skillup",
		"petfood",
		"devotion",
		"reforge",
		"xpup",
		"promotion",
		"intimacy",
		"rune"
	})
	
	for iter_27_0, iter_27_1 in pairs(Account:getUnits()) do
		if iter_27_1:isExpUnit() then
			local var_27_1 = iter_27_1:getBaseGrade()
			local var_27_2 = "ma_m80" .. var_27_1 .. "1"
			
			if var_27_1 <= 3 then
				local var_27_3 = false
				
				for iter_27_2, iter_27_3 in pairs(var_27_0) do
					if iter_27_3.code == var_27_2 then
						var_27_0[iter_27_2].count = var_27_0[iter_27_2].count + 1
						var_27_3 = true
						arg_27_0.uid = arg_27_0.uid or {}
						arg_27_0.uid[var_27_2] = arg_27_0.uid[var_27_2] or {}
						
						table.insert(arg_27_0.uid[var_27_2], {
							iter_27_1.inst.uid
						})
						
						break
					end
				end
				
				if not var_27_3 then
					table.push(var_27_0, {
						count = 1,
						code = var_27_2,
						priority = var_0_1.xpup,
						grade = var_27_1
					})
					
					arg_27_0.uid = arg_27_0.uid or {}
					arg_27_0.uid[var_27_2] = arg_27_0.uid[var_27_2] or {}
					
					table.insert(arg_27_0.uid[var_27_2], {
						iter_27_1.inst.uid
					})
				end
			end
		end
	end
	
	for iter_27_4, iter_27_5 in pairs(Account:getStoneItems()) do
		if to_n(iter_27_5.count) > 0 then
			local var_27_4, var_27_5 = DB("item_material", iter_27_5.code, {
				"ma_type",
				"grade"
			})
			local var_27_6 = {
				priority = var_0_1[var_27_4],
				grade = var_27_5
			}
			
			table.merge(var_27_6, iter_27_5)
			table.push(var_27_0, var_27_6)
		end
	end
	
	return var_27_0
end

function Inventory.Etc.selectItems(arg_28_0)
	local var_28_0 = {}
	
	if arg_28_0.tab == var_0_0.All or arg_28_0.tab == var_0_0.Currency then
		table.join(var_28_0, arg_28_0:getCurrencyItems())
	end
	
	if arg_28_0.tab == var_0_0.All or arg_28_0.tab == var_0_0.Fragment then
		table.join(var_28_0, var_0_2({
			"fragment"
		}))
	end
	
	if arg_28_0.tab == var_0_0.All or arg_28_0.tab == var_0_0.Catalyst then
		table.join(var_28_0, var_0_2({
			"essence"
		}))
	end
	
	if arg_28_0.tab == var_0_0.All or arg_28_0.tab == var_0_0.Enhancement then
		table.join(var_28_0, arg_28_0:getEnhancementItems())
	end
	
	if arg_28_0.tab == var_0_0.All or arg_28_0.tab == var_0_0.Crafting then
		table.join(var_28_0, var_0_2({
			"material",
			"catalyst"
		}))
	end
	
	if arg_28_0.tab == var_0_0.All or arg_28_0.tab == var_0_0.Consumable then
		table.join(var_28_0, var_0_2({
			"special",
			"expendable",
			"gradejump",
			"awakenjump",
			"multi_eq_select"
		}))
	end
	
	table.sort(var_28_0, function(arg_29_0, arg_29_1)
		arg_29_0.priority = arg_29_0.priority or 0
		arg_29_1.priority = arg_29_1.priority or 0
		
		if arg_29_0.priority ~= arg_29_1.priority then
			return arg_29_1.priority < arg_29_0.priority
		end
		
		arg_29_0.grade = arg_29_0.grade or 0
		arg_29_1.grade = arg_29_1.grade or 0
		
		if arg_29_0.grade ~= arg_29_1.grade then
			return arg_29_1.grade < arg_29_0.grade
		end
		
		arg_29_0.sort = arg_29_0.sort or 0
		arg_29_1.sort = arg_29_1.sort or 0
		
		if arg_29_0.sort ~= arg_29_1.sort then
			return arg_29_0.sort < arg_29_1.sort
		end
		
		return arg_29_0.code < arg_29_1.code
	end)
	
	return var_28_0
end

function Inventory.Etc.isHaveSpecialItem(arg_30_0)
	for iter_30_0, iter_30_1 in pairs(Account.items) do
		if DB("item_material", iter_30_0, "ma_type") == "special" and iter_30_1 > 0 then
			return true
		end
	end
	
	return false
end

function Inventory.Etc.getSpecialItemList(arg_31_0)
	local var_31_0 = {}
	
	for iter_31_0, iter_31_1 in pairs(Account.items) do
		if DB("item_material", iter_31_0, "ma_type") == "special" then
			var_31_0[iter_31_0] = iter_31_1
		end
	end
	
	return var_31_0
end

function Inventory.Etc.getGradeJumpItemList(arg_32_0)
	local var_32_0 = {}
	
	for iter_32_0, iter_32_1 in pairs(Account.items) do
		if DB("item_material", iter_32_0, "ma_type") == "gradejump" then
			var_32_0[iter_32_0] = iter_32_1
		end
	end
	
	return var_32_0
end

function Inventory.Etc.getAwakeJumpItemList(arg_33_0)
	local var_33_0 = {}
	
	for iter_33_0, iter_33_1 in pairs(Account.items) do
		if DB("item_material", iter_33_0, "ma_type") == "awakenjump" then
			var_33_0[iter_33_0] = iter_33_1
		end
	end
	
	return var_33_0
end

function Inventory.Etc.checkItemListDiff(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_1 or not arg_34_2 then
		return 
	end
	
	for iter_34_0, iter_34_1 in pairs(arg_34_1) do
		if (tonumber(iter_34_1) or 0) > (tonumber(arg_34_2[iter_34_0]) or 0) then
			return true
		end
	end
	
	for iter_34_2, iter_34_3 in pairs(arg_34_2) do
		if (tonumber(arg_34_1[iter_34_2]) or 0) > (tonumber(iter_34_3) or 0) then
			return true
		end
	end
	
	return false
end

function Inventory.Etc.isSpecialItemListChange(arg_35_0)
	local var_35_0 = SAVE:get("inventory.special_item_list")
	
	if not var_35_0 then
		return false
	end
	
	local var_35_1 = json.decode(var_35_0)
	
	if not var_35_1 then
		return false
	end
	
	return arg_35_0:checkItemListDiff(arg_35_0:getSpecialItemList(), var_35_1)
end

function Inventory.Etc.isGradeJumpItemListChange(arg_36_0)
	local var_36_0 = SAVE:get("inventory.gradejump_item_list")
	
	if not var_36_0 then
		return false
	end
	
	local var_36_1 = json.decode(var_36_0)
	
	if not var_36_1 then
		return false
	end
	
	return arg_36_0:checkItemListDiff(arg_36_0:getGradeJumpItemList(), var_36_1)
end

function Inventory.Etc.isAwakeJumpItemListChange(arg_37_0)
	local var_37_0 = SAVE:get("inventory.awakejump_item_list")
	
	if not var_37_0 then
		return false
	end
	
	local var_37_1 = json.decode(var_37_0)
	
	if not var_37_1 then
		return false
	end
	
	return arg_37_0:checkItemListDiff(arg_37_0:getAwakeJumpItemList(), var_37_1)
end

function Inventory.Etc.onLeave(arg_38_0)
	arg_38_0.sell_mode = false
	
	arg_38_0:toggleSellMode(false)
	
	if arg_38_0.tab == var_0_0.Consumable then
		arg_38_0:saveSpecialItemList()
		arg_38_0:saveGradeJumpItemList()
		arg_38_0:saveAwakeJumpItemList()
	end
end
