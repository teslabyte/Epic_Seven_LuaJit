WorldBoss = WorldBoss or {}
WorldBoss.FSM = WorldBoss.FSM or {}
WorldBoss.FSM.STATES = WorldBoss.STATES or {}
WorldBossState = {
	BATTLE = 22,
	END = 44,
	ACTION = 11,
	SUPPORTER = 33,
	SEQUENCER = 1
}

function WorldBoss.FSM.changeState(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:_onExit(arg_1_0.current_state)
	
	arg_1_0.current_state = arg_1_1
	
	arg_1_0:_onEnter(arg_1_1, arg_1_2)
end

function WorldBoss.FSM.update(arg_2_0)
	if arg_2_0.current_state then
		arg_2_0:_onUpdate(arg_2_0.current_state)
	end
end

function WorldBoss.FSM.pause(arg_3_0)
	if arg_3_0.current_state then
		arg_3_0:_onPause(arg_3_0.current_state)
	end
end

function WorldBoss.FSM.resume(arg_4_0)
	if arg_4_0.current_state then
		arg_4_0:_onResume(arg_4_0.current_state)
	end
end

function WorldBoss.FSM.getCurrentState(arg_5_0)
	return arg_5_0.current_state
end

function WorldBoss.FSM._onEnter(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 or not arg_6_0.STATES[arg_6_1] then
		return 
	end
	
	if arg_6_0.STATES[arg_6_1].onEnter then
		arg_6_0.STATES[arg_6_1]:onEnter(arg_6_2)
	end
end

function WorldBoss.FSM._onUpdate(arg_7_0, arg_7_1)
	if not arg_7_1 or not arg_7_0.STATES[arg_7_1] then
		return 
	end
	
	if arg_7_0.STATES[arg_7_1].onUpdate then
		arg_7_0.STATES[arg_7_1]:onUpdate()
	end
end

function WorldBoss.FSM._onExit(arg_8_0, arg_8_1)
	if not arg_8_1 or not arg_8_0.STATES[arg_8_1] then
		return 
	end
	
	if arg_8_0.STATES[arg_8_1].onExit then
		arg_8_0.STATES[arg_8_1]:onExit()
	end
end

function WorldBoss.FSM._onPause(arg_9_0, arg_9_1)
	if not arg_9_1 or not arg_9_0.STATES[arg_9_1] then
		return 
	end
	
	if arg_9_0.STATES[arg_9_1].onPause then
		arg_9_0.STATES[arg_9_1]:onPause()
	end
end

function WorldBoss.FSM._onResume(arg_10_0, arg_10_1)
	if not arg_10_1 or not arg_10_0.STATES[arg_10_1] then
		return 
	end
	
	if arg_10_0.STATES[arg_10_1].onResume then
		arg_10_0.STATES[arg_10_1]:onResume()
	end
end

WorldBoss.FSM.STATES[WorldBossState.SEQUENCER] = {}
WorldBoss.FSM.STATES[WorldBossState.SEQUENCER].onEnter = function(arg_11_0, arg_11_1)
	local var_11_0 = WorldBoss:getNextSequence()
	
	if not var_11_0 then
		WorldBoss.FSM:changeState(WorldBossState.END, {})
		
		return 
	end
	
	local var_11_1
	local var_11_2
	
	if var_11_0.type == "action" then
		var_11_1 = WorldBossState.ACTION
		var_11_2 = {
			skillact_id = var_11_0.value
		}
	elseif var_11_0.type == "battle" then
		var_11_1 = WorldBossState.BATTLE
		var_11_2 = var_11_0.value
	elseif var_11_0.type == "supporter" then
		var_11_1 = WorldBossState.SUPPORTER
		var_11_2 = var_11_0.value or {}
	else
		Log.e("Wrong type for Sequence Play")
		
		var_11_1 = WorldBossState.END
		var_11_2 = {}
	end
	
	local var_11_3 = WorldBoss:getWorldBoss()[1]
	
	if not var_11_3 then
		return 
	end
	
	BattleAction:Add(SEQ(DELAY(arg_11_1.delay_tm or 0), CALL(WorldBoss.FSM.changeState, WorldBoss.FSM, var_11_1, var_11_2)), var_11_3.model, "worldboss")
end
WorldBoss.FSM.STATES[WorldBossState.SEQUENCER].onExit = function(arg_12_0)
end
WorldBoss.FSM.STATES[WorldBossState.ACTION] = {}
WorldBoss.FSM.STATES[WorldBossState.ACTION].onEnter = function(arg_13_0, arg_13_1)
	WorldBossBattleUI:fadeOut()
	
	local var_13_0 = WorldBoss:getWorldBoss()[1]
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = {
		a_unit = var_13_0,
		d_units = WorldBoss:getRaidParty()
	}
	local var_13_2 = {
		rate = 1,
		unit = var_13_0,
		units = {
			friends = WorldBoss:getWorldBoss(),
			enemies = WorldBoss:getRaidParty()
		}
	}
	
	WorldBoss:setAttackInfo(var_13_0, var_13_1)
	SoundEngine:playBattle("event:/skill/" .. arg_13_1.skillact_id)
	
	local var_13_3, var_13_4 = StageStateManager:executeStateDoc(arg_13_1.skillact_id, "start", var_13_2)
	
	if var_13_3 then
		local var_13_5 = WorldBoss:isLastSequence() and 0 or 500
		
		var_13_3:setCallback({
			onFinish = function()
				BattleAction:Add(SEQ(DELAY(var_13_5), CALL(WorldBoss.FSM.changeState, WorldBoss.FSM, WorldBossState.SEQUENCER, {})), var_13_0.model, "worldboss")
			end
		})
		StageStateManager:releaseStateCache(arg_13_1.skillact_id)
	end
end
WorldBoss.FSM.STATES[WorldBossState.ACTION].onExit = function(arg_15_0)
end
WorldBoss.FSM.STATES[WorldBossState.BATTLE] = {}
WorldBoss.FSM.STATES[WorldBossState.BATTLE].onEnter = function(arg_16_0, arg_16_1)
	WorldBossBattleUI:fadeIn()
	
	arg_16_0.ready_for_nextseq = false
	arg_16_0.is_battle_finish = false
	arg_16_0.pause = false
	arg_16_0.total_play_tick = tonumber(arg_16_1.total_play_tick) or 10000
	arg_16_0.battle_timeline = arg_16_1.battle_timeline
	arg_16_0.start_tick = systick()
	arg_16_0.elapsed_tick = 0
	arg_16_0.skill_actor_list = {}
	arg_16_0.raidparty = WorldBoss:getRaidParty()
	arg_16_0.worldboss = WorldBoss:getWorldBoss()
end
WorldBoss.FSM.STATES[WorldBossState.BATTLE].onUpdate = function(arg_17_0)
	if not arg_17_0.start_tick then
		return 
	end
	
	if not arg_17_0.total_play_tick then
		return 
	end
	
	if not arg_17_0.battle_timeline then
		return 
	end
	
	if arg_17_0.pause then
		return 
	end
	
	arg_17_0.elapsed_tick = systick() - arg_17_0.start_tick
	
	if arg_17_0.elapsed_tick >= arg_17_0.total_play_tick then
		arg_17_0.ready_for_nextseq = true
	end
	
	local var_17_0
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.battle_timeline) do
		if iter_17_1.attack_time < arg_17_0.elapsed_tick then
			arg_17_0:executeTimeline(iter_17_1)
			
			arg_17_0.battle_timeline[iter_17_0] = nil
		else
			break
		end
	end
end
WorldBoss.FSM.STATES[WorldBossState.BATTLE].onExit = function(arg_18_0)
	if WorldBoss.vars.skip_sequence then
		for iter_18_0, iter_18_1 in pairs(arg_18_0.skill_actor_list) do
			StageStateManager:stop(iter_18_1.skill_id, iter_18_1)
		end
	end
	
	arg_18_0.skill_actor_list = nil
end
WorldBoss.FSM.STATES[WorldBossState.BATTLE].onPause = function(arg_19_0)
	arg_19_0.pause = true
end
WorldBoss.FSM.STATES[WorldBossState.BATTLE].onResume = function(arg_20_0)
	if not arg_20_0.start_tick then
		return 
	end
	
	if not arg_20_0.elapsed_tick then
		return 
	end
	
	arg_20_0.pause = false
	arg_20_0.start_tick = systick() - arg_20_0.elapsed_tick
end
WorldBoss.FSM.STATES[WorldBossState.BATTLE].executeTimeline = function(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.raidparty) do
		if iter_21_1.inst.pos == arg_21_1.unit_pos then
			var_21_0 = iter_21_1
			
			break
		end
	end
	
	if not var_21_0 then
		return 
	end
	
	var_21_0.curatt_dmg = var_21_0.curatt_dmg + arg_21_1.attack_damage
	
	local var_21_1 = var_21_0.model
	
	if not get_cocos_refid(var_21_1) then
		return 
	end
	
	if arg_21_0.skill_actor_list[var_21_1] then
		return 
	end
	
	local var_21_2 = arg_21_0.worldboss[1]
	local var_21_3 = var_21_0:getSkinCheck()
	local var_21_4 = var_21_0:getSkillByIndex(1)
	
	if not DB("skill", var_21_4, "skillset") then
		var_21_4 = var_21_0:getCoopSkillId()
	end
	
	local var_21_5 = DB("skillact", DB("skill", var_21_4, "skillact"), var_21_3 or "action") or var_21_1:getBoneNode("arrow_start") and "def_range_attack" or "def_melee_attack"
	local var_21_6 = {
		a_unit = var_21_0,
		d_unit = var_21_2,
		d_units = arg_21_0.worldboss,
		d_unit_target = math.random(0, (var_21_2.max_target_count or 1) - 1)
	}
	
	WorldBoss:setAttackInfo(var_21_0, var_21_6)
	
	local var_21_7 = {
		idx = 1,
		id = var_21_4,
		skill_id = var_21_4,
		unit = var_21_0,
		units = {
			friends = arg_21_0.raidparty,
			enemies = arg_21_0.worldboss
		},
		att_info = var_21_6
	}
	
	arg_21_0.skill_actor_list[var_21_1] = var_21_7
	
	ShakeManager:setShakeLevel(0.1)
	
	if arg_21_1.is_critical then
		SoundEngine:play("event:/voc/skill/" .. var_21_5)
	end
	
	local var_21_8, var_21_9 = StageStateManager:executeStateDoc(var_21_5, "start", var_21_7)
	
	if var_21_8 then
		local var_21_10 = arg_21_1.is_critical and {
			"DARK"
		} or {
			"DARK",
			"CAM",
			"ZOOM",
			"BGSHOW",
			"LAYOUT"
		}
		
		var_21_8:setActionFilters(var_21_10)
		var_21_8:setValue("zorder_by_y", true)
		var_21_8:setCallback({
			onDestroy = function()
				if WorldBoss:isSkip() then
					return 
				end
				
				if arg_21_0.skill_actor_list then
					arg_21_0.skill_actor_list[var_21_8:getActor()] = nil
				end
				
				WorldBossBattleUI:update(arg_21_1)
			end,
			onFinish = function()
				if WorldBoss:isSkip() then
					return 
				end
				
				if arg_21_0.ready_for_nextseq then
					ShakeManager:resetDefault()
					
					arg_21_0.is_battle_finish = true
					
					local var_23_0 = WorldBoss:isLastSequence() and 0 or 500
					
					BattleAction:Add(SEQ(DELAY(var_23_0), CALL(WorldBoss.FSM.changeState, WorldBoss.FSM, WorldBossState.SEQUENCER, {})), var_21_2.model, "worldboss")
				end
			end
		})
		StageStateManager:releaseStateCache(var_21_5)
	end
end
WorldBoss.FSM.STATES[WorldBossState.SUPPORTER] = {}
WorldBoss.FSM.STATES[WorldBossState.SUPPORTER].onEnter = function(arg_24_0, arg_24_1)
	arg_24_0.action_started = false
	arg_24_0.worldboss = WorldBoss:getWorldBoss()[1]
	arg_24_0.supporter = {}
	
	for iter_24_0, iter_24_1 in pairs(WorldBoss:getRaidParty()) do
		if iter_24_1.party == 4 then
			table.insert(arg_24_0.supporter, iter_24_1)
		end
	end
	
	local var_24_0 = SceneManager:getRunningNativeScene()
	
	if not get_cocos_refid(var_24_0) then
		return 
	end
	
	arg_24_0.dlg = load_dlg("clan_worldboss_battle_supporter", true, "wnd")
	
	if not get_cocos_refid(arg_24_0.dlg) then
		return 
	end
	
	var_24_0:addChild(arg_24_0.dlg)
	
	arg_24_0.bg = arg_24_0.dlg:findChildByName("bg")
	arg_24_0.bg_origin_x, arg_24_0.bg_origin_y = arg_24_0.bg:getPosition()
	arg_24_0.move_step = arg_24_0.bg:getContentSize().width
	
	arg_24_0.bg:setPosition(arg_24_0.bg_origin_x + arg_24_0.move_step, arg_24_0.bg_origin_y)
	
	arg_24_0.info = arg_24_0.dlg:findChildByName("n_info")
	arg_24_0.info_origin_x, arg_24_0.info_origin_y = arg_24_0.info:getPosition()
	
	arg_24_0.info:setPosition(arg_24_0.info_origin_x + arg_24_0.move_step, arg_24_0.info_origin_y)
	
	arg_24_0.port = arg_24_0.dlg:findChildByName("n_port")
	arg_24_0.port_origin_x, arg_24_0.port_origin_y = arg_24_0.port:getPosition()
	
	arg_24_0.port:setPosition(arg_24_0.port_origin_x + arg_24_0.move_step, arg_24_0.port_origin_y)
end
WorldBoss.FSM.STATES[WorldBossState.SUPPORTER].onUpdate = function(arg_25_0)
	if not arg_25_0.dlg then
		return 
	end
	
	if not arg_25_0.action_started then
		local var_25_0 = WorldBoss:getSupporterUserInfo() or {}
		local var_25_1 = var_25_0.name or temp
		local var_25_2 = var_25_0.level or 1
		
		if_set(arg_25_0.info, "t_supporter_name", var_25_1)
		UIUtil:setLevelDetail(arg_25_0.dlg, var_25_2, GAME_STATIC_VARIABLE.max_account_level, {
			hide_max = true
		})
		
		local var_25_3 = arg_25_0.info:findChildByName("n_lv_num")
		
		var_25_3:setPositionX(var_25_3:getPositionX() + 50)
		
		local var_25_4, var_25_5 = UIUtil:getPortraitAniByLeaderCode(var_25_0.leader_code, {
			pin_sprite_position_y = true,
			parent_pos_y = arg_25_0.port:getPositionY()
		})
		
		var_25_4:setAnchorPoint(0.5, 0.5)
		
		if var_25_5 then
			var_25_4:setPositionY(-350)
		else
			var_25_4:setScaleX(-0.6)
			var_25_4:setScaleY(0.6)
			
			local var_25_6 = var_25_4:getContentSize()
			
			var_25_4:setPositionY(var_25_6.height / 2 * 0.3)
		end
		
		arg_25_0.port:addChild(var_25_4)
		
		local var_25_7 = 1
		
		BattleAction:Add(SPAWN(COND_LOOP(SEQ(CALL(function()
			local var_26_0 = arg_25_0.supporter[var_25_7]
			
			if var_26_0 and get_cocos_refid(var_26_0.model) then
				local var_26_1 = var_26_0.model:getBoneNode("root")
				local var_26_2 = var_26_1:getPositionX()
				local var_26_3 = var_26_1:getPositionY()
				local var_26_4 = SceneManager:convertToSceneSpace(var_26_0.model, {
					x = var_26_2,
					y = var_26_3
				})
				local var_26_5 = EffectManager:Play({
					fn = "ui_wb_suppot_eff.cfx",
					layer = WorldBoss.root_layer
				})
				
				var_26_5:setPosition(var_26_4.x, var_26_4.y)
				var_26_5:setScaleX(0.4)
				var_26_5:setScaleY(0.4)
			end
		end), DELAY(240), CALL(function()
			local var_27_0 = arg_25_0.supporter[var_25_7]
			
			if var_27_0 and get_cocos_refid(var_27_0.model) then
				var_27_0.model:setVisible(true)
			end
			
			var_25_7 = var_25_7 + 1
		end), DELAY(100)), function()
			return var_25_7 > table.count(arg_25_0.supporter)
		end)), arg_25_0.worldboss.model, "worldboss")
		SoundEngine:play("event:/ui/worldboss_suppot")
		UIAction:Add(SEQ(LOG(MOVE_TO(50, arg_25_0.bg_origin_x, arg_25_0.bg_origin_y), 500), DELAY(1150), RLOG(MOVE_TO(300, arg_25_0.bg_origin_x + arg_25_0.move_step, arg_25_0.bg_origin_y), 3000)), arg_25_0.bg, "worldboss")
		UIAction:Add(SEQ(LOG(MOVE_TO(100, arg_25_0.port_origin_x, arg_25_0.port_origin_y), 500), DELAY(1100), RLOG(MOVE_TO(300, arg_25_0.port_origin_x + arg_25_0.move_step, arg_25_0.port_origin_y), 3000)), arg_25_0.port, "worldboss")
		UIAction:Add(SEQ(LOG(MOVE_TO(150, arg_25_0.info_origin_x, arg_25_0.info_origin_y), 500), DELAY(1050), RLOG(MOVE_TO(300, arg_25_0.info_origin_x + arg_25_0.move_step, arg_25_0.info_origin_y), 3000), CALL(function()
			arg_25_0.dlg:setVisible(false)
			WorldBoss.FSM:changeState(WorldBossState.SEQUENCER, {})
		end)), arg_25_0.info, "worldboss")
		
		arg_25_0.action_started = true
	end
end
WorldBoss.FSM.STATES[WorldBossState.SUPPORTER].onExit = function(arg_30_0)
end
WorldBoss.FSM.STATES[WorldBossState.END] = {}
WorldBoss.FSM.STATES[WorldBossState.END].onEnter = function(arg_31_0, arg_31_1)
	if not WorldBoss.params then
		return 
	end
	
	if not WorldBoss.vars or not WorldBoss.vars.raidparty then
		return 
	end
	
	vibrate(VIBRATION_TYPE.Default)
	WorldBossBattleResult:show(WorldBoss.params, WorldBoss.vars.raidparty)
end
WorldBoss.FSM.STATES[WorldBossState.END].onExit = function(arg_32_0)
end

function WorldBoss.load(arg_33_0, arg_33_1)
	arg_33_0.params = arg_33_1
	arg_33_0.vars = {}
	arg_33_0.vars.sequence = {}
	arg_33_0.vars.sequence_index = 0
	arg_33_0.vars.sequence_max = 0
	arg_33_0.vars.battle_finish = false
	arg_33_0.vars.worldboss = {}
	arg_33_0.vars.raidparty = {}
	arg_33_0.vars.supporter_user_info = arg_33_1.supporter_userInfo
	arg_33_0.vars.skip_sequence = false
	arg_33_0.vars.has_supporter_action = false
	arg_33_0.vars.after_supporter_action = false
	
	SpriteCache:loadCache()
	StageStateManager:reset()
	CameraManager:resetDefault()
	BattleLayout:init()
	
	local var_33_0 = DB("clan_worldboss", arg_33_1.boss_id, "bg")
	
	arg_33_0.root_layer = BattleField:create()
	
	BattleField:addTestField(var_33_0 or "pars8", DESIGN_WIDTH * 4)
	arg_33_0.root_layer:ejectFromParent()
	arg_33_0:makeBattleLayout(arg_33_1)
	arg_33_0:makeSequence(arg_33_1)
	BattleField:getUILayer():removeAllChildren()
	WorldBossBattleUI:load(arg_33_0.vars.worldboss, arg_33_0.vars.raidparty, arg_33_1.season_data)
	WorldBossBattleUI:setVisible(false)
	Analytics:setMode("world_boss")
	
	return arg_33_0.root_layer
end

function WorldBoss.begin(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	SoundEngine:playBGM("event:/bgm/worldboss_battle")
	arg_34_0.FSM:changeState(WorldBossState.SEQUENCER, {})
end

function WorldBoss.update(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	arg_35_0.FSM:update()
end

function WorldBoss.unload(arg_36_0)
	SAVE:sendQueryServerConfig()
	WorldBossBattleUI:unload()
	BattleLayout:removeTeamLayout(ENEMY)
	BattleLayout:removeTeamLayout(FRIEND)
	BattleField:clear()
	BattleAction:Remove("worldboss")
	BattleUIAction:Remove("worldboss")
	UIAction:Remove("worldboss")
	StageStateManager:reset()
	CameraManager:resetDefault()
	ShakeManager:resetDefault()
	
	if arg_36_0.vars then
		arg_36_0.vars.raidparty = nil
		arg_36_0.vars.worldboss = nil
		arg_36_0.vars.sequence = nil
		arg_36_0.vars = nil
	end
end

function WorldBoss.setAttackInfo(arg_37_0, arg_37_1, arg_37_2)
	arg_37_0.att_info = arg_37_2
	
	if not arg_37_0.att_info_map then
		arg_37_0.att_info_map = {}
	end
	
	arg_37_0.att_info_map[arg_37_1] = arg_37_2
end

function WorldBoss.getAttackInfo(arg_38_0, arg_38_1)
	if not arg_38_1 or not arg_38_0.att_info_map then
		return 
	end
	
	return arg_38_0.att_info_map[arg_38_1]
end

function WorldBoss.onAniEvent(arg_39_0, arg_39_1)
	if arg_39_0.vars.skip_sequence then
		return 
	end
	
	EffectManager:onAniEvent(arg_39_1)
	StageStateManager:onAniEvent(arg_39_1)
end

function WorldBoss.onEvent(arg_40_0, arg_40_1, arg_40_2, ...)
	if arg_40_0.vars.skip_sequence then
		return 
	end
	
	local var_40_0 = {
		...
	}
	
	if arg_40_2.sender == "state.hit" then
		arg_40_0:onHit(arg_40_2)
		
		return 
	end
	
	if arg_40_2.sender == "state.fire" then
		print("FIRE!!!")
		
		return 
	end
end

function WorldBoss.onHit(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1.unit
	local var_41_1 = arg_41_0:getAttackInfo(var_41_0)
	local var_41_2 = arg_41_1.info
	
	if not var_41_1 then
		return 
	end
	
	if not var_41_2.effect then
		return 
	end
	
	local function var_41_3(arg_42_0)
		local var_42_0 = false
		local var_42_1 = 0
		local var_42_2 = 0
		local var_42_3 = 0
		
		if not get_cocos_refid(arg_42_0.model) then
			return 
		end
		
		local var_42_4 = var_41_2.offset_x or 0
		local var_42_5 = var_41_2.offset_y or 0
		local var_42_6 = not (var_41_1.d_unit_target ~= 0 and var_41_1.d_unit_target ~= nil) and "" or var_41_1.d_unit_target
		
		if var_41_2.attach_self then
			if var_41_0 and get_cocos_refid(var_41_0.model) then
				local var_42_7 = "hit" .. var_42_6
				
				var_42_1, var_42_2 = var_41_0.model:getBonePosition(var_42_7)
				
				if not var_41_2.ignore_flip_x and var_41_0.model:getScaleX() < 0 then
					var_42_0 = true
				end
			end
		elseif arg_42_0 and get_cocos_refid(arg_42_0.model) then
			local var_42_8 = "target" .. var_42_6
			
			var_42_1, var_42_2 = arg_42_0.model:getBonePosition(var_42_8)
			
			if not var_41_2.ignore_flip_x and arg_42_0.model:getScaleX() > 0 then
				var_42_0 = true
			end
		end
		
		if var_42_0 then
			var_42_4 = -var_42_4
		end
		
		local var_42_9 = arg_42_0.model:getLocalZOrder() + 1
		local var_42_10 = (var_41_2.rand_x or 0) * 0.5
		local var_42_11 = (var_41_2.rand_y or 0) * 0.5
		local var_42_12 = var_42_10 * 100
		local var_42_13 = var_42_11 * 100
		local var_42_14 = var_42_1 + var_42_4 + math.random(-var_42_12, var_42_12) / 100
		local var_42_15 = var_42_2 + var_42_5 + math.random(-var_42_13, var_42_13) / 100
		local var_42_16 = (var_41_2.scale or 1) * 0.5 + math.random() * (var_41_2.rand_scale or 0)
		local var_42_17 = BGI.main.layer:getFrontLayer()
		
		EffectManager:Play({
			is_battle_effect = true,
			fn = var_41_2.effect,
			layer = var_42_17,
			pivot_x = var_42_14,
			pivot_y = var_42_15,
			pivot_z = var_42_9,
			scale = var_42_16,
			flip_x = var_42_0,
			action = BattleAction
		})
		BattleAction:Finish("battle.damage_motion" .. arg_42_0.inst.pos)
		BattleAction:Add(SEQ(DMOTION(500, "attacked", false), DELAY(60), Battle:getIdleAction(arg_42_0)), arg_42_0.model, "battle.damage_motion" .. arg_42_0.inst.pos)
	end
	
	for iter_41_0, iter_41_1 in pairs(var_41_1.d_units) do
		var_41_3(iter_41_1)
	end
end

function WorldBoss.makeBattleLayout(arg_43_0, arg_43_1)
	if not arg_43_0.vars then
		return 
	end
	
	local var_43_0 = BGI.main.layer
	local var_43_1 = arg_43_1.unit_info
	
	local function var_43_2(arg_44_0)
		if not string.find(arg_44_0, "/") then
			return "spani/" .. arg_44_0
		end
		
		return arg_44_0
	end
	
	local function var_43_3(arg_45_0, arg_45_1)
		arg_45_0 = arg_45_0 or {}
		
		local var_45_0 = {}
		
		for iter_45_0, iter_45_1 in pairs(arg_45_0) do
			local var_45_1 = iter_45_1.unit
			
			if not var_45_1 then
				var_45_1 = Account:getUnit(iter_45_1.uid)
				
				if not var_45_1 and iter_45_1.id then
					var_45_1 = UNIT:create({
						exp = 0,
						lv = 1,
						code = iter_45_1.id,
						skin_code = iter_45_1.skin_code
					})
				end
			end
			
			if var_45_1 then
				var_45_1.inst.show = false
				var_45_1.inst.pos = iter_45_1.pos or 1
				var_45_1.inst.ally = arg_45_1
				var_45_1.inst.ani_id = iter_45_1.ani or "idle"
				var_45_1.totatt_dmg = iter_45_1.power
				var_45_1.curatt_dmg = 0
				var_45_1.party = iter_45_1.party or 1
				
				var_45_1:reset()
				table.insert(var_45_0, var_45_1)
			end
		end
		
		return var_45_0
	end
	
	local function var_43_4(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
		if not arg_46_0 or table.count(arg_46_0) == 0 then
			return 
		end
		
		local var_46_0 = WorldBossLayout:build(arg_46_0, arg_46_1, arg_46_3)
		
		if not var_46_0 then
			return 
		end
		
		for iter_46_0 = 1, table.count(arg_46_0) do
			local var_46_1 = arg_46_0[iter_46_0]
			
			if not get_cocos_refid(var_46_1.model) then
				local var_46_2 = var_46_1.db.model_id
				local var_46_3 = var_46_1.db.skin
				local var_46_4 = var_46_1.db.atlas
				
				if var_46_2 then
					local var_46_5 = CACHE:getModel(var_46_2, var_46_3, var_46_1.inst.ani_id, var_46_4)
					
					if var_46_1.db and var_46_1.db.model_opt then
						var_46_5:loadOption("model/" .. var_46_1.db.model_opt)
					end
					
					var_46_1.model = var_46_5
					
					var_46_1.model:setLuaTag({
						unit = var_46_1
					})
					var_46_5:createShadow(var_43_0)
					var_46_5:loadTexture()
					
					if not arg_46_3 then
						var_46_5.sound_rate = 0.3
					end
				end
			end
			
			if get_cocos_refid(var_46_1.model) then
				var_46_1.model:ejectFromParent()
				var_46_1.model:resetTimeline()
				var_46_1.model:setVisible(true)
				
				if var_46_1.party == 4 and arg_43_0.vars.supporter_user_info then
					var_46_1.model:setVisible(false)
				end
				
				if arg_46_2 then
					local var_46_6 = tonumber(string.sub(arg_46_2, 1, 2), 16)
					local var_46_7 = tonumber(string.sub(arg_46_2, 3, 4), 16)
					local var_46_8 = tonumber(string.sub(arg_46_2, 5, 6), 16)
					local var_46_9 = cc.c3b(var_46_6, var_46_7, var_46_8)
					
					var_46_1.model:setColor(var_46_9)
				end
				
				var_43_0:addChild(var_46_1.model)
			end
		end
		
		return arg_46_0, var_46_0
	end
	
	local function var_43_5(arg_47_0)
		local var_47_0 = arg_47_0.model
		
		if not get_cocos_refid(var_47_0) then
			return 
		end
		
		local var_47_1 = 0
		
		for iter_47_0 = 0, 10 do
			if iter_47_0 == 0 then
				iter_47_0 = ""
			end
			
			local var_47_2 = var_47_0:getBoneNode("target" .. iter_47_0)
			
			if not get_cocos_refid(var_47_2) then
				arg_47_0.max_target_count = var_47_1
				
				return 
			end
			
			var_47_1 = var_47_1 + 1
		end
	end
	
	for iter_43_0, iter_43_1 in pairs(var_43_0:getChildren()) do
		iter_43_1:removeFromParent()
	end
	
	local var_43_6 = arg_43_1.boss_id or "wb1"
	local var_43_7, var_43_8, var_43_9 = DB("clan_worldboss", var_43_6, {
		"char_id",
		"ambient_color",
		"direction"
	})
	local var_43_10 = {
		{
			id = var_43_7
		}
	}
	local var_43_11 = {}
	
	for iter_43_2, iter_43_3 in pairs(var_43_1) do
		local var_43_12 = (iter_43_3.party - 1) * 4 + iter_43_3.pos
		
		if var_43_12 < 13 then
			table.insert(var_43_11, {
				uid = iter_43_2,
				id = iter_43_3.code,
				power = iter_43_3.power,
				pos = var_43_12,
				party = iter_43_3.party,
				skin_code = iter_43_3.skin_code
			})
		end
	end
	
	if arg_43_1.supporter_unit_info then
		for iter_43_4, iter_43_5 in pairs(arg_43_1.supporter_unit_info) do
			local var_43_13 = (iter_43_5.party - 1) * 4 + iter_43_5.pos
			
			if var_43_13 > 12 then
				table.insert(var_43_11, {
					uid = iter_43_4,
					id = iter_43_5.code,
					power = iter_43_5.power,
					pos = var_43_13,
					party = iter_43_5.party,
					skin_code = iter_43_5.skin_code
				})
			end
		end
	end
	
	BattleLayout:setDirection(var_43_9 or 1)
	
	local var_43_14 = var_43_3(var_43_10, FRIEND)
	local var_43_15 = var_43_3(var_43_11, ENEMY)
	local var_43_16 = var_43_7 .. "_party_pos.scsp"
	local var_43_17 = var_43_2(var_43_16)
	local var_43_18 = var_43_7 .. "_boss_pos.scsp"
	local var_43_19 = var_43_2(var_43_18)
	local var_43_20
	local var_43_21
	local var_43_22
	
	arg_43_0.vars.worldboss, var_43_22 = var_43_4(var_43_14, var_43_19, var_43_8, true)
	
	local var_43_23
	
	arg_43_0.vars.raidparty, var_43_23 = var_43_4(var_43_15, var_43_17, var_43_8)
	
	if not arg_43_0.vars.raidparty then
		return 
	end
	
	if not arg_43_0.vars.worldboss then
		return 
	end
	
	BattleLayout:addWorldBossLayoutData(var_43_22, FRIEND):setDirection(1)
	BattleLayout:addWorldBossLayoutData(var_43_23, ENEMY):setDirection(-1)
	
	if var_43_9 < 0 then
		BattleLayout:setFieldPosition(DESIGN_WIDTH - BATTLE_LAYOUT.XDIST_FROM_SIDE)
	else
		BattleLayout:setFieldPosition(BATTLE_LAYOUT.XDIST_FROM_SIDE)
	end
	
	BattleLayout:updatePose()
	BattleLayout:updateModelPose()
	var_43_5(var_43_14[1])
end

function WorldBoss.makeSequence(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_1.boss_id
	local var_48_1 = arg_48_0.vars.raidparty
	local var_48_2 = 0.05
	
	local function var_48_3()
		local var_49_0 = 0
		
		for iter_49_0, iter_49_1 in pairs(var_48_1) do
			var_49_0 = var_49_0 + (iter_49_1.totatt_dmg or 0)
		end
		
		return var_49_0
	end
	
	local function var_48_4(arg_50_0, arg_50_1)
		local var_50_0 = {}
		local var_50_1 = var_48_3()
		
		for iter_50_0, iter_50_1 in pairs(var_48_1) do
			local var_50_2 = (iter_50_1.totatt_dmg or 0) / arg_50_0
			local var_50_3 = math.random(1, 2)
			local var_50_4 = arg_50_1 / var_50_3
			local var_50_5 = 1
			local var_50_6 = var_50_4
			local var_50_7 = {}
			local var_50_8 = math.random(2, 8)
			
			if var_50_3 > 1 then
				local var_50_9 = var_50_2 * var_50_8 / 10
				local var_50_10 = var_50_2 - var_50_9
				
				var_50_7 = {
					var_50_9,
					var_50_10
				}
			else
				var_50_7 = {
					var_50_2
				}
			end
			
			for iter_50_2 = 1, var_50_3 do
				local var_50_11 = var_50_7[iter_50_2]
				local var_50_12 = math.random(var_50_5, var_50_6)
				local var_50_13 = var_50_11 > var_50_1 * var_48_2
				
				table.insert(var_50_0, {
					unit_pos = iter_50_1.inst.pos,
					attack_phase = iter_50_2,
					attack_damage = var_50_11,
					attack_time = var_50_12,
					is_critical = var_50_13
				})
				
				var_50_5 = var_50_12 + var_50_4
				var_50_6 = arg_50_1
			end
		end
		
		table.sort(var_50_0, function(arg_51_0, arg_51_1)
			return arg_51_0.attack_time < arg_51_1.attack_time
		end)
		
		return var_50_0
	end
	
	local var_48_5 = {}
	
	for iter_48_0 = 1, 10 do
		table.insert(var_48_5, "sequence" .. iter_48_0)
	end
	
	local var_48_6 = 0
	local var_48_7 = DBT("clan_worldboss", var_48_0, var_48_5)
	
	for iter_48_1 = 1, 10 do
		local var_48_8 = var_48_7["sequence" .. iter_48_1]
		
		if var_48_8 and string.split(var_48_8, ";")[1] == "battle" then
			var_48_6 = var_48_6 + 1
		end
	end
	
	for iter_48_2 = 1, 10 do
		local var_48_9 = var_48_7["sequence" .. iter_48_2]
		
		if var_48_9 then
			local var_48_10 = string.split(var_48_9, ";")
			local var_48_11 = var_48_10[1]
			local var_48_12 = var_48_10[2]
			local var_48_13 = {
				type = var_48_11
			}
			
			if var_48_11 == "battle" then
				var_48_13.value = {
					battle_timeline = var_48_4(var_48_6, var_48_12 * 1000),
					total_play_tick = var_48_12 * 1000
				}
			else
				var_48_13.value = var_48_12
			end
			
			if var_48_11 == "supporter" and not arg_48_0.vars.supporter_user_info then
			else
				table.insert(arg_48_0.vars.sequence, var_48_13)
			end
		end
	end
	
	arg_48_0.vars.sequence_max = table.count(arg_48_0.vars.sequence)
end

function WorldBoss.getNextSequence(arg_52_0)
	local var_52_0 = arg_52_0.vars.sequence_index + 1
	local var_52_1 = arg_52_0.vars.sequence[var_52_0]
	
	arg_52_0.vars.sequence_index = var_52_0
	
	return var_52_1
end

function WorldBoss.isLastSequence(arg_53_0)
	return arg_53_0.vars.sequence_index == arg_53_0.vars.sequence_max
end

function WorldBoss.getRaidParty(arg_54_0)
	return arg_54_0.vars.raidparty
end

function WorldBoss.getWorldBoss(arg_55_0)
	return arg_55_0.vars.worldboss
end

function WorldBoss.getSupporterUserInfo(arg_56_0)
	return arg_56_0.vars.supporter_user_info
end

function WorldBoss.skip(arg_57_0)
	if arg_57_0.vars.skip_sequence then
		return 
	end
	
	if arg_57_0:isLastSequence() then
		return 
	end
	
	if arg_57_0.FSM:getCurrentState() ~= WorldBossState.BATTLE then
		return 
	end
	
	if WorldBoss.FSM.STATES[WorldBossState.BATTLE].is_battle_finish then
		return 
	end
	
	arg_57_0.vars.skip_sequence = true
	arg_57_0.vars.sequence_index = arg_57_0.vars.sequence_max - 1
	
	arg_57_0.FSM:changeState(WorldBossState.SEQUENCER, {
		delay_tm = 1000
	})
end

function WorldBoss.isSkip(arg_58_0)
	return arg_58_0.vars.skip_sequence
end

function WorldBoss.pause(arg_59_0)
	if not arg_59_0.FSM then
		return 
	end
	
	arg_59_0.FSM:pause()
end

function WorldBoss.resume(arg_60_0)
	if not arg_60_0.FSM then
		return 
	end
	
	arg_60_0.FSM:resume()
end

function WorldBoss.onTouchDown(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
end

function WorldBoss.onTouchUp(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
end

function WorldBoss.onTouchMove(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
end
