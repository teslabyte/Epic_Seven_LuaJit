Scene.world_boss_map = SceneHandler:create("world_boss_map", 1280, 720)

function Scene.world_boss_map.onLoad(arg_1_0)
	SoundEngine:stopAllSound()
	
	arg_1_0.layer = cc.Layer:create()
end

function Scene.world_boss_map.onUnload(arg_2_0)
	WorldBossMap:unload()
end

function Scene.world_boss_map.onEnter(arg_3_0)
	WorldBossMap:onLoad(arg_3_0.layer)
end

function Scene.world_boss_map.onLeave(arg_4_0)
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.world_boss_map.getSceneState(arg_5_0)
end

function Scene.world_boss_map.onTouchUp(arg_6_0, arg_6_1, arg_6_2)
end

function Scene.world_boss_map.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.world_boss_map.onTouchMove(arg_8_0, arg_8_1, arg_8_2)
end
