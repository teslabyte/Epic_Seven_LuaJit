CookMain = {}

function HANDLER.game_cooking(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "n_btn_c" then
		CookMain:touch()
	elseif arg_1_1 == "n_btn_r" then
		CookMain:start_game()
	elseif arg_1_1 == "n_btn_result" then
		CookMain:play_story()
	end
end

function MsgHandler.substory_cook_clear(arg_2_0)
	if arg_2_0 then
		CookMain:res_clear(arg_2_0)
	end
end

local function var_0_0()
	return "substory/image/"
end

function CookMain.show(arg_4_0, arg_4_1)
	arg_4_0:init(arg_4_1)
end

function CookMain.init(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	if not DB("substory_cook", arg_5_1, {
		"id"
	}) then
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("game_cooking", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_5_0.vars.wnd)
	
	arg_5_0.vars.enter_id = arg_5_1
	
	arg_5_0:initData()
	arg_5_0:initReadyUI()
	
	arg_5_0.vars.cur_time = systick()
	arg_5_0.vars.timmer_time = arg_5_0.vars.data.limit_time
	arg_5_0.vars.one_total_touch_count = 0
	arg_5_0.vars.one_second_touch_count = 0
	arg_5_0.vars.cur_point = 0
	arg_5_0.vars.max_point = 100
	arg_5_0.vars.one_touch_add_point = arg_5_0.vars.data.touch_increase_gauge * 100
	arg_5_0.vars.one_touch_minus_point = arg_5_0.vars.data.notouch_decrease_gauge * 100
	arg_5_0.vars.fast_ani = false
	
	Scheduler:add(CookMain.vars.wnd, CookMain.update, CookMain):setName("cook_update")
	
	arg_5_0.vars.progress_delta = 0.005
	arg_5_0.vars.progress_delta_plus = 0.015
	arg_5_0.vars.minus_start = false
	arg_5_0.vars.normal_eff_time_scale = 1
	arg_5_0.vars.fast_eff_time_scale = 4
	arg_5_0.vars.progress_bar = arg_5_0.vars.wnd:getChildByName("n_gauge_bar")
	
	if_set_percent(arg_5_0.vars.progress_bar, nil, 0)
	
	local var_5_0 = arg_5_0.vars.wnd:getChildByName("n_limit")
	
	arg_5_0.vars.n_timmer = var_5_0:getChildByName("txt_time")
	
	arg_5_0:setTimmerText(arg_5_0.vars.timmer_time)
	arg_5_0.vars.n_timmer:setTextColor(tocolor("#ffcc00"))
	arg_5_0.vars.n_timmer:enableOutline(tocolor("#ffcc00"), 1)
	
	local var_5_1 = var_5_0:getChildByName("n_food")
	
	if get_cocos_refid(var_5_1) then
		local var_5_2 = var_0_0()
		local var_5_3 = UIUtil:getRewardIcon(nil, arg_5_0.vars.data.success_food_icon, {
			is_food = true,
			no_tooltip = true,
			no_bg = true,
			no_detail_popup = true,
			parent = var_5_1
		})
		
		if_set_sprite(var_5_3, "icon", var_5_2 .. arg_5_0.vars.data.success_food_icon .. ".png")
	end
	
	if DEBUG.SKIP_STORY then
		arg_5_0:ready_game()
	else
		arg_5_0:play_enter_story()
	end
end

function CookMain.play_enter_story(arg_6_0)
	local var_6_0, var_6_1 = DB("level_enter", arg_6_0.vars.enter_id, {
		"id",
		"story_stage_link"
	})
	
	if not var_6_0 or not var_6_1 then
		return 
	end
	
	play_story(var_6_1, {
		force = true,
		enter_id = arg_6_0.vars.enter_id,
		on_finish = function()
			arg_6_0:ready_game()
		end
	})
end

function CookMain.change_eff(arg_8_0)
	local var_8_0
	
	arg_8_0.vars.cook_eff2 = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_substory_cook2.cfx",
		pivot_y = 180,
		pivot_z = 99998,
		scale = 2,
		layer = arg_8_0.vars.wnd:getChildByName("n_eff_utensil")
	})
	
	arg_8_0.vars.cook_eff2:setVisible(false)
	
	if arg_8_0.vars.cook_eff and arg_8_0.vars.cook_eff.sd and get_cocos_refid(arg_8_0.vars.cook_eff.sd) then
		arg_8_0.vars.cook_eff.sd:setVolume(0)
	end
	
	local var_8_1 = arg_8_0.vars.cook_eff:getTimeScale()
	local var_8_2 = arg_8_0.vars.cook_eff
	
	arg_8_0.vars.cook_eff = arg_8_0.vars.cook_eff2
	arg_8_0.vars.cook_eff2 = var_8_2
	
	arg_8_0.vars.cook_eff:setTimeScale(var_8_1)
	UIAction:Add(SEQ(FADE_OUT(1), SHOW(false), REMOVE()), arg_8_0.vars.cook_eff2, "cook2")
	UIAction:Add(SEQ(FADE_IN(1), SHOW(true)), arg_8_0.vars.cook_eff, "cook1")
