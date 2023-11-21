Lobby = Lobby or {}

function HANDLER.notice(arg_1_0, arg_1_1)
	UIAction:Add(SEQ(FADE_OUT(250), REMOVE()), getParentWindow(arg_1_0), "block")
end

function HANDLER.bartender(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_back" then
		Lobby:toggleBartenderMode()
	end
end

function HANDLER.calendar(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		Lobby:closeAttendance(arg_3_0)
	end
end

function HANDLER.calendar_7days(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		Lobby:closeAttendance(arg_4_0)
	end
end

function HANDLER.calendar_7days_sp(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		Lobby:closeAttendance(arg_5_0)
	end
end

function HANDLER.calendar_7_consecutive(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" then
		Lobby:closeAttendance(arg_6_0)
	end
end

function HANDLER.calendar_7_consecutive_sp(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_close" then
		Lobby:closeAttendance(arg_7_0)
	end
end

function HANDLER.calendar_14days(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_close" then
		Lobby:closeAttendance(arg_8_0)
	end
end

function HANDLER.lobby(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if get_cocos_refid(arg_9_0) and arg_9_3 and arg_9_4 then
		UIUtil:checkBtnTouchPos(arg_9_0, arg_9_3, arg_9_4)
	end
	
	RingMenu:hide()
	
	if string.starts(arg_9_1, "btn_char") then
		local var_9_0 = tonumber(string.sub(arg_9_1, -1, -1))
		
		Lobby:onTouchUnit(var_9_0)
	elseif arg_9_1 == "btn_goout" then
		Lobby:goOut()
	elseif arg_9_1 == "btn_bartender" then
		Lobby:toggleBartenderMode()
	elseif arg_9_1 == "btn_hero" then
		Lobby:toggleUnitMenuShortCut()
	elseif arg_9_1 == "btn_team" then
		if UnlockSystem:isUnlockSystemAndMsg({
			id = "system_078",
			exclude_story = true
		}, function()
		end) and not Lobby:req_lobbyPetGift() then
			SceneManager:nextScene("unit_ui")
		end
	elseif arg_9_1 == "btn_recruit" then
		Lobby:toggleUnitMenuShortCut()
		HeroRecruit:open()
	elseif string.starts(arg_9_1, "btn_unit_") then
		Lobby:openUnitUI(string.sub(arg_9_1, 10, -1))
	elseif arg_9_1 == "btn_growth_guide" then
		if UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.GROWTH_GUIDE
		}, function()
		end) then
			SceneManager:nextScene("growth_guide")
		end
	elseif arg_9_1 == "btn_growth_guide_talk" then
		if UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.GROWTH_GUIDE
		}, function()
		end) then
			SceneManager:nextScene("growth_guide", {
				quest_id = arg_9_0.quest_id
			})
		end
	elseif arg_9_1 == "btn_gacha_inven" then
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.GACHA
		}, function()
			GachaTempInventory:showPopup()
		end)
	elseif arg_9_1 == "btn_scene_collection" then
		if not Account:checkQueryEmptyDungeonData("collection.booklist") then
			CollectionController:open()
		end
	elseif arg_9_1 == "btn_storage" then
		UnlockSystem:isUnlockSystemAndMsg({
			replace_title = "waitingroom_title",
			exclude_story = true,
			id = UNLOCK_ID.GACHA
		}, function()
			TopBarNew:closeQuickMenu()
			SceneManager:nextScene("waitingroom")
		end)
	elseif arg_9_1 == "btn_blessing" and UnlockSystem:isUnlockSystemAndMsg({
		replace_title = "ui_gb_title",
		exclude_story = true,
		id = UNLOCK_ID.GROWTH_BOOST_1
	}, function()
	end) then
		GrowthBoostUI:show()
	end
end

function MsgHandler.friend_count(arg_16_0)
	SceneManager:dispatchGameEvent("friend_count", arg_16_0)
end

function MsgHandler.test_get_server_time(arg_17_0)
	if arg_17_0.tm then
		local var_17_0 = os.date("%y", arg_17_0.tm)
		local var_17_1 = os.date("%m", arg_17_0.tm)
		local var_17_2 = os.date("%d", arg_17_0.tm)
		local var_17_3 = os.date("%H", arg_17_0.tm)
		local var_17_4 = os.date("%M", arg_17_0.tm)
		
		Dialog:msgBox(var_17_0 .. ". " .. var_17_1 .. "/" .. var_17_2 .. " " .. var_17_3 .. ":" .. var_17_4)
	end
end

function MsgHandler.bring_pet(arg_18_0)
	Lobby:recive_lobbyPetGift(arg_18_0)
end

function ErrHandler.bring_pet(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_1 == "yet_time" then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	on_net_error(arg_19_0, arg_19_1, arg_19_2)
end

function MsgHandler.lobby_update(arg_20_0)
	ContentDisable:resetContentSwitchMain(arg_20_0.content_switch)
	GrowthGuideNavigator:updateVisibleByContentDisable()
	Account:updateCurrencies(arg_20_0.currencies)
	TopBarNew:topbarUpdate(true)
	Lobby:updateGrowthGuide()
	
	if arg_20_0.notice_urls then
		Stove:setCommunityUrls("patchnote", arg_20_0.notice_urls.update_note)
		Stove:setCommunityUrls("developer", arg_20_0.notice_urls.developer_note)
		Stove:setCommunityUrls("notice", arg_20_0.notice_urls.notice_note)
		Stove:setCommunityUrls("enhance_rate_info", arg_20_0.notice_urls.enhance_rate_info)
	end
	
	Account:updateFriendCounts(arg_20_0)
	TopBarNew:updateFriendRequested()
	Account:setClanId(arg_20_0.clan_id)
	
	if arg_20_0.clan_noti_flag then
		TopBarNew:setForceClanNoti(true)
	else
		TopBarNew:setForceClanNoti(false)
	end
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.boosters or {}) do
		AccountSkill:setAccountSkill(iter_20_1.skill_id, iter_20_1)
		Booster:resetUIBooster()
	end
	
	if arg_20_0.clan_mission_attrbutes then
		Account:resetConditonsByContentsType()
		Account:setClanMissions(arg_20_0.clan_mission_attrbutes)
	end
	
	if arg_20_0.mail_list then
		AccountData.mails = arg_20_0.mail_list
		Lobby.last_mail_check_time = os.time()
	end
	
	if arg_20_0.account_data_update then
		for iter_20_2, iter_20_3 in pairs(arg_20_0.account_data_update) do
			AccountData[iter_20_2] = iter_20_3
		end
		
		Account:updateLotaTeamInfo()
		
		local var_20_0 = arg_20_0.account_data_update.music_box_info
		
		if var_20_0 then
			if not MusicBox:isValid() then
				MusicBox:init()
			end
			
			MusicBox:setServerData(var_20_0)
			MusicBox:load()
			
			if SceneManager:getCurrentSceneName() == "arena_net_lounge" then
				ArenaNetMusicBox:show({
					service = ArenaNetLounge.vars.service,
					cur_bgm_id = ArenaNetLounge.vars.bgm_id,
					callback = function(arg_21_0)
						ArenaNetLounge:onChangeBGM(arg_21_0)
					end
				})
			end
		end
		
		if arg_20_0.account_data_update.is_return_user_cond then
			Singular:event("return_user_info")
		end
	end
	
	if arg_20_0.calc_friend_point then
		AccountData.calc_friend_point = arg_20_0.calc_friend_point
	end
	
	if arg_20_0.iap_responses then
		AccountData.iap_responses = arg_20_0.iap_responses
	end
	
	if arg_20_0.user_config then
		AccountData.user_config = arg_20_0.user_config
	end
	
	local var_20_1 = Account:getLobbyCount() or 0
	
	if var_20_1 == 0 then
		SAVE:removeExpireConfigDatas()
		BattleRepeat:initOnce()
	end
	
	if arg_20_0.teams then
		Account:setTeams(arg_20_0.teams)
		
		local var_20_2 = Account:getUserConfigs("descent_team")
		
		if var_20_2 then
			local var_20_3 = json.decode(var_20_2) or {}
			
			for iter_20_4, iter_20_5 in pairs(var_20_3.teams or {}) do
				local var_20_4 = to_n(iter_20_4)
				
				if var_20_4 == 22 or var_20_4 == 23 or var_20_4 == 24 then
					for iter_20_6, iter_20_7 in pairs(iter_20_5.team or {}) do
						local var_20_5 = Account:getUnit(iter_20_7)
						
						if var_20_5 then
							local var_20_6 = var_20_4 + 1
							
							if not Account:isInTeam(var_20_5, var_20_6) then
								var_20_5:removeFromTeam(var_20_6)
							end
						end
					end
				end
			end
		end
		
		local var_20_7 = Account:getUserConfigs("burning_team")
		
		if var_20_7 then
			local var_20_8 = json.decode(var_20_7) or {}
			
			for iter_20_8, iter_20_9 in pairs(var_20_8.teams or {}) do
				local var_20_9 = to_n(iter_20_8)
				
				if var_20_9 == 26 or var_20_9 == 27 then
					for iter_20_10, iter_20_11 in pairs(iter_20_9.team or {}) do
						local var_20_10 = Account:getUnit(iter_20_11)
						
						if var_20_10 then
							local var_20_11 = var_20_9 + 1
							
							if not Account:isInTeam(var_20_10, var_20_11) then
								var_20_10:removeFromTeam(var_20_11)
							end
						end
					end
				end
			end
		end
	end
	
	if DEBUG.DEBUG_DELETE_LOG then
		Log.e("삭제 완료 로그")
		table.print(arg_20_0.delete_useless_data)
	end
	
	if arg_20_0.delete_useless_data then
		if arg_20_0.delete_useless_data.story then
			Account:deletePlayedStories(arg_20_0.delete_useless_data.story)
		end
		
		if arg_20_0.delete_useless_data.d_mission then
			Account:deleteDungeonMissoins(arg_20_0.delete_useless_data.d_mission)
		end
	end
	
	local var_20_12 = Account:serverTimeDayLocalDetail()
	
	if AccountData.server_time.today_day_id == var_20_12 then
		Account:setLobbyCount(var_20_1 + 1)
	end
	
	TopBarNew:updateSeasonPass()
	Lobby:LobbyUpdateAfterUI()
	
	if arg_20_0.clan_buff_docs then
		Account:setClanBuffInfos(arg_20_0.clan_buff_docs)
	end
	
	TopBarNew:setupCustomWebEventNotification()
	TopBarNew:checkPackageNotifications()
	TopBarNew:updateVisibleByContentDisable()
	TopBarNew:showE7WCTimeBalloon()
	TopBarNew:showEventBalloon()
	TopBarNew:showCustomWebEventNotification()
	TopBarNew:updateE7WCBalloon()
	TopBarNew:updateMoonlightDestiny()
	TopBarNew:updateBattleBalloon()
	print("Chat Init")
	ChatMain:init()
	GlobalSubstoryManager:updateSubstory()
	BackPlayManager:init()
	
	if arg_20_0.reset_faction then
		AchievementBase:updateResetInfo(arg_20_0.reset_faction)
	end
	
	if arg_20_0.atmt_season_info then
		Account:setCurrentAtmtSeason(arg_20_0.atmt_season_info)
	end
	
	if arg_20_0.trial_hall_rank then
		Account:setTrialHallRankInfo(arg_20_0.trial_hall_rank)
	end
	
	ConditionContentsManager:initConditionsLobbyUpdate()
	TopBarNew:updateAchieveButton()
	Shop:checkShopNewBossUnits()
	TopBarNew:updateMailMark()
	NewNotice:cleanUp()
	
	if arg_20_0 and arg_20_0.abuse_filter then
		add_abuse_filter_list(arg_20_0.abuse_filter)
	end
	
	StoryAction:RemoveAll()
	Lobby:updateBanners(arg_20_0.notice_banners)
	ConditionContentsManager:updateEventMissionConditionDispatch({
		ignore_migration = true
	})
end

function Lobby.LobbyUpdateAfterUI(arg_22_0)
	arg_22_0.vars.is_lobby_update_after = true
	
	if SceneManager:getCurrentSceneName() == "lobby" then
		Lobby:createNoti()
		BoosterUI:update(TopBarNew:getMainHud())
	end
end

function Lobby.create(arg_23_0, arg_23_1)
	arg_23_0.vars = {}
	arg_23_0.childs = {}
	
	local var_23_0 = cc.Layer:create()
	
	arg_23_0.vars.base_layer = var_23_0
	arg_23_0.vars.bar_layer = cc.Layer:create()
	
	arg_23_0.vars.bar_layer:setAnchorPoint(0.8, 0.7)
	
	arg_23_0.vars.out_layer = cc.Layer:create()
	
	arg_23_0.vars.out_layer:setAnchorPoint(0.2, 0.8)
	
	arg_23_0.vars.layer = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	arg_23_0.vars.layer:setScale(1)
	CustomLobby:loadUserConfigData()
	
	local var_23_1 = arg_23_0:isAlternativeLobby()
	
	local function var_23_2()
		arg_23_0:setupBar(arg_23_0.vars.layer)
		arg_23_0.vars.bar_layer:addChild(arg_23_0.vars.layer)
		arg_23_0.vars.out_layer:addChild(arg_23_0.vars.bar_layer)
		var_23_0:addChild(arg_23_0.vars.out_layer)
	end
	
	CustomLobbyIllust.Util:removeAllScheduler()
	
	if var_23_1 and xpcall(arg_23_0.setupCustomLobby, function(arg_25_0)
		var_23_1 = false
		
		SAVE:setKeep("custom_lobby.mode", "default")
		__G__TRACKBACK__(arg_25_0)
	end, arg_23_0, arg_23_0.vars.bar_layer) then
		var_23_0:addChild(arg_23_0.vars.bar_layer)
	end
	
	if not var_23_1 then
		var_23_2()
	end
	
	TopBarNew:createMainHUD(SceneManager:getRunningUIScene(), true, var_23_1)
	
	arg_23_0.vars.open_sub_story = arg_23_1 and arg_23_1.open_sub_story
	
	if not arg_23_0.vars.open_sub_story then
		TopBarNew:setOpacity(0)
	end
	
	if not var_23_1 then
		arg_23_0:setupTeamUnits()
	end
	
	arg_23_0:setupLobbyUI()
	
	if not var_23_1 then
		arg_23_0:setupRandomRewardSysCharacter()
		arg_23_0:setupLobbyPet()
	else
		arg_23_0:setupLobbyPetAltLobby()
		arg_23_0:setupPubAlternativeLobby(TopBarNew:getMainHud())
		arg_23_0:setupFuchiAlternativeLobby(TopBarNew:getMainHud())
	end
	
	TopBarNew:updateFeedButton()
	SceneManager:resetSceneFlow()
	Scheduler:addSlow(arg_23_0.vars.ui_layer, arg_23_0.update, arg_23_0):setName("lobby_update_slow")
	
	arg_23_0.vars.opts = arg_23_1 or {}
	
	if arg_23_1 and arg_23_1.unlock_id then
		arg_23_0.vars.unlock_id = arg_23_1.unlock_id
	end
	
	arg_23_0.vars.noti_flag = true
	
	if cc.UserDefault:getInstance():getBoolForKey("tune.new_start", false) and not cc.UserDefault:getInstance():getBoolForKey("tune.new_enter_lobby", false) then
		Singular:event("first_lobby")
		print("Singular Log : new_enter_lobby")
		cc.UserDefault:getInstance():setBoolForKey("tune.new_enter_lobby", true)
	end
	
	if IS_PUBLISHER_ZLONG and getenv("zlong.download_reward_enable", "false") == "true" and not cc.UserDefault:getInstance():getBoolForKey("download_reward_disable", false) then
		cc.UserDefault:getInstance():setBoolForKey("download_reward_disable", true)
	end
	
	ArenaNetNotifier:init({
		max_visible = 3
	})
	
	if arg_23_0:isAlternativeLobby() then
		arg_23_0:applyTintColor(arg_23_0.vars.bar_layer, SceneManager:getRunningUIScene())
	end
	
	return var_23_0
end

function Lobby.createNotiSeq(arg_26_0, arg_26_1)
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		return 
	end
	
	if SubStoryEntrance:isVisible() then
		return 
	end
	
	arg_26_1 = arg_26_1 or {}
	arg_26_0.vars.noti_layer = cc.Layer:create()
	
	arg_26_0.vars.noti_layer:setName("noti_layer")
	
	arg_26_0.vars.seq = Sequencer:init()
	
	arg_26_0.vars.seq:getLayer():addChild(arg_26_0.vars.noti_layer)
	arg_26_0:setNotiFlag(true)
	arg_26_0.vars.seq:addRaw(arg_26_0.checkWebEventRedDot, arg_26_0)
	arg_26_0.vars.seq:addRaw(arg_26_0.checkStoveNoti, arg_26_0)
	
	local var_26_0 = Account:getAttendanceEventsBySubTypes("30days", "7days", "14days")
	
	arg_26_0.vars.seq:addRaw(arg_26_0.beforeCheckAttendanceEvent, arg_26_0)
	
	if not table.empty(var_26_0) then
		for iter_26_0, iter_26_1 in pairs(var_26_0) do
			arg_26_0.vars.seq:addRaw(arg_26_0.checkAttendanceEvent, arg_26_0, iter_26_0, iter_26_1)
		end
		
		local var_26_1 = Account:getReturnAttendanceEvent()
		
		if var_26_1 then
			arg_26_0.vars.seq:addRaw(arg_26_0.checkAttendanceEvent, arg_26_0, #var_26_0 + 1, var_26_1)
		end
	end
	
	arg_26_0.vars.seq:addRaw(arg_26_0.checkDailyBonus, arg_26_0)
	arg_26_0.vars.seq:addRaw(arg_26_0.checkPreviewUnit, arg_26_0)
	arg_26_0.vars.seq:addRaw(arg_26_0.checkFriendPointCalculate, arg_26_0)
	arg_26_0.vars.seq:addRaw(arg_26_0.checkSubTaskComplete, arg_26_0)
	arg_26_0.vars.seq:addRaw(arg_26_0.checkNewBooster, arg_26_0)
	arg_26_0.vars.seq:addAsync(arg_26_0.clearNoti, arg_26_0)
	arg_26_0.vars.seq:play(SceneManager:getRunningPopupScene())
	
	arg_26_0.vars.seq_created = true
end

function Lobby.nextNoti(arg_27_0, arg_27_1)
	if not arg_27_0.vars.seq then
		return 
	end
	
	if arg_27_1 and get_cocos_refid(arg_27_0.vars.noti_layer) then
		arg_27_0.vars.noti_layer:removeAllChildren()
	end
	
	arg_27_0.vars.seq:next(true, true)
	
	if arg_27_0.vars.seq and not arg_27_0.vars.seq:isEmpty() then
		LuaEventDispatcher:dispatchEvent("invite.event", "hide")
	end
end

function Lobby.checkStoveNoti(arg_28_0)
	if not Stove.enable then
		return arg_28_0:nextNoti()
	end
	
	if not Login.FSM:isCurrentState("STANDBY") then
		return arg_28_0:nextNoti()
	end
	
	if Stove.vars.touch_notice then
		return arg_28_0:nextNoti()
	end
	
	Stove.vars.touch_notice = true
	
	Login.FSM:changeState(LoginState.STOVE_VIEW_AUTO, {
		callback = function()
			arg_28_0:nextNoti()
		end
	})
end

function Lobby.checkWebEventRedDot(arg_30_0)
	if IS_PUBLISHER_ZLONG then
		TopBarNew:updateWebEventNoti(false)
		Zlong:reqIsRedDotWebEvent({
			callback = function(arg_31_0)
				TopBarNew:updateWebEventNoti(arg_31_0)
			end
		})
	else
		WebEventPopUp:queryRedDot("Y")
	end
	
	return arg_30_0:nextNoti()
end

function Lobby.getLayer(arg_32_0)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.ui_layer) then
		return 
	end
	
	return arg_32_0.vars.ui_layer
end

function Lobby.getBarLayer(arg_33_0)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.ui_layer) then
		return 
	end
	
	return arg_33_0.vars.bar_layer
end

function Lobby.checkNotiSeqActive(arg_34_0)
	return arg_34_0.vars.seq and not arg_34_0.vars.seq:isEmpty()
end

function Lobby.closeAttendance(arg_35_0)
	if not get_cocos_refid(arg_35_0.vars.calendar) then
		return 
	end
	
	BackButtonManager:pop("Dialog.calendar")
	
	if arg_35_0.vars.seq then
		Lobby:nextNoti(true)
	else
		if get_cocos_refid(arg_35_0.vars.calendar) then
			arg_35_0.vars.calendar:removeFromParent()
			
			if arg_35_0.vars.has_open_webevent then
				if WebEventPopUp:isShowWebView() then
					WebEventPopUp:showWebView(true)
				else
					if_set_visible(WebEventPopUp:getWindow(), "n_event_banner", WebEventPopUp:getSelectedEvent().is_category == "total")
				end
			end
		end
		
		if arg_35_0.vars.calendar_current < arg_35_0.vars.calendar_count then
			local var_35_0 = Account:getEvents().attendance or {}
			local var_35_1 = arg_35_0.vars.calendar_current + 1
			local var_35_2 = {
				option = true,
				current = var_35_1,
				calendar_count = arg_35_0.vars.calendar_count
			}
			
			Lobby:showAttendanceEvent(var_35_0[var_35_1], var_35_2)
		end
	end
end

function Lobby.showAttendanceEvent(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_1 then
		Log.e("Lobby.showAttendanceEvent", "no_event")
		
		return 
	end
	
	arg_36_2 = arg_36_2 or {}
	
	local var_36_0
	local var_36_1
	local var_36_2
	local var_36_3 = false
	local var_36_4 = arg_36_1.sub_type
	
	for iter_36_0, iter_36_1 in pairs(arg_36_1.info.days) do
		if iter_36_1.rank then
			var_36_3 = true
			
			break
		end
	end
	
	local var_36_5 = true
	
	if var_36_4 == "30days" then
		var_36_2 = arg_36_2.csb_name or "wnd/calendar"
		var_36_5 = false
	elseif var_36_4 == "7days" then
		if arg_36_1.continue_reward_id and arg_36_1.continue_reward_count then
			if var_36_3 then
				var_36_2 = "wnd/calendar_7_consecutive_sp"
			else
				var_36_2 = "wnd/calendar_7_consecutive"
			end
		elseif var_36_3 then
			var_36_2 = arg_36_2.csb_name or "wnd/calendar_7days_sp"
		else
			var_36_2 = arg_36_2.csb_name or "wnd/calendar_7days"
		end
	elseif var_36_4 == "14days" then
		var_36_2 = "wnd/calendar_14days"
	end
	
	if var_36_4 == "30days" then
		var_36_0 = 5
		var_36_1 = 7
	elseif var_36_4 == "7days" then
		var_36_0 = 1
		var_36_1 = 7
	elseif var_36_4 == "14days" then
		var_36_0 = 2
		var_36_1 = 7
	end
	
	local var_36_6 = arg_36_1.progress_day
	local var_36_7 = var_36_6 - 1
	local var_36_8 = var_36_7 and var_36_6 <= var_36_7
	
	if arg_36_2.option or arg_36_1.failed_reward_level then
		var_36_8 = true
	end
	
	local var_36_9 = false
	
	if arg_36_2.current and arg_36_2.calendar_count then
		arg_36_0.vars.calendar_count = arg_36_2.calendar_count
		arg_36_0.vars.calendar_current = arg_36_2.current
	else
		arg_36_0.vars.calendar_count = 0
		arg_36_0.vars.calendar_current = 0
	end
	
	local var_36_10 = Dialog:open(var_36_2, arg_36_0, {
		back_func = function()
			Lobby:closeAttendance()
		end
	})
	
	arg_36_0.vars.calendar = var_36_10
	
	if arg_36_1.image and arg_36_1.image ~= "" then
		if_set_sprite(var_36_10, "image", string.format("banner/%s.png", arg_36_1.image))
	end
	
	if_set(var_36_10, "t_title", T(arg_36_1.title))
	
	local var_36_11 = var_36_4 == "30days" and arg_36_1["repeat"] and arg_36_1["repeat"] == "n"
	
	if_set_visible(var_36_10, "txt_info", var_36_11)
	
	if var_36_11 and var_36_10:getChildByName("txt_info"):getStringNumLines() >= 2 then
		local var_36_12 = var_36_10:getChildByName("t_last_0")
		
		var_36_12:setPositionY(var_36_12:getPositionY() - 9)
	end
	
	var_36_10:setOpacity(0)
	UIAction:Add(LOG(OPACITY(600, 0, 1)), var_36_10, "block")
	
	local var_36_13 = var_36_10:getChildByName("n_portrait")
	
	if get_cocos_refid(var_36_13) then
		local var_36_14 = UIUtil:getPortraitAni("npc1004", {
			pin_sprite_position_y = true
		})
		
		if get_cocos_refid(var_36_14) then
			var_36_14:setScale(0.87)
			var_36_13:removeAllChildren()
			var_36_13:addChild(var_36_14)
		end
	end
	
	local var_36_15 = 0
	local var_36_16 = arg_36_2.parent or Lobby.vars.noti_layer
	
	if not get_cocos_refid(var_36_16) then
		var_36_16 = SceneManager:getRunningPopupScene()
	end
	
	var_36_16:addChild(var_36_10)
	
	for iter_36_2 = 1, var_36_0 do
		local var_36_17 = var_36_10:getChildByName("n_week" .. iter_36_2)
		
		if not var_36_17 then
			break
		end
		
		for iter_36_3 = 1, var_36_1 do
			local var_36_18 = var_36_17:getChildByName("n_d" .. iter_36_3)
			
			if not get_cocos_refid(var_36_18) then
				break
			end
			
			local var_36_19 = (iter_36_2 - 1) * 7 + iter_36_3
			local var_36_20 = arg_36_1.info.days[var_36_19]
			
			if not var_36_20 then
				if_set_visible(var_36_18, nil, false)
				if_set_visible(var_36_17, "icon_check" .. iter_36_3, false)
				if_set_visible(var_36_17, "title_bg" .. iter_36_3, false)
			else
				local var_36_21 = var_36_17:getChildByName("n_rank" .. iter_36_3)
				local var_36_22 = var_36_17:getChildByName("icon_check" .. iter_36_3)
				local var_36_23 = var_36_17:getChildByName("title_bg" .. iter_36_3)
				local var_36_24
				
				if var_36_4 == "14days" then
					var_36_24 = var_36_17:getChildByName("n_" .. iter_36_3)
				end
				
				if var_36_20.rank and get_cocos_refid(var_36_21) then
					UIUtil:setLevel(var_36_21, var_36_20.rank, MAX_ACCOUNT_LEVEL, 2)
				elseif var_36_20.rank == nil and get_cocos_refid(var_36_21) then
					var_36_21:setVisible(false)
				end
				
				if arg_36_1.failed_reward_level and var_36_20.rank == arg_36_1.failed_reward_level and var_36_20.rank and var_36_20.rank > Account:getLevel() and not var_36_9 then
					if_set_visible(var_36_17, "n_not_enough" .. iter_36_3, true)
					
					var_36_9 = true
				else
					if_set_visible(var_36_17, "n_not_enough" .. iter_36_3, false)
				end
				
				var_36_15 = var_36_19
				
				local var_36_25 = var_36_20.item_code or var_36_20.item_type
				local var_36_26 = var_36_20.item_count
				
				UIUtil:getRewardIcon(var_36_26, var_36_25, {
					parent = var_36_18
				})
				
				local var_36_27
				
				if get_cocos_refid(var_36_24) then
					var_36_27 = var_36_24:getChildByName("t_day")
				elseif get_cocos_refid(var_36_23) then
					var_36_27 = var_36_23:getChildByName("t_day")
				end
				
				if_set(var_36_27, nil, T("remain_day_single", {
					day = var_36_19
				}))
				if_set_visible(var_36_23, nil, not not var_36_20)
				if_set_visible(var_36_18, "select", false)
				
				if get_cocos_refid(var_36_24) and get_cocos_refid(var_36_21) and var_36_21:isVisible() then
					var_36_18:setPositionY(var_36_18:getPositionY() + 16)
					
					if get_cocos_refid(var_36_22) then
						var_36_22:setPositionY(var_36_22:getPositionY() + 16)
					end
				end
				
				if var_36_19 < var_36_6 then
					if_set_visible(var_36_22, nil, true)
					if_set_opacity(var_36_5 and var_36_23, nil, 76)
					var_36_18:setOpacity(76)
				elseif var_36_19 == var_36_6 then
					if var_36_8 then
						if_set_visible(var_36_22, nil, true)
						if_set_opacity(var_36_5 and var_36_23, nil, 76)
						var_36_18:setOpacity(76)
					else
						local var_36_28 = var_36_10
						local var_36_29, var_36_30 = var_36_17:getPosition()
						local var_36_31, var_36_32 = var_36_18:getPosition()
						local var_36_33 = var_36_29 + var_36_31
						local var_36_34 = var_36_30 + var_36_32
						
						if get_cocos_refid(var_36_24) then
							var_36_28 = var_36_24
							var_36_33, var_36_34 = var_36_31, var_36_32
						end
						
						if get_cocos_refid(var_36_22) then
							UIAction:Add(SEQ(SHOW(false), CALL(EffectManager.Play, EffectManager, {
								fn = "ui_calendar_eff.cfx",
								pivot_z = 99998,
								layer = var_36_28,
								pivot_x = var_36_33,
								pivot_y = var_36_34
							}), DELAY(470), CALL(function()
								balloon_message_with_sound("sended_prize")
							end), SHOW(true), CALL(if_set_opacity, var_36_5 and var_36_23, nil, 76), CALL(if_set_opacity, var_36_18, nil, 76)), var_36_22, "block")
						end
						
						SAVE:save()
					end
				else
					if_set_visible(var_36_22, nil, false)
				end
			end
		end
	end
	
	if var_36_4 == "30days" then
		UIUtil:playNPCSoundRandomly("mail.enter")
		
		local var_36_35 = math.min(var_36_15, 28)
		
		if_set(var_36_10, "t_last_0", T("calendar_count", {
			cur = var_36_6,
			max = var_36_35
		}))
	else
		if Account:isReturnAttendance(arg_36_1.event_name) or arg_36_1.hide_time then
			if_set_visible(var_36_10, "event_time", false)
		else
			local var_36_36, var_36_37 = Account:getEventTime(arg_36_1.event_name)
			
			if arg_36_1.start_day_end_time and var_36_37 then
				if arg_36_1.disable_delay ~= "y" then
					local var_36_38 = Account:serverTimeDayLocalDetail(arg_36_1.start_day_end_time)
					local var_36_39 = Account:serverTimeDayLocalDetail(arg_36_1.end_time) - var_36_38 + 1
					local var_36_40 = 0
					
					if var_36_4 == "7days" and var_36_39 < 7 then
						var_36_40 = 10
					elseif var_36_4 == "14days" and var_36_39 < 14 then
						var_36_40 = 20
					end
					
					local var_36_41 = arg_36_1.start_day_end_time + var_36_40 * 24 * 60 * 60
					
					var_36_37 = math.max(var_36_37, var_36_41)
				end
				
				if_set(var_36_10, "event_time", T("ui_calendar_7days_time2", timeToStringDef({
					preceding_with_zeros = true,
					start_time = var_36_36,
					end_time = var_36_37
				})))
			else
				if_set_visible(var_36_10, "event_time", false)
			end
		end
		
		if var_36_4 == "14days" then
			if_set(var_36_10, "t_disc_bottom", T("ui_calendar_caution_desc"))
		end
	end
	
	if arg_36_1.continue_reward_id and arg_36_1.continue_reward_count then
		if_set_visible(var_36_10, "n_result", arg_36_1.is_continue_item)
		if_set_visible(var_36_10, "txt_rank_info", var_36_9)
		if_set_visible(var_36_10, "txt_challenge", not var_36_9 and not arg_36_1.is_continue_item)
		
		if arg_36_1.ui_show_reward then
			if_set_visible(var_36_10, "n_b_item", false)
			
			local var_36_42 = var_36_10:getChildByName("n_b_item2")
			
			var_36_42:setVisible(true)
			
			local var_36_43 = totable(arg_36_1.ui_show_reward) or {}
			local var_36_44 = 1
			
			for iter_36_4, iter_36_5 in pairs(var_36_43) do
				local var_36_45 = var_36_42:getChildByName("n_" .. tostring(var_36_44))
				local var_36_46 = UIUtil:getRewardIcon(to_n(iter_36_5), iter_36_4, {
					parent = var_36_45:getChildByName("n_reward")
				})
				local var_36_47 = var_36_45:getChildByName("n_eff")
				
				if arg_36_1.failed_reward_level or arg_36_1.is_continue_item then
					var_36_46:setOpacity(76.5)
				else
					var_36_46:setOpacity(255)
				end
				
				if arg_36_1.is_continue_item and not var_36_8 then
					EffectManager:Play({
						pivot_x = 0,
						fn = "ui_itemset_calendar_eff_on2.cfx",
						pivot_y = 0,
						delay = 1000,
						pivot_z = 99998,
						layer = var_36_47
					})
					EffectManager:Play({
						loop = true,
						pivot_x = 0,
						fn = "ui_itemset_calendar_eff_loop.cfx",
						pivot_y = 0,
						delay = 2000,
						pivot_z = 99998,
						layer = var_36_47
					})
				end
				
				var_36_44 = var_36_44 + 1
				
				if_set_visible(var_36_45, "icon_check_b", arg_36_1.is_continue_item)
			end
		else
			if_set_visible(var_36_10, "n_b_item2", false)
			
			local var_36_48 = var_36_10:getChildByName("n_b_item")
			
			var_36_48:setVisible(true)
			
			local var_36_49 = var_36_48:getChildByName("n_eff")
			local var_36_50 = UIUtil:getRewardIcon(arg_36_1.continue_reward_count, arg_36_1.continue_reward_id, {
				parent = var_36_48:getChildByName("n_reward")
			})
			
			if arg_36_1.failed_reward_level or arg_36_1.is_continue_item then
				var_36_50:setOpacity(76.5)
			else
				var_36_50:setOpacity(255)
			end
			
			if arg_36_1.is_continue_item and not var_36_8 then
				EffectManager:Play({
					pivot_x = 0,
					fn = "ui_itemset_calendar_eff_on.cfx",
					pivot_y = 0,
					delay = 1000,
					pivot_z = 99998,
					layer = var_36_49
				})
				EffectManager:Play({
					loop = true,
					pivot_x = 0,
					fn = "ui_itemset_calendar_eff_loop.cfx",
					pivot_y = 0,
					delay = 2000,
					pivot_z = 99998,
					layer = var_36_49
				})
			end
			
			if_set_visible(var_36_48, "icon_check_b", arg_36_1.is_continue_item)
		end
	end
	
	Singular:attendanceEvent(arg_36_1)
	
	arg_36_1.reward_received = false
	arg_36_1.complete = true
	
	if arg_36_2.has_open_webevent then
		arg_36_0.vars.has_open_webevent = true
	end
end

function Lobby.beforeCheckAttendanceEvent(arg_39_0)
	ConditionContentsManager:dispatch("login.accumulate", {
		login_cnt = AccountData.login_days_total
	})
	ConditionContentsManager:dispatch("login.continue", {
		continue_login_cnt = AccountData.login_days_cont
	})
	arg_39_0:nextNoti()
end

function Lobby.checkAttendanceEvent(arg_40_0, arg_40_1, arg_40_2)
	if (function()
		if not arg_40_2 or arg_40_2.complete then
			return false
		end
		
		if arg_40_2.reward_received then
			return true
		end
		
		if arg_40_2.failed_reward_level and Account:getLobbyCount() == 1 then
			return true
		end
		
		return false
	end)() == false then
		return arg_40_0:nextNoti()
	end
	
	arg_40_0:showAttendanceEvent(arg_40_2)
end

function Lobby.checkSubTaskComplete(arg_42_0)
	print("checkSubTaskComplete")
	
	if SubTask:checkComplete() then
		if not SubTask:complete() then
			arg_42_0:nextNoti()
		end
	else
		arg_42_0:nextNoti()
	end
end

function Lobby.checkDailyBonus(arg_43_0)
	print("checkDailyBonus")
	
	if ShopPromotion:CanReceiveDailyPackage() then
		ShopPromotion:reqReceiveDailyPackage()
	else
		arg_43_0:nextNoti()
	end
end

function Lobby.checkNewBooster(arg_44_0)
	print("checkNewBooster")
	
	if Booster:hasNewBooster() then
		BoosterUI:show()
	else
		arg_44_0:nextNoti()
	end
end

function Lobby.checkFriendPointCalculate(arg_45_0)
	print("checkFriendPointCalculate")
	
	if Friend:friendPointCalculate(arg_45_0.vars.noti_layer) == false then
		arg_45_0:nextNoti()
	end
end

function Lobby.checkMail(arg_46_0, arg_46_1)
	if not VARS.GAME_STARTED then
		return 
	end
	
	if not arg_46_0.vars or not arg_46_0.vars.is_lobby_update_after then
		return 
	end
	
	if arg_46_1 or to_n(arg_46_0.last_mail_check_time or 0) + 600 < os.time() then
		arg_46_0.last_mail_check_time = os.time()
		
		query("mail_list")
	end
end

function Lobby.checkPreviewUnit(arg_47_0)
	if CharPreviewController:isCanShowPreview() then
		CharPreviewController:init()
		
		return 
	else
		arg_47_0:nextNoti()
	end
end

function Lobby.clearNoti(arg_48_0)
	print("clearNoti")
	arg_48_0:setNotiFlag(false)
	arg_48_0.vars.seq:getLayer():removeAllChildren()
	arg_48_0.vars.seq:deinit()
	
	arg_48_0.vars.seq = nil
	
	if get_cocos_refid(arg_48_0.vars.noti_layer) then
		arg_48_0.vars.noti_layer:removeAllChildren()
	end
	
	arg_48_0.vars.noti_layer = nil
	
	local var_48_0 = false
	
	if arg_48_0.vars.unlock_id then
		var_48_0 = TutorialGuide:startGuide(arg_48_0.vars.unlock_id)
	end
	
	local var_48_1 = false
	
	if not var_48_0 then
		TutorialGuide:onEnterLobby()
		
		if not TutorialGuide:isPlayingTutorial() then
			callButtonEvent(arg_48_0.vars.opts.ui_event, arg_48_0.vars.opts.btn)
			
			if CharPreviewController:isCanShowPreview() then
				CharPreviewController:init()
			elseif not ShopPromotion:popupLobbyPromotionPackages() then
				if is_can_open_review_popup() then
					review_popup()
				else
					Account:checkIapResponses()
				end
			end
			
			LuaEventDispatcher:dispatchEvent("invite.event", "reload")
		end
	end
	
	if Stove.enable then
		Stove:excuteStoveDeepLink()
	end
	
	ConditionContentsManager:updateLobbyConditionDispatch()
	ConditionContentsNotifier:resetPendingNotifications()
end

function Lobby.setupBar(arg_49_0, arg_49_1)
	local var_49_0 = Account:getCurrentLobbyData()
	
	if var_49_0 and var_49_0.id == "christmas" then
		return arg_49_0:christmasBar(arg_49_1)
	else
		if UIUtil:IsNight() then
			return arg_49_0:setupNightBar(arg_49_1)
		end
		
		return arg_49_0:setupDayBar(arg_49_1)
	end
end

function Lobby.setupBasicObjects(arg_50_0, arg_50_1, arg_50_2)
	for iter_50_0, iter_50_1 in pairs(arg_50_2) do
		local var_50_0 = CACHE:getEffect(iter_50_1[1], iter_50_1[3])
		
		var_50_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_50_0:setScale(1.1)
		arg_50_1:addChild(var_50_0)
		
		arg_50_0.childs[string.gsub(iter_50_1[1], iter_50_1[2], "")] = var_50_0
	end
	
	local var_50_1 = CACHE:getModel("bartender")
	
	var_50_1:setColor(arg_50_0.vars.ambient)
	arg_50_0:attach("lobby_bg", "bartender_attach", var_50_1)
	
	arg_50_0.vars.bartender = var_50_1
	
	local var_50_2 = CACHE:getModel("npc_fuchi_lobby")
	
	var_50_2:setColor(arg_50_0.vars.ambient)
	var_50_2:setVisible(false)
	arg_50_0:attach("lobby_bg", "hoochi_attach", var_50_2)
	
	arg_50_0.vars.fuchi = var_50_2
end

function Lobby.setVisibleBartender(arg_51_0, arg_51_1)
	if get_cocos_refid(arg_51_0.vars.bartender) then
		if arg_51_1 then
			arg_51_0.vars.bartender:setOpacity(255)
			arg_51_0.vars.bartender:setVisible(arg_51_1)
		else
			UIAction:Add(SEQ(DELAY(400), SHOW(arg_51_1)), arg_51_0.vars.bartender, "block")
		end
	end
	
	if ShopGuerrilla:isShopPresent() then
		arg_51_0:setVisibleFuchi(arg_51_1)
	end
end

function Lobby.setVisibleFuchi(arg_52_0, arg_52_1, arg_52_2)
	if get_cocos_refid(arg_52_0.vars.fuchi) then
		if arg_52_1 then
			arg_52_0.vars.fuchi:setOpacity(255)
			arg_52_0.vars.fuchi:setVisible(arg_52_1)
		else
			UIAction:Add(SEQ(DELAY(arg_52_2 or 400), SHOW(arg_52_1)), arg_52_0.vars.fuchi, "block")
		end
	end
	
	if Lobby:isAlternativeLobby() and get_cocos_refid(arg_52_0.vars.fuchi_alt) then
		if CustomLobbySettingMain:isAnyModeSettingPopupOpen() then
			return 
		end
		
		arg_52_0.vars.fuchi_alt:getParent():getParent():setVisible(arg_52_1)
	end
end

function Lobby.setupPubAlternativeLobby(arg_53_0, arg_53_1)
	if not Lobby:isAlternativeLobby() then
		return 
	end
	
	if get_cocos_refid(arg_53_0.vars.bartender_alt) then
		arg_53_0.vars.bartender_alt:removeFromParent()
	end
	
	arg_53_0.vars.bartender_alt = UIUtil:getRewardIcon(nil, "npc1034", {
		no_tooltip = true
	})
	
	local var_53_0 = arg_53_1:getChildByName("mob_icon_pub")
	
	if get_cocos_refid(var_53_0) then
		var_53_0:addChild(arg_53_0.vars.bartender_alt)
	end
end

function Lobby.setupFuchiAlternativeLobby(arg_54_0, arg_54_1)
	if not Lobby:isAlternativeLobby() then
		return 
	end
	
	if get_cocos_refid(arg_54_0.vars.fuchi_alt) then
		arg_54_0.vars.fuchi_alt:removeFromParent()
	end
	
	arg_54_0.vars.fuchi_alt = UIUtil:getRewardIcon(nil, "npc1033", {
		no_tooltip = true
	})
	
	local var_54_0 = arg_54_1:getChildByName("mob_icon_guer")
	
	if get_cocos_refid(var_54_0) then
		var_54_0:addChild(arg_54_0.vars.fuchi_alt)
	end
end

function Lobby.deatch(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	if arg_55_3 == nil then
		print("deatch node error", arg_55_1, arg_55_2)
		
		return 
	end
	
	local var_55_0 = arg_55_0.childs[arg_55_1]:getBoneNode(arg_55_2)
	
	if not var_55_0 then
		print("attach bone error", arg_55_1, arg_55_2)
		
		return 
	end
	
	var_55_0:deatach(arg_55_3)
end

function Lobby.attach(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	if arg_56_3 == nil then
		print("attach node error", arg_56_1, arg_56_2)
		
		return 
	end
	
	local var_56_0 = arg_56_0.childs[arg_56_1]:getBoneNode(arg_56_2)
	
	if not var_56_0 then
		print("attach bone error", arg_56_1, arg_56_2)
		
		return 
	end
	
	if arg_56_4 then
		arg_56_3:setScale(arg_56_4)
	end
	
	var_56_0:setInheritScale(true)
	var_56_0:attach(arg_56_3)
	
	if arg_56_3.start_loop then
		arg_56_3:start_loop()
	elseif arg_56_3.start then
		arg_56_3:start()
	end
	
	arg_56_3:update(math.random())
end

function Lobby.onEnter(arg_57_0)
	BoosterUI:update(TopBarNew:getMainHud())
	AdNetworks:init()
	
	if arg_57_0.vars.opts.open_destiny then
		Destiny:show(arg_57_0.vars.opts.open_destiny.char_code, arg_57_0.vars.opts.open_destiny.opts)
	elseif arg_57_0.vars.opts.open_sub_story then
		SubStoryEntrance:show(arg_57_0.vars.opts.open_sub_story.mode or "HOME")
	end
	
	if MusicBoxUI:isShow() then
		MusicBoxUI:close()
	end
	
	if not arg_57_0.is_first_enter then
		arg_57_0.is_first_enter = true
		
		local var_57_0 = Zlong:isUseGlobalResource()
		
		Zlong:gameEventLog(ZLONG_LOG_CODE.LOBBY_ENTER, not var_57_0 and "true" or "false")
		Zlong:openStickFaceWebView()
	end
end

function Lobby.onLeave(arg_58_0)
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		print("removeAllScheduler?")
		CustomLobbyIllust.Util:removeAllScheduler()
	end
	
	CustomLobbyIllust.Util:ifSoundThenStop()
end

function Lobby.onAfterDraw(arg_59_0)
	if not SceneManager:isAbsent() then
		return 
	end
	
	if not TLRenderer:isActive() then
		return 
	end
	
	if not arg_59_0.vars or not arg_59_0.vars.tl_dir then
		return 
	end
	
	local var_59_0 = TLRenderer:getField()
	
	if not var_59_0 then
		return 
	end
	
	local var_59_1 = TLRenderer.FIELD_RANGE
	local var_59_2, var_59_3 = var_59_0:getViewPortPosition()
	
	if math.abs(var_59_2) >= var_59_1 - 0.01 then
		if var_59_2 > 0 then
			arg_59_0.vars.tl_dir = -1
		else
			arg_59_0.vars.tl_dir = 1
		end
	end
	
	local var_59_4 = var_59_2 + 10 * cc.Director:getInstance():getDeltaTime() * arg_59_0.vars.tl_dir
	
	var_59_0:setViewPortPosition(var_59_4)
	var_59_0:updateViewport()
end

function Lobby.setupLobbyUI(arg_60_0)
	arg_60_0.vars.ui_layer = load_dlg("lobby", true, "wnd")
	
	arg_60_0.vars.ui_layer:setPosition(0, 0)
	arg_60_0.vars.ui_layer:setAnchorPoint(0, 0)
	arg_60_0.vars.ui_layer:setVisible(false)
	arg_60_0.vars.ui_layer:setOpacity(0)
	SceneManager:getRunningUIScene():addChild(arg_60_0.vars.ui_layer)
	if_set_visible(arg_60_0.vars.ui_layer, "n_unit_ui", false)
	if_set_visible(arg_60_0.vars.ui_layer, "n_community", false)
	arg_60_0.vars.ui_layer:getChildByName("n_unit_classchange"):removeFromParent()
	UnlockSystem:setButtonUnlockInfo(arg_60_0.vars.ui_layer, "btn_unit_Team", "system_078", {
		pos_y_ratio = 0.06,
		right_bottom_pos = true,
		pos_x_ratio = 0.2
	})
	UnlockSystem:setButtonUnlockInfo(arg_60_0.vars.ui_layer, "btn_gacha_inven", UNLOCK_ID.GACHA, {
		pos_y_ratio = 0.06,
		right_bottom_pos = true,
		pos_x_ratio = 0.2
	})
	UnlockSystem:setButtonUnlockInfo(arg_60_0.vars.ui_layer, "btn_storage", UNLOCK_ID.GACHA, {
		pos_y_ratio = 0.06,
		right_bottom_pos = true,
		pos_x_ratio = 0.2,
		replace_title = "waitingroom_title"
	})
	UnlockSystem:setButtonUnlockInfo(arg_60_0.vars.ui_layer, "btn_recruit", UNLOCK_ID.DESTINY, {
		pos_y_ratio = 0.06,
		right_bottom_pos = true,
		pos_x_ratio = 0.2,
		replace_title = "ui_recruit_hero"
	})
	UnlockSystem:setButtonUnlockInfo(arg_60_0.vars.ui_layer, "btn_blessing", UNLOCK_ID.GROWTH_BOOST_1, {
		pos_y_ratio = 0.06,
		right_bottom_pos = true,
		pos_x_ratio = 0.2
	})
	
	local var_60_0, var_60_1 = ClassChange:CheckNotification()
	local var_60_2 = Account:getClassChangeQuests() or {}
	local var_60_3 = {
		pos_y_ratio = 0.06,
		right_bottom_pos = true,
		pos_x_ratio = 0.2
	}
	
	if table.count(var_60_2) > 0 and not UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE) then
		var_60_3.force_open = true
	end
	
	if not arg_60_0:isAlternativeLobby() then
		arg_60_0:updateUnitInfo(true)
	end
	
	local var_60_4 = arg_60_0.vars.ui_layer:getChildByName("n_growth_guide")
	
	if_set_visible(var_60_4, "n_growth_talk", false)
	if_set_visible(var_60_4, "count_bg", false)
	
	if Lobby:isAlternativeLobby() then
		var_60_4:setPositionY(var_60_4:getPositionY() + 10)
	end
	
	if_set_visible(arg_60_0.vars.ui_layer, "n_banner", false)
	
	if arg_60_0:isAlternativeLobby() then
		if_set_visible(arg_60_0.vars.ui_layer, "n_zoomout", false)
	end
end

function Lobby.setupTeamUnits(arg_61_0)
	arg_61_0.vars.models = arg_61_0.vars.models or {}
	arg_61_0.vars.units = arg_61_0.vars.units or {}
	
	local var_61_0 = Account:getLobbyTeam() or Account:getCurrentTeam()
	local var_61_1 = {
		1.2,
		1.05,
		1,
		1.1
	}
	
	for iter_61_0, iter_61_1 in pairs({
		2,
		3,
		1,
		4
	}) do
		local var_61_2 = var_61_0[iter_61_1]
		
		if var_61_2 then
			local var_61_3 = CACHE:getModel(var_61_2.db.model_id, var_61_2.db.skin, "camping", var_61_2.db.atlas, var_61_2.db.model_opt)
			
			var_61_3:setPosition(0, 20)
			var_61_3:setColor(arg_61_0.vars.ambient)
			var_61_3:update(math.random())
			
			local var_61_4 = var_61_1[iter_61_1] * var_61_2.db.scale * 0.8
			
			var_61_3:setScale(var_61_4)
			
			if iter_61_1 > 2 then
				var_61_3:setScaleX(0 - var_61_4)
			end
			
			local var_61_5 = arg_61_0.childs.lobby_main_chairs:getBoneNode("char" .. iter_61_1 .. "_attach")
			
			var_61_5:setInheritScale(true)
			var_61_5:attach(var_61_3)
			
			arg_61_0.vars.models[iter_61_0] = var_61_3
			arg_61_0.vars.units[iter_61_0] = var_61_2
		end
	end
end

function Lobby.setupLobbyPet(arg_62_0)
	if not arg_62_0.vars then
		return 
	end
	
	local var_62_0 = SceneManager:getRunningUIScene()
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
		if_set_visible(var_62_0, "cm_icon_pet", false)
		
		return 
	end
	
	local var_62_1 = PetSlot:getPetsBySlot("lobby_slot1")
	local var_62_2 = arg_62_0.childs.lobby_front_table:getBoneNode("pet_attach")
	
	var_62_2:removeAllChildren()
	if_set_visible(var_62_0, "cm_icon_pet", true)
	if_set_visible(var_62_0, "n_pet", false)
	if_set_visible(var_62_0, "n_none_pet", false)
	
	if not var_62_1 then
		if_set_visible(var_62_0, "n_none_pet", true)
		
		local var_62_3 = var_62_0:findChildByName("n_none_pet")
		
		if Account:isLobbyPet_exist() then
			if_set_visible(var_62_3, "img_noti", true)
		else
			if_set_visible(var_62_3, "img_noti", false)
		end
		
		return 
	end
	
	if_set_visible(var_62_0, "n_pet", true)
	
	local var_62_4 = "model_" .. var_62_1:getGrade()
	local var_62_5 = CACHE:getModel(var_62_1.db[var_62_4], nil, "camping", nil, nil)
	
	if not var_62_5 or not var_62_2 then
		return 
	end
	
	var_62_5:setScaleX(var_62_5:getScaleX() * -1)
	var_62_5:setColor(arg_62_0.vars.ambient)
	var_62_2:setInheritScale(true)
	var_62_2:attach(var_62_5)
end

function Lobby.setupLobbyPetAltLobby(arg_63_0)
	local var_63_0 = SceneManager:getRunningUIScene()
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
		if_set_visible(var_63_0, "cm_icon_pet", false)
		
		return 
	end
	
	local var_63_1 = PetSlot:getPetsBySlot("lobby_slot1")
	local var_63_2 = var_63_0:getChildByName("btn_pet")
	
	if_set_visible(var_63_0, "cm_icon_pet", true)
	if_set_visible(var_63_2, "btn_pet_lobby", not var_63_1)
	if_set_visible(var_63_2, "icon_pet_setting", not var_63_1)
	if_set_visible(var_63_2, "n_pet_face", false)
	
	if var_63_1 then
		local var_63_3 = var_63_2:getChildByName("n_pet_face")
		local var_63_4 = var_63_1:getFaceID()
		
		SpriteCache:resetSprite(var_63_3:getChildByName("face"), "face/" .. var_63_4 .. "_s.png")
	end
end

function Lobby.update_petGift(arg_64_0)
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		return 
	end
	
	if arg_64_0:isAlternativeLobby() then
		arg_64_0:update_petGift_altLobby()
	else
		arg_64_0:update_petGift_lobby()
	end
end

function Lobby.isPetRewardable(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_1:getGiftTime()
	
	return (Account:getPetSlots().present_tm or 0) + var_65_0 - os.time() <= 0
end

function Lobby.update_petGift_altLobby(arg_66_0)
	local var_66_0 = SceneManager:getRunningUIScene():getChildByName("btn_pet")
	
	if not get_cocos_refid(var_66_0) then
		return 
	end
	
	local var_66_1 = Account:getLobbyPet()
	
	if not var_66_1 then
		if_set_visible(var_66_0, "btn_pet_lobby", true)
		if_set_visible(var_66_0, "icon_pet_setting", true)
		if_set_visible(var_66_0, "n_pet_face", false)
		
		return 
	end
	
	local var_66_2 = arg_66_0:isPetRewardable(var_66_1)
	
	if_set_visible(var_66_0, "btn_pet_lobby", var_66_2)
	if_set_visible(var_66_0, "icon_pet_setting", false)
	if_set_visible(var_66_0, "n_pet_face", var_66_2)
end

function Lobby.update_petGift_lobby(arg_67_0)
	local var_67_0 = SceneManager:getRunningUIScene():getChildByName("n_pet")
	
	if not get_cocos_refid(var_67_0) then
		return 
	end
	
	local var_67_1 = Account:getLobbyPet()
	
	if not var_67_1 then
		if_set_visible(var_67_0, "n_petbonus", false)
		if_set_visible(var_67_0, "n_item", false)
		
		return 
	end
	
	local var_67_2 = arg_67_0:isPetRewardable(var_67_1)
	
	if_set_visible(var_67_0, "n_petbonus", var_67_2)
	if_set_visible(var_67_0, "n_item", var_67_2)
end

function Lobby.recive_lobbyPetGift(arg_68_0, arg_68_1)
	Account:setLobbyPet_presentTime(arg_68_1.present_tm)
	
	local var_68_0 = arg_68_1.reward
	
	if not var_68_0 then
		return 
	end
	
	local var_68_1 = {
		effect = true,
		single = true,
		no_randombox_eff = true
	}
	
	Account:addReward(var_68_0, var_68_1)
	
	local var_68_2
	local var_68_3 = 0
	local var_68_4 = 0
	
	if arg_68_0:isAlternativeLobby() then
		var_68_2 = SceneManager:getRunningUIScene()
		var_68_3 = 418 + VIEW_BASE_LEFT
		var_68_4 = 150
	else
		var_68_2 = arg_68_0.childs.lobby_front_table:getBoneNode("pet_attach")
	end
	
	EffectManager:Play({
		fn = "ui_pet_act_eff.cfx",
		pivot_z = 99998,
		layer = var_68_2,
		pivot_x = var_68_3,
		pivot_y = var_68_4
	})
end

function Lobby.req_lobbyPetGift(arg_69_0)
	local var_69_0 = Account:getLobbyPet()
	
	if not var_69_0 then
		return 
	end
	
	local var_69_1 = var_69_0:getGiftTime()
	
	if (Account:getPetSlots().present_tm or 0) + var_69_1 - os.time() <= 0 then
		SoundEngine:play("event:/ui/pet/" .. var_69_0:getRace())
		query("bring_pet", {
			uid = Account:getLobbyPetUID()
		})
		
		return true
	end
	
	return false
end

function Lobby.setupRandomRewardSysCharacter(arg_70_0)
	if arg_70_0:isAlternativeLobby() then
		return 
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.DESTINY) then
		return 
	end
	
	if arg_70_0.vars.reward_sys_model then
		Lobby:deatch("lobby_main_chairs", "char1_attach", arg_70_0.vars.reward_sys_model)
	end
	
	local var_70_0 = Destiny:getRandomCharacter()
	
	if var_70_0 and var_70_0.code then
		local var_70_1 = UNIT:create({
			code = var_70_0.code
		})
		
		if var_70_1 then
			local var_70_2 = CACHE:getModel(var_70_1.db.model_id, var_70_1.db.skin, "camping", var_70_1.db.atlas, var_70_1.db.model_opt)
			
			var_70_2:setColor(arg_70_0.vars.ambient)
			var_70_2:update(math.random())
			var_70_2:setScale(var_70_1.db.scale * 0.85)
			var_70_2:setPositionX(var_70_2:getPositionX() - 485)
			var_70_2:setPositionY(var_70_2:getPositionY() + 158)
			arg_70_0:attach("lobby_main_chairs", "char1_attach", var_70_2)
			
			arg_70_0.vars.reward_sys_model = var_70_2
		end
		
		if var_70_0.lobby_text then
			local var_70_3 = TopBarNew:getMainHud()
			local var_70_4 = var_70_3:getChildByName("n_ballon_destini")
			
			var_70_4:setVisible(false)
			var_70_4:setScale(0.5)
			
			local var_70_5 = GAME_STATIC_VARIABLE.destiny_lobby_text_on_time
			local var_70_6 = GAME_STATIC_VARIABLE.destiny_lobby_text_rotation_time
			
			if not var_70_3:getChildByName("btn_rel"):isVisible() and not UIAction:Find("destiny_ballon") then
				UIAction:Add(LOOP(SEQ(DELAY(2000), SHOW(true), LOG(SCALE(200, 0.5, 1)), DELAY(var_70_5 * 1000), RLOG(SCALE(200, 1, 0.5)), SHOW(false), DELAY((var_70_6 - 2) * 1000))), var_70_4, "destiny_ballon")
			end
			
			if_set(var_70_4, "txt_disc", T(var_70_0.lobby_text))
		end
		
		arg_70_0.vars.char_code = var_70_0.code
	end
end

function Lobby.setScale(arg_71_0, arg_71_1)
	arg_71_0.vars.layer:setScale(arg_71_1)
end

function Lobby.createNoti(arg_72_0)
	if DEBUG.SKIP_ANIMS or arg_72_0.lobby_intro_skip then
		arg_72_0:createNotiSeq()
		
		return 
	end
	
	UIAction:AddSmooth(SEQ(DELAY(1300), CALL(arg_72_0.createNotiSeq, arg_72_0)), arg_72_0.vars.ui_layer, "block")
end

function Lobby.playLobbyBGM(arg_73_0)
	local var_73_0 = "event:/bgm/"
	local var_73_1 = "default"
	local var_73_2 = Account:getCurrentLobbyData()
	
	if var_73_2 and var_73_2.bgm then
		var_73_1 = var_73_2.bgm
	end
	
	SoundEngine:playBGM(var_73_0 .. var_73_1)
end

function Lobby.isAlternativeLobby(arg_74_0)
	if not arg_74_0.vars then
		return 
	end
	
	return SAVE:getKeep("custom_lobby.mode", "default") ~= "default"
end

function Lobby.playTownEnterEffect(arg_75_0)
	arg_75_0:playLobbyBGM()
	
	local var_75_0 = false
	
	if arg_75_0:isAlternativeLobby() then
		var_75_0 = true
	end
	
	var_75_0 = var_75_0 or DEBUG.SKIP_ANIMS
	var_75_0 = var_75_0 or arg_75_0.BattleCount == Battle:GetBattleCount()
	var_75_0 = var_75_0 or arg_75_0.vars.opts.open_destiny
	
	if var_75_0 then
		TopBarNew:setOpacity(255)
		arg_75_0:setAnimation(0, "loop", true)
		arg_75_0.vars.ui_layer:setVisible(true)
		arg_75_0.vars.ui_layer:setOpacity(255)
		arg_75_0:setNotiFlag(false)
		
		arg_75_0.lobby_intro_skip = true
		
		return 
	end
	
	arg_75_0.BattleCount = Battle:GetBattleCount()
	
	set_high_fps_tick(5000)
	
	local var_75_1 = 300
	local var_75_2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_75_2:setLocalZOrder(99)
	arg_75_0.vars.layer:addChild(var_75_2)
	arg_75_0:setAnimation(0, "intro", false, 0)
	UIAction:AddSmooth(SEQ(FADE_OUT(var_75_1), REMOVE()), var_75_2, "block")
	
	if not arg_75_0.vars.open_sub_story then
		UIAction:AddSmooth(SEQ(DELAY(1200), FADE_IN(var_75_1)), TopBarNew, "block")
	end
	
	UIAction:AddSmooth(SEQ(DELAY(1200), SHOW(true), FADE_IN(var_75_1), CALL(arg_75_0.showNotice, arg_75_0)), arg_75_0.vars.ui_layer, "block")
	
	for iter_75_0, iter_75_1 in pairs(arg_75_0.childs) do
		UIAction:AddSmooth(SEQ(DELAY(150), DMOTION("intro"), MOTION("loop", true)), iter_75_1, "block")
	end
	
	arg_75_0.lobby_intro_skip = false
	
	TutorialNotice:detachByPoint("top_bar")
	TutorialNotice:detachByPoint("lobby")
	UIAction:Add(SEQ(DELAY(1200)), arg_75_0.vars.ui_layer, "tutorial_notice_delay")
end

function Lobby.setNotiFlag(arg_76_0, arg_76_1)
	arg_76_0.vars.noti_flag = arg_76_1
end

function Lobby.getNotiFlag(arg_77_0)
	return arg_77_0.vars.noti_flag
end

function Lobby.checkNoti(arg_78_0)
	if ShopPromotion:isPackagePopup() then
		return 
	end
	
	if arg_78_0:getNotiFlag() == true then
		return 
	end
	
	if not arg_78_0.vars.seq_created then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if SeasonPassBase:isVisible() then
		return 
	end
	
	if SubStoryEntrance:isVisible() then
		return 
	end
	
	if SubTask:checkComplete() then
		arg_78_0:createNotiSeq()
		
		if WebEventPopUp:isShowWebView() then
			WebEventPopUp:showWebView(false)
		end
		
		return 
	end
	
	arg_78_0:updateGachaTempInventory()
end

function Lobby.update(arg_79_0)
	if not VARS.GAME_STARTED then
		return 
	end
	
	if not get_cocos_refid(arg_79_0.vars.ui_layer) then
		return 
	end
	
	if not TopBarNew:isToday() then
		return 
	end
	
	arg_79_0:checkNoti()
	arg_79_0:checkMail()
	arg_79_0:updateEatingUnit()
	arg_79_0:update_petGift()
	TopBarNew:updateE7WCBalloon()
	
	if arg_79_0.vars.is_lobby_update_after then
		BoosterUI:update(TopBarNew:getMainHud())
	end
end

function Lobby.goOut(arg_80_0)
	balloon_message_with_sound("notyet_town")
	
	do return  end
	
	RingMenu:hide()
	
	if UIAction:Find("block") then
		return 
	end
	
	if arg_80_0.vars.mode == "bartender" then
		return 
	end
	
	arg_80_0:setAnimation(0, "exit")
	SceneManager:nextScene("town", nil, {
		delay = 150,
		pre_tm = 350,
		additive = not arg_80_0.vars.night,
		color = arg_80_0.vars.fade_color
	})
end

function Lobby.setTimeScale(arg_81_0, arg_81_1)
	for iter_81_0, iter_81_1 in pairs(arg_81_0.childs) do
		iter_81_1:setTimeScale(arg_81_1)
	end
end

function Lobby.tt(arg_82_0)
	print("테스트!!!!!")
end

function Lobby.setAnimation(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	for iter_83_0, iter_83_1 in pairs(arg_83_0.childs) do
		iter_83_1:setAnimation(arg_83_1, arg_83_2, arg_83_3)
		
		if arg_83_4 then
			iter_83_1:setTimeScale(arg_83_4)
		end
	end
end

function Lobby.isBartenderMode(arg_84_0)
	return arg_84_0.vars.mode == "bartender"
end

function Lobby.isGuerrillaMode(arg_85_0)
	return arg_85_0.vars.mode == "guerrilla"
end

function Lobby.makeGrowForZOrder(arg_86_0, arg_86_1)
	if not TopBarNew.vars.top_right then
		return 
	end
	
	arg_86_1:setLocalZOrder(TopBarNew.vars.top_right:getLocalZOrder() - 1)
	
	local var_86_0 = TopBarNew.vars.top_right:findChildByName("grow_s")
	
	if var_86_0 then
		local var_86_1 = var_86_0:clone()
		
		var_86_1:setLocalZOrder(-1)
		arg_86_1:addChild(var_86_1)
		var_86_0:setVisible(false)
	end
end

function Lobby.toggleBartenderMode(arg_87_0, arg_87_1, arg_87_2)
	RingMenu:hide()
	
	if not arg_87_1 and UIAction:Find("block") then
		return 
	end
	
	set_high_fps_tick(3000)
	
	if arg_87_0.vars.mode == "bartender" or arg_87_0.vars.mode == "guerrilla" then
		arg_87_0:setAnimation(0, "bar_out")
		arg_87_0:setVisibleBartender(true)
		
		if arg_87_0.vars.mode == "guerrilla" then
			ShopGuerrilla:exit()
		else
			ShopRandom:exit()
		end
		
		if TopBarNew.vars.top_right then
			TopBarNew.vars.top_right:findChildByName("grow_s"):setVisible(true)
		end
		
		local var_87_0 = 500
		
		if not arg_87_0:isAlternativeLobby() then
			UIAction:Add(SEQ(DELAY(700), SHOW(true), FADE_IN(200)), arg_87_0.vars.ui_layer, "block")
			
			for iter_87_0 = 1, 4 do
				if arg_87_0.vars.models[iter_87_0] then
					UIAction:Add(FADE_IN(300), arg_87_0.vars.models[iter_87_0], "block")
				end
			end
		else
			local var_87_1 = arg_87_0.vars.bar_layer
			
			UIAction:Add(SEQ(DELAY(150), FADE_OUT(300)), var_87_1:getChildByName("dim_layer"), "block")
			UIAction:Add(SEQ(DELAY(150), SHOW(true), FADE_IN(300)), arg_87_0.vars.ui_layer, "block")
			
			var_87_0 = 450
		end
		
		TopBarNew:toggleHUDMode(true, var_87_0)
		
		arg_87_0.vars.mode = nil
		
		LuaEventDispatcher:dispatchEvent("invite.event", "reload")
	else
		arg_87_0:setAnimation(0, "bar_zoom")
		
		if arg_87_2 then
			arg_87_0.vars.mode = "guerrilla"
			
			local var_87_2 = ShopGuerrilla:show(TopBarNew.vars.base)
			
			if not var_87_2 then
				arg_87_0:toggleBartenderMode(true)
				
				return 
			end
			
			arg_87_0:makeGrowForZOrder(var_87_2)
			var_87_2:setVisible(false)
			UIAction:Add(SEQ(FADE_OUT(200), SHOW(false), CALL(set_scene_fps, 15)), arg_87_0.vars.ui_layer, "block")
			UIAction:Add(SEQ(DELAY(400), SHOW(true)), var_87_2, "block")
			
			if arg_87_0:isAlternativeLobby() then
				local var_87_3 = var_87_2:getChildByName("bg")
				
				UIAction:Add(SEQ(DELAY(150), FADE_IN(300)), var_87_3, "block")
			end
		else
			arg_87_0.vars.mode = "bartender"
			
			local var_87_4 = ShopRandom:show(TopBarNew.vars.base)
			
			arg_87_0:makeGrowForZOrder(var_87_4)
			var_87_4:setVisible(false)
			UIAction:Add(SEQ(FADE_OUT(200), SHOW(false), CALL(set_scene_fps, 15)), arg_87_0.vars.ui_layer, "block")
			UIAction:Add(SEQ(DELAY(400), SHOW(true)), var_87_4, "block")
			
			if arg_87_0:isAlternativeLobby() then
				local var_87_5 = var_87_4:getChildByName("bg")
				
				UIAction:Add(SEQ(DELAY(150), FADE_IN(300)), var_87_5, "block")
			end
		end
		
		arg_87_0:setVisibleBartender(false)
		TopBarNew:toggleHUDMode(false)
		
		if not arg_87_0:isAlternativeLobby() then
			for iter_87_1 = 1, 4 do
				if arg_87_0.vars.models[iter_87_1] then
					UIAction:Add(SEQ(DELAY(300), FADE_OUT(300)), arg_87_0.vars.models[iter_87_1], "block")
				end
			end
		else
			local var_87_6 = arg_87_0.vars.bar_layer
			
			UIAction:Add(SEQ(FADE_IN(300)), var_87_6:getChildByName("dim_layer"))
		end
		
		LuaEventDispatcher:dispatchEvent("invite.event", "hide")
		SoundEngine:play("event:/ui/main_hud/btn_pub")
		TutorialNotice:detachByPoint("lobby")
	end
end

function Lobby.onTouchUnit(arg_88_0, arg_88_1)
	if arg_88_0.vars.mode then
		return 
	end
	
	local var_88_0 = arg_88_0.vars.units[arg_88_1]
	
	if not var_88_0 then
		return 
	end
	
	if RingMenu:isVisible() then
		RingMenu:hide()
		
		if arg_88_0.vars.prev_selected_unit and arg_88_0.vars.prev_selected_unit:getUID() == var_88_0:getUID() then
			return 
		end
	end
	
	RingMenu:hide()
	
	local var_88_1, var_88_2 = arg_88_0.vars.ui_layer:getChildByName("n_char" .. arg_88_1):getPosition()
	
	RingMenu:show(arg_88_0.vars.ui_layer, var_88_1, var_88_2 + 50, var_88_0)
	arg_88_0:toggleUnitInfos(arg_88_1)
	
	arg_88_0.vars.prev_selected_unit = var_88_0
end

function Lobby.onTouchMove(arg_89_0, arg_89_1, arg_89_2)
	if not arg_89_0.begin_x then
		return 
	end
	
	local var_89_0 = arg_89_1 - arg_89_0.begin_x
	
	arg_89_0.begin_x = arg_89_1
	
	if TLRenderer:isActive() then
		TLRenderer:moveScrollRatio(-var_89_0 / 6)
	end
end

function Lobby.onTouchDown(arg_90_0, arg_90_1, arg_90_2)
	arg_90_0.begin_x = arg_90_1
	
	RingMenu:hide()
end

function Lobby.updateUnitInfo(arg_91_0, arg_91_1)
	for iter_91_0 = 1, 4 do
		local var_91_0 = arg_91_0.vars.units[iter_91_0]
		local var_91_1 = arg_91_0.vars.ui_layer:getChildByName("n_char" .. iter_91_0)
		local var_91_2 = var_91_1:getChildByName("n_lv")
		
		var_91_1:setVisible(arg_91_0.vars.units[iter_91_0] ~= nil)
		
		if var_91_0 then
			local var_91_3 = var_91_1:getChildByName("info" .. iter_91_0)
			local var_91_4 = var_91_0:getLv()
			local var_91_5 = var_91_0:getMaxLevel()
			
			if arg_91_1 then
				UIUtil:setLevelDetail(var_91_3, var_91_4, var_91_0:getMaxLevel())
				
				if var_91_0:isGrowthBoostRegistered() then
					local var_91_6, var_91_7 = var_91_0:getGrowthBoostLvAndMaxLv()
					
					UIUtil:setLevelDetail(var_91_3, var_91_6, var_91_7)
				end
				
				local var_91_8 = var_91_3:getChildByName("name")
				local var_91_9 = get_word_wrapped_name(var_91_8, T(var_91_0.db.name))
				
				if_set_scale_fit_width_long_word(var_91_3, "name", var_91_9, 146)
				
				if iter_91_0 == 1 or iter_91_0 == 3 then
					if var_91_4 < 10 then
						var_91_2:setPositionX(10)
					end
					
					if var_91_5 then
						var_91_2:setPositionX(-10)
					end
				end
				
				if_set_sprite(var_91_1, "color", UIUtil:getColorIcon(var_91_0))
				if_set_visible(var_91_1, "notification", Account:isUpgradableUnit(var_91_0) or Account:isZodiacUpgradableUnit(var_91_0) and UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC))
			end
		end
	end
end

function Lobby.updateEatingUnit(arg_92_0)
	if not arg_92_0.vars or not arg_92_0.vars.units then
		return 
	end
	
	local var_92_0
	
	for iter_92_0, iter_92_1 in pairs(arg_92_0.vars.units) do
		local var_92_1 = arg_92_0.vars.ui_layer:getChildByName("n_char" .. iter_92_0)
		
		if get_cocos_refid(var_92_1) then
			if get_cocos_refid(var_92_1.hp_bar) then
				if iter_92_1:getHPRatio() < 1 then
					var_92_1.hp_bar.c.hp:setScaleX(iter_92_1:getHPRatio())
				else
					var_92_1.hp_bar:removeFromParent()
					
					var_92_1.hp_bar = nil
				end
			elseif iter_92_1:getHPRatio() < 1 then
				local var_92_2 = var_92_1:getChildByName("info" .. iter_92_0)
				
				var_92_1.hp_bar = UIUtil:getHPBar(iter_92_1, var_92_2:getChildByName("n_hp_pos"), nil, false, true)
				
				if arg_92_0.vars.models[iter_92_0] and arg_92_0.vars.models[iter_92_0].getBonePosition then
					local var_92_3, var_92_4 = arg_92_0.vars.models[iter_92_0]:getBonePosition("top")
					
					if var_92_4 > 330 then
						var_92_1.hp_bar:setPositionY(var_92_1.hp_bar:getPositionY() + (var_92_4 - 320) / 2)
					end
				end
			end
		end
	end
	
	TopBarNew:updateFeedButton()
end

function Lobby.updateTopBar(arg_93_0)
	TopBarNew:createMainHUD(SceneManager:getRunningUIScene(), true)
	TopBarNew:updateMailMark()
end

local var_0_0

function Lobby.showNotice(arg_94_0, arg_94_1)
	arg_94_1 = arg_94_1 or AccountData.notice
	
	if var_0_0 == arg_94_1 then
		return 
	end
	
	local var_94_0 = load_dlg("notice", true, "wnd")
	
	var_94_0:setPositionY(1200)
	var_94_0:setOpacity(0)
	UIAction:Add(SPAWN(FADE_IN(300), LOG(MOVE_TO(300, DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2))), var_94_0, "block")
	UIUtil:setScrollViewText(var_94_0:getChildByName("scrollview"), arg_94_1)
	
	var_0_0 = arg_94_1
	
	arg_94_0.vars.ui_layer:addChild(var_94_0)
end

function Lobby.focus(arg_95_0, arg_95_1)
	local var_95_0, var_95_1 = arg_95_0.vars.ui_layer:getChildByName("n_char" .. arg_95_1):getPosition()
	
	arg_95_0.vars.ui_layer:setAnchorPoint(var_95_0 / DESIGN_WIDTH, var_95_1 / DESIGN_HEIGHT)
	arg_95_0.vars.ui_layer:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	arg_95_0.vars.ui_layer:setScale(1.3)
end

function Lobby.toggleUnitInfos(arg_96_0, arg_96_1)
	if arg_96_1 then
		for iter_96_0 = 1, 4 do
			local var_96_0 = arg_96_0.vars.ui_layer:getChildByName("info" .. iter_96_0)
			
			UIAction:Remove(var_96_0)
			
			if iter_96_0 == arg_96_1 then
				if var_96_0:getOpacity() == 0 then
					UIAction:Add(FADE_IN(200), var_96_0, "block")
				end
			elseif var_96_0:getOpacity() ~= 0 then
				UIAction:Add(FADE_OUT(200), var_96_0, "block")
			end
		end
	else
		for iter_96_1 = 1, 4 do
			local var_96_1 = arg_96_0.vars.ui_layer:getChildByName("info" .. iter_96_1)
			
			UIAction:Remove(var_96_1)
			
			if var_96_1:getOpacity() == 0 then
				UIAction:Add(FADE_IN(200), var_96_1, "block")
			end
		end
	end
end

function Lobby.onHideRingMenu(arg_97_0)
	arg_97_0:toggleUnitInfos()
end

function Lobby.showBistro(arg_98_0)
	Bistro:show(SceneManager:getRunningPopupScene())
	TutorialGuide:forceProcGuide()
end

function Lobby.showBooster(arg_99_0)
	BoosterUI:show()
end

function Lobby.getCurrnetDestinyCharacter(arg_100_0)
	if not arg_100_0.vars then
		return 
	end
	
	return arg_100_0.vars.char_code
end

function Lobby.showCharacterRewardsSystem(arg_101_0, arg_101_1)
	UnlockSystem:isUnlockSystemAndMsg({
		exclude_story = true,
		id = UNLOCK_ID.DESTINY
	}, function()
		if Destiny:isVisible() then
			return 
		end
		
		Destiny:show(arg_101_1 or arg_101_0.vars.char_code)
		TutorialGuide:forceProcGuide()
		SoundEngine:play("event:/ui/whoosh_b")
	end)
end

function Lobby.onGameEvent(arg_103_0, arg_103_1, arg_103_2)
	if arg_103_1 == "friend_count" then
		Profile:open(SceneManager:getRunningPopupScene(), arg_103_2)
	end
end

function Lobby.updateNotifier(arg_104_0)
	if not arg_104_0.vars or not arg_104_0.vars.ui_layer or not get_cocos_refid(arg_104_0.vars.ui_layer) then
		return 
	end
	
	local var_104_0 = arg_104_0.vars.ui_layer:getChildByName("n_hero_recruit")
	
	if_set_visible(var_104_0, "icon_noti", HeroRecruit:isNotification())
	if_set_visible(var_104_0, "img_icon", HeroRecruit:isNew())
	
	local var_104_1 = arg_104_0.vars.ui_layer:getChildByName("btn_unit_Detail")
	
	if_set_visible(var_104_1, "icon_noti", false)
	
	local var_104_2 = arg_104_0.vars.ui_layer:getChildByName("btn_blessing")
	
	if_set_visible(var_104_2, "icon_noti", GrowthBoost:isNotification())
	
	if not UIAction:Find("tutorial_notice_delay") then
		TutorialNotice:update("lobby")
	end
end

function Lobby.updateGachaTempInventory(arg_105_0)
	if not get_cocos_refid(arg_105_0.vars.ui_layer) then
		return 
	end
	
	local var_105_0 = arg_105_0.vars.ui_layer:getChildByName("n_unit_ui"):getChildByName("n_unit_menus"):getChildByName("n_unit_gacha_inven")
	
	if get_cocos_refid(var_105_0) then
		local var_105_1 = Account:countGachaTempInventory()
		
		if var_105_1 > 0 then
			if_set_visible(var_105_0, "count_bg", true)
			
			if var_105_1 > 99 then
				if_set(var_105_0, "label_count", "99+")
			else
				if_set(var_105_0, "label_count", var_105_1)
			end
		else
			if_set_visible(var_105_0, "count_bg", false)
		end
	end
end

function Lobby.toggleUnitMenuShortCut(arg_106_0, arg_106_1)
	RingMenu:hide()
	TutorialGuide:procGuide()
	
	local var_106_0 = arg_106_0.vars.ui_layer:getChildByName("n_unit_ui")
	
	arg_106_1 = arg_106_1 or not var_106_0:isVisible()
	
	if arg_106_1 then
		TutorialNotice:detachByID("classchange_start_02")
		UIAction:Add(DELAY(100), var_106_0, "tutorial_notice_delay")
		var_106_0:setVisible(true)
		var_106_0:setOpacity(0)
		UIAction:Add(FADE_IN(100), var_106_0, "block")
		
		local var_106_1 = var_106_0:getChildByName("n_unit_menus"):getChildren()
		
		for iter_106_0, iter_106_1 in pairs(var_106_1) do
			local var_106_2, var_106_3 = iter_106_1:getPosition()
			
			iter_106_1:setPositionY(var_106_3 - 300)
			iter_106_1:setOpacity(0)
			
			local var_106_4 = iter_106_0 * 30
			local var_106_5 = 200 - var_106_4 / 2
			
			UIAction:Add(SEQ(DELAY(var_106_4), SPAWN(FADE_IN(var_106_5), LOG(MOVE_TO(var_106_5, var_106_2, var_106_3)))), iter_106_1, "block")
			
			local var_106_6 = iter_106_1:getName()
			
			if var_106_6 and var_106_6 == "n_unit_gacha_inven" then
				local var_106_7 = Account:countGachaTempInventory()
				
				if var_106_7 > 0 then
					if_set_visible(iter_106_1, "count_bg", true)
					
					if var_106_7 > 99 then
						if_set(iter_106_1, "label_count", "99+")
					else
						if_set(iter_106_1, "label_count", var_106_7)
					end
				else
					if_set_visible(iter_106_1, "count_bg", false)
				end
			end
		end
	else
		UIAction:Add(SEQ(RLOG(FADE_OUT(250)), SHOW(false)), var_106_0, "block")
		
		local var_106_8 = var_106_0:getChildByName("n_unit_menus"):getChildren()
		
		for iter_106_2, iter_106_3 in pairs(var_106_8) do
			local var_106_9, var_106_10 = iter_106_3:getPosition()
			local var_106_11 = (iter_106_2 - 1) * 30
			local var_106_12 = 200 - var_106_11 / 2
			
			UIAction:Add(SEQ(DELAY(var_106_11), SPAWN(FADE_OUT(var_106_12), RLOG(MOVE_TO(var_106_12, var_106_9, var_106_10 - 300))), MOVE_TO(0, var_106_9, var_106_10)), iter_106_3, "block")
		end
	end
end

function Lobby.showAmazonPromotionButton(arg_107_0)
	if not AmazonPromotion:isEnable() then
		return 
	end
	
	local var_107_0 = EventPlatform:getAmazonPromotion()
	
	if not var_107_0 then
		return 
	end
	
	local var_107_1 = arg_107_0.vars.ui_layer:getChildByName("n_promotion")
	
	if not get_cocos_refid(var_107_1) then
		return 
	end
	
	var_107_1:setVisible(true)
	var_107_1:setOpacity(0)
	
	local var_107_2, var_107_3 = var_107_1:getPosition()
	
	var_107_1:setPositionY(var_107_3 - 300)
	UIAction:Add(SEQ(SPAWN(FADE_IN(200), LOG(MOVE_TO(200, var_107_2, var_107_3)))), var_107_1, "block")
	if_set(var_107_1, "t_period", T("ui_lobby_promotion_amazon_schedule", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_107_0.start_time,
		end_time = var_107_0.end_time
	})))
	if_set_visible(var_107_1, "img_noti", EventPlatform:isVisibleAmazonIndicator())
	if_set_sprite(var_107_1, "amazon_bg", EventPlatform:getAmazonCurrentBannerSprite())
end

function Lobby.closeAmazonPromotionButton(arg_108_0)
	if not AmazonPromotion:isEnable() then
		return 
	end
	
	if not EventPlatform:getAmazonPromotion() then
		return 
	end
	
	local var_108_0 = arg_108_0.vars.ui_layer:getChildByName("n_promotion")
	
	UIAction:Add(SEQ(RLOG(FADE_OUT(200)), SHOW(false)), var_108_0, "block")
	
	local var_108_1, var_108_2 = var_108_0:getPosition()
	
	UIAction:Add(SEQ(SPAWN(FADE_OUT(200), RLOG(MOVE_TO(200, var_108_1, var_108_2 - 300))), MOVE_TO(0, var_108_1, var_108_2)), var_108_0, "block")
end

function Lobby.openUnitUI(arg_109_0, arg_109_1)
	arg_109_0:toggleUnitMenuShortCut(false)
	SoundEngine:play("event:/ui/whoosh_a")
	
	if arg_109_1 == "Team" then
		SceneManager:nextScene("unit_ui")
	elseif arg_109_1 == "Detail" then
		SceneManager:nextScene("unit_ui", {
			mode = "Detail"
		})
	elseif arg_109_1 == "Skill" then
		SceneManager:nextScene("unit_ui", {
			mode = "Skill"
		})
	elseif arg_109_1 == "Sell" then
		SceneManager:nextScene("unit_ui", {
			mode = "Sell"
		})
	else
		balloon_message_with_sound("notyet_con")
	end
end

function Lobby.updateBanners(arg_110_0, arg_110_1)
	if not get_cocos_refid(arg_110_0.vars.ui_layer) then
		return 
	end
	
	AccountData.banners = {}
	
	for iter_110_0, iter_110_1 in pairs(arg_110_1 or {}) do
		local var_110_0 = string.split(iter_110_1.link, "=")
		local var_110_1 = string.split(var_110_0[1], "?")
		
		if var_110_1[2] ~= nil and var_110_1[2] == "pickup_id" then
			local var_110_2, var_110_3, var_110_4, var_110_5, var_110_6, var_110_7, var_110_8, var_110_9 = DB("gacha_ui", var_110_0[2], {
				"id",
				"limit",
				"background",
				"left_character",
				"right_character",
				"banner",
				"banner_data",
				"ui_type"
			})
			local var_110_10 = {
				touch_block = true,
				id = var_110_0[2],
				limit = var_110_3,
				background = var_110_4,
				left_character = var_110_5,
				right_character = var_110_6,
				banner = var_110_7,
				banner_data = var_110_8
			}
			
			if var_110_2 then
				var_110_10.use_lobby = true
				
				local var_110_11 = createGachaBanner(var_110_10)
				
				if var_110_9 == "customgroup" then
					table.push(AccountData.banners, {
						link = "epic7://gacha_unit?mode=gacha_customgroup",
						node = var_110_11
					})
				elseif var_110_9 == "customspecial" then
					if UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_CUSTOMGROUP) then
						table.push(AccountData.banners, {
							link = "epic7://gacha_unit?mode=gacha_customspecial",
							node = var_110_11
						})
					end
				else
					table.push(AccountData.banners, {
						node = var_110_11,
						link = iter_110_1.link
					})
				end
			else
				print("banner not found", var_110_0[2])
			end
		else
			local var_110_12 = parseEpic7Link(iter_110_1.link)
			local var_110_13 = true
			local var_110_16
			
			if (var_110_12.scene_name == "webevent" or var_110_12.scene_name == "event_popup") and var_110_12.params.event_mission then
				local var_110_14 = var_110_12.params.event_mission
				
				var_110_13 = false
				
				if EventMissionUtil:getEventTicket(var_110_14) then
					local var_110_15 = EventMissionUtil:createEventBanner(var_110_14)
					
					table.push(AccountData.banners, {
						node = var_110_15,
						link = iter_110_1.link,
						indicator = iter_110_1.indicator_enable == 1,
						event_mission = var_110_14
					})
				end
			elseif var_110_12.scene_name == "webevent" and var_110_12.params.custom_event_id then
				var_110_16 = to_n(var_110_12.params.custom_event_id)
				var_110_13 = false
				
				for iter_110_2, iter_110_3 in pairs(AccountData.custom_web_event_issued_list or {}) do
					if to_n(iter_110_3.event_id) == to_n(var_110_16) then
						var_110_13 = true
						
						break
					end
				end
			end
			
			if var_110_13 then
				table.push(AccountData.banners, {
					id = iter_110_1.banner_id,
					img = iter_110_1.img,
					link = iter_110_1.link,
					indicator = iter_110_1.indicator_enable == 1,
					start_time = iter_110_1.start_time,
					end_time = iter_110_1.end_time,
					mail_expose = iter_110_1.mail_expose,
					rolling_invisible = iter_110_1.rolling_invisible
				})
			end
		end
	end
	
	PromotionBanner:set(arg_110_0.vars.ui_layer:getChildByName("n_banner"), AccountData.banners or {})
