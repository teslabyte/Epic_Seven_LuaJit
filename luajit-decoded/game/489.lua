SanctuaryCraftReset = {}

local var_0_0 = {
	"weapon",
	"armor",
	"neck",
	"helm",
	"boot",
	"ring"
}
local var_0_1 = {
	weapon = 1,
	armor = 2,
	boot = 5,
	ring = 6,
	helm = 4,
	neck = 3
}

function HANDLER_BEFORE.equip_craft_reset(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 == "btn_select" then
		arg_1_0.touch_tick = systick()
	end
end

function HANDLER.equip_craft_reset(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_produce" then
		SanctuaryCraftReset:openConfirmPopup()
	elseif arg_2_1 == "btn_select" and systick() - to_n(arg_2_0.touch_tick) < 180 then
		SanctuaryCraftReset:onSelectEquip(arg_2_0.data)
	elseif string.starts(arg_2_1, "btn_equip_tab") then
		SanctuaryCraftReset:selectTab(string.sub(arg_2_1, -1, -1))
	end
end

function HANDLER.equip_craft_reset_confirm(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ok" then
		SanctuaryCraftReset:reqResetItem()
		SanctuaryCraftReset:closeConfirmPopup()
	elseif arg_3_1 == "btn_cancel" then
		SanctuaryCraftReset:closeConfirmPopup()
	end
end

function HANDLER.equip_craft_reset_result(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_bg" then
		SanctuaryCraftReset:closeResultPopup()
	elseif arg_4_1 == "btn_cancel" then
		SanctuaryCraftReset:closeResultPopup()
	elseif arg_4_1 == "btn_reinforce" then
		SanctuaryCraftReset:openUpgradePopup()
		SanctuaryCraftReset:closeResultPopup()
	end
end

function MsgHandler.reset_enhance_equip(arg_5_0)
	local var_5_0 = arg_5_0.rewards or {}
	local var_5_1 = var_5_0.new_items or {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		Account:setItemCount(iter_5_1.code, iter_5_1.c)
	end
	
	Account:updateCurrencies(var_5_0)
	TopBarNew:topbarUpdate(true)
	SanctuaryCraftReset:resResetItem(arg_5_0)
end

function SanctuaryCraftReset.onEnter(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}
	
	local var_6_0 = arg_6_1.layer or SceneManager:getRunningPopupScene()
	
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = load_dlg("equip_craft_reset", true, "wnd")
	arg_6_0.vars.layer = var_6_0
	
	var_6_0:addChild(arg_6_0.vars.wnd)
	
	local var_6_1 = UIUtil:getPortraitAni("npc1126", {})
	
	if var_6_1 then
		arg_6_0.vars.wnd:getChildByName("n_portrait"):addChild(var_6_1)
		var_6_1:setName("@portrait")
		var_6_1:setScale(0.7)
	end
	
	EffectManager:Play({
		z = 99999,
		fn = "eff_equipreset_slot_1.cfx",
		layer = arg_6_0.vars.wnd:getChildByName("bg_effect")
	})
	arg_6_0.vars.wnd:getChildByName("n_balloon"):setScale(0)
	UIUtil:playNPCSoundAndTextRandomly("reforge.reset", arg_6_0.vars.wnd, "txt_balloon", nil, "reforge.reset")
	arg_6_0:initEquipResetDB()
	arg_6_0:updateEquips()
	arg_6_0:initListView()
	arg_6_0:initSorter()
	arg_6_0:selectTab(arg_6_1.tab or 1)
	arg_6_0:updateUI()
end

function SanctuaryCraftReset._forcedSelectItem(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = var_0_1[arg_7_1.db.type]
	
	if not var_7_0 then
		return 
	end
	
	arg_7_0:selectTab(var_7_0)
	
	local var_7_1
	local var_7_2 = arg_7_0:getEquips()
	
	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		if iter_7_1:getUID() == arg_7_1:getUID() then
			var_7_1 = iter_7_1
		end
	end
	
	arg_7_0:onSelectEquip(var_7_1)
end

function SanctuaryCraftReset.onLeave(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) or get_cocos_refid(arg_8_0.vars.confirm_wnd) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_8_0.vars.wnd, "block")
	
	arg_8_0.vars = nil
end

function SanctuaryCraftReset.updateUI(arg_9_0)
	arg_9_0:updateCenterUI()
	arg_9_0:updateLeftUI()
end

local function var_0_2(arg_10_0, arg_10_1, arg_10_2)
	if_set_visible(arg_10_1, "n_select", arg_10_2.selected)
	if_set_visible(arg_10_1, "icon_type", arg_10_2.isEquip ~= nil)
	if_set_visible(arg_10_1, "equip", arg_10_2 and arg_10_2.parent)
	if_set_visible(arg_10_1, "item_slot", true)
	if_set_visible(arg_10_1, "arti_slot", false)
	
	local var_10_0 = arg_10_1:getChildByName("bg_item")
	local var_10_1 = arg_10_1:getChildByName("txt_value")
	local var_10_2 = arg_10_1:getChildByName("n_txt_value")
	local var_10_3 = arg_10_1:getChildByName("n_img_value")
	
	var_10_3:setVisible(true)
	var_10_2:setVisible(false)
	
	local var_10_4 = UIUtil:getRewardIcon("equip", arg_10_2.code, {
		tooltip_delay = 130,
		parent = var_10_0,
		equip = arg_10_2
	})
	local var_10_5, var_10_6, var_10_7, var_10_8 = arg_10_2:getMainStat()
	
	if UNIT.is_percentage_stat(var_10_6) then
		var_10_5 = to_var_str(var_10_5, var_10_6)
	else
		var_10_5 = comma_value(math.floor(var_10_5))
	end
	
	local var_10_9 = arg_10_1:getChildByName("icon_type")
	
	var_10_9:setVisible(true)
	var_10_3:setVisible(true)
	SpriteCache:resetSprite(var_10_9, "img/cm_icon_stat_" .. string.gsub(var_10_6, "_rate", "") .. ".png")
	UIUtil:resetImageNumber(var_10_3, var_10_5)
	
	local var_10_10 = SanctuaryCraftReset:getContentConfig(arg_10_2.db.type)
	
	if not (var_10_10 and var_10_10.count > arg_10_2:getResetCount()) then
		var_10_0:setOpacity(76.5)
		var_10_1:setOpacity(76.5)
		var_10_2:setOpacity(76.5)
		var_10_3:setOpacity(76.5)
		var_10_9:setOpacity(76.5)
	end
	
	if arg_10_2.parent then
		local var_10_11 = Account:getUnit(arg_10_2.parent)
		
		if var_10_11 ~= nil then
			UIUtil:getRewardIcon("c", var_10_11:getDisplayCode(), {
				no_popup = true,
				no_grade = true,
				parent = arg_10_1:getChildByName("n_mob_icon")
			})
			if_set_visible(arg_10_1, "n_mob_icon", true)
			if_set_visible(arg_10_1, "equip", true)
		end
	else
		if_set_visible(arg_10_1, "n_mob_icon", false)
		if_set_visible(arg_10_1, "equip", false)
	end
	
	local var_10_12 = SanctuaryCraftReset:getShowEquipPoint()
	
	if var_10_12 then
		if_set(arg_10_1, "t_equip_point", arg_10_2:getEquipPoint())
	end
	
	if_set_visible(arg_10_1, "icon_type", not var_10_12)
	if_set_visible(arg_10_1, "n_img_value", not var_10_12)
	if_set_visible(arg_10_1, "t_equip_point", var_10_12)
	
	local var_10_13 = arg_10_1:getChildByName("btn_select")
	
	if get_cocos_refid(var_10_13) then
		var_10_13.data = arg_10_2
	end
	
	arg_10_2.renderer = arg_10_1
end

function SanctuaryCraftReset.initListView(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	arg_11_0.vars.listview = arg_11_0.vars.wnd:getChildByName("listview")
	arg_11_0.vars.listview = ItemListView:bindControl(arg_11_0.vars.listview)
	
	local var_11_0 = {
		onUpdate = var_0_2
	}
	local var_11_1 = load_control("wnd/inventory_card.csb")
	
	arg_11_0.vars.listview:setRenderer(var_11_1, var_11_0)
	arg_11_0:updateListView()
end

local function var_0_3(arg_12_0, arg_12_1)
	local var_12_0 = SanctuaryCraftReset:getResetScore(arg_12_0)
	local var_12_1 = SanctuaryCraftReset:getResetScore(arg_12_1)
	
	if var_12_0 == var_12_1 then
		return EQUIP.greaterThanGrade(arg_12_0, arg_12_1)
	end
	
	return var_12_1 < var_12_0
end

function SanctuaryCraftReset.initSorter(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	if not arg_13_0.vars.sorter then
		arg_13_0.vars.sorter = Sorter:create(arg_13_0.vars.wnd:getChildByName("btn_sorting"), {
			use_level_filter = true,
			useExtention = true,
			movePosition = true
		})
		
		local var_13_0 = {}
		
		for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.levels or {}) do
			local var_13_1 = {
				is_filter = true,
				default_flag = true,
				id = iter_13_0,
				name = T("ui_equip_reset_level_filter_" .. iter_13_0),
				checked = arg_13_0.vars.levels[iter_13_0]
			}
			
			table.insert(var_13_0, var_13_1)
		end
		
		table.sort(var_13_0, function(arg_14_0, arg_14_1)
			return arg_14_0.id < arg_14_1.id
		end)
		table.insert(var_13_0, {
			id = "show_point",
			name = T("ui_equip_score_view"),
			checked = arg_13_0.vars.showEquipPoint
		})
		
		local var_13_2 = {
			{
				name = T("ui_unit_item_recommend"),
				func = var_0_3
			},
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
		local var_13_3 = 1
		
		arg_13_0.vars.sorter:setSorter({
			priority_sort_func = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				if not arg_13_0.vars or not arg_13_0.vars.content_config then
					return nil
				end
				
				local var_15_0 = arg_15_0:getResetCount() < arg_13_0.vars.content_config.count
				local var_15_1 = arg_15_1:getResetCount() < arg_13_0.vars.content_config.count
				
				if var_15_0 and not var_15_1 then
					return true
				end
				
				if var_15_1 and not var_15_0 then
					return false
				end
				
				return nil
			end,
			default_sort_index = var_13_3,
			menus = var_13_2,
			checkboxs = var_13_0,
			callback_checkbox = function(arg_16_0, arg_16_1, arg_16_2)
				if arg_16_0 == "show_point" then
					arg_13_0:setShowEquipPoint(arg_16_2)
					arg_13_0:updateListView()
					
					return 
				end
				
				if arg_13_0:setLevelFilter(arg_16_0, arg_16_2) then
					arg_13_0:resetData()
				else
					balloon_message_with_sound("equip_reset_level_error_msg_1")
					arg_13_0.vars.sorter:toggle(arg_16_1)
				end
			end,
			close_callback = function()
				arg_13_0:resetData()
			end,
			callback_sort = function(arg_18_0, arg_18_1)
				arg_13_0:updateListView()
			end
		})
	end
	
	arg_13_0.vars.sorter:setVisible(true)
end

function SanctuaryCraftReset.setShowEquipPoint(arg_19_0, arg_19_1)
	if not arg_19_0.vars then
		return 
	end
	
	arg_19_0.vars.show_equip_point = arg_19_1
end

function SanctuaryCraftReset.getShowEquipPoint(arg_20_0)
	return arg_20_0.vars and arg_20_0.vars.show_equip_point
end

function SanctuaryCraftReset.setLevelFilter(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0.vars or not arg_21_0.vars.levels then
		return 
	end
	
	arg_21_0.vars.levels[arg_21_1] = arg_21_2
	
	local var_21_0 = true
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.levels) do
		if iter_21_1 then
			var_21_0 = false
			
			break
		end
	end
	
	if var_21_0 then
		arg_21_0.vars.levels[arg_21_1] = true
		
		return false
	end
	
	return true
end

function SanctuaryCraftReset.updateEquips(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	arg_22_0.vars.equips = {}
	
	for iter_22_0, iter_22_1 in pairs(var_0_0) do
		arg_22_0.vars.equips[iter_22_1] = {}
	end
	
	for iter_22_2, iter_22_3 in pairs(Account.equips) do
		if arg_22_0:isVisibleEquip(iter_22_3) then
			local var_22_0 = iter_22_3:clone()
			
			if arg_22_0.vars.equips[var_22_0.db.type] then
				table.insert(arg_22_0.vars.equips[var_22_0.db.type], var_22_0)
			end
		end
	end
end

function SanctuaryCraftReset.resetData(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if arg_23_0.vars.sorter then
		local var_23_0 = arg_23_0:getEquips()
		
		arg_23_0.vars.sorter:setItems(var_23_0)
		arg_23_0.vars.sorter:sort()
		SorterExtentionUtil:set_itemSetCounts(arg_23_0.vars.sorter.sorter_extention:get_setBox(), var_23_0)
	else
		arg_23_0:updateListView()
	end
end

function SanctuaryCraftReset.isVisibleEquip(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return false
	end
	
	if not var_0_1[arg_24_1.db.type] then
		return false
	end
	
	if not arg_24_0.vars.material_db[var_0_1[arg_24_1.db.type]] then
		return false
	end
	
	if not arg_24_0.vars.material_db[var_0_1[arg_24_1.db.type]][arg_24_1.db.item_level] then
		return false
	end
	
	if arg_24_1:getEnhance() < 3 then
		return false
	end
	
	if arg_24_1:isSubStatChanged() then
		return false
	end
	
	return true
end

function SanctuaryCraftReset.updateListView(arg_25_0)
	if not arg_25_0.vars or not arg_25_0.vars.listview then
		return 
	end
	
	local var_25_0 = arg_25_0:getEquips()
	
	if arg_25_0.vars.sorter then
		var_25_0 = arg_25_0.vars.sorter:getSortedList()
	end
	
	arg_25_0.vars.listview:setItems(var_25_0)
	if_set_visible(arg_25_0.vars.wnd, "no_data", table.empty(var_25_0))
end

function SanctuaryCraftReset.selectTab(arg_26_0, arg_26_1)
	if not arg_26_0.vars then
		return 
	end
	
	arg_26_1 = to_n(arg_26_1)
	
	for iter_26_0 = 1, #var_0_0 do
		local var_26_0 = arg_26_0.vars.wnd:getChildByName("btn_equip_tab" .. iter_26_0)
		
		if get_cocos_refid(var_26_0) then
			if_set_visible(var_26_0, "bg_tab", iter_26_0 == arg_26_1)
		end
	end
	
	arg_26_0.vars.tab = arg_26_1
	arg_26_0.vars.content_config = arg_26_0:getContentConfig(var_0_0[arg_26_1])
	
	arg_26_0:resetData()
end

function SanctuaryCraftReset.getEquips(arg_27_0)
	if not arg_27_0.vars then
		return {}
	end
	
	if not arg_27_0.vars.equips then
		return {}
	end
	
	local var_27_0 = arg_27_0.vars.equips[var_0_0[arg_27_0.vars.tab]] or {}
	
	if arg_27_0.vars.levels then
		local var_27_1 = {}
		
		for iter_27_0, iter_27_1 in pairs(var_27_0) do
			if arg_27_0.vars.levels[iter_27_1.db.item_level] then
				table.insert(var_27_1, iter_27_1)
			end
		end
		
		return var_27_1
	end
	
	return var_27_0
end

function SanctuaryCraftReset.onSelectEquip(arg_28_0, arg_28_1)
	if not arg_28_0.vars then
		return 
	end
	
	if arg_28_1 then
		local var_28_0 = arg_28_1.selected
		
		arg_28_0:deselectEquip()
		
		if not var_28_0 then
			arg_28_1.selected = true
			
			if_set_visible(arg_28_1.renderer, "n_select", true)
			
			arg_28_0.vars.selected_equip = arg_28_1
		end
	else
		arg_28_0:deselectEquip()
	end
	
	arg_28_0:updateCenterUI()
end

function SanctuaryCraftReset.deselectEquip(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	if arg_29_0.vars.selected_equip then
		if_set_visible(arg_29_0.vars.selected_equip.renderer, "n_select", false)
		
		arg_29_0.vars.selected_equip.selected = false
		arg_29_0.vars.selected_equip = nil
	end
	
	arg_29_0.vars.selected_material = nil
end

function SanctuaryCraftReset.onSelectMaterial(arg_30_0, arg_30_1)
	if not arg_30_0.vars then
		return 
	end
	
	if not arg_30_1 then
		return 
	end
	
	arg_30_0.vars.selected_material = arg_30_1
	
	arg_30_0:updateMaterialSelector()
end

function SanctuaryCraftReset.updateCenterUI(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.selected_equip
	
	if_set_visible(arg_31_0.vars.wnd, "n_no_select", not var_31_0)
	if_set_visible(arg_31_0.vars.wnd, "n_stat", var_31_0)
	if_set_visible(arg_31_0.vars.wnd, "btn_produce", var_31_0)
	arg_31_0:updateEquipInfoUI(var_31_0)
	arg_31_0:updateMaterialSelector()
	
	if var_31_0 then
		local var_31_1 = arg_31_0.vars.wnd:getChildByName("btn_produce")
		local var_31_2 = arg_31_0.vars.content_config.count - var_31_0:getResetCount()
		
		if_set(var_31_1, "label", T("equip_reset_btn", {
			curr = var_31_2,
			max = arg_31_0.vars.content_config.count
		}))
		if_set(var_31_1, "cost", comma_value(arg_31_0.vars.content_config.price))
		
		local var_31_3 = var_31_2 > 0 and arg_31_0.vars.selected_material and Account:getItemCount(arg_31_0.vars.selected_material.id) > 0 and Account:getCurrency(arg_31_0.vars.content_config.token) >= arg_31_0.vars.content_config.price
		
		if_set_opacity(var_31_1, nil, var_31_3 and 255 or 76.5)
	end
end

function SanctuaryCraftReset.updateEquipInfoUI(arg_32_0, arg_32_1)
	arg_32_1 = arg_32_1 or arg_32_0.vars.selected_equip
	
	local var_32_0 = arg_32_0.vars.wnd:getChildByName("n_target")
	
	if get_cocos_refid(var_32_0) then
		var_32_0:removeAllChildren()
	end
	
	if arg_32_1 then
		UIUtil:getRewardIcon("equip", arg_32_1.code, {
			tooltip_delay = 130,
			parent = var_32_0,
			equip = arg_32_1
		})
		arg_32_0:setCurItemInfo(arg_32_1)
		arg_32_0:setResetItemInfo(arg_32_1)
	end
	
	arg_32_0:setEquipName(arg_32_1)
end

function SanctuaryCraftReset.setCurItemInfo(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1 or arg_33_0.vars.selected_equip
	local var_33_1 = arg_33_0.vars.wnd:getChildByName("n_stat")
	
	if_set(var_33_1, "t_level", var_33_0.db.item_level)
	
	local var_33_2, var_33_3 = var_33_0:getMainStat()
	
	SpriteCache:resetSprite(var_33_1:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_33_3, "_rate", "") .. ".png")
	if_set(var_33_1, "txt_main_stat", to_var_str(var_33_2, var_33_3))
	if_set(var_33_1, "txt_main_name", getStatName(var_33_3))
	
	local var_33_4 = {}
	local var_33_5 = {}
	local var_33_6 = 0
	
	for iter_33_0 = 2, 99 do
		if var_33_0.op[iter_33_0] then
			local var_33_7 = var_33_0.op[iter_33_0][1]
			local var_33_8 = var_33_0.op[iter_33_0][2]
			
			if not var_33_5[var_33_7] then
				var_33_6 = var_33_6 + 1
				var_33_5[var_33_7] = var_33_6
			end
			
			if type(var_33_8) == "table" then
				var_33_4[var_33_7] = var_33_8
			else
				var_33_4[var_33_7] = (var_33_4[var_33_7] or 0) + var_33_8
			end
		else
			break
		end
	end
	
	for iter_33_1, iter_33_2 in pairs(var_33_4) do
		local var_33_9 = var_33_5[iter_33_1]
		local var_33_10 = var_33_1:findChildByName("txt_sub_name" .. var_33_9)
		
		if_set(var_33_10, nil, getStatName(iter_33_1))
		
		if type(iter_33_2) == "table" then
			if_set(var_33_1, "txt_sub_stat" .. var_33_9, to_var_str(iter_33_2[1], iter_33_1, nil, true) .. "-" .. to_var_str(iter_33_2[2], iter_33_1))
		else
			if_set(var_33_1, "txt_sub_stat" .. var_33_9, to_var_str(iter_33_2, iter_33_1))
		end
	end
	
	for iter_33_3 = 0, 3 do
		if_set_visible(var_33_1, tostring(iter_33_3), iter_33_3 < var_33_6)
	end
end

function SanctuaryCraftReset.setResetItemInfo(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_1 or arg_34_0.vars.selected_equip
	local var_34_1 = arg_34_0.vars.wnd:getChildByName("n_stat")
	local var_34_2 = arg_34_0:getBaseEquipInfo(var_34_0)
	
	if var_34_2 then
		if_set(var_34_1, "t_main_stat_after", to_var_str(var_34_2.main_stat[2], var_34_2.main_stat[1]))
		if_set(var_34_1, "t_level_after", var_34_2.item_level)
	else
		if_set(var_34_1, "t_main_stat_after", to_var_str(var_34_0.op[1][2], var_34_0.op[1][1]))
		if_set(var_34_1, "t_level_after", var_34_0.db.item_level)
	end
	
	local var_34_3 = var_34_1:getChildByName("t_level_after")
	local var_34_4 = var_34_2 and cc.c3b(37, 134, 233) or cc.c3b(255, 255, 255)
	
	if get_cocos_refid(var_34_3) then
		var_34_3:setTextColor(var_34_4)
		var_34_3:enableOutline(var_34_4, 1)
	end
	
	if_set_color(var_34_1, "icon_arr", var_34_4)
	
	local var_34_5 = {}
	local var_34_6 = {}
	local var_34_7 = 0
	
	for iter_34_0 = 2, var_34_0.grade do
		if var_34_0.op[iter_34_0] then
			local var_34_8 = var_34_0.op[iter_34_0][1]
			local var_34_9 = var_34_0.op[iter_34_0][2]
			
			if not var_34_6[var_34_8] then
				var_34_7 = var_34_7 + 1
				var_34_6[var_34_8] = var_34_7
			end
			
			if type(var_34_9) == "table" then
				var_34_5[var_34_8] = var_34_9
			else
				var_34_5[var_34_8] = (var_34_5[var_34_8] or 0) + var_34_9
			end
		else
			break
		end
	end
	
	for iter_34_1, iter_34_2 in pairs(var_34_5) do
		local var_34_10 = var_34_6[iter_34_1]
		
		if type(iter_34_2) == "table" then
			if_set(var_34_1, "t_sub_stat" .. var_34_10 .. "_after", to_var_str(iter_34_2[1], iter_34_1, nil, true) .. "-" .. to_var_str(iter_34_2[2], iter_34_1))
		else
			if_set(var_34_1, "t_sub_stat" .. var_34_10 .. "_after", to_var_str(iter_34_2, iter_34_1))
		end
	end
	
	for iter_34_3 = 1, 4 do
		if_set_visible(var_34_1, "t_sub_stat" .. iter_34_3 .. "_after", iter_34_3 <= var_34_7)
	end
end

function SanctuaryCraftReset.setEquipName(arg_35_0, arg_35_1)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	local var_35_0 = getChildByPath(arg_35_0.vars.wnd:getChildByName("n_equip_slot"), "txt_name")
	
	if get_cocos_refid(var_35_0) then
		if arg_35_1 then
			if_set(var_35_0, nil, T(arg_35_1.db.name))
		end
		
		if_set_visible(var_35_0, nil, arg_35_1 ~= nil)
	end
end

function SanctuaryCraftReset.getBaseEquipInfo(arg_36_0, arg_36_1)
	if not arg_36_0.vars or not arg_36_0.vars.base_equip_db then
		return 
	end
	
	if arg_36_1 then
		local var_36_0 = arg_36_1.code
		local var_36_1 = arg_36_0.vars.base_equip_db[var_36_0]
		
		if not var_36_1 then
			return nil
		end
		
		local var_36_2 = {}
		local var_36_3, var_36_4 = DB("equip_item", var_36_1, {
			"main_stat",
			"item_level"
		})
		
		if arg_36_0.vars.base_stat_db[var_36_3] then
			local var_36_5 = arg_36_1.stats[1][1]
			
			var_36_2.main_stat = {
				var_36_5,
				arg_36_0.vars.base_stat_db[var_36_3][var_36_5]
			}
		end
		
		var_36_2.item_level = var_36_4
		
		return var_36_2
	end
end

function SanctuaryCraftReset.initEquipResetDB(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	arg_37_0.vars.base_equip_db = {}
	
	for iter_37_0 = 1, 99 do
		local var_37_0, var_37_1 = DBN("item_equip_upgrade", iter_37_0, {
			"item_equip_base",
			"item_equip_result"
		})
		
		if not var_37_0 or not var_37_1 then
			break
		end
		
		arg_37_0.vars.base_equip_db[var_37_1] = var_37_0
	end
	
	arg_37_0.vars.base_stat_db = {}
	
	for iter_37_1, iter_37_2 in pairs(arg_37_0.vars.base_equip_db) do
		local var_37_2 = DB("equip_item", iter_37_2, "main_stat")
		
		if var_37_2 and not arg_37_0.vars.base_stat_db[var_37_2] then
			arg_37_0.vars.base_stat_db[var_37_2] = {}
			
			for iter_37_3 = 1, 99 do
				local var_37_3, var_37_4 = DB("equip_stat", var_37_2 .. "_" .. iter_37_3, {
					"stat_type",
					"val_max"
				})
				
				if not var_37_3 then
					break
				end
				
				local var_37_5 = DB("item_equip_stat_revision", var_37_3, "revise_max") or 1
				
				arg_37_0.vars.base_stat_db[var_37_2][var_37_3] = var_37_4 * var_37_5
			end
		end
	end
	
	arg_37_0.vars.levels = {}
	arg_37_0.vars.material_db = {}
	arg_37_0.vars.material_db.all = {}
	
	for iter_37_4 = 1, 99 do
		local var_37_6, var_37_7, var_37_8, var_37_9, var_37_10 = DBN("item_equip_reset", iter_37_4, {
			"id",
			"item_id",
			"type",
			"item_level",
			"sort"
		})
		
		if not var_37_6 then
			break
		end
		
		local var_37_11 = string.split(var_37_9, ";") or {}
		local var_37_12 = string.split(var_37_8, ";") or {}
		
		for iter_37_5, iter_37_6 in pairs(var_37_12) do
			local var_37_13 = var_0_1[iter_37_6]
			
			if not var_37_13 then
				Log.e("invalid equip type", iter_37_6)
				
				break
			end
			
			if not arg_37_0.vars.material_db[var_37_13] then
				arg_37_0.vars.material_db[var_37_13] = {}
			end
			
			for iter_37_7, iter_37_8 in pairs(var_37_11) do
				local var_37_14 = to_n(iter_37_8)
				
				arg_37_0.vars.levels[var_37_14] = true
				
				if not arg_37_0.vars.material_db[var_37_13][var_37_14] then
					arg_37_0.vars.material_db[var_37_13][var_37_14] = {}
				end
				
				table.insert(arg_37_0.vars.material_db[var_37_13][var_37_14], {
					id = var_37_7,
					sort = var_37_10
				})
			end
		end
		
		table.insert(arg_37_0.vars.material_db.all, {
			id = var_37_7,
			sort = var_37_10
		})
	end
	
	local function var_37_15(arg_38_0, arg_38_1)
		return arg_38_0.sort < arg_38_1.sort
	end
	
	for iter_37_9, iter_37_10 in pairs(arg_37_0.vars.material_db) do
		if iter_37_9 == "all" then
			table.sort(iter_37_10, var_37_15)
		else
			for iter_37_11, iter_37_12 in pairs(iter_37_10) do
				table.sort(iter_37_12, var_37_15)
			end
		end
	end
end

local function var_0_4(arg_39_0, arg_39_1, arg_39_2)
	if not get_cocos_refid(arg_39_0) then
		return 
	end
	
	if not arg_39_1 then
		return 
	end
	
	arg_39_2 = arg_39_2 or {}
	
	local var_39_0 = Account:getItemCount(arg_39_1.id) or 0
	local var_39_1 = UIUtil:getRewardIcon(var_39_0, arg_39_1.id, {
		show_count = true,
		tooltip_delay = 130,
		parent = arg_39_0,
		no_bg = arg_39_2.no_bg
	})
	
	if_set_opacity(var_39_1, nil, var_39_0 > 0 and 255 or 76.5)
end

function SanctuaryCraftReset.updateLeftUI(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.wnd:getChildByName("n_material")
	local var_40_1 = arg_40_0.vars.material_db.all
	local var_40_2 = table.count(var_40_1)
	
	if not get_cocos_refid(var_40_0) or var_40_2 < 4 then
		return 
	end
	
	for iter_40_0 = 1, var_40_2 do
		local var_40_3 = var_40_0:getChildByName("reward_item_" .. iter_40_0)
		
		if not get_cocos_refid(var_40_3) then
			break
		end
		
		var_0_4(var_40_3, var_40_1[iter_40_0], {
			no_bg = true
		})
	end
	
	var_40_0:setVisible(true)
end

function SanctuaryCraftReset.updateMaterialSelector(arg_41_0)
	if not arg_41_0.vars or not get_cocos_refid(arg_41_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_41_0.vars.wnd, "n_mater_needs_sel", false)
	if_set_visible(arg_41_0.vars.wnd, "n_mater_needs_1", false)
	
	local var_41_0 = arg_41_0.vars.selected_equip
	
	if not var_41_0 then
		return 
	end
	
	local var_41_1 = var_0_1[var_41_0.db.type]
	
	if not var_41_1 then
		return 
	end
	
	local var_41_2 = var_41_0.db.item_level
	local var_41_3 = arg_41_0.vars.material_db[var_41_1] and arg_41_0.vars.material_db[var_41_1][var_41_2]
	
	if not var_41_3 or table.empty(var_41_3) then
		return 
	end
	
	local var_41_4 = table.count(var_41_3)
	
	if not arg_41_0.vars.selected_material then
		arg_41_0.vars.selected_material = var_41_3[1]
	end
	
	if var_41_4 > 1 then
		local var_41_5 = arg_41_0.vars.wnd:getChildByName("n_mater_needs_sel")
		
		if get_cocos_refid(var_41_5) then
			for iter_41_0 = 1, 5 do
				if_set_visible(var_41_5, "n_" .. iter_41_0, false)
			end
			
			local var_41_6 = var_41_4 == 2 and 3 or 0
			
			for iter_41_1 = 1, var_41_4 do
				local var_41_7 = var_41_5:getChildByName("n_" .. iter_41_1 + var_41_6)
				
				if not get_cocos_refid(var_41_7) then
					break
				end
				
				var_0_4(var_41_7:getChildByName("reward_item_needs"), var_41_3[iter_41_1])
				if_set_visible(var_41_7, "select", arg_41_0.vars.selected_material.id == var_41_3[iter_41_1].id)
				if_set_visible(var_41_7, nil, true)
			end
			
			if_set_visible(var_41_5, nil, true)
		end
	elseif var_41_4 == 1 then
		local var_41_8 = arg_41_0.vars.wnd:getChildByName("n_mater_needs_1")
		
		if get_cocos_refid(var_41_8) then
			local var_41_9 = arg_41_0.vars.selected_material.id
			local var_41_10 = Account:getItemCount(var_41_9)
			local var_41_11, var_41_12 = DB("item_material", var_41_9, {
				"name",
				"desc_category"
			})
			
			if_set(var_41_8, "t_mater_disc", T(var_41_11))
			if_set(var_41_8, "t_item_category", T(var_41_12))
			
			local var_41_13 = UIUtil:getRewardIcon(1, var_41_9, {
				show_count = true,
				tooltip_delay = 130,
				parent = var_41_8:getChildByName("reward_item_needs")
			})
			
			if_set_opacity(var_41_13, nil, var_41_10 > 0 and 255 or 76.5)
			if_set_visible(var_41_8, "n_lack_item", var_41_10 < 1)
			if_set_visible(var_41_8, nil, true)
		end
	end
end

function SanctuaryCraftReset.getContentConfig(arg_42_0, arg_42_1)
	local var_42_0 = (function(arg_43_0)
		if not arg_43_0 then
			return 
		end
		
		if table.isInclude({
			"weapon",
			"helm",
			"armor",
			"boot"
		}, arg_43_0) then
			return "equip"
		elseif table.isInclude({
			"neck",
			"ring"
		}, arg_43_0) then
			return "jewellery"
		end
	end)(arg_42_1)
	
	if var_42_0 then
		local var_42_1 = GAME_CONTENT_VARIABLE[var_42_0 .. "_reset_token"] or "to_gold"
		local var_42_2 = GAME_CONTENT_VARIABLE[var_42_0 .. "_reset_price"] or 500000
		local var_42_3 = GAME_CONTENT_VARIABLE[var_42_0 .. "_reset_count"] or 0
		
		return {
			token = var_42_1,
			price = var_42_2,
			count = var_42_3
		}
	end
end

function SanctuaryCraftReset.getResetEquip(arg_44_0, arg_44_1)
	if not arg_44_1 then
		return 
	end
	
	if arg_44_1.reset_equip then
		return arg_44_1.reset_equip
	end
	
	local var_44_0
	
	if arg_44_0.vars and arg_44_0.vars.base_equip_db then
		var_44_0 = arg_44_0.vars.base_equip_db[arg_44_1.code] or arg_44_1.code
	else
		var_44_0 = arg_44_1.code
		
		for iter_44_0 = 1, 99 do
			local var_44_1, var_44_2 = DBN("item_equip_upgrade", iter_44_0, {
				"item_equip_base",
				"item_equip_result"
			})
			
			if var_44_2 == var_44_0 then
				var_44_0 = var_44_1
				
				break
			end
		end
	end
	
	local var_44_3 = {}
	
	for iter_44_1 = 1, arg_44_1.grade do
		if arg_44_1.op[iter_44_1] then
			table.insert(var_44_3, {
				arg_44_1.op[iter_44_1][1],
				arg_44_1.op[iter_44_1][2]
			})
		end
	end
	
	local var_44_4 = EQUIP:createByInfo({
		enhance = 0,
		code = var_44_0,
		op = var_44_3,
		grade = arg_44_1.grade,
		set_fx = arg_44_1.set_fx
	})
	
	arg_44_1.reset_equip = var_44_4
	
	return var_44_4
end

function SanctuaryCraftReset.openConfirmPopup(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	local var_45_0 = arg_45_0.vars.selected_equip
	local var_45_1 = arg_45_0.vars.selected_material
	
	if not var_45_0 or not var_45_1 then
		return 
	end
	
	local var_45_2 = arg_45_0.vars.content_config
	
	if not var_45_2 then
		return 
	end
	
	local var_45_3 = var_45_2.count - var_45_0:getResetCount()
	
	if var_45_3 <= 0 then
		balloon_message_with_sound("err_cannot_reset_msg_1")
		
		return 
	end
	
	if Account:getCurrency(var_45_2.token) < var_45_2.price then
		UIUtil:checkCurrencyDialog(var_45_2.token)
		
		return 
	end
	
	if Account:getItemCount(var_45_1.id) < 1 then
		balloon_message_with_sound("err_cannot_reset_msg_2")
		
		return 
	end
	
	local var_45_4 = arg_45_0:getBaseEquipInfo(var_45_0)
	local var_45_5 = arg_45_0:getResetEquip(var_45_0)
	
	if not var_45_5 then
		return 
	end
	
	arg_45_0.vars.confirm_wnd = load_dlg("equip_craft_reforging_confirm", true, "wnd", function()
		SanctuaryCraftReset:closeConfirmPopup()
	end)
	
	arg_45_0.vars.confirm_wnd:setName("equip_craft_reset_confirm")
	SceneManager:getRunningPopupScene():addChild(arg_45_0.vars.confirm_wnd)
	if_set(arg_45_0.vars.confirm_wnd, "txt_title", T("equip_reset_popup_title"))
	
	local var_45_6 = DB("item_material", var_45_1.id, "name")
	
	if_set(arg_45_0.vars.confirm_wnd, "t_disc", T("equip_reset_popup_desc", {
		count = 1,
		item_name = T(var_45_6)
	}))
	
	local var_45_7 = arg_45_0.vars.confirm_wnd:getChildByName("n_before")
	local var_45_8 = arg_45_0.vars.confirm_wnd:getChildByName("n_after")
	local var_45_9 = arg_45_0.vars.confirm_wnd:getChildByName("n_btn")
	
	ItemTooltip:updateItemInformation({
		no_resize = true,
		wnd = var_45_7,
		equip = var_45_0
	})
	ItemTooltip:updateItemInformation({
		no_resize = true,
		wnd = var_45_8,
		equip = var_45_5
	})
	if_set(var_45_9, "label_0", comma_value(var_45_2.price))
	if_set(var_45_9, "label", T("equip_reset_btn", {
		curr = var_45_3,
		max = var_45_2.count
	}))
	if_set_sprite(var_45_9, "Sprite_41", "item/token_gold.png")
	
	local var_45_10 = cc.c3b(37, 134, 233)
	
	if_set_color(arg_45_0.vars.confirm_wnd, "arrow_item", var_45_10)
	
	local var_45_11 = var_45_8:getChildByName("txt_main_stat")
	
	if get_cocos_refid(var_45_11) then
		var_45_11:setTextColor(var_45_10)
		var_45_11:enableOutline(var_45_10, 1)
		
		if var_45_4 then
			var_45_11:setString(to_var_str(var_45_4.main_stat[2], var_45_4.main_stat[1]))
		end
	end
	
	for iter_45_0 = 1, 4 do
		local var_45_12 = var_45_8:getChildByName("txt_sub_stat" .. iter_45_0)
		
		if get_cocos_refid(var_45_12) then
			var_45_12:setTextColor(var_45_10)
		end
	end
end

function SanctuaryCraftReset.closeConfirmPopup(arg_47_0)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.wnd) or not get_cocos_refid(arg_47_0.vars.confirm_wnd) then
		return 
	end
	
	BackButtonManager:pop({
		id = "equip_craft_reforging_confirm",
		dlg = arg_47_0.vars.confirm_wnd
	})
	arg_47_0.vars.confirm_wnd:removeFromParent()
end

function SanctuaryCraftReset.reqResetItem(arg_48_0)
	if not arg_48_0.vars then
		return 
	end
	
	if not arg_48_0.vars.selected_equip then
		return 
	end
	
	if not arg_48_0.vars.selected_material then
		return 
	end
	
	query("reset_enhance_equip", {
		target = arg_48_0.vars.selected_equip.id,
		material_id = arg_48_0.vars.selected_material.id
	})
end

function SanctuaryCraftReset.resResetItem(arg_49_0, arg_49_1)
	if not arg_49_0.vars then
		return 
	end
	
	local var_49_0 = arg_49_0.vars.selected_equip
	local var_49_1 = Account:addEquip(arg_49_1.equip, {
		ignore_get_condition = true
	})
	
	if var_49_0.parent then
		local var_49_2 = Account:getUnit(var_49_0.parent)
		
		if var_49_2 then
			var_49_2:removeEquip(var_49_0)
			var_49_2:addEquip(var_49_1)
		end
	end
	
	Account:removeEquip(var_49_0.id)
	
	if not var_49_1 then
		return 
	end
	
	arg_49_0:openResultPopup(var_49_1)
	
	local var_49_3 = load_dlg("item_detail_sub", true, "wnd")
	local var_49_4 = load_dlg("item_detail_sub", true, "wnd")
	
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = var_49_3,
		equip = var_49_0
	})
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = var_49_4,
		equip = var_49_1
	})
	
	local var_49_5 = arg_49_0.vars.result_wnd:getChildByName("arrow_item")
	local var_49_6 = arg_49_0.vars.result_wnd:getChildByName("title_bg")
	local var_49_7 = arg_49_0.vars.result_wnd:getChildByName("txt")
	local var_49_8 = arg_49_0.vars.result_wnd:getChildByName("n_btn")
	local var_49_9 = arg_49_0.vars.result_wnd:getChildByName("n_before"):getChildByName("n_item_tooltip")
	local var_49_10 = arg_49_0.vars.result_wnd:getChildByName("n_after"):getChildByName("n_item_tooltip")
	
	ItemTooltip:updateItemFrame(var_49_9, var_49_0, nil, "cm_tooltipbox")
	ItemTooltip:updateItemFrame(var_49_10, var_49_1, nil, "cm_tooltipbox")
	var_49_9:addChild(var_49_3)
	var_49_10:addChild(var_49_4)
	
	local var_49_11 = 0
	local var_49_12 = 285
	
	var_49_3:setPosition(var_49_11, var_49_12)
	var_49_4:setPosition(var_49_11, var_49_12)
	var_49_3:setAnchorPoint(0.5, 0.5)
	var_49_4:setAnchorPoint(0.5, 0.5)
	
	local var_49_13 = var_49_3:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_49_13) then
		local var_49_14 = var_49_13:getStringNumLines()
		
		if var_49_14 and var_49_14 >= 4 then
			local var_49_15 = var_49_9:getChildByName("cm_tooltipbox")
			local var_49_16 = var_49_10:getChildByName("cm_tooltipbox")
			
			if get_cocos_refid(var_49_15) and get_cocos_refid(var_49_16) then
				local var_49_17 = var_49_15:getContentSize()
				
				var_49_15:setContentSize({
					width = var_49_17.width,
					height = var_49_17.height + 20
				})
				var_49_16:setContentSize({
					width = var_49_17.width,
					height = var_49_17.height + 20
				})
			end
		end
	end
	
	var_49_9:setOpacity(0)
	var_49_10:setOpacity(0)
	var_49_5:setOpacity(0)
	var_49_6:setOpacity(0)
	var_49_7:setOpacity(0)
	var_49_8:setOpacity(0)
	
	local var_49_18 = 2000
	local var_49_19 = 300
	local var_49_20 = var_49_18 + 200
	local var_49_21 = 200
	
	UIAction:Add(SEQ(DELAY(var_49_20), FADE_IN(var_49_21)), var_49_9, "block")
	UIAction:Add(SEQ(DELAY(var_49_20), FADE_IN(var_49_21)), var_49_10, "block")
	UIAction:Add(SEQ(DELAY(var_49_20), FADE_IN(var_49_21)), var_49_5, "block")
	UIAction:Add(SEQ(DELAY(var_49_20), FADE_IN(var_49_21)), var_49_6, "block")
	UIAction:Add(SEQ(DELAY(var_49_20), FADE_IN(var_49_21)), var_49_7, "block")
	UIAction:Add(SEQ(DELAY(var_49_20), FADE_IN(var_49_21)), var_49_8, "block")
	EffectManager:Play({
		pivot_x = 640,
		fn = "ui_item_rewind_b.cfx",
		pivot_y = 360,
		pivot_z = 99998,
		layer = arg_49_0.vars.result_wnd:getChildByName("n_eff_back")
	})
	EffectManager:Play({
		pivot_x = 640,
		fn = "ui_item_rewind_f.cfx",
		pivot_y = 360,
		pivot_z = 99998,
		layer = arg_49_0.vars.result_wnd:getChildByName("n_eff_back")
	})
	EffectManager:Play({
		fn = "eff_equipreset_edge_1.cfx",
		pivot_z = -1,
		layer = var_49_10,
		pivot_x = var_49_11,
		pivot_y = var_49_12
	})
	EffectManager:Play({
		fn = "eff_equipreset_edge_1f.cfx",
		pivot_z = 99999,
		layer = var_49_10,
		pivot_x = var_49_11,
		pivot_y = var_49_12
	})
	UIAction:Add(SEQ(DELAY(var_49_20 + var_49_19), CALL(SanctuaryCraftUpgrade.playResultStatEffect, arg_49_0, var_49_4)), arg_49_0, "block")
	arg_49_0:refreshAll()
end

function SanctuaryCraftReset.refreshAll(arg_50_0)
	arg_50_0:updateEquips()
	arg_50_0:resetData()
	arg_50_0:deselectEquip()
	arg_50_0:updateUI()
end

function SanctuaryCraftReset.openResultPopup(arg_51_0, arg_51_1)
	arg_51_0.vars.result_wnd = load_dlg("equip_craft_reforging_result", true, "wnd", function()
		SanctuaryCraftReset:closeResultPopup()
	end)
	
	arg_51_0.vars.result_wnd:setName("equip_craft_reset_result")
	if_set(arg_51_0.vars.result_wnd, "txt", T("equip_reset_complete_popup_title"))
	if_set_color(arg_51_0.vars.result_wnd, "arrow_item", cc.c3b(37, 134, 233))
	if_set_visible(arg_51_0.vars.result_wnd, "n_btn", true)
	
	arg_51_0.vars.result_wnd.equip = arg_51_1
	
	SceneManager:getRunningPopupScene():addChild(arg_51_0.vars.result_wnd)
end

function SanctuaryCraftReset.closeResultPopup(arg_53_0)
	if not arg_53_0.vars or not get_cocos_refid(arg_53_0.vars.result_wnd) then
		return 
	end
	
	BackButtonManager:pop({
		id = "equip_craft_reforging_result",
		dlg = arg_53_0.vars.result_wnd
	})
	arg_53_0.vars.result_wnd:removeFromParent()
end

function SanctuaryCraftReset.openUpgradePopup(arg_54_0)
	if not arg_54_0.vars or not get_cocos_refid(arg_54_0.vars.result_wnd) then
		return 
	end
	
	local var_54_0 = arg_54_0.vars.result_wnd.equip
	
	if not var_54_0 or not var_54_0:isUpgradable() then
		return 
	end
	
	UnitEquipUpgrade:OpenPopup(var_54_0, {
		exit_callback = function()
			arg_54_0:refreshAll()
			arg_54_0:_forcedSelectItem(var_54_0)
		end
	})
end

function SanctuaryCraftReset.canLeave(arg_56_0)
	if arg_56_0.vars and get_cocos_refid(arg_56_0.vars.wnd) and get_cocos_refid(arg_56_0.vars.confirm_wnd) then
		return false
	end
	
	return true
end

function SanctuaryCraftReset.getResetScore(arg_57_0, arg_57_1)
	if not arg_57_1 then
		return 0
	end
	
	local var_57_0 = arg_57_0:getResetEquip(arg_57_1)
	
	if not var_57_0 then
		return 0
	end
	
	local var_57_1 = to_n(var_57_0.point) * to_n(GAME_CONTENT_VARIABLE.recommend_score_a or 10)
	local var_57_2 = to_n(arg_57_1.point) * to_n(GAME_CONTENT_VARIABLE.recommend_score_b or -2)
	local var_57_3 = to_n(arg_57_1.enhance) * to_n(GAME_CONTENT_VARIABLE.recommend_score_c or 5)
	
	return var_57_1 + var_57_2 + var_57_3
end
