UnitInfosDetail = {}

function UnitInfosDetail.onTouchDown(arg_1_0, arg_1_1)
	UnitDetail:onTouchDown(arg_1_1)
end

function UnitInfosDetail.onTouchUp(arg_2_0, arg_2_1)
	UnitDetail:onTouchUp(arg_2_1)
end

function UnitInfosDetail.onTouchMove(arg_3_0, arg_3_1)
	UnitDetail:onTouchMove(arg_3_1)
end

function UnitInfosDetail.onAfterUpdate(arg_4_0)
	UnitDetail:onAfterUpdate()
end

function UnitInfosDetail.onButtonStory(arg_5_0)
	local var_5_0 = UnitInfosController:getUnit()
	
	if not var_5_0 then
		return 
	end
	
	if not arg_5_0:isDetailInfoUnit(var_5_0) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	if not UnitInfosSubStory:getCharacterSubStories(var_5_0) then
		balloon_message_with_sound("ui_hero_detail_story_btn_block", {
			char = var_5_0:getName()
		})
		
		return 
	end
	
	if not UnitDetail:isModeChangeable() then
		return 
	end
	
	Account:showServerResUI("unitinfo_substory")
end

function UnitInfosDetail.onButtonRelation(arg_6_0, arg_6_1)
	local var_6_0 = UnitInfosController:getUnit()
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1 = var_6_0.db.role or nil
	
	if not arg_6_1.active_flag and not var_6_0:isOrganizable() and var_6_1 ~= "material" then
		balloon_message_with_sound("msg_relation_npc")
		
		return 
	end
	
	if not UnitDetail.vars.unit:checkStory() then
		balloon_message_with_sound("no_story")
		
		return 
	end
	
	if not UnitDetail:isModeChangeable() then
		return 
	end
	
	UnitInfosController:setMode("Story")
end

function UnitInfosDetail.onButtonIntimacy(arg_7_0)
	local var_7_0 = UnitInfosController:getUnit()
	
	if not var_7_0 then
		return 
	end
	
	if not arg_7_0:isDetailInfoUnit(var_7_0) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	UnitIntimacy:open(var_7_0)
end

function UnitInfosDetail.onButtonPresent(arg_8_0)
	local var_8_0 = UnitInfosController:getUnit()
	
	if not var_8_0 then
		return 
	end
	
	if not arg_8_0:isDetailInfoUnit(var_8_0) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	if BackPlayManager:isInBackPlayTeam(var_8_0:getUID()) then
		balloon_message_with_sound("msg_bgbattle_cant_levelup")
		
		return 
	end
	
	local var_8_1 = UnitIntimacy:getIntimacyData(var_8_0)
	
	if not var_8_1 then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	if var_8_1.is_max_intimacy_lv then
		return 
	end
	
	if var_8_1.unit and var_8_1.unit:isMoonlightDestinyUnit() then
		balloon_message_with_sound("character_mc_cannot_gift")
		
		return 
	end
	
	UnitIntimacy:openPresent(var_8_1)
end

function UnitInfosDetail.onButtonEmotion(arg_9_0)
	local var_9_0 = UnitInfosController:getUnit()
	
	if not var_9_0 then
		return 
	end
	
	if not arg_9_0:isDetailInfoUnit(var_9_0) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	if not UnitDetail:isModeChangeable() then
		return 
	end
	
	UnitInfosController:setMode("Emotion")
end

function UnitInfosDetail.showSkillPreview(arg_10_0)
	local var_10_0 = UnitInfosController:getUnit()
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = var_10_0.db.code
	
	if MoonlightDestiny:isDestinyCharacter(var_10_1) then
		var_10_1 = MoonlightDestiny:getRelationCharacterCode(var_10_1)
	end
	
	if not DB("dic_data", var_10_1, "skill_preview") then
		balloon_message_with_sound("skill_preview_none")
		
		return 
	end
	
	SceneManager:cancelReseveResetSceneFlow()
	startSkillPreview(var_10_0.inst and var_10_0.inst.skin_code or var_10_1)
end

