ResultStatUI = ResultStatUI or {}

local var_0_0 = {
	all_contribution_att = cc.c3b(17, 145, 235),
	all_contribution_def = cc.c3b(107, 193, 27),
	att = cc.c3b(17, 145, 235),
	def = cc.c3b(107, 193, 27),
	heal = cc.c3b(185, 124, 46),
	buff_count = cc.c3b(107, 193, 27),
	debuff_count = cc.c3b(17, 145, 235),
	resurrect_count = cc.c3b(185, 124, 46)
}
local var_0_1 = {
	all_contribution_att = cc.c3b(17, 145, 235),
	all_contribution_def = cc.c3b(107, 193, 27),
	att = cc.c3b(17, 145, 235),
	def = cc.c3b(107, 193, 27),
	heal = cc.c3b(185, 124, 46),
	buff_count = cc.c3b(107, 193, 27),
	debuff_count = cc.c3b(17, 145, 235),
	resurrect_count = cc.c3b(185, 124, 46)
}
local var_0_2 = {
	buff_count = "img/battle_pvp_icon_strengthen.png",
	def = "img/battle_pvp_icon_taken.png",
	all_contribution_att = "img/battle_pvp_icon_win_plus.png",
	all_contribution_def = "img/battle_pvp_icon_def_plus.png",
	heal = "img/battle_pvp_icon_recovery.png",
	resurrect_count = "img/battle_pvp_icon_rebirth.png",
	att = "img/battle_pvp_icon_damage.png",
	debuff_count = "img/battle_pvp_icon_weak.png"
}

function HANDLER.result_stat(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		ResultStatUI:close()
	end
	
	if arg_1_1 == "btn_main_tab1" then
		ResultStatUI:update("all_contribution")
	end
	
	if arg_1_1 == "btn_main_tab2" then
		ResultStatUI:update("att_contribution")
	end
	
	if arg_1_1 == "btn_main_tab3" then
		ResultStatUI:update("def_contribution")
	end
end

function HANDLER.result_stat_story_challenge(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		ResultStatUI:close()
	end
	
	if arg_2_1 == "btn_main_tab1" then
		ResultStatUI:update("all_contribution")
	end
	
	if arg_2_1 == "btn_main_tab2" then
		ResultStatUI:update("att_contribution")
	end
	
	if arg_2_1 == "btn_main_tab3" then
		ResultStatUI:update("def_contribution")
	end
	
	if arg_2_1 == "btn_team" then
		local var_2_0 = arg_2_0:getParent()
		
		if var_2_0 and var_2_0.getName then
			local var_2_1 = var_2_0:getName()
			
			ResultStatUI:selectTeamIdx(tonumber(string.sub(var_2_1, -1, -1)))
		end
	end
end

function ResultStatUI.show(arg_3_0, arg_3_1, arg_3_2)
	arg_3_2 = arg_3_2 or {}
	arg_3_1 = arg_3_1 or SceneManager:getRunningNativeScene()
	arg_3_0.vars = {}
	arg_3_0.vars.controls = {}
	arg_3_0.vars.core = arg_3_2.core
	arg_3_0.vars.is_reverse = arg_3_2.is_reverse
	
	if arg_3_2.test_data then
		arg_3_0.vars.infos = arg_3_2.test_data.infos
		arg_3_0.vars.highest_score = arg_3_2.test_data.highest_score
	elseif arg_3_2.result_stat then
		arg_3_0.vars.infos = arg_3_2.result_stat.infos
		arg_3_0.vars.highest_score = arg_3_2.result_stat.highest_score
	elseif arg_3_0.vars.infos == nil then
		local var_3_0 = arg_3_0.vars.core:calc()
		
		arg_3_0.vars.infos = var_3_0.infos
		arg_3_0.vars.highest_score = var_3_0.highest_score
	end
	
	arg_3_0.vars.mvp_uid_infos = arg_3_2.mvp_uid_infos
	
	local var_3_1 = "result_stat"
	
	if arg_3_0:isUseMultiTeam() then
		var_3_1 = "result_stat_story_challenge"
		
		arg_3_0:initMultiTeamInfos()
		arg_3_0:setTeamIdx(1)
	end
	
	arg_3_0.vars.wnd = load_dlg(var_3_1, true, "wnd", function()
		arg_3_0:close()
	end)
	
	arg_3_0.vars.wnd:setOpacity(0)
	arg_3_0.vars.wnd:getChildByName("n_list"):removeAllChildren()
	UIAction:Add(FADE_IN(200), arg_3_0.vars.wnd, "block")
	arg_3_1:addChild(arg_3_0.vars.wnd)
	
	if arg_3_0:isUseMultiTeam() then
		for iter_3_0 = 1, 3 do
			local var_3_2 = arg_3_0.vars.wnd:getChildByName("tab" .. iter_3_0)
			
			if get_cocos_refid(var_3_2) then
				if_set(var_3_2, "txt", T("ui_battle_ready_challenge_formation_team", {
					team = iter_3_0
				}))
			end
		end
	end
	
	arg_3_0:setInfos("all_contribution")
end

function ResultStatUI.close(arg_5_0)
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE(), CALL(function()
		BackButtonManager:pop("result_stat")
	end)), arg_5_0.vars.wnd, "block")
