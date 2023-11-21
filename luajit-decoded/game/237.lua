Scene.unit_ui = SceneHandler:create("unit_ui", 1280, 720)

function Scene.unit_ui.onLoad(arg_1_0, arg_1_1)
	arg_1_0.args = arg_1_1
	arg_1_0.layer = cc.Layer:create()
end

function Scene.unit_ui.onUnload(arg_2_0)
end

function Scene.unit_ui.onEnter(arg_3_0)
	set_scene_fps(15)
	SoundEngine:playBGM("event:/bgm/default")
	UnitMain:show(arg_3_0.args or {
		mode = "Main"
	})
	arg_3_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.unit_ui.onLeave(arg_4_0)
	UnitMain:destroy()
end

function Scene.unit_ui.getSceneState(arg_5_0)
	return UnitMain:getSceneState()
end

function Scene.unit_ui.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	if UnitMain:onTouchDown(arg_6_1, arg_6_2) then
		arg_6_2:stopPropagation()
	end
end

function Scene.unit_ui.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	if UnitMain:onTouchUp(arg_7_1, arg_7_2) then
		arg_7_2:stopPropagation()
	else
		UnitMain:onPushBackground()
	end
end

function Scene.unit_ui.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	if UnitMain:onTouchMove(arg_8_1, arg_8_2) then
		arg_8_2:stopPropagation()
	end
end

function Scene.unit_ui.onMouseWheel(arg_9_0, arg_9_1)
	UnitMain:onMouseWheel(arg_9_1)
end

function Scene.unit_ui.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	UnitMain:onGestureZoom(arg_10_1, arg_10_2, arg_10_3)
end

function Scene.unit_ui.onGameEvent(arg_11_0, arg_11_1, arg_11_2)
	UnitMain:onGameEvent(arg_11_1, arg_11_2)
end

function Scene.unit_ui.onChangeResolution(arg_12_0)
	UnitMain:onChangeResolution()
	UnitDetail:onChangeResolution()
end

function Scene.unit_ui.onEnterFinished(arg_13_0)
	UnitMain:onEnterFinished()
end
