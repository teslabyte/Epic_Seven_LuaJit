TOOLS = {}

local var_0_0 = {
	Heal = 1,
	Attack = 0
}

function effecttool()
	SceneManager:nextScene("effecttool")
end

Scene.effecttool = Scene.effecttool or SceneHandler:create("effecttool", 1280, 720)
EffectTool = EffectTool or {}

function EFFECT_TOOL_FILED_X(arg_2_0)
	return arg_2_0 or EFFECT_TOOL_POS_X
end

function EFFECT_TOOL_FILED_Y(arg_3_0)
	return arg_3_0 or EFFECT_TOOL_POS_Y
end

function attach_combine_model(arg_4_0, arg_4_1)
	if not get_cocos_refid(arg_4_1) then
		return 
	end
	
	if arg_4_0.db and arg_4_0.db.code then
		for iter_4_0 = 1, 10 do
			local var_4_0, var_4_1, var_4_2, var_4_3, var_4_4, var_4_5, var_4_6, var_4_7 = DB("character_model_combine", string.format("%s#%d", arg_4_0.db.code, iter_4_0), {
				"combine_model_id",
				"combine_skin",
				"combine_atlas",
				"combine_model_opt",
				"combine_x",
				"combine_y",
				"combine_z",
				"combine_scale"
			})
			
			if var_4_0 then
				local var_4_8 = CACHE:getModel(var_4_0, var_4_1, "idle", var_4_2, var_4_3)
				
				if get_cocos_refid(var_4_8) then
					local var_4_9 = var_4_7 or 1
					local var_4_10 = to_n(var_4_4)
					local var_4_11 = to_n(var_4_5)
					local var_4_12 = var_4_6 or 0
					
					arg_4_1:attachRelatedModel(var_4_8, {
						offset_x = var_4_10,
						offset_y = var_4_11,
						offset_z = var_4_12,
						offset_scale = var_4_9
					})
				end
			end
		end
	end
end

local function var_0_1(arg_5_0, ...)
	CACHE.models = {}
	
	local var_5_0 = CACHE:getModel(...)
	
	if arg_5_0.db and arg_5_0.db.model_opt then
		var_5_0:loadOption("model/" .. arg_5_0.db.model_opt)
	end
	
	attach_combine_model(arg_5_0, var_5_0)
	
	return var_5_0
end

function Scene.effecttool.onLoad(arg_6_0)
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
	
	IS_TOOL_MODE_REF = (IS_TOOL_MODE_REF or 0) + 1
	IS_TOOL_MODE = true
	__STRICT = false
	
	print("IS_TOOL_MODE = true")
	ShaderManager:loadShader()
	arg_6_0:initKeyboard()
	EffectManager:init()
	
	EFFECT_TOOL_POS_X = DESIGN_WIDTH / 2
	EFFECT_TOOL_POS_Y = DESIGN_HEIGHT / 4
	EFFECT_TOOL_TOP_LAYER = cc.LayerColor:create(cc.c3b(0, 0, 0))
	EFFECT_TOOL_BG_LAYER = su.BatchedLayer:create()
	EFFECT_TOOL_GM_LAYER = su.BatchedLayer:create()
	EFFECT_TOOL_FX_LAYER = su.BatchedLayer:create()
	EFFECT_TOOL_PC_LAYER = su.BatchedLayer:create()
	EFFECT_TOOL_TM_LAYER = su.BatchedLayer:create()
	EFFECT_TOOL_OD_LAYER = su.BatchedLayer:create()
	
	EFFECT_TOOL_TOP_LAYER:addChild(EFFECT_TOOL_BG_LAYER, 0)
	EFFECT_TOOL_TOP_LAYER:addChild(EFFECT_TOOL_GM_LAYER, 1)
	EFFECT_TOOL_TOP_LAYER:addChild(EFFECT_TOOL_FX_LAYER, 2)
	EFFECT_TOOL_TOP_LAYER:addChild(EFFECT_TOOL_PC_LAYER, 3)
	EFFECT_TOOL_TOP_LAYER:addChild(EFFECT_TOOL_TM_LAYER, 4)
	EFFECT_TOOL_TOP_LAYER:addChildLast(EFFECT_TOOL_OD_LAYER)
	EFFECT_TOOL_TM_LAYER:setVisible(false)
	
	arg_6_0.layer = EFFECT_TOOL_TOP_LAYER
	
	if EFFECT_TOOL_LAYER_COLOR then
		arg_6_0.layer:setColor(EFFECT_TOOL_LAYER_COLOR)
	end
	
	if TOOL_TEST_TBL_MODEL then
		TOOL_TEST_TBL_MODEL.model = nil
	end
	
	_PARTICLE_CACHE = nil
	DEBUG_BONES_ENABLED = false
	DEBUG_SLOTS_ENABLED = false
	VARS.GAME_STARTED = true
	EffectTool.inited = true
	
	EffectTool.SetFigureImage(EFFECT_TOOL_BG_FIGURE_IMAGE)
	EffectTool.UpdateField()
	EffectTool.UpdateToolInfo()
	arg_6_0:initMoustEvent()
end

function EffectTool.SelectToolPage(arg_7_0)
	EffectTool.CurrentToolPage = arg_7_0
	
	EffectTool.UpdateToolPage()
end

function EffectTool.UpdateToolPage()
	if not get_cocos_refid(EFFECT_TOOL_GM_LAYER) then
		return 
	end
	
	if not get_cocos_refid(EFFECT_TOOL_FX_LAYER) then
		return 
	end
	
	if not get_cocos_refid(EFFECT_TOOL_PC_LAYER) then
		return 
	end
	
	if not get_cocos_refid(EFFECT_TOOL_TM_LAYER) then
		return 
	end
	
	local var_8_0 = EffectTool.CurrentToolPage
	
	print("CurrentToolPage", var_8_0)
	
	if var_8_0 == "StageStateEditor" then
		EFFECT_TOOL_FX_LAYER:setVisible(false)
		EFFECT_TOOL_PC_LAYER:setVisible(false)
		EFFECT_TOOL_TM_LAYER:setVisible(false)
		EFFECT_TOOL_UI_LAYER:setVisible(true)
		
		if get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
			EFFECT_TOOL_FG_LAYER:setVisible(true)
		end
	elseif var_8_0 == "TimelineEditor" then
		EFFECT_TOOL_FX_LAYER:setVisible(false)
		EFFECT_TOOL_PC_LAYER:setVisible(false)
		EFFECT_TOOL_TM_LAYER:setVisible(true)
		EFFECT_TOOL_UI_LAYER:setVisible(false)
		
		if get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
			EFFECT_TOOL_FG_LAYER:setVisible(false)
		end
	elseif var_8_0 == "EffectEditor" then
		EFFECT_TOOL_FX_LAYER:setVisible(true)
		EFFECT_TOOL_PC_LAYER:setVisible(false)
		EFFECT_TOOL_TM_LAYER:setVisible(false)
		EFFECT_TOOL_UI_LAYER:setVisible(false)
		
		if get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
			EFFECT_TOOL_FG_LAYER:setVisible(false)
		end
	elseif var_8_0 == "ParticleEditor" then
		EFFECT_TOOL_FX_LAYER:setVisible(false)
		EFFECT_TOOL_PC_LAYER:setVisible(true)
		EFFECT_TOOL_TM_LAYER:setVisible(false)
		EFFECT_TOOL_UI_LAYER:setVisible(false)
		
		if get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
			EFFECT_TOOL_FG_LAYER:setVisible(false)
		end
	else
		EFFECT_TOOL_FX_LAYER:setVisible(false)
		EFFECT_TOOL_PC_LAYER:setVisible(false)
		EFFECT_TOOL_TM_LAYER:setVisible(false)
		EFFECT_TOOL_UI_LAYER:setVisible(true)
		
		if get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
			EFFECT_TOOL_FG_LAYER:setVisible(true)
		end
	end
