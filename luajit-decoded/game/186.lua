function Battle.isAutoPlaying(arg_1_0)
	if GAME_STATIC_VARIABLE.pvp_auto_mode and arg_1_0.logic:isPVP() then
		return true
	end
	
	return arg_1_0:_getAutoBattle() and arg_1_0:isAutoPlayableStage()
end

function Battle.toggleAutoBattle(arg_2_0)
	if GAME_STATIC_VARIABLE.pvp_auto_mode and arg_2_0.logic:isPVP() then
		return 
	end
	
	if not arg_2_0.logic or arg_2_0.logic:isRealtimeMode() and not arg_2_0:isNetLocalTest() then
		return 
	end
	
	if not arg_2_0:isAutoPlayableStage() then
		balloon_message_with_sound("no_auto_mode")
		
		return 
	end
	
	local var_2_0 = not arg_2_0:_getAutoBattle() and true
	
	Log.i("BATTLE", "auto mode " .. tostring(var_2_0))
	SoundEngine:play(var_2_0 == true and "event:/ui/battle_hud/auto_on" or "event:/ui/battle_hud/auto_off")
	arg_2_0:_setAutoBattle(var_2_0)
	
	arg_2_0.vars.auto_walking = arg_2_0:isAutoPlaying()
	
	if not var_2_0 and arg_2_0:isSummonReservationOn() then
		BattleUI:toggleSummonReservation()
	end
	
	arg_2_0:testAutoPlayingMode()
end

function Battle.isAutoPlayableStage(arg_3_0)
	if arg_3_0.logic and arg_3_0.logic.auto_battle_able then
		return false
	end
	
	if DEBUG.MAP_DEBUG then
		return true
	end
	
	if getenv("app.viewer") == "true" then
		return false
	end
	
	if GAME_STATIC_VARIABLE.pvp_auto_mode and arg_3_0.logic:isPVP() or string.starts(arg_3_0.logic.map.enter, "tot") or not BattleRepeat:check_cleared_ije005() then
		return false
	end
	
	return true
end

function Battle._getAutoBattle(arg_4_0)
	if not arg_4_0.logic then
		return false
	end
	
	if arg_4_0.logic:isPVP() and not GAME_STATIC_VARIABLE.pvp_auto_mode or arg_4_0.logic:isSkillPreview() then
		return arg_4_0.vars.auto_battle
	end
	
	if BattleRepeat:isPlayingRepeatPlay() then
		return true
	end
	
	local var_4_0 = "app.auto_battle"
	
	if arg_4_0.logic.map and arg_4_0.logic.map.enter and string.starts(arg_4_0.logic.map.enter, "mission_") then
		var_4_0 = var_4_0 .. "." .. string.sub(arg_4_0.logic.map.enter, 1, 9)
	end
	
	local var_4_1 = SAVE:get(var_4_0)
	
	if var_4_1 ~= nil then
		SAVE:setKeep(var_4_0, var_4_1)
		SAVE:set(var_4_0, nil)
		SAVE:save()
	end
	
	return SAVE:getKeep(var_4_0)
end

function Battle._setAutoBattle(arg_5_0, arg_5_1)
	if arg_5_0.logic:isPVP() and not GAME_STATIC_VARIABLE.pvp_auto_mode or arg_5_0.logic:isSkillPreview() then
		arg_5_0.vars.auto_battle = arg_5_1
		
		return 
	end
	
	local var_5_0 = "app.auto_battle"
	
	if arg_5_0.logic.map and arg_5_0.logic.map.enter and string.starts(arg_5_0.logic.map.enter, "mission_") then
		var_5_0 = var_5_0 .. "." .. string.sub(arg_5_0.logic.map.enter, 1, 9)
	end
	
	SAVE:setKeep(var_5_0, arg_5_1)
end

function Battle.testAutoPlayingMode(arg_6_0)
	local var_6_0
	local var_6_1
	
	if not arg_6_0:isAutoPlayableStage() then
		if arg_6_0:isAutoPlaying() then
			arg_6_0:endAutoBattle()
		end
		
		var_6_1 = false
	else
		var_6_1 = arg_6_0:_getAutoBattle()
	end
	
	if var_6_1 then
		arg_6_0:startAutoBattle()
	else
		arg_6_0:endAutoBattle()
	end
end

function Battle.playAutoSelectTargetForced(arg_7_0, arg_7_1)
	if arg_7_0:isSummonReservationOn() and arg_7_0.logic:getSummonSkillUseInfo(FRIEND).useable then
		arg_7_0:startSummonSkill()
		
		return 
	end
	
	local var_7_0 = arg_7_0.vars.auto_specify_target
	
	if var_7_0 and (var_7_0:isEmptyHP() or not var_7_0:isValidTarget(arg_7_1)) then
		var_7_0 = nil
		
		arg_7_0:setAutoSpecifyTarget(nil)
	end
	
	if not arg_7_0.vars.ai_random then
		arg_7_0.vars.ai_random = getRandom(systick())
	end
	
	local var_7_1, var_7_2, var_7_3, var_7_4 = AIManager:selectSkillIdxAndTarget(arg_7_0.vars.ai_random, arg_7_1, var_7_0)
	
	arg_7_0.vars.arrange_skill.attacker = arg_7_1
	arg_7_0.vars.arrange_skill.selected_skill_idx = var_7_1
	arg_7_0.vars.arrange_skill.skill_id = var_7_2
	
	arg_7_0:onSelectTarget(var_7_4)
