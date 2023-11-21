Scene.substory_lobby = SceneHandler:create("substory_lobby", 1280, 720)

function Scene.substory_lobby.onLoad(arg_1_0, arg_1_1)
	if Account:checkQueryEmptyDungeonData("exception") then
		return false
	end
	
	arg_1_0.layer = cc.Layer:create()
	
	SoundEngine:playBGM(SubStoryUtil:getLobbySound())
	SubStoryLobbyMain:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.substory_lobby.onUnload(arg_2_0)
end

function Scene.substory_lobby.onEnter(arg_3_0)
	set_scene_fps(15)
	set_high_fps_tick(10000)
	SubStoryLobbyMain:movePathParms()
end

function Scene.substory_lobby.onLeave(arg_4_0)
	SubStoryLobbyMain:onLeave()
end

function Scene.substory_lobby.onAfterUpdate(arg_5_0)
	BattleReady:update()
end

function Scene.substory_lobby.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getLocation()
	
	arg_6_2:stopPropagation()
end

function Scene.substory_lobby.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
end

function Scene.substory_lobby.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	arg_8_2:stopPropagation()
end

function Scene.substory_lobby.getSceneState(arg_9_0)
	return SubStoryLobbyMain:getSceneState()
end
