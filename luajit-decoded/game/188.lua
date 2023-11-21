function HANDLER.pet_auto_inventory(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 == "btn_sell" then
		BattleRepeatPopup:sellItems(1)
	elseif arg_1_1 == "btn_extract" then
		BattleRepeatPopup:sellItems(2)
	elseif arg_1_1 == "btn_autoselect" then
		BattleRepeatPopup:openAutoSelect()
	elseif arg_1_1 == "btn_delete" then
		BattleRepeatPopup:toggleSellMode(true)
	elseif arg_1_1 == "btn_delete_after" then
		BattleRepeatPopup:toggleSellMode(false)
	elseif arg_1_1 == "btn_close" then
		BattleRepeatPopup:closeItemListPopup()
	end
end

function HANDLER_BEFORE.pet_auto_inventory_card(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == "btn_select" then
		arg_2_0.touch_tick = systick()
	end
end

function HANDLER.pet_auto_inventory_card(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "btn_select" and arg_3_0:getParent() and arg_3_0:getParent().item and systick() - to_n(arg_3_0.touch_tick) < 180 then
		local var_3_0 = arg_3_0:getParent().item
		
		BattleRepeatPopup:onSelectItemCard(var_3_0)
	end
end

BattleRepeatPopup = {}

copy_functions(ScrollView, BattleRepeatPopup)

function BattleRepeatPopup.openItemListPopup(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1 or {}
	
	arg_4_0.vars = {}
	arg_4_0.vars.items = BattleRepeat:getPetRepeatItems() or {}
	arg_4_0.vars.sellmode = false
	arg_4_0.vars.selectedItems = {}
	arg_4_0.vars.itemIdx = 1
	arg_4_0.vars.map_id = nil
	
	if BackPlayManager:isRunning() then
		arg_4_0.vars.map_id = BackPlayManager:getRunningMapId()
	end
	
	if not arg_4_0.vars.map_id then
		if BattleRepeat.map_id then
			arg_4_0.vars.map_id = BattleRepeat.map_id
		elseif ClearResult:getMapId() then
			arg_4_0.vars.map_id = ClearResult:getMapId()
		end
	end
	
	arg_4_0.vars.itemListPopup = load_dlg("pet_auto_inventory", true, "wnd", function()
		BattleRepeatPopup:closeItemListPopup()
	end)
	
	if_set_visible(arg_4_0.vars.itemListPopup, "n_dim_img", not var_4_0.is_back_play)
	
	local var_4_1 = arg_4_0.vars.itemListPopup:getChildByName("ScrollView")
	local var_4_2 = DBT("level_enter", arg_4_0.vars.map_id, {
		"cp_material",
		"cp_value"
	})
	
	if UnlockSystem:isUnlockSystem(UNLOCK_ID.LOCAL_SHOP) and var_4_2.cp_material and var_4_2.cp_value and not var_4_0.is_back_play then
		local var_4_3 = var_4_1:getContentSize()
		local var_4_4 = Account:getItemCount(var_4_2.cp_material) or 0
		
		var_4_1:setContentSize({
			width = var_4_3.width,
			height = var_4_3.height - 86
		})
		
		local var_4_5 = DB("item_material", var_4_2.cp_material, {
			"name"
		})
		
		if_set(arg_4_0.vars.itemListPopup, "title_contr_point", T(var_4_5))
		if_set(arg_4_0.vars.itemListPopup, "count_cp", T("mission_base_cpshop_cp_value", {
			value = var_4_4
		}))
		if_set_visible(arg_4_0.vars.itemListPopup, "contr_point", true)
	else
		if_set_visible(arg_4_0.vars.itemListPopup, "contr_point", false)
	end
	
	BattleRepeat:getParentPopup():addChild(arg_4_0.vars.itemListPopup)
	arg_4_0:updateInventoryUI()
	BattleRepeat:sortPetRepeatItems()
	arg_4_0:initScrollView(var_4_1, 111, 111)
	arg_4_0:setScrollViewItems(arg_4_0.vars.items)
end

function BattleRepeatPopup.updateInventoryUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.itemListPopup) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.itemListPopup
	local var_6_1 = var_6_0:getChildByName("btn_delete")
	
	if_set_visible(var_6_0, "n_tab_sell", false)
	if_set_visible(var_6_0, "btn_delete_after", false)
	if_set_visible(var_6_0, "n_info", false)
	if_set_visible(var_6_1, nil, true)
	
	if not BattleRepeat:canSellItems() then
		if_set_visible(var_6_0, "n_info", true)
		if_set_opacity(var_6_1, nil, 76.5)
		var_6_1:setTouchEnabled(false)
	else
		if_set_visible(var_6_0, "n_info", false)
		if_set_opacity(var_6_1, nil, 255)
		var_6_1:setTouchEnabled(true)
	end
	
	arg_6_0:_updateInventoryUI()
end

function BattleRepeatPopup._updateInventoryUI(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.itemListPopup) then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.itemListPopup
	local var_7_1 = table.count(arg_7_0.vars.items)
	local var_7_2 = table.count(arg_7_0.vars.selectedItems)
	
	if_set(var_7_0, "txt_reward_count", "+" .. var_7_1)
	if_set(var_7_0, "t_item_count", T("ui_extraction_select_inventory", {
		count = table.count(arg_7_0.vars.selectedItems)
	}))
	if_set_opacity(var_7_0, "btn_sell", var_7_2 <= 0 and 76.5 or 255)
	
	local var_7_3 = Inventory:checkExtractItemList(arg_7_0.vars.selectedItems)
	local var_7_4 = var_7_2 > 0 and var_7_3
	
	if_set_opacity(var_7_0, "btn_extract", var_7_4 and 255 or 76.5)
	
	if not Account:isUnlockExtract() then
		if_set_visible(var_7_0, "btn_extract", false)
		
		local var_7_5 = var_7_0:getChildByName("t_item_count")
		
		if not var_7_5.originPosX then
			var_7_5.originPosX = var_7_5:getPositionX()
		end
		
		var_7_5:setPositionX(var_7_5.originPosX - 150)
	end
end

function BattleRepeatPopup.getScrollViewItem(arg_8_0, arg_8_1)
	local var_8_0 = load_control("wnd/pet_auto_inventory_card.csb")
	
	if_set_visible(var_8_0, "n_select", false)
	if_set_visible(var_8_0, "icon_dont", false)
	
	local var_8_1 = {
		zero = true,
		star_scale = 0.65,
		set_fx = arg_8_1.set_fx,
		equip_stat = arg_8_1.equip_stat,
		g = arg_8_1.g,
		set_drop = arg_8_1.set_drop,
		show_small_count = arg_8_1.show_small_count,
		add_bonus = arg_8_1.add_bonus,
		add_pet_bonus = arg_8_1.add_pet_bonus,
		dlg_name = ".reward_icon" .. arg_8_0.vars.itemIdx,
		parent = var_8_0:getChildByName("bg_item"),
		reward_info = arg_8_1.reward_info
	}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1.reward_info or {}) do
		if Account:isFirstReward(arg_8_0.vars.map_id, arg_8_1.code) then
			var_8_1.reward_info.first_reward = true
		end
		
		if iter_8_0 == "star_reward" then
			var_8_1.reward_info.stage_mission = true
		end
		
		if iter_8_0 == "add_bonus" and iter_8_1 > 0 then
			var_8_1.reward_info.account_skill_bonus = true
		end
		
		if iter_8_0 == "add_pet_bonus" and iter_8_1 > 0 then
			var_8_1.reward_info.pet_skill_bonus = true
		end
		
		if iter_8_0 == "goldbox_reward" then
			var_8_1.reward_info.goldbox_reward = true
		end
	end
	
	if not arg_8_1.code then
		arg_8_1.code = arg_8_1.item_code
	end
	
	local var_8_2 = 1
	local var_8_3 = var_8_0:getChildByName("btn_select")
	
	if arg_8_1.isEquip then
		var_8_1.equip = arg_8_1
		
		if arg_8_1:isArtifact() or arg_8_1:isStone() then
			var_8_2 = 0.77
		end
	else
		var_8_3:setTouchEnabled(false)
	end
	
	if string.starts(arg_8_1.code, "c") then
		var_8_2 = 1.3
		var_8_1.no_tooltip = true
	end
	
	if arg_8_1.removed or arg_8_1.can_not_sel then
		var_8_1.no_tooltip = true
		var_8_1.no_popup = true
	end
	
	var_8_1.scale = var_8_2
	
	local var_8_4 = UIUtil:getRewardIcon(arg_8_1.count, arg_8_1.code, var_8_1)
	
	if arg_8_1.removed or arg_8_1.can_not_sel then
		var_8_4:setOpacity(76.5)
	end
	
	var_8_4:setPosition(0, 0)
	var_8_4:setAnchorPoint(0.5, 0.5)
	
	var_8_0.item = arg_8_1
	arg_8_0.vars.itemIdx = arg_8_0.vars.itemIdx + 1
	
	return var_8_0
end

function BattleRepeatPopup.toggleSellMode(arg_9_0, arg_9_1)
	BattleRepeatPopup:resetSelectedItems()
	
	arg_9_0.vars.sellmode = arg_9_1
	
	arg_9_0:toggleIconSellMode(arg_9_1)
	if_set_visible(arg_9_0.vars.itemListPopup, "n_tab_sell", arg_9_1)
	if_set_visible(arg_9_0.vars.itemListPopup, "btn_delete_after", arg_9_1)
	if_set_visible(arg_9_0.vars.itemListPopup, "btn_delete", not arg_9_1)
	
	if arg_9_1 then
	else
		BattleRepeatPopup:resetSelectedItems()
	end
	
	arg_9_0:_updateInventoryUI()
end

function BattleRepeatPopup.toggleIconSellMode(arg_10_0, arg_10_1)
	if not arg_10_0.ScrollViewItems or table.empty(arg_10_0.ScrollViewItems) then
		return 
	end
	
	local var_10_0 = arg_10_1 or arg_10_0.vars.sellmode
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.ScrollViewItems) do
		local var_10_1 = var_10_0 and tocolor("#333333") or tocolor("#FFFFFF")
		
		if not string.starts(iter_10_1.item.code, "e") or iter_10_1.item.isEquip and iter_10_1.item:isArtifact() then
			if_set_color(iter_10_1.control, nil, var_10_1)
		end
		
		if_set_visible(iter_10_1.control, "ui_itemset_pet_eff_loop", not var_10_0)
	end
end

function BattleRepeatPopup.autoSelect(arg_11_0)
	arg_11_0:toggleSellMode(true)
	
	local var_11_0, var_11_1, var_11_2, var_11_3 = arg_11_0:getSelectLists()
	local var_11_4 = {}
	
	local function var_11_5(arg_12_0, arg_12_1, arg_12_2)
		for iter_12_0, iter_12_1 in pairs(arg_12_2) do
			if iter_12_1 then
				table.insert(arg_12_0, arg_12_1 .. iter_12_0)
			end
		end
	end
	
	var_11_5(var_11_4, "g_", var_11_0)
	var_11_5(var_11_4, "t_", var_11_1)
	var_11_5(var_11_4, "e_", var_11_2)
	var_11_5(var_11_4, "k_", var_11_3)
	SAVE:setUserDefaultData(arg_11_0:getSelectInfoKey_v2(), json.encode(var_11_4))
	BattleRepeatPopup:resetSelectedItems()
	
	local function var_11_6(arg_13_0, arg_13_1)
		local var_13_0 = true
		
		if not var_11_2[1] and arg_13_0 == 0 then
			var_13_0 = false
		elseif not var_11_2[2] and arg_13_0 >= 1 and arg_13_0 <= 9 then
			var_13_0 = false
		elseif not var_11_2[3] and arg_13_0 >= 10 and arg_13_0 <= 12 then
			var_13_0 = false
		elseif not var_11_2[4] and arg_13_0 >= 13 and arg_13_0 <= 15 then
			var_13_0 = false
		end
		
		return var_13_0
	end
	
	local function var_11_7(arg_14_0, arg_14_1)
		local var_14_0 = true
		local var_14_1 = 0
		
		if arg_14_1 == "weapon" then
			var_14_1 = 1
		elseif arg_14_1 == "helm" then
			var_14_1 = 2
		elseif arg_14_1 == "armor" then
			var_14_1 = 3
		elseif arg_14_1 == "neck" then
			var_14_1 = 4
		elseif arg_14_1 == "ring" then
			var_14_1 = 5
		elseif arg_14_1 == "boot" then
			var_14_1 = 6
		end
		
		if arg_14_0[var_14_1] == false then
			var_14_0 = false
		end
		
		return var_14_0
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.items) do
		if iter_11_1.isEquip and iter_11_1:isEquip() and not iter_11_1:isArtifact() then
			local var_11_8 = true
			local var_11_9 = iter_11_1.enhance or 0
			local var_11_10
			
			if iter_11_1.db.item_level then
				local var_11_11 = iter_11_1.db.item_level
				
				if var_11_11 <= 28 then
					var_11_10 = 1
				elseif var_11_11 <= 42 then
					var_11_10 = 2
				elseif var_11_11 <= 57 then
					var_11_10 = 3
				elseif var_11_11 <= 71 then
					var_11_10 = 4
				elseif var_11_11 <= 84 then
					var_11_10 = 5
				elseif var_11_11 == 85 then
					var_11_10 = 6
				elseif var_11_11 >= 86 then
					var_11_10 = 7
				end
			else
				var_11_10 = iter_11_1.db.tier
			end
			
			var_11_7(var_11_3, iter_11_1.db.type)
			
			var_11_8 = (not iter_11_1:isStone() or false) and (not iter_11_1:isArtifact() or false) and (var_11_7(var_11_3, iter_11_1.db.type) or false) and (var_11_0[iter_11_1.grade] or false) and (not iter_11_1.db or not iter_11_1.db.ma_type or iter_11_1.db.ma_type ~= "xpup" or false) and (var_11_1[var_11_10] or false) and (not iter_11_1.removed or false) and (not iter_11_1.can_not_sel or false) and (iter_11_1:checkSell() or false) and var_11_8 and var_11_6(var_11_9, 5)
			
			if not SorterExtention:checkFilterOptions(iter_11_1, {
				set = arg_11_0.vars.set,
				mainstat = arg_11_0.vars.mainstat,
				substat1 = arg_11_0.vars.substat1,
				substat2 = arg_11_0.vars.substat2
			}) then
				var_11_8 = false
			end
			
			if var_11_8 then
				table.insert(arg_11_0.vars.selectedItems, iter_11_1)
			end
		end
	end
	
	for iter_11_2, iter_11_3 in pairs(arg_11_0.vars.selectedItems) do
		arg_11_0:updateSelectItemCard(iter_11_3, true)
	end
	
	arg_11_0:closeAutoSelect()
	arg_11_0:_updateInventoryUI()
	arg_11_0:save_autoSelect_filterOpts()
