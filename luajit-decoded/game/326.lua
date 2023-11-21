function MsgHandler.hero_storage_list(arg_1_0)
	if arg_1_0.list then
		AccountData.stored_units = arg_1_0.list
		
		Storage:updateStoredHeroes(true)
	end
end

function MsgHandler.inc_hero_storage_unit_inven(arg_2_0)
	Account:updateCurrencies(arg_2_0)
	TopBarNew:topbarUpdate(true)
	
	if arg_2_0.storage_unit_inven then
		local var_2_0 = AccountData.storage_unit_inven
		
		AccountData.storage_unit_inven = arg_2_0.storage_unit_inven
		
		Dialog:msgBoxLevelUp({
			text = T("waitingroom_error_noti3"),
			title = T("waitingroom_confirm_title"),
			after_score = arg_2_0.storage_unit_inven,
			before_score = var_2_0
		})
	end
	
	Storage:updateStorageUnitInven(true)
end

function MsgHandler.hero_storage_put_in(arg_3_0)
	Storage:applyPutIn(arg_3_0)
end

function MsgHandler.hero_storage_take_out(arg_4_0)
	Storage:applyTakeOut(arg_4_0)
end

function HANDLER.unit_storage(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_reset" then
		Storage:reset()
	elseif arg_5_1 == "btn_add_inven" then
		Storage:showIncDialog()
	elseif arg_5_1 == "btn_change" then
		Storage:applyChanged()
	elseif string.starts(arg_5_1, "btn_remove") then
		Storage:touchStorageItem(arg_5_0, string.split(arg_5_1, ":")[2])
	end
end

Storage = {}

function Storage.show(arg_6_0, arg_6_1, arg_6_2)
	if ContentDisable:byAlias("waitingroom") then
		balloon_message(T("content_disable"))
		SceneManager:popScene()
		
		return 
	end
	
	arg_6_0.vars = {}
	arg_6_0.vars.layer = arg_6_1 or SceneManager:getDefaultLayer()
	arg_6_0.vars.base_wnd = load_dlg("unit_storage", true, "wnd")
	
	arg_6_0.vars.layer:addChild(arg_6_0.vars.base_wnd)
	
	arg_6_0.vars.mode = "init"
	arg_6_0.vars.slots = {}
	arg_6_0.vars.unit_color_table = {
		wind = 3,
		fire = 5,
		light = 2,
		dark = 1,
		ice = 4
	}
	
	TopBarNew:create(T("waitingroom_title"), arg_6_0.vars.base_wnd, function()
		SceneManager:popScene()
	end)
	
	AccountData.storage_unit_inven = to_n(AccountData.storage_unit_inven or GAME_CONTENT_VARIABLE.inven_waitingroom_hero)
	
	local var_6_0 = 0
	
	for iter_6_0, iter_6_1 in pairs(AccountData.stored_units or {}) do
		var_6_0 = var_6_0 + 1
	end
	
	local var_6_1 = math.max(AccountData.storage_unit_inven, var_6_0)
	
	for iter_6_2 = 1, var_6_1 do
		arg_6_0.vars.slots[iter_6_2] = {
			is_disabled = false,
			is_temp = false,
			idx = iter_6_2
		}
	end
	
	arg_6_0.vars.unit_dock = HeroBelt:create("Storage")
	
	HeroBelt:showSortButton(true)
	arg_6_0.vars.unit_dock:setEventHandler(arg_6_0.onHeroListEvent, arg_6_0)
	arg_6_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	
	local var_6_2 = arg_6_0.vars.base_wnd:getChildByName("n_unit_list")
	
	var_6_2:removeAllChildren()
	var_6_2:addChild(arg_6_0.vars.unit_dock:getWindow())
	arg_6_0:switchMode(nil)
	
	arg_6_0.vars.listview = ItemListView_v2:bindControl(arg_6_0.vars.base_wnd:getChildByName("listview"))
	
	local var_6_3 = {
		onUpdate = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			local var_8_0 = Storage:getSlotItem(arg_8_2)
			
			Storage:updateItemRender(arg_8_1, var_8_0)
			
			return var_8_0.idx
		end
	}
	
	arg_6_0.vars.listview:setRenderer(load_control("wnd/unit_storage_item.csb"), var_6_3)
	arg_6_0.vars.listview:removeAllChildren()
	arg_6_0.vars.listview:setDataSource(arg_6_0.vars.slots)
	arg_6_0.vars.listview:jumpToTop()
	arg_6_0:updateStorageUnitInven()
	arg_6_0:updateSelectedCount()
	
	if not AccountData.stored_units then
		query("hero_storage_list")
	else
		arg_6_0:updateStoredHeroes()
	end
end

function Storage.isTakeOutMode(arg_9_0)
	if not arg_9_0.vars then
		return false
	end
	
	return arg_9_0.vars.mode == "takeout"
end

function Storage.applyChanged(arg_10_0)
	if arg_10_0.vars.mode == "putin" then
		local var_10_0 = {
			list = {},
			slot = {}
		}
		
		for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.slots) do
			if iter_10_1.is_temp == true and iter_10_1.unit then
				table.push(var_10_0.list, iter_10_1.unit:getUID())
				table.push(var_10_0.slot, iter_10_0)
			end
		end
		
		if #var_10_0.list < 1 then
			return 
		end
		
		Dialog:msgBox(T("waitingroom_move_desc", {
			value = #var_10_0.list
		}), {
			yesno = true,
			title = T("waitingroom_move_title"),
			handler = function()
				query("hero_storage_put_in", {
					putin = json.encode(var_10_0)
				})
			end
		})
	elseif arg_10_0.vars.mode == "takeout" then
		local var_10_1 = {
			list = {},
			slot = {}
		}
		
		for iter_10_2, iter_10_3 in pairs(arg_10_0.vars.slots) do
			if iter_10_3.is_temp == true and iter_10_3.unit then
				table.push(var_10_1.list, iter_10_3.unit:getUID())
				table.push(var_10_1.slot, iter_10_2)
			end
		end
		
		if #var_10_1.list < 1 then
			return 
		end
		
		Dialog:msgBox(T("waitingroom_move_desc", {
			value = #var_10_1.list
		}), {
			yesno = true,
			title = T("waitingroom_move_title"),
			handler = function()
				query("hero_storage_take_out", {
					takeout = json.encode(var_10_1)
				})
			end
		})
	end
