Scene.arena_net_round_result = SceneHandler:create("arena_net_round_result", 1280, 720)

function Scene.arena_net_round_result.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ArenaNetRoundResult:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.arena_net_round_result.onEnter(arg_2_0)
	set_scene_fps(30, 45)
	ArenaNetRoundResult:Enter()
end

function Scene.arena_net_round_result.onLeave(arg_3_0)
	LuaEventDispatcher:removeEventListenerByKey("arena.service.next_round")
end

function Scene.arena_net_round_result.onUnload(arg_4_0)
end

function Scene.arena_net_round_result.onAfterDraw(arg_5_0)
end

function Scene.arena_net_round_result.onAfterUpdate(arg_6_0)
end

function Scene.arena_net_round_result.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
end

function Scene.arena_net_round_result.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.arena_net_round_result.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end
