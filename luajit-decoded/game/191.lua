function Battle.getTargetUNIT(arg_1_0, arg_1_1)
	return arg_1_1.target or arg_1_0.logic:getUnit(arg_1_1.target_uid)
end

function Battle.isProcInfoActvate(arg_2_0)
	if BattleAction:Find("battle.proc_lock") then
		return false
	end
	
	return (arg_2_0.vars.NEXT_PROC_TICK or 0) < LAST_TICK
end

function Battle.setNextProcInfoDelay(arg_3_0, arg_3_1)
	arg_3_0.vars.NEXT_PROC_TICK = LAST_TICK + arg_3_1
end

function Battle.async_call(arg_4_0, arg_4_1, ...)
	if not arg_4_0.vars.async_procinfo_list then
		arg_4_0.vars.async_procinfo_list = {}
	end
	
	table.insert(arg_4_0.vars.async_procinfo_list, bind_func(arg_4_1, ...))
end

function Battle.invokeAsyncProcInfos(arg_5_0, arg_5_1, ...)
	if arg_5_0:isPlayingBattleAction() then
		return 
	end
	
	if not arg_5_0.vars.async_procinfo_list then
		return 
	end
	
	while not table.empty(arg_5_0.vars.async_procinfo_list) do
		table.remove(arg_5_0.vars.async_procinfo_list, 1)()
	end
end

function Battle.procText(arg_6_0, arg_6_1)
	local var_6_0 = {}
	local var_6_1 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		if iter_6_1.target then
			local var_6_2 = true
			
			if iter_6_1.activate or iter_6_1.add then
				if iter_6_1.info and iter_6_1.info.state and iter_6_1.info.state.db then
					var_6_2 = iter_6_1.add and iter_6_1.info.state.db.name_add or iter_6_1.activate and iter_6_1.info.state.db.name_activate
				else
					var_6_2 = false
				end
			end
			
			if iter_6_1.info and iter_6_1.info.state and iter_6_1.info.state.db and iter_6_1.info.state.db.cs_effecttexthide == "y" then
				var_6_2 = false
			end
			
			if iter_6_1.type == "add_tick" then
				local var_6_3 = ""
				
				if iter_6_1.text then
					var_6_3 = iter_6_1.text
				elseif iter_6_1.state then
					var_6_3 = iter_6_1.state:getName()
				end
				
				local var_6_4 = string.format("%s.%d.%s", iter_6_1.type, iter_6_1.target:getUID(), var_6_3)
				
				if not var_6_0[var_6_4] then
					var_6_0[var_6_4] = true
					
					if var_6_2 then
						table.push(var_6_1, {
							type = "text",
							target = iter_6_1.target,
							text = iter_6_1.text
						})
					end
				end
			elseif var_6_2 then
				table.push(var_6_1, iter_6_1)
			end
		end
	end
	
	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		if iter_6_3.type == "text" then
			BattleUI:displayText(iter_6_3.target, iter_6_3.text)
		elseif iter_6_3.type == "add_state" then
			BattleUI:displayState(iter_6_3.info)
		elseif iter_6_3.type == "passive" then
			BattleUI:displayPassive(iter_6_3.info, iter_6_3.text)
		end
	end
end

function Battle.procInfos(arg_7_0)
	local var_7_0 = {}
	
	while not is_playing_story() and arg_7_0:isProcInfoActvate() do
		local var_7_1 = arg_7_0.logic:popInfo() or arg_7_0.viewer:popInfo()
		
		if var_7_1 then
			arg_7_0:procInfo(var_7_1, var_7_0)
		end
		
		if not var_7_1 then
			break
		end
	end
	
	arg_7_0:procText(var_7_0)
end

