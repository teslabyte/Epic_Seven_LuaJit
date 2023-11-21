UnitUpgrade = UnitUpgrade or {}

function MsgHandler.enhance_unit(arg_1_0)
	UnitUpgrade:doUpgrade(arg_1_0)
end

function HANDLER.hero_up_dedication(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_ok" then
		UnitUpgrade:hideDedicationPopup()
	end
end

function HANDLER.dlg_zodiac_reward_potential(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ok" then
		UnitUpgrade:hideAwakeSkillPopup()
	end
end

function HANDLER.unit_upgrade(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_up" then
		UnitUpgrade:reqUpgrade()
		TutorialGuide:procGuide("ras_memorization")
		TutorialGuide:procGuide("mer_memorization")
		
		return 
	end
	
	if string.starts(arg_4_1, "btn_remove") then
		UnitUpgrade:removeItemByIndex(tonumber(string.sub(arg_4_1, -1, -1)))
		vibrate(VIBRATION_TYPE.Select)
		
		return 
	end
	
	if arg_4_1 == "btn_dedi2" then
		DevoteTooltip:showDevoteDetail(UnitUpgrade.vars.unit, UnitUpgrade.vars.wnd)
		
		return 
	end
	
	if arg_4_1 == "btn_slot" then
		UnitUpgrade:onBtnFragmentSlot(arg_4_0)
		
		return 
	end
	
	if arg_4_1 == "btn_swap" then
		UIUtil:updateToggleUI(arg_4_0:getChildByName("Slider_btn"), UnitUpgrade:toggleUpgradeMode())
		
		return 
	end
	
	if arg_4_1 == "btn_material" then
		UnitUpgrade:onBtnListFragment(arg_4_0)
		TutorialGuide:procGuide("ras_memorization")
		TutorialGuide:procGuide("mer_memorization")
		
		return 
	end
end

function UnitUpgrade.getSlotUnitNums(arg_5_0)
	return #(arg_5_0.vars.slot_units or {})
end

function UnitUpgrade.onEnter(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars = {}
	arg_6_0.vars.start_unit = arg_6_2.unit
	arg_6_0.vars.slot_units = {}
	arg_6_0.vars.effects = {}
	arg_6_0.vars.controls = {}
	arg_6_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	arg_6_0.vars.wnd = load_dlg("unit_upgrade", true, "wnd")
	arg_6_0.vars.upgrade_mode = "unit"
	arg_6_0.vars.n_hero = arg_6_0.vars.wnd:getChildByName("n_hero")
	arg_6_0.vars.n_hero_slot = arg_6_0.vars.wnd:getChildByName("n_slots")
	arg_6_0.vars.n_fragment = arg_6_0.vars.wnd:getChildByName("n_material")
	arg_6_0.vars.n_fragment_slot = arg_6_0.vars.n_fragment:getChildByName("n_material_scroll_view")
	
	arg_6_0:playBgEffect()
	TopBarNew:setDisableTopRight()
	arg_6_0:clipUnitList(true)
	arg_6_0.vars.wnd:setLocalZOrder(1)
	UnitMain.vars.base_wnd:addChild(arg_6_0.vars.wnd)
	UIAction:Add(SEQ(COLOR(0, 187, 0, 200), FADE_IN(200)), UnitMain.vars.base_wnd:getChildByName("TOP"), "block")
	arg_6_0.vars.wnd:getChildByName("n_add_exp"):setVisible(false)
	arg_6_0:onSelectTargetUnit(arg_6_0.vars.start_unit)
	arg_6_0:updateHeroBelt()
	arg_6_0:updateFragmentSlotUI()
	arg_6_0:loadFragmentListView()
	
	local var_6_0 = arg_6_0:toggleUpgradeMode(arg_6_0:isHaveUpgradableFragments() and "fragment" or "unit")
	local var_6_1 = arg_6_0.vars.wnd:getChildByName("btn_swap")
	
	if get_cocos_refid(var_6_1) then
		UIUtil:initSliderToggle(var_6_1, function()
			return arg_6_0:toggleUpgradeMode()
		end, var_6_0)
		
		arg_6_0.vars.btn_swap = var_6_1
		arg_6_0.vars.btn_slider = var_6_1:getChildByName("Slider_btn")
	end
	
	arg_6_0:updateFragmentToggleRedDot()
	TopBarNew:checkhelpbuttonID("growth_3_1")
	SoundEngine:play("event:/ui/unit_upgrade/enter")
	arg_6_0:ifStartTutorial()
end

function UnitUpgrade.ifStartTutorial(arg_8_0)
	local var_8_0 = arg_8_0.vars.start_unit
	
	if not var_8_0 then
		return 
	end
	
	if not var_8_0.db then
		return 
	end
	
	if var_8_0.db.code == "c1001" then
		TutorialGuide:ifStartGuide("ras_memorization")
	elseif var_8_0.db.code == "c1005" then
		TutorialGuide:ifStartGuide("mer_memorization")
	end
	
	arg_8_0:setTouchEnabledSliderBtn(not TutorialGuide:isPlayingTutorial())
end

function UnitUpgrade.setTouchEnabledSliderBtn(arg_9_0, arg_9_1)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_9_0.vars.btn_swap) or not get_cocos_refid(arg_9_0.vars.btn_slider) then
		return 
	end
	
	arg_9_0.vars.btn_swap:setTouchEnabled(arg_9_1)
	arg_9_0.vars.btn_slider:setTouchEnabled(arg_9_1)
end

function UnitUpgrade.stopDevotionLooptEffect(arg_10_0)
	if not arg_10_0.vars.devotion_loop_eff then
		return 
	end
	
	arg_10_0.vars.devotion_loop_eff:removeFromParent()
	
	arg_10_0.vars.devotion_loop_eff = nil
end

function UnitUpgrade.playDevotionLoopEffect(arg_11_0)
	arg_11_0:stopDevotionLooptEffect()
	
	local var_11_0 = arg_11_0.vars.wnd:getChildByName("n_material_slot")
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	local var_11_1 = var_11_0:getChildByName("btn_slot")
	
	if not get_cocos_refid(var_11_1) then
		return 
	end
	
	arg_11_0.vars.devotion_loop_eff = EffectManager:Play({
		pivot_x = 70,
		fn = "eff_ui_devotion_loop.cfx",
		pivot_y = 70,
		pivot_z = 0,
		scale = 1,
		layer = var_11_1
	})
end

function UnitUpgrade.playSelectEffect(arg_12_0)
	local var_12_0 = arg_12_0.vars.wnd:getChildByName("n_material_slot")
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	local var_12_1 = var_12_0:getChildByName("btn_slot")
	
	if not get_cocos_refid(var_12_1) then
		return 
	end
	
	EffectManager:Play({
		pivot_x = 70,
		fn = "ui_unit_level_up_penguin.cfx",
		pivot_y = 70,
		pivot_z = 0,
		scale = 1.2,
		layer = var_12_1
	})
end

function UnitUpgrade.showMemoryEffect(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_1 then
		return 
	end
	
	local var_13_0 = arg_13_1:getChildByName("list_tag_memory")
	
	if arg_13_2 then
		if not var_13_0 then
			var_13_0 = CACHE:getEffect("list_tag_memory")
			
			var_13_0:setAnimation(0, arg_13_3)
			var_13_0:setPosition(170, 10)
			arg_13_1:addChild(var_13_0)
		end
	elseif var_13_0 then
		arg_13_1:removeChild(var_13_0)
	end
end

function UnitUpgrade.showExpEffect(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_1 then
		return 
	end
	
	local var_14_0 = arg_14_1:getChildByName("list_tag_exp")
	
	if arg_14_2 then
		if not var_14_0 then
			local var_14_1 = CACHE:getEffect("list_tag_exp")
			
			if arg_14_3 == "slot" then
				var_14_1:setScale(1.3)
			end
			
			var_14_1:setAnimation(0, arg_14_3)
			var_14_1:setPosition(170, 0)
			arg_14_1:addChild(var_14_1)
		end
	elseif var_14_0 then
		arg_14_1:removeChild(var_14_0)
	end
end

function UnitUpgrade.clipUnitList(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not arg_15_0.vars.hero_belt then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.hero_belt:getWindow()
	local var_15_1
	local var_15_2
	local var_15_3
	
	if arg_15_1 then
		var_15_1 = arg_15_0.vars.wnd:getChildByName("n_herolist")
		var_15_2 = arg_15_0.vars.wnd:getChildByName("n_sorting")
		var_15_3 = arg_15_0.vars.wnd:getChildByName("add_inven")
	else
		var_15_1 = UnitMain.vars.base_wnd
		var_15_2 = var_15_0:getChildByName("n_sorting")
		var_15_3 = var_15_0:getChildByName("add_inven")
	end
	
	var_15_0:ejectFromParent()
	var_15_1:addChild(var_15_0)
	arg_15_0.vars.hero_belt:changeSorterParent(var_15_2, true)
	arg_15_0.vars.hero_belt:changeCountParent(var_15_3)
	arg_15_0.vars.hero_belt:updateHeroCount()
end

function UnitUpgrade.toggleUpgradeMode(arg_16_0, arg_16_1)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if arg_16_1 == "unit" then
		arg_16_0.vars.is_unit_mode = true
	elseif arg_16_1 == "fragment" then
		arg_16_0.vars.is_unit_mode = false
	else
		arg_16_0.vars.is_unit_mode = not arg_16_0.vars.is_unit_mode
	end
	
	arg_16_0:updateUpgradeModeUI()
	
	return not arg_16_0.vars.is_unit_mode
end

function UnitUpgrade.updateUpgradeModeUI(arg_17_0)
	UnitMain:showUnitList(arg_17_0.vars.is_unit_mode)
	if_set_visible(arg_17_0.vars.wnd, "n_hero", arg_17_0.vars.is_unit_mode)
	if_set_visible(arg_17_0.vars.wnd, "n_slots", arg_17_0.vars.is_unit_mode)
	if_set_visible(arg_17_0.vars.wnd, "n_material", not arg_17_0.vars.is_unit_mode)
	if_set_visible(arg_17_0.vars.wnd, "n_material_slot", not arg_17_0.vars.is_unit_mode)
	
	if arg_17_0.vars.is_unit_mode then
		arg_17_0:removeFragmentSlot()
	else
		arg_17_0:removeAllItems(true, false)
	end
end

function UnitUpgrade.isVisible(arg_18_0)
	return arg_18_0.vars and arg_18_0.vars.wnd and get_cocos_refid(arg_18_0.vars.wnd)
end

function UnitUpgrade.onSelectTargetUnit(arg_19_0, arg_19_1)
	if arg_19_0.vars.unit then
		arg_19_0:showUpgradePanels(false)
		UnitMain:leavePortrait("right")
		UIAction:Remove("team_upgrade.blink")
		arg_19_0.vars.hero_belt:revertPoppedItem()
		UIAction:Add(LOG(MOVE_TO(180, -160)), arg_19_0.vars.eff_bg, "block")
		
		arg_19_0.vars.unit = nil
	else
		arg_19_0.vars.unit = arg_19_1
		
		if arg_19_1 then
			UnitMain:changePortrait(arg_19_1)
			arg_19_0:showUpgradePanels(true)
			arg_19_0:updateBaseUnitInfo()
			arg_19_0:updateUpgradeInfo()
			UIAction:Add(LOG(MOVE_TO(180, 0)), arg_19_0.vars.eff_bg, "block")
		else
			if_set_visible(arg_19_0.vars.wnd, "LEFT", false)
			if_set_visible(arg_19_0.vars.wnd, "RIGHT", false)
			arg_19_0.vars.eff_bg:setPositionX(-160)
		end
		
		arg_19_0:updateHeroBelt()
	end
	
	if_set_visible(arg_19_0.vars.wnd, "n_select_target_unit", arg_19_0.vars.unit == nil)
end

function UnitUpgrade.updateHeroBelt(arg_20_0)
	arg_20_0.vars.hero_belt:resetDataUseFilter(Account.units, "Enhance", arg_20_0.vars.unit)
end

function UnitUpgrade.updateBaseUnitInfo(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0.vars then
		return 
	end
	
	for iter_21_0 = 1, 6 do
		if_set_visible(arg_21_2 or arg_21_0.vars.wnd, "slot" .. iter_21_0, iter_21_0 <= arg_21_0:getMaxResCount(arg_21_1))
	end
	
	UIUtil:setUnitAllInfo(arg_21_2 or arg_21_0.vars.wnd, arg_21_1 or arg_21_0.vars.unit, {
		base = true
	})
end

function UnitUpgrade.showUpgradePanels(arg_22_0, arg_22_1)
	if arg_22_1 then
		if_set_visible(arg_22_0.vars.wnd, "LEFT", true)
		if_set_visible(arg_22_0.vars.wnd, "CENTER", true)
		if_set_visible(arg_22_0.vars.wnd, "RIGHT", true)
		if_set_visible(arg_22_0.vars.wnd, "grow", true)
		UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_22_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_IN_Y(200, 1200)), arg_22_0.vars.wnd:getChildByName("CENTER"), "block")
		arg_22_0.vars.wnd:getChildByName("LEFT"):setOpacity(0)
		arg_22_0.vars.wnd:getChildByName("CENTER"):setOpacity(0)
	else
		if_set_visible(arg_22_0.vars.wnd, "RIGHT", false)
		if_set_visible(arg_22_0.vars.wnd, "grow", false)
		UIAction:Add(SEQ(SLIDE_OUT(200, -600)), arg_22_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_22_0.vars.wnd:getChildByName("CENTER"), "block")
	end
end

function UnitUpgrade.isCanLeave(arg_23_0)
	if not arg_23_0.vars then
		return false
	end
	
	if get_cocos_refid(arg_23_0.vars.popup_upgrade) then
		return false
	end
	
	return true
end

function UnitUpgrade.onLeave(arg_24_0, arg_24_1)
	arg_24_0:clipUnitList(false)
	arg_24_0:showUpgradePanels(false)
	UIAction:Add(FADE_OUT(200), UnitMain.vars.base_wnd:getChildByName("TOP"), "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), arg_24_0.vars.wnd, "block")
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_24_0.vars.eff_bg, "block")
	arg_24_0.vars.hero_belt:revertPoppedItem()
	
	if arg_24_1 then
		arg_24_0.vars.hero_belt:resetDataUseFilter(Account.units, arg_24_1)
	end
	
	if arg_24_1 then
		if arg_24_0.vars.unit then
			UnitDetail:updateUnitInfo(arg_24_0.vars.unit)
		end
		
		if arg_24_1 ~= "Detail" and arg_24_1 ~= "Skill" then
			UnitMain:leavePortrait(nil, arg_24_1 ~= "Main")
		end
	end
	
	if not UnitMain:isDisableTopRight() then
		TopBarNew:setEnableTopRight()
	end
	
	arg_24_0.vars.popup_upgrade = nil
end

function UnitUpgrade.onPushBackButton(arg_25_0, arg_25_1)
	if arg_25_0.vars.start_unit then
		UnitMain:setMode("Detail", {
			set_start_mode = true,
			unit = arg_25_0.vars.unit,
			select_next_promotable_unit = arg_25_1
		})
	else
		arg_25_0:onSelectTargetUnit()
	end
end

function UnitUpgrade.getMaxResCount(arg_26_0, arg_26_1)
	return 6
end

function UnitUpgrade.onSelectUnit(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0.vars.unit then
		arg_27_0:onSelectTargetUnit(arg_27_1)
		
		return 
	end
	
	if arg_27_0:getSlotUnitNums() >= arg_27_0:getMaxResCount() then
		balloon_message_with_sound("cant_add")
		
		return 
	end
	
	local var_27_0 = arg_27_1:getUsableCodeList(arg_27_0.vars.unit)
	
	if var_27_0 then
		Dialog:msgUnitLock(var_27_0)
		
		return 
	end
	
	if arg_27_1 == arg_27_0.vars.unit then
		return 
	end
	
	if arg_27_1:isDevotionUnit() and not arg_27_0.vars.unit:isDevotionUpgradable(arg_27_1) then
		balloon_message_with_sound("cant_unit_devotion")
		
		return 
	end
	
	if arg_27_1:isMoonlightDestinyUnit() then
		balloon_message_with_sound("character_mc_hero_limit")
		
		return 
	end
	
	if arg_27_0.vars.unit:isMoonlightDestinyUnit() and arg_27_0.vars.unit:isDevotionUpgradable(arg_27_1) then
		balloon_message_with_sound(arg_27_1:isDevotionUnit() and "character_mc_hero_limit3" or "character_mc_hero_limit2")
		
		return 
	end
	
	if arg_27_0.vars.unit:isDevotionUpgradable(arg_27_1, true) then
		local var_27_1 = arg_27_0.vars.unit:getDevoteCountFromUnits(arg_27_0.vars.slot_units)
		
		if arg_27_0.vars.unit:isMaxDevoteLevel(var_27_1) then
			balloon_message_with_sound("ui_devotion_no_more_grade")
			
			return 
		end
		
		if arg_27_1:isMaxDevoteLevel() then
			Dialog:msgBox(T("memory_inscription_no_more_achieve"), {})
		end
	end
	
	if arg_27_1:isLimitedUnit() and not arg_27_0.vars.unit:isSameGroup(arg_27_1) then
		balloon_message_with_sound("group_mismatch")
		
		return 
	end
	
	local var_27_2, var_27_3 = arg_27_0:getEnhanceInfo()
	
	if not arg_27_0.vars.unit:isMaxLevel() and var_27_2:isMaxLevel() and not arg_27_0.vars.unit:isDevotionUpgradable(arg_27_1) then
		balloon_message_with_sound("max_level")
		
		return 
	end
	
	if arg_27_1:isRecallExpUnit() then
		for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.slot_units) do
			if not iter_27_1:isRecallExpUnit() then
				balloon_message_with_sound("cant_unit_upgrade_recallexpup_with_others")
				
				return 
			end
		end
	else
		for iter_27_2, iter_27_3 in pairs(arg_27_0.vars.slot_units) do
			if iter_27_3:isRecallExpUnit() then
				balloon_message_with_sound("cant_unit_upgrade_recallexpup_with_others")
				
				return 
			end
		end
	end
	
	if arg_27_0.vars.unit:isDevotionUpgradable(arg_27_1) and arg_27_1:getGrade() > arg_27_0.vars.unit:getGrade() then
		balloon_message_with_sound("upgrade_memorise_lock")
		
		return 
	end
	
	arg_27_0:addUnitRes(arg_27_1)
	SoundEngine:play("event:/ui/upgrade/slot_in")
end

function UnitUpgrade.removeItemByIndex(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.vars.slot_units[arg_28_1]
	
	if not var_28_0 then
		return 
	end
	
	arg_28_0:removeUnitRes(var_28_0, true)
	SoundEngine:play("event:/ui/upgrade/slot_out")
end

function UnitUpgrade.updateDevoteUI(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0.vars then
		return 
	end
	
	if not arg_29_2 then
		return 
	end
	
	if not get_cocos_refid(arg_29_1) then
		return 
	end
	
	local var_29_0, var_29_1 = arg_29_2:getDevoteSkill()
	local var_29_2 = (var_29_1 or -1) >= 0
	
	if_set_visible(arg_29_1, nil, var_29_2)
	
	if not var_29_2 then
		return 
	end
	
	UIUtil:setDevoteDetail_new(arg_29_1, arg_29_2)
	
	local var_29_3, var_29_4 = arg_29_2:getDevoteGrade()
	local var_29_5 = getStatName(var_29_0) .. " + " .. UIUtil:toVarStrEx(var_29_1, var_29_0, 1)
	
	if_set(arg_29_1, "t_dedi", var_29_5)
	if_set_color(arg_29_1, "t_dedi", var_29_1 == 0 and cc.c3b(255, 255, 255) or arg_29_2:getDevoteColor(var_29_3))
	if_set_text_color(arg_29_1, "t_dedi", var_29_1 == 0 and cc.c3b(136, 136, 136) or cc.c3b(255, 255, 255))
	UIUtil:setDevoteDetailFitString(arg_29_1, var_29_3)
end

function UnitUpgrade.updateExpectDevoteUI(arg_30_0, arg_30_1)
	local var_30_0 = getChildByPath(arg_30_0.vars.wnd, "LEFT/name/n_lv")
	
	UIUtil:setLevelDetail(var_30_0, arg_30_1:getLv(), arg_30_1:getMaxLevel())
	arg_30_0:updateUnitDevoteStatUI(arg_30_1)
	arg_30_0:updateDevoteUI(arg_30_0.vars.wnd:getChildByName("n_dedi_stat"), arg_30_0.vars.unit)
	
	local var_30_1 = false
	
	if arg_30_0.vars.is_unit_mode then
		var_30_1 = arg_30_0:getSlotUnitNums() ~= 0
	else
		var_30_1 = arg_30_0.vars.slot_fragment ~= nil
	end
	
	if_set_visible(arg_30_0.vars.wnd, "n_dedi_stat_up", var_30_1)
	
	if var_30_1 then
		arg_30_0:updateDevoteUI(arg_30_0.vars.wnd:getChildByName("n_dedi_stat_up"), arg_30_1)
	end
end

function UnitUpgrade.updateUnitDevoteStatUI(arg_31_0, arg_31_1)
	if not arg_31_0:isVisible() then
		return 
	end
	
	if not arg_31_0.vars.unit then
		return 
	end
	
	if not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	local var_31_0 = getChildByPath(arg_31_0.vars.wnd, "LEFT/detail")
	
	if not get_cocos_refid(var_31_0) then
		return 
	end
	
	UIUtil:setUnitAllInfo(var_31_0, arg_31_1)
	
	local var_31_1 = arg_31_0.vars.unit:clone()
	
	var_31_1:reset()
	var_31_1:calc(true)
	
	local var_31_2 = var_31_1:getPoint() or 0
	
	arg_31_1:reset()
	arg_31_1:calc(true)
	
	local var_31_3 = arg_31_1:getPoint() or 0
	
	if var_31_2 == var_31_3 then
		return 
	end
	
	local var_31_4 = var_31_0:getChildByName("txt_stat00")
	
	if get_cocos_refid(var_31_4) then
		UIAction:Add(INC_NUMBER(500, var_31_3, nil, var_31_2), var_31_4, "point_inc")
	end
end

function UnitUpgrade.updateUpgradeInfo(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	local var_32_0, var_32_1 = arg_32_0:getEnhanceInfo()
	
	if_set(arg_32_0.vars.wnd, "cost", comma_value(var_32_1))
	if_set(arg_32_0.vars.wnd, "txt_enhance", T("ui_memorize_clear_title"))
	arg_32_0:updateExpectDevoteUI(var_32_0)
	
	local var_32_2 = arg_32_0.vars.wnd:getChildByName("n_up_reward")
	local var_32_3
	
	if get_cocos_refid(var_32_2) then
		var_32_3 = {}
		
		for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.slot_units or {}) do
			local var_32_4 = iter_32_1:getGrade()
			local var_32_5, var_32_6 = DB("char_memory_imprint_reward", tostring(var_32_4), {
				"reward_id",
				"value"
			})
			
			if var_32_5 and to_n(var_32_6) > 0 then
				var_32_3[var_32_5] = to_n(var_32_3[var_32_5]) + to_n(var_32_6)
			end
		end
		
		for iter_32_2 = 1, 3 do
			local var_32_7 = var_32_2:getChildByName("icon_up_r" .. iter_32_2)
			local var_32_8 = "ma_elemental_" .. iter_32_2
			
			if var_32_7 then
				UIUtil:getRewardIcon(nil, var_32_8, {
					no_bg = true,
					parent = var_32_7
				})
			end
			
			if_set(var_32_2, "txt_count" .. iter_32_2, to_n(var_32_3[var_32_8]))
		end
	end
end

function UnitUpgrade.removeAllItems(arg_33_0, arg_33_1, arg_33_2)
	if arg_33_1 then
		for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.slot_units) do
			arg_33_0.vars.hero_belt:revertPoppedItem(iter_33_1)
		end
	end
	
	for iter_33_2 = 1, 6 do
		local var_33_0 = arg_33_0.vars.wnd:getChildByName("item" .. iter_33_2)
		
		if var_33_0 then
			var_33_0:setName("")
			
			if arg_33_2 then
				UIAction:Add(SEQ(DELAY(iter_33_2 * 40), SLIDE_OUT(150, -100), REMOVE()), var_33_0)
			else
				var_33_0:removeFromParent()
			end
		end
		
		if get_cocos_refid(arg_33_0.vars.effects[iter_33_2]) then
			arg_33_0.vars.effects[iter_33_2]:removeFromParent()
		end
	end
	
	arg_33_0.vars.slot_units = {}
	arg_33_0.vars.controls = {}
	arg_33_0.vars.effects = {}
	
	arg_33_0:updateUpgradeInfo()
end

function UnitUpgrade.getSceneState(arg_34_0)
	return {
		start_mode = "Detail",
		unit = arg_34_0.vars.unit
	}
end

function UnitUpgrade.checkAlreadyExistUnit(arg_35_0, arg_35_1)
	for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.slot_units) do
		if iter_35_1:getUID() == arg_35_1:getUID() then
			return true
		end
	end
	
	return false
end

function UnitUpgrade.addUnitRes(arg_36_0, arg_36_1)
	if arg_36_1 == arg_36_0.vars.unit then
		return 
	end
	
	if arg_36_0:checkAlreadyExistUnit(arg_36_1) then
		Log.e("USER REQUEST ADD ALREADY EXIST UNIT!")
		
		return 
	end
	
	table.push(arg_36_0.vars.slot_units, arg_36_1)
	arg_36_0.vars.hero_belt:popItem(arg_36_1)
	
	local var_36_0 = arg_36_0:getSlotUnitNums()
	local var_36_1 = arg_36_0.vars.wnd:getChildByName("slot" .. var_36_0)
	local var_36_2 = UIUtil:updateUnitBar("Enhance", arg_36_1, {
		lv = arg_36_1:getLv(),
		max_lv = arg_36_1:getMaxLevel()
	})
	
	var_36_2:setAnchorPoint(0.5, 0.5)
	var_36_2:setScale(var_36_1:getScale())
	var_36_2:setName("item" .. var_36_0)
	
	local var_36_3 = "hero_bg_normal.png"
	local var_36_4 = "hero_up_slotglow_nomal.cfx"
	local var_36_5 = false
	
	if arg_36_0.vars.unit:isDevotionUpgradable(arg_36_1) and not arg_36_0.vars.unit:isPromotionUnit() then
		local var_36_6 = arg_36_0.vars.unit:getDevoteCountFromUnits(arg_36_0.vars.slot_units)
		
		if arg_36_0.vars.unit:getDevoteGrade(arg_36_0.vars.unit:getDevote() + var_36_6 - (to_n(arg_36_1.inst.devote) + 1)) ~= arg_36_0.vars.unit:getDevoteGrade(arg_36_0.vars.unit:getDevote() + var_36_6) then
			var_36_3 = "hero_bg_sametype.png"
			var_36_4 = "hero_up_slotglow_special.cfx"
			var_36_5 = true
			var_36_2.upgradable = true
		end
	elseif arg_36_1.db.type == "xpup" then
		var_36_3 = "hero_bg_selected.png"
	end
	
	arg_36_0:showMemoryEffect(var_36_2, var_36_5, "slot")
	arg_36_0:showExpEffect(var_36_2, arg_36_1.db.type == "xpup", "slot")
	SpriteCache:resetSprite(var_36_2:getChildByName("bg"), "img/" .. var_36_3)
	
	local var_36_7, var_36_8 = var_36_1:getPosition()
	local var_36_9 = cc.Layer:create()
	
	var_36_9:setCascadeOpacityEnabled(true)
	var_36_2:addChild(var_36_9)
	EffectManager:Play({
		scale = 1.35,
		y = 44,
		x = 187,
		fn = var_36_4,
		layer = var_36_9
	})
	
	if arg_36_0.vars.slot_units[var_36_0].db.color ~= arg_36_0.vars.unit.db.color then
		var_36_9:setOpacity(80)
	end
	
	arg_36_0.vars.effects[var_36_0] = var_36_9
	arg_36_0.vars.controls[var_36_0] = var_36_2
	
	arg_36_0.vars.wnd:getChildByName("CENTER"):addChild(var_36_2)
	var_36_2:setPosition(var_36_7 - 6, var_36_8 + 2)
	var_36_2:setOpacity(0)
	Action:Add(SLIDE_IN(150, -800), var_36_2)
	arg_36_0:updateUpgradeInfo()
end

function UnitUpgrade.removeUnitRes(arg_37_0, arg_37_1)
	local var_37_0
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.slot_units) do
		if iter_37_1 == arg_37_1 then
			var_37_0 = iter_37_0
			
			arg_37_0.vars.hero_belt:revertPoppedItem(arg_37_1)
			table.remove(arg_37_0.vars.slot_units, iter_37_0)
			arg_37_0.vars.effects[iter_37_0]:removeFromParent()
			table.remove(arg_37_0.vars.effects, iter_37_0)
			table.remove(arg_37_0.vars.controls, iter_37_0)
			
			break
		end
	end
	
	if var_37_0 then
		local var_37_1 = false
		
		for iter_37_2 = var_37_0, 6 do
			local var_37_2 = arg_37_0.vars.wnd:getChildByName("item" .. iter_37_2)
			
			if not var_37_2 then
				break
			end
			
			if iter_37_2 == var_37_0 then
				var_37_2:setName("")
				UIAction:Add(SEQ(SLIDE_OUT(150, -100), REMOVE()), var_37_2, "block")
				
				var_37_1 = var_37_2.upgradable
			else
				var_37_2:setName("item" .. iter_37_2 - 1)
				
				local var_37_3, var_37_4 = arg_37_0.vars.wnd:getChildByName("slot" .. iter_37_2 - 1):getPosition()
				
				UIAction:Add(RLOG(MOVE_TO(150, var_37_3 - 6, var_37_4 + 2), 1.5), var_37_2, "block")
			end
		end
		
		if var_37_1 then
			for iter_37_3 = 1, 6 do
				local var_37_5 = arg_37_0.vars.wnd:getChildByName("item" .. iter_37_3)
				
				if get_cocos_refid(var_37_5) then
					local var_37_6 = arg_37_0.vars.slot_units[iter_37_3]
					local var_37_7 = false
					
					if not var_37_5.upgradable and arg_37_0.vars.unit:isDevotionUpgradable(var_37_6) then
						var_37_5.upgradable = true
						var_37_7 = true
						
						SpriteCache:resetSprite(var_37_5:getChildByName("bg"), "img/hero_bg_sametype.png")
						
						local var_37_8 = arg_37_0.vars.effects[iter_37_3]
						
						if get_cocos_refid(var_37_8) then
							table.each_reverse(var_37_8:getChildren(), function(arg_38_0, arg_38_1)
								arg_38_1:removeFromParent()
							end)
							EffectManager:Play({
								scale = 1.35,
								fn = "hero_up_slotglow_special.cfx",
								y = 44,
								x = 187,
								layer = var_37_8
							})
							var_37_8:setOpacity(var_37_6.db.color ~= arg_37_0.vars.unit.db.color and 80 or 255)
						end
						
						break
					end
					
					arg_37_0:showMemoryEffect(var_37_5, var_37_7, "slot")
					arg_37_0:showExpEffect(var_37_5, var_37_6.db.type == "xpup", "slot")
				end
			end
		end
	end
	
	arg_37_0:updateUpgradeInfo()
end

function UnitUpgrade.getEnhanceInfo(arg_39_0)
	if not arg_39_0.vars.unit then
		return nil, 0, 0
	end
	
	local var_39_0 = 0
	local var_39_1 = 0
	
	if arg_39_0.vars.is_unit_mode then
		for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.slot_units) do
			var_39_0 = var_39_0 + iter_39_1:getEnhancePrice()
		end
		
		var_39_1 = arg_39_0.vars.unit:getDevoteCountFromUnits(arg_39_0.vars.slot_units)
	elseif arg_39_0.vars.slot_fragment then
		local var_39_2 = GAME_CONTENT_VARIABLE.fragment_enhance_price or 600
		
		var_39_1 = arg_39_0:getFragmentSlotCount() / arg_39_0.vars.slot_fragment.devotion_need_count
		var_39_0 = var_39_2 * var_39_1
	end
	
	local var_39_3 = arg_39_0.vars.unit:clone()
	
	var_39_3.inst.devote = var_39_3.inst.devote + var_39_1
	
	var_39_3:reset()
	var_39_3:calc(true)
	
	arg_39_0.vars.total_price = var_39_0
	
	return var_39_3, var_39_0
end

function UnitUpgrade.checkItemsHaveDiffUID(arg_40_0)
	local var_40_0 = {}
	
	for iter_40_0, iter_40_1 in pairs(arg_40_0.vars.slot_units) do
		if var_40_0[iter_40_1:getUID()] then
			return true
		end
		
		var_40_0[iter_40_1:getUID()] = true
	end
	
	return false
end

function UnitUpgrade.getUpgradeWarningText(arg_41_0)
	for iter_41_0, iter_41_1 in pairs(arg_41_0.vars.slot_units) do
		if iter_41_1:isPromotionUnit() then
			return T("confirm_enhance_promo")
		end
	end
	
	for iter_41_2, iter_41_3 in pairs(arg_41_0.vars.slot_units) do
		if iter_41_3:getGrade() > 2 then
			return T("confirm_high_grade")
		end
	end
	
	return T("confirm_enhance")
end

function UnitUpgrade.reqUpgradeUnitMode(arg_42_0)
	if not arg_42_0.vars then
		return 
	end
	
	if table.empty(arg_42_0.vars.slot_units) then
		balloon_message_with_sound("upgrade_char_select")
		
		return 
	end
	
	if arg_42_0:checkItemsHaveDiffUID() then
		Log.e("checkItemsHaveDiffUID WAS TRUE! USER REQUEST UPGRADE SAME UID UNITS!")
		
		return 
	end
	
	arg_42_0.vars.popup_upgrade = Dialog:msgBox(arg_42_0:getUpgradeWarningText(), {
		yesno = true,
		yes_text = T("ui_msgbox_ok"),
		handler = function()
			arg_42_0.vars.prev_lv = arg_42_0.vars.unit:getLv()
			arg_42_0.vars.prev_grade = arg_42_0.vars.unit:getGrade()
			
			TutorialGuide:procGuide("ras_memorization")
			TutorialGuide:procGuide("mer_memorization")
			arg_42_0:setTouchEnabledSliderBtn(false)
			
			local var_43_0 = {}
			local var_43_1 = {}
			
			for iter_43_0, iter_43_1 in pairs(arg_42_0.vars.slot_units) do
				table.insert(var_43_0, iter_43_1:getUID())
				
				for iter_43_2, iter_43_3 in pairs(iter_43_1.equips) do
					table.push(var_43_1, iter_43_3:getUID())
				end
			end
			
			query("enhance_unit", {
				units = array_to_json(var_43_0),
				equips = array_to_json(var_43_1),
				target = arg_42_0.vars.unit:getUID(),
				curr_point = arg_42_0.vars.unit:getPoint()
			})
		end
	})
end

function UnitUpgrade.reqUpgradeFragmentMode(arg_44_0)
	if not arg_44_0.vars then
		return 
	end
	
	if arg_44_0.vars.slot_fragment == nil then
		balloon_message_with_sound("ui_devotion_material_ok_fail")
		
		return 
	end
	
	arg_44_0.vars.popup_upgrade = Dialog:msgBox(arg_44_0:getUpgradeWarningText(), {
		yesno = true,
		yes_text = T("ui_msgbox_ok"),
		handler = function()
			arg_44_0.vars.prev_lv = arg_44_0.vars.unit:getLv()
			arg_44_0.vars.prev_grade = arg_44_0.vars.unit:getGrade()
			
			TutorialGuide:procGuide("ras_memorization")
			TutorialGuide:procGuide("mer_memorization")
			
			local var_45_0 = {
				{
					arg_44_0.vars.slot_fragment.code,
					arg_44_0:getFragmentSlotCount()
				}
			}
			
			query("enhance_unit", {
				units = array_to_json({}),
				fragments = array_to_json(var_45_0),
				target = arg_44_0.vars.unit:getUID(),
				curr_point = arg_44_0.vars.unit:getPoint()
			})
		end
	})
end

function UnitUpgrade.reqUpgrade(arg_46_0)
	if arg_46_0.vars.is_unit_mode then
		arg_46_0:reqUpgradeUnitMode()
	else
		arg_46_0:reqUpgradeFragmentMode()
	end
end

function UnitUpgrade.doUpgradeUnitMode(arg_47_0, arg_47_1)
	local var_47_0 = 1000
	
	if arg_47_1.items then
		Account:updateProperties(arg_47_1.items)
	end
	
	if arg_47_0.vars.unit:isPromotionEffectSimple() then
		var_47_0 = 450
	end
	
	for iter_47_0, iter_47_1 in pairs(arg_47_0.vars.effects) do
		local var_47_1 = (iter_47_0 - 1) * 125
		local var_47_2 = "hero_up_slot_0" .. iter_47_0
		local var_47_3 = "_nomal.cfx"
		
		if arg_47_0.vars.slot_units[iter_47_0].inst.code == arg_47_0.vars.unit.inst.code then
			var_47_3 = "_special.cfx"
		end
		
		if arg_47_0.vars.unit:isPromotionEffectSimple() then
			var_47_1 = 0
			var_47_2 = "hero_up_slot_opti"
		end
		
		local var_47_4 = var_47_2 .. var_47_3
		
		UIAction:AddSync(SEQ(DELAY(var_47_1), FADE_OUT(80), REMOVE()), arg_47_0.vars.effects[iter_47_0], "block")
		UIAction:AddSync(SEQ(DELAY(var_47_1), FADE_OUT(80), REMOVE()), arg_47_0.vars.controls[iter_47_0], "block")
		
		local var_47_5, var_47_6 = arg_47_0.vars.wnd:getChildByName("slot" .. iter_47_0):getPosition()
		
		EffectManager:Play({
			fn = var_47_4,
			layer = arg_47_0.vars.wnd:getChildByName("CENTER"),
			delay = var_47_1,
			x = var_47_5,
			y = var_47_6
		})
	end
	
	arg_47_0.vars.effects = {}
	arg_47_0.vars.controls = {}
	
	local var_47_7 = arg_47_0:getSlotUnitNums()
	local var_47_8 = 70
	local var_47_9 = 0
	local var_47_10 = NONE()
	local var_47_11 = NONE()
	
	if not arg_47_0.vars.unit:isPromotionEffectSimple() then
		var_47_9 = 600
		var_47_10 = CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_47_0.vars.unit, true)
		var_47_11 = SHAKE_UI(500 + var_47_7 * var_47_8 + var_47_9, 10)
	else
		var_47_10 = CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_47_0.vars.unit)
	end
	
	UIAction:Add(SEQ(DELAY(var_47_0), SPAWN(SEQ(LOG(BLEND(500, "white", 0, 1), 100), DELAY(var_47_7 * var_47_8 + var_47_9), RLOG(BLEND(200, "white", 1, 0), 100), LOG(BLEND(0))), CALL(UnitUpgrade.playBgEffect, arg_47_0), var_47_11, SEQ(LOG(SCALE(500, 0.8, 0.85)), DELAY(var_47_7 * var_47_8 + var_47_9), var_47_10, CALL(SoundEngine.play, SoundEngine, "event:/ui/hero_grow_02_levelup"), CALL(UnitUpgrade.doUpgrade_1, arg_47_0, arg_47_1), RLOG(SCALE(100, 0.8, 0.75)), RLOG(SCALE(100, 0.75, 0.8))))), UnitMain:getPortrait(), "block")
	
	local var_47_12 = arg_47_0.vars.unit:isPromotionEffectSimple() and 0 or 1100 + var_47_7 * 125
	
	UIAction:AddSync(DELAY(var_47_12), arg_47_0, "block")
end

function UnitUpgrade.doUpgradeFragmentMode(arg_48_0, arg_48_1)
	SoundEngine:play("event:/ui/hero_grow_02_levelup")
	
	if arg_48_1.update_fragments and arg_48_1.update_fragments.new_items then
		for iter_48_0, iter_48_1 in pairs(arg_48_1.update_fragments.new_items) do
			Account:setItemCount(iter_48_1.code, to_n(iter_48_1.c))
		end
	end
	
	local var_48_0 = 0
	
	UIAction:Add(SEQ(DELAY(var_48_0), SPAWN(SEQ(LOG(BLEND(500, "white", 0, 1), 100), DELAY(600), RLOG(BLEND(200, "white", 1, 0), 100), LOG(BLEND(0))), CALL(UnitUpgrade.playBgEffect, arg_48_0), SHAKE_UI(1100, 10), SEQ(LOG(SCALE(500, 0.8, 0.85)), DELAY(600), CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_48_0.vars.unit, true), CALL(UnitUpgrade.doUpgrade_1, arg_48_0, arg_48_1), RLOG(SCALE(100, 0.8, 0.75)), RLOG(SCALE(100, 0.75, 0.8))))), UnitMain:getPortrait(), "block")
	UIAction:AddSync(DELAY(var_48_0 + 1100), arg_48_0, "block")
