PetDetail = {}

function HANDLER.unit_pet_detail(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_lock" then
		PetDetail:setPetLock(true)
	elseif arg_1_1 == "btn_voice" then
		PetDetail.vars.pet:playPetSound()
	elseif arg_1_1 == "btn_locked" then
		PetDetail:setPetLock(false)
	elseif arg_1_1 == "btn_transfer" then
		PetDetail:openPetTransfer()
	elseif arg_1_1 == "btn_name_set" then
		PetDetail:setPetName()
	elseif arg_1_1 == "btn_care" then
		PetCare:open_carePopup(nil, {
			callback = PetDetail:getPetCareCallback()
		})
	elseif arg_1_1 == "btn_reinforce" then
		PetDetail:openPetUpgrade()
	elseif arg_1_1 == "btn_synthesis" then
		PetDetail:openPetSynthesis()
	elseif arg_1_1 == "btn_Help" then
		PetAffectionPopup:show()
	elseif arg_1_1 == "btn_transform" then
		PetDetail:openPetTransform()
	elseif arg_1_1 == "add_inven" then
		UIUtil:showIncPetInvenDialog()
	end
end

function MsgHandler.lock_pet(arg_2_0)
	if arg_2_0.flag == 1 then
		SoundEngine:play("event:/ui/unit_detail/btn_lock")
	else
		SoundEngine:play("event:/ui/unit_detail/btn_unlock")
	end
	
	PetDetail:onLockPet(arg_2_0.uid, arg_2_0.flag)
end

function PetDetail.onCreate(arg_3_0, arg_3_1)
	arg_3_0.vars = {}
	arg_3_1 = arg_3_1 or {}
	arg_3_0.vars.dlg = load_dlg("unit_pet_detail", true, "wnd")
	arg_3_0.vars.parent = PetUIBase:getBaseUI()
	
	arg_3_0.vars.parent:addChild(arg_3_0.vars.dlg)
	
	arg_3_0.vars.pet_belt = PetUIBase:getPetBelt()
	
	arg_3_0:skillViewSetting()
	
	local var_3_0 = arg_3_1.pet or arg_3_0.vars.pet_belt:getItems()[1]
	
	arg_3_0:setPetInfos(var_3_0)
	
	local var_3_1 = arg_3_0.vars.dlg:findChildByName("bar")
	
	var_3_1:setPositionX(var_3_1:getPositionX() - VIEW_BASE_LEFT)
	arg_3_0:slideIn()
end

function PetDetail.onEnter(arg_4_0)
	arg_4_0:eventSetting()
	arg_4_0.vars.pet_belt:setData(Account:getPets(), "Detail")
	
	if arg_4_0.vars.pet then
		arg_4_0.vars.pet_belt:updateControlColor(nil, arg_4_0.vars.pet, nil, true)
	end
	
	if PetHouse:isFocus() then
		PetRingMenu:hide()
	end
	
	TutorialNotice:update("pet_ui")
end

function PetDetail.onPause(arg_5_0)
	arg_5_0:slideOut()
end

function PetDetail.onResume(arg_6_0, arg_6_1)
	local var_6_0 = Account:getPets()
	
	if table.empty(var_6_0) then
		PetUIMain:popMode()
		
		return 
	end
	
	arg_6_0:eventSetting()
	arg_6_0.vars.pet_belt:setData(var_6_0, "Detail")
	
	arg_6_1 = arg_6_1 or {}
	
	local var_6_1 = arg_6_1.pet
	
	if arg_6_0.vars.pet_belt:isItemExist(var_6_1) then
		arg_6_0.vars.pet_belt:scrollToItem(var_6_1)
	elseif arg_6_0.vars.pet_belt:isItemExist(arg_6_0.vars.pet) then
		arg_6_0.vars.pet_belt:scrollToItem(arg_6_0.vars.pet)
		
		var_6_1 = arg_6_0.vars.pet
	else
		arg_6_0.vars.pet_belt:scrollToFirstItem()
		
		local var_6_2 = arg_6_0.vars.pet_belt:getItems()
		
		if var_6_2 then
			var_6_1 = var_6_2[1]
		end
	end
	
	arg_6_0.vars.pet_belt:updateControlColor(nil, var_6_1, nil, true)
	arg_6_0:setPetModel(var_6_1)
	arg_6_0:onPetBeltSelect(var_6_1)
	arg_6_0:slideIn()
end

function PetDetail.onLeave(arg_7_0)
	arg_7_0:slideOut()
	UIAction:Add(SEQ(DELAY(200), REMOVE()), arg_7_0.vars.dlg)
	
	local var_7_0 = {
		pet = arg_7_0.vars.pet_belt:getCurrentItem()
	}
	
	arg_7_0.vars = nil
	
	return var_7_0
end

function PetDetail.getWnd(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.dlg) then
		return nil
	end
	
	return arg_8_0.vars.dlg
end

function PetDetail.onLockPet(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = Account:getPet(arg_9_1)
	
	if not var_9_0 then
		Log.e("Check Pet UID. lock failed.")
		
		return 
	end
	
	if arg_9_2 == 1 then
		balloon_message_with_sound("ui_pet_detail_lock_on")
	else
		balloon_message_with_sound("ui_pet_detail_lock_off")
	end
	
	var_9_0:setLocked(arg_9_2)
	arg_9_0:setPetButtons(var_9_0)
	arg_9_0.vars.pet_belt:updatePet(nil, var_9_0, true)
end

function PetDetail.getPetCareCallback(arg_10_0)
	return function(arg_11_0)
		if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.dlg) then
			return 
		end
		
		arg_10_0:updatePetInfos()
		arg_10_0:updateLoveEffect(arg_11_0)
	end
end

function MsgHandler.set_pet_name(arg_12_0)
	if table.count(arg_12_0.result) > 0 then
		Account:updateCurrencies(arg_12_0.result)
	end
	
	PetDetail:onSetPetName(arg_12_0.uid, arg_12_0.flag)
	TeamNameModifyDialog:close()
	balloon_message_with_sound("ui_pet_name_change_success")
end

function PetDetail.onSetPetName(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Account:getPet(arg_13_1)
	
	var_13_0:setName(arg_13_2)
	TopBarNew:setTitleName(var_13_0:getName(), "infopet")
	arg_13_0.vars.pet_belt:updatePet(nil, var_13_0)
	arg_13_0.vars.pet_belt:updateControlColor(nil, var_13_0, nil, true)
	
	local var_13_1 = arg_13_0.vars.dlg:findChildByName("name")
	
	UIUtil:updatePetNameInfo(var_13_1, var_13_0)
end

function PetDetail.onActivePetCare(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.dlg) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.dlg:getChildByName("n_pos")
	local var_14_1 = 1 / var_14_0:getScale()
	
	EffectManager:Play({
		fn = "ui_pet_takecare.cfx",
		layer = var_14_0,
		scale = var_14_1
	})
end

function PetDetail.slideOut(arg_15_0)
	PetUIBase:clilpPetBelt(false)
	
	local var_15_0 = arg_15_0.vars.dlg:findChildByName("LEFT")
	local var_15_1 = arg_15_0.vars.dlg:findChildByName("CENTER")
	local var_15_2 = arg_15_0.vars.dlg:findChildByName("bar")
	local var_15_3 = var_15_0:findChildByName("TOP_LEFT")
	local var_15_4 = var_15_0:findChildByName("n_exp_detail")
	local var_15_5 = var_15_0:findChildByName("n_lv")
	local var_15_6 = var_15_0:findChildByName("btn")
	local var_15_7 = var_15_0:findChildByName("skill")
	local var_15_8 = arg_15_0.vars.dlg:findChildByName("RIGHT")
	local var_15_9 = var_15_8:getChildByName("n_favorabililty")
	local var_15_10 = var_15_8:getChildByName("n_info")
	local var_15_11 = 200
	
	if_set_visible(var_15_8, "n_list", false)
	if_set_visible(arg_15_0.vars.dlg, "grow", false)
	UIAction:Add(SEQ(LOG(FADE_OUT(var_15_11))), var_15_0, "block")
	UIAction:Add(SEQ(LOG(FADE_OUT(var_15_11))), var_15_1, "block")
	UIAction:Add(SEQ(SLIDE_OUT(var_15_11, -600)), var_15_3, "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_OUT(var_15_11, -600)), var_15_5, "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_OUT(var_15_11, -600)), var_15_4, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(var_15_11, -1200)), var_15_6, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(var_15_11, -1200)), var_15_7, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(var_15_11, -1200)), var_15_1, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(var_15_11, -1200)), var_15_2, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(var_15_11, -1200)), var_15_9, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(var_15_11, -1200)), var_15_10, "block")
	UIAction:Add(SEQ(LOG(FADE_OUT(var_15_11))), arg_15_0.vars.dlg, "block")
