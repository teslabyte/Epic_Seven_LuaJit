Scene.moonlight_theater = SceneHandler:create("moonlight_theater", 1280, 720)

function Scene.moonlight_theater.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	arg_1_1.parent_wnd = arg_1_0.layer
	
	if not MoonlightTheaterManager:isPlayedDLCEffect() then
		MoonlightTheaterManager:setPlayedDLCEffect(true)
		EffectManager:Play({
			fn = "ui_moonlight_theather_admission.cfx",
			pivot_z = 99998,
			layer = arg_1_0.layer,
			pivot_x = DESIGN_WIDTH / 2,
			pivot_y = DESIGN_HEIGHT / 2
		})
		UIAction:Add(SEQ(DELAY(2600), CALL(function()
			MoonlightTheaterList:onShow(arg_1_1)
		end)), arg_1_0.layer, "block")
	else
		MoonlightTheaterList:onShow(arg_1_1)
	end
	
	if PLATFORM == "win32" then
		local var_1_0 = arg_1_0.layer:getEventDispatcher()
		local var_1_1 = cc.EventListenerMouse:create()
		
		var_1_1:registerScriptHandler(function(arg_3_0, arg_3_1)
			arg_1_0:onMouseWheel(arg_3_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_1_0:addEventListenerWithSceneGraphPriority(var_1_1, arg_1_0.layer)
	end
	
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.3)
end

function Scene.moonlight_theater.onUnload(arg_4_0)
end

function Scene.moonlight_theater.onEnter(arg_5_0)
	set_scene_fps(DEFAULT_DISPLAY_FPS)
end

function Scene.moonlight_theater.onLeave(arg_6_0)
end

function Scene.moonlight_theater.onAfterDraw(arg_7_0)
end

function Scene.moonlight_theater.getSceneState(arg_8_0)
end

function Scene.moonlight_theater.onTouchDown(arg_9_0, arg_9_1, arg_9_2)
end

function Scene.moonlight_theater.onMouseWheel(arg_10_0, arg_10_1)
end