end

function CookMain.initData(arg_9_0)
	local var_9_0 = DBT("substory_cook", arg_9_0.vars.enter_id, {
		"id",
		"success_food_name",
		"success_food_icon",
		"success_story",
		"fail_story",
		"ingredient_name1",
		"ingredient_icon1",
		"ingredient_name2",
		"ingredient_icon2",
		"ingredient_name3",
		"ingredient_icon3",
		"limit_time",
		"touch_increase_gauge",
		"notouch_decrease_gauge",
		"effect_type",
		"npc",
		"baloon1",
		"face1",
		"baloon2",
		"face2",
		"baloon3",
		"face3",
		"baloon_success",
		"face_success",
		"baloon_fail",
		"face_fail"
	})
	
	if not var_9_0 or table.empty(var_9_0) then
		return 
	end
	
	arg_9_0.vars.data = var_9_0
	arg_9_0.vars.substory_id = SubstoryManager:getInfoID() or "vrimaa"
end

function CookMain.initReadyUI(arg_10_0)
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("n_ready")
	local var_10_1 = var_10_0:getChildByName("n_ingredient")
	local var_10_2 = var_0_0()
	
	if_set(var_10_0, "txt_food", T(arg_10_0.vars.data.success_food_name))
	
	local var_10_3 = UIUtil:getRewardIcon(nil, arg_10_0.vars.data.success_food_icon, {
		is_food = true,
		no_tooltip = true,
		no_bg = true,
		no_detail_popup = true,
		parent = var_10_0:getChildByName("n_food")
	})
	
	if_set_sprite(var_10_3, "icon", var_10_2 .. arg_10_0.vars.data.success_food_icon .. ".png")
	
	local var_10_4 = 0
	
	for iter_10_0 = 1, 3 do
		local var_10_5 = arg_10_0.vars.data["ingredient_name" .. iter_10_0]
		local var_10_6 = arg_10_0.vars.data["ingredient_icon" .. iter_10_0]
		
		if var_10_5 and var_10_6 then
			if_set(var_10_1, "txt_item_" .. iter_10_0, T(var_10_5))
			
			local var_10_7 = UIUtil:getRewardIcon(nil, var_10_6, {
				is_food = true,
				no_tooltip = true,
				no_bg = true,
				no_detail_popup = true,
				parent = var_10_1:getChildByName("n_item_" .. iter_10_0)
			})
			
			if_set_sprite(var_10_7, "icon", var_10_2 .. var_10_6 .. ".png")
			
			var_10_4 = var_10_4 + 1
		else
			if_set_visible(var_10_1, "txt_item_" .. iter_10_0, false)
			if_set_visible(var_10_1, "n_item_" .. iter_10_0, false)
		end
	end
	
	local var_10_8 = var_10_1:getChildByName("n_item")
	
	if var_10_4 == 2 and not var_10_8.origin_x then
		var_10_8.origin_x = var_10_8:getPositionX()
		
		var_10_8:setPositionX(var_10_8.origin_x + 70)
		
		arg_10_0.vars.move_res_position = true
	end
	
	arg_10_0:initNPC_ui()
end

function CookMain.initNPC_ui(arg_11_0)
	local var_11_0 = arg_11_0.vars.wnd:getChildByName("n_npc"):getChildByName("n_pos")
	
	if get_cocos_refid(var_11_0) then
		local var_11_1, var_11_2 = UIUtil:getPortraitAni(arg_11_0.vars.data.npc, {})
		
		var_11_0:addChild(var_11_1)
		var_11_1:setLocalZOrder(1)
		var_11_1:setScale(1)
		var_11_1:setPosition(0, 0)
		
		arg_11_0.vars.portrait = var_11_1
		
		arg_11_0:updateNPC_ui(1)
	end