end

function Storage.applyPutIn(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_1.add_storage or {}) do
		AccountData.stored_units[tostring(iter_13_1.id)] = iter_13_1
	end
	
	local var_13_0 = arg_13_1.putin
	
	for iter_13_2, iter_13_3 in pairs(var_13_0.list or {}) do
		Account:removeUnit(Account:getUnit(iter_13_3))
	end
	
	for iter_13_4, iter_13_5 in pairs(var_13_0.slot or {}) do
		arg_13_0.vars.slots[iter_13_5].is_temp = false
	end
	
	arg_13_0.vars.listview:removeAllChildren()
	arg_13_0:updateStoredHeroes(true)
	arg_13_0:reset()
end

function Storage.applyTakeOut(arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_1.remove_storage or {}) do
		AccountData.stored_units[tostring(iter_14_1.id)] = nil
		
		Account:addUnit(iter_14_1, nil, nil, nil, {
			storage_takeout = true
		})
	end
	
	HeroBelt:resetDataUseFilter(Account.units, "Storage", nil)
	arg_14_0.vars.listview:removeAllChildren()
	arg_14_0:updateStoredHeroes(true)
	arg_14_0:reset()
end

function Storage.getSlotItem(arg_15_0, arg_15_1)
	return arg_15_0.vars.slots[arg_15_1]
end

