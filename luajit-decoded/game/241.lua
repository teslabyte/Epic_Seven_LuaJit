Scene.sanctuary = SceneHandler:create("sanctuary", 1280, 720)

function Scene.sanctuary.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	
	set_high_fps_tick(4500)
	SanctuaryMain:open(arg_1_1)
end

function Scene.sanctuary.onUnload(arg_2_0)
end

function Scene.sanctuary.onEnter(arg_3_0)
	SCENE_FPS = 15
	
	SoundEngine:playBGM("event:/bgm/sanctuary")
end

function Scene.sanctuary.onLeave(arg_4_0)
	if SoundEngine:isPlayingBGM("event:/bgm/sanctuary") then
		SoundEngine:playBGM("event:/bgm/default")
	end
end

function Scene.sanctuary.getTransitionColor(arg_5_0)
	local var_5_0
	local var_5_1 = Account:getCurrentLobbyData()
	
	if var_5_1 and var_5_1.id == "christmas" and true or UIUtil:IsNight() then
		return cc.c3b(0, 0, 0)
	else
		return cc.c3b(255, 255, 255)
	end
end

function Scene.sanctuary.onAfterUpdate(arg_6_0)
end

function Scene.sanctuary.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
end

function Scene.sanctuary.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
end
