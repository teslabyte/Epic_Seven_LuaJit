PetSettingPopup = {}

function MsgHandler.set_slot_pet(arg_1_0)
	PetSettingPopup:res_lobbyPet(arg_1_0)
end

function HANDLER.pet_config_p(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_ok" then
		PetSettingPopup:petAddToTeam()
	elseif arg_2_1 == "btn_cancel" then
		PetSettingPopup:petRemoveFromTeam()
	elseif arg_2_1 == "btn_setting" then
		PetHelper:open_petSetting(PetSettingPopup.vars.pet, PetSettingPopup.vars.team_idx)
	elseif arg_2_1 == "btn_close" then
		PetSettingPopup:close()
	end
end

function PetSettingPopup.petAddToTeam(arg_3_0)
	if arg_3_0:isBackPlayingTeam() then
		balloon_message_with_sound("msg_bgbattle_cant_change_pet")
		
		return 
	end
	
	local function var_3_0(arg_4_0)
		local var_4_0, var_4_1 = BattleRepeat:getConfigRepeatBattleCount(arg_4_0 or arg_3_0.vars.team_idx)
		
		if var_4_0 > arg_3_0.vars.pet:getRepeat_count() or var_4_1 then
			BattleRepeat:setConfigRepeatBattleCount(arg_3_0.vars.pet:getRepeat_count(), arg_4_0 or arg_3_0.vars.team_idx)
		end
	end
	
	if arg_3_0.vars.mode == "Battle" or arg_3_0.vars.mode == "Descent" or arg_3_0.vars.mode == "Burning" then
		var_3_0()
		Account:petAddToTeam(arg_3_0.vars.pet, arg_3_0.vars.team_idx)
	elseif arg_3_0.vars.mode == "Lobby" then
		arg_3_0:set_lobbyPet()
		
		return 
	else
		Log.e("Unknown PetSettingPopup Mode.")
	end
	
	if arg_3_0.vars.select_callback and arg_3_0.vars.team_idx then
		arg_3_0.vars.select_callback(arg_3_0.vars.pet, arg_3_0.vars.team_idx)
	end
	
	PetSettingPopup:close(true)
end

function PetSettingPopup.isBackPlayingTeamPet(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.dlg) or not BackPlayManager:isRunning() then
		return 
	end
	
	if not arg_5_0.vars.mode or arg_5_0.vars.mode == "Lobby" or not arg_5_0.vars.pet then
		return 
	end
	
	return BackPlayManager:isRunningTeamPet(arg_5_0.vars.pet:getUID())
end

function PetSettingPopup.isBackPlayingTeam(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.dlg) or not BackPlayManager:isRunning() then
		return 
	end
	
	if not arg_6_0.vars.mode or arg_6_0.vars.mode == "Lobby" or not arg_6_0.vars.team_idx then
		return 
	end
	
	local var_6_0 = BackPlayManager:getRunningTeamIdx() or 0
	
	return arg_6_0.vars.team_idx == var_6_0
end

function PetSettingPopup.petRemoveFromTeam(arg_7_0)
	if arg_7_0:isBackPlayingTeam() then
		balloon_message_with_sound("msg_bgbattle_cant_change_pet")
		
		return 
	end
	
	if arg_7_0.vars.mode == "Battle" or arg_7_0.vars.mode == "Descent" or arg_7_0.vars.mode == "Burning" then
		Account:petAddToTeam(nil, arg_7_0.vars.team_idx)
	elseif arg_7_0.vars.mode == "Lobby" then
		arg_7_0:set_lobbyPet({
			putOff = true
		})
		
		return 
	else
		Log.e("Unknown PetSettingPopup Mode.")
	end
	
	if arg_7_0.vars.select_callback and arg_7_0.vars.team_idx then
		arg_7_0.vars.select_callback(nil, arg_7_0.vars.team_idx)
	end
	
	PetSettingPopup:close(true)
end

function PetSettingPopup.init(arg_8_0, arg_8_1)
	if arg_8_0.vars then
		Log.e("DO NOT OPEN TWICE!")
	end
	
	TutorialGuide:procGuide("pet_team")
	
	if arg_8_1.mode == "Lobby" and not Account:isLobbyPet_exist() then
		balloon_message_with_sound("ui_lobby_ui_pet_none")
		
		return 
	end
	
	arg_8_1 = arg_8_1 or {}
	arg_8_1.mode = arg_8_1.mode or "Lobby"
	arg_8_0.vars = {}
	
	local var_8_0 = arg_8_1.parent or SceneManager:getRunningPopupScene()
	
	arg_8_0.vars.select_callback = arg_8_1.select_callback
	arg_8_0.vars.close_callback = arg_8_1.close_callback
	arg_8_0.vars.update_callback = arg_8_1.update_callback
	arg_8_0.vars.mode = arg_8_1.mode
	
	if arg_8_1.mode == "Battle" then
		arg_8_0.vars.team_idx = arg_8_1.team_idx
	elseif arg_8_1.mode == "Descent" then
		arg_8_0.vars.team_idx = Account:getDescentPetTeamIdx()
	elseif arg_8_1.mode == "Burning" then
		arg_8_0.vars.team_idx = Account:getBurningPetTeamIdx()
	end
	
	arg_8_0.vars.dlg = load_dlg("pet_config_p", true, "wnd")
	
	var_8_0:addChild(arg_8_0.vars.dlg)
	BackButtonManager:push({
		check_id = "PetSettingPopup",
		back_func = function()
			PetSettingPopup:close()
		end,
		dlg = arg_8_0.vars.dlg
	})
	arg_8_0:initPetBelt()
	arg_8_0:eventSetting()
	
	local var_8_1
	
	if arg_8_1.pet then
		var_8_1 = arg_8_1.pet
	elseif arg_8_1.mode == "Battle" then
		var_8_1 = Account:getPetInTeam(arg_8_0.vars.team_idx)
		
		arg_8_0.vars.pet_belt_container:scrollToItem(var_8_1)
	elseif arg_8_1.mode == "Descent" then
		var_8_1 = Account:getPetInTeam(Account:getDescentPetTeamIdx())
		
		arg_8_0.vars.pet_belt_container:scrollToItem(var_8_1)
	elseif arg_8_1.mode == "Burning" then
		var_8_1 = Account:getPetInTeam(Account:getBurningPetTeamIdx())
		
		arg_8_0.vars.pet_belt_container:scrollToItem(var_8_1)
	else
		var_8_1 = Account:getLobbyPet()
		
		arg_8_0.vars.pet_belt_container:scrollToItem(var_8_1)
	end
	
	var_8_1 = var_8_1 or arg_8_0.vars.pet_belt_container:getItems()[1]
	arg_8_0.vars.pet = var_8_1
	arg_8_0.vars.pet_skill_list = PetSkillList:create({
		gap = 10,
		mode = "vertical",
		control = arg_8_0.vars.dlg:findChildByName("scrollview_skill")
	})
	
	arg_8_0:setPetInfos(var_8_1)
	arg_8_0:buttonSetting(arg_8_1.mode)
end

function PetSettingPopup.close(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "PetSettingPopup",
		dlg = arg_10_0.vars.dlg
	})
	
	if arg_10_0.vars.close_callback then
		arg_10_0.vars.close_callback(arg_10_1)
	end
	
	arg_10_0.vars.dlg:removeFromParent()
	arg_10_0.vars.pet_belt_container:destroy()
	UIUtil:deletePetBelt("PetSettingPopup")
	Scheduler:remove(arg_10_0.onUpdate)
	TutorialGuide:procGuide()
	
	arg_10_0.vars = nil
