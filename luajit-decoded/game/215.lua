Scene.pvp_npc = SceneHandler:create("pvp_npc", 1280, 720)

function Scene.pvp_npc.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	PvpNPC:enterSingleMode()
	SceneManager:resetSceneFlow()
end

function Scene.pvp_npc.onUnload(arg_2_0)
	print("unload")
end

function Scene.pvp_npc.onEnter(arg_3_0)
	print("enter")
	SoundEngine:play("event:/ui/main_hud/btn_arena")
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.pvp_npc.onLeave(arg_4_0)
end

function Scene.pvp_npc.onAfterDraw(arg_5_0)
end

function Scene.pvp_npc.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	if PvpNPC:onTouchDown(arg_6_1, arg_6_2) then
		arg_6_2:stopPropagation()
	end
end

function Scene.pvp_npc.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	if PvpNPC:onTouchUp(arg_7_1, arg_7_2) then
		arg_7_2:stopPropagation()
	else
		PvpNPC:onPushBackground()
	end
end

function Scene.pvp_npc.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
	if PvpNPC:onTouchMove(arg_8_1, arg_8_2) then
		arg_8_2:stopPropagation()
	end
end