end

function ResultStatUI.selectTeamIdx(arg_7_0, arg_7_1)
	if not arg_7_0:isUseMultiTeam() then
		return 
	end
	
	arg_7_0:setTeamIdx(arg_7_1)
	arg_7_0:setInfos("all_contribution", true)
end

function ResultStatUI.setTeamIdx(arg_8_0, arg_8_1)
	arg_8_0.vars.select_team_idx = arg_8_1
end

function ResultStatUI.getTeamIdx(arg_9_0)
	return arg_9_0.vars.select_team_idx or 0
end

function ResultStatUI.isDescent(arg_10_0)
	if not arg_10_0.vars.core then
		return false
	end
	
	return arg_10_0.vars.core:isDescent()
end

function ResultStatUI.isBurning(arg_11_0)
	if not arg_11_0.vars.core then
		return false
	end
	
	return arg_11_0.vars.core:isBurning()
end

function ResultStatUI.isUseMultiTeam(arg_12_0)
	if arg_12_0.vars.core then
		return arg_12_0.vars.core:isUseMultiTeam()
	end
end

function ResultStatUI.initMultiTeamInfos(arg_13_0)
	arg_13_0.vars.multi_team_infos = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.infos) do
		local var_13_0 = iter_13_1.team_idx
		
		if var_13_0 then
			if not arg_13_0.vars.multi_team_infos[var_13_0] then
				arg_13_0.vars.multi_team_infos[var_13_0] = {}
			end
			
			if arg_13_0.vars.mvp_uid_infos and table.find(arg_13_0.vars.mvp_uid_infos, iter_13_1.uid) then
				iter_13_1.is_mvp = true
			end
			
			table.insert(arg_13_0.vars.multi_team_infos[var_13_0], iter_13_1)
		end
	end
end

function ResultStatUI.getInfosCount(arg_14_0)
	if arg_14_0:isUseMultiTeam() then
		return table.count(arg_14_0:getMultiTeamInfo())
	else
		return #arg_14_0.vars.infos
	end
end

function ResultStatUI.getInfos(arg_15_0)
	if arg_15_0:isUseMultiTeam() then
		return arg_15_0:getMultiTeamInfo()
	else
		return arg_15_0.vars.infos
	end
end

function ResultStatUI.getMultiTeamInfo(arg_16_0)
	if not arg_16_0:isUseMultiTeam() or not arg_16_0.vars.multi_team_infos then
		return {}
	end
	
	return arg_16_0.vars.multi_team_infos[arg_16_0:getTeamIdx()] or {}
end

function ResultStatUI.setInfos(arg_17_0, arg_17_1, arg_17_2)
	SoundEngine:play("event:/ui/whoosh_a")
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.controls) do
		UIAction:Add(SEQ(DELAY(iter_17_0 * 40), SPAWN(FADE_OUT(180), RLOG(MOVE_TO(180, 1500), 100)), REMOVE()), iter_17_1, "block")
	end
	
	local var_17_0 = arg_17_0:getInfos()
	
	arg_17_0.vars.controls = {}
	
	for iter_17_2, iter_17_3 in ipairs(var_17_0) do
		arg_17_0:addItem(iter_17_2)
	end
	
	arg_17_0:update(arg_17_1, 300, arg_17_2)
