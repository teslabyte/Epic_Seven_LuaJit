UnitDetailGrowth = {}

function MsgHandler.set_main_unit(arg_1_0)
	if arg_1_0.uid then
		local var_1_0 = Account:updateMainUnitId(arg_1_0.uid)
		
		UnitDetailGrowth:updateMainUnitButton()
		
		local var_1_1 = HeroBelt:getInst("UnitMain")
		
		var_1_1:updateUnit(nil, Account:getUnit(var_1_0))
		var_1_1:updateUnit(nil, Account:getUnit(arg_1_0.uid))
		balloon_message_with_sound("unit_detail_main_char_regist")
	end
end

function MsgHandler.lock_unit(arg_2_0)
	if arg_2_0.flag then
		SoundEngine:play("event:/ui/unit_detail/btn_lock")
	else
		SoundEngine:play("event:/ui/unit_detail/btn_unlock")
	end
	
	UnitDetailGrowth:lock(arg_2_0.uid, arg_2_0.flag)
end

function MsgHandler.set_favorite_unit(arg_3_0)
	if arg_3_0.target and arg_3_0.unit_opt then
		local var_3_0 = Account:getUnit(arg_3_0.target)
		
		if not var_3_0 then
			return 
		end
		
		var_3_0:updateUnitOptionValue(arg_3_0.unit_opt)
		UnitDetailGrowth:setFavoriteUnit(var_3_0)
	end
end

function UnitDetailGrowth.onCreate(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or {}
	
	if not get_cocos_refid(arg_4_1.detail_wnd) then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.menu_wnd = arg_4_1.detail_wnd:getChildByName("n_menu_hero")
	
	arg_4_0:initUI()
end

function UnitDetailGrowth.initUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.menu_wnd) then
		return 
	end
	
	arg_5_0.vars.left = arg_5_0.vars.menu_wnd:getChildByName("left_hero")
	arg_5_0.vars.center = arg_5_0.vars.menu_wnd:getChildByName("center_hero")
	
	local var_5_0 = arg_5_0.vars.left:getChildByName("n_btn")
	
	if get_cocos_refid(var_5_0) then
		arg_5_0.vars.btn_classchange = var_5_0:getChildByName("btn_classchange")
	end
	
	if IS_PUBLISHER_ZLONG then
		local var_5_1 = arg_5_0.vars.left:getChildByName("n_btn_zl")
		
		if_set_visible(var_5_0, nil, false)
		if_set_visible(var_5_1, nil, true)
		
		if get_cocos_refid(var_5_1) then
			arg_5_0.vars.btn_classchange = var_5_1:getChildByName("btn_classchange")
		end
	end
end

function UnitDetailGrowth.isVisible(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.menu_wnd) then
		return false
	end
	
	return arg_6_0.vars.menu_wnd:isVisible()
end

function UnitDetailGrowth.onRelease(arg_7_0)
end

function UnitDetailGrowth.onEnter(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.menu_wnd) then
		return 
	end
	
	arg_8_0:enterUI()
end

function UnitDetailGrowth.onLeave(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.menu_wnd) then
		return 
	end
	
	arg_9_0:leaveUI()
end

function UnitDetailGrowth.enterUI(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.menu_wnd) then
		return 
	end
	
	arg_10_0.vars.menu_wnd:setVisible(true)
	arg_10_0.vars.menu_wnd:setOpacity(0)
	
	local var_10_0 = arg_10_0.vars.left
	local var_10_1 = arg_10_0.vars.center
	
	var_10_0:getChildByName("n_skills"):setOpacity(0)
	var_10_0:getChildByName("btn_sub"):setOpacity(0)
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_10_0:getChildByName("name"), "block")
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_10_0:getChildByName("n_dim"), "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_IN(200, 600)), var_10_0:getChildByName("n_skills"), "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_IN(200, 600)), var_10_0:getChildByName("btn_sub"), "block")
	UIAction:Add(SLIDE_IN_Y(200, 300), var_10_1, "block")
	UIAction:Add(FADE_IN(400), arg_10_0.vars.menu_wnd, "block")
	
	local var_10_2 = UnitDetail:getHeroBelt()
	
	if var_10_2 then
		var_10_2:setTouchEnabled(true)
		var_10_2:setScrollEnabled(true)
	end
end

function UnitDetailGrowth.leaveUI(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.menu_wnd) then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.left
	local var_11_1 = arg_11_0.vars.center
	
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_11_0:getChildByName("name"), "block")
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_11_0:getChildByName("n_dim"), "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_OUT(200, -600)), var_11_0:getChildByName("n_skills"), "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_OUT(200, -600)), var_11_0:getChildByName("btn_sub"), "block")
	UIAction:Add(SLIDE_OUT_Y(200, -300), var_11_1, "block")
	UIAction:Add(SEQ(DELAY(400), SHOW(false)), arg_11_0.vars.menu_wnd, "block")
	ShareChatPopup:close()
	arg_11_0:closeBGPacks()
	arg_11_0:closeGrowthBoostTooltip()
	arg_11_0:closeMoonlightDestinyTooltip()
end

function UnitDetailGrowth.updateUnitInfo(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.menu_wnd) then
		return 
	end
	
	arg_12_1 = arg_12_1 or arg_12_0.vars.unit
	
	local var_12_0 = UnitDetail:getHeroBelt()
	
	if var_12_0 then
		var_12_0:updateUnit(nil, arg_12_1)
	end
	
	arg_12_0.vars.unit = arg_12_1
	
	arg_12_0:setUIUnitInfo(arg_12_1)
	
	local var_12_1 = arg_12_0.vars.menu_wnd:getChildByName("txt_name")
	
	var_12_1:setString(T(arg_12_1.db.name))
	UIUserData:proc(var_12_1)
	if_call(arg_12_0.vars.menu_wnd, "star1", "setPositionX", 10 + var_12_1:getContentSize().width * var_12_1:getScaleX() + var_12_1:getPositionX())
	UIUtil:setUnitAllInfo(arg_12_0.vars.menu_wnd, arg_12_1)
	UIUtil:setLevelDetail(arg_12_0.vars.menu_wnd, arg_12_1:getLv(), arg_12_1:getMaxLevel())
	
	if not arg_12_0.vars.n_dedi then
		arg_12_0.vars.n_dedi = arg_12_0.vars.menu_wnd:getChildByName("n_dedi")
	end
	
	UIUtil:setDevoteDetail_new(arg_12_0.vars.n_dedi, arg_12_1, {
		view_next_level = true,
		is_skill_text_CRLF = true
	})
	UIUtil:setUnitSkillInfo(arg_12_0.vars.menu_wnd, arg_12_1, {
		delay = 0,
		style = "scale",
		no_change_pos = true,
		tooltip_opts = {
			show_effs = "right"
		}
	})
	arg_12_0:updateButtons()
	
	if arg_12_0.vars.unit:isGrowthBoostRegistered() then
		local var_12_2 = arg_12_0.vars.unit:clone()
		
		GrowthBoost:apply(var_12_2)
		UIUtil:setUnitSkillInfo(arg_12_0.vars.menu_wnd, var_12_2, {
			delay = 0,
			style = "scale",
			no_change_pos = true,
			tooltip_opts = {
				show_effs = "right"
			}
		})
		
		var_12_2.inst.locked = arg_12_0.vars.unit:isLocked()
		
		UIUtil:setUnitAllInfo(arg_12_0.vars.menu_wnd, var_12_2)
		UIUtil:setLevelDetail(arg_12_0.vars.menu_wnd, var_12_2:getLv(), var_12_2:getMaxLevel())
	end
	
	GrowthGuideNavigator:proc()
	
	local var_12_3 = not arg_12_1:isPromotionUnit() and not arg_12_1:isExpUnit()
	
	var_12_3 = var_12_3 and not arg_12_1:isDevotionUnit()
	
	if var_12_3 then
		TutorialNotice:update("unit_ui", {
			unit = arg_12_1
		})
	end
