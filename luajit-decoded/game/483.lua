RingMenu = {}

function HANDLER.unit_menu_pet(arg_1_0, arg_1_1)
	if PetRingMenu:isPet() then
		local var_1_0 = PetRingMenu:getPet()
		
		PetRingMenu:petHandler(arg_1_0, arg_1_1, var_1_0)
		
		return 
	end
end

function HANDLER.unit_menu(arg_2_0, arg_2_1)
	if arg_2_0.handler then
		arg_2_0.handler()
	end
	
	if PetRingMenu:isPet() then
		local var_2_0 = PetRingMenu:getPet()
		
		PetRingMenu:petHandler(arg_2_0, arg_2_1, var_2_0)
		
		return 
	end
	
	RingMenu:hide()
	
	local var_2_1 = getParentWindow(arg_2_0)
	
	SoundEngine:play("event:/ui/whoosh_b")
	
	if arg_2_1 == "btn_equip" then
		SceneManager:nextScene("unit_ui", {
			mode = "Detail",
			unit = var_2_1.info
		})
	end
	
	if arg_2_1 == "btn_levelup" then
		local var_2_2 = var_2_1.info
		
		if not var_2_2 then
			return 
		end
		
		if var_2_2:isDevotionUnit() then
			balloon_message_with_sound("cant_upgrade")
			
			return 
		end
		
		if var_2_2:isExpUnit() then
			balloon_message_with_sound("cant_upgrade")
			
			return 
		end
		
		if BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(var_2_2:getUID()) then
			balloon_message_with_sound("msg_bgbattle_cant_levelup")
			
			return 
		end
		
		if var_2_2:isMaxLevel() then
			if var_2_2:isMaxLevel() and var_2_2:isLockUpgrade6() then
				balloon_message_with_sound("character_star_cannot_grade_upgrade")
				
				return 
			end
			
			if var_2_2:getGrade() >= 6 then
				balloon_message_with_sound("max_level")
				
				return 
			end
			
			SceneManager:nextScene("unit_ui", {
				mode = "NewPromote",
				unit = var_2_2
			})
		else
			SceneManager:nextScene("unit_ui", {
				mode = "LevelUp",
				unit = var_2_2
			})
		end
	end
	
	if arg_2_1 == "btn_skills" then
		if var_2_1.info:isSpecialUnit() or var_2_1.info:isPromotionUnit() or var_2_1.info:isDevotionUnit() then
			balloon_message_with_sound("cant_skill_upgrade")
			
			return 
		end
		
		if var_2_1.info:isLockSkillUpgrade() then
			balloon_message_with_sound("character_star_cannot_skill_upgrade")
			
			return 
		end
		
		SceneManager:nextScene("unit_ui", {
			mode = "Skill",
			unit = var_2_1.info
		})
	end
	
	if arg_2_1 == "btn_upgrade" then
		local var_2_3 = var_2_1.info
		
		if not var_2_3 then
			return 
		end
		
		local var_2_4, var_2_5 = UnitInfosUtil:isEnableUpgrade(var_2_3)
		
		if var_2_5 then
			balloon_message_with_sound(var_2_5)
			
			return 
		end
		
		SceneManager:nextScene("unit_ui", {
			mode = "Upgrade",
			unit = var_2_3
		})
	end
	
	if arg_2_1 == "btn_zodiac" then
		if var_2_1.info.db.zodiac == nil or not var_2_1.info:checkZodiac() then
			balloon_message_with_sound("no_zodiac")
			
			return 
		end
		
		local var_2_6 = var_2_1.info
		local var_2_7 = UnitInfosUtil:isEnableAwake(var_2_6) and "Potential" or "Stone"
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.ZODIAC
		}, function()
			SceneManager:nextScene("unit_ui", {
				mode = "Zodiac",
				unit = var_2_6,
				enter_mode = var_2_7
			})
		end)
	end
end

function RingMenu.isVisible(arg_4_0)
	return arg_4_0.vars and arg_4_0.vars.items ~= nil
end

