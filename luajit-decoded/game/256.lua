Scene.storage = SceneHandler:create("waitingroom", 1280, 720)

function Scene.storage.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	Storage:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionFade, 0.3)
	Lobby:playLobbyBGM()
end

function Scene.storage.onUnload(arg_2_0)
	print("unload")
end

function Scene.storage.onEnter(arg_3_0)
	set_scene_fps(DEFAULT_DISPLAY_FPS)
	print("enter")
end

function Scene.storage.onLeave(arg_4_0)
end

function Scene.storage.onAfterDraw(arg_5_0)
end

function Scene.storage.getSceneState(arg_6_0)
end

function Scene.storage.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
end