end

function Lobby.updateGrowthGuideTalk(arg_111_0)
	if not get_cocos_refid(arg_111_0.vars.ui_layer) then
		return 
	end
	
	local var_111_0 = getChildByPath(arg_111_0.vars.ui_layer, "n_growth_guide/n_growth_talk")
	
	if_set_visible(var_111_0, nil, false)
	
	if GrowthGuide:isFinish(true) then
		return 
	end
	
	local var_111_1 = not GrowthGuide:isUnlock()
	local var_111_2 = GrowthGuide:isTracking()
	local var_111_3 = GrowthGuide:isClearedTutorial()
	
	if not var_111_3 and not var_111_2 then
		local var_111_4, var_111_5 = GrowthGuide:getGroupDB()
		
		if var_111_5 and table.count(var_111_5) > 0 then
			GrowthGuide:setTrackingGroupID(var_111_5[1].group_id)
		end
		
		return 
	end
	
	if not var_111_3 then
		return 
	end
	
	if var_111_1 then
		return 
	end
	
	if not var_111_2 then
		return 
	end
	
	local var_111_6 = GrowthGuide:getTrackingGroupID()
	
	if var_111_6 == nil then
		return 
	end
	
	local var_111_7 = GrowthGuide:getDBCurrentQuestByGroupID(var_111_6)
	
	if var_111_7 == nil then
		return 
	end
	
	if not GrowthGuide:isOpenQuest(var_111_7) then
		return 
	end
	
	local var_111_8 = GrowthGuide:getGroupDB(var_111_6)
	
	if var_111_8 == nil then
		return 
	end
	
	if_set_visible(var_111_0, nil, true)
	if_set(var_111_0, "label_count", string.format("%s %d/%d", T(var_111_8.group_name), GrowthGuide:getGroupProgress(var_111_6)))
	if_set(var_111_0, "txt_disc", T(var_111_7.quest_name))
	if_set_sprite(var_111_0, "emblem", var_111_8.group_icon)
	
	local var_111_9 = var_111_0:getChildByName("btn_growth_guide_talk")
	
	if get_cocos_refid(var_111_9) then
		var_111_9.quest_id = var_111_7.id
	end
	
	local var_111_10 = ConditionContentsManager:getGrowthGuideQuest():getScore(var_111_7.id)
	local var_111_11 = tonumber(totable(GrowthGuide:getQuestDB(var_111_7.id).value).count)
	
	if_set(var_111_0, "t_percent", var_111_10 .. " / " .. var_111_11)
	
	local var_111_12 = var_111_0:getChildByName("progress_bar")
	
	if get_cocos_refid(var_111_12) then
		var_111_12:setPercent(var_111_10 / var_111_11 * 100)
	end
	
	if UIAction:Find("growth_talk") then
		return 
	end
	
	UIAction:Add(LOOP(SEQ(DELAY(GAME_STATIC_VARIABLE.guidequest_navigator_rotate * 1000), LOG(FADE_OUT(400)), CALL(function()
		var_111_9:setTouchEnabled(false)
	end), DELAY(GAME_STATIC_VARIABLE.guidequest_navigator_hide * 1000), CALL(function()
		var_111_9:setTouchEnabled(true)
	end), LOG(FADE_IN(400)))), var_111_0, "growth_talk")
