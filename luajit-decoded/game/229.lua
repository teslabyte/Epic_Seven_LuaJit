Scene.cinema = SceneHandler:create("cinema", 1280, 720)
CINEMA_TIMES = {}
CINEMA_TIMES["cinema/event_01.mp4"] = 10800
CINEMA_TIMES["cinema/zht/event_01.mp4"] = 5800
CINEMA_TIMES["cinema/event_02.mp4"] = 78800
CINEMA_TIMES["cinema/zht/event_02.mp4"] = 53800
CINEMA_TIMES["cinema/event_03.mp4"] = 78800
CINEMA_TIMES["cinema/event_covenant.mp4"] = 78800
CINEMA_TIMES["cinema/event_archdemon.mp4"] = 78800
CINEMA_TIMES["cinema/mov1_1_10.mp4"] = 16800
CINEMA_TIMES["cinema/mov1_2_0.mp4"] = 93800
CINEMA_TIMES["cinema/mov1_2_10.mp4"] = 20800
CINEMA_TIMES["cinema/mov1_3_10.mp4"] = 18800
CINEMA_TIMES["cinema/mov1_7_9.mp4"] = 21800
CINEMA_TIMES["cinema/mov1_8_10.mp4"] = 12800
CINEMA_TIMES["cinema/mov1_10_9.mp4"] = 24800
CINEMA_TIMES["cinema/mov1_10_10.mp4"] = 11800
CINEMA_TIMES["cinema/mov1_10_10_1.mp4"] = 14800
CINEMA_TIMES["cinema/pvp_01.mp4"] = 44800
CINEMA_FI_TIME = 500
CINEMA_FO_TIME = 500

function Scene.cinema.onLoad(arg_1_0, arg_1_1)
	print("cinema Scene onLoad")
	
	arg_1_0.vars = {}
	arg_1_0.layer = arg_1_0:getCinemaLayer(arg_1_1)
	
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.3)
	
	arg_1_0.callback = arg_1_1.callback
	
	if MusicBox:isPlaying() and not MusicBox:isEnableScene(SceneManager:getCurrentSceneName()) then
		MusicBox:stop({
			is_disable_scene = true
		})
	end
	
	SoundEngine:stopAllMusic()
	
	if arg_1_1.path then
		BackButtonManager:push({
			check_id = "Cinema.skip",
			id = "Cinema.skip",
			back_func = function()
				if not get_cocos_refid(arg_1_0.videoPlayer) then
					return 
				end
				
				if arg_1_0.videoPlayer._start_time and arg_1_0.videoPlayer._start_time + 2 <= os.time() then
					check_cool_time(arg_1_0.videoPlayer, "skip_video", 2000, function()
						arg_1_0.videoPlayer:executeVideoSkip(T("movie_skip_toast"))
					end, function()
						balloon_message_with_sound("movie_skip_toast")
					end, true)
				end
			end
		})
	end
end

function Scene.cinema.addNextMovie(arg_5_0, arg_5_1)
	if get_cocos_refid(arg_5_0.layer) then
		arg_5_0.layer:removeFromParent()
	end
	
	arg_5_0.videoPlayer = nil
	arg_5_0.layer = nil
	arg_5_0.is_finished = false
	arg_5_0.layer = arg_5_0:getCinemaLayer({
		path = arg_5_1
	})
	
	SceneManager:getRunningNativeScene():addChild(arg_5_0.layer)
end

