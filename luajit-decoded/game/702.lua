LotaBattleReady = {}

function HANDLER.clan_heritage_battle_ready(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ignore" then
		LotaBattleReady:onPushBackground()
	end
	
	if arg_1_1 == "btn_go" then
		LotaBattleReady:btnGo()
	end
	
	if arg_1_1 == "btn_up" then
		LotaBattleReady:downWeakLevel()
	end
	
	if arg_1_1 == "btn_down" then
		LotaBattleReady:upWeakLevel()
	end
	
	if arg_1_1 == "btn_reward_info" then
		LotaBattleReady:openRewardInfo()
	end
	
	if arg_1_1 == "btn_registration" then
		LotaBattleReady:openRegistration()
	end
end

function LotaBattleReady.isOpenRegistration(arg_2_0)
	return arg_2_0.vars and arg_2_0.vars.is_open_registration
end

function LotaBattleReady.openRegistration(arg_3_0)
	if LotaRegistrationUI:isAvailableEnter() then
		HeroBelt:destroy()
		
		arg_3_0.vars.is_open_registration = true
		
		LotaRegistrationUI:open(LotaSystem:getUIPopupLayer(), {
			register_list = LotaUserData:getRegistrationList(),
			close_callback = function()
				HeroBelt:destroy()
				LotaBattleReady:setupHeroBelt()
				
				arg_3_0.vars.is_open_registration = false
			end
		})
	else
		LotaRegistrationUI:sendWarningMessage()
	end
end

function LotaBattleReady.isOpenHeroInfo(arg_5_0)
	return arg_5_0.vars and arg_5_0.vars.is_open_information
end

function LotaBattleReady.openHeroInfoUI(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}
	
	function arg_6_1.close_callback()
		HeroBelt:destroy()
		LotaBattleReady:setupHeroBelt()
		LotaBattleReady:updateAllyFormation()
		
		arg_6_0.vars.is_open_information = false
	end
	
	HeroBelt:destroy()
	
	arg_6_0.vars.is_open_information = true
	
	LotaHeroInformationUI:open(LotaSystem:getUIPopupLayer(), arg_6_1)
end

function LotaBattleReady.sendNormalBattleStartQuery(arg_8_0)
	local var_8_0 = Account:saveTeamInfo(true)
	
	LotaNetworkSystem:sendQuery("lota_start_battle", {
		tile_id = arg_8_0:getTileId(),
		team = arg_8_0.vars.team_idx,
		update_team_info = var_8_0,
		weak_lv = arg_8_0.vars.weak_lv
	})
end

function LotaBattleReady.sendEventBattleStartQuery(arg_9_0)
	local var_9_0 = Account:saveTeamInfo(true)
	
	LotaEventSystem:selectBattleEvent()
	LotaNetworkSystem:sendQuery("lota_start_event_battle", {
		tile_id = arg_9_0:getTileId(),
		team = arg_9_0.vars.team_idx,
		update_team_info = var_9_0,
		event_select_id = arg_9_0.vars.event.id
	})
end

function LotaBattleReady.makeWeakConfirm(arg_10_0)
	local var_10_0 = arg_10_0:getWeakInformation()
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = load_dlg("msgbox_monster_weak", true, "wnd")
	local var_10_2 = var_10_1:findChildByName("n_item")
	local var_10_3 = var_10_0.token
	local var_10_4 = UIUtil:getRewardIcon(nil, var_10_3, {
		show_name = true
	})
	
	var_10_2:addChild(var_10_4)
	if_set(var_10_1, "txt_have", T("ui_msgbox_monster_weak_have", {
		have = LotaUserData:getActionPoint()
	}))
	
	local var_10_5 = DB("item_token", var_10_3, "icon")
	local var_10_6 = "item/" .. (var_10_5 or "") .. ".png"
	local var_10_7 = SpriteCache:getSprite(var_10_6)
	
	var_10_1:findChildByName("n_token_icon"):addChild(var_10_7)
	
	local var_10_8 = arg_10_0:getWeakCost(arg_10_0.vars.weak_lv)
	local var_10_9 = var_10_1:findChildByName("window_frame"):findChildByName("btn_ok")
	
	if_set(var_10_9, "t_token", var_10_8)
	
	return var_10_1
end

function LotaBattleReady.realGo(arg_11_0)
	Account:resetTeam(arg_11_0.vars.team_idx)
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.lota_team) do
		if iter_11_1 then
			local var_11_0 = Account:getUnit(iter_11_1:getUID())
			
			Account:addToTeam(var_11_0, arg_11_0.vars.team_idx, iter_11_0)
		end
	end
	
	BattleRepeat:disableRepeatBattleCount()
	
	if arg_11_0.vars.event then
		arg_11_0:sendEventBattleStartQuery()
	elseif arg_11_0.vars.type == "normal_monster" then
		if arg_11_0.vars.weak_lv > 0 then
			local var_11_1 = arg_11_0:makeWeakConfirm()
			
			Dialog:msgBox(T("ui_msgbox_clanheritage_weak", {
				nerf_range = arg_11_0.vars.weak_lv * 10
			}), {
				yesno = true,
				handler = function()
					arg_11_0:sendNormalBattleStartQuery()
				end,
				dlg = var_11_1
			})
		else
			arg_11_0:sendNormalBattleStartQuery()
		end
	else
		local function var_11_2()
			if arg_11_0:checkClear() then
				return 
			end
			
			local var_13_0 = Account:saveTeamInfo(true)
			
			LotaNetworkSystem:sendQuery("lota_start_coop_battle", {
				tile_id = arg_11_0:getTileId(),
				team = arg_11_0.vars.team_idx,
				update_team_info = var_13_0
			})
		end
		
		local var_11_3 = arg_11_0:getMyExpeditionInfos()
		
		if var_11_3 and to_n(var_11_3.count) > 0 then
			Dialog:openDailySkipPopup("lota.stop_watching", {
				info = "ui_clan_heritage_coop_warning_desc2",
				title = "ui_clan_heritage_coop_warning_title",
				desc = "ui_clan_heritage_coop_warning_desc",
				func = var_11_2
			})
		else
			var_11_2()
		end
	end