end

function ResultStatUI.addItem(arg_18_0, arg_18_1)
	local var_18_0 = cc.CSLoader:createNode("wnd/result_stat_item.csb")
	local var_18_1 = 880
	
	if arg_18_0:isUseMultiTeam() then
		var_18_1 = 767
	end
	
	local var_18_2 = var_18_1 / arg_18_0:getInfosCount()
	local var_18_3 = var_18_2 / 2 + var_18_2 * (arg_18_1 - 1)
	
	var_18_0:setPosition(-200, 0)
	
	local var_18_4 = arg_18_1 * 40 + 200
	
	UIAction:Add(SEQ(DELAY(var_18_4), SPAWN(FADE_IN(100), LOG(MOVE_TO(180, var_18_3), 200))), var_18_0, "block")
	arg_18_0.vars.wnd:getChildByName("n_list"):addChild(var_18_0)
	
	arg_18_0.vars.controls[arg_18_1] = var_18_0
end

function ResultStatUI.update(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not arg_19_3 and arg_19_0.vars.mode == arg_19_1 then
		return 
	end
	
	local function var_19_0(arg_20_0)
		if not arg_20_0 or arg_20_0 < 1 then
			return 
		end
		
		arg_20_0 = math.clamp(arg_20_0, 1, 6)
		
		return "img/_battle_pvp_" .. tostring(arg_20_0) .. "kill.png"
	end
	
	arg_19_0.vars.mode = arg_19_1
	
	if_set_visible(arg_19_0.vars.wnd, "selected1", arg_19_1 == "all_contribution")
	if_set_visible(arg_19_0.vars.wnd, "selected2", arg_19_1 == "att_contribution")
	if_set_visible(arg_19_0.vars.wnd, "selected3", arg_19_1 == "def_contribution")
	
	local var_19_1
	
	if arg_19_0:isUseMultiTeam() then
		var_19_1 = table.count(arg_19_0.vars.multi_team_infos or {})
		
		for iter_19_0 = 1, 3 do
			local var_19_2 = arg_19_0.vars.wnd:getChildByName("tab" .. iter_19_0)
			
			if get_cocos_refid(var_19_2) then
				var_19_2:setVisible(iter_19_0 <= var_19_1)
				if_set_visible(var_19_2, "selected", iter_19_0 == arg_19_0:getTeamIdx())
			end
		end
	end
	
	local var_19_3 = arg_19_0:getInfos()
	local var_19_4 = arg_19_0.vars.controls
	
	for iter_19_1, iter_19_2 in pairs(var_19_3) do
		local var_19_5 = var_19_4[iter_19_1]
		
		if_set_sprite(var_19_5, "face", "face/" .. iter_19_2.face_id .. "_s.png")
		if_set_visible(var_19_5, "n_mvp", iter_19_2.is_mvp)
		if_set_visible(var_19_5, "n_turn", iter_19_2.speed_order and iter_19_2.speed_order > 0)
		if_set(var_19_5, "t_order", tostring(iter_19_2.speed_order))
		
		if var_19_0(iter_19_2.kill_count) then
			if_set_visible(var_19_5, "n_kill", true)
			SpriteCache:resetSprite(var_19_5:getChildByName("n_kill"), var_19_0(iter_19_2.kill_count))
		else
			if_set_visible(var_19_5, "n_kill", false)
		end
	end
	
	local var_19_6 = {}
	local var_19_7 = 0
	
	for iter_19_3, iter_19_4 in pairs(var_19_3) do
		local var_19_8 = to_n(var_19_6[iter_19_4.ally]) + iter_19_4[arg_19_0.vars.mode]
		
		var_19_7 = var_19_7 + var_19_8
		var_19_6[iter_19_4.ally] = var_19_8
	end
	
	for iter_19_5, iter_19_6 in pairs(var_19_3) do
		local var_19_9 = var_19_4[iter_19_5]
		local var_19_10 = 0
		local var_19_11 = var_19_6[iter_19_6.ally or FRIEND]
		
		if var_19_11 > 0 then
			var_19_10 = math.floor(var_19_3[iter_19_5][arg_19_0.vars.mode] * 100 / var_19_11 + 0.5)
		end
		
		if_set(var_19_9, "t_percent", tostring(var_19_10) .. "%")
		
		if arg_19_0.vars.is_reverse then
			if iter_19_6.ally == FRIEND then
				if_set_color(var_19_9, "t_percent", UIUtil.RED)
				if_set_sprite(var_19_9, "frame", "img/cm_hero_circool2.png")
				if_set_sprite(var_19_9, "bg", "img/_hero_s_bg_enemy.png")
			end
		elseif iter_19_6.ally == ENEMY then
			if_set_color(var_19_9, "t_percent", UIUtil.RED)
			if_set_sprite(var_19_9, "frame", "img/cm_hero_circool2.png")
			if_set_sprite(var_19_9, "bg", "img/_hero_s_bg_enemy.png")
		else
			local var_19_12 = iter_19_6.is_supporter
			
			if_set_color(var_19_9, "frame", var_19_12 and cc.c3b(17, 146, 237) or cc.c3b(255, 255, 255))
		end
		
		arg_19_0:playGauge(iter_19_5, arg_19_2)
	end
	
	if var_19_7 > 0 then
		if_set_visible(arg_19_0.vars.wnd, "n_noscore", false)
	else
		local var_19_13 = arg_19_0.vars.wnd:getChildByName("n_noscore")
		
		if get_cocos_refid(var_19_13) then
			if_set(var_19_13, "txt_noscore", T("ui_result_stat_no_help"))
			var_19_13:setVisible(true)
		end
	end
end

function ResultStatUI.playGauge(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.vars.controls[arg_21_1]
	
	if not get_cocos_refid(var_21_0) then
		return 
	end
	
	local var_21_1 = arg_21_0:getInfos()[arg_21_1]
	
	if arg_21_0.vars.mode == "all_contribution" then
		if_set_visible(var_21_0, "n_progress1", true)
		if_set_visible(var_21_0, "n_progress2", true)
		if_set_visible(var_21_0, "n_progress3", false)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress1"), "all_contribution_att", arg_21_1, arg_21_2, 10)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress2"), "all_contribution_def", arg_21_1, arg_21_2, 10)
	elseif arg_21_0.vars.mode == "att_contribution" then
		if_set_visible(var_21_0, "n_progress1", true)
		if_set_visible(var_21_0, "n_progress2", true)
		if_set_visible(var_21_0, "n_progress3", true)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress1"), "att", arg_21_1, arg_21_2)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress2"), "def", arg_21_1, arg_21_2)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress3"), "heal", arg_21_1, arg_21_2)
	elseif arg_21_0.vars.mode == "def_contribution" then
		if_set_visible(var_21_0, "n_progress1", true)
		if_set_visible(var_21_0, "n_progress2", true)
		if_set_visible(var_21_0, "n_progress3", true)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress1"), "debuff_count", arg_21_1, arg_21_2)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress2"), "buff_count", arg_21_1, arg_21_2)
		arg_21_0:playSingleGauge(var_21_0:getChildByName("n_progress3"), "resurrect_count", arg_21_1, arg_21_2)
	end
