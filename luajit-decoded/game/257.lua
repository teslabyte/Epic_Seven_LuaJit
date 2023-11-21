Scene.coop = SceneHandler:create("coop", 1280, 720)

function MsgHandler.coop_enter(arg_1_0)
	if not CoopUtil:isValidRtn(arg_1_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	local var_1_0 = arg_1_0.cant_enter_reason
	local var_1_1 = CoopMission:getCurrentRoom()
	
	if var_1_0 then
		if not var_1_1 then
			return 
		end
		
		if var_1_1:getExitReason() ~= nil then
			return 
		end
		
		if string.starts(var_1_0, "boss_dead") then
			Dialog:msgBox(T("expedition_enterfail_desc_bosskill"), var_1_1:getDefaultDialogOpts())
			var_1_1:setExitReason("boss_dead")
		elseif var_1_0 == "expire_tm" then
			Dialog:msgBox(T("expedition_enterfail_desc_timeover"), var_1_1:getDefaultDialogOpts())
			var_1_1:setExitReason("expire_tm")
		else
			Dialog:msgBox(T("expedition_enterfail_desc_partymax"), var_1_1:getDefaultDialogOpts())
			var_1_1:setExitReason("party_max")
		end
		
		return 
	end
	
	if var_1_1 and var_1_1:getBossInfo() then
		local var_1_2 = var_1_1:getBossInfo()
		local var_1_3 = Account:getCoopMissionData()
		local var_1_4 = var_1_3.my_lists[tostring(var_1_2.boss_id)] or var_1_3.invite_list[tostring(var_1_2.boss_id)]
		
		if not var_1_4 and var_1_3.open_lists then
			for iter_1_0, iter_1_1 in pairs(var_1_3.open_lists) do
				for iter_1_2, iter_1_3 in pairs(iter_1_1) do
					if iter_1_2 == tostring(var_1_2.boss_id) then
						var_1_4 = iter_1_3
						
						break
					end
				end
			end
		end
		
		var_1_4.entered = true
		
		Account:setCoopMissionData(var_1_3)
	end
	
	Action:RemoveAll()
	BattleReady:hide()
	
	if arg_1_0.update_currencies then
		local var_1_5 = arg_1_0.enter_point
		
		if not var_1_5 and var_1_1 then
			var_1_5 = var_1_1:getReplaceEnterPoint()
		end
		
		Account:updateCurrencies(arg_1_0.update_currencies, {
			use_stamina = var_1_5
		})
	end
	
	startBattleScene(arg_1_0)
end

function MsgHandler.coop_ready_enter(arg_2_0)
	if not CoopUtil:isValidRtn(arg_2_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	if arg_2_0.state and arg_2_0.state == "not_have_room" then
		Dialog:msgBox(T("coop_ready_enter.not_have_boss_room"))
	else
		if arg_2_0.content_switch then
			ContentDisable:resetContentSwitchMain(arg_2_0.content_switch)
			
			AccountData.content_switch = nil
		end
		
		CoopMission:onMsgCoopReadyEnter(arg_2_0)
	end
end

function MsgHandler.coop_result(arg_3_0)
	if not CoopUtil:isValidRtn(arg_3_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	ConditionContentsManager:dispatch("expedition.result", {
		difficulty = arg_3_0.difficulty
	})
	CoopMission:onMsgCoopResult(arg_3_0)
end

function MsgHandler.coop_invited_list(arg_4_0)
	if not CoopUtil:isValidRtn(arg_4_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	CoopMission:onInvitedList(arg_4_0)
	
	if not CoopMission:checkJustUpdateInvitedList() then
		CoopMission:refreshMissionList("share")
	end
end

function MsgHandler.coop_lobby(arg_5_0)
	if not CoopUtil:isValidRtn(arg_5_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	arg_5_0.latest_invite_tm = Account:getCoopMissionData().latest_invite_tm or 0
	
	Account:setCoopMissionData(arg_5_0)
	
	if arg_5_0.content_switch then
		ContentDisable:resetContentSwitchMain(arg_5_0.content_switch)
		
		AccountData.content_switch = nil
	end
	
	if table.count(arg_5_0.difficulty_infos or {}) > 0 then
		for iter_5_0, iter_5_1 in pairs(arg_5_0.difficulty_infos or {}) do
			ConditionContentsManager:dispatch("expedition.result", {
				difficulty = iter_5_0,
				count = iter_5_1
			})
		end
	end
	
	if SceneManager:getCurrentSceneName() ~= "coop" then
		SceneManager:nextScene("coop", {
			coop_info = arg_5_0,
			prev_scene = SceneManager:getCurrentSceneName()
		})
	elseif CoopMission.vars and get_cocos_refid(CoopMission.vars.wnd) then
		CoopMission:updateData(arg_5_0)
	else
		SceneManager:nextScene("coop", {
			coop_info = arg_5_0
		})
		SceneManager:resetSceneFlow()
	end
end

function MsgHandler.coop_invite_reject(arg_6_0)
	if not CoopUtil:isValidRtn(arg_6_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	local var_6_0 = Account:getCoopMissionData()
	
	var_6_0.invite_list[tostring(arg_6_0.rejected_invite.boss_id)] = nil
	
	Account:setCoopMissionData(var_6_0)
	CoopMission:updateData(Account:getCoopMissionData())
	
	if CoopMission.vars and (CoopMission.vars.mission_list or CoopMission.vars.missionList.vars.dataSource) and CoopMission:getMode() == "select" and CoopMission.vars.tab == "share" then
		CoopMission.vars.mission_list = var_6_0.invite_list
		
		CoopMission.vars.missionList:setDataSource(CoopMission.vars.mission_list)
		CoopMission:refreshMissionList("share")
		
		if table.count(CoopMission.vars.mission_list) == 0 then
			CoopMission:toggleDelBtn()
		end
	end
end

function MsgHandler.coop_my_list(arg_7_0)
	if not CoopUtil:isValidRtn(arg_7_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	local var_7_0 = Account:getCoopMissionData()
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.my_lists) do
		if iter_7_1.season_no then
			var_7_0.my_lists[iter_7_0] = iter_7_1
		end
	end
	
	local var_7_1 = Account:getCoopMissionSchedule().season_number
	
	for iter_7_2, iter_7_3 in pairs(var_7_0.my_lists) do
		if CoopUtil:getBossInfo(iter_7_3).season_no ~= var_7_1 then
			var_7_0.my_lists[iter_7_2] = nil
		end
	end
	
	Account:setCoopMissionData(var_7_0)
	CoopMission:updateData(var_7_0)
	
	if CoopMission.vars.tab == "share" and (CoopMission.vars.exit_reason == "time_over" or CoopMission.vars.exit_reason == "boss_dead") then
		CoopMission:selectTab("hand")
		
		CoopMission.vars.exit_reason = nil
	elseif CoopMission:popSceneStateTab() and CoopMission:popSceneStateTab() == "hand" or CoopMission.vars.tab == "hand" then
		CoopMission:refreshMissionList("hand")
	else
		local var_7_2 = CoopMission:popSceneStateTab() or "share"
		
		CoopMission:setMode("select", {
			tab = var_7_2,
			data = CoopMission.vars.boss_infos[CoopMission.vars.currentBossBtn]
		})
	end
end

function MsgHandler.coop_open_boss_list(arg_8_0)
	if not CoopUtil:isValidRtn(arg_8_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	arg_8_0.invites = arg_8_0.invites or {}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.invites) do
		iter_8_1.is_open = true
	end
	
	arg_8_0.invites = CoopUtil:getValidList(arg_8_0.invites, {
		is_open_list = true
	})
	
	local var_8_0 = CoopMission:getOpenSubTab()
	
	if not var_8_0 then
		Log.e("Err: no open list difficulty info!!!!!! report now")
		
		return 
	end
	
	for iter_8_2, iter_8_3 in pairs(arg_8_0.invites) do
		if iter_8_3.difficulty then
			var_8_0 = iter_8_3.difficulty
		end
	end
	
	Account:setOpenLists(arg_8_0.invites, var_8_0)
	CoopMission:selectOpenSubTab(CoopMission:getOpenSubTab())
end

function MsgHandler.coop_pass_unlock(arg_9_0)
	if arg_9_0.dec_result then
		Account:addReward(arg_9_0.dec_result)
	end
	
	if arg_9_0.user_season_info then
		local var_9_0 = Account:getCoopMissionData()
		
		var_9_0.user_season_infos[to_n(arg_9_0.user_season_info.season_no)] = arg_9_0.user_season_info
		
		Account:setCoopMissionData(var_9_0)
	end
	
	Dialog:msgBox(T("expedition_pass_success_desc"), {
		title = T("expedition_pass_success_title")
	})
	CoopMission:resetSupplyListView()
	CoopMission:updateSupplyBtnState()
end

function MsgHandler.coop_set_boss_open(arg_10_0)
	if CoopMission.vars and CoopMission.vars.ready then
		CoopMission.vars.ready:res_open_room(arg_10_0)
	end
end

function MsgHandler.coop_my_with_invited_list(arg_11_0)
	if not CoopUtil:isValidRtn(arg_11_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	local var_11_0 = Account:getCoopMissionData()
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.my_lists) do
		if iter_11_1.season_no then
			var_11_0.my_lists[iter_11_0] = iter_11_1
		end
	end
	
	local var_11_1 = Account:getCoopMissionSchedule().season_number
	
	for iter_11_2, iter_11_3 in pairs(var_11_0.my_lists) do
		if CoopUtil:getBossInfo(iter_11_3).season_no ~= var_11_1 then
			var_11_0.my_lists[iter_11_2] = nil
		end
	end
	
	Account:setCoopMissionData(var_11_0)
	CoopMission:updateData(var_11_0)
	
	if CoopMission.vars.tab == "share" and (CoopMission.vars.exit_reason == "time_over" or CoopMission.vars.exit_reason == "boss_dead") then
		CoopMission:selectTab("hand")
		
		CoopMission.vars.exit_reason = nil
	else
		local var_11_2 = CoopMission:popSceneStateTab() or "share"
		
		CoopMission:setMode("select", {
			tab = var_11_2,
			data = CoopMission.vars.boss_infos[CoopMission.vars.currentBossBtn]
		})
	end
	
	CoopMission:onInvitedList(arg_11_0)
	
	if not CoopMission:checkJustUpdateInvitedList() then
		CoopMission:refreshMissionList("share")
	end
end

function MsgHandler.coop_season(arg_12_0)
	if not CoopUtil:isValidRtn(arg_12_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	CoopMission.vars.already_have_pre_season = true
	
	if table.count(arg_12_0.season_data) == 0 then
		arg_12_0.season_data = {}
	end
	
	CoopMission.vars.custom_season_data = arg_12_0
	
	local var_12_0 = "current"
	
	if arg_12_0.season == Account:getCoopMissionData().previous_season_number then
		var_12_0 = "previous"
	end
	
	CoopMission.vars.supply.mode = var_12_0
	
	CoopMission:resetSupplyListView()
	CoopMission:updateSupplyBtnState()
end

function MsgHandler.coop_reward(arg_13_0)
	if not CoopUtil:isValidRtn(arg_13_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	if_set_opacity(CoopMission.vars.wnd._supply_wnd, "btn_recive_all", 76.5)
	if_set_opacity(CoopMission.vars.wnd._supply_wnd, "btn_recive_all_pre", 76.5)
	if_set_visible(CoopMission.vars.wnd:getChildByName("btn_pass"), "icon_noti", false)
	
	if CoopMission.vars.supply.mode == "current" then
		local var_13_0 = Account:getCoopMissionData()
		
		var_13_0.season_data = arg_13_0.season_data
		
		Account:setCoopMissionData(var_13_0)
	else
		CoopMission.vars.custom_season_data.season_data = arg_13_0.season_data
	end
	
	if CoopMission.vars.supply then
		if not arg_13_0 or not arg_13_0.rewards or table.count(arg_13_0.rewards) == 0 then
			balloon_message(T("expedition_reward_get_faile"))
		elseif arg_13_0.rewards then
			local var_13_1 = Account:addReward(arg_13_0.rewards)
			local var_13_2 = {
				rewards = {}
			}
			
			var_13_2.rewards.new_items = {}
			var_13_2.rewards.new_items = var_13_1.rewards
			
			UIUtil:playNPCSoundAndTextRandomly("expedition.reward", CoopMission.vars.wnd, "txt_balloon", 100, nil, CoopMission.vars.portrait)
			
			if CoopMission:isPremiumSeason() then
				TutorialGuide:procGuide("expedition_reward_new")
			else
				TutorialGuide:procGuide("expedition_reward")
			end
			
			Dialog:msgScrollRewards(T("expedition_reward_get_desc"), {
				open_effect = true,
				title = T("expedition_reward_get_title"),
				rewards = var_13_2.rewards
			})
		end
		
		CoopMission:resetSupplyListView()
	end
end

function MsgHandler.coop_ticket_delete(arg_14_0)
	if not CoopUtil:isValidRtn(arg_14_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	local var_14_0
	
	if arg_14_0.boss_slot then
		var_14_0 = Account:getCoopMissionData()
		CoopMission.drop_boss_slot = 0
		
		for iter_14_0, iter_14_1 in pairs(var_14_0.ticket_list) do
			if iter_14_1.boss_slot == arg_14_0.boss_slot then
				table.remove(var_14_0.ticket_list, iter_14_0)
				Account:setCoopMissionData(var_14_0)
				CoopMission:initHandMissionListView()
				balloon_message(T("expedition_boss_del_complete"))
				
				return 
			end
		end
	end
end

function MsgHandler.coop_ticket_add(arg_15_0)
	if not CoopUtil:isValidRtn(arg_15_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	local var_15_0
	
	if arg_15_0.boss_slot then
		var_15_0 = Account:getCoopMissionData()
		
		ConditionContentsManager:dispatch("expedition.detect")
		
		for iter_15_0, iter_15_1 in pairs(var_15_0.ticket_list) do
			if iter_15_1.boss_slot == arg_15_0.boss_slot then
				table.remove(var_15_0.ticket_list, iter_15_0)
				
				var_15_0.my_lists[tostring(arg_15_0.user_info.boss_id)] = arg_15_0.my_lists[tostring(arg_15_0.user_info.boss_id)]
				
				Account:setCoopMissionData(var_15_0)
				
				local var_15_1 = Account:getCoopMissionData()
				local var_15_2 = var_15_1.my_lists[tostring(arg_15_0.user_info.boss_id)] or var_15_1.invite_list[tostring(arg_15_0.user_info.boss_id)]
				
				CoopMission:closeHandPopup(true)
				CoopMission:setMode("ready", var_15_2)
				
				return 
			end
		end
	end
end

function MsgHandler.cheat_user_add_coop(arg_16_0)
	print("===================cheat_user_add_coop==================")
	table.print(arg_16_0)
end

function MsgHandler.cheat_coop_issue_ticket(arg_17_0)
	table.print(arg_17_0)
end

function MsgHandler.coop_battle_get(arg_18_0)
	if not CoopUtil:isValidRtn(arg_18_0) then
		CoopUtil:ExitLobby()
		
		return 
	end
	
	table.print(arg_18_0)
end

function Scene.coop.onLoad(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1 or {}
	
	SoundEngine:playBGM("event:/bgm/bgm_expedition_lobby")
	
	arg_19_0.layer = cc.Layer:create()
	arg_19_0.args = var_19_0
end

function Scene.coop.onUnload(arg_20_0)
	local var_20_0 = CoopMission:getCurrentRoom()
	
	if var_20_0 then
		var_20_0:destroy()
	end
	
	CoopMission:destroy()
end

function Scene.coop.onEnter(arg_21_0)
	local var_21_0 = arg_21_0.args or {}
	
	CoopMission:onEnter(var_21_0, var_21_0.coop_info)
end

function Scene.coop.onLeave(arg_22_0)
	if SoundEngine:isPlayingBGM("event:/bgm/bgm_expedition_lobby") then
		SoundEngine:playBGM("event:/bgm/default")
	end
	
	local var_22_0 = CoopMission:getCurrentRoom()
	
	if var_22_0 then
		var_22_0:destroy()
	end
end

function Scene.coop.onAfterUpdate(arg_23_0)
	if (not CoopMission:isUnlocked() or CoopMission:isMaintenance()) and not get_cocos_refid(CoopMission.maintenance) then
		CoopMission.maintenance = Dialog:msgBox(T("expedition_rest_pop_desc"), {
			title = T("expedition_rest_pop_title"),
			handler = function()
				CoopMission.maintenance = nil
				
				if SceneManager:getCurrentSceneName() == "coop" then
					SceneManager:nextScene("lobby")
				end
			end
		})
		
		return 
	end
	
	CoopMission:onAfterUpdate()
	BattleReady:update()
end

function Scene.coop.getSceneState(arg_25_0)
	local var_25_0 = CoopMission:getSceneState()
	
	CoopMission.scene_state = table.clone(var_25_0)
	
	return CoopMission:getSceneState()
end

function Scene.coop.getTouchEventTime(arg_26_0)
	return arg_26_0.touchEventTime
end

function Scene.coop.onEnterFinished(arg_27_0)
end

function Scene.coop.onReload(arg_28_0)
end

function Scene.coop.onAfterDraw(arg_29_0)
end

function Scene.coop.onTouchDown(arg_30_0, arg_30_1, arg_30_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchDown(arg_30_1, arg_30_2)
	end
end

function Scene.coop.onTouchUp(arg_31_0, arg_31_1, arg_31_2)
	if UnitMain:isVisible() then
		if UnitMain:onTouchUp(arg_31_1, arg_31_2) then
			arg_31_2:stopPropagation()
		else
			UnitMain:onPushBackground()
		end
	end
end

function Scene.coop.onTouchMove(arg_32_0, arg_32_1, arg_32_2)
	if UnitMain:isVisible() then
		return UnitMain:onTouchMove(arg_32_1, arg_32_2)
	end
end
