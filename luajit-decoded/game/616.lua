ExorcistMain = ExorcistMain or {}

function HANDLER.story_halloween_seal(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_guide_bg" then
		if not ExorcistMain:isReadyGame() then
			if ExorcistMain:isTalkEnd() then
				ExorcistMain:ready_game()
				
				return 
			end
			
			ExorcistMain:showNextTalk()
		end
	elseif arg_1_1 == "btn_message" then
		if ExorcistMain:isStartGame() then
			ExorcistMain:touchError()
		end
	elseif string.starts(arg_1_1, "btn_slot") then
		local var_1_0 = string.sub(arg_1_1, 10, -1)
		
		if var_1_0 then
			ExorcistMain:touchCharm(var_1_0)
		end
	end
end

function HANDLER.story_halloween_seal_result(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		ExorcistMain:play_result_story()
	end
end

function MsgHandler.substory_exorcist_clear(arg_3_0)
	if arg_3_0 then
		ExorcistMain:res_clear(arg_3_0)
	end
end

ExorcistMain.CharmFSM = {}
ExorcistMain.CharmFSM.STATE = {}

local var_0_0 = {
	burn_idle = "burn_idle",
	charm_idle = "charm_idle",
	burn_hit = "burn_hit",
	burn_start = "burn_start",
	charm_start = "charm_start"
}
local var_0_1 = {
	burn_idle = "ui_exorcist_charm_active_idle_2022.cfx",
	charm_idle = "ui_exorcist_charm_idle_2022.cfx",
	burn_hit = "ui_exorcist_charm_active_hit_2022.cfx",
	burn_start = "ui_exorcist_charm_active_2022.cfx",
	charm_start = "ui_exorcist_charm_start_2022.cfx"
}

function ExorcistMain.CharmFSM.isCurrentState(arg_4_0, arg_4_1, arg_4_2)
	if table.empty(arg_4_0.charm_tbl) or not arg_4_1 or not arg_4_2 then
		return 
	end
	
	local var_4_0 = arg_4_0.charm_tbl[arg_4_1]
	
	if var_4_0 and var_4_0.state == arg_4_2 then
		return true
	end
	
	return false
end

function ExorcistMain.CharmFSM.changeState(arg_5_0, arg_5_1, arg_5_2)
	if table.empty(arg_5_0.charm_tbl) or not arg_5_1 or not arg_5_2 then
		return 
	end
	
	if arg_5_0:isCurrentState(arg_5_1, arg_5_2) then
		return 
	end
	
	local var_5_0 = arg_5_0.charm_tbl[arg_5_1]
	
	if var_5_0 then
		arg_5_0:_onExit(arg_5_1)
		
		var_5_0.state = arg_5_2
		
		arg_5_0:_onEnter(arg_5_1, arg_5_2)
	end
end

function ExorcistMain.CharmFSM._onEnter(arg_6_0, arg_6_1, arg_6_2)
	if not arg_6_1 or not arg_6_2 then
		return 
	end
	
	arg_6_0.STATE[arg_6_2]:enter(arg_6_1)
end

function ExorcistMain.CharmFSM._onExit(arg_7_0, arg_7_1)
	if not arg_7_1 then
		return 
	end
	
	arg_7_0.STATE:exit(arg_7_1)
end

function ExorcistMain.CharmFSM.STATE.exit(arg_8_0, arg_8_1)
	local var_8_0 = ExorcistMain.CharmFSM.charm_tbl[arg_8_1]
	
	if var_8_0 then
		var_8_0.node:removeAllChildren()
	end
end

ExorcistMain.CharmFSM.STATE[var_0_0.charm_start] = {}
ExorcistMain.CharmFSM.STATE[var_0_0.charm_start].enter = function(arg_9_0, arg_9_1)
	if table.empty(ExorcistMain.CharmFSM.charm_tbl) or not arg_9_1 then
		return 
	end
	
	local var_9_0 = ExorcistMain.CharmFSM.charm_tbl[arg_9_1]
	
	if var_9_0 and var_9_0.node and var_9_0.state then
		local var_9_1 = var_0_1[var_9_0.state]
		
		EffectManager:Play({
			fn = var_9_1,
			layer = var_9_0.node
		})
		UIAction:Add(SEQ(DELAY(250), CALL(ExorcistMain.CharmFSM.changeState, ExorcistMain.CharmFSM, arg_9_1, var_0_0.charm_idle)), var_9_0.node)
	end
end
ExorcistMain.CharmFSM.STATE[var_0_0.charm_idle] = {}
ExorcistMain.CharmFSM.STATE[var_0_0.charm_idle].enter = function(arg_10_0, arg_10_1)
	if table.empty(ExorcistMain.CharmFSM.charm_tbl) or not arg_10_1 then
		return 
	end
	
	local var_10_0 = ExorcistMain.CharmFSM.charm_tbl[arg_10_1]
	
	if var_10_0 and var_10_0.node and var_10_0.state then
		local var_10_1 = var_0_1[var_10_0.state]
		
		EffectManager:Play({
			fn = var_10_1,
			layer = var_10_0.node
		})
	end
end
ExorcistMain.CharmFSM.STATE[var_0_0.burn_start] = {}
ExorcistMain.CharmFSM.STATE[var_0_0.burn_start].enter = function(arg_11_0, arg_11_1)
	if table.empty(ExorcistMain.CharmFSM.charm_tbl) or not arg_11_1 then
		return 
	end
	
	local var_11_0 = ExorcistMain.CharmFSM.charm_tbl[arg_11_1]
	
	if var_11_0 and var_11_0.node and var_11_0.state then
		local var_11_1 = var_0_1[var_11_0.state]
		
		EffectManager:Play({
			fn = var_11_1,
			layer = var_11_0.node
		})
		UIAction:Add(SEQ(DELAY(400), CALL(ExorcistMain.CharmFSM.changeState, ExorcistMain.CharmFSM, arg_11_1, var_0_0.burn_idle)), var_11_0.node)
	end
end
ExorcistMain.CharmFSM.STATE[var_0_0.burn_idle] = {}
ExorcistMain.CharmFSM.STATE[var_0_0.burn_idle].enter = function(arg_12_0, arg_12_1)
	if table.empty(ExorcistMain.CharmFSM.charm_tbl) or not arg_12_1 then
		return 
	end
	
	local var_12_0 = ExorcistMain.CharmFSM.charm_tbl[arg_12_1]
	
	if var_12_0 and var_12_0.node and var_12_0.state then
		local var_12_1 = var_0_1[var_12_0.state]
		
		EffectManager:Play({
			fn = var_12_1,
			layer = var_12_0.node
		})
	end
end
ExorcistMain.CharmFSM.STATE[var_0_0.burn_hit] = {}
ExorcistMain.CharmFSM.STATE[var_0_0.burn_hit].enter = function(arg_13_0, arg_13_1)
	if table.empty(ExorcistMain.CharmFSM.charm_tbl) or not arg_13_1 then
		return 
	end
	
	local var_13_0 = ExorcistMain.CharmFSM.charm_tbl[arg_13_1]
	
	if var_13_0 and var_13_0.node and var_13_0.state then
		local var_13_1 = var_0_1[var_13_0.state]
		
		EffectManager:Play({
			fn = var_13_1,
			layer = var_13_0.node
		})
		UIAction:Add(SEQ(DELAY(150), CALL(ExorcistMain.CharmFSM.changeState, ExorcistMain.CharmFSM, arg_13_1, var_0_0.burn_idle)), var_13_0.node)
	end
end

function ExorcistMain.onEnter(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	local var_14_0, var_14_1 = DB("level_enter", arg_14_1, {
		"id",
		"type"
	})
	
	if not var_14_0 or not var_14_1 or var_14_1 ~= "exorcist" then
		return 
	end
	
	arg_14_0:init(arg_14_1)
	
	if DEBUG.SKIP_STORY then
		arg_14_0:initUI()
	else
		arg_14_0:play_enter_story()
	end
end

function ExorcistMain.init(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	if not DB("substory_exorcist", arg_15_1, {
		"id"
	}) then
		return 
	end
	
	arg_15_0.vars = arg_15_0.vars or {}
	arg_15_0.vars.enter_id = arg_15_1
	arg_15_0.vars.wnd = load_dlg("story_halloween_seal", true, "wnd")
	
	arg_15_0.vars.wnd:setVisible(false)
	SceneManager:getRunningPopupScene():addChild(arg_15_0.vars.wnd)
	arg_15_0.vars.wnd:getChildByName("n_seal"):getChildByName("img_magicsquare"):setOpacity(0)
	arg_15_0:initData()
end

function ExorcistMain.initData(arg_16_0)
	if not arg_16_0.vars or not arg_16_0.vars.enter_id then
		return 
	end
	
	local var_16_0 = arg_16_0.vars.enter_id
	local var_16_1 = DBT("substory_exorcist", var_16_0, {
		"id",
		"stage_bg",
		"circle_effect",
		"charm_effect",
		"spot_effect",
		"charm_spot",
		"charm_pattern",
		"time_charm",
		"time_limit",
		"time_fail",
		"time_warning",
		"talk_ready",
		"success_story",
		"next_round",
		"touch_error_msg"
	})
	
	if not var_16_1 or table.empty(var_16_1) then
		return 
	end
	
	arg_16_0.vars.data = var_16_1
	
	local var_16_2 = {}
	
	if arg_16_0.vars.data.circle_effect then
		var_16_2 = string.split(arg_16_0.vars.data.circle_effect, ",")
		arg_16_0.vars.data.circle_effect = var_16_2
	end
	
	if arg_16_0.vars.data.next_round then
		var_16_2 = string.split(arg_16_0.vars.data.next_round, ",")
	end
	
	table.insert(var_16_2, 1, arg_16_0.vars.enter_id)
	
	arg_16_0.vars.data.next_round = var_16_2
	arg_16_0.vars.cur_round = 1
	arg_16_0.vars.substory_id = SubstoryManager:getInfoID() or "vha2aa"
	
	arg_16_0:initRoundData(arg_16_0.vars.cur_round)
end

local function var_0_2(arg_17_0)
	local var_17_0 = {}
	
	arg_17_0 = string.split(arg_17_0, ",")
	
	local function var_17_1(arg_18_0, arg_18_1)
		if not arg_18_0 or not arg_18_1 or arg_18_1 == 1 then
			return 
		end
		
		local var_18_0 = {}
		
		for iter_18_0 = 1, arg_18_1 do
			local var_18_1 = string.sub(arg_18_0, iter_18_0, iter_18_0)
			
			table.insert(var_18_0, var_18_1)
		end
		
		return var_18_0
	end
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0) do
		local var_17_2 = var_17_1(iter_17_1, string.len(iter_17_1))
		
		if var_17_2 then
			arg_17_0[iter_17_0] = var_17_2
		end
	end
	
	return arg_17_0
end

local function var_0_3(arg_19_0)
	if not arg_19_0 then
		return 
	end
	
	local var_19_0 = {}
	
	arg_19_0 = string.split(arg_19_0, ";")
	
	local function var_19_1(arg_20_0)
		if not arg_20_0 then
			return 
		end
		
		local var_20_0 = {}
		
		return (string.split(arg_20_0, ","))
	end
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0) do
		local var_19_2 = var_19_1(iter_19_1)
		
		if var_19_2 then
			arg_19_0[iter_19_0] = var_19_2
		end
	end
	
	return arg_19_0
end

function ExorcistMain.initRoundData(arg_21_0, arg_21_1)
	if not arg_21_0.vars or table.empty(arg_21_0.vars.data.next_round) or not arg_21_1 then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.data.next_round[arg_21_1]
	
	if not var_21_0 then
		return 
	end
	
	local var_21_1 = DBT("substory_exorcist", var_21_0, {
		"charm_spot",
		"charm_pattern",
		"time_charm",
		"time_limit",
		"time_fail",
		"time_warning",
		"talk_ready"
	})
	
	if not var_21_1 or table.empty(var_21_1) then
		return 
	end
	
	if var_21_1.charm_spot then
		local var_21_2 = {}
		local var_21_3 = string.split(var_21_1.charm_spot, ",")
		
		arg_21_0.vars.data.charm_spot = var_21_3
	end
	
	if var_21_1.charm_pattern then
		arg_21_0.vars.data.charm_pattern = var_0_2(var_21_1.charm_pattern)
		
		local var_21_4 = math.random(1, table.count(arg_21_0.vars.data.charm_pattern))
		
		arg_21_0.vars.answer_pattern = Queue.new()
		
		for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.data.charm_pattern[var_21_4]) do
			if table.count(arg_21_0.vars.data.charm_spot) == 5 and iter_21_1 == "5" then
				iter_21_1 = "5_0"
			end
			
			Queue.push(arg_21_0.vars.answer_pattern, iter_21_1)
		end
	end
	
	arg_21_0.vars.data.time_charm = var_21_1.time_charm
	arg_21_0.vars.data.time_limit = var_21_1.time_limit / 1000
	arg_21_0.vars.data.time_fail = var_21_1.time_fail / 1000
	
	if var_21_1.time_warning then
		local var_21_5
		local var_21_6 = string.split(var_21_1.time_warning, ",")
		
		for iter_21_2, iter_21_3 in pairs(var_21_6) do
			var_21_6[iter_21_2] = var_21_6[iter_21_2] / 1000
		end
		
		arg_21_0.vars.data.time_warning = var_21_6
	end
	
	if var_21_1.talk_ready then
		arg_21_0.vars.data.talk_ready = var_0_3(var_21_1.talk_ready)
		arg_21_0.vars.cur_talk = 1
	end
	
	arg_21_0.vars.ready_game = false
	arg_21_0.vars.start_game = false
end

function ExorcistMain.isReadyGame(arg_22_0)
	return arg_22_0.vars and arg_22_0.vars.ready_game
end

function ExorcistMain.isStartGame(arg_23_0)
	return arg_23_0.vars and arg_23_0.vars.start_game
end

local function var_0_4(arg_24_0, arg_24_1)
	if not arg_24_0 or not get_cocos_refid(arg_24_0.wnd) or not arg_24_1 or table.empty(arg_24_1) then
		return 
	end
	
	local function var_24_0(arg_25_0, arg_25_1)
		if not arg_25_0 then
			return 
		end
		
		local var_25_0 = arg_25_0:getChildByName("n_talk_box")
		local var_25_1 = var_25_0:getChildByName("txt_disc")
		local var_25_2 = var_25_1:getContentSize()
		
		if_set(var_25_0, "txt_disc", string.gsub(arg_25_1, "%\\n", "\n"))
		
		local var_25_3 = var_25_1:getContentSize()
		
		if getUserLanguage() ~= "ja" or not string.find(arg_25_1, "\n") then
			local var_25_4 = VIEW_WIDTH * 0.78
			local var_25_5 = 100
			
			if var_25_4 < var_25_3.width then
				local var_25_6 = var_25_1:getLineHeight()
				local var_25_7 = math.ceil(var_25_3.width / var_25_4)
				local var_25_8 = var_25_3.width / var_25_7 + var_25_5
				
				var_25_1:setTextAreaSize({
					width = var_25_8,
					height = var_25_6 * var_25_7
				})
				var_25_1:setTextAreaSize({
					width = var_25_8,
					height = var_25_6 * var_25_1:getStringNumLines()
				})
				
				var_25_3 = var_25_1:getContentSize()
			end
		end
		
		var_25_0:getChildByName("box_bg"):setContentSize(var_25_3.width + 80, var_25_3.height + 100)
		
		local var_25_9 = var_25_1:getContentSize()
		local var_25_10 = {
			x = var_25_9.width - var_25_2.width,
			y = var_25_9.height - var_25_2.height
		}
		local var_25_11 = arg_25_0:getContentSize()
		
		var_25_11.width = var_25_11.width + var_25_10.x
		var_25_11.height = var_25_11.height + var_25_10.y
		
		var_25_0:setPositionY(var_25_0:getPositionY() + var_25_10.y * 0.5)
		
		local var_25_12 = 0
		local var_25_13 = arg_25_0:getPositionY()
		local var_25_14 = math.min(VIEW_BASE_LEFT + var_25_12, VIEW_BASE_RIGHT - var_25_11.width)
		local var_25_15 = math.min(var_25_13, VIEW_HEIGHT - var_25_11.height)
		
		arg_25_0:setPosition(var_25_14 - (var_25_11.width + 200), var_25_15)
		UIAction:Add(SPAWN(FADE_IN(50), LOG(MOVE_TO(100, var_25_14, var_25_15))), arg_25_0)
		set_high_fps_tick(3000)
	end
	
	if arg_24_0.cur_n_talk and get_cocos_refid(arg_24_0.cur_n_talk) then
		arg_24_0.cur_n_talk:removeFromParent()
		
		arg_24_0.cur_n_talk = nil
	end
	
	local var_24_1 = arg_24_0.n_talk:clone()
	
	if var_24_1 then
		arg_24_0.wnd:addChild(var_24_1)
		var_24_1:setPositionY(arg_24_0.n_talk:getPositionY())
		SpriteCache:resetSprite(var_24_1:getChildByName("talk_face"), "face/" .. arg_24_1[1] .. ".png")
		if_set(var_24_1, "talk_name", T(arg_24_1[2]))
		var_24_0(var_24_1, T(arg_24_1[3]))
		
		arg_24_0.cur_n_talk = var_24_1
	end
end

function ExorcistMain.showNextTalk(arg_26_0)
	if not arg_26_0.vars or not arg_26_0.vars.cur_talk or not arg_26_0.vars.wnd or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	if not arg_26_0.vars.n_talk then
		return 
	end
	
	arg_26_0.vars.cur_talk = arg_26_0.vars.cur_talk + 1
	
	UIAction:Add(SEQ(CALL(var_0_4, arg_26_0.vars, arg_26_0.vars.data.talk_ready[arg_26_0.vars.cur_talk]), DELAY(1000)), arg_26_0.vars.wnd, "block")
end

function ExorcistMain.initUI(arg_27_0)
	if not arg_27_0.vars or not arg_27_0.vars.wnd or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	if arg_27_0.vars.cur_round and arg_27_0.vars.cur_round > 1 then
		local var_27_0 = arg_27_0.vars.data.circle_effect[2]
		local var_27_1 = arg_27_0.vars.wnd:getChildByName("n_seal"):getChildByName("n_magicsquare_effect"):getChildByName(var_27_0)
		
		var_27_1:ejectFromParent()
		SceneManager:getRunningPopupScene():addChild(var_27_1)
		arg_27_0.vars.wnd:removeFromParent()
		
		arg_27_0.vars.wnd = load_dlg("story_halloween_seal", true, "wnd")
		
		arg_27_0.vars.wnd:getChildByName("Image_dim_bg"):setVisible(true)
		
		local var_27_2 = arg_27_0.vars.wnd:getChildByName("n_seal")
		local var_27_3 = SceneManager:getRunningPopupScene():getChildByName(var_27_0)
		
		var_27_3:ejectFromParent()
		var_27_2:getChildByName("n_magicsquare_effect"):addChild(var_27_3)
		SceneManager:getRunningPopupScene():addChild(arg_27_0.vars.wnd)
	end
	
	local var_27_4 = arg_27_0.vars.wnd
	local var_27_5 = var_27_4:getChildByName("n_bg")
	
	if var_27_5 then
		local var_27_6 = cc.Sprite:create(UIUtil:getIllustPath("story/bg/", arg_27_0.vars.data.stage_bg))
		
		var_27_6:setName("bg")
		var_27_5:addChild(var_27_6)
	end
	
	SoundEngine:playBGM("event:/bgm/hal2022_Battle1_Loop")
	
	arg_27_0.vars.n_talk = var_27_4:getChildByName("n_talk")
	
	UIAction:Add(DELAY(2000), var_27_4, "block")
end

function ExorcistMain.play_enter_story(arg_28_0)
	local var_28_0, var_28_1 = DB("level_enter", arg_28_0.vars.enter_id, {
		"id",
		"story_stage_link"
	})
	
	if not var_28_0 or not var_28_1 then
		return 
	end
	
	local function var_28_2()
		UIAction:Add(SEQ(CALL(function()
			arg_28_0:initUI()
		end), FADE_IN(1000), CALL(var_0_4, arg_28_0.vars, arg_28_0.vars.data.talk_ready[arg_28_0.vars.cur_talk])), arg_28_0.vars.wnd)
	end
	
	play_story(var_28_1, {
		force = true,
		enter_id = arg_28_0.vars.enter_id,
		on_finish = var_28_2
	})
end

function ExorcistMain.isTalkEnd(arg_31_0)
	if not arg_31_0.vars or not arg_31_0.vars.cur_talk or table.empty(arg_31_0.vars.data.talk_ready) then
		return 
	end
	
	return table.count(arg_31_0.vars.data.talk_ready) == arg_31_0.vars.cur_talk
end

function ExorcistMain.ready_game(arg_32_0)
	if not arg_32_0.vars or not arg_32_0.vars.wnd or not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	if arg_32_0.vars.cur_round and arg_32_0.vars.cur_round > 1 then
		arg_32_0:initUI()
	end
	
	local var_32_0 = arg_32_0.vars.wnd
	
	if arg_32_0.vars.cur_n_talk and get_cocos_refid(arg_32_0.vars.cur_n_talk) then
		arg_32_0.vars.cur_n_talk:removeFromParent()
		
		arg_32_0.vars.cur_n_talk = nil
	end
	
	local function var_32_1(arg_33_0)
		local var_33_0 = arg_33_0:getChildByName("n_seal"):getChildByName("n_magicsquare_effect")
		
		EffectManager:Play({
			fn = arg_32_0.vars.data.circle_effect[1] .. ".cfx",
			layer = var_33_0
		})
	end
	
	local function var_32_2(arg_34_0)
		arg_34_0:getChildByName("Image_dim_bg"):setVisible(true)
		
		local var_34_0 = arg_34_0:getChildByName("n_seal")
		
		var_34_0:getChildByName("img_magicsquare"):setOpacity(255)
		
		local var_34_1 = var_34_0:getChildByName("n_magicsquare_effect")
		
		EffectManager:Play({
			fn = arg_32_0.vars.data.circle_effect[2] .. ".cfx",
			layer = var_34_1
		})
	end
	
	local function var_32_3(arg_35_0)
		for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.data.charm_spot) do
			local var_35_0 = arg_35_0.vars.wnd:getChildByName("n_charm"):getChildByName("n_charm_eff_" .. iter_35_1)
			
			UIAction:Add(SEQ(CALL(function()
				EffectManager:Play({
					fn = arg_35_0.vars.data.spot_effect .. ".cfx",
					layer = var_35_0
				})
			end), DELAY(500), CALL(function()
				local var_37_0 = var_32_0:getChildByName("n_seal"):getChildByName("n_slot"):getChildByName("btn_slot_" .. iter_35_1)
				
				if var_37_0 then
					var_37_0:setVisible(true)
				end
			end)), var_35_0)
		end
	end
	
	arg_32_0.vars.cur_id = 0
	arg_32_0.CharmFSM.charm_tbl = {}
	
	local function var_32_4(arg_38_0)
		local var_38_0 = arg_38_0.vars.cur_id
		local var_38_1 = arg_38_0.vars.answer_pattern
		local var_38_2 = var_38_1[var_38_0]
		
		if Queue.size(var_38_1) == 5 and var_38_2 == "5" then
			var_38_2 = "5_0"
		end
		
		local var_38_3 = arg_38_0.vars.wnd:getChildByName("n_charm"):getChildByName("n_charm_" .. var_38_2)
		local var_38_4 = {
			state = "none",
			node = var_38_3
		}
		
		arg_38_0.CharmFSM.charm_tbl[var_38_2] = var_38_4
		
		arg_38_0.CharmFSM:changeState(var_38_2, var_0_0.charm_start)
		
		arg_38_0.vars.cur_id = arg_38_0.vars.cur_id + 1
	end
	
	local function var_32_5(arg_39_0)
		Scheduler:add(arg_39_0.vars.wnd, arg_39_0.update, arg_39_0):setName("exorcist_update")
		
		arg_39_0.vars.ready_game = true
		
		arg_39_0:start_game()
	end
	
	if arg_32_0.vars.cur_round and arg_32_0.vars.cur_round > 1 then
		UIAction:Add(SEQ(CALL(var_32_3, arg_32_0), DELAY(1000 + arg_32_0.vars.data.time_charm), COND_LOOP(SEQ(CALL(var_32_4, arg_32_0), DELAY(arg_32_0.vars.data.time_charm)), function()
			if arg_32_0.vars.cur_id and arg_32_0.vars.cur_id == Queue.size(arg_32_0.vars.answer_pattern) then
				return true
			end
		end), DELAY(arg_32_0.vars.data.time_charm), CALL(var_32_5, arg_32_0)), var_32_0, "block")
	else
		UIAction:Add(SEQ(CALL(var_32_1, var_32_0), DELAY(900), CALL(var_32_2, var_32_0), DELAY(1000), CALL(var_32_3, arg_32_0), DELAY(1000 + arg_32_0.vars.data.time_charm), COND_LOOP(SEQ(CALL(var_32_4, arg_32_0), DELAY(arg_32_0.vars.data.time_charm)), function()
			if arg_32_0.vars.cur_id and arg_32_0.vars.cur_id == Queue.size(arg_32_0.vars.answer_pattern) then
				return true
			end
		end), DELAY(arg_32_0.vars.data.time_charm), CALL(var_32_5, arg_32_0)), var_32_0, "block")
	end