end

function ResultStatUI.playSingleGauge(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = arg_22_1:getChildByName("bar")
	local var_22_1 = arg_22_1:getChildByName("t_count")
	local var_22_2 = arg_22_1:getChildByName("n_icon")
	
	if_set_add_position_x(arg_22_1, nil, arg_22_5 or 0)
	if_set_add_position_x(arg_22_1, nil, arg_22_5 or 0)
	var_22_1:setPosition(30, 3)
	var_22_1:setString("")
	var_22_2:setPosition(-18, 12)
	SpriteCache:resetSprite(var_22_2, var_0_2[arg_22_2])
	
	local var_22_3 = var_22_0:getContentSize()
	
	if not var_22_0.width then
		var_22_0.width = var_22_3.width
	end
	
	var_22_0:setContentSize({
		width = 0,
		height = var_22_3.height
	})
	
	arg_22_4 = arg_22_4 or 0
	
	local var_22_4 = arg_22_0:getInfos()
	local var_22_5 = var_22_4[arg_22_3][arg_22_2]
	local var_22_6 = var_22_5 / arg_22_0.vars.highest_score[arg_22_0.vars.mode] * 0.88
	local var_22_7 = 200 + 300 * var_22_6
	local var_22_8 = arg_22_4
	
	if var_22_4[arg_22_3].is_mvp then
		var_22_7 = var_22_7 + 200
	end
	
	local var_22_9 = var_22_0.width * var_22_6
	
	if math.is_nan(var_22_7) or math.is_nan(var_22_9) then
		var_22_7 = 0
		var_22_9 = 0
	end
	
	var_22_0:setColor(var_0_0[arg_22_2])
	var_22_1:setTextColor(var_0_1[arg_22_2])
	
	if var_22_5 < 1e-07 then
		var_22_0:setOpacity(76.5)
		var_22_2:setOpacity(76.5)
		var_22_1:setOpacity(76.5)
	else
		var_22_0:setOpacity(255)
		var_22_2:setOpacity(255)
		var_22_1:setOpacity(255)
	end
	
	local var_22_10 = NONE()
	
	if var_22_5 > 0 then
		var_22_10 = TARGET(var_22_1, SPAWN(INC_NUMBER(var_22_7, var_22_5), MOVE_TO(var_22_7, 28 + var_22_9)))
	else
		var_22_1:setPositionY(-5)
	end
	
	UIAction:Add(SEQ(DELAY(var_22_8), LOG(SPAWN(var_22_10, CONTENT_SIZE(var_22_7, var_22_9, var_22_3.height)), 250)), var_22_0, "block")
end

function ResultStatUI.print(arg_23_0, arg_23_1)
	if PRODUCTION_MODE then
		return 
	end
	
	if PLATFORM ~= "win32" then
		return 
	end
	
	local var_23_0 = {}
	
	if arg_23_1 == 1 then
		for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.core.statistics or {}) do
			if iter_23_1.code then
				var_23_0[iter_23_1.code] = table.clone(iter_23_1)
				var_23_0[iter_23_1.code].unit = nil
			end
		end
	elseif arg_23_1 == 2 then
		for iter_23_2, iter_23_3 in pairs(arg_23_0.vars.infos or {}) do
			if iter_23_3.code then
				var_23_0[iter_23_3.code] = table.clone(iter_23_3)
			end
		end
	end
	
	Log.e("statistics info", table.print(var_23_0))
