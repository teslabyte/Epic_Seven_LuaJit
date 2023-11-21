Scene.hero = SceneHandler:create("hero", 1280, 720)

function Scene.hero.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	Hero:show(arg_1_1 or {
		mode = "Normal"
	})
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.hero.onUnload(arg_2_0)
	print("unload")
end

function Scene.hero.onEnter(arg_3_0)
	print("enter")
end

function Scene.hero.onLeave(arg_4_0)
end

function Scene.hero.onTouchDown(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1:getLocation()
	
	if Hero:onTouchDown(var_5_0.x, var_5_0.y, arg_5_2) then
		arg_5_2:stopPropagation()
	end
end

function Scene.hero.onAfterUpdate(arg_6_0)
	Hero:onAfterUpdate()
end

function Scene.hero.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	if Hero:onTouchUp(var_7_0.x, var_7_0.y, arg_7_2) then
		arg_7_2:stopPropagation()
	end
end