end

local function var_0_5(arg_42_0, arg_42_1)
	if not arg_42_0 or not get_cocos_refid(arg_42_0) or not arg_42_1 then
		return 
	end
	
	local var_42_0 = arg_42_0:getChildByName("n_start_success")
	local var_42_1 = arg_42_0:getChildByName("n_cloud")
	
	if var_42_0 then
		if arg_42_1 == "img_start" then
			local var_42_2 = arg_42_0:getChildByName("img_seal_bg")
			
			var_42_2:setOpacity(0)
			UIAction:Add(FADE_IN(200), var_42_2)
		end
		
		local var_42_3 = var_42_0:getChildByName("n_deco")
		
		if var_42_3 then
			local var_42_4 = 5
			local var_42_5 = 4
			
			for iter_42_0, iter_42_1 in pairs(var_42_3:getChildren() or {}) do
				local var_42_6 = math.random() * math.pi
				local var_42_7 = iter_42_1:getRotation()
				local var_42_8 = LINEAR_CALL(2000, nil, function(arg_43_0, arg_43_1)
					iter_42_1:setRotation(var_42_7 + math.sin(var_42_6 + arg_43_1) * var_42_4)
				end, 0, math.pi * var_42_5)
				
				UIAction:Add(var_42_8, iter_42_1)
			end
			
			var_42_3:setOpacity(0)
			UIAction:Add(SEQ(DELAY(200), FADE_IN(300)), var_42_3)
		end
		
		local var_42_9 = var_42_0:getChildByName(arg_42_1)
		
		if var_42_9 then
			var_42_9:setOpacity(0)
			UIAction:Add(SEQ(DELAY(200), FADE_IN(800)), var_42_9)
		end
	end
	
	if var_42_1 then
		local var_42_10 = {}
		
		for iter_42_2, iter_42_3 in pairs(var_42_1:getChildren() or {}) do
			iter_42_3:setOpacity(0)
			iter_42_3:setVisible(false)
			table.insert(var_42_10, iter_42_3)
		end
		
		for iter_42_4 = 1, 2 do
			UIAction:Add(SEQ(DELAY(200), SPAWN(FADE_IN(800), LOG(MOVE_TO(1400, var_42_10[iter_42_4]:getPositionX() - 100)))), var_42_10[iter_42_4])
		end
		
		UIAction:Add(SEQ(DELAY(200), SPAWN(FADE_IN(800), LOG(MOVE_TO(1400, var_42_10[3]:getPositionX() + 100)))), var_42_10[3])
	end
