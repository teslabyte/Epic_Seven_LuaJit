Scene.credits = SceneHandler:create("credits", 1280, 720)

function HANDLER.story_movie_skip(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_skip" then
		local var_1_0 = SceneManager:getRunningScene()
		
		var_1_0:pause()
		
		var_1_0.skip_popup = Dialog:msgBox(T("ui_skip_credit"), {
			yesno = true,
			yes_text = T("unit_sell_yes"),
			no_text = T("unit_sell_no"),
			handler = function()
				var_1_0:resume()
				var_1_0:skip()
			end,
			cancel_handler = function()
				print("GOGO LANG LANG")
				var_1_0:resume()
			end
		})
	end
end

function Scene.credits.onLoad(arg_4_0, arg_4_1)
	arg_4_0.arg = arg_4_1
	arg_4_0.finished = false
	arg_4_0.time = {}
	
	if arg_4_0.arg.quest_id == arg_4_0:getLastQuestIdOfLastEp() then
		arg_4_0.layer = arg_4_0:getCreditsLayer(arg_4_0.arg)
		
		arg_4_0:setTransition(cc.TransitionCrossFade, 0.3)
		set_scene_fps(24)
	else
		arg_4_0:skip()
	end
end

function Scene.credits.getLastQuestIdOfLastEp(arg_5_0)
	local var_5_0
	
	for iter_5_0 = 1, 9999 do
		local var_5_1, var_5_2 = DBN("quest_episode", iter_5_0, {
			"last_chapter",
			"last_quest"
		})
		
		if not var_5_1 then
			break
		end
		
		var_5_0 = var_5_2
	end
	
	return var_5_0
end

function Scene.credits.getCreditsLayer(arg_6_0, arg_6_1)
	local var_6_0 = cc.LayerColor:create(cc.c3b(255, 255, 225))
	
	var_6_0:setPosition(VIEW_BASE_LEFT, 0)
	
	local var_6_1 = load_file("credits/credits.json")
	
	if not var_6_1 then
		print(debug.traceback())
		Log.e("s_credits", "Can't Find credits/credits.json file..")
		
		return 
	end
	
	arg_6_0.credits = json.decode(var_6_1)
	
	if not arg_6_0.credits then
		Log.e("s_credits", "Json decode failed : credits/credits.json")
		
		return 
	end
	
	local var_6_2 = load_file("credits/images.json")
	
	if not var_6_2 then
		print(debug.traceback())
		Log.e("s_credits", "Can't Find credits/images.json file..")
		
		return 
	end
	
	local var_6_3 = json.decode(var_6_2)
	
	if not var_6_3 then
		Log.e("s_credits", "Json decode failed : credits/credits.json")
		
		return 
	end
	
	arg_6_0.images = var_6_3[1]
	arg_6_0.credits_layer = cc.Layer:create()
	arg_6_0.top_layer = cc.Layer:create()
	
	arg_6_0.credits_layer:setPositionX(0 - VIEW_BASE_LEFT)
	var_6_0:addChild(arg_6_0.credits_layer)
	var_6_0:addChild(arg_6_0.top_layer)
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.credits) do
		table.push(arg_6_0.time, {
			stage = iter_6_1.stage,
			time = iter_6_1.time,
			list = iter_6_1.list
		})
	end
	
	var_6_0:setCascadeColorEnabled(true)
	arg_6_0.credits_layer:setCascadeColorEnabled(true)
	arg_6_0.top_layer:setCascadeColorEnabled(true)
	var_6_0:addChild(load_dlg("credits", true, "wnd"))
	
	arg_6_0.eff = cc.Sprite:create("credits/eff.png")
	
	arg_6_0.eff:setAnchorPoint(0.5, 0.5)
	arg_6_0.eff:setPositionX(0 - VIEW_BASE_LEFT)
	var_6_0:addChild(arg_6_0.eff)
	
	arg_6_0.vignetting = var_6_0:getChildByName("vignetting")
	
	arg_6_0.vignetting:setPositionX(VIEW_WIDTH / 2)
	
	arg_6_0.skip_btn = load_dlg("story_movie_skip", true, "wnd")
	
	var_6_0:addChild(arg_6_0.skip_btn)
	
	arg_6_0.touch_cnt = 0
	
	arg_6_0:nextStage()
	
	return var_6_0
end

function Scene.credits.onUnload(arg_7_0)
	if get_cocos_refid(arg_7_0.layer) then
		arg_7_0.layer:removeFromParent()
	end
end

function Scene.credits.onEnter(arg_8_0)
	SoundEngine:playBGM("event:/bgm/bgm_town")
end

