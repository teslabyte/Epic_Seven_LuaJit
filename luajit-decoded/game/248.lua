Scene.clan_war_close = SceneHandler:create("clan_war_close", 1280, 720)

function Scene.clan_war_close.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ClanWarClose:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
end

function Scene.clan_war_close.onEnter(arg_2_0)
	set_scene_fps(15)
	SoundEngine:playBGM("event:/bgm/guildwar_lobby1")
end

function Scene.clan_war_close.onLeave(arg_3_0)
end

function Scene.clan_war_close.onUnload(arg_4_0)
end

function Scene.clan_war_close.onAfterDraw(arg_5_0)
end

function Scene.clan_war_close.onAfterUpdate(arg_6_0)
end

function Scene.clan_war_close.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
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

function Scene.clan_war_close.getSceneState(arg_8_0)
	return ClanWarClose:getSceneState()
end

function Scene.clan_war_close.onTouchUp(arg_9_0, arg_9_1, arg_9_2)
	if ClanWarTeam:isShow() then
		if ClanWarTeam:onTouchUp(arg_9_1, arg_9_2) then
			arg_9_2:stopPropagation()
		else
			ClanWarTeam:onPushBackground()
		end
		
		return 
	end
	
	local var_9_0 = arg_9_1:getLocation()
end

function Scene.clan_war_close.onTouchMove(arg_10_0, arg_10_1, arg_10_2)
	set_high_fps_tick()
	
	if ClanWarTeam:isShow() and ClanWarTeam:onTouchMove(arg_10_1, arg_10_2) then
		arg_10_2:stopPropagation()
	end
	
	local var_10_0 = arg_10_1:getLocation()
	
	arg_10_2:stopPropagation()
end
