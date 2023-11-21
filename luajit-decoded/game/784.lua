RumbleSystem = {}

function MsgHandler.substory_rumble_clear(arg_1_0)
	if arg_1_0.substory_rumble then
		Account:setSubStoryRumble(arg_1_0.substory_rumble)
		RumbleSystem:resClear(arg_1_0.substory_rumble)
	end
end

local var_0_0 = -137
local var_0_1 = 362
local var_0_2 = 1
local var_0_3 = 40
local var_0_4 = 400
local var_0_5 = 0.92
local var_0_6 = 1.5
local var_0_7 = 1.2
local var_0_8 = 1.4
local var_0_9 = 1.8
local var_0_10 = 1
local var_0_11

function RumbleSystem.init(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {}
	arg_2_0.doAfterNextSceneLoaded = arg_2_1.doAfterNextSceneLoaded
	arg_2_0.vars = {}
	arg_2_0.vars.preview_layer = cc.Layer:create()
	
	arg_2_0.vars.preview_layer:setLocalZOrder(1000)
	
	arg_2_0.vars.ui_layer = cc.Layer:create()
	
	arg_2_0.vars.ui_layer:setLocalZOrder(999)
	
	arg_2_0.vars.field_ui_layer = cc.Layer:create()
	
	arg_2_0.vars.field_ui_layer:setLocalZOrder(998)
	
	arg_2_0.vars.layer = su.BatchedLayer:create()
	
	arg_2_0.vars.layer:setCascadeOpacityEnabled(true)
	arg_2_0.vars.layer:setAnchorPoint(0.5, 0.5)
	arg_2_0.vars.layer:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	arg_2_0.vars.layer:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	arg_2_0.vars.stage = 1
	arg_2_0.vars.bg = cc.Sprite:create("img/z_rumble_bg.png")
	
	arg_2_0.vars.bg:setAnchorPoint(0.5, 0)
	arg_2_0.vars.layer:addChild(arg_2_0.vars.bg)
	
	arg_2_0.vars.rumble_info = arg_2_1.rumble_info
	
	SceneManager:getRunningNativeScene():addChild(arg_2_0.vars.preview_layer)
	SceneManager:getRunningNativeScene():addChild(arg_2_0.vars.ui_layer)
	SceneManager:getRunningNativeScene():addChild(arg_2_0.vars.field_ui_layer)
	SceneManager:getRunningNativeScene():addChild(arg_2_0.vars.layer)
	RumbleBoard:init(arg_2_0.vars.layer, {
		pos = {
			x = -480,
			y = 34
		}
	})
	RumbleCamera:init({
		layers = {
			arg_2_0.vars.layer
		},
		scale = var_0_2,
		x = var_0_0,
		y = var_0_1
	})
	RumblePlayer:init()
	RumbleSynergy:init()
	RumbleUI:init(arg_2_0.vars.ui_layer)
	RumbleStat:init()
	TutorialGuide:startGuide("rumble_round1")
end

function RumbleSystem.onEnter(arg_3_0)
	var_0_11 = getenv("time_scale")
	var_0_8 = arg_3_0:getConfig("rumble_speed_battle") or 1.4
	var_0_9 = arg_3_0:getConfig("rumble_speed_battle2") or 1.8
	var_0_10 = arg_3_0:getConfig("rumble_speed_form") or 1
	
	arg_3_0:updateTimeScale()
end

function RumbleSystem.onLeave(arg_4_0)
	setenv("time_scale", var_0_11 or 1)
	
	var_0_11 = nil
	arg_4_0.vars = nil
	arg_4_0.config = nil
	
	RumbleSynergy:unload()
end

function RumbleSystem.onUnload(arg_5_0)
end

function RumbleSystem.onUpdate(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	RumbleCamera:update()
	
	if arg_6_0:isPaused() then
		return 
	end
	
	if arg_6_0.vars.in_battle then
		RumbleBoard:update(arg_6_1)
		arg_6_0:updateTimeLimit(arg_6_1)
	end
	
	if get_cocos_refid(arg_6_0.vars.field_ui_layer) then
		local var_6_0 = arg_6_0.vars.field_ui_layer:getChildren() or {}
		
		for iter_6_0, iter_6_1 in pairs(var_6_0) do
			if type(iter_6_1.update) == "function" then
				iter_6_1:update(arg_6_1)
			end
		end
	end
end

function RumbleSystem.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
end

function RumbleSystem.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars then
		return 
	end
	
	if arg_8_0:isInBattle() then
		return 
	end
	
	if UIAction:Find("block") then
		return 
	end
	
	local var_8_0 = arg_8_1:getLocation()
	local var_8_1 = arg_8_1:getStartLocation()
	local var_8_2 = var_8_0.x - var_8_1.x
	local var_8_3 = var_8_0.y - var_8_1.y
	
	if var_8_2 * var_8_2 + var_8_3 * var_8_3 > 100 then
		return 
	end
	
	local var_8_4 = RumbleCamera:screenPosToWorldPos(var_8_0)
	local var_8_5, var_8_6 = RumbleBoard:worldPosToTilePos(var_8_4.x, var_8_4.y)
	
	RumbleBoard:select(var_8_5, var_8_6)
end

function RumbleSystem.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end

function RumbleSystem.onWillEnterForeground(arg_10_0)
end

function RumbleSystem.getMainLayer(arg_11_0)
	return arg_11_0.vars and arg_11_0.vars.layer
end

function RumbleSystem.getUILayer(arg_12_0)
	return arg_12_0.vars and arg_12_0.vars.ui_layer
end

function RumbleSystem.getFieldUILayer(arg_13_0)
	return arg_13_0.vars and arg_13_0.vars.field_ui_layer
end

function RumbleSystem.isTimeScaleMode(arg_14_0)
	return arg_14_0.vars and arg_14_0.vars.is_time_scale_mode
end

function RumbleSystem.setTimeScaleMode(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	arg_15_0.vars.is_time_scale_mode = arg_15_1
	
	arg_15_0:updateTimeScale()
end

function RumbleSystem.updateTimeScale(arg_16_0)
	if not arg_16_0.vars then
		return 1
	end
	
	local var_16_0 = 1
	
	if arg_16_0:isInBattle() then
		if arg_16_0:isTimeScaleMode() then
			var_16_0 = var_0_9
		else
			var_16_0 = var_0_8
		end
	else
		var_16_0 = var_0_10
	end
	
	setenv("time_scale", var_16_0)
end

function RumbleSystem.updateTimeLimit(arg_17_0, arg_17_1)
	if not arg_17_0.vars then
		return 
	end
	
	if not arg_17_1 or arg_17_1 <= 0 then
		return 
	end
	
	arg_17_1 = arg_17_1 / var_0_8
	
	if arg_17_0.vars.time_limit > 0 then
		arg_17_0.vars.time_limit = arg_17_0.vars.time_limit - arg_17_1
		
		if arg_17_0.vars.time_limit <= 0 then
			arg_17_0.vars.time_limit = 0
			
			local var_17_0 = RumbleBoard:getUnits({
				team = 1,
				include_hide = true
			}) or {}
			
			for iter_17_0, iter_17_1 in pairs(var_17_0) do
				iter_17_1:getBuffList():clear()
				iter_17_1:damage({
					damage = 9999999
				})
			end
		end
		
		RumbleUI:setTimer(arg_17_0.vars.time_limit)
	end
end

function RumbleSystem.useUltimateSkill(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.vars or not arg_18_0.vars.in_battle then
		return 
	end
	
	local var_18_0 = arg_18_2.targets
	
	if not arg_18_1 or not var_18_0 or table.empty(var_18_0) then
		return 
	end
	
	RumbleCamera:focusOnUnit(arg_18_1)
	
	local var_18_1 = 200
	local var_18_2 = {}
	local var_18_3 = RumbleBoard:getUnits({
		include_hide = true,
		except_units = {
			arg_18_1
		}
	}) or {}
	
	for iter_18_0, iter_18_1 in pairs(var_18_3) do
		local var_18_4 = iter_18_1:getUnitNode()
		
		if get_cocos_refid(var_18_4) then
			table.insert(var_18_2, TARGET(var_18_4, FADE_OUT(var_18_1)))
		end
	end
	
	BattleAction:Add(SPAWN(table.unpack(var_18_2)), arg_18_0.vars.layer)
	BattleAction:Add(SHOW(false), arg_18_0.vars.field_ui_layer)
	BattleAction:Add(FADE_OUT(var_18_1), arg_18_0.vars.bg)
	arg_18_0.vars.preview_layer:removeAllChildren()
	
	if not arg_18_0.scheduler or arg_18_0.scheduler.removed then
		arg_18_0.scheduler = Scheduler:add(arg_18_0.vars.preview_layer, function()
			if CharPreviewViewer:isActive() then
				CameraManager:update()
				BattleField:update()
			end
		end)
	end
	
	local var_18_5 = arg_18_1:getModel()
	
	CharPreviewViewer:Init(arg_18_0.vars.preview_layer, nil, var_18_5:getScaleX() < 0)
	CharPreviewViewer:MakeTeamForStory({
		arg_18_1:getBaseCode()
	}, FRIEND, {})
	
	local var_18_6 = {}
	
	for iter_18_2, iter_18_3 in pairs(var_18_0) do
		table.insert(var_18_6, iter_18_3:getBaseCode())
		
		if #var_18_6 >= 6 then
			break
		end
	end
	
	CharPreviewViewer:MakeTeam(var_18_6, ENEMY)
	CharPreviewViewer:MakeLayouts()
	CharPreviewViewer:UseSkill(3, true)
	arg_18_0.vars.preview_layer:setVisible(false)
	BattleAction:Add(SEQ(DELAY(arg_18_2.delay or var_18_1), TARGET(arg_18_0.vars.layer, SHOW(false)), SHOW(true)), arg_18_0.vars.preview_layer)
	
	local var_18_7 = arg_18_0:isTimeScaleMode() and var_0_6 or var_0_7
	
	setenv("time_scale", var_18_7)
end

function RumbleSystem.resetFocus(arg_20_0, arg_20_1)
	if not CharPreviewViewer:isActive() then
		return 
	end
	
	arg_20_1 = arg_20_1 or {}
	
	CharPreviewViewer:Destroy()
	
	local var_20_0 = {}
	local var_20_1 = RumbleBoard:getUnits() or {}
	
	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		local var_20_2 = iter_20_1:getUnitNode()
		
		if get_cocos_refid(var_20_2) then
			local var_20_3 = var_20_2:getOpacity() / 255
			
			table.insert(var_20_0, TARGET(var_20_2, OPACITY(200, var_20_3, 1)))
		end
	end
	
	arg_20_0.vars.layer:setVisible(true)
	BattleAction:Add(SPAWN(table.unpack(var_20_0)), arg_20_0.vars.layer)
	BattleAction:Add(SEQ(DELAY(2000), CALL(RumbleSystem.unlockUlt, arg_20_0)), arg_20_0.vars.layer)
	BattleAction:Add(SHOW(true), arg_20_0.vars.field_ui_layer)
	BattleAction:Add(FADE_IN(200), arg_20_0.vars.bg)
	
	if arg_20_1.dim then
		local var_20_4 = cc.LayerColor:create(arg_20_1.dim)
		
		arg_20_0.vars.preview_layer:addChild(var_20_4)
		BattleAction:Add(SEQ(FADE_OUT(200), REMOVE()), var_20_4)
	end
	
	RumbleCamera:resetFocus()
	arg_20_0:updateTimeScale()
	arg_20_0:checkDeadUnit()
	arg_20_0:checkEndBattle()
end

function RumbleSystem.lockUlt(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	arg_21_0.vars.lock_ult = true
end

function RumbleSystem.unlockUlt(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	arg_22_0.vars.lock_ult = false
end

function RumbleSystem.isUltimateLocked(arg_23_0)
	return arg_23_0.vars and arg_23_0.vars.lock_ult
end

function RumbleSystem.isPaused(arg_24_0)
	return CharPreviewViewer:isActive() or RumbleResult:isOpen()
end

function RumbleSystem.spawnUnit(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if not arg_25_0.vars then
		return 
	end
	
	arg_25_2 = arg_25_2 or 1
	arg_25_3 = RumbleBoard:getPlacablePos(arg_25_3, arg_25_2)
	
	local var_25_0 = RumbleUnit(arg_25_1, {
		is_creature = true,
		team = arg_25_2
	})
	
	RumbleBoard:addUnit(var_25_0, arg_25_3)
end

function RumbleSystem.beginBattle(arg_26_0)
	if not arg_26_0.vars then
		return 
	end
	
	if arg_26_0.vars.in_battle then
		return 
	end
	
	if arg_26_0.vars.champion_info then
		for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.champion_info) do
			local var_26_0 = iter_26_1.y
			local var_26_1 = RumbleBoard:getTileMapWidth() - iter_26_1.x + 1
			local var_26_2 = RumbleUnit(iter_26_1.c, {
				team = 2,
				devote = iter_26_1.d
			})
			
			RumbleBoard:addUnit(var_26_2, {
				x = var_26_1,
				y = var_26_0
			})
		end
	else
		local var_26_3 = arg_26_0.vars.stage_info
		
		if not var_26_3 then
			local var_26_4 = {}
			
			for iter_26_2 = 1, 12 do
				table.insert(var_26_4, "enemy_" .. iter_26_2)
				table.insert(var_26_4, "enemy_" .. iter_26_2 .. "_position")
			end
			
			table.insert(var_26_4, "enemy_power_rate")
			table.insert(var_26_4, "clear_rumble_gold_val")
			table.insert(var_26_4, "announce_text")
			
			local var_26_5 = string.format("stage_%02d", arg_26_0:getStage())
			local var_26_6 = {}
			
			for iter_26_3 = 1, 9 do
				local var_26_7 = DBT("rumble_stage", var_26_5 .. "_" .. iter_26_3, var_26_4)
				
				if not var_26_7 or table.empty(var_26_7) then
					break
				end
				
				table.insert(var_26_6, var_26_7)
			end
			
			if table.empty(var_26_6) then
				Log.e("rumble.stage info not found", arg_26_0:getStage())
				
				return 
			end
			
			var_26_3 = var_26_6[arg_26_0:getRandom(1, #var_26_6)]
			arg_26_0.vars.stage_info = var_26_3
		end
		
		for iter_26_4 = 1, 12 do
			local var_26_8 = var_26_3["enemy_" .. iter_26_4]
			local var_26_9 = var_26_3["enemy_" .. iter_26_4 .. "_position"]
			
			if not var_26_8 or not var_26_9 then
				break
			end
			
			local var_26_10 = var_26_9:split(",")
			local var_26_11 = var_26_10[2] + 1
			local var_26_12 = var_26_10[1] * 2 + var_26_11 % 2
			local var_26_13 = RumbleUnit(var_26_8, {
				team = 2,
				power_rate = var_26_3.enemy_power_rate or 1
			})
			
			RumbleBoard:addUnit(var_26_13, {
				x = var_26_12,
				y = var_26_11
			})
		end
		
		if var_26_3.announce_text then
			arg_26_0:announce(T(var_26_3.announce_text))
		end
	end
	
	arg_26_0.vars.time_limit = arg_26_0:getConfig("rumble_limit_time") or 100
	arg_26_0.vars.time_limit = arg_26_0.vars.time_limit * 1000
	arg_26_0.vars.in_battle = true
	arg_26_0.vars.lock_ult = false
	
	RumbleSynergy:update(true)
	RumbleSynergy:update()
	RumbleUI:setEditMode(false)
	RumbleBoard:beginBattle()
	RumbleStat:reset()
	RumbleUI:update()
	RumbleCamera:moveTo(1000, var_0_3, var_0_4)
	RumbleCamera:scaleTo(1000, var_0_5)
	arg_26_0:playRoundEffect()
	UIAction:Add(SEQ(DELAY(1000), CALL(RumbleSystem.updateTimeScale, arg_26_0)), arg_26_0.vars.layer, "block")
end

function RumbleSystem.playRoundEffect(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.ui_layer) then
		return 
	end
	
	EffectManager:Play({
		fn = "ui_super_battle_vs_eff.cfx",
		layer = arg_27_0.vars.ui_layer,
		x = DESIGN_WIDTH * 0.5,
		y = DESIGN_HEIGHT * 0.5
	})
end

function RumbleSystem.setEditMode(arg_28_0)
	RumbleBoard:clear()
	
	local var_28_0 = RumblePlayer:getTeamUnits() or {}
	
	for iter_28_0, iter_28_1 in pairs(var_28_0) do
		iter_28_1:onBattleEnd()
		RumbleBoard:addUnit(iter_28_1, iter_28_1:getPosition())
	end
	
	RumbleUI:setEditMode(true)
	RumbleSynergy:update()
	RumbleUI:update()
	RumbleCamera:moveTo(1000, var_0_0, var_0_1)
	RumbleCamera:scaleTo(1000, var_0_2)
	
	if arg_28_0:getStage() == 2 then
		TutorialGuide:startGuide("rumble_round2")
	elseif arg_28_0:getStage() == 3 then
		TutorialGuide:startGuide("rumble_round3")
	end
end

function RumbleSystem.setChampionInfo(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.rumble_info
	
	if not var_29_0 then
		return 
	end
	
	local var_29_1 = var_29_0.unit_list
	
	if not var_29_1 then
		return 
	end
	
	arg_29_0.vars.champion_info = json.decode(var_29_1)
end

function RumbleSystem.isInBattle(arg_30_0)
	return arg_30_0.vars and arg_30_0.vars.in_battle
end

function RumbleSystem.getChampionInfo(arg_31_0)
	return arg_31_0.vars and arg_31_0.vars.champion_info
end

function RumbleSystem.checkDeadUnit(arg_32_0)
	if not arg_32_0.vars or not arg_32_0.vars.in_battle then
		return 
	end
	
	if arg_32_0:isPaused() then
		return 
	end
	
	local var_32_0 = RumbleBoard:getUnits() or {}
	
	for iter_32_0, iter_32_1 in ipairs(var_32_0) do
		if iter_32_1:getCurHp() <= 0 then
			iter_32_1:dead()
		end
	end
end

function RumbleSystem.checkEndBattle(arg_33_0)
	if not arg_33_0.vars or not arg_33_0.vars.in_battle then
		return 
	end
	
	if arg_33_0:isPaused() then
		return 
	end
	
	local var_33_0 = false
	local var_33_1 = false
	local var_33_2 = RumbleBoard:getUnits() or {}
	
	for iter_33_0, iter_33_1 in ipairs(var_33_2) do
		if iter_33_1:getTeam() == 1 and not iter_33_1:isDead() then
			var_33_0 = true
		elseif iter_33_1:getTeam() == 2 and not iter_33_1:isDead() then
			var_33_1 = true
		end
	end
	
	if not var_33_0 or not var_33_1 then
		local var_33_3 = var_33_0 and arg_33_0.onClearBattle or arg_33_0.onDefeatBattle
		
		UIAction:Add(SEQ(DELAY(400), CALL(var_33_3, arg_33_0)), arg_33_0.vars.ui_layer, "block")
		RumbleUnitPopup:close()
		RumbleSynergyPopup:close()
		
		arg_33_0.vars.in_battle = false
		
		arg_33_0:updateTimeScale()
	end
end

function RumbleSystem.announce(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.ui_layer) then
		return 
	end
	
	local var_34_0 = load_dlg("caution_flash_2", true, "wnd")
	
	var_34_0:setOpacity(0)
	arg_34_0.vars.ui_layer:addChild(var_34_0)
	var_34_0:getChildByName("txt"):setString(arg_34_1)
	UIAction:Add(SEQ(FADE_IN(200), DELAY(2000), FADE_OUT(200), REMOVE()), var_34_0, "rumble.caution")
end

function RumbleSystem.onClearBattle(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	local var_35_0 = 0
	
	if arg_35_0.vars.stage_info then
		var_35_0 = arg_35_0.vars.stage_info.clear_rumble_gold_val or 0
		
		local var_35_1 = to_n(RumbleSystem:getConfig("rumble_death_penalty"))
		local var_35_2 = 0
		local var_35_3 = RumblePlayer:getTeamUnits() or {}
		
		for iter_35_0, iter_35_1 in ipairs(var_35_3) do
			if iter_35_1:isDead() then
				var_35_2 = var_35_2 - var_35_0 * var_35_1
			else
				var_35_2 = var_35_2 + iter_35_1:getBonusGold()
			end
		end
		
		var_35_0 = var_35_0 + var_35_2
		arg_35_0.vars.stage_info = nil
	end
	
	local var_35_4 = arg_35_0.vars.ui_layer:getChildByName("n_result_eff")
	
	if get_cocos_refid(var_35_4) then
		var_35_4:setVisible(true)
		
		local var_35_5 = NONE()
		
		if arg_35_0:getStage() == arg_35_0:getConfig("rumble_final_round") then
			var_35_5 = CALL(RumbleSystem.onClearGame, arg_35_0)
		end
		
		local var_35_6 = NONE()
		
		if var_35_0 > 0 then
			var_35_6 = CALL(function()
				RumblePlayer:addGold(var_35_0)
				RumbleUI:update()
				RumbleSystem:announce(T("rumble_announce_01", {
					token = T(RumbleUtil:getTokenName()),
					val = var_35_0
				}))
			end)
		end
		
		local var_35_7 = var_35_4:getChildByName("n_win")
		
		var_35_7:setVisible(true)
		
		local var_35_8 = EffectManager:Play({
			fn = "stageclear_base_top",
			layer = var_35_7
		})
		
		var_35_8:setAnchorPoint(0.5, 0.5)
		SoundEngine:play("event:/effect/stageclear_base")
		var_35_4:setOpacity(0)
		UIAction:Add(SEQ(LOG(FADE_IN(500), 100), DELAY(1000), CALL(RumbleSystem.setEditMode, arg_35_0), var_35_5, LOG(FADE_OUT(500), 100), var_35_6), var_35_4, "block")
		UIAction:Add(SEQ(DELAY(2000), REMOVE()), var_35_8, "block")
	end
	
	arg_35_0.vars.stage = math.min(arg_35_0:getStage() + 1, arg_35_0:getConfig("rumble_final_round") or 20)
end

function RumbleSystem.onDefeatBattle(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.ui_layer) then
		return 
	end
	
	local var_37_0 = 0
	
	if arg_37_0.vars.stage_info then
		var_37_0 = arg_37_0.vars.stage_info.clear_rumble_gold_val or 0
		var_37_0 = math.ceil(var_37_0 * 0.5)
	end
	
	RumblePlayer:addLife(-1)
	
	local var_37_1 = arg_37_0.vars.ui_layer:getChildByName("n_result_eff")
	
	if get_cocos_refid(var_37_1) then
		var_37_1:setVisible(true)
		
		local var_37_2 = NONE()
		
		if RumblePlayer:getLife() <= 0 then
			var_37_2 = CALL(RumbleSystem.onGameOver, arg_37_0)
		end
		
		local var_37_3 = NONE()
		
		if var_37_0 > 0 then
			var_37_3 = CALL(function()
				RumblePlayer:addGold(var_37_0)
				RumbleUI:update()
				RumbleSystem:announce(T("rumble_announce_02", {
					token = T(RumbleUtil:getTokenName()),
					val = var_37_0
				}))
			end)
		end
		
		local var_37_4 = var_37_1:getChildByName("n_fail")
		
		var_37_4:setVisible(true)
		
		local var_37_5 = EffectManager:Play({
			fn = "ui_stagefailed",
			layer = var_37_4
		})
		
		var_37_5:setAnchorPoint(0.5, 0.5)
		SoundEngine:play("event:/effect/stageclear_fail")
		var_37_1:setOpacity(0)
		UIAction:Add(SEQ(LOG(FADE_IN(500), 100), DELAY(1000), CALL(RumbleSystem.setEditMode, arg_37_0), var_37_2, LOG(FADE_OUT(500), 100), var_37_3), var_37_1, "block")
		UIAction:Add(SEQ(DELAY(2000), REMOVE()), var_37_5, "block")
	end
end

function RumbleSystem.onClearGame(arg_39_0)
	if not arg_39_0.vars then
		return 
	end
	
	if arg_39_0:getChampionInfo() then
		arg_39_0:onWinChampion()
		
		return 
	end
	
	arg_39_0:setChampionInfo()
	
	local var_39_0 = false
	
	if not arg_39_0.vars.rumble_info or arg_39_0.vars.rumble_info.max_stage_count < arg_39_0:getStage() then
		var_39_0 = true
	end
	
	function arg_39_0.vars.on_res_clear()
		RumbleResult:showClear({
			first = var_39_0
		})
		ConditionContentsManager:dispatch("rumble.clear", {
			cleared_round = arg_39_0:getStage()
		})
		
		local var_40_0 = RumblePlayer:getTeamUnits()
		local var_40_1 = RumbleSynergy:getCurrentSynergy()
		
		if var_40_0 and var_40_1 then
			local var_40_2 = table.collect(var_40_0, function(arg_41_0, arg_41_1)
				return arg_41_1:getCode()
			end)
			local var_40_3 = table.collect(var_40_1, function(arg_42_0, arg_42_1)
				return RumbleSynergy:getSynergyLevel(arg_42_0)
			end)
			
			ConditionContentsManager:dispatch("rumble.allclear", {
				battle_units = var_40_2,
				battle_synergies = var_40_3
			})
		end
	end
	
	arg_39_0:reqClear(true, {
		champion = var_39_0,
		update_stage = var_39_0
	})
end

function RumbleSystem.onGameOver(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	function arg_43_0.vars.on_res_clear()
		RumbleResult:showDefeat({
			champion = arg_43_0:getChampionInfo() ~= nil
		})
		
		if arg_43_0:getChampionInfo() then
			ConditionContentsManager:dispatch("rumble.champion.end")
		else
			ConditionContentsManager:dispatch("rumble.clear", {
				cleared_round = arg_43_0:getStage() - 1
			})
		end
	end
	
	if not arg_43_0.vars.rumble_info or arg_43_0.vars.rumble_info.max_stage_count < arg_43_0:getStage() then
		arg_43_0:reqClear(false, {
			update_team = true,
			update_stage = true
		})
	else
		arg_43_0.vars.on_res_clear()
	end
end

function RumbleSystem.onWinChampion(arg_45_0)
	function arg_45_0.vars.on_res_clear()
		RumbleResult:showClear({
			champion = true
		})
		ConditionContentsManager:dispatch("rumble.champion.end")
		ConditionContentsManager:dispatch("rumble.champion.win")
	end
	
	arg_45_0:reqClear(false, {
		champion = true
	})
end

function RumbleSystem.reqClear(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = {
		substory_id = SubstoryManager:getInfoID() or "vfm3aa",
		inc_clear_count = arg_47_1
	}
	
	if arg_47_2.champion or arg_47_2.update_team then
		local var_47_1 = RumblePlayer:getTeamUnits()
		local var_47_2 = {}
		
		for iter_47_0, iter_47_1 in pairs(var_47_1) do
			local var_47_3 = {
				c = iter_47_1:getCode(),
				d = iter_47_1:getDevote()
			}
			
			if arg_47_2.champion then
				var_47_3.x = iter_47_1:getPlace().x
				var_47_3.y = iter_47_1:getPlace().y
			end
			
			table.insert(var_47_2, var_47_3)
		end
		
		var_47_0.unit_list = json.encode(var_47_2)
	end
	
	if arg_47_2.update_stage then
		var_47_0.max_stage_count = arg_47_0:getStage() - (arg_47_1 and 0 or 1)
	end
	
	query("substory_rumble_clear", var_47_0)
end

function RumbleSystem.resClear(arg_48_0, arg_48_1)
	if not arg_48_0.vars then
		return 
	end
	
	if type(arg_48_0.vars.on_res_clear) == "function" then
		arg_48_0.vars.on_res_clear()
		
		arg_48_0.vars.on_res_clear = nil
	end
end

function RumbleSystem.loadConfig(arg_49_0)
	arg_49_0.config = {}
	
	for iter_49_0 = 1, 99 do
		local var_49_0, var_49_1 = DBN("rumble_config", iter_49_0, {
			"key",
			"value"
		})
		
		if not var_49_0 then
			break
		end
		
		arg_49_0.config[var_49_0] = var_49_1
	end
end

function RumbleSystem.getConfig(arg_50_0, arg_50_1)
	if not arg_50_0.config then
		arg_50_0:loadConfig()
	end
	
	return arg_50_0.config[arg_50_1]
end

function RumbleSystem.getStage(arg_51_0)
	return arg_51_0.vars and arg_51_0.vars.stage or 1
end

function RumbleSystem.getRandom(arg_52_0, arg_52_1, arg_52_2)
	if not arg_52_0.random then
		arg_52_0.random = getRandom(systick())
	end
	
	return arg_52_0.random:get(arg_52_1, arg_52_2)
end

function RumbleSystem.isValid(arg_53_0)
	return arg_53_0.vars ~= nil
end

function RumbleSystem.close(arg_54_0)
	SceneManager:popScene(arg_54_0.doAfterNextSceneLoaded)
end

RumbleEsc = RumbleEsc or {}

function HANDLER.rumble_esc(arg_55_0, arg_55_1)
	if arg_55_1 == "btn_end_view" then
		RumbleEsc:close()
		RumbleEsc:giveUp()
		
		return 
	end
	
	if arg_55_1 == "btn_option" then
		RumbleEsc:close()
		UIOption:show({
			category = "game",
			layer = SceneManager:getRunningPopupScene(),
			close_callback = function()
				RumbleEsc:resumeBattle()
			end
		})
		UIOption:bringToFront()
		
		return 
	end
	
	if arg_55_1 == "btn_restart" then
		balloon_message_with_sound("ui_inbattle_esc_restart_error")
		
		return 
	end
	
	if arg_55_1 == "btn_close" or arg_55_1 == "btn_return" then
		RumbleEsc:resumeBattle()
		RumbleEsc:close()
		
		return 
	end
end

function RumbleEsc.open(arg_57_0)
	if get_cocos_refid(arg_57_0.wnd) then
		return 
	end
	
	if RumbleResult:isOpen() then
		return 
	end
	
	arg_57_0.wnd = load_dlg("inbattle_esc", true, "wnd", function()
		arg_57_0:resumeBattle()
		arg_57_0:close()
	end)
	
	arg_57_0.wnd:setName("rumble_esc")
	
	if not SceneManager:getRunningPopupScene():addChild(arg_57_0.wnd) then
		UIAction:Add(REMOVE(), arg_57_0.wnd, "worldboss")
		
		return 
	end
	
	local var_57_0 = arg_57_0.wnd:getChildByName("n_story")
	
	if_set_visible(var_57_0, nil, true)
	
	local var_57_1 = var_57_0:getChildByName("btn_end_view")
	
	if_set(var_57_1, "label", T("ui_inbattle_esc_giveup"))
	arg_57_0:pauseBattle()
end

function RumbleEsc.giveUp(arg_59_0)
	Dialog:msgBox(T("rumble_out"), {
		yesno = true,
		handler = function()
			arg_59_0:_giveUp()
		end,
		cancel_handler = function()
			arg_59_0:resumeBattle()
		end,
		yes_text = T("msg_close")
	})
end

function RumbleEsc._giveUp(arg_62_0)
	if RumbleSystem:getStage() > 1 then
		RumbleSystem:onGameOver()
	else
		RumbleSystem:close()
	end
	
	arg_62_0:resumeBattle()
end

function RumbleEsc.close(arg_63_0, arg_63_1)
	if not get_cocos_refid(arg_63_0.wnd) then
		return 
	end
	
	arg_63_1 = arg_63_1 or {}
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_63_0.wnd, "block")
	BackButtonManager:pop("rumble_esc")
	
	arg_63_0.wnd = nil
end

function RumbleEsc.isOpen(arg_64_0)
	if not get_cocos_refid(arg_64_0.wnd) then
		return 
	end
	
	return true
end

function RumbleEsc.setPausedBattleSound(arg_65_0, arg_65_1)
	SoundEngine:setPausedBus("bus:/character", arg_65_1)
	SoundEngine:setPausedBus("bus:/voice", arg_65_1)
end

function RumbleEsc.pauseBattle(arg_66_0)
	arg_66_0:setPausedBattleSound(true)
	pause()
end

function RumbleEsc.resumeBattle(arg_67_0)
	arg_67_0:setPausedBattleSound(false)
	resume()
end

RumbleResult = {}

function HANDLER.result_rumble(arg_68_0, arg_68_1)
	if arg_68_1 == "btn_back" then
		RumbleSystem:close()
	elseif arg_68_1 == "btn_go" then
		RumbleResult:close()
		RumbleUI:update()
	end
end

function RumbleResult.showClear(arg_69_0, arg_69_1)
	arg_69_1 = arg_69_1 or {}
	arg_69_0.wnd = load_dlg("result_rumble", true, "wnd")
	
	if_set(arg_69_0.wnd, "txt_final", RumbleSystem:getConfig("rumble_final_round"))
	
	if arg_69_1.champion then
		if_set(arg_69_0.wnd, "txt_info", T("rumble_end_desc_champion_win"))
		if_set_sprite(arg_69_0.wnd, "icon_rumble", "img/icon_menu_rumble.png")
		if_set_visible(arg_69_0.wnd, "icon_rumble", true)
		if_set_visible(arg_69_0.wnd, "txt_final", false)
	else
		local var_69_0 = RumbleSystem:getStage()
		
		if_set(arg_69_0.wnd, "txt_final", var_69_0)
		if_set(arg_69_0.wnd, "txt_info", T("rumble_end_desc_clear"))
	end
	
	if arg_69_1.first then
		TutorialGuide:startGuide("rumble_champion")
	end
	
	if_set_sprite(arg_69_0.wnd, "n_bg", "img/z_rumble_win.png")
	
	local var_69_1 = arg_69_1.first or arg_69_1.champion
	
	if_set_visible(arg_69_0.wnd, "n_btn1", var_69_1)
	if_set_visible(arg_69_0.wnd, "n_btn2", not var_69_1)
	
	local var_69_2 = RumblePlayer:getTeamUnits()
	local var_69_3 = {}
	
	for iter_69_0, iter_69_1 in pairs(var_69_2) do
		table.insert(var_69_3, {
			c = iter_69_1:getCode(),
			d = iter_69_1:getDevote()
		})
	end
	
	arg_69_0:setTeam(var_69_3)
	
	local var_69_4 = arg_69_0.wnd:getChildByName("n_eff")
	
	if get_cocos_refid(var_69_4) then
		EffectManager:Play({
			delay = 400,
			fn = "ui_rumble_clear_success.cfx",
			layer = var_69_4
		})
	end
	
	arg_69_0.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_69_0.wnd, "block")
	;(arg_69_1.layer or SceneManager:getRunningPopupScene()):addChild(arg_69_0.wnd)
end

function RumbleResult.showDefeat(arg_70_0, arg_70_1)
	arg_70_1 = arg_70_1 or {}
	arg_70_0.wnd = load_dlg("result_rumble", true, "wnd")
	
	if arg_70_1.champion then
		if_set(arg_70_0.wnd, "txt_info", T("rumble_end_desc_champion_lose"))
		if_set_sprite(arg_70_0.wnd, "icon_rumble", "img/icon_menu_rumble.png")
		if_set_visible(arg_70_0.wnd, "icon_rumble", true)
		if_set_visible(arg_70_0.wnd, "txt_final", false)
	else
		local var_70_0 = RumbleSystem:getStage()
		
		if_set(arg_70_0.wnd, "txt_final", var_70_0)
		if_set(arg_70_0.wnd, "txt_info", T("rumble_end_desc_fail"))
	end
	
	if_set_sprite(arg_70_0.wnd, "n_bg", "img/z_rumble_lose.png")
	if_set_visible(arg_70_0.wnd, "n_btn1", true)
	if_set_visible(arg_70_0.wnd, "n_btn2", false)
	
	local var_70_1 = {}
	local var_70_2 = RumbleSystem:getChampionInfo()
	
	if var_70_2 then
		for iter_70_0, iter_70_1 in pairs(var_70_2) do
			table.insert(var_70_1, {
				c = iter_70_1.c,
				d = iter_70_1.d
			})
		end
	else
		local var_70_3 = RumblePlayer:getTeamUnits()
		
		for iter_70_2, iter_70_3 in pairs(var_70_3) do
			table.insert(var_70_1, {
				c = iter_70_3:getCode(),
				d = iter_70_3:getDevote()
			})
		end
	end
	
	arg_70_0:setTeam(var_70_1)
	
	local var_70_4 = arg_70_0.wnd:getChildByName("n_eff")
	
	if get_cocos_refid(var_70_4) then
		EffectManager:Play({
			delay = 400,
			fn = "ui_rumble_clear_failed.cfx",
			layer = var_70_4
		})
	end
	
	arg_70_0.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_70_0.wnd, "block")
	;(arg_70_1.layer or SceneManager:getRunningPopupScene()):addChild(arg_70_0.wnd)
end

function RumbleResult.setTeam(arg_71_0, arg_71_1)
	if not get_cocos_refid(arg_71_0.wnd) then
		return 
	end
	
	if not arg_71_1 then
		return 
	end
	
	local function var_71_0(arg_72_0)
		local var_72_0 = math.ceil(#arg_71_1 / 2)
		
		if var_72_0 < arg_72_0 then
			return (arg_72_0 - var_72_0) * 2
		else
			return (var_72_0 - arg_72_0) * 2 + 1
		end
	end
	
	table.sort(arg_71_1, RumbleUtil.sortLineUp)
	
	local var_71_1 = #arg_71_1 % 2 == 1
	local var_71_2 = arg_71_0.wnd:getChildByName(var_71_1 and "n_odd" or "n_even")
	local var_71_3 = {}
	
	for iter_71_0 = 1, 8 do
		local var_71_4 = var_71_2:getChildByName("n_" .. iter_71_0)
		
		if not get_cocos_refid(var_71_4) then
			break
		end
		
		table.insert(var_71_3, var_71_4)
	end
	
	for iter_71_1, iter_71_2 in ipairs(arg_71_1) do
		local var_71_5 = var_71_3[var_71_0(iter_71_1)]
		
		if not var_71_5 then
			break
		end
		
		local var_71_6 = RumbleUtil:getHeroIcon(iter_71_2.c, {
			show_info = true,
			devote = RumbleUtil:getDevoteGrade(iter_71_2.c, iter_71_2.d)
		})
		
		var_71_5:addChild(var_71_6)
	end
	
	if_set_visible(arg_71_0.wnd, "n_odd", var_71_1)
	if_set_visible(arg_71_0.wnd, "n_even", not var_71_1)
end

function RumbleResult.isOpen(arg_73_0)
	return get_cocos_refid(arg_73_0.wnd)
end

function RumbleResult.close(arg_74_0)
	if not get_cocos_refid(arg_74_0.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_74_0.wnd, "block")
	
	arg_74_0.wnd = nil
end

RumbleCheat = {}

function RumbleCheat.skipStage(arg_75_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_75_0 = RumbleBoard:getUnits({
		team = 2,
		include_hide = true
	}) or {}
	
	for iter_75_0, iter_75_1 in pairs(var_75_0) do
		iter_75_1:getBuffList():clear()
		iter_75_1:damage({
			damage = 9999999
		})
	end
end

function RumbleCheat.healAll(arg_76_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_76_0 = RumbleBoard:getUnits({
		team = 1,
		include_hide = true
	}) or {}
	
	for iter_76_0, iter_76_1 in pairs(var_76_0) do
		iter_76_1:heal(1000000)
	end
end

function RumbleCheat.forceSchedule(arg_77_0, arg_77_1)
	if PRODUCTION_MODE then
		return 
	end
	
	RumbleCheat.schedule_id = arg_77_1
end

function RumbleCheat.forceAttackTimer(arg_78_0, arg_78_1)
	if PRODUCTION_MODE then
		return 
	end
	
	for iter_78_0, iter_78_1 in pairs(RumbleBoard.vars.units) do
		iter_78_1.vars.attack_tm = to_n(arg_78_1)
	end
end

function RumbleCheat.setTimeLimit(arg_79_0, arg_79_1)
	if PRODUCTION_MODE then
		return 
	end
	
	RumbleSystem.vars.time_limit = to_n(arg_79_1) * 1000 + 1
end

RC = RumbleCheat
RC.ss = RumbleCheat.skipStage
RC.ha = RumbleCheat.healAll
RC.fs = RumbleCheat.forceSchedule
RC.at = RumbleCheat.forceAttackTimer
RC.tl = RumbleCheat.setTimeLimit