end

function UnitUpgrade.doUpgrade(arg_49_0, arg_49_1)
	if arg_49_0.vars.is_unit_mode then
		arg_49_0:doUpgradeUnitMode(arg_49_1)
	else
		arg_49_0:doUpgradeFragmentMode(arg_49_1)
	end
end

function UnitUpgrade.playBgEffect(arg_50_0)
	if arg_50_0.vars.eff_bg then
		arg_50_0.vars.eff_bg:removeFromParent()
	end
	
	arg_50_0.vars.eff_bg = EffectManager:Play({
		pivot_x = 0,
		fn = "hero_enchant_circle.cfx",
		pivot_y = 0,
		pivot_z = 0,
		scale = 1,
		layer = UnitMain.vars.base_wnd:getChildByName("eff_pos")
	})
end

function UnitUpgrade.playAfterEffect(arg_51_0)
	local var_51_0
	local var_51_1
	local var_51_2
	
	if arg_51_0.vars.skill_lv_before then
		for iter_51_0 = 1, 3 do
			var_51_1 = to_n(arg_51_0.vars.skill_lv_before[iter_51_0])
			var_51_2 = to_n(arg_51_0.vars.skill_lv_after[iter_51_0])
			
			if to_n(var_51_1) ~= to_n(var_51_2) then
				arg_51_0.vars.skill_lv_before[iter_51_0] = var_51_2
				var_51_0 = arg_51_0.vars.unit:getSkillByIndex(iter_51_0)
				
				break
			end
		end
	end
	
	if not var_51_0 then
		if arg_51_0.vars.unit:isMaxLevel() then
			if arg_51_0.vars.unit:getGrade() < 6 and arg_51_0.vars.prev_lv ~= arg_51_0.vars.unit:getLv() then
				if not arg_51_0.vars.unit:isMoonlightDestinyUnit() then
					Dialog:msgBox(T("ui_go_next_promotion"))
				end
			elseif arg_51_0.vars.prev_grade and arg_51_0.vars.prev_grade ~= arg_51_0.vars.unit:getGrade() then
				Dialog:msgBox(T("hero_max_grade"))
			end
		end
		
		return 
	end
	
	local var_51_3 = load_dlg("dlg_zodiac_reward_skill", true, "wnd")
	local var_51_4 = var_51_3:getChildByName("skill_01")
	local var_51_5 = var_51_3:getChildByName("skill_02")
	
	UIUtil:getSkillDetail(arg_51_0.vars.unit, var_51_0, {
		ignore_check = true,
		wnd = var_51_4,
		skill_id = var_51_0,
		skill_lv = var_51_1
	})
	UIUtil:getSkillDetail(arg_51_0.vars.unit, var_51_0, {
		ignore_check = true,
		wnd = var_51_5,
		skill_id = var_51_0,
		skill_lv = var_51_2
	})
	if_set(var_51_3, "txt_title", T("skill_upgrade"))
	Dialog:msgBox({
		fade_in = 500,
		dlg = var_51_3,
		handler = function()
			UnitUpgrade:playAfterEffect()
		end
	})
