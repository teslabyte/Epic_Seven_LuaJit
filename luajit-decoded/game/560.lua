Inventory = {}

local var_0_0 = {
	"Wearing",
	"Equip",
	"Artifact",
	"Etc",
	"Exclusive_Equip",
	"EquipMaterials"
}
local var_0_1 = {
	Wearing = 1,
	Equip = 2,
	EquipMaterials = 6,
	ExclusiveEquip = 5,
	Artifact = 3,
	Etc = 4
}

function MsgHandler.lock_equip(arg_1_0)
	Inventory:MSG_lock_equip(arg_1_0)
end

function MsgHandler.unlock_equip(arg_2_0)
	Inventory:MSG_unlock_equip(arg_2_0)
end

function MsgHandler.open_option_item(arg_3_0)
	if arg_3_0.rewards then
		local var_3_0 = {
			effect = true
		}
		
		if arg_3_0.rewards.new_units and table.count(arg_3_0.rewards.new_units) > 1 then
			var_3_0.play_reward_data = {
				title = T("read_mail")
			}
		elseif arg_3_0.rewards.new_equips and table.count(arg_3_0.rewards.new_equips) > 1 then
			var_3_0.effect = false
			var_3_0.rtn_equips = true
		else
			var_3_0.single = true
		end
		
		local var_3_1 = Account:addReward(arg_3_0.rewards, var_3_0) or {}
		
		Inventory:ResetItems()
		
		if var_3_1.new_equips and table.count(var_3_1.new_equips) > 1 then
			CraftMassPopup:openRewardMassPopup(var_3_1.new_equips, {
				layer = SceneManager:getRunningPopupScene()
			})
		end
	end
end

function MsgHandler.open_dual_select_item(arg_4_0)
	if arg_4_0.rewards then
		local var_4_0 = {
			effect = true
		}
		
		if arg_4_0.rewards.new_units and table.count(arg_4_0.rewards.new_units) > 1 then
			var_4_0.play_reward_data = {
				title = T("read_mail")
			}
		elseif arg_4_0.rewards.new_equips and table.count(arg_4_0.rewards.new_equips) > 1 then
			var_4_0.effect = false
			var_4_0.rtn_equips = true
		else
			var_4_0.single = true
		end
		
		local var_4_1 = Account:addReward(arg_4_0.rewards, var_4_0) or {}
		
		Inventory:ResetItems()
		
		if var_4_1.new_equips and table.count(var_4_1.new_equips) > 1 then
			CraftMassPopup:openRewardMassPopup(var_4_1.new_equips, {
				layer = SceneManager:getRunningPopupScene()
			})
		end
	end
end

function MsgHandler.open_expendable_item(arg_5_0)
	if arg_5_0.rewards then
		Account:addReward(arg_5_0.rewards, {
			single = true,
			effect = true
		})
		Inventory:ResetItems()
	end
end

