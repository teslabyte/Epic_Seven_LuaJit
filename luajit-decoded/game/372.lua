EquipBelt = EquipBelt or {}
EquipBeltEventInterface = {}

function EquipBeltEventInterface.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.listeners = {}
end

function EquipBeltEventInterface.checkInit(arg_2_0)
	if not arg_2_0.vars then
		arg_2_0:init()
	end
end

function EquipBeltEventInterface.addListener(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:checkInit()
	
	arg_3_0.vars.listeners[arg_3_1] = arg_3_2
end

function EquipBeltEventInterface.removeListener(arg_4_0, arg_4_1)
	arg_4_0:checkInit()
	
	arg_4_0.vars.listeners[arg_4_1] = nil
end

function EquipBeltEventInterface.updateListeners(arg_5_0)
	arg_5_0:checkInit()
	
	local var_5_0 = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.listeners) do
		if not get_cocos_refid(iter_5_0) then
			table.insert(var_5_0, iter_5_0)
		end
	end
	
	for iter_5_2, iter_5_3 in pairs(var_5_0) do
		arg_5_0.vars.listeners[iter_5_3] = nil
	end
end

function EquipBeltEventInterface.getRootNode(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return nil
	end
	
	if arg_6_1:getName() == "equip_belt" then
		return arg_6_1
	end
	
	return arg_6_0:getRootNode(arg_6_1:getParent())
end

function EquipBeltEventInterface._getListenerTable(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:getRootNode(arg_7_1)
	local var_7_1 = arg_7_0.vars.listeners[var_7_0]
	
	if not var_7_1 then
		Log.e("EquipBelt Eventer is Dead!")
		
		return 
	end
	
	return var_7_1
end

function EquipBeltEventInterface.event_onSelectEquip(arg_8_0, arg_8_1)
	arg_8_0:updateListeners()
	
	local var_8_0 = arg_8_0:_getListenerTable(arg_8_1)
	
	if not var_8_0 then
		return 
	end
	
	var_8_0:onSelectEquip(arg_8_1:getParent().equip)
end

function EquipBeltEventInterface.event_showIncInvenDialog(arg_9_0, arg_9_1)
	arg_9_0:updateListeners()
	
	local var_9_0 = arg_9_0:_getListenerTable(arg_9_1)
	
	if not var_9_0 then
		return 
	end
	
	var_9_0:showIncInvenDialog()
end

function HANDLER.equip_belt(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_1 == "btn_select" and not UIAction:Find("showed_tooptip") then
		EquipBeltEventInterface:event_onSelectEquip(arg_10_0)
	end
	
	if arg_10_1 == "btn_count" or arg_10_1 == "btn_count_arti" then
		EquipBeltEventInterface:event_showIncInvenDialog(arg_10_0)
	end
	
	if arg_10_1 == "btn_auto_fill" then
		UnitEquipUpgradeFilter:toggleEnhanceLevelUI()
	elseif arg_10_1 == "btn_fill_option" then
		UnitEquipUpgradeFilter:toggleSelectOptionUI()
	elseif arg_10_1 == "btn_close" then
		UnitEquipUpgradeFilter:closeAll()
	end
	
	if string.starts(arg_10_1, "btn_checkbox_") or string.starts(arg_10_1, "checkbox_") then
		UnitEquipUpgradeFilter:pushButtons(arg_10_0, arg_10_1)
	elseif string.starts(arg_10_1, "btn_check") then
		local var_10_0 = ({
			btn_check2 = "stone_check",
			btn_check1 = "equip_check"
		})[arg_10_1]
		
		if not var_10_0 then
			return 
		end
		
		UnitEquipUpgradeFilter:pushButtons(arg_10_0, var_10_0)
	elseif string.starts(arg_10_1, "equip_check") or string.starts(arg_10_1, "stone_check") then
		UnitEquipUpgradeFilter:pushButtons(arg_10_0, arg_10_1)
	elseif arg_10_1 == "btn_3" or arg_10_1 == "btn_6" or arg_10_1 == "btn_9" or arg_10_1 == "btn_12" or arg_10_1 == "btn_15" then
		local var_10_1 = string.split(arg_10_1, "_")
		
		UnitEquipUpgrade:autoSelect(tonumber(var_10_1[2]))
	end
	
	if arg_10_1 == "btn_shop" and not Account:checkQueryEmptyDungeonData("dungeon_list", {
		req_open_exclusive_shop = true,
		mode = "Trial_Hall"
	}) then
		if UnlockSystem:isUnlockSystem(UNLOCK_ID.TRIAL_HALL) then
			SceneManager:nextScene("DungeonList", {
				req_open_exclusive_shop = true,
				mode = "Trial_Hall"
			})
		else
			Dialog:msgBox(T("system_118_equip_msg"))
		end
	end
end

function EquipBelt.onSelectEquip(arg_11_0, arg_11_1)
	if arg_11_0.vars.select_callback then
		arg_11_0.vars.select_callback(arg_11_1)
	end
end

function EquipBelt.getWnd(arg_12_0)
	return arg_12_0.vars.wnd
end

function EquipBelt.isVisible(arg_13_0)
	return arg_13_0.vars and arg_13_0.vars.wnd and get_cocos_refid(arg_13_0.vars.wnd)
end

function EquipBelt.showIncInvenDialog(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if arg_14_0.vars.is_artifact then
		UIUtil:showIncArtiEquipInvenDialog()
	else
		UIUtil:showIncEquipInvenDialog()
	end
end

function EquipBelt.setShowEquipDetailView(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0.vars.showEquipDetail = arg_15_1
	
	SAVE:setKeep("inventory_show_detail", arg_15_1)
	
	if arg_15_1 then
		SAVE:setKeep("inventory_show_point", false)
	end
end

function EquipBelt.setHideEquippedItems(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	arg_16_0.vars.hideEquippedItem = arg_16_1
end

function EquipBelt.setHideMaxItems(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	arg_17_0.vars.hideMaxItem = arg_17_1
end

function EquipBelt.createInstance(arg_18_0)
	local var_18_0 = {}
	
	copy_functions(EquipBelt, var_18_0)
	
	return var_18_0
end

function EquipBelt.getInst(arg_19_0, arg_19_1)
	if arg_19_1 == "UnitEquip" then
		if UnitEquip:isVisible() then
			return UnitEquip:getEquipBelt()
		end
		
		return nil
	end
	
	return arg_19_0
end

function EquipBelt.show(arg_20_0, arg_20_1)
	arg_20_0.vars = {
		selected_equips = {},
		base_equip = arg_20_1.base_equip
	}
	arg_20_1 = arg_20_1 or {
		parent = SceneManager:getRunningNativeScene()
	}
	
	local var_20_0
	
	if arg_20_1.listview_cont then
		arg_20_0.vars.listview = ItemListView_v2:bindControl(arg_20_1.listview_cont)
	else
		arg_20_0.vars.wnd = load_dlg("equip_belt", true, "wnd")
		
		local var_20_1 = getChildByPath(arg_20_0.vars.wnd, "node")
		
		if arg_20_1.use_enhancer and not arg_20_1.is_artifact then
			var_20_0 = arg_20_0.vars.wnd:getChildByName("node_reinforce")
			
			var_20_1:setVisible(false)
			var_20_0:setVisible(true)
		else
			var_20_0 = var_20_1
		end
		
		if arg_20_1.is_exclusive then
			local var_20_2 = var_20_0:findChildByName("clip")
			local var_20_3 = var_20_2:findChildByName("listview")
			local var_20_4 = var_20_2:getContentSize()
			local var_20_5 = var_20_3:getContentSize()
			local var_20_6 = 108
			
			var_20_2:setContentSize(var_20_4.width, var_20_4.height - var_20_6)
			var_20_3:setContentSize(var_20_5.width, var_20_5.height - var_20_6)
			var_20_3:setPositionY(var_20_3:getPositionY() - var_20_6)
			if_set_visible(arg_20_0.vars.wnd, "n_private_shop", true)
		end
		
		arg_20_0.vars.listview = ItemListView_v2:bindControl(var_20_0:getChildByName("listview"))
		
		local var_20_7 = {
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
		}
		
		if arg_20_1.use_enhancer then
			var_20_7 = {
				{
					name = T("ui_inventory_sort_10"),
					func = ENHANCER.greaterThanEnhance
				},
				{
					name = T("ui_inventory_sort_4"),
					func = ENHANCER.greaterThanUID
				},
				{
					name = T("ui_inventory_sort_1"),
					func = ENHANCER.greaterThanGrade
				},
				{
					name = T("ui_inventory_sort_8"),
					func = ENHANCER.greaterThanStat
				},
				{
					name = T("ui_inventory_sort_2"),
					func = ENHANCER.greaterThanItemLevel
				},
				{
					name = T("ui_inventory_sort_5"),
					func = ENHANCER.greaterThanSet
				},
				{
					name = T("ui_equip_score"),
					func = ENHANCER.greaterThanPoint
				}
			}
		end
		
		if arg_20_1.is_exclusive then
			var_20_7 = {
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
			}
		end
		
		if arg_20_1.is_artifact then
			table.remove(var_20_7, 7)
			table.remove(var_20_7, 6)
			table.remove(var_20_7, 5)
		end
		
		if arg_20_1.is_artifact then
			local var_20_8 = {
				name = T("ui_inventory_sort_12"),
				func = EQUIP.greaterThanName
			}
			
			if arg_20_1.use_enhancer then
				var_20_8 = {
					name = T("ui_inventory_sort_12"),
					func = ENHANCER.greaterThanName
				}
			end
			
			table.insert(var_20_7, var_20_8)
		end
		
		local var_20_9 = arg_20_1.is_artifact or false
		local var_20_10 = arg_20_1.is_exclusive or false
		local var_20_11 = arg_20_1.use_enhancer or false
		local var_20_12 = not var_20_9 and not var_20_10
		
		arg_20_0.vars.sorter = Sorter:create(arg_20_1.sorter_parent or arg_20_0.vars.wnd:getChildByName("n_sorting"), {
			useExtention = var_20_12
		})
		
		local var_20_13
		
		local function var_20_14(arg_21_0)
			if not var_20_13 then
				var_20_13 = {}
			end
			
			table.insert(var_20_13, arg_21_0)
		end
		
		if not var_20_11 then
			var_20_14({
				id = "hide_equipped",
				is_filter = true,
				name = T("sort_hide_equipped"),
				checked = arg_20_0.vars.hideEquippedItem
			})
		end
		
		if var_20_11 then
			local var_20_15 = "hide_max_upgrade_item"
			
			if arg_20_1.is_artifact then
				var_20_15 = "hide_max_upgrade_artifact"
			end
			
			var_20_14({
				id = "hide_max_enhance",
				is_filter = true,
				name = T(var_20_15),
				checked = arg_20_0.vars.hideMaxItem
			})
		end
		
		if var_20_12 then
			var_20_14({
				id = "show_detail",
				name = T("show_equip_detail"),
				checked = SAVE:getKeep("inventory_show_detail") or arg_20_0.vars.showEquipDetail
			})
		end
		
		arg_20_0.vars.sorter:setSorter({
			base_unit = arg_20_1.base_unit,
			base_equip = arg_20_1.base_equip,
			priority_sort_func = arg_20_1.priority_sort_func,
			default_sort_index = arg_20_1.default_sort_index,
			menus = var_20_7,
			checkboxs = var_20_13,
			not_update_check_boxes = var_20_12,
			callback_checkbox = function(arg_22_0, arg_22_1, arg_22_2)
				if arg_22_0 == "show_detail" then
					arg_20_0:setShowEquipDetailView(arg_22_2)
					arg_20_0:updateList()
				elseif arg_22_0 == "hide_equipped" then
					arg_20_0:setHideEquippedItems(arg_22_2)
					arg_20_0:updateList()
				elseif arg_22_0 == "hide_max_enhance" then
					arg_20_0:setHideMaxItems(arg_22_2)
					arg_20_0:updateList()
				end
			end,
			close_callback = function()
				local var_23_0
				
				if not var_20_11 and not table.empty(arg_20_0.vars.selected_equips) then
					for iter_23_0, iter_23_1 in pairs(arg_20_0.vars.selected_equips) do
						var_23_0 = iter_23_0
					end
				end
				
				arg_20_0:updateList()
				
				local var_23_1 = false
				
				for iter_23_2, iter_23_3 in pairs(arg_20_0.vars.equip_list) do
					if iter_23_3 == var_23_0 then
						var_23_1 = true
						
						break
					end
				end
				
				if not var_23_1 then
					var_23_0 = nil
					arg_20_0.vars.selected_equips = {}
				end
				
				arg_20_0:onSelectEquip(var_23_0)
				arg_20_0:refresh()
				
				if not var_23_1 then
					local var_23_2
					
					arg_20_0.vars.selected_equips = {}
				end
			end,
			callback_sort = function(arg_24_0, arg_24_1)
				arg_20_0:refresh()
				
				if arg_20_1.callback_sort then
					arg_20_1.callback_sort(arg_24_0, arg_24_1)
				end
			end
		})
		UIAction:Add(LOG(MOVE_TO(200, arg_20_0.vars.wnd:getPosition())), arg_20_0.vars.wnd, "block")
		arg_20_0.vars.wnd:setPositionX(arg_20_0.vars.wnd:getPositionX() + 900)
	end
	
	local var_20_16 = {
		onUpdate = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			if arg_20_0.vars.is_equip_enhancer then
				arg_20_0:_updateEquipEnhancerBar(arg_25_1, arg_25_3)
			else
				arg_20_0:_updateEquipBar(arg_25_1, arg_25_3)
			end
			
			if arg_20_0.vars.base_equip then
				arg_20_0:showExpUpEffect(arg_25_1, arg_25_3:isStone() and not arg_25_3:isLimitBreak(), "list", arg_25_3:isArtifact(), arg_25_3:count())
				
				if arg_20_0.vars.base_equip:isArtifact() then
					local var_25_0 = arg_25_3:checkLimitBreak(arg_20_0.vars.base_equip) and arg_20_0.vars.base_equip.dup_pt < 5
					
					arg_20_0:showSlvUpEffect(arg_25_1, var_25_0, "list")
				end
			end
			
			if_set_visible(arg_25_1, "n_private", false)
			
			if arg_25_3:isExclusive() then
				local var_25_1 = arg_25_3.op[2][2]
				local var_25_2 = UNIT:create({
					code = arg_25_3.db.exclusive_unit
				})
				local var_25_3 = DB("skill_equip", arg_25_3.db.exclusive_skill .. "_0" .. var_25_1, {
					"exc_number"
				})
				local var_25_4 = UIUtil:getSkillIcon(var_25_2, var_25_3, {
					notMyUnit = true,
					no_tooltip = true,
					show_exclusive_target = var_25_1
				})
				
				if_set_visible(var_25_4, "soul1", false)
				if_set_visible(var_25_4, "exclusive", true)
				if_set_visible(arg_25_1, "n_private", true)
				
				local var_25_5 = arg_25_1:getChildByName("n_private")
				local var_25_6 = arg_25_1:getChildByName("n_skill_icon1")
				
				if get_cocos_refid(var_25_6) then
					if get_cocos_refid(var_25_6.skill_icon) then
						var_25_6.skill_icon:removeFromParent()
					end
					
					var_25_6:addChild(var_25_4)
					
					var_25_6.skill_icon = var_25_4
				end
				
				if_set(arg_25_1, "txt_skill_num", var_25_3)
				SpriteCache:resetSprite(arg_25_1:getChildByName("img_hero_l"), "face/" .. var_25_2.db.face_id .. "_l.png")
				
				local var_25_7 = {
					no_popup = true,
					name = false,
					no_lv = true,
					no_role = true,
					no_grade = true,
					parent = arg_25_1:getChildByName("mob_icon")
				}
				
				UIUtil:getUserIcon(var_25_2, var_25_7)
				
				local var_25_8 = arg_25_1:getChildByName("item_name")
				
				if get_cocos_refid(var_25_8) then
					UIUserData:call(var_25_8, "MULTI_SCALE(2,50)")
				end
			end
			
			arg_25_1.equip = arg_25_3
			
			return arg_25_3.id
		end
	}
	
	arg_20_0.vars.base_unit = arg_20_1.base_unit
	arg_20_0.vars.is_artifact = arg_20_1.is_artifact
	arg_20_0.vars.is_exclusive = arg_20_1.is_exclusive
	arg_20_0.vars.equip_list = arg_20_1.equip_list
	arg_20_0.vars.is_upgrade_mode = arg_20_1.is_upgrade_mode
	arg_20_0.vars.parent = arg_20_1.parent
	arg_20_0.vars.select_callback = arg_20_1.select_callback
	arg_20_0.vars.is_equip_enhancer = arg_20_1.use_enhancer and not arg_20_0.vars.is_artifact
	
	if arg_20_0.vars.parent and arg_20_0.vars.wnd then
		arg_20_0.vars.parent:addChild(arg_20_0.vars.wnd)
	end
	
	local var_20_17
	
	if arg_20_0.vars.is_artifact then
		var_20_17 = load_control("wnd/artifact_bar.csb")
	elseif arg_20_0.vars.is_exclusive then
		var_20_17 = load_control("wnd/private_bar.csb")
	elseif arg_20_0.vars.is_equip_enhancer then
		var_20_17 = load_control("wnd/item_upgrade_equip_card.csb")
	else
		var_20_17 = load_control("wnd/item_bar.csb")
	end
	
	arg_20_0.vars.listview:setRenderer(var_20_17, var_20_16)
	
	if arg_20_0.vars.equip_list then
		arg_20_0:updateList(arg_20_0.vars.equip_list)
	end
	
	if get_cocos_refid(arg_20_0.vars.wnd) then
		if_set_visible(arg_20_0.vars.wnd, "btn_count_arti", arg_20_0.vars.is_artifact)
		if_set_visible(arg_20_0.vars.wnd, "btn_count", not arg_20_0.vars.is_artifact)
	end
	
	if arg_20_1.use_enhancer and not arg_20_1.is_artifact then
		if_set_visible(arg_20_0.vars.wnd, "n_autofill", true)
		if_set_visible(arg_20_0.vars.wnd, "btn_count", false)
		if_set_visible(arg_20_0.vars.wnd, "n_sorting", false)
	end
	
	arg_20_0.vars.listview:jumpToTop()
	EquipBeltEventInterface:addListener(arg_20_0.vars.wnd, arg_20_0)
end

function EquipBelt.hide(arg_26_0)
	if not arg_26_0.vars or not arg_26_0.vars.wnd then
		return 
	end
	
	if arg_26_0.vars.wnd then
		UIAction:Add(SEQ(MOVE_BY(200, 900), CALL(arg_26_0.destroy, arg_26_0)), arg_26_0.vars.wnd, "block")
	else
		arg_26_0:destroy()
	end
end

function EquipBelt.destroy(arg_27_0)
	Inventory:updateSorterCheckBox()
	
	if arg_27_0.vars.sorter:isShow() then
		BackButtonManager:pop()
	end
	
	arg_27_0.vars.listview:removeAllChildren()
	
	if arg_27_0.vars.wnd then
		arg_27_0.vars.wnd:removeFromParent()
		EquipBeltEventInterface:removeListener(arg_27_0.vars.wnd)
	end
	
	arg_27_0.vars = {}
end

function EquipBelt.getEquipList(arg_28_0)
	return arg_28_0.vars.equip_list
end

function EquipBelt.updateList(arg_29_0, arg_29_1)
	if arg_29_1 then
		arg_29_0.vars.equip_list = arg_29_1
	end
	
	if not arg_29_0.vars.original_list then
		arg_29_0.vars.original_list = table.shallow_clone(arg_29_0.vars.equip_list)
	end
	
	arg_29_0.vars.equip_list = arg_29_1 or arg_29_0.vars.original_list
	
	if arg_29_0.vars.hideEquippedItem or arg_29_0.vars.hideMaxItem then
		local var_29_0 = {}
		
		for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.equip_list) do
			if (not arg_29_0.vars.hideEquippedItem or not iter_29_1.parent) and (not arg_29_0.vars.hideMaxItem or iter_29_1:isStone() or not iter_29_1:isMaxEnhance()) then
				table.insert(var_29_0, iter_29_1)
			end
		end
		
		arg_29_0.vars.equip_list = var_29_0
	end
	
	arg_29_0.vars.selected_equips = {}
	
	arg_29_0.vars.sorter:setItems(arg_29_0.vars.equip_list)
	
	if arg_29_0.vars.is_equip_enhancer then
		table.sort(arg_29_0.vars.equip_list, function(arg_30_0, arg_30_1)
			if arg_30_0.grade == arg_30_1.grade then
				if (arg_30_0.db.ma_type2 == "equip" or arg_30_0.db.ma_type2 == "jewellery") and arg_30_1.db.ma_type2 ~= "equip" and arg_30_0.db.ma_type2 ~= "jewellery" then
					return false
				end
				
				if (arg_30_1.db.ma_type2 == "equip" or arg_30_1.db.ma_type2 == "jewellery") and arg_30_0.db.ma_type2 ~= "equip" and arg_30_0.db.ma_type2 ~= "jewellery" then
					return true
				end
			end
			
			return arg_30_0.grade < arg_30_1.grade
		end)
		
		local var_29_1 = {}
		local var_29_2 = {}
		
		for iter_29_2, iter_29_3 in pairs(arg_29_0.vars.equip_list) do
			if iter_29_3:count() <= 0 then
				var_29_1[iter_29_2] = true
				
				table.insert(var_29_2, iter_29_3)
			end
		end
		
		for iter_29_4 = table.count(arg_29_0.vars.equip_list), 1, -1 do
			if var_29_1[iter_29_4] then
				table.remove(arg_29_0.vars.equip_list, iter_29_4)
			end
		end
		
		for iter_29_5, iter_29_6 in pairs(var_29_2) do
			table.insert(arg_29_0.vars.equip_list, iter_29_6)
		end
	else
		arg_29_0.vars.equip_list = arg_29_0.vars.sorter:sort()
	end
	
	arg_29_0:refresh()
	
	if arg_29_0.vars.sorter.sorter_extention then
		SorterExtentionUtil:set_itemSetCounts(arg_29_0.vars.sorter.sorter_extention:get_setBox(), arg_29_0.vars.original_list)
	end
	
	arg_29_0:UpdateEquipListCounter()
end

function EquipBelt.refresh(arg_31_0)
	arg_31_0.vars.listview:setDataSource(arg_31_0.vars.equip_list)
end

function EquipBelt.getTopWeaponControl(arg_32_0)
	if arg_32_0.vars and arg_32_0.vars.listview and arg_32_0.vars and arg_32_0.vars.equip_list then
		for iter_32_0, iter_32_1 in ipairs(arg_32_0.vars.equip_list) do
			local var_32_0
			
			if iter_32_1.material_stone then
				var_32_0 = iter_32_1.material_stone.db.ma_type2
			else
				var_32_0 = iter_32_1.db.type
			end
			
			if var_32_0 == "weapon" then
				return (arg_32_0.vars.listview:getControl(iter_32_1))
			end
		end
	end
end

function EquipBelt.getEquipItemControl(arg_33_0, arg_33_1)
	if arg_33_0.vars and arg_33_0.vars.listview and arg_33_0.vars and arg_33_0.vars.equip_list then
		for iter_33_0, iter_33_1 in ipairs(arg_33_0.vars.equip_list) do
			if iter_33_1.code == arg_33_1 then
				return (arg_33_0.vars.listview:getControl(iter_33_1))
			end
		end
	end
end

function EquipBelt.sortUID(arg_34_0)
	if not arg_34_0.vars or not arg_34_0.vars.sorter then
		return 
	end
	
	arg_34_0.vars.sorter:sort(2)
end

function EquipBelt.setSelect(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_1 then
		return 
	end
	
	arg_35_0.vars.selected_equips[arg_35_1] = arg_35_2
	
	local var_35_0 = arg_35_0.vars.listview:getControl(arg_35_1)
	
	if var_35_0 then
		if_set_visible(var_35_0, "eq_selected", arg_35_0.vars.selected_equips[arg_35_1])
	end
end

function EquipBelt.removeEquip(arg_36_0, arg_36_1)
	if arg_36_0.vars.original_list then
		table.removeByValue(arg_36_0.vars.original_list, arg_36_1)
		
		if arg_36_0.vars.sorter.sorter_extention then
			SorterExtentionUtil:set_itemSetCounts(arg_36_0.vars.sorter.sorter_extention:get_setBox(), arg_36_0.vars.original_list)
		end
	end
	
	table.removeByValue(arg_36_0.vars.equip_list, arg_36_1)
	arg_36_0.vars.listview:refresh()
	arg_36_0:UpdateEquipListCounter()
end

function EquipBelt.addEquip(arg_37_0, arg_37_1)
	if arg_37_0.vars.original_list then
		table.insert(arg_37_0.vars.original_list, arg_37_1)
		
		if arg_37_0.vars.sorter.sorter_extention then
			SorterExtentionUtil:set_itemSetCounts(arg_37_0.vars.sorter.sorter_extention:get_setBox(), arg_37_0.vars.original_list)
		end
	end
	
	arg_37_0:updateList()
end

function EquipBelt.updateEquipBar(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0.vars.listview:getControl(arg_38_1)
	
	if arg_38_0.vars.is_equip_enhancer then
		arg_38_0:_updateEquipEnhancerBar(var_38_0, arg_38_1)
	else
		arg_38_0:_updateEquipBar(var_38_0, arg_38_1)
	end
end

function EquipBelt._updateEquipBar(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_1 then
		return 
	end
	
	local var_39_0 = SAVE:getKeep("inventory_show_detail") or arg_39_0.vars.showEquipDetail
	
	var_39_0 = var_39_0 and not arg_39_2:isExclusive() and not arg_39_2:isArtifact()
	
	UIUtil:updateEquipBar(arg_39_1, arg_39_2, {
		equip_belt = true,
		show_detail = var_39_0
	})
	
	if arg_39_2:isArtifact() then
		local var_39_1 = arg_39_0.vars.base_equip
		
		if var_39_1 then
			if var_39_1:isBreakThrough() and arg_39_2:isLimitBreak() then
				if_set_visible(arg_39_1, "dim", true)
			elseif not var_39_1:isMaxEnhance() or var_39_1.dup_pt < 5 and arg_39_2:checkLimitBreak(var_39_1) then
				if_set_visible(arg_39_1, "dim", false)
			else
				if_set_visible(arg_39_1, "dim", true)
			end
		elseif arg_39_0.vars.base_unit then
			if_set_visible(arg_39_1, "dim", not arg_39_2:checkRole(arg_39_0.vars.base_unit))
		end
	end
	
	if arg_39_2:isExclusive() then
		if arg_39_0.vars.base_unit.db.code ~= arg_39_2.db.exclusive_unit then
			if_set_opacity(arg_39_1, nil, 76.5)
		end
		
		if_set_visible(arg_39_1, "equip", arg_39_2.parent)
		if_set_visible(arg_39_1, "icon_new", false)
		if_set_visible(arg_39_1, "icon_check", false)
		arg_39_1:setScale(0.9)
		arg_39_1:setPositionX(7)
	end
	
	if arg_39_2.parent then
		local var_39_2 = Account:getUnit(arg_39_2.parent)
		
		if var_39_2 ~= nil then
			UIUtil:getRewardIcon("c", var_39_2:getDisplayCode(), {
				no_popup = true,
				no_grade = true,
				parent = arg_39_1:getChildByName("n_unit_icon")
			})
			if_set_visible(arg_39_1, "n_unit_icon", true)
			if_set_visible(arg_39_1, "locked", false)
		end
	end
	
	if_set_visible(arg_39_1, "eq_selected", arg_39_0.vars.selected_equips[arg_39_2])
end

function EquipBelt._updateEquipEnhancerBar(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_1 or not arg_40_2 then
		return 
	end
	
	UIUtil:updateEquipBar(arg_40_1, arg_40_2, {
		equip_belt = true
	})
	UIUtil:getRewardIcon(nil, arg_40_2.code, {
		no_popup = true,
		tooltip_delay = 300,
		no_grade = true,
		parent = arg_40_1:getChildByName("bg_item")
	})
	if_set_visible(arg_40_1, "icon_check", false)
	
	local var_40_0 = Account:getItemCount(arg_40_2.code)
	local var_40_1 = arg_40_2:getRewardIconCountValue()
	
	use_count = var_40_0 - var_40_1
	
	if use_count > 0 then
		if_set(arg_40_1, "t_count", var_40_1 .. "(" .. "-" .. use_count .. ")")
		if_set_color(arg_40_1, "t_count", tocolor("#6bc11b"))
	else
		if_set(arg_40_1, "t_count", var_40_0)
		if_set_color(arg_40_1, "t_count", tocolor("#FFFFFF"))
	end
	
	UIUserData:call(arg_40_1:getChildByName("t_count"), "SINGLE_WSCALE(91)")
	if_set(arg_40_1, "title_main", arg_40_2:getName())
	if_set(arg_40_1, "t_main_stat", comma_value(arg_40_2.db.get_xp))
	
	local var_40_2 = getChildByPath(arg_40_1, "title_main")
	
	if get_cocos_refid(var_40_2) then
		UIUserData:call(var_40_2, "MULTI_SCALE_LONG_WORD(),MULTI_SCALE(2,60)")
	end
	
	if var_40_0 <= 0 then
		arg_40_1:setOpacity(76.5)
	else
		arg_40_1:setOpacity(255)
	end
end

function EquipBelt.showSlvUpEffect(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not arg_41_1 then
		return 
	end
	
	local var_41_0 = arg_41_1:getChildByName("list_tag_arti_max")
	
	if arg_41_2 then
		if not var_41_0 then
			var_41_0 = CACHE:getEffect("list_tag_arti_max")
			
			if arg_41_3 == "list" then
				var_41_0:setPosition(60, 94)
				var_41_0:setAnimation(0, arg_41_3, true)
				var_41_0.body:update(1000)
			elseif arg_41_3 == "slot" then
				var_41_0:setPosition(55, 30)
				var_41_0:setAnimation(0, arg_41_3)
			end
			
			var_41_0:setScale(1.3)
			arg_41_1:addChild(var_41_0)
		end
	elseif var_41_0 then
		arg_41_1:removeChild(var_41_0)
	end
	
	return var_41_0
end

function EquipBelt.UpdateEquipListCounter(arg_42_0)
	if not arg_42_0.vars or not arg_42_0.vars.wnd or not get_cocos_refid(arg_42_0.vars.wnd) then
		return 
	end
	
	local var_42_0 = tostring(#arg_42_0.vars.equip_list)
	local var_42_1 = Account:getCurrentEquipCount()
	local var_42_2 = arg_42_0.vars.wnd:getChildByName("btn_count")
	
	if arg_42_0.vars.is_artifact then
		var_42_1 = Account:getCurrentArtifactCount()
		var_42_2 = arg_42_0.vars.wnd:getChildByName("btn_count_arti")
	end
	
	if_set(var_42_2, "t_count", var_42_0 .. "/" .. var_42_1)
end

function EquipBelt.showExpUpEffect(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if not arg_43_1 then
		return 
	end
	
	if not arg_43_4 then
		return 
	end
	
	local var_43_0 = arg_43_1:getChildByName("list_tag_exp")
	local var_43_1 = arg_43_5 or 0
	
	if arg_43_2 then
		if not var_43_0 then
			var_43_0 = CACHE:getEffect("list_tag_exp")
			
			if arg_43_4 then
				if arg_43_3 == "list" then
					var_43_0:setPosition(66, 116)
					var_43_0:setAnimation(0, arg_43_3, true)
				elseif arg_43_3 == "slot" then
					var_43_0:setPosition(55, 24)
					var_43_0:setAnimation(0, arg_43_3)
					var_43_0:setScale(1.2)
				end
			elseif arg_43_3 == "list" then
				if var_43_1 <= 0 then
					var_43_0 = nil
					
					if get_cocos_refid(arg_43_1._effect) then
						arg_43_1._effect:removeFromParent()
						
						arg_43_1._effect = nil
					end
				else
					var_43_0:setPosition(60, 85)
					var_43_0:setAnimation(0, arg_43_3, true)
				end
			elseif arg_43_3 == "slot" then
				var_43_0:setPosition(42, 10)
				var_43_0:setAnimation(0, arg_43_3)
			end
			
			if var_43_0 then
				arg_43_1:addChild(var_43_0)
				
				arg_43_1._effect = var_43_0
			end
		end
	elseif var_43_0 then
		arg_43_1:removeChild(var_43_0)
	end
	
	return var_43_0
end

function EquipBelt.setTouchEnabled(arg_44_0, arg_44_1)
	if arg_44_0.vars and get_cocos_refid(arg_44_0.vars.listview) then
		arg_44_0.vars.listview:setTouchEnabled(arg_44_1)
	end
end
