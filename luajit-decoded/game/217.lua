Scene.arena_net_lobby = SceneHandler:create("arena_net_lobby", 1280, 720)

function Scene.arena_net_lobby.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ArenaNetLobby:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.arena_net_lobby.onEnter(arg_2_0)
	set_scene_fps(15)
end

function Scene.arena_net_lobby.onLeave(arg_3_0)
	ArenaNetLobby:onLeave()
end

function Scene.arena_net_lobby.onUnload(arg_4_0)
end

function Scene.arena_net_lobby.onAfterDraw(arg_5_0)
end

function Scene.arena_net_lobby.onAfterUpdate(arg_6_0)
end

function Scene.arena_net_lobby.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
end

function Scene.arena_net_lobby.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.arena_net_lobby.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end
