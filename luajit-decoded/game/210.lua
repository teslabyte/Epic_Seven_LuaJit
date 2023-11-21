Scene.title = SceneHandler:create("title", 1280, 720)

function HANDLER.login(arg_1_0, arg_1_1)
	print("touch login ui : ", arg_1_1)
	
	if arg_1_1 == "btn_go" then
		if getenv("verinfo.status") == "maintenance" then
			return 
		end
		
		if getenv("verinfo.status." .. "world_" .. Login:getRegion()) == "maintenance" then
			return 
		end
		
		SceneManager:getCurrentScene():onButtonGo()
	elseif arg_1_1 == "btn_stove_login" or arg_1_1 == "btn_stove_login_jpn" then
		if Stove.enable then
			if Login.FSM:isCurrentState(LoginState.STOVE_WAIT_LOGIN) then
				Login.FSM:changeState(LoginState.STOVE_LOGIN)
			else
				Log.e("btn_stove_login. not STOVE_WAIT_LOGIN fsm state")
			end
		elseif Zlong.enable then
			if Login.FSM:isCurrentState(LoginState.ZLONG_WAIT_LOGIN) then
				Login.FSM:changeState(LoginState.ZLONG_LOGIN)
			else
				Log.e(" not ZLONG_WAIT_LOGIN state")
			end
		end
	elseif arg_1_1 == "btn_guest_login" or arg_1_1 == "btn_guest_login_jpn" then
		if Login.FSM:isCurrentState(LoginState.STOVE_WAIT_LOGIN) then
			Login.FSM:changeState(LoginState.STOVE_CHECK_GUEST_LOGIN)
		else
			Log.e("btn_guest_login. not STOVE_WAIT_LOGIN fsm state")
		end
	elseif arg_1_1 == "btn_select_server" or arg_1_1 == "btn_select_server_zl" or arg_1_1 == "btn_select_server_waiting_zl" then
		if getenv("patch.status") ~= "ask_download" or Login.FSM:isCurrentState("TICKET_WAIT") then
			local var_1_0 = SceneManager:getCurrentScene()
			
			if var_1_0.vars and var_1_0.vars.started then
				return 
			end
			
			if Login.FSM:isCurrentState("STANDBY") or Login.FSM:isCurrentState("TICKET_WAIT") then
				if not Stove:isGuestAccount() then
					SceneManager:getCurrentScene():showStoveWorldSelectUI(true)
				else
					balloon_message_with_sound("guest_not_allow_server_change")
				end
				
				if IS_PUBLISHER_ZLONG then
					Zlong:gameEventLog(ZLONG_LOG_CODE.WORLD_SELECT_BUTTON)
				end
			end
		end
	elseif arg_1_1 == "btn_logout" then
		if Login.FSM:isCurrentState(LoginState.STANDBY) or Login.FSM:isCurrentState(LoginState.TICKET_WAIT) then
			UIOption:proc_logout()
		end
	elseif string.starts(arg_1_1, "btn_world_") then
		if Login.FSM:isCurrentState(LoginState.STOVE_SELECT_WORLD) then
			if Stove:isGuestAccount() then
				Dialog:msgBox(T("guest_question_server_change"), {
					yesno = true,
					handler = function()
						local var_2_0 = SceneManager:getCurrentScene()
						
						var_2_0:refreshSelectedStoveWorldUI()
						var_2_0:showStoveWorldSelectUI(false)
						
						if Login.FSM:isCurrentState(LoginState.STOVE_SELECT_WORLD) then
							Login.FSM.STATES[LoginState.STOVE_SELECT_WORLD]:onSelectRegion(arg_1_0.region)
						end
					end
				})
			else
				local var_1_1 = SceneManager:getCurrentScene()
				
				var_1_1:refreshSelectedStoveWorldUI()
				var_1_1:showStoveWorldSelectUI(false)
				
				if Login.FSM:isCurrentState(LoginState.STOVE_SELECT_WORLD) then
					Login.FSM.STATES[LoginState.STOVE_SELECT_WORLD]:onSelectRegion(arg_1_0.region)
				end
			end
		elseif not Stove:isGuestAccount() then
			local var_1_2 = Login:getRegion()
			
			if Login.FSM:isCurrentState(LoginState.MAINTENANCE_REGION) then
				var_1_2 = Login:getMaintenanceRegion()
			end
			
			if var_1_2 ~= arg_1_0.region then
				Dialog:msgBox(T("question_server_change"), {
					yesno = true,
					handler = function()
						if IS_PUBLISHER_ZLONG then
							Login:setLocalSavedRegion(arg_1_0.region)
							Zlong:gameEventLog(ZLONG_LOG_CODE.SELECT_WORLD, string.format("{\"serverid\":\"%s\"}", arg_1_0.region))
						else
							setenv("needChangeRegion", arg_1_0.region)
						end
						
						SAVE:setUserDefaultData("main_quest_progress", "ep1")
						SAVE:destroy()
						delete_info()
						restart_contents()
					end
				})
			else
				local var_1_3 = SceneManager:getCurrentScene()
				
				var_1_3:refreshSelectedStoveWorldUI()
				var_1_3:showStoveWorldSelectUI(false)
			end
		else
			SceneManager:getCurrentScene():showStoveWorldSelectUI(false)
			balloon_message_with_sound("guest_not_allow_server_change")
		end
	elseif arg_1_1 == "btn_close_world_select" then
		if not Login.FSM:isCurrentState("STOVE_SELECT_WORLD") and not Login.FSM:isCurrentState("SELECT_WORLD") then
			SceneManager:getCurrentScene():showStoveWorldSelectUI(false)
		end
	elseif arg_1_1 == "icon_age_zl" then
		SceneManager:getCurrentScene():openAgeInfo()
	elseif arg_1_1 == "btn_close_age_info" then
		SceneManager:getCurrentScene():closeAgeInfo()
	elseif arg_1_1 == "chk_zlong_terms" then
		print("zlong terms checbox : ", arg_1_0:isSelected())
		SAVE:setUserDefaultData("zlong_check_terms", arg_1_0:isSelected())
	elseif arg_1_1 == "btn_zlong_terms_1" then
		Zlong:openGeneralWebView({
			title_flag = 2,
			action = "agreement",
			fullscreen_flag = 0
		})
	elseif arg_1_1 == "btn_zlong_terms_2" then
		Zlong:openGeneralWebView({
			title_flag = 2,
			action = "privacy",
			fullscreen_flag = 0
		})
	elseif arg_1_1 == "btn_notice_zl" then
		Zlong:openTitleNoticeWebView()
	end
end

function Scene.title.onLoad(arg_4_0)
	print("title.onload")
	
	arg_4_0.vars = {}
	arg_4_0.dlg_login = nil
	arg_4_0.layer = cc.Layer:create()
	
	BackButtonManager:clear()
	SAVE:load()
	PreLoad:afterLoadConfig()
	load_title_db()
end

