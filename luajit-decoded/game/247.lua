Scene.clanWar = SceneHandler:create("clan_war", 1280, 720)

function Scene.clanWar.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ClanWarMain:show(arg_1_0.layer)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
	
	if ClanWar:getMode() == CLAN_WAR_MODE.READY then
		SoundEngine:playBGM("event:/bgm/guildwar_lobby1")
	elseif ClanWar:getMode() == CLAN_WAR_MODE.WAR then
		SoundEngine:playBGM("event:/bgm/guildwar_lobby2")
	end
end

function Scene.clanWar.onEnter(arg_2_0)
	set_scene_fps(15)
end

function Scene.clanWar.onLeave(arg_3_0)
end

function Scene.clanWar.onUnload(arg_4_0)
end

function Scene.clanWar.onAfterDraw(arg_5_0)
end

function Scene.clanWar.onAfterUpdate(arg_6_0)
end

function Scene.clanWar.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
	
	if ClanWarTeam:isShow() then
		if ClanWarTeam:onTouchDown(arg_7_1, arg_7_2) then
			arg_7_2:stopPropagation()
		end
		
		return 
	end
	
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
end

function Scene.clanWar.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	if ClanWarTeam:isShow() then
		if ClanWarTeam:onTouchUp(arg_8_1, arg_8_2) then
			arg_8_2:stopPropagation()
		else
			ClanWarTeam:onPushBackground()
		end
		
		return 
	end
	
	local var_8_0 = arg_8_1:getLocation()
end

function Scene.clanWar.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
	set_high_fps_tick()
	
	if ClanWarTeam:isShow() and ClanWarTeam:onTouchMove(arg_9_1, arg_9_2) then
		arg_9_2:stopPropagation()
	end
	
	local var_9_0 = arg_9_1:getLocation()
	
	arg_9_2:stopPropagation()
end