end

function UnitDetailGrowth.updateButtons(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.menu_wnd) then
		return 
	end
	
	arg_13_1 = arg_13_1 or arg_13_0.vars.unit
	
	if not arg_13_1 then
		return 
	end
	
	arg_13_0:updateSkillTreeInfo(arg_13_1)
	arg_13_0:updateShareButton(arg_13_1)
	arg_13_0:updateLvupBtnState(arg_13_1)
	arg_13_0:updateRecallButton(arg_13_1)
	arg_13_0:updateGrowthBoostButton(arg_13_1)
	arg_13_0:updateMainUnitButton(arg_13_1)
	arg_13_0:updateFavoriteButton(arg_13_1)
	arg_13_0:updateSkillUpgradeButton(arg_13_1)
	arg_13_0:updateZodiacButton(arg_13_1)
end

function UnitDetailGrowth.updateUnitDevoteInfo(arg_14_0, arg_14_1)
	if not arg_14_0:isVisible() or not arg_14_0.vars.unit then
		return 
	end
	
	arg_14_1 = arg_14_1 or arg_14_0.vars.unit
	
	if not arg_14_1 then
		return 
	end
	
	if not arg_14_0.vars.n_dedi then
		arg_14_0.vars.n_dedi = arg_14_0.vars.menu_wnd:getChildByName("n_dedi")
	end
	
	UIUtil:setDevoteDetail_new(arg_14_0.vars.n_dedi, arg_14_1, {
		view_next_level = true
	})
	
	if arg_14_1:isGrowthBoostRegistered() then
		local var_14_0 = arg_14_1:clone()
		
		GrowthBoost:apply(var_14_0)
		
		arg_14_1 = var_14_0
	end
	
	UIUtil:setUnitAllInfo(arg_14_0.vars.menu_wnd, arg_14_1)
end

function UnitDetailGrowth.setUIUnitInfo(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.menu_wnd) or not get_cocos_refid(arg_15_0.vars.center) then
		return 
	end
	
	arg_15_1 = arg_15_1 or arg_15_0.vars.unit
	
	if not arg_15_1 then
		return 
	end
	
	if_set_visible(arg_15_0.vars.center, "n_info", false)
	if_set_visible(arg_15_0.vars.center, "n_info_material", false)
	if_set_visible(arg_15_0.vars.center, "n_info_moonlight_destiny", false)
	if_set_visible(arg_15_0.vars.center, "btn_info_material", arg_15_1:isMerEnhanceProceeding())
	if_set_visible(arg_15_0.vars.center, "n_blessing", false)
	if_set_visible(arg_15_0.vars.center, "n_info_blessing", false)
	
	if arg_15_1:isExpUnit() or arg_15_1:isPromotionUnit() then
		arg_15_0:setUIDescMaterialInfo(arg_15_1)
	elseif arg_15_1:isDevotionUnit() or arg_15_1:isMerEnhanceProceeding() then
		arg_15_0:setUIDescUnitInfo(arg_15_1)
	elseif arg_15_1:isMoonlightDestinyUnit() then
		arg_15_0:setUIMoonlightDestinyUnitInfo(arg_15_1)
	end
	
	arg_15_0:setUIGrowthBoostUnitInfo(arg_15_1)
end

function UnitDetailGrowth.setUIDescMaterialInfo(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.menu_wnd) or not get_cocos_refid(arg_16_0.vars.center) then
		return 
	end
	
	arg_16_1 = arg_16_1 or arg_16_0.vars.unit
	
	if not arg_16_1 then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.center:getChildByName("n_info_material")
	
	if not get_cocos_refid(var_16_0) then
		return 
	end
	
	if_set_visible(var_16_0, nil, true)
	if_set_visible(var_16_0, "grow", true)
	
	local var_16_1 = var_16_0:getChildByName("txt_info")
	
	if not get_cocos_refid(var_16_1) then
		return 
	end
	
	local function var_16_2()
		if arg_16_1:isPromotionUnit() then
			return "ui_detail_main_desc_promotion"
		end
		
		if arg_16_1:isExpUnit() then
			return "ui_detail_main_desc_xpup"
		end
		
		return ""
	end
	
	if_set(var_16_1, nil, T(var_16_2()))
	if_set_visible(var_16_0, "noti_infor", arg_16_1:isMerEnhanceProceeding())
	
	local var_16_3 = var_16_0:getChildByName("cm_icon_etcinfor")
	
	if not get_cocos_refid(var_16_3) then
		return 
	end
	
	local var_16_4 = arg_16_0.vars.infoIconPosY or 200
	local var_16_5 = var_16_1:getStringNumLines()
	
	if var_16_5 > 1 then
		var_16_4 = var_16_4 + 20 * (var_16_5 - 1)
	end
	
	var_16_3:setPositionY(var_16_4)
end

function UnitDetailGrowth.setUIDescUnitInfo(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.menu_wnd) or not get_cocos_refid(arg_18_0.vars.center) then
		return 
	end
	
	arg_18_1 = arg_18_1 or arg_18_0.vars.unit
	
	if not arg_18_1 then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.center:getChildByName("n_info")
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	if_set_visible(var_18_0, nil, true)
	if_set_visible(var_18_0, "grow", true)
	
	local var_18_1 = var_18_0:getChildByName("txt_info")
	
	if not get_cocos_refid(var_18_1) then
		return 
	end
	
	local function var_18_2()
		local var_19_0 = DB("character_reference", arg_18_1.db.code, {
			"self_promo_desc"
		})
		
		if var_19_0 then
			return T(var_19_0)
		end
		
		if arg_18_1:isMerEnhanceProceeding() then
			return T("poe17_clear_desc")
		end
		
		if arg_18_1:isDevotionUnit() then
			return T("self_promo_desc_devotion", {
				name = T(arg_18_1.db.name)
			})
		end
		
		return ""
	end
	
	if_set(var_18_1, nil, var_18_2())
	if_set_visible(var_18_0, "noti_infor", arg_18_1:isMerEnhanceProceeding())
	
	local var_18_3 = var_18_0:getChildByName("cm_icon_etcinfor")
	
	if not get_cocos_refid(var_18_3) then
		return 
	end
	
	local var_18_4 = arg_18_0.vars.infoIconPosY or 200
	local var_18_5 = var_18_1:getStringNumLines()
	
	if var_18_5 > 1 then
		var_18_4 = var_18_4 + 20 * (var_18_5 - 1)
	end
	
	var_18_3:setPositionY(var_18_4)
end

function UnitDetailGrowth.setUIMoonlightDestinyUnitInfo(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.menu_wnd) or not get_cocos_refid(arg_20_0.vars.center) then
		return 
	end
	
	arg_20_1 = arg_20_1 or arg_20_0.vars.unit
	
	if not arg_20_1 then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.center:getChildByName("n_info_moonlight_destiny")
	
	if not get_cocos_refid(var_20_0) then
		return 
	end
	
	if_set_visible(var_20_0, nil, true)
	
	local function var_20_1()
		if arg_20_1:isLockArenaAndClan() then
			return T("character_mc_cannot_desc", {
				character_id = T(arg_20_1.db.name)
			})
		end
		
		return T("character_mc_cannot_desc2", {
			character_id = T(arg_20_1.db.name)
		})
	end
	
	if_set(var_20_0, "txt_info", var_20_1())
end

