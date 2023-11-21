UnitNewPromote = {}

function MsgHandler.exchange_elemental(arg_1_0)
	Account:addReward(arg_1_0.rewards, {
		buy = false,
		single = true,
		effect = true,
		no_check_condition = true
	})
	UnitNewPromote:updateResourceInfo()
end

function MsgHandler.upgrade_unit_via_elemental(arg_2_0)
	UnitNewPromote:doUpgrade(arg_2_0)
end

function HANDLER.unit_up(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_reset" then
		UnitNewPromote:resetResource()
		
		return 
	end
	
	if arg_3_1 == "btn_up" then
		UnitNewPromote:reqUpgrade()
		
		return 
	end
	
	if arg_3_1 == "btn_auto" then
		UnitNewPromote:autoResourceFill()
		
		return 
	end
	
	if string.starts(arg_3_1, "btn_spr") then
		local var_3_0 = tonumber(string.sub(arg_3_1, 8))
		
		UnitNewPromote:selectResource(var_3_0)
		
		return 
	end
end

function UnitNewPromote.create(arg_4_0)
	arg_4_0.vars = {}
	arg_4_0.vars.items = {}
	arg_4_0.vars.effects = {}
	arg_4_0.vars.controls = {}
	arg_4_0.vars.select_res = {}
	arg_4_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	arg_4_0.vars.wnd = load_dlg("unit_up", true, "wnd")
	
	arg_4_0:playBgEffect()
	TopBarNew:setDisableTopRight()
	
	return arg_4_0
end

function UnitNewPromote.getSceneState(arg_5_0)
	return {
		start_mode = "Detail",
		unit = arg_5_0.vars.unit
	}
end

function UnitNewPromote.autoResourceFill(arg_6_0)
	local var_6_0 = arg_6_0.vars.unit:getGrade() + 1
	local var_6_1, var_6_2 = DB("char_promotion_data", tostring(var_6_0), {
		"need_material",
		"value",
		"token",
		"price",
		"promotion_ui_icon"
	})
	
	if to_n(var_6_2) <= 0 then
		return 
	end
	
	for iter_6_0 = 1, 3 do
		local var_6_3 = DBN("char_promotion_combine", iter_6_0, {
			"id"
		})
		
		if var_6_3 == var_6_1 then
			if not Account:getPropertyCount(var_6_3) then
				local var_6_4 = 0
			end
			
			UnitNewPromote:selectResource(iter_6_0, var_6_2)
		end
	end
end

function UnitNewPromote.getMakeableMaterialCount(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0, var_7_1, var_7_2, var_7_3 = DB("char_promotion_combine", arg_7_1, {
		"need_material",
		"value",
		"token",
		"price"
	})
	
	if not var_7_0 then
		return 0
	end
	
	local var_7_4 = to_n(var_7_1)
	local var_7_5 = Account:getPropertyCount(var_7_0) or 0
	local var_7_6 = math.floor(var_7_5 / var_7_4)
	local var_7_7 = var_7_5 % var_7_4
	local var_7_8 = arg_7_2 - (var_7_6 + arg_7_4)
	local var_7_9 = 0
	
	if var_7_8 > 0 then
		table.insert(arg_7_3, {
			var_7_0,
			var_7_6 * var_7_4 + var_7_7,
			var_7_2,
			var_7_3
		})
		
		local var_7_10 = arg_7_0:getMakeableMaterialCount(var_7_0, var_7_8 * var_7_4 - var_7_7, arg_7_3, var_7_7)
		
		return var_7_6 + math.floor((var_7_10 + var_7_7) / var_7_4)
	elseif var_7_8 == 0 or var_7_6 <= arg_7_2 then
		table.insert(arg_7_3, {
			var_7_0,
			math.floor(var_7_6 * var_7_4),
			var_7_2,
			var_7_3
		})
		
		return var_7_6
	end
	
	if var_7_6 <= 0 then
		return 0
	end
	
	table.insert(arg_7_3, {
		var_7_0,
		math.floor(arg_7_2 * var_7_4),
		var_7_2,
		var_7_3
	})
	
	return arg_7_2
end

function UnitNewPromote.checkMaterial(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = Account:getPropertyCount(arg_8_1) or 0
	local var_8_1 = arg_8_2 - var_8_0
	local var_8_2 = {}
	
	if var_8_1 > 0 then
		if arg_8_2 <= arg_8_0:getMakeableMaterialCount(arg_8_1, var_8_1, var_8_2, 0) + var_8_0 then
			return true, var_8_2
		end
		
		return false, var_8_2
	end
	
	return true, false
end

function UnitNewPromote.selectResource(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2 or 1
	local var_9_1 = arg_9_0.vars.unit:getGrade() + 1
	local var_9_2, var_9_3, var_9_4, var_9_5 = DB("char_promotion_data", tostring(var_9_1), {
		"need_material",
		"value",
		"token",
		"price"
	})
	local var_9_6 = DBN("char_promotion_combine", arg_9_1, {
		"id"
	})
	
	if var_9_6 ~= var_9_2 then
		return 
	end
	
	local var_9_7 = DB("item_material", var_9_6, {
		"name"
	})
	local var_9_8 = Account:getPropertyCount(var_9_6) or 0
	local var_9_9 = to_n(arg_9_0.vars.select_res[arg_9_1])
	
	if var_9_9 >= to_n(var_9_3) then
		return 
	end
	
	if var_9_8 < var_9_9 + var_9_0 then
		var_9_0 = var_9_8 - var_9_9
		
		local var_9_10, var_9_11 = arg_9_0:checkMaterial(var_9_2, to_n(var_9_3))
		
		if var_9_11 then
			if var_9_10 then
				local var_9_12 = load_dlg("item_change_popup2", true, "wnd")
				
				if_set(var_9_12, "txt_title_", T("ui_promotion_auto_combine_title"))
				if_set(var_9_12, "txt_desc_", T("ui_promotion_auto_combine_desc", {
					name = arg_9_0.vars.unit:getName(),
					num = var_9_1,
					item = T(var_9_7),
					count = math.max(0, to_n(var_9_3) - (var_9_9 + var_9_0))
				}))
				
				for iter_9_0 = table.count(var_9_11), 1, -1 do
					local var_9_13 = var_9_11[iter_9_0]
					
					if var_9_13 and var_9_13[2] <= 0 then
						table.remove(var_9_11, iter_9_0)
					end
				end
				
				local var_9_14 = math.clamp(table.count(var_9_11), 1, 2)
				
				if var_9_14 == 2 then
					local var_9_15 = var_9_12:getChildByName("window_frame")
					
					var_9_15:setPositionY(var_9_15:getPositionY() + 50)
					
					for iter_9_1, iter_9_2 in pairs(var_9_15:getChildren()) do
						iter_9_2:setPositionY(iter_9_2:getPositionY() + 92)
					end
					
					var_9_15:setContentSize(var_9_15:getContentSize().width, var_9_15:getContentSize().height + 92)
					
					local var_9_16 = var_9_12:getChildByName("n_buttons2_move")
					
					var_9_12:getChildByName("n_buttons"):setPosition(var_9_16:getPosition())
				end
				
				local var_9_17 = var_9_12:getChildByName("n_item_change" .. var_9_14)
				
				var_9_17:setVisible(true)
				
				for iter_9_3, iter_9_4 in pairs(var_9_11) do
					local var_9_18 = ""
					
					if iter_9_3 > 1 then
						var_9_18 = tostring(iter_9_3)
					end
					
					local var_9_19 = var_9_17:getChildByName("reward_item" .. var_9_18)
					local var_9_20 = {
						show_name = true,
						detail = true,
						parent = var_9_19
					}
					local var_9_21 = UIUtil:getRewardIcon(iter_9_4[2], iter_9_4[1], var_9_20):getChildByName("txt_type")
					
					if get_cocos_refid(var_9_21) then
						UIUserData:call(var_9_21, "SINGLE_WSCALE(180)")
					end
				end
				
				local var_9_22 = {
					show_name = true,
					detail = true,
					parent = var_9_17:getChildByName("result_item")
				}
				local var_9_23 = UIUtil:getRewardIcon(to_n(var_9_3) - var_9_8, var_9_2, var_9_22):getChildByName("txt_type")
				
				if get_cocos_refid(var_9_23) then
					UIUserData:call(var_9_23, "SINGLE_WSCALE(180)")
				end
				
				Dialog:msgBox(nil, {
					yesno = true,
					title = T("ui_promotion_auto_combine_title"),
					dlg = var_9_12,
					handler = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
						if arg_10_1 == "btn_yes" then
							query("exchange_elemental", {
								combine_target = var_9_2,
								combine_info = array_to_json(var_9_11)
							})
						elseif arg_10_1 == "btn_block" then
							return "dont_close"
						end
					end
				})
			elseif SceneManager:getCurrentSceneName() ~= "sanctuary" then
				local var_9_24 = load_dlg("shop_nocurrency", true, "wnd")
				
				if_set(var_9_24, "txt_shop_comment", T("ui_promotion_move_spirit_desc_2"))
				
				local var_9_25 = {
					show_name = true,
					detail = true,
					parent = var_9_24:getChildByName("n_item_pos")
				}
				local var_9_26 = UIUtil:getRewardIcon(1, var_9_6, var_9_25)
				
				Dialog:msgBox(T("ui_promotion_move_spirit_desc_1", {
					name = arg_9_0.vars.unit:getName(),
					num = var_9_1,
					item = T(var_9_7),
					count = math.max(0, to_n(var_9_3) - (var_9_9 + var_9_0))
				}), {
					yesno = true,
					title = T("ui_promotion_move_spirit_title"),
					dlg = var_9_24,
					handler = function()
						local var_11_0 = DB("sanctuary_upgrade", "forest_0_0", "system")
						
						UnlockSystem:isUnlockSystemAndMsg({
							exclude_story = true,
							id = var_11_0
						}, function()
							SceneManager:nextScene("sanctuary", {
								show_alter_popup = true,
								mode = "Forest"
							})
						end)
					end
				})
			end
			
			return 
		end
	end
	
	if var_9_3 < var_9_9 + var_9_0 then
		var_9_0 = var_9_3 - var_9_9
	end
	
	arg_9_0.vars.select_res[arg_9_1] = var_9_9 + var_9_0
	
	arg_9_0:updateResourceInfo()
	arg_9_0:playSelectEffect()
end

function UnitNewPromote.resetResource(arg_13_0)
	arg_13_0.vars.select_res = {}
	
	arg_13_0:updateResourceInfo()
end

function UnitNewPromote.playFullEffect(arg_14_0, arg_14_1)
	if not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("n_eff_star")
	
	if not get_cocos_refid(var_14_0) then
		return 
	end
	
	local var_14_1 = var_14_0:getContentSize()
	
	if arg_14_0.vars.full_eff then
		arg_14_0.vars.full_eff:removeFromParent()
		
		arg_14_0.vars.full_eff = nil
	end
	
	if arg_14_1 then
		arg_14_0.vars.full_eff = EffectManager:Play({
			pivot_x = 0,
			fn = "uieff_char_promotion_star.cfx",
			pivot_y = 0,
			pivot_z = 0,
			scale = 1,
			layer = var_14_0
		})
	end
end

function UnitNewPromote.playSelectEffect(arg_15_0)
	if not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_eff_star")
	
	if not get_cocos_refid(var_15_0) then
		return 
	end
	
	EffectManager:Play({
		pivot_x = 0,
		fn = "ui_unit_level_up_penguin.cfx",
		pivot_y = 0,
		pivot_z = 0,
		scale = 1.2,
		layer = var_15_0
	})
end

function UnitNewPromote.updateResourceInfo(arg_16_0)
	local var_16_0 = arg_16_0.vars.unit:getGrade() + 1
	local var_16_1, var_16_2, var_16_3, var_16_4, var_16_5 = DB("char_promotion_data", tostring(var_16_0), {
		"need_material",
		"value",
		"token",
		"price",
		"promotion_ui_icon"
	})
	local var_16_6 = arg_16_0.vars.wnd:getChildByName("btn_up")
	
	if var_16_5 then
		if_set_sprite(arg_16_0.vars.wnd, "item_icon", "img/" .. var_16_5 .. ".png")
		if_set_visible(arg_16_0.vars.wnd, "n_item_slot", true)
	else
		if_set_visible(arg_16_0.vars.wnd, "n_item_slot", false)
	end
	
	for iter_16_0 = 1, 3 do
		local var_16_7 = arg_16_0.vars.wnd:getChildByName("btn_spr" .. iter_16_0)
		local var_16_8 = var_16_7:getChildByName("reward_item" .. iter_16_0)
		local var_16_9 = DBN("char_promotion_combine", iter_16_0, {
			"id"
		})
		local var_16_10 = DB("item_material", var_16_9, {
			"name"
		})
		local var_16_11 = {
			parent = var_16_8
		}
		local var_16_12 = UIUtil:getRewardIcon(1, var_16_9, var_16_11)
		local var_16_13 = Account:getPropertyCount(var_16_9) or 0
		
		if_set(var_16_7, "t_exp", T(var_16_10))
		if_set_visible(var_16_7, "t_none", var_16_13 <= 0)
		
		local var_16_14 = to_n(arg_16_0.vars.select_res[iter_16_0])
		local var_16_15 = var_16_14 > 0
		local var_16_16 = var_16_14 > 0 and "(-" .. tostring(var_16_14) .. ")" or ""
		
		if var_16_13 > 0 then
			if_set_visible(var_16_7, "t_count", not var_16_15)
			if_set_visible(var_16_7, "t_count_selected", var_16_15)
			if_set(var_16_7, var_16_15 and "t_count_selected" or "t_count", T("ui_promotion_elemental_count_value", {
				num = string.format("%d%s", math.max(0, var_16_13 - var_16_14), var_16_16)
			}))
		else
			if_set_visible(var_16_7, "t_count", false)
			if_set_visible(var_16_7, "t_count_selected", false)
		end
		
		if var_16_9 == var_16_1 then
			if var_16_14 > 0 then
				if_set(var_16_6, "cost", comma_value(to_n(var_16_4)))
			else
				if_set(var_16_6, "cost", 0)
			end
			
			if_set(arg_16_0.vars.wnd, "t_item_name", T(var_16_10))
			if_set(arg_16_0.vars.wnd, "t_count_item", var_16_14 .. "/" .. var_16_2)
			var_16_7:setOpacity(255)
			
			local var_16_17 = var_16_2 <= var_16_14
			
			if_set_opacity(arg_16_0.vars.wnd, "btn_up", var_16_17 and 255 or 76)
			arg_16_0:playFullEffect(var_16_17)
		else
			var_16_7:setOpacity(76)
		end
	end
	
	if not var_16_1 then
		if_set_visible(arg_16_0.vars.wnd, "n_item_slot", false)
		if_set_visible(arg_16_0.vars.wnd, "n_buttons", false)
		
		return 
	end
	
	if_set_visible(arg_16_0.vars.wnd, "n_item_slot", true)
	if_set_visible(arg_16_0.vars.wnd, "n_buttons", true)
end

function UnitNewPromote.playBgEffect(arg_17_0)
	if arg_17_0.vars.eff_bg then
		arg_17_0.vars.eff_bg:removeFromParent()
	end
	
	local var_17_0 = UnitMain.vars.base_wnd:getChildByName("eff_pos")
	
	arg_17_0.vars.eff_bg = EffectManager:Play({
		pivot_x = 0,
		fn = "hero_enchant_circle.cfx",
		pivot_y = 0,
		pivot_z = -10,
		scale = 1,
		layer = var_17_0
	})
end

function UnitNewPromote.onEnter(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_2.unit
	
	arg_18_0:create()
	
	arg_18_0.vars.start_unit = var_18_0
	
	arg_18_0.vars.wnd:setLocalZOrder(1)
	UnitMain.vars.base_wnd:addChild(arg_18_0.vars.wnd)
	UIAction:Add(SEQ(COLOR(0, 187, 0, 200), FADE_IN(200)), UnitMain.vars.base_wnd:getChildByName("TOP"), "block")
	arg_18_0.vars.wnd:getChildByName("n_add_exp"):setVisible(false)
	arg_18_0:onSelectTargetUnit(var_18_0)
	arg_18_0:updateResourceInfo()
	TopBarNew:checkhelpbuttonID("growth_1_2")
	SoundEngine:play("event:/ui/unit_upgrade/enter")
end

function UnitNewPromote.isVisible(arg_19_0)
	return arg_19_0.vars and arg_19_0.vars.wnd and get_cocos_refid(arg_19_0.vars.wnd)
end

function UnitNewPromote.updateBaseUnitInfo(arg_20_0, arg_20_1, arg_20_2)
	UIUtil:setUnitAllInfo(arg_20_2 or arg_20_0.vars.wnd, arg_20_1 or arg_20_0.vars.unit, {
		base = true
	})
end

function UnitNewPromote.isPromote(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_2 then
		return false
	end
	
	if #arg_21_2 ~= arg_21_1 then
		for iter_21_0, iter_21_1 in pairs(arg_21_2 or {}) do
			if not arg_21_0.vars.unit:isDevotionUpgradable(iter_21_1) then
				return false
			end
		end
		
		return true
	end
	
	return false
end

function UnitNewPromote.getEnhanceInfo(arg_22_0, arg_22_1)
	if not arg_22_0.vars.unit then
		return nil, 0, 0
	end
	
	local var_22_0 = 0
	local var_22_1 = 0
	local var_22_2 = 0
	local var_22_3 = false
	
	if arg_22_1 == "Promote" then
		var_22_0 = ({
			5000,
			10000,
			20000,
			40000,
			150000,
			99999999
		})[arg_22_0.vars.unit.inst.grade]
		var_22_3 = arg_22_0:isPromote(arg_22_0.vars.unit.inst.grade, arg_22_0.vars.items)
	end
	
	if arg_22_1 ~= "Promote" or var_22_3 then
		var_22_0 = 0
		
		for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.items) do
			var_22_0 = var_22_0 + iter_22_1:getEnhancePrice()
			
			local var_22_4 = iter_22_1:getEnhanceExp(arg_22_0.vars.unit)
			
			var_22_1 = var_22_1 + (var_22_4 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.ENHANCE_HERO_EXP, var_22_4))
		end
	end
	
	local var_22_5 = arg_22_0.vars.unit:getDevoteCountFromUnits(arg_22_0.vars.items)
	local var_22_6 = arg_22_0.vars.unit:clone()
	
	if arg_22_0.vars.unit:isMaxLevel() then
		local var_22_7 = 0
		
		for iter_22_2, iter_22_3 in pairs(arg_22_0.vars.items) do
			if iter_22_3:getGrade() ~= arg_22_0.vars.unit:getGrade() then
				var_22_7 = var_22_7 + 1
			end
		end
		
		var_22_6.inst.grade = var_22_6.inst.grade
		
		if arg_22_1 == "Promote" then
			var_22_6.inst.grade = math.min(6, var_22_6.inst.grade + 1)
		else
			var_22_6.inst.grade = var_22_6.inst.grade
		end
	end
	
	var_22_6.inst.devote = var_22_6.inst.devote + var_22_5
	
	var_22_6:reset()
	var_22_6:calc(true)
	
	local var_22_8, var_22_9 = var_22_6:getExpString()
	
	arg_22_0.vars.total_price = var_22_0
	
	return var_22_6, var_22_0, var_22_1, var_22_9
end

function UnitNewPromote.updateUpgradeInfo(arg_23_0, arg_23_1)
	local var_23_0, var_23_1, var_23_2, var_23_3 = arg_23_0:getEnhanceInfo(arg_23_0:getEnhanceMode())
	local var_23_4 = arg_23_0.vars.unit:getExpString(var_23_2)
	
	if_set(arg_23_0.vars.wnd, "cost", comma_value(var_23_1))
	UIUtil:setUnitAllInfo(arg_23_0.vars.wnd, var_23_0, {
		pre = "up_",
		base = true,
		reverse_upgrade_star = arg_23_1
	})
	
	if DEBUG.OLD_PROMOTION_RULE then
		if_set_visible(arg_23_0.vars.wnd, "n_exp_bar", not arg_23_0.vars.unit:isMaxLevel() and not arg_23_0.vars.unit:isPromotionUnit())
	end
	
	if not arg_23_0.vars.unit:isMaxLevel() then
		if_set(arg_23_0.vars.wnd, "label_up", "+" .. var_23_0.inst.lv - arg_23_0.vars.unit.inst.lv)
		
		if var_23_0.inst.lv > arg_23_0.vars.unit.inst.lv then
			arg_23_0.vars.wnd:getChildByName("up_exp_gauge"):setPercent(100)
		end
	end
	
	if_set_visible(arg_23_0.vars.wnd, "upgrade", not arg_23_0.vars.unit:isMaxLevel())
	
	local var_23_5 = cc.c4b(255, 120, 0)
	local var_23_6 = cc.c4b(60, 120, 220)
	
	if_set_visible(arg_23_0.vars.wnd, "n_upgrade", arg_23_0:getEnhanceMode() == "Promote")
	
	local var_23_7 = arg_23_0.vars.unit.inst.lv < 60 or arg_23_0.vars.unit:getGrade() < 6 or Account:getSameUnitCount(arg_23_0.vars.unit) > 1
	
	if DEBUG.OLD_PROMOTION_RULE and arg_23_0.vars.unit:isPromotionUnit() then
		var_23_7 = arg_23_0.vars.unit:isMaxLevel()
	end
	
	if_set_visible(arg_23_0.vars.wnd, "n_buttons", var_23_7)
	if_set_visible(arg_23_0.vars.wnd, "n_slots", var_23_7)
	if_set_visible(arg_23_0.vars.wnd, "n_exp_bar", var_23_7)
	if_set(arg_23_0.vars.wnd, "txt_exp", "exp " .. var_23_4)
	
	for iter_23_0 = 0, 13 do
		local var_23_8 = arg_23_0.vars.wnd:getChildByName("img_stat_up_" .. string.format("%02d", iter_23_0))
		local var_23_9 = arg_23_0.vars.wnd:getChildByName(string.format("txt_stat%02d", iter_23_0))
		local var_23_10 = arg_23_0.vars.wnd:getChildByName(string.format("up_txt_stat%02d", iter_23_0))
		
		if var_23_9 and var_23_10 then
			if var_23_9:getString() ~= var_23_10:getString() then
				local var_23_11 = to_n(string.gsub(string.gsub(string.gsub(var_23_9:getString(), ",", ""), "%%", ""), "+", ""))
				local var_23_12 = to_n(string.gsub(string.gsub(string.gsub(var_23_10:getString(), ",", ""), "%%", ""), "+", ""))
				local var_23_13 = var_23_5
				
				if var_23_12 < var_23_11 then
					var_23_13 = var_23_6
				end
				
				var_23_8:setVisible(true)
				var_23_10:setVisible(true)
				var_23_8:setColor(var_23_13)
				var_23_10:setTextColor(var_23_13)
				
				if iter_23_0 == 10 then
					var_23_8:setVisible(false)
					var_23_10:setVisible(false)
				end
			else
				if_set_visible(arg_23_0.vars.wnd, "img_stat_up_" .. string.format("%02d", iter_23_0), false)
				var_23_10:setVisible(false)
			end
		end
	end
	
	if_set_visible(arg_23_0.vars.wnd, "arrow_lv", arg_23_0.vars.unit:getLv() ~= var_23_0:getLv())
	if_set_visible(arg_23_0.vars.wnd, "n_lv_up", arg_23_0.vars.unit:getLv() ~= var_23_0:getLv())
	UIUtil:setLevel(arg_23_0.vars.wnd:getChildByName("n_lv"), arg_23_0.vars.unit:getLv(), nil, 2)
	
	if arg_23_0.vars.unit:getLv() ~= var_23_0:getLv() then
		UIUtil:setLevel(arg_23_0.vars.wnd:getChildByName("n_lv_up"), var_23_0:getLv(), nil, 2)
	end
	
	if_set_visible(arg_23_0.vars.wnd, "node_upgrade", var_23_0:getPoint(var_23_0:getCharacterStatus()) ~= arg_23_0.vars.unit:getPoint(arg_23_0.vars.unit:getCharacterStatus()))
	
	if arg_23_0:getEnhanceMode() == "Promote" then
		if_set(arg_23_0.vars.wnd, "txt_enhance", T("promote"))
	else
		if_set(arg_23_0.vars.wnd, "txt_enhance", T("ui_memorize_clear_title"))
	end
	
	local var_23_14, var_23_15 = arg_23_0.vars.unit:getDevoteSkill()
	
	if not var_23_15 then
		if_set_visible(arg_23_0.vars.wnd, "n_dedi_stat", false)
		if_set_visible(arg_23_0.vars.wnd, "n_dedi_stat_up", false)
	elseif to_n(var_23_15) >= 0 then
		if_set_visible(arg_23_0.vars.wnd, "n_dedi_stat", true)
		UIUtil:setDevoteDetail_new(arg_23_0.vars.wnd, arg_23_0.vars.unit, {
			target = "n_dedi_stat"
		})
		
		local var_23_16, var_23_17 = var_23_0:getDevoteSkill()
		
		if var_23_17 == 0 or var_23_15 == var_23_17 then
			if_set_visible(arg_23_0.vars.wnd, "n_dedi_stat_up", false)
		else
			if_set_visible(arg_23_0.vars.wnd, "n_dedi_stat_up", true)
			UIUtil:setDevoteDetail_new(arg_23_0.vars.wnd, var_23_0, {
				target = "n_dedi_stat_up"
			})
		end
		
		local var_23_18, var_23_19 = arg_23_0.vars.unit:getDevoteGrade()
	end
	
	local var_23_20 = arg_23_0.vars.wnd:getChildByName("n_up_reward")
	local var_23_21
	
	if get_cocos_refid(var_23_20) then
		var_23_21 = {}
		
		for iter_23_1, iter_23_2 in pairs(arg_23_0.vars.items or {}) do
			local var_23_22 = iter_23_2:getGrade()
			local var_23_23, var_23_24 = DB("char_memory_imprint_reward", tostring(var_23_22), {
				"reward_id",
				"value"
			})
			
			if var_23_23 and to_n(var_23_24) > 0 then
				var_23_21[var_23_23] = to_n(var_23_21[var_23_23]) + to_n(var_23_24)
			end
		end
		
		for iter_23_3 = 1, 3 do
			local var_23_25 = var_23_20:getChildByName("icon_up_r" .. iter_23_3)
			local var_23_26 = "ma_elemental_" .. iter_23_3
			
			if var_23_25 then
				UIUtil:getRewardIcon(nil, var_23_26, {
					no_bg = true,
					parent = var_23_25
				})
			end
			
			if_set(var_23_20, "txt_count" .. iter_23_3, to_n(var_23_21[var_23_26]))
		end
	end
end

function UnitNewPromote.onSelectTargetUnit(arg_24_0, arg_24_1)
	arg_24_0.vars.unit = arg_24_1
	
	if arg_24_1 then
		UnitMain:removePortrait()
		UnitMain:changePortrait(arg_24_1, true)
		arg_24_0:showUpgradePanels(true)
		arg_24_0:updateBaseUnitInfo()
		arg_24_0:updateUpgradeInfo(true)
	else
		if_set_visible(arg_24_0.vars.wnd, "LEFT", false)
		if_set_visible(arg_24_0.vars.wnd, "RIGHT", false)
	end
	
	if_set_visible(arg_24_0.vars.wnd, "n_select_target_unit", arg_24_0.vars.unit == nil)
end

function UnitNewPromote.showUpgradePanels(arg_25_0, arg_25_1)
	if arg_25_1 then
		if_set_visible(arg_25_0.vars.wnd, "LEFT", true)
		if_set_visible(arg_25_0.vars.wnd, "CENTER", true)
		if_set_visible(arg_25_0.vars.wnd, "RIGHT", true)
		UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_25_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_IN(200, -600)), arg_25_0.vars.wnd:getChildByName("RIGHT"), "block")
		UIAction:Add(SEQ(SLIDE_IN_Y(200, 1200)), arg_25_0.vars.wnd:getChildByName("CENTER"), "block")
		arg_25_0.vars.wnd:getChildByName("LEFT"):setOpacity(0)
		arg_25_0.vars.wnd:getChildByName("CENTER"):setOpacity(0)
	else
		UIAction:Add(SEQ(SLIDE_OUT(200, -600)), arg_25_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_OUT(200, 600)), arg_25_0.vars.wnd:getChildByName("RIGHT"), "block")
		UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_25_0.vars.wnd:getChildByName("CENTER"), "block")
	end
