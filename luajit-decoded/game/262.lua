Scene.mini_exorcist = SceneHandler:create("mini_exorcist", 1280, 720)

local var_0_0

function Scene.mini_exorcist.onLoad(arg_1_0, arg_1_1)
	arg_1_0.args = arg_1_1
	arg_1_0.layer = cc.Layer:create()
	var_0_0 = MINIMUM_FPS
	MINIMUM_FPS = 30
	
	set_scene_fps(30, 30)
	SoundEngine:stopAllEvent()
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
	ExorcistMain:onEnter(arg_1_1.enter_id)
end

function Scene.mini_exorcist.onUnload(arg_2_0)
end

function Scene.mini_exorcist.onEnter(arg_3_0)
end

function Scene.mini_exorcist.onLeave(arg_4_0)
	if var_0_0 then
		MINIMUM_FPS = var_0_0
	end
	
	SoundEngine:stopAllEvent()
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
end

function Scene.mini_exorcist.getSceneState(arg_5_0)
end

function Scene.mini_exorcist.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.mini_exorcist.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.mini_exorcist.onTouchMove(arg_8_0, arg_8_1)
end

function Scene.mini_exorcist.onMouseWheel(arg_9_0, arg_9_1)
end

function Scene.mini_exorcist.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
end

function Scene.mini_exorcist.onGameEvent(arg_11_0, arg_11_1, arg_11_2)
end

function Scene.mini_exorcist.onAfterUpdate(arg_12_0)
	if MINIMUM_FPS and MINIMUM_FPS ~= 30 then
		MINIMUM_FPS = 0
	end
	
	if SCENE_FPS and SCENE_FPS > 30 then
		set_scene_fps(30, 30)
	end
end

function Scene.mini_exorcist.onAfterDraw(arg_13_0)
end

function DEBUG_START_REPAIR_STAGE()
	if not PRODUCTION_MODE then
		return 
	end
end
