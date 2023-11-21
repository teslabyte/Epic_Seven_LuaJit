Scene.pvp = SceneHandler:create("pvp", 1280, 720)

function Scene.pvp.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	PvpSA:open(arg_1_1)
	SceneManager:resetSceneFlow()
end

function Scene.pvp.onUnload(arg_2_0)
	print("unload")
end

function Scene.pvp.onEnter(arg_3_0)
	print("enter")
	SoundEngine:play("event:/ui/main_hud/btn_arena")
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.pvp.onLeave(arg_4_0)
end

function Scene.pvp.onAfterDraw(arg_5_0)
	PvpSA:update()
end

function Scene.pvp.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	if PvpSA:onTouchDown(arg_6_1, arg_6_2) then
		arg_6_2:stopPropagation()
	end
end

function Scene.pvp.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	if PvpSA:onTouchUp(arg_7_1, arg_7_2) then
		arg_7_2:stopPropagation()
	else
		PvpSA:onPushBackground()
	end
end

function Scene.pvp.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	if PvpSA:onTouchMove(arg_8_1, arg_8_2) then
		arg_8_2:stopPropagation()
	end
end

function Scene.pvp.onGameEvent(arg_9_0, arg_9_1, arg_9_2)
	UnitTeam:onGameEvent(arg_9_1, arg_9_2)
end
