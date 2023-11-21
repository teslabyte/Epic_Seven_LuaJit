local var_0_0 = 270

function procBackGround(arg_1_0)
	BattleTopBar:resumeBattle()
	SceneManager:getCurrentScene().layer:setVisible(false)
	BackPlayManager:init()
	
	local var_1_0 = Account:getCurrentTeamIndex()
	
	if BattleRepeat:getRepeatPlayingTeamIndex() then
		var_1_0 = BattleRepeat:getRepeatPlayingTeamIndex()
	end
	
	if Battle.vars.battle_state == "begin" then
		Battle.logic:popInfoAll()
		BattleAction:Remove("Battle.end_reserve")
	end
	
	if BattleAction:Find("battle.ready") then
		BattleAction:Remove("battle.ready")
		Battle:playAutoSelectTarget()
	end
	
	SoundEngine:stopAllEvent()
	BackPlayManager:play(Battle.logic, {
		from_battle_scene = true,
		lose = Battle.logic:getFinalResult() == "lose",
		battle_state = Battle.vars.battle_state,
		start_time = Battle:getStartTime(),
		team_idx = var_1_0,
		team_point = Account:getTeamPoint(Account:getCurrentTeamIndex()) or 0,
		is_first_enter = not Battle:isRestored(),
		make_new_team = not Battle:isRestored(),
		ignore_lack_currency = Battle.vars.ignore_lack_currency,
		road_field_info = BattleField.road_field_info,
		current_sector_field_info = BattleField.vars and BattleField.vars.current_sector_field_info,
		cur_pos = BattleLayout:getFieldPosition()
	})
	StageStateManager:reset()
	BattleAction:RemoveAll()
	SceneManager:nextScene("lobby")
	
	Battle.pause = true
	
	setenv("time_scale", 1)
end

function MsgHandler.move_to_background(arg_2_0)
	if arg_2_0.move_success then
		procBackGround()
	else
		ContentDisable:resetContentSwitchMain(arg_2_0.content_switch)
		BattleTopBar:update_close_auto()
		BattleTopBar:resumeBattle()
		balloon_message(T("content_disable"))
	end
end

