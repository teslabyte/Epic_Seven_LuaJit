PetTransform = {}

function HANDLER.pet_transform(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_remove") then
		local var_1_0 = tonumber(string.sub(arg_1_1, -1))
		
		PetTransform:removeSlot(var_1_0)
	elseif arg_1_1 == "btn_reset" then
		PetTransform:clearSlot()
	elseif arg_1_1 == "btn_ok" then
		PetTransform:reqTransformPet()
	end
end

function HANDLER.pet_transform_result_p(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		PetTransform:closeResultPopupUI()
	end
end

function MsgHandler.change_pet_code(arg_3_0)
	PetTransform:transformPet(arg_3_0)
end

function PetTransform.onCreate(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_1 = arg_4_1 or {}
	arg_4_0.vars.dlg = load_dlg("pet_transform", true, "wnd")
	arg_4_0.vars.parent = PetUIBase:getBaseUI()
	
	arg_4_0.vars.parent:addChild(arg_4_0.vars.dlg)
	
	arg_4_0.vars.pet_belt = PetUIBase:getPetBelt()
	
	arg_4_0:cache()
	arg_4_0:skillViewSetting()
	arg_4_0:setButtonState()
	arg_4_0:resetResultUI()
	arg_4_0:initTransformCost()
	
	arg_4_0.vars.pet = arg_4_1.pet
	
	arg_4_0.vars.dlg:setVisible(false)
end

function PetTransform.onEnter(arg_5_0)
	arg_5_0:eventSetting()
	arg_5_0.vars.pet_belt:setData(Account:getPets(), "Transform", nil, {
		only_can_remove = true
	})
	PetUIBase:clilpPetBelt(false)
	
	if arg_5_0.vars.pet then
		arg_5_0:addPetInSlot(arg_5_0.vars.pet)
		
		arg_5_0.vars.pet = nil
	end
	
	TopBarNew:setTitleName(T("ui_title_pet_lookchange"), "infopet_8")
	arg_5_0:slideIn()
end

function PetTransform.onLeave(arg_6_0)
	arg_6_0:slideOut()
	arg_6_0.vars.dlg:removeFromParent()
	
	arg_6_0.vars = nil
end

function PetTransform.getWnd(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.dlg) then
		return nil
	end
	
	return arg_7_0.vars.dlg
end

function PetTransform.reqTransformPet(arg_8_0)
	if not arg_8_0.vars.dest_pet or not arg_8_0.vars.src_pet then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.src_pet
	
	if Account:getItemCount("ma_petpoint") < var_8_0:getTransformValue() then
		balloon_message_with_sound("pet_need_x")
		
		return 
	end
	
	local var_8_1 = arg_8_0.vars.dest_pet
	local var_8_2 = {
		pet_uid = var_8_1:getUID(),
		skin_pet_uid = var_8_0:getUID()
	}
	local var_8_3 = "pet_race_change_check"
	
	if var_8_1:isFeature() then
		var_8_3 = "pet_race_change_check2"
	end
	
	Dialog:msgBox(T(var_8_3), {
		yesno = true,
		handler = function()
			if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.dlg) then
				return 
			end
			
			query("change_pet_code", var_8_2)
		end
	})
end

function PetTransform.transformPet(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 or {}
	
	Account:addReward(var_10_0.result)
	Account:updatePetByInfo(var_10_0.pet, {
		is_update_pet_db = true
	})
	
	local var_10_1 = var_10_0.pet.id
	
	if var_10_1 and Account:isHousePet(var_10_1) then
		Account:setReserveUpdateHousePet(var_10_1)
	end
	
	arg_10_0:showResultPopup(var_10_0.pet)
	Account:removePet(var_10_0.delete_pet)
	
	if Account:isHousePet(var_10_0.delete_pet) then
		Account:removeHousePet(var_10_0.delete_pet)
	end
	
	if var_10_0.slot_attri then
		Account:setPetSlots(var_10_0.slot_attri)
	end
	
	arg_10_0:clearSlot()
	arg_10_0.vars.pet_belt:setData(Account:getPets(), "Transform")
end

function PetTransform.showResultPopup(arg_11_0, arg_11_1)
	if not arg_11_0.vars or table.empty(arg_11_1) then
		return 
	end
	
	arg_11_0.vars.result_dlg = load_dlg("pet_transform_result_p", true, "wnd")
	
	PetUIMain:addBackFunc("pet_transform_result_p", arg_11_0.vars.result_dlg, function()
		arg_11_0:closeResultPopupUI()
	end)
	
	local var_11_0 = arg_11_0.vars.result_dlg
	
	PetUIBase:getPopupLayer():addChild(var_11_0)
	arg_11_0:setResultPopupUI(Account:getPet(arg_11_1.id))
end

function PetTransform.setResultPopupUI(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.result_dlg) or table.empty(arg_13_1) then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.result_dlg:getChildByName("n_pet")
	local var_13_1 = arg_13_0.vars.result_dlg:getChildByName("n_pet_info")
	
	if get_cocos_refid(var_13_0) and get_cocos_refid(var_13_1) then
		local var_13_2 = var_13_0:findChildByName("n_pos")
		
		if get_cocos_refid(var_13_2) then
			local var_13_3 = UIUtil:getPetModel(arg_13_1)
			
			var_13_2:removeAllChildren()
			var_13_2:addChild(var_13_3)
		end
		
		UIUtil:updatePetStars(var_13_1:getChildByName("n_stars"), arg_13_1)
		UIUtil:updatePetName(var_13_1:getChildByName("txt_name"), arg_13_1)
	end
end

function PetTransform.closeResultPopupUI(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.result_dlg) then
		return 
	end
	
	PetUIMain:popBackFunc("pet_transform_result_p", arg_14_0.vars.result_dlg)
	arg_14_0.vars.result_dlg:removeFromParent()
	
	arg_14_0.vars.result_dlg = nil
end

function PetTransform.removeSlot(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.material_str_tbl
	local var_15_1 = arg_15_0.vars.slot_str_tbl
	local var_15_2 = arg_15_0.vars[var_15_0[arg_15_1]]
	local var_15_3 = arg_15_0.vars[var_15_1[arg_15_1]]
	
	if not var_15_2 or not var_15_3 then
		return 
	end
	
	var_15_3:findChildByName("n_pet_bar"):removeAllChildren()
	arg_15_0.vars.pet_belt:revertPoppedItem(var_15_2)
	
	arg_15_0.vars[var_15_0[arg_15_1]] = nil
	
	arg_15_0:updateTransformResultUI()
	arg_15_0:setButtonState()
	
	local var_15_4
	
	if arg_15_1 == 1 then
		var_15_4 = arg_15_0.vars[var_15_0[2]]
	else
		var_15_4 = arg_15_0.vars[var_15_0[1]]
	end
	
	arg_15_0:updatePetBeltSort(var_15_4)
	arg_15_0:updateTransformCost()
end

function PetTransform.setButtonState(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.dlg:findChildByName("n_buttons")
	
	if not arg_16_1 then
		if_set_color(var_16_0, "btn_ok", cc.c3b(76, 76, 76))
	else
		if_set_color(var_16_0, "btn_ok", cc.c3b(255, 255, 255))
	end
end

function PetTransform.clearSlot(arg_17_0, arg_17_1)
	arg_17_0:resetResultUI()
	
	for iter_17_0 = 1, 2 do
		arg_17_0:removeSlot(iter_17_0, arg_17_1)
	end
end

function PetTransform.resetResultUI(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.dlg) then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.n_skill
	local var_18_1 = arg_18_0.vars.n_appearance
	
	if not get_cocos_refid(var_18_0) or not get_cocos_refid(var_18_1) then
		return 
	end
	
	if_set_visible(var_18_0, "scrollview_skill", false)
	if_set_visible(var_18_0, "n_info", true)
	if_set_visible(var_18_1, "n_none", true)
	if_set_visible(var_18_1, "n_info", true)
	if_set_visible(var_18_1, "n_pos", false)
	if_set_visible(var_18_1, "n_stars", false)
	if_set_visible(var_18_1, "txt_name", false)
end

function PetTransform.cache(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.dlg) then
		return 
	end
	
	arg_19_0.vars.n_dest_slot = arg_19_0.vars.dlg:getChildByName("n_slot1")
	arg_19_0.vars.n_src_slot = arg_19_0.vars.dlg:getChildByName("n_slot2")
	arg_19_0.vars.n_skill = arg_19_0.vars.dlg:getChildByName("n_skill")
	arg_19_0.vars.n_appearance = arg_19_0.vars.dlg:getChildByName("n_appearance")
	arg_19_0.vars.material_str_tbl = {
		"dest_pet",
		"src_pet"
	}
	arg_19_0.vars.slot_str_tbl = {
		"n_dest_slot",
		"n_src_slot"
	}
end

function PetTransform.slideIn(arg_20_0)
	local var_20_0 = arg_20_0.vars.dlg:findChildByName("RIGHT")
	local var_20_1 = arg_20_0.vars.dlg:findChildByName("CENTER")
	
	var_20_0:setOpacity(0)
	var_20_1:setOpacity(0)
	UIAction:Add(SEQ(SLIDE_IN(200, -600)), var_20_0, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 600)), var_20_1, "block")
	if_set_visible(arg_20_0.vars.dlg, nil, true)
end

function PetTransform.slideOut(arg_21_0)
	local var_21_0 = arg_21_0.vars.dlg:findChildByName("RIGHT")
	local var_21_1 = arg_21_0.vars.dlg:findChildByName("CENTER")
	
	UIAction:Add(SEQ(SLIDE_OUT(200, 600)), var_21_0, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, -600)), var_21_1, "block")
	UIAction:Add(SEQ(DELAY(200), SHOW(false)), arg_21_0.vars.dlg, "block")
end

function PetTransform.skillViewSetting(arg_22_0)
	local var_22_0 = arg_22_0.vars.dlg:findChildByName("scrollview_skill")
	
	arg_22_0.vars.scrollView = var_22_0
	arg_22_0.vars.dest_pet_skill_list = PetSkillList:create({
		gap = 10,
		mode = "vertical",
		control = var_22_0
	})
end

function PetTransform.addPetInSlot(arg_23_0, arg_23_1)
	if arg_23_0.vars.dest_pet and arg_23_0.vars.src_pet then
		balloon_message_with_sound("ui_pet_synthesis_no_full")
		
		return 
	end
	
	local var_23_0
	local var_23_1
	local var_23_2
	
	if not arg_23_0.vars.dest_pet then
		var_23_0 = 1
		var_23_2 = 2
	else
		var_23_0 = 2
		var_23_2 = 1
	end
	
	local var_23_3 = arg_23_0.vars.material_str_tbl
	local var_23_4 = arg_23_0.vars[var_23_3[var_23_2]]
	
	if var_23_4 then
		if var_23_4:getUID() == arg_23_1:getUID() then
			return 
		elseif var_23_4:getType() ~= arg_23_1:getType() then
			balloon_message_with_sound("ui_pet_synthesis_no_type")
			
			return 
		elseif var_23_4:getCode() == arg_23_1:getCode() then
			balloon_message_with_sound("pet_race_change_no")
			
			return 
		elseif arg_23_0.vars.dest_pet and not arg_23_1:isCanRemove() then
			local var_23_5 = arg_23_1:getUsableCodeList()
			
			if var_23_5 then
				Dialog:msgPetLock(var_23_5)
				
				return 
			end
			
			return 
		end
	end
	
	arg_23_0.vars[var_23_3[var_23_0]] = arg_23_1
	
	arg_23_0:setPetInfos(arg_23_1, var_23_0)
	arg_23_0:updateTransformResultUI()
	
	if arg_23_0.vars.dest_pet and arg_23_0.vars.src_pet then
		arg_23_0:setButtonState(true)
	end
	
	arg_23_0.vars.pet_belt:scrollToFirstItem()
	arg_23_0:updatePetBeltSort(arg_23_1)
	arg_23_0:updateTransformCost()
end

function PetTransform.updatePetBeltSort(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_2 or {}
	
	if arg_24_0.vars.dest_pet then
		var_24_0.only_can_remove = true
	end
	
	arg_24_0.vars.pet_belt:updateSort("Transform", arg_24_1, var_24_0)
end

function PetTransform.setPetInfos(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_1 or not arg_25_2 then
		return 
	end
	
	arg_25_0:setPetSlot(arg_25_1, arg_25_2)
end

function PetTransform.initTransformCost(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.dlg) then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.dlg:getChildByName("btn_ok")
	
	if_set(var_26_0, "cost", 0)
	
	local var_26_1 = "ma_petpoint"
	local var_26_2 = DB("item_material", var_26_1, {
		"icon"
	})
	local var_26_3 = "item/" .. (var_26_2 or "") .. ".png"
	
	SpriteCache:resetSprite(var_26_0:getChildByName("icon_res"), var_26_3)
end

function PetTransform.updateTransformCost(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.dlg) then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.src_pet
	
	if var_27_0 then
		if_set(arg_27_0.vars.dlg, "cost", comma_value(var_27_0:getTransformValue()))
	else
		if_set(arg_27_0.vars.dlg, "cost", comma_value(0))
	end
end

function PetTransform.setPetSlot(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.dlg) or not arg_28_1 or not arg_28_2 then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.slot_str_tbl
	local var_28_1 = arg_28_0.vars[var_28_0[arg_28_2]]
	local var_28_2 = UIUtil:updatePetBar(nil, nil, arg_28_1)
	
	UIUtil:updatePetBarInfo(var_28_2, nil, arg_28_1)
	var_28_2:setAnchorPoint(0.5, 0.5)
	
	if get_cocos_refid(var_28_1) then
		local var_28_3 = var_28_1:findChildByName("n_pet_bar")
		
		var_28_3:removeAllChildren()
		var_28_3:addChild(var_28_2)
		arg_28_0.vars.pet_belt:popItem(arg_28_1)
	end
end

function PetTransform.updateTransformResultUI(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.dlg) then
		return 
	end
	
	arg_29_0:setDestPetInfos()
	arg_29_0:setSrcPetInfos()
	
	local var_29_0 = arg_29_0.vars.dest_pet and arg_29_0.vars.src_pet
	
	if get_cocos_refid(arg_29_0.vars.n_appearance) then
		if_set_visible(arg_29_0.vars.n_appearance, "n_stars", var_29_0)
		if_set_visible(arg_29_0.vars.n_appearance, "txt_name", var_29_0)
	end
end

function PetTransform.setDestPetInfos(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.dlg) then
		return 
	end
	
	if not arg_30_0.vars.dest_pet_skill_list or not get_cocos_refid(arg_30_0.vars.n_skill) or not get_cocos_refid(arg_30_0.vars.n_appearance) then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.dest_pet_skill_list
	local var_30_1 = arg_30_0.vars.n_skill
	local var_30_2 = arg_30_0.vars.n_appearance
	local var_30_3 = arg_30_0.vars.dest_pet
	
	if var_30_3 then
		local var_30_4 = var_30_0:getPetSkillList(var_30_3)
		
		if not table.empty(var_30_4) then
			var_30_0:setPet(var_30_3)
		end
		
		UIUtil:updatePetStars(var_30_2:getChildByName("n_stars"), var_30_3)
	end
	
	if_set_visible(var_30_1, "scrollview_skill", var_30_3)
	if_set_visible(var_30_1, "n_info", not var_30_3)
end

function PetTransform.setSrcPetInfos(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.dlg) then
		return 
	end
	
	if not get_cocos_refid(arg_31_0.vars.n_appearance) then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.n_appearance
	local var_31_1 = arg_31_0.vars.dest_pet
	local var_31_2 = arg_31_0.vars.src_pet
	
	if var_31_2 then
		local var_31_3 = var_31_0:findChildByName("n_pos")
		local var_31_4
		local var_31_5
		local var_31_6 = false
		
		if var_31_1 then
			var_31_4 = var_31_1:getGrade()
			
			if not var_31_1:isNameChangeFree() then
				var_31_5 = var_31_1
			else
				var_31_5 = var_31_2
				var_31_6 = true
			end
			
			UIUtil:updatePetName(var_31_0:getChildByName("txt_name"), var_31_5, false, var_31_6)
		end
		
		local var_31_7 = UIUtil:getPetModel(var_31_2, var_31_4)
		
		var_31_3:removeAllChildren()
		var_31_3:addChild(var_31_7)
	end
	
	if_set_visible(var_31_0, "n_pos", var_31_2)
	if_set_visible(var_31_0, "n_none", not var_31_2)
	if_set_visible(var_31_0, "n_info", not var_31_2)
end

function PetTransform.petBeltEventHandler(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_1 == "select" then
		arg_32_0:addPetInSlot(arg_32_2)
	end
end

function PetTransform.eventSetting(arg_33_0)
	arg_33_0.vars.pet_belt:setEventHandler(arg_33_0.petBeltEventHandler, arg_33_0)
end
