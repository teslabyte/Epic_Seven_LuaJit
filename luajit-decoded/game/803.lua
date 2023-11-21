UnitDetailEquip = {}

function UnitDetailEquip.onCreate(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	
	if not get_cocos_refid(arg_1_1.detail_wnd) then
		return 
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.menu_wnd = arg_1_1.detail_wnd:getChildByName("n_menu_equipment")
	
	arg_1_0:initUI()
end

function UnitDetailEquip.initUI(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.menu_wnd) then
		return 
	end
	
	arg_2_0.vars.left = arg_2_0.vars.menu_wnd:getChildByName("left_equipment")
	arg_2_0.vars.center = arg_2_0.vars.menu_wnd:getChildByName("center_equipment")
	
	local var_2_0 = arg_2_0.vars.menu_wnd:getChildByName("n_item")
	
	if get_cocos_refid(var_2_0) then
		arg_2_0.vars.equip_btns = {
			var_2_0:getChildByName("btn_item1"),
			var_2_0:getChildByName("btn_item2"),
			var_2_0:getChildByName("btn_item3"),
			var_2_0:getChildByName("btn_item4"),
			var_2_0:getChildByName("btn_item5"),
			var_2_0:getChildByName("btn_item6"),
			var_2_0:getChildByName("btn_item7"),
			var_2_0:getChildByName("btn_item8")
		}
	end
	
	arg_2_0.vars.TUTORIAL_EQUIP = UnlockSystem:isUnlockSystem(UNLOCK_ID.TUTORIAL_EQUIP)
	
	if_set_visible(arg_2_0.vars.equip_btns[1], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[2], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[3], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[4], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[5], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[6], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[7], "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.equip_btns[8], "icon_locked", not Account:canUseExclusive())
	if_set_visible(arg_2_0.vars.center:getChildByName("btn_equip"), "icon_locked", not arg_2_0.vars.TUTORIAL_EQUIP)
	if_set_visible(arg_2_0.vars.center, "btn_item_up", false)
	if_set_visible(arg_2_0.vars.center, "btn_auto_equip", false)
	if_set_position_x(arg_2_0.vars.center, "btn_equip", 581)
	if_set_position_x(arg_2_0.vars.center, "btn_unequip", 781)
end

function UnitDetailEquip.isVisible(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.menu_wnd) then
		return false
	end
	
	return arg_3_0.vars.menu_wnd:isVisible()
end

function UnitDetailEquip.onRelease(arg_4_0)
end

function UnitDetailEquip.onEnter(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.menu_wnd) then
		return 
	end
	
	arg_5_0:enterUI()
end

function UnitDetailEquip.onLeave(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.menu_wnd) then
		return 
	end
	
	arg_6_0:leaveUI()
end

function UnitDetailEquip.enterUI(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.menu_wnd) then
		return 
	end
	
	arg_7_0.vars.menu_wnd:setVisible(true)
	arg_7_0.vars.menu_wnd:setOpacity(0)
	
	local var_7_0 = arg_7_0.vars.left
	local var_7_1 = arg_7_0.vars.center
	
	var_7_0:getChildByName("n_skills"):setOpacity(0)
	var_7_0:getChildByName("detail_stats"):setOpacity(0)
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_7_0:getChildByName("name"), "block")
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_7_0:getChildByName("n_dim"), "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_IN(200, 600)), var_7_0:getChildByName("n_skills"), "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_IN(200, 600)), var_7_0:getChildByName("detail_stats"), "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 300)), var_7_1, "block")
	UIAction:Add(FADE_IN(400), arg_7_0.vars.menu_wnd, "block")
	arg_7_0:onChangeResolution()
	
	local var_7_2 = UnitDetail:getHeroBelt()
	
	if var_7_2 then
		var_7_2:setTouchEnabled(true)
		var_7_2:setScrollEnabled(true)
	end
end