end

function CookMain.updateNPC_ui(arg_12_0, arg_12_1)
	arg_12_0.vars.npc_state = arg_12_1
	
	arg_12_0:showBalloonMessage(arg_12_1)
end

function CookMain.showBalloonMessage(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.portrait) then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_npc")
	local var_13_1 = arg_13_0.vars.wnd:getChildByName("talk_bg")
	
	if get_cocos_refid(var_13_1) then
		var_13_1:setScale(0)
	end
	
	local var_13_2 = arg_13_0.vars.data["baloon" .. arg_13_1]
	local var_13_3 = arg_13_0.vars.data["face" .. arg_13_1]
	
	if arg_13_1 == 4 then
		var_13_2 = arg_13_0.vars.data.baloon_success
		var_13_3 = arg_13_0.vars.data.face_success
	elseif arg_13_1 == 5 then
		var_13_2 = arg_13_0.vars.data.baloon_fail
		var_13_3 = arg_13_0.vars.data.face_fail
	end
	
	if var_13_2 and var_13_3 then
		if_set(var_13_0, "disc", T(var_13_2))
		var_13_1:setVisible(true)
		UIAction:Add(SEQ(LOG(SCALE(80, 0, 1))), var_13_1)
		
		local var_13_4 = StoryFace:getFaceAni(var_13_3)
		
		if var_13_4 then
			UnitMain:setPortraitEmotion(nil, arg_13_0.vars.portrait, var_13_4)
		end
	end
end

function CookMain.ready_game(arg_14_0)
	if_set_visible(arg_14_0.vars.wnd, "n_ready", true)
	if_set_visible(arg_14_0.vars.wnd, "n_cook", false)
	UIAction:Add(SEQ(SHOW(false), DELAY(2000), SHOW(true)), arg_14_0.vars.wnd:getChildByName("n_btn_r"), "block")
end

function CookMain.start_game(arg_15_0)
	if arg_15_0.vars.start_game then
		return 
	end
	
	local var_15_0 = {}
	local var_15_1 = arg_15_0.vars.wnd:getChildByName("n_cook"):getChildByName("n_ingredient")
	local var_15_2 = var_0_0()
	
	var_15_1:setVisible(true)
	
	local var_15_3 = 0
	
	for iter_15_0 = 1, 3 do
		local var_15_4 = arg_15_0.vars.data["ingredient_name" .. iter_15_0]
		local var_15_5 = arg_15_0.vars.data["ingredient_icon" .. iter_15_0]
		
		if var_15_4 and var_15_5 then
			local var_15_6 = var_15_1:getChildByName("n_item_" .. iter_15_0)
			
			if get_cocos_refid(var_15_6) then
				var_15_6:setVisible(true)
				
				local var_15_7 = UIUtil:getRewardIcon(nil, var_15_5, {
					is_food = true,
					no_tooltip = true,
					no_bg = true,
					no_detail_popup = true,
					parent = var_15_6
				})
				
				if_set_sprite(var_15_7, "icon", var_15_2 .. var_15_5 .. ".png")
				
				var_15_3 = var_15_3 + 1
				
				table.insert(var_15_0, var_15_6)
			end
		else
			if_set_visible(var_15_1, "n_item_" .. iter_15_0, false)
		end
	end
	
	local var_15_8 = var_15_1:getChildByName("n_item")
	
	if var_15_3 == 2 and not var_15_8.origin_x then
		var_15_8.origin_x = var_15_8:getPositionX()
		
		var_15_8:setPositionX(var_15_8.origin_x + 70)
	end
	
	if_set_visible(arg_15_0.vars.wnd, "n_ready", false)
	if_set_visible(arg_15_0.vars.wnd, "n_btn_c", false)
	if_set_visible(arg_15_0.vars.wnd, "n_count", true)
	if_set_visible(arg_15_0.vars.wnd, "n_cook", true)
	
	arg_15_0.vars.cook_eff = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_substory_cook1.cfx",
		pivot_y = 180,
		pivot_z = 99998,
		scale = 2,
		layer = arg_15_0.vars.wnd:getChildByName("n_eff_utensil")
	})
	
	local var_15_9 = arg_15_0.vars.wnd:getChildByName("n_count")
	local var_15_10 = 1000
	
	BattleAction:Add(SEQ(CALL(function()
		if_set(var_15_9, "txt_count", 3)
	end), DELAY(var_15_10), CALL(function()
		if_set(var_15_9, "txt_count", 2)
	end), DELAY(var_15_10), CALL(function()
		if_set(var_15_9, "txt_count", 1)
	end), DELAY(var_15_10), CALL(function()
		if_set_visible(arg_15_0.vars.wnd, "n_count", false)
		arg_15_0:moveResIcons(var_15_0)
	end), DELAY(var_15_10 + 300), CALL(function()
		if_set_visible(arg_15_0.vars.wnd, "n_limit", true)
		if_set_visible(arg_15_0.vars.wnd, "n_btn_c", true)
		
		arg_15_0.vars.start_game = true
		
		CookMain:updateNPC_ui(2)
	end)), var_15_9, "start_count")
