Scene.mini_defence = SceneHandler:create("mini_defence", 1280, 720)

local var_0_0

function Scene.mini_defence.onLoad(arg_1_0, arg_1_1)
	arg_1_0.args = arg_1_1
	arg_1_0.layer = cc.Layer:create()
	var_0_0 = MINIMUM_FPS
	MINIMUM_FPS = 30
	
	set_scene_fps(30, 30)
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
	MiniDefenceMain:onEnter(arg_1_0.layer, arg_1_1)
end

function Scene.mini_defence.onUnload(arg_2_0)
end

function Scene.mini_defence.onEnter(arg_3_0)
end

function Scene.mini_defence.onLeave(arg_4_0)
	if var_0_0 then
		MINIMUM_FPS = var_0_0
	end
end

function Scene.mini_defence.getSceneState(arg_5_0)
end

function Scene.mini_defence.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.mini_defence.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.mini_defence.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.mini_defence.onMouseWheel(arg_9_0, arg_9_1)
end

function Scene.mini_defence.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
end

function Scene.mini_defence.onGameEvent(arg_11_0, arg_11_1, arg_11_2)
end

function Scene.mini_defence.onAfterUpdate(arg_12_0)
	if MINIMUM_FPS and MINIMUM_FPS ~= 30 then
		MINIMUM_FPS = 0
	end
	
	if SCENE_FPS and SCENE_FPS > 30 then
		set_scene_fps(30, 30)
	end
end

function Scene.mini_defence.onAfterDraw(arg_13_0)
end