function UnitDetailGrowth.setUIGrowthBoostUnitInfo(arg_22_0, arg_22_1)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.menu_wnd) or not get_cocos_refid(arg_22_0.vars.center) then
		return 
	end
	
	arg_22_1 = arg_22_1 or arg_22_0.vars.unit
	
	if not arg_22_1 then
		return 
	end
	
	local var_22_0 = arg_22_1:isGrowthBoostRegistered()
	
	if_set_visible(arg_22_0.vars.center, "n_blessing", var_22_0)
	if_set_visible(arg_22_0.vars.center, "n_info_blessing", var_22_0)
	
	local var_22_1 = arg_22_0.vars.center:getChildByName("n_info")
	local var_22_2 = arg_22_0.vars.center:getChildByName("n_info_material")
	local var_22_3 = arg_22_0.vars.center:getChildByName("n_info_blessing")
	local var_22_4 = false
	
	if get_cocos_refid(var_22_1) and var_22_1:isVisible() then
		var_22_1.origin_y = var_22_1.origin_y or var_22_1:getPositionY()
		
		var_22_1:setPositionY(var_22_1.origin_y + (var_22_0 and 100 or 0))
		
		if var_22_0 then
			if_set_visible(var_22_1, "grow", false)
			
			var_22_4 = true
		end
	end
	
	if get_cocos_refid(var_22_2) and var_22_2:isVisible() then
		var_22_2.origin_y = var_22_2.origin_y or var_22_2:getPositionY()
		
		var_22_2:setPositionY(var_22_2.origin_y + (var_22_0 and 100 or 0))
		
		if var_22_0 then
			if_set_visible(var_22_2, "grow", false)
			
			var_22_4 = true
		end
	end
	
	if get_cocos_refid(var_22_3) then
		local var_22_5 = var_22_3:findChildByName("grow")
		
		if get_cocos_refid(var_22_5) then
			var_22_5.origin_scale_y = var_22_5.origin_scale_y or var_22_5:getScaleY()
			
			var_22_5:setScaleY(var_22_4 and 2.62 or var_22_5.origin_scale_y)
		end
		
		if var_22_3:isVisible() then
			if_set(var_22_3, "txt_info", T("ui_unit_detail_bless_limit_desc", {
				character_id = T(arg_22_1.db.name)
			}))
		end
	end
end

function UnitDetailGrowth.updateRateButton(arg_23_0, arg_23_1)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.menu_wnd) then
		return 
	end
	
	arg_23_1 = arg_23_1 or arg_23_0.vars.unit
	
	if not arg_23_1 then
		return 
	end
	
	if_set_visible(arg_23_0.vars.menu_wnd, "btn_rate", UnitInfosUtil:isDetailInfoUnit(arg_23_1))
end

function UnitDetailGrowth.updateSkillTreeInfo(arg_24_0, arg_24_1)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.menu_wnd) then
		return 
	end
	
	arg_24_1 = arg_24_1 or arg_24_0.vars.unit
	
	if not arg_24_1 then
		return 
	end
	
	local var_24_0 = UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE) and arg_24_1:isClassChangeableUnit()
	
	if_set_visible(arg_24_0.vars.btn_classchange, nil, var_24_0)
	
	if var_24_0 then
		local var_24_1 = arg_24_1:getSTreeTotalPoint()
		
		if_set(arg_24_0.vars.btn_classchange, "txt_skill_up", "+" .. var_24_1)
		if_set_visible(arg_24_0.vars.btn_classchange, "skill_up", var_24_1 > 0)
	end
end

function UnitDetailGrowth.updateShareButton(arg_25_0, arg_25_1)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.menu_wnd) or not get_cocos_refid(arg_25_0.vars.left) then
		return 
	end
	
	arg_25_1 = arg_25_1 or arg_25_0.vars.unit
	
	if not arg_25_1 then
		return 
	end
	
	local var_25_0 = ShareUnitUtil:checkSharableUnit(arg_25_1)
	
	if_set_visible(arg_25_0.vars.left, "Img_line_1", var_25_0)
	if_set_visible(arg_25_0.vars.left, "btn_share", var_25_0)
end

function UnitDetailGrowth.updateLvupBtnState(arg_26_0, arg_26_1)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.menu_wnd) then
		return 
	end
	
	arg_26_1 = arg_26_1 or arg_26_0.vars.unit
	
	if not arg_26_1 then
		return 
	end
	
	local var_26_0 = (not arg_26_1:isMaxLevel() or not (arg_26_1:getGrade() >= 6)) and not arg_26_1:isDevotionUnit() and not arg_26_1:isExpUnit()
	local var_26_1
	
	if BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(arg_26_1:getUID()) then
		var_26_0 = false
		var_26_1 = "msg_bgbattle_cant_levelup"
	end
	
	local var_26_2 = arg_26_0.vars.menu_wnd:getChildByName("btn_lv_up")
	
	if get_cocos_refid(var_26_2) then
		local var_26_3 = arg_26_0.vars.unit:isMaxLevel() and "promote" or "unit_menu_levelup"
		
		UIUtil:changeButtonState(var_26_2, var_26_0, var_26_1)
		if_set(var_26_2, "label", T(var_26_3))
		
		var_26_2.guide_tag = var_26_3
	end
	
	if_set(arg_26_0.vars.menu_wnd, "txt_enhance", T("ui_memorize_clear_title"))
	
	local var_26_4, var_26_5 = UnitInfosUtil:isEnableUpgrade(arg_26_1)
	local var_26_6 = arg_26_0.vars.menu_wnd:getChildByName("btn_upgrade")
	
	UIUtil:changeButtonState(var_26_6, var_26_4, var_26_5)
	if_set_visible(arg_26_0.vars.menu_wnd, "alert_upgrade", arg_26_1:isUpgradeable())
end

function UnitDetailGrowth.updateRecallButton(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.menu_wnd) then
		return 
	end
	
	arg_27_1 = arg_27_1 or arg_27_0.vars.unit
	
	if not arg_27_1 then
		return 
	end
	
	local var_27_0 = false
	
	if AccountData.recall_info then
		local var_27_1 = arg_27_0.vars.unit.db.code
		local var_27_2 = AccountData.recall_info.recall_period.units[var_27_1]
		
		if var_27_2 and var_27_2.start_time and var_27_2.end_time and var_27_2.start_time < os.time() and var_27_2.end_time > os.time() and var_27_2.start_time > (arg_27_0.vars.unit.inst.ct or os.time()) then
			if var_27_2.skill_only then
				if arg_27_0.vars.unit:getUnitOptionValue("stigma_skill_enhance") ~= 1 and to_n(arg_27_0.vars.unit:getTotalSkillLevel()) > 0 then
					var_27_0 = true
					
					if_set(arg_27_0.vars.menu_wnd:getChildByName("btn_recall"), "txt", T("ui_btn_skillreset"))
				end
			elseif arg_27_0.vars.unit:getLv() >= 50 and (AccountData.recall_info.recalled_units[var_27_1] == nil or to_n(AccountData.recall_info.recalled_units[var_27_1].last_recall) < var_27_2.end_time) then
				var_27_0 = true
				
				if_set(arg_27_0.vars.menu_wnd:getChildByName("btn_recall"), "txt", T("ui_unit_detail_btn_recall"))
			end
		end
	end
	
	if_set_visible(arg_27_0.vars.menu_wnd, "btn_recall", var_27_0)
end

function UnitDetailGrowth.updateGrowthBoostButton(arg_28_0, arg_28_1)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.menu_wnd) then
		return 
	end
	
	arg_28_1 = arg_28_1 or arg_28_0.vars.unit
	
	if not arg_28_1 then
		return 
	end
	
	if_set_visible(arg_28_0.vars.menu_wnd, "btn_blessing_go", arg_28_1:isGrowthBoostRegistered())
end

