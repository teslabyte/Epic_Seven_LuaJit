local function var_0_0(arg_1_0, arg_1_1)
	if arg_1_1 then
		if arg_1_1 > 0 then
			return LOG(arg_1_0, math.max(2, arg_1_1))
		elseif arg_1_1 < 0 then
			return RLOG(arg_1_0, math.max(2, math.abs(arg_1_1)))
		end
	end
	
	return arg_1_0
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.x or 0
	local var_2_1 = arg_2_1.y or 0
	
	if not arg_2_1.disableAutoFlipX and arg_2_0.model:getScaleX() < 0 then
		var_2_0 = -var_2_0
	end
	
	return var_2_0, var_2_1
end

local function var_0_2(arg_3_0, arg_3_1)
	if arg_3_1 and string.sub(arg_3_1, 1, 1) == "$" then
		local var_3_0 = arg_3_0:getParam("unit").model:removeLocalCacheObject(arg_3_1)
		
		for iter_3_0, iter_3_1 in pairs(var_3_0) do
			stop_or_remove(iter_3_1)
		end
	else
		local var_3_1 = arg_3_0:getObject(arg_3_1)
		
		stop_or_remove(var_3_1)
		arg_3_0:setObject(arg_3_0, arg_3_1, nil)
	end
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 then
		return 
	end
	
	if string.sub(arg_4_1, 1, 1) == "$" then
		arg_4_0:getParam("unit").model:addLocalCacheObject(arg_4_1, arg_4_2)
	else
		arg_4_0:setObject(arg_4_1, arg_4_2)
	end
end

StateAction = ClassDef()

function StateAction.constructor(arg_5_0, arg_5_1)
	arg_5_0._updated = false
	arg_5_0.info = arg_5_1
	arg_5_0.elapsed_time = 0
	arg_5_0.TOTAL_TIME = 0
	arg_5_0.SCOPE_DURATION = 0
end

function StateAction.getName(arg_6_0)
	return arg_6_0.info.etty
end

