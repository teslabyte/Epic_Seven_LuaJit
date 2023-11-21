PET_ANI_CONTROLLER = {}

local var_0_0 = {
	idle = {
		camping = true,
		move = true
	},
	camping = {
		idle = true
	},
	move = {
		consider_special_behavior = true,
		collision_wait = true
	},
	collision_wait = {
		collision = true
	},
	consider_special_behavior = {
		idle = true,
		special_behavior = true
	},
	special_behavior = {
		idle = true
	},
	collision = {
		consider_special_behavior = true,
		collision_wait = "consider_special_behavior"
	}
}
local var_0_1 = "idle"
local var_0_2 = {}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2.current_animation = arg_1_1
	
	return arg_1_0:setAnimation(0, arg_1_1, true)
end

function var_0_2.idle(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_4.camping_percent and math.random(0, 100) < arg_2_4.camping_percent then
		arg_2_4.camping = true
	end
	
	var_0_3(arg_2_2, "idle", arg_2_4)
	
	if arg_2_4.use_random then
		arg_2_4.time = arg_2_4.time + math.random(arg_2_4.time_random_min, arg_2_4.time_random_max)
	end
	
	if arg_2_4.begin_camping then
		arg_2_4.time = 0
	end
	
	if arg_2_4.loop then
		arg_2_0:setScheduler("nothing")
	else
		arg_2_0:setScheduler("idle")
	end
end

function var_0_2.camping(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = var_0_3(arg_3_2, "camping", arg_3_4)
	
	if arg_3_4.camping_addition_time then
		arg_3_4.time = arg_3_4.time + arg_3_4.camping_addition_time
	end
	
	if arg_3_4.use_random then
		arg_3_4.time = arg_3_4.time + math.random(arg_3_4.time_random_min, arg_3_4.time_random_max)
	end
	
	local var_3_1 = arg_3_4.adjust_camping_position
	
	if arg_3_4.camping and var_3_1 then
		arg_3_2:setPosition(var_3_1.x, var_3_1.y)
	end
	
	if var_3_0 then
		var_3_0.time = var_3_0.endTime + math.random() * 20
	end
	
	if arg_3_4.loop then
		arg_3_0:setScheduler("nothing")
	else
		arg_3_0:setScheduler("camping")
	end
end

function var_0_2.move(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	var_0_3(arg_4_2, "run", arg_4_4)
	
	local var_4_0 = (arg_4_4.x_vector_min or 0.5) * 100
	local var_4_1 = math.random(var_4_0, 100) / 100
	local var_4_2 = 1 - var_4_1
	local var_4_3 = arg_4_4.reverse_percent
	
	if var_4_3 < math.random(0, 100) then
		var_4_1 = var_4_1 * -1
		
		arg_4_2:setScaleX(-1)
	else
		arg_4_2:setScaleX(1)
	end
	
	if var_4_3 < math.random(0, 100) then
		var_4_2 = var_4_2 * -1
	end
	
	arg_4_4.x_vector = var_4_1
	arg_4_4.y_vector = var_4_2
	
	arg_4_0:setScheduler("move")
end

function var_0_2.collision_wait(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	var_0_3(arg_5_2, "idle", arg_5_4)
	
	arg_5_4.x_vector = arg_5_3.x_vector
	arg_5_4.y_vector = arg_5_3.y_vector
	
	arg_5_0:setScheduler("collision_wait")
end

function var_0_2.collision(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	var_0_3(arg_6_2, "run", arg_6_4)
	
	local var_6_0 = arg_6_3.x_vector
	local var_6_1 = arg_6_3.y_vector
	local var_6_2 = var_6_0 * -1
	local var_6_3 = var_6_1 * -1
	
	if var_6_2 > 0 then
		arg_6_2:setScaleX(1)
	else
		arg_6_2:setScaleX(-1)
	end
	
	arg_6_4.x_vector = var_6_2
	arg_6_4.y_vector = var_6_3
	
	arg_6_0:setScheduler("collision")
end

function var_0_2.consider_special_behavior(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0:setState("idle")
end

function var_0_2.special_behavior(arg_8_0, arg_8_1, arg_8_2)
end

function PET_ANI_CONTROLLER.create(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0 = {}
	
	copy_functions(PET_ANI_CONTROLLER, var_9_0)
	
	var_9_0.pet = arg_9_1
	var_9_0.model = arg_9_2
	var_9_0.node = arg_9_3
	var_9_0.info_node = arg_9_4
	var_9_0.slot_idx = arg_9_5
	var_9_0.range_rect = arg_9_6
	var_9_0.state_condition = arg_9_7
	
	if_set_visible(arg_9_4, nil, true)
	if_set_visible(arg_9_3, nil, true)
	var_9_0:init(arg_9_1, arg_9_2, arg_9_5)
	
	return var_9_0
end

function PET_ANI_CONTROLLER.init(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0.scheduler_state = ""
	arg_10_0.state = var_0_1
	arg_10_0.id = "slot_" .. arg_10_3
	
	Scheduler:add(arg_10_2, arg_10_0._update, arg_10_0):setName(arg_10_0.id)
	arg_10_0:_setState(arg_10_0.state)
end

function PET_ANI_CONTROLLER.addEffect(arg_11_0, arg_11_1)
	EffectManager:Play({
		fn = arg_11_1,
		layer = arg_11_0.model:getBoneNode("target")
	})
end

function PET_ANI_CONTROLLER.addEffectNode(arg_12_0, arg_12_1)
	EffectManager:Play({
		fn = arg_12_1,
		layer = arg_12_0.node
	})
end

function PET_ANI_CONTROLLER.playAddAnimation(arg_13_0)
	arg_13_0:addEffect("ui_pet_pop_eff.cfx")
end

function PET_ANI_CONTROLLER._onEndUpdateMove(arg_14_0)
	arg_14_0:setState("consider_special_behavior")
end

function PET_ANI_CONTROLLER._saveLastVector(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
end

function PET_ANI_CONTROLLER._onCollision(arg_16_0, arg_16_1)
	arg_16_0:setState("collision_wait")
end

function PET_ANI_CONTROLLER._updateMove(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_2 or arg_17_0.current_state_condition.distance
	local var_17_1 = arg_17_3 or arg_17_0.current_state_condition.y_distance
	local var_17_2 = arg_17_0.current_state_condition.time
	local var_17_3 = uitick() - arg_17_0.last_ui_tick
	local var_17_4 = var_17_0 / var_17_2 * var_17_3 * arg_17_1
	local var_17_5 = var_17_1 / var_17_2 * var_17_3
	local var_17_6 = arg_17_0.node:getPositionX()
	local var_17_7 = arg_17_0.node:getPositionY()
	
	if var_17_6 + var_17_4 <= arg_17_0.range_rect.left or var_17_6 + var_17_4 >= arg_17_0.range_rect.width then
		arg_17_0:_onCollision(arg_17_1)
		
		return 
	end
	
	if var_17_7 + var_17_5 <= arg_17_0.range_rect.top or var_17_7 + var_17_5 >= arg_17_0.range_rect.height then
		arg_17_0:_onCollision(arg_17_1)
		
		return 
	end
	
	if var_17_0 <= arg_17_0.total_distance + var_17_4 then
		arg_17_0:_onEndUpdateMove()
		
		return 
	end
	
	arg_17_0.total_distance = arg_17_0.total_distance + math.abs(var_17_4)
	arg_17_0.total_y_distance = arg_17_0.total_y_distance + math.abs(var_17_5)
	
	arg_17_0.node:setPositionX(var_17_6 + var_17_4)
	arg_17_0.node:setPositionY(var_17_7 + var_17_5)
end

function PET_ANI_CONTROLLER.updateMovement(arg_18_0)
	if not arg_18_0.current_state_condition.x_vector then
		return 
	end
	
	local var_18_0 = arg_18_0.current_state_condition.time
	local var_18_1 = uitick() - arg_18_0.last_ui_tick
	local var_18_2 = arg_18_0.current_state_condition.x_vector
	local var_18_3 = arg_18_0.current_state_condition.y_vector
	local var_18_4 = arg_18_0.current_state_condition.speed
	local var_18_5 = uitick() - arg_18_0.last_ui_tick
	local var_18_6 = var_18_4 * var_18_2 * (var_18_5 / 1000)
	local var_18_7 = var_18_4 * var_18_3 * (var_18_5 / 1000)
	local var_18_8, var_18_9 = arg_18_0.node:getPosition()
	
	if var_18_6 + var_18_8 <= arg_18_0.range_rect.left or var_18_8 + var_18_6 >= arg_18_0.range_rect.width then
		arg_18_0:_onCollision()
		
		return 
	end
	
	if var_18_7 + var_18_9 <= arg_18_0.range_rect.top or var_18_9 + var_18_7 >= arg_18_0.range_rect.height then
		arg_18_0:_onCollision()
		
		return 
	end
	
	if arg_18_0.current_state_condition.time < arg_18_0.last_ui_tick - arg_18_0.start_time then
		arg_18_0:_setState("consider_special_behavior")
		
		return 
	end
	
	arg_18_0.node:setPositionX(var_18_8 + var_18_6)
	arg_18_0.node:setPositionY(var_18_9 + var_18_7)
end

function PET_ANI_CONTROLLER._getRandomDistance(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_1 or arg_19_0.current_state_condition.distance
	local var_19_1 = arg_19_2 or arg_19_0.current_state_condition.y_distance
	local var_19_2 = arg_19_0.current_state_condition.random_distance
	
	if var_19_2 then
		var_19_0 = var_19_0 + var_19_2.x
		var_19_1 = var_19_1 + var_19_2.y
	end
	
	return var_19_0, var_19_1
end

function PET_ANI_CONTROLLER._updateLeft(arg_20_0)
	local var_20_0, var_20_1 = arg_20_0:_getRandomDistance()
	
	arg_20_0:_updateMove(-1, var_20_0, var_20_1)
	
	arg_20_0.current_direction = -1
end

function PET_ANI_CONTROLLER._updateRight(arg_21_0)
	local var_21_0, var_21_1 = arg_21_0:_getRandomDistance()
	
	arg_21_0:_updateMove(1, var_21_0, var_21_1)
	
	arg_21_0.current_direction = 1
end

function PET_ANI_CONTROLLER._updateCollision(arg_22_0)
	local var_22_0 = arg_22_0.current_state_condition.distance or arg_22_0.remain_distance
	local var_22_1 = math.min(var_22_0, arg_22_0.remain_distance)
	local var_22_2 = arg_22_0.current_state_condition.y_distance or arg_22_0.remain_y_distance
	local var_22_3 = math.min(var_22_2, arg_22_0.remain_y_distance)
	local var_22_4, var_22_5 = arg_22_0:_getRandomDistance(var_22_1, var_22_3)
	
	arg_22_0:_updateMove(arg_22_0.last_direction * -1, var_22_4, var_22_5)
	
	arg_22_0.current_direction = arg_22_0.last_direction * -1
end

function PET_ANI_CONTROLLER._updateCamping(arg_23_0)
	if not arg_23_0.current_state_condition then
		return 
	end
	
	if arg_23_0.current_state_condition.time < arg_23_0.last_ui_tick - arg_23_0.start_time then
		arg_23_0:_setState("idle")
	end
end

function PET_ANI_CONTROLLER._updateIdle(arg_24_0)
	if not arg_24_0.current_state_condition then
		return 
	end
	
	if arg_24_0.current_state_condition.time < arg_24_0.last_ui_tick - arg_24_0.start_time then
		if arg_24_0.current_state_condition.camping then
			arg_24_0:_setState("camping")
		else
			arg_24_0:_setState("move")
		end
	end
end

function PET_ANI_CONTROLLER._updateCollisionWait(arg_25_0)
	if not arg_25_0.current_state_condition then
		return 
	end
	
	if arg_25_0.current_state_condition.time < arg_25_0.last_ui_tick - arg_25_0.start_time then
		arg_25_0:_setState("collision")
	end
end

function PET_ANI_CONTROLLER._updatePositionInfoNode(arg_26_0)
	if get_cocos_refid(arg_26_0.node) then
		local var_26_0, var_26_1 = arg_26_0.node:getPosition()
		
		arg_26_0.info_node:setPosition(var_26_0 - 24, var_26_1 - 34)
	end
end

function PET_ANI_CONTROLLER._update(arg_27_0)
	local var_27_0 = arg_27_0.scheduler_state
	
	arg_27_0.node:setLocalZOrder(arg_27_0.node:getPositionY() * -1)
	arg_27_0.info_node:setLocalZOrder(arg_27_0.node:getPositionY() * -1)
	
	if var_27_0 then
		if var_27_0 == "move" then
			arg_27_0:updateMovement()
		elseif var_27_0 == "collision" then
			arg_27_0:updateMovement()
		elseif var_27_0 == "collision_wait" then
			arg_27_0:_updateCollisionWait()
		elseif var_27_0 == "idle" then
			arg_27_0:_updateIdle()
		elseif var_27_0 == "camping" then
			arg_27_0:_updateCamping()
		elseif var_27_0 == "nothing" then
		elseif var_27_0 == "pause" then
			arg_27_0.start_time = uitick()
		elseif var_27_0 == "focus" then
		end
		
		if arg_27_0.debug_show_text and get_cocos_refid(arg_27_0.text_node) then
			arg_27_0.text_node:setString(var_27_0)
		end
	end
	
	if false then
	end
	
	arg_27_0:_updatePositionInfoNode()
	
	arg_27_0.last_ui_tick = uitick()
end

function PET_ANI_CONTROLLER.setScheduler(arg_28_0, arg_28_1)
	local var_28_0 = uitick()
	
	arg_28_0.scheduler_state = arg_28_1
	arg_28_0.current_pos = arg_28_0.node:getPositionX()
	arg_28_0.start_time = var_28_0
	arg_28_0.last_ui_tick = var_28_0
	arg_28_0.total_distance = 0
	arg_28_0.total_y_distance = 0
	
	arg_28_0:_update()
end

function PET_ANI_CONTROLLER.setStateCondition(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.current_state_condition[arg_29_1] = arg_29_2
end

function PET_ANI_CONTROLLER._setState(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.state_condition[arg_30_1]
	local var_30_1 = arg_30_0.current_state_condition
	
	arg_30_0.state = arg_30_1
	
	if var_30_0 then
		arg_30_0.current_state_condition = table.clone(var_30_0)
	else
		arg_30_0.current_state_condition = nil
	end
	
	var_0_2[arg_30_1](arg_30_0, arg_30_0.pet, arg_30_0.model, var_30_1, arg_30_0.current_state_condition)
end

function PET_ANI_CONTROLLER.setState(arg_31_0, arg_31_1)
	if var_0_0[arg_31_0.state] and type(var_0_0[arg_31_0.state][arg_31_1]) == "string" then
		arg_31_1 = var_0_0[arg_31_0.state][arg_31_1]
	end
	
	if var_0_0[arg_31_0.state] and var_0_0[arg_31_0.state][arg_31_1] then
		arg_31_0:_setState(arg_31_1)
	else
		Log.e("PET_ANI_CONTROLLER : WRONG STATE ! ")
	end
end

function PET_ANI_CONTROLLER.showTestText(arg_32_0)
	arg_32_0.debug_show_text = true
	
	if arg_32_0.text_node then
		return 
	end
	
	local var_32_0 = ccui.Text:create()
	
	var_32_0:setString("디버깅")
	var_32_0:setColor(cc.c3b(0, 0, 0))
	var_32_0:setFontSize(50)
	arg_32_0.node:addChild(var_32_0)
	
	arg_32_0.text_node = var_32_0
end

function PET_ANI_CONTROLLER.focus(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.model:setAnimation(0, "idle", true)
	arg_33_0:pause()
	if_set_visible(arg_33_0.node, nil, true)
	if_set_visible(arg_33_0.node, "btn_slot_select", false)
	if_set_visible(arg_33_0.info_node, nil, false)
	
	arg_33_0.last_animation = arg_33_0.current_state_condition.current_animation or "idle"
	arg_33_0.is_focus = true
end

function PET_ANI_CONTROLLER.deFocus(arg_34_0)
	arg_34_0.model:setAnimation(0, arg_34_0.last_animation, true)
	arg_34_0:resume()
	if_set_visible(arg_34_0.info_node, nil, true)
	if_set_visible(arg_34_0.node, "btn_slot_select", true)
	
	arg_34_0.is_focus = false
end

function PET_ANI_CONTROLLER.pause(arg_35_0)
	if arg_35_0.prv_scheduler_state then
		return 
	end
	
	arg_35_0.prv_scheduler_state = arg_35_0.scheduler_state
	arg_35_0.prv_remain_time = arg_35_0.start_time - arg_35_0.last_ui_tick
	arg_35_0.scheduler_state = "pause"
end

function PET_ANI_CONTROLLER.setVisible(arg_36_0, arg_36_1)
	if arg_36_0.is_focus then
		return 
	end
	
	if get_cocos_refid(arg_36_0.node) then
		if arg_36_1 then
			UIAction:Add(SEQ(SHOW(true), RLOG(FADE_IN(500))), arg_36_0.node, "block")
			UIAction:Add(SEQ(SHOW(true), RLOG(FADE_IN(500))), arg_36_0.info_node, "block")
		else
			UIAction:Add(SEQ(LOG(FADE_OUT(500)), SHOW(false)), arg_36_0.node, "block")
			UIAction:Add(SEQ(LOG(FADE_OUT(500)), SHOW(false)), arg_36_0.info_node, "block")
		end
	end
end

function PET_ANI_CONTROLLER.setAmbientColor(arg_37_0, arg_37_1)
	arg_37_0.model:setColor(arg_37_1)
end

function PET_ANI_CONTROLLER.getPosition(arg_38_0, arg_38_1)
	if not get_cocos_refid(arg_38_0.node) then
		return 
	end
	
	local var_38_0 = arg_38_0.model:getBoundingBox()
	local var_38_1, var_38_2 = arg_38_0.node:getPosition()
	
	return var_38_1, var_38_2
end

function PET_ANI_CONTROLLER.getBoundingBox(arg_39_0)
	return arg_39_0.model:getBoundingBox()
end

function PET_ANI_CONTROLLER.test(arg_40_0, arg_40_1, arg_40_2)
	arg_40_0.node:setPosition(arg_40_1, arg_40_2)
end

function PET_ANI_CONTROLLER.resume(arg_41_0)
	if not arg_41_0.prv_remain_time then
		return 
	end
	
	local var_41_0 = uitick()
	
	arg_41_0.start_time = var_41_0 - arg_41_0.prv_remain_time
	arg_41_0.last_ui_tick = var_41_0
	arg_41_0.scheduler_state = arg_41_0.prv_scheduler_state
	arg_41_0.prv_remain_time = nil
	arg_41_0.prv_scheduler_state = nil
end

function PET_ANI_CONTROLLER.remove(arg_42_0)
	Scheduler:remove(arg_42_0.id)
	if_set_visible(arg_42_0.info_node, nil, false)
	
	if get_cocos_refid(arg_42_0.model) then
		local var_42_0 = arg_42_0.node:clone()
		
		arg_42_0.node:getParent():addChild(var_42_0)
		if_set_visible(arg_42_0.node, nil, false)
		
		arg_42_0.node = var_42_0
		
		arg_42_0.model:ejectFromParent()
		arg_42_0.node:getChildByName("n_pos"):addChild(arg_42_0.model)
		UIAction:Add(SEQ(FADE_OUT(500), CALL(PET_ANI_CONTROLLER.addEffectNode, arg_42_0, "ui_pet_pop_eff.cfx"), DELAY(501), CALL(function()
			CACHE:releaseModel(arg_42_0.model)
			if_set_visible(arg_42_0.node, nil, false)
			arg_42_0.node:removeFromParent()
		end)), arg_42_0.model, "ani_end_effect")
	end
end