end

function CookMain.moveResIcons(arg_21_0, arg_21_1)
	if not arg_21_1 or table.empty(arg_21_1) then
		return 
	end
	
	local var_21_0, var_21_1 = arg_21_0.vars.wnd:getChildByName("n_item_move"):getPosition()
	local var_21_2 = 0
	
	if arg_21_0.vars.move_res_position then
		var_21_2 = -70
	end
	
	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		UIAction:Add(SEQ(MOVE_TO(math.random(800, 100), var_21_0 + var_21_2, var_21_1), SHOW(false)), iter_21_1, "res_move_" .. iter_21_0)
	end
	
	local var_21_3 = arg_21_0.vars.wnd:getChildByName("n_start_info")
	
	UIAction:Add(SEQ(SHOW(true), DELAY(1000), SHOW(false)), var_21_3, "show_start")
end

function CookMain.isStartGame(arg_22_0)
	return arg_22_0.vars and arg_22_0.vars.start_game
end

function CookMain.isMaxScore(arg_23_0)
	return arg_23_0.vars and arg_23_0.vars.cur_point >= arg_23_0.vars.max_point
end

function CookMain.isTimmerEnd(arg_24_0)
	return arg_24_0.vars and arg_24_0.vars.timmer_time <= 0
end

function CookMain.touch(arg_25_0)
	if not arg_25_0:isStartGame() then
		return 
	end
	
	if arg_25_0:isMaxScore() then
		Scheduler:removeByName("cook_update")
		
		if not arg_25_0.vars.result then
			CookMain:update()
		end
		
		return 
	elseif arg_25_0:isTimmerEnd() then
		Scheduler:removeByName("cook_update")
		
		if not arg_25_0.vars.result then
			CookMain:update()
		end
		
		return 
	end
	
	arg_25_0.vars.one_total_touch_count = arg_25_0.vars.one_total_touch_count + 1
	arg_25_0.vars.one_second_touch_count = arg_25_0.vars.one_second_touch_count + 1
	arg_25_0.vars.cur_point = arg_25_0.vars.cur_point + arg_25_0.vars.one_touch_add_point
	arg_25_0.vars.minus_start = false
	
	local var_25_0 = math.random(700, 1200)
	local var_25_1 = math.random(200, 500)
	local var_25_2 = "angelica_m2_fx_camping_particle"
	
	EffectManager:Play({
		pivot_z = 99998,
		scale = 2,
		fn = var_25_2,
		layer = arg_25_0.vars.wnd,
		pivot_x = var_25_0,
		pivot_y = var_25_1
	})
end