function UnitDetailGrowth.updateFavoriteButton(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.menu_wnd) or not get_cocos_refid(arg_29_0.vars.left) then
		return 
	end
	
	arg_29_1 = arg_29_1 or arg_29_0.vars.unit
	
	if not arg_29_1 then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.left:getChildByName("pos_favorites")
	
	if arg_29_1:isFavoriteUnit() then
		if_set_visible(var_29_0, "btn_favorites", false)
		if_set_visible(var_29_0, "btn_favorites_done", true)
	else
		if_set_visible(var_29_0, "btn_favorites", true)
		if_set_visible(var_29_0, "btn_favorites_done", false)
	end
end

function UnitDetailGrowth.updateSkillUpgradeButton(arg_30_0, arg_30_1)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.menu_wnd) then
		return 
	end
	
	arg_30_1 = arg_30_1 or arg_30_0.vars.unit
	
	if not arg_30_1 then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.menu_wnd:getChildByName("btn_skill")
	
	if get_cocos_refid(var_30_0) then
		local var_30_1 = arg_30_1:isSpecialUnit() or arg_30_1:isPromotionUnit() or arg_30_1:isDevotionUnit()
		
		UIUtil:changeButtonState(var_30_0, not var_30_1, true)
		
		local var_30_2 = SAVE:getKeep(NOTI_UNIT_SKILL_UPGRADE .. arg_30_1:getUID())
		
		if_set_visible(var_30_0, "alert_skill", arg_30_1:skillPointNoti() and not var_30_2)
	end
end

function UnitDetailGrowth.updateZodiacButton(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.menu_wnd) then
		return 
	end
	
	arg_31_1 = arg_31_1 or arg_31_0.vars.unit
	
	if not arg_31_1 then
		return 
	end
	
	local var_31_0 = UnitInfosUtil:isEnableAwake(arg_31_1)
	local var_31_1 = arg_31_0.vars.menu_wnd:getChildByName("btn_zodiac")
	
	if get_cocos_refid(var_31_1) then
		if_set_sprite(var_31_1, "icon", var_31_0 and "img/icon_menu_awake_p.png" or "img/icon_menu_awake.png")
		
		local var_31_2
		
		if var_31_0 then
			UIUtil:changeButtonState(var_31_1, true)
			if_set_visible(var_31_1, "alert_zodiac", arg_31_1:isAwakeUpgradable())
			
			var_31_2 = T("ui_unit_zodiac2_btn_awake")
		else
			local var_31_3 = UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC)
			
			UIUtil:changeButtonState(var_31_1, arg_31_1:checkZodiac() and var_31_3)
			if_set_visible(arg_31_0.vars.menu_wnd, "icon_locked_zodiac", arg_31_1:checkZodiac() and not var_31_3)
			if_set_visible(var_31_1, "alert_zodiac", Account:isZodiacUpgradableUnit(arg_31_0.vars.unit) and UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC))
			
			var_31_2 = T("ui_unit_detail_btnzodiac_label")
		end
		
		if_set(var_31_1, "label", var_31_2)
	end
end

function UnitDetailGrowth.reqToggleFavorite(arg_32_0)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.menu_wnd) then
		return 
	end
	
	if not arg_32_0.vars.unit then
		return 
	end
	
	query("set_favorite_unit", {
		target = arg_32_0.vars.unit:getUID(),
		flag = not arg_32_0.vars.unit:isFavoriteUnit()
	})
end

function UnitDetailGrowth.setFavoriteUnit(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.menu_wnd) then
		return 
	end
	
	arg_33_1 = arg_33_1 or arg_33_0.vars.unit
	
	if not arg_33_1 then
		return 
	end
	
	if arg_33_1:isFavoriteUnit() then
		balloon_message_with_sound_raw_text(T_KR("hero_bookmark_add", {
			name = T(arg_33_1.db.name)
		}))
	else
		balloon_message_with_sound_raw_text(T_KR("hero_bookmark_del", {
			name = T(arg_33_1.db.name)
		}))
	end
	
	local var_33_0 = UnitDetail:getHeroBelt()
	
	if var_33_0 then
		var_33_0:update()
		var_33_0:scrollToUnit(arg_33_1, 0.6)
		var_33_0:updateSelectedControlColor(arg_33_1)
	end
	
	arg_33_0:updateFavoriteButton(arg_33_1)
end

function UnitDetailGrowth.shareUnit(arg_34_0)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.menu_wnd) or not arg_34_0.vars.unit then
		return 
	end
	
	local var_34_0 = arg_34_0.vars.menu_wnd:getParent()
	
	ShareChatPopup:open({
		uid = arg_34_0.vars.unit:getUID(),
		parent_layer = var_34_0:getChildByName("n_share_chat")
	})
end

function UnitDetailGrowth.onSelectBackground(arg_35_0, arg_35_1, arg_35_2)
	if_set_sprite(arg_35_0.vars.bg_change, "bg_base", arg_35_2.icon)
	if_set(arg_35_0.vars.bg_change, "txt_title", T(arg_35_2.name))
	if_set(arg_35_0.vars.bg_change, "txt_desc", T(arg_35_2.desc))
	
	if arg_35_0.vars.bg_idx ~= arg_35_1 then
		UnitMain:setBackground(arg_35_2, true)
		UnitMain:fadeInOut()
		SAVE:setKeep("unit_detail_bg_id", arg_35_2.id)
	end
	
	arg_35_0.vars.bg_idx = arg_35_1
end

function UnitDetailGrowth.showBGPacks(arg_36_0)
	if not arg_36_0:isVisible() then
		return 
	end
	
	local var_36_0 = UnitDetail:getWnd()
	
	if not get_cocos_refid(var_36_0) then
		return 
	end
	
	if UIAction:Find("bg.fade") then
		return 
	end
	
	if arg_36_0.vars.bg_change or arg_36_0.vars.focus then
		return 
	end
	
	local var_36_1 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
	local var_36_2 = DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left"
	local var_36_3 = var_36_2 and 0 or  / 2
	
	var_36_1 = not var_36_2 and 0 or var_36_1 / 2
	
	local var_36_4 = load_control("wnd/bg_change_popup.csb")
	
	var_36_4:setPosition(VIEW_BASE_LEFT + var_36_3, 0)
	BackButtonManager:push({
		check_id = "bg_change_popup",
		back_func = function()
			arg_36_0:closeBGPacks()
		end,
		dlg = var_36_4
	})
	var_36_0:addChild(var_36_4)
	
	local var_36_5 = ccui.Button:create()
	
	var_36_5:setTouchEnabled(true)
	var_36_5:ignoreContentAdaptWithSize(false)
	
	local var_36_6 = 4
	
	var_36_5:setContentSize(VIEW_WIDTH * var_36_6, VIEW_HEIGHT * var_36_6)
	var_36_5:setPosition(VIEW_BASE_LEFT + var_36_3, 0)
	var_36_5:setAnchorPoint(0, 0)
	var_36_5:setLocalZOrder(-1)
	var_36_5:addTouchEventListener(function(arg_38_0, arg_38_1)
		if arg_38_1 ~= 2 then
			return 
		end
		
		arg_36_0:closeBGPacks()
	end)
	var_36_5:setName("btn_bg_close")
	var_36_4:addChild(var_36_5)
	
	arg_36_0.vars.bg_change = var_36_4
	
	local var_36_7 = SAVE:getKeep("unit_detail_bg_id")
	local var_36_8
	
	if not var_36_7 or var_36_7 == "" then
		var_36_8 = 1
	end
	
	BGSelector:init(var_36_4:findChildByName("scrollview"), function(arg_39_0, arg_39_1)
		arg_36_0:onSelectBackground(arg_39_0, arg_39_1)
	end, "UnitInfos", var_36_8)
	
	if not var_36_8 then
		arg_36_0.vars.bg_idx = BGSelector:getIdxById(var_36_7)
		
		BGSelector:setToIndex(arg_36_0.vars.bg_idx)
	end
	
	if_set_visible(var_36_0, "btn_bg_close", true)
	if_set(var_36_4, "t_bgpack_info", T("background_change_hero"))
	var_36_4:setPositionY(-800)
	UIAction:Add(LOG(MOVE_TO(400, nil, 0)), var_36_4, "block")
