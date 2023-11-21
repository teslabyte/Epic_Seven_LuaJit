WorldBossBattleResult = WorldBossBattleResult or {}

function HANDLER.clan_worldboss_result(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		WorldBossBattleResult:backButton()
	end
	
	if arg_1_1 == "btn_stat" then
		WorldBossBattleResultStat:show(WorldBossBattleResult.vars.unit_infos)
	end
end

function WorldBossBattleResult.show(arg_2_0, arg_2_1, arg_2_2)
	if not Account:getConfigData("worldboss_did_play") then
		SAVE:setTempConfigData("worldboss_did_play", true)
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.reward_db = {}
	
	for iter_2_0 = 1, 99 do
		table.insert(arg_2_0.vars.reward_db, DBT("clan_worldboss_battle_grade", tostring(iter_2_0), {
			"grade",
			"grade_point",
			"reward_view",
			"reward_id",
			"reward_count",
			"static_reward_id",
			"static_reward_count"
		}))
	end
	
	arg_2_0.vars.unit_infos = {}
	
	for iter_2_1, iter_2_2 in pairs(arg_2_2) do
		table.insert(arg_2_0.vars.unit_infos, {
			unit = iter_2_2,
			power = iter_2_2.totatt_dmg or 0,
			code = iter_2_2.inst.code,
			party = iter_2_2.party
		})
	end
	
	table.sort(arg_2_0.vars.unit_infos, function(arg_3_0, arg_3_1)
		return arg_3_0.power > arg_3_1.power
	end)
	
	arg_2_0.vars.wnd = load_dlg("clan_worldboss_result", true, "wnd")
	
	if not get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	arg_2_0.vars.wnd:setOpacity(0)
	
	local var_2_0 = arg_2_1.layer or SceneManager:getRunningNativeScene()
	
	if not var_2_0 then
		return 
	end
	
	var_2_0:addChild(arg_2_0.vars.wnd)
	
	arg_2_0.score_info = arg_2_1.score_info or {}
	arg_2_0.params = arg_2_1
	
	local var_2_1 = arg_2_0.vars.wnd:findChildByName("n_point")
	
	arg_2_0.vars.earnpoint_txt = var_2_1:findChildByName("t_point_earning")
	
	if not get_cocos_refid(arg_2_0.vars.earnpoint_txt) then
		return 
	end
	
	arg_2_0.vars.earnpoint_txt:setString(0)
	
	arg_2_0.vars.supppoint_txt = var_2_1:findChildByName("t_point_supporter")
	
	if not get_cocos_refid(arg_2_0.vars.supppoint_txt) then
		return 
	end
	
	arg_2_0.vars.supppoint_txt:setString(0)
	
	arg_2_0.vars.totalbonus_txt = var_2_1:findChildByName("t_total_bonus")
	
	if not get_cocos_refid(arg_2_0.vars.totalbonus_txt) then
		return 
	end
	
	arg_2_0.vars.totalbonus_txt:setString(0 .. "%")
	
	local var_2_2 = arg_2_0.vars.wnd:findChildByName("n_total_point")
	
	if not get_cocos_refid(var_2_2) then
		return 
	end
	
	local var_2_3 = var_2_2:findChildByName("n_score_txt")
	
	if not get_cocos_refid(var_2_3) then
		return 
	end
	
	arg_2_0.vars.totalscore_txt = cc.Label:createWithBMFont("font/score.fnt", comma_value(0))
	
	arg_2_0.vars.totalscore_txt:setAnchorPoint(0, 0)
	arg_2_0.vars.totalscore_txt:setPosition(0, 20)
	var_2_3:addChild(arg_2_0.vars.totalscore_txt)
	
	local var_2_4
	local var_2_5 = table.count(arg_2_0.vars.reward_db)
	
	for iter_2_3 = 1, var_2_5 do
		local var_2_6 = arg_2_0.vars.reward_db[iter_2_3]
		
		if not var_2_6.grade_point then
			break
		end
		
		if arg_2_0.score_info.total_score < var_2_6.grade_point then
			break
		end
		
		var_2_4 = var_2_6
	end
	
	arg_2_0.vars.n_rank = var_2_2:findChildByName("n_rank")
	arg_2_0.vars.rankicon_spr = var_2_2:findChildByName("icon_rank")
	
	if not get_cocos_refid(arg_2_0.vars.rankicon_spr) then
		return 
	end
	
	arg_2_0.vars.rankicon_spr:setOpacity(0)
	
	var_2_4.grade = string.replace(var_2_4.grade, "+", "_plus")
	
	if_set_sprite(var_2_2, "icon_rank", "img/rank_raid_" .. string.lower(var_2_4.grade) .. ".png")
	
	local var_2_7 = arg_2_0.vars.wnd:findChildByName("n_reward_item")
	local var_2_8 = var_2_7:findChildByName("n_item1")
	
	if get_cocos_refid(var_2_8) then
		UIUtil:getRewardIcon(nil, var_2_4.reward_id, {
			no_frame = true,
			no_count = true,
			scale = 0.8,
			no_detail_popup = true,
			parent = var_2_8
		})
		if_set(var_2_7, "txt_reward1_count", "X" .. var_2_4.reward_count)
	end
	
	local var_2_9 = var_2_7:findChildByName("n_item2")
	
	if get_cocos_refid(var_2_9) then
		UIUtil:getRewardIcon(nil, var_2_4.static_reward_id, {
			no_frame = true,
			no_count = true,
			scale = 0.8,
			no_detail_popup = true,
			parent = var_2_9
		})
		if_set(var_2_7, "txt_reward2_count", "X" .. var_2_4.static_reward_count)
	end
	
	arg_2_0.vars.char_results = {}
	
	for iter_2_4 = 1, 4 do
		local var_2_10 = arg_2_0.vars.unit_infos[iter_2_4]
		local var_2_11 = var_2_10.unit
		
		if not var_2_11 and var_2_10.code then
			var_2_11 = UNIT:create({
				exp = 0,
				lv = 1,
				code = var_2_10.code
			})
			var_2_10.unit = var_2_11
		end
		
		local var_2_12 = arg_2_0:createCharResult(var_2_11, var_2_10.power, var_2_10.party == 4, iter_2_4 == 1)
		
		if not get_cocos_refid(var_2_12) then
			return 
		end
		
		local var_2_13 = arg_2_0.vars.wnd:findChildByName("n_pos" .. iter_2_4)
		
		if get_cocos_refid(var_2_13) then
			var_2_13:addChild(var_2_12)
			var_2_12:setOpacity(0)
			table.insert(arg_2_0.vars.char_results, var_2_12)
		end
	end
	
	local var_2_14 = {
		reward = arg_2_1.reward_result,
		layer = var_2_0,
		grade = var_2_4.grade
	}
	
	BackButtonManager:push({
		check_id = "WorldBossBattleResult.backButton",
		back_func = function()
			WorldBossBattleResult:backButton()
		end
	})
	UIAction:Add(SEQ(FADE_IN(300), DELAY(200), CALL(WorldBossBattleResult._onCharResultAction, WorldBossBattleResult), CALL(WorldBossBattleResult._onEarnPointAction, WorldBossBattleResult), DELAY(200), CALL(WorldBossBattleResult._onSuppPointAction, WorldBossBattleResult), DELAY(200), CALL(WorldBossBattleResult._onTotalBonusAction, WorldBossBattleResult), DELAY(400), CALL(WorldBossBattleResult._onRankIconAction, WorldBossBattleResult), CALL(WorldBossBattleResult._onRankPointAction, WorldBossBattleResult), DELAY(1000), CALL(WorldBossBattleReward.show, WorldBossBattleReward, var_2_14)), arg_2_0.vars.wnd, "block")
end

function WorldBossBattleResult.hide(arg_5_0)
	BackButtonManager:pop("WorldBossBattleResult.backButton")
	
	if arg_5_0.vars and get_cocos_refid(arg_5_0.vars.wnd) then
		UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_5_0.vars.wnd, "block")
	end