end

local function var_0_6(arg_44_0)
	if not arg_44_0 or not get_cocos_refid(arg_44_0) then
		return 
	end
	
	local var_44_0 = arg_44_0:getChildByName("n_seal_failure")
	local var_44_1 = arg_44_0:getChildByName("n_cloud")
	
	if var_44_0 then
		local var_44_2 = var_44_0:getChildByName("img_seal_failure")
		
		var_44_2:setOpacity(0)
		UIAction:Add(SEQ(DELAY(200), FADE_IN(800)), var_44_2)
	end
	
	if var_44_1 then
		local var_44_3 = {}
		
		for iter_44_0, iter_44_1 in pairs(var_44_1:getChildren() or {}) do
			iter_44_1:setOpacity(0)
			iter_44_1:setVisible(false)
			table.insert(var_44_3, iter_44_1)
		end
		
		for iter_44_2 = 1, 2 do
			UIAction:Add(SEQ(DELAY(200), SPAWN(FADE_IN(800), LOG(MOVE_TO(1400, var_44_3[iter_44_2]:getPositionX() - 100)))), var_44_3[iter_44_2])
		end
		
		UIAction:Add(SEQ(DELAY(200), SPAWN(FADE_IN(800), LOG(MOVE_TO(1400, var_44_3[3]:getPositionX() + 100)))), var_44_3[3])
	end
