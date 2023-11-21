DescentReady = {}

function HANDLER.battle_ready_challenge(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_booster" then
		BoosterUI:show()
	elseif arg_1_1 == "btn_bonus" then
		DescentReadyBonusPopup:open()
	elseif arg_1_1 == "btn_pet" then
		if not Account:isHaveBattlePets() then
			return 
		end
		
		DescentReady:open_pet_setting_popup()
	elseif arg_1_1 == "btn_team" or arg_1_1 == "btn_info" then
		DescentReady:toggle_edit_mode()
	elseif arg_1_1 == "btn_go" then
		DescentReady:onEnter()
	elseif arg_1_1 == "btn_bossguide" then
		DescentReady:openBossGuide()
	elseif arg_1_1 == "btn_checkbox_g" then
		BattleRepeat:toggle_repeatPlay()
	end
	
	DescentReady:setNormalMode()
end

function DescentReady.show(arg_2_0, arg_2_1)
	BattleReady:hide()
	
	local var_2_0 = arg_2_1 or {}
	
	if var_2_0.enter_id and not BackPlayUtil:checkEnterableMapOnBackPlaying(var_2_0.enter_id) then
		var_2_0.enter_error_text = T("msg_bgbattle_samebattle_error")
	end
	
	arg_2_0:init(var_2_0)
end

function DescentReady.isShow(arg_3_0)
	return arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd)
end

DESCENT_TEAM_IDX = {
	23,
	24,
	25
}

