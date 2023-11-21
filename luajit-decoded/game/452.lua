PetHouse = {}

function MsgHandler.market_pet(arg_1_0)
	GachaPet:close_petGachaResult()
	GachaPet:close_petGachaPopup()
	PetHouse:toggleUI(false)
	PetShop:open(nil, arg_1_0.list)
end

function HANDLER.unit_pet_house(arg_2_0, arg_2_1)
	if arg_2_1 ~= "btn_bg" then
		PetHouse:closeBGPacks()
	end
	
	if arg_2_1 == "btn_remove" then
		PetHouse:onSlotRemove()
		PetHouse:setNormalMode()
	end
	
	if arg_2_1 == "btn_team_detail" then
	elseif arg_2_1 == "btn_slot_select" then
		PetHouse:onSlotSelect(arg_2_0.slot_idx)
	elseif arg_2_1 == "btn_slot" then
		PetHouse:onSlotButtonPushed(arg_2_0)
	elseif arg_2_1 == "btn_setting" then
		PetUIMain:pushMode("Detail")
	end
	
	if arg_2_1 == "btn_shop" then
		if not ContentDisable:byAlias("market_pet") then
			query("market_pet")
		else
			balloon_message_with_sound("content_disable")
		end
	end
	
	if arg_2_1 == "btn_bg" then
		PetHouse:showBGPacks()
	elseif arg_2_1 == "btn_bg_close" then
		PetHouse:closeBGPacks()
	end
	
	if arg_2_1 == "btn_summon" then
		GachaPet:open_petGachaPopup({
			close_callback = PetHouse:getGachaCloseCallback()
		})
	end
	
	if arg_2_1 == "btn_synthesis" and not Account:checkPet_gachafree() then
		PetUIMain:pushMode("Synthesis")
	end
	
	if arg_2_1 == "btn_transfer" then
		if PetHouse:isFocus() then
			local var_2_0 = PetRingMenu:getRingDlg()
			
			PetUIMain:popBackFunc("PetHouse_Focus", var_2_0)
		end
		
		PetDetail:openPetTransfer()
	end
	
	if arg_2_1 == "add_inven" then
		UIUtil:showIncPetInvenDialog()
	end
	
	if arg_2_1 == "btn_lobby_set" then
		PetSettingPopup:init({
			mode = "Lobby",
			parent = SceneManager:getRunningPopupScene(),
			close_callback = function()
				PetHouse:uiSetting()
			end,
			update_callback = function(arg_4_0, arg_4_1)
				PetHouse:updateLobbyPetItem(arg_4_0, arg_4_1)
			end
		})
	end
end

function PetHouse.onCreate(arg_5_0)
	arg_5_0.vars = {}
	arg_5_0.vars.dlg = load_dlg("unit_pet_house", true, "wnd")
	arg_5_0.vars.parent = PetUIBase:getBaseUI()
	
	arg_5_0.vars.parent:addChild(arg_5_0.vars.dlg)
	
	arg_5_0.vars.pet_belt = PetUIBase:getPetBelt()
	arg_5_0.vars.pet_slots = {}
	
	for iter_5_0 = 1, 6 do
		arg_5_0.vars.pet_slots[iter_5_0] = arg_5_0.vars.dlg:findChildByName("n_pet" .. iter_5_0)
	end
	
	arg_5_0.vars.n_pet_select = arg_5_0.vars.dlg:findChildByName("n_pet_select")
	
	arg_5_0:uiSetting()
	arg_5_0:slotSetting()
	
	arg_5_0.vars.ui_bg = UIBackground:create(arg_5_0.vars.dlg:findChildByName("n_bg"), 2, "bg_position_pet", "bg_scale_pet", {
		default_poses = {
			0,
			0,
			0
		}
	})
	
	BGSelector:dataInit("PetHouse", function(arg_6_0, arg_6_1)
		arg_5_0:onChangeBackground(arg_6_0, arg_6_1)
	end)
	
	local var_5_0 = Account:getConfigData("pethouse_bg_id")
	
	if var_5_0 then
		arg_5_0.vars.bg_select_idx = BGSelector:setToID(var_5_0)
		
		if not arg_5_0.vars.bg_select_idx then
			BGSelector:callEvent(1)
		end
	else
		arg_5_0.vars.bg_select_idx = 1
		
		BGSelector:callEvent(1)
	end
	
	arg_5_0:updateSynthesisOpacity()
	arg_5_0:updateFreeDailyGachaNoti()
	arg_5_0:updateTransferOpacity()