function HANDLER.inbattle_topbar(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_bag" then
	elseif arg_3_1 == "btn_battle_frenzy" then
		BattleTopBar:showRTAPenalyTooltip()
	elseif arg_3_1 == "btn_setting" then
		if not TutorialGuide:isPlayingTutorial() then
			if Battle:isReplayMode() and ClearResult:isShow() then
				return 
			end
			
			BattleTopBar:pause()
		end
	elseif arg_3_1 == "btn_chat" or arg_3_1 == "btn_top_chat_alram" then
		local var_3_0
		
		if Battle:getViewerMode() == "net_friend" then
			var_3_0 = "arena"
		end
		
		ChatMain:show(SceneManager:getRunningPopupScene(), nil, {
			section = var_3_0
		})
		ArenaNetChat:updateMemberCount()
	elseif arg_3_1 == "btn_top_auto" then
		if PetUtil:isRepeatBattleEnableMap(Battle.logic.map.enter) and BattleRepeat:isPlayingRepeatPlay() then
			balloon_message_with_sound("ui_pet_auto_battle_auto_btn")
			
			return 
		else
			Battle:toggleAutoBattle()
		end
	elseif arg_3_1 == "btn_speed" or arg_3_1 == "btn_speed2" then
		BattleTopBar:toggleBattleTimeScale()
	elseif arg_3_1 == "btn_camping" then
		if STAGE_MODE.MOVE ~= Battle:getStageMode() then
			balloon_message_with_sound("cant_use_in_battle")
			
			return 
		end
		
		if Battle:isCampingComplete() then
			Dialog:msgBox(T("camp_impossilbe"), {
				title = T("camp_complete_title")
			})
			
			return 
		end
		
		if not Battle.logic:getCurrentRoadInfo().is_cross then
			Dialog:msgBox(T("camp_possilbe_cross"), {
				title = T("camp_complete_title")
			})
			
			return 
		end
		
		local var_3_1 = Battle.logic:getTeamRes(FRIEND, "morale")
		local var_3_2 = Battle.logic:getMoraleValue("max") - (var_3_1 + Battle.logic:getMoraleValue("camp"))
		local var_3_3 = Battle.logic:getMoraleValue("camp")
		
		if var_3_2 < 0 then
			var_3_3 = Battle.logic:getMoraleValue("camp") + var_3_2
		end
		
		BattleLayout:setPauseByTag(true, "alert.camping")
		Dialog:msgBox(T("camp_start_desc", {
			morale = Battle.logic:getMoraleValue("camp"),
			heal = var_3_3,
			max = Battle.logic:getMoraleValue("max")
		}), {
			tag = "alert.camping",
			yesno = true,
			title = T("camp_start_title"),
			handler = function()
				if STAGE_MODE.MOVE ~= Battle:getStageMode() then
					balloon_message_with_sound("cant_use_in_battle")
					
					return 
				end
				
				Battle:doCamping(function()
					BattleLayout:setPauseByTag(false, "alert.camping")
				end)
			end,
			cancel_handler = function()
				BattleLayout:setPauseByTag(false, "alert.camping")
			end
		})
	elseif arg_3_1 == "btn_potion" then
		if STAGE_MODE.MOVE ~= Battle:getStageMode() then
			balloon_message_with_sound("cant_use_in_battle")
			
			return 
		end
		
		local var_3_4 = Battle.logic:getUsingPotionLimit()
		local var_3_5 = Battle.logic:getUsingPotionCount("default_potion")
		
		if var_3_4 <= var_3_5 then
			balloon_message_with_sound("cant_use_more")
			
			return 
		end
		
		BattleLayout:setPauseByTag(true, "alert.potion")
		Dialog:msgBox(T("potion_party_heal", {
			heal = GAME_STATIC_VARIABLE.potion_party_heal,
			count = math.max(var_3_4 - var_3_5, 0)
		}), {
			tag = "alert.potion",
			yesno = true,
			title = T("potion_popup_title"),
			handler = function()
				BattleLayout:setPauseByTag(false, "alert.potion")
				
				if STAGE_MODE.MOVE ~= Battle:getStageMode() then
					balloon_message_with_sound("cant_use_in_battle")
					
					return 
				end
				
				Battle:usePotion()
			end,
			cancel_handler = function()
				BattleLayout:setPauseByTag(false, "alert.potion")
			end
		})
	elseif arg_3_1 == "btn_boss_guide" then
		if arg_3_0:getOpacity() >= 255 then
			TutorialGuide:procGuide("boss_guide")
			HelpGuide:open_in_battle()
		else
			balloon_message_with_sound("has_not_guide")
		end
	elseif arg_3_1 == "btn_battle_frenzy" then
		BattleTopBar:hideRTAPenalyTooltip()
	elseif arg_3_1 == "btn_draw_turn" then
		BattleTopBar:onOptionalDraw()
	elseif arg_3_1 == "btn_esc" then
		Battle.viewer:exit()
	elseif arg_3_1 == "btn_my_device" then
		DeviceInventory:openDeviceInventory()
	else
		balloon_message_with_sound("notyet_con")
	end
end

function HANDLER.pet_auto_control(arg_9_0, arg_9_1)
	if Battle.logic:getCurrentRoadType() == "goblin" or Battle.logic:getCurrentRoadType() == "chaos" then
		return 
	end
	
	if arg_9_1 == "btn_end" then
		if BattleRepeat:get_repeatCount() <= 0 and not BattleRepeat:getConfigRepeatPlay() then
			BattleTopBar:close_RepeateControl()
		else
			BattleRepeat:stop_repeatPlay()
		end
	elseif arg_9_1 == "btn_setting" then
		local var_9_0
		local var_9_1
		
		if Battle.logic then
			if Battle.logic:isDescent() then
				var_9_0 = Account:getDescentPetTeamIdx()
				var_9_1 = Account:getPetInTeam(var_9_0)
			elseif Battle.logic:isBurning() then
				var_9_0 = Account:getBurningPetTeamIdx()
				var_9_1 = Account:getPetInTeam(var_9_0)
			elseif Battle.logic:isCreviceHunt() then
				var_9_0 = Account:getCrehuntTeamIndex()
				var_9_1 = Account:getPetInTeam(var_9_0)
			end
		else
			var_9_0 = Account:getCurrentTeamIndex()
		end
		
		PetHelper:open_petSetting(var_9_1, var_9_0)
	elseif arg_9_1 == "btn_item" then
		BattleRepeatPopup:openItemListPopup()
		ClearResult:offSellMode()
	elseif arg_9_1 == "btn_expedition" then
		BattleTopBarCoopPopup:open_coopMissionPopup()
	elseif arg_9_1 == "btn_time" then
		BattleTopBarUrgentPopup:open_urgentMissionPopup()
	elseif arg_9_1 == "btn_close_auto" then
		if InBattleEsc:isShow() then
			return 
		end
		
		if Battle.logic then
			local var_9_2 = Battle.logic.map.enter
			local var_9_3, var_9_4 = BackPlayManager:checkBackGroundPlayableMap(var_9_2)
			
			if not var_9_3 then
				if var_9_4 then
					balloon_message(T(var_9_4))
				end
				
				return 
			end
			
			BattleTopBar:pauseBattle()
			
			local var_9_5 = Dialog:msgBox(T("ui_bgbattle_start"), {
				yesno = true,
				handler = function()
					if SubStoryBurningDungeon:getEnterDungeonBattle() then
						SubStoryBurningDungeon:setEnterDungeonBattle(false)
					end
					
					BattleRepeat:set_isCounting(false)
					query("move_to_background", {
						is_first_enter = not Battle:isRestored()
					})
				end,
				cancel_handler = function()
					BattleTopBar:resumeBattle()
				end
			})
			
			BattleTopBar:setBackGroundConfirmDlg(var_9_5)
		end
	end
end

function HANDLER.inbattle_top_device(arg_12_0, arg_12_1)
	if arg_12_1 == "n_btn_device_on_off" then
		UIAction:Remove("device_auto_hide")
		BattleTopBar:toggleMonsterDeviceIcon()
	end
end

function HANDLER.frenzy_tooltip_hud(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_close" then
		BattleTopBar:hideRTAPenalyTooltip()
	end
end

BattleTopBar = {}

function BattleTopBar.setPausedBattleSound(arg_14_0, arg_14_1)
	SoundEngine:setPausedBus("bus:/character", arg_14_1)
	SoundEngine:setPausedBus("bus:/voice", arg_14_1)
end

function BattleTopBar.pauseBattle(arg_15_0)
	if BGI and get_cocos_refid(BGI.ui_layer) then
		BGI.ui_layer:setVisible(false)
	end
	
	if arg_15_0.logic and not arg_15_0.logic:isRealtimeMode() then
		arg_15_0:setPausedBattleSound(true)
		pause()
	end
end

function BattleTopBar.resumeBattle(arg_16_0)
	if BGI and get_cocos_refid(BGI.ui_layer) then
		BGI.ui_layer:setVisible(true)
	end
	
	arg_16_0:setPausedBattleSound(false)
	resume()
end

function BattleTopBar.restart(arg_17_0)
	local var_17_0 = Battle.logic.map.enter
	local var_17_1 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(var_17_0)
	
	arg_17_0:_giveUp(function()
		if Battle:isRestored() then
			SceneManager:nextScene("lobby")
			SceneManager:resetSceneFlow()
		else
			local var_18_0, var_18_1, var_18_2, var_18_3 = DB("level_enter", var_17_0, {
				"id",
				"type",
				"sub_type",
				"contents_type"
			})
			
			if var_18_0 and var_18_1 and var_18_1 == "descent" then
				DescentReady:show({
					enter_id = var_17_0,
					callback = arg_17_0
				})
			elseif var_18_0 and var_18_1 and var_18_1 == "burning" then
				BurningReady:show({
					enter_id = var_17_0,
					callback = arg_17_0,
					burning_battle_id = SubStoryBurningDungeon:getBattleID()
				})
			else
				local var_18_4
				
				if var_18_1 and var_18_1 == "trial_hall" then
					var_18_4 = DungeonTrialHall:getTargetDBId()
				end
				
				local var_18_5 = var_18_3 == "substory" and SubstoryManager:getInfo() or nil
				
				BattleReady:show({
					hide_open_difficulty = true,
					ignore_block = true,
					enter_id = var_17_0,
					callback = arg_17_0,
					urgent_mission_id = var_17_1,
					sub_story = var_18_5,
					trial_id = var_18_4,
					currencies = SceneManager:getCurrentSceneName() == "DungeonList" and DungeonList:getCurrentCurrencies() or nil,
					practice_mode = Battle.logic:isPracticeMode()
				})
			end
		end
	end)
end

function BattleTopBar.onStartBattle(arg_19_0, arg_19_1)
	if not startBattle(arg_19_1.enter_id, arg_19_1) then
		SceneManager:nextScene("lobby")
		SceneManager:resetSceneFlow()
	end
end

function BattleTopBar.onCloseBattleReadyDialog(arg_20_0)
	if SceneManager:getCurrentSceneName() == "DungeonList" and DungeonList:getMode() == "Crevice" and DungeonCreviceMain:isOpen() then
		DungeonCreviceMain:addTickUpdateEvent()
	end
end

function BattleTopBar.init(arg_21_0, arg_21_1)
	arg_21_0.logic = arg_21_1
	arg_21_0.vars = {}
	arg_21_0.topbar_wnd = load_dlg("inbattle_topbar", true, "wnd")
	arg_21_0.vars.btn_top_chat = arg_21_0.topbar_wnd:getChildByName("n_chat")
	
	if_set_visible(arg_21_0.topbar_wnd, "n_debug", false)
	if_set_visible(arg_21_0.topbar_wnd, "top_right", not arg_21_1:isTutorial())
	
	if ContentDisable:byAlias("chat") then
		if_set_visible(arg_21_0.vars.btn_top_chat, nil, false)
		arg_21_0.topbar_wnd.c.n_miscs:setPositionX(arg_21_0.vars.btn_top_chat:getPositionX())
	else
		if ChatMain:isRepeatMode() then
			local var_21_0 = ChatMain:getLastInputText() and string.len(ChatMain:getLastInputText()) > 0
			
			ChatMain:show(SceneManager:getRunningPopupScene(), var_21_0, nil)
		end
		
		if ChatEmojiPopup:isRepeatMode() then
			ChatEmojiPopup:show()
		end
	end
	
	arg_21_0.topbar_wnd.c.n_speed:setVisible(Battle:isTimeScaleMode())
	arg_21_0:updateBattleTimeScale()
	
	if arg_21_1 and arg_21_1.isRealtimeMode then
		if_set_visible(arg_21_0.topbar_wnd, "btn_boss_guide", not arg_21_1:isRealtimeMode())
	else
		if_set_visible(arg_21_0.topbar_wnd, "btn_boss_guide", false)
	end
	
	local var_21_1 = arg_21_0.topbar_wnd:getChildByName("n_camping")
	
	var_21_1:setVisible(false)
	var_21_1:setPositionX(-300)
	
	local var_21_2 = arg_21_0.topbar_wnd:getChildByName("n_potion")
	
	var_21_2:setVisible(false)
	var_21_2:setPositionX(-390)
	BattleField:addUIControl(arg_21_0.topbar_wnd)
	arg_21_0.topbar_wnd:setLocalZOrder(100000)
	
	if arg_21_1 and arg_21_1:isAutomaton() then
		if_set_visible(arg_21_0.topbar_wnd, "btn_my_device", true)
		
		local var_21_3 = arg_21_1:getMonsterDevice()
		
		if not table.empty(var_21_3) then
			arg_21_0.device_wnd = load_dlg("inbattle_top_device", true, "wnd")
			
			BattleField:addUIControl(arg_21_0.device_wnd)
			arg_21_0.device_wnd:setLocalZOrder(100000)
			
			local var_21_4 = arg_21_0.device_wnd:getChildByName("txt_enermy_device")
			local var_21_5 = arg_21_0.device_wnd:getChildByName("icon")
			
			if var_21_4 and var_21_5 then
				local var_21_6 = var_21_4:getContentSize()
				
				var_21_5:setPositionX(var_21_4:getPositionX() + var_21_6.width / 2 * var_21_4:getScaleX() + 14)
			end
			
			arg_21_0:initMonsterDeviceIcon(arg_21_1)
			
			arg_21_0.vars.showMonsterDevice = true
			
			local var_21_7 = arg_21_0.device_wnd:getChildByName("n_normal")
			
			UIAction:Add(SEQ(DELAY(4000), CALL(function()
				BattleTopBar:toggleMonsterDeviceIcon()
			end)), var_21_7, "device_auto_hide")
		end
	end
	
	if not Battle:isAutoPlayableStage() then
		if_set_opacity(arg_21_0.topbar_wnd, "n_top_auto", 127.5)
	end
	
	if Battle:isRealtimeMode() then
		if_set_visible(arg_21_0.topbar_wnd, "n_top_auto", Battle:isNetLocalTest())
		if_set_visible(arg_21_0.topbar_wnd, "btn_setting", not Battle.viewer.service:isAllowExitBattle())
		if_set_visible(arg_21_0.topbar_wnd, "btn_esc", Battle.viewer.service:isAllowExitBattle())
		if_set_visible(arg_21_0.topbar_wnd, "btn_battle_frenzy", arg_21_0.logic:isEnableRtaPenalty() and not MatchService:isBroadCastUIHide())
		if_set_visible(arg_21_0.vars.btn_top_chat, nil, not ArenaNetChat:isDisabled() and not ContentDisable:byAlias("chat") and not MatchService:isBroadCastUIHide())
		
		arg_21_0.vars.frenzy_tooltip = arg_21_0.topbar_wnd:getChildByName("n_inbattle_frenzy_tooltip")
		
		local var_21_8 = load_control("wnd/inbattle_frenzy_tooltip.csb")
		
		var_21_8:setName("frenzy_tooltip_hud")
		arg_21_0.vars.frenzy_tooltip:addChild(var_21_8)
	elseif Battle:isReplayMode() then
		if_set_visible(arg_21_0.topbar_wnd, "n_top_auto", false)
		if_set_visible(arg_21_0.topbar_wnd, "btn_esc", false)
		if_set_visible(arg_21_0.topbar_wnd, "btn_boss_guide", false)
		if_set_visible(arg_21_0.topbar_wnd, "btn_battle_frenzy", true)
		if_set_visible(arg_21_0.vars.btn_top_chat, nil, false)
		
		arg_21_0.vars.frenzy_tooltip = arg_21_0.topbar_wnd:getChildByName("n_inbattle_frenzy_tooltip")
		
		local var_21_9 = load_control("wnd/inbattle_frenzy_tooltip.csb")
		
		var_21_9:setName("frenzy_tooltip_hud")
		arg_21_0.vars.frenzy_tooltip:addChild(var_21_9)
	end
	
	if arg_21_0:isUseTurnInfo() then
		local var_21_10 = arg_21_0.topbar_wnd:getChildByName("n_turn")
		
		if get_cocos_refid(var_21_10) then
			var_21_10:setVisible(true)
			arg_21_0:setTurnInfo(0)
			UIUserData:proc(var_21_10:getChildByName("bg"))
		end
	end
	
	arg_21_0:updateOptionalDraw()
	arg_21_0:setMode(arg_21_0.logic:getStageMainType())
	arg_21_0:update()
	arg_21_0:updatePotion()
	arg_21_0:updateNewChatCount()
	
	local var_21_11 = arg_21_0.topbar_wnd:findChildByName("top_right")
	
	if NotchStatus:isRequireAdjustEdge() then
		local var_21_12 = var_21_11:getPositionX()
		
		var_21_11:setPositionX(var_21_12 - NotchStatus:getAdjustEdgeValue())
	end
	
	if arg_21_1 and arg_21_1.auto_battle_able then
		arg_21_0:hideAutoBattle()
	end
	
	if not arg_21_0.topbar_wnd.c.n_speed:isVisible() then
		local var_21_13 = var_21_11:getChildByName("n_top_auto")
		local var_21_14 = var_21_11:getChildByName("n_boss_guide_move1")
		
		if not var_21_13:isVisible() then
			var_21_14 = var_21_11:getChildByName("n_boss_guide_move2")
		end
		
		local var_21_15 = var_21_11:getChildByName("btn_boss_guide")
		
		if var_21_15 and var_21_14 then
			var_21_15:setPosition(var_21_14:getPosition())
		end
		
		if arg_21_1 and arg_21_1:isAutomaton() then
			if_set_add_position_x(arg_21_0.topbar_wnd, "btn_my_device", 54)
		end
	end
	
	return BattleTopBar
end

function BattleTopBar.hideAutoBattle(arg_23_0)
	local var_23_0 = arg_23_0.topbar_wnd:findChildByName("top_right")
	
	if not var_23_0 then
		return 
	end
	
	var_23_0:getChildByName("n_top_auto"):setVisible(false)
	
	local var_23_1 = arg_23_0.topbar_wnd:getChildByName("n_speed")
	local var_23_2 = arg_23_0.topbar_wnd:getChildByName("n_speed_move")
	local var_23_3 = var_23_0:getChildByName("btn_boss_guide")
	local var_23_4 = var_23_0:getChildByName("n_boss_guide_move1")
	
	if not var_23_1 or not var_23_2 or not var_23_3 or not var_23_4 then
		return 
	end
	
	var_23_1:setPosition(var_23_2:getPosition())
	var_23_3:setPosition(var_23_4:getPosition())
end

function BattleTopBar.updateOptionalDraw(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1 or 0
	local var_24_1 = arg_24_0.topbar_wnd:getChildByName("btn_draw_turn")
	
	if get_cocos_refid(var_24_1) then
		if arg_24_0.logic:isClanWar() and Account:getCurrentWarUId() >= 4 then
			var_24_1:setVisible(true)
			if_set_visible(var_24_1, "t_active", arg_24_0.logic:isOptionalDraw())
			if_set_visible(var_24_1, "t_draw", not arg_24_0.logic:isOptionalDraw())
			if_set_visible(var_24_1, "t_count", not arg_24_0.logic:isOptionalDraw())
			var_24_1:setOpacity(arg_24_0.logic:isOptionalDraw() and 255 or 76)
			
			if not arg_24_0.logic:isOptionalDraw() then
				if_set(var_24_1, "t_count", T("clanwar_draw_desc1", {
					value = (GAME_STATIC_VARIABLE.clan_draw_turn or 20) - var_24_0
				}))
			elseif not get_cocos_refid(var_24_1.eff) then
				local var_24_2 = var_24_1:getContentSize()
				
				var_24_1.eff = EffectManager:Play({
					fn = "ui_guildpvp_draw_bt_eff.cfx",
					pivot_z = 99998,
					layer = var_24_1,
					pivot_x = var_24_2.width / 2,
					pivot_y = var_24_2.height / 2
				})
			end
		else
			var_24_1:setVisible(false)
		end
	end
end

function BattleTopBar.onOptionalDraw(arg_25_0)
	if Account:getCurrentWarUId() < 4 then
		return 
	end
	
	if arg_25_0.logic:isClanWar() and arg_25_0.logic:isOptionalDraw() then
		arg_25_0:pauseBattle()
		Dialog:msgBox(T("clanwar_draw_popup_desc1"), {
			yesno = true,
			title = T("clanwar_draw_popup_title"),
			warning = T("clanwar_draw_popup_desc2"),
			yes_text = T("clanwar_draw_popup_btn_y"),
			no_text = T("clanwar_draw_popup_btn_n"),
			handler = function()
				SoundEngine:resume()
				SoundEngine:stopAllEvent()
				BattleTopBar:setPausedBattleSound(false)
				Battle:doEndBattle({
					fatal_stop = true,
					resume = true,
					draw = true
				})
			end,
			cancel_handler = function()
				arg_25_0:resumeBattle()
			end
		})
	end
	
	if false then
	end
end

function BattleTopBar.open_RepeateControl(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1 or {}
	
	if get_cocos_refid(arg_28_0.pet_wnd) then
		arg_28_0.pet_wnd:removeFromParent()
	end
	
	arg_28_0:create_RepeateControl(var_28_0)
	arg_28_0.pet_wnd:setPositionY(DESIGN_HEIGHT / 2)
	
	arg_28_0.n_repeat_cont = arg_28_0.pet_wnd:getChildByName("n_control")
	
	if get_cocos_refid(arg_28_0.n_repeat_cont) then
		arg_28_0.n_repeat_cont:setPositionY(var_0_0)
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(300, nil, 0))), arg_28_0.n_repeat_cont)
	end
end

function BattleTopBar.create_RepeateControl(arg_29_0, arg_29_1)
	arg_29_0.pet_wnd = load_dlg("pet_auto_control", true, "wnd")
	
	if_set_visible(arg_29_0.pet_wnd, "n_count", false)
	if_set_visible(arg_29_0.pet_wnd, "txt_end", false)
	upgradeLabelToRichLabel(arg_29_0.pet_wnd, "txt_info", true)
	arg_29_0:init_missionCount()
	arg_29_0:update_repeatCount()
	arg_29_0:update_close_auto()
	;(arg_29_1.parent_layer or BGI.ui_layer):addChild(arg_29_0.pet_wnd)
end

function BattleTopBar.update_close_auto(arg_30_0)
	local var_30_0 = arg_30_0.pet_wnd:getChildByName("btn_close_auto")
	local var_30_1 = Battle.logic.map.enter
	
	if var_30_0 and not BackPlayUtil:isPlayableContentSwitch(var_30_1) then
		var_30_0:setOpacity(76.5)
	end
end

function BattleTopBar.update_repeatCount(arg_31_0)
	if not get_cocos_refid(arg_31_0.pet_wnd) then
		return 
	end
	
	if BattleRepeat:get_repeatMaxCount() == BattleRepeat:get_repeatCount() then
		if_set_visible(arg_31_0.pet_wnd, "txt_info", false)
		if_set_visible(arg_31_0.pet_wnd, "txt_disc", true)
	else
		if_set_visible(arg_31_0.pet_wnd, "txt_info", true)
		if_set_visible(arg_31_0.pet_wnd, "txt_disc", false)
		arg_31_0:update_winRateScore()
	end
	
	BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
end

function BattleTopBar.update_winRateScore(arg_32_0)
	if not get_cocos_refid(arg_32_0.pet_wnd) then
		return 
	end
	
	local var_32_0, var_32_1 = BattleRepeat:getScores()
	
	if not var_32_0 or not var_32_1 then
		return 
	end
	
	local var_32_2 = T("ui_pet_auto_battle_desc", {
		count = BattleRepeat:getCurRepeatCount(),
		max = BattleRepeat:get_repeatMaxCount()
	}) .. T("ui_pet_auto_battle_winrate", {
		win = var_32_0,
		lose = var_32_1
	})
	
	if_set(arg_32_0.pet_wnd, "txt_info", var_32_2)
end

function BattleTopBar.init_missionCount(arg_33_0)
	if not get_cocos_refid(arg_33_0.pet_wnd) then
		return 
	end
	
	local var_33_0 = BattleRepeat:get_urgentMissionCount()
	
	if var_33_0 <= 0 then
		if_set_visible(arg_33_0.pet_wnd, "n_count_time", false)
	else
		if_set_visible(arg_33_0.pet_wnd, "n_count_time", true)
		if_set(arg_33_0.pet_wnd, "count_time", var_33_0)
	end
	
	if_set_opacity(arg_33_0.pet_wnd, "btn_time", var_33_0 > 0 and 255 or 76.5)
end

function BattleTopBar.setDisabledBackPlayBtn(arg_34_0)
	if not get_cocos_refid(arg_34_0.pet_wnd) then
		return 
	end
	
	local var_34_0 = arg_34_0.pet_wnd:getChildByName("btn_close_auto")
	
	if not get_cocos_refid(var_34_0) then
		return 
	end
	
	var_34_0:setOpacity(76.5)
	var_34_0:setTouchEnabled(false)
end

function BattleTopBar.setEnd_repeatCountText(arg_35_0, arg_35_1)
	if not get_cocos_refid(arg_35_0.pet_wnd) then
		return 
	end
	
	if not (arg_35_1 or {}).count then
		local var_35_0 = BattleRepeat:get_repeatMaxCount()
	end
	
	if_set_visible(arg_35_0.pet_wnd, "txt_disc", false)
	if_set(arg_35_0.pet_wnd, "txt_title", T("ui_pet_auto_battle_off"))
	
	local var_35_1 = arg_35_0.pet_wnd:getChildByName("btn_close_auto")
	
	if var_35_1 then
		var_35_1:setOpacity(76.5)
		var_35_1:setTouchEnabled(false)
	end
	
	local var_35_2, var_35_3 = BattleRepeat:getScores()
	
	if not var_35_2 or not var_35_3 then
		return 
	end
	
	if_set_visible(arg_35_0.pet_wnd, "txt_info", false)
	if_set_visible(arg_35_0.pet_wnd, "txt_end", true)
	if_set(arg_35_0.pet_wnd, "txt_end", T("ui_pet_auto_battle_off_count") .. T("ui_pet_auto_battle_winrate", {
		win = var_35_2,
		lose = var_35_3
	}))
	if_set(arg_35_0.pet_wnd, "txt_repeat", T("close_text"))
	BattleRepeat:set_isEndRepeatPlay(true)
	arg_35_0:setDisabledBackPlayBtn()
	vibrate(VIBRATION_TYPE.Default)
end

function BattleTopBar.open_RepeateControlAgain(arg_36_0)
	if get_cocos_refid(arg_36_0.pet_wnd) and not Battle.logic:isPVP() and not Battle.logic:isTutorial() and Battle:isAutoPlayableStage() then
		arg_36_0:setEnd_repeatCountText({
			count = BattleRepeat:getCurRepeatCount()
		})
		arg_36_0.pet_wnd:setPositionY(DESIGN_HEIGHT / 2)
		
		if get_cocos_refid(arg_36_0.n_repeat_cont) then
			arg_36_0.n_repeat_cont:setPositionY(var_0_0)
			UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(300, nil, 0))), arg_36_0.n_repeat_cont)
		end
		
		arg_36_0:setDisabledBackPlayBtn()
		ClearResult:showAll_btns()
		BattleRepeat:set_isCounting(false)
	end