function Storage.updateItemRender(arg_16_0, arg_16_1, arg_16_2)
	if not get_cocos_refid(arg_16_1) then
		return 
	end
	
	local var_16_0 = arg_16_1:getChildByName("n_unit_bar")
	
	var_16_0:removeAllChildren()
	
	local var_16_1 = arg_16_1:getChildByName("btn_remove")
	
	if arg_16_2.unit then
		local var_16_2 = UIUtil:updateUnitBar("Storage", arg_16_2.unit)
		
		if var_16_2 then
			if get_cocos_refid(var_16_1) then
				var_16_1:setName("btn_remove:" .. arg_16_2.idx)
			end
			
			var_16_0:addChild(var_16_2)
			
			if arg_16_2.is_temp == true then
				EffectManager:Play({
					scale = 1.35,
					fn = "hero_up_slotglow_nomal.cfx",
					y = 44,
					x = 187,
					layer = var_16_2
				})
			end
			
			if arg_16_2.is_disabled == true then
				arg_16_1:setColor(cc.c3b(80, 80, 80))
			else
				arg_16_1:setColor(cc.c3b(255, 255, 255))
			end
		end
	end
end

function Storage.reset(arg_17_0, arg_17_1)
	if not arg_17_0.vars or arg_17_0.vars.mode == nil then
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.slots) do
		if arg_17_0.vars.mode == "putin" then
			if iter_17_1.is_temp == true then
				HeroBelt:revertPoppedItem(iter_17_1.unit)
				
				iter_17_1.unit = nil
				iter_17_1.is_temp = false
			end
		elseif arg_17_0.vars.mode == "takeout" and iter_17_1.is_temp == true then
			iter_17_1.is_temp = false
		end
	end
	
	arg_17_0:switchMode(nil)
	arg_17_0.vars.listview:setDataSource(arg_17_0.vars.slots)
	
	if not arg_17_1 then
		arg_17_0:updateStorageUnitInven()
		arg_17_0:updateSelectedCount()
	end
end

function Storage.onHeroListEvent(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_1 == "select" then
		arg_18_0:onSelectUnit(arg_18_2, arg_18_3)
	elseif arg_18_1 == "change" and HeroBelt:isScrolling() then
		vibrate(VIBRATION_TYPE.Select)
	end
end

function Storage.switchMode(arg_19_0, arg_19_1)
	if arg_19_0.vars.mode ~= arg_19_1 then
		arg_19_0.vars.mode = arg_19_1
	else
		return false
	end
	
	local var_19_0 = arg_19_0.vars.base_wnd:getChildByName("n_center")
	local var_19_1 = arg_19_0.vars.base_wnd:getChildByName("n_storage")
	local var_19_2 = var_19_0:getChildByName("n_action")
	
	if arg_19_1 == "putin" then
		var_19_2:setVisible(true)
		if_set_visible(var_19_2, "arrow_l", true)
		if_set_visible(var_19_2, "arrow_r", false)
		if_set_visible(var_19_0, "n_no_data", false)
		if_set(var_19_0, "t_action", T("waitingroom_desc04"))
		if_set(var_19_2, "t_disc_choose", T("waitingroom_desc06"))
		if_set_opacity(var_19_1, "n_btn", 255)
		
		for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.slots) do
			if iter_19_1.unit then
				iter_19_1.is_disabled = true
			end
		end
	elseif arg_19_1 == "takeout" then
		var_19_2:setVisible(true)
		if_set_visible(var_19_2, "arrow_l", false)
		if_set_visible(var_19_2, "arrow_r", true)
		if_set_visible(var_19_0, "n_no_data", false)
		if_set(var_19_0, "t_action", T("waitingroom_desc03"))
		if_set(var_19_2, "t_disc_choose", T("waitingroom_desc06"))
		if_set_opacity(var_19_1, "n_btn", 255)
		HeroBelt:resetDataUseFilter(Account.units, "Storage", nil)
		
		for iter_19_2, iter_19_3 in pairs(arg_19_0.vars.slots) do
			if iter_19_3.unit then
				iter_19_3.is_disabled = false
			end
		end
	else
		var_19_2:setVisible(false)
		if_set(var_19_0, "t_action", T("waitingroom_desc02"))
		if_set_visible(var_19_0, "n_no_data", true)
		if_set(var_19_0:getChildByName("n_no_data"), "label", T("waitingroom_desc05"))
		if_set_opacity(var_19_1, "n_btn", 76.5)
		HeroBelt:resetDataUseFilter(Account.units, "Storage", nil)
		
		for iter_19_4, iter_19_5 in pairs(arg_19_0.vars.slots) do
			if iter_19_5.unit then
				iter_19_5.is_disabled = false
			end
		end
	end
	
	return true