end

function PetHouse.onEnter(arg_7_0)
	arg_7_0:eventSetting()
	arg_7_0:petBeltSetting()
	PetUIBase:clilpPetBelt(true, arg_7_0.vars.dlg)
	SoundEngine:play("event:/ui/main_hud/btn_pethouse")
	TutorialGuide:procGuide("pet_team")
	TutorialGuide:ifStartGuide("pet_present_new")
	TopBarNew:setTitleName(T("ui_pet_house_title"), "infopet")
end

function PetHouse.onPause(arg_8_0)
	PetUIBase:clilpPetBelt(false)
	if_set_visible(arg_8_0.vars.dlg, nil, false)
end

function PetHouse.onResume(arg_9_0, arg_9_1)
	if_set_visible(arg_9_0.vars.dlg, nil, true)
	arg_9_0:eventSetting()
	arg_9_0:petBeltSetting()
	PetUIBase:clilpPetBelt(true, arg_9_0.vars.dlg)
	
	arg_9_1 = arg_9_1 or {}
	
	local var_9_0 = arg_9_1.pet
	
	if arg_9_0.vars.pet_belt:isItemExist(var_9_0) then
		arg_9_0.vars.pet_belt:scrollToItem(var_9_0)
	else
		arg_9_0.vars.pet_belt:scrollToFirstItem()
		
		local var_9_1 = arg_9_0.vars.pet_belt:getItems()
		
		if var_9_1 then
			var_9_0 = var_9_1[1]
		end
	end
	
	arg_9_0.vars.pet_belt:updateControlColor(nil, var_9_0, nil, true)
	arg_9_0:updatePetHouse()
	TopBarNew:setTitleName(T("ui_pet_house_title"), "infopet")
	arg_9_0:updateTransferOpacity()
end

function PetHouse.onLeave(arg_10_0)
	PetRingMenu:hide()
	BGSelector:remove()
end

function PetHouse.getWnd(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.dlg) then
		return nil
	end
	
	return arg_11_0.vars.dlg
end