function Battle.procInfo(arg_8_0, arg_8_1, arg_8_2)
	if DEBUG.BATTLE_LOGIC_COMMAND then
		print("DEBUG Battle.procInfos", arg_8_1.type)
	end
	
	local var_8_0 = arg_8_0:getTargetUNIT(arg_8_1)
	
	if arg_8_0.logic:isInReserveTeam(var_8_0) then
		return 
	end
	
	if arg_8_1.type == "attack" then
		arg_8_0:onAttack(arg_8_1)
	elseif arg_8_1.type == "skill_eff" then
		arg_8_0:onSkillEff(arg_8_1)
	elseif arg_8_1.type == "pvp_penalty" then
		arg_8_0:onPvpPenalty(arg_8_1)
	elseif arg_8_1.type == "pvp_penalty_info" then
		arg_8_0:onPvpPenaltyExtInfo(arg_8_1)
	elseif arg_8_1.type == "clanwar_penalty" then
		if arg_8_0:isAutoPlaying() then
			arg_8_0:toggleAutoBattle()
		end
		
		pause()
		
		if BGI and get_cocos_refid(BGI.ui_layer) then
			BGI.ui_layer:setVisible(false)
		end
		
		Dialog:msgBox(T("war_ui_0055"), {
			handler = function()
				Battle:doEndBattle({
					fatal_stop = true,
					resume = true
				})
			end
		})
	elseif arg_8_1.type == "heal" then
		if arg_8_0.logic:getFinalResult() == "lose" then
			return 
		end
		
		arg_8_0:playStateHealEff(arg_8_1, "heal_hp_01")
		BattleUI:updateUnitGaugeInfo(arg_8_0:getTargetUNIT(arg_8_1))
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
		BattleUI:displayDamage(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1)
	elseif arg_8_1.type == "exp" then
		BattleUI:displayExp(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1)
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
	elseif arg_8_1.type == "dispatch_conditoin" then
		local var_8_1 = arg_8_0:getTargetUNIT(arg_8_1)
		local var_8_2 = arg_8_0.logic:getBattleUID()
		
		ConditionContentsManager:dispatch("battle.cs", {
			unique_id = var_8_2,
			entertype = arg_8_0.logic.type,
			target_unit = var_8_1,
			state_id = arg_8_1.state_id,
			ignore_condition = Battle:checkIgnoreCondition()
		})
	elseif arg_8_1.type == "add_state" then
		if Battle:isRealtimeMode() or Battle:isReplayMode() then
			arg_8_1.state = State:restorePureData(arg_8_1.target, arg_8_1.state_data) or arg_8_1.state
			
			arg_8_0:getTargetUNIT(arg_8_1):swapState(arg_8_1.state)
		end
		
		if Battle.logic:getRunningEventState() == "running" then
			BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
		end
		
		if arg_8_1.state and arg_8_1.state.db.cs_attribute == 9 then
			table.push(arg_8_2, {
				add = true,
				type = "passive",
				target = arg_8_1.target,
				info = arg_8_1
			})
		else
			table.push(arg_8_2, {
				add = true,
				type = "add_state",
				target = arg_8_1.target,
				info = arg_8_1
			})
		end
		
		if arg_8_1.state then
			arg_8_0:onAddState(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1.state)
		end
	elseif arg_8_1.type == "invoke_state_effect" then
		arg_8_0:onInvokeStateEffect(arg_8_1)
	elseif arg_8_1.type == "invoke_passive" then
		if Battle:isRealtimeMode() or Battle:isReplayMode() then
			arg_8_1.state = State:restorePureData(arg_8_1.target, arg_8_1.state_data) or arg_8_1.state
			
			arg_8_0:getTargetUNIT(arg_8_1):swapState(arg_8_1.state)
		end
		
		arg_8_1.text = T(arg_8_1.text)
		
		table.push(arg_8_2, {
			activate = true,
			type = "passive",
			target = arg_8_1.target,
			info = arg_8_1
		})
	elseif arg_8_1.type == "toggle_cs" then
		if arg_8_1.state and arg_8_1.state.db and arg_8_1.state.db.name then
			if arg_8_1.flag then
				table.push(arg_8_2, {
					activate = true,
					type = "passive",
					target = arg_8_1.target,
					info = arg_8_1,
					text = T("sk_toggle_activate", {
						name = arg_8_1.state:getName()
					})
				})
			else
				table.push(arg_8_2, {
					activate = true,
					type = "passive",
					target = arg_8_1.target,
					info = arg_8_1,
					text = T("sk_toggle_deactivate", {
						name = arg_8_1.state:getName()
					})
				})
			end
		end
	elseif arg_8_1.type == "immune" then
		table.push(arg_8_2, {
			type = "text",
			target = arg_8_0:getTargetUNIT(arg_8_1),
			text = T("immune")
		})
	elseif arg_8_1.type == "resist_cool" then
		table.push(arg_8_2, {
			type = "text",
			target = arg_8_0:getTargetUNIT(arg_8_1),
			text = T("resist")
		})
	elseif arg_8_1.type == "resist_time" then
		table.push(arg_8_2, {
			type = "text",
			target = arg_8_0:getTargetUNIT(arg_8_1),
			text = T("resist")
		})
	elseif arg_8_1.type == "resist_state" then
		table.push(arg_8_2, {
			type = "text",
			target = arg_8_0:getTargetUNIT(arg_8_1),
			text = T("resist")
		})
	elseif arg_8_1.type == "damage_solidarity" then
		table.push(arg_8_2, {
			type = "text",
			target = arg_8_0:getTargetUNIT(arg_8_1),
			text = T("damage_solidarity")
		})
	elseif arg_8_1.type == "remove_state" then
		if Battle:isRealtimeMode() or Battle:isReplayMode() then
			arg_8_1.state = State:restorePureData(arg_8_1.target, arg_8_1.state_data) or arg_8_1.state
			
			arg_8_0:getTargetUNIT(arg_8_1):swapState(arg_8_1.state)
		end
		
		if arg_8_1.state then
			arg_8_0:onRemoveState(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1.state)
		end
	elseif arg_8_1.type == "state_finish_call" then
		if arg_8_1.isPreProc then
			arg_8_0:onStateFinishCallback(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1)
		end
	elseif arg_8_1.type == "text" then
		table.push(arg_8_2, {
			type = "text",
			target = arg_8_0:getTargetUNIT(arg_8_1),
			text = T(arg_8_1.text)
		})
	elseif arg_8_1.type == "banner" then
		BattleUI:displayBanner(arg_8_1)
	elseif arg_8_1.type == "smart_bg" then
		BattleField:onCheckFieldState(arg_8_1.check_type, arg_8_1.check_value)
	elseif arg_8_1.type == "bg_effect" then
		BattleUI:displayBGEffect(arg_8_1.eff_info)
	elseif arg_8_1.type == "stun" then
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
	elseif arg_8_1.type == "sp_heal" then
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
		
		local var_8_3 = arg_8_0:getTargetUNIT(arg_8_1)
		
		if var_8_3 and var_8_3:getSPName() == "mp" then
			BattleUI:displayDamage(var_8_3, arg_8_1)
			
			if not arg_8_1.no_effect then
				arg_8_0:playStateEff(arg_8_1, "heal_ap_01")
			end
		end
	elseif arg_8_1.type == "sp_use" then
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
		BattleUI:displayDamage(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1)
	elseif arg_8_1.type == "sp_dec" then
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
	elseif arg_8_1.type == "gauge_update" then
		BattleUI:onUpdateGauge(arg_8_0:getTargetUNIT(arg_8_1))
	elseif arg_8_1.type == "add_turn" then
		arg_8_0:playStateEff(arg_8_1, "stse_addturn")
	elseif arg_8_1.type == "add_skill_cool" then
		BattleUI:updateUnitGaugeInfo(arg_8_0:getTargetUNIT(arg_8_1))
		
		if arg_8_1.inc_turn > 0 then
			table.push(arg_8_2, {
				type = "text",
				target = arg_8_0:getTargetUNIT(arg_8_1),
				text = T("inc_turn", {
					turn = arg_8_1.inc_turn
				}),
				info = arg_8_1
			})
		else
			table.push(arg_8_2, {
				type = "text",
				target = arg_8_0:getTargetUNIT(arg_8_1),
				text = T("dec_turn", {
					turn = 0 - arg_8_1.inc_turn
				}),
				info = arg_8_1
			})
		end
	elseif arg_8_1.type == "remove_buffs" then
		arg_8_0:playStateEff(arg_8_1, "stse_del_buff")
	elseif arg_8_1.type == "remove_debuffs" then
		arg_8_0:playStateEff(arg_8_1, "stse_del_debuff")
	elseif arg_8_1.type == "add_tick" then
		if arg_8_0.logic:getTurnOwner() ~= arg_8_0:getTargetUNIT(arg_8_1) then
			UIBattleAttackOrder:update(arg_8_0:getTargetUNIT(arg_8_1), arg_8_1.tick)
		end
		
		if to_n(arg_8_1.tick) > 0 then
			table.push(arg_8_2, {
				type = "add_tick",
				target = arg_8_0:getTargetUNIT(arg_8_1),
				text = T("sk_actionbarup")
			})
		elseif to_n(arg_8_1.tick) < 0 then
			table.push(arg_8_2, {
				type = "add_tick",
				target = arg_8_0:getTargetUNIT(arg_8_1),
				text = T("sk_actionbardown")
			})
		end
	elseif arg_8_1.type == "move_stage" then
		arg_8_0:warpToRoad(arg_8_1.value, arg_8_1.road_event_id)
	elseif arg_8_1.type == "drop_reward" then
		arg_8_0:onDropReward(arg_8_1)
	elseif arg_8_1.type == "crystal_drop" then
		local var_8_4 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
	elseif arg_8_1.type == "box_open" then
		local var_8_5 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
		local var_8_6 = BattleField:getRoadEventFieldModel(var_8_5)
		
		if get_cocos_refid(var_8_6) then
			UIAction:Add(DMOTION("box_open"), var_8_6, "field.object")
		end
		
		arg_8_0:setNextProcInfoDelay(500)
	elseif arg_8_1.type == "mimic_transform" then
		UIAction:Add(SEQ(SHOW(false)), arg_8_1.object.model, "field.object")
	elseif arg_8_1.type == "gain_soul_by_field" then
		local var_8_7 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
		local var_8_8 = BattleField:getRoadEventFieldModel(var_8_7)
		
		BattleUI:gainSoulEffectByObject(var_8_8, true)
	elseif arg_8_1.type == "gain_soul_piece_by_field" then
		local var_8_9 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
		local var_8_10 = BattleField:getRoadEventFieldModel(var_8_9)
		
		BattleUI:gainSoulEffectByObject(var_8_10)
	elseif arg_8_1.type == "gain_soul_by_battle" then
		if not arg_8_0.viewer:isSpectator() and arg_8_1.unit and arg_8_1.soul_gain then
			local var_8_11 = arg_8_0.viewer:getAttackInfo(arg_8_1.unit)
			
			if var_8_11 and var_8_11.d_units then
				BattleUI:gainSoulEffectByAttacker(arg_8_1.unit, var_8_11.d_units, arg_8_1.soul_gain)
			end
		end
	elseif arg_8_1.type == "sp_use" then
	elseif arg_8_1.type == "appear" then
		arg_8_0:spawn(arg_8_1.dead_unit, arg_8_1.dead_index, arg_8_1.unit, arg_8_1.type)
		BattleUI:updateUnitFaces()
	elseif arg_8_1.type == "appear_by_tag" then
		arg_8_0:spawn(arg_8_1.dead_unit, arg_8_1.dead_index, arg_8_1.unit, arg_8_1.type)
		BattleUI:updateUnitFaces()
	elseif arg_8_1.type == "disappear_by_tag" then
		arg_8_0:tagEffect(arg_8_1.unit, arg_8_1.unit.model)
		arg_8_0:testAutoSpecifyTarget(arg_8_1.unit)
		BattleUI:hideSkillButtons()
	elseif arg_8_1.type == "dead" then
		Log.i("BATTLE", "dead", systick())
		arg_8_0:onDeadInfo(arg_8_1)
	elseif arg_8_1.type == "resurrect" then
		arg_8_0:spawn(arg_8_1.dead_unit, arg_8_1.dead_index, arg_8_1.unit, arg_8_1.type)
		BattleUI:updateUnitFaces()
		
		local var_8_12 = "battle.clear_unit" .. arg_8_1.dead_unit:getUID()
		
		if BattleAction:Find(var_8_12) then
			BattleAction:Remove(var_8_12)
			BattleUtil:clearUnits({
				arg_8_1.dead_unit
			})
		end
		
		BattleUI:register(arg_8_1.dead_unit)
		arg_8_0:updateModelExtraInfo()
		
		return 
	elseif arg_8_1.type == "transform" then
		local var_8_13 = arg_8_1.target
		
		var_8_13.model:resetTimeline()
		var_8_13.model:cleanupReferencedObject()
		var_8_13.model:removePartsObject("", "effect", true)
		BattleUtil:updateModel(var_8_13)
		
		if table.empty(var_8_13:getTransformVars()) then
			if var_8_13.db.model_opt then
				var_8_13.model:loadOption("model/" .. var_8_13.db.model_opt)
			end
			
			if var_8_13.db.skin then
				var_8_13.model:setSkin(var_8_13.db.skin)
			end
		end
		
		var_8_13.model:setAnimation(0, "idle", true)
		UIBattleAttackOrder:activeUnitInfo(var_8_13)
		UIBattleAttackOrder:updateUnitInfo(var_8_13)
	elseif arg_8_1.type == "swap_team" then
		Battle:swapTeam(arg_8_1)
	elseif arg_8_1.type == "antiskilldamage" then
		if arg_8_1.target and arg_8_1.target.ui_vars and arg_8_1.target.ui_vars.gauge then
			arg_8_1.target.ui_vars.gauge:updateState(true, true)
		end
	elseif arg_8_1.type == "summon" then
		arg_8_0:spawn(arg_8_1.dead_unit, arg_8_1.dead_index, arg_8_1.unit, arg_8_1.type)
		BattleUI:updateUnitFaces()
	elseif arg_8_1.type == "replace" then
		arg_8_0:onReplaceUnit(arg_8_1)
	elseif arg_8_1.type == "skip_turn" then
		arg_8_0:onSkipTurn(arg_8_1)
	elseif arg_8_1.type == "field_npc" then
		local var_8_14 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
		
		arg_8_0:onFieldNPC(var_8_14, arg_8_1.counting)
	elseif arg_8_1.type == "switch" or arg_8_1.type == "switch_mel" then
		local var_8_15 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
		local var_8_16 = BattleField:getRoadEventFieldModel(var_8_15)
		
		if get_cocos_refid(var_8_16) then
			local var_8_17 = "active"
			local var_8_18 = "finish"
			local var_8_19 = NONE()
			
			if arg_8_1.type == "switch_mel" then
				var_8_17 = "fire_b"
				var_8_18 = "fire_b"
				var_8_19 = CALL(function()
					var_8_16:activeAction(var_8_16:getParent(), true)
				end)
			end
			
			SoundEngine:play("event:/eff/obj_maze_switch")
			UIAction:Add(SEQ(var_8_19, DMOTION(var_8_17), MOTION(var_8_18, true)), var_8_16, "field.object")
		end
	elseif arg_8_1.type == "dec_morale" then
		arg_8_0:onUpdateMorale(arg_8_1.value, arg_8_1.dec_value)
	elseif arg_8_1.type == "obstacle" then
		arg_8_0:onFieldObstacle(arg_8_1.road_event_id)
	elseif arg_8_1.type == "field_npc_shop" then
		arg_8_0:onFieldNPCShop(arg_8_1)
	elseif arg_8_1.type == "warp_portal" then
		Dialog:msgBox(T(arg_8_1.value.pop_desc or "use_warp_portal"), {
			yesno = true,
			handler = function()
				if arg_8_1.target_road_id then
					arg_8_0:warpToRoad(arg_8_1.target_road_id)
				end
			end,
			title = T(arg_8_1.value.pop_title or "use_warp_portal_title"),
			cancel_handler = function()
				local var_12_0 = arg_8_0.logic:getRoadEventObject(arg_8_1.road_event_id)
				local var_12_1 = BattleField:getRoadEventFieldModel(var_12_0)
				
				BattleUI:displayRoadEventObjectGuideUI(var_12_0, var_12_1)
			end
		})
	elseif arg_8_1.type == "draw_notify" then
		BattleTopBar:updateOptionalDraw(arg_8_1.stage_count)
	elseif arg_8_1.type == "expedition_update" then
		local var_8_20 = arg_8_0:getTargetUNIT(arg_8_1)
		
		BattleUI:updateUnitGaugeInfo(var_8_20)
		BattleUI:onUpdateGauge(var_8_20)
		
		if var_8_20 and var_8_20.ui_vars.gauge and var_8_20.ui_vars.gauge:isValid() then
			var_8_20.ui_vars.gauge:set(true)
		end
		
		BattleUI:onScoreUpdate()
	elseif arg_8_1.type == "content_enhance" then
		local var_8_21 = arg_8_0:getTargetUNIT(arg_8_1)
		
		if var_8_21 and var_8_21.ui_vars.gauge and var_8_21.ui_vars.gauge:isValid() then
			var_8_21.ui_vars.gauge:set(true)
		end
	elseif arg_8_1.type == "set_ignore_hit_action" then
		arg_8_0:getTargetUNIT(arg_8_1):setIgnoreHitAction(arg_8_1.flag)
	elseif arg_8_1.type == "@change_bg" then
		arg_8_0:changeStageBG(arg_8_1.value)
	elseif arg_8_1.type == "@use_potion" then
		BattleTopBar:updatePotion()
	elseif arg_8_1.type == "@camping_topic" then
		arg_8_0:onCampingTopic(arg_8_1.result_info)
	elseif arg_8_1.type == "@enter_road" then
		arg_8_0:onEnterRoad(arg_8_1.is_enter_start)
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.real", {
			type = arg_8_1.type
		})
	elseif arg_8_1.type == "@enter_road_sector" then
		arg_8_0:onEnterRoadSector(arg_8_1.road_sector_id)
	elseif arg_8_1.type == "@insight_road_sector" then
		arg_8_0:onInSightRoadSector(arg_8_1.road_sector_id)
	elseif arg_8_1.type == "@require_level_flag" then
		arg_8_0:onRequireLevelFlag(arg_8_1.road_event_id, arg_8_1.flag)
	elseif arg_8_1.type == "@require_mission_state" then
		arg_8_0:onRequireMissionState(arg_8_1.road_event_id)
	elseif arg_8_1.type == "@set_level_flag" then
		arg_8_0:onSetLevelFlag(arg_8_1.road_event_id, arg_8_1.flag_on, arg_8_1.msg_flag_on)
	elseif arg_8_1.type == "@set_group_flag" then
		arg_8_0:onSetGroupFlag(arg_8_1.road_sector_id, arg_8_1.msg)
	elseif arg_8_1.type == "@prepare_road_event" then
		arg_8_0:onPrepareRoadEvent(arg_8_1.road_event_id)
	elseif arg_8_1.type == "@encounter_road_event" then
		arg_8_0:onEncounterRoadEvent(arg_8_1.road_event_id, arg_8_1.event_param)
	elseif arg_8_1.type == "@encounter_enemy" then
		arg_8_0:onEncounterEnemy(arg_8_1.road_event_id, arg_8_1)
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.real", {
			type = arg_8_1.type
		})
	elseif arg_8_1.type == "@destroyed_road_event" then
		arg_8_0:onDestroyedRoadEvent(arg_8_1.road_event_id)
	elseif arg_8_1.type == "@complete_road_event" then
		arg_8_0:onCompleteRoadEvent(arg_8_1.road_event_id)
	elseif arg_8_1.type == "@pet_fire" then
	elseif arg_8_1.type == "@fire_road_event" then
		arg_8_0:onFireRoadEvent(arg_8_1.road_event_id, arg_8_1.is_pet_fired)
	elseif arg_8_1.type == "@start_turn" then
		BattleUI:onUpdateGauge(arg_8_1.unit)
		arg_8_0:onPlayAttackOrder(arg_8_1.unit)
		arg_8_0:async_call(function()
			arg_8_0:onStartTurn(arg_8_1.unit, arg_8_1.rest_tick)
		end)
	elseif arg_8_1.type == "@ready_attack" then
		if not arg_8_1.unit:getProvoker() then
			arg_8_0:async_call(function()
				arg_8_0:onReadyAttack(arg_8_1.unit, arg_8_1.skip_move_turn)
			end)
		end
	elseif arg_8_1.type == "@end_turn" then
		arg_8_0:onEndTurn(arg_8_1.unit)
	elseif arg_8_1.type == "@delay_skill" then
		BattleAction:Append(SEQ(DELAY(arg_8_1.delay)), arg_8_0, "battle.proc_action")
	elseif arg_8_1.type == "@skill_start" then
		arg_8_0:onSkillStart(arg_8_1)
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.real", {
			type = arg_8_1.type,
			attacker = arg_8_1.unit
		})
	elseif arg_8_1.type == "@skill_stop" then
		arg_8_0:onSkillStop(arg_8_1.unit, arg_8_1.skill_info)
		arg_8_0:setNextProcInfoDelay(700)
	elseif arg_8_1.type == "@summon_skill" then
		arg_8_0:onSummonSkill(arg_8_1.summon)
	elseif arg_8_1.type == "@end_hit" then
	elseif arg_8_1.type == "@end_road_event" then
		arg_8_0:onEndRoadEvent(arg_8_1.road_event_id)
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.real", {
			type = arg_8_1.type
		})
	elseif arg_8_1.type == "@end_battle" then
		arg_8_0:onEndBattle()
		LuaEventDispatcher:dispatchEvent("proc.info.log", "battle.real", {
			type = arg_8_1.type,
			proc_counter = Battle.logic.battle_info.proc_info.counter
		})
	elseif arg_8_1.type == "@burning_phase_action" then
		arg_8_0:onBurningPhase(arg_8_1)
	elseif arg_8_1.type == "@crevice_return" then
		arg_8_0:onCreviceReturn(arg_8_1)
	elseif arg_8_1.type == "sort_order" then
		BattleUI:onUpdateStateOrder()
	elseif arg_8_1.type == "update_viewer" then
		Battle.viewer:updateViewState(arg_8_1, arg_8_1.immdeiate)
	end
