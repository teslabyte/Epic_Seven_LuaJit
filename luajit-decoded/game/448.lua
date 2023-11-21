PetSynthesisSettingPopup = {}

function HANDLER.pet_synthesis_check_p(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_cancel" then
		PetSynthesisSettingPopup:close(true)
	elseif arg_1_1 == "btn_ok" then
		PetSynthesisSettingPopup:close()
	elseif arg_1_1 == "btn_skill_item_select" then
		PetSynthesisSettingPopup:onSelectSkillItem(arg_1_0)
	end
end

function PetSynthesisSettingPopup.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0.vars = {}
	arg_2_0.vars.dlg = load_dlg("pet_synthesis_check_p", true, "wnd")
	
	PetUIMain:addBackFunc("pet_synthesis_check_p", arg_2_0.vars.dlg, function()
		arg_2_0:close()
	end)
	arg_2_1:addChild(arg_2_0.vars.dlg)
	arg_2_0.vars.dlg:setLocalZOrder(9999999)
	
	arg_2_0.vars.listview_skill1 = arg_2_0.vars.dlg:findChildByName("scrollview_skill1")
	arg_2_0.vars.listview_skill2 = arg_2_0.vars.dlg:findChildByName("scrollview_skill2")
	arg_2_0.vars.skill_list_synthesis_pet = PetSkillList:create({
		button_id = "synthesis",
		mode = "mid",
		use_button = true,
		control = arg_2_0.vars.listview_skill1
	})
	arg_2_0.vars.skill_list_synthesis2_pet = PetSkillList:create({
		button_id = "synthesis2",
		mode = "mid",
		use_button = true,
		control = arg_2_0.vars.listview_skill2
	})
	
	arg_2_0.vars.skill_list_synthesis_pet:setPet(arg_2_2)
	arg_2_0.vars.skill_list_synthesis2_pet:setPet(arg_2_3)
	
	arg_2_0.vars.synthesis_pet = arg_2_2
	arg_2_0.vars.synthesis_pet2 = arg_2_3
	arg_2_0.vars.max_select = arg_2_2:getMaxFixSkillNum()
	arg_2_0.vars.origin_selected_items = {}
	arg_2_0.vars.selected_items = {}
	
	if arg_2_4.change_callback then
		arg_2_0.vars.change_callback = arg_2_4.change_callback
	end
	
	local var_2_0 = 0
	
	if arg_2_4.selected_list then
		arg_2_0.vars.selected_items = arg_2_4.selected_list
		
		for iter_2_0, iter_2_1 in pairs(arg_2_0.vars.selected_items) do
			if iter_2_1.pet_type == "synthesis" then
				arg_2_0.vars.skill_list_synthesis_pet:setButtonSelected(iter_2_1)
			else
				arg_2_0.vars.skill_list_synthesis2_pet:setButtonSelected(iter_2_1)
			end
		end
		
		arg_2_0.vars.origin_selected_items = table.clone(arg_2_0.vars.selected_items)
		var_2_0 = #arg_2_4.selected_list
	end
	
	if_set(arg_2_0.vars.dlg, "txt_desc", T("ui_pet_genetic_popup_desc", {
		grade = arg_2_0.vars.synthesis_pet:getGrade(),
		min = var_2_0,
		max = arg_2_0.vars.synthesis_pet:getMaxFixSkillNum()
	}))
	if_set(arg_2_0.vars.dlg, "txt_info1", T("ui_pet_genetic_popup_name", {
		name = arg_2_0.vars.synthesis_pet:getName()
	}))
	if_set(arg_2_0.vars.dlg, "txt_info2", T("ui_pet_genetic_popup_name", {
		name = arg_2_0.vars.synthesis_pet2:getName()
	}))
end

function PetSynthesisSettingPopup.onSelectSkillItem(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.vars["skill_list_" .. arg_4_1.id .. "_pet"]
	
	if arg_4_1.select_flag then
		for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.selected_items) do
			if iter_4_1.skill_idx == arg_4_1.item.skill_idx and iter_4_1.pet_uid == arg_4_1.item.pet_uid then
				table.remove(arg_4_0.vars.selected_items, iter_4_0)
				
				break
			end
		end
		
		var_4_0:onPushButton(arg_4_1)
		if_set(arg_4_0.vars.dlg, "txt_desc", T("ui_pet_genetic_popup_desc", {
			grade = arg_4_0.vars.synthesis_pet:getGrade(),
			min = #arg_4_0.vars.selected_items,
			max = arg_4_0.vars.synthesis_pet:getMaxFixSkillNum()
		}))
		
		return 
	end
	
	if #arg_4_0.vars.selected_items >= arg_4_0.vars.max_select then
		balloon_message_with_sound("pet_synthesis_skill_over")
		
		return 
	end
	
	for iter_4_2, iter_4_3 in pairs(arg_4_0.vars.selected_items) do
		if iter_4_3.skill == arg_4_1.item.skill then
			balloon_message_with_sound("pet_synthesis_skill_overlap")
			
			return 
		end
	end
	
	arg_4_1.item.pet_type = arg_4_1.id
	
	table.insert(arg_4_0.vars.selected_items, arg_4_1.item)
	if_set(arg_4_0.vars.dlg, "txt_desc", T("ui_pet_genetic_popup_desc", {
		grade = arg_4_0.vars.synthesis_pet:getGrade(),
		min = #arg_4_0.vars.selected_items,
		max = arg_4_0.vars.synthesis_pet:getMaxFixSkillNum()
	}))
	var_4_0:onPushButton(arg_4_1)
end

function PetSynthesisSettingPopup.close(arg_5_0, arg_5_1)
	if arg_5_1 then
		arg_5_0.vars.selected_items = arg_5_0.vars.origin_selected_items
	end
	
	if arg_5_0.vars.change_callback then
		arg_5_0.vars.change_callback(arg_5_0.vars.selected_items)
	end
	
	PetUIMain:popBackFunc("pet_synthesis_check_p", arg_5_0.vars.dlg)
	arg_5_0.vars.dlg:removeFromParent()
end

PetSynthesisCheckPopup = {}

function HANDLER.pet_skill_choose_p(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" or arg_6_1 == "btn_cancel" then
		PetSynthesisCheckPopup:close()
	elseif arg_6_1 == "btn_ok" then
		PetSynthesisCheckPopup:query()
	end
end

function PetSynthesisCheckPopup.initAdditionData(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.vars.dlg:findChildByName("n_upgrade_chance")
	local var_7_1 = arg_7_1:isMaxGrade()
	local var_7_2 = {
		"txt_count_add",
		"txt_count_total"
	}
	local var_7_3 = {
		"txt_count_none"
	}
	local var_7_4 = var_7_0:findChildByName("txt_upgrade_chance")
	local var_7_5 = var_7_4:getContentSize()
	local var_7_6 = var_7_4:getScale()
	local var_7_7 = var_7_5.width * var_7_4:getScale()
	
	for iter_7_0, iter_7_1 in pairs(var_7_2) do
		local var_7_8 = var_7_0:findChildByName(iter_7_1)
		
		if get_cocos_refid(var_7_8) then
			var_7_8:setVisible(not var_7_1)
			var_7_8:setPositionX(var_7_8:getPositionX() + (var_7_7 - 285 * var_7_6) / 2)
		end
		
		if_set_visible(var_7_0, iter_7_1, not var_7_1)
	end
	
	for iter_7_2, iter_7_3 in pairs(var_7_3) do
		local var_7_9 = var_7_0:findChildByName(iter_7_3)
		
		if get_cocos_refid(var_7_9) then
			var_7_9:setVisible(var_7_1)
			var_7_9:setPositionX(var_7_9:getPositionX() + (var_7_7 - 285 * var_7_6) / 2)
		end
	end
	
	if var_7_1 then
		return 
	end
	
	UIUtil:setUIUpgradeChance(var_7_0, arg_7_2, arg_7_3, 24.25)
end

function PetSynthesisCheckPopup.init(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	arg_8_0.vars = {}
	arg_8_0.vars.check_pets = {}
	arg_8_0.vars.check_pets[1] = arg_8_4
	arg_8_0.vars.check_pets[2] = arg_8_5
	arg_8_0.vars.selected_appear_pet = arg_8_2
	arg_8_0.vars.selected_skill_list = arg_8_3
	arg_8_0.vars.dlg = load_dlg("pet_skill_choose_p", true, "wnd")
	
	PetUIMain:addBackFunc("pet_skill_choose_p", arg_8_0.vars.dlg, function()
		arg_8_0:close()
	end)
	arg_8_0:initAppearPet(arg_8_2)
	arg_8_0:initSkillList(arg_8_3)
	arg_8_0:initAdditionData(arg_8_4, arg_8_6, arg_8_7)
	arg_8_1:addChild(arg_8_0.vars.dlg)
end

function PetSynthesisCheckPopup.initAppearPet(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.vars.dlg:findChildByName("n_appearance")
	
	if_set_visible(var_10_0, "n_none", not arg_10_1)
	if_set_visible(var_10_0, "n_pet", arg_10_1)
	
	if arg_10_1 then
		local var_10_1 = var_10_0:findChildByName("n_pet_info")
		
		UIUtil:updatePetName(var_10_1:getChildByName("txt_name"), arg_10_1)
		UIUtil:updatePetStars(var_10_1:getChildByName("n_stars"), arg_10_1)
		
		local var_10_2 = var_10_0:findChildByName("n_pos")
		local var_10_3 = UIUtil:getPetModel(arg_10_1)
		
		var_10_2:removeAllChildren()
		var_10_2:addChild(var_10_3)
	end
end

function PetSynthesisCheckPopup.initSkillList(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.vars.dlg:findChildByName("n_skill")
	local var_11_1 = arg_11_1 and #arg_11_1 or 0
	
	if_set_visible(var_11_0, "n_none", not (var_11_1 > 0))
	if_set_visible(var_11_0, "scrollview_skill", var_11_1 > 0)
	
	if var_11_1 > 0 then
		local var_11_2 = var_11_0:findChildByName("scrollview_skill")
		
		arg_11_0.vars.skill_list = PetSkillList:create({
			mode = "vertical",
			control = var_11_2
		})
		
		arg_11_0.vars.skill_list:setPetSkills(arg_11_1)
	end
end

function PetSynthesisCheckPopup.procNextPopup(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.dlg) then
		return 
	end
	
	if #arg_12_0.vars.popups <= 0 then
		PetSynthesis:confirmChoice(arg_12_0.vars.selected_appear_pet, arg_12_0.vars.selected_skill_list)
		arg_12_0:close()
		
		return 
	end
	
	local var_12_0 = table.remove(arg_12_0.vars.popups, 1)
	
	local function var_12_1()
		arg_12_0:procNextPopup()
	end
	
	local var_12_2 = {
		yesno = true,
		handler = var_12_1,
		warning = var_12_0.warning_text
	}
	
	Dialog:msgBox(T(var_12_0.text), var_12_2)
end

function PetSynthesisCheckPopup.getHighestSkills(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = {}
	local var_14_1 = 0
	
	for iter_14_0 = 1, #arg_14_2 do
		local var_14_2 = arg_14_2[iter_14_0]
		local var_14_3 = arg_14_3[var_14_2]
		
		if var_14_3 >= arg_14_1 - var_14_1 then
			local var_14_4 = arg_14_1 - var_14_1
			
			var_14_1 = var_14_1 + var_14_4
			var_14_0[var_14_2] = var_14_4
			
			break
		else
			var_14_1 = var_14_1 + var_14_3
			var_14_0[var_14_2] = var_14_3
		end
	end
	
	return var_14_0
end

function PetSynthesisCheckPopup.isHighestSkills(arg_15_0)
	if not arg_15_0.vars.selected_skill_list then
		return false
	end
	
	local var_15_0 = {}
	local var_15_1 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.check_pets) do
		local var_15_2 = iter_15_1:getAllSkillRank()
		
		for iter_15_2, iter_15_3 in pairs(var_15_2) do
			if not var_15_0[iter_15_3] then
				var_15_0[iter_15_3] = 1
				
				table.insert(var_15_1, iter_15_3)
			else
				var_15_0[iter_15_3] = var_15_0[iter_15_3] + 1
			end
		end
	end
	
	table.sort(var_15_1, function(arg_16_0, arg_16_1)
		return arg_16_1 < arg_16_0
	end)
	
	local var_15_3 = arg_15_0:getHighestSkills(arg_15_0:getMaxFixSkillNum(), var_15_1, var_15_0)
	local var_15_4 = {}
	
	for iter_15_4, iter_15_5 in pairs(arg_15_0.vars.selected_skill_list) do
		if not var_15_4[iter_15_5.skill_lv] then
			var_15_4[iter_15_5.skill_lv] = 1
		else
			var_15_4[iter_15_5.skill_lv] = var_15_4[iter_15_5.skill_lv] + 1
		end
	end
	
	for iter_15_6, iter_15_7 in pairs(var_15_3) do
		if var_15_4[iter_15_6] ~= iter_15_7 then
			return false
		end
	end
	
	return true
end

function PetSynthesisCheckPopup.getMaxFixSkillNum(arg_17_0)
	local var_17_0 = arg_17_0.vars.check_pets[1]:getMaxFixSkillNum()
	
	if var_17_0 ~= arg_17_0.vars.check_pets[2]:getMaxFixSkillNum() then
		Log.e("PET1 ~= PET2 Skill Num!")
		
		return nil
	end
	
	return var_17_0
end

function PetSynthesisCheckPopup.isHaveFeature(arg_18_0)
	return arg_18_0.vars.check_pets[1]:isFeature() == "y" or arg_18_0.vars.check_pets[2]:isFeature() == "y"
end

function PetSynthesisCheckPopup.getTeamEquipPetList(arg_19_0)
	local var_19_0 = arg_19_0.vars.check_pets[1]
	local var_19_1 = arg_19_0.vars.check_pets[2]
	local var_19_2 = {}
	
	for iter_19_0, iter_19_1 in pairs(Account:getPublicReservedTeamSlot()) do
		if Account:isPetInTeam(var_19_0, iter_19_1) or Account:isPetInLobby(var_19_0) then
			var_19_2[1] = var_19_0
		end
		
		if Account:isPetInTeam(var_19_1, iter_19_1) or Account:isPetInLobby(var_19_1) then
			var_19_2[2] = var_19_1
		end
	end
	
	return var_19_2
end

function PetSynthesisCheckPopup.query(arg_20_0)
	arg_20_0.vars.popups = {}
	
	local var_20_0 = arg_20_0:isHighestSkills()
	local var_20_1 = arg_20_0.vars.selected_skill_list and #arg_20_0.vars.selected_skill_list or 0
	local var_20_2 = arg_20_0:getMaxFixSkillNum()
	local var_20_3 = arg_20_0:getTeamEquipPetList()
	
	if table.count(var_20_3) > 0 then
		local var_20_4 = ""
		
		if table.count(var_20_3) == 1 then
			for iter_20_0, iter_20_1 in pairs(var_20_3) do
				var_20_4 = iter_20_1:getName()
			end
		else
			var_20_4 = var_20_3[1]:getName() .. ", " .. var_20_3[2]:getName()
		end
		
		local var_20_5 = T("pet_synthesis_auto_place_name", {
			pet_name = var_20_4
		})
		
		table.insert(arg_20_0.vars.popups, {
			text = "pet_synthesis_auto_place",
			warning_text = var_20_5
		})
	end
	
	if var_20_1 < var_20_2 then
		table.insert(arg_20_0.vars.popups, {
			text = "pet_synthesis_warning_no_skill"
		})
	elseif not var_20_0 then
		table.insert(arg_20_0.vars.popups, {
			text = "pet_synthesis_warning_low_skill"
		})
	end
	
	local var_20_6 = arg_20_0.vars.selected_appear_pet
	
	if not var_20_6 and arg_20_0:isHaveFeature() or var_20_6 and var_20_6:isFeature() ~= "y" and arg_20_0:isHaveFeature() then
		table.insert(arg_20_0.vars.popups, {
			text = "pet_synthesis_warning_special"
		})
	end
	
	arg_20_0:procNextPopup()
end

function PetSynthesisCheckPopup.close(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	PetUIMain:popBackFunc("pet_skill_choose_p", arg_21_0.vars.dlg)
	PetSynthesis:setProgressBarEnabled(true)
	arg_21_0.vars.dlg:removeFromParent()
	
	arg_21_0.vars = nil
end

function HANDLER.pet_synthesis_result_p(arg_22_0, arg_22_1)
	if arg_22_1 == "btn_ok" then
		PetSynthesisResultPopup:close()
	end
end

PetSynthesisResultPopup = {}

function PetSynthesisResultPopup.updateSkillList(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.vars.skill_list:getPetSkillList(arg_23_1)
	local var_23_1 = arg_23_2.skill_list
	local var_23_2 = {}
	
	for iter_23_0, iter_23_1 in pairs(var_23_1) do
		var_23_2[iter_23_1] = true
	end
	
	for iter_23_2, iter_23_3 in pairs(var_23_0) do
		if not var_23_2[arg_23_1:getSkillID(iter_23_3.skill_idx)] then
			iter_23_3.is_new = true
		end
	end
	
	arg_23_0.vars.skill_list:setPetSkills(var_23_0)
end

function PetSynthesisResultPopup.updateBasicData(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1:getMaxLevel()
	local var_24_1 = arg_24_1:getMaxFav()
	local var_24_2 = arg_24_0.vars.dlg:findChildByName("n_generation")
	local var_24_3 = arg_24_0.vars.dlg:findChildByName("n_level")
	local var_24_4 = arg_24_0.vars.dlg:findChildByName("n_favorability")
	
	UIUtil:updatePetStars(var_24_2:findChildByName("n_star"), arg_24_1)
	if_set(var_24_3, "txt_level", var_24_0)
	if_set(var_24_4, "txt_favorability", var_24_1)
end

function PetSynthesisResultPopup.updateDiffData(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_2.pet
	local var_25_1 = var_25_0:getGrade()
	local var_25_2 = var_25_0:getMaxLevel()
	local var_25_3 = var_25_0:getMaxFav()
	local var_25_4 = arg_25_1:getGrade()
	local var_25_5 = arg_25_1:getMaxLevel()
	local var_25_6 = arg_25_1:getMaxFav()
	local var_25_7 = arg_25_0.vars.dlg:findChildByName("n_generation")
	local var_25_8 = arg_25_0.vars.dlg:findChildByName("n_level")
	local var_25_9 = arg_25_0.vars.dlg:findChildByName("n_favorability")
	local var_25_10 = var_25_1 ~= var_25_4
	
	if_set_visible(var_25_7, "n_up", var_25_10)
	if_set_visible(var_25_8, "n_up", var_25_10)
	if_set_visible(var_25_9, "n_up", var_25_10)
	if_set_visible(var_25_7, "n_same", not var_25_10)
	if_set_visible(var_25_8, "n_same", not var_25_10)
	if_set_visible(var_25_9, "n_same", not var_25_10)
	
	if var_25_10 then
		local var_25_11 = var_25_7:findChildByName("n_up")
		local var_25_12 = var_25_8:findChildByName("n_up")
		local var_25_13 = var_25_9:findChildByName("n_up")
		
		UIUtil:updatePetStars(var_25_11:findChildByName("n_star"), arg_25_1)
		if_set(var_25_12, "txt_level", var_25_5)
		if_set(var_25_13, "txt_favorability", var_25_6)
		if_set_visible(var_25_11, "txt_next", true)
		if_set(var_25_12, "txt_next", tostring(var_25_5 - var_25_2))
		if_set(var_25_13, "txt_next", tostring(var_25_6 - var_25_3))
	end
end

function PetSynthesisResultPopup.effect_test(arg_26_0, arg_26_1)
	arg_26_0.vars = {}
	arg_26_0.vars.dlg = load_dlg("pet_synthesis_result_p", true, "wnd")
	arg_26_1 = arg_26_1 or SceneManager:getRunningNativeScene()
	arg_26_0.vars.model = CACHE:getModel("pet_slime1_s_grade3_1")
	
	arg_26_0.vars.dlg:findChildByName("n_pos"):addChild(arg_26_0.vars.model)
	arg_26_0:updateEffect(true)
	arg_26_1:addChild(arg_26_0.vars.dlg)
end

function PetSynthesisResultPopup.updateEffect(arg_27_0, arg_27_1)
	arg_27_0.vars.model:setVisible(false)
	setBlendColor2(arg_27_0.vars.model, "def", cc.c4f(1, 1, 1, 1), 1)
	UIAction:Add(SEQ(DELAY(500), SEQ(SPAWN(CALL(function()
		local var_28_0 = arg_27_0.vars.dlg:findChildByName("n_pos")
		local var_28_1 = 1 / var_28_0:getScale()
		local var_28_2, var_28_3 = arg_27_0.vars.model:getBoneNode("target"):getPosition()
		
		EffectManager:Play({
			fn = "ui_pet_swap_eff.cfx",
			layer = var_28_0,
			pivot_x = var_28_2,
			pivot_y = var_28_3,
			scale = var_28_1
		})
	end), BLEND(500, "white", 1, 0), SHOW(true)), DELAY(500), CALL(function()
		local var_29_0 = arg_27_0.vars.dlg:findChildByName("n_pos")
		local var_29_1, var_29_2 = arg_27_0.vars.model:getBoneNode("target"):getPosition()
		local var_29_3 = 1 / var_29_0:getScale()
		
		EffectManager:Play({
			fn = "ui_pet_shine_loop.cfx",
			layer = var_29_0,
			pivot_x = var_29_1,
			pivot_y = var_29_2,
			scale = var_29_3
		})
	end))), arg_27_0.vars.model, "block")
	
	local var_27_0 = "ui_reward_popup_eff_weak.cfx"
	
	if arg_27_1 then
		var_27_0 = "ui_reward_popup_eff.cfx"
	end
	
	local var_27_1 = arg_27_0.vars.dlg:findChildByName("txt_title")
	local var_27_2 = var_27_1:getContentSize()
	
	EffectManager:Play({
		fn = var_27_0,
		layer = var_27_1,
		pivot_x = var_27_2.width / 2
	})
end

function PetSynthesisResultPopup.init(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	arg_30_0.vars = {}
	arg_30_0.vars.pet = arg_30_2
	arg_30_0.vars.diff_data = arg_30_3
	arg_30_0.vars.dlg = load_dlg("pet_synthesis_result_p", true, "wnd")
	
	PetUIMain:addBackFunc("pet_synthesis_result_p", arg_30_0.vars.dlg, function()
		arg_30_0:close()
	end)
	
	local var_30_0 = arg_30_0.vars.dlg:findChildByName("scrollview_skill")
	
	arg_30_0.vars.skill_list = PetSkillList:create({
		control_name = "wnd/pet_skill_item2.csb",
		mode = "mid",
		check_new = true,
		control = var_30_0
	})
	
	local var_30_1 = arg_30_0.vars.dlg:findChildByName("n_pos")
	
	arg_30_0.vars.model = UIUtil:getPetModel(arg_30_2)
	
	var_30_1:addChild(arg_30_0.vars.model)
	arg_30_0:updateBasicData(arg_30_3.pet)
	arg_30_0:updateSkillList(arg_30_2, arg_30_3)
	arg_30_0:updateDiffData(arg_30_2, arg_30_3)
	
	local var_30_2 = arg_30_2:getGrade()
	local var_30_3 = arg_30_3.pet:getGrade()
	
	arg_30_0:updateEffect(var_30_2 ~= var_30_3)
	arg_30_1:addChild(arg_30_0.vars.dlg)
end

function PetSynthesisResultPopup.close(arg_32_0)
	if arg_32_0.vars then
		PetUIMain:popBackFunc("pet_synthesis_result_p", arg_32_0.vars.dlg)
		arg_32_0.vars.dlg:removeFromParent()
		
		arg_32_0.vars = nil
	end
end