function DescentReady.init(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_0.vars.wnd = load_dlg("battle_ready_challenge", true, "wnd")
	
	if_set_opacity(arg_4_0.vars.wnd, "btn_pet", Account:isHaveBattlePets() and 255 or 76.5)
	if_set_opacity(arg_4_0.vars.wnd, "n_none_pet", Account:isHaveBattlePets() and 255 or 76.5)
	SceneManager:getRunningNativeScene():addChild(arg_4_0.vars.wnd)
	
	arg_4_0.vars.team1 = Account:getTeam(DESCENT_TEAM_IDX[1])
	arg_4_0.vars.team2 = Account:getTeam(DESCENT_TEAM_IDX[2])
	arg_4_0.vars.team3 = Account:getTeam(DESCENT_TEAM_IDX[3])
	arg_4_0.vars.opts = arg_4_1
	arg_4_0.vars.opts.is_descent = true
	arg_4_0.vars.enter_id = arg_4_1.enter_id
	
	local var_4_0 = DB("level_enter", arg_4_1.enter_id, "substory_contents_id")
	
	arg_4_0.vars.sub_story = SubstoryManager:makeInfo(var_4_0)
	
	if not arg_4_0.vars.sub_story then
		Log.e("DescentReady.init", "invalid_substory_info")
		
		return 
	end
	
	arg_4_0.vars.opts.sub_story = arg_4_0.vars.sub_story
	
	local var_4_1 = SubStoryUtil:getTopbarCurrencies(arg_4_0.vars.sub_story, {
		"crystal",
		"gold",
		"stamina"
	})
	local var_4_2 = "descent_temp"
	
	TopBarNew:createFromPopup(T(var_4_2), arg_4_0.vars.wnd, function()
		DescentReady:leave()
	end, var_4_1, "infosubs_7")
	TopBarNew:setDisableLobbyAuto()
	
	local var_4_3, var_4_4, var_4_5, var_4_6, var_4_7, var_4_8 = DB("level_enter", arg_4_1.enter_id, {
		"use_enterpoint",
		"type",
		"contents_type",
		"enter_limit",
		"type_enterpoint",
		"use_enterpoint"
	})
	
	arg_4_0.vars.req = var_4_3
	arg_4_0.vars.level_type = var_4_4
	arg_4_0.vars.contents_type = var_4_5
	arg_4_0.vars.enter_limit = var_4_6
	arg_4_0.vars.type_enterpoint = var_4_7
	arg_4_0.vars.use_enterpoint = var_4_8
	
	BoosterUI:update(arg_4_0.vars.wnd)
	
	local var_4_9 = arg_4_0.vars.wnd:getChildByName("btn_go")
	
	if get_cocos_refid(var_4_9) then
		arg_4_0.vars.enterable, arg_4_0.vars.lack_enter_item = UIUtil:setButtonEnterInfo(var_4_9, arg_4_0.vars.enter_id, arg_4_0.vars.opts)
		
		if_set_visible(var_4_9, "icon_res", true)
		
		local var_4_10 = true
		local var_4_11, var_4_12, var_4_13 = Account:getEnterLimitInfo(arg_4_0.vars.enter_id)
		
		if var_4_11 and var_4_11 < 1 then
			var_4_10 = false
		end
		
		UIUtil:changeButtonState(var_4_9, arg_4_0.vars.opts.enter_error_text == nil and var_4_10)
		
		arg_4_0.vars.enter_rest = var_4_11
		
		if var_4_11 and var_4_12 then
			arg_4_0:updateLimit(var_4_11, var_4_12)
		end
	end
	
	arg_4_0:initFormations()
	BattleRepeat:init_repeatCheckbox(arg_4_0.vars.wnd:getChildByName("n_check_box"), arg_4_0.vars.enter_id)
	arg_4_0:update_pet()
	arg_4_0:init_boss_info_ui()
	
	arg_4_0.vars.edit_mode = false
	
	if_set_visible(arg_4_0.vars.wnd, "btn_info", false)
	if_set_visible(arg_4_0.vars.wnd, "btn_team", true)
	arg_4_0:init_stage_info_ui()
	TutorialGuide:procGuide()
end

function DescentReady.updateLimit(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_1 and arg_6_2 then
		local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_limit")
		
		if var_6_0 then
			var_6_0:setVisible(true)
			
			local var_6_1 = arg_6_1 == nil or arg_6_1 > 0
			local var_6_2
			
			if var_6_1 then
				var_6_2 = "level_enter_limit_desc"
				
				local var_6_3 = string.format("%d/%d", math.min(arg_6_2, math.max(arg_6_1, 0)), arg_6_2)
				
				if_set(var_6_0, "t_count", var_6_3)
			else
				var_6_2 = "battle_cant_getin"
				
				if_set_visible(var_6_0, "t_count", false)
			end
			
			if_set(var_6_0, "disc", T(var_6_2))
			
			local var_6_4 = var_6_0:getChildByName("t_count")
			local var_6_5 = var_6_0:getChildByName("disc")
			
			var_6_4:setPositionX(var_6_5:getContentSize().width + 7)
			
			local var_6_6 = var_6_2 == "level_enter_limit_desc" and 60 or 20
			
			if arg_6_2 >= 10 then
				var_6_6 = var_6_6 + 8
				
				if arg_6_1 >= 10 then
					var_6_6 = var_6_6 + 8
				end
			end
			
			UIUserData:call(var_6_0:getChildByName("talk_small_bg"), string.format("AUTOSIZE_WIDTH(disc, 1, %d)", var_6_6))
		end
	end
end

function DescentReady.initFormations(arg_7_0)
	local var_7_0 = load_dlg("battle_ready_challenge_formation", true, "wnd")
	local var_7_1 = load_dlg("battle_ready_challenge_formation", true, "wnd")
	local var_7_2 = load_dlg("battle_ready_challenge_formation", true, "wnd")
	
	if_set_visible(var_7_0, "bar_visible", false)
	arg_7_0.vars.wnd:getChildByName("round1"):addChild(var_7_0)
	arg_7_0.vars.wnd:getChildByName("round2"):addChild(var_7_1)
	arg_7_0.vars.wnd:getChildByName("round3"):addChild(var_7_2)
	
	arg_7_0.vars.group_wnd_1 = var_7_0
	arg_7_0.vars.group_wnd_2 = var_7_1
	arg_7_0.vars.group_wnd_3 = var_7_2
	
	var_7_0:setAnchorPoint(0, 0)
	var_7_1:setAnchorPoint(0, 0)
	var_7_2:setAnchorPoint(0, 0)
	var_7_0:setPosition(0, 0)
	var_7_1:setPosition(0, 0)
	var_7_2:setPosition(0, 0)
	
	local var_7_3 = {
		{
			max_unit = 3,
			group_name = "descent_team1",
			can_edit = true,
			wnd = var_7_0,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4,
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 1
				})
			},
			descent_team_idx = DESCENT_TEAM_IDX[1]
		},
		{
			max_unit = 3,
			group_name = "descent_team2",
			can_edit = true,
			wnd = var_7_1,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4,
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 2
				})
			},
			descent_team_idx = DESCENT_TEAM_IDX[2]
		},
		{
			max_unit = 3,
			group_name = "descent_team3",
			can_edit = true,
			wnd = var_7_2,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4,
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 3
				})
			},
			descent_team_idx = DESCENT_TEAM_IDX[3]
		}
	}
	local var_7_4 = {}
	
	GroupFormationEditor:initFormationEditor(var_7_4, {
		least_unit = 0,
		hide_hpbar = true,
		sprite_mode = true,
		is_descent = true,
		useSimpleTag = true,
		hide_hpbar_color = true,
		tagScale = 1,
		tagOffsetY = 45,
		max_unit = 3,
		notUseTouchHandler = true,
		infos = var_7_3,
		ui_handler = function(arg_8_0, arg_8_1)
			arg_7_0:set_edit_mode()
		end,
		onFormationResEvent_UpdateFormation = function()
			arg_7_0:updateAllyTeamFormation()
		end,
		onFormationResEvent_UpdateTeamPoint = function()
			arg_7_0:updateAllyTeamPoint()
		end,
		callbackUpdateFormation = function(arg_11_0)
			HeroBelt:updateTeamMarkers()
			DescentReady:updateUI_all()
			DescentReady:updateTeamArtifactBonus()
		end,
		callbackSelectUnit = function(arg_12_0)
			arg_7_0:set_edit_mode()
			HeroBelt:scrollToUnit(arg_12_0)
		end,
		callbackSelectTeam = function(arg_13_0)
			arg_7_0:setTeam(arg_13_0)
		end,
		callbackUpdatePoint = function(arg_14_0)
			arg_7_0:updateFormationUI(arg_14_0)
		end,
		callbackCanAddUnit = function(arg_15_0)
			return true
		end
	})
	
	for iter_7_0 = 1, 3 do
		local var_7_5 = arg_7_0.vars.sub_story["descent_powerup" .. iter_7_0]
		local var_7_6 = arg_7_0.vars["group_wnd_" .. iter_7_0]
		
		arg_7_0.vars["team_cs_" .. iter_7_0] = {}
		
		if var_7_5 and var_7_6 then
			local var_7_7 = string.split(var_7_5, ",")
			
			for iter_7_1, iter_7_2 in pairs(var_7_7) do
				local var_7_8, var_7_9, var_7_10 = DB("cs_monster_descent", iter_7_2, {
					"id",
					"cs_refer",
					"descent_icon"
				})
				
				if var_7_8 and var_7_9 and var_7_10 then
					local var_7_11 = tonumber(var_7_9) * 100 .. "%"
					
					table.insert(arg_7_0.vars["team_cs_" .. iter_7_0], {
						id = iter_7_2,
						cs_refer = var_7_11,
						descent_icon = var_7_10
					})
					
					if iter_7_1 == 1 then
						if_set(var_7_6, "txt_up_point", var_7_11)
						if_set_sprite(var_7_6, "icon_stat", "img/" .. var_7_10 .. ".png")
					end
				end
			end
		end
	end
	
	arg_7_0.vars.group_editor = var_7_4
	
	arg_7_0:createHeroBelt("decent")
	arg_7_0:updateGroupFormation()