end

function UnitNewPromote.reqUpgrade(arg_26_0)
	local var_26_0 = arg_26_0.vars.unit:getGrade() + 1
	local var_26_1, var_26_2, var_26_3, var_26_4, var_26_5 = DB("char_promotion_data", tostring(var_26_0), {
		"need_material",
		"value",
		"token",
		"price",
		"promotion_ui_icon"
	})
	local var_26_6 = 0
	
	for iter_26_0 = 1, 3 do
		if var_26_1 == DBN("char_promotion_combine", iter_26_0, {
			"id"
		}) then
			var_26_6 = to_n(arg_26_0.vars.select_res[iter_26_0])
		end
	end
	
	if var_26_6 < to_n(var_26_2) then
		balloon_message_with_sound("ui_char_promotion_btn_confirm_info")
		
		return 
	end
	
	local var_26_7 = arg_26_0.vars.unit:getPoint()
	local var_26_8 = arg_26_0.vars.unit:clone()
	
	var_26_8.inst.grade = var_26_0
	
	var_26_8:calc()
	
	local var_26_9 = var_26_8:getPoint()
	
	query("upgrade_unit_via_elemental", {
		target = arg_26_0.vars.unit:getUID(),
		begin_point = var_26_7,
		after_point = var_26_9
	})
