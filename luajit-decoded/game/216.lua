Scene.pvp_team = SceneHandler:create("pvp_team", 1280, 720)

function Scene.pvp_team.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	PvpSATeam:show(arg_1_1, {
		pop_scene = true,
		parent = arg_1_0.layer
	})
	arg_1_0:setTransition(cc.TransitionFade, 0.3)
end

function Scene.pvp_team.getSceneState(arg_2_0)
	return PvpSATeam:getSceneState()
end

function Scene.pvp_team.onUnload(arg_3_0)
	print("unload")
end

function Scene.pvp_team.onEnter(arg_4_0)
	print("enter")
end

function Scene.pvp_team.onLeave(arg_5_0)
end

function Scene.pvp_team.onAfterDraw(arg_6_0)
end

function Scene.pvp_team.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.pvp_team.onTouchDown(arg_8_0, arg_8_1, arg_8_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchDown(arg_8_1, arg_8_2)
	end
end

function Scene.pvp_team.onTouchUp(arg_9_0, arg_9_1, arg_9_2)
	if UnitMain:isVisible() then
		if UnitMain:onTouchUp(arg_9_1, arg_9_2) then
			arg_9_2:stopPropagation()
		else
			UnitMain:onPushBackground()
		end
	end
end

function Scene.pvp_team.onTouchMove(arg_10_0, arg_10_1, arg_10_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchMove(arg_10_1, arg_10_2)
	end
end