end

function UnitDetailGrowth.closeBGPacks(arg_40_0, arg_40_1)
	local var_40_0 = UnitDetail:getWnd()
	
	if not get_cocos_refid(var_40_0) then
		return 
	end
	
	if not arg_40_0.vars.bg_change then
		return 
	end
	
	if_set_visible(var_40_0, "btn_bg_close", false)
	BackButtonManager:pop({
		dlg = arg_40_0.vars.bg_change
	})
	
	if not arg_40_1 then
		UIAction:Add(SEQ(LOG(MOVE_TO(400, nil, -800)), REMOVE()), arg_40_0.vars.bg_change, "block")
	else
		arg_40_0.vars.bg_change:removeFromParent()
	end
	
	arg_40_0.vars.bg_change = nil
	
	BGSelector:close()
end

function UnitDetailGrowth.reqToggleLock(arg_41_0)
	if not arg_41_0:isVisible() or not arg_41_0.vars.unit then
		return 
	end
	
	query("lock_unit", {
		uid = arg_41_0.vars.unit:getUID(),
		flag = arg_41_0.vars.unit.inst.locked ~= true
	})
end

function UnitDetailGrowth.lock(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0:isVisible() or not arg_42_0.vars.unit or not arg_42_1 then
		return 
	end
	
	local var_42_0 = Account:getUnit(arg_42_1)
	
	var_42_0.inst.locked = arg_42_2
	
	if arg_42_1 == arg_42_0.vars.unit:getUID() then
		if arg_42_0.vars.unit:isGrowthBoostRegistered() then
			local var_42_1 = arg_42_0.vars.unit:clone()
			
			GrowthBoost:apply(var_42_1)
			
			var_42_1.inst.locked = arg_42_0.vars.unit:isLocked()
			
			UIUtil:setUnitAllInfo(arg_42_0.vars.menu_wnd, var_42_1)
		else
			UIUtil:setUnitAllInfo(arg_42_0.vars.menu_wnd, var_42_0)
		end
	end
	
	if arg_42_2 then
		balloon_message_with_sound("character_lock")
	else
		balloon_message_with_sound("character_unlock")
	end
	
	SoundEngine:play("event:/ui/unit_detail/btn_lock")
	
	local var_42_2 = UnitDetail:getHeroBelt()
	
	if var_42_2 then
		var_42_2:updateUnit(nil, var_42_0)
	end
end

function UnitDetailGrowth.setMainUnit(arg_43_0)
	if not arg_43_0:isVisible() or not arg_43_0.vars.unit then
		return 
	end
	
	if arg_43_0.vars.unit.db.type ~= "character" and arg_43_0.vars.unit.db.type ~= "monster" and arg_43_0.vars.unit.db.type ~= "limited" then
		balloon_message_with_sound("unit_detail_main_char_x")
		
		return 
	end
	
	if arg_43_0.vars.unit:isMoonlightDestinyUnit() then
		balloon_message_with_sound("character_mc_cannot_set_main")
		
		return 
	end
	
	query("set_main_unit", {
		uid = arg_43_0.vars.unit:getUID()
	})
end

function UnitDetailGrowth.updateMainUnitButton(arg_44_0, arg_44_1)
	if not arg_44_0:isVisible() or not get_cocos_refid(arg_44_0.vars.left) or not arg_44_0.vars.unit then
		return 
	end
	
	arg_44_1 = arg_44_1 or arg_44_0.vars.unit
	
	if not arg_44_1 then
		return 
	end
	
	if arg_44_1.db.type ~= "character" and arg_44_1.db.type ~= "monster" and arg_44_1.db.type ~= "limited" then
		if_set_opacity(arg_44_0.vars.left, "btn_main", 76.5)
		if_set_opacity(arg_44_0.vars.left, "btn_main_done", 76.5)
		if_set_visible(arg_44_0.vars.left, "btn_main", true)
		if_set_visible(arg_44_0.vars.left, "btn_main_done", false)
	elseif Account:getMainUnitId() == arg_44_1:getUID() then
		if_set_opacity(arg_44_0.vars.left, "btn_main", 255)
		if_set_opacity(arg_44_0.vars.left, "btn_main_done", 255)
		if_set_visible(arg_44_0.vars.left, "btn_main", false)
		if_set_visible(arg_44_0.vars.left, "btn_main_done", true)
	else
		if_set_opacity(arg_44_0.vars.left, "btn_main", 255)
		if_set_opacity(arg_44_0.vars.left, "btn_main_done", 255)
		if_set_visible(arg_44_0.vars.left, "btn_main", true)
		if_set_visible(arg_44_0.vars.left, "btn_main_done", false)
	end
end

function UnitDetailGrowth.openGrowthBoostTooltip(arg_45_0)
	if not arg_45_0:isVisible() then
		return 
	end
	
	local var_45_0 = UnitDetail:getWnd()
	
	if not get_cocos_refid(var_45_0) then
		return 
	end
	
	local var_45_1 = var_45_0:getChildByName("n_blessing_tooltip")
	
	if not get_cocos_refid(var_45_1) then
		return 
	end
	
	local var_45_2 = var_45_1:getChildByName("t_contents1")
	local var_45_3 = var_45_1:getChildByName("n_disc")
	local var_45_4 = var_45_1:getChildByName("t_disc")
	local var_45_5 = var_45_1:getChildByName("bg")
	local var_45_6 = {
		var_45_2,
		var_45_3,
		var_45_4,
		var_45_5
	}
	
	for iter_45_0, iter_45_1 in pairs(var_45_6) do
		if not get_cocos_refid(iter_45_1) then
			return 
		end
	end
	
	if_set(var_45_2, nil, T("ui_gb_hero_info_restrict_desc"))
	
	local var_45_7 = var_45_2:getTextBoxSize().height * var_45_2:getScaleY() - 10
	
	var_45_3._origin_pos_y = var_45_3._origin_pos_y or var_45_3:getPositionY()
	
	var_45_3:setPositionY(var_45_3._origin_pos_y + var_45_7)
	
	var_45_5._origin_size = var_45_5._origin_size or var_45_5:getContentSize()
	
	local var_45_8 = var_45_5._origin_size.height + var_45_7 + (var_45_4:getTextBoxSize().height * var_45_4:getScaleY() - 35)
	
	var_45_5:setContentSize({
		width = var_45_5._origin_size.width,
		height = var_45_8
	})
	var_45_1:setOpacity(0)
	UIAction:Add(SEQ(SHOW(true), LOG(FADE_IN(200))), var_45_1, "block")
	BackButtonManager:push({
		check_id = "growth_boost_tooltip",
		back_func = function()
			arg_45_0:closeGrowthBoostTooltip()
		end,
		dlg = var_45_1
	})
end

function UnitDetailGrowth.closeGrowthBoostTooltip(arg_47_0)
	local var_47_0 = UnitDetail:getWnd()
	
	if not get_cocos_refid(var_47_0) then
		return 
	end
	
	local var_47_1 = var_47_0:getChildByName("n_blessing_tooltip")
	
	if not get_cocos_refid(var_47_1) then
		return 
	end
	
	if not var_47_1:isVisible() then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "growth_boost_tooltip",
		dlg = var_47_1
	})
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), SHOW(false)), var_47_1, "block")
end