end

function Scene.effecttool.initMoustEvent(arg_9_0)
	local var_9_0 = cc.Director:getInstance():getEventDispatcher()
	local var_9_1 = cc.EventListenerMouse:create()
	
	var_9_1:registerScriptHandler(function(arg_10_0)
		_onBgMouseScrollDown(arg_10_0:getScrollY())
	end, cc.Handler.EVENT_MOUSE_SCROLL)
	var_9_0:addEventListenerWithSceneGraphPriority(var_9_1, EFFECT_TOOL_TOP_LAYER)
end

local function var_0_2()
	reload_master_sound()
end

function Scene.effecttool.onEnter(arg_12_0)
	var_0_2()
	LuaEventDispatcher:removeEventListenerByKey("effecttool")
	LuaEventDispatcher:addEventListener("spine.ani", EffectTool.onAniEvent, "effecttool")
	LuaEventDispatcher:addEventListener("battle.event", EffectTool.onEvent, "effecttool")
end

function Scene.effecttool.onLeave(arg_13_0)
end

function Scene.effecttool.onUnload(arg_14_0)
	IS_TOOL_MODE_REF = (IS_TOOL_MODE_REF or 1) - 1
	
	if IS_TOOL_MODE_REF == 0 then
		IS_TOOL_MODE = false
	end
	
	print("IS_TOOL_MODE = ", IS_TOOL_MODE)
	LuaEventDispatcher:removeEventListenerByKey("effecttool")
end

function Scene.effecttool.initKeyboard(arg_15_0)
	arg_15_0._KEY_MAP = {}
	
	if EFFECTTOOL_KEYBOARD_EVENT_LISTENER then
		return 
	end
	
	EFFECTTOOL_KEYBOARD_EVENT_LISTENER = cc.EventListenerKeyboard:create()
	
	EFFECTTOOL_KEYBOARD_EVENT_LISTENER:registerScriptHandler(function(arg_16_0, arg_16_1)
		local var_16_0 = SceneManager:getCurrentScene()
		
		if var_16_0.onKeyReleased then
			var_16_0:onKeyReleased(arg_16_0, arg_16_1)
		end
	end, cc.Handler.EVENT_KEYBOARD_RELEASED)
	EFFECTTOOL_KEYBOARD_EVENT_LISTENER:registerScriptHandler(function(arg_17_0, arg_17_1)
		local var_17_0 = SceneManager:getCurrentScene()
		
		if var_17_0.onKeyPressed then
			var_17_0:onKeyPressed(arg_17_0, arg_17_1)
		end
	end, cc.Handler.EVENT_KEYBOARD_PRESSED)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(EFFECTTOOL_KEYBOARD_EVENT_LISTENER, 1)
end

function Scene.effecttool.onAfterDraw(arg_18_0)
	CameraManager:update()
	BattleField:update()
end