end

function ExorcistMain.start_game(arg_45_0)
	if not arg_45_0.vars or not arg_45_0.vars.wnd or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	if arg_45_0.vars.cur_n_talk and get_cocos_refid(arg_45_0.vars.cur_n_talk) then
		arg_45_0.vars.cur_n_talk:removeFromParent()
		
		arg_45_0.vars.cur_n_talk = nil
	end
	
	local var_45_0 = load_dlg("story_halloween_seal_result", true, "wnd")
	
	var_45_0:getChildByName("btn_close"):setVisible(false)
	SceneManager:getRunningPopupScene():addChild(var_45_0)
	
	local var_45_1 = var_45_0:getChildByName("n_title")
	
	if var_45_1 then
		var_0_5(var_45_1, "img_start")
		SoundEngine:play("event:/effect/exorcist_2022_scene_start")
	end
	
	UIAction:Add(SEQ(DELAY(1600), FADE_OUT(300), REMOVE(), CALL(function()
		arg_45_0.vars.timer_time = arg_45_0.vars.data.time_limit
		
		arg_45_0:setTimerUI(arg_45_0.vars.timer_time)
		
		arg_45_0.vars.before_time = systick()
		arg_45_0.vars.start_game = true
	end)), var_45_0, "start_font")
end

function ExorcistMain.update(arg_47_0)
	if not arg_47_0:isStartGame() then
		return 
	end
	
	if arg_47_0:isExorcistSuccess() then
		if arg_47_0:isFinalRound() then
			arg_47_0:clear(1)
			
			return 
		end
		
		arg_47_0:setNewRound()
		
		return 
	end
	
	if arg_47_0.vars.timer_time <= 0 then
		arg_47_0:clear(0)
		
		return 
	end
	
	if systick() - arg_47_0.vars.before_time >= 1000 then
		arg_47_0.vars.timer_time = arg_47_0.vars.timer_time - 1
		
		arg_47_0:updateTimerUI(arg_47_0.vars.timer_time)
		
		arg_47_0.vars.before_time = systick()
	end
	
	arg_47_0:showWarningUI()
