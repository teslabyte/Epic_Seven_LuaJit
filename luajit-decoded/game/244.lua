Scene.world_sub = SceneHandler:create("world_sub", 1280, 720)

function Scene.world_sub.onLoad(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getSceneArgs()
	
	if var_1_0 and var_1_0.preLoad then
		var_1_0.preLoad(var_1_0)
	end
	
	arg_1_0.layer = SubWorldMapController:create(var_1_0)
	
	if var_1_0 and var_1_0.afterLoad then
		var_1_0.afterLoad(var_1_0)
	end
	
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
	
	if not arg_1_1 or not arg_1_1.option or not arg_1_1.option.unlock_id then
		SoundEngine:play("event:/ui/main_hud/btn_map")
	end
	
	if arg_1_1.is_story_map then
		ConditionContentsNotifier:playPendingNotifications()
	end
end

function Scene.world_sub.onEnter(arg_2_0)
	set_scene_fps(15)
	SubWorldMapController:playBGM()
	SubWorldMapController:onEnterScene()
	SoundEngine:playAmbient("event:/ui/adventure/amb_small", SoundEngine.AMB_MUSIC_TRACK_2)
end

function Scene.world_sub.onLeave(arg_3_0)
end

function Scene.world_sub.onUnload(arg_4_0)
end

function Scene.world_sub.onAfterDraw(arg_5_0)
end

function Scene.world_sub.onAfterUpdate(arg_6_0)
	SubWorldMapController:onAfterUpdate()
end

function Scene.world_sub.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
	
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
	SubWorldMapController:onTouchDown(var_7_0.x, var_7_0.y, arg_7_2)
end

function Scene.world_sub.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	SubWorldMapController:onTouchUp(var_8_0.x, var_8_0.y, arg_8_2)
end

function Scene.world_sub.onGestureZoom(arg_9_0, arg_9_1, arg_9_2)
	SubWorldMapController:onGestureZoom(arg_9_1, arg_9_2)
end

function Scene.world_sub.onTouchMove(arg_10_0, arg_10_1, arg_10_2)
	set_high_fps_tick()
	
	local var_10_0 = arg_10_1:getLocation()
	
	arg_10_2:stopPropagation()
	SubWorldMapController:onTouchMove(var_10_0.x, var_10_0.y, arg_10_2)
end

function Scene.world_sub.getSceneState(arg_11_0)
	return SubWorldMapController:getSceneState()
end