end

function PetSettingPopup.initPetBelt(arg_11_0)
	arg_11_0.vars.pet_belt_container = PetBelt:createContainer()
	
	arg_11_0.vars.pet_belt_container:create(arg_11_0.vars.mode, "popup", {
		no_event = true
	})
	arg_11_0.vars.pet_belt_container:setData(Account:getPets(), arg_11_0.vars.mode)
	UIUtil:addPetBelt("PetSettingPopup", arg_11_0.vars.pet_belt_container)
	
	local var_11_0 = arg_11_0.vars.pet_belt_container:getWnd()
	
	arg_11_0.vars.dlg:findChildByName("n_petlist"):addChild(var_11_0)
	var_11_0:setPosition(VIEW_BASE_LEFT, 0)
end

function PetSettingPopup.buttonSetting(arg_12_0, arg_12_1)
	if_set_visible(arg_12_0.vars.dlg, "label_lobby", arg_12_1 == "Lobby")
	if_set_visible(arg_12_0.vars.dlg, "label_battle", arg_12_1 ~= "Lobby")
	if_set_visible(arg_12_0.vars.dlg:getChildByName("btn_setting"), "icon_battle", arg_12_1 ~= "Lobby")
end

function PetSettingPopup.setPetButtons(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.inst.uid
	local var_13_1 = false
	
	if arg_13_0.vars.mode == "Battle" or arg_13_0.vars.mode == "Descent" or arg_13_0.vars.mode == "Burning" then
		local var_13_2 = Account:getPetInTeam(arg_13_0.vars.team_idx)
		
		if not var_13_2 then
			var_13_1 = false
		else
			var_13_1 = var_13_2.inst.uid == var_13_0
		end
	elseif Account:getLobbyPetUID() == var_13_0 then
		var_13_1 = true
		
		UIUtil:setPetGiftInfo(arg_13_0.vars.dlg, arg_13_1)
	end
	
	if_set_visible(arg_13_0.vars.dlg, "btn_ok", not var_13_1)
	if_set_visible(arg_13_0.vars.dlg, "btn_cancel", var_13_1)
	if_set_opacity(arg_13_0.vars.dlg, "btn_ok", arg_13_0:isBackPlayingTeam() and 76.5 or 255)
	if_set_opacity(arg_13_0.vars.dlg, "btn_cancel", arg_13_0:isBackPlayingTeam() and 76.5 or 255)
end

function PetSettingPopup.adjustNodePosition(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_1:findChildByName("txt")
	local var_14_1 = arg_14_1:findChildByName("n_pet_love_icon")
	
	if not arg_14_0.vars.origin_pos_txt_desc then
		arg_14_0.vars.origin_pos_txt_desc = var_14_0:getPosition()
	end
	
	if not arg_14_0.vars.origin_pos_icon then
		arg_14_0.vars.origin_pos_icon = var_14_1:getPosition()
	end
	
	if arg_14_2:isMaxLevel() then
		var_14_1:setPositionX(arg_14_0.vars.origin_pos_icon + 40)
		var_14_0:setPositionX(arg_14_0.vars.origin_pos_txt_desc + 40)
	else
		var_14_1:setPositionX(arg_14_0.vars.origin_pos_icon)
		var_14_0:setPositionX(arg_14_0.vars.origin_pos_txt_desc)
	end
end

function PetSettingPopup.setPetInfos(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.dlg:findChildByName("n_pet_name")
	
	UIUtil:updatePetNameInfo(var_15_0, arg_15_1)
	UIUtil:updatePetLevel(var_15_0:findChildByName("n_lv"), arg_15_1, {
		show_max_lv = true,
		use_offset = true
	})
	UIUtil:updatePetFavInfos(var_15_0, arg_15_1, {
		txt_desc = "txt"
	})
	arg_15_0:adjustNodePosition(var_15_0, arg_15_1)
	
	if arg_15_1:getUID() == Account:getLobbyPetUID() then
		UIUtil:setPetGiftInfo(arg_15_0.vars.dlg, arg_15_1)
	elseif arg_15_1:getType() == PET_TYPE.LOBBY then
		if_set_visible(arg_15_0.vars.dlg, "n_gift", true)
		
		local var_15_1 = arg_15_1:getGiftTime()
		
		if_set_visible(arg_15_0.vars.dlg, "txt_time", false)
		
		local var_15_2 = arg_15_0.vars.dlg:getChildByName("n_gift")
		
		if_set(var_15_2, "txt_info", T("ui_pet_config_popup_gift_time", {
			time = sec_to_full_string(var_15_1)
		}))
	else
		if_set_visible(arg_15_0.vars.dlg, "n_gift", false)
	end
	
	arg_15_0.vars.pet = arg_15_1
	
	arg_15_0.vars.pet_skill_list:setPet(arg_15_1)
	arg_15_0:setPetModel(arg_15_1)
	arg_15_0:updateLoveEffect(arg_15_1)
	arg_15_0:setPetButtons(arg_15_1)
end

function PetSettingPopup.updateLoveEffect(arg_16_0, arg_16_1)
	arg_16_0.vars.love_effect = UIUtil:setLoveEffect(arg_16_0.vars.love_effect, arg_16_0.vars.model, arg_16_1)
end

function PetSettingPopup.setPetModel(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.vars.dlg:findChildByName("n_pos")
	local var_17_1 = UIUtil:getPetModel(arg_17_1)
	
	var_17_1:setScale(arg_17_1:getModelScale())
	
	arg_17_0.vars.model = var_17_1
	
	var_17_0:removeAllChildren()
	var_17_0:addChild(var_17_1)
end

function PetSettingPopup.onPetBeltEventHandler(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_1 == "select" then
		arg_18_0:onPetBeltSelect(arg_18_2)
	elseif arg_18_1 == "add" then
		arg_18_0:onPetBeltAdd(arg_18_2)
	elseif arg_18_1 == "change" then
		arg_18_0:onPetBeltChange(arg_18_2, arg_18_3)
	end
end

function PetSettingPopup.onPetBeltSelect(arg_19_0, arg_19_1)
end

function PetSettingPopup.onPetBeltChange(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.vars.selected_time = uitick()
	arg_20_0.vars.selected_pet = arg_20_2
end

function PetSettingPopup.onPetBeltAdd(arg_21_0, arg_21_1)
end

function PetSettingPopup.onUpdate(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if arg_22_0.vars.pet and get_cocos_refid(arg_22_0.vars.dlg) and arg_22_0.vars.pet:getUID() == Account:getLobbyPetUID() then
		UIUtil:setPetGiftInfo(arg_22_0.vars.dlg, arg_22_0.vars.pet)
	end
	
	if arg_22_0.vars.selected_time and arg_22_0.vars.selected_time + 200 < uitick() then
		arg_22_0:setPetInfos(arg_22_0.vars.selected_pet)
		
		arg_22_0.vars.selected_time = nil
		arg_22_0.vars.selected_pet = nil
	end
end

function PetSettingPopup.eventSetting(arg_23_0)
	arg_23_0.vars.pet_belt_container:setEventHandler(arg_23_0.onPetBeltEventHandler, arg_23_0)
	Scheduler:add(arg_23_0.vars.dlg, arg_23_0.onUpdate, arg_23_0)
end

function PetSettingPopup.res_lobbyPet(arg_24_0, arg_24_1)
	local var_24_0 = Account:getLobbyPet()
	
	if arg_24_1.slot.lobby_slot1 then
		local var_24_1 = Account:getPet(arg_24_1.slot.lobby_slot1)
		
		if not var_24_1 or var_24_1:getType() ~= PET_TYPE.LOBBY then
			return 
		end
	end
	
	local var_24_2 = var_24_0 ~= nil
	
	Account:setPetSlots(arg_24_1.slot)
	
	if SceneManager:getCurrentSceneName() == "lobby" and not Lobby:isAlternativeLobby() then
		Lobby:setupLobbyPet()
	end
	
	local var_24_3 = Account:getLobbyPet()
	
	if arg_24_0.vars and arg_24_0.vars.update_callback then
		arg_24_0.vars.update_callback(var_24_0, var_24_3)
	end
	
	if var_24_2 then
		PetSettingPopup:close()
	elseif arg_24_0.vars and arg_24_0.vars.pet then
		arg_24_0:setPetButtons(arg_24_0.vars.pet)
		arg_24_0.vars.pet_belt_container:updateControlColor(nil, arg_24_0.vars.pet, nil, true)
	end
end

function PetSettingPopup.set_lobbyPet(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_1 or {}
	
	if not arg_25_0.vars or not arg_25_0.vars.pet then
		return 
	end
	
	if var_25_0.putOff then
		Dialog:msgBox(T("ui_pet_config_lobby_lift"), {
			yesno = true,
			handler = function()
				query("set_slot_pet")
			end
		})
		
		return 
	end
	
	if arg_25_0.vars.pet:getType() ~= PET_TYPE.LOBBY then
		Log.e("로비타입아님")
		
		return 
	end
	
	if Account:getLobbyPet() then
		Dialog:msgBox(T("ui_pet_config_popup_lobby_check"), {
			yesno = true,
			handler = function()
				SoundEngine:play("event:/ui/pet/" .. PetSettingPopup.vars.pet:getRace())
				query("set_slot_pet", {
					uid = PetSettingPopup.vars.pet:getUID()
				})
			end
		})
	else
		SoundEngine:play("event:/ui/pet/" .. arg_25_0.vars.pet:getRace())
		query("set_slot_pet", {
			uid = arg_25_0.vars.pet:getUID()
		})
	end
end