end

function Storage.onSelectUnit(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0.vars.mode ~= nil and arg_20_0.vars.mode ~= "putin" then
		return 
	end
	
	local var_20_0 = to_n(GAME_CONTENT_VARIABLE.inven_waitingroom_select_limit or 10)
	local var_20_1 = arg_20_0:countTempSlots()
	
	if var_20_0 <= var_20_1 then
		balloon_message_with_sound("waitingroom_noti2", {
			max = var_20_0
		})
		
		return 
	end
	
	local var_20_2 = to_n(GAME_CONTENT_VARIABLE.inven_waitingroom_hero_max)
	
	AccountData.storage_unit_inven = to_n(AccountData.storage_unit_inven or GAME_CONTENT_VARIABLE.inven_waitingroom_hero)
	
	if var_20_1 + table.count(AccountData.stored_units) >= AccountData.storage_unit_inven then
		if var_20_2 <= AccountData.storage_unit_inven then
			balloon_message_with_sound("waitingroom_error_noti")
			
			return 
		else
			Dialog:msgBox(T("waitingroom_error_desc"), {
				yesno = true,
				title = T("waitingroom_error_title"),
				handler = function()
					arg_20_0:showIncDialog()
				end
			})
			
			return 
		end
	end
	
	local var_20_3 = arg_20_1:getUsableCodeList(nil, "Storage")
	
	if var_20_3 then
		Dialog:msgUnitLock(var_20_3)
		
		return 
	end
	
	if arg_20_1.equips and table.count(arg_20_1.equips) > 0 then
		local var_20_4 = 0
		local var_20_5 = {
			unequip = {},
			equip = {}
		}
		
		var_20_5.unequip[tostring(arg_20_1:getUID())] = {}
		
		for iter_20_0, iter_20_1 in pairs(arg_20_1.equips) do
			var_20_4 = var_20_4 + iter_20_1:getUnequipCost()
			
			table.push(var_20_5.unequip[tostring(arg_20_1:getUID())], iter_20_1.id)
		end
		
		Dialog:msgBox(T("waitingroom_undress_desc"), {
			token = "to_gold",
			yesno = true,
			title = T("waitingroom_undress_title"),
			cost = var_20_4,
			handler = function()
				if UIUtil:checkTotalInven() == false then
					return 
				end
				
				query("puton_equip_mass", {
					caller = "storage",
					putons = json.encode(var_20_5)
				})
			end
		})
	else
		arg_20_0:addSlotPutIn(arg_20_1)
	end
end

function Storage.addSlotPutIn(arg_23_0, arg_23_1)
	local var_23_0 = 0
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.slots) do
		if not iter_23_1.unit then
			var_23_0 = iter_23_0
			
			break
		end
	end
	
	if var_23_0 < 1 then
		return 
	end
	
	local var_23_1 = arg_23_0:switchMode("putin")
	
	HeroBelt:popItem(arg_23_1)
	vibrate(VIBRATION_TYPE.Select)
	SoundEngine:play("event:/ui/upgrade/slot_in")
	
	arg_23_0.vars.slots[var_23_0].unit = arg_23_1
	arg_23_0.vars.slots[var_23_0].is_temp = true
	
	arg_23_0.vars.listview:setDataSource(arg_23_0.vars.slots)
	arg_23_0:updateSelectedCount()
	
	local var_23_2 = arg_23_0:updateStorageUnitInven()
	
	if var_23_1 then
		local var_23_3 = arg_23_0.vars.listview:getInnerContainerSize()
		local var_23_4 = arg_23_0.vars.listview:getContentSize()
		
		var_23_3.height = var_23_3.height - var_23_4.height
		
		local var_23_5 = var_23_3.height / 92
		local var_23_6 = math.floor(var_23_3.width / 267)
		local var_23_7 = 100 / var_23_5
		local var_23_8 = math.floor((var_23_2 - 1) / var_23_6)
		
		arg_23_0.vars.listview:jumpToPercentVertical(math.min(var_23_8 * var_23_7, 100))
	end
