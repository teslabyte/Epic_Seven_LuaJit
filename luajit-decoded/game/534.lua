ClanTeamDefence = {}

function HANDLER.clan_team_defence(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_auto" then
		ClanTeamDefence:onAutoTeam()
		TutorialGuide:procGuide()
	elseif arg_1_1 == "btn_defence_team" and ClanWarTeam:isShow() then
		ClanWarTeam:destroy()
		ClanWarTeam:show({
			mode = "clan_pvp_defence",
			parent = SceneManager:getRunningNativeScene()
		})
	end
end

function ClanTeamDefence.onCreate(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:create(arg_2_2)
	arg_2_1:addChild(arg_2_0.vars.wnd)
end

function ClanTeamDefence.create(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	arg_3_0.vars = {}
	arg_3_0.vars.team1_idx = arg_3_1.team1_idx or CLAN_TEAM_DEF_F
	arg_3_0.vars.team2_idx = arg_3_1.team2_idx or CLAN_TEAM_DEF_B
	arg_3_0.vars.completeCB = arg_3_1.completeCB
	arg_3_0.vars.wnd = load_dlg("clan_war_defense_team", true, "wnd")
	
	arg_3_0.vars.wnd:setName("clan_team_defence")
	arg_3_0.vars.wnd:setLocalZOrder(100)
	if_set_visible(arg_3_0.vars.wnd, "n_infor2", false)
	if_set_visible(arg_3_0.vars.wnd, " btn_ignore", false)
	if_set_visible(arg_3_0.vars.wnd, "btn_attack_team", false)
	if_set_visible(arg_3_0.vars.wnd, "btn_defence_team", false)
	arg_3_0:initHandler()
	arg_3_0:createFormation()
end

function ClanTeamDefence.createFormation(arg_4_0)
	local var_4_0 = load_dlg("clan_war_defense_formation", true, "wnd")
	local var_4_1 = load_dlg("clan_war_defense_formation", true, "wnd")
	
	arg_4_0.vars.wnd:getChildByName("form_pos1"):addChild(var_4_0)
	arg_4_0.vars.wnd:getChildByName("form_pos2"):addChild(var_4_1)
	var_4_0:setPosition(280, 240)
	var_4_1:setPosition(160, 240)
	
	local var_4_2 = {
		{
			use_detail = true,
			group_name = "group1",
			can_edit = true,
			wnd = var_4_0,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 3,
				text = T("war_ui_round", {
					round = "1"
				})
			}
		},
		{
			use_detail = true,
			group_name = "group2",
			can_edit = true,
			wnd = var_4_1,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 3,
				text = T("war_ui_round", {
					round = "2"
				})
			}
		}
	}
	local var_4_3 = {}
	
	GroupFormationEditor:initFormationEditor(var_4_3, {
		notUseTouchHandler = true,
		hide_hpbar = true,
		useSimpleTag = true,
		tagScale = 1,
		tagOffsetY = 45,
		hide_hpbar_color = true,
		infos = var_4_2,
		pvp_info = arg_4_0.vars.pvp_info,
		callbackUpdateFormation = function(arg_5_0)
			HeroBelt:updateTeamMarkers()
		end,
		callbackSelectUnit = function(arg_6_0)
			HeroBelt:scrollToUnit(arg_6_0)
		end,
		callbackSelectTeam = function(arg_7_0)
			arg_4_0:setTeam(arg_7_0)
		end,
		callbackUpdatePoint = function(arg_8_0)
			arg_4_0:updatePoint(arg_8_0)
		end,
		callbackCanAddUnit = function(arg_9_0)
			return true
		end
	})
	
	arg_4_0.vars.group_editor = var_4_3
end

function ClanTeamDefence.destroy(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	arg_10_0.vars.wnd:removeFromParent()
	
	arg_10_0.vars = {}
end

function ClanTeamDefence.setTeam(arg_11_0, arg_11_1)
end

function ClanTeamDefence.updatePoint(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or {}
	
	if arg_12_1.wnd then
		local var_12_0 = arg_12_1.wnd:getChildByName("txt_point")
		
		if var_12_0 then
			UIAction:Add(INC_NUMBER(400, arg_12_1.cur, nil, arg_12_1.pre), var_12_0)
		end
	end
end

function ClanTeamDefence.onEnter(arg_13_0, arg_13_1)
	arg_13_1 = arg_13_1 or {}
	
	local var_13_0 = HeroBelt:getCurrentControl()
	
	if var_13_0 then
		var_13_0.add:setVisible(true)
	end
	
	arg_13_0:updateGroupFormation()
	arg_13_0.vars.group_editor:setFormationEditMode(true)
	Analytics:setPopup("clan_defence_team")
	
	if arg_13_1.cb then
		arg_13_1.cb()
	end
end

function ClanTeamDefence.onLeave(arg_14_0)
	arg_14_0.vars.group_editor:setFormationEditMode(false)
	print("ClanTeamDefence OnLeave")
	Analytics:closePopup()
	ClanWarMain:updateEmtpyEquipSlotUI()
end

function ClanTeamDefence.updateGroupFormation(arg_15_0)
	arg_15_0.vars.group_editor:updateGroupFormation("group1", arg_15_0.vars.team1_idx)
	arg_15_0.vars.group_editor:updateGroupFormation("group2", arg_15_0.vars.team2_idx)
end

function ClanTeamDefence.onAutoTeam(arg_16_0)
	arg_16_0.vars.group_editor:setNormalMode()
	
	for iter_16_0 = 1, 4 do
		Account:removeFromTeamByPos(arg_16_0.vars.team1_idx, iter_16_0)
		Account:removeFromTeamByPos(arg_16_0.vars.team2_idx, iter_16_0)
	end
	
	local var_16_0 = table.shallow_clone(Account:getUnits())
	local var_16_1 = {}
	
	for iter_16_1, iter_16_2 in pairs(var_16_0) do
		if not iter_16_2:isGrowthBoostRegistered() then
			table.insert(var_16_1, iter_16_2)
		end
	end
	
	table.sort(var_16_1, UNIT.greaterThanPoint)
	
	local function var_16_2(arg_17_0, arg_17_1)
		for iter_17_0, iter_17_1 in pairs(arg_17_0) do
			if iter_17_1.inst.uid == arg_17_1.inst.uid then
				return false
			end
			
			if iter_17_1.db.code == arg_17_1.db.code then
				return false
			end
			
			if iter_17_1.db.set_group and iter_17_1.db.set_group == arg_17_1.db.set_group then
				return false
			end
		end
		
		return true
	end
	
	local var_16_3 = {}
	
	for iter_16_3, iter_16_4 in pairs(var_16_1) do
		if #var_16_3 > 5 then
			break
		end
		
		local var_16_4 = iter_16_4:isOrganizable()
		local var_16_5 = var_16_2(var_16_3, iter_16_4)
		
		if var_16_4 and not iter_16_4:isLockArenaAndClan() and var_16_5 then
			table.insert(var_16_3, iter_16_4)
		end
	end
	
	local var_16_6 = {
		arg_16_0.vars.team1_idx,
		arg_16_0.vars.team2_idx,
		arg_16_0.vars.team1_idx,
		arg_16_0.vars.team2_idx,
		arg_16_0.vars.team1_idx,
		arg_16_0.vars.team2_idx
	}
	local var_16_7 = {
		1,
		1,
		2,
		2,
		3,
		3
	}
	
	for iter_16_5, iter_16_6 in pairs(var_16_3) do
		Account:addToTeam(iter_16_6, var_16_6[iter_16_5], var_16_7[iter_16_5], true)
	end
	
	arg_16_0:updateGroupFormation()
end

function ClanTeamDefence.onHeroListEvent(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if arg_18_0.vars and arg_18_0.vars.group_editor then
		arg_18_0.vars.group_editor:onHeroListEventForFormationEditor(arg_18_1, arg_18_2, arg_18_3)
	end
end

function ClanTeamDefence.onPushBackground(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	if not arg_19_0.vars.touched_model_idx then
		arg_19_0.vars.group_editor:setNormalMode()
	end
end

function ClanTeamDefence.checkModelTouch(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1:getLocation()
	local var_20_1 = {}
	
	arg_20_0.vars.group_editor:collectModelInfos(var_20_1)
	
	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		local var_20_2 = slowpick(arg_20_0.vars.wnd, iter_20_1.units, var_20_0.x, var_20_0.y)
		
		if var_20_2 then
			arg_20_0.vars.group_editor.vars.touched_group_name = iter_20_1.group
			arg_20_0.vars.group_editor.vars.touched_base_idx = var_20_2
			
			return true
		end
	end
end

function ClanTeamDefence.initHandler(arg_21_0)
	local function var_21_0(arg_22_0, arg_22_1)
		return true
	end
	
	local function var_21_1(arg_23_0, arg_23_1)
		if TouchBlocker:isBlockingScene(SceneManager:getCurrentSceneName(), arg_23_0, arg_23_1) then
			return 
		end
		
		if arg_21_0:checkModelTouch(arg_23_0, arg_23_1) then
			arg_23_1:stopPropagation()
		else
			arg_21_0:onPushBackground()
		end
	end
	
	local var_21_2 = cc.EventListenerTouchOneByOne:create()
	local var_21_3 = arg_21_0.vars.wnd:getEventDispatcher()
	
	var_21_2:registerScriptHandler(var_21_0, cc.Handler.EVENT_TOUCH_BEGAN)
	var_21_2:registerScriptHandler(var_21_1, cc.Handler.EVENT_TOUCH_ENDED)
	var_21_3:addEventListenerWithSceneGraphPriority(var_21_2, arg_21_0.vars.wnd)
end

function ClanTeamDefence.saveTeamInfo(arg_24_0)
	return Account:saveTeamInfo() ~= nil
end