end

function UnitNewPromote.doUpgrade(arg_27_0, arg_27_1)
	SoundEngine:play("event:/ui/hero_grow_02_levelup")
	
	local var_27_0 = 400
	
	if arg_27_0.vars.unit:isPromotionEffectSimple() then
		var_27_0 = 200
	end
	
	local var_27_1 = 70
	
	UIAction:Add(SEQ(DELAY(var_27_0), SPAWN(SEQ(LOG(BLEND(500, "white", 0, 1), 100), DELAY(600), RLOG(BLEND(200, "white", 1, 0), 100), LOG(BLEND(0))), CALL(UnitNewPromote.playBgEffect, arg_27_0), SHAKE_UI(1100, 10), SEQ(LOG(SCALE(500, 0.8, 0.85)), DELAY(600), CALL(UnitMain.playPortraitWhiteEffect, UnitMain, arg_27_0.vars.unit, true), CALL(UnitNewPromote.procUpgrade, arg_27_0, arg_27_1), RLOG(SCALE(100, 0.8, 0.75)), RLOG(SCALE(100, 0.75, 0.8))))), UnitMain:getPortrait(), "block")
	
	local var_27_2 = arg_27_0.vars.unit:isPromotionEffectSimple() and 200 or 400
	
	UIAction:AddSync(DELAY(var_27_2 + 1100), arg_27_0, "block")
