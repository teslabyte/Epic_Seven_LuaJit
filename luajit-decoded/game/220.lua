Scene.arena_net_round_next = SceneHandler:create("arena_net_round_next", 1280, 720)

function Scene.arena_net_round_next.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ArenaNetRoundNext:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.arena_net_round_next.onEnter(arg_2_0)
	set_scene_fps(30, 45)
	ArenaNetRoundNext:Enter()
end

function Scene.arena_net_round_next.onLeave(arg_3_0)
	LuaEventDispatcher:removeEventListenerByKey("arena.service.next_round")
end

function Scene.arena_net_round_next.onUnload(arg_4_0)
end

function Scene.arena_net_round_next.onAfterDraw(arg_5_0)
end

function Scene.arena_net_round_next.onAfterUpdate(arg_6_0)
end

function Scene.arena_net_round_next.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
end

function Scene.arena_net_round_next.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.arena_net_round_next.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end