end

function Lobby.updateGrowthGuide(arg_114_0)
	if not get_cocos_refid(arg_114_0.vars.ui_layer) then
		return 
	end
	
	local var_114_0 = arg_114_0.vars.ui_layer:getChildByName("n_growth_guide")
	
	if_set_visible(var_114_0, nil, GrowthGuide:isUnlock() and not GrowthGuide:isFinish(true))
	
	local var_114_1 = GrowthGuide:getCountRewardableAllQuests()
	local var_114_2 = var_114_0:getChildByName("count_bg")
	
	if_set_visible(var_114_2, nil, var_114_1 > 0)
	if_set(var_114_2, "label_count", var_114_1)
	arg_114_0:updateGrowthGuideTalk()
end

function Lobby.isVisibleCommunityIndicator(arg_115_0, arg_115_1)
	local var_115_0 = AccountData.lobby_indicator
	
	if not var_115_0 then
		return false
	end
	
	if not var_115_0[arg_115_1] then
		return false
	end
	
	local var_115_1 = var_115_0[arg_115_1][getUserLanguage()]
	
	if not var_115_1 then
		return false
	end
	
	if not var_115_1.visible then
		return false
	end
	
	if (tonumber(var_115_1.visible) or 0) ~= 1 then
		return false
	end
	
	if os.time() > (tonumber(var_115_1.end_time) or 0) then
		return false
	end
	
	if (tonumber(var_115_1.start_time) or 0) < (Account:getConfigData("red_dot_" .. arg_115_1) or 0) then
		return false
	end
	
	return true