end

function Battle.onAttack(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0:getTargetUNIT(arg_15_1)
	
	arg_15_0:playAttacked(arg_15_1)
	BattleUI:onUpdateGauge(var_15_0)
	BattleUI:displayDamage(var_15_0, arg_15_1)
	
	if arg_15_1.attack_type == "pvp_penalty" then
		EffectManager:Play({
			extractNodes = true,
			z = 1,
			fn = "eff_pvp_damage.cfx",
			y = 0,
			x = 0,
			layer = var_15_0.model,
			action = BattleAction
		})
	end
end

function Battle.onPvpPenalty(arg_16_0, arg_16_1)
	EffectManager:Play({
		fn = "eff_pvp_damage_back.scsp",
		layer = BGI.main.layer
	}):setLocalZOrder(-1)
	BattleUI:showPVPDamageBanner()
	BattleAction:Add(SEQ(ANI_CAM("eff_pvp_damage_cm"), DELAY(700)), BGI.game_layer, "battle")
end

function Battle.onPvpPenaltyExtInfo(arg_17_0, arg_17_1)
	BattleTopBar:updatePVPPenaltyInfo(arg_17_1)
end

function Battle.onRequireMissionState(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.logic:getRoadEventObject(arg_18_1)
	
	if not var_18_0 then
		return 
	end
	
	arg_18_0:syncRoadEventMissionStates(var_18_0)
end

function Battle.onRequireLevelFlag(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.logic:getRoadEventObject(arg_19_1)
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = var_19_0.flag_info
	
	if arg_19_2 then
		for iter_19_0 = 1, 3 do
			if arg_19_2 == var_19_1["flag_lock_" .. iter_19_0] then
				local var_19_2 = var_19_1["msg_flag_lock_" .. iter_19_0]
				
				if var_19_2 then
					balloon_message_with_sound(var_19_2)
				end
			end
		end
		
		if get_cocos_refid(var_19_0.model) then
			var_19_0.model:lockAction()
		end
	end
end

function Battle.onSetLevelFlag(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0.logic:getRoadEventObject(arg_20_1)
	
	if arg_20_3 then
		add_callback_to_story(function()
			flash_message(T(arg_20_3))
		end)
	end
	
	BattleMapManager:unlockByFlag(arg_20_2)
	
	if string.starts(arg_20_2, "key") then
		local var_20_1 = arg_20_0.logic:getOption(arg_20_2)
		
		if var_20_1 then
			Dialog:ShowRareDrop({
				code = "",
				img = var_20_1.img,
				custom = var_20_1.name,
				category = var_20_1.category
			})
		end
	end
	
	BattleMapManager:updateIcon(var_20_0)
end

function Battle.onSetGroupFlag(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_2 then
		add_callback_to_story(function()
			flash_message(T(arg_22_2))
		end)
	end
end

function Battle.onCampingTopic(arg_24_0, arg_24_1)
	CampingSiteNew:topicResult(arg_24_1)
end

function Battle.hideRoadPopup(arg_25_0)
	local var_25_0 = Dialog:findMsgBox("alert.potion")
	
	if get_cocos_refid(var_25_0) then
		Dialog:msgBoxUIHandler(var_25_0, "btn_cancel")
	end
	
	local var_25_1 = Dialog:findMsgBox("alert.camping")
	
	if get_cocos_refid(var_25_1) then
		Dialog:msgBoxUIHandler(var_25_1, "btn_cancel")
	end
end

function Battle.onEnterRoad(arg_26_0, arg_26_1)
	if Battle and Battle.vars then
		Battle.vars.map_finished = nil
	end
	
	arg_26_0:hideRoadPopup()
	BattleUI:updateUnitFaces()
	
	local function var_26_0()
		local var_27_0
		local var_27_1 = Battle.logic:getCurrentRoadInfo()
		
		if var_27_1.is_cross then
			if var_27_1.road_reverse then
				var_27_0 = {
					dir = -1,
					is_cross = true,
					pos = DESIGN_WIDTH - BATTLE_LAYOUT.XDIST_FROM_SIDE
				}
			else
				var_27_0 = {
					dir = 1,
					is_cross = true,
					pos = BATTLE_LAYOUT.XDIST_FROM_SIDE
				}
			end
		else
			local var_27_2 = Battle.logic:getCurrentRoadSectorId()
			local var_27_3 = Battle.logic:getRoadSectorObject(var_27_2)
			
			if var_27_3 then
				local var_27_4 = BattleField:getRoadSectorFieldInfo(var_27_3)
				local var_27_5 = var_27_1.road_reverse and -1 or 1
				
				var_27_0 = {
					pos = var_27_4.position - BATTLE_LAYOUT.TEAM_WIDTH * var_27_5,
					dir = var_27_5
				}
			elseif var_27_1.road_reverse then
				local var_27_6 = BattleField:getRoadFieldInfo(var_27_1.road_id)
				
				var_27_0 = {
					enter_effect = true,
					dir = -1,
					pos = var_27_6.width - DESIGN_WIDTH * 0.2 + BATTLE_LAYOUT.XDIST_FROM_SIDE
				}
			else
				var_27_0 = {
					enter_effect = true,
					dir = 1,
					pos = 0
				}
			end
		end
		
		return var_27_0
	end
	
	BattleLayout:removeTeamLayout(ENEMY)
	UIBattleGuideArrow:hide()
	
	local var_26_1 = arg_26_0.logic:getCurrentRoadInfo()
	local var_26_2 = arg_26_0.logic:getSelectMapData() or {}
	local var_26_3
	local var_26_4
	
	if arg_26_0.vars.restore_info then
		var_26_3 = arg_26_0.vars.restore_info.road_field_info
		var_26_4 = arg_26_0.vars.restore_info.current_sector_field_info
	end
	
	local var_26_5 = BattleField:loadRoadTheme(arg_26_0.logic, var_26_1, var_26_2, {
		restore_road_field_info = var_26_3,
		restore_current_sector_info = var_26_4
	})
	
	arg_26_0:changeAmbientColor(var_26_5, var_26_2)
	arg_26_0:changeBGM(var_26_5, var_26_2, arg_26_0.vars.override_bgm)
	arg_26_0:syncRoadMissionStates(var_26_1)
	
	local var_26_6 = var_26_0()
	
	if var_26_6.pos then
		BattleLayout:setDirection(var_26_6.dir)
		BattleLayout:setFieldPosition(var_26_6.pos)
	end
	
	if arg_26_1 then
		BattleStory:playEnterLevelStory(arg_26_0.logic.map.enter)
	end
	
	BattleStory:playEnterRoadStory(arg_26_0.logic.map.enter, var_26_1.road_id)
	attach_story_finished_callback(function()
		if arg_26_1 then
			if BattleRepeat:isPlayingRepeatPlay() and not Battle.logic:isPVP() and not Battle.logic:isTutorial() and PetUtil:isRepeatBattleEnableMap(Battle.logic.map.enter) and Battle:isAutoPlayableStage() then
				BattleTopBar:open_RepeateControl()
			end
			
			BattleUtil:playMapTitle(arg_26_0.logic.map.enter, arg_26_0.logic:getStageMainType())
			print("BattleUtil:playMapTitle( self.logic.map.enter, self.logic:getStageMainType() )")
		end
		
		arg_26_0:DoEnter(var_26_6)
		BattleTopBar:updateCampingButton()
	end)
end

function Battle.onEnterRoadSector(arg_29_0, arg_29_1)
	BattleMapManager:onEnterRoadSector(arg_29_1)
	
	local var_29_0 = arg_29_0.logic:getRoadSectorObject(arg_29_1)
	
	for iter_29_0, iter_29_1 in pairs(var_29_0.event_list) do
		BattleMapManager:updateIcon(iter_29_1)
	end
end

function Battle.onInSightRoadSector(arg_30_0, arg_30_1)
	BattleMapManager:onInSightRoadSector(arg_30_1)
end

function Battle.onStartTurn(arg_31_0, arg_31_1, arg_31_2)
	Log.i("onStartTurn", systick())
	BattleUtil:collectClearUnits()
	BattleTopBar:setVisible(true)
	BattleTopBar:updateRTAPenalyInfo()
	BattleUI:resetVars()
	BattleUI:setIndividualShow(nil)
	BattleUI:setVisible(true)
	
	arg_31_0.vars.mode = "StartTurn"
	
	TutorialGuide:onStartTurn(arg_31_0.logic, arg_31_1)
end

function Battle.onPlayAttackOrder(arg_32_0, arg_32_1)
	if not arg_32_1 then
		return 
	end
	
	local var_32_0, var_32_1 = arg_32_1:getRestTimeAndTick()
	
	BattleUI:playAttackOrder(arg_32_1, var_32_1)
end

function Battle.onReadyAttack(arg_33_0, arg_33_1, arg_33_2)
	Log.i("onReadyAttack", systick())
	
	local var_33_0 = arg_33_0.logic:getTurnOwner()
	
	if not var_33_0 then
		Log.e("invalid turn owner")
		
		return 
	end
	
	arg_33_0.vars.mode = "ReadyAttack"
	arg_33_0.vars.arrange_skill = {}
	
	BattleAction:Remove(var_33_0.model)
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.logic.units) do
		BattleUI:initTextDisplayCount(iter_33_1)
	end
	
	BattleUI:playFaceFrame(true, var_33_0)
	BattleUI:updateTimeline()
	BattleUI:showGauge()
	
	if BattleTopBar:isUseTurnInfo() then
		BattleTopBar:setTurnInfo(arg_33_0.logic:getStageCounter())
	end
	
	Battle.viewer:sendReady()
	
	arg_33_0.vars.pointless_sync_tm = nil
	
	local var_33_1 = DMOTION("b_idle_ready", false)
	local var_33_2
	local var_33_3 = NONE()
	local var_33_4
	local var_33_5 = MOTION("b_idle", true)
	
	if arg_33_0.logic:isRealtimeMode() or arg_33_0:isReplayMode() then
		ur.Model:setNoSoundAniFlag("b_idle_ready", arg_33_0:isAutoPlaying())
	else
		ur.Model:setNoSoundAniFlag("b_idle_ready", arg_33_0:isAutoPlaying() or var_33_0.inst.ally == ENEMY)
	end
	
	BattleAction:Add(SEQ(var_33_1, var_33_5), var_33_0.model, "battle.ready")
	BattleAction:Add(SEQ(COND_LOOP(SEQ(DELAY(1)), function()
		if not arg_33_0.logic then
			return true
		end
		
		if arg_33_0.logic:isRealtimeMode() then
			return true
		end
		
		if not arg_33_0.logic._paused.banner then
			return true
		end
	end), CALL(function()
		if not arg_33_0.logic then
			return 
		end
		
		local var_35_0 = 200
		local var_35_1 = 0
		local var_35_2 = CameraFocus(ScreenCenterPivot(), var_35_1)
		
		var_35_2:setTime(var_35_0)
		CameraManager:setFocusObject(var_35_2)
		
		local var_35_3 = CameraZoom(CAM_READY_SCALE)
		
		var_35_3:setTime(var_35_0)
		CameraManager:setZoomObject(var_35_3)
		
		local function var_35_4()
			arg_33_0:showFocusRing(var_33_0)
			
			if arg_33_0:playAutoSelectTarget(var_33_0) then
				BattleUI:hideSkillButtons()
			else
				BattleUI:showSkillButtons(var_33_0)
				arg_33_0:onTouchSkill(1)
			end
			
			UIBattleActWait:hideActWaitPopup()
		end
		
		if arg_33_0:isNetLocalTest() then
			var_35_4()
		elseif arg_33_0.logic:isRealtimeMode() then
		elseif Battle:isReplayMode() then
			var_35_4()
			
			if not arg_33_2 then
				Battle.viewer.player:moveTurn(1, true)
				
				local var_35_5 = BattleUI:getReplayController()
				
				if var_35_5 then
					var_35_5:updateUI()
				end
			end
		else
			var_35_4()
		end
	end)), var_33_0.model, "battle.ready")
	BattleAction:Add(var_33_3, var_33_0.model)
	arg_33_0.logic:verifyTurn()
end

function Battle.onEndTurn(arg_37_0, arg_37_1)
	arg_37_0.vars.call_end_turn = nil
	
	print("END TURN", nil)
	Log.i("BATTLE", "onEndTurn", systick())
	report_convic()
	BattleUI:resetVars()
	CameraManager:playCamera("default")
	
	local var_37_0 = arg_37_1
	local var_37_1 = arg_37_0.viewer:getAttackInfo(var_37_0)
	local var_37_2 = arg_37_0:getIdleAni(var_37_0)
	
	if var_37_1 and var_37_1.cur_hit and var_37_1.tot_hit and var_37_1.cur_hit < var_37_1.tot_hit then
		balloon_message(string.format(T("skill_hit_enough"), var_37_1.skill_id, var_37_1.cur_hit, var_37_1.tot_hit))
	end
	
	local function var_37_3(arg_38_0)
		if get_cocos_refid(arg_38_0.model) then
			arg_38_0.model:setPartsVisibility("skill", true, "effect")
			
			local var_38_0 = arg_37_0:getIdleAni(arg_38_0)
			
			if var_37_2 ~= var_38_0 then
				arg_38_0.model:setAnimation(0, var_38_0, true)
			end
		end
	end
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.logic.friends) do
		var_37_3(iter_37_1)
	end
	
	for iter_37_2, iter_37_3 in pairs(arg_37_0.logic.enemies) do
		var_37_3(iter_37_3)
	end
	
	BattleUI:onUpdateGauge(var_37_0)
	BattleUI:playFaceFrame(false, var_37_0)
	
	var_37_0.inst.add_skill = {}
	arg_37_0.vars.pause = nil
	
	BattleUI:resetCombo()
	BattleTopBar:setVisible(true)
	
	if BattleTopBar:isUseTurnInfo() then
		BattleTopBar:setTurnInfo(arg_37_0.logic:getStageCounter())
	end
	
	BattleUI:setVisible(true)
	BattleUI:setIndividualShow(nil)
	BattleUI:stopTopSoulEffect()
	
	if not arg_37_0.logic:getSummonSkillUseInfo(FRIEND).useable and arg_37_0:isSummonReservationOn() then
		arg_37_0:setSummonReservation(false)
		BattleUI:setVisibleSummonReservation(false)
	end
	
	if not arg_37_0:applyTimeScaleUp() then
		arg_37_0:resetBattleTimeScale(SAVE:get("app.battle_time_scale"))
	end
	
	ur.Model:setNoSoundAniFlag("b_idle_ready", false)
end

function Battle.onDeadInfo(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0:getTargetUNIT(arg_39_1)
	local var_39_1 = var_39_0.model
	local var_39_2 = {}
	
	for iter_39_0, iter_39_1 in pairs(arg_39_1.remain_units) do
		local var_39_3 = arg_39_0.logic:getUnit(iter_39_1)
		
		table.insert(var_39_2, var_39_3)
	end
	
	if var_39_0.inst.ally == ENEMY then
		local var_39_4 = arg_39_0.logic:getBattleUID()
		
		ConditionContentsManager:dispatch("battle.killed", {
			unique_id = var_39_4,
			entertype = arg_39_0.logic.type,
			targetid = var_39_0.db.code,
			enter_id = arg_39_0.logic.map.enter,
			ignore_condition = Battle:checkIgnoreCondition()
		})
	end
	
	arg_39_0:testAutoSpecifyTarget(var_39_0)
	
	local var_39_5 = var_39_0:isResurrectionReserved()
	
	if not var_39_5 then
		local var_39_6 = arg_39_0.logic:getRunningRoadEventObject()
		local var_39_7, var_39_8 = BattleStory:getStoryData(var_39_6.story_id)
		
		if BattleStory:isPlayableStory(arg_39_0.logic.map.enter, var_39_8) then
			var_39_5 = arg_39_0.logic:getAliveCount(var_39_0.inst.ally) == 0
		else
			var_39_5 = arg_39_0.logic:isLastRoadEvent() and arg_39_0.logic:getAliveCount(var_39_0.inst.ally) == 0
		end
	end
	
	local var_39_9 = CALL(function()
		if get_cocos_refid(var_39_1) then
			if var_39_0:isDead() then
				var_39_1:setVisible(false)
				
				if var_39_1.body and var_39_1.body.stop then
					var_39_1.body:stop()
				end
				
				var_39_1:setScale(var_39_0.db.scale)
			else
				var_39_1:setColor(arg_39_0.vars.ambient_color)
				var_39_1:setTimeScale(1)
			end
		end
		
		BattleAction:Add(SEQ(DELAY(1000), CALL(function()
			if get_cocos_refid(var_39_1) and var_39_0:isDead() then
				BattleUtil:removeModel(var_39_0)
			end
		end)), var_39_1)
	end)
	local var_39_10 = arg_39_0:deadEffect(var_39_0, var_39_0.model, var_39_5, var_39_9)
	local var_39_11 = "battle.clear_unit" .. var_39_0:getUID()
	
	if get_cocos_refid(var_39_1) then
		BattleAction:Add(SEQ(CALL(function()
			if var_39_0.ui_vars then
				if var_39_0.ui_vars.gauge then
					var_39_0.ui_vars.gauge:setVisible(false)
				end
				
				if var_39_0.ui_vars.condition_bar then
					var_39_0.ui_vars.condition_bar:setVisible(false)
				end
			end
		end), DELAY(var_39_10 or 0), CALL(function()
			BattleUtil:clearUnits({
				var_39_0
			})
		end)), var_39_1, var_39_11)
	end
	
	BattleUI:updateUnitFaces()
	
	if BattleTopBar:isUseTurnInfo() then
		BattleTopBar:setTurnInfo(arg_39_0.logic:getStageCounter())
	end
	
	arg_39_0:updateModelExtraInfo()
end

function Battle.onPrepareRoadEvent(arg_44_0, arg_44_1)
	local var_44_0 = assert(arg_44_0.logic:getRoadEventObject(arg_44_1))
	local var_44_1 = var_44_0.type
	
	if var_44_0.group_expired and arg_44_0.logic:isCompletedRoadEvent(arg_44_1) then
		return 
	end
	
	if string.starts(var_44_1, "battle") then
		for iter_44_0, iter_44_1 in pairs(var_44_0.mobs or {}) do
			local var_44_2, var_44_3 = DB("character", iter_44_1.code, {
				"model_id",
				"atlas"
			})
			
			if var_44_2 then
				local var_44_4 = "model/" .. var_44_2 .. ".scsp"
				local var_44_5 = "model/" .. (var_44_3 or var_44_2) .. ".atlas"
				
				preload(var_44_4, var_44_5)
			end
		end
	elseif var_44_1 == "empty" or var_44_1 == "start" then
		local var_44_6 = arg_44_0.logic:getRoadEventObject(arg_44_1)
		
		BattleMapManager:updateIcon(var_44_6)
	elseif arg_44_0.logic:isObjectType(var_44_1) then
		arg_44_0:layoutRoadEventModel(arg_44_1)
	end
end

function Battle.onEncounterRoadEvent(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0.logic:getRoadEventObject(arg_45_1)
	
	BattleStory:playRoadEventStory(arg_45_0.logic.map.enter, var_45_0, "before")
	
	local function var_45_1()
		TutorialGuide:onEncounterRoadEvent(arg_45_0.logic, var_45_0)
	end
	
	attach_story_finished_callback(var_45_1)
end

function Battle.updateModelExtraInfo(arg_47_0)
	local var_47_0 = {}
	local var_47_1 = {}
	
	for iter_47_0, iter_47_1 in pairs(arg_47_0.logic.units) do
		local var_47_2 = not iter_47_1:isDead()
		
		if iter_47_1:getAlly() == FRIEND then
			var_47_0[iter_47_1.inst.code] = var_47_2
		else
			var_47_1[iter_47_1.inst.code] = var_47_2
		end
	end
	
	for iter_47_2, iter_47_3 in pairs(arg_47_0.logic.units) do
		local var_47_3 = iter_47_3.model
		
		if get_cocos_refid(var_47_3) then
			if iter_47_3:getAlly() == FRIEND then
				var_47_3:setExtraData({
					friends = var_47_0,
					enemies = var_47_1,
					unit = iter_47_3
				})
			else
				var_47_3:setExtraData({
					friends = var_47_1,
					enemies = var_47_0,
					unit = iter_47_3
				})
			end
		end
	end
end

function Battle.onEncounterEnemy(arg_48_0, arg_48_1, arg_48_2)
	arg_48_2 = arg_48_2 or {}
	
	arg_48_0:hideRoadPopup()
	BattleLayout:setPause(true)
	BattleLayout:setDirection(arg_48_0:isReverseDirection() and -1 or 1)
	BattleLayout:updateModelPose(true)
	BattleField:setCheckableEvent(false)
	BattleUIAction:Remove("Battle.Drop.AutoCollect")
	BattleDropManager:collectDropItem(true)
	arg_48_0:layoutEnemies(arg_48_1):setVisible(true)
	BattleAction:Remove("MoveButton.Press")
	arg_48_0:onClickNextButton(false)
	arg_48_0:setStageMode(STAGE_MODE.EVENT)
	
	arg_48_0.vars.mode = "Encount"
	
	arg_48_0:updateModelExtraInfo()
	
	local var_48_0
	local var_48_1
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.logic.enemies) do
		if iter_48_1:isBoss() then
			var_48_1 = true
			
			break
		end
		
		if iter_48_1:isElite() then
			var_48_0 = true
		end
	end
	
	local var_48_2 = 0
	local var_48_3 = 0
	
	for iter_48_2, iter_48_3 in pairs(arg_48_0.logic.enemies) do
		if iter_48_3.inst.code ~= "cleardummy" then
			if iter_48_3:isEmptyHP() then
				var_48_3 = var_48_3 + 1
			end
			
			var_48_2 = var_48_2 + 1
		end
	end
	
	if var_48_3 > 0 and var_48_2 == var_48_3 then
		query("convic", {
			reason = "empty_hp",
			convic = 0
		})
	end
	
	local var_48_4 = (arg_48_0.vars.moveButton or {}).spr
	
	if var_48_4 then
		var_48_4:setVisible(false)
		var_48_4:getParent():removeChild(var_48_4)
		
		arg_48_0.vars.moveButton = nil
	end
	
	arg_48_0.vars.finished = nil
	
	local function var_48_5(arg_49_0)
		BattleLayout:setWalking(false)
		
		for iter_49_0 = 1, #arg_49_0.logic.friends do
			local var_49_0 = arg_49_0.logic.friends[iter_49_0]
			local var_49_1 = var_49_0.model
			
			if not arg_49_0.logic.friends[iter_49_0]:isDead() then
				local var_49_2 = var_49_0.x
				local var_49_3 = var_49_0.y
				local var_49_4, var_49_5 = var_49_1:getPosition()
				
				if arg_49_0.logic:isSkillPreview() and var_49_0.db.code == "m9201" then
					BattleAction:Add(SEQ(OPACITY(400, 0, 1)), var_49_0.model, "battle.enter")
				end
			end
		end
	end
	
	local function var_48_6()
		if arg_48_0.logic.pet then
			if BattleAction:Find("battle.pet") then
				BattleAction:Remove("battle.pet")
			end
			
			local var_50_0 = arg_48_0.logic.pet
			local var_50_1 = arg_48_0.logic.pet.model
			
			if get_cocos_refid(var_50_1) then
				BattleAction:Add(SEQ(CALL(var_50_0.setMoverPause, var_50_0, true), DMOTION("fade_out"), CALL(EffectManager.Play, EffectManager, {
					fn = "ui_pet_pop_eff.cfx",
					layer = var_50_1:getBoneNode("target")
				})), var_50_1, "battle.pet")
			end
		end
	end
	
	local function var_48_7(arg_51_0, arg_51_1)
		for iter_51_0 = 1, #arg_51_0.logic.friends do
			local var_51_0 = arg_51_0.logic.friends[iter_51_0]
			local var_51_1 = var_51_0.model
			
			if not arg_51_0.logic.friends[iter_51_0]:isDead() then
				local var_51_2 = DB("character", var_51_0.inst.code, "size") or 1
				local var_51_3 = var_51_2 * 10
				local var_51_4 = var_51_2 * 10
				local var_51_5, var_51_6 = var_51_1:getBonePosition("top")
				
				EffectManager:Play({
					scale = 1,
					fn = "encounter_01.cfx",
					layer = BGI.main.layer,
					x = var_51_5 + 40,
					y = var_51_6 + 10,
					z = var_51_0.z,
					action = BattleAction,
					delay = arg_51_1
				})
			end
		end
		
		var_48_6()
	end
	
	local function var_48_8(arg_52_0)
		if not arg_52_0.logic:isPVP() then
			if var_48_1 then
				EffectManager:Play({
					scale = 1,
					z = 999,
					fn = "ui_boss_encounter.cfx",
					layer = BGI.ui_layer,
					x = DESIGN_WIDTH / 2,
					y = DESIGN_HEIGHT * 0.5,
					action = BattleAction
				})
			else
				local var_52_0 = 0
				
				if var_48_0 then
					var_52_0 = 1000
					
					EffectManager:Play({
						scale = 1,
						z = 999,
						fn = "ui_warning_mark.cfx",
						layer = BGI.ui_layer,
						x = DESIGN_WIDTH / 2,
						y = DESIGN_HEIGHT * 0.5,
						action = BattleAction
					})
				end
				
				EffectManager:Play({
					scale = 1,
					z = 999,
					fn = "encounter_baner.cfx",
					layer = BGI.ui_layer,
					x = DESIGN_WIDTH / 2,
					y = DESIGN_HEIGHT * 0.7,
					delay = var_52_0,
					action = BattleAction
				})
			end
		else
			EffectManager:Play({
				scale = 1,
				z = 99999,
				fn = "pvp_battle_igni.cfx",
				layer = BGI.ui_layer,
				x = DESIGN_WIDTH / 2,
				y = DESIGN_HEIGHT * 0.7,
				action = BattleAction
			})
		end
	end
	
	BattleAction:Add(SEQ(CALL(var_48_5, arg_48_0), DELAY(100)), BGI.ui_layer, "battle.enter")
	
	local var_48_9 = 0
	local var_48_10 = arg_48_2.burning_phase_count or 0
	
	if var_48_1 then
		if not arg_48_0.is_screen_restoring and var_48_10 < 1 then
			var_48_9 = 2500
		end
		
		local var_48_11 = arg_48_0.logic:getCurrentRoadInfo().road_id
		local var_48_12 = DB("level_info", var_48_11, "bgm_boss")
		
		if var_48_12 then
			SoundEngine:playBGM("event:/bgm/" .. var_48_12)
		end
	end
	
	if arg_48_0.logic:isAbyss() then
		arg_48_0:showStageTitleLabel(var_48_1)
	else
		if not arg_48_0.is_screen_restoring and var_48_10 < 1 then
			BattleAction:Add(SEQ(DELAY(100), CALL(var_48_7, arg_48_0, var_48_9)), BGI.ui_layer, "battle.enter")
		else
			var_48_6()
		end
		
		local var_48_13
		
		if arg_48_0.logic.enemy_uid then
			local var_48_14 = string.split(arg_48_0.logic.enemy_uid, ":")
			
			if var_48_14[1] == "npc" then
				var_48_13 = var_48_14[3]
			end
		end
		
		local var_48_15
		
		if var_48_13 then
			var_48_15 = DB("pvp_npcbattle", var_48_13, "story_start")
		end
		
		if arg_48_0.logic:isTournament() then
			local var_48_16 = arg_48_0.logic:getTournamentID()
			
			var_48_15 = DB("substory_tournament", var_48_16, "story_start")
		end
		
		if var_48_15 then
			start_new_story(nil, var_48_15, {
				force = true,
				on_finish = function()
					var_48_8(arg_48_0)
					TutorialGuide:onBattleStoryEnd(var_48_15)
				end
			})
		elseif not arg_48_0.is_screen_restoring and var_48_10 < 1 then
			BattleAction:Add(SEQ(DELAY(100), CALL(var_48_8, arg_48_0)), BGI.ui_layer, "battle.enter")
		end
	end
	
	local var_48_17 = arg_48_0.logic:getCurrentRoadInfo().road_reverse and -1 or 1
	
	BattleLayout:appearTeamLayout(ENEMY, var_48_9, var_48_17)
	
	if not arg_48_0.logic:isPVP() and arg_48_0.logic:getStageMainType() ~= "tow" and arg_48_0.logic:getStageMainType() ~= "def" then
		BattleMapManager:show(false)
	end
	
	UIBattleGuideArrow:hide()
	BattleUI:setStageMode(STAGE_MODE.EVENT)
	BattleUI:setVisible(true)
	BattleUI:updateTimeline(true)
	BattleUI:playFaceFrame(true, arg_48_0.logic:predictAttackers()[1], 460)
	
	if arg_48_0.logic:isExpeditionType() then
		local var_48_18, var_48_19 = arg_48_0.logic:getExpeditionBoss()
		
		if var_48_19 then
			BattleUI:updateUnitGaugeInfo(var_48_19)
			BattleUI:onUpdateGauge(var_48_19)
			
			if var_48_19.ui_vars.gauge and var_48_19.ui_vars.gauge:isValid() then
				var_48_19.ui_vars.gauge:setHP(true, 0)
			end
		end
	end
	
	SoundEngine:play("event:/battle/encounter")
	SoundEngine:linearChangeParam("battle", 1, 1000)
	BattleField:setVisibleFieldModel(false)
	TutorialGuide:onEncounterEnemy(arg_48_0.logic)
	
	if arg_48_0:isRealtimeMode() then
		if arg_48_0:getInitSnap() then
			arg_48_0.logic:command({
				cmd = "Snapshot",
				snap_data = arg_48_0:getInitSnap(),
				opts = {
					clearAll = true
				}
			})
		end
		
		arg_48_0.viewer.player:play(1000)
		
		for iter_48_4, iter_48_5 in pairs(arg_48_0.logic.units) do
			if iter_48_5.ui_vars.gauge and iter_48_5.ui_vars.gauge:isValid() then
				iter_48_5:calc()
				iter_48_5.ui_vars.gauge:updateMarks()
			end
		end
	elseif arg_48_0:isReplayMode() then
		BattleUIAction:Add(SEQ(DELAY(1200), CALL(function()
			arg_48_0.viewer.player:moveTurn(0, true)
			arg_48_0.viewer.player:updateUnitState()
			
			local var_54_0 = BattleUI:getReplayController()
			
			if var_54_0 then
				var_54_0:show()
				var_54_0:play()
			end
		end)), BGI.ui_layer, "battle.replay.begin")
	end
end

function Battle.onDestroyedRoadEvent(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0.logic:getRoadEventObject(arg_55_1)
	
	if not var_55_0 then
		return 
	end
	
	BattleMapManager:updateIcon(var_55_0)
end

function Battle.onCompleteRoadEvent(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.logic:getRoadEventObject(arg_56_1)
	
	if not var_56_0 then
		return 
	end
	
	BattleMapManager:updateIcon(var_56_0)
	arg_56_0:onCheckFinishRoadEvent()
	BattleField:updateReachMoveable(arg_56_0.logic)
	
	local var_56_1 = var_56_0.type
	
	if string.starts(var_56_1, "battle") and arg_56_0.logic.pet then
		local var_56_2 = arg_56_0.logic.pet
		local var_56_3 = arg_56_0.logic.pet.model
		
		if get_cocos_refid(var_56_3) then
			BattleAction:Add(SEQ(CALL(EffectManager.Play, EffectManager, {
				fn = "ui_pet_pop_eff.cfx",
				layer = var_56_3:getBoneNode("target")
			}), DMOTION("fade_in"), MOTION("idle", true), CALL(var_56_2.setMoverPause, var_56_2, false)), var_56_3, "battle.pet")
		end
	end
end

function Battle.onFireRoadEvent(arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = assert(arg_57_0.logic:getRoadEventObject(arg_57_1))
	
	if var_57_0:isTouchable() then
		local var_57_1 = BattleField:getRoadEventFieldModel(var_57_0)
		
		if get_cocos_refid(var_57_1) then
			var_57_1:activeAction(var_57_1:getParent())
			arg_57_0:removeGuideUI()
			
			local var_57_2 = var_57_1:getChildByName("guide_ui")
			
			if get_cocos_refid(var_57_2) then
				if var_57_2.remove_ui then
					var_57_2:remove_ui()
				else
					BattleUIAction:Remove(var_57_2)
					var_57_2:removeFromParent()
				end
			end
		end
		
		local var_57_3 = arg_57_0.logic:getBattleUID()
		
		ConditionContentsManager:dispatch("battle.touchObject", {
			unique_id = var_57_3,
			entertype = arg_57_0.logic.type,
			event_type = var_57_0.type,
			enter_id = arg_57_0.logic.map.enter,
			ignore_condition = Battle:checkIgnoreCondition()
		})
		TutorialGuide:procGuide()
		BattleStory:playRoadEventStory(arg_57_0.logic.map.enter, var_57_0, "after")
		
		if arg_57_2 then
		else
			arg_57_0:onClickNextButton(false)
		end
		
		saveBattleInfo()
	end
end

function Battle.onEndRoadEvent(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0.logic:getRoadEventObject(arg_58_1) or {}
	
	local function var_58_1()
		print("callback_doEndRoadEvent")
		
		local var_59_0 = arg_58_0.logic:getFinalResult() == "lose"
		
		if not var_59_0 then
			local var_59_1 = false
			local var_59_2 = arg_58_0.logic:getCurrentRoadSectorId()
			local var_59_3 = arg_58_0.logic:getRoadSectorObject(var_59_2)
			
			if arg_58_0.logic:isSequenceType(var_59_3.road_id) then
				var_59_1 = arg_58_0.logic:isCompletedRoadBattle(var_59_3.road_id)
			end
			
			BattleField:setVisibleFieldModel(true, var_59_1)
		end
		
		BattleField:setCheckableEvent(true)
		
		local var_59_4 = arg_58_0.logic:getCurrentRoadInfo()
		
		BattleLayout:setPause(var_59_4.is_cross)
		
		if not var_59_0 then
			if not arg_58_0.is_screen_restoring then
				BattleDropManager:restore(arg_58_0:forecastReward(arg_58_0.logic))
				BattleMapManager:reloadInventory()
				BattleDropManager:showBaseDrops((var_58_0.data or {}).base_drop)
			end
			
			if var_58_0.is_last and arg_58_0.logic:getCurrentRoadType() == "chaos" then
				BattleField:addWarpLine("finishToNext")
				BattleField:lockViewPort(true)
			end
		end
		
		if string.starts(arg_58_0.logic.type, "dungeon") then
			if not var_59_0 then
				arg_58_0:setStageMode(STAGE_MODE.MOVE)
				BattleUI:hideGauge()
				BattleUI:setVisible(false)
				
				if not arg_58_0.logic:isPVP() and arg_58_0.logic:getStageMainType() ~= "tow" and arg_58_0.logic:getStageMainType() ~= "def" then
					BattleMapManager:show(true)
				end
				
				for iter_59_0 = 1, #arg_58_0.logic.friends do
					if not arg_58_0.logic.friends[iter_59_0]:isDead() then
						local var_59_5 = arg_58_0.logic.friends[iter_59_0].model
						
						Battle:playIdleAction(arg_58_0.logic.friends[iter_59_0], "battle.move_center")
					end
				end
			end
			
			BattleAction:Add(SEQ(DELAY(600), CALL(function()
				BattleAction:Add(SEQ(COND_LOOP(DELAY(10), function()
					if not arg_58_0:isPlayingBattleAction() then
						return true
					end
				end), CALL(arg_58_0.testAutoPlayingMode, Battle)), arg_58_0)
			end)), arg_58_0, "battle")
		end
		
		if not arg_58_0.is_screen_restoring then
			if not arg_58_0.logic:isEnded() then
				BattleAction:Add(SEQ(DELAY(610), CALL(arg_58_0.DoMoveStage, Battle)), arg_58_0, "battle")
			end
			
			TutorialGuide:onEndStage(arg_58_1)
		end
	end
	
	arg_58_0:highlightMainAttacker()
	
	if not arg_58_0.is_screen_restoring then
		SoundEngine:linearChangeParam("battle", 0, 1000)
		BattleUI:initSummonReservation()
		BattleAction:Add(SEQ(COND_LOOP(DELAY(10), function()
			if not arg_58_0:isPlayingBattleAction() then
				return true
			end
		end), CALL(function()
			BattleStory:playRoadEventStory(arg_58_0.logic.map.enter, var_58_0, "after")
			attach_story_finished_callback(var_58_1)
		end)), arg_58_0, "battle.proc_lock")
	else
		var_58_1()
	end
end

function Battle.onEndBattle(arg_64_0)
	arg_64_0:doEndBattle()
end

function Battle.onSkillEff(arg_65_0, arg_65_1)
	local var_65_0, var_65_1 = DB("skill_effect", arg_65_1.eff, {
		"cfx",
		"bone"
	})
	
	arg_65_0:playStateEff(arg_65_1, var_65_0, var_65_1)
end

function Battle.onSkillStart(arg_66_0, arg_66_1)
	arg_66_0:highlightMainAttacker()
	
	if not get_cocos_refid(arg_66_1.unit.model) then
		error("attacker.model is nil")
	end
	
	ur.Model:setNoSoundAniFlag("b_idle_ready", true)
	
	local var_66_0 = arg_66_1.att_info
	
	arg_66_0.viewer:setAttackInfo(arg_66_1.unit, arg_66_1.att_info)
	
	local var_66_1 = 0
	
	if arg_66_0.logic:isRealtimeMode() or arg_66_0:isReplayMode() then
		local var_66_2 = DB("skill", var_66_0.skill_id, {
			"parent_skill"
		})
		local var_66_3 = false
		
		if var_66_2 then
			local var_66_4 = string.gsub(var_66_0.skill_id, var_66_2, "")
			
			if var_66_0.skill_id ~= var_66_4 and string.starts(var_66_4, "s") then
				var_66_1 = 500
				var_66_3 = true
				
				BattleUI:startTopSoulEffect(arg_66_1.unit:getAlly())
			else
				var_66_3 = false
			end
		end
		
		if arg_66_0.viewer and arg_66_0.viewer.service then
			arg_66_0.viewer.service:sendImmediateDataToWebsock("skill", {
				use_soul_burn = var_66_3
			})
		end
	end
	
	local function var_66_5(arg_67_0, arg_67_1)
		if arg_66_0.vars.end_battle then
			return 
		end
		
		if arg_67_1.hidden then
			BattleUI:resetVars()
			BattleUI:resetCombo()
		end
		
		if arg_67_1.hidden or (arg_67_1.coop_order or 0) > 1 then
			arg_66_0:playAdditionalSkillEffect(arg_67_0)
		end
		
		if (arg_67_1.coop_order or 0) < 2 then
			BattleUI:showSkillName(arg_67_0, arg_67_1.skill_id)
		end
		
		arg_66_0.vars.mode = "Attack"
		
		if arg_67_0.inst.ally == FRIEND or arg_66_0:isReplayMode() then
			BattleUI:hideSkillButtons()
			BattleUI:hideTargetButtons()
		end
		
		BattleAction:Remove("battle.ready")
		
		local var_67_0 = "battle.damage_motion_finish" .. tostring(arg_67_0:getUID())
		
		BattleAction:Remove(var_67_0)
		
		if DB("skill", arg_67_1.skill_id, "deal_damage") == "y" then
			BattleUI:hideGauge()
		end
		
		arg_66_0:hideFocusRing()
		BattleUI:setIndividualShow(nil)
		
		local var_67_1, var_67_2 = arg_66_0:startSkillMotion(arg_67_0, arg_67_1)
		
		if not arg_67_0:isSummon() then
			arg_66_0:applyTimeScaleUp()
		end
		
		if get_cocos_refid(arg_67_0.model) then
			arg_67_0.model:setPartsVisibility("skill", false, "effect")
		end
		
		BattleUI:updateUnitGaugeInfo(arg_67_0)
		TutorialGuide:onSkillStart(arg_66_0.logic, arg_67_0, arg_67_1.skill_id)
		
		return var_67_1, var_67_2
	end
	
	if var_66_0.coop_order == 1 then
		local var_66_6, var_66_7 = var_66_5(arg_66_1.unit, arg_66_1.att_info)
		
		if not var_66_6 then
			return 
		end
		
		local var_66_8 = StageStateManager:enumStateTiming("HIT", var_66_6, var_66_7)
		local var_66_9 = 0
		
		if table.empty(var_66_8) then
			Log.e("BATTLE", "협공 HIT 타이밍 계산 실패 HIT컴포넌트가 없다.")
		else
			var_66_9 = var_66_8[#var_66_8]
		end
		
		local var_66_10 = var_66_9 - COOP_ATTACK_DELAY
		
		BattleAction:Append(SEQ(DELAY(var_66_10)), arg_66_0, "battle.proc_action")
	else
		BattleAction:Append(SEQ(DELAY(var_66_1), CALL(var_66_5, arg_66_1.unit, arg_66_1.att_info)), arg_66_0, "battle.proc_action")
	end
end

function Battle.onSkillStop(arg_68_0, arg_68_1, arg_68_2)
	if arg_68_2 then
		arg_68_0:stopSkillMotion(arg_68_1, arg_68_2)
	elseif get_cocos_refid(arg_68_1.model) then
		BattleAction:Add(MOTION("idle", true), arg_68_1.model, "battle")
	end
end

function Battle.onInvokeStateEffect(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0:getTargetUNIT(arg_69_1)
	
	if not var_69_0 then
		return 
	end
	
	if var_69_0:isDead() then
		return 
	end
	
	if not get_cocos_refid(var_69_0.model) then
		return 
	end
	
	EffectManager:Attach(arg_69_1.effect, var_69_0.model, arg_69_1.target_bone, nil, arg_69_1.scale)
end

function Battle.onAddState(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5)
	local var_70_0 = arg_70_2.id
	local var_70_1 = arg_70_2.db.cs_type
	local var_70_2 = arg_70_2.effect
	local var_70_3 = arg_70_2.eff_bone
	local var_70_4 = arg_70_2.eff_scale
	local var_70_5 = arg_70_2.always_visible
	
	Log.d("stack_count", "Battle.onAddState", arg_70_1.db.name, var_70_0, var_70_2, var_70_3)
	
	if var_70_2 and var_70_2 ~= "nil" and var_70_2 ~= "null" and arg_70_1.model then
		local var_70_6 = arg_70_1.model:addPartsObject({
			name = string.format("%s/%s", var_70_3 or "", var_70_2 or ""),
			source = var_70_2,
			bone = var_70_3,
			scale = var_70_4,
			loop_only = arg_70_3,
			always_visible = var_70_5
		}, "effect")
		
		if get_cocos_refid(var_70_6) and string.starts(var_70_2, "stse_") and arg_70_1.model:getScaleX() < 0 then
			var_70_6:setScaleX(-var_70_6:getScaleX())
		end
		
		if arg_70_4 and var_70_1 == "debuff" then
		else
			local var_70_7 = "event:/effect/" .. Path.filename_withoutext(var_70_2 or "")
			
			if not arg_70_5 and SoundEngine:existsEvent(var_70_7) then
				SoundEngine:playBattle(var_70_7)
			end
		end
	end
	
	if arg_70_2:isBarrier() and arg_70_1.ui_vars.gauge then
		arg_70_1.ui_vars.gauge:set(true)
	end
	
	if arg_70_2:isModelChange() then
		UIBattleAttackOrder:activeUnitInfo(arg_70_1)
		UIBattleAttackOrder:updateUnitInfo(arg_70_1)
	end
	
	arg_70_0:updateStateMotion(arg_70_1)
end

function Battle.onRemoveState(arg_71_0, arg_71_1, arg_71_2)
	local var_71_0 = arg_71_2.id
	local var_71_1 = arg_71_2.db.cs_type
	local var_71_2 = arg_71_2.effect
	local var_71_3 = arg_71_2.eff_bone
	
	if var_71_2 and get_cocos_refid(arg_71_1.model) then
		arg_71_1.model:removePartsObject(string.format("%s/%s", var_71_3 or "", var_71_2 or ""), "effect")
	end
	
	if arg_71_2:isModelChange() then
		arg_71_1.model_vars = nil
		
		BattleUtil:updateModel(arg_71_1)
		
		if get_cocos_refid(arg_71_1.model) then
			BattleAction:Add(Battle:getIdleAction(arg_71_1), arg_71_1.model)
		end
		
		UIBattleAttackOrder:activeUnitInfo(arg_71_1)
		UIBattleAttackOrder:updateUnitInfo(arg_71_1)
	end
	
	if arg_71_2.db.cs_deactivate_effect and arg_71_2.db.cs_deactivate_eff_bone then
		local var_71_4 = arg_71_1.model:getBoneNode(arg_71_2.db.cs_deactivate_eff_bone)
		
		if get_cocos_refid(var_71_4) then
			local var_71_5 = EffectManager:Play({
				extractNodes = true,
				fn = arg_71_2.db.cs_deactivate_effect,
				layer = var_71_4
			})
			
			if get_cocos_refid(var_71_5) then
				var_71_5:setScaleFactor(arg_71_2.db.cs_deactivate_eff_scale or 1)
			end
		end
	end
	
	if arg_71_2:isBarrier() and arg_71_1.ui_vars and arg_71_1.ui_vars.gauge then
		arg_71_1.ui_vars.gauge:set(true)
	end
	
	arg_71_0:updateStateMotion(arg_71_1)
end

function Battle.onFieldObstacle(arg_72_0, arg_72_1)
	local var_72_0 = arg_72_0.logic:getRoadEventObject(arg_72_1)
	local var_72_1 = BattleField:getRoadEventFieldModel(var_72_0)
	local var_72_2 = var_72_0.value or {}
	
	if var_72_2.attack then
		UIAction:Add(SEQ(DMOTION("Damage"), DELAY(600), CALL(function()
			UIAction:Add(SEQ(DMOTION("Destroy"), DMOTION("Finish"), SHOW(false)), var_72_1, "field.object")
		end)), var_72_1, "block")
		
		local var_72_3 = var_72_2.damage_msg
		
		if var_72_3 then
			local var_72_4 = {}
			
			for iter_72_0 = 1, 5 do
				local var_72_5 = var_72_3 .. "_" .. iter_72_0
				
				if DB("text", var_72_5, "text") then
					table.insert(var_72_4, var_72_5)
				end
			end
			
			if #var_72_4 > 0 then
				balloon_message_with_sound(var_72_4[math.random(1, #var_72_4)])
			end
		end
	else
		UIAction:Add(SEQ(DMOTION("Destroy"), DMOTION("Finish"), SHOW(false)), var_72_1, "field.object")
	end
end

function Battle.onFieldNPCShop(arg_74_0, arg_74_1)
	if UIAction:Find("field.object") then
		return 
	end
	
	ShopRandom:open(arg_74_1.shop_id)
	
	local var_74_0 = arg_74_0.logic:getRoadEventObject(arg_74_1.road_event_id)
	local var_74_1 = BattleField:getRoadEventFieldModel(var_74_0)
	
	UIAction:Add(SEQ(COND_LOOP(SEQ(DELAY(100)), function()
		if ShopRandom.ready and not get_cocos_refid(ShopRandom.wnd) then
			return true
		end
	end), CALL(function(arg_76_0, arg_76_1)
		BattleUI:displayRoadEventObjectGuideUI(arg_76_0, arg_76_1)
		
		arg_74_0.vars.lastTouchUpTime = LAST_TICK
	end, var_74_0, var_74_1)), var_74_1, "field.object")
end

function Battle.onUpdateMorale(arg_77_0, arg_77_1, arg_77_2)
	BattleMapManager:updateMorale()
	TutorialGuide:onUpdateMoral(arg_77_1, arg_77_2)
end

function Battle.onSkipTurn(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0:getTargetUNIT(arg_78_1)
	
	BattleUI:displayText(arg_78_0:getTargetUNIT(arg_78_1), T(arg_78_1.reason))
	BattleAction:Add(DELAY(1500), var_78_0, "battle")
end

function Battle.onReplaceUnit(arg_79_0, arg_79_1)
	arg_79_0:spawn(arg_79_1.dead_unit, arg_79_1.dead_index, arg_79_1.unit, arg_79_1.type)
	BattleUI:updateUnitFaces()
end

function Battle.onFieldNPC(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0 = arg_80_2 > 1
	local var_80_1 = BattleField:getRoadEventFieldModel(arg_80_1)
	local var_80_2 = var_80_1.info.story_id_before
	local var_80_3 = var_80_1.info.story_id_after
	
	var_80_2 = var_80_2 or var_80_3
	
	local var_80_4 = var_80_0 and var_80_3 or var_80_2
	
	if not var_80_4 then
		return 
	end
	
	local var_80_5 = BattleLayout:isPaused()
	
	BattleLayout:setPause(true)
	
	if start_new_story(BGI.ui_layer, var_80_4, {
		force_on_finish = true,
		force = true,
		on_finish = function()
			BattleUI:displayRoadEventObjectGuideUI(arg_80_1, var_80_1)
			BattleLayout:setPause(var_80_5)
			TutorialGuide:onBattleStoryEnd(var_80_4)
		end
	}) then
		local var_80_6 = arg_80_0.logic:getBattleUID()
		
		ConditionContentsManager:dispatch("battle.story", {
			unique_id = var_80_6,
			storyid = var_80_4,
			ignore_condition = Battle:checkIgnoreCondition()
		})
		saveBattleInfo()
	end
	
	UIAction:Remove("npc.balloon" .. get_cocos_refid(var_80_1))
	
	local var_80_7 = var_80_1:getParent():getChildByName(get_cocos_refid(var_80_1))
	
	if get_cocos_refid(var_80_7) then
		var_80_7:removeFromParent()
	end
	
	UIAction:Add(SEQ(COND_LOOP(DELAY(100), function()
		if not is_playing_story() then
			return true
		end
	end), CALL(var_80_1.showBalloon, var_80_1)), arg_80_0, "npc.balloon")
end

function Battle.onStateFinishCallback(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
	local var_83_0 = arg_83_1.model
	local var_83_1 = arg_83_0.vars.concentration_info[arg_83_1]
	
	if not var_83_1 then
	end
	
	local var_83_2 = var_83_1.id
	local var_83_3 = var_83_1.d_units
	local var_83_4 = DB("skill", arg_83_2.call, "id")
	
	if var_83_4 and not arg_83_2.isPreProc and arg_83_3 then
		local var_83_5 = get_skillpt_id("skill_id")
		
		for iter_83_0 = #var_83_3, 1, -1 do
			if var_83_3[iter_83_0]:isDead() then
				table.remove(var_83_3, iter_83_0)
			end
		end
		
		if not var_83_3 or #var_83_3 <= 0 then
			var_83_3 = arg_83_0.logic:getTargetCandidates(var_83_2, arg_83_1)
			arg_83_0.att_info.target_type = DB("skill", var_83_2, "target")
			
			local var_83_6 = DB("skill", var_83_2, "target")
			
			if var_83_6 == 2 or var_83_6 == 12 then
				var_83_3 = {
					var_83_3[1]
				}
			end
		end
		
		arg_83_0.att_info.playing = true
		arg_83_0.att_info.selected_skill_idx = var_83_1.idx
		arg_83_0.att_info.skill_id = var_83_4
		arg_83_0.att_info.skills = {
			[var_83_1.idx] = var_83_4
		}
		arg_83_0.att_info.a_unit = arg_83_1
		arg_83_0.att_info.d_units = var_83_3
		arg_83_0.att_info.d_unit = var_83_3[1]
		
		if not arg_83_1:getSkillCool(var_83_4) then
			arg_83_1:setSkillCool(var_83_4, 0)
		end
		
		arg_83_0:startSkillMotion(arg_83_1, var_83_3, var_83_4)
	end
end

function Battle.onDropReward(arg_84_0, arg_84_1)
	if arg_84_1.target_uid then
		local var_84_0 = arg_84_0.logic:getUnit(arg_84_1.target_uid)
		
		if var_84_0.x and var_84_0.y and var_84_0.z then
			BattleDropManager:dropReward(var_84_0.x, var_84_0.y, var_84_0.z, arg_84_1.reward)
		end
	else
		local var_84_1 = arg_84_0.logic:getRoadEventObject(arg_84_1.road_event_id)
		local var_84_2 = BattleField:getRoadEventFieldModel(var_84_1)
		
		BattleDropManager:takeReward(var_84_2, arg_84_1.reward)
	end
end