function Scene.cinema.getCinemaLayer(arg_6_0, arg_6_1)
	local var_6_0 = cc.Layer:create()
	
	arg_6_0.vars = {}
	
	if arg_6_1.story then
		start_new_story(var_6_0, arg_6_1.story)
	elseif arg_6_1.path then
		local function var_6_1(arg_7_0)
			if arg_7_0 then
				arg_6_0:finiThisScene()
			end
		end
		
		arg_6_0.videoPlayer = create_movie_clip(arg_6_1.path, true, var_6_1)
		
		var_6_0:addChild(arg_6_0.videoPlayer)
		
		FPS_BEFORE_PLAY = CURRENT_DISPLAY_FPS
		
		set_scene_fps(30)
		
		arg_6_0.vars.start_tick = systick()
		arg_6_0.vars.offset_time = 0
		arg_6_0.vars.file_name = arg_6_1.path
		
		print("PLAY MOVIE", arg_6_1.path)
		Singular:movieStartEvent(arg_6_0.vars.file_name)
		
		if arg_6_1.path == "cinema/event_01.mp4" and SAVE:getTutorialCounter() <= TOTURIALCOUNT.START_EVENT_01_CINEMA then
			SAVE:saveTutorialCount(TOTURIALCOUNT.START_INTRO_STORY_D)
		end
	end
	
	if getenv("patch.status") ~= "complete" then
		PatchGauge:sideShow(false)
	end
	
	return var_6_0
end

function Scene.cinema.onUnload(arg_8_0)
	BackButtonManager:pop({
		check_id = "Cinema.skip"
	})
	
	if get_cocos_refid(arg_8_0.layer) then
		arg_8_0.layer:removeFromParent()
	end
end

function Scene.cinema.onEnter(arg_9_0)
	print("cinema Scene OnEnter")
end

function Scene.cinema.onAfterDraw(arg_10_0)
	if arg_10_0.vars.is_open_error_msg_box then
		return 
	end
	
	if arg_10_0.vars then
		local var_10_0 = math.max(math.min(to_n(getenv("time_scale")), 1.2), 0.1)
		
		arg_10_0.vars.offset_time = (arg_10_0.vars.offset_time or 0) + cc.Director:getInstance():getDeltaTime() * 1000 / var_10_0
	end
	
	local var_10_1
	
	if not arg_10_0.is_finished and get_cocos_refid(arg_10_0.videoPlayer) then
		local var_10_2 = 1
		local var_10_3 = 0
		local var_10_4 = 1
		local var_10_5 = 2
		local var_10_6 = 3
		local var_10_7 = 4
		
		if arg_10_0.videoPlayer.getVersion then
			var_10_2 = arg_10_0.videoPlayer:getVersion()
		end
		
		if var_10_2 < 2 then
			local var_10_8
			local var_10_9 = 0
			
			var_10_5 = 1
			
			local var_10_10 = 2
			local var_10_11 = 2
		end
		
		local var_10_12 = arg_10_0.videoPlayer:getState()
		
		var_10_1 = var_10_12 <= var_10_5
		
		if IS_ANDROID_BASED_PLATFORM then
			if var_10_5 == var_10_12 then
				arg_10_0.videoPlayer:resume()
			end
		elseif var_10_12 == var_10_5 then
			arg_10_0.videoPlayer:resume()
		end
	end
	
	if not var_10_1 and not is_playing_story() and not arg_10_0.is_finished and not is_invalid_media_file then
		arg_10_0:finiThisScene()
	end
end

function Scene.cinema.onLeave(arg_11_0)
end

function Scene.cinema.onTouchDown(arg_12_0, arg_12_1, arg_12_2)
end

function Scene.cinema.finiThisScene(arg_13_0)
	if arg_13_0.is_finished then
		return 
	end
	
	print("cinema Scene finishThisScene")
	set_fps(FPS_BEFORE_PLAY)
	
	arg_13_0.is_finished = true
	
	if arg_13_0.vars and arg_13_0.vars.file_name then
		Singular:movieEndEvent(arg_13_0.vars.file_name)
	end
	
	if arg_13_0.callback then
		arg_13_0.callback()
	else
		local var_13_0 = SAVE:getTutorialCounter()
		
		if arg_13_0.vars.file_name == "cinema/event_02.mp4" and var_13_0 == TOTURIALCOUNT.END_INTRO_STORY_D then
			SAVE:incTutorialCounter()
		end
		
		if SceneManager:getPrevSceneName() == "cinema" and var_13_0 >= TOTURIALCOUNT.START_INTRO_STORY_D then
			startGame()
		end
	end
	
	if getenv("patch.status") ~= "complete" then
		PatchGauge:sideShow(true)
	end
end
