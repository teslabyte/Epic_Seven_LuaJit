CharPreviewViewer = {}

local function var_0_0(arg_1_0, ...)
	CACHE.models = {}
	
	local var_1_0 = CACHE:getModel(...)
	
	if CocosSchedulerManager:get("gacha") then
	end
	
	if arg_1_0.db and arg_1_0.db.model_opt then
		var_1_0:loadOption("model/" .. arg_1_0.db.model_opt)
	end
	
	return var_1_0
end

function make_renderer_test()
	CharPreviewViewer:MakeTeam({
		"c1109"
	}, FRIEND)
	CharPreviewViewer:MakeTeam({
		"c1002",
		"c1003",
		"c1005"
	}, ENEMY)
	CharPreviewViewer:MakeLayouts()
end

function test_preview_renderer()
	local var_3_0 = SceneManager:getDefaultLayer()
	
	CharPreviewViewer:Init(var_3_0)
end

function CharPreviewViewer.Init(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if get_cocos_refid(arg_4_0.layer) then
		arg_4_0.bg_layer:removeAllChildren()
		arg_4_0.unit_layer:removeAllChildren()
	else
		arg_4_0.layer = cc.Layer:create()
		arg_4_0.bg_layer = su.BatchedLayer:create()
		arg_4_0.unit_layer = su.BatchedLayer:create()
		
		arg_4_0.layer:addChild(arg_4_0.bg_layer, 0)
		arg_4_0.layer:addChild(arg_4_0.unit_layer, 1)
		arg_4_1:addChild(arg_4_0.layer)
	end
	
	arg_4_0:updateField(arg_4_2, arg_4_3)
	LuaEventDispatcher:removeEventListenerByKey("char_preview_renderer")
	LuaEventDispatcher:pauseSendEventToListenerByKey("spine.ani", "battle")
	LuaEventDispatcher:pauseSendEventToListenerByKey("battle.event", "battle")
	LuaEventDispatcher:addEventListener("spine.ani", LISTENER(CharPreviewViewer.onAniEvent), "char_preview_renderer")
	LuaEventDispatcher:addEventListener("battle.event", LISTENER(CharPreviewViewer.onEvent), "char_preview_renderer")
	
	arg_4_0.is_off_hit_eff = arg_4_4
	
	return arg_4_0.layer
end

function CharPreviewViewer.PreLoad(arg_5_0, arg_5_1)
	arg_5_0.preLoadField = {}
end

function CharPreviewViewer.Destroy(arg_6_0)
	if get_cocos_refid(arg_6_0.unit_layer) then
		arg_6_0.unit_layer:removeFromParent()
		
		arg_6_0.unit_layer = nil
	end
	
	if get_cocos_refid(arg_6_0.bg_layer) then
		arg_6_0.bg_layer:removeFromParent()
		
		arg_6_0.bg_layer = nil
	end
	
	if get_cocos_refid(arg_6_0.layer) then
		arg_6_0.layer:removeFromParent()
		
		arg_6_0.layer = nil
		
		BGIManager:removeBGI("cpv")
		BattleField:init("battle")
		
		if BGI and get_cocos_refid(BGI.game_layer) then
			BGI.game_layer:setVisible(true)
		end
	end
	
	LuaEventDispatcher:resumeSendEventToListenerByKey("spine.ani", "battle")
	LuaEventDispatcher:resumeSendEventToListenerByKey("battle.event", "battle")
	LuaEventDispatcher:removeEventListenerByKey("char_preview_renderer")
end

function CharPreviewViewer.isActive(arg_7_0)
	return get_cocos_refid(arg_7_0.layer)
end

function CharPreviewViewer.Unload(arg_8_0)
	LuaEventDispatcher:removeEventListenerByKey("char_preview_renderer")
end

function CharPreviewViewer.updateField(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = BattleField:create("cpv")
	
	BattleLayout:init()
	BattleLayout:setDirection(1)
	
	local var_9_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_9_1:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_9_0:addChild(var_9_1)
	var_9_1:setPositionX(VIEW_BASE_LEFT)
	BattleField:addTestField(arg_9_1, DESIGN_WIDTH * 4, arg_9_2, {
		additional_bgi_mode = "cpv"
	})
	
	arg_9_0.ui_layer = BattleField:getUILayer()
	
	arg_9_0.ui_layer:removeAllChildren()
	var_9_0:ejectFromParent()
	arg_9_0.bg_layer:addChild(var_9_0)
	
	if BGI and get_cocos_refid(BGI.game_layer) then
		BGI.game_layer:setVisible(false)
	end
	
	arg_9_0.fg_layer = BGIManager:getBGI().main.layer
	arg_9_0.reverse_direction = arg_9_2
	
	EffectManager.setDefaultLayer(BGIManager:getBGI().main.layer)
end

function CharPreviewViewer.MakeTeamForStory(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = {}
	
	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		arg_10_0:setUnit(iter_10_0, iter_10_1, {}, arg_10_2, var_10_0, arg_10_3[iter_10_0])
	end
	
	if arg_10_2 == FRIEND then
		arg_10_0.friend = var_10_0
	elseif arg_10_2 == ENEMY then
		arg_10_0.enemy = var_10_0
	end
end

function CharPreviewViewer.setUnit(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	if not arg_11_2 then
		return 
	end
	
	if arg_11_2 == "" then
		return 
	end
	
	local var_11_0 = UNIT:create({
		exp = 0,
		lv = 1,
		code = arg_11_2,
		skin_code = arg_11_6
	})
	
	var_11_0.inst.show = true
	var_11_0.inst.pos = arg_11_1
	var_11_0.inst.line = arg_11_1 > 3 and FRONT or BACK
	var_11_0.inst.ally = arg_11_4
	var_11_0.inst.ani_id = arg_11_3.ani
	
	table.insert(arg_11_5, var_11_0)
end

function CharPreviewViewer.MakeTeam(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		arg_12_0:setUnit(iter_12_0, iter_12_1, arg_12_1, arg_12_2, var_12_0, arg_12_3)
	end
	
	if arg_12_2 == FRIEND then
		arg_12_0.friend = var_12_0
	elseif arg_12_2 == ENEMY then
		arg_12_0.enemy = var_12_0
	end
end

function CharPreviewViewer.makeLayout(arg_13_0, arg_13_1, arg_13_2)
	for iter_13_0 = 1, #arg_13_2 do
		local var_13_0 = arg_13_2[iter_13_0]
		local var_13_1 = var_13_0.unit
		
		print("#layouts", #arg_13_2)
		
		if var_13_1 then
			if not get_cocos_refid(var_13_1.model) then
				local var_13_2 = var_13_1.db.model_id
				local var_13_3 = var_13_1.db.skin
				local var_13_4 = var_13_1.db.atlas
				
				if var_13_2 then
					local var_13_5 = var_0_0(var_13_1, var_13_2, var_13_3, var_13_1.inst.ani_id, var_13_4)
					
					var_13_1.model = var_13_5
					
					var_13_1.model:setLuaTag({
						unit = var_13_1
					})
					var_13_5:createShadow(arg_13_0.unit_layer)
					var_13_5:setScale(var_13_1.db.scale or 1)
					var_13_5:setVisible(var_13_1.inst.show)
					var_13_5:loadTexture()
					var_13_5:setPosition(var_13_0.x, var_13_0.y)
				end
			end
			
			if get_cocos_refid(var_13_1.model) then
				var_13_1.model:ejectFromParent()
				var_13_1.model:resetTimeline()
				arg_13_0.fg_layer:addChild(var_13_1.model)
				var_13_1.model:updateModelParent(arg_13_0.fg_layer)
			end
		end
	end
end

function CharPreviewViewer.getDirection(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1
	
	if arg_14_0.reverse_direction then
		var_14_0 = var_14_0 * -1
	end
	
	return var_14_0
end

function CharPreviewViewer.getOffsetPos(arg_15_0, arg_15_1)
	local var_15_0 = BattleLayout:getTeamDistance() * BattleLayout:getDirection()
	
	if arg_15_0:getDirection(arg_15_1) == -1 then
		return var_15_0
	end
	
	return 0
end

function CharPreviewViewer._makeAllyLayout(arg_16_0)
	if not arg_16_0.friend then
		return 
	end
	
	local var_16_0 = TeamLayout:build(arg_16_0.friend, true)
	local var_16_1 = BattleLayout:addTeamLayoutData(var_16_0, FRIEND)
	
	arg_16_0:makeLayout(arg_16_0.friend, var_16_0)
	
	local var_16_2 = 1
	
	var_16_1:setPosition(arg_16_0:getOffsetPos(var_16_2), 0)
	var_16_1:setInitPosition(arg_16_0:getOffsetPos(var_16_2), 0)
	var_16_1:setDirection(arg_16_0:getDirection(var_16_2))
end

function CharPreviewViewer._makeEnemyLayout(arg_17_0)
	if not arg_17_0.enemy then
		return 
	end
	
	local var_17_0 = TeamLayout:build(arg_17_0.enemy)
	local var_17_1 = BattleLayout:addTeamLayoutData(var_17_0, ENEMY)
	
	arg_17_0:makeLayout(arg_17_0.enemy, var_17_0)
	
	local var_17_2 = BattleLayout:addTeamLayoutData(var_17_0, ENEMY)
	
	var_17_2.ally = ENEMY
	
	local var_17_3 = -1
	
	var_17_2:setPosition(arg_17_0:getOffsetPos(var_17_3), 0)
	var_17_2:setInitPosition(arg_17_0:getOffsetPos(var_17_3), 0)
	var_17_2:setDirection(arg_17_0:getDirection(var_17_3))
end

function CharPreviewViewer.GetSkillInfo(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.friend[1]:getSkillBundle():slot(arg_18_1):getSkillId()
	local var_18_1 = 1
	local var_18_2 = {}
	local var_18_3, var_18_4, var_18_5, var_18_6, var_18_7, var_18_8, var_18_9, var_18_10 = UNIT.getSkillDB(var_18_1, var_18_0, {
		"name",
		"sk_icon",
		"turn_cool",
		"soul_gain",
		"point_gain",
		"point_require",
		"soul_req",
		"soulburn_skill"
	}, nil, nil)
	
	var_18_2.skill_id = var_18_0
	var_18_2.name = var_18_3
	var_18_2.sk_icon = var_18_4
	var_18_2.turn_cool = var_18_5
	var_18_2.soul_gain = var_18_6
	var_18_2.point_gain = var_18_7
	var_18_2.point_require = var_18_8
	var_18_2.soul_req = var_18_9
	var_18_2.soulburn_skill = var_18_10
	var_18_2.sk_description = TooltipUtil:getSkillTooltipText(var_18_0, var_18_1, nil, nil)
	
	return var_18_2
end

function CharPreviewViewer.getEnemyIndex(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.enemy) do
		if iter_19_1.inst.pos == arg_19_1 then
			return iter_19_0
		end
	end
	
	return nil
end

function CharPreviewViewer.getFriendIndex(arg_20_0, arg_20_1)
	for iter_20_0, iter_20_1 in pairs(arg_20_0.friend) do
		if iter_20_1.inst.pos == arg_20_1 then
			return iter_20_0
		end
	end
	
	return nil
end

function CharPreviewViewer.UseSkill(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_0:getFriendIndex(arg_21_3)
	local var_21_1 = arg_21_0.friend[var_21_0 or 1]
	local var_21_2 = var_21_1:getSkillBundle():slot(arg_21_1):getOriginSkillId()
	
	set_high_fps_tick()
	
	local var_21_3 = SEQ(CALL(CameraManager.resetReadyFocus, CameraManager), MOTION("idle", false), MOTION("idle", true), DELAY(500), DMOTION("b_idle_ready", false), MOTION("b_idle", true), DELAY(10))
	
	if arg_21_2 then
		var_21_3 = SEQ(CALL(CameraManager.resetReadyFocus, CameraManager))
	end
	
	local var_21_4 = {}
	local var_21_5
	
	if not arg_21_4 then
		for iter_21_0 = 1, #arg_21_0.enemy do
			if arg_21_0.enemy[iter_21_0] then
				var_21_5 = arg_21_0.enemy[iter_21_0]
				
				break
			end
		end
	else
		local var_21_6 = arg_21_0:getEnemyIndex(arg_21_4)
		
		if not var_21_6 then
			Log.e("Can't find d_unit. idx was ", arg_21_4)
			
			var_21_5 = arg_21_0.enemy[1]
		else
			var_21_5 = arg_21_0.enemy[var_21_6]
		end
	end
	
	local var_21_7 = table.shallow_clone(arg_21_0.enemy)
	
	if get_cocos_refid(var_21_1.model) then
		var_21_1.model:changeBodyTo()
		var_21_1.model:setAnimation(0, "b_idle", true)
	end
	
	arg_21_0.show_hit_effect = true
	
	local var_21_8 = to_n(DB("skill", var_21_2, "target"))
	
	if DB("skill", var_21_2, "deal_damage") ~= "y" then
		arg_21_0.show_hit_effect = false
	end
	
	arg_21_4 = arg_21_4 or 1
	
	if var_21_8 == 12 then
		var_21_7 = {
			arg_21_0.enemy[arg_21_0:getEnemyIndex(arg_21_4)]
		}
	elseif var_21_8 == 13 then
		var_21_7 = table.shallow_clone(arg_21_0.enemy)
	elseif var_21_8 == 14 then
		var_21_7 = table.shallow_clone(arg_21_0.enemy)
		
		for iter_21_1 = #var_21_7, 1, -1 do
			if var_21_7[iter_21_1].inst.line ~= var_21_5.inst.line then
				table.remove(var_21_7, iter_21_1)
			end
		end
	elseif var_21_8 == 3 then
		arg_21_0.show_hit_effect = false
		var_21_7 = table.shallow_clone(arg_21_0.friend)
	elseif var_21_8 == 2 or var_21_8 == 15 then
		arg_21_0.show_hit_effect = false
		var_21_7 = {
			arg_21_0.friend[1]
		}
		var_21_5 = arg_21_0.friend[1]
	elseif var_21_8 == 1 then
		arg_21_0.show_hit_effect = false
		var_21_7 = {
			arg_21_0.friend[1]
		}
		var_21_5 = arg_21_0.friend[1]
	end
	
	local var_21_9 = {
		a_unit = var_21_1,
		d_unit = var_21_5,
		d_units = var_21_7
	}
	local var_21_10 = {
		skill_id = var_21_2,
		unit = var_21_1,
		units = {
			friends = arg_21_0.friend,
			enemies = arg_21_0.enemy
		},
		att_info = var_21_9
	}
	
	arg_21_0:setAttackInfo(var_21_1, var_21_9)
	
	arg_21_0.hitCount = 0
	
	BattleAction:Add(SEQ(var_21_3, CALL(function()
		var_21_9.tick = GET_LAST_TICK()
		
		StageStateManager:start(var_21_2, var_21_10)
	end)), var_21_1.model, "battle.skill")
end

function CharPreviewViewer.Pause(arg_23_0, arg_23_1, arg_23_2)
	Action:Add(SEQ(DELAY(arg_23_1), CALL(function()
		BattleAction:Pause()
		
		if not arg_23_2 then
			local var_24_0 = arg_23_0.friend[1]
			
			if not get_cocos_refid(var_24_0.model) then
				return 
			end
			
			if var_24_0.model:getCurrent() then
				var_24_0.model:pauseAnimation()
			end
		end
	end)), {})
end

function CharPreviewViewer.Resume(arg_25_0)
	arg_25_0.friend[1].model:resumeAnimation()
	BattleAction:Resume()
end

function CharPreviewViewer.MakeLayouts(arg_26_0)
	arg_26_0.unit_layer:removeAllChildren()
	arg_26_0:_makeAllyLayout()
	arg_26_0:_makeEnemyLayout()
	BattleLayout:setFieldPosition(BATTLE_LAYOUT.XDIST_FROM_SIDE)
	BattleLayout:updatePose()
	BattleLayout:updateModelPose()
	CameraManager:update()
	BattleField:update()
end

function CharPreviewViewer.onAfterDraw(arg_27_0)
	if arg_27_0.layer and get_cocos_refid(arg_27_0.bg_layer) then
		CameraManager:update()
		BattleField:update()
	end
end

function CharPreviewViewer.getAttackInfo(arg_28_0, arg_28_1)
	if not arg_28_1 or not arg_28_0.att_info_map then
		return 
	end
	
	return arg_28_0.att_info_map[arg_28_1]
end

function CharPreviewViewer.setAttackInfo(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.att_info = arg_29_2
	
	if not arg_29_0.att_info_map then
		arg_29_0.att_info_map = {}
	end
	
	arg_29_0.att_info_map[arg_29_1] = arg_29_2
end

function CharPreviewViewer.onDoHit(arg_30_0, arg_30_1)
	arg_30_0.hitCount = (arg_30_0.hitCount or 0) + 1
	
	local var_30_0 = arg_30_1.unit
	local var_30_1 = arg_30_0:getAttackInfo(var_30_0)
	local var_30_2 = arg_30_0.show_hit_effect and not arg_30_0.is_off_hit_eff
	
	if var_30_1 and arg_30_0.show_hit_effect then
		for iter_30_0, iter_30_1 in pairs(var_30_1.d_units) do
			if not StageStateManager:hasStateActionFlagsByActor(var_30_0.model, "ignore_default_motion") then
				BattleAction:Finish("battle.damage_motion" .. iter_30_0)
				BattleAction:Add(SEQ(DMOTION(500, "attacked", false), DELAY(60), Battle:getIdleAction(iter_30_1)), iter_30_1.model, "battle.damage_motion" .. iter_30_0)
			end
		end
	else
		print("HIT!", arg_30_0.hitCount)
	end
	
	if var_30_2 then
		Battle:onFireEffect(var_30_1, {
			attacker = var_30_0,
			targets = var_30_1.d_units,
			eff_info = arg_30_1.info
		})
	end
end

function CharPreviewViewer.onEvent(arg_31_0, arg_31_1, ...)
	local var_31_0 = {
		...
	}
	
	if arg_31_1.sender == "state.hit" then
		CharPreviewViewer:onDoHit(arg_31_1)
		
		return 
	end
	
	if arg_31_1.sender == "state.fire" then
		do return  end
		
		CharPreviewViewer:onDoFire(arg_31_1)
		
		return 
	end
end

function CharPreviewViewer.onAniEvent(arg_32_0)
	EffectManager:onAniEvent(arg_32_0)
	StageStateManager:onAniEvent(arg_32_0)
end
