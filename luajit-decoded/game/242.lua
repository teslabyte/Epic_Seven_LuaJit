Scene.clan = SceneHandler:create("clan", 1280, 720)

function Scene.clan.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	ClanBase:show(arg_1_0.layer)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.4)
	SceneManager:cancelReseveResetSceneFlow()
	SoundEngine:playBGM("event:/bgm/default")
end

function Scene.clan.onEnter(arg_2_0)
	set_scene_fps(15)
end

function Scene.clan.onLeave(arg_3_0)
	ClanHistory:clear()
end

function Scene.clan.onUnload(arg_4_0)
end

function Scene.clan.onAfterDraw(arg_5_0)
end

function Scene.clan.onAfterUpdate(arg_6_0)
	ClanBase:onAfterUpdate()
end

function Scene.clan.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	set_high_fps_tick()
	
	local var_7_0 = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
	ClanBase:onTouchDown(var_7_0.x, var_7_0.y, arg_7_2)
	
	if ClanWarTeam:isShow() then
		if ClanWarTeam:onTouchDown(arg_7_1, arg_7_2) then
			arg_7_2:stopPropagation()
		end
		
		return 
	end
end

function Scene.clan.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	ClanBase:onTouchUp(var_8_0.x, var_8_0.y, arg_8_2)
	
	if ClanWarTeam:isShow() then
		if ClanWarTeam:onTouchUp(arg_8_1, arg_8_2) then
			arg_8_2:stopPropagation()
		else
			ClanWarTeam:onPushBackground()
		end
		
		return 
	end
end

function Scene.clan.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
	set_high_fps_tick()
	
	local var_9_0 = arg_9_1:getLocation()
	
	arg_9_2:stopPropagation()
	ClanBase:onTouchMove(var_9_0.x, var_9_0.y, arg_9_2)
end
