BallManager = {}
BallObject = {}

local var_0_0 = 1100
local var_0_1 = 1000
local var_0_2 = 700
local var_0_3 = 400
local var_0_4 = 60
local var_0_5 = 600
local var_0_6 = 600
local var_0_7 = 100
local var_0_8 = 0.25

function BallManager.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.bollObject = {}
	arg_1_0.vars.commands = Queue.new()
	arg_1_0.vars.delay_time = 0
	arg_1_0.vars.bollObject = BallObject:create(arg_1_0.vars.bollObject, arg_1_1)
	
	arg_1_1:addChild(arg_1_0.vars.bollObject:getBallModel())
	arg_1_0.vars.bollObject:getBallModel():setLocalZOrder(20)
	Scheduler:removeByName("volley_delay_update")
	Scheduler:addInterval(VolleyBallMain.vars.parent_layer, 50, BallManager.update_delay_time, BallManager):setName("volley_delay_update")
	arg_1_0.vars.bollObject:setBallPosition(var_0_5, var_0_6)
	arg_1_0:setVisibleBall(false)
end

function BallManager.reset(arg_2_0)
	arg_2_0:stopRollingAnimation()
	arg_2_0.vars.bollObject:resetOwner()
	arg_2_0:stopUltEffect()
	
	arg_2_0.vars.next_command = nil
	arg_2_0.vars.next_delay = nil
	arg_2_0.vars.commands = nil
	arg_2_0.vars.commands = Queue.new()
end

function BallManager.setVisibleBall(arg_3_0, arg_3_1)
	if not arg_3_0.vars or not arg_3_0.vars.bollObject then
		return 
	end
	
	arg_3_0.vars.bollObject:setVisible(arg_3_1)
end

function BallManager.startRollingAnimation(arg_4_0)
	arg_4_0.vars.bollObject:startRollingAnimation()
end

function BallManager.stopRollingAnimation(arg_5_0)
	arg_5_0.vars.bollObject:stopRollingAnimation()
end

