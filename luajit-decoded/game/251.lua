Scene.tournament = SceneHandler:create("tournament", 1280, 720)

function Scene.tournament.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	Tournament:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.tournament.onEnter(arg_2_0)
	set_scene_fps(15)
	TutorialGuide:procGuide()
end

function Scene.tournament.onLeave(arg_3_0)
end

function Scene.tournament.onUnload(arg_4_0)
end

function Scene.tournament.onAfterDraw(arg_5_0)
end

function Scene.tournament.onAfterUpdate(arg_6_0)
end

function Scene.tournament.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	if Tournament:onTouchDown(arg_7_1, arg_7_2) then
		arg_7_2:stopPropagation()
	end
end

function Scene.tournament.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	if Tournament:onTouchUp(arg_8_1, arg_8_2) then
		arg_8_2:stopPropagation()
	else
		Tournament:onPushBackground()
	end
end

function Scene.tournament.onGestureZoom(arg_9_0, arg_9_1, arg_9_2)
end

function Scene.tournament.onTouchMove(arg_10_0, arg_10_1, arg_10_2)
	if Tournament:onTouchMove(arg_10_1, arg_10_2) then
		arg_10_2:stopPropagation()
	end
end

function Scene.tournament.getSceneState(arg_11_0)
	return Tournament:getSceneState()
end

function Scene.pvp.onGameEvent(arg_12_0, arg_12_1, arg_12_2)
	TournamentTeam:onGameEvent(arg_12_1, arg_12_2)
end