end

function DescentReady.openBossGuide(arg_16_0)
	BossGuide:show({
		enter_id = arg_16_0.vars.enter_id,
		parent = arg_16_0.vars.wnd
	})
end

function DescentReady.setNormalMode(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) or not arg_17_0.vars.group_editor then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.group_editor
	
	if var_17_0 then
		var_17_0:setNormalMode()
	end
end

function DescentReady.createHeroBelt(arg_18_0, arg_18_1)
	if not arg_18_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_18_0.vars.unit_dock) then
		arg_18_0.vars.unit_doc = nil
		
		HeroBelt:destroy()
	end
	
	arg_18_0.vars.unit_dock = HeroBelt:create(arg_18_1)
	
	arg_18_0.vars.unit_dock:setEventHandler(arg_18_0.onHeroListEvent, arg_18_0)
	arg_18_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_18_0.vars.wnd:addChild(arg_18_0.vars.unit_dock:getWindow())
	
	local var_18_0 = arg_18_0:checkHeros()
	
	HeroBelt:resetData(var_18_0, arg_18_1, nil, nil, nil)
	
	local var_18_1 = arg_18_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_18_0.vars.unit_dock:getWindow():setPositionX(var_18_1)
end

function DescentReady.checkHeros(arg_19_0)
	local var_19_0 = {}
	
	return (table.shallow_clone(Account.units))
end

