PetUpgrade = {}

function HANDLER.unit_pet_upgrade(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_upgrade" then
		PetUpgrade:reqUpgrade()
	elseif arg_1_1 == "btn_reset" then
		PetUpgrade:clearPetFoodList()
	elseif arg_1_1 == "btn_synthesis" then
		PetUpgrade:openPetSynthesis()
	elseif arg_1_1 == "btn_auto" then
		PetUpgrade:autoFillPetFoodList()
	elseif arg_1_1 == "btn_left" or arg_1_1 == "btn_right" then
		local var_1_0 = string.len("btn_")
		local var_1_1 = string.sub(arg_1_1, var_1_0 + 1, -1)
		local var_1_2 = PetUpgrade:findDirectionGetUnit(var_1_1)
		
		if not var_1_2 then
			return 
		end
		
		PetUpgrade:setPetInfos(var_1_2)
		PetUpgrade:updateAllPetFoodCount()
		PetUpgrade:clearPetFoodList()
		PetUpgrade:setButtonState(true)
	elseif string.starts(arg_1_1, "btn_petfood") then
		local var_1_3 = string.len("btn_petfood")
		local var_1_4 = tonumber(string.sub(arg_1_1, var_1_3 + 1, -1))
		
		PetUpgrade:addPetFoodList(var_1_4)
	elseif string.starts(arg_1_1, "btn_remove") then
		local var_1_5 = string.len("btn_remove")
		local var_1_6 = tonumber(string.sub(arg_1_1, var_1_5 + 1, -1))
		
		PetUpgrade:removePetFoodList(var_1_6)
	end
end

function MsgHandler.enhance_pet(arg_2_0)
	PetUpgrade:onEnhancePet(arg_2_0)
	ConditionContentsManager:dispatch("pet.enchance")
end

function PetUpgrade.onCreate(arg_3_0, arg_3_1)
	arg_3_0.vars = {}
	arg_3_1 = arg_3_1 or {}
	arg_3_0.vars.dlg = load_dlg("unit_pet_upgrade", true, "wnd")
	arg_3_0.vars.parent = PetUIBase:getBaseUI()
	
	arg_3_0.vars.parent:addChild(arg_3_0.vars.dlg)
	PetUIBase:setVisiblePetBelt(false)
	arg_3_0:initSortedPetFoodlList()
	arg_3_0:initRegisteredPetFoods()
	arg_3_0:initPetUpgradeUI()
	
	local var_3_0 = arg_3_1.pet
	
	arg_3_0:setPetInfos(var_3_0)
	
	if arg_3_0.vars.eff_bg then
		arg_3_0.vars.eff_bg:removeFromParent()
	end
	
	arg_3_0:disableLvUp(false)
	arg_3_0.vars.dlg:setVisible(false)
	
	arg_3_0.vars.eff_bg = EffectManager:Play({
		fn = "ui_pet_up_back_eff.cfx",
		layer = PetUIBase:getBaseUI(),
		pivot_x = VIEW_WIDTH / 2 + VIEW_BASE_LEFT - 200
	})
end

function PetUpgrade.onEnter(arg_4_0)
	arg_4_0:slideIn()
	arg_4_0.vars.dlg:setVisible(true)
end

function PetUpgrade.onLeave(arg_5_0)
	PetUIBase:setVisiblePetBelt(true)
	arg_5_0:slideOut()
	UIAction:Add(SEQ(DELAY(200), REMOVE()), arg_5_0.vars.dlg, "block")
	
	if arg_5_0.vars.eff_bg then
		arg_5_0.vars.eff_bg:removeFromParent()
		
		arg_5_0.vars.eff_bg = nil
	end
	
	if UIAction:Find("pet_upgrade.blink") then
		UIAction:Remove("pet_upgrade.blink")
	end
	
	local var_5_0 = {
		pet = arg_5_0.vars.pet
	}
	
	arg_5_0.vars = nil
	
	return var_5_0
end

function PetUpgrade.getWnd(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.dlg) then
		return nil
	end
	
	return arg_6_0.vars.dlg
end

function PetUpgrade.openPetSynthesis(arg_7_0)
	if not arg_7_0.vars or not arg_7_0.vars.pet then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.pet
	
	if not var_7_0:isCanSynthesis() then
		local var_7_1 = var_7_0:getUsableSynthesisList()
		
		Dialog:msgPetLock(var_7_1)
		
		return 
	end
	
	PetUIMain:popMode()
	PetUIMain:pushMode("Synthesis", {
		pet = var_7_0
	})
end

local function var_0_0(arg_8_0, arg_8_1)
	local var_8_0
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0) do
		if iter_8_1:getUID() == arg_8_1:getUID() then
			var_8_0 = iter_8_0
			
			break
		end
	end
	
	return var_8_0