end

function WorldBossBattleResult.createCharResult(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = cc.CSLoader:createNode("wnd/result_character.csb")
	
	var_6_0:setPosition(0, 0)
	var_6_0:setAnchorPoint(0, 0)
	if_set_visible(var_6_0, "exp", false)
	if_set_visible(var_6_0, "exp_none", false)
	if_set_visible(var_6_0, "intimacy", false)
	
	local var_6_1 = var_6_0:findChildByName("n_face")
	
	if not get_cocos_refid(var_6_1) then
		return 
	end
	
	if_set_sprite(var_6_1, "face", "face/" .. arg_6_1.db.face_id .. "_s.png")
	if_set_visible(var_6_1, "frame", false)
	if_set_visible(var_6_1, "frame_worldboss", true)
	if_set_visible(var_6_1, "progress_bg", false)
	if_set_visible(var_6_1, "icon_supporter", arg_6_3)
	if_set_color(var_6_1, "frame_worldboss", arg_6_3 and cc.c3b(17, 146, 237) or cc.c3b(255, 255, 255))
	
	local var_6_2 = var_6_0:findChildByName("n_worldboss")
	
	if not get_cocos_refid(var_6_2) then
		return 
	end
	
	if_set_visible(var_6_2, nil, true)
	if_set(var_6_2, "txt_name_worldboss", arg_6_1:getName())
	if_set(var_6_2, "txt_point_worldboss", comma_value(arg_6_2 or 0))
	if_set_visible(var_6_0, "n_mvp", arg_6_4)
	
	return var_6_0
end

function WorldBossBattleResult.backButton(arg_7_0)
	arg_7_0:hide()
	
	local function var_7_0()
		BackButtonManager:pop("WorldBossBattleResult.backButton")
		SceneManager:popScene()
		SceneManager:nextScene("world_boss_map")
	end
	
	if arg_7_0.params.isPlayEndStory and arg_7_0.params.endStoryID then
		play_story(arg_7_0.params.endStoryID, {
			force_on_finish = true,
			force = true,
			on_finish = function()
				var_7_0()
			end
		})
	else
		var_7_0()
	end
end

function WorldBossBattleResult._onCharResultAction(arg_10_0)
	for iter_10_0 = 1, table.count(arg_10_0.vars.char_results) do
		local var_10_0 = arg_10_0.vars.char_results[iter_10_0]
		
		UIAction:Add(SEQ(DELAY((iter_10_0 - 1) * 85), SLIDE_IN(300, 600)), var_10_0, "block")
	end
end

function WorldBossBattleResult._onEarnPointAction(arg_11_0)
	UIAction:Add(INC_NUMBER(300, arg_11_0.score_info.my_score), arg_11_0.vars.earnpoint_txt, "block")
end

function WorldBossBattleResult._onSuppPointAction(arg_12_0)
	UIAction:Add(INC_NUMBER(300, arg_12_0.score_info.supporter_score), arg_12_0.vars.supppoint_txt, "block")
end

function WorldBossBattleResult._onTotalBonusAction(arg_13_0)
	UIAction:Add(INC_NUMBER(300, arg_13_0.score_info.total_bonus * 100, "%", 0), arg_13_0.vars.totalbonus_txt, "block")
end

function WorldBossBattleResult._onRankIconAction(arg_14_0)
	if not get_cocos_refid(arg_14_0.vars.n_rank) then
		return 
	end
	
	if not get_cocos_refid(arg_14_0.vars.rankicon_spr) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.rankicon_spr:getContentSize()
	
	EffectManager:Play({
		z = 1,
		fn = "ui_worldboss_result_grade_eff.cfx",
		layer = arg_14_0.vars.rankicon_spr,
		x = var_14_0.width / 2,
		y = var_14_0.height / 2
	})
	UIAction:Add(SEQ(DELAY(50), OPACITY(0, 0, 1)), arg_14_0.vars.rankicon_spr, "block")
end

function WorldBossBattleResult._onRankPointAction(arg_15_0)
	UIAction:Add(INC_NUMBER(500, arg_15_0.score_info.total_score), arg_15_0.vars.totalscore_txt, "block")
end
