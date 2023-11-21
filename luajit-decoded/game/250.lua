Scene.story_action = SceneHandler:create("story_action", 1280, 720)

function Scene.story_action.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	set_high_fps_tick()
	test_story(arg_1_1.story_id, arg_1_1.opts)
end

function Scene.story_action.onUnload(arg_2_0)
end

function Scene.story_action.getSceneState(arg_3_0)
	return {
		ignore_flow = true
	}
end

function Scene.story_action.onEnter(arg_4_0)
	set_scene_fps(30, 45)
end

function Scene.story_action.onLeave(arg_5_0)
	CameraManager:resetDefault()
end

function Scene.story_action.onAfterUpdate(arg_6_0)
end

function Scene.story_action.onEnterFinished(arg_7_0)
end

function Scene.story_action.onReload(arg_8_0)
end

function Scene.story_action.onbeforeDraw(arg_9_0)
end

function Scene.story_action.onAfterDraw(arg_10_0)
	if not is_playing_story() then
		return 
	end
	
	BattleLayout:update()
	CameraManager:update()
	
	if BattleField:isRootLayerValid() then
		BattleField:update()
	end
end

function Scene.story_action.onTouchDown(arg_11_0, arg_11_1, arg_11_2)
end

function Scene.story_action.onTouchUp(arg_12_0, arg_12_1, arg_12_2)
end

function Scene.story_action.onTouchMove(arg_13_0, arg_13_1, arg_13_2)
end
