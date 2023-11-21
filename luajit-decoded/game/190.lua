function Battle.DoEnterAct_JumpNew(arg_1_0, arg_1_1)
	for iter_1_0 = 1, 4 do
		local var_1_0 = arg_1_0.logic.friends[iter_1_0]
		
		if var_1_0 and not var_1_0:isDead() then
			local var_1_1 = var_1_0.model
			local var_1_2, var_1_3 = var_1_1:getPosition()
			
			var_1_1:setPositionX(var_1_2 - DESIGN_WIDTH / 2 * (arg_1_1 or 1))
			var_1_1:setVisible(true)
		end
	end
	
	if arg_1_0.logic.pet then
		local var_1_4 = arg_1_0.logic.pet
		
		if get_cocos_refid(var_1_4.model) then
			local var_1_5, var_1_6 = var_1_4.model:getPosition()
			
			var_1_4.model:setPositionX(var_1_5 - DESIGN_WIDTH / 2 * (arg_1_1 or 1))
			var_1_4.model:setVisible(true)
		end
	end
	
	BattleLayout:moveToFieldPosition(arg_1_1 == 1 and BATTLE_LAYOUT.XDIST_FROM_SIDE or BattleLayout:getFieldPosition() - BATTLE_LAYOUT.XDIST_FROM_SIDE)
end

function Battle.DoEnterAct_Defend(arg_2_0, arg_2_1)
	for iter_2_0 = 1, 4 do
		local var_2_0 = arg_2_0.logic.friends[iter_2_0]
		
		if var_2_0 and not var_2_0:isDead() then
			local var_2_1 = var_2_0.model
			local var_2_2, var_2_3 = var_2_1:getPosition()
			
			var_2_1:setPositionX(var_2_2 - DESIGN_WIDTH / 2 * (arg_2_1 or 1))
			var_2_1:setVisible(true)
		end
	end
	
	if arg_2_0.logic.pet then
		local var_2_4 = arg_2_0.logic.pet
		
		if get_cocos_refid(var_2_4.model) then
			local var_2_5, var_2_6 = var_2_4.model:getPosition()
			
			var_2_4.model:setPositionX(var_2_5 - DESIGN_WIDTH / 2 * (arg_2_1 or 1))
			var_2_4.model:setVisible(true)
		end
	end
	
	BattleLayout:setFieldPosition(arg_2_1 == 1 and BATTLE_LAYOUT.XDIST_FROM_SIDE or BattleLayout:getFieldPosition() - BATTLE_LAYOUT.XDIST_FROM_SIDE)
end

function Battle.DoEnterAct_RunNew(arg_3_0, arg_3_1)
	local function var_3_0(arg_4_0)
		BattleLayout:setPause(true)
		BattleUI:setIndividualShow(false)
	end
	
	local function var_3_1(arg_5_0)
		arg_5_0:DoMoveStage()
		BattleLayout:setPause(false)
		
		if arg_5_0.vars.pressed_next_button then
			arg_5_0:onClickNextButton(true)
		else
			BattleUI:setIndividualShow(true)
		end
	end
	
	local function var_3_2(arg_6_0)
		local var_6_0, var_6_1 = arg_6_0.model:getBonePosition("root")
		local var_6_2 = CACHE:getEffect("dust_landing")
		
		var_6_2:setCascadeOpacityEnabled(true)
		var_6_2:setPosition(var_6_0, var_6_1)
		var_6_2:setLocalZOrder(arg_6_0.z)
		var_6_2:setOpacity(70)
		BGI.main.layer:addChild(var_6_2)
		BattleAction:Add(SEQ(DMOTION("animation"), REMOVE()), var_6_2, "battle.enter")
	end
	
	for iter_3_0 = 1, 4 do
		local var_3_3 = arg_3_0.logic.friends[iter_3_0]
		
		if var_3_3 and not var_3_3:isDead() then
			if get_cocos_refid(var_3_3.model) then
				local var_3_4, var_3_5 = var_3_3.model:getPosition()
				
				var_3_3.model:setPositionX(var_3_4 - DESIGN_WIDTH / 2 * (arg_3_1 or 1))
				var_3_3.model:setVisible(true)
				
				if arg_3_0.logic:isSkillPreview() and var_3_3.db.code == "m9201" then
					var_3_3.model:setOpacity(0)
				end
			else
				Log.e("error ??", "왜 model이 날라갔을까? ")
			end
		end
	end
	
	if arg_3_0.logic.pet then
		local var_3_6 = arg_3_0.logic.pet
		
		if get_cocos_refid(var_3_6.model) then
			local var_3_7, var_3_8 = var_3_6.model:getPosition()
			
			var_3_6.model:setPositionX(var_3_7 - DESIGN_WIDTH / 2 * (arg_3_1 or 1))
			var_3_6.model:setVisible(true)
		end
	end
	
	BattleLayout:moveToFieldPosition(arg_3_1 == 1 and BATTLE_LAYOUT.XDIST_FROM_SIDE or BattleLayout:getFieldPosition() - BATTLE_LAYOUT.XDIST_FROM_SIDE)