function UnitDetailGrowth.openMoonlightDestinyTooltip(arg_48_0)
	if not arg_48_0:isVisible() then
		return 
	end
	
	local var_48_0 = UnitDetail:getWnd()
	
	if not get_cocos_refid(var_48_0) then
		return 
	end
	
	local var_48_1 = var_48_0:getChildByName("n_moonlight_destiny_tooltip")
	
	if not get_cocos_refid(var_48_1) then
		return 
	end
	
	local var_48_2 = var_48_1:getChildByName("t_contents1")
	local var_48_3 = var_48_1:getChildByName("n_disc")
	local var_48_4 = var_48_1:getChildByName("t_disc")
	local var_48_5 = var_48_1:getChildByName("bg")
	local var_48_6 = {
		var_48_2,
		var_48_3,
		var_48_4,
		var_48_5
	}
	
	for iter_48_0, iter_48_1 in pairs(var_48_6) do
		if not get_cocos_refid(iter_48_1) then
			return 
		end
	end
	
	if_set(var_48_2, nil, T("character_mc_cannot_listup"))
	
	local var_48_7 = var_48_2:getTextBoxSize().height * var_48_2:getScaleY() - 10
	
	var_48_3._origin_pos_y = var_48_3._origin_pos_y or var_48_3:getPositionY()
	
	var_48_3:setPositionY(var_48_3._origin_pos_y + var_48_7)
	
	var_48_5._origin_size = var_48_5._origin_size or var_48_5:getContentSize()
	
	local var_48_8 = var_48_5._origin_size.height + var_48_7 + (var_48_4:getTextBoxSize().height * var_48_4:getScaleY() - 35)
	
	var_48_5:setContentSize({
		width = var_48_5._origin_size.width,
		height = var_48_8
	})
	var_48_1:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), var_48_1, "block")
	BackButtonManager:push({
		check_id = "moonlight_destiny_tooltip",
		back_func = function()
			arg_48_0:closeMoonlightDestinyTooltip()
		end,
		dlg = var_48_1
	})
end

function UnitDetailGrowth.closeMoonlightDestinyTooltip(arg_50_0)
	local var_50_0 = UnitDetail:getWnd()
	
	if not get_cocos_refid(var_50_0) then
		return 
	end
	
	local var_50_1 = var_50_0:getChildByName("n_moonlight_destiny_tooltip")
	
	if not get_cocos_refid(var_50_1) then
		return 
	end
	
	if not var_50_1:isVisible() then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "moonlight_destiny_tooltip",
		dlg = var_50_1
	})
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), SHOW(false)), var_50_1, "block")
end

function UnitDetailGrowth.requestPreviewRecallUnit(arg_51_0)
	arg_51_0.vars.recall_unit = arg_51_0.vars.unit
	
	local var_51_0 = AccountData.recall_info.recall_period.units[arg_51_0.vars.recall_unit.db.code]
	
	if not var_51_0 then
		balloon_message_with_sound("recall_invalid_unit_desc")
		
		return 
	end
	
	if var_51_0.skill_only ~= true then
		local var_51_1 = arg_51_0.vars.recall_unit:getUsableCodeList()
		
		if var_51_1 then
			Dialog:msgUnitLock(var_51_1)
			
			return 
		end
		
		if arg_51_0.vars.recall_unit:isDoingSubTask() then
			balloon_message_with_sound("cannot_recall_subtask")
			
			return 
		end
		
		if arg_51_0.vars.recall_unit:isDoingClassChange() then
			Dialog:msgBox(T("recall_invalid_unit_classchange_desc"), {
				title = T("recall_invalid_unit_classchange_title")
			})
			
			return 
		end
	end
	
	if var_51_0.skill_only then
		query("recall_unit_preview", {
			skill_only = 1,
			unit_id = arg_51_0.vars.recall_unit:getUID()
		})
	else
		query("recall_unit_preview", {
			unit_id = arg_51_0.vars.recall_unit:getUID()
		})
	end
end

