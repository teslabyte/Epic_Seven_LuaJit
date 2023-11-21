function MsgHandler.growth_boost_register(arg_1_0)
	if arg_1_0.growth_boost then
		GrowthBoost:setInfo(arg_1_0.growth_boost)
	end
	
	GrowthBoostUI:effectUnitRegister()
end

function MsgHandler.growth_boost_deregister(arg_2_0)
	if arg_2_0.growth_boost then
		GrowthBoost:setInfo(arg_2_0.growth_boost)
	end
	
	if UnitExclusiveEquip.vars and get_cocos_refid(UnitExclusiveEquip.vars.wnd) then
		UnitExclusiveEquip:PutOff(arg_2_0)
	else
		UnitEquip:PutOff(arg_2_0)
	end
	
	SAVE:setKeep("growth_boost_skip_register_noti", nil)
	GrowthBoostUI:updateDeregister()
end

function MsgHandler.growth_boost_update(arg_3_0)
	GrowthBoostUI:open({
		info = arg_3_0.growth_boost
	})
end

function MsgHandler.growth_boost_change_unlock(arg_4_0)
	if arg_4_0.growth_boost then
		GrowthBoost:setInfo(arg_4_0.growth_boost)
	end
	
	GrowthBoostUI:effectUnlockLevelChange(to_n(arg_4_0.prev_lv), math.min(to_n(arg_4_0.curr_lv), 4))
end

function MsgHandler.growth_boost_reset_deregister(arg_5_0)
	if arg_5_0.growth_boost then
		GrowthBoost:setInfo(arg_5_0.growth_boost)
	end
	
	Account:updateCurrencies(arg_5_0)
	TopBarNew:topbarUpdate(true)
end

function HANDLER.hero_blessing(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_recruit" then
		local var_6_0 = GrowthBoost:getGrowthLevel()
		
		GrowthBoostUI:setMode("Select")
	elseif arg_6_1 == "btn_removal" then
		GrowthBoostUI:deregister()
	elseif arg_6_1 == "btn_detail" then
		if not GrowthBoostUI.vars.portrait or not GrowthBoostUI.vars.portrait.unit then
			balloon_message_with_sound("ui_gb_regist_btn_hero_impossible")
			
			return 
		end
		
		local var_6_1 = GrowthBoostUI.vars.portrait.unit
		
		GrowthBoostUI:setScrollPause(true)
		
		local var_6_2 = HeroBelt:getFilterSetting("growth_boost")
		
		function popup_leave_callback()
			HeroBelt:updateUnit(nil, var_6_1)
			HeroBelt:scrollToUnit(var_6_1, 0)
			GrowthBoostUI:setScrollPause(false)
			GrowthBoostUI:updatePortrait()
			GrowthBoostUI:updateLeftInfo()
			
			if GrowthBoostUI.vars and GrowthBoostUI.vars.belt_item_cnt ~= table.count(Account.units) then
				HeroBelt:resetData(Account.units, "growth_boost", nil, nil, nil, var_6_2)
			end
			
			local var_7_0 = HeroBelt:getCurrentItem()
			
			if var_7_0 and not Account:getUnit(var_7_0:getUID()) then
				HeroBelt:clearCurrentItem()
				
				var_7_0 = nil
			end
			
			GrowthBoostUI:onSelectUnit(var_7_0)
		end
		
		UnitMain:beginPopupMode({
			growth_boost = true,
			unit = var_6_1,
			popup_leave_callback = popup_leave_callback
		})
	elseif arg_6_1 == "btn_select" then
		GrowthBoostUI:register()
	elseif arg_6_1 == "btn_wait" then
		GrowthBoostUI:reduceRegisterTime()
	end
end

GrowthBoost = {}

function GrowthBoost.makeData(arg_8_0, arg_8_1)
	if not arg_8_0.boost_data then
		arg_8_0.boost_data = {}
	end
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1 or {}) do
		local var_8_0 = tonumber(iter_8_1.slot_num)
		
		arg_8_0.boost_data[var_8_0] = iter_8_1
	end
	
	arg_8_0.regiser_units = nil
	
	return arg_8_0.boost_data
end

function GrowthBoost.getInfo(arg_9_0)
	local var_9_0 = Account:getGrowthBoostInfo()
	
	return arg_9_0:makeData(var_9_0)
end

function GrowthBoost.setInfo(arg_10_0, arg_10_1)
	Account:setGrowthBoostInfo(arg_10_1)
	arg_10_0:makeData(arg_10_1)
	
	arg_10_0.regiser_units = nil
end

function GrowthBoost.getSlotInfo(arg_11_0, arg_11_1)
	return arg_11_0:getInfo()[arg_11_1]
end

function GrowthBoost.getGrowthLevel(arg_12_0, arg_12_1)
	if DEBUG.GROWTH_LEVEL then
		return to_n(DEBUG.GROWTH_LEVEL)
	end
	
	local var_12_0 = arg_12_1 or 1
	local var_12_1 = (arg_12_0:getSlotInfo(var_12_0) or {}).unlock_level
	
	return to_n(var_12_1)
end

function GrowthBoost.calcGrowthLevel(arg_13_0, arg_13_1)
	local var_13_0 = false
	local var_13_1 = arg_13_0:getGrowthLevel(arg_13_1)
	local var_13_2 = 0
	
	for iter_13_0 = 1, 4 do
		local var_13_3 = UNLOCK_ID["GROWTH_BOOST_" .. iter_13_0]
		
		if not UnlockSystem:isUnlockSystem(var_13_3) then
			break
		end
		
		var_13_2 = iter_13_0
	end
	
	if var_13_1 < var_13_2 then
		var_13_0 = true
	end
	
	return var_13_2, var_13_0
end

function GrowthBoost.checkGrowthLevelup(arg_14_0, arg_14_1)
	local var_14_0, var_14_1 = GrowthBoost:calcGrowthLevel()
	
	if var_14_1 and not DEBUG.GROWTH_LEVEL then
		if not TutorialGuide:isClearedTutorial("growth_boost") then
			TutorialGuide:startGuide("growth_boost")
		else
			query("growth_boost_change_unlock", {
				curr_lv = arg_14_0:getGrowthLevel(arg_14_1),
				next_lv = var_14_0
			})
		end
	elseif not TutorialGuide:isClearedTutorial("growth_boost") then
		TutorialGuide:startGuide("growth_boost")
	end
end