end

function PetDetail.slideIn(arg_16_0)
	local var_16_0 = arg_16_0.vars.dlg:findChildByName("LEFT")
	local var_16_1 = arg_16_0.vars.dlg:findChildByName("CENTER")
	local var_16_2 = arg_16_0.vars.dlg:findChildByName("bar")
	local var_16_3 = var_16_0:findChildByName("TOP_LEFT")
	local var_16_4 = var_16_0:findChildByName("n_exp_detail")
	local var_16_5 = var_16_0:findChildByName("n_lv")
	local var_16_6 = var_16_0:findChildByName("btn")
	local var_16_7 = var_16_0:findChildByName("skill")
	local var_16_8 = arg_16_0.vars.dlg:findChildByName("RIGHT")
	local var_16_9 = var_16_8:getChildByName("n_favorabililty")
	local var_16_10 = var_16_8:getChildByName("n_info")
	
	if_set_visible(var_16_8, "n_list", true)
	
	local var_16_11 = 200
	
	PetUIBase:clilpPetBelt(true, arg_16_0.vars.dlg)
	if_set_visible(arg_16_0.vars.dlg, nil, true)
	if_set_opacity(arg_16_0.vars.dlg, nil, 255)
	var_16_0:setOpacity(0)
	var_16_1:setOpacity(0)
	var_16_9:setOpacity(0)
	var_16_10:setOpacity(0)
	if_set_visible(arg_16_0.vars.dlg, "grow", true)
	UIAction:Add(SEQ(LOG(FADE_IN(var_16_11))), var_16_0, "block")
	UIAction:Add(SEQ(LOG(FADE_IN(var_16_11))), var_16_1, "block")
	UIAction:Add(SEQ(SHOW(true), SLIDE_IN(var_16_11, 600)), var_16_3, "block")
	UIAction:Add(SEQ(SHOW(false), DELAY(80), SHOW(true), SLIDE_IN(var_16_11, 600)), var_16_5, "block")
	UIAction:Add(SEQ(SHOW(false), DELAY(160), SHOW(true), SLIDE_IN(var_16_11, 600)), var_16_4, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(var_16_11, 1200)), var_16_6, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(var_16_11, 1200)), var_16_7, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(var_16_11, 1200)), var_16_1, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(var_16_11, 1200)), var_16_2, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(var_16_11, 1200)), var_16_9, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(var_16_11, 1200)), var_16_10, "block")