function UnitDetailGrowth.updatePreviewRecallUnitUI(arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_1 then
		return 
	end
	
	local var_52_0 = arg_52_1.enhance
	local var_52_1 = arg_52_1.awaken
	local var_52_2 = arg_52_1.skill
	local var_52_3 = arg_52_1.imprint
	local var_52_4 = arg_52_1.intimacy
	local var_52_5 = arg_52_2:getChildByName("level_grade")
	
	if get_cocos_refid(var_52_5) then
		if_set_visible(var_52_5, "n_no_data", false)
		
		if var_52_0 then
			for iter_52_0 = 1, 7 do
				local var_52_6 = var_52_5:getChildByName("n_" .. iter_52_0)
				
				if var_52_6 then
					if var_52_0[iter_52_0] then
						UIUtil:getRewardIcon(var_52_0[iter_52_0].c, var_52_0[iter_52_0].i, {
							no_popup = true,
							no_tooltip = true,
							show_count = true,
							scale = 0.8,
							parent = var_52_6:getChildByName("n_item")
						})
						if_set_visible(var_52_6, "t_count_mob", false)
						var_52_6:setVisible(true)
					else
						var_52_6:setVisible(false)
					end
				end
			end
			
			var_52_5:setVisible(true)
		else
			var_52_5:setVisible(false)
		end
	end
	
	local var_52_7 = arg_52_2:getChildByName("awake")
	
	if get_cocos_refid(var_52_7) then
		if_set_visible(var_52_7, "n_no_data", false)
		
		if var_52_1 then
			for iter_52_1 = 1, 7 do
				local var_52_8 = var_52_7:getChildByName("n_" .. iter_52_1)
				
				if var_52_8 then
					if var_52_1[iter_52_1] then
						if string.starts(var_52_1[iter_52_1].i, "to_") then
							UIUtil:getRewardIcon(var_52_1[iter_52_1].c, var_52_1[iter_52_1].i, {
								no_popup = true,
								scale = 0.8,
								no_tooltip = true,
								parent = var_52_8:getChildByName("n_item")
							})
							if_set_visible(var_52_8, "t_count_mob", false)
						else
							UIUtil:getRewardIcon(var_52_1[iter_52_1].c, var_52_1[iter_52_1].i, {
								no_popup = true,
								scale = 0.85,
								no_tooltip = true,
								parent = var_52_8:getChildByName("n_item")
							})
							if_set(var_52_8, "t_count_mob", "x" .. var_52_1[iter_52_1].c)
						end
						
						var_52_8:setVisible(true)
					else
						var_52_8:setVisible(false)
					end
				end
			end
			
			var_52_7:setVisible(true)
		else
			var_52_7:setVisible(false)
		end
	end
	
	local var_52_9 = arg_52_2:getChildByName("skill_enchant")
	
	if get_cocos_refid(var_52_9) then
		if_set_visible(var_52_9, "n_no_data", false)
		
		if var_52_2 then
			for iter_52_2 = 1, 7 do
				local var_52_10 = var_52_9:getChildByName("n_" .. iter_52_2)
				
				if var_52_10 then
					if var_52_2[iter_52_2] then
						if string.starts(var_52_2[iter_52_2].i, "to_") then
							UIUtil:getRewardIcon(var_52_2[iter_52_2].c, var_52_2[iter_52_2].i, {
								no_popup = true,
								scale = 0.8,
								no_tooltip = true,
								parent = var_52_10:getChildByName("n_item")
							})
							if_set_visible(var_52_10, "t_count_mob", false)
						else
							UIUtil:getRewardIcon(var_52_2[iter_52_2].c, var_52_2[iter_52_2].i, {
								no_popup = true,
								scale = 0.85,
								no_tooltip = true,
								parent = var_52_10:getChildByName("n_item")
							})
							if_set(var_52_10, "t_count_mob", "x" .. var_52_2[iter_52_2].c)
						end
						
						var_52_10:setVisible(true)
					else
						var_52_10:setVisible(false)
					end
				end
			end
			
			var_52_9:setVisible(true)
		else
			var_52_9:setVisible(false)
		end
	end
	
	local var_52_11 = arg_52_2:getChildByName("memory_imprint")
	
	if get_cocos_refid(var_52_11) then
		if_set_visible(var_52_11, "n_no_data", false)
		
		if var_52_3 then
			for iter_52_3 = 1, 3 do
				local var_52_12 = var_52_11:getChildByName("n_" .. iter_52_3)
				
				if get_cocos_refid(var_52_12) then
					if var_52_3[iter_52_3] then
						if string.starts(var_52_3[iter_52_3].i, "to_") or var_52_3[iter_52_3].i == "ma_devotion1" then
							UIUtil:getRewardIcon(var_52_3[iter_52_3].c, var_52_3[iter_52_3].i, {
								no_popup = true,
								show_count = true,
								no_tooltip = true,
								scale = 0.85,
								no_grade = true,
								parent = var_52_12:getChildByName("n_item")
							})
							if_set_visible(var_52_12, "t_count_mob", false)
						else
							UIUtil:getRewardIcon(nil, var_52_3[iter_52_3].i, {
								no_popup = true,
								no_tooltip = true,
								scale = 0.85,
								no_grade = true,
								parent = var_52_12:getChildByName("n_item")
							})
							if_set(var_52_12, "t_count_mob", "x" .. var_52_3[iter_52_3].c)
						end
						
						var_52_12:setVisible(true)
					else
						var_52_12:setVisible(false)
					end
				end
			end
			
			var_52_11:setVisible(true)
		else
			var_52_11:setVisible(false)
		end
	end
	
	local var_52_13 = arg_52_2:getChildByName("intimacy")
	
	if get_cocos_refid(var_52_13) then
		if_set_visible(var_52_13, "n_no_data", false)
		
		if var_52_4 then
			for iter_52_4 = 1, 3 do
				local var_52_14 = var_52_13:getChildByName("n_" .. iter_52_4)
				
				if var_52_14 then
					if var_52_4[iter_52_4] then
						if string.starts(var_52_4[iter_52_4].i, "to_") then
							UIUtil:getRewardIcon(var_52_4[iter_52_4].c, var_52_4[iter_52_4].i, {
								no_popup = true,
								scale = 0.8,
								no_tooltip = true,
								parent = var_52_14:getChildByName("n_item")
							})
							if_set_visible(var_52_14, "t_count_mob", false)
						else
							UIUtil:getRewardIcon(var_52_4[iter_52_4].c, var_52_4[iter_52_4].i, {
								no_popup = true,
								scale = 0.85,
								no_tooltip = true,
								parent = var_52_14:getChildByName("n_item")
							})
							if_set(var_52_14, "t_count_mob", "x" .. var_52_4[iter_52_4].c)
						end
						
						var_52_14:setVisible(true)
					else
						var_52_14:setVisible(false)
					end
				end
			end
			
			var_52_13:setVisible(true)
		else
			var_52_13:setVisible(false)
		end
	end
end

function UnitDetailGrowth.previewRecallUnit(arg_53_0, arg_53_1)
	if not arg_53_0.vars.recall_unit then
		return 
	end
	
	local var_53_0 = AccountData.recall_info.recall_period.units[arg_53_0.vars.recall_unit.db.code]
	
	if var_53_0 == nil or arg_53_1 == nil or arg_53_1.confirm_rewards == nil or arg_53_1.code ~= arg_53_0.vars.recall_unit.db.code or arg_53_1.unit_id ~= arg_53_0.vars.recall_unit:getUID() then
		Dialog:msgBox(T("recall_invalid_unit_desc"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end,
			title = T("recall_invalid_unit_title")
		})
		
		return 
	end
	
	arg_53_0.vars.recall_data = {}
	
	local var_53_1 = load_dlg("recall", true, "wnd")
	local var_53_2 = var_53_1:getChildByName("n_hero")
	
	var_53_2:setVisible(true)
	if_set_visible(var_53_1, "n_arti", false)
	
	if var_53_0.skill_only then
		if_set(var_53_1, "t_title", T("ui_popup_skillreset_title"))
		if_set(var_53_1, "t_disc", T("ui_popup_skillreset_desc"))
		if_set(var_53_1:getChildByName("btn_recall"), "label", T("ui_btn_skillreset_confirm"))
	else
		if_set(var_53_1, "t_title", T("ui_recall_hero_tl"))
		if_set(var_53_1, "t_disc", T("ui_recall_hero_desc"))
		if_set(var_53_1:getChildByName("btn_recall"), "label", T("ui_recall_confirm_btn_recall"))
	end
	
	arg_53_0:updatePreviewRecallUnitUI(arg_53_1.confirm_rewards, var_53_2)
	
	local var_53_3 = arg_53_1.confirm_rewards.imprint
	
	if var_53_3 then
		for iter_53_0 = 1, 3 do
			if (iter_53_0 == 2 or iter_53_0 == 3) and var_53_3[iter_53_0] and string.starts(var_53_3[iter_53_0].i, "d") then
				arg_53_0.vars.recall_data.tablets = var_53_3[iter_53_0]
			end
			
			if (iter_53_0 == 2 or iter_53_0 == 3) and var_53_3[iter_53_0] and var_53_3[iter_53_0].i == "ma_devotion1" then
				arg_53_0.vars.recall_data.devotion = var_53_3[iter_53_0]
			end
		end
	end
	
	arg_53_0.vars.recall_data.select_pool = arg_53_1.select_pool
	
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_53_1,
		handler = function()
			if arg_53_1.select_pool then
				query("select_pool_list", {
					caller = "unit_recall",
					item = arg_53_1.select_pool
				})
			else
				arg_53_0.vars.recall_data.unit = arg_53_0.vars.recall_unit:getDisplayCode()
				
				arg_53_0:confirmRecall(1)
			end
		end
	})
end

function UnitDetailGrowth.selectRecall(arg_56_0, arg_56_1)
	arg_56_0.vars.recall_data.unit = arg_56_1
	
	arg_56_0:confirmRecall(1)
end