end

function Storage.touchStorageItem(arg_24_0, arg_24_1, arg_24_2)
	arg_24_2 = to_n(arg_24_2)
	
	if arg_24_2 < 1 then
		return 
	end
	
	if arg_24_0.vars.mode == "putin" then
		local var_24_0 = arg_24_0.vars.slots[arg_24_2]
		
		if not var_24_0 or var_24_0.is_temp ~= true or not var_24_0.unit then
			return 
		end
		
		HeroBelt:revertPoppedItem(var_24_0.unit)
		
		var_24_0.unit = nil
		var_24_0.is_temp = false
		
		if arg_24_2 == #arg_24_0.vars.slots then
			arg_24_0:updateItemRender(arg_24_0.vars.listview:getControl(var_24_0), var_24_0)
		else
			for iter_24_0 = arg_24_2, #arg_24_0.vars.slots do
				local var_24_1 = arg_24_0.vars.slots[iter_24_0 + 1]
				
				if not var_24_1 then
					if iter_24_0 + 1 > #arg_24_0.vars.slots then
						var_24_1 = {
							is_disabled = false,
							is_temp = false,
							idx = #arg_24_0.vars.slots + 1
						}
					else
						break
					end
				end
				
				arg_24_0.vars.slots[iter_24_0].unit = var_24_1.unit
				arg_24_0.vars.slots[iter_24_0].is_temp = var_24_1.is_temp
				
				arg_24_0:updateItemRender(arg_24_0.vars.listview:getControl(arg_24_0.vars.slots[iter_24_0]), var_24_1)
				
				if arg_24_0.vars.slots[iter_24_0 + 2] then
					arg_24_0:updateItemRender(arg_24_0.vars.listview:getControl(var_24_1), arg_24_0.vars.slots[iter_24_0 + 2])
				end
				
				if not var_24_1.unit then
					break
				end
			end
		end
		
		arg_24_0:updateSelectedCount()
		arg_24_0:updateStorageUnitInven()
	else
		local var_24_2 = arg_24_0.vars.slots[arg_24_2]
		
		if not var_24_2 or not var_24_2.unit then
			return 
		end
		
		if var_24_2.is_temp == false then
			local var_24_3 = arg_24_0:countTempSlots()
			local var_24_4 = to_n(GAME_CONTENT_VARIABLE.inven_waitingroom_select_limit or 10)
			
			if var_24_4 <= var_24_3 then
				balloon_message_with_sound("waitingroom_noti2", {
					max = var_24_4
				})
				
				return 
			end
			
			if not UIUtil:checkUnitInven(var_24_3) then
				return 
			end
		end
		
		arg_24_0:switchMode("takeout")
		
		var_24_2.is_temp = not var_24_2.is_temp
		
		arg_24_0:updateItemRender(arg_24_1:getParent(), var_24_2)
		
		for iter_24_1, iter_24_2 in pairs(arg_24_0.vars.slots) do
			if iter_24_2.is_temp == true then
				arg_24_0:updateItemRender(arg_24_0.vars.listview:getControl(iter_24_2), iter_24_2)
			end
		end
		
		arg_24_0:updateSelectedCount()
		arg_24_0:updateStorageUnitInven()
	end