function UnitDetailEquip.leaveUI(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.menu_wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.left
	local var_8_1 = arg_8_0.vars.center
	
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_8_0:getChildByName("name"), "block")
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_8_0:getChildByName("n_dim"), "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_OUT(200, -600)), var_8_0:getChildByName("n_skills"), "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_OUT(200, -600)), var_8_0:getChildByName("detail_stats"), "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, -300)), var_8_1, "block")
	UIAction:Add(SEQ(DELAY(400), SHOW(false)), arg_8_0.vars.menu_wnd, "block")
end

function UnitDetailEquip.getEquipUIOpacity(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1:isOrganizable() or arg_9_2 and not arg_9_1:getEquipByIndex(arg_9_2) and #UnitEquip:GetItems(arg_9_1, EQUIP:getEquipPositionByIndex(arg_9_2), {
		ignore_equipped = true,
		ignore_stone = true
	}) < 1 or not UnlockSystem:isUnlockSystem(UNLOCK_ID.TUTORIAL_EQUIP) then
		return 76.5
	else
		return 255
	end
end

function UnitDetailEquip.updateUnitInfo(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.menu_wnd) then
		return 
	end
	
	arg_10_1 = arg_10_1 or arg_10_0.vars.unit
	
	local var_10_0 = UnitDetail:getHeroBelt()
	
	if var_10_0 then
		var_10_0:updateUnit(nil, arg_10_1)
	end
	
	arg_10_0.vars.unit = arg_10_1
	
	local var_10_1 = arg_10_0.vars.menu_wnd:getChildByName("txt_name")
	
	var_10_1:setString(T(arg_10_1.db.name))
	UIUserData:proc(var_10_1)
	if_call(arg_10_0.vars.menu_wnd, "star1", "setPositionX", 10 + var_10_1:getContentSize().width * var_10_1:getScaleX() + var_10_1:getPositionX())
	UIUtil:setUnitAllInfo(arg_10_0.vars.menu_wnd, arg_10_1)
	UIUtil:setLevelDetail(arg_10_0.vars.menu_wnd, arg_10_1:getLv(), arg_10_1:getMaxLevel())
	
	if not arg_10_0.vars.n_dedi then
		arg_10_0.vars.n_dedi = arg_10_0.vars.menu_wnd:getChildByName("n_dedi")
	end
	
	UIUtil:setDevoteDetail_new(arg_10_0.vars.n_dedi, arg_10_1, {
		view_next_level = true,
		is_skill_text_CRLF = true
	})
	arg_10_0:updateArtiAndExclusiveSlot(arg_10_1)
	arg_10_0:updateExclusiveEquipAlert(arg_10_1)
	arg_10_0:updateUnitEquipItems(arg_10_1)
	arg_10_0:updateEquipManagerButton(arg_10_1)
	arg_10_0:updateUnEquipButton(arg_10_1)
	
	if arg_10_0.vars.unit:isGrowthBoostRegistered() then
		local var_10_2 = arg_10_0.vars.unit:clone()
		
		GrowthBoost:apply(var_10_2)
		
		var_10_2.inst.locked = arg_10_0.vars.unit:isLocked()
		
		UIUtil:setUnitAllInfo(arg_10_0.vars.menu_wnd, var_10_2)
		UIUtil:setLevelDetail(arg_10_0.vars.menu_wnd, var_10_2:getLv(), var_10_2:getMaxLevel())
	end
end

function UnitDetailEquip.onChangeResolution(arg_11_0)
	if not arg_11_0:isVisible() or not get_cocos_refid(arg_11_0.vars.center) then
		return 
	end
	
	arg_11_0.vars.center:getChildByName("n_item_left_base"):setPositionX(VIEW_BASE_LEFT * 0.5 + NOTCH_WIDTH / 2 * 0.5)
	arg_11_0.vars.center:getChildByName("n_item_right_base"):setPositionX(0 - VIEW_BASE_LEFT * 0.5 - NOTCH_WIDTH / 2 * 0.5)
end