function GrowthBoost.getGrowthUnit(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1 or 1
	local var_15_1 = arg_15_0:getSlotInfo(var_15_0) or {}
	
	return (Account:getUnit(var_15_1.reg_uid))
end

function GrowthBoost.getUnregisterType(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1:getLv()
	local var_16_1 = arg_16_1:getGrade()
	local var_16_2 = arg_16_1:getZodiacGrade()
	local var_16_3 = arg_16_1:getTotalSkillLevel()
	local var_16_4 = arg_16_1:getAwakeGrade()
	
	if to_n(var_16_4) > 0 then
		return "awake"
	end
	
	if var_16_3 >= 12 and var_16_0 >= 60 and var_16_1 >= 6 and var_16_2 >= 6 then
		return "max"
	end
	
	if arg_16_1:isMoonlightDestinyUnit() or arg_16_1:isDevotionUnit() or arg_16_1:isSpecialUnit() or arg_16_1:isPromotionUnit() then
		return "etc"
	end
	
	if (DB("character", arg_16_1.inst.code, "grade") or 3) <= 2 then
		return "low_grade"
	end
	
	local var_16_5 = ""
	
	local function var_16_6(arg_17_0)
		if not arg_17_0 then
			return 
		end
		
		if string.len(var_16_5) > 0 then
			var_16_5 = var_16_5 .. ","
		end
		
		var_16_5 = var_16_5 .. arg_17_0
	end
	
	if Account:isIn_worldbossSupporterTeam(arg_16_1:getUID()) then
		var_16_6("worldboss")
	end
	
	if Account:isInTeam(arg_16_1, 11) then
		var_16_6("team_11")
	end
	
	if Account:isInTeam(arg_16_1, 12) then
		var_16_6("team_12")
	end
	
	for iter_16_0 = 13, 16 do
		if Account:isInTeam(arg_16_1, iter_16_0) then
			var_16_6("clan_war")
		end
	end
	
	if string.len(var_16_5) > 0 then
		return var_16_5
	end
	
	return "none"
end

function GrowthBoost.isUnregisterable(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return false
	end
	
	local var_18_0 = arg_18_0:getUnregisterType(arg_18_1)
	
	if var_18_0 ~= "none" then
		return var_18_0
	end
	
	return false
end

function GrowthBoost.isNotification(arg_19_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.GROWTH_BOOST_1) then
		return false
	end
	
	local var_19_0 = SAVE:getKeep("growth_boost_skip_register_noti")
	local var_19_1 = false
	local var_19_2 = GrowthBoost:getInfo()
	
	for iter_19_0, iter_19_1 in pairs(var_19_2 or {}) do
		if to_n(iter_19_1.reg_uid) > 0 then
			var_19_1 = true
			
			break
		end
	end
	
	local var_19_3, var_19_4 = GrowthBoost:calcGrowthLevel()
	
	return not var_19_0 and not var_19_1 or var_19_4
end

function GrowthBoost.getRegisteredIDs(arg_20_0)
	local var_20_0 = {}
	local var_20_1 = GrowthBoost:getInfo()
	
	for iter_20_0, iter_20_1 in pairs(var_20_1 or {}) do
		if iter_20_1.reg_uid ~= -1 then
			var_20_0[tostring(iter_20_1.reg_uid)] = true
		end
	end
	
	return var_20_0
end

function GrowthBoost.isRegistered(arg_21_0, arg_21_1)
	if not arg_21_0.regiser_units then
		arg_21_0.regiser_units = arg_21_0:getRegisteredIDs()
	end
	
	return arg_21_0.regiser_units[tostring(arg_21_1:getUID())]
end

function GrowthBoost.apply(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_2 or GrowthBoost:getInfo()
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if arg_22_1:getUID() == iter_22_1.reg_uid then
			local var_22_1 = arg_22_0:getGrowthLevel(iter_22_1.slot_num)
			local var_22_2 = DB("growth_boost", "growth_" .. to_n(var_22_1), "cs_id")
			
			if var_22_2 then
				arg_22_1:addState(var_22_2)
				arg_22_1:applyGrowthBoost()
				arg_22_1:calc()
			end
		end
	end
end

function GrowthBoost.applyManual(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_1 then
		return arg_23_1
	end
	
	local var_23_0 = arg_23_1:clone()
	local var_23_1 = to_n(arg_23_2)
	local var_23_2 = DB("growth_boost", "growth_" .. to_n(var_23_1), "cs_id")
	
	if var_23_2 then
		var_23_0:addState(var_23_2)
		var_23_0:applyGrowthBoost()
		var_23_0:calc()
	end
	
	return var_23_0
end

function GrowthBoost.getEffect(arg_24_0, arg_24_1)
	local var_24_0 = DB("growth_boost", "growth_" .. to_n(arg_24_1), "cs_id")
	local var_24_1 = {}
	local var_24_4
	
	if var_24_0 then
		local var_24_2 = {}
		local var_24_3 = {
			"cs_eff1",
			"cs_eff2",
			"cs_eff3",
			"cs_eff4",
			"cs_eff5",
			"cs_eff6",
			"cs_eff_value1",
			"cs_eff_value2",
			"cs_eff_value3",
			"cs_eff_value4",
			"cs_eff_value5",
			"cs_eff_value6"
		}
		
		var_24_4 = DBT("cs", var_24_0, var_24_3)
		
		for iter_24_0 = 1, 6 do
			local var_24_5 = var_24_4["cs_eff" .. iter_24_0]
			local var_24_6 = var_24_4["cs_eff_value" .. iter_24_0]
			
			if var_24_5 == "CSP_LEVEL_ENHANCE" then
				var_24_1.lv = var_24_6
			elseif var_24_5 == "CSP_GRADE_ENHANCE" then
				var_24_1.grade = var_24_6
			elseif var_24_5 == "CSP_SKLV_ENHANCE" then
				var_24_1.skill_lv = var_24_6
			elseif var_24_5 == "CSP_ZODIAC_ENHANCE" then
				var_24_1.zodiac = var_24_6
			end
		end
	end
	
	return var_24_1
end

function GrowthBoost.isRegisteredUnit(arg_25_0, arg_25_1)
	if not arg_25_1 then
		return false
	end
	
	local var_25_0 = GrowthBoost:getInfo()
	
	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		if arg_25_1:getUID() == iter_25_1.reg_uid then
			return GrowthBoost:getEffect(arg_25_0:getGrowthLevel(iter_25_1.slot_num))
		end
	end
	
	return false
end

GrowthBoostUI = {}

function GrowthBoostUI.show(arg_26_0)
	SceneManager:nextScene("growth_boost")
end

function GrowthBoostUI.onUpdateUI(arg_27_0)
	if SceneManager:getCurrentSceneName() ~= "growth_boost" then
		return 
	end
end

function GrowthBoostUI.isValid(arg_28_0)
	return arg_28_0.vars and get_cocos_refid(arg_28_0.vars.wnd)
end

function GrowthBoostUI.open(arg_29_0, arg_29_1)
	arg_29_1 = arg_29_1 or {}
	arg_29_0.vars = {}
	arg_29_0.vars.opts = arg_29_1
	
	if arg_29_1.info then
		GrowthBoost:setInfo(arg_29_1.info)
	end
	
	local var_29_0 = arg_29_1.parent or SceneManager:getDefaultLayer()
	
	arg_29_0.vars.wnd = load_dlg("hero_blessing", true, "wnd")
	
	var_29_0:addChild(arg_29_0.vars.wnd)
	
	local var_29_1 = arg_29_0.vars.wnd:findChildByName("n_main")
	local var_29_2 = var_29_1:findChildByName("top")
	local var_29_3 = var_29_1:findChildByName("bottom")
	
	var_29_2.origin_y = var_29_2:getPositionY()
	var_29_3.origin_y = var_29_3:getPositionY()
	
	if_set_visible(arg_29_0.vars.wnd, "n_select", false)
	
	local var_29_4 = arg_29_0.vars.wnd:findChildByName("n_select")
	local var_29_5 = var_29_4:findChildByName("RIGHT")
	local var_29_6 = var_29_4:findChildByName("LEFT")
	local var_29_7 = var_29_4:findChildByName("n_bottom")
	
	var_29_5.origin_x = var_29_5:getPositionX()
	var_29_6.origin_x = var_29_6:getPositionX()
	
	arg_29_0:setMode("Main")
	SAVE:setKeep("growth_boost_skip_register_noti", true)
	TopBarNew:create(T("ui_gb_title"), var_29_0, function()
		GrowthBoostUI:onPushBackButton()
	end, nil, nil, "growth_6")
	BackButtonManager:push({
		check_id = "growth_boost",
		back_func = function()
			arg_29_0:onPushBackButton()
		end
	})
	SoundEngine:playBGM("event:/bgm/default")
end

function GrowthBoostUI.close(arg_32_0)
	arg_32_0.vars.wnd:removeFromParent()
	
	arg_32_0.vars = {}
	
	SceneManager:nextScene("lobby")
end

function GrowthBoostUI.getWnd(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	return arg_33_0.vars.wnd
end

function GrowthBoostUI.getSceneState(arg_34_0)
	return {}
end

function GrowthBoostUI.onPushBackButton(arg_35_0)
	if arg_35_0:getMode() == "Select" then
		arg_35_0:setMode("Main")
	elseif arg_35_0:getMode() == "Main" then
		BackButtonManager:pop("growth_boost")
		arg_35_0:close()
	end
end

function GrowthBoostUI.register(arg_36_0, arg_36_1)
	if arg_36_0:getMode() ~= "Select" then
		return 
	end
	
	if HeroBelt:isScrolling() then
		local var_36_0 = HeroBelt:getCurrentItem()
		
		arg_36_0:onSelectUnit(var_36_0)
	end
	
	local var_36_1 = arg_36_0.vars.select_unit
	
	if not var_36_1 then
		balloon_message(T("no_unit"))
		
		return 
	end
	
	local var_36_2 = GrowthBoost:isUnregisterable(var_36_1)
	
	if var_36_2 then
		local var_36_3
		
		if var_36_2 == "etc" or var_36_2 == "low_grade" then
			Dialog:msgBox(T("ui_gb_hero_regist_impossible2"), {
				title = T("ui_gb_hero_regist_impossible_title")
			})
		elseif var_36_2 == "max" or var_36_2 == "awake" then
			Dialog:msgBox(T("ui_gb_hero_regist_impossible"), {
				title = T("ui_gb_hero_regist_impossible_title")
			})
		elseif var_36_2 and var_36_2 ~= "none" then
			local var_36_4 = string.split(var_36_2, ",")
			local var_36_5 = Dialog:msgUnitLock(var_36_4)
			
			if_set(var_36_5, "txt_title", T("ui_gb_hero_regist_impossible_title"))
		end
		
		return 
	end
	
	local function var_36_6()
		local var_37_0 = var_36_1:getUID()
		
		query("growth_boost_register", {
			slot_num = 1,
			target_uid = var_37_0,
			target_code = var_36_1.db.code
		})
	end
	
	local var_36_7 = load_dlg("hero_blessing_info", true, "wnd")
	
	if_set(var_36_7, "txt_title", T("ui_gb_regist_popup_title"))
	if_set(var_36_7, "txt_disc", T("ui_gb_regist_popup_default_desc"))
	
	local var_36_8 = GrowthBoost:getEffect(to_n(GrowthBoost:getGrowthLevel()))
	local var_36_9 = {}
	
	if var_36_1:getLv() > to_n(var_36_8.lv) then
		table.insert(var_36_9, T("ui_gb_high_growth_level"))
	end
	
	if var_36_1:getGrade() > to_n(var_36_8.grade) then
		table.insert(var_36_9, T("ui_gb_high_growth_star"))
	end
	
	if var_36_1:getZodiacGrade() > to_n(var_36_8.zodiac) then
		table.insert(var_36_9, T("ui_gb_high_growth_awaken"))
	end
	
	local var_36_10 = var_36_1:getTotalSkillLevel()
	
	if var_36_10 > 0 and var_36_10 >= to_n(var_36_8.skill_lv) then
		table.insert(var_36_9, T("ui_gb_high_growth_skill"))
	end
	
	if table.count(var_36_9) > 0 then
		local var_36_11 = ""
		
		for iter_36_0, iter_36_1 in pairs(var_36_9) do
			if string.len(var_36_11) > 0 then
				var_36_11 = var_36_11 .. ", "
			end
			
			var_36_11 = var_36_11 .. iter_36_1
		end
		
		local var_36_12 = "<#ff7800>" .. var_36_11 .. "</>"
		local var_36_13 = T("ui_gb_regist_popup_high_growth_desc", {
			codes = var_36_12
		})
		
		if_set_visible(var_36_7, "txt_apply", true)
		if_set(var_36_7, "txt_apply", var_36_13)
		
		local var_36_14 = var_36_7:findChildByName("window_frame")
		
		if get_cocos_refid(var_36_14) then
			local var_36_15 = var_36_14:getContentSize()
			
			var_36_15.height = var_36_15.height + 84
			
			var_36_14:setContentSize(var_36_15)
		end
		
		if_set_add_position_y(var_36_7, "n_top", 84)
	else
		if_set_visible(var_36_7, "txt_apply", false)
	end
	
	if_set_visible(var_36_7, "txt_warning", false)
	arg_36_0:setUnitIcon(var_36_7:findChildByName("n_mob_icon"), var_36_1)
	
	local var_36_16 = {
		yesno = true,
		dlg = var_36_7,
		handler = var_36_6,
		yes_text = T("ui_gb_regist_popup_btn_apply"),
		no_text = T("ui_gb_regist_popup_btn_cancel")
	}
	
	Dialog:msgBox(var_36_16)
end

function GrowthBoostUI.deregister(arg_38_0)
	local var_38_0 = GrowthBoost:getInfo()[1] or {}
	local var_38_1 = Account:getUnit(var_38_0.reg_uid)
	
	if not var_38_1 then
		return 
	end
	
	local var_38_2 = false
	local var_38_3 = ""
	local var_38_4
	local var_38_5 = var_38_1:getEquipByIndex(8)
	local var_38_6 = 0
	
	if var_38_1:getZodiacGrade() < 5 and var_38_5 then
		var_38_3 = var_38_3 .. T("ui_gb_deregist_popup_equip_desc")
		var_38_4 = var_38_5:getUID()
		
		local var_38_7 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT)
		local var_38_8 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
		local var_38_9 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ARTI_FREE)
		
		if not (var_38_5:getUnequipCost() <= 0) and not var_38_7 and not var_38_5:isArtifact() and var_38_8 then
		end
		
		var_38_6 = var_38_5:getUnequipCost()
	else
		var_38_2 = true
	end
	
	local function var_38_10()
		local var_39_0 = var_38_1:getUID()
		
		query("growth_boost_deregister", {
			slot_num = 1,
			caller = "growth_boost",
			exclusive_id = var_38_4
		})
	end
	
	local var_38_11 = load_dlg("hero_blessing_info", true, "wnd")
	
	if_set(var_38_11, "txt_title", T("ui_gb_deregist_popup_title"))
	if_set(var_38_11, "txt_disc", T("ui_gb_deregist_popup_default_desc"))
	if_set_visible(var_38_11, "txt_apply", false)
	arg_38_0:setUnitIcon(var_38_11:findChildByName("n_mob_icon"), var_38_1)
	
	local var_38_12 = {
		yesno = true,
		dlg = var_38_11,
		handler = var_38_10,
		yes_text = T("ui_gb_deregist_popup_btn_apply"),
		no_text = T("ui_gb_deregist_popup_btn_cancel")
	}
	
	if not var_38_2 then
		var_38_12.cost = var_38_6
		var_38_12.token = "to_gold"
		
		if_set(var_38_11, "txt_go", T("ui_gb_deregist_popup_btn_apply"))
	end
	
	Dialog:msgBox(var_38_12)
	
	local var_38_13 = var_38_1:getUsableCodeList(nil, "growth_boost") or {}
	
	if table.count(var_38_13) > 0 then
		local var_38_14 = ""
		
		for iter_38_0, iter_38_1 in pairs(var_38_13) do
			if string.len(var_38_14) > 0 then
				var_38_14 = var_38_14 .. ", "
			end
			
			var_38_14 = var_38_14 .. T("ul_" .. iter_38_1)
		end
		
		local var_38_15 = "<#dd4545>" .. var_38_14 .. "</>"
		
		if string.len(var_38_3) > 0 then
			var_38_3 = var_38_3 .. "\n\n"
		end
		
		var_38_3 = var_38_3 .. T("ui_gb_deregist_popup_use_desc", {
			codes = var_38_15
		})
	end
	
	if string.len(var_38_3) > 0 then
		local var_38_16 = var_38_11:findChildByName("txt_warning")
		
		var_38_16:setVisible(true)
		var_38_16:setString(var_38_3)
		
		local var_38_17 = 20 * (var_38_16:getStringNumLines() - 1)
		local var_38_18 = var_38_11:findChildByName("window_frame")
		
		if get_cocos_refid(var_38_18) then
			local var_38_19 = var_38_18:getContentSize()
			
			var_38_19.height = var_38_19.height + 46 + var_38_17
			
			var_38_18:setContentSize(var_38_19)
		end
		
		if_set_add_position_y(var_38_11, "n_top", 46 + var_38_17)
	else
		if_set_visible(var_38_11, "txt_warning", false)
	end
end

function GrowthBoostUI.reduceRegisterTime(arg_40_0)
	local var_40_0 = GrowthBoost:getInfo()[1] or {}
	local var_40_1 = to_n(var_40_0.deregister_tm)
	local var_40_2 = GAME_CONTENT_VARIABLE.gb_register_reset_cost or 720
	local var_40_3 = GAME_CONTENT_VARIABLE.gb_register_decrease_cost or 5
	local var_40_4 = DEBUG.GB_TEST_COOLTIME or GAME_CONTENT_VARIABLE.gb_register_reset_cooltime or 259200
	local var_40_5 = var_40_4 - (var_40_1 + var_40_4 - os.time())
	local var_40_6 = math.clamp(var_40_2 - math.floor(var_40_5 / 1800) * var_40_3, 0, GAME_CONTENT_VARIABLE.gb_register_reset_cost or 720)
	
	local function var_40_7()
		query("growth_boost_reset_deregister")
	end
	
	local var_40_8 = {
		token = "crystal",
		handler = var_40_7,
		cost = var_40_6,
		title = T("ui_gb_cooltime_del_popup_title"),
		warning = "<#AB8759>" .. T("ui_gb_cooltime_del_popup_discount_desc") .. "</>"
	}
	local var_40_9 = Dialog:msgBox(T("ui_gb_cooltime_del_popup_desc"), var_40_8)
end

function GrowthBoostUI.setUnitIcon(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_2:getSkinCode() or arg_42_2.db.code
	
	UIUtil:getRewardIcon(nil, var_42_0, {
		no_db_grade = true,
		no_tooltip = true,
		no_frame = true,
		role = true,
		no_count = true,
		no_popup = true,
		parent = arg_42_1,
		lv = arg_42_2:getLv(),
		grade = arg_42_2:getGrade(),
		zodiac = arg_42_2:getZodiacGrade()
	})
end

function GrowthBoostUI.getMode(arg_43_0)
	return arg_43_0.vars.mode
end

function GrowthBoostUI.setMode(arg_44_0, arg_44_1)
	arg_44_0:onModeDeactivate()
	
	arg_44_0.vars.mode = arg_44_1
	
	arg_44_0:onModeActivate()
end

function GrowthBoostUI.onModeDeactivate(arg_45_0)
	local var_45_0 = arg_45_0.vars.mode
	
	if not var_45_0 then
		return 
	end
	
	local var_45_1 = arg_45_0["deactiveMode" .. var_45_0]
	
	if var_45_1 then
		var_45_1(arg_45_0)
	end
end

function GrowthBoostUI.onModeActivate(arg_46_0)
	local var_46_0 = arg_46_0.vars.mode
	
	if not var_46_0 then
		return 
	end
	
	local var_46_1 = arg_46_0["activeMode" .. var_46_0]
	
	if var_46_1 then
		var_46_1(arg_46_0)
	end
end

function GrowthBoostUI.updatePortrait(arg_47_0, arg_47_1)
	if not arg_47_0.vars then
		return 
	end
	
	local var_47_0 = arg_47_1 or arg_47_0.vars.portrait.unit
	
	if get_cocos_refid(arg_47_0.vars.portrait) then
		arg_47_0.vars.portrait:removeFromParent()
	end
	
	if not var_47_0 then
		return 
	end
	
	local var_47_1
	local var_47_2 = arg_47_0.vars.mode
	local var_47_3 = 0
	
	if var_47_2 == "Select" then
		var_47_1 = arg_47_0.vars.wnd:findChildByName("n_select"):findChildByName("port_pos")
		var_47_3 = var_47_1:getPositionY() + 40
	elseif var_47_2 == "Main" then
		var_47_1 = arg_47_0.vars.wnd:findChildByName("n_main"):findChildByName("port_pos")
		var_47_3 = var_47_1:getPositionY() + 140
	end
	
	if not get_cocos_refid(var_47_1) then
		return 
	end
	
	local var_47_4 = var_47_0:getSkinCode() or var_47_0.db.code
	local var_47_5, var_47_6, var_47_7, var_47_8 = DB("character", var_47_4, {
		"name",
		"role",
		"grade",
		"face_id"
	})
	local var_47_9, var_47_10 = UIUtil:getPortraitAni(var_47_8, {
		parent_pos_y = var_47_3
	})
	
	if var_47_9 then
		if not var_47_10 then
			var_47_9:setAnchorPoint(0.5, 0.1)
		else
			var_47_9:setAnchorPoint(0.5, 0)
		end
		
		var_47_9:setLocalZOrder(1)
		var_47_9:setPositionX(0)
		var_47_9:setScale(0.8)
		var_47_1:addChild(var_47_9)
		
		arg_47_0.vars.portrait = var_47_9
		arg_47_0.vars.portrait.unit = var_47_0
		
		local var_47_11 = var_47_0:getFaceID()
		
		if var_47_11 and var_47_9 and var_47_9.setSkin then
			var_47_9:setSkin(var_47_11)
		end
		
		var_47_9:setOpacity(0)
		UIAction:Add(SEQ(LOG(FADE_IN(400))), var_47_9)
	end
	
	if false then
		var_47_9:setScale(0.8)
	end
end

function GrowthBoostUI.getTutorialTargetNodeByIdx(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0.vars.wnd:findChildByName("n_main"):findChildByName("n_grade_" .. arg_48_1)
	
	if get_cocos_refid(var_48_0) then
		return var_48_0:getChildByName("itxt_num" .. arg_48_1)
	end
end

function GrowthBoostUI.activeModeMain(arg_49_0)
	local var_49_0 = arg_49_0.vars.wnd:findChildByName("n_main")
	
	if get_cocos_refid(arg_49_0.vars.portrait) then
		arg_49_0.vars.portrait:removeFromParent()
	end
	
	var_49_0:setVisible(true)
	
	local var_49_1 = GrowthBoost:getInfo()[1] or {}
	local var_49_2 = var_49_0:findChildByName("top")
	local var_49_3 = to_n(var_49_1.reg_uid) > 0
	local var_49_4 = to_n(var_49_1.deregister_tm)
	
	if not var_49_3 then
		local var_49_5 = DEBUG.GB_TEST_COOLTIME or GAME_CONTENT_VARIABLE.gb_register_reset_cooltime or 259200
		local var_49_6 = var_49_4 + var_49_5 > os.time()
		
		if_set_visible(var_49_2, "n_register", not var_49_6)
		if_set_visible(var_49_2, "n_waiting", var_49_6)
		
		if var_49_6 then
			local var_49_7 = var_49_4 + var_49_5 - os.time()
			local var_49_8 = var_49_2:findChildByName("n_waiting")
			
			if get_cocos_refid(var_49_8) then
				if_set(var_49_8, "txt_info", T("ui_gb_cooltime", {
					time = sec_to_full_string(var_49_7)
				}))
			end
		end
	end
	
	if_set_visible(var_49_2, "n_hero_result", var_49_3)
	
	local var_49_9
	
	if var_49_3 then
		local var_49_10 = var_49_2:findChildByName("n_hero_result"):findChildByName("n_hero")
		local var_49_11 = var_49_10:findChildByName("n_before")
		local var_49_12 = var_49_10:findChildByName("n_after")
		local var_49_13 = arg_49_0.vars.wnd:findChildByName("n_bg_eff")
		
		var_49_13:setOpacity(255)
		
		local var_49_14 = EffectManager:Play({
			scale = 2.4,
			y = -2,
			fn = "ui_growtboost_bg.cfx",
			layer = var_49_13
		})
		
		EffectManager:Play({
			scale = 2.4,
			fn = "ui_growthboost_pati1.particle",
			layer = var_49_14
		})
		
		local var_49_15 = Account:getUnit(var_49_1.reg_uid)
		
		arg_49_0:updateUnitInfo(var_49_15)
	end
	
	if false then
	end
	
	local var_49_16 = GrowthBoost:getGrowthLevel()
	
	if var_49_16 < 1 then
	end
	
	local var_49_17 = var_49_0:findChildByName("bottom")
	local var_49_18 = var_49_17:findChildByName("n_deco")
	
	for iter_49_0 = 1, 4 do
		local var_49_19 = var_49_17:findChildByName("n_grade_" .. iter_49_0)
		local var_49_20 = load_control("wnd/hero_blessing_card.csb")
		local var_49_21 = var_49_20:findChildByName("n_link")
		local var_49_22 = var_49_20:findChildByName("n_base")
		
		if not var_49_19.origin_y then
			var_49_19.origin_y = var_49_19:getPositionY()
		end
		
		if not var_49_21.origin_y then
			var_49_21.origin_y = var_49_21:getPositionY()
		end
		
		if not var_49_22.origin_y then
			var_49_22.origin_y = var_49_22:getPositionY()
		end
		
		var_49_19:addChild(var_49_20)
		
		local var_49_23 = iter_49_0 <= var_49_16
		local var_49_24 = var_49_20:findChildByName("n_link")
		local var_49_25 = var_49_20:findChildByName("n_base")
		
		if var_49_16 < iter_49_0 then
			var_49_25:setColor(cc.c3b(161, 161, 161))
		end
		
		local var_49_26 = var_49_25:findChildByName("n_grade")
		local var_49_27 = var_49_25:findChildByName("n_quest")
		local var_49_28, var_49_29 = DB("growth_boost", "growth_" .. iter_49_0, {
			"name",
			"desc"
		})
		
		if not var_49_28 then
			var_49_27:setVisible(false)
		else
			if_set_visible(var_49_25, "n_quest", not var_49_23)
			if_set(var_49_27, "txt_title", T(var_49_28))
			if_set(var_49_27, "txt_name", T(var_49_29))
			
			local var_49_30 = UNLOCK_ID["GROWTH_BOOST_" .. iter_49_0]
			local var_49_31 = UnlockSystem:isUnlockSystem(var_49_30)
			
			if_set_percent(var_49_27, "progress", 0)
			
			local var_49_32, var_49_33 = DB("system_achievement", var_49_30, {
				"condition",
				"value"
			})
			local var_49_34 = totable(var_49_33)
			local var_49_35 = ""
			
			if string.ends(var_49_32, "level_count") then
				local var_49_36 = 0
				
				for iter_49_1, iter_49_2 in pairs(Account:getUnits() or {}) do
					if var_49_36 >= 3 then
						break
					end
					
					if iter_49_2:getLv() >= to_n(var_49_34.level) then
						var_49_36 = var_49_36 + 1
					end
				end
				
				var_49_35 = var_49_36 .. " / 3"
				
				if_set_percent(var_49_27, "progress", var_49_36 / 3)
			elseif string.ends(var_49_32, "skillenhance_count") then
				local var_49_37 = 0
				local var_49_38 = to_n(var_49_34.skillenhance)
				
				for iter_49_3, iter_49_4 in pairs(Account:getUnits() or {}) do
					if iter_49_4:getBaseGrade() >= to_n(var_49_34.basegrade) and var_49_37 < iter_49_4:getTotalSkillLevel() then
						var_49_37 = iter_49_4:getTotalSkillLevel()
					end
				end
				
				local var_49_39 = math.min(var_49_37, var_49_38)
				
				var_49_35 = var_49_39 .. " / " .. var_49_38
				
				if_set_percent(var_49_27, "progress", var_49_39 / var_49_38)
			end
			
			if_set(var_49_27, "txt_progress", var_49_35)
		end
		
		local var_49_40 = var_49_26:findChildByName("n_" .. iter_49_0)
		local var_49_41 = var_49_40:findChildByName("n_ability")
		local var_49_42 = var_49_40:findChildByName("n_on_eff")
		
		if var_49_16 == iter_49_0 then
			var_49_42.eff = EffectManager:Play({
				scale = 2.4,
				fn = "ui_growtboost_current.cfx",
				layer = var_49_42
			})
		end
		
		if_set_visible(var_49_24, "n_" .. iter_49_0, var_49_23)
		if_set_visible(var_49_26, "n_" .. iter_49_0, true)
		if_set_visible(var_49_40, "n_ability", var_49_16 <= iter_49_0)
		if_set_visible(var_49_25, "icon_etclock", not var_49_23)
		if_set_visible(var_49_40, "n_on", var_49_16 == iter_49_0)
		if_set_visible(var_49_18, "n_" .. iter_49_0, var_49_23)
		
		if var_49_23 then
			local var_49_43 = var_49_20:findChildByName("n_" .. iter_49_0)
			
			arg_49_0:makeSparkleEffect(var_49_43)
		end
	end
	
	var_49_2:setOpacity(0)
	var_49_18:setOpacity(0)
	UIAction:Add(SPAWN(LOG(MOVE_TO(250, 0, var_49_2.origin_y)), LOG(OPACITY(250, 0, 1))), var_49_2, "block")
	UIAction:Add(SPAWN((OPACITY(400, 0, 1))), var_49_18, "block")
	
	for iter_49_5 = 1, 4 do
		local var_49_44 = var_49_17:findChildByName("n_grade_" .. iter_49_5)
		local var_49_45 = var_49_44:findChildByName("n_link")
		local var_49_46 = var_49_44:findChildByName("n_base")
		
		if get_cocos_refid(var_49_44) then
			var_49_45:setOpacity(0)
			var_49_46:setOpacity(0)
			
			if var_49_44.move_effet then
				var_49_45:setPositionY(var_49_45:getPositionY() - 300)
				var_49_46:setPositionY(var_49_46:getPositionY() - 300)
			end
			
			UIAction:Add(SEQ(DELAY(100 * (iter_49_5 - 1)), SPAWN(TARGET(var_49_46, LOG(MOVE_TO(250, var_49_46:getPositionX(), var_49_46.origin_y))), TARGET(var_49_46, LOG(OPACITY(250, 0, 1))), SEQ(DELAY(iter_49_5 > 1 and 50 or 0), SPAWN(TARGET(var_49_45, LOG(MOVE_TO(250, var_49_45:getPositionX(), var_49_45.origin_y))), TARGET(var_49_45, RLOG(OPACITY(400, 0, 1))))))), var_49_2, "block")
		end
	end
	
	UIAction:Add(SEQ(DELAY(200), COND_LOOP(DELAY(200), function()
		return not UIAction:Find("block")
	end), CALL(function()
		arg_49_0:checkMaxUnitWarningAndLevelup()
	end)), arg_49_0.vars.wnd)
end

function GrowthBoostUI.checkMaxUnitWarningAndLevelup(arg_52_0)
	local var_52_0 = GrowthBoost:getGrowthUnit()
	local var_52_1
	
	if var_52_0 then
		local var_52_2 = var_52_0:getLv()
		local var_52_3 = var_52_0:getGrade()
		local var_52_4 = var_52_0:getZodiacGrade()
		local var_52_5 = var_52_0:getTotalSkillLevel()
		
		if SAVE:getKeep("growth_boost_max_warning_uid") ~= var_52_0:getUID() and var_52_5 >= 12 and var_52_2 >= 60 and var_52_3 >= 6 and var_52_4 >= 6 then
			local function var_52_6()
				SAVE:setKeep("growth_boost_max_warning_uid", var_52_0:getUID())
				GrowthBoost:checkGrowthLevelup()
			end
			
			var_52_1 = Dialog:msgBox(T("ui_gb_growth_alert_desc"), {
				title = T("ui_gb_growth_alert_title"),
				handler = var_52_6
			})
		end
	end
	
	if not var_52_1 then
		GrowthBoost:checkGrowthLevelup()
	end
end

function GrowthBoostUI.makeSparkleEffect(arg_54_0, arg_54_1)
	if get_cocos_refid(arg_54_1) then
		for iter_54_0, iter_54_1 in pairs(arg_54_1:getChildren()) do
			if iter_54_1:getName() == "n_sparkle" then
				if UIAction:Find(iter_54_1) then
					UIAction:Remove(iter_54_1)
				end
				
				UIAction:Add(SEQ(DELAY(math.random() * 1000), LOOP(SEQ(SPAWN(LOG(SCALE_TO(2000, 1.1)), LOG(OPACITY(2000, 1, 0.6))), SPAWN(LOG(SCALE_TO(2000, 0.8)), LOG(OPACITY(2000, 0.6, 1)))))), iter_54_1, "sparkle")
			elseif iter_54_1:getName() == "n_line2" then
				UIAction:Add(SEQ(DELAY(math.random() * 1000), LOOP(SEQ(SPAWN(LOG(OPACITY(2000, 1, 0.7))), SPAWN(LOG(OPACITY(2000, 0.7, 1)))))), iter_54_1, "line")
			end
		end
	end
end

function GrowthBoostUI.deactiveModeMain(arg_55_0)
	local var_55_0 = arg_55_0.vars.wnd:findChildByName("n_main")
	local var_55_1 = var_55_0:findChildByName("top")
	local var_55_2 = var_55_0:findChildByName("bottom")
	local var_55_3 = var_55_2:findChildByName("n_deco")
	
	UIAction:Add(SPAWN(LOG(OPACITY(250, 1, 0))), var_55_1, "block")
	UIAction:Add(SPAWN(LOG(OPACITY(250, 1, 0))), var_55_3, "block")
	
	for iter_55_0 = 1, 4 do
		local var_55_4 = var_55_2:findChildByName("n_grade_" .. iter_55_0)
		local var_55_5 = var_55_4:findChildByName("n_link")
		local var_55_6 = var_55_4:findChildByName("n_base")
		
		if get_cocos_refid(var_55_4) then
			UIAction:Add(SEQ(SPAWN(TARGET(var_55_6, LOG(MOVE_TO(250, var_55_6:getPositionX(), -300 + var_55_6.origin_y))), TARGET(var_55_6, LOG(OPACITY(250, 1, 0))), TARGET(var_55_5, LOG(MOVE_TO(250, var_55_5:getPositionX(), -300 + var_55_5.origin_y))), TARGET(var_55_5, LOG(OPACITY(250, 1, 0)))), CALL(function()
				var_55_4:removeAllChildren()
				
				var_55_4.move_effet = true
			end)), var_55_1, "block")
		end
	end
	
	if get_cocos_refid(arg_55_0.vars.portrait) then
		arg_55_0.vars.portrait:removeFromParent()
	end
end

function GrowthBoostUI.updateDeregister(arg_57_0)
	local var_57_0 = arg_57_0.vars.wnd:findChildByName("n_main")
	
	if get_cocos_refid(arg_57_0.vars.portrait) then
		arg_57_0.vars.portrait:removeFromParent()
	end
	
	local var_57_1 = arg_57_0.vars.wnd:findChildByName("n_bg_eff")
	
	UIAction:Add(SEQ(LOG(OPACITY(250, 1, 0)), CALL(function()
		var_57_1:removeAllChildren()
	end)), var_57_1, "block")
	
	local var_57_2 = GrowthBoost:getInfo()[1] or {}
	local var_57_3 = var_57_0:findChildByName("top")
	local var_57_4 = to_n(var_57_2.reg_uid) > 0
	
	if_set_visible(var_57_3, "n_register", not var_57_4)
	if_set_visible(var_57_3, "n_hero_result", var_57_4)
end

function GrowthBoostUI.effectUnlockLevelChange(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = arg_59_0.vars.wnd:findChildByName("n_main")
	local var_59_1 = var_59_0:findChildByName("bottom")
	local var_59_2 = var_59_1:findChildByName("n_deco")
	
	for iter_59_0 = 1, 4 do
		local var_59_3 = var_59_1:findChildByName("n_grade_" .. iter_59_0):findChildByName("hero_blessing_card")
		local var_59_4 = var_59_3:findChildByName("n_link")
		local var_59_5 = var_59_3:findChildByName("n_grade")
		local var_59_6 = var_59_3:findChildByName("n_base")
		local var_59_7 = var_59_5:findChildByName("n_" .. iter_59_0)
		local var_59_8 = var_59_7:findChildByName("n_on_eff")
		
		if_set_visible(var_59_7, "n_on", false)
		
		if get_cocos_refid(var_59_8) and get_cocos_refid(var_59_8.eff) then
			var_59_8.eff:stop()
			var_59_8.eff:removeFromParent()
			
			var_59_8.eff = nil
		end
		
		local var_59_9 = NONE()
		
		if iter_59_0 <= arg_59_2 then
			var_59_9 = DELAY(200 * (iter_59_0 - arg_59_1 - 1))
		end
		
		local var_59_10 = NONE()
		
		if_set_visible(var_59_2, "n_" .. iter_59_0, iter_59_0 <= arg_59_1)
		
		if arg_59_1 < iter_59_0 and iter_59_0 <= arg_59_2 then
			var_59_4:setVisible(false)
			var_59_4:setOpacity(0)
			
			local var_59_11 = var_59_2:findChildByName("n_" .. iter_59_0)
			
			var_59_11:setVisible(false)
			var_59_11:setOpacity(0)
			
			var_59_10 = SPAWN(TARGET(var_59_4, SEQ(SHOW(true), FADE_IN(200))), TARGET(var_59_11, SEQ(DELAY(400), SHOW(true), FADE_IN(200))))
		end
		
		if get_cocos_refid(var_59_3) then
			UIAction:Add(SEQ(var_59_9, SPAWN(var_59_10, DELAY(400), CALL(function()
				if_set_visible(var_59_3, "n_ability", arg_59_2 >= iter_59_0)
				if_set_visible(var_59_3, "n_on", arg_59_2 == iter_59_0)
				if_set_visible(var_59_3, "n_" .. iter_59_0, arg_59_2 >= iter_59_0)
				if_set_visible(var_59_3, "n_quest", arg_59_2 < iter_59_0)
				
				local var_60_0 = var_59_3:findChildByName("n_" .. iter_59_0)
				
				arg_59_0:makeSparkleEffect(var_60_0)
				if_set_visible(var_59_7, "n_on", arg_59_2 == iter_59_0)
				
				if arg_59_2 < iter_59_0 then
					var_59_6:setColor(cc.c3b(161, 161, 161))
				else
					var_59_6:setColor(cc.c3b(255, 255, 255))
				end
				
				if_set_visible(var_59_7, "n_ability", arg_59_2 <= iter_59_0)
				
				if arg_59_2 == iter_59_0 then
					UIAction:Add(SEQ(CALL(function()
						EffectManager:Play({
							scale = 2.4,
							fn = "ui_growtboost_unlock.cfx",
							layer = var_59_8
						})
					end), DELAY(800), CALL(function()
						local var_62_0 = var_59_0:findChildByName("n_hero")
						
						for iter_62_0 = 1, 4 do
							if_set_visible(var_62_0, "itxt_num" .. iter_62_0, iter_62_0 == arg_59_2)
						end
						
						GrowthBoostUI:updateUnitInfo(nil, {
							portrait_skip = true
						})
						
						var_59_8.eff = EffectManager:Play({
							scale = 2.4,
							fn = "ui_growtboost_current.cfx",
							layer = var_59_8
						})
					end), DELAY(600), CALL(GrowthBoostUI.showUnlockPopup, GrowthBoostUI, arg_59_1, arg_59_2)), var_59_8, "block")
				end
			end))), var_59_0, "block")
		end
	end
end

function GrowthBoostUI.showUnlockPopup(arg_63_0, arg_63_1, arg_63_2)
	if arg_63_2 == 1 then
		return 
	end
	
	local var_63_0 = math.max(arg_63_1, 1)
	local var_63_1 = load_dlg("hero_blessing_unlocked", true, "wnd")
	local var_63_2 = {
		open_effect = true,
		dlg = var_63_1
	}
	
	Dialog:msgBox(var_63_2)
	if_set(var_63_1, "txt_title", T("ui_gb_unlock_popup_title"))
	if_set(var_63_1, "txt_disc", T("ui_gb_unlock_popup_desc"))
	
	local var_63_3 = var_63_1:findChildByName("n_before")
	local var_63_4 = var_63_1:findChildByName("n_after")
	
	for iter_63_0 = 1, 4 do
		if_set_visible(var_63_3, "n_" .. iter_63_0, iter_63_0 == var_63_0)
		if_set_visible(var_63_4, "n_" .. iter_63_0, iter_63_0 == arg_63_2)
	end
end

function GrowthBoostUI.effectUnitRegister(arg_64_0)
	local var_64_0 = arg_64_0.vars.wnd:findChildByName("n_select")
	local var_64_1 = var_64_0:findChildByName("eff_pos")
	
	arg_64_0.vars.select_portrait = arg_64_0.vars.portrait
	
	local var_64_2 = arg_64_0.vars.select_portrait
	
	UIAction:Add(SEQ(CALL(function()
		EffectManager:Play({
			scale = 2.4,
			fn = "ui_growtboost_regist.cfx",
			layer = var_64_1
		})
	end), DELAY(160), CALL(function()
		GrowthBoostUI:setMode("Main")
	end)), var_64_0, "block")
	UIAction:Add(SEQ(SPAWN(RLOG(SCALE(600, 0.8, 6)), BLEND(10, "white", 0, 1), RLOG(OPACITY(600, 1, 0))), REMOVE()), var_64_2, "block")
end

function GrowthBoostUI.activeModeSelect(arg_67_0)
	if_set_visible(arg_67_0.vars.wnd, "n_select", true)
	arg_67_0:createHeroBelt()
	
	local var_67_0 = arg_67_0.vars.wnd:findChildByName("n_select")
	local var_67_1 = var_67_0:findChildByName("RIGHT")
	local var_67_2 = var_67_0:findChildByName("LEFT")
	local var_67_3 = var_67_0:findChildByName("n_bottom")
	
	var_67_1:setOpacity(0)
	var_67_2:setOpacity(0)
	var_67_3:setOpacity(0)
	var_67_1:setPositionX(300 + var_67_1.origin_x)
	var_67_2:setPositionX(-300 + var_67_2.origin_x)
	UIAction:Add(SPAWN(LOG(MOVE_TO(250, var_67_1.origin_x, 0)), LOG(OPACITY(250, 0, 1))), var_67_1, "block")
	UIAction:Add(SPAWN(LOG(MOVE_TO(250, var_67_2.origin_x, 0)), LOG(OPACITY(250, 0, 1))), var_67_2, "block")
	UIAction:Add(LOG(OPACITY(250, 0, 1)), var_67_3, "block")
	
	arg_67_0.right = var_67_1
	
	local var_67_4 = GrowthBoost:getGrowthLevel()
	local var_67_5 = GrowthBoost:getEffect(GrowthBoost:getGrowthLevel())
	local var_67_6 = var_67_2:findChildByName("n_grade")
	local var_67_7 = var_67_6:findChildByName("tag_lv")
	
	for iter_67_0 = 1, 4 do
		if_set_visible(var_67_6, "n_" .. iter_67_0, iter_67_0 == var_67_4)
		
		if iter_67_0 == var_67_4 then
			local var_67_8 = var_67_6:findChildByName("n_" .. iter_67_0)
			local var_67_9 = var_67_8:getChildByName("n_skillup")
			
			if var_67_9 then
				var_67_9:setVisible(false)
				
				local var_67_10 = to_n(var_67_5.skill_lv)
				
				if var_67_10 > 0 then
					var_67_9:setVisible(true)
					if_set(var_67_9, "skill_up", "+" .. var_67_10)
				end
			end
			
			UIUtil:setStars(var_67_8, to_n(var_67_5.grade), to_n(var_67_5.zodiac))
			
			local var_67_11, var_67_12 = UIUtil:setLevel(var_67_8, var_67_5.lv, nil, 2)
		end
	end
	
	local var_67_13 = arg_67_0.vars.select_unit
	
	if_set_visible(var_67_2, "n_none_hero", var_67_13 == nil)
	if_set_visible(var_67_2, "n_select_hero", var_67_13 ~= nil)
	if_set_visible(var_67_2:findChildByName("n_none_hero"), "n_ability", false)
end

function GrowthBoostUI.deactiveModeSelect(arg_68_0)
	local var_68_0 = arg_68_0.vars.wnd:findChildByName("n_select")
	local var_68_1 = var_68_0:findChildByName("RIGHT")
	local var_68_2 = var_68_0:findChildByName("LEFT")
	local var_68_3 = var_68_0:findChildByName("n_bottom")
	
	UIAction:Add(SPAWN(LOG(MOVE_TO(250, 300 + var_68_1.origin_x, 0)), LOG(OPACITY(250, 1, 0))), var_68_1, "block")
	UIAction:Add(SPAWN(LOG(MOVE_TO(250, -300 + var_68_2.origin_x, 0)), LOG(OPACITY(250, 1, 0))), var_68_2, "block")
	UIAction:Add(LOG(OPACITY(250, 1, 0)), var_68_3, "block")
	
	if arg_68_0.vars.belt and arg_68_0.vars.belt:isValid() then
		arg_68_0.vars.belt = nil
		
		HeroBelt:destroy()
	end
	
	if get_cocos_refid(arg_68_0.vars.portrait) then
		arg_68_0.vars.portrait:removeFromParent()
	end
	
	arg_68_0.vars.select_unit = nil
	arg_68_0.vars.changed_tm = nil
end

function GrowthBoostUI.createHeroBelt(arg_69_0)
	if not arg_69_0.vars then
		return 
	end
	
	if arg_69_0.vars.belt and arg_69_0.vars.belt:isValid() then
		arg_69_0.vars.belt = nil
		
		HeroBelt:destroy()
	end
	
	local var_69_0 = arg_69_0.vars.wnd:findChildByName("n_select")
	local var_69_1 = arg_69_0.vars.wnd:findChildByName("n_unit_list")
	local var_69_2 = "growth_boost"
	
	arg_69_0.vars.belt = HeroBelt:create(var_69_2)
	
	arg_69_0.vars.belt:setEventHandler(arg_69_0.onHeroListEvent, arg_69_0)
	arg_69_0.vars.belt:getWindow():setLocalZOrder(9999)
	var_69_1:addChild(arg_69_0.vars.belt:getWindow())
	
	arg_69_0.vars.belt_item_cnt = table.count(Account.units)
	
	HeroBelt:tempSaveFilter("growth_boost")
	HeroBelt:resetData(Account.units, var_69_2, nil, nil, nil)
	
	local var_69_3 = arg_69_0.vars.belt:getWindow():getPositionX()
end

function GrowthBoostUI.onHeroListEvent(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	if not arg_70_0.vars.belt or not arg_70_0.vars.belt:isValid() then
		return 
	end
	
	if arg_70_1 == "select" then
		local var_70_0 = HeroBelt:getCurrentItem()
		
		arg_70_0:onSelectUnit(var_70_0)
	end
	
	if arg_70_1 == "change" and arg_70_0.vars.belt:isScrolling() then
		arg_70_0.vars.change_event_tm = uitick()
		arg_70_0.vars.change_unit = arg_70_3
		
		vibrate(VIBRATION_TYPE.Select)
	end
end

function GrowthBoostUI.onAfterUpdate(arg_71_0, arg_71_1)
	if arg_71_0.vars then
		if not get_cocos_refid(arg_71_0.vars.wnd) then
			return 
		end
		
		if arg_71_0.vars.mode == "Select" then
			if (arg_71_0.vars.change_event_tm or 0) + 500 < uitick() and arg_71_0.vars.change_unit then
				arg_71_0:onSelectUnit(arg_71_0.vars.change_unit)
				
				arg_71_0.vars.change_unit = nil
				
				return 
			end
			
			if arg_71_0.vars.changed_tm and arg_71_0.vars.changed_tm + 300 > uitick() then
				return 
			end
			
			if not arg_71_0.vars.belt or arg_71_0.vars.belt:isScrolling() then
				return 
			end
			
			local var_71_0 = HeroBelt:getCurrentItem()
			
			arg_71_0:onSelectUnit(var_71_0)
		elseif arg_71_0.vars.mode == "Main" then
			local var_71_1 = GrowthBoost:getInfo()[1] or {}
			local var_71_2 = arg_71_0.vars.wnd:findChildByName("n_main"):findChildByName("top")
			local var_71_3 = to_n(var_71_1.reg_uid) > 0
			local var_71_4 = to_n(var_71_1.deregister_tm)
			
			if not var_71_3 then
				local var_71_5 = DEBUG.GB_TEST_COOLTIME or GAME_CONTENT_VARIABLE.gb_register_reset_cooltime or 259200
				local var_71_6 = var_71_4 + var_71_5 > os.time()
				
				if_set_visible(var_71_2, "n_register", not var_71_6)
				if_set_visible(var_71_2, "n_waiting", var_71_6)
				
				if var_71_6 then
					local var_71_7 = var_71_4 + var_71_5 - os.time()
					local var_71_8 = var_71_2:findChildByName("n_waiting")
					
					if get_cocos_refid(var_71_8) then
						if_set(var_71_8, "txt_info", T("ui_gb_cooltime", {
							time = sec_to_full_string(var_71_7)
						}))
					end
				end
			else
				if_set_visible(var_71_2, "n_register", false)
				if_set_visible(var_71_2, "n_waiting", false)
			end
		end
	end
end

function GrowthBoostUI.onSelectUnit(arg_72_0, arg_72_1)
	arg_72_0:updateUnitInfo(arg_72_1)
end

function GrowthBoostUI.updateUnitInfo(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = arg_73_0.vars.mode
	
	if not var_73_0 then
		return 
	end
	
	local var_73_1 = arg_73_0["updateUnitMode" .. var_73_0]
	
	if var_73_1 then
		var_73_1(arg_73_0, arg_73_1, arg_73_2)
	end
end

function GrowthBoostUI.updateUnitModeMain(arg_74_0, arg_74_1, arg_74_2)
	local var_74_0 = arg_74_1 or GrowthBoost:getGrowthUnit()
	
	if not var_74_0 then
		return 
	end
	
	local var_74_1 = arg_74_2 or {}
	local var_74_2 = arg_74_0.vars.wnd:findChildByName("n_main"):findChildByName("n_hero")
	local var_74_3 = var_74_2:findChildByName("n_mob_icon")
	local var_74_4 = var_74_0:getSkinCode() or var_74_0.db.code
	local var_74_5 = DEBUG.GROWTH_LEVEL or GrowthBoost:getGrowthLevel()
	
	UIUtil:getRewardIcon(nil, var_74_4, {
		no_popup = true,
		no_tooltip = true,
		hide_star = true,
		no_frame = true,
		no_count = true,
		monster = true,
		parent = var_74_3
	})
	
	for iter_74_0 = 1, 4 do
		if_set_visible(var_74_2, "itxt_num" .. iter_74_0, iter_74_0 == var_74_5)
	end
	
	if not var_74_1.portrait_skip then
		arg_74_0:updatePortrait(var_74_0)
	end
	
	local var_74_6 = var_74_2:findChildByName("n_before")
	local var_74_7 = var_74_2:findChildByName("n_after")
	local var_74_8 = var_74_6:findChildByName("n_etc")
	local var_74_9 = var_74_7:findChildByName("n_etc")
	
	for iter_74_1 = 1, 6 do
		if_set_visible(var_74_8, "star" .. iter_74_1, false)
		if_set_visible(var_74_9, "star" .. iter_74_1, false)
	end
	
	local var_74_10 = var_74_0:getGrade()
	
	UIUtil:setStars(var_74_8, var_74_10, var_74_0:getZodiacGrade())
	
	local var_74_11, var_74_12 = UIUtil:setLevel(var_74_8, var_74_0:getLv(), nil, 2)
	local var_74_13 = var_74_8:findChildByName("n_lv_num")
	
	if get_cocos_refid(var_74_13) then
		if not var_74_13.origin_x then
			var_74_13.origin_x = var_74_13:getPositionX()
		end
		
		var_74_13:setPositionX(var_74_11 < 2 and var_74_13.origin_x - 21 or var_74_13.origin_x)
	end
	
	local var_74_14 = var_74_0:getTotalSkillLevel()
	
	if_set_visible(var_74_6, "n_skillup", var_74_14 ~= 0)
	
	if var_74_14 > 0 then
		if_set(var_74_6, "skill_up", "+" .. var_74_14)
	end
	
	local var_74_15 = var_74_0:clone()
	local var_74_16 = DB("growth_boost", "growth_" .. to_n(var_74_5), "cs_id")
	
	if var_74_16 then
		var_74_15:addState(var_74_16)
		var_74_15:applyGrowthBoost()
		var_74_15:calc()
	end
	
	local var_74_17 = var_74_15:getGrade()
	
	UIUtil:setStars(var_74_9, var_74_17, var_74_15:getZodiacGrade())
	
	local var_74_18, var_74_19 = UIUtil:setLevel(var_74_9, var_74_15:getLv(), nil, 2)
	local var_74_20 = var_74_9:findChildByName("n_lv_num")
	
	if get_cocos_refid(var_74_20) then
		if not var_74_20.origin_x then
			var_74_20.origin_x = var_74_20:getPositionX()
		end
		
		var_74_20:setPositionX(var_74_18 < 2 and var_74_20.origin_x - 21 or var_74_20.origin_x)
	end
	
	local var_74_21 = var_74_15:getTotalSkillLevel()
	
	if_set_visible(var_74_7, "n_skillup", var_74_21 ~= 0)
	
	if var_74_21 > 0 then
		if_set(var_74_7, "skill_up", "+" .. var_74_21)
	end
end

function GrowthBoostUI.setScrollPause(arg_75_0, arg_75_1)
	if not arg_75_0.vars then
		return 
	end
	
	arg_75_0.vars.pause_scroll = arg_75_1
end

function GrowthBoostUI.getScrollPause(arg_76_0)
	if not arg_76_0.vars then
		return 
	end
	
	return arg_76_0.vars.pause_scroll
end

function GrowthBoostUI.updateUnitModeSelect(arg_77_0, arg_77_1)
	if arg_77_0.vars.select_unit == arg_77_1 then
		return 
	end
	
	if arg_77_0:getScrollPause() then
		return 
	end
	
	local var_77_0 = arg_77_0.vars.wnd:findChildByName("n_select")
	local var_77_1 = var_77_0:findChildByName("RIGHT")
	local var_77_2 = var_77_0:findChildByName("LEFT")
	
	if_set_visible(var_77_0, "n_bottom", arg_77_1 ~= nil)
	
	if not arg_77_1 then
		arg_77_0.vars.select_unit = nil
		
		local var_77_3 = arg_77_0.vars.wnd:findChildByName("n_select")
		
		if_set_visible(var_77_2, "n_none_hero", true)
		if_set_visible(var_77_2, "n_select_hero", false)
		
		if get_cocos_refid(arg_77_0.vars.portrait) then
			arg_77_0.vars.portrait:removeFromParent()
		end
		
		return 
	end
	
	local var_77_4 = var_77_0:findChildByName("port_pos")
	local var_77_5 = arg_77_1:getSkinCode() or arg_77_1.db.code
	local var_77_6, var_77_7, var_77_8, var_77_9 = DB("character", var_77_5, {
		"name",
		"role",
		"grade",
		"face_id"
	})
	
	if get_cocos_refid(arg_77_0.vars.portrait) then
		if false then
			arg_77_0.vars.portrait:removeFromParent()
		else
			local var_77_10 = 600
			
			if arg_77_0.vars.portrait.is_model then
				UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, var_77_10), 300), FADE_OUT(250)), REMOVE()), arg_77_0.vars.portrait)
			else
				UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, var_77_10), 300), FADE_OUT(250)), REMOVE_SPRITE()), arg_77_0.vars.portrait)
			end
		end
	end
	
	arg_77_0.vars.select_unit = arg_77_1
	arg_77_0.vars.changed_tm = uitick()
	
	if GrowthBoost:isUnregisterable(arg_77_1) then
		if_set_visible(var_77_2, "n_none_hero", true)
		if_set_visible(var_77_2, "n_select_hero", false)
		
		return 
	end
	
	local var_77_11, var_77_12 = UIUtil:getPortraitAni(var_77_9, {
		parent_pos_y = var_77_4:getPositionY() + 40
	})
	
	if var_77_11 then
		if not var_77_12 then
			var_77_11:setAnchorPoint(0.5, 0.1)
		else
			var_77_11:setAnchorPoint(0.5, 0)
		end
		
		var_77_11:setLocalZOrder(1)
		var_77_11:setPositionX(0)
		var_77_4:addChild(var_77_11)
		
		arg_77_0.vars.portrait = var_77_11
		arg_77_0.vars.portrait.unit = arg_77_1
		
		local var_77_13 = arg_77_1:getFaceID()
		
		if var_77_13 and var_77_11 and var_77_11.setSkin then
			var_77_11:setSkin(var_77_13)
		end
		
		local var_77_14 = 1600
		
		var_77_11:setOpacity(0)
		UIAction:Add(SEQ(SPAWN(LOG(SCALE(250, 0, 0.8), 300), LOG(SLIDE_IN(250, var_77_14, false), 300), FADE_IN(250))), var_77_11)
	end
	
	if false then
		var_77_11:setScale(0.8)
	end
	
	arg_77_0:updateLeftInfo(arg_77_1)
