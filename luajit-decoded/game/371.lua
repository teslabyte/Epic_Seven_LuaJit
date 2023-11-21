UnitExclusiveEquip = {}

copy_functions(ScrollView, UnitExclusiveEquip)

function HANDLER.unit_private(arg_1_0, arg_1_1)
	local var_1_0 = getParentWindow(arg_1_0).equip
	
	if (arg_1_1 == "btn_up" or arg_1_1 == "btn_puton" or arg_1_1 == "btn_putoff" or arg_1_1 == "btn_unequip" or arg_1_1 == "btn_equip") and var_1_0 and var_1_0:isStone() then
		balloon_message_with_sound("equip_stone_none")
		
		return 
	end
	
	if arg_1_1 == "btn_puton" or arg_1_1 == "btn_putoff" or arg_1_1 == "btn_puton_cost" or arg_1_1 == "btn_unequip" or arg_1_1 == "btn_equip" then
		UnitExclusiveEquip:reqWearEquip()
	end
	
	if arg_1_1 == "btn_top_back" then
		UnitExclusiveEquip:onPushBackButton()
	end
end

function UnitExclusiveEquip.isVisible(arg_2_0)
	return arg_2_0.vars and arg_2_0.vars.wnd and get_cocos_refid(arg_2_0.vars.wnd)
end