function UnitDetailEquip.updateUnitEquipItems(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.menu_wnd) then
		return 
	end
	
	arg_12_1 = arg_12_1 or arg_12_0.vars.unit
	
	for iter_12_0 = 1, 8 do
		local var_12_0 = arg_12_0.vars.menu_wnd:getChildByName("item" .. iter_12_0)
		
		if get_cocos_refid(var_12_0) then
			var_12_0:removeFromParent()
		end
		
		local var_12_1 = arg_12_1:getEquipByIndex(iter_12_0)
		local var_12_2 = arg_12_0.vars.menu_wnd:getChildByName("n_item" .. iter_12_0)
		
		if var_12_2 then
			var_12_2:removeAllChildren()
			
			if var_12_1 then
				local var_12_3 = UIUtil:getRewardIcon("equip", var_12_1.code, {
					scale = 1,
					tooltip_delay = 120,
					parent = var_12_2,
					equip = var_12_1
				})
				
				var_12_3:setPosition(-2, 2)
				var_12_3:setName("item" .. iter_12_0)
				var_12_3:setAnchorPoint(0.5, 0.5)
				
				if iter_12_0 == 7 then
					if_set_visible(var_12_3, "locked", false)
					if_set_visible(var_12_3, "locked2", var_12_1.lock)
				else
					if_set_visible(var_12_3, "locked", var_12_1.lock)
				end
			end
		end
		
		if_set_opacity(arg_12_0.vars.menu_wnd, "btn_item" .. iter_12_0, arg_12_0:getEquipUIOpacity(arg_12_1, iter_12_0))
	end
end

function UnitDetailEquip.updateEquipLock(arg_13_0, arg_13_1)
	if not arg_13_0:isVisible() or not arg_13_0.vars.unit or not arg_13_1 then
		return 
	end
	
	local var_13_0 = Account:getUnit(arg_13_1.parent)
	local var_13_1 = EQUIP.getEquipPositionIndex(arg_13_1)
	
	if not var_13_0 or not var_13_1 or arg_13_0.vars.unit ~= var_13_0 then
		return 
	end
	
	local var_13_2 = arg_13_0.vars.menu_wnd:getChildByName("item" .. var_13_1)
	
	if var_13_2 then
		var_13_2:removeFromParent()
	else
		return 
	end
	
	local var_13_3 = arg_13_0.vars.menu_wnd:getChildByName("n_item" .. var_13_1)
	
	if var_13_3 then
		var_13_3:removeAllChildren()
		
		if arg_13_1 then
			local var_13_4 = UIUtil:getRewardIcon("equip", arg_13_1.code, {
				scale = 1,
				tooltip_delay = 120,
				parent = var_13_3,
				equip = arg_13_1
			})
			
			var_13_4:setPosition(-2, 2)
			var_13_4:setName("item" .. var_13_1)
			var_13_4:setAnchorPoint(0.5, 0.5)
			
			if var_13_1 == 7 then
				if_set_visible(var_13_4, "locked", false)
				if_set_visible(var_13_4, "locked2", arg_13_1.lock)
			else
				if_set_visible(var_13_4, "locked", arg_13_1.lock)
			end
		end
	end
end

function UnitDetailEquip.updateEquipManagerButton(arg_14_0, arg_14_1)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.menu_wnd) or not get_cocos_refid(arg_14_0.vars.center) then
		return 
	end
	
	arg_14_1 = arg_14_1 or arg_14_0.vars.unit
	
	if not arg_14_1 then
		return 
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_MANAGER) then
		if_set_visible(arg_14_0.vars.menu_wnd, "btn_equip", false)
	else
		if_set_opacity(arg_14_0.vars.menu_wnd, "btn_equip", arg_14_0:getEquipUIOpacity(arg_14_1))
	end
end

function UnitDetailEquip.updateUnEquipButton(arg_15_0, arg_15_1)
	if not arg_15_0:isVisible() or not get_cocos_refid(arg_15_0.vars.center) then
		return 
	end
	
	arg_15_1 = arg_15_1 or arg_15_0.vars.unit
	
	if not arg_15_1 then
		return 
	end
	
	local var_15_0 = false
	
	for iter_15_0, iter_15_1 in pairs(arg_15_1.equips or {}) do
		if not iter_15_1:isExclusive() and not iter_15_1:isArtifact() then
			var_15_0 = true
			
			break
		end
	end
	
	if_set_opacity(arg_15_0.vars.center, "btn_unequip", var_15_0 and 255 or 76.5)