function RingMenu.hide_ui(arg_5_0)
	local var_5_0 = arg_5_0.vars.base
	local var_5_1 = var_5_0:getChildByName("n_circle_center")
	
	UIAction:Add(SEQ(DELAY(40), SPAWN(RLOG(ROTATE(250, 0, 90), 500), FADE_OUT(250))), var_5_1, "block")
	
	local var_5_2 = 0
	
	if arg_5_0.vars.opts.dlg_name then
		var_5_2 = 1
	end
	
	for iter_5_0 = var_5_2, 4 do
		local var_5_3 = var_5_0:getChildByName(iter_5_0)
		
		UIAction:Add(SEQ(DELAY(40 * iter_5_0), SPAWN(FADE_OUT(200), LOG(MOVE_TO(200, 80, 0)))), var_5_3, "block")
	end
	
	UIAction:AddSmooth(SEQ(DELAY(450), REMOVE()), var_5_0)
end

function RingMenu.hide(arg_6_0, arg_6_1)
	if arg_6_0.vars == nil or arg_6_0.vars.items == nil then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.base
	
	if get_cocos_refid(var_6_0) then
		arg_6_0:hide_ui()
		Lobby:onHideRingMenu()
		SoundEngine:play("event:/ui/lobby/btn_char_close")
	end
	
	arg_6_0.vars = {}
	
	return true
end

function RingMenu.show_on_lobby(arg_7_0, arg_7_1, arg_7_2)
	if_set_visible(arg_7_1, "n_pet_info", false)
	
	if arg_7_2.db.zodiac == nil or not arg_7_2:checkZodiac() or not UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC) then
		if_set_color(arg_7_1:getChildByName("4"), "label", cc.c3b(90, 90, 90))
	end
	
	local var_7_0 = (not arg_7_2:isMaxLevel() or not (arg_7_2:getGrade() >= 6)) and not arg_7_2:isDevotionUnit() and not arg_7_2:isExpUnit()
	local var_7_1 = UnitInfosUtil:isEnableUpgrade(arg_7_2)
	
	if BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(arg_7_2:getUID()) then
		var_7_0 = false
		var_7_1 = false
	end
	
	if not var_7_0 then
		if_set_color(arg_7_1:getChildByName("2"), "label", cc.c3b(90, 90, 90))
	end
	
	if not var_7_1 then
		if_set_color(arg_7_1:getChildByName("3"), "label", cc.c3b(90, 90, 90))
	end
	
	if arg_7_2:isSpecialUnit() or arg_7_2:isPromotionUnit() or arg_7_2:isDevotionUnit() then
		if_set_color(arg_7_1:getChildByName("1"), "label", cc.c3b(90, 90, 90))
	end
	
	local var_7_2 = Account:isZodiacUpgradableUnit(arg_7_2) and UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC)
	local var_7_3 = UnitInfosUtil:isEnableAwake(arg_7_2) and arg_7_2:isAwakeUpgradable()
	local var_7_4 = TutorialCondition:isEnable("char_awake_unlock", {
		unit = arg_7_2
	})
	
	if_set_visible(arg_7_1:getChildByName(4), "noti", var_7_2 or var_7_3 or var_7_4)
	if_set_visible(arg_7_1:getChildByName(2), "noti", Account:isUpgradableUnit(arg_7_2))
	if_set_visible(arg_7_1:getChildByName(3), "noti", arg_7_2:isUpgradeable())
	if_set_visible(arg_7_1:getChildByName(1), "noti", arg_7_2:skillPointNoti())
	UnlockSystem:setButtonUnlockInfo(arg_7_1:getChildByName(4), "btn_zodiac", UNLOCK_ID.ZODIAC, {
		left_bottom_pos = true,
		pos_x_ratio = 0.47
	})
end