function Scene.title._settingBackground(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0
	
	if arg_5_1 then
		if arg_5_2 == "movie" then
			if string.find(arg_5_1, ".mp4") then
				var_5_0 = ccexp.VideoPlayer:new()
				
				var_5_0:setName("movie_title")
				var_5_0:setFileName(cc.FileUtils:getInstance():fullPathForFilename(arg_5_1))
				var_5_0:setAnchorPoint(0.5, 0.5)
				adjustTitleMovieScale(var_5_0, nil)
				var_5_0:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
				var_5_0:setLoop(true)
				var_5_0:play()
			end
		else
			var_5_0 = cc.Sprite:create(arg_5_1)
			
			if not var_5_0 then
				return 
			end
			
			var_5_0:setScale(1)
			var_5_0:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
		end
	end
	
	return var_5_0
end

function Scene.title._settingEventLogo(arg_6_0)
	local var_6_0 = getUserLanguage()
	
	if not arg_6_0.logo_lang_data[var_6_0] then
		local var_6_1 = ""
	end
	
	local var_6_2
	
	if arg_6_0.logo_path then
		var_6_2 = cc.Sprite:create(arg_6_0.logo_path)
	end
	
	return var_6_2
end

function Scene.title.getMusicHandle(arg_7_0)
	return arg_7_0.sound
end

function Scene.title._playEventBGM(arg_8_0)
	if not arg_8_0:checkTimeData() then
		return 
	end
	
	local var_8_0 = cc.FileUtils:getInstance():getWritablePath() .. "data.ext/current_bgm.mp3"
	local var_8_1 = ccexp.SoundEngine:playSoundFile(var_8_0, true)
	
	if not get_cocos_refid(var_8_1) then
		return 
	end
	
	local var_8_2 = math.round(cc.UserDefault:getInstance():getFloatForKey("sound.vol_bgm", 0.3) * 1000) / 1000
	local var_8_3 = math.min(var_8_2, 0.3)
	
	var_8_1:setVolume(0)
	SysAction:Add(LINEAR_CALL(1500, nil, function(arg_9_0, arg_9_1)
		var_8_1:setVolume(arg_9_1)
	end, 0, var_8_3), {})
	
	arg_8_0.sound = var_8_1
	
	if TitleBackground then
		local var_8_4 = TitleBackground:getMusicHandle()
		
		if get_cocos_refid(var_8_4) then
			SysAction:Add(SEQ(LINEAR_CALL(1500, nil, function(arg_10_0, arg_10_1)
				if get_cocos_refid(var_8_4) then
					var_8_4:setVolume(arg_10_1)
				end
			end, var_8_4:getVolume(), 0), CALL(function()
				local var_11_0 = TitleBackground:getMusicHandle()
				
				if get_cocos_refid(var_11_0) then
					var_11_0:stop()
				end
			end)), {})
		end
	end
end

function setTitleLogoPosition(arg_12_0, arg_12_1, arg_12_2)
	if not DEBUG or not get_cocos_refid(DEBUG.n_event_logo) then
		return 
	end
	
	if arg_12_0 then
		DEBUG.n_event_logo:setScale(arg_12_0)
	end
	
	if arg_12_1 then
		DEBUG.n_event_logo:setPositionX(arg_12_1)
	end
	
	if arg_12_2 then
		DEBUG.n_event_logo:setPositionY(arg_12_2)
	end
end

function Scene.title.reloadTitle(arg_13_0)
	if not arg_13_0.vars.title_reloaded then
		arg_13_0.vars.title_reloaded = true
		
		arg_13_0:loadTitleSettingData()
		
		if BackgroundEventData and not BackgroundEventData:isLoadSucceed() then
			if arg_13_0:checkTimeData() then
				arg_13_0:settingEventTitle()
			end
		elseif BackgroundEventData and BackgroundEventData:isLoadSucceed() and DEBUG then
			DEBUG.n_event_logo = TitleBackground.wnd:findChildByName("n_event_logo")
		end
	end
end

function Scene.title.settingEventTitle(arg_14_0)
	if not TitleBackground then
		return 
	end
	
	if SAVE:getUserDefaultData("main_quest_progress", "") == "" then
		return 
	end
	
	local var_14_0 = TitleBackground.wnd
	
	if get_cocos_refid(var_14_0) then
		TitleBackground:removeAllScheduler()
		
		local var_14_1 = var_14_0:findChildByName("n_bg")
		local var_14_2 = var_14_0:findChildByName("n_event_bg")
		local var_14_3 = arg_14_0:_settingBackground(arg_14_0.bg_path, arg_14_0.bg_type)
		
		if not var_14_3 then
			return 
		end
		
		if var_14_2 and var_14_1 then
			var_14_2:addChild(var_14_3)
			var_14_2:setOpacity(0)
			UIAction:Add(SEQ(DELAY(500), FADE_IN(1500)), var_14_2)
			UIAction:Add(SEQ(FADE_OUT(1500)), var_14_1)
		end
		
		local var_14_4
		local var_14_5 = arg_14_0:_settingEventLogo()
		
		if not var_14_5 then
			return 
		end
		
		local var_14_6 = var_14_0:findChildByName("n_event_logo")
		local var_14_7 = var_14_0:findChildByName("n_logo")
		
		if var_14_6 and var_14_7 then
			local var_14_8 = arg_14_0.event_json_data.logo_x or 0
			local var_14_9 = arg_14_0.event_json_data.logo_y or 0
			local var_14_10 = arg_14_0.event_json_data.logo_scale or 1
			
			var_14_6:setPosition(var_14_8, var_14_9)
			var_14_6:setScale(var_14_10)
			
			if not arg_14_0.vars.event_to_event then
				UIAction:Add(SEQ(FADE_OUT(1500)), var_14_7)
			else
				if_set_visible(var_14_7, nil, false)
				
				local var_14_11 = (var_14_6:getChildren() or {})[1]
				
				if var_14_11 then
					UIAction:Add(SEQ(FADE_OUT(500), REMOVE()), var_14_11)
				end
			end
			
			var_14_6:addChild(var_14_5)
			var_14_6:setOpacity(0)
			UIAction:Add(SEQ(DELAY(500), FADE_IN(1500)), var_14_6)
			
			if DEBUG then
				DEBUG.n_event_logo = var_14_6
			end
		end
		
		arg_14_0:_playEventBGM()
	end
end

local function var_0_0(arg_15_0)
	local var_15_0 = {
		"year",
		"month",
		"day"
	}
	local var_15_1, var_15_2, var_15_3 = string.match(arg_15_0, "(%d%d)(%d%d)(%d%d)")
	local var_15_4 = tostring(to_n(var_15_1) + 2000)
	
	return {
		hour = 0,
		year = var_15_4,
		month = var_15_2,
		day = var_15_3
	}
end

local function var_0_1(arg_16_0)
	local var_16_0
	local var_16_1
	
	if arg_16_0 < 1000 then
		var_16_0, var_16_1 = string.match(arg_16_0, "(%d)(%d%d)")
	else
		var_16_0, var_16_1 = string.match(arg_16_0, "(%d%d)(%d%d)")
	end
	
	local var_16_2 = to_n(var_16_0)
	local var_16_3 = to_n(var_16_1)
	
	return var_16_2 * 60 * 60 + var_16_3 * 60
end

local function var_0_2()
	return 32400 - (os.time() - os.time(os.date("!*t")))
end

function Scene.title.getEventScheduleData(arg_18_0)
	do return nil end
	
	local var_18_0 = {}
	local var_18_1 = os.time()
	
	for iter_18_0 = 1, 9999 do
		local var_18_2, var_18_3, var_18_4, var_18_5, var_18_6 = DBN("title_manager", iter_18_0, {
			"id",
			"start_date",
			"start_time",
			"end_date",
			"end_time"
		})
		
		if not var_18_2 then
			break
		end
		
		local var_18_7 = 32400
		local var_18_8 = var_0_2()
		local var_18_9 = os.time(var_0_0(var_18_3)) + var_0_1(var_18_4) + var_18_8
		local var_18_10 = os.time(var_0_0(var_18_5)) + var_0_1(var_18_6) + var_18_8
		
		if var_18_9 < var_18_1 and var_18_1 < var_18_10 then
			return {
				id = var_18_2,
				start_date_time = var_18_9,
				end_date_time = var_18_10
			}
		end
		
		table.push(var_18_0, {
			id = var_18_2,
			start_date_time = var_18_9,
			end_date_time = var_18_10
		})
	end
	
	local var_18_11
	local var_18_12 = math.huge
	
	for iter_18_1, iter_18_2 in pairs(var_18_0) do
		if var_18_1 < iter_18_2.start_date_time then
			var_18_12 = math.min(var_18_12, iter_18_2.end_date_time)
			var_18_11 = iter_18_1
		end
	end
	
	if var_18_11 then
		return var_18_0[var_18_11]
	end
	
	return nil
end

function Scene.title.exportLogo(arg_19_0, arg_19_1)
	local var_19_0 = getenv("allow.language")
	local var_19_1 = getUserLanguage()
	local var_19_2 = {}
	
	if var_19_0 then
		local var_19_3 = string.split(var_19_0, ",")
		
		for iter_19_0, iter_19_1 in pairs(var_19_3) do
			local var_19_4
			
			if iter_19_1 then
				local var_19_5 = DB("title_manager", arg_19_1, "logo_" .. iter_19_1)
				
				if var_19_5 ~= var_19_4 then
					local var_19_6 = var_19_5 and "logo/" .. var_19_5 .. ".png" or "failed"
					local var_19_7 = var_19_5 .. ".png"
					
					var_19_2[iter_19_1] = var_19_7
					
					export_title_to_file(var_19_6, var_19_7)
					
					if iter_19_1 == var_19_1 then
						arg_19_0.logo_path = "title/" .. var_19_6
					end
				end
			end
		end
	end
	
	local var_19_8 = json.encode(var_19_2)
	
	SAVE:setUserDefaultData("title_overlap.logo_lang", var_19_8)
end

LAST_EXPORT_LOG = ""

function Scene.title.exportTitleFiles(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	local var_20_0
	local var_20_1 = arg_20_3 == "movie" and (LOW_RESOLUTION_MODE and "_low.mp4" or ".mp4") or ".png"
	local var_20_2 = arg_20_2 and "bg/" .. arg_20_2 .. var_20_1 or "failed"
	local var_20_3 = arg_20_4 and "bgm/" .. arg_20_4 .. ".mp3" or "failed"
	
	LAST_EXPORT_LOG = "bg  : " .. tostring(arg_20_2) .. " bgm : " .. tostring(arg_20_4) .. "\n"
	
	local var_20_4 = export_title_to_file(var_20_2, "current_bg" .. var_20_1)
	
	LAST_EXPORT_LOG = LAST_EXPORT_LOG .. "export 1 ok : " .. tostring(var_20_4) .. "\n"
	arg_20_0.bg_type = arg_20_3
	arg_20_0.bg_path = "title/" .. var_20_2
	
	local var_20_5 = export_title_to_file(var_20_3, "current_bgm.mp3")
	
	LAST_EXPORT_LOG = LAST_EXPORT_LOG .. "export 2 ok : " .. tostring(var_20_5) .. "\n"
	
	arg_20_0:exportLogo(arg_20_1)
	
	if arg_20_5 then
		return 
	end
	
	if BackgroundEventData.load_complete then
		arg_20_0.vars.event_to_event = true
	end
	
	BackgroundEventData.load_complete = false
end

TITLE_ERROR_LOG = ""

function Scene.title.loadTitleSettingData(arg_21_0)
	if not export_title_to_file then
		return 
	end
	
	local var_21_0 = to_n(getenv("title_overlap.start", ""))
	local var_21_1 = to_n(getenv("title_overlap.end", ""))
	local var_21_2 = getenv("title_overlap.id", "auto")
	
	if var_21_2 == "auto" then
		local var_21_3
		
		if var_21_3 then
			var_21_2 = var_21_3.id
			var_21_0 = var_21_3.start_date_time
			var_21_1 = var_21_3.end_date_time
		else
			var_21_2 = "no_event"
			var_21_0 = 0
			var_21_1 = 0
			arg_21_0.event_begin_time = var_21_0
			arg_21_0.event_end_time = var_21_1
			
			local var_21_4 = {
				logo_scale = 1,
				logo_y = 0,
				logo_x = 0,
				id = var_21_2,
				begin_time = var_21_0,
				end_time = var_21_1
			}
			local var_21_5 = json.encode(var_21_4)
			
			SAVE:setUserDefaultData("title_overlap.json", var_21_5)
			
			return 
		end
	end
	
	local var_21_6 = "logo_" .. getUserLanguage()
	local var_21_7, var_21_8, var_21_9, var_21_10, var_21_11, var_21_12, var_21_13 = DB("title_manager", var_21_2, {
		"bg",
		"bg_type",
		"bgm",
		var_21_6,
		"logo_x",
		"logo_y",
		"logo_scale"
	})
	
	if not var_21_7 then
		var_21_2 = "no_event"
		var_21_0 = 0
		var_21_1 = 0
		arg_21_0.event_begin_time = var_21_0
		arg_21_0.event_end_time = var_21_1
		
		local var_21_14 = {
			logo_scale = 1,
			logo_y = 0,
			logo_x = 0,
			id = var_21_2,
			begin_time = var_21_0,
			end_time = var_21_1
		}
		local var_21_15 = json.encode(var_21_14)
		
		SAVE:setUserDefaultData("title_overlap.json", var_21_15)
		
		return 
	end
	
	var_21_11 = var_21_11 or "default"
	var_21_12 = var_21_12 or "default"
	var_21_13 = var_21_13 or "default"
	
	local var_21_16 = json.decode(SAVE:getUserDefaultData("title_overlap.json", "")) or {}
	local var_21_17 = cc.FileUtils:getInstance()
	local var_21_18 = var_21_17:getWritablePath() .. "data.ext"
	
	if arg_21_0:checkTimeData(var_21_0, var_21_1) then
		arg_21_0:exportTitleFiles(var_21_2, var_21_7, var_21_8, var_21_9, true)
	end
	
	if var_21_16.id ~= var_21_2 or not var_21_17:isDirectoryExist(var_21_18) then
		arg_21_0:exportTitleFiles(var_21_2, var_21_7, var_21_8, var_21_9)
	elseif not BackgroundEventData:isLoadSucceed() and arg_21_0:checkTimeData(var_21_0, var_21_1) then
		arg_21_0:exportTitleFiles(var_21_2, var_21_7, var_21_8, var_21_9)
	end
	
	local var_21_19 = {
		id = var_21_2,
		bg_type = var_21_8,
		begin_time = var_21_0,
		end_time = var_21_1,
		logo_x = var_21_11,
		logo_y = var_21_12,
		logo_scale = var_21_13
	}
	local var_21_20 = json.encode(var_21_19)
	
	print(var_21_20)
	SAVE:setUserDefaultData("title_overlap.json", var_21_20)
	
	arg_21_0.logo_lang_data = json.decode(SAVE:getUserDefaultData("title_overlap.logo_lang", "")) or {}
	arg_21_0.event_begin_time = var_21_0
	arg_21_0.event_end_time = var_21_1
	arg_21_0.event_json_data = var_21_19
end

function Scene.title.checkTimeData(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = to_n(arg_22_1 or arg_22_0.event_begin_time)
	local var_22_1 = to_n(arg_22_2 or arg_22_0.event_end_time)
	
	return var_22_0 < os.time() and var_22_1 > os.time()
end

function Scene.title.isJPNLoginMode(arg_23_0)
	return Stove:isJPN_ip()
end

function Scene.title.openAgeInfo(arg_24_0)
	if not get_cocos_refid(arg_24_0.dlg_login) then
		return 
	end
	
	local var_24_0 = arg_24_0.dlg_login:getChildByName("n_age_info_zl")
	
	if not get_cocos_refid(var_24_0) then
		return 
	end
	
	UIAction:Add(FADE_IN(200), var_24_0, "block")
	BackButtonManager:push({
		check_id = "Dialog.ageinfo",
		back_func = function()
			arg_24_0:closeAgeInfo()
		end,
		dlg = arg_24_0.dlg_login
	})
end

function Scene.title.closeAgeInfo(arg_26_0)
	if not get_cocos_refid(arg_26_0.dlg_login) then
		return 
	end
	
	local var_26_0 = arg_26_0.dlg_login:getChildByName("n_age_info_zl")
	
	if not get_cocos_refid(var_26_0) then
		return 
	end
	
	UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), var_26_0, "block")
	BackButtonManager:pop({
		check_id = "Dialog.ageinfo",
		dlg = arg_26_0.dlg_login
	})
end

function Scene.title.onEnter(arg_27_0)
	print("title.onEnter")
	print("Stove.enable : ", Stove.enable)
	print("user_language : ", getUserLanguage())
	print("patch.local.lang(media lang) : ", getMediaLanguage())
	
	if IS_ANDROID_BASED_PLATFORM then
		local var_27_0 = getenv("android.distribution_format") or "nil"
		
		print("android.distribution_format: " .. var_27_0)
	end
	
	local var_27_1 = load_dlg("login", true, "wnd")
	
	if not get_cocos_refid(var_27_1) then
		return 
	end
	
	local var_27_2 = var_27_1:getChildByName("enter_id")
	
	if get_cocos_refid(var_27_2) then
		var_27_2:setVisible(false)
	end
	
	var_27_1:setOpacity(0)
	if_set_visible(var_27_1, "touch", false)
	if_set_visible(var_27_1, "btn_access_account_jpn", false)
	var_27_1:findChildByName("btn_stove_login_jpn"):getChildByName("label"):setString(T("ui_login_btn_login"))
	if_set_visible(var_27_1, "n_selected_world", false)
	if_set_visible(var_27_1, "n_selected_world_zl", false)
	var_27_1:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	arg_27_0.layer:addChild(var_27_1)
	SysAction:Add(SEQ(DELAY(500), FADE_IN(500)), var_27_1)
	
	arg_27_0.dlg_login = var_27_1
	
	arg_27_0:showStoveLoginUI(false)
	arg_27_0:showStoveWorldSelectUI(false)
	arg_27_0:refreshSelectedStoveWorldUI()
	arg_27_0:updateVersionInfo()
	
	local var_27_3 = arg_27_0:getAgeLimitNode()
	
	if get_cocos_refid(var_27_3) then
		UIAction:Add(SEQ(SHOW(), FADE_IN(1500)), var_27_3, "block")
	end
	
	arg_27_0:updateOffset()
	
	if PLATFORM == "win32" then
		local var_27_4 = getenv("app.data_path") .. "/config.db"
		local var_27_5 = io.open(var_27_4, "r")
		
		if var_27_5 then
			local var_27_6 = var_27_5:seek()
			local var_27_7 = var_27_5:seek("end")
			
			var_27_5:close()
			
			if var_27_7 > 31457280 then
				Dialog:msgBox("설정정보가 비정상입니다. testors 에게 알려 주세요.\nconfig size:" .. comma_value(math.floor(var_27_7 / 1048576)) .. "MB", {})
			end
		end
	end
	
	if PrePrologue and PLATFORM ~= "win32" then
		PrePrologue:clear()
		
		PrePrologue = nil
	end
	
	if IS_PUBLISHER_ZLONG then
		arg_27_0:setZlongTermsCheckbox(SAVE:getUserDefaultData("zlong_check_terms", false))
	end
	
	arg_27_0.vars.db_load = false
end

function Scene.title.setZlongTermsCheckbox(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.dlg_login:findChildByName("chk_zlong_terms")
	
	if get_cocos_refid(var_28_0) then
		var_28_0:setSelected(arg_28_1)
	end
end

function Scene.title.onChangeResolution(arg_29_0)
	print("title onChangeResolution")
	arg_29_0:updateOffset()
end

function Scene.title.updateOffset(arg_30_0)
	if not get_cocos_refid(arg_30_0.dlg_login) then
		return 
	end
	
	if_set_position_y(arg_30_0.dlg_login, "n_selected_world", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 12)
	if_set_position_y(arg_30_0.dlg_login, "n_selected_world_waiting_zl", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 131)
	if_set_position_y(arg_30_0.dlg_login, "btn_stove_login_jpn", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 12)
	if_set_position_y(arg_30_0.dlg_login, "n_notice", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 131)
	if_set_position_y(arg_30_0.dlg_login, "n_notice_zl", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 12)
	if_set_position_y(arg_30_0.dlg_login, "n_logout", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 71)
	if_set_content_size(arg_30_0.dlg_login, "btn_go", TITLE_WIDTH, TITLE_HEIGHT)
	if_set_position_y(arg_30_0.dlg_login, "n_terms_zl", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 60)
	if_set_position_y(arg_30_0.dlg_login, "download_reward_zl", 0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 125)
	if_set_position_y(arg_30_0:getAgeLimitNode(), nil, 626 + (TITLE_HEIGHT - VIEW_HEIGHT) / 2)
	
	local var_30_0 = TITLE_WIDTH / DESIGN_WIDTH
	local var_30_1 = TITLE_HEIGHT / DESIGN_HEIGHT
	
	if arg_30_0:isShowChinaAgeLimit() then
		local var_30_2 = arg_30_0.dlg_login:getChildByName("n_age_info_zl")
		
		if get_cocos_refid(var_30_2) then
			local var_30_3 = var_30_2:getChildByName("grow")
			
			if get_cocos_refid(var_30_3) then
				var_30_3.origin_scale_x = var_30_3.origin_scale_x or var_30_3:getScaleX()
				
				var_30_3:setScaleX(var_30_3.origin_scale_x * var_30_0)
				
				var_30_3.origin_scale_y = var_30_3.origin_scale_y or var_30_3:getScaleY()
				
				var_30_3:setScaleY(var_30_3.origin_scale_y * var_30_1)
			end
		end
	end
end

function Scene.title.isShowChinaAgeLimit(arg_31_0)
	return IS_PUBLISHER_ZLONG
end

function Scene.title.isShowKoreaAgeLimit(arg_32_0)
	if getCompositiveCountry() ~= "KR" then
		return false
	end
	
	if PLATFORM == "iphoneos" then
		return true
	end
	
	if not PRODUCTION_MODE and PLATFORM == "win32" then
		return true
	end
	
	return false
end

function Scene.title.getAgeLimitNodeName(arg_33_0)
	if arg_33_0:isShowChinaAgeLimit() then
		return "icon_age_zl"
	end
	
	if arg_33_0:isShowKoreaAgeLimit() then
		return "icon_age"
	end
	
	return nil
end

function Scene.title.getAgeLimitNode(arg_34_0)
	if not get_cocos_refid(arg_34_0.dlg_login) then
		return 
	end
	
	local var_34_0 = arg_34_0:getAgeLimitNodeName()
	
	if not var_34_0 then
		return 
	end
	
	return arg_34_0.dlg_login:getChildByName(var_34_0)
end

function Scene.title.onLeave(arg_35_0)
end

function Scene.title.updateVersionInfo(arg_36_0)
	TitleBackground:updateVersionInfo()
end

function Scene.title.onUnload(arg_37_0)
	SysAction:Remove("touch")
	Patch:hide()
	TitleBackground:hide()
	collect_resources_paths()
end

function Scene.title.setStatusText(arg_38_0, arg_38_1)
	local var_38_0 = cc.Director:getInstance():getRunningScene():getChildByName("txt_status")
	
	if var_38_0 then
		var_38_0:setString(arg_38_1)
	end
end

function Scene.title.isSkipAskDownload(arg_39_0)
	if not IS_PUBLISHER_ZLONG then
		return false
	end
	
	if not IS_ANDROID_BASED_PLATFORM then
		return false
	end
	
	if not get_network_state then
		return false
	end
	
	return get_network_state() == "wifi"
end

function Scene.title.askZlongPreStandbyDownload(arg_40_0)
	if getenv("patch.status") ~= "ask_download" then
		return false
	end
	
	if arg_40_0:isSkipAskDownload() then
		setenv("patch.status", "downloading")
		Zlong:gameEventLog(ZLONG_LOG_CODE.CDN_PATCH_START)
		
		return false
	end
	
	if not PatchDownloadPopup:isShowPopupPatchDownload() then
		PatchDownloadPopup:show(arg_40_0.layer, false, {
			callback_ok = function()
				arg_40_0:reloadTitle()
			end
		})
	end
	
	return true
end

function Scene.title.setZlongPreStandbyMode(arg_42_0)
	if not Zlong.enable then
		return false
	end
	
	if getenv("verinfo.status") ~= "pre_standby" then
		return false
	end
	
	if get_cocos_refid(arg_42_0.pre_standby_dlg) then
		Patch:updateMaintenanceLeftTime(arg_42_0.pre_standby_dlg, getenv("pre_standby.display.open_time"))
		
		return true
	end
	
	arg_42_0.pre_standby_dlg = Patch:showMaintenanceDlg({
		show_server_change = false,
		custom_layer = true,
		title = getenv("pre_standby.display.title.zhs_zl", ""),
		msg = getenv("pre_standby.display.msg.zhs_zl", ""),
		retry_handler = function()
			restart_contents()
		end
	})
	
	arg_42_0.dlg_login:addChild(arg_42_0.pre_standby_dlg)
	
	Patch.event_timer = nil
	
	arg_42_0.pre_standby_dlg:setPositionX(DESIGN_WIDTH / 2)
	arg_42_0.pre_standby_dlg:setPositionY(DESIGN_HEIGHT / 2)
	
	return true
end

function Scene.title.onAfterDraw(arg_44_0)
	local var_44_0 = Login.FSM:getCurrentStateString()
	
	arg_44_0:setStatusText(var_44_0)
	
	local var_44_1 = getenv("patch.status")
	
	if var_44_1 == "complete" and not arg_44_0.vars.patch_completed then
		arg_44_0.vars.patch_completed = true
		
		arg_44_0:updateVersionInfo()
	end
	
	Zlong:pollingForLog()
	
	if Login.FSM:isCurrentState(LoginState.STOVE_WAIT_LOGIN) then
		return 
	end
	
	arg_44_0:updatePatchGaugeServerList()
	
	if Login.FSM:isCurrentState(LoginState.ZLONG_PRE_STANDBY_DOWNLOAD) then
		arg_44_0:askZlongPreStandbyDownload()
		
		return 
	end
	
	if Login.FSM:isCurrentState(LoginState.ZLONG_PRE_STANDBY_MAINTENANCE) then
		arg_44_0:setZlongPreStandbyMode()
		
		return 
	end
	
	if Login.FSM:isCurrentState(LoginState.MAINTENANCE_REGION) then
		if not get_cocos_refid(arg_44_0.region_maintenance_popup) then
			arg_44_0:showRegionServerMaintenanceDlg()
		else
			arg_44_0:refreshRegionMaintenanceDlg()
		end
		
		return 
	end
	
	if arg_44_0.vars.need_to_touch then
		return 
	end
	
	if arg_44_0.vars.isShowCodeUI then
		return 
	end
	
	if Login.FSM:isCurrentState(LoginState.STOVE_SELECT_WORLD) then
		return 
	end
	
	if Account:isLoginComplete() and not SAVE:isPatchCompleteRequired() then
		setenv("patch.background", true)
	else
		setenv("patch.background", nil)
	end
	
	if Account:isLoginComplete() and SAVE:isPatchCompleteRequired() then
		setenv("tutorial.status", "complete")
	end
	
	if Login.FSM:isCurrentState(LoginState.STANDBY) then
		if Account:isLoginComplete() and getenv("patch.status") == "ask_download" then
			if arg_44_0:isSkipAskDownload() then
				setenv("patch.status", "downloading")
				Zlong:gameEventLog(ZLONG_LOG_CODE.CDN_PATCH_START)
			else
				if not PatchDownloadPopup:isShowPopupPatchDownload() then
					arg_44_0:showStoveWorldSelectUI(false)
					
					local var_44_2 = {
						callback_ok = function()
							arg_44_0:reloadTitle()
						end
					}
					
					PatchDownloadPopup:show(arg_44_0.layer, not SAVE:isPatchCompleteRequired(), var_44_2)
				end
				
				return 
			end
		end
		
		if var_44_1 == "complete" or Account:isLoginComplete() and not SAVE:isPatchCompleteRequired() then
		else
			return 
		end
		
		if not arg_44_0.vars.db_load then
			reload_db()
			
			arg_44_0.vars.db_load = true
		end
		
		arg_44_0:reloadTitle()
		
		if Stove.enable then
			if Login.FSM:isCurrentState("STANDBY") then
				if_set_visible(arg_44_0.dlg_login, "n_logout", Stove:isGuestAccount() == false and (var_44_1 == "complete" or arg_44_0.vars.need_to_touch))
				arg_44_0:setTouchMode(true)
				arg_44_0:refreshSelectedStoveWorldUI()
				
				return 
			end
		else
			arg_44_0:setTouchMode(true)
			arg_44_0:refreshSelectedStoveWorldUI()
			
			return 
		end
	elseif Login.FSM:isCurrentState(LoginState.TICKET_WAIT) then
		arg_44_0:refreshSelectedStoveWorldUI()
		arg_44_0:setTouchMode(false)
		
		return 
	end
	
	if Login.FSM:isCurrentState(LoginState.WAIT_LOGIN) then
		arg_44_0:setMessage(T("waiting_server", "서버가 혼잡하여 접속 대기 중입니다.. (#time#)", {
			time = Login.vars.waiting_left
		}))
		
		return 
	end
end

function Scene.title.setMessage(arg_46_0, arg_46_1)
	arg_46_0.vars.message = arg_46_1
	
	local var_46_0 = cc.Director:getInstance():getRunningScene():getChildByName("txt_message")
	
	if var_46_0 then
		if arg_46_1 then
			var_46_0:setString(arg_46_1)
		else
			var_46_0:setString("")
		end
	end
end

function Scene.title.setTouchMode(arg_47_0, arg_47_1)
	if arg_47_0.vars.isShowCodeUI then
		return 
	end
	
	local var_47_0 = "touch"
	
	if IS_PUBLISHER_ZLONG then
		var_47_0 = "touch_zl"
	end
	
	if not arg_47_0.vars.need_to_touch and arg_47_1 then
		local var_47_1 = arg_47_0.dlg_login:getChildByName(var_47_0)
		
		arg_47_0.vars.need_to_touch = true
		
		arg_47_0:updateVersionInfo()
		SysAction:AddAsync(SEQ(SHOW(true), LOOP(SEQ(FADE_OUT(600), DELAY(300), LOG(FADE_IN(1000)), DELAY(300)))), var_47_1, "touch")
		arg_47_0:setMessage(nil)
		arg_47_0:showStoveLoginUI(false)
		if_set_visible(arg_47_0.dlg_login, "n_logout", arg_47_0.vars.need_to_touch and Stove and Stove:isGuestAccount() == false)
		
		if IS_PUBLISHER_ZLONG then
			if_set_visible(arg_47_0.dlg_login, "touch_glow_zl", true)
			if_set_visible(arg_47_0.dlg_login, "n_terms_zl", getenv("zlong.disable_check_terms", "false") ~= "true")
			if_set_visible(arg_47_0.dlg_login, "n_notice_zl", true)
		end
		
		if IS_PUBLISHER_ZLONG and getenv("zlong.download_reward_enable", "false") == "true" and not cc.UserDefault:getInstance():getBoolForKey("download_reward_disable", false) then
			if_set_visible(arg_47_0.dlg_login, "download_reward_zl", true)
		end
	end
	
	if arg_47_0.vars.need_to_touch and not arg_47_1 then
		local var_47_2 = arg_47_0.dlg_login:getChildByName(var_47_0)
		
		arg_47_0.vars.need_to_touch = nil
		
		var_47_2:setVisible(false)
		var_47_2:setOpacity(0)
		SysAction:Remove("touch")
		if_set_visible(arg_47_0.dlg_login, "touch_glow_zl", false)
		if_set_visible(arg_47_0.dlg_login, "n_terms_zl", false)
		if_set_visible(arg_47_0.dlg_login, "n_notice_zl", false)
		if_set_visible(arg_47_0.dlg_login, "download_reward_zl", false)
	end
end

function Scene.title.showStoveLoginUI(arg_48_0, arg_48_1)
	if get_cocos_refid(arg_48_0.dlg_login) then
		arg_48_0.vars.isShowStoveLoginUI = arg_48_1
		
		if arg_48_0:isJPNLoginMode() then
			if_set_visible(arg_48_0.dlg_login, "n_login", false)
			if_set_visible(arg_48_0.dlg_login, "n_login_jpn", arg_48_1)
		else
			if_set_visible(arg_48_0.dlg_login, "n_login", arg_48_1)
			if_set_visible(arg_48_0.dlg_login, "n_login_jpn", false)
		end
		
		if IS_PUBLISHER_ZLONG then
			if_set_visible(arg_48_0.dlg_login, "btn_guest_login", false)
		end
	end
end

function Scene.title.updatePatchGaugeServerList(arg_49_0)
	if not arg_49_0.vars.adjust_world_select_ui then
		return 
	end
	
	local var_49_0 = arg_49_0.dlg_login:getChildByName("n_world_select")
	
	if not var_49_0 or not var_49_0:isVisible() then
		return 
	end
	
	local var_49_1 = var_49_0:getChildByName("progress_bar_01")
	local var_49_2 = var_49_0:getChildByName("progress_bar_02")
	
	if not var_49_1 then
		return 
	end
	
	local var_49_3 = getenv("patch.status", "") == "complete"
	
	if_set_visible(var_49_0, "t_percent_02", var_49_3)
	if_set_visible(var_49_0, "t_percent_01", not var_49_3)
	if_set_visible(var_49_1, nil, not var_49_3)
	if_set_visible(var_49_2, nil, var_49_3)
	
	if getenv("patch.status", "") ~= "complete" then
		local var_49_4 = PatchGauge:getPercent() * 100
		
		var_49_1:setPercent(var_49_4)
		
		local var_49_5 = string.format("%.1f%%", var_49_4)
		
		if_set(var_49_0, "t_percent_01", var_49_5)
	else
		if_set(var_49_0, "t_percent_02", "100.0%")
	end
end

function Scene.title.showStoveWorldSelectUI(arg_50_0, arg_50_1)
	print("showStoveWorldSelectUI", arg_50_1)
	
	arg_50_0.vars.isShowStoveWorldSelectUI = arg_50_1
	
	local var_50_1, var_50_3, var_50_4, var_50_10
	
	if get_cocos_refid(arg_50_0.dlg_login) then
		local var_50_0 = "n_world_select"
		
		if IS_PUBLISHER_ZLONG then
			var_50_0 = "n_world_select_zl"
		end
		
		var_50_1 = arg_50_0.dlg_login:getChildByName(var_50_0)
		
		if not var_50_1 then
			return 
		end
		
		var_50_1:setVisible(arg_50_1)
		
		if not arg_50_1 then
			return 
		end
		
		var_50_1:bringToFront()
		
		local var_50_2 = string.split(getenv("zlong.display_server_list", "zlong1"), ",")
		
		var_50_3 = {}
		var_50_4 = getRecommendRegion()
		
		if IS_PUBLISHER_ZLONG then
			if table.find(var_50_2, "zlong1") then
				table.insert(var_50_3, {
					region = "zlong1",
					character_info = {}
				})
			end
			
			if table.find(var_50_2, "zlong2") then
				table.insert(var_50_3, {
					region = "zlong2",
					character_info = {}
				})
			end
			
			if table.find(var_50_2, "zlong3") then
				table.insert(var_50_3, {
					region = "zlong3",
					character_info = {}
				})
			end
			
			if table.find(var_50_2, "zlong4") then
				table.insert(var_50_3, {
					region = "zlong4",
					character_info = {}
				})
			end
			
			if table.find(var_50_2, "zlong5") then
				table.insert(var_50_3, {
					region = "zlong5",
					character_info = {}
				})
			end
			
			var_50_4 = getenv("zlong.recommend_region", "zlong1")
			
			print("zlong.recommend_region", var_50_4)
		else
			var_50_3 = Stove:getServerList()
		end
		
		print("server info list : ")
		table.print(var_50_3)
		
		local var_50_5 = var_50_1:findChildByName("frame")
		
		arg_50_0.vars.frame_size = arg_50_0.vars.frame_size or var_50_5:getContentSize()
		arg_50_0.vars.frame_y = arg_50_0.vars.frame_y or var_50_1:getPositionY()
		
		local var_50_6 = getenv("patch.status", "") == "complete" and 1 or 0
		
		if IS_PUBLISHER_ZLONG then
			var_50_6 = 0
		end
		
		local var_50_7 = (MAX_REGION_COUNT - table.count(var_50_3) + var_50_6) * 90
		
		if_set_visible(var_50_1, "n_download", var_50_6 == 0)
		
		if var_50_6 == 0 then
			local var_50_8 = var_50_1:getChildByName("n_download")
			
			if var_50_8 then
				var_50_8:setPositionY(var_50_7)
			end
		end
		
		var_50_5:setContentSize(arg_50_0.vars.frame_size.width, arg_50_0.vars.frame_size.height - var_50_7)
		var_50_1:setPositionY(arg_50_0.vars.frame_y - var_50_7 * 0.5)
		
		if not IS_PUBLISHER_ZLONG then
			arg_50_0.vars.adjust_world_select_ui = true
		end
		
		local var_50_9 = var_50_1:getChildByName("grow")
		
		var_50_9:setScaleX(DEVICE_WIDTH)
		var_50_9:setScaleY(DESIGN_HEIGHT)
		
		var_50_10 = Login:getRegion()
		
		if Login.FSM:isCurrentState(LoginState.MAINTENANCE_REGION) then
			var_50_10 = Login:getMaintenanceRegion()
		end
		
		for iter_50_0 = 1, MAX_REGION_COUNT do
			local var_50_11 = var_50_3[iter_50_0]
			local var_50_12 = var_50_1:getChildByName("n_region_" .. iter_50_0)
			
			if var_50_11 then
				local var_50_13 = var_50_11.region
				local var_50_14 = var_50_11.character_info
				
				if var_50_12 then
					var_50_12:setVisible(true)
					print("btn_world_" .. tostring(iter_50_0), var_50_13)
					
					var_50_12:getChildByName("btn_world_" .. tostring(iter_50_0)).region = var_50_13
					
					var_50_12:getChildByName("label_world_" .. tostring(iter_50_0)):setString(T(var_50_13 .. "_server"))
					var_50_12:getChildByName("icon_check_" .. tostring(iter_50_0)):setVisible(tostring(var_50_10 or "") == var_50_13)
					var_50_12:getChildByName("recommend_" .. tostring(iter_50_0)):setVisible(var_50_4 == var_50_13)
					if_set_visible(var_50_12, "n_level_info_" .. iter_50_0, var_50_14.nickname)
					if_set_visible(var_50_12, "t_nickname_" .. iter_50_0, var_50_14.nickname)
					if_set_visible(var_50_12, "n_no_account_" .. iter_50_0, not var_50_14.nickname)
					
					if var_50_14.nickname then
						local var_50_15 = string.find(var_50_14.nickname, "_")
						
						if var_50_15 then
							local var_50_16 = string.sub(var_50_14.nickname, 1, var_50_15 - 1)
							
							if_set(var_50_1, "t_nickname_" .. iter_50_0, var_50_16)
						else
							if_set(var_50_1, "t_nickname_" .. iter_50_0, var_50_14.nickname)
						end
						
						UIUtil:warpping_setLevel(var_50_1:getChildByName("n_level_info_" .. iter_50_0), tonumber(var_50_14.level or 1), nil, 2)
					end
				end
			else
				if_set_visible(var_50_12, nil, false)
			end
		end
	end
end

function Scene.title.refreshRegionMaintenanceDlg(arg_51_0)
	if not get_cocos_refid(arg_51_0.region_maintenance_popup) or arg_51_0.region_maintenance_popup:getName() ~= "#MAINTENANCE" then
		return 
	end
	
	local var_51_0 = Login:getMaintenanceRegion()
	
	if var_51_0 then
		local var_51_1 = Patch:getMaintenanceTitle(var_51_0)
		local var_51_2 = Patch:getMaintenanceMessage(var_51_0)
		local var_51_3 = string.gsub(var_51_2, "\\n", "\n")
		
		Patch:updateMaintenanceLeftTime(arg_51_0.region_maintenance_popup, tonumber(getenv("maintenance_end.world_" .. var_51_0)))
		if_set(arg_51_0.region_maintenance_popup, "txt_change", T(var_51_0 .. "_server"))
		if_set(arg_51_0.region_maintenance_popup, "t_title", var_51_1)
		if_set(arg_51_0.region_maintenance_popup, "t_disc", var_51_3)
	end
end

function Scene.title.showRegionServerMaintenanceDlg(arg_52_0)
	print("showRegionServerMaintenance region: ", Login:getMaintenanceRegion())
	
	if not get_cocos_refid(arg_52_0.region_maintenance_popup) and Login:getMaintenanceRegion() then
		arg_52_0.region_maintenance_popup = Patch:showMaintenanceDlg({
			show_server_change = true,
			custom_layer = true,
			region = Login:getMaintenanceRegion(),
			retry_handler = function()
				setenv("needChangeRegion", Login:getMaintenanceRegion())
				restart_contents()
			end
		})
		
		arg_52_0.region_maintenance_popup:getChildByName("btn_server"):addTouchEventListener(function(arg_54_0, arg_54_1)
			if arg_54_1 == ccui.TouchEventType.ended then
				if not Stove:isGuestAccount() then
					arg_52_0:showStoveWorldSelectUI(true)
				else
					balloon_message_with_sound("guest_not_allow_server_change")
				end
			end
		end)
		
		if get_cocos_refid(Patch.layer and Patch.layer:getChildByName("maintenance_title_black_board")) then
			Patch.layer:getChildByName("maintenance_title_black_board"):setVisible(true)
		end
		
		arg_52_0.dlg_login:addChild(arg_52_0.region_maintenance_popup)
		
		Patch.event_timer = nil
		
		arg_52_0.region_maintenance_popup:setPositionX(DESIGN_WIDTH / 2)
		arg_52_0.region_maintenance_popup:setPositionY(DESIGN_HEIGHT / 2)
	end
end

function Scene.title.refreshSelectedStoveWorldUI(arg_55_0)
	if get_cocos_refid(arg_55_0.dlg_login) then
		local var_55_0 = "n_selected_world"
		local var_55_1 = "label_selected_server"
		local var_55_2 = Login:getRegion()
		
		if IS_PUBLISHER_ZLONG then
			if_set_visible(arg_55_0.dlg_login, "n_selected_world", false)
			
			var_55_0 = "n_selected_world_zl"
			var_55_1 = "label_selected_server_zl"
			
			if not var_55_2 or var_55_2 == "" then
				local var_55_3 = getenv("zlong.recommend_region", "zlong1")
				
				var_55_2 = Login:getLocalSavedRegion(var_55_3)
			end
		end
		
		local var_55_4 = Login.FSM:getCurrentStateString()
		
		if getenv("is_review", "") ~= "1" and (var_55_4 == "STANDBY" or var_55_4 == "TICKET_WAIT") then
			local var_55_5 = arg_55_0.dlg_login:getChildByName(var_55_0)
			
			if var_55_5 and var_55_2 then
				if IS_PUBLISHER_ZLONG and var_55_4 == "TICKET_WAIT" then
					var_55_5:setVisible(false)
				else
					var_55_5:setVisible(true)
				end
				
				if_set(var_55_5, var_55_1, T(tostring(var_55_2) .. "_server"))
				
				if not Stove:isGuestAccount() then
					var_55_5:getChildByName("Img_icon"):setOpacity(128)
				else
					var_55_5:getChildByName("Img_icon"):setOpacity(20)
				end
				
				if var_55_4 ~= "TICKET_WAIT" then
					arg_55_0:updateVersionInfo()
				end
			end
		else
			if_set_visible(arg_55_0.dlg_login, "n_selected_world_zl", false)
			if_set_visible(arg_55_0.dlg_login, "n_selected_world", false)
			if_set_visible(arg_55_0.dlg_login, "n_logout", false)
		end
	end
end

function Scene.title.showEnterCodeUI(arg_56_0)
	arg_56_0.vars.isShowCodeUI = true
	
	SysAction:Add(SEQ(DELAY(500), FADE_IN(500)), arg_56_0.dlg_login:getChildByName("enter_id"))
end

function Scene.title.showWaitServerDlg(arg_57_0, arg_57_1)
	if get_cocos_refid(arg_57_0.dlg_login) then
		if not get_cocos_refid(arg_57_0.n_wait_queue) then
			arg_57_0.n_wait_queue = arg_57_0.dlg_login:getChildByName("n_queue")
		end
		
		arg_57_0.n_wait_queue:setVisible(true)
		if_set(arg_57_0.n_wait_queue, "txt_info", T("login_wait_desc", {
			count = arg_57_1 or 0
		}))
		
		local var_57_0 = arg_57_0.dlg_login:getChildByName("n_selected_world_waiting_zl")
		
		var_57_0:setVisible(true)
		
		local var_57_1 = getenv("zlong.recommend_region", "zlong1")
		local var_57_2 = Login:getLocalSavedRegion(var_57_1)
		
		if_set(var_57_0, "label_selected_server_waiting_zl", T(var_57_2 .. "_server"))
		if_set_visible(arg_57_0.dlg_login, "n_logout", true)
		if_set_visible(arg_57_0.dlg_login, "n_notice_zl", true)
	end
end

function Scene.title.unshowWaitServerDlg(arg_58_0)
	if get_cocos_refid(arg_58_0.dlg_login) then
		if not get_cocos_refid(arg_58_0.n_wait_queue) then
			arg_58_0.n_wait_queue = arg_58_0.dlg_login:getChildByName("n_queue")
		end
		
		arg_58_0.n_wait_queue:setVisible(false)
		if_set_visible(arg_58_0.dlg_login, "n_selected_world_waiting_zl", false)
		if_set_visible(arg_58_0.dlg_login, "n_logout", false)
		if_set_visible(arg_58_0.dlg_login, "n_notice_zl", false)
	end
end

function Scene.title.onButtonGo(arg_59_0)
	if not arg_59_0.vars.need_to_touch then
		return 
	end
	
	arg_59_0:setTouchMode(false)
	print("isJPN IP: ", Stove:isJPN_ip(), "isAlterDbRequired:", Account:isAlterDbRequired())
	
	if Login.FSM:isCurrentState(LoginState.STANDBY) then
		local var_59_0 = true
		
		if IS_PUBLISHER_ZLONG and getenv("zlong.disable_check_terms", "false") ~= "true" then
			var_59_0 = SAVE:getUserDefaultData("zlong_check_terms", false)
			
			if not var_59_0 then
				balloon_message("请详细阅读并同意《用户协议》和《隐私保护指引》")
			end
		end
		
		if var_59_0 then
			arg_59_0:startGame()
		else
			arg_59_0:setTouchMode(true)
		end
	else
		arg_59_0:setTouchMode(true)
	end
end

function Scene.title.startGame(arg_60_0)
	if not arg_60_0.vars.started then
		reload_master_sound()
		
		SoundEngine.START_SOUND_NODE = SoundEngine:play("event:/ui/start_sound")
		
		if Zlong.enable then
			Zlong:startGame()
			Zlong:gameEventLog(ZLONG_LOG_CODE.TAP_TO_START)
		end
		
		local var_60_0 = arg_60_0:getMusicHandle() or TitleBackground:getMusicHandle()
		
		if get_cocos_refid(var_60_0) then
			local var_60_1 = var_60_0:getVolume()
			
			UIAction:Add(SPAWN(SEQ(DELAY(800), CALL(function()
				SoundEngine:playBGM("event:/bgm/default")
			end)), SEQ(REPEAT(40, SEQ(DELAY(50), CALL(function()
				if get_cocos_refid(var_60_0) and var_60_1 > 0 then
					var_60_1 = var_60_1 - 0.01
					
					var_60_0:setVolume(var_60_1)
				end
			end))), CALL(function()
				if get_cocos_refid(var_60_0) then
					var_60_0:stop()
				end
			end))), {}, "title_bgm_fader")
		end
		
		UIOption:UpdateScreenOnState()
		
		arg_60_0.vars.started = true
		
		local var_60_2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_60_2:setOpacity(0)
		var_60_2:setAnchorPoint(0, 0)
		var_60_2:setPosition(VIEW_BASE_LEFT, 0 - HEIGHT_MARGIN / 2)
		SceneManager:getRunningNativeScene():addChild(var_60_2)
		SysAction:Add(SEQ(FADE_IN(1200), CALL(startGame)), var_60_2)
		set_fps(DEFAULT_DISPLAY_FPS)
		
		if cc.UserDefault:getInstance():getBoolForKey("tune.v3_cdn_touch", false) and not cc.UserDefault:getInstance():getBoolForKey("tune.new_start", false) then
			Singular:event("new_start")
			print("Tune Log : new_start")
			cc.UserDefault:getInstance():setBoolForKey("tune.new_start", true)
		end
	end
end
