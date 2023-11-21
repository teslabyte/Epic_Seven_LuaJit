Scene.battle = SceneHandler:create("battle", 1280, 720)

function Scene.battle.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	BackButtonManager:clear()
	
	local var_1_0 = arg_1_1.logic
	
	if arg_1_0.story_data then
		SceneManager:resetSceneFlow()
	end
	
	local var_1_1 = Battle:begin(var_1_0, arg_1_1)
	
	arg_1_0.layer:addChild(var_1_1)
	
	local var_1_2 = Battle:getStoryMovieNameList()
	
	for iter_1_0, iter_1_1 in pairs(var_1_2) do
		local var_1_3 = "cinema/" .. iter_1_1
		
		download_file(var_1_3)
	end
	
	Battle:update()
end

function Scene.battle.onUnload(arg_2_0)
end

function Scene.battle.getSceneState(arg_3_0)
	return {
		ignore_flow = true
	}
end

function Scene.battle.getTagInfo(arg_4_0)
	return {
		viewer_mode = Battle:getViewerMode(),
		restored = Battle:isRestored()
	}
end

function Scene.battle.onEnter(arg_5_0)
	set_scene_fps(30, 45)
	UIOption:UpdateScreenOnState(SAVE:getOptionData("option.prevent_off_while_battle", true))
	LuaEventDispatcher:removeEventListenerByKey("battle")
	LuaEventDispatcher:addEventListener("spine.ani", LISTENER(Battle.onAniEvent, Battle), "battle")
	LuaEventDispatcher:addEventListener("battle.event", LISTENER(Battle.onEvent, Battle), "battle")
end

function Scene.battle.onChangeResolution(arg_6_0)
	updateOffsetStory()
end

function Scene.battle.onLeave(arg_7_0)
	LuaEventDispatcher:removeEventListenerByKey("battle")
	LuaEventDispatcher:removeEventListenerByKey("arena.service.viewer")
	ClearResult:onLeave()
	
	if Battle.logic and Battle.logic:isSkillPreview() then
		BattleAction:RemoveAll()
		BattleUIAction:RemoveAll()
	end
	
	if SceneManager:getCurrentSceneName() ~= "battle" then
		Battle:resetBattleTimeScale(1, true)
	end
	
	CameraManager:resetDefault()
	removeSavedBattleInfo()
end

function Scene.battle.onAfterUpdate(arg_8_0)
	BattleReady:update()
	ClearResult:update()
end

function Scene.battle.onEnterFinished(arg_9_0)
	TutorialGuide:onBattleEnterFinished(Battle.logic)
	Battle:beginAfter()
end

function Scene.battle.onReload(arg_10_0)
	copy_functions(BattleLogic, Battle.logic)
end

function Scene.battle.onbeforeDraw(arg_11_0)
end

function Scene.battle.onAfterDraw(arg_12_0)
	if Battle.vars then
		Battle:update()
		BattleLayout:update()
		CameraManager:update()
		BattleField:update()
		BattleUI:update()
	end
end

function Scene.battle.onAppBackground(arg_13_0)
	BattleTopBar:applicationDidEnterBackground()
end

function Scene.battle.onAppForeground(arg_14_0)
	BattleTopBar:applicationWillenterForeground()
end

function Scene.battle.onTouchDown(arg_15_0, arg_15_1, arg_15_2)
	if not Battle.vars then
		return 
	end
	
	local var_15_0 = arg_15_1:getLocation()
	
	arg_15_2:stopPropagation()
	
	if _onBgTouchDown(var_15_0.x, var_15_0.y) then
		return 
	end
	
	Battle:onTouchDown(var_15_0.x, var_15_0.y, arg_15_2)
end

function Scene.battle.onTouchUp(arg_16_0, arg_16_1, arg_16_2)
	if not Battle.vars then
		return 
	end
	
	local var_16_0 = arg_16_1:getLocation()
	
	arg_16_2:stopPropagation()
	
	if _onBgTouchUp(var_16_0.x, var_16_0.y) then
		return 
	end
	
	Battle:onTouchUp(var_16_0.x, var_16_0.y, arg_16_2)
end

function Scene.battle.onTouchMove(arg_17_0, arg_17_1, arg_17_2)
	if not Battle.vars then
		return 
	end
	
	local var_17_0 = arg_17_1:getLocation()
	
	arg_17_2:stopPropagation()
	
	if _onBgTouchMove(var_17_0.x, var_17_0.y) then
		return 
	end
	
	Battle:onTouchMove(var_17_0.x, var_17_0.y, arg_17_2)
end
