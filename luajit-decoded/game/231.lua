Scene.achievement = SceneHandler:create("achievement", 1280, 720)

function Scene.achievement.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	
	AchievementBase:show(arg_1_1.tap)
end

function Scene.achievement.onUnload(arg_2_0)
end

function Scene.achievement.onEnter(arg_3_0)
	SCENE_FPS = 15
end

function Scene.achievement.onLeave(arg_4_0)
	AchievementBase:clear()
end

function Scene.achievement.onAfterUpdate(arg_5_0)
	if AchievementBase.onAfterUpdate then
		AchievementBase:onAfterUpdate()
	end
end

function Scene.achievement.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getLocation()
	
	if AchievementBase.onTouchDown and AchievementBase:onTouchDown(var_6_0.x, var_6_0.y, arg_6_2) then
		arg_6_2:stopPropagation()
	end
end

function Scene.achievement.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	if AchievementBase.onTouchUp and AchievementBase:onTouchUp(var_7_0.x, var_7_0.y, arg_7_2) then
		arg_7_2:stopPropagation()
	end
end