end

function UnitUpgrade.doUpgrade_1(arg_53_0, arg_53_1)
	vibrate(VIBRATION_TYPE.Success)
	ConditionContentsManager:setIgnoreQuery(true)
	
	local var_53_0 = arg_53_0.vars.unit:getLv()
	local var_53_1 = arg_53_0:getSlotUnitNums()
	
	arg_53_0.vars.skill_lv_before = table.clone(arg_53_0.vars.unit.inst.skill_lv)
	
	UnitUpgradeLogic:UpdateLevelInfo(arg_53_0.vars.unit, arg_53_1.target, var_53_1)
	
	arg_53_0.vars.skill_lv_after = table.clone(arg_53_0.vars.unit.inst.skill_lv)
	
	if arg_53_1.target.d then
		if UnitUpgradeLogic:UpdateDevote(arg_53_0.vars.unit, arg_53_1.target, arg_53_0.vars.slot_units) then
			arg_53_0:showDedicationPopup(arg_53_0.vars.unit, arg_53_1.target.d)
		end
		
		arg_53_0:updateUnitDevoteStatUI(arg_53_0.vars.unit)
	end
	
	if UnitUpgradeLogic:UpdateImprintFocus(arg_53_0.vars.unit, arg_53_1.target) then
		Dialog:msgBox(T("m_stamp_s_unlock_pa"), {
			dont_proc_tutorial = true,
			title = T("m_stamp_self_unlock")
		})
	end
	
	UnitUpgradeLogic:UpdateAccountUnitInfo(arg_53_0.vars.unit, arg_53_1.target, var_53_0)
	UnitUpgradeLogic:UpdateAccountData(arg_53_1, arg_53_0.vars.slot_units)
	arg_53_0.vars.hero_belt:clearPoppedItems()
	arg_53_0:removeAllItems()
	arg_53_0:removeFragmentSlot()
	arg_53_0:updateFragmentToggleRedDot()
	arg_53_0.vars.hero_belt:updateUnit(nil, arg_53_0.vars.unit)
	arg_53_0:updateHeroBelt()
	arg_53_0:playAfterEffect()
	arg_53_0:updateBaseUnitInfo()
	arg_53_0:updateUpgradeInfo()
	arg_53_0:setTouchEnabledSliderBtn(not TutorialGuide:isPlayingTutorial())
	ConditionContentsManager:setIgnoreQuery(false)
	ConditionContentsManager:queryUpdateConditions("f:doUpgrade_1")
	
	if TutorialGuide:isPlayingTutorial("memorization") then
		return 
	end
	
	if arg_53_0.vars.unit:isMaxDevoteLevel() then
		UnitMain:setMode("Detail", {
			set_start_mode = true,
			unit = arg_53_0.vars.unit
		})
	end
