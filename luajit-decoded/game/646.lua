EquipStorage = {}
EquipStorageMode = {
	Manage = "EquipStorageManage",
	Main = "EquipStorageMain"
}
EquipStorageMain = {}
EquipStorageManage = {}

function HANDLER_BEFORE.equip_storage(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 == "btn_select" then
		arg_1_0.touch_tick = systick()
	end
end

HANDLER_BEFORE.equip_storage_manage = HANDLER_BEFORE.equip_storage

function HANDLER.equip_storage(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_bulk_up" then
		if EquipStorageMain.vars.mode ~= EquipStorageMainMode.Waiting then
			balloon_message_with_sound("storage_err_01")
			
			return 
		end
		
		EquipStorage:setMode(EquipStorageMode.Manage)
	elseif arg_2_1 == "btn_select" then
		local var_2_0 = arg_2_0:getParent().datasource
		local var_2_1 = getParentWindow(arg_2_0):getName()
		
		if var_2_0 and systick() - to_n(arg_2_0.touch_tick) < 180 then
			if var_2_1 == "equip_storage_manage" and not EquipStorageManage:isSellMode() then
				InventoryPopupDetail:Open(var_2_0)
			else
				if var_2_0.lock and EquipStorageManage:isSellMode() then
					balloon_message_with_sound("sell_cant_lock")
					
					return 
				end
				
				EquipStorageMain:stackEquip(var_2_0.id, var_2_0.list_type, arg_2_0:getParent())
			end
		end
	elseif arg_2_1 == "btn_change" then
		EquipStorageMain:commit()
	elseif arg_2_1 == "btn_reset" then
		EquipStorageMain:reset()
	elseif arg_2_1 == "btn_count" then
		if arg_2_0:getParent():getParent():getParent():getName() == "equip_storage_manage" then
			UIUtil:showIncEquipStorageDialog()
		else
			if EquipStorageMain.vars.mode ~= EquipStorageMainMode.Take and EquipStorageMain.vars.mode ~= EquipStorageMainMode.Waiting then
				balloon_message_with_sound("storage_err_01")
				
				return 
			end
			
			UIUtil:showIncEquipInvenDialog()
		end
	elseif arg_2_1 == "btn_count_storage" then
		if EquipStorageMain.vars.mode ~= EquipStorageMainMode.Stack and EquipStorageMain.vars.mode ~= EquipStorageMainMode.Waiting then
			balloon_message_with_sound("storage_err_01")
			
			return 
		end
		
		UIUtil:showIncEquipStorageDialog()
	elseif string.starts(arg_2_1, "btn_equip_tab") then
		local var_2_2 = arg_2_0:getParent():getName()
		local var_2_3 = arg_2_0:getParent():getParent():getName()
		
		if var_2_2 == "n_tab_storage" then
			if var_2_3 == "equip_storage_manage" then
				EquipStorage:toggleTab("storage", to_n(string.sub(arg_2_1, -1, -1)), EquipStorageManage.vars.listview_normal, arg_2_0:getParent(), true)
			else
				if EquipStorageMain.vars.mode ~= EquipStorageMainMode.Stack and EquipStorageMain.vars.mode ~= EquipStorageMainMode.Waiting then
					balloon_message_with_sound("storage_err_01")
					
					return 
				end
				
				EquipStorage:toggleTab("storage", to_n(string.sub(arg_2_1, -1, -1)), EquipStorageMain.vars.listview_left, arg_2_0:getParent())
			end
		else
			if EquipStorageMain.vars.mode ~= EquipStorageMainMode.Take and EquipStorageMain.vars.mode ~= EquipStorageMainMode.Waiting then
				balloon_message_with_sound("storage_err_01")
				
				return 
			end
			
			EquipStorage:toggleTab("inventory", to_n(string.sub(arg_2_1, -1, -1)), EquipStorageMain.vars.listview_right, arg_2_0:getParent())
		end
	elseif arg_2_1 == "btn_delete" or arg_2_1 == "btn_delete_after" then
		EquipStorageManage:toggleSellMode()
	elseif arg_2_1 == "btn_sell" then
		EquipStorageManage:send("sell_equips")
	elseif arg_2_1 == "btn_extract" then
		EquipStorageManage:send("alchemist_point_extract")
	elseif arg_2_1 == "btn_autoselect" then
		EquipStorageManage:toggleAutoselectMode()
	end
end

HANDLER.equip_storage_manage = HANDLER.equip_storage

function HANDLER.inventory_autosel_storage(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		EquipStorageManage:autoSelect()
		
		return 
	end
	
	if string.starts(arg_3_1, "btn_checkbox_") then
		local var_3_0 = string.sub(arg_3_1, 14, -1)
		
		arg_3_1 = "checkbox_" .. var_3_0
		arg_3_0 = getParentWindow(arg_3_0):getChildByName(arg_3_1)
		
		arg_3_0:setSelected(not arg_3_0:isSelected())
	end
	
	if string.starts(arg_3_1, "checkbox_") then
		local var_3_1 = string.sub(arg_3_1, 10, -1)
		
		EquipStorageManage:updateSelectButton(var_3_1)
	end
	
	if arg_3_1 == "btn_set" or arg_3_1 == "btn_set_done" or arg_3_1 == "btn_mainstat" or arg_3_1 == "btn_mainstat_done" or arg_3_1 == "btn_substat1" or arg_3_1 == "btn_substat1_done" or arg_3_1 == "btn_substat2" or arg_3_1 == "btn_substat2_done" then
		EquipStorageManage:onClickEventExtentionFilter(arg_3_1)
	end
end

function MsgHandler.equip_storage_list(arg_4_0)
	AccountData.equip_storage = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.equip_storage or {}) do
		local var_4_0 = EQUIP:createByInfo(iter_4_1)
		
		var_4_0.list_type = "storage"
		
		table.insert(AccountData.equip_storage, var_4_0)
	end
	
	if arg_4_0.caller == "storage" then
		EquipStorage:init(Scene.equip_storage.args)
	elseif arg_4_0.caller == "inventory" then
		InventoryPopupDetail:onStorage()
	end
end

function MsgHandler.equip_storage_put_in(arg_5_0)
	for iter_5_0, iter_5_1 in pairs(arg_5_0.updated_equip_storage or {}) do
		iter_5_1.selected = nil
		
		Account:addEquipStorage(iter_5_1.id)
	end
	
	for iter_5_2, iter_5_3 in pairs(arg_5_0.deleted_equip_id or {}) do
		Account:removeEquip(iter_5_3)
	end
	
	if EquipStorageMain:isActive() then
		EquipStorageMain:resetListViewItems()
		EquipStorageMain:reset()
	end
	
	if Inventory:isShow() then
		Inventory:UpdateContents(nil, {
			do_not_keep_pos = false
		})
	end
	
	if InventoryPopupDetail:IsOpen() then
		InventoryPopupDetail:Close()
	end
	
	if UnitEquip:isVisible() then
		UnitEquip:updateInfos()
	end
	
	balloon_message_with_sound("msg_equip_moved_storage")
end

function MsgHandler.equip_storage_take_out(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(arg_6_0.updated_equips or {}) do
		Account:addEquip(iter_6_1, {
			ignore_get_condition = true
		})
	end
	
	for iter_6_2, iter_6_3 in pairs(arg_6_0.deleted_stored_id or {}) do
		Account:removeEquipStorage(iter_6_3)
	end
	
	EquipStorageMain:resetListViewItems()
	EquipStorageMain:reset()
end

function MsgHandler.inc_equip_storage_inven(arg_7_0)
	local var_7_0 = AccountData.storage_equip_inven
	
	AccountData.storage_equip_inven = arg_7_0.storage_equip_inven
	
	if EquipStorageMain:isActive() then
		EquipStorageMain:reset()
		EquipStorageMain:resetListViewItems()
		EquipStorageManage:resetUI()
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.currency) do
		Account:setCurrency(iter_7_0, iter_7_1)
	end
	
	TopBarNew:topbarUpdate(true)
	Dialog:msgBoxLevelUp({
		text = T("storage_add_noti"),
		title = T("storage_confirm_title"),
		after_score = arg_7_0.storage_equip_inven,
		before_score = var_7_0
	})
	SoundEngine:play("event:/ui/inc_equip_inven")
end

local function var_0_0(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not EquipStorageMain.vars or not get_cocos_refid(arg_8_1) or not arg_8_3 then
		return 
	end
	
	local var_8_0
	
	if EquipStorageMain.vars.selected then
		var_8_0 = EquipStorageMain.vars.selected.storage[arg_8_3.id] or EquipStorageMain.vars.selected.inventory[arg_8_3.id]
	end
	
	if_set_visible(arg_8_1, "n_select", var_8_0)
	
	local var_8_1 = arg_8_1:getChildByName("bg_item")
	local var_8_2 = UIUtil:getRewardIcon("equip", arg_8_3.code, {
		tooltip_delay = 130,
		parent = var_8_1,
		equip = arg_8_3
	})
	
	if_set_visible(arg_8_1, "equip", arg_8_3 and arg_8_3.parent)
	if_set_visible(arg_8_1, "icon_type", false)
	if_set_visible(arg_8_1, "n_txt_value", false)
	if_set_visible(arg_8_1, "n_img_value", false)
	if_set_visible(arg_8_1, "t_equip_point", true)
	
	local var_8_3 = arg_8_1:getChildByName("t_equip_point")
	
	if get_cocos_refid(var_8_3) then
		local var_8_4 = arg_8_3:getEquipPoint()
		
		if_set(var_8_3, nil, var_8_4)
	end
	
	arg_8_1.datasource = arg_8_3
end

local function var_0_1(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not EquipStorageMain.vars then
		return 
	end
	
	local var_9_0
	
	if EquipStorageMain.vars.selected then
		var_9_0 = EquipStorageMain.vars.selected.storage[arg_9_3.id] or EquipStorageMain.vars.selected.inventory[arg_9_3.id]
	end
	
	if_set_visible(arg_9_1, "n_select", var_9_0)
	if_set_visible(arg_9_1, "icon_equip", arg_9_3 and arg_9_3.parent)
	
	local var_9_1 = UIUtil:getRewardIcon("equip", arg_9_3.code, {
		tooltip_delay = 130,
		parent = arg_9_1:getChildByName("n_reward_icon"),
		equip = arg_9_3
	})
	local var_9_2 = arg_9_1:getChildByName("txt_main_stat")
	local var_9_3 = arg_9_1:getChildByName("icon_main")
	local var_9_4 = UnitEquipUtil:getOptionsSumTable(arg_9_3)
	local var_9_5 = {}
	
	for iter_9_0 = 1, table.count(var_9_4 or {}) do
		local var_9_6 = table.clone(var_9_4[iter_9_0])
		
		if UNIT.is_percentage_stat(var_9_6[1]) then
			var_9_6[2] = to_var_str(var_9_6[2], var_9_6[1])
		else
			var_9_6[2] = comma_value(math.floor(var_9_6[2]))
		end
		
		table.insert(var_9_5, var_9_6)
	end
	
	local var_9_7, var_9_8 = arg_9_3:getMainStat()
	local var_9_9 = false
	
	if UNIT.is_percentage_stat(var_9_8) then
		var_9_7 = to_var_str(var_9_7, var_9_8)
		
		local var_9_10 = true
	else
		var_9_7 = comma_value(math.floor(var_9_7))
	end
	
	if var_9_3 then
		SpriteCache:resetSprite(var_9_3, "img/cm_icon_stat_" .. string.gsub(var_9_8, "_rate", "") .. ".png")
	end
	
	if_set(var_9_2, nil, var_9_7)
	
	if var_9_0 and Account:isUnlockExtract() and EquipStorageManage:isSellMode() then
		if_set_visible(arg_9_1, "n_extract", not arg_9_3:isExtractable())
	else
		if_set_visible(arg_9_1, "n_extract", false)
	end
	
	for iter_9_1 = 1, 4 do
		if_set_visible(arg_9_1, "n_type" .. iter_9_1, var_9_5[iter_9_1])
		
		if var_9_5[iter_9_1] then
			SpriteCache:resetSprite(arg_9_1:getChildByName("icon_type" .. iter_9_1), "img/cm_icon_stat_" .. string.gsub(var_9_5[iter_9_1][1], "_rate", "") .. ".png")
			if_set(arg_9_1, "txt_stat" .. iter_9_1, var_9_5[iter_9_1][2])
		end
	end
	
	local var_9_11 = EquipStorageManage:isSellMode() and (arg_9_3.parent or arg_9_3.lock) or arg_9_3.block
	
	if_set_cascade_color(var_9_1, nil, false)
	
	if var_9_11 then
		for iter_9_2, iter_9_3 in pairs(var_9_1:getChildren()) do
			if_set_color(iter_9_3, nil, cc.c3b(55, 55, 55))
		end
		
		for iter_9_4, iter_9_5 in pairs(arg_9_1:getChildren()) do
			if_set_color(iter_9_5, nil, cc.c3b(55, 55, 55))
		end
		
		if_set_color(arg_9_1, "icon_equip", cc.c3b(255, 255, 255))
		if_set_color(arg_9_1, "icon_new", cc.c3b(255, 255, 255))
	else
		for iter_9_6, iter_9_7 in pairs(var_9_1:getChildren()) do
			if_set_color(iter_9_7, nil, cc.c3b(255, 255, 255))
		end
		
		if_set_color(var_9_1, "n_lv", tocolor("#FFDC7F"))
		
		for iter_9_8, iter_9_9 in pairs(arg_9_1:getChildren()) do
			if_set_color(iter_9_9, nil, cc.c3b(255, 255, 255))
		end
	end
	
	if_set_color(var_9_1, "locked", cc.c3b(255, 255, 255))
	
	arg_9_1.datasource = arg_9_3
end

EquipStorageTabType = {
	Weapon = 1,
	Armor = 2,
	Boots = 5,
	Ring = 6,
	Helm = 4,
	All = 0,
	Neck = 3
}

function EquipStorage.getLastTab(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	return arg_10_1 == "storage" and arg_10_0.vars.left_tab or arg_10_0.vars.right_tab
end

function EquipStorage.toggleTab(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = EquipStorage:getEquipList(arg_11_1)
	
	arg_11_0.vars.left_tab = arg_11_0.vars.left_tab or 0
	arg_11_0.vars.right_tab = arg_11_0.vars.right_tab or 0
	
	for iter_11_0 = 0, 6 do
		if iter_11_0 == arg_11_2 then
			if arg_11_1 == "storage" then
				arg_11_0.vars.left_tab = iter_11_0
			else
				arg_11_0.vars.right_tab = iter_11_0
			end
		end
		
		if get_cocos_refid(arg_11_4) then
			if_set_visible(arg_11_4:getChildByName("btn_equip_tab" .. iter_11_0), "bg_tab", iter_11_0 == arg_11_2)
		end
	end
	
	local var_11_1 = {}
	
	for iter_11_1, iter_11_2 in pairs(var_11_0 or {}) do
		if arg_11_2 == 0 then
			table.push(var_11_1, iter_11_2)
		elseif arg_11_2 == 1 and iter_11_2.db.type == "weapon" then
			table.push(var_11_1, iter_11_2)
		elseif arg_11_2 == 2 and iter_11_2.db.type == "armor" then
			table.push(var_11_1, iter_11_2)
		elseif arg_11_2 == 3 and iter_11_2.db.type == "neck" then
			table.push(var_11_1, iter_11_2)
		elseif arg_11_2 == 4 and iter_11_2.db.type == "helm" then
			table.push(var_11_1, iter_11_2)
		elseif arg_11_2 == 5 and iter_11_2.db.type == "boot" then
			table.push(var_11_1, iter_11_2)
		elseif arg_11_2 == 6 and iter_11_2.db.type == "ring" then
			table.push(var_11_1, iter_11_2)
		end
	end
	
	if EquipStorageMain.vars and EquipStorageMain.vars.selected and EquipStorageMain.vars.selected[arg_11_1] then
		for iter_11_3, iter_11_4 in pairs(EquipStorageMain.vars.selected[arg_11_1]) do
			if var_11_1[iter_11_3] then
				var_11_1[iter_11_3].selected = true
			end
		end
	end
	
	local var_11_2
	
	if arg_11_1 == "storage" and EquipStorageMain.vars.sorter_equip_left then
		var_11_2 = arg_11_0.vars.mode:getName() == EquipStorageMode.Manage and EquipStorageManage.vars.sorter_equip or EquipStorageMain.vars.sorter_equip_left
	elseif arg_11_1 == "inventory" and EquipStorageMain.vars.sorter_equip_right then
		var_11_2 = EquipStorageMain.vars.sorter_equip_right
	end
	
	SorterExtentionUtil:set_itemSetCounts(var_11_2.sorter_extention:get_setBox(), var_11_1)
	var_11_2:setItems(var_11_1)
	
	local var_11_3 = var_11_2:sort()
	
	if arg_11_3 then
		local var_11_4 = arg_11_3:getInnerContainerSize()
		
		arg_11_3:removeAllChildren()
		arg_11_3:setDataSource(var_11_3)
		
		local var_11_5 = arg_11_3:getInnerContainerSize()
		
		if not arg_11_3.old_scroll_pos then
			arg_11_3:jumpToTop()
		else
			arg_11_3.old_scroll_pos.y = arg_11_3.old_scroll_pos.y + (var_11_4.height - var_11_5.height)
			
			if arg_11_3.old_scroll_pos.y >= 0 then
				arg_11_3.old_scroll_pos.y = 0
				
				arg_11_3:setInnerContainerPosition(arg_11_3.old_scroll_pos)
			else
				arg_11_3:setInnerContainerPosition(arg_11_3.old_scroll_pos)
			end
			
			arg_11_3.old_scroll_pos = arg_11_3:getInnerContainerPosition()
		end
	end
	
	if arg_11_1 == "storage" then
		arg_11_0.vars.left_sorted = var_11_3
		
		if_set_visible(EquipStorageManage.vars and EquipStorageManage.vars.wnd, "n_info", table.count(var_11_3 or {}) <= 0)
		if_set_visible(EquipStorageManage.vars and EquipStorageManage.vars.wnd, "listview", table.count(var_11_3 or {}) > 0)
		if_set_visible(EquipStorageMain.vars.ui_left, "info", table.count(var_11_3) <= 0)
		if_set_visible(EquipStorageMain.vars.ui_left, "listview", table.count(var_11_3) > 0)
	else
		arg_11_0.vars.right_sorted = var_11_3
		
		if_set_visible(EquipStorageMain.vars.ui_right, "info", table.count(var_11_3) <= 0)
		if_set_visible(EquipStorageMain.vars.ui_right, "listview", table.count(var_11_3) > 0)
	end
	
	if EquipStorageManage:isSellMode() and arg_11_5 then
		EquipStorageMain.vars.selected = {}
		EquipStorageMain.vars.selected.storage = {}
		EquipStorageMain.vars.selected.inventory = {}
		
		if_set(EquipStorageManage.vars.wnd, "t_item_count", T("ui_extraction_select_inventory", {
			count = 0
		}))
		if_set_opacity(EquipStorageManage.vars.wnd, "btn_sell", 76.5)
		if_set_opacity(EquipStorageManage.vars.wnd, "btn_extract", 76.5)
	end
	
	return var_11_3
end

EquipStorageMainMode = {
	Take = "take",
	Stack = "stack",
	Waiting = "waiting"
}

function EquipStorageMain.onEnter(arg_12_0, arg_12_1)
	arg_12_0.vars = arg_12_0.vars or {}
	arg_12_1 = arg_12_1 or {}
	arg_12_0.vars.args = arg_12_1 or {}
	
	local var_12_0 = arg_12_1.layer or EquipStorage.vars.layer
	
	if not arg_12_0.vars.wnd then
		arg_12_0.vars.wnd = load_dlg("equip_storage", true, "wnd")
		arg_12_0.vars.ui_left = arg_12_0.vars.wnd:getChildByName("LEFT")
		arg_12_0.vars.ui_right = arg_12_0.vars.wnd:getChildByName("RIGHT")
		
		arg_12_0.vars.ui_left:setVisible(false)
		arg_12_0.vars.ui_right:setVisible(false)
		var_12_0:addChild(arg_12_0.vars.wnd)
	end
	
	if_set_visible(arg_12_0.vars.wnd, "btn_cancel", false)
	
	if get_cocos_refid(arg_12_0.vars.wnd:getChildByName("n_sorting_storage"):getChildByName("sorting_filter_equip")) then
		arg_12_0.vars.wnd:getChildByName("n_sorting_storage"):getChildByName("sorting_filter_equip"):removeFromParent()
		
		arg_12_0.vars.sorter_equip_left = nil
	end
	
	arg_12_0.vars.wnd:getChildByName("n_sorting_storage"):bringToFront()
	
	local var_12_1 = {
		{
			id = "show_point",
			is_filter = true,
			name = T("ui_equip_score_view"),
			checked = arg_12_0.vars.showEquipPoint_left
		}
	}
	
	arg_12_0.vars.sorter_equip_left = arg_12_0.vars.sorter_equip_left or Sorter:create(arg_12_0.vars.wnd:getChildByName("n_sorting_storage"), {
		is_inventory_equip = true,
		useExtention = true
	})
	
	arg_12_0.vars.sorter_equip_left:setSorter({
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
		checkboxs = var_12_1,
		callback_checkbox = function(arg_13_0, arg_13_1, arg_13_2)
			if arg_13_0 == "show_point" then
				arg_12_0:setShowEquipPointView(arg_13_2, "_left")
				arg_12_0:initListView("_left")
				arg_12_0:resetListViewItems()
				arg_12_0:reset()
			end
		end,
		close_callback = function()
			local var_14_0 = EquipStorage:toggleTab("storage", EquipStorage.vars.left_tab or 0, arg_12_0.vars.listview_left, nil)
			
			arg_12_0.vars.sorter_equip_left:setItems(var_14_0)
			arg_12_0.vars.listview_left:setItemsKeepPos(arg_12_0.vars.sorter_equip_left:sort())
		end,
		open_callback = function()
			if arg_12_0.vars.mode == EquipStorageMainMode.Take then
				arg_12_0.vars.sorter_equip_left:show(false)
				balloon_message_with_sound("storage_err_01")
				
				return 
			end
			
			local var_15_0 = arg_12_0.vars.sorter_equip_left:getWnd():getChildByName("n_sort")
			
			arg_12_0.vars.ui_left:bringToFront()
			
			local var_15_1 = VIEW_WIDTH / 4
			
			var_15_0:setPosition(var_15_1, -20)
		end,
		callback_sort = function(arg_16_0, arg_16_1)
			if arg_16_0 ~= arg_16_1 then
				SAVE:setTempConfigData("inven_equip_sort_index", arg_16_1)
				arg_12_0.vars.listview_left:setItemsKeepPos(arg_12_0.vars.sorter_equip_left:sort() or {})
			end
		end
	})
	arg_12_0:initListView("_left")
	
	if get_cocos_refid(arg_12_0.vars.wnd:getChildByName("n_sorting"):getChildByName("sorting_filter_equip")) then
		arg_12_0.vars.wnd:getChildByName("n_sorting"):getChildByName("sorting_filter_equip"):removeFromParent()
		
		arg_12_0.vars.sorter_equip_right = nil
	end
	
	arg_12_0.vars.wnd:getChildByName("n_sorting"):bringToFront()
	
	local var_12_2 = {
		{
			id = "show_point",
			is_filter = true,
			name = T("ui_equip_score_view"),
			checked = arg_12_0.vars.showEquipPoint_right
		}
	}
	
	arg_12_0.vars.sorter_equip_right = arg_12_0.vars.sorter_equip_right or Sorter:create(arg_12_0.vars.wnd:getChildByName("n_sorting"), {
		is_inventory_equip = true,
		useExtention = true
	})
	
	arg_12_0.vars.sorter_equip_right:setSorter({
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
		checkboxs = var_12_2,
		callback_checkbox = function(arg_17_0, arg_17_1, arg_17_2)
			if arg_17_0 == "show_point" then
				arg_12_0:setShowEquipPointView(arg_17_2, "_right")
				arg_12_0:initListView("_right")
				arg_12_0:resetListViewItems()
				arg_12_0:reset()
			end
		end,
		close_callback = function()
			local var_18_0 = EquipStorage:toggleTab("inventory", EquipStorage.vars.right_tab or 0, arg_12_0.vars.listview_right, nil)
			
			arg_12_0.vars.sorter_equip_right:setItems(EquipStorage.vars.right_sorted or EquipStorage:getEquipList("inventory"))
			arg_12_0.vars.listview_right:setDataSource(arg_12_0.vars.sorter_equip_right:sort())
		end,
		open_callback = function()
			if arg_12_0.vars.mode == EquipStorageMainMode.Stack then
				arg_12_0.vars.sorter_equip_right:show(false)
				balloon_message_with_sound("storage_err_01")
				
				return 
			end
			
			arg_12_0.vars.sorter_equip_right:getWnd():getChildByName("n_sort"):setPositionX(42)
			arg_12_0.vars.sorter_equip_right.sorter_extention:get_setBox():setPositionX(-290)
			arg_12_0.vars.ui_right:bringToFront()
		end,
		callback_sort = function(arg_20_0, arg_20_1)
			if arg_20_0 ~= arg_20_1 then
				SAVE:setTempConfigData("inven_equip_sort_index", arg_20_1)
				arg_12_0.vars.listview_right:setItemsKeepPos(arg_12_0.vars.sorter_equip_right:sort() or {})
			end
		end
	})
	arg_12_0:initListView("_right")
	arg_12_0:resetListViewItems()
	arg_12_0:reset()
	SorterExtentionUtil:set_itemSetCounts(arg_12_0.vars.sorter_equip_right.sorter_extention:get_setBox(), EquipStorage:getEquipList("inventory"))
	SorterExtentionUtil:set_itemSetCounts(arg_12_0.vars.sorter_equip_left.sorter_extention:get_setBox(), EquipStorage:getEquipList("storage"))
	TopBarNew:setTitleName(T("storage_title"))
	arg_12_0:animation(true)
	
	EquipStorage.vars.init_end = true
	
	if EquipStorage.vars.prev_mode and EquipStorage.vars.prev_mode:getName() == EquipStorageMode.Main then
		BackButtonManager:push({
			check_id = "Main",
			back_func = function()
				EquipStorage:setMode(EquipStorageMode.Manage)
				BackButtonManager:pop()
			end,
			dlg = arg_12_0.vars.wnd
		})
	end
end

function EquipStorageMain.setShowEquipPointView(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars or not arg_22_2 or type(arg_22_2) ~= "string" then
		return 
	end
	
	arg_22_0.vars["showEquipPoint" .. arg_22_2] = arg_22_1
end

function EquipStorageMain.updateIncInventoryCount(arg_23_0, arg_23_1)
	if not arg_23_0.vars then
		return 
	end
	
	if_set(arg_23_0.vars.wnd:getChildByName("btn_count"), "t_count", string.format("%d/%d", Account:getFreeEquipCount(), Account:getCurrentEquipCount()))
end

function EquipStorageMain.resetListViewItems(arg_24_0)
	if_set(arg_24_0.vars.wnd:getChildByName("btn_count_storage"), "t_count", string.format("%d/%d", Account:getEquipStorageCount(), Account:getEquipStorageMaxCount()))
	if_set(arg_24_0.vars.wnd:getChildByName("btn_count"), "t_count", string.format("%d/%d", Account:getFreeEquipCount(), Account:getCurrentEquipCount()))
end

function EquipStorageMain.stackEquip(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	arg_25_0.vars.selected = arg_25_0.vars.selected or {}
	arg_25_0.vars.selected.storage = arg_25_0.vars.selected.storage or {}
	arg_25_0.vars.selected.inventory = arg_25_0.vars.selected.inventory or {}
	
	if arg_25_0.vars.mode == EquipStorageMainMode.Stack and arg_25_2 == "inventory" then
		return 
	end
	
	if arg_25_0.vars.mode == EquipStorageMainMode.Take and arg_25_2 == "storage" then
		return 
	end
	
	if (table.count(arg_25_0.vars.selected.inventory) > 19 or table.count(arg_25_0.vars.selected.storage) > 19) and (not arg_25_0.vars.selected[arg_25_2] or not arg_25_0.vars.selected[arg_25_2][arg_25_1]) then
		balloon_message_with_sound("storage_err_02")
		
		return 
	end
	
	if arg_25_0.vars.selected[arg_25_2] and arg_25_0.vars.selected[arg_25_2][arg_25_1] then
		if_set_visible(arg_25_3, "n_select", false)
		
		arg_25_0.vars.selected[arg_25_2][arg_25_1] = nil
	else
		if table.count(arg_25_0.vars.selected.storage) + 1 + Account:getFreeEquipCount() > Account:getCurrentEquipCount() and arg_25_2 == "storage" and not EquipStorageManage:isSellMode() then
			Dialog:msgBox(T("too_many_equip"), {
				yesno = true,
				title = T("storage_full_title"),
				yes_text = T("storage_full_expand"),
				handler = function()
					UIUtil:showIncEquipInvenDialog()
				end
			})
			
			return 
		end
		
		if table.count(arg_25_0.vars.selected.inventory) + 1 + Account:getEquipStorageCount() > Account:getEquipStorageMaxCount() and arg_25_2 == "inventory" then
			Dialog:msgBox(T("storage_overflow_desc"), {
				yesno = true,
				yes_text = T("storage_full_expand"),
				title = T("storage_overflow_title"),
				handler = function()
					UIUtil:showIncEquipStorageDialog()
				end
			})
			
			return 
		end
		
		local var_25_0 = Account:getEquipFromStorage(arg_25_1)
		
		if var_25_0 and var_25_0.lock and EquipStorageManage:isSellMode() then
			return 
		end
		
		if_set_visible(arg_25_3, "n_select", true)
		
		arg_25_0.vars.selected[arg_25_2][arg_25_1] = true
	end
	
	if table.count(arg_25_0.vars.selected.storage) > 0 or table.count(arg_25_0.vars.selected.inventory) > 0 then
		arg_25_0:setMode(arg_25_2 == "storage" and EquipStorageMainMode.Stack or EquipStorageMainMode.Take)
	else
		arg_25_0.vars.lock = false
		
		arg_25_0:setMode(EquipStorageMainMode.Waiting)
	end
	
	if arg_25_0.vars.selected then
		if_set(arg_25_0.vars.wnd, "t_sel_equip", T("storage_count_ui"))
		if_set(arg_25_0.vars.wnd, "t_count_equip", T("storage_count", {
			curr = table.count(arg_25_0.vars.mode == EquipStorageMainMode.Take and arg_25_0.vars.selected.inventory or arg_25_0.vars.selected.storage),
			max = GAME_CONTENT_VARIABLE.inven_storage_box_select_limit
		}))
		if_set(arg_25_0.vars.wnd, "t_disc_choose", T("storage_status_keep_desc"))
		
		if EquipStorageManage:isSellMode() then
			local var_25_1 = {}
			
			for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.selected.storage) do
				local var_25_2 = Account:getEquipFromStorage(iter_25_0)
				
				if var_25_2 and var_25_2:isExtractable() then
					table.insert(var_25_1, var_25_2)
				end
			end
			
			if_set(EquipStorageManage.vars.wnd, "t_item_count", T("ui_extraction_select_inventory", {
				count = table.count(arg_25_0.vars.selected.storage) or 0
			}))
			if_set_opacity(EquipStorageManage.vars.wnd, "btn_sell", table.count(arg_25_0.vars.selected.storage) > 0 and 255 or 76.5)
			if_set_opacity(EquipStorageManage.vars.wnd, "btn_extract", not table.empty(var_25_1) and 255 or 76.5)
			EquipStorageManage.vars.listview_normal:refresh()
		end
	end
end

function EquipStorageMain.reset(arg_28_0)
	arg_28_0.vars.selected = nil
	
	EquipStorage:toggleTab("inventory", EquipStorage:getLastTab("inventory") or EquipStorageTabType.All, arg_28_0.vars.listview_right, arg_28_0.vars.wnd:getChildByName("n_tab"))
	EquipStorage:toggleTab("storage", EquipStorage:getLastTab("storage") or EquipStorageTabType.All, arg_28_0.vars.listview_left, arg_28_0.vars.wnd:getChildByName("n_tab_storage"))
	
	arg_28_0.vars.lock = false
	
	arg_28_0:setMode(EquipStorageMainMode.Waiting)
end

function EquipStorageMain.commit(arg_29_0)
	if not arg_29_0.vars.selected then
		print("error empty select")
		
		return 
	end
	
	local var_29_0 = table.count(arg_29_0.vars.selected.storage)
	local var_29_1 = table.count(arg_29_0.vars.selected.inventory)
	
	if var_29_0 <= 0 and var_29_1 <= 0 then
		print("error 3")
		
		return 
	end
	
	local var_29_2 = arg_29_0.vars.mode == EquipStorageMainMode.Take and "equip_storage_put_in" or "equip_storage_take_out"
	local var_29_3 = arg_29_0.vars.mode == EquipStorageMainMode.Take and var_29_1 or var_29_0
	local var_29_4 = arg_29_0.vars.mode == EquipStorageMainMode.Take and arg_29_0.vars.selected.inventory or arg_29_0.vars.selected.storage
	local var_29_5 = {}
	
	arg_29_0.vars.listview_right.old_scroll_pos = arg_29_0.vars.listview_right:getInnerContainerPosition()
	arg_29_0.vars.listview_left.old_scroll_pos = arg_29_0.vars.listview_left:getInnerContainerPosition()
	
	for iter_29_0, iter_29_1 in pairs(var_29_4) do
		table.insert(var_29_5, iter_29_0)
	end
	
	local var_29_6 = arg_29_0.vars.mode == EquipStorageMainMode.Take and {
		putin = json.encode(var_29_5)
	} or {
		takeout = json.encode()
	}
	
	Dialog:msgBox(T("storage_move_desc", {
		value = var_29_3
	}), {
		yesno = true,
		title = T("storage_move_title"),
		handler = function()
			query(var_29_2, var_29_6)
		end
	})
end

function EquipStorageMain.animation(arg_31_0, arg_31_1)
	if not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	local var_31_0 = 1200
	local var_31_1 = EquipStorage.vars.prev_mode and EquipStorage.vars.prev_mode:getName() == EquipStorageMode.Manage and 440 or 0
	
	if not EquipStorage.vars.inout then
		EquipStorage.vars.inout = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		EquipStorage.vars.layer:addChild(EquipStorage.vars.inout)
		EquipStorage.vars.inout:bringToFront()
	end
	
	EquipStorage.vars.inout:setOpacity(0)
	EquipStorage.vars.inout:setPosition(VIEW_BASE_LEFT, 0)
	EquipStorage.vars.inout:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	
	if EquipStorage.vars.init_end then
		UIAction:Add(SEQ(FADE_IN(200), DELAY(600), FADE_OUT(200)), EquipStorage.vars.inout, "curtain")
	end
	
	if arg_31_1 then
		arg_31_0.vars.ui_left:setPositionX(-var_31_0)
		arg_31_0.vars.ui_right:setPositionX(var_31_0 - VIEW_BASE_LEFT)
		UIAction:Add(SEQ(DELAY(var_31_1), SHOW(true), LOG(MOVE_BY(450, var_31_0, 0))), arg_31_0.vars.ui_left, "block")
		UIAction:Add(SEQ(DELAY(var_31_1), SHOW(true), LOG(MOVE_BY(450, -var_31_0, 0))), arg_31_0.vars.ui_right, "block")
		UIAction:Add(SEQ(DELAY(var_31_1), LOG(FADE_IN(440))), arg_31_0.vars.wnd:getChildByName("n_center"), "block")
	else
		arg_31_0.vars.ui_left:setPositionX(0)
		arg_31_0.vars.ui_right:setPositionX(-VIEW_BASE_LEFT)
		UIAction:Add(SEQ(RLOG(MOVE_BY(450, -var_31_0, 0)), SHOW(false)), arg_31_0.vars.ui_left, "block")
		UIAction:Add(SEQ(RLOG(MOVE_BY(450, var_31_0, 0)), SHOW(false)), arg_31_0.vars.ui_right, "block")
		UIAction:Add(SEQ(LOG(FADE_OUT(440))), arg_31_0.vars.wnd:getChildByName("n_center"), "block")
	end
end

function EquipStorageMain._setBlockEquip(arg_32_0, arg_32_1, arg_32_2)
	for iter_32_0, iter_32_1 in pairs(arg_32_1) do
		iter_32_1.block = arg_32_2
	end
end

function EquipStorageMain.setMode(arg_33_0, arg_33_1)
	if arg_33_0.vars.lock then
		return 
	end
	
	local var_33_0 = {}
	
	if arg_33_1 == EquipStorageMainMode.Waiting then
		var_33_0.t_action = "storage_status_wait"
		arg_33_0.vars.lock = false
	elseif arg_33_1 == EquipStorageMainMode.Take then
		var_33_0.t_action = "storage_status_keep"
		arg_33_0.vars.lock = true
	elseif arg_33_1 == EquipStorageMainMode.Stack then
		var_33_0.t_action = "storage_status_get"
		arg_33_0.vars.lock = true
	end
	
	arg_33_0.vars.mode = arg_33_1
	
	if arg_33_0.vars.listview_left then
		if arg_33_0.vars.mode == EquipStorageMainMode.Waiting then
			arg_33_0:_setBlockEquip(arg_33_0.vars.sorter_equip_left.vars.items, nil)
			arg_33_0:_setBlockEquip(arg_33_0.vars.sorter_equip_right.vars.items, nil)
			arg_33_0.vars.listview_left:refresh()
			arg_33_0.vars.listview_right:refresh()
		elseif arg_33_0.vars.mode == EquipStorageMainMode.Take then
			arg_33_0:_setBlockEquip(arg_33_0.vars.sorter_equip_left.vars.items, true)
			arg_33_0.vars.listview_left:refresh()
		elseif arg_33_0.vars.mode == EquipStorageMainMode.Stack then
			arg_33_0:_setBlockEquip(arg_33_0.vars.sorter_equip_right.vars.items, true)
			arg_33_0.vars.listview_right:refresh()
		end
	end
	
	if_set(arg_33_0.vars.wnd, "t_action", T(var_33_0.t_action))
	if_set(arg_33_0.vars.wnd:getChildByName("n_no_data"), "label", T("storage_status_wait_desc"))
	if_set_visible(arg_33_0.vars.wnd, "n_no_data", arg_33_0.vars.mode == EquipStorageMainMode.Waiting)
	if_set_visible(arg_33_0.vars.wnd, "n_action", arg_33_0.vars.mode ~= EquipStorageMainMode.Waiting)
	if_set_visible(arg_33_0.vars.wnd, "arrow_l", arg_33_0.vars.mode == EquipStorageMainMode.Take)
	if_set_visible(arg_33_0.vars.wnd, "arrow_r", arg_33_0.vars.mode == EquipStorageMainMode.Stack)
	if_set_opacity(arg_33_0.vars.wnd, "btn_change", arg_33_0.vars.mode == EquipStorageMainMode.Waiting and 76.5 or 255)
end

function EquipStorageMain.resetUI(arg_34_0)
	if not get_cocos_refid(arg_34_0.vars.wnd) then
		return 
	end
	
	arg_34_0:setMode(EquipStorageMainMode.Waiting)
	
	local var_34_0 = arg_34_0.vars.wnd:getChildByName("n_tab_storage")
	local var_34_1 = arg_34_0.vars.wnd:getChildByName("n_tab")
	
	for iter_34_0 = 1, 6 do
		if_set_visible(var_34_0:getChildByName("btn_equip_tab" .. iter_34_0), "bg_tab", false)
		if_set_visible(var_34_1:getChildByName("btn_equip_tab" .. iter_34_0), "bg_tab", false)
	end
	
	if_set(arg_34_0.vars.wnd:getChildByName("btn_count_storage"), "t_count", string.format("%d/%d", Account:getEquipStorageCount(), Account:getEquipStorageMaxCount()))
	if_set(arg_34_0.vars.wnd:getChildByName("btn_count"), "t_count", string.format("%d/%d", Account:getFreeEquipCount(), Account:getCurrentEquipCount()))
end

function EquipStorageMain.onLeave(arg_35_0, arg_35_1)
	UIAction:Add(SEQ(CALL(EquipStorageMain.animation, EquipStorageMain, false)), arg_35_0.vars.wnd, "block")
	
	EquipStorage.vars.left_sorted = nil
	
	EquipStorageMain.vars.listview_left:removeAllChildren()
	EquipStorageMain.vars.listview_right:removeAllChildren()
end

function EquipStorageMain.initListView(arg_36_0, arg_36_1)
	if not arg_36_0.vars or not arg_36_1 or type(arg_36_1) ~= "string" then
		return 
	end
	
	arg_36_0.vars["listview" .. arg_36_1] = ItemListView_v2:bindControl(arg_36_0.vars["ui" .. arg_36_1]:getChildByName("listview"))
	
	local var_36_0 = not arg_36_0.vars["showEquipPoint" .. arg_36_1]
	local var_36_1 = var_36_0 == true and "wnd/inventory_card2.csb"
	local var_36_2 = {
		onUpdate = var_36_0 and var_0_1 or var_0_0
	}
	
	arg_36_0.vars["listview" .. arg_36_1]:setRenderer(load_control(var_36_1 or "wnd/inventory_card.csb"), var_36_2)
end

function EquipStorageMain.isActive(arg_37_0)
	return arg_37_0.vars ~= nil
end

function EquipStorageMain.getName(arg_38_0)
	return "EquipStorageMain"
end

function EquipStorageManage.onEnter(arg_39_0, arg_39_1)
	arg_39_0.vars = arg_39_0.vars or {}
	arg_39_1 = arg_39_1 or {}
	arg_39_0.vars.args = arg_39_1 or {}
	
	local var_39_0 = arg_39_1.layer or EquipStorage.vars.layer
	
	if not arg_39_0.vars.wnd then
		arg_39_0.vars.wnd = load_dlg("equip_storage_manage", true, "wnd")
		
		arg_39_0.vars.wnd:setPositionY(arg_39_0.vars.wnd:getPositionY() + DESIGN_HEIGHT)
		arg_39_0:initListViewNormal()
		
		local var_39_1 = EquipStorage:getEquipList("storage")
		
		if table.count(var_39_1) > 0 then
			arg_39_0.vars.listview_normal:setDataSource(EquipStorage:getEquipList("storage"))
		end
		
		if not Account:isUnlockExtract() then
			if_set_visible(arg_39_0.vars.wnd, "btn_extract", false)
			
			local var_39_2 = arg_39_0.vars.wnd:getChildByName("t_item_count")
			
			if not var_39_2.originPosX then
				var_39_2.originPosX = var_39_2:getPositionX()
			end
			
			var_39_2:setPositionX(var_39_2.originPosX - 150)
		end
		
		var_39_0:addChild(arg_39_0.vars.wnd)
	end
	
	if_set_visible(arg_39_0.vars.wnd, "btn_close", false)
	if_set_visible(arg_39_0.vars.wnd:getChildByName("n_sorting"), "btn_toggle", false)
	
	if get_cocos_refid(arg_39_0.vars.wnd:getChildByName("n_sorting"):getChildByName("sorting_filter_equip")) then
		arg_39_0.vars.wnd:getChildByName("n_sorting"):getChildByName("sorting_filter_equip"):removeFromParent()
		
		arg_39_0.vars.sorter_equip = nil
	end
	
	local var_39_3 = {
		{
			id = "show_point",
			is_filter = true,
			name = T("ui_equip_score_view"),
			checked = arg_39_0.vars.showEquipPoint
		}
	}
	
	arg_39_0.vars.sorter_equip = arg_39_0.vars.sorter_equip or Sorter:create(arg_39_0.vars.wnd:getChildByName("n_sorting"), {
		is_inventory_equip = true,
		useExtention = true
	})
	
	arg_39_0.vars.sorter_equip:setSorter({
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
		checkboxs = var_39_3,
		callback_checkbox = function(arg_40_0, arg_40_1, arg_40_2)
			if arg_40_0 == "show_point" then
				arg_39_0:setShowEquipPointView(arg_40_2)
				arg_39_0:initListViewNormal()
				arg_39_0:resetUI()
			end
		end,
		close_callback = function()
			local var_41_0 = EquipStorage:toggleTab("storage", EquipStorage.vars.left_tab or 0, arg_39_0.vars.listview_normal, nil)
			
			arg_39_0.vars.sorter_equip:setItems(var_41_0)
			arg_39_0.vars.listview_normal:setDataSource(arg_39_0.vars.sorter_equip:sort())
		end,
		open_callback = function()
			arg_39_0.vars.sorter_equip:getWnd():getChildByName("n_sort"):setPositionX(-240)
		end,
		callback_sort = function(arg_43_0, arg_43_1)
			if arg_43_0 ~= arg_43_1 then
				SAVE:setTempConfigData("inven_equip_sort_index", arg_43_1)
				arg_39_0.vars.listview_normal:setItemsKeepPos(arg_39_0.vars.sorter_equip:sort() or {})
			end
		end
	})
	
	for iter_39_0 = 1, 6 do
		if_set_visible(arg_39_0.vars.wnd:getChildByName("btn_equip_tab" .. iter_39_0), "bg_tab", false)
	end
	
	TopBarNew:setTitleName(T("storage_manage_title"))
	arg_39_0:resetUI()
	SorterExtentionUtil:set_itemSetCounts(arg_39_0.vars.sorter_equip.sorter_extention:get_setBox(), EquipStorage:getEquipList("storage"))
	EquipStorage:toggleTab("storage", EquipStorageTabType.All, arg_39_0.vars.listview_normal, arg_39_0.vars.wnd:getChildByName("n_tab_storage"))
	UIAction:Add(SEQ(DELAY(140), RLOG(MOVE_BY(450, 0, -DESIGN_HEIGHT)), RLOG(MOVE_BY(10, 0, -DESIGN_HEIGHT))), arg_39_0.vars.wnd, "block")
	BackButtonManager:push({
		check_id = "Manage",
		back_func = function()
			EquipStorage:setMode(EquipStorageMode.Main)
			BackButtonManager:pop()
		end,
		dlg = arg_39_0.vars.wnd
	})
end

function EquipStorageManage.setShowEquipPointView(arg_45_0, arg_45_1)
	if not arg_45_0.vars then
		return 
	end
	
	arg_45_0.vars.showEquipPoint = arg_45_1
end

function EquipStorageManage.initListViewNormal(arg_46_0)
	if not arg_46_0.vars then
		return 
	end
	
	arg_46_0.vars.listview_normal = ItemListView_v2:bindControl(arg_46_0.vars.wnd:getChildByName("listview"))
	
	local var_46_0 = not arg_46_0.vars.showEquipPoint
	local var_46_1 = var_46_0 == true and "wnd/inventory_card2.csb"
	local var_46_2 = {
		onUpdate = var_46_0 and var_0_1 or var_0_0
	}
	
	arg_46_0.vars.listview_normal:setRenderer(load_control(var_46_1 or "wnd/inventory_card.csb"), var_46_2)
end

function EquipStorageManage.send(arg_47_0, arg_47_1)
	if not EquipStorageMain.vars.selected then
		return 
	end
	
	if table.count(EquipStorageMain.vars.selected.storage) <= 0 then
		return 
	end
	
	local var_47_0 = {}
	
	for iter_47_0, iter_47_1 in pairs(EquipStorageMain.vars.selected.storage or {}) do
		table.push(var_47_0, iter_47_0)
	end
	
	if arg_47_1 == "alchemist_point_extract" then
		local var_47_1 = {}
		
		for iter_47_2, iter_47_3 in pairs(var_47_0) do
			table.push(var_47_1, Account:getEquipFromStorage(iter_47_3))
		end
		
		Inventory:getExtractDlg(var_47_1, "inventory", nil, 1)
	elseif arg_47_1 == "sell_equips" then
		local var_47_2 = 0
		
		for iter_47_4, iter_47_5 in pairs(var_47_0) do
			var_47_2 = var_47_2 + calcEquipSellPrice(Account:getEquipFromStorage(iter_47_5))
		end
		
		local var_47_3 = var_47_2 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_47_2)
		
		Inventory:getSellDlg(var_47_0, 1, var_47_3, 0)
	end
end

function EquipStorageManage.isSellMode(arg_48_0)
	if not arg_48_0.vars then
		return false
	end
	
	return arg_48_0.vars.sell_mode
end

function EquipStorageManage.toggleSellMode(arg_49_0, arg_49_1)
	if not arg_49_0.vars then
		return 
	end
	
	if arg_49_0.vars.sell_mode then
		arg_49_0.vars.sell_mode = false
	else
		arg_49_0.vars.sell_mode = true
	end
	
	if type(arg_49_1) == "boolean" then
		arg_49_0.vars.sell_mode = arg_49_1
	end
	
	if not arg_49_0.vars.sell_mode then
		EquipStorageMain.vars.selected = nil
		
		if_set(arg_49_0.vars.wnd, "t_item_count", T("ui_extraction_select_inventory", {
			count = 0
		}))
	end
	
	if arg_49_0.vars.sell_mode then
		EquipStorageMain.vars.selected = {}
		EquipStorageMain.vars.selected.storage = {}
		EquipStorageMain.vars.selected.inventory = {}
		
		if_set_opacity(arg_49_0.vars.wnd, "btn_sell", 76.5)
		if_set_opacity(arg_49_0.vars.wnd, "btn_extract", 76.5)
	end
	
	arg_49_0.vars.listview_normal:refresh()
	if_set_visible(arg_49_0.vars.wnd, "btn_delete", not arg_49_0.vars.sell_mode)
	if_set_visible(arg_49_0.vars.wnd, "btn_delete_after", arg_49_0.vars.sell_mode)
	if_set_visible(arg_49_0.vars.wnd, "n_tab_sell", arg_49_0.vars.sell_mode)
end

function EquipStorageManage.resetUI(arg_50_0, arg_50_1)
	if not arg_50_0.vars then
		return 
	end
	
	if_set(arg_50_0.vars.wnd:getChildByName("btn_count"), "t_count", string.format("%d/%d", Account:getEquipStorageCount(), Account:getEquipStorageMaxCount()))
	if_set(arg_50_0.vars.wnd, "t_item_count", T("ui_extraction_select_inventory", {
		count = 0
	}))
	
	local var_50_0
	
	if not arg_50_1 then
		var_50_0 = EquipStorage:toggleTab("storage", EquipStorage.vars.left_tab or 0, arg_50_0.vars.listview_normal, nil)
		
		arg_50_0.vars.listview_normal:setDataSource(var_50_0)
	end
	
	if EquipStorageMain.vars.selected then
		local var_50_1 = table.count(EquipStorageMain.vars.selected.storage or {})
		
		if_set_opacity(arg_50_0.vars.wnd, "btn_sell", var_50_1 > 0 and 255 or 76.5)
		
		local var_50_2 = {}
		
		for iter_50_0, iter_50_1 in pairs(EquipStorageMain.vars.selected.storage or {}) do
			local var_50_3 = Account:getEquipFromStorage(iter_50_0)
			
			if var_50_3 and var_50_3:isExtractable() then
				table.insert(var_50_2, var_50_3)
			end
		end
		
		if_set_opacity(arg_50_0.vars.wnd, "btn_extract", table.count(var_50_2) > 0 and 255 or 76.5)
	else
		if_set_opacity(arg_50_0.vars.wnd, "btn_sell", 76.5)
		if_set_opacity(arg_50_0.vars.wnd, "btn_extract", 76.5)
	end
	
	if_set_visible(arg_50_0.vars.wnd, "n_info", table.count(var_50_0 or {}) <= 0)
	if_set_visible(arg_50_0.vars.wnd, "listview", table.count(var_50_0 or {}) > 0)
end

function EquipStorageManage.getSetOpt(arg_51_0)
	return arg_51_0.vars.optsFilter.set or false
end

function EquipStorageManage.getMainStatOpt(arg_52_0)
	return arg_52_0.vars.optsFilter.mainstat or false
end

function EquipStorageManage.getSubStat1_Opt(arg_53_0)
	return arg_53_0.vars.optsFilter.substat1 or false
end

function EquipStorageManage.getSubStat2_Opt(arg_54_0)
	return arg_54_0.vars.optsFilter.substat2 or false
end

function EquipStorageManage._updateSelectButton(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_2 then
		return 
	end
	
	local var_55_0 = arg_55_1:getChildByName("checkbox_" .. arg_55_2)
	
	if not get_cocos_refid(var_55_0) then
		return 
	end
	
	local var_55_1 = var_55_0:getParent():getChildByName("label")
	
	if var_55_1 then
		var_55_1:setTextColor(var_55_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	end
	
	local var_55_2 = var_55_0:getParent():getChildByName("icon")
	
	if var_55_2 then
		var_55_2:setColor(var_55_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	end
	
	if_set_visible(var_55_0:getParent(), "select_" .. arg_55_2, var_55_0:isSelected())
end

function EquipStorageManage.getSelectLists(arg_56_0)
	local function var_56_0(arg_57_0, arg_57_1)
		local var_57_0 = arg_57_0:getChildByName(arg_57_1)
		
		if var_57_0 then
			return var_57_0:isSelected()
		end
		
		return false
	end
	
	local var_56_1 = {
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_g_1"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_g_2"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_g_3"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_g_4"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_g_5")
	}
	local var_56_2 = {
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_1"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_2"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_3"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_4"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_5"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_6"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_t_7")
	}
	local var_56_3 = {
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_e_1"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_e_2"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_e_3"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_e_4")
	}
	local var_56_4 = {
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_k_1"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_k_2"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_k_3"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_k_4"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_k_5"),
		var_56_0(arg_56_0.vars.autoselect_dlg, "checkbox_k_6")
	}
	
	return var_56_1, var_56_2, var_56_3, var_56_4
end

function EquipStorageManage.autoSelect(arg_58_0)
	if not arg_58_0.vars.auto_select then
		return 
	end
	
	EquipStorageMain.vars.selected = {}
	EquipStorageMain.vars.selected.storage = {}
	EquipStorageMain.vars.selected.inventory = {}
	
	local var_58_0, var_58_1, var_58_2, var_58_3 = arg_58_0:getSelectLists()
	local var_58_4 = {}
	
	local function var_58_5(arg_59_0, arg_59_1, arg_59_2)
		for iter_59_0, iter_59_1 in pairs(arg_59_2) do
			if iter_59_1 then
				table.insert(arg_59_0, arg_59_1 .. iter_59_0)
			end
		end
	end
	
	var_58_5(var_58_4, "g_", var_58_0)
	var_58_5(var_58_4, "t_", var_58_1)
	var_58_5(var_58_4, "e_", var_58_2)
	var_58_5(var_58_4, "k_", var_58_3)
	SAVE:setUserDefaultData(Inventory:getSelectInfoKey_v2(2), json.encode(var_58_4))
	
	local function var_58_6(arg_60_0, arg_60_1)
		local var_60_0 = true
		
		if not var_58_2[1] and arg_60_0 == 0 then
			var_60_0 = false
		elseif not var_58_2[2] and arg_60_0 >= 1 and arg_60_0 <= arg_60_1 then
			var_60_0 = false
		elseif not var_58_2[3] and arg_60_0 >= arg_60_1 + 1 and arg_60_0 <= arg_60_1 * 2 then
			var_60_0 = false
		elseif not var_58_2[4] and arg_60_0 >= arg_60_1 * 2 + 1 and arg_60_0 <= arg_60_1 * 3 then
			var_60_0 = false
		end
		
		return var_60_0
	end
	
	local function var_58_7(arg_61_0, arg_61_1)
		local var_61_0 = true
		
		if not var_58_2[1] and arg_61_0 == 0 then
			var_61_0 = false
		elseif not var_58_2[2] and arg_61_0 >= 1 and arg_61_0 <= 9 then
			var_61_0 = false
		elseif not var_58_2[3] and arg_61_0 >= 10 and arg_61_0 <= 12 then
			var_61_0 = false
		elseif not var_58_2[4] and arg_61_0 >= 13 and arg_61_0 <= 15 then
			var_61_0 = false
		end
		
		return var_61_0
	end
	
	local function var_58_8(arg_62_0, arg_62_1)
		if EquipStorage.vars.left_tab ~= 0 then
			return true
		end
		
		local var_62_0 = true
		local var_62_1 = 0
		
		if arg_62_1 == "weapon" then
			var_62_1 = 1
		elseif arg_62_1 == "helm" then
			var_62_1 = 2
		elseif arg_62_1 == "armor" then
			var_62_1 = 3
		elseif arg_62_1 == "neck" then
			var_62_1 = 4
		elseif arg_62_1 == "ring" then
			var_62_1 = 5
		elseif arg_62_1 == "boot" then
			var_62_1 = 6
		end
		
		if arg_62_0[var_62_1] == false then
			var_62_0 = false
		end
		
		return var_62_0
	end
	
	local var_58_9 = EquipStorage:toggleTab("storage", EquipStorage.vars.left_tab or 0, arg_58_0.vars.listview_left, nil)
	
	for iter_58_0, iter_58_1 in pairs(var_58_9) do
		local var_58_10 = true
		local var_58_11 = iter_58_1.enhance or 0
		local var_58_12 = iter_58_1:isArtifact()
		local var_58_13
		
		if iter_58_1.db.item_level then
			local var_58_14 = iter_58_1.db.item_level
			
			if var_58_14 <= 28 then
				var_58_13 = 1
			elseif var_58_14 <= 42 then
				var_58_13 = 2
			elseif var_58_14 <= 57 then
				var_58_13 = 3
			elseif var_58_14 <= 71 then
				var_58_13 = 4
			elseif var_58_14 <= 84 then
				var_58_13 = 5
			elseif var_58_14 == 85 then
				var_58_13 = 6
			elseif var_58_14 >= 86 then
				var_58_13 = 7
			end
		else
			var_58_13 = iter_58_1.db.tier
		end
		
		var_58_8(var_58_3, iter_58_1.db.type)
		
		if iter_58_1:isStone() then
			var_58_10 = false
		elseif not var_58_0[iter_58_1.grade] then
			var_58_10 = false
		elseif not var_58_8(var_58_3, iter_58_1.db.type) then
			var_58_10 = false
		elseif not var_58_1[var_58_13] and not var_58_12 then
			var_58_10 = false
		elseif var_58_10 then
			if var_58_12 then
				var_58_10 = var_58_6(var_58_11, 10)
			else
				var_58_10 = var_58_7(var_58_11)
			end
		end
		
		if arg_58_0.vars and arg_58_0.vars.optsFilter and not arg_58_0.vars.sorter_equip.sorter_extention:checkFilterOptions(iter_58_1, {
			set = arg_58_0.vars.optsFilter.set,
			mainstat = arg_58_0.vars.optsFilter.mainstat,
			substat1 = arg_58_0.vars.optsFilter.substat1,
			substat2 = arg_58_0.vars.optsFilter.substat2
		}) then
			var_58_10 = false
		end
		
		if var_58_10 and iter_58_1.lock then
			var_58_10 = false
		end
		
		if var_58_10 then
			EquipStorageMain.vars.selected.storage[iter_58_1.id] = true
		end
	end
	
	arg_58_0.vars.listview_normal:refresh()
	arg_58_0:resetUI()
	if_set(EquipStorageManage.vars.wnd, "t_item_count", T("ui_extraction_select_inventory", {
		count = table.count(EquipStorageMain.vars.selected and EquipStorageMain.vars.selected.storage or {})
	}))
	arg_58_0:toggleAutoselectMode(false)
	arg_58_0:save_autoSelect_filterOpts()
end

function EquipStorageManage.save_autoSelect_filterOpts(arg_63_0)
	if not arg_63_0.vars or not arg_63_0.vars.optsFilter then
		return 
	end
	
	SAVE:setUserDefaultData("inven_autosell_set_filter", arg_63_0.vars.optsFilter.set or "all")
	SAVE:setUserDefaultData("inven_autosell_mainstat_filter", arg_63_0.vars.optsFilter.mainstat or "all")
	SAVE:setUserDefaultData("inven_autosell_substat1_filter", arg_63_0.vars.optsFilter.substat1 or "all")
	SAVE:setUserDefaultData("inven_autosell_substat2_filter", arg_63_0.vars.optsFilter.substat2 or "all")
end

function EquipStorageManage.updateSelectButton(arg_64_0, arg_64_1)
	if arg_64_1 then
		arg_64_0:_updateSelectButton(arg_64_0.vars.autoselect_dlg, arg_64_1)
	end
end

function EquipStorageManage.closeAll(arg_65_0)
	if not arg_65_0.vars then
		return 
	end
	
	local var_65_0 = arg_65_0.vars.autoselect_dlg
	local var_65_1 = false
	
	if_set_visible(var_65_0, "autosell_n_set_box", var_65_1)
	if_set_visible(var_65_0, "autosell_n_mainstat_box", var_65_1)
	if_set_visible(var_65_0, "autosell_n_substat_box", var_65_1)
	if_set_visible(var_65_0, "btn_set", not var_65_1)
	if_set_visible(var_65_0, "btn_mainstat", not var_65_1)
	if_set_visible(var_65_0, "btn_substat1", not var_65_1)
	if_set_visible(var_65_0, "btn_substat2", not var_65_1)
	if_set_visible(var_65_0, "btn_set_done", var_65_1)
	if_set_visible(var_65_0, "btn_mainstat_done", var_65_1)
	if_set_visible(var_65_0, "btn_substat1_done", var_65_1)
	if_set_visible(var_65_0, "btn_substat2_done", var_65_1)
	SorterExtentionUtil:updateAllButtons(var_65_0, {
		setOpt = arg_65_0:getSetOpt(),
		mainOpt = arg_65_0:getMainStatOpt(),
		substat1_opt = arg_65_0:getSubStat1_Opt(),
		substat2_opt = arg_65_0:getSubStat2_Opt()
	})
end

function EquipStorageManage.toggleOptsFilterBox(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = arg_66_0.vars.autoselect_dlg
	
	if arg_66_1 == "btn_set" or arg_66_1 == "btn_set_done" then
		if_set_visible(var_66_0, "autosell_n_set_box", arg_66_2)
		if_set_visible(var_66_0, "btn_set", not arg_66_2)
		if_set_visible(var_66_0, "btn_set_done", arg_66_2)
		
		if arg_66_2 then
			local var_66_1 = EquipStorage:toggleTab("storage", EquipStorage.vars.left_tab or 0, nil, nil)
			
			SorterExtentionUtil:set_itemSetCounts(arg_66_0.vars.autoselect_dlg:getChildByName("n_filter_set_box"):getChildByName("n_set_box"), var_66_1)
		end
	elseif arg_66_1 == "btn_mainstat" or arg_66_1 == "btn_mainstat_done" then
		if_set_visible(var_66_0, "autosell_n_mainstat_box", arg_66_2)
		if_set_visible(var_66_0, "btn_mainstat", not arg_66_2)
		if_set_visible(var_66_0, "btn_mainstat_done", arg_66_2)
	elseif arg_66_1 == "btn_substat1" or arg_66_1 == "btn_substat1_done" or arg_66_1 == "btn_substat2" or arg_66_1 == "btn_substat2_done" then
		if_set_visible(var_66_0, "autosell_n_substat_box", arg_66_2)
		
		if string.find(arg_66_1, "1") then
			if_set_visible(var_66_0, "btn_substat1", not arg_66_2)
			if_set_visible(var_66_0, "btn_substat1_done", arg_66_2)
		else
			if_set_visible(var_66_0, "btn_substat2", not arg_66_2)
			if_set_visible(var_66_0, "btn_substat2_done", arg_66_2)
		end
		
		if arg_66_2 then
			local var_66_2 = string.find(arg_66_1, "1") and 1 or 2
			
			arg_66_0:_setSubstatBox(var_66_0:getChildByName("autosell_n_substat_box"), var_66_2)
		end
	end
end

function EquipStorageManage.getSubStatOpt(arg_67_0, arg_67_1)
	if not arg_67_1 then
		return 
	end
	
	if arg_67_1 == 1 then
		return arg_67_0.vars.optsFilter.substat1
	else
		return arg_67_0.vars.optsFilter.substat2
	end
end

function EquipStorageManage._moveSubstatBox(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_2 or not get_cocos_refid(arg_68_0.vars.autoselect_dlg) or not get_cocos_refid(arg_68_1) then
		return 
	end
	
	local var_68_0
	
	if arg_68_2 == 1 then
		var_68_0 = arg_68_0.vars.autoselect_dlg:getChildByName("n_filter_stat_box_sub")
	elseif arg_68_2 == 2 then
		if_set_visible(arg_68_0.vars.autoselect_dlg, "n_filter_stat_box_sub2", true)
		
		var_68_0 = arg_68_0.vars.autoselect_dlg:getChildByName("n_filter_stat_box_sub2")
	end
	
	if get_cocos_refid(var_68_0) then
		arg_68_1:ejectFromParent()
		var_68_0:addChild(arg_68_1)
	end
end

function EquipStorageManage._setSubstatBox(arg_69_0, arg_69_1, arg_69_2)
	if not get_cocos_refid(arg_69_1) or not arg_69_2 then
		return 
	end
	
	for iter_69_0, iter_69_1 in pairs(arg_69_0.vars.optsFilter.substats) do
		if iter_69_1 == arg_69_0:getSubStatOpt(arg_69_2) then
			SorterExtentionUtil:setFilterUI(arg_69_1, iter_69_0, 12)
		end
	end
	
	arg_69_0:_moveSubstatBox(arg_69_1, arg_69_2)
end

function EquipStorageManage.onClickEventExtentionFilter(arg_70_0, arg_70_1)
	if not arg_70_0.vars then
		return 
	end
	
	local var_70_0 = not string.find(arg_70_1, "done")
	
	if var_70_0 then
		arg_70_0:closeAll()
	end
	
	if arg_70_1 == "btn_set" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
		
		arg_70_0.vars.optsFilter.curset = "set"
	elseif arg_70_1 == "btn_set_done" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
	elseif arg_70_1 == "btn_mainstat" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
		
		arg_70_0.vars.optsFilter.curset = "mainstat"
	elseif arg_70_1 == "btn_mainstat_done" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
	elseif arg_70_1 == "btn_substat1" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
		
		arg_70_0.vars.optsFilter.curset = "substat1"
	elseif arg_70_1 == "btn_substat1_done" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
	elseif arg_70_1 == "btn_substat2" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
		
		arg_70_0.vars.optsFilter.curset = "substat2"
	elseif arg_70_1 == "btn_substat2_done" then
		arg_70_0:toggleOptsFilterBox(arg_70_1, var_70_0)
	elseif arg_70_1 == "btn_cancle" or arg_70_1 == "btn_toggle" then
		arg_70_0:closeAll()
	end
	
	if string.find(arg_70_1, "done") or arg_70_1 == "btn_cancle" then
		arg_70_0.vars.optsFilter.curset = nil
	end
	
	if string.find(arg_70_1, "btn_sort") then
		local var_70_1 = string.split(arg_70_1, "_")[3] or 1
		
		arg_70_0:setFilterOpt(arg_70_0.vars.autoselect_dlg, arg_70_0.vars.optsFilter.curset, tonumber(var_70_1))
	end
end

function EquipStorageManage.setFilterOpt(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	if not get_cocos_refid(arg_71_1) then
		return 
	end
	
	if arg_71_2 == "set" then
		arg_71_0:setSetStatFilter(arg_71_3)
		SorterExtentionUtil:setFilterUI(arg_71_1:getChildByName("autosell_n_set_box"), arg_71_3, 17)
	elseif arg_71_2 == "mainstat" then
		arg_71_0:setMainStatFilter(arg_71_3)
		SorterExtentionUtil:setFilterUI(arg_71_1:getChildByName("autosell_n_mainstat_box"), arg_71_3, 12)
	elseif arg_71_2 == "substat1" then
		arg_71_0:setSubStatFilter(arg_71_3, 1)
		SorterExtentionUtil:setFilterUI(arg_71_1:getChildByName("autosell_n_substat_box"), arg_71_3, 12)
	elseif arg_71_2 == "substat2" then
		arg_71_0:setSubStatFilter(arg_71_3, 2)
		SorterExtentionUtil:setFilterUI(arg_71_1:getChildByName("autosell_n_substat_box"), arg_71_3, 12)
	end
	
	arg_71_0:closeAll()
end

function EquipStorageManage.setMainStatFilter(arg_72_0, arg_72_1)
	if not arg_72_1 then
		return 
	end
	
	local var_72_0 = arg_72_0.vars.optsFilter.mainstats[arg_72_1]
	
	if not var_72_0 then
		return 
	end
	
	arg_72_0.vars.optsFilter.mainstat = var_72_0
end

function EquipStorageManage.setSubStatFilter(arg_73_0, arg_73_1, arg_73_2)
	if not arg_73_1 or not arg_73_2 then
		return 
	end
	
	local var_73_0 = arg_73_2 or 1 or 2
	local var_73_1 = arg_73_0.vars.optsFilter.substats[arg_73_1]
	
	if not var_73_1 then
		return 
	end
	
	if var_73_0 == 1 then
		arg_73_0.vars.optsFilter.substat1 = var_73_1
	else
		arg_73_0.vars.optsFilter.substat2 = var_73_1
	end
end

function EquipStorageManage.setSetStatFilter(arg_74_0, arg_74_1)
	if not arg_74_1 then
		return 
	end
	
	local var_74_0 = arg_74_0.vars.optsFilter.sets[arg_74_1]
	
	if not var_74_0 then
		return 
	end
	
	arg_74_0.vars.optsFilter.set = var_74_0
end

function EquipStorageManage.toggleAutoselectMode(arg_75_0, arg_75_1)
	if not arg_75_0.vars then
		return 
	end
	
	if arg_75_0.vars.auto_select then
		arg_75_0.vars.auto_select = false
	else
		arg_75_0.vars.auto_select = true
	end
	
	if type(arg_75_1) == "boolean" then
		arg_75_0.vars.auto_select = arg_75_1
	end
	
	if arg_75_0.vars.auto_select then
		if not get_cocos_refid(arg_75_0.vars.autoselect_dlg) then
			if arg_75_0.vars.wnd:getChildByName("autoselect") then
				arg_75_0.vars.wnd:getChildByName("autoselect"):removeFromParent()
			end
			
			local var_75_0 = EquipStorage.vars.left_tab and EquipStorage.vars.left_tab == 0 and "inventory_autosel_all" or "inventory_autosel"
			
			arg_75_0.vars.autoselect_dlg = load_dlg(var_75_0, true, "wnd")
			
			arg_75_0.vars.autoselect_dlg:setName("inventory_autosel_storage")
			arg_75_0.vars.wnd:addChild(arg_75_0.vars.autoselect_dlg)
			if_set_visible(arg_75_0.vars.autoselect_dlg, nil, arg_75_0.vars.auto_select)
			
			local var_75_1 = SAVE:getUserDefaultData(Inventory:getSelectInfoKey_v2(2), "empty")
			
			if var_75_1 == "empty" then
				var_75_1 = SAVE:getUserDefaultData(Inventory:getSelectInfoKey(2), "[\"g_1\",\"g_2\",\"t_1\",\"t_2\",\"e_1\"]")
			end
			
			local var_75_2 = json.decode(var_75_1)
			
			local function var_75_3(arg_76_0, arg_76_1)
				if not arg_76_1 then
					return 
				end
				
				local var_76_0 = arg_75_0.vars.autoselect_dlg:getChildByName("checkbox_" .. arg_76_1)
				
				if get_cocos_refid(var_76_0) then
					var_76_0:setSelected(table.find(arg_76_0, arg_76_1) ~= nil)
					var_76_0:setTouchEnabled(false)
				end
			end
			
			for iter_75_0, iter_75_1 in pairs({
				"k_",
				"g_",
				"e_",
				"t_"
			}) do
				for iter_75_2 = 1, 7 do
					local var_75_4 = iter_75_1 .. iter_75_2
					
					var_75_3(var_75_2, var_75_4)
					arg_75_0:_updateSelectButton(arg_75_0.vars.autoselect_dlg, var_75_4)
				end
			end
			
			local var_75_5 = SAVE:getUserDefaultData("inven_autosell_set_filter", "all")
			local var_75_6 = SAVE:getUserDefaultData("inven_autosell_mainstat_filter", "all")
			local var_75_7 = SAVE:getUserDefaultData("inven_autosell_substat1_filter", "all")
			local var_75_8 = SAVE:getUserDefaultData("inven_autosell_substat2_filter", "all")
			local var_75_9 = {
				set = var_75_5,
				mainstat = var_75_6,
				substat1 = var_75_7,
				substat2 = var_75_8
			}
			
			arg_75_0.vars.optsFilter = {}
			
			SorterExtentionUtil:initSetUI_opts(arg_75_0.vars.optsFilter, arg_75_0.vars.autoselect_dlg, var_75_9)
			SorterExtentionUtil:updateAllButtons(arg_75_0.vars.autoselect_dlg, {
				setOpt = arg_75_0:getSetOpt(),
				mainOpt = arg_75_0:getMainStatOpt(),
				substat1_opt = arg_75_0:getSubStat1_Opt(),
				substat2_opt = arg_75_0:getSubStat2_Opt()
			})
			SorterExtentionUtil:set_itemSetCounts(arg_75_0.vars.autoselect_dlg:getChildByName("n_filter_set_box"):getChildByName("n_set_box"), arg_75_0.vars.sorted)
		end
	else
		arg_75_0.vars.autoselect_dlg:removeFromParent()
		
		arg_75_0.vars.autoselect_dlg = nil
	end
end

function EquipStorageManage.onLeave(arg_77_0, arg_77_1)
	UIAction:Add(SPAWN(RLOG(MOVE_BY(550, 0, DESIGN_HEIGHT))), arg_77_0.vars.wnd, "block")
	arg_77_0:toggleSellMode(false)
	
	if InventoryPopupDetail:IsOpen() then
		InventoryPopupDetail:Close()
	end
	
	EquipStorageMain:reset()
	arg_77_0.vars.listview_normal:removeAllChildren()
	if_set_visible(arg_77_0.vars.wnd:getChildByName("btn_equip_tab" .. 0), "bg_tab", true)
	
	for iter_77_0 = 1, 6 do
		if_set_visible(arg_77_0.vars.wnd:getChildByName("btn_equip_tab" .. iter_77_0), "bg_tab", false)
	end
	
	EquipStorage.vars.left_sorted = nil
end

function EquipStorageManage.getName(arg_78_0)
	return "EquipStorageManage"
end

function EquipStorage.onPushBackButton(arg_79_0)
	if arg_79_0.vars and arg_79_0.vars.mode:getName() == EquipStorageMode.Manage then
		EquipStorage:setMode(EquipStorageMode.Main)
		BackButtonManager:pop()
	else
		EquipStorage:leave()
	end
end

function EquipStorage.init(arg_80_0, arg_80_1)
	arg_80_0.vars = {}
	arg_80_1 = arg_80_1 or {}
	arg_80_0.vars.args = arg_80_1
	
	SoundEngine:playBGM("event:/bgm/default")
	Inventory:close(true)
	SceneManager:resetSceneFlow()
	
	EquipStorage.modes = {
		EquipStorageMain = EquipStorageMain,
		EquipStorageManage = EquipStorageManage
	}
	
	local var_80_0 = arg_80_1.parent or SceneManager:getRunningNativeScene()
	local var_80_1 = cc.Layer:create()
	
	var_80_1:setName("equip_storage")
	var_80_0:addChild(var_80_1)
	
	arg_80_0.vars.layer = var_80_1
	
	TopBarNew:create(T("storage_title"), arg_80_0.vars.layer, function()
		arg_80_0:onPushBackButton()
	end, {
		"crystal",
		"gold",
		"stamina"
	}, nil)
	TopBarNew:setDisableTopRight()
	arg_80_0:setMode(arg_80_1.start_mode, {
		layer = arg_80_0.vars.layer
	})
end

function EquipStorage.setMode(arg_82_0, arg_82_1, arg_82_2)
	if not arg_82_1 then
		return 
	end
	
	if not arg_82_0.vars then
		print("error : vars nil")
		
		return 
	end
	
	if arg_82_0.vars.mode and arg_82_0.vars.mode:getName() == EquipStorage.modes[arg_82_1]:getName() then
		print("error : same mode")
		
		return 
	end
	
	arg_82_0.vars.prev_mode = arg_82_0.vars.mode
	arg_82_0.vars.mode = EquipStorage.modes[arg_82_1]
	
	if arg_82_0.vars.prev_mode and arg_82_0.vars.prev_mode.onLeave then
		arg_82_0.vars.prev_mode:onLeave(arg_82_2)
	end
	
	if arg_82_0.vars.mode.onEnter then
		arg_82_0.vars.mode:onEnter(arg_82_2)
	end
end

function EquipStorage.getEquipList(arg_83_0, arg_83_1)
	local var_83_0 = {}
	
	if arg_83_1 == "storage" then
		for iter_83_0, iter_83_1 in pairs(AccountData.equip_storage or {}) do
			if iter_83_1.db and iter_83_1.db.type ~= "artifact" and iter_83_1.db.type ~= "exclusive" and iter_83_1.db.stone ~= "y" then
				iter_83_1.list_type = "storage"
				
				table.insert(var_83_0, iter_83_1)
			end
		end
	else
		for iter_83_2, iter_83_3 in pairs(Account.equips or {}) do
			if iter_83_3.db and iter_83_3.db.type ~= "artifact" and iter_83_3.db.type ~= "exclusive" and iter_83_3.parent == nil and iter_83_3.db.stone ~= "y" then
				iter_83_3.list_type = "inventory"
				
				table.insert(var_83_0, iter_83_3)
			end
		end
	end
	
	return var_83_0
end

function EquipStorage.leave(arg_84_0, arg_84_1)
	arg_84_1 = arg_84_1 or {}
	
	local var_84_0
	
	if arg_84_0.vars then
		UIAction:Add(SEQ(FADE_OUT(250), REMOVE()), arg_84_0.vars.layer, "block")
		
		EquipStorageMain.vars = nil
		EquipStorageManage.vars = nil
		arg_84_0.vars = nil
	end
	
	if not arg_84_1.ignore_popscene then
		SceneManager:popScene()
	end
end