end

local function var_0_1(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0[arg_9_1]
	
	if not var_9_0 then
		return nil
	end
	
	if not var_9_0:isMaxLevel() then
		return var_9_0
	end
	
	return false
end

function PetUpgrade.findDirectionGetUnit(arg_10_0, arg_10_1)
	if not arg_10_1 or type(arg_10_1) ~= "string" then
		return 
	end
	
	local var_10_0 = PetUIBase:getPetBelt()
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = var_10_0:getItems()
	local var_10_2 = var_0_0(var_10_1, arg_10_0.vars.pet)
	
	if not var_10_2 then
		print("NOTHING! CHECK UNIT EXIST!")
		
		return 
	end
	
	local var_10_3
	local var_10_4
	
	if arg_10_1 == "right" then
		for iter_10_0 = var_10_2 + 1, table.count(var_10_1) do
			local var_10_5 = var_0_1(var_10_1, iter_10_0)
			
			if var_10_5 == nil then
				return 
			end
			
			if var_10_5 ~= false then
				var_10_3 = var_10_5
				
				break
			end
		end
	elseif arg_10_1 == "left" then
		for iter_10_1 = var_10_2 - 1, 1, -1 do
			local var_10_6 = var_0_1(var_10_1, iter_10_1)
			
			if var_10_6 == nil then
				return 
			end
			
			if var_10_6 ~= false then
				var_10_3 = var_10_6
				
				break
			end
		end
	else
		return nil
	end
	
	return var_10_3
end

function PetUpgrade.reqUpgrade(arg_11_0)
	if arg_11_0:isEmptyPetFoodList() then
		balloon_message_with_sound("pet_need_material")
		
		return 
	end
	
	local var_11_0, var_11_1 = arg_11_0:getEnhanceInfo()
	
	if var_11_1 > Account:getCurrency("gold") then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	arg_11_0:req_upgrade_pet()
end

function PetUpgrade.req_upgrade_pet(arg_12_0)
	if not arg_12_0.vars or table.empty(arg_12_0.vars.registered_pet_foods) then
		return 
	end
	
	local var_12_0 = {
		materials = {}
	}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.registered_pet_foods) do
		local var_12_1 = iter_12_0
		
		var_12_0.materials[var_12_1] = iter_12_1.count
	end
	
	local var_12_2 = arg_12_0.vars.pet:getUID()
	
	query("enhance_pet", {
		target = var_12_2,
		enhancers = json.encode(var_12_0)
	})
end

function PetUpgrade.onEnhancePet(arg_13_0, arg_13_1)
	arg_13_0:enhanceEffect(arg_13_1)
end

