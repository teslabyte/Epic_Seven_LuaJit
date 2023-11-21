Scene.class_change = SceneHandler:create("class_change", 1280, 720)

function Scene.class_change.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	arg_1_1.parent = arg_1_0.layer
	
	ClassChange:open(arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.class_change.onUnload(arg_2_0)
	print("unload")
end

function Scene.class_change.onEnter(arg_3_0)
	print("enter")
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.class_change.onLeave(arg_4_0)
end

function Scene.class_change.onTouchDown(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1:getLocation()
end

function Scene.class_change.onAfterUpdate(arg_6_0)
	BattleReady:update()
end

function Scene.class_change.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
end

function Scene.class_change.getSceneState(arg_8_0)
	return ClassChange:getSceneState()
end
