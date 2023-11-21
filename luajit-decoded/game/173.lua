local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_0.model:getScaleX() < 0 then
		return -arg_1_1, arg_1_2
	end
	
	return arg_1_1, arg_1_2
end

local function var_0_1(arg_2_0, arg_2_1)
	if arg_2_1 and arg_2_0.getBoneNode then
		local var_2_0 = arg_2_0:getBoneNode(arg_2_1)
		
		if var_2_0 then
			return PivotByBone(var_2_0, arg_2_0)
		end
	end
	
	return PivotByModel(arg_2_0)
end

StateHandle = ClassDef()

function StateHandle.constructor(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.TOTAL_TIME = math.huge
	arg_3_0._manager = arg_3_1
	arg_3_0._actor = arg_3_2
	arg_3_0._flags = {
		ignore_default_motion = {}
	}
	arg_3_0._execute_action_list = {}
end

function StateHandle.setCallback(arg_4_0, arg_4_1)
	arg_4_0._callback = arg_4_1
end

function StateHandle.executeCallback(arg_5_0, arg_5_1, ...)
	if arg_5_0._callback then
		local var_5_0 = arg_5_0._callback[arg_5_1]
		
		if type(var_5_0) == "function" then
			xpcall(var_5_0, __G__TRACKBACK__, arg_5_0, argument_unpack({
				...
			}))
		end
	end
end

function StateHandle.realloc(arg_6_0, arg_6_1)
	local var_6_0 = StateHandle(arg_6_0._manager, arg_6_1 or arg_6_0:getActor())
	
	var_6_0._state_actions = arg_6_0._state_actions
	var_6_0._variables = arg_6_0._variables
	var_6_0._state_document = arg_6_0._state_document
	var_6_0._callback = arg_6_0._callback
	var_6_0._clone = true
	
	return var_6_0
end

function StateHandle.isClone(arg_7_0)
	return arg_7_0._clone
end

function StateHandle.getEntryStateId(arg_8_0, arg_8_1)
	return arg_8_0._state_document.entrypoint[arg_8_1]
end

function StateHandle.setStateDocument(arg_9_0, arg_9_1)
	arg_9_0._state_document = arg_9_1
end

function StateHandle.setStateActions(arg_10_0, arg_10_1)
	arg_10_0._state_actions = arg_10_1
	
	if not arg_10_0._state_document then
		return 
	end
	
	arg_10_0._event_listeners = {}
	
	if arg_10_0._state_document.eventlisteners then
		for iter_10_0, iter_10_1 in pairs(arg_10_0._state_document.eventlisteners) do
			local var_10_0 = arg_10_0._state_actions[iter_10_1]
			
			if var_10_0 then
				table.insert(arg_10_0._event_listeners, var_10_0)
			end
		end
	end
end

function StateHandle.getEntitiesCount(arg_11_0, arg_11_1)
	local var_11_0 = 0
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0._state_document.entities) do
		if arg_11_1 == iter_11_1.etty then
			var_11_0 = var_11_0 + 1
		end
	end
	
	return var_11_0
end

