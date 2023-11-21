Scene.growth_guide = SceneHandler:create("growth_guide", 1280, 720)

function Scene.growth_guide.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	
	GrowthGuideBase:open(arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
	GrowthGuideBase:onLoad()
	SceneManager:resetSceneFlow()
	Lobby:playLobbyBGM()
end

function Scene.growth_guide.onUnload(arg_2_0)
	GrowthGuideBase:onUnload()
end

function Scene.growth_guide.onEnter(arg_3_0)
	SCENE_FPS = 15
end

function Scene.growth_guide.onLeave(arg_4_0)
end

function Scene.growth_guide.onAfterUpdate(arg_5_0)
end

function Scene.growth_guide.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.growth_guide.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
end