end

function BattleRepeatPopup.save_autoSelect_filterOpts(arg_15_0)
	if not arg_15_0.vars then
		return 
	end
	
	SAVE:setUserDefaultData("inven_autosell_set_filter", arg_15_0.vars.set or "all")
	SAVE:setUserDefaultData("inven_autosell_mainstat_filter", arg_15_0.vars.mainstat or "all")
	SAVE:setUserDefaultData("inven_autosell_substat1_filter", arg_15_0.vars.substat1 or "all")
	SAVE:setUserDefaultData("inven_autosell_substat2_filter", arg_15_0.vars.substat2 or "all")
end

function BattleRepeatPopup.updateSelectItemCard(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars.sellmode then
		return 
	end
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.ScrollViewItems) do
		if iter_16_1.item == arg_16_1 then
			if_set_visible(iter_16_1.control, "n_select", arg_16_2)
			
			iter_16_1.item.select = arg_16_2
			
			if arg_16_2 and Account:isUnlockExtract() then
				if_set_visible(iter_16_1.control, "icon_dont", not iter_16_1.item:isExtractable())
				
				break
			end
			
			if_set_visible(iter_16_1.control, "icon_dont", false)
			
			break
		end
	end
end

function BattleRepeatPopup.onSelectItemCard(arg_17_0, arg_17_1)
	if not arg_17_1.isEquip or not arg_17_0.vars.sellmode then
		return 
	end
	
	if arg_17_1:isArtifact() then
		return 
	end
	
	if arg_17_1.removed then
		balloon_message_with_sound("msg_equipment_cant_sell")
		
		return 
	end
	
	if arg_17_1.can_not_sel then
		if arg_17_1.lock then
			balloon_message_with_sound("equip_sell_locked")
		elseif arg_17_1.parent then
			balloon_message_with_sound("equip_sell_used")
		end
		
		return 
	end
	
	if not arg_17_1.select then
		if not arg_17_1:checkSell() then
			return 
		end
		
		table.insert(arg_17_0.vars.selectedItems, arg_17_1)
		arg_17_0:updateSelectItemCard(arg_17_1, true)
	else
		arg_17_0:removeSelectItem(arg_17_1)
		arg_17_0:updateSelectItemCard(arg_17_1, false)
	end
	
	arg_17_0:_updateInventoryUI()
