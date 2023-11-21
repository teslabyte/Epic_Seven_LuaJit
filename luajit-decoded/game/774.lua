SPLEventSystem = {}
SPLEventType = {
	STEP = 2,
	DETAIL = 5,
	CREATE = 1,
	NEAR = 3,
	USE = 4
}
SPLEventState = {
	IDLE = 1,
	ACTION = 4,
	START = 2,
	EVENT = 3
}

local var_0_0 = {
	DELAY = function(arg_1_0)
		return DELAY(arg_1_0.total_time)
	end,
	CAMERA_MOVE = function(arg_2_0, arg_2_1)
		local var_2_0 = SPLEventSystem:getTargetTile(arg_2_0.target, arg_2_0.value)
		
		if not var_2_0 then
			return NONE()
		end
		
		local var_2_1 = SPLUtil:calcTilePosToWorldPos(var_2_0:getPos())
		local var_2_2 = SPLObjectSystem:getObject(var_2_0:getTileId())
		
		if var_2_2 and var_2_2:isModel() then
			var_2_1.y = var_2_1.y + var_2_2:getAdjustFocusYPos()
		end
		
		local var_2_3 = arg_2_0.total_time or 1000
		
		return SPLCameraSystem:createCameraTween(var_2_3, var_2_1.x, var_2_1.y)
	end,
	SCENE_FADE_OUT = function(arg_3_0)
		local var_3_0 = SPLCameraSystem:getDim()
		
		if not var_3_0 then
			return NONE()
		end
		
		local var_3_1 = arg_3_0.total_time or 1000
		
		return TARGET(var_3_0, FADE_IN(var_3_1))
	end,
	SCENE_FADE_IN = function(arg_4_0)
		local var_4_0 = SPLCameraSystem:getDim()
		
		if not var_4_0 then
			return NONE()
		end
		
		local var_4_1 = arg_4_0.total_time or 1000
		
		return TARGET(var_4_0, FADE_OUT(var_4_1))
	end,
	CINEMA_ON = function(arg_5_0)
		local var_5_0, var_5_1 = SPLCameraSystem:getLetterBoxes()
		
		if not var_5_0 or not var_5_1 then
			return NONE()
		end
		
		local var_5_2 = arg_5_0.total_time or 1000
		local var_5_3 = var_5_0:getContentSize().height
		local var_5_4 = TARGET(var_5_0, LOG(MOVE_TO(var_5_2, var_5_0.org_x, var_5_0.org_y - var_5_3)))
		local var_5_5 = TARGET(var_5_1, LOG(MOVE_TO(var_5_2, var_5_1.org_x, var_5_1.org_y + var_5_3)))
		
		SPLMainUI:fadeOut()
		
		return SPAWN(var_5_4, var_5_5)
	end,
	CINEMA_OFF = function(arg_6_0)
		local var_6_0, var_6_1 = SPLCameraSystem:getLetterBoxes()
		
		if not var_6_0 or not var_6_1 then
			return NONE()
		end
		
		local var_6_2 = arg_6_0.total_time or 1000
		local var_6_3 = TARGET(var_6_0, RLOG(MOVE_TO(var_6_2, var_6_0.org_x, var_6_0.org_y)))
		local var_6_4 = TARGET(var_6_1, RLOG(MOVE_TO(var_6_2, var_6_1.org_x, var_6_1.org_y)))
		
		SPLMainUI:fadeIn()
		
		return SPAWN(var_6_3, var_6_4)
	end,
	ANNOUNCE = function(arg_7_0)
		local var_7_0 = SPLUtil:makeSystemAnnounce(T(arg_7_0.value))
		
		SPLMainUI:addChild(var_7_0)
		var_7_0:setOpacity(0)
		
		local var_7_1 = arg_7_0.total_time or 5000
		local var_7_2 = SEQ(FADE_IN(450), DELAY(var_7_1), FADE_OUT(450), REMOVE())
		
		return TARGET(var_7_0, var_7_2)
	end
}
local var_0_1 = {
	ICON_CHANGE = function(arg_8_0)
		SPLObjectSystem:changeIcon(arg_8_0.target, arg_8_0.value)
	end,
	NPC_TEXT = function(arg_9_0)
		SPLStorySystem:playStory(arg_9_0.value)
	end,
	STORY = function(arg_10_0)
		SPLStorySystem:playEpicStory(arg_10_0.value)
	end,
	SPEECH = function(arg_11_0)
		SPLStorySystem:playSpeech(arg_11_0.value)
	end,
	EFF_SOUND_ON = function(arg_12_0)
		if not arg_12_0 or not arg_12_0.value then
			Log.e("NO VALUE @EFF_SOUND_ON")
			
			return 
		end
		
		local var_12_0 = "event:/" .. arg_12_0.value
		
		SoundEngine:play(var_12_0)
	end,
	EFF_BGM_ON = function(arg_13_0)
		if not arg_13_0 or not arg_13_0.value then
			Log.e("NO VALUE @EFF_BGM_ON")
			
			return 
		end
		
		local var_13_0 = "event:/" .. arg_13_0.value
		
		SoundEngine:playBGM(var_13_0)
	end,
	REMOVE_FOG = function(arg_14_0)
		if arg_14_0.target == "map" then
			SPLFogSystem:clear()
			
			return 
		end
		
		local var_14_0 = SPLEventSystem:getTargetTile(arg_14_0.target, arg_14_0.value)
		
		if not var_14_0 then
			return 
		end
		
		local var_14_1 = string.split(arg_14_0.value, ",")
		
		if not var_14_1 then
			return 
		end
		
		local var_14_2 = 3
		local var_14_3 = var_14_0:getPos()
		local var_14_4 = to_n(var_14_1[2])
		
		if var_14_4 <= var_14_2 then
			SPLFogSystem:discover(var_14_3.x, var_14_3.y, var_14_2, HTBFogVisibilityEnum.VISIBLE)
		else
			local var_14_5 = SPLUtil:getTileCircle({
				x = var_14_3.x,
				y = var_14_3.y
			}, var_14_4 - var_14_2)
			
			for iter_14_0, iter_14_1 in pairs(var_14_5) do
				local var_14_6 = iter_14_1:getPos()
				
				SPLFogSystem:discover(var_14_6.x, var_14_6.y, var_14_2, HTBFogVisibilityEnum.VISIBLE)
			end
		end
	end,
	POPUP_TEXT = function(arg_15_0)
		SPLEventSystem:pause()
		
		local var_15_0 = SPLUtil:makeTextPopup(T(arg_15_0.value), function()
			SPLEventSystem:resume()
		end)
		
		SPLMainUI:addChild(var_15_0)
	end,
	QUARTER_POPUP = function(arg_17_0)
		SPLEventSystem:pause()
		
		local var_17_0 = {
			[arg_17_0.target] = arg_17_0.value,
			on_close = function()
				SPLEventSystem:resume()
			end
		}
		local var_17_1 = SPLUtil:showCompleteDlg(var_17_0)
		
		SPLMainUI:addChild(var_17_1)
	end,
	MOVE_TO = function(arg_19_0)
		local var_19_0 = SPLEventSystem:getTargetTile(arg_19_0.target, arg_19_0.value)
		
		if not var_19_0 then
			return 
		end
		
		local var_19_1 = var_19_0:getPos()
		local var_19_2 = SPLMovableSystem:getPlayer()
		local var_19_3 = var_19_2:getPos()
		local var_19_4 = SPLPathFindingSystem:find(var_19_3, var_19_1, 20)
		
		if var_19_4 then
			SPLMovableSystem:movePath(var_19_2, var_19_4)
		end
	end
}
local var_0_2 = {
	mission_complete = function(arg_20_0)
		return SPLMissionData:isMissionCompleted(arg_20_0)
	end,
	use_complete = function(arg_21_0)
		return SPLObjectSystem:isObjectCompleted(arg_21_0)
	end
}