function StateHandle.setCleanupFlags(arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in pairs(arg_12_0._flags) do
		iter_12_1[arg_12_1] = nil
	end
end

function StateHandle.setStateActionFlags(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_2 then
		arg_13_0._flags[arg_13_1][arg_13_3] = arg_13_2
	else
		arg_13_0._flags[arg_13_1][arg_13_3] = nil
	end
end

function StateHandle.hasStateActionFlags(arg_14_0, arg_14_1)
	return not table.empty(arg_14_0._flags[arg_14_1])
end

function StateHandle.getActor(arg_15_0)
	return arg_15_0._actor
end

function StateHandle.getManager(arg_16_0)
	return arg_16_0._manager
end

function StateHandle.setObject(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_1 then
		return 
	end
	
	if not arg_17_0._objects then
		arg_17_0._objects = {}
	end
	
	arg_17_0._objects[arg_17_1] = arg_17_2
end

function StateHandle.getObject(arg_18_0, arg_18_1)
	if not arg_18_0._objects then
		arg_18_0._objects = {}
	end
	
	return arg_18_0._objects[arg_18_1]
end

function StateHandle.setValue(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0._variables then
		arg_19_0._variables = {}
	end
	
	arg_19_0._variables[arg_19_1] = arg_19_2
end

function StateHandle.getValue(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0._variables then
		arg_20_0._variables = {}
	end
	
	return arg_20_0._variables[arg_20_1] or arg_20_2
end

function StateHandle.reformValue(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0
	local var_21_1 = 1
	local var_21_2 = string.len(arg_21_1)
	
	while var_21_1 <= var_21_2 do
		local var_21_3, var_21_4, var_21_5 = string.find(arg_21_1, "{(.-)}", var_21_1)
		
		if not var_21_3 or not var_21_4 then
			if var_21_0 then
				var_21_0 = var_21_0 .. string.sub(arg_21_1, var_21_1)
			end
			
			break
		end
		
		var_21_0 = (var_21_0 or "") .. string.sub(arg_21_1, var_21_1, var_21_3 - 1)
		var_21_0 = var_21_0 .. arg_21_0:getValue(var_21_5, "")
		var_21_1 = var_21_4 + 1
	end
	
	return var_21_0 or arg_21_1
end

function StateHandle.executeStateID(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0._state_actions[arg_22_1]
	
	if var_22_0 then
		arg_22_0:executeState(var_22_0, arg_22_2, arg_22_3)
	end
end

function StateHandle.executeState(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_1:Enter(arg_23_0, arg_23_2, arg_23_3, arg_23_0:isSkipAction(arg_23_1.info.etty))
	arg_23_0:pushStateAction(arg_23_1)
end

function StateHandle.pushStateAction(arg_24_0, arg_24_1)
	table.insert(arg_24_0._execute_action_list, arg_24_1)
end

function StateHandle.getEventListener(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_0._event_listeners then
		for iter_25_0, iter_25_1 in pairs(arg_25_0._event_listeners) do
			local var_25_0 = iter_25_1.info
			
			if arg_25_1 == var_25_0.name and (not var_25_0.ani or var_25_0.ani == arg_25_2) then
				return iter_25_1
			end
		end
	end
end

function StateHandle.onAniEvent(arg_26_0, arg_26_1)
	local var_26_0
	
	if arg_26_0._event_listeners then
		for iter_26_0, iter_26_1 in pairs(arg_26_0._event_listeners) do
			local var_26_1 = iter_26_1.info
			
			if arg_26_1.name == var_26_1.name and (not var_26_1.ani or var_26_1.ani == arg_26_1.ani) then
				var_26_0 = var_26_0 or var_26_1.handled
				
				local var_26_2 = arg_26_0:realloc()
				local var_26_3 = var_26_1.guid
				
				StageStateManager:addActionHandler(var_26_2, var_26_3, arg_26_0._params)
			end
		end
	end
	
	if var_26_0 then
		return 
	end
	
	if not arg_26_1.name then
		Log.e("skill", arg_26_0._params.unit.db.name .. " spine.ani event name is nil Skill( " .. tostring(arg_26_0._params.id) .. ")")
	end
	
	if arg_26_1.name then
		if string.starts(arg_26_1.name, "cutin") and not DEBUG.IGNORE_CUTIN then
			local var_26_4 = string.split(string.sub(arg_26_1.name, 7, string.len(arg_26_1.name) - 1), ",")
			
			StageStateManager:playBattleCutIn(arg_26_0, var_26_4, arg_26_1.target:getScaleX() < 0)
		end
		
		if string.starts(arg_26_1.name, "hit") or string.starts(arg_26_1.name, "fire") then
			LuaEventDispatcher:dispatchEvent("battle.event", "Fire", {
				unit = arg_26_0._params.unit
			})
		end
	end
	
	return true
end

function StateHandle.getActionSender(arg_27_0)
	return arg_27_0._actionSender
end

function StateHandle.isSkipAction(arg_28_0, arg_28_1)
	if not arg_28_0._filters then
		return 
	end
	
	if arg_28_0._filters then
		for iter_28_0, iter_28_1 in pairs(arg_28_0._filters) do
			if arg_28_1 == iter_28_1 then
				return true
			end
		end
	end
	
	return false
end

function StateHandle.isContainState(arg_29_0, arg_29_1)
	if not arg_29_0._state_actions then
		return 
	end
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0._state_actions) do
		if arg_29_1 == iter_29_1:getName() then
			return true
		end
	end
	
	return false
end

function StateHandle.isContainEntityType(arg_30_0, arg_30_1)
	if not arg_30_0._state_document then
		return 
	end
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0._state_document.entities) do
		if arg_30_1 == iter_30_1.etty then
			return true
		end
	end
	
	return false
end

function StateHandle.Init(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_0._entiry = arg_31_0._state_actions[arg_31_2]
	arg_31_0._params = arg_31_3
	arg_31_0._finished = false
end

function StateHandle.Start(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0._actionSender = arg_32_2
	
	arg_32_0:executeState(arg_32_0._entiry, nil, arg_32_0._params)
end

function StateHandle.getParam(arg_33_0, arg_33_1)
	if not arg_33_0._params then
		return 
	end
	
	return arg_33_0._params[arg_33_1]
end

function StateHandle.Update(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = {}
	
	for iter_34_0, iter_34_1 in ipairs(arg_34_0._execute_action_list) do
		iter_34_1:Update(arg_34_1, arg_34_2)
		
		if iter_34_1:IsFinished() then
			table.insert(var_34_0, 1, iter_34_0)
		end
	end
	
	for iter_34_2, iter_34_3 in ipairs(var_34_0) do
		local var_34_1 = arg_34_0._execute_action_list[iter_34_3]
		
		table.remove(arg_34_0._execute_action_list, iter_34_3)
		xpcall(var_34_1.Leave, __G__TRACKBACK__, var_34_1, arg_34_0)
	end
	
	arg_34_0._finished = #arg_34_0._execute_action_list == 0
end

function StateHandle.Finish(arg_35_0, arg_35_1)
	if arg_35_0._objects then
		for iter_35_0, iter_35_1 in pairs(arg_35_0._objects) do
			stop_or_remove(iter_35_1)
		end
	end
	
	StageStateManager:removeExecutingList(arg_35_0)
end

function StateHandle.IsFinished(arg_36_0, arg_36_1)
	return arg_36_0._finished
end

function StateHandle.setActionFilters(arg_37_0, arg_37_1)
	arg_37_0._filters = arg_37_1
end

StageStateManager = {}
StageStateManager._execute_handle_list = {}

function StageStateManager.reset(arg_38_0)
	arg_38_0._execute_handle_list = {}
end

function StageStateManager.reformValue(arg_39_0, arg_39_1)
	do return arg_39_1 end
	
	if not arg_39_1 then
		return 
	end
	
	local var_39_0
	local var_39_1 = 1
	local var_39_2 = string.len(arg_39_1)
	
	while var_39_1 <= var_39_2 do
		local var_39_3, var_39_4, var_39_5 = string.find(arg_39_1, "{(.-)}", var_39_1)
		
		if not var_39_3 or not var_39_4 then
			if var_39_0 then
				var_39_0 = var_39_0 .. string.sub(arg_39_1, var_39_1)
			end
			
			break
		end
		
		var_39_0 = (var_39_0 or "") .. string.sub(arg_39_1, var_39_1, var_39_3 - 1)
		var_39_0 = var_39_0 .. arg_39_0:getValue(var_39_5, "")
		var_39_1 = var_39_4 + 1
	end
	
	return var_39_0 or arg_39_1
end

function StageStateManager.start(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_2.unit
	local var_40_1 = var_40_0:getSkinCheck()
	local var_40_2 = DB("skillact", DB("skill", arg_40_1, "skillact"), {
		var_40_1 or "action"
	}) or var_40_0.model:getBoneNode("arrow_start") and "def_range_attack" or "def_melee_attack"
	
	arg_40_2.id = arg_40_1
	arg_40_2.idx = var_40_0:getSkillIndex(arg_40_1)
	
	SoundEngine:playBattle("event:/skill/" .. var_40_2)
	
	if not arg_40_2.ignore_sound then
		local var_40_3
		
		if (arg_40_2.att_info or {}).coop_order == 2 then
			var_40_3 = SoundEngine:play("event:/voc/skill/" .. var_40_2 .. "_a")
		elseif (arg_40_2.att_info or {}).coop_order == 1 then
			var_40_3 = SoundEngine:play("event:/voc/skill/" .. var_40_2 .. "_c")
		end
		
		if not var_40_3 then
			local var_40_4
			local var_40_5 = var_40_0.model:getExtraSound(var_40_2)
			
			if var_40_5 then
				var_40_4 = SoundEngine:play("event:/voc/skill/" .. var_40_5)
			end
			
			if var_40_4 then
				local var_40_6 = var_40_4
			else
				SoundEngine:play("event:/voc/skill/" .. var_40_2)
			end
		end
	end
	
	return arg_40_0:executeStateDoc(var_40_2, "start", arg_40_2)
end

function StageStateManager.stop(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_2.unit
	local var_41_1 = DB("skillact", DB("skill", arg_41_1, "skillact"), "action")
	
	if not var_41_1 then
		return 
	end
	
	arg_41_2.id = arg_41_1
	arg_41_2.idx = var_41_0:getSkillIndex(arg_41_1)
	
	return arg_41_0:executeStateDoc(var_41_1, "stop", arg_41_2)
end

function StageStateManager.getLocationPivotObject(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	local var_42_0
	
	arg_42_1 = arg_42_1 or LOCATION_TYPE_VER2.Screen_Center
	
	if arg_42_4.d_unit_target and LOCATION_TYPE_VER2.Unit_Target == arg_42_1 then
		local var_42_1 = arg_42_2 == "root"
		
		var_42_0 = PivotByTarget(arg_42_4.d_unit, arg_42_4.d_unit_target, var_42_1)
	elseif arg_42_4.d_unit_target and (LOCATION_TYPE_VER2.Field_Target == arg_42_1 or LOCATION_TYPE_VER2.Field_TargetFront == arg_42_1) then
		var_42_0 = PivotByTarget(arg_42_4.d_unit, arg_42_4.d_unit_target, true)
	elseif LOCATION_TYPE_VER2.Unit_Self == arg_42_1 then
		var_42_0 = var_0_1(arg_42_4.a_unit.model, arg_42_2)
	elseif LOCATION_TYPE_VER2.Unit_Target == arg_42_1 then
		var_42_0 = var_0_1(arg_42_4.d_unit.model, arg_42_2)
	elseif LOCATION_TYPE_VER2.Attach_Self == arg_42_1 then
		var_42_0 = var_0_1(arg_42_4.a_unit.model, arg_42_2)
	elseif LOCATION_TYPE_VER2.Attach_Target == arg_42_1 then
		var_42_0 = var_0_1(arg_42_4.d_unit.model, arg_42_2)
	elseif LOCATION_TYPE_VER2.Attach_Object == arg_42_1 then
		if not arg_42_4.actor then
			var_42_0 = ScreenCenterPivot()
			
			error("no have target_actor")
		else
			var_42_0 = var_0_1(arg_42_4.actor, true, arg_42_2)
		end
	elseif LOCATION_TYPE_VER2.Field_OurFront == arg_42_1 or LOCATION_TYPE_VER2.Field_OurCenter == arg_42_1 then
		local var_42_2
		local var_42_3
		
		if not arg_42_3 or arg_42_3 == LOCATION_FORCE_TYPE.None then
			var_42_2 = arg_42_4.a_unit.inst.ally
			var_42_3 = arg_42_4.a_unit
		elseif arg_42_3 == LOCATION_FORCE_TYPE.For then
			if arg_42_4.a_unit.inst.ally == FRIEND then
				var_42_2 = ENEMY
			else
				var_42_2 = FRIEND
			end
			
			var_42_3 = arg_42_4.a_unit
		else
			var_42_2 = arg_42_4.a_unit.inst.ally
			var_42_3 = arg_42_4.a_unit
		end
		
		var_42_0 = BattleLayout:getTeamLayout(var_42_2, var_42_3.uid)
	elseif LOCATION_TYPE_VER2.Field_ForFront == arg_42_1 or LOCATION_TYPE_VER2.Field_ForCenter == arg_42_1 then
		local var_42_4
		local var_42_5
		
		if not arg_42_3 or arg_42_3 == LOCATION_FORCE_TYPE.None then
			var_42_4 = arg_42_4.d_unit.inst.ally
			var_42_5 = arg_42_4.d_unit
		elseif arg_42_3 == LOCATION_FORCE_TYPE.For then
			if arg_42_4.a_unit.inst.ally == FRIEND then
				var_42_4 = ENEMY
			else
				var_42_4 = FRIEND
			end
			
			var_42_5 = arg_42_4.referenceParam and arg_42_4.referenceParam.a_unit
		else
			var_42_4 = arg_42_4.a_unit.inst.ally
			var_42_5 = arg_42_4.referenceParam and arg_42_4.referenceParam.a_unit
		end
		
		var_42_0 = BattleLayout:getTeamLayout(var_42_4, var_42_5 and var_42_5.uid)
	elseif LOCATION_TYPE_VER2.Field_Self == arg_42_1 then
		var_42_0 = PivotByUnit(arg_42_4.a_unit, arg_42_2)
	elseif LOCATION_TYPE_VER2.Field_Target == arg_42_1 or LOCATION_TYPE_VER2.Field_TargetFront == arg_42_1 then
		var_42_0 = PivotByUnit(arg_42_4.d_unit, arg_42_2)
	else
		var_42_0 = ScreenCenterPivot()
	end
	
	if not var_42_0 then
		return 
	end
	
	local var_42_6 = BindLocationPivot(var_42_0, LOCATION_TYPE_FRONT_TYPE_TABLE[arg_42_1])
	
	function var_42_6.getLocationType(arg_43_0)
		return arg_42_1
	end
	
	function var_42_6.isAttachType(arg_44_0)
		return LOCATION_TYPE_ATTACH_TYPE_TABLE[arg_42_1]
	end
	
	return var_42_6
end

function StageStateManager.getZoomAction(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	local var_45_0 = math.max(0, arg_45_2 or 0)
	local var_45_1 = CameraZoom(arg_45_3.scale or DEF_CAM_SCALE)
	
	var_45_1:setTime(var_45_0)
	var_45_1:setCurves(BezierCurves(arg_45_3.curve))
	
	return USER_ACT(CameraZoomActionHandler(var_45_1))
end

function StageStateManager.getCameraAction(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5)
	local var_46_0 = math.max(0, arg_46_2 or 0)
	local var_46_1, var_46_2 = var_0_0(arg_46_1, arg_46_3.x or 0, arg_46_3.y or 0)
	local var_46_3 = arg_46_3.location or LOCATION_TYPE_VER2.Screen_Center
	local var_46_4 = arg_46_3.locationParam
	local var_46_5 = arg_46_3.locationForce
	local var_46_6
	
	if arg_46_4.att_info then
		var_46_6 = {
			a_unit = arg_46_4.att_info.a_unit,
			d_unit = arg_46_4.att_info.d_unit,
			actor = arg_46_5
		}
	else
		var_46_6 = {
			actor = arg_46_5
		}
	end
	
	local var_46_7 = arg_46_0:getLocationPivotObject(var_46_3, var_46_4, var_46_5, var_46_6)
	local var_46_8 = CameraFocus(var_46_7, var_46_1, var_46_2)
	
	var_46_8:setTime(var_46_0)
	var_46_8:setCurves(BezierCurves(arg_46_3.curve))
	
	return USER_ACT(CameraFocusActionHandler(var_46_8))
end

function StageStateManager.loadStateCacheFromFile(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = cc.FileUtils:getInstance():getStringFromFile(arg_47_2)
	
	if not var_47_0 or var_47_0 == "" then
		return 
	end
	
	arg_47_0._cache = arg_47_0._cache or {}
	arg_47_0._cache[arg_47_1] = json.decode(var_47_0)
	
	return arg_47_1
end

function StageStateManager.releaseStateCache(arg_48_0, arg_48_1)
	if arg_48_0._cache then
		arg_48_0._cache[arg_48_1] = nil
	end
end

function StageStateManager.executeStateDoc(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	if not arg_49_1 then
		return 
	end
	
	arg_49_0._cache = arg_49_0._cache or {}
	
	local var_49_0 = arg_49_0._cache[arg_49_1]
	
	if not var_49_0 then
		local var_49_1 = "stagept/" .. arg_49_1 .. ".stg"
		local var_49_2 = cc.FileUtils:getInstance():getStringFromFile(var_49_1)
		
		if var_49_2 == "" then
			return 
		end
		
		var_49_0 = json.decode(var_49_2)
	else
		print("exists StageState cache ", arg_49_1)
	end
	
	if not var_49_0.entrypoint then
		return 
	end
	
	local var_49_3 = var_49_0.entrypoint[arg_49_2]
	
	if not var_49_0.entities[var_49_3 or 0] then
		return 
	end
	
	return arg_49_0:executeStateAction(var_49_0, var_49_3, arg_49_3)
end

function StageStateManager.getStateDocTime(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	if not arg_50_1 then
		return 
	end
	
	arg_50_0._cache = arg_50_0._cache or {}
	
	local var_50_0 = arg_50_0._cache[arg_50_1]
	
	if not var_50_0 then
		local var_50_1 = "stagept/" .. arg_50_1 .. ".stg"
		local var_50_2 = cc.FileUtils:getInstance():getStringFromFile(var_50_1)
		
		if var_50_2 == "" then
			return 
		end
		
		var_50_0 = json.decode(var_50_2)
	else
		print("exists StageState cache ", arg_50_1)
	end
	
	if not var_50_0.entrypoint then
		return 
	end
	
	local var_50_3 = var_50_0.entrypoint[arg_50_2]
	
	if not var_50_0.entities[var_50_3 or 0] then
		return 
	end
	
	return arg_50_0:getTotalTimeStateActions(var_50_0, var_50_3, arg_50_3)
end

function StageStateManager.genStateAction(arg_51_0, arg_51_1)
	local var_51_0 = StateDef[arg_51_1.etty] or StateAction
	
	if var_51_0 then
		return var_51_0(arg_51_1)
	end
end

local var_0_2 = {
	OnData = 2,
	OnFinish = 0,
	OnStart = 1
}
local var_0_3 = {
	ACTOR = true,
	ANI_POS = true,
	ANI_SCOPE = true
}

function StageStateManager.executeStateAction(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = arg_52_3.unit
	local var_52_1 = arg_52_3.unit.model
	local var_52_2 = StateHandle(arg_52_0, var_52_1)
	
	if var_52_0 then
		local var_52_3 = DB("character", var_52_0.inst.code, "ch_attribute")
		
		var_52_2:setValue("ch_attr", var_52_3)
	end
	
	local var_52_4 = arg_52_3.idx or arg_52_3.att_info and arg_52_3.att_info.selected_skill_idx or 1
	
	var_52_2:setValue("id", arg_52_3.id)
	var_52_2:setValue("rate", arg_52_3.rate)
	var_52_2:setValue("idx", var_52_4)
	
	local var_52_5 = {}
	
	for iter_52_0, iter_52_1 in pairs(arg_52_1.entities) do
		var_52_5[iter_52_0] = arg_52_0:genStateAction(iter_52_1)
	end
	
	for iter_52_2, iter_52_3 in pairs(arg_52_1.connections) do
		local var_52_6 = var_52_5[iter_52_3.from]
		local var_52_7 = var_52_5[iter_52_3.to]
		
		if not var_52_6 or not var_52_7 then
			print("cant found symbol!! ", iter_52_3.from, iter_52_3.to, var_52_6, var_52_7)
			
			return false
		end
		
		if not var_52_6.on_start then
			var_52_6.on_start = {}
		end
		
		if not var_52_6.on_finish then
			var_52_6.on_finish = {}
		end
		
		if not var_52_6.on_data then
			var_52_6.on_data = {}
		end
		
		local var_52_8 = arg_52_0:genStateAction(iter_52_3)
		
		if iter_52_3.when == var_0_2.OnStart or var_0_3[var_52_7.info.etty] then
			table.insert(var_52_6.on_start, var_52_8)
		elseif iter_52_3.when == var_0_2.OnData then
			table.insert(var_52_6.on_data, var_52_8)
		else
			table.insert(var_52_6.on_finish, var_52_8)
		end
	end
	
	var_52_2:setStateDocument(arg_52_1)
	var_52_2:setStateActions(var_52_5)
	arg_52_0:addActionHandler(var_52_2, arg_52_2, arg_52_3)
	cc.Director:getInstance():setNextDeltaTimeZero(true)
	
	return var_52_2, arg_52_2
end

function StageStateManager.getTotalTimeStateActions(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = arg_53_3.unit
	local var_53_1 = arg_53_3.unit.model
	local var_53_2 = StateHandle(arg_53_0, var_53_1)
	
	var_53_2.start_tick = systick()
	
	if var_53_0 then
		local var_53_3 = DB("character", var_53_0.inst.code, "ch_attribute")
		
		var_53_2:setValue("ch_attr", var_53_3)
	end
	
	local var_53_4 = arg_53_3.idx or arg_53_3.att_info and arg_53_3.att_info.selected_skill_idx or 1
	
	var_53_2:setValue("id", arg_53_3.id)
	var_53_2:setValue("rate", arg_53_3.rate)
	var_53_2:setValue("idx", var_53_4)
	var_53_2:setValue("cutin_time_calc", true)
	var_53_2:setValue("cutin_time_calc_sync", true)
	
	local var_53_5
	local var_53_6 = {}
	
	for iter_53_0, iter_53_1 in pairs(arg_53_1.entities) do
		var_53_6[iter_53_0] = arg_53_0:genStateAction(iter_53_1)
		
		if iter_53_1.guid == arg_53_2 then
			var_53_5 = var_53_6[iter_53_0]
		end
	end
	
	for iter_53_2, iter_53_3 in pairs(arg_53_1.connections) do
		local var_53_7 = var_53_6[iter_53_3.from]
		local var_53_8 = var_53_6[iter_53_3.to]
		
		if not var_53_7 or not var_53_8 then
			print("cant found symbol!! ", iter_53_3.from, iter_53_3.to, var_53_7, var_53_8)
			
			return false
		end
		
		if not var_53_7.on_start then
			var_53_7.on_start = {}
		end
		
		if not var_53_7.on_finish then
			var_53_7.on_finish = {}
		end
		
		if not var_53_7.on_data then
			var_53_7.on_data = {}
		end
		
		local var_53_9 = arg_53_0:genStateAction(iter_53_3)
		
		if iter_53_3.when == var_0_2.OnStart or var_0_3[var_53_8.info.etty] then
			table.insert(var_53_7.on_start, var_53_9)
		elseif iter_53_3.when == var_0_2.OnData then
			table.insert(var_53_7.on_data, var_53_9)
		else
			table.insert(var_53_7.on_finish, var_53_9)
		end
	end
	
	var_53_2:setStateDocument(arg_53_1)
	var_53_2:setStateActions(var_53_6)
	
	local var_53_10 = 0
	
	local function var_53_11(arg_54_0, arg_54_1, arg_54_2)
		arg_54_1.elapsed_tick = arg_54_2 or 0
		arg_54_1.visited = true
		
		local var_54_0 = arg_54_1.getDuration and arg_54_1:getDuration(var_53_2, arg_54_0) or 0
		
		if arg_54_1.elapsed_tick + var_54_0 > var_53_10 then
			var_53_10 = arg_54_1.elapsed_tick + var_54_0
		end
		
		for iter_54_0, iter_54_1 in pairs(arg_54_1.on_start or {}) do
			if iter_54_1.info.to and var_53_6[iter_54_1.info.to] then
				local var_54_1 = var_53_6[iter_54_1.info.to]
				
				var_53_11(arg_54_1, var_54_1, arg_54_1.elapsed_tick + iter_54_1:getDuration())
			end
		end
		
		for iter_54_2, iter_54_3 in pairs(arg_54_1.on_finish or {}) do
			if iter_54_3.info.to and var_53_6[iter_54_3.info.to] then
				local var_54_2 = var_53_6[iter_54_3.info.to]
				
				var_53_11(arg_54_1, var_54_2, arg_54_1.elapsed_tick + var_54_0 + iter_54_3:getDuration())
			end
		end
	end
	
	var_53_11(nil, var_53_5, 0)
	
	for iter_53_4, iter_53_5 in pairs(var_53_6 or {}) do
		if not iter_53_5.visited and iter_53_5.info.etty and iter_53_5.info.etty == "CUTIN" then
			calc_cutin_playtime(var_53_2, iter_53_5.info.args)
		end
	end
	
	local var_53_12 = var_53_2:getValue("cutin_time") or 0
	
	return var_53_2, var_53_10 + var_53_12, arg_53_2
end

function StageStateManager.enumStateTiming(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = math.huge
	local var_55_1 = arg_55_2._state_actions
	local var_55_2 = var_55_1[arg_55_3]
	local var_55_3 = {}
	
	local function var_55_4(arg_56_0, arg_56_1, arg_56_2)
		if arg_56_1:getName() == arg_55_1 then
			table.insert(var_55_3, arg_56_0)
		end
		
		local var_56_0 = 0
		
		if arg_56_1.getDuration then
			var_56_0 = arg_56_1:getDuration(arg_55_2, arg_56_2)
		end
		
		Log.d("ANI TIMING ", arg_56_1:getName(), arg_56_0, "duration", var_56_0, "#state.on_start , #state.on_finish", arg_56_1.on_start, arg_56_1.on_finish)
		
		if arg_56_1:getName() == "CONNECTION" then
			arg_56_0 = arg_56_0 + var_56_0
			
			var_55_4(arg_56_0, var_55_1[arg_56_1.info.to], arg_56_2)
		else
			if arg_56_1:getName() == "ANI" then
				local var_56_1 = arg_56_1:getAniEvents(arg_55_2)
				
				for iter_56_0, iter_56_1 in pairs(var_56_1 or {}) do
					local var_56_2 = arg_55_2:getEventListener(iter_56_1[1], arg_56_1:getAniName())
					
					if var_56_2 then
						var_55_4(arg_56_0 + iter_56_1[2] * 1000, var_56_2)
					end
				end
			end
			
			for iter_56_2, iter_56_3 in pairs(arg_56_1.on_start or {}) do
				var_55_4(arg_56_0, iter_56_3, arg_56_1)
			end
			
			arg_56_0 = arg_56_0 + var_56_0
			
			for iter_56_4, iter_56_5 in pairs(arg_56_1.on_finish or {}) do
				var_55_4(arg_56_0, iter_56_5, arg_56_1)
			end
		end
	end
	
	var_55_4(0, var_55_2)
	table.sort(var_55_3)
	
	return var_55_3
end

function StageStateManager.getActionHandleByActor(arg_57_0, arg_57_1, arg_57_2)
	for iter_57_0, iter_57_1 in pairs(arg_57_0._execute_handle_list) do
		if arg_57_2 then
			if arg_57_1 == iter_57_0:getActor() and iter_57_0:hasStateActionFlags(arg_57_2) then
				return iter_57_0
			end
		elseif arg_57_1 == iter_57_0:getActor() then
			return iter_57_0
		end
	end
end

function StageStateManager.hasStateActionFlagsByActor(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = StageStateManager:getActionHandleByActor(arg_58_1, arg_58_2)
	
	return var_58_0 and var_58_0:hasStateActionFlags(arg_58_2)
end

function StageStateManager.addActionHandler(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	if not arg_59_1 or not arg_59_2 then
		return 
	end
	
	BattleAction:Add(USER_ACT(arg_59_1, arg_59_2, arg_59_3), arg_59_1:getActor(), "battle.skill")
	
	arg_59_0._execute_handle_list[arg_59_1] = arg_59_2
end

function StageStateManager.removeExecutingList(arg_60_0, arg_60_1)
	arg_60_0._execute_handle_list[arg_60_1] = nil
	
	if table.empty(arg_60_0._execute_handle_list) then
		BattleField:setVisibleField(true, 200)
		
		local var_60_0 = arg_60_1:getActor()
		
		if get_cocos_refid(var_60_0) then
			BattleAction:Add(MOTION("idle", true), var_60_0)
		end
		
		local var_60_1 = arg_60_1._state_actions
		
		for iter_60_0 = 1, table.count(var_60_1) do
			local var_60_2 = var_60_1[iter_60_0]
			
			if var_60_2.Cleanup then
				var_60_2:Cleanup()
			end
		end
		
		arg_60_1:executeCallback("onFinish")
	end
	
	arg_60_1:executeCallback("onDestroy")
end

function StageStateManager.playBattleCutIn(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	local var_61_0
	local var_61_1 = ".atlas"
	
	if arg_61_2[1] and string.len(arg_61_2[1]) > 0 then
		var_61_0 = arg_61_2[1]
	end
	
	local var_61_2 = arg_61_1:getParam("skill_id") or "sk_10101_3"
	
	Log.d("playBattleCutIn", var_61_2)
	
	var_61_0 = var_61_0 or DB("skill", arg_61_1:getValue("id", var_61_2), "cutin")
	
	if var_61_0 then
		local var_61_3 = load_file("cut/" .. var_61_0 .. ".txt")
		local var_61_4, var_61_5
		
		if var_61_3 then
			var_61_4 = string.split(var_61_3, ",")
			var_61_5 = 0
			
			for iter_61_0 = 1, #var_61_4 do
				var_61_5 = var_61_5 + tonumber(var_61_4[iter_61_0])
				var_61_4[iter_61_0] = var_61_5
			end
		end
		
		local var_61_6 = CocosSchedulerManager:getCurrentSchForPoll()
		
		if get_cocos_refid(var_61_6) then
			var_61_6:setTimeScale(0)
			BattleAction:Pause()
		else
			pause()
		end
		
		play_cutin(BGIManager:getBGI().cutin_layer, var_61_0, arg_61_3, arg_61_4, function(arg_62_0)
			if get_cocos_refid(var_61_6) then
				var_61_6:setTimeScale(BATTLE_TIME_SCALE_X2)
				BattleAction:Resume()
			else
				resume()
			end
		end)
	end
end

function StageStateManager.isRunning(arg_63_0)
	for iter_63_0, iter_63_1 in pairs(arg_63_0._execute_handle_list) do
		return true
	end
	
	return false
end

function StageStateManager.onEvent(arg_64_0, arg_64_1)
end

function StageStateManager.onAniEvent(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	for iter_65_0, iter_65_1 in pairs(arg_65_0._execute_handle_list) do
		if not iter_65_0:isClone() and iter_65_0:getActor() == arg_65_1.target then
			iter_65_0:onAniEvent(arg_65_1, arg_65_2, arg_65_3, arg_65_4)
		end
	end
	
	return true
end