end

function UnitNewPromote.showPromoteRewardPopup(arg_28_0)
	local var_28_0 = arg_28_0.vars.unit:clone()
	
	var_28_0:calc()
	
	local var_28_1 = var_28_0:getCharacterStatus()
	local var_28_2 = var_28_0:clone()
	
	var_28_2.inst.grade = var_28_0.inst.grade - 1
	
	var_28_2:calc()
	
	local var_28_3 = var_28_2:getCharacterStatus()
	local var_28_4 = load_dlg("dlg_promote_reward_stat", true, "wnd")
	
	Dialog:msgBox({
		delay = 0,
		fade_in = 500,
		dont_proc_tutorial = true,
		dlg = var_28_4,
		title = T("promotion_up_title")
	})
	if_set(var_28_4, "txt_stat_name0", T("promote_stat_maxlv"))
	if_set(var_28_4, "txt_stat0_before", var_28_2:getMaxLevel())
	if_set(var_28_4, "txt_stat0", var_28_0:getMaxLevel())
	
	local var_28_5 = var_28_0:getMaxLevel() - var_28_2:getMaxLevel()
	
	if_set_visible(var_28_4, "diff_icon", var_28_5 ~= 0)
	if_set(var_28_4, "txt_diff0", var_28_5)
	if_set_sprite(var_28_4, "stat_icon1", "img/cm_icon_etcbp.png")
	if_set(var_28_4, "txt_stat_name1", T("unit_power"))
	if_set(var_28_4, "txt_stat1_before", var_28_2:getPoint())
	if_set(var_28_4, "txt_stat1", var_28_0:getPoint())
	
	local var_28_6 = var_28_0:getPoint() - var_28_2:getPoint()
	
	if_set_visible(var_28_4, "diff_icon1", var_28_6 ~= 0)
	if_set(var_28_4, "txt_diff1", var_28_6)
	if_set_sprite(var_28_4, "stat_icon2", "img/cm_icon_stat_att.png")
	if_set(var_28_4, "txt_stat_name2", getStatName("att"))
	if_set(var_28_4, "txt_stat2_before", var_28_3.att)
	if_set(var_28_4, "txt_stat2", var_28_1.att)
	
	local var_28_7 = var_28_1.att - var_28_3.att
	
	if_set_visible(var_28_4, "diff_icon2", var_28_7 ~= 0)
	if_set(var_28_4, "txt_diff2", var_28_7)
	if_set_sprite(var_28_4, "stat_icon3", "img/cm_icon_stat_def.png")
	if_set(var_28_4, "txt_stat_name3", getStatName("def"))
	if_set(var_28_4, "txt_stat3_before", var_28_3.def)
	if_set(var_28_4, "txt_stat3", var_28_1.def)
	
	local var_28_8 = var_28_1.def - var_28_3.def
	
	if_set_visible(var_28_4, "diff_icon3", var_28_8 ~= 0)
	if_set(var_28_4, "txt_diff3", var_28_8)
	if_set_sprite(var_28_4, "stat_icon4", "img/cm_icon_stat_max_hp.png")
	if_set(var_28_4, "txt_stat_name4", getStatName("max_hp"))
	if_set(var_28_4, "txt_stat4_before", var_28_3.max_hp)
	if_set(var_28_4, "txt_stat4", var_28_1.max_hp)
	
	local var_28_9 = var_28_1.max_hp - var_28_3.max_hp
	
	if_set_visible(var_28_4, "diff_icon4", var_28_9 ~= 0)
	if_set_diff(var_28_4, "txt_diff4", var_28_9)