function UnitInfosDetail.showStatPreview(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	if not UnitDetail:isModeChangeable() then
		return 
	end
	
	local var_11_0 = HeroStatViewer:showStatPopup(UnitInfosController:getUnit())
	
	if_set_visible(var_11_0, "n_info", true)
end

function UnitInfosDetail.onCreate(arg_12_0, arg_12_1)
	arg_12_0.vars = {}
	arg_12_0.vars.wnd = UnitDetail.vars.wnd
	arg_12_0.vars.hide_equip = SAVE:get("unit_detail_hide_equip")
	
	arg_12_0:enterDetailUI()
	arg_12_0:updateEquipVisibleBtn()
	arg_12_0:updateUnitInfo()
	
	if arg_12_0.vars.hide_equip then
		UnitDetail:leaveEquipUI()
	end
end

function UnitInfosDetail.updateUnitInfo(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	arg_13_1 = arg_13_1 or UnitInfosController:getUnit()
	
	local var_13_0 = arg_13_0:isDetailInfoUnit(arg_13_1)
	local var_13_1 = arg_13_0.vars.wnd:getChildByName("LEFT_detail")
	local var_13_2 = var_13_1:getChildByName("txt_name")
	
	var_13_2:setString(T(arg_13_1.db.name))
	UIUserData:proc(var_13_2)
	if_call(var_13_1, "star1", "setPositionX", 10 + var_13_2:getContentSize().width * var_13_2:getScaleX() + var_13_2:getPositionX())
	
	local var_13_3 = var_13_1:getChildByName("txt_story")
	
	if var_13_3 then
		UIAction:Remove(var_13_3)
		var_13_3:setString("")
		UIAction:Add(SEQ(SOUND_TEXT(T(DB("character", arg_13_1.db.code, "2line"), "text"), true, 20, nil, 60)), var_13_3)
	end
	
	UIUtil:setUnitAllInfo(var_13_1, arg_13_1)
	
	local var_13_4 = arg_13_0.vars.wnd:getChildByName("btn_story")
	local var_13_5 = arg_13_0.vars.wnd:getChildByName("btn_expressions")
	local var_13_6 = arg_13_0.vars.wnd:getChildByName("btn_relationship")
	
	UIUtil:changeButtonState(var_13_4, UnitInfosSubStory:getCharacterSubStories(arg_13_1), true)
	UIUtil:changeButtonState(var_13_5, var_13_0, true)
	UIUtil:changeButtonState(var_13_6, arg_13_1:checkStory(), true)
	if_set_visible(arg_13_0.vars.wnd, "alert_story", UnitStory:getPlayableStoryCount(arg_13_1) > 0)
	UIUtil:setFavoriteDetail(arg_13_0.vars.wnd, arg_13_1)
	
	if not var_13_0 or arg_13_1:isMoonlightDestinyUnit() then
		if_set_opacity(arg_13_0.vars.wnd, "btn_present", 76.5)
	elseif BackPlayManager:isInBackPlayTeam(arg_13_1:getUID()) then
		if_set_opacity(arg_13_0.vars.wnd, "btn_present", 76.5)
	else
		if_set_opacity(arg_13_0.vars.wnd, "btn_present", 255)
	end
	
	if_set_visible(arg_13_0.vars.wnd, "btn_present", arg_13_1:getFavLevel() < 10)
	if_set_visible(arg_13_0.vars.wnd, "n_intimacy_complet", arg_13_1:getFavLevel() >= 10)
	if_set_visible(arg_13_0.vars.wnd, "btn_intimacy", var_13_0)
	if_set_visible(arg_13_0.vars.wnd, "icon_arr", var_13_0)
	if_set_opacity(arg_13_0.vars.wnd, "btn_skin", arg_13_1:isSkinViewable() and 255 or 76.5)
	UnitDetail:updateCommonUI(arg_13_1)
	arg_13_0:updateMainUnitButton()
	arg_13_0:updateSkinAlert()
	arg_13_0:updateSpecialty()
	arg_13_0:updateIntimacy()
	arg_13_0:updateCharacterVoice()
	
	if HeroStatViewer:isVisible() then
		HeroStatViewer:setUnit(arg_13_1)
	end
	
	local var_13_7 = UnitMain:getHeroBelt()
	
	if var_13_7 then
		var_13_7:updateUnit(nil, arg_13_1)
	end
	
	if var_13_0 then
		UnitMain:movePortrait("Infos")
	else
		UnitMain:resetPortraitPos()
	end
end

function UnitInfosDetail.updateSpecialty(arg_14_0, arg_14_1)
	arg_14_1 = arg_14_1 or UnitInfosController:getUnit()
	
	if not arg_14_1 then
		return 
	end
	
	local var_14_0 = arg_14_1:getSubTaskMissionSkill()
	local var_14_1 = arg_14_0.vars.wnd:getChildByName("n_specialty")
	
	if var_14_0 then
		local var_14_2 = var_14_1:getChildByName("n_icon_specialty")
		
		if get_cocos_refid(var_14_2) then
			if_set_sprite(var_14_2, "icon", "skill/" .. (var_14_0.icon or ""))
		end
		
		WidgetUtils:setupTooltip({
			delay = 0,
			control = var_14_2:getChildByName("icon"),
			creator = function()
				if not arg_14_0.vars then
					return 
				end
				
				return UIUtil:getSubtaskSkillTooltip(UnitInfosController:getUnit())
			end
		})
		if_set(var_14_1, "txt_name", T(var_14_0.name))
		if_set(var_14_1, "txt_disc", T(var_14_0.desc))
	end
	
	if_set_visible(var_14_1, "n_contents", var_14_0 ~= nil)
	if_set_visible(var_14_1, "n_specialty_none", var_14_0 == nil)
end

function UnitInfosDetail.updateIntimacy(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not arg_16_1 then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.wnd:getChildByName("btn_intimacy")
	local var_16_1 = arg_16_0.vars.wnd:getChildByName("n_love")
	
	if get_cocos_refid(arg_16_0.vars.wnd) and get_cocos_refid(var_16_0) then
		if arg_16_1:canUseIntimacy() then
			if_set_visible(var_16_0, nil, true)
			if_set_visible(var_16_1, "icon_arr", true)
		else
			if_set_visible(var_16_0, nil, false)
			if_set_visible(var_16_1, "icon_arr", false)
		end
	end
end

function UnitInfosDetail.updateMainUnitButton(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 or UnitInfosController:getUnit()
	
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("pos_main")
	
	if arg_17_1.db.type ~= "character" and arg_17_1.db.type ~= "monster" and arg_17_1.db.type ~= "limited" then
		if_set_opacity(var_17_0, "btn_main", 76.5)
		if_set_opacity(var_17_0, "btn_main_done", 76.5)
		if_set_visible(var_17_0, "btn_main", true)
		if_set_visible(var_17_0, "btn_main_done", false)
	elseif Account:getMainUnitId() == arg_17_1:getUID() then
		if_set_opacity(var_17_0, "btn_main", 255)
		if_set_opacity(var_17_0, "btn_main_done", 255)
		if_set_visible(var_17_0, "btn_main", false)
		if_set_visible(var_17_0, "btn_main_done", true)
	else
		if_set_opacity(var_17_0, "btn_main", 255)
		if_set_opacity(var_17_0, "btn_main_done", 255)
		if_set_visible(var_17_0, "btn_main", true)
		if_set_visible(var_17_0, "btn_main_done", false)
	end
end

function UnitInfosDetail.updateSkinAlert(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	arg_18_1 = arg_18_1 or UnitInfosController:getUnit()
	
	if not arg_18_1 then
		return 
	end
	
	if_set_visible(arg_18_0.vars.wnd, "alert_skin", UnitSkin:CheckNotification(arg_18_1))
end

function UnitInfosDetail.updateCharacterVoice(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	arg_19_1 = arg_19_1 or UnitInfosController:getUnit()
	
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = UnitInfosUtil:getCharacterVoiceName(arg_19_1.db.code)
	local var_19_1 = arg_19_0.vars.wnd:getChildByName("LEFT_detail")
	local var_19_2 = var_19_1:getChildByName("n_cv_info")
	
	if var_19_0 then
		local var_19_3 = var_19_1:getChildByName("txt_zodiac")
		local var_19_4 = var_19_3:getPositionX() + var_19_3:getContentSize().width * var_19_3:getScaleX()
		
		if_set(var_19_2, "txt_cv", var_19_0)
		if_set_position_x(var_19_2, nil, var_19_4 - 308)
		if_set_visible(var_19_2, nil, true)
	else
		if_set_visible(var_19_2, nil, false)
	end
end

function UnitInfosDetail.isDetailInfoUnit(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or UnitInfosController:getUnit()
	
	if not arg_20_1 then
		return 
	end
	
	local var_20_0 = arg_20_1:getDisplayCode() == "c3084"
	
	return not (arg_20_1:getBaseGrade() < 3) and not arg_20_1:isPromotionUnit() and not arg_20_1:isDevotionUnit() and not arg_20_1:isSpecialUnit() and not var_20_0
end

function UnitInfosDetail.isHideEquip(arg_21_0)
	if not arg_21_0.vars then
		return false
	end
	
	return arg_21_0.vars.hide_equip
end

function UnitInfosDetail.hideEquip(arg_22_0, arg_22_1)
	if not arg_22_0.vars then
		return 
	end
	
	if arg_22_0.vars.hide_equip == arg_22_1 then
		return 
	end
	
	if arg_22_1 then
		UnitDetail:leaveEquipUI()
	else
		UnitDetail:enterEquipUI()
	end
	
	arg_22_0.vars.hide_equip = arg_22_1
	
	arg_22_0:updateEquipVisibleBtn()
end

function UnitInfosDetail.setEquipVisible(arg_23_0, arg_23_1)
	if not arg_23_0.vars or arg_23_0.vars.hide_equip then
		return 
	end
	
	if arg_23_1 then
		UnitDetail:enterEquipUI()
	else
		UnitDetail:leaveEquipUI()
	end
end

function UnitInfosDetail.updateEquipVisibleBtn(arg_24_0)
	if not arg_24_0.vars then
		return 
	end
	
	if_set_visible(arg_24_0.vars.wnd, "btn_visible_on", arg_24_0.vars.hide_equip)
	if_set_visible(arg_24_0.vars.wnd, "btn_visible_off", not arg_24_0.vars.hide_equip)
end

function UnitInfosDetail.onLeave(arg_25_0)
	if get_cocos_refid(arg_25_0.vars.wnd) then
		arg_25_0:closeBGPacks(true)
		arg_25_0:leaveDetailUI()
	end
	
	SAVE:set("unit_detail_hide_equip", arg_25_0.vars.hide_equip)
end
