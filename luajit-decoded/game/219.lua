Scene.arena_net_ready = SceneHandler:create("arena_net_ready", 1280, 720)

function Scene.arena_net_ready.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ArenaNetReady:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.arena_net_ready.onEnter(arg_2_0)
	set_scene_fps(30, 60)
	ArenaNetReady:Enter()
end

function Scene.arena_net_ready.onLeave(arg_3_0)
	LuaEventDispatcher:removeEventListenerByKey("arena.service.ready")
end

function Scene.arena_net_ready.onUnload(arg_4_0)
end

function Scene.arena_net_ready.onAfterDraw(arg_5_0)
end

function Scene.arena_net_ready.onAfterUpdate(arg_6_0)
end

function Scene.arena_net_ready.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
	
	if ArenaNetReady:isShow() then
		if ArenaNetReady:onTouchDown(arg_7_1, arg_7_2) then
			arg_7_2:stopPropagation()
		end
		
		return 
	end
end

function Scene.arena_net_ready.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	if ArenaNetReady:isShow() then
		if ArenaNetReady:onTouchUp(arg_8_1, arg_8_2) then
			arg_8_2:stopPropagation()
		else
			ArenaNetReady:onPushBackground()
		end
		
		return 
	end
end

function Scene.arena_net_ready.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end
