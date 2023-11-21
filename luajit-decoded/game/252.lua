Scene.pet_ui = SceneHandler:create("pet_ui", 1280, 720)

function Scene.pet_ui.onLoad(arg_1_0, arg_1_1)
	arg_1_0.args = arg_1_1
	arg_1_0.layer = cc.Layer:create()
	
	PetUIMain:init(arg_1_0.layer, arg_1_1)
end

function Scene.pet_ui.onUnload(arg_2_0)
end

function Scene.pet_ui.onEnter(arg_3_0)
	PetUIMain:show()
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.pet_ui.onLeave(arg_4_0)
	PetUIMain:onLeave()
end

function Scene.pet_ui.getSceneState(arg_5_0)
end

function Scene.pet_ui.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.pet_ui.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	if PetUIMain:onTouchUp(arg_7_1, arg_7_2) then
		arg_7_2:stopPropagation()
	else
		PetUIMain:onPushBackground()
	end
end

function Scene.pet_ui.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.pet_ui.onMouseWheel(arg_9_0, arg_9_1)
end

function Scene.pet_ui.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
end

function Scene.pet_ui.onGameEvent(arg_11_0, arg_11_1, arg_11_2)
end
