ClanTeamReady = {}

function MsgHandler.clan_team_ready(arg_1_0)
	SceneManager:nextScene("pvp_group", arg_1_0)
end

function HANDLER.clan_team_ready(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_clan_go" then
		ClanTeamReady:onBattleBegin()
	end
end

local function var_0_0(arg_3_0)
	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		if iter_3_1 and ClanWar:isInDeadUnits(iter_3_1) then
			arg_3_0[iter_3_0] = nil
		end
	end
end

function ClanTeamReady.onCreate(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:create(arg_4_2)
	arg_4_1:addChild(arg_4_0.vars.wnd)
end

function ClanTeamReady.create(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}
	arg_5_0.vars = {}
	arg_5_0.vars.enter_id = "clan_war_01"
	arg_5_0.vars.pvp_info = arg_5_1.pvp_info or {}
	arg_5_0.vars.pvp_info.clan_pvp_mode = "true"
	arg_5_0.vars.team1 = Account:loadLocalCustomTeam("clan_pvp_attack1")
	arg_5_0.vars.team2 = Account:loadLocalCustomTeam("clan_pvp_attack2")
	arg_5_0.vars.wnd = load_dlg("clan_war_formation", true, "wnd")
	
	arg_5_0.vars.wnd:setName("clan_team_ready")
	arg_5_0.vars.wnd:setLocalZOrder(100)
	
	local var_5_0 = arg_5_0.vars.wnd:findChildByName("n_power1")
	local var_5_1 = arg_5_0.vars.wnd:findChildByName("n_power2")
	
	if var_5_0 and var_5_1 then
		if_set(var_5_0, "txt_point", tostring(0))
		if_set(var_5_1, "txt_point", tostring(0))
	end
	
	var_0_0(arg_5_0.vars.team1)
	var_0_0(arg_5_0.vars.team2)
	arg_5_0:createFormation()
	arg_5_0:initHandler()
	arg_5_0:updateInfo(arg_5_0.vars.wnd:getChildByName("n_my_formation"))
	arg_5_0:updateInfo(arg_5_0.vars.wnd:getChildByName("n_peer_formation"), true)
	Analytics:setPopup("clan_war_ready")
end

function ClanTeamReady.onEnter(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}
	
	local var_6_0 = HeroBelt:getCurrentControl()
	
	if var_6_0 then
		var_6_0.add:setVisible(true)
	end
	
	arg_6_0:updateGroupFormation()
	arg_6_0.vars.group_editor:setFormationEditMode(true)
	
	if arg_6_1.cb then
		arg_6_1.cb()
	end
end

function ClanTeamReady.onLeave(arg_7_0)
	arg_7_0.vars.group_editor:setFormationEditMode(false)
	
	if not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	UnitMain:procSideBarEnter("GroupTeam", nil)
	
	local var_7_0 = HeroBelt:getCurrentControl()
	
	if var_7_0 then
		var_7_0.add:setVisible(false)
	end
	
	Analytics:closePopup()
end

function ClanTeamReady.createFormation(arg_8_0)
	local var_8_0 = load_dlg("clan_war_formation_my", true, "wnd")
	local var_8_1 = load_dlg("clan_war_formation_my", true, "wnd")
	local var_8_2 = load_dlg("clan_war_formation_peer", true, "wnd")
	local var_8_3 = load_dlg("clan_war_formation_peer", true, "wnd")
	local var_8_4 = arg_8_0.vars.wnd:getChildByName("n_my_formation")
	local var_8_5 = arg_8_0.vars.wnd:getChildByName("n_peer_formation")
	
	var_8_4:getChildByName("n_round1"):addChild(var_8_0)
	var_8_4:getChildByName("n_round2"):addChild(var_8_1)
	var_8_5:getChildByName("n_round1"):addChild(var_8_2)
	var_8_5:getChildByName("n_round2"):addChild(var_8_3)
	
	for iter_8_0, iter_8_1 in pairs({
		var_8_0,
		var_8_1,
		var_8_2,
		var_8_3
	}) do
		iter_8_1:setPosition(0, 0)
		iter_8_1:setAnchorPoint(0, 0)
	end
	
	local var_8_6 = {
		{
			use_detail = true,
			group_name = "clan_ready_group1",
			max_unit = 3,
			ignore_team_selector = true,
			can_edit = true,
			custom = true,
			wnd = var_8_0
		},
		{
			use_detail = true,
			group_name = "clan_ready_group2",
			max_unit = 3,
			ignore_team_selector = true,
			can_edit = true,
			custom = true,
			wnd = var_8_1
		},
		{
			group_name = "clan_ready_group3",
			is_enemy = true,
			can_edit = false,
			wnd = var_8_2
		},
		{
			group_name = "clan_ready_group4",
			is_enemy = true,
			can_edit = false,
			wnd = var_8_3
		}
	}
	local var_8_7 = {}
	
	GroupFormationEditor:initFormationEditor(var_8_7, {
		sprite_mode = true,
		notUseTouchHandler = true,
		hide_hpbar = true,
		max_unit = 3,
		hide_hpbar_color = true,
		infos = var_8_6,
		pvp_info = arg_8_0.vars.pvp_info,
		lua_event_wnd = arg_8_0.vars.wnd,
		onFormationResEvent_UpdateFormation = function()
			arg_8_0:updateAllyTeamFormation()
		end,
		onFormationResEvent_UpdateTeamPoint = function()
			arg_8_0:updateAllyTeamPoint()
		end,
		callbackUpdateFormation = function(arg_11_0)
			HeroBelt:updateTeamMarkers()
		end,
		callbackSelectUnit = function(arg_12_0)
			HeroBelt:scrollToUnit(arg_12_0)
		end,
		callbackSelectTeam = function(arg_13_0)
			arg_8_0:setTeam(arg_13_0)
		end,
		callbackUpdatePoint = function(arg_14_0)
			arg_8_0:updatePoint(arg_14_0)
		end,
		callbackCanAddUnit = function(arg_15_0)
			return not ClanWar:isInDeadUnits(arg_15_0)
		end
	})
	
	arg_8_0.vars.group_editor = var_8_7
end

function ClanTeamReady.updateAllyTeamFormation(arg_16_0)
	local var_16_0 = table.shallow_clone(arg_16_0.vars.team1)
	local var_16_1 = table.shallow_clone(arg_16_0.vars.team2)
	
	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if not Account:getUnit(iter_16_1:getUID()) then
			arg_16_0.vars.team1[iter_16_0] = nil
		end
	end
	
	for iter_16_2, iter_16_3 in pairs(var_16_1) do
		if not Account:getUnit(iter_16_3:getUID()) then
			arg_16_0.vars.team2[iter_16_2] = nil
		end
	end
	
	arg_16_0.vars.group_editor:updateGroupFormation("clan_ready_group1", arg_16_0.vars.team1)
	arg_16_0.vars.group_editor:updateGroupFormation("clan_ready_group2", arg_16_0.vars.team2)
end

function ClanTeamReady.updateAllyTeamPoint(arg_17_0)
	arg_17_0.vars.group_editor:updateGroupTeamPoint("clan_ready_group1", arg_17_0.vars.team1)
	arg_17_0.vars.group_editor:updateGroupTeamPoint("clan_ready_group2", arg_17_0.vars.team2)
end

function ClanTeamReady.updateGroupFormation(arg_18_0)
	arg_18_0.vars.group_editor:updateGroupFormation("clan_ready_group1", arg_18_0.vars.team1)
	arg_18_0.vars.group_editor:updateGroupFormation("clan_ready_group2", arg_18_0.vars.team2)
	arg_18_0.vars.group_editor:updateGroupFormation("clan_ready_group3", arg_18_0.vars.pvp_info.enemy_team1)
	arg_18_0.vars.group_editor:updateGroupFormation("clan_ready_group4", arg_18_0.vars.pvp_info.enemy_team2)
end

function ClanTeamReady.setTeam(arg_19_0, arg_19_1)
end

function ClanTeamReady.updatePoint(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.vars.group_editor:getGroupEditor("clan_ready_group1")
	local var_20_1 = arg_20_0.vars.group_editor:getGroupEditor("clan_ready_group2")
	
	local function var_20_2(arg_21_0)
		arg_20_1 = arg_20_1 or {}
		
		local var_21_0 = arg_20_0.vars.wnd:getChildByName(arg_21_0)
		
		if var_21_0 then
			local var_21_1 = var_21_0:getChildByName("txt_point")
			
			if var_21_1 then
				UIAction:Add(INC_NUMBER(400, arg_20_1.cur, nil, arg_20_1.pre), var_21_1)
			end
		end
	end
	
	if var_20_0 and var_20_0:getFormation_wnd() == arg_20_1.wnd then
		var_20_2("n_power1")
	elseif var_20_1 and var_20_1:getFormation_wnd() == arg_20_1.wnd then
		var_20_2("n_power2")
	end
end

function ClanTeamReady.updateInfo(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_1 or not get_cocos_refid(arg_22_1) then
		return 
	end
	
	local var_22_0
	local var_22_1
	local var_22_2
	local var_22_3
	
	local function var_22_4(arg_23_0, arg_23_1)
		return ClanWar:getAttackerInfos(arg_23_1)[tostring(arg_23_0)] or {}
	end
	
	if not arg_22_2 then
		var_22_0 = arg_22_0.vars.wnd:getChildByName("n_my_formation")
		var_22_2 = AccountData.name
		var_22_1 = AccountData.level
		var_22_3 = var_22_4(Account:getUserId(), false)
	else
		local var_22_5 = arg_22_0.vars.pvp_info.enemy_info.defense_user_info or {}
		
		var_22_0 = arg_22_0.vars.wnd:getChildByName("n_peer_formation")
		var_22_2 = var_22_5.name
		var_22_1 = var_22_5.level
		var_22_3 = var_22_4(var_22_5.id, true)
	end
	
	local var_22_6 = var_22_0:getChildByName("infor")
	
	if_set(var_22_6, "txt_name", var_22_2)
	if_set(var_22_6, "txt_rating", T("pvp_point", {
		point = comma_value(var_22_3.destroy_score or 0)
	}))
	
	local var_22_7 = var_22_6:getChildByName("n_rank")
	
	if var_22_7 and var_22_1 then
		UIUtil:setLevel(var_22_7, var_22_1, MAX_ACCOUNT_LEVEL, 2)
	end
	
	if not arg_22_2 then
		UIUtil:setButtonEnterInfo(arg_22_0.vars.wnd:getChildByName("btn_clan_go"), "clan_war_01")
	end
end

function ClanTeamReady.onBattleBegin(arg_24_0, arg_24_1)
	local function var_24_0()
		arg_24_0.vars.pvp_info.enemy_info = arg_24_0.vars.pvp_info.enemy_info or {}
		
		local var_25_0 = arg_24_0.vars.pvp_info.enemy_info.slot
		local var_25_1 = arg_24_0.vars.pvp_info.enemy_info.clan_id
		local var_25_2 = string.format("cw:%s:%s", var_25_0, var_25_1)
		
		arg_24_0:saveTeamInfo()
		BattleClanWar:startPVP({
			enemy_uid = var_25_2,
			team1 = arg_24_0.vars.team1,
			team2 = arg_24_0.vars.team2,
			confirm_duplication = arg_24_1
		})
	end
	
	if Account:getCurrency("clanpvpkey") < 1 then
		Dialog:msgBox(T("war_err_msg002", {
			name = UIUtil:getTokenName("to_clanpvpkey")
		}))
		
		return 
	end
	
	local var_24_1 = arg_24_0.vars.group_editor:getTeamMemberCount("clan_ready_group1", true)
	local var_24_2 = arg_24_0.vars.group_editor:getTeamMemberCount("clan_ready_group2", true)
	
	if var_24_1 == 0 or var_24_2 == 0 then
		balloon_message_with_sound("war_ui_0011")
		
		return 
	end
	
	if var_24_1 + var_24_2 < 6 and arg_24_1 == nil then
		Dialog:msgBox(T("war_ui_0010"), {
			yesno = true,
			handler = var_24_0
		})
		
		return 
	end
	
	local var_24_3, var_24_4 = arg_24_0:checkTeam(arg_24_0.vars.team1)
	local var_24_5, var_24_6 = arg_24_0:checkTeam(arg_24_0.vars.team2)
	
	if var_24_4 == nil then
		var_24_4 = {}
	end
	
	if var_24_6 == nil then
		var_24_6 = {}
	end
	
	if var_24_4 and var_24_6 then
		for iter_24_0, iter_24_1 in pairs(var_24_6) do
			table.insert(var_24_4, iter_24_1)
		end
	end
	
	if (var_24_3 or var_24_5) and not table.empty(var_24_4) then
		local var_24_7 = var_24_3 or var_24_5
		
		Dialog:openDailySkipPopup("ClanTeamReady.unequip_stop_watching", {
			info = "expedition_daily_stop_desc",
			title = "pvp_unequip_character_desc",
			csd = "pvp_unequipped_hero",
			desc = var_24_7 or "pvp_team_warning",
			arg = var_24_4,
			func = var_24_0
		})
	else
		var_24_0()
	end
end

function ClanTeamReady.checkTeam(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	local var_26_0 = false
	local var_26_1 = {}
	
	for iter_26_0, iter_26_1 in pairs(arg_26_1) do
		if iter_26_1.is_unit and not iter_26_1:isSummon() and iter_26_1.getEquipByIndex then
			for iter_26_2 = 1, 7 do
				if not iter_26_1:getEquipByIndex(iter_26_2) then
					table.insert(var_26_1, iter_26_1)
					
					var_26_0 = true
					
					break
				end
			end
		end
	end
	
	if var_26_0 and not table.empty(var_26_1) then
		return "pvp_team_warning4", var_26_1
	end
end

function ClanTeamReady.onHeroListEvent(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0.vars.group_editor:onHeroListEventForFormationEditor(arg_27_1, arg_27_2, arg_27_3)
end

function ClanTeamReady.checkModelTouch(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1:getLocation()
	local var_28_1 = {}
	
	arg_28_0.vars.group_editor:collectModelInfos(var_28_1)
	
	for iter_28_0, iter_28_1 in pairs(var_28_1) do
		local var_28_2 = slowpick(arg_28_0.vars.wnd, iter_28_1.units, var_28_0.x, var_28_0.y)
		
		if var_28_2 then
			arg_28_0.vars.group_editor.vars.touched_group_name = iter_28_1.group
			arg_28_0.vars.group_editor.vars.touched_base_idx = var_28_2
			
			return true
		end
	end
end

function ClanTeamReady.onPushBackground(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	if not arg_29_0.vars.touched_model_idx then
		arg_29_0.vars.group_editor:setNormalMode()
	end
end

function ClanTeamReady.saveTeamInfo(arg_30_0)
	Account:saveLocalCustomTeam("clan_pvp_attack1", arg_30_0.vars.team1)
	Account:saveLocalCustomTeam("clan_pvp_attack2", arg_30_0.vars.team2)
	
	return false
end

function ClanTeamReady.initHandler(arg_31_0)
	local function var_31_0(arg_32_0, arg_32_1)
		return true
	end
	
	local function var_31_1(arg_33_0, arg_33_1)
		if TouchBlocker:isBlockingScene(SceneManager:getCurrentSceneName(), arg_33_0, arg_33_1) then
			return 
		end
		
		if arg_31_0:checkModelTouch(arg_33_0, arg_33_1) then
			arg_33_1:stopPropagation()
		else
			arg_31_0:onPushBackground()
		end
	end
	
	local var_31_2 = cc.EventListenerTouchOneByOne:create()
	local var_31_3 = arg_31_0.vars.wnd:getEventDispatcher()
	
	var_31_2:registerScriptHandler(var_31_0, cc.Handler.EVENT_TOUCH_BEGAN)
	var_31_2:registerScriptHandler(var_31_1, cc.Handler.EVENT_TOUCH_ENDED)
	var_31_3:addEventListenerWithSceneGraphPriority(var_31_2, arg_31_0.vars.wnd)
end