end

function Battle.playAutoSelectTarget(arg_8_0, arg_8_1)
	if arg_8_0.logic:getTurnState() ~= "ready" and arg_8_0.logic:getTurnState() ~= "pending_ready" then
		return 
	end
	
	arg_8_1 = arg_8_1 or arg_8_0.logic:getTurnOwner()
	
	if arg_8_0:isRealtimeMode() and not arg_8_0:isNetLocalTest() or arg_8_0:isReplayMode() then
		return 
	end
	
	if arg_8_1 and arg_8_0.logic:isAIPlayer(arg_8_1) then
		return 
	end
	
	if arg_8_0:isSummonReservationOn() and arg_8_0.logic:getSummonSkillUseInfo(FRIEND).useable then
		arg_8_0:startSummonSkill()
		
		return 
	end
	
	if not arg_8_0:isAutoPlaying() then
		return 
	end
	
	if arg_8_0.vars.mode ~= "ReadyAttack" then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.auto_specify_target
	
	if var_8_0 and (var_8_0:isEmptyHP() or not var_8_0:isValidTarget(arg_8_1)) then
		var_8_0 = nil
		
		arg_8_0:setAutoSpecifyTarget(nil)
	end
	
	if not arg_8_0.vars.ai_random then
		arg_8_0.vars.ai_random = getRandom(systick())
	end
	
	local var_8_1, var_8_2, var_8_3, var_8_4 = AIManager:selectSkillIdxAndTarget(arg_8_0.vars.ai_random, arg_8_1, var_8_0)
	
	arg_8_0.vars.arrange_skill.attacker = arg_8_1
	arg_8_0.vars.arrange_skill.selected_skill_idx = var_8_1
	arg_8_0.vars.arrange_skill.skill_id = var_8_2
	
	arg_8_0:onSelectTarget(var_8_4)
	
	return true
end

function Battle.startAutoBattle(arg_9_0)
	if not arg_9_0:isAutoPlayableStage() then
		return 
	end
	
	BattleTopBar:update()
	BattleUI:updateAutoMode()
	
	if STAGE_MODE.MOVE ~= arg_9_0:getStageMode() then
		arg_9_0:playAutoSelectTarget()
		
		return 
	end
	
	if is_playing_story() then
		return 
	end
	
	if arg_9_0.logic:getStageMainType() ~= "adv" then
		BattleLayout:setDirection(1, true)
	else
		local var_9_0 = (arg_9_0.logic:getCurrentRoadInfo() or {}).road_reverse and -1 or 1
		
		BattleLayout:setDirection(var_9_0, true)
	end
	
	arg_9_0:onClickNextButton(true)
end

function Battle.endAutoBattle(arg_10_0)
	if GAME_STATIC_VARIABLE.pvp_auto_mode and arg_10_0.logic:isPVP() then
		return 
	end
	
	BattleUI:updateAutoMode()
	arg_10_0:setAutoSpecifyTarget(nil)
	
	if STAGE_MODE.MOVE == arg_10_0:getStageMode() then
		arg_10_0:onClickNextButton(false)
		
		arg_10_0.vars.auto_walking = false
		arg_10_0.vars.lastTouchUpTime = nil
	end
	
	BattleTopBar:update()
end

function Battle.testAutoSpecifyTarget(arg_11_0, arg_11_1)
	if arg_11_1 == arg_11_0.vars.auto_specify_target then
		arg_11_0:setAutoSpecifyTarget(nil)
	end
end

function Battle.toggleAutoSpecifyTarget(arg_12_0, arg_12_1)
	if arg_12_1 == nil then
		return 
	end
	
	if not arg_12_0:isAutoPlaying() then
		return 
	end
	
	if table.find(arg_12_0.logic.enemies, arg_12_1) == nil then
		return 
	end
	
	if arg_12_0.vars.auto_specify_target == nil then
		arg_12_0:setAutoSpecifyTarget(arg_12_1)
	elseif arg_12_1 == arg_12_0.vars.auto_specify_target then
		arg_12_0:setAutoSpecifyTarget(nil)
	else
		arg_12_0:setAutoSpecifyTarget(arg_12_1)
	end
end

function Battle.setAutoSpecifyTarget(arg_13_0, arg_13_1)
	if not arg_13_0.logic then
		return 
	end
	
	arg_13_0.vars.auto_specify_target = arg_13_1
	
	print("########################### 자동타겟 해제 ")
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.logic.units) do
		BattleUI:hideTimelineAutoTarget(iter_13_1)
	end
	
	BattleUI:hideAutoTargetFocusRing()
	
	if arg_13_1 then
		BattleUI:showAutoTargetFocusRing(arg_13_1)
		BattleUI:showTimelineAutoTarget(arg_13_1)
	end
end