end

function GrowthBoostUI.updateLeftInfo(arg_78_0, arg_78_1)
	if not arg_78_0.vars then
		return 
	end
	
	local var_78_0 = arg_78_1 or arg_78_0.vars.portrait.unit
	local var_78_1 = arg_78_0.vars.wnd:findChildByName("n_select"):findChildByName("LEFT")
	
	if_set_visible(var_78_1, "n_none_hero", var_78_0 == nil)
	if_set_visible(var_78_1, "n_select_hero", var_78_0 ~= nil)
	
	local var_78_2 = var_78_1:findChildByName("n_select_hero"):findChildByName("n_ability")
	local var_78_3 = var_78_2:findChildByName("n_lv")
	local var_78_4 = var_78_2:findChildByName("n_etc")
	
	for iter_78_0 = 1, 6 do
		if_set_visible(var_78_4, "star" .. iter_78_0, false)
	end
	
	local var_78_5 = var_78_0:getGrade()
	
	UIUtil:setStars(var_78_4, var_78_5, var_78_0:getZodiacGrade())
	
	local var_78_6, var_78_7 = UIUtil:setLevel(var_78_3, var_78_0:getLv(), nil, 2)
	
	if not var_78_4.origin_x then
		var_78_4.origin_x = var_78_4:getPositionX()
	end
	
	var_78_4:setPositionX(var_78_4.origin_x + 8 * (6 - var_78_5))
	
	local var_78_8 = var_78_2:findChildByName("n_lv")
	local var_78_9 = var_78_2:findChildByName("n_lv_num")
	
	if get_cocos_refid(var_78_8) then
		if not var_78_8.origin_x then
			var_78_8.origin_x = var_78_8:getPositionX()
		end
		
		var_78_8:setPositionX(var_78_6 < 2 and var_78_8.origin_x + 10 or var_78_8.origin_x)
	end
	
	if get_cocos_refid(var_78_8) then
		if not var_78_9.origin_x then
			var_78_9.origin_x = var_78_9:getPositionX()
		end
		
		var_78_9:setPositionX(var_78_6 < 2 and var_78_9.origin_x - 18 or var_78_9.origin_x)
	end
	
	local var_78_10 = var_78_0:getTotalSkillLevel()
	local var_78_11 = var_78_2:getChildByName("n_skillup")
	
	if not var_78_11.origin_x then
		var_78_11.origin_x = var_78_11:getPositionX()
	end
	
	if var_78_11 then
		var_78_11:setVisible(var_78_10 ~= 0)
		
		if var_78_10 == 0 then
			var_78_4:setPositionX(var_78_4:getPositionX() + 14)
		else
			var_78_11:setPositionX(var_78_11.origin_x - 8 * (6 - var_78_5) - 8 * (6 - var_78_5))
		end
		
		if var_78_10 > 0 then
			if_set(var_78_11, "skill_up", "+" .. var_78_10)
		end
	end
end

function GrowthBoostUI.fillGrowthInfo(arg_79_0, arg_79_1)
end