end

function LotaBattleReady.getMyExpeditionInfos(arg_14_0)
	return ((arg_14_0.vars.data.res or {}).expedition_users or {})[Account:getUserId()]
end

function LotaBattleReady.btnGo(arg_15_0)
	if arg_15_0.vars.check_use_token > LotaUserData:getActionPoint() then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return 
	end
	
	local var_15_0 = arg_15_0:getWeakInformation()
	
	if arg_15_0.vars.weak_lv > 0 and var_15_0 and var_15_0.token and var_15_0.action_point and arg_15_0:getWeakCost(arg_15_0.vars.weak_lv) + arg_15_0.vars.check_use_token > LotaUserData:getActionPoint() then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return 
	end
	
	if table.count(arg_15_0:getPartyUIDList()) <= 0 then
		balloon_message_with_sound("msg_clan_heritage_no_hero")
		
		return 
	end
	
	if not LotaUtil:isSlotHaveRemainEnterCount(arg_15_0.vars.tile_id) then
		balloon_message_with_sound("msg_clan_heritage_normal_warning")
		
		return 
	end
	
	local var_15_1, var_15_2 = arg_15_0:isTeamOk()
	
	if not var_15_1 then
		Log.e("TRY LOTA PARTY, BUT REASON : ", var_15_2)
		
		return 
	end
	
	arg_15_0:realGo()
end

function LotaBattleReady.getTileId(arg_16_0)
	return arg_16_0.vars.tile_id
end

function LotaBattleReady.responseSync(arg_17_0, arg_17_1)
	if arg_17_0.vars.open_ready then
		print(" res.no_info_reason??", arg_17_1.no_info_reason)
		
		if arg_17_1.no_info_reason then
			local var_17_0 = arg_17_0.vars.ready_data.object_id
			local var_17_1 = LotaUtil:getBossInfo(var_17_0)
			
			arg_17_0.vars.ready_data.res = LotaUtil:genResponse(var_17_1)
		else
			arg_17_0.vars.ready_data.res = arg_17_1
		end
		
		arg_17_0:show(arg_17_0.vars.ready_data)
	else
		if not arg_17_1.no_info_reason then
			arg_17_0.vars.data.res = arg_17_1
		end
		
		arg_17_0:updateByResponse()
	end
end