end

function Storage.updateStoredHeroes(arg_25_0, arg_25_1)
	local var_25_0 = {}
	local var_25_1 = 0
	
	for iter_25_0, iter_25_1 in pairs(AccountData.stored_units) do
		var_25_1 = var_25_1 + 1
		
		local var_25_2, var_25_3 = DB("character", iter_25_1.code, {
			"grade",
			"ch_attribute"
		})
		
		iter_25_1.sort = iter_25_1.g * 1000000000 + var_25_2 * 100000000 + to_n(arg_25_0.vars.unit_color_table[var_25_3]) * 10000000 + to_n(string.sub(iter_25_1.code, 2, -1)) * 1000 + var_25_1
		
		table.push(var_25_0, iter_25_1)
	end
	
	table.sort(var_25_0, function(arg_26_0, arg_26_1)
		return arg_26_0.sort > arg_26_1.sort
	end)
	
	AccountData.storage_unit_inven = to_n(AccountData.storage_unit_inven or GAME_CONTENT_VARIABLE.inven_waitingroom_hero)
	
	local var_25_4 = math.max(AccountData.storage_unit_inven, #var_25_0)
	
	if arg_25_1 then
		arg_25_0.vars.slots = {}
		
		for iter_25_2 = 1, var_25_4 do
			arg_25_0.vars.slots[iter_25_2] = {
				is_disabled = false,
				is_temp = false,
				idx = iter_25_2
			}
		end
	end
	
	for iter_25_3, iter_25_4 in pairs(var_25_0) do
		arg_25_0.vars.slots[iter_25_3].unit = UNIT:create(iter_25_4)
		arg_25_0.vars.slots[iter_25_3].is_temp = false
	end
	
	arg_25_0:updateSelectedCount()
	arg_25_0:updateStorageUnitInven()
	arg_25_0.vars.listview:setDataSource(arg_25_0.vars.slots)
end

function Storage.updateStorageUnitInven(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.vars.base_wnd:getChildByName("n_right"):getChildByName("btn_add_inven")
	local var_27_1 = 0
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.slots) do
		if iter_27_1.unit then
			var_27_1 = var_27_1 + 1
		end
	end
	
	if arg_27_0.vars.mode == "takeout" then
		var_27_1 = var_27_1 - arg_27_0:countTempSlots()
	end
	
	AccountData.storage_unit_inven = to_n(AccountData.storage_unit_inven or GAME_CONTENT_VARIABLE.inven_waitingroom_hero)
	
	if_set(var_27_0, "t_count", var_27_1 .. "/" .. AccountData.storage_unit_inven)
	
	if arg_27_1 then
		local var_27_2 = 0
		
		for iter_27_2, iter_27_3 in pairs(AccountData.stored_units) do
			var_27_2 = var_27_2 + 1
		end
		
		local var_27_3 = math.max(AccountData.storage_unit_inven, var_27_2)
		
		for iter_27_4 = 1, var_27_3 do
			if arg_27_0.vars.slots[iter_27_4] == nil then
				arg_27_0.vars.slots[iter_27_4] = {
					is_disabled = false,
					is_temp = false,
					idx = iter_27_4
				}
			end
		end
		
		arg_27_0.vars.listview:removeAllChildren()
		arg_27_0.vars.listview:setDataSource(arg_27_0.vars.slots)
	end
	
	return var_27_1
end

function Storage.countTempSlots(arg_28_0)
	local var_28_0 = 0
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.slots) do
		if iter_28_1.is_temp == true then
			var_28_0 = var_28_0 + 1
		end
	end
	
	return var_28_0
end

