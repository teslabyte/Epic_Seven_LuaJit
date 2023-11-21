PetSynthesis = {}

function HANDLER.unit_pet_synthesis(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_remove") then
		local var_1_0 = tonumber(string.sub(arg_1_1, -1))
		
		PetSynthesis:removeSlot(var_1_0)
	elseif arg_1_1 == "btn_reset" then
		PetSynthesis:clearSlot()
	elseif arg_1_1 == "btn_ok" then
		PetSynthesis:checkSynthesis()
	elseif arg_1_1 == "btn_skill_pick" then
		PetSynthesis:openSettingPopup()
	elseif string.find(arg_1_1, "btn_checkbox") then
		local var_1_1 = tonumber(string.sub(arg_1_1, -1))
		
		PetSynthesis:toggleAppearCheckBox(var_1_1)
	elseif string.find(arg_1_1, "checkbox") then
		local var_1_2 = tonumber(string.sub(arg_1_1, -1))
		local var_1_3 = PetSynthesis:getCheckBox(var_1_2)
		
		if not var_1_3 then
			return 
		end
		
		PetSynthesis:setAppearPet(var_1_2, var_1_3:isSelected())
	end
end

function PetSynthesis.onCreate(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars.dlg = load_dlg("unit_pet_synthesis", true, "wnd")
	arg_2_0.vars.parent = PetUIBase:getBaseUI()
	
	arg_2_0.vars.parent:addChild(arg_2_0.vars.dlg)
	
	arg_2_0.vars.pet_belt = PetUIBase:getPetBelt()
	arg_2_0.vars.n_slot1 = arg_2_0.vars.dlg:findChildByName("n_slot1")
	arg_2_0.vars.n_slot2 = arg_2_0.vars.dlg:findChildByName("n_slot2")
	
	arg_2_0:skillViewSetting()
	if_set_visible(arg_2_0.vars.dlg, "n_none", false)
	arg_2_0:toggleAppearCheckBox(1, false)
	arg_2_0:toggleAppearCheckBox(2, false)
	if_set(arg_2_0.vars.dlg, "cost", comma_value(0))
	if_set_sprite(arg_2_0.vars.dlg, "icon_res", "item/" .. GAME_STATIC_VARIABLE.pet_synthesis_token .. ".png")
	
	arg_2_0.vars.pet = arg_2_1.pet
	arg_2_0.vars.selected_addition_pet_list = {}
	
	if_set_visible(arg_2_0.vars.dlg, "n_top", arg_2_0.vars.syn_pet1)
	if_set_visible(arg_2_0.vars.dlg, "n_info", arg_2_0.vars.syn_pet1)
	if_set_visible(arg_2_0.vars.dlg, "n_skill_select_info", arg_2_0.vars.syn_pet1)
	if_set_visible(arg_2_0.vars.dlg, "n_none", not arg_2_0.vars.syn_pet1)
	if_set_visible(arg_2_0.vars.dlg, "n_none_info", not arg_2_0.vars.syn_pet1)
	arg_2_0:setScrollViewOpacity(false)
	arg_2_0.vars.dlg:setVisible(false)
	
	local var_2_0 = arg_2_0.vars.dlg:getChildByName("n_material"):getChildByName("n_pet")
	local var_2_1 = "ma_petpoint"
	local var_2_2 = Account:getItemCount(var_2_1)
	
	UIUtil:getRewardIcon(nil, var_2_1, {
		use_drop_icon = true,
		parent = var_2_0
	})
	
	local var_2_3 = arg_2_0.vars.dlg:findChildByName("n_slider"):findChildByName("bg_slider"):findChildByName("progress")
	
	arg_2_0.vars.synthesis_progress = var_2_3
end

function PetSynthesis.onEnter(arg_3_0)
	TutorialGuide:ifStartGuide("pet_synthesis_new")
	if_set_visible(arg_3_0.vars.dlg, "n_add", false)
	TopBarNew:setTitleName(T("ui_pet_house_synthesis"), "infopet_3")
	arg_3_0:eventSetting()
	arg_3_0.vars.pet_belt:setData(Account:getPets(), "Synthesis", nil, {
		only_max_lv = true
	})
	PetUIBase:clilpPetBelt(false)
	
	if arg_3_0.vars.pet then
		arg_3_0:addPetInSlot(arg_3_0.vars.pet, true)
		
		arg_3_0.vars.pet = nil
	end
	
	arg_3_0:setButtonState(false)
	arg_3_0.vars.dlg:setVisible(true)
	arg_3_0:slideIn()
end

function PetSynthesis.onLeave(arg_4_0)
	arg_4_0.vars.dlg:removeFromParent()
	
	arg_4_0.vars = nil
end

function PetSynthesis.getWnd(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.dlg) then
		return nil
	end
	
	return arg_5_0.vars.dlg
end

function PetSynthesis.getCheckBox(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	return arg_6_0.vars.dlg:findChildByName("checkbox" .. arg_6_1)
end

function PetSynthesis.setScrollViewOpacity(arg_7_0, arg_7_1)
	if arg_7_1 then
		if_set_opacity(arg_7_0.vars.dlg, "btn_skill", 255)
		if_set_opacity(arg_7_0.vars.dlg, "skill_bg", 255)
	else
		if_set_opacity(arg_7_0.vars.dlg, "btn_skill", 76.5)
		if_set_opacity(arg_7_0.vars.dlg, "skill_bg", 76.5)
	end
end

function PetSynthesis.setButtonState(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.dlg:findChildByName("n_buttons")
	
	if not arg_8_1 then
		if_set_color(var_8_0, "btn_ok", cc.c3b(76, 76, 76))
	else
		if_set_color(var_8_0, "btn_ok", cc.c3b(255, 255, 255))
	end
end

function PetSynthesis.setTextOnEmptySlot(arg_9_0)
	if_set_visible(arg_9_0.vars.dlg, "n_none", true)
	if_set_visible(arg_9_0.vars.dlg, "n_skill_select_info", false)
	if_set_visible(arg_9_0.vars.dlg, "n_top", false)
	if_set_visible(arg_9_0.vars.dlg, "n_info", false)
	if_set_visible(arg_9_0.vars.dlg, "n_none_info", true)
end

function PetSynthesis.doRemoveSlot(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.vars["syn_pet" .. arg_10_1]
	local var_10_1 = arg_10_0.vars["n_slot" .. arg_10_1]
	
	if not var_10_0 then
		return 
	end
	
	if not var_10_1 then
		return 
	end
	
	local var_10_2 = var_10_1:findChildByName("n_pos")
	local var_10_3 = var_10_1:findChildByName("n_pet_bar")
	
	var_10_2:removeAllChildren()
	var_10_3:removeAllChildren()
	arg_10_0.vars.pet_skill_list:setPetSkills({})
	
	arg_10_0.vars.selected_addition_pet_list = {}
	
	if_set_visible(arg_10_0.vars.dlg, "n_skill_select_info", false)
	if_set_visible(arg_10_0.vars.dlg, "n_add", false)
	if_set_visible(arg_10_0.vars.dlg, "n_none", true)
	
	arg_10_0.vars["syn_pet" .. arg_10_1] = nil
	
	if not arg_10_0.vars.syn_pet1 and not arg_10_0.vars.syn_pet2 then
		arg_10_0:setTextOnEmptySlot()
		arg_10_0.vars.pet_belt:updateSort("Synthesis", nil, {
			only_max_lv = true
		})
		if_set(arg_10_0.vars.dlg, "cost", 0)
		
		if not arg_10_2 then
			arg_10_0.vars.pet_belt:revertPoppedItem(var_10_0)
		end
	elseif not arg_10_2 then
		arg_10_0.vars.pet_belt:revertPoppedItem(var_10_0)
		
		local var_10_4 = {
			2,
			1
		}
		
		arg_10_0:updatePetBeltSort(arg_10_0.vars["syn_pet" .. var_10_4[arg_10_1]])
	end
	
	arg_10_0:setButtonState(false)
	arg_10_0:setScrollViewOpacity(false)
	arg_10_0:toggleAppearCheckBox(1, false)
	arg_10_0:toggleAppearCheckBox(2, false)
end

function PetSynthesis.removeSlot(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0.vars["syn_pet" .. arg_11_1] then
		return 
	end
	
	if not arg_11_0.vars["n_slot" .. arg_11_1] then
		Log.e("SLOT WAS NIL! IS REF ALL RIGHT?")
		
		return 
	end
	
	arg_11_0:doRemoveSlot(arg_11_1, arg_11_2)
end

function PetSynthesis.clearSlot(arg_12_0, arg_12_1)
	arg_12_0:setTextOnEmptySlot()
	
	for iter_12_0 = 1, 2 do
		arg_12_0:removeSlot(iter_12_0, arg_12_1)
	end
	
	if_set(arg_12_0.vars.dlg, "cost", 0)
	
	arg_12_0.vars.selected_skill_list = {}
	
	arg_12_0.vars.pet_skill_list:setPetSkills({})
end

function PetSynthesis.onClearSlot(arg_13_0)
	arg_13_0:clearSlot()
	arg_13_0.vars.pet_belt:updateSort("Synthesis", nil, {
		only_max_lv = true
	})
end

function PetSynthesis.checkSynthesis(arg_14_0)
	local var_14_0 = arg_14_0.vars.syn_pet1
	local var_14_1 = arg_14_0.vars.syn_pet2
	
	if not var_14_0 or not var_14_1 then
		balloon_message_with_sound("ui_pet_synthesis_cant")
		
		return 
	end
	
	if not var_14_0:isMaxLevel() and not var_14_1:isMaxLevel() then
		balloon_message_with_sound("ui_pet_upgrade_need_level")
		
		return 
	end
	
	if var_14_0:getGrade() ~= var_14_1:getGrade() then
		Log.e("on PetSynthesis, Grade was Diff.")
		
		return 
	end
	
	local var_14_2 = Account:isCurrencyType(GAME_STATIC_VARIABLE.pet_synthesis_token)
	
	if Account:getCurrency(var_14_2) < var_14_0:getSynthesisValue() then
		UIUtil:checkCurrencyDialog(GAME_STATIC_VARIABLE.pet_synthesis_token)
		
		return 
	end
	
	arg_14_0:setProgressBarEnabled(false)
	
	local var_14_3
	
	if arg_14_0.vars.appear_index then
		var_14_3 = arg_14_0.vars["syn_pet" .. arg_14_0.vars.appear_index]
	end
	
	local var_14_4 = false
	
	if var_14_0:isFeature() or var_14_1:isFeature() then
		var_14_4 = true
	end
	
	local var_14_5 = arg_14_0:getUsePetPoint()
	
	if var_14_4 and (not var_14_3 or var_14_3 and not var_14_3:isFeature()) then
		Dialog:msgBox(T("ui_pet_limit_check_look"), {
			yesno = true,
			handler = function()
				if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.dlg) then
					return 
				end
				
				PetSynthesisCheckPopup:init(PetUIBase:getPopupLayer(), var_14_3, arg_14_0.vars.selected_list, var_14_0, var_14_1, PetUtil:getCurrentSynthesisPercent(var_14_5, var_14_0))
			end
		})
	else
		PetSynthesisCheckPopup:init(PetUIBase:getPopupLayer(), var_14_3, arg_14_0.vars.selected_list, var_14_0, var_14_1, PetUtil:getCurrentSynthesisPercent(var_14_5, var_14_0))
	end
end

function PetSynthesis.toggleAppearCheckBox(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0.vars.dlg:findChildByName("checkbox" .. arg_16_1)
	local var_16_1 = arg_16_2
	
	if var_16_1 == nil then
		var_16_1 = not var_16_0:isSelected()
	end
	
	var_16_0:setSelected(var_16_1)
	arg_16_0:setAppearPet(arg_16_1, var_16_1)
end

function PetSynthesis.setAppearPet(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2 then
		arg_17_0.vars.appear_index = arg_17_1
	else
		arg_17_0.vars.appear_index = nil
	end
	
	local var_17_0 = ({
		2,
		1
	})[arg_17_1]
	local var_17_1 = arg_17_0.vars.dlg:findChildByName("checkbox" .. var_17_0)
	
	if var_17_1:isSelected() and arg_17_2 then
		var_17_1:setSelected(false)
	end
end

function MsgHandler.synthesis_pet(arg_18_0)
	local var_18_0 = Account:addPet(arg_18_0.pet)
	local var_18_1 = PetSynthesis:getDiffData()
	
	PetSynthesisResultPopup:init(PetUIBase:getPopupLayer(), var_18_0, var_18_1)
	
	local var_18_2 = Account:getPet(arg_18_0.delete_pet1)
	
	if arg_18_0.teams and var_18_0.isPet and var_18_0.getRepeat_count and var_18_0:getType() == "battle" and var_18_2 and var_18_2:getGrade() ~= var_18_0:getGrade() then
		BattleRepeat:updateRepeatCount(arg_18_0.delete_pet1, arg_18_0.delete_pet2, var_18_0:getRepeat_count())
	end
	
	Account:removePet(arg_18_0.delete_pet1)
	Account:removePet(arg_18_0.delete_pet2)
	Account:setPetSlots(arg_18_0.slot)
	Account:addReward(arg_18_0.result)
	ConditionContentsManager:dispatch("pet.synthesis", {
		grade = var_18_0:getGrade()
	})
	PetSynthesis:onSynthesisPet()
	
	if arg_18_0.teams then
		Account:setTeams(arg_18_0.teams)
	end
end

function PetSynthesis.onSynthesisPet(arg_19_0)
	if_set_visible(arg_19_0.vars.scrollView, nil, true)
	arg_19_0:clearDiffSkillList()
	arg_19_0:clearSlot(true)
	arg_19_0.vars.pet_belt:setData(Account:getPets(), "Synthesis", nil, {
		only_max_lv = true
	})
end

function PetSynthesis.clearDiffSkillList(arg_20_0)
	arg_20_0.vars.diff_skill_list = nil
end

function PetSynthesis.getDiffData(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	return {
		pet = arg_21_0.vars.syn_pet1,
		skill_list = arg_21_0.vars.diff_skill_list
	}
end

function PetSynthesis.confirmChoice(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars.syn_pet1 or not arg_22_0.vars.syn_pet2 then
		return 
	end
	
	if_set_visible(arg_22_0.vars.scrollView, nil, false)
	
	arg_22_2 = arg_22_2 or {}
	
	for iter_22_0 = 1, 2 do
		local var_22_0 = arg_22_0.vars["model" .. iter_22_0]
		local var_22_1 = arg_22_0.vars["n_slot" .. iter_22_0]:findChildByName("n_pos")
		local var_22_2, var_22_3 = var_22_0:getBoneNode("target"):getPosition()
		local var_22_4 = 1 / var_22_1:getScale()
		
		EffectManager:Play({
			fn = "ui_pet_swap_eff.cfx",
			layer = var_22_1,
			pivot_x = var_22_2,
			pivot_y = var_22_3,
			scale = var_22_4
		})
		UIAction:Add(SPAWN(BLEND(500, "white", 0, 1), OPACITY(500, 1, 0)), var_22_0, "block")
	end
	
	UIAction:Add(SEQ(DELAY(1000), CALL(PetSynthesis.confirmChoice_1, arg_22_0, arg_22_1, arg_22_2)), arg_22_0.vars.dlg, "block")
end

function PetSynthesis.confirmChoice_1(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars.syn_pet1 or not arg_23_0.vars.syn_pet2 then
		return 
	end
	
	arg_23_2 = arg_23_2 or {}
	
	local var_23_0 = {
		pet1 = {},
		pet2 = {}
	}
	local var_23_1 = arg_23_0.vars.syn_pet1:getUID()
	local var_23_2 = arg_23_0.vars.syn_pet2:getUID()
	
	arg_23_0.vars.diff_skill_list = {}
	
	for iter_23_0, iter_23_1 in pairs(arg_23_2) do
		if var_23_1 == iter_23_1.pet_uid then
			table.insert(var_23_0.pet1, iter_23_1.skill_idx)
			
			local var_23_3 = arg_23_0.vars.syn_pet1:getSkillID(iter_23_1.skill_idx)
			
			table.insert(arg_23_0.vars.diff_skill_list, var_23_3)
		elseif var_23_2 == iter_23_1.pet_uid then
			table.insert(var_23_0.pet2, iter_23_1.skill_idx)
			
			local var_23_4 = arg_23_0.vars.syn_pet2:getSkillID(iter_23_1.skill_idx)
			
			table.insert(arg_23_0.vars.diff_skill_list, var_23_4)
		else
			Log.e("PET`S NOT HAVE PET SKILL UID.")
		end
	end
	
	local var_23_5
	
	if arg_23_1 then
		var_23_5 = arg_23_1:getUID()
	end
	
	local var_23_6 = arg_23_0:getUsePetPoint()
	local var_23_7 = arg_23_0.vars.synthesis_progress
	
	if not get_cocos_refid(var_23_7) then
		Log.e("PET SYNTHESIS PROGRESS ERROR. REFID IS NIL.")
		
		return 
	end
	
	local var_23_8 = arg_23_0.vars.synthesis_progress:getPercent()
	
	if var_23_8 ~= var_23_6 then
		Log.e("PET SYNTHESIS PROGRESS ERROR. PROGRESS_PERCENT : " .. var_23_8 .. " USE_PETPOINT : " .. var_23_6)
		
		return 
	end
	
	query("synthesis_pet", {
		target_pet1 = var_23_1,
		target_pet2 = var_23_2,
		keep_skills = json.encode(var_23_0),
		keep_appear_petid = var_23_5,
		use_point = var_23_6
	})
end

function PetSynthesis.setVisibleButtons(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.dlg:findChildByName("n_buttons")
	local var_24_1 = var_24_0:findChildByName("btn_skill_pick")
	local var_24_2 = var_24_0:findChildByName("btn_ok")
	local var_24_3 = var_24_0:findChildByName("btn_reset")
	
	if not var_24_2 or not var_24_1 or not var_24_3 then
		return 
	end
	
	if not var_24_2.origin_pos_x then
		var_24_2.origin_pos_x = var_24_2:getPositionX()
		var_24_3.origin_pos_x = var_24_3:getPositionX()
	end
	
	if_set_visible(var_24_1, nil, arg_24_1)
	
	if arg_24_1 then
		var_24_2:setPositionX(var_24_2.origin_pos_x + 128)
		var_24_3:setPositionX(var_24_3.origin_pos_x - 123)
	else
		var_24_2:setPositionX(var_24_2.origin_pos_x)
		var_24_3:setPositionX(var_24_3.origin_pos_x)
	end
end

function PetSynthesis.openSettingPopup(arg_25_0)
	if not arg_25_0.vars.syn_pet1 or not arg_25_0.vars.syn_pet2 then
		balloon_message_with_sound("pet_synthesis_need_select_pet")
		
		return 
	end
	
	PetSynthesisSettingPopup:init(PetUIBase:getPopupLayer(), arg_25_0.vars.syn_pet1, arg_25_0.vars.syn_pet2, {
		selected_list = arg_25_0.vars.selected_list,
		change_callback = function(arg_26_0)
			arg_25_0.vars.pet_skill_list:setPetSkills(arg_26_0)
			
			if #arg_26_0 == 0 then
				if_set_visible(arg_25_0.vars.dlg, "n_skill_select_info", true)
				arg_25_0:setVisibleButtons(false)
			else
				if_set_visible(arg_25_0.vars.dlg, "n_skill_select_info", false)
				arg_25_0:setVisibleButtons(true)
			end
			
			arg_25_0.vars.selected_list = arg_26_0
		end
	})
end

function PetSynthesis.openAdditionPopup(arg_27_0)
	if not arg_27_0.vars.syn_pet1 or not arg_27_0.vars.syn_pet2 then
		balloon_message_with_sound("pet_synthesis_need_select_pet")
		
		return 
	end
	
	if arg_27_0.vars.syn_pet1:isMaxGrade() then
		return 
	end
	
	arg_27_0.vars.target_pets = arg_27_0.vars.target_pets or {}
end

function PetSynthesis.slideIn(arg_28_0)
	local var_28_0 = arg_28_0.vars.dlg:findChildByName("LEFT")
	local var_28_1 = arg_28_0.vars.dlg:findChildByName("CENTER")
	local var_28_2 = arg_28_0.vars.dlg:findChildByName("RIGHT")
	
	var_28_0:setOpacity(0)
	var_28_2:setOpacity(0)
	var_28_1:setOpacity(0)
	UIAction:Add(SEQ(LOG(FADE_IN(200))), var_28_0, "block")
	UIAction:Add(SEQ(LOG(FADE_IN(200))), var_28_2, "block")
	UIAction:Add(SEQ(LOG(FADE_IN(200))), var_28_1, "block")
	
	local var_28_3 = var_28_1:findChildByName("n_star")
	local var_28_4 = var_28_1:findChildByName("n_level")
	local var_28_5 = var_28_1:findChildByName("n_favorability")
	local var_28_6 = var_28_0:findChildByName("skills")
	
	if not var_28_3 or not var_28_4 or not var_28_5 or not var_28_6 then
		Log.e(" ERRROR! IN SLIDEING!")
		
		return 
	end
	
	UIAction:Add(SEQ(SHOW(true), SLIDE_IN(200, 600)), var_28_3, "block")
	UIAction:Add(SEQ(SHOW(false), DELAY(80), SHOW(true), SLIDE_IN(200, 600)), var_28_4, "block")
	UIAction:Add(SEQ(SHOW(false), DELAY(160), SHOW(true), SLIDE_IN(200, 600)), var_28_5, "block")
	UIAction:Add(SEQ(SHOW(true), SLIDE_IN_Y(200, 1200)), var_28_6, "block")
	UIAction:Add(SEQ(SHOW(true), SLIDE_IN_Y(200, 1200)), var_28_2, "block")
	UIAction:Add(SEQ(SHOW(true), SLIDE_IN_Y(200, 1200)), var_28_1, "block")
end

function PetSynthesis.slideOut(arg_29_0)
end

function PetSynthesis.updatePetBeltSort(arg_30_0, arg_30_1)
	local var_30_0 = {}
	
	if not arg_30_1:isMaxLevel() then
		var_30_0.only_max_lv = true
	end
	
	arg_30_0.vars.pet_belt:updateSort("Synthesis", arg_30_1, var_30_0)
end

function PetSynthesis.addPetInSlot(arg_31_0, arg_31_1, arg_31_2)
	if arg_31_0.vars.syn_pet1 and arg_31_0.vars.syn_pet2 then
		balloon_message_with_sound("ui_pet_synthesis_no_full")
		
		return 
	end
	
	if not arg_31_2 and not arg_31_0.vars.syn_pet1 and not arg_31_0.vars.syn_pet2 and not arg_31_1:isMaxLevel() then
		balloon_message_with_sound("ui_pet_synthesis_no_maxlv")
		
		return 
	end
	
	local var_31_0
	local var_31_1 = not arg_31_0.vars.syn_pet1 and 1 or 2
	local var_31_2 = {
		2,
		1
	}
	local var_31_3 = arg_31_0.vars["syn_pet" .. var_31_2[var_31_1]]
	
	if var_31_3 and var_31_3:getGrade() ~= arg_31_1:getGrade() then
		balloon_message_with_sound("ui_pet_synthesis_no_grade")
		
		return 
	elseif var_31_3 and var_31_3:getType() ~= arg_31_1:getType() then
		balloon_message_with_sound("ui_pet_synthesis_no_type")
		
		return 
	elseif var_31_3 and var_31_3:getUID() == arg_31_1:getUID() then
		Log.e("another_pet:getUID() : " .. var_31_3:getUID() .. "was same.")
		
		return 
	elseif not arg_31_1:isCanSynthesis() then
		local var_31_4 = arg_31_1:getUsableSynthesisList()
		
		Dialog:msgPetLock(var_31_4)
		
		return 
	end
	
	if var_31_3 and not var_31_3:isMaxLevel() and not arg_31_1:isMaxLevel() then
		balloon_message_with_sound("ui_pet_synthesis_no_maxlv")
		
		return 
	end
	
	arg_31_0.vars["syn_pet" .. var_31_1] = arg_31_1
	arg_31_0.vars.selected_list = nil
	
	arg_31_0.vars.pet_skill_list:setPetSkills({})
	arg_31_0:setPetInfos(arg_31_1, var_31_1)
	
	if arg_31_0.vars.syn_pet1 and arg_31_0.vars.syn_pet2 then
		arg_31_0:setButtonState(true)
	end
	
	arg_31_0.vars.pet_belt:scrollToFirstItem()
	arg_31_0:updatePetBeltSort(arg_31_1)
end

function PetSynthesis.skillViewSetting(arg_32_0)
	local var_32_0 = arg_32_0.vars.dlg:findChildByName("scrollview_skill")
	
	arg_32_0.vars.scrollView = var_32_0
	arg_32_0.vars.pet_skill_list = PetSkillList:create({
		mode = "mid",
		control = var_32_0
	})
end

function PetSynthesis.updatePetTopArea(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1:getGrade() < GAME_STATIC_VARIABLE.max_pet_grade and 1 or 0
	local var_33_1 = arg_33_0.vars.dlg:findChildByName("n_star_before_after")
	local var_33_2 = var_33_1:findChildByName("n_before_star")
	local var_33_3 = var_33_1:findChildByName("n_max")
	
	UIUtil:updatePetStars(var_33_2, arg_33_1)
	if_set_visible(var_33_3, nil, true)
	UIUtil:updatePetStars(var_33_3:findChildByName("n_star"), arg_33_1, var_33_0)
	
	local var_33_4 = arg_33_0.vars.dlg:findChildByName("n_level")
	local var_33_5 = var_33_4:findChildByName("txt_level")
	local var_33_6 = var_33_4:findChildByName("n_max")
	local var_33_7 = var_33_6:findChildByName("txt_level")
	local var_33_8 = arg_33_1:getMaxLevel()
	local var_33_9 = arg_33_1:getMaxLevel(arg_33_1:getGrade() + var_33_0)
	
	if_set(var_33_5, nil, tostring(var_33_8))
	if_set_visible(var_33_6, nil, true)
	if_set(var_33_7, nil, tostring(var_33_9))
	
	local var_33_10 = arg_33_0.vars.dlg:findChildByName("n_favorability")
	local var_33_11 = var_33_10:findChildByName("txt_favorability")
	local var_33_12 = var_33_10:findChildByName("n_max")
	local var_33_13 = var_33_12:findChildByName("txt_favorability")
	local var_33_14 = arg_33_1:getMaxFav()
	local var_33_15 = arg_33_1:getMaxFav(arg_33_1:getGrade() + var_33_0)
	
	if_set(var_33_11, nil, tostring(var_33_14))
	if_set_visible(var_33_12, nil, true)
	if_set(var_33_13, nil, tostring(var_33_15))
end

function PetSynthesis.setupOnReadyComposeUI(arg_34_0, arg_34_1)
	if_set_visible(arg_34_0.vars.dlg, "n_none", false)
	
	local var_34_0 = arg_34_0.vars.dlg:findChildByName("n_skill_select_info")
	local var_34_1 = arg_34_1:getMaxFixSkillNum()
	local var_34_2 = arg_34_1:getGrade()
	
	if_set_visible(var_34_0, nil, true)
	if_set(var_34_0, "txt_desc", T("ui_pet_genetic_skill_count", {
		count = var_34_1,
		grade = var_34_2
	}))
	
	local var_34_3 = arg_34_0.vars.dlg:findChildByName("n_add")
	local var_34_4 = arg_34_0.vars.syn_pet1:isMaxGrade()
	
	if_set_visible(var_34_3, nil, true)
	if_set_visible(var_34_3, "n_upgrade_chance", true)
	
	local var_34_5 = {
		n_slider = false,
		img_arrow = false,
		txt_count_none = true,
		n_top_info = true,
		txt_count_add = false,
		txt_count_total = false
	}
	
	for iter_34_0, iter_34_1 in pairs(var_34_5) do
		if_set_visible(var_34_3, iter_34_0, iter_34_1 == var_34_4)
	end
	
	local var_34_6 = "ma_petpoint"
	local var_34_7 = Account:getItemCount(var_34_6)
	local var_34_8 = DB("item_material", var_34_6, "name")
	local var_34_9 = arg_34_0.vars.dlg:getChildByName("n_material")
	
	if_set(var_34_9, "t_item_name", T(var_34_8))
	if_set(var_34_9, "t_have", T("item_count", {
		num = var_34_7
	}))
	if_set_opacity(var_34_9, nil, var_34_4 and 76.5 or 255)
	
	local var_34_10 = arg_34_0.vars.dlg:findChildByName("n_slider")
	local var_34_11 = arg_34_0.vars.synthesis_progress
	local var_34_12 = PetUtil:getUsableComposeMaxMaterial(arg_34_1)
	local var_34_13 = var_34_10:findChildByName("t_count")
	local var_34_14 = math.min(var_34_7, var_34_12)
	
	var_34_11:setMaxPercent(var_34_12)
	
	local var_34_15 = var_34_3:getChildByName("n_upgrade_chance")
	
	local function var_34_16(arg_35_0)
		arg_34_0.vars.use_petpoint = arg_35_0
		
		if_set(var_34_13, nil, arg_34_0.vars.use_petpoint .. "/" .. var_34_12)
		
		local var_35_0, var_35_1 = PetUtil:getCurrentSynthesisPercent(arg_34_0.vars.use_petpoint, arg_34_1)
		
		if var_35_0 and var_35_1 then
			UIUtil:setUIUpgradeChance(var_34_15, var_35_0, var_35_1, 24.25)
		end
	end
	
	local function var_34_17(arg_36_0, arg_36_1, arg_36_2)
		var_34_16(arg_36_1)
	end
	
	local var_34_18 = not var_34_4 or var_34_14 > 0
	
	arg_34_0:setProgressBarEnabled(var_34_18)
	var_34_11:addEventListener(Dialog.defaultSliderEventHandler)
	var_34_11:setPercent(0)
	
	local var_34_19 = 0
	
	var_34_11.min = var_34_19
	var_34_11.max = var_34_14
	
	var_34_16(var_34_19)
	
	var_34_11.handler = var_34_17
	
	local function var_34_20(arg_37_0)
		if arg_37_0 < var_34_19 then
			return 
		end
		
		if arg_37_0 > var_34_14 then
			return 
		end
		
		var_34_11:setPercent(arg_37_0)
		Dialog.defaultSliderEventHandler(var_34_11, 2)
		var_34_16(arg_37_0)
	end
	
	local function var_34_21()
		local var_38_0 = var_34_11:getPercent() - 1
		
		var_34_20(var_38_0)
	end
	
	local function var_34_22()
		var_34_20(var_34_19)
	end
	
	local function var_34_23()
		var_34_20(var_34_14)
	end
	
	local function var_34_24()
		local var_41_0 = var_34_11:getPercent() + 1
		
		var_34_20(var_41_0)
	end
	
	local var_34_25 = var_34_10:getChildByName("btn_plus")
	local var_34_26 = var_34_10:getChildByName("btn_minus")
	local var_34_27 = var_34_10:getChildByName("btn_max")
	local var_34_28 = var_34_10:getChildByName("btn_min")
	
	if var_34_18 and get_cocos_refid(var_34_25) and get_cocos_refid(var_34_26) and get_cocos_refid(var_34_27) and get_cocos_refid(var_34_28) then
		var_34_25:addTouchEventListener(function(arg_42_0, arg_42_1)
			if arg_42_1 == 0 then
				var_34_24()
			end
		end)
		var_34_26:addTouchEventListener(function(arg_43_0, arg_43_1)
			if arg_43_1 == 0 then
				var_34_21()
			end
		end)
		var_34_27:addTouchEventListener(function(arg_44_0, arg_44_1)
			if arg_44_1 == 0 then
				var_34_23()
			end
		end)
		var_34_28:addTouchEventListener(function(arg_45_0, arg_45_1)
			if arg_45_1 == 0 then
				var_34_22()
			end
		end)
	end
end

function PetSynthesis.setProgressBarEnabled(arg_46_0, arg_46_1)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.dlg) or not get_cocos_refid(arg_46_0.vars.synthesis_progress) then
		return 
	end
	
	arg_46_0.vars.synthesis_progress:setTouchEnabled(arg_46_1)
	
	if arg_46_1 then
		PetSynthesis:setHightLight(not arg_46_1)
	end
end

function PetSynthesis.setHightLight(arg_47_0, arg_47_1)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.dlg) or not get_cocos_refid(arg_47_0.vars.synthesis_progress) then
		return 
	end
	
	arg_47_0.vars.synthesis_progress:setHighlighted(arg_47_1)
end

function PetSynthesis.getUsePetPoint(arg_48_0)
	if not arg_48_0.vars then
		return 0
	end
	
	local var_48_0 = arg_48_0.vars.synthesis_progress
	
	if not get_cocos_refid(var_48_0) then
		return 0
	end
	
	local var_48_1 = arg_48_0.vars.synthesis_progress:getPercent()
	local var_48_2 = arg_48_0.vars.use_petpoint or 0
	
	if var_48_1 ~= var_48_2 then
		Log.e("PET SYNTHESIS PROGRESS ERROR. PROGRESS_PERCENT : " .. var_48_1 .. " USE_PETPOINT : " .. var_48_2)
		
		return 0
	end
	
	return var_48_2
end

function PetSynthesis.setPetInfos(arg_49_0, arg_49_1, arg_49_2)
	arg_49_0:updatePetTopArea(arg_49_1)
	arg_49_0:setPetSlot(arg_49_1, arg_49_2)
	if_set_visible(arg_49_0.vars.dlg, "n_top", true)
	if_set_visible(arg_49_0.vars.dlg, "n_info", true)
	if_set_visible(arg_49_0.vars.dlg, "n_none_info", false)
	if_set(arg_49_0.vars.dlg, "cost", comma_value(arg_49_1:getSynthesisValue()))
	
	if not arg_49_0.vars.syn_pet1 or not arg_49_0.vars.syn_pet2 then
		arg_49_0:setScrollViewOpacity(false)
	else
		arg_49_0:setupOnReadyComposeUI(arg_49_1)
		arg_49_0:setScrollViewOpacity(true)
	end
end

function PetSynthesis.setPetSlot(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0.vars["n_slot" .. arg_50_2]
	local var_50_1 = var_50_0:findChildByName("n_pos")
	local var_50_2 = UIUtil:getPetModel(arg_50_1)
	
	var_50_1:removeAllChildren()
	var_50_1:addChild(var_50_2)
	
	arg_50_0.vars["model" .. arg_50_2] = var_50_2
	
	local var_50_3 = UIUtil:updatePetBar(nil, nil, arg_50_1)
	
	UIUtil:updatePetBarInfo(var_50_3, nil, arg_50_1)
	var_50_3:setAnchorPoint(0.5, 0.5)
	
	local var_50_4 = var_50_0:findChildByName("n_pet_bar")
	
	var_50_4:removeAllChildren()
	var_50_4:addChild(var_50_3)
	arg_50_0.vars.pet_belt:popItem(arg_50_1)
end

function PetSynthesis.petBeltEventHandler(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	if arg_51_1 == "select" then
		arg_51_0:addPetInSlot(arg_51_2)
	end
end

function PetSynthesis.eventSetting(arg_52_0)
	arg_52_0.vars.pet_belt:setEventHandler(arg_52_0.petBeltEventHandler, arg_52_0)
end
