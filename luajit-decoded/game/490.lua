SanctuaryCraftUpgradeSelect = {}
SanctuaryCraftUpgrade = {}
SanctuaryCraftUpgradeUtil = {}

local var_0_0 = 0.7
local var_0_1 = 1e-07

function MsgHandler.upgrade_equip(arg_1_0)
	SanctuaryCraftUpgrade:res_upgradeItem(arg_1_0)
end

function HANDLER.equip_craft_reforging(arg_2_0, arg_2_1)
	if string.find(arg_2_1, "btn_set") then
		SanctuaryCraftUpgradeSelect:setMode(string.sub(arg_2_1, -1, -1))
	elseif arg_2_1 == "btn_ok" or arg_2_1 == "btn_go" then
		SanctuaryCraftMain:setMode("equip_upgrade")
	end
end

function HANDLER_BEFORE.equip_craft_reforging_2(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "btn_select" then
		arg_3_0.touch_tick = systick()
	end
end

function HANDLER.equip_craft_reforging_2(arg_4_0, arg_4_1)
	if string.find(arg_4_1, "btn_equip") then
		SanctuaryCraftUpgrade:selectItemTab(tonumber(string.sub(arg_4_1, -1, -1)))
	elseif string.find(arg_4_1, "btn_set") then
		SanctuaryCraftUpgrade:selectSetTab(tonumber(string.sub(arg_4_1, -1, -1)))
	elseif arg_4_1 == "btn_select" and systick() - to_n(arg_4_0.touch_tick) < 180 then
		local var_4_0 = arg_4_0:getParent().datasource
		
		SanctuaryCraftUpgrade:selectItem(var_4_0)
	elseif arg_4_1 == "btn_produce" then
		SanctuaryCraftUpgrade:openConfirmPopup()
	end
end

function HANDLER.equip_craft_reforging_confirm(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_ok" then
		SanctuaryCraftUpgrade:req_upgradeItem()
		SanctuaryCraftUpgrade:closeConfirmPopup()
	elseif arg_5_1 == "btn_cancel" then
		SanctuaryCraftUpgrade:closeConfirmPopup()
	end
end

function HANDLER.equip_craft_reforging_result(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_bg" then
		SanctuaryCraftUpgrade:closeResultPopup()
	end
end

local var_0_2 = {
	"weapon",
	"armor",
	"neck",
	"helm",
	"boot",
	"ring"
}
local var_0_3 = {}
local var_0_4 = {
	set_alchemist = 5,
	set_golem = 2,
	set_demon = 6,
	set_banshee = 3,
	set_azimanak = 4,
	set_wyvern = 1
}
local var_0_5 = {}
local var_0_6 = {
	weapon = 1,
	armor = 2,
	boot = 5,
	ring = 6,
	helm = 4,
	neck = 3
}

function SanctuaryCraftUpgradeSelect.onEnter(arg_7_0, arg_7_1)
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg("equip_craft_reforging", true, "wnd")
	
	arg_7_1:addChild(arg_7_0.vars.wnd)
	SanctuaryCraftUpgradeUtil:initTypes()
	
	local var_7_0 = UIUtil:getPortraitAni("npc1126", {})
	
	if var_7_0 then
		arg_7_0.vars.wnd:getChildByName("n_portrait"):addChild(var_7_0)
		var_7_0:setName("@portrait")
		var_7_0:setScale(var_0_0)
	end
	
	EffectManager:Play({
		z = 99999,
		fn = "ui_town_smith_bg_effect.cfx",
		layer = arg_7_0.vars.wnd:getChildByName("bg_effect")
	})
	arg_7_0.vars.wnd:getChildByName("n_balloon"):setScale(0)
	UIUtil:playNPCSoundAndTextRandomly("reforge.enter", arg_7_0.vars.wnd, "txt_balloon", nil, "reforge.enter")
	arg_7_0:updateUI()
	
	arg_7_0.vars.mode = 1
	
	arg_7_0:setMode(1)
	arg_7_0:setUIAction()
	GrowthGuideNavigator:proc()
	TutorialGuide:procGuide("item_reforge")
end

function SanctuaryCraftUpgradeSelect.setUIAction(arg_8_0)
	local var_8_0 = arg_8_0.vars.wnd:getChildByName("LEFT")
	local var_8_1 = arg_8_0.vars.wnd:getChildByName("RIGHT")
	local var_8_2 = arg_8_0.vars.wnd:getChildByName("CENTER")
	
	var_8_0:setPositionX(-300 + VIEW_BASE_LEFT)
	var_8_1:setPositionX(300 - VIEW_BASE_LEFT)
	var_8_2:setPositionY(-700)
	
	local var_8_3 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
	local var_8_4 = DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left"
	local var_8_5 = var_8_4 and 0 or  / 2
	local var_8_6 = not var_8_4 and 0 or  / 2
	
	UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT + var_8_5, 0)), var_8_0, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0 - VIEW_BASE_LEFT - var_8_6, 0)), var_8_1, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0, 0)), var_8_2, "block")
end