end

function UnitUpgrade.showDedicationPopup(arg_54_0, arg_54_1, arg_54_2)
	if not arg_54_0.vars or not arg_54_1 then
		return 
	end
	
	local var_54_0 = load_dlg("hero_up_dedication", nil, "wnd", function()
		UnitUpgrade:hideDedicationPopup()
	end)
	
	SceneManager:getRunningNativeScene():addChild(var_54_0)
	
	local var_54_1 = UnitInfosUtil:isExistUnitProfileUnlock(arg_54_1, "devotion", {
		cur_devote = arg_54_2
	})
	
	if_set_visible(var_54_0, "n_new_profile", var_54_1)
	if_set_visible(var_54_0, "txt_profile", var_54_1)
	UIUtil:setDevoteDetail_new(var_54_0, arg_54_1, {
		target = "n_before"
	})
	UIUtil:setDevoteDetail_new(var_54_0, arg_54_1, {
		target = "n_after",
		devote = arg_54_2
	})
	if_set_arrow(var_54_0)
	
	arg_54_0.vars._dedication_popup = var_54_0
	var_54_0.pre_devote = arg_54_1:getPresentDevote()
	
	TutorialGuide:startGuide("memorization")
end

function UnitUpgrade.hideDedicationPopup(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	local var_56_0 = 0
	
	if get_cocos_refid(arg_56_0.vars._dedication_popup) then
		var_56_0 = arg_56_0.vars._dedication_popup.pre_devote
		
		BackButtonManager:pop({
			dlg = arg_56_0.vars._dedication_popup
		})
		arg_56_0.vars._dedication_popup:removeFromParent()
		
		arg_56_0.vars._dedication_popup = nil
		
		TutorialGuide:procGuide()
	end
	
	if arg_56_0.vars.unit and arg_56_0.vars.unit:isAwakeUnit() and not TutorialGuide:isPlayingTutorial() then
		if table.empty(arg_56_0.vars.unit:getAwakeSkill()) then
			arg_56_0:showAwakeInfoPopup(arg_56_0.vars.unit)
		else
			arg_56_0:showAwakeSkillPopup(arg_56_0.vars.unit, var_56_0)
		end
	end
end

function UnitUpgrade.showAwakeInfoPopup(arg_57_0, arg_57_1)
	local var_57_0 = load_dlg("unlock_system_open", true, "wnd")
	
	if_set(var_57_0, "txt_title", T("ui_devotion_comp_title1"))
	if_set(var_57_0, "infor", T("ui_devotion_comp_desc1", {
		char = arg_57_1 and arg_57_1:getName() or ""
	}))
	if_set_sprite(var_57_0, "icon_storyguide", "img/icon_menu_awake_p.png")
	if_set_visible(var_57_0, "dim_real", false)
	Dialog:msgBox("", {
		dlg = var_57_0
	})
end

function UnitUpgrade.showAwakeSkillPopup(arg_58_0, arg_58_1, arg_58_2)
	if not arg_58_0.vars then
		return 
	end
	
	arg_58_2 = arg_58_2 or 0
	
	local var_58_0, var_58_1 = arg_58_1:getDevoteGrade()
	local var_58_2 = load_dlg("dlg_zodiac_reward_potential", nil, "wnd", function()
		UnitUpgrade:hideAwakeSkillPopup()
	end)
	local var_58_3 = var_58_2:getChildByName("window_frame")
	
	if get_cocos_refid(var_58_3) then
		local var_58_4 = var_58_3:getChildByName("txt_disc")
		local var_58_5 = var_58_3:getChildByName("icon_potential")
		local var_58_6 = var_58_3:getChildByName("txt_potential")
		
		if_set(var_58_4, nil, T("ui_devotion_comp_desc2", {
			grade = var_58_0
		}))
		
		local var_58_7 = var_58_4:getTextBoxSize().height * var_58_4:getScaleY()
		local var_58_8 = var_58_5:getContentSize().height * var_58_5:getScaleY()
		local var_58_9 = var_58_3:getContentSize().height / 2 - var_58_8 / 2 + var_58_7 / 2
		
		var_58_4:setPositionY(var_58_9)
		var_58_5:setPositionY(var_58_9 + 40)
		var_58_6:setPositionY(var_58_9 + 41)
	end
	
	SceneManager:getRunningNativeScene():addChild(var_58_2)
	UIUtil:setAwakeSkillScrollview(var_58_2, arg_58_1, {
		align = "center",
		min = arg_58_2 + 1,
		max = var_58_1
	})
	if_set_arrow(var_58_2)
	
	arg_58_0.vars._awake_popup = var_58_2
end

function UnitUpgrade.hideAwakeSkillPopup(arg_60_0)
	if not arg_60_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_60_0.vars._awake_popup) then
		BackButtonManager:pop({
			dlg = arg_60_0.vars._awake_popup
		})
		arg_60_0.vars._awake_popup:removeFromParent()
		
		arg_60_0.vars._awake_popup = nil
	end
