BurningReady = {}
BURNING_TEAM_IDX = {
	27,
	28
}

function HANDLER.battle_ready_key_slot(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_booster" then
		BoosterUI:show()
	elseif arg_1_1 == "btn_bonus" then
		BurningReady:openBonus()
	elseif arg_1_1 == "btn_pet" then
		if not Account:isHaveBattlePets() then
			return 
		end
		
		BurningReady:open_pet_setting_popup()
	elseif arg_1_1 == "btn_team" or arg_1_1 == "btn_info" then
	elseif arg_1_1 == "btn_go" then
		BurningReady:onEnter()
	elseif arg_1_1 == "btn_bossguide" then
		BurningReady:openBossGuide()
	elseif arg_1_1 == "btn_checkbox_g" then
		BattleRepeat:toggle_repeatPlay()
	elseif arg_1_1 == "btn_detail" then
		BurningReady:showKeySlotPopup()
	end
	
	BurningReady:setNormalMode()
end

function HANDLER.battle_ready_key_slot_info(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_select" then
		BurningReadyKeySlotPopup:selectDevote(arg_2_0)
	elseif arg_2_1 == "btn_close" then
		BurningReadyKeySlotPopup:close()
	end
end

function BurningReady.showKeySlotPopup(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	BurningReadyKeySlotPopup:show({
		hero_id = arg_3_0.vars.data.hero_character,
		hero_character_data = arg_3_0.vars.hero_character_data,
		burning_battle_id = arg_3_0.vars.burning_battle_id
	})
end

function BurningReady.show(arg_4_0, arg_4_1)
	BattleReady:hide()
	
	local var_4_0 = arg_4_1 or {}
	
	var_4_0.enter_id = var_4_0.enter_id
	var_4_0.burning_battle_id = var_4_0.burning_battle_id
	
	if not var_4_0.burning_battle_id or not var_4_0.enter_id then
		return 
	end
	
	if var_4_0.enter_id and not BackPlayUtil:checkEnterableMapOnBackPlaying(var_4_0.enter_id) then
		var_4_0.enter_error_text = T("msg_bgbattle_samebattle_error")
	end
	
	arg_4_0:init(var_4_0)
end

function BurningReady.isShow(arg_5_0)
	return arg_5_0.vars and get_cocos_refid(arg_5_0.vars.wnd)
end

function BurningReady.init(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = load_dlg("battle_ready_key_slot", true, "wnd")
	
	if_set_opacity(arg_6_0.vars.wnd, "btn_pet", Account:isHaveBattlePets() and 255 or 76.5)
	if_set_opacity(arg_6_0.vars.wnd, "n_none_pet", Account:isHaveBattlePets() and 255 or 76.5)
	SceneManager:getRunningNativeScene():addChild(arg_6_0.vars.wnd)
	
	arg_6_0.vars.opts = arg_6_1
	arg_6_0.vars.burning_battle_id = arg_6_1.burning_battle_id
	arg_6_0.vars.enter_id = arg_6_1.enter_id
	
	local var_6_0 = DB("level_enter", arg_6_0.vars.enter_id, "substory_contents_id")
	
	arg_6_0.vars.sub_story = SubstoryManager:makeInfo(var_6_0)
	
	if not arg_6_0.vars.sub_story then
		Log.e("BurningReady.init", "invalid_substory_info")
		
		return 
	end
	
	arg_6_0.vars.opts.sub_story = arg_6_0.vars.sub_story
	arg_6_0.vars.opts.is_burning = true
	
	arg_6_0:initData()
	arg_6_0:checkBurningTeam()
	
	local var_6_1 = SubStoryUtil:getTopbarCurrencies(arg_6_0.vars.sub_story, {
		"crystal",
		"gold",
		"stamina"
	})
	local var_6_2 = "descent_temp"
	
	TopBarNew:createFromPopup(T(var_6_2), arg_6_0.vars.wnd, function()
		BurningReady:leave()
	end, var_6_1, "contents_1")
	TopBarNew:setDisableLobbyAuto()
	
	local var_6_3, var_6_4, var_6_5, var_6_6, var_6_7, var_6_8 = DB("level_enter", arg_6_0.vars.enter_id, {
		"use_enterpoint",
		"type",
		"contents_type",
		"enter_limit",
		"type_enterpoint",
		"use_enterpoint"
	})
	
	arg_6_0.vars.req = var_6_3
	arg_6_0.vars.level_type = var_6_4
	arg_6_0.vars.contents_type = var_6_5
	arg_6_0.vars.enter_limit = var_6_6
	arg_6_0.vars.type_enterpoint = var_6_7
	arg_6_0.vars.use_enterpoint = var_6_8
	
	BoosterUI:update(arg_6_0.vars.wnd)
	
	local var_6_9 = arg_6_0.vars.wnd:getChildByName("btn_go")
	
	if get_cocos_refid(var_6_9) then
		arg_6_0.vars.enterable, arg_6_0.vars.lack_enter_item = UIUtil:setButtonEnterInfo(var_6_9, arg_6_0.vars.enter_id, arg_6_0.vars.opts)
		
		if_set_visible(var_6_9, "icon_res", true)
		
		local var_6_10 = true
		local var_6_11, var_6_12, var_6_13 = Account:getEnterLimitInfo(arg_6_0.vars.enter_id)
		
		if var_6_11 and var_6_11 < 1 then
			var_6_10 = false
		end
		
		UIUtil:changeButtonState(var_6_9, arg_6_0.vars.opts.enter_error_text == nil and var_6_10)
		
		arg_6_0.vars.enter_rest = var_6_11
		
		if var_6_11 and var_6_12 then
			arg_6_0:updateLimit(var_6_11, var_6_12)
		end
	end
	
	arg_6_0:initFormations()
	BattleRepeat:init_repeatCheckbox(arg_6_0.vars.wnd:getChildByName("n_check_box"), arg_6_0.vars.enter_id)
	arg_6_0:update_pet()
	arg_6_0:init_boss_info_ui()
	if_set_visible(arg_6_0.vars.wnd, "btn_info", false)
	if_set_visible(arg_6_0.vars.wnd, "btn_team", true)
	TutorialGuide:procGuide()
end

function BurningReady.initData(arg_8_0)
	local var_8_0 = DBT("substory_burning_battle", arg_8_0.vars.burning_battle_id, {
		"id",
		"sort",
		"enter_key",
		"battle_bg",
		"battle_character",
		"reward_set",
		"reward_item",
		"hero_character",
		"powerup_skill0",
		"powerup_skill1",
		"powerup_skill2",
		"powerup_skill3",
		"powerup_skill4",
		"powerup_skill5",
		"key_slot"
	})
	
	if not var_8_0 or not var_8_0.id then
		return 
	end
	
	arg_8_0.vars.data = var_8_0
end

function BurningReady.updateLimit(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1 and arg_9_2 then
		local var_9_0 = arg_9_0.vars.wnd:getChildByName("n_limit")
		
		if var_9_0 then
			var_9_0:setVisible(true)
			
			local var_9_1 = arg_9_1 == nil or arg_9_1 > 0
			local var_9_2
			
			if var_9_1 then
				var_9_2 = "level_enter_limit_desc"
				
				local var_9_3 = string.format("%d/%d", math.min(arg_9_2, math.max(arg_9_1, 0)), arg_9_2)
				
				if_set(var_9_0, "t_count", var_9_3)
			else
				var_9_2 = "battle_cant_getin"
				
				if_set_visible(var_9_0, "t_count", false)
			end
			
			if_set(var_9_0, "disc", T(var_9_2))
			
			local var_9_4 = var_9_0:getChildByName("t_count")
			local var_9_5 = var_9_0:getChildByName("disc")
			
			var_9_4:setPositionX(var_9_5:getContentSize().width + 7)
			
			local var_9_6 = var_9_2 == "level_enter_limit_desc" and 60 or 20
			
			if arg_9_2 >= 10 then
				var_9_6 = var_9_6 + 8
				
				if arg_9_1 >= 10 then
					var_9_6 = var_9_6 + 8
				end
			end
			
			UIUserData:call(var_9_0:getChildByName("talk_small_bg"), string.format("AUTOSIZE_WIDTH(disc, 1, %d)", var_9_6))
		end
	end
end

function BurningReady.initFormations(arg_10_0)
	local var_10_0 = tonumber(arg_10_0.vars.data.key_slot)
	local var_10_1 = 4
	local var_10_2 = 0
	local var_10_3 = load_dlg("battle_ready_key_slot_formation", true, "wnd")
	local var_10_4 = load_dlg("battle_ready_key_slot_formation", true, "wnd")
	
	if_set_visible(var_10_3, "bar_visible", false)
	arg_10_0.vars.wnd:getChildByName("team1"):addChild(var_10_3)
	arg_10_0.vars.wnd:getChildByName("team2"):addChild(var_10_4)
	
	arg_10_0.vars.group_wnd_1 = var_10_3
	arg_10_0.vars.group_wnd_2 = var_10_4
	
	var_10_3:setAnchorPoint(0, 0)
	var_10_4:setAnchorPoint(0, 0)
	var_10_3:setPosition(0, 0)
	var_10_4:setPosition(0, 0)
	
	local var_10_5 = {
		{
			group_name = "burning_team1",
			can_edit = true,
			wnd = var_10_3,
			max_unit = var_10_1,
			key_slot_idx = var_10_0,
			least_unit = var_10_2,
			title = {
				ignore_team_selector = true,
				cont = "txt_round",
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 1
				}),
				max_unit = var_10_1,
				least_unit = var_10_2
			},
			burning_team_idx = BURNING_TEAM_IDX[1]
		},
		{
			group_name = "burning_team2",
			can_edit = true,
			wnd = var_10_4,
			max_unit = var_10_1,
			key_slot_idx = var_10_0,
			least_unit = var_10_2,
			title = {
				ignore_team_selector = true,
				cont = "txt_round",
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 2
				}),
				max_unit = var_10_1,
				least_unit = var_10_2
			},
			burning_team_idx = BURNING_TEAM_IDX[2]
		}
	}
	local var_10_6 = {}
	
	GroupFormationEditor:initFormationEditor(var_10_6, {
		useSimpleTag = true,
		sprite_mode = true,
		hide_hpbar = true,
		hide_hpbar_color = true,
		is_burning = true,
		tagScale = 1,
		tagOffsetY = 45,
		notUseTouchHandler = true,
		infos = var_10_5,
		least_unit = var_10_2,
		max_unit = var_10_1,
		key_slot_idx = var_10_0,
		ui_handler = function(arg_11_0, arg_11_1)
		end,
		onFormationResEvent_UpdateFormation = function()
			arg_10_0:updateAllyTeamFormation()
		end,
		onFormationResEvent_UpdateTeamPoint = function()
			arg_10_0:updateAllyTeamPoint()
		end,
		callbackUpdateFormation = function(arg_14_0)
			HeroBelt:updateTeamMarkers()
			BurningReady:updateUI_all()
			BurningReady:updateTeamArtifactBonus()
			BurningReady:checkKeySlotUnit()
		end,
		callbackSelectUnit = function(arg_15_0)
			HeroBelt:scrollToUnit(arg_15_0)
		end,
		callbackSelectTeam = function(arg_16_0)
			arg_10_0:setTeam(arg_16_0)
		end,
		callbackUpdatePoint = function(arg_17_0)
			arg_10_0:updateFormationUI(arg_17_0)
		end,
		callbackCanAddUnit = function(arg_18_0)
			return true
		end
	})
	
	arg_10_0.vars.group_editor = var_10_6
	
	arg_10_0:createHeroBelt("burning")
	arg_10_0:updateGroupFormation()
end

function BurningReady.openBossGuide(arg_19_0)
	BossGuide:show({
		enter_id = arg_19_0.vars.enter_id,
		parent = arg_19_0.vars.wnd
	})
end

function BurningReady.setNormalMode(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) or not arg_20_0.vars.group_editor then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.group_editor
	
	if var_20_0 then
		var_20_0:setNormalMode()
	end
end

function BurningReady.createHeroBelt(arg_21_0, arg_21_1)
	if not arg_21_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_21_0.vars.unit_dock) then
		arg_21_0.vars.unit_doc = nil
		
		HeroBelt:destroy()
	end
	
	arg_21_0.vars.unit_dock = HeroBelt:create(arg_21_1)
	
	arg_21_0.vars.unit_dock:setEventHandler(arg_21_0.onHeroListEvent, arg_21_0)
	arg_21_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_21_0.vars.wnd:addChild(arg_21_0.vars.unit_dock:getWindow())
	
	local var_21_0 = arg_21_0:checkHeros()
	
	HeroBelt:resetData(var_21_0, arg_21_1, nil, nil, nil)
	
	local var_21_1 = arg_21_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_21_0.vars.unit_dock:getWindow():setPositionX(var_21_1)
	LuaEventDispatcher:addEventListener("unit_popup_detail.close", LISTENER(arg_21_0.updateOnLeaveUnitPopupMode, arg_21_0), "ready.unit_detail_popup")