end

function BattleRepeatPopup.removeSelectItem(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not arg_18_0.vars.selectedItems then
		return 
	end
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.selectedItems) do
		if iter_18_1 == arg_18_1 then
			arg_18_0.vars.selectedItems[iter_18_0] = nil
			
			break
		end
	end
end

function BattleRepeatPopup.getSelectInfoKey(arg_19_0)
	local var_19_0 = tonumber(Stove:getNickNameNo()) or 0
	
	return string.format("autosell:%d_%d_%d", var_19_0, 2, 0)
end

function BattleRepeatPopup.getSelectInfoKey_v2(arg_20_0)
	local var_20_0 = tonumber(Account:getUserId()) or 0
	
	return string.format("autosell:%d_%d_%d", var_20_0, 2, 0)
end

function BattleRepeatPopup.openAutoSelect(arg_21_0)
	if not arg_21_0.vars.sellmode then
		return 
	end
	
	if arg_21_0.vars.autoselect_dlg and get_cocos_refid(arg_21_0.vars.autoselect_dlg) then
		arg_21_0:closeAutoSelect()
	end
	
	arg_21_0.vars.autoselect_dlg = load_dlg("inventory_autosel_all", true, "wnd")
	
	arg_21_0.vars.itemListPopup:getChildByName("n_tab_sell_equip"):addChild(arg_21_0.vars.autoselect_dlg)
	arg_21_0:initAutoSell()
