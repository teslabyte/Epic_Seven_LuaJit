Scene.mini_cook = SceneHandler:create("mini_cook", 1280, 720)

function Scene.mini_cook.onLoad(arg_1_0, arg_1_1)
	arg_1_0.args = arg_1_1
	arg_1_0.layer = cc.Layer:create()
	PREV_MINIMUM_FPS = MINIMUM_FPS
	MINIMUM_FPS = 30
	
	set_scene_fps(30, 30)
	SoundEngine:stopAllEvent()
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
	CookMain:show(arg_1_1.enter_id)
end

function Scene.mini_cook.onUnload(arg_2_0)
end

function Scene.mini_cook.onEnter(arg_3_0)
end

function Scene.mini_cook.onLeave(arg_4_0)
	if PREV_MINIMUM_FPS then
		MINIMUM_FPS = PREV_MINIMUM_FPS
	end
	
	SoundEngine:stopAllEvent()
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
end

function Scene.mini_cook.getSceneState(arg_5_0)
end

function Scene.mini_cook.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.mini_cook.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.mini_cook.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.mini_cook.onMouseWheel(arg_9_0, arg_9_1)
end

function Scene.mini_cook.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
end

function Scene.mini_cook.onGameEvent(arg_11_0, arg_11_1, arg_11_2)
end

function Scene.mini_cook.onAfterUpdate(arg_12_0)
	if MINIMUM_FPS and MINIMUM_FPS ~= 30 then
		MINIMUM_FPS = 0
	end
	
	if SCENE_FPS and SCENE_FPS > 30 then
		set_scene_fps(30, 30)
	end
end

function Scene.mini_cook.onAfterDraw(arg_13_0)
end