end

function Lobby.isShowCommunityIndicator(arg_116_0, arg_116_1)
	if arg_116_1 then
		return arg_116_0:isVisibleCommunityIndicator(arg_116_1)
	end
	
	return arg_116_0:isVisibleCommunityIndicator("stove") or arg_116_0:isVisibleCommunityIndicator("event") or arg_116_0:isVisibleCommunityIndicator("notice") or arg_116_0:isVisibleCommunityIndicator("youtube") or arg_116_0:isVisibleCommunityIndicator(arg_116_0:getFirstSocialName()) or arg_116_0:isVisibleCommunityIndicator("developer") or arg_116_0:isVisibleCommunityIndicator("patchnote") or AmazonPromotion:isEnable() and EventPlatform:isVisibleAmazonIndicator()
end

function Lobby.updateCommunityLastReadTime(arg_117_0, arg_117_1)
	if not arg_117_1 then
		return 
	end
	
	local var_117_0 = string.sub(arg_117_1, 15, -1)
	
	SAVE:setTempConfigData("red_dot_" .. var_117_0, os.time())
	
	return var_117_0
end

function Lobby.getFirstSocialName(arg_118_0)
	return Account:isJPN() and "twitter" or "facebook"
end

function Lobby.enterArena(arg_119_0)
	if getenv("is_review", "") == "1" then
		if SceneManager:getCurrentSceneName() == "pvp" then
			return 
		end
		
		local var_119_0 = os.time()
		
		if AccountData.pvp_info and var_119_0 < to_n(AccountData.pvp_info.next_season_start_time) and var_119_0 > to_n(AccountData.pvp_info.season_end_time) then
			SceneManager:nextScene("pvp_npc")
		else
			query("pvp_sa_lobby")
		end
	else
		PvpSelectPopup:show()
	end
