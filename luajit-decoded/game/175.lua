BattleViewer = {}
REPLAY_FILE_TOKEN = "-"
REPLAY_FILE_EXT = ".dat"
REPLAY_DATA_FOLDER = "/replay_data/"

local function var_0_0(arg_1_0)
	if not arg_1_0 then
		return 
	end
	
	if type(arg_1_0) == "table" and arg_1_0.isClassUnit then
		return arg_1_0
	end
	
	return Battle.logic:getUnit(arg_1_0)
end

local function var_0_1(arg_2_0)
	local var_2_0 = {}
	
	for iter_2_0, iter_2_1 in pairs(arg_2_0 or {}) do
		table.insert(var_2_0, var_0_0(iter_2_1))
	end
	
	return var_2_0
end

local function var_0_2(arg_3_0)
	if not arg_3_0 then
		return 
	end
	
	if type(arg_3_0) == "table" and arg_3_0.isClassState then
		return arg_3_0
	end
	
	for iter_3_0, iter_3_1 in pairs(Battle.logic.allocated_unit_tbl) do
		local var_3_0 = iter_3_1.states:findByGUId(arg_3_0)
		
		if var_3_0 then
			return var_3_0
		end
	end
end

function BattleViewer.create(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}
	
	copy_functions(BattleViewer, var_4_0)
	var_4_0:init(arg_4_1, arg_4_2)
	
	return var_4_0
end

function BattleViewer.init(arg_5_0, arg_5_1, arg_5_2)
	arg_5_2 = arg_5_2 or {}
	
	if arg_5_2.service and arg_5_2.service:isReset() then
		TransitionScreen:hide()
		UIAction:Remove("block")
		Dialog:msgBox(T("game_connect_lost") .. generateErrCode(CON_ERR.UNKNOWN), {
			handler = function()
				SceneManager:nextScene("lobby")
				SceneManager:resetSceneFlow()
			end
		})
		
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.mode = arg_5_2.mode or "none"
	arg_5_0.logic = arg_5_1
	arg_5_0.init_records = table.clone(arg_5_2.records or {})
	
	if arg_5_2.mode == "replay" then
		arg_5_0.player = BattleViewerReplay:create(arg_5_0, arg_5_2)
	else
		arg_5_0.player = BattleViewerPlayer:create(arg_5_0, arg_5_2)
	end
	
	arg_5_0.service = arg_5_2.service or nil
	arg_5_0.logger = BattleLogger:new()
	arg_5_0.record_data = {}
	arg_5_0.record_count = 1
	arg_5_0.vars.is_spectator = false
	arg_5_0.att_info_map = {}
	arg_5_0.vars.record_id = arg_5_2.record_id or 1
	arg_5_0.vars.match_info = arg_5_2.match_info
	arg_5_0.replay_from_scene_name = arg_5_2.replay_from_scene_name
	
	if arg_5_0.service then
		function arg_5_0.service.onUpdate()
			arg_5_0:onUpdate()
		end
		
		arg_5_0.vars.owner = arg_5_0.service:getUserUID()
		arg_5_0.vars.season_id = arg_5_0.service:getSeasonId()
		arg_5_0.vars.room_key = arg_5_0.service:getRoomKey()
		arg_5_0.vars.battle_room_key = arg_5_0.service:getBattleRoomKey()
		arg_5_0.vars.is_spectator = arg_5_0.service:isSpectator()
	end
	
	LuaEventDispatcher:removeEventListenerByKey("view.action")
	LuaEventDispatcher:removeEventListenerByKey("arena.service.viewer")
	LuaEventDispatcher:addEventListener("arena.service.req", LISTENER(BattleViewer.onRequest, arg_5_0), "arena.service.viewer")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(BattleViewer.onResponse, arg_5_0), "arena.service.viewer")
end

function BattleViewer.reset(arg_8_0)
	arg_8_0.vars = nil
	arg_8_0.mode = nil
	arg_8_0.logic = nil
	arg_8_0.player = nil
	arg_8_0.service = nil
	arg_8_0.logger = nil
	arg_8_0.att_info_map = nil
end

function BattleViewer.update(arg_9_0)
	if Battle:isRealtimeMode() or Battle:isReplayMode() then
		arg_9_0.player:update()
	end
end

function BattleViewer.isRunning(arg_10_0)
	if Battle:isReplayMode() then
		return arg_10_0.player.player:isRunning()
	else
		return arg_10_0.player:isRunning()
	end
end

function BattleViewer.isSpectator(arg_11_0)
	return arg_11_0.vars.is_spectator
end

function BattleViewer.getReplayFromSceneName(arg_12_0)
	return arg_12_0.replay_from_scene_name
end

function BattleViewer.getMatchInfo(arg_13_0)
	return arg_13_0.vars.match_info
end