end

function PetDetail.onAfterUpdate(arg_17_0)
	if arg_17_0.vars and arg_17_0.vars.changed_tm and arg_17_0.vars.changed_tm + 100 < uitick() then
		arg_17_0:setPetInfos(arg_17_0.vars.changed_pet)
		
		arg_17_0.vars.changed_tm = nil
		arg_17_0.vars.changed_pet = nil
		
		TutorialNotice:update("pet_ui")
	end
end

function PetDetail.onPetBeltSelect(arg_18_0, arg_18_1)
	arg_18_0:setPetInfos(arg_18_1)
	
	arg_18_0.vars.changed_tm = nil
	arg_18_0.vars.changed_pet = nil
	
	TutorialNotice:update("pet_ui")
end

function PetDetail.onPetBeltChange(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.vars.changed_pet = arg_19_2
	arg_19_0.vars.changed_tm = uitick()
end

function PetDetail.petBeltEventHandler(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_1 == "select" then
		arg_20_0:onPetBeltSelect(arg_20_2)
	elseif arg_20_1 == "add" then
		arg_20_0:onPetBeltAdd(arg_20_2)
	elseif arg_20_1 == "change" then
		arg_20_0:onPetBeltChange(arg_20_2, arg_20_3)
	end
end

function PetDetail.eventSetting(arg_21_0)
	arg_21_0.vars.pet_belt:setEventHandler(arg_21_0.petBeltEventHandler, arg_21_0)
end

function PetDetail.skillViewSetting(arg_22_0)
	local var_22_0 = arg_22_0.vars.dlg:findChildByName("scrollview_skill")
	
	arg_22_0.vars.scrollView = var_22_0
	arg_22_0.vars.pet_skill_list = PetSkillList:create({
		mode = "mid",
		control = var_22_0
	})
end

function PetDetail.setPetLock(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.vars.pet:getUID()
	local var_23_1 = 0
	
	if arg_23_1 == true then
		var_23_1 = 1
	end
	
	query("lock_pet", {
		uid = var_23_0,
		flag = var_23_1
	})
end

function PetDetail.setPetName(arg_24_0)
	TeamNameModifyDialog:init(arg_24_0.vars.pet:getUID(), nil, {
		onebyte_len_max = 12,
		name = "ui_pet_name_change_title",
		onebyte_len_min = 1,
		len_min = 1,
		len_max = 8,
		desc = "ui_pet_name_change_1",
		alert_2 = "ui_pet_name_change_alert_2",
		alert_1 = "ui_pet_name_change_alert_1",
		callback = function(arg_25_0, arg_25_1)
			local var_25_0 = Account:getPet(arg_25_0)
			
			if var_25_0:getName() == arg_25_1 then
				balloon_message_with_sound("pet_ui_rename_already")
				
				return 
			end
			
			if var_25_0:isNameChangeFree() then
				query("set_pet_name", {
					uid = arg_25_0,
					name = arg_25_1
				})
			else
				local var_25_1 = load_dlg("msgbox_item_sel", true, "wnd")
				
				UIUtil:getRewardIcon(GAME_STATIC_VARIABLE.pet_rename_price, GAME_STATIC_VARIABLE.pet_rename_token, {
					show_small_count = true,
					show_name = true,
					detail = true,
					parent = var_25_1:getChildByName("reward_item1/1")
				})
				Dialog:msgBox(T("ui_pet_name_token_need"), {
					yesno = true,
					handler = function()
						if Account:getCurrency("crystal") < GAME_STATIC_VARIABLE.pet_rename_price then
							UIUtil:checkCurrencyDialog("crystal")
							
							return 
						end
						
						query("set_pet_name", {
							charged = true,
							uid = arg_25_0,
							name = arg_25_1
						})
					end,
					dlg = var_25_1,
					title = T("ui_pet_name_change_title")
				})
			end
		end
	})
end

function PetDetail.setPetModel(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.vars.dlg:findChildByName("n_pos")
	local var_27_1 = UIUtil:getPetModel(arg_27_1)
	
	arg_27_0.vars.model = var_27_1
	
	var_27_0:removeAllChildren()
	
	arg_27_0.vars.love_effect = nil
	
	var_27_1:setScale(1)
	var_27_0:addChild(var_27_1)
end

function PetDetail.setPetButtons(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.vars.dlg:findChildByName("n_btn_lock")
	local var_28_1 = arg_28_1:isLocked()
	
	if_set_visible(var_28_0, "btn_lock", var_28_1 ~= true)
	if_set_visible(var_28_0, "btn_locked", var_28_1)
	
	if arg_28_1:isFavUpgradeable() then
		if_set_opacity(arg_28_0.vars.dlg, "btn_care", 255)
	else
		if_set_opacity(arg_28_0.vars.dlg, "btn_care", 76.5)
	end
	
	if not arg_28_1:isMaxLevel() then
		if_set_opacity(arg_28_0.vars.dlg, "btn_reinforce", 255)
	else
		if_set_opacity(arg_28_0.vars.dlg, "btn_reinforce", 76.5)
	end
	
	if_set_visible(arg_28_0.vars.dlg, "noti_care", false)
	if_set_visible(arg_28_0.vars.dlg, "noti_reinforce", false)
	if_set_visible(arg_28_0.vars.dlg, "noti_Synthesis", false)
	if_set_visible(arg_28_0.vars.dlg, "noti_trans", false)
end

function PetDetail.updateLoveEffect(arg_29_0, arg_29_1)
	arg_29_0.vars.love_effect = UIUtil:setLoveEffect(arg_29_0.vars.love_effect, arg_29_0.vars.model, arg_29_1)
end

function PetDetail.updatePetInfos(arg_30_0)
	arg_30_0:setPetInfos(arg_30_0.vars.pet, true)
end

function PetDetail.setPetInfos(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.vars.dlg:findChildByName("name")
	
	TopBarNew:setTitleName(arg_31_1:getName(), "infopet")
	UIUtil:updatePetNameInfo(var_31_0, arg_31_1)
	UIUtil:updatePetMainInfo(var_31_0, arg_31_1, {
		show_full_desc = true,
		is_ani = false,
		show_max_lv = true,
		use_offset = true
	})
	
	local var_31_1 = arg_31_0.vars.dlg:findChildByName("n_favorabililty")
	
	UIUtil:updatePetFavInfos(var_31_1, arg_31_1, {
		txt_desc = "txt_title",
		is_ani = false
	})
	arg_31_0.vars.pet_skill_list:setPet(arg_31_1)
	arg_31_0:setPetButtons(arg_31_1)
	
	if arg_31_1 == arg_31_0.vars.pet then
		return 
	end
	
	arg_31_0:setPetModel(arg_31_1)
	arg_31_0:updateLoveEffect(arg_31_1)
	
	arg_31_0.vars.pet = arg_31_1
end

function PetDetail.openPetUpgrade(arg_32_0)
	if arg_32_0.vars.pet:isMaxLevel() then
		balloon_message_with_sound("ui_pet_upgrade_already_max")
	else
		PetUIMain:pushMode("Upgrade", {
			pet = arg_32_0.vars.pet
		})
	end
end

function PetDetail.openPetSynthesis(arg_33_0)
	if not arg_33_0.vars.pet:isCanSynthesis() then
		local var_33_0 = arg_33_0.vars.pet:getUsableSynthesisList()
		
		Dialog:msgPetLock(var_33_0)
		
		return 
	end
	
	PetUIMain:pushMode("Synthesis", {
		pet = arg_33_0.vars.pet
	})
end

function PetDetail.openPetTransform(arg_34_0)
	PetUIMain:pushMode("Transform", {
		pet = arg_34_0.vars.pet
	})
end

function PetDetail.openPetTransfer(arg_35_0)
	if #Account.pets <= 0 then
		return 
	end
	
	local var_35_0 = PetUIBase:getPetBelt()
	
	if var_35_0 then
		local var_35_1 = var_35_0:getCurrentItem()
		
		PetUIMain:pushMode("Transfer", {
			pet = var_35_1
		})
	end
end