end

function BattleTopBar.get_repeateControl(arg_37_0)
	return arg_37_0.pet_wnd
end

function BattleTopBar.close_RepeateControl(arg_38_0)
	if arg_38_0.pet_wnd and get_cocos_refid(arg_38_0.pet_wnd) then
		UIAction:Add(SEQ(RLOG(MOVE_TO(300, nil, var_0_0)), SHOW(false)), arg_38_0.n_repeat_cont)
		
		local var_38_0 = arg_38_0.pet_wnd:getChildByName("n_count")
		
		if get_cocos_refid(var_38_0) and var_38_0:isVisible() then
			UIAction:Add(SEQ(FADE_OUT(300), SHOW(false)), var_38_0)
		end
		
		if ClearResult.vars and get_cocos_refid(ClearResult.vars.wnd) and Battle.logic and not Battle.logic:isEnded() and ClearResult.childs.n_reward:isVisible() then
			ClearResult.vars.seq:setAutoNext(false)
		end
		
		ClearResult:showAll_btns()
		BattleRepeat:set_isCounting(false)
		BattleTopBarUrgentPopup:close_urgentMissionPopup()
	end
end

BattleTopBarUrgentPopup = {}
BattleTopBarCoopPopup = {}

copy_functions(ScrollView, BattleTopBarUrgentPopup)
copy_functions(ScrollView, BattleTopBarCoopPopup)

function HANDLER.mission_item_repeat(arg_39_0, arg_39_1)
	local var_39_0 = ConditionContentsManager:getUrgentMissions()
	
	if arg_39_1 == "btn_place_go" then
		if not var_39_0 or not BattleTopBarUrgentPopup:_canMoveToPath() then
			balloon_message_with_sound("ui_pet_auto_battle_other_btn")
			
			return 
		end
		
		local var_39_1 = arg_39_0.enter_id
		
		local function var_39_2()
			UrgentMissionMove:showReady(var_39_1)
		end
		
		BattleTopBarUrgentPopup:close_urgentMissionPopup()
		BackPlayControlBox:close()
		MusicBoxUI:close()
		AdvWorldMapController:worldmap({
			no_check_dungeon = true,
			afterLoad = var_39_2
		})
		var_39_0:initNoti()
	end
end

function HANDLER.pet_auto_mission_time(arg_41_0, arg_41_1)
	if arg_41_1 == "btn_close" then
		BattleTopBarUrgentPopup:close_urgentMissionPopup()
	elseif arg_41_1 == "btn_go_adventure" then
		BattleTopBarUrgentPopup:enterStory()
	end
end

function BattleTopBarUrgentPopup.open_urgentMissionPopup(arg_42_0, arg_42_1)
	if BattleRepeat:get_urgentMissionCount() <= 0 then
		balloon_message_with_sound("mission_base_urgent_desc")
		
		return 
	end
	
	BattleRepeat:set_urgentMissionNotiCount(0)
	arg_42_0:init(arg_42_1)
	BackButtonManager:push({
		check_id = "pet_auto_mission_time",
		back_func = function()
			BattleTopBarUrgentPopup:close_urgentMissionPopup()
		end
	})
end