function PetHouse.getUIBackground(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	return arg_12_0.vars.ui_bg
end

function PetHouse.updateTransferOpacity(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.dlg) then
		return 
	end
	
	if_set_opacity(arg_13_0.vars.dlg, "btn_transfer", #Account.pets <= 0 and 76.5 or 255)
end

function PetHouse.getGachaCloseCallback(arg_14_0)
	return function()
		arg_14_0:petBeltSetting()
		arg_14_0:updateSynthesisOpacity()
		arg_14_0:updateTransferOpacity()
	end
end

function PetHouse.onSlotRemove(arg_16_0)
	if not arg_16_0.vars.focus then
		print("NOT FOCUS, BUT REMOVE SLOT.")
		
		return 
	end
	
	local var_16_0 = arg_16_0.vars.focus_idx
	
	PetAniDirector:remove(var_16_0)
	
	arg_16_0.vars.pets[var_16_0] = nil
	
	local var_16_1 = {}
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.pets) do
		local var_16_2 = iter_16_1:getUID()
		
		if Account:getPet(var_16_2) then
			table.insert(var_16_1, var_16_2)
		else
			Log.e("Send Not Exist Pet.")
		end
	end
	
	query("set_pet_house", {
		pets = array_to_json(var_16_1)
	})
end

function PetHouse.onSlotSelect(arg_17_0, arg_17_1)
	arg_17_0:focus(arg_17_1)
end

function PetHouse.onTakeCare(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	if not arg_18_1 then
		return 
	end
	
	local var_18_0
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.pets) do
		if iter_18_1:getUID() == arg_18_1:getUID() then
			var_18_0 = iter_18_0
		end
	end
	
	if not var_18_0 then
		return 
	end
	
	PetAniDirector:addEffect(var_18_0, "ui_pet_act_eff.cfx")
end

function PetHouse._getRemainIndex(arg_19_0)
	local var_19_0
	
	for iter_19_0 = 1, 6 do
		if not arg_19_0.vars.pets[iter_19_0] then
			var_19_0 = iter_19_0
		end
	end
	
	return var_19_0
end

function PetHouse.updatePetHouse(arg_20_0)
	local var_20_0 = Account:getInHousePets()
	local var_20_1 = {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		var_20_1[iter_20_1] = true
	end
	
	for iter_20_2, iter_20_3 in pairs(arg_20_0.vars.pets) do
		if not var_20_1[iter_20_3:getUID()] then
			PetAniDirector:remove(iter_20_2)
			
			arg_20_0.vars.pets[iter_20_2] = nil
		else
			local var_20_2 = arg_20_0.vars.dlg:findChildByName("n_pet" .. iter_20_2 .. "_info")
			
			UIUtil:updatePetSlot(var_20_2, iter_20_3, {
				role = "icon_role",
				use_offsets = true,
				offsets = {
					42,
					21
				},
				digits = {
					1,
					2
				}
			})
			
			if Account:isReserveUpdateHousePet(iter_20_3:getUID()) then
				PetAniDirector:remove(iter_20_2)
				arg_20_0:_addPetToSlot(iter_20_2, iter_20_3)
			end
		end
	end
	
	Account:clearReserveUpdateHousePet()
	
	local var_20_3 = {}
	
	for iter_20_4, iter_20_5 in pairs(arg_20_0.vars.pets) do
		var_20_3[iter_20_5:getUID()] = true
	end
	
	for iter_20_6, iter_20_7 in pairs(var_20_1) do
		if not var_20_3[iter_20_6] then
			local var_20_4 = arg_20_0:_getRemainIndex()
			local var_20_5 = Account:getPet(iter_20_6)
			
			if var_20_4 and var_20_5 then
				arg_20_0:_addPetToSlot(var_20_4, var_20_5)
			end
		end
	end
end

function PetHouse.setNormalMode(arg_21_0)
	if arg_21_0.vars.lock_flag then
		if not arg_21_0.vars.lock_ui then
			arg_21_0.vars.lock_flag = false
		end
		
		return 
	end
	
	arg_21_0:releaseFocusMode()
end

function PetHouse.lockUI(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	arg_22_0.vars.lock_ui = true
	arg_22_0.vars.lock_flag = true
end

function PetHouse.breakLockUI(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	arg_23_0.vars.lock_ui = false
	arg_23_0.vars.lock_flag = false
end

function PetHouse.releaseLockUI(arg_24_0)
	if not arg_24_0.vars then
		return 
	end
	
	arg_24_0.vars.lock_ui = false
end

function PetHouse.petBeltEventHandler(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_1 == "select" then
		arg_25_0:onPetBeltSelect(arg_25_2)
	elseif arg_25_1 == "add" then
		arg_25_0:slotAdd(arg_25_2)
	elseif arg_25_1 == "change" then
		PetUIBase:onPetBeltCurrentChange(arg_25_2, arg_25_3)
		PetHouse:setNormalMode()
	end
end

function MsgHandler.set_pet_house(arg_26_0)
	Account:setInHousePets(arg_26_0.house_pets)
end

function PetHouse.onPushBackground(arg_27_0)
	arg_27_0:setNormalMode()
end

function PetHouse.setValueInChangeMode(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.vars.change_mode = arg_28_0.vars.change_mode or {}
	arg_28_0.vars.change_mode[arg_28_1] = arg_28_2
end

function PetHouse.getValueInChangeMode(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0.vars.change_mode then
		print("attemp to release value.")
	end
	
	return arg_29_0.vars.change_mode
end

function PetHouse.isFocus(arg_30_0)
	if not arg_30_0.vars then
		return false
	end
	
	return arg_30_0.vars.focus
end

function PetHouse.releaseFocusMode(arg_31_0)
	if UIAction:Find("block") then
		return 
	end
	
	if arg_31_0.vars.focus then
		PetRingMenu:hide()
		arg_31_0:focusOut()
	end
end

function PetHouse.toggleUI(arg_32_0, arg_32_1)
	if not arg_32_0.vars.dlg then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.dlg:getChildren()
	
	local function var_32_1(arg_33_0, arg_33_1)
		if arg_33_0 then
			arg_33_1:setOpacity(0)
			UIAction:Add(LOG(OPACITY(300, 0, 0.8)), arg_33_1, "block")
		else
			arg_33_1:setOpacity(255)
			UIAction:Add(LOG(FADE_OUT(300)), arg_33_1, "block")
		end
	end
	
	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		if not iter_32_1 then
			break
		end
		
		if iter_32_1:getName() ~= "n_bg" then
			var_32_1(arg_32_1, iter_32_1)
		end
	end
	
	local var_32_2 = arg_32_0.vars.dlg:findChildByName("CENTER")
	
	var_32_1(arg_32_1, var_32_2)
	var_32_1(arg_32_1, arg_32_0.vars.pet_belt:getWnd())
end

function PetHouse.onPetBeltSelect(arg_34_0, arg_34_1)
	if arg_34_0:isFocus() then
		local var_34_0 = PetRingMenu:getRingDlg()
		
		PetUIMain:popBackFunc("PetHouse_Focus", var_34_0)
	end
	
	if arg_34_0.vars.pet_belt:getCurrentItem():getUID() == arg_34_1:getUID() then
		PetUIMain:pushMode("Detail", {
			pet = arg_34_1
		})
	end
end

function PetHouse.uiSetting(arg_35_0)
	local var_35_0 = arg_35_0.vars.dlg:getChildByName("btn_lobby_set")
	local var_35_1 = Account:getLobbyPet()
	
	if_set_visible(var_35_0, "icon_noti", not var_35_1)
end

function PetHouse.updateLobbyPetItem(arg_36_0, arg_36_1, arg_36_2)
	if arg_36_0.vars and arg_36_0.vars.pet_belt then
		local var_36_0 = arg_36_0.vars.pet_belt:getCurrentItem()
		local var_36_1 = false
		
		if arg_36_1 then
			local var_36_2 = var_36_0 == arg_36_1
			
			arg_36_0.vars.pet_belt:updateControlColor(nil, arg_36_1, nil, var_36_2)
		end
		
		if arg_36_2 then
			local var_36_3 = var_36_0 == arg_36_2
			
			arg_36_0.vars.pet_belt:updateControlColor(nil, arg_36_2, nil, var_36_3)
		end
	end
end

function PetHouse.eventSetting(arg_37_0)
	arg_37_0.vars.pet_belt:setEventHandler(arg_37_0.petBeltEventHandler, arg_37_0)
end

function PetHouse.petAddToSlot(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	if not arg_38_3 then
		if_set_visible(arg_38_1, "pet_name", false)
		
		return 
	end
	
	local var_38_0 = UIUtil:updatePetIcon2(nil, arg_38_3)
	
	arg_38_1:findChildByName("n_pet_icon2"):addChild(var_38_0)
	if_set(arg_38_1, "pet_name", T(arg_38_3:getName()))
	if_set_visible(arg_38_1, "pet_name", true)
	arg_38_0:attachSlotModel(arg_38_2, arg_38_3)
	
	return true
end

function PetHouse.onChangeBackground(arg_39_0, arg_39_1, arg_39_2)
	if_set_sprite(arg_39_0.vars.bg_change, "bg_base", arg_39_2.icon)
	if_set(arg_39_0.vars.bg_change, "txt_title", T(arg_39_2.name))
	if_set(arg_39_0.vars.bg_change, "txt_desc", T(arg_39_2.desc))
	
	if arg_39_0.vars.bg_idx ~= arg_39_1 then
		local var_39_0 = arg_39_0.vars.bg_idx == nil
		
		arg_39_0:setBackground(arg_39_2, not var_39_0)
		
		if not var_39_0 then
			arg_39_0.vars.ui_bg:fadeInOut()
		end
		
		SAVE:setTempConfigData("pethouse_bg_id", arg_39_2.id)
		SAVE:sendQueryServerConfig()
	end
	
	arg_39_0.vars.bg_idx = arg_39_1
end

function PetHouse.showBGPacks(arg_40_0)
	if arg_40_0.vars.bg_change or arg_40_0.vars.focus then
		return 
	end
	
	local var_40_0 = load_control("wnd/bg_change_popup.csb")
	local var_40_1 = arg_40_0.vars.dlg:findChildByName("n_bg_pack")
	
	BackButtonManager:push({
		check_id = "bg_change_popup",
		back_func = function()
			PetHouse:closeBGPacks()
		end
	})
	var_40_1:addChild(var_40_0)
	
	arg_40_0.vars.bg_change = var_40_0
	
	BGSelector:init(var_40_0:findChildByName("scrollview"), function(arg_42_0, arg_42_1)
		arg_40_0:onChangeBackground(arg_42_0, arg_42_1)
	end, "PetHouse", arg_40_0.vars.bg_idx)
	if_set_visible(var_40_1, nil, true)
	if_set_visible(arg_40_0.vars.dlg, "btn_bg_close", true)
	if_set_visible(arg_40_0.vars.bg_change, "n_infor", false)
	var_40_0:setPositionY(-800)
	UIAction:Add(LOG(MOVE_TO(400, nil, 0)), var_40_0, "block")
end

function PetHouse.closeBGPacks(arg_43_0)
	if not arg_43_0.vars.bg_change then
		return 
	end
	
	if_set_visible(arg_43_0.vars.dlg, "btn_bg_close", false)
	BackButtonManager:pop("bg_change_popup")
	UIAction:Add(SEQ(LOG(MOVE_TO(400, nil, -800)), REMOVE()), arg_43_0.vars.bg_change, "block")
	
	arg_43_0.vars.bg_change = nil
	
	BGSelector:close()
end

function PetHouse.slotAnimationSetting(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_0.vars.dlg:findChildByName("n_pet" .. arg_44_3 .. "_info")
	local var_44_1 = arg_44_1:findChildByName("n_pos")
	
	UIUtil:updatePetSlot(var_44_0, arg_44_2, {
		role = "icon_role",
		use_offsets = true,
		offsets = {
			42,
			21
		},
		digits = {
			1,
			2
		}
	})
	
	local var_44_2 = UIUtil:getPetModel(arg_44_2)
	
	var_44_1:addChild(var_44_2)
	var_44_2:loadTexture()
	
	local var_44_3 = var_44_2:createShadow()
	
	var_44_3:setGlobalZOrder(0)
	var_44_3:setLocalZOrder(-10)
	
	local var_44_4 = var_44_1:findChildByName("btn_slot_select")
	
	var_44_4.slot_idx = arg_44_3
	
	if_set_visible(var_44_4, nil, true)
	
	return {
		pet = arg_44_2,
		model = var_44_2,
		node = arg_44_1,
		info_node = var_44_0,
		slot_idx = arg_44_3
	}
end

function PetHouse.slotSetting(arg_45_0)
	arg_45_0.vars.pets = {}
	
	local var_45_0 = Account:getInHousePets()
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		local var_45_1 = Account:getPet(iter_45_1)
		
		table.insert(arg_45_0.vars.pets, var_45_1)
	end
	
	local var_45_2 = {}
	
	for iter_45_2 = 1, 6 do
		local var_45_3 = arg_45_0.vars.pet_slots[iter_45_2]
		local var_45_4 = arg_45_0.vars.pets[iter_45_2]
		
		if not var_45_4 then
			if_set_visible(var_45_3, nil, false)
		else
			var_45_2[iter_45_2] = arg_45_0:slotAnimationSetting(var_45_3, var_45_4, iter_45_2)
		end
	end
	
	PetAniDirector:init(var_45_2)
end

function PetHouse.addPetToSlot(arg_46_0, arg_46_1, arg_46_2)
	if UIAction:Find("ani_end_effect") then
		return 
	end
	
	local var_46_0 = arg_46_0:_addPetToSlot(arg_46_1, arg_46_2)
	
	query("set_pet_house", {
		pets = array_to_json(var_46_0)
	})
end

function PetHouse._addPetToSlot(arg_47_0, arg_47_1, arg_47_2)
	arg_47_0.vars.pets[arg_47_1] = arg_47_2
	
	local var_47_0 = arg_47_0.vars.pet_slots[arg_47_1]
	local var_47_1 = arg_47_0:slotAnimationSetting(var_47_0, arg_47_2, arg_47_1)
	
	PetAniDirector:addPet(var_47_1, arg_47_1, true)
	if_set_visible(var_47_0, nil, true)
	
	local var_47_2 = {}
	
	for iter_47_0, iter_47_1 in pairs(arg_47_0.vars.pets) do
		table.insert(var_47_2, iter_47_1:getUID())
	end
	
	return var_47_2
end

function PetHouse.slotAdd(arg_48_0, arg_48_1)
	local var_48_0
	local var_48_1 = false
	
	for iter_48_0 = 1, 6 do
		if arg_48_0.vars.pets[iter_48_0] and arg_48_0.vars.pets[iter_48_0]:getUID() == arg_48_1:getUID() then
			var_48_1 = true
			
			break
		end
	end
	
	if var_48_1 then
		balloon_message_with_sound("ui_pet_house_already_in")
		
		return 
	end
	
	for iter_48_1 = 1, 6 do
		if not arg_48_0.vars.pets[iter_48_1] then
			var_48_0 = iter_48_1
		end
	end
	
	if not var_48_0 then
		balloon_message_with_sound("ui_pet_house_full")
		
		return 
	end
	
	SoundEngine:play("event:/ui/pet/" .. arg_48_1:getRace())
	arg_48_0:addPetToSlot(var_48_0, arg_48_1)
end

function PetHouse.focus(arg_49_0, arg_49_1)
	if not arg_49_1 then
		return 
	end
	
	if UIAction:Find("block") then
		return 
	end
	
	if arg_49_0.vars.focus then
		return 
	end
	
	local var_49_0 = 1 * arg_49_0.vars.dlg:findChildByName("n_pet_select"):getScale()
	local var_49_1, var_49_2 = PetAniDirector:focus(arg_49_1, arg_49_0.vars.dlg:findChildByName("n_pet_select"), var_49_0)
	
	PetAniDirector:pause()
	
	local var_49_3 = PetAniDirector:getBoundingBox(arg_49_1)
	local var_49_4 = 100
	local var_49_5 = (VIEW_WIDTH / 2 - var_49_1) * var_49_0
	local var_49_6 = (VIEW_HEIGHT / 2 - var_49_2) * var_49_0
	local var_49_7 = var_49_5 - var_49_3.width / 2 * var_49_0
	local var_49_8 = var_49_6 - var_49_3.height / 2 * var_49_0
	local var_49_9 = arg_49_0.vars.ui_bg:getBG()
	
	UIAction:Add(LOG(MOVE_TO(500, var_49_7 + VIEW_BASE_LEFT / 2 - var_49_4, var_49_8)), var_49_9, "block")
	UIAction:Add(LOG(SCALE_TO(500, var_49_0)), var_49_9, "block")
	
	arg_49_0.vars.focus = true
	arg_49_0.vars.focus_idx = arg_49_1
	
	if_set_visible(arg_49_0.vars.dlg, "n_pet_select", true)
	if_set_visible(arg_49_0.vars.dlg, "n_select", true)
	PetRingMenu:show(arg_49_0.vars.dlg, VIEW_BASE_LEFT + VIEW_WIDTH / 2 - var_49_4, VIEW_HEIGHT / 2, arg_49_0.vars.pets[arg_49_1], {
		dlg_name = "unit_menu_pet",
		pet = true
	})
	arg_49_0.vars.pet_belt:scrollToItem(arg_49_0.vars.pets[arg_49_1])
	
	local var_49_10 = PetRingMenu:getRingDlg()
	
	PetUIMain:addBackFunc("PetHouse_Focus", var_49_10, function()
		arg_49_0:releaseFocusMode()
		arg_49_0:breakLockUI()
	end)
end

function PetHouse.focusOut(arg_51_0)
	if not arg_51_0.vars.focus then
		return 
	end
	
	local var_51_0 = 1
	local var_51_1 = arg_51_0.vars.ui_bg:getBG()
	
	UIAction:Add(LOG(MOVE_TO(500, 0, 0)), var_51_1)
	UIAction:Add(LOG(SCALE_TO(500, var_51_0 * 1)), var_51_1)
	PetAniDirector:resume()
	PetAniDirector:focusOut(arg_51_0.vars.focus_idx, arg_51_0.vars.dlg:findChildByName("n_pet_select"))
	
	arg_51_0.vars.focus = false
	arg_51_0.vars.focus_idx = nil
	
	if_set_visible(arg_51_0.vars.dlg, "n_pet_select", false)
	if_set_visible(arg_51_0.vars.dlg, "n_select", false)
end

function PetHouse.setBackground(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0.vars.dlg:findChildByName("n_bg")
	
	arg_52_0.vars.ui_bg:setBackground(arg_52_1, arg_52_2)
	
	local var_52_1 = var_52_0:findChildByName("CENTER")
	
	var_52_1:ejectFromParent()
	
	local var_52_2 = arg_52_0.vars.ui_bg:getUsableBG(arg_52_2) or var_52_0
	
	var_52_2:setAnchorPoint(0.5, 0.5)
	var_52_2:addChild(var_52_1)
	
	local var_52_3 = cc.c3b(255, 255, 255)
	
	if arg_52_1.ambient_color then
		local var_52_4 = tonumber(string.sub(arg_52_1.ambient_color, 1, 2), 16)
		local var_52_5 = tonumber(string.sub(arg_52_1.ambient_color, 3, 4), 16)
		local var_52_6 = tonumber(string.sub(arg_52_1.ambient_color, 5, 6), 16)
		
		var_52_3 = cc.c3b(var_52_4, var_52_5, var_52_6)
	end
	
	PetAniDirector:setAmbientColor(var_52_3)
end

function PetHouse.attachSlotModel(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = "n_pos" .. arg_53_1
	local var_53_1 = arg_53_0.vars.dlg:findChildByName(var_53_0)
	local var_53_2 = UIUtil:getPetModel(arg_53_2)
	
	var_53_2:setScale(1)
	var_53_1:addChild(var_53_2)
end

function PetHouse.fade_in_out(arg_54_0)
	local var_54_0 = cc.Node:create()
	
	var_54_0:setPosition(-VIEW_WIDTH * 2, 600)
	
	for iter_54_0 = 1, 8 do
		for iter_54_1 = 1, 15 do
			local var_54_1 = PET:create({
				grade = 1,
				code = "pet001_1"
			})
			local var_54_2 = UIUtil:getPetModel(var_54_1)
			local var_54_3 = iter_54_1 * 100
			local var_54_4 = iter_54_0 * 110 - 200
			
			var_54_2:setScale(3)
			var_54_2:setPosition(iter_54_1 * 100, iter_54_0 * 110 - 200)
			var_54_0:addChild(var_54_2)
			
			local var_54_5 = var_54_3 + VIEW_WIDTH * 4 + math.random() % 2000
			local var_54_6 = var_54_4 + math.random() % 600
			
			UIAction:Add(SPAWN(MOVE_TO(5000, var_54_5, var_54_6), (SCALE_TO(5000, 3 + math.random() % 100 / 2))), var_54_2)
		end
	end
	
	var_54_0:setPositionY(-120)
	SceneManager:getRunningNativeScene():addChild(var_54_0)
end

function PetHouse.petBeltSetting(arg_55_0)
	arg_55_0.vars.pet_belt:setData(Account:getPets(), "House")
	arg_55_0.vars.pet_belt:updateControlColor(nil, arg_55_0.vars.pet_belt:getCurrentItem(), nil, true)
	PetUIBase:onPetBeltCurrentChange(nil, arg_55_0.vars.pet_belt:getCurrentItem())
end

function PetHouse.updateFreeDailyGachaNoti(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_56_0.vars.dlg) then
		return 
	end
	
	local var_56_0 = arg_56_0.vars.dlg:getChildByName("btn_summon")
	
	arg_56_0.vars.dlg:getChildByName("icon_noti"):setVisible(GachaPet:isFreeDailyGacha())
end

function PetHouse.updateSynthesisOpacity(arg_57_0)
	local var_57_0 = Account:checkPet_gachafree() and 80 or 255
	
	if_set_opacity(arg_57_0.vars.dlg, "btn_synthesis", var_57_0)
end

function PetHouse.check_noti(arg_58_0)
	if UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) and (Account:checkPet_gachafree() or GachaPet:isFreeDailyGacha()) then
		return true
	end
	
	return false
end