function StateAction.createStoppable(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = cc.Node:create()
	local var_7_1 = arg_7_0.info.id or string.format("%p", var_7_0)
	
	var_7_0:setName(var_7_1)
	var_0_3(arg_7_1, arg_7_0.info.id, var_7_0)
	var_7_0:retain()
	SceneManager:getRunningNodeCollector():addChild(var_7_0)
	
	function var_7_0.stop(arg_8_0)
		BattleAction:Add(SEQ(arg_7_2 or NONE(), REMOVE()), var_7_0, "battle.skill")
	end
	
	return var_7_0
end

function StateAction.Enter(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_0._params = arg_9_3
	
	if not arg_9_0.info.without and arg_9_0.OnEnter and not arg_9_4 then
		if arg_9_0.on_data then
			for iter_9_0, iter_9_1 in pairs(arg_9_0.on_data) do
				arg_9_1:executeState(iter_9_1, arg_9_0, arg_9_0._params)
			end
		end
		
		arg_9_0:OnEnter(arg_9_1, arg_9_2, arg_9_3)
		
		if arg_9_0.action then
			arg_9_0._sender = arg_9_1:getActionSender()
			arg_9_0._action = Action:create(arg_9_0.action, arg_9_1:getActor())
		end
	end
	
	if arg_9_0.on_start then
		for iter_9_2, iter_9_3 in pairs(arg_9_0.on_start) do
			arg_9_1:executeState(iter_9_3, arg_9_0, arg_9_0._params)
		end
	end
end

function StateAction.Update(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.elapsed_time = arg_10_0.elapsed_time + (arg_10_2 or 0)
	
	if arg_10_0._action then
		arg_10_0._action:Update(arg_10_0._sender, arg_10_2)
	end
	
	arg_10_0._updated = true
end

function StateAction.Leave(arg_11_0, arg_11_1)
	if arg_11_0.OnLeave then
		arg_11_0:OnLeave(arg_11_1, from, arg_11_0._params)
	end
	
	arg_11_1:setCleanupFlags(arg_11_0)
	
	if arg_11_0.on_finish then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.on_finish) do
			arg_11_1:executeState(iter_11_1, arg_11_0, arg_11_0._params)
		end
	end
end

function StateAction.Cleanup(arg_12_0)
	arg_12_0.TOTAL_TIME = 0
	arg_12_0.on_start = nil
	arg_12_0.on_finish = nil
	
	if arg_12_0.OnCleanup then
		arg_12_0:OnCleanup()
	end
end

local var_0_4 = 1e-07

function StateAction.IsFinished(arg_13_0)
	if arg_13_0._action then
		return arg_13_0._action:IsFinished()
	end
	
	local var_13_0 = arg_13_0.TOTAL_TIME - arg_13_0.elapsed_time
	
	return arg_13_0._updated and (var_13_0 < 0 or var_13_0 < var_0_4 and var_13_0 > 0 - var_0_4)
end

StateDef = {}
StateDef.CONNECTION = ClassDef(StateAction)

function StateDef.CONNECTION.OnEnter(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0.info.delay or 0
	
	if var_14_0 > 0 then
		arg_14_0.action = SEQ(DELAY(var_14_0), CALL(arg_14_1.executeStateID, arg_14_1, arg_14_0.info.to, arg_14_2, arg_14_3))
	else
		arg_14_1:executeStateID(arg_14_0.info.to, arg_14_2, arg_14_3)
	end
end

function StateDef.CONNECTION.getDuration(arg_15_0, arg_15_1, arg_15_2)
	return arg_15_0.info.delay or 0
end

StateDef.ONEVENT = ClassDef(StateAction)

function StateDef.ONEVENT.OnEnter(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
end

StateDef.ACTOR = ClassDef(StateAction)

function StateDef.ACTOR.OnEnter(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if not arg_17_2.actor then
		return 
	end
	
	local var_17_0 = arg_17_1:realloc(arg_17_2.actor)
	local var_17_1 = arg_17_1:getEntryStateId(arg_17_0.info.state)
	
	print("entry_state_id", arg_17_0.info.state, var_17_1)
	StageStateManager:addActionHandler(var_17_0, var_17_1, arg_17_3)
end

StateDef.DELAY = ClassDef(StateAction)

function StateDef.DELAY.OnEnter(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0.TOTAL_TIME = arg_18_0.info.time or 0
end

function StateDef.DELAY.getDuration(arg_19_0, arg_19_1, arg_19_2)
	return arg_19_0.info.time or 0
end

StateDef.FIRE = ClassDef(StateAction)

function StateDef.FIRE.constructor(arg_20_0, arg_20_1)
	CACHE:getEffect(arg_20_0.info.effect)
end

function StateDef.FIRE.OnEnter(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0.TOTAL_TIME = 0
	
	local var_21_0 = {
		sender = "state.fire",
		unit = arg_21_3.unit,
		info = table.shallow_clone(arg_21_0.info)
	}
	
	arg_21_0.action = CALL(LuaEventDispatcher.dispatchEvent, LuaEventDispatcher, "battle.event", arg_21_0.info.name or "Fire", var_21_0)
end

function StateDef.FIRE.getDuration(arg_22_0, arg_22_1, arg_22_2)
	return 0
end

StateDef.HIT = ClassDef(StateAction)

function StateDef.HIT.constructor(arg_23_0, arg_23_1)
	CACHE:getEffect(arg_23_0.info.effect)
end

function StateDef.HIT.OnEnter(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0.TOTAL_TIME = 0
	
	local var_24_0 = {
		sender = "state.hit",
		unit = arg_24_3.unit,
		info = table.shallow_clone(arg_24_0.info)
	}
	
	arg_24_0.action = CALL(LuaEventDispatcher.dispatchEvent, LuaEventDispatcher, "battle.event", "Hit", var_24_0)
end

function StateDef.HIT.getDuration(arg_25_0, arg_25_1, arg_25_2)
	return 0
end

StateDef.IDLE = ClassDef(StateAction)

function StateDef.IDLE.OnEnter(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0.action = Battle:getIdleAction(arg_26_3.unit)
end

StateDef.SHADER = ClassDef(StateAction)

function StateDef.SHADER.OnEnter(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_0.info
	local var_27_1 = SHADER_METHOD[var_27_0.name or ""]
	
	if var_27_1 then
		local var_27_2 = arg_27_1:getActor()
		
		print(tolua.type(var_27_2), var_27_1, var_27_2:getName(), argument_unpack(string.split(var_27_0.args or "", ",")))
		var_27_1(var_27_2, argument_unpack(string.split(var_27_0.args or "", ",")))
	end
end

StateDef.ANI = ClassDef(StateAction)

function StateDef.ANI.OnEnter(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if arg_28_0:getDuration(arg_28_1, arg_28_2) > 0 then
		arg_28_0.action = DMOTION(arg_28_0.anim_name, arg_28_0.info.loop)
	else
		arg_28_0.action = NONE()
	end
end

function StateDef.ANI.getDuration(arg_29_0, arg_29_1, arg_29_2)
	if (not arg_29_0.anim_name or not arg_29_0.anim_duration) and arg_29_1 then
		arg_29_0.anim_name = arg_29_1:reformValue(arg_29_0.info.ani)
		
		local var_29_0 = NONE()
		
		if arg_29_0.anim_name and arg_29_0.anim_name ~= "" then
			local var_29_1 = arg_29_1:getActor()
			
			if var_29_1 and var_29_1.getAnimationDuration then
				arg_29_0.anim_duration = var_29_1:getAnimationDuration(arg_29_0.anim_name)
			end
		end
	end
	
	if arg_29_1:getValue("cutin_time_calc") and arg_29_1:getActor().getEvents then
		local var_29_2 = arg_29_1:getActor():getEvents(arg_29_0.anim_name)
		
		for iter_29_0, iter_29_1 in pairs(var_29_2 or {}) do
			if iter_29_1[1] == "cutin" then
				local var_29_3 = arg_29_1:getParam("skill_id") or "sk_10101_3"
				local var_29_4 = DB("skill", arg_29_1:getValue("id", var_29_3), "cutin")
				
				if var_29_4 then
					calc_cutin_playtime(arg_29_1, var_29_4)
				end
			end
		end
	end
	
	return arg_29_0.anim_duration * 1000
end

function StateDef.ANI.getAniName(arg_30_0)
	return arg_30_0.anim_name
end

function StateDef.ANI.getAniEvents(arg_31_0, arg_31_1)
	if not arg_31_0.anim_name then
		arg_31_0.anim_name = arg_31_1:reformValue(arg_31_0.info.ani)
	end
	
	return arg_31_1:getActor():getEvents(arg_31_0.anim_name)
end

StateDef.ANI_SCOPE = ClassDef(StateAction)

function StateDef.ANI_SCOPE.OnEnter(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_0:calcDuration(arg_32_1, arg_32_2)
end

function StateDef.ANI_SCOPE.calcDuration(arg_33_0, arg_33_1, arg_33_2)
	if StateDef.ANI ~= get_class_table(arg_33_2) then
		return 
	end
	
	local var_33_0 = arg_33_1:getActor()
	
	if not var_33_0.getEventTimings then
		return 
	end
	
	local var_33_1 = arg_33_2:getAniName()
	local var_33_2 = arg_33_2.anim_duration or 0
	local var_33_3, var_33_4 = var_33_0:getEventTimings(var_33_1, arg_33_0.info.from or "", arg_33_0.info.to or "")
	
	arg_33_0.SCOPE_DURATION = math.max(0, (var_33_4 or var_33_2) - (var_33_3 or 0)) * 1000
	arg_33_0.TOTAL_TIME = (var_33_3 or 0) * 1000
end

function StateDef.ANI_SCOPE.getDuration(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0.TOTAL_TIME == 0 or arg_34_0.SCOPE_DURATION == 0 then
		arg_34_0:calcDuration(arg_34_1, arg_34_2)
	end
	
	return arg_34_0.TOTAL_TIME or 0
end

StateDef.ANI_POS = ClassDef(StateAction)

function StateDef.ANI_POS.OnEnter(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_0.TOTAL_TIME = arg_35_0.info.delay or 0
end

function StateDef.ANI_POS.getDuration(arg_36_0, arg_36_1, arg_36_2)
	return arg_36_0.info.delay or 0
end

StateDef.PAUSE = ClassDef(StateAction)

function StateDef.PAUSE.OnEnter(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	pause()
end

StateDef.MOVE = ClassDef(StateAction)

function StateDef.MOVE.OnEnter(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_0.info.time or 0
	
	if arg_38_2 and arg_38_2.SCOPE_DURATION then
		var_38_0 = var_38_0 + (arg_38_2.SCOPE_DURATION or 0)
	end
	
	local var_38_1 = arg_38_1:getActor()
	local var_38_2 = arg_38_1:getValue("zorder_by_y")
	local var_38_3 = USER_ACT(UnitMoveAction(var_38_1, arg_38_0.info, arg_38_3, var_38_0, var_38_2))
	local var_38_4 = arg_38_0.info.curve
	
	if var_38_4 then
		arg_38_0.action = BEZIER(var_38_3, to_curve_table(var_38_4))
	else
		arg_38_0.action = var_0_0(var_38_3, arg_38_0.info.log)
	end
end

function StateDef.MOVE.getDuration(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0.info.time or 0
	
	if arg_39_2 and arg_39_2.SCOPE_DURATION then
		var_39_0 = var_39_0 + (arg_39_2.SCOPE_DURATION or 0)
	end
	
	return var_39_0
end

StateDef.CAM = ClassDef(StateAction)

function StateDef.CAM.OnEnter(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_0.info.time or 0
	
	if arg_40_2 and arg_40_2.SCOPE_DURATION then
		var_40_0 = var_40_0 + (arg_40_2.SCOPE_DURATION or 0)
	end
	
	arg_40_0.action = StageStateManager:getCameraAction(arg_40_3.unit, var_40_0, arg_40_0.info, arg_40_3, arg_40_1:getActor())
end

function StateDef.CAM.getDuration(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0.info.time or 0
	
	if arg_41_2 and arg_41_2.SCOPE_DURATION then
		var_41_0 = var_41_0 + (arg_41_2.SCOPE_DURATION or 0)
	end
	
	return var_41_0
end

StateDef.ZOOM = ClassDef(StateAction)

function StateDef.ZOOM.OnEnter(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_0.info.time or 0
	
	if arg_42_2 and arg_42_2.SCOPE_DURATION then
		var_42_0 = var_42_0 + (arg_42_2.SCOPE_DURATION or 0)
	end
	
	arg_42_0.action = StageStateManager:getZoomAction(arg_42_3.unit, var_42_0, arg_42_0.info, arg_42_3)
end

function StateDef.ZOOM.getDuration(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0.info.time or 0
	
	if arg_43_2 and arg_43_2.SCOPE_DURATION then
		var_43_0 = var_43_0 + (arg_43_2.SCOPE_DURATION or 0)
	end
	
	return var_43_0
end

StateDef.SHAKE = ClassDef(StateAction)

function StateDef.SHAKE.constructor(arg_44_0)
	StageUtils.prepareCameraAni(arg_44_0.info.source)
end

function StateDef.SHAKE.OnEnter(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	arg_45_0.info.name = "state"
	arg_45_0.action = ShakeManager:createAction(arg_45_0.info)
end

function StateDef.SHAKE.getDuration(arg_46_0, arg_46_1, arg_46_2)
	return 0
end

StateDef.BGSHOW = ClassDef(StateAction)

function StateDef.BGSHOW.OnEnter(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	arg_47_0.action = SEQ(DELAY(arg_47_0.info.delay or 0), SPAWN(DELAY(arg_47_0.info.time or 0), CALL(function(arg_48_0, arg_48_1, arg_48_2)
		BattleField:setVisibleField(arg_48_0, arg_48_1, arg_48_2)
	end, arg_47_0.info.show or false, arg_47_0.info.time or 0, arg_47_0.info.id)))
end

function StateDef.BGSHOW.getDuration(arg_49_0, arg_49_1, arg_49_2)
	return arg_49_0.info.delay or 0
end

StateDef.LAYOUT = ClassDef(StateAction)

function StateDef.LAYOUT.OnEnter(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = USER_ACT(TeamLayoutEffect(arg_50_3.unit, arg_50_0.info, arg_50_3))
	local var_50_1 = arg_50_0.info.curve
	
	if var_50_1 then
		arg_50_0.action = BEZIER(var_50_0, to_curve_table(var_50_1))
	else
		arg_50_0.action = var_0_0(var_50_0, arg_50_0.info.log)
	end
end

function StateDef.LAYOUT.getDuration(arg_51_0, arg_51_1, arg_51_2)
	return arg_51_0.info.time or 0
end

StateDef.SPAWN = ClassDef(StateAction)

function StateDef.SPAWN.OnEnter(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	arg_52_0.TOTAL_TIME = 0
end

StateDef.CUTIN = ClassDef(StateAction)

function StateDef.CUTIN.OnEnter(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = string.split(arg_53_0.info.args, ",")
	local var_53_1 = arg_53_0.info.disableAutoFlipX
	local var_53_2 = {
		color = tocolor(arg_53_0.info.curtain_color or "0,0,0"),
		opacity = arg_53_0.info.curtain_opacity or 1
	}
	local var_53_3 = arg_53_3.unit
	local var_53_4
	
	if get_cocos_refid(var_53_3.model) then
		var_53_4 = not var_53_1 and BattleLayout:getAllyDirection(var_53_3.inst.ally, var_53_3.uid) < 0
	end
	
	local var_53_5 = {
		Update = function(arg_54_0, arg_54_1)
		end,
		IsFinished = function(arg_55_0, arg_55_1)
			if CocosSchedulerManager:isUseCustomSchForPoll() then
				return not (CocosSchedulerManager:getCurrentSchForPoll():getTimeScale() < 0.1)
			end
			
			return not PAUSED
		end
	}
	
	arg_53_0.action = SEQ(CALL(LuaEventDispatcher.dispatchEvent, LuaEventDispatcher, "battle.event", "Cutin", {}), CALL(StageStateManager.playBattleCutIn, StageStateManager, arg_53_1, var_53_0, var_53_4, var_53_2), USER_ACT(var_53_5))
end

function StateDef.CUTIN.getDuration(arg_56_0, arg_56_1, arg_56_2)
	if arg_56_1:getValue("cutin_time_calc") then
		local var_56_0 = string.split(arg_56_0.info.args, ",")
		local var_56_1
		
		if var_56_0[1] and string.len(var_56_0[1]) > 0 then
			var_56_1 = var_56_0[1]
		end
		
		local var_56_2 = arg_56_1:getParam("skill_id") or "sk_10101_3"
		
		var_56_1 = var_56_1 or DB("skill", arg_56_1:getValue("id", var_56_2), "cutin")
		
		calc_cutin_playtime(arg_56_1, var_56_1)
	end
	
	return 0
end

StateDef.STOP = ClassDef(StateAction)

function StateDef.STOP.OnEnter(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	local function var_57_0(arg_58_0, arg_58_1, arg_58_2)
		var_0_2(arg_58_0, arg_58_1.targetId)
	end
	
	arg_57_0.action = SEQ(DELAY(arg_57_0.info.delay or 0), CALL(var_57_0, arg_57_1, arg_57_0.info, arg_57_3))
end

function StateDef.STOP.getDuration(arg_59_0, arg_59_1, arg_59_2)
	return arg_59_0.info.delay or 0
end

StateDef.EFFECT = ClassDef(StateAction)

function StateDef.EFFECT.constructor(arg_60_0)
	CACHE:getEffect(arg_60_0.info.source)
end

function StateDef.EFFECT.OnEnter(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = arg_61_0.info
	
	if not var_61_0.source then
		return 
	end
	
	local var_61_1 = arg_61_3.unit
	local var_61_2 = var_61_0.location or LOCATION_TYPE_VER2.Screen_Center
	local var_61_3 = arg_61_1:reformValue(var_61_0.source)
	local var_61_4 = {}
	local var_61_5, var_61_6 = var_0_1(var_61_1, var_61_0)
	
	function var_61_4.Init(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
		local var_62_0 = var_61_0.id or string.format("%p:%s", arg_62_2, var_61_3)
		
		arg_62_0.effect = arg_62_2
		arg_62_0.TOTAL_TIME = arg_62_4
		arg_62_0.target_unit = arg_62_3
		arg_62_0.ignore_event = arg_62_5
		
		arg_62_0.effect:retain()
		arg_62_0.effect:setName(var_62_0)
		var_0_3(arg_61_1, var_62_0, arg_62_0.effect)
		
		local var_62_1
		
		if arg_61_3.att_info then
			var_62_1 = arg_61_3.att_info.d_unit_target
		end
		
		local var_62_2 = {
			a_unit = arg_61_3.unit,
			d_unit = arg_62_3,
			d_unit_target = var_62_1,
			actor = arg_62_2
		}
		
		if LOCATION_TYPE_VER2.Screen_Center == var_61_2 then
			arg_62_0.pivotObject = ScreenViewCenterPivot()
		else
			arg_62_0.pivotObject = StageStateManager:getLocationPivotObject(var_61_2, var_61_0.locationParam, var_61_0.locationForce, var_62_2)
		end
		
		if not arg_62_0.pivotObject then
			arg_62_0.action = NONE()
			
			return 
		end
		
		local var_62_3, var_62_4 = arg_62_0.pivotObject:getWorldPosition()
		
		if var_62_1 then
			var_62_3 = var_62_3 + math.random(-50, 50)
		end
		
		local var_62_5 = arg_62_0.pivotObject:getLocalZOrder()
		
		if var_61_0.inheritedScale or var_62_1 then
			local var_62_6 = math.abs(var_61_1.model:getScaleY())
			
			arg_62_0.init_scale = (var_61_0.scale or 1) * var_62_6
			arg_62_0.offset_x = (var_61_5 or 0) * var_62_6
			arg_62_0.offset_y = (var_61_6 or 0) * var_62_6
			arg_62_0.offset_z = var_61_0.z or 0
		else
			arg_62_0.init_scale = var_61_0.scale or 1
			arg_62_0.offset_x = var_61_5 or 0
			arg_62_0.offset_y = var_61_6 or 0
			arg_62_0.offset_z = var_61_0.z or 0
		end
		
		arg_62_0.init_x = var_62_3 + arg_62_0.offset_x
		arg_62_0.init_y = var_62_4 + arg_62_0.offset_y
		arg_62_0.init_z = var_62_5 + arg_62_0.offset_z
		arg_62_0.init_flip_x = not var_61_0.disableAutoFlipX and var_61_1.model:getScaleX() < 0
		
		arg_62_2:setPosition(arg_62_0.init_x, arg_62_0.init_y)
		arg_62_2:setLocalZOrder(arg_62_0.init_z)
		
		if arg_62_0.init_flip_x then
			arg_62_2:setScaleX(-arg_62_0.init_scale)
			arg_62_2:setScaleY(arg_62_0.init_scale)
		else
			arg_62_2:setScaleX(arg_62_0.init_scale)
			arg_62_2:setScaleY(arg_62_0.init_scale)
		end
	end
	
	function var_61_4.Update(arg_63_0)
		if not arg_63_0.started then
			arg_63_0.started = true
			
			local var_63_0 = true
			local var_63_1 = BGIManager:getBGI().main.layer
			
			EffectManager:EffectPlay({
				extractNodes = true,
				is_battle_effect = true,
				effect = arg_63_0.effect,
				layer = var_63_1,
				ancestor = var_63_1,
				x = arg_63_0.init_x,
				y = arg_63_0.init_y,
				z = arg_63_0.init_z,
				scale = arg_63_0.init_scale,
				flip_x = arg_63_0.init_flip_x,
				tag = {
					unit = var_61_1,
					ignore_event = arg_63_0.ignore_event
				}
			})
			
			if LOCATION_TYPE_VER2.Screen_Center == var_61_2 then
				arg_63_0.effect:setTransformParent(BGIManager:getBGI().game_layer)
			end
			
			if LOCATION_TYPE_ATTACH_TYPE_TABLE[var_61_2] then
				local function var_63_2()
				end
				
				arg_63_0.pivotObject:setFollower(arg_63_0.effect, arg_63_0.offset_x, arg_63_0.offset_y, arg_63_0.offset_z, var_63_2)
			end
		end
	end
	
	local var_61_7 = CACHE:getEffect(var_61_3)
	
	if not var_61_7 then
		return 
	end
	
	arg_61_0.actor = var_61_7
	arg_61_0.TOTAL_TIME = math.max(var_61_7:getDuration() * 1000, 0)
	
	local var_61_8 = {}
	
	if arg_61_3.att_info then
		local var_61_9 = false
		
		if LOCATION_TYPE_TARGETING_TYPE_TABLE[var_61_2] then
			local var_61_10 = true
			
			var_61_8 = arg_61_3.att_info.d_units
		else
			var_61_8 = {
				arg_61_3.att_info.d_unit
			}
		end
	else
		var_61_8 = {
			arg_61_3.unit
		}
	end
	
	local var_61_11 = var_61_7
	local var_61_12 = {}
	
	for iter_61_0, iter_61_1 in pairs(var_61_8) do
		local var_61_13 = copy_functions(var_61_4)
		local var_61_14 = var_61_11 or CACHE:getEffect(var_61_3)
		local var_61_15 = false
		
		if not var_61_11 then
			var_61_15 = true
		end
		
		var_61_11 = nil
		
		local var_61_16 = USER_ACT(var_61_13, var_61_14, iter_61_1, arg_61_0.TOTAL_TIME, var_61_15)
		
		table.insert(var_61_12, var_61_16)
	end
	
	arg_61_0.action = SPAWN(argument_unpack(var_61_12))
end

function StateDef.EFFECT.getDuration(arg_65_0, arg_65_1, arg_65_2)
	if arg_65_0.TOTAL_TIME == 0 then
		local var_65_0 = arg_65_1:reformValue(arg_65_0.info.source)
		local var_65_1 = CACHE:getEffect(var_65_0)
		
		if not var_65_1 then
			return 0
		end
		
		arg_65_0.TOTAL_TIME = math.max(var_65_1:getDuration() * 1000, 0)
	end
	
	return arg_65_0.TOTAL_TIME
end

StateDef.BGHATCH = ClassDef(StateAction)

function StateDef.BGHATCH.constructor(arg_66_0, arg_66_1)
	cc.Director:getInstance():getTextureCache():addImage("effect/hatch_type_01.sct")
end

function StateDef.BGHATCH.OnEnter(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local function var_67_0(arg_68_0)
		local var_68_0 = su.HatchSprite:create()
		
		var_68_0:setContentSize(DESIGN_WIDTH + 200, DESIGN_HEIGHT)
		
		local var_68_1 = cc.Director:getInstance():getTextureCache():addImage("effect/hatch_type_01.sct")
		
		var_68_0:setTexture(var_68_1)
		var_68_0:setSpeed({
			arg_68_0.speed0 or 0,
			arg_68_0.speed1 or 0,
			arg_68_0.speed2 or 0
		})
		var_68_0:setColors({
			tocolor(arg_68_0.color0 or "255,214,95,255"),
			tocolor(arg_68_0.color1 or "255,143,108,255"),
			tocolor(arg_68_0.color2 or "186,55,34,127")
		})
		var_68_0:setAccTime(0)
		var_68_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
		var_68_0:start()
		var_68_0:setVisible(false)
		
		return var_68_0
	end
	
	local var_67_1 = arg_67_3.unit
	local var_67_2 = arg_67_0.info
	local var_67_3, var_67_4 = var_0_1(var_67_1, var_67_2)
	local var_67_5 = var_67_0(var_67_2)
	local var_67_6 = 1
	local var_67_7 = var_67_2.fadeIn or 5
	local var_67_8 = var_67_2.fadeOut or 5
	local var_67_9 = var_67_2.time or 1000
	
	var_67_5:setOpacity(0)
	
	if var_67_2.localZ then
		var_67_5:setLocalZOrder(var_67_2.localZ)
	end
	
	function var_67_5.stop(arg_69_0)
		BattleAction:AddAsync(SEQ(FADE_OUT(var_67_8), REMOVE()), arg_69_0, "battle.skill")
	end
	
	local var_67_10 = var_67_2.rotate or 0
	
	if var_67_1.model:getScaleX() < 0 then
		var_67_6 = -var_67_6
	end
	
	var_67_5:setScale(var_67_2.scale or 1)
	var_67_5:setRotation(var_67_6 * var_67_10)
	var_67_5:setPosition(DESIGN_WIDTH / 2 + var_67_3, DESIGN_HEIGHT / 2 + var_67_4)
	var_0_3(arg_67_1, var_67_2.id, var_67_5)
	var_67_5:setScaleX(var_67_6 * math.abs(var_67_5:getScaleX()))
	BGIManager:getBGI().game_layer:addChild(var_67_5, -100)
	
	if var_67_9 < 0 then
		arg_67_0.action = TARGET(var_67_5, FADE_IN(var_67_7))
	else
		arg_67_0.action = TARGET(var_67_5, SEQ(SHOW(true), FADE_IN(var_67_7), DELAY(var_67_9), FADE_OUT(var_67_8), REMOVE()))
	end
end

function StateDef.BGHATCH.getDuration(arg_70_0, arg_70_1, arg_70_2)
	local var_70_0 = arg_70_0.info.fadeIn or 5
	local var_70_1 = arg_70_0.info.fadeOut or 5
	local var_70_2 = arg_70_0.info.time or 1000
	
	if var_70_2 < 0 then
		return var_70_0
	else
		return var_70_0 + var_70_1 + var_70_2
	end
end

StateDef.CALL = ClassDef(StateAction)

function StateDef.CALL.OnEnter(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	local var_71_0 = Battle["on" .. tostring(arg_71_0.info.method)]
	
	if not var_71_0 then
		arg_71_0.action = NONE()
		
		return 
	end
	
	arg_71_0.action = CALL(var_71_0, Battle, arg_71_3, argument_unpack(string.split(arg_71_0.info.args, ",")))
end

StateDef.SHOT = ClassDef(StateAction)

function StateDef.SHOT.OnEnter(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
	local var_72_0 = arg_72_0.info.time or 0
	
	if arg_72_2 and arg_72_2.SCOPE_DURATION then
		var_72_0 = var_72_0 + (arg_72_2.SCOPE_DURATION or 0)
	end
	
	arg_72_0.TOTAL_TIME = var_72_0
	arg_72_0.action = CALL(function()
		StageUtils.shotSkill(arg_72_1, arg_72_3.unit, arg_72_3.att_info.d_unit, arg_72_0.info, arg_72_3, var_72_0)
	end)
end

function StateDef.SHOT.getDuration(arg_74_0, arg_74_1, arg_74_2)
	local var_74_0 = arg_74_0.info.time or 0
	
	if arg_74_2 and arg_74_2.SCOPE_DURATION then
		var_74_0 = var_74_0 + (arg_74_2.SCOPE_DURATION or 0)
	end
	
	return var_74_0 + ((arg_74_0.info.count or 1) - 1) * (arg_74_0.info.interval or 0)
end

StateDef.HP_BAR = ClassDef(StateAction)

function StateDef.HP_BAR.OnEnter(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	local var_75_0 = arg_75_0.info
	local var_75_1 = var_75_0.alpha_channel or 1
	local var_75_2 = var_75_0.hpbar_target or HP_BAR_TARGET.Unit_Self
	local var_75_3 = var_75_0.duration or 1000
	local var_75_4 = var_75_0.fadeIn or 200
	local var_75_5 = var_75_0.fadeOut or 200
	local var_75_6 = 0
	
	if var_75_3 < 0 then
		local var_75_7 = var_75_4
	else
		local var_75_8 = var_75_4 + var_75_3 + var_75_5
	end
	
	local var_75_9 = {}
	
	if HP_BAR_TARGET.Unit_Self == var_75_2 then
		table.insert(var_75_9, arg_75_3.att_info.a_unit)
	elseif HP_BAR_TARGET.Unit_Target == var_75_2 then
		table.insert(var_75_9, arg_75_3.att_info.d_unit)
	elseif HP_BAR_TARGET.WithOut_Self == var_75_2 then
		local var_75_10 = arg_75_3.att_info.a_unit
		
		for iter_75_0, iter_75_1 in pairs(arg_75_3.units.friends) do
			if var_75_10 ~= iter_75_1 then
				table.insert(var_75_9, iter_75_1)
			end
		end
		
		for iter_75_2, iter_75_3 in pairs(arg_75_3.units.enemies) do
			if var_75_10 ~= iter_75_3 then
				table.insert(var_75_9, iter_75_3)
			end
		end
	elseif HP_BAR_TARGET.WithOut_Target == var_75_2 then
		local var_75_11 = arg_75_3.att_info.d_unit
		
		for iter_75_4, iter_75_5 in pairs(arg_75_3.units.friends) do
			if var_75_11 ~= iter_75_5 then
				table.insert(var_75_9, iter_75_5)
			end
		end
		
		for iter_75_6, iter_75_7 in pairs(arg_75_3.units.enemies) do
			if var_75_11 ~= iter_75_7 then
				table.insert(var_75_9, iter_75_7)
			end
		end
	elseif HP_BAR_TARGET.Unit_OurAll == var_75_2 then
		for iter_75_8, iter_75_9 in pairs(arg_75_3.units.friends) do
			table.insert(var_75_9, iter_75_9)
		end
	elseif HP_BAR_TARGET.Unit_ForAll == var_75_2 then
		for iter_75_10, iter_75_11 in pairs(arg_75_3.units.enemies) do
			table.insert(var_75_9, iter_75_11)
		end
	elseif HP_BAR_TARGET.All_Unit == var_75_2 then
		for iter_75_12, iter_75_13 in pairs(arg_75_3.units.enemies) do
			table.insert(var_75_9, iter_75_13)
		end
		
		for iter_75_14, iter_75_15 in pairs(arg_75_3.units.friends) do
			table.insert(var_75_9, iter_75_15)
		end
	else
		for iter_75_16, iter_75_17 in pairs(arg_75_3.units.friends) do
			table.insert(var_75_9, iter_75_17)
		end
		
		for iter_75_18, iter_75_19 in pairs(arg_75_3.units.enemies) do
			table.insert(var_75_9, iter_75_19)
		end
	end
	
	local var_75_12 = {
		unit_list = var_75_9,
		TOTAL_TIME = var_75_4,
		Start = function(arg_76_0)
		end,
		Update = function(arg_77_0, arg_77_1, arg_77_2)
			local var_77_0 = arg_77_1.elapsed_time + (arg_77_2 or 0)
			local var_77_1 = math.min(1, var_77_0 / arg_77_1.TOTAL_TIME)
			
			for iter_77_0, iter_77_1 in pairs(arg_77_0.unit_list) do
				local var_77_2 = iter_77_1.ui_vars
				
				if var_77_2 and var_77_2.gauge then
					var_77_2.gauge:setCustomOpacity((1 - (1 - var_75_1) * var_77_1) * 255)
				end
				
				if var_77_2 and var_77_2.condition_bar then
					var_77_2.condition_bar:setCustomOpacity((1 - (1 - var_75_1) * var_77_1) * 255)
				end
			end
		end
	}
	local var_75_13 = {
		unit_list = var_75_9,
		TOTAL_TIME = var_75_5,
		Update = function(arg_78_0, arg_78_1, arg_78_2)
			local var_78_0 = arg_78_1.elapsed_time + (arg_78_2 or 0)
			local var_78_1 = math.max(0, 1 - var_78_0 / arg_78_1.TOTAL_TIME)
			
			for iter_78_0, iter_78_1 in pairs(arg_78_0.unit_list) do
				local var_78_2 = iter_78_1.ui_vars
				
				if var_78_2 and var_78_2.gauge then
					var_78_2.gauge:setCustomOpacity((1 - (1 - var_75_1) * var_78_1) * 255)
				end
				
				if var_78_2 and var_78_2.condition_bar then
					var_78_2.condition_bar:setCustomOpacity((1 - (1 - var_75_1) * var_78_1) * 255)
				end
			end
		end,
		Finish = function(arg_79_0)
			for iter_79_0, iter_79_1 in pairs(arg_79_0.unit_list) do
				local var_79_0 = iter_79_1.ui_vars
				
				if var_79_0 and var_79_0.gauge then
					var_79_0.gauge:setCustomOpacity(nil)
				end
				
				if var_79_0 and var_79_0.condition_bar then
					var_79_0.condition_bar:setCustomOpacity(nil)
				end
			end
		end
	}
	
	if var_75_3 < 0 then
		arg_75_0:createStoppable(arg_75_1, USER_ACT(var_75_13))
		
		arg_75_0.action = USER_ACT(var_75_12)
	else
		arg_75_0.action = SEQ(USER_ACT(var_75_12), DELAY(var_75_3), USER_ACT(var_75_13))
	end
end

function StateDef.HP_BAR.getDuration(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0 = arg_80_0.info.duration or 1000
	local var_80_1 = arg_80_0.info.fadeIn or 5
	local var_80_2 = arg_80_0.info.fadeOut or 5
	local var_80_3 = 0
	
	if var_80_0 < 0 then
		var_80_3 = var_80_1
	else
		var_80_3 = var_80_1 + var_80_0 + var_80_2
	end
	
	return var_80_3
end

StateDef.COLOR_BLEND = ClassDef(StateAction)

function StateDef.COLOR_BLEND.OnEnter(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	local var_81_0 = arg_81_0.info
	local var_81_1 = toc4f(tocolor(var_81_0.color))
	local var_81_2 = var_81_0.alpha_channel or 1
	local var_81_3 = var_81_0.blend_target or BLEND_TARGET_VER2.Unit_Self
	local var_81_4 = var_81_0.duration or 1000
	local var_81_5 = var_81_0.fadeIn or 5
	local var_81_6 = var_81_0.fadeOut or 5
	local var_81_7 = var_81_0.category or "@StateDef/COLOR_BLEND"
	local var_81_8 = 0
	
	if var_81_4 < 0 then
		local var_81_9 = var_81_5
	else
		local var_81_10 = var_81_5 + var_81_4 + var_81_6
	end
	
	local var_81_11 = {}
	
	if BLEND_TARGET_VER2.Unit_Self == var_81_3 then
		table.insert(var_81_11, arg_81_3.att_info.a_unit)
	elseif BLEND_TARGET_VER2.Unit_Target == var_81_3 then
		table.insert(var_81_11, arg_81_3.att_info.d_unit)
	elseif BLEND_TARGET_VER2.WithOut_Self == var_81_3 then
		local var_81_12 = arg_81_3.att_info.a_unit
		
		for iter_81_0, iter_81_1 in pairs(arg_81_3.units.friends) do
			if var_81_12 ~= iter_81_1 then
				table.insert(var_81_11, iter_81_1)
			end
		end
		
		for iter_81_2, iter_81_3 in pairs(arg_81_3.units.enemies) do
			if var_81_12 ~= iter_81_3 then
				table.insert(var_81_11, iter_81_3)
			end
		end
	elseif BLEND_TARGET_VER2.WithOut_Target == var_81_3 then
		local var_81_13 = arg_81_3.att_info.d_unit
		
		for iter_81_4, iter_81_5 in pairs(arg_81_3.units.friends) do
			if var_81_13 ~= iter_81_5 then
				table.insert(var_81_11, iter_81_5)
			end
		end
		
		for iter_81_6, iter_81_7 in pairs(arg_81_3.units.enemies) do
			if var_81_13 ~= iter_81_7 then
				table.insert(var_81_11, iter_81_7)
			end
		end
	elseif BLEND_TARGET_VER2.Unit_OurAll == var_81_3 then
		for iter_81_8, iter_81_9 in pairs(arg_81_3.units.friends) do
			table.insert(var_81_11, iter_81_9)
		end
	elseif BLEND_TARGET_VER2.Unit_ForAll == var_81_3 then
		for iter_81_10, iter_81_11 in pairs(arg_81_3.units.enemies) do
			table.insert(var_81_11, iter_81_11)
		end
	else
		for iter_81_12, iter_81_13 in pairs(arg_81_3.units.friends) do
			table.insert(var_81_11, iter_81_13)
		end
		
		for iter_81_14, iter_81_15 in pairs(arg_81_3.units.enemies) do
			table.insert(var_81_11, iter_81_15)
		end
	end
	
	local var_81_14 = {
		unit_list = var_81_11,
		TOTAL_TIME = var_81_5,
		Start = function(arg_82_0)
			for iter_82_0, iter_82_1 in pairs(arg_82_0.unit_list) do
				if get_cocos_refid(iter_82_1.model) then
					iter_82_1.model:setVisibleOptionProp(false)
				end
			end
		end,
		Update = function(arg_83_0, arg_83_1, arg_83_2)
			local var_83_0 = arg_83_1.elapsed_time + (arg_83_2 or 0)
			local var_83_1 = math.min(1, var_83_0 / arg_83_1.TOTAL_TIME)
			
			for iter_83_0, iter_83_1 in pairs(arg_83_0.unit_list) do
				if get_cocos_refid(iter_83_1.model) then
					setBlendColor2(iter_83_1.model, var_81_7, var_81_1, var_81_1.a * var_83_1)
					iter_83_1.model:setOpacityByKey(var_81_7, (1 - (1 - var_81_2) * var_83_1) * 255)
				end
			end
		end
	}
	local var_81_15 = {
		unit_list = var_81_11,
		TOTAL_TIME = var_81_6,
		Update = function(arg_84_0, arg_84_1, arg_84_2)
			local var_84_0 = arg_84_1.elapsed_time + (arg_84_2 or 0)
			local var_84_1 = math.max(0, 1 - var_84_0 / arg_84_1.TOTAL_TIME)
			
			for iter_84_0, iter_84_1 in pairs(arg_84_0.unit_list) do
				if get_cocos_refid(iter_84_1.model) then
					setBlendColor2(iter_84_1.model, var_81_7, var_81_1, var_81_1.a * var_84_1)
					iter_84_1.model:setOpacityByKey(var_81_7, (1 - (1 - var_81_2) * var_84_1) * 255)
				end
			end
		end,
		Finish = function(arg_85_0)
			for iter_85_0, iter_85_1 in pairs(arg_85_0.unit_list) do
				if get_cocos_refid(iter_85_1.model) then
					iter_85_1.model:updateVisibleOptionProp()
				end
			end
		end
	}
	
	if var_81_4 < 0 then
		arg_81_0:createStoppable(arg_81_1, USER_ACT(var_81_15))
		
		arg_81_0.action = USER_ACT(var_81_14)
	else
		arg_81_0.action = SEQ(USER_ACT(var_81_14), DELAY(var_81_4), USER_ACT(var_81_15))
	end
end

function StateDef.COLOR_BLEND.getDuration(arg_86_0, arg_86_1, arg_86_2)
	local var_86_0 = arg_86_0.info.duration or 1000
	local var_86_1 = arg_86_0.info.fadeIn or 5
	local var_86_2 = arg_86_0.info.fadeOut or 5
	local var_86_3 = 0
	
	if var_86_0 < 0 then
		var_86_3 = var_86_1
	else
		var_86_3 = var_86_1 + var_86_0 + var_86_2
	end
	
	return var_86_3
end

StateDef.DARK = ClassDef(StateAction)

function StateDef.DARK.OnEnter(arg_87_0, arg_87_1, arg_87_2, arg_87_3)
	local var_87_0 = arg_87_0.info.time or arg_87_0.info.duration or 0
	
	if arg_87_2 and arg_87_2.SCOPE_DURATION then
		var_87_0 = var_87_0 + (arg_87_2.SCOPE_DURATION or 0)
	end
	
	local var_87_1 = BattleField:getPlayground() or arg_87_1:getActor():getParent()
	local var_87_2 = arg_87_0.info
	local var_87_3 = tocolor(var_87_2.color)
	local var_87_4 = var_87_2.fadeIn or 5
	local var_87_5 = var_87_2.fadeOut or 5
	local var_87_6 = var_87_2.opacity or 1
	local var_87_7 = get_curtain("white")
	
	var_87_7:setOpacity(0)
	
	if var_87_2.localZ then
		var_87_7:setLocalZOrder(var_87_2.localZ)
	else
		var_87_7:setLocalZOrder(9999)
	end
	
	var_87_7:setGlobalZOrder(var_87_2.globalZ or -1)
	var_87_1:addChild(var_87_7)
	
	if var_87_3 then
		var_87_7:setColor(var_87_3)
	end
	
	local var_87_8 = {
		setOpacity = function(arg_88_0, arg_88_1)
			BattleField:setForgroundOpacityByTag(arg_88_1 * 255, var_87_7)
		end
	}
	local var_87_9 = SPAWN(OPACITY(var_87_4, 0, var_87_6), LINEAR_CALL(var_87_4, var_87_8, "setOpacity", 1, 0))
	local var_87_10 = SPAWN(OPACITY(var_87_5, var_87_6, 0), LINEAR_CALL(var_87_5, var_87_8, "setOpacity", 0, 1))
	
	function var_87_7.stop(arg_89_0)
		BattleAction:AddAsync(SEQ(var_87_10, REMOVE()), arg_89_0, "battle.skill")
	end
	
	var_0_3(arg_87_1, var_87_2.id, var_87_7)
	
	if var_87_0 < 0 then
		arg_87_0.action = TARGET(var_87_7, SEQ(var_87_9, DELAY(var_87_4)))
	else
		arg_87_0.action = TARGET(var_87_7, SEQ(var_87_9, DELAY(var_87_0), var_87_10, REMOVE()))
	end
end

function StateDef.DARK.getDuration(arg_90_0, arg_90_1, arg_90_2)
	local var_90_0 = arg_90_0.info.time or arg_90_0.info.duration or 0
	
	if arg_90_2 and arg_90_2.SCOPE_DURATION then
		var_90_0 = var_90_0 + (arg_90_2.SCOPE_DURATION or 0)
	end
	
	local var_90_1 = arg_90_0.info.fadeIn or 5
	local var_90_2 = arg_90_0.info.fadeOut or 5
	
	if var_90_0 < 0 then
		return var_90_1
	else
		return var_90_1 + var_90_0 + var_90_2
	end
end

StateDef.BGSTAGE = ClassDef(StateAction)

function StateDef.BGSTAGE.OnEnter(arg_91_0, arg_91_1, arg_91_2, arg_91_3)
	local var_91_0 = arg_91_0.info
	local var_91_1 = arg_91_3.unit
	
	local function var_91_2(arg_92_0, arg_92_1, arg_92_2)
		local var_92_0 = arg_91_1:reformValue(arg_92_0.source)
		local var_92_1 = CACHE:getEffect(var_92_0)
		
		if var_92_1 then
			var_0_3(arg_91_1, arg_92_0.id, var_92_1)
			
			local var_92_2 = ScreenCenterPivot()
			local var_92_3, var_92_4 = var_92_2:getWorldPosition()
			local var_92_5 = var_92_2:getLocalZOrder()
			local var_92_6 = arg_92_0.x or 0
			local var_92_7 = arg_92_0.y or 0
			local var_92_8 = arg_92_0.z or 0
			
			var_92_1:setPosition(var_92_3 + var_92_6, var_92_4 + var_92_7)
			var_92_1:setLocalZOrder(var_92_5 + var_92_8)
			var_92_1:setGlobalZOrder(arg_92_0.globalZ or -10)
			var_92_1:setScale(arg_92_0.scale or 1)
			
			if not arg_92_0.fliplock and arg_92_1.model and arg_92_1.model:getScaleX() < 0 then
				var_92_1:setScaleX(-math.abs(var_92_1:getScaleX()))
			end
			
			BGIManager:getBGI().main.layer:addChild(var_92_1)
			var_92_1:start()
			var_92_2:setFollower(var_92_1, var_92_6, var_92_7, var_92_8)
		end
	end
	
	arg_91_0.action = SEQ(DELAY(var_91_0.delay or 0), CALL(var_91_2, var_91_0, var_91_1, arg_91_3))
end

function StateDef.BGSTAGE.getDuration(arg_93_0, arg_93_1, arg_93_2)
	return arg_93_0.info.delay or 0
end

StateDef.PPEFFECT = ClassDef(StateAction)

function StateDef.PPEFFECT.OnEnter(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local function var_94_0(arg_95_0, arg_95_1)
		local var_95_0 = cc.GLProgramCache:getInstance():getGLProgram(arg_95_0)
		
		if var_95_0 then
			local var_95_1 = cc.GLProgramState:create(var_95_0)
			
			if var_95_1 then
				local var_95_2 = arg_95_1.resolution_scale or 1
				
				if not arg_95_1.u_sample then
					local var_95_3 = 0
				end
				
				if not arg_95_1.u_range then
					local var_95_4 = 0
				end
				
				if not arg_95_1.u_weight then
					local var_95_5 = 0
				end
				
				if not arg_95_1.u_ratio then
					local var_95_6 = 0
				end
				
				var_95_1:setUniformVec2("u_resolution", {
					x = VIEW_WIDTH * (var_95_2 or 1),
					y = VIEW_HEIGHT * (var_95_2 or 1)
				})
				var_95_1:setUniformVec2("u_direction", {
					x = arg_95_1.direction_x or 0,
					y = arg_95_1.direction_y or 0
				})
				
				local var_95_7 = {
					u_weight = true,
					u_range = true,
					u_ratio = true,
					u_sample = true
				}
				
				for iter_95_0, iter_95_1 in pairs(var_95_7) do
					var_95_1:setUniformFloat(iter_95_0, 0)
				end
				
				StageUtils.setMetatable(arg_95_1, {
					__newindex = function(arg_96_0, arg_96_1, arg_96_2)
						if var_95_7[arg_96_1] and get_cocos_refid(var_95_1) then
							local var_96_0 = tonumber(arg_96_2)
							
							if var_96_0 then
								var_95_1:setUniformFloat(arg_96_1, var_96_0)
							end
						end
					end
				})
				
				local var_95_8 = BGIManager:getBGI().ppeffect_layer
				
				if var_95_8.addProcessGLProgramState then
					var_95_8:setPostProcessEnabled(true)
					var_95_8:addProcessGLProgramState(var_95_1, arg_95_0, 0)
				else
					var_95_8:setGLProgramState(var_95_1)
					var_95_8:setPostProcessEnabled(true)
				end
			end
		end
	end
	
	local function var_94_1(arg_97_0)
		local var_97_0 = BGIManager:getBGI().ppeffect_layer
		
		if var_97_0.removeProcessGLProgramStateByName then
			var_97_0:removeProcessGLProgramStateByName(arg_97_0)
		else
			var_97_0:setPostProcessEnabled(false)
		end
	end
	
	local var_94_2 = arg_94_0.info
	local var_94_3 = var_94_2.duration or 0
	local var_94_4 = var_94_2.program or "sprite_invert"
	local var_94_5 = CALL(var_94_0, var_94_4, arg_94_0.info)
	local var_94_6 = SEQ(WAIT_FRAME(1), CALL(var_94_1, var_94_4, arg_94_0.info))
	
	if LOW_RESOLUTION_MODE then
		arg_94_0.action = DELAY(var_94_3)
		
		return 
	end
	
	if (var_94_2.program == "sprite_blur" or var_94_2.program == "sprite_blur_vert" or var_94_2.program == "sprite_blur_horz") and SAVE and SAVE:getOptionData("option.blur_off", default_options.blur_off) then
		arg_94_0.action = DELAY(var_94_3)
		
		return 
	end
	
	if var_94_3 < 0 then
		arg_94_0:createStoppable(arg_94_1, var_94_6)
		
		arg_94_0.action = var_94_5
	else
		arg_94_0.action = SEQ(var_94_5, DELAY(var_94_3), var_94_6)
	end
end

StateDef.OBJ_MOVE_BY = ClassDef(StateAction)

function StateDef.OBJ_MOVE_BY.OnEnter(arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	local var_98_0 = arg_98_0.info
	local var_98_1 = var_98_0.time or 0
	local var_98_2 = var_98_0.curve or {
		0.5,
		0.5,
		0.5,
		0.5
	}
	local var_98_3 = var_98_0.x or 0
	local var_98_4 = var_98_0.y or 0
	local var_98_5 = {
		OBJECT_ID = var_98_0.targetId,
		TOTAL_TIME = var_98_1,
		Start = function(arg_99_0)
			local var_99_0 = arg_98_1:getObject(arg_99_0.OBJECT_ID)
			
			print("object move by : info.targetId", arg_99_0.OBJECT_ID, var_99_0)
			
			if not var_99_0 then
				return 
			end
			
			local var_99_1, var_99_2 = var_99_0:getPosition()
			local var_99_3 = math.normalize(var_99_0:getScaleX(), 1)
			local var_99_4 = BEZIER(MOVE_TO(var_98_1, var_99_1 + var_98_3 * var_99_3, var_99_2 + var_98_4), to_curve_table(var_98_2))
			
			BattleAction:Add(var_99_4, var_99_0, "battle.skill")
		end,
		Update = function(arg_100_0)
		end
	}
	
	arg_98_0.action = USER_ACT(var_98_5)
end

StateDef.OBJ_SCALE_TO = ClassDef(StateAction)

function StateDef.OBJ_SCALE_TO.OnEnter(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	local var_101_0 = arg_101_0.info
	local var_101_1 = var_101_0.time or 0
	local var_101_2 = var_101_0.curve or {
		0.5,
		0.5,
		0.5,
		0.5
	}
	local var_101_3 = var_101_0.scale or 1
	local var_101_4 = {
		OBJECT_ID = var_101_0.targetId,
		TOTAL_TIME = var_101_1,
		Start = function(arg_102_0)
			local var_102_0 = arg_101_1:getObject(arg_102_0.OBJECT_ID)
			
			print("object scale to : info.targetId", arg_102_0.OBJECT_ID, var_102_0)
			
			if not var_102_0 then
				return 
			end
			
			local var_102_1 = math.normalize(var_102_0:getScaleX(), 1)
			local var_102_2 = BEZIER(SPAWN(SCALE_TO_X(var_101_1, var_101_3 * var_102_1), SCALE_TO_Y(var_101_1, var_101_3)), to_curve_table(var_101_2))
			
			BattleAction:Add(var_102_2, var_102_0, "battle.skill")
		end,
		Update = function(arg_103_0)
		end
	}
	
	arg_101_0.action = USER_ACT(var_101_4)
end

StateDef.NODE_ANI = ClassDef(StateAction)

local var_0_5 = ClassDef()

function var_0_5.constructor(arg_104_0, arg_104_1, arg_104_2)
	arg_104_0.ref = arg_104_1
	arg_104_0.node = arg_104_1.model
	arg_104_0.opts = arg_104_2
	arg_104_0.direction = BattleLayout:getAllyDirection(arg_104_1.inst.ally, arg_104_1.uid)
	
	if arg_104_1.db then
		arg_104_0.init_scale_x = (arg_104_1.db.scale or 1) * arg_104_0.direction
		arg_104_0.init_scale_y = arg_104_1.db.scale or 1
	else
		arg_104_0.init_scale_x = arg_104_0.direction
		arg_104_0.init_scale_y = 1
	end
	
	arg_104_0.init_rotation = arg_104_1.rot
	arg_104_0.init_pos_y = arg_104_0.node:getPositionY()
	arg_104_0.init_offset_x = (tonumber(arg_104_2.offset_x) or 0) * arg_104_0.direction
	arg_104_0.init_offset_y = tonumber(arg_104_2.offset_y) or 0
	arg_104_0.is_screen_pivot = arg_104_2.screen_pivot
	arg_104_0.disable_restore = arg_104_2.disable_restore
end

function var_0_5.setPosition(arg_105_0, arg_105_1, arg_105_2)
	local var_105_0 = 0
	local var_105_1 = 0
	
	if arg_105_0.opts.pivot == "target" then
		local var_105_2 = arg_105_0.node:getRotation()
		local var_105_3 = math.rad(var_105_2)
		local var_105_4, var_105_5 = arg_105_0.node:getBonePosition("target")
		local var_105_6, var_105_7 = arg_105_0.node:getPosition()
		local var_105_8 = var_105_4 - var_105_6
		local var_105_9 = var_105_5 - var_105_7
		
		var_105_0 = math.cos(var_105_3) * var_105_8 - math.sin(var_105_3) * var_105_9 * -1
		var_105_1 = math.sin(var_105_3) * var_105_8 + math.cos(var_105_3) * var_105_9
	end
	
	if arg_105_0.is_screen_pivot then
		local var_105_10, var_105_11 = ScreenCenterPivot:getWorldPosition()
		
		arg_105_0.node:setPosition(var_105_10 + arg_105_1 + arg_105_0.init_offset_x - var_105_0, var_105_11 + arg_105_2 + arg_105_0.init_offset_y - var_105_1)
	else
		arg_105_0.node:setPosition(arg_105_0.ref.x + arg_105_1 + arg_105_0.init_offset_x - var_105_0, arg_105_0.ref.y + arg_105_2 + arg_105_0.init_offset_y - var_105_1)
	end
	
	local var_105_12 = arg_105_0.node:getPositionY() - arg_105_0.init_pos_y
	
	arg_105_0.node:setReverseY(var_105_12)
	arg_105_0.node:setShadowY(arg_105_2)
end

function var_0_5.getPosition(arg_106_0)
	return arg_106_0.node:getPosition()
end

function var_0_5.getScaleX(arg_107_0)
	return arg_107_0.node:getScaleX()
end

function var_0_5.getScaleY(arg_108_0)
	return arg_108_0.node:getScaleY()
end

function var_0_5.getRotation(arg_109_0)
	return arg_109_0.node:getRotation()
end

function var_0_5.setScaleX(arg_110_0, arg_110_1)
	arg_110_0.node:setScaleX(arg_110_1)
end

function var_0_5.setScaleY(arg_111_0, arg_111_1)
	arg_111_0.node:setScaleY(arg_111_1)
end

function var_0_5.setRotation(arg_112_0, arg_112_1)
	if arg_112_0.opts.disable_rotation_self then
		return 
	end
	
	arg_112_0.node:setRotation(arg_112_1)
end

function var_0_5.setAnimation(arg_113_0, arg_113_1, arg_113_2, arg_113_3)
	if not get_cocos_refid(arg_113_0.node) then
		return 
	end
	
	arg_113_0.node:setAnimation(arg_113_1, arg_113_2, arg_113_3)
end

function var_0_5.getAnimationDuration(arg_114_0, arg_114_1)
	if not get_cocos_refid(arg_114_0.node) then
		return 0
	end
	
	return arg_114_0.node:getAnimationDuration(arg_114_1)
end

function var_0_5.isValidate(arg_115_0)
	return get_cocos_refid(arg_115_0.node)
end

function var_0_5.cleanup(arg_116_0, arg_116_1)
	if not arg_116_1 and arg_116_0.disable_restore then
		return 
	end
	
	if arg_116_0.CLEANUP then
		return 
	end
	
	arg_116_0.CLEANUP = true
	
	local function var_116_0()
		if get_cocos_refid(arg_116_0.node) then
			arg_116_0.node:setPosition(arg_116_0.ref.x, arg_116_0.ref.y)
			arg_116_0.node:setScaleX(arg_116_0.init_scale_x)
			arg_116_0.node:setScaleY(arg_116_0.init_scale_y)
			arg_116_0.node:setRotation(arg_116_0.init_rotation)
			arg_116_0.node:setShadowY(0)
		end
	end
	
	arg_116_0.node:setReverseY(0)
	
	local var_116_1 = arg_116_0.ref
	local var_116_2 = Battle:getIdleAni(var_116_1) or "idle"
	
	if var_116_2 == "idle" and var_116_1.model:getLastAnimation() == "knock_down" then
		BattleAction:Add(SEQ(DMOTION("rise", false), MOTION(var_116_2, true), CALL(var_116_0)), var_116_1.model, "battle.skill")
	else
		BattleAction:Add(SPAWN(MOTION(var_116_2, true), CALL(var_116_0)), var_116_1.model, "battle.skill")
	end
end

function var_0_5.setVisibleAttachedModel(arg_118_0, arg_118_1)
	if get_cocos_refid(arg_118_0.node) then
		arg_118_0.node:setVisibleAttachedModel(arg_118_1)
	end
end

local var_0_6 = ClassDef()

function var_0_6.constructor(arg_119_0, arg_119_1, arg_119_2)
	local var_119_0, var_119_1 = arg_119_1:getPosition()
	
	arg_119_0.ref = {}
	arg_119_0.ref.x = var_119_0
	arg_119_0.ref.y = var_119_1
	arg_119_0.opts = arg_119_2
	arg_119_0.direction = BattleLayout:getAllyDirection(arg_119_1:getAlly())
	arg_119_0.init_scale_x = arg_119_1:getScaleX()
	arg_119_0.init_scale_y = arg_119_1:getScaleY()
	arg_119_0.init_rotation = arg_119_1:getRotation()
	arg_119_0.init_offset_x = (tonumber(arg_119_2.offset_x) or 0) * arg_119_0.direction
	arg_119_0.init_offset_y = tonumber(arg_119_2.offset_y) or 0
	arg_119_0.is_screen_pivot = arg_119_2.screen_pivot
	arg_119_0.disable_restore = arg_119_2.disable_restore
	arg_119_0.team_layout = arg_119_1
	
	arg_119_0.team_layout:setDisableRotationSelf(arg_119_2.disable_rotation_self)
	arg_119_0.team_layout:setDisableRotationTeam(arg_119_2.disable_rotation_team)
	arg_119_0.team_layout:setRotationPivot(arg_119_2.pivot)
	
	arg_119_0.node_list = {}
	
	local var_119_2 = arg_119_1:getUnits()
	
	for iter_119_0, iter_119_1 in pairs(var_119_2) do
		local var_119_3 = var_0_5(iter_119_1, {})
		
		if var_119_3:isValidate() then
			table.insert(arg_119_0.node_list, var_119_3)
		end
	end
end

function var_0_6.setPosition(arg_120_0, arg_120_1, arg_120_2)
	if arg_120_0.is_screen_pivot then
		local var_120_0 = BattleLayout:getTeamDistance() * 0.5 * BattleLayout:getDirection()
		local var_120_1 = -BATTLE_LAYOUT.TEAM_Y * 0.5 * BASE_SCALE
		
		arg_120_0.team_layout:setOffset(math.huge, math.huge, "@NodeANI")
		arg_120_0.team_layout:setPosition(var_120_0 + arg_120_1 + arg_120_0.init_offset_x, var_120_1 + arg_120_2 + arg_120_0.init_offset_y)
	else
		arg_120_0.team_layout:setOffset(arg_120_1 + arg_120_0.init_offset_x, arg_120_2 + arg_120_0.init_offset_y, "@NodeANI")
	end
	
	arg_120_0.team_layout:updatePose()
	arg_120_0.team_layout:updateModelPose()
end

function var_0_6.getScaleX(arg_121_0)
	return arg_121_0.team_layout:getScaleX()
end

function var_0_6.getScaleY(arg_122_0)
	return arg_122_0.team_layout:getScaleY()
end

function var_0_6.getRotation(arg_123_0)
	return arg_123_0.team_layout:getRotation()
end

function var_0_6.setScaleX(arg_124_0, arg_124_1)
	arg_124_0.team_layout:setScaleX(arg_124_1)
end

function var_0_6.setScaleY(arg_125_0, arg_125_1)
	arg_125_0.team_layout:setScaleY(arg_125_1)
end

function var_0_6.setRotation(arg_126_0, arg_126_1)
	arg_126_0.team_layout:setRotation(arg_126_1)
end

function var_0_6.setAnimation(arg_127_0, arg_127_1, arg_127_2, arg_127_3)
	for iter_127_0, iter_127_1 in pairs(arg_127_0.node_list) do
		if iter_127_1:isValidate() then
			iter_127_1:setAnimation(arg_127_1, arg_127_2, arg_127_3)
		end
	end
end

function var_0_6.getAnimationDuration(arg_128_0, arg_128_1)
	local var_128_0 = 0
	
	for iter_128_0, iter_128_1 in pairs(arg_128_0.node_list) do
		if iter_128_1:isValidate() then
			var_128_0 = math.max(var_128_0, iter_128_1:getAnimationDuration(arg_128_1) or 0)
		end
	end
	
	return var_128_0
end

function var_0_6.isValidate(arg_129_0)
	return not table.empty(arg_129_0.node_list)
end

function var_0_6.cleanup(arg_130_0, arg_130_1)
	if not arg_130_1 and arg_130_0.disable_restore then
		return 
	end
	
	if arg_130_0.CLEANUP then
		return 
	end
	
	arg_130_0.CLEANUP = true
	
	arg_130_0.team_layout:initPosition()
	arg_130_0.team_layout:initScale()
	arg_130_0.team_layout:setOffset(0, 0, "@NodeANI")
	arg_130_0.team_layout:setRotationPivot("root")
	arg_130_0.team_layout:setRotation(arg_130_0.init_rotation)
	arg_130_0.team_layout:updatePose()
	arg_130_0.team_layout:updateModelPose()
	
	for iter_130_0, iter_130_1 in pairs(arg_130_0.node_list) do
		iter_130_1:cleanup()
	end
	
	arg_130_0.node_list = {}
end

function var_0_6.setVisibleAttachedModel(arg_131_0, arg_131_1)
	for iter_131_0, iter_131_1 in pairs(arg_131_0.node_list) do
		arg_131_0.node:setVisibleAttachedModel(arg_131_1)
	end
end

local function var_0_7(arg_132_0)
	if not arg_132_0.source then
		return 
	end
	
	if not string.find(arg_132_0.source, "/") then
		return "spani/" .. arg_132_0.source
	end
	
	return arg_132_0.source
end

function StateDef.NODE_ANI.constructor(arg_133_0, arg_133_1)
	local var_133_0 = var_0_7(arg_133_1)
	
	if var_133_0 then
		sp.SkeletonAnimation:create(var_133_0)
	end
end

function StateDef.NODE_ANI.OnEnter(arg_134_0, arg_134_1, arg_134_2, arg_134_3)
	local var_134_0 = arg_134_0.info
	
	if not var_134_0.source then
		return 
	end
	
	local var_134_1 = "bone"
	
	if var_134_0.bone and var_134_0.bone ~= "" then
		var_134_1 = var_134_0.bone
	end
	
	local var_134_2 = arg_134_3.unit
	local var_134_3 = arg_134_3.att_info.a_unit
	local var_134_4
	local var_134_5 = StageUtils.getEnemyAlly(var_134_2.inst.ally)
	
	if NODEANI_TARGET.Unit_Self == var_134_0.target_node then
		var_134_4 = var_0_5(arg_134_3.att_info.a_unit, var_134_0)
	elseif NODEANI_TARGET.Unit_Target == var_134_0.target_node then
		var_134_4 = var_0_5(arg_134_3.att_info.d_unit, var_134_0)
	elseif NODEANI_TARGET.Team_Self == var_134_0.target_node then
		var_134_4 = var_0_6(BattleLayout:getTeamLayout(var_134_2.inst.ally), var_134_0)
	elseif NODEANI_TARGET.Team_Target == var_134_0.target_node then
		var_134_4 = var_0_6(BattleLayout:getTeamLayout(var_134_5), var_134_0)
	else
		var_134_4 = var_0_5(arg_134_3.att_info.d_unit, var_134_0)
	end
	
	arg_134_0.target_node = var_134_4
	
	local var_134_6 = var_134_0.time_scale or 1
	
	if var_134_6 == 0 then
		var_134_6 = 1
	end
	
	local var_134_7 = var_134_0.additional_time or 0
	local var_134_8 = var_0_7(var_134_0)
	local var_134_9 = sp.SkeletonAnimation:create(var_134_8)
	
	if not var_134_9 then
		return 
	end
	
	local var_134_10 = var_134_9:getBoneNode(var_134_1)
	
	if not var_134_10 then
		return 
	end
	
	var_134_10:setInheritScale(true)
	var_134_10:setInheritRotation(true)
	BGIManager:getBGI().game_layer:addChild(var_134_9)
	
	local var_134_11 = var_134_9:getAnimationDuration("animation")
	local var_134_12, var_134_13 = (function()
		local var_135_0 = var_134_11 * 1000 / var_134_6
		local var_135_1 = var_134_0.timeline
		
		if type(var_135_1) ~= "table" then
			return {}, var_135_0
		end
		
		local var_135_2 = {}
		
		for iter_135_0, iter_135_1 in pairs(var_135_1) do
			local var_135_3 = {}
			local var_135_4 = string.split(iter_135_1, ",")
			
			if type(var_135_4[2]) == "string" then
				var_135_3.time = (tonumber(var_135_4[1]) or 0) / 1000
				
				if var_135_4[2] == "@hit" then
					var_135_3.event = "hit"
				else
					var_135_3.event = "ani"
					var_135_3.name = var_135_4[2]
					var_135_3.loop = tonumber(var_135_4[3]) == 1
				end
				
				table.insert(var_135_2, var_135_3)
			end
		end
		
		table.sort(var_135_2, function(arg_136_0, arg_136_1)
			return arg_136_0.time < arg_136_1.time
		end)
		
		local var_135_5
		local var_135_6 = 0
		local var_135_7 = 0
		
		for iter_135_2 = table.count(var_135_2), 1, -1 do
			local var_135_8 = var_135_2[iter_135_2]
			
			if var_135_8.event == "ani" then
				local var_135_9 = var_134_4:getAnimationDuration(var_135_8.name) or 0
				local var_135_10 = var_135_8.name
				
				var_135_6 = var_135_8.time * 1000
				
				if var_135_8.name == "idle" and var_135_8.loop == true then
					var_135_7 = 0
					
					break
				end
				
				var_135_7 = var_135_9 * 1000
				
				break
			end
		end
		
		local var_135_11 = var_135_6 / var_134_6 + var_135_7
		
		return var_135_2, math.max(var_135_0, var_135_11)
	end)()
	local var_134_14 = {
		TOTAL_TIME = var_134_13 + var_134_7,
		ANINODE = var_134_9,
		BONE = var_134_10,
		TARGET_NODE = var_134_4,
		TIME_SCALE = var_134_6,
		TIMELINE = var_134_12,
		ACTOR_DIRECTION = not var_134_0.disableAutoFlipX and BattleLayout:getAllyDirection(var_134_3.inst.ally, var_134_3.uid) or 1,
		ExecTimeline = function(arg_137_0)
			local var_137_0 = arg_137_0.ANINODE:getCurrent()
			
			if not var_137_0 then
				return 
			end
			
			for iter_137_0, iter_137_1 in pairs(arg_137_0.TIMELINE) do
				if iter_137_1.time > var_137_0.time then
					break
				end
				
				arg_137_0.TIMELINE[iter_137_0] = nil
				
				if iter_137_1.event == "ani" then
					print("act.event", iter_137_1.event, iter_137_1.name, iter_137_1.loop)
					arg_137_0.TARGET_NODE:setAnimation(0, iter_137_1.name, iter_137_1.loop)
				elseif iter_137_1.event == "hit" then
					LuaEventDispatcher:dispatchEvent("battle.event", "Fire", {
						sender = "node_ani",
						unit = var_134_3
					})
				end
			end
		end,
		IsTargetValidate = function(arg_138_0)
			if get_cocos_refid(arg_138_0.BONE) and arg_138_0.TARGET_NODE and arg_138_0.TARGET_NODE.isValidate and arg_138_0.TARGET_NODE:isValidate() then
				return true
			end
		end,
		Start = function(arg_139_0, arg_139_1)
			BattleAction:Finish("battle.damage_motion")
			
			arg_139_0.ANINODE:setAnimation(0, "animation", false).timeScale = arg_139_0.TIME_SCALE
			
			arg_139_0.ANINODE:update(0)
			
			arg_139_0.listener = cc.EventListenerCustom:create("director_after_update", function()
				if arg_139_0:IsTargetValidate() then
					local var_140_0, var_140_1 = arg_139_0.BONE:getPosition()
					local var_140_2 = var_140_0 * arg_139_0.mul_offset_x
					local var_140_3 = var_140_1 * arg_139_0.mul_offset_y
					
					arg_139_0.TARGET_NODE:setPosition(var_140_2, var_140_3)
					arg_139_0.TARGET_NODE:setRotation(arg_139_0.init_rotation + arg_139_0.init_actor_dir * arg_139_0.BONE:getRotation())
					arg_139_0.TARGET_NODE:setScaleX(arg_139_0.init_scale_x * arg_139_0.BONE:getScaleX())
					arg_139_0.TARGET_NODE:setScaleY(arg_139_0.init_scale_y * arg_139_0.BONE:getScaleY())
					arg_139_0:ExecTimeline()
				end
			end)
			
			cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(arg_139_0.listener, arg_139_0.ANINODE)
			arg_139_0.ANINODE:registerSpineEventHandler(function()
				arg_139_0:OnAnimationFinished(arg_139_1)
			end, sp.ANIMATION_END)
			
			arg_139_0.init_actor_dir = arg_139_0.ACTOR_DIRECTION
			arg_139_0.init_scale_x = arg_139_0.TARGET_NODE.init_scale_x
			arg_139_0.init_scale_y = arg_139_0.TARGET_NODE.init_scale_y
			arg_139_0.init_rotation = arg_139_0.TARGET_NODE.init_rotation
			arg_139_0.mul_offset_x = BASE_SCALE * arg_139_0.init_actor_dir
			arg_139_0.mul_offset_y = BASE_SCALE
			
			arg_139_0:ExecTimeline()
		end,
		Update = function(arg_142_0, arg_142_1, arg_142_2)
		end,
		Cleanup = function(arg_143_0)
			if get_cocos_refid(arg_143_0.listener) then
				cc.Director:getInstance():getEventDispatcher():removeEventListener(arg_143_0.listener)
			end
			
			SysAction:AddAsync(CALL(function()
				if get_cocos_refid(arg_143_0.ANINODE) then
					arg_143_0.ANINODE:removeFromParent()
				end
			end), arg_143_0.ANINODE)
			arg_143_0.TARGET_NODE:cleanup()
		end,
		OnAnimationFinished = function(arg_145_0, arg_145_1)
			arg_145_0:Update()
			
			arg_145_0.FINISHED = true
			
			if arg_145_1:IsFinished() then
				arg_145_0:Cleanup()
			end
		end,
		Finish = function(arg_146_0, arg_146_1)
			arg_146_0:Update()
			
			if arg_146_0.FINISHED then
				arg_146_0:Cleanup()
			end
		end
	}
	
	arg_134_0.action = USER_ACT(var_134_14)
	
	arg_134_1:setStateActionFlags("ignore_default_motion", true, arg_134_0)
end

function StateDef.NODE_ANI.OnCleanup(arg_147_0)
	if not arg_147_0.target_node then
		return 
	end
	
	arg_147_0.target_node:cleanup(true)
end

StateDef.SHAKE_VALUE = ClassDef(StateAction)

function StateDef.SHAKE_VALUE.OnEnter(arg_148_0, arg_148_1, arg_148_2, arg_148_3)
	if not arg_148_0.info.name then
		return 
	end
	
	local var_148_0 = arg_148_0.info
	local var_148_1 = {
		TOTAL_TIME = arg_148_0.info.duration or 0,
		Update = function(arg_149_0, arg_149_1, arg_149_2)
			local var_149_0 = var_148_0.power * math.random()
			
			arg_148_2.info[var_148_0.name] = var_149_0
		end,
		Finish = function(arg_150_0, arg_150_1)
		end
	}
	
	arg_148_0.action = USER_ACT(var_148_1)
end

StateDef.RANDOM_VALUE = ClassDef(StateAction)

function StateDef.RANDOM_VALUE.OnEnter(arg_151_0, arg_151_1, arg_151_2, arg_151_3)
	if not arg_151_0.info.name then
		return 
	end
	
	local var_151_0 = arg_151_0.info
	local var_151_1 = {
		TOTAL_TIME = arg_151_0.info.duration or 0,
		Update = function(arg_152_0, arg_152_1, arg_152_2)
			local var_152_0
			
			if var_151_0.floating_type then
				local var_152_1 = math.min(var_151_0.lower or 0, var_151_0.upper or 0)
				
				var_152_0 = var_152_1 + (math.max(var_151_0.lower or 0, var_151_0.upper or 0) - var_152_1) * math.random()
			else
				var_152_0 = math.random(var_151_0.lower or 0, var_151_0.upper or 0)
			end
			
			arg_151_2.info[var_151_0.name] = var_152_0
		end,
		Finish = function(arg_153_0, arg_153_1)
		end
	}
	
	arg_151_0.action = USER_ACT(var_151_1)
end

StateDef.SINE_VALUE = ClassDef(StateAction)

function StateDef.SINE_VALUE.OnEnter(arg_154_0, arg_154_1, arg_154_2, arg_154_3)
	if not arg_154_0.info.name then
		return 
	end
	
	local var_154_0 = arg_154_0.info
	local var_154_1 = {}
	local var_154_2 = var_154_0.start_rad or 0
	local var_154_3 = var_154_0.finish_rad or 1
	local var_154_4 = math.max(0, var_154_3 - var_154_2)
	local var_154_5
	
	if var_154_0.abs then
		function var_154_5(arg_155_0)
			local var_155_0 = math.abs(arg_155_0)
			
			if var_155_0 < 1e-09 then
				return 0
			end
			
			return var_155_0
		end
	else
		function var_154_5(arg_156_0)
			if math.abs(arg_156_0) < 1e-09 then
				return 0
			end
			
			return arg_156_0
		end
	end
	
	var_154_1.TOTAL_TIME = var_154_0.duration or 0
	
	function var_154_1.Update(arg_157_0, arg_157_1, arg_157_2)
		local var_157_0 = var_154_2 + var_154_4 * arg_157_1.elapsed_time / arg_157_1.TOTAL_TIME
		local var_157_1
		
		arg_154_2.info[var_154_0.name] = var_154_0.power * var_154_5(math.sin(var_157_0 * math.pi))
	end
	
	function var_154_1.Finish(arg_158_0, arg_158_1)
		arg_154_2.info[var_154_0.name] = var_154_0.power * var_154_5(math.sin(var_154_3 * math.pi))
	end
	
	arg_154_0.action = USER_ACT(var_154_1)
end

StateDef.MODEL_BODY = ClassDef(StateAction)

function StateDef.MODEL_BODY.OnEnter(arg_159_0, arg_159_1, arg_159_2, arg_159_3)
	arg_159_0.action = CALL(function()
		local var_160_0 = arg_159_3.unit
		local var_160_1 = arg_159_3.unit.model
		
		if get_cocos_refid(var_160_1) then
			local var_160_2 = arg_159_0.info.model_id
			
			if var_160_2 then
				var_160_0.model_vars = {
					model_id = var_160_2
				}
			else
				var_160_0.model_vars = nil
			end
			
			BattleUtil:updateModel(var_160_0)
			
			if arg_159_0.info.ani then
				var_160_1:setAnimation(0, arg_159_0.info.ani, arg_159_0.info.loop)
			end
		end
	end)
end

StateDef.SPINE_ANI = ClassDef(StateAction)

local var_0_8 = ClassDef()

function var_0_8.constructor(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4)
	arg_161_0.actor = arg_161_1
	arg_161_0.node = arg_161_2
	arg_161_0.unit = arg_161_3
	arg_161_0.model = arg_161_3.model
	arg_161_0.info = arg_161_4
	
	arg_161_2:setInheritScale(true)
	arg_161_2:setInheritRotation(true)
	
	arg_161_0.direction = BattleLayout:getAllyDirection(arg_161_3.inst.ally, arg_161_3.uid)
	arg_161_0.actor_direction = not arg_161_4.disableAutoFlipX and BattleLayout:getAllyDirection(arg_161_1.inst.ally, arg_161_1.uid) or 1
	arg_161_0.init_scale_x = math.abs(arg_161_0.unit.sx) * arg_161_0.direction
	arg_161_0.init_scale_y = arg_161_0.unit.sy
	arg_161_0.init_rotation = arg_161_0.unit.rot
	arg_161_0.disable_restore = arg_161_4.disable_restore
end

function var_0_8.update(arg_162_0)
	local var_162_0, var_162_1 = arg_162_0.node:getPosition()
	local var_162_2 = var_162_0 * BASE_SCALE * arg_162_0.actor_direction + DESIGN_WIDTH / 2
	local var_162_3 = var_162_1 * BASE_SCALE + DESIGN_HEIGHT / 2
	
	arg_162_0.model:setPosition(var_162_2, var_162_3)
	arg_162_0.model:setLocalZOrder(-var_162_3)
	arg_162_0.model:setShadowY(var_162_3)
	
	local var_162_4 = arg_162_0.node:getScaleX()
	local var_162_5 = arg_162_0.node:getScaleY()
	
	arg_162_0.model:setScaleX(var_162_4 * arg_162_0.actor_direction)
	arg_162_0.model:setScaleY(var_162_5)
	
	local var_162_6 = arg_162_0.node:getRotation()
	
	arg_162_0.model:setRotation(var_162_6)
end

function var_0_8.setAnimation(arg_163_0, arg_163_1, arg_163_2, arg_163_3)
	arg_163_0.model:setAnimation(arg_163_1, arg_163_2, arg_163_3)
end

function var_0_8.setVisible(arg_164_0, arg_164_1)
	arg_164_0.unit.inst.show = arg_164_1
	
	arg_164_0.model:setVisible(arg_164_1)
end

function var_0_8.getAnimationDuration(arg_165_0, arg_165_1)
	return arg_165_0.model:getAnimationDuration(arg_165_1)
end

function var_0_8.cleanup(arg_166_0)
	if arg_166_0.disable_restore then
		return 
	end
	
	local function var_166_0()
		arg_166_0.model:setPosition(arg_166_0.unit.init_x, arg_166_0.unit.init_y)
		arg_166_0.model:setLocalZOrder(arg_166_0.unit.init_z)
		arg_166_0.model:setScaleX(arg_166_0.init_scale_x)
		arg_166_0.model:setScaleY(arg_166_0.init_scale_y)
		arg_166_0.model:setRotation(arg_166_0.init_rotation)
		arg_166_0.model:setShadowY(0)
	end
	
	local var_166_1 = Battle:getIdleAni(arg_166_0.unit) or "idle"
	
	if var_166_1 == "idle" and arg_166_0.unit.model:getLastAnimation() == "knock_down" then
		BattleAction:Add(SEQ(DMOTION("rise", false), MOTION(var_166_1, true), CALL(var_166_0)), arg_166_0.unit.model, "battle.skill")
	else
		BattleAction:Add(SPAWN(MOTION(var_166_1, true), CALL(var_166_0)), arg_166_0.unit.model, "battle.skill")
	end
end

local var_0_9 = ClassDef()

function var_0_9.constructor(arg_168_0, arg_168_1, arg_168_2, arg_168_3, arg_168_4)
	arg_168_0.node_list = {}
	
	for iter_168_0 = 1, table.count(arg_168_2) do
		local var_168_0 = arg_168_2[iter_168_0]
		local var_168_1 = arg_168_3[iter_168_0]
		
		table.insert(arg_168_0.node_list, var_0_8(arg_168_1, var_168_0, var_168_1, arg_168_4))
	end
end

function var_0_9.update(arg_169_0)
	for iter_169_0, iter_169_1 in ipairs(arg_169_0.node_list) do
		iter_169_1:update()
	end
end

function var_0_9.setVisible(arg_170_0, arg_170_1)
	for iter_170_0, iter_170_1 in ipairs(arg_170_0.node_list) do
		iter_170_1:setVisible(arg_170_1)
	end
end

function var_0_9.setAnimation(arg_171_0, arg_171_1, arg_171_2, arg_171_3)
	for iter_171_0, iter_171_1 in ipairs(arg_171_0.node_list) do
		iter_171_1:setAnimation(arg_171_1, arg_171_2, arg_171_3)
	end
end

function var_0_9.getAnimationDuration(arg_172_0, arg_172_1)
	local var_172_0 = 0
	
	for iter_172_0, iter_172_1 in ipairs(arg_172_0.node_list) do
		local var_172_1 = iter_172_1:getAnimationDuration(arg_172_1)
		
		var_172_0 = math.max(var_172_1, var_172_0)
	end
	
	return var_172_0
end

function var_0_9.cleanup(arg_173_0)
	if arg_173_0.disable_restore then
		return 
	end
	
	for iter_173_0, iter_173_1 in pairs(arg_173_0.node_list) do
		iter_173_1:cleanup()
	end
end

function StateDef.SPINE_ANI.constructor(arg_174_0, arg_174_1)
	local var_174_0 = var_0_7(arg_174_1)
	
	if var_174_0 then
		sp.SkeletonAnimation:create(var_174_0)
	end
end

function StateDef.SPINE_ANI.OnEnter(arg_175_0, arg_175_1, arg_175_2, arg_175_3)
	local var_175_0 = arg_175_0.info
	local var_175_1 = arg_175_3.unit
	local var_175_2 = arg_175_3.units.enemies
	
	if not var_175_0.offset_x then
		local var_175_3 = 0
	end
	
	if not var_175_0.offset_y then
		local var_175_4 = 0
	end
	
	local var_175_5 = var_0_7(var_175_0)
	
	if not var_175_5 then
		return 
	end
	
	local var_175_6 = sp.SkeletonAnimation:create(var_175_5)
	
	if not var_175_6 then
		return 
	end
	
	BGIManager:getBGI().game_layer:addChild(var_175_6)
	
	local var_175_7
	
	if var_175_0.target_node == SPINEANI_TARGET.Unit_Self then
		var_175_7 = var_0_8(var_175_1, var_175_6:getBoneNode("node1"), var_175_1, var_175_0)
	else
		local var_175_8 = {}
		
		for iter_175_0 = 1, table.count(var_175_2) do
			local var_175_9 = var_175_2[iter_175_0]
			local var_175_10 = var_175_6:getBoneNode("node" .. var_175_9.inst.pos)
			
			if get_cocos_refid(var_175_10) then
				table.insert(var_175_8, var_175_10)
			end
		end
		
		var_175_7 = var_0_9(var_175_1, var_175_8, var_175_2, var_175_0)
	end
	
	if not var_175_7 then
		return 
	end
	
	local var_175_11 = var_175_0.time_scale or 1
	
	if var_175_11 == 0 then
		var_175_11 = 1
	end
	
	local var_175_12 = var_175_0.animation_name or "animation"
	local var_175_13 = var_175_6:getAnimationDuration(var_175_12)
	local var_175_14, var_175_15 = (function()
		local var_176_0 = var_175_13 * 1000 / var_175_11
		local var_176_1 = var_175_0.timeline
		
		if type(var_176_1) ~= "table" then
			return {}, var_176_0
		end
		
		local var_176_2 = {}
		
		for iter_176_0, iter_176_1 in pairs(var_176_1) do
			local var_176_3 = {}
			local var_176_4 = string.split(iter_176_1, ",")
			
			if type(var_176_4[2]) == "string" then
				var_176_3.time = (tonumber(var_176_4[1]) or 0) / 1000
				
				if var_176_4[2] == "@hit" then
					var_176_3.event = "hit"
				else
					var_176_3.event = "ani"
					var_176_3.name = var_176_4[2]
					var_176_3.loop = tonumber(var_176_4[3]) == 1
				end
				
				table.insert(var_176_2, var_176_3)
			end
		end
		
		table.sort(var_176_2, function(arg_177_0, arg_177_1)
			return arg_177_0.time < arg_177_1.time
		end)
		
		local var_176_5
		local var_176_6 = 0
		local var_176_7 = 0
		
		for iter_176_2 = table.count(var_176_2), 1, -1 do
			local var_176_8 = var_176_2[iter_176_2]
			
			if var_176_8.event == "ani" and var_176_8.name ~= "idle" then
				local var_176_9 = var_175_7:getAnimationDuration(var_176_8.name) or 0
				local var_176_10 = var_176_8.name
				
				var_176_6 = var_176_8.time * 1000
				var_176_7 = var_176_9 * 1000
				
				break
			end
		end
		
		local var_176_11 = var_176_6 / var_175_11 + var_176_7
		
		return var_176_2, math.max(var_176_0, var_176_11)
	end)()
	local var_175_16 = var_175_0.additional_time or 0
	local var_175_17 = {
		TOTAL_TIME = var_175_15 + var_175_16,
		ANINODE = var_175_6,
		TIME_SCALE = var_175_11,
		TIMELINE = var_175_14,
		ExecTimeline = function(arg_178_0)
			local var_178_0 = arg_178_0.ANINODE:getCurrent()
			
			if not var_178_0 then
				return 
			end
			
			for iter_178_0, iter_178_1 in pairs(arg_178_0.TIMELINE) do
				if iter_178_1.time > var_178_0.time then
					break
				end
				
				arg_178_0.TIMELINE[iter_178_0] = nil
				
				if iter_178_1.event == "ani" then
					print("act.event", iter_178_1.event, iter_178_1.name, iter_178_1.loop)
					var_175_7:setAnimation(0, iter_178_1.name, iter_178_1.loop)
				elseif iter_178_1.event == "hit" then
					LuaEventDispatcher:dispatchEvent("battle.event", "Fire", {
						sender = "node_ani",
						unit = var_175_1
					})
				end
			end
		end,
		Start = function(arg_179_0, arg_179_1)
			arg_179_0.ANINODE:setAnimation(0, var_175_12, false).timeScale = arg_179_0.TIME_SCALE
			
			arg_179_0.ANINODE:update(0)
			arg_179_0.ANINODE:registerSpineEventHandler(function()
				arg_179_0:OnAnimationFinished(arg_179_1)
			end, sp.ANIMATION_END)
			arg_179_0:ExecTimeline()
		end,
		Update = function(arg_181_0, arg_181_1, arg_181_2)
			arg_181_0:ExecTimeline()
			var_175_7:update()
		end,
		Cleanup = function(arg_182_0)
			if arg_182_0.CLEANUP then
				return 
			end
			
			arg_182_0.CLEANUP = true
			
			var_175_7:cleanup()
		end,
		OnAnimationFinished = function(arg_183_0, arg_183_1)
			arg_183_0:Update()
			
			arg_183_0.FINISHED = true
			
			if arg_183_1:IsFinished() then
				arg_183_0:Cleanup()
			end
		end,
		Finish = function(arg_184_0, arg_184_1)
			arg_184_0:Update()
			
			if arg_184_0.FINISHED then
				arg_184_0:Cleanup()
			end
		end
	}
	
	arg_175_0.action = USER_ACT(var_175_17)
end

local var_0_10 = ClassDef()

function var_0_10.constructor(arg_185_0, arg_185_1, arg_185_2, arg_185_3)
	arg_185_0.effect = arg_185_1
	arg_185_0.model = arg_185_2
	arg_185_0.info = arg_185_3
	
	if arg_185_3.inheritedScale then
		local var_185_0 = math.abs(arg_185_2:getScaleY())
		
		arg_185_0.init_scale = (arg_185_3.scale or 1) * var_185_0
		arg_185_0.offset_x = (arg_185_3.x or 0) * var_185_0
		arg_185_0.offset_y = (arg_185_3.y or 0) * var_185_0
		arg_185_0.offset_z = arg_185_3.z or 0
	else
		arg_185_0.init_scale = arg_185_3.scale or 1
		arg_185_0.offset_x = arg_185_3.x or 0
		arg_185_0.offset_y = arg_185_3.y or 0
		arg_185_0.offset_z = arg_185_3.z or 0
	end
	
	arg_185_0.init_x = arg_185_2:getPositionX() + arg_185_0.offset_x
	arg_185_0.init_y = arg_185_2:getPositionY() + arg_185_0.offset_y
	arg_185_0.init_z = arg_185_2:getLocalZOrder() + arg_185_0.offset_z
	arg_185_0.init_flip_x = not arg_185_3.disableAutoFlipX and arg_185_2:getScaleX() < 0
	
	arg_185_1:setPosition(arg_185_0.init_x, arg_185_0.init_y)
	arg_185_1:setLocalZOrder(arg_185_0.init_z)
	
	if arg_185_0.init_flip_x then
		arg_185_1:setScaleX(-arg_185_0.init_scale)
		arg_185_1:setScaleY(arg_185_0.init_scale)
	else
		arg_185_1:setScaleX(arg_185_0.init_scale)
		arg_185_1:setScaleY(arg_185_0.init_scale)
	end
end

function var_0_10.update(arg_186_0, arg_186_1)
	if not arg_186_0.played then
		arg_186_0.played = true
		
		local var_186_0 = BGIManager:getBGI().main.layer
		
		EffectManager:EffectPlay({
			extractNodes = true,
			is_battle_effect = true,
			effect = arg_186_0.effect,
			layer = var_186_0,
			ancestor = var_186_0,
			x = arg_186_0.init_x,
			y = arg_186_0.init_y,
			z = arg_186_0.init_z,
			scale = arg_186_0.init_scale,
			flip_x = arg_186_0.init_flip_x,
			tag = {
				ignore_event = false
			}
		})
	end
	
	if arg_186_0.info.location == SPINE_EFFECT_LOCATION.Attach_Target and get_cocos_refid(arg_186_0.model) then
		local var_186_1, var_186_2 = arg_186_0.model:getPosition()
		local var_186_3 = arg_186_0.model:getLocalZOrder()
		
		arg_186_0.effect:setPosition(var_186_1 + (arg_186_0.offset_x or 0), var_186_2 + (arg_186_0.offset_y or 0))
		arg_186_0.effect:setLocalZOrder(var_186_3 + (arg_186_0.offset_zOrder or 0))
		arg_186_0.effect:update(0)
	end
end

local var_0_11 = ClassDef()

function var_0_11.constructor(arg_187_0, arg_187_1)
	arg_187_0.source = arg_187_1.source
	arg_187_0.target_unit = arg_187_1.target_unit
	arg_187_0.handle = arg_187_1.handle
	arg_187_0.info = arg_187_1.info
	arg_187_0.total_time = arg_187_1.total_time
	arg_187_0.min_time = arg_187_1.min_time
	arg_187_0.max_time = arg_187_1.max_time
	arg_187_0.unit_number = arg_187_1.unit_number
	arg_187_0.gen_time = 0
	arg_187_0.interval = 0
	arg_187_0.spine_effect_list = {}
	
	arg_187_0:createInterval()
end

function var_0_11.createEffect(arg_188_0)
	local var_188_0 = CACHE:getEffect(arg_188_0.source)
	
	if not get_cocos_refid(var_188_0) then
		return 
	end
	
	local var_188_1 = arg_188_0.target_unit.model
	
	if not get_cocos_refid(var_188_1) then
		return 
	end
	
	local var_188_2 = string.format("%p:%s", var_188_0, arg_188_0.source)
	
	var_188_0:retain()
	var_188_0:setName(var_188_2)
	var_0_3(arg_188_0.handle, var_188_2, var_188_0)
	table.insert(arg_188_0.spine_effect_list, var_0_10(var_188_0, var_188_1, arg_188_0.info))
end

function var_0_11.createInterval(arg_189_0)
	if arg_189_0.max_time > 0 and arg_189_0.max_time < arg_189_0.total_time then
		arg_189_0.interval = math.random(arg_189_0.min_time, arg_189_0.max_time)
		
		if arg_189_0.unit_number > 0 and arg_189_0.unit_number <= arg_189_0.max_time then
			local var_189_0 = arg_189_0.interval % arg_189_0.unit_number
			
			arg_189_0.interval = arg_189_0.interval - var_189_0
		end
	end
end

function var_0_11.update(arg_190_0, arg_190_1)
	if arg_190_1 - arg_190_0.gen_time >= arg_190_0.interval then
		arg_190_0.gen_time = arg_190_1
		
		arg_190_0:createEffect()
		arg_190_0:createInterval()
	end
	
	for iter_190_0, iter_190_1 in pairs(arg_190_0.spine_effect_list) do
		iter_190_1:update(arg_190_1)
	end
end

StateDef.SPINE_EFFECT = ClassDef(StateAction)

function StateDef.SPINE_EFFECT.constructor(arg_191_0)
	CACHE:getEffect(arg_191_0.info.source)
end

function StateDef.SPINE_EFFECT.OnEnter(arg_192_0, arg_192_1, arg_192_2, arg_192_3)
	local var_192_0 = arg_192_0.info
	
	if not var_192_0.source then
		return 
	end
	
	local var_192_1 = arg_192_1:reformValue(var_192_0.source)
	local var_192_2 = CACHE:getEffect(var_192_1)
	
	if not get_cocos_refid(var_192_2) then
		return 
	end
	
	local var_192_3 = string.trim(var_192_0.timeOption) or ""
	local var_192_4 = string.split(var_192_3, ";")
	local var_192_5 = var_192_4[1]
	local var_192_6 = tonumber(var_192_5) or math.max(var_192_2:getDuration() * 1000, 0)
	local var_192_7 = var_192_4[2]
	local var_192_8 = 0
	local var_192_9 = 0
	
	if var_192_7 then
		local var_192_10 = string.split(var_192_7, "~")
		
		if table.count(var_192_10) > 1 then
			var_192_8 = tonumber(var_192_10[1]) or 0
			var_192_9 = tonumber(var_192_10[2]) or 0
		end
	end
	
	local var_192_11 = tonumber(var_192_4[3]) or 0
	local var_192_12 = {}
	
	if not var_192_0.locationParam then
		var_192_12 = arg_192_3.units.enemies
	else
		local var_192_13 = string.split(var_192_0.locationParam, ",")
		
		for iter_192_0, iter_192_1 in pairs(var_192_13) do
			local var_192_14 = arg_192_3.units.enemies[tonumber(iter_192_1)]
			
			table.insert(var_192_12, var_192_14)
		end
	end
	
	local var_192_15 = {
		TOTAL_TIME = var_192_6,
		SPINE_EFFECT_GEN_LIST = {},
		Start = function(arg_193_0, arg_193_1)
			for iter_193_0, iter_193_1 in pairs(var_192_12) do
				local var_193_0 = {
					source = var_192_1,
					target_unit = iter_193_1,
					handle = arg_192_1,
					info = var_192_0,
					total_time = var_192_6,
					min_time = var_192_8,
					max_time = var_192_9,
					unit_number = var_192_11
				}
				
				table.insert(arg_193_0.SPINE_EFFECT_GEN_LIST, var_0_11(var_193_0))
			end
		end,
		Update = function(arg_194_0, arg_194_1, arg_194_2)
			if not arg_194_1.elapsed_time then
				return 
			end
			
			for iter_194_0, iter_194_1 in pairs(arg_194_0.SPINE_EFFECT_GEN_LIST) do
				iter_194_1:update(arg_194_1.elapsed_time)
			end
		end,
		Finish = function(arg_195_0, arg_195_1)
			arg_195_0.SPINE_EFFECT_GEN_LIST = nil
		end
	}
	
	arg_192_0.action = USER_ACT(var_192_15)
end

function StateDef.SPINE_EFFECT.getDuration(arg_196_0, arg_196_1, arg_196_2)
	if arg_196_0.TOTAL_TIME == 0 then
		local var_196_0 = arg_196_1:reformValue(arg_196_0.info.source)
		local var_196_1 = CACHE:getEffect(var_196_0)
		
		if not var_196_1 then
			return 0
		end
		
		arg_196_0.TOTAL_TIME = math.max(var_196_1:getDuration() * 1000, 0)
	end
	
	return arg_196_0.TOTAL_TIME
end

StateDef.SCREEN_SHOT = ClassDef(StateAction)

function StateDef.SCREEN_SHOT.OnEnter(arg_197_0, arg_197_1, arg_197_2, arg_197_3)
	arg_197_0.action = CALL(function()
		local var_198_0 = SceneManager:getRunningRootScene()
		
		enumerateNodeRecursive(var_198_0, function(arg_199_0)
			if get_cocos_refid(arg_199_0) then
				local var_199_0 = arg_199_0:getUserObject()
				
				if get_cocos_refid(var_199_0) and var_199_0:getName() == "csbscene" then
					arg_199_0:setVisible(false)
				end
			end
		end)
		
		local var_198_1 = capture_bg(var_198_0, 1)
		
		var_198_1:setAnchorPoint(0.5, 0.5)
		var_198_1:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
		var_198_1:setScaleY(-1)
		BattleField:getUILayer():addChild(var_198_1)
		var_198_1:bringToFront()
	end)
end
