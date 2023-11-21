Scene.growth_boost = SceneHandler:create("growth_boost", 1280, 720)

function Scene.growth_boost.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	arg_1_1 = arg_1_1 or {}
	arg_1_1.parent = arg_1_0.layer
	
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.growth_boost.onUnload(arg_2_0)
end

function Scene.growth_boost.onEnter(arg_3_0)
	ConditionContentsManager:dispatch("growthboost.sync.sklv")
	ConditionContentsManager:dispatch("growthboost.sync.lv")
	query("growth_boost_update")
end

function Scene.growth_boost.onLeave(arg_4_0)
end

function Scene.growth_boost.onTouchDown(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1:getLocation()
end

function Scene.growth_boost.onAfterUpdate(arg_6_0)
	GrowthBoostUI:onAfterUpdate()
end

function Scene.growth_boost.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
end

function Scene.growth_boost.getSceneState(arg_8_0)
	return GrowthBoostUI:getSceneState()
end
