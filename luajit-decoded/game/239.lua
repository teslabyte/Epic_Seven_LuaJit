Scene.friend = SceneHandler:create("friend", 1280, 720)

function Scene.friend.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	Friend:show(arg_1_1, arg_1_0.layer)
	arg_1_0:setTransition(cc.TransitionFade, 0.3)
end

function Scene.friend.onUnload(arg_2_0)
	print("unload")
end

function Scene.friend.onEnter(arg_3_0)
	print("enter")
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.friend.onLeave(arg_4_0)
end

function Scene.friend.onAfterDraw(arg_5_0)
end

function Scene.friend.onGameEvent(arg_6_0, arg_6_1, arg_6_2)
	Friend:onGameEvent(arg_6_1, arg_6_2)
end
