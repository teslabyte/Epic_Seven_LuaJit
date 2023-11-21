Scene.gacha_unit = SceneHandler:create("gacha_unit", 1280, 720)

function Scene.gacha_unit.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	GachaUnit:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionFade, 0.3)
end

function Scene.gacha_unit.onUnload(arg_2_0)
	print("unload")
end

function Scene.gacha_unit.onEnter(arg_3_0)
	set_scene_fps(DEFAULT_DISPLAY_FPS)
	print("enter")
end

function Scene.gacha_unit.onPreDestroy(arg_4_0)
	GachaIntroduceBG:closeWithSound()
end

function Scene.gacha_unit.onLeave(arg_5_0)
	GachaUnit:onLeave()
end

function Scene.gacha_unit.onAfterDraw(arg_6_0)
end

function Scene.gacha_unit.onAfterUpdate(arg_7_0)
end

function Scene.gacha_unit.onbeforeDraw(arg_8_0)
end

function Scene.gacha_unit.onCompleteDraw(arg_9_0)
	if GachaResultShare then
		GachaResultShare:updateAction()
	end
end

function Scene.gacha_unit.getSceneState(arg_10_0)
	return GachaUnit:getSceneState()
end

function Scene.gacha_unit.onTouchDown(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1:getLocation()
	
	arg_11_2:stopPropagation()
	GachaUnit:onTouchDown(var_11_0.x, var_11_0.y, arg_11_2)
end
