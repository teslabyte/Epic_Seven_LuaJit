function HANDLER.expedition_get_difficulty(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_confirm" then
		CoopMission:difficultyDlg_onDifficultyConfirm(arg_1_1)
	elseif string.starts(arg_1_1, "btn_sel") and not string.starts(arg_1_1, "btn_selected") then
		CoopMission:difficultyDlg_onDifficultySelect(arg_1_1)
		TutorialGuide:procGuide("expedition_wanted")
	elseif string.starts(arg_1_1, "btn_selected") then
		CoopMission:difficultyDlg_onPushSelected(arg_1_1)
	else
		CoopMission:difficultyDlg_onLeaveDifficultyDlg()
	end
end

function HANDLER.expedition_home(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_get" then
		if CoopMission:getMode() == "select" then
			CoopMission:onPushBackButton(true)
		end
		
		CoopMission:openHandPopup()
		TutorialGuide:procGuide("expedition_wanted")
	elseif string.starts(arg_2_1, "btn_del_") then
		CoopMission:toggleDelBtn()
		
		return 
	elseif arg_2_1 == "btn_del" then
		local var_2_0 = arg_2_0:getParent()._datasource
		
		Dialog:msgBox(T("expedition_shared_del_desc"), {
			yesno = true,
			title = T("expedition_current_shared2"),
			handler = function(arg_3_0, arg_3_1)
				if arg_3_1 == "btn_yes" then
					query("coop_invite_reject", {
						boss_code = var_2_0.boss_code,
						boss_id = var_2_0.boss_id
					})
				end
			end
		})
		
		return 
	elseif arg_2_1 == "btn_result" then
		local var_2_1 = arg_2_0:getParent()._datasource
		
		CoopMission:setMode("result", var_2_1)
	elseif arg_2_1 == "btn_enter" then
		local var_2_2 = arg_2_0:getParent()._datasource
		
		if CoopMission:getCurrentTab() ~= "share" or CoopMission:canEnterInvitedRoom(var_2_2) then
			if CoopMission:getCurrentTab() == "share" then
				CoopMission.vars.ready_args = var_2_2
				
				query("coop_ready_enter", {
					boss_id = var_2_2.boss_id
				})
			elseif CoopMission:getCurrentTab() == "open" then
				if CoopMission:canEnterInvitedRoom(var_2_2) then
					CoopMission:readyOpenRoom(var_2_2)
				else
					balloon_message_with_sound("expedition_already_full_my_list")
					
					return 
				end
			else
				CoopMission:setMode("ready", var_2_2)
			end
		else
			balloon_message_with_sound("expedition_already_full_my_list")
		end
	elseif string.starts(arg_2_1, "tab") then
		CoopMission:selectTab(string.sub(arg_2_1, 5, -1))
	elseif string.starts(arg_2_1, "btn_lv") then
		CoopMission:selectOpenSubTab(string.sub(arg_2_1, -1, -1))
	elseif arg_2_1 == "btn_ignore" and CoopMission:getMode() == "select" then
		CoopMission:onPushBackButton()
		
		return 
	elseif arg_2_1 == "btn_refresh" then
		CoopMission:refreshBossList()
	elseif arg_2_1 == "btn_pass" then
		CoopMission:setMode("supply")
		CoopMission:updateSupplyPassRedDot("home")
	elseif arg_2_1 == "btn_formation" then
		CoopMission:openFormation()
	elseif arg_2_1 == "btn_discussion" then
		Stove:openExpeditionGuidePage()
		
		return 
	end
end

function HANDLER.expedition_home_sel_item(arg_4_0, arg_4_1)
end

function HANDLER.expedition_map_boss(arg_5_0, arg_5_1)
	if string.starts(arg_5_1, "btn_boss_") then
		local var_5_0 = arg_5_1:sub(10, #arg_5_1)
		
		CoopMission.vars.currentBossBtn = var_5_0
		
		query("coop_my_with_invited_list", {
			boss_code = CoopMission.vars.boss_infos[var_5_0].data.id
		})
	end
end

function HANDLER.expedition_ready(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_go" then
		local var_6_0 = CoopMission:getCurrentRoom()
		
		if not var_6_0 then
			return 
		end
		
		local var_6_1 = var_6_0:getBossInfo()
		local var_6_2 = CoopUtil:getLevelData(var_6_1)
		
		if not var_6_2.level_enter then
			balloon_message_with_sound("invalid_expedition_season_boss")
			
			return 
		end
		
		var_6_0:openBattleReady(var_6_2)
	elseif arg_6_1 == "btn_boss_guide" then
		local var_6_3 = CoopMission:getCurrentRoom()
		
		if not var_6_3 then
			return 
		end
		
		local var_6_4 = var_6_3:getBossInfo()
		local var_6_5 = CoopUtil:getLevelData(var_6_4)
		local var_6_6 = CoopMission:getRootLayer()
		
		BossGuide:show({
			enter_id = var_6_5.level_enter,
			parent = var_6_6
		})
	elseif arg_6_1 == "btn_formation" then
		CoopMission:onEnterFormation()
	elseif arg_6_1 == "btn_reward_info" then
		local var_6_7 = CoopMission:getCurrentRoom()
		
		if not var_6_7 then
			return 
		end
		
		local var_6_8 = var_6_7:getBossInfo()
		local var_6_9 = CoopUtil:getLevelData(var_6_8)
		
		CoopUtil:openRewardPreviewItem(var_6_8, var_6_9)
	elseif arg_6_1 == "btn_all" then
		CoopMission:requestInviteAll()
	elseif arg_6_1 == "btn_limit" then
		CoopMission:onEnterLimit()
	elseif arg_6_1 == "btn_sharing" then
		CoopMission:onSharing()
	elseif arg_6_1 == "btn_public" then
		CoopMission:req_open_room()
	end
end

function HANDLER.expedition_ready_reward_info(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_close" then
		CoopUtil:removeRewardInfoDlg()
	end
end

function HANDLER.expedition_get_list(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:getParent():getParent().data
	
	if arg_8_1 == "btn_close" then
		Dialog:close("expedition_get_list")
	elseif arg_8_1 == "btn_del" then
		Dialog:msgBox(T("expedition_boss_del_desc"), {
			yesno = true,
			handler = function()
				query("coop_ticket_delete", {
					boss_slot = var_8_0.boss_slot
				})
			end,
			title = T("expedition_boss_del_title")
		})
	elseif arg_8_1 == "btn_start" then
		CoopMission:warningOpenRoom(CoopMission.vars.wnd._hand, {
			character_id = var_8_0.boss_code,
			boss_slot = var_8_0.boss_slot
		})
		TutorialGuide:procGuide("expedition_wanted")
	end
end

HANDLER.expedition_get_list_item = HANDLER.expedition_get_list

function HANDLER.expedition_pass_base(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_pre" or arg_10_1 == "btn_cur" then
		if Account:getCoopMissionData().previous_season_number == 0 then
			balloon_message(T("expedition_reward_no_prev"))
			
			return 
		end
		
		CoopMission.vars.supply.mode = CoopMission:getSupplyMode() == "previous" and "current" or "previous"
		
		if CoopMission:getSupplyMode() == "previous" then
			query("coop_season", {
				season = Account:getCoopMissionData().previous_season_number
			})
			
			return 
		end
		
		CoopMission:resetSupplyListView()
		CoopMission:updateSupplyBtnState()
	elseif arg_10_1 == "btn_recive_all" or arg_10_1 == "btn_recive_all_pre" then
		local var_10_0 = CoopMission:getSupplyMode() == "current" and Account:getCoopMissionSchedule().season_number or Account:getCoopMissionData().previous_season_number
		
		if CoopMission:isRewardReceivable(CoopMission:getSupplyMode()) then
			query("coop_reward", {
				season_number = var_10_0
			})
		else
			balloon_message(T("expedition_reward_get_faile"))
		end
	elseif arg_10_1 == "btn_done" then
		balloon_message(T("errmsg_expedition_pass_limit"))
		
		return 
	elseif arg_10_1 == "btn_premium" then
		if CoopMission:getSupplyMode() == "previous" then
			balloon_message(T("errmsg_expedition_pass_past"))
			
			return 
		end
		
		local function var_10_1(arg_11_0, arg_11_1)
			CoopMission:updateSupplyPassRedDot("supply")
			if_set_visible(arg_10_0, "icon_noti", false)
			
			local var_11_0 = ShopCommon:ShowConfirmDialog(arg_11_0, function(arg_12_0, arg_12_1)
				if arg_12_1 == "btn_buy" then
					if not UIUtil:checkCurrencyDialog("crystal", to_n(Account:getCoopMissionSchedule().premium_price)) then
						return 
					end
					
					query("coop_pass_unlock", {
						season_id = arg_11_1
					})
				end
			end)
			
			UIUtil:getRewardIcon(arg_11_0.value, arg_11_0.type, {
				no_resize_name = true,
				show_name = true,
				parent = var_11_0:getChildByName("n_item_pos"),
				txt_name = var_11_0:getChildByName("txt_shop_name"),
				txt_type = var_11_0:getChildByName("txt_shop_type")
			})
		end
		
		local var_10_2 = Account:getCoopMissionSchedule().id
		local var_10_3 = DB("expedition_main", var_10_2, {
			"premium_id"
		})
		local var_10_4 = {
			value = 1,
			token = "to_crystal",
			type = var_10_3,
			price = to_n(Account:getCoopMissionSchedule().premium_price)
		}
		local var_10_5 = timeToStringDef({
			remain_time_with_day = to_n(Account:getCoopMissionSchedule().end_time) - os.time()
		})
		
		if to_n(var_10_5.day) < 7 then
			Dialog:msgBox(T("expedition_end_popup_desc", var_10_5), {
				title = T("expedition_end_popup_title"),
				handler = function(arg_13_0, arg_13_1)
					var_10_1(var_10_4, var_10_2)
				end
			})
		else
			var_10_1(var_10_4, var_10_2)
		end
	end
end

function HANDLER.expedition_previous_reward_p(arg_14_0, arg_14_1)
	if arg_14_1 == "btn_ok" then
		CoopMission:_tutorialPopup(CoopMission.vars.tuto_args)
		BackButtonManager:pop("coop.all_reward")
		UIAction:Add(SEQ(FADE_OUT(140), REMOVE()), CoopMission.vars.all_reward_wnd, "block")
	end
end

CoopMission = {}

function CoopMission.isMaintenance(arg_15_0)
	if not PRODUCTION_MODE and CoopMission.FORCE_MAINTENANCE == true then
		return true
	end
	
	local var_15_0 = os.time()
	
	if Account:isMainStance() then
		return true
	end
	
	if var_15_0 <= Account:getCoopMissionSchedule().start_time or var_15_0 >= Account:getCoopMissionSchedule().end_time then
		return true
	end
	
	return false
end

function CoopMission.isUnlocked(arg_16_0)
	if not PRODUCTION_MODE and CoopMission.FORCE_ENABLE then
		return true
	end
	
	return (Account:isSysAchieveCleared("system_124"))
end

local function var_0_0(arg_17_0, arg_17_1, arg_17_2)
	if to_n(arg_17_0.season_no) ~= arg_17_2 then
		return 
	end
	
	if arg_17_1 ~= "share" then
		return arg_17_0
	end
	
	if arg_17_0.last_hp >= 0 and arg_17_0.clear_tm == nil and arg_17_0.expire_tm >= os.time() then
		return arg_17_0
	end
end

function CoopMission.getSceneState(arg_18_0)
	if not arg_18_0.vars then
		return {}
	end
	
	return {
		tab = arg_18_0.vars.tab
	}
end

function CoopMission.popSceneStateTab(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.scene_state_tab
	
	arg_19_0.vars.scene_state_tab = nil
	
	return var_19_0
end

function CoopMission.isRequestInviteAll(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	return arg_20_0.vars.req_invite_all
end

function CoopMission.isUsableRequestAll(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if arg_21_0.vars.req_invite_all then
		return false
	end
	
	local var_21_0 = arg_21_0:getCurrentRoom()
	
	if not var_21_0 then
		return 
	end
	
	local var_21_1 = var_21_0:getBossInfo().boss_id
	
	return not CoopUtil:isExistsInviteAllList(var_21_1)
end

function CoopMission.requestInviteAll(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if not arg_22_0:isUsableRequestAll() then
		balloon_message_with_sound("expedition_all_call_failed")
		
		return 
	end
	
	local var_22_0 = arg_22_0.vars.prv_btn_all_click_tm or 0
	local var_22_1 = uitick()
	
	if var_22_1 - var_22_0 < 10000 then
		balloon_message_with_sound("error_try_again")
	end
	
	arg_22_0.vars.prv_btn_all_click_tm = var_22_1
	
	local var_22_2 = arg_22_0:getCurrentRoom()
	
	if not var_22_2 then
		return 
	end
	
	local var_22_3 = var_22_2:getBossInfo().boss_id
	
	arg_22_0.vars.req_invite_all = true
	
	query("coop_invite", {
		invite_all = true,
		clan_id = AccountData.clan_id,
		boss_id = var_22_3
	})
end

function CoopMission.updateReadyBtnAll(arg_23_0)
	local var_23_0 = arg_23_0:getCurrentRoom()
	
	if not var_23_0 then
		return 
	end
	
	var_23_0:updateBtnAll()
end

function CoopMission.updateCachingListByInviteAll(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0:getCurrentRoom()
	
	if not var_24_0 then
		return 
	end
	
	local var_24_1 = var_24_0:getCacheCoopSharedList()
	
	if not var_24_1 then
		return 
	end
	
	local var_24_2 = {
		"recent",
		"friend",
		"clan"
	}
	local var_24_3 = table.clone(var_24_1)
	
	for iter_24_0, iter_24_1 in pairs(var_24_1) do
		var_24_3[iter_24_0] = var_24_3[iter_24_0].list
	end
	
	for iter_24_2, iter_24_3 in pairs(arg_24_1.invited_user_list or {}) do
		local var_24_4 = tostring(iter_24_3)
		
		for iter_24_4, iter_24_5 in pairs(var_24_2) do
			if var_24_3[iter_24_5] and var_24_3[iter_24_5][var_24_4] then
				var_24_3[iter_24_5][var_24_4].already_invited = true
				var_24_3[iter_24_5][var_24_4].recent_invite = os.time()
			end
		end
	end
	
	for iter_24_6, iter_24_7 in pairs(var_24_2) do
		if var_24_3[iter_24_7] then
			arg_24_0:onUpdateCoopSharedList(var_24_3[iter_24_7], iter_24_7)
		end
	end
end

function CoopMission.responseInviteAll(arg_25_0, arg_25_1)
	if not arg_25_0.vars then
		return 
	end
	
	local var_25_0 = arg_25_0:getCurrentRoom()
	
	if not var_25_0 then
		return 
	end
	
	local var_25_1 = var_25_0:getBossInfo().boss_id
	
	arg_25_0.vars.req_invite_all = false
	
	CoopUtil:addSaveInviteAllList(var_25_1)
	
	if arg_25_1.invite_list_empty then
		balloon_message_with_sound("expedition_all_call_failed")
	else
		CoopUtil:openInviteResultDialog(arg_25_1, true)
	end
	
	var_25_0:updateBtnAll()
	arg_25_0:updateCachingListByInviteAll(arg_25_1)
end

function CoopMission.getAvailableRoom(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {}
	local var_26_1 = to_n(Account:getCoopSeasonNumber())
	
	for iter_26_0, iter_26_1 in pairs(arg_26_2) do
		if var_0_0(iter_26_1, arg_26_1, var_26_1) then
			table.insert(var_26_0, iter_26_1)
		end
	end
	
	return var_26_0
end

function CoopMission.canEnterInvitedRoom(arg_27_0, arg_27_1)
	if not arg_27_0.vars.coop_info then
		return false
	end
	
	if (arg_27_0.vars.tab == "share" or arg_27_0.vars.tab == "open") and CoopUtil:getBossRoomCount(arg_27_1.boss_code, {
		type = "hand"
	}) >= 20 then
		return false
	end
	
	return true
end

function CoopMission.refreshBossList(arg_28_0, arg_28_1)
	if arg_28_0.vars.refresh_cool_time_cur >= arg_28_0.vars.refresh_cool_time_end then
		if arg_28_0:getCurrentTab() == "open" and arg_28_0.vars.open_sub_tab and not arg_28_1 then
			arg_28_0:refreshOpenList()
		elseif arg_28_0:getCurrentTab() == "share" then
			query("coop_invited_list", {
				boss_code = arg_28_0.vars.boss_infos[arg_28_0.vars.currentBossBtn].data.id
			})
		else
			query("coop_my_list", {
				boss_code = arg_28_0.vars.boss_infos[arg_28_0.vars.currentBossBtn].data.id
			})
		end
		
		arg_28_0.vars.refresh_cool_time_end = os.time() + 9
	else
		balloon_message(T("expedition_refresh_cant"))
	end
end

function CoopMission.warningOpenRoom(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = to_n(Account:getCoopSeasonNumber() or 1)
	local var_29_1 = var_29_0 ~= SAVE:getUserDefaultData("coop_last_warning_popup_season", 0) and not TutorialGuide:isPlayingTutorial("expedition_wanted")
	
	if var_29_1 and os.time() + CoopUtil:getConfigDBValue("expire_tm") < Account:getCoopMissionSchedule().end_time then
		var_29_1 = false
	end
	
	if var_29_1 then
		local var_29_2, var_29_3, var_29_4 = CoopUtil:getClearTime(Account:getCoopMissionSchedule().end_time, os.time())
		local var_29_5 = ""
		
		if var_29_3 == 0 and var_29_2 ~= 0 then
			var_29_5 = T("remain_min", {
				min = var_29_2
			})
		elseif var_29_3 ~= 0 then
			var_29_5 = T("remain_hour", {
				hour = var_29_3
			})
		elseif var_29_2 == 0 and var_29_3 == 0 then
			var_29_5 = T("remain_sec", {
				sec = var_29_4
			})
		end
		
		Dialog:msgBox(T("expedition_rest_last_desc", {
			time = var_29_5
		}), {
			yesno = true,
			title = T("expedition_rest_last_title"),
			handler = function(arg_30_0, arg_30_1)
				if arg_30_1 == "btn_yes" then
					arg_29_0:openDifficultyPopup(arg_29_1, arg_29_2)
					SAVE:setUserDefaultData("coop_last_warning_popup_season", var_29_0)
				end
			end
		})
	else
		arg_29_0:openDifficultyPopup(arg_29_1, arg_29_2)
	end
end

function CoopMission.openFormation(arg_31_0)
	UnitMain:beginCoopMode(arg_31_0.vars.root_layer, arg_31_0.vars.wnd, function()
	end)
end

function CoopMission.getCurrentBossLastLevelInfo(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = arg_33_0.vars.boss_infos[arg_33_0.vars.currentBossBtn]
	
	if not var_33_0 then
		return 
	end
	
	local var_33_1 = var_33_0.data.level_info
	local var_33_2
	local var_33_3 = 0
	
	for iter_33_0, iter_33_1 in pairs(var_33_1) do
		if var_33_3 < to_n(iter_33_0) then
			var_33_3 = to_n(iter_33_0)
			var_33_2 = iter_33_1
		end
	end
	
	return var_33_2
end

function CoopMission.openDifficultyPopup(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_2 then
		return nil
	end
	
	if not arg_34_2.character_id then
		return nil
	end
	
	if get_cocos_refid(arg_34_0.vars.wnd:getChildByName("expedition_get_difficulty")) then
		return 
	end
	
	local var_34_0 = arg_34_0.vars.boss_infos[arg_34_2.character_id].data.character_id
	local var_34_1 = DB("character", var_34_0, {
		"name"
	})
	
	arg_34_0.vars.difficulty_popup_difficulty = 0
	
	local var_34_2 = load_dlg("expedition_get_difficulty", false, "wnd")
	
	if_set(var_34_2, "txt_title", T("expedition_boss_level_title"))
	if_set(var_34_2, "t_disc", T("expedition_boss_level_desc"))
	if_set(var_34_2, "t_name", T(var_34_1))
	var_34_2:getChildByName("btn_confirm"):setOpacity(76.5)
	
	for iter_34_0 = 1, 3 do
		if iter_34_0 > tonumber(Account:getCoopMissionData().max_difficulty) + 1 then
			var_34_2:getChildByName("btn_sel" .. iter_34_0):setOpacity(76.5)
		end
	end
	
	if_set(var_34_2, "t_level_info", T("expedition_level_select_desc2"))
	if_set_visible(var_34_2, "t_level_info", tonumber(Account:getCoopMissionData().max_difficulty) <= 1)
	
	if tonumber(Account:getCoopMissionData().max_difficulty) <= 1 then
		local var_34_3 = var_34_2:getChildByName("n_difficulty_move")
		
		UIAction:Add(MOVE_TO(100, var_34_2:getChildByName("n_difficulty"):getPositionX(), var_34_3:getPositionY()), var_34_2:getChildByName("n_difficulty"), "block")
	end
	
	if_set(var_34_2:getChildByName("n_difficulty"), "t_disc", T("expedition_level_select_desc"))
	if_set_visible(var_34_2:getChildByName("n_difficulty"), "t_disc", true)
	BackButtonManager:push({
		check_id = "expedition_get_difficulty",
		back_func = function()
			CoopMission:difficultyDlg_onLeaveDifficultyDlg()
		end
	})
	
	local var_34_4 = Account:getCoopMissionSchedule().boss[arg_34_2.character_id].level_info
	local var_34_5 = CoopUtil:getBossLevelFromLevelData(var_34_4[tostring(1)])
	
	if not var_34_5 then
		return 
	end
	
	UIUtil:getRewardIcon(nil, var_34_0, {
		hide_lv = true,
		hide_star = true,
		tier = "boss",
		show_color_right = true,
		no_grade = true,
		parent = var_34_2:findChildByName("mob_icon"),
		lv = var_34_5
	})
	
	arg_34_0.vars.difficulty_dlg = var_34_2
	arg_34_0.vars.difficulty_dlg.data = arg_34_2
	arg_34_1.expedition_get_difficulty = var_34_2
	
	arg_34_1:addChild(var_34_2)
end

function CoopMission.difficultyDlg_onLeaveDifficultyDlg(arg_36_0)
	local var_36_0 = arg_36_0.vars.difficulty_dlg
	
	if not var_36_0 then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(250)), REMOVE()), var_36_0, "block")
	BackButtonManager:pop("expedition_get_difficulty")
end

function CoopMission.difficultyDlg_onDifficultyConfirm(arg_37_0, arg_37_1)
	if not arg_37_0.vars.difficulty_dlg then
		return 
	end
	
	local var_37_0 = arg_37_0.vars.difficulty_dlg.data
	
	if arg_37_0.vars.difficulty_popup_difficulty == 0 then
		balloon_message(T("expedition_level_select_cant"))
		
		return 
	end
	
	if CoopUtil:getBossRoomCount(var_37_0.character_id, {
		type = "hand"
	}) >= 20 then
		balloon_message(T("expedition_already_full_my_list"))
		
		return 
	end
	
	query("coop_ticket_add", {
		boss_slot = var_37_0.boss_slot,
		difficulty = arg_37_0.vars.difficulty_popup_difficulty
	})
	arg_37_0:difficultyDlg_onLeaveDifficultyDlg()
end

function CoopMission.difficultyDlg_onDifficultySelect(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0.vars.difficulty_dlg
	
	if not var_38_0 then
		return 
	end
	
	local var_38_1 = arg_38_0.vars.difficulty_dlg.data
	local var_38_2 = arg_38_0.vars.boss_infos[var_38_1.character_id].data.character_id
	local var_38_3 = Account:getCoopMissionSchedule().boss[var_38_1.character_id].level_info
	local var_38_4 = tonumber(string.sub(arg_38_1, 8, -1))
	
	var_38_0:getChildByName("mob_icon"):removeAllChildren()
	
	local var_38_5 = CoopUtil:getBossLevelFromLevelData(var_38_3[tostring(var_38_4)])
	
	if not var_38_5 then
		return 
	end
	
	UIUtil:getRewardIcon(nil, var_38_2, {
		hide_lv = true,
		hide_star = true,
		tier = "boss",
		show_color_right = true,
		no_grade = true,
		parent = var_38_0:findChildByName("mob_icon"),
		lv = var_38_5
	})
	
	if var_38_4 <= tonumber(Account:getCoopMissionData().max_difficulty) + 1 then
		for iter_38_0 = 1, 3 do
			if_set_visible(var_38_0, "btn_selected" .. iter_38_0, var_38_4 == iter_38_0)
			
			if var_38_4 == iter_38_0 then
				arg_38_0.vars.difficulty_popup_difficulty = iter_38_0
				
				var_38_0:getChildByName("btn_confirm"):setOpacity(255)
			end
		end
		
		if_set(var_38_0, "t_selected", T("expedition_boss_level_desc2", {
			level = var_38_4
		}))
		if_set(var_38_0, "t_level_info", T("expedition_level_select_desc2"))
		if_set_visible(var_38_0:getChildByName("n_difficulty"), "t_selected", var_38_4 ~= nil)
		if_set_visible(var_38_0:getChildByName("n_difficulty"), "t_disc", var_38_4 == nil)
		if_set_visible(var_38_0, "t_level_info", tonumber(Account:getCoopMissionData().max_difficulty) <= 1)
	else
		if_set_visible(var_38_0:getChildByName("n_difficulty"), "t_disc", false)
		if_set_visible(var_38_0, "t_level_info", tonumber(Account:getCoopMissionData().max_difficulty) <= 1)
		if_set_visible(var_38_0, "t_selected", false)
		if_set(var_38_0:getChildByName("n_difficulty"), "t_disc", T("expedition_level_select_desc"))
		if_set_visible(var_38_0, "btn_selected" .. arg_38_0.vars.difficulty_popup_difficulty, false)
		
		arg_38_0.vars.difficulty_popup_difficulty = 0
		
		var_38_0:getChildByName("btn_confirm"):setOpacity(76.5)
		balloon_message(T("expedition_boss_level_cant"))
	end
end

function CoopMission.difficultyDlg_onPushSelected(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.vars.difficulty_dlg
	
	if not var_39_0 then
		return 
	end
	
	local var_39_1 = tonumber(string.sub(arg_39_1, 13, -1))
	
	if var_39_1 == arg_39_0.vars.difficulty_popup_difficulty then
		arg_39_0.vars.difficulty_popup_difficulty = 0
		
		var_39_0:getChildByName("btn_confirm"):setOpacity(76.5)
		if_set_visible(var_39_0, "btn_selected" .. var_39_1, false)
		if_set_visible(var_39_0:getChildByName("n_difficulty"), "t_disc", true)
		if_set(var_39_0, "t_level_info", T("expedition_level_select_desc2"))
		if_set_visible(var_39_0, "t_level_info", tonumber(Account:getCoopMissionData().max_difficulty) <= 1)
		if_set_visible(var_39_0, "t_selected", false)
		
		return 
	end
	
	if_set(var_39_0, "t_selected", T("expedition_boss_level_desc2", {
		level = var_39_1
	}))
	if_set_visible(var_39_0:getChildByName("n_difficulty"), "t_selected", var_39_1 ~= nil)
	if_set_visible(var_39_0:getChildByName("n_difficulty"), "t_disc", var_39_1 == nil)
	if_set_visible(var_39_0, "t_level_info", false)
end

function CoopMission.updateData(arg_40_0, arg_40_1)
	if not arg_40_0.vars then
		return 
	end
	
	if not arg_40_1 then
		local var_40_0 = Account:getCoopMissionData()
		
		var_40_0.invite_list = CoopUtil:getValidList(var_40_0.invite_list)
		var_40_0.my_lists = CoopUtil:getValidList(var_40_0.my_lists)
		
		Account:setCoopMissionData(var_40_0)
		
		arg_40_1 = Account:getCoopMissionData()
	end
	
	if arg_40_0.vars then
		arg_40_0.vars.coop_info = arg_40_1
	end
	
	local var_40_1 = {}
	
	for iter_40_0, iter_40_1 in pairs(Account:getCoopMissionData().my_lists) do
		local var_40_2 = iter_40_1.boss_info ~= nil and iter_40_1.boss_info.boss_code or iter_40_1.boss_code
		
		var_40_1[var_40_2] = var_40_1[var_40_2] or 0
		var_40_1[var_40_2] = var_40_1[var_40_2] + 1
	end
	
	local var_40_3 = {}
	
	for iter_40_2, iter_40_3 in pairs(Account:getCoopMissionSchedule().boss) do
		var_40_3[iter_40_2] = Account:getCoopMissionSchedule().boss[iter_40_2].sort
	end
	
	arg_40_0.vars.boss_infos = arg_40_0.vars.boss_infos or {}
	arg_40_0.vars.cheat_tbl = {}
	
	local var_40_4 = 1
	
	for iter_40_4, iter_40_5 in pairs(Account:getCoopMissionSchedule().boss) do
		local var_40_5 = DB("character", iter_40_5.character_id, {
			"ch_attribute"
		})
		
		arg_40_0.vars.cheat_tbl[iter_40_5.character_id] = iter_40_5.id
		
		if not arg_40_0.vars.boss_infos[iter_40_5.id] then
			arg_40_0.vars.boss_infos[iter_40_5.id] = arg_40_0:createHomeBossBtn(iter_40_5, {
				attribute = var_40_5,
				count = var_40_1[iter_40_4]
			})
			
			arg_40_0.vars.wnd:getChildByName("n_home"):getChildByName("n_boss" .. var_40_3[iter_40_5.id]):addChild(arg_40_0.vars.boss_infos[iter_40_5.id].node)
		end
		
		var_40_4 = var_40_4 + 1
	end
	
	arg_40_0:updateHomeBossBtn()
	
	if get_cocos_refid(arg_40_0.vars.wnd) then
		if_set(arg_40_0.vars.wnd, "time", CoopUtil:getRewardDateTime("home"))
	end
	
	if not get_cocos_refid(arg_40_0.vars.portrait) then
		local var_40_6 = UIUtil:getPortraitAni("npc1034", {
			pin_sprite_position_y = true
		})
		
		if get_cocos_refid(var_40_6) then
			var_40_6:setScale(0.87)
			
			local var_40_7 = arg_40_0.vars.wnd:getChildByName("n_portrait")
			
			var_40_7:removeAllChildren()
			var_40_7:addChild(var_40_6)
			
			arg_40_0.vars.portrait = var_40_6
			
			arg_40_0.vars.wnd:getChildByName("n_balloon"):setScale(0)
			UIUtil:playNPCSoundAndTextRandomly("expedition.enter", arg_40_0.vars.wnd, "txt_balloon", 800, nil, arg_40_0.vars.portrait)
			UIAction:Add(SEQ(DELAY(400), CALL(function()
				if_set_visible(arg_40_0.vars.wnd, "n_balloon", true)
			end), SCALE(140, 0, 1)), arg_40_0.vars.wnd:getChildByName("n_balloon"), "block")
		end
	end
	
	local var_40_8 = Account:getCoopMissionData()
	
	var_40_8.invite_list = CoopUtil:getValidList(var_40_8.invite_list)
	var_40_8.my_lists = CoopUtil:getValidList(var_40_8.my_lists)
	
	Account:setCoopMissionData(var_40_8)
end

function CoopMission.createHomeBossBtn(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = load_dlg("expedition_map_boss", true, "wnd")
	
	if not get_cocos_refid(var_42_0) then
		Log.e(debug.traceback())
	end
	
	if not arg_42_2.count or arg_42_2.count == 0 then
		if_set_visible(var_42_0, "count", false)
	end
	
	local var_42_1 = {
		data = arg_42_1,
		node = var_42_0
	}
	
	var_42_1.name = var_42_1.data.character_id
	var_42_1.attribute = arg_42_2.attribute
	var_42_1.count = arg_42_2.count
	
	if_set_sprite(var_42_0, "boss", "face/" .. var_42_1.data.image .. ".png")
	if_set_sprite(var_42_0, "icon", "img/cm_icon_pro" .. arg_42_2.attribute .. ".png")
	if_set(var_42_0, "t_count", tostring(arg_42_2.count))
	if_set(var_42_0, "t_name", T(Account:getCoopMissionSchedule().boss[arg_42_1.id].boss_name))
	var_42_0:getChildByName("btn_boss"):setName("btn_boss_" .. var_42_1.data.id)
	var_42_1.node:setPosition({
		0,
		0
	})
	
	return var_42_1
end

function CoopMission.updateHomeBossBtn(arg_43_0)
	for iter_43_0, iter_43_1 in pairs(arg_43_0.vars.boss_infos) do
		if_set_sprite(arg_43_0.vars.boss_infos[iter_43_0].node, "boss", "face/" .. arg_43_0.vars.boss_infos[iter_43_0].data.image .. ".png")
		if_set_sprite(arg_43_0.vars.boss_infos[iter_43_0].node, "icon", "img/cm_icon_pro" .. arg_43_0.vars.boss_infos[iter_43_0].attribute .. ".png")
		
		local var_43_0, var_43_1 = CoopUtil:isClearedRooms(iter_43_0)
		
		if_set_opacity(arg_43_0.vars.boss_infos[iter_43_0].node, "n_reward", var_43_0 == true and 255 or 127.5)
		if_set(arg_43_0.vars.boss_infos[iter_43_0].node, "t_reward", T("expedition_result_count", {
			count = var_43_1 == nil and "0" or tostring(var_43_1)
		}))
		
		local var_43_2 = CoopUtil:getBossRoomCount(iter_43_0, {
			type = "share"
		})
		
		if_set_opacity(arg_43_0.vars.boss_infos[iter_43_0].node, "n_recruit", var_43_2 ~= 0 and 255 or 127.5)
		if_set(arg_43_0.vars.boss_infos[iter_43_0].node, "t_recruit", var_43_2 == 0 and "0" or tostring(var_43_2))
		
		local var_43_3 = CoopUtil:getBossRoomCount(iter_43_0, {
			type = "hand"
		})
		
		if_set_opacity(arg_43_0.vars.boss_infos[iter_43_0].node, "n_proceed", var_43_3 - var_43_1 ~= 0 and 255 or 127.5)
		if_set(arg_43_0.vars.boss_infos[iter_43_0].node, "t_proceed", var_43_3 == 0 and "0" or tostring(var_43_3 - var_43_1))
	end
end

function CoopMission.DoEnter(arg_44_0)
	if not CoopMission:isUnlocked() or ContentDisable:byAlias("expedition") then
		balloon_message_with_sound(T("msg_contents_disable_expedition"))
		
		return 
	end
	
	if CoopMission:isMaintenance() then
		if not get_cocos_refid(CoopMission.maintenance) then
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
		
		return 
	end
	
	query("coop_lobby", arg_44_0)
end

function CoopMission.justUpdateInvitedList(arg_46_0)
	arg_46_0.vars.just_update_invited_list = true
end

function CoopMission.checkJustUpdateInvitedList(arg_47_0)
	local var_47_0 = arg_47_0.vars.just_update_invited_list
	
	arg_47_0.vars.just_update_invited_list = nil
	
	return var_47_0
end

function CoopMission.onTouchDown(arg_48_0)
	if not arg_48_0.vars then
		return 
	end
	
	local var_48_0 = arg_48_0:getCurrentRoom()
	
	if not var_48_0 then
		return 
	end
	
	var_48_0:onTouchDown()
end

function CoopMission._tutorialPopup(arg_49_0, arg_49_1)
	TutorialGuide:ifStartGuide("expedition_unlock")
	
	if arg_49_1.coop_info == nil or not arg_49_1.coop_info.url then
		arg_49_0:checkStartTutorial()
	end
	
	local var_49_0 = arg_49_1.coop_info ~= nil and arg_49_1.coop_info.url or "home"
	
	if var_49_0 == "hand" then
		arg_49_0:setMode("home")
		
		if not TutorialGuide:isPlayingTutorial() then
			arg_49_0:openHandPopup()
		end
	else
		arg_49_0:setMode(var_49_0)
	end
end

function CoopMission.ct_acrr(arg_50_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_50_0 = arg_50_0.vars.mission_list
	local var_50_1 = ""
	
	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		var_50_1 = iter_50_1.boss_id .. "," .. var_50_1
	end
	
	local var_50_2 = string.sub(var_50_1, 0, #var_50_1 - 1)
	
	print(var_50_2)
	query("cheat_coop_clear_rendered_rooms", {
		rooms = var_50_2
	})
end

function CoopMission.onEnter(arg_51_0, arg_51_1, arg_51_2)
	arg_51_0:clear()
	
	if not arg_51_2 then
		CoopMission.DoEnter()
	end
	
	arg_51_1 = arg_51_1 or {}
	
	local var_51_0 = SceneManager:getDefaultLayer()
	local var_51_1 = cc.Layer:create()
	
	var_51_0:addChild(var_51_1)
	
	local var_51_2 = load_dlg("expedition_home", true, "wnd")
	
	var_51_1:addChild(var_51_2)
	
	if arg_51_1.prev_scene and arg_51_1.prev_scene ~= "battle" then
		arg_51_0._last_enter_prev_scene = arg_51_1.prev_scene
	end
	
	arg_51_0.vars = {}
	arg_51_0.vars.root_layer = var_51_1
	arg_51_0.vars.wnd = var_51_2
	arg_51_0.vars.args = arg_51_1
	arg_51_0.vars.scene_args = arg_51_1
	arg_51_0.vars.mode_flow = {}
	arg_51_0.vars.home_portrait_x = var_51_2:getChildByName("n_portrait"):getPositionX()
	arg_51_0.vars.home_portrait_y = var_51_2:getChildByName("n_portrait"):getPositionY()
	
	arg_51_0:updateData(arg_51_2)
	arg_51_0:setBackground()
	
	arg_51_0.vars.supply_list = arg_51_0:getSupplyList("current")
	
	TopBarNew:create(T("coop_main"), arg_51_0.vars.root_layer, function()
		CoopMission:onPushBackButton()
	end, {
		"crystal",
		"gold",
		"stamina"
	}, nil, "infoexped")
	if_set_visible(arg_51_0.vars.wnd, "n_select", false)
	
	if arg_51_0.scene_state and arg_51_1.caller == "battle" then
		arg_51_0.vars.scene_state_tab = arg_51_0.scene_state.tab
	end
	
	arg_51_0.scene_state = nil
	
	local var_51_3 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EXPEDITION_POINT)
	
	if_set_visible(arg_51_0.vars.wnd, "n_event", var_51_3)
	arg_51_0:initListView()
	CoopUtil:updateSaveInviteAllList()
	
	if arg_51_1.caller == "battle" and arg_51_1.btn_go then
		local var_51_4 = Account:getCoopMissionData()
		local var_51_5 = var_51_4.my_lists[tostring(arg_51_1.boss_id)] or var_51_4.invite_list[tostring(arg_51_1.boss_id)]
		
		if not var_51_5 and var_51_4.open_lists then
			for iter_51_0, iter_51_1 in pairs(var_51_4.open_lists) do
				for iter_51_2, iter_51_3 in pairs(iter_51_1) do
					if iter_51_2 == tostring(arg_51_1.boss_id) then
						var_51_5 = iter_51_3
						
						break
					end
				end
			end
		end
		
		arg_51_0:setMode("home", nil, nil, true)
		arg_51_0:setMode("ready", var_51_5)
		
		return 
	elseif arg_51_1.caller == "battle" and arg_51_1.btn_list then
		local var_51_6 = arg_51_1.info
		
		arg_51_0.vars.currentBossBtn = var_51_6.boss_code
		
		arg_51_0:setMode("home", nil, nil, true)
		arg_51_0:reqSetMode("select")
		query("coop_my_with_invited_list", {
			boss_code = arg_51_0.vars.boss_infos[var_51_6.boss_code].data.id
		})
		
		if arg_51_0.vars.scene_state_tab == "hand" then
			arg_51_0:justUpdateInvitedList()
		end
		
		return 
	end
	
	if get_cocos_refid(arg_51_0.vars.wnd) then
		if_set(arg_51_0.vars.wnd, "time", CoopUtil:getRewardDateTime("home"))
	end
	
	if not arg_51_0:getAllRoomRewards(arg_51_1) then
		arg_51_0:_tutorialPopup(arg_51_1)
	end
end

function CoopMission.onAfterUpdate(arg_53_0)
	if arg_53_0.vars and get_cocos_refid(arg_53_0.vars.wnd) and arg_53_0:getMode() == "select" then
		arg_53_0.vars.refresh_cool_time_cur = os.time()
		arg_53_0.vars.refresh_cool_time_end = arg_53_0.vars.refresh_cool_time_end or 0
		
		if arg_53_0.vars.refresh_cool_time_cur >= arg_53_0.vars.refresh_cool_time_end then
			if_set(arg_53_0.vars.wnd:getChildByName("btn_refresh"), "txt", T("expedition_refresh_btn"))
		else
			if_set(arg_53_0.vars.wnd:getChildByName("btn_refresh"), "txt", T("expedition_refresh_time", {
				time = arg_53_0.vars.refresh_cool_time_end - arg_53_0.vars.refresh_cool_time_cur
			}))
		end
	end
end

function CoopMission.getScrollViewItem(arg_54_0, arg_54_1)
	local var_54_0 = load_control("wnd/expedition_get_list_item.csb")
	local var_54_1 = Account:getCoopMissionSchedule().boss[arg_54_1.boss_code].image
	local var_54_2 = Account:getCoopMissionSchedule().boss[arg_54_1.boss_code].character_id
	local var_54_3, var_54_4 = DB("character", var_54_2, {
		"ch_attribute",
		"name"
	})
	
	if_set_sprite(var_54_0, "boss", "face/" .. var_54_1 .. ".png")
	if_set_sprite(var_54_0, "icon", "img/cm_icon_pro" .. var_54_3 .. ".png")
	if_set(var_54_0, "t_name", T(var_54_4))
	if_set(var_54_0, "label", T("expedition_start"))
	
	var_54_0.data = {}
	var_54_0.data.id = var_54_2
	var_54_0.data.name = var_54_4
	var_54_0.data.image = var_54_1
	var_54_0.data.attribute = var_54_3
	var_54_0.data.boss_slot = arg_54_1.boss_slot
	var_54_0.data.boss_code = arg_54_1.boss_code
	
	return var_54_0
end

function CoopMission.onSelectScrollViewItem(arg_55_0, arg_55_1, arg_55_2)
	if arg_55_2.control:getName() == "btn_del" then
		Dialog:msgBox(T("expedition_boss_del_title"), {
			yesno = true,
			handler = function()
				query("coop_ticket_delete", {
					boss_slot = arg_55_2.item.boss_slot
				})
			end,
			title = T("expedition_boss_del_desc")
		})
	end
end

function CoopMission.initHandMissionListView(arg_57_0)
	if not arg_57_0 or not arg_57_0.vars or not get_cocos_refid(arg_57_0.vars.wnd) then
		return 
	end
	
	copy_functions(ScrollView, arg_57_0)
	
	arg_57_0.vars.wnd._hand.scroll_view = arg_57_0.vars.wnd._hand:getChildByName("ScrollView")
	
	arg_57_0.vars.wnd._hand.scroll_view:removeAllChildren()
	
	arg_57_0.vars.wnd._hand.scroll_view.cache = {}
	arg_57_0.vars.wnd._hand.scroll_view.ScrollViewItems = {}
	
	local var_57_0 = arg_57_0.vars.wnd._hand.scroll_view
	
	if not get_cocos_refid(var_57_0) then
		return 
	end
	
	local var_57_1 = Account:getCoopMissionData().ticket_list
	
	if_set_visible(arg_57_0.vars.wnd._hand, "n_none", table.count(var_57_1) == 0)
	if_set_visible(arg_57_0.vars.wnd._hand, "ScrollView", table.count(var_57_1) > 0)
	if_set(arg_57_0.vars.wnd._hand, "t_count", #var_57_1 .. "/5")
	
	if table.count(var_57_1) == 0 then
		return 
	end
	
	arg_57_0:initScrollView(var_57_0, 244, 377, {
		fit_height = true,
		force_horizontal = true
	})
	arg_57_0:createScrollViewItems(var_57_1)
end

DEBUG.SHOW_ROOM_ID_ON_LIST = false

function CoopMission.setClearTimeToRenderer(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	if not arg_58_2.clear_tm then
		return 
	end
	
	local var_58_0, var_58_1 = CoopUtil:getClearTime(arg_58_2.clear_tm, arg_58_2.start_tm)
	
	arg_58_3 = arg_58_3 or "t_complete_time"
	
	local var_58_2 = T("remain_min", {
		min = var_58_0
	})
	local var_58_3 = var_58_1 == 0 and "" or T("remain_hour", {
		hour = 
	})
	
	if_set(arg_58_1, arg_58_3, T("expedition_run_time", {
		hour = var_58_3,
		min = var_58_2
	}))
end

function CoopMission.updateStatusToRenderer(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	if_set_visible(arg_59_1, "btn_del", false)
	
	local var_59_0 = arg_59_1:findChildByName("btn_enter")
	
	if_set(var_59_0, "label", T("ui_dungeon_btnhell_label"))
	
	local var_59_1 = CoopUtil:getLevelData(arg_59_2).party_max or 0
	
	if_set(var_59_0, "t_count", "(" .. arg_59_2.user_count .. "/" .. var_59_1 .. ")")
	if_set_visible(arg_59_1, "btn_enter", not arg_59_3)
	if_set_visible(arg_59_1, "btn_result", arg_59_3)
	
	if arg_59_3 then
		local var_59_2 = CoopUtil:getConfigDBValue("expedition_result_keep_time")
		local var_59_3 = arg_59_2.clear_tm ~= nil and arg_59_2.clear_tm + var_59_2 or arg_59_2.expire_tm + var_59_2
		local var_59_4, var_59_5 = CoopUtil:getDisplayLeftTime(var_59_3, arg_59_4)
		
		if var_59_5 and var_59_5 > 0 then
			if_set(arg_59_1, "t_reward_time", T("remain_hour", {
				hour = var_59_5
			}))
		else
			if_set(arg_59_1, "t_reward_time", T("remain_min", {
				min = var_59_4
			}))
		end
	end
end

function CoopMission.buildUpdateData(arg_60_0, arg_60_1)
	local var_60_0 = {}
	
	if not arg_60_1 then
		return 
	end
	
	var_60_0.boss_info = arg_60_1.boss_info ~= nil and arg_60_1.boss_info or arg_60_1
	var_60_0.user_info = var_60_0.boss_info.boss_user_info ~= nil and var_60_0.boss_info.boss_user_info or var_60_0.boss_info
	
	if not var_60_0.boss_info then
		return 
	end
	
	var_60_0.expire_tm = var_60_0.boss_info.expire_tm or 0
	var_60_0.current_tm = os.time()
	var_60_0.last_hp = var_60_0.boss_info.last_hp or 0
	var_60_0.max_hp = var_60_0.boss_info.max_hp or 0
	var_60_0.is_cleared = var_60_0.boss_info.clear_tm ~= nil and var_60_0.last_hp <= 0
	var_60_0.is_expired = var_60_0.is_cleared or CoopUtil:isExpired(var_60_0.expire_tm, var_60_0.current_tm)
	var_60_0.leader_code = var_60_0.user_info.leader_code
	var_60_0.border_code = var_60_0.user_info.border_code
	var_60_0.is_open = var_60_0.boss_info and var_60_0.boss_info.open_tm
	var_60_0.join_type = arg_60_1.join_type
	
	return var_60_0
end

function CoopMission.additionalUpdate(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = arg_61_0:buildUpdateData(arg_61_2)
	
	if_set_visible(arg_61_1, "n_gauge", var_61_0.last_hp > 0)
	if_set_visible(arg_61_1, "hp", not var_61_0.is_expired)
	
	if var_61_0.last_hp > 0 and CoopUtil:isExpired(var_61_0.expire_tm, var_61_0.current_tm) then
		if_set_color(arg_61_1, "n_gauge", cc.c3b(80, 80, 80))
	else
		if_set_color(arg_61_1, "n_gauge", cc.c3b(255, 255, 255))
	end
	
	local var_61_1 = CoopUtil:getConfigDBValue("expedition_tm_bonus")
	local var_61_2 = var_61_0.is_cleared and var_61_0.boss_info.start_tm + var_61_1 >= var_61_0.boss_info.clear_tm
	
	if not CoopUtil:isUsableBonusTime() then
		var_61_2 = false
	end
	
	local var_61_3 = arg_61_1:getChildByName("t_time_proceeding")
	local var_61_4 = arg_61_1:getChildByName("t_complete_time_bonus")
	
	if_set(var_61_3, nil, CoopUtil:getTextLeftTime(var_61_0.expire_tm, var_61_0.current_tm))
	var_61_3:getChildByName("icon_time"):setPositionX(var_61_3:getContentSize().width + 25)
	if_set_visible(var_61_3, nil, not var_61_0.is_expired)
	if_set_visible(var_61_3, "icon_time", CoopUtil:isBonusTime(var_61_0.boss_info.start_tm, var_61_0.current_tm) and not var_61_0.is_expired)
	
	if var_61_2 then
		arg_61_0:setClearTimeToRenderer(arg_61_1, var_61_0.boss_info, "t_complete_time_bonus")
	end
	
	var_61_4:getChildByName("icon_time"):setPositionX(var_61_4:getContentSize().width + 25)
	if_set_visible(var_61_4, nil, var_61_2)
	arg_61_0:setClearTimeToRenderer(arg_61_1, var_61_0.boss_info)
	if_set_visible(arg_61_1, "t_complete_time", not var_61_2 and var_61_0.is_expired)
	if_set(arg_61_1, "t_complete", T("expedition_complete"))
	if_set_visible(arg_61_1, "n_complete", var_61_0.is_cleared)
	if_set_visible(arg_61_1, "t_fail", not var_61_0.is_cleared and var_61_0.is_expired)
	
	if not arg_61_0.vars.n_btn_normal.toggle_del then
		if_set_visible(arg_61_1, "btn_del", true)
		if_set_visible(arg_61_1, "btn_enter", false)
	else
		arg_61_0:updateStatusToRenderer(arg_61_1, var_61_0.boss_info, var_61_0.is_expired, var_61_0.current_tm)
	end
	
	local var_61_5 = var_61_0.user_info.id == Account:getUserId()
	local var_61_6
	local var_61_7 = arg_61_1:getChildByName("n_bonus")
	
	if var_61_5 then
		var_61_6 = not var_61_0.is_open
	elseif var_61_0.join_type and var_61_0.join_type == 0 then
		var_61_6 = true
	elseif not var_61_0.is_open then
		var_61_6 = true
	end
	
	if not var_61_5 and arg_61_0.vars.tab and arg_61_0.vars.tab == "share" then
		var_61_6 = true
	end
	
	if_set_visible(var_61_7, nil, var_61_6)
	
	local var_61_8 = arg_61_1:getChildByName("txt_level")
	
	if get_cocos_refid(var_61_8) and var_61_6 and not var_61_7.origin_x then
		var_61_7:setPositionX(var_61_8:getPositionX() + 10 + var_61_8:getContentSize().width * var_61_8:getScaleX())
	end
end

function CoopMission.getCurrentTab(arg_62_0)
	if not arg_62_0.vars or not arg_62_0.vars.tab then
		return 
	end
	
	return arg_62_0.vars.tab
end

function CoopMission.commonUpdate(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0 = arg_63_1:getChildByName("n_item")
	
	if not var_63_0 then
		return 
	end
	
	var_63_0._datasource = arg_63_3
	
	local var_63_1 = arg_63_0:buildUpdateData(arg_63_3)
	
	UIUtil:getUserIcon(var_63_1.leader_code, {
		no_popup = true,
		no_tooltip = true,
		no_zodiac = true,
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = arg_63_1:getChildByName("face_icon"),
		border_code = var_63_1.border_code
	})
	if_set(arg_63_1, "t_starter", T("expedition_boss_finder"))
	if_set(arg_63_1, "t_name", var_63_1.user_info.name)
	UIUserData:call(arg_63_1:getChildByName("t_name"), "SINGLE_WSCALE(145)")
	CoopUtil:setDifficulty(arg_63_1:findChildByName("n_difficulty"), var_63_1.boss_info.difficulty)
	
	local var_63_2 = var_63_1.last_hp / var_63_1.max_hp
	
	if var_63_1.last_hp > 0 and var_63_1.max_hp > 0 then
		arg_63_1:findChildByName("hp"):setScaleX(var_63_2)
	else
		arg_63_1:findChildByName("hp"):setScaleX(0)
	end
	
	if arg_63_1:findChildByName("hp"):getScaleX() ~= arg_63_1:findChildByName("hp_red"):getScaleX() then
		arg_63_1:findChildByName("hp_red"):setScaleX(arg_63_1:findChildByName("hp"):getScaleX())
	end
	
	arg_63_0:additionalUpdate(arg_63_1, arg_63_3)
end

function CoopMission.onListViewItemUpdate(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	arg_64_0:commonUpdate(arg_64_1, arg_64_2, arg_64_3)
end

function CoopMission.onLightListViewUpdate(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	arg_65_0:additionalUpdate(arg_65_1, arg_65_3)
end

function CoopMission.initListView(arg_66_0)
	local var_66_0 = arg_66_0.vars.wnd:getChildByName("ListView")
	
	arg_66_0.vars.missionList = ItemListView_v2:bindControl(var_66_0)
	
	local var_66_1 = load_control("wnd/expedition_home_sel_item.csb")
	
	if var_66_0.STRETCH_INFO then
		local var_66_2 = var_66_0:getContentSize()
		
		resetControlPosAndSize(var_66_1, var_66_2.width, var_66_0.STRETCH_INFO.width_prev)
	end
	
	local var_66_3 = {
		onUpdate = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			arg_66_0:onListViewItemUpdate(arg_67_1, arg_67_2, arg_67_3)
		end,
		onLightUpdate = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
			arg_66_0:onLightListViewUpdate(arg_68_1, arg_68_2, arg_68_3)
		end
	}
	
	arg_66_0.vars.missionList:setRenderer(var_66_1, var_66_3)
	arg_66_0.vars.missionList:removeAllChildren()
	arg_66_0.vars.missionList:setDataSource({})
	arg_66_0.vars.missionList:jumpToTop()
end

function CoopMission.clear(arg_69_0)
	if get_cocos_refid(arg_69_0.root_layer) then
		arg_69_0.root_layer:removeFromParent()
	end
	
	arg_69_0.root_layer = nil
	arg_69_0.vars = nil
end

function CoopMission.setBackground(arg_70_0)
	local var_70_0 = arg_70_0.vars.wnd:getChildByName("n_bg")
	
	if get_cocos_refid(var_70_0) then
		var_70_0:removeAllChildren()
		
		local var_70_1 = cc.Sprite:create("worldmap/expedition.png")
		
		var_70_0:addChild(var_70_1)
	end
end

function CoopMission.getMode(arg_71_0)
	return arg_71_0.vars.mode
end

function CoopMission.currentModeUpdateArgs(arg_72_0, arg_72_1, arg_72_2)
	if not arg_72_0.vars then
		return 
	end
	
	arg_72_0.vars.mode_flow[#arg_72_0.vars.mode_flow].args[arg_72_1] = arg_72_2
end

function CoopMission.reqSetMode(arg_73_0, arg_73_1)
	arg_73_0.vars.req_mode = arg_73_1
end

function CoopMission.isModeRequested(arg_74_0, arg_74_1)
	return arg_74_0.vars.req_mode == arg_74_1
end

function CoopMission.setMode(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4, arg_75_5)
	arg_75_0.vars = arg_75_0.vars or {}
	
	if arg_75_0.vars.mode == arg_75_1 then
		return 
	end
	
	if arg_75_1 and arg_75_1 == "result" and arg_75_0.vars and arg_75_0.vars.tab and arg_75_0.vars.tab == "open" then
		return 
	end
	
	if arg_75_0.vars.req_mode == arg_75_1 then
		arg_75_0.vars.req_mode = nil
	end
	
	local var_75_0 = arg_75_0.vars.mode
	
	if var_75_0 then
		local var_75_1 = arg_75_0[string.format("onLeaveMode_%s", var_75_0)]
		
		if var_75_1 then
			var_75_1(arg_75_0, arg_75_1)
		end
		
		if var_75_0 == "ready" and arg_75_1 == "select" then
			arg_75_0:refreshBossList(true)
		end
	end
	
	arg_75_0.vars.mode = arg_75_1
	arg_75_0.vars.args = arg_75_2
	
	if not arg_75_3 then
		table.insert(arg_75_0.vars.mode_flow, {
			mode = arg_75_1,
			args = arg_75_2
		})
	end
	
	if not arg_75_4 then
		local var_75_2 = arg_75_0[string.format("onEnterMode_%s", arg_75_0.vars.mode)]
		
		if arg_75_5 then
			arg_75_2 = arg_75_2 or {}
			arg_75_2.ignore_tutorial = true
		end
		
		if var_75_2 then
			var_75_2(arg_75_0, arg_75_2, var_75_0)
		end
	end
	
	if var_75_0 == "select" then
		arg_75_0.vars.is_exist_open_list = nil
	end
	
	arg_75_0:onChangeMode()
end

function CoopMission.onChangeMode(arg_76_0)
end

function CoopMission.checkCanOpenReady(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_1.coop_members
	
	if not var_77_0 then
		return false
	end
	
	local var_77_1 = arg_77_0.vars.ready_args
	local var_77_2 = var_77_1.boss_info or var_77_1
	
	if (CoopUtil:getLevelData(var_77_2).party_max or 6) > table.count(var_77_0) then
		return true
	end
	
	for iter_77_0, iter_77_1 in pairs(var_77_0) do
		if iter_77_0 == tostring(Account:getUserId()) then
			return true
		end
	end
	
	return false
end

function CoopMission.onMsgCoopReadyEnter(arg_78_0, arg_78_1)
	if not arg_78_0.vars.ready then
		if arg_78_0:getCurrentTab() == "share" or arg_78_0:getCurrentTab() == "open" then
			if not arg_78_0:checkCanOpenReady(arg_78_1) then
				arg_78_0.vars.ready_args = nil
				arg_78_0.vars.ready_enter_failed = true
				
				return 
			end
			
			if get_cocos_refid(arg_78_0.vars.wnd) then
				arg_78_0.vars.wnd:setVisible(false)
			end
			
			arg_78_0.vars.ready = CoopReady(arg_78_0.vars.ready_args)
			
			arg_78_0.vars.ready:show(arg_78_0.vars.root_layer)
			arg_78_0:setMode("ready", arg_78_0.vars.ready_args, nil, true)
			
			arg_78_0.vars.ready_args = nil
		else
			Log.e("NOT EXIST READY !")
			
			return 
		end
	end
	
	arg_78_0.vars.ready:onResponse(arg_78_1)
end

function CoopMission.onMsgCoopResult(arg_79_0, arg_79_1)
	if not arg_79_0.vars.result then
		Log.e("NOT EXISTS RESUKLT ")
		
		return 
	end
	
	if_set_visible(arg_79_0.vars.wnd, nil, false)
	
	if arg_79_1.max_difficulty then
		Account:updateCoopMaxDifficulty(arg_79_1)
	end
	
	if arg_79_1.point_value then
		Account:addCoopPointValue(arg_79_1)
	end
	
	arg_79_0.vars.result:onQuery(arg_79_1)
end

function CoopMission.checkStartTutorial(arg_80_0)
	if not arg_80_0.vars then
		return 
	end
	
	if arg_80_0.vars.mode == "home" then
		TutorialGuide:onEnterCoopLobby()
	end
end

function CoopMission.onEnterMode_home(arg_81_0, arg_81_1, arg_81_2)
	if get_cocos_refid(arg_81_0.vars.wnd) then
		arg_81_0:updateHomeBossBtn()
		if_set(arg_81_0.vars.wnd, "time", CoopUtil:getRewardDateTime("home"))
		
		local var_81_0 = arg_81_0:isPremiumSeason()
		
		if_set_visible(arg_81_0.vars.wnd:getChildByName("btn_pass"), "icon_noti", arg_81_0:isRewardReceivable("current") or var_81_0 and arg_81_0:isShowRedDotOnSupplyPass("home"))
		arg_81_0.vars.wnd:setVisible(true)
		if_set_visible(arg_81_0.vars.wnd, "n_home", true)
		
		local var_81_1 = table.count(Account:getCoopMissionData().ticket_list)
		
		if_set_visible(arg_81_0.vars.wnd:getChildByName("btn_get"), "noti_count", var_81_1 > 0)
		if_set(arg_81_0.vars.wnd:getChildByName("btn_get"), "count_mission", var_81_1)
		
		local var_81_2 = arg_81_0.vars.wnd:getChildByName("btn_discussion")
		
		if get_cocos_refid(var_81_2) then
			local var_81_3 = not ContentDisable:byAlias("expedition_guide") and IS_PUBLISHER_STOVE
			
			if_set_visible(var_81_2, nil, var_81_3)
		end
	end
	
	if not get_cocos_refid(arg_81_0.vars.portrait) then
		local var_81_4 = UIUtil:getPortraitAni("npc1034", {
			pin_sprite_position_y = true
		})
		
		if get_cocos_refid(var_81_4) then
			var_81_4:setScale(0.87)
			
			local var_81_5 = arg_81_0.vars.wnd:getChildByName("n_portrait")
			
			var_81_5:removeAllChildren()
			var_81_5:addChild(var_81_4)
			
			arg_81_0.vars.portrait = var_81_4
			
			arg_81_0.vars.wnd:getChildByName("n_balloon"):setScale(0)
			UIUtil:playNPCSoundAndTextRandomly("expedition.enter", arg_81_0.vars.wnd, "txt_balloon", 800, nil, arg_81_0.vars.portrait)
			UIAction:Add(SEQ(DELAY(400), CALL(function()
				if_set_visible(arg_81_0.vars.wnd, "n_balloon", true)
			end), SCALE(140, 0, 1)), arg_81_0.vars.wnd:getChildByName("n_balloon"), "block")
		end
	end
	
	if (not arg_81_1 or not arg_81_1.ignore_tutorial) and not arg_81_0:isModeRequested("select") then
		arg_81_0:checkStartTutorial()
	end
end

function CoopMission.isPremiumSeason(arg_83_0)
	local var_83_0 = Account:getCoopMissionSchedule().premium_price
	
	if arg_83_0.vars.supply and arg_83_0.vars.supply.mode == "previous" then
		var_83_0 = arg_83_0.vars.custom_season_data.coop_mission_schedule.premium_price
	end
	
	return var_83_0
end

function CoopMission.getSupplyMode(arg_84_0)
	if not arg_84_0.vars or not arg_84_0.vars.supply then
		return 
	end
	
	return arg_84_0.vars.supply.mode
end

function CoopMission.getSupplyList(arg_85_0, arg_85_1)
	arg_85_1 = arg_85_1 or "current"
	
	local var_85_0 = {}
	local var_85_1 = {}
	local var_85_2 = {}
	
	if arg_85_1 ~= "previous" then
		var_85_2 = Account:getCoopMissionSchedule().boss
	else
		var_85_2 = arg_85_0:getPreviousCoopInfo().coop_mission_schedule.boss
	end
	
	for iter_85_0, iter_85_1 in pairs(var_85_2) do
		local var_85_3 = iter_85_1.supply_group_id
		local var_85_4 = iter_85_1.sort
		
		var_85_1[iter_85_0] = {
			key = var_85_3,
			sort = var_85_4
		}
	end
	
	local var_85_5 = arg_85_0:isPremiumSeason()
	
	for iter_85_2 = 1, 999 do
		for iter_85_3, iter_85_4 in pairs(var_85_1) do
			local var_85_6, var_85_7, var_85_8, var_85_9, var_85_10, var_85_11, var_85_12 = DB("expedition_supply", iter_85_4.key .. "_" .. iter_85_2, {
				"id",
				"supply_group_id",
				"point",
				"show_item",
				"value",
				"premium",
				"sort"
			})
			
			if var_85_6 == nil then
				break
			end
			
			var_85_0[iter_85_2] = var_85_0[iter_85_2] or {}
			var_85_0[iter_85_2][iter_85_3] = {
				id = var_85_6,
				group_id = var_85_7,
				point = var_85_8,
				show_item = var_85_9,
				value = var_85_10,
				sort = iter_85_4.sort,
				premium = var_85_11,
				list_sort = var_85_12
			}
		end
	end
	
	local var_85_13 = {}
	
	for iter_85_5, iter_85_6 in pairs(var_85_0 or {}) do
		if not var_85_5 then
			local var_85_14 = false
			
			for iter_85_7, iter_85_8 in pairs(var_85_1 or {}) do
				if iter_85_6[iter_85_7].premium ~= nil then
					var_85_14 = true
					
					break
				end
			end
			
			if not var_85_14 then
				var_85_13[iter_85_5] = iter_85_6
			end
		else
			var_85_13[iter_85_5] = iter_85_6
		end
	end
	
	table.sort(var_85_13, function(arg_86_0, arg_86_1)
		for iter_86_0, iter_86_1 in pairs(var_85_1) do
			if arg_86_0[iter_86_0].list_sort and arg_86_1[iter_86_0].list_sort then
				return arg_86_0[iter_86_0].list_sort < arg_86_1[iter_86_0].list_sort
			else
				return arg_86_0[iter_86_0].point < arg_86_1[iter_86_0].point
			end
		end
	end)
	
	return var_85_13
end

function CoopMission.resetSupplyListView(arg_87_0)
	local var_87_0 = arg_87_0.vars.supply.mode
	
	if_set_visible(arg_87_0.vars.wnd._supply_wnd, "btn_pre", var_87_0 == "current")
	if_set_visible(arg_87_0.vars.wnd._supply_wnd, "btn_cur", var_87_0 ~= "current")
	
	local var_87_1 = var_87_0 == "previous" and arg_87_0:getPreviousCoopInfo().coop_mission_schedule.boss or Account:getCoopMissionSchedule().boss
	local var_87_2 = {}
	
	for iter_87_0, iter_87_1 in pairs(var_87_1) do
		var_87_2[iter_87_0] = iter_87_1.sort
	end
	
	if_set(arg_87_0.vars.wnd._supply_wnd, "txt_periord", CoopUtil:getRewardDateTime(arg_87_0.vars.supply.mode))
	
	local var_87_3 = var_87_0 == "previous" and arg_87_0:getPreviousCoopInfo().season_data or Account:getCoopMissionData().season_data
	
	if var_87_0 == "previous" and table.count(var_87_3) then
		var_87_3 = arg_87_0:getPreviousCoopInfo().coop_mission_schedule.boss
	end
	
	for iter_87_2, iter_87_3 in pairs(var_87_3) do
		local var_87_4 = iter_87_3.character_id or Account:getCoopMissionSchedule().boss[iter_87_2].character_id
		local var_87_5 = iter_87_3.supply_group_id or Account:getCoopMissionSchedule().boss[iter_87_2].supply_group_id
		local var_87_6 = iter_87_3.point or 0
		
		if_set(arg_87_0.vars.wnd._supply_wnd, "t_area" .. var_87_2[iter_87_2], T(DB("character", var_87_4, {
			"name"
		})))
		if_set(arg_87_0.vars.wnd._supply_wnd:getChildByName("n_area_point" .. var_87_2[iter_87_2]), "t_point", T("expedition_my_point", {
			point = CoopUtil:getFormatIntComma(math.min(var_87_6 or 0, CoopUtil:getMaxRewardPoint(var_87_5) or 0))
		}))
	end
	
	arg_87_0.vars.home_delta_x = arg_87_0.vars.home_delta_x or arg_87_0.vars.wnd:getChildByName("n_portrait_pass"):getPositionX() - arg_87_0.vars.home_portrait_x
	arg_87_0.vars.home_balloon_x = arg_87_0.vars.home_balloon_x or arg_87_0.vars.wnd:getChildByName("n_balloon"):getPositionX()
	
	UIAction:Add(SEQ(LOG(SPAWN(MOVE_TO(400, arg_87_0.vars.wnd:getChildByName("n_portrait_pass"):getPositionX(), arg_87_0.vars.wnd._supply_wnd:getChildByName("n_portrait"):getPositionY())))), arg_87_0.vars.wnd:getChildByName("n_portrait"), "block")
	UIAction:Add(SEQ(LOG(SPAWN(MOVE_TO(400, arg_87_0.vars.home_balloon_x + arg_87_0.vars.home_delta_x, arg_87_0.vars.wnd:getChildByName("n_balloon"):getPositionY())))), arg_87_0.vars.wnd:getChildByName("n_balloon"), "block")
	UIAction:Add(SEQ(SPAWN(LOG(FADE_IN(140)), CALL(function()
		arg_87_0.vars.wnd._supply_wnd:setEnabled(true)
	end))), arg_87_0.vars.wnd._supply_wnd, "block")
	arg_87_0.vars.wnd._supply_wnd:getChildByName("btn_pre"):setOpacity(255)
	
	if arg_87_0.vars.supply and arg_87_0.vars.supply.clearScrollViewItems then
		arg_87_0.vars.supply:clearScrollViewItems()
	end
	
	arg_87_0:initSupplyListView()
end

function CoopMission.getAllRoomRewards(arg_89_0, arg_89_1, arg_89_2)
	if not arg_89_2 and table.count(Account:getCoopMissionData().rewards or {}) == 0 and table.count(Account:getCoopMissionData().point_infos or {}) == 0 then
		return false
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	
	local var_89_0 = load_dlg("expedition_previous_reward_p", true, "wnd")
	
	if_set_visible(var_89_0, "n_item", true)
	if_set_visible(var_89_0, "n_point", true)
	if_set_visible(var_89_0, "n_center", false)
	
	arg_89_0.vars.all_reward_wnd = var_89_0
	
	BackButtonManager:push({
		check_id = "coop.all_reward",
		back_func = function()
			BackButtonManager:pop("coop.all_reward")
			
			if get_cocos_refid(CoopMission.vars.all_reward_wnd) then
				UIAction:Add(SEQ(FADE_OUT(140), REMOVE()), CoopMission.vars.all_reward_wnd, "block")
			end
			
			CoopMission:_tutorialPopup(arg_89_1)
		end,
		dlg = var_89_0
	})
	
	arg_89_0.vars.tuto_args = arg_89_1
	
	local var_89_1 = Account:getCoopMissionData().rewards
	local var_89_2 = Account:getCoopMissionData().point_infos
	local var_89_3 = Account:addReward(var_89_1)
	local var_89_4 = 0
	
	for iter_89_0, iter_89_1 in pairs(var_89_2 or {}) do
		for iter_89_2, iter_89_3 in pairs(iter_89_1) do
			var_89_4 = var_89_4 + iter_89_3.point
		end
	end
	
	local var_89_5 = var_89_4 == 0 and true or false
	
	if_set_visible(var_89_0, "n_no_point", var_89_5)
	if_set_visible(var_89_0, "n_boss", not var_89_5)
	
	local var_89_6 = {}
	
	for iter_89_4, iter_89_5 in pairs(var_89_3.rewards) do
		if Account:isCurrencyType(iter_89_5.code) then
			iter_89_5.code = "to_" .. iter_89_5.code
		end
		
		if not iter_89_5.is_randombox then
			table.insert(var_89_6, iter_89_5)
		end
	end
	
	local var_89_7 = ItemListView:bindControl(var_89_0:getChildByName("listview_item"))
	local var_89_8 = {
		onUpdate = function(arg_91_0, arg_91_1, arg_91_2)
			arg_91_1:removeAllChildren()
			
			arg_91_1 = UIUtil:getRewardIcon(arg_91_2.count, arg_91_2.code, {
				tooltip_delay = 130,
				parent = arg_91_1
			})
			
			arg_91_1:setPosition(0, 10)
			arg_91_1:setAnchorPoint(0, 0)
		end
	}
	
	var_89_7:setClippingEnabled(true)
	
	local var_89_9
	
	if not PRODUCTION_MODE and arg_89_2 then
		var_89_9 = {
			count = 2,
			code = "ma_azimanak_reforge"
		}
		
		for iter_89_6 = 1, 20 do
			var_89_3.rewards[iter_89_6] = var_89_9
		end
	end
	
	local var_89_10 = cc.Layer:create()
	
	var_89_10:setContentSize(102, 110)
	var_89_7:setRenderer(var_89_10, var_89_8)
	var_89_7:setItems(var_89_6)
	
	local var_89_11
	
	if not var_89_5 then
		var_89_11 = {}
		
		for iter_89_7, iter_89_8 in pairs(var_89_2 or {}) do
			for iter_89_9, iter_89_10 in pairs(iter_89_8) do
				if iter_89_10.point > 0 then
					table.insert(var_89_11, {
						point = iter_89_10.point,
						boss_code = iter_89_9,
						season_no = iter_89_7,
						character_id = iter_89_10.character_id,
						sort = iter_89_10.sort,
						add_bonus_point = iter_89_10.add_bonus_point
					})
				end
			end
		end
		
		local function var_89_12(arg_92_0, arg_92_1)
			return arg_92_0.sort <= arg_92_1.sort
		end
		
		table.sort(var_89_11, var_89_12)
		
		for iter_89_11 = 1, 3 do
			local var_89_13 = var_89_0:getChildByName("n_boss_" .. iter_89_11)
			
			if_set_visible(var_89_13, nil, var_89_11[iter_89_11])
			
			if var_89_11[iter_89_11] then
				local var_89_14 = var_89_13:getChildByName("txt_count")
				local var_89_15 = var_89_13:getChildByName("txt_point")
				local var_89_16 = var_89_13:getChildByName("n_bonus")
				
				if get_cocos_refid(var_89_14) and get_cocos_refid(var_89_15) and get_cocos_refid(var_89_16) then
					local var_89_17 = UIUtil:getRewardIcon(nil, var_89_11[iter_89_11].character_id, {
						hide_lv = true,
						hide_star = true,
						tier = "boss",
						show_color_right = true,
						no_popup = true,
						no_grade = true,
						parent = var_89_13:getChildByName("n_mob_icon")
					})
					local var_89_18 = tonumber(var_89_11[iter_89_11].point)
					local var_89_19 = var_89_11[iter_89_11].add_bonus_point
					
					if var_89_19 and var_89_19 > 0 then
						if_set_visible(var_89_16, nil, true)
						if_set(var_89_16, "txt_bonus", var_89_19)
						
						if not var_89_14.origin_y or not var_89_15.origin_y then
							var_89_14.origin_y = var_89_14:getPositionY()
							var_89_15.origin_y = var_89_15:getPositionY()
							
							var_89_14:setPositionY(var_89_14:getPositionY() + 10)
							var_89_15:setPositionY(var_89_15:getPositionY() - 10)
						end
						
						var_89_18 = var_89_18 - tonumber(var_89_19)
					end
					
					if_set(var_89_14, nil, var_89_18)
					if_set(var_89_15, nil, T("expedition_point_title"))
				end
			end
		end
	end
	
	arg_89_0.vars.wnd:addChild(var_89_0)
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		pivot_y = 600,
		pivot_z = 99998,
		layer = arg_89_0.vars.all_reward_wnd,
		pivot_x = VIEW_WIDTH / 2 - 150
	})
	ConditionContentsManager:setIgnoreQuery(false)
	ConditionContentsManager:queryUpdateConditions("h:getAllRoomRewards")
	
	return true
end

function CoopMission.getPreviousCoopInfo(arg_93_0)
	return arg_93_0.vars.custom_season_data or nil
end

function CoopMission.initSupplyListView(arg_94_0)
	local var_94_0 = arg_94_0.vars.wnd._supply_wnd:getChildByName("scroll_view_rewards")
	
	if not get_cocos_refid(var_94_0) then
		return 
	end
	
	copy_functions(ScrollView, arg_94_0.vars.supply)
	
	arg_94_0.vars.supply.scroll_view = var_94_0
	
	var_94_0:removeAllChildren()
	
	local var_94_1 = 1
	local var_94_2 = 0
	local var_94_3
	
	function arg_94_0.vars.supply.getScrollViewItem(arg_95_0, arg_95_1)
		local var_95_0 = load_control("wnd/expedition_pass_base_item.csb")
		local var_95_1 = 0
		local var_95_2 = CoopMission:getSupplyMode() == "current" and Account:getCoopMissionData() or CoopMission:getPreviousCoopInfo()
		local var_95_3 = 0
		
		for iter_95_0, iter_95_1 in pairs(arg_95_1) do
			if iter_95_1.premium then
				var_95_3 = var_95_3 + 1
			end
		end
		
		if_set_visible(var_95_0, "n_premium_reward", var_95_3 >= 3)
		if_set_visible(var_95_0, "n_point_reward", var_95_3 < 3)
		
		local var_95_4 = var_95_3 >= 3 and var_95_0:getChildByName("n_premium_reward") or var_95_0:getChildByName("n_point_reward")
		local var_95_5 = CoopMission:getPremiumPass(var_95_2.coop_mission_schedule.season_number)
		local var_95_6 = var_95_5 and var_95_5.premium_pass_state == 1 or false
		
		if_set_visible(var_95_4, "n_not_yet", not var_95_6)
		
		for iter_95_2, iter_95_3 in pairs(arg_95_1) do
			local var_95_7 = iter_95_3.sort
			
			iter_95_3.point = iter_95_3.point or 0
			
			if_set(var_95_4, "txt_point", T("expedition_point", {
				point = CoopUtil:getFormatIntComma(iter_95_3.point)
			}))
			if_set(var_95_4, "txt_point_premium", T("expedition_point", {
				point = CoopUtil:getFormatIntComma(iter_95_3.point)
			}))
			
			local var_95_8 = UIUtil:getRewardIcon(iter_95_3.value, iter_95_3.show_item, {
				parent = var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"):getChildByName("n_reward_icon")
			})
			
			var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"):setOpacity(0)
			
			local var_95_9 = var_95_2.season_data[iter_95_2] and var_95_2.season_data[iter_95_2].point or 0
			local var_95_10 = var_95_2.season_data[iter_95_2] and var_95_2.season_data[iter_95_2].reward_point or 0
			local var_95_11 = var_95_2.season_data[iter_95_2] and var_95_2.season_data[iter_95_2].premium_reward_point or 0
			
			var_95_10 = var_95_3 >= 3 and var_95_11 or var_95_10
			
			if not var_95_6 and var_95_3 >= 3 then
				if_set_visible(var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"), "icon_locked", true)
				if_set_visible(var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"), "icon_check", false)
			else
				if_set_visible(var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"), "icon_locked", var_95_9 < iter_95_3.point)
				if_set_visible(var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"), "icon_check", var_95_10 >= iter_95_3.point)
				
				if var_95_10 >= iter_95_3.point then
					local var_95_12 = var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"):getChildByName("icon_check")
					
					var_95_12:setScale(3)
					UIAction:Add(SEQ(DELAY(var_94_1 * 40), SPAWN(SCALE(var_94_1 * 40, 3, 1))), var_95_12, "block")
					
					var_95_1 = var_95_1 + 1
				end
			end
			
			if var_95_9 < iter_95_3.point then
				var_95_8:setOpacity(76.5)
			elseif var_95_10 >= iter_95_3.point then
				var_95_8:setOpacity(76.5)
			elseif var_95_3 < 3 or var_95_6 then
				var_95_8:setOpacity(255)
				
				var_94_3 = var_94_3 or var_94_1
			end
			
			UIAction:Add(SEQ(DELAY(var_94_1 * 50), SPAWN(LOG(FADE_IN(170)))), var_95_4:getChildByName("n_area" .. var_95_7 .. "_reward"), "block")
		end
		
		if var_95_1 == 3 then
			var_94_2 = math.max(var_94_1, var_94_2)
		end
		
		var_94_1 = var_94_1 + 1
		
		return var_95_0
	end
	
	arg_94_0.vars.supply:initScrollView(var_94_0, 105 / (VIEW_WIDTH_RATIO * VIEW_WIDTH_RATIO), 453, {
		force_horizontal = true
	})
	arg_94_0.vars.supply:createScrollViewItems(CoopMission:getSupplyList(arg_94_0:getSupplyMode()))
	
	if var_94_2 == 0 or var_94_2 == 1 then
		var_94_2 = 0
	end
	
	var_94_2 = var_94_1 <= var_94_2 and var_94_1 or var_94_2
	
	UIAction:Add(SEQ(DELAY(100), CALL(function()
		arg_94_0.vars.supply:scrollToIndex(var_94_3 or var_94_2 + 1, 1)
	end)), arg_94_0.vars.supply, "block")
end

function CoopMission.getPremiumPass(arg_97_0, arg_97_1)
	local var_97_0 = Account:getCoopMissionData().user_season_infos
	
	if var_97_0 then
		arg_97_1 = arg_97_1 or Account:getCoopMissionSchedule().season_number
		arg_97_1 = to_n(arg_97_1)
		
		return var_97_0[arg_97_1]
	end
end

function CoopMission.isEnablePremiumPass(arg_98_0, arg_98_1)
	arg_98_1 = arg_98_1 or Account:getCoopMissionSchedule().season_number
	
	local var_98_0 = arg_98_0:getPremiumPass(arg_98_1)
	
	if not var_98_0 or not var_98_0.premium_pass_state then
		return 
	end
	
	return var_98_0.premium_pass_state == 1
end

function CoopMission.updateSupplyBtnState(arg_99_0)
	if not get_cocos_refid(arg_99_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_99_0.vars.wnd._supply_wnd) then
		return 
	end
	
	local var_99_0 = arg_99_0:isPremiumSeason()
	
	if arg_99_0.vars.wnd._supply_wnd:getChildByName("btn_recive_all_pre") then
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_recive_all_pre", not var_99_0)
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_recive_all", var_99_0)
	else
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_recive_all", true)
	end
	
	if_set(arg_99_0.vars.wnd._supply_wnd:getChildByName("RIGHT"), "txt_info", T("expedition_pass_reward_desc", timeToStringDef({
		preceding_with_zeros = true,
		time = to_n(Account:getCoopMissionSchedule().start_time)
	})))
	if_set_visible(arg_99_0.vars.wnd._supply_wnd:getChildByName("RIGHT"), "txt_info", var_99_0)
	if_set_opacity(arg_99_0.vars.wnd._supply_wnd, "btn_recive_all", arg_99_0:isRewardReceivable(arg_99_0.vars.supply.mode) and 255 or 76.5)
	if_set_opacity(arg_99_0.vars.wnd._supply_wnd, "btn_recive_all_pre", arg_99_0:isRewardReceivable(arg_99_0.vars.supply.mode) and 255 or 76.5)
	
	if var_99_0 then
		local var_99_1 = arg_99_0:getPremiumPass(arg_99_0.vars.supply.mode == "previous" and Account:getCoopMissionData().previous_season_number)
		local var_99_2 = var_99_1 and var_99_1.premium_pass_state == 1 or false
		
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_premium", not var_99_2)
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_done", var_99_2)
		
		if not var_99_2 then
			if_set_opacity(arg_99_0.vars.wnd._supply_wnd, "btn_premium", var_99_2 and 76.5 or 255)
			
			if arg_99_0.vars.supply.mode == "previous" then
				if_set_opacity(arg_99_0.vars.wnd._supply_wnd, "btn_premium", 76.5)
			end
		end
	else
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_premium", false)
		if_set_visible(arg_99_0.vars.wnd._supply_wnd, "btn_done", false)
	end
	
	if_set_visible(arg_99_0.vars.wnd:getChildByName("btn_premium"), "icon_noti", arg_99_0:isShowRedDotOnSupplyPass("supply") and arg_99_0.vars.supply.mode == "current")
end

function CoopMission.onEnterMode_supply(arg_100_0, arg_100_1)
	if not get_cocos_refid(arg_100_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_100_0.vars.wnd._supply_wnd) then
		arg_100_0.vars.wnd._supply_wnd = load_dlg("expedition_pass_base", true, "wnd")
		
		arg_100_0.vars.wnd._supply_wnd:setOpacity(0)
		arg_100_0.vars.wnd:addChild(arg_100_0.vars.wnd._supply_wnd)
	end
	
	arg_100_0.vars.supply = {}
	arg_100_0.vars.supply.mode = "current"
	
	TopBarNew:checkhelpbuttonID("infoexped_5")
	if_set(arg_100_0.vars.wnd._supply_wnd:getChildByName("btn_pre"), "label", T("expedition_reward_prev_btn"))
	if_set(arg_100_0.vars.wnd._supply_wnd, "txt_periord", CoopUtil:getRewardDateTime(arg_100_0.vars.supply.mode))
	arg_100_0:updateSupplyBtnState()
	if_set_visible(arg_100_0.vars.wnd._supply_wnd:getChildByName("n_periord_info"), "n_info", true)
	if_set_visible(arg_100_0.vars.wnd._supply_wnd:getChildByName("btn_premium"), "icon_noti", arg_100_0:isShowRedDotOnSupplyPass("supply") and arg_100_0.vars.supply.mode == "current")
	arg_100_0:resetSupplyListView()
	
	if arg_100_0:isPremiumSeason() then
		TutorialGuide:procGuide("expedition_reward_new")
	else
		TutorialGuide:procGuide("expedition_reward")
	end
end

function CoopMission.isShowRedDotOnSupplyPass(arg_101_0, arg_101_1)
	local var_101_0 = Account:getCoopMissionSchedule().season_number
	local var_101_1 = SAVE:getKeep("coop_season_supply_pass_reddot", "")
	local var_101_2 = json.decode(var_101_1) or {}
	
	if var_101_2[arg_101_1] then
		return (to_n(var_101_2[arg_101_1]) or 0) ~= (to_n(var_101_0) or 0)
	else
		return true
	end
end

function CoopMission.updateSupplyPassRedDot(arg_102_0, arg_102_1)
	local var_102_0 = Account:getCoopMissionSchedule().season_number
	local var_102_1 = SAVE:getKeep("coop_season_supply_pass_reddot", "")
	local var_102_2 = json.decode(var_102_1) or {}
	
	var_102_2[arg_102_1] = var_102_0
	
	SAVE:setKeep("coop_season_supply_pass_reddot", json.encode(var_102_2))
end

function CoopMission.onLeaveMode_supply(arg_103_0, arg_103_1)
	arg_103_0:controlHomeElements({
		is_visible = true
	})
	TopBarNew:checkhelpbuttonID("infoexped")
	UIAction:Add(SEQ(LOG(SPAWN(MOVE_TO(400, arg_103_0.vars.home_portrait_x, arg_103_0.vars.home_portrait_y)))), arg_103_0.vars.wnd:getChildByName("n_portrait"), "block")
	UIAction:Add(SEQ(LOG(SPAWN(MOVE_TO(400, arg_103_0.vars.home_balloon_x + arg_103_0.vars.home_delta_x - arg_103_0.vars.home_delta_x, arg_103_0.vars.wnd:getChildByName("n_balloon"):getPositionY())))), arg_103_0.vars.wnd:getChildByName("n_balloon"), "block")
	UIAction:Add(SEQ(SPAWN(LOG(FADE_OUT(140, true)), CALL(function()
		arg_103_0.vars.wnd._supply_wnd:setEnabled(false)
	end))), arg_103_0.vars.wnd._supply_wnd, "block")
end

function CoopMission.controlHomeElements(arg_105_0, arg_105_1)
	if not get_cocos_refid(arg_105_0.vars.wnd) then
		return 
	end
	
	local var_105_0 = arg_105_1.is_visible == true and FADE_IN or FADE_OUT
	
	if arg_105_1.is_visible ~= true or not FADE_OUT then
		local var_105_1 = FADE_IN
	end
	
	arg_105_0:updateHomeBossBtn()
	
	local var_105_2 = arg_105_0.vars.wnd:getChildByName("n_home")
	
	if get_cocos_refid(var_105_2) then
		local var_105_3 = var_105_2:getChildByName("n_boss1"):getOpacity()
		
		if arg_105_1.is_visible == true and var_105_3 ~= 255 or arg_105_1.is_visible == false and var_105_3 ~= 0 then
			UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("n_boss1"), "block")
			UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("n_boss2"), "block")
			UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("n_boss3"), "block")
			UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("n_time_info"), "block")
			UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("btn_pass"), "block")
			
			if not ContentDisable:byAlias("expedition_guide") and IS_PUBLISHER_STOVE then
				UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("btn_discussion"), "block")
			else
				if_set_visible(var_105_2, "btn_discussion", false)
			end
			
			UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("btn_get"), "block")
			
			if Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EXPEDITION_POINT) then
				UIAction:Add(LOG(var_105_0(150)), var_105_2:getChildByName("n_event"), "block")
			end
		end
	end
	
	UIAction:Add(SEQ(LOG(var_105_0(150))), arg_105_0.vars.wnd:getChildByName("n_map_title"), "block")
	arg_105_0.vars.wnd:getChildByName("n_home"):setEnabled(arg_105_1.is_visible)
	
	if arg_105_0.vars.mode == "select" then
		local var_105_4 = arg_105_0.vars.wnd:getChildByName("n_portrait"):getOpacity()
		
		if arg_105_1.is_visible == true and var_105_4 ~= 255 or arg_105_1.is_visible == false and var_105_4 ~= 0 then
			UIAction:Add(SEQ(LOG(var_105_0(150))), arg_105_0.vars.wnd:getChildByName("n_portrait"), "block")
			UIAction:Add(SEQ(LOG(var_105_0(150))), arg_105_0.vars.wnd:getChildByName("n_balloon"), "block")
		end
	end
	
	local var_105_5 = arg_105_0.vars.wnd:getChildByName("n_npc")
	
	if arg_105_0.vars.mode == "supply" and get_cocos_refid(var_105_5) then
		UIAction:Add(LOG(OPACITY(150, 0, 0.4)), var_105_5:getChildByName("_grow_pass"), "block")
		UIAction:Add(LOG(OPACITY(150, 0.4, 0)), var_105_5:getChildByName("_grow_home"), "block")
	elseif get_cocos_refid(var_105_5) then
		UIAction:Add(LOG(OPACITY(150, 0.4, 0)), var_105_5:getChildByName("_grow_pass"), "block")
		UIAction:Add(LOG(OPACITY(150, 0, 0.4)), var_105_5:getChildByName("_grow_home"), "block")
	end
end

function CoopMission.closeHandPopup(arg_106_0, arg_106_1)
	if not get_cocos_refid(arg_106_0.vars.wnd) or not get_cocos_refid(arg_106_0.vars.wnd._hand) then
		return 
	end
	
	local var_106_0 = arg_106_1 and 0 or 100
	
	UIAction:Add(SEQ(LOG(FADE_OUT(var_106_0)), REMOVE()), arg_106_0.vars.wnd._hand, "block")
	
	local var_106_1 = table.count(Account:getCoopMissionData().ticket_list)
	
	if_set_visible(arg_106_0.vars.wnd:getChildByName("btn_get"), "noti_count", var_106_1 > 0)
	if_set(arg_106_0.vars.wnd:getChildByName("btn_get"), "count_mission", var_106_1)
	Scheduler:removeByName("coop.hand_update")
	BackButtonManager:pop("hand_popup")
end

function CoopMission.openHandPopup(arg_107_0)
	if not get_cocos_refid(arg_107_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_107_0.vars.wnd, "n_select", false)
	
	arg_107_0.vars.wnd._hand = Dialog:open("wnd/expedition_get_list", arg_107_0, {
		back_func = function()
			CoopMission:closeHandPopup()
		end
	})
	
	arg_107_0.vars.wnd._hand:setOpacity(0)
	arg_107_0:updateHandPopupTime()
	arg_107_0:initHandMissionListView()
	arg_107_0:updateTabCount()
	UIAction:Add(SEQ(LOG(FADE_IN(200))), arg_107_0.vars.wnd._hand, "block")
	Scheduler:removeByName("coop.hand_update")
	
	Scheduler:addSlow(arg_107_0.vars.wnd._hand, arg_107_0.onHandPopupUpdate, arg_107_0).name = "coop.hand_update"
	
	SceneManager:getRunningPopupScene():addChild(arg_107_0.vars.wnd._hand)
end

function CoopMission.updateTabCount(arg_109_0)
	if not get_cocos_refid(arg_109_0.vars.wnd) then
		return 
	end
	
	arg_109_0:updateData()
	
	local var_109_0 = Account:getCoopListByType(arg_109_0.vars.tab)
	
	if arg_109_0.vars.tab == "share" then
		if_set(arg_109_0.vars.wnd:getChildByName("n_no_record"), "label", T("expedition_current_shared_empty"))
	elseif arg_109_0.vars.tab == "hand" then
		if_set(arg_109_0.vars.wnd:getChildByName("n_no_record"), "label", T("expedition_current_ing_empty"))
	elseif arg_109_0.vars.tab == "open" then
		if_set(arg_109_0.vars.wnd:getChildByName("n_no_record"), "label", T("expedition_current_shared_del_cant"))
	end
	
	if arg_109_0.vars.tab ~= "open" then
		local var_109_1 = CoopUtil:getBossRoomCount(arg_109_0.vars.currentBossBtn, {
			type = arg_109_0.vars.tab
		}) <= 0
		
		if_set_visible(arg_109_0.vars.wnd, "n_no_record", var_109_1)
		if_set(arg_109_0.vars.wnd:getChildByName("n_no_record"), "count_mission", BattleRepeat:get_ticketCount())
		if_set_visible(arg_109_0.vars.wnd:getChildByName("n_no_record"), "noti_count", var_109_1 and BattleRepeat:get_ticketCount() > 0)
		if_set_visible(arg_109_0.vars.wnd, "n_regulate", false)
		
		local var_109_2
		
		for iter_109_0, iter_109_1 in pairs(var_109_0 or {}) do
			if iter_109_1.boss_code == arg_109_0.vars.currentBossBtn then
				var_109_2 = iter_109_1
				
				break
			end
		end
		
		local var_109_3 = table.count(var_109_0) > 0 and var_109_2 ~= nil
		
		if_set_visible(arg_109_0.vars.wnd, "ListView", var_109_3)
		
		local var_109_4 = {}
		local var_109_5
		local var_109_6 = arg_109_0.vars.wnd:getChildByName("tab1")
		local var_109_7 = arg_109_0.vars.wnd:getChildByName("tab2")
		
		if_set(arg_109_0.vars.wnd:getChildByName("n_select"):getChildByName("RIGHT"), "t_count", tostring(CoopUtil:getBossRoomCount(arg_109_0.vars.currentBossBtn, {
			type = arg_109_0.vars.tab
		}) .. "/" .. "20"))
		if_set(var_109_6, "txt", T("expedition_current_shared") .. "(" .. CoopUtil:getBossRoomCount(arg_109_0.vars.currentBossBtn, {
			type = "share"
		}) .. ")")
		if_set(var_109_7, "txt", T("expedition_current_ing") .. "(" .. CoopUtil:getBossRoomCount(arg_109_0.vars.currentBossBtn, {
			type = "hand"
		}) .. ")")
	end
end

CoopSort = {}

function CoopSort.HighDifficulty(arg_110_0, arg_110_1)
	local var_110_0 = arg_110_0.boss_info or arg_110_0
	local var_110_1 = arg_110_1.boss_info or arg_110_1
	
	return var_110_0.difficulty < var_110_1.difficulty
end

function CoopSort.Hp(arg_111_0, arg_111_1)
	local var_111_0 = arg_111_0.boss_info or arg_111_0
	local var_111_1 = arg_111_1.boss_info or arg_111_1
	
	return var_111_0.last_hp < var_111_1.last_hp
end

function CoopSort.LeftTime(arg_112_0, arg_112_1)
	local var_112_0 = arg_112_0.boss_info or arg_112_0
	local var_112_1 = arg_112_1.boss_info or arg_112_1
	local var_112_2 = os.time()
	
	return var_112_0.expire_tm - var_112_2 < var_112_1.expire_tm - var_112_2
end

function CoopMission.updateSorter(arg_113_0)
	if arg_113_0.vars.sorter and get_cocos_refid(arg_113_0.vars.sorter.vars.wnd) then
		arg_113_0.vars.sorter.vars.wnd:removeFromParent()
		
		arg_113_0.vars.sorter = nil
	end
	
	arg_113_0.vars.sorter = Sorter:create(arg_113_0.vars.wnd:getChildByName("n_sorting"))
	
	arg_113_0.vars.sorter:setSorter({
		default_sort_index = arg_113_0.vars.sort_index or 1,
		menus = {
			{
				name = T("expedition_sort_level"),
				func = CoopSort.HighDifficulty
			},
			{
				name = T("expedition_sort_hp"),
				func = CoopSort.Hp
			},
			{
				name = T("expedition_sort_timeleft"),
				func = CoopSort.LeftTime
			}
		},
		callback_sort = function(arg_114_0, arg_114_1)
			arg_113_0.vars.sort_index = arg_114_1
			
			local var_114_0 = arg_113_0.vars.sorter:getSortedList()
			
			for iter_114_0, iter_114_1 in pairs(var_114_0) do
				local var_114_1 = iter_114_1.boss_info or iter_114_1
				
				if var_114_1.last_hp > 0 and var_114_1.expire_tm < os.time() then
					table.remove(var_114_0, iter_114_0)
					table.insert(var_114_0, 1, iter_114_1)
				end
			end
			
			for iter_114_2, iter_114_3 in pairs(var_114_0) do
				local var_114_2 = iter_114_3.boss_info or iter_114_3
				
				if var_114_2.last_hp <= 0 and var_114_2.clear_tm ~= nil then
					table.remove(var_114_0, iter_114_2)
					table.insert(var_114_0, 1, iter_114_3)
				end
			end
			
			arg_113_0.vars.missionList:setDataSource(var_114_0)
		end
	})
	arg_113_0.vars.sorter:setItems(arg_113_0.vars.mission_list)
	arg_113_0.vars.sorter:sort()
end

function CoopMission.updateValidList(arg_115_0)
	local var_115_0 = Account:getCoopMissionData()
	
	var_115_0.invite_list = CoopUtil:getValidList(var_115_0.invite_list)
	var_115_0.my_lists = CoopUtil:getValidList(var_115_0.my_lists)
	
	Account:setCoopMissionData(var_115_0)
end

function CoopMission.updateHandPopupTime(arg_116_0)
	local var_116_0 = Account:getCoopMissionSchedule().end_time - os.time()
	local var_116_1 = math.floor(var_116_0 / 86400)
	local var_116_2 = math.floor(var_116_0 / 3600)
	local var_116_3 = math.floor(var_116_0 / 60)
	
	if var_116_1 > 0 then
		var_116_0 = T("remain_day", {
			day = var_116_1
		})
	elseif var_116_1 <= 0 and var_116_2 > 0 then
		var_116_0 = T("remain_hour", {
			hour = var_116_2
		})
	elseif var_116_2 <= 0 and var_116_3 > 0 then
		var_116_0 = T("remain_min", {
			min = var_116_3
		})
	else
		var_116_0 = T("remain_sec", {
			sec = var_116_0
		})
	end
	
	if_set(arg_116_0.vars.wnd._hand, "t_initialization_title", T("expedition_season_off_time", {
		time = " " .. var_116_0
	}))
end

function CoopMission.onHandPopupUpdate(arg_117_0)
	if arg_117_0.vars and arg_117_0.vars.wnd and get_cocos_refid(arg_117_0.vars.wnd._hand) then
		arg_117_0:updateHandPopupTime()
	end
end

function CoopMission.onUpdate(arg_118_0)
	if arg_118_0:getMode() == "select" then
		arg_118_0:updateValidList()
		arg_118_0.vars.missionList:refresh()
	end
end

function CoopMission.onLightUpdate(arg_119_0)
	if arg_119_0:getMode() == "select" then
		if arg_119_0.vars.tab == "share" then
			local var_119_0 = Account:getCoopMissionData()
			local var_119_1 = table.count(var_119_0.invite_list)
			
			var_119_0.invite_list = CoopUtil:getValidList(var_119_0.invite_list)
			
			if var_119_1 ~= table.count(var_119_0.invite_list) then
				local var_119_2 = var_119_0.invite_list
				local var_119_3 = {}
				
				for iter_119_0, iter_119_1 in pairs(var_119_2) do
					if (iter_119_1.boss_info or iter_119_1).boss_code == arg_119_0.vars.currentBossBtn then
						table.insert(var_119_3, iter_119_1)
					end
				end
				
				arg_119_0.vars.mission_list = var_119_3
				
				arg_119_0:updateTabCount()
				
				if arg_119_0.vars.sorter then
					arg_119_0.vars.sorter:setItems(arg_119_0.vars.mission_list)
					arg_119_0.vars.sorter:sort()
				end
				
				arg_119_0.vars.missionList:setDataSource(arg_119_0.vars.sorter:getSortedList())
			end
		elseif arg_119_0.vars.tab == "open" and arg_119_0.vars.open_sub_tab then
			local var_119_4 = (Account:getCoopMissionData().open_lists or {})[arg_119_0.vars.open_sub_tab]
			
			if var_119_4 then
				local var_119_5 = table.count(var_119_4)
				local var_119_6 = CoopUtil:getValidList(var_119_4, {
					is_open_list = true
				})
				
				if var_119_5 ~= table.count(var_119_6) then
					arg_119_0:updateOpenListData()
					arg_119_0:updateOpenList()
				end
			end
		end
		
		arg_119_0.vars.missionList:lightRefresh()
	end
end

function CoopMission.onEnterMode_select(arg_120_0, arg_120_1, arg_120_2)
	if arg_120_0.vars.mode ~= "select" then
		return 
	end
	
	arg_120_1 = arg_120_1 or {}
	
	if get_cocos_refid(arg_120_0.vars.wnd) then
		arg_120_0.vars.wnd:setVisible(true)
		
		local var_120_0 = tonumber(Account:getCoopMissionData().season_data[arg_120_1.data.data.id].point)
		local var_120_1 = tonumber(CoopUtil:getMaxRewardPoint(arg_120_1.data.data.supply_group_id))
		local var_120_2 = CoopUtil:getFormatIntComma(math.min(var_120_0, var_120_1)) .. "/" .. CoopUtil:getFormatIntComma(var_120_1)
		
		if_set_visible(arg_120_0.vars.wnd, "txt_point", false)
		if_set_visible(arg_120_0.vars.wnd, "txt_point_title", false)
		if_set(arg_120_0.vars.wnd, "txt_point", var_120_2)
		if_set(arg_120_0.vars.wnd, "txt_point_title", T("expedition_my_point2", {
			boss = T(arg_120_1.data.data.character_id)
		}))
		
		local var_120_3 = arg_120_0.vars.wnd:getChildByName("txt_point_title")
		
		if_set_visible(arg_120_0.vars.wnd, "txt_point", true)
		if_set_visible(arg_120_0.vars.wnd, "txt_point_title", true)
		if_set_visible(arg_120_0.vars.wnd:getChildByName("btn_go_shared"), "noti_icon", table.count(Account:getCoopMissionData().my_lists) > 1 or table.count(Account:getCoopMissionData().invite_list) > 1)
		
		local var_120_4 = arg_120_0.vars.wnd:findChildByName("n_select"):findChildByName("RIGHT")
		local var_120_5 = var_120_4:getPositionX()
		
		if not var_120_4.origin_pos then
			var_120_4.origin_pos = var_120_5
		end
		
		arg_120_0:updateTabCount()
		var_120_4:setPositionX(1000)
		UIAction:Add(LOG(MOVE_TO(250, var_120_4.origin_pos)), var_120_4, "block")
		if_set_visible(arg_120_0.vars.wnd, "n_select", true)
		arg_120_0:controlHomeElements({
			is_visible = false
		})
		
		arg_120_0.vars.origin_bg_pos_x = DESIGN_WIDTH / 2
		arg_120_0.vars.origin_bg_pos_y = DESIGN_HEIGHT / 2
		
		local var_120_6 = string.sub(CoopMission.vars.boss_infos[CoopMission.vars.currentBossBtn].node:getParent():getName(), 7, -1)
		local var_120_7 = 0
		local var_120_8 = 0
		
		if var_120_6 == "1" then
			var_120_7 = 900
			var_120_8 = 0
		elseif var_120_6 == "2" then
			var_120_7 = -300
			var_120_8 = -200
		elseif var_120_6 == "3" then
			var_120_7 = -300
			var_120_8 = 500
		end
		
		EffectManager:Play({
			fn = "stagechange_cloud.cfx",
			delay = 0,
			pivot_z = 99998,
			layer = arg_120_0.vars.wnd:getChildByName("n_bg"),
			pivot_x = VIEW_WIDTH / 2 + 90,
			pivot_y = VIEW_HEIGHT / 2
		})
		Action:Add(SPAWN(MOVE(500, arg_120_0.vars.origin_bg_pos_x, arg_120_0.vars.origin_bg_pos_y, var_120_7, var_120_8), SCALE(500, 1, 3.5)), arg_120_0.vars.wnd:getChildByName("n_bg"))
		
		if arg_120_1.data then
			local var_120_9 = arg_120_0.vars.wnd:findChildByName("n_boss_select")
			
			if_set_visible(arg_120_0.vars.wnd, "n_boss_select", true)
			
			local var_120_10, var_120_11, var_120_12 = DB("character", arg_120_1.data.data.character_id, {
				"ch_attribute",
				"name",
				"story"
			})
			
			if_set(var_120_9, "t_name", T(var_120_11))
			if_set(var_120_9, "t_disc", T(var_120_12))
			if_set_sprite(var_120_9, "boss", "face/" .. arg_120_1.data.data.image .. ".png")
			if_set_sprite(var_120_9, "icon", "img/cm_icon_pro" .. var_120_10 .. ".png")
			var_120_9:setOpacity(0)
			UIAction:Add(FADE_IN(350), var_120_9, "block")
		else
			if_set_visible(arg_120_0.vars.wnd, "n_boss_select", false)
		end
	end
	
	arg_120_0:selectTab(arg_120_1.tab or "share")
	Scheduler:removeByName("coop.list_update")
	Scheduler:removeByName("coop.light_list_update")
	
	Scheduler:addSlow(arg_120_0.vars.wnd, arg_120_0.onLightUpdate, arg_120_0).name = "coop.light_list_update"
	Scheduler:addInterval(arg_120_0.vars.wnd, 10000, arg_120_0.onUpdate, arg_120_0).name = "coop.list_update"
	
	if arg_120_2 == "result" then
		arg_120_0:refreshMissionList("hand")
	end
	
	TutorialGuide:procGuide("expedition_join")
end

function CoopMission.onLeaveMode_select(arg_121_0, arg_121_1)
	if arg_121_1 ~= "ready" then
		arg_121_0:controlHomeElements({
			is_visible = true
		})
	end
	
	Scheduler:removeByName("coop.list_update")
	
	local var_121_0 = arg_121_0.vars.wnd:findChildByName("n_select")
	local var_121_1 = arg_121_0.vars.wnd:getChildByName("n_boss_select")
	local var_121_2 = var_121_0:findChildByName("RIGHT")
	
	UIAction:Add(LOG(MOVE_TO(250, 1000)), var_121_2, "block")
	UIAction:Add(LOG(FADE_OUT(250)), var_121_1, "block")
	UIAction:Add(SEQ(DELAY(250), SHOW(false)), var_121_0, "block")
	
	local var_121_3 = arg_121_0.vars.wnd:getChildByName("n_bg"):getPositionX()
	local var_121_4 = arg_121_0.vars.wnd:getChildByName("n_bg"):getPositionY()
	
	arg_121_0.vars.mission_list = nil
	
	if not arg_121_0.vars.n_btn_normal.toggle_del then
		arg_121_0:toggleDelBtn()
	end
	
	EffectManager:Play({
		fn = "stagechange_cloud.cfx",
		delay = 0,
		pivot_z = 99998,
		layer = arg_121_0.vars.wnd:getChildByName("n_bg"),
		pivot_x = VIEW_WIDTH / 2 + 90,
		pivot_y = VIEW_HEIGHT / 2
	})
	UIAction:Add(LOG(SPAWN(MOVE(250, var_121_3, var_121_4, arg_121_0.vars.origin_bg_pos_x, arg_121_0.vars.origin_bg_pos_y), SCALE(250, 3.5, 1))), arg_121_0.vars.wnd:getChildByName("n_bg"), "block")
end

function CoopMission.onEnterMode_ready(arg_122_0, arg_122_1)
	if arg_122_0.vars.ready and arg_122_0.vars.ready:isValid() then
		Log.e("ERROR : ALREADY READY layer EXIST AND VALID.")
	end
	
	if get_cocos_refid(arg_122_0.vars.wnd) then
		arg_122_0.vars.wnd:setVisible(false)
	end
	
	arg_122_0.vars.ready = CoopReady(arg_122_1)
	
	arg_122_0.vars.ready:show(arg_122_0.vars.root_layer)
	query("coop_ready_enter", {
		boss_id = arg_122_1.boss_id
	})
end

function CoopMission.onLeaveMode_home(arg_123_0)
	arg_123_0:controlHomeElements({
		is_visible = false
	})
end

function CoopMission.onLeaveMode_ready(arg_124_0, arg_124_1)
	local var_124_0 = false
	
	if arg_124_1 == "home" then
		local var_124_1 = arg_124_0.vars.ready:getBossInfo()
		
		arg_124_0.vars.currentBossBtn = var_124_1.boss_code
		
		arg_124_0:reqSetMode("select")
		
		if not var_124_0 then
			query("coop_my_with_invited_list", {
				boss_code = arg_124_0.vars.boss_infos[var_124_1.boss_code].data.id
			})
			
			var_124_0 = true
		end
		
		if arg_124_0.vars.scene_state_tab == "hand" then
			arg_124_0:justUpdateInvitedList()
		end
	end
	
	if arg_124_0.vars.coop_sharing and arg_124_0.vars.coop_sharing:isValid() then
		arg_124_0.vars.coop_sharing:destroy()
		
		arg_124_0.vars.coop_sharing = nil
	end
	
	if arg_124_0.vars.ready then
		if UnitMain:isValid() then
			UnitMain:destroy()
			BackButtonManager:pop("TopBarNew." .. T("hero"))
		end
		
		if BattleReady:isShow() then
			BattleReady:closeCoopWarningMsgBox()
			BattleReady:onButtonClose()
			BackButtonManager:pop("TopBarNew." .. T("battle_ready"))
			
			local var_124_2 = Dialog:findMsgBox("expedition_ready_warning")
			
			if get_cocos_refid(var_124_2) then
				Dialog:msgBoxUIHandler(var_124_2, "btn_cancel")
			end
		end
		
		arg_124_0.vars.exit_reason = arg_124_0.vars.ready:getExitReason()
		
		local var_124_3 = arg_124_0.vars.ready:getBossInfo()
		
		if arg_124_0.vars.exit_reason and var_124_3 then
			arg_124_0.vars.coop_info.invite_list[tostring(var_124_3.boss_id)] = nil
			
			if arg_124_0.vars.exit_reason == "boss_dead" and arg_124_0.vars.coop_info.my_lists[tostring(var_124_3.boss_id)] then
				CoopUtil:getBossInfo(arg_124_0.vars.coop_info.my_lists[tostring(var_124_3.boss_id)]).clear_tm = os.time()
			end
		end
		
		if arg_124_0.vars.exit_reason and arg_124_0.vars.tab == "hand" and not var_124_0 then
			arg_124_0:updateData()
			query("coop_my_list", {
				boss_code = arg_124_0.vars.boss_infos[arg_124_0.vars.currentBossBtn].data.id
			})
			
			var_124_0 = true
		elseif arg_124_0.vars.exit_reason and arg_124_0.vars.tab == "open" and not var_124_0 then
			arg_124_0:refreshOpenList(true)
			
			var_124_0 = true
		elseif arg_124_0.vars.exit_reason and not var_124_0 then
			query("coop_invited_list", {
				boss_code = arg_124_0.vars.boss_infos[arg_124_0.vars.currentBossBtn].data.id
			})
			
			local var_124_4 = true
		end
		
		arg_124_0.vars.ready:destroy()
	end
	
	arg_124_0.vars.ready = nil
end

function CoopMission.onEnterMode_result(arg_125_0, arg_125_1)
	if arg_125_0.vars.result then
		Log.e(" ERROR : ALREADY RESULT layer EXIST AND VALID. ")
	end
	
	arg_125_0.vars.result = CoopResult(arg_125_1)
	
	arg_125_0.vars.result:onShow(arg_125_0.vars.root_layer)
	query("coop_result", {
		boss_id = arg_125_1.boss_id
	})
end

function CoopMission.onLeaveMode_result(arg_126_0)
	if not arg_126_0.vars.result then
		Log.e(" ERROR : RESULT WAS NOT EXISTS  ")
		
		return 
	end
	
	local var_126_0 = arg_126_0.vars.result:getBossInfo().boss_id
	
	if arg_126_0.vars.coop_info.my_lists[tostring(var_126_0)] then
		arg_126_0.vars.coop_info.my_lists[tostring(var_126_0)] = nil
	else
		Log.e("NOT EXIST CLEAR BOSS ON MY LISTS. INVALID!")
	end
	
	arg_126_0.vars.result:onRemove()
	
	arg_126_0.vars.result = nil
	
	TopBarNew:setVisible(true)
end

function CoopMission.getCurrentRoom(arg_127_0)
	if not arg_127_0.vars then
		return nil
	end
	
	return arg_127_0.vars.ready
end

function CoopMission.getUserList(arg_128_0)
	if arg_128_0.vars and arg_128_0.vars.ready and arg_128_0.vars.ready:isValid() then
		return arg_128_0.vars.ready:getUserList()
	end
end

function CoopMission.getRootLayer(arg_129_0)
	return arg_129_0.vars.root_layer
end

function CoopMission.destroy(arg_130_0)
	if not arg_130_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_130_0.vars.wnd) then
		arg_130_0.vars.wnd:removeFromParent()
	end
	
	if arg_130_0.vars then
		arg_130_0.vars = nil
	end
end

function CoopMission.onPushBackButton(arg_131_0, arg_131_1)
	if not arg_131_0.vars then
		return 
	end
	
	table.pop(arg_131_0.vars.mode_flow)
	
	if not table.empty(arg_131_0.vars.mode_flow) then
		local var_131_0 = arg_131_0.vars.mode_flow[#arg_131_0.vars.mode_flow]
		
		arg_131_0:setMode(var_131_0.mode, var_131_0.args, true, nil, arg_131_1)
		
		return 
	end
	
	if arg_131_0._last_enter_prev_scene == "DungeonList" then
		SceneManager:cancelReseveResetSceneFlow()
		SceneManager:nextScene("DungeonList", {
			mode = "Expedition"
		})
	else
		SceneManager:nextScene("lobby")
	end
end

function CoopMission.responseExpedition(arg_132_0, arg_132_1)
	if not arg_132_0.vars or not arg_132_0.vars.ready then
		return 
	end
	
	arg_132_0.vars.ready:responseExpedition(arg_132_1)
end

function CoopMission.onInvitedList(arg_133_0, arg_133_1)
	if not arg_133_1.invites then
		return 
	end
	
	for iter_133_0, iter_133_1 in pairs(arg_133_1.invites) do
		arg_133_0.vars.coop_info.invite_list[iter_133_0] = iter_133_1
	end
	
	for iter_133_2, iter_133_3 in pairs(arg_133_0.vars.coop_info.invite_list) do
		if iter_133_3.boss_code == arg_133_0.vars.currentBossBtn and not arg_133_1.invites[iter_133_2] then
			arg_133_0.vars.coop_info.invite_list[iter_133_2] = nil
		end
	end
	
	local var_133_0 = Account:getCoopMissionData()
	
	var_133_0.invite_list = arg_133_0.vars.coop_info.invite_list
	
	local var_133_1 = os.time()
	
	for iter_133_4, iter_133_5 in pairs(var_133_0.invite_list) do
		if CoopUtil:isExpired(iter_133_5.expire_tm, var_133_1) then
			var_133_0.invite_list[iter_133_4] = nil
		end
		
		local var_133_2 = iter_133_5.boss_info ~= nil and iter_133_5.boss_info or iter_133_5
		
		if (CoopUtil:getLevelData(var_133_2).party_max or 6) <= var_133_2.user_count then
			var_133_0.invite_list[iter_133_4] = nil
		end
		
		if var_133_2.clear_tm then
			var_133_0.invite_list[iter_133_4] = nil
		end
	end
	
	Account:setCoopMissionData(var_133_0)
	
	arg_133_0.vars.coop_info.invite_list = var_133_0.invite_list
	
	arg_133_0:updateData(var_133_0)
end

function CoopMission.refreshMissionList(arg_134_0, arg_134_1)
	local var_134_0 = {
		"share",
		"hand",
		"open"
	}
	local var_134_1 = arg_134_0.vars.wnd:getChildByName("n_tab")
	
	for iter_134_0, iter_134_1 in pairs(var_134_0) do
		local var_134_2 = var_134_1:getChildByName("tab" .. iter_134_0)
		
		if_set_visible(var_134_2, "bg", iter_134_1 == arg_134_1)
	end
	
	if not arg_134_0.vars.missionList then
		arg_134_0:initListView()
	end
	
	local var_134_3 = Account:getCoopMissionData()
	
	var_134_3.invite_list = CoopUtil:getValidList(var_134_3.invite_list)
	var_134_3.my_lists = CoopUtil:getValidList(var_134_3.my_lists)
	
	Account:setCoopMissionData(var_134_3)
	
	if not Account:getCoopMissionData() then
		local var_134_4 = {}
	end
	
	arg_134_0.vars.missionList:setDataSource({})
	
	local var_134_5 = Account:getCoopListByType(arg_134_1)
	local var_134_6 = {}
	local var_134_7 = arg_134_0:getAvailableRoom(arg_134_1, var_134_5)
	local var_134_8 = {}
	
	for iter_134_2, iter_134_3 in pairs(var_134_7) do
		if (iter_134_3.boss_info or iter_134_3).boss_code == arg_134_0.vars.currentBossBtn then
			table.insert(var_134_8, iter_134_3)
		end
	end
	
	arg_134_0.vars.mission_list = var_134_8
	
	arg_134_0:selectTab(arg_134_1)
	arg_134_0:updateSorter()
	arg_134_0:updateTabCount()
	arg_134_0.vars.missionList:setDataSource(arg_134_0.vars.sorter:getSortedList())
	if_set(arg_134_0.vars.wnd:getChildByName("n_select"):getChildByName("RIGHT"), "t_count", tostring(#arg_134_0.vars.missionList.vars.dataSource) .. "/" .. "20")
end

function CoopMission.initDelBtn(arg_135_0, arg_135_1)
	if not get_cocos_refid(arg_135_0.vars.wnd) then
		return 
	end
	
	local var_135_0 = arg_135_0.vars.wnd:getChildByName("n_btn_normal_move")
	local var_135_1 = arg_135_0.vars.wnd:getChildByName("n_btn_normal")
	local var_135_2 = arg_135_0.vars.wnd:getChildByName("n_btn_del")
	
	arg_135_0.vars.n_btn_normal = arg_135_0.vars.n_btn_normal or {}
	arg_135_0.vars.n_btn_normal.origin_x = arg_135_0.vars.n_btn_normal.origin_x or var_135_1:getPositionX()
	arg_135_0.vars.n_btn_normal.origin_y = arg_135_0.vars.n_btn_normal.origin_y or var_135_1:getPositionY()
	arg_135_0.vars.n_btn_normal.toggle_del = arg_135_0.vars.n_btn_normal.toggle_del or true
	
	local var_135_3 = var_135_2:getChildByName("btn_del_on")
	local var_135_4 = var_135_2:getChildByName("btn_del_off")
	
	if arg_135_1 == "share" then
		var_135_2:getChildByName("btn_del_on"):setTouchEnabled(true)
		var_135_4:setTouchEnabled(true)
		UIAction:Add(LOG(MOVE_TO(100, var_135_0:getPositionX(), var_135_0:getPositionY())), var_135_1, "block")
		UIAction:Add(SEQ(SHOW(true), FADE_IN(100)), var_135_3, "block")
		var_135_4:setVisible(false)
		var_135_4:setOpacity(0)
		
		arg_135_0.vars.n_btn_normal.toggle_del = true
	else
		if var_135_1:getPositionX() ~= arg_135_0.vars.n_btn_normal.origin_x then
			UIAction:Add(LOG(MOVE_TO(100, arg_135_0.vars.n_btn_normal.origin_x, arg_135_0.vars.n_btn_normal.origin_y)), var_135_1, "block")
		end
		
		if not arg_135_0.vars.n_btn_normal.toggle_del then
			UIAction:Add(SEQ(FADE_OUT(100), SHOW(false)), var_135_4, "block")
		elseif var_135_4:isVisible() then
			UIAction:Add(SEQ(FADE_OUT(100), SHOW(false)), var_135_4, "block")
		end
		
		if var_135_3:isVisible() then
			UIAction:Add(SEQ(FADE_OUT(100), SHOW(false)), var_135_3, "block")
		end
		
		var_135_3:setTouchEnabled(false)
		var_135_4:setTouchEnabled(false)
	end
end

function CoopMission.toggleSortBtn(arg_136_0, arg_136_1)
	if arg_136_0.vars and arg_136_0.vars.sorter and get_cocos_refid(arg_136_0.vars.sorter.vars.wnd) then
		arg_136_0.vars.sorter.vars.wnd:setVisible(arg_136_1)
	end
end

function CoopMission.toggleDelBtn(arg_137_0)
	if not get_cocos_refid(arg_137_0.vars.wnd) then
		return 
	end
	
	if not arg_137_0:getMode() == "select" then
		return 
	end
	
	if table.count(arg_137_0.vars.mission_list or arg_137_0.vars.missionList.vars.dataSource) <= 0 then
		if not arg_137_0.vars.n_btn_normal.toggle_del then
			arg_137_0.vars.n_btn_normal.toggle_del = not arg_137_0.vars.n_btn_normal.toggle_del
			
			arg_137_0.vars.wnd:getChildByName("btn_del_on"):setVisible(arg_137_0.vars.n_btn_normal.toggle_del)
			if_set_opacity(arg_137_0.vars.wnd, "btn_del_on", arg_137_0.vars.n_btn_normal.toggle_del == true and 255 or 0)
			arg_137_0.vars.wnd:getChildByName("btn_del_off"):setVisible(not arg_137_0.vars.n_btn_normal.toggle_del)
			if_set_opacity(arg_137_0.vars.wnd, "btn_del_off", arg_137_0.vars.n_btn_normal.toggle_del == false and 255 or 0)
		end
		
		balloon_message(T("expedition_current_shared_del_cant"))
		
		return 
	end
	
	arg_137_0.vars.n_btn_normal.toggle_del = not arg_137_0.vars.n_btn_normal.toggle_del
	
	arg_137_0.vars.wnd:getChildByName("btn_del_on"):setVisible(arg_137_0.vars.n_btn_normal.toggle_del)
	if_set_opacity(arg_137_0.vars.wnd, "btn_del_on", arg_137_0.vars.n_btn_normal.toggle_del == true and 255 or 0)
	arg_137_0.vars.wnd:getChildByName("btn_del_off"):setVisible(not arg_137_0.vars.n_btn_normal.toggle_del)
	if_set_opacity(arg_137_0.vars.wnd, "btn_del_off", arg_137_0.vars.n_btn_normal.toggle_del == false and 255 or 0)
	arg_137_0.vars.missionList:refresh()
end

function CoopMission.selectTab(arg_138_0, arg_138_1)
	if arg_138_0:getMode() ~= "select" then
		return 
	end
	
	if arg_138_0.vars.tab == arg_138_1 then
		return 
	end
	
	local var_138_0
	
	if arg_138_1 == "share" then
		var_138_0 = "expedition_current_shared2"
	elseif arg_138_1 == "hand" then
		var_138_0 = "expedition_current_ing2"
	end
	
	local var_138_1 = arg_138_0.vars.wnd:getChildByName("n_count"):getChildByName("t_count_title")
	
	if_set(var_138_1, nil, T(var_138_0))
	
	arg_138_0.vars.tab = arg_138_1
	
	if_set_visible(arg_138_0.vars.wnd, "btn_go_shared", arg_138_0.vars.tab == "share")
	if_set_visible(arg_138_0.vars.wnd, "txt_bonus_info", arg_138_0.vars.tab == "share")
	arg_138_0:initDelBtn(arg_138_1)
	arg_138_0:refreshMissionList(arg_138_0.vars.tab)
	arg_138_0:currentModeUpdateArgs("tab", arg_138_1)
	arg_138_0:toggleSortBtn(arg_138_1 ~= "open")
	
	if arg_138_1 == "open" then
		local var_138_2 = SAVE:get("coop_open_tab." .. arg_138_0.vars.currentBossBtn, 3)
		
		arg_138_0:selectOpenSubTab(var_138_2)
	end
	
	if_set_visible(arg_138_0.vars.wnd, "n_level_tabs", arg_138_0.vars.tab == "open")
	if_set_visible(arg_138_0.vars.wnd, "n_count", arg_138_0.vars.tab ~= "open")
end

function CoopMission.readyOpenRoom(arg_139_0, arg_139_1)
	if not arg_139_1 then
		return 
	end
	
	CoopMission.vars.ready_args = arg_139_1
	
	query("coop_ready_enter", {
		boss_id = arg_139_1.boss_id
	})
end

function CoopMission.getOpenSubTab(arg_140_0)
	if not arg_140_0.vars or not arg_140_0.vars.open_sub_tab then
		return 
	end
	
	return arg_140_0.vars.open_sub_tab or 1
end

function CoopMission.refreshOpenList(arg_141_0, arg_141_1)
	if not arg_141_0.vars or arg_141_0.vars.tab ~= "open" or not arg_141_0.vars.open_sub_tab then
		return 
	end
	
	local var_141_0 = arg_141_0.vars.boss_infos[arg_141_0.vars.currentBossBtn].data.level_info[tostring(arg_141_0.vars.open_sub_tab)]
	
	if not CoopUtil:isUnlockOpenDifficulty(var_141_0.id) then
		return 
	end
	
	if arg_141_0.vars.is_exist_open_list and arg_141_0.vars.is_exist_open_list[arg_141_0.vars.open_sub_tab] then
		arg_141_0.vars.is_exist_open_list[arg_141_0.vars.open_sub_tab] = false
		
		arg_141_0:selectOpenSubTab(arg_141_0.vars.open_sub_tab)
	elseif arg_141_1 then
		arg_141_0:selectOpenSubTab(arg_141_0.vars.open_sub_tab)
	end
end

function CoopMission.getOpenSubTab(arg_142_0)
	if not arg_142_0.vars or not arg_142_0.vars.open_sub_tab then
		return 
	end
	
	return arg_142_0.vars.open_sub_tab
end

function CoopMission.selectOpenSubTab(arg_143_0, arg_143_1)
	if arg_143_0.vars.tab ~= "open" then
		return 
	end
	
	local var_143_0 = tonumber(arg_143_1) or 3
	
	arg_143_0.vars.open_sub_tab = var_143_0
	
	SAVE:set("coop_open_tab." .. arg_143_0.vars.currentBossBtn, var_143_0)
	
	if not arg_143_0.vars.is_exist_open_list then
		arg_143_0.vars.is_exist_open_list = {}
	end
	
	local var_143_1 = arg_143_0.vars.boss_infos[arg_143_0.vars.currentBossBtn].data.level_info[tostring(arg_143_0.vars.open_sub_tab)]
	
	if not CoopUtil:isUnlockOpenDifficulty(var_143_1.id) then
		Account:setOpenLists({}, arg_143_0.vars.open_sub_tab)
	elseif not arg_143_0.vars.is_exist_open_list[arg_143_0.vars.open_sub_tab] then
		arg_143_0.vars.is_exist_open_list[arg_143_0.vars.open_sub_tab] = true
		
		arg_143_0:updateSubTabUI()
		query("coop_open_boss_list", {
			boss_code = arg_143_0.vars.boss_infos[arg_143_0.vars.currentBossBtn].data.id,
			difficulty = arg_143_0.vars.open_sub_tab
		})
		
		return 
	end
	
	arg_143_0:updateOpenListData()
	arg_143_0:updateOpenList()
	arg_143_0:updateSubTabUI()
end

function CoopMission.updateOpenListData(arg_144_0)
	local var_144_0 = {}
	local var_144_1 = Account:getCoopListByType("open", arg_144_0.vars.open_sub_tab)
	
	if var_144_1 then
		local var_144_2 = CoopUtil:getValidList(var_144_1, {
			is_open_list = true
		}) or {}
		
		for iter_144_0, iter_144_1 in pairs(var_144_2) do
			if not var_144_0[iter_144_1.difficulty] then
				var_144_0[iter_144_1.difficulty] = {}
			end
			
			table.insert(var_144_0[iter_144_1.difficulty], table.shallow_clone(iter_144_1))
		end
	end
	
	arg_144_0.vars.cur_open_list = var_144_0[arg_144_0.vars.open_sub_tab] or {}
	
	table.sort(arg_144_0.vars.cur_open_list, function(arg_145_0, arg_145_1)
		if arg_145_0.last_hp ~= arg_145_1.last_hp then
			return arg_145_0.last_hp < arg_145_1.last_hp
		end
		
		if arg_145_0.user_count ~= arg_145_1.user_count then
			return arg_145_0.user_count > arg_145_1.user_count
		end
		
		if arg_145_0.expire_tm ~= arg_145_1.expire_tm then
			return arg_145_0.expire_tm < arg_145_1.expire_tm
		end
		
		return arg_145_0.user_id < arg_145_1.user_id
	end)
end

function CoopMission.updateOpenList(arg_146_0)
	local var_146_0 = arg_146_0.vars.boss_infos[arg_146_0.vars.currentBossBtn].data.level_info[tostring(arg_146_0.vars.open_sub_tab)]
	local var_146_1, var_146_2, var_146_3 = CoopUtil:isUnlockOpenDifficulty(var_146_0.id)
	local var_146_4 = table.empty(arg_146_0.vars.cur_open_list)
	local var_146_5 = arg_146_0.vars.wnd:getChildByName("n_regulate")
	
	if var_146_1 and (not var_146_4 or true) then
		if false then
		end
	elseif var_146_2 and var_146_3 then
		if_set(var_146_5, "txt_title", T(var_146_2))
		if_set(var_146_5, "txt_explain", T(var_146_3))
	end
	
	arg_146_0.vars.missionList:setDataSource(arg_146_0.vars.cur_open_list)
	
	local var_146_6 = arg_146_0.vars.wnd:getChildByName("n_no_record")
	
	if_set_visible(var_146_6, nil, var_146_4)
	if_set_visible(var_146_6, "n_info", var_146_4 and var_146_1)
	if_set_visible(var_146_5, nil, not var_146_1)
	
	if var_146_4 or not var_146_1 then
		local var_146_7 = table.count(Account:getCoopMissionData().ticket_list)
		local var_146_8 = arg_146_0.vars.wnd:getChildByName("btn_get")
		
		if_set_visible(arg_146_0.vars.wnd, "ListView", false)
		if_set_visible(var_146_6, "noti_count", var_146_7 > 0)
		if_set_visible(var_146_8, "noti_count", var_146_7 > 0)
		if_set(var_146_8, "count_mission", var_146_7)
	else
		if_set_visible(var_146_6, "noti_count", false)
		if_set_visible(arg_146_0.vars.wnd, "ListView", true)
	end
end

function CoopMission.updateSubTabUI(arg_147_0)
	if arg_147_0:getMode() ~= "select" or arg_147_0.vars.tab ~= "open" then
		return 
	end
	
	local var_147_0 = arg_147_0.vars.wnd:getChildByName("n_level_tabs")
	
	if get_cocos_refid(var_147_0) then
		for iter_147_0 = 1, 3 do
			if_set_visible(var_147_0:getChildByName("tab_lv" .. iter_147_0), "bg", iter_147_0 == arg_147_0.vars.open_sub_tab)
		end
	end
end

function CoopMission.isValid(arg_148_0)
	if not arg_148_0.vars then
		return false
	end
	
	return get_cocos_refid(arg_148_0.vars.wnd)
end

function CoopMission.getCurrentBossCode(arg_149_0)
	if not arg_149_0:isValid() then
		return nil
	end
	
	if arg_149_0:getMode() == "select" then
		return arg_149_0.vars.currentBossBtn
	end
	
	if not arg_149_0.vars.ready or not arg_149_0.vars.ready:isValid() then
		return nil
	end
	
	local var_149_0 = arg_149_0.vars.ready:getBossInfo()
	
	return (var_149_0.boss_info ~= nil and var_149_0.boss_info or var_149_0).boss_code
end

function CoopMission.getCurrentTab(arg_150_0)
	return arg_150_0.vars.tab
end

function CoopMission.onEnterFormation(arg_151_0)
	if not arg_151_0.vars.ready then
		return 
	end
	
	arg_151_0.vars.ready:enterFormation()
end

function CoopMission.onEnterLimit(arg_152_0)
	if not arg_152_0.vars.ready then
		return 
	end
	
	arg_152_0.vars.ready:showLimitInfo(false)
end

function CoopMission.onSharing(arg_153_0)
	if not arg_153_0.vars.ready then
		return 
	end
	
	local var_153_0 = arg_153_0.vars.ready:getStartArgs()
	local var_153_1 = arg_153_0.vars.ready:getBossInfo()
	local var_153_2 = CoopUtil:getLevelData(var_153_1)
	
	if not var_153_1 or not var_153_0 then
		Log.e(" NO BOSS INFO!!! ")
		
		return 
	end
	
	if var_153_1.user_count >= var_153_2.party_max then
		balloon_message_with_sound("expedition_party_call_full")
		
		return 
	end
	
	arg_153_0.vars.coop_sharing = CoopSharing({
		parent = SceneManager:getRunningPopupScene(),
		cache = arg_153_0.vars.ready:getCacheCoopSharedList(),
		boss_id = var_153_0.boss_id
	})
end

function CoopMission.onMsgGetCoopSharedList(arg_154_0, arg_154_1, arg_154_2)
	if not arg_154_0.vars.ready then
		Log.e("CACHE FAILED!!! ")
		
		return 
	end
	
	arg_154_0.vars.ready:cachingCoopSharedList(arg_154_1, arg_154_2)
end

function CoopMission.onUpdateCoopSharedList(arg_155_0, arg_155_1, arg_155_2)
	if not arg_155_0.vars.ready then
		Log.e("CACHE FAILED!!! ")
		
		return 
	end
	
	arg_155_0.vars.ready:updateCachedCoopSharedList(arg_155_1, arg_155_2)
end

function CoopMission.req_open_room(arg_156_0, arg_156_1)
	if not arg_156_0.vars or not arg_156_0.vars.ready then
		Log.e("CACHE FAILED!!! ")
		
		return 
	end
	
	arg_156_0.vars.ready:req_open_room()
end

function CoopMission.onStartBattle(arg_157_0, arg_157_1)
	local var_157_0 = arg_157_1 or {}
	
	if not arg_157_0:startBattle(var_157_0.enter_id, var_157_0) then
	end
end

function CoopMission.startBattle(arg_158_0, arg_158_1, arg_158_2)
	local var_158_0 = arg_158_2 or {}
	local var_158_1, var_158_2, var_158_3 = DB("level_enter", arg_158_1, {
		"type_enterpoint",
		"use_enterpoint",
		"type"
	})
	local var_158_4 = arg_158_0.vars.ready:getReplaceEnterPoint()
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		var_158_4 = 0
	end
	
	if arg_158_0.vars.ready:isFreeEnterPoint() then
		var_158_4 = 0
	end
	
	if to_n(var_158_4) > 0 then
		local var_158_5 = DB("item_token", var_158_1, "type")
		
		if var_158_4 > Account:getCurrency(var_158_5) then
			balloon_message_with_sound("battle_cant_getin")
			
			return false
		end
	end
	
	PreLoad:beforeReqBattle(arg_158_1)
	
	local var_158_6 = Account:saveTeamInfo(true)
	local var_158_7 = CoopMission:getCurrentBossCode()
	local var_158_8 = CoopUtil:getTeamIdx(var_158_7)
	local var_158_9 = Account:getCoopMissionSchedule().boss[var_158_7].sort
	local var_158_10 = {}
	local var_158_11
	
	if var_158_8 then
		var_158_11 = Account:getTeam(var_158_8)
		
		for iter_158_0 = 1, 4 do
			local var_158_12 = var_158_11[iter_158_0]
			
			if var_158_12 then
				table.insert(var_158_10, {
					c = var_158_12.db.code,
					s = c_check_db(var_158_12.db.code)
				})
			end
		end
	end
	
	add_local_push("DAILY_CONNECT_1", DAILY_CONNECT_1_PUSH_TIME)
	add_local_push("DAILY_CONNECT_3", DAILY_CONNECT_3_PUSH_TIME)
	
	local var_158_13 = Analytics:getDatas()
	local var_158_14 = {
		open = 1,
		hand = 0,
		share = 0
	}
	local var_158_15
	
	if arg_158_0.vars and arg_158_0.vars.ready and arg_158_0.vars.tab and (arg_158_0.vars.ready:getPlayCount() or 0) <= 0 then
		var_158_15 = var_158_14[arg_158_0.vars.tab]
	end
	
	local var_158_16 = var_158_0.boss_id
	local var_158_17 = BattleUtil:getPlayingEpisode() or {}
	
	query("coop_enter", {
		map = arg_158_1,
		team = var_158_8,
		update_team_info = var_158_6,
		boss_id = var_158_16,
		cheat_limit = DEBUG.DEBUG_NO_ENTER_LIMIT,
		join_type = var_158_15,
		coffee = array_to_json(var_158_10),
		play_time_logs = var_158_13,
		episode_log = json.encode(var_158_17)
	})
	
	return true
end

function CoopMission.isStartCoopCallTutorial(arg_159_0)
	if not arg_159_0.vars or not arg_159_0.vars.coop_info then
		return 
	end
	
	for iter_159_0, iter_159_1 in pairs(arg_159_0.vars.coop_info.invite_list) do
		return true
	end
	
	return false
end

function CoopMission.isStartCoopWantedTutorial(arg_160_0)
	if not arg_160_0.vars or not arg_160_0.vars.coop_info then
		return 
	end
	
	local var_160_0 = Account:getTicketList()
	
	if not var_160_0 then
		return false
	end
	
	for iter_160_0, iter_160_1 in pairs(var_160_0) do
		return true
	end
	
	return false
end

function CoopMission.isRewardReceivable(arg_161_0, arg_161_1)
	if not arg_161_0.vars or not arg_161_0.vars.supply_list then
		return 
	end
	
	arg_161_1 = arg_161_1 or "current"
	
	local var_161_0 = arg_161_1 == "current" and Account:getCoopSeasonData() or arg_161_0:getPreviousCoopInfo().season_data
	local var_161_1 = arg_161_0:getSupplyList(arg_161_1)
	
	if not var_161_0 or table.count(var_161_0) == 0 then
		return 
	end
	
	local var_161_2 = {}
	local var_161_3 = {}
	local var_161_4 = {}
	local var_161_5 = arg_161_1 == "current" and Account:getCoopMissionSchedule().season_number or arg_161_0:getPreviousCoopInfo().coop_mission_schedule.season_number
	
	for iter_161_0, iter_161_1 in pairs(var_161_0) do
		var_161_2[iter_161_0] = iter_161_1.reward_point
		var_161_3[iter_161_0] = iter_161_1.point
		var_161_4[iter_161_0] = iter_161_1.premium_reward_point
		var_161_5 = iter_161_1.season_no
	end
	
	for iter_161_2, iter_161_3 in pairs(var_161_1) do
		for iter_161_4, iter_161_5 in pairs(iter_161_3) do
			local var_161_6 = var_161_2[iter_161_4] or 0
			local var_161_7 = var_161_3[iter_161_4] or 0
			local var_161_8 = var_161_4[iter_161_4] or 0
			
			if iter_161_5.premium and iter_161_5.premium == "y" then
				if arg_161_0:isEnablePremiumPass(var_161_5) and var_161_8 < iter_161_5.point and var_161_7 >= iter_161_5.point then
					return true
				end
			elseif var_161_6 < iter_161_5.point and var_161_7 >= iter_161_5.point then
				return true
			end
		end
	end
	
	return false
end

function CoopMission._getFirstData()
	local var_162_0 = Account:getCoopMissionSchedule()
	
	for iter_162_0, iter_162_1 in pairs(var_162_0.boss) do
		if to_n(iter_162_1.sort) == 1 then
			return iter_162_1
		end
	end
end

function CoopMission.getTutorialTargetFindRoom(arg_163_0, arg_163_1)
	if not arg_163_0.vars or not arg_163_0.vars.coop_info then
		return 
	end
	
	local var_163_0 = 4
	local var_163_1
	local var_163_2 = to_n(Account:getCoopSeasonNumber())
	local var_163_3 = Account:getCoopMissionSchedule()
	
	for iter_163_0, iter_163_1 in pairs(arg_163_0.vars.coop_info.invite_list) do
		local var_163_4 = iter_163_1.boss_code
		local var_163_5 = var_163_3.boss[var_163_4].sort
		
		if to_n(iter_163_1.season_no) == var_163_2 and var_163_0 > to_n(var_163_5) then
			if arg_163_1 then
				var_163_1 = arg_163_0.vars.wnd:findChildByName("n_boss" .. var_163_5)
			else
				var_163_1 = arg_163_0.vars.wnd:findChildByName("btn_boss_" .. var_163_4)
			end
			
			if var_163_0 == 1 then
				break
			end
		end
	end
	
	if not var_163_1 and arg_163_1 then
		var_163_1 = arg_163_0.vars.wnd:findChildByName("n_boss1")
	elseif not var_163_1 then
		local var_163_6 = arg_163_0:_getFirstData()
		
		if not var_163_6 then
			return 
		end
		
		var_163_1 = arg_163_0.vars.wnd:findChildByName("n_boss1"):findChildByName("btn_boss_" .. var_163_6.id)
	end
	
	return var_163_1
end

function CoopMission.getTutorialWantedFirstItem(arg_164_0)
	if not arg_164_0.vars or not arg_164_0.vars.coop_info or not arg_164_0.vars.wnd._hand then
		return 
	end
	
	local var_164_0 = arg_164_0.vars.wnd._hand.scroll_view
	
	if not get_cocos_refid(var_164_0) then
		return 
	end
	
	local var_164_1 = var_164_0:getChildren()
	
	if not var_164_1 then
		return 
	end
	
	local var_164_2 = var_164_1[1]
	
	if not get_cocos_refid(var_164_2) then
		return 
	end
	
	return (var_164_2:findChildByName("btn_start"))
end

if not PRODUCTION_MODE then
	function MsgHandler.cheat_coop_set_expire_tm()
		local var_165_0 = CoopMission.vars.ready
		
		if not var_165_0 then
			return 
		end
		
		var_165_0:requestExpedition()
	end
	
	function CoopMission.setExpireTm2(arg_166_0, arg_166_1)
		arg_166_1 = arg_166_1 or os.time() + 1
		
		local var_166_0 = arg_166_0.vars.ready
		
		if not var_166_0 then
			Log.e("NO READY!")
			
			return 
		end
		
		local var_166_1 = var_166_0:getBossInfo()
		
		query("cheat_coop_set_expire_tm", {
			boss_id = var_166_1.boss_id,
			expire_tm = os.time() + 605
		})
	end
	
	function CoopMission.setExpireTm(arg_167_0, arg_167_1)
		arg_167_1 = arg_167_1 or os.time() + 1
		
		local var_167_0 = arg_167_0.vars.ready
		
		if not var_167_0 then
			Log.e("NO READY!")
			
			return 
		end
		
		local var_167_1 = var_167_0:getBossInfo()
		
		query("cheat_coop_set_expire_tm", {
			boss_id = var_167_1.boss_id,
			expire_tm = arg_167_1
		})
	end
	
	function CoopMission.setExpireTmById(arg_168_0, arg_168_1, arg_168_2)
		arg_168_2 = arg_168_2 or os.time() + 1
		
		query("cheat_coop_set_expire_tm", {
			boss_id = arg_168_1,
			expire_tm = arg_168_2
		})
	end
end