function UnitExclusiveEquip.OpenPopup(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:onCreate({
		popup_mode = true,
		unit = arg_3_1,
		pos = arg_3_2
	})
	arg_3_0:onEnter()
	TopBarNew:createFromPopup(T("puton"), arg_3_0.vars.wnd, function()
		arg_3_0:onLeave()
	end)
	TopBarNew:setDisableTopRight()
end

function UnitExclusiveEquip.onCreate(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.opts = arg_5_1
	arg_5_0.vars.popup_mode = arg_5_1.popup_mode
	arg_5_0.vars.wnd = load_dlg("unit_private", true, "wnd")
	
	if NotchStatus:isRequireAdjustEdge() then
		local var_5_0 = getChildByPath(arg_5_0.vars.wnd, "TOP_LEFT")
		
		if var_5_0 then
			NotchManager:addListener(var_5_0, nil, function()
				var_5_0:setPositionX(VIEW_BASE_LEFT + NotchStatus:getAdjustEdgeValue())
			end)
		end
	end
	
	;(arg_5_1.layer or SceneManager:getRunningPopupScene()):addChild(arg_5_0.vars.wnd)
end

function UnitExclusiveEquip.onSelectEquip(arg_7_0, arg_7_1)
	EquipBelt:setSelect(arg_7_0.vars.before_equip, false)
	EquipBelt:setSelect(arg_7_1, true)
	
	arg_7_0.vars.before_equip = arg_7_1
	
	arg_7_0:updateInfo()
	SoundEngine:play("event:/ui/ok")
	TutorialGuide:procGuide("equip_install")
	TutorialGuide:procGuide("artifact_install")
end

function UnitExclusiveEquip.GetItems(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_2 = arg_8_2 or arg_8_0.vars.category
	
	local var_8_0 = {}
	
	for iter_8_0, iter_8_1 in pairs(Account.equips) do
		if iter_8_1.db.type == arg_8_2 and iter_8_1 ~= arg_8_3 then
			local var_8_1 = not iter_8_1.parent
			
			if iter_8_1.parent and arg_8_1:getUID() == iter_8_1.parent then
				var_8_1 = true
			end
			
			if arg_8_4 and iter_8_1.db.stone == "y" then
				var_8_1 = nil
			end
			
			if var_8_1 and (not arg_8_5 or not iter_8_1.lock) and (not arg_8_0.vars or iter_8_1 ~= arg_8_0.vars.base_equip) then
				var_8_0[#var_8_0 + 1] = iter_8_1
			end
		end
	end
	
	return var_8_0
end

function UnitExclusiveEquip.onEnter(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or arg_9_0.vars.opts or {}
	arg_9_0.vars.unit = arg_9_2.unit
	arg_9_0.vars.pos = arg_9_2.pos
	arg_9_0.vars.is_exclusive = arg_9_0.vars.pos == 8
	arg_9_0.vars.category = EQUIP:getEquipPositionByIndex(arg_9_0.vars.pos)
	
	arg_9_0:init()
	arg_9_0:updateInfo()
	
	local var_9_0 = arg_9_0.vars.prev_equip
	
	if var_9_0 then
		local var_9_1 = var_9_0:getUnequipCost()
		
		if_set(arg_9_0.vars.wnd, "txt_puton_cost", comma_value(var_9_1))
		if_set(arg_9_0.vars.wnd, "txt_equip", T("ui_equip_popup_btn_change"))
		
		local var_9_2 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
		
		if var_9_0:getUnequipCost() <= 0 and var_9_2 then
			if_set_visible(arg_9_0.vars.wnd:findChildByName("btn_equip"), "event_badge", true)
			if_set_visible(arg_9_0.vars.wnd:findChildByName("btn_unequip"), "event_badge", true)
		else
			if_set_visible(arg_9_0.vars.wnd:findChildByName("btn_equip"), "event_badge", false)
			if_set_visible(arg_9_0.vars.wnd:findChildByName("btn_unequip"), "event_badge", false)
		end
	else
		if_set_visible(arg_9_0.vars.wnd, "txt_puton_cost", false)
		if_set_visible(arg_9_0.vars.wnd, "b", false)
		if_set_visible(arg_9_0.vars.wnd, "c", false)
		
		local var_9_3 = arg_9_0.vars.wnd:getChildByName("txt_equip"):getPositionX() or 0
		
		arg_9_0.vars.wnd:getChildByName("txt_equip"):setPositionX(var_9_3 - 60)
		if_set_visible(arg_9_0.vars.wnd:findChildByName("btn_equip"), "event_badge", false)
		if_set_visible(arg_9_0.vars.wnd:findChildByName("btn_unequip"), "event_badge", false)
	end
	
	TutorialGuide:procGuide("equip_install")
end

function UnitExclusiveEquip.init(arg_10_0)
	EquipBelt:show({
		is_exclusive = arg_10_0.vars.is_exclusive,
		base_unit = arg_10_0.vars.unit,
		parent = arg_10_0.vars.wnd:getChildByName("n_equiplist"),
		sorter_parent = arg_10_0.vars.wnd:getChildByName("n_custom_sorting"),
		default_sort_index = SAVE:get("app.equip_exclusive_sort_index", 1),
		callback_sort = function(arg_11_0, arg_11_1)
			SAVE:set("app.equip_exclusive_sort_index", arg_11_1)
		end,
		select_callback = function(arg_12_0)
			arg_10_0:onSelectEquip(arg_12_0)
		end,
		priority_sort_func = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			local var_13_0 = EQUIP:checkExclusive(arg_13_3.base_unit, arg_13_0)
			
			if var_13_0 ~= EQUIP:checkExclusive(arg_13_3.base_unit, arg_13_1) then
				return var_13_0 == true
			end
		end
	})
	EquipBelt:updateList(arg_10_0:GetItems(arg_10_0.vars.unit, arg_10_0.vars.category, nil, true))
	
	arg_10_0.vars.before_equip = arg_10_0.vars.unit:getEquipByIndex(arg_10_0.vars.pos)
	arg_10_0.vars.prev_equip = arg_10_0.vars.before_equip
	
	if arg_10_0.vars.before_equip == nil then
		local var_10_0 = EquipBelt:getEquipList()[1]
		
		if var_10_0 and arg_10_0.vars.unit.db.code == var_10_0.db.exclusive_unit then
			arg_10_0.vars.before_equip = EquipBelt:getEquipList()[1]
			
			arg_10_0:onSelectEquip(EquipBelt:getEquipList()[1])
		end
		
		arg_10_0:updateInfo()
	else
		arg_10_0:onSelectEquip(arg_10_0.vars.before_equip)
	end
	
	if_set_visible(arg_10_0.vars.wnd, "LEFT", true)
	if_set_visible(arg_10_0.vars.wnd, "CENTER", true)
	
	arg_10_0.vars.item_wnd = load_dlg("item_private_change", true, "wnd")
	
	arg_10_0.vars.wnd:getChildByName("CENTER"):getChildByName("pos_base"):addChild(arg_10_0.vars.item_wnd)
	arg_10_0.vars.item_wnd:setPositionX(0)
	arg_10_0.vars.item_wnd:setPositionY(0)
	arg_10_0.vars.item_wnd:setAnchorPoint(0, 0)
end

function UnitExclusiveEquip.updateInfo(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) or not get_cocos_refid(arg_14_0.vars.item_wnd) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.before_equip
	local var_14_1
	local var_14_2
	local var_14_3 = {
		wnd = arg_14_0.vars.item_wnd
	}
	
	var_14_3.no_resize = true
	
	if var_14_0 then
		var_14_3.equip = var_14_0
	else
		local var_14_4 = arg_14_0.vars.unit:getExclusiveEquip()
		
		if not var_14_4 then
			Log.e("NOT EXIST ex_equip ")
		end
		
		var_14_2 = DB("equip_item", var_14_4, "main_stat")
		var_14_1 = EQUIP:createByInfo({
			code = var_14_4
		})
		var_14_3.equip = var_14_1
	end
	
	ItemTooltip:updateItemInformation(var_14_3)
	
	local var_14_5 = arg_14_0.vars.unit
	local var_14_6 = var_14_0 or var_14_1
	
	if var_14_0 and arg_14_0.vars.unit.db.code ~= var_14_0.db.exclusive_unit then
		local var_14_7 = DB("character", var_14_0.db.exclusive_unit, {
			"grade"
		})
		
		var_14_5 = UNIT:create({
			z = 6,
			code = var_14_0.db.exclusive_unit,
			g = var_14_7
		})
	end
	
	if_set(arg_14_0.vars.wnd:getChildByName("LEFT"), "txt_title", T("exc_title_" .. var_14_6.db.exclusive_unit))
	
	local var_14_8 = arg_14_0.vars.wnd:findChildByName("btn_unequip")
	
	if arg_14_0.vars.prev_equip then
		local var_14_9 = arg_14_0.vars.prev_equip:getUnequipCost()
		
		if_set(var_14_8, "txt_puton_cost", comma_value(var_14_9))
		
		local var_14_10 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
		
		if arg_14_0.vars.prev_equip:getUnequipCost() <= 0 and var_14_10 then
			if_set_visible(arg_14_0.vars.wnd:findChildByName("btn_equip"), "event_badge", true)
			if_set_visible(arg_14_0.vars.wnd:findChildByName("btn_unequip"), "event_badge", true)
		else
			if_set_visible(arg_14_0.vars.wnd:findChildByName("btn_equip"), "event_badge", false)
			if_set_visible(arg_14_0.vars.wnd:findChildByName("btn_unequip"), "event_badge", false)
		end
		
		if_set_visible(arg_14_0.vars.wnd, "btn_equip", false)
		if_set_visible(arg_14_0.vars.wnd, "btn_puton_cost", false)
		if_set_visible(arg_14_0.vars.wnd, "btn_unequip", true)
		
		if arg_14_0.vars.prev_equip:getUID() == var_14_0:getUID() then
			if_set(var_14_8, "txt_equip", T("ui_equip_popup_btn_unequip"))
		else
			if_set(var_14_8, "txt_equip", T("ui_equip_popup_btn_change"))
		end
		
		UIUtil:changeButtonState(arg_14_0.vars.wnd.c.btn_unequip, arg_14_0.vars.unit.db.code == var_14_0.db.exclusive_unit, true)
	elseif var_14_1 then
		if_set_visible(arg_14_0.vars.wnd, "btn_equip", false)
		if_set_visible(arg_14_0.vars.wnd, "btn_puton_cost", false)
		if_set_visible(arg_14_0.vars.wnd, "btn_unequip", false)
		if_set_visible(arg_14_0.vars.item_wnd, "n_detail", false)
		
		local var_14_11, var_14_12, var_14_13 = DB("equip_stat", var_14_2 .. "_1", {
			"stat_type",
			"val_min",
			"val_max"
		})
		
		if_set(arg_14_0.vars.item_wnd, "txt_main_name", getStatName(var_14_11))
		
		local var_14_14 = ItemTooltip:getExclusiveStatRange(var_14_12, var_14_13, var_14_11)
		
		if_set(arg_14_0.vars.item_wnd, "txt_main_stat", var_14_14)
		SpriteCache:resetSprite(arg_14_0.vars.item_wnd:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_14_11, "_rate", "") .. ".png")
	else
		if_set_visible(var_14_8, "txt_puton_cost", false)
		if_set_visible(var_14_8, "b", false)
		if_set_visible(var_14_8, "c", false)
		
		local var_14_15 = var_14_8:getChildByName("txt_equip"):getPositionX() or 0
		
		var_14_8:getChildByName("txt_equip"):setPositionX(var_14_15 - 60)
		if_set_visible(arg_14_0.vars.wnd:findChildByName("btn_equip"), "event_badge", false)
		if_set_visible(arg_14_0.vars.wnd:findChildByName("btn_unequip"), "event_badge", false)
		UIUtil:changeButtonState(arg_14_0.vars.wnd.c.btn_puton_cost, arg_14_0.vars.unit.db.code == var_14_0.db.exclusive_unit, true)
		if_set_visible(arg_14_0.vars.wnd, "btn_puton_cost", false)
		UIUtil:changeButtonState(arg_14_0.vars.wnd.c.btn_equip, arg_14_0.vars.unit.db.code == var_14_0.db.exclusive_unit, true)
		if_set_visible(arg_14_0.vars.wnd, "btn_equip", true)
		if_set_visible(arg_14_0.vars.wnd, "btn_unequip", false)
	end
	
	if_set(arg_14_0.vars.item_wnd, "txt_type", T("item_type_exclusive"))
	if_set(arg_14_0.vars.wnd, "txt_info", T("info_exclusive_de"))
	if_set_visible(arg_14_0.vars.item_wnd, "txt_name", false)
	if_set_visible(arg_14_0.vars.item_wnd, "txt_type", false)
	
	local var_14_16 = arg_14_0.vars.item_wnd:getChildByName("n_private")
	
	if get_cocos_refid(var_14_16) then
		local var_14_17 = var_14_16:getChildByName("txt_type")
		
		if_set(var_14_17, nil, T("item_type_exclusive"))
		
		local var_14_18 = var_14_16:getChildByName("txt_name")
		
		if_set(var_14_18, nil, T(var_14_6.db.name))
	end
	
	local var_14_19 = arg_14_0.vars.wnd:getChildByName("LEFT"):findChildByName("n_skill")
	
	if get_cocos_refid(var_14_19) then
		UIUtil:setUnitSkillInfo(var_14_19, var_14_5, {
			tooltip_opts = {
				show_effs = "right"
			}
		})
	end
	
	UnitExclusiveEquip:setPortrait(var_14_5)
end

function UnitExclusiveEquip.setPortrait(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_portrait")
	
	if not arg_15_0.vars.beforeUnit or arg_15_0.vars.beforeUnit and arg_15_0.vars.beforeUnit.db.code ~= arg_15_1.db.code then
		arg_15_0.vars.beforeUnit = arg_15_1
	else
		return 
	end
	
	if arg_15_0.vars.portrait and get_cocos_refid(arg_15_0.vars.portrait) then
		UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, 600), 300), FADE_OUT(250)), REMOVE()), arg_15_0.vars.portrait)
	end
	
	arg_15_0.vars.portrait = UIUtil:getPortraitAni(arg_15_0.vars.beforeUnit.db.face_id, {
		pin_sprite_position_y = true
	})
	
	if get_cocos_refid(arg_15_0.vars.portrait) and get_cocos_refid(var_15_0) then
		var_15_0:addChild(arg_15_0.vars.portrait)
		arg_15_0.vars.portrait:setOpacity(0)
		UIAction:Add(SEQ(SPAWN(LOG(SCALE(250, 0, 0.8), 300), LOG(SLIDE_IN(250, 1600, false), 300), FADE_IN(250))), arg_15_0.vars.portrait)
	end
