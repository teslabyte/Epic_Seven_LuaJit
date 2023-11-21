Scene.mini_volley_ball = SceneHandler:create("mini_volley_ball", 1280, 720)

function Scene.mini_volley_ball.onLoad(arg_1_0, arg_1_1)
	arg_1_0.args = arg_1_1
	arg_1_0.layer = cc.Layer:create()
	PREV_MINIMUM_FPS = MINIMUM_FPS
	MINIMUM_FPS = 30
	
	set_scene_fps(30, 30)
	VolleyBallMain:init(arg_1_0.layer, arg_1_1)
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
end

function Scene.mini_volley_ball.onUnload(arg_2_0)
end

function Scene.mini_volley_ball.onEnter(arg_3_0)
	SoundEngine:playBGM("event:/bgm/adventure_sum2021")
end

function Scene.mini_volley_ball.onLeave(arg_4_0)
	if PREV_MINIMUM_FPS then
		MINIMUM_FPS = PREV_MINIMUM_FPS
	end
	
	SoundEngine:stopAllEvent()
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
end

function Scene.mini_volley_ball.getSceneState(arg_5_0)
end

function Scene.mini_volley_ball.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.mini_volley_ball.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.mini_volley_ball.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.mini_volley_ball.onMouseWheel(arg_9_0, arg_9_1)
end

function Scene.mini_volley_ball.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
end

function Scene.mini_volley_ball.onGameEvent(arg_11_0, arg_11_1, arg_11_2)
end

function Scene.mini_volley_ball.onAfterUpdate(arg_12_0)
	if MINIMUM_FPS and MINIMUM_FPS ~= 30 then
		MINIMUM_FPS = 0
	end
	
	if SCENE_FPS and SCENE_FPS > 30 then
		set_scene_fps(30, 30)
	end
	
	BallManager:update()
	BallManager:procNextCommand()
	Volley_CharacterManager:updateJumpShadow()
	VolleyBallMain:update_reset_game()
	VolleyScoreManager:updateUI()
	VolleyBallMain:update_ready_scroll()
end

function Scene.mini_volley_ball.onAfterDraw(arg_13_0)
end

function Scene.mini_volley_ball.onAppBackground(arg_14_0)
	VolleyBallMain:applicationDidEnterBackground()
end

function Scene.mini_volley_ball.onAppForeground(arg_15_0)
	VolleyBallMain:applicationWillEnterForeground()
end