function Scene.credits.nextStage(arg_9_0, arg_9_1)
	arg_9_0.stage = to_n(arg_9_0.stage) + 1
	
	if not arg_9_0.time[arg_9_0.stage] then
		arg_9_0.finished = true
		
		arg_9_0:finiThisScene()
		
		return 
	end
	
	arg_9_0.stage_name = arg_9_0.time[arg_9_0.stage].stage
	arg_9_0.next_stage_time = systick() + arg_9_0.time[arg_9_0.stage].time
	
	arg_9_0["onStartStage" .. arg_9_0.time[arg_9_0.stage].stage](arg_9_0, arg_9_0.time[arg_9_0.stage].time, arg_9_0.time[arg_9_0.stage].list)
end

function Scene.credits.skip(arg_10_0)
	arg_10_0.stage = 99
	
	arg_10_0:nextStage()
	
	arg_10_0.stage = 0
end

function Scene.credits.onAfterDraw(arg_11_0)
	if arg_11_0.finished then
		return 
	end
	
	local var_11_0 = systick()
	
	if arg_11_0.is_pause then
		arg_11_0.pause_tm = var_11_0 - arg_11_0.pause_start_tm
		
		return 
	elseif arg_11_0.pause_tm then
		arg_11_0.next_stage_time = arg_11_0.next_stage_time + arg_11_0.pause_tm
		
		if arg_11_0.random_image_tick then
			arg_11_0.random_image_tick = arg_11_0.random_image_tick + arg_11_0.pause_tm
		end
	end
	
	if var_11_0 >= arg_11_0.next_stage_time then
		if arg_11_0["onEndStage" .. arg_11_0.stage_name] then
			arg_11_0["onEndStage" .. arg_11_0.stage_name](arg_11_0, var_11_0)
		end
		
		arg_11_0:nextStage()
	end
	
	if arg_11_0.random_image_interval and var_11_0 >= to_n(arg_11_0.random_image_tick) then
		if #arg_11_0.random_images == 0 then
			Log.e("s_credits", "혹시 " .. arg_11_0.arg.quest_id .. " 관련 크래딧 이미지를 설정하셨나요?")
			
			return 
		end
		
		arg_11_0.random_image_index = (to_n(arg_11_0.random_image_index) + 1) % #arg_11_0.random_images
		
		arg_11_0:showSprite(arg_11_0.random_images[arg_11_0.random_image_index + 1].name, arg_11_0.random_image_interval)
		
		arg_11_0.random_image_tick = var_11_0 + arg_11_0.random_image_interval
	end
	
	if arg_11_0["onUpdateStage" .. arg_11_0.stage_name] then
		arg_11_0["onUpdateStage" .. arg_11_0.stage_name](arg_11_0, var_11_0)
	end
	
	arg_11_0.vignetting:setOpacity(math.random(0, 4))
	arg_11_0.eff:setPosition(DESIGN_WIDTH / 2 + math.random(-100, 100) - VIEW_BASE_LEFT, DESIGN_HEIGHT / 2 + math.random(-100, 100))
	
	if math.random(1, 2) == 1 then
		arg_11_0.eff:setScaleX(1)
	else
		arg_11_0.eff:setScaleX(-1)
	end
	
	if arg_11_0.stage_name == "TransEffect" then
		if not arg_11_0.time[arg_11_0.stage] then
			return 
		end
		
		local var_11_1 = arg_11_0.time[arg_11_0.stage].time
		local var_11_2 = (arg_11_0.next_stage_time - var_11_0) / var_11_1
		
		arg_11_0.eff:setOpacity(50 * math.sin(var_11_2))
	else
		arg_11_0.eff:setOpacity(math.random(0, 1) * 50)
	end
	
	if arg_11_0.pause_tm then
		arg_11_0.pause_tm = nil
	end
end