end

function Lobby.showAllUINode(arg_120_0)
	local var_120_0 = SceneManager:getRunningUIRootScene()
	
	if var_120_0:getOpacity() >= 255 then
		return 
	end
	
	UIAction:Remove(var_120_0)
	UIAction:Add(SEQ(SHOW(true), FADE_IN(300)), var_120_0, "block")
	
	if TLRenderer:isActive() then
		arg_120_0.vars.tl_dir = nil
	end
end

function Lobby.isHideAllUINodeStatus(arg_121_0)
	if not arg_121_0.vars then
		return 
	end
	
	if MusicBoxUI.vars then
		if get_cocos_refid(MusicBoxUI.vars.wnd) and MusicBoxUI.vars.wnd:isVisible() then
			return 
		elseif MusicBoxUI:isPlaying() then
			local var_121_0 = SceneManager:getRunningPopupScene()
			
			if var_121_0 and table.count(var_121_0:getChildren()) > 1 then
				return 
			end
		end
	else
		local var_121_1 = SceneManager:getRunningPopupScene()
		
		if var_121_1 and table.count(var_121_1:getChildren()) > 0 then
			return 
		end
	end
	
	local var_121_2 = SceneManager:getAlertLayer()
	
	if var_121_2 and table.count(var_121_2:getChildren()) > 0 then
		return 
	end
	
	if BattleReady:isShow() then
		return 
	end
	
	if arg_121_0.vars and arg_121_0.vars.ui_layer and get_cocos_refid(arg_121_0.vars.ui_layer) then
		local var_121_3 = arg_121_0.vars.ui_layer:getChildByName("n_unit_ui")
		
		if get_cocos_refid(var_121_3) and var_121_3:isVisible() then
			return 
		end
		
		local var_121_4 = arg_121_0.vars.ui_layer:getChildByName(Account:isJPN() and "n_community_ja" or "n_community")
		
		if get_cocos_refid(var_121_4) and var_121_4:isVisible() then
			return 
		end
	end
	
	if arg_121_0:isBartenderMode() or arg_121_0:isGuerrillaMode() then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if Stove.enable and not Login.FSM:isCurrentState(LoginState.STANDBY) then
		return 
	end
	
	return true
end

function Lobby.hideAllUINode(arg_122_0)
	if not arg_122_0:isHideAllUINodeStatus() then
		return 
	end
	
	local var_122_0 = SceneManager:getRunningUIRootScene()
	
	UIAction:Add(SEQ(FADE_OUT(300), SHOW(false)), var_122_0, "block")
	
	if TLRenderer:isActive() then
		local var_122_1 = TLRenderer:getField()
		
		if var_122_1 then
			if var_122_1:getViewPortPosition() > 0 then
				arg_122_0.vars.tl_dir = -1
			else
				arg_122_0.vars.tl_dir = 1
			end
		end
	end
end