function BattleViewer.convertUnit(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	arg_14_1.unit = var_0_0(arg_14_1.unit)
	arg_14_1.from = var_0_0(arg_14_1.from)
	arg_14_1.target = var_0_0(arg_14_1.target)
	arg_14_1.dead_unit = var_0_0(arg_14_1.dead_unit)
	arg_14_1.remain_units = var_0_1(arg_14_1.remain_units)
	
	if arg_14_1.att_info then
		arg_14_1.att_info.a_unit = var_0_0(arg_14_1.att_info.a_unit)
		arg_14_1.att_info.d_unit = var_0_0(arg_14_1.att_info.d_unit)
		arg_14_1.att_info.d_units = var_0_1(arg_14_1.att_info.d_units)
	end
end

function BattleViewer.convertState(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	arg_15_1.state = var_0_2(arg_15_1.state)
end

function BattleViewer.addInfo(arg_16_0, arg_16_1)
	arg_16_0.logger:add(arg_16_1)
end

function BattleViewer.popInfo(arg_17_0)
	local var_17_0 = arg_17_0.logger:pop()
	
	arg_17_0:convertUnit(var_17_0)
	arg_17_0:convertState(var_17_0)
	
	return var_17_0
end

function BattleViewer.setAttackInfo(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 or not arg_18_2 or not arg_18_0.att_info_map then
		return 
	end
	
	local var_18_0 = arg_18_1:getUID()
	
	arg_18_0.att_info_map[var_18_0] = arg_18_2
end

function BattleViewer.getAttackInfo(arg_19_0, arg_19_1)
	if not arg_19_1 or not arg_19_0.att_info_map then
		return 
	end
	
	local var_19_0 = arg_19_1:getUID()
	
	return arg_19_0.att_info_map[var_19_0]
end

function BattleViewer.getResult(arg_20_0)
	return arg_20_0.vars.result
end

function BattleViewer.getTeamRes(arg_21_0, arg_21_1, arg_21_2)
	return arg_21_0.logic:getTeamRes(arg_21_1, arg_21_2)
end

function BattleViewer.applySnapData(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_1 then
		return 
	end
	
	arg_22_0.logic:command({
		cmd = "Snapshot",
		snap_data = arg_22_1,
		opts = arg_22_2
	})
end

function BattleViewer.exit(arg_23_0)
	if not arg_23_0.service or arg_23_0.service:isReset() then
		return 
	end
	
	local var_23_0 = arg_23_0.service:isRoundMode() and T("pvp_rta_mock_leave_room2") or T("pvp_rta_mock_leave_room")
	
	Dialog:msgBox(var_23_0, {
		yesno = true,
		handler = function()
			if arg_23_0.service and not arg_23_0.service:isReset() then
				arg_23_0.service:resetWebSocket()
				arg_23_0.service:query("command", {
					type = "exit"
				})
				arg_23_0.service:reset()
				MatchService:query("arena_net_enter_lobby", nil, function(arg_25_0)
					arg_25_0.mode = "VS_FRIEND"
					
					SceneManager:nextScene("arena_net_lobby", arg_25_0)
					SceneManager:resetSceneFlow()
				end)
			end
		end
	})
end

function BattleViewer.updateState(arg_26_0, arg_26_1)
	if not arg_26_0.service or arg_26_0.service:isChangeBlocked() then
		return 
	end
	
	if arg_26_1.cur_state == "LOUNGE" or ClearResult:isShow() then
		Scheduler:removeByName(ARENA_NET_BATTLE_READY)
		
		return 
	elseif arg_26_1.cur_state == "NEXT_ROUND" or ClearResult:isShow() then
		Scheduler:removeByName(ARENA_NET_BATTLE_READY)
		
		return 
	end
	
	arg_26_0.service:changeState(arg_26_1.cur_state, arg_26_1)
end

function BattleViewer.updateViewState(arg_27_0, arg_27_1, arg_27_2)
	arg_27_1 = arg_27_1 or {}
	
	if arg_27_1.snap_data then
		arg_27_0:applySnapData(arg_27_1.snap_data, {
			clearAll = true
		})
	end
	
	local var_27_0 = arg_27_0.logic:getTurnOwner()
	
	for iter_27_0, iter_27_1 in pairs(arg_27_1.units_status or {}) do
		local var_27_1 = Battle.logic:getUnit(iter_27_0)
		
		if var_27_1 then
			var_27_1.status = iter_27_1
		end
	end
	
	if arg_27_2 and Battle.logic:getRunningEventState() == "running" then
		local var_27_2, var_27_3 = var_27_0:getRestTimeAndTick()
		
		BattleUI:playAttackOrder(var_27_0, var_27_3)
	end
	
	for iter_27_2, iter_27_3 in pairs(Battle.logic.units or {}) do
		local function var_27_4(arg_28_0)
			if arg_28_0:isDead() then
				if get_cocos_refid(arg_28_0.model) then
					local var_28_0, var_28_1 = BattleLayout:getUnitFieldPosition(arg_28_0)
					
					arg_28_0.model:setPosition(var_28_0, var_28_1)
					
					if arg_27_2 then
						arg_28_0.model:setVisible(false)
					else
						Battle:deadEffect(arg_28_0, arg_28_0.model)
					end
					
					if arg_28_0.ui_vars and arg_28_0.ui_vars.gauge then
						arg_28_0.ui_vars.gauge:setVisible(false)
					end
				end
			elseif get_cocos_refid(arg_28_0.model) then
				arg_28_0.model:setVisible(true)
				arg_28_0.model:setOpacity(255)
				arg_28_0.model:setTimeScale(1)
				arg_28_0.model:setColor(Battle.vars.ambient_color)
				
				if arg_28_0:getAlly() == FRIEND then
					arg_28_0.model:setScaleX(math.abs(arg_28_0.model:getScaleX()) * 1)
				else
					arg_28_0.model:setScaleX(math.abs(arg_28_0.model:getScaleX()) * -1)
				end
				
				if arg_28_0.ui_vars and arg_28_0.ui_vars.gauge then
					arg_28_0.ui_vars.gauge:setVisible(true)
					arg_28_0.ui_vars.gauge:setOpacity(255)
				else
					BattleUI:register(arg_28_0)
				end
			end
		end
		
		local function var_27_5(arg_29_0)
			if not arg_29_0 or arg_29_0:isDead() then
				return 
			end
			
			local var_29_0 = Battle:getIdleAni(arg_29_0)
			
			if arg_29_0.model then
				arg_29_0.model:removePartsObject("", "effect", true)
				arg_29_0.model:setAnimation(0, var_29_0, true)
			end
		end
		
		local function var_27_6(arg_30_0)
			if not arg_30_0 or arg_30_0:isDead() then
				return 
			end
			
			if arg_30_0.ui_vars.gauge and arg_30_0.ui_vars.gauge:isValid() then
				if arg_27_2 then
					arg_30_0.ui_vars.gauge:setHP(true, 0)
				else
					arg_30_0.ui_vars.gauge:setHP()
				end
				
				arg_30_0.ui_vars.gauge:updateSP()
			end
		end
		
		local function var_27_7(arg_31_0)
			if not arg_31_0 or arg_31_0:isDead() then
				return 
			end
			
			for iter_31_0, iter_31_1 in pairs(arg_31_0.states.List) do
				if not iter_31_1:isInvalid() then
					Battle:onAddState(arg_31_0, iter_31_1, true, nil, true)
				end
			end
			
			if arg_31_0.db.code == "c1067" then
				if arg_31_0:isModelChange() then
					local var_31_0 = DB("character", arg_31_0:getDisplayCode(), {
						"model_id2"
					})
					
					arg_31_0.model_vars = {
						model_id = var_31_0
					}
				else
					arg_31_0.model_vars = nil
				end
				
				BattleUtil:updateModel(arg_31_0)
				
				if get_cocos_refid(arg_31_0.model) then
					BattleAction:Add(Battle:getIdleAction(arg_31_0), arg_31_0.model)
				end
				
				UIBattleAttackOrder:activeUnitInfo(arg_31_0)
				UIBattleAttackOrder:updateUnitInfo(arg_31_0)
			end
			
			if arg_31_0.ui_vars and arg_31_0.ui_vars.gauge and arg_31_0.ui_vars.gauge:isValid() then
				arg_31_0.ui_vars.gauge:removeAllIcon()
				arg_31_0.ui_vars.gauge:updateState(true)
			end
		end
		
		var_27_4(iter_27_3)
		var_27_5(iter_27_3)
		var_27_6(iter_27_3)
		var_27_7(iter_27_3)
		
		if arg_27_2 then
			local var_27_8 = "actionbar_" .. iter_27_3:getUID()
			
			BattleUIAction:Remove(var_27_8)
			UIBattleAttackOrder:update(iter_27_3, nil, true, true)
		end
	end
	
	BattleUI:updatePVPGauge(false, true)
	BattleUI:updateUnitFaces()
	BattleUI:updatePVPSoulPiece()
	
	if var_27_0 then
		UIBattleAttackOrder:activeUnitInfo(var_27_0)
		UIBattleAttackOrder:updateUnitInfo(var_27_0)
	end
	
	BattleTopBar:updateRTAPenalyInfo()
	
	if arg_27_2 then
		if Battle.logic:getRunningEventState() == "running" then
			if Battle.logic.pet and Battle.logic.pet.model then
				Battle.logic.pet.model:setVisible(false)
			end
			
			Battle:setStageMode(STAGE_MODE.EVENT)
			Battle:onReadyAttack(var_27_0, true)
		elseif Battle.logic:isEnded() then
			Battle:setStageMode(STAGE_MODE.STAY)
		else
			Battle:setStageMode(STAGE_MODE.MOVE)
			BattleMapManager:show(true)
		end
		
		local var_27_9 = Battle.logic:getInSightRoadSectorTbl()
		
		for iter_27_4, iter_27_5 in pairs(var_27_9 or {}) do
			Battle:onInSightRoadSector(iter_27_4)
		end
		
		local var_27_10 = Battle.logic:getCurrentRoadInfo()
		local var_27_11 = Battle.logic:getCurrentRoadSectorId()
		local var_27_12 = Battle.logic:getRoadSectorObject(var_27_11)
		local var_27_13 = BattleField:getRoadSectorFieldInfo(var_27_12)
		local var_27_14 = var_27_10.road_reverse and -1 or 1
		local var_27_15 = {
			pos = var_27_13.position - BATTLE_LAYOUT.TEAM_WIDTH * var_27_14,
			dir = var_27_14
		}
		
		if var_27_15.pos then
			BattleLayout:setDirection(var_27_15.dir)
			BattleLayout:setFieldPosition(var_27_15.pos)
		end
		
		if Battle.vars.battle_state == "finish" and Battle:getNextDungeon(Battle.logic) and not string.starts(Battle.logic.type or "", "dungeon") then
			Battle:showGuideArrow()
			BattleField:addWarpLine("finishToNext")
			BattleField:addWarpLine("finishToLobby")
			UIAction:Add(SEQ(DELAY(300), CALL(function()
				BattleField:lockViewPortRange(true, {
					maxOffsetX = 0,
					minOffsetX = -DESIGN_WIDTH / 2
				})
			end)), SceneManager:getCurrentScene(), "sssads")
		end
	end
end

function BattleViewer.onUpdate(arg_33_0)
	local var_33_0 = {
		record_id = arg_33_0.vars.record_id
	}
	
	arg_33_0.service:query("watch", var_33_0)
	
	if not arg_33_0:isSpectator() then
		local var_33_1 = {
			[arg_33_0.vars.owner] = {
				ping = ArenaNetMeter:lastPing()
			}
		}
		
		BattleUI:updatePingInfo(var_33_1)
	end
end

function BattleViewer.onRequest(arg_34_0, arg_34_1, arg_34_2)
	if arg_34_2 and arg_34_2.type == "skill" then
		if arg_34_1 == ARENA_NET_REQUEST.REQUEST then
			if arg_34_0.logic:getTurnOwner():getAlly() == FRIEND and not arg_34_0.service:isAdminMode() then
				BattleUI:highlightMainSkill(true)
				BattleUI:hideSkillButtons()
				BattleUI:hideTargetButtons()
			end
		elseif arg_34_1 == ARENA_NET_REQUEST.FAIL then
			local var_34_0 = arg_34_0.logic:getTurnOwner()
			local var_34_1 = arg_34_2.skill_id
			local var_34_2 = arg_34_0.logic:getTargetCandidates(var_34_1, var_34_0, nil, true)
			
			if Battle:getProcInfoState() == "ReadyAttack" and var_34_0:getAlly() == FRIEND and not arg_34_0.service:isAdminMode() then
				BattleUI:showSkillButtons(var_34_0)
				BattleUI:showTargetButtons(var_34_0, var_34_2)
			end
		end
	end
end

function BattleViewer.onResponse(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = table.count(arg_35_2 or {})
	
	if not arg_35_0.vars or var_35_0 == 0 or not arg_35_1 then
		return 
	end
	
	local var_35_1 = "on" .. string.ucfirst(arg_35_1)
	
	if arg_35_0[var_35_1] then
		arg_35_0[var_35_1](arg_35_0, arg_35_2, arg_35_3)
	end
end

function BattleViewer.onWatch(arg_36_0, arg_36_1)
	if ClearResult:isShow() then
		return 
	end
	
	arg_36_0:updateState(arg_36_1)
	
	arg_36_0.record_data[arg_36_0.record_count] = arg_36_0.record_data[arg_36_0.record_count] or {}
	
	local var_36_0 = arg_36_1.recordinfo
	
	if var_36_0 and var_36_0.id and arg_36_0.vars.record_id < var_36_0.id then
		arg_36_0.vars.record_id = var_36_0.id
		
		restoreArenaNetBattle(arg_36_0.logic, var_36_0)
		Battle:showEmptyPositionTargets(false, arg_36_0.logic:getTurnOwner())
		
		arg_36_0.record_data[arg_36_0.record_count].record_info = table.clone(var_36_0)
		arg_36_0.record_data[arg_36_0.record_count].record_info.records_snap = nil
		
		LuaEventDispatcher:dispatchEvent("player.event", {
			type = "EXECUTE",
			infos = var_36_0.records
		})
	end
	
	local var_36_1 = arg_36_1.timeinfo
	
	if var_36_1 then
		arg_36_0.record_data[arg_36_0.record_count].time_info = table.clone(var_36_1)
		
		BattleUI:updateArenaTimer(var_36_1)
	end
	
	local var_36_2 = arg_36_1.emoginfo
	
	if var_36_2 then
		local var_36_3 = BattleUI:getEmojiPanel()
		
		if var_36_3 and var_36_3:isNewEmoji(var_36_2) then
			arg_36_0.record_data[arg_36_0.record_count].emogi_info = table.clone(var_36_2)
		end
		
		LuaEventDispatcher:dispatchEvent("arena.emogi.res", "push", var_36_2)
	end
	
	local var_36_4 = arg_36_1.envinfo
	
	if var_36_4 then
		InBattleEsc:update(var_36_4)
	end
	
	local var_36_5 = arg_36_1.result
	
	if var_36_5 then
		local var_36_6 = arg_36_0.service:getMatchMode()
		
		if var_36_6 == "net_rank" then
			arg_36_0.service:reset()
		elseif var_36_6 == "net_event_rank" and var_36_5.round_info and var_36_5.round_info.finish then
			arg_36_0.service:reset()
		end
		
		arg_36_0.vars.result = var_36_5
		
		if var_36_5.reason ~= 1 then
			Battle:doEndBattle({
				fatal_stop = true
			})
		end
	end
	
	local var_36_7 = arg_36_1.pinginfo
	
	if var_36_7 then
		BattleUI:updatePingInfo(var_36_7)
	end
	
	arg_36_0.record_count = arg_36_0.record_count + 1
end

function BattleViewer.sendReady(arg_37_0)
	if not Battle:isRealtimeMode() then
		return 
	end
	
	if arg_37_0:isSpectator() then
		return 
	end
	
	if Scheduler:findByName(ARENA_NET_BATTLE_READY) then
		return 
	end
	
	if arg_37_0.service and arg_37_0.service:isReset() then
		Scheduler:removeByName(ARENA_NET_BATTLE_READY)
		
		return 
	end
	
	local function var_37_0()
		arg_37_0.service:query("command", {
			type = "ready"
		})
	end
	
	var_37_0()
	Scheduler:addInterval(nil, 500, function()
		var_37_0()
	end):setName(ARENA_NET_BATTLE_READY)
end

function BattleViewer.onReady(arg_40_0, arg_40_1, arg_40_2)
	print("ON READY")
	
	if not arg_40_1 then
		return 
	end
	
	if arg_40_1.ready_state == "ready" then
		UIBattleActWait:hideActWaitPopup()
		
		local var_40_0 = arg_40_0.logic:getTurnOwner()
		
		if var_40_0.inst.ally == FRIEND then
			BattleUI:showSkillButtons(var_40_0)
			Battle:showFocusRing(var_40_0)
			Battle:onTouchSkill(1)
			Battle:playAutoSelectTarget(var_40_0)
			UIBattleActWait:hideActWaitPopup()
		end
		
		Scheduler:removeByName(ARENA_NET_BATTLE_READY)
	else
		local var_40_1 = BattleField:getUILayer()
		
		if get_cocos_refid(var_40_1) then
			UIBattleActWait:showActWaitPopup()
		end
	end
end

function BattleViewer.onSkill(arg_41_0, arg_41_1, arg_41_2)
	if arg_41_2 ~= nil and arg_41_2 ~= 0 then
		BattleUI:highlightMainSkill(false)
		
		return 
	end
	
	UIBattleActWait:hideActWaitPopup()
	Battle:showEmptyPositionTargets(false, arg_41_0.logic:getTurnOwner())
	
	local var_41_0 = arg_41_1.recordinfo
	
	if var_41_0 and arg_41_0.vars.record_id < var_41_0.id then
		arg_41_0.vars.record_id = var_41_0.id
		arg_41_0.record_data[arg_41_0.record_count] = arg_41_0.record_data[arg_41_0.record_count] or {}
		arg_41_0.record_data[arg_41_0.record_count].record_info = table.clone(var_41_0)
		
		LuaEventDispatcher:dispatchEvent("player.event", {
			type = "EXECUTE",
			infos = var_41_0.records
		})
	end
end

function BattleViewer.createViewHandle(arg_42_0, arg_42_1, arg_42_2)
	return (ViewHandle(arg_42_0, arg_42_1, arg_42_2))
end

function BattleViewer.createViewState(arg_43_0, arg_43_1)
	if not ViewDef[arg_43_1] then
		Log.e("Invalid view state type", arg_43_1)
	end
	
	return (ViewDef[arg_43_1].ACTION(arg_43_1))
end

function BattleViewer.createViewAction(arg_44_0, arg_44_1)
	return arg_44_1
end

function BattleViewer.getBattleReplayData(arg_45_0, arg_45_1)
	local var_45_0 = {}
	local var_45_1 = table.shallow_clone(arg_45_0.logic.init_data)
	local var_45_2 = arg_45_0.logic.team_data
	local var_45_3 = arg_45_0.logic.map
	
	var_45_1.service = nil
	var_45_0.mode = arg_45_0.service:getMatchMode()
	var_45_0.logic_data = {
		init_data = var_45_1,
		team_data = Battle.logic.team_data,
		map_data = Battle.logic.map
	}
	var_45_0.version_info = {
		res_version = getenv("patch.res.version"),
		time = os.time()
	}
	var_45_0.match_info = arg_45_0.vars.match_info
	var_45_0.init_record = arg_45_0.init_records
	var_45_0.record_data = arg_45_0.record_data
	var_45_0.result_info = {
		net_pvp = true,
		map_id = "pvp001",
		net_pvp_result = arg_45_0:getResult()
	}
	var_45_0.verify_data = arg_45_1
	
	return var_45_0
end

function restoreArenaNetBattle(arg_46_0, arg_46_1)
	if arg_46_1.snap then
		local var_46_0 = {}
		
		table.reverse(arg_46_1.records)
		
		local var_46_1 = table.find(arg_46_1.records, function(arg_47_0, arg_47_1)
			return arg_47_1 and arg_47_1.state and arg_47_1.state == "START_TURN"
		end)
		
		for iter_46_0, iter_46_1 in pairs(arg_46_1.records or {}) do
			if iter_46_1.type == "HANDLE" or iter_46_0 <= (var_46_1 or math.huge) then
				table.insert(var_46_0, iter_46_1)
			end
		end
		
		table.reverse(var_46_0)
		table.insert(var_46_0, {
			type = "update_viewer",
			snap_data = arg_46_1.snap
		})
		
		arg_46_1.records = var_46_0
	end
end

function BattleViewer.checkAndMakeReplayDirectory(arg_48_0)
	if cc.FileUtils:getInstance():isDirectoryExist(getenv("app.data_path") .. REPLAY_DATA_FOLDER) then
		return true
	else
		return (cc.FileUtils:getInstance():createDirectory(getenv("app.data_path") .. REPLAY_DATA_FOLDER))
	end
end

function BattleViewer.checkSaveLocalReplay(arg_49_0, arg_49_1)
	if ContentDisable:byAlias("world_arena_replay") then
		return false
	end
	
	if not arg_49_0.service then
		return false
	end
	
	if arg_49_0.service:getMatchMode() ~= "net_rank" and arg_49_0.service:getMatchMode() ~= "net_event_rank" then
		return false
	end
	
	if not arg_49_1 or not arg_49_1.replay_data then
		return false
	end
	
	return true
end

function BattleViewer.saveReplay(arg_50_0, arg_50_1, arg_50_2)
	if not arg_50_0:checkAndMakeReplayDirectory() then
		return false
	end
	
	local var_50_0 = (function()
		local var_51_0 = arg_50_0.service:getMatchMode()
		local var_51_1 = arg_50_0.vars.battle_room_key
		local var_51_2 = os.time()
		local var_51_3 = REPLAY_FILE_EXT
		local var_51_4 = REPLAY_FILE_TOKEN
		
		if var_51_0 and var_51_1 and var_51_2 then
			return var_51_0 .. var_51_4 .. tostring(var_51_1) .. var_51_4 .. tostring(var_51_2) .. var_51_3
		end
	end)()
	
	if not var_50_0 then
		return false
	end
	
	local var_50_1 = arg_50_0:getBattleReplayData(arg_50_1)
	local var_50_2
	
	if arg_50_2 then
		local var_50_3 = json.encode(var_50_1)
		
		Log.i("save local to json", string.len(var_50_3))
		
		var_50_2 = lz4_compress(var_50_3)
	else
		local var_50_4 = json.encode(var_50_1)
		
		Log.i("save local to json", string.len(var_50_4))
		
		var_50_2 = var_50_4
	end
	
	if var_50_0 and var_50_2 then
		Log.i("save local replay success", var_50_0)
		io.writefile(getenv("app.data_path") .. REPLAY_DATA_FOLDER .. var_50_0, var_50_2)
		
		return true
	end
end

function BattleViewer.loadLocalReplay(arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_1 then
		return nil, "no file name"
	end
	
	local function var_52_0(arg_53_0)
		local var_53_0 = arg_53_0:seek()
		local var_53_1 = arg_53_0:seek("end")
		
		arg_53_0:seek("set", var_53_0)
		
		return var_53_1
	end
	
	local var_52_1 = getenv("app.data_path") .. REPLAY_DATA_FOLDER .. arg_52_1 .. REPLAY_FILE_EXT
	local var_52_2 = io.open(var_52_1, "rb")
	
	if var_52_2 then
		local var_52_3 = var_52_0(var_52_2)
		local var_52_4 = var_52_2:read("*a")
		local var_52_5
		
		if arg_52_2 then
			local var_52_6 = lz4_uncompress(var_52_4)
			
			var_52_5 = json.decode(var_52_6)
		else
			var_52_5 = json.decode(var_52_4)
		end
		
		Log.i("loaded local file", arg_52_1)
		
		return var_52_5
	else
		return nil, "cannot open file"
	end
end

local function var_0_3(arg_54_0, arg_54_1)
	if not arg_54_0 or not arg_54_1 then
		return 
	end
	
	local var_54_0 = "replay"
	local var_54_1 = arg_54_0.match_info
	local var_54_2 = arg_54_0.version_info
	local var_54_3 = arg_54_0.init_record
	local var_54_4 = arg_54_0.record_data
	local var_54_5 = arg_54_0.result_info
	local var_54_6 = arg_54_0.logic_data
	local var_54_7
	local var_54_8 = false
	
	if PLATFORM == "win32" and not PRODUCTION_MODE and DEBUG.ignore_res_version then
		var_54_8 = true
	end
	
	if not var_54_8 then
		if not var_54_6 or not var_54_1 or not var_54_2 or not var_54_3 or not var_54_4 or not var_54_5 then
			balloon_message_with_sound("msg_pvp_rta_replay_lock_crash")
			
			return 
		end
		
		if var_54_2 and var_54_2.res_version and arg_54_1 > tonumber(var_54_2.res_version) then
			balloon_message_with_sound("msg_pvp_rta_replay_lock_version")
			
			return 
		end
	end
	
	if arg_54_0.verify_data then
		local var_54_9 = Base64.decode(arg_54_0.verify_data)
		local var_54_10 = lz4_uncompress(var_54_9)
		
		var_54_7 = json.decode(var_54_10).snap_data
	end
	
	var_54_6.init_data.mode = var_54_0
	var_54_6.init_data.service = nil
	
	local var_54_11 = BattleLogic:makeLogic(var_54_6.map_data, var_54_6.team_data, var_54_6.init_data)
	
	if not var_54_11 then
		balloon_message_with_sound("msg_pvp_rta_replay_lock_crash")
		
		return 
	end
	
	if GachaUnit:isActive() then
		GachaIntroduceBG:closeWithSound()
		CocosSchedulerManager:removeCustomSchForPoll()
	end
	
	ArenaService:setMatchMode(arg_54_0.mode)
	SceneManager:nextScene("battle", {
		logic = var_54_11,
		mode = var_54_0,
		replay_from_scene_name = SceneManager:getCurrentSceneName(),
		version_info = var_54_2,
		match_info = var_54_1,
		snap_data = var_54_7,
		init_record = var_54_3,
		record_data = var_54_4,
		result_info = var_54_5
	})
end

function BattleViewer.playAIReplay(arg_55_0, arg_55_1)
	local function var_55_0(arg_56_0)
		local var_56_0 = {}
		
		for iter_56_0, iter_56_1 in pairs(arg_56_0 or {}) do
			local var_56_1 = iter_56_1
			
			table.insert(var_56_0, var_56_1)
		end
		
		return var_56_0
	end
	
	local function var_55_1(arg_57_0)
		local var_57_0 = {}
		
		for iter_57_0, iter_57_1 in pairs(arg_57_0 or {}) do
			local var_57_1 = {
				{},
				{},
				{
					record_info = {
						records = iter_57_1
					}
				}
			}
			
			table.insert(var_57_0, var_57_1)
		end
		
		return var_57_0
	end
	
	local var_55_2 = "replay"
	local var_55_3 = arg_55_1.init_data
	local var_55_4 = arg_55_1.team_data
	local var_55_5 = arg_55_1.map_data
	local var_55_6 = arg_55_1.init_record
	local var_55_7 = arg_55_1.command_data
	local var_55_8 = arg_55_1.snap_data
	local var_55_9 = arg_55_1.record_data
	local var_55_10 = var_55_0(var_55_8)
	local var_55_11 = var_55_1(var_55_9)
	
	var_55_3.mode = var_55_2
	
	local var_55_12 = BattleLogic:makeLogic(var_55_5, var_55_4, var_55_3)
	
	if not var_55_12 then
		Log.e("logic genarate fail")
		
		return 
	end
	
	SceneManager:nextScene("battle", {
		logic = var_55_12,
		mode = var_55_2,
		init_record = var_55_6,
		snap_datas = var_55_10,
		turn_datas = var_55_11,
		record_data = var_55_9
	})
end

function BattleViewer.playLocalReplay(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0, var_58_1 = arg_58_0:loadLocalReplay(arg_58_1, true)
	
	if not var_58_0 then
		Log.e("load local replay data fail", arg_58_1, var_58_1)
		
		return 
	end
	
	var_0_3(var_58_0, arg_58_2)
end

function BattleViewer.playRemoteReplay(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	if not arg_59_1 or not arg_59_2 then
		return 
	end
	
	local var_59_0 = Base64.decode(arg_59_2)
	local var_59_1 = lz4_uncompress(var_59_0)
	local var_59_2 = json.decode(var_59_1)
	
	var_59_2.verify_data = arg_59_1
	
	var_0_3(var_59_2, arg_59_3)
end

function BattleViewer.getLocalReplayData(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_1 then
		return nil, "no file name"
	end
	
	local var_60_0 = getenv("app.data_path") .. REPLAY_DATA_FOLDER .. arg_60_1 .. REPLAY_FILE_EXT
	local var_60_1 = io.open(var_60_0, "rb")
	
	if var_60_1 then
		local var_60_2 = var_60_1:read("*a")
		local var_60_3 = lz4_uncompress(var_60_2)
		local var_60_4 = json.decode(var_60_3)
		local var_60_5 = var_60_4.verify_data
		local var_60_6 = var_60_4
		
		var_60_6.verify_data = nil
		
		local var_60_7
		
		if var_60_5 and var_60_6 then
			local var_60_8 = lz4_compress(json.encode(var_60_6))
			
			if var_60_8 then
				if arg_60_2 then
					var_60_7 = Base64.encode(var_60_8)
				end
				
				return {
					verify_data = var_60_5,
					unverify_data = var_60_7
				}
			end
		end
		
		if arg_60_2 then
			var_60_4 = Base64.encode(var_60_2)
		end
		
		return var_60_4
	else
		return nil, "cannot find file"
	end
end

function BattleViewer.isExistLocalReplayFile(arg_61_0, arg_61_1)
	if not arg_61_1 then
		return false, "not file name"
	end
	
	local var_61_0 = getenv("app.data_path") .. REPLAY_DATA_FOLDER .. arg_61_1 .. REPLAY_FILE_EXT
	
	if io.exists(var_61_0) then
		return true
	end
	
	return false, "cannot find file"
end

function BattleViewer.getLocalReplayFileNameByOpts(arg_62_0, arg_62_1)
	if not arg_62_1 then
		return nil
	end
	
	local var_62_0, var_62_1 = arg_62_0:getLocalReplayFilePropertyList()
	
	if var_62_1 then
		return nil, var_62_1
	end
	
	for iter_62_0, iter_62_1 in pairs(var_62_0) do
		if iter_62_1[1] == arg_62_1.mode and iter_62_1[2] == arg_62_1.uid then
			return iter_62_1[1] .. REPLAY_FILE_TOKEN .. iter_62_1[2] .. REPLAY_FILE_TOKEN .. iter_62_1[3]
		end
	end
	
	return nil, "not exist file"
end

function BattleViewer.getLocalReplayFileNameList(arg_63_0)
	local var_63_0 = getenv("app.data_path") .. REPLAY_DATA_FOLDER
	
	if cc.FileUtils:getInstance():isDirectoryExist(var_63_0) then
		local var_63_1 = dir_scan(var_63_0, "*.dat", 1)
		local var_63_2 = {}
		
		for iter_63_0, iter_63_1 in pairs(var_63_1) do
			local var_63_3, var_63_4 = string.find(iter_63_1, "replay_data/")
			local var_63_5 = string.len(iter_63_1)
			
			if var_63_4 then
				local var_63_6 = string.sub(iter_63_1, var_63_4 + 1, var_63_5 - 4)
				
				table.insert(var_63_2, var_63_6)
			end
		end
		
		local var_63_7
		
		if table.empty(var_63_2) then
			var_63_7 = "empty replay_data directory"
		end
		
		return var_63_2, var_63_7
	end
	
	return nil, "cannot find directory"
end

function BattleViewer.getLocalReplayFilePropertyList(arg_64_0)
	local var_64_0, var_64_1 = arg_64_0:getLocalReplayFileNameList()
	
	if var_64_1 then
		return nil, var_64_1
	end
	
	arg_64_0:removeInvalidReplayFiles()
	
	local var_64_2 = {}
	
	for iter_64_0, iter_64_1 in pairs(var_64_0) do
		local var_64_3 = string.split(iter_64_1, "-")
		
		if not table.empty(var_64_3) and table.count(var_64_3) == 3 then
			table.insert(var_64_2, var_64_3)
		end
	end
	
	table.sort(var_64_2, function(arg_65_0, arg_65_1)
		return arg_65_0[3] > arg_65_1[3]
	end)
	
	return var_64_2
end

function BattleViewer.removeInvalidReplayFiles(arg_66_0)
	local var_66_0, var_66_1 = arg_66_0:getLocalReplayFileNameList()
	
	if var_66_1 then
		return 
	end
	
	local function var_66_2(arg_67_0)
		if table.empty(arg_67_0) or table.count(arg_67_0) ~= 3 then
			return true
		end
		
		if arg_67_0[1] ~= "net_rank" and arg_67_0[1] ~= "net_event_rank" then
			return true
		end
		
		for iter_67_0 = 2, 3 do
			if not arg_67_0[iter_67_0] then
				return true
			end
		end
		
		return false
	end
	
	local var_66_3 = getenv("app.data_path") .. REPLAY_DATA_FOLDER
	
	for iter_66_0, iter_66_1 in pairs(var_66_0) do
		local var_66_4 = string.split(iter_66_1, "-")
		
		if var_66_2(var_66_4) then
			local var_66_5 = var_66_3 .. iter_66_1 .. REPLAY_FILE_EXT
			
			if cc.FileUtils:getInstance():removeFile(var_66_5) and not PRODUCTION_MODE then
				Log.e("Delete File Name: " .. iter_66_1)
				Log.e("Delete File Full Path: " .. var_66_5)
			end
		end
	end
end

function BattleViewer.removeReplayFilesByCount(arg_68_0, arg_68_1)
	if not arg_68_1 then
		return 
	end
	
	local var_68_0, var_68_1 = arg_68_0:getLocalReplayFilePropertyList()
	
	if var_68_1 then
		return 
	end
	
	local var_68_2 = table.count(var_68_0)
	
	if var_68_2 < arg_68_1 then
		return 
	end
	
	local var_68_3 = getenv("app.data_path") .. REPLAY_DATA_FOLDER
	
	for iter_68_0 = arg_68_1 + 1, var_68_2 do
		local var_68_4 = var_68_0[iter_68_0]
		local var_68_5 = var_68_4[1] .. REPLAY_FILE_TOKEN .. var_68_4[2] .. REPLAY_FILE_TOKEN .. var_68_4[3]
		local var_68_6 = var_68_3 .. var_68_5 .. REPLAY_FILE_EXT
		
		if cc.FileUtils:getInstance():removeFile(var_68_6) and not PRODUCTION_MODE then
			Log.i("Delete File: " .. var_68_6)
		end
	end
end

local var_0_4 = 1

function BattleViewer.removeReplayFilesByDay(arg_69_0, arg_69_1)
	if not arg_69_1 then
		return 
	end
	
	local var_69_0, var_69_1 = arg_69_0:getLocalReplayFilePropertyList()
	
	if var_69_1 then
		return 
	end
	
	local var_69_2 = getenv("app.data_path") .. REPLAY_DATA_FOLDER
	local var_69_3 = (arg_69_1 + var_0_4) * 24 * 60 * 60
	
	for iter_69_0, iter_69_1 in pairs(var_69_0) do
		if iter_69_1[3] and tonumber(iter_69_1[3]) + var_69_3 <= os.time() then
			local var_69_4 = iter_69_1[1] .. REPLAY_FILE_TOKEN .. iter_69_1[2] .. REPLAY_FILE_TOKEN .. iter_69_1[3]
			local var_69_5 = var_69_2 .. var_69_4 .. REPLAY_FILE_EXT
			
			if cc.FileUtils:getInstance():removeFile(var_69_5) and not PRODUCTION_MODE then
				Log.i("Delete File: " .. var_69_5)
			end
		end
	end
end
