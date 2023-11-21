Scene.shop = SceneHandler:create("shop", 1280, 720)

function Scene.shop.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	Shop:show(arg_1_1)
	arg_1_0:setTransition(cc.TransitionFade, 0.4)
	Lobby:playLobbyBGM()
end

function Scene.shop.onUnload(arg_2_0)
	print("unload")
end

function Scene.shop.onEnter(arg_3_0)
	set_scene_fps(30)
	set_high_fps_tick(60000)
	print("enter")
end

function Scene.shop.onLeave(arg_4_0)
end

function Scene.shop.onAfterUpdate(arg_5_0)
	Shop:onAfterUpdate()
end

function Scene.shop.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getLocation()
	
	arg_6_2:stopPropagation()
	Shop:onTouchDown(var_6_0.x, var_6_0.y, arg_6_2)
end

function Scene.shop.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
	Shop:onTouchUp(var_7_0.x, var_7_0.y, arg_7_2)
end

function Scene.shop.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	arg_8_2:stopPropagation()
	Shop:onTouchMove(var_8_0.x, var_8_0.y, arg_8_2)
end