function UnitDetailGrowth.confirmRecall(arg_57_0, arg_57_1)
	if not arg_57_0.vars.recall_data then
		return 
	end
	
	local var_57_0 = AccountData.recall_info.recall_period.units[arg_57_0.vars.recall_unit.db.code]
	local var_57_1 = load_dlg("recall_confirm_p", true, "wnd")
	
	if arg_57_1 == 1 then
		if var_57_0.skill_only then
			if_set(var_57_1, "disc", T("ui_popup_skillreset_desc2"))
			if_set(var_57_1, "txt_title", T("ui_popup_skillreset_title"))
			if_set(var_57_1:getChildByName("btn_recall"), "label", T("ui_btn_skillreset_confirm"))
		else
			if_set(var_57_1, "disc", T("ui_recall_hero_confirm_desc1"))
			if_set(var_57_1, "txt_title", T("ui_recall_hero_tl"))
			if_set(var_57_1:getChildByName("btn_recall"), "label", T("ui_recall_confirm_p_btn_recall"))
		end
		
		if_set_visible(var_57_1, "disc", true)
		if_set_visible(var_57_1, "disc_2", false)
	elseif arg_57_1 == 2 then
		if var_57_0.skill_only then
			if_set(var_57_1, "disc_2", T("ui_recall_hero_confirm_desc2"))
			if_set(var_57_1, "txt_title", T("ui_popup_skillreset_title"))
			if_set(var_57_1:getChildByName("btn_recall"), "label", T("ui_btn_skillreset_confirm"))
		elseif arg_57_0.vars.recall_data.select_pool then
			if_set(var_57_1, "disc_2", T("ui_recall_hero2_confirm_desc2"))
			if_set(var_57_1, "txt_title", T("ui_recall_hero_tl"))
			if_set(var_57_1:getChildByName("btn_recall"), "label", T("ui_recall_confirm_p_btn_recall"))
		else
			if_set(var_57_1, "disc_2", T("ui_recall_hero_confirm_desc2"))
			if_set(var_57_1, "txt_title", T("ui_recall_hero_tl"))
			if_set(var_57_1:getChildByName("btn_recall"), "label", T("ui_recall_confirm_p_btn_recall"))
		end
		
		if_set_visible(var_57_1, "disc", false)
		if_set_visible(var_57_1, "disc_2", true)
	end
	
	local var_57_2 = var_57_1:getChildByName("n_contents")
	local var_57_3 = var_57_2:getChildByName("n_before")
	
	UIUtil:setLevel(var_57_3:getChildByName("n_lv"), arg_57_0.vars.recall_unit:getLv(), nil, 2)
	UIUtil:getUserIcon(arg_57_0.vars.recall_unit, {
		no_popup = true,
		no_tooltip = true,
		no_lv = true,
		scale = 1.28,
		parent = var_57_3:getChildByName("n_item")
	})
	
	local var_57_4 = arg_57_0.vars.recall_unit:getTotalSkillLevel()
	
	if var_57_4 > 0 then
		if_set(var_57_3, "skill_up", "+" .. var_57_4)
		if_set_visible(var_57_3, "skill_up_bg", true)
	else
		if_set_visible(var_57_3, "skill_up_bg", false)
	end
	
	local var_57_5 = var_57_2:getChildByName("n_after")
	local var_57_6 = var_57_5:getChildByName("n_1")
	
	if var_57_0.skill_only then
		UIUtil:setLevel(var_57_6:getChildByName("n_lv"), arg_57_0.vars.recall_unit:getLv(), nil, 2)
		UIUtil:getUserIcon(arg_57_0.vars.recall_unit, {
			no_popup = true,
			no_tooltip = true,
			no_lv = true,
			scale = 1.28,
			parent = var_57_6:getChildByName("n_item")
		})
	else
		UIUtil:setLevel(var_57_6:getChildByName("n_lv"), 1, nil, 2)
		UIUtil:getUserIcon(arg_57_0.vars.recall_data.unit, {
			base_grade = true,
			zodiac = 0,
			use_popup = true,
			no_lv = true,
			scale = 1.28,
			parent = var_57_6:getChildByName("n_item")
		})
	end
	
	local var_57_7 = var_57_5:getChildByName("n_2")
	
	if arg_57_0.vars.recall_data.tablets then
		UIUtil:getRewardIcon(arg_57_0.vars.recall_data.tablets.c, arg_57_0.vars.recall_data.tablets.i, {
			show_small_count = true,
			show_count = true,
			no_grade = true,
			parent = var_57_7:getChildByName("n_item")
		})
		var_57_7:setVisible(true)
	elseif arg_57_0.vars.recall_data.devotion then
		UIUtil:getRewardIcon(arg_57_0.vars.recall_data.devotion.c, arg_57_0.vars.recall_data.devotion.i, {
			show_small_count = true,
			show_count = true,
			no_grade = true,
			parent = var_57_7:getChildByName("n_item")
		})
		var_57_7:setVisible(true)
	else
		var_57_7:setVisible(false)
	end
	
	local var_57_8 = var_57_5:getChildByName("n_3")
	
	if arg_57_0.vars.recall_data.tablets and arg_57_0.vars.recall_data.devotion then
		UIUtil:getRewardIcon(arg_57_0.vars.recall_data.devotion.c, arg_57_0.vars.recall_data.devotion.i, {
			show_small_count = true,
			show_count = true,
			no_grade = true,
			parent = var_57_8:getChildByName("n_item")
		})
		var_57_8:setVisible(true)
	else
		var_57_8:setVisible(false)
	end
	
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_57_1,
		handler = function()
			if arg_57_1 == nil or arg_57_1 == 1 then
				if var_57_0.skill_only then
					arg_57_0:requestRecallUnit()
				else
					arg_57_0:confirmRecall(2)
				end
			elseif arg_57_1 == 2 then
				arg_57_0:requestRecallUnit()
			end
		end
	})
end

function UnitDetailGrowth.requestRecallUnit(arg_59_0)
	if AccountData.recall_info.recall_period.units[arg_59_0.vars.recall_unit.db.code].skill_only then
		query("recall_unit", {
			skill_only = 1,
			unit_id = arg_59_0.vars.recall_unit:getUID(),
			select_unit_code = arg_59_0.vars.recall_data.unit
		})
	else
		if UIUtil:checkUnitInven() == false then
			return 
		end
		
		local var_59_0 = arg_59_0.vars.recall_unit
		
		if var_59_0:isDoingSubTask() then
			balloon_message_with_sound("cannot_recall_subtask")
			
			return 
		end
		
		if var_59_0:isDoingClassChange() then
			balloon_message_with_sound("recall_invalid_unit_desc")
			
			return 
		end
		
		query("recall_unit", {
			unit_id = arg_59_0.vars.recall_unit:getUID(),
			select_unit_code = arg_59_0.vars.recall_data.unit
		})
	end
end

function UnitDetailGrowth.processRecallUnit(arg_60_0, arg_60_1)
	if arg_60_1.err then
		balloon_message_with_sound(arg_60_1.err)
		
		return 
	end
	
	if arg_60_1.recall_info then
		AccountData.recall_info = arg_60_1.recall_info
	end
	
	if arg_60_1.deleted_unit_id then
		local var_60_0 = Account:getUnit(arg_60_1.deleted_unit_id)
		
		if var_60_0 then
			Account:removeUnit(var_60_0)
		end
	elseif arg_60_1.updated_unit then
		local var_60_1 = Account:getUnit(arg_60_1.updated_unit.id)
		
		if var_60_1 then
			var_60_1.inst.zodiac = math.min(6, arg_60_1.updated_unit.z or 0)
			var_60_1.inst.grade = arg_60_1.updated_unit.g
			var_60_1.inst.devote = arg_60_1.updated_unit.d
			var_60_1.inst.stree = arg_60_1.updated_unit.stree or {}
			var_60_1.inst.unit_option = arg_60_1.updated_unit.opt
			
			var_60_1:setExp(arg_60_1.updated_unit.exp)
			var_60_1:setSkillLevelInfo(arg_60_1.updated_unit.s or {
				0,
				0,
				0
			})
			var_60_1:bindGameDB(var_60_1.inst.code, var_60_1.inst.skin_code)
			var_60_1:updateZodiacSkills()
			var_60_1:reset()
		end
	end
	
	if arg_60_1.unequiped_list then
		for iter_60_0, iter_60_1 in pairs(arg_60_1.unequiped_list) do
			local var_60_2 = Account:getEquip(iter_60_1)
			
			if var_60_2 then
				local var_60_3 = Account:getUnit(var_60_2.parent)
				
				if var_60_3 then
					var_60_3:removeEquip(var_60_2)
				end
			end
		end
	end
	
	if arg_60_1.rewards then
		Account:addReward(arg_60_1.rewards, {
			ignore_get_condition = true
		})
	end
	
	if AccountData.recall_info.recall_period.units[arg_60_0.vars.recall_unit.db.code].skill_only then
		Dialog:msgBox(T("ui_popup_skillreset_desc3"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end,
			title = T("ui_popup_skillreset_title")
		})
	else
		Dialog:msgBox(T("recall_complete_desc"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end,
			title = T("recall_complete_title")
		})
	end
end