function RingMenu.ui_init(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_5 = arg_8_5 or {}
	
	if arg_8_0.vars and arg_8_0.vars.items then
		arg_8_0:hide()
	end
	
	arg_8_0.vars = {}
	arg_8_0.vars.items = {}
	arg_8_0.vars.opts = arg_8_5 or {}
	
	local var_8_0 = arg_8_2 > DESIGN_WIDTH / 2
	
	if arg_8_5.pet then
		var_8_0 = false
	end
	
	local var_8_1 = load_dlg(arg_8_5.dlg_name or "unit_menu", true, "wnd")
	
	var_8_1.info = arg_8_4
	arg_8_0.vars.base = var_8_1
	
	if var_8_0 then
		var_8_1:getChildByName("n_base"):setScaleX(-1)
	end
	
	arg_8_0.vars.base:setAnchorPoint(0, 0)
	arg_8_0.vars.base:setPosition(arg_8_2, arg_8_3)
	arg_8_0.vars.base:setCascadeOpacityEnabled(true)
	arg_8_1:addChild(arg_8_0.vars.base)
	
	local var_8_2 = var_8_1:getChildByName("n_circle_center")
	
	var_8_2:setOpacity(0)
	UIAction:Add(SPAWN(LOG(ROTATE(140, -90, 0), 500), FADE_IN(140)), var_8_2, "block")
	
	local var_8_3 = var_8_1:getChildByName("2")
	
	if get_cocos_refid(var_8_3) then
		local var_8_4 = var_8_3:getChildByName("label")
		local var_8_5 = arg_8_4:isMaxLevel() and T("promote") or T("unit_menu_levelup")
		
		if_set(var_8_3, "label", var_8_5)
	end
	
	local var_8_6 = var_8_1:getChildByName("3")
	
	if get_cocos_refid(var_8_6) then
		if_set(var_8_6, "label", T("ui_memorize_clear_title"))
	end
	
	local var_8_7 = var_8_1:getChildByName("4")
	
	if get_cocos_refid(var_8_7) and not arg_8_5.pet then
		if_set(var_8_7, "label", UnitInfosUtil:isEnableAwake(arg_8_4) and T("ui_unit_zodiac2_btn_awake") or T("unit_menu_awakening"))
	end
	
	local var_8_8 = 0
	
	if arg_8_5.dlg_name then
		var_8_8 = 1
	end
	
	for iter_8_0 = var_8_8, 4 do
		local var_8_9 = var_8_1:getChildByName(iter_8_0)
		
		var_8_9:setOpacity(0)
		var_8_9:setPositionX(-180)
		UIAction:Add(SEQ(DELAY((iter_8_0 - 1) * 40), SPAWN(FADE_IN(160), LOG(MOVE_TO(160, 0, 0)))), var_8_9, "block")
		if_set_visible(var_8_9, "noti", false)
		
		local var_8_10 = var_8_9:getChildByName("label")
		
		if var_8_0 then
			local var_8_11 = var_8_10:getPosition()
			local var_8_12 = var_8_10:getContentSize()
			
			var_8_10:setAnchorPoint(1)
			var_8_10:setScaleX(-var_8_10:getScaleX())
			var_8_10:setPositionX(var_8_11 - var_8_12.width * var_8_10:getScaleX())
			var_8_9:getChildByName("noti"):setScaleX(-1)
		end
	end
end

function RingMenu.show(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_0:ui_init(arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_0:show_on_lobby(arg_9_0.vars.base, arg_9_4)
end

function RingMenu._setItemRotation(arg_10_0, arg_10_1)
end

PetRingMenu = {}

copy_functions(RingMenu, PetRingMenu)

function PetRingMenu.petHandler(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_2 == "btn_equip" and PetCare:open_carePopup(arg_11_3, {
		callback = function(arg_12_0, arg_12_1, arg_12_2)
			PetRingMenu:update_noti()
			PetRingMenu:update_opacity_in_pethouse()
			
			if arg_12_1 then
				PetHouse:onTakeCare(arg_12_0)
				PetHouse:breakLockUI()
			elseif arg_12_2 then
				PetHouse:breakLockUI()
			else
				PetHouse:releaseLockUI()
			end
		end
	}) then
		PetHouse:lockUI()
	end
	
	if arg_11_2 == "btn_skills" then
		if arg_11_3:isMaxLevel() then
			balloon_message_with_sound("ui_pet_upgrade_already_max")
			
			return 
		end
		
		PetUIMain:popBackFunc("PetHouse_Focus", arg_11_0.vars.base)
		PetUIMain:pushMode("Upgrade", {
			pet = arg_11_3
		})
	end
	
	if arg_11_2 == "btn_upgrade" then
		if not arg_11_3:isCanSynthesis() then
			local var_11_0 = arg_11_3:getUsableSynthesisList()
			
			Dialog:msgPetLock(var_11_0)
			
			return 
		end
		
		PetUIMain:popBackFunc("PetHouse_Focus", arg_11_0.vars.base)
		PetUIMain:pushMode("Synthesis", {
			pet = arg_11_3
		})
	end
	
	if arg_11_2 == "btn_zodiac" then
		PetUIMain:popBackFunc("PetHouse_Focus", arg_11_0.vars.base)
		PetUIMain:pushMode("Detail", {
			pet = arg_11_3
		})
	end
	
	arg_11_0:hide(arg_11_2)
end

function PetRingMenu.isPet(arg_13_0)
	return arg_13_0.vars and arg_13_0.vars.is_pet
end

function PetRingMenu.getPet(arg_14_0)
	return arg_14_0.vars and arg_14_0.vars.pet
end

function PetRingMenu.hide(arg_15_0, arg_15_1)
	if arg_15_0.vars == nil or arg_15_0.vars.items == nil then
		return 
	end
	
	if arg_15_0.vars.is_pet and arg_15_1 == "btn_equip" then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.base
	
	if get_cocos_refid(var_15_0) then
		PetUIMain:popBackFunc("PetHouse_Focus", var_15_0)
		arg_15_0:hide_ui()
		arg_15_0:hide_info()
		PetHouse:focusOut()
		SoundEngine:play("event:/ui/lobby/btn_char_close")
	end
	
	arg_15_0.vars = {}
	
	return true
end

function PetRingMenu.hide_info(arg_16_0)
	local var_16_0 = arg_16_0.vars.base:getChildByName("n_pet_info")
	
	UIAction:Add(SEQ(DELAY(40), FADE_OUT(200)), var_16_0, "block")
end

function PetRingMenu.show_on_pethouse(arg_17_0, arg_17_1, arg_17_2)
	if_set_visible(arg_17_1, "n_pet_info", true)
	
	local var_17_0 = arg_17_1:findChildByName("n_pet_info")
	
	UIUtil:updatePetName(var_17_0:findChildByName("txt_name"), arg_17_2)
	UIUtil:updatePetStars(var_17_0:findChildByName("n_stars"), arg_17_2)
	UIUtil:updatePetRoleIcon(var_17_0:findChildByName("icon_role"), arg_17_2)
	UIUtil:updatePetRoleText(var_17_0:findChildByName("txt_role"), arg_17_2)
	UIUtil:updatePetLevel(var_17_0:findChildByName("n_lv"), arg_17_2, {
		show_max_lv = true
	})
	var_17_0:setOpacity(0)
	UIAction:Add(SEQ(DELAY(160), FADE_IN(200)), var_17_0, "block")
	arg_17_0:update_noti()
end

function PetRingMenu.update_noti(arg_18_0)
	if not arg_18_0.vars or not arg_18_0.vars.base then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.base:findChildByName("n_1")
	local var_18_1 = arg_18_0.vars.pet:isTodayTakeCare() and arg_18_0.vars.pet:isFavUpgradeable()
	
	if var_18_1 and Account:getPropertyCount(GAME_STATIC_VARIABLE.pet_care_token) < (GAME_CONTENT_VARIABLE.pet_care_price or 50) then
		var_18_1 = false
	end
	
	if_set_visible(var_18_0, "noti", var_18_1)
end

function PetRingMenu.update_opacity_in_pethouse(arg_19_0)
	if not arg_19_0.vars or not arg_19_0.vars.base then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.base
	local var_19_1 = {
		not arg_19_0.vars.pet:isFavUpgradeable(),
		arg_19_0.vars.pet:isMaxLevel()
	}
	
	for iter_19_0 = 1, 4 do
		local var_19_2 = var_19_0:findChildByName("n_" .. iter_19_0)
		local var_19_3 = 255
		
		if var_19_1[iter_19_0] then
			var_19_3 = 127.5
		end
		
		if_set_opacity(var_19_2, nil, var_19_3)
		if_set_opacity(var_19_2, "label", var_19_3)
	end
end

function PetRingMenu.set_string_in_pethouse(arg_20_0, arg_20_1)
	local var_20_0 = {
		"ui_pet_care_popup_btn",
		"ui_pet_detail_upgrade",
		"ui_pet_detail_synthesis",
		"unit_menu_detail"
	}
	
	for iter_20_0 = 1, 4 do
		local var_20_1 = arg_20_1:findChildByName("n_" .. iter_20_0)
		
		if_set(var_20_1, "label", T(var_20_0[iter_20_0]))
	end
end

function PetRingMenu.show(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	arg_21_0:ui_init(arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	
	arg_21_0.vars.is_pet = true
	arg_21_0.vars.pet = arg_21_4
	
	arg_21_0:show_on_pethouse(arg_21_0.vars.base, arg_21_4)
	arg_21_0:set_string_in_pethouse(arg_21_0.vars.base)
	arg_21_0:update_opacity_in_pethouse()
end

function PetRingMenu.getRingDlg(arg_22_0)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.base) then
		return 
	end
	
	return arg_22_0.vars.base
end