function DescentReady.onHeroListEvent(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_0.vars and arg_20_0.vars.group_editor then
		arg_20_0.vars.group_editor:onHeroListEventForFormationEditor(arg_20_1, arg_20_2, arg_20_3)
		arg_20_0:setUnitBar(arg_20_1, arg_20_2, arg_20_3)
	end
end

function DescentReady.setUnitBar(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_1 == "change" then
		local var_21_0 = HeroBelt:getControl(arg_21_2)
		
		if var_21_0 then
			if_set_visible(var_21_0, "add", false)
		end
		
		local var_21_1 = HeroBelt:getControl(arg_21_3)
		
		if var_21_1 then
			if_set_visible(var_21_1, "add", true)
		end
	end
end

function DescentReady.updateGroupFormation(arg_22_0)
	arg_22_0.vars.group_editor:updateGroupFormation("descent_team1", DESCENT_TEAM_IDX[1])
	arg_22_0.vars.group_editor:updateGroupFormation("descent_team2", DESCENT_TEAM_IDX[2])
	arg_22_0.vars.group_editor:updateGroupFormation("descent_team3", DESCENT_TEAM_IDX[3])
end

function DescentReady.updateTeamArtifactBonus(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.wnd:getChildByName("btn_bonus")
	
	if not get_cocos_refid(var_23_0) then
		return 
	end
	
	local var_23_1 = {}
	local var_23_2 = 0
	
	for iter_23_0 = 1, 3 do
		local var_23_3 = arg_23_0.vars["team" .. iter_23_0] or {}
		
		if table.empty(var_23_3) then
			var_23_2 = var_23_2 + 1
		else
			table.insert(var_23_1, var_23_3)
		end
	end
	
	if table.empty(var_23_1) or var_23_2 >= 3 then
		if_set_opacity(var_23_0, nil, 102)
		if_set_opacity(var_23_0, "img", 255)
		if_set_opacity(var_23_0, "icon_order", 255)
		if_set(var_23_0, "txt_booster_cnt", "")
		if_set_visible(var_23_0, "n_cnt", false)
		if_set_color(var_23_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	arg_23_0.vars.test = var_23_1
	
	local var_23_4 = 0
	local var_23_5 = 0
	local var_23_6 = 0
	
	for iter_23_1, iter_23_2 in pairs(var_23_1) do
		if not table.empty(iter_23_2) then
			local var_23_7 = Team:getGrowthBonusArtifactsCount(iter_23_2, arg_23_0.vars.level_type)
			local var_23_8 = Team:getSubStoryCurrencyBonusArtifactsCount(iter_23_2, SubstoryManager:getArtifactBonusInfo(), arg_23_0.vars.enter_id)
			
			var_23_6 = var_23_6 + var_23_7 + var_23_8
		end
	end
	
	if var_23_6 == 0 then
		if_set_opacity(var_23_0, nil, 102)
		if_set_opacity(var_23_0, "img", 255)
		if_set_opacity(var_23_0, "icon_order", 255)
		if_set(var_23_0, "txt_booster_cnt", "")
		if_set_visible(var_23_0, "n_cnt", false)
		if_set_color(var_23_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	local var_23_9 = 0
	local var_23_10 = 0
	local var_23_11 = 0
	
	for iter_23_3, iter_23_4 in pairs(var_23_1) do
		if not table.empty(iter_23_4) then
			local var_23_12 = Team:getGrowthBonusApplyArtifactsCount(iter_23_4, arg_23_0.vars.level_type)
			
			var_23_11 = Team:getSubStoryCurrencyBonusApplyArtifactsCount(iter_23_4, SubstoryManager:getArtifactBonusInfo(), arg_23_0.vars.enter_id) + var_23_12 + var_23_11
		end
	end
	
	if var_23_11 == 0 then
		if_set_opacity(var_23_0, nil, 255)
		if_set_opacity(var_23_0, "img", 102)
		if_set_opacity(var_23_0, "icon_order", 102)
		if_set_visible(var_23_0, "n_cnt", false)
		if_set_visible(var_23_0, "n_cnt_off", true)
		if_set(var_23_0:getChildByName("n_cnt_off"), "txt_booster_cnt", "+" .. var_23_6)
		if_set_color(var_23_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	if_set_opacity(var_23_0, nil, 255)
	if_set_opacity(var_23_0, "img", 255)
	if_set_opacity(var_23_0, "icon_order", 255)
	if_set_visible(var_23_0, "n_cnt", true)
	if_set(var_23_0:getChildByName("n_cnt"), "txt_booster_cnt", "+" .. var_23_11)
	if_set_visible(var_23_0, "n_cnt_off", false)
	if_set_color(var_23_0, "icon_order", cc.c3b(255, 120, 0))
end

function DescentReady.updateUI_all(arg_24_0)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	local var_24_0 = false
	local var_24_1 = {
		arg_24_0.vars.group_wnd_1,
		arg_24_0.vars.group_wnd_2,
		arg_24_0.vars.group_wnd_3
	}
	
	for iter_24_0 = 1, 3 do
		local var_24_2 = arg_24_0.vars["team" .. iter_24_0] or {}
		local var_24_3 = var_24_1[iter_24_0]
		local var_24_4 = {
			"wind",
			"fire",
			"ice",
			"dark",
			"light"
		}
		local var_24_5 = {}
		
		for iter_24_1, iter_24_2 in pairs(var_24_4) do
			var_24_5[iter_24_2] = 0
		end
		
		for iter_24_3, iter_24_4 in pairs(var_24_2) do
			if iter_24_4.getColor then
				local var_24_6 = iter_24_4:getColor()
				
				if not var_24_5[var_24_6] then
					var_24_5[var_24_6] = 0
				end
				
				var_24_5[var_24_6] = var_24_5[var_24_6] + 1
			end
		end
		
		local var_24_7 = table.count(var_24_2)
		
		if var_24_2[7] then
			var_24_7 = var_24_7 - 1
		end
		
		if not var_24_0 and var_24_7 < 1 then
			var_24_0 = true
		end
		
		local var_24_8 = 2
		local var_24_9
		local var_24_10 = 0
		
		for iter_24_5, iter_24_6 in pairs(var_24_5) do
			if var_24_8 <= iter_24_6 then
				var_24_9 = iter_24_5
				var_24_10 = iter_24_6
				
				break
			end
		end
		
		local function var_24_11(arg_25_0, arg_25_1)
			if not arg_25_0 or not arg_25_1 then
				return 
			end
			
			local var_25_0 = arg_25_1
			local var_25_1 = "img/cm_icon_pro"
			
			if var_25_0 == "light" or var_25_0 == "dark" then
				var_25_1 = var_25_1 .. "m"
			end
			
			local var_25_2 = var_25_1 .. var_25_0 .. ".png"
			
			if_set_sprite(arg_25_0, "icon_element", var_25_2)
		end
		
		local var_24_12 = var_24_3:getChildByName("n_reinforce_element")
		
		if_set_visible(var_24_12, "n_info", var_24_10 < var_24_8)
		if_set_visible(var_24_12, "n_reinforce", var_24_8 <= var_24_10)
		var_24_11(var_24_12, var_24_9)
		
		if var_24_8 <= var_24_10 then
			if_set(var_24_12, "t_count", var_24_10)
			if_set_visible(var_24_12, "n_up1", var_24_8 <= var_24_10)
			if_set_opacity(var_24_12, "n_up2", var_24_10 >= 3 and 255 or 76.5)
			if_set(var_24_12, "txt_up_point", "20%")
		end
		
		local var_24_13 = arg_24_0.vars["team_cs_" .. iter_24_0]
		
		if var_24_13 then
			local var_24_14 = var_24_13[var_24_10 - 1]
			
			if var_24_14 and var_24_14.cs_refer and var_24_14.descent_icon then
				if_set(var_24_3, "txt_up_point", var_24_14.cs_refer)
				if_set_sprite(var_24_3, "icon_stat", "img/" .. var_24_14.descent_icon .. ".png")
			end
		end
	end
	
	if arg_24_0.vars.enter_rest and arg_24_0.vars.enter_rest <= 0 or var_24_0 then
		if_set_opacity(arg_24_0.vars.wnd, "btn_go", 76.5)
	else
		if_set_opacity(arg_24_0.vars.wnd, "btn_go", 255)
	end
end

function DescentReady.update_pet(arg_26_0)
	local var_26_0 = Account:getPetInTeam(Account:getDescentPetTeamIdx())
	local var_26_1 = arg_26_0.vars.wnd:getChildByName("base_pet")
	
	if_set_visible(var_26_1, "n_none_pet", not var_26_0)
	if_set_visible(var_26_1, "n_pet", var_26_0)
	
	if var_26_0 then
		local var_26_2 = var_26_1:getChildByName("pos7")
		
		if not var_26_2 then
			print("Not Have Pos!")
		end
		
		var_26_2:removeAllChildren()
		
		if not var_26_0 then
			return 
		end
		
		local var_26_3 = UIUtil:getRewardIcon(nil, var_26_0:getDisplayCode(), {
			no_popup = true,
			role = true,
			no_db_grade = true,
			lv = var_26_0:getLv(),
			max_lv = var_26_0:getMaxLevel(),
			grade = var_26_0:getGrade()
		})
		
		var_26_3:setName("model")
		var_26_2:addChild(var_26_3)
	end
	
	if false then
	end
	
	arg_26_0:update_repeatCount(var_26_0)
end

function DescentReady.update_repeatCount(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	local var_27_0 = arg_27_1 or Account:getPetInTeam(Account:getDescentPetTeamIdx())
	local var_27_1 = arg_27_0.vars.wnd
	
	if not get_cocos_refid(var_27_1) then
		return 
	end
	
	local var_27_2 = var_27_1:getChildByName("n_check_box")
	
	if not get_cocos_refid(var_27_2) then
		return 
	end
	
	local var_27_3, var_27_4 = BattleRepeat:getConfigRepeatBattleCount(Account:getDescentPetTeamIdx())
	
	if var_27_0 and var_27_0.getRepeat_count then
		local var_27_5 = var_27_0:getRepeat_count()
		
		if var_27_5 < var_27_3 or var_27_4 then
			var_27_3 = var_27_5
		end
	end
	
	if not var_27_0 then
		var_27_3 = 0
	end
	
	BattleRepeat:set_checkBox(var_27_0 ~= nil, arg_27_0.vars.enter_id)
	if_set(var_27_2, "label", var_27_3)
end

function DescentReady.getEnterID(arg_28_0)
	if not arg_28_0.vars or not arg_28_0.vars.enter_id then
		return 
	end
	
	return arg_28_0.vars.enter_id
end

function DescentReady.open_pet_setting_popup(arg_29_0)
	local var_29_0 = DESCENT_TEAM_IDX[1]
	
	PetSettingPopup:init({
		mode = "Descent",
		team_idx = var_29_0,
		close_callback = function(arg_30_0)
			if arg_30_0 then
				Account:saveTeamInfo(nil, {
					is_descent = true
				})
			end
			
			arg_29_0:update_pet()
		end
	})
end

function DescentReady.getTeamData(arg_31_0, arg_31_1)
	return arg_31_0.vars["team" .. arg_31_1] or {}
end

function DescentReady.getTeamBonus(arg_32_0, arg_32_1)
	local var_32_0 = "v1002a004"
	local var_32_1 = "quest"
	local var_32_2 = Team:getGrowthBonusArtifacts(arg_32_0:getTeamData(arg_32_1), var_32_1)
	
	table.sort(var_32_2, function(arg_33_0, arg_33_1)
		if arg_33_0.is_apply == arg_33_1.is_apply then
			return false
		end
		
		return arg_33_0.is_apply or not arg_33_1.is_apply
	end)
	
	return var_32_2
end

function DescentReady.init_boss_info_ui(arg_34_0)
	local var_34_0 = arg_34_0.vars.enter_id
	local var_34_1 = arg_34_0.vars.wnd:getChildByName("n_content")
	local var_34_2, var_34_3, var_34_4 = BattleReady:GetReqPointAndRewards(var_34_0)
	
	arg_34_0.vars.req_point = var_34_2
	
	if DBT("level_enter", var_34_0, {
		"hide_battle_power",
		"cp_material",
		"cp_value"
	}).hide_battle_power == "y" then
		arg_34_0.vars.req_point = 0
	end
	
	local var_34_5 = to_n(Account:getMapClearCount(var_34_0))
	local var_34_6 = {}
	
	for iter_34_0, iter_34_1 in pairs(var_34_3) do
		table.push(var_34_6, {
			iter_34_1.m,
			iter_34_1.lv,
			iter_34_1.tier
		})
	end
	
	table.sort(var_34_6, function(arg_35_0, arg_35_1)
		if arg_35_0[3] ~= arg_35_1[3] then
			if arg_35_0[3] == "boss" then
				return true
			end
			
			if arg_35_1[3] == "boss" then
				return false
			end
			
			if arg_35_0[3] == "subboss" then
				return true
			end
			
			if arg_35_1[3] == "subboss" then
				return false
			end
			
			if arg_35_0[3] == "elite" then
				return true
			end
			
			if arg_35_1[3] == "elite" then
				return false
			end
			
			return false
		end
		
		return arg_35_0[2] > arg_35_1[2]
	end)
	
	local var_34_7 = arg_34_0.vars.wnd:getChildByName("n_boss_info")
	local var_34_8, var_34_9 = DB("level_enter", var_34_0, {
		"randomability",
		"type"
	})
	
	if var_34_9 == "quest" or var_34_9 == "dungeon_quest" or var_34_9 == "defense_quest" or var_34_9 == "descent" then
		for iter_34_2, iter_34_3 in pairs(var_34_6) do
			if get_cocos_refid(var_34_7) and iter_34_3[3] == "boss" then
				local var_34_10, var_34_11 = DB("character_monster_descent", iter_34_3[1], {
					"id",
					"name"
				})
				
				if var_34_11 then
					if_set(var_34_7, "t_boss_name", T(var_34_11))
				end
				
				UIUtil:getRewardIcon("c", iter_34_3[1], {
					no_db_grade = true,
					dlg_name = "battle_ready_descent",
					hide_star = true,
					monster = true,
					parent = var_34_7:getChildByName("mob_icon"),
					lv = iter_34_3[2],
					tier = iter_34_3[3]
				})
			end
		end
	end
	
	arg_34_0.vars.ScrollEnemy = {}
	
	copy_functions(ScrollView, arg_34_0.vars.ScrollEnemy)
	
	function arg_34_0.vars.ScrollEnemy.getScrollViewItem(arg_36_0, arg_36_1)
		return UIUtil:getRewardIcon("c", arg_36_1[1], {
			no_db_grade = true,
			scale = 0.85,
			dlg_name = "battle_ready_descent",
			hide_star = true,
			monster = true,
			lv = arg_36_1[2],
			tier = arg_36_1[3]
		})
	end
	
	function arg_34_0.vars.ScrollEnemy.onSelectScrollViewItem(arg_37_0, arg_37_1, arg_37_2)
	end
	
	local var_34_12 = var_34_1:getChildByName("scroll_enemy")
	
	arg_34_0.vars.ScrollEnemy:initScrollView(var_34_12, 75, 75)
	arg_34_0.vars.ScrollEnemy:createScrollViewItems(var_34_6)
	var_34_12:jumpToPercentVertical(0)
	var_34_12:jumpToPercentHorizontal(0)
	
	arg_34_0.vars.ScrollItems = {}
	
	copy_functions(ScrollView, arg_34_0.vars.ScrollItems)
	
	function arg_34_0.vars.ScrollItems.getScrollViewItem(arg_38_0, arg_38_1)
		local var_38_0 = {
			dlg_name = "battle_ready_descent",
			scale = 0.8,
			grade_max = true,
			set_drop = arg_38_1[3],
			grade_rate = arg_38_1[4]
		}
		
		if string.starts(arg_38_1[1], "e") and DB("equip_item", arg_38_1[1], "type") == "artifact" then
			var_38_0.scale = 0.66
		end
		
		local var_38_1
		
		if var_34_9 == "abyss" then
			var_38_1 = arg_38_1[2]
		end
		
		return UIUtil:getRewardIcon(var_38_1, arg_38_1[1], var_38_0)
	end
	
	function arg_34_0.vars.ScrollItems.onSelectScrollViewItem(arg_39_0, arg_39_1, arg_39_2)
	end
	
	local var_34_13 = var_34_1:getChildByName("scroll_item")
	
	var_34_13:removeAllChildren()
	arg_34_0.vars.ScrollItems:initScrollView(var_34_13, 82, 82, {
		skip_anchor = true
	})
	arg_34_0.vars.ScrollItems:createScrollViewItems(var_34_4)
end

function DescentReady.init_stage_info_ui(arg_40_0)
	local var_40_0 = arg_40_0.vars.unit_dock:getWindow()
	local var_40_1 = arg_40_0.vars.wnd:getChildByName("n_content")
	
	if not get_cocos_refid(var_40_0) or not get_cocos_refid(var_40_1) then
		return 
	end
	
	if not var_40_0.origin_x then
		var_40_0.origin_x = var_40_0:getPositionX()
		var_40_0.origin_y = var_40_0:getPositionY()
		var_40_0.move_to_x = 1040
		var_40_1.origin_x = var_40_1:getPositionX()
		var_40_1.origin_y = var_40_1:getPositionY()
		var_40_1.move_to_x = 1240
	end
	
	var_40_0:setPositionX(var_40_0.move_to_x)
	var_40_0:setVisible(false)
	var_40_1:setVisible(true)
	
	local var_40_2, var_40_3, var_40_4 = DB("level_enter", arg_40_0.vars.enter_id, {
		"name",
		"local",
		"type"
	})
	
	if_set(var_40_1, "txt_zone", T(var_40_3))
	if_set(var_40_1, "txt_title", T(var_40_2))
end

function DescentReady.set_edit_mode(arg_41_0)
	if not arg_41_0.vars.edit_mode then
		arg_41_0:toggle_edit_mode()
	end
end

function DescentReady.toggle_edit_mode(arg_42_0)
	local var_42_0 = arg_42_0.vars.unit_dock:getWindow()
	local var_42_1 = arg_42_0.vars.wnd:getChildByName("n_content")
	
	if not get_cocos_refid(var_42_0) or not get_cocos_refid(var_42_1) then
		return 
	end
	
	local var_42_2 = var_42_0:getPositionY()
	local var_42_3 = 400
	
	arg_42_0.vars.edit_mode = not arg_42_0.vars.edit_mode
	
	if arg_42_0.vars.edit_mode then
		if_set_visible(arg_42_0.vars.wnd, "btn_info", true)
		if_set_visible(arg_42_0.vars.wnd, "btn_team", false)
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(var_42_3, var_42_0.origin_x, var_42_0.origin_y), var_42_3)), var_42_0, "block")
		UIAction:Add(SEQ(RLOG(MOVE_TO(var_42_3, var_42_1.move_to_x, var_42_1.origin_y), var_42_3), SHOW(false)), var_42_1, "block")
		SoundEngine:play("event:/ui/whoosh_a")
	else
		if_set_visible(arg_42_0.vars.wnd, "btn_info", false)
		if_set_visible(arg_42_0.vars.wnd, "btn_team", true)
		UIAction:Add(SEQ(RLOG(MOVE_TO(var_42_3, var_42_0.move_to_x, var_42_0.origin_y), var_42_3), SHOW(false)), var_42_0, "block")
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(var_42_3, var_42_1.origin_x, var_42_1.origin_y), var_42_3)), var_42_1, "block")
		SoundEngine:play("event:/ui/whoosh_a")
	end
end

function DescentReady.updateButtons(arg_43_0)
	arg_43_0:updateEnterButton()
end

function DescentReady.updateEnterButton(arg_44_0)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	local var_44_0 = arg_44_0.vars.wnd:getChildByName("btn_go")
	
	if get_cocos_refid(var_44_0) then
		arg_44_0.vars.enterable, arg_44_0.vars.lack_enter_item = UIUtil:setButtonEnterInfo(var_44_0, arg_44_0.vars.enter_id, arg_44_0.vars.opts)
		
		if_set_visible(var_44_0, "icon_res", true)
		
		local var_44_1 = true
		local var_44_2, var_44_3, var_44_4 = Account:getEnterLimitInfo(arg_44_0.vars.enter_id)
		
		if var_44_2 and var_44_2 < 1 then
			var_44_1 = false
		end
		
		UIUtil:changeButtonState(var_44_0, arg_44_0.vars.opts.enter_error_text == nil and var_44_1)
	end
end

function DescentReady.procCheckEnter(arg_45_0)
	if not UIUtil:checkUnitInven() then
		return 
	end
	
	if not UIUtil:checkTotalInven() then
		return 
	end
	
	for iter_45_0, iter_45_1 in pairs(DESCENT_TEAM_IDX) do
		local var_45_0 = Account:getTeamMemberCount(iter_45_1, true)
		
		if var_45_0 < 1 or var_45_0 >= 4 then
			balloon_message_with_sound("msg_descent_team_min")
			
			return 
		end
	end
	
	return true
end

function DescentReady.onEnter(arg_46_0)
	if not arg_46_0:procCheckEnter() then
		return 
	end
	
	if not arg_46_0.vars.enterable and arg_46_0.vars.lack_enter_item then
		if arg_46_0.vars.lack_enter_item == "to_stamina" then
			UIUtil:wannaBuyStamina("battle.ready")
			
			return 
		end
		
		if DB("item_material", arg_46_0.vars.lack_enter_item, "id") then
			balloon_message_with_sound("not_enough_enter_item")
		end
		
		return 
	end
	
	SoundEngine:play("event:/ui/battle_ready/btn_go")
	BattleRepeat:initBeforeBattleStart(Account:getDescentPetTeamIdx(), arg_46_0.vars.enter_id, arg_46_0.vars.opts)
	startBattle(arg_46_0.vars.enter_id, arg_46_0.vars.opts)
end

DescentReadyBonusPopup = {}

function HANDLER.artifact_bonus_challenge(arg_47_0, arg_47_1)
	if arg_47_1 == "btn_team" then
		DescentReadyBonusPopup:select_tab(tonumber(string.sub(arg_47_0:getParent():getName(), -1, -1)))
	elseif arg_47_1 == "btn_close" then
		DescentReadyBonusPopup:close()
	end
end

function DescentReadyBonusPopup.open(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_1 or {}
	
	var_48_0.bonus_info = {}
	var_48_0.parent_layer = SceneManager:getRunningNativeScene()
	var_48_0.bonus_info.bonus1 = DescentReady:getTeamBonus(1)
	var_48_0.bonus_info.bonus2 = DescentReady:getTeamBonus(2)
	var_48_0.bonus_info.bonus3 = DescentReady:getTeamBonus(3)
	
	for iter_48_0 = 1, 3 do
		local var_48_1 = DescentReady:getTeamBonus(iter_48_0)
		
		var_48_0.bonus_info["bonus" .. iter_48_0] = var_48_1
	end
	
	arg_48_0:init(var_48_0)
	arg_48_0:updateInfo()
end

function DescentReadyBonusPopup.init(arg_49_0, arg_49_1)
	if not arg_49_1.bonus_info or table.empty(arg_49_1.bonus_info) then
		return 
	end
	
	arg_49_0.vars = {}
	arg_49_0.vars.wnd = load_dlg("artifact_bonus_challenge", true, "wnd", function()
		DescentReadyBonusPopup:close()
	end)
	
	arg_49_1.parent_layer:addChild(arg_49_0.vars.wnd)
	
	arg_49_0.vars.bonus_info = arg_49_1.bonus_info
	arg_49_0.vars.listview = ItemListView:bindControl(arg_49_0.vars.wnd:getChildByName("listview"))
	
	local var_49_0 = {
		onUpdate = function(arg_51_0, arg_51_1, arg_51_2)
			local var_51_0 = arg_51_1:getChildByName("n_artifact_bonus_item")
			
			if get_cocos_refid(var_51_0) then
				var_51_0:removeAllChildren()
				
				local var_51_1 = load_control("wnd/artifact_bonus_item.csb")
				
				var_51_0:addChild(var_51_1)
				var_51_1:setName("artifact_bonus_item")
			end
			
			ArtifactBonus:updateGrowthListItem(arg_51_1, arg_51_2)
		end
	}
	
	arg_49_0.vars.listview:setRenderer(load_control("wnd/artifact_bonus_item_base.csb"), var_49_0)
	
	arg_49_0.vars.team_idx = 1
	
	arg_49_0:select_tab(arg_49_0.vars.team_idx)
end

function DescentReadyBonusPopup.select_tab(arg_52_0, arg_52_1)
	arg_52_0.vars.team_idx = arg_52_1
	
	for iter_52_0 = 1, 3 do
		local var_52_0 = arg_52_0.vars.bonus_info["bonus" .. iter_52_0]
		local var_52_1 = arg_52_0.vars.wnd:getChildByName("tab" .. iter_52_0)
		
		if_set_visible(var_52_1, nil, var_52_0)
		if_set_visible(var_52_1, "selected", arg_52_0.vars.team_idx == iter_52_0)
	end
	
	arg_52_0:updateInfo()
end

function DescentReadyBonusPopup.updateInfo(arg_53_0)
	arg_53_0.vars.listview:setItems(arg_53_0.vars.bonus_info["bonus" .. arg_53_0.vars.team_idx])
	if_set_visible(arg_53_0.vars.wnd, "n_no_growth", table.empty(arg_53_0.vars.bonus_info["bonus" .. arg_53_0.vars.team_idx]))
end

function DescentReadyBonusPopup.close(arg_54_0)
	arg_54_0.vars.wnd:removeFromParent()
	
	arg_54_0.vars = nil
end

function DescentReady.updateAllyTeamFormation(arg_55_0)
	local var_55_0 = table.shallow_clone(arg_55_0.vars.team1)
	local var_55_1 = table.shallow_clone(arg_55_0.vars.team2)
	local var_55_2 = table.shallow_clone(arg_55_0.vars.team3)
	
	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		if not Account:getUnit(iter_55_1:getUID()) then
			arg_55_0.vars.team1[iter_55_0] = nil
		end
	end
	
	for iter_55_2, iter_55_3 in pairs(var_55_1) do
		if not Account:getUnit(iter_55_3:getUID()) then
			arg_55_0.vars.team2[iter_55_2] = nil
		end
	end
	
	for iter_55_4, iter_55_5 in pairs(var_55_2) do
		if not Account:getUnit(iter_55_5:getUID()) then
			arg_55_0.vars.team3[iter_55_4] = nil
		end
	end
	
	arg_55_0.vars.group_editor:updateGroupFormation("descent_team1", arg_55_0.vars.team1)
	arg_55_0.vars.group_editor:updateGroupFormation("descent_team2", arg_55_0.vars.team2)
	arg_55_0.vars.group_editor:updateGroupFormation("descent_team3", arg_55_0.vars.team3)
end

function DescentReady.updateAllyTeamPoint(arg_56_0)
	arg_56_0.vars.group_editor:updateGroupTeamPoint("descent_team1", arg_56_0.vars.team1)
	arg_56_0.vars.group_editor:updateGroupTeamPoint("descent_team2", arg_56_0.vars.team2)
	arg_56_0.vars.group_editor:updateGroupTeamPoint("descent_team3", arg_56_0.vars.team3)
end

function DescentReady.updateFormationUI(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_1 or {}
	
	if var_57_0.wnd and var_57_0.pre and var_57_0.cur then
		local var_57_1 = var_57_0.wnd:getChildByName("txt_point")
		
		if var_57_1 then
			UIAction:Add(INC_NUMBER(400, var_57_0.cur, nil, var_57_0.pre), var_57_1)
		end
	end
end

function DescentReady.leave(arg_58_0)
	Account:saveTeamInfo(nil, {
		is_descent = true
	})
	arg_58_0.vars.wnd:removeFromParent()
	
	arg_58_0.vars = nil
	
	local var_58_0 = "descent_temp"
	
	BackButtonManager:pop(var_58_0)
	TopBarNew:pop()
end