end

function ExorcistMain.setNewRound(arg_48_0)
	if not arg_48_0.vars or not arg_48_0.vars.cur_round then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.wnd:getChildByName("n_vignetting")
	
	if var_48_0 then
		UIAction:Add(FADE_OUT(500, true), var_48_0)
	end
	
	local var_48_1 = arg_48_0.vars.wnd:getChildByName("n_time")
	
	UIAction:Add(FADE_OUT(500, true), var_48_1)
	
	local var_48_2 = arg_48_0.vars.wnd:getChildByName("caution")
	
	if var_48_2 then
		UIAction:Remove("caution")
		UIAction:Add(SEQ(FADE_OUT(500, true), REMOVE()), var_48_2)
	end
	
	arg_48_0.vars.cur_round = arg_48_0.vars.cur_round + 1
	
	arg_48_0:initRoundData(arg_48_0.vars.cur_round)
	
	local var_48_3 = arg_48_0.vars.wnd:getChildByName("n_seal")
	local var_48_4 = var_48_3:getChildByName("n_seal_effect")
	
	var_48_4:setVisible(true)
	UIAction:Add(SEQ(CALL(function()
		EffectManager:Play({
			fn = arg_48_0.vars.data.circle_effect[3] .. ".cfx",
			layer = var_48_4
		})
	end), DELAY(700), CALL(function()
		if var_48_3 and get_cocos_refid(var_48_3) then
			local var_50_0 = var_48_3:getChildByName("n_slot")
			
			UIAction:Add(FADE_OUT(500, true), var_50_0)
			
			local var_50_1 = var_48_3:getChildByName("n_charm")
			
			UIAction:Add(FADE_OUT(300, true), var_50_1)
		end
	end), DELAY(500), CALL(var_0_4, arg_48_0.vars, arg_48_0.vars.data.talk_ready[arg_48_0.vars.cur_talk])), arg_48_0.vars.wnd, "block")