function PetUpgrade.enhanceEffect(arg_14_0, arg_14_1)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.dlg) then
		return 
	end
	
	if table.empty(arg_14_0.vars.pet_food_data_list) or table.empty(arg_14_0.vars.registered_pet_foods) then
		return 
	end
	
	if not arg_14_0.vars or not arg_14_0.vars.ui or table.empty(arg_14_0.vars.ui.pet_food_slot) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.pet_food_data_list
	local var_14_1 = arg_14_0.vars.registered_pet_foods
	local var_14_2 = 0
	local var_14_3 = 0
	
	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		local var_14_4 = var_14_1[iter_14_1.id]
		
		if var_14_4 and var_14_4.count and var_14_4.count > 0 then
			local var_14_5 = arg_14_0.vars.ui.pet_food_slot[iter_14_0]:getChildByName("pet_food_eff") or cc.Node:create()
			
			if not get_cocos_refid(arg_14_0.vars.ui.pet_food_slot[iter_14_0]:getChildByName("pet_food_eff")) then
				var_14_5:setName("pet_food_eff")
				arg_14_0.vars.ui.pet_food_slot[iter_14_0]:addChild(var_14_5)
				
				local var_14_6 = arg_14_0.vars.ui.pet_food_slot[iter_14_0]:getChildByName("n_pet"):getPositionX()
				local var_14_7 = arg_14_0.vars.ui.pet_food_slot[iter_14_0]:getChildByName("n_pet"):getPositionY()
				
				var_14_5:setPositionX(var_14_6)
				var_14_5:setPositionY(var_14_7)
			end
			
			var_14_3 = var_14_3 + 1
			var_14_2 = (var_14_3 - 1) * 200
			
			EffectManager:Play({
				fn = "ui_pet_levelup_food.cfx",
				y = 0,
				pivot_z = 99998,
				x = 0,
				layer = var_14_5,
				delay = var_14_2
			})
			UIAction:Add(DELAY(var_14_2), arg_14_0.vars.dlg, "block")
		end
	end
	
	local var_14_8 = var_14_2 - 100
	
	UIAction:Add(SPAWN(SEQ(LOG(BLEND(200, "white", 0, 1), 100), DELAY(var_14_8), RLOG(BLEND(200, "white", 1, 0), 100)), SEQ(RLOG(SCALE(200, 1, 1.05)), DELAY(var_14_8), CALL(PetUpgrade.onEnhancePet_1, arg_14_0, arg_14_1), RLOG(SCALE(100, 1.05, 0.85)), RLOG(SCALE(100, 0.85, 1)))), arg_14_0.vars.model, "block")
end

function PetUpgrade.onEnhancePet_1(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.pet:getLv()
	
	Account:updatePetByInfo(arg_15_1.target)
	Account:addReward(arg_15_1.dec_result)
	Account:addReward(arg_15_1.add_result)
	
	local var_15_1 = arg_15_0.vars.pet:getLv()
	
	if var_15_0 ~= var_15_1 then
		ConditionContentsManager:dispatch("pet.levelup", {
			level = var_15_1,
			prev_level = var_15_0
		})
	end
	
	arg_15_0:showRefundPetFoodPopup(arg_15_1.extra_cnt)
	arg_15_0:playBonusEffect(arg_15_1.exp_ratio)
	arg_15_0:updateAllPetFoodCount()
	arg_15_0:clearPetFoodList()
	arg_15_0:updatePetInfos(arg_15_0.vars.pet)
	arg_15_0:updatePetIncInfos()
	
	if arg_15_0.vars.pet:isMaxLevel() then
		arg_15_0:setButtonState(false)
		arg_15_0:setDisableRegisterButtons()
	end
end

function PetUpgrade.playBonusEffect(arg_16_0, arg_16_1)
	if to_n(arg_16_1) <= 1 then
		return 
	end
	
	local var_16_0
	local var_16_1 = arg_16_1 > 1.5 and "ui_enchant_ultimate.cfx" or "ui_enchant_bonus.cfx"
	local var_16_2 = arg_16_0.vars.dlg:getChildByName("CENTER")
	
	if get_cocos_refid(var_16_2) then
		EffectManager:Play({
			x = 0,
			y = 420,
			fn = var_16_1,
			layer = arg_16_0.vars.dlg:getChildByName("CENTER")
		})
	end
end

function PetUpgrade.showRefundPetFoodPopup(arg_17_0, arg_17_1)
	if not arg_17_1 or arg_17_1 < 1 then
		return 
	end
	
	local var_17_0 = {}
	
	table.insert(var_17_0, {
		code = "ma_petfood_e_1",
		count = arg_17_1
	})
	Dialog:msgRewards(T("ui_popup_desc_pet_refund"), {
		rewards = var_17_0
	})
end

function PetUpgrade.disableLvUp(arg_18_0, arg_18_1)
	if_set_visible(arg_18_0.vars.dlg, "n_lv_up", arg_18_1)
	if_set_visible(arg_18_0.vars.dlg, "arrow_lv", arg_18_1)
end

function PetUpgrade.setButtonState(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.dlg) then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.dlg:getChildByName("CENTER")
	
	if get_cocos_refid(var_19_0) then
		local var_19_1 = var_19_0:getChildByName("n_buttons")
		
		if_set_visible(var_19_1, "btn_upgrade", arg_19_1)
		if_set_visible(var_19_1, "btn_reset", arg_19_1)
		if_set_visible(var_19_1, "btn_synthesis", not arg_19_1)
		
		local var_19_2 = var_19_0:getChildByName("n_info")
		local var_19_3
		local var_19_4 = arg_19_1 and "pet_upgrade_exp_desc" or "pet_upgrade_exp_max"
		
		if_set(var_19_2, "label", T(var_19_4))
	end
end

function PetUpgrade.setDisableRegisterButtons(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.dlg) then
		return 
	end
	
	if not arg_20_0.vars.ui or table.empty(arg_20_0.vars.ui) then
		return 
	end
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.ui.pet_food_btn) do
		if_set_opacity(iter_20_1, nil, 76.5)
	end
	
	if get_cocos_refid(arg_20_0.vars.ui.auto_fill_btn) then
		if_set_opacity(arg_20_0.vars.ui.auto_fill_btn, nil, 76.5)
	end
