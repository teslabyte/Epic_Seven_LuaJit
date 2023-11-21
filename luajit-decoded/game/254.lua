function testWorldBoss()
	local var_1_0 = {}
	
	var_1_0.boss_id = "wb1"
	var_1_0.unit_info = {
		{
			uid = 1,
			party = 1,
			power = 100,
			code = "c1001",
			pos = 1
		},
		{
			uid = 2,
			party = 1,
			power = 100,
			code = "c1001",
			pos = 2
		},
		{
			uid = 3,
			party = 1,
			power = 100,
			code = "c1001",
			pos = 3
		},
		{
			uid = 4,
			party = 1,
			power = 100,
			code = "c1001",
			pos = 4
		},
		{
			uid = 5,
			party = 2,
			power = 100,
			code = "c1001",
			pos = 1
		},
		{
			uid = 6,
			party = 2,
			power = 100,
			code = "c1001",
			pos = 2
		},
		{
			uid = 7,
			party = 2,
			power = 100,
			code = "c1001",
			pos = 3
		},
		{
			uid = 8,
			party = 2,
			power = 100,
			code = "c1001",
			pos = 4
		},
		{
			uid = 9,
			party = 3,
			power = 100,
			code = "c1001",
			pos = 1
		},
		{
			uid = 10,
			party = 3,
			power = 100,
			code = "c1001",
			pos = 2
		},
		{
			uid = 11,
			party = 3,
			power = 100,
			code = "c1001",
			pos = 3
		},
		{
			uid = 12,
			party = 3,
			power = 100,
			code = "c1001",
			pos = 4
		}
	}
	var_1_0.supporter_userInfo = {
		leader_code = "c1001",
		name = "test",
		level = 1
	}
	var_1_0.supporter_unit_info = {
		{
			uid = 13,
			party = 4,
			power = 100,
			code = "c1076",
			pos = 1
		},
		{
			uid = 14,
			party = 4,
			power = 100,
			code = "c1050",
			pos = 2
		},
		{
			uid = 15,
			party = 4,
			power = 100,
			code = "c1082",
			pos = 3
		},
		{
			uid = 16,
			party = 4,
			power = 100,
			code = "c1097",
			pos = 4
		}
	}
	
	startWorldboss(var_1_0)
end

function startWorldboss(arg_2_0)
	SceneManager:nextScene("world_boss", arg_2_0)
end

Scene.world_boss = Scene.world_boss or SceneHandler:create("world_boss", 1280, 720)

function Scene.world_boss.onLoad(arg_3_0, arg_3_1)
	arg_3_0.layer = cc.Layer:create()
	
	SoundEngine:stopAllSound()
	SoundEngine:stopAllMusic()
	BackButtonManager:clear()
	
	local var_3_0 = WorldBoss:load(arg_3_1)
	
	arg_3_0.layer:addChild(var_3_0)
end

function Scene.world_boss.onReload(arg_4_0)
end

function Scene.world_boss.onUnload(arg_5_0)
	WorldBoss:unload()
end

function Scene.world_boss.onEnter(arg_6_0)
	set_scene_fps(30, 45)
	UIOption:UpdateScreenOnState(SAVE:getOptionData("option.prevent_off_while_battle", true))
	LuaEventDispatcher:removeEventListenerByKey("worldboss")
	LuaEventDispatcher:addEventListener("battle.event", LISTENER(WorldBoss.onEvent, WorldBoss), "worldboss")
	LuaEventDispatcher:addEventListener("spine.ani", LISTENER(WorldBoss.onAniEvent, WorldBoss), "worldboss")
end

function Scene.world_boss.onEnterFinished(arg_7_0)
	WorldBoss:begin()
end

function Scene.world_boss.onLeave(arg_8_0)
	LuaEventDispatcher:removeEventListenerByKey("worldboss")
	CameraManager:resetDefault()
	UIOption:UpdateScreenOnState()
end

function Scene.world_boss.onAfterDraw(arg_9_0)
	if not WorldBoss.vars then
		return 
	end
	
	WorldBoss:update()
	BattleField:update()
	CameraManager:update()
end

function Scene.world_boss.onAfterUpdate(arg_10_0)
	if not WorldBoss.vars then
		return 
	end
end

function Scene.world_boss.onAppBackground(arg_11_0)
	WorldBossBattleUI:applicationDidEnterBackground()
end

function Scene.world_boss.onAppForeground(arg_12_0)
	WorldBossBattleUI:applicationWillEnterForeground()
end

function Scene.world_boss.onTouchUp(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1:getLocation()
	
	WorldBoss:onTouchDown(var_13_0.x, var_13_0.y, arg_13_2)
end

function Scene.world_boss.onTouchDown(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_1:getLocation()
	
	WorldBoss:onTouchDown(var_14_0.x, var_14_0.y, arg_14_2)
end

function Scene.world_boss.onTouchMove(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1:getLocation()
	
	WorldBoss:onTouchDown(var_15_0.x, var_15_0.y, arg_15_2)
end