function Storage.updateSelectedCount(arg_29_0)
	local var_29_0 = arg_29_0.vars.base_wnd:getChildByName("n_left")
	local var_29_1 = arg_29_0:countTempSlots()
	
	if_set(var_29_0, "t_count", T("waitingroom_desc07", {
		curr = var_29_1,
		max = to_n(GAME_CONTENT_VARIABLE.inven_waitingroom_select_limit or 10)
	}))
	UIUserData:call(var_29_0:getChildByName("t_count"), "RICH_LABEL(true)")
	
	if var_29_1 == 0 then
		arg_29_0:switchMode(nil)
		arg_29_0.vars.listview:setDataSource(arg_29_0.vars.slots)
	end
end

function Storage.uniUniequipped(arg_30_0, arg_30_1)
	Account:updateCurrencies(arg_30_1)
	TopBarNew:topbarUpdate(true)
	
	for iter_30_0, iter_30_1 in pairs(arg_30_1.putons.unequip) do
		local var_30_0 = Account:getUnit(tonumber(iter_30_0))
		
		arg_30_0:addSlotPutIn(var_30_0)
		
		for iter_30_2, iter_30_3 in pairs(iter_30_1) do
			local var_30_1 = Account:getEquip(tonumber(iter_30_3))
			
			if var_30_0 ~= nil and var_30_1 ~= nil then
				var_30_0:removeEquip(var_30_1)
			end
		end
	end
end

function Storage.showIncDialog(arg_31_0)
	if not AccountData.stored_units then
		return 
	end
	
	local var_31_0 = to_n(GAME_CONTENT_VARIABLE.inven_waitingroom_hero_max)
	local var_31_1 = to_n(AccountData.storage_unit_inven or GAME_CONTENT_VARIABLE.inven_waitingroom_hero)
	
	if var_31_0 <= var_31_1 then
		balloon_message_with_sound("waitingroom_noti")
		
		return 
	end
	
	local var_31_2 = (var_31_0 - var_31_1) / 5
	local var_31_3 = 0
	
	for iter_31_0 = 1, var_31_0 do
		if var_31_3 * GAME_CONTENT_VARIABLE.inven_waitingroom_hero_add_price > Account:getCurrency("crystal") then
			break
		end
		
		var_31_3 = iter_31_0
	end
	
	if var_31_3 < 1 then
		balloon_message_with_sound("no_crystal")
		
		return 
	end
	
	local var_31_4 = {
		slider_pos = 1,
		min = 1,
		yesno = true,
		slider_handler = function(arg_32_0, arg_32_1, arg_32_2)
			if_set(arg_32_0, "txt_title", T("waitingroom_add_title"))
			if_set(arg_32_0, "txt_add_count", "+" .. comma_value(arg_32_1 * 5))
			if_set(arg_32_0, "text", T("waitingroom_add_desc", {
				count = arg_32_1 * 5
			}))
			if_set(arg_32_0, "txt_slide", arg_32_1 * 5 + var_31_1 .. "/" .. 5 * var_31_2 + var_31_1)
			
			arg_32_0.need_crystal = GAME_CONTENT_VARIABLE.inven_waitingroom_hero_add_price * arg_32_1
			
			if_set(arg_32_0, "txt_rest", comma_value(arg_32_0.need_crystal))
			UIUtil:changeButtonState(arg_32_0.c.btn_yes, Account:getCurrency("crystal") >= arg_32_0.need_crystal, true)
		end,
		token = GAME_CONTENT_VARIABLE.inven_waitingroom_hero_add_token,
		max = var_31_2,
		handler = function(arg_33_0, arg_33_1, arg_33_2)
			if not UIUtil:checkCurrencyDialog("crystal", to_n(arg_33_0.need_crystal)) then
				return 
			end
			
			local var_33_0 = arg_33_0.slider:getPercent()
			
			if var_33_0 > 0 then
				query("inc_hero_storage_unit_inven", {
					value = var_33_0
				})
			end
		end
	}
	local var_31_5 = Dialog:msgBoxSlider(var_31_4)
end