end

function UnitUpgrade.onBtnFragmentSlot(arg_61_0, arg_61_1)
	arg_61_0:removeFragmentSlot()
end

function UnitUpgrade.onBtnListFragment(arg_62_0, arg_62_1)
	if not get_cocos_refid(arg_62_1) then
		return 
	end
	
	arg_62_0:addFragmentSlot(arg_62_1.fragment)
end

function UnitUpgrade.getFragmentCountString(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	arg_63_1 = arg_63_1 or 0
	arg_63_2 = arg_63_2 or 0
	arg_63_3 = arg_63_3 or 0
	
	if arg_63_2 == 0 then
		return (arg_63_1 < arg_63_3 and "<#f83535>" or "<#ffffff>") .. tostring(arg_63_1) .. "</>/" .. tostring(arg_63_3)
	end
	
	return "<#6bc11b>" .. tostring(arg_63_1) .. "(-" .. tostring(arg_63_2) .. ")</>/" .. tostring(arg_63_3)
end

function UnitUpgrade.isEnableFragmentListItem(arg_64_0, arg_64_1)
	if not arg_64_1 then
		return false
	end
	
	if not arg_64_0.vars.unit then
		return false
	end
	
	if not arg_64_0.vars.unit:isDevotionUpgradableFragment(arg_64_1) then
		return false
	end
	
	return arg_64_0:isCanFragmentDevotion(arg_64_1)
end

function UnitUpgrade.updateFragmentSlotUI(arg_65_0)
	if not get_cocos_refid(arg_65_0.vars.wnd) then
		return 
	end
	
	local var_65_0 = arg_65_0.vars.wnd:getChildByName("n_material_slot")
	
	if not get_cocos_refid(var_65_0) then
		return 
	end
	
	local var_65_1 = arg_65_0.vars.slot_fragment ~= nil
	
	if_set_visible(var_65_0, "face_s", var_65_1)
	if_set_visible(var_65_0, "t_material", var_65_1)
	if_set_visible(var_65_0, "cover_piece", var_65_1)
	if_set_visible(var_65_0, "n_info", not var_65_1)
	
	if var_65_1 then
		local var_65_2 = arg_65_0.vars.slot_fragment.ma_type2 == "char"
		
		if_set_visible(var_65_0, "cover_piece", var_65_1 and var_65_2)
		
		if var_65_2 then
			local var_65_3 = arg_65_0.vars.unit:isMoonlight() and "img/memory_imprint_slot_moonlight.png" or "img/memory_imprint_slot_common.png"
			
			if_set_sprite(var_65_0, "cover_piece", var_65_3)
		end
		
		local var_65_4 = T(arg_65_0.vars.slot_fragment.name) .. " " .. arg_65_0:getFragmentSlotCount() .. "/" .. arg_65_0.vars.slot_fragment.devotion_need_count
		
		if_set(var_65_0, "t_material", var_65_4)
		
		local var_65_5 = var_65_2 and arg_65_0.vars.slot_fragment.devotion_target or arg_65_0.vars.slot_fragment.code
		local var_65_6 = var_65_2 and "face/" .. var_65_5 .. "_s.png" or "item/icon_" .. var_65_5 .. ".png"
		
		if_set_sprite(var_65_0, "face_s", var_65_6)
	end
end

function UnitUpgrade.isInFragmentSlot(arg_66_0, arg_66_1)
	if not arg_66_1 then
		return false
	end
	
	if not arg_66_0.vars.slot_fragment then
		return false
	end
	
	return arg_66_0.vars.slot_fragment.code == arg_66_1.code
end

function UnitUpgrade.getFragmentSlotCount(arg_67_0)
	if not arg_67_0.vars.slot_fragment then
		return 0
	end
	
	return arg_67_0.vars.slot_fragment.count or 0
end

function UnitUpgrade.addFragmentSlotCount(arg_68_0, arg_68_1)
	if not arg_68_0.vars.slot_fragment then
		return false
	end
	
	if not arg_68_0:isCanFragmentDevotion(arg_68_0.vars.slot_fragment) then
		return false
	end
	
	local var_68_0 = arg_68_0:getFragmentSlotCount() / arg_68_0.vars.slot_fragment.devotion_need_count
	
	if arg_68_0.vars.unit:isMaxDevoteLevel(var_68_0) then
		balloon_message_with_sound("ui_devotion_no_more_grade")
		
		return 
	end
	
	arg_68_0.vars.slot_fragment.count = arg_68_0:getFragmentSlotCount() + arg_68_1
	
	return true
end

function UnitUpgrade.setFragmentSlot(arg_69_0, arg_69_1)
	if not arg_69_1 then
		arg_69_0.vars.slot_fragment = nil
		
		return 
	end
	
	arg_69_0.vars.slot_fragment = arg_69_1
	arg_69_0.vars.slot_fragment.count = 0
	
	arg_69_0:addFragmentSlotCount(arg_69_1.devotion_need_count)
end

function UnitUpgrade.addFragmentSlot(arg_70_0, arg_70_1)
	if not arg_70_1 then
		return 
	end
	
	if not arg_70_0.vars.unit then
		return 
	end
	
	if not arg_70_0:isEnableFragmentListItem(arg_70_1) then
		local var_70_0 = (arg_70_0:isInFragmentSlot(arg_70_1) and arg_70_0:getFragmentSlotCount() or 0) + arg_70_1.devotion_need_count - Account:getItemCount(arg_70_1.code)
		
		balloon_message_with_sound(T("ui_devotion_lack", {
			count = var_70_0
		}))
	end
	
	if not arg_70_0.vars.unit:isDevotionUpgradableFragment(arg_70_1) then
		return 
	end
	
	local function var_70_1()
		if not get_cocos_refid(arg_70_1.ui) then
			return 
		end
		
		local var_71_0 = Account:getItemCount(arg_70_1.code) - arg_70_0:getFragmentSlotCount()
		local var_71_1 = arg_70_0:getFragmentSlotCount()
		local var_71_2 = arg_70_1.devotion_need_count
		
		if_set(arg_70_1.ui, "t_count", arg_70_0:getFragmentCountString(var_71_0, var_71_1, var_71_2))
	end
	
	local function var_70_2()
		arg_70_0:updateFragmentSlotUI()
		arg_70_0:updateUpgradeInfo()
		SoundEngine:play("event:/ui/ok")
		arg_70_0:playSelectEffect()
		arg_70_0:playDevotionLoopEffect()
	end
	
	if arg_70_0:isInFragmentSlot(arg_70_1) then
		if arg_70_0:addFragmentSlotCount(arg_70_1.devotion_need_count) then
			var_70_1()
			var_70_2()
		end
	else
		arg_70_0:removeFragmentSlot()
		
		if arg_70_0:isCanFragmentDevotion(arg_70_1) then
			arg_70_0:setFragmentSlot(arg_70_1)
			var_70_1()
			var_70_2()
		end
	end
end

function UnitUpgrade.removeFragmentSlot(arg_73_0)
	arg_73_0:stopDevotionLooptEffect()
	
	if not arg_73_0.vars.slot_fragment then
		arg_73_0:updateUpgradeInfo()
		
		return 
	end
	
	local var_73_0 = arg_73_0.vars.slot_fragment
	
	arg_73_0:setFragmentSlot(nil)
	arg_73_0:updateFragmentSlotUI()
	arg_73_0:updateListFragment(var_73_0.ui, var_73_0)
	arg_73_0:updateUpgradeInfo()
end

function UnitUpgrade.updateListFragment(arg_74_0, arg_74_1, arg_74_2)
	if not arg_74_2 then
		return 
	end
	
	local var_74_0 = Account:getItemCount(arg_74_2.code)
	
	if not arg_74_1.is_init then
		arg_74_1.is_init = true
		arg_74_2.ui = arg_74_1
		
		local var_74_1 = arg_74_1:getChildByName("mob_icon")
		
		if get_cocos_refid(var_74_1) then
			UIUtil:getRewardIcon(var_74_0, arg_74_2.code, {
				no_count = true,
				parent = var_74_1
			})
		end
		
		if_set(arg_74_1, "t_up", T(arg_74_2.name))
		UIUserData:call(arg_74_1:getChildByName("t_count"), "RICH_LABEL(true)")
	end
	
	local var_74_2 = arg_74_0:isInFragmentSlot(arg_74_2)
	local var_74_3 = var_74_2 and var_74_0 - arg_74_2.devotion_need_count or var_74_0
	local var_74_4 = var_74_2 and arg_74_2.devotion_need_count or 0
	local var_74_5 = arg_74_2.devotion_need_count
	
	if_set(arg_74_1, "t_count", arg_74_0:getFragmentCountString(var_74_3, var_74_4, var_74_5))
	
	local var_74_6 = arg_74_1:getChildByName("btn_material")
	
	if get_cocos_refid(var_74_6) then
		var_74_6.fragment = arg_74_2
		
		if_set_opacity(var_74_6, nil, arg_74_0:isEnableFragmentListItem(arg_74_2) and 255 or 102)
	end
end

function UnitUpgrade.isHaveUpgradableFragments(arg_75_0)
	local var_75_0 = arg_75_0:getUpgradeableFragments()
	
	for iter_75_0, iter_75_1 in pairs(var_75_0) do
		if arg_75_0:isCanFragmentDevotion(iter_75_1) then
			return true
		end
	end
	
	return false
end

function UnitUpgrade.getUpgradeableFragments(arg_76_0)
	if arg_76_0.vars.upgradable_fragments then
		return arg_76_0.vars.upgradable_fragments
	end
	
	arg_76_0.vars.upgradable_fragments = {}
	
	local var_76_0 = ItemMaterial:getFragments()
	
	for iter_76_0, iter_76_1 in pairs(var_76_0) do
		if arg_76_0.vars.unit:isDevotionUpgradableFragment(iter_76_1) then
			table.push(arg_76_0.vars.upgradable_fragments, iter_76_1)
		end
	end
	
	table.sort(arg_76_0.vars.upgradable_fragments, function(arg_77_0, arg_77_1)
		return arg_77_0.sort < arg_77_1.sort
	end)
	
	return arg_76_0.vars.upgradable_fragments
end

function UnitUpgrade.loadFragmentListView(arg_78_0)
	if arg_78_0.vars.fragment_list_view then
		return 
	end
	
	local var_78_0 = arg_78_0.vars.wnd:getChildByName("n_material"):getChildByName("scroll_view")
	
	if not get_cocos_refid(var_78_0) then
		return 
	end
	
	local var_78_1 = load_control("wnd/unit_upgrade_item.csb")
	
	if var_78_0.STRETCH_INFO then
		resetControlPosAndSize(var_78_1, var_78_0:getContentSize().width, var_78_0.STRETCH_INFO.width_prev)
	end
	
	local var_78_2 = {
		onUpdate = function(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
			arg_78_0:updateListFragment(arg_79_1, arg_79_3)
			
			return arg_79_3.code
		end
	}
	
	arg_78_0.vars.fragment_list_view = ItemListView_v2:bindControl(var_78_0)
	
	arg_78_0.vars.fragment_list_view:setVisible(true)
	arg_78_0.vars.fragment_list_view:setRenderer(var_78_1, var_78_2)
	arg_78_0.vars.fragment_list_view:removeAllChildren()
	
	local var_78_3 = arg_78_0:getUpgradeableFragments()
	
	arg_78_0.vars.fragment_list_view:setDataSource(var_78_3)
end

function UnitUpgrade.isCanFragmentDevotion(arg_80_0, arg_80_1)
	if not arg_80_1 then
		return false
	end
	
	return (arg_80_0:isInFragmentSlot(arg_80_1) and arg_80_0:getFragmentSlotCount() or 0) + arg_80_1.devotion_need_count <= Account:getItemCount(arg_80_1.code)
end

function UnitUpgrade.updateFragmentToggleRedDot(arg_81_0)
	local var_81_0 = arg_81_0.vars.wnd:getChildByName("btn_swap")
	
	if not get_cocos_refid(var_81_0) then
		return 
	end
	
	if_set_visible(var_81_0, "icon_notice", arg_81_0.vars.unit:isUpgradeableByPrivateFragments())
end