end

function UnitNewPromote.clipUnitList(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not arg_29_0.vars.hero_belt then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.hero_belt:getWindow()
	local var_29_1
	local var_29_2
	local var_29_3
	
	if arg_29_1 then
		var_29_1 = arg_29_0.vars.wnd:getChildByName("n_herolist")
		var_29_2 = arg_29_0.vars.wnd:getChildByName("n_sorting")
		var_29_3 = arg_29_0.vars.wnd:getChildByName("add_inven")
	else
		var_29_1 = UnitMain.vars.base_wnd
		var_29_2 = var_29_0:getChildByName("n_sorting")
		var_29_3 = var_29_0:getChildByName("add_inven")
	end
	
	var_29_0:ejectFromParent()
	var_29_1:addChild(var_29_0)
	arg_29_0.vars.hero_belt:changeSorterParent(var_29_2, true)
	arg_29_0.vars.hero_belt:changeCountParent(var_29_3)
	arg_29_0.vars.hero_belt:updateHeroCount()
end

function UnitNewPromote.onLeave(arg_30_0, arg_30_1)
	arg_30_0:clipUnitList(false)
	arg_30_0:showUpgradePanels(false)
	UIAction:Add(FADE_OUT(200), UnitMain.vars.base_wnd:getChildByName("TOP"), "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), arg_30_0.vars.wnd, "block")
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_30_0.vars.eff_bg, "block")
	arg_30_0.vars.hero_belt:revertPoppedItem()
	
	if arg_30_1 then
		arg_30_0.vars.hero_belt:resetDataUseFilter(Account.units, arg_30_1)
	end
	
	if arg_30_1 then
		if arg_30_0.vars.unit then
			UnitDetail:updateUnitInfo(arg_30_0.vars.unit)
		end
		
		if arg_30_1 ~= "Detail" and arg_30_1 ~= "Skill" then
			UnitMain:leavePortrait(nil, arg_30_1 ~= "Main")
		end
	end
	
	if not UnitMain:isDisableTopRight() then
		TopBarNew:setEnableTopRight()
	end
end

function UnitNewPromote.onPushBackButton(arg_31_0, arg_31_1)
	if arg_31_0.vars.start_unit then
		UnitMain:setMode("Detail", {
			set_start_mode = true,
			detail_mode = "Growth",
			unit = arg_31_0.vars.unit,
			select_next_promotable_unit = arg_31_1
		})
	else
		arg_31_0:onSelectTargetUnit()
	end
end

function UnitNewPromote.procUpgrade(arg_32_0, arg_32_1)
	vibrate(VIBRATION_TYPE.Success)
	ConditionContentsManager:setIgnoreQuery(true)
	Account:addReward(arg_32_1.rewards)
	
	local var_32_0 = arg_32_0.vars.unit:getLv()
	
	UnitUpgradeLogic:UpdateLevelInfo(arg_32_0.vars.unit, arg_32_1.target)
	UnitUpgradeLogic:UpdateAccountUnitInfo(arg_32_0.vars.unit, arg_32_1.target, var_32_0)
	
	local var_32_1 = Account:getUnit(arg_32_1.target.id)
	
	arg_32_0.vars.unit = var_32_1
	
	HeroBelt:getInst("UnitMain"):updateUnit(nil, arg_32_0.vars.unit)
	arg_32_0:updateBaseUnitInfo()
	arg_32_0:updateUpgradeInfo(true)
	arg_32_0:resetResource()
	arg_32_0.vars.hero_belt:updateUnit(nil, arg_32_0.vars.unit)
	ConditionContentsManager:setIgnoreQuery(false)
	ConditionContentsManager:queryUpdateConditions("f:doUpgrade_1")
	arg_32_0:showPromoteRewardPopup()
	
	if UnitMain:getStartMode() == "Upgrade" or UnitMain:getStartMode() == "LevelUp" then
		UnitMain:setMode("Detail", {
			set_start_mode = true,
			detail_mode = "Growth",
			unit = arg_32_0.vars.unit
		})
	else
		arg_32_0:onPushBackButton()
	end
end

function UnitNewPromote.getEnhanceMode(arg_33_0)
	return "Promote"
end