end

function ExorcistMain.isFinalRound(arg_51_0)
	if not arg_51_0.vars or not arg_51_0.vars.wnd or not get_cocos_refid(arg_51_0.vars.wnd) then
		return 
	end
	
	return arg_51_0.vars.cur_round == table.count(arg_51_0.vars.data.next_round)
end

function ExorcistMain.isExorcistSuccess(arg_52_0)
	if not arg_52_0.vars or not arg_52_0.vars.wnd or not get_cocos_refid(arg_52_0.vars.wnd) then
		return 
	end
	
	return Queue.size(arg_52_0.vars.answer_pattern) == 0
end

function ExorcistMain.touchError(arg_53_0)
	if not arg_53_0.vars or not arg_53_0.vars.wnd or not get_cocos_refid(arg_53_0.vars.wnd) then
		return 
	end
	
	local var_53_0 = arg_53_0.vars.wnd:getChildByName("n_charm")
	
	UIAction:Add(SHAKE_UI(300, 10, true, {
		only_x = true
	}), var_53_0, "block")
	
	local var_53_1 = arg_53_0.vars.data.touch_error_msg
	
	if var_53_1 then
		local var_53_2 = "effect/exorcist_2022_charm_error"
		
		balloon_message(T(var_53_1), var_53_2, 0, {
			delay = 500,
			layer = arg_53_0.vars.wnd
		})
	end