end

function BurningReady.updateOnLeaveUnitPopupMode(arg_22_0)
	if arg_22_0.vars and get_cocos_refid(arg_22_0.vars.wnd) then
		HeroBelt:resetDataUseFilter(Account.units, "Burning", nil, true)
	end
end

function BurningReady.checkHeros(arg_23_0)
	local var_23_0 = {}
	
	return (table.shallow_clone(Account.units))
end

function BurningReady.onHeroListEvent(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if arg_24_0.vars and arg_24_0.vars.group_editor then
		arg_24_0.vars.group_editor:onHeroListEventForFormationEditor(arg_24_1, arg_24_2, arg_24_3)
		arg_24_0:setUnitBar(arg_24_1, arg_24_2, arg_24_3)
	end
end

function BurningReady.setUnitBar(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	if arg_25_1 == "change" then
		local var_25_0 = HeroBelt:getControl(arg_25_2)
		
		if var_25_0 then
			if_set_visible(var_25_0, "add", false)
		end
		
		local var_25_1 = HeroBelt:getControl(arg_25_3)
		
		if var_25_1 then
			if_set_visible(var_25_1, "add", true)
		end
	end
end

function BurningReady.updateGroupFormation(arg_26_0)
	arg_26_0.vars.group_editor:updateGroupFormation("burning_team1", BURNING_TEAM_IDX[1])
	arg_26_0.vars.group_editor:updateGroupFormation("burning_team2", BURNING_TEAM_IDX[2])
end

function BurningReady.updateTeamArtifactBonus(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("btn_bonus")
	
	if not get_cocos_refid(var_27_0) then
		return 
	end
	
	local var_27_1 = {}
	local var_27_2 = 0
	local var_27_3 = tonumber(arg_27_0.vars.data.key_slot)
	
	for iter_27_0 = 1, 2 do
		local var_27_4 = table.clone(arg_27_0.vars["team" .. iter_27_0] or {})
		
		if table.empty(var_27_4) then
			var_27_2 = var_27_2 + 1
		else
			if iter_27_0 == 2 then
				var_27_4[var_27_3] = nil
			end
			
			table.insert(var_27_1, var_27_4)
		end
	end
	
	if table.empty(var_27_1) or var_27_2 >= 2 then
		if_set_opacity(var_27_0, nil, 102)
		if_set_opacity(var_27_0, "img", 255)
		if_set_opacity(var_27_0, "icon_order", 255)
		if_set(var_27_0, "txt_booster_cnt", "")
		if_set_visible(var_27_0, "n_cnt", false)
		if_set_color(var_27_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	local var_27_5 = 0
	local var_27_6 = 0
	local var_27_7 = 0
	
	for iter_27_1, iter_27_2 in pairs(var_27_1) do
		if not table.empty(iter_27_2) then
			local var_27_8 = Team:getGrowthBonusArtifactsCount(iter_27_2, arg_27_0.vars.level_type)
			local var_27_9 = Team:getSubStoryCurrencyBonusArtifactsCount(iter_27_2, SubstoryManager:getArtifactBonusInfo(), arg_27_0.vars.enter_id)
			
			var_27_7 = var_27_7 + var_27_8 + var_27_9
		end
	end
	
	if var_27_7 == 0 then
		if_set_opacity(var_27_0, nil, 102)
		if_set_opacity(var_27_0, "img", 255)
		if_set_opacity(var_27_0, "icon_order", 255)
		if_set(var_27_0, "txt_booster_cnt", "")
		if_set_visible(var_27_0, "n_cnt", false)
		if_set_color(var_27_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	local var_27_10 = 0
	local var_27_11 = 0
	local var_27_12 = 0
	
	for iter_27_3, iter_27_4 in pairs(var_27_1) do
		if not table.empty(iter_27_4) then
			local var_27_13 = Team:getGrowthBonusApplyArtifactsCount(iter_27_4, arg_27_0.vars.level_type)
			local var_27_14 = Team:getSubStoryCurrencyBonusApplyArtifactsCount(iter_27_4, SubstoryManager:getArtifactBonusInfo(), arg_27_0.vars.enter_id)
			
			var_27_10 = var_27_10 + var_27_13
			var_27_11 = var_27_11 + var_27_14
		end
	end
	
	local var_27_15 = var_27_10 + math.min(var_27_11, table.count(SubstoryManager:getArtifactBonusInfo() or {}))
	
	if var_27_15 == 0 then
		if_set_opacity(var_27_0, nil, 255)
		if_set_opacity(var_27_0, "img", 102)
		if_set_opacity(var_27_0, "icon_order", 102)
		if_set_visible(var_27_0, "n_cnt", false)
		if_set_visible(var_27_0, "n_cnt_off", true)
		if_set(var_27_0:getChildByName("n_cnt_off"), "txt_booster_cnt", "+" .. var_27_7)
		if_set_color(var_27_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	if_set_opacity(var_27_0, nil, 255)
	if_set_opacity(var_27_0, "img", 255)
	if_set_opacity(var_27_0, "icon_order", 255)
	if_set_visible(var_27_0, "n_cnt", true)
	if_set(var_27_0:getChildByName("n_cnt"), "txt_booster_cnt", "+" .. var_27_15)
	if_set_visible(var_27_0, "n_cnt_off", false)
	if_set_color(var_27_0, "icon_order", cc.c3b(255, 120, 0))
end

function BurningReady.updateUI_all(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = false
	
	for iter_28_0 = 1, 2 do
		local var_28_1 = arg_28_0.vars["team" .. iter_28_0] or {}
		local var_28_2 = table.count(var_28_1)
		
		if var_28_1[7] then
			var_28_2 = var_28_2 - 1
		end
		
		if not var_28_0 and var_28_2 < 1 then
			var_28_0 = true
		end
	end
	
	if arg_28_0.vars.enter_rest and arg_28_0.vars.enter_rest <= 0 or var_28_0 then
		if_set_opacity(arg_28_0.vars.wnd, "btn_go", 76.5)
	else
		if_set_opacity(arg_28_0.vars.wnd, "btn_go", 255)
	end
end

function BurningReady.update_pet(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = Account:getPetInTeam(Account:getBurningPetTeamIdx())
	local var_29_1 = arg_29_0.vars.wnd:getChildByName("base_pet")
	
	if_set_visible(var_29_1, "n_none_pet", not var_29_0)
	if_set_visible(var_29_1, "n_pet", var_29_0)
	
	if var_29_0 then
		local var_29_2 = var_29_1:getChildByName("pos7")
		
		if not var_29_2 then
			print("Not Have Pos!")
		end
		
		var_29_2:removeAllChildren()
		
		if not var_29_0 then
			return 
		end
		
		local var_29_3 = UIUtil:getRewardIcon(nil, var_29_0:getDisplayCode(), {
			no_popup = true,
			role = true,
			no_db_grade = true,
			lv = var_29_0:getLv(),
			max_lv = var_29_0:getMaxLevel(),
			grade = var_29_0:getGrade()
		})
		
		var_29_3:setName("model")
		var_29_2:addChild(var_29_3)
	end
	
	arg_29_0:update_repeatCount(var_29_0)
end

function BurningReady.update_repeatCount(arg_30_0, arg_30_1)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0 = arg_30_1 or Account:getPetInTeam(Account:getBurningPetTeamIdx())
	local var_30_1 = arg_30_0.vars.wnd
	
	if not get_cocos_refid(var_30_1) then
		return 
	end
	
	local var_30_2 = var_30_1:getChildByName("n_check_box")
	
	if not get_cocos_refid(var_30_2) then
		return 
	end
	
	local var_30_3, var_30_4 = BattleRepeat:getConfigRepeatBattleCount(Account:getBurningPetTeamIdx())
	
	if var_30_0 and var_30_0.getRepeat_count then
		local var_30_5 = var_30_0:getRepeat_count()
		
		if var_30_5 < var_30_3 or var_30_4 then
			var_30_3 = var_30_5
		end
	end
	
	if not var_30_0 then
		var_30_3 = 0
	end
	
	BattleRepeat:set_checkBox(var_30_0 ~= nil, arg_30_0.vars.enter_id)
	if_set(var_30_2, "label", var_30_3)
end

function BurningReady.getEnterID(arg_31_0)
	if not arg_31_0.vars or not arg_31_0.vars.enter_id then
		return 
	end
	
	return arg_31_0.vars.enter_id
end

function BurningReady.open_pet_setting_popup(arg_32_0)
	local var_32_0 = Account:getBurningPetTeamIdx()
	
	PetSettingPopup:init({
		mode = "Burning",
		team_idx = var_32_0,
		close_callback = function(arg_33_0)
			if arg_33_0 then
				Account:saveTeamInfo(nil, {
					is_burning = true
				})
			end
			
			arg_32_0:update_pet()
		end
	})
end

function BurningReady.getTeamData(arg_34_0, arg_34_1)
	return arg_34_0.vars["team" .. arg_34_1] or {}
end

function BurningReady.getTeamBonus(arg_35_0, arg_35_1)
	local var_35_0 = "v1002a004"
	local var_35_1 = "quest"
	local var_35_2 = Team:getGrowthBonusArtifacts(arg_35_0:getTeamData(arg_35_1), var_35_1)
	
	table.sort(var_35_2, function(arg_36_0, arg_36_1)
		if arg_36_0.is_apply == arg_36_1.is_apply then
			return false
		end
		
		return arg_36_0.is_apply or not arg_36_1.is_apply
	end)
	
	return var_35_2
end

function BurningReady.init_boss_info_ui(arg_37_0)
	local var_37_0 = arg_37_0.vars.enter_id
	local var_37_1 = arg_37_0.vars.wnd:getChildByName("LEFT")
	local var_37_2, var_37_3, var_37_4 = BattleReady:GetReqPointAndRewards(var_37_0)
	
	arg_37_0.vars.req_point = var_37_2
	
	if DBT("level_enter", var_37_0, {
		"hide_battle_power",
		"cp_material",
		"cp_value"
	}).hide_battle_power == "y" then
		arg_37_0.vars.req_point = 0
	end
	
	local var_37_5 = to_n(Account:getMapClearCount(var_37_0))
	local var_37_6 = {}
	
	for iter_37_0, iter_37_1 in pairs(var_37_3) do
		table.push(var_37_6, {
			iter_37_1.m,
			iter_37_1.lv,
			iter_37_1.tier
		})
	end
	
	table.sort(var_37_6, function(arg_38_0, arg_38_1)
		if arg_38_0[3] ~= arg_38_1[3] then
			if arg_38_0[3] == "boss" then
				return true
			end
			
			if arg_38_1[3] == "boss" then
				return false
			end
			
			if arg_38_0[3] == "subboss" then
				return true
			end
			
			if arg_38_1[3] == "subboss" then
				return false
			end
			
			if arg_38_0[3] == "elite" then
				return true
			end
			
			if arg_38_1[3] == "elite" then
				return false
			end
			
			return false
		end
		
		return arg_38_0[2] > arg_38_1[2]
	end)
	
	local var_37_7 = arg_37_0.vars.wnd:getChildByName("n_boss_info")
	local var_37_8, var_37_9 = DB("level_enter", var_37_0, {
		"randomability",
		"type"
	})
	
	arg_37_0.vars.boss_data = nil
	arg_37_0.vars.ScrollEnemy = {}
	
	copy_functions(ScrollView, arg_37_0.vars.ScrollEnemy)
	
	function arg_37_0.vars.ScrollEnemy.getScrollViewItem(arg_39_0, arg_39_1)
		return UIUtil:getRewardIcon("c", arg_39_1[1], {
			no_db_grade = true,
			scale = 0.85,
			monster = true,
			hide_star = true,
			lv = arg_39_1[2],
			tier = arg_39_1[3]
		})
	end
	
	function arg_37_0.vars.ScrollEnemy.onSelectScrollViewItem(arg_40_0, arg_40_1, arg_40_2)
	end
	
	local var_37_10 = var_37_1:getChildByName("n_monster")
	
	arg_37_0.vars.ScrollEnemy:initScrollView(var_37_10, 75, 75)
	arg_37_0.vars.ScrollEnemy:createScrollViewItems(var_37_6)
	var_37_10:jumpToPercentVertical(0)
	var_37_10:jumpToPercentHorizontal(0)
	
	local var_37_11 = arg_37_0.vars.data.battle_character
	
	for iter_37_2, iter_37_3 in pairs(var_37_6) do
		if iter_37_3[3] and iter_37_3[3] == "boss" then
			arg_37_0.vars.boss_data = iter_37_3
			
			break
		end
	end
	
	if arg_37_0.vars.boss_data then
		UIUtil:getRewardIcon("c", var_37_11, {
			no_db_grade = true,
			monster = true,
			hide_star = true,
			no_popup = true,
			parent = var_37_7:getChildByName("mob_icon"),
			lv = arg_37_0.vars.boss_data[2],
			tier = arg_37_0.vars.boss_data[3]
		})
	else
		UIUtil:getRewardIcon("c", var_37_11, {
			no_db_grade = true,
			hide_star = true,
			no_popup = true,
			monster = true,
			parent = var_37_7:getChildByName("mob_icon")
		})
	end
	
	local var_37_12 = DB("character", var_37_11, "name")
	
	if var_37_12 then
		if_set(var_37_7, "t_boss_name", T(var_37_12))
	end
	
	local var_37_13 = arg_37_0.vars.data.hero_character
	local var_37_14 = arg_37_0.vars.wnd:getChildByName("n_key_slot")
	
	if get_cocos_refid(var_37_14) then
		arg_37_0.vars.n_hero_face = UIUtil:getRewardIcon("c", var_37_13, {
			parent = var_37_14:getChildByName("hero")
		})
		
		if_set_visible(var_37_14, "key_slot_buff_on", false)
		if_set_visible(var_37_14, "key_slot_buff_off", true)
		
		local var_37_15 = DB("character", var_37_13, "name")
		local var_37_16 = var_37_14:getChildByName("n_key_slot_info")
		
		if get_cocos_refid(var_37_16) then
			if_set(var_37_16, "t_info", T("burn_battle_hero_desc", {
				name = T(var_37_15)
			}))
		end
	end
	
	arg_37_0:updateKeySlotHeroUI()
end

function BurningReady.setKeySlotUnitInfo(arg_41_0, arg_41_1, arg_41_2)
	arg_41_0.vars.is_buff_on = arg_41_1
	
	if not arg_41_1 then
		arg_41_0.vars.cur_devote_lv = 0
	else
		arg_41_0.vars.cur_devote_lv = arg_41_2 or 0
	end
	
	arg_41_0:updateKeySlotHeroUI()
end

function BurningReady.updateKeySlotHeroUI(arg_42_0)
	local var_42_0 = arg_42_0.vars.is_buff_on
	local var_42_1 = arg_42_0.vars.cur_devote_lv or 0
	local var_42_2 = arg_42_0.vars.data.hero_character
	local var_42_3 = arg_42_0.vars.wnd:getChildByName("n_key_slot")
	
	if_set_visible(var_42_3, "grade", var_42_0)
	if_set_visible(var_42_3, "key_slot_buff_on", var_42_0)
	if_set_visible(var_42_3, "key_slot_buff_off", not var_42_0)
	
	if get_cocos_refid(arg_42_0.vars.n_hero_face) then
		arg_42_0.vars.n_hero_face:setOpacity(var_42_0 and 255 or 76.5)
	end
	
	local var_42_4 = arg_42_0.vars.data["powerup_skill" .. var_42_1]
	
	if var_42_4 then
		local var_42_5 = DB("skill", var_42_4, "sk_description")
		
		if_set(var_42_3, "t_hero_buff_info", T(var_42_5))
	end
	
	if not var_42_0 then
		if_set(var_42_3, "t_hero_buff_info", T("ui_battle_ready_keydesc"))
	elseif arg_42_0.vars.hero_character_data then
		local var_42_6, var_42_7 = UIUtil:getDevoteSprite(arg_42_0.vars.hero_character_data, true)
		
		if_set_sprite(var_42_3, "grade", var_42_7)
	end
end

function BurningReady.updateButtons(arg_43_0)
	arg_43_0:updateEnterButton()
end

function BurningReady.updateEnterButton(arg_44_0)
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

function BurningReady.checkBurningTeam(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	local var_45_0 = tonumber(arg_45_0.vars.data.key_slot)
	local var_45_1 = Account:getTeam(BURNING_TEAM_IDX[1])
	local var_45_2 = Account:getTeam(BURNING_TEAM_IDX[2])
	local var_45_3 = {}
	local var_45_4 = {}
	
	for iter_45_0, iter_45_1 in pairs(var_45_1) do
		var_45_3[iter_45_0] = iter_45_1:getUID()
	end
	
	for iter_45_2, iter_45_3 in pairs(var_45_2) do
		var_45_4[iter_45_2] = iter_45_3:getUID()
	end
	
	for iter_45_4, iter_45_5 in pairs(var_45_3) do
		if not var_45_4[iter_45_4] or var_45_4[iter_45_4] ~= iter_45_5 or iter_45_4 == var_45_0 then
		else
			Account:removeFromTeamByPos(BURNING_TEAM_IDX[2], iter_45_4)
		end
		
		if iter_45_4 == var_45_0 then
			if var_45_4[iter_45_4] and var_45_4[iter_45_4] ~= iter_45_5 then
				Account:removeFromTeamByPos(BURNING_TEAM_IDX[2], iter_45_4)
				
				var_45_4[iter_45_4] = nil
			end
			
			if not var_45_4[iter_45_4] then
				Account:addToTeam(Account:getUnit(iter_45_5), BURNING_TEAM_IDX[2], iter_45_4)
			end
		end
	end
	
	if not var_45_3[var_45_0] and var_45_4[var_45_0] then
		Account:addToTeam(Account:getUnit(var_45_4[var_45_0]), BURNING_TEAM_IDX[1], var_45_0)
	end
	
	arg_45_0.vars.team1 = Account:getTeam(BURNING_TEAM_IDX[1])
	arg_45_0.vars.team2 = Account:getTeam(BURNING_TEAM_IDX[2])
end

function BurningReady.procCheckEnter(arg_46_0)
	if not UIUtil:checkUnitInven() then
		return 
	end
	
	if not UIUtil:checkTotalInven() then
		return 
	end
	
	for iter_46_0, iter_46_1 in pairs(BURNING_TEAM_IDX) do
		local var_46_0 = Account:getTeamMemberCount(iter_46_1, true)
		
		if var_46_0 < 1 or var_46_0 > 4 then
			balloon_message_with_sound("msg_descent_team_min")
			
			return 
		end
	end
	
	local var_46_1 = arg_46_0.vars.data.key_slot
	
	if not arg_46_0.vars.team1[var_46_1] or not arg_46_0.vars.team2[var_46_1] then
		balloon_message_with_sound("ui_battle_ready_key_empty")
		
		return 
	end
	
	local var_46_2 = Account:getTeam(BURNING_TEAM_IDX[1])
	local var_46_3 = Account:getTeam(BURNING_TEAM_IDX[2])
	local var_46_4 = {}
	local var_46_5 = {}
	
	for iter_46_2, iter_46_3 in pairs(var_46_2) do
		var_46_4[iter_46_2] = iter_46_3:getUID()
	end
	
	for iter_46_4, iter_46_5 in pairs(var_46_3) do
		var_46_5[iter_46_4] = iter_46_5:getUID()
	end
	
	for iter_46_6, iter_46_7 in pairs(var_46_4) do
		if iter_46_6 ~= tonumber(var_46_1) and var_46_4[iter_46_6] and var_46_5[iter_46_6] and var_46_4[iter_46_6] == var_46_5[iter_46_6] then
			return 
		end
	end
	
	return true
end

function BurningReady.onEnter(arg_47_0)
	if not arg_47_0:procCheckEnter() then
		return 
	end
	
	if not arg_47_0.vars.enterable and arg_47_0.vars.lack_enter_item then
		if arg_47_0.vars.lack_enter_item == "to_stamina" then
			UIUtil:wannaBuyStamina("battle.ready")
			
			return 
		end
		
		if DB("item_material", arg_47_0.vars.lack_enter_item, "id") then
			balloon_message_with_sound("not_enough_enter_item")
		end
		
		return 
	end
	
	SoundEngine:play("event:/ui/battle_ready/btn_go")
	
	if arg_47_0.vars.opts.onEnter and type(arg_47_0.vars.opts.onEnter) == "function" then
		arg_47_0.vars.opts.onEnter()
	end
	
	BattleRepeat:initBeforeBattleStart(Account:getBurningPetTeamIdx(), arg_47_0.vars.enter_id, arg_47_0.vars.opts)
	startBattle(arg_47_0.vars.enter_id, arg_47_0.vars.opts)
end

function BurningReady.openBonus(arg_48_0)
	if not arg_48_0.vars then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.team1
	local var_48_1 = arg_48_0.vars.team2
	local var_48_2 = {}
	
	for iter_48_0, iter_48_1 in pairs(var_48_0) do
		var_48_2[iter_48_1:getUID()] = iter_48_1
	end
	
	for iter_48_2, iter_48_3 in pairs(var_48_1) do
		var_48_2[iter_48_3:getUID()] = iter_48_3
	end
	
	ArtifactBonus:show(var_48_2, "burning", arg_48_0.vars.enter_id)
end

function BurningReady.checkKeySlotUnit(arg_49_0)
	if not arg_49_0.vars or not get_cocos_refid(arg_49_0.vars.wnd) or not arg_49_0.vars.team1 or not arg_49_0.vars.team2 then
		return 
	end
	
	arg_49_0.vars.hero_character_data = nil
	
	local var_49_0 = arg_49_0.vars.data.key_slot
	local var_49_1 = arg_49_0.vars.data.hero_character
	local var_49_2 = false
	local var_49_3 = 0
	
	for iter_49_0, iter_49_1 in pairs(arg_49_0.vars.team1) do
		if iter_49_1.db and iter_49_1.db.code and iter_49_1.db.code == var_49_1 then
			var_49_2 = true
			var_49_3 = iter_49_1:getClampedDevote()
			arg_49_0.vars.hero_character_data = iter_49_1
			
			break
		end
	end
	
	if not var_49_2 then
		for iter_49_2, iter_49_3 in pairs(arg_49_0.vars.team2) do
			if iter_49_3.db and iter_49_3.db.code and iter_49_3.db.code == var_49_1 then
				var_49_2 = true
				var_49_3 = iter_49_3:getClampedDevote()
				arg_49_0.vars.hero_character_data = iter_49_3
				
				break
			end
		end
	end
	
	arg_49_0:setKeySlotUnitInfo(var_49_2, var_49_3)
end

function BurningReady.updateAllyTeamFormation(arg_50_0)
	local var_50_0 = table.shallow_clone(arg_50_0.vars.team1)
	local var_50_1 = table.shallow_clone(arg_50_0.vars.team2)
	
	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		if not Account:getUnit(iter_50_1:getUID()) then
			arg_50_0.vars.team1[iter_50_0] = nil
		end
	end
	
	for iter_50_2, iter_50_3 in pairs(var_50_1) do
		if not Account:getUnit(iter_50_3:getUID()) then
			arg_50_0.vars.team2[iter_50_2] = nil
		end
	end
	
	arg_50_0.vars.group_editor:updateGroupFormation("burning_team1", arg_50_0.vars.team1)
	arg_50_0.vars.group_editor:updateGroupFormation("burning_team2", arg_50_0.vars.team2)
end

function BurningReady.updateAllyTeamPoint(arg_51_0)
	arg_51_0.vars.group_editor:updateGroupTeamPoint("burning_team1", arg_51_0.vars.team1)
	arg_51_0.vars.group_editor:updateGroupTeamPoint("burning_team2", arg_51_0.vars.team2)
end

function BurningReady.updateFormationUI(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_1 or {}
	
	if var_52_0.wnd and var_52_0.pre and var_52_0.cur then
		local var_52_1 = var_52_0.wnd:getChildByName("txt_point")
		
		if var_52_1 then
			UIAction:Add(INC_NUMBER(400, var_52_0.cur, nil, var_52_0.pre), var_52_1)
		end
	end
end

function BurningReady.leave(arg_53_0)
	Account:saveTeamInfo(nil, {
		is_burning = true
	})
	arg_53_0.vars.wnd:removeFromParent()
	
	arg_53_0.vars = nil
	
	local var_53_0 = "descent_temp"
	
	BackButtonManager:pop(var_53_0)
	TopBarNew:pop()
end

BurningReadyKeySlotPopup = {}

function BurningReadyKeySlotPopup.show(arg_54_0, arg_54_1)
	if arg_54_0.vars and get_cocos_refid(arg_54_0.vars.wnd) then
		return 
	end
	
	arg_54_1 = arg_54_1 or {}
	arg_54_0.vars = {}
	arg_54_0.vars.burning_battle_id = arg_54_1.burning_battle_id
	arg_54_0.vars.hero_id = arg_54_1.hero_id
	arg_54_0.vars.hero_character_data = arg_54_1.hero_character_data
	arg_54_0.vars.wnd = load_dlg("battle_ready_key_slot_info", true, "wnd")
	
	;(arg_54_1.parent or SceneManager:getRunningNativeScene()):addChild(arg_54_0.vars.wnd)
	BackButtonManager:push({
		check_id = "BurningReadyKeySlotPopup",
		back_func = function()
			arg_54_0:close()
		end,
		dlg = arg_54_0.vars.wnd
	})
	
	if arg_54_0.vars.hero_character_data then
		arg_54_0.vars.devote_lv = tonumber(arg_54_0.vars.hero_character_data:getClampedDevote())
		arg_54_0.vars.devote_grade = arg_54_0.vars.hero_character_data:getClampedDevote()
	else
		arg_54_0.vars.devote_lv = 0
		arg_54_0.vars.devote_grade = "none"
	end
	
	arg_54_0:init()
	arg_54_0:update()
end

function BurningReadyKeySlotPopup.init(arg_56_0)
	local var_56_0 = arg_56_0.vars.wnd:getChildByName("n_rank")
	local var_56_1 = {
		"b",
		"a",
		"s",
		"ss",
		"sss"
	}
	
	for iter_56_0 = 1, 5 do
		if var_56_1[iter_56_0] then
			local var_56_2 = var_56_0:getChildByName("n_rank_" .. var_56_1[iter_56_0])
			
			if get_cocos_refid(var_56_2) then
				local var_56_3 = var_56_2:getChildByName("btn_select")
				
				if get_cocos_refid(var_56_3) then
					var_56_3.devote_lv = iter_56_0
					var_56_3.devote_grade = var_56_1[iter_56_0]
				end
			end
		end
	end
	
	local var_56_4 = var_56_0:getChildByName("n_rank")
	
	if get_cocos_refid(var_56_4) then
		local var_56_5 = var_56_4:getChildByName("n_rank")
		
		if get_cocos_refid(var_56_5) then
			local var_56_6 = var_56_5:getChildByName("btn_select")
			
			if var_56_6 then
				var_56_6.devote_lv = 0
				var_56_6.devote_grade = "none"
			end
		end
	end
end

function BurningReadyKeySlotPopup.update(arg_57_0, arg_57_1)
	if not arg_57_0.vars or not get_cocos_refid(arg_57_0.vars.wnd) then
		return 
	end
	
	local var_57_0 = arg_57_0.vars.wnd:getChildByName("n_key_slot_info")
	local var_57_1 = arg_57_0.vars.wnd:getChildByName("n_strong_step")
	local var_57_2 = arg_57_0.vars.wnd:getChildByName("n_area")
	local var_57_3 = arg_57_0.vars.wnd:getChildByName("n_rank")
	local var_57_4 = arg_57_0.vars.devote_lv
	
	if arg_57_0.vars.hero_character_data then
		local var_57_5 = DBT("substory_burning_battle", arg_57_0.vars.burning_battle_id, {
			"powerup_skill0",
			"powerup_skill1",
			"powerup_skill2",
			"powerup_skill3",
			"powerup_skill4",
			"powerup_skill5",
			"key_slot"
		})["powerup_skill" .. var_57_4]
		
		if var_57_5 then
			local var_57_6 = DB("skill", var_57_5, "sk_description")
			
			if_set(arg_57_0.vars.wnd, "t_hero_buff_info", T(var_57_6))
		end
		
		if arg_57_1 then
			if arg_57_1 == "C" then
				arg_57_1 = "none"
			end
			
			if_set_sprite(var_57_1, "grade", string.format("img/hero_dedi_a_%s.png", arg_57_1))
		else
			local var_57_7, var_57_8 = UIUtil:getDevoteSprite(arg_57_0.vars.hero_character_data, true)
			
			if_set_sprite(var_57_1, "grade", var_57_8)
		end
	end
	
	local var_57_9 = {
		"b",
		"a",
		"s",
		"ss",
		"sss"
	}
	
	if_set_visible(var_57_2, "bg_area", var_57_4 >= 1)
	
	local var_57_10 = arg_57_0.vars.wnd:getChildByName("n_rank")
	
	if get_cocos_refid(var_57_10) then
		local var_57_11 = var_57_10:getChildByName("n_rank")
		
		if get_cocos_refid(var_57_11) then
			local var_57_12 = var_57_11:getChildByName("n_rank")
			
			if get_cocos_refid(var_57_12) then
				if_set_visible(var_57_12, "img_selected", var_57_4 == 0)
			end
		end
	end
	
	for iter_57_0 = 1, 5 do
		if_set_visible(var_57_2, "bg_area_" .. iter_57_0, iter_57_0 <= var_57_4 - 1)
		
		if var_57_9[iter_57_0] then
			local var_57_13 = var_57_10:getChildByName("n_rank_" .. var_57_9[iter_57_0])
			
			if get_cocos_refid(var_57_13) then
				if_set_visible(var_57_13, "img_selected", iter_57_0 == var_57_4)
			end
		end
	end
	
	UIUtil:getRewardIcon("c", arg_57_0.vars.hero_id, {
		parent = var_57_1:getChildByName("n_hero")
	})
	
	local var_57_14 = DB("character", arg_57_0.vars.hero_id, "name")
	
	if_set(var_57_0, "t_info", T("burn_battle_hero_desc", {
		name = T(var_57_14)
	}))
end

function BurningReadyKeySlotPopup.selectDevote(arg_58_0, arg_58_1)
	if not arg_58_1 or not arg_58_1.devote_lv or not arg_58_1.devote_grade then
		return 
	end
	
	arg_58_0.vars.devote_lv = arg_58_1.devote_lv
	arg_58_0.vars.devote_grade = arg_58_1.devote_grade
	
	arg_58_0:update(arg_58_0.vars.devote_grade)
end

function BurningReadyKeySlotPopup.close(arg_59_0)
	if not arg_59_0.vars or not get_cocos_refid(arg_59_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("BurningReadyKeySlotPopup")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE(), CALL(function()
		arg_59_0.vars = nil
	end)), arg_59_0.vars.wnd, "block")
end
