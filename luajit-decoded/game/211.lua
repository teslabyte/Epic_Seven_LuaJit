Scene.lobby = SceneHandler:create("lobby", 1280, 720)
Scene.lobby.END_EPISODE = 5

function Scene.lobby.onLoad(arg_1_0, arg_1_1)
	arg_1_0.opts = arg_1_1
	arg_1_0.layer = Lobby:create(arg_1_1)
	
	BackButtonManager:clear()
	print("onLoad", DESIGN_WIDTH, DESIGN_HEIGHT)
end

function Scene.lobby.onUnload(arg_2_0)
end

function Scene.lobby.onEnter(arg_3_0)
	SceneManager:resetSceneFlow()
	
	function SceneManager.onContentChangeScene()
		GrowthGuideNavigator:proc()
	end
	
	UIOption:UpdateScreenOnState()
	
	local var_3_0 = Account:getAttendanceEventsBySubTypes("7days", "14days")
	local var_3_1 = Account:getReturnAttendanceEvent()
	
	if var_3_1 then
		table.insert(var_3_0, var_3_1)
	end
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if iter_3_1.failed_reward_level and iter_3_1.failed_reward_level <= Account:getLevel() then
			iter_3_1.failed_reward_level = nil
			
			Account:setLobbyCount(0)
		end
	end
	
	local var_3_2 = os.time()
	local var_3_3 = Account:getLobbyEnterTime()
	local var_3_4 = to_n(AccountData.server_time.this_week_thursday12kst)
	
	if var_3_3 < var_3_4 and var_3_4 <= var_3_2 then
		Account:setLobbyCount(0)
	end
	
	Account:setLobbyEnterTime(var_3_2)
	
	local var_3_5 = Login:getLoginResult()
	local var_3_6 = Account:getLobbyCount()
	local var_3_7 = {
		lobby_count = var_3_6
	}
	
	if Account:isLobbyFirst() then
		var_3_7.lobby_first = 1
	end
	
	if var_3_6 == 0 and Account:isAlterDbRequired() and Account:isAlterDbLoaded() == false then
		reload_db(true)
	end
	
	if var_3_5 and var_3_5.id then
		if opbit then
			var_3_7.opbit = opbit()
		end
		
		if utf8stamp then
			var_3_7.stamp = utf8stamp(var_3_5.session)
		end
	end
	
	var_3_7.play_time_logs = Analytics:getDatas()
	
	Analytics:saveLocalLogs()
	
	if SAVE:updateConfigDataByTemp() > 0 then
		var_3_7.config_datas = SAVE:getJsonConfigData()
	end
	
	var_3_7.delete_useless_data = Account:getDeleteUselessData()
	
	setenv("time_scale", 1)
	query("lobby_update", var_3_7)
	ConditionContentsManager:getDungeonMissions():clear()
	ConditionContentsManager:initConditions()
	Lobby:playTownEnterEffect()
	ConditionContentsManager:clearSubStoryContents()
	Lobby:onEnter()
	set_scene_fps(15)
	add_local_push("DAILY_CONNECT_1", DAILY_CONNECT_1_PUSH_TIME)
	add_local_push("DAILY_CONNECT_3", DAILY_CONNECT_3_PUSH_TIME)
	SAVE:updateUserDefaultData_MainQuestClearState(Scene.lobby.END_EPISODE)
	TutorialBattle:removeDownloadNode()
	
	if arg_3_0.opts and arg_3_0.opts.open_webevent_popup then
		if IS_PUBLISHER_ZLONG then
			TopBarNew:showZlongWebEvent()
		else
			WebEventPopUp:show()
		end
	end
end

function Scene.lobby.onLeave(arg_5_0)
	Lobby:onLeave()
end

function Scene.lobby.onAfterDraw(arg_6_0)
	Lobby:onAfterDraw()
end

function Scene.lobby.onAbsent(arg_7_0)
	Lobby:hideAllUINode()
end

function Scene.lobby.onExist(arg_8_0)
	Lobby:showAllUINode()
end

function Scene.lobby.onTouchDown(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1:getLocation()
	
	arg_9_2:stopPropagation()
	Lobby:onTouchDown(var_9_0.x, var_9_0.y, arg_9_2)
end

function Scene.lobby.onTouchUp(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1:getLocation()
	
	arg_10_2:stopPropagation()
end

function Scene.lobby.onTouchMove(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1:getLocation()
	
	arg_11_2:stopPropagation()
	Lobby:onTouchMove(var_11_0.x, var_11_0.y, arg_11_2)
end

function Scene.lobby.onGameEvent(arg_12_0, arg_12_1, arg_12_2)
	Lobby:onGameEvent(arg_12_1, arg_12_2)
end