end

function BattleRepeatPopup.getSetOpt(arg_22_0)
	return arg_22_0.vars.set or false
end

function BattleRepeatPopup.getMainStatOpt(arg_23_0)
	return arg_23_0.vars.mainstat or false
end

function BattleRepeatPopup.getSubStat1_Opt(arg_24_0)
	return arg_24_0.vars.substat1 or false
end

function BattleRepeatPopup.getSubStat2_Opt(arg_25_0)
	return arg_25_0.vars.substat2 or false
end

function BattleRepeatPopup.setSetStatFilter(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.sets[arg_26_1]
	
	if not var_26_0 then
		return 
	end
	
	arg_26_0.vars.set = var_26_0
end

function BattleRepeatPopup.setMainStatFilter(arg_27_0, arg_27_1)
	if not arg_27_1 then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.mainstats[arg_27_1]
	
	if not var_27_0 then
		return 
	end
	
	arg_27_0.vars.mainstat = var_27_0
end

function BattleRepeatPopup.setSubStatFilter(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_1 or not arg_28_2 then
		return 
	end
	
	local var_28_0 = arg_28_2 or 1 or 2
	local var_28_1 = arg_28_0.vars.substats[arg_28_1]
	
	if not var_28_1 then
		return 
	end
	
	if var_28_0 == 1 then
		arg_28_0.vars.substat1 = var_28_1
	else
		arg_28_0.vars.substat2 = var_28_1
	end
end

function BattleRepeatPopup.getSubStatOpt(arg_29_0, arg_29_1)
	if not arg_29_1 then
		return 
	end
	
	if arg_29_1 == 1 then
		return arg_29_0.vars.substat1
	else
		return arg_29_0.vars.substat2
	end
end

function BattleRepeatPopup.closeAutoSelect(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.autoselect_dlg) then
		return 
	end
	
	arg_30_0.vars.autoselect_dlg:removeFromParent()
	
	arg_30_0.vars.autoselect_dlg = nil
end

function BattleRepeatPopup.initAutoSell(arg_31_0)
	local var_31_0 = SAVE:getUserDefaultData(arg_31_0:getSelectInfoKey_v2(), "empty")
	
	if var_31_0 == "empty" then
		var_31_0 = SAVE:getUserDefaultData(arg_31_0:getSelectInfoKey(), "[\"g_1\",\"g_2\",\"t_1\",\"t_2\",\"e_1\"]")
	end
	
	local var_31_1 = json.decode(var_31_0)
	
	local function var_31_2(arg_32_0, arg_32_1)
		if not arg_32_1 then
			return 
		end
		
		local var_32_0 = arg_31_0.vars.autoselect_dlg:getChildByName("checkbox_" .. arg_32_1)
		
		if get_cocos_refid(var_32_0) then
			var_32_0:setSelected(table.find(arg_32_0, arg_32_1) ~= nil)
		end
	end
	
	for iter_31_0, iter_31_1 in pairs({
		"k_",
		"g_",
		"e_",
		"t_"
	}) do
		for iter_31_2 = 1, 7 do
			local var_31_3 = iter_31_1 .. iter_31_2
			
			var_31_2(var_31_1, var_31_3)
			arg_31_0:_updateSelectButton(var_31_3)
		end
	end
	
	local var_31_4 = SAVE:getUserDefaultData("inven_autosell_set_filter", "all")
	local var_31_5 = SAVE:getUserDefaultData("inven_autosell_mainstat_filter", "all")
	local var_31_6 = SAVE:getUserDefaultData("inven_autosell_substat1_filter", "all")
	local var_31_7 = SAVE:getUserDefaultData("inven_autosell_substat2_filter", "all")
	local var_31_8 = {
		is_pet_inventory = true,
		set = var_31_4,
		mainstat = var_31_5,
		substat1 = var_31_6,
		substat2 = var_31_7
	}
	
	SorterExtentionUtil:initSetUI_opts(arg_31_0.vars, arg_31_0.vars.autoselect_dlg, var_31_8)
	SorterExtentionUtil:updateAllButtons(arg_31_0.vars.autoselect_dlg, {
		setOpt = arg_31_0:getSetOpt(),
		mainOpt = arg_31_0:getMainStatOpt(),
		substat1_opt = arg_31_0:getSubStat1_Opt(),
		substat2_opt = arg_31_0:getSubStat2_Opt()
	})
end

function BattleRepeatPopup.onClickEventExtentionFilter(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.autoselect_dlg) then
		return 
	end
	
	local var_33_0 = not string.find(arg_33_1, "done")
	
	if var_33_0 then
		arg_33_0:closeAll()
	end
	
	if arg_33_1 == "btn_set" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
		
		arg_33_0.vars.curset = "set"
	elseif arg_33_1 == "btn_set_done" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
	elseif arg_33_1 == "btn_mainstat" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
		
		arg_33_0.vars.curset = "mainstat"
	elseif arg_33_1 == "btn_mainstat_done" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
	elseif arg_33_1 == "btn_substat1" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
		
		arg_33_0.vars.curset = "substat1"
	elseif arg_33_1 == "btn_substat1_done" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
	elseif arg_33_1 == "btn_substat2" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
		
		arg_33_0.vars.curset = "substat2"
	elseif arg_33_1 == "btn_substat2_done" then
		arg_33_0:toggleOptsFilterBox(arg_33_1, var_33_0)
	elseif arg_33_1 == "btn_cancle" or arg_33_1 == "btn_toggle" then
		arg_33_0:closeAll()
	end
	
	if string.find(arg_33_1, "done") or arg_33_1 == "btn_cancle" then
		arg_33_0.vars.curset = nil
	end
	
	if string.find(arg_33_1, "btn_sort") then
		local var_33_1 = string.split(arg_33_1, "_")[3] or 1
		
		arg_33_0:setFilterOpt(arg_33_0.vars.autoselect_dlg, arg_33_0.vars.curset, tonumber(var_33_1))
	end
end

function BattleRepeatPopup.setFilterOpt(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if not get_cocos_refid(arg_34_1) then
		return 
	end
	
	if arg_34_2 == "set" then
		arg_34_0:setSetStatFilter(arg_34_3)
		SorterExtentionUtil:setFilterUI(arg_34_1:getChildByName("autosell_n_set_box"), arg_34_3, 17)
	elseif arg_34_2 == "mainstat" then
		arg_34_0:setMainStatFilter(arg_34_3)
		SorterExtentionUtil:setFilterUI(arg_34_1:getChildByName("autosell_n_mainstat_box"), arg_34_3, 12)
	elseif arg_34_2 == "substat1" then
		arg_34_0:setSubStatFilter(arg_34_3, 1)
		SorterExtentionUtil:setFilterUI(arg_34_1:getChildByName("autosell_n_substat_box"), arg_34_3, 12)
	elseif arg_34_2 == "substat2" then
		arg_34_0:setSubStatFilter(arg_34_3, 2)
		SorterExtentionUtil:setFilterUI(arg_34_1:getChildByName("autosell_n_substat_box"), arg_34_3, 12)
	end
	
	arg_34_0:closeAll()
end

function BattleRepeatPopup.toggleOptsFilterBox(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.vars.autoselect_dlg
	
	if arg_35_1 == "btn_set" or arg_35_1 == "btn_set_done" then
		if_set_visible(var_35_0, "autosell_n_set_box", arg_35_2)
		if_set_visible(var_35_0, "btn_set", not arg_35_2)
		if_set_visible(var_35_0, "btn_set_done", arg_35_2)
		
		if arg_35_2 then
			SorterExtentionUtil:set_itemSetCounts(arg_35_0.vars.n_set_box, arg_35_0.vars.items)
		end
	elseif arg_35_1 == "btn_mainstat" or arg_35_1 == "btn_mainstat_done" then
		if_set_visible(var_35_0, "autosell_n_mainstat_box", arg_35_2)
		if_set_visible(var_35_0, "btn_mainstat", not arg_35_2)
		if_set_visible(var_35_0, "btn_mainstat_done", arg_35_2)
	elseif arg_35_1 == "btn_substat1" or arg_35_1 == "btn_substat1_done" or arg_35_1 == "btn_substat2" or arg_35_1 == "btn_substat2_done" then
		if_set_visible(var_35_0, "autosell_n_substat_box", arg_35_2)
		
		if string.find(arg_35_1, "1") then
			if_set_visible(var_35_0, "btn_substat1", not arg_35_2)
			if_set_visible(var_35_0, "btn_substat1_done", arg_35_2)
		else
			if_set_visible(var_35_0, "btn_substat2", not arg_35_2)
			if_set_visible(var_35_0, "btn_substat2_done", arg_35_2)
		end
		
		if arg_35_2 then
			local var_35_1 = string.find(arg_35_1, "1") and 1 or 2
			
			arg_35_0:_setSubstatBox(var_35_0:getChildByName("autosell_n_substat_box"), var_35_1)
		end
	end
end

function BattleRepeatPopup._setSubstatBox(arg_36_0, arg_36_1, arg_36_2)
	if not get_cocos_refid(arg_36_1) or not arg_36_2 then
		return 
	end
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0.vars.substats) do
		if iter_36_1 == arg_36_0:getSubStatOpt(arg_36_2) then
			SorterExtentionUtil:setFilterUI(arg_36_1, iter_36_0, 12)
		end
	end
	
	arg_36_0:_moveSubstatBox(arg_36_1, arg_36_2)
end

function BattleRepeatPopup._moveSubstatBox(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_2 or not get_cocos_refid(arg_37_0.vars.autoselect_dlg) or not get_cocos_refid(arg_37_1) then
		return 
	end
	
	local var_37_0
	
	if arg_37_2 == 1 then
		var_37_0 = arg_37_0.vars.autoselect_dlg:getChildByName("n_filter_stat_box_sub")
	elseif arg_37_2 == 2 then
		if_set_visible(arg_37_0.vars.autoselect_dlg, "n_filter_stat_box_sub2", true)
		
		var_37_0 = arg_37_0.vars.autoselect_dlg:getChildByName("n_filter_stat_box_sub2")
	end
	
	if get_cocos_refid(var_37_0) then
		arg_37_1:ejectFromParent()
		var_37_0:addChild(arg_37_1)
	end
end

function BattleRepeatPopup.updateSelectButton(arg_38_0, arg_38_1)
	if arg_38_1 then
		arg_38_0:_updateSelectButton(arg_38_1)
	end
end

function BattleRepeatPopup._updateSelectButton(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.autoselect_dlg:getChildByName("checkbox_" .. arg_39_1)
	
	if not get_cocos_refid(var_39_0) then
		return 
	end
	
	local var_39_1 = var_39_0:getParent():getChildByName("label")
	
	if var_39_1 then
		var_39_1:setTextColor(var_39_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	end
	
	local var_39_2 = var_39_0:getParent():getChildByName("icon")
	
	if var_39_2 then
		var_39_2:setColor(var_39_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	end
	
	if_set_visible(var_39_0:getParent(), "select_" .. arg_39_1, var_39_0:isSelected())
end

function BattleRepeatPopup.closeAll(arg_40_0)
	local var_40_0 = arg_40_0.vars.autoselect_dlg
	local var_40_1 = false
	
	if_set_visible(var_40_0, "autosell_n_set_box", var_40_1)
	if_set_visible(var_40_0, "autosell_n_mainstat_box", var_40_1)
	if_set_visible(var_40_0, "autosell_n_substat_box", var_40_1)
	if_set_visible(var_40_0, "btn_set", not var_40_1)
	if_set_visible(var_40_0, "btn_mainstat", not var_40_1)
	if_set_visible(var_40_0, "btn_substat1", not var_40_1)
	if_set_visible(var_40_0, "btn_substat2", not var_40_1)
	if_set_visible(var_40_0, "btn_set_done", var_40_1)
	if_set_visible(var_40_0, "btn_mainstat_done", var_40_1)
	if_set_visible(var_40_0, "btn_substat1_done", var_40_1)
	if_set_visible(var_40_0, "btn_substat2_done", var_40_1)
	SorterExtentionUtil:updateAllButtons(var_40_0, {
		setOpt = arg_40_0:getSetOpt(),
		mainOpt = arg_40_0:getMainStatOpt(),
		substat1_opt = arg_40_0:getSubStat1_Opt(),
		substat2_opt = arg_40_0:getSubStat2_Opt()
	})
end

function BattleRepeatPopup.getSelectLists(arg_41_0)
	local function var_41_0(arg_42_0, arg_42_1)
		local var_42_0 = arg_42_0:getChildByName(arg_42_1)
		
		if var_42_0 then
			return var_42_0:isSelected()
		end
		
		return false
	end
	
	local var_41_1 = {
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_g_1"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_g_2"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_g_3"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_g_4"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_g_5")
	}
	local var_41_2 = {
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_1"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_2"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_3"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_4"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_5"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_6"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_t_7")
	}
	local var_41_3 = {
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_e_1"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_e_2"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_e_3"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_e_4")
	}
	local var_41_4 = {
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_k_1"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_k_2"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_k_3"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_k_4"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_k_5"),
		var_41_0(arg_41_0.vars.autoselect_dlg, "checkbox_k_6")
	}
	
	return var_41_1, var_41_2, var_41_3, var_41_4
end

function BattleRepeatPopup.sellItems(arg_43_0, arg_43_1)
	if not arg_43_1 or not BattleRepeat:canSellItems() or not arg_43_0.vars.sellmode then
		return 
	end
	
	local var_43_0 = BattleRepeatPopup:getSelectedItems() or {}
	local var_43_1 = {}
	
	if table.empty(var_43_0) then
		return 
	end
	
	if arg_43_1 == 1 then
		local var_43_2 = 0
		local var_43_3 = 0
		
		for iter_43_0, iter_43_1 in pairs(var_43_0) do
			if iter_43_1.isEquip and not iter_43_1.removed and not iter_43_1.can_not_sel then
				local var_43_4 = iter_43_1
				
				table.insert(var_43_1, var_43_4:getUID())
				
				if var_43_4:isArtifact() then
					var_43_3 = var_43_3 + calcArtifactSellPowder(var_43_4)
				else
					var_43_2 = var_43_2 + calcEquipSellPrice(var_43_4)
				end
			end
		end
		
		local var_43_5 = var_43_2 + (PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_43_2) or 0)
		
		GlobalGetSellDialog(var_43_5, var_43_3, var_43_1, "pet_bonus_items", function()
			BattleRepeat:refreshItems(var_43_1)
			BattleRepeat:sortPetRepeatItems()
			BattleRepeatPopup:refreshPopup()
		end):bringToFront()
	elseif arg_43_1 == 2 then
		for iter_43_2, iter_43_3 in pairs(var_43_0) do
			if iter_43_3.isEquip and iter_43_3:isExtractable() then
				table.insert(var_43_1, iter_43_3:getUID())
			end
		end
		
		Inventory:extractUtil(var_43_0, "pet_bonus_items", function()
			BattleRepeat:refreshItems(var_43_1)
			BattleRepeat:sortPetRepeatItems()
			BattleRepeatPopup:refreshPopup()
		end)
	end
end

function BattleRepeatPopup.refreshPopup(arg_46_0)
	arg_46_0.vars.items = BattleRepeat:getPetRepeatItems() or {}
	
	arg_46_0:initScrollView(arg_46_0.vars.itemListPopup:getChildByName("ScrollView"), 111, 111)
	arg_46_0:setScrollViewItems(arg_46_0.vars.items)
	arg_46_0:toggleSellMode(false)
end

function BattleRepeatPopup.getSelectedItems(arg_47_0)
	if not arg_47_0.vars or not arg_47_0.vars.selectedItems then
		return 
	end
	
	return arg_47_0.vars.selectedItems
end

function BattleRepeatPopup.resetSelectedItems(arg_48_0)
	if not arg_48_0.vars then
		return 
	end
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.selectedItems or {}) do
		arg_48_0:onSelectItemCard(iter_48_1)
	end
	
	arg_48_0.vars.selectedItems = {}
end

function BattleRepeatPopup.MSG_sell_equips(arg_49_0, arg_49_1)
	if arg_49_1.total_powder and arg_49_1.total_powder > 0 then
		balloon_message_with_sound("equip_sell_gold2", {
			price = comma_value(arg_49_1.total_price),
			price2 = comma_value(arg_49_1.total_powder)
		})
	else
		balloon_message_with_sound("equip_sell_gold", {
			price = comma_value(arg_49_1.total_price)
		})
	end
end

function BattleRepeatPopup.closeItemListPopup(arg_50_0)
	if not arg_50_0.vars or not get_cocos_refid(arg_50_0.vars.itemListPopup) then
		return 
	end
	
	Dialog:ForcedCloseMsgBoxByTag("pet_bonus_items")
	
	for iter_50_0, iter_50_1 in pairs(arg_50_0.vars.selectedItems or {}) do
		iter_50_1.select = false
	end
	
	BackButtonManager:pop(arg_50_0.vars.itemListPopup)
	arg_50_0.vars.itemListPopup:removeFromParent()
	
	arg_50_0.vars = {}
end