function BallManager.setNextCommend(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars.next_command = arg_6_1
	arg_6_0.vars.next_delay = arg_6_2
end

function BallManager.procNextCommand(arg_7_0)
	if not arg_7_0.vars or not arg_7_0.vars.next_command or PAUSED then
		return 
	end
	
	if not BattleAction:Find("ball_toss_to_spike") then
		arg_7_0:addCommandString(arg_7_0.vars.next_command, arg_7_0.vars.next_delay)
		
		arg_7_0.vars.next_command = nil
		arg_7_0.vars.next_delay = nil
	end
end

function BallManager.addCommandString(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_1 then
		return 
	end
	
	local var_8_0 = (arg_8_2 or var_0_0 / 1000) - var_0_8
	local var_8_1 = {}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		var_8_1[iter_8_0] = {}
		
		local var_8_2 = string.split(iter_8_1, "/")
		
		for iter_8_2, iter_8_3 in pairs(var_8_2) do
			table.insert(var_8_1[iter_8_0], iter_8_3)
		end
	end
	
	for iter_8_4, iter_8_5 in pairs(var_8_1) do
		local var_8_3 = false
		
		if iter_8_5[2] == "true" then
			var_8_3 = true
		end
		
		local var_8_4 = Volley_CharacterManager:getCharacter(var_8_3, tonumber(iter_8_5[3]))
		local var_8_5 = var_8_0
		
		if iter_8_5[1] == "spike" or iter_8_5[1] == "spike_ult" then
			var_8_5 = (iter_8_5[1] == "spike" and var_0_1 or var_0_2) / 1000 - math.max(var_0_8 - 0.4, 0)
			
			if iter_8_5[1] == "spike" then
				var_8_5 = var_8_5 - 0.2
			else
				var_8_5 = var_8_5 - 0.17
			end
		end
		
		if iter_8_5[1] == "out" then
			var_8_5 = 0
		end
		
		if iter_8_5[1] == "start" then
			var_8_5 = 0.2
		end
		
		if not var_8_3 and iter_8_5[1] == "toss_to_spike_ult" then
			var_8_5 = var_8_5 + VolleyCutInManager:getCutInTime() / 1000
		end
		
		BallManager:addCommand(iter_8_5[1], var_8_4, var_8_5, tonumber(iter_8_5[4]))
	end
end

function BallManager.addCommand(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	Queue.push(arg_9_0.vars.commands, {
		arg_9_1,
		arg_9_2,
		arg_9_3,
		arg_9_4
	})
end

function BallManager.popCommand(arg_10_0)
	if not arg_10_0.vars or not arg_10_0.vars.commands or Queue.empty(arg_10_0.vars.commands) then
		return 
	end
	
	Queue.pop(arg_10_0.vars.commands)
end

function BallManager.update(arg_11_0)
	if not arg_11_0.vars or not arg_11_0.vars.commands or Queue.empty(arg_11_0.vars.commands) or PAUSED then
		return 
	end
	
	local var_11_0 = Queue.top(arg_11_0.vars.commands)
	
	if var_11_0 and arg_11_0.vars.delay_time <= 0 then
		print("volley_act_cmd", var_11_0[1], var_11_0[2], var_11_0[2].vars.isAlly, var_11_0[3], var_11_0[4])
		arg_11_0:command(var_11_0[1], var_11_0[2], var_11_0[4])
		
		arg_11_0.vars.delay_time = var_11_0[3]
		
		arg_11_0:popCommand()
	end
end

function BallManager.update_delay_time(arg_12_0)
	if not arg_12_0.vars or not arg_12_0.vars.delay_time or arg_12_0.vars.delay_time <= 0 or PAUSED then
		return 
	end
	
	arg_12_0.vars.delay_time = arg_12_0.vars.delay_time - 0.05
end

function BallManager.reset_delay_time(arg_13_0)
	if not arg_13_0.vars or not arg_13_0.vars.delay_time then
		return 
	end
	
	arg_13_0.vars.delay_time = 0
end

function BallManager.command(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0.vars.bollObject:command(arg_14_1, arg_14_2, arg_14_3)
end

function BallManager.setOwner(arg_15_0, arg_15_1)
	arg_15_0.vars.bollObject:setOwner(arg_15_1)
end

function BallManager.getOwner(arg_16_0)
	return arg_16_0.vars.bollObject:getOwner()
end

function BallManager.resetOwner(arg_17_0)
	arg_17_0.vars.bollObject:resetOwner()
end

function BallManager.startUltEffect(arg_18_0)
	arg_18_0.vars.bollObject:startUltEffect()
end

function BallManager.stopUltEffect(arg_19_0)
	arg_19_0.vars.bollObject:stopUltEffect()
end

function BallObject.create(arg_20_0, arg_20_1, arg_20_2)
	arg_20_1.vars = {}
	arg_20_1.vars.model = nil
	arg_20_1.vars.speed = var_0_0
	arg_20_1.vars.spike_speed = var_0_1
	arg_20_1.vars.spike_ult_speed = var_0_2
	arg_20_1.vars.start_height = 180
	
	copy_functions(BallObject, arg_20_1)
	
	local var_20_0 = cc.Node:create()
	local var_20_1 = cc.Sprite:create("img/2021_summer_ball.png")
	
	var_20_0:addChild(var_20_1)
	var_20_1:setScale(0.6)
	
	arg_20_1.vars.model = var_20_0
	arg_20_1.vars.model_bg = var_20_1
	
	arg_20_1.vars.model:setPositionX(320)
	arg_20_1.vars.model:setPositionY(350)
	
	local var_20_2 = cc.Sprite:create(get_texture_filename("model/default/shadow.png"))
	
	var_20_2:setAnchorPoint(0.5, 0.5)
	var_20_2:setGlobalZOrder(-100000000)
	
	arg_20_1.vars.shadow = var_20_2
	arg_20_1.vars.shadow_state = 1
	arg_20_1.vars.shadow_scale = 1.3
	
	local var_20_3 = var_20_0
	
	local function var_20_4()
		local var_21_0 = 0.02
		local var_21_1 = 0.8
		local var_21_2 = arg_20_1.vars.shadow_scale
		local var_21_3 = var_20_2:getScale()
		
		if arg_20_1.vars.shadow_state == 1 then
			var_20_2:setScale(arg_20_1.vars.shadow_scale)
		elseif arg_20_1.vars.shadow_state == 2 then
			var_20_2:setScale(math.max(var_21_3 - var_21_0, var_21_1))
		elseif arg_20_1.vars.shadow_state == 3 then
			var_20_2:setScale(math.min(var_21_3 + var_21_0 + 0.03, var_21_2))
		elseif arg_20_1.vars.shadow_state == 4 then
			var_20_2:setScale(math.min(var_21_3 + var_21_0, var_21_2))
		end
	end
	
	var_20_2:setScaleFactor(1)
	arg_20_2:addChild(var_20_2)
	var_20_2:setScale(arg_20_1.vars.shadow_scale)
	var_20_2:setColor(cc.c3b(255, 255, 255))
	var_20_2:setOpacity(255)
	var_20_2:setPositionX(var_20_1:getPositionX())
	var_20_2:setPositionY(var_20_1:getPositionY() - 100)
	var_20_2:setVisible(true)
	var_20_4()
	var_20_2:registerUpdateLuaHandler(var_20_4)
	var_20_2:registerScriptHandler(function(arg_22_0)
		if arg_22_0 == "enter" then
			var_20_2:scheduleUpdate()
		end
	end)
	var_20_2:scheduleUpdate()
	var_20_2:setGlobalZOrder(0)
	var_20_2:setLocalZOrder(5)
	
	return arg_20_1
end

function BallObject.setShadowState(arg_23_0, arg_23_1)
	arg_23_0.vars.shadow_state = arg_23_1
end

function BallObject.setVisible(arg_24_0, arg_24_1)
	arg_24_0.vars.model_bg:setVisible(arg_24_1)
	arg_24_0.vars.shadow:setVisible(arg_24_1)
end

function BallObject.startRollingAnimation(arg_25_0)
	if not arg_25_0.vars or not arg_25_0.vars.model_bg or BattleAction:Find("ball_rolling") then
		return 
	end
	
	BattleAction:Add(LOOP(ROTATE(800, 0, -360), 100), arg_25_0.vars.model_bg, "ball_rolling")
end

function BallObject.stopRollingAnimation(arg_26_0)
	BattleAction:Remove("ball_rolling")
end

function BallObject.setBallPosition(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0.vars or not arg_27_0.vars.model or not arg_27_1 or not arg_27_2 then
		return 
	end
	
	arg_27_0.vars.model:setPosition(arg_27_1, arg_27_2)
	arg_27_0.vars.shadow:setPosition(arg_27_1, arg_27_2 - 100)
end

function BallObject.getBallModel(arg_28_0)
	return arg_28_0.vars.model
end

function BallObject.getSpeed(arg_29_0)
	return arg_29_0.vars.speed
end

function BallObject.setSpeed(arg_30_0, arg_30_1)
	arg_30_0.vars.speed = arg_30_1
end

function BallObject.getSpikeSpeed(arg_31_0, arg_31_1)
	if arg_31_1 then
		return arg_31_0.vars.spike_ult_speed
	else
		return arg_31_0.vars.spike_speed
	end
end

function BallObject.setSpikeSpeed(arg_32_0, arg_32_1)
	arg_32_0.vars.spike_speed = arg_32_1
end

function BallObject.setOwner(arg_33_0, arg_33_1)
	arg_33_0.vars.owner = arg_33_1
end

function BallObject.getOwner(arg_34_0)
	return arg_34_0.vars.owner
end

function BallObject.resetOwner(arg_35_0)
	arg_35_0.vars.owner = nil
end

function BallObject.startUltEffect(arg_36_0)
	arg_36_0.vars.ult_eff = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_volleyball_ball.cfx",
		pivot_y = 0,
		pivot_z = 99999,
		scale = 1,
		layer = arg_36_0.vars.model
	})
end

function BallObject.stopUltEffect(arg_37_0)
	if get_cocos_refid(arg_37_0.vars.ult_eff) then
		arg_37_0.vars.ult_eff:stop()
	end
end

function BallObject.addBallAction(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_2 or {}
	local var_38_1 = var_38_0.ball_speed
	local var_38_2 = var_38_0.spike_speed
	local var_38_3 = var_38_0.dest_pos_y
	local var_38_4 = var_38_0.target_x
	local var_38_5 = var_38_0.target_y
	local var_38_6 = var_38_0.target
	local var_38_7 = var_38_0.use_cut_in
	local var_38_8 = var_38_0.spike_out_ally
	local var_38_9 = arg_38_0.vars.model
	local var_38_10 = arg_38_0.vars.shadow
	local var_38_11 = var_38_4
	local var_38_12 = var_38_5 - 50
	
	if arg_38_1 == "start" then
		BallManager:setVisibleBall(true)
		BattleAction:Add(SEQ(MOVE_TO(var_38_1, var_38_4, var_38_3), CALL(function()
			BallManager:startRollingAnimation()
		end)), var_38_9, "ball_start")
		var_38_10:setPosition(var_38_11, var_38_3 - 50)
		var_38_10:setScale(1)
		arg_38_0:setShadowState(4)
	elseif arg_38_1 == "toss" or arg_38_1 == "toss_spike" or arg_38_1 == "toss_to_start" then
		local var_38_13 = var_0_7
		local var_38_14 = var_38_13
		
		if arg_38_1 == "toss_to_start" then
			var_38_14 = 30
		end
		
		BattleAction:Add(SEQ(JUMP_TO(var_38_1, var_38_4, var_38_5, var_38_13)), var_38_9, "ball_toss")
		BattleAction:Add(SEQ(JUMP_TO(var_38_1, var_38_11, var_38_12, var_38_14)), var_38_10, "shadow_ball_toss")
		arg_38_0:stopUltEffect()
		arg_38_0:setShadowState(1)
	elseif arg_38_1 == "toss_to_spike" or arg_38_1 == "toss_to_spike_ult" then
		if var_38_7 then
			BattleAction:Add(SEQ(JUMP_TO(var_38_1, var_38_4, var_38_5 + 70, var_0_7), DELAY(VolleyCutInManager:getCutInTime()), CALL(function()
				arg_38_0:startUltEffect()
				VolleyScoreManager:resetGague(var_38_6:isAlly())
			end)), var_38_9, "ball_toss_to_spike")
		else
			BattleAction:Add(SEQ(JUMP_TO(var_38_1, var_38_4, var_38_5 + 70, var_0_7)), var_38_9, "ball_toss_to_spike")
		end
		
		BattleAction:Add(SEQ(MOVE_TO(var_38_1, var_38_11, var_38_12 - 100)), var_38_10, "shadow_ball_toss_to_spike")
		arg_38_0:setShadowState(2)
	elseif arg_38_1 == "spike" or arg_38_1 == "spike_ult" then
		BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_4, var_38_5)), var_38_9, "ball_spike")
		BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_11, var_38_12)), var_38_10, "shadow_ball_spike")
		arg_38_0:setShadowState(3)
	elseif arg_38_1 == "receive_out" then
		BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_4, var_38_5)), var_38_9, "ball_out")
		BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_11, var_38_12 - 100)), var_38_10, "shadow_ball_out")
		arg_38_0:setShadowState(1)
	elseif arg_38_1 == "spike_out" then
		local var_38_15 = 420
		
		if var_38_8 then
			BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_4 + 200, var_38_5), MOVE_TO(var_38_2 - 50, var_38_4 + var_38_15, var_38_5 + 100)), var_38_9, "ball_spike_out")
			BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_11 + 200, var_38_12), MOVE_TO(var_38_2 - 50, var_38_11 + var_38_15, var_38_12 + 100)), var_38_10, "shadow_ball_spike_out")
		else
			BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_4 - 200, var_38_5), MOVE_TO(var_38_2 - 50, var_38_4 - var_38_15, var_38_5 + 100)), var_38_9, "ball_spike_out")
			BattleAction:Add(SEQ(MOVE_TO(var_38_2, var_38_11 - 200, var_38_12), MOVE_TO(var_38_2 - 50, var_38_11 - var_38_15, var_38_12 + 100)), var_38_10, "shadow_ball_spike_out")
		end
		
		arg_38_0:setShadowState(3)
	elseif arg_38_1 == "out" then
		arg_38_0:setShadowState(1)
		
		local var_38_16 = var_38_2 - 300
		local var_38_17 = 820
		
		if var_38_8 then
			BattleAction:Add(SEQ(MOVE_TO(var_38_16 - 50, var_38_4 + var_38_17, var_38_5 + 100)), var_38_9, "ball__out")
			BattleAction:Add(SEQ(MOVE_TO(var_38_16 - 50, var_38_11 + var_38_17, var_38_12 + 100)), var_38_10, "shadow_ball_out")
		else
			BattleAction:Add(SEQ(MOVE_TO(var_38_16 - 50, var_38_4 - var_38_17, var_38_5 + 100)), var_38_9, "ball_out")
			BattleAction:Add(SEQ(MOVE_TO(var_38_16 - 50, var_38_11 - var_38_17, var_38_12 + 100)), var_38_10, "shadow_ball_out")
		end
	end
