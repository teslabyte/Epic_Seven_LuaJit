function HANDLER.clan_worldboss_battle(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_chat" then
		ChatMain:show()
	end
	
	if arg_1_1 == "btn_skip" then
		WorldBoss:skip()
	end
	
	if arg_1_1 == "icon" then
		WorldBoss:skip()
	end
	
	if arg_1_1 == "btn_setting" then
		if not WorldBossBattleUI:isPausable() then
			return 
		end
		
		WorldBossBattleEsc:open()
	end
end

UIUnitMeter = ClassDef()

function UIUnitMeter.constructor(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0._x, arg_2_0._y = arg_2_2, arg_2_3
	arg_2_0.control = load_control("wnd/clan_worldboss_battle_unit.csb")
	
	if not get_cocos_refid(arg_2_0.control) then
		return 
	end
	
	arg_2_0.control:setPosition(arg_2_2, arg_2_3)
	
	arg_2_0.damage_text = arg_2_0.control:findChildByName("t_point")
	
	if not get_cocos_refid(arg_2_0.damage_text) then
		return 
	end
	
	arg_2_0:setDamageText(0)
	
	arg_2_0.progress_bar = arg_2_0.control:findChildByName("progress_bar")
	
	if not get_cocos_refid(arg_2_0.progress_bar) then
		return 
	end
	
	arg_2_0:setProgressBar(0, 0)
	
	arg_2_0.face = arg_2_0.control:findChildByName("face")
	
	if not get_cocos_refid(arg_2_0.face) then
		return 
	end
	
	arg_2_0:setUnitFace(arg_2_1.db.face_id)
	
	arg_2_0.frame = arg_2_0.control:findChildByName("frame")
	
	if not get_cocos_refid(arg_2_0.frame) then
		return 
	end
	
	arg_2_0:setFrameColor(arg_2_1.inst.pos > 12 and cc.c3b(17, 146, 237) or cc.c3b(255, 255, 255))
end

function UIUnitMeter.setUnitFace(arg_3_0, arg_3_1)
	if not get_cocos_refid(arg_3_0.face) then
		return 
	end
	
	if_set_sprite(arg_3_0.face, nil, "face/" .. arg_3_1 .. "_s.png")
end

function UIUnitMeter.setFrameColor(arg_4_0, arg_4_1)
	if not get_cocos_refid(arg_4_0.frame) then
		return 
	end
	
	if_set_color(arg_4_0.frame, nil, arg_4_1)
end

function UIUnitMeter.setDamageText(arg_5_0, arg_5_1)
	if not get_cocos_refid(arg_5_0.damage_text) then
		return 
	end
	
	arg_5_0.damage_text:setString(T("ui_clan_worldboss_battle_unit_point", {
		unit_point = comma_value(arg_5_1)
	}))
end

function UIUnitMeter.setProgressBar(arg_6_0, arg_6_1, arg_6_2)
	if_set_percent(arg_6_0.progress_bar, nil, arg_6_1 / arg_6_2)
end

function UIUnitMeter.setProgressBarColor(arg_7_0, arg_7_1)
	if_set_color(arg_7_0.progress_bar, nil, arg_7_1)
end

function UIUnitMeter.shake(arg_8_0)
	BattleUIAction:Add(SHAKE_UI(100, 30), arg_8_0.control, "worldboss")
end

WorldBossBattleUI = WorldBossBattleUI or {}

function WorldBossBattleUI.load(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0.worldboss = table.shallow_clone(arg_9_1)
	arg_9_0.raidparty = table.shallow_clone(arg_9_2)
	arg_9_0.unitmeters = {}
	arg_9_0.lasttotal_damage = 0
	arg_9_0.curtotal_damage = 0
	arg_9_0.rank_table = {}
	arg_9_0.season_info = arg_9_3 or {}
	arg_9_0.wnd = load_dlg("clan_worldboss_battle", true, "wnd", function()
		if not arg_9_0:isPausable() then
			return 
		end
		
		WorldBossBattleEsc:open()
	end)
	
	arg_9_0.wnd:setCascadeOpacityEnabled(true)
	SceneManager:getRunningNativeScene():addChild(arg_9_0.wnd)
	arg_9_0:makeDamageMeter()
	arg_9_0:makeDamageBoard()
	arg_9_0:makeHPBar()
	arg_9_0:updateDamageBoard()
end

function WorldBossBattleUI.unload(arg_11_0)
	arg_11_0.worldboss = nil
	arg_11_0.raidparty = nil
	arg_11_0.unitmeters = nil
	arg_11_0.curtotal_damage = 0
	arg_11_0.rank_table = nil
end

function WorldBossBattleUI.update(arg_12_0, arg_12_1)
	arg_12_0:updateDamageMeter(arg_12_1)
	arg_12_0:updateDamageBoard()
	arg_12_0:updateWorldBossHP()
end

function WorldBossBattleUI.makeDamageMeter(arg_13_0)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.raidparty) do
		local var_13_0 = arg_13_0.wnd:findChildByName("n_" .. iter_13_0)
		
		if not get_cocos_refid(var_13_0) then
			return 
		end
		
		local var_13_1, var_13_2 = var_13_0:getPosition()
		local var_13_3 = UIUnitMeter(iter_13_1, var_13_1, var_13_2)
		
		if not var_13_3 then
			return 
		end
		
		arg_13_0.wnd:addChild(var_13_3.control)
		
		arg_13_0.unitmeters[iter_13_0] = var_13_3
	end
end

function WorldBossBattleUI.makeDamageBoard(arg_14_0)
	arg_14_0.dmgboard = arg_14_0.wnd:findChildByName("n_battle")
	
	if not get_cocos_refid(arg_14_0.dmgboard) then
		return 
	end
	
	arg_14_0.dmgboard.rankicon = arg_14_0.dmgboard:findChildByName("icon_rank")
	
	if not get_cocos_refid(arg_14_0.dmgboard.rankicon) then
		return 
	end
	
	SpriteCache:resetSprite(arg_14_0.dmgboard.rankicon, "img/rank_raid_d.png")
	
	arg_14_0.dmgboard.score = arg_14_0.dmgboard:findChildByName("n_score_txt")
	
	if not get_cocos_refid(arg_14_0.dmgboard.score) then
		return 
	end
	
	arg_14_0.dmgboard.label = cc.Label:createWithBMFont("font/score.fnt", comma_value(arg_14_0.curtotal_damage))
	
	if not get_cocos_refid(arg_14_0.dmgboard.label) then
		return 
	end
	
	arg_14_0.dmgboard.label:setPosition(0, 10)
	arg_14_0.dmgboard.label:setAnchorPoint(1, 0)
	arg_14_0.dmgboard.score:addChild(arg_14_0.dmgboard.label)
	
	for iter_14_0 = 1, 99 do
		local var_14_0, var_14_1 = DBN("clan_worldboss_battle_grade", tostring(iter_14_0), {
			"grade",
			"grade_point"
		})
		
		if not var_14_0 then
			break
		end
		
		table.insert(arg_14_0.rank_table, {
			rank = var_14_0,
			point = var_14_1
		})
	end
	
	table.sort(arg_14_0.rank_table, function(arg_15_0, arg_15_1)
		return arg_15_0.point < arg_15_1.point
	end)
	
	arg_14_0.dmgboard.cur_rank = arg_14_0.rank_table[1].rank
end

function WorldBossBattleUI.makeHPBar(arg_16_0)
	if not arg_16_0.worldboss then
		return 
	end
	
	local var_16_0 = arg_16_0.worldboss[1]
	
	if not var_16_0.db then
		return 
	end
	
	local var_16_1 = arg_16_0.wnd:findChildByName("n_hp_bar")
	
	if not get_cocos_refid(var_16_1) then
		return 
	end
	
	local var_16_2 = WorldBossUtil:getBossHP(arg_16_0.season_info.start_time, arg_16_0.season_info.end_time)
	
	WorldBossUtil:setHPBar(var_16_1, var_16_2)
	if_set(var_16_1, "txt_name", T(var_16_0.db.name))
	if_set_sprite(var_16_1, "face", "face/" .. (var_16_0.db.face_id or "") .. "_s.png")
end

function WorldBossBattleUI.updateDamageMeter(arg_17_0, arg_17_1)
	table.sort(arg_17_0.raidparty, function(arg_18_0, arg_18_1)
		return arg_18_0.curatt_dmg > arg_18_1.curatt_dmg
	end)
	
	arg_17_0.lasttotal_damage = arg_17_0.curtotal_damage
	arg_17_0.curtotal_damage = arg_17_0.curtotal_damage + arg_17_1.attack_damage
	
	local var_17_0 = arg_17_0.raidparty[1].curatt_dmg or 1
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.raidparty) do
		local var_17_1 = arg_17_0.unitmeters[iter_17_0]
		
		if not var_17_1 then
			return 
		end
		
		local var_17_2 = math.floor(iter_17_1.curatt_dmg)
		local var_17_3 = iter_17_0 == 1
		local var_17_4 = iter_17_1.inst.pos > 12
		
		var_17_1:setUnitFace(iter_17_1.db.face_id)
		var_17_1:setFrameColor(var_17_4 and cc.c3b(17, 146, 237) or cc.c3b(255, 255, 255))
		var_17_1:setDamageText(var_17_2)
		var_17_1:setProgressBar(var_17_2, var_17_0)
		var_17_1:setProgressBarColor(var_17_3 and cc.c3b(107, 193, 27) or cc.c3b(146, 109, 62))
		
		if arg_17_1.unit_pos == iter_17_1.inst.pos and arg_17_1.is_critical then
			var_17_1:shake()
		end
	end
end

function WorldBossBattleUI.updateDamageBoard(arg_19_0)
	if not get_cocos_refid(arg_19_0.dmgboard) then
		return 
	end
	
	if arg_19_0.curtotal_damage > 0 then
		BattleUIAction:Add(LOG(INC_NUMBER(500, arg_19_0.curtotal_damage, nil, arg_19_0.lasttotal_damage)), arg_19_0.dmgboard.label, "worldboss")
	end
	
	local var_19_0 = "D"
	local var_19_1 = false
	local var_19_2 = table.count(arg_19_0.rank_table)
	
	for iter_19_0 = 1, var_19_2 do
		if arg_19_0.curtotal_damage < arg_19_0.rank_table[iter_19_0].point then
			break
		end
		
		var_19_0 = arg_19_0.rank_table[iter_19_0].rank
	end
	
	if arg_19_0.dmgboard.cur_rank ~= var_19_0 then
		arg_19_0.dmgboard.cur_rank = var_19_0
		
		local var_19_3 = string.replace(arg_19_0.dmgboard.cur_rank, "+", "_plus")
		
		SpriteCache:resetSprite(arg_19_0.dmgboard.rankicon, "img/rank_raid_" .. string.lower(var_19_3) .. ".png")
		BattleUIAction:Add(SHAKE_UI(200, 30), arg_19_0.dmgboard.rankicon, "worldboss")
	end
end

function WorldBossBattleUI.updateWorldBossHP(arg_20_0)
end

function WorldBossBattleUI.fadeIn(arg_21_0)
	BattleUIAction:Add(SEQ(CALL(function()
		if not arg_21_0:isVisible() then
			arg_21_0:setVisible(true)
		end
	end), FADE_IN(200)), arg_21_0.wnd, "worldboss")
end

function WorldBossBattleUI.fadeOut(arg_23_0)
	if not arg_23_0:isVisible() then
		return 
	end
	
	BattleUIAction:Add(SEQ(FADE_OUT(200), CALL(function()
		if arg_23_0:isVisible() then
			arg_23_0:setVisible(false)
		end
	end)), arg_23_0.wnd, "worldboss")
end

function WorldBossBattleUI.setVisible(arg_25_0, arg_25_1)
	if not get_cocos_refid(arg_25_0.wnd) then
		return 
	end
	
	arg_25_0.wnd:setVisible(arg_25_1)
end

function WorldBossBattleUI.isVisible(arg_26_0)
	if not get_cocos_refid(arg_26_0.wnd) then
		return 
	end
	
	return arg_26_0.wnd:isVisible()
end

function WorldBossBattleUI.isPausable(arg_27_0)
	if SceneManager:getCurrentSceneName() ~= "world_boss" then
		return 
	end
	
	if NetWaiting:isWaiting() then
		return 
	end
	
	if TransitionScreen:isShow() then
		return 
	end
	
	if get_cocos_refid(G_CURRENT_MOVIE_CLIP) then
		return 
	end
	
	if HelpGuide.vars and get_cocos_refid(HelpGuide.vars.wnd) then
		return 
	end
	
	if WorldBoss.FSM:getCurrentState() == WorldBossState.ACTION then
		return 
	end
	
	if get_cocos_refid(WorldBossBattleEsc:isOpen()) then
		return 
	end
	
	return true
end

function WorldBossBattleUI.applicationDidEnterBackground(arg_28_0)
	if IS_ANDROID_BASED_PLATFORM and getenv("allow.battle_pause", "") == "1" then
		arg_28_0.time_didEnterBackground = os.time()
	end
end

function WorldBossBattleUI.applicationWillEnterForeground(arg_29_0)
	if IS_ANDROID_BASED_PLATFORM and getenv("allow.battle_pause", "") == "1" and arg_29_0.time_didEnterBackground and os.time() - arg_29_0.time_didEnterBackground > 1 and arg_29_0:isPausable() then
		WorldBossBattleEsc:open()
	end
end