function SPLEventSystem.init(arg_22_0)
	arg_22_0.vars = {}
	arg_22_0.vars.event_queue = {}
	arg_22_0.vars.cur_event = nil
	arg_22_0.vars.state = SPLEventState.IDLE
	arg_22_0.vars.callback_on_finish = {}
end

function SPLEventSystem.onLeave(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	arg_23_0.vars.event_queue = {}
	arg_23_0.vars.cur_event = nil
	arg_23_0.vars.state = SPLEventState.IDLE
	arg_23_0.vars.callback_on_finish = {}
end

function SPLEventSystem.setState(arg_24_0, arg_24_1)
	if not arg_24_0.vars then
		return 
	end
	
	arg_24_0.vars.state = arg_24_1
end

function SPLEventSystem.getState(arg_25_0)
	return arg_25_0.vars and arg_25_0.vars.state
end

function SPLEventSystem.enqueueEvent(arg_26_0, arg_26_1)
	if not arg_26_0.vars then
		return 
	end
	
	table.insert(arg_26_0.vars.event_queue, arg_26_1)
end

function SPLEventSystem.nextEvent(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	while not arg_27_0:isEventQueueEmpty() do
		local var_27_0 = table.remove(arg_27_0.vars.event_queue, 1)
		
		if var_27_0 and var_27_0:initActionList() then
			return var_27_0
		end
	end
	
	return nil
end

function SPLEventSystem.isEventQueueEmpty(arg_28_0)
	if not arg_28_0.vars then
		return true
	end
	
	return #arg_28_0.vars.event_queue == 0
end

function SPLEventSystem.addCallbackOnFinish(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0.vars then
		return 
	end
	
	if not arg_29_0:isPlayingEvent() and not arg_29_0:isPaused() then
		if type(arg_29_1) == "function" then
			arg_29_1()
		end
		
		return 
	end
	
	if arg_29_2 then
		arg_29_0.vars.callback_on_finish[arg_29_2] = arg_29_1
	else
		table.insert(arg_29_0.vars.callback_on_finish, arg_29_1)
	end
end

function SPLEventSystem.procCallbackOnFinish(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.callback_on_finish or {}) do
		if type(iter_30_1) == "function" then
			iter_30_1()
		end
	end
	
	arg_30_0.vars.callback_on_finish = {}
end

function SPLEventSystem.onFinishEvent(arg_31_0)
	if not arg_31_0.vars then
		return 
	end
	
	if arg_31_0:isPaused() then
		return 
	end
	
	SPLObjectSystem:onFinishEvent()
	SPLMovableSystem:updateMovableArea()
	arg_31_0:procCallbackOnFinish()
	arg_31_0:setState(SPLEventState.IDLE)
	UIAction:Add(DELAY(200), arg_31_0.vars, "block")
end

function SPLEventSystem.onBeginStep(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	SPLObjectSystem:onBeginStep()
	SPLTileMapRenderer:revertMovableArea(true)
end

function SPLEventSystem.onEndStep(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	SPLTileMapRenderer:unmarking()
	SPLObjectSystem:onEndStep()
	arg_33_0:startEvent()
end

function SPLEventSystem.checkNear(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not arg_34_1 then
		return 
	end
	
	local var_34_0 = arg_34_1:getNearRange()
	
	if not var_34_0 then
		return 
	end
	
	local var_34_1 = SPLMovableSystem:getPlayerPos()
	local var_34_2 = SPLTileMapSystem:getPosById(arg_34_1:getUID())
	
	if HTUtil:isSamePosition(var_34_1, var_34_2) then
		return true
	end
	
	if var_34_0 >= HTUtil:getTileCost(var_34_1, var_34_2) then
		local var_34_3 = SPLPathFindingSystem:getReachableTiles(var_34_2, var_34_0) or {}
		
		for iter_34_0, iter_34_1 in pairs(var_34_3) do
			if HTUtil:isSamePosition(iter_34_1, var_34_1) then
				return true
			end
		end
	end
end

function SPLEventSystem.startEvent(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	if arg_35_0:isPlayingEvent() then
		return 
	end
	
	arg_35_0:setState(SPLEventState.START)
	
	if arg_35_0:isPaused() then
		return 
	end
	
	SPLTileMapRenderer:revertMovableArea(true)
	
	if arg_35_0:isEventQueueEmpty() then
		arg_35_0:onFinishEvent()
		
		return 
	end
	
	arg_35_0:procEvent()
end

function SPLEventSystem.procEvent(arg_36_0)
	if not arg_36_0.vars then
		return 
	end
	
	if arg_36_0:isPaused() then
		return 
	end
	
	arg_36_0:setState(SPLEventState.EVENT)
	
	if arg_36_0.vars.cur_event then
		arg_36_0:procObjectHandler(arg_36_0.vars.cur_event)
		
		arg_36_0.vars.cur_event = nil
	end
	
	local var_36_0 = arg_36_0:nextEvent()
	
	if not var_36_0 then
		arg_36_0:onFinishEvent()
		
		return 
	end
	
	arg_36_0.vars.cur_event = var_36_0
	
	if var_36_0:getActionCount() < 2 and var_36_0:isConcurrentEvent() then
		arg_36_0:procFunc(var_36_0)
	else
		arg_36_0:procAction(var_36_0)
	end
end

function SPLEventSystem.procAction(arg_37_0, arg_37_1)
	if not arg_37_0.vars then
		return 
	end
	
	if arg_37_0:isPaused() then
		return 
	end
	
	arg_37_1 = arg_37_1 or arg_37_0.vars.cur_event
	
	if not arg_37_1 then
		return 
	end
	
	local var_37_0 = arg_37_1:nextAction()
	
	if not var_37_0 then
		arg_37_0:procEvent()
		
		return 
	end
	
	local var_37_1 = arg_37_1:getActor()
	local var_37_2 = {}
	
	for iter_37_0, iter_37_1 in pairs(var_37_0) do
		local var_37_3 = iter_37_1:getType()
		local var_37_4 = iter_37_1:getParams()
		local var_37_5 = arg_37_0:getActionFunc(var_37_3, var_37_4, var_37_1) or arg_37_0:getCallAction(var_37_3, var_37_4, var_37_1)
		
		if not var_37_5 then
			Log.e("유효한 eff_type이 아닙니다. @" .. var_37_3)
		else
			table.insert(var_37_2, var_37_5)
		end
	end
	
	arg_37_0:setState(SPLEventState.ACTION)
	
	local var_37_6 = SPAWN(table.unpack(var_37_2))
	local var_37_7 = CALL(function()
		arg_37_0:procAction()
	end)
	
	UIAction:Add(SEQ(var_37_6, var_37_7), arg_37_0.vars.cur_event, "block")
end

function SPLEventSystem.procFunc(arg_39_0, arg_39_1)
	if not arg_39_0.vars then
		return 
	end
	
	arg_39_1 = arg_39_1 or arg_39_0.vars.cur_event
	
	if not arg_39_1 then
		return 
	end
	
	local var_39_0 = arg_39_1:getActionCount()
	
	for iter_39_0 = 1, var_39_0 do
		local var_39_1 = arg_39_1:nextAction()
		
		if not var_39_1 then
			break
		end
		
		for iter_39_1, iter_39_2 in pairs(var_39_1) do
			local var_39_2 = iter_39_2:getType()
			local var_39_3 = arg_39_0:getProcedureFunc(var_39_2)
			
			if type(var_39_3) == "function" then
				var_39_3(iter_39_2:getParams())
			else
				Log.e("유효한 proc_type이 아닙니다. @" .. var_39_2)
			end
		end
	end
	
	arg_39_0:procEvent()
end

function SPLEventSystem.procObjectHandler(arg_40_0, arg_40_1)
	if not arg_40_1 then
		return 
	end
	
	local var_40_0 = arg_40_1:getTrigger()
	local var_40_1 = arg_40_1:getActor()
	
	if not var_40_1 or not SPLObjectHandler[var_40_0] then
		return 
	end
	
	if arg_40_1:isMainEvent() and arg_40_0:checkCondition(arg_40_1) then
		local var_40_2 = var_40_1:getType()
		
		;(SPLObjectHandler[var_40_0][var_40_2] or SPLObjectHandler[var_40_0].default)(var_40_1)
	end
end

function SPLEventSystem.checkCondition(arg_41_0, arg_41_1)
	if not arg_41_1 then
		return 
	end
	
	local var_41_0 = arg_41_1:getConditionType()
	
	if not var_41_0 then
		return true
	end
	
	local var_41_1 = var_0_2[var_41_0]
	
	if not var_41_1 then
		Log.e("유효하지 않은 condition_type 입니다. @" .. var_41_0)
		
		return false
	end
	
	local var_41_2 = arg_41_1:getConditionValue()
	
	return var_41_1(var_41_2)
end

function SPLEventSystem.getActionFunc(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = var_0_0[arg_42_1]
	
	if not var_42_0 then
		return 
	end
	
	return var_42_0(arg_42_2, arg_42_3)
end

function SPLEventSystem.getProcedureFunc(arg_43_0, arg_43_1)
	return var_0_1[arg_43_1]
end

function SPLEventSystem.getCallAction(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = var_0_1[arg_44_1]
	
	if not var_44_0 then
		return 
	end
	
	return CALL(var_44_0, arg_44_2, arg_44_3)
end

function SPLEventSystem.getTargetTile(arg_45_0, arg_45_1, arg_45_2)
	if arg_45_1 == "player" then
		local var_45_0 = SPLMovableSystem:getPlayerPos()
		
		return SPLTileMapSystem:getTileByPos(var_45_0)
	elseif arg_45_1 == "tile" then
		local var_45_1 = string.split(arg_45_2, ",") or {}
		
		return SPLTileMapSystem:getTileById(var_45_1[1])
	elseif arg_45_1 == "object" then
		local var_45_2 = string.split(arg_45_2, ",") or {}
		local var_45_3 = SPLObjectSystem:getObjectByKey(var_45_2[1])
		
		if not var_45_3 then
			Log.e("유효하지 않은 object입니다.", arg_45_2)
			
			return 
		end
		
		return SPLTileMapSystem:getTileById(var_45_3:getUID())
	end
end

function SPLEventSystem.pause(arg_46_0)
	if not arg_46_0.vars then
		return 
	end
	
	arg_46_0.vars.paused = true
end

function SPLEventSystem.resume(arg_47_0)
	if not arg_47_0.vars then
		return 
	end
	
	if not arg_47_0:isPaused() then
		return 
	end
	
	arg_47_0.vars.paused = nil
	
	local var_47_0 = arg_47_0:getState()
	
	if var_47_0 == SPLEventState.ACTION then
		arg_47_0:procAction()
	elseif var_47_0 == SPLEventState.EVENT then
		arg_47_0:procEvent()
	elseif var_47_0 == SPLEventState.START then
		arg_47_0:startEvent()
	end
end

function SPLEventSystem.isPlayingEvent(arg_48_0)
	return arg_48_0:getState() > SPLEventState.START
end

function SPLEventSystem.isPaused(arg_49_0)
	return arg_49_0.vars and arg_49_0.vars.paused
end

function SPLEventSystem.isEnable(arg_50_0)
	return arg_50_0.vars ~= nil
end

function SPLEventSystem.debug_action(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0.vars then
		return 
	end
	
	arg_51_2 = arg_51_2 or {}
	
	if type(arg_51_2) == "string" then
		arg_51_2 = totable(arg_51_2)
	end
	
	local var_51_0 = arg_51_0:getActionFunc(arg_51_1, arg_51_2) or arg_51_0:getCallAction(arg_51_1, arg_51_2)
	
	if var_51_0 then
		UIAction:Add(var_51_0, {})
	end
end