function MsgHandler.sell_equips(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(arg_6_0.remove_list) do
		if arg_6_0.stored_item and tonumber(arg_6_0.stored_item) == 1 then
			Account:removeEquipStorage(tonumber(iter_6_1))
		else
			Account:removeEquip(tonumber(iter_6_1))
		end
	end
	
	Account:setCurrency("gold", arg_6_0.gold)
	
	if arg_6_0.powder then
		Account:setCurrency("powder", arg_6_0.powder)
	end
	
	if arg_6_0.rewards then
		Account:addReward(arg_6_0.rewards)
	end
	
	if string.starts(arg_6_0.caller, "inventory") then
		Inventory:MSG_sell_equips(arg_6_0)
		
		if EquipStorageManage.vars then
			EquipStorageManage:resetUI()
			EquipStorageManage:toggleSellMode(false)
		end
	end
	
	if string.starts(arg_6_0.caller, "result") then
		ClearResult:MSG_sell_equips(arg_6_0)
	end
	
	if arg_6_0.caller == "pet_bonus_items" then
		BattleRepeatPopup:MSG_sell_equips(arg_6_0)
	end
	
	if arg_6_0.caller == "get_item_popup" then
		arg_6_0.caller = "sell_equips"
		
		GetItemPopup:close(arg_6_0)
	end
	
	if arg_6_0.caller == "craft_result" then
		SanctuaryCraft:closeResultDlg()
		balloon_message_with_sound("equip_sell_gold", {
			price = comma_value(arg_6_0.total_price)
		})
	end
	
	if arg_6_0.caller == "alchemy_result" then
		AlchemistSelect:closeResultPopup()
		balloon_message_with_sound("equip_sell_gold", {
			price = comma_value(arg_6_0.total_price)
		})
	end
	
	if arg_6_0.caller == "sanctuary_craft_mass" then
		balloon_message_with_sound("equip_sell_gold", {
			price = comma_value(arg_6_0.total_price)
		})
	end
	
	if arg_6_0.caller == "burningEquipExtract" then
		SubstoryBurningShop:closeResultDlg()
		balloon_message_with_sound("equip_sell_gold", {
			price = comma_value(arg_6_0.total_price)
		})
	end
end

function MsgHandler.alchemist_point_extract(arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.remove_list) do
		if arg_7_0.stored_item and tonumber(arg_7_0.stored_item) == 1 then
			Account:removeEquipStorage(tonumber(iter_7_1))
		else
			Account:removeEquip(tonumber(iter_7_1))
		end
	end
	
	arg_7_0.isExtract = true
	
	if string.starts(arg_7_0.caller, "inventory") then
		Inventory:MSG_sell_equips(arg_7_0)
	end
	
	if arg_7_0.caller then
		if arg_7_0.caller == "inventory" then
			InventoryPopupDetail:updatePopupCaller()
			InventoryPopupDetail:Close()
			
			if EquipStorageManage.vars then
				EquipStorageManage:resetUI()
				EquipStorageManage:toggleSellMode(false)
			end
		elseif arg_7_0.caller == "craftItemPopup" then
			SanctuaryCraft:closeResultDlg()
		elseif arg_7_0.caller == "burningEquipExtract" then
			SubstoryBurningShop:closeResultDlg()
		end
	end
	
	local var_7_0 = arg_7_0.rewards.new_items
	local var_7_1 = {}
	
	for iter_7_2, iter_7_3 in pairs(var_7_0 or {}) do
		local var_7_2 = Account:getItemCount(iter_7_3.code) or 0
		local var_7_3 = iter_7_3.c - var_7_2
		
		table.insert(var_7_1, {
			code = iter_7_3.code,
			count = var_7_3
		})
	end
	
	Account:addReward(arg_7_0.rewards)
	balloon_message_with_sound("msg_extraction_success_desc")
end

function HANDLER_BEFORE.inventory(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == "btn_select" or string.starts(arg_8_1, "btn_item") then
		arg_8_0.touch_tick = systick()
	end
end

local function var_0_2(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0:getParent().unit
	local var_9_1 = UnitMain:isUsablePopupScene(SceneManager:getCurrentSceneName())
	local var_9_2 = not UnitMain:isValid() and var_9_1
	
	Inventory:close(var_9_2)
	
	if UnitMain:isValid() then
		if MusicBoxUI:isShow() then
			MusicBoxUI:close()
		end
		
		if arg_9_2 and UnitMain:getMode() == arg_9_1 then
			HeroBelt:getInst("UnitMain"):scrollToUnit(var_9_0, 0)
		else
			UnitMain:setMode(arg_9_1, {
				unit = var_9_0
			})
		end
	else
		local var_9_3 = {
			mode = arg_9_1,
			unit = var_9_0
		}
		
		if var_9_1 then
			UnitMain:beginPopupMode(var_9_3)
		else
			SceneManager:nextScene("unit_ui", var_9_3)
		end
	end
end

function HANDLER.inventory(arg_10_0, arg_10_1, arg_10_2)
	if string.starts(arg_10_1, "btn_main_tab") then
		Inventory:selectMainTab(to_n(string.sub(arg_10_1, -1, -1)))
	elseif string.starts(arg_10_1, "btn_equip_tab") then
		Inventory:selectSubTab(to_n(string.sub(arg_10_1, -1, -1)), arg_10_1)
	elseif string.starts(arg_10_1, "btn_private_tab") then
		Inventory:selectSubTab(to_n(string.sub(arg_10_1, -1, -1)), arg_10_1)
	elseif string.starts(arg_10_1, "btn_etc_tab") then
		Inventory:selectSubTab(to_n(string.sub(arg_10_1, -1, -1)), arg_10_1)
	elseif string.starts(arg_10_1, "btn_eq_ma_tab") then
		Inventory:selectSubTab(to_n(string.sub(arg_10_1, -1, -1)), arg_10_1)
		TutorialGuide:procGuide("system_126")
	elseif (string.starts(arg_10_1, "btn_sort") or arg_10_1 == "btn_cancel") and (Inventory:isUseSetFxFilterHandler() or Inventory:isUseSetFxSorterHandler() or Inventory:isUseGradeFxSorterHandler()) then
		if Inventory:isUseSetFxSorterHandler() then
			Inventory:getFilterStat():onHandler(arg_10_0, arg_10_1)
		elseif Inventory:isUseGradeFxSorterHandler() then
			Inventory:getFilterGrade():onHandler(arg_10_0, arg_10_1)
		else
			Inventory:getFilterSetFx():onHandler(arg_10_0, arg_10_1)
		end
	elseif arg_10_1 == "btn_count" then
		UIUtil:showIncEquipInvenDialog()
	elseif arg_10_1 == "btn_count_arti" then
		UIUtil:showIncArtiEquipInvenDialog()
	elseif arg_10_1 == "btn_close" then
		Inventory:close()
	elseif arg_10_1 == "btn_autoselect" then
		Inventory:toggleAutoselectMode()
	elseif arg_10_1 == "btn_delete_after" then
		local var_10_0 = arg_10_0:getParent():getName()
		
		if var_10_0 == "n_tab_sell_material" then
			if Inventory.vars.main_tab == var_0_1.EquipMaterials then
				Inventory.EquipMaterials:toggleSellMode()
			end
		elseif var_10_0 == "n_tab_sell_stuff" then
			if Inventory.vars.main_tab == var_0_1.Etc then
				Inventory.Etc:toggleSellMode()
			end
		elseif var_10_0 == "n_equip_menu" then
			TutorialGuide:procGuide("system_126")
			Inventory:toggleSellMode()
		end
	elseif arg_10_1 == "btn_delete" then
		local var_10_1 = arg_10_0:getParent():getName()
		
		if var_10_1 == "n_tab_sell_material" then
			if Inventory.vars.main_tab == var_0_1.EquipMaterials then
				Inventory.EquipMaterials:toggleSellMode()
			end
		elseif var_10_1 == "n_tab_sell_stuff" then
			if Inventory.vars.main_tab == var_0_1.Etc then
				Inventory.Etc:toggleSellMode()
			end
		elseif var_10_1 == "n_equip_menu" then
			TutorialGuide:procGuide("system_126")
			Inventory:toggleSellMode()
		end
	elseif arg_10_1 == "btn_sell" then
		local var_10_2 = arg_10_0:getParent():getName()
		
		if var_10_2 == "n_extract_mode" then
			if Inventory.vars.main_tab == var_0_1.EquipMaterials then
				Inventory.EquipMaterials:extract()
			end
		elseif var_10_2 == "n_sell_mode" then
			if Inventory.vars.main_tab == var_0_1.Etc then
				Inventory.Etc:sell()
			end
		elseif var_10_2 == "n_tab_sell" or var_10_2 == "n_tab_sell_equip" then
			Inventory:sell()
		end
	elseif arg_10_1 == "btn_extract" then
		Inventory:extract()
	elseif arg_10_1 == "btn_select" then
		local var_10_3 = arg_10_0:getParent().datasource
		
		if var_10_3 and systick() - to_n(arg_10_0.touch_tick) < 180 then
			Inventory:onSelect(var_10_3)
		end
	elseif arg_10_1 == "btn_unit_detail" then
		var_0_2(arg_10_0, "Detail", true)
	elseif string.starts(arg_10_1, "btn_item") then
		if systick() - to_n(arg_10_0.touch_tick) < 180 then
			local var_10_4 = arg_10_0:getParent().unit
			
			if var_10_4:isOrganizable() then
				local var_10_5 = tonumber(string.sub(arg_10_1, -1, -1))
				local var_10_6 = var_10_4:getEquipByIndex(var_10_5)
				
				if var_10_6 then
					if not var_10_6:isStone() then
						InventoryPopupDetail:Open(var_10_6, {
							layer = Inventory.vars.wnd
						})
					end
				else
					if var_10_5 == 8 then
						local var_10_7 = UnlockSystem:isUnlockSystem(UNLOCK_ID.TRIAL_HALL) or Account:isHaveExclusive()
						local var_10_8 = var_10_4:getZodiacGrade() >= 5
						local var_10_9 = UnitDetailEquip:isHaveExclusiveEquip(var_10_4)
						local var_10_10 = GrowthBoost:isRegisteredUnit(var_10_4)
						
						if var_10_10 and to_n(var_10_10.zodiac) >= 5 then
							var_10_8 = true
						end
						
						if not var_10_9 and var_10_8 and var_10_7 then
						elseif not var_10_8 and var_10_7 then
							Dialog:msgBox(T("system_118_equip_open"))
							
							return 
						elseif not var_10_7 then
							Dialog:msgBox(T("system_118_equip_msg"))
							
							return 
						end
						
						if not Account:canUseExclusive() then
							balloon_message_with_sound("ui_exclusive_open")
							
							return 
						end
						
						if var_10_6 then
							UnitExclusiveEquip:OpenPopup(Account:getUnit(var_10_6.parent), var_10_6:getEquipPositionIndex())
						else
							UnitExclusiveEquip:OpenPopup(var_10_4, var_10_5)
						end
						
						return 
					end
					
					if #UnitEquip:GetItems(var_10_4, EQUIP:getEquipPositionByIndex(var_10_5), {
						ignore_stone = true
					}) < 1 then
						balloon_message_with_sound("no_equips")
					elseif var_10_5 ~= 8 then
						UnitEquip:OpenPopup(var_10_4, var_10_5)
					end
				end
			end
		end
	elseif arg_10_1 == "btn_Help" then
		local var_10_11 = "infoinve1"
		
		HelpGuide:open({
			menu = var_10_11,
			parent = Inventory.vars.wnd
		})
	elseif arg_10_1 == "btn_equip" then
		var_0_2(arg_10_0, "Build")
	elseif arg_10_1 == "btn_set" or arg_10_1 == "btn_set_done" then
		Inventory:toggleEquipSetFilter()
	elseif arg_10_1 == "btn_mainstat" or arg_10_1 == "btn_mainstat_done" then
		Inventory:toggleEquipStatFilter()
	elseif arg_10_1 == "btn_grade" or arg_10_1 == "btn_grade_done" then
		Inventory:toggleGradeStatFilter()
	elseif arg_10_1 == "btn_selectall" then
		if Inventory.vars.main_tab == var_0_1.EquipMaterials then
			Inventory.EquipMaterials:selectAll()
		end
	elseif arg_10_1 == "btn_equip_storage" then
		SceneManager:nextScene("equip_storage", {
			start_mode = EquipStorageMode.Main
		})
	elseif arg_10_1 == "btn_check" and arg_10_0:getParent():getName() == "n_extract_mode" and Inventory.vars.main_tab == var_0_1.EquipMaterials then
		Inventory.EquipMaterials:toggleCountPopup(true)
	end
end

function HANDLER_BEFORE.inventory_autosel(arg_11_0, arg_11_1)
end

function HANDLER_CANCEL.inventory_autosel(arg_12_0, arg_12_1)
	if string.starts(arg_12_1, "checkbox_") then
		arg_12_0:setSelected(not arg_12_0:isSelected())
	end
end

function HANDLER.inventory_autosel(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_1 == "btn_close" then
		Inventory:autoSelect()
		
		return 
	end
	
	if string.starts(arg_13_1, "btn_checkbox_") then
		local var_13_0 = string.sub(arg_13_1, 14, -1)
		
		arg_13_1 = "checkbox_" .. var_13_0
		arg_13_0 = getParentWindow(arg_13_0):getChildByName(arg_13_1)
		
		arg_13_0:setSelected(not arg_13_0:isSelected())
	end
	
	if string.starts(arg_13_1, "checkbox_") then
		local var_13_1 = string.sub(arg_13_1, 10, -1)
		
		Inventory:updateSelectButton(var_13_1)
	end
	
	if arg_13_1 == "btn_set" or arg_13_1 == "btn_set_done" or arg_13_1 == "btn_mainstat" or arg_13_1 == "btn_mainstat_done" or arg_13_1 == "btn_substat1" or arg_13_1 == "btn_substat1_done" or arg_13_1 == "btn_substat2" or arg_13_1 == "btn_substat2_done" then
		Inventory:onClickEventExtentionFilter(arg_13_1)
	end
end

function HANDLER.inventory_artifact_autosel(arg_14_0, arg_14_1, arg_14_2)
	HANDLER.inventory_autosel(arg_14_0, arg_14_1, arg_14_2)
end

function HANDLER_BEFORE.inventory_autosel_all(arg_15_0, arg_15_1)
end

function HANDLER_CANCEL.inventory_autosel_all(arg_16_0, arg_16_1)
	if string.starts(arg_16_1, "checkbox_") then
		arg_16_0:setSelected(not arg_16_0:isSelected())
	end
end

local function var_0_3(arg_17_0, arg_17_1)
	if Inventory.vars and get_cocos_refid(Inventory.vars.wnd) then
		Inventory:autoSelect_func(arg_17_0, arg_17_1, "inventory")
	elseif BattleRepeatPopup.vars and get_cocos_refid(BattleRepeatPopup.vars.itemListPopup) then
		Inventory:autoSelect_func(arg_17_0, arg_17_1, "pet_inventory")
	end
end

function HANDLER.inventory_autosel_all(arg_18_0, arg_18_1, arg_18_2)
	var_0_3(arg_18_0, arg_18_1)
end

function HANDLER.inventory_artifact_autosel(arg_19_0, arg_19_1, arg_19_2)
	HANDLER.inventory_autosel_all(arg_19_0, arg_19_1, arg_19_2)
end

function HANDLER.autosell_n_set_box(arg_20_0, arg_20_1, arg_20_2)
	Inventory:onClickEventExtentionFilter(arg_20_1)
	BattleRepeatPopup:onClickEventExtentionFilter(arg_20_1)
	EquipStorageManage:onClickEventExtentionFilter(arg_20_1)
end

function HANDLER.autosell_n_mainstat_box(arg_21_0, arg_21_1, arg_21_2)
	Inventory:onClickEventExtentionFilter(arg_21_1)
	BattleRepeatPopup:onClickEventExtentionFilter(arg_21_1)
	EquipStorageManage:onClickEventExtentionFilter(arg_21_1)
end

function HANDLER.autosell_n_substat_box(arg_22_0, arg_22_1, arg_22_2)
	Inventory:onClickEventExtentionFilter(arg_22_1)
	BattleRepeatPopup:onClickEventExtentionFilter(arg_22_1)
	EquipStorageManage:onClickEventExtentionFilter(arg_22_1)
end

local function var_0_4(arg_23_0)
	if_set_visible(arg_23_0, "icon_new", true)
end

local function var_0_5(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0 and arg_24_0.parent
	local var_24_1 = Inventory[var_0_0[Inventory.vars.main_tab]].tab
	
	if Inventory.equipMaxUids[var_24_1] and arg_24_0:getUID() > Inventory.equipMaxUids[var_24_1] and not var_24_0 then
		var_0_4(arg_24_1)
	end
end

local function var_0_6(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0 and arg_25_0.parent
	
	if Inventory.equipMaxUids.artifact and arg_25_0:getUID() > Inventory.equipMaxUids.artifact and not var_25_0 then
		var_0_4(arg_25_1)
	end
end

local function var_0_7(arg_26_0, arg_26_1, arg_26_2)
	if_set_visible(arg_26_1, "n_select", Inventory:IsSelected(arg_26_2))
	if_set_visible(arg_26_1, "icon_equip", arg_26_2 and arg_26_2.parent)
	
	local var_26_0 = UIUtil:getRewardIcon("equip", arg_26_2.code, {
		tooltip_delay = 130,
		parent = arg_26_1:getChildByName("n_reward_icon"),
		equip = arg_26_2
	})
	local var_26_1 = arg_26_1:getChildByName("txt_main_stat")
	local var_26_2 = arg_26_1:getChildByName("icon_main")
	local var_26_3 = UnitEquipUtil:getOptionsSumTable(arg_26_2)
	local var_26_4 = {}
	
	for iter_26_0 = 1, table.count(var_26_3 or {}) do
		local var_26_5 = table.clone(var_26_3[iter_26_0])
		
		if UNIT.is_percentage_stat(var_26_5[1]) then
			var_26_5[2] = to_var_str(var_26_5[2], var_26_5[1])
		else
			var_26_5[2] = comma_value(math.floor(var_26_5[2]))
		end
		
		table.insert(var_26_4, var_26_5)
	end
	
	local var_26_6, var_26_7 = arg_26_2:getMainStat()
	local var_26_8 = false
	
	if UNIT.is_percentage_stat(var_26_7) then
		var_26_6 = to_var_str(var_26_6, var_26_7)
		
		local var_26_9 = true
	else
		var_26_6 = comma_value(math.floor(var_26_6))
	end
	
	if var_26_2 then
		SpriteCache:resetSprite(var_26_2, "img/cm_icon_stat_" .. string.gsub(var_26_7, "_rate", "") .. ".png")
	end
	
	if_set(var_26_1, nil, var_26_6)
	
	if Inventory.vars and Inventory.vars.sell_mode and Inventory:IsSelected(arg_26_2) and Account:isUnlockExtract() then
		if_set_visible(arg_26_1, "n_extract", not arg_26_2:isExtractable())
	else
		if_set_visible(arg_26_1, "n_extract", false)
	end
	
	for iter_26_1 = 1, 4 do
		if_set_visible(arg_26_1, "n_type" .. iter_26_1, var_26_4[iter_26_1])
		
		if var_26_4[iter_26_1] then
			SpriteCache:resetSprite(arg_26_1:getChildByName("icon_type" .. iter_26_1), "img/cm_icon_stat_" .. string.gsub(var_26_4[iter_26_1][1], "_rate", "") .. ".png")
			if_set(arg_26_1, "txt_stat" .. iter_26_1, var_26_4[iter_26_1][2])
		end
	end
	
	if Inventory.vars and Inventory.vars.sell_mode and (arg_26_2.parent or arg_26_2.lock) then
		if_set_cascade_color(var_26_0, nil, false)
		
		for iter_26_2, iter_26_3 in pairs(var_26_0:getChildren()) do
			if_set_color(iter_26_3, nil, cc.c3b(55, 55, 55))
		end
		
		if_set_color(var_26_0, "locked", cc.c3b(255, 255, 255))
		
		for iter_26_4, iter_26_5 in pairs(arg_26_1:getChildren()) do
			if_set_color(iter_26_5, nil, cc.c3b(55, 55, 55))
		end
		
		if_set_color(arg_26_1, "icon_equip", cc.c3b(255, 255, 255))
		if_set_color(arg_26_1, "icon_new", cc.c3b(255, 255, 255))
		var_0_5(arg_26_2, arg_26_1)
	elseif Inventory.vars ~= nil then
		var_0_5(arg_26_2, arg_26_1)
	end
	
	arg_26_1.datasource = arg_26_2
end

local function var_0_8(arg_27_0, arg_27_1)
	if arg_27_1 == "hexagon_shape" then
		if_set_visible(arg_27_0, "item_slot", false)
		if_set_visible(arg_27_0, "arti_slot", true)
		
		return 
	end
	
	if arg_27_1 == "round_shape" then
		if_set_visible(arg_27_0, "n_material", true)
		if_set_visible(arg_27_0, "material_slot", true)
		if_set_visible(arg_27_0, "piece_slot", false)
		if_set_visible(arg_27_0, "item_slot", false)
		
		return 
	end
	
	if arg_27_1 == "gem_shape" then
		if_set_visible(arg_27_0, "n_material", true)
		if_set_visible(arg_27_0, "material_slot", false)
		if_set_visible(arg_27_0, "piece_slot", true)
		if_set_visible(arg_27_0, "item_slot", false)
		
		return 
	end
end

function Inventory.isSellableFragment(arg_28_0, arg_28_1)
	local var_28_0, var_28_1, var_28_2 = DB("item_material", arg_28_1, {
		"ma_type",
		"ma_type2",
		"devotion_target"
	})
	
	if var_28_0 ~= "fragment" then
		return false
	end
	
	if var_28_1 ~= nil then
		return false
	end
	
	if not string.starts(var_28_2, "c") then
		return false
	end
	
	local var_28_3 = Account:getUnitsByVariationGroupCode(var_28_2)
	
	for iter_28_0, iter_28_1 in pairs(var_28_3) do
		if iter_28_1:isMaxDevoteLevel() then
			return true
		end
	end
	
	return false
end

function Inventory.isSellableItem(arg_29_0, arg_29_1)
	local var_29_0, var_29_1, var_29_2 = DB("item_material", arg_29_1, {
		"ma_type",
		"ma_type2",
		"devotion_target"
	})
	
	if var_29_0 == "xpup" then
		return true
	end
	
	if var_29_0 == "fragment" and var_29_1 == nil and string.starts(var_29_2, "c") then
		local var_29_3 = Account:getUnitsByVariationGroupCode(var_29_2)
		
		for iter_29_0, iter_29_1 in pairs(var_29_3) do
			if iter_29_1:isMaxDevoteLevel() then
				return true
			end
		end
	end
	
	return false
end

local function var_0_9(arg_30_0, arg_30_1, arg_30_2)
	if_set_visible(arg_30_1, "n_select", Inventory:IsSelected(arg_30_2))
	if_set_visible(arg_30_1, "icon_type", arg_30_2.isEquip ~= nil)
	if_set_visible(arg_30_1, "equip", arg_30_2 and arg_30_2.parent)
	if_set_visible(arg_30_1, "item_slot", true)
	if_set_visible(arg_30_1, "arti_slot", false)
	
	local var_30_0 = arg_30_1:getChildByName("bg_item")
	local var_30_1 = arg_30_1:getChildByName("txt_value")
	local var_30_2 = arg_30_1:getChildByName("n_txt_value")
	local var_30_3 = arg_30_1:getChildByName("n_img_value")
	local var_30_4 = arg_30_1:getChildByName("t_equip_point")
	
	if arg_30_2 and arg_30_2.code and arg_30_2.count and not arg_30_2.isEquip then
		local var_30_5, var_30_6, var_30_7 = DB("item_material", arg_30_2.code, {
			"ma_type",
			"ma_type2",
			"devotion_target"
		})
		local var_30_8 = {
			no_count = true,
			parent = var_30_0
		}
		
		if var_30_5 == "stone" and var_30_6 == "artifact" then
			var_0_8(arg_30_1, "hexagon_shape")
		elseif var_30_5 == "xpup" then
			var_0_8(arg_30_1, "round_shape")
		elseif var_30_5 == "fragment" and var_30_6 == "char" then
			var_0_8(arg_30_1, "gem_shape")
		elseif var_30_5 == "fragment" and var_30_6 ~= "char" then
			var_0_8(arg_30_1, "round_shape")
		end
		
		if Inventory.Etc.sell_mode then
			if_set_visible(arg_30_1, "n_select", Inventory.Etc:getSelectItem(arg_30_2.code))
			if_set_opacity(arg_30_1, nil, Inventory:isSellableItem(arg_30_2.code) and 255 or 76.5)
		elseif Inventory.EquipMaterials.sell_mode then
			if_set_visible(arg_30_1, "n_select", Inventory.EquipMaterials.selected[arg_30_2.code])
			if_set_opacity(arg_30_1, nil, 255)
		else
			if_set_visible(arg_30_1, "n_select", false)
			if_set_opacity(arg_30_1, nil, 255)
		end
		
		if var_30_5 == "special" or var_30_5 == "gradejump" or var_30_5 == "awakenjump" or var_30_5 == "multi_eq_select" then
			var_30_8.tooltip_delay = 130
		end
		
		local var_30_9 = string.find(arg_30_2.code, "ma_petpoint")
		
		if string.find(arg_30_2.code, "ma_petfood_e") or var_30_9 then
			var_30_8.isInventory = true
			
			if_set_visible(arg_30_1, "pet_slot", true)
			if_set_visible(arg_30_1, "item_slot", false)
			
			if var_30_9 then
				var_30_8.use_drop_icon = true
			end
		end
		
		local var_30_10 = UIUtil:getRewardIcon(arg_30_2.count, arg_30_2.code, var_30_8)
		local var_30_11 = Inventory.Etc:getSelectItem(arg_30_2.code) and Inventory.Etc.sell_mode
		local var_30_12 = Inventory.EquipMaterials.selected and Inventory.EquipMaterials.selected[arg_30_2.code] and Inventory.EquipMaterials.sell_mode
		
		if var_30_11 then
			local var_30_13 = Inventory.Etc:getSelectItemCount(arg_30_2.code)
			
			if_set(var_30_1, nil, comma_value(arg_30_2.count - var_30_13) .. "(-" .. comma_value(var_30_13) .. ")")
		elseif var_30_12 then
			local var_30_14 = Inventory.EquipMaterials.selected[arg_30_2.code].count
			
			if_set(var_30_1, nil, comma_value(arg_30_2.count - var_30_14) .. "(-" .. comma_value(var_30_14) .. ")")
		else
			if_set(var_30_1, nil, comma_value(arg_30_2.count))
		end
		
		local var_30_15 = var_30_11 or var_30_12
		
		if_set_color(arg_30_1:getChildByName("n_txt_value"), "txt_value", var_30_15 and tocolor("#6BC11B") or tocolor("#ffffff"))
		var_30_1:setAnchorPoint(0.5, 0.5)
		
		if var_30_5 == "xpup" then
			var_30_10:setPosition(var_30_10:getPositionX() + 1, 0)
		end
		
		var_30_2:setVisible(true)
		
		local var_30_16 = var_30_1:getContentSize().width
		
		if var_30_16 > 110 then
			var_30_2:setScaleX(110 / var_30_16)
		else
			var_30_2:setScaleX(1)
		end
		
		var_30_2:setVisible(true)
		var_30_3:setVisible(false)
	else
		var_30_3:setVisible(true)
		var_30_2:setVisible(false)
		
		if arg_30_2.isEquip then
			local var_30_17 = UIUtil:getRewardIcon("equip", arg_30_2.code, {
				tooltip_delay = 130,
				parent = var_30_0,
				equip = arg_30_2
			})
			local var_30_18, var_30_19 = arg_30_2:getMainStat()
			local var_30_20 = var_30_18 or 0
			local var_30_21 = false
			
			if UNIT.is_percentage_stat(var_30_19) then
				var_30_18 = to_var_str(var_30_18, var_30_19)
				var_30_21 = true
			else
				var_30_18 = comma_value(math.floor(var_30_18))
			end
			
			local var_30_22 = arg_30_1:getChildByName("icon_type")
			
			if arg_30_2:isStone() then
				var_30_22:setVisible(false)
				var_30_3:setVisible(false)
				var_30_2:setVisible(true)
				if_set(arg_30_1, "txt_value", T("equip_category_stone"))
			else
				local var_30_23 = Inventory:getShowEquipPointView()
				
				var_30_22:setVisible(not var_30_23)
				var_30_3:setVisible(not var_30_23)
				var_30_4:setVisible(var_30_23)
				
				if var_30_23 then
					local var_30_24 = arg_30_2:getEquipPoint()
					
					if_set(var_30_4, nil, var_30_24)
				else
					if var_30_22 then
						SpriteCache:resetSprite(var_30_22, "img/cm_icon_stat_" .. string.gsub(var_30_19, "_rate", "") .. ".png")
					end
					
					UIUtil:resetImageNumber(var_30_3, var_30_18)
					
					local var_30_25 = 0
					local var_30_26 = tonumber(var_30_20) or 0
					
					if var_30_21 then
						var_30_26 = var_30_20 * 100
					end
					
					if var_30_26 <= 999 and var_30_26 >= 100 or var_30_21 and var_30_26 >= 10 and var_30_26 <= 99 then
						var_30_25 = 3
					elseif var_30_26 <= 9999 and var_30_26 >= 1000 or var_30_21 and var_30_26 >= 100 and var_30_26 <= 999 then
						var_30_25 = 5
					elseif var_30_26 >= 10000 then
						var_30_25 = 8
					end
					
					if not var_30_22.originPosX or not var_30_3.originPosX then
						var_30_22.originPosX = var_30_22:getPositionX()
						var_30_3.originPosX = var_30_3:getPositionX()
					end
					
					var_30_22:setPositionX(var_30_22.originPosX - var_30_25)
					var_30_3:setPositionX(var_30_3.originPosX - var_30_25)
				end
				
				if Inventory.vars and Inventory.vars.sell_mode and Inventory:IsSelected(arg_30_2) and Account:isUnlockExtract() then
					if_set_visible(arg_30_1, "icon_dont", not arg_30_2:isExtractable())
				else
					if_set_visible(arg_30_1, "icon_dont", false)
				end
			end
			
			if Inventory.vars and Inventory.vars.sell_mode and (arg_30_2.parent or arg_30_2.lock) then
				if_set_cascade_color(var_30_17, nil, false)
				
				for iter_30_0, iter_30_1 in pairs(var_30_17:getChildren()) do
					if_set_color(iter_30_1, nil, cc.c3b(55, 55, 55))
				end
				
				if_set_color(var_30_17, "locked", cc.c3b(255, 255, 255))
				
				for iter_30_2, iter_30_3 in pairs(arg_30_1:getChildren()) do
					if_set_color(iter_30_3, nil, cc.c3b(55, 55, 55))
				end
				
				if_set_color(arg_30_1, "equip", cc.c3b(255, 255, 255))
				if_set_color(arg_30_1, "icon_new", cc.c3b(255, 255, 255))
				var_0_5(arg_30_2, arg_30_1)
			elseif Inventory.vars ~= nil then
				var_0_5(arg_30_2, arg_30_1)
			end
		end
	end
	
	arg_30_1.datasource = arg_30_2
end

function Inventory.autoSelect_func(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if not arg_31_2 then
		return 
	end
	
	if arg_31_3 == "pet_inventory" then
		arg_31_0 = BattleRepeatPopup
	end
	
	if arg_31_2 == "btn_close" then
		arg_31_0:autoSelect()
		
		if arg_31_3 == "pet_inventory" then
			arg_31_0:closeAutoSelect()
		end
	end
	
	if string.starts(arg_31_2, "btn_checkbox_") then
		local var_31_0 = string.sub(arg_31_2, 14, -1)
		
		arg_31_2 = "checkbox_" .. var_31_0
		arg_31_1 = getParentWindow(arg_31_1):getChildByName(arg_31_2)
		
		arg_31_1:setSelected(not arg_31_1:isSelected())
	end
	
	if string.starts(arg_31_2, "checkbox_") then
		local var_31_1 = string.sub(arg_31_2, 10, -1)
		
		arg_31_0:updateSelectButton(var_31_1)
	end
	
	if arg_31_2 == "btn_set" or arg_31_2 == "btn_set_done" or arg_31_2 == "btn_mainstat" or arg_31_2 == "btn_mainstat_done" or arg_31_2 == "btn_substat1" or arg_31_2 == "btn_substat1_done" or arg_31_2 == "btn_substat2" or arg_31_2 == "btn_substat2_done" then
		arg_31_0:onClickEventExtentionFilter(arg_31_2)
	end
end

function Inventory.setSorter(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if not arg_32_1 and not arg_32_0.vars.sorter_equip and not arg_32_2 then
		local var_32_0 = {
			{
				id = "hide_equipped",
				is_filter = true,
				name = T("sort_hide_equip"),
				checked = arg_32_0.vars.hideEquippedItem
			},
			{
				id = "hide_max_enhance_equip",
				is_filter = true,
				name = T("hide_max_upgrade_item"),
				checked = arg_32_0.vars.hideMaxEquipItem
			},
			{
				id = "show_detail",
				name = T("show_equip_detail"),
				checked = SAVE:getKeep("inventory_show_detail") or arg_32_0.vars.showEquipDetail
			},
			{
				id = "show_point",
				name = T("ui_equip_score_view"),
				checked = SAVE:getKeep("inventory_show_point") or arg_32_0.vars.showEquipPoint
			}
		}
		
		arg_32_0.vars.sorter_equip = Sorter:create(arg_32_0.vars.wnd:getChildByName("n_sorting"), {
			is_inventory_equip = true,
			useExtention = true
		})
		
		arg_32_0.vars.sorter_equip:setSorter({
			not_update_check_boxes = true,
			default_sort_index = Account:getConfigData("inven_equip_sort_index") or 3,
			menus = {
				{
					name = T("ui_inventory_sort_10"),
					func = EQUIP.greaterThanEnhance
				},
				{
					name = T("ui_inventory_sort_4"),
					func = EQUIP.greaterThanUID
				},
				{
					name = T("ui_inventory_sort_1"),
					func = EQUIP.greaterThanGrade
				},
				{
					name = T("ui_inventory_sort_8"),
					func = EQUIP.greaterThanStat
				},
				{
					name = T("ui_inventory_sort_2"),
					func = EQUIP.greaterThanItemLevel
				},
				{
					name = T("ui_inventory_sort_5"),
					func = EQUIP.greaterThanSet
				},
				{
					name = T("ui_equip_score"),
					func = EQUIP.greaterThanPoint
				}
			},
			checkboxs = var_32_0,
			callback_checkbox = function(arg_33_0, arg_33_1, arg_33_2)
				if arg_33_0 == "hide_equipped" then
					arg_32_0:setHideEquippedItems(arg_33_2)
					arg_32_0:ResetItems()
				elseif arg_33_0 == "show_detail" then
					arg_32_0:setShowEquipDetailView(arg_33_2)
					arg_32_0:toggleEquipView(arg_33_0)
					arg_32_0:initListView(arg_33_2 == true and "wnd/inventory_card2.csb" or nil)
					arg_32_0:ResetItems()
				elseif arg_33_0 == "hide_max_enhance_equip" then
					arg_32_0:setHideMaxEquipItems(arg_33_2)
					arg_32_0:ResetItems()
				elseif arg_33_0 == "show_point" then
					arg_32_0:setShowEquipPointView(arg_33_2)
					arg_32_0:toggleEquipView(arg_33_0)
					arg_32_0:initListView(nil)
					arg_32_0:ResetItems()
				end
			end,
			close_callback = function()
				local function var_34_0()
					for iter_35_0, iter_35_1 in pairs(arg_32_0.vars.selected) do
						local var_35_0 = false
						
						for iter_35_2, iter_35_3 in pairs(arg_32_0.vars.items) do
							if iter_35_0 == iter_35_3 then
								var_35_0 = true
								
								break
							end
						end
						
						if not var_35_0 and arg_32_0.vars.selected[iter_35_0] then
							arg_32_0.vars.selected[iter_35_0] = nil
						end
					end
					
					arg_32_0:updateSellInfo()
				end
				
				arg_32_0:ResetItems()
				
				if arg_32_0.vars and arg_32_0.vars.sell_mode then
				end
			end,
			callback_sort = function(arg_36_0, arg_36_1)
				if arg_36_0 ~= arg_36_1 then
					SAVE:setTempConfigData("inven_equip_sort_index", arg_36_1)
					arg_32_0:resetListView(true)
				end
			end
		})
	end
	
	if arg_32_1 and not arg_32_0.vars.sorter_artifact then
		arg_32_0.vars.hideLockArtifact = false
		arg_32_0.vars.hideMaxArtifact = false
		
		local var_32_1 = {
			{
				id = "hide_lock",
				is_filter = true,
				name = T("sort_hide_artifact"),
				checked = arg_32_0.vars.hideLockArtifact
			},
			{
				id = "hide_arti_max",
				is_filter = true,
				name = T("hide_max_upgrade_artifact"),
				checked = arg_32_0.vars.hideMaxArtifact
			}
		}
		
		arg_32_0.vars.sorter_artifact = Sorter:create(arg_32_0.vars.wnd:getChildByName("n_sorting"))
		
		arg_32_0.vars.sorter_artifact:setSorter({
			default_sort_index = Account:getConfigData("inven_artifact_sort_index") or 3,
			menus = {
				{
					name = T("ui_inventory_sort_10"),
					func = EQUIP.greaterThanEnhance
				},
				{
					name = T("ui_inventory_sort_4"),
					func = EQUIP.greaterThanUID
				},
				{
					name = T("ui_inventory_sort_1"),
					func = EQUIP.greaterThanGrade
				},
				{
					name = T("ui_inventory_sort_8"),
					func = EQUIP.greaterThanStat
				},
				{
					name = T("ui_inventory_sort_12"),
					func = EQUIP.greaterThanName
				}
			},
			checkboxs = var_32_1,
			callback_checkbox = function(arg_37_0, arg_37_1, arg_37_2)
				if arg_37_0 == "hide_lock" then
					arg_32_0:sethideArtifactLockItems(arg_37_2)
					arg_32_0:ResetItems()
				elseif arg_37_0 == "hide_arti_max" then
					arg_32_0:sethideMaxArtifactItems(arg_37_2)
					arg_32_0:ResetItems()
				end
			end,
			callback_sort = function(arg_38_0, arg_38_1)
				if arg_38_0 ~= arg_38_1 then
					SAVE:setTempConfigData("inven_artifact_sort_index", arg_38_1)
					arg_32_0:resetListView(true)
				end
			end
		})
	end
	
	if arg_32_2 and not arg_32_0.vars.sotrer_exclusive then
		arg_32_0.vars.sotrer_exclusive = Sorter:create(arg_32_0.vars.wnd:getChildByName("n_sorting"))
		
		arg_32_0.vars.sotrer_exclusive:setSorter({
			default_sort_index = Account:getConfigData("inven_exclusive_sort_index") or 3,
			menus = {
				{
					name = T("ui_inventory_sort_4"),
					func = EQUIP.greaterThanUID
				},
				{
					name = T("ui_inventory_sort_8"),
					func = EQUIP.greaterThanStat
				},
				{
					name = T("ui_inventory_sort_9"),
					func = EQUIP.greaterThanID
				}
			},
			callback_sort = function(arg_39_0, arg_39_1)
				if arg_39_0 ~= arg_39_1 then
					SAVE:setTempConfigData("inven_exclusive_sort_index", arg_39_1)
					arg_32_0:resetListView(true)
				end
			end
		})
	end
	
	if arg_32_3 and not arg_32_0.vars.sorter_wearing then
		local var_32_2 = {
			{
				id = "hide_all_equip",
				is_filter = true,
				name = T("sort_hide_allequip_hero"),
				checked = arg_32_0.vars.hide_all_equipped_units
			},
			{
				id = "hide_max_enhance",
				is_filter = true,
				name = T("sort_hide_maxhero"),
				checked = arg_32_0.vars.hide_max_units
			}
		}
		
		local function var_32_3(arg_40_0, arg_40_1)
			if not arg_40_0 or type(arg_40_0) ~= "number" then
				return arg_40_1
			end
			
			return arg_40_0
		end
		
		arg_32_0.vars.saved_sort_index = var_32_3(Account:getConfigData("inven_wearing_sort_index"), 6)
		arg_32_0.vars.saved_stat_index = var_32_3(Account:getConfigData("inven_wearing_stat_index"), 1)
		arg_32_0.vars.hide_max_units = false
		arg_32_0.vars.hide_all_equipped_units = false
		arg_32_0.vars.filter_un_hash_tbl = ItemFilterUtil:getDefaultUnHashTable()
		
		if arg_32_0.vars.filter_un_hash_tbl.role then
			arg_32_0.vars.filter_un_hash_tbl.role = nil
		end
		
		local function var_32_4(arg_41_0, arg_41_1, arg_41_2)
			local var_41_0 = arg_32_0.vars.filter_un_hash_tbl[arg_41_0][arg_41_1]
			
			arg_32_0.vars.filters[arg_41_0][var_41_0] = arg_41_2
		end
		
		arg_32_0.vars.filters = {
			star = {
				id = "star",
				check_list = ItemFilterUtil:getFilterCheckList(arg_32_0.vars.filter_un_hash_tbl, "star", nil)
			},
			element = {
				id = "element",
				check_list = ItemFilterUtil:getFilterCheckList(arg_32_0.vars.filter_un_hash_tbl, "element", nil)
			}
		}
		
		local function var_32_5(arg_42_0)
			for iter_42_0 = 1, 10 do
				local var_42_0 = arg_32_0.vars.filter_un_hash_tbl[arg_42_0][iter_42_0]
				
				if not var_42_0 then
					break
				end
				
				arg_32_0.vars.filters[arg_42_0][var_42_0] = true
			end
		end
		
		var_32_5("star")
		var_32_5("element")
		
		local var_32_6 = {
			btn_toggle_box = true,
			stat_menu_idx = 6,
			sorting_unit = true,
			inventory_wearing = true
		}
		
		arg_32_0.vars.sorter_wearing = Sorter:create(arg_32_0.vars.wnd:getChildByName("n_wear_sorting"), var_32_6)
		
		local var_32_7 = {
			{
				name = T("ui_unit_list_sort_1_label"),
				func = UnitSortOrder.greaterThanGrade
			},
			{
				name = T("ui_unit_list_sort_2_label"),
				func = UnitSortOrder.greaterThanLevel
			},
			{
				name = T("ui_unit_list_sort_3_label"),
				func = UnitSortOrder.greaterThanColor
			},
			{
				name = T("ui_unit_list_sort_7_label"),
				func = UnitSortOrder.greaterThanName
			},
			{
				name = T("ui_unit_list_sort_4_label"),
				func = UnitSortOrder.greaterThanUID
			},
			{
				key = "Stat",
				name = T("ui_unit_list_sort_stat_label"),
				func = UnitSortOrder.makeStatSortFuncSelector(arg_32_0.vars.sorter_wearing)
			}
		}
		
		arg_32_0.vars.sorter_wearing:setSorter({
			default_sort_index = arg_32_0.vars.saved_sort_index,
			default_stat_index = arg_32_0.vars.saved_stat_index,
			menus = var_32_7,
			checkboxs = var_32_2,
			filters = arg_32_0.vars.filters,
			close_callback = function()
				arg_32_0:ResetItems()
			end,
			callback_checkbox = function(arg_44_0, arg_44_1, arg_44_2)
				if arg_44_0 == "hide_all_equip" then
					arg_32_0:toggleHideAllEquippedItemUnit(arg_44_2)
					arg_32_0:ResetItems()
				elseif arg_44_0 == "hide_max_enhance" then
					arg_32_0:toggleHideMaxLevelUnits(arg_44_2)
					arg_32_0:ResetItems()
				end
			end,
			callback_sort = function(arg_45_0, arg_45_1)
				local var_45_0 = false
				
				if arg_32_0.vars.saved_sort_index ~= arg_45_1 then
					arg_32_0.vars.saved_sort_index = arg_45_1
					
					SAVE:setTempConfigData("inven_wearing_sort_index", arg_32_0.vars.saved_sort_index)
					
					var_45_0 = true
				end
				
				local var_45_1 = arg_32_0.vars.sorter:getLatestStatMenuIdx()
				
				if var_45_1 and arg_32_0.vars.saved_stat_index ~= var_45_1 then
					arg_32_0.vars.saved_stat_index = var_45_1
					
					SAVE:setTempConfigData("inven_wearing_stat_index", arg_32_0.vars.saved_stat_index)
					
					var_45_0 = true
				end
				
				if var_45_0 then
					arg_32_0:resetListView(true)
				end
			end,
			callback_on_add_filter = function(arg_46_0, arg_46_1, arg_46_2)
				var_32_4(arg_46_0, arg_46_1, arg_46_2)
			end,
			callback_on_commit_filter = function()
				arg_32_0:ResetItems()
			end,
			callback_filter = function(arg_48_0, arg_48_1, arg_48_2)
				arg_32_0:addFilter(arg_48_0, arg_48_1, arg_48_2)
				arg_32_0:ResetItems()
			end
		})
	end
	
	if arg_32_1 then
		arg_32_0.vars.sorter = arg_32_0.vars.sorter_artifact
		
		if arg_32_0.vars.sorter_equip then
			arg_32_0.vars.sorter_equip:setVisible(false)
		end
		
		if arg_32_0.vars.sotrer_exclusive then
			arg_32_0.vars.sotrer_exclusive:setVisible(false)
		end
		
		if arg_32_0.vars.sorter_wearing then
			arg_32_0.vars.sorter_wearing:setVisible(false)
		end
	elseif arg_32_2 then
		arg_32_0.vars.sorter = arg_32_0.vars.sotrer_exclusive
		
		if arg_32_0.vars.sorter_artifact then
			arg_32_0.vars.sorter_artifact:setVisible(false)
		end
		
		if arg_32_0.vars.sorter_equip then
			arg_32_0.vars.sorter_equip:setVisible(false)
		end
		
		if arg_32_0.vars.sorter_wearing then
			arg_32_0.vars.sorter_wearing:setVisible(false)
		end
	elseif arg_32_3 then
		arg_32_0.vars.sorter = arg_32_0.vars.sorter_wearing
		
		if arg_32_0.vars.sorter_artifact then
			arg_32_0.vars.sorter_artifact:setVisible(false)
		end
		
		if arg_32_0.vars.sorter_equip then
			arg_32_0.vars.sorter_equip:setVisible(false)
		end
	else
		if arg_32_0.vars.sorter_equip then
			arg_32_0.vars.sorter = arg_32_0.vars.sorter_equip
		end
		
		if arg_32_0.vars.sorter_artifact then
			arg_32_0.vars.sorter_artifact:setVisible(false)
		end
		
		if arg_32_0.vars.sotrer_exclusive then
			arg_32_0.vars.sotrer_exclusive:setVisible(false)
		end
		
		if arg_32_0.vars.sorter_wearing then
			arg_32_0.vars.sorter_wearing:setVisible(false)
		end
	end
	
	arg_32_0.vars.sorter:setVisible(true)
end

function Inventory.setFilterSetEffect(arg_49_0)
	local var_49_0 = arg_49_0.vars.wnd:findChildByName("n_3_menu")
	local var_49_1 = var_49_0:findChildByName("n_set_box")
	local var_49_2 = var_49_0:findChildByName("n_mainstat_box")
	local var_49_3 = var_49_0:findChildByName("n_grade_box")
	
	if not arg_49_0.vars.set_fx_filter or not arg_49_0.vars.stat_filter or not arg_49_0.vars.grade_filter then
		arg_49_0.vars.set_fx_filter = UnitEquipSetFilter:create(var_49_1)
		arg_49_0.vars.stat_filter = UnitEquipStatFilter:create(var_49_2)
		arg_49_0.vars.grade_filter = UnitEquipGradeFilter:create(var_49_3)
	end
end

function Inventory.getFilterSetFx(arg_50_0)
	return arg_50_0.vars.set_fx_filter
end

function Inventory.getFilterStat(arg_51_0)
	return arg_51_0.vars.stat_filter
end

function Inventory.getFilterGrade(arg_52_0)
	return arg_52_0.vars.grade_filter
end

function Inventory.isUseSetFxFilterHandler(arg_53_0)
	return arg_53_0.vars.main_tab == var_0_1.EquipMaterials and arg_53_0.vars.set_fx_filter and arg_53_0.vars.set_fx_filter:isOpen()
end

function Inventory.isUseSetFxSorterHandler(arg_54_0)
	return arg_54_0.vars.main_tab == var_0_1.EquipMaterials and arg_54_0.vars.stat_filter and arg_54_0.vars.stat_filter:isOpen()
end

function Inventory.isUseGradeFxSorterHandler(arg_55_0)
	return arg_55_0.vars.main_tab == var_0_1.EquipMaterials and arg_55_0.vars.grade_filter and arg_55_0.vars.grade_filter:isOpen()
end

function Inventory.toggleHideAllEquippedItemUnit(arg_56_0, arg_56_1)
	arg_56_0.vars.hide_all_equipped_units = arg_56_1
end

function Inventory.getHideAllEquippedItemUnit(arg_57_0)
	if not arg_57_0.vars then
		return 
	end
	
	return arg_57_0.vars.hide_all_equipped_units
end

function Inventory.toggleHideMaxLevelUnits(arg_58_0, arg_58_1)
	arg_58_0.vars.hide_max_units = arg_58_1
end

function Inventory.getHideMaxLevelUnits(arg_59_0)
	if not arg_59_0.vars then
		return 
	end
	
	return arg_59_0.vars.hide_max_units
end

function Inventory.sethideArtifactLockItems(arg_60_0, arg_60_1)
	if not arg_60_0.vars then
		return 
	end
	
	arg_60_0.vars.hideLockArtifact = arg_60_1
end

function Inventory.ishideArtifactLockItems(arg_61_0)
	if not arg_61_0.vars then
		return 
	end
	
	return arg_61_0.vars.hideLockArtifact or false
end

function Inventory.sethideMaxArtifactItems(arg_62_0, arg_62_1)
	if not arg_62_0.vars then
		return 
	end
	
	arg_62_0.vars.hideMaxArtifact = arg_62_1
end

function Inventory.ishideMaxArtifactItems(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	return arg_63_0.vars.hideMaxArtifact or false
end

function Inventory.setHideMaxEquipItems(arg_64_0, arg_64_1)
	if not arg_64_0.vars then
		return 
	end
	
	arg_64_0.vars.hideMaxEquipItem = arg_64_1
end

function Inventory.setHideEquippedItems(arg_65_0, arg_65_1)
	if not arg_65_0.vars then
		return 
	end
	
	arg_65_0.vars.hideEquippedItem = arg_65_1
end

function Inventory.setShowEquipDetailView(arg_66_0, arg_66_1)
	if not arg_66_0.vars then
		return 
	end
	
	arg_66_0.vars.showEquipDetail = arg_66_1
	
	SAVE:setKeep("inventory_show_detail", arg_66_1)
end

function Inventory.isHideEquippedItems(arg_67_0)
	if not arg_67_0.vars then
		return 
	end
	
	return arg_67_0.vars.hideEquippedItem or false
end

function Inventory.isHideMaxEquipItems(arg_68_0)
	if not arg_68_0.vars then
		return 
	end
	
	return arg_68_0.vars.hideMaxEquipItem or false
end

function Inventory.setShowEquipPointView(arg_69_0, arg_69_1)
	if not arg_69_0.vars then
		return 
	end
	
	arg_69_0.vars.showEquipPoint = arg_69_1
	
	SAVE:setKeep("inventory_show_point", arg_69_1)
end

function Inventory.getShowEquipPointView(arg_70_0)
	if not arg_70_0.vars then
		return false
	end
	
	return SAVE:getKeep("inventory_show_point") or arg_70_0.vars.showEquipPoint
end

function Inventory.toggleEquipView(arg_71_0, arg_71_1)
	if not arg_71_0.vars or not arg_71_1 then
		return 
	end
	
	local var_71_0 = {
		show_detail = {
			func_name = "setShowEquipPointView",
			toggle_id = "show_point",
			var_name = "showEquipPoint"
		},
		show_point = {
			func_name = "setShowEquipDetailView",
			toggle_id = "show_detail",
			var_name = "showEquipDetail"
		}
	}
	
	if var_71_0[arg_71_1] and var_71_0[arg_71_1].toggle_id and var_71_0[arg_71_1].var_name and var_71_0[arg_71_1].func_name then
		local var_71_1 = var_71_0[arg_71_1]
		local var_71_2
		
		if var_71_1.toggle_id == "show_detail" then
			var_71_2 = SAVE:getKeep("inventory_show_detail") or arg_71_0.vars[var_71_1.var_name]
		else
			var_71_2 = SAVE:getKeep("inventory_show_point") or arg_71_0.vars[var_71_1.var_name]
		end
		
		if var_71_2 then
			arg_71_0[var_71_1.func_name](arg_71_0, false)
			
			if arg_71_0.vars.sorter_equip then
				arg_71_0.vars.sorter_equip:setCheckBoxFlag(var_71_1.toggle_id, false)
			end
		end
	end
end

function Inventory.isShow(arg_72_0)
	return arg_72_0.vars and get_cocos_refid(arg_72_0.vars.wnd)
end

function Inventory.checkLastInventoryEnter(arg_73_0)
	arg_73_0.equipMaxUids = {}
	
	for iter_73_0 = 0, 6 do
		local var_73_0 = SAVE:get("equip_maxUid" .. iter_73_0)
		
		if var_73_0 ~= nil then
			arg_73_0.equipMaxUids[iter_73_0] = tonumber(var_73_0)
		else
			Log.e("ERROR : equip_maxUid" .. iter_73_0 .. " Can`t Found.")
		end
	end
	
	local var_73_1 = SAVE:get("equip_artifactMaxUid")
	
	arg_73_0.equipMaxUids.artifact = var_73_1 and tonumber(var_73_1) or Account:getMaxUidArtifact()
end

function Inventory.setNoticeBoxItem(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0.vars.wnd:findChildByName("n_main_tab")
	local var_74_1 = arg_74_0.vars.wnd:findChildByName("n_tab_sub4")
	
	if_set_visible(var_74_0, "icon_notice", arg_74_1)
	if_set_visible(var_74_1, "icon_notice", arg_74_1)
end

function Inventory.open(arg_75_0, arg_75_1, arg_75_2)
	arg_75_2 = arg_75_2 or {}
	
	TutorialGuide:procGuide("equip_install")
	
	if SceneManager:getCurrentSceneName() == "battle" then
		arg_75_2.is_allow_battle_open = arg_75_2.is_allow_battle_open or false
		
		if not arg_75_2.is_allow_battle_open then
			balloon_message_with_sound("cant_use_inventory_in_battle")
			
			return 
		end
	end
	
	if UnitEquip:isVisible() then
		return 
	end
	
	if DungeonHome:isVisible() then
		DungeonHome:close()
	end
	
	if arg_75_0.vars and get_cocos_refid(arg_75_0.vars.wnd) then
		return 
	end
	
	ShareChatPopup:close()
	
	arg_75_1 = arg_75_1 or SceneManager:getRunningPopupScene()
	arg_75_0.vars = {
		selected = {},
		opts = arg_75_2
	}
	arg_75_0.vars.wnd = load_dlg("inventory", true, "wnd", function()
		arg_75_0:close()
	end)
	
	arg_75_1:addChild(arg_75_0.vars.wnd)
	
	if not Account:canUseExclusive() then
		if_set_opacity(arg_75_0.vars.wnd, "n_tab5", 76.5)
	end
	
	if not Account:isUnlockTabEquipMaterials() then
		if_set_opacity(arg_75_0.vars.wnd, "n_tab6", 76.5)
	end
	
	UIUtil:slideOpen(arg_75_0.vars.wnd, arg_75_0.vars.wnd:getChildByName("n_content"), true)
	
	local var_75_0 = arg_75_2.main_tab or arg_75_0.last_main_tab or 2
	local var_75_1
	local var_75_2 = SAVE:getKeep("inventory_show_detail") and var_75_0 == 2
	
	arg_75_0:initListView(var_75_2 == true and "wnd/inventory_card2.csb" or nil)
	
	if arg_75_2.sell_mode then
		var_75_0 = 2
		var_75_1 = arg_75_2.equip_pos
	end
	
	arg_75_0:selectMainTab(var_75_0, var_75_1)
	
	if arg_75_0.vars.opts.sell_mode then
		arg_75_0:toggleSellMode(true)
	end
	
	arg_75_0:HelpbuttonPosition()
	
	local var_75_3 = arg_75_0.Etc:isSpecialItemListChange()
	
	arg_75_0:setNoticeBoxItem(var_75_3)
	
	if not var_75_3 then
		arg_75_0:setNoticeBoxItem(arg_75_0.Etc:isGradeJumpItemListChange() or arg_75_0.Etc:isAwakeJumpItemListChange())
	end
	
	if MusicBoxUI:isShow() then
		arg_75_0.vars.wnd:bringToFront()
	end
	
	SoundEngine:play("event:/ui/top_bar/inventory")
	GrowthGuideNavigator:proc()
	TutorialNotice:update("inventory")
	Analytics:setPopup("inventory")
end

local function var_0_10(arg_77_0, arg_77_1)
	if not arg_77_0 then
		return 
	end
	
	local var_77_0 = {}
	
	for iter_77_0, iter_77_1 in pairs(arg_77_0) do
		local var_77_1
		
		if arg_77_1 then
			var_77_1 = Account:getEquipFromStorage(iter_77_1)
		else
			var_77_1 = Account:getEquip(iter_77_1)
		end
		
		if var_77_1 and not var_77_1:isArtifact() then
			local var_77_2 = 0
			
			for iter_77_2 = 1, 99999 do
				local var_77_3, var_77_4, var_77_5, var_77_6 = DBN("item_equip_sell_enchant", iter_77_2, {
					"id",
					"grade",
					"level_min",
					"level_max"
				})
				
				if not var_77_3 then
					break
				end
				
				local var_77_7 = var_77_1.db.item_level
				
				if var_77_4 == var_77_1.grade and var_77_5 <= var_77_7 and var_77_7 <= var_77_6 then
					local var_77_8 = DB("item_equip_sell_enchant", var_77_3, {
						"enchant_" .. var_77_1:getEnhance()
					})
					
					if not var_77_8 then
						return 
					end
					
					local var_77_9 = tonumber(var_77_8)
					local var_77_10 = tonumber(var_77_1:getConsumeExp())
					
					var_77_2 = math.floor((var_77_10 - var_77_9) / 100)
					
					if var_77_2 < 0 then
						var_77_2 = 0
					end
				end
			end
			
			local var_77_11 = var_77_1.db.type
			local var_77_12 = string.sub(var_77_11, 1, 1)
			local var_77_13 = "ma_est1" .. var_77_12
			local var_77_14, var_77_15, var_77_16 = DB("item_material", var_77_13, {
				"id",
				"ma_type",
				"ma_type2"
			})
			
			if not var_77_14 or var_77_15 ~= "stone" or var_77_16 ~= var_77_11 then
				return 
			end
			
			local var_77_17 = false
			
			for iter_77_3, iter_77_4 in pairs(var_77_0) do
				if iter_77_4.id == var_77_14 and var_77_2 > 0 then
					iter_77_4.count = iter_77_4.count + var_77_2
					var_77_17 = true
					
					break
				end
			end
			
			if not var_77_17 and var_77_2 > 0 then
				table.insert(var_77_0, {
					id = var_77_14,
					count = var_77_2
				})
			end
		end
	end
	
	return var_77_0
end

function Inventory.getSellDialog(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5, arg_78_6, arg_78_7)
	if not arg_78_1 and not arg_78_2 or not arg_78_3 or not arg_78_4 then
		Log.e("Wrong Parameter.")
	end
	
	local var_78_0 = arg_78_5 and {
		arg_78_3
	} or arg_78_3
	local var_78_1 = load_dlg("msgbox_item_sel", true, "wnd")
	local var_78_2 = false
	local var_78_3
	
	if arg_78_2 and arg_78_2 > 0 then
		UIUtil:getRewardIcon(arg_78_1, "to_gold", {
			parent = var_78_1:getChildByName("reward_item1/2")
		})
		UIUtil:getRewardIcon(arg_78_2, "to_powder", {
			parent = var_78_1:getChildByName("reward_item2/2")
		})
	else
		var_78_3 = var_0_10(var_78_0, arg_78_6)
		
		if var_78_3 and not table.empty(var_78_3) then
			var_78_1 = load_dlg("msgbox_rewards_expand", true, "wnd")
			
			if_set(var_78_1, "txt_title", T("temp_inven_popup_title2"))
			
			var_78_3 = {
				{
					id = "to_gold",
					count = arg_78_1
				},
				table.unpack(var_78_3)
			}
			
			local var_78_4 = table.count(var_78_3)
			
			var_78_2 = var_78_4 > 5
			
			if_set_visible(var_78_1, "n_scrollview", false)
			if_set_visible(var_78_1, "n_item_node", not var_78_2)
			if_set_visible(var_78_1, "window_frame", not var_78_2)
			if_set_visible(var_78_1, "n_listview", var_78_2)
			if_set_visible(var_78_1, "window_frame_scroll", var_78_2)
			if_set_visible(var_78_1, "btn_ok", false)
			if_set_visible(var_78_1, "btn_cancel", false)
			if_set_visible(var_78_1, "btn_ok_blue", true)
			if_set_visible(var_78_1, "btn_confirm", false)
			
			if not var_78_2 then
				local var_78_5 = var_78_4 % 2 == 1
				
				if_set_visible(var_78_1, "n_odd", var_78_5)
				if_set_visible(var_78_1, "n_even", not var_78_5)
				if_set_visible(var_78_1, var_78_4, true)
				
				local var_78_6 = var_78_1:getChildByName(var_78_4)
				
				if get_cocos_refid(var_78_6) then
					for iter_78_0 = 1, var_78_4 do
						local var_78_7 = var_78_6:getChildByName("reward_item" .. iter_78_0)
						
						if not var_78_3[iter_78_0] or not get_cocos_refid(var_78_7) then
							break
						end
						
						local var_78_8 = var_78_3[iter_78_0]
						
						if var_78_8 then
							UIUtil:getRewardIcon(var_78_8.count, var_78_8.id, {
								show_count = true,
								tooltip_delay = 130,
								parent = var_78_7
							})
						end
					end
				end
				
				UIUtil:getRewardIcon(arg_78_1, "to_gold", {
					parent = var_78_1:getChildByName("reward_item1/2")
				})
			end
		else
			UIUtil:getRewardIcon(arg_78_1, "to_gold", {
				parent = var_78_1:getChildByName("reward_item1/1")
			})
		end
	end
	
	local var_78_9
	local var_78_10 = true
	
	if arg_78_4 and (arg_78_4 == "inventory" or arg_78_4 == "inventory_popup") then
		for iter_78_1, iter_78_2 in pairs(var_78_0) do
			local var_78_11 = Account:getEquip(iter_78_2)
			
			if var_78_11 and var_78_11.isArtifact and var_78_11:isArtifact() then
				if var_78_11.grade >= 4 then
					var_78_9 = var_78_9 or {}
					
					table.insert(var_78_9, var_78_11)
				end
				
				local var_78_12 = DB("equip_item", var_78_11.code, "limited")
				
				if var_78_10 and not var_78_12 then
					var_78_10 = false
				end
			end
		end
	end
	
	if var_78_2 and var_78_3 then
		local var_78_13 = var_78_1:getChildByName("n_top")
		
		if get_cocos_refid(var_78_13) then
			var_78_13:setPositionY(var_78_13:getPositionY() + 56)
		end
		
		local var_78_14 = var_78_1:getChildByName("n_bottom")
		
		if get_cocos_refid(var_78_14) then
			var_78_14:setPositionY(var_78_14:getPositionY() - 56)
		end
		
		local var_78_15 = table.count(var_78_3)
		local var_78_16 = var_78_1:getChildByName("listview")
		
		if var_78_15 > 5 and var_78_15 <= 10 then
			local var_78_17 = var_78_16:getContentSize()
			
			var_78_16:setContentSize(var_78_17.width, var_78_17.height - 20)
		end
		
		local var_78_18 = ItemListView:bindControl(var_78_16)
		local var_78_19 = {
			onUpdate = function(arg_79_0, arg_79_1, arg_79_2)
				arg_79_1:removeAllChildren()
				
				arg_79_1 = UIUtil:getRewardIcon(arg_79_2.count, arg_79_2.id, {
					tooltip_delay = 130,
					parent = arg_79_1
				})
				
				arg_79_1:setPosition(16, 10)
				arg_79_1:setAnchorPoint(0, 0)
			end
		}
		local var_78_20 = cc.Layer:create()
		
		var_78_20:setContentSize(105, 105)
		var_78_20:setCascadeOpacityEnabled(true)
		var_78_18:setListViewCascadeEnabled(true)
		var_78_18:setRenderer(var_78_20, var_78_19)
		var_78_18:setItems(var_78_3)
	end
	
	local var_78_21 = arg_78_4 or "msgbox_item_sel"
	
	if var_78_9 then
		local var_78_22 = var_78_10 and "confirm_high_grade_artifact_limited_sell" or "confirm_high_grade_artifact_sell"
		
		Dialog:msgBox(T("sell_equips", {
			count = #var_78_0
		}), {
			yesno = true,
			handler = function()
				local var_80_0 = Dialog:msgItems(var_78_9)
				local var_80_1 = Dialog:msgBox(T(var_78_22), {
					yesno = true,
					handler = function()
						query("sell_equips", {
							equips = array_to_json(var_78_0),
							caller = arg_78_4,
							stored_item = arg_78_6
						})
						
						if arg_78_7 then
							arg_78_7()
						end
					end,
					dlg = var_80_0,
					tag = var_78_21
				})
				
				if_set(var_80_1, "txt_title", T("sell_equips_name"))
			end,
			dlg = var_78_1,
			title = T("sell_equips_name")
		})
	else
		Dialog:msgBox(T("sell_equips", {
			count = #var_78_0
		}), {
			yesno = true,
			handler = function()
				query("sell_equips", {
					equips = array_to_json(var_78_0),
					caller = arg_78_4,
					stored_item = arg_78_6
				})
				
				if arg_78_7 then
					arg_78_7()
				end
			end,
			dlg = var_78_1,
			title = T("sell_equips_name"),
			tag = var_78_21
		})
	end
	
	return var_78_1
end

function GlobalGetSellDialog(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	local var_83_0
	
	return Inventory:getSellDialog(arg_83_0, arg_83_1, arg_83_2, arg_83_3, var_83_0, stored_item, arg_83_4)
end

local function var_0_11(arg_84_0)
	if not arg_84_0 or not arg_84_0.db then
		return 
	end
	
	for iter_84_0 = 1, 99999 do
		local var_84_0, var_84_1, var_84_2, var_84_3 = DBN("alchemy_equip_quality_enchant", iter_84_0, {
			"id",
			"grade",
			"level_min",
			"level_max"
		})
		
		if not var_84_0 then
			break
		end
		
		local var_84_4 = arg_84_0.db.item_level
		
		if var_84_1 == arg_84_0.grade and var_84_2 <= var_84_4 and var_84_4 <= var_84_3 then
			local var_84_5, var_84_6 = DB("alchemy_equip_quality_enchant", var_84_0, {
				"enchant_" .. arg_84_0:getEnhance(),
				"alchemy_bonus"
			})
			
			if not var_84_5 then
				return 
			end
			
			if string.starts(arg_84_0.code, "eal") then
				count = tonumber(var_84_5) + tonumber(var_84_6)
			else
				count = tonumber(var_84_5)
			end
		end
	end
	
	local var_84_7 = string.replace(arg_84_0.set_fx, "set_", "")
	local var_84_8 = "ma_" .. arg_84_0.db.type .. "_" .. var_84_7
	local var_84_9 = DB("item_material", var_84_8, {
		"id"
	})
	
	if not var_84_9 then
		return 
	end
	
	return var_84_9, count
end

function Inventory.getExtractDialog(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5)
	if not arg_85_1 or not arg_85_2 then
		Log.e("Wrong Parameter.")
	end
	
	if not Account:isUnlockExtract() then
		return 
	end
	
	local var_85_0 = arg_85_3 and {
		arg_85_1
	} or arg_85_1
	local var_85_1 = {}
	
	for iter_85_0, iter_85_1 in pairs(var_85_0) do
		if iter_85_1:isExtractable() then
			table.insert(var_85_1, iter_85_1)
		end
	end
	
	if table.empty(var_85_1) then
		balloon_message_with_sound("msg_extraction_level_error")
		
		return 
	end
	
	local var_85_2 = var_85_1
	local var_85_3 = load_dlg("msgbox_rewards_expand", true, "wnd")
	
	if get_cocos_refid(var_85_3) then
		if_set_visible(var_85_3, "n_scrollview", false)
		
		local var_85_4 = {}
		
		for iter_85_2, iter_85_3 in pairs(var_85_2) do
			local var_85_5, var_85_6 = var_0_11(iter_85_3)
			
			if not var_85_4[var_85_5] then
				var_85_4[var_85_5] = {
					mat_id = var_85_5,
					mat_count = var_85_6
				}
			else
				var_85_4[var_85_5].mat_count = var_85_4[var_85_5].mat_count + var_85_6
			end
		end
		
		local var_85_7 = table.count(var_85_4)
		
		if_set_visible(var_85_3, "n_item_node", var_85_7 <= 5)
		if_set_visible(var_85_3, "window_frame", var_85_7 <= 5)
		if_set_visible(var_85_3, "n_listview", not (var_85_7 <= 5))
		if_set_visible(var_85_3, "window_frame_scroll", not (var_85_7 <= 5))
		if_set_visible(var_85_3, "btn_ok", false)
		if_set_visible(var_85_3, "btn_cancel", false)
		
		if var_85_7 <= 5 then
			local var_85_8 = var_85_7 % 2 == 1
			
			if_set_visible(var_85_3, "n_odd", var_85_8)
			if_set_visible(var_85_3, "n_even", not var_85_8)
			if_set_visible(var_85_3, var_85_7, true)
			
			local var_85_9 = var_85_3:getChildByName(var_85_7)
			local var_85_10
			
			if get_cocos_refid(var_85_9) then
				var_85_10 = 1
				
				for iter_85_4, iter_85_5 in pairs(var_85_4) do
					local var_85_11 = var_85_9:getChildByName("reward_item" .. var_85_10)
					
					if not get_cocos_refid(var_85_11) then
						break
					end
					
					local var_85_12 = iter_85_5.mat_id
					local var_85_13 = iter_85_5.mat_count
					
					UIUtil:getRewardIcon(var_85_13, var_85_12, {
						tooltip_delay = 130,
						parent = var_85_11
					})
					
					var_85_10 = var_85_10 + 1
				end
			end
		else
			local var_85_14 = var_85_3:getChildByName("n_top")
			
			if get_cocos_refid(var_85_14) then
				var_85_14:setPositionY(var_85_14:getPositionY() + 56)
			end
			
			local var_85_15 = var_85_3:getChildByName("n_bottom")
			
			if get_cocos_refid(var_85_15) then
				var_85_15:setPositionY(var_85_15:getPositionY() - 56)
			end
			
			local var_85_16 = table.count(var_85_2)
			local var_85_17 = var_85_3:getChildByName("listview")
			
			if var_85_16 > 5 and var_85_16 <= 10 then
				local var_85_18 = var_85_17:getContentSize()
				
				var_85_17:setContentSize(var_85_18.width, var_85_18.height - 20)
			end
			
			local var_85_19 = ItemListView:bindControl(var_85_17)
			local var_85_20 = {
				onUpdate = function(arg_86_0, arg_86_1, arg_86_2)
					arg_86_1:removeAllChildren()
					
					local var_86_0 = arg_86_2.mat_id
					local var_86_1 = arg_86_2.mat_count
					
					arg_86_1 = UIUtil:getRewardIcon(var_86_1, var_86_0, {
						tooltip_delay = 130,
						parent = arg_86_1
					})
					
					arg_86_1:setPosition(16, 10)
					arg_86_1:setAnchorPoint(0, 0)
				end
			}
			local var_85_21 = cc.Layer:create()
			
			var_85_21:setContentSize(105, 105)
			var_85_21:setCascadeOpacityEnabled(true)
			var_85_19:setListViewCascadeEnabled(true)
			var_85_19:setRenderer(var_85_21, var_85_20)
			
			local var_85_22 = {}
			
			for iter_85_6, iter_85_7 in pairs(var_85_2) do
				local var_85_23, var_85_24 = var_0_11(iter_85_7)
				
				if not var_85_22[var_85_23] then
					var_85_22[var_85_23] = {
						mat_id = var_85_23,
						mat_count = var_85_24
					}
				else
					var_85_22[var_85_23].mat_count = var_85_22[var_85_23].mat_count + var_85_24
				end
			end
			
			var_85_19:setItems(var_85_22)
		end
		
		local var_85_25 = {}
		
		for iter_85_8, iter_85_9 in pairs(var_85_2) do
			table.push(var_85_25, iter_85_9.id)
		end
		
		local var_85_26 = "ui_extraction_popup_desc"
		
		if arg_85_2 and (arg_85_2 == "craftItemPopup" or arg_85_2 == "getItemPopup" or arg_85_2 == "equip_craft_mass" or var_85_7 == 1) then
			var_85_26 = "ui_extraction_popup_desc_2"
		end
		
		local var_85_27 = arg_85_2 or "msgbox_rewards_expand"
		
		if_set(var_85_3, "txt_title", T("ui_extraction_popup_title"))
		Dialog:msgBox(T(var_85_26), {
			yesno = true,
			handler = function()
				query("alchemist_point_extract", {
					equips = array_to_json(var_85_25),
					caller = arg_85_2,
					stored_item = arg_85_5
				})
				
				if arg_85_4 then
					arg_85_4()
				end
			end,
			dlg = var_85_3,
			title = T("ui_extraction_popup_title"),
			tag = var_85_27
		})
		
		local var_85_28 = var_85_3:getChildByName("btn_confirm")
		
		if get_cocos_refid(var_85_28) then
			if_set(var_85_28, "label", T("ui_extraction_popup_btn"))
		end
		
		var_85_3:bringToFront()
	end
end

function Inventory.getExtractResultDialog(arg_88_0, arg_88_1, arg_88_2)
	if not arg_88_1 or not arg_88_2 then
		return 
	end
	
	local var_88_0 = load_dlg("msgbox_rewards_expand", true, "wnd")
	
	if get_cocos_refid(var_88_0) then
		if_set_visible(var_88_0, "n_scrollview", false)
		
		local var_88_1 = table.count(arg_88_2)
		
		if_set_visible(var_88_0, "n_item_node", var_88_1 <= 5)
		if_set_visible(var_88_0, "window_frame", var_88_1 <= 5)
		if_set_visible(var_88_0, "n_listview", not (var_88_1 <= 5))
		if_set_visible(var_88_0, "window_frame_scroll", not (var_88_1 <= 5))
		if_set_visible(var_88_0, "btn_cancel", false)
		if_set_visible(var_88_0, "btn_confirm", false)
		
		local var_88_2 = ItemListView:bindControl(var_88_0:getChildByName("listview"))
		local var_88_3 = var_88_0:getChildByName("n_below")
		
		if var_88_1 <= 5 then
			local var_88_4 = var_88_1 % 2 == 1
			
			if_set_visible(var_88_0, "n_odd", var_88_4)
			if_set_visible(var_88_0, "n_even", not var_88_4)
			if_set_visible(var_88_0, var_88_1, true)
			
			local var_88_5 = var_88_0:getChildByName(var_88_1)
			
			if get_cocos_refid(var_88_5) then
				for iter_88_0 = 1, var_88_1 do
					local var_88_6 = var_88_5:getChildByName("reward_item" .. iter_88_0)
					
					if not arg_88_2[iter_88_0] or not get_cocos_refid(var_88_6) then
						break
					end
					
					local var_88_7 = arg_88_2[iter_88_0]
					local var_88_8 = UIUtil:getRewardIcon(var_88_7.count, var_88_7.code, {
						show_small_count = true,
						show_count = true,
						tooltip_delay = 130,
						parent = var_88_6
					}):getChildByName("txt_small_count")
					
					if get_cocos_refid(var_88_8) then
						var_88_8:setPositionY(var_88_8:getPositionY() - 12)
					end
				end
			end
			
			if get_cocos_refid(var_88_3) then
				var_88_3:setVisible(true)
				if_set_visible(var_88_3, "bar", true)
			end
		else
			local var_88_9 = var_88_0:getChildByName("n_top")
			
			if get_cocos_refid(var_88_9) then
				var_88_9:setPositionY(var_88_9:getPositionY() + 56)
			end
			
			local var_88_10 = var_88_0:getChildByName("n_bottom")
			
			if get_cocos_refid(var_88_10) then
				var_88_10:setPositionY(var_88_10:getPositionY() - 56)
			end
			
			if get_cocos_refid(var_88_3) then
				var_88_3:setVisible(true)
				var_88_3:setPositionY(var_88_3:getPositionY() - 56)
				if_set_visible(var_88_3, "bar", false)
			end
			
			local var_88_11 = {
				onUpdate = function(arg_89_0, arg_89_1, arg_89_2)
					arg_89_1:removeAllChildren()
					
					arg_89_1 = UIUtil:getRewardIcon(arg_89_2.count, arg_89_2.code, {
						show_small_count = true,
						show_count = true,
						tooltip_delay = 130,
						parent = arg_89_1
					})
					
					arg_89_1:setPosition(16, 25)
					arg_89_1:setAnchorPoint(0, 0)
					
					local var_89_0 = arg_89_1:getChildByName("txt_small_count")
					
					if get_cocos_refid(var_89_0) then
						var_89_0:setPositionY(var_89_0:getPositionY() - 20)
					end
				end
			}
			local var_88_12 = cc.Layer:create()
			
			var_88_12:setContentSize(105, 125)
			var_88_2:setRenderer(var_88_12, var_88_11)
			var_88_2:setItems(arg_88_2)
			var_88_2:setVisible(false)
		end
		
		if_set(var_88_0, "txt_title", T("ui_extraction_popup_title"))
		
		local var_88_13 = true
		
		if not var_88_13 then
			local var_88_14 = SceneManager:getRunningPopupScene()
			local var_88_15 = cc.c3b(0, 0, 0)
			local var_88_16 = cc.LayerColor:create(var_88_15)
			
			var_88_16:setContentSize(VIEW_WIDTH, VIEW_WIDTH)
			var_88_16:setPosition(VIEW_BASE_LEFT, 0)
			var_88_16:setLocalZOrder(99999)
			var_88_16:setOpacity(153)
			var_88_14:addChild(var_88_16)
			
			local var_88_17 = EffectManager:Play({
				z = 99999,
				fn = "ui_town_alchemy_npc_eff.cfx",
				layer = var_88_14,
				x = DESIGN_WIDTH / 2,
				y = DESIGN_HEIGHT / 2
			})
			
			Dialog:msgBox(T("ui_extraction_popup_success_desc"), {
				delay = 3200,
				dlg = var_88_0,
				title = T("ui_extraction_popup_title")
			})
			
			if var_88_1 > 5 then
				UIAction:Add(SEQ(DELAY(3200), SHOW(true)), var_88_2, "block")
			end
			
			UIAction:Add(SEQ(DELAY(3600), TARGET(var_88_17, REMOVE()), TARGET(var_88_16, REMOVE()), REMOVE()), var_88_16, "block")
		else
			if var_88_1 > 5 then
				var_88_2:setVisible(true)
			end
			
			Dialog:msgBox(T("ui_extraction_popup_success_desc"), {
				dlg = var_88_0,
				title = T("ui_extraction_popup_title")
			})
		end
		
		if_set_visible(var_88_0, "btn_ok", false)
		if_set_visible(var_88_0, "btn_close", true)
	end
end

function Inventory.isEtcTab(arg_90_0)
	return arg_90_0.vars.main_tab == var_0_1.Etc
end

function Inventory.isEquipTab(arg_91_0)
	return arg_91_0.vars.main_tab == var_0_1.Equip or arg_91_0.vars.main_tab == var_0_1.Artifact
end

function Inventory.isExclusiveTab(arg_92_0)
	return arg_92_0.vars.main_tab == var_0_1.ExclusiveEquip
end

function Inventory.PlayEquipSetEffect(arg_93_0, arg_93_1, arg_93_2)
	if not arg_93_0.vars then
		return 
	end
	
	if arg_93_0.vars.main_tab ~= var_0_1.Wearing then
		return 
	end
	
	local var_93_0 = arg_93_0.vars.listview:getControl(arg_93_1)
	
	if var_93_0 then
		UIUtil:playEquipSetEffect(var_93_0, arg_93_1, arg_93_2)
	end
end

function Inventory.ResetItems(arg_94_0, arg_94_1, arg_94_2)
	if not arg_94_0.vars then
		return 
	end
	
	if arg_94_0.vars and not get_cocos_refid(arg_94_0.vars.wnd) then
		return 
	end
	
	if not arg_94_1 then
		local var_94_0 = Inventory[var_0_0[arg_94_0.vars.main_tab]]
		
		if var_94_0 and var_94_0.selectItems then
			arg_94_0.vars.items = var_94_0:selectItems()
		else
			arg_94_0.vars.items = {}
		end
	end
	
	if arg_94_0.vars.main_tab == var_0_1.Equip and arg_94_0.vars.sorter_equip and not arg_94_1 then
		SorterExtentionUtil:set_itemSetCounts(arg_94_0.vars.sorter.sorter_extention:get_setBox(), arg_94_0.vars.items)
	end
	
	if arg_94_0.vars.main_tab == var_0_1.Equip or arg_94_0.vars.main_tab == var_0_1.Artifact or arg_94_0:isExclusiveTab() or arg_94_0.vars.main_tab == var_0_1.Wearing then
		arg_94_0.vars.sorter:setItems(arg_94_0.vars.items)
		
		arg_94_0.vars.items = arg_94_0.vars.sorter:sort()
		
		if arg_94_2 == nil then
			arg_94_2 = true
		end
	end
	
	if arg_94_0.vars.main_tab == var_0_1.EquipMaterials and arg_94_2 == nil then
		arg_94_2 = true
	end
	
	arg_94_0:updateItemInvenCount()
	arg_94_0:resetListView(arg_94_2)
	if_set_visible(arg_94_0.vars.wnd, "n_info", table.empty(arg_94_0.vars.items))
	
	local var_94_1 = arg_94_0.vars.wnd:getChildByName("n_info")
	
	if get_cocos_refid(var_94_1) then
		if arg_94_0.vars.main_tab == var_0_1.Wearing then
			if_set(var_94_1, "label", T("ui_unit_list_none"))
		else
			if_set(var_94_1, "label", T("ui_inventory_no_item"))
		end
	end
end

function Inventory.updateItemInvenCount(arg_95_0)
	if arg_95_0.vars and arg_95_0.vars.main_tab ~= var_0_1.Etc and get_cocos_refid(arg_95_0.vars.wnd) and arg_95_0.vars.items then
		if arg_95_0.vars.main_tab == var_0_1.Equip or arg_95_0.vars.main_tab == var_0_1.ExclusiveEquip then
			local var_95_0 = arg_95_0.vars.wnd:getChildByName("btn_count")
			
			if_set(var_95_0, "t_count", string.format("%d/%d", Account:getFreeEquipCount(), Account:getCurrentEquipCount()))
		elseif arg_95_0.vars.main_tab == var_0_1.Artifact then
			local var_95_1 = arg_95_0.vars.wnd:getChildByName("btn_count_arti")
			
			if_set(var_95_1, "t_count", string.format("%d/%d", Account:getFreeArtifactCount(), Account:getCurrentArtifactCount()))
		end
	end
end

function Inventory.getListViewFirstItem(arg_96_0)
	if not arg_96_0.vars or #arg_96_0.vars.items < 1 then
		return 
	end
	
	if not get_cocos_refid(arg_96_0.vars.wnd) then
		return 
	end
	
	return arg_96_0.vars.listview:getControl(arg_96_0.vars.items[1])
end

function Inventory.getListViewFirstSelectBoxItem(arg_97_0)
	if not arg_97_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_97_0.vars.wnd) then
		return 
	end
	
	for iter_97_0, iter_97_1 in pairs(arg_97_0.vars.items) do
		if iter_97_1.type == "special" then
			return arg_97_0.vars.listview:getControl(iter_97_1)
		end
	end
end

function Inventory.resetListView(arg_98_0, arg_98_1)
	if not arg_98_1 then
		arg_98_0.vars.listview:setItemsKeepPos(arg_98_0.vars.items)
	else
		arg_98_0.vars.listview:setItems(arg_98_0.vars.items)
	end
end

function Inventory.initListView(arg_99_0, arg_99_1)
	arg_99_0:initListViewNormal(arg_99_1)
	arg_99_0:initListViewArtifact()
	arg_99_0:initListViewWearing()
	arg_99_0:initListViewExclusive()
	arg_99_0:initListViewEquipMaterials()
end

function Inventory.initListViewNormal(arg_100_0, arg_100_1)
	arg_100_0.vars.listview_normal = ItemListView:bindControl(arg_100_0.vars.wnd:getChildByName("listview"))
	
	local var_100_0 = {
		onUpdate = arg_100_1 ~= nil and var_0_7 or var_0_9
	}
	
	arg_100_0.vars.listview_normal:setRenderer(load_control(arg_100_1 or "wnd/inventory_card.csb"), var_100_0)
end

function Inventory.initListViewEquipMaterials(arg_101_0)
	arg_101_0.vars.listview_eq_material = ItemListView:bindControl(arg_101_0.vars.wnd:getChildByName("listview_eq_material"))
	
	local var_101_0 = {
		onUpdate = var_0_9
	}
	
	arg_101_0.vars.listview_eq_material:setRenderer(load_control("wnd/inventory_card.csb"), var_101_0)
end

function Inventory.initListViewExclusive(arg_102_0)
	arg_102_0.vars.listview_exclusive = ItemListView:bindControl(arg_102_0.vars.wnd:getChildByName("listview_private"))
	
	local var_102_0 = {
		onUpdate = function(arg_103_0, arg_103_1, arg_103_2)
			UIUtil:updateEquipBar(arg_103_1, arg_103_2)
			
			local var_103_0 = arg_103_1:getChildByName("item_name")
			
			set_scale_fit_width(var_103_0, 215)
			
			local var_103_1 = arg_103_1:getChildByName("eq_selected")
			local var_103_2 = arg_103_1:getChildByName("icon_check")
			local var_103_3 = Inventory:IsSelected(arg_103_2)
			
			if var_103_1 and var_103_2 then
				var_103_1:setLocalZOrder(9999999)
				var_103_2:setLocalZOrder(10000000)
				if_set_visible(var_103_1, nil, var_103_3)
				if_set_visible(var_103_2, nil, var_103_3)
			end
			
			arg_103_1.datasource = arg_103_2
			
			local var_103_4 = arg_103_2.op[2][2]
			local var_103_5 = UNIT:create({
				code = arg_103_2.db.exclusive_unit
			})
			local var_103_6 = DB("skill_equip", arg_103_2.db.exclusive_skill .. "_0" .. var_103_4, {
				"exc_number"
			})
			local var_103_7 = UIUtil:getSkillIcon(var_103_5, var_103_6, {
				no_tooltip = true,
				show_exclusive_target = var_103_4
			})
			
			if_set_visible(var_103_7, "exclusive", true)
			if_set_visible(var_103_7, "soul1", false)
			arg_103_1:getChildByName("n_skill_icon1"):addChild(var_103_7)
			if_set(arg_103_1, "txt_skill_num", var_103_4)
			SpriteCache:resetSprite(arg_103_1:getChildByName("img_hero_l"), "face/" .. var_103_5.db.face_id .. "_l.png")
			if_set_visible(arg_103_1, "locked", arg_103_2.lock)
			if_set_visible(arg_103_1, "icon_new", false)
			if_set_visible(arg_103_1, "equip", arg_103_2.parent)
			
			local var_103_8 = UIUtil:isEquipRecallable(arg_103_2)
			
			if_set_visible(arg_103_1, "n_recall", var_103_8)
			
			local var_103_9 = 255
			
			if var_103_8 then
				var_103_9 = 127.5
			end
			
			if_set_opacity(arg_103_1, "bg", var_103_9)
			
			local var_103_10 = arg_103_1:getChildByName("item_name")
			
			if get_cocos_refid(var_103_10) then
				UIUserData:call(var_103_10, "MULTI_SCALE(2,50)")
			end
		end
	}
	local var_102_1 = load_control("wnd/private_bar.csb")
	
	var_102_1:setContentSize(332, 109)
	var_102_1:setAnchorPoint(0.6, 0.5)
	var_102_1:setPosition(166, 50)
	var_102_1:setScale(0.85)
	arg_102_0.vars.listview_exclusive:setRenderer(var_102_1, var_102_0)
end

function Inventory.initListViewArtifact(arg_104_0)
	arg_104_0.vars.listview_artifact = ItemListView:bindControl(arg_104_0.vars.wnd:getChildByName("listview_artifact"))
	
	local var_104_0 = {
		onUpdate = function(arg_105_0, arg_105_1, arg_105_2)
			UIUtil:updateEquipBar(arg_105_1, arg_105_2)
			
			local var_105_0 = arg_105_1:getChildByName("item_name")
			
			set_scale_fit_width(var_105_0, 215)
			
			local var_105_1 = arg_105_1:getChildByName("eq_selected")
			local var_105_2 = arg_105_1:getChildByName("icon_check")
			local var_105_3 = Inventory:IsSelected(arg_105_2)
			
			if var_105_1 and var_105_2 then
				var_105_1:setLocalZOrder(9999999)
				var_105_2:setLocalZOrder(10000000)
				if_set_visible(var_105_1, nil, var_105_3)
				if_set_visible(var_105_2, nil, var_105_3)
			end
			
			arg_105_1.datasource = arg_105_2
			
			if Inventory.vars and Inventory.vars.sell_mode and (arg_105_2.parent or arg_105_2.lock or arg_105_2:isForceLock()) then
				if_set_cascade_color(arg_105_1, "item_pos", false)
				if_set_color(arg_105_1, "n_root", cc.c3b(55, 55, 55))
				if_set_color(arg_105_1, nil, cc.c3b(55, 55, 55))
			end
			
			var_0_6(arg_105_2, arg_105_1)
		end
	}
	local var_104_1 = load_control("wnd/artifact_bar.csb")
	
	var_104_1:setContentSize(332, 129)
	var_104_1:setAnchorPoint(0.53, 0.5)
	var_104_1:setPosition(166, 65)
	var_104_1:setScale(0.92)
	arg_104_0.vars.listview_artifact:setRenderer(var_104_1, var_104_0)
	
	local var_104_2 = arg_104_0.vars.wnd:getChildByName("n_cost")
	
	if_set_sprite(var_104_2, "icon2", "item/token_powder.png")
end

function Inventory.initListViewWearing(arg_106_0)
	arg_106_0.vars.listview_wearing = ItemListView:bindControl(arg_106_0.vars.wnd:getChildByName("listview_unit"))
	
	local var_106_0 = {
		onUpdate = function(arg_107_0, arg_107_1, arg_107_2)
			if_set_sprite(arg_107_1, "face", "face/" .. arg_107_2.db.face_id .. "_s.png")
			UIUtil:setTextAndReturnHeight(arg_107_1:getChildByName("txt_unit_name"), T(arg_107_2.db.name))
			SpriteCache:resetSprite(arg_107_1:getChildByName("color"), UIUtil:getColorIcon(arg_107_2))
			UIUtil:setLevelDetail(arg_107_1:getChildByName("n_lv"), arg_107_2:getLv(), arg_107_2:getMaxLevel())
			
			local var_107_0 = UIUtil:getUserIcon(arg_107_2, {
				show_color = true,
				no_lv = true,
				scale = 1.5,
				parent = arg_107_1:getChildByName("n_face"),
				unit = arg_107_2
			})
			
			if_set_visible(var_107_0, "n_element", true)
			SpriteCache:resetSprite(var_107_0:getChildByName("icon_element"), UIUtil:getColorIcon(arg_107_2))
			
			for iter_107_0 = 1, 8 do
				local var_107_1 = arg_107_1:getChildByName("btn_item" .. iter_107_0)
				
				if var_107_1 == nil then
					break
				end
				
				local var_107_2 = arg_107_2:getEquipByIndex(iter_107_0)
				
				if not arg_107_2:isOrganizable() or not var_107_2 and #UnitEquip:GetItems(arg_107_2, EQUIP:getEquipPositionByIndex(iter_107_0), {
					ignore_equipped = true,
					ignore_stone = true,
					check_role = true
				}) < 1 then
					var_107_1:setOpacity(76.5)
				else
					var_107_1:setOpacity(255)
				end
			end
			
			local var_107_3 = {}
			
			for iter_107_1 = 1, 8 do
				local var_107_4 = arg_107_1:getChildByName("btn_item" .. iter_107_1)
				
				if var_107_4 == nil then
					break
				end
				
				var_107_3[iter_107_1] = var_107_4
				
				local var_107_5 = arg_107_2:getEquipByIndex(iter_107_1)
				local var_107_6 = var_107_4:getChildByName("n_item" .. iter_107_1)
				local var_107_7 = var_107_4:getChildByName("n_img_value")
				
				if var_107_7 then
					var_107_7:removeAllChildren()
				end
				
				var_107_6:removeAllChildren()
				
				if var_107_5 then
					UIUtil:getRewardIcon("equip", var_107_5.code, {
						scale = 1,
						tooltip_delay = 130,
						parent = var_107_6,
						equip = var_107_5
					})
					
					if var_107_7 then
						local var_107_8, var_107_9, var_107_10, var_107_11 = var_107_5:getMainStat()
						
						if UNIT.is_percentage_stat(var_107_9) then
							var_107_8 = to_var_str(var_107_8, var_107_9)
						else
							var_107_8 = comma_value(math.floor(var_107_8))
						end
						
						SpriteCache:resetSprite(var_107_4:getChildByName("icon_type"), "img/cm_icon_stat_" .. string.gsub(var_107_9, "_rate", "") .. ".png")
						UIUtil:resetImageNumber(var_107_7, var_107_8)
					end
				end
				
				if_set_visible(var_107_4, "icon", var_107_5 == nil)
				if_set_visible(var_107_4, "icon_type", var_107_5 ~= nil)
				if_set_visible(var_107_4, "n_img_value", var_107_5 ~= nil)
			end
			
			for iter_107_2, iter_107_3 in pairs(arg_107_2.equips) do
				local var_107_12 = iter_107_3:getEquipPositionIndex()
			end
			
			local var_107_13 = arg_107_1:getChildByName("btn_equip")
			
			if var_107_13 ~= nil and not arg_107_2:isOrganizable() then
				if_set_opacity(var_107_13, nil, 76.5)
				var_107_13:setTouchEnabled(false)
			end
			
			if_set_visible(var_107_13, nil, UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_MANAGER))
			if_set_visible(arg_107_1, "cm_icon_locked_private", false)
			
			if arg_107_2:isExclusiveEquip_exist() then
				if not arg_107_2:canEquip_Exclusive() or #UnitEquip:GetItems(arg_107_2, EQUIP:getEquipPositionByIndex(8)) <= 0 then
					if_set_opacity(arg_107_1, "btn_item8", 76.5)
				else
					if_set_opacity(arg_107_1, "btn_item8", 255)
				end
				
				if not Account:canUseExclusive() then
					if_set_visible(arg_107_1, "cm_icon_locked_private", true)
				end
			else
				if_set_visible(arg_107_1, "btn_item8", false)
			end
			
			arg_107_1.unit = arg_107_2
		end
	}
	local var_106_1 = load_control("wnd/inventory_wearing.csb")
	
	arg_106_0.vars.listview_wearing:setRenderer(var_106_1, var_106_0)
end

function Inventory.saveMaxUids(arg_108_0)
	if not arg_108_0.vars then
		return 
	end
	
	local var_108_0 = var_0_0[arg_108_0.vars.main_tab]
	
	if var_108_0 == "Equip" then
		arg_108_0.Equip:setCurrentMaxUid(arg_108_0.Equip.tab)
	elseif var_108_0 == "Artifact" then
		arg_108_0.Artifact:setCurrentMaxUid()
	end
	
	for iter_108_0 = 0, 6 do
		local var_108_1 = "equip_maxUid" .. iter_108_0
		
		SAVE:set(var_108_1, tostring(arg_108_0.equipMaxUids[iter_108_0]))
	end
	
	SAVE:set("equip_artifactMaxUid", arg_108_0.equipMaxUids.artifact)
end

function Inventory.close(arg_109_0, arg_109_1)
	if not arg_109_0.vars or not get_cocos_refid(arg_109_0.vars.wnd) then
		return 
	end
	
	local var_109_0 = BackButtonManager:getTopInfo()
	
	if var_109_0 then
		if var_109_0.dlg and var_109_0.dlg ~= arg_109_0.vars.wnd then
			return 
		end
		
		if var_109_0.id and var_109_0.id ~= "inventory" then
			return 
		end
	end
	
	arg_109_0:saveMaxUids()
	
	if arg_109_0.vars.sell_mode then
		arg_109_0:toggleSellMode(false)
		
		return 
	end
	
	if arg_109_0.vars.opts.onClose then
		arg_109_0.vars.opts.onClose()
	end
	
	if not arg_109_1 then
		UIUtil:slideOpen(arg_109_0.vars.wnd, arg_109_0.vars.wnd:getChildByName("n_content"), false)
	else
		arg_109_0.vars.wnd:removeFromParent()
	end
	
	BackButtonManager:pop({
		id = "Inventory",
		dlg = arg_109_0.vars.wnd
	})
	
	arg_109_0.vars = nil
	
	Analytics:closePopup()
	LuaEventDispatcher:dispatchEvent("formation.res", "inventory.update")
end

function Inventory.getSelectInfoKey(arg_110_0, arg_110_1)
	local var_110_0 = tonumber(Stove:getNickNameNo()) or 0
	local var_110_1 = Inventory[var_0_0[arg_110_1 or arg_110_0.vars.main_tab]]
	local var_110_2 = arg_110_1 or arg_110_0.vars.main_tab
	local var_110_3 = var_110_1.tab or "0"
	
	return string.format("autosell:%d_%d_%d", var_110_0, var_110_2, var_110_3)
end

function Inventory.getSelectInfoKey_v2(arg_111_0, arg_111_1)
	local var_111_0 = tonumber(Account:getUserId()) or 0
	local var_111_1 = Inventory[var_0_0[arg_111_1 or arg_111_0.vars.main_tab]]
	local var_111_2 = arg_111_1 or arg_111_0.vars.main_tab
	local var_111_3 = var_111_1.tab or "0"
	
	return string.format("autosell:%d_%d_%d", var_111_0, var_111_2, var_111_3)
end

function Inventory.autoSelect(arg_112_0)
	if not arg_112_0.vars.autoselect_mode then
		return 
	end
	
	local var_112_0, var_112_1, var_112_2, var_112_3 = arg_112_0:getSelectLists()
	local var_112_4 = {}
	
	local function var_112_5(arg_113_0, arg_113_1, arg_113_2)
		for iter_113_0, iter_113_1 in pairs(arg_113_2) do
			if iter_113_1 then
				table.insert(arg_113_0, arg_113_1 .. iter_113_0)
			end
		end
	end
	
	var_112_5(var_112_4, "g_", var_112_0)
	var_112_5(var_112_4, "t_", var_112_1)
	var_112_5(var_112_4, "e_", var_112_2)
	var_112_5(var_112_4, "k_", var_112_3)
	SAVE:setUserDefaultData(arg_112_0:getSelectInfoKey_v2(), json.encode(var_112_4))
	
	arg_112_0.vars.selected = {}
	
	local function var_112_6(arg_114_0, arg_114_1)
		local var_114_0 = true
		
		if not var_112_2[1] and arg_114_0 == 0 then
			var_114_0 = false
		elseif not var_112_2[2] and arg_114_0 >= 1 and arg_114_0 <= arg_114_1 then
			var_114_0 = false
		elseif not var_112_2[3] and arg_114_0 >= arg_114_1 + 1 and arg_114_0 <= arg_114_1 * 2 then
			var_114_0 = false
		elseif not var_112_2[4] and arg_114_0 >= arg_114_1 * 2 + 1 and arg_114_0 <= arg_114_1 * 3 then
			var_114_0 = false
		end
		
		return var_114_0
	end
	
	local function var_112_7(arg_115_0, arg_115_1)
		local var_115_0 = true
		
		if not var_112_2[1] and arg_115_0 == 0 then
			var_115_0 = false
		elseif not var_112_2[2] and arg_115_0 >= 1 and arg_115_0 <= 9 then
			var_115_0 = false
		elseif not var_112_2[3] and arg_115_0 >= 10 and arg_115_0 <= 12 then
			var_115_0 = false
		elseif not var_112_2[4] and arg_115_0 >= 13 and arg_115_0 <= 15 then
			var_115_0 = false
		end
		
		return var_115_0
	end
	
	local function var_112_8(arg_116_0, arg_116_1)
		if Inventory.Equip:getCurrentCategoryName() ~= nil then
			return true
		end
		
		local var_116_0 = true
		local var_116_1 = 0
		
		if arg_116_1 == "weapon" then
			var_116_1 = 1
		elseif arg_116_1 == "helm" then
			var_116_1 = 2
		elseif arg_116_1 == "armor" then
			var_116_1 = 3
		elseif arg_116_1 == "neck" then
			var_116_1 = 4
		elseif arg_116_1 == "ring" then
			var_116_1 = 5
		elseif arg_116_1 == "boot" then
			var_116_1 = 6
		end
		
		if arg_116_0[var_116_1] == false then
			var_116_0 = false
		end
		
		return var_116_0
	end
	
	for iter_112_0, iter_112_1 in pairs(arg_112_0.vars.items) do
		local var_112_9 = true
		local var_112_10 = iter_112_1.enhance or 0
		local var_112_11 = iter_112_1:isArtifact()
		local var_112_12
		
		if iter_112_1.db.item_level then
			local var_112_13 = iter_112_1.db.item_level
			
			if var_112_13 <= 28 then
				var_112_12 = 1
			elseif var_112_13 <= 42 then
				var_112_12 = 2
			elseif var_112_13 <= 57 then
				var_112_12 = 3
			elseif var_112_13 <= 71 then
				var_112_12 = 4
			elseif var_112_13 <= 84 then
				var_112_12 = 5
			elseif var_112_13 == 85 then
				var_112_12 = 6
			elseif var_112_13 >= 86 then
				var_112_12 = 7
			end
		else
			var_112_12 = iter_112_1.db.tier
		end
		
		var_112_8(var_112_3, iter_112_1.db.type)
		
		if iter_112_1:isStone() then
			var_112_9 = false
		elseif not iter_112_1:checkSell() then
			var_112_9 = false
		elseif not var_112_8(var_112_3, iter_112_1.db.type) then
			var_112_9 = false
		elseif not var_112_0[iter_112_1.grade] then
			var_112_9 = false
		elseif not var_112_1[var_112_12] and not var_112_11 then
			var_112_9 = false
		elseif var_112_9 then
			if var_112_11 then
				var_112_9 = var_112_6(var_112_10, 10)
			else
				var_112_9 = var_112_7(var_112_10)
			end
		end
		
		if arg_112_0.vars and arg_112_0.vars.optsFilter and arg_112_0.vars.main_tab == var_0_1.Equip and not arg_112_0.vars.sorter.sorter_extention:checkFilterOptions(iter_112_1, {
			set = arg_112_0.vars.optsFilter.set,
			mainstat = arg_112_0.vars.optsFilter.mainstat,
			substat1 = arg_112_0.vars.optsFilter.substat1,
			substat2 = arg_112_0.vars.optsFilter.substat2
		}) then
			var_112_9 = false
		end
		
		if var_112_9 then
			arg_112_0.vars.selected[iter_112_1] = true
		end
	end
	
	arg_112_0:updateCard()
	arg_112_0:updateSellInfo()
	arg_112_0:toggleAutoselectMode(false)
	
	if arg_112_0.vars.main_tab == var_0_1.Equip then
		arg_112_0:save_autoSelect_filterOpts()
	end
end

function Inventory.getSelectLists(arg_117_0)
	local function var_117_0(arg_118_0, arg_118_1)
		local var_118_0 = arg_118_0:getChildByName(arg_118_1)
		
		if var_118_0 then
			return var_118_0:isSelected()
		end
		
		return false
	end
	
	local var_117_1 = {
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_g_1"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_g_2"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_g_3"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_g_4"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_g_5")
	}
	local var_117_2 = {
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_1"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_2"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_3"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_4"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_5"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_6"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_t_7")
	}
	local var_117_3 = {
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_e_1"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_e_2"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_e_3"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_e_4")
	}
	local var_117_4 = {
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_k_1"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_k_2"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_k_3"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_k_4"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_k_5"),
		var_117_0(arg_117_0.vars.autoselect_dlg, "checkbox_k_6")
	}
	
	return var_117_1, var_117_2, var_117_3, var_117_4
end

function Inventory.initAutoSell(arg_119_0)
	local var_119_0 = SAVE:getUserDefaultData(arg_119_0:getSelectInfoKey_v2(), "empty")
	
	if var_119_0 == "empty" then
		var_119_0 = SAVE:getUserDefaultData(arg_119_0:getSelectInfoKey(), "[\"g_1\",\"g_2\",\"t_1\",\"t_2\",\"e_1\"]")
	end
	
	local var_119_1 = json.decode(var_119_0)
	
	local function var_119_2(arg_120_0, arg_120_1)
		if not arg_120_1 then
			return 
		end
		
		local var_120_0 = arg_119_0.vars.autoselect_dlg:getChildByName("checkbox_" .. arg_120_1)
		
		if get_cocos_refid(var_120_0) then
			var_120_0:setSelected(table.find(arg_120_0, arg_120_1) ~= nil)
			var_120_0:setTouchEnabled(false)
		end
	end
	
	for iter_119_0, iter_119_1 in pairs({
		"k_",
		"g_",
		"e_",
		"t_"
	}) do
		for iter_119_2 = 1, 7 do
			local var_119_3 = iter_119_1 .. iter_119_2
			
			var_119_2(var_119_1, var_119_3)
			arg_119_0:_updateSelectButton(var_119_3)
		end
	end
	
	if arg_119_0.vars.main_tab == var_0_1.Equip then
		local var_119_4 = SAVE:getUserDefaultData("inven_autosell_set_filter", "all")
		local var_119_5 = SAVE:getUserDefaultData("inven_autosell_mainstat_filter", "all")
		local var_119_6 = SAVE:getUserDefaultData("inven_autosell_substat1_filter", "all")
		local var_119_7 = SAVE:getUserDefaultData("inven_autosell_substat2_filter", "all")
		local var_119_8 = {
			set = var_119_4,
			mainstat = var_119_5,
			substat1 = var_119_6,
			substat2 = var_119_7
		}
		
		arg_119_0.vars.optsFilter = {}
		
		SorterExtentionUtil:initSetUI_opts(arg_119_0.vars.optsFilter, arg_119_0.vars.autoselect_dlg, var_119_8)
		SorterExtentionUtil:updateAllButtons(arg_119_0.vars.autoselect_dlg, {
			setOpt = arg_119_0:getSetOpt(),
			mainOpt = arg_119_0:getMainStatOpt(),
			substat1_opt = arg_119_0:getSubStat1_Opt(),
			substat2_opt = arg_119_0:getSubStat2_Opt()
		})
	end
end

function Inventory.save_autoSelect_filterOpts(arg_121_0)
	if not arg_121_0.vars or not arg_121_0.vars.optsFilter then
		return 
	end
	
	SAVE:setUserDefaultData("inven_autosell_set_filter", arg_121_0.vars.optsFilter.set or "all")
	SAVE:setUserDefaultData("inven_autosell_mainstat_filter", arg_121_0.vars.optsFilter.mainstat or "all")
	SAVE:setUserDefaultData("inven_autosell_substat1_filter", arg_121_0.vars.optsFilter.substat1 or "all")
	SAVE:setUserDefaultData("inven_autosell_substat2_filter", arg_121_0.vars.optsFilter.substat2 or "all")
end

function Inventory.onClickEventExtentionFilter(arg_122_0, arg_122_1)
	if not arg_122_0.vars or not get_cocos_refid(arg_122_0.vars.autoselect_dlg) or arg_122_0.vars.main_tab ~= var_0_1.Equip then
		return 
	end
	
	local var_122_0 = not string.find(arg_122_1, "done")
	
	if var_122_0 then
		arg_122_0:closeAll()
	end
	
	if arg_122_1 == "btn_set" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
		
		arg_122_0.vars.optsFilter.curset = "set"
	elseif arg_122_1 == "btn_set_done" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
	elseif arg_122_1 == "btn_mainstat" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
		
		arg_122_0.vars.optsFilter.curset = "mainstat"
	elseif arg_122_1 == "btn_mainstat_done" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
	elseif arg_122_1 == "btn_substat1" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
		
		arg_122_0.vars.optsFilter.curset = "substat1"
	elseif arg_122_1 == "btn_substat1_done" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
	elseif arg_122_1 == "btn_substat2" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
		
		arg_122_0.vars.optsFilter.curset = "substat2"
	elseif arg_122_1 == "btn_substat2_done" then
		arg_122_0:toggleOptsFilterBox(arg_122_1, var_122_0)
	elseif arg_122_1 == "btn_cancle" or arg_122_1 == "btn_toggle" then
		arg_122_0:closeAll()
	end
	
	if string.find(arg_122_1, "done") or arg_122_1 == "btn_cancle" then
		arg_122_0.vars.optsFilter.curset = nil
	end
	
	if string.find(arg_122_1, "btn_sort") then
		local var_122_1 = string.split(arg_122_1, "_")[3] or 1
		
		arg_122_0:setFilterOpt(arg_122_0.vars.autoselect_dlg, arg_122_0.vars.optsFilter.curset, tonumber(var_122_1))
	end
end

function Inventory.reset_allFilterOpts(arg_123_0)
	if not arg_123_0.vars or not get_cocos_refid(arg_123_0.vars.autoselect_dlg) or arg_123_0.vars.main_tab ~= var_0_1.Equip then
		return 
	end
	
	local var_123_0 = 1
	
	arg_123_0:setSetStatFilter(var_123_0)
	SorterExtentionUtil:setFilterUI(arg_123_0.vars.autoselect_dlg:getChildByName("autosell_n_set_box"), var_123_0, 17)
	arg_123_0:setMainStatFilter(var_123_0)
	SorterExtentionUtil:setFilterUI(arg_123_0.vars.autoselect_dlg:getChildByName("autosell_n_mainstat_box"), var_123_0, 12)
	arg_123_0:setSubStatFilter(var_123_0, 1)
	SorterExtentionUtil:setFilterUI(arg_123_0.vars.autoselect_dlg:getChildByName("autosell_n_substat_box"), var_123_0, 12)
	arg_123_0:setSubStatFilter(var_123_0, 2)
	SorterExtentionUtil:setFilterUI(arg_123_0.vars.autoselect_dlg:getChildByName("autosell_n_substat_box"), var_123_0, 12)
	arg_123_0:closeAll()
end

function Inventory.setFilterOpt(arg_124_0, arg_124_1, arg_124_2, arg_124_3)
	if not get_cocos_refid(arg_124_1) then
		return 
	end
	
	if arg_124_2 == "set" then
		arg_124_0:setSetStatFilter(arg_124_3)
		SorterExtentionUtil:setFilterUI(arg_124_1:getChildByName("autosell_n_set_box"), arg_124_3, 17)
	elseif arg_124_2 == "mainstat" then
		arg_124_0:setMainStatFilter(arg_124_3)
		SorterExtentionUtil:setFilterUI(arg_124_1:getChildByName("autosell_n_mainstat_box"), arg_124_3, 12)
	elseif arg_124_2 == "substat1" then
		arg_124_0:setSubStatFilter(arg_124_3, 1)
		SorterExtentionUtil:setFilterUI(arg_124_1:getChildByName("autosell_n_substat_box"), arg_124_3, 12)
	elseif arg_124_2 == "substat2" then
		arg_124_0:setSubStatFilter(arg_124_3, 2)
		SorterExtentionUtil:setFilterUI(arg_124_1:getChildByName("autosell_n_substat_box"), arg_124_3, 12)
	end
	
	arg_124_0:closeAll()
end

function Inventory.toggleOptsFilterBox(arg_125_0, arg_125_1, arg_125_2)
	local var_125_0 = arg_125_0.vars.autoselect_dlg
	
	if arg_125_1 == "btn_set" or arg_125_1 == "btn_set_done" then
		if_set_visible(var_125_0, "autosell_n_set_box", arg_125_2)
		if_set_visible(var_125_0, "btn_set", not arg_125_2)
		if_set_visible(var_125_0, "btn_set_done", arg_125_2)
		
		if arg_125_2 then
			SorterExtentionUtil:set_itemSetCounts(arg_125_0.vars.optsFilter.n_set_box, arg_125_0.vars.items)
		end
	elseif arg_125_1 == "btn_mainstat" or arg_125_1 == "btn_mainstat_done" then
		if_set_visible(var_125_0, "autosell_n_mainstat_box", arg_125_2)
		if_set_visible(var_125_0, "btn_mainstat", not arg_125_2)
		if_set_visible(var_125_0, "btn_mainstat_done", arg_125_2)
	elseif arg_125_1 == "btn_substat1" or arg_125_1 == "btn_substat1_done" or arg_125_1 == "btn_substat2" or arg_125_1 == "btn_substat2_done" then
		if_set_visible(var_125_0, "autosell_n_substat_box", arg_125_2)
		
		if string.find(arg_125_1, "1") then
			if_set_visible(var_125_0, "btn_substat1", not arg_125_2)
			if_set_visible(var_125_0, "btn_substat1_done", arg_125_2)
		else
			if_set_visible(var_125_0, "btn_substat2", not arg_125_2)
			if_set_visible(var_125_0, "btn_substat2_done", arg_125_2)
		end
		
		if arg_125_2 then
			local var_125_1 = string.find(arg_125_1, "1") and 1 or 2
			
			arg_125_0:_setSubstatBox(var_125_0:getChildByName("autosell_n_substat_box"), var_125_1)
		end
	end
end

function Inventory._setSubstatBox(arg_126_0, arg_126_1, arg_126_2)
	if not get_cocos_refid(arg_126_1) or not arg_126_2 then
		return 
	end
	
	for iter_126_0, iter_126_1 in pairs(arg_126_0.vars.optsFilter.substats) do
		if iter_126_1 == arg_126_0:getSubStatOpt(arg_126_2) then
			SorterExtentionUtil:setFilterUI(arg_126_1, iter_126_0, 12)
		end
	end
	
	arg_126_0:_moveSubstatBox(arg_126_1, arg_126_2)
end

function Inventory._moveSubstatBox(arg_127_0, arg_127_1, arg_127_2)
	if not arg_127_2 or not get_cocos_refid(arg_127_0.vars.autoselect_dlg) or not get_cocos_refid(arg_127_1) then
		return 
	end
	
	local var_127_0
	
	if arg_127_2 == 1 then
		var_127_0 = arg_127_0.vars.autoselect_dlg:getChildByName("n_filter_stat_box_sub")
	elseif arg_127_2 == 2 then
		if_set_visible(arg_127_0.vars.autoselect_dlg, "n_filter_stat_box_sub2", true)
		
		var_127_0 = arg_127_0.vars.autoselect_dlg:getChildByName("n_filter_stat_box_sub2")
	end
	
	if get_cocos_refid(var_127_0) then
		arg_127_1:ejectFromParent()
		var_127_0:addChild(arg_127_1)
	end
end

function Inventory.setSetStatFilter(arg_128_0, arg_128_1)
	if not arg_128_1 then
		return 
	end
	
	local var_128_0 = arg_128_0.vars.optsFilter.sets[arg_128_1]
	
	if not var_128_0 then
		return 
	end
	
	arg_128_0.vars.optsFilter.set = var_128_0
end

function Inventory.setMainStatFilter(arg_129_0, arg_129_1)
	if not arg_129_1 then
		return 
	end
	
	local var_129_0 = arg_129_0.vars.optsFilter.mainstats[arg_129_1]
	
	if not var_129_0 then
		return 
	end
	
	arg_129_0.vars.optsFilter.mainstat = var_129_0
end

function Inventory.setSubStatFilter(arg_130_0, arg_130_1, arg_130_2)
	if not arg_130_1 or not arg_130_2 then
		return 
	end
	
	local var_130_0 = arg_130_2 or 1 or 2
	local var_130_1 = arg_130_0.vars.optsFilter.substats[arg_130_1]
	
	if not var_130_1 then
		return 
	end
	
	if var_130_0 == 1 then
		arg_130_0.vars.optsFilter.substat1 = var_130_1
	else
		arg_130_0.vars.optsFilter.substat2 = var_130_1
	end
end

function Inventory.getSubStatOpt(arg_131_0, arg_131_1)
	if not arg_131_1 then
		return 
	end
	
	if arg_131_1 == 1 then
		return arg_131_0.vars.optsFilter.substat1
	else
		return arg_131_0.vars.optsFilter.substat2
	end
end

function Inventory.closeAll(arg_132_0)
	local var_132_0 = arg_132_0.vars.autoselect_dlg
	local var_132_1 = false
	
	if_set_visible(var_132_0, "autosell_n_set_box", var_132_1)
	if_set_visible(var_132_0, "autosell_n_mainstat_box", var_132_1)
	if_set_visible(var_132_0, "autosell_n_substat_box", var_132_1)
	if_set_visible(var_132_0, "btn_set", not var_132_1)
	if_set_visible(var_132_0, "btn_mainstat", not var_132_1)
	if_set_visible(var_132_0, "btn_substat1", not var_132_1)
	if_set_visible(var_132_0, "btn_substat2", not var_132_1)
	if_set_visible(var_132_0, "btn_set_done", var_132_1)
	if_set_visible(var_132_0, "btn_mainstat_done", var_132_1)
	if_set_visible(var_132_0, "btn_substat1_done", var_132_1)
	if_set_visible(var_132_0, "btn_substat2_done", var_132_1)
	SorterExtentionUtil:updateAllButtons(var_132_0, {
		setOpt = arg_132_0:getSetOpt(),
		mainOpt = arg_132_0:getMainStatOpt(),
		substat1_opt = arg_132_0:getSubStat1_Opt(),
		substat2_opt = arg_132_0:getSubStat2_Opt()
	})
end

function Inventory.getSetOpt(arg_133_0)
	return arg_133_0.vars.optsFilter.set or false
end

function Inventory.getMainStatOpt(arg_134_0)
	return arg_134_0.vars.optsFilter.mainstat or false
end

function Inventory.getSubStat1_Opt(arg_135_0)
	return arg_135_0.vars.optsFilter.substat1 or false
end

function Inventory.getSubStat2_Opt(arg_136_0)
	return arg_136_0.vars.optsFilter.substat2 or false
end

function Inventory._updateSelectButton(arg_137_0, arg_137_1)
	if not arg_137_1 then
		return 
	end
	
	local var_137_0 = arg_137_0.vars.autoselect_dlg:getChildByName("checkbox_" .. arg_137_1)
	
	if not get_cocos_refid(var_137_0) then
		return 
	end
	
	local var_137_1 = var_137_0:getParent():getChildByName("label")
	
	if var_137_1 then
		var_137_1:setTextColor(var_137_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	end
	
	local var_137_2 = var_137_0:getParent():getChildByName("icon")
	
	if var_137_2 then
		var_137_2:setColor(var_137_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	end
	
	if_set_visible(var_137_0:getParent(), "select_" .. arg_137_1, var_137_0:isSelected())
end

function Inventory.updateSelectButton(arg_138_0, arg_138_1)
	if not arg_138_0.vars.autoselect_mode then
		return 
	end
	
	if arg_138_1 then
		arg_138_0:_updateSelectButton(arg_138_1)
	end
end

function Inventory.toggleAutoselectMode(arg_139_0, arg_139_1)
	if arg_139_1 ~= nil then
		arg_139_0.vars.autoselect_mode = arg_139_1
	else
		arg_139_0.vars.autoselect_mode = not arg_139_0.vars.autoselect_mode
	end
	
	if not arg_139_0.vars.autoselect_mode then
		arg_139_0.vars.autoselect_dlg:removeFromParent()
		
		arg_139_0.vars.autoselect_dlg = nil
		
		BackButtonManager:pop()
	else
		arg_139_0.vars.autoselect_dlg = nil
		
		if arg_139_0.vars.main_tab == var_0_1.Equip then
			if Inventory.Equip:getCurrentCategoryName() == nil then
				arg_139_0.vars.autoselect_dlg = load_dlg("inventory_autosel_all", true, "wnd")
			else
				arg_139_0.vars.autoselect_dlg = load_dlg("inventory_autosel", true, "wnd")
			end
		elseif arg_139_0.vars.main_tab == var_0_1.Artifact then
			arg_139_0.vars.autoselect_dlg = load_dlg("inventory_artifact_autosel", true, "wnd")
		else
			return 
		end
		
		arg_139_0.vars.wnd:addChild(arg_139_0.vars.autoselect_dlg)
		arg_139_0:initAutoSell()
		BackButtonManager:push({
			check_id = "Inventory_autosel",
			back_func = function()
				arg_139_0:toggleAutoselectMode(false)
			end
		})
	end
end

function MsgHandler.sell_items(arg_141_0)
	Account:addReward(arg_141_0.use_rewards)
	Account:addReward(arg_141_0.rewards)
	
	for iter_141_0, iter_141_1 in pairs(arg_141_0.p_units_deleted or {}) do
		Account:removeUnit(iter_141_1)
	end
	
	if Inventory.vars and Inventory.vars.wnd then
		Inventory:ResetItems(nil, false)
	end
	
	Inventory.Etc:toggleSellMode(false)
	
	if UnitLevelUp and UnitLevelUp.vars and get_cocos_refid(UnitLevelUp.vars.wnd) then
		UnitLevelUp.vars.selected_penguin = {}
		
		UnitLevelUp:request_update_exp()
	end
	
	balloon_message_with_sound("penguin_sell_complete")
end

function Inventory.toggleSellMode(arg_142_0, arg_142_1, arg_142_2)
	if arg_142_0.vars.sell_mode ~= nil and arg_142_0.vars.sell_mode == arg_142_1 then
		return 
	end
	
	if not arg_142_0.vars or not get_cocos_refid(arg_142_0.vars.wnd) then
		return 
	end
	
	if arg_142_1 ~= nil then
		arg_142_0.vars.sell_mode = arg_142_1
	else
		arg_142_0.vars.sell_mode = not arg_142_0.vars.sell_mode
	end
	
	if_set_visible(arg_142_0.vars.wnd, "n_tab_sell", arg_142_0.vars.sell_mode == true)
	if_set_visible(arg_142_0.vars.wnd, "n_tab_sell_equip", false)
	if_set_visible(arg_142_0.vars.wnd, "n_sub_tabs", not arg_142_0.vars.sell_mode)
	
	if arg_142_0.vars.sell_mode then
		arg_142_0:updateSellInfo()
	else
		local var_142_0 = arg_142_0.vars.selected
		
		arg_142_0.vars.selected = {}
		
		for iter_142_0, iter_142_1 in pairs(var_142_0) do
			arg_142_0:updateCard(iter_142_0)
		end
	end
	
	if_set_visible(arg_142_0.vars.wnd:getChildByName("n_equip_menu"), "btn_delete_after", arg_142_0.vars.sell_mode == true)
	if_set_visible(arg_142_0.vars.wnd:getChildByName("n_equip_menu"), "btn_delete", arg_142_0.vars.sell_mode ~= true)
	
	if arg_142_0.vars.main_tab == var_0_1.Equip then
		if arg_142_0.vars.sell_mode == true then
			arg_142_0.vars.set_filterOpt = arg_142_0.vars.sorter.sorter_extention:getSetStatOpt() or "all"
			arg_142_0.vars.mainstat_filterOpt = arg_142_0.vars.sorter.sorter_extention:getMainStatOpt() or "all"
			arg_142_0.vars.substat1_filterOpt = arg_142_0.vars.sorter.sorter_extention:getSubStatOpt(1) or "all"
			arg_142_0.vars.substat2_filterOpt = arg_142_0.vars.sorter.sorter_extention:getSubStatOpt(2) or "all"
			
			arg_142_0.vars.sorter.sorter_extention:closeOptsFilter()
		elseif arg_142_0.vars.sell_mode == false and arg_142_0.vars.set_filterOpt and arg_142_0.vars.mainstat_filterOpt and arg_142_0.vars.substat1_filterOpt and arg_142_0.vars.substat2_filterOpt then
			local var_142_1 = {
				set = arg_142_0.vars.set_filterOpt,
				mainstat = arg_142_0.vars.mainstat_filterOpt,
				substat1 = arg_142_0.vars.substat1_filterOpt,
				substat2 = arg_142_0.vars.substat2_filterOpt
			}
			
			arg_142_0.vars.sorter.sorter_extention:closeOptsFilter()
			
			arg_142_0.vars.set_filterOpt = nil
			arg_142_0.vars.mainstat_filterOpt = nil
			arg_142_0.vars.substat1_filterOpt = nil
			arg_142_0.vars.substat2_filterOpt = nil
		end
		
		if_set_visible(arg_142_0.vars.wnd, "btn_equip_change", false)
		if_set_visible(arg_142_0.vars.wnd, "n_tab_sell", false)
		if_set_visible(arg_142_0.vars.wnd, "n_tab_sell_equip", arg_142_0.vars.sell_mode == true)
	end
	
	if arg_142_0.vars.items then
		if not arg_142_2 then
			arg_142_0:UpdateContents(nil, {
				ignore_select = true,
				do_not_keep_pos = false
			})
		end
	else
		arg_142_0:UpdateContents()
	end
end

function Inventory.moveSubTabSelector(arg_143_0, arg_143_1, arg_143_2)
	if not arg_143_1 then
		return 
	end
	
	local var_143_0 = arg_143_1:getChildByName("n_selected")
	
	if not var_143_0 then
		return 
	end
	
	local var_143_1 = arg_143_1:getChildByName("n_tab" .. arg_143_2)
	
	if var_143_1 then
		var_143_0:setPositionX(var_143_1:getPositionX())
	end
end

function Inventory._setTabBg(arg_144_0, arg_144_1, arg_144_2, arg_144_3)
	if not arg_144_2 then
		return 
	end
	
	local var_144_0 = arg_144_1:findChildByName("n_tab" .. arg_144_2)
	
	if_set_visible(var_144_0, "tab_bg", arg_144_3)
end

function Inventory.moveMainTabSelector(arg_145_0, arg_145_1, arg_145_2, arg_145_3)
	if not arg_145_1 then
		return 
	end
	
	if arg_145_2 == arg_145_3 then
		return 
	end
	
	arg_145_0:_setTabBg(arg_145_1, arg_145_2, true)
	arg_145_0:_setTabBg(arg_145_1, arg_145_3, false)
end

function Inventory.updateSellInfo(arg_146_0)
	local var_146_0 = 0
	local var_146_1 = 0
	local var_146_2 = 0
	
	for iter_146_0, iter_146_1 in pairs(arg_146_0.vars.selected) do
		if iter_146_0.isEquip then
			var_146_0 = var_146_0 + calcEquipSellPrice(iter_146_0)
		end
		
		if iter_146_0:isArtifact() then
			local var_146_3 = calcArtifactSellPowder(iter_146_0)
			
			if var_146_3 then
				var_146_1 = var_146_1 + var_146_3
			end
		end
		
		var_146_2 = var_146_2 + 1
	end
	
	local var_146_4 = var_146_0 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_146_0)
	
	if get_cocos_refid(arg_146_0.vars.wnd) then
		local var_146_5 = arg_146_0.vars.wnd:getChildByName("txt_sell_price")
		
		if_set(var_146_5, nil, currency_format(var_146_4, "", "+"))
		
		local var_146_6 = arg_146_0.vars.wnd:getChildByName("txt_sell_price2")
		
		if get_cocos_refid(var_146_6) then
			local var_146_7 = var_146_6:getParent()
			
			if arg_146_0.vars.main_tab == var_0_1.Artifact then
				if_set(var_146_6, nil, currency_format(var_146_1, "", "+"))
				
				local var_146_8 = var_146_5:getContentSize().width * var_146_5:getScaleX()
				local var_146_9 = var_146_7:getContentSize().width * var_146_7:getScaleX() - 15
				
				var_146_7:setPositionX(var_146_5:getPositionX() + var_146_8 + var_146_9)
				
				if var_146_1 > 0 then
					if_set_visible(var_146_7, nil, true)
				else
					if_set_visible(var_146_7, nil, false)
				end
			else
				if_set_visible(var_146_7, nil, false)
			end
		end
		
		local var_146_10
		
		if arg_146_0.vars.main_tab == var_0_1.Equip then
			var_146_10 = arg_146_0.vars.wnd:getChildByName("n_tab_sell_equip")
			
			if_set(var_146_10, "t_item_count", T("ui_extraction_select_inventory", {
				count = var_146_2
			}))
			
			local var_146_11 = arg_146_0:checkExtractItemList(arg_146_0.vars.selected, true)
			local var_146_12 = var_146_2 > 0 and var_146_11
			
			if_set_opacity(var_146_10, "btn_extract", var_146_12 and 255 or 76.5)
			
			if not Account:isUnlockExtract() then
				if_set_visible(var_146_10, "btn_extract", false)
				
				local var_146_13 = var_146_10:getChildByName("t_item_count")
				
				if not var_146_13.originPosX then
					var_146_13.originPosX = var_146_13:getPositionX()
				end
				
				var_146_13:setPositionX(var_146_13.originPosX - 150)
			end
		else
			var_146_10 = arg_146_0.vars.wnd:getChildByName("n_tab_sell")
			
			if_set(var_146_10, "txt_sell_count", T("sell_count", {
				count = var_146_2
			}))
		end
		
		local var_146_14 = var_146_10:getChildByName("btn_sell")
		
		if var_146_2 > 0 then
			var_146_14:setOpacity(255)
		else
			var_146_14:setOpacity(50)
		end
	end
	
	arg_146_0.vars.totalGold = var_146_4
	arg_146_0.vars.totalPowder = var_146_1
end

function Inventory.updateSorterCheckBox(arg_147_0)
	local var_147_0 = false
	local var_147_1 = SAVE:getKeep("inventory_show_detail") or false
	
	if arg_147_0:isShow() then
		if arg_147_0.vars and arg_147_0.vars.sorter_equip and arg_147_0.vars.sorter_equip.vars and arg_147_0.vars.sorter_equip.vars.opts then
			for iter_147_0, iter_147_1 in pairs(arg_147_0.vars.sorter_equip.vars.opts.checkboxs or {}) do
				if iter_147_1.id == "show_detail" and iter_147_1.checked then
					var_147_0 = true
				end
			end
		end
		
		if var_147_1 ~= var_147_0 and arg_147_0.vars.sorter_equip then
			for iter_147_2, iter_147_3 in pairs(arg_147_0.vars.sorter_equip.vars.opts.checkboxs or {}) do
				if iter_147_3.id == "show_detail" then
					local var_147_2 = SAVE:getKeep("inventory_show_detail")
					local var_147_3 = arg_147_0.vars.sorter_equip.vars.check_flags
					
					if var_147_3 and var_147_3[iter_147_3.id] ~= var_147_2 then
						arg_147_0:setShowEquipDetailView(var_147_2)
						arg_147_0.vars.sorter_equip:setToggle(iter_147_2, var_147_2)
					end
				end
			end
			
			local var_147_4 = SAVE:getKeep("inventory_show_detail")
			
			arg_147_0:initListView(var_147_4 == true and "wnd/inventory_card2.csb" or nil)
			arg_147_0:ResetItems()
		end
	end
end

function Inventory.selectMainTab(arg_148_0, arg_148_1, arg_148_2)
	if arg_148_1 == var_0_1.ExclusiveEquip and not Account:canUseExclusive() then
		balloon_message_with_sound("ui_exclusive_open")
		
		return 
	end
	
	if arg_148_1 == 6 then
		if not Account:isUnlockTabEquipMaterials() then
			balloon_message_with_sound("ui_inventory_enchant_tap_yet")
			
			return 
		end
		
		TutorialGuide:procGuide("system_126")
	end
	
	local var_148_0 = (SAVE:getKeep("inventory_show_detail") or arg_148_0.vars.showEquipDetail) and arg_148_1 == var_0_1.Equip
	
	if SAVE:getKeep("inventory_show_detail") ~= arg_148_0.vars.showEquipDetail and arg_148_1 == 2 and arg_148_0.vars.sorter_equip then
		for iter_148_0, iter_148_1 in pairs(arg_148_0.vars.sorter_equip.vars.opts.checkboxs or {}) do
			if iter_148_1.id == "show_detail" then
				local var_148_1 = SAVE:getKeep("inventory_show_detail")
				local var_148_2 = arg_148_0.vars.sorter_equip.vars.check_flags
				
				if var_148_2 and var_148_2[iter_148_1.id] ~= var_148_1 then
					arg_148_0:setShowEquipDetailView(var_148_1)
					arg_148_0.vars.sorter_equip:setToggle(iter_148_0, var_148_1)
				end
			end
		end
	end
	
	arg_148_0:initListView(var_148_0 == true and "wnd/inventory_card2.csb" or nil)
	if_set_visible(arg_148_0.vars.wnd, "btn_equip_change", false)
	arg_148_0:setSorter(arg_148_1 == var_0_1.Artifact, arg_148_1 == var_0_1.ExclusiveEquip, arg_148_1 == var_0_1.Wearing)
	
	arg_148_1 = arg_148_1 or var_0_1.Wearing
	
	local var_148_3 = Inventory[var_0_0[arg_148_0.vars.main_tab]]
	local var_148_4 = Inventory[var_0_0[arg_148_1]]
	
	if var_148_3 and var_148_3.onLeave then
		var_148_3:onLeave()
	end
	
	local var_148_5 = arg_148_0.vars.main_tab
	
	arg_148_0.vars.main_tab = arg_148_1
	arg_148_0.last_main_tab = arg_148_1
	
	arg_148_0:moveMainTabSelector(arg_148_0.vars.wnd:getChildByName("n_main_tab"), arg_148_0.vars.main_tab, var_148_5)
	
	for iter_148_2 = 1, table.count(var_0_0) do
		if_set_visible(arg_148_0.vars.wnd, "n_tab_sub" .. iter_148_2, iter_148_2 == arg_148_1)
	end
	
	if_set_visible(arg_148_0.vars.wnd, "n_equip_menu", arg_148_1 == var_0_1.Wearing or arg_148_1 == var_0_1.Equip or arg_148_1 == var_0_1.Artifact or arg_148_1 == var_0_1.ExclusiveEquip)
	if_set_visible(arg_148_0.vars.wnd, "btn_count", arg_148_1 == var_0_1.Equip or arg_148_1 == var_0_1.ExclusiveEquip)
	if_set_visible(arg_148_0.vars.wnd, "btn_count_arti", arg_148_1 == var_0_1.Artifact)
	if_set_visible(arg_148_0.vars.wnd, "n_wear_sorting", arg_148_1 == var_0_1.Wearing)
	if_set_visible(arg_148_0.vars.wnd, "n_sorting", arg_148_1 ~= var_0_1.Wearing)
	
	if arg_148_0.vars.listview then
		arg_148_0.vars.listview:removeAllChildren()
	end
	
	if arg_148_1 == var_0_1.Wearing then
		arg_148_0.vars.listview = arg_148_0.vars.listview_wearing
	elseif arg_148_1 == var_0_1.ExclusiveEquip then
		arg_148_0.vars.listview = arg_148_0.vars.listview_exclusive
	elseif arg_148_1 == var_0_1.EquipMaterials then
		arg_148_0.vars.listview = arg_148_0.vars.listview_eq_material
	elseif arg_148_1 ~= var_0_1.Artifact then
		arg_148_0.vars.listview = arg_148_0.vars.listview_normal
	else
		arg_148_0.vars.listview = arg_148_0.vars.listview_artifact
	end
	
	arg_148_0:toggleSellMode(false, arg_148_1 == var_0_1.ExclusiveEquip)
	arg_148_0.vars.listview_normal:setVisible(arg_148_1 > var_0_1.Wearing and arg_148_1 ~= var_0_1.Artifact and arg_148_1 ~= var_0_1.ExclusiveEquip and arg_148_1 ~= var_0_1.EquipMaterials)
	arg_148_0.vars.listview_artifact:setVisible(arg_148_1 == var_0_1.Artifact)
	arg_148_0.vars.listview_wearing:setVisible(arg_148_1 == var_0_1.Wearing)
	arg_148_0.vars.listview_exclusive:setVisible(arg_148_1 == var_0_1.ExclusiveEquip)
	arg_148_0.vars.listview_eq_material:setVisible(arg_148_1 == var_0_1.EquipMaterials)
	if_set_visible(arg_148_0.vars.wnd, "n_tab_sell_material", arg_148_1 == var_0_1.EquipMaterials)
	if_set_visible(arg_148_0.vars.wnd, "n_tab_sell_stuff", arg_148_1 == var_0_1.Etc)
	
	if var_148_4 and var_148_4.onEnter then
		var_148_4:onEnter()
	end
	
	if not arg_148_2 then
		arg_148_2 = not (arg_148_1 ~= var_0_1.ExclusiveEquip and arg_148_1 ~= var_0_1.Artifact and arg_148_1 ~= var_0_1.Wearing) and 0 or 1
		
		if var_148_4 and var_148_4.tab then
			arg_148_2 = var_148_4.tab
		end
	end
	
	local var_148_6
	
	if arg_148_1 == var_0_1.EquipMaterials and var_148_4 and var_148_4.tab_name then
		if string.find(var_148_4.tab_name, "eq_ma") then
			var_148_6 = var_148_4.tab_name
		elseif string.find(var_148_4.tab_name, "equip") then
			arg_148_2 = string.sub(var_148_4.tab_name, -1, -1)
			arg_148_2 = tonumber(arg_148_2)
			var_148_6 = var_148_4.tab_name
		end
	end
	
	arg_148_0:selectSubTab(arg_148_2, var_148_6)
	if_set_visible(arg_148_0.vars.wnd:getChildByName("n_equip_menu"), "btn_delete", arg_148_1 ~= var_0_1.ExclusiveEquip and arg_148_1 ~= var_0_1.Wearing)
end

function Inventory.selectSubTab(arg_149_0, arg_149_1, arg_149_2)
	if arg_149_0.vars.main_tab ~= var_0_1.EquipMaterials then
		arg_149_0:moveSubTabSelector(arg_149_0.vars.wnd:getChildByName("n_tab_sub" .. arg_149_0.vars.main_tab), arg_149_1)
	end
	
	local var_149_0 = Inventory[var_0_0[arg_149_0.vars.main_tab]]
	
	if var_149_0 and var_149_0.selectSubTab then
		var_149_0:selectSubTab(arg_149_1, arg_149_2)
	end
	
	arg_149_0:ResetItems(nil, true)
end

function Inventory.selectMaterialSubTab(arg_150_0, arg_150_1)
end

function Inventory.baseButtonsFilterList(arg_151_0, arg_151_1, arg_151_2, arg_151_3, arg_151_4)
	local var_151_0 = arg_151_0.vars.wnd:findChildByName("n_3_menu")
	local var_151_1 = var_151_0:findChildByName("n_3_tab6_2")
	
	if not get_cocos_refid(var_151_0) or not get_cocos_refid(var_151_1) then
		return 
	end
	
	local var_151_2 = var_151_1:findChildByName(arg_151_4)
	
	if not get_cocos_refid(var_151_2) then
		return 
	end
	
	if_set_visible(var_151_1, arg_151_3, false)
	if_set_visible(var_151_2, nil, true)
	if_set_visible(var_151_2, "icon_all", arg_151_2)
	
	var_151_2.base_sz = var_151_2.base_sz or var_151_2:getContentSize()
	var_151_2.base_pos_x = var_151_2.base_pos_x or var_151_2:getPositionX()
	
	var_151_2:setContentSize(var_151_2.base_sz)
	var_151_2:setPositionX(var_151_2.base_pos_x)
	
	for iter_151_0 = 1, 16 do
		if_set_visible(var_151_2, "icon_stat_" .. iter_151_0, false)
	end
	
	local var_151_3 = 0
	local var_151_4 = 34
	local var_151_5 = 7
	
	for iter_151_1 = 1, var_151_5 do
		if_set_sprite(var_151_2, "icon_stat_" .. iter_151_1, EQUIP:getSetItemIconPath(arg_151_1[iter_151_1]))
		if_set_visible(var_151_2, "icon_stat_" .. iter_151_1, arg_151_1[iter_151_1] and not arg_151_2)
		
		if arg_151_1[iter_151_1] and not arg_151_2 then
			var_151_3 = var_151_3 + var_151_4
		end
	end
	
	if_set_position_x(var_151_2, "label", arg_151_2 and 42 or var_151_3 + 8)
	
	local var_151_6 = T("ui_equip_base_filter_set")
	
	if var_151_5 < table.count(arg_151_1) then
		var_151_6 = "⋯ " .. var_151_6
	end
	
	if_set(var_151_2, "label", var_151_6)
end

function Inventory.baseButtonsFilter(arg_152_0, arg_152_1, arg_152_2, arg_152_3)
	local var_152_0 = arg_152_0.vars.wnd:findChildByName("n_3_menu")
	local var_152_1 = var_152_0:findChildByName("n_3_tab6_2")
	
	if not get_cocos_refid(var_152_0) or not get_cocos_refid(var_152_1) then
		return 
	end
	
	local var_152_2 = var_152_1:findChildByName(arg_152_3)
	
	if not get_cocos_refid(var_152_2) then
		return 
	end
	
	if_set_visible(var_152_1, arg_152_2, false)
	if_set_visible(var_152_2, nil, true)
	if_set_visible(var_152_2, "icon_all", not arg_152_1)
	if_set_visible(var_152_2, "icon_stat", arg_152_1)
	if_set_visible(var_152_2, "icon_pers", arg_152_1 and string.ends(arg_152_1, "_rate"))
	
	if arg_152_1 then
		if_set_sprite(var_152_2, "icon_stat", UIUtil:getStatIconPath(arg_152_1))
	end
end

function Inventory.baseButtonsGradeFilter(arg_153_0, arg_153_1, arg_153_2, arg_153_3, arg_153_4)
	local var_153_0 = arg_153_0.vars.wnd:findChildByName("n_3_menu")
	local var_153_1 = var_153_0:findChildByName("n_3_tab6_2")
	
	if not get_cocos_refid(var_153_0) or not get_cocos_refid(var_153_1) then
		return 
	end
	
	local var_153_2 = var_153_1:findChildByName(arg_153_4)
	
	if not get_cocos_refid(var_153_2) then
		return 
	end
	
	if_set_visible(var_153_1, arg_153_3, arg_153_2)
	if_set_visible(var_153_2, nil, not arg_153_2)
	
	if arg_153_2 then
		if_set(var_153_2, "label", T("ui_inventory_extractgrade1"))
	elseif arg_153_1 then
		local var_153_3 = ({
			ext_4 = "ui_inventory_extractgrade2",
			ext_3 = "ui_inventory_extractgrade3"
		})[arg_153_1] or "nill"
		
		if_set(var_153_2, "label", T(var_153_3))
	end
end

function Inventory.updateButtonSetFxList(arg_154_0, arg_154_1, arg_154_2)
	arg_154_0:baseButtonsFilterList(arg_154_1, arg_154_2, "btn_set", "btn_set_done")
end

function Inventory.updateButtonStatList(arg_155_0, arg_155_1, arg_155_2)
	arg_155_0:baseButtonsFilter(arg_155_1[1], "btn_mainstat", "btn_mainstat_done")
end

function Inventory.updateButtonGradeList(arg_156_0, arg_156_1, arg_156_2)
	arg_156_0:baseButtonsGradeFilter(arg_156_1[1], arg_156_2, "btn_grade", "btn_grade_done")
end

function Inventory.setButtonSetFxList(arg_157_0, arg_157_1, arg_157_2)
	arg_157_0:baseButtonsFilterList(arg_157_1, arg_157_2, "btn_set_done", "btn_set")
end

function Inventory.setButtonStatList(arg_158_0, arg_158_1, arg_158_2)
	arg_158_0:baseButtonsFilter(arg_158_1[1], "btn_mainstat_done", "btn_mainstat")
end

function Inventory.setButtonGradeList(arg_159_0, arg_159_1, arg_159_2)
	arg_159_0:baseButtonsGradeFilter(arg_159_1[1], arg_159_2, "btn_grade", "btn_grade_done")
end

function Inventory.forceOpenEquipMode(arg_160_0)
	arg_160_0:open()
	arg_160_0:selectMainTab(2)
	arg_160_0:selectSubTab(0)
	arg_160_0:toggleSellMode()
end

function Inventory.forceOpenEquipMaterialMode(arg_161_0)
	arg_161_0:open()
	arg_161_0:selectMainTab(6)
	arg_161_0:selectSubTab(2, "btn_eq_ma_tab2")
	arg_161_0.EquipMaterials:toggleSellMode(true)
end

function Inventory.toggleEquipSetFilter(arg_162_0)
	if not arg_162_0.vars or not get_cocos_refid(arg_162_0.vars.wnd) or arg_162_0.vars.main_tab ~= var_0_1.EquipMaterials or not arg_162_0.vars.set_fx_filter then
		return 
	end
	
	arg_162_0.vars.set_fx_filter:open()
end

function Inventory.toggleEquipStatFilter(arg_163_0)
	if not arg_163_0.vars or not get_cocos_refid(arg_163_0.vars.wnd) or arg_163_0.vars.main_tab ~= var_0_1.EquipMaterials or not arg_163_0.vars.stat_filter then
		return 
	end
	
	arg_163_0.vars.stat_filter:open()
end

function Inventory.toggleGradeStatFilter(arg_164_0)
	if not arg_164_0.vars or not get_cocos_refid(arg_164_0.vars.wnd) or arg_164_0.vars.main_tab ~= var_0_1.EquipMaterials or not arg_164_0.vars.grade_filter then
		return 
	end
	
	arg_164_0.vars.grade_filter:open()
end

function Inventory.UpdateContents(arg_165_0, arg_165_1, arg_165_2)
	local var_165_0 = arg_165_2 or {}
	
	if not arg_165_0.vars then
		return 
	end
	
	if arg_165_0.vars and not get_cocos_refid(arg_165_0.vars.wnd) then
		return 
	end
	
	if arg_165_0.vars.main_tab == var_0_1.Wearing then
		arg_165_0.vars.listview_wearing:refresh()
		
		return 
	end
	
	if not arg_165_1 then
		arg_165_0:ResetItems(var_165_0.ignore_select, var_165_0.do_not_keep_pos)
		
		return 
	end
	
	if arg_165_0.vars.main_tab == var_0_1.Equip or arg_165_0.vars.main_tab == var_0_1.Artifact or arg_165_0.vars.main_tab == var_0_1.ExclusiveEquip then
		for iter_165_0, iter_165_1 in pairs(arg_165_0.vars.items) do
			if iter_165_1 == arg_165_1 then
				arg_165_0.vars.listview:refresh(iter_165_1)
			end
		end
	end
end

function Inventory.updateCard(arg_166_0, arg_166_1)
	arg_166_0.vars.listview:refresh(arg_166_1)
end

function Inventory.onSelect(arg_167_0, arg_167_1)
	if not arg_167_0.vars then
		return 
	end
	
	UIAction:Add(DELAY(50), arg_167_0.vars.wnd, "block")
	
	if arg_167_0.vars.main_tab == var_0_1.Etc then
		Inventory.Etc:onSelect(arg_167_1)
	elseif arg_167_0.vars.main_tab == var_0_1.EquipMaterials then
		Inventory.EquipMaterials:onSelect(arg_167_1)
	end
	
	if not arg_167_1.isEquip and not arg_167_1.type then
		return 
	end
	
	if arg_167_1.type and arg_167_1.type == "multi_eq_select" then
		ItemSelectBoxDual:open(arg_167_0.vars.wnd, arg_167_1.code, "equip_set", function(arg_168_0)
			if arg_168_0 and arg_168_0.material_id then
				query("open_dual_select_item", arg_168_0)
			end
		end)
		
		return 
	end
	
	if arg_167_1.type and arg_167_1.type == "special" then
		ItemSelectBox:make(arg_167_0.vars.wnd, arg_167_1, {
			enable_touch = true,
			handler = function(arg_169_0)
				local var_169_0 = arg_169_0
				
				if not var_169_0 then
					balloon_message_with_sound("msg_no_reward_select")
					
					return "dont_close"
				end
				
				query("open_option_item", {
					material_id = var_169_0.material_id,
					option_id = var_169_0.option_id,
					use_count = var_169_0.use_count
				})
			end
		})
		TutorialGuide:procGuide("itemselection")
		
		return 
	end
	
	if arg_167_1.type and arg_167_1.type == "expendable" then
		local var_167_0
		local var_167_1 = T("misc_popup_desc")
		local var_167_2 = T("misc_popup_title")
		local var_167_3
		local var_167_4 = DB("item_material", arg_167_1.code, {
			"ma_type2"
		})
		
		if var_167_4 and string.starts(var_167_4, "sp_") then
			local var_167_5, var_167_6, var_167_7, var_167_8 = DB("item_special", var_167_4, {
				"type",
				"value",
				"random_list",
				"name"
			})
			local var_167_9 = arg_167_0:checkInventoryItem(var_167_4)
			
			if var_167_9 and var_167_9.equip and UIUtil:checkEquipInven() == false then
				return 
			end
			
			if var_167_9 and var_167_9.artifact and UIUtil:checkArtifactInven() == false then
				return 
			end
			
			if var_167_9 and var_167_9.unit and UIUtil:checkUnitInven() == false then
				return 
			end
			
			if var_167_5 == "account_skill" then
				local var_167_10 = DB("account_skill", var_167_6, {
					"effect_type"
				})
				
				if AccountSkill:isBlockConditionEquipFree(var_167_6) == true then
					return 
				end
				
				local var_167_11, var_167_12 = AccountSkill:isChangeTextEquipFree(var_167_6)
				
				if var_167_11 then
					var_167_1 = var_167_12
				end
			elseif var_167_5 == "gacha" and var_167_6 and var_167_7 == "y" then
				var_167_0 = load_dlg("gacha_p_confirm_inven", true, "wnd")
				var_167_2 = T("ui_inventory_gacha_randombox_title")
				var_167_1 = T("inventory_gacha_randombox_desc")
				
				if_set(var_167_0, "txt_include", T("ui_randomitem_included", {
					item = T(var_167_8)
				}))
				
				function var_167_3(arg_170_0, arg_170_1, arg_170_2)
					if arg_170_1 == "btn_rate" then
						query("gacha_rate_info", {
							item = var_167_6
						})
						
						return "dont_close"
					elseif arg_170_1 == "btn_yes" then
						query("open_expendable_item", {
							material_id = arg_167_1.code
						})
					end
				end
			end
		end
		
		var_167_0 = var_167_0 or load_dlg("shop_nocurrency", true, "wnd")
		
		if_set_visible(var_167_0, "txt_shop_comment", false)
		UIUtil:getRewardIcon(0, arg_167_1.code, {
			show_small_count = true,
			show_name = true,
			detail = true,
			parent = var_167_0:getChildByName("n_item_pos")
		})
		
		var_167_3 = var_167_3 or function()
			query("open_expendable_item", {
				material_id = arg_167_1.code
			})
		end
		
		Dialog:msgBox(var_167_1, {
			yesno = true,
			dlg = var_167_0,
			yes_text = T("misc_popup_btn_ok"),
			no_text = T("misc_popup_btn_cancel"),
			handler = var_167_3,
			title = var_167_2
		})
		
		return 
	end
	
	if arg_167_1.type and (arg_167_1.type == "gradejump" or arg_167_1.type == "awakenjump") then
		UnitPromotePopup:create(arg_167_1.type)
		
		return 
	end
	
	if arg_167_0.vars.sell_mode then
		Inventory:onSelectSell(arg_167_1)
	elseif arg_167_1.isStone and not arg_167_1:isStone() then
		InventoryPopupDetail:Open(arg_167_1, {
			layer = arg_167_0.vars.wnd
		})
	end
end

function Inventory.lockEquip(arg_172_0, arg_172_1, arg_172_2)
	local var_172_0 = Account:getEquip(arg_172_1)
	local var_172_1
	
	if not var_172_0 then
		var_172_0 = Account:getEquipFromStorage(arg_172_1)
		var_172_1 = true
	end
	
	var_172_0.lock = arg_172_2
	
	if arg_172_2 then
		balloon_message_with_sound("equip_lock")
	else
		balloon_message_with_sound("equip_unlock")
	end
	
	LuaEventDispatcher:dispatchEvent("update.equip.lock", var_172_0.lock)
	UnitDetailEquip:updateEquipLock(var_172_0)
	UnitEquip:updateInfos()
	
	if var_172_1 then
		EquipStorageManage:resetUI()
	end
	
	SoundEngine:play("event:/ui/unit_detail/btn_lock")
end

function Inventory.MSG_lock_equip(arg_173_0, arg_173_1)
	Inventory:lockEquip(arg_173_1.equip, arg_173_1.lock)
end

function Inventory.MSG_unlock_equip(arg_174_0, arg_174_1)
	Inventory:lockEquip(arg_174_1.equip, arg_174_1.lock)
end

function Inventory.MSG_putoff_equip(arg_175_0, arg_175_1)
	if arg_175_1.caller == "inventory_wear" then
		arg_175_0:UpdateContents()
		InventoryPopupDetail:Close()
	end
	
	if arg_175_1.caller == "inventory_popup" then
		InventoryPopupDetail:Close()
		arg_175_0:UpdateContents(Account:getEquip(arg_175_1.equips[1]))
		arg_175_0:updateItemInvenCount()
		
		return 
	end
	
	if arg_175_1.caller == "inventory_putoff_all" then
		arg_175_0:UpdateContents()
		arg_175_0:updateItemInvenCount()
	end
end

function Inventory.MSG_sell_equips(arg_176_0, arg_176_1)
	if not (arg_176_1.isExtract or false) then
		if arg_176_1.total_powder and arg_176_1.total_powder > 0 then
			balloon_message_with_sound("equip_sell_gold2", {
				price = comma_value(arg_176_1.total_price),
				price2 = comma_value(arg_176_1.total_powder)
			})
		else
			balloon_message_with_sound("equip_sell_gold", {
				price = comma_value(arg_176_1.total_price)
			})
		end
	end
	
	if arg_176_1.caller == "inventory_popup" then
		InventoryPopupDetail:updatePopupCaller()
		InventoryPopupDetail:Close()
	end
	
	if arg_176_0.vars and arg_176_0.vars.wnd then
		arg_176_0:ResetItems(nil, false)
		
		if arg_176_1.caller == "inventory" then
			arg_176_0:toggleSellMode(false)
		end
	end
end

function Inventory.IsSelected(arg_177_0, arg_177_1)
	return arg_177_0.vars and arg_177_0.vars.selected[arg_177_1]
end

function Inventory.onSelectSell(arg_178_0, arg_178_1)
	if arg_178_1.parent then
		balloon_message_with_sound("sell_cant_equip")
		
		return 
	end
	
	if arg_178_1.lock then
		balloon_message_with_sound("sell_cant_lock")
		
		return 
	end
	
	if arg_178_1:isForceLock() then
		balloon_message_with_sound("err_cannot_sell_equip")
		
		return 
	end
	
	if arg_178_0.vars.selected[arg_178_1] then
		arg_178_0.vars.selected[arg_178_1] = nil
	else
		arg_178_0.vars.selected[arg_178_1] = true
	end
	
	arg_178_0:updateCard(arg_178_1)
	arg_178_0:updateSellInfo()
end

function Inventory.getSellDlg(arg_179_0, arg_179_1, arg_179_2, arg_179_3, arg_179_4)
	if not arg_179_1 then
		Log.e("Equipid_list was not set.")
	end
	
	Inventory:getSellDialog(arg_179_3 or arg_179_0.vars.totalGold, arg_179_4 or arg_179_0.vars.totalPowder, arg_179_1, "inventory", nil, arg_179_2)
end

function Inventory.getExtractDlg(arg_180_0, arg_180_1, arg_180_2, arg_180_3, arg_180_4)
	if not arg_180_1 or not arg_180_2 then
		Log.e("Equipid_list was not set.")
	end
	
	Inventory:getExtractDialog(arg_180_1, arg_180_2, nil, arg_180_3, arg_180_4)
end

function Inventory.sell(arg_181_0)
	local var_181_0 = {}
	local var_181_1 = 0
	
	for iter_181_0, iter_181_1 in pairs(arg_181_0.vars.selected) do
		table.push(var_181_0, iter_181_0.id)
		
		var_181_1 = var_181_1 + 1
	end
	
	if var_181_1 == 0 then
		return 
	end
	
	arg_181_0:getSellDlg(var_181_0)
end

function Inventory.extract(arg_182_0)
	if not arg_182_0.vars or not get_cocos_refid(arg_182_0.vars.wnd) or table.empty(arg_182_0.vars.selected) then
		return 
	end
	
	local var_182_0 = {}
	local var_182_1 = 0
	
	for iter_182_0, iter_182_1 in pairs(arg_182_0.vars.selected) do
		table.push(var_182_0, iter_182_0)
		
		var_182_1 = var_182_1 + 1
	end
	
	if var_182_1 == 0 then
		return 
	end
	
	arg_182_0:getExtractDlg(var_182_0, "inventory")
end

function Inventory.extractUtil(arg_183_0, arg_183_1, arg_183_2, arg_183_3)
	if not arg_183_1 or table.empty(arg_183_1) then
		return 
	end
	
	arg_183_0:getExtractDlg(arg_183_1, arg_183_2, arg_183_3)
end

function Inventory.checkExtractItemList(arg_184_0, arg_184_1, arg_184_2)
	if not arg_184_1 or table.empty(arg_184_1) then
		return 
	end
	
	local var_184_0 = arg_184_2 or false
	
	for iter_184_0, iter_184_1 in pairs(arg_184_1) do
		if (var_184_0 and iter_184_0 or iter_184_1):isExtractable() then
			return true
		end
	end
	
	return false
end

function Inventory.ReqUnequip(arg_185_0, arg_185_1, arg_185_2)
	if not arg_185_1.parent then
		return 
	end
	
	local function var_185_0()
		local var_186_0 = Account:getUnit(arg_185_1.parent)
		
		if not var_186_0 then
			return 
		end
		
		query("putoff_equip", {
			unit = var_186_0:getUID(),
			equip = arg_185_1:getUID(),
			caller = arg_185_2
		})
	end
	
	local var_185_1 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT)
	local var_185_2 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
	local var_185_3 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ARTI_FREE)
	
	if arg_185_1:getUnequipCost() <= 0 and (var_185_1 or arg_185_1:isArtifact() and var_185_3 or not arg_185_1:isArtifact() and var_185_2) then
		var_185_0()
		
		return 
	end
	
	local var_185_4 = arg_185_1:getUnequipCost()
	
	Dialog:msgBox(T("equip_undress_desc", {
		cost = var_185_4
	}), {
		token = "to_gold",
		yesno = true,
		title = T("equip_undress_title"),
		cost = var_185_4,
		handler = var_185_0
	})
end

function Inventory.HelpbuttonPosition(arg_187_0)
	local var_187_0 = arg_187_0.vars.wnd:getChildByName("txt_title")
	local var_187_1 = arg_187_0.vars.wnd:getChildByName("btn_Help")
	
	if var_187_0 then
		local var_187_2 = var_187_0:getContentSize().width * var_187_0:getScaleX() + var_187_0:getPositionX()
		
		if var_187_1 then
			var_187_1:setPositionX(var_187_2 + 10)
		end
	end
end

function Inventory.checkInventoryItem(arg_188_0, arg_188_1)
	local var_188_0 = {
		artifact = false,
		unit = false,
		equip = false
	}
	local var_188_1, var_188_2 = DB("equip_item", arg_188_1, {
		"id",
		"type"
	})
	
	if var_188_1 then
		if var_188_2 == "artifact" then
			var_188_0.artifact = true
		else
			var_188_0.equip = true
		end
	elseif DB("character", arg_188_1, "id") then
		var_188_0.unit = true
	else
		local var_188_3, var_188_4 = DB("item_special", arg_188_1, {
			"type",
			"inven_check"
		})
		
		if var_188_4 then
			local var_188_5 = string.split(var_188_4, ",")
			
			for iter_188_0, iter_188_1 in pairs(var_188_5) do
				if iter_188_1 == "hero" then
					var_188_0.unit = true
				end
				
				if iter_188_1 == "equip" then
					var_188_0.equip = true
				end
				
				if iter_188_1 == "artifact" then
					var_188_0.artifact = true
				end
				
				if iter_188_1 == "ignore" then
					var_188_0.unit = false
					var_188_0.equip = false
					var_188_0.artifact = false
				end
			end
		elseif var_188_3 == "gacha" or var_188_3 == "gacha_select" then
			var_188_0.unit = true
			var_188_0.artifact = true
		elseif var_188_3 == "randombox" or var_188_3 == "package" or var_188_3 == "option" then
			var_188_0.unit = true
			var_188_0.equip = true
			var_188_0.artifact = true
		end
	end
	
	if var_188_0.unit or var_188_0.equip or var_188_0.artifact then
		return var_188_0
	else
		return nil
	end
end