end

function UnitDetailEquip.updateArtiAndExclusiveSlot(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.menu_wnd) or not get_cocos_refid(arg_16_0.vars.center) then
		return 
	end
	
	arg_16_1 = arg_16_1 or arg_16_0.vars.unit
	
	if not arg_16_1 then
		return 
	end
	
	if_set_visible(arg_16_0.vars.center, "bg_art", false)
	if_set_visible(arg_16_0.vars.center, "bg_pri_on", false)
	if_set_visible(arg_16_0.vars.center, "bg_art_on", false)
	if_set_visible(arg_16_0.vars.center, "bg_all", false)
	if_set_visible(arg_16_0.vars.center, "btn_item8", arg_16_1:isExclusiveEquip_exist())
	
	if not arg_16_0.vars.TUTORIAL_EQUIP then
		if arg_16_1:isExclusiveEquip_exist() then
			if_set_visible(arg_16_0.vars.center, "bg_all", true)
			if_set_opacity(arg_16_0.vars.center, "bg_all", 76.5)
		else
			if_set_visible(arg_16_0.vars.center, "bg_art", true)
			if_set_opacity(arg_16_0.vars.center, "bg_art", 76.5)
			if_set_visible(arg_16_0.vars.center, "btn_item8", false)
		end
		
		return 
	end
	
	local var_16_0 = {
		ignore_equipped = true,
		ignore_stone = true,
		check_role = true
	}
	
	if arg_16_1:isExclusiveEquip_exist() then
		if arg_16_1:canEquip_Exclusive() and #UnitEquip:GetItems(arg_16_1, EQUIP:getEquipPositionByIndex(8)) > 0 then
			if_set_visible(arg_16_0.vars.center:getChildByName("btn_item8"), "icon_locked", false)
			
			if #UnitEquip:GetItems(arg_16_1, EQUIP:getEquipPositionByIndex(7), var_16_0) > 0 then
				if_set_visible(arg_16_0.vars.center, "bg_all", true)
				if_set_opacity(arg_16_0.vars.center, "bg_all", 255)
			else
				if_set_visible(arg_16_0.vars.center, "bg_pri_on", true)
			end
		elseif #UnitEquip:GetItems(arg_16_1, EQUIP:getEquipPositionByIndex(7), var_16_0) > 0 then
			if_set_visible(arg_16_0.vars.center, "bg_art_on", true)
		else
			if_set_visible(arg_16_0.vars.center, "bg_all", true)
			if_set_opacity(arg_16_0.vars.center, "bg_all", 76.5)
		end
	else
		if_set_visible(arg_16_0.vars.center, "btn_item8", false)
		if_set_visible(arg_16_0.vars.center, "bg_art", true)
		
		if #UnitEquip:GetItems(arg_16_1, EQUIP:getEquipPositionByIndex(7), var_16_0) <= 0 then
			if_set_opacity(arg_16_0.vars.center, "bg_art", 76.5)
		else
			if_set_opacity(arg_16_0.vars.center, "bg_art", 255)
		end
	end
end

function UnitDetailEquip.updateExclusiveEquipAlert(arg_17_0, arg_17_1)
	if not arg_17_0:isVisible() or not get_cocos_refid(arg_17_0.vars.center) then
		return 
	end
	
	arg_17_1 = arg_17_1 or arg_17_0.vars.unit
	
	if not arg_17_1 then
		return 
	end
	
	local var_17_0 = SAVE:getKeep(NOTI_UNIT_EXCLUSIVE_EQUIP .. arg_17_1:getUID())
	
	if_set_visible(arg_17_0.vars.center:getChildByName("btn_item8"), "alert_private", arg_17_0:isHaveExclusiveEquip(arg_17_1) and arg_17_1:exclusive_noti() and not arg_17_1:getEquipByIndex(8) and not var_17_0)
end