function CookMain.update(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	if not arg_26_0:isStartGame() then
		return 
	end
	
	if arg_26_0:isMaxScore() then
		arg_26_0.vars.result = 1
		
		CookMain:clear(1)
		
		return 
	elseif arg_26_0:isTimmerEnd() then
		arg_26_0.vars.result = 0
		
		CookMain:clear(0)
		
		return 
	end
	
	local var_26_0 = systick()
	
	if var_26_0 - arg_26_0.vars.cur_time >= 500 and arg_26_0.vars.one_second_touch_count == 0 and not arg_26_0.vars.minus_start then
		arg_26_0.vars.minus_start = true
	end
	
	if var_26_0 - arg_26_0.vars.cur_time >= 1000 then
		if arg_26_0.vars.minus_start then
			arg_26_0.vars.cur_point = arg_26_0.vars.cur_point - arg_26_0.vars.one_touch_minus_point
			arg_26_0.vars.cur_point = math.max(arg_26_0.vars.cur_point, 0)
		end
		
		if arg_26_0.vars.one_second_touch_count > 0 then
		end
		
		arg_26_0.vars.fast_ani = arg_26_0.vars.one_second_touch_count >= 3
		arg_26_0.vars.one_second_touch_count = 0
		arg_26_0.vars.cur_time = var_26_0
		arg_26_0.vars.normal_eff_time_scale = 1
		arg_26_0.vars.fast_eff_time_scale = 2
		
		local var_26_1 = arg_26_0.vars.cook_eff:getTimeScale()
		
		if arg_26_0.vars.fast_ani and arg_26_0.vars.fast_eff_time_scale ~= var_26_1 then
			arg_26_0.vars.cook_eff:setTimeScale(arg_26_0.vars.fast_eff_time_scale)
		elseif (not arg_26_0.vars.fast_ani or arg_26_0.vars.minus_start) and arg_26_0.vars.normal_eff_time_scale ~= var_26_1 then
			arg_26_0.vars.cook_eff:setTimeScale(arg_26_0.vars.normal_eff_time_scale)
		end
		
		arg_26_0.vars.timmer_time = arg_26_0.vars.timmer_time - 1
		
		arg_26_0:setTimmerText(arg_26_0.vars.timmer_time)
		
		if arg_26_0.vars.timmer_time <= 5 and not arg_26_0.vars.change_timmer_color then
			arg_26_0.vars.n_timmer:setTextColor(tocolor("#ff540a"))
			arg_26_0.vars.n_timmer:enableOutline(tocolor("#ff540a"), 1)
			
			arg_26_0.vars.change_timmer_color = true
		end
	end
	
	arg_26_0:updateUI()
end

function CookMain.setTimmerText(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not arg_27_0.vars.n_timmer or not arg_27_1 then
		return 
	end
	
	local var_27_0, var_27_1 = (function(arg_28_0)
		local var_28_0 = math.floor(arg_28_0 / 60)
		
		arg_28_0 = arg_28_0 - var_28_0 * 60
		
		return var_28_0, arg_28_0
	end)(arg_27_1)
	local var_27_2 = string.format("%02d : %02d", var_27_0, var_27_1)
	
	arg_27_0.vars.n_timmer:setString(var_27_2)
end

function CookMain.updateUI(arg_29_0)
	local var_29_0 = arg_29_0.vars.cur_point / arg_29_0.vars.max_point
	local var_29_1 = arg_29_0.vars.progress_bar:getPercent() / 100
	
	if arg_29_0.vars.minus_start and var_29_0 < var_29_1 then
		var_29_1 = var_29_1 - arg_29_0.vars.progress_delta
	elseif var_29_1 < var_29_0 then
		var_29_1 = var_29_1 + arg_29_0.vars.progress_delta_plus
	end
	
	local var_29_2 = math.max(var_29_1, 0)
	
	if_set_percent(arg_29_0.vars.progress_bar, nil, var_29_2)
	
	if var_29_2 >= 0.5 and arg_29_0.vars.npc_state ~= 3 then
		arg_29_0:updateNPC_ui(3)
		arg_29_0:change_eff()
	end
end

function CookMain.setClearUI(arg_30_0, arg_30_1)
	if arg_30_0.vars.cook_eff and arg_30_0.vars.cook_eff.sd and get_cocos_refid(arg_30_0.vars.cook_eff.sd) then
		arg_30_0.vars.cook_eff.sd:setVolume(0)
	end
	
	if_set_visible(arg_30_0.vars.wnd, "n_count", false)
	if_set_visible(arg_30_0.vars.wnd, "n_cook", false)
	if_set_visible(arg_30_0.vars.wnd, "n_result", true)
	
	local var_30_0 = arg_30_0.vars.wnd:getChildByName("n_result")
	local var_30_1 = arg_30_1 == 1
	
	CookMain:updateNPC_ui(var_30_1 and 4 or 5)
	if_set_visible(var_30_0, "n_fail", not var_30_1)
	if_set_visible(var_30_0, "n_success", var_30_1)
	
	local var_30_2
	local var_30_3
	local var_30_4 = 0
	local var_30_5
	
	if var_30_1 then
		var_30_2 = arg_30_0.vars.wnd:getChildByName("n_success")
		var_30_3 = "ui_substory_cook_success.cfx"
		var_30_5 = 90
	else
		var_30_2 = arg_30_0.vars.wnd:getChildByName("n_fail")
		var_30_3 = "ui_substory_cook_fail.cfx"
		var_30_5 = 230
	end
	
	local var_30_6 = var_30_2:getChildByName("txt_food")
	
	if_set(var_30_6, nil, T(arg_30_0.vars.data.success_food_name))
	
	local var_30_7 = UIUtil:getRewardIcon(nil, arg_30_0.vars.data.success_food_icon, {
		is_food = true,
		no_tooltip = true,
		no_bg = true,
		no_detail_popup = true,
		parent = var_30_2:getChildByName("n_food")
	})
	local var_30_8 = var_0_0()
	
	if not var_30_1 then
		if_set_sprite(var_30_7, "icon", var_30_8 .. arg_30_0.vars.data.success_food_icon .. ".png?grayscale=1")
	else
		if_set_sprite(var_30_7, "icon", var_30_8 .. arg_30_0.vars.data.success_food_icon .. ".png")
	end
	
	local var_30_9 = var_30_2:getChildByName("n_eff")
	
	UIAction:Add(SEQ(CALL(function()
		local var_31_0 = EffectManager:Play({
			pivot_x = 0,
			fn = "ui_substory_cook_end.cfx",
			pivot_z = 99998,
			scale = 2,
			layer = var_30_9,
			pivot_y = var_30_5
		})
	end)), var_30_2, "block")
	UIAction:Add(SEQ(DELAY(1000), CALL(function()
		local var_32_0 = EffectManager:Play({
			pivot_x = 0,
			pivot_z = 99998,
			scale = 2,
			fn = var_30_3,
			layer = var_30_9,
			pivot_y = var_30_5
		})
	end)), var_30_2, "block")
	var_30_7:setOpacity(0)
	UIAction:Add(SEQ(DELAY(1000), FADE_IN(200)), var_30_7, "block")
	var_30_6:setOpacity(0)
	UIAction:Add(SEQ(DELAY(1000), FADE_IN(200)), var_30_6, "block")
end

function CookMain.clear(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) or not arg_33_1 then
		return 
	end
	
	Scheduler:removeByName("cook_update")
	
	local var_33_0 = arg_33_0.vars.substory_id
	local var_33_1 = arg_33_1
	local var_33_2 = arg_33_0.vars.enter_id
	
	arg_33_0:setClearUI(var_33_1)
	ConditionContentsManager:setIgnoreQuery(true)
	
	if var_33_1 == 1 then
		ConditionContentsManager:dispatch("cook.clear", {
			enter_id = var_33_2
		})
	end
	
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_33_3 = ConditionContentsManager:getUpdateConditions() and json.encode()
	
	UIAction:Add(SEQ(SHOW(false), DELAY(2000), SHOW(true)), arg_33_0.vars.wnd:getChildByName("n_btn_result"), "block")
	query("substory_cook_clear", {
		map_id = var_33_2,
		result = var_33_1,
		substory_id = var_33_0,
		update_conditions = var_33_3
	})
end

function CookMain.res_clear(arg_34_0, arg_34_1)
	local var_34_0 = ConditionContentsManager:updateResponseConditionList(arg_34_1)
	
	if arg_34_1.substory_id and arg_34_1.map and arg_34_1.doc_dungeon_base then
		Account:setSubstoryDungeonBaseInfo(arg_34_1.substory_id, arg_34_1.map, arg_34_1.doc_dungeon_base)
	end
end

function CookMain.play_story(arg_35_0)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.wnd) or not arg_35_0.vars.result then
		return 
	end
	
	local var_35_0 = Account:getSubStoryChoiceID(arg_35_0.vars.enter_id)
	
	SoundEngine:stopAllEvent()
	
	if arg_35_0.vars.result == 0 and arg_35_0.vars.data.fail_story then
		play_story(arg_35_0.vars.data.fail_story, {
			force = true,
			on_finish = function()
				arg_35_0:onLeave()
			end,
			choice_id = var_35_0,
			enter_id = arg_35_0.vars.enter_id
		})
	elseif arg_35_0.vars.result == 1 and arg_35_0.vars.data.success_story then
		play_story(arg_35_0.vars.data.success_story, {
			force = true,
			on_finish = function()
				arg_35_0:onLeave()
			end,
			choice_id = var_35_0,
			enter_id = arg_35_0.vars.enter_id
		})
	else
		arg_35_0:onLeave()
	end
end

function CookMain.onLeave(arg_38_0)
	arg_38_0.vars.wnd:removeFromParent()
	
	arg_38_0.vars = nil
	
	SceneManager:popScene()
	BackButtonManager:pop("game_cooking")
end
