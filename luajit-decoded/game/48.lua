Singular = Singular or {}

function Singular.event(arg_1_0, arg_1_1, ...)
	if not Stove.enable then
		return 
	end
	
	if not tracking_custom_event then
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "collection" then
		return 
	end
	
	Log.d("Singular event", arg_1_1, ...)
	tracking_custom_event(arg_1_1, ...)
end

function Singular.introLog(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return 
	end
	
	local var_2_0 = tonumber(arg_2_1)
	
	if var_2_0 == 4 then
		return 
	end
	
	if var_2_0 >= 5 then
		var_2_0 = var_2_0 - 1
	end
	
	Singular:event("intro_log " .. var_2_0)
end

function Singular.attendanceEvent(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return 
	end
	
	if arg_3_1.event_name and string.starts(arg_3_1.event_name, "newbie") and arg_3_1.progress_day and tonumber(arg_3_1.progress_day) == 1 and arg_3_1.reward_received then
		Singular:event("calendar_reward_" .. arg_3_1.event_name)
	end
end

function Singular.loginEvent(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if not Stove.enable then
		return 
	end
	
	if not tracking_login_event then
		return 
	end
	
	Log.d("Singular loginEvent", arg_4_1, arg_4_2, arg_4_3)
	tracking_login_event(arg_4_1, arg_4_2, arg_4_3)
end

function Singular.purchase(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not Stove.enable then
		return 
	end
	
	if not tracking_purchase_event then
		return 
	end
	
	Log.d("Singular event", arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	tracking_purchase_event(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
end

Singular.movie_start_event_ids = {}
Singular.movie_start_event_ids["mov1_1_10.mp4"] = "v_chapter_01_0110"
Singular.movie_start_event_ids["mov1_2_10.mp4"] = "v_chapter_01_0210"
Singular.movie_start_event_ids["mov1_3_10.mp4"] = "v_chapter_01_0304"
Singular.movie_start_event_ids["mov1_7_9.mp4"] = "v_chapter_01_0709"
Singular.movie_start_event_ids["mov1_10_9.mp4"] = "v_chapter_01_1009"

function Singular.movieStartEvent(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.movie_start_event_ids[arg_6_1]
	
	if not var_6_0 then
		return 
	end
	
	arg_6_0:event(var_6_0)
end

Singular.movie_end_event_ids = {}

function Singular.movieEndEvent(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.movie_end_event_ids[arg_7_1]
	
	if not var_7_0 then
		return 
	end
	
	arg_7_0:event(var_7_0)
end

Singular.tutorial_start_event_ids = {}

function Singular.tutorialStartEvent(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.tutorial_start_event_ids[arg_8_1]
	
	if not var_8_0 then
		return 
	end
	
	arg_8_0:event(var_8_0)
end

Singular.tutorial_end_event_ids = {}
Singular.tutorial_end_event_ids.guide_quest = "tutorial_growth_guide"
Singular.tutorial_end_event_ids.guide_quest2 = "tutorial_growth_guide"
Singular.tutorial_end_event_ids.summon_select = "tutorial_selective_summon"
Singular.tutorial_end_event_ids.equip_install = "tutorial_equip_upgrade"
Singular.tutorial_end_event_ids.system_011 = "first_gacha"
Singular.tutorial_end_event_ids.system_059_09 = "first_power_up"
Singular.tutorial_end_event_ids.tuto_destiny_moonlight = "Moonlight_Connections_tutorial_01"
Singular.tutorial_end_event_ids.tuto_destiny_moonlight2 = "Moonlight_Connections_tutorial_02"

function Singular.tutorialEndEvent(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.tutorial_end_event_ids[arg_9_1]
	
	if not var_9_0 then
		return 
	end
	
	arg_9_0:event(var_9_0)
end

Singular.story_start_event_ids = {}

function Singular.storyStartEvent(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.story_start_event_ids[arg_10_1]
	
	if not var_10_0 then
		return 
	end
	
	arg_10_0:event(var_10_0)
end

Singular.story_end_event_ids = {}

function Singular.storyEndEvent(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.story_end_event_ids[arg_11_1]
	
	if not var_11_0 then
		return 
	end
	
	arg_11_0:event(var_11_0)
end