function UnitDetailEquip.isHaveExclusiveEquip(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1 or arg_18_0.vars.unit
	
	if not var_18_0 then
		return false
	end
	
	local var_18_1 = UnitExclusiveEquip:GetItems(var_18_0, "exclusive", nil, true)
	local var_18_2 = 0
	
	for iter_18_0, iter_18_1 in pairs(var_18_1 or {}) do
		if iter_18_1.db.exclusive_unit == var_18_0.db.code then
			var_18_2 = var_18_2 + 1
		end
	end
	
	return var_18_2 > 0
end

function UnitDetailEquip.onTouchUp(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.menu_wnd) or table.empty(arg_19_0.vars.equip_btns) then
		return 
	end
	
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = checkUIPick(arg_19_0.vars.equip_btns, arg_19_1.x, arg_19_1.y)
	
	if var_19_0 then
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.TUTORIAL_EQUIP
		}, function()
			arg_19_0:openEquipDialog(var_19_0)
		end)
	end
end

function UnitDetailEquip.openEquipDialog(arg_21_0, arg_21_1)
	if not arg_21_0:isVisible() or not arg_21_0.vars.unit then
		return 
	end
	
	if TutorialGuide:isBlockOpenEquipDialog(arg_21_1) then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.unit:getEquipByIndex(arg_21_1)
	
	if not arg_21_0.vars.unit:isOrganizable() then
		balloon_message_with_sound("cant_equips")
		
		return 
	end
	
	if arg_21_1 == 8 then
		local var_21_1 = UnlockSystem:isUnlockSystem(UNLOCK_ID.TRIAL_HALL) or Account:isHaveExclusive()
		local var_21_2 = arg_21_0.vars.unit:getZodiacGrade() >= 5
		local var_21_3 = GrowthBoost:isRegisteredUnit(arg_21_0.vars.unit)
		
		if var_21_3 and to_n(var_21_3.zodiac) >= 5 then
			var_21_2 = true
		end
		
		if not var_21_2 and var_21_1 then
			Dialog:msgBox(T("system_118_equip_open"))
			
			return 
		elseif not var_21_1 then
			Dialog:msgBox(T("system_118_equip_msg"))
			
			return 
		end
		
		if not Account:canUseExclusive() then
			balloon_message_with_sound("ui_exclusive_open")
			
			return 
		elseif not arg_21_0.vars.unit:isExclusiveEquip_exist() or not arg_21_0.vars.unit:canEquip_Exclusive() then
			balloon_message_with_sound("cannot_equip_exclusive_de")
			
			return 
		end
		
		local var_21_4 = arg_21_0.vars.unit:isExclusiveEquip_exist()
		
		if SAVE:getKeep(NOTI_UNIT_EXCLUSIVE_EQUIP .. arg_21_0.vars.unit.inst.uid) ~= var_21_4 then
			SAVE:setKeep(NOTI_UNIT_EXCLUSIVE_EQUIP .. arg_21_0.vars.unit.inst.uid, true)
		end
	end
	
	if arg_21_1 ~= 8 and #UnitEquip:GetItems(arg_21_0.vars.unit, EQUIP:getEquipPositionByIndex(arg_21_1), {
		ignore_stone = true
	}) < 1 and not arg_21_0.vars.unit:getEquipByIndex(arg_21_1) then
		balloon_message_with_sound("no_equips")
		
		return 
	end
	
	if var_21_0 then
		InventoryPopupDetail:Open(var_21_0)
	elseif arg_21_1 == 8 then
		UnitExclusiveEquip:OpenPopup(arg_21_0.vars.unit, arg_21_1)
	else
		UnitEquip:OpenPopup(arg_21_0.vars.unit, arg_21_1)
	end
	
	SoundEngine:play("event:/ui/ok")
end