function Scene.effecttool.onKeyPressed(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._KEY_MAP[arg_19_1] = true
end

function Scene.effecttool.onKeyReleased(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0._KEY_MAP[arg_20_1] = nil
	
	if arg_20_0._KEY_MAP[cc.KeyCode.KEY_CTRL] and cc.KeyCode.KEY_R == arg_20_1 then
		var_0_2()
	end
end

function Scene.effecttool.onTouchMove(arg_21_0, arg_21_1, arg_21_2)
	arg_21_2:stopPropagation()
	
	local var_21_0 = arg_21_1:getLocation()
	
	_onBgTouchMove(var_21_0.x, var_21_0.y)
	
	if arg_21_0._KEY_MAP[cc.KeyCode.KEY_CTRL] then
		EFFECT_TOOL_TOUCH_X = var_21_0.x + (DESIGN_WIDTH - VIEW_WIDTH) * 0.5
		EFFECT_TOOL_TOUCH_Y = var_21_0.y
		
		EffectTool.MakeGuideLine()
		EffectTool.SetObjectPos(EFFECT_TOOL_FILED_X(), EFFECT_TOOL_FILED_Y())
	end
end

function Scene.effecttool.onTouchDown(arg_22_0, arg_22_1, arg_22_2)
	arg_22_2:stopPropagation()
	
	local var_22_0 = arg_22_1:getLocation()
	
	_onBgTouchDown(var_22_0.x, var_22_0.y)
	
	if arg_22_0._KEY_MAP[cc.KeyCode.KEY_CTRL] and arg_22_0._KEY_MAP[cc.KeyCode.KEY_SHIFT] then
		DEBUG.MAP_TEST = true
		
		return 
	end
	
	DEBUG.MAP_TEST = nil
	
	if arg_22_0._KEY_MAP[cc.KeyCode.KEY_CTRL] then
		EFFECT_TOOL_TOUCH_X = var_22_0.x + (DESIGN_WIDTH - VIEW_WIDTH) * 0.5
		EFFECT_TOOL_TOUCH_Y = var_22_0.y
		
		EffectTool.MakeGuideLine()
		EffectTool.SetObjectPos(EFFECT_TOOL_FILED_X(), EFFECT_TOOL_FILED_Y())
		
		return 
	end
	
	if get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
		if EffectTool.FRIENDS then
			local var_22_1 = slowpick(EFFECT_TOOL_FG_LAYER, EffectTool.FRIENDS, var_22_0.x, var_22_0.y)
			
			if var_22_1 then
				EffectTool.SelectFriend(var_22_1)
				
				return 
			end
		end
		
		if EffectTool.ENEMIES then
			local var_22_2 = slowpick(EFFECT_TOOL_FG_LAYER, EffectTool.ENEMIES, var_22_0.x, var_22_0.y)
			
			if var_22_2 then
				EffectTool.SelectEnemy(var_22_2)
				
				return 
			end
		end
	end
end

function EffectTool.SetToolPath(arg_23_0)
end

function EffectTool.SetShowFieldGrid(arg_24_0)
	BattleField:setVisibleFieldGrid(arg_24_0)
end

function EffectTool.Clear()
	EFFECT_TOOL_FX_LAYER:removeAllChildren()
	EFFECT_TOOL_PC_LAYER:removeAllChildren()
	EFFECT_TOOL_TM_LAYER:removeAllChildren()
end

function EffectTool.onDoHit(arg_26_0)
	EffectTool.HitCount = (EffectTool.HitCount or 0) + 1
	
	local var_26_0 = arg_26_0.unit
	local var_26_1 = DESIGN_WIDTH / 2 + math.random(-50, 50)
	local var_26_2 = DESIGN_HEIGHT / 2 + math.random(-50, 50)
	local var_26_3 = EffectTool.getAttackInfo(var_26_0)
	
	if var_26_3 then
		for iter_26_0, iter_26_1 in pairs(var_26_3.d_units) do
			if var_0_0.Heal ~= EffectTool.TEST_PROPERTY.hit_type then
				local var_26_4 = StageStateManager:hasStateActionFlagsByActor(var_26_0.model, "ignore_default_motion")
				local var_26_5 = iter_26_1.model
				
				if var_26_5 then
					local var_26_6 = var_26_5:convertToWorldSpace({
						x = 0,
						y = 0
					})
					
					var_26_1, var_26_2 = var_26_6.x + math.random(-50, 50), var_26_6.y + 60 + math.random(-50, 50)
					
					if not StageStateManager:hasStateActionFlagsByActor(var_26_0.model, "ignore_default_motion") then
						BattleAction:Finish("battle.damage_motion" .. iter_26_1.inst.pos)
						BattleAction:Add(SEQ(DMOTION(500, "attacked", false), DELAY(60), Battle:getIdleAction(iter_26_1)), var_26_5, "battle.damage_motion" .. iter_26_1.inst.pos)
					end
				end
			end
		end
	else
		print("HIT!", EffectTool.HitCount)
	end
	
	Battle:onFireEffect(var_26_3, {
		attacker = var_26_0,
		targets = var_26_3.d_units,
		eff_info = arg_26_0.info
	})
	EffectTool.MakeNameTag(var_26_1, var_26_2, "HIT!", "battle", 2000)
end

function EffectTool.onDoFire(arg_27_0)
	print("FIRE!")
	
	local var_27_0 = DESIGN_WIDTH / 2 + math.random(-50, 50)
	local var_27_1 = DESIGN_HEIGHT / 2 + math.random(-50, 50)
	
	EffectTool.MakeNameTag(var_27_0, var_27_1, "FIRE!", "battle", 2000)
end

function EffectTool.onEvent(arg_28_0, arg_28_1, ...)
	local var_28_0 = {
		...
	}
	
	if arg_28_1.sender == "state.hit" then
		EffectTool.onDoHit(arg_28_1)
		
		return 
	end
	
	if arg_28_1.sender == "state.fire" then
		EffectTool.onDoFire(arg_28_1)
		
		return 
	end
end

function EffectTool.onAniEvent(arg_29_0)
	EffectManager:onAniEvent(arg_29_0)
	StageStateManager:onAniEvent(arg_29_0)
end

function EffectTool.UpdateToolInfo()
	EffectTool.MakeGuideLine()
	BattleLayout:updateLayoutMark()
end

function EffectTool.CompositiveEffectPlayShot(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = "effect/"
	local var_31_1 = EFFECT_TOOL_FX_LAYER
	local var_31_2 = su.CompositiveEffect2D:create(var_31_0 .. arg_31_0)
	
	if not var_31_2 then
		return 
	end
	
	var_31_2:setScaleFactor(BASE_SCALE)
	var_31_2:setPosition(EFFECT_TOOL_FILED_X(), EFFECT_TOOL_FILED_Y())
	var_31_1:addChild(var_31_2)
	var_31_2:capture(arg_31_1, arg_31_2 / 1000)
end

function EffectTool.InitToolConnect(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if arg_32_0 == "lobby" then
		SceneManager:nextScene(arg_32_0)
		
		return 
	end
	
	LuaEventDispatcher:removeEventListenerByKey("effecttool")
	reload_scripts()
	Action:RemoveAll()
	BattleAction:RemoveAll()
	UIAction:RemoveAll()
	reload_db()
	init_game_static_variable()
	SceneManager:reload()
	ShaderManager:loadShader()
	resume()
	setenv("time_scale", 1)
	
	if arg_32_2 ~= "" then
		EFFECT_TOOL_BG_FIGURE_IMAGE = arg_32_2
	end
	
	if arg_32_3 ~= "" then
		EFFECT_TOOL_FIELD_NAME = arg_32_3
	end
	
	cc.Director:getInstance():getEventDispatcher():removeEventListener(G_EFFECTTOOL_LOOP_LISTEN)
	SceneManager:nextScene(arg_32_0 or "effecttool")
end

function EffectTool.loadField(arg_33_0)
	EFFECT_TOOL_FIELD_NAME = arg_33_0
	
	EffectTool.UpdateField()
end

function EffectTool.UpdateField()
	if not EffectTool.inited then
		return 
	end
	
	if get_cocos_refid(EFFECT_TOOL_GM_LAYER) then
		EFFECT_TOOL_GM_LAYER:removeAllChildren()
	end
	
	local var_34_0 = BattleField:create()
	
	BattleField:addTestField(EFFECT_TOOL_FIELD_NAME, DESIGN_WIDTH * 4)
	
	EFFECT_TOOL_UI_LAYER = BattleField:getUILayer()
	
	EFFECT_TOOL_UI_LAYER:removeAllChildren()
	var_34_0:ejectFromParent()
	EFFECT_TOOL_GM_LAYER:addChild(var_34_0)
	
	EFFECT_BGI = BGI
	EFFECT_TOOL_FG_LAYER = BGI.main.layer
	
	EffectManager.setDefaultLayer(EFFECT_TOOL_FG_LAYER)
	EffectTool.DrawTestUnits()
	EffectTool:UpdateToolPage()
	collectgarbage("collect")
	cc.Director:getInstance():removeUnusedCachedData()
end

function EffectTool.DrawTestPlayModel(arg_35_0, arg_35_1)
	if not get_cocos_refid(arg_35_1) or not arg_35_0 then
		return 
	end
	
	if arg_35_0.modelName ~= arg_35_0.curModelName or arg_35_0.skinName ~= arg_35_0.curSkinName or arg_35_0.posInfo and (not arg_35_0.curPosInfo or arg_35_0.curPosInfo.type ~= arg_35_0.posInfo.type or arg_35_0.curPosInfo.x ~= arg_35_0.posInfo.x or arg_35_0.curPosInfo.y ~= arg_35_0.posInfo.y) then
		if get_cocos_refid(arg_35_0.model) then
			arg_35_1:removeChild(arg_35_0.model)
		end
		
		arg_35_0.model = nil
	end
	
	if arg_35_0.modelName and not get_cocos_refid(arg_35_0.model) then
		arg_35_0.curPosInfo = arg_35_0.posInfo
		arg_35_0.curModelName = arg_35_0.modelName
		arg_35_0.curSkinName = arg_35_0.skinName
		
		local var_35_0 = arg_35_0.db and arg_35_0.db.atlas
		
		arg_35_0.model = var_0_1(arg_35_0, arg_35_0.curModelName, arg_35_0.curSkinName, arg_35_0.aniName or "idle", var_35_0, model_opt)
		
		arg_35_0.model:setLuaTag({
			unit = arg_35_0
		})
		arg_35_0.model:setScaleFactor(BASE_SCALE)
		arg_35_0.model:resetTimeline()
		arg_35_0.model:createShadow(arg_35_1)
		
		local var_35_1
		local var_35_2
		local var_35_3 = 1
		
		if arg_35_0.db then
			var_35_3 = arg_35_0.db.scale or 1
		end
		
		if arg_35_0.posInfo and arg_35_0.posInfo.type == "right" then
			var_35_1 = DESIGN_WIDTH * 0.8
			var_35_2 = DESIGN_HEIGHT * 0.3
			
			arg_35_0.model:setScale(-var_35_3, var_35_3)
		elseif arg_35_0.posInfo and arg_35_0.posInfo.type == "center" then
			var_35_1 = DESIGN_WIDTH * 0.5
			var_35_2 = DESIGN_HEIGHT * 0.3
			
			arg_35_0.model:setScale(var_35_3)
		else
			var_35_1 = DESIGN_WIDTH * 0.2
			var_35_2 = DESIGN_HEIGHT * 0.3
			
			arg_35_0.model:setScale(var_35_3)
		end
		
		if arg_35_0.posInfo and arg_35_0.posInfo.x and arg_35_0.posInfo.y then
			var_35_1 = arg_35_0.posInfo.x
			var_35_2 = arg_35_0.posInfo.y
		end
		
		arg_35_0.init_x = EFFECT_TOOL_FILED_X(var_35_1)
		arg_35_0.init_y = EFFECT_TOOL_FILED_Y(var_35_2)
		arg_35_0.x, arg_35_0.y = arg_35_0.init_x, arg_35_0.init_y
		
		arg_35_0.model:setPosition(arg_35_0.x, arg_35_0.y)
		
		local var_35_4 = 0
		
		if arg_35_0.inst.line == BACK then
			var_35_4 = var_35_4 - 1
		end
		
		arg_35_0.z = BattleUtil:getZ(arg_35_0.y) + var_35_4
		arg_35_0.desc = ccui.Text:create()
		
		arg_35_0.desc:setFontName("font/daum.ttf")
		arg_35_0.desc:setColor(cc.c3b(255, 255, 255))
		arg_35_0.desc:enableOutline(cc.c3b(0, 0, 0), 1)
		arg_35_0.desc:setFontSize(12 * WIDGET_SCALE_FACTOR)
		arg_35_0.model:addChild(arg_35_0.desc)
		
		local var_35_5 = arg_35_0.model:getScaleX() / math.abs(arg_35_0.model:getScaleX())
		local var_35_6 = arg_35_0.model:getScaleY() / math.abs(arg_35_0.model:getScaleY())
		
		arg_35_0.desc:setScale(1 * var_35_5 / BASE_SCALE, 1 * var_35_6 / BASE_SCALE)
		arg_35_0.desc:setPositionY(-100)
		arg_35_1:addChild(arg_35_0.model)
		arg_35_0.model:updateModelParent(arg_35_1)
	end
	
	if arg_35_0.model then
		if arg_35_0.model:getParent() ~= arg_35_1 then
			arg_35_0.model:ejectFromParent()
			arg_35_1:addChild(arg_35_0.model)
		end
		
		arg_35_0.model:resetTimeline()
		
		local var_35_7 = arg_35_0.aniName or "idle"
		local var_35_8 = arg_35_0.loop
		
		if not arg_35_0.model:isExistAnimation(var_35_7) then
			var_35_7 = "idle"
			var_35_8 = true
		end
		
		if not arg_35_0.model:isExistAnimation(var_35_7) then
			var_35_7 = "animation"
			var_35_8 = false
		end
		
		if var_35_7 then
			local var_35_9 = arg_35_0.model:getCurrent()
			
			if not var_35_9 or not arg_35_0.keytime or var_35_9.animation ~= var_35_7 then
				var_35_9 = arg_35_0.model:setAnimation(0, var_35_7, var_35_8)
			end
			
			if var_35_9 then
				if arg_35_0.keytime then
					if arg_35_0.keytime == 0 then
						arg_35_0.model:setSetupPose()
					end
					
					var_35_9.time = arg_35_0.keytime / 1000
					var_35_9.timeScale = 0
					
					arg_35_0.desc:setString(string.format("%s : %d / %d", arg_35_0.aniName, arg_35_0.keytime, var_35_9.endTime * 1000))
				else
					var_35_9.timeScale = 1
					
					arg_35_0.desc:setString(arg_35_0.aniName)
				end
			end
		end
		
		arg_35_0.model:setPosition(arg_35_0.x, arg_35_0.y)
	end
	
	return arg_35_0
end

function EffectTool.makeUnitInst(arg_36_0)
	return {
		exp = 0,
		uid = -1,
		job = 3,
		grade = 1,
		lv = 1,
		code = arg_36_0,
		ally = FRIEND
	}
end

function EffectTool.removeCacheData()
	SceneManager:removeUnusedCachedData()
	
	local var_37_0 = cc.FileUtils:getInstance()
	
	if var_37_0.purgeCachingFileData then
		var_37_0:purgeCachingFileData()
	end
	
	if var_37_0.purgeCachingValueData then
		var_37_0:purgeCachingValueData()
	end
end

function EffectTool.PlayModelAnimation(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	EffectTool.removeCacheData()
	
	if not get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
		return 
	end
	
	print(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, flip)
	
	TOOL_TEST_TBL_MODEL = TOOL_TEST_TBL_MODEL or {}
	
	local var_38_0 = TOOL_TEST_TBL_MODEL or {}
	
	var_38_0.db = nil
	var_38_0.modelName = arg_38_0
	var_38_0.aniName = arg_38_2
	var_38_0.skinName = arg_38_1
	var_38_0.keytime = arg_38_3
	var_38_0.loop = arg_38_4
	var_38_0.posInfo = arg_38_5
	var_38_0.inst = EffectTool.makeUnitInst()
	
	EffectTool.DrawTestPlayModel(var_38_0, EFFECT_TOOL_FG_LAYER)
end

function EffectTool.PlayModelTimeline(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	EffectTool.removeCacheData()
	
	if not arg_39_0 then
		EffectTool.Clear()
		
		return 
	end
	
	print(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, flip)
	
	local var_39_0 = TOOL_TEST_TIMELINE_MODEL or {}
	
	var_39_0.db = nil
	var_39_0.modelName = arg_39_0
	var_39_0.aniName = arg_39_2
	var_39_0.skinName = arg_39_1
	var_39_0.keytime = arg_39_3
	var_39_0.loop = arg_39_4
	var_39_0.posInfo = arg_39_5
	var_39_0.inst = EffectTool.makeUnitInst()
	TOOL_TEST_TIMELINE_MODEL = EffectTool.DrawTestPlayModel(var_39_0, EFFECT_TOOL_TM_LAYER)
end

function EffectTool.setupPlayLayout(arg_40_0)
	if not TOOL_TEST_TBL_FRIEND then
		TOOL_TEST_TBL_FRIEND = {
			{
				id = "c1001",
				ani = "idle"
			},
			{
				id = "c1002",
				ani = "idle"
			},
			{
				id = "c1003",
				ani = "idle"
			},
			{
				id = "c1004",
				ani = "idle"
			}
		}
		TOOL_TEST_TBL_FRIEND_SELECTED = 2
	end
	
	if not TOOL_TEST_TBL_ENEMY then
		TOOL_TEST_TBL_ENEMY = {
			{
				id = "m0135",
				ani = "idle"
			},
			{
				id = "m0135",
				ani = "idle"
			},
			{
				id = "m0135",
				ani = "idle"
			},
			{
				id = "m0135",
				ani = "idle"
			},
			{
				id = "m0135",
				ani = "idle"
			}
		}
		TOOL_TEST_TBL_ENEMY_SELECTED = 1
	end
	
	if #TOOL_TEST_TBL_FRIEND < 1 then
		TOOL_TEST_TBL_FRIEND = {
			id = "c1001",
			ani = "idle",
			unit = arg_40_0
		}
	else
		for iter_40_0, iter_40_1 in pairs(TOOL_TEST_TBL_FRIEND) do
			if iter_40_0 == TOOL_TEST_TBL_FRIEND_SELECTED then
				iter_40_1.id = arg_40_0.inst.code
				iter_40_1.unit = arg_40_0
			end
		end
	end
end

function EffectTool.createTestUnit(arg_41_0)
	TOOL_TEST_TBL_MODEL = TOOL_TEST_TBL_MODEL or {}
	
	local var_41_0 = TOOL_TEST_TBL_MODEL or {}
	
	if not var_41_0.inst or var_41_0.inst.code ~= arg_41_0 then
		if get_cocos_refid(var_41_0.model) then
			var_41_0.model:ejectFromParent()
		end
		
		local var_41_1 = EffectTool.makeUnitInst(arg_41_0)
		
		var_41_0 = UNIT:create({
			code = var_41_1.code,
			lv = var_41_1.lv,
			exp = var_41_1.exp,
			grade = var_41_1.grade,
			uid = var_41_1.uid
		})
		
		var_41_0:reset()
		
		TOOL_TEST_TBL_MODEL = var_41_0
	end
	
	local var_41_2, var_41_3, var_41_4 = DB("character", arg_41_0, {
		"face_id",
		"model_id",
		"skin"
	})
	
	var_41_0.modelName = var_41_3
	var_41_0.skinName = var_41_4
	
	return var_41_0
end

function EffectTool.getAttackInfo(arg_42_0)
	if not arg_42_0 or not EffectTool.att_info_map then
		return 
	end
	
	return EffectTool.att_info_map[arg_42_0]
end

function EffectTool.setAttackInfo(arg_43_0, arg_43_1)
	EffectTool.att_info = arg_43_1
	
	if not EffectTool.att_info_map then
		EffectTool.att_info_map = {}
	end
	
	EffectTool.att_info_map[arg_43_0] = arg_43_1
end

function EffectTool.PlayStageAction(arg_44_0)
	resume()
	EffectTool.removeCacheData()
	
	if SceneManager:getCurrentSceneName() ~= "effecttool" then
		return 
	end
	
	if BattleAction:Find("battle.skill") then
		return 
	end
	
	if not arg_44_0.char_id then
		return 
	end
	
	EFFECT_TOOL_TEST_PROP = arg_44_0.test_property or {}
	
	EffectTool.loadDefaultField()
	EFFECT_TOOL_UI_LAYER:removeAllChildren()
	EFFECT_TOOL_FG_LAYER:removeAllChildren()
	
	local var_44_0 = EffectTool.createTestUnit(arg_44_0.char_id)
	
	TOOL_TEST_CHAR_PROP = arg_44_0.char_prop
	
	if get_cocos_refid(var_44_0.model) then
		local var_44_1 = TOOL_TEST_CHAR_PROP.model_id
		
		if var_44_1 then
			var_44_0.model:changeBodyTo("model/" .. var_44_1 .. ".scsp", "model/" .. var_44_1 .. ".atlas")
		else
			var_44_0.model:changeBodyTo()
		end
		
		var_44_0.model:setAnimation(0, "b_idle", true)
	end
	
	EffectTool.setupPlayLayout(var_44_0)
	
	if arg_44_0.state_id == "" then
		arg_44_0.state_id = "start"
	end
	
	if arg_44_0.state_id == "start" or not arg_44_0.state_id then
		EffectTool.DrawTestUnits()
	end
	
	if not arg_44_0.state_doc then
		return 
	end
	
	local var_44_2 = NONE()
	
	if arg_44_0.state_id == "start" then
		var_44_2 = SEQ(CALL(CameraManager.resetReadyFocus, CameraManager), MOTION("idle", false), MOTION("idle", true), DELAY(500), DMOTION("b_idle_ready", false), MOTION("b_idle", true), DELAY(10))
	end
	
	local var_44_3
	local var_44_4 = {}
	local var_44_5 = arg_44_0.test_property
	
	EffectTool.TEST_PROPERTY = var_44_5
	
	local var_44_6
	local var_44_7
	
	print("test_property.hit_type", var_44_5.hit_type)
	
	if var_0_0.Heal == var_44_5.hit_type then
		print("Heal ")
		
		var_44_6 = EffectTool.FRIENDS
		var_44_7 = TOOL_TEST_TBL_FRIEND_SELECTED
	else
		var_44_6 = EffectTool.ENEMIES
		var_44_7 = TOOL_TEST_TBL_ENEMY_SELECTED
	end
	
	local var_44_8 = var_44_6[var_44_7]
	
	if var_44_5.multiple_target then
		var_44_4 = table.shallow_clone(var_44_6)
	else
		table.insert(var_44_4, var_44_8)
	end
	
	local var_44_9 = {
		a_unit = var_44_0,
		d_unit = var_44_8,
		d_units = var_44_4
	}
	
	EffectTool.setAttackInfo(var_44_0, var_44_9)
	
	local var_44_10 = {
		rate = 1,
		units = {
			friends = EffectTool.FRIENDS,
			enemies = EffectTool.ENEMIES
		},
		unit = var_44_0,
		att_info = var_44_9
	}
	
	table.merge(var_44_10, testParams or {})
	
	if not StageStateManager:loadStateCacheFromFile(arg_44_0.state_doc, arg_44_0.filename) then
		balloon_message("없어요!! " .. arg_44_0.filename)
		
		return 
	end
	
	EffectTool.HitCount = 0
	
	BattleAction:Add(SEQ(var_44_2, CALL(function()
		if not arg_44_0.state_doc then
			return 
		end
		
		if arg_44_0.skill_id then
			if arg_44_0.state_id == "start" then
				var_44_9.tick = LAST_TICK
				
				local var_45_0, var_45_1 = StageStateManager:start(arg_44_0.skill_id, var_44_10)
				
				if var_45_0 and IS_SHOW_RESULTMESSAGE then
					var_45_0:setCallback({
						onFinish = function(arg_46_0)
							local var_46_0 = "연출 종료"
							
							if not arg_46_0:isContainState("HIT") then
								var_46_0 = var_46_0 .. "(ERR:HIT 컴포넌트가 연출상에 없습니다)"
							end
							
							balloon_message(var_46_0)
						end
					})
				end
			elseif arg_44_0.state_id == "idle" then
			elseif arg_44_0.state_id == "stop" then
				StageStateManager:stop(arg_44_0.skill_id, var_44_10)
			end
			
			StageStateManager:releaseStateCache(arg_44_0.state_doc)
			
			return 
		end
		
		if arg_44_0.state_id then
			local var_45_2, var_45_3 = StageStateManager:executeStateDoc(arg_44_0.state_doc, arg_44_0.state_id, var_44_10)
			
			if var_45_2 and IS_SHOW_RESULTMESSAGE then
				var_45_2:setCallback({
					onFinish = function(arg_47_0)
						local var_47_0 = "연출 종료"
						
						if not arg_47_0:isContainState("HIT") then
							var_47_0 = var_47_0 .. "(ERR:HIT 컴포넌트가 연출상에 없습니다)"
						end
						
						balloon_message(var_47_0)
					end
				})
			end
			
			StageStateManager:releaseStateCache(arg_44_0.state_doc)
			
			return 
		end
	end)), var_44_0.model, "battle.skill")
end

function EffectTool.loadDefaultField()
	if not get_cocos_refid(EFFECT_TOOL_FG_LAYER) then
		EffectTool.loadField("grassland")
	end
end

function EffectTool.SetSelfCamera()
	EffectTool.loadDefaultField()
	CameraManager:resetReadyFocus()
end

function EffectTool.MakeGuideLine()
	local var_50_0 = EFFECT_TOOL_OD_LAYER
	local var_50_1 = "@EFFECTTOOL_SCREEN_GUIDE_LINE"
	
	if not IS_SHOW_CROSSHAIR then
		var_50_0:removeChildByName(var_50_1)
		
		return 
	end
	
	if MODE_LOCK_CROSSHAIR == 1 then
		EFFECT_TOOL_POS_X = DESIGN_WIDTH * 0.5
		EFFECT_TOOL_POS_Y = DESIGN_HEIGHT * 0.5
		EFFECT_TOOL_TOUCH_X = nil
		EFFECT_TOOL_TOUCH_Y = nil
	elseif MODE_LOCK_CROSSHAIR == 2 then
		EFFECT_TOOL_POS_X = DESIGN_WIDTH * CAM_ANCHOR_X
		EFFECT_TOOL_POS_Y = DESIGN_HEIGHT * 0.2
		EFFECT_TOOL_TOUCH_X = nil
		EFFECT_TOOL_TOUCH_Y = nil
	else
		EFFECT_TOOL_POS_X = EFFECT_TOOL_TOUCH_X or DESIGN_WIDTH * CAM_ANCHOR_X
		EFFECT_TOOL_POS_Y = EFFECT_TOOL_TOUCH_Y or DESIGN_HEIGHT * 0.2
	end
	
	local var_50_2 = var_50_0:getChildByName(var_50_1)
	
	if not var_50_2 then
		local var_50_3 = DESIGN_WIDTH * 2
		
		var_50_2 = cc.DrawNode:create()
		
		local var_50_4 = cc.c4f(1, 1, 1, 0.3)
		
		var_50_2:drawLine({
			y = 0,
			x = -var_50_3
		}, {
			y = 0,
			x = var_50_3
		}, var_50_4)
		var_50_2:drawLine({
			x = 0,
			y = -var_50_3
		}, {
			x = 0,
			y = var_50_3
		}, var_50_4)
		var_50_2:setLineWidth(2)
		var_50_2:setName(var_50_1)
		var_50_2:setAnchorPoint(0, 0)
		var_50_0:addChild(var_50_2)
	end
	
	var_50_2:setPosition(EFFECT_TOOL_POS_X, EFFECT_TOOL_POS_Y)
end

function EffectTool.MakeNameTag(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
	if not EffectTool.TEST_PROPERTY.show_hit_message then
		return 
	end
	
	local var_51_0 = EFFECT_TOOL_OD_LAYER
	local var_51_1 = ccui.Text:create()
	
	var_51_1:setFontName("font/daum.ttf")
	var_51_1:setColor(cc.c3b(255, 255, 255))
	var_51_1:enableOutline(cc.c3b(0, 0, 0), 1)
	var_51_1:setFontSize(25)
	var_51_1:setString(arg_51_2)
	
	local var_51_2 = var_51_1:getContentSize()
	
	var_51_1:setPosition(arg_51_0, arg_51_1 - 30)
	var_51_1:setLocalZOrder(300)
	var_51_0:addChild(var_51_1)
	Action:Add(SEQ(DELAY(arg_51_4), REMOVE()), var_51_1, arg_51_3)
end

function EffectTool.SelectFriend(arg_52_0)
	if not TOOL_TEST_TBL_MODEL then
		return 
	end
	
	arg_52_0 = arg_52_0 or TOOL_TEST_TBL_FRIEND_SELECTED or 2
	
	local var_52_0
	local var_52_1
	
	if EffectTool.FRIENDS then
		for iter_52_0 = 1, 6 do
			local var_52_2 = EffectTool.FRIENDS[iter_52_0]
			
			if var_52_2 and var_52_2.model then
				if arg_52_0 == iter_52_0 then
					TOOL_TEST_TBL_MODEL = var_52_2
					TOOL_TEST_TBL_FRIEND_SELECTED = iter_52_0
					
					var_52_2.model:setColor(cc.c3b(255, 255, 255))
				else
					var_52_2.model:setColor(cc.c3b(150, 150, 150))
				end
			end
		end
	end
end

function EffectTool.SelectEnemy(arg_53_0)
	arg_53_0 = arg_53_0 or TOOL_TEST_TBL_ENEMY_SELECTED or 1
	TOOL_TEST_TBL_ENEMY_SELECTED = arg_53_0
	
	local var_53_0 = false
	local var_53_1
	local var_53_2
	
	if EffectTool.ENEMIES then
		for iter_53_0 = 1, 6 do
			local var_53_3 = EffectTool.ENEMIES[iter_53_0]
			
			if var_53_3 and var_53_3.model then
				var_53_1 = var_53_3
				var_53_2 = iter_53_0
				
				if arg_53_0 == iter_53_0 then
					var_53_0 = true
					
					var_53_3.model:setColor(cc.c3b(255, 255, 255))
				else
					var_53_3.model:setColor(cc.c3b(150, 150, 150))
				end
			end
		end
		
		if not var_53_0 and var_53_1 then
			var_53_1.model:setColor(cc.c3b(255, 255, 255))
			
			TOOL_TEST_TBL_ENEMY_SELECTED = var_53_2
		end
	end
end

function EffectTool.DrawTestUnits()
	if not TOOL_TEST_TBL_FRIEND or not TOOL_TEST_TBL_ENEMY then
		return 
	end
	
	local var_54_0 = EFFECT_TOOL_FG_LAYER
	
	if not get_cocos_refid(var_54_0) then
		return 
	end
	
	local function var_54_1(arg_55_0, arg_55_1)
		arg_55_0 = arg_55_0 or {}
		
		local var_55_0 = {}
		
		for iter_55_0, iter_55_1 in pairs(arg_55_0) do
			local var_55_1 = iter_55_1.unit
			
			if not var_55_1 and iter_55_1.id then
				var_55_1 = UNIT:create({
					exp = 0,
					lv = 1,
					code = iter_55_1.id
				})
				iter_55_1.unit = var_55_1
				
				print("make model ", var_55_1.db.model_id)
			end
			
			if var_55_1 then
				var_55_1.inst.show = true
				var_55_1.inst.pos = iter_55_0
				var_55_1.inst.line = iter_55_0 > 3 and FRONT or BACK
				var_55_1.inst.ally = arg_55_1
				var_55_1.inst.ani_id = iter_55_1.ani
				
				var_55_1:reset()
				table.insert(var_55_0, var_55_1)
			end
		end
		
		return var_55_0
	end
	
	local function var_54_2(arg_56_0, arg_56_1)
		if not arg_56_0 or #arg_56_0 == 0 then
			return 
		end
		
		local var_56_0 = TeamLayout:build(arg_56_0, arg_56_1)
		
		for iter_56_0 = 1, #var_56_0 do
			local var_56_1 = arg_56_0[iter_56_0]
			
			if not get_cocos_refid(var_56_1.model) then
				local var_56_2 = var_56_1.db.model_id
				local var_56_3 = var_56_1.db.skin
				local var_56_4 = var_56_1.db.atlas
				
				if var_56_2 then
					local var_56_5 = var_0_1(var_56_1, var_56_2, var_56_3, var_56_1.inst.ani_id, var_56_4)
					
					var_56_1.model = var_56_5
					
					var_56_1.model:setLuaTag({
						unit = var_56_1
					})
					var_56_5:createShadow(var_54_0)
					var_56_5:setDebugBonesEnabled(DEBUG_BONES_ENABLED)
					var_56_5:setDebugSlotsEnabled(DEBUG_SLOTS_ENABLED)
					var_56_5:setScale(var_56_1.db.scale or 1)
					var_56_5:setVisible(var_56_1.inst.show)
					var_56_5:loadTexture()
				end
			end
			
			if get_cocos_refid(var_56_1.model) then
				var_56_1.model:ejectFromParent()
				var_56_1.model:setColor(cc.c3b(100, 100, 100))
				var_56_1.model:resetTimeline()
				var_54_0:addChild(var_56_1.model)
				var_56_1.model:updateModelParent(var_54_0)
			end
		end
		
		return arg_56_0, var_56_0
	end
	
	local var_54_3 = var_54_0:getChildren()
	
	for iter_54_0, iter_54_1 in pairs(var_54_3) do
		iter_54_1:ejectFromParent()
	end
	
	local var_54_4 = {
		[FRIEND] = FRIEND,
		[ENEMY] = ENEMY
	}
	local var_54_5 = 1
	local var_54_6 = false
	local var_54_7
	
	if TOOL_TEST_CHAR_PROP then
		var_54_6 = TOOL_TEST_CHAR_PROP.location == "right"
		var_54_5 = TOOL_TEST_CHAR_PROP.dir or 1
		
		local var_54_8 = TOOL_TEST_CHAR_PROP.model_id
	end
	
	BattleLayout:setDirection(var_54_5)
	
	local var_54_9 = var_54_1(TOOL_TEST_TBL_FRIEND, FRIEND)
	local var_54_10 = var_54_1(TOOL_TEST_TBL_ENEMY, ENEMY)
	local var_54_11
	local var_54_12
	local var_54_13
	
	EffectTool.FRIENDS, var_54_13 = var_54_2(var_54_9, true)
	
	local var_54_14
	
	EffectTool.ENEMIES, var_54_14 = var_54_2(var_54_10)
	
	local var_54_15 = {}
	
	if var_54_6 then
		var_54_15 = {
			{
				ally = ENEMY,
				layouts = var_54_14
			},
			{
				ally = FRIEND,
				layouts = var_54_13
			}
		}
	else
		var_54_15 = {
			{
				ally = FRIEND,
				layouts = var_54_13
			},
			{
				ally = ENEMY,
				layouts = var_54_14
			}
		}
	end
	
	local var_54_16 = BattleLayout:addTeamLayoutData(var_54_15[1].layouts, var_54_15[1].ally)
	
	var_54_16:setPosition(0, 0)
	var_54_16:setInitPosition(0, 0)
	var_54_16:setDirection(1)
	
	local var_54_17 = BattleLayout:addTeamLayoutData(var_54_15[2].layouts, var_54_15[2].ally)
	local var_54_18 = BattleLayout:getTeamDistance() * BattleLayout:getDirection()
	
	var_54_17:setPosition(var_54_18, 0)
	var_54_17:setInitPosition(var_54_18, 0)
	var_54_17:setDirection(-1)
	
	if var_54_5 < 0 then
		BattleLayout:setFieldPosition(DESIGN_WIDTH - BATTLE_LAYOUT.XDIST_FROM_SIDE)
	else
		BattleLayout:setFieldPosition(BATTLE_LAYOUT.XDIST_FROM_SIDE)
	end
	
	BattleLayout:updatePose()
	BattleLayout:updateModelPose()
	BattleLayout:updateLayoutMark()
	EffectTool.SelectEnemy()
	EffectTool.SelectFriend()
end

function EffectTool.RemoveTestUnits(arg_57_0)
	if not TOOL_TEST_TBL_FRIEND then
		TOOL_TEST_TBL_FRIEND = {}
	end
	
	if not TOOL_TEST_TBL_ENEMY then
		TOOL_TEST_TBL_ENEMY = {}
	end
	
	for iter_57_0 = 1, 6 do
		if TOOL_TEST_TBL_FRIEND[iter_57_0] and TOOL_TEST_TBL_FRIEND[iter_57_0].id == arg_57_0 then
			TOOL_TEST_TBL_FRIEND[iter_57_0] = nil
		end
		
		if TOOL_TEST_TBL_ENEMY[iter_57_0] and TOOL_TEST_TBL_ENEMY[iter_57_0].id == arg_57_0 then
			TOOL_TEST_TBL_ENEMY[iter_57_0] = nil
		end
	end
end

function EffectTool.SetBackgroundColor(arg_58_0)
	EFFECT_TOOL_LAYER_COLOR = arg_58_0
	
	EFFECT_TOOL_TOP_LAYER:setColor(arg_58_0)
end

FIGURE_POS_X = DESIGN_WIDTH / 2
FIGURE_POS_Y = DESIGN_HEIGHT / 2

function EffectTool.SetFigureImage(arg_59_0)
	EFFECT_TOOL_BG_FIGURE_IMAGE = arg_59_0
	
	local var_59_0 = EFFECT_TOOL_BG_LAYER
	
	var_59_0:removeChildByName("@FIGURE_IMAGE")
	
	if arg_59_0 then
		cc.FileUtils:getInstance():addSearchPath("../../../Raws/Supports")
		
		local var_59_1 = cc.Sprite:create(arg_59_0)
		
		if var_59_1 then
			var_59_1:setName("@FIGURE_IMAGE")
			var_59_1:setPosition(FIGURE_POS_X, FIGURE_POS_Y)
			var_59_0:addChild(var_59_1)
		end
	end
end

function EffectTool.SetObjectPos(arg_60_0, arg_60_1)
	local var_60_0 = EffectTool._effect_object
	
	if get_cocos_refid(var_60_0) then
		var_60_0:setPosition(arg_60_0, arg_60_1)
	end
end

function EffectTool.StopParticle()
	local var_61_0 = EffectTool._effect_object
	
	if get_cocos_refid(var_61_0) then
		if type(var_61_0.setAutoRemoveOnFinish) == "function" then
			var_61_0:setAutoRemoveOnFinish(true)
		end
		
		if type(var_61_0.stop) == "function" then
			var_61_0:stop()
		end
	end
end

function EffectTool.SetParticle(arg_62_0)
	EffectTool.removeCacheData()
	
	EffectTool._particleName = arg_62_0
	
	cc.FileUtils:getInstance():addSearchPath("../../../Raws/Particle/textures", true)
	
	local var_62_0 = (folder or "effect") .. "/" .. arg_62_0
	local var_62_1 = EFFECT_TOOL_FILED_X()
	local var_62_2 = EFFECT_TOOL_FILED_Y()
	local var_62_3 = 0
	local var_62_4 = EFFECT_TOOL_PC_LAYER
	
	var_62_4:removeAllChildren()
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	
	local var_62_5 = su.ParticleEffect2D:create(var_62_0)
	
	if var_62_5 then
		var_62_5:setPosition(var_62_1, var_62_2)
		var_62_5:setScaleFactor(BASE_SCALE)
		var_62_4:addChild(var_62_5)
		var_62_5:start()
		
		EffectTool._effect_object = var_62_5
	end
end

function EffectTool.CompositiveEffectPlay(arg_63_0)
	EffectTool.removeCacheData()
	
	local var_63_0 = EffectTool._effect_info
	
	if get_cocos_refid(var_63_0) then
		var_63_0:setVisible(false)
	end
	
	local function var_63_1(arg_64_0, arg_64_1)
		local var_64_0 = EffectTool._effect_info
		
		if not get_cocos_refid(var_64_0) then
			var_64_0 = ccui.Text:create()
			
			var_64_0:setAnchorPoint(0, 0)
			var_64_0:setFontName("font/daum.ttf")
			var_64_0:setColor(cc.c3b(255, 255, 255))
			var_64_0:enableOutline(cc.c3b(0, 0, 0), 1)
			var_64_0:setFontSize(25)
			var_64_0:setLocalZOrder(300)
			var_64_0:setVisible(false)
			EFFECT_TOOL_FX_LAYER:addChild(var_64_0)
			
			EffectTool._effect_info = var_64_0
		end
		
		var_64_0:setString(arg_64_0)
		
		local var_64_1 = var_64_0:getContentSize()
		local var_64_2 = 0
		local var_64_3 = 220
		
		var_64_0:setPosition(var_64_2, var_64_3)
		Action:Add(SEQ(DELAY(arg_64_1), SHOW(true)), var_64_0)
	end
	
	local var_63_2 = EffectManager:CompositiveEffectPlay({
		extractNodes = true,
		z = 0,
		source = arg_63_0,
		layer = EFFECT_TOOL_FX_LAYER,
		x = EFFECT_TOOL_FILED_X(),
		y = EFFECT_TOOL_FILED_Y()
	})
	
	if get_cocos_refid(var_63_2) then
		EffectTool._effect_object = var_63_2
		
		if var_63_2:getDuration() > 0 then
			local var_63_3 = math.ceil(var_63_2:getDuration() * 1000)
			
			var_63_1("파일이름: " .. arg_63_0 .. "\n" .. "재생시간: " .. tostring(var_63_3) .. "ms", var_63_3 + 500)
		end
	end
end

function EffectTool.CompositiveEffectStop(arg_65_0)
	if get_cocos_refid(EffectTool._effect_object) then
		EffectTool._effect_object:stop()
	end
end

function EffectTool.PlayWorldBossAction(arg_66_0)
	resume()
	EffectTool.removeCacheData()
	
	IS_SHOW_CROSSHAIR = false
	
	if SceneManager:getCurrentSceneName() ~= "effecttool" then
		return 
	end
	
	if BattleAction:Find("battle.skill") then
		return 
	end
	
	EFFECT_TOOL_UI_LAYER:removeAllChildren()
	EFFECT_TOOL_FG_LAYER:removeAllChildren()
	
	WORLDBOSS_INFO = {
		{
			ani = "idle",
			id = arg_66_0.char_id
		}
	}
	RAIDPARTY_INFO = {
		{
			id = "c1001",
			ani = "idle"
		},
		{
			id = "c1002",
			ani = "idle"
		},
		{
			id = "c1003",
			ani = "idle"
		},
		{
			id = "c1004",
			ani = "idle"
		},
		{
			id = "c1005",
			ani = "idle"
		},
		{
			id = "c1006",
			ani = "idle"
		},
		{
			id = "c1007",
			ani = "idle"
		},
		{
			id = "c1008",
			ani = "idle"
		},
		{
			id = "c1009",
			ani = "idle"
		},
		{
			id = "c1010",
			ani = "idle"
		},
		{
			id = "c1011",
			ani = "idle"
		},
		{
			id = "c1012",
			ani = "idle"
		},
		{
			id = "c1013",
			ani = "idle"
		},
		{
			id = "c1014",
			ani = "idle"
		},
		{
			id = "c1015",
			ani = "idle"
		},
		{
			id = "c1016",
			ani = "idle"
		}
	}
	
	if arg_66_0.state_id == "" then
		arg_66_0.state_id = "start"
	end
	
	TOOL_TEST_CHAR_PROP = arg_66_0.char_prop
	EffectTool.TEST_PROPERTY = {
		hit_type = 0,
		show_hit_message = false,
		multiple_target = true
	}
	EffectTool.HitCount = 0
	
	if arg_66_0.state_id == "start" or not arg_66_0.state_id then
		EffectTool.DrawWorldBossUnits()
	end
	
	local var_66_0 = arg_66_0.state_doc
	local var_66_1 = arg_66_0.state_file
	
	if not var_66_0 or not var_66_1 then
		return 
	end
	
	CameraManager:resetDefault()
	
	if not StageStateManager:loadStateCacheFromFile(var_66_0, var_66_1) then
		balloon_message("없어요!! " .. var_66_1)
		
		return 
	end
	
	local var_66_2 = EffectTool.WFRIENDS
	local var_66_3 = EffectTool.WENEMIES
	local var_66_4 = var_66_2[1]
	
	if table.count(var_66_2) <= 0 or table.count(var_66_3) <= 0 then
		return 
	end
	
	local var_66_5 = {
		a_unit = var_66_4,
		d_units = var_66_3
	}
	local var_66_6 = {
		rate = 1,
		units = {
			friends = var_66_2,
			enemies = var_66_3
		},
		unit = var_66_4
	}
	
	EffectTool.setAttackInfo(var_66_4, var_66_5)
	BattleAction:Add(SEQ(CALL(function()
		if not var_66_0 then
			return 
		end
		
		local var_67_0, var_67_1 = StageStateManager:executeStateDoc(var_66_0, "start", var_66_6)
		
		if var_67_0 then
			var_67_0:setCallback({
				onFinish = function(arg_68_0)
					balloon_message_with_sound("월드보스 연출툴 끝!!!")
				end,
				onDestroy = function(arg_69_0)
				end
			})
			StageStateManager:releaseStateCache(var_66_0)
		end
	end)), var_66_4.model, "battle.skill")
end

function EffectTool.DrawWorldBossUnits()
	local var_70_0 = EFFECT_TOOL_FG_LAYER
	
	if not get_cocos_refid(var_70_0) then
		return 
	end
	
	local function var_70_1(arg_71_0)
		if not string.find(arg_71_0, "/") then
			return "spani/" .. arg_71_0
		end
		
		return arg_71_0
	end
	
	local function var_70_2(arg_72_0, arg_72_1)
		arg_72_0 = arg_72_0 or {}
		
		local var_72_0 = {}
		
		for iter_72_0, iter_72_1 in pairs(arg_72_0) do
			local var_72_1 = iter_72_1.unit
			
			if not var_72_1 and iter_72_1.id then
				var_72_1 = UNIT:create({
					exp = 0,
					lv = 1,
					code = iter_72_1.id
				})
				iter_72_1.unit = var_72_1
			end
			
			if var_72_1 then
				var_72_1.inst.show = true
				var_72_1.inst.pos = iter_72_0
				var_72_1.inst.ally = arg_72_1
				var_72_1.inst.ani_id = iter_72_1.ani
				
				var_72_1:reset()
				table.insert(var_72_0, var_72_1)
			end
		end
		
		return var_72_0
	end
	
	local function var_70_3(arg_73_0, arg_73_1, arg_73_2)
		if not arg_73_0 or #arg_73_0 == 0 then
			return 
		end
		
		local var_73_0 = WorldBossLayout:build(arg_73_0, arg_73_1, arg_73_2)
		
		if not var_73_0 then
			return 
		end
		
		for iter_73_0 = 1, table.count(var_73_0) do
			local var_73_1 = arg_73_0[iter_73_0]
			
			if not get_cocos_refid(var_73_1.model) then
				local var_73_2 = var_73_1.db.model_id
				local var_73_3 = var_73_1.db.skin
				local var_73_4 = var_73_1.db.atlas
				
				if var_73_2 then
					local var_73_5 = var_0_1(var_73_1, var_73_2, var_73_3, var_73_1.inst.ani_id, var_73_4)
					
					var_73_1.model = var_73_5
					
					var_73_1.model:setLuaTag({
						unit = var_73_1
					})
					var_73_5:createShadow(var_70_0)
					var_73_5:setDebugBonesEnabled(DEBUG_BONES_ENABLED)
					var_73_5:setDebugSlotsEnabled(DEBUG_SLOTS_ENABLED)
					var_73_5:loadTexture()
					
					var_73_5.sound_rate = 0.3
				end
			end
			
			if get_cocos_refid(var_73_1.model) then
				var_73_1.model:ejectFromParent()
				var_73_1.model:resetTimeline()
				var_73_1.model:setVisible(var_73_1.inst.show)
				var_70_0:addChild(var_73_1.model)
				var_73_1.model:updateModelParent(var_70_0)
			end
		end
		
		return arg_73_0, var_73_0
	end
	
	local var_70_4 = var_70_0:getChildren()
	
	for iter_70_0, iter_70_1 in pairs(var_70_4) do
		iter_70_1:ejectFromParent()
	end
	
	local var_70_5 = WORLDBOSS_INFO[1]
	local var_70_6 = TOOL_TEST_CHAR_PROP.dir or 1
	
	BattleLayout:setDirection(var_70_6)
	
	local var_70_7 = var_70_2(WORLDBOSS_INFO, FRIEND)
	local var_70_8 = var_70_2(RAIDPARTY_INFO, ENEMY)
	local var_70_9 = var_70_5.id .. "_boss_pos.scsp"
	local var_70_10 = var_70_1(var_70_9)
	local var_70_11 = var_70_5.id .. "_party_pos.scsp"
	local var_70_12 = var_70_1(var_70_11)
	local var_70_13
	local var_70_14
	local var_70_15
	
	EffectTool.WFRIENDS, var_70_15 = var_70_3(var_70_7, var_70_10, true)
	
	local var_70_16
	
	EffectTool.WENEMIES, var_70_16 = var_70_3(var_70_8, var_70_12)
	
	if not var_70_15 then
		return 
	end
	
	if not var_70_16 then
		return 
	end
	
	BattleLayout:addWorldBossLayoutData(var_70_15, FRIEND):setDirection(1)
	BattleLayout:addWorldBossLayoutData(var_70_16, ENEMY):setDirection(-1)
	
	if var_70_6 < 0 then
		BattleLayout:setFieldPosition(DESIGN_WIDTH - BATTLE_LAYOUT.XDIST_FROM_SIDE)
	else
		BattleLayout:setFieldPosition(BATTLE_LAYOUT.XDIST_FROM_SIDE)
	end
	
	BattleLayout:updatePose()
	BattleLayout:updateModelPose()
end