function SanctuaryCraftUpgradeSelect.updateUI(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	local var_9_0 = SanctuaryCraftUpgradeUtil:getSetCount()
	
	for iter_9_0 = 1, var_9_0 do
		local var_9_1 = arg_9_0.vars.wnd:getChildByName("n_set_" .. iter_9_0)
		local var_9_2 = Account:getItemCount(var_0_5[iter_9_0])
		
		if not get_cocos_refid(var_9_1) or not var_0_5[iter_9_0] then
			break
		end
		
		UIUtil:getRewardIcon(nil, var_0_5[iter_9_0], {
			no_popup = true,
			no_tooltip = true,
			no_bg = true,
			no_grade = true,
			parent = var_9_1:getChildByName("reward_item")
		})
		if_set(arg_9_0.vars.wnd, "t_have_set_" .. iter_9_0, var_9_2)
		
		local var_9_3 = var_9_2 <= 0 and 76.5 or 255
		
		if_set_opacity(var_9_1, "mob_icon", var_9_3)
		if_set_opacity(var_9_1, "reward_item", var_9_3)
		if_set_opacity(var_9_1, "t_have_set_" .. iter_9_0, var_9_3)
		if_set_opacity(var_9_1, "t_set_" .. iter_9_0, var_9_3)
		if_set_opacity(var_9_1, "icon_set_" .. iter_9_0, var_9_3)
	end
end

function SanctuaryCraftUpgradeSelect.setMode(arg_10_0, arg_10_1)
	local var_10_0 = tonumber(arg_10_1) or arg_10_0.vars.mode or 1
	local var_10_1 = SanctuaryCraftUpgradeUtil:getSetCount()
	
	for iter_10_0 = 1, var_10_1 do
		if_set_visible(arg_10_0.vars.wnd:getChildByName("n_set_" .. iter_10_0), "selected", iter_10_0 == var_10_0)
	end
	
	arg_10_0.vars.mode = var_10_0
end

function SanctuaryCraftUpgradeSelect.getMode(arg_11_0)
	return arg_11_0.vars.mode
end

function SanctuaryCraftUpgradeSelect.enterMode(arg_12_0)
	SanctuaryCraftUpgrade:onEnter({
		layer = SanctuaryCraftMain:getParentLayer(),
		mode = arg_12_0:getMode()
	})
end

function SanctuaryCraftUpgradeSelect.onShow(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		SanctuaryCraftUpgradeSelect:onEnter(SanctuaryCraftMain:getParentLayer())
		
		return 
	end
	
	arg_13_0.vars.wnd:setVisible(true)
end

function SanctuaryCraftUpgradeSelect.onHide(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	arg_14_0.vars.wnd:setVisible(false)
end

function SanctuaryCraftUpgradeSelect.onLeave(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_15_0.vars.wnd, "block")
	
	arg_15_0.vars = nil
end

function SanctuaryCraftUpgrade.quickEnter(arg_16_0, arg_16_1, arg_16_2)
	arg_16_2 = arg_16_2 or {}
	
	if not arg_16_1 then
		return 
	end
	
	SanctuaryCraftUpgradeUtil:initTypes()
	
	local var_16_0 = SceneManager:getRunningPopupScene()
	local var_16_1 = (function(arg_17_0)
		for iter_17_0 = 1, 99 do
			local var_17_0, var_17_1 = DBN("item_equip_upgrade", iter_17_0, {
				"set_id",
				"item_equip_base"
			})
			
			if not var_17_0 then
				break
			end
			
			if arg_17_0.code == var_17_1 then
				return var_17_0
			end
		end
		
		return false
	end)(arg_16_1)
	local var_16_2 = var_0_4[var_16_1]
	local var_16_3 = var_0_6[arg_16_1.db.type]
	
	arg_16_2.layer = var_16_0
	arg_16_2.mode = var_16_2
	arg_16_2.tab = var_16_3
	arg_16_2.item = arg_16_1
	arg_16_2.quick_enter = true
	
	arg_16_0:onEnter(arg_16_2)
end

function SanctuaryCraftUpgrade.onEnter(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1 or {}
	local var_18_1 = var_18_0.layer
	local var_18_2 = var_18_0.mode
	local var_18_3 = var_18_0.tab or 1
	
	arg_18_0.vars = {}
	arg_18_0.vars.wnd = load_dlg("equip_craft_reforging_2", true, "wnd")
	arg_18_0.vars.layer = var_18_1
	
	var_18_1:addChild(arg_18_0.vars.wnd)
	
	local var_18_4 = UIUtil:getPortraitAni("npc1126", {})
	
	if var_18_4 then
		arg_18_0.vars.wnd:getChildByName("n_portrait"):addChild(var_18_4)
		var_18_4:setName("@portrait")
		var_18_4:setScale(var_0_0)
	end
	
	EffectManager:Play({
		z = 99999,
		fn = "ui_town_smith_bg_effect.cfx",
		layer = arg_18_0.vars.wnd:getChildByName("bg_effect")
	})
	arg_18_0.vars.wnd:getChildByName("n_balloon"):setScale(0)
	UIUtil:playNPCSoundAndTextRandomly("reforge.idle", arg_18_0.vars.wnd, "txt_balloon", nil, "reforge.idle")
	
	arg_18_0.vars.material_type = nil
	arg_18_0.vars.material_count = 0
	arg_18_0.vars.set_tab = var_0_3[var_18_2] or "set_wyvern"
	arg_18_0.vars.item_tab = var_0_2[var_18_3] or "weapon"
	arg_18_0.vars.quick_enter = var_18_0.quick_enter or false
	arg_18_0.vars.callback_on_leave = var_18_0.callback_on_leave
	arg_18_0.vars.upgradable_itemInfos = {}
	arg_18_0.vars.upgrade_stats = {}
	arg_18_0.vars.selectedItem = nil
	
	for iter_18_0, iter_18_1 in pairs(var_0_3) do
		arg_18_0.vars.upgradable_itemInfos[iter_18_1] = {}
	end
	
	local var_18_5 = SanctuaryMain:GetLevels("Craft")[1]
	local var_18_6 = DB("sanctuary_upgrade", "craft_0_" .. var_18_5, "value_1") or 1
	
	for iter_18_2 = 1, 9999 do
		local var_18_7, var_18_8, var_18_9, var_18_10, var_18_11, var_18_12, var_18_13, var_18_14 = DBN("item_equip_upgrade", iter_18_2, {
			"id",
			"set_id",
			"item_equip_base",
			"item_equip_result",
			"material",
			"count",
			"price",
			"option"
		})
		
		if not var_18_7 then
			break
		end
		
		local var_18_15 = math.floor(var_18_13 * var_18_6 + 0.5)
		
		table.insert(arg_18_0.vars.upgradable_itemInfos, {
			id = var_18_7,
			set_id = var_18_8,
			item_equip_base = var_18_9,
			item_equip_result = var_18_10,
			material = var_18_11,
			count = var_18_12,
			price = var_18_15,
			option = var_18_14
		})
	end
	
	for iter_18_3 = 1, 9999 do
		local var_18_16, var_18_17, var_18_18 = DBN("item_equip_upgrade_stat", iter_18_3, {
			"id",
			"option",
			"value"
		})
		
		if not var_18_16 then
			break
		end
		
		table.insert(arg_18_0.vars.upgrade_stats, {
			id = var_18_16,
			option = var_18_17,
			value = var_18_18
		})
	end
	
	local var_18_19 = getUserLanguage()
	local var_18_20 = arg_18_0.vars.wnd:getChildByName("n_item_ex")
	
	if var_18_19 == "fr" or var_18_19 == "de" or var_18_19 == "pt" or var_18_19 == "es" then
		var_18_20:setPositionX(var_18_20:getPositionX() - 60)
	elseif var_18_19 == "en" then
		var_18_20:setPositionX(var_18_20:getPositionX() - 30)
	end
	
	arg_18_0:getItemList()
	arg_18_0:initListView()
	arg_18_0:initSorter()
	arg_18_0:setCurMaterial()
	arg_18_0:updateCenterUI()
	arg_18_0:updateLeftUI()
	arg_18_0:setItemTabUI(var_18_3)
	arg_18_0:setSetTabUI(var_18_2)
	arg_18_0:setUIAction()
	
	if var_18_0.quick_enter and var_18_0.item then
		arg_18_0:_forcedSelectItem(var_18_0.item)
		TopBarNew:createFromPopup(T("system_009_title"), arg_18_0.vars.wnd, function()
			arg_18_0:onLeave()
		end)
		TopBarNew:setDisableTopRight()
	end
	
	GrowthGuideNavigator:proc()
	TutorialGuide:procGuide("item_reforge")
end

function SanctuaryCraftUpgrade._forcedSelectItem(arg_20_0, arg_20_1)
	if not arg_20_1 then
		return 
	end
	
	local var_20_0
	local var_20_1 = arg_20_0:get_curItemList()
	
	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		if iter_20_1:getUID() == arg_20_1:getUID() then
			var_20_0 = iter_20_1
		end
	end
	
	arg_20_0:selectItem(var_20_0)
end

function SanctuaryCraftUpgrade.setUIAction(arg_21_0)
	local var_21_0 = arg_21_0.vars.wnd:getChildByName("LEFT")
	local var_21_1 = arg_21_0.vars.wnd:getChildByName("RIGHT")
	local var_21_2 = arg_21_0.vars.wnd:getChildByName("CENTER")
	
	var_21_1:setPositionX(300 - VIEW_BASE_LEFT)
	var_21_2:setPositionY(-700)
	
	local var_21_3 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
	local var_21_4 = var_21_3
	local var_21_5 = DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left"
	
	var_21_3 = var_21_5 and 0 or var_21_3 / 2
	
	local var_21_6 = not var_21_5 and 0 or  / 2
	
	UIAction:Add(LOG(MOVE_TO(250, 0 - VIEW_BASE_LEFT - var_21_6, 0)), var_21_1, "block")
	UIAction:Add(LOG(MOVE_TO(250, 608, 0)), var_21_2, "block")
end

function SanctuaryCraftUpgrade.setCurMaterial(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if not arg_22_0.vars.selectedItem then
		local var_22_0 = arg_22_0:get_setTab()
		
		for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.upgradable_itemInfos) do
			if iter_22_1.set_id == var_22_0 then
				arg_22_0.vars.material_type = iter_22_1.material
			end
		end
		
		arg_22_0.vars.material_count = 0
	else
		arg_22_0.vars.material_type = arg_22_0.vars.selectedItem.material
		arg_22_0.vars.material_count = arg_22_0.vars.selectedItem.count
	end
end

function SanctuaryCraftUpgrade.updateLeftUI(arg_23_0)
	local var_23_0 = arg_23_0.vars.wnd:getChildByName("n_material")
	local var_23_1 = SanctuaryCraftUpgradeUtil:getMaterialTypeCount()
	
	for iter_23_0 = 1, var_23_1 do
		local var_23_2 = var_23_0:getChildByName("reward_item_" .. iter_23_0)
		
		if not get_cocos_refid(var_23_2) then
			break
		end
		
		local var_23_3 = Account:getItemCount(var_0_5[iter_23_0]) or 0
		local var_23_4 = UIUtil:getRewardIcon(var_23_3, var_0_5[iter_23_0], {
			no_bg = true,
			show_count = true,
			tooltip_delay = 130,
			parent = var_23_2
		})
		local var_23_5 = var_23_3 > 0
		
		if_set_opacity(var_23_4, nil, var_23_5 and 255 or 76.5)
	end
end

function SanctuaryCraftUpgrade.updateCenterUI(arg_24_0)
	local var_24_0 = arg_24_0.vars.selectedItem
	
	if_set_visible(arg_24_0.vars.wnd, "n_info_nodata", not var_24_0)
	if_set_visible(arg_24_0.vars.wnd, "n_stat", var_24_0)
	
	local var_24_1 = arg_24_0.vars.wnd:getChildByName("n_info_nodata")
	local var_24_2 = arg_24_0.vars.wnd:getChildByName("n_stat")
	local var_24_3, var_24_4 = DB("item_material", arg_24_0.vars.material_type, {
		"name",
		"desc_category"
	})
	
	UIUtil:getRewardIcon(nil, arg_24_0.vars.material_type, {
		no_bg = true,
		tooltip_delay = 130,
		parent = var_24_1:getChildByName("reward_item")
	})
	
	if var_24_0 then
		arg_24_0:updateEquipInfoUI(var_24_0)
		if_set(var_24_2, "cost", comma_value(var_24_0.price))
		UIUtil:getRewardIcon(var_24_0.count, arg_24_0.vars.material_type, {
			tooltip_delay = 130,
			parent = var_24_2:getChildByName("reward_item_needs")
		})
		if_set(var_24_2, "t_mater_disc", T(var_24_3))
		
		local var_24_5 = Account:getItemCount(arg_24_0.vars.material_type) >= var_24_0.count and Account:getCurrency("to_gold") >= arg_24_0.vars.selectedItem.price
		local var_24_6 = Account:getItemCount(arg_24_0.vars.material_type) >= var_24_0.count
		
		if_set_visible(var_24_2, "n_lack_item", not var_24_6)
		if_set_opacity(var_24_2, "reward_item_needs", var_24_6 and 255 or 76.5)
		if_set_opacity(var_24_2, "btn_produce", var_24_5 and 255 or 76.5)
		
		local var_24_7 = getChildByPath(arg_24_0.vars.wnd:getChildByName("n_equip_slot"), "txt_name")
		
		if get_cocos_refid(var_24_7) then
			if_set(var_24_7, nil, T(var_24_0.db.name))
		end
	else
		local var_24_8 = arg_24_0.vars.wnd:getChildByName("n_target")
		
		if get_cocos_refid(var_24_8) then
			var_24_8:removeAllChildren()
		end
		
		local var_24_9 = {
			set_alchemist = "ui_reforge_material_alchemy",
			set_golem = "ui_reforge_material_golem",
			set_demon = "ui_reforge_material_demon",
			set_banshee = "ui_reforge_material_bansee",
			set_azimanak = "ui_reforge_material_azimanak",
			set_wyvern = "ui_reforge_material_wyvern"
		}
		
		if_set(arg_24_0.vars.wnd, "label_ma", T(var_24_9[arg_24_0:get_setTab()]))
		UIUserData:call(arg_24_0.vars.wnd:getChildByName("label_ma"), "RICH_LABEL(true)")
		if_set(arg_24_0.vars.wnd:getChildByName("n_info_nodata"), "txt_grade", T(var_24_4))
		
		local var_24_10 = getChildByPath(arg_24_0.vars.wnd:getChildByName("n_item_ex"), "txt_name")
		
		if get_cocos_refid(var_24_10) then
			if_set(var_24_10, nil, T(var_24_3))
		end
		
		local var_24_11 = getChildByPath(arg_24_0.vars.wnd:getChildByName("n_equip_slot"), "txt_name")
		
		if get_cocos_refid(var_24_11) then
			if_set_visible(var_24_11, nil, false)
		end
	end
end

function SanctuaryCraftUpgrade.updateEquipInfoUI(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1 or arg_25_0.vars.selectedItem
	local var_25_1 = arg_25_0.vars.wnd:getChildByName("n_target")
	local var_25_2 = UIUtil:getRewardIcon("equip", var_25_0.code, {
		tooltip_delay = 130,
		parent = var_25_1,
		equip = var_25_0
	})
	
	arg_25_0:setCurItemInfo(var_25_0)
	arg_25_0:setUpdateItemInfo(var_25_0)
end

function SanctuaryCraftUpgrade.setCurItemInfo(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1 or arg_26_0.vars.selectedItem
	local var_26_1 = arg_26_0.vars.wnd:getChildByName("n_stat")
	
	if_set(var_26_1, "t_level", var_26_0.db.item_level)
	
	local var_26_2, var_26_3 = var_26_0:getMainStat()
	
	SpriteCache:resetSprite(var_26_1:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_26_3, "_rate", "") .. ".png")
	if_set(var_26_1, "txt_main_stat", to_var_str(var_26_2, var_26_3))
	if_set(var_26_1, "txt_main_name", getStatName(var_26_3))
	
	local var_26_4 = {}
	local var_26_5 = {}
	local var_26_6
	local var_26_7 = 0
	
	for iter_26_0 = 2, 99 do
		if var_26_0.op[iter_26_0] then
			local var_26_8 = var_26_0.op[iter_26_0][1]
			local var_26_9 = var_26_0.op[iter_26_0][2]
			local var_26_10 = var_26_0.op[iter_26_0][3]
			
			if not var_26_5[var_26_8] then
				var_26_7 = var_26_7 + 1
				var_26_5[var_26_8] = var_26_7
			end
			
			if var_26_10 == "c" then
				var_26_6 = var_26_8
			end
			
			if type(var_26_9) == "table" then
				var_26_4[var_26_8] = var_26_9
			else
				var_26_4[var_26_8] = (var_26_4[var_26_8] or 0) + var_26_9
			end
		else
			break
		end
	end
	
	for iter_26_1, iter_26_2 in pairs(var_26_4) do
		local var_26_11 = var_26_5[iter_26_1]
		local var_26_12 = var_26_1:findChildByName("txt_sub_name" .. var_26_11)
		
		if_set(var_26_12, nil, getStatName(iter_26_1))
		
		if type(iter_26_2) == "table" then
			if_set(var_26_1, "txt_sub_stat" .. var_26_11, to_var_str(iter_26_2[1], iter_26_1, nil, true) .. "-" .. to_var_str(iter_26_2[2], iter_26_1))
		else
			if_set(var_26_1, "txt_sub_stat" .. var_26_11, to_var_str(iter_26_2, iter_26_1))
		end
		
		if_set_visible(var_26_12, "icon_option_change", var_26_6 == iter_26_1)
	end
	
	for iter_26_3 = 0, 3 do
		if_set_visible(var_26_1, tostring(iter_26_3), iter_26_3 < var_26_7)
	end
end

function SanctuaryCraftUpgrade.getUpgradeStat(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_1 or not arg_27_2 then
		return 0
	end
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.upgrade_stats) do
		if string.find(iter_27_1.id, arg_27_1) and iter_27_1.option == arg_27_2 then
			return iter_27_1.value
		end
	end
	
	return 0
end

function SanctuaryCraftUpgrade.is_percentage_stat(arg_28_0, arg_28_1)
	return UnitEquipUtil:is_percentage_stat(arg_28_1)
end

function SanctuaryCraftUpgrade.get_normalize_value(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	return UnitEquipUtil:get_normalize_value(arg_29_1, arg_29_2, arg_29_3)
end

function SanctuaryCraftUpgrade.get_stat_data(arg_30_0, arg_30_1, arg_30_2)
	for iter_30_0 = 1, 20 do
		local var_30_0, var_30_1, var_30_2 = DB("equip_stat", arg_30_1 .. "_" .. iter_30_0, {
			"stat_type",
			"val_min",
			"val_max"
		})
		
		if not var_30_0 then
			break
		end
		
		if arg_30_2 == var_30_0 then
			return {
				stat_type = var_30_0,
				val_min = var_30_1,
				val_max = var_30_2
			}
		end
	end
end

function SanctuaryCraftUpgrade.get_stat_value(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = 1
	local var_31_1, var_31_2, var_31_3 = DB("item_equip_stat_revision", arg_31_2.stat_type, {
		"revise_min",
		"revise_max",
		"t" .. arg_31_1
	})
	local var_31_4 = arg_31_2.val_min
	local var_31_5 = arg_31_2.val_max
	
	if var_31_1 then
		var_31_1 = var_31_1 or 1
		var_31_2 = var_31_2 or 1
		var_31_3 = var_31_3 or 1
		var_31_4 = var_31_4 * var_31_1
		var_31_5 = var_31_5 * var_31_2
	end
	
	return var_31_4, var_31_5, var_31_3
end

function SanctuaryCraftUpgrade.setUpdateItemInfo(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_1 or arg_32_0.vars.selectedItem
	local var_32_1, var_32_2, var_32_3 = DB("equip_item", var_32_0.code, {
		"tier",
		"main_stat",
		"sub_stat"
	})
	local var_32_4, var_32_5, var_32_6, var_32_7 = DB("equip_item", var_32_0.item_equip_result, {
		"tier",
		"item_level",
		"main_stat",
		"sub_stat"
	})
	
	if not var_32_2 or not var_32_6 then
		return 
	end
	
	local var_32_8 = {}
	local var_32_9 = {}
	local var_32_10 = var_32_1
	local var_32_11 = var_32_2
	local var_32_12 = var_32_3
	local var_32_13 = var_32_4
	local var_32_14 = var_32_6
	local var_32_15 = var_32_7
	local var_32_16
	
	for iter_32_0 = 1, 99 do
		local var_32_17 = var_32_0.op[iter_32_0]
		
		if var_32_17 and var_32_17[3] == "c" then
			var_32_16 = var_32_17[1]
			
			break
		end
	end
	
	for iter_32_1 = 1, 99 do
		if iter_32_1 == 1 and var_32_0.op[iter_32_1] then
			local var_32_18
			local var_32_19
			
			for iter_32_2 = 1, 99 do
				local var_32_20, var_32_21 = DB("equip_stat", var_32_6 .. "_" .. iter_32_2, {
					"stat_type",
					"val_max"
				})
				
				if var_32_20 == var_32_0.op[iter_32_1][1] then
					var_32_18 = var_32_20
					var_32_19 = var_32_21
				end
			end
			
			if not var_32_18 or not var_32_19 then
				Log.e("error wrongMainStat")
				
				return 
			end
			
			local var_32_22, var_32_23, var_32_24 = DB("item_equip_stat_revision", var_32_18, {
				"revise_min",
				"revise_max",
				"t" .. var_32_13
			})
			
			if arg_32_0:is_percentage_stat(var_32_18) then
				var_32_19 = math.round(var_32_19 * var_32_23 * var_32_24 * 100) / 100 * var_32_0.enhance_rate
			else
				var_32_19 = math.floor(var_32_19 * var_32_23 * var_32_24) * var_32_0.enhance_rate
			end
			
			table.insert(var_32_8, {
				var_32_18,
				var_32_19
			})
		elseif var_32_0.op[iter_32_1] and var_32_0.op[iter_32_1][3] == nil then
			local var_32_25 = var_32_0.op[iter_32_1][1]
			local var_32_26 = var_32_0.op[iter_32_1][2]
			
			if var_32_0.op[iter_32_1][1] == var_32_16 then
				table.insert(var_32_8, {
					var_32_25,
					var_32_26
				})
			else
				local var_32_27 = DB("itemgrade", tostring(var_32_0.grade), {
					"power"
				}) or 1
				local var_32_28 = 1
				
				if UNIT.is_percentage_stat(var_32_25) then
					var_32_28 = 100
				end
				
				local var_32_29 = arg_32_0:get_stat_data(var_32_12, var_32_25)
				local var_32_30 = arg_32_0:get_stat_data(var_32_15, var_32_25)
				local var_32_31, var_32_32, var_32_33 = arg_32_0:get_stat_value(var_32_10, var_32_29)
				local var_32_34, var_32_35, var_32_36 = arg_32_0:get_stat_value(var_32_13, var_32_30)
				local var_32_37 = var_32_26 / var_32_27 / var_32_33
				local var_32_38 = math.max(0, var_32_37 - var_32_31) / (var_32_32 - var_32_31)
				local var_32_39 = round((var_32_35 - var_32_34) * var_32_28)
				local var_32_40 = (var_32_34 + round(var_32_39 * var_32_38, 2) / var_32_28) * var_32_36 * var_32_27
				local var_32_41 = math.max(var_32_26, arg_32_0:get_normalize_value(var_32_25, var_32_40))
				
				table.insert(var_32_8, {
					var_32_25,
					var_32_41
				})
			end
			
			if not var_32_9[var_32_25] then
				var_32_9[var_32_25] = 0
			end
			
			var_32_9[var_32_25] = var_32_9[var_32_25] + 1
		elseif var_32_0.op[iter_32_1] and var_32_0.op[iter_32_1][3] ~= nil then
			local var_32_42 = var_32_0.op[iter_32_1][1]
			local var_32_43 = var_32_0.op[iter_32_1][2]
			local var_32_44 = var_32_0.op[iter_32_1][3]
			
			table.insert(var_32_8, {
				var_32_42,
				var_32_43,
				var_32_44
			})
		end
	end
	
	for iter_32_3, iter_32_4 in pairs(var_32_9) do
		local var_32_45 = arg_32_0:get_normalize_value(iter_32_3, arg_32_0:getUpgradeStat(var_32_0.option, iter_32_3) * iter_32_4 + var_0_1, iter_32_3 == "speed")
		
		table.insert(var_32_8, {
			iter_32_3,
			var_32_45
		})
	end
	
	local var_32_46 = arg_32_0.vars.wnd:getChildByName("n_stat")
	local var_32_47 = var_32_8[1][2]
	local var_32_48 = var_32_8[1][1]
	
	if_set(var_32_46, "t_main_stat_after", to_var_str(var_32_47, var_32_48))
	if_set(var_32_46, "t_level_after", var_32_5)
	
	local var_32_49 = {}
	local var_32_50 = {}
	local var_32_51 = 0
	
	for iter_32_5 = 2, 99 do
		if var_32_8[iter_32_5] then
			local var_32_52 = var_32_8[iter_32_5][1]
			local var_32_53 = var_32_8[iter_32_5][2]
			
			if not var_32_50[var_32_52] then
				var_32_51 = var_32_51 + 1
				var_32_50[var_32_52] = var_32_51
			end
			
			if type(var_32_53) == "table" then
				var_32_49[var_32_52] = var_32_53
			else
				var_32_49[var_32_52] = (var_32_49[var_32_52] or 0) + var_32_53
			end
		else
			break
		end
	end
	
	for iter_32_6, iter_32_7 in pairs(var_32_49) do
		local var_32_54 = var_32_50[iter_32_6]
		
		if_set(var_32_46, "t_sub_stat" .. var_32_54 .. "_after", to_var_str(iter_32_7, iter_32_6))
	end
	
	arg_32_0.vars.result_item = EQUIP:createByInfo({
		code = arg_32_0.vars.selectedItem.item_equip_result,
		op = var_32_8,
		grade = arg_32_0.vars.selectedItem.grade,
		enhance = arg_32_0.vars.selectedItem:getEnhance(),
		set_fx = arg_32_0.vars.selectedItem.set_fx
	})
	arg_32_0.vars.result_item.enhance = arg_32_0.vars.selectedItem:getEnhance()
end

local function var_0_7(arg_33_0, arg_33_1, arg_33_2)
	if_set_visible(arg_33_1, "n_select", arg_33_2.selected)
	if_set_visible(arg_33_1, "icon_type", arg_33_2.isEquip ~= nil)
	if_set_visible(arg_33_1, "equip", arg_33_2 and arg_33_2.parent)
	if_set_visible(arg_33_1, "item_slot", true)
	if_set_visible(arg_33_1, "arti_slot", false)
	
	local var_33_0 = arg_33_1:getChildByName("bg_item")
	local var_33_1 = arg_33_1:getChildByName("txt_value")
	local var_33_2 = arg_33_1:getChildByName("n_txt_value")
	local var_33_3 = arg_33_1:getChildByName("n_img_value")
	
	var_33_3:setVisible(true)
	var_33_2:setVisible(false)
	
	local var_33_4 = UIUtil:getRewardIcon("equip", arg_33_2.code, {
		tooltip_delay = 130,
		parent = var_33_0,
		equip = arg_33_2
	})
	local var_33_5, var_33_6, var_33_7, var_33_8 = arg_33_2:getMainStat()
	
	if UNIT.is_percentage_stat(var_33_6) then
		var_33_5 = to_var_str(var_33_5, var_33_6)
	else
		var_33_5 = comma_value(math.floor(var_33_5))
	end
	
	local var_33_9 = arg_33_1:getChildByName("icon_type")
	
	var_33_9:setVisible(true)
	var_33_3:setVisible(true)
	SpriteCache:resetSprite(var_33_9, "img/cm_icon_stat_" .. string.gsub(var_33_6, "_rate", "") .. ".png")
	UIUtil:resetImageNumber(var_33_3, var_33_5)
	
	if not arg_33_2.upgradable then
		var_33_0:setOpacity(76.5)
		var_33_1:setOpacity(76.5)
		var_33_2:setOpacity(76.5)
		var_33_3:setOpacity(76.5)
		var_33_9:setOpacity(76.5)
	end
	
	if arg_33_2.parent then
		local var_33_10 = Account:getUnit(arg_33_2.parent)
		
		if var_33_10 ~= nil then
			UIUtil:getRewardIcon("c", var_33_10:getDisplayCode(), {
				no_popup = true,
				no_grade = true,
				parent = arg_33_1:getChildByName("n_mob_icon")
			})
			if_set_visible(arg_33_1, "n_mob_icon", true)
			if_set_visible(arg_33_1, "equip", true)
		end
	else
		if_set_visible(arg_33_1, "n_mob_icon", false)
		if_set_visible(arg_33_1, "equip", false)
	end
	
	arg_33_1.datasource = arg_33_2
end

function SanctuaryCraftUpgrade.set_itemTab(arg_34_0, arg_34_1)
	arg_34_0.vars.item_tab = arg_34_1 or "weapon"
end

function SanctuaryCraftUpgrade.set_setTab(arg_35_0, arg_35_1)
	arg_35_0.vars.set_tab = arg_35_1 or "set_wyvern"
end

function SanctuaryCraftUpgrade.get_itemTab(arg_36_0)
	return arg_36_0.vars.item_tab or "weapon"
end

function SanctuaryCraftUpgrade.get_setTab(arg_37_0)
	return arg_37_0.vars.set_tab or "set_wyvern"
end

function SanctuaryCraftUpgrade.get_curItemList(arg_38_0)
	if not arg_38_0.vars.items[arg_38_0:get_setTab()] or not arg_38_0.vars.items[arg_38_0:get_setTab()][arg_38_0:get_itemTab()] then
		return {}
	end
	
	return arg_38_0.vars.items[arg_38_0:get_setTab()][arg_38_0:get_itemTab()]
end

function SanctuaryCraftUpgrade.set_curItemList(arg_39_0, arg_39_1)
	if not arg_39_0.vars.items[arg_39_0:get_setTab()] or not arg_39_0.vars.items[arg_39_0:get_setTab()][arg_39_0:get_itemTab()] then
		return 
	end
	
	arg_39_0.vars.items[arg_39_0:get_setTab()][arg_39_0:get_itemTab()] = arg_39_1 or {}
end

function SanctuaryCraftUpgrade.initListView(arg_40_0)
	arg_40_0.vars.listview = arg_40_0.vars.wnd:getChildByName("ListView_578_519")
	arg_40_0.vars.listview = ItemListView:bindControl(arg_40_0.vars.listview)
	
	local var_40_0 = {
		onUpdate = var_0_7
	}
	local var_40_1 = load_control("wnd/inventory_card.csb")
	
	arg_40_0.vars.listview:setRenderer(var_40_1, var_40_0)
	arg_40_0.vars.listview:setItems(arg_40_0:get_curItemList())
end

function SanctuaryCraftUpgrade.refreshItems(arg_41_0)
	SorterExtentionUtil:set_itemSetCounts(arg_41_0.vars.sorter.sorter_extention:get_setBox(), arg_41_0:get_curItemList())
	arg_41_0.vars.sorter:setItems(arg_41_0:getOriginal_list())
	arg_41_0:set_curItemList(arg_41_0.vars.sorter:sort())
	arg_41_0.vars.listview:setItems(arg_41_0:get_curItemList())
	if_set_visible(arg_41_0.vars.wnd, "no_data", table.empty(arg_41_0:get_curItemList()))
end

function SanctuaryCraftUpgrade.resetListView(arg_42_0)
	arg_42_0.vars.listview:setItems(arg_42_0:get_curItemList())
end

function SanctuaryCraftUpgrade.initOriginal_list(arg_43_0)
	arg_43_0.vars.original_items = {}
	
	for iter_43_0, iter_43_1 in pairs(var_0_3) do
		arg_43_0.vars.original_items[iter_43_1] = {}
		
		for iter_43_2, iter_43_3 in pairs(var_0_2) do
			arg_43_0.vars.original_items[iter_43_1][iter_43_3] = arg_43_0.vars.items[iter_43_1][iter_43_3]
		end
	end
end

function SanctuaryCraftUpgrade.getOriginal_list(arg_44_0)
	if not arg_44_0.vars.original_items[arg_44_0:get_setTab()] or not arg_44_0.vars.original_items[arg_44_0:get_setTab()][arg_44_0:get_itemTab()] then
		return {}
	end
	
	return arg_44_0.vars.original_items[arg_44_0:get_setTab()][arg_44_0:get_itemTab()]
end

function SanctuaryCraftUpgrade.initSorter(arg_45_0)
	if not arg_45_0.vars.sorter then
		arg_45_0.vars.sorter = Sorter:create(arg_45_0.vars.wnd:getChildByName("btn_sorting"), {
			movePosition = true,
			useExtention = true
		})
		
		local var_45_0 = {
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
		local var_45_1 = Account:getConfigData("inven_equip_sort_index") or 3
		
		arg_45_0.vars.sorter:setSorter({
			default_sort_index = var_45_1,
			menus = var_45_0,
			close_callback = function()
				SanctuaryCraftUpgrade:refreshItems()
			end,
			callback_sort = function(arg_47_0, arg_47_1)
				SanctuaryCraftUpgrade:resetListView()
				SAVE:setTempConfigData("inven_equip_sort_index", arg_47_1)
			end
		})
	end
	
	arg_45_0:set_curItemList(arg_45_0:getOriginal_list())
	SorterExtentionUtil:set_itemSetCounts(arg_45_0.vars.sorter.sorter_extention:get_setBox(), arg_45_0:get_curItemList())
	arg_45_0.vars.sorter:setItems(arg_45_0:get_curItemList())
	arg_45_0:set_curItemList(arg_45_0.vars.sorter:sort())
	arg_45_0.vars.sorter:setVisible(true)
end

function SanctuaryCraftUpgrade.canUpgradableItem(arg_48_0, arg_48_1)
	if not arg_48_1 or not arg_48_1:isMaxEnhance() then
		return false
	end
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.upgradable_itemInfos) do
		if iter_48_1.item_equip_base == arg_48_1.code then
			return true
		end
	end
	
	return false
end

function SanctuaryCraftUpgrade.setUpgradeInfo(arg_49_0, arg_49_1)
	for iter_49_0, iter_49_1 in pairs(arg_49_0.vars.upgradable_itemInfos) do
		if iter_49_1.item_equip_base == arg_49_1.code then
			arg_49_1.set_id = iter_49_1.set_id
			arg_49_1.material = iter_49_1.material
			arg_49_1.count = iter_49_1.count
			arg_49_1.price = iter_49_1.price
			arg_49_1.item_equip_result = iter_49_1.item_equip_result
			arg_49_1.upgradable = iter_49_1.count <= Account:getItemCount(arg_49_1.material)
			arg_49_1.option = iter_49_1.option
			
			return 
		end
	end
end

function SanctuaryCraftUpgrade.getItemList(arg_50_0)
	arg_50_0.vars.items = {}
	
	for iter_50_0, iter_50_1 in pairs(var_0_3) do
		arg_50_0.vars.items[iter_50_1] = {}
		
		for iter_50_2, iter_50_3 in pairs(var_0_2) do
			arg_50_0.vars.items[iter_50_1][iter_50_3] = {}
		end
	end
	
	local var_50_0 = Account.equips
	
	for iter_50_4, iter_50_5 in pairs(var_50_0) do
		if arg_50_0:canUpgradableItem(iter_50_5) then
			local var_50_1 = iter_50_5:clone()
			
			arg_50_0:setUpgradeInfo(var_50_1)
			table.insert(arg_50_0.vars.items[var_50_1.set_id][var_50_1.db.type], var_50_1)
		end
	end
	
	arg_50_0:initOriginal_list()
end

function SanctuaryCraftUpgrade.selectSetTab(arg_51_0, arg_51_1)
	if not arg_51_1 then
		return 
	end
	
	if var_0_3[arg_51_1] == arg_51_0:get_setTab() then
		return 
	end
	
	arg_51_0:set_setTab(var_0_3[arg_51_1])
	arg_51_0:refreshItems()
	arg_51_0:setCurMaterial()
	arg_51_0:updateCenterUI()
	arg_51_0:setSetTabUI(arg_51_1)
end

function SanctuaryCraftUpgrade.setSetTabUI(arg_52_0, arg_52_1)
	if not arg_52_1 then
		return 
	end
	
	local var_52_0 = SanctuaryCraftUpgradeUtil:getSetCount()
	
	for iter_52_0 = 1, var_52_0 do
		local var_52_1 = arg_52_0.vars.wnd:getChildByName("n_set_" .. iter_52_0)
		
		if get_cocos_refid(var_52_1) then
			if_set_visible(var_52_1, "selected", iter_52_0 == arg_52_1)
		end
	end
	
	if arg_52_0:get_curItemList() then
		if_set_visible(arg_52_0.vars.wnd, "no_data", table.empty(arg_52_0:get_curItemList()))
	end
end

function SanctuaryCraftUpgrade.selectItemTab(arg_53_0, arg_53_1)
	if not arg_53_1 then
		return 
	end
	
	if var_0_2[arg_53_1] == arg_53_0:get_itemTab() then
		return 
	end
	
	arg_53_0:set_itemTab(var_0_2[arg_53_1])
	arg_53_0:refreshItems()
	arg_53_0:setItemTabUI(arg_53_1)
end

function SanctuaryCraftUpgrade.setItemTabUI(arg_54_0, arg_54_1)
	if not arg_54_1 then
		return 
	end
	
	for iter_54_0 = 1, 6 do
		local var_54_0 = arg_54_0.vars.wnd:getChildByName("btn_equip_tab" .. iter_54_0)
		
		if get_cocos_refid(var_54_0) then
			if_set_visible(var_54_0, "bg_tab", iter_54_0 == arg_54_1)
		end
	end
	
	if arg_54_0:get_curItemList() then
		if_set_visible(arg_54_0.vars.wnd, "no_data", table.empty(arg_54_0:get_curItemList()))
	end
end

function SanctuaryCraftUpgrade.selectItem(arg_55_0, arg_55_1)
	if not arg_55_0.vars or not arg_55_1 then
		return 
	end
	
	if arg_55_0.vars.selectedItem then
		local var_55_0 = arg_55_0.vars.listview:getControl(arg_55_0.vars.selectedItem)
		
		if arg_55_0.vars.selectedItem == arg_55_1 then
			if var_55_0 then
				if_set_visible(var_55_0, "n_select", false)
				
				arg_55_0.vars.selectedItem.selected = false
				arg_55_0.vars.selectedItem = nil
			end
			
			arg_55_0:setCurMaterial()
			arg_55_0:updateCenterUI()
			
			return 
		else
			if var_55_0 then
				if_set_visible(var_55_0, "n_select", false)
			end
			
			arg_55_0.vars.selectedItem.selected = false
		end
	end
	
	local var_55_1 = arg_55_0.vars.listview:getControl(arg_55_1)
	
	if var_55_1 then
		if_set_visible(var_55_1, "n_select", true)
	end
	
	arg_55_1.selected = true
	arg_55_0.vars.selectedItem = arg_55_1
	
	arg_55_0:setCurMaterial()
	arg_55_0:updateCenterUI()
end

function SanctuaryCraftUpgrade.req_upgradeItem(arg_56_0)
	if not arg_56_0.vars or not arg_56_0.vars.selectedItem then
		return 
	end
	
	if Account:getItemCount(arg_56_0.vars.material_type) < arg_56_0.vars.selectedItem.count then
		balloon_message_with_sound("need_material")
		
		return 
	end
	
	if Account:getCurrency("to_gold") < arg_56_0.vars.selectedItem.price then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	query("upgrade_equip", {
		target = arg_56_0.vars.selectedItem:getUID()
	})
end

function SanctuaryCraftUpgrade.res_upgradeItem(arg_57_0, arg_57_1)
	for iter_57_0, iter_57_1 in pairs(arg_57_1.items) do
		Account:setItemCount(iter_57_0, iter_57_1)
	end
	
	Account:updateCurrencies(arg_57_1)
	TopBarNew:topbarUpdate(true)
	
	local var_57_0 = arg_57_0.vars.selectedItem:clone()
	local var_57_1 = Account:addEquip(arg_57_1.equip)
	
	if arg_57_0.vars.selectedItem.parent then
		local var_57_2 = Account:getUnit(arg_57_0.vars.selectedItem.parent)
		
		if var_57_2 then
			var_57_2:removeEquip(arg_57_0.vars.selectedItem)
			var_57_2:addEquip(var_57_1)
		end
	end
	
	ConditionContentsManager:dispatch("equip.refine", {
		equip = var_57_1,
		prev_sub_stats = table.clone(var_57_0.opts or {}),
		sub_stats = table.clone(var_57_1.opts or {})
	})
	Account:removeEquip(arg_57_0.vars.selectedItem:getUID())
	
	if not var_57_1 then
		return 
	end
	
	arg_57_0:openResultPopup(arg_57_1)
	
	local var_57_3 = load_dlg("item_detail_sub", true, "wnd")
	local var_57_4 = load_dlg("item_detail_sub", true, "wnd")
	
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = var_57_3,
		equip = var_57_0
	})
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = var_57_4,
		equip = var_57_1
	})
	
	local var_57_5 = arg_57_0.vars.resultPopup:getChildByName("arrow_item")
	local var_57_6 = arg_57_0.vars.resultPopup:getChildByName("title_bg")
	local var_57_7 = arg_57_0.vars.resultPopup:getChildByName("txt")
	local var_57_8 = arg_57_0.vars.resultPopup:getChildByName("n_before"):getChildByName("n_item_tooltip")
	local var_57_9 = arg_57_0.vars.resultPopup:getChildByName("n_after"):getChildByName("n_item_tooltip")
	
	ItemTooltip:updateItemFrame(var_57_8, var_57_0, nil, "cm_tooltipbox")
	ItemTooltip:updateItemFrame(var_57_9, var_57_1, nil, "cm_tooltipbox")
	var_57_8:addChild(var_57_3)
	var_57_9:addChild(var_57_4)
	var_57_3:setPosition(0, 285)
	var_57_4:setPosition(0, 285)
	var_57_3:setAnchorPoint(0.5, 0.5)
	var_57_4:setAnchorPoint(0.5, 0.5)
	
	local var_57_10 = var_57_3:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_57_10) then
		local var_57_11 = var_57_10:getStringNumLines()
		
		if var_57_11 and var_57_11 >= 4 then
			local var_57_12 = var_57_8:getChildByName("cm_tooltipbox")
			local var_57_13 = var_57_9:getChildByName("cm_tooltipbox")
			
			if get_cocos_refid(var_57_12) and get_cocos_refid(var_57_13) then
				local var_57_14 = var_57_12:getContentSize()
				
				var_57_12:setContentSize({
					width = var_57_14.width,
					height = var_57_14.height + 20
				})
				var_57_13:setContentSize({
					width = var_57_14.width,
					height = var_57_14.height + 20
				})
			end
		end
	end
	
	var_57_8:setOpacity(0)
	var_57_9:setOpacity(0)
	var_57_5:setOpacity(0)
	var_57_6:setOpacity(0)
	var_57_7:setOpacity(0)
	
	local var_57_15 = 2000
	local var_57_16 = 300
	local var_57_17 = var_57_15 + 200
	local var_57_18 = 200
	
	UIAction:Add(SEQ(DELAY(var_57_17), FADE_IN(var_57_18)), var_57_8, "block")
	UIAction:Add(SEQ(DELAY(var_57_17), FADE_IN(var_57_18)), var_57_9, "block")
	UIAction:Add(SEQ(DELAY(var_57_17), FADE_IN(var_57_18)), var_57_5, "block")
	UIAction:Add(SEQ(DELAY(var_57_17), FADE_IN(var_57_18)), var_57_6, "block")
	UIAction:Add(SEQ(DELAY(var_57_17), FADE_IN(var_57_18)), var_57_7, "block")
	EffectManager:Play({
		pivot_x = 640,
		fn = "ui_item_refine_b.cfx",
		pivot_y = 360,
		pivot_z = 99998,
		layer = SanctuaryCraftUpgrade.vars.resultPopup:getChildByName("n_eff_back")
	})
	EffectManager:Play({
		pivot_x = 640,
		fn = "ui_item_refine_f.cfx",
		pivot_y = 360,
		pivot_z = 99998,
		layer = SanctuaryCraftUpgrade.vars.resultPopup:getChildByName("n_eff_back")
	})
	UIAction:Add(SEQ(DELAY(var_57_17 + var_57_16), CALL(arg_57_0.playResultStatEffect, arg_57_0, var_57_4)), arg_57_0, "block")
	arg_57_0:refreshAll()
	SanctuaryCraftUpgradeSelect:updateUI()
end

function SanctuaryCraftUpgrade.playResultStatEffect(arg_58_0, arg_58_1)
	local var_58_0 = CACHE:getEffect("itemupgrade_statup")
	local var_58_1 = arg_58_1:getChildByName("txt_main_stat")
	local var_58_2, var_58_3 = var_58_1:getPosition()
	
	var_58_0:setScaleY(2)
	var_58_0:setPosition(var_58_2 - 20, var_58_3)
	var_58_0:setLocalZOrder(2000)
	var_58_1:getParent():addChild(var_58_0)
	UIAction:AddSync(SEQ(DMOTION("animation"), REMOVE()), var_58_0)
	
	for iter_58_0 = 1, 4 do
		local var_58_4 = arg_58_1:getChildByName("txt_sub_stat" .. iter_58_0)
		
		if var_58_4:isVisible() then
			local var_58_5, var_58_6 = var_58_4:getPosition()
			local var_58_7 = CACHE:getEffect("itemupgrade_statup")
			
			var_58_7:setScaleX(0.5)
			var_58_7:setPosition(var_58_5 - 10, var_58_6)
			var_58_7:setLocalZOrder(2000)
			var_58_4:getParent():addChild(var_58_7)
			UIAction:AddSync(SEQ(DMOTION("animation"), REMOVE()), var_58_7)
		end
	end
end

function SanctuaryCraftUpgrade.openResultPopup(arg_59_0, arg_59_1)
	arg_59_0.vars.resultPopup = load_dlg("equip_craft_reforging_result", true, "wnd", function()
		SanctuaryCraftUpgrade:closeResultPopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_59_0.vars.resultPopup)
end

function SanctuaryCraftUpgrade.closeResultPopup(arg_61_0)
	if not arg_61_0.vars or not get_cocos_refid(arg_61_0.vars.resultPopup) then
		return 
	end
	
	BackButtonManager:pop({
		id = "equip_craft_reforging_result",
		dlg = arg_61_0.vars.resultPopup
	})
	arg_61_0.vars.resultPopup:removeFromParent()
end

function SanctuaryCraftUpgrade.openConfirmPopup(arg_62_0)
	if not arg_62_0.vars or not get_cocos_refid(arg_62_0.vars.wnd) then
		return 
	end
	
	if Account:getCurrency("to_gold") < arg_62_0.vars.selectedItem.price then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	if Account:getItemCount(arg_62_0.vars.material_type) < arg_62_0.vars.selectedItem.count then
		balloon_message_with_sound("need_material")
		
		return 
	end
	
	arg_62_0.vars.confirm_wnd = load_dlg("equip_craft_reforging_confirm", true, "wnd", function()
		SanctuaryCraftUpgrade:closeConfirmPopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_62_0.vars.confirm_wnd)
	
	local var_62_0, var_62_1 = DB("item_material", arg_62_0.vars.material_type, {
		"name",
		"desc_category"
	})
	
	if_set(arg_62_0.vars.confirm_wnd, "t_disc", T("ui_reforge_popup_desc", {
		name = T(var_62_0),
		count = arg_62_0.vars.selectedItem.count
	}))
	ItemTooltip:updateItemInformation({
		wnd = arg_62_0.vars.confirm_wnd:getChildByName("n_before"),
		equip = arg_62_0.vars.selectedItem
	})
	ItemTooltip:updateItemInformation({
		wnd = arg_62_0.vars.confirm_wnd:getChildByName("n_after"),
		equip = arg_62_0.vars.result_item
	})
	if_set(arg_62_0.vars.confirm_wnd, "label_0", comma_value(arg_62_0.vars.selectedItem.price))
	if_set_sprite(arg_62_0.vars.confirm_wnd, "Sprite_41", "item/token_gold.png")
	GrowthGuideNavigator:proc()
end

function SanctuaryCraftUpgrade.closeConfirmPopup(arg_64_0)
	if not arg_64_0.vars or not get_cocos_refid(arg_64_0.vars.wnd) or not get_cocos_refid(arg_64_0.vars.confirm_wnd) then
		return 
	end
	
	BackButtonManager:pop({
		id = "equip_craft_reforging_confirm",
		dlg = arg_64_0.vars.confirm_wnd
	})
	arg_64_0.vars.confirm_wnd:removeFromParent()
end

function SanctuaryCraftUpgrade.refreshAll(arg_65_0)
	arg_65_0:getItemList()
	arg_65_0:initListView()
	
	arg_65_0.vars.selectedItem = nil
	arg_65_0.vars.result_item = nil
	
	arg_65_0:setCurMaterial()
	arg_65_0:updateCenterUI()
	arg_65_0:updateLeftUI()
	arg_65_0:refreshItems()
end

function SanctuaryCraftUpgrade.canLeave(arg_66_0)
	if arg_66_0.vars and get_cocos_refid(arg_66_0.vars.wnd) and get_cocos_refid(arg_66_0.vars.confirm_wnd) then
		return false
	end
	
	return true
end

function SanctuaryCraftUpgrade.onLeave(arg_67_0)
	if not arg_67_0.vars or not get_cocos_refid(arg_67_0.vars.wnd) or get_cocos_refid(arg_67_0.vars.confirm_wnd) then
		return 
	end
	
	BackButtonManager:pop({
		id = "TopBarNew." .. T("system_009_title"),
		dlg = arg_67_0.vars.wnd
	})
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_67_0.vars.wnd, "block")
	
	if arg_67_0.vars.quick_enter then
		TopBarNew:pop()
	end
	
	if type(arg_67_0.vars.callback_on_leave) == "function" then
		arg_67_0.vars.callback_on_leave()
	end
	
	arg_67_0.vars = nil
end

function SanctuaryCraftUpgradeUtil.getSetCount(arg_68_0)
	local var_68_0 = var_0_3 or {}
	
	if table.empty(var_68_0) then
		return 6
	end
	
	return table.count(var_68_0)
end

function SanctuaryCraftUpgradeUtil.getMaterialTypeCount(arg_69_0)
	local var_69_0 = var_0_5 or {}
	
	if table.empty(var_69_0) then
		return 6
	end
	
	return table.count(var_69_0)
end

function SanctuaryCraftUpgradeUtil.initTypes(arg_70_0)
	if not var_0_3 or not table.empty(var_0_3) then
		return 
	end
	
	for iter_70_0 = 1, 99 do
		local var_70_0, var_70_1, var_70_2 = DBN("item_equip_upgrade", iter_70_0, {
			"id",
			"set_id",
			"material"
		})
		
		if not var_70_0 then
			break
		end
		
		if not table.find(var_0_3, var_70_1) then
			table.insert(var_0_3, var_70_1)
		end
		
		if not table.find(var_0_5, var_70_2) then
			table.insert(var_0_5, var_70_2)
		end
	end
end
