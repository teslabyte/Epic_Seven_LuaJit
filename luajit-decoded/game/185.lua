function Battle.playFireEffect(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if not arg_1_1.effect then
		return 
	end
	
	local var_1_0 = false
	local var_1_1 = 0
	local var_1_2 = 0
	local var_1_3 = 0
	
	if not get_cocos_refid(arg_1_3.model) then
		return 
	end
	
	local var_1_4 = arg_1_1.offset_x or 0
	local var_1_5 = arg_1_1.offset_y or 0
	
	if arg_1_1.attach_self then
		if arg_1_2 and get_cocos_refid(arg_1_2.model) then
			var_1_1, var_1_2 = arg_1_2.model:getBonePosition("hit")
			
			if not arg_1_1.ignore_flip_x and arg_1_2.model:getScaleX() < 0 then
				var_1_0 = true
			end
		end
	elseif arg_1_3 and get_cocos_refid(arg_1_3.model) then
		var_1_1, var_1_2 = arg_1_3.model:getBonePosition("target")
		
		if not arg_1_1.ignore_flip_x and arg_1_3.model:getScaleX() > 0 then
			var_1_0 = true
		end
	end
	
	if var_1_0 then
		var_1_4 = -var_1_4
	end
	
	local var_1_6 = arg_1_3.model:getLocalZOrder() + 1
	local var_1_7 = var_1_2 + arg_1_4
	local var_1_8 = 0.5
	local var_1_9 = math.floor((arg_1_1.rand_x or 0) * var_1_8)
	local var_1_10 = math.floor((arg_1_1.rand_y or 0) * var_1_8)
	local var_1_11 = var_1_1 + var_1_4 + math.random(-var_1_9, var_1_9)
	local var_1_12 = var_1_7 + var_1_5 + math.random(-var_1_10, var_1_10)
	local var_1_13 = (arg_1_1.scale or 1) + math.random() * (arg_1_1.rand_scale or 0)
	local var_1_14 = BGIManager:getBGI().main.layer:getFrontLayer()
	
	EffectManager:Play({
		is_battle_effect = true,
		fn = arg_1_1.effect,
		layer = var_1_14,
		pivot_x = var_1_11,
		pivot_y = var_1_12,
		pivot_z = var_1_6,
		scale = var_1_13,
		flip_x = var_1_0,
		action = BattleAction
	})
end

DEBUG.PRV_DAMAGE_COLOR = false

function Battle.playDamageColor(arg_2_0, arg_2_1, arg_2_2)
	if SAVE and SAVE:getOptionData("option.blur_off", default_options.blur_off) then
		return 
	end
	
	if arg_2_2 and arg_2_2.damage < 1 then
		return 
	end
	
	local var_2_0 = get_cocos_refid(arg_2_1)
	
	if not var_2_0 then
		return 
	end
	
	local var_2_1 = cc.c3b(255, 0, 0)
	local var_2_2 = 80
	local var_2_3
	
	if arg_2_0.vars and arg_2_0.vars.ambient_color then
		var_2_3 = arg_2_0.vars.ambient_color
	else
		var_2_3 = cc.c3b(255, 255, 255)
	end
	
	local var_2_4 = string.format("damage_effect.%d", var_2_0)
	
	if BattleAction:Find(var_2_4) and not DEBUG.PRV_DAMAGE_COLOR then
		BattleAction:Remove(var_2_4)
	end
	
	BattleAction:Add(SEQ(SEQ(BLEND(1, "red", 0, 1), DELAY(33), BLEND(1, "white", 0, 1), DELAY(25), BLEND(0), COLOR(0, var_2_1), DELAY(var_2_2), COLOR(350, var_2_3))), arg_2_1, var_2_4)
end

function Battle.playStateEff(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_1.target or arg_3_0.logic:getUnit(arg_3_1.target_uid)
	
	if not get_cocos_refid(var_3_0.model) then
		return 
	end
	
	if not arg_3_2 then
		return 
	end
	
	arg_3_3 = arg_3_3 or "target"
	
	local var_3_1
	local var_3_2
	local var_3_3
	local var_3_4, var_3_5 = var_3_0.model:getBonePosition(arg_3_3)
	local var_3_6 = var_3_0.model:getLocalZOrder() + 1
	local var_3_7
	local var_3_8 = arg_3_0.logic:getTurnOwner()
	local var_3_9 = not string.starts(arg_3_2, "stse_") and var_3_8 and var_3_8.inst.ally == ENEMY and true or nil
	
	EffectManager:Play({
		fn = arg_3_2,
		layer = BGIManager:getBGI().main.layer,
		x = var_3_4,
		y = var_3_5,
		z = var_3_6,
		flip_x = var_3_9,
		action = BattleAction
	})
end

function Battle.playStateHealEff(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1.target or arg_4_0.logic:getUnit(arg_4_1.target_uid)
	
	if not get_cocos_refid(var_4_0.model) then
		return 
	end
	
	if not arg_4_2 then
		return 
	end
	
	local var_4_1 = "target"
	
	if var_4_0.model.getRawBonePosition == nil then
		Log.e("Battle.playStateHealEff() : no getRawBonePosition")
		Log.e(var_4_0.model:getName())
	end
	
	local var_4_2
	local var_4_3
	local var_4_4, var_4_5 = var_4_0.model:getRawBonePosition(var_4_1)
	local var_4_6
	local var_4_7 = arg_4_0.logic:getTurnOwner()
	local var_4_8 = not string.starts(arg_4_2, "stse_") and var_4_7 and var_4_7.inst.ally == ENEMY and true or nil
	
	EffectManager:Play({
		z = 1,
		fn = arg_4_2,
		layer = var_4_0.model,
		x = var_4_4,
		y = var_4_5,
		scale = 1 / BASE_SCALE,
		flip_x = var_4_8,
		action = BattleAction
	})
end

function Battle.playAdditionalSkillEffect(arg_5_0, arg_5_1)
	if not get_cocos_refid(arg_5_1.model) then
		return 
	end
	
	if arg_5_1.model.getRawBonePosition == nil then
		Log.e("Battle.playStateHealEff() : no getRawBonePosition")
		Log.e(arg_5_1.model:getName())
	end
	
	local var_5_0
	local var_5_1
	local var_5_2
	local var_5_3, var_5_4 = arg_5_1.model:getRawBonePosition("target")
	local var_5_5 = arg_5_1.model:getLocalZOrder() + 1
	
	EffectManager:Play({
		extractNodes = true,
		is_battle_effect = true,
		fn = "stse_chain.cfx",
		layer = arg_5_1.model,
		x = var_5_3,
		y = var_5_4,
		z = var_5_5,
		scale = 1 / BASE_SCALE,
		action = BattleAction
	})
end
