VolleyBallMain = {}
VolleyBallUtil = {}
VolleyBallMainManager = {}
VolleyScoreManager = {}
VolleyCutInManager = {}
VolleySoundManager = {}
TouchNodeManager = {}
TouchCircleNode = {}

copy_functions(ScrollView, VolleyBallMain)

local var_0_0 = 0
local var_0_1 = {
	-25,
	-20,
	-15,
	15,
	20,
	25
}
local var_0_2 = {
	-30,
	-25,
	-20,
	-15,
	15,
	20,
	25,
	30
}

TOUCH_TYPE_TEXT = {
	"miss",
	"good",
	"perfect"
}

function HANDLER.volleyball_battle(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "btn_setting" then
		VolleyBallEsc:open()
		
		if PAUSED then
		end
		
		if false then
		end
	elseif arg_1_1 == "btn_boss_guide" then
		VolleyBallMain:openHelpGuide()
	end
end

function VolleyBallMain.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.parent_layer = arg_2_1
	arg_2_0.vars.player_serve = true
	arg_2_0.vars.enter_id = arg_2_2.enter_id
	
	arg_2_0:initData()
	arg_2_0:initUI()
	arg_2_0:initBG()
	arg_2_0:initCharacterPos()
	arg_2_0:initManagers()
	arg_2_0:initCharacter()
	BallManager:init(arg_2_0.vars.parent_layer)
	
	local var_2_0 = 1300
	
	BattleAction:Add(SEQ(CALL(function()
		Volley_CharacterManager:showStartTalk()
	end), DELAY(var_2_0), CALL(function()
		VolleyBallMain:startGame()
	end)), arg_2_0.vars.ui_wnd, "volley_start")
end

function VolleyBallMain.initData(arg_5_0)
	arg_5_0.vars.character_datas = {}
	
	local var_5_0 = DBT("substory_volleyball_enter", arg_5_0.vars.enter_id, {
		"id",
		"config_id",
		"npc_name",
		"user_1",
		"user_2",
		"npc_1",
		"npc_2"
	})
	
	if not var_5_0 or not var_5_0.id then
		Log.e("Err: wrong map id")
		
		return 
	end
	
	for iter_5_0 = 1, 4 do
		local var_5_1
		
		if iter_5_0 < 3 then
			var_5_1 = var_5_0["user_" .. iter_5_0]
		else
			var_5_1 = var_5_0["npc_" .. iter_5_0 - 2]
		end
		
		if var_5_1 then
			local var_5_2 = DBT("substory_volleyball_character", var_5_1, {
				"id",
				"code",
				"spine",
				"face",
				"talk_start",
				"talk_serve",
				"talk_toss",
				"talk_recive",
				"talk_spike",
				"talk_special",
				"talk_hit",
				"talk_win",
				"talk_lose",
				"spike_voice",
				"special_voice"
			})
			
			if var_5_2 and var_5_2.id then
				table.insert(arg_5_0.vars.character_datas, var_5_2)
			end
		end
	end
	
	arg_5_0.vars.level_data = {}
	
	local var_5_3 = var_5_0.config_id
	local var_5_4 = DBT("substory_volleyball_config", var_5_3, {
		"id",
		"npc_node_speed",
		"node_speed",
		"gauge_atk_user",
		"gauge_def_user",
		"gauge_special_user",
		"gauge_atk_npc",
		"gauge_def_npc",
		"gauge_special_npc",
		"npc_ratio_atk",
		"npc_ratio_def",
		"npc_ratio_special",
		"score_points"
	})
	
	if var_5_4 and var_5_4.id then
		for iter_5_1, iter_5_2 in pairs(var_5_4) do
			if iter_5_1 ~= "node_speed" and string.find(iter_5_2, ",") then
				var_5_4[iter_5_1] = string.split(iter_5_2, ",")
			end
		end
		
		if not var_5_4.gauge_special_npc then
			var_5_4.gauge_special_npc = var_5_4.gauge_def_npc
		end
		
		if not var_5_4.gauge_special_user then
			var_5_4.gauge_special_user = var_5_4.gauge_def_user
		end
		
		arg_5_0.vars.level_data = var_5_4
	else
		Log.e("Err: empty data // substory_volleyball_config.db // id: ", var_5_3)
	end
end

function VolleyBallMain.getWinScore(arg_6_0)
	return arg_6_0.vars.level_data.score_points
end

function VolleyBallMain.getLevelData(arg_7_0)
	return arg_7_0.vars.level_data
end

function VolleyBallMain.getCharacterDataByIndex(arg_8_0, arg_8_1)
	return arg_8_0.vars.character_datas[arg_8_1]
end

function VolleyBallMain.initCharacterPos(arg_9_0)
	arg_9_0.vars.character_init_pos = {}
	
	for iter_9_0 = 1, 2 do
		local var_9_0
		
		if iter_9_0 == 1 then
			var_9_0 = arg_9_0.vars.ui_wnd:getChildByName("n_team")
		else
			var_9_0 = arg_9_0.vars.ui_wnd:getChildByName("n_npc")
		end
		
		for iter_9_1 = 1, 2 do
			local var_9_1 = iter_9_1
			
			if iter_9_0 == 2 then
				var_9_1 = var_9_1 + 2
			end
			
			local var_9_2 = var_9_0:getChildByName("n_" .. var_9_1)
			
			if get_cocos_refid(var_9_2) then
				local var_9_3 = var_9_2:getChildByName("n_node_pos")
				local var_9_4 = var_9_2:getWorldPosition()
				local var_9_5 = var_9_2:getChildByName("pos" .. var_9_1):getWorldPosition()
				
				table.insert(arg_9_0.vars.character_init_pos, {
					var_9_5.x,
					var_9_5.y
				})
			end
		end
	end
end

function VolleyBallMain.getCharacterPos(arg_10_0)
	return arg_10_0.vars.character_init_pos
end

function VolleyBallMain.initBG(arg_11_0)
	local var_11_0 = arg_11_0.vars.ui_wnd:getChildByName("bg")
	
	if get_cocos_refid(var_11_0) then
		var_11_0:ejectFromParent()
		arg_11_0.vars.parent_layer:addChild(var_11_0)
		var_11_0:setLocalZOrder(-9999999)
	end
end

function VolleyBallMain.initUI(arg_12_0)
	arg_12_0.vars.ui_wnd = load_dlg("volleyball_battle", true, "wnd")
	
	arg_12_0.vars.parent_layer:addChild(arg_12_0.vars.ui_wnd)
end

function VolleyBallMain.getUIWnd(arg_13_0)
	return arg_13_0.vars.ui_wnd
end

function VolleyBallMain.initCharacter(arg_14_0)
	Volley_CharacterManager.vars.characters = {}
	Volley_CharacterManager.vars.characters.allys = {}
	Volley_CharacterManager.vars.characters.enemies = {}
	
	local var_14_0 = VolleyBallMain:getCharacterPos()
	local var_14_1 = 2
	local var_14_2 = var_14_1 + 2
	
	for iter_14_0 = 1, 4 do
		local var_14_3 = {}
		local var_14_4 = Volley_Character:create(var_14_3, iter_14_0)
		local var_14_5 = var_14_4:getModel()
		local var_14_6 = {}
		
		if iter_14_0 <= 2 then
			local var_14_7 = {
				x = 160,
				y = 320
			}
			
			var_14_4:setSeverPosition(var_14_7)
		else
			local var_14_8 = {
				x = 1160,
				y = 320
			}
			
			var_14_4:setSeverPosition(var_14_8)
		end
		
		arg_14_0.vars.parent_layer:addChild(var_14_5)
		var_14_5:setPosition(var_14_0[iter_14_0][1], var_14_0[iter_14_0][2])
		var_14_4:setInitPosition(var_14_0[iter_14_0][1], var_14_0[iter_14_0][2])
		
		if iter_14_0 >= 3 then
			var_14_5:setScaleX(-var_14_5:getScaleX())
			
			var_14_4.vars.isAlly = false
			var_14_4.vars.isLeft = false
			
			table.insert(Volley_CharacterManager.vars.characters.enemies, var_14_4)
		else
			var_14_4.vars.isAlly = true
			var_14_4.vars.isLeft = true
			
			table.insert(Volley_CharacterManager.vars.characters.allys, var_14_4)
		end
		
		if VolleyBallMain:isPlayerServe() then
			if iter_14_0 == 1 then
				var_14_4:setServeCharacter(true)
			end
		elseif iter_14_0 == 3 then
			var_14_4:setServeCharacter(true)
		end
		
		if var_14_4:isUp() then
			var_14_5:setLocalZOrder(10)
		else
			var_14_5:setLocalZOrder(11)
		end
		
		var_14_4:after_work()
		var_14_4:createBalloonNode()
		
		local var_14_9 = VolleyBallMain:isPlayerServe()
		
		if var_14_9 and var_14_4.vars.isAlly and var_14_4:isServeCharacter() then
			local var_14_10, var_14_11 = var_14_4:getSeverPosition()
			
			var_14_5:setPosition(var_14_10, var_14_11)
		elseif not var_14_9 and not var_14_4.vars.isAlly and var_14_4:isServeCharacter() then
			local var_14_12, var_14_13 = var_14_4:getSeverPosition()
			
			var_14_5:setPosition(var_14_12, var_14_13)
		end
	end
	
	arg_14_0:intServeIdx()
end

function VolleyBallMain.getParentLayer(arg_15_0)
	return arg_15_0.vars.parent_layer
end

function VolleyBallMain.initManagers(arg_16_0)
	Volley_CharacterManager.vars = {}
	
	VolleyCutInManager:init()
	VolleyScoreManager:init()
	TouchNodeManager:init()
	Scheduler:removeByName("TouchNodeManager")
	Scheduler:add(VolleyBallMain.vars.parent_layer, TouchNodeManager.update_node, TouchNodeManager):setName("TouchNodeManager")
end

function VolleyBallMain.intServeIdx(arg_17_0)
	arg_17_0.vars.ally_serve_idx = 1
	arg_17_0.vars.enemy_serve_idx = 1
end

function VolleyBallMain.changeServeIdx(arg_18_0, arg_18_1)
	if arg_18_1 then
		if arg_18_0.vars.ally_serve_idx == 1 then
			arg_18_0.vars.ally_serve_idx = 2
		else
			arg_18_0.vars.ally_serve_idx = 1
		end
	elseif arg_18_0.vars.enemy_serve_idx == 1 then
		arg_18_0.vars.enemy_serve_idx = 2
	else
		arg_18_0.vars.enemy_serve_idx = 1
	end
end

function VolleyBallMain.getServeIdx(arg_19_0, arg_19_1)
	return arg_19_1 and arg_19_0.vars.ally_serve_idx or arg_19_0.vars.enemy_serve_idx
end

function VolleyBallMain.isPlayerServe(arg_20_0)
	return arg_20_0.vars.player_serve
end

function VolleyBallMain.setServePlayer(arg_21_0, arg_21_1)
	arg_21_0.vars.player_serve = arg_21_1
end

function VolleyBallMain.getNPC_touch_result(arg_22_0, arg_22_1)
	local var_22_0 = 2
	local var_22_1
	
	if arg_22_1 == "spike" then
		var_22_1 = arg_22_0.vars.level_data.npc_ratio_atk
	elseif arg_22_1 == "toss_spike" then
		var_22_1 = arg_22_0.vars.level_data.npc_ratio_def
	elseif arg_22_1 == "ult" then
		var_22_1 = arg_22_0.vars.level_data.npc_ratio_special
	end
	
	local var_22_2 = math.random(1, 100)
	
	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		if var_22_2 <= tonumber(iter_22_1) then
			var_22_0 = iter_22_0
		end
	end
	
	return var_22_0
end

function VolleyBallMain.reserve_reset_game(arg_23_0)
	arg_23_0.vars.reserve_reset_game = true
	arg_23_0.vars.reset_start_time = os.time()
	arg_23_0.vars.reset_game_delay_time = 4
end

function VolleyBallMain.update_reset_game(arg_24_0)
	if not arg_24_0.vars then
		return 
	end
	
	if arg_24_0.vars.reserve_reset_game and os.time() - arg_24_0.vars.reset_start_time >= arg_24_0.vars.reset_game_delay_time then
		arg_24_0.vars.reserve_reset_game = false
		
		arg_24_0:reset_game()
	end
end

function VolleyBallMain.startGame(arg_25_0, arg_25_1)
	if arg_25_1 then
		VolleyBallMain:start_game()
	else
		BattleAction:Remove("volley_ready_ui")
		
		local var_25_0 = arg_25_0:getUIWnd()
		local var_25_1 = var_25_0:getChildByName("n_game_info")
		local var_25_2 = var_25_1:getChildByName("n_set")
		
		var_25_1:setVisible(true)
		var_25_2:setVisible(true)
		var_25_2:removeAllChildren()
		if_set_visible(var_25_0, "n_start_bg", true)
		
		local var_25_3 = arg_25_0:getLevelData()
		local var_25_4 = string.split(var_25_3.id, "_")[2]
		
		arg_25_0.vars.n_set_img = cc.Sprite:create("img/vball_set" .. var_25_4 .. ".png")
		
		var_25_1:addChild(arg_25_0.vars.n_set_img)
		arg_25_0.vars.n_set_img:setPosition(var_25_2:getPosition())
		arg_25_0.vars.n_set_img:setAnchorPoint(0.5, 0.5)
		
		arg_25_0.vars.n_ready_img = cc.Sprite:create("img/vball_ready.png")
		
		var_25_1:addChild(arg_25_0.vars.n_ready_img)
		arg_25_0.vars.n_ready_img:setPosition(var_25_2:getPosition())
		arg_25_0.vars.n_ready_img:setAnchorPoint(0.5, 0.5)
		arg_25_0.vars.n_ready_img:setVisible(false)
		arg_25_0:startReadyBg()
		
		local var_25_5 = 1000
		
		var_25_1:setOpacity(0)
		BattleAction:Add(SEQ(OPACITY(200, 0, 1), DELAY(var_25_5), CALL(function()
			arg_25_0.vars.n_set_img:removeFromParent()
			arg_25_0.vars.n_ready_img:setVisible(true)
		end), DELAY(var_25_5), CALL(function()
			arg_25_0.vars.n_ready_img:setVisible(false)
			VolleyBallMain:stopReadyBg()
			VolleyBallMain:start_game()
		end)), var_25_1, "volley_ready_ui")
	end
end

function VolleyBallMain.startReadyBg(arg_28_0)
	local var_28_0 = arg_28_0:getUIWnd()
	local var_28_1 = var_28_0:getChildByName("n_game_info")
	local var_28_2 = var_28_1:getChildByName("n_set")
	
	var_28_1:setVisible(true)
	var_28_2:setVisible(true)
	var_28_2:removeAllChildren()
	
	if not arg_28_0.vars.bg_scroll_view then
		local var_28_3 = {}
		
		for iter_28_0 = 1, 10 do
			table.insert(var_28_3, {
				id = "test_" .. iter_28_0
			})
		end
		
		arg_28_0.vars.bg_scroll_view = var_28_0:getChildByName("start_bg_scrollview")
		
		arg_28_0.vars.bg_scroll_view:setTouchEnabled(false)
		arg_28_0.vars.bg_scroll_view:setBounceEnabled(false)
		arg_28_0:initScrollView(arg_28_0.vars.bg_scroll_view, 525, 265)
		arg_28_0:createScrollViewItems(var_28_3)
		
		if arg_28_0.vars.bg_scroll_view.setScrollBarAutoHideEnabled then
			arg_28_0.vars.bg_scroll_view:setScrollBarAutoHideEnabled(false)
		end
	else
		arg_28_0.vars.bg_scroll_view:setVisible(true)
	end
	
	arg_28_0.vars.start_bg_scroll_per = 0
	arg_28_0.vars.ready_scroll_on = true
end

function VolleyBallMain.stopReadyBg(arg_29_0)
	arg_29_0.vars.bg_scroll_view:jumpToPercentHorizontal(0)
	
	arg_29_0.vars.ready_scroll_on = false
	arg_29_0.vars.start_bg_scroll_per = 0
	
	arg_29_0.vars.bg_scroll_view:setVisible(false)
end

function VolleyBallMain.getScrollViewItem(arg_30_0, arg_30_1)
	return (cc.Sprite:create("img/vball_fx.png"))
end

function VolleyBallMain.update_ready_scroll(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.ui_wnd) or not arg_31_0.vars.bg_scroll_view or not arg_31_0.vars.ready_scroll_on or PAUSED then
		return 
	end
	
	arg_31_0.vars.start_bg_scroll_per = arg_31_0.vars.start_bg_scroll_per + 0.05
	
	if arg_31_0.vars.start_bg_scroll_per >= 99 then
		arg_31_0.vars.start_bg_scroll_per = 0
	end
	
	arg_31_0.vars.bg_scroll_view:jumpToPercentHorizontal(arg_31_0.vars.start_bg_scroll_per)
end

function VolleyBallMain.setPlayerUseUlt(arg_32_0, arg_32_1)
	arg_32_0.vars.player_ult = arg_32_1
end

function VolleyBallMain.getPlayerUseUlt(arg_33_0)
	return arg_33_0.vars.player_ult
end

function VolleyBallMain.reset_game(arg_34_0)
	BallManager:reset()
	VolleyScoreManager:reset()
	TouchNodeManager:reset()
	VolleyCutInManager:reset()
	Volley_CharacterManager:reset()
	VolleyBallMain:setPlayerUseUlt(false)
	BallManager:setVisibleBall(false)
end

function MsgHandler.volley_clear(arg_35_0)
	if arg_35_0.is_user_win and tolua.type(arg_35_0.is_user_win) == "string" then
		arg_35_0.is_user_win = arg_35_0.is_user_win == "true"
	end
	
	if arg_35_0.map and arg_35_0.doc_dungeon_base then
		Account:setDungeonBaseInfo(arg_35_0.map, arg_35_0.doc_dungeon_base)
	end
	
	if arg_35_0.rewards then
		arg_35_0.result_rewards = Account:addReward(arg_35_0.rewards, {
			enter = arg_35_0.map
		})
	end
	
	local var_35_0 = ConditionContentsManager:updateResponseConditionList(arg_35_0)
	
	VolleyBallResult:show(arg_35_0)
end

function VolleyBallMain.clear_game(arg_36_0, arg_36_1)
	local var_36_0 = (arg_36_1 or {}).is_user_win or false
	local var_36_1 = SubstoryManager:getInfoID()
	
	ConditionContentsManager:setIgnoreQuery(true)
	
	if var_36_0 then
		ConditionContentsManager:dispatch("volley.clear", {
			enter_id = arg_36_0.vars.enter_id
		})
	end
	
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_36_2 = ConditionContentsManager:getUpdateConditions() and json.encode()
	
	query("volley_clear", {
		map_id = arg_36_0.vars.enter_id,
		is_user_win = var_36_0,
		substory_id = var_36_1,
		update_conditions = var_36_2
	})
end

function VolleyBallMain.start_game(arg_37_0)
	VolleySoundManager:play("ui/Summer_beginning")
	BallManager:reset_delay_time()
	
	local var_37_0 = arg_37_0:isPlayerServe()
	local var_37_1 = VolleyScoreManager:isMaxGauge(true)
	local var_37_2 = VolleyScoreManager:isMaxGauge(false)
	local var_37_3 = arg_37_0:getServeIdx(var_37_0)
	local var_37_4 = 2
	local var_37_5 = 1
	
	if var_37_3 == 1 then
		var_37_4 = 2
		var_37_5 = 1
	elseif var_37_3 == 2 then
		var_37_4 = 1
		var_37_5 = 2
	end
	
	local var_37_6
	
	if var_37_0 then
		var_37_6 = {
			"start/true/" .. var_37_3,
			"toss_to_start/false/" .. var_37_4,
			"toss/false/" .. var_37_5
		}
		
		if var_37_2 then
			local var_37_7 = VolleyBallMain:getNPC_touch_result("ult")
			
			table.insert(var_37_6, "toss_to_spike_ult/false/" .. var_37_4)
			
			if var_37_7 == 1 then
				table.insert(var_37_6, "spike_out/true/" .. var_37_5 .. "/" .. var_37_7)
			else
				table.insert(var_37_6, "spike_ult/true/" .. var_37_5 .. "/" .. var_37_7)
			end
			
			VolleyBallMain:setPlayerUseUlt(false)
		else
			local var_37_8 = VolleyBallMain:getNPC_touch_result("spike")
			
			table.insert(var_37_6, "toss_to_spike/false/" .. var_37_4)
			
			if var_37_8 == 1 then
				table.insert(var_37_6, "spike_out/true/" .. var_37_5 .. "/" .. var_37_8)
			else
				table.insert(var_37_6, "spike/true/" .. var_37_5 .. "/" .. var_37_8)
			end
		end
	else
		var_37_6 = {
			"start/false/" .. var_37_3,
			"toss_to_start/true/" .. var_37_4,
			"toss/true/" .. var_37_5
		}
		
		if var_37_1 then
			table.insert(var_37_6, "toss_to_spike_ult/true/" .. var_37_4)
			VolleyBallMain:setPlayerUseUlt(true)
		else
			table.insert(var_37_6, "toss_to_spike/true/" .. var_37_4)
		end
	end
	
	BallManager:setNextCommend(var_37_6)
end

function TouchCircleNode.create(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = VolleyBallMain:getLevelData()
	
	arg_38_1.vars = {}
	arg_38_1.vars.type = arg_38_2
	arg_38_1.vars.touched = false
	arg_38_1.vars.spawn_time = LAST_TICK
	arg_38_1.vars.real_spawn_time = LAST_TICK
	arg_38_1.vars.speed = var_38_0.node_speed
	
	if arg_38_3 then
		arg_38_1.vars.speed = var_38_0.npc_node_speed or var_38_0.node_speed
	end
	
	arg_38_1.vars.scale_minus = 0.15
	arg_38_1.vars.minus_scale = round(1 / (arg_38_1.vars.speed / 100), 2) / 2
	arg_38_1.vars.wnd = load_dlg("volleyball_battle_node", true, "wnd")
	arg_38_1.vars.n_guide = arg_38_1.vars.wnd:getChildByName("n_guide")
	arg_38_1.vars.n_good = arg_38_1.vars.wnd:getChildByName("n_good")
	arg_38_1.vars.n_perfect = arg_38_1.vars.wnd:getChildByName("n_perfect")
	
	copy_functions(TouchCircleNode, arg_38_1)
	BattleAction:Add(LOOP(ROTATE(8000, 0, -360), 100), arg_38_1.vars.n_guide, "touch_node_rotate")
	
	return arg_38_1
end

function TouchCircleNode.getWnd(arg_39_0)
	return arg_39_0.vars.wnd
end

function TouchCircleNode.get_n_guide(arg_40_0)
	return arg_40_0.vars.n_guide
end

function TouchCircleNode.getType(arg_41_0)
	return arg_41_0.vars.type
end

function TouchCircleNode.set_touched(arg_42_0, arg_42_1)
	if not arg_42_0.vars then
		return 
	end
	
	arg_42_0.vars.touched = arg_42_1
end

function TouchCircleNode.getResult(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	local var_43_0
	local var_43_1 = arg_43_0.vars.n_good:getContentSize()
	local var_43_2 = math.floor(var_43_1.width * arg_43_0.vars.n_good:getScaleX())
	local var_43_3 = math.floor(var_43_1.height * arg_43_0.vars.n_good:getScaleY())
	local var_43_4 = arg_43_0.vars.n_perfect:getContentSize()
	local var_43_5 = math.floor(var_43_4.width * arg_43_0.vars.n_perfect:getScaleX())
	local var_43_6 = math.floor(var_43_4.height * arg_43_0.vars.n_perfect:getScaleY())
	local var_43_7 = arg_43_0.vars.n_guide:getContentSize()
	local var_43_8 = math.floor(var_43_7.width * arg_43_0.vars.n_guide:getScale())
	local var_43_9 = math.floor(var_43_7.height * arg_43_0.vars.n_guide:getScale())
	
	if var_43_8 ~= var_43_9 then
		var_43_8 = math.min(var_43_8, var_43_9)
		var_43_9 = math.min(var_43_8, var_43_9)
	end
	
	local var_43_10 = 5
	local var_43_11 = 3
	
	if var_43_2 < var_43_8 - var_43_10 and var_43_3 < var_43_9 - var_43_10 then
		var_43_0 = TOUCH_TYPE_TEXT[1]
	elseif var_43_8 <= var_43_5 - var_43_11 and var_43_9 <= var_43_6 - var_43_11 then
		var_43_0 = TOUCH_TYPE_TEXT[3]
	elseif var_43_8 <= var_43_2 + var_43_10 and var_43_9 <= var_43_3 + var_43_10 then
		var_43_0 = TOUCH_TYPE_TEXT[2]
	end
	
	return var_43_0
end

local var_0_3 = 0

function TouchCircleNode.update(arg_44_0)
	if not arg_44_0.vars or PAUSED then
		return 
	end
	
	local var_44_0 = arg_44_0.vars.n_guide:getScale()
	
	if not arg_44_0.vars.fake_scale then
		arg_44_0.vars.fake_scale = var_44_0
	end
	
	local var_44_1 = arg_44_0.vars.fake_scale
	local var_44_2 = -0.1
	local var_44_3 = false
	local var_44_4
	
	if var_44_1 <= var_44_2 then
		var_44_3 = true
		var_44_4 = TOUCH_TYPE_TEXT[1]
	elseif arg_44_0.vars.touched then
		var_44_4 = arg_44_0:getResult()
		var_44_3 = true
	end
	
	if var_44_3 then
		if DEBUG.VOLLEY_AUTO_MODE then
			print("touch node remove total count: ", var_0_3, LAST_TICK - arg_44_0.vars.real_spawn_time)
			
			var_0_3 = 0
			
			return true, "perfect"
		end
		
		return true, var_44_4
	end
	
	if LAST_TICK - arg_44_0.vars.spawn_time >= 10 then
		local var_44_5 = var_44_0 - arg_44_0.vars.minus_scale
		local var_44_6 = var_44_1 - arg_44_0.vars.minus_scale
		
		arg_44_0.vars.fake_scale = math.max(var_44_6, var_44_2)
		
		local var_44_7 = math.max(0, var_44_5)
		
		arg_44_0.vars.n_guide:setScale(var_44_7)
		
		arg_44_0.vars.spawn_time = LAST_TICK
		var_0_3 = var_0_3 + 1
	end
end

function TouchCircleNode.remove(arg_45_0)
	arg_45_0.vars.wnd:removeFromParent()
	
	arg_45_0.vars = nil
end

function TouchNodeManager.init(arg_46_0)
	TouchNodeManager.vars = {}
	
	arg_46_0:createTouchButton()
end

function TouchNodeManager.reset(arg_47_0)
	if arg_47_0.vars.touch_node then
		arg_47_0.vars.touch_node:removeFromParent()
		
		arg_47_0.vars.touch_node = nil
	end
end

function TouchNodeManager.set_touched(arg_48_0, arg_48_1)
	if not arg_48_0.vars or not arg_48_0.vars.touch_node then
		return 
	end
	
	arg_48_0.vars.touch_node:set_touched(arg_48_1)
end

function TouchNodeManager.createTouchNode(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	if not arg_49_2 then
		return Log.e("Err: no touch node type")
	end
	
	local var_49_0 = arg_49_1 or arg_49_0:getTarget()
	
	if not var_49_0 then
		Log.e("타겟이없다?")
		
		return 
	end
	
	local var_49_1 = (arg_49_3 or {}).recieve_enemy_ult or false
	local var_49_2 = {}
	local var_49_3 = var_49_0:getModel()
	local var_49_4 = VolleyBallMain:getParentLayer()
	local var_49_5 = 0
	
	arg_49_0.vars.touch_node = TouchCircleNode:create(var_49_2, arg_49_2, var_49_1)
	
	if var_49_3 then
		var_49_4:addChild(arg_49_0.vars.touch_node.vars.wnd)
	end
	
	if arg_49_2 == "receive" then
		var_49_5 = 50
	elseif arg_49_2 == "spike" then
		var_49_5 = 180
	end
	
	if arg_49_0.vars.touch_node then
		local var_49_6 = arg_49_0.vars.touch_node:getWnd()
		
		if get_cocos_refid(var_49_6) then
			var_49_6:setAnchorPoint(0.5, 0.5)
			var_49_6:setPosition(var_49_3:getPositionX(), var_49_3:getPositionY() + var_49_5)
		end
	end
end

function TouchNodeManager.createTouchButton(arg_50_0)
	local var_50_0 = VolleyBallMain:getParentLayer():getChildByName("btn_touch_ball")
	
	if not get_cocos_refid(var_50_0) then
		local var_50_1 = ccui.Button:create()
		
		var_50_1:setTouchEnabled(true)
		var_50_1:ignoreContentAdaptWithSize(false)
		var_50_1:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
		var_50_1:addTouchEventListener(function(arg_51_0, arg_51_1)
			if arg_51_1 == 2 then
				TouchNodeManager:set_touched(true)
				
				return 
			end
		end)
		var_50_1:setName("btn_touch_ball")
		VolleyBallMain:getParentLayer():addChild(var_50_1)
		var_50_1:setPosition(0, 0)
		var_50_1:setAnchorPoint(0, 0)
		var_50_1:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	end
end

function TouchNodeManager.update_node(arg_52_0)
	if not arg_52_0.vars or not arg_52_0.vars.touch_node or not arg_52_0.vars.touch_node:getWnd() or not get_cocos_refid(arg_52_0.vars.touch_node:getWnd()) or PAUSED then
		return 
	end
	
	local var_52_0, var_52_1 = arg_52_0.vars.touch_node:update()
	
	if var_52_0 then
		BattleAction:Remove("touch_node_rotate")
		
		local var_52_2 = arg_52_0.vars.touch_node:getType()
		local var_52_3 = BallManager:getOwner()
		local var_52_4 = 1
		
		if var_52_1 == "good" then
			var_52_4 = 2
		elseif var_52_1 == "perfect" then
			var_52_4 = 3
		end
		
		VolleyScoreManager:addGauge(true, var_52_4, {
			is_defense = var_52_2 == "receive"
		})
		arg_52_0.vars.touch_node:remove()
		
		arg_52_0.vars.touch_node = nil
		
		if var_52_1 ~= "miss" then
			VolleySoundManager:play("ui/summer_note")
			
			local var_52_5 = VolleyScoreManager:isMaxGauge(true)
			
			if var_52_2 == "receive" then
				local var_52_6 = var_52_3:getIdx()
				local var_52_7 = 1
				
				if var_52_6 == 1 then
					var_52_7 = 2
				end
				
				local var_52_8 = {
					"toss_spike/true/" .. var_52_7,
					"toss_to_spike/true/" .. var_52_6
				}
				
				if var_52_5 then
					var_52_8 = {
						"toss_spike/true/" .. var_52_7,
						"toss_to_spike_ult/true/" .. var_52_6
					}
					
					VolleyBallMain:setPlayerUseUlt(true)
				end
				
				BallManager:setNextCommend(var_52_8)
			elseif var_52_2 == "spike" then
				local var_52_9 = {}
				local var_52_10 = var_52_3:getIdx()
				local var_52_11 = 1
				local var_52_12 = 2
				
				if var_52_10 == 1 then
					var_52_11 = 2
					var_52_12 = 1
				end
				
				if VolleyBallMain:getPlayerUseUlt() then
					table.insert(var_52_9, "spike_ult/false/" .. var_52_11)
					table.insert(var_52_9, "out/false/" .. var_52_11)
					VolleyBallMain:setPlayerUseUlt(false)
				else
					table.insert(var_52_9, "spike/false/" .. var_52_11)
					
					local var_52_13 = VolleyBallMain:getNPC_touch_result("toss_spike")
					
					if var_52_13 == 1 then
						table.insert(var_52_9, "receive_out/false/" .. var_52_12 .. "/" .. 1)
					else
						table.insert(var_52_9, "toss_spike/false/" .. var_52_12 .. "/" .. var_52_13)
						
						if VolleyScoreManager:isEnemyMaxGaugeExpect("toss_spike", var_52_13) then
							local var_52_14 = VolleyBallMain:getNPC_touch_result("ult")
							
							table.insert(var_52_9, "toss_to_spike_ult/false/" .. var_52_11)
							
							if var_52_14 == 1 then
								table.insert(var_52_9, "spike_out/true/" .. var_52_12 .. "/" .. var_52_14)
							else
								table.insert(var_52_9, "spike_ult/true/" .. var_52_12 .. "/" .. var_52_14)
							end
						else
							local var_52_15 = VolleyBallMain:getNPC_touch_result("spike")
							
							table.insert(var_52_9, "toss_to_spike/false/" .. var_52_11)
							
							if var_52_15 == 1 then
								table.insert(var_52_9, "spike_out/true/" .. var_52_12 .. "/" .. var_52_15)
							else
								table.insert(var_52_9, "spike/true/" .. var_52_12 .. "/" .. var_52_15)
							end
						end
					end
				end
				
				BallManager:setNextCommend(var_52_9)
			end
			
			var_0_0 = var_0_0 + 1
		else
			local var_52_16 = BallManager:getOwner():getIdx()
			local var_52_17 = 1
			
			if var_52_16 == 1 then
				var_52_17 = 2
			end
			
			if var_52_2 == "receive" then
				local var_52_18 = {
					"receive_out/true/2"
				}
				
				BallManager:setNextCommend(var_52_18)
			elseif var_52_2 == "spike" then
				local var_52_19 = {
					"spike_out/false/" .. var_52_17
				}
				
				BallManager:setNextCommend(var_52_19)
			end
		end
		
		local var_52_20 = 1
		
		if var_52_1 == TOUCH_TYPE_TEXT[2] then
			var_52_20 = 2
		elseif var_52_1 == TOUCH_TYPE_TEXT[3] then
			var_52_20 = 3
		end
		
		VolleyScoreManager:addTypeText(var_52_3:getModel():getPositionX(), var_52_3:getModel():getPositionY(), var_52_20)
	end
end

function TouchNodeManager.setTarget(arg_53_0, arg_53_1)
	arg_53_0.vars.target = arg_53_1
end

function TouchNodeManager.getTarget(arg_54_0)
	return arg_54_0.vars.target
end

function VolleyCutInManager.init(arg_55_0)
	arg_55_0.vars = {}
	arg_55_0.vars.cut_in_speed = 700
	arg_55_0.vars.cut_in_power = 300
	arg_55_0.vars.cut_in_time = 300
	arg_55_0.vars.parent_layer = VolleyBallMain:getParentLayer()
	arg_55_0.vars.cur_data = nil
	arg_55_0.vars.user_data = {}
	arg_55_0.vars.user_data.wnd = VolleyBallMain:getUIWnd():getChildByName("n_cutin_out")
	arg_55_0.vars.user_data.n_deco = arg_55_0.vars.user_data.wnd:getChildByName("n_deco")
	arg_55_0.vars.user_data.n_hero = arg_55_0.vars.user_data.wnd:getChildByName("n_hero")
	arg_55_0.vars.user_data.cutIn_in_node = VolleyBallMain:getUIWnd():getChildByName("n_cutin_in")
	arg_55_0.vars.user_data.begin_pos_x, arg_55_0.vars.user_data.begin_pos_y = arg_55_0.vars.user_data.wnd:getPosition()
	arg_55_0.vars.user_data.target_pos_x, arg_55_0.vars.user_data.target_pos_y = arg_55_0.vars.user_data.cutIn_in_node:getPosition()
	arg_55_0.vars.npc_data = {}
	arg_55_0.vars.npc_data.wnd = VolleyBallMain:getUIWnd():getChildByName("n_cutin_out_npc")
	arg_55_0.vars.npc_data.n_deco = arg_55_0.vars.npc_data.wnd:getChildByName("n_deco")
	arg_55_0.vars.npc_data.n_hero = arg_55_0.vars.npc_data.wnd:getChildByName("n_hero")
	arg_55_0.vars.npc_data.cutIn_in_node = VolleyBallMain:getUIWnd():getChildByName("n_cutin_in_npc")
	arg_55_0.vars.npc_data.begin_pos_x, arg_55_0.vars.npc_data.begin_pos_y = arg_55_0.vars.npc_data.wnd:getPosition()
	arg_55_0.vars.npc_data.target_pos_x, arg_55_0.vars.npc_data.target_pos_y = arg_55_0.vars.npc_data.cutIn_in_node:getPosition()
end

function VolleyCutInManager.getCutInTime(arg_56_0)
	return 1000
end

function VolleyCutInManager.showCutIn(arg_57_0, arg_57_1, arg_57_2)
	if not arg_57_0.vars then
		return 
	end
	
	local var_57_0 = arg_57_1.face or "volleyball_2021_lucy"
	local var_57_1 = cc.Sprite:create("face/" .. var_57_0 .. ".png")
	
	if not var_57_1 then
		var_57_1 = cc.Sprite:create("face/volleyball_2021_lucy.png")
		
		if not var_57_1 then
			Log.e("Err: no cutin face img")
			
			return 
		end
	end
	
	arg_57_0.vars.is_ally = arg_57_2
	
	if arg_57_2 then
		arg_57_0.vars.cur_data = arg_57_0.vars.user_data
	else
		arg_57_0.vars.cur_data = arg_57_0.vars.npc_data
	end
	
	arg_57_0.vars.cur_data.n_hero:removeAllChildren()
	arg_57_0.vars.cur_data.n_hero:addChild(var_57_1)
	var_57_1:setAnchorPoint(0.5, 0)
	arg_57_0.vars.cur_data.wnd:setPositionX(arg_57_0.vars.cur_data.target_pos_x)
	arg_57_0.vars.cur_data.wnd:setPositionY(arg_57_0.vars.cur_data.target_pos_y)
	arg_57_0.vars.cur_data.wnd:setVisible(false)
	
	local var_57_2 = arg_57_1.talk_special or ""
	
	if_set(arg_57_0.vars.cur_data.wnd, "txt_speech", T(var_57_2))
	arg_57_0:startRollingAnimation()
	
	if arg_57_2 then
		BattleAction:Add(SEQ(SHOW(true), SLIDE_IN(arg_57_0.vars.cut_in_speed, arg_57_0.vars.cut_in_power, true), DELAY(arg_57_0.vars.cut_in_time), SLIDE_OUT(arg_57_0.vars.cut_in_speed, -arg_57_0.vars.cut_in_power, true), CALL(function()
			VolleyCutInManager:stopRollingAnimation()
		end)), arg_57_0.vars.cur_data.wnd, "block")
	else
		BattleAction:Add(SEQ(SHOW(true), SLIDE_IN(arg_57_0.vars.cut_in_speed, -arg_57_0.vars.cut_in_power, true), DELAY(arg_57_0.vars.cut_in_time), SLIDE_OUT(arg_57_0.vars.cut_in_speed, arg_57_0.vars.cut_in_power, true), CALL(function()
			VolleyCutInManager:stopRollingAnimation()
		end)), arg_57_0.vars.cur_data.wnd, "block")
	end
	
	arg_57_0.vars.use_ult = true
end

function VolleyCutInManager.startRollingAnimation(arg_60_0)
	if not arg_60_0.vars or not arg_60_0.vars.cur_data or not get_cocos_refid(arg_60_0.vars.cur_data.n_deco) then
		return 
	end
	
	local var_60_0 = arg_60_0.vars.is_ally and -360 or 360
	
	BattleAction:Add(LOOP(ROTATE(4000, 0, var_60_0), 100), arg_60_0.vars.cur_data.n_deco, "cutin_deco_rolling")
end

function VolleyCutInManager.stopRollingAnimation(arg_61_0)
	BattleAction:Remove("cutin_deco_rolling")
end

function VolleyCutInManager.reset(arg_62_0)
	arg_62_0:resetUseUlt()
end

function VolleyCutInManager.isUseUlt(arg_63_0)
	return arg_63_0.vars.use_ult
end

function VolleyCutInManager.resetUseUlt(arg_64_0)
	arg_64_0.vars.use_ult = nil
end

function VolleyScoreManager.init(arg_65_0)
	local var_65_0 = VolleyBallMain:getLevelData()
	
	arg_65_0.vars = {}
	arg_65_0.vars.gauge_atk_user = var_65_0.gauge_atk_user
	arg_65_0.vars.gauge_def_user = var_65_0.gauge_def_user
	arg_65_0.vars.gauge_special_user = var_65_0.gauge_special_user
	arg_65_0.vars.gauge_atk_npc = var_65_0.gauge_atk_npc
	arg_65_0.vars.gauge_def_npc = var_65_0.gauge_def_npc
	arg_65_0.vars.gauge_special_npc = var_65_0.gauge_special_npc
	arg_65_0.vars.ally_max_gauge = 100
	arg_65_0.vars.enemy_max_gauge = 100
	arg_65_0.vars.ally_score = 0
	arg_65_0.vars.enemy_score = 0
	arg_65_0.vars.win_score = VolleyBallMain:getWinScore() or 3
	arg_65_0.vars.ally_gauge = 0
	arg_65_0.vars.enemy_gauge = 0
	
	arg_65_0:initUI()
	arg_65_0:updateUI()
end

function VolleyScoreManager.reset(arg_66_0)
	arg_66_0:resetRound()
	arg_66_0:checkUltEffect()
end

function VolleyScoreManager.checkUltEffect(arg_67_0)
	local var_67_0 = arg_67_0:isMaxGauge(true)
	local var_67_1 = arg_67_0:isMaxGauge(false)
	
	if not var_67_0 then
		arg_67_0:endAllyEffect()
	end
	
	if not var_67_1 then
		arg_67_0:endEnemyEffect()
	end
end

function VolleyScoreManager.resetRound(arg_68_0)
	if arg_68_0.vars.ally_score >= arg_68_0.vars.win_score or arg_68_0.vars.enemy_score >= arg_68_0.vars.win_score then
		arg_68_0.vars.ally_score = 0
		arg_68_0.vars.enemy_score = 0
	end
end

function VolleyScoreManager.isEndGame(arg_69_0)
	local var_69_0
	local var_69_1
	
	if arg_69_0.vars.ally_score >= arg_69_0.vars.win_score or arg_69_0.vars.enemy_score >= arg_69_0.vars.win_score then
		var_69_0 = true
		var_69_1 = arg_69_0.vars.ally_score >= arg_69_0.vars.win_score
	end
	
	return var_69_0, var_69_1
end

function VolleyScoreManager.initUI(arg_70_0)
	local var_70_0 = VolleyBallMain:getParentLayer()
	local var_70_1 = VolleyBallMain:getUIWnd()
	local var_70_2 = var_70_1:getChildByName("n_scoreboard")
	local var_70_3 = var_70_1:getChildByName("n_gauge")
	
	if get_cocos_refid(var_70_2) then
		arg_70_0.vars.n_ally_score = var_70_2:getChildByName("txt_team")
		arg_70_0.vars.n_enemy_score = var_70_2:getChildByName("txt_npc")
	end
	
	if get_cocos_refid(var_70_3) then
		arg_70_0.vars.n_ally_gauge = var_70_3:getChildByName("n_team")
		arg_70_0.vars.n_enemy_gauge = var_70_3:getChildByName("n_npc")
	end
	
	if_set_percent(arg_70_0.vars.n_ally_gauge, "progress_bar", 0)
	if_set_percent(arg_70_0.vars.n_enemy_gauge, "progress_bar", 0)
	if_set_visible(var_70_1, "n_result", true)
	
	arg_70_0.vars.win_ui = var_70_1:getChildByName("n_win")
	arg_70_0.vars.lose_ui = var_70_1:getChildByName("n_lose")
	
	arg_70_0.vars.win_ui:setVisible(false)
	arg_70_0.vars.lose_ui:setVisible(false)
end

function VolleyScoreManager.updateUI(arg_71_0)
	if not arg_71_0.vars then
		return 
	end
	
	if_set(arg_71_0.vars.n_ally_score, nil, arg_71_0.vars.ally_score)
	if_set(arg_71_0.vars.n_enemy_score, nil, arg_71_0.vars.enemy_score)
	
	local var_71_0 = arg_71_0.vars.n_ally_gauge:getChildByName("progress_bar")
	local var_71_1 = arg_71_0.vars.n_enemy_gauge:getChildByName("progress_bar")
	local var_71_2 = 100
	local var_71_3 = math.min(arg_71_0.vars.ally_gauge / arg_71_0.vars.ally_max_gauge, var_71_2)
	local var_71_4 = math.min(arg_71_0.vars.enemy_gauge / arg_71_0.vars.enemy_max_gauge, var_71_2)
	local var_71_5 = var_71_0:getPercent() / 100
	local var_71_6 = var_71_1:getPercent() / 100
	local var_71_7 = 0.03
	
	if var_71_5 < var_71_3 then
		if_set_percent(arg_71_0.vars.n_ally_gauge, "progress_bar", var_71_5 + var_71_7)
	elseif var_71_3 <= 0 then
		if_set_percent(arg_71_0.vars.n_ally_gauge, "progress_bar", var_71_5 - var_71_7 * 4)
	end
	
	if var_71_6 < var_71_4 then
		if_set_percent(arg_71_0.vars.n_enemy_gauge, "progress_bar", var_71_6 + var_71_7)
	elseif var_71_4 <= 0 and var_71_6 > 0 then
		if_set_percent(arg_71_0.vars.n_enemy_gauge, "progress_bar", var_71_6 - var_71_7 * 4)
	end
end

function VolleyScoreManager.updateEffect(arg_72_0)
	local var_72_0 = arg_72_0:isMaxGauge(true)
	local var_72_1 = arg_72_0:isMaxGauge(false)
	
	if var_72_0 then
		arg_72_0:startAllyEffect()
	end
	
	if var_72_1 then
		arg_72_0:startEnemyEffect()
	end
end

function VolleyScoreManager.startAllyEffect(arg_73_0)
	if get_cocos_refid(arg_73_0.vars.ally_eff_start) or get_cocos_refid(arg_73_0.vars.ally_eff_loop) then
		return 
	end
	
	VolleySoundManager:play("ui/summer_gauge_max")
	
	local var_73_0 = arg_73_0.vars.n_ally_gauge:getChildByName("progress_bar")
	
	arg_73_0.vars.ally_eff_start = CACHE:getEffect("ui_volleyball_max_start.cfx")
	arg_73_0.vars.ally_eff_loop = CACHE:getEffect("ui_volleyball_max_loop.cfx")
	arg_73_0.vars.ally_eff_end = CACHE:getEffect("ui_volleyball_max_end.cfx")
	
	arg_73_0.vars.ally_eff_start:setScaleX(-math.abs(arg_73_0.vars.ally_eff_start:getScaleX()))
	arg_73_0.vars.ally_eff_loop:setScaleX(-math.abs(arg_73_0.vars.ally_eff_loop:getScaleX()))
	arg_73_0.vars.ally_eff_end:setScaleX(-math.abs(arg_73_0.vars.ally_eff_end:getScaleX()))
	arg_73_0.vars.ally_eff_loop:setAnchorPoint(0, 0)
	var_73_0:addChild(arg_73_0.vars.ally_eff_start)
	var_73_0:addChild(arg_73_0.vars.ally_eff_loop)
	var_73_0:addChild(arg_73_0.vars.ally_eff_end)
	arg_73_0.vars.ally_eff_start:setPosition(390, 15)
	arg_73_0.vars.ally_eff_loop:setPosition(390, 15)
	arg_73_0.vars.ally_eff_end:setPosition(390, 15)
	
	local var_73_1 = arg_73_0.vars.ally_eff_start:getDuration() * 1000 / 4
	
	BattleAction:Add(SEQ(CALL(function()
		arg_73_0.vars.ally_eff_start:start()
	end), DELAY(var_73_1), CALL(function()
		arg_73_0.vars.ally_eff_loop:start()
	end)), arg_73_0.vars.n_ally_gauge, "ally_gauge_eff")
end

function VolleyScoreManager.endAllyEffect(arg_76_0)
	if get_cocos_refid(arg_76_0.vars.ally_eff_loop) then
		arg_76_0.vars.ally_eff_loop:stop()
	end
	
	if get_cocos_refid(arg_76_0.vars.ally_eff_end) then
		arg_76_0.vars.ally_eff_end:start()
	end
end

function VolleyScoreManager.startEnemyEffect(arg_77_0)
	if get_cocos_refid(arg_77_0.vars.enemy_eff_start) or get_cocos_refid(arg_77_0.vars.enemy_eff_loop) then
		return 
	end
	
	VolleySoundManager:play("ui/summer_gauge_max")
	
	local var_77_0 = arg_77_0.vars.n_enemy_gauge:getChildByName("progress_bar")
	
	arg_77_0.vars.enemy_eff_start = CACHE:getEffect("ui_volleyball_max_start.cfx")
	arg_77_0.vars.enemy_eff_loop = CACHE:getEffect("ui_volleyball_max_loop.cfx")
	arg_77_0.vars.enemy_eff_end = CACHE:getEffect("ui_volleyball_max_end.cfx")
	
	var_77_0:addChild(arg_77_0.vars.enemy_eff_start)
	var_77_0:addChild(arg_77_0.vars.enemy_eff_loop)
	var_77_0:addChild(arg_77_0.vars.enemy_eff_end)
	arg_77_0.vars.enemy_eff_start:setPosition(-10, 15)
	arg_77_0.vars.enemy_eff_loop:setPosition(-10, 15)
	arg_77_0.vars.enemy_eff_end:setPosition(-10, 15)
	
	local var_77_1 = arg_77_0.vars.enemy_eff_start:getDuration() * 1000 / 4
	
	BattleAction:Add(SEQ(CALL(function()
		arg_77_0.vars.enemy_eff_start:start()
	end), DELAY(var_77_1), CALL(function()
		arg_77_0.vars.enemy_eff_loop:start()
	end)), arg_77_0.vars.n_enemy_gauge, "enemy_gauge_eff")
end

function VolleyScoreManager.endEnemyEffect(arg_80_0)
	if get_cocos_refid(arg_80_0.vars.enemy_eff_loop) then
		arg_80_0.vars.enemy_eff_loop:stop()
	end
	
	if get_cocos_refid(arg_80_0.vars.enemy_eff_end) then
		arg_80_0.vars.enemy_eff_end:start()
	end
end

function VolleyScoreManager.addScore(arg_81_0, arg_81_1)
	if arg_81_1 then
		arg_81_0.vars.ally_score = arg_81_0.vars.ally_score + 1
	else
		arg_81_0.vars.enemy_score = arg_81_0.vars.enemy_score + 1
	end
	
	VolleyBallMain:changeServeIdx(VolleyBallMain:isPlayerServe())
	VolleyBallMain:setServePlayer(arg_81_1)
	Volley_CharacterManager:updateServeCharacter()
	arg_81_0:showRoundResult(arg_81_1)
end

function VolleyScoreManager.showRoundResult(arg_82_0, arg_82_1)
	local var_82_0 = 2500
	local var_82_1 = 800
	local var_82_2 = 800
	
	arg_82_0.vars.win_ui:setVisible(false)
	arg_82_0.vars.lose_ui:setVisible(false)
	
	local var_82_3 = arg_82_0.vars.lose_ui
	
	if arg_82_1 then
		var_82_3 = arg_82_0.vars.win_ui
	end
	
	local var_82_4, var_82_5 = VolleyScoreManager:isEndGame()
	
	if var_82_4 then
		BattleAction:Add(SEQ(DELAY(var_82_1), CALL(function()
			VolleySoundManager:play("ui/Summer_beginning_alt2")
		end), DELAY(var_82_2), SHOW(true), CALL(function()
			if arg_82_1 then
				VolleySoundManager:play("ui/Summer_goal")
			else
				VolleySoundManager:play("ui/Summer_failure")
			end
		end), DELAY(var_82_0), SHOW(false), DELAY(500), CALL(function()
			VolleyBallMain:clear_game({
				is_user_win = var_82_5
			})
		end)), var_82_3, "round_result")
	else
		BattleAction:Add(SEQ(DELAY(var_82_1), CALL(function()
			VolleySoundManager:play("ui/Summer_beginning_alt2")
		end), DELAY(var_82_2), SHOW(true), CALL(function()
			if arg_82_1 then
				VolleySoundManager:play("ui/Summer_goal")
			else
				VolleySoundManager:play("ui/Summer_failure")
			end
		end), DELAY(var_82_0), SHOW(false), DELAY(1300), CALL(function()
			VolleyBallMain:startGame(true)
		end)), var_82_3, "round_result")
	end
end

function VolleyScoreManager.getScore(arg_89_0, arg_89_1)
	return arg_89_1 and arg_89_0.vars.ally_score or arg_89_0.vars.enemy_score
end

function VolleyScoreManager.addGauge(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	local var_90_0 = arg_90_3 or {}
	local var_90_1 = tonumber(arg_90_2) or 1
	local var_90_2 = 0
	
	if arg_90_1 then
		if var_90_0.is_ult then
			var_90_2 = arg_90_0.vars.gauge_special_user[var_90_1]
		elseif var_90_0.is_defense then
			var_90_2 = arg_90_0.vars.gauge_def_user[var_90_1]
		else
			var_90_2 = arg_90_0.vars.gauge_atk_user[var_90_1]
		end
	else
		if var_90_0.is_ult then
			var_90_2 = arg_90_0.vars.gauge_special_npc[var_90_1]
		elseif var_90_0.is_defense then
			var_90_2 = arg_90_0.vars.gauge_def_npc[var_90_1]
		else
			var_90_2 = arg_90_0.vars.gauge_atk_npc[var_90_1]
		end
		
		var_90_2 = tonumber(var_90_2)
	end
	
	local var_90_3 = false
	local var_90_4 = false
	
	if arg_90_1 then
		if arg_90_0.vars.ally_max_gauge <= arg_90_0.vars.ally_gauge then
			local var_90_5 = true
		end
		
		arg_90_0.vars.ally_gauge = arg_90_0.vars.ally_gauge + var_90_2
		
		if arg_90_0.vars.ally_max_gauge <= arg_90_0.vars.ally_gauge then
			var_90_3 = true
		end
	else
		if arg_90_0.vars.enemy_max_gauge <= arg_90_0.vars.enemy_gauge then
			local var_90_6 = true
		end
		
		arg_90_0.vars.enemy_gauge = arg_90_0.vars.enemy_gauge + var_90_2
		
		if arg_90_0.vars.enemy_max_gauge <= arg_90_0.vars.enemy_gauge then
			var_90_3 = true
		end
	end
	
	arg_90_0:updateEffect()
	
	return var_90_3, arg_90_1
end

function VolleyScoreManager.isEnemyMaxGaugeExpect(arg_91_0, arg_91_1, arg_91_2)
	local var_91_0 = arg_91_0.vars.enemy_gauge
	local var_91_1 = arg_91_0.vars.enemy_max_gauge
	local var_91_2 = 0
	
	if arg_91_1 == "ult" then
		var_91_2 = arg_91_0.vars.gauge_special_npc[arg_91_2]
	elseif arg_91_1 == "toss_spike" then
		var_91_2 = arg_91_0.vars.gauge_def_npc[arg_91_2]
	elseif arg_91_1 == "spike" then
		var_91_2 = arg_91_0.vars.gauge_atk_npc[arg_91_2]
	end
	
	return var_91_1 <= var_91_2 + var_91_0
end

function VolleyScoreManager.isMaxGauge(arg_92_0, arg_92_1)
	if arg_92_1 then
		return arg_92_0.vars.ally_max_gauge <= arg_92_0.vars.ally_gauge
	else
		return arg_92_0.vars.enemy_max_gauge <= arg_92_0.vars.enemy_gauge
	end
end

function VolleyScoreManager.resetGague(arg_93_0, arg_93_1)
	if arg_93_1 then
		arg_93_0.vars.ally_gauge = 0
	else
		arg_93_0.vars.enemy_gauge = 0
	end
end

function VolleyScoreManager.addTypeText(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0 = tonumber(arg_94_3)
	local var_94_1 = ({
		"vball_score3.png",
		"vball_score2.png",
		"vball_score1.png"
	})[var_94_0]
	local var_94_2 = cc.Sprite:create("img/" .. var_94_1)
	local var_94_3 = VolleyBallMain:getParentLayer()
	
	var_94_2:setScale(0.5)
	var_94_2:setOpacity(204)
	var_94_2:setAnchorPoint(0.5, 0.5)
	var_94_3:addChild(var_94_2)
	var_94_2:bringToFront()
	var_94_2:setPosition(arg_94_1, arg_94_2)
	
	local var_94_4 = 0.5
	local var_94_5 = 0.8
	local var_94_6 = 1
	local var_94_7 = 1.1
	local var_94_8 = 1
	local var_94_9 = 0.5
	local var_94_10 = 0.2
	local var_94_11 = 0.8
	local var_94_12 = 0.9
	local var_94_13 = 1
	local var_94_14 = 1
	local var_94_15 = 1
	local var_94_16 = 0.5
	local var_94_17 = 0.2
	local var_94_18 = 100
	local var_94_19 = 80
	
	BattleAction:Add(SEQ(SCALE(var_94_19, var_94_4, var_94_5), SCALE(var_94_19, var_94_5, var_94_6), SCALE(var_94_19, var_94_6, var_94_7), SCALE(var_94_18, var_94_7, var_94_8), SCALE(var_94_18, var_94_8, var_94_9), SCALE(var_94_18, var_94_9, var_94_10)), var_94_2, "touch_text_scale")
	BattleAction:Add(SEQ(OPACITY(var_94_19, var_94_11, var_94_12), OPACITY(var_94_19, var_94_12, var_94_13), OPACITY(var_94_19, var_94_13, var_94_14), OPACITY(var_94_18, var_94_14, var_94_15), OPACITY(var_94_18, var_94_15, var_94_16), OPACITY(var_94_18, var_94_16, var_94_17)), var_94_2, "touch_text_opaicty")
	BattleAction:Add(SEQ(DELAY(var_94_18 * 6.5), REMOVE()), var_94_2, "touch_text_remove")
end

function VolleyBallUtil.getRndPosX_list(arg_95_0)
	return var_0_2
end

function VolleyBallUtil.getRndPosY_list(arg_96_0)
	return var_0_1
end

function VolleyBallUtil.getRndPosX_gap(arg_97_0)
	return table.count(var_0_2)
end

function VolleyBallUtil.getRndPosY_gap(arg_98_0)
	return table.count(var_0_1)
end

function VolleyBallMain.endVolleyGame(arg_99_0)
	resume()
	SoundEngine:resume()
	SoundEngine:stopAllEvent()
	Dialog:closeAll()
	BattleAction:RemoveAll()
	UIAction:RemoveAll()
	BattleUIAction:RemoveAll()
	StageStateManager:reset()
	UIOption:UpdateScreenOnState()
	SceneManager:popScene()
	UIOption:setBlock(false)
end

function VolleyBallMain.openHelpGuide(arg_100_0)
	pause()
	HelpGuide:open({
		contents_id = "vsu1aa"
	})
end

function VolleyBallMain.isPausable(arg_101_0)
	if SceneManager:getCurrentSceneName() ~= "mini_volley_ball" or not arg_101_0.vars or not get_cocos_refid(arg_101_0.vars.wnd) then
		return 
	end
	
	return true
end

function VolleyBallMain.applicationDidEnterBackground(arg_102_0)
	if IS_ANDROID_BASED_PLATFORM and getenv("allow.battle_pause", "") == "1" then
		arg_102_0.time_didEnterBackground = os.time()
	end
end

function VolleyBallMain.applicationWillEnterForeground(arg_103_0)
	if IS_ANDROID_BASED_PLATFORM and getenv("allow.battle_pause", "") == "1" and arg_103_0.time_didEnterBackground and os.time() - arg_103_0.time_didEnterBackground > 1 and arg_103_0:isPausable() then
		VolleyBallEsc:open()
	end
end

function VolleySoundManager.play(arg_104_0, arg_104_1)
	local var_104_0 = arg_104_1
	
	if var_104_0 == "start" then
		var_104_0 = math.random(1, 2) == 1 and "Summer_beginning" or "Summer_beginning_alt1"
	end
	
	SoundEngine:play("event:/" .. var_104_0)
end

VolleyBallEsc = VolleyBallEsc or {}

function HANDLER.volley_ball_esc(arg_105_0, arg_105_1)
	if arg_105_1 == "btn_giveup" then
		VolleyBallEsc:giveUp()
		
		return 
	end
	
	if arg_105_1 == "btn_option" then
		UIOption:show({
			category = "game",
			close_callback = function()
			end
		})
		
		return 
	end
	
	if arg_105_1 == "btn_restart" then
		balloon_message_with_sound("ui_inbattle_esc_restart_error")
		
		return 
	end
	
	if arg_105_1 == "btn_close" or arg_105_1 == "btn_return" then
		VolleyBallEsc:close()
		
		return 
	end
end

function VolleyBallEsc.open(arg_107_0)
	arg_107_0.wnd = load_dlg("inbattle_esc", true, "wnd", function()
		arg_107_0:close()
	end)
	
	arg_107_0.wnd:setName("volley_ball_esc")
	
	local var_107_0 = SceneManager:getRunningNativeScene()
	
	if not var_107_0 then
		UIAction:Add(REMOVE(), arg_107_0.wnd, "worldboss")
		
		return 
	end
	
	if_set_visible(arg_107_0.wnd, "n_common", true)
	if_set_opacity(arg_107_0.wnd, "btn_restart", 76.5)
	var_107_0:addChild(arg_107_0.wnd)
	arg_107_0.wnd:bringToFront()
	pause()
end

function VolleyBallEsc.giveUp(arg_109_0)
	Dialog:msgBox(T("pop_giveup_battle"), {
		yesno = true,
		handler = function()
			arg_109_0:_giveUp()
		end,
		cancel_handler = function()
			arg_109_0:close()
		end,
		yes_text = T("msg_close")
	})
end

function VolleyBallEsc._giveUp(arg_112_0)
	Dialog:closeAll()
	VolleyBallMain:endVolleyGame()
	UIOption:setBlock(false)
end

function VolleyBallEsc.close(arg_113_0)
	if not get_cocos_refid(arg_113_0.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_113_0.wnd, "block")
	BackButtonManager:pop("volley_ball_esc")
	
	arg_113_0.wnd = nil
	
	resume()
end

function VolleyBallEsc.isOpen(arg_114_0)
	if not get_cocos_refid(arg_114_0.wnd) then
		return 
	end
	
	return true
end

VolleyBallReady = {}

function HANDLER.volleyball_battle_ready(arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4)
	if arg_115_1 == "n_btn" and arg_115_0.idx then
		if arg_115_0.is_enterable then
			VolleyBallReady:select_level(arg_115_0.idx)
		else
			balloon_message_with_sound("ui_battle_ready_difficulty_error")
		end
	elseif arg_115_1 == "btn_go" then
		VolleyBallReady:startGame()
	elseif arg_115_1 == "btn_limit" then
		VolleyBallReady:showLimitInfo(false)
	end
end

function VolleyBallReady.show(arg_116_0, arg_116_1)
	local var_116_0 = arg_116_1 or {}
	
	if not var_116_0.enter_id then
		return 
	end
	
	local var_116_1, var_116_2 = DB("level_enter", var_116_0.enter_id, {
		"id",
		"type"
	})
	
	if not var_116_1 or not var_116_2 or var_116_2 ~= "volleyball" then
		return 
	end
	
	local var_116_3 = SceneManager:getRunningPopupScene()
	
	arg_116_0.vars = {}
	arg_116_0.vars.wnd = load_dlg("volleyball_battle_ready", true, "wnd")
	
	var_116_3:addChild(arg_116_0.vars.wnd)
	
	local var_116_4 = {
		"crystal",
		"gold",
		"stamina"
	}
	local var_116_5 = SubstoryManager:getInfo() or {}
	
	for iter_116_0 = 1, 3 do
		if var_116_5["token_id" .. iter_116_0] then
			table.insert(var_116_4, var_116_5["token_id" .. iter_116_0])
		end
	end
	
	TopBarNew:createFromPopup(T("battle_ready"), arg_116_0.vars.wnd, function()
		VolleyBallReady:leave()
	end, var_116_4)
	
	arg_116_0.vars.enter_id = var_116_0.enter_id
	
	arg_116_0:initData()
	arg_116_0:initLevelUI()
	
	arg_116_0.vars.first_select_level = SAVE:get("volley_diff." .. arg_116_0.vars.first_map_id, 1)
	
	if var_116_0.select_level then
		arg_116_0.vars.first_select_level = var_116_0.select_level
	end
	
	arg_116_0:select_level(arg_116_0.vars.first_select_level)
	arg_116_0:showLimitInfo(true, false)
end

function VolleyBallReady.showLimitInfo(arg_118_0, arg_118_1, arg_118_2, arg_118_3)
	if not get_cocos_refid(arg_118_0.vars.wnd) then
		return 
	end
	
	local function var_118_0(arg_119_0)
		arg_119_0:setScale(1)
	end
	
	local var_118_1 = arg_118_0.vars.wnd:getChildByName("n_count_info")
	
	if not get_cocos_refid(var_118_1) then
		return 
	end
	
	local var_118_2 = false
	
	if arg_118_1 then
		local var_118_3 = DB("level_enter", arg_118_3 or arg_118_0.vars.enter_id, {
			"achievement_link"
		})
		local var_118_4 = var_118_1:getChildByName("talk_bg_count")
		
		if var_118_3 then
			var_118_2 = UIUtil:showSubstoryAchievementBalloon(var_118_1, var_118_3)
		end
		
		if var_118_2 == false then
			return 
		end
		
		if arg_118_2 then
			var_118_1:setScale(1)
			if_set_visible(arg_118_0.vars.wnd, "n_count_info", true)
		else
			var_118_1:setVisible(true)
			var_118_1:setScale(0)
			UIAction:Add(SEQ(LOG(SCALE(80, 0, 1))), var_118_1)
		end
	else
		var_118_1:setScale(1)
		
		if arg_118_2 then
			if_set_visible(arg_118_0.vars.wnd, "n_count_info", false)
		elseif var_118_1:isVisible() then
			UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false), CALL(var_118_0, var_118_1)), var_118_1)
		end
	end
end

function VolleyBallReady.initData(arg_120_0)
	arg_120_0.vars.datas = {}
	arg_120_0.vars.first_map_id = nil
	
	local var_120_0 = true
	
	for iter_120_0 = 0, 3 do
		local var_120_1 = string.sub(arg_120_0.vars.enter_id, -2, -1)
		local var_120_2 = string.sub(arg_120_0.vars.enter_id, 1, 6) .. iter_120_0 .. var_120_1
		local var_120_3 = DBT("substory_volleyball_enter", var_120_2, {
			"id",
			"npc_name",
			"illust_user",
			"illust_npc",
			"reward1",
			"count1",
			"reward2",
			"count2",
			"reward3",
			"count3",
			"reward4",
			"count4"
		})
		
		if not var_120_3 or table.empty(var_120_3) then
			break
		end
		
		if not arg_120_0.vars.first_map_id then
			arg_120_0.vars.first_map_id = var_120_3.id
		end
		
		var_120_3.is_enterable = var_120_0
		
		if DEBUG.MAP_DEBUG then
			var_120_3.is_enterable = true
		end
		
		var_120_3.is_cleared = Account:isMapCleared(var_120_3.id)
		var_120_0 = var_120_3.is_cleared
		var_120_3.idx = iter_120_0 + 1
		
		table.insert(arg_120_0.vars.datas, var_120_3)
	end
	
	if table.count(arg_120_0.vars.datas) < 4 then
		Log.e("잘못된 맵 데이터", arg_120_0.vars.enter_id)
	end
end

function VolleyBallReady.initLevelUI(arg_121_0)
	local var_121_0 = arg_121_0.vars.wnd:getChildByName("n_difficulty")
	
	for iter_121_0, iter_121_1 in pairs(arg_121_0.vars.datas) do
		local var_121_1 = iter_121_1.idx
		local var_121_2 = var_121_0:getChildByName("n_" .. var_121_1)
		local var_121_3 = iter_121_1.is_enterable
		
		if get_cocos_refid(var_121_2) then
			if_set_opacity(var_121_2, "n_" .. var_121_1, var_121_3 and 255 or 76.5)
			if_set_visible(var_121_2, "cm_icon_etclock", not var_121_3)
			if_set_visible(var_121_2, "selected", false)
			if_set_visible(var_121_2, "icon_clear", Account:isMapCleared(iter_121_1.id))
			
			local var_121_4 = var_121_2:getChildByName("n_btn")
			
			if get_cocos_refid(var_121_4) then
				var_121_4.idx = var_121_1
				var_121_4.is_enterable = var_121_3
			end
		end
	end
end

function VolleyBallReady.select_level(arg_122_0, arg_122_1)
	arg_122_0.vars.select_level = arg_122_1
	arg_122_0.vars.cur_data = arg_122_0.vars.datas[arg_122_0.vars.select_level]
	
	arg_122_0:updateUI()
end

function VolleyBallReady.updateUI(arg_123_0)
	arg_123_0:updateSelectUI()
	arg_123_0:updateEnterButton()
	arg_123_0:updatePoster()
	arg_123_0:updateReward()
end

function VolleyBallReady.updatePoster(arg_124_0)
	local var_124_0 = arg_124_0.vars.cur_data.illust_user
	local var_124_1 = arg_124_0.vars.cur_data.illust_npc
	local var_124_2 = arg_124_0.vars.wnd:getChildByName("n_user")
	local var_124_3 = arg_124_0.vars.wnd:getChildByName("n_npc")
	
	if_set_sprite(var_124_2, "n_pos", "face/" .. var_124_0)
	if_set_sprite(var_124_3, "n_pos", "face/" .. var_124_1)
	
	local var_124_4 = arg_124_0.vars.wnd:getChildByName("n_title_user")
	local var_124_5 = arg_124_0.vars.wnd:getChildByName("n_title_npc")
	
	if_set(var_124_4, "t_name", Account:getName(true))
	if_set(var_124_5, "t_name", T(arg_124_0.vars.cur_data.npc_name))
end

function VolleyBallReady.updateReward(arg_125_0)
	local var_125_0 = arg_125_0.vars.wnd:getChildByName("n_reward")
	local var_125_1 = arg_125_0.vars.cur_data.id
	local var_125_2 = not Account:isMapCleared(var_125_1)
	
	if_set_visible(arg_125_0.vars.wnd, "n_reward", var_125_2)
	if_set_visible(arg_125_0.vars.wnd, "n_noreward", not var_125_2)
	
	if var_125_2 then
		for iter_125_0 = 1, 4 do
			local var_125_3 = var_125_0:getChildByName("n_" .. iter_125_0)
			
			if get_cocos_refid(var_125_3) then
				var_125_3:removeAllChildren()
				
				local var_125_4 = arg_125_0.vars.cur_data["reward" .. iter_125_0]
				local var_125_5 = arg_125_0.vars.cur_data["count" .. iter_125_0]
				
				if var_125_4 and var_125_5 then
					if string.starts(var_125_4, "c") then
						UIUtil:getRewardIcon("c", var_125_4, {
							no_detail_popup = true,
							parent = var_125_3
						})
					else
						UIUtil:getRewardIcon(var_125_5, var_125_4, {
							no_detail_popup = true,
							parent = var_125_3
						})
					end
				end
			end
		end
	end
end

function VolleyBallReady.updateSelectUI(arg_126_0)
	local var_126_0 = arg_126_0.vars.wnd:getChildByName("n_difficulty")
	
	for iter_126_0 = 1, 4 do
		local var_126_1 = var_126_0:getChildByName("n_" .. iter_126_0)
		
		if get_cocos_refid(var_126_1) then
			if_set_visible(var_126_1, "selected", arg_126_0.vars.select_level == iter_126_0)
		end
	end
end

function VolleyBallReady.updateEnterButton(arg_127_0)
end

function VolleyBallReady.leave(arg_128_0)
	arg_128_0.vars.wnd:removeFromParent()
	
	arg_128_0.vars = nil
	
	BackButtonManager:pop("volleyball_battle_ready")
	TopBarNew:pop()
end

function VolleyBallReady.startGame(arg_129_0)
	local var_129_0 = arg_129_0.vars.cur_data or {}
	
	if not var_129_0.is_enterable then
		balloon_message_with_sound("err: temp clear before map")
		
		return 
	end
	
	local var_129_1 = arg_129_0.vars.first_map_id
	
	if var_129_1 then
		local var_129_2 = DB("level_enter", var_129_1, {
			"type"
		})
		local var_129_3 = WorldMapManager:getController()
		
		if var_129_3 and var_129_2 and WORLDMAP_MODE_LIST[var_129_2] then
			var_129_3:saveLastTown(var_129_1)
			SAVE:sendQueryServerConfig()
		end
		
		SAVE:set("volley_diff." .. var_129_1, arg_129_0.vars.select_level)
		SAVE:save()
	end
	
	SceneManager:nextScene("mini_volley_ball", {
		enter_id = var_129_0.id
	})
	
	arg_129_0.vars = nil
end

VolleyBallResult = {}

function HANDLER.volleyball_result(arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4)
	if arg_130_1 == "btn_next" then
		VolleyBallResult:next_game()
	elseif arg_130_1 == "btn_again" then
		VolleyBallResult:restart_game()
	elseif arg_130_1 == "btn_back" then
		VolleyBallResult:onLeave()
	end
end

function VolleyBallResult.show(arg_131_0, arg_131_1)
	local var_131_0 = arg_131_1 or {}
	
	if not var_131_0.map then
		return 
	end
	
	local var_131_1, var_131_2 = DB("level_enter", var_131_0.map, {
		"id",
		"type"
	})
	
	if not var_131_1 or not var_131_2 or var_131_2 ~= "volleyball" then
		return 
	end
	
	local var_131_3 = SceneManager:getRunningPopupScene()
	
	arg_131_0.vars = {}
	arg_131_0.vars.wnd = load_dlg("volleyball_result", true, "wnd")
	
	var_131_3:addChild(arg_131_0.vars.wnd)
	
	arg_131_0.vars.map_id = var_131_0.map
	arg_131_0.vars.is_user_win = var_131_0.is_user_win or false
	arg_131_0.vars.rewards = {}
	
	if var_131_0.result_rewards and var_131_0.result_rewards.rewards and not table.empty(var_131_0.result_rewards.rewards) then
		arg_131_0.vars.rewards = var_131_0.result_rewards.rewards
	end
	
	arg_131_0:initData()
	arg_131_0:update_ui()
	arg_131_0:initUIAction()
	BackButtonManager:push({
		check_id = "VolleyBallResult",
		back_func = function()
			VolleyBallResult:onLeave()
		end
	})
end

function VolleyBallResult.initData(arg_133_0)
	arg_133_0.vars.data = {}
	
	local var_133_0 = DBT("substory_volleyball_enter", arg_133_0.vars.map_id, {
		"id",
		"config_id",
		"npc_name",
		"illust_user",
		"illust_npc",
		"reward1",
		"count1",
		"reward2",
		"count2",
		"reward3",
		"count3",
		"reward4",
		"count4"
	})
	
	if not var_133_0 or table.empty(var_133_0) then
		Log.e("empty data", arg_133_0.vars.map_id)
		
		return 
	end
	
	arg_133_0.vars.data = var_133_0
	
	local var_133_1 = string.sub(arg_133_0.vars.map_id, -2, -1)
	local var_133_2 = string.sub(arg_133_0.vars.map_id, -3, -3)
	
	if var_133_2 and tonumber(var_133_2) then
		var_133_2 = tonumber(var_133_2) + 1
	end
	
	local var_133_3 = string.sub(arg_133_0.vars.map_id, 1, 6) .. var_133_2 .. var_133_1
	local var_133_4 = DBT("substory_volleyball_enter", var_133_3, {
		"id",
		"config_id"
	})
	
	arg_133_0.vars.next_map_expsit = var_133_4 and not table.empty(var_133_4)
	
	if arg_133_0.vars.next_map_expsit then
		arg_133_0.vars.next_map_id = var_133_4.id
		arg_133_0.vars.next_config_id = var_133_4.config_id
	end
end

function VolleyBallResult.initUIAction(arg_134_0)
	local var_134_0
	
	if arg_134_0.vars.is_user_win then
		var_134_0 = arg_134_0.vars.wnd:getChildByName("n_lose_npc")
	else
		var_134_0 = arg_134_0.vars.wnd:getChildByName("n_lose_user")
	end
	
	if get_cocos_refid(var_134_0) then
		local var_134_1 = var_134_0:getChildByName("n_eff")
		local var_134_2 = var_134_0:getChildByName("n_eff01")
		local var_134_3 = var_134_0:getChildByName("n_eff02")
		
		if get_cocos_refid(var_134_1) and get_cocos_refid(var_134_2) and get_cocos_refid(var_134_3) then
			BattleAction:Add(LOOP(ROTATE(8000, 0, -360), 100), var_134_1, "voll_rotat1")
			BattleAction:Add(LOOP(ROTATE(8000, 0, -360), 100), var_134_2, "voll_rotat2")
			BattleAction:Add(LOOP(ROTATE(8000, 0, -360), 100), var_134_3, "voll_rotat3")
		end
	end
end

function VolleyBallResult.removeUIAction(arg_135_0)
	if not arg_135_0.vars.is_user_win then
		BattleAction:Remove("voll_rotat1")
		BattleAction:Remove("voll_rotat2")
		BattleAction:Remove("voll_rotat3")
	end
end

function VolleyBallResult.update_ui(arg_136_0)
	arg_136_0:update_poster()
	arg_136_0:update_rewards()
	arg_136_0:update_buttons()
end

function VolleyBallResult.update_rewards(arg_137_0)
	local var_137_0 = arg_137_0.vars.rewards and not table.empty(arg_137_0.vars.rewards)
	
	if_set_visible(arg_137_0.vars.wnd, "n_reward", var_137_0)
	
	local var_137_1
	
	if var_137_0 then
		var_137_1 = arg_137_0.vars.wnd:getChildByName("n_reward")
		
		local var_137_2 = false
		local var_137_3 = (table.count(arg_137_0.vars.rewards) or 1) % 2 == 1
		
		if_set_visible(var_137_1, "n_odd", var_137_3)
		if_set_visible(var_137_1, "n_even", not var_137_3)
		
		local var_137_4
		
		if var_137_3 then
			var_137_4 = var_137_1:getChildByName("n_odd")
		else
			var_137_4 = var_137_1:getChildByName("n_even")
		end
		
		for iter_137_0, iter_137_1 in pairs(arg_137_0.vars.rewards) do
			local var_137_5 = string.starts(iter_137_1.code, "c")
			local var_137_6 = var_137_4:getChildByName("n_" .. iter_137_0)
			
			if get_cocos_refid(var_137_6) then
				if var_137_5 then
					UIUtil:getRewardIcon("c", iter_137_1.code, {
						no_detail_popup = true,
						parent = var_137_6
					})
				else
					local var_137_7 = iter_137_1.code
					
					if Account:isCurrencyType(iter_137_1.code) and not string.starts(iter_137_1.code, "to_") then
						var_137_7 = "to_" .. var_137_7
					end
					
					UIUtil:getRewardIcon(iter_137_1.count, var_137_7, {
						no_detail_popup = true,
						parent = var_137_6
					})
				end
			end
		end
	else
		var_137_1 = getChildByPath(arg_137_0.vars.wnd, "n_set")
		
		if get_cocos_refid(var_137_1) then
			var_137_1:setVisible(true)
		end
	end
	
	if_set_sprite(var_137_1, "n_set", "img/vball_set" .. string.sub(arg_137_0.vars.data.config_id, "-1", "-1") .. ".png")
end

function VolleyBallResult.update_poster(arg_138_0)
	local var_138_0 = arg_138_0.vars.is_user_win
	local var_138_1 = arg_138_0.vars.wnd:getChildByName("CENTER")
	local var_138_2 = arg_138_0.vars.data.illust_user
	local var_138_3 = arg_138_0.vars.data.illust_npc
	local var_138_4
	
	if var_138_0 then
		var_138_4 = var_138_1:getChildByName("n_lose_npc")
		
		SpriteCache:resetSprite(var_138_4:getChildByName("n_user"), "face/" .. var_138_2 .. ".png")
		SpriteCache:resetSprite(var_138_4:getChildByName("n_pos"), "face/" .. var_138_3 .. ".png?grayscale=1")
	else
		var_138_4 = var_138_1:getChildByName("n_lose_user")
		
		SpriteCache:resetSprite(var_138_4:getChildByName("n_user"), "face/" .. var_138_2 .. ".png?grayscale=1")
		SpriteCache:resetSprite(var_138_4:getChildByName("n_pos"), "face/" .. var_138_3 .. ".png")
	end
	
	if_set_visible(var_138_1, "n_lose_npc", var_138_0)
	if_set_visible(var_138_1, "n_lose_user", not var_138_0)
	
	local var_138_5 = var_138_4:getChildByName("n_title_user")
	local var_138_6 = var_138_4:getChildByName("n_title_npc")
	
	if_set(var_138_5, "t_name", Account:getName(true))
	if_set(var_138_6, "t_name", T(arg_138_0.vars.data.npc_name))
end

function VolleyBallResult.update_buttons(arg_139_0)
	local var_139_0 = arg_139_0.vars.wnd:getChildByName("RIGHT")
	local var_139_1 = arg_139_0.vars.next_map_expsit and arg_139_0.vars.is_user_win
	
	if_set_visible(var_139_0, "btn_next", var_139_1)
	
	if var_139_1 then
		local var_139_2 = var_139_0:getChildByName("n_icon_difficulty")
		
		if get_cocos_refid(var_139_2) then
			if_set_visible(var_139_2, string.sub(arg_139_0.vars.next_config_id, -1, -1), true)
		end
	end
end

function VolleyBallResult.next_game(arg_140_0)
	if not arg_140_0.vars.next_map_expsit then
		balloon_message_with_sound("err: next map is not exist")
		
		return 
	elseif not arg_140_0.vars.is_user_win then
		balloon_message_with_sound("err: not win")
		
		return 
	end
	
	local var_140_0 = string.sub(arg_140_0.vars.next_config_id, -1, -1) or 1
	
	VolleyBallReady:show({
		enter_id = arg_140_0.vars.next_map_id,
		select_level = tonumber(var_140_0)
	})
end

function VolleyBallResult.restart_game(arg_141_0)
	if not arg_141_0.vars.map_id then
		balloon_message_with_sound("err: map is not exist")
		
		return 
	end
	
	VolleyBallReady:show({
		enter_id = arg_141_0.vars.map_id
	})
end

function VolleyBallResult.onLeave(arg_142_0)
	arg_142_0:removeUIAction()
	arg_142_0.vars.wnd:removeFromParent()
	
	arg_142_0.vars = nil
	
	SceneManager:popScene()
	BackButtonManager:pop("VolleyBallResult")
end