function LotaBattleReady.isWaitResponse(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	return arg_18_0.vars.open_ready
end

function LotaBattleReady.isCoop(arg_19_0)
	local var_19_0 = arg_19_0.vars.data.boss_room
	local var_19_1 = arg_19_0.vars.data.elite_room
	
	return var_19_0 or var_19_1
end

function LotaBattleReady.openReady(arg_20_0, arg_20_1)
	arg_20_0.vars = {}
	arg_20_0.vars.ready_data = arg_20_1
	arg_20_0.vars.open_ready = true
	
	LotaNetworkSystem:sendQuery("lota_battle_sync", {
		tile_id = arg_20_1.tile_id,
		battle_id = LotaUtil:getBattleId(arg_20_1.tile_id)
	})
end

function LotaBattleReady.openRewardInfo(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	LotaUtil:openRewardPreviewDlg(arg_21_0.vars.reward_id, arg_21_0.vars.object_id)
end

function LotaBattleReady.show(arg_22_0, arg_22_1)
	local var_22_0 = LotaSystem:getUIPopupLayer()
	
	arg_22_0.vars = {}
	arg_22_0.vars.data = arg_22_1 or {}
	
	if arg_22_0.vars.data.tile_id then
		arg_22_0.vars.data.tile_id = tostring(arg_22_0.vars.data.tile_id)
	end
	
	local var_22_1 = arg_22_0.vars.data.object_id
	
	arg_22_0.vars.tile_id = arg_22_0.vars.data.tile_id
	arg_22_0.vars.object_id = var_22_1
	arg_22_0.vars.enter_id, arg_22_0.vars.type, arg_22_0.vars.monster_level, arg_22_0.vars.use_token, arg_22_0.vars.add_use_token, arg_22_0.vars.nerf_action_point, arg_22_0.vars.nerf_token, arg_22_0.vars.nerf_value, arg_22_0.vars.reward_id = DB("clan_heritage_object_data", var_22_1, {
		"level_id",
		"type_2",
		"monster_level",
		"use_token",
		"add_use_token",
		"nerf_action_point",
		"nerf_token",
		"nerf_value",
		"reward_id"
	})
	arg_22_0.vars.add_use_token = arg_22_0.vars.add_use_token or 0
	
	if arg_22_0.vars.data.event then
		arg_22_0.vars.event = arg_22_0.vars.data.event
		arg_22_0.vars.add_use_token = 0
		arg_22_0.vars.use_token, arg_22_0.vars.reward_id = DB("clan_heritage_event_select", arg_22_0.vars.event.id, {
			"need_token",
			"reward_id"
		})
	end
	
	arg_22_0.vars.check_use_token = arg_22_0.vars.use_token + arg_22_0.vars.add_use_token
	arg_22_0.vars.open_ready = false
	arg_22_0.vars.weak_lv = 0
	arg_22_0.vars.toggle_edit = false
	
	if arg_22_0:checkClear() then
		return 
	end
	
	arg_22_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_battle_ready")
	
	arg_22_0.vars.dlg:setLocalZOrder(999999)
	var_22_0:addChild(arg_22_0.vars.dlg)
	arg_22_0:initUI()
	TopBarNew:createFromPopup(T("battle_ready"), arg_22_0.vars.dlg, function()
		LotaBattleReady:onButtonClose()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritagebattle")
	TopBarNew:setDisableLobbyAuto()
	
	local var_22_2 = LotaUserData:getUsableUIDList()
	local var_22_3 = LotaUserData:getRegistrationList()
	local var_22_4 = LotaUserData:getMaxHeroCount()
	
	if table.count(var_22_2) < 4 and var_22_4 - table.count(var_22_3) > 0 and table.count(var_22_3) ~= 0 then
		local var_22_5 = Dialog:msgBox(T("msg_clan_heritage_hero_lack"), {
			yesno = true,
			handler = function()
				arg_22_0:openRegistration()
			end
		}):findChildByName("n_buttons"):findChildByName("btn_yes")
		
		if_set(var_22_5, "txt_yes", T("btn_clanheritage_status_registration"))
	end
	
	TutorialGuide:startGuide("tuto_heritage_register")
end

function LotaBattleReady.close(arg_25_0)
	arg_25_0:onButtonClose()
end

function LotaBattleReady.initUI(arg_26_0)
	local var_26_0 = arg_26_0.vars.data.boss_room
	local var_26_1 = arg_26_0.vars.data.elite_room
	
	if var_26_1 then
		arg_26_0:setupInformation(arg_26_0.vars.enter_id, true)
	elseif not var_26_0 then
		arg_26_0:setupInformation(arg_26_0.vars.enter_id)
	else
		arg_26_0.vars.req_point = BattleReady:GetReqPointAndRewards(arg_26_0.vars.enter_id)
	end
	
	arg_26_0:setupFormation()
	arg_26_0:setupHeroBelt()
	arg_26_0:setupWindowReadyDifficulty()
	arg_26_0:setupBtnGo()
	
	local var_26_2 = arg_26_0.vars.dlg:findChildByName("getitem")
	
	if_set_visible(var_26_2, nil, false)
	
	if var_26_0 then
		arg_26_0:initBossUI(arg_26_0.vars.enter_id)
	elseif var_26_1 then
		arg_26_0:initEliteRoom(arg_26_0.vars.enter_id)
		arg_26_0:setupInformation(arg_26_0.vars.enter_id, true)
	elseif arg_26_0.vars.event then
		arg_26_0:setupInformation(arg_26_0.vars.enter_id)
		arg_26_0:setupReward()
		if_set_visible(var_26_2, nil, true)
	else
		arg_26_0:setupInformation(arg_26_0.vars.enter_id)
		arg_26_0:setupCountClear()
		arg_26_0:setupReward()
		arg_26_0:setupWeakInformation()
		if_set_visible(var_26_2, nil, true)
	end
	
	if_set_visible(arg_26_0.vars.dlg, "btn_reward_info", var_26_0 or var_26_1)
end

function LotaBattleReady.setupBtnGo(arg_27_0)
	local var_27_0 = arg_27_0.vars.dlg:findChildByName("btn_go")
	local var_27_1 = LotaUserData:getActionPoint()
	local var_27_2 = arg_27_0.vars.check_use_token
	
	if_set(var_27_0, "cost", var_27_2 .. "/" .. var_27_1)
end

function LotaBattleReady.initBossUI(arg_28_0)
	local var_28_0 = arg_28_0.vars.dlg:findChildByName("n_boss")
	
	if_set_visible(var_28_0, nil, true)
	
	local var_28_1 = var_28_0:findChildByName("scroll_boss_skill")
	local var_28_2 = arg_28_0.vars.data.res
	
	LotaUtil:createBossSkillList(var_28_1, LotaUtil:getSkillList(var_28_2.expedition_info.boss_info.character_id))
	arg_28_0:updateBossRoom()
	
	local var_28_3 = DB("level_enter", arg_28_0.vars.enter_id, {
		"name"
	})
	local var_28_4 = arg_28_0.vars.dlg:findChildByName("n_top")
	
	if_set(var_28_4, "txt_title", T(var_28_3))
end

function LotaBattleReady.initEliteRoom(arg_29_0)
	local var_29_0 = arg_29_0.vars.dlg:findChildByName("n_boss_elite")
	
	if_set_visible(var_29_0, nil, true)
	
	arg_29_0.vars.member_list = LotaUtil:createMembersList(arg_29_0.vars.dlg:findChildByName("n_boss_elite"), arg_29_0.vars.data.res.expedition_users, {
		scroll_view_name = "ScrollView_damage_rank"
	})
	
	arg_29_0:updateEliteRoom()
end

function LotaBattleReady.updateBossRoom(arg_30_0)
	local var_30_0 = arg_30_0.vars.data.res.expedition_info
	
	LotaUtil:updateBossInfoUI(arg_30_0.vars.dlg, var_30_0, arg_30_0.vars.hp_rate, {
		n_boss_name = "n_boss"
	})
	
	local var_30_1 = CoopUtil:getBossHpRate(var_30_0.boss_info.max_hp, var_30_0.last_hp)
	
	arg_30_0.vars.hp_rate = var_30_1
end

function LotaBattleReady.updateEliteRoom(arg_31_0)
	local var_31_0 = arg_31_0.vars.data.res.expedition_info
	
	LotaUtil:updateBossInfoUI(arg_31_0.vars.dlg, var_31_0, arg_31_0.vars.hp_rate, {
		n_boss_name = "n_boss_elite"
	})
	
	local var_31_1 = CoopUtil:getBossHpRate(var_31_0.boss_info.max_hp, var_31_0.last_hp)
	
	arg_31_0.vars.hp_rate = var_31_1
	
	LotaUtil:updateMembersList(arg_31_0.vars.member_list, arg_31_0.vars.dlg:findChildByName("n_boss_elite"), arg_31_0.vars.data.res.expedition_users)
end

function LotaBattleReady.getLastHP(arg_32_0)
	if not arg_32_0.vars or not arg_32_0.vars.data or not arg_32_0.vars.data.res then
		return 
	end
	
	local var_32_0 = arg_32_0.vars.data.boss_room
	local var_32_1 = arg_32_0.vars.data.elite_room
	
	if not var_32_0 and not var_32_1 then
		return 
	end
	
	local var_32_2 = arg_32_0.vars.data.res.expedition_info
	
	return to_n(var_32_2.last_hp)
end

function LotaBattleReady.closeByAlreadyDead(arg_33_0)
	arg_33_0:close()
	Dialog:closeAll()
	Dialog:msgBox(T("msg_clan_heritage_enterfail"))
end

function LotaBattleReady.checkClear(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	local var_34_0 = arg_34_0:getLastHP()
	
	if not var_34_0 then
		return false
	end
	
	if var_34_0 <= 0 then
		arg_34_0:closeByAlreadyDead()
		
		return true
	end
	
	return false
end

function LotaBattleReady.updateByResponse(arg_35_0)
	if arg_35_0.vars.data.boss_room then
		arg_35_0:updateBossRoom()
	else
		arg_35_0:updateEliteRoom()
	end
	
	arg_35_0:checkClear()
end

function LotaBattleReady.getEnemies(arg_36_0, arg_36_1)
	local var_36_0 = {}
	
	for iter_36_0, iter_36_1 in pairs(arg_36_1) do
		table.push(var_36_0, {
			iter_36_1.m,
			iter_36_1.lv,
			iter_36_1.tier
		})
	end
	
	table.sort(var_36_0, function(arg_37_0, arg_37_1)
		if arg_37_0[3] ~= arg_37_1[3] then
			if arg_37_0[3] == "boss" then
				return true
			end
			
			if arg_37_1[3] == "boss" then
				return false
			end
			
			if arg_37_0[3] == "subboss" then
				return true
			end
			
			if arg_37_1[3] == "subboss" then
				return false
			end
			
			if arg_37_0[3] == "elite" then
				return true
			end
			
			if arg_37_1[3] == "elite" then
				return false
			end
			
			return false
		end
		
		return arg_37_0[2] > arg_37_1[2]
	end)
	
	return var_36_0
end

function LotaBattleReady.isActive(arg_38_0)
	return arg_38_0.vars and get_cocos_refid(arg_38_0.vars.dlg)
end

function LotaBattleReady.getWeakInformation(arg_39_0)
	if arg_39_0.vars.type ~= "normal_monster" then
		return 
	end
	
	local var_39_0 = {
		token = arg_39_0.vars.nerf_token,
		value = arg_39_0.vars.nerf_value,
		action_point = arg_39_0.vars.nerf_action_point,
		weak_lv = arg_39_0.vars.weak_lv
	}
	
	if var_39_0.action_point == nil and var_39_0.token == nil then
		return 
	end
	
	return var_39_0
end

function LotaBattleReady.updateWeakInformationUI(arg_40_0)
	local var_40_0 = arg_40_0:getWeakInformation()
	local var_40_1 = arg_40_0.vars.weak_point_info
	
	if_set_visible(var_40_1, "n_weak_disable", var_40_0 == nil)
	if_set_visible(var_40_1, "n_weak_enable", var_40_0 ~= nil)
	
	if var_40_0 == nil then
		return 
	end
	
	for iter_40_0 = 1, 3 do
		local var_40_2 = var_40_1:getChildByName("lv_" .. iter_40_0)
		
		if get_cocos_refid(var_40_2) then
			if_set_visible(var_40_2, "on", iter_40_0 == var_40_0.weak_lv)
			if_set_visible(var_40_2, "off", iter_40_0 ~= var_40_0.weak_lv)
		end
	end
	
	if arg_40_0.vars.weak_lv == 3 then
		if_set_opacity(var_40_1, "btn_down", 102)
	else
		if_set_opacity(var_40_1, "btn_down", 255)
	end
	
	if arg_40_0.vars.weak_lv == 0 then
		if_set_opacity(var_40_1, "btn_up", 102)
	else
		if_set_opacity(var_40_1, "btn_up", 255)
	end
	
	local var_40_3 = var_40_0.token
	
	if var_40_1.nerf_token ~= var_40_3 then
		UIUtil:getRewardIcon(nil, var_40_3, {
			no_count = true,
			no_frame = true,
			parent = var_40_1:getChildByName("nerf_token")
		})
		
		var_40_1.nerf_token = var_40_3
	end
	
	local var_40_4 = math.floor(to_n(var_40_0.value) * var_40_0.weak_lv)
	
	if var_40_4 > 0 then
		var_40_4 = var_40_4 * -1
	end
	
	if_set(var_40_1, "t_count", var_40_4)
end

function LotaBattleReady.upWeakLevel(arg_41_0)
	arg_41_0:updateWeakInformation(arg_41_0.vars.weak_lv + 1)
end

function LotaBattleReady.downWeakLevel(arg_42_0)
	arg_42_0:updateWeakInformation(arg_42_0.vars.weak_lv - 1)
end

function LotaBattleReady.getWeakCost(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0:getWeakInformation()
	
	if var_43_0.action_point then
		return var_43_0.action_point * arg_43_1
	else
		return var_43_0.value * arg_43_1
	end
end

function LotaBattleReady.updateWeakInformation(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0:getWeakInformation()
	local var_44_1 = false
	
	if arg_44_1 > 3 then
		balloon_message_with_sound("clanheritage_weak_cant_max")
		
		return 
	elseif arg_44_1 < 0 then
		balloon_message_with_sound("clanheritage_weak_max")
		
		return 
	end
	
	local var_44_2 = arg_44_0:getWeakCost(arg_44_1)
	
	if var_44_0.action_point then
		var_44_1 = LotaUserData:getActionPoint() >= var_44_2 + arg_44_0.vars.check_use_token
	else
		var_44_1 = var_44_2 <= Account:getItemCount(var_44_0.token)
	end
	
	if not var_44_1 then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return 
	end
	
	arg_44_0.vars.weak_lv = arg_44_1
	
	arg_44_0:updateWeakInformationUI()
end

function LotaBattleReady.setupWeakInformation(arg_45_0)
	local var_45_0 = arg_45_0.vars.dlg:findChildByName("n_content"):findChildByName("n_monster_weak")
	
	if_set_visible(var_45_0, nil, true)
	
	arg_45_0.vars.weak_point_info = var_45_0
	
	arg_45_0:updateWeakInformationUI()
end

function LotaBattleReady.setupInformation(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0, var_46_1, var_46_2, var_46_3, var_46_4 = DB("level_enter", arg_46_1, {
		"name",
		"local",
		"type",
		"tag_icon",
		"subcus_value"
	})
	local var_46_5 = arg_46_0.vars.dlg:findChildByName("n_top")
	
	if_set(var_46_5, "txt_title", T(var_46_0))
	
	arg_46_0.vars.ScrollEnemy = {}
	
	copy_functions(ScrollView, arg_46_0.vars.ScrollEnemy)
	
	function arg_46_0.vars.ScrollEnemy.getScrollViewItem(arg_47_0, arg_47_1)
		return UIUtil:getRewardIcon("c", arg_47_1[1], {
			no_db_grade = true,
			scale = 0.85,
			dlg_name = "battle_ready",
			hide_star = true,
			monster = true,
			lv = arg_47_1[2],
			tier = arg_47_1[3]
		})
	end
	
	local var_46_6, var_46_7, var_46_8 = BattleReady:GetReqPointAndRewards(arg_46_1)
	
	arg_46_0.vars.req_point = var_46_6
	
	local var_46_9 = arg_46_0:getEnemies(var_46_7)
	local var_46_10 = arg_46_0.vars.dlg:getChildByName("scroll_enemy")
	
	if arg_46_2 then
		local var_46_11 = arg_46_0.vars.dlg:findChildByName("scroll_enemy_move")
		local var_46_12 = {
			height = 100,
			width = var_46_10:getContentSize().width
		}
		
		var_46_10:setPosition(var_46_11:getPosition())
		var_46_10:setContentSize(var_46_12)
		var_46_10:setInnerContainerSize(var_46_12)
	end
	
	arg_46_0.vars.ScrollEnemy:initScrollView(var_46_10, 75, 88)
	arg_46_0.vars.ScrollEnemy:createScrollViewItems(var_46_9)
	var_46_10:jumpToPercentVertical(0)
	var_46_10:jumpToPercentHorizontal(0)
	if_set_visible(var_46_10, nil, true)
end

function LotaBattleReady.setupCountClear(arg_48_0)
	local var_48_0 = LotaObjectSystem:getObject(arg_48_0.vars.tile_id)
	
	if not var_48_0 then
		Log.e("NOT EXIST MONSTER")
		
		return 
	end
	
	local var_48_1 = arg_48_0.vars.dlg:findChildByName("n_count_clear")
	
	if_set_visible(var_48_1, nil, true)
	
	local var_48_2 = var_48_0:getMaxUse()
	local var_48_3 = var_48_0:getClanObjectUseCount()
	
	for iter_48_0 = 1, 5 do
		if var_48_2 < iter_48_0 then
			if_set_visible(var_48_1, "icon_clear" .. iter_48_0, false)
			if_set_visible(var_48_1, "icon_off" .. iter_48_0, false)
		else
			if_set_visible(var_48_1, "icon_clear" .. iter_48_0, var_48_3 < iter_48_0)
			if_set_visible(var_48_1, "icon_off" .. iter_48_0, iter_48_0 <= var_48_3)
		end
	end
end

function LotaBattleReady.setupWindowReadyDifficulty(arg_49_0)
	local var_49_0 = arg_49_0.vars.dlg:findChildByName("n_window_ready")
	local var_49_1 = var_49_0:findChildByName("txt_title")
	local var_49_2 = var_49_0:findChildByName("n_difficulty_enable")
	local var_49_3 = var_49_2:findChildByName("n_icon_difficulty")
	local var_49_4 = ({
		keeper_monster = "guardian",
		boss_monster = "boss",
		elite_monster = "elite"
	})[arg_49_0.vars.type]
	
	if_set_visible(var_49_2, nil, arg_49_0.vars.type ~= "normal_monster")
	
	if arg_49_0.vars.type == "normal_monster" then
		return 
	end
	
	local var_49_5 = {
		"elite",
		"boss",
		"guardian",
		"normal"
	}
	local var_49_6 = var_49_2:findChildByName("label")
	local var_49_7 = {
		keeper_monster = "ui_clan_heritage_battle_ready_keeper",
		boss_monster = "ui_clan_heritage_battle_ready_boss",
		elite_monster = "ui_clan_heritage_battle_ready_elite"
	}
	local var_49_8 = {
		elite_monster = cc.c3b(91, 144, 241),
		keeper_monster = cc.c3b(216, 88, 224),
		boss_monster = cc.c3b(254, 69, 49)
	}
	
	if var_49_7[arg_49_0.vars.type] then
		if_set(var_49_6, nil, T(var_49_7[arg_49_0.vars.type]))
	end
	
	if_set_color(var_49_6, nil, var_49_8[arg_49_0.vars.type])
	
	local var_49_9 = 50
	local var_49_10 = 22
	local var_49_11 = var_49_6:getContentSize().width * var_49_6:getScaleX() + var_49_9 + var_49_10
	
	var_49_1:setPositionX(var_49_1:getPositionX() + var_49_11)
	
	for iter_49_0, iter_49_1 in pairs(var_49_5) do
		if_set_visible(var_49_3, iter_49_1, iter_49_1 == var_49_4)
	end
	
	if_set_visible(var_49_1, "i", true)
end

function LotaBattleReady.setupNeedLevel(arg_50_0)
	local var_50_0 = arg_50_0.vars.dlg:findChildByName("n_window_ready")
	
	if not arg_50_0.vars.monster_level then
		arg_50_0.vars.monster_level = 1
		
		Log.e("MONSTER LEVEL EMPTY! EMPTY! EMPTY!", arg_50_0.vars.object_id)
	end
	
	LotaUtil:updateLevelIconWithLv(var_50_0, arg_50_0.vars.monster_level, {
		n_expedition_level_name = "n_need_expedition_level"
	})
	
	local var_50_1 = var_50_0:findChildByName("n_need_expedition_level")
	
	if_set_visible(var_50_1, nil, true)
end

function LotaBattleReady.setupReward(arg_51_0)
	if not arg_51_0.vars.reward_id then
		return 
	end
	
	local var_51_0 = arg_51_0.vars.object_id
	
	if arg_51_0.vars.event then
		var_51_0 = nil
	end
	
	local var_51_1 = LotaUtil:getRewardData(arg_51_0.vars.reward_id, var_51_0)
	
	arg_51_0.vars.ScrollItems = {}
	
	copy_functions(ScrollView, arg_51_0.vars.ScrollItems)
	
	function arg_51_0.vars.ScrollItems.getScrollViewItem(arg_52_0, arg_52_1)
		return LotaUtil:getPreviewItemIcon(arg_52_1)
	end
	
	local var_51_2 = arg_51_0.vars.dlg:findChildByName("n_window_ready"):findChildByName("getitem"):findChildByName("scroll_item")
	
	var_51_2:removeAllChildren()
	arg_51_0.vars.ScrollItems:initScrollView(var_51_2, 85, 85, {
		skip_anchor = true
	})
	arg_51_0.vars.ScrollItems:createScrollViewItems(var_51_1)
end

function LotaBattleReady.setupFormation(arg_53_0)
	local var_53_0 = load_control("wnd/clan_heritage_battle_ready_formation.csb", true)
	
	arg_53_0.vars.dlg:findChildByName("n_formation"):addChild(var_53_0)
	
	var_53_0.class = arg_53_0
	
	CustomFormationEditor:initFormationEditor(arg_53_0, {
		is_lota = true,
		sprite_mode = true,
		ignore_team_selector = true,
		can_edit = true,
		wnd = var_53_0,
		req_point = arg_53_0.vars.req_point,
		callbackSelectTeam = function(arg_54_0)
		end,
		callbackSelectUnit = function(arg_55_0)
			HeroBelt:scrollToUnit(arg_55_0)
		end,
		ui_handler = function(arg_56_0, arg_56_1)
			if string.match(arg_56_1, "btn%d") and not arg_53_0.vars.edit_mode and not arg_53_0.vars.npcteam_id then
			end
		end
	})
	
	for iter_53_0 = 1, 4 do
		local var_53_1 = var_53_0:findChildByName("btn_add_" .. iter_53_0)
		
		if_set_visible(var_53_1, nil, false)
	end
	
	arg_53_0.vars.lota_team = {}
	arg_53_0.vars.team_idx = 26
	
	Account:resetTeam(arg_53_0.vars.team_idx)
	arg_53_0:addFormationUpdateLuaEvent("lota")
	
	function arg_53_0.vars.onFormationResEvent_UpdateFormation()
		arg_53_0:updateAllyFormation()
	end
	
	function arg_53_0.vars.onFormationResEvent_UpdateTeamPoint()
		arg_53_0:updateAllyTeamPoint()
	end
	
	arg_53_0:updateFormation(arg_53_0.vars.lota_team)
end

function LotaBattleReady.updateAllyFormation(arg_59_0)
	arg_59_0:updateLotaUnits()
	arg_59_0:updateFormation(arg_59_0.vars.lota_team)
end

function LotaBattleReady.updateAllyTeamPoint(arg_60_0)
	arg_60_0:updateLotaUnits()
	arg_60_0:updateTeamPoint(arg_60_0.vars.lota_team)
end

function LotaBattleReady.onDedicationPopup(arg_61_0)
	arg_61_0:updateLotaUnits()
	
	arg_61_0.vars.custom_team = arg_61_0.vars.lota_team
end

function LotaBattleReady.onPushBackground(arg_62_0)
	if not arg_62_0.vars then
		return 
	end
	
	arg_62_0:setNormalMode()
end

function LotaBattleReady.getPartyUIDList(arg_63_0)
	local var_63_0 = arg_63_0.vars.lota_team
	local var_63_1 = {}
	
	for iter_63_0, iter_63_1 in pairs(var_63_0) do
		if iter_63_1 then
			table.insert(var_63_1, iter_63_1:getUID())
		end
	end
	
	return var_63_1
end

function LotaBattleReady.isTeamOk(arg_64_0)
	local var_64_0 = Account:getTeam(arg_64_0.vars.team_idx)
	
	for iter_64_0, iter_64_1 in pairs(var_64_0) do
		if not LotaUserData:isRegistration(iter_64_1) then
			return false, "NOT_REGISTRATION"
		end
		
		if not LotaUserData:isUsableUnit(iter_64_1) then
			return false, "NOT_USABLE"
		end
	end
	
	return true
end

function LotaBattleReady.updateLotaUnits(arg_65_0)
	arg_65_0.vars.lota_units = LotaUtil:getLotaUnits()
	
	arg_65_0:updateLotaTeam()
	arg_65_0:updateHeroBelt()
end

function LotaBattleReady.updateLotaTeam(arg_66_0)
	local var_66_0 = arg_66_0.vars.lota_units
	local var_66_1 = arg_66_0.vars.lota_team
	
	for iter_66_0 = 1, 4 do
		if var_66_1[iter_66_0] then
			if LotaUserData:isRegistration(var_66_1[iter_66_0]) then
				for iter_66_1, iter_66_2 in pairs(var_66_0) do
					if iter_66_2:getUID() == var_66_1[iter_66_0]:getUID() then
						var_66_1[iter_66_0] = iter_66_2
						
						break
					end
				end
			else
				var_66_1[iter_66_0] = nil
			end
		end
	end
end

function LotaBattleReady.setupHeroBelt(arg_67_0)
	if not arg_67_0.vars or not get_cocos_refid(arg_67_0.vars.dlg) then
		return 
	end
	
	local var_67_0 = arg_67_0.vars.dlg:findChildByName("n_sorting_f")
	
	arg_67_0.vars.unit_dock = HeroBelt:create()
	
	local var_67_1 = arg_67_0.vars.dlg:getChildByName("n_herolist")
	
	var_67_1:addChild(arg_67_0.vars.unit_dock:getWindow())
	var_67_1:setPositionX(VIEW_BASE_LEFT)
	HeroBelt:changeSorterParent(var_67_0, true)
	arg_67_0.vars.unit_dock:setEventHandler(arg_67_0.onHeroListEventForFormationEditor, arg_67_0)
	
	arg_67_0.vars.lota_units = LotaUtil:getLotaUnits()
	
	arg_67_0:updateHeroBelt()
end

function LotaBattleReady.updateHeroBelt(arg_68_0)
	local var_68_0 = arg_68_0.vars.dlg:findChildByName("n_sorting_f")
	local var_68_1 = arg_68_0.vars.lota_units
	
	HeroBelt:resetData(var_68_1, "LotaReady", nil, nil)
	arg_68_0.vars.unit_dock:getWindow():setPosition(0, 100)
	
	local var_68_2 = table.empty(var_68_1)
	
	HeroBelt:showAddInvenButton(false)
	HeroBelt:setVisible(not var_68_2)
	var_68_0:setVisible(not var_68_2)
	if_set_visible(arg_68_0.vars.dlg, "btn_registration", var_68_2)
	if_set(arg_68_0.vars.dlg, "t_hero_count", T("ui_clanheritage_hero_regi", {
		number = #var_68_1
	}))
end

function LotaBattleReady.onButtonClose(arg_69_0)
	if get_cocos_refid(arg_69_0.vars.dlg) then
		arg_69_0.vars.dlg:removeFromParent()
		BackButtonManager:pop("battle_ready")
		TopBarNew:pop()
		LotaSystem:setBlockCoolTime()
	end
end
