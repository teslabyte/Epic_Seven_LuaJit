Scene.arena_net_lounge = SceneHandler:create("arena_net_lounge", 1280, 720)

function Scene.arena_net_lounge.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ArenaNetLounge:Show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.arena_net_lounge.onEnter(arg_2_0)
	set_scene_fps(30, 45)
	ArenaNetLounge:Enter()
end

function Scene.arena_net_lounge.onLeave(arg_3_0)
	ArenaNetMusicBox:stopMusic()
	LuaEventDispatcher:removeEventListenerByKey("arena.service.lounge")
end

function Scene.arena_net_lounge.onUnload(arg_4_0)
end

function Scene.arena_net_lounge.onAfterDraw(arg_5_0)
end

function Scene.arena_net_lounge.onAfterUpdate(arg_6_0)
end

function Scene.arena_net_lounge.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
end

function Scene.arena_net_lounge.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.arena_net_lounge.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end
