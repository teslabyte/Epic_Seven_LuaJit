ClanWarTeam = {}
CLAN_TEAM_ATK_F = 13
CLAN_TEAM_ATK_B = 14
CLAN_TEAM_DEF_F = 15
CLAN_TEAM_DEF_B = 16
MAX_CLAN_TEAM_UNIT = 3

function ClanWarTeam.show(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.mode_list = {
		clan_pvp_ready = ClanTeamReady,
		clan_pvp_defence = ClanTeamDefence
	}
	
	local var_1_0 = {
		clan_pvp_defence = "war_ui_btn_name7",
		clan_pvp_ready = "war_ui_btn_name8"
	}
	
	arg_1_0.vars.parent = arg_1_1.parent or SceneManager:getDefaultLayer()
	arg_1_0.vars.base_wnd = load_dlg("event_bg", true, "wnd")
	
	arg_1_0.vars.base_wnd:setName("clan_war_team")
	
	arg_1_0.vars.completeCB = arg_1_1.completeCB
	
	if_set_visible(arg_1_0.vars.base_wnd, "bg", true)
	arg_1_0.vars.parent:addChild(arg_1_0.vars.base_wnd)
	TopBarNew:createFromPopup(T(var_1_0[arg_1_1.mode]), arg_1_0.vars.base_wnd, function()
		arg_1_0:onPushBackButton()
	end)
	TopBarNew:setCurrencies({
		"clanpvpkey"
	})
	arg_1_0:createHeroBelt(arg_1_1.mode)
	arg_1_0:setMode(arg_1_1)
	SoundEngine:play("event:/ui/main_hud/btn_hero")
	LuaEventDispatcher:removeEventListenerByKey("clan_war_team.update_unit_popup")
	LuaEventDispatcher:addEventListener("unit_popup_detail.close", LISTENER(arg_1_0.updateOnLeaveUnitPopupMode, arg_1_0), "clan_war_team.update_unit_popup")
end

function ClanWarTeam.updateOnLeaveUnitPopupMode(arg_3_0)
	if HeroBelt:isValid() and arg_3_0:isShow() then
		local var_3_0 = arg_3_0:getMode()
		local var_3_1 = table.shallow_clone(Account:getUnits())
		local var_3_2 = {}
		
		for iter_3_0, iter_3_1 in pairs(var_3_1) do
			if var_3_0 == "clan_pvp_ready" or not iter_3_1:isGrowthBoostRegistered() then
				table.insert(var_3_2, iter_3_1)
			end
		end
		
		HeroBelt:resetDataUseFilter(var_3_2, nil, nil, true, true)
	end
end

function ClanWarTeam.isShow(arg_4_0)
	return arg_4_0.vars and get_cocos_refid(arg_4_0.vars.base_wnd)
end

function ClanWarTeam.setMode(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}
	
	local var_5_0 = arg_5_1.mode
	
	if (arg_5_0.vars or {}).mode == var_5_0 then
		return 
	end
	
	set_high_fps_tick(5000)
	
	if var_5_0 == "clan_pvp_ready" then
		set_scene_fps(30)
	elseif var_5_0 == "clan_pvp_defence" then
		set_scene_fps(15)
		
		arg_5_1.team1_idx = CLAN_TEAM_DEF_F
		arg_5_1.team2_idx = CLAN_TEAM_DEF_B
	else
		Log.e("Invalid ClanWarTeam mode : ", var_5_0)
		
		return 
	end
	
	arg_5_0.vars.mode = var_5_0
	
	local var_5_1 = arg_5_0.vars.mode_list[arg_5_0.vars.mode]
	
	if var_5_1 then
		var_5_1:onCreate(arg_5_0.vars.base_wnd, arg_5_1)
	end
	
	if var_5_1 then
		UIAction:Add(SEQ(DELAY(80), CALL(var_5_1.onEnter, var_5_1, {
			cb = function()
				arg_5_0:showUnitList(true)
			end
		})), arg_5_0.vars.base_wnd, "block")
	end
end

function ClanWarTeam.getMode(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	return arg_7_0.vars.mode
end

function ClanWarTeam.createHeroBelt(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_8_0.vars.unit_dock) then
		arg_8_0.vars.unit_doc = nil
		
		HeroBelt:destroy()
	end
	
	arg_8_0.vars.unit_dock = HeroBelt:create(arg_8_1)
	
	arg_8_0.vars.unit_dock:setEventHandler(arg_8_0.onHeroListEvent, arg_8_0)
	arg_8_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_8_0.vars.base_wnd:addChild(arg_8_0.vars.unit_dock:getWindow())
	
	local var_8_0 = table.shallow_clone(Account:getUnits())
	local var_8_1 = {}
	
	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if arg_8_1 == "clan_pvp_ready" or not iter_8_1:isGrowthBoostRegistered() then
			table.insert(var_8_1, iter_8_1)
		end
	end
	
	HeroBelt:resetData(var_8_1, arg_8_1, nil, nil, nil)
	
	local var_8_2 = arg_8_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_8_0.vars.unit_dock:getWindow():setPositionX(var_8_2 + 300)
end

function ClanWarTeam.disableHeroList(arg_9_0)
	if arg_9_0.vars.unit_dock then
		arg_9_0.vars.unit_dock:removeEventHandler()
	end
end

function ClanWarTeam.onPushBackButton(arg_10_0)
	if arg_10_0.vars == nil then
		return 
	end
	
	arg_10_0:onLeave()
end

function ClanWarTeam.onLeave(arg_11_0)
	local var_11_0 = arg_11_0.vars.mode_list[arg_11_0.vars.mode]
	
	if var_11_0 and var_11_0.onLeave then
		var_11_0:onLeave()
		arg_11_0:showUnitList(false)
		TopBarNew:pop()
		BackButtonManager:pop("clan_war_team")
		
		if get_cocos_refid(arg_11_0.vars.base_wnd) then
			UIAction:Add(SEQ(DELAY(80), FADE_OUT(200), SHOW(false), DELAY(40), CALL(arg_11_0.destroy, arg_11_0)), arg_11_0.vars.base_wnd, "block")
		end
	end
end

function ClanWarTeam.destroy(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = false
	local var_12_1 = arg_12_0.vars.mode_list[arg_12_0.vars.mode]
	
	if var_12_1 and var_12_1.saveTeamInfo then
		var_12_0 = var_12_1:saveTeamInfo()
	end
	
	if var_12_0 and arg_12_0.vars.completeCB then
		arg_12_0.vars.completeCB(Account:getUserId(), ClanWarMain:makeLocalTeamData())
		
		arg_12_0.vars.completeCB = nil
	end
	
	HeroBelt:destroy()
	
	if get_cocos_refid(arg_12_0.vars.base_wnd) then
		arg_12_0.vars.base_wnd:removeFromParent()
	end
	
	LuaEventDispatcher:removeEventListenerByKey("clan_war_team.update_unit_popup")
	
	arg_12_0.vars = nil
end

function ClanWarTeam.onHeroListEvent(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0.vars.mode then
		local var_13_0 = arg_13_0.vars.mode_list[arg_13_0.vars.mode]
		
		if var_13_0 and var_13_0.onHeroListEvent then
			var_13_0:onHeroListEvent(arg_13_1, arg_13_2, arg_13_3)
		end
	end
end

function ClanWarTeam.showUnitList(arg_14_0, arg_14_1)
	if not get_cocos_refid(arg_14_0.vars.unit_dock:getWindow()) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.unit_dock:getWindow():getPositionX()
	
	if arg_14_1 then
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, var_14_0 - 300), 100)), arg_14_0.vars.unit_dock:getWindow(), "block")
	else
		UIAction:Add(SEQ(LOG(MOVE_TO(200, var_14_0 + 300), 100), SHOW(false)), arg_14_0.vars.unit_dock:getWindow(), "block")
	end
end

function ClanWarTeam.onTouchUp(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.vars or not arg_15_0.vars.mode then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.mode_list[arg_15_0.vars.mode]
	
	if var_15_0 and var_15_0.checkModelTouch then
		return var_15_0:checkModelTouch(arg_15_1, arg_15_2)
	end
end

function ClanWarTeam.onTouchDown(arg_16_0, arg_16_1, arg_16_2)
end

function ClanWarTeam.onTouchMove(arg_17_0, arg_17_1, arg_17_2)
end

function ClanWarTeam.onPushBackground(arg_18_0)
	if not arg_18_0.vars or not arg_18_0.vars.mode then
		return 
	end
	
	local var_18_0 = arg_18_0.vars.mode_list[arg_18_0.vars.mode]
	
	if not var_18_0 or not var_18_0.onPushBackground then
		return 
	end
	
	return var_18_0:onPushBackground()
end