function UnitDetailEquip.onUnEquip(arg_22_0)
	if not arg_22_0:isVisible() or not arg_22_0.vars.unit then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.unit
	local var_22_1 = {}
	
	for iter_22_0, iter_22_1 in pairs(var_22_0.equips or {}) do
		if not iter_22_1:isExclusive() and not iter_22_1:isArtifact() then
			table.insert(var_22_1, iter_22_1)
		end
	end
	
	if table.empty(var_22_1) then
		balloon_message_with_sound("msg_unequip_all_no_equip")
		
		return 
	end
	
	local function var_22_2()
		if var_22_1 and table.count(var_22_1) > 0 then
			local var_23_0 = {
				unequip = {},
				equip = {},
				unequip = {}
			}
			
			var_23_0.unequip[tostring(var_22_0:getUID())] = {}
			
			for iter_23_0, iter_23_1 in pairs(var_22_1) do
				table.insert(var_23_0.unequip[tostring(var_22_0:getUID())], iter_23_1.id)
			end
			
			query("puton_equip_mass", {
				caller = "unit_detail_equip",
				putons = json.encode(var_23_0)
			})
		end
	end
	
	local var_22_3 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT)
	local var_22_4 = 0
	
	if not var_22_3 then
		for iter_22_2, iter_22_3 in pairs(var_22_1) do
			local var_22_5 = iter_22_3:getUnequipCost()
			
			if var_22_5 then
				var_22_4 = var_22_4 + var_22_5
			end
		end
	end
	
	Dialog:msgBox(T("equip_undress_desc", {
		cost = var_22_4
	}), {
		token = "to_gold",
		yesno = true,
		title = T("equip_undress_title"),
		cost = var_22_4,
		handler = var_22_2
	})
end

function UnitDetailEquip.resUnitUnEquip(arg_24_0, arg_24_1)
	if not arg_24_0:isVisible() or not arg_24_0.vars.unit then
		return 
	end
	
	if arg_24_1 and arg_24_1.res == "ok" then
		SoundEngine:play("event:/ui/equip_off")
		Account:updateCurrencies(arg_24_1)
		
		for iter_24_0, iter_24_1 in pairs(arg_24_1.putons.unequip) do
			local var_24_0 = Account:getUnit(tonumber(iter_24_0))
			
			if var_24_0 and arg_24_0.vars.unit:getUID() == tonumber(iter_24_0) then
				for iter_24_2, iter_24_3 in pairs(iter_24_1) do
					local var_24_1 = Account:getEquip(tonumber(iter_24_3))
					
					if var_24_1 ~= nil then
						var_24_0:removeEquip(var_24_1)
					end
				end
			end
		end
		
		arg_24_0:updateUnitInfo(arg_24_0.vars.unit)
	end
end

function UnitDetailEquip.getWeaponEquipControl(arg_25_0)
	if not arg_25_0.vars or table.empty(arg_25_0.vars.equip_btns) then
		return 
	end
	
	return arg_25_0.vars.equip_btns[1]
end

function UnitDetailEquip.updateUnitDevoteInfo(arg_26_0, arg_26_1)
	if not arg_26_0:isVisible() or not arg_26_0.vars.unit then
		return 
	end
	
	arg_26_1 = arg_26_1 or arg_26_0.vars.unit
	
	if not arg_26_1 then
		return 
	end
	
	if not arg_26_0.vars.n_dedi then
		arg_26_0.vars.n_dedi = arg_26_0.vars.menu_wnd:getChildByName("n_dedi")
	end
	
	UIUtil:setDevoteDetail_new(arg_26_0.vars.n_dedi, arg_26_1, {
		view_next_level = true
	})
	
	if arg_26_1:isGrowthBoostRegistered() then
		local var_26_0 = arg_26_1:clone()
		
		GrowthBoost:apply(var_26_0)
		
		arg_26_1 = var_26_0
	end
	
	local var_26_1 = arg_26_1:getPoint() or 0
	
	arg_26_1:calc()
	
	local var_26_2 = arg_26_1:getPoint() or 0
	
	UIUtil:setUnitAllInfo(arg_26_0.vars.menu_wnd, arg_26_1)
	
	local var_26_3 = arg_26_0.vars.menu_wnd:getChildByName("txt_stat00")
	
	if get_cocos_refid(var_26_3) and var_26_1 ~= var_26_2 then
		UIAction:Add(INC_NUMBER(500, var_26_2, nil, var_26_1), var_26_3, "point_inc")
	end
end
