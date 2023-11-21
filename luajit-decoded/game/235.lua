Scene.moonlight_destiny = SceneHandler:create("moonlight_destiny", 1280, 720)

function Scene.moonlight_destiny.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	
	SoundEngine:playBGM("event:/bgm/bgm_story_dark2")
	MoonlightDestinyUI:open(arg_1_1)
	
	local var_1_0 = SceneManager:getPrevSceneName()
	local var_1_1 = {
		"lota_lobby",
		"lota",
		"clan"
	}
	
	if table.find(var_1_1, var_1_0) then
		SceneManager:resetSceneFlow()
	end
	
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.3)
end

function Scene.moonlight_destiny.onUnload(arg_2_0)
	MoonlightDestinyUI:onUnload()
end

function Scene.moonlight_destiny.onEnter(arg_3_0)
	set_scene_fps(DEFAULT_DISPLAY_FPS)
end

function Scene.moonlight_destiny.onLeave(arg_4_0)
end

function Scene.moonlight_destiny.onAfterDraw(arg_5_0)
end

function Scene.moonlight_destiny.getSceneState(arg_6_0)
	return MoonlightDestinyUI:getSceneState()
end

function Scene.moonlight_destiny.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
end