end

function ExorcistMain.touchCharm(arg_54_0, arg_54_1)
	if not arg_54_0:isStartGame() then
		return 
	end
	
	if not arg_54_0.vars or not arg_54_0.vars.wnd or not get_cocos_refid(arg_54_0.vars.wnd) or not arg_54_1 then
		return 
	end
	
	local var_54_0 = Queue.top(arg_54_0.vars.answer_pattern)
	
	if not Queue.exist(arg_54_0.vars.answer_pattern, function(arg_55_0)
		return arg_55_0 == arg_54_1
	end) then
		arg_54_0.CharmFSM:changeState(arg_54_1, var_0_0.burn_hit)
		
		return 
	end
	
	if var_54_0 == arg_54_1 then
		arg_54_0.CharmFSM:changeState(arg_54_1, var_0_0.burn_start)
		Queue.pop(arg_54_0.vars.answer_pattern)
		
		return 
	end
	
	arg_54_0.vars.timer_time = arg_54_0.vars.timer_time - arg_54_0.vars.data.time_fail
	
	if arg_54_0.vars.timer_time <= 0 then
		arg_54_0.vars.timer_time = 0
	end
	
	arg_54_0:updateTimerUI(arg_54_0.vars.timer_time, cc.c3b(255, 119, 119), 500)
	
	local var_54_1 = arg_54_0.vars.wnd:getChildByName("n_vignetting"):getChildByName("Image_vignetting_2")
	
	UIAction:Add(SHAKE_UI(300, 30, true, {
		only_x = true
	}), arg_54_0.vars.wnd)
	var_54_1:setOpacity(255)
	UIAction:Add(SEQ(SHOW(true), DELAY(300), FADE_OUT(200, true)), var_54_1, "block")
	SoundEngine:play("event:/effect/exorcist_2022_charm_faile")
end

