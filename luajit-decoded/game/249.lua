Scene.storymap = SceneHandler:create("storymap", 1280, 720)

function Scene.storymap.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.3)
	
	arg_1_0.callback = arg_1_1.callback
	arg_1_0.enter_id = arg_1_1.enter_id
	
	SoundEngine:stopAllMusic()
end

function Scene.storymap.onUnload(arg_2_0)
	if get_cocos_refid(arg_2_0.layer) then
		arg_2_0.layer:removeFromParent()
	end
end

function Scene.storymap.onEnter(arg_3_0)
	StoryMap:playStory(arg_3_0.enter_id)
end

function Scene.storymap.onAfterDraw(arg_4_0)
end

function Scene.storymap.onLeave(arg_5_0)
end

function Scene.storymap.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.storymap.finiThisScene(arg_7_0)
	if arg_7_0.is_finished then
		return 
	end
	
	arg_7_0.is_finished = true
	
	if arg_7_0.callback then
		arg_7_0.callback()
	end
end