end

function ResultStatUI.save(arg_24_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if PLATFORM ~= "win32" then
		return 
	end
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.infos or {}) do
		iter_24_1.ally = iter_24_1.unit:getAlly()
		iter_24_1.unit = iter_24_1.unit.inst.code
	end
	
	local var_24_0 = {
		total_turn = arg_24_0.vars.core.logic:getStageCounter(),
		highest_score = arg_24_0.vars.highest_score,
		infos = arg_24_0.vars.infos
	}
	local var_24_1 = "/result_stat"
	local var_24_2 = json.encode(var_24_0)
	
	Log.i("save local to json", string.len(var_24_2))
	io.writefile(getenv("app.data_path") .. var_24_1, var_24_2)
end

function ResultStatUI.load(arg_25_0)
	if PRODUCTION_MODE then
		return 
	end
	
	if PLATFORM ~= "win32" then
		return 
	end
	
	local var_25_0 = "/result_stat"
	local var_25_1 = getenv("app.data_path") .. var_25_0
	local var_25_2 = io.open(var_25_1, "rb")
	
	if var_25_2 then
		local var_25_3 = var_25_2:read("*a")
		local var_25_4 = json.decode(var_25_3)
		
		for iter_25_0, iter_25_1 in pairs(var_25_4.infos or {}) do
			iter_25_1.unit = UNIT:create({
				code = iter_25_1.unit
			})
			iter_25_1.unit.inst.ally = iter_25_1.ally
		end
		
		Log.e("----------- 총 진행 턴수 --------------", var_25_4.total_turn)
		arg_25_0:show(nil, {
			test_data = var_25_4
		})
	end
end