function BattleTopBarUrgentPopup.init(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1 or {}
	
	arg_44_0.vars = {}
	arg_44_0.vars.urgentMissionCards = {}
	arg_44_0.vars.wnd = load_dlg("pet_auto_mission_time", true, "wnd")
	
	BattleRepeat:getParentPopup():addChild(arg_44_0.vars.wnd)
	if_set_visible(arg_44_0.vars.wnd, "n_info", not var_44_0.is_back_play)
	if_set_visible(arg_44_0.vars.wnd, "n_dim_img", not var_44_0.is_back_play)
	
	arg_44_0.vars.scrollview = arg_44_0.vars.wnd:getChildByName("ScrollView")
	
	local var_44_1 = {}
	local var_44_2 = Account:getUrgentMissions()
	
	table.sort(var_44_2, function(arg_45_0, arg_45_1)
		if not arg_45_0.end_time then
			return false
		end
		
		if not arg_45_1.end_time then
			return true
		end
		
		return arg_45_0.end_time < arg_45_1.end_time
	end)
	
	for iter_44_0, iter_44_1 in pairs(var_44_2) do
		if iter_44_1.state == URGENT_MISSION_STATE.ACTIVE and iter_44_1.end_time > os.time() then
			table.insert(var_44_1, iter_44_0)
		end
	end
	
	for iter_44_2, iter_44_3 in pairs(var_44_1) do
		local var_44_3 = ConditionContentsManager:getUrgentMissions()
		local var_44_4 = var_44_3:getScore(iter_44_3)
		local var_44_5 = var_44_3:getMaxCount(iter_44_3)
		local var_44_6 = ConditionContentsManager:getUrgentMissions()
		local var_44_7 = {
			id = iter_44_3
		}
		
		table.insert(arg_44_0.vars.urgentMissionCards, var_44_7)
	end
	
	if_set_visible(arg_44_0.vars.wnd, "noti_time", table.empty(arg_44_0.vars.urgentMissionCards))
	if_set(arg_44_0.vars.wnd, "count_time", table.count(arg_44_0.vars.urgentMissionCards))
	Scheduler:add(BattleTopBarUrgentPopup.vars.wnd, BattleTopBarUrgentPopup.update_urgentMissionTime, BattleTopBarUrgentPopup):setName("update_urgentMissionTime")
	arg_44_0:selectTab()
end

function BattleTopBarUrgentPopup.selectTab(arg_46_0)
	arg_46_0.vars.btn_go_adventure = arg_46_0.vars.wnd:getChildByName("btn_go_adventure")
	
	if get_cocos_refid(arg_46_0.vars.btn_go_adventure) then
		arg_46_0.vars.btn_go_adventure:setOpacity(not arg_46_0:_canMoveToPath() and 76.5 or 255)
	end
	
	arg_46_0:updatePopup()
end

function BattleTopBarUrgentPopup.enterStory(arg_47_0)
	if not BattleTopBarUrgentPopup:_canMoveToPath() then
		balloon_message_with_sound("ui_pet_auto_battle_other_btn")
		
		return 
	end
	
	BattleTopBarUrgentPopup:close_urgentMissionPopup()
	BackPlayControlBox:close()
	AdvWorldMapController:worldmap({
		no_check_dungeon = true
	})
end

function BattleTopBarUrgentPopup.updatePopup(arg_48_0)
	arg_48_0:initScrollView(arg_48_0.vars.scrollview, 600, 140)
	arg_48_0:setScrollViewItems(arg_48_0.vars.urgentMissionCards)
	if_set_visible(arg_48_0.vars.wnd, "n_no_data", table.empty(arg_48_0.vars.urgentMissionCards))
	arg_48_0.vars.scrollview:scrollToTop(0, false)
end

function BattleTopBarUrgentPopup._canMoveToPath(arg_49_0)
	if BattleRepeat:isPlayingRepeatPlay() and SceneManager:getCurrentSceneName() == "battle" then
		if not BattleRepeat:get_isEndRepeatPlay() then
			return false
		end
		
		if not ClearResult:isShow() then
			return false
		end
		
		if not Battle:isEnded() then
			return false
		end
	end
	
	return true
end

function BattleTopBarUrgentPopup.getScrollViewItem(arg_50_0, arg_50_1)
	local var_50_0 = load_dlg("mission_item", true, "wnd")
	
	var_50_0:setName("mission_item_repeat")
	if_set_visible(var_50_0, "n_locked", false)
	
	local var_50_1 = ConditionContentsManager:getUrgentMissions()
	local var_50_2 = DB("mission_data", arg_50_1.id, {
		"name"
	})
	
	if_set(var_50_0, "txt_name", T(var_50_2))
	var_50_1:setNoti(var_50_0, arg_50_1.id)
	if_set_visible(var_50_0, "txt_title", false)
	
	local var_50_3 = var_50_1:getScore(arg_50_1.id)
	local var_50_4 = var_50_1:getMaxCount(arg_50_1.id)
	
	var_50_0:getChildByName("progress"):setPercent(var_50_3 / var_50_4 * 100)
	if_set(var_50_0, "txt_progress", var_50_3 .. "/" .. var_50_4)
	
	if (var_50_1:getGroups() or {})[arg_50_1.id] then
		local var_50_5 = var_50_1:getRemainTime(arg_50_1.id)
		
		if var_50_5 <= 0 then
			if_set(var_50_0, "txt_time_title", T("urgent_time_expire"))
		else
			if_set(var_50_0, "txt_time_title", T("remain_time_urgent", {
				time = sec_to_full_string(var_50_5, true)
			}))
		end
	end
	
	local var_50_6, var_50_7, var_50_8, var_50_9, var_50_10 = DB("mission_data", arg_50_1.id, {
		"reward_id1",
		"reward_count1",
		"grade_rate1",
		"set_drop_id1",
		"area_enter_id"
	})
	local var_50_11 = {
		tooltip_x = -170,
		parent = var_50_0:getChildByName("icon"),
		set_drop = var_50_9,
		grade_rate = var_50_8
	}
	
	UIUtil:getRewardIcon(var_50_7, var_50_6, var_50_11)
	
	local var_50_12 = var_50_0:getChildByName("btn_place_go")
	
	if get_cocos_refid(var_50_12) then
		var_50_12.enter_id = var_50_10
	end
	
	if_set_opacity(var_50_0, "btn_place_go", 76.5)
	if_set_opacity(var_50_0, "btn_label", 76.5)
	
	arg_50_1.cont = var_50_0
	
	return var_50_0
end

function BattleTopBarUrgentPopup.update_urgentMissionTime(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.wnd) then
		arg_51_0:remove_urgentMissionTime_scheduler()
		
		return 
	end
	
	local var_51_0, var_51_1 = BackPlayUtil:checkAdventureInBackPlay()
	
	if arg_51_0.vars.urgentMissionCards then
		for iter_51_0, iter_51_1 in pairs(arg_51_0.vars.urgentMissionCards) do
			local var_51_2 = ConditionContentsManager:getUrgentMissions()
			
			if (var_51_2:getGroups() or {})[iter_51_1.id] and iter_51_1.cont then
				local var_51_3 = 0
				local var_51_4 = var_51_2:getRemainTime(iter_51_1.id)
				local var_51_5 = not arg_51_0:_canMoveToPath() and 76.5 or 255
				
				if not var_51_0 then
					var_51_5 = 76.5
				end
				
				if_set_opacity(iter_51_1.cont, "btn_place_go", var_51_5)
				if_set_opacity(iter_51_1.cont, "btn_label", var_51_5)
				
				if var_51_4 <= 0 then
					if_set(iter_51_1.cont, "txt_time_title", T("urgent_time_expire"))
					
					iter_51_1.remove = true
				else
					if_set(iter_51_1.cont, "txt_time_title", T("remain_time_urgent", {
						time = sec_to_full_string(var_51_4, true)
					}))
				end
			end
		end
		
		for iter_51_2 = #arg_51_0.vars.urgentMissionCards, 1, -1 do
			local var_51_6 = arg_51_0.vars.urgentMissionCards[iter_51_2]
			
			if var_51_6 and var_51_6.remove then
				table.remove(arg_51_0.vars.urgentMissionCards, iter_51_2)
				arg_51_0:removeScrollViewItem(var_51_6)
			end
		end
	end
	
	if get_cocos_refid(arg_51_0.vars.btn_go_adventure) then
		local var_51_7 = not arg_51_0:_canMoveToPath() and 76.5 or 255
		
		if not var_51_0 then
			var_51_7 = 76.5
		end
		
		arg_51_0.vars.btn_go_adventure:setOpacity(var_51_7)
	end
	
	BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
	if_set_visible(arg_51_0.vars.wnd, "noti_time", not table.empty(arg_51_0.vars.urgentMissionCards))
	if_set(arg_51_0.vars.wnd, "count_time", table.count(arg_51_0.vars.urgentMissionCards))
end

function BattleTopBarUrgentPopup.remove_urgentMissionTime_scheduler(arg_52_0)
	if not Scheduler:findByName("update_urgentMissionTime") then
		return 
	end
	
	Scheduler:removeByName("update_urgentMissionTime")
end

function BattleTopBarUrgentPopup.close_urgentMissionPopup(arg_53_0)
	if not arg_53_0.vars or not get_cocos_refid(arg_53_0.vars.wnd) then
		return 
	end
	
	arg_53_0:remove_urgentMissionTime_scheduler()
	BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
	arg_53_0.vars.wnd:removeFromParent()
	
	arg_53_0.vars = nil
	
	BackButtonManager:pop("pet_auto_mission_time")
end

function MsgHandler.coop_my_invite_list(arg_54_0)
	BattleTopBarCoopPopup:init(arg_54_0)
end

function HANDLER.pet_auto_mission_expedition(arg_55_0, arg_55_1)
	if arg_55_1 == "btn_shared" then
		BattleTopBarCoopPopup:selectTab(1)
	elseif arg_55_1 == "btn_acquired" then
		BattleTopBarCoopPopup:selectTab(2)
	elseif arg_55_1 == "btn_close" then
		BattleTopBarCoopPopup:hide()
	elseif arg_55_1 == "btn_go_expedition" then
		BattleTopBarCoopPopup:enterCoopMission()
	end
end

function BattleTopBarCoopPopup.open_coopMissionPopup(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_1 or {}
	
	BattleTopBarCoopPopup.is_back_play = var_56_0.is_back_play
	
	if not Account:isSysAchieveCleared("system_124") then
		balloon_message_with_sound("system_124_btn_lock")
		
		return 
	end
	
	if not arg_56_0.vars or arg_56_0.vars and not get_cocos_refid(arg_56_0.vars.wnd) then
		query("coop_my_invite_list")
	else
		arg_56_0:refreshMyCardList()
		arg_56_0:show()
	end
	
	BackButtonManager:push({
		check_id = "pet_auto_mission_expedition",
		back_func = function()
			BattleTopBarCoopPopup:hide()
		end
	})
end

function BattleTopBarCoopPopup.init(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_1 or {}
	
	arg_58_0.vars = {}
	arg_58_0.vars.sharedMissionCards = var_58_0.my_lists or {}
	arg_58_0.vars.tab = 2
	arg_58_0.vars.wnd = load_dlg("pet_auto_mission_expedition", true, "wnd")
	
	BattleRepeat:getParentPopup():addChild(arg_58_0.vars.wnd)
	if_set_visible(arg_58_0.vars.wnd, "n_info", not BattleTopBarCoopPopup.is_back_play)
	if_set_visible(arg_58_0.vars.wnd, "n_dim_img", not BattleTopBarCoopPopup.is_back_play)
	
	arg_58_0.vars.ScrollView_shared = arg_58_0.vars.wnd:getChildByName("ScrollView_shared")
	arg_58_0.vars.ScrollView_acquired = arg_58_0.vars.wnd:getChildByName("ScrollView_acquired")
	
	local var_58_1 = (Account:getCoopMissionSchedule() or {}).boss or {}
	
	arg_58_0:refreshMyCardList()
	
	for iter_58_0, iter_58_1 in pairs(arg_58_0.vars.sharedMissionCards) do
		if var_58_1[iter_58_1.boss_code] then
			iter_58_1.character_id = var_58_1[iter_58_1.boss_code].character_id
			iter_58_1.name = DB("character", iter_58_1.character_id, "name") or var_58_1[iter_58_1.boss_code].boss_name
		end
	end
	
	if_set(arg_58_0.vars.wnd, "txt_count_acquired", T("pet_repeat_acquired_mission", {
		count = table.count(arg_58_0.vars.myMissionCards)
	}))
	if_set(arg_58_0.vars.wnd, "txt_count_total", T("pet_repeat_shared_mission", {
		count = table.count(arg_58_0.vars.sharedMissionCards)
	}))
	Scheduler:add(BattleTopBarCoopPopup.vars.wnd, BattleTopBarCoopPopup.update_coopMissionTime, BattleTopBarCoopPopup):setName("update_coopMissionTime")
	arg_58_0:selectTab(arg_58_0.vars.tab)
end

function BattleTopBarCoopPopup.refreshMyCardList(arg_59_0)
	if not arg_59_0.vars then
		return 
	end
	
	arg_59_0.vars.myMissionCards = {}
	
	local var_59_0 = Account:getTicketList() or {}
	local var_59_1 = (Account:getCoopMissionSchedule() or {}).boss or {}
	
	for iter_59_0, iter_59_1 in pairs(var_59_0) do
		if iter_59_1.expire_tm > os.time() and var_59_1[iter_59_1.boss_code] then
			local var_59_2 = var_59_1[iter_59_1.boss_code].image
			local var_59_3 = var_59_1[iter_59_1.boss_code].character_id
			local var_59_4, var_59_5 = DB("character", var_59_3, {
				"ch_attribute",
				"name"
			})
			local var_59_6 = table.clone(iter_59_1)
			
			var_59_6.image = var_59_2
			var_59_6.id = var_59_3
			var_59_6.attribute = var_59_4
			var_59_6.name = var_59_5
			
			table.insert(arg_59_0.vars.myMissionCards, var_59_6)
		end
	end
end

function BattleTopBarCoopPopup.selectTab(arg_60_0, arg_60_1)
	local var_60_0 = tonumber(arg_60_1) or 1
	
	arg_60_0.vars.tab = var_60_0
	arg_60_0.vars.btn_go_expedition = arg_60_0.vars.wnd:getChildByName("btn_go_expedition")
	
	if_set_visible(arg_60_0.vars.wnd, "bg_shared", var_60_0 == 1)
	if_set_visible(arg_60_0.vars.wnd, "n_shared", var_60_0 == 1)
	if_set_visible(arg_60_0.vars.wnd, "bg_acquired", var_60_0 == 2)
	if_set_visible(arg_60_0.vars.wnd, "n_acquired", var_60_0 == 2)
	if_set_visible(arg_60_0.vars.wnd, "btn_go_expedition", true)
	
	if get_cocos_refid(arg_60_0.vars.btn_go_expedition) then
		arg_60_0.vars.btn_go_expedition:setOpacity(not arg_60_0:_canMoveToPath() and 76.5 or 255)
	end
	
	if_set_visible(arg_60_0.vars.ScrollView_shared, nil, var_60_0 == 1)
	if_set_visible(arg_60_0.vars.ScrollView_acquired, nil, var_60_0 == 2)
	arg_60_0:updatePopup()
	BattleTopBarCoopPopup:update_coopMissionTime()
end

function BattleTopBarCoopPopup.enterCoopMission(arg_61_0)
	if not BattleTopBarCoopPopup:_canMoveToPath() then
		balloon_message_with_sound("ui_pet_auto_battle_other_btn")
		
		return 
	end
	
	BattleTopBarCoopPopup:close_coopMissionPopup()
	BackPlayControlBox:close()
	CoopMission.DoEnter()
end

function BattleTopBarCoopPopup.updatePopup(arg_62_0)
	local var_62_0
	
	if arg_62_0.vars.tab == 1 then
		arg_62_0:initScrollView(arg_62_0.vars.ScrollView_shared, 600, 140)
		arg_62_0:setScrollViewItems(arg_62_0.vars.sharedMissionCards)
		if_set_visible(arg_62_0.vars.wnd, "n_no_data", table.empty(arg_62_0.vars.sharedMissionCards))
		arg_62_0.vars.ScrollView_shared:scrollToTop(0, false)
	else
		arg_62_0:initScrollView(arg_62_0.vars.ScrollView_acquired, 214, 280, {
			fit_height = true,
			force_horizontal = true
		})
		arg_62_0:setScrollViewItems(arg_62_0.vars.myMissionCards)
		if_set_visible(arg_62_0.vars.wnd, "n_no_data", table.empty(arg_62_0.vars.myMissionCards))
	end
end

function BattleTopBarCoopPopup._canMoveToPath(arg_63_0)
	if BattleRepeat:isPlayingRepeatPlay() then
		if BackPlayManager:isRunning() then
			return true
		end
		
		if SceneManager:getCurrentSceneName() == "battle" then
			if not BattleRepeat:get_isEndRepeatPlay() then
				return false
			end
			
			if not ClearResult:isShow() then
				return false
			end
			
			if not Battle:isEnded() then
				return false
			end
		end
	end
	
	return true
end

function BattleTopBarCoopPopup.getScrollViewItem(arg_64_0, arg_64_1)
	local var_64_0
	
	if arg_64_0.vars.tab == 1 then
		var_64_0 = load_dlg("pet_auto_mission_item_expedition", true, "wnd")
		
		if_set(var_64_0, "t_name", T(arg_64_1.name))
		CoopUtil:setDifficulty(var_64_0, arg_64_1.difficulty)
		
		local var_64_1 = 0
		local var_64_2 = CoopUtil:getLevelData(arg_64_1)
		
		if var_64_2 and var_64_2.character_id then
			arg_64_1.character_id = var_64_2.character_id
			var_64_1 = CoopUtil:getBossLevelFromLevelData(var_64_2) or 0
		end
		
		UIUtil:getRewardIcon(nil, arg_64_1.character_id, {
			hide_lv = true,
			hide_star = true,
			tier = "boss",
			show_color_right = true,
			no_grade = true,
			parent = var_64_0:findChildByName("mob_icon"),
			lv = var_64_1
		})
		
		local var_64_3 = arg_64_1.invite_name or ""
		
		if_set(var_64_0, "txt_sharer", T("ui_repeat_expedition_user", {
			name = var_64_3
		}))
		if_set(var_64_0, "txt_time_shared", T("pet_repeat_exped_shared_time", {
			time = sec_to_full_string(os.time() - arg_64_1.invite_tm, true)
		}))
	elseif arg_64_0.vars.tab == 2 then
		var_64_0 = load_dlg("pet_auto_mission_item_expedition2", true, "wnd")
		
		if_set_sprite(var_64_0, "boss", "face/" .. arg_64_1.image .. ".png")
		if_set_sprite(var_64_0, "icon", "img/cm_icon_pro" .. arg_64_1.attribute .. ".png")
		if_set(var_64_0, "t_name", T(arg_64_1.name))
		if_set(var_64_0, "label", T("expedition_start"))
		
		var_64_0.data = {}
		var_64_0.data.id = arg_64_1.id
		var_64_0.data.name = arg_64_1.name
		var_64_0.data.image = arg_64_1.image
		var_64_0.data.attribute = arg_64_1.attribute
		var_64_0.data.boss_slot = arg_64_1.boss_slot
		var_64_0.data.boss_code = arg_64_1.boss_code
	end
	
	arg_64_1.cont = var_64_0
	
	return var_64_0
end

function BattleTopBarCoopPopup.update_coopMissionTime(arg_65_0)
	if not arg_65_0.vars or not get_cocos_refid(arg_65_0.vars.wnd) then
		arg_65_0:remove_coopMissionTime_scheduler()
		
		return 
	end
	
	if arg_65_0.vars.sharedMissionCards then
		for iter_65_0, iter_65_1 in pairs(arg_65_0.vars.sharedMissionCards) do
			if iter_65_1.cont then
				local var_65_0 = 0
				local var_65_1 = iter_65_1.expire_tm - os.time()
				
				if var_65_1 <= 0 then
					if_set(iter_65_1.cont, "txt_time_title", T("urgent_time_expire"))
					
					iter_65_1.remove = true
				else
					if_set(iter_65_1.cont, "txt_time_title", T("remain_time_urgent", {
						time = sec_to_full_string(var_65_1, true)
					}))
				end
				
				if iter_65_1.invite_tm then
					if_set(iter_65_1.cont, "txt_time_shared", T("pet_repeat_exped_shared_time", {
						time = sec_to_full_string(os.time() - iter_65_1.invite_tm, true)
					}))
				end
			end
		end
		
		for iter_65_2 = #arg_65_0.vars.sharedMissionCards, 1, -1 do
			local var_65_2 = arg_65_0.vars.sharedMissionCards[iter_65_2]
			
			if var_65_2 and var_65_2.remove then
				table.remove(arg_65_0.vars.sharedMissionCards, iter_65_2)
				arg_65_0:removeScrollViewItem(var_65_2)
			end
		end
	end
	
	if get_cocos_refid(arg_65_0.vars.btn_go_expedition) then
		arg_65_0.vars.btn_go_expedition:setOpacity(not arg_65_0:_canMoveToPath() and 76.5 or 255)
	end
	
	BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
	if_set(arg_65_0.vars.wnd, "txt_count_acquired", T("pet_repeat_acquired_mission", {
		count = table.count(arg_65_0.vars.myMissionCards)
	}))
	if_set(arg_65_0.vars.wnd, "txt_count_total", T("pet_repeat_shared_mission", {
		count = table.count(arg_65_0.vars.sharedMissionCards)
	}))
	
	if arg_65_0.vars.tab == 1 and table.count(arg_65_0.vars.sharedMissionCards) == 0 then
		if_set_visible(arg_65_0.vars.wnd, "n_no_data", true)
	elseif arg_65_0.vars.tab == 2 and table.count(arg_65_0.vars.myMissionCards) == 0 then
		if_set_visible(arg_65_0.vars.wnd, "n_no_data", true)
	end
end

function BattleTopBarCoopPopup.updateMissionCount(arg_66_0)
	local var_66_0 = table.count(arg_66_0.vars.sharedMissionCards)
	
	BattleRepeat:set_coopMissionCount(var_66_0)
	BattleRepeat:update_missionCount(BattleTopBar:get_repeateControl())
end

function BattleTopBarCoopPopup.remove_coopMissionTime_scheduler(arg_67_0)
	if not Scheduler:findByName("update_coopMissionTime") then
		return 
	end
	
	Scheduler:removeByName("update_coopMissionTime")
end

function BattleTopBarCoopPopup.show(arg_68_0)
	if not arg_68_0.vars or not get_cocos_refid(arg_68_0.vars.wnd) then
		return 
	end
	
	arg_68_0.vars.wnd:setVisible(true)
end

function BattleTopBarCoopPopup.hide(arg_69_0)
	if not arg_69_0.vars or not get_cocos_refid(arg_69_0.vars.wnd) then
		return 
	end
	
	arg_69_0:updateMissionCount()
	arg_69_0.vars.wnd:setVisible(false)
	BackButtonManager:pop("pet_auto_mission_expedition")
end

function BattleTopBarCoopPopup.close_coopMissionPopup(arg_70_0)
	if not arg_70_0.vars or not get_cocos_refid(arg_70_0.vars.wnd) then
		return 
	end
	
	arg_70_0:remove_coopMissionTime_scheduler()
	arg_70_0:updateMissionCount()
	arg_70_0.vars.wnd:removeFromParent()
	
	arg_70_0.vars = nil
	
	BackButtonManager:pop("pet_auto_mission_expedition")
end

function BattleTopBar.removeBackGroundConfirmDlg(arg_71_0)
	if not arg_71_0.vars or not get_cocos_refid(arg_71_0.vars.back_ground_play_dlg) then
		return 
	end
	
	arg_71_0.vars.back_ground_play_dlg:removeFromParent()
	BackButtonManager:pop()
	BattleTopBar:resumeBattle()
end

function BattleTopBar.setBackGroundConfirmDlg(arg_72_0, arg_72_1)
	if not arg_72_0.vars then
		return 
	end
	
	arg_72_0.vars.back_ground_play_dlg = arg_72_1
end

function BattleTopBar.isShowPause(arg_73_0)
	if arg_73_0.vars and get_cocos_refid(arg_73_0.vars.pauseMsgBox) then
		return true
	end
end

function BattleTopBar.pause(arg_74_0)
	if NetWaiting:isWaiting() then
		return 
	end
	
	if TransitionScreen:isShow() then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if get_cocos_refid(G_CURRENT_MOVIE_CLIP) then
		return 
	end
	
	if get_cocos_refid(arg_74_0.vars.pauseMsgBox) then
		return 
	end
	
	if CampingSiteNew:isActive() then
		return 
	end
	
	if HelpGuide.vars and get_cocos_refid(HelpGuide.vars.wnd) then
		return 
	end
	
	if BattleRepeat:get_isCounting() then
		return 
	end
	
	if UIOption:isVisible() then
		return 
	end
	
	if is_playing_story() then
		return 
	end
	
	BattleTopBar:removeBackGroundConfirmDlg()
	
	if Battle.viewer.service and Battle.viewer.service:isAllowPauseGame() then
		InBattleEsc:netOpen()
	elseif Battle:isReplayMode() then
		InBattleEsc:replayOpen()
	elseif Battle.viewer:isSpectator() then
		Battle.viewer:exit()
	else
		InBattleEsc:open()
	end
end

function BattleTopBar._giveUp(arg_75_0, arg_75_1)
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return 
	end
	
	SoundEngine:resume()
	SoundEngine:stopAllEvent()
	BattleTopBar:setPausedBattleSound(false)
	
	if BattleRepeat:isPlayingRepeatPlay() then
		BattleRepeat:stop_repeatPlay()
	end
	
	if DummyService:isActive() then
		SceneManager:popScene()
		
		return 
	end
	
	if Battle.vars.end_battle then
		balloon_message_with_sound("already_battle_end")
		Dialog:closeAll()
		UIOption:close()
		
		return 
	end
	
	if Battle.logic:isRealtimeMode() then
		Dialog:closeAll()
		UIOption:setBlock(false)
		
		if Battle.viewer and Battle.viewer.service then
			if not Battle.viewer.service:isReset() then
				Battle.viewer.service:query("command", {
					type = "giveup"
				})
			end
		else
			SceneManager:nextScene("lobby")
			SceneManager:resetSceneFlow()
		end
		
		return 
	end
	
	if Battle.logic:isPVP() then
		Dialog:closeAll()
		UIOption:setBlock(false)
		Battle:doEndBattle({
			fatal_stop = true,
			resume = true,
			giveup = true
		})
		
		return 
	end
	
	if Battle.logic:isExpeditionType() then
		Dialog:closeAll()
		UIOption:setBlock(false)
		Battle:doEndBattle({
			fatal_stop = true,
			resume = true
		})
		
		return 
	end
	
	if Battle.logic:isLotaContents() then
		Dialog:closeAll()
		UIOption:setBlock(false)
		Battle:doEndBattle({
			fatal_stop = true,
			resume = true,
			giveup = true
		})
		
		return 
	end
	
	if Battle.logic:isSkillPreview() then
		resume()
		
		local var_75_0 = SceneManager:getNextFlowSceneName()
		
		if var_75_0 and var_75_0 == "collection" then
			local var_75_1 = Battle.logic.friends[1]
			local var_75_2 = var_75_1.db.skin_group
			local var_75_3 = var_75_1.inst.code
			
			if var_75_2 then
				local var_75_4 = DB("character_skin", var_75_2, "default")
			end
			
			SceneManager:popScene()
		elseif var_75_0 and var_75_0 == "shop" then
			Shop:open("normal", "skin")
		elseif var_75_0 and var_75_0 == "arena_net_lobby" then
			MatchService:query("arena_net_enter_lobby", nil, function(arg_76_0)
				SceneManager:nextScene("arena_net_lobby", arg_76_0)
				SceneManager:resetSceneFlow()
			end)
		else
			SceneManager:popScene()
		end
		
		return 
	end
	
	if BattleRepeat:isPlayingRepeatPlay() then
		BattleRepeat:end_repeatPlay()
	end
	
	local var_75_5 = Battle.logic:getCreviceHuntDifficulty()
	
	if var_75_5 and Battle.logic:isCreviceHunt() then
		local var_75_6 = DungeonCreviceUtil:getBossInfo(var_75_5 == "normal" and 0 or 1)
		
		DungeonCreviceUtil:setBossInfo(var_75_6, true)
	end
	
	DungeonMissions:clear()
	Dialog:closeAll()
	Battle:endBattleScene({
		giveup = true,
		doAfterNextSceneLoaded = arg_75_1
	})
	UIOption:setBlock(false)
end

function BattleTopBar.getGiveUpMessage(arg_77_0)
	if Battle.logic.type and Battle.logic.type == "trial_hall" then
		return T("pop_giveup_trial_hall")
	end
	
	if Battle.logic:isLotaContents() and Battle.logic:isExpeditionType() then
		return T("ui_clan_heritage_coop_retire")
	end
	
	if false then
	end
	
	if Battle.logic:isExpeditionType() then
		return T("pop_giveup_coop")
	end
	
	if Battle.logic:isClanWar() then
		return T("clanwar_giveup_caution")
	end
	
	if Battle.logic:isRealtimeMode() then
		if Battle.viewer.service:getMatchMode() == "net_event_rank" then
			return T("clanwar_giveup_caution")
		else
			return T("pvp_giveup_caution")
		end
	end
	
	if Battle.logic:isPVP() then
		return T("pvp_giveup_caution")
	end
	
	if Battle.logic:getMoonlightTheaterEpisodeID() then
		return T("theater_story_close_desc")
	end
	
	if Battle.logic:isCreviceHunt() then
		return T("pop_giveup_crehunt")
	end
	
	return T("pop_giveup_battle")
end

function BattleTopBar.giveUp(arg_78_0)
	if Battle.logic:isTutorial() then
		arg_78_0:resumeBattle()
		balloon_message_with_sound("no_setup_mode")
		
		return 
	end
	
	if Battle.logic:isSplType() then
		arg_78_0:resumeBattle()
		SPLSystem:giveUpBattle()
		
		return 
	end
	
	if Battle.logic:isSkillPreview() then
		arg_78_0:_giveUp()
		
		return 
	end
	
	if Battle.logic:isPreviewQuest() and not Battle.logic:getMoonlightTheaterEpisodeID() then
		arg_78_0:_giveUp()
		
		return 
	end
	
	Dialog:msgBox(arg_78_0:getGiveUpMessage(), {
		yesno = true,
		handler = function()
			arg_78_0:stopStoryInMoonlightTheater()
			arg_78_0:_giveUp()
		end,
		cancel_handler = function()
			arg_78_0:resumeBattle()
		end,
		yes_text = T("msg_close")
	})
end

function BattleTopBar.stopStoryInMoonlightTheater(arg_81_0)
	if get_cocos_refid(STORY.layer) and Battle.logic and Battle.logic:getMoonlightTheaterEpisodeID() then
		BattleField:lockViewPort(true)
		exit_story_no_clear()
	end
end

function BattleTopBar.setMode(arg_82_0, arg_82_1)
	arg_82_0.mode = arg_82_1
end

function BattleTopBar.isVisible(arg_83_0)
	return arg_83_0.topbar_wnd:isVisible()
end

function BattleTopBar.setVisible(arg_84_0, arg_84_1)
	if not arg_84_0.topbar_wnd or not get_cocos_refid(arg_84_0.topbar_wnd) or arg_84_0:isVisible() == arg_84_1 then
		return 
	end
	
	if not arg_84_0:isVisible() and BattlePopupMap:isShow() then
		return 
	end
	
	local var_84_0 = arg_84_0.topbar_wnd:getChildByName("top_right")
	local var_84_1 = 50
	local var_84_2 = 300
	local var_84_3 = 110
	local var_84_4 = 0
	
	if NotchStatus:isRequireAdjustEdge() then
		var_84_4 = NotchStatus:getAdjustEdgeValue()
	end
	
	if arg_84_1 then
		BattleMapManager:updateMorale()
		BattleUIAction:Add(SEQ(SHOW(true), TARGET(var_84_0, SEQ(MOVE_TO(0, VIEW_WIDTH + var_84_1, DESIGN_HEIGHT + var_84_1), MOVE_TO(var_84_2, VIEW_WIDTH + VIEW_BASE_LEFT - var_84_4, DESIGN_HEIGHT)))), arg_84_0.topbar_wnd)
	else
		BattleUIAction:Add(SEQ(TARGET(var_84_0, SEQ(MOVE_BY(var_84_3, var_84_1, var_84_1))), SHOW(false)), arg_84_0.topbar_wnd)
	end
end

function BattleTopBar.getControl(arg_85_0, arg_85_1)
	return arg_85_0.topbar_wnd:getChildByName(arg_85_1)
end

function BattleTopBar.getCtrlPosition(arg_86_0, arg_86_1)
	local var_86_0 = arg_86_0.topbar_wnd:getChildByName(arg_86_1)
	
	if var_86_0 then
		return var_86_0:getPosition()
	end
	
	return 0, 0
end

function BattleTopBar.updateNotifications(arg_87_0)
	arg_87_0:checkChatNotification()
end

function BattleTopBar.checkChatNotification(arg_88_0)
	if not get_cocos_refid(arg_88_0.topbar_wnd) then
		return 
	end
	
	if arg_88_0:isDisableTip() then
		return 
	end
	
	local var_88_0 = arg_88_0.topbar_wnd:getChildByName("n_chat")
	local var_88_1 = arg_88_0.topbar_wnd:getChildByName("btn_top_chat_alram")
	
	if not get_cocos_refid(var_88_0) or not get_cocos_refid(var_88_1) then
		return 
	end
	
	local var_88_2 = ChatMain:checkNotification()
	
	arg_88_0.vars.btn_top_chat = var_88_2 and var_88_1 or var_88_0
	
	if_set_visible(var_88_1, nil, var_88_2)
	if_set_visible(var_88_0, nil, not var_88_2)
	
	if var_88_2 then
		if not get_cocos_refid(arg_88_0.vars.eff_chat_noti) then
			arg_88_0.vars.eff_chat_noti = ChatMain:getNotificationEffect(var_88_1:getChildByName("n_eff"))
		end
	elseif get_cocos_refid(arg_88_0.vars.eff_chat_noti) then
		arg_88_0.vars.eff_chat_noti:removeFromParent()
		
		arg_88_0.vars.eff_chat_noti = nil
	end
	
	arg_88_0:updateNewChatCount()
end

function BattleTopBar.updateNewChatCount(arg_89_0)
	if not get_cocos_refid(arg_89_0.topbar_wnd) then
		return 
	end
	
	local var_89_0 = ChatMBox:getUnseenMsgCount()
	local var_89_1 = var_89_0 > 0
	
	if_set_visible(arg_89_0.vars.btn_top_chat, "chat_count", var_89_1)
	if_set(arg_89_0.vars.btn_top_chat, "text_chat_count", var_89_0)
end

function BattleTopBar.tip(arg_90_0, arg_90_1)
	if not get_cocos_refid(arg_90_0.topbar_wnd) then
		return 
	end
	
	if arg_90_0:isDisableTip() then
		return 
	end
	
	arg_90_0:hideTip()
	
	local var_90_0 = arg_90_0.topbar_wnd:getChildByName("n_tip")
	
	UIUtil:tip(var_90_0, arg_90_1)
end

function BattleTopBar.tipEmoji(arg_91_0, arg_91_1)
	if not get_cocos_refid(arg_91_0.topbar_wnd) then
		return 
	end
	
	if arg_91_0:isDisableTip() then
		return 
	end
	
	arg_91_0:hideTip()
	
	local var_91_0 = arg_91_0.topbar_wnd:getChildByName("n_tip_emoji")
	
	UIUtil:tipEmoji(var_91_0, arg_91_1)
end

function BattleTopBar.hideTip(arg_92_0)
	if not get_cocos_refid(arg_92_0.topbar_wnd) then
		return 
	end
	
	if_set_visible(arg_92_0.topbar_wnd, "n_tip", false)
	if_set_visible(arg_92_0.topbar_wnd, "n_tip_emoji", false)
end

function BattleTopBar.isDisableTip(arg_93_0)
	if ArenaService:isAdminMode() then
		return true
	end
	
	if ArenaNetChat:isDisabled() then
		return true
	end
	
	if Battle:isReplayMode() then
		return true
	end
	
	return false
end

function BattleTopBar.shakeBackpack(arg_94_0, arg_94_1)
	local function var_94_0(arg_95_0, arg_95_1)
		if not arg_95_1 then
			return 
		end
		
		local var_95_0 = arg_95_1.grade
		
		if not var_95_0 then
			var_95_0 = 0
			
			if arg_95_1.code == "to_crystal" then
				var_95_0 = 3
			end
		end
		
		local var_95_1 = {
			[0] = "loot_magic.cfx",
			"loot_common.cfx",
			"loot_uncommon.cfx",
			"loot_rare.cfx",
			"loot_hero.cfx",
			"loot_legend.cfx"
		}
		local var_95_2 = arg_95_0:getLocalZOrder()
		local var_95_3, var_95_4 = arg_95_0:getPosition()
		local var_95_5 = var_95_4 + arg_95_0:getContentSize().height / 2
		
		EffectManager:Play({
			fn = var_95_1[var_95_0],
			layer = arg_95_0:getParent(),
			pivot_x = var_95_3,
			pivot_y = var_95_5,
			pivot_z = var_95_2 + 1
		})
	end
	
	local var_94_1 = BattleMapManager:getControl("bag")
	local var_94_2 = var_94_1:getScale()
	
	BattleUIAction:Remove("battle.box")
	BattleUIAction:Add(SEQ(CALL(var_94_0, var_94_1, arg_94_1), LOG(SCALE(130, var_94_2, var_94_2 * 2)), SHAKE_UI(250, 20), RLOG(SCALE(200, var_94_2 * 2, var_94_2 * 0.8)), DELAY(90), RLOG(SCALE(90, var_94_2 * 0.8, var_94_2))), var_94_1, "battle.box")
end

function BattleTopBar.toggleBattleTimeScale(arg_96_0)
	if not Battle:isSpeedPlayableStage() then
		balloon_message_with_sound("no_battlespeed_mode")
		
		return 
	end
	
	Battle:setTimeScaleUp(not Battle:isTimeScaleUp())
	Battle:applyTimeScaleUp()
	SoundEngine:play("event:/" .. (Battle:isTimeScaleUp() and "ui/battle_hud/speed_up" or "ui/battle_hud/speed_down"))
	SAVE:setKeep("battle.speed.up", Battle:isTimeScaleUp())
	arg_96_0:updateBattleTimeScale()
end

function BattleTopBar.updateBattleTimeScale(arg_97_0)
	local var_97_0 = arg_97_0.topbar_wnd:getChildByName("n_speed")
	
	if not var_97_0 then
		return 
	end
	
	if_set_visible(var_97_0, "btn_speed", not Battle:isTimeScaleUp())
	if_set_visible(var_97_0, "btn_speed2", Battle:isTimeScaleUp())
	if_set_opacity(var_97_0, nil, Battle:isSpeedPlayableStage() and 255 or 127.5)
end

function BattleTopBar.update(arg_98_0)
	if not get_cocos_refid(arg_98_0.topbar_wnd) then
		return 
	end
	
	if Battle:isAutoPlaying() then
		BattleUIAction:Remove("battle.auto")
		
		local var_98_0 = arg_98_0.topbar_wnd:getChildByName("btn_top_auto")
		local var_98_1 = 0
		
		BattleUIAction:Add(COND_LOOP(ROTATE(2000, var_98_1, var_98_1 - 360), function()
			return not Battle:isAutoPlaying()
		end), var_98_0, "battle.auto")
	else
		BattleUIAction:Remove("battle.auto")
		
		local var_98_2 = arg_98_0.topbar_wnd:getChildByName("btn_top_auto")
		local var_98_3 = var_98_2:getRotationSkewX()
		local var_98_4 = -180
		
		if var_98_3 < var_98_4 then
			var_98_4 = -360
		end
		
		var_98_2:setRotation(var_98_4)
	end
	
	arg_98_0:updateBattleTimeScale()
	arg_98_0:updateNewChatCount()
end

function BattleTopBar.initMonsterDeviceIcon(arg_100_0, arg_100_1)
	local var_100_0 = "monster_" .. DungeonAutomaton:getAutomatonMonsterDeviceRotateId()
	local var_100_1 = DB("level_automaton", arg_100_1.map.enter, {
		var_100_0
	})
	local var_100_2 = {}
	
	if var_100_1 then
		for iter_100_0 = 1, 99 do
			local var_100_3 = var_100_1 .. "_" .. iter_100_0
			local var_100_4 = DBT("level_automaton_device", var_100_3, {
				"id",
				"category",
				"sort",
				"sort",
				"cs",
				"skill_1",
				"grade_1"
			})
			
			if not var_100_4.id then
				break
			end
			
			table.insert(var_100_2, var_100_4)
		end
		
		table.sort(var_100_2, function(arg_101_0, arg_101_1)
			return arg_101_0.sort < arg_101_1.sort
		end)
	end
	
	if table.empty(var_100_2) then
		return 
	end
	
	for iter_100_1 = 1, 99 do
		local var_100_5 = arg_100_0.device_wnd:getChildByName("n_device_icon" .. iter_100_1)
		
		if not get_cocos_refid(var_100_5) or not var_100_2[iter_100_1] then
			break
		end
		
		local var_100_6 = var_100_2[iter_100_1].skill_1
		local var_100_7 = var_100_2[iter_100_1].grade_1
		local var_100_8 = UIUtil:getDeviceIcon(var_100_6, {
			category = "monster",
			id = var_100_2[iter_100_1].id,
			grade = var_100_7
		})
		
		var_100_5:addChild(var_100_8)
		var_100_8:setAnchorPoint(0.5, 0.5)
	end
end

function BattleTopBar.toggleMonsterDeviceIcon(arg_102_0)
	if not arg_102_0.device_wnd then
		return 
	end
	
	local var_102_0 = arg_102_0.device_wnd:getChildByName("n_move")
	local var_102_1 = arg_102_0.device_wnd:getChildByName("n_normal")
	local var_102_2 = arg_102_0.device_wnd:getChildByName("icon")
	local var_102_3 = arg_102_0.device_wnd:getChildByName("n_gear_left")
	local var_102_4 = arg_102_0.device_wnd:getChildByName("n_gear_right")
	local var_102_5 = var_102_3:getChildByName("g1")
	local var_102_6 = var_102_3:getChildByName("g2")
	local var_102_7 = var_102_4:getChildByName("g1")
	local var_102_8 = var_102_4:getChildByName("g2")
	
	if not var_102_1.origin_y then
		var_102_1.origin_y = var_102_1:getPositionY()
	end
	
	if arg_102_0.vars.showMonsterDevice then
		UIAction:Add(SEQ(LOG(MOVE_TO(300, nil, var_102_0:getPositionY())), CALL(function()
			var_102_2:setRotation(180)
		end)), var_102_1)
		UIAction:Add(SEQ(ROTATE(300, 0, 150)), var_102_5)
		UIAction:Add(SEQ(ROTATE(300, 0, -150)), var_102_6)
		UIAction:Add(SEQ(ROTATE(300, 0, 150)), var_102_7)
		UIAction:Add(SEQ(ROTATE(300, 0, -150)), var_102_8)
	else
		UIAction:Add(SEQ(LOG(MOVE_TO(300, nil, var_102_1.origin_y)), CALL(function()
			var_102_2:setRotation(0)
		end)), var_102_1)
		UIAction:Add(SEQ(ROTATE(300, 150, 0)), var_102_5)
		UIAction:Add(SEQ(ROTATE(300, -150, 0)), var_102_6)
		UIAction:Add(SEQ(ROTATE(300, 150, 0)), var_102_7)
		UIAction:Add(SEQ(ROTATE(300, -150, 0)), var_102_8)
	end
	
	arg_102_0.vars.showMonsterDevice = not arg_102_0.vars.showMonsterDevice
end

function BattleTopBar.updateCampingButton(arg_105_0)
	local var_105_0 = Battle.logic:getCurrentRoadInfo().is_cross
	local var_105_1 = arg_105_0.topbar_wnd:getChildByName("n_camping")
	
	if get_cocos_refid(var_105_1) then
		var_105_1:removeChildByName("@camp_eff")
		
		if Battle:isCampingComplete() or not var_105_0 then
			var_105_1:setColor(cc.c3b(100, 100, 100))
		else
			var_105_1:setColor(cc.c3b(255, 255, 255))
			EffectManager:Play({
				z = 1,
				fn = "ui_camping_bt_eff.cfx",
				y = 1,
				layer = var_105_1,
				x = VIEW_BASE_LEFT - 1
			}):setName("@camp_eff")
		end
	end
end

function BattleTopBar.onUpdateStageMode(arg_106_0, arg_106_1)
	if string.starts(Battle.logic.type, "dungeon") then
		local var_106_0 = arg_106_0.topbar_wnd:getChildByName("n_camping")
		local var_106_1 = arg_106_0.topbar_wnd:getChildByName("n_potion")
		
		if arg_106_1 == STAGE_MODE.MOVE then
			if not var_106_0:isVisible() and Battle.logic.type ~= "dungeon_quest" then
				var_106_0:setVisible(true)
				var_106_0:setOpacity(0)
				UIAction:Add(LOG(SPAWN(MOVE_TO(300, 154, 46), FADE_IN(300))), var_106_0, "block")
			end
			
			if not var_106_1:isVisible() then
				var_106_1:setVisible(true)
				var_106_1:setOpacity(0)
				UIAction:Add(LOG(SPAWN(MOVE_TO(300, 64, 55), FADE_IN(300))), var_106_1, "block")
			end
		else
			if var_106_0:isVisible() then
				var_106_0:setOpacity(0)
				UIAction:Add(RLOG(SPAWN(MOVE_TO(300, -300, 46), SEQ(FADE_IN(300), SHOW(false)))), var_106_0, "block")
			end
			
			if var_106_1:isVisible() then
				var_106_1:setOpacity(0)
				UIAction:Add(RLOG(SPAWN(MOVE_TO(300, -390, 55), SEQ(FADE_IN(300), SHOW(false)))), var_106_1, "block")
			end
		end
	end
end

function BattleTopBar.setOpacity(arg_107_0, arg_107_1)
	arg_107_0.topbar_wnd:setOpacity(arg_107_1)
end

function BattleTopBar.updatePotion(arg_108_0)
	local var_108_0 = arg_108_0.topbar_wnd:getChildByName("n_potion")
	local var_108_1 = Battle.logic:getUsingPotionLimit()
	local var_108_2 = Battle.logic:getUsingPotionCount("default_potion")
	local var_108_3 = math.max(0, var_108_1 - var_108_2)
	
	if_set_visible(var_108_0, "noti_count", var_108_3 ~= 0)
	if_set(var_108_0, "count", var_108_3)
end

function BattleTopBar.showRTAPenalyTooltip(arg_109_0, arg_109_1)
	if not arg_109_0.vars or not get_cocos_refid(arg_109_0.vars.frenzy_tooltip) then
		return 
	end
	
	local var_109_0 = arg_109_0.vars.frenzy_tooltip:getChildByName("frenzy_tooltip_hud")
	
	var_109_0:setPosition(-300, -600)
	UIAction:Add(SEQ(CALL(function()
		var_109_0:getChildByName("btn_close"):setVisible(true)
		arg_109_0.vars.frenzy_tooltip:setVisible(true)
	end), MOVE_TO(300, -1310, -600)), var_109_0, "block")
end

function BattleTopBar.hideRTAPenalyTooltip(arg_111_0)
	if not arg_111_0.vars or not get_cocos_refid(arg_111_0.vars.frenzy_tooltip) then
		return 
	end
	
	local var_111_0 = arg_111_0.vars.frenzy_tooltip:getChildByName("frenzy_tooltip_hud")
	
	var_111_0:setPosition(-1310, -600)
	UIAction:Add(SEQ(MOVE_TO(300, -300, -600), CALL(function()
		var_111_0:getChildByName("btn_close"):setVisible(false)
		arg_111_0.vars.frenzy_tooltip:setVisible(false)
	end)), var_111_0, "block")
end

function BattleTopBar.updateRTAPenalyInfo(arg_113_0, arg_113_1)
	if Battle.logic:isRealtimeMode() or Battle:isReplayMode() then
		arg_113_0.vars.penalty_info = arg_113_0.vars.penalty_info or {}
		
		local var_113_0 = arg_113_0.topbar_wnd:getChildByName("btn_battle_frenzy")
		local var_113_1 = Battle.logic:getStageCounter()
		
		if var_113_1 == 0 then
			var_113_1 = 1
		end
		
		local var_113_2
		
		for iter_113_0 = 1, 10 do
			local var_113_3 = Battle.logic:getRtaPenaltyDB(iter_113_0)
			
			if var_113_3 then
				local var_113_4, var_113_5 = DB("pvp_rta_penalty", tostring(var_113_3.id), {
					"id",
					"turn"
				})
				
				if not var_113_4 then
					break
				end
				
				if to_n(var_113_5) > var_113_1 - 1 then
					var_113_2 = {
						id = iter_113_0 - 1,
						turn = var_113_5
					}
					
					break
				end
				
				var_113_2 = {
					id = iter_113_0,
					turn = var_113_5
				}
			end
		end
		
		arg_113_0.vars.prev_penalty_info = arg_113_0.vars.prev_penalty_info or {}
		
		if Battle:isReplayMode() then
			if arg_113_0.vars.penalty_info.id ~= var_113_2.id then
				arg_113_0.vars.penalty_info = var_113_2
				
				local var_113_6, var_113_7 = DB("pvp_rta_penalty", tostring(arg_113_0.vars.penalty_info.id), {
					"id",
					"turn"
				})
				
				arg_113_0.vars.prev_penalty_info.id = var_113_6
				arg_113_0.vars.prev_penalty_info.turn = var_113_7
			end
		elseif arg_113_0.vars.penalty_info.id ~= var_113_2.id then
			arg_113_0.vars.prev_penalty_info = arg_113_0.vars.penalty_info
			arg_113_0.vars.penalty_info = var_113_2
		end
		
		if_set_visible(var_113_0, "cm_battle_frenzy_p", arg_113_0.vars.penalty_info.id == 0)
		if_set_visible(var_113_0, "cm_battle_frenzy", false)
		
		local var_113_8 = var_113_0:getChildByName("icon_battle_frenzy")
		
		if not var_113_8:getChildByName("frenzy_bar") then
			local var_113_9 = var_113_8:getChildByName("cm_battle_frenzy")
			
			var_113_9:setVisible(false)
			
			arg_113_0.vars.frenzy_bar = WidgetUtils:createBarProgress("img/cm_icon_battle_frenzy.png", cc.p(0, 0.5), cc.p(1, 0))
			
			arg_113_0.vars.frenzy_bar:setName("frenzy_bar")
			arg_113_0.vars.frenzy_bar:setPercentage(0)
			arg_113_0.vars.frenzy_bar:setRotation(-90)
			arg_113_0.vars.frenzy_bar:setPosition(var_113_9:getPosition())
			var_113_8:addChild(arg_113_0.vars.frenzy_bar)
		end
		
		local var_113_10 = var_113_1 - (arg_113_0.vars.prev_penalty_info.turn or 0)
		local var_113_11 = arg_113_0.vars.penalty_info.turn - (arg_113_0.vars.prev_penalty_info.turn or 0)
		
		arg_113_0.vars.frenzy_bar:setPercentage(var_113_10 / var_113_11 * 100)
		
		arg_113_0.vars.penalty_info.rest = math.max(0, arg_113_0.vars.penalty_info.turn - var_113_1 + 1)
		arg_113_0.vars.penalty_info.total = var_113_11
		
		if_set(var_113_0, "t_turn", arg_113_0.vars.penalty_info.rest)
		if_set(var_113_0, "t_step", arg_113_0.vars.penalty_info.id)
		arg_113_0:updateRTAPenaltyTooltipInfo(arg_113_0.vars.penalty_info.id)
	end
end

function BattleTopBar.updateRTAPenaltyTooltipInfo(arg_114_0, arg_114_1)
	local var_114_0 = math.min(arg_114_1 + 1, 9)
	
	if_set(arg_114_0.vars.frenzy_tooltip, "t_battle_frenzy", T("pvp_rta_battle_frenzy_step", {
		step_no = arg_114_1
	}))
	if_set(arg_114_0.vars.frenzy_tooltip, "t_turn", T("pvp_rta_battle_frenzy_next", {
		next_no = var_114_0
	}))
	if_set(arg_114_0.vars.frenzy_tooltip, "t_Increase_effect", T("pvp_rta_increase_eff"))
	if_set(arg_114_0.vars.frenzy_tooltip, "t_reduction_effect", T("pvp_rta_decrease_eff"))
	
	local var_114_1 = Battle.logic:getRtaPenaltyDB(arg_114_1) or {}
	local var_114_2 = Battle.logic:getRtaPenaltyDB(var_114_0) or {}
	local var_114_3 = DBT("pvp_rta_penalty", tostring(var_114_1.id), {
		"cs_good1",
		"cs_good1_value",
		"cs_good2",
		"cs_good2_value",
		"cs_good3",
		"cs_good3_value",
		"cs_harm1",
		"cs_harm1_value",
		"cs_harm2",
		"cs_harm2_value",
		"cs_harm3",
		"cs_harm3_value"
	})
	local var_114_4 = DBT("pvp_rta_penalty", tostring(var_114_2.id), {
		"cs_good1",
		"cs_good1_value",
		"cs_good2",
		"cs_good2_value",
		"cs_good3",
		"cs_good3_value",
		"cs_harm1",
		"cs_harm1_value",
		"cs_harm2",
		"cs_harm2_value",
		"cs_harm3",
		"cs_harm3_value"
	})
	
	local function var_114_5(arg_115_0)
		if not arg_115_0 then
			return "0%"
		elseif arg_115_0 > 0 then
			return "+" .. tostring(arg_115_0) .. "%"
		else
			return tostring(arg_115_0) .. "%"
		end
	end
	
	for iter_114_0, iter_114_1 in pairs({
		"good",
		"harm"
	}) do
		for iter_114_2 = 1, 3 do
			local var_114_6 = arg_114_0.vars.frenzy_tooltip:getChildByName("n_" .. iter_114_1 .. tostring(iter_114_2))
			
			if var_114_6 then
				var_114_6:setVisible(true)
				
				local var_114_7 = "cs_" .. iter_114_1 .. iter_114_2
				local var_114_8 = "cs_" .. iter_114_1 .. iter_114_2 .. "_value"
				
				if_set(var_114_6, "t_text", T(var_114_4[var_114_7]))
				if_set(var_114_6, "t_point", var_114_5(var_114_3[var_114_8]))
				if_set(var_114_6, "t_next_point", var_114_5(var_114_4[var_114_8]))
			end
		end
	end
end

function BattleTopBar.updatePVPPenaltyInfo(arg_116_0, arg_116_1)
	arg_116_1 = arg_116_1 or {}
	arg_116_0.vars.penalty_node = arg_116_0.topbar_wnd:getChildByName("n_punish")
	
	if not arg_116_0.vars.penalty_node then
		return 
	end
	
	if arg_116_1.rest < 1 then
		arg_116_1.rest = 0
	end
	
	arg_116_0.vars.penalty_node:setVisible(true)
	
	local var_116_0 = arg_116_0.vars.penalty_node:getChildByName("tooltip")
	
	var_116_0:setVisible(false)
	
	local var_116_1 = arg_116_0.vars.penalty_node:getChildByName("n_hud_skill")
	
	if not var_116_1 then
		return 
	end
	
	upgradeLabelToRichLabel(var_116_0, "txt_desc")
	upgradeLabelToRichLabel(var_116_0, "data1")
	
	local var_116_2 = var_116_1:getChildByName("penalty_icon")
	
	if not get_cocos_refid(var_116_2) then
		var_116_2 = UIPenaltyButton:create({
			listener = arg_116_0,
			callbackActive = function(arg_117_0)
				arg_116_0:onPenaltyActive(arg_117_0)
			end
		})
		
		var_116_1:addChild(var_116_2)
	end
	
	var_116_2:updateInfo(arg_116_1.db_turn, arg_116_1.rest, arg_116_1.cool, arg_116_1.damage)
	arg_116_0.vars.penalty_node:getChildByName("t_turn"):setString(tostring(arg_116_1.rest - 1))
end

function BattleTopBar.initPenaltyInfo(arg_118_0, arg_118_1, arg_118_2)
	if not arg_118_0.vars.penalty_node then
		return 
	end
	
	local var_118_0, var_118_1, var_118_2, var_118_3 = DB("pvp_penalty", arg_118_1, {
		"name",
		"icon",
		"desc",
		"dmg_desc"
	})
	local var_118_4 = arg_118_0.vars.penalty_node:getChildByName("tooltip")
	
	var_118_4:setVisible(true)
	var_118_4:setOpacity(0)
	if_set(var_118_4, "txt_name", T(var_118_0))
	if_set(var_118_4, "txt_desc", T(var_118_2))
	if_set(var_118_4, "data1", T(var_118_3, {
		damage = arg_118_2
	}))
	
	local var_118_5 = var_118_4:getChildByName("skill_icon")
	local var_118_6 = "skill/" .. var_118_1 .. ".png"
	
	SpriteCache:resetSprite(var_118_5, var_118_6)
end

function BattleTopBar.showPenaltyInfo(arg_119_0)
	if not arg_119_0.vars.penalty_node then
		return 
	end
	
	local var_119_0 = arg_119_0.vars.penalty_node:getChildByName("tooltip")
	
	var_119_0:setOpacity(255)
	
	local var_119_1 = arg_119_0.vars.penalty_node:getChildByName("txt_desc"):getStringNumLines()
	local var_119_2 = 20 * math.clamp(var_119_1 - 4, 0, 10)
	
	var_119_0:setContentSize(440, 330 + var_119_2)
	arg_119_0.vars.penalty_node:getChildByName("n_top"):setPositionY(0 + var_119_2)
end

function BattleTopBar.hidePenaltyInfo(arg_120_0)
	if not arg_120_0.vars.penalty_node then
		return 
	end
	
	arg_120_0.vars.penalty_node:getChildByName("tooltip"):setVisible(false)
end

function BattleTopBar.onPenaltyActive(arg_121_0, arg_121_1)
	if not arg_121_0.vars.penalty_node then
		return 
	end
	
	if_set_visible(arg_121_0.vars.penalty_node, "t_turn", arg_121_1)
	if_set_visible(arg_121_0.vars.penalty_node, "i_turn", arg_121_1)
end

function BattleTopBar.applicationDidEnterBackground(arg_122_0)
	print("BattleTopBar.applicationDidEnterBackground")
	
	if IS_ANDROID_BASED_PLATFORM and getenv("allow.battle_pause", "") == "1" then
		arg_122_0.time_didEnterBackground = os.time()
	end
end

function BattleTopBar.applicationWillenterForeground(arg_123_0)
	print("BattleTopBar.applicationWillenterForeground")
	print("allow.battle_pause : ", getenv("allow.battle_pause", ""))
	
	if IS_ANDROID_BASED_PLATFORM and getenv("allow.battle_pause", "") == "1" then
		print("time : ", arg_123_0.time_didEnterBackground, os.time())
		
		if arg_123_0.time_didEnterBackground and os.time() - arg_123_0.time_didEnterBackground > 1 and not is_playing_story() then
			arg_123_0:pause()
		end
	end
end

function BattleTopBar.isUseTurnInfo(arg_124_0)
	if arg_124_0.logic and arg_124_0.logic.map and arg_124_0.logic.map.enter then
		return DB("level_enter", arg_124_0.logic.map.enter, "turn_ui_show") == "y"
	end
	
	return false
end

function BattleTopBar.setTurnInfo(arg_125_0, arg_125_1)
	if get_cocos_refid(arg_125_0.topbar_wnd) then
		local var_125_0 = arg_125_0.topbar_wnd:getChildByName("n_turn")
		
		if get_cocos_refid(var_125_0) then
			if_set(var_125_0, "disc", T("turn_progress", {
				turn = arg_125_1
			}))
		end
	end
end
