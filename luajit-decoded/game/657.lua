Scene.lota_lobby = SceneHandler:create("lota_lobby", 1280, 720)

function Scene.lota_lobby.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_0.info = arg_1_1
end

function Scene.lota_lobby.onUnload(arg_2_0)
	print("unload")
end

function Scene.lota_lobby.onEnter(arg_3_0)
	set_scene_fps(60)
	print("enter")
	LotaEnterUI:init(arg_3_0.layer, arg_3_0.info)
end

function Scene.lota_lobby.onLeave(arg_4_0)
end

function Scene.lota_lobby.onAfterUpdate(arg_5_0)
end

function Scene.lota_lobby.getSceneState(arg_6_0)
end

function Scene.lota_lobby.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.lota_lobby.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.lota_lobby.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end

function Scene.lota_lobby.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
end

function Scene.lota_lobby.onMouseWheel(arg_11_0, arg_11_1)
end