function ExorcistMain.showWarningUI(arg_56_0)
	if not arg_56_0.vars or not arg_56_0.vars.wnd or not get_cocos_refid(arg_56_0.vars.wnd) then
		return 
	end
	
	if arg_56_0.vars.timer_time <= arg_56_0.vars.data.time_warning[1] then
		if UIAction:Find("show_warning") then
			return 
		end
		
		local var_56_0 = arg_56_0.vars.wnd:getChildByName("n_vignetting")
		local var_56_1 = var_56_0:getChildByName("Image_vignetting_3")
		local var_56_2 = var_56_0:getChildByName("Image_vignetting")
		
		local function var_56_3(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
			return LINEAR_CALL(arg_57_0 * 1000, arg_57_3, function(arg_58_0, arg_58_1)
				local var_58_0 = (math.cos(arg_58_1) - 1) * -0.5
				
				arg_58_0:setOpacity(((1 - var_58_0) * arg_57_1 + var_58_0 * arg_57_2) * 255)
			end, 0, math.pi * arg_57_4)
		end
		
		var_56_1:setVisible(true)
		var_56_2:setVisible(true)
		var_56_1:setOpacity(0)
		var_56_2:setOpacity(0)
		UIAction:Add(SEQ(var_56_3(arg_56_0.vars.data.time_warning[1] - arg_56_0.vars.data.time_warning[2], 0, 0.85, var_56_1, 6), SHOW(false)), var_56_1, "show_warning")
		UIAction:Add(SEQ(DELAY((arg_56_0.vars.data.time_warning[1] - arg_56_0.vars.data.time_warning[2]) * 1000), var_56_3(arg_56_0.vars.data.time_warning[2], 0, 0.9, var_56_2, 10), SHOW(false)), var_56_2, "show_warning")
	end
end

function ExorcistMain.setTimerUI(arg_59_0, arg_59_1)
	if not arg_59_0.vars or not arg_59_0.vars.wnd or not get_cocos_refid(arg_59_0.vars.wnd) or not arg_59_1 then
		return 
	end
	
	local var_59_0 = arg_59_0.vars.wnd:getChildByName("n_time")
	
	if var_59_0 then
		if_set(var_59_0, "t_score", arg_59_1)
	end
	
	UIAction:Add(FADE_IN(500), var_59_0)
end

function ExorcistMain.updateTimerUI(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	if not arg_60_0.vars or not arg_60_0.vars.wnd or not get_cocos_refid(arg_60_0.vars.wnd) or not arg_60_1 then
		return 
	end
	
	local var_60_0 = arg_60_0.vars.wnd:getChildByName("n_time")
	
	if var_60_0 then
		if_set(var_60_0, "t_score", arg_60_1)
	end
	
	if arg_60_2 and arg_60_3 then
		local var_60_1 = cc.c3b(255, 255, 255)
		
		UIAction:Add(SEQ(COLOR(0, arg_60_2.r, arg_60_2.g, arg_60_2.b), DELAY(arg_60_3), COLOR(0, var_60_1.r, var_60_1.g, var_60_1.b)), var_60_0:getChildByName("img_time"))
		UIAction:Add(SEQ(COLOR(0, arg_60_2.r, arg_60_2.g, arg_60_2.b), DELAY(arg_60_3), COLOR(0, var_60_1.r, var_60_1.g, var_60_1.b)), var_60_0:getChildByName("t_score"))
	end
end

function ExorcistMain.res_clear(arg_61_0, arg_61_1)
	ConditionContentsManager:updateResponseConditionList(arg_61_1)
	
	if arg_61_1.substory_id and arg_61_1.map and arg_61_1.doc_dungeon_base then
		Account:setSubstoryDungeonBaseInfo(arg_61_1.substory_id, arg_61_1.map, arg_61_1.doc_dungeon_base)
	end
end

function ExorcistMain.clear(arg_62_0, arg_62_1)
	if not arg_62_0.vars or not arg_62_0.vars.wnd or not get_cocos_refid(arg_62_0.vars.wnd) or not arg_62_1 then
		return 
	end
	
	arg_62_0:removeAllUpdate()
	
	arg_62_0.vars.result = arg_62_1
	
	local var_62_0 = arg_62_0.vars.wnd:getChildByName("n_vignetting")
	
	if var_62_0 then
		UIAction:Add(FADE_OUT(500, true), var_62_0)
	end
	
	local var_62_1 = arg_62_0.vars.wnd:getChildByName("n_time")
	
	UIAction:Add(FADE_OUT(500, true), var_62_1)
	
	local function var_62_2(arg_63_0, arg_63_1)
		local var_63_0 = arg_63_0:getChildByName("n_seal")
		local var_63_1 = var_63_0:getChildByName("n_magicsquare_effect")
		local var_63_2 = "event:/effect/" .. arg_62_0.vars.data.circle_effect[2]
		
		if SoundEngine:existsEvent(var_63_2) then
			local var_63_3 = var_63_1:getChildByName(arg_62_0.vars.data.circle_effect[2])
			
			if var_63_3 and get_cocos_refid(var_63_3) and var_63_3.sd then
				var_63_3.sd:stop()
			end
		end
		
		if arg_63_1 == 0 then
			var_63_1:removeAllChildren()
		elseif arg_63_1 == 1 then
			var_63_1 = var_63_0:getChildByName("n_seal_effect")
			
			var_63_1:setVisible(true)
			UIAction:Add(SEQ(CALL(function()
				EffectManager:Play({
					fn = arg_62_0.vars.data.circle_effect[3] .. ".cfx",
					layer = var_63_1
				})
			end), DELAY(700), CALL(function()
				if var_63_0 and get_cocos_refid(var_63_0) then
					local var_65_0 = var_63_0:getChildByName("n_slot")
					
					UIAction:Add(FADE_OUT(300, true), var_65_0)
					
					local var_65_1 = var_63_0:getChildByName("n_charm")
					
					UIAction:Add(FADE_OUT(300, true), var_65_1)
				end
			end)), arg_62_0.vars.wnd, "block")
		end
	end
	
	local function var_62_3(arg_66_0)
		local var_66_0 = arg_66_0.vars.enter_id
		local var_66_1 = arg_66_0.vars.result
		
		ConditionContentsManager:setIgnoreQuery(true)
		
		if var_66_1 == 1 then
			ConditionContentsManager:dispatch("exorcist.clear", {
				enter_id = var_66_0
			})
		end
		
		ConditionContentsManager:setIgnoreQuery(false)
		
		local var_66_2 = ConditionContentsManager:getUpdateConditions() and json.encode()
		local var_66_3 = arg_66_0.vars.substory_id
		
		query("substory_exorcist_clear", {
			map_id = var_66_0,
			result = var_66_1,
			substory_id = var_66_3,
			update_conditions = var_66_2
		})
	end
	
	UIAction:Add(SEQ(CALL(var_62_2, arg_62_0.vars.wnd, arg_62_0.vars.result), DELAY(1500), CALL(arg_62_0.setClearUI, arg_62_0, arg_62_0.vars.result), CALL(var_62_3, arg_62_0), DELAY(1600)), arg_62_0.vars.wnd, "block")
end

function ExorcistMain.setClearUI(arg_67_0, arg_67_1)
	if not arg_67_0.vars or not arg_67_0.vars.wnd or not get_cocos_refid(arg_67_0.vars.wnd) or not arg_67_1 then
		return 
	end
	
	arg_67_0.vars.font_wnd = load_dlg("story_halloween_seal_result", true, "wnd")
	
	local var_67_0 = arg_67_0.vars.font_wnd
	local var_67_1 = var_67_0:getChildByName("n_title")
	
	if var_67_1 then
		var_67_1:getChildByName("dim"):setVisible(true)
		
		local var_67_2 = var_67_1:getChildByName("n_start_success")
		
		var_67_2:getChildByName("img_start"):setVisible(false)
		
		if arg_67_1 == 0 then
			var_67_2:setVisible(false)
			var_67_1:getChildByName("n_seal_failure"):setVisible(true)
			var_0_6(var_67_1)
			SoundEngine:play("event:/effect/exorcist_2022_scene_faile")
		elseif arg_67_1 == 1 then
			var_67_2:getChildByName("img_seal_success"):setVisible(true)
			var_0_5(var_67_1, "img_seal_success")
			SoundEngine:play("event:/effect/exorcist_2022_scene_success")
		end
		
		var_67_1:getChildByName("txt_close"):setVisible(true)
		SceneManager:getRunningPopupScene():addChild(var_67_0)
		var_67_0:setOpacity(0)
		UIAction:Add(FADE_IN(200), var_67_0)
	end
end

function ExorcistMain.play_result_story(arg_68_0)
	if not arg_68_0.vars or not arg_68_0.vars.wnd or not get_cocos_refid(arg_68_0.vars.wnd) or not arg_68_0.vars.result then
		return 
	end
	
	SoundEngine:stopAllSound()
	
	if arg_68_0.vars.result == 0 then
		arg_68_0:onLeave()
	elseif arg_68_0.vars.result == 1 and arg_68_0.vars.data.success_story then
		play_story(arg_68_0.vars.data.success_story, {
			force = true,
			enter_id = arg_68_0.vars.enter_id,
			on_finish = function()
				arg_68_0:onLeave()
			end
		})
	end
end

function ExorcistMain.removeAllUpdate(arg_70_0)
	Scheduler:removeByName("exorcist_update")
end

function ExorcistMain.onLeave(arg_71_0)
	arg_71_0.vars.font_wnd:removeAllChildren()
	arg_71_0.vars.wnd:removeFromParent()
	
	arg_71_0.vars = nil
	arg_71_0.CharmFSM.charm_tbl = nil
	
	SceneManager:popScene()
end