end

function UnitExclusiveEquip.onLeave(arg_16_0, arg_16_1)
	if arg_16_0.vars.popup_mode then
		TopBarNew:pop()
		BackButtonManager:pop("TopBarNew." .. T("puton"))
	end
	
	EquipBelt:hide()
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_16_0.vars.wnd:getChildByName("LEFT"), "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_16_0.vars.wnd:getChildByName("CENTER"), "block")
	UIAction:Add(SEQ(MOVE_BY(200, 900)), arg_16_0.vars.wnd:getChildByName("n_custom_sorting"), "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), arg_16_0.vars.wnd, "block")
	
	if UnitDetail.vars and get_cocos_refid(UnitDetail.vars.wnd) and UnitDetail:getUnit() then
		HeroBelt:getInst("UnitMain"):getInst("UnitMain"):scrollToUnit(arg_16_0.vars.unit, 0)
		
		if UnitDetail:getCurDetailMode() == "Equip" and UnitDetailEquip:isVisible() then
			UnitDetailEquip:updateExclusiveEquipAlert()
		end
	end
	
	arg_16_0.vars = nil
end

function UnitExclusiveEquip.PutOn(arg_17_0, arg_17_1)
	local var_17_0 = Account:getUnit(arg_17_1.unit)
	local var_17_1 = Account:getEquip(arg_17_1.equip)
	local var_17_2 = Account:getEquip(arg_17_1.putoff_equip)
	
	if var_17_2 then
		var_17_0:removeEquip(var_17_2)
	end
	
	Account:updateCurrencies(arg_17_1)
	TopBarNew:topbarUpdate(true)
	
	if not var_17_0:addEquip(var_17_1) then
		return false
	end
	
	local var_17_3 = "event:/ui/equip/equip_" .. var_17_1.db.type
	
	if SoundEngine:existsEvent(var_17_3) then
		SoundEngine:play(var_17_3)
	else
		SoundEngine:play("event:/ui/equip_on")
	end
	
	if arg_17_0.vars then
		arg_17_0:onLeave()
	end
	
	arg_17_0:updateWearInfo(var_17_0, var_17_1)
	Inventory:UpdateContents()
	Inventory:PlayEquipSetEffect(var_17_0, var_17_1)
	TutorialGuide:procGuide("equip_install")
	SkillEffectFilterManager:refreshUnit(var_17_0)
	
	return true
end

function UnitExclusiveEquip.updateWearInfo(arg_18_0, arg_18_1, arg_18_2)
	if SceneManager:getCurrentSceneName() == "unit_ui" or UnitDetail.vars and get_cocos_refid(UnitDetail.vars.wnd) then
		local var_18_0 = HeroBelt:getInst("UnitMain")
		
		if var_18_0:isValid() then
			var_18_0:updateUnit(nil, arg_18_1)
		end
		
		if UnitDetail:isValid() then
			UnitDetail:updateUnitInfo()
			
			if arg_18_2 then
				UIUtil:playEquipSetEffect(UnitDetail.vars.wnd, arg_18_1, arg_18_2)
			end
		end
	end
end

function UnitExclusiveEquip.PutOff(arg_19_0, arg_19_1)
	SoundEngine:play("event:/ui/equip_off")
	Account:updateCurrencies(arg_19_1)
	TopBarNew:topbarUpdate(true)
	
	local var_19_0
	local var_19_1 = {}
	
	for iter_19_0, iter_19_1 in pairs(arg_19_1.equips) do
		local var_19_2 = Account:getEquip(iter_19_1)
		
		if var_19_2 then
			var_19_0 = Account:getUnit(var_19_2.parent)
			
			if var_19_0 then
				var_19_0:removeEquip(var_19_2)
				SkillEffectFilterManager:refreshUnit(var_19_0)
				table.push(var_19_1, var_19_0)
			end
		end
	end
	
	if string.starts(arg_19_1.caller, "inventory") then
		Inventory:MSG_putoff_equip(arg_19_1)
	end
	
	arg_19_0:updateWearInfo(var_19_0)
	
	if UnitMain:isValid() then
		local var_19_3 = HeroBelt:getInst("UnitMain")
		
		for iter_19_2, iter_19_3 in pairs(var_19_1) do
			var_19_3:updateUnit(nil, iter_19_3)
		end
		
		if UnitDetail:isValid() then
			UnitDetail:updateUnitInfo()
		end
	end
	
	if arg_19_0.vars then
		if get_cocos_refid(arg_19_0.vars.base_equip_wnd) then
			arg_19_0.vars.base_equip_wnd:removeFromParent()
		end
		
		arg_19_0.vars.base_equip_wnd = nil
		arg_19_0.vars.base_equip = nil
		
		if arg_19_0.updateGuide then
			arg_19_0:updateGuide()
		end
		
		EquipBelt:updateEquipBar(arg_19_0.vars.before_equip)
		
		arg_19_0.vars.prev_equip = nil
		
		arg_19_0:onSelectEquip(EquipBelt:getEquipList()[1])
	end
end

function UnitExclusiveEquip.reqWearEquip(arg_20_0)
	if not arg_20_0.vars.before_equip then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.before_equip:getUID()
	local var_20_1 = Account:getEquip(var_20_0)
	local var_20_2 = arg_20_0.vars.unit
	
	if var_20_1.db.exclusive_unit and var_20_1.db.exclusive_unit ~= var_20_2.db.code then
		balloon_message_with_sound("cannot_equip_class_exclusive_de")
		
		return 
	end
	
	if var_20_1.db.role and var_20_1.db.role ~= var_20_2.db.role then
		balloon_message_with_sound("cannot_equip_class_exclusive_de")
		
		return 
	end
	
	if var_20_1.parent then
		if var_20_1 == arg_20_0.vars.before_equip and var_20_1.parent ~= var_20_2:getUID() then
			balloon_message_with_sound("equip_used")
			
			return 
		end
		
		if var_20_1 == arg_20_0.vars.base_equip then
			Inventory:ReqUnequip(var_20_1, "inventory_wear")
			
			return 
		end
		
		if var_20_1 == arg_20_0.vars.before_equip and var_20_1.parent == var_20_2:getUID() then
			Inventory:ReqUnequip(var_20_1, "inventory_wear")
			
			return 
		end
		
		return 
	end
	
	local var_20_3 = var_20_2:getEquipByPos(var_20_1.db.type)
	
	local function var_20_4()
		local var_21_0
		
		if var_20_3 then
			var_21_0 = var_20_3:getUID()
		end
		
		query("puton_equip", {
			unit = var_20_2:getUID(),
			equip = var_20_0,
			putoff_equip = var_21_0
		})
	end
	
	local var_20_5 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
	
	if not var_20_3 or var_20_3:getUnequipCost() <= 0 and var_20_5 then
		var_20_4()
		
		return 
	end
	
	local var_20_6 = var_20_3:getUnequipCost()
	
	if var_20_6 > Account:getCurrency("gold") then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	Dialog:msgBox(T("equip_swap_desc", {
		cost = var_20_6
	}), {
		token = "to_gold",
		yesno = true,
		title = T("equip_change_title"),
		cost = var_20_6,
		handler = var_20_4
	})
end

function UnitExclusiveEquip.onPushBackButton(arg_22_0)
end
