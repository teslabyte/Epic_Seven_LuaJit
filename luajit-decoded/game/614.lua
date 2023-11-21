local var_0_0 = 20
local var_0_1 = 40000
local var_0_2 = 100 / var_0_0 / 100
local var_0_3 = false

function HANDLER.dungeon_story_fullmetal_alchemis(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "n_btn_c" then
		RepairMain:touch()
	elseif arg_1_1 == "n_btn_r" then
		RepairMain:start_game()
	elseif arg_1_1 == "n_btn_result" then
		RepairMain:play_story()
	end
end

function MsgHandler.substory_repair_clear(arg_2_0)
	if arg_2_0 then
		RepairMain:res_clear(arg_2_0)
	end
end

local function var_0_4()
	return "substory/image/"
end

RepairMain = {}

function RepairMain.onEnter(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	local var_4_0, var_4_1 = DB("level_enter", arg_4_1, {
		"id",
		"type"
	})
	
	if not var_4_0 or not var_4_1 or var_4_1 ~= "repair" then
		return 
	end
	
	arg_4_0:init(arg_4_1)
	arg_4_0:initUI()
	arg_4_0:initGaugeUI()
	
	local var_4_2 = tonumber(arg_4_0.vars.data.gaugebar_position)
	
	arg_4_0:_setCurRotation(var_4_2)
end

function RepairMain.onUpdateGauge(arg_5_0)
	if not arg_5_0.vars or arg_5_0:isTimmerEnd() then
		return 
	end
	
	local var_5_0 = tonumber(arg_5_0.vars.success_range[1]) * 1000
	local var_5_1 = tonumber(arg_5_0.vars.success_range[2]) * 1000
	local var_5_2 = var_5_0 / (var_0_2 * 100)
	local var_5_3 = var_5_1 / (var_0_2 * 100)
	local var_5_4 = tonumber(arg_5_0.vars.last_range[1]) * 1000
	local var_5_5 = tonumber(arg_5_0.vars.last_range[2]) * 1000
	local var_5_6 = var_5_4 / (var_0_2 * 100)
	local var_5_7 = var_5_5 / (var_0_2 * 100)
	local var_5_8 = var_5_6 / 10 + 1e-05
	local var_5_9 = var_5_7 / 10 + 1e-05
	local var_5_10 = var_5_2 / 10 + 1e-05
	local var_5_11 = var_5_3 / 10 + 1e-05
	local var_5_12 = math.floor(var_5_8)
	local var_5_13 = math.floor(var_5_9)
	local var_5_14 = math.floor(var_5_10)
	local var_5_15 = math.floor(var_5_11)
	local var_5_16 = math.floor(var_5_12 - var_5_14)
	local var_5_17 = math.floor(var_5_15 - var_5_13)
	local var_5_18 = var_5_16 >= 1
	local var_5_19 = var_5_17 >= 1
	local var_5_20 = math.min(var_5_16, arg_5_0.vars.range_change_time_value)
	local var_5_21 = math.min(var_5_17, arg_5_0.vars.range_change_time_value)
	
	if var_5_18 and var_5_19 then
		local var_5_22 = arg_5_0.vars.range_change_time_value
		local var_5_23 = math.random(0, var_5_20)
		local var_5_24 = math.min(var_5_22 - var_5_23, var_5_21)
		
		if var_5_22 <= var_5_20 + var_5_21 and var_5_22 > var_5_23 + var_5_24 then
			local var_5_25 = var_5_22 - var_5_24
			
			if var_5_25 < var_5_20 then
				var_5_23 = var_5_25
			else
				var_5_23 = var_5_20
			end
		end
		
		if var_5_22 < var_5_23 + var_5_24 then
			var_5_23 = math.min(var_5_22 - var_5_24, var_5_20)
		end
		
		arg_5_0.vars.success_range[1] = tonumber(arg_5_0.vars.success_range[1]) + tonumber(var_5_23 * var_0_2)
		arg_5_0.vars.success_range[2] = tonumber(arg_5_0.vars.success_range[2]) - tonumber(var_5_24 * var_0_2)
	elseif var_5_18 then
		arg_5_0.vars.success_range[1] = tonumber(arg_5_0.vars.success_range[1]) + tonumber(var_5_20 * var_0_2)
	elseif var_5_19 then
		arg_5_0.vars.success_range[2] = tonumber(arg_5_0.vars.success_range[2]) - tonumber(var_5_21 * var_0_2)
	else
		return 
	end
	
	arg_5_0:calcRange()
	arg_5_0:initGaugeUI(true)
end

function RepairMain.initGaugeUI(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_progress")
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	local var_6_1 = var_6_0:getChildByName("n_fever_red")
	local var_6_2 = var_6_0:getChildByName("n_fever_green")
	
	var_6_1:setVisible(true)
	var_6_2:setVisible(true)
	
	local var_6_3 = tonumber(arg_6_0.vars.success_range[1]) * 1000
	local var_6_4 = tonumber(arg_6_0.vars.success_range[2]) * 1000
	local var_6_5 = var_6_3 / (var_0_2 * 100)
	local var_6_6 = var_6_4 / (var_0_2 * 100)
	local var_6_7 = var_6_5 / 10 + 1e-05
	local var_6_8 = var_6_6 / 10 + 1e-05
	local var_6_9 = math.floor(var_6_7)
	local var_6_10 = math.floor(var_6_8)
	
	arg_6_0.vars.cur_min_val = var_6_9
	arg_6_0.vars.cur_max_val = var_6_10
	
	for iter_6_0 = 1, 20 do
		local var_6_11 = "n_fever_green" .. iter_6_0
		local var_6_12 = var_6_2:getChildByName(var_6_11)
		
		if not get_cocos_refid(var_6_12) then
			break
		end
		
		if var_6_9 <= iter_6_0 and iter_6_0 <= var_6_10 then
			var_6_12:setVisible(true)
		elseif arg_6_1 and var_6_12:isVisible() then
			UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), var_6_12, "n_gauge_" .. iter_6_0)
		else
			var_6_12:setVisible(false)
		end
	end
end

function RepairMain.calcRange(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	local var_7_0 = 180 / var_0_0
	local var_7_1 = tonumber(arg_7_0.vars.success_range[1]) * 100
	local var_7_2 = tonumber(arg_7_0.vars.success_range[2]) * 100
	local var_7_3 = var_7_1 / (var_0_2 * 100)
	local var_7_4 = var_7_2 / (var_0_2 * 100)
	
	arg_7_0.vars.success_min = var_7_3 * var_7_0 - var_7_0
	arg_7_0.vars.success_max = var_7_4 * var_7_0
end

function RepairMain.init(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if not DB("substory_cook", arg_8_1, {
		"id"
	}) then
		return 
	end
	
	arg_8_0.vars = {}
	arg_8_0.vars.wnd = load_dlg("dungeon_story_fullmetal_alchemis", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_8_0.vars.wnd)
	if_set_visible(arg_8_0.vars.wnd, "n_result", false)
	if_set_visible(arg_8_0.vars.wnd, "n_count", false)
	if_set_visible(arg_8_0.vars.wnd, "n_fullmetal_start", false)
	
	arg_8_0.vars.enter_id = arg_8_1
	
	arg_8_0:initData()
	arg_8_0:initReadyUI()
	
	arg_8_0.vars.cur_time = systick()
	arg_8_0.vars.before_time = systick()
	arg_8_0.vars.timmer_time = arg_8_0.vars.data.limit_time
	arg_8_0.vars.init_timmer_time = arg_8_0.vars.data.limit_time - 1
	arg_8_0.vars.one_total_touch_count = 0
	arg_8_0.vars.one_second_touch_count = 0
	arg_8_0.vars.cur_rotation = 0
	arg_8_0.vars.dest_rotaion = 0
	arg_8_0.vars.max_rotation = 180
	
	local var_8_0 = 1.8
	
	arg_8_0.vars.one_touch_add_rotation = arg_8_0.vars.data.touch_increase_gauge * 100 * var_8_0
	arg_8_0.vars.one_touch_minus_rotation = arg_8_0.vars.data.notouch_decrease_gauge * 100 * var_8_0
	arg_8_0.vars.one_touch_minus_rotation2 = arg_8_0.vars.data.notouch_decrease_gauge2 * 100 * var_8_0
	
	local var_8_1 = string.split(arg_8_0.vars.data.success_range, ",")
	
	arg_8_0.vars.success_range = string.split(var_8_1[1], ";")
	arg_8_0.vars.last_range = string.split(var_8_1[2], ";")
	
	arg_8_0:calcRange()
	
	local var_8_2 = 180 / var_0_0
	local var_8_3 = tonumber(arg_8_0.vars.last_range[1]) * 100
	local var_8_4 = tonumber(arg_8_0.vars.last_range[2]) * 100
	local var_8_5 = var_8_3 / (var_0_2 * 100)
	local var_8_6 = var_8_4 / (var_0_2 * 100)
	
	arg_8_0.vars.last_success_min = var_8_5 * var_8_2 - var_8_2
	arg_8_0.vars.last_success_max = var_8_6 * var_8_2
	
	local var_8_7 = var_0_1 * arg_8_0.vars.data.notouch_decrease_gauge
	
	arg_8_0.vars.normal_total_time = var_8_7
	
	local var_8_8 = var_0_1 * arg_8_0.vars.data.notouch_decrease_gauge2 * 0.4
	
	arg_8_0.vars.fast_total_time = var_8_8
	
	Scheduler:add(RepairMain.vars.wnd, RepairMain.update, RepairMain):setName("repair_update")
	
	arg_8_0.vars.minus_start = false
	arg_8_0.vars.fast_minus_start = false
	arg_8_0.vars.progress_bar = arg_8_0.vars.wnd:getChildByName("n_gauge_bar")
	
	if_set_percent(arg_8_0.vars.progress_bar, nil, 0)
	
	local var_8_9 = arg_8_0.vars.wnd:getChildByName("n_limit")
	
	arg_8_0.vars.n_timmer = var_8_9:getChildByName("txt_time")
	
	arg_8_0:setTimmerText(arg_8_0.vars.timmer_time)
	arg_8_0.vars.n_timmer:setTextColor(tocolor("#ffcc00"))
	arg_8_0.vars.n_timmer:enableOutline(tocolor("#ffcc00"), 1)
	
	local var_8_10 = var_8_9:getChildByName("n_food")
	
	if get_cocos_refid(var_8_10) then
		local var_8_11 = var_0_4()
		local var_8_12 = UIUtil:getRewardIcon(nil, arg_8_0.vars.data.success_food_icon, {
			is_food = true,
			no_tooltip = true,
			no_bg = true,
			no_detail_popup = true,
			parent = var_8_10
		})
		
		if_set_sprite(var_8_12, "icon", var_8_11 .. arg_8_0.vars.data.success_food_icon .. ".png")
	end
	
	if DEBUG.SKIP_STORY then
		arg_8_0:ready_game()
	else
		arg_8_0:play_enter_story()
	end
end

function RepairMain.setTimmerText(arg_9_0, arg_9_1)
	if not arg_9_0.vars or not arg_9_0.vars.n_timmer or not arg_9_1 then
		return 
	end
	
	local var_9_0, var_9_1 = (function(arg_10_0)
		local var_10_0 = math.floor(arg_10_0 / 60)
		
		arg_10_0 = arg_10_0 - var_10_0 * 60
		
		return var_10_0, arg_10_0
	end)(arg_9_1)
	local var_9_2 = string.format("%02d : %02d", var_9_0, var_9_1)
	
	arg_9_0.vars.n_timmer:setString(var_9_2)
end

function RepairMain.initData(arg_11_0)
	local var_11_0 = DBT("substory_cook", arg_11_0.vars.enter_id, {
		"id",
		"success_food_name",
		"success_food_icon",
		"fail_food_name",
		"fail_food_icon",
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
		"notouch_decrease_gauge2",
		"success_range",
		"effect_type",
		"npc",
		"baloon1",
		"face1",
		"baloon2",
		"face2",
		"baloon3",
		"face3",
		"baloon4",
		"face4",
		"baloon_success",
		"face_success",
		"baloon_fail",
		"face_fail",
		"gaugebar_position",
		"range_change_time",
		"range_change_time_value",
		"gauge_reduction_speed"
	})
	
	if not var_11_0 or table.empty(var_11_0) then
		return 
	end
	
	arg_11_0.vars.half_time = var_11_0.limit_time / 2
	var_11_0.limit_time = var_11_0.limit_time + 1
	arg_11_0.vars.data = var_11_0
	arg_11_0.vars.range_change_time = arg_11_0.vars.data.range_change_time
	arg_11_0.vars.range_change_time_value = arg_11_0.vars.data.range_change_time_value
	arg_11_0.vars.range_change_time_value = tonumber(arg_11_0.vars.range_change_time_value) / var_0_2
	arg_11_0.vars.gauge_reduction_speed = tonumber(arg_11_0.vars.data.gauge_reduction_speed) or 60
	arg_11_0.vars.substory_id = SubstoryManager:getInfoID() or "vrimaa"
	arg_11_0.vars.npc_state = 0
end

function RepairMain.initReadyUI(arg_12_0)
	local var_12_0 = arg_12_0.vars.wnd:getChildByName("n_repair_goal")
	local var_12_1 = var_12_0:getChildByName("n_ingredient")
	local var_12_2 = var_0_4()
	
	if_set(var_12_0, "txt_title", T(arg_12_0.vars.data.success_food_name))
	
	local var_12_3 = UIUtil:getRewardIcon(nil, arg_12_0.vars.data.success_food_icon, {
		is_food = true,
		no_tooltip = true,
		no_bg = true,
		no_detail_popup = true,
		parent = var_12_0:getChildByName("n_food")
	})
	
	if_set_sprite(var_12_3, "icon", var_12_2 .. arg_12_0.vars.data.success_food_icon .. ".png")
	
	local var_12_4 = 0
	
	for iter_12_0 = 1, 3 do
		local var_12_5 = arg_12_0.vars.data["ingredient_name" .. iter_12_0]
		local var_12_6 = arg_12_0.vars.data["ingredient_icon" .. iter_12_0]
		local var_12_7 = var_12_1:getChildByName("n_item_" .. iter_12_0)
		
		if not get_cocos_refid(var_12_7) then
			break
		end
		
		if_set_visible(var_12_7, "icon_material", false)
		
		if var_12_5 and var_12_6 then
			if_set(var_12_1, "txt_item_" .. iter_12_0, T(var_12_5))
			
			local var_12_8 = UIUtil:getRewardIcon(nil, var_12_6, {
				is_food = true,
				no_tooltip = true,
				no_bg = true,
				no_detail_popup = true,
				parent = var_12_1:getChildByName("n_item_" .. iter_12_0)
			})
			
			if_set_sprite(var_12_8, "icon", var_12_2 .. var_12_6 .. ".png")
			
			var_12_4 = var_12_4 + 1
		else
			if_set_visible(var_12_7, nil, false)
		end
	end
	
	local var_12_9 = var_12_1:getChildByName("n_item")
	
	if var_12_4 == 2 and not var_12_9.origin_x then
		var_12_9.origin_x = var_12_9:getPositionX()
		
		var_12_9:setPositionX(var_12_9.origin_x + 70)
		
		arg_12_0.vars.move_res_position = true
	end
	
	arg_12_0:initNPC_ui()
end

function RepairMain.initNPC_ui(arg_13_0)
	local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_npc"):getChildByName("n_pos")
	
	if get_cocos_refid(var_13_0) then
		local var_13_1, var_13_2 = UIUtil:getPortraitAni(arg_13_0.vars.data.npc, {})
		
		var_13_0:addChild(var_13_1)
		var_13_1:setLocalZOrder(1)
		var_13_1:setScale(0.8)
		var_13_1:setPosition(0, 0)
		
		arg_13_0.vars.portrait = var_13_1
		
		arg_13_0:updateNPC_ui(1)
	end
end

function RepairMain.updateNPC_ui(arg_14_0, arg_14_1)
	arg_14_0:showBalloonMessage(arg_14_1)
	
	arg_14_0.vars.npc_state = arg_14_1
end

function RepairMain.showBalloonMessage(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.portrait) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_npc")
	local var_15_1 = arg_15_0.vars.wnd:getChildByName("take_bg")
	
	if get_cocos_refid(var_15_1) and arg_15_0.vars.npc_state ~= arg_15_1 then
		var_15_1:setScale(0)
	end
	
	local var_15_2 = arg_15_0.vars.data["baloon" .. arg_15_1]
	local var_15_3 = arg_15_0.vars.data["face" .. arg_15_1]
	
	if arg_15_1 == 5 then
		var_15_2 = arg_15_0.vars.data.baloon_success
		var_15_3 = arg_15_0.vars.data.face_success
	elseif arg_15_1 == 6 then
		var_15_2 = arg_15_0.vars.data.baloon_fail
		var_15_3 = arg_15_0.vars.data.face_fail
	end
	
	if var_15_2 and var_15_3 and arg_15_0.vars.npc_state ~= arg_15_1 then
		if_set(var_15_0, "disc", T(var_15_2))
		var_15_1:setVisible(true)
		UIAction:Add(SEQ(LOG(SCALE(80, 0, 1))), var_15_1)
		
		local var_15_4 = StoryFace:getFaceAni(var_15_3)
		
		if var_15_4 then
			UnitMain:setPortraitEmotion(nil, arg_15_0.vars.portrait, var_15_4)
		end
	end
end

function RepairMain.play_enter_story(arg_16_0)
	local var_16_0, var_16_1 = DB("level_enter", arg_16_0.vars.enter_id, {
		"id",
		"story_stage_link"
	})
	
	if not var_16_0 or not var_16_1 then
		return 
	end
	
	play_story(var_16_1, {
		force = true,
		enter_id = arg_16_0.vars.enter_id,
		on_finish = function()
			arg_16_0:ready_game()
		end
	})
end

function RepairMain.ready_game(arg_18_0)
	if_set_visible(arg_18_0.vars.wnd, "n_repair_goal", true)
	if_set_visible(arg_18_0.vars.wnd, "n_fullmetal_start", false)
	UIAction:Add(SEQ(SHOW(false), DELAY(2000), SHOW(true)), arg_18_0.vars.wnd:getChildByName("n_btn_r"), "block")
	
	if not TutorialGuide:isClearedTutorial("vfa2aa_minigame_guide") then
		TutorialGuide:startGuide("vfa2aa_minigame_guide")
		
		return 
	end
end

function RepairMain.start_game(arg_19_0)
	if arg_19_0.vars.start_game or TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	local var_19_0 = {}
	local var_19_1 = arg_19_0.vars.wnd:getChildByName("n_repair_goal"):getChildByName("n_ingredient")
	local var_19_2 = var_0_4()
	
	var_19_1:setVisible(true)
	
	local var_19_3 = 0
	
	for iter_19_0 = 1, 3 do
		local var_19_4 = arg_19_0.vars.data["ingredient_name" .. iter_19_0]
		local var_19_5 = arg_19_0.vars.data["ingredient_icon" .. iter_19_0]
		
		if var_19_4 and var_19_5 then
			local var_19_6 = var_19_1:getChildByName("n_item_" .. iter_19_0)
			
			if get_cocos_refid(var_19_6) then
				var_19_6:setVisible(true)
				
				local var_19_7 = UIUtil:getRewardIcon(nil, var_19_5, {
					is_food = true,
					no_tooltip = true,
					no_bg = true,
					no_detail_popup = true,
					parent = var_19_6
				})
				
				if_set_sprite(var_19_7, "icon", var_19_2 .. var_19_5 .. ".png")
				
				var_19_3 = var_19_3 + 1
				
				table.insert(var_19_0, var_19_6)
			end
		else
			if_set_visible(var_19_1, "n_item_" .. iter_19_0, false)
		end
	end
	
	local var_19_8 = var_19_1:getChildByName("n_item")
	
	if var_19_3 == 2 and not var_19_8.origin_x then
		var_19_8.origin_x = var_19_8:getPositionX()
		
		var_19_8:setPositionX(var_19_8.origin_x + 70)
	end
	
	if_set_visible(arg_19_0.vars.wnd, "n_repair_goal", false)
	if_set_visible(arg_19_0.vars.wnd, "n_btn_c", false)
	if_set_visible(arg_19_0.vars.wnd, "n_count", true)
	if_set_visible(arg_19_0.vars.wnd, "n_fullmetal_start", true)
	
	local var_19_9 = arg_19_0.vars.wnd:getChildByName("n_count")
	local var_19_10 = 1000
	
	BattleAction:Add(SEQ(CALL(function()
		RepairMain:updateNPC_ui(2)
		if_set(var_19_9, "txt_count", 3)
	end), DELAY(var_19_10), CALL(function()
		if_set(var_19_9, "txt_count", 2)
	end), DELAY(var_19_10), CALL(function()
		if_set(var_19_9, "txt_count", 1)
	end), DELAY(var_19_10), CALL(function()
		if_set_visible(arg_19_0.vars.wnd, "n_count", false)
	end), CALL(function()
		if_set_visible(arg_19_0.vars.wnd, "n_limit", true)
		if_set_visible(arg_19_0.vars.wnd, "n_btn_c", true)
		
		arg_19_0.vars.start_game = true
	end)), var_19_9, "start_count")
end

function RepairMain.lessThanHalfTime(arg_25_0)
	return arg_25_0.vars.half_time >= arg_25_0.vars.timmer_time
end

function RepairMain.isInSuccessRange(arg_26_0)
	local var_26_0 = arg_26_0:_getCurRotation()
	local var_26_1 = arg_26_0.vars.success_min
	local var_26_2 = arg_26_0.vars.success_max
	
	return var_26_1 <= var_26_0 and var_26_0 <= var_26_2
end

function RepairMain.calcResult(arg_27_0)
	arg_27_0:_removeAllUpdate()
	
	arg_27_0.vars.result = arg_27_0:isInSuccessRange() and 1 or 0
	
	local var_27_0 = arg_27_0.vars.success_min
	local var_27_1 = arg_27_0.vars.success_max
	
	arg_27_0:clear(arg_27_0.vars.result)
end

function RepairMain.update(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	if not arg_28_0:isStartGame() then
		return 
	end
	
	if arg_28_0:isTimmerEnd() then
		arg_28_0:calcResult()
		
		return 
	end
	
	local var_28_0 = systick()
	
	if var_28_0 - arg_28_0.vars.cur_time >= 200 and not arg_28_0.vars.minus_start then
		arg_28_0.vars.minus_start = true
		
		arg_28_0:_start_minus_action()
	end
	
	if arg_28_0.vars.minus_start and BattleAction:Find("minus_action") and arg_28_0.vars.prev_fast_minus_start ~= arg_28_0.vars.fast_minus_start and arg_28_0.vars.minus_action then
		arg_28_0.vars.prev_fast_minus_start = arg_28_0.vars.fast_minus_start
		
		local var_28_1 = arg_28_0.vars.normal_total_time / arg_28_0.vars.fast_total_time
		
		arg_28_0.vars.minus_action:SetSpeed(var_28_1)
	end
	
	if not arg_28_0.vars.fast_minus_start and arg_28_0:lessThanHalfTime() then
		print("------------Half time faster------")
		
		arg_28_0.vars.fast_minus_start = true
	end
	
	if var_28_0 - arg_28_0.vars.before_time >= 1000 and (not arg_28_0.vars.minus_start or not arg_28_0.vars.fast_minus_start or true) then
		if false then
		end
		
		if arg_28_0.vars.one_second_touch_count > 0 then
		end
		
		arg_28_0.vars.one_second_touch_count = 0
		arg_28_0.vars.before_time = systick()
		arg_28_0.vars.timmer_time = arg_28_0.vars.timmer_time - 1
		
		arg_28_0:setTimmerText(arg_28_0.vars.timmer_time)
		
		if arg_28_0.vars.timmer_time <= arg_28_0.vars.half_time and not arg_28_0.vars.change_timmer_color then
			arg_28_0.vars.n_timmer:setTextColor(tocolor("#ff540a"))
			arg_28_0.vars.n_timmer:enableOutline(tocolor("#ff540a"), 1)
			
			arg_28_0.vars.change_timmer_color = true
			
			if not arg_28_0.vars.timmer_sound then
				arg_28_0.vars.timmer_sound = SoundEngine:play("event:/effect/repair_clock")
			end
		end
		
		local var_28_2 = tonumber(arg_28_0.vars.range_change_time)
		
		if arg_28_0.vars.timmer_time > 0 and arg_28_0.vars.init_timmer_time ~= arg_28_0.vars.timmer_time and arg_28_0.vars.timmer_time % tonumber(arg_28_0.vars.range_change_time) == 0 then
			arg_28_0:onUpdateGauge()
		end
	end
	
	arg_28_0:updateUI()
	arg_28_0:updateAlertEffect()
end

function RepairMain.updateAlertEffect(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	local var_29_0 = arg_29_0:isInSuccessRange()
	
	if not var_29_0 and not get_cocos_refid(arg_29_0.vars.alert_eff) then
		local var_29_1 = "ui_eff_vfa2aa_repair_warning"
		local var_29_2 = arg_29_0.vars.wnd:getChildByName("n_fever_red")
		
		arg_29_0.vars.alert_eff = EffectManager:Play({
			pivot_x = 0,
			pivot_y = 0,
			pivot_z = 99998,
			scale = 1,
			fn = var_29_1,
			layer = var_29_2
		})
	elseif var_29_0 and get_cocos_refid(arg_29_0.vars.alert_eff) then
		arg_29_0.vars.alert_eff:removeFromParent()
	end
end

function RepairMain.updateUI(arg_30_0)
	local var_30_0 = arg_30_0.vars.cur_rotation / arg_30_0.vars.max_rotation
	local var_30_1 = arg_30_0:_getCurRotation()
	
	if arg_30_0.vars.minus_start or arg_30_0.vars.fast_minus_start then
	else
		var_30_1 = var_30_1 + arg_30_0.vars.one_touch_add_rotation
	end
	
	local var_30_2 = math.max(var_30_1, 0)
	
	if_set_percent(arg_30_0.vars.progress_bar, nil, var_30_2)
	
	if var_30_2 >= 0.5 and (arg_30_0.vars.npc_state ~= 3 or arg_30_0.vars.npc_state ~= 4) then
		if RepairMain:isInSuccessRange() then
			arg_30_0:updateNPC_ui(4)
		else
			arg_30_0:updateNPC_ui(3)
		end
	end
	
	arg_30_0:updateGaugeUI(arg_30_0.vars.cur_rotation)
end

function RepairMain.touch(arg_31_0)
	if not arg_31_0:isStartGame() then
		return 
	end
	
	if arg_31_0:isTimmerEnd() then
		return 
	end
	
	arg_31_0.vars.cur_time = systick()
	arg_31_0.vars.one_total_touch_count = arg_31_0.vars.one_total_touch_count + 1
	arg_31_0.vars.one_second_touch_count = arg_31_0.vars.one_second_touch_count + 1
	arg_31_0.vars.dest_rotaion = arg_31_0.vars.dest_rotaion + arg_31_0.vars.one_touch_add_rotation
	arg_31_0.vars.dest_rotaion = math.min(arg_31_0.vars.dest_rotaion, 180)
	arg_31_0.vars.dest_rotaion = math.max(arg_31_0.vars.dest_rotaion, 0)
	
	if arg_31_0.vars.minus_start and BattleAction:Find("minus_action") then
		BattleAction:Remove("minus_action")
	end
	
	arg_31_0.vars.minus_start = false
	
	arg_31_0:onUpdateTouchEff()
	
	local var_31_0 = math.random(700, 1200)
	local var_31_1 = math.random(200, 500)
	local var_31_2 = "angelica_m2_fx_camping_particle"
	
	EffectManager:Play({
		pivot_z = 99998,
		scale = 2,
		fn = var_31_2,
		layer = arg_31_0.vars.wnd,
		pivot_x = var_31_0,
		pivot_y = var_31_1
	})
end

function RepairMain.onUpdateTouchEff(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.wnd:getChildByName("n_fullmetal_start"):getChildByName("n_automail")
	
	if get_cocos_refid(var_32_0) and not get_cocos_refid(arg_32_0.vars.touch_eff) then
		local var_32_1 = ({
			"ui_eff_vfa2aa_repair_hammer",
			"ui_eff_vfa2aa_repair_spanner"
		})[math.random(1, 2)]
		local var_32_2 = math.random(-100, 100)
		local var_32_3 = math.random(-50, 120)
		local var_32_4 = {
			{
				-82,
				99
			},
			{
				-74,
				59
			},
			{
				-50,
				14
			},
			{
				-14,
				10
			},
			{
				18,
				-22
			},
			{
				66,
				-49
			},
			{
				82,
				-37
			},
			{
				-41,
				37
			},
			{
				-91,
				64
			},
			{
				-14,
				-32
			},
			{
				5,
				-10
			}
		}
		local var_32_5 = var_32_4[math.random(1, table.count(var_32_4))]
		
		arg_32_0.vars.touch_eff = EffectManager:Play({
			pivot_z = 99998,
			scale = 1,
			fn = var_32_1,
			layer = var_32_0,
			pivot_x = var_32_5[1],
			pivot_y = var_32_5[2]
		})
	end
end

function RepairMain.clear(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) or not arg_33_1 then
		return 
	end
	
	arg_33_0:_removeAllUpdate()
	
	if arg_33_0.vars.timmer_sound and arg_33_0.vars.timmer_sound.stop then
		arg_33_0.vars.timmer_sound:stop()
	end
	
	local var_33_0 = arg_33_0.vars.substory_id
	local var_33_1 = arg_33_1
	local var_33_2 = arg_33_0.vars.enter_id
	
	arg_33_0:setClearUI(var_33_1)
	ConditionContentsManager:setIgnoreQuery(true)
	
	if var_33_1 == 1 then
		ConditionContentsManager:dispatch("repair.clear", {
			enter_id = var_33_2
		})
	end
	
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_33_3 = ConditionContentsManager:getUpdateConditions() and json.encode()
	
	UIAction:Add(SEQ(SHOW(false), DELAY(2000), SHOW(true)), arg_33_0.vars.wnd:getChildByName("n_btn_result"), "block")
	query("substory_repair_clear", {
		map_id = var_33_2,
		result = var_33_1,
		substory_id = var_33_0,
		update_conditions = var_33_3
	})
end

function RepairMain.setClearUI(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.vars.wnd:getChildByName("n_fullmetal_start")
	
	if_set_visible(arg_34_0.vars.wnd, "n_count", false)
	if_set_visible(arg_34_0.vars.wnd, "n_result", true)
	if_set_visible(var_34_0, "n_btn_c", false)
	if_set_visible(var_34_0, "n_info", false)
	if_set_visible(var_34_0, "n_time", false)
	
	local var_34_1 = arg_34_0.vars.wnd:getChildByName("n_result")
	local var_34_2 = arg_34_1 == 1
	
	RepairMain:updateNPC_ui(var_34_2 and 5 or 6)
	
	if not var_34_2 then
		if_set_color(arg_34_0.vars.wnd, "n_fullmetal_arrow", tocolor("#818181"))
		if_set_color(var_34_0, "n_progress", tocolor("#818181"))
		if_set_visible(arg_34_0.vars.wnd, "img_fullmetal_fail", true)
		if_set_visible(arg_34_0.vars.wnd, "img_fullmetal", false)
	end
	
	if_set_visible(var_34_1, "n_fail", not var_34_2)
	if_set_visible(var_34_1, "n_success", var_34_2)
	
	local var_34_3
	local var_34_4
	local var_34_5 = 0
	local var_34_6
	
	if var_34_2 then
		var_34_3 = arg_34_0.vars.wnd:getChildByName("n_success")
		var_34_4 = "ui_eff_vfa2aa_repair_success.cfx"
		var_34_6 = 0
	else
		var_34_3 = arg_34_0.vars.wnd:getChildByName("n_fail")
		var_34_4 = "ui_eff_vfa2aa_repair_fail.cfx"
		var_34_6 = 0
	end
	
	local var_34_7 = var_34_3:getChildByName("n_title")
	local var_34_8 = var_34_3:getChildByName("txt_title")
	local var_34_9 = var_34_2 and arg_34_0.vars.data.success_food_name or arg_34_0.vars.data.fail_food_name
	
	if_set(var_34_8, nil, T(var_34_9))
	
	local var_34_10 = UIUtil:getRewardIcon(nil, arg_34_0.vars.data.success_food_icon, {
		is_food = true,
		no_tooltip = true,
		no_bg = true,
		no_detail_popup = true,
		parent = var_34_3:getChildByName("n_food")
	})
	local var_34_11 = var_0_4()
	
	if not var_34_2 then
		if_set_sprite(var_34_10, "icon", var_34_11 .. arg_34_0.vars.data.success_food_icon .. ".png?grayscale=1")
	else
		if_set_sprite(var_34_10, "icon", var_34_11 .. arg_34_0.vars.data.success_food_icon .. ".png")
	end
	
	UIAction:Add(SEQ(CALL(function()
		local var_35_0 = EffectManager:Play({
			pivot_x = 0,
			fn = "ui_substory_cook_end.cfx",
			pivot_z = 99998,
			scale = 2,
			layer = var_34_0,
			pivot_y = var_34_6
		})
	end)), var_34_3, "block")
	UIAction:Add(SEQ(DELAY(1000), CALL(function()
		local var_36_0 = EffectManager:Play({
			pivot_x = 0,
			pivot_z = 99998,
			scale = 1,
			fn = var_34_4,
			layer = var_34_0,
			pivot_y = var_34_6
		})
	end)), var_34_3, "block")
	var_34_10:setOpacity(0)
	UIAction:Add(SEQ(DELAY(1000), FADE_IN(200)), var_34_10, "block")
	var_34_7:setOpacity(0)
	UIAction:Add(SEQ(DELAY(1000), FADE_IN(200)), var_34_7, "block")
	
	local var_34_12 = var_34_1:getChildByName("n_info")
	
	var_34_12:setOpacity(0)
	UIAction:Add(SEQ(DELAY(1000), FADE_IN(200)), var_34_12, "block")
	
	local var_34_13 = var_34_0:getChildByName("n_automail")
	
	var_34_13:setOpacity(0)
	UIAction:Add(SEQ(DELAY(1000), FADE_IN(200)), var_34_13, "block")
end

function RepairMain.res_clear(arg_37_0, arg_37_1)
	local var_37_0 = ConditionContentsManager:updateResponseConditionList(arg_37_1)
	
	if arg_37_1.substory_id and arg_37_1.map and arg_37_1.doc_dungeon_base then
		Account:setSubstoryDungeonBaseInfo(arg_37_1.substory_id, arg_37_1.map, arg_37_1.doc_dungeon_base)
	end
end

function RepairMain.isStartGame(arg_38_0)
	return arg_38_0.vars and arg_38_0.vars.start_game
end

function RepairMain.isTimmerEnd(arg_39_0)
	if var_0_3 then
		return true
	end
	
	return arg_39_0.vars and arg_39_0.vars.timmer_time <= 0
end

function RepairMain.initUI(arg_40_0)
	arg_40_0.vars.n_icon_parent_parent = cc.Node:create()
	
	arg_40_0.vars.wnd:addChild(arg_40_0.vars.n_icon_parent_parent)
	arg_40_0.vars.n_icon_parent_parent:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	arg_40_0.vars.n_icon_parent_parent:setRotation(90)
	arg_40_0.vars.n_icon_parent_parent:setScaleX(-1)
	
	arg_40_0.vars.n_icon_parent = cc.Node:create()
	
	arg_40_0.vars.n_icon_parent_parent:addChild(arg_40_0.vars.n_icon_parent)
	arg_40_0.vars.n_icon_parent:setPosition(0, 0)
	
	arg_40_0.vars.move_icon = arg_40_0.vars.wnd:getChildByName("n_fullmetal_arrow")
	
	local var_40_0 = arg_40_0.vars.move_icon:getParent()
	local var_40_1, var_40_2 = arg_40_0.vars.move_icon:getPosition()
	
	arg_40_0.vars.move_icon:ejectFromParent()
	arg_40_0.vars.move_icon:setPosition(0, 0)
	
	local var_40_3 = cc.Node:create()
	
	var_40_0:addChild(var_40_3)
	var_40_3:setPosition(var_40_1, var_40_2)
	var_40_3:addChild(arg_40_0.vars.move_icon)
	
	arg_40_0.vars.n_n_fullmetal_arrow = var_40_3
	
	arg_40_0.vars.n_icon_parent:bringToFront()
end

function RepairMain.updateGaugeUI(arg_41_0, arg_41_1)
	if arg_41_0:isTimmerEnd() then
		return 
	end
	
	if arg_41_0.vars.minus_start then
		arg_41_0.vars.cur_rotation = arg_41_0:_getCurRotation()
		arg_41_0.vars.dest_rotaion = arg_41_0:_getCurRotation()
		
		return 
	end
	
	if arg_41_0.vars.cur_rotation < arg_41_0.vars.dest_rotaion then
		arg_41_0.vars.cur_rotation = arg_41_0.vars.cur_rotation + arg_41_0.vars.one_touch_add_rotation / 4
		
		arg_41_0:_setCurRotation(arg_41_0.vars.cur_rotation)
	end
end

function RepairMain._start_minus_action(arg_42_0)
	if BattleAction:Find("minus_action") then
		return 
	end
	
	local var_42_0 = arg_42_0:_getCurRotation() * -1
	local var_42_1 = var_0_1
	local var_42_2 = arg_42_0.vars.gauge_reduction_speed or 60
	local var_42_3 = 3500
	
	if arg_42_0.vars.fast_minus_start then
		var_42_1 = arg_42_0.vars.fast_total_time
	else
		var_42_1 = arg_42_0.vars.normal_total_time
	end
	
	arg_42_0.vars.prev_fast_minus_start = arg_42_0.vars.fast_minus_start
	arg_42_0.vars.minus_action = BattleAction:Add(SEQ(MAXRLOG(ROTATE(var_42_1, var_42_0, 0), var_42_3, var_42_2)), arg_42_0.vars.move_icon, "minus_action")
end

function RepairMain._setCurRotation(arg_43_0, arg_43_1)
	if not arg_43_0.vars or not arg_43_0.vars.move_icon then
		return 
	end
	
	local var_43_0 = arg_43_1 * -1
	
	arg_43_0.vars.move_icon:setRotation(var_43_0)
end

function RepairMain._getCurRotation(arg_44_0)
	if not arg_44_0.vars or not arg_44_0.vars.move_icon then
		return 
	end
	
	return arg_44_0.vars.move_icon:getRotation() * -1
end

function RepairMain._debug_force_rot_end_game(arg_45_0, arg_45_1)
	if BattleAction:Find("minus_action") then
		return 
	end
	
	if arg_45_1 then
		arg_45_0:_setCurRotation(arg_45_1)
	end
	
	var_0_3 = true
	
	arg_45_0:calcResult()
end

function RepairMain.play_story(arg_46_0)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.wnd) or not arg_46_0.vars.result then
		return 
	end
	
	local var_46_0 = Account:getSubStoryChoiceID(arg_46_0.vars.enter_id)
	
	SoundEngine:stopAllEvent()
	
	if arg_46_0.vars.result == 0 and arg_46_0.vars.data.fail_story then
		play_story(arg_46_0.vars.data.fail_story, {
			force = true,
			on_finish = function()
				arg_46_0:onLeave()
			end,
			choice_id = var_46_0,
			enter_id = arg_46_0.vars.enter_id
		})
	elseif arg_46_0.vars.result == 1 and arg_46_0.vars.data.success_story then
		play_story(arg_46_0.vars.data.success_story, {
			force = true,
			on_finish = function()
				arg_46_0:onLeave()
			end,
			choice_id = var_46_0,
			enter_id = arg_46_0.vars.enter_id
		})
	else
		arg_46_0:onLeave()
	end
end

function RepairMain._removeAllUpdate(arg_49_0)
	Scheduler:removeByName("repair_update")
	BattleAction:Remove("minus_action")
	arg_49_0:_removeEffect()
end

function RepairMain._removeEffect(arg_50_0)
	if not arg_50_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_50_0.vars.alert_eff) then
		arg_50_0.vars.alert_eff:removeFromParent()
	end
end

function RepairMain.onLeave(arg_51_0)
	arg_51_0.vars.wnd:removeFromParent()
	
	arg_51_0.vars = nil
	
	SceneManager:popScene()
	BackButtonManager:pop("dungeon_story_fullmetal_alchemis")
end