end

function Battle.spawn(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if not arg_7_1 or not arg_7_2 then
		return 
	end
	
	set_high_fps_tick()
	Log.i("BATTLE", "SPAWN!", T(arg_7_1.db.name), T(arg_7_3.db.name), arg_7_1.inst.pos)
	
	local var_7_0, var_7_1 = BattleLayout:getUnitFieldPosition(arg_7_1)
	local var_7_2 = var_7_0
	local var_7_3 = var_7_1
	
	arg_7_3.init_x, arg_7_3.init_y, arg_7_3.init_z = arg_7_1.init_x, arg_7_1.init_y, arg_7_1.init_z
	arg_7_3.x, arg_7_3.y = var_7_0, var_7_1
	
	if arg_7_1 ~= arg_7_3 then
		BattleLayout:getTeamLayout(arg_7_1.inst.ally or FRIEND):swap(arg_7_1, arg_7_3)
	end
	
	arg_7_3.z = arg_7_1.init_z
	
	local var_7_4 = arg_7_3.model
	local var_7_5 = BattleLayout:getDirection() * (arg_7_3.inst.ally == FRIEND and 1 or -1)
	
	if not get_cocos_refid(var_7_4) or not BGI.main.layer:getChildByName("model." .. arg_7_3.inst.uid) then
		var_7_4 = CACHE:getModel(arg_7_3.db.model_id, arg_7_3.db.skin, arg_7_0:getIdleAni(arg_7_3), arg_7_3.db.atlas, arg_7_3.db.model_opt)
		
		var_7_4:setScale(arg_7_3.db.scale)
		
		if arg_7_4 == "appear" then
			var_7_2 = var_7_2 - DESIGN_WIDTH / 2 * var_7_5
			var_7_3 = var_7_3 + DESIGN_HEIGHT / 4
		elseif arg_7_4 == "appear_by_tag" then
			var_7_2 = var_7_2 - DESIGN_WIDTH / 2 * var_7_5
		end
		
		arg_7_0:addModel(arg_7_3, var_7_4, arg_7_2, {
			x = var_7_2,
			y = var_7_3,
			z = arg_7_1.init_z
		}, true)
		
		for iter_7_0, iter_7_1 in pairs(arg_7_3.states.List) do
			arg_7_0:onAddState(arg_7_3, iter_7_1)
		end
	end
	
	var_7_4:setColor(arg_7_0.vars.ambient_color)
	var_7_4:setScaleX(math.abs(var_7_4:getScaleX()) * var_7_5)
	var_7_4:setVisible(true)
	
	local function var_7_6(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = arg_8_1.model
		local var_8_1, var_8_2 = var_8_0:getBonePosition("root")
		
		if string.find(arg_8_2, ".cfx") then
			EffectManager:Play({
				fn = arg_8_2,
				layer = BGI.main.layer,
				x = var_8_1,
				y = var_8_2,
				z = arg_8_1.z + 1,
				action = BattleAction
			})
			BattleAction:Add(DELAY(2000), var_8_0, "battle.enter")
		else
			local var_8_3 = CACHE:getEffect(arg_8_2)
			
			var_8_3:setPosition(var_8_1, var_8_2)
			var_8_3:setLocalZOrder(arg_8_1.z)
			BGI.main.layer:addChild(var_8_3)
			BattleAction:Add(SEQ(DMOTION("animation"), REMOVE()), var_8_3, "battle.enter")
		end
	end
	
	local var_7_7
	local var_7_8
	local var_7_9
	local var_7_10
	
	if BattleDelay[arg_7_4] then
		local var_7_11
		
		var_7_11, var_7_9, var_7_10 = BattleDelay[arg_7_4]:getDelay()
	end
	
	local var_7_12 = arg_7_4 == "summon" and "bansheequeen_sk2_sommoneff.cfx" or (arg_7_4 ~= "replace" or nil) and "rescue_success.cfx"
	
	if arg_7_4 == "resurrect" then
		arg_7_3.inst.resurrect = false
	end
	
	var_7_4:setTimeScale(1)
	
	if arg_7_4 == "appear" then
		arg_7_3:onStartStage("before")
		arg_7_3:onStartStage("after")
		
		local var_7_13 = arg_7_0:getIdleAction(arg_7_3)
		
		if var_7_4:isExistAnimation("appear") then
			var_7_13 = MOTION("appear")
		end
		
		local var_7_14, var_7_15, var_7_16, var_7_17 = BattleDelay[arg_7_4]:getDelay()
		
		BattleAction:Add(SEQ(var_7_13, MOVE_TO(0, var_7_2, var_7_3), DELAY(var_7_15), SPAWN(JUMP_TO(var_7_16, var_7_0, var_7_1)), CALL(var_7_6, arg_7_0, arg_7_3, "dust_landing"), arg_7_0:getIdleAction(arg_7_3), MOVE_TO(var_7_17, var_7_0, var_7_1)), var_7_4, "battle.hidden_appear")
	elseif arg_7_4 == "appear_by_tag" then
		arg_7_3:onStartStage("before")
		arg_7_3:onStartStage("after")
		
		local var_7_18, var_7_19, var_7_20 = BattleDelay[arg_7_4]:getDelay()
		
		BattleAction:Add(SEQ(MOVE_TO(0, var_7_2, var_7_3), DELAY(var_7_19), SPAWN(MOTION("run", true), MOVE_TO(var_7_20, var_7_0, var_7_1))), var_7_4, "battle.hidden_appear")
	elseif arg_7_4 == "replace" then
		local var_7_21 = arg_7_1.model
		
		if get_cocos_refid(var_7_21) then
			var_7_21:setLocalZOrder(arg_7_1.init_z + 1)
		end
		
		if arg_7_1.ui_vars and arg_7_1.ui_vars.gauge then
			arg_7_1.ui_vars.gauge:setIndividualShow(false)
			arg_7_1.ui_vars.gauge:setVisible(false)
		end
		
		var_7_4:setOpacity(0)
		BattleAction:Add(SPAWN(TARGET(var_7_21, SEQ(FADE_OUT(var_7_10), DELAY(100), CALL(function()
			var_7_21:setVisible(false)
			BattleUtil:pendingClearUnits({
				arg_7_1
			})
		end))), SEQ(arg_7_0:getIdleAction(arg_7_3), DELAY(var_7_9), FADE_IN(var_7_10))), var_7_4, "battle.hidden_appear")
	else
		var_7_4:setOpacity(0)
		BattleAction:Add(SPAWN(arg_7_0:getIdleAction(arg_7_3), SEQ(DELAY(var_7_9), FADE_IN(var_7_10)), CALL(var_7_6, arg_7_0, arg_7_3, var_7_12)), var_7_4, "battle.hidden_appear")
	end
	
	if arg_7_3.ui_vars.gauge then
		arg_7_3.ui_vars.gauge.control:setVisible(true)
	end
end

function Battle.tagEffect(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = 0
	local var_10_1 = 1000
	local var_10_2, var_10_3 = arg_10_2:getBonePosition("target")
	local var_10_4 = arg_10_2:getLocalZOrder() + 1
	local var_10_5 = arg_10_2:getScaleX()
	local var_10_6, var_10_7 = BattleLayout:getUnitFieldPosition(arg_10_1)
	local var_10_8 = var_10_6
	local var_10_9 = var_10_7
	local var_10_10 = BattleLayout:getDirection() * (arg_10_1.inst.ally == FRIEND and 1 or -1)
	local var_10_11 = var_10_8 - DESIGN_WIDTH * 0.6 * var_10_10
	
	if arg_10_1.ui_vars and arg_10_1.ui_vars.gauge then
		arg_10_1.ui_vars.gauge:setIndividualShow(false)
		arg_10_1.ui_vars.gauge:setVisible(false)
	end
	
	BattleAction:Add(SEQ(DELAY(var_10_0), CALL(function()
		EffectManager:Play({
			fn = "stse_tag.cfx",
			layer = BGI.main.layer,
			pivot_x = var_10_2,
			pivot_y = var_10_3,
			pivot_z = var_10_4
		})
	end), DELAY(1200), SCALEX(0, arg_10_2:getScaleX(), -arg_10_2:getScaleX()), MOTION("run", true), MOVE_TO(500, var_10_11, var_10_9), FADE_OUT(100), SHOW(false), CALL(BattleUtil.clearUnits, BattleUtil, {
		arg_10_1
	})), arg_10_2, "block")
	UIBattleAttackOrder:update(arg_10_1)
end

function Battle.deadEffect(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	if not get_cocos_refid(arg_12_2) then
		return 
	end
	
	local var_12_0 = 300
	local var_12_1 = 1000
	local var_12_2 = DB("character_scale", arg_12_1.db.code, "die_effect")
	
	arg_12_2:setOpacity(255)
	SoundEngine:playBattle("event:/model/dead")
	SoundEngine:play("event:/voc/character/" .. arg_12_1.db.model_id .. "/evt/dead")
	
	arg_12_0.vars.last_dead_model_id = arg_12_1.db.model_id
	
	if arg_12_1:checkResurrectBlockEffect() then
		var_12_2 = "death_eff_02"
	end
	
	var_12_2 = var_12_2 or "death_eff_01"
	
	local var_12_3, var_12_4 = arg_12_2:getBonePosition("target")
	local var_12_5 = arg_12_2:getLocalZOrder() + 1
	local var_12_6 = arg_12_2:getScaleX()
	local var_12_7 = FADE_OUT(var_12_1)
	
	arg_12_4 = arg_12_4 or NONE()
	
	local var_12_8 = DB("character", arg_12_1.db.code, "die_action")
	
	if arg_12_1.inst.resurrect or arg_12_1:isResurrectionReserved() then
		arg_12_2:setColor(cc.c3b(30, 30, 30))
		BattleAction:Add(SEQ(DELAY(var_12_0), OPACITY(0, 1, 1), COLOR(0, 30, 30, 30), CALL(arg_12_2.setTimeScale, arg_12_2, 0), CALL(EffectManager.Play, EffectManager, var_12_2, BGI.main.layer, var_12_3, var_12_4, var_12_5, nil, var_12_6 < 0, nil, nil, true), var_12_7, arg_12_4), arg_12_2, "battle.dead")
	elseif var_12_8 == "run" then
		local var_12_9, var_12_10 = BattleLayout:getUnitFieldPosition(arg_12_1)
		local var_12_11 = var_12_9
		local var_12_12 = var_12_10
		local var_12_13 = BattleLayout:getDirection() * (arg_12_1.inst.ally == FRIEND and 1 or -1)
		local var_12_14 = var_12_11 - VIEW_WIDTH / 2 * var_12_13
		
		BattleAction:Add(SEQ(MOTION("idle", true), DELAY(var_12_0), SCALEX(0, arg_12_2:getScaleX(), -arg_12_2:getScaleX()), MOTION("run", true), MOVE_TO(1200, var_12_14, var_12_12), var_12_7, arg_12_4), arg_12_2)
	elseif var_12_8 == "idle" then
		BattleAction:Add(SEQ(MOTION("idle", true)), arg_12_2)
	else
		arg_12_2:setColor(cc.c3b(30, 30, 30))
		BattleAction:Add(SEQ(DELAY(var_12_0), OPACITY(0, 1, 1), COLOR(0, 30, 30, 30), CALL(arg_12_2.setTimeScale, arg_12_2, 0), CALL(EffectManager.Play, EffectManager, var_12_2, BGI.main.layer, var_12_3, var_12_4, var_12_5, nil, var_12_6 < 0, nil, nil, true), var_12_7, arg_12_4), arg_12_2, "battle.dead")
	end
	
	UIBattleAttackOrder:update(arg_12_1)
	
	if arg_12_3 then
		BattleAction:Add(DELAY(var_12_0 + var_12_1), arg_12_2, "battle")
	end
	
	Log.i("BATTLE", "DEAD_FINAL", arg_12_3)
	
	return var_12_0 + var_12_1
end

function Battle.swapTeam(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.appear_units
	local var_13_1 = arg_13_1.disappear_units
	local var_13_2 = arg_13_1.st_time or 0
	local var_13_3 = arg_13_1.in_time or 0
	local var_13_4 = arg_13_1.out_time or 0
	local var_13_5 = arg_13_1.mid_time or 0
	
	local function var_13_6(arg_14_0)
		Log.i("appear", arg_14_0:getName())
		
		local var_14_0 = arg_14_0.model
		local var_14_1, var_14_2 = var_14_0:getBonePosition("target")
		local var_14_3 = var_14_0:getLocalZOrder() + 1
		local var_14_4, var_14_5 = BattleLayout:getUnitFieldPosition(arg_14_0)
		local var_14_6 = var_14_4
		local var_14_7 = var_14_5
		local var_14_8 = BattleLayout:getDirection() * (arg_14_0.inst.ally == FRIEND and 1 or -1)
		local var_14_9 = var_14_4 - DESIGN_WIDTH * 0.6 * var_14_8
		
		var_14_0:setPositionX(var_14_9)
		var_14_0:setPositionY(var_14_5)
		BattleAction:Add(SEQ(DELAY(var_13_5), SHOW(true), MOTION("run", true), MOVE_TO(var_13_3, var_14_6, var_14_7), MOTION("idle", true), DELAY(1000)), var_14_0, "battle.proc_lock")
		BattleUI:updateUnitFaces()
		UIBattleAttackOrder:update(arg_14_0)
	end
	
	local function var_13_7(arg_15_0)
		Log.i("disappear", arg_15_0:getName())
		
		local var_15_0 = arg_15_0.model
		local var_15_1, var_15_2 = var_15_0:getBonePosition("target")
		local var_15_3 = var_15_0:getLocalZOrder() + 1
		local var_15_4, var_15_5 = BattleLayout:getUnitFieldPosition(arg_15_0)
		local var_15_6 = var_15_4
		local var_15_7 = var_15_5
		local var_15_8 = BattleLayout:getDirection() * (arg_15_0.inst.ally == FRIEND and 1 or -1)
		local var_15_9 = var_15_6 - DESIGN_WIDTH * 0.6 * var_15_8
		
		if arg_15_0.ui_vars and arg_15_0.ui_vars.gauge then
			arg_15_0.ui_vars.gauge:setIndividualShow(false)
			arg_15_0.ui_vars.gauge:setVisible(false)
			UIBattleAttackOrder:removeCtrl(arg_15_0)
		end
		
		BattleAction:Add(SEQ(SCALEX(0, var_15_0:getScaleX(), -var_15_0:getScaleX()), MOTION("run", true), MOVE_TO(var_13_4, var_15_9, var_15_7), FADE_OUT(100), SHOW(false), CALL(BattleUtil.clearUnits, BattleUtil, {
			arg_15_0
		})), var_15_0, "battle.proc_lock")
		UIBattleAttackOrder:update(arg_15_0)
	end
	
	Battle:layoutFriends()
	UIBattleAttackOrder:hide(200)
	BattleUI:hideSkillButtons()
	BattleAction:Add(SEQ(DELAY(var_13_2), CALL(function()
		for iter_16_0, iter_16_1 in pairs(var_13_0 or {}) do
			var_13_6(iter_16_1)
		end
		
		for iter_16_2, iter_16_3 in pairs(var_13_1 or {}) do
			var_13_7(iter_16_3)
		end
	end)), arg_13_0, "battle.team_change")
end

function Battle.onCreviceReturn(arg_17_0, arg_17_1)
	local var_17_0 = 0
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.logic.friends) do
		if not iter_17_1:isDead() and get_cocos_refid(iter_17_1.model) then
			local var_17_1, var_17_2 = iter_17_1.model:getBonePosition("root")
			
			BattleAction:Add(SEQ(DELAY(var_17_0), CALL(function()
				local var_18_0 = EffectManager:Play({
					scale = 1,
					fn = "ui_crevicehunt_return.cfx",
					layer = BGI.main.layer,
					x = var_17_1,
					y = var_17_2,
					z = iter_17_1.z + 1
				})
			end), FADE_OUT(800), SHOW(false), DELAY(400)), iter_17_1.model, "battle.crevice_return")
			
			var_17_0 = var_17_0 + 300
		end
	end
	
	local var_17_3 = arg_17_0.logic.pet
	
	if var_17_3 and get_cocos_refid(var_17_3.model) then
		local var_17_4, var_17_5 = var_17_3.model:getBonePosition("root")
		
		BattleAction:Add(SEQ(DELAY(600), CALL(function()
			local var_19_0 = EffectManager:Play({
				scale = 0.4,
				fn = "ui_crevicehunt_return.cfx",
				layer = BGI.main.layer,
				x = var_17_4,
				y = var_17_5,
				z = var_17_3.z + 1
			})
		end), FADE_OUT(800), SHOW(false)), var_17_3.model, "battle.crevice_return")
	end
end

function Battle.onBurningPhase(arg_20_0, arg_20_1)
	if arg_20_1.phase == "enter" then
		arg_20_0:onBurningPhaseEnter(arg_20_1)
	elseif arg_20_1.phase == "finish" then
		arg_20_0:onBurningPhaseFinish(arg_20_1)
	end
end

function Battle.onBurningPhaseEnter(arg_21_0, arg_21_1)
	local function var_21_0(arg_22_0, arg_22_1)
		local var_22_0 = arg_22_0.model
		local var_22_1, var_22_2 = var_22_0:getBonePosition("root")
		
		if string.find(arg_22_1, ".cfx") then
			EffectManager:Play({
				fn = arg_22_1,
				layer = BGI.main.layer,
				x = var_22_1,
				y = var_22_2,
				z = arg_22_0.z + 1,
				action = BattleAction
			})
			BattleAction:Add(DELAY(2000), var_22_0, "battle.enter")
		else
			local var_22_3 = CACHE:getEffect(arg_22_1)
			
			var_22_3:setPosition(var_22_1, var_22_2)
			var_22_3:setLocalZOrder(arg_22_0.z)
			BGI.main.layer:addChild(var_22_3)
			BattleAction:Add(SEQ(DMOTION("animation"), REMOVE()), var_22_3, "battle.enter")
		end
	end
	
	set_high_fps_tick()
	
	local var_21_1 = arg_21_1.appear_units
	local var_21_2 = arg_21_1.remain_units
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.disappear_unit_models or {}) do
		iter_21_1:setVisible(false)
	end
	
	for iter_21_2, iter_21_3 in pairs(var_21_2 or {}) do
		local var_21_3 = iter_21_3.model
		local var_21_4 = arg_21_0:getIdleAction(iter_21_3)
		local var_21_5 = "battle.hidden_appear2." .. tostring(iter_21_2)
		
		BattleAction:Add(SEQ(var_21_4), var_21_3, var_21_5)
	end
	
	Battle:layoutFriends()
	BattleUI:setIndividualShow(false)
	BattleUI:updateUnitFaces()
	
	for iter_21_4, iter_21_5 in pairs(var_21_1 or {}) do
		local var_21_6, var_21_7 = BattleLayout:getUnitFieldPosition(iter_21_5)
		local var_21_8 = var_21_6
		local var_21_9 = var_21_7
		
		iter_21_5.x, iter_21_5.y = var_21_6, var_21_7
		
		local var_21_10 = iter_21_5.model
		local var_21_11 = BattleLayout:getDirection() * (iter_21_5.inst.ally == FRIEND and 1 or -1)
		local var_21_12 = var_21_8 - DESIGN_WIDTH / 2 * var_21_11
		local var_21_13 = var_21_9 + DESIGN_HEIGHT / 4
		
		var_21_10:setColor(arg_21_0.vars.ambient_color)
		var_21_10:setScaleX(math.abs(var_21_10:getScaleX()) * var_21_11)
		var_21_10:setVisible(false)
		iter_21_5:onStartStage("before")
		iter_21_5:onStartStage("after")
		
		local var_21_14 = arg_21_0:getIdleAction(iter_21_5)
		
		if var_21_10:isExistAnimation("appear") then
			var_21_14 = MOTION("appear")
		end
		
		local var_21_15, var_21_16, var_21_17, var_21_18 = BattleDelay.appear:getDelay()
		local var_21_19 = "battle.hidden_appear." .. tostring(iter_21_4)
		
		BattleAction:Add(SEQ(var_21_14, MOVE_TO(0, var_21_12, var_21_13), DELAY(200), SPAWN(CALL(function()
			var_21_10:setVisible(true)
		end), JUMP_TO(300, var_21_6, var_21_7)), CALL(var_21_0, iter_21_5, "dust_landing"), arg_21_0:getIdleAction(iter_21_5), MOVE_TO(var_21_18, var_21_6, var_21_7)), var_21_10, var_21_19)
	end
end

function Battle.onBurningPhaseFinish(arg_24_0, arg_24_1)
	arg_24_0.vars.disappear_unit_models = arg_24_0.vars.disappear_unit_models or {}
	
	for iter_24_0, iter_24_1 in pairs(arg_24_1.disappear_units or {}) do
		BattleLayout:getTeamLayout(FRIEND):removeUnitSlot(iter_24_1)
	end
	
	arg_24_0:setAutoSpecifyTarget(nil)
	
	local var_24_0 = arg_24_1.params
	
	BattleLayout:setPauseByTag(true, "phase.finish")
	UIAction:Add(SEQ(DELAY((var_24_0.edelay or 0) * 1000), CALL(function()
		BattleLayout:setPauseByTag(false, "phase.finish")
	end)), arg_24_0, "block")
	BattleAction:Add(SEQ(DELAY((var_24_0.sdelay or 0) * 1000), SPAWN(CALL(function()
		for iter_26_0, iter_26_1 in pairs(arg_24_1.disappear_units or {}) do
			table.insert(arg_24_0.vars.disappear_unit_models, iter_26_1.model)
			
			if iter_26_1.ui_vars.gauge then
				iter_26_1.ui_vars.gauge:setIndividualShow(false)
				iter_26_1.ui_vars.gauge:setVisible(false)
			end
			
			BattleAction:Add(TARGET(iter_26_1.model, MOTION("groggy", true)), iter_26_1.model)
			
			local var_26_0 = "top"
			local var_26_1 = "stse_stun.cfx"
			local var_26_2 = iter_26_1.model:addPartsObject({
				always_visible = false,
				scale = 1,
				name = string.format("%s/%s", var_26_0 or "", var_26_1 or ""),
				source = var_26_1,
				bone = var_26_0
			}, "effect")
			
			if get_cocos_refid(var_26_2) and string.starts(var_26_1, "stse_") and iter_26_1.model:getScaleX() < 0 then
				var_26_2:setScaleX(-var_26_2:getScaleX())
			end
		end
	end), CALL(function()
		for iter_27_0, iter_27_1 in pairs(arg_24_1.enemy_list or {}) do
			local var_27_0 = iter_27_1.model
			local var_27_1 = arg_24_0:deadEffect(iter_27_1, iter_27_1.model, nil, nil)
			local var_27_2 = "battle.clear_unit" .. iter_27_1:getUID()
			
			if get_cocos_refid(var_27_0) then
				BattleAction:Add(SEQ(CALL(function()
					if iter_27_1.ui_vars then
						if iter_27_1.ui_vars.gauge then
							iter_27_1.ui_vars.gauge:setVisible(false)
						end
						
						if iter_27_1.ui_vars.condition_bar then
							iter_27_1.ui_vars.condition_bar:setVisible(false)
						end
					end
				end), DELAY(var_27_1 or 0), CALL(function()
					BattleUtil:clearUnits({
						iter_27_1
					})
				end)), var_27_0, var_27_2)
			end
		end
		
		BattleUI:updateUnitFaces()
		CameraManager:playCamera("default")
	end))), BattleUI.battle_wnd, "phase.finish.act")
end