end

function BallObject.command(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not arg_41_1 then
		return 
	end
	
	if arg_41_1 ~= "out" and not arg_41_2 then
		return 
	end
	
	local var_41_0 = arg_41_0:getSpeed()
	local var_41_1 = arg_41_0:getSpikeSpeed(arg_41_1 == "spike_ult")
	local var_41_2 = arg_41_1 == "toss_to_spike_ult"
	local var_41_3 = false
	
	if arg_41_1 ~= "start" and arg_41_1 ~= "out" and arg_41_1 ~= "spike" and arg_41_1 ~= "receive_out" and arg_41_1 ~= "spike_out" and arg_41_1 ~= "spike_ult" then
		Volley_CharacterManager:command("move", arg_41_2)
	end
	
	local var_41_4, var_41_5 = arg_41_2:getFutureBallPos()
	local var_41_6 = arg_41_0:getOwner()
	local var_41_7 = 0
	local var_41_8 = var_41_5 + arg_41_0.vars.start_height / 2 - var_41_7
	
	if arg_41_1 == "start" then
		local var_41_9 = 0
		
		var_41_0 = var_0_3
		
		Volley_CharacterManager:command("serve", arg_41_2, {
			ball_speed = var_41_0,
			target_y = var_41_8 - 50,
			before_jump_delay = var_41_9
		})
		arg_41_0:setBallPosition(var_41_4, var_41_5 + arg_41_0.vars.start_height)
	elseif arg_41_1 == "toss" or arg_41_1 == "toss_spike" or arg_41_1 == "toss_to_start" then
		if arg_41_1 == "toss_spike" and not var_41_6:isAlly() then
			local var_41_10 = arg_41_3 or VolleyBallMain:getNPC_touch_result(arg_41_1) or 2
			
			VolleyScoreManager:addTypeText(var_41_6:getModel():getPositionX(), var_41_6:getModel():getPositionY(), var_41_10)
			VolleyScoreManager:addGauge(var_41_6:isAlly(), var_41_10, {
				is_defense = true
			})
		end
		
		if var_41_6 and arg_41_1 ~= "toss_to_start" and arg_41_1 ~= "toss_spike" then
			Volley_CharacterManager:command("toss", var_41_6)
		elseif arg_41_1 == "toss_to_start" then
		end
	elseif arg_41_1 == "toss_to_spike" or arg_41_1 == "toss_to_spike_ult" then
		if var_41_6 then
			Volley_CharacterManager:command("toss_to_spike", var_41_6)
		end
		
		var_41_5 = var_41_5 + var_0_4
		
		if var_41_2 then
			Volley_CharacterManager:command("spike_cutin", arg_41_2, {
				ball_speed = var_41_0,
				target_y = var_41_5
			})
		else
			Volley_CharacterManager:command("spike", arg_41_2, {
				ball_speed = var_41_0,
				target_y = var_41_5
			})
		end
		
		if arg_41_2:isAlly() then
			TouchNodeManager:setTarget(arg_41_2)
			TouchNodeManager:createTouchNode(nil, "spike")
		end
	elseif arg_41_1 == "spike" or arg_41_1 == "spike_ult" then
		if not var_41_6:isAlly() then
			local var_41_11 = arg_41_3 or VolleyBallMain:getNPC_touch_result(arg_41_1) or 2
			
			VolleyScoreManager:addTypeText(var_41_6:getModel():getPositionX(), var_41_6:getModel():getPositionY(), var_41_11)
			VolleyScoreManager:addGauge(var_41_6:isAlly(), var_41_11, {
				is_ult = arg_41_1 == "spike_ult"
			})
		end
		
		Volley_CharacterManager:command("receive_spike_toss", arg_41_2, {
			spike_speed = var_41_1
		})
		
		if arg_41_2:isAlly() and (arg_41_1 == "spike" or arg_41_1 == "spike_ult") then
			TouchNodeManager:setTarget(arg_41_2)
			TouchNodeManager:createTouchNode(nil, "receive", {
				recieve_enemy_ult = arg_41_1 == "spike_ult"
			})
		end
	elseif arg_41_1 == "receive_out" then
		if arg_41_2:isAlly() then
			if var_41_6:getIdx() == 1 then
				var_41_4 = var_41_4 - 580
				var_41_5 = var_41_5 + 60
			else
				var_41_4 = var_41_4 - 580
				var_41_5 = var_41_5 + 160
			end
		else
			if var_41_6:getIdx() == 1 then
				var_41_4 = var_41_4 + 580
				var_41_5 = var_41_5 + 60
			else
				var_41_4 = var_41_4 + 580
				var_41_5 = var_41_5 + 140
			end
			
			local var_41_12 = arg_41_3 or 2
			
			if var_41_6 then
				VolleyScoreManager:addTypeText(var_41_6:getModel():getPositionX(), var_41_6:getModel():getPositionY(), var_41_12)
			end
		end
		
		var_41_1 = var_41_1 + 150
		
		VolleyScoreManager:addScore(not arg_41_2:isAlly())
		VolleyBallMain:reserve_reset_game()
	elseif arg_41_1 == "spike_out" then
		if var_41_6:isAlly() then
			var_41_3 = true
			var_41_4 = arg_41_2:getModel():getPositionX() + 250
			var_41_5 = arg_41_2:getModel():getPositionY()
		else
			var_41_4 = arg_41_2:getModel():getPositionX() - 250
			var_41_5 = arg_41_2:getModel():getPositionY()
			
			local var_41_13 = arg_41_3 or 2
			
			VolleyScoreManager:addTypeText(var_41_6:getModel():getPositionX(), var_41_6:getModel():getPositionY(), var_41_13)
		end
		
		VolleyScoreManager:addScore(not var_41_6:isAlly())
		VolleyBallMain:reserve_reset_game()
	elseif arg_41_1 == "out" then
		Volley_CharacterManager:command("hit", var_41_6)
		
		if arg_41_2:isAlly() then
			if var_41_6:getIdx() == 1 then
				Volley_CharacterManager:command("out", var_41_6, {
					spike_speed = var_41_1
				})
			else
				Volley_CharacterManager:command("out", var_41_6, {
					spike_speed = var_41_1
				})
			end
		else
			var_41_3 = true
			
			Volley_CharacterManager:command("out", var_41_6, {
				spike_speed = var_41_1
			})
		end
		
		arg_41_0:stopUltEffect()
		VolleyScoreManager:addScore(not arg_41_2:isAlly())
		VolleyBallMain:reserve_reset_game()
	end
	
	VolleyScoreManager:checkUltEffect()
	
	local var_41_14 = {
		ball_speed = var_41_0,
		spike_speed = var_41_1,
		dest_pos_y = var_41_8,
		target = arg_41_2,
		target_x = var_41_4,
		target_y = var_41_5,
		use_cut_in = var_41_2,
		spike_out_ally = var_41_3
	}
	
	arg_41_0:addBallAction(arg_41_1, var_41_14)
	
	if var_41_6 then
		var_41_6:showBalloonMsg(arg_41_1)
	end
	
	arg_41_0:setOwner(arg_41_2)
end
