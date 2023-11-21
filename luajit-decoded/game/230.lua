Scene.review = SceneHandler:create("review", 1280, 720)

function Scene.review.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	Review:show(arg_1_1)
	SceneCloser:set()
end

function Scene.review.onUnload(arg_2_0)
	print("unload")
end

function Scene.review.onEnter(arg_3_0)
	print("enter")
end

function Scene.review.onLeave(arg_4_0)
end

function Scene.review.onAfterUpdate(arg_5_0)
end

function Scene.review.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getLocation()
	
	Review:onTouchDown(var_6_0.x, var_6_0.y, arg_6_2)
end

function Scene.review.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
end

function Scene.review.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	arg_8_2:stopPropagation()
end