function Scene.credits.showSprite(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_2 = arg_12_2 or 3000
	
	local var_12_0 = cc.Sprite:create(arg_12_1)
	
	var_12_0:setOpacity(0)
	var_12_0:setPosition(350 + to_n(arg_12_3), 360)
	var_12_0:setLocalZOrder(-999)
	arg_12_0.credits_layer:addChild(var_12_0)
	
	arg_12_0.cur_random_image = var_12_0
	
	Action:Add(SEQ(FADE_IN(1000), DELAY(math.max(0, arg_12_2 - 1000)), FADE_OUT(1000), REMOVE()), var_12_0, "random_image")
end

function Scene.credits.pause(arg_13_0)
	arg_13_0.is_pause = true
	arg_13_0.pause_tm = 0
	arg_13_0.pause_start_tm = systick()
	
	Action:Pause()
end

function Scene.credits.resume(arg_14_0)
	arg_14_0.is_pause = nil
	
	Action:Resume()
end

function Scene.credits.onStartStageOpening(arg_15_0, arg_15_1)
	arg_15_0:showSprite("credits/images/crd_0.png", arg_15_1, 260)
end

function Scene.credits.onEndStageOpening(arg_16_0, arg_16_1)
	if not arg_16_0.random_image_interval then
		arg_16_0.random_image_interval = 4000
		arg_16_0.random_images = {}
		
		for iter_16_0, iter_16_1 in pairs(arg_16_0.images.img_list) do
			local var_16_0 = false
			local var_16_1 = true
			
			for iter_16_2, iter_16_3 in pairs(iter_16_1.show_filter) do
				if IS_PUBLISHER_ZLONG then
					if iter_16_3 == "zl" then
						var_16_1 = false
					end
				elseif iter_16_3 == getUserLanguage() then
					var_16_1 = false
				end
				
				if iter_16_3 == 1 and arg_16_0.arg.quest_id == "ep1_10_10" then
					var_16_0 = true
				end
				
				if iter_16_3 == 2 and arg_16_0.arg.quest_id == "ep2_10_10" then
					var_16_0 = true
				end
				
				if iter_16_3 == 3 and arg_16_0.arg.quest_id == "ep3_10_10" then
					var_16_0 = true
				end
				
				if iter_16_3 == 4 and arg_16_0.arg.quest_id == "ep4_10_10" then
					var_16_0 = true
				end
			end
			
			if var_16_0 and var_16_1 then
				table.push(arg_16_0.random_images, iter_16_1)
			end
		end
		
		table.shuffle(arg_16_0.random_images)
	end
end

function Scene.credits.onStartStageStaffs1(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0.staffs_interval = arg_17_1 / #arg_17_2
	arg_17_0.staffs_next_tick = systick()
	arg_17_0.staffs_index = 1
	arg_17_0.staffs_list = arg_17_2
	
	table.shuffle(arg_17_2)
end

function Scene.credits.onUpdateStageStaffs1(arg_18_0, arg_18_1)
	if arg_18_0.pause_tm then
		arg_18_0.staffs_next_tick = arg_18_0.staffs_next_tick + arg_18_0.pause_tm
	end
	
	if arg_18_1 > arg_18_0.staffs_next_tick then
		arg_18_0.staffs_next_tick = arg_18_0.staffs_next_tick + arg_18_0.staffs_interval
		
		local var_18_0 = arg_18_0.staffs_list[arg_18_0.staffs_index]
		local var_18_1 = cc.CSLoader:createNode("wnd/credits_item.csb")
		
		var_18_1:setPosition(700, 360)
		var_18_1:setOpacity(0)
		if_set(var_18_1, "name", var_18_0[1])
		if_set(var_18_1, "role", var_18_0[2])
		if_set(var_18_1, "desc", var_18_0[3])
		if_set_visible(var_18_1, "n_thanks", false)
		arg_18_0.credits_layer:addChild(var_18_1)
		Action:Add(SEQ(SPAWN(SLIDE_IN_Y(400, 30), FADE_IN(400)), DELAY(math.max(0, arg_18_0.staffs_interval - 800)), SPAWN(SLIDE_OUT_Y(400, 30), FADE_OUT(400)), REMOVE()), var_18_1)
		
		arg_18_0.staffs_index = arg_18_0.staffs_index + 1
	end
end

function Scene.credits.onStartStageStaffs2(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.staffs_interval = arg_19_1 / math.floor(#arg_19_2 / 2 + 1)
	arg_19_0.staffs_next_tick = systick()
	arg_19_0.staffs_index = 1
	arg_19_0.staffs_list = arg_19_2
	
	table.shuffle(arg_19_2)
end

function Scene.credits.onUpdateStageStaffs2(arg_20_0, arg_20_1)
	if arg_20_0.pause_tm then
		arg_20_0.staffs_next_tick = arg_20_0.staffs_next_tick + arg_20_0.pause_tm
	end
	
	if arg_20_1 > arg_20_0.staffs_next_tick then
		arg_20_0.staffs_next_tick = arg_20_0.staffs_next_tick + arg_20_0.staffs_interval
		
		for iter_20_0 = 1, 2 do
			local var_20_0 = arg_20_0.staffs_list[arg_20_0.staffs_index]
			
			if var_20_0 then
				local var_20_1 = cc.CSLoader:createNode("wnd/credits_item.csb")
				
				if iter_20_0 == 1 then
					var_20_1:setPosition(700, 420)
				else
					var_20_1:setPosition(700, 230)
				end
				
				var_20_1:setOpacity(0)
				if_set(var_20_1, "name", var_20_0[1])
				if_set(var_20_1, "role", var_20_0[2])
				if_set(var_20_1, "desc", var_20_0[3] or "")
				if_set_visible(var_20_1, "n_thanks", false)
				arg_20_0.credits_layer:addChild(var_20_1)
				Action:Add(SEQ(DELAY((iter_20_0 - 1) * 100), SPAWN(SLIDE_IN_Y(400, 30), FADE_IN(400)), DELAY(math.max(0, arg_20_0.staffs_interval - 800)), SPAWN(SLIDE_OUT_Y(400, 30), FADE_OUT(400)), REMOVE()), var_20_1)
				
				arg_20_0.staffs_index = arg_20_0.staffs_index + 1
			end
		end
	end
end

function Scene.credits.onStartStageSpecialThanks(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = cc.CSLoader:createNode("wnd/credits_item.csb")
	local var_21_1 = 2
	
	var_21_0:setPosition(700, 360)
	var_21_0:setOpacity(0)
	if_set_visible(var_21_0, "n_member", false)
	if_set_visible(var_21_0, "n_thanks", false)
	arg_21_0.credits_layer:addChild(var_21_0)
	
	local var_21_2 = "Special Thanks\n\n"
	
	table.shuffle(arg_21_2)
	
	for iter_21_0, iter_21_1 in pairs(arg_21_2) do
		if iter_21_0 > 1 and iter_21_0 % var_21_1 == 1 then
			var_21_2 = var_21_2 .. "\n"
		end
		
		var_21_2 = var_21_2 .. iter_21_1
		
		if iter_21_0 < #arg_21_2 and iter_21_0 % var_21_1 ~= 0 then
			var_21_2 = var_21_2 .. ","
		end
	end
	
	if_set(var_21_0, "etc", var_21_2)
	Action:Add(SPAWN(SEQ(FADE_IN(400), DELAY(math.max(0, arg_21_1 - 800)), FADE_OUT(400), REMOVE())), var_21_0)
end

function Scene.credits.stopRandomImage(arg_22_0)
	arg_22_0.random_image_interval = nil
	
	if get_cocos_refid(arg_22_0.cur_random_image) then
		Action:Remove(arg_22_0.cur_random_image)
		Action:Add(FADE_OUT(300), arg_22_0.cur_random_image)
	end
end

function Scene.credits.onStartStageEnding(arg_23_0, arg_23_1)
	arg_23_0:stopRandomImage()
	
	local var_23_0 = cc.LayerColor:create(cc.c3b(255, 255, 255))
	
	var_23_0:setCascadeOpacityEnabled(true)
	arg_23_0.top_layer:addChild(var_23_0)
	var_23_0:setOpacity(0)
	Action:Add(SEQ(DELAY(200), FADE_IN(2000)), var_23_0)
	
	local var_23_1 = cc.CSLoader:createNode("wnd/credits_item.csb")
	
	var_23_1:setPosition(DESIGN_WIDTH / 2 - VIEW_BASE_LEFT, DESIGN_HEIGHT / 2)
	if_set_visible(var_23_1, "n_member", false)
	if_set_visible(var_23_1, "n_thanks", true)
	
	if getUserLanguage() ~= "ko" then
		if_set(var_23_1, "thanks", "Thank you")
	end
	
	var_23_0:addChild(var_23_1)
end

function Scene.credits.onLeave(arg_24_0)
end

function Scene.credits.onTouchDown(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0.touch_cnt = to_n(arg_25_0.touch_cnt) + 1
	
	if arg_25_0.touch_cnt > 1 then
		arg_25_0.touch_cnt = 0
	end
end

function Scene.credits.onStartStageTransEffect(arg_26_0, arg_26_1)
	local var_26_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_26_0:setCascadeOpacityEnabled(true)
	arg_26_0.top_layer:addChild(var_26_0)
	var_26_0:setOpacity(0)
	Action:Add(FADE_IN(2000), var_26_0)
end

function Scene.credits.finiThisScene(arg_27_0)
	if get_cocos_refid(arg_27_0.layer) then
		arg_27_0.layer:setVisible(false)
	end
	
	if arg_27_0.arg.quest_id == "ep1_10_10" then
		SceneManager:nextScene("lobby")
	elseif arg_27_0.arg.quest_id == "ep2_10_10" then
		SceneManager:nextScene("lobby")
	elseif arg_27_0.arg.quest_id == "ep3_10_10" then
		start_new_story(nil, "EP3_CH10_mer_1", {
			force = true,
			on_finish = function()
				SceneManager:nextScene("lobby")
			end
		})
	elseif arg_27_0.arg.quest_id == "ep4_10_10" then
		start_new_story(nil, "EP4_CH10_end", {
			force = true,
			on_finish = function()
				SceneManager:nextScene("lobby")
			end
		})
	end
end