end

function PetUpgrade.getEnhanceInfo(arg_21_0)
	local var_21_0 = arg_21_0.vars.pet:clone()
	local var_21_1 = 0
	local var_21_2 = 0
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.registered_pet_foods) do
		local var_21_3 = iter_21_1.count * iter_21_1.price
		local var_21_4 = iter_21_1.count * iter_21_1.exp
		
		var_21_2 = var_21_2 + var_21_3
		var_21_1 = var_21_1 + var_21_4
	end
	
	var_21_0:addExp(var_21_1)
	
	return var_21_0, var_21_2, var_21_1
end

function PetUpgrade._updateIncLevel(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.pet:getLv()
	local var_22_1 = arg_22_1:getLv()
	local var_22_2 = arg_22_0.vars.dlg:findChildByName("upgrade")
	
	if_set_visible(var_22_2, nil, true)
	if_set(var_22_2, "label_up", "+" .. var_22_1 - var_22_0)
end

function PetUpgrade._updateIncExp(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.vars.dlg:findChildByName("n_exp_bar")
	
	UIUtil:updatePetExpText(var_23_0:findChildByName("txt_exp"), arg_23_0.vars.pet, {
		inc_exp = arg_23_1
	})
	
	local var_23_1 = var_23_0:findChildByName("up_exp_gauge")
	
	UIUtil:updatePetExpBar(var_23_1, arg_23_0.vars.pet, {
		inc_exp = arg_23_1
	})
	
	if not UIAction:Find("pet_upgrade.blink") then
		UIAction:Add(SEQ(DELAY(200), LOOP(SEQ(LOG(FADE_OUT(300)), LOG(FADE_IN(300))))), var_23_1, "pet_upgrade.blink")
	end
end

function PetUpgrade._updateUsePrice(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.dlg:findChildByName("cost")
	
	if_set(var_24_0, nil, comma_value(arg_24_1))
end

function PetUpgrade.updatePetIncInfos(arg_25_0)
	local var_25_0, var_25_1, var_25_2 = arg_25_0:getEnhanceInfo()
	local var_25_3 = arg_25_0.vars.dlg:findChildByName("n_lv_up")
	
	UIUtil:updatePetLevel(var_25_3, var_25_0)
	arg_25_0:_updateIncLevel(var_25_0)
	arg_25_0:_updateIncExp(var_25_2)
	arg_25_0:_updateUsePrice(var_25_1)
end

function PetUpgrade.updatePetInfos(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.vars.dlg:findChildByName("name")
	
	UIUtil:updatePetUpgradeInfo(var_26_0, arg_26_1)
	UIUtil:updatePetExpInfos(arg_26_0.vars.dlg:findChildByName("n_exp_bar"), arg_26_1, {
		is_ani = true
	})
end

function PetUpgrade.initSortedPetFoodlList(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	local var_27_0 = {}
	
	for iter_27_0 = 1, 99999 do
		local var_27_1, var_27_2, var_27_3, var_27_4, var_27_5, var_27_6 = DBN("item_material", iter_27_0, {
			"id",
			"ma_type",
			"ma_type2",
			"get_xp",
			"icon",
			"grade"
		})
		
		if not var_27_1 then
			break
		end
		
		if string.starts(var_27_1, "ma_pet") and var_27_2 == "petfood" and var_27_3 == "exp" then
			local var_27_7 = {
				id = var_27_1,
				price = 4 * (GAME_STATIC_VARIABLE.pet_enhance_price or 1000),
				get_xp = to_n(var_27_4),
				icon = var_27_5,
				grade = var_27_6
			}
			
			table.insert(var_27_0, var_27_7)
		end
	end
	
	table.sort(var_27_0, function(arg_28_0, arg_28_1)
		return arg_28_0.get_xp < arg_28_1.get_xp
	end)
	
	arg_27_0.vars.pet_food_data_list = var_27_0
end

function PetUpgrade.initRegisteredPetFoods(arg_29_0)
	if not arg_29_0.vars or table.empty(arg_29_0.vars.pet_food_data_list) then
		return 
	end
	
	arg_29_0.vars.registered_pet_foods = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.pet_food_data_list) do
		arg_29_0.vars.registered_pet_foods[iter_29_1.id] = {
			count = 0,
			price = iter_29_1.price,
			exp = iter_29_1.get_xp
		}
	end
end

function PetUpgrade.initPetUpgradeUI(arg_30_0)
	if not get_cocos_refid(arg_30_0.vars.dlg) then
		return 
	end
	
	arg_30_0.vars.ui = {}
	arg_30_0.vars.ui.pet_food_btn = {}
	arg_30_0.vars.ui.pet_food_slot = {}
	
	local var_30_0 = arg_30_0.vars.dlg:getChildByName("RIGHT")
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.pet_food_data_list) do
		local var_30_1 = false
		
		if string.find(iter_30_1.id, "ma_petpoint") then
			var_30_1 = true
		end
		
		if get_cocos_refid(var_30_0) then
			local var_30_2 = var_30_0:getChildByName("btn_petfood" .. iter_30_0)
			local var_30_3 = Account:getItemCount(iter_30_1.id)
			
			if_set_opacity(var_30_2, nil, var_30_3 > 0 and 255 or 76.5)
			UIUtil:getRewardIcon(nil, iter_30_1.id, {
				show_name = false,
				tooltip_delay = 130,
				scale = 0.9,
				parent = var_30_2:getChildByName("n_pet"),
				grade = iter_30_1.grade,
				use_drop_icon = var_30_1
			})
			if_set(var_30_2, "t_up", T(iter_30_1.id .. "_name"))
			if_set(var_30_2, "t_exp", "+" .. comma_value(iter_30_1.get_xp))
			
			local var_30_4 = var_30_2:getChildByName("n_count")
			
			if get_cocos_refid(var_30_4) then
				if_set(var_30_4, "t_have", T("ui_alchemy_catalyst_have_txt"))
				if_set(var_30_4, "t_count", var_30_3)
				if_set_visible(var_30_4, "t_count", var_30_3 > 0)
				if_set_visible(var_30_4, "t_count_selected", false)
				if_set(var_30_4, "t_none", T("ui_levelup_card_none"))
				if_set_visible(var_30_4, "t_none", var_30_3 == 0)
			end
			
			arg_30_0.vars.ui.pet_food_btn[iter_30_0] = var_30_2
		end
		
		local var_30_5 = arg_30_0.vars.dlg:getChildByName("CENTER")
		
		if get_cocos_refid(var_30_5) then
			local var_30_6 = var_30_5:getChildByName("slot" .. iter_30_0)
			
			UIUtil:getRewardIcon(nil, iter_30_1.id, {
				show_name = false,
				tooltip_delay = 130,
				scale = 0.9,
				parent = var_30_6:getChildByName("n_pet"),
				grade = iter_30_1.grade,
				use_drop_icon = var_30_1
			})
			if_set(var_30_6, "txt_value", 0)
			if_set_opacity(var_30_6, nil, 76.5)
			
			arg_30_0.vars.ui.pet_food_slot[iter_30_0] = var_30_6
		end
	end
	
	if get_cocos_refid(var_30_0) then
		arg_30_0.vars.ui.auto_fill_btn = var_30_0:getChildByName("btn_auto")
		
		local var_30_7 = arg_30_0:getAllPetFoodCount()
		
		if_set_opacity(arg_30_0.vars.ui.auto_fill_btn, nil, var_30_7 > 0 and 255 or 76.5)
	end
	
	arg_30_0:setButtonState(true)
	arg_30_0:updateAllPetFoodCount()
end

function PetUpgrade.getAllPetFoodCount(arg_31_0)
	if not arg_31_0.vars then
		return 0
	end
	
	local var_31_0 = 0
	local var_31_1 = Account:getPetFoods()
	
	for iter_31_0, iter_31_1 in pairs(var_31_1) do
		var_31_0 = var_31_0 + iter_31_1.count
	end
	
	return var_31_0
end

function PetUpgrade.setPetInfos(arg_32_0, arg_32_1)
	arg_32_0:updatePetInfos(arg_32_1)
	
	local var_32_0 = UIUtil:getPetModel(arg_32_1)
	
	arg_32_0.vars.dlg:findChildByName("n_pos"):removeAllChildren()
	arg_32_0.vars.dlg:findChildByName("n_pos"):addChild(var_32_0)
	
	arg_32_0.vars.model = var_32_0
	arg_32_0.vars.pet = arg_32_1
	
	TopBarNew:setTitleName(arg_32_0.vars.pet:getName(), "infopet_2")
	arg_32_0:updatePetIncInfos()
end

function PetUpgrade.isCanAddToPetFood(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not arg_33_1 then
		return false
	end
	
	if table.empty(arg_33_0.vars.registered_pet_foods) then
		return false
	end
	
	if arg_33_0.vars.registered_pet_foods[arg_33_1].count >= Account:getItemCount(arg_33_1) then
		balloon_message_with_sound("pet_need_x")
		
		return false
	end
	
	if arg_33_0:getEnhanceInfo():isMaxLevel() then
		balloon_message_with_sound("ui_pet_upgrade_already_max")
		
		return false
	end
	
	return true
end

function PetUpgrade.isEmptyPetFoodList(arg_34_0)
	if not arg_34_0.vars or table.empty(arg_34_0.vars.registered_pet_foods) then
		return true
	end
	
	for iter_34_0, iter_34_1 in pairs(arg_34_0.vars.registered_pet_foods) do
		if iter_34_1.count > 0 then
			return false
		end
	end
	
	return true
end

function PetUpgrade.autoFillPetFoodList(arg_35_0)
	if not arg_35_0.vars or table.empty(arg_35_0.vars.pet_food_data_list) then
		return 
	end
	
	if arg_35_0:getAllPetFoodCount() == 0 then
		balloon_message_with_sound("pet_need_x")
		
		return 
	end
	
	if arg_35_0.vars.pet:isMaxLevel() then
		balloon_message_with_sound("ui_pet_upgrade_already_max")
		
		return 
	end
	
	arg_35_0:clearPetFoodList()
	
	local var_35_0 = table.clone(arg_35_0.vars.pet_food_data_list)
	
	table.reverse(var_35_0)
	
	local var_35_1
	local var_35_2 = false
	local var_35_3 = table.count(var_35_0)
	
	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		local var_35_4 = Account:getItemCount(iter_35_1.id)
		
		if var_35_4 > 0 then
			for iter_35_2 = 1, var_35_4 do
				local var_35_5 = arg_35_0.vars.registered_pet_foods[iter_35_1.id].count
				
				arg_35_0.vars.registered_pet_foods[iter_35_1.id].count = var_35_5 + 1
				var_35_2 = arg_35_0:getEnhanceInfo():isMaxLevel()
				
				if var_35_2 then
					break
				end
			end
		end
		
		local var_35_6 = var_35_3 - iter_35_0 + 1
		
		arg_35_0:updatePetFoodBtn(iter_35_1.id, var_35_6)
		arg_35_0:updatePetFoodSlot(iter_35_1.id, var_35_6)
		
		if var_35_2 then
			break
		end
	end
	
	arg_35_0:disableLvUp(true)
	arg_35_0:updatePetIncInfos()
end

function PetUpgrade.addPetFoodList(arg_36_0, arg_36_1)
	if not arg_36_0.vars or not arg_36_1 then
		return 
	end
	
	if table.empty(arg_36_0.vars.pet_food_data_list) or table.empty(arg_36_0.vars.registered_pet_foods) then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.pet_food_data_list[arg_36_1]
	
	if not arg_36_0:isCanAddToPetFood(var_36_0.id) then
		return 
	end
	
	local var_36_1 = arg_36_0.vars.registered_pet_foods[var_36_0.id].count
	
	arg_36_0.vars.registered_pet_foods[var_36_0.id].count = var_36_1 + 1
	
	arg_36_0:updatePetFoodBtn(var_36_0.id, arg_36_1)
	arg_36_0:updatePetFoodSlot(var_36_0.id, arg_36_1)
	arg_36_0:disableLvUp(true)
	arg_36_0:updatePetIncInfos()
end

function PetUpgrade.removePetFoodList(arg_37_0, arg_37_1)
	if not arg_37_0.vars or not arg_37_1 then
		return 
	end
	
	if table.empty(arg_37_0.vars.pet_food_data_list) or table.empty(arg_37_0.vars.registered_pet_foods) then
		return 
	end
	
	if arg_37_0.vars.pet:isMaxLevel() then
		return 
	end
	
	local var_37_0 = arg_37_0.vars.pet_food_data_list[arg_37_1]
	local var_37_1 = arg_37_0.vars.registered_pet_foods[var_37_0.id].count
	
	if var_37_1 <= 0 then
		return 
	end
	
	arg_37_0.vars.registered_pet_foods[var_37_0.id].count = var_37_1 - 1
	
	arg_37_0:updatePetFoodBtn(var_37_0.id, arg_37_1)
	arg_37_0:updatePetFoodSlot(var_37_0.id, arg_37_1)
	
	local var_37_2 = arg_37_0:isEmptyPetFoodList()
	
	if var_37_2 then
		arg_37_0:disableLvUp(not var_37_2)
	end
	
	arg_37_0:updatePetIncInfos()
end

function PetUpgrade.updateAllPetFoodCount(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.dlg) then
		return 
	end
	
	if not arg_38_0.vars.ui or not get_cocos_refid(arg_38_0.vars.ui.auto_fill_btn) then
		return 
	end
	
	local var_38_0 = arg_38_0:getAllPetFoodCount()
	
	if_set(arg_38_0.vars.dlg, "t_1_title", T("ui_pet_upgrade_item", {
		count = var_38_0
	}))
	if_set_opacity(arg_38_0.vars.ui.auto_fill_btn, nil, var_38_0 > 0 and 255 or 76.5)
end

function PetUpgrade.updatePetFoodBtn(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_0.vars or not arg_39_1 or not arg_39_2 then
		return 
	end
	
	if not arg_39_0.vars.ui or table.empty(arg_39_0.vars.ui.pet_food_btn) then
		return 
	end
	
	if table.empty(arg_39_0.vars.registered_pet_foods) then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.ui.pet_food_btn[arg_39_2]
	
	if get_cocos_refid(var_39_0) then
		local var_39_1 = var_39_0:getChildByName("n_count")
		
		if get_cocos_refid(var_39_1) then
			local var_39_2 = Account:getItemCount(arg_39_1)
			local var_39_3 = arg_39_0.vars.registered_pet_foods[arg_39_1].count
			
			if_set_opacity(var_39_0, nil, var_39_2 > 0 and 255 or 76.5)
			if_set(var_39_1, "t_count", var_39_2)
			if_set(var_39_1, "t_count_selected", var_39_2 - var_39_3 .. "(-" .. var_39_3 .. ")")
			if_set_visible(var_39_1, "t_count", var_39_3 == 0 and var_39_2 > 0)
			if_set_visible(var_39_1, "t_count_selected", var_39_3 > 0)
			if_set_visible(var_39_1, "t_none", var_39_2 == 0)
		end
	end
end

function PetUpgrade.updatePetFoodSlot(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.vars or not arg_40_1 or not arg_40_2 then
		return 
	end
	
	if not arg_40_0.vars.ui or table.empty(arg_40_0.vars.ui.pet_food_slot) then
		return 
	end
	
	if table.empty(arg_40_0.vars.registered_pet_foods) then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.ui.pet_food_slot[arg_40_2]
	
	if get_cocos_refid(var_40_0) then
		local var_40_1 = arg_40_0.vars.registered_pet_foods[arg_40_1].count
		
		if_set(var_40_0, "txt_value", var_40_1)
		if_set_opacity(var_40_0, nil, var_40_1 > 0 and 255 or 76.5)
	end
end

function PetUpgrade.clearPetFoodList(arg_41_0)
	if not arg_41_0.vars or not get_cocos_refid(arg_41_0.vars.dlg) then
		return 
	end
	
	if table.empty(arg_41_0.vars.pet_food_data_list) or table.empty(arg_41_0.vars.registered_pet_foods) then
		return 
	end
	
	local var_41_0 = arg_41_0.vars.pet_food_data_list
	local var_41_1 = arg_41_0.vars.registered_pet_foods
	
	for iter_41_0, iter_41_1 in pairs(var_41_0) do
		var_41_1[iter_41_1.id].count = 0
		
		arg_41_0:updatePetFoodBtn(iter_41_1.id, iter_41_0)
		arg_41_0:updatePetFoodSlot(iter_41_1.id, iter_41_0)
	end
	
	arg_41_0:disableLvUp(false)
	arg_41_0:updatePetIncInfos()
end

function PetUpgrade.slideIn(arg_42_0)
	local var_42_0 = arg_42_0.vars.dlg:findChildByName("LEFT")
	local var_42_1 = arg_42_0.vars.dlg:findChildByName("RIGHT")
	local var_42_2 = arg_42_0.vars.dlg:findChildByName("CENTER")
	
	var_42_0:setOpacity(0)
	var_42_1:setOpacity(0)
	var_42_2:setOpacity(0)
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_42_0, "block")
	UIAction:Add(SEQ(SLIDE_IN(200, -600)), var_42_1, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 600)), var_42_2, "block")
	if_set_visible(arg_42_0.vars.dlg, nil, true)
end

function PetUpgrade.slideOut(arg_43_0)
	local var_43_0 = arg_43_0.vars.dlg:findChildByName("LEFT")
	local var_43_1 = arg_43_0.vars.dlg:findChildByName("RIGHT")
	local var_43_2 = arg_43_0.vars.dlg:findChildByName("CENTER")
	
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_43_0, "block")
	UIAction:Add(SEQ(SLIDE_OUT(200, 600)), var_43_1, "block")
	UIAction:Add(SEQ(SLIDE_OUT_Y(200, -600)), var_43_2, "block")
	UIAction:Add(SEQ(DELAY(200), SHOW(false)), arg_43_0.vars.dlg, "block")
end
