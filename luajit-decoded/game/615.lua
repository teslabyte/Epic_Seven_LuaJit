local var_0_0 = false
local var_0_1 = false

DEFENCE_BOSS_DEBUG = false
MiniDefenceMain = {}
MiniDefenceMainResult = {}
MiniDefenceMainManager = {}
MiniDefenceFeverManager = {}
MiniDefenceEnemyManager = {}
MiniDefenceEnemyUnit = {}
MiniDefencePlayer = {}
MiniDefenceUtil = {}

local var_0_2 = 200
local var_0_3 = 1500
local var_0_4 = 10
local var_0_5 = 10
local var_0_6 = 20
local var_0_7 = 200
local var_0_8 = 200
local var_0_9 = 10
local var_0_10 = 1
local var_0_11 = 3000
local var_0_12 = 1600

function MsgHandler.substory_arcade_clear(arg_1_0)
	if arg_1_0 then
		MiniDefenceMain:res_clear_query(arg_1_0)
	end
end

function HANDLER.game_aprilfool_battle(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	if arg_2_1 == "btn_touch" then
		MiniDefenceFeverManager:updateTouchTick()
		MiniDefencePlayer:onAttack()
	end
end

function HANDLER.game_aprilfool_result(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_1 == "btn_close" then
		MiniDefenceMainResult:onLeave()
	end
end

function HANDLER.defence_inbattle_topbar(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_1 == "btn_setting" then
		MiniDefenceEsc:open()
		
		return 
	end
	
	if arg_4_1 == "btn_chat" then
		local var_4_0
		
		ChatMain:show(SceneManager:getRunningPopupScene(), nil, {
			section = var_4_0
		})
	end
end

function MiniDefenceMain.enterGame(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0, var_5_1, var_5_2, var_5_3 = DB("level_enter", arg_5_1, {
		"id",
		"type",
		"substory_contents_id",
		"story_stage_link"
	})
	
	if not var_5_0 or not var_5_1 or var_5_1 ~= "arcade" or not var_5_2 then
		return 
	end
	
	SceneManager:nextScene("mini_defence", {
		enter_id = arg_5_1,
		substory_contents_id = var_5_2,
		story_stage_link = var_5_3
	})
end

function MiniDefenceMain.startGame(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = arg_6_1
	arg_6_0.vars.enter_id = arg_6_2.enter_id
	arg_6_0.vars.substory_contents_id = arg_6_2.substory_contents_id
	arg_6_0.vars.isEndGame = nil
	
	arg_6_0:init()
	arg_6_0:updateBGM("normal")
end

function MiniDefenceMain.onEnter(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2 or {}
	
	if var_7_0.story_stage_link then
		play_story(var_7_0.story_stage_link, {
			force = true,
			enter_id = var_7_0.enter_id,
			on_finish = function()
				MiniDefenceMain:startGame(arg_7_1, var_7_0)
			end
		})
	else
		MiniDefenceMain:startGame(arg_7_1, var_7_0)
	end
end

function MiniDefenceMain.getEnterId(arg_9_0)
	return arg_9_0.vars.enter_id
end

function MiniDefenceMain.init(arg_10_0)
	arg_10_0:initData()
	arg_10_0:initBG()
	arg_10_0:initUI()
	arg_10_0:initManagers()
end

function MiniDefenceMain.initData(arg_11_0)
	local var_11_0 = DBT("substory_arcade_1_stage", arg_11_0.vars.substory_contents_id, {
		"id",
		"limit_time",
		"character_id",
		"monster_id1",
		"spawn_interval1",
		"monster_id2",
		"spawn_interval2",
		"monster_id3",
		"spawn_interval3",
		"boss_id",
		"boss_time",
		"bg",
		"ambient_color",
		"bgm",
		"bgm_fever",
		"success_story",
		"success_img",
		"fail_story",
		"fail_img",
		"fever_player_res",
		"fever_monster_res",
		"fever_speedup1",
		"fever_speedup2"
	})
	
	if not var_11_0 or table.empty(var_11_0) then
		return 
	end
	
	arg_11_0.vars.data = var_11_0
	arg_11_0.vars.left_time = arg_11_0.vars.data.limit_time
end

function MiniDefenceMain.updateBGM(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not arg_12_0.vars.data then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.data.bgm
	local var_12_1 = arg_12_0.vars.data.bgm_fever
	
	if arg_12_1 == "normal" then
		SoundEngine:playBGM("event:/bgm/" .. var_12_0)
	elseif arg_12_1 == "fever" then
		SoundEngine:playBGM("event:/bgm/" .. var_12_1)
	end
end

function MiniDefenceMain.getData(arg_13_0)
	return arg_13_0.vars.data
end

function MiniDefenceMain.initUI(arg_14_0)
	arg_14_0.vars.ui_wnd = load_dlg("game_aprilfool_battle", true, "wnd")
	
	arg_14_0.vars.wnd:addChild(arg_14_0.vars.ui_wnd)
	if_set_visible(arg_14_0.vars.ui_wnd, "n_boss", false)
	
	arg_14_0.vars.countDown = arg_14_0.vars.ui_wnd:getChildByName("txt_time")
	arg_14_0.vars.txt_count = arg_14_0.vars.ui_wnd:getChildByName("txt_count")
	arg_14_0.vars.n_diene = arg_14_0.vars.ui_wnd:getChildByName("n_diene")
	arg_14_0.vars.n_hp_bar = arg_14_0.vars.n_diene:getChildByName("n_hp_bar")
	
	arg_14_0:initBossUI()
	
	arg_14_0.vars.topbar_wnd = load_dlg("inbattle_topbar", true, "wnd")
	
	arg_14_0.vars.ui_wnd:addChild(arg_14_0.vars.topbar_wnd)
	arg_14_0.vars.topbar_wnd:setName("defence_inbattle_topbar")
	if_set_visible(arg_14_0.vars.topbar_wnd, "n_potion", false)
	if_set_visible(arg_14_0.vars.topbar_wnd, "n_camping", false)
	if_set_visible(arg_14_0.vars.topbar_wnd, "n_miscs", false)
	if_set_visible(arg_14_0.vars.topbar_wnd, "btn_boss_guide", false)
	if_set_visible(arg_14_0.vars.topbar_wnd, "btn_draw_turn", false)
end

function MiniDefenceMain.updatePlayerHPUI(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.ui_wnd) or not arg_15_1 or not arg_15_2 then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.n_hp_bar
	local var_15_1 = arg_15_2 / arg_15_1
	local var_15_2 = math.max(var_15_1, 0)
	
	if_set_percent(var_15_0, nil, var_15_2)
end

function MiniDefenceMain.getUIWnd(arg_16_0)
	return arg_16_0.vars.ui_wnd
end

function MiniDefenceMain.updateProgress(arg_17_0)
end

function MiniDefenceMain.updateKillCount(arg_18_0, arg_18_1)
	if_set(arg_18_0.vars.txt_count, nil, arg_18_1)
	
	local var_18_0 = 30
	
	if string.len(arg_18_1) == 2 and not arg_18_0.vars.txt_count.change_length then
		arg_18_0.vars.txt_count.change_length = true
		
		local var_18_1 = arg_18_0.vars.txt_count:getChildByName("n_kill")
		
		if get_cocos_refid(var_18_1) then
			var_18_1:setPositionX(var_18_1:getPositionX() + var_18_0)
		end
	elseif string.len(arg_18_1) == 3 and not arg_18_0.vars.txt_count.change_length_2 then
		arg_18_0.vars.txt_count.change_length_2 = true
		
		local var_18_2 = arg_18_0.vars.txt_count:getChildByName("n_kill")
		
		if get_cocos_refid(var_18_2) then
			var_18_2:setPositionX(var_18_2:getPositionX() + var_18_0)
		end
	end
	
	BattleAction:Add(SEQ(SCALE(50, 1, 1.5), SCALE(50, 1.5, 1)), arg_18_0.vars.txt_count, "txt_count")
end

function MiniDefenceMain.initBG(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) or not arg_19_0.vars.data then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.data.bg
	local var_19_1 = arg_19_0.vars.data.ambient_color
	
	arg_19_0.vars.layer, arg_19_0.vars.field = FIELD_NEW:create(var_19_0, VIEW_WIDTH * 2)
	
	arg_19_0.vars.layer:setName("travel_bg")
	arg_19_0.vars.field:setViewPortPosition(DESIGN_WIDTH * 0.5)
	arg_19_0.vars.field:updateViewport()
	arg_19_0.vars.wnd:addChild(arg_19_0.vars.layer)
	
	if var_19_1 then
		arg_19_0.vars.layer:setColor(tocolor(var_19_1))
	end
	
	arg_19_0:scaleBG(1.4, 1.4)
end

function MiniDefenceMain.scaleBG(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.vars.layer:setScaleX(arg_20_1)
	arg_20_0.vars.layer:setScaleY(arg_20_2)
	arg_20_0.vars.field:updateViewport()
end

function MiniDefenceMain.initManagers(arg_21_0)
	MiniDefenceMainManager:init()
	MiniDefenceEnemyManager:init()
	
	local var_21_0 = arg_21_0.vars.data.character_id
	
	MiniDefenceFeverManager:init(var_21_0)
	MiniDefencePlayer:init(var_21_0)
	Scheduler:add(arg_21_0.vars.wnd, arg_21_0.onUpdate, arg_21_0):setName("MiniDefenceMain")
	Scheduler:addInterval(arg_21_0.vars.wnd, 1000, arg_21_0.updateTimmer, arg_21_0):setName("MiniDefenceMain_timmer")
	arg_21_0:initTimmer()
end

function MiniDefenceMain.onUpdate(arg_22_0)
	if MiniDefenceMain:isPaused() then
		return 
	end
	
	MiniDefenceMainManager:onUpdate()
	MiniDefenceEnemyManager:onUpdate()
	MiniDefenceFeverManager:onUpdate()
	MiniDefencePlayer:onUpdate()
end

function MiniDefenceMain.getLayer(arg_23_0)
	return arg_23_0.vars.wnd
end

function MiniDefenceMain.endGame(arg_24_0, arg_24_1)
	if var_0_1 then
		return 
	end
	
	if arg_24_0.vars.isEndGame then
		return 
	end
	
	local var_24_0 = arg_24_1 or ""
	
	arg_24_0.vars.isEndGame = true
	arg_24_0.vars.is_win = var_24_0 == "win"
	
	local var_24_1 = arg_24_0.vars.is_win and 1 or 0
	local var_24_2 = SubstoryManager:getInfo().id
	local var_24_3 = MiniDefenceMain:getEnterId()
	
	ConditionContentsManager:setIgnoreQuery(true)
	
	if var_24_1 == 1 then
		ConditionContentsManager:dispatch("arcade.clear", {
			enter_id = var_24_3
		})
	end
	
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_24_4 = ConditionContentsManager:getUpdateConditions() and json.encode()
	
	MiniDefencePlayer:pauseAnimation()
	MiniDefenceEnemyManager:forceRemoveAllUnit()
	query("substory_arcade_clear", {
		map_id = var_24_3,
		result = var_24_1,
		substory_id = var_24_2,
		update_conditions = var_24_4
	})
end

function MiniDefenceMain.res_clear_query(arg_25_0, arg_25_1)
	local var_25_0 = ConditionContentsManager:updateResponseConditionList(arg_25_1)
	
	if arg_25_1.substory_id and arg_25_1.map and arg_25_1.doc_dungeon_base then
		Account:setSubstoryDungeonBaseInfo(arg_25_1.substory_id, arg_25_1.map, arg_25_1.doc_dungeon_base)
	end
	
	MiniDefenceMainResult:show(arg_25_0.vars.is_win)
end

function MiniDefenceMain.isEndGame(arg_26_0)
	return arg_26_0.vars and arg_26_0.vars.isEndGame
end

function MiniDefenceMain.isPaused(arg_27_0)
	return PAUSED or var_0_0 or arg_27_0.vars and arg_27_0.vars.isEndGame
end

function MiniDefenceMain.setPause(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_2 == true then
		pause()
	elseif arg_28_2 == false then
		resume()
	end
	
	if var_0_0 == arg_28_1 then
		return 
	end
	
	var_0_0 = arg_28_1
	
	if arg_28_1 then
		MiniDefenceEnemyManager:pauseAllUnitAnimation()
		MiniDefenceFeverManager:pauseAllEffect()
		MiniDefencePlayer:pauseAnimation()
	else
		MiniDefenceEnemyManager:resumeAllUnitAnimation()
		MiniDefenceFeverManager:resumeAllEffect()
		MiniDefencePlayer:resumeAnimation()
	end
end

function MiniDefenceMain.getLeftTime(arg_29_0)
	return arg_29_0.vars.left_time
end

function MiniDefenceMain.initTimmer(arg_30_0)
	if not arg_30_0.vars or not arg_30_0.vars.countDown then
		return 
	end
	
	local var_30_0 = math.max(0, arg_30_0.vars.left_time) / 1000
	local var_30_1 = math.max(0, arg_30_0.vars.left_time) / 1000
	local var_30_2 = math.floor(var_30_1 / 60)
	local var_30_3 = var_30_1 - var_30_2 * 60
	local var_30_4 = string.format("%02d:%02d", var_30_2, var_30_3)
	
	if_set(arg_30_0.vars.countDown, nil, var_30_4)
end

function MiniDefenceMain.updateTimmer(arg_31_0)
	if not arg_31_0.vars or not arg_31_0.vars.countDown or MiniDefenceMain:isPaused() then
		return 
	end
	
	arg_31_0.vars.left_time = arg_31_0.vars.left_time - 1000
	
	local var_31_0 = math.max(0, arg_31_0.vars.left_time) / 1000
	local var_31_1 = math.max(0, arg_31_0.vars.left_time) / 1000
	local var_31_2 = math.floor(var_31_1 / 60)
	local var_31_3 = var_31_1 - var_31_2 * 60
	local var_31_4 = string.format("%02d:%02d", var_31_2, var_31_3)
	
	if_set(arg_31_0.vars.countDown, nil, var_31_4)
	
	if var_31_0 <= 0 then
		if MiniDefenceMain:isBossExistStage() and MiniDefenceEnemyManager:getBossCount() >= 1 then
			MiniDefenceMain:endGame("lose")
		else
			MiniDefenceMain:endGame("win")
		end
	end
end

function MiniDefenceMain.showBossSpawnEff(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	MiniDefenceMain:setPause(true)
	EffectManager:Play({
		extractNodes = true,
		z = 999999999,
		fn = "ui_boss_encounter.cfx",
		scale = 1,
		layer = arg_32_0.vars.wnd,
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT * 0.5,
		action = BattleAction
	})
	BattleAction:Add(SEQ(DELAY(2500), CALL(function()
		MiniDefenceMain:setPause(false)
		MiniDefenceMain:showBossUI()
	end)), arg_32_0.vars.wnd, "boss_eff")
end

function MiniDefenceMain.initBossUI(arg_34_0)
	local var_34_0 = arg_34_0.vars.ui_wnd:getChildByName("n_boss")
	local var_34_1 = arg_34_0.vars.ui_wnd:getChildByName("n_boss_in")
	
	if arg_34_0.vars.data.boss_id then
		local var_34_2, var_34_3, var_34_4, var_34_5 = DB("substory_arcade_3_monster", arg_34_0.vars.data.boss_id, {
			"id",
			"name_res",
			"face_res",
			"hp"
		})
		
		if var_34_2 then
			if var_34_3 then
				if_set_sprite(var_34_0, "n_name", var_34_3)
			end
			
			if var_34_4 then
				if_set_sprite(var_34_0, "n_pos_l", "face/" .. var_34_4)
			end
		end
	end
end

function MiniDefenceMain.showBossUI(arg_35_0)
	local var_35_0 = arg_35_0.vars.ui_wnd:getChildByName("n_boss")
	local var_35_1 = arg_35_0.vars.ui_wnd:getChildByName("n_boss_in")
	
	BattleAction:Add(SEQ(SHOW(true), MOVE_TO(300, var_35_1:getPositionX(), var_35_1:getPositionY())), var_35_0, "block")
end

function MiniDefenceMain.updateBossHPUI(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.ui_wnd) or not arg_36_1 or not arg_36_2 then
		return 
	end
	
	local var_36_0 = arg_36_0.vars.ui_wnd:getChildByName("n_boss"):getChildByName("n_hp_bar")
	local var_36_1 = arg_36_2 / arg_36_1
	local var_36_2 = math.max(var_36_1, 0)
	
	if_set_percent(var_36_0, nil, var_36_2)
end

function MiniDefenceMain.showFeverCutIn(arg_37_0)
	MiniDefenceMain:setPause(true)
	
	if not arg_37_0.vars or get_cocos_refid(arg_37_0.vars.cutin_wnd) then
		return 
	end
	
	arg_37_0.vars.cutin_wnd = load_dlg("game_aprilfool_battle_fever", true, "wnd")
	
	arg_37_0.vars.wnd:addChild(arg_37_0.vars.cutin_wnd)
	arg_37_0.vars.cutin_wnd:setVisible(false)
	
	local var_37_0
	local var_37_1, var_37_2 = DB("substory_arcade_2_character", arg_37_0.vars.data.character_id, {
		"fever_balloon1",
		"fever_balloon2"
	})
	
	if MiniDefenceFeverManager:getFeverModeLevel() == 2 then
		var_37_0 = var_37_1
	else
		var_37_0 = var_37_2
	end
	
	if var_37_0 then
		if_set(arg_37_0.vars.cutin_wnd, "txt_speech", T(var_37_0))
	end
	
	local var_37_3 = arg_37_0.vars.cutin_wnd:getChildByName("n_hero")
	local var_37_4 = arg_37_0.vars.cutin_wnd:getChildByName("n_speech_out")
	local var_37_5 = arg_37_0.vars.cutin_wnd:getChildByName("n_speech_in")
	local var_37_6 = var_37_3:getChildByName("n_pos_out")
	local var_37_7 = var_37_3:getChildByName("n_pos_in")
	local var_37_8 = arg_37_0.vars.cutin_wnd:getChildByName("n_monster")
	local var_37_9 = var_37_8:getChildByName("n_mob")
	local var_37_10 = var_37_8:getChildByName("n_out")
	local var_37_11 = var_37_8:getChildByName("n_in")
	
	if_set_sprite(var_37_6, nil, arg_37_0.vars.data.fever_player_res)
	if_set_sprite(var_37_10, "n_mob", arg_37_0.vars.data.fever_monster_res)
	
	local var_37_12 = 400
	local var_37_13 = 120
	local var_37_14 = 220
	local var_37_15 = 250 + var_37_12
	
	BattleAction:Add(SEQ(SHOW(true), DELAY(var_37_13 + var_37_15 + var_37_14 + 100), CALL(function()
		MiniDefenceMain:setPause(false)
	end), REMOVE()), arg_37_0.vars.cutin_wnd, "cut_in_resume")
	BattleAction:Add(SEQ(SCALE_TO(var_37_13, 1), DELAY(var_37_15)), var_37_3, "n_hero")
	BattleAction:Add(SEQ(OPACITY(var_37_13, 0, 1), DELAY(var_37_15), OPACITY(var_37_14, 1, 0)), var_37_3, "n_hero2")
	
	local var_37_16 = var_37_6:getPositionX()
	local var_37_17 = var_37_6:getPositionY()
	local var_37_18 = var_37_7:getPositionX()
	local var_37_19 = var_37_7:getPositionY()
	
	BattleAction:Add(SEQ(SCALE_TO(var_37_13, 1), DELAY(var_37_15)), var_37_6, "n_pos_out")
	BattleAction:Add(SEQ(OPACITY(var_37_13, 0, 1), DELAY(var_37_15), OPACITY(var_37_14, 1, 0)), var_37_6, "n_pos_out2")
	BattleAction:Add(SEQ(MOVE_TO(var_37_13, var_37_18, var_37_19), DELAY(var_37_15), MOVE_TO(var_37_14, var_37_16, var_37_17)), var_37_6, "n_pos_out3")
	
	local var_37_20 = var_37_4:getPositionX()
	local var_37_21 = var_37_4:getPositionY()
	local var_37_22 = var_37_5:getPositionX()
	local var_37_23 = var_37_5:getPositionY()
	local var_37_24 = 80
	
	BattleAction:Add(SEQ(DELAY(var_37_13 + var_37_24), OPACITY(var_37_13 / 3, 0, 1), DELAY(var_37_15 - var_37_13 / 2 - var_37_24), OPACITY(var_37_14, 1, 0)), var_37_4, "n_speech_out1")
	BattleAction:Add(SEQ(DELAY(var_37_13 + var_37_24), MOVE_TO(var_37_13 / 3, var_37_22, var_37_23), DELAY(var_37_15 - var_37_13 / 2 - var_37_24), MOVE_TO(var_37_14, var_37_20, var_37_21)), var_37_4, "n_speech_out2")
	
	local var_37_25 = var_37_15 - var_37_12
	local var_37_26 = var_37_11:getPositionX()
	local var_37_27 = var_37_11:getPositionY()
	local var_37_28 = var_37_10:getPositionY()
	local var_37_29 = var_37_10:getPositionX()
	local var_37_30 = 70
	local var_37_31 = 30
	
	BattleAction:Add(SEQ(DELAY(var_37_13), DELAY(var_37_25 - (var_37_30 + var_37_31)), SCALE_TO(var_37_30, 1.1), SCALE_TO(var_37_31, 1), DELAY(var_37_12)), var_37_9, "n_mob")
	
	local var_37_32 = var_37_25 + var_37_12
	
	BattleAction:Add(SEQ(OPACITY(var_37_13, 0, 1), DELAY(var_37_32), OPACITY(var_37_14, 1, 0)), var_37_8, "n_monster")
	BattleAction:Add(SEQ(OPACITY(var_37_13, 0, 1), DELAY(var_37_32), OPACITY(var_37_14, 1, 0)), var_37_10, "n_out")
	BattleAction:Add(SEQ(MOVE_TO(var_37_13, var_37_26, var_37_27), DELAY(var_37_32), MOVE_TO(var_37_14, var_37_29, var_37_28)), var_37_10, "n_out1")
	SoundEngine:play("event:/effect/ui_2022_foolsday_fever_eff")
end

function MiniDefenceMain.canSpawnBossMonsterTime(arg_39_0)
	if not arg_39_0.vars or not arg_39_0.vars.data or not arg_39_0.vars.data.boss_time then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.data.limit_time or 0
	local var_39_1 = arg_39_0.vars.left_time or 0
	local var_39_2 = arg_39_0.vars.data.boss_time or 0
	
	return tonumber(var_39_0) - tonumber(var_39_1) >= tonumber(var_39_2)
end

function MiniDefenceMain.getLayer(arg_40_0)
	return arg_40_0.vars.wnd
end

function MiniDefenceMain.onLeave(arg_41_0)
	arg_41_0.vars = nil
	
	Scheduler:removeByName("MiniDefenceMain")
	Scheduler:removeByName("MiniDefenceMain_timmer")
	Scheduler:removeByName("progressToZero")
	MiniDefenceFeverManager:onLeave()
	MiniDefenceEnemyManager:onLeave()
	MiniDefencePlayer:onLeave()
end

function MiniDefenceMainManager.init(arg_42_0)
	arg_42_0.vars = {}
	arg_42_0.vars.enemy_kill_count = 0
	arg_42_0.vars.ui_enemy_kill_count = 0
end

function MiniDefenceMainManager.resetKillCount(arg_43_0)
	arg_43_0.vars.enemy_kill_count = 0
	
	MiniDefenceMain:updateKillCount(arg_43_0.vars.ui_enemy_kill_count)
end

function MiniDefenceMainManager.getKillCount(arg_44_0)
	return arg_44_0.vars.enemy_kill_count
end

function MiniDefenceMainManager.incEnemyKillCount(arg_45_0)
	if MiniDefenceMain:isEndGame() then
		return 
	end
	
	arg_45_0.vars.ui_enemy_kill_count = arg_45_0.vars.ui_enemy_kill_count + 1
	
	MiniDefenceMain:updateKillCount(arg_45_0.vars.ui_enemy_kill_count)
	
	if MiniDefenceFeverManager:isLastFever() then
		return 
	end
	
	arg_45_0.vars.enemy_kill_count = arg_45_0.vars.enemy_kill_count + 1
	
	MiniDefenceFeverManager:checkFeverLevel()
end

function MiniDefenceMain.isBossExistStage(arg_46_0)
	return arg_46_0.vars.data.boss_id
end

function MiniDefenceMain.getBossId(arg_47_0)
	return arg_47_0.vars.data.boss_id
end

function MiniDefenceMainManager.onUpdate(arg_48_0)
end

function MiniDefenceFeverManager.init(arg_49_0, arg_49_1)
	arg_49_0.vars = {}
	arg_49_0.vars.fever_level = 1
	
	local var_49_0, var_49_1, var_49_2, var_49_3, var_49_4, var_49_5 = DB("substory_arcade_2_character", arg_49_1, {
		"fever_require_kill1",
		"fever_require_kill2",
		"fever_time",
		"attack_range1",
		"attack_range2",
		"attack_range3"
	})
	
	arg_49_0.vars.fever_count = {
		var_49_0,
		var_49_1
	}
	arg_49_0.vars.fever_2_time = var_49_2
	arg_49_0.vars.effects = {}
	arg_49_0.vars.touch_tick = 0
	arg_49_0.vars.fever_1_disable_tm = var_0_3
	arg_49_0.vars.fever_2_disable_tm = var_0_3
	arg_49_0.vars.hide_1_eff = false
	arg_49_0.vars.hide_2_eff = false
	arg_49_0.vars.fever_2_start_tm = nil
	arg_49_0.vars.att_range = {
		var_49_3,
		var_49_4,
		var_49_5
	}
	arg_49_0.vars.att = {
		var_0_4,
		var_0_5,
		var_0_6
	}
	
	local var_49_6 = MiniDefenceMain:getUIWnd()
	
	arg_49_0.vars.n_fever_step1 = var_49_6:getChildByName("n_fever_step1")
	arg_49_0.vars.n_fever_step2 = var_49_6:getChildByName("n_fever_step2")
	arg_49_0.vars.n_charge_bar1 = var_49_6:getChildByName("n_charge_bar1")
	arg_49_0.vars.n_charge_bar2 = var_49_6:getChildByName("n_charge_bar2")
	arg_49_0.vars.cur_progress = arg_49_0.vars.n_charge_bar1
	
	if_set_percent(arg_49_0.vars.n_charge_bar1, nil, 0)
	if_set_percent(arg_49_0.vars.n_charge_bar2, nil, 0)
end

function MiniDefenceFeverManager.checkFeverLevel(arg_50_0)
	local var_50_0 = MiniDefenceMainManager:getKillCount()
	local var_50_1 = false
	
	for iter_50_0 = 1, 2 do
		local var_50_2 = arg_50_0.vars.fever_count[iter_50_0]
		local var_50_3 = iter_50_0 + 1
		
		if var_50_2 <= var_50_0 and var_50_3 > arg_50_0.vars.fever_level then
			arg_50_0.vars.fever_level = var_50_3
			var_50_1 = true
		end
	end
	
	if arg_50_0.vars.fever_level == 1 then
		local var_50_4 = var_50_0 / arg_50_0.vars.fever_count[arg_50_0.vars.fever_level]
		
		if_set_percent(arg_50_0.vars.cur_progress, nil, var_50_4)
	elseif arg_50_0.vars.fever_level == 2 then
		local var_50_5 = (var_50_0 - arg_50_0.vars.fever_count[1]) / (arg_50_0.vars.fever_count[arg_50_0.vars.fever_level] - arg_50_0.vars.fever_count[1])
		
		if_set_percent(arg_50_0.vars.cur_progress, nil, var_50_5)
	elseif arg_50_0.vars.fever_level == 3 then
	end
	
	if var_50_1 then
		arg_50_0:checkFeverLevelAfter()
	end
end

function MiniDefenceFeverManager.progressToZero(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.n_charge_bar1) or not get_cocos_refid(arg_51_0.vars.n_charge_bar2) then
		return 
	end
	
	local var_51_0 = arg_51_0.vars.fever_2_time / 200
	local var_51_1 = math.floor(var_51_0)
	
	Scheduler:addGlobalInterval(var_51_1, arg_51_0.updateprogressToZero, arg_51_0):setName("progressToZero")
end

function MiniDefenceFeverManager.updateprogressToZero(arg_52_0)
	if not arg_52_0.vars or not get_cocos_refid(arg_52_0.vars.n_charge_bar1) or not get_cocos_refid(arg_52_0.vars.n_charge_bar2) then
		return 
	end
	
	if MiniDefenceMain:isPaused() then
		return 
	end
	
	local var_52_0 = arg_52_0.vars.n_charge_bar1:getPercent() - 1
	
	if var_52_0 <= 0 then
		arg_52_0.vars.n_charge_bar1:setPercent(0)
		arg_52_0.vars.n_charge_bar2:setPercent(0)
		Scheduler:removeByName("progressToZero")
		
		return 
	end
	
	local var_52_1 = math.max(var_52_0, 0)
	
	arg_52_0.vars.n_charge_bar1:setPercent(var_52_1)
	arg_52_0.vars.n_charge_bar2:setPercent(var_52_1)
end

function MiniDefenceFeverManager.checkFeverLevelAfter(arg_53_0)
	arg_53_0:removeAllEffect()
	
	if MiniDefenceMain:isEndGame() then
		return 
	end
	
	if arg_53_0.vars.fever_level == 1 then
		arg_53_0.vars.n_fever_step1:setVisible(false)
		
		arg_53_0.vars.cur_progress = arg_53_0.vars.n_charge_bar1
		
		MiniDefencePlayer:changeAttDely(1)
		MiniDefenceMain:updateBGM("normal")
		arg_53_0:updateUIEffect(1)
	elseif arg_53_0.vars.fever_level == 2 then
		arg_53_0.vars.n_fever_step1:setVisible(true)
		if_set_percent(arg_53_0.vars.cur_progress, nil, 1)
		
		arg_53_0.vars.cur_progress = arg_53_0.vars.n_charge_bar2
		
		local var_53_0 = 700
		
		MiniDefenceMain:showFeverCutIn()
		BattleAction:Add(SEQ(DELAY(var_53_0), CALL(function()
			arg_53_0:addEffect(arg_53_0.vars.fever_level)
		end)), MiniDefenceMain.vars.wnd, "fever_eff")
		MiniDefencePlayer:changeAttDely(MiniDefenceMain:getData().fever_speedup1)
		MiniDefenceMain:updateBGM("fever")
	elseif arg_53_0.vars.fever_level == 3 then
		arg_53_0.vars.n_fever_step2:setVisible(true)
		if_set_percent(arg_53_0.vars.cur_progress, nil, 1)
		
		local var_53_1 = 700
		
		MiniDefenceMain:showFeverCutIn()
		BattleAction:Add(SEQ(DELAY(var_53_1), CALL(function()
			arg_53_0.vars.fever_2_start_tm = MiniDefenceUtil:getCurTick()
			
			MiniDefenceMainManager:resetKillCount()
			arg_53_0:addEffect(arg_53_0.vars.fever_level)
			arg_53_0:updateUIEffect(3)
		end)), MiniDefenceMain.vars.wnd, "fever_eff")
		MiniDefencePlayer:changeAttDely(MiniDefenceMain:getData().fever_speedup2)
	end
	
	arg_53_0.vars.touch_tick = MiniDefenceUtil:getCurTick()
end

function MiniDefenceFeverManager.addEffect(arg_56_0, arg_56_1)
	if not arg_56_1 or arg_56_1 <= 1 then
		return 
	end
	
	local var_56_0
	
	if arg_56_1 == 2 then
		var_56_0 = "ui_2022_foolsday_fever_01_eff"
	else
		var_56_0 = "ui_2022_foolsday_fever_02_eff"
		
		arg_56_0:progressToZero()
	end
	
	local var_56_1 = DESIGN_WIDTH / 2
	local var_56_2 = DESIGN_HEIGHT / 2
	local var_56_3 = EffectManager:Play({
		pivot_z = 1,
		fn = var_56_0,
		layer = SceneManager:getDefaultLayer(),
		pivot_x = var_56_1,
		pivot_y = var_56_2
	})
	
	arg_56_0.vars.effects[arg_56_1] = var_56_3
end

function MiniDefenceFeverManager.updateUIEffect(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0.vars.n_fever_step2:getChildByName("n_eff")
	local var_57_1 = var_57_0:getChildByName("n_grow_scale")
	local var_57_2 = var_57_0:getChildByName("n_grow2")
	local var_57_3 = var_57_0:getChildByName("n_eff1")
	local var_57_4 = var_57_0:getChildByName("n_eff2")
	local var_57_5 = var_57_0:getChildByName("n_on2")
	local var_57_6 = var_57_0:getChildByName("n_twinkle")
	local var_57_7 = var_57_0:getChildByName("n_twinkle2")
	local var_57_8 = var_57_0:getChildByName("n_twinkle4")
	local var_57_9 = var_57_0:getChildByName("n_twinkle3")
	local var_57_10 = 600
	local var_57_11 = 400
	local var_57_12 = var_57_10 / 2
	local var_57_13 = 700
	local var_57_14 = 300
	local var_57_15 = var_57_13
	local var_57_16 = var_57_14 * 2 + 200
	
	if arg_57_1 == 1 then
		var_57_0:setOpacity(255)
		BattleAction:Add(SEQ(FADE_OUT(var_57_10), SHOW(false)), var_57_0, "n_eff_out")
		BattleAction:Add(SEQ(DELAY(var_57_10), SHOW(false)), arg_57_0.vars.n_fever_step2, "n_fever_step22")
	elseif arg_57_1 == 3 then
		var_57_0:setOpacity(0)
		BattleAction:Add(SEQ(FADE_IN(var_57_10)), var_57_0, "n_eff_in")
		BattleAction:Add(SEQ(SCALE(var_57_10 / 1.5, 1, 1.7), SCALE(var_57_10 / 2.5, 1.7, 1)), var_57_1, "n_grow_scale")
		BattleAction:Add(SEQ(DELAY(var_57_12), LOOP(SEQ(OPACITY(var_57_13, 0.6, 1), OPACITY(var_57_13, 1, 0.6)))), var_57_2, "n_grow2")
		BattleAction:Add(SEQ(DELAY(var_57_12), LOOP(SEQ(SCALE(var_57_15, 0.7, 1), SCALE(var_57_15, 1, 0.7)))), var_57_3, "n_eff1")
		BattleAction:Add(SEQ(DELAY(var_57_12), LOOP(SEQ(OPACITY(var_57_13, 0.4, 0.7), OPACITY(var_57_13, 0.7, 0.4)))), var_57_4, "n_eff2_1")
		BattleAction:Add(SEQ(DELAY(var_57_12), LOOP(SEQ(SCALE(var_57_15, 0.6, 1), SCALE(var_57_15, 1, 0.6)))), var_57_4, "n_eff2_2")
		BattleAction:Add(SEQ(DELAY(var_57_12), LOOP(SEQ(OPACITY(var_57_13, 1, 0.3), OPACITY(var_57_13, 0.3, 1)))), var_57_5, "n_on2")
		BattleAction:Add(SEQ(DELAY(var_57_12), LOOP(SEQ(OPACITY(var_57_14, 0, 1), DELAY(var_57_14), OPACITY(var_57_14, 1, 0)))), var_57_6, "n_twinkle")
		BattleAction:Add(SEQ(DELAY(var_57_12 * 2), LOOP(SEQ(OPACITY(var_57_14, 0, 1), DELAY(var_57_14), OPACITY(var_57_14, 1, 0)))), var_57_7, "n_twinkle2")
		BattleAction:Add(SEQ(DELAY(var_57_12 * 2), LOOP(SEQ(OPACITY(var_57_14, 0, 1), DELAY(var_57_14), OPACITY(var_57_14, 1, 0)))), var_57_8, "n_twinkle4")
		BattleAction:Add(SEQ(DELAY(var_57_16), LOOP(SEQ(OPACITY(var_57_14, 0, 0.6), DELAY(var_57_14), OPACITY(var_57_14, 0.6, 0)))), var_57_9, "n_twinkle3")
	end
end

function MiniDefenceFeverManager.resumeAllEffect(arg_58_0)
	if not arg_58_0.vars or table.empty(arg_58_0.vars.effects) then
		return 
	end
	
	for iter_58_0, iter_58_1 in pairs(arg_58_0.vars.effects) do
		if get_cocos_refid(iter_58_1) then
			iter_58_1:setTimeScale(1)
			
			if iter_58_1.sd and get_cocos_refid(iter_58_1.sd) and iter_58_1.sd.setVolume then
				iter_58_1.sd:setVolume(1)
			end
		end
	end
end

function MiniDefenceFeverManager.pauseAllEffect(arg_59_0)
	if not arg_59_0.vars or table.empty(arg_59_0.vars.effects) then
		return 
	end
	
	for iter_59_0, iter_59_1 in pairs(arg_59_0.vars.effects) do
		if get_cocos_refid(iter_59_1) then
			iter_59_1:setTimeScale(0)
			
			if iter_59_1.sd and get_cocos_refid(iter_59_1.sd) and iter_59_1.sd.setVolume then
				iter_59_1.sd:setVolume(0)
			end
		end
	end
end

function MiniDefenceFeverManager.isLastFever(arg_60_0)
	return arg_60_0.vars.fever_level == 3
end

function MiniDefenceFeverManager.updateTouchTick(arg_61_0)
	if not arg_61_0.vars then
		return 
	end
	
	arg_61_0.vars.touch_tick = MiniDefenceUtil:getCurTick()
end

function MiniDefenceFeverManager.onUpdate(arg_62_0)
	if not arg_62_0.vars or arg_62_0.vars.fever_level == 1 then
		return 
	end
	
	local var_62_0 = arg_62_0.vars.effects[arg_62_0.vars.fever_level]
	
	if arg_62_0.vars.fever_level ~= 3 and not get_cocos_refid(var_62_0) then
		return 
	end
	
	local var_62_1 = MiniDefenceUtil:getCurTick()
	
	if arg_62_0.vars.fever_level == 2 then
		local var_62_2 = var_62_1 - arg_62_0.vars.touch_tick >= arg_62_0.vars.fever_1_disable_tm
		
		if not arg_62_0.vars.hide_1_eff and var_62_2 then
			arg_62_0.vars.hide_1_eff = true
			
			BattleAction:Add(FADE_OUT(300), var_62_0, "fever_1_fade_out")
		elseif arg_62_0.vars.hide_1_eff and not var_62_2 then
			BattleAction:Remove("fever_1_fade_out")
			var_62_0:setOpacity(255)
			var_62_0:setVisible(true)
			
			arg_62_0.vars.hide_1_eff = false
		end
	elseif arg_62_0.vars.fever_level == 3 then
		local var_62_3 = var_62_1 - arg_62_0.vars.touch_tick >= arg_62_0.vars.fever_2_disable_tm
		
		if not arg_62_0.vars.hide_2_eff and var_62_3 then
			arg_62_0.vars.hide_2_eff = true
			
			BattleAction:Add(FADE_OUT(300), var_62_0, "fever_2_fade_out")
		elseif arg_62_0.vars.hide_2_eff and not var_62_3 then
			BattleAction:Remove("fever_2_fade_out")
			var_62_0:setOpacity(255)
			var_62_0:setVisible(true)
			
			arg_62_0.vars.hide_2_eff = false
		end
		
		if arg_62_0.vars.fever_2_start_tm and var_62_1 - arg_62_0.vars.fever_2_start_tm >= arg_62_0.vars.fever_2_time then
			arg_62_0.vars.fever_level = 1
			
			arg_62_0:checkFeverLevelAfter()
		end
	end
	
	if false then
	end
end

function MiniDefenceFeverManager.removeAllEffect(arg_63_0)
	if not arg_63_0.vars or table.empty(arg_63_0.vars.effects) then
		return 
	end
	
	for iter_63_0, iter_63_1 in pairs(arg_63_0.vars.effects) do
		if get_cocos_refid(iter_63_1) then
			if iter_63_1.sd and iter_63_1.sd.stop then
				iter_63_1.sd:stop()
			end
			
			iter_63_1:removeFromParent()
		end
	end
	
	arg_63_0.vars.effects = {}
end

function MiniDefenceFeverManager.getFeverModeLevel(arg_64_0)
	return arg_64_0.vars.fever_level
end

function MiniDefenceFeverManager.isFeverModeOn(arg_65_0)
	return arg_65_0.vars.fever_level >= 2
end

function MiniDefenceFeverManager.onLeave(arg_66_0)
	arg_66_0.vars = nil
end

function MiniDefenceEnemyManager.init(arg_67_0)
	arg_67_0.vars = {}
	arg_67_0.vars.mob_info = {}
	arg_67_0.vars.already_spawn_boss = false
	arg_67_0.vars.boss_count = 0
	
	local var_67_0 = MiniDefenceMain:getData()
	local var_67_1 = MiniDefenceUtil:getCurTick()
	local var_67_2 = MiniDefenceMain:getBossId()
	
	for iter_67_0 = 1, 3 do
		local var_67_3 = var_67_0["monster_id" .. iter_67_0]
		local var_67_4 = var_67_0["spawn_interval" .. iter_67_0]
		
		if var_67_3 then
			local var_67_5 = var_67_2 == var_67_3
			local var_67_6 = var_0_9
			
			if var_67_5 then
				local var_67_7 = 1
			end
			
			arg_67_0.vars.mob_info[var_67_3] = {
				cur_enemy_count = 0,
				id = var_67_3,
				spawn_interval = var_67_4,
				spawn_timmer = var_67_1,
				max_enemy_count = var_0_9,
				is_boss = var_67_5
			}
		end
	end
	
	if var_67_0.boss_id then
		arg_67_0.vars.mob_info[var_67_0.boss_id] = {
			is_boss = true,
			cur_enemy_count = 0,
			spawn_interval = 0,
			max_enemy_count = 1,
			id = var_67_0.boss_id,
			spawn_timmer = var_67_1
		}
	end
	
	arg_67_0.vars.units = {}
	arg_67_0.vars.spawn_pos = {
		{
			var_0_12,
			170,
			200
		},
		{
			var_0_12,
			240,
			100
		},
		{
			var_0_12,
			290,
			70
		},
		{
			var_0_12,
			340,
			50
		}
	}
end

function MiniDefenceEnemyManager.spawnMonster(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_1 or MiniDefenceMain:isEndGame() then
		return 
	end
	
	arg_68_0:incMonsterCount(arg_68_1)
	
	local var_68_0 = table.count(arg_68_0.vars.spawn_pos)
	local var_68_1 = math.random(1, var_68_0)
	
	if arg_68_0.vars.prev_pos_num and arg_68_0.vars.prev_pos_num == var_68_1 then
		if var_68_1 == var_68_0 then
			var_68_1 = var_68_1 - 1
		else
			var_68_1 = var_68_1 + 1
		end
	end
	
	arg_68_0.vars.prev_pos_num = var_68_1
	
	local var_68_2 = arg_68_0.vars.spawn_pos[var_68_1]
	
	if arg_68_2 then
		var_68_2[1] = var_0_12
		var_68_2[2] = var_0_8
		var_68_2[3] = 200
	end
	
	local var_68_3 = MiniDefenceEnemyUnit:create(arg_68_1, var_68_2, arg_68_2)
	
	if var_68_3 then
		table.insert(arg_68_0.vars.units, var_68_3)
	end
end

function MiniDefenceEnemyManager.setSpawnTimmer(arg_69_0, arg_69_1, arg_69_2)
	arg_69_0.vars.mob_info[arg_69_1].spawn_timmer = arg_69_2
end

function MiniDefenceEnemyManager.getSpawnTimmer(arg_70_0, arg_70_1)
	return arg_70_0.vars.mob_info[arg_70_1].spawn_timmer
end

function MiniDefenceEnemyManager.getSpawnInterval(arg_71_0, arg_71_1)
	return arg_71_0.vars.mob_info[arg_71_1].spawn_interval
end

function MiniDefenceEnemyManager.isMaxMonsterCount(arg_72_0, arg_72_1)
	if not arg_72_1 then
		return 
	end
	
	return arg_72_0.vars.mob_info[arg_72_1].cur_enemy_count == arg_72_0.vars.mob_info[arg_72_1].max_enemy_count
end

function MiniDefenceEnemyManager.incBossCount(arg_73_0)
	arg_73_0.vars.boss_count = arg_73_0.vars.boss_count + 1
end

function MiniDefenceEnemyManager.decBossCount(arg_74_0)
	arg_74_0.vars.boss_count = arg_74_0.vars.boss_count - 1
end

function MiniDefenceEnemyManager.getBossCount(arg_75_0)
	return arg_75_0.vars.boss_count or 0
end

function MiniDefenceEnemyManager.incMonsterCount(arg_76_0, arg_76_1)
	arg_76_0.vars.mob_info[arg_76_1].cur_enemy_count = arg_76_0.vars.mob_info[arg_76_1].cur_enemy_count + 1
end

function MiniDefenceEnemyManager.decMonsterCount(arg_77_0, arg_77_1)
	arg_77_0.vars.mob_info[arg_77_1].cur_enemy_count = arg_77_0.vars.mob_info[arg_77_1].cur_enemy_count - 1
end

function MiniDefenceEnemyManager.forceRemoveAllUnit(arg_78_0)
	local var_78_0 = {}
	
	for iter_78_0, iter_78_1 in pairs(arg_78_0.vars.units) do
		iter_78_1:onHit(99999999, true)
		
		if iter_78_1:isDead() then
			table.insert(var_78_0, iter_78_0)
		end
	end
	
	for iter_78_2 = #var_78_0, 1, -1 do
		table.remove(arg_78_0.vars.units, var_78_0[iter_78_2])
	end
end

function MiniDefenceEnemyManager.removeDeadUnit(arg_79_0)
	local var_79_0 = {}
	
	for iter_79_0, iter_79_1 in pairs(arg_79_0.vars.units) do
		if iter_79_1:isDead() then
			table.insert(var_79_0, iter_79_0)
		end
	end
	
	for iter_79_2 = #var_79_0, 1, -1 do
		table.remove(arg_79_0.vars.units, var_79_0[iter_79_2])
	end
end

function MiniDefenceEnemyManager.canSpawnBossMonster(arg_80_0)
	return MiniDefenceMain:canSpawnBossMonsterTime() and not arg_80_0.vars.already_spawn_boss
end

function MiniDefenceEnemyManager.onUpdate(arg_81_0)
	if not arg_81_0.vars then
		return 
	end
	
	local var_81_0 = MiniDefenceUtil:getCurTick()
	
	for iter_81_0, iter_81_1 in pairs(arg_81_0.vars.mob_info) do
		local var_81_1 = arg_81_0:getSpawnTimmer(iter_81_1.id)
		local var_81_2 = arg_81_0:getSpawnInterval(iter_81_1.id)
		local var_81_3 = iter_81_1.is_boss
		
		if var_81_3 and not arg_81_0:isMaxMonsterCount(iter_81_1.id) and arg_81_0:canSpawnBossMonster() then
			arg_81_0:spawnMonster(iter_81_1.id, true)
			arg_81_0:setSpawnTimmer(iter_81_1.id, var_81_0)
			
			arg_81_0.vars.already_spawn_boss = true
			
			arg_81_0:incBossCount()
			MiniDefenceMain:showBossSpawnEff()
		elseif not var_81_3 and var_81_2 <= var_81_0 - var_81_1 and not arg_81_0:isMaxMonsterCount(iter_81_1.id) then
			arg_81_0:spawnMonster(iter_81_1.id)
			arg_81_0:setSpawnTimmer(iter_81_1.id, var_81_0)
		end
	end
	
	arg_81_0:removeDeadUnit()
	
	for iter_81_2, iter_81_3 in pairs(arg_81_0.vars.units) do
		if not iter_81_3:isDead() then
			iter_81_3:onUpdate()
		end
	end
end

function MiniDefenceEnemyManager.calcHitUnits(arg_82_0, arg_82_1, arg_82_2)
	if not arg_82_1 or not arg_82_2 then
		return 
	end
	
	for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.units) do
		if not iter_82_1:isDead() and iter_82_1:canHit(arg_82_2) then
			iter_82_1:onHit(arg_82_1)
		end
	end
end

function MiniDefenceEnemyManager.pauseAllUnitAnimation(arg_83_0)
	for iter_83_0, iter_83_1 in pairs(arg_83_0.vars.units) do
		if not iter_83_1:isDead() then
			iter_83_1:pauseAnimation()
		end
	end
end

function MiniDefenceEnemyManager.resumeAllUnitAnimation(arg_84_0)
	for iter_84_0, iter_84_1 in pairs(arg_84_0.vars.units) do
		if not iter_84_1:isDead() then
			iter_84_1:resumeAnimation()
		end
	end
end

function MiniDefenceEnemyManager.onLeave(arg_85_0)
	arg_85_0.vars = nil
end

function MiniDefenceEnemyUnit.create(arg_86_0, arg_86_1, arg_86_2, arg_86_3)
	if not arg_86_1 or not arg_86_2 then
		return 
	end
	
	local var_86_0 = {}
	
	return (arg_86_0:init(var_86_0, arg_86_1, arg_86_2, arg_86_3))
end

function MiniDefenceEnemyUnit.init(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
	arg_87_1.vars = {}
	arg_87_1.vars.id = arg_87_2
	arg_87_1.vars.isDead = false
	arg_87_1.vars.isArrived = false
	
	local var_87_0, var_87_1, var_87_2, var_87_3, var_87_4, var_87_5, var_87_6, var_87_7, var_87_8 = DB("substory_arcade_3_monster", arg_87_2, {
		"id",
		"model_id",
		"hp",
		"scale",
		"attack_range",
		"knockback_hit_count",
		"knockback_distance",
		"recovery_time",
		"move_speed"
	})
	
	arg_87_1.vars.hp = var_87_2
	arg_87_1.vars.max_hp = var_87_2
	arg_87_1.vars.att = var_0_10
	arg_87_1.vars.att_delay = var_0_11
	arg_87_1.vars.knockback_dist = var_87_6
	arg_87_1.vars.recovery_time = var_87_7
	arg_87_1.vars.hit_count = var_87_5
	arg_87_1.vars.move_speed = var_87_8
	arg_87_1.vars.attack_range = var_87_4
	arg_87_1.vars.is_boss = arg_87_4
	arg_87_1.vars.local_z = arg_87_3[3]
	
	local var_87_9 = cc.Node:create()
	local var_87_10
	local var_87_11
	local var_87_12
	
	if var_87_1 == "fire" or var_87_1 == "wind" or var_87_1 == "light" then
		var_87_10 = var_87_1
		var_87_1 = "sd_ma_skull"
	end
	
	local var_87_13 = CACHE:getModel(var_87_1, var_87_10, nil, var_87_11, var_87_12)
	
	if var_87_9 and var_87_13 then
		var_87_13:setScale(var_87_3)
		var_87_13:setScaleX(var_87_3 * -1)
		var_87_13:setTimeScale(1.2)
		var_87_9:addChild(var_87_13)
		
		arg_87_1.vars.model_data = var_87_13
	end
	
	MiniDefenceMain:getLayer():addChild(var_87_9)
	var_87_9:setPosition(arg_87_3[1], arg_87_3[2])
	var_87_9:setLocalZOrder(arg_87_3[3])
	
	arg_87_1.vars.model = var_87_9
	arg_87_1.vars.state = "spawn"
	arg_87_1.vars.cur_att_delay = nil
	arg_87_1.vars.cur_hit_count = 0
	
	if not arg_87_4 then
		arg_87_1.vars.attack_range = var_87_4 + math.random(0, -40)
	end
	
	copy_functions(MiniDefenceEnemyUnit, arg_87_1)
	
	return arg_87_1
end

function MiniDefenceEnemyUnit.isBoss(arg_88_0)
	return arg_88_0.vars and arg_88_0.vars.is_boss
end

function MiniDefenceEnemyUnit.getAttaceRange(arg_89_0)
	return arg_89_0.vars.attack_range
end

function MiniDefenceEnemyUnit.onUpdate(arg_90_0)
	if not arg_90_0.vars or not get_cocos_refid(arg_90_0.vars.model) then
		return 
	end
	
	if arg_90_0:isDead() or arg_90_0:isKnockBack() then
		return 
	end
	
	local var_90_0 = false
	
	if arg_90_0:getAttaceRange() >= arg_90_0:getPosX() then
		if not arg_90_0:isArrived() then
			arg_90_0.vars.model:setLocalZOrder(arg_90_0.vars.local_z)
			
			var_90_0 = true
		end
		
		arg_90_0:setArrived(true)
	else
		arg_90_0:setArrived(false)
	end
	
	if arg_90_0:isArrived() then
		arg_90_0:onArrived(var_90_0)
	else
		arg_90_0:onMove()
	end
end

function MiniDefenceEnemyUnit.setArrived(arg_91_0, arg_91_1)
	arg_91_0.vars.isArrived = arg_91_1
end

function MiniDefenceEnemyUnit.isArrived(arg_92_0)
	return arg_92_0.vars.isArrived
end

function MiniDefenceEnemyUnit.setPosX(arg_93_0, arg_93_1)
	arg_93_0.vars.model:setPositionX(arg_93_1)
end

function MiniDefenceEnemyUnit.getPosY(arg_94_0)
	return arg_94_0.vars.model:getPositionY()
end

function MiniDefenceEnemyUnit.getPosX(arg_95_0)
	return arg_95_0.vars.model:getPositionX()
end

function MiniDefenceEnemyUnit.getSpeed(arg_96_0)
	return arg_96_0.vars.move_speed
end

function MiniDefenceEnemyUnit.checkDead(arg_97_0)
	if arg_97_0.vars.hp <= 0 then
		arg_97_0.vars.isDead = true
	end
end

function MiniDefenceEnemyUnit.onMove(arg_98_0)
	local var_98_0 = MiniDefenceMain:getData()
	local var_98_1 = arg_98_0:getSpeed()
	
	if MiniDefenceFeverManager:isFeverModeOn() then
		local var_98_2 = MiniDefenceFeverManager:getFeverModeLevel()
		
		if var_98_2 == 2 then
			var_98_1 = var_98_1 * var_98_0.fever_speedup1
		elseif var_98_2 == 3 then
			var_98_1 = var_98_1 * var_98_0.fever_speedup2
		end
	end
	
	local var_98_3 = arg_98_0:getPosX()
	
	arg_98_0:setPosX(var_98_3 - var_98_1)
	arg_98_0:setAnimation(0, "run", true)
	arg_98_0:setState("move")
end

function MiniDefenceEnemyUnit.onKnockBack(arg_99_0)
	if DEFENCE_BOSS_DEBUG and arg_99_0:isBoss() then
		Log.e("보스넉백@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
	end
	
	local var_99_0 = math.random(1, 50)
	local var_99_1 = arg_99_0:getPosX() + arg_99_0.vars.knockback_dist + var_99_0
	local var_99_2 = arg_99_0.vars.recovery_time
	
	if arg_99_0:isDead() then
		var_99_2 = 0
	end
	
	arg_99_0:setAnimation(0, "knock_down", true)
	BattleAction:Add(SEQ(MOVE_TO(var_0_2, var_99_1, arg_99_0:getPosY()), DELAY(var_99_2), CALL(function()
		if arg_99_0:isDead() then
			arg_99_0:onDead()
		else
			arg_99_0:resetHitCount()
			arg_99_0:setState("move")
			arg_99_0:setArrived(false)
		end
	end)), arg_99_0.vars.model, "att")
end

function MiniDefenceEnemyUnit.onArrived(arg_101_0, arg_101_1)
	local var_101_0 = MiniDefenceUtil:getCurTick()
	
	if arg_101_1 then
		arg_101_0:onAttack()
	end
	
	if not arg_101_0.vars.cur_att_delay then
		arg_101_0.vars.cur_att_delay = var_101_0
	end
	
	if var_101_0 - arg_101_0.vars.cur_att_delay >= arg_101_0.vars.att_delay and not arg_101_0:isAttacking() then
		arg_101_0:onAttack()
	end
end

function MiniDefenceEnemyUnit.addHitCount(arg_102_0)
	arg_102_0.vars.cur_hit_count = arg_102_0.vars.cur_hit_count + 1
	
	if DEFENCE_BOSS_DEBUG and arg_102_0:isBoss() then
		Log.e("히트", arg_102_0.vars.cur_hit_count)
	end
end

function MiniDefenceEnemyUnit.resetHitCount(arg_103_0)
	arg_103_0.vars.cur_hit_count = 0
end

function MiniDefenceEnemyUnit.needKnockBack(arg_104_0)
	return arg_104_0.vars.cur_hit_count == arg_104_0.vars.hit_count
end

function MiniDefenceEnemyUnit.setState(arg_105_0, arg_105_1)
	arg_105_0.vars.state = arg_105_1
end

function MiniDefenceEnemyUnit.canHit(arg_106_0, arg_106_1)
	if not arg_106_1 then
		return 
	end
	
	return arg_106_1 >= arg_106_0:getPosX()
end

function MiniDefenceEnemyUnit.onHit(arg_107_0, arg_107_1, arg_107_2)
	if arg_107_2 then
		arg_107_0:_onHit(arg_107_1)
		
		return 
	end
	
	if arg_107_0:isKnockBack() or not arg_107_1 then
		return 
	end
	
	arg_107_0:_onHit(arg_107_1)
end

function MiniDefenceEnemyUnit._onHit(arg_108_0, arg_108_1)
	arg_108_0.vars.hp = arg_108_0.vars.hp - arg_108_1
	
	if arg_108_0:isBoss() then
		MiniDefenceMain:updateBossHPUI(arg_108_0.vars.max_hp, arg_108_0.vars.hp)
	end
	
	if not get_cocos_refid(arg_108_0.vars.hit_eff) then
		local var_108_0 = 0
		
		if arg_108_0:isBoss() then
			var_108_0 = 70
		end
		
		arg_108_0.vars.hit_eff = EffectManager:Play({
			x = 0,
			fn = "ui_2022_foolsday_hit_eff.cfx",
			layer = arg_108_0.vars.model,
			y = var_108_0
		})
	end
	
	arg_108_0:addHitCount()
	arg_108_0:checkDead()
	
	if arg_108_0:isDead() then
		arg_108_0:setState("knockback")
	elseif arg_108_0:needKnockBack() then
		arg_108_0:setState("knockback")
		
		if DEFENCE_BOSS_DEBUG and arg_108_0:isBoss() then
			Log.e("bossHit: ", arg_108_0.vars.cur_hit_count, arg_108_0.vars.hit_count)
		end
	else
		return 
	end
	
	arg_108_0:onKnockBack()
end

function MiniDefenceEnemyUnit.isKnockBack(arg_109_0)
	return arg_109_0.vars.state == "knockback"
end

function MiniDefenceEnemyUnit.isAttacking(arg_110_0)
	return arg_110_0.vars.state == "attack"
end

function MiniDefenceEnemyUnit.getDamage(arg_111_0)
	return arg_111_0.vars.att
end

function MiniDefenceEnemyUnit.onAttack(arg_112_0)
	local var_112_0 = 1000
	local var_112_1 = MiniDefenceUtil:getCurTick()
	
	arg_112_0:setState("attack")
	arg_112_0:setAnimation(0, "skill1", false)
	
	if arg_112_0:isBoss() then
		SoundEngine:play("event:/effect/ui_2022_foolsday_attack_03_eff")
	else
		SoundEngine:play("event:/effect/ui_2022_foolsday_attack_02_eff")
	end
	
	MiniDefencePlayer:onHit(arg_112_0:getDamage())
	BattleAction:Add(SEQ(DELAY(var_112_0), CALL(function()
		arg_112_0:setAnimation(0, "idle", true)
		
		arg_112_0.vars.cur_att_delay = var_112_1
		
		arg_112_0:setState("idle")
	end)), arg_112_0.vars.model, "att")
end

function MiniDefenceEnemyUnit.resumeAnimation(arg_114_0)
	if not arg_114_0.vars or not arg_114_0.vars.model_data then
		return 
	end
	
	arg_114_0.vars.model_data:resumeAnimation()
end

function MiniDefenceEnemyUnit.pauseAnimation(arg_115_0)
	if not arg_115_0.vars or not arg_115_0.vars.model_data then
		return 
	end
	
	local var_115_0 = arg_115_0.vars.model_data
	
	if var_115_0:getCurrent() then
		var_115_0:pauseAnimation()
	end
end

function MiniDefenceEnemyUnit.setAnimation(arg_116_0, arg_116_1, arg_116_2, arg_116_3)
	local var_116_0 = arg_116_0.vars.model_data
	local var_116_1 = arg_116_0.vars.model
	
	if var_116_0 and var_116_0.setAnimation then
		var_116_0:setAnimation(arg_116_1, arg_116_2, arg_116_3)
	end
end

function MiniDefenceEnemyUnit.isDead(arg_117_0)
	return not arg_117_0.vars or arg_117_0.vars.isDead
end

function MiniDefenceEnemyUnit.onDead(arg_118_0)
	if not arg_118_0.vars or not get_cocos_refid(arg_118_0.vars.model) then
		return 
	end
	
	MiniDefenceMainManager:incEnemyKillCount()
	
	if arg_118_0:isBoss() then
		MiniDefenceEnemyManager:decBossCount()
		MiniDefenceMain:endGame("win")
	end
	
	local var_118_0 = 500
	
	BattleAction:Add(SEQ(CALL(function()
		arg_118_0:setState("die")
		EffectManager:Play({
			x = 0,
			y = 0,
			fn = "death_eff_01.cfx",
			layer = arg_118_0.vars.model_data
		})
	end), FADE_OUT(500), CALL(function()
		MiniDefenceEnemyManager:decMonsterCount(arg_118_0.vars.id)
		arg_118_0.vars.model:removeFromParent()
		
		arg_118_0.vars = nil
	end)), arg_118_0.vars.model_data, "die")
end

function MiniDefencePlayer.init(arg_121_0, arg_121_1)
	arg_121_0.vars = {}
	arg_121_0.vars.id = arg_121_1
	arg_121_0.vars.state = "idle"
	
	local var_121_0 = DBT("substory_arcade_2_character", arg_121_0.vars.id, {
		"id",
		"name_res",
		"model_id",
		"face_id",
		"hp",
		"scale",
		"invincible_time",
		"attack_range1",
		"attack_range2",
		"attack_range3",
		"fever_require_kill1",
		"fever_require_kill2",
		"fever_time",
		"fever_balloon1",
		"fever_face1",
		"fever_balloon2",
		"fever_face2"
	})
	
	arg_121_0.vars.att_range = {
		var_121_0.attack_range1,
		var_121_0.attack_range2,
		var_121_0.attack_range3
	}
	arg_121_0.vars.att = {
		var_0_4,
		var_0_5,
		var_0_6
	}
	arg_121_0.vars.hp = var_121_0.hp
	arg_121_0.vars.att_delay = var_0_7
	arg_121_0.vars.invisible_time = var_121_0.invincible_time
	arg_121_0.vars.data = var_121_0
	arg_121_0.vars.can_attack = true
	
	arg_121_0:initModel(var_121_0.model_id, tonumber(var_121_0.scale))
	arg_121_0:initUI()
end

function MiniDefencePlayer.initModel(arg_122_0, arg_122_1, arg_122_2)
	local var_122_0 = arg_122_2 or 1
	local var_122_1 = cc.Node:create()
	local var_122_2
	local var_122_3
	local var_122_4
	local var_122_5 = arg_122_1 or "sd_su_clarisa"
	local var_122_6 = CACHE:getModel(var_122_5, var_122_2, nil, var_122_3, var_122_4)
	
	if var_122_1 and var_122_6 then
		var_122_6:setScale(var_122_0)
		var_122_6:setTimeScale(1.2)
		var_122_1:addChild(var_122_6)
		var_122_1:setLocalZOrder(200)
		
		arg_122_0.vars.model_data = var_122_6
	end
	
	MiniDefenceMain:getLayer():addChild(var_122_1)
	var_122_1:setPosition(100, var_0_8)
	
	arg_122_0.vars.model = var_122_1
end

function MiniDefencePlayer.initUI(arg_123_0)
	if not arg_123_0.vars.data.name_res then
		return 
	end
	
	local var_123_0 = MiniDefenceMain:getUIWnd():getChildByName("n_diene")
	
	if get_cocos_refid(var_123_0) then
		if_set_sprite(var_123_0, "n_name", arg_123_0.vars.data.name_res)
	end
end

function MiniDefencePlayer.onUpdate(arg_124_0)
	if not arg_124_0.vars then
		return 
	end
	
	if MiniDefenceMain:isPaused() or MiniDefenceMain:isEndGame() or arg_124_0:isDead() then
		return 
	end
	
	local var_124_0 = MiniDefenceUtil:getCurTick()
	
	if not arg_124_0:isIdleState() and arg_124_0.vars.can_attack and arg_124_0.vars.touch_tick and var_124_0 - arg_124_0.vars.touch_tick >= 400 then
		arg_124_0:setState("idle")
		arg_124_0:setAnimation(0, "idle", true)
		
		if get_cocos_refid(arg_124_0.vars.hit_eff) then
			arg_124_0.vars.hit_eff:removeFromParent()
			
			arg_124_0.vars.hit_eff = nil
		end
	elseif arg_124_0:isAttackState() and MiniDefenceFeverManager:getFeverModeLevel() == 1 and not get_cocos_refid(arg_124_0.vars.hit_eff) then
		arg_124_0.vars.hit_eff = EffectManager:Play({
			x = 0,
			y = 0,
			fn = "ui_2022_foolsday_attack_01_eff",
			layer = arg_124_0.vars.model
		})
		
		arg_124_0.vars.hit_eff:setTimeScale(1.7)
	end
end

function MiniDefencePlayer.setState(arg_125_0, arg_125_1)
	arg_125_0.vars.state = arg_125_1
end

function MiniDefencePlayer.isIdleState(arg_126_0)
	return arg_126_0.vars.state == "idle"
end

function MiniDefencePlayer.isAttackState(arg_127_0)
	return arg_127_0.vars.state == "attack"
end

function MiniDefencePlayer.isHitState(arg_128_0)
	return arg_128_0.vars.state == "hit"
end

function MiniDefencePlayer.isDead(arg_129_0)
	return arg_129_0.vars.hp <= 0
end

function MiniDefencePlayer.onHit(arg_130_0, arg_130_1)
	if not arg_130_1 or arg_130_0:isHitState() then
		return 
	end
	
	if arg_130_0.vars.invisible_mode then
		return 
	end
	
	if not arg_130_0.vars.invisible_mode then
		arg_130_0.vars.hp = arg_130_0.vars.hp - arg_130_1
		
		MiniDefenceMain:updatePlayerHPUI(arg_130_0.vars.data.hp, arg_130_0.vars.hp)
	end
	
	if arg_130_0:isDead() then
		arg_130_0:onDead()
		
		return 
	end
	
	arg_130_0:setState("hit")
	
	if not arg_130_0.vars.invisible_mode then
		arg_130_0:setAnimation(0, "knock_down", true)
	end
	
	if not get_cocos_refid(arg_130_0.vars.inf_effect) then
		local var_130_0 = tonumber(arg_130_0.vars.data.scale) - 0.85
		
		arg_130_0.vars.inf_effect = EffectManager:Play({
			fn = "stse_invincible.cfx",
			y = 0,
			x = 0,
			layer = arg_130_0.vars.model,
			scale = var_130_0
		})
	end
	
	arg_130_0.vars.invisible_mode = true
	
	BattleAction:Add(LOOP(SEQ(DELAY(25), RLOG(FADE_OUT(50)), LOG(FADE_IN(50)))), arg_130_0.vars.model_data, "blink_user")
	BattleAction:Add(SEQ(DELAY(arg_130_0.vars.invisible_time), CALL(function()
		arg_130_0.vars.invisible_mode = false
		
		if not arg_130_0:isAttackState() then
			arg_130_0:setState("idle")
			arg_130_0:setAnimation(0, "idle", true)
		end
		
		BattleAction:Remove("blink_user")
		
		if get_cocos_refid(arg_130_0.vars.inf_effect) then
			arg_130_0.vars.inf_effect:removeFromParent()
		end
	end)), arg_130_0.vars.model, "idle")
end

function MiniDefencePlayer.updateTouchTick(arg_132_0)
	if not arg_132_0.vars then
		return 
	end
	
	arg_132_0.vars.touch_tick = MiniDefenceUtil:getCurTick()
end

function MiniDefencePlayer.onAttack(arg_133_0)
	if MiniDefenceMain:isPaused() then
		return 
	end
	
	arg_133_0:setState("attack")
	arg_133_0:updateTouchTick()
	
	if not arg_133_0.vars.can_attack or arg_133_0:isDead() then
		return 
	end
	
	local var_133_0 = MiniDefenceFeverManager:getFeverModeLevel()
	
	MiniDefenceEnemyManager:calcHitUnits(arg_133_0.vars.att[var_133_0], arg_133_0.vars.att_range[var_133_0])
	
	arg_133_0.vars.can_attack = false
	
	local var_133_1 = {
		"skill1",
		"skill2",
		"skill2"
	}
	
	arg_133_0:setAnimation(0, var_133_1[var_133_0], true)
	BattleAction:Add(SEQ(DELAY(arg_133_0.vars.att_delay), CALL(function()
		arg_133_0.vars.can_attack = true
	end)), arg_133_0.vars.model, "idle")
end

function MiniDefencePlayer.changeAttDely(arg_135_0, arg_135_1)
	local var_135_0 = var_0_7
	
	arg_135_0.vars.att_delay = var_135_0 / arg_135_1
end

function MiniDefencePlayer.setAnimation(arg_136_0, arg_136_1, arg_136_2, arg_136_3)
	local var_136_0 = arg_136_0.vars.model_data
	local var_136_1 = arg_136_0.vars.model
	
	if var_136_0 and var_136_0.setAnimation then
		if var_136_0.body and var_136_0.body:getCurrent() and var_136_0.body:getCurrent().animation then
			local var_136_2 = var_136_0.body:getCurrent().animation
			
			if var_136_2 and var_136_2 ~= arg_136_2 then
				var_136_0:setAnimation(arg_136_1, arg_136_2, arg_136_3)
			end
		else
			var_136_0:setAnimation(arg_136_1, arg_136_2, arg_136_3)
		end
	end
end

function MiniDefencePlayer.resumeAnimation(arg_137_0)
	if not arg_137_0.vars or not arg_137_0.vars.model_data then
		return 
	end
	
	arg_137_0.vars.model_data:resumeAnimation()
end

function MiniDefencePlayer.pauseAnimation(arg_138_0)
	if not arg_138_0.vars or not arg_138_0.vars.model_data then
		return 
	end
	
	local var_138_0 = arg_138_0.vars.model_data
	
	if var_138_0:getCurrent() then
		var_138_0:pauseAnimation()
	end
end

function MiniDefencePlayer.onDead(arg_139_0)
	arg_139_0:setState("dead")
	MiniDefenceMain:endGame("lose")
end

function MiniDefencePlayer.onLeave(arg_140_0)
	arg_140_0.vars = nil
end

function MiniDefenceMainResult.show(arg_141_0, arg_141_1)
	local var_141_0 = MiniDefenceMain:getLayer() or SceneManager:getDefaultLayer()
	
	if not get_cocos_refid(var_141_0) then
		return 
	end
	
	arg_141_0.vars = {}
	arg_141_0.vars.result = arg_141_1
	arg_141_0.vars.wnd = load_dlg("game_aprilfool_result", true, "wnd")
	
	var_141_0:addChild(arg_141_0.vars.wnd)
	BackButtonManager:push({
		check_id = "MiniDefenceMainResult",
		back_func = function()
			MiniDefenceMainResult:onLeave()
		end
	})
	arg_141_0:initUI()
	MiniDefenceEnemyManager:forceRemoveAllUnit()
	MiniDefenceFeverManager:pauseAllEffect()
	UIAction:Add(SEQ(SHOW(false), DELAY(2000), SHOW(true)), arg_141_0.vars.wnd:getChildByName("btn_close"), "block")
end

function MiniDefenceMainResult.initUI(arg_143_0)
	arg_143_0.vars.cur_ui = nil
	
	if_set_visible(arg_143_0.vars.wnd, "n_clear", arg_143_0.vars.result)
	if_set_visible(arg_143_0.vars.wnd, "n_fail", not arg_143_0.vars.result)
	
	local var_143_0
	local var_143_1
	
	if arg_143_0.vars.result then
		arg_143_0.vars.cur_ui = arg_143_0.vars.wnd:getChildByName("n_clear")
		var_143_1 = "face/z_aprilfool_2022_clear"
	else
		arg_143_0.vars.cur_ui = arg_143_0.vars.wnd:getChildByName("n_fail")
		var_143_1 = "face/z_aprilfool_2022_failed"
	end
	
	if_set_sprite(arg_143_0.vars.cur_ui, "n_pos", var_143_1)
	
	local var_143_2
	local var_143_3
	
	if arg_143_0.vars.result then
		var_143_2 = "stageclear_base_top"
		var_143_3 = arg_143_0.vars.cur_ui:getChildByName("n_clear_eff")
		
		SoundEngine:play("event:/effect/stageclear_base")
	else
		var_143_2 = "ui_stagefailed"
		var_143_3 = arg_143_0.vars.cur_ui:getChildByName("n_fail_eff")
		
		SoundEngine:play("event:/effect/stageclear_fail")
	end
	
	local var_143_4 = 1.5
	
	EffectManager:Play({
		y = 0,
		x = 0,
		fn = var_143_2,
		layer = var_143_3,
		scale = var_143_4
	})
end

function MiniDefenceMainResult.onLeave(arg_144_0)
	local function var_144_0()
		MiniDefenceMain:onLeave()
		
		arg_144_0.vars = nil
		
		SceneManager:popScene()
		BackButtonManager:pop("VolleyBallResult")
	end
	
	if MiniDefenceMain.vars.data.success_story and arg_144_0.vars.result then
		local var_144_1 = MiniDefenceMain:getLayer()
		
		if get_cocos_refid(var_144_1) then
			var_144_1:setVisible(false)
		end
		
		local var_144_2 = MiniDefenceMain.vars.data.success_story
		
		play_story(var_144_2, {
			force = true,
			enter_id = MiniDefenceMain.vars.enter_id,
			on_finish = function()
				var_144_0()
			end
		})
	else
		var_144_0()
	end
end

function MiniDefenceUtil.getCurTick(arg_147_0)
	return math.floor(LAST_TICK)
end

MiniDefenceEsc = MiniDefenceEsc or {}

function HANDLER.mini_defence_esc(arg_148_0, arg_148_1)
	if arg_148_1 == "btn_giveup" then
		MiniDefenceEsc:close(true)
		MiniDefenceEsc:giveUp()
		
		return 
	end
	
	if arg_148_1 == "btn_option" then
		balloon_message_with_sound("no_setup_mode")
		
		return 
	end
	
	if arg_148_1 == "btn_restart" then
		balloon_message_with_sound("ui_inbattle_esc_restart_error")
		
		return 
	end
	
	if arg_148_1 == "btn_close" or arg_148_1 == "btn_return" then
		MiniDefenceEsc:close()
		
		return 
	end
end

function MiniDefenceEsc.open(arg_149_0)
	if BattleAction:Find("boss_eff") then
		return 
	end
	
	arg_149_0.wnd = load_dlg("inbattle_esc", true, "wnd", function()
		arg_149_0:close()
	end)
	
	arg_149_0.wnd:setName("mini_defence_esc")
	
	local var_149_0 = SceneManager:getRunningNativeScene()
	
	if not var_149_0 then
		UIAction:Add(REMOVE(), arg_149_0.wnd, "worldboss")
		
		return 
	end
	
	if_set_opacity(arg_149_0.wnd, "btn_restart", 76.5)
	if_set_opacity(arg_149_0.wnd, "btn_option", 76.5)
	var_149_0:addChild(arg_149_0.wnd)
	arg_149_0.wnd:bringToFront()
	MiniDefenceMain:setPause(true, true)
end

function MiniDefenceEsc.giveUp(arg_151_0)
	Dialog:msgBox(T("pop_giveup_battle"), {
		yesno = true,
		handler = function()
			arg_151_0:_giveUp()
		end,
		cancel_handler = function()
			MiniDefenceMain:setPause(false, false)
		end,
		yes_text = T("msg_close")
	})
end

function MiniDefenceEsc._giveUp(arg_154_0)
	Dialog:closeAll()
	VolleyBallMain:endVolleyGame()
	UIOption:setBlock(false)
end

function MiniDefenceEsc.close(arg_155_0, arg_155_1)
	if not get_cocos_refid(arg_155_0.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_155_0.wnd, "block")
	BackButtonManager:pop("mini_defence_esc")
	
	arg_155_0.wnd = nil
	
	if not arg_155_1 then
		MiniDefenceMain:setPause(false, false)
	end
end

function MiniDefenceEsc.isOpen(arg_156_0)
	if not get_cocos_refid(arg_156_0.wnd) then
		return 
	end
	
	return true
end
