Scene.DungeonList = SceneHandler:create("DungeonList", 1280, 720)

function Scene.DungeonList.onLoad(arg_1_0, arg_1_1)
	if Account:checkQueryEmptyDungeonData("exception") then
		return false
	end
	
	arg_1_0.layer = cc.Layer:create()
	
	DungeonList:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.DungeonList.onUnload(arg_2_0)
end

function Scene.DungeonList.onEnter(arg_3_0)
	set_scene_fps(15)
	set_high_fps_tick(10000)
end

function Scene.DungeonList.onLeave(arg_4_0)
end

function Scene.DungeonList.onAfterUpdate(arg_5_0)
	DungeonList:onAfterUpdate()
end

function Scene.DungeonList.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getLocation()
	
	arg_6_2:stopPropagation()
	DungeonList:onTouchDown(var_6_0.x, var_6_0.y, arg_6_2)
	
	if UnitMain:isVisible() then
		return UnitMain:onTouchDown(arg_6_1, arg_6_2)
	end
end

function Scene.DungeonList.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
	DungeonList:onTouchUp(var_7_0.x, var_7_0.y, arg_7_2)
	
	if UnitMain:isVisible() then
		if UnitMain:onTouchUp(arg_7_1, arg_7_2) then
			arg_7_2:stopPropagation()
		else
			UnitMain:onPushBackground()
		end
	end
end

function Scene.DungeonList.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	arg_8_2:stopPropagation()
	DungeonList:onTouchMove(var_8_0.x, var_8_0.y, arg_8_2)
	
	if UnitMain:isVisible() then
		return UnitMain:onTouchMove(arg_8_1, arg_8_2)
	end
end

function Scene.DungeonList.getSceneState(arg_9_0)
	return DungeonList:getSceneState()
end

function Scene.DungeonList.onGameEvent(arg_10_0, arg_10_1, arg_10_2)
	DungeonList:onGameEvent(arg_10_1, arg_10_2)
end

function Scene.DungeonList.getTouchEventTime(arg_11_0)
	return arg_11_0.touchEventTime
end
