InBattleEsc = {}

function HANDLER.inbattle_esc(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" or arg_1_1 == "btn_return" then
		InBattleEsc:close()
		BattleTopBar:resumeBattle()
		
		return 
	end
	
	if arg_1_1 == "btn_restart" then
		if not InBattleEsc:isEnableRestart() then
			balloon_message_with_sound("ui_inbattle_esc_restart_error")
			
			return 
		end
		
		InBattleEsc:close()
		
		local var_1_0 = T("pop_restart_battle")
		
		if Battle.logic:isCreviceHunt() then
			var_1_0 = T("pop_restart_crehunt")
		end
		
		Dialog:msgBox(var_1_0, {
			yesno = true,
			handler = function()
				BattleTopBar:restart()
			end,
			cancel_handler = function()
				BattleTopBar:resumeBattle()
			end
		})
		
		return 
	end
	
	if arg_1_1 == "btn_giveup" then
		InBattleEsc:close()
		BattleTopBar:giveUp()
		
		return 
	end
	
	if arg_1_1 == "btn_option" then
		InBattleEsc:close()
		
		if Battle.logic:isTutorial() then
			BattleTopBar:resumeBattle()
			balloon_message_with_sound("no_setup_mode")
		else
			UIOption:show({
				category = "game",
				close_callback = function()
					BattleTopBar:resumeBattle()
				end
			})
		end
		
		return 
	end
	
	if arg_1_1 == "btn_pause" then
		InBattleEsc:pause()
	end
	
	if arg_1_1 == "btn_resume" then
		InBattleEsc:resume()
	end
	
	if arg_1_1 == "btn_terminate" then
		InBattleEsc:terminate()
	end
	
	if arg_1_1 == "btn_bg" then
		InBattleEsc:close(0)
	end
	
	if arg_1_1 == "btn_end" and Battle:isReplayMode() then
		local var_1_1 = Battle.viewer:getReplayFromSceneName()
		
		Battle.viewer.player:clear()
		BattleTopBar:resumeBattle()
		
		if var_1_1 ~= "arena_net_lobby" then
			SceneManager:nextScene("lobby")
			SceneManager:resetSceneFlow()
			ClearResult:hide()
		elseif MatchService:isProgress() then
			balloon_message_with_sound("error_try_again")
		else
			MatchService:query("arena_net_enter_lobby", nil, function(arg_5_0)
				SceneManager:nextScene("arena_net_lobby", arg_5_0)
				SceneManager:resetSceneFlow()
			end)
		end
	end
	
	if arg_1_1 == "btn_play" then
		BattleTopBar:resumeBattle()
		InBattleEsc:close(0)
	end
end

function InBattleEsc.open(arg_6_0)
	if get_cocos_refid(arg_6_0.dialog) then
		return 
	end
	
	arg_6_0.dialog = load_dlg("inbattle_esc", true, "wnd", function()
		BattleTopBar:resumeBattle()
		arg_6_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_6_0.dialog)
	arg_6_0.dialog:bringToFront()
	BattleTopBar:pauseBattle()
	BattleUI:hideEmojiPanel()
	if_set_opacity(arg_6_0.dialog, "btn_restart", arg_6_0:isEnableRestart() and 255 or 76.5)
	if_set_visible(arg_6_0.dialog, "n_common", true)
	if_set_visible(arg_6_0.dialog, "n_pvplive", false)
end

function InBattleEsc.replayOpen(arg_8_0)
	if get_cocos_refid(arg_8_0.dialog) then
		return 
	end
	
	if ClearResult:isShow() then
		return 
	end
	
	arg_8_0.dialog = load_dlg("inbattle_esc", true, "wnd", function()
		BattleTopBar:resumeBattle()
		arg_8_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_8_0.dialog)
	arg_8_0.dialog:bringToFront()
	Battle:setPause(true)
	BattleTopBar:pauseBattle()
	BattleUI:hideEmojiPanel()
	if_set_opacity(arg_8_0.dialog, "btn_restart", arg_8_0:isEnableRestart() and 255 or 76.5)
	if_set_visible(arg_8_0.dialog, "n_common", false)
	if_set_visible(arg_8_0.dialog, "n_pvplive", false)
	if_set_visible(arg_8_0.dialog, "n_replay", true)
	arg_8_0:updateBtnState()
end

function InBattleEsc.netOpen(arg_10_0)
	if get_cocos_refid(arg_10_0.dialog) then
		if_set_visible(arg_10_0.dialog, "n_common", false)
		if_set_visible(arg_10_0.dialog, "n_pvplive", true)
		if_set_visible(arg_10_0.dialog:getChildByName("n_pvplive"), "n_menu", ArenaService:isAllowResumeGame())
		if_set_visible(arg_10_0.dialog, "popnoti", arg_10_0.time_state == "pause")
		if_set(arg_10_0.dialog, "txt", T("pvp_rta_mock_battle_stop"))
		if_set_visible(arg_10_0.dialog, "dim", true)
		arg_10_0:updateBtnState()
		
		return 
	end
	
	if ClearResult:isShow() then
		return 
	end
	
	arg_10_0.dialog = load_dlg("inbattle_esc", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_10_0.dialog)
	arg_10_0.dialog:bringToFront()
	BattleUI:hideEmojiPanel()
	if_set_opacity(arg_10_0.dialog, "btn_restart", arg_10_0:isEnableRestart() and 255 or 76.5)
	if_set_visible(arg_10_0.dialog, "n_common", false)
	if_set_visible(arg_10_0.dialog, "n_pvplive", true)
	if_set_visible(arg_10_0.dialog:getChildByName("n_pvplive"), "n_menu", ArenaService:isAllowResumeGame())
	if_set_visible(arg_10_0.dialog, "popnoti", arg_10_0.time_state == "pause")
	if_set(arg_10_0.dialog, "txt", T("pvp_rta_mock_battle_stop"))
	arg_10_0:updateBtnState()
end

function InBattleEsc.netUpdate(arg_11_0)
	if ClearResult:isShow() then
		arg_11_0:close(0)
		
		return 
	end
	
	if arg_11_0.time_state == "pause" then
		arg_11_0:netOpen()
	elseif arg_11_0.time_state == "countdown" then
		arg_11_0:updateBtnState()
		arg_11_0:startCountDown()
	else
		arg_11_0:updateBtnState()
		
		if arg_11_0.prev_time_state == "countdown" then
			BattleTopBar:resumeBattle()
			BattleUI:restoreSkillButtons()
			arg_11_0:resetCountDown()
			arg_11_0:close(0)
		end
	end
end

function InBattleEsc.updateBtnState(arg_12_0)
	if not get_cocos_refid(arg_12_0.dialog) then
		return 
	end
	
	local var_12_0 = arg_12_0.dialog:getChildByName("n_pvplive")
	local var_12_1 = ArenaService:isAllowResumeGame()
	
	if_set_visible(var_12_0, "btn_resume", arg_12_0.time_state == "pause")
	if_set_visible(var_12_0, "btn_pause", arg_12_0.time_state ~= "pause")
	if_set_visible(var_12_0, "btn_terminate", true)
	if_set_opacity(var_12_0, "btn_resume", arg_12_0.user_online and 255 or 76.5)
	if_set_visible(var_12_0, "btn_ignore", arg_12_0.time_state == "pause" or arg_12_0.time_state == "countdown")
	if_set_visible(var_12_0, "btn_bg", var_12_1 and arg_12_0.time_state == "running")
end

function InBattleEsc.isShow(arg_13_0)
	if get_cocos_refid(arg_13_0.dialog) then
		return true
	end
end

function InBattleEsc.isEnableRestart(arg_14_0)
	if not Battle.logic then
		return false
	end
	
	if Battle.logic:isPVP() then
		return false
	end
	
	if Battle.logic:isClanWar() then
		return false
	end
	
	if Battle.logic:isTutorial() then
		return false
	end
	
	if Battle.logic:isSkillPreview() then
		return false
	end
	
	if Battle.logic:isTournament() then
		return false
	end
	
	if Battle.logic:isDestiny() then
		return false
	end
	
	if Battle.logic:isNPCTeam() and not Battle.logic:isAutoBattleAble() then
		return false
	end
	
	if Battle.logic:isExpeditionType() or Battle.logic.type == "coop" or Battle.logic.type == "heritage" then
		return false
	end
	
	if Battle.logic:isLotaContents() then
		return false
	end
	
	return true
end

function InBattleEsc.update(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	if ArenaService:isReset() then
		return 
	end
	
	if ArenaService:isAdminMode() or ArenaService:isRoundMode() then
		arg_15_0.prev_time_state = arg_15_0.time_state
		arg_15_0.time_state = arg_15_1.time_state
		arg_15_0.user_online = arg_15_1.user_online
		
		arg_15_0:netUpdate()
	end
end

function InBattleEsc.pause(arg_16_0)
	ArenaService:query("command", {
		type = "pause"
	})
end

function InBattleEsc.resume(arg_17_0)
	if ArenaService:isRoundMode() and not arg_17_0.user_online then
		return 
	end
	
	ArenaService:query("command", {
		type = "resume"
	})
end

function InBattleEsc.terminate(arg_18_0)
	if ArenaService:getGameInfo().host == ArenaService:getUserUID() or ArenaService:isAdminUser() then
		ArenaNetRoundWinnerSelect:show({
			callback = function(arg_19_0)
				ArenaService:query("command", {
					type = "roundterminate",
					winner = arg_19_0
				})
			end
		})
	elseif ArenaService:isSpectator() then
		local var_18_0 = T("pvp_rta_mock_leave_room")
		
		Dialog:msgBox(var_18_0, {
			yesno = true,
			handler = function()
				ArenaService:resetWebSocket()
				ArenaService:query("command", {
					type = "exit"
				})
				ArenaService:reset()
				MatchService:query("arena_net_enter_lobby", nil, function(arg_21_0)
					arg_21_0.mode = "VS_FRIEND"
					
					SceneManager:nextScene("arena_net_lobby", arg_21_0)
					SceneManager:resetSceneFlow()
				end)
			end
		})
	else
		Dialog:msgBox(T("arena_wa_giveup_desc"), {
			yesno = true,
			handler = function()
				ArenaService:query("command", {
					type = "giveup"
				})
			end
		})
	end
end

function InBattleEsc.startCountDown(arg_23_0)
	if UIAction:Find("arena_net.count_down") then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.dialog) then
		arg_23_0:netOpen()
	end
	
	local var_23_0 = arg_23_0.dialog:getChildByName("n_pvplive")
	local var_23_1 = var_23_0:getChildByName("popnoti")
	local var_23_2 = var_23_0:getChildByName("n_resume_eff")
	local var_23_3 = var_23_2:getChildByName("count_down")
	local var_23_4 = var_23_2:getChildByName("start")
	local var_23_5 = var_23_2:getChildByName("eff1")
	local var_23_6 = var_23_2:getChildByName("eff2")
	
	if_set_visible(var_23_0, "n_menu", false)
	var_23_1:setVisible(true)
	var_23_2:setVisible(true)
	var_23_3:setVisible(true)
	var_23_4:setVisible(false)
	var_23_5:setVisible(false)
	var_23_6:setVisible(false)
	if_set(var_23_0, "txt", T("pvp_rta_mock_battle_start"))
	
	local function var_23_7(arg_24_0)
		SpriteCache:resetSprite(var_23_3, "img/game_eff_score_" .. tostring(arg_24_0) .. ".png")
	end
	
	local function var_23_8()
		var_23_1:setVisible(false)
		var_23_3:setVisible(false)
		var_23_4:setVisible(true)
		var_23_4:setPositionX(-125)
		var_23_5:setVisible(true)
		var_23_5:setPositionX(-2000)
		var_23_6:setVisible(true)
		var_23_6:setPositionX(2000)
		if_set(var_23_0, "txt", T("pvp_rta_mock_battle_start"))
		
		local var_25_0 = 400
		local var_25_1 = 400
		
		UIAction:Add(SEQ(LOG(MOVE_TO(var_25_0, -15, var_23_4:getPositionY())), SPAWN(RLOG(MOVE_TO(var_25_1, 1500, var_23_4:getPositionY())), FADE_OUT(var_25_1 * 0.5))), var_23_4, "arena_net_count_down.start_eff")
		UIAction:Add(SEQ(LOG(MOVE_TO(var_25_0, 0, var_23_5:getPositionY()), 2500), RLOG(MOVE_TO(var_25_1, 1500, var_23_5:getPositionY()), 120)), var_23_5, "arena_net_count_down.eff1")
		UIAction:Add(SEQ(LOG(MOVE_TO(var_25_0, 0, var_23_6:getPositionY()), 2500), RLOG(MOVE_TO(var_25_1, -1500, var_23_6:getPositionY()), 120)), var_23_6, "arena_net_count_down.eff1")
	end
	
	local var_23_9 = {
		TOTAL_TIME = 5000,
		Start = function(arg_26_0)
			local var_26_0 = 900
			local var_26_1 = 2
			local var_26_2 = 1
			local var_26_3 = 0.1
			
			UIAction:Add(SEQ(SEQ(CALL(function()
				var_23_7(3)
			end), RLOG(SCALE(var_26_0, var_26_1, var_26_2), var_26_3)), SEQ(CALL(function()
				var_23_7(2)
			end), RLOG(SCALE(var_26_0, var_26_1, var_26_2), var_26_3)), SEQ(CALL(function()
				var_23_7(1)
			end), RLOG(SCALE(var_26_0, var_26_1, var_26_2), var_26_3)), SEQ(CALL(function()
				var_23_8()
			end))), var_23_3, "arena_net.count_down.eff")
		end,
		Update = function(arg_31_0, arg_31_1, arg_31_2)
		end,
		Finish = function(arg_32_0)
			InBattleEsc:close()
			BattleTopBar:resumeBattle()
		end,
		IsFinished = function(arg_33_0, arg_33_1)
			return arg_33_1.elapsed_time >= arg_33_1.TOTAL_TIME or arg_23_0.time_state == "running"
		end
	}
	
	UIAction:Add(USER_ACT(var_23_9), var_23_0, "arena_net.count_down")
end

function InBattleEsc.resetCountDown(arg_34_0)
	UIAction:Remove("arena_net.count_down")
	
	if not get_cocos_refid(arg_34_0.dialog) then
		return 
	end
	
	arg_34_0.dialog:getChildByName("n_pvplive"):getChildByName("n_resume_eff"):setVisible(false)
end

function InBattleEsc.close(arg_35_0, arg_35_1)
	if not get_cocos_refid(arg_35_0.dialog) then
		return 
	end
	
	if_set_visible(arg_35_0.dialog, "dim", false)
	
	if UIAction:Find("arena_net.count_down") then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(arg_35_1 or 200)), REMOVE()), arg_35_0.dialog, "block")
	BackButtonManager:pop("inbattle_esc")
	Battle:setPause(false)
	
	arg_35_0.dialog = nil
end
