ArenaNetLobby = {}
DEBUG.ignore_res_version = false
ARENA_TITLE_MIN_LEN = 2
ARENA_TITLE_MAX_LEN = 28

function MsgHandler.arena_net_enter_ready(arg_1_0)
	local var_1_0 = arg_1_0.arena_net_enter_info.arena_net_user_uid
	local var_1_1 = arg_1_0.arena_net_enter_info.arena_net_match_friend or false
	local var_1_2 = arg_1_0.arena_net_enter_info.arena_net_match_uri
	
	MatchService:init()
	MatchService:setUri(var_1_2)
	MatchService:setArenaUID(tostring(var_1_0))
	
	local var_1_3 = getenv("arena_net.url.match")
	
	if var_1_3 then
		MatchService:setUri(var_1_3)
	end
	
	if var_1_1 then
		LuaEventDispatcher:dispatchEvent("arena_net_invite_step", {
			success = true
		})
	elseif SceneManager:getCurrentSceneName() ~= "arena_net_lobby" then
		MatchService:query("arena_net_enter_lobby", nil, function(arg_2_0)
			SceneManager:nextScene("arena_net_lobby", arg_2_0)
		end)
	end
end

function ErrHandler.arena_net_enter_ready(arg_3_0, arg_3_1)
	LuaEventDispatcher:dispatchEvent("arena_net_invite_step", {
		success = false
	})
	
	if ContentDisable:byAlias("world_arena") then
		Dialog:msgBox(T("content_disable"))
	else
		Dialog:msgBox(T("game_connect_lost"))
	end
end

function MsgHandler.arena_net_lobby_update(arg_4_0)
	if arg_4_0 and arg_4_0.abuse_filter then
		add_abuse_filter_list(arg_4_0.abuse_filter)
	end
end

function MsgHandler.abuse_filter(arg_5_0)
	if arg_5_0 and arg_5_0.abuse_filter then
		add_abuse_filter_list(arg_5_0.abuse_filter)
	end
end

function HANDLER.arena_net_lobby(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_go" then
		ArenaNetLobby:onEvent("startMatch")
	elseif arg_6_1 == "btn_cancel" then
		ArenaNetLobby:onEvent("cancelMatch")
	elseif arg_6_1 == "btn_event_go" then
		ArenaNetLobby:onEvent("startEventMatch")
	elseif arg_6_1 == "btn_event_cancel" then
		ArenaNetLobby:onEvent("cancelEventMatch")
	elseif arg_6_1 == "btn_my_ranking" then
		ArenaNetVSMyRanking:show("league")
	elseif arg_6_1 == "btn_tab_1" then
		ArenaNetLobby:setMode("VS_RANK")
	elseif arg_6_1 == "btn_tab_2" then
		if ContentDisable:byAlias("world_arena_match_friend") then
			balloon_message(T("pvp_rta_cannot_use_now"))
			
			return 
		else
			ArenaNetLobby:setMode("VS_FRIEND")
		end
	elseif arg_6_1 == "btn_tab_3" then
		balloon_message_with_sound("notyet_dev")
	elseif arg_6_1 == "btn_tab_4" then
		balloon_message_with_sound("notyet_dev")
	elseif arg_6_1 == "btn_tab_5" then
		if ContentDisable:byAlias("world_arena_ranking") then
			balloon_message(T("pvp_rta_cannot_use_now"))
			
			return 
		else
			ArenaNetLobby:setMode("RANKING")
		end
	elseif arg_6_1 == "btn_tab_6" then
		if ContentDisable:byAlias("world_arena_halloffame") then
			balloon_message(T("pvp_rta_cannot_use_now"))
			
			return 
		end
		
		ArenaNetLobby:setMode("HALL")
	elseif arg_6_1 == "btn_tab_7" then
		if ContentDisable:byAlias("world_arena_result") then
			balloon_message(T("pvp_rta_cannot_use_now"))
			
			return 
		end
		
		ArenaNetLobby:setMode("BATTLE_RECORD")
	elseif arg_6_1 == "btn_tab_8" then
		ArenaNetLobby:setMode("VS_EVENT")
	elseif arg_6_1 == "btn_info" then
		LuaEventDispatcher:dispatchEvent("arena_net_battle_record", {
			event = "open_detail",
			info = arg_6_0.info
		})
	elseif arg_6_1 == "btn_creat" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "create"
		})
	elseif arg_6_1 == "btn_reset" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "renew"
		})
	elseif arg_6_1 == "btn_enter" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "join",
			info = arg_6_0.info
		})
	elseif arg_6_1 == "btn_search" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "search"
		})
	elseif arg_6_1 == "btn_sort" or arg_6_1 == "btn_sort_active" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "open_filter"
		})
	elseif arg_6_1 == "btn_open_search" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "open_search"
		})
	elseif arg_6_1 == "btn_close_search" then
		LuaEventDispatcher:dispatchEvent("arena_net_friend", {
			event = "close_search"
		})
	elseif arg_6_1 == "btn_ranking_category_league" then
		LuaEventDispatcher:dispatchEvent("arena_net_rank", {
			event = "category",
			name = "TOTAL"
		})
	elseif arg_6_1 == "btn_ranking_category_season" then
		LuaEventDispatcher:dispatchEvent("arena_net_rank", {
			event = "category",
			name = "LEAGUE"
		})
	elseif arg_6_1 == "btn_ranking_category_reward" then
		LuaEventDispatcher:dispatchEvent("arena_net_rank", {
			event = "category",
			name = "REWARD"
		})
	elseif arg_6_1 == "btn_ranking_category_event" then
		LuaEventDispatcher:dispatchEvent("arena_net_rank", {
			event = "category",
			name = "EVENT"
		})
	elseif arg_6_1 == "btn_history_category_common" then
		LuaEventDispatcher:dispatchEvent("arena_net_battle_record", {
			event = "RANKING"
		})
	elseif arg_6_1 == "btn_history_category_event" then
		LuaEventDispatcher:dispatchEvent("arena_net_battle_record", {
			event = "EVENT"
		})
	elseif arg_6_1 == "btn_ban_info" or arg_6_1 == "btn_ban_info_2" then
		if not ArenaNetLobbyBanInfo:isVisible() and not ArenaNetBattleDetailInfo:isShow() and not ArenaNetLobby:isLock() then
			ArenaNetLobbyBanInfo:showBanInfoPopup()
		end
	elseif arg_6_1 == "btn_more" then
		arg_6_0.parent:nextPage()
	elseif arg_6_1 == "btn_regularseason" then
		LuaEventDispatcher:dispatchEvent("arena_net_hall", {
			event = "REGULAR"
		})
	elseif arg_6_1 == "btn_e7wc" then
		LuaEventDispatcher:dispatchEvent("arena_net_hall", {
			event = "WORLD_CHAMPION"
		})
	elseif arg_6_1 == "btn_l_arrow" then
		ArenaNetHall:movePage(-1)
	elseif arg_6_1 == "btn_r_arrow" then
		ArenaNetHall:movePage(1)
	end
end

function HANDLER.pvplive_lounge_creat(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_yes" then
		ArenaNetCreatePopup:confirm()
	elseif arg_7_1 == "btn_cancel" then
		ArenaNetCreatePopup:close()
	elseif arg_7_1 == "check_box" then
		ArenaNetCreatePopup:togglePassword()
	elseif arg_7_1 == "btn_allow" or arg_7_1 == "btn_disallow" then
		ArenaNetCreatePopup:toggleAllowChat(arg_7_1)
	elseif arg_7_1 == "btn_close" then
		ArenaNetCreatePopup:close()
	end
end

function HANDLER.pvplive_lounge_pw(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_confirm" then
		ArenaNetPasswordPopup:confirm()
	elseif arg_8_1 == "btn_close" then
		ArenaNetPasswordPopup:close()
	end
end

function HANDLER.pvplive_invite(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1 == "btn1" then
		ArenaNetInvitePopup:setCategory("FRIEND")
	elseif arg_9_1 == "btn2" then
		ArenaNetInvitePopup:setCategory("KNIGHT")
	elseif arg_9_1 == "btn3" then
		ArenaNetInvitePopup:setCategory("RECENT")
	elseif arg_9_1 == "btn4" then
		ArenaNetInvitePopup:setCategory("SEARCH")
	elseif arg_9_1 == "btn_search" then
		ArenaNetInvitePopup:search()
	elseif arg_9_1 == "btn_battle" then
		ArenaNetInvitePopup:invite(arg_9_0, arg_9_0.info)
	elseif arg_9_1 == "btn_close" then
		ArenaNetInvitePopup:close()
	end
end

function MsgHandler.e7wc_reward_list(arg_10_0)
	if arg_10_0 then
		if ArenaNetLobby:getCurrentMode() == "HALL" then
			ArenaNetHall:updateChampionRing(arg_10_0)
			ArenaNetHall:initPage()
		end
		
		ArenaNetLobby:updateE7WCRewardCondition(arg_10_0)
	end
end

function MsgHandler.e7wc_reward_get(arg_11_0)
	if arg_11_0 then
		local var_11_0 = {
			effect = true,
			single = true
		}
		local var_11_1 = Account:addReward(arg_11_0.rewards, var_11_0).rewards[1].code
		
		if var_11_1 then
			local var_11_2 = ArenaNetHall:getE7WCInfoByRing(var_11_1)
			local var_11_3 = var_11_2.wc_info.ring_info
			
			var_11_3.acquired = true
			
			ArenaNetHall:updateChampionRingUI(var_11_2.wc_banner, var_11_2.wc_info.id, var_11_3)
			
			local var_11_4 = ArenaNetHall:getE7WCRewardInfos()
			
			ArenaNetLobby:updateE7WCRewardCondition(var_11_4)
		end
	end
end

function HANDLER.pvplive_2021_e7wc_banner(arg_12_0, arg_12_1)
	if arg_12_1 == "btn_video" then
		LuaEventDispatcher:dispatchEvent("arena_net_hall", {
			event = "open_video"
		})
	end
end

function HANDLER.pvplive_2022_e7wc_banner(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_video" then
		LuaEventDispatcher:dispatchEvent("arena_net_hall", {
			event = "open_video"
		})
	elseif arg_13_1 == "btn_reward" then
		local var_13_0 = ArenaNetHall:getE7WCInfoByIndex(2)
		
		if var_13_0 then
			ArenaNetHall:selectChampionRing(arg_13_0, var_13_0.wc_info)
		end
	end
end

function HANDLER.pvplive_2023_e7wc_banner(arg_14_0, arg_14_1)
	if arg_14_1 == "btn_video" then
		LuaEventDispatcher:dispatchEvent("arena_net_hall", {
			event = "open_video"
		})
	elseif arg_14_1 == "btn_reward" then
		local var_14_0 = ArenaNetHall:getE7WCInfoByIndex(3)
		
		if var_14_0 then
			ArenaNetHall:selectChampionRing(arg_14_0, var_14_0.wc_info)
		end
	end
end

function ArenaNetLobby.show(arg_15_0, arg_15_1, arg_15_2)
	arg_15_2 = arg_15_2 or {}
	arg_15_0.vars = {}
	arg_15_0.vars.parent = arg_15_2.parent or SceneManager:getDefaultLayer()
	arg_15_0.vars.base_wnd = load_dlg("pvplive_base", true, "wnd")
	
	arg_15_0.vars.base_wnd:setName("arena_net_lobby")
	arg_15_0.vars.parent:addChild(arg_15_0.vars.base_wnd)
	
	arg_15_0.vars.left_wnd = arg_15_0.vars.base_wnd:getChildByName("LEFT")
	arg_15_0.vars.right_wnd = arg_15_0.vars.base_wnd:getChildByName("RIGHT")
	
	if arg_15_2.offscreen then
		arg_15_0.vars.base_wnd:setVisible(false)
		
		return 
	end
	
	TopBarNew:create(T("arena_net_lobby"), arg_15_0.vars.parent, function()
		arg_15_0:onPushBackButton()
	end, {
		"crystal",
		"gold"
	}, nil, "inforta")
	if_set_visible(arg_15_0.vars.base_wnd, "LEFT", false)
	if_set_visible(arg_15_0.vars.base_wnd, "CENTER_1", false)
	if_set_visible(arg_15_0.vars.base_wnd, "CENTER_2", false)
	if_set_visible(arg_15_0.vars.base_wnd, "CENTER_5", false)
	if_set_visible(arg_15_0.vars.base_wnd, "CENTER_6", false)
	if_set_visible(arg_15_0.vars.base_wnd, "CENTER_7", false)
	if_set_visible(arg_15_0.vars.base_wnd, "CENTER_8", false)
	if_set_visible(arg_15_0.vars.base_wnd, "bg_main", false)
	
	arg_15_0.vars.lobby_info = arg_15_2.arena_net_lobby_info or arg_15_0.cached_lobby_info or {}
	arg_15_0.cached_lobby_info = table.clone(arg_15_0.vars.lobby_info)
	
	if arg_15_0.vars.lobby_info.error_code then
		local var_15_0 = (arg_15_0.vars.lobby_info.next_season_start_time or os.time()) - os.time()
		local var_15_1 = math.floor(var_15_0 / 3600)
		local var_15_2 = math.floor((var_15_0 - var_15_1 * 3600) / 60)
		local var_15_3 = T("pvp_rta_season_change_msg", {
			hour = var_15_1,
			min = var_15_2
		})
		
		if_set_visible(arg_15_0.vars.base_wnd, "bg_main", true)
		if_set_visible(arg_15_0.vars.base_wnd, "btn_tab_8", false)
		Dialog:msgBox(var_15_3, {
			handler = function()
				SceneManager:nextScene("lobby")
				SceneManager:resetSceneFlow()
			end
		})
		
		return 
	end
	
	arg_15_0.vars.modes = {
		VS_RANK = {
			ArenaNetVSRank,
			"n_main"
		},
		VS_FRIEND = {
			ArenaNetVSFriend,
			"n_base"
		},
		BATTLE_RECORD = {
			ArenaNetBattleRecord,
			"n_base"
		},
		SPECTATOR = {
			ArenaNetSpectator,
			"n_main"
		},
		REPLAY = {
			ArenaNetReplay,
			"n_main"
		},
		RANKING = {
			ArenaNetRanking,
			"n_base"
		},
		HALL = {
			ArenaNetHall,
			"n_base"
		},
		VS_EVENT = {
			ArenaNetVSEvent,
			"n_main"
		}
	}
	
	ArenaNetUserInfo:init(arg_15_0, "n_main")
	updateRegionIds(arg_15_0.vars.lobby_info)
	
	local var_15_4 = "VS_RANK"
	
	arg_15_0:setMode(arg_15_2.mode or var_15_4)
	arg_15_0:popupLobby()
	arg_15_0:updateBG()
	arg_15_0:updateRemainTime()
	
	local var_15_5 = DB("pvp_rta_season", arg_15_0.vars.lobby_info.season_info.id, {
		"bgm_lobby"
	})
	
	if var_15_5 then
		SoundEngine:playBGM("event:/bgm/" .. var_15_5)
	end
	
	TutorialGuide:ifStartGuide("rta_001")
	
	local var_15_6 = SAVE:getKeep("net_arena_join_info")
	
	if var_15_6 then
		SAVE:setKeep("net_arena_join_info", nil)
		Dialog:msgBox(T("pvp_rta_already_playing"), {
			yesno = true,
			handler = function()
				requestJoin(arg_15_0, var_15_6)
			end
		})
	end
	
	if_set_visible(arg_15_0.vars.base_wnd, "btn_tab_8", arg_15_0:isTimeOfEventMatch(true))
	
	if arg_15_0.vars.lobby_info.content_disable then
		ContentDisable:resetContentSwitchRta(arg_15_0.vars.lobby_info.content_disable)
	end
	
	arg_15_0:manageReplayFiles()
	query("arena_net_lobby_update")
	
	if not IS_PUBLISHER_ZLONG then
		query("e7wc_reward_list")
	end
	
	ConditionContentsManager:dispatch("pvprta.league")
end

function ArenaNetLobby.manageReplayFiles(arg_19_0)
	if not arg_19_0.vars or not arg_19_0.vars.lobby_info then
		return 
	end
	
	if arg_19_0.vars.lobby_info.battle_recent_limit_count then
		BattleViewer:removeReplayFilesByCount(arg_19_0.vars.lobby_info.battle_recent_limit_count)
	end
	
	if arg_19_0.vars.lobby_info.battle_recent_limit_day then
		BattleViewer:removeReplayFilesByDay(arg_19_0.vars.lobby_info.battle_recent_limit_day)
	end
end

function ArenaNetLobby.isVisible(arg_20_0)
	return arg_20_0.vars and get_cocos_refid(arg_20_0.vars.base_wnd)
end

function ArenaNetLobby.getSeasonInfo(arg_21_0)
	return arg_21_0.vars.lobby_info.season_info
end

function ArenaNetLobby.getEventSeasonInfo(arg_22_0)
	return arg_22_0.vars.lobby_info.event_info
end

function ArenaNetLobby.getSeasonId(arg_23_0)
	return arg_23_0.vars.lobby_info.season_info.id
end

function ArenaNetLobby.getEventSeasonId(arg_24_0)
	if arg_24_0.vars.lobby_info.event_info then
		return arg_24_0.vars.lobby_info.event_info.id
	end
end

function ArenaNetLobby.getUserInfo(arg_25_0)
	return arg_25_0.vars.lobby_info.user_info
end

function ArenaNetLobby.getEventUserInfo(arg_26_0)
	return arg_26_0.vars.lobby_info.user_info.event
end

function ArenaNetLobby.getReplayMinVersion(arg_27_0)
	local var_27_0 = arg_27_0.vars.lobby_info.replay_min_version
	
	if var_27_0 and type(var_27_0) == "number" then
		return var_27_0
	end
	
	return nil
end

function ArenaNetLobby.getBatchInfo(arg_28_0, arg_28_1)
	local var_28_0 = (arg_28_1.win or 0) + (arg_28_1.lose or 0) + (arg_28_1.draw or 0)
	
	if var_28_0 >= ARENA_MATCH_BATCH_COUNT then
		return 
	else
		return {
			cur = var_28_0,
			total = ARENA_MATCH_BATCH_COUNT
		}
	end
end

function ArenaNetLobby.updateBG(arg_29_0)
	local var_29_0 = arg_29_0.vars.lobby_info.season_info.id
	local var_29_1, var_29_2 = DB("pvp_rta_season", var_29_0, {
		"rta_bg2",
		"rta_bg3"
	})
	local var_29_3 = arg_29_0.vars.base_wnd:getChildByName("base")
	local var_29_4 = arg_29_0.vars.base_wnd:getChildByName("bg_main")
	
	if var_29_1 then
		SpriteCache:resetSprite(var_29_4, "img/" .. var_29_1 .. ".png")
	end
	
	if var_29_2 then
		SpriteCache:resetSprite(var_29_3, "img/" .. var_29_2 .. ".png")
	end
end

function ArenaNetLobby.updateRemainTime(arg_30_0)
	local var_30_0 = ArenaNetLobby:getUserInfo()
	local var_30_1 = arg_30_0.vars.lobby_info.user_info.league_id == "gold" and T("rta_time_limit_message_1") or T("rta_time_limit_message_2")
	local var_30_2 = (var_30_0.win or 0) + (var_30_0.draw or 0) + (var_30_0.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	if_set_visible(arg_30_0.vars.left_wnd, "n_point_info", true)
	
	if arg_30_0.vars.lobby_info.score_reduce_left < 0 or var_30_2 then
		if_set_visible(arg_30_0.vars.left_wnd, "n_point_info", false)
	elseif arg_30_0.vars.lobby_info.score_reduce_left <= 3600 then
		if_set(arg_30_0.vars.left_wnd, "t_time", T("rta_time_limit_lefttime3"))
		if_set(arg_30_0.vars.left_wnd, "t_point_info", var_30_1)
	elseif arg_30_0.vars.lobby_info.score_reduce_left <= 43200 then
		if_set(arg_30_0.vars.left_wnd, "t_time", T("rta_time_limit_lefttime2", {
			time = math.ceil(arg_30_0.vars.lobby_info.score_reduce_left / 3600)
		}))
		if_set(arg_30_0.vars.left_wnd, "t_point_info", var_30_1)
	elseif arg_30_0.vars.lobby_info.score_reduce_left <= 86400 then
		if_set(arg_30_0.vars.left_wnd, "t_time", T("rta_time_limit_lefttime1"))
		if_set(arg_30_0.vars.left_wnd, "t_point_info", var_30_1)
	else
		if_set_visible(arg_30_0.vars.left_wnd, "n_point_info", false)
	end
end

function ArenaNetLobby.popupLobby(arg_31_0)
	if not arg_31_0.vars.lobby_info or not arg_31_0.vars.lobby_info.season_change then
		return 
	end
	
	arg_31_0:popupNewSeason(arg_31_0.vars.lobby_info.season_change, function()
		arg_31_0:popupLastSeasonReward(arg_31_0.vars.lobby_info.season_change.season_reward, 1, 4)
	end)
end

function ArenaNetLobby.popupNewSeason(arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_1 or not arg_33_1.hall_of_fame then
		return 
	end
	
	local var_33_0 = load_dlg("pvp_season_change_honor", true, "wnd")
	local var_33_1 = arg_33_1.hall_of_fame
	local var_33_2
	local var_33_3 = var_33_0:getChildByName("n_season_info")
	local var_33_4, var_33_5 = DB("pvp_rta_season", var_33_1.last_season_id, {
		"season_name",
		"season_name_abb"
	})
	local var_33_6 = T("pvp_season_change_heroes_title", {
		season_name = T(var_33_4)
	})
	
	if_set(var_33_0, "txt_title", var_33_6)
	
	if UIUtil:isChangeSeasonLabelPosition() then
		var_33_2 = var_33_3:getChildByName("n_season_2/2")
		
		var_33_2:setVisible(true)
		if_set_visible(var_33_3, "n_season_1/2", false)
	else
		var_33_2 = var_33_3:getChildByName("n_season_1/2")
		
		var_33_2:setVisible(true)
		if_set_visible(var_33_3, "n_season_2/2", false)
	end
	
	if_set(var_33_2, "txt_season_number", T(var_33_5))
	if_set(var_33_3, "txt_season_period", T("season_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = arg_33_1.start_date,
		end_time = arg_33_1.end_date
	})))
	
	local var_33_7 = var_33_0:getChildByName("n_season_honor")
	
	for iter_33_0 = 1, 3 do
		local var_33_8 = var_33_1.ranking[iter_33_0]
		local var_33_9 = var_33_0:getChildByName("n_" .. iter_33_0)
		
		if var_33_8 then
			var_33_9:setVisible(true)
			if_set(var_33_9, "txt_user_name", var_33_8.user_name)
			if_set_visible(var_33_9, "txt_season_point", false)
			if_set(var_33_9, "txt_nation", getRegionText(var_33_8.user_world))
			
			local var_33_10 = var_33_8.border_code
			local var_33_11 = UNIT:create({
				code = var_33_8.leader_code
			})
			
			UIUtil:getUserIcon(var_33_11, {
				no_popup = true,
				no_lv = true,
				no_role = true,
				no_grade = true,
				parent = var_33_9:getChildByName("mob_icon_" .. iter_33_0),
				border_code = var_33_10
			})
		else
			var_33_9:setVisible(false)
		end
		
		if_set(var_33_9, "txt_clan", clanNameFilter(var_33_8.clan_name))
		UIUtil:updateClanEmblem(var_33_9:getChildByName("n_clan"), {
			emblem = var_33_8.clan_emblem
		})
		if_set_visible(var_33_9, "n_clan", string.len(var_33_8.clan_name or "") > 0)
		
		local var_33_12 = string.len(var_33_8.clan_name or "") > 0 and 0 or 23
		
		if_set_add_position_y(var_33_9, "txt_season_point", var_33_12)
		if_set_add_position_y(var_33_9, "txt_nation", var_33_12)
		
		local var_33_13 = 0.73 / var_33_9:getChildByName("txt_clan"):getScaleX()
		
		var_33_9:getChildByName("emblem_bg"):setScaleX(0.19 * var_33_13)
	end
	
	Dialog:msgBox(nil, {
		dlg = var_33_0,
		handler = arg_33_2
	})
end

function ArenaNetLobby.__testPopupNewSeason(arg_34_0)
	local var_34_0 = {
		last_season_id = "pvp_rta_ss1f",
		start_date = 1594350000,
		seqnum = 4,
		end_date = 1599102000,
		hall_of_fame = {
			last_season_id = "pvp_rta_ss1f",
			ranking = {
				{
					score = 1710,
					user_world = "world_kor",
					border_code = "ma_border1",
					season_rank = 1,
					season_id = "pvp_rta_ss1f",
					leader_code = "c1001",
					user_name = "tom5"
				},
				{
					score = 1303,
					user_world = "world_kor",
					border_code = "ma_border1",
					season_rank = 2,
					season_id = "pvp_rta_ss1f",
					leader_code = "c1001",
					user_name = "uuuuu"
				},
				{
					score = 1298,
					user_world = "world_kor",
					border_code = "ma_border15",
					season_rank = 3,
					season_id = "pvp_rta_ss1f",
					leader_code = "c3084",
					user_name = "cswqa1"
				}
			}
		}
	}
	
	arg_34_0:popupNewSeason(var_34_0)
end

function ArenaNetLobby.popupLastSeasonReward(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if not arg_35_1 or not arg_35_1.reward then
		return 
	end
	
	local var_35_0 = arg_35_1.reward
	local var_35_1 = {}
	
	for iter_35_0 = arg_35_2, arg_35_3 do
		local var_35_2 = "season_reward_id" .. tostring(iter_35_0)
		
		if var_35_0[var_35_2] then
			local var_35_3 = {
				id = var_35_0[var_35_2],
				count = var_35_0["season_reward_count" .. tostring(iter_35_0)]
			}
			
			table.insert(var_35_1, var_35_3)
		end
	end
	
	local var_35_4 = load_dlg("pvp_season_reward_p", true, "wnd")
	local var_35_5 = table.count(var_35_1)
	local var_35_6
	
	if_set_visible(var_35_4, "n_contents_1", false)
	if_set_visible(var_35_4, "n_contents_2", false)
	
	for iter_35_1 = 1, 4 do
		local var_35_7 = var_35_4:getChildByName("n_contents_" .. tostring(iter_35_1) .. "_new")
		
		if var_35_7 then
			var_35_7:setVisible(iter_35_1 == var_35_5)
			
			if iter_35_1 == var_35_5 then
				var_35_6 = var_35_7
			end
		end
	end
	
	for iter_35_2, iter_35_3 in pairs(var_35_1 or {}) do
		local var_35_8 = var_35_6:getChildByName("n_" .. tostring(iter_35_2))
		
		if var_35_8 then
			local var_35_9 = UIUtil:getItemDisplayInfo(iter_35_3.id)
			
			if_set(var_35_8, "txt_name", T(var_35_9.title))
			if_set(var_35_8, "txt_type", T(var_35_9.desc))
			if_set(var_35_8, "txt_desc", T(var_35_9.desc_text))
			UIUtil:getRewardIcon(iter_35_3.count, var_35_9.code, {
				parent = var_35_8:getChildByName("n_reward_icon")
			})
		end
	end
	
	local var_35_10
	
	for iter_35_4 = arg_35_2 + 4, arg_35_3 + 4 do
		if var_35_0["season_reward_id" .. tostring(iter_35_4)] then
			function var_35_10()
				arg_35_0:popupLastSeasonReward(arg_35_1, arg_35_2 + 4, arg_35_3 + 4)
			end
		end
	end
	
	Dialog:msgBox(nil, {
		dlg = var_35_4,
		handler = var_35_10
	})
end

function ArenaNetLobby.onPushBackButton(arg_37_0)
	if ArenaNetLobbyBanInfo:isVisible() then
		return 
	end
	
	if MatchService:isProgress() then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	if arg_37_0:isLock() then
		balloon_message(T("rta_match_disable_desc"))
	else
		Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
		MatchService:query("arena_net_unregister", nil)
		SceneManager:nextScene("lobby")
		SceneManager:resetSceneFlow()
	end
end

function ArenaNetLobby.onEvent(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.vars.modes[arg_38_0.vars.cur_name]
	
	if var_38_0 and var_38_0[1][arg_38_1] then
		var_38_0[1][arg_38_1](var_38_0[1], arg_38_2)
	end
end

function ArenaNetLobby.onLeave(arg_39_0)
	arg_39_0.vars = nil
end

function ArenaNetLobby.setLock(arg_40_0, arg_40_1)
	if not arg_40_0.vars then
		return 
	end
	
	arg_40_0.vars.lock = arg_40_1
end

function ArenaNetLobby.isLock(arg_41_0)
	return arg_41_0.vars and arg_41_0.vars.lock
end

function ArenaNetLobby.isTimeOfRankMatch(arg_42_0)
	local var_42_0 = {}
	
	if arg_42_0.vars.lobby_info then
		for iter_42_0, iter_42_1 in pairs(arg_42_0.vars.lobby_info.week_schedule or {}) do
			if iter_42_1.day_of_week then
				local var_42_1 = iter_42_1.day_of_week
				
				var_42_0[var_42_1] = var_42_0[var_42_1] or {}
				
				table.insert(var_42_0[var_42_1], iter_42_1)
			end
		end
		
		local var_42_2 = arg_42_0.vars.lobby_info.server_week_of_day
		
		if not var_42_0[var_42_2] then
			return true
		else
			for iter_42_2, iter_42_3 in pairs(var_42_0[var_42_2] or {}) do
				if tonumber(iter_42_3.start_time) <= os.time() and os.time() <= tonumber(iter_42_3.end_time) then
					return true
				end
			end
		end
	end
	
	return false
end

function ArenaNetLobby.isTimeOfEventMatch(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.vars.lobby_info.event_info
	
	if var_43_0 then
		if arg_43_1 then
			return os.time() < var_43_0.end_time + var_43_0.until_hide_time and os.time() > var_43_0.start_time
		else
			return os.time() < var_43_0.end_time and os.time() > var_43_0.start_time
		end
	end
	
	return false
end

function ArenaNetLobby.setSchedule(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_1 then
		arg_44_0.vars.lobby_info.week_schedule = arg_44_1
	end
	
	if arg_44_2 then
		arg_44_0.vars.lobby_info.server_week_of_day = arg_44_2
	end
end

function ArenaNetLobby.setMode(arg_45_0, arg_45_1)
	if arg_45_0.vars.cur_name == arg_45_1 then
		return 
	end
	
	if MatchService:isProgress() then
		return 
	end
	
	if arg_45_0:isLock() then
		balloon_message(T("rta_match_disable_desc"))
		
		return 
	end
	
	local var_45_0 = arg_45_0.vars.modes[arg_45_0.vars.cur_name]
	
	if var_45_0 then
		var_45_0[1]:unshow()
	end
	
	local var_45_1 = arg_45_0.vars.modes[arg_45_1]
	
	if var_45_1 then
		arg_45_0.vars.cur_name = arg_45_1
		
		var_45_1[1]:show(arg_45_0)
	end
	
	ArenaNetUserInfo:setMode(var_45_1[2])
	ArenaNetUserInfo:updateUserInfo(arg_45_1)
end

function ArenaNetLobby.getCurrentMode(arg_46_0)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.base_wnd) or not arg_46_0.vars.cur_name then
		return 
	end
	
	return arg_46_0.vars.cur_name
end

function ArenaNetLobby.updateE7WCRewardCondition(arg_47_0, arg_47_1)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.base_wnd) or not get_cocos_refid(arg_47_0.vars.right_wnd) then
		return 
	end
	
	arg_47_1 = arg_47_1 or {}
	
	local var_47_0 = false
	
	for iter_47_0, iter_47_1 in pairs(arg_47_1.reward_list or {}) do
		if os.time() < iter_47_1.expire_time and iter_47_1.acquired == nil then
			var_47_0 = true
			
			break
		end
	end
	
	local var_47_1 = "icon_noti"
	local var_47_2 = arg_47_0.vars.right_wnd:getChildByName("btn_tab_6")
	
	if var_47_2 and get_cocos_refid(var_47_2) then
		if_set_visible(var_47_2, var_47_1, var_47_0)
	end
	
	local var_47_3 = arg_47_0.vars.base_wnd:getChildByName("CENTER_6")
	
	if var_47_3 and get_cocos_refid(var_47_3) then
		if_set_visible(var_47_3, var_47_1, var_47_0)
	end
end

ArenaNetUserInfo = {}

function ArenaNetUserInfo.init(arg_48_0, arg_48_1, arg_48_2)
	arg_48_0.vars = {}
	arg_48_0.vars.wnd = arg_48_1.vars.base_wnd:getChildByName("LEFT")
	
	arg_48_0.vars.wnd:setVisible(true)
	
	arg_48_0.vars.cur_mode = "NONE"
	arg_48_0.vars.child_wnds = {
		n_main = arg_48_0.vars.wnd:getChildByName("n_main"),
		n_base = arg_48_0.vars.wnd:getChildByName("n_base"),
		n_base_zl = arg_48_0.vars.wnd:getChildByName("n_base_zl")
	}
end

function ArenaNetUserInfo.setMode(arg_49_0, arg_49_1)
	if arg_49_0.vars.cur_mode == arg_49_1 then
		return 
	end
	
	for iter_49_0, iter_49_1 in pairs(arg_49_0.vars.child_wnds) do
		iter_49_1:setVisible(false)
	end
	
	if arg_49_0.vars.child_wnds[arg_49_1] then
		arg_49_0.vars.child_wnds[arg_49_1]:setVisible(true)
		
		arg_49_0.vars.cur_mode = arg_49_1
	end
end

function ArenaNetUserInfo.updateUserInfo(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_1 == "VS_EVENT"
	local var_50_1 = var_50_0 and ArenaNetLobby:getEventSeasonInfo() or ArenaNetLobby:getSeasonInfo()
	local var_50_2 = var_50_0 and ArenaNetLobby:getEventUserInfo() or ArenaNetLobby:getUserInfo()
	local var_50_3 = ArenaNetLobby.vars.lobby_info.global_ban_info or {}
	local var_50_4 = var_50_3.units or {}
	local var_50_5 = var_50_3.artifacts or {}
	local var_50_6 = var_50_2.win or 0
	local var_50_7 = var_50_2.draw or 0
	local var_50_8 = var_50_2.lose or 0
	local var_50_9 = var_50_6 + var_50_7 + var_50_8
	local var_50_10 = var_50_9 == 0 and 0 or 100 * var_50_6 / var_50_9
	local var_50_11 = var_50_2.league_id or ""
	local var_50_12, var_50_13 = getArenaNetRankInfo(var_50_2.season_id, var_50_11)
	local var_50_14 = var_50_6 + var_50_7 + var_50_8
	local var_50_15
	local var_50_16
	
	if var_50_0 then
		local var_50_17 = false
		
		var_50_16 = nil
	else
		local var_50_18 = var_50_14 < ARENA_MATCH_BATCH_COUNT
		
		var_50_16 = ArenaNetLobby:getBatchInfo(var_50_2)
		AccountData.world_pvp_league = var_50_18 and "draft" or var_50_11
	end
	
	for iter_50_0, iter_50_1 in pairs(arg_50_0.vars.child_wnds) do
		local var_50_19 = iter_50_1:getChildByName("txt_season_title")
		local var_50_20 = iter_50_1:getChildByName("txt_season_remaining")
		local var_50_21 = to_n(var_50_1.end_term) < (var_50_1.end_time - os.time()) / 86400
		
		if var_50_19 and var_50_20 then
			var_50_19:setString(T(var_50_1.name))
			UIUserData:call(var_50_19, "SINGLE_WSCALE(212)")
			var_50_20:setString(sec_to_full_string(var_50_1.end_time - os.time()))
			
			if var_50_21 then
				var_50_19:setPositionY(611)
				var_50_20:setVisible(false)
			else
				var_50_19:setPositionY(623)
				var_50_20:setVisible(true)
			end
		end
		
		if_set_visible(iter_50_1, "txt_count_win", false)
		
		if var_50_16 then
			if_set_visible(iter_50_1, "n_normal", false)
			if_set_visible(iter_50_1, "n_tier_placement", true)
			if_set(iter_50_1, "txt_count", tostring(var_50_16.cur) .. "/" .. tostring(var_50_16.total))
			SpriteCache:resetSprite(iter_50_1:getChildByName("icon_league"), "emblem/" .. ARENA_UNRANK_ICON)
		else
			if_set_visible(iter_50_1, "n_normal", true)
			if_set_visible(iter_50_1, "n_tier_placement", false)
			if_set(iter_50_1, "txt_rank", T(var_50_12))
			SpriteCache:resetSprite(iter_50_1:getChildByName("icon_league"), "emblem/" .. var_50_13 .. ".png")
			
			if var_50_0 and var_50_14 == 0 then
				if_set(iter_50_1, "txt_total_rank", T("pvp_my_rank", {
					rank = ARENA_UNRANK_RATE
				}))
				if_set(iter_50_1, "txt_score", T("pvp_point", {
					point = ARENA_UNRANK_RATE
				}))
			else
				if_set(iter_50_1, "txt_total_rank", T("pvp_my_rank", {
					rank = var_50_2.season_rank
				}))
				if_set(iter_50_1, "txt_score", T("pvp_point", {
					point = comma_value(var_50_2.score or 0)
				}))
			end
		end
		
		if_set(iter_50_1, "txt_win", T("arena_wa_win_rate", {
			percent = string.format("%.1f", var_50_10)
		}))
		if_set(iter_50_1, "t_win", var_50_6)
		if_set(iter_50_1, "t_draw", var_50_7)
		if_set(iter_50_1, "t_lose", var_50_8)
		if_set(iter_50_1, "txt_count_conti_win", T("pvp_win_rapid", {
			count = comma_value(var_50_2.win_continue or 0)
		}))
		
		local var_50_23
		
		if table.empty(var_50_4) and table.empty(var_50_5) then
			if iter_50_0 == "n_main" then
				if_set_visible(iter_50_1, "btn_ban_info", false)
				if_set_visible(iter_50_1, "n_ban_none", true)
			else
				if_set_visible(iter_50_1, "btn_ban_info_2", false)
				if_set_visible(iter_50_1, "n_ban_none", true)
			end
		else
			local var_50_22 = iter_50_1:getChildByName("n_ban_list")
			
			var_50_23 = 1
			
			local var_50_24 = table.count(var_50_4) + table.count(var_50_5)
			
			for iter_50_2, iter_50_3 in pairs(var_50_4 or {}) do
				UIUtil:getRewardIcon(nil, var_50_4[iter_50_2].code, {
					no_popup = true,
					no_frame = true,
					no_tooltip = true,
					no_count = true,
					scale = 0.5,
					parent = iter_50_1:getChildByName("n_" .. tostring(var_50_23))
				})
				
				var_50_23 = var_50_23 + 1
			end
			
			for iter_50_4, iter_50_5 in pairs(var_50_5 or {}) do
				UIUtil:getRewardIcon(nil, var_50_5[iter_50_4].code, {
					no_popup = true,
					no_tooltip = true,
					no_count = true,
					scale = 0.35,
					parent = iter_50_1:getChildByName("n_" .. tostring(var_50_23))
				})
				
				var_50_23 = var_50_23 + 1
			end
		end
	end
end

ArenaNetMatchBanner = {}

function ArenaNetMatchBanner.show(arg_51_0, arg_51_1, arg_51_2)
	arg_51_1 = arg_51_1 or SceneManager:getRunningPopupScene()
	arg_51_0.vars = {}
	arg_51_0.vars.wnd = load_dlg("pvplive_match", true, "wnd")
	
	arg_51_0.vars.wnd:setVisible(false)
	
	local var_51_0 = arg_51_0.vars.wnd:getChildByName("img_vs")
	
	var_51_0:setVisible(false)
	
	local var_51_1, var_51_2 = var_51_0:getPosition()
	local var_51_3 = ArenaService:getMatchMode() == "net_rank"
	
	arg_51_0:setUserInfo(arg_51_0.vars.wnd:getChildByName("n_left"), arg_51_2.user_info or {}, arg_51_2.first_pick_arena_uid, arg_51_2.user_profile, false)
	arg_51_0:setUserInfo(arg_51_0.vars.wnd:getChildByName("n_right"), arg_51_2.enemy_user_info or {}, arg_51_2.first_pick_arena_uid, arg_51_2.enemy_user_profile, var_51_3)
	
	local var_51_4 = 250
	local var_51_5 = 2000
	
	UIAction:Add(SEQ(FADE_IN(200), DELAY(5000), CALL(arg_51_0.destroy, arg_51_0)), arg_51_0.vars.wnd, "match.banner")
	UIAction:Add(SLIDE_IN(var_51_4, var_51_5), arg_51_0.vars.wnd:getChildByName("n_left"), "block")
	UIAction:Add(SLIDE_IN(var_51_4, -var_51_5), arg_51_0.vars.wnd:getChildByName("n_right"), "block")
	EffectManager:Play({
		scale = 1,
		z = 99999,
		fn = "ui_livepvp_vs_eff.cfx",
		layer = arg_51_0.vars.wnd,
		x = var_51_1,
		y = var_51_2
	})
	arg_51_1:addChild(arg_51_0.vars.wnd)
end

function ArenaNetMatchBanner.destroy(arg_52_0)
	arg_52_0.vars.wnd:removeFromParent()
	
	arg_52_0.vars = nil
end

function ArenaNetMatchBanner.setUserInfo(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	local var_53_0 = (arg_53_2.win or 0) + (arg_53_2.draw or 0) + (arg_53_2.lose or 0)
	local var_53_1 = ArenaService:getMatchMode()
	local var_53_2 = ArenaService:getSeasonId()
	local var_53_3 = var_53_1 == "net_event_rank" and arg_53_2.event.league_id or arg_53_2.league_id
	local var_53_4 = var_53_1 == "net_event_rank" and arg_53_2.event.season_rank or arg_53_2.season_rank
	local var_53_5 = var_53_1 == "net_event_rank" and arg_53_2.event.score or arg_53_2.score
	local var_53_6, var_53_7 = getArenaNetRankInfo(var_53_2, var_53_3)
	local var_53_8
	local var_53_9 = (var_53_1 ~= "net_event_rank" or false) and var_53_0 < ARENA_MATCH_BATCH_COUNT
	local var_53_10 = arg_53_1:getChildByName("n_custom_card")
	
	if get_cocos_refid(var_53_10) and arg_53_4 ~= nil then
		if type(arg_53_4) == "string" and string.len(arg_53_4) <= 0 then
			arg_53_4 = {}
		end
		
		local var_53_11
		
		if not table.empty(arg_53_4) then
			local var_53_12 = arg_53_2.user_id == Account:getUserId()
			local var_53_13 = SAVE:getOptionData("option.profile_off", default_options.profile_off) == true
			
			if not var_53_12 and var_53_13 then
				var_53_11 = CustomProfileCard:create({
					is_default = true,
					is_capture = true,
					leader_code = arg_53_2.leader_code,
					face_id = arg_53_2.face_id or 0
				})
			else
				var_53_11 = CustomProfileCard:create({
					is_capture = true,
					card_data = arg_53_4.data
				})
			end
		else
			var_53_11 = CustomProfileCard:create({
				is_default = true,
				is_capture = true,
				leader_code = arg_53_2.leader_code,
				face_id = arg_53_2.face_id or 0
			})
		end
		
		if var_53_11 then
			local var_53_14 = var_53_11:getWnd()
			
			if get_cocos_refid(var_53_14) then
				var_53_10:addChild(var_53_14)
			end
		end
	end
	
	local var_53_15 = arg_53_1:getChildByName("n_normal")
	local var_53_16 = arg_53_1:getChildByName("n_tier_placement")
	
	if var_53_9 then
		var_53_15:setVisible(false)
		var_53_16:setVisible(true)
		if_set(var_53_16, "txt_tier_placement", T(ARENA_UNRANK_TEXT))
		SpriteCache:resetSprite(var_53_16:getChildByName("icon_league"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		var_53_15:setVisible(true)
		var_53_16:setVisible(false)
		
		if var_53_1 == "net_event_rank" and var_53_0 == 0 then
			if_set(var_53_15, "txt_total_rank", T("pvp_my_rank", {
				rank = ARENA_UNRANK_RATE
			}))
			if_set(var_53_15, "txt_rating", T("pvp_point", {
				point = ARENA_UNRANK_RATE
			}))
		else
			if_set(var_53_15, "txt_total_rank", T("pvp_my_rank", {
				rank = var_53_4
			}))
			if_set(var_53_15, "txt_rating", T("pvp_point", {
				point = comma_value(var_53_5 or 0)
			}))
		end
		
		if_set(var_53_15, "txt_grade", T(var_53_6))
		SpriteCache:resetSprite(var_53_15:getChildByName("icon_league"), "emblem/" .. var_53_7 .. ".png")
	end
	
	if arg_53_5 then
		if_set_visible(arg_53_1, "txt_nation", false)
		if_set_visible(arg_53_1, "icon_menu_global", false)
		if_set_visible(arg_53_1, "n_clan", false)
		if_set(arg_53_1, "txt_name", T("pvp_blind_name"))
		
		local var_53_17 = arg_53_1:getChildByName("n_name_unknown")
		
		if_set_position(arg_53_1, "txt_name", var_53_17:getPositionX(), var_53_17:getPositionY())
		
		local var_53_18 = arg_53_1:getChildByName("n_grade_unknown")
		
		if var_53_9 == false then
			if_set_position(arg_53_1, "txt_grade", var_53_18:getPositionX(), var_53_18:getPositionY())
			if_set_visible(arg_53_1, "txt_rating", false)
			if_set_visible(arg_53_1, "txt_total_rank", false)
			if_set_visible(arg_53_1, "icon_rank", false)
		end
	else
		if_set(arg_53_1, "txt_nation", getRegionText(arg_53_2.world))
		if_set(arg_53_1, "txt_name", check_abuse_filter(arg_53_2.name, ABUSE_FILTER.WORLD_NAME) or arg_53_2.name)
		
		local var_53_19 = string.len(arg_53_2.clan_name or "") > 0
		
		if var_53_19 then
			if_set(arg_53_1, "txt_clan", clanNameFilter(arg_53_2.clan_name))
			UIUtil:updateClanEmblem(arg_53_1:getChildByName("n_clan"), {
				emblem = arg_53_2.clan_emblem
			})
		else
			local var_53_20 = arg_53_1:getChildByName("txt_name")
			
			if get_cocos_refid(var_53_20) then
				var_53_20:setPositionY(var_53_20:getPositionY() - 10)
			end
			
			local var_53_21 = 16
			local var_53_22 = arg_53_1:getChildByName("txt_nation")
			
			if get_cocos_refid(var_53_22) then
				var_53_22:setPositionY(var_53_22:getPositionY() + var_53_21)
			end
			
			local var_53_23 = arg_53_1:getChildByName("icon_menu_global")
			
			if get_cocos_refid(var_53_23) then
				var_53_23:setPositionY(var_53_23:getPositionY() + var_53_21)
			end
		end
		
		if_set_visible(arg_53_1, "n_clan", var_53_19)
	end
	
	if arg_53_2.uid == arg_53_3 then
		UIAction:Add(SEQ(DELAY(800), SHOW(true), OPACITY(500, 0, 1)), arg_53_1:getChildByName("n_first_pick"), "first_pick_visible_act")
	end
end

ArenaNetVSRank = {}

function ArenaNetVSRank.show(arg_54_0, arg_54_1)
	arg_54_0.vars = {}
	arg_54_0.vars.wnd = arg_54_1.vars.base_wnd:getChildByName("CENTER_1")
	
	arg_54_0.vars.wnd:setVisible(true)
	
	arg_54_0.vars.bg = arg_54_1.vars.base_wnd:getChildByName("bg_main")
	
	arg_54_0.vars.bg:setVisible(true)
	
	arg_54_0.vars.tab = arg_54_1.vars.base_wnd:getChildByName("btn_tab_1")
	
	if_set_visible(arg_54_0.vars.tab, "bg", true)
	arg_54_0:updateInfo()
	arg_54_0:updateTeam()
	
	if ArenaNetLobby:isTimeOfRankMatch() then
		arg_54_0:matchBtnState("NORMAL")
	else
		arg_54_0:matchBtnState("NOT_MATCH_TIME")
	end
end

function ArenaNetVSRank.unshow(arg_55_0)
	arg_55_0.vars.wnd:setVisible(false)
	arg_55_0.vars.bg:setVisible(false)
	if_set_visible(arg_55_0.vars.tab, "bg", false)
end

function ArenaNetVSRank.updateInfo(arg_56_0)
	local var_56_0 = ArenaNetLobby:getSeasonInfo()
	
	if var_56_0 then
		local var_56_1 = to_n(var_56_0.end_term) < (var_56_0.end_time - os.time()) / 86400
		
		if_set(arg_56_0.vars.wnd, "txt_season_title", T(var_56_0.name))
		if_set(arg_56_0.vars.wnd, "txt_season_remaining", sec_to_full_string(var_56_0.end_time - os.time()))
		if_set_visible(arg_56_0.vars.wnd, "txt_season_current", var_56_1)
		if_set_visible(arg_56_0.vars.wnd, "txt_season_remaining", not var_56_1)
		
		local var_56_2 = var_56_1 and 568 or 588
		
		arg_56_0.vars.wnd:getChildByName("txt_season_title"):setPositionY(var_56_2)
	end
end

function ArenaNetVSRank.updateTeam(arg_57_0)
	arg_57_0.vars.team = Account:loadLocalCustomTeam("arena_net_last_team")
	
	for iter_57_0 = 1, 4 do
		local var_57_0 = arg_57_0.vars.wnd:getChildByName("pos" .. tostring(iter_57_0))
		
		if var_57_0 then
			var_57_0:removeAllChildren()
		end
	end
	
	for iter_57_1, iter_57_2 in pairs(arg_57_0.vars.team or {}) do
		if iter_57_2 then
			local var_57_1 = arg_57_0.vars.wnd:getChildByName("pos" .. tostring(iter_57_1))
			local var_57_2 = CACHE:getModel(iter_57_2.db.model_id, iter_57_2.db.skin, nil, iter_57_2.db.atlas, iter_57_2.db.model_opt)
			
			var_57_2:setName("rank.team." .. tostring(iter_57_1))
			
			if var_57_1 and var_57_2 and not var_57_1:getChildByName("rank.team." .. tostring(iter_57_1)) then
				var_57_2:setScale(1.15)
				var_57_1:addChild(var_57_2)
			end
		end
	end
	
	local var_57_3 = math.random(1, #arg_57_0.vars.team)
	
	for iter_57_3, iter_57_4 in pairs(arg_57_0.vars.team or {}) do
		local var_57_4 = arg_57_0.vars.wnd:getChildByName("pos" .. tostring(iter_57_3))
		
		if var_57_4 then
			local var_57_5 = var_57_4:getChildByName("rank.team." .. tostring(iter_57_3))
			
			if var_57_5 then
				var_57_5:setNoSoundAniFlag("b_idle_ready", true)
				var_57_5:setNoSoundAniFlag("b_idle", true)
				UIAction:Add(SEQ(DMOTION("b_idle_ready", false), MOTION("b_idle", true), CALL(function()
					var_57_5:setNoSoundAniFlag("b_idle_ready", false)
					var_57_5:setNoSoundAniFlag("b_idle", false)
				end)), var_57_5, "arena_net.lobby.model" .. tostring(iter_57_3))
				
				if iter_57_3 == var_57_3 then
					ccexp.SoundEngine:playBattle("event:/model/" .. var_57_5.res_id .. "/ani/" .. "b_idle_ready")
					ccexp.SoundEngine:play("event:/voc/character/" .. var_57_5.res_id .. "/ani/" .. "b_idle_ready")
					ccexp.SoundEngine:playBattle("event:/model/" .. var_57_5.res_id .. "/ani/" .. "b_idle")
					ccexp.SoundEngine:play("event:/voc/character/" .. var_57_5.res_id .. "/ani/" .. "b_idle")
				end
			end
		end
	end
end

function ArenaNetVSRank.startMatch(arg_59_0)
	if ContentDisable:byAlias("world_arena") or ContentDisable:byAlias("world_arena_match_rank") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if ArenaNetLobby:isLock() then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	if not ArenaNetLobby:isTimeOfRankMatch() then
		balloon_message_with_sound("pvp_rta_not_playtime")
		
		return 
	end
	
	local var_59_0, var_59_1 = checkCanStartMatch()
	
	if var_59_1 then
		Dialog:msgBox(T("arena_wa_notenough_4hero"))
		
		return 
	end
	
	if BackPlayControlBox:getWnd() then
		return 
	end
	
	ArenaNetLobby:setLock(true)
	UIAction:Add(SEQ(DELAY(1500)), arg_59_0, "block")
	MatchService:query("arena_net_register_match", nil, function(arg_60_0)
		if arg_60_0.match_register_info.result == 1 then
			arg_59_0.vars.start_time = os.time()
			
			arg_59_0:startWatch()
			arg_59_0:updateTime()
			arg_59_0:matchBtnState("CANCEL")
			ArenaNetLobby:setSchedule(arg_60_0.match_register_info.week_schedule, arg_60_0.match_register_info.server_week_of_day)
			LuaEventDispatcher:dispatchEvent("invite.event", "hide")
		else
			Log.i("register match fail", table.print(arg_60_0.match_register_info))
			ArenaNetLobby:setLock(false)
			ArenaNetLobby:setSchedule(arg_60_0.match_register_info.week_schedule, arg_60_0.match_register_info.server_week_of_day)
			arg_59_0:matchBtnState("NORMAL")
			
			if arg_60_0.match_register_info.err_msg then
				if string.starts(arg_60_0.match_register_info.err_msg, "no_arena") then
					Dialog:msgBox(T("server_busy_msg"))
				elseif string.starts(arg_60_0.match_register_info.err_msg, "already_playing") then
					balloon_message_with_sound("error_try_again")
				elseif string.starts(arg_60_0.match_register_info.err_msg, "already_lounge") then
					balloon_message_with_sound("pvp_rta_mock_already_in")
				elseif string.starts(arg_60_0.match_register_info.err_msg, "week_schedule_off") then
					arg_59_0:matchBtnState("NOT_MATCH_TIME")
					Dialog:msgBox(T("pvp_rta_not_playtime"))
				elseif string.starts(arg_60_0.match_register_info.err_msg, "content_disable") then
					Dialog:msgBox(T("content_disable"))
				else
					balloon_message_with_sound("error_try_again")
				end
			end
		end
	end)
end

function ArenaNetVSRank.cancelMatch(arg_61_0)
	if not ArenaNetLobby:isLock() then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	UIAction:Add(SEQ(DELAY(1000)), arg_61_0, "block")
	MatchService:query("arena_net_unregister", nil, function(arg_62_0)
		if arg_62_0.match_unregister_info.result == 1 then
			arg_61_0.vars.start_time = nil
			
			UIAction:Add(SEQ(DELAY(1000)), arg_61_0, "block")
			UIAction:Remove("match.canceling")
			Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
			ArenaNetLobby:setLock(false)
			arg_61_0:matchBtnState("NORMAL")
			arg_61_0:updateTime()
			LuaEventDispatcher:dispatchEvent("invite.event", "reload")
		end
	end)
	UIAction:Add(SEQ(DELAY(1000), CALL(function()
		arg_61_0:matchBtnState("CANCELING")
	end)), arg_61_0, "match.canceling")
end

function ArenaNetVSRank.startWatch(arg_64_0)
	arg_64_0.scheduler = Scheduler:addGlobalInterval(ARENA_MATCH_INTERVAL, arg_64_0.update, arg_64_0)
	
	arg_64_0.scheduler:setName(ARENA_MATCH_SCHEDULER)
end

function ArenaNetVSRank.update(arg_65_0)
	arg_65_0:watch()
	arg_65_0:updateTime()
end

function ArenaNetVSRank.watch(arg_66_0)
	MatchService:query("arena_net_polling_match", nil, function(arg_67_0)
		if arg_67_0.match_info and arg_67_0.match_info.match_success == 1 then
			UIAction:Remove("match.canceling")
			Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
			ArenaService:init(arg_67_0.match_info)
		elseif arg_67_0.match_info and arg_67_0.match_info.keep_matching == 0 then
			Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
			ArenaNetLobby:setLock(false)
			arg_66_0:matchBtnState("NORMAL")
			
			if arg_67_0.match_info.err_code then
				if string.starts(arg_67_0.match_info.err_code, "no_arena") then
					Dialog:msgBox(T("server_busy_msg"))
				elseif string.starts(arg_67_0.match_info.err_code, "limit_match_try_max") then
					Dialog:msgBox(T("arena_wa_cancle_match"))
				elseif string.starts(arg_67_0.match_info.err_code, "week_schedule_off") then
					arg_66_0:matchBtnState("NOT_MATCH_TIME")
					Dialog:msgBox(T("pvp_rta_not_playtime"))
				end
			end
		end
	end)
end

function ArenaNetVSRank.updateTime(arg_68_0)
	local var_68_0 = arg_68_0.vars.wnd:getChildByName("btn_cancel")
	local var_68_1 = arg_68_0.vars.start_time and os.time() - arg_68_0.vars.start_time or 0
	local var_68_2 = math.floor(var_68_1 / 60)
	local var_68_3 = string.format("%02d:%02d", var_68_2 % 60, var_68_1 % 60)
	
	if_set(var_68_0, "t_time", var_68_3)
end

function ArenaNetVSRank.matchBtnState(arg_69_0, arg_69_1)
	if not arg_69_0.vars then
		return 
	end
	
	if not arg_69_0.vars.wnd or not get_cocos_refid(arg_69_0.vars.wnd) then
		return 
	end
	
	local var_69_0 = arg_69_0.vars.wnd:getChildByName("btn_cancel"):getChildByName("icon")
	
	if_set_visible(arg_69_0.vars.wnd, "n_watching", false)
	
	if arg_69_1 == "NORMAL" then
		if_set_visible(arg_69_0.vars.wnd, "btn_go", true)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel", false)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel_msg", false)
		if_set_color(arg_69_0.vars.wnd, "btn_go", tocolor("#ffffff"))
		
		local var_69_1 = var_69_0:getRotationSkewX() < -180 and -360 or -180
		
		UIAction:Remove("match.auto")
		var_69_0:setRotation(var_69_1)
	elseif arg_69_1 == "CANCEL" then
		if_set_visible(arg_69_0.vars.wnd, "btn_go", false)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel", true)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel_msg", false)
		if_set_color(arg_69_0.vars.wnd, "btn_go", tocolor("#ffffff"))
		
		local var_69_2 = 0
		
		UIAction:Remove("match.auto")
		UIAction:Add(LOOP(ROTATE(2000, var_69_2, var_69_2 - 360)), var_69_0, "match.auto")
	elseif arg_69_1 == "CANCELING" then
		if_set_visible(arg_69_0.vars.wnd, "btn_go", false)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel", false)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel_msg", true)
		if_set_color(arg_69_0.vars.wnd, "btn_go", tocolor("#ffffff"))
	elseif arg_69_1 == "NOT_MATCH_TIME" then
		if_set_visible(arg_69_0.vars.wnd, "btn_go", true)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel", false)
		if_set_visible(arg_69_0.vars.wnd, "btn_cancel_msg", false)
		if_set_color(arg_69_0.vars.wnd, "btn_go", tocolor("#7f7f7f"))
		
		local var_69_3 = var_69_0:getRotationSkewX() < -180 and -360 or -180
		
		UIAction:Remove("match.auto")
		var_69_0:setRotation(var_69_3)
	end
end

ArenaNetVSFriend = {}
ArenaNetSpectator = {}
ArenaNetReplay = {}
ArenaNetRanking = {}

function HANDLER.ArenaNetRoomFilter(arg_70_0, arg_70_1)
	if arg_70_0.owner then
		arg_70_0.owner:onEvent(arg_70_0.event, arg_70_0.item)
	end
end

ArenaNetRoomFilter = {}
ArenaNetRoomFilter.bind_infos = {
	{
		event = "all",
		group = "group1",
		ctrl = "n_check_box_all"
	},
	{
		event = "public",
		group = "group1",
		ctrl = "n_check_box_open_room"
	},
	{
		event = "private",
		group = "group1",
		ctrl = "n_check_box_private_room"
	},
	{
		event = "number",
		group = "group2",
		ctrl = "n_sort_number"
	},
	{
		event = "recent",
		group = "group2",
		ctrl = "n_sort_recent"
	}
}

function ArenaNetRoomFilter.create(arg_71_0, arg_71_1)
	local var_71_0 = load_control("wnd/sorting_filter_2.csb")
	
	copy_functions(ArenaNetRoomFilter, var_71_0)
	
	return var_71_0
end

function ArenaNetRoomFilter.init(arg_72_0, arg_72_1)
	arg_72_0.vars = {}
	arg_72_0.vars.control_group = {}
	arg_72_0.vars.change_callback = arg_72_1.change_callback
	
	arg_72_0:setName("ArenaNetRoomFilter")
	arg_72_0:bind()
	arg_72_0:selectGroup1(arg_72_1.public or "all")
	arg_72_0:selectGroup2(arg_72_1.sort or "number")
	arg_72_0:selectOrder(arg_72_1.order or "down")
end

function ArenaNetRoomFilter.close(arg_73_0)
	arg_73_0.vars = nil
	
	arg_73_0:removeFromParent()
end

function ArenaNetRoomFilter.bind(arg_74_0)
	for iter_74_0, iter_74_1 in pairs(ArenaNetRoomFilter.bind_infos) do
		local var_74_0 = arg_74_0:getChildByName(iter_74_1.ctrl)
		
		if var_74_0 then
			var_74_0.group = iter_74_1.group
			var_74_0.event = iter_74_1.event
			
			local var_74_1 = var_74_0:getChildByName("btn")
			
			var_74_1.owner = arg_74_0
			var_74_1.item = var_74_0
			arg_74_0.vars.control_group[iter_74_1.group] = arg_74_0.vars.control_group[iter_74_1.group] or {}
			arg_74_0.vars.control_group[iter_74_1.group][iter_74_1.event] = var_74_0
		else
			Log.e("room filter ctrl bind fail", iter_74_1.ctrl)
		end
	end
	
	local var_74_2 = arg_74_0:getChildByName("btn_toggle")
	
	if var_74_2 then
		var_74_2.owner = arg_74_0
		var_74_2.event = "close"
	end
end

function ArenaNetRoomFilter.onEvent(arg_75_0, arg_75_1, arg_75_2)
	if arg_75_1 == "close" then
		arg_75_0:close()
	else
		if UIAction:Find("event.delay") then
			balloon_message_with_sound("error_try_again")
			
			return 
		end
		
		UIAction:Add(SEQ(DELAY(1000)), arg_75_0, "event.delay")
		
		if arg_75_2.group == "group1" then
			if arg_75_0:selectGroup1(arg_75_2.event) then
				arg_75_0:refresh()
			end
		elseif arg_75_2.group == "group2" then
			if not arg_75_0:selectGroup2(arg_75_2.event) then
				arg_75_0:toggleOrder()
			end
			
			arg_75_0:refresh()
			arg_75_0:close()
		end
	end
end

function ArenaNetRoomFilter.refresh(arg_76_0)
	if arg_76_0.vars.change_callback then
		arg_76_0.vars.change_callback(arg_76_0.vars.selected_group1, arg_76_0.vars.selected_group2, arg_76_0.vars.selected_order)
	end
end

function ArenaNetRoomFilter.selectGroup1(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0.vars.control_group.group1.all:getChildByName("checkbox")
	local var_77_1 = arg_77_0.vars.control_group.group1.public:getChildByName("checkbox")
	local var_77_2 = arg_77_0.vars.control_group.group1.private:getChildByName("checkbox")
	local var_77_3 = arg_77_0.vars.control_group.group1.all:getChildByName("select_bg")
	local var_77_4 = arg_77_0.vars.control_group.group1.public:getChildByName("select_bg")
	local var_77_5 = arg_77_0.vars.control_group.group1.private:getChildByName("select_bg")
	local var_77_6 = arg_77_0.vars.control_group.group1.all:getChildByName("icon_all")
	local var_77_7 = arg_77_0.vars.control_group.group1.public:getChildByName("t_openroom")
	local var_77_8 = arg_77_0.vars.control_group.group1.private:getChildByName("t_private_room")
	
	if arg_77_1 == "all" then
		var_77_0:setSelected(not var_77_0:isSelected())
		var_77_1:setSelected(not var_77_0:isSelected())
		var_77_2:setSelected(not var_77_0:isSelected())
	elseif arg_77_1 == "public" then
		var_77_1:setSelected(not var_77_1:isSelected())
		var_77_0:setSelected(not var_77_1:isSelected() and not var_77_2:isSelected())
	elseif arg_77_1 == "private" then
		var_77_2:setSelected(not var_77_2:isSelected())
		var_77_0:setSelected(not var_77_1:isSelected() and not var_77_2:isSelected())
	end
	
	local var_77_9 = arg_77_0.vars.selected_group1
	
	if var_77_0:isSelected() then
		arg_77_0.vars.selected_group1 = "all"
	elseif var_77_1:isSelected() and var_77_2:isSelected() then
		arg_77_0.vars.selected_group1 = "all"
	elseif var_77_1:isSelected() then
		arg_77_0.vars.selected_group1 = "public"
	else
		arg_77_0.vars.selected_group1 = "private"
	end
	
	var_77_3:setVisible(var_77_0:isSelected())
	var_77_4:setVisible(var_77_1:isSelected())
	var_77_5:setVisible(var_77_2:isSelected())
	var_77_6:setColor(var_77_0:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	var_77_7:setTextColor(var_77_1:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	var_77_8:setTextColor(var_77_2:isSelected() and cc.c3b(100, 203, 0) or cc.c3b(136, 136, 136))
	
	return var_77_9 ~= arg_77_0.vars.selected_group1
end

function ArenaNetRoomFilter.selectGroup2(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0:getChildByName("n_sort_cursor")
	
	for iter_78_0, iter_78_1 in pairs(arg_78_0.vars.control_group.group2 or {}) do
		if iter_78_0 == arg_78_1 then
			var_78_0:setPositionY(iter_78_1:getChildByName("btn"):getPositionY())
		end
	end
	
	local var_78_1 = arg_78_0.vars.selected_group2
	
	arg_78_0.vars.selected_group2 = arg_78_1
	
	return var_78_1 ~= arg_78_0.vars.selected_group2
end

function ArenaNetRoomFilter.selectOrder(arg_79_0, arg_79_1)
	arg_79_0.vars.selected_order = arg_79_1
	
	local var_79_0 = arg_79_0:getChildByName("n_sort_cursor")
	
	if_set_visible(var_79_0, "btn_up", arg_79_1 == "up")
	if_set_visible(var_79_0, "btn_down", arg_79_1 == "down")
end

function ArenaNetRoomFilter.toggleOrder(arg_80_0)
	if arg_80_0.vars.selected_order == "down" then
		arg_80_0.vars.selected_order = "up"
	else
		arg_80_0.vars.selected_order = "down"
	end
end

ArenaNetVSFriend.PAGE_SIZE = 10

function requestJoin(arg_81_0, arg_81_1, arg_81_2)
	local var_81_0 = {
		lounge_id = tostring(arg_81_1),
		password = arg_81_2
	}
	
	MatchService:query("arena_net_join_lounge", var_81_0, function(arg_82_0)
		if arg_82_0.join_info and arg_82_0.join_info.join_success == 1 then
			ArenaNetPasswordPopup:close()
			ArenaService:init(arg_82_0.join_info)
		else
			local var_82_0 = (arg_82_0.join_info or {}).err_code or ""
			
			if string.starts(var_82_0, "invalid_password") then
				if arg_81_0.itemRefresh then
					arg_81_0:itemRefresh(arg_81_1, "public")
				end
				
				ArenaNetPasswordPopup:show(function(arg_83_0)
					requestJoin(arg_81_0, arg_81_1, arg_83_0)
				end)
			elseif string.starts(var_82_0, "finish") or string.starts(var_82_0, "invalid_lounge_id") then
				if arg_81_0.renew then
					arg_81_0:renew()
				end
				
				ArenaNetPasswordPopup:close()
			elseif string.starts(var_82_0, "max_user") then
				if arg_81_0.itemRefresh then
					arg_81_0:itemRefresh(arg_81_1, "public")
				end
				
				ArenaNetPasswordPopup:close()
			else
				ArenaNetPasswordPopup:close()
			end
			
			joinLoungeErrorMsg(var_82_0)
			UIAction:Add(SEQ(DELAY(2000)), arg_81_0.vars.wnd or arg_81_0.vars.base_wnd, "join.block")
		end
	end)
end

function ArenaNetVSFriend.show(arg_84_0, arg_84_1)
	arg_84_0.vars = {}
	arg_84_0.vars.wnd = arg_84_1.vars.base_wnd:getChildByName("CENTER_2")
	arg_84_0.vars.tab = arg_84_1.vars.base_wnd:getChildByName("btn_tab_2")
	arg_84_0.vars.page_index = 0
	arg_84_0.vars.search_text = arg_84_0.vars.wnd:getChildByName("input_search")
	
	arg_84_0.vars.search_text:setMaxLength(8)
	arg_84_0:loadMockListView()
	arg_84_0:resetSorter()
	arg_84_0:updateSorterUI()
	
	arg_84_0.vars.categories = {
		ALL = {}
	}
	arg_84_0.vars.categories.ALL.tab = nil
	arg_84_0.vars.categories.ALL.query = "arena_net_lounge_list"
	
	arg_84_0.vars.wnd:setVisible(true)
	if_set_visible(arg_84_0.vars.tab, "bg", true)
	if_set_visible(arg_84_0.vars.wnd, "n_nodata", false)
	arg_84_0:setCategory("ALL")
	arg_84_0:closeSearch()
	LuaEventDispatcher:removeEventListenerByKey("arena_net_friend_event")
	LuaEventDispatcher:addEventListener("arena_net_friend", LISTENER(ArenaNetVSFriend.onEvent, arg_84_0), "arena_net_friend_event")
end

function ArenaNetVSFriend.unshow(arg_85_0)
	arg_85_0.vars.wnd:setVisible(false)
	
	if get_cocos_refid(arg_85_0.vars.filter) then
		arg_85_0.vars.filter:close()
	end
	
	if_set_visible(arg_85_0.vars.tab, "bg", false)
end

function ArenaNetVSFriend.itemRefresh(arg_86_0, arg_86_1, arg_86_2)
	local var_86_0 = table.find(arg_86_0.vars.item_list or {}, function(arg_87_0, arg_87_1)
		return arg_87_1.lounge_id == arg_86_1
	end)
	
	if var_86_0 then
		if arg_86_2 == "public" then
			arg_86_0.vars.item_list[var_86_0].is_public = 0
		elseif arg_86_2 == "max_user" then
			arg_86_0.vars.item_list[var_86_0].cur_count = arg_86_0.vars.item_list[var_86_0].max_count
		end
		
		arg_86_0.vars.itemView:refresh()
	end
end

function ArenaNetVSFriend.onEvent(arg_88_0, ...)
	local var_88_0 = ...
	
	if var_88_0.event == "create" then
		arg_88_0:createLounge()
	elseif var_88_0.event == "join" then
		arg_88_0:joinLounge(var_88_0.info)
	elseif var_88_0.event == "renew" then
		arg_88_0:resetSorter()
		arg_88_0:renew()
	elseif var_88_0.event == "search" then
		arg_88_0:search()
	elseif var_88_0.event == "open_filter" then
		arg_88_0:openFilter()
	elseif var_88_0.event == "open_search" then
		arg_88_0:openSearch()
	elseif var_88_0.event == "close_search" then
		arg_88_0:closeSearch()
	end
end

function ArenaNetVSFriend.createLounge(arg_89_0)
	local var_89_0, var_89_1 = checkCanStartMatch()
	
	if var_89_1 then
		Dialog:msgBox(T("arena_wa_notenough_4hero"))
		
		return 
	end
	
	ArenaNetCreatePopup:show({
		is_enable_chat = true,
		mode = "CREATE",
		is_public = true
	})
end

function ArenaNetVSFriend.joinLounge(arg_90_0, arg_90_1)
	if UIAction:Find("join.block") then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	local var_90_0, var_90_1 = checkCanStartMatch()
	
	if var_90_1 then
		Dialog:msgBox(T("arena_wa_notenough_4hero"))
		
		return 
	end
	
	if arg_90_1.is_public then
		requestJoin(arg_90_0, arg_90_1.lounge_id)
	else
		ArenaNetPasswordPopup:show(function(arg_91_0)
			requestJoin(arg_90_0, arg_90_1.lounge_id, arg_91_0)
		end)
	end
end

function ArenaNetVSFriend.makeLoungeListQueryInfo(arg_92_0, arg_92_1)
	local var_92_0 = {
		all = -1,
		public = 1,
		recent = 1,
		number = 0,
		down = 0,
		up = 1,
		private = 0
	}
	
	return {
		title = arg_92_1 or "",
		is_public = var_92_0[arg_92_0.vars.public],
		sort = var_92_0[arg_92_0.vars.sort],
		order = var_92_0[arg_92_0.vars.order],
		page_index = arg_92_0.vars.page_index,
		page_size = arg_92_0.PAGE_SIZE
	}
end

function ArenaNetVSFriend.updateSorterUI(arg_93_0)
	local function var_93_0(arg_94_0)
		if arg_94_0 == "all" then
			return T("pvp_rta_search_all")
		elseif arg_94_0 == "public" then
			return T("pvp_rta_search_public")
		elseif arg_94_0 == "private" then
			return T("pvp_rta_search_private")
		end
	end
	
	local var_93_1 = arg_93_0.vars.wnd:getChildByName("btn_sort")
	local var_93_2 = arg_93_0.vars.wnd:getChildByName("btn_sort_active")
	
	if_set(var_93_1, "t_number of people", var_93_0(arg_93_0.vars.public))
	if_set(var_93_2, "t_number of people", var_93_0(arg_93_0.vars.public))
	if_set_visible(var_93_1, nil, arg_93_0.vars.public == "all")
	if_set_visible(var_93_2, nil, arg_93_0.vars.public ~= "all")
end

function ArenaNetVSFriend.resetSorter(arg_95_0)
	arg_95_0.vars.public = "all"
	arg_95_0.vars.sort = "number"
	arg_95_0.vars.order = "down"
end

function ArenaNetVSFriend.renew(arg_96_0)
	if UIAction:Find("renew") then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	UIAction:Add(SEQ(DELAY(1000)), arg_96_0, "renew")
	
	arg_96_0.vars.item_list = nil
	arg_96_0.vars.page_index = 0
	
	local var_96_0 = arg_96_0:makeLoungeListQueryInfo()
	
	MatchService:query("arena_net_lounge_list", var_96_0, function(arg_97_0)
		if arg_97_0 and arg_97_0.lounge_list then
			arg_96_0:update(arg_97_0.lounge_list, arg_96_0.vars.public ~= "all")
		end
	end)
	arg_96_0:updateSorterUI()
end

function ArenaNetVSFriend.search(arg_98_0)
	local var_98_0 = arg_98_0.vars.search_text:getString()
	local var_98_1 = utf8len(var_98_0)
	local var_98_2 = string.trim(var_98_0)
	local var_98_3 = utf8len(var_98_2)
	
	if check_abuse_filter(var_98_2, ABUSE_FILTER.WORLD_NAME) then
		balloon_message_with_sound("pvp_rta_mock_bad_title")
		
		return 
	end
	
	if UIUtil:checkInvalidCharacter(var_98_2, false, {
		allow_jamo = true,
		allow_ascii = true
	}) then
		balloon_message_with_sound("pvp_rta_mock_bad_title")
		
		return 
	end
	
	if var_98_1 ~= var_98_3 then
		balloon_message_with_sound("pvp_rta_mock_bad_title")
		
		return 
	end
	
	if UIAction:Find("search.delay") then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	UIAction:Add(SEQ(DELAY(1000)), arg_98_0, "search.delay")
	
	arg_98_0.vars.item_list = nil
	arg_98_0.vars.page_index = 0
	
	local var_98_4 = arg_98_0:makeLoungeListQueryInfo(var_98_2)
	
	MatchService:query("arena_net_lounge_list", var_98_4, function(arg_99_0)
		if arg_99_0 and arg_99_0.lounge_list then
			arg_98_0:update(arg_99_0.lounge_list, true)
		end
	end)
end

function ArenaNetVSFriend.openSearch(arg_100_0)
	arg_100_0.vars.search_text:setString("")
	if_set_visible(arg_100_0.vars.wnd, "layer_search", true)
	if_set_visible(arg_100_0.vars.wnd, "btn_cancel_search", true)
end

function ArenaNetVSFriend.closeSearch(arg_101_0)
	if_set_visible(arg_101_0.vars.wnd, "layer_search", false)
	if_set_visible(arg_101_0.vars.wnd, "btn_cancel_search", false)
end

function ArenaNetVSFriend.openFilter(arg_102_0)
	if not get_cocos_refid(arg_102_0.vars.filter) then
		arg_102_0.vars.filter = ArenaNetRoomFilter:create()
		
		arg_102_0.vars.filter:init({
			public = arg_102_0.vars.public,
			sort = arg_102_0.vars.sort,
			order = arg_102_0.vars.order,
			change_callback = function(arg_103_0, arg_103_1, arg_103_2)
				Log.i("filter event callback", arg_103_0, arg_103_1, arg_103_2)
				
				arg_102_0.vars.public = arg_103_0
				arg_102_0.vars.sort = arg_103_1
				arg_102_0.vars.order = arg_103_2
				
				arg_102_0:renew()
			end
		})
		arg_102_0.vars.wnd:getChildByName("n_sorting_filter"):addChild(arg_102_0.vars.filter)
		arg_102_0.vars.wnd:getChildByName("n_sorting_filter"):setVisible(true)
	end
end

function ArenaNetVSFriend.nextPage(arg_104_0)
	arg_104_0.vars.page_index = arg_104_0.vars.page_index + 1
	
	local var_104_0 = arg_104_0:makeLoungeListQueryInfo()
	
	MatchService:query("arena_net_lounge_list", var_104_0, function(arg_105_0)
		if arg_105_0 and arg_105_0.lounge_list then
			arg_104_0:update(arg_105_0.lounge_list)
		end
	end)
end

function ArenaNetVSFriend.loadMockListView(arg_106_0)
	local var_106_0 = arg_106_0.vars.wnd:getChildByName("listview_mock")
	
	arg_106_0.vars.itemView = ItemListView_v2:bindControl(var_106_0)
	
	local var_106_1 = load_control("wnd/pvplive_mock_battle_item.csb")
	
	if var_106_0.STRETCH_INFO then
		local var_106_2 = var_106_0:getContentSize()
		
		resetControlPosAndSize(var_106_1, var_106_2.width, var_106_0.STRETCH_INFO.width_prev)
	end
	
	local var_106_3 = {
		onUpdate = function(arg_107_0, arg_107_1, arg_107_2, arg_107_3)
			ArenaNetVSFriend:updateItem(arg_107_1, arg_107_3)
			
			return arg_107_3.id
		end
	}
	
	arg_106_0.vars.itemView:setVisible(true)
	arg_106_0.vars.itemView:setRenderer(var_106_1, var_106_3)
	arg_106_0.vars.itemView:removeAllChildren()
	arg_106_0.vars.itemView:setDataSource({})
end

function ArenaNetVSFriend.setCategory(arg_108_0, arg_108_1)
	if not arg_108_0.vars.categories[arg_108_1] then
		Log.e("non category", arg_108_1)
		
		return 
	end
	
	if arg_108_0.vars.current == arg_108_1 then
		return 
	end
	
	arg_108_0.vars.current = arg_108_1
	
	arg_108_0.vars.itemView:setDataSource({})
	
	for iter_108_0, iter_108_1 in pairs(arg_108_0.vars.categories) do
		if iter_108_0 == arg_108_0.vars.current then
			MatchService:query(iter_108_1.query, {
				page_index = arg_108_0.vars.page_index,
				page_size = arg_108_0.PAGE_SIZE
			}, function(arg_109_0)
				if arg_109_0 and arg_109_0.lounge_list then
					arg_108_0:update(arg_109_0.lounge_list)
				end
			end)
		end
	end
end

function ArenaNetVSFriend.update(arg_110_0, arg_110_1, arg_110_2)
	local var_110_0 = false
	
	if not arg_110_0.vars.item_list then
		arg_110_0.vars.item_list = arg_110_1
	else
		arg_110_0:insert(arg_110_1)
		
		var_110_0 = true
	end
	
	if #arg_110_1 >= arg_110_0.PAGE_SIZE then
		table.insert(arg_110_0.vars.item_list, {
			next_item = true,
			next_page = true
		})
	elseif #arg_110_1 >= 1 then
		table.insert(arg_110_0.vars.item_list, {
			next_item = true,
			next_page = false
		})
	end
	
	arg_110_0.vars.itemView:setDataSource(arg_110_0.vars.item_list or {})
	
	if var_110_0 then
		arg_110_0.vars.itemView:jumpToBottom()
	else
		arg_110_0.vars.itemView:jumpToTop()
	end
	
	if arg_110_2 then
		if_set(arg_110_0.vars.wnd, "txt_nodata", T("pvp_rta_mock_no_results"))
	else
		if_set(arg_110_0.vars.wnd, "txt_nodata", T("pvp_rta_mock_noroom"))
	end
	
	if_set_visible(arg_110_0.vars.wnd, "n_nodata", table.empty(arg_110_0.vars.item_list or {}))
end

function ArenaNetVSFriend.insert(arg_111_0, arg_111_1)
	local var_111_0
	
	for iter_111_0, iter_111_1 in pairs(arg_111_0.vars.item_list) do
		if iter_111_1.next_item then
			var_111_0 = iter_111_0
		end
	end
	
	for iter_111_2, iter_111_3 in pairs(arg_111_1 or {}) do
		if not table.find(arg_111_0.vars.item_list or {}, function(arg_112_0, arg_112_1)
			return arg_112_1.lounge_id == iter_111_3.lounge_id
		end) then
			table.insert(arg_111_0.vars.item_list, iter_111_3)
		end
	end
	
	if var_111_0 then
		table.remove(arg_111_0.vars.item_list, var_111_0)
	end
end

function ArenaNetVSFriend.updateItem(arg_113_0, arg_113_1, arg_113_2)
	local var_113_0 = arg_113_2.is_public == 1
	local var_113_1 = (arg_113_2.win or 0) + (arg_113_2.draw or 0) + (arg_113_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	arg_113_1:getChildByName("btn_enter").info = {
		lounge_id = arg_113_2.lounge_id,
		is_public = var_113_0
	}
	arg_113_1:getChildByName("btn_more").parent = arg_113_0
	
	if arg_113_2.next_item then
		if_set_visible(arg_113_1, "btn_more", arg_113_2.next_page)
		if_set_visible(arg_113_1, "LEFT", false)
		if_set_visible(arg_113_1, "CENTER", false)
		if_set_visible(arg_113_1, "RIGHT", false)
		
		return 
	end
	
	if_set_visible(arg_113_1, "btn_more", false)
	if_set_visible(arg_113_1, "LEFT", true)
	if_set_visible(arg_113_1, "CENTER", true)
	if_set_visible(arg_113_1, "RIGHT", true)
	
	local var_113_2 = arg_113_1:getChildByName("txt_title")
	
	var_113_2:setString(check_abuse_filter(arg_113_2.title, ABUSE_FILTER.CHAT) or arg_113_2.title)
	UIUserData:call(var_113_2, "SINGLE_WSCALE(485)")
	if_set_visible(arg_113_1, "icon_locked", not var_113_0)
	if_set_text_color(arg_113_1, "txt_title", var_113_0 and cc.c3b(255, 255, 255) or cc.c3b(136, 136, 136))
	if_set(arg_113_1, "txt_nation", getRegionText(arg_113_2.world))
	
	local var_113_3 = arg_113_1:getChildByName("t_mod")
	
	var_113_3:setString(getArenaRuleName(arg_113_2.rule))
	UIUserData:call(var_113_3, "SINGLE_WSCALE(185)")
	
	local var_113_4, var_113_5 = UIUtil:getTextWidthAndPos(arg_113_1, "txt_title")
	
	arg_113_1:getChildByName("icon_locked"):setPositionX(var_113_5 + (var_113_4 + 18))
	
	local var_113_6 = arg_113_1:getChildByName("icon_etcgood")
	
	if var_113_0 and arg_113_2.cur_count >= 5 then
		var_113_6:setPositionX(var_113_5 + (var_113_4 + 18))
		var_113_6:setVisible(true)
		var_113_2:setTextColor(cc.c3b(100, 203, 0))
	else
		var_113_6:setVisible(false)
		var_113_2:setTextColor(cc.c3b(255, 255, 255))
	end
	
	UIUtil:getUserIcon(arg_113_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_113_1:getChildByName("mob_icon"),
		border_code = arg_113_2.border_code
	})
	
	if var_113_1 then
		SpriteCache:resetSprite(arg_113_1:getChildByName("icon_league"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		local var_113_7, var_113_8 = getArenaNetRankInfo(ArenaNetLobby:getSeasonId(), arg_113_2.league_id)
		
		SpriteCache:resetSprite(arg_113_1:getChildByName("icon_league"), "emblem/" .. var_113_8 .. ".png")
	end
	
	local var_113_9 = arg_113_1:getChildByName("txt_name")
	
	var_113_9:setString(check_abuse_filter(arg_113_2.name, ABUSE_FILTER.WORLD_NAME) or arg_113_2.name)
	UIUserData:call(var_113_9, "SINGLE_WSCALE(165)")
	
	local var_113_10 = arg_113_1:getChildByName("t_status")
	
	UIUserData:call(var_113_10, "SINGLE_WSCALE(156)")
	
	if arg_113_2.status == "READY" then
		var_113_10:setString(T("pvp_rta_mock_standby"))
		var_113_10:setTextColor(tocolor("#6bc11b"))
	elseif arg_113_2.status == "BANPICK" then
		var_113_10:setString(T("pvp_rta_mock_banpick"))
		var_113_10:setTextColor(tocolor("#6bc11b"))
	elseif arg_113_2.status == "BATTLE" then
		var_113_10:setString(T("pvp_rta_mock_battle"))
		var_113_10:setTextColor(tocolor("#ab8759"))
	end
	
	local var_113_11 = arg_113_2.cur_count or 0
	local var_113_12 = arg_113_2.max_count or 0
	
	if_set(arg_113_1, "t_member", tostring(var_113_11) .. "/" .. tostring(var_113_12))
end

function ArenaNetRanking.show(arg_114_0, arg_114_1)
	arg_114_0.vars = {}
	arg_114_0.vars.wnd = arg_114_1.vars.base_wnd:getChildByName("CENTER_5")
	
	arg_114_0.vars.wnd:setVisible(true)
	
	arg_114_0.vars.tab = arg_114_1.vars.base_wnd:getChildByName("btn_tab_5")
	
	if_set_visible(arg_114_0.vars.tab, "bg", true)
	
	arg_114_0.vars.my_rank_node = arg_114_0.vars.wnd:getChildByName("n_my_rank")
	
	arg_114_0:loadRankingListView()
	arg_114_0:loadRewardListView()
	LuaEventDispatcher:removeEventListenerByKey("arena_net_rank_event")
	LuaEventDispatcher:addEventListener("arena_net_rank", LISTENER(ArenaNetRanking.onEvent, arg_114_0), "arena_net_rank_event")
	
	arg_114_0.vars.categories = {
		LEAGUE = {},
		TOTAL = {},
		REWARD = {},
		EVENT = {}
	}
	arg_114_0.vars.categories.LEAGUE.tab = arg_114_0.vars.wnd:getChildByName("fg_ranking_category_season")
	arg_114_0.vars.categories.TOTAL.tab = arg_114_0.vars.wnd:getChildByName("fg_ranking_category_league")
	arg_114_0.vars.categories.REWARD.tab = arg_114_0.vars.wnd:getChildByName("fg_ranking_category_reward")
	arg_114_0.vars.categories.EVENT.tab = arg_114_0.vars.wnd:getChildByName("fg_ranking_category_event")
	arg_114_0.vars.categories.LEAGUE.query = "arena_net_league_rank"
	arg_114_0.vars.categories.TOTAL.query = "arena_net_season_rank"
	arg_114_0.vars.categories.EVENT.query = "arena_net_event_rank"
	
	if_set_visible(arg_114_0.vars.wnd, "n_nodata", false)
	if_set_visible(arg_114_0.vars.wnd, "ranking_category_event", ArenaNetLobby:isTimeOfEventMatch(true))
	arg_114_0:setCategory("TOTAL")
end

function ArenaNetRanking.unshow(arg_115_0)
	arg_115_0.vars.wnd:setVisible(false)
	if_set_visible(arg_115_0.vars.tab, "bg", false)
end

function ArenaNetRanking.onEvent(arg_116_0, ...)
	local var_116_0 = ...
	
	if var_116_0.event == "category" then
		arg_116_0:setCategory(var_116_0.name)
	end
end

function ArenaNetRanking.loadRankingListView(arg_117_0)
	local var_117_0 = arg_117_0.vars.wnd:getChildByName("listview_rank")
	
	arg_117_0.vars.itemView = ItemListView_v2:bindControl(var_117_0)
	
	local var_117_1 = load_control("wnd/pvplive_rank_bar.csb")
	
	if var_117_0.STRETCH_INFO then
		local var_117_2 = var_117_0:getContentSize()
		
		resetControlPosAndSize(var_117_1, var_117_2.width, var_117_0.STRETCH_INFO.width_prev)
	end
	
	local var_117_3 = {
		onUpdate = function(arg_118_0, arg_118_1, arg_118_2, arg_118_3)
			ArenaNetRanking:updateItem(arg_118_1, arg_118_3)
			
			return arg_118_3.id
		end
	}
	
	arg_117_0.vars.itemView:setRenderer(var_117_1, var_117_3)
	arg_117_0.vars.itemView:removeAllChildren()
	arg_117_0.vars.itemView:setDataSource({})
end

function ArenaNetRanking.loadRewardListView(arg_119_0)
	local var_119_0 = arg_119_0.vars.wnd:getChildByName("listview_reward")
	
	arg_119_0.vars.rewardView = ItemListView_v2:bindControl(var_119_0)
	
	local var_119_1 = load_control("wnd/pvplive_reward_bar.csb")
	
	if var_119_0.STRETCH_INFO then
		local var_119_2 = var_119_0:getContentSize()
		
		resetControlPosAndSize(var_119_1, var_119_2.width, var_119_0.STRETCH_INFO.width_prev)
	end
	
	local var_119_3 = {
		onUpdate = function(arg_120_0, arg_120_1, arg_120_2, arg_120_3)
			ArenaNetRanking:updateRewardItem(arg_120_1, arg_120_3)
			
			return arg_120_3.id
		end
	}
	
	local function var_119_4(arg_121_0, arg_121_1)
		local var_121_0 = {}
		
		for iter_121_0 = arg_121_1, arg_121_1 + 3 do
			local var_121_1 = {}
			local var_121_2 = tostring(iter_121_0)
			local var_121_3, var_121_4, var_121_5, var_121_6 = DBN("pvp_rta_reward", arg_121_0, {
				"season_reward_id" .. var_121_2,
				"season_reward_icon" .. var_121_2,
				"season_reward_name" .. var_121_2,
				"season_reward_count" .. var_121_2
			})
			
			if var_121_3 then
				var_121_1.id = var_121_3
				var_121_1.icon = var_121_4
				var_121_1.name = var_121_5
				var_121_1.count = var_121_6
				
				table.insert(var_121_0, var_121_1)
			end
		end
		
		return var_121_0
	end
	
	local var_119_5 = {}
	local var_119_6 = ArenaNetLobby:getSeasonInfo()
	
	for iter_119_0 = 1, 999 do
		local var_119_7, var_119_8, var_119_9 = DBN("pvp_rta_reward", iter_119_0, {
			"id",
			"season_id",
			"league_id"
		})
		
		if not var_119_7 then
			break
		end
		
		if var_119_8 == var_119_6.id and var_119_9 ~= "place" then
			local var_119_10, var_119_11 = getArenaNetRankInfo(ArenaNetLobby:getSeasonId(), var_119_9)
			local var_119_12 = {
				id = var_119_7,
				season_id = var_119_8,
				league_id = var_119_9,
				name = var_119_10,
				desc = "pvp_rta_desc2_" .. tostring(var_119_9),
				icon = var_119_11,
				rewards = var_119_4(iter_119_0, 1)
			}
			
			table.insert(var_119_5, var_119_12)
			
			local var_119_13 = var_119_4(iter_119_0, 5)
			
			if not table.empty(var_119_13) then
				local var_119_14 = table.clone(var_119_12)
				
				var_119_14.add_reward = true
				var_119_14.rewards = var_119_13
				
				table.insert(var_119_5, var_119_14)
			end
		end
	end
	
	arg_119_0.vars.rewardView:setRenderer(var_119_1, var_119_3)
	arg_119_0.vars.rewardView:removeAllChildren()
	arg_119_0.vars.rewardView:setDataSource(var_119_5)
end

function ArenaNetRanking.setCategory(arg_122_0, arg_122_1)
	if not arg_122_0.vars.categories[arg_122_1] then
		Log.e("non category", arg_122_1)
		
		return 
	end
	
	if arg_122_0.vars.current == arg_122_1 then
		return 
	end
	
	if os.time() - (arg_122_0.last_send_time or 0) < 1 then
		return 
	else
		arg_122_0.last_send_time = os.time()
	end
	
	arg_122_0.vars.current = arg_122_1
	
	arg_122_0.vars.itemView:setDataSource({})
	
	local var_122_0 = ArenaNetLobby:getUserInfo()
	local var_122_1 = (var_122_0.win or 0) + (var_122_0.draw or 0) + (var_122_0.lose or 0) < ARENA_MATCH_BATCH_COUNT
	local var_122_2 = T("")
	local var_122_3 = false
	local var_122_4 = arg_122_0.vars.wnd:getChildByName("txt_info")
	
	var_122_4:setString(T(""))
	if_set_visible(arg_122_0.vars.wnd, "btn_my_ranking", false)
	if_set_visible(arg_122_0.vars.wnd, "n_nodata", false)
	
	if arg_122_0.vars.current == "LEAGUE" then
		if var_122_1 then
			if_set_visible(arg_122_0.vars.wnd, "n_nodata", true)
			if_set(arg_122_0.vars.wnd, "txt_nodata", T("pvp_rta_batch_norank"))
		else
			var_122_4:setString(T("rta_rank_tab1_title"))
		end
	elseif arg_122_0.vars.current == "TOTAL" then
		var_122_4:setString(T("rta_rank_tab2_title"))
		if_set(arg_122_0.vars.wnd, "txt_nodata", T("pvp_rta_no_ranking_type1"))
	elseif arg_122_0.vars.current == "REWARD" then
		if_set_visible(arg_122_0.vars.wnd, "n_nodata", table.empty(arg_122_0.vars.rewardView:getDataSource()))
		if_set(arg_122_0.vars.wnd, "txt_nodata", T("pvp_rta_no_reward"))
	elseif arg_122_0.vars.current == "EVENT" then
		var_122_4:setString(T("rta_rank_tab3_title"))
		if_set(arg_122_0.vars.wnd, "txt_nodata", T("pvp_rta_no_ranking_type1"))
	end
	
	arg_122_0:updateMyRank()
	
	for iter_122_0, iter_122_1 in pairs(arg_122_0.vars.categories) do
		if iter_122_0 == arg_122_0.vars.current then
			iter_122_1.tab:setVisible(true)
			
			if iter_122_1.query then
				arg_122_0.vars.itemView:setVisible(true)
				arg_122_0.vars.rewardView:setVisible(false)
				MatchService:query(iter_122_1.query, {
					page_index = 0
				}, function(arg_123_0)
					arg_122_0:update(arg_123_0)
					
					arg_122_0.last_send_time = 0
				end)
			else
				arg_122_0.vars.itemView:setVisible(false)
				arg_122_0.vars.rewardView:setVisible(true)
				arg_122_0.vars.rewardView:jumpToTop()
			end
		else
			iter_122_1.tab:setVisible(false)
		end
	end
end

function ArenaNetRanking.updateMyRank(arg_124_0)
	arg_124_0.vars.my_rank_node:setVisible(arg_124_0.vars.current == "TOTAL" or arg_124_0.vars.current == "EVENT")
	
	local var_124_0 = arg_124_0.vars.current == "EVENT" and ArenaNetLobby:getEventUserInfo() or ArenaNetLobby:getUserInfo()
	local var_124_1 = arg_124_0.vars.current == "EVENT" and ArenaNetLobby:getEventSeasonId() or ArenaNetLobby:getSeasonId()
	local var_124_2 = var_124_0.season_rank
	local var_124_3 = var_124_0.score
	local var_124_4 = (var_124_0.win or 0) + (var_124_0.lose or 0) + (var_124_0.draw or 0)
	local var_124_5
	
	if (arg_124_0.vars.current ~= "EVENT" or false) and (var_124_0.win or 0) + (var_124_0.draw or 0) + (var_124_0.lose or 0) < ARENA_MATCH_BATCH_COUNT then
		if_set(arg_124_0.vars.my_rank_node, "t_rank_number", "-")
		if_set_visible(arg_124_0.vars.my_rank_node, "txt_score", false)
		if_set(arg_124_0.vars.my_rank_node, "t_rank_grade", T(ARENA_UNRANK_TEXT))
		if_set_opacity(arg_124_0.vars.my_rank_node, "t_rank_grade", 51)
		SpriteCache:resetSprite(arg_124_0.vars.my_rank_node:getChildByName("icon_league"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		if arg_124_0.vars.current == "EVENT" and var_124_4 == 0 then
			if_set(arg_124_0.vars.my_rank_node, "t_rank_number", "-")
			if_set(arg_124_0.vars.my_rank_node, "txt_score", T("pvp_point", {
				point = "-"
			}))
		else
			if_set(arg_124_0.vars.my_rank_node, "t_rank_number", "#" .. var_124_2)
			if_set(arg_124_0.vars.my_rank_node, "txt_score", T("pvp_point", {
				point = comma_value(var_124_3 or 0)
			}))
		end
		
		if_set_visible(arg_124_0.vars.my_rank_node, "txt_score", true)
		if_set_opacity(arg_124_0.vars.my_rank_node, "t_rank_grade", 255)
		UIUserData:call(arg_124_0.vars.my_rank_node, "SINGLE_WSCALE(120)")
		
		local var_124_6, var_124_7 = getArenaNetRankInfo(var_124_1, var_124_0.league_id)
		
		if_set(arg_124_0.vars.my_rank_node, "t_rank_grade", T(var_124_6))
		SpriteCache:resetSprite(arg_124_0.vars.my_rank_node:getChildByName("icon_league"), "emblem/" .. var_124_7 .. ".png")
	end
end

function ArenaNetRanking.nextPage(arg_125_0)
	UIAction:Add(SEQ(DELAY(2000)), arg_125_0.vars.wnd, "block")
	
	local var_125_0 = arg_125_0.vars.categories[arg_125_0.vars.current]
	
	MatchService:query(var_125_0.query, {
		page_index = arg_125_0.vars.page + 1
	}, function(arg_126_0)
		arg_125_0:update(arg_126_0)
	end)
end

function ArenaNetRanking.update(arg_127_0, arg_127_1)
	arg_127_1 = arg_127_1 or {}
	
	if arg_127_1.err then
		if_set_visible(arg_127_0.vars.wnd, "n_nodata", true)
		
		return 
	end
	
	local var_127_0 = arg_127_0.vars.itemView:getDataSource() or {}
	local var_127_1 = table.count(var_127_0)
	
	arg_127_0.vars.page = arg_127_1.page_index
	
	local var_127_2 = ArenaNetLobby:getUserInfo()
	local var_127_3 = (var_127_2.win or 0) + (var_127_2.draw or 0) + (var_127_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	local var_127_4
	
	if arg_127_0.vars.page == 0 or not arg_127_0.vars.item_list then
		arg_127_0.vars.item_list = arg_127_1.rank_list
	else
		arg_127_0:insert(arg_127_1.rank_list)
		
		var_127_4 = true
	end
	
	if #arg_127_1.rank_list >= 10 then
		table.insert(arg_127_0.vars.item_list, {
			next_item = true,
			next_page = true
		})
	elseif #arg_127_1.rank_list >= 1 then
		table.insert(arg_127_0.vars.item_list, {
			next_item = true,
			next_page = false
		})
	end
	
	if var_127_3 and arg_127_0.vars.current == "LEAGUE" then
		return 
	end
	
	if_set_visible(arg_127_0.vars.wnd, "n_nodata", table.empty(arg_127_0.vars.item_list or {}))
	arg_127_0.vars.itemView:setDataSource(arg_127_0.vars.item_list or {})
	
	if var_127_4 then
		arg_127_0.vars.itemView:forceDoLayout()
		arg_127_0.vars.itemView:jumpToIndex(var_127_1)
	end
end

function ArenaNetRanking.insert(arg_128_0, arg_128_1)
	local var_128_0
	
	for iter_128_0, iter_128_1 in pairs(arg_128_0.vars.item_list) do
		if iter_128_1.next_item then
			var_128_0 = iter_128_0
		end
	end
	
	for iter_128_2, iter_128_3 in pairs(arg_128_1 or {}) do
		table.insert(arg_128_0.vars.item_list, iter_128_3)
	end
	
	if var_128_0 then
		table.remove(arg_128_0.vars.item_list, var_128_0)
	end
end

function ArenaNetRanking.updateItem(arg_129_0, arg_129_1, arg_129_2)
	arg_129_1:getChildByName("btn_more").parent = arg_129_0
	
	if arg_129_2.next_item then
		if_set_visible(arg_129_1, "page_next", arg_129_2.next_page)
		if_set_visible(arg_129_1, "txt_rank", false)
		if_set_visible(arg_129_1, "txt_toprank", false)
		if_set_visible(arg_129_1, "txt_name", false)
		if_set_visible(arg_129_1, "txt_nation", false)
		if_set_visible(arg_129_1, "txt_rating", false)
		if_set_visible(arg_129_1, "icon_league", false)
		if_set_visible(arg_129_1, "icon_menu_global", false)
		if_set_visible(arg_129_1, "n_clan", false)
		if_set_visible(arg_129_1, "bar", false)
		
		return 
	end
	
	if_set_visible(arg_129_1, "icon_league", true)
	if_set_visible(arg_129_1, "page_next", false)
	
	local var_129_0 = arg_129_0.vars.current == "EVENT" and ArenaNetLobby:getEventSeasonId() or ArenaNetLobby:getSeasonId()
	local var_129_1, var_129_2 = getArenaNetRankInfo(var_129_0, arg_129_2.league_id)
	
	SpriteCache:resetSprite(arg_129_1:getChildByName("icon_league"), "emblem/" .. var_129_2 .. ".png")
	UIUtil:getUserIcon(arg_129_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_129_1:getChildByName("mob_icon"),
		border_code = arg_129_2.border_code
	})
	
	if arg_129_2.rank > 3 then
		if_set_visible(arg_129_1, "txt_rank", true)
		if_set_visible(arg_129_1, "txt_toprank", false)
		if_set(arg_129_1, "txt_rank", T("pvp_list_rank", {
			rank = arg_129_2.rank
		}))
	else
		if_set_visible(arg_129_1, "txt_rank", false)
		if_set_visible(arg_129_1, "txt_toprank", true)
		if_set(arg_129_1, "txt_toprank", T("pvp_list_rank", {
			rank = arg_129_2.rank
		}))
		
		if arg_129_0.vars.current == "LEAGUE" then
			if_set_visible(arg_129_1, "icon", true)
			if_set_visible(arg_129_1, "icon2", false)
		elseif arg_129_0.vars.current == "EVENT" then
			if_set_visible(arg_129_1, "icon", false)
			if_set_visible(arg_129_1, "icon2", true)
		elseif arg_129_0.vars.current == "TOTAL" then
			if_set_visible(arg_129_1, "icon", false)
			if_set_visible(arg_129_1, "icon2", true)
		end
	end
	
	if_set(arg_129_1, "txt_name", check_abuse_filter(arg_129_2.name, ABUSE_FILTER.WORLD_NAME) or arg_129_2.name)
	if_set(arg_129_1, "txt_nation", getRegionText(arg_129_2.world))
	if_set(arg_129_1, "txt_rating", T("pvp_point", {
		point = comma_value(arg_129_2.score)
	}))
	UIUserData:call(arg_129_1:getChildByName("txt_rating"), "SINGLE_WSCALE(120)")
	if_set_visible(arg_129_1, "n_clan", arg_129_2.clan_name)
	if_set(arg_129_1, "txt_clan", clanNameFilter(arg_129_2.clan_name))
	UIUtil:updateClanEmblem(arg_129_1:getChildByName("n_clan"), {
		emblem = arg_129_2.clan_emblem
	})
	if_set_visible(arg_129_1, "n_clan", string.len(arg_129_2.clan_name or "") > 0)
	
	local var_129_3 = string.len(arg_129_2.clan_name or "") > 0 and 0 or -12
	local var_129_4 = string.len(arg_129_2.clan_name or "") > 0 and 0 or 12
	
	if_set_add_position_y(arg_129_1, "txt_name", var_129_3)
	if_set_add_position_y(arg_129_1, "icon_menu_global", var_129_4)
	if_set_add_position_y(arg_129_1, "txt_nation", var_129_4)
end

function ArenaNetRanking.updateRewardItem(arg_130_0, arg_130_1, arg_130_2)
	if_set_visible(arg_130_1, "txt_name", not arg_130_2.add_reward)
	if_set_visible(arg_130_1, "txt_point", not arg_130_2.add_reward)
	if_set_visible(arg_130_1, "icon_league", not arg_130_2.add_reward)
	
	if not arg_130_2.add_reward then
		SpriteCache:resetSprite(arg_130_1:getChildByName("icon_league"), "emblem/" .. arg_130_2.icon .. ".png")
		if_set(arg_130_1, "txt_name", T(arg_130_2.name))
		if_set(arg_130_1, "txt_point", T(arg_130_2.desc))
	end
	
	local var_130_0 = 1
	
	for iter_130_0, iter_130_1 in pairs(arg_130_2.rewards) do
		if iter_130_1.id then
			local var_130_1 = arg_130_1:getChildByName("reward_item" .. tostring(var_130_0))
			
			if var_130_1 then
				local var_130_2 = DB("equip_item", iter_130_1.id, "type") == "artifact"
				local var_130_3 = DB("character", iter_130_1.id, "id") ~= nil
				
				var_130_1:removeAllChildren()
				UIUtil:getRewardIcon(iter_130_1.count, iter_130_1.id, {
					hero_multiply_scale = 1,
					artifact_multiply_scale = 0.7,
					tooltip_delay = 300,
					show_equip_count = true,
					scale = 1,
					popup_delay = 300,
					parent = var_130_1,
					no_popup = var_130_3 and iter_130_1.is_rewardable,
					grade_rate = iter_130_1.grade_rate,
					no_bg = string.starts(iter_130_1.id, "ma_bg"),
					no_grade = var_130_2
				})
				
				var_130_0 = var_130_0 + 1
			end
		end
	end
end

ArenaNetHall = {}
E7WC2021 = {}

function E7WC2021.setPageDetail(arg_131_0)
	if not arg_131_0.wc_banner or not get_cocos_refid(arg_131_0.wc_banner) or table.count(arg_131_0.wc_info) == 0 then
		return 
	end
	
	local var_131_0 = arg_131_0.wc_info
	local var_131_1 = arg_131_0.wc_banner
	local var_131_2 = var_131_1:getChildByName("t_title_01")
	local var_131_3 = var_131_1:getChildByName("t_title_02")
	local var_131_4 = getUserLanguage()
	
	if var_131_4 == "es" or var_131_4 == "fr" or var_131_4 == "pt" or var_131_4 == "th" then
		if_set(var_131_2, nil, T("e7wc_title_name2"))
		if_set(var_131_3, nil, T("e7wc_title_name1"))
	else
		if_set(var_131_2, nil, T("e7wc_title_name1"))
		if_set(var_131_3, nil, T("e7wc_title_name2"))
	end
	
	UIUtil:getUserIcon(var_131_0.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_131_1:getChildByName("n_face"),
		border_code = var_131_0.border_code
	})
	ArenaNetHall:updateChampionInfo(var_131_1, var_131_0)
end

E7WC2022 = {}

function E7WC2022.setPageDetail(arg_132_0)
	if not arg_132_0.wc_banner or not get_cocos_refid(arg_132_0.wc_banner) or table.count(arg_132_0.wc_info) == 0 then
		return 
	end
	
	local var_132_0 = arg_132_0.wc_info
	local var_132_1 = arg_132_0.wc_banner
	local var_132_2 = var_132_1:getChildByName("t_title_01")
	local var_132_3 = var_132_1:getChildByName("t_title_02")
	local var_132_4 = getUserLanguage()
	
	if var_132_4 == "es" or var_132_4 == "fr" or var_132_4 == "pt" or var_132_4 == "th" then
		if_set(var_132_2, nil, T("e7wc_title_name2"))
		if_set(var_132_3, nil, T("2022_e7wc_title_name"))
	else
		if_set(var_132_2, nil, T("2022_e7wc_title_name"))
		if_set(var_132_3, nil, T("e7wc_title_name2"))
	end
	
	ArenaNetHall:updateChampionInfo(var_132_1, var_132_0)
	
	local var_132_5 = var_132_0.ring_info
	
	if var_132_5 then
		ArenaNetHall:updateChampionRingUI(var_132_1, var_132_0.id, var_132_5)
	end
end

E7WC2023 = {}

function E7WC2023.setPageDetail(arg_133_0)
	if not arg_133_0.wc_banner or not get_cocos_refid(arg_133_0.wc_banner) or table.count(arg_133_0.wc_info) == 0 then
		return 
	end
	
	local var_133_0 = arg_133_0.wc_info
	local var_133_1 = arg_133_0.wc_banner
	local var_133_2 = var_133_1:getChildByName("t_title_01")
	local var_133_3 = var_133_1:getChildByName("t_title_02")
	local var_133_4 = getUserLanguage()
	
	if var_133_4 == "es" or var_133_4 == "fr" or var_133_4 == "pt" or var_133_4 == "th" then
		if_set(var_133_2, nil, T("e7wc_title_name2"))
		if_set(var_133_3, nil, T("2023_e7wc_title_name"))
	else
		if_set(var_133_2, nil, T("2023_e7wc_title_name"))
		if_set(var_133_3, nil, T("e7wc_title_name2"))
	end
	
	ArenaNetHall:updateChampionInfo(var_133_1, var_133_0)
	
	local var_133_5 = var_133_0.ring_info
	
	if var_133_5 then
		ArenaNetHall:updateChampionRingUI(var_133_1, var_133_0.id, var_133_5)
	end
end

function HANDLER.hall_of_fame_card_s(arg_134_0, arg_134_1)
	if arg_134_1 == "btn_more" then
		LuaEventDispatcher:dispatchEvent("arena_net_hall", {
			event = "page_next"
		})
	end
end

function ArenaNetHall.updateChampionInfo(arg_135_0, arg_135_1, arg_135_2)
	if not arg_135_1 or not get_cocos_refid(arg_135_1) or not arg_135_2 then
		return 
	end
	
	if_set(arg_135_1, "txt_name", check_abuse_filter(arg_135_2.user_name, ABUSE_FILTER.WORLD_NAME) or arg_135_2.user_name)
	if_set(arg_135_1, "txt_nation", getRegionText(arg_135_2.user_server))
	if_set(arg_135_1, "t_impression", T(arg_135_2.user_ment))
	if_set(arg_135_1, "txt_clan", clanNameFilter(arg_135_2.clan_name))
	UIUtil:updateClanEmblem(arg_135_1:getChildByName("n_clan"), {
		emblem = arg_135_2.clan_emblem
	})
	if_set_visible(arg_135_1, "n_clan", string.len(arg_135_2.clan_name or "") > 0)
	
	local var_135_0 = string.len(arg_135_2.clan_name or "") > 0 and -16 or 0
	local var_135_1 = string.len(arg_135_2.clan_name or "") > 0 and -22 or 0
	
	if_set_add_position_y(arg_135_1, "btn_video", var_135_0)
	if_set_add_position_y(arg_135_1, "txt_nation", var_135_1)
end

function ArenaNetHall.getE7WCInfoByIndex(arg_136_0, arg_136_1)
	if table.empty(arg_136_0.vars.wc_season_list) or not arg_136_1 then
		return 
	end
	
	return arg_136_0.vars.wc_season_list[arg_136_1]
end

function ArenaNetHall.getE7WCInfoByRing(arg_137_0, arg_137_1)
	if table.empty(arg_137_0.vars.wc_season_list) or not arg_137_1 then
		return 
	end
	
	for iter_137_0, iter_137_1 in pairs(arg_137_0.vars.wc_season_list) do
		local var_137_0 = iter_137_1.wc_info.ring_info
		
		if var_137_0 and var_137_0.equip_data.code == arg_137_1 then
			return iter_137_1
		end
	end
	
	return nil
end

function ArenaNetHall.getE7WCRewardInfos(arg_138_0)
	if table.empty(arg_138_0.vars.wc_season_list) then
		return 
	end
	
	local var_138_0 = {}
	
	for iter_138_0, iter_138_1 in pairs(arg_138_0.vars.wc_season_list) do
		local var_138_1 = iter_138_1.wc_info.ring_info
		
		if var_138_1 then
			table.insert(var_138_0, var_138_1)
		end
	end
	
	return var_138_0
end

function ArenaNetHall.updateChampionRingUI(arg_139_0, arg_139_1, arg_139_2, arg_139_3)
	if not arg_139_1 or not arg_139_2 or not arg_139_3 then
		return 
	end
	
	local var_139_0 = arg_139_1:getChildByName("n_reward")
	
	if var_139_0 then
		var_139_0:removeAllChildren()
		if_set(arg_139_1, "t_e7wc", T(arg_139_2 .. "_champ_ring_title"))
		
		if arg_139_3.expire_time then
			if_set(arg_139_1, "n_time", T("e7wc_champ_ring_expire_date", timeToStringDef({
				preceding_with_zeros = true,
				time = arg_139_3.expire_time
			})))
		end
		
		local var_139_1 = UIUtil:getRewardIcon(nil, arg_139_3.equip_data.code, {
			parent = var_139_0,
			set_fx = arg_139_3.equip_data.f,
			grade = arg_139_3.equip_data.g
		})
		
		if os.time() < arg_139_3.expire_time then
			if not arg_139_3.acquired then
				if not arg_139_0.vars.ui_itemset_eff_on then
					EffectManager:Play({
						fn = "ui_itemset_eff_on.cfx",
						layer = var_139_0
					})
					
					arg_139_0.vars.ui_itemset_eff_on = true
				end
				
				EffectManager:Play({
					loop = true,
					fn = "ui_itemset_eff_loop.cfx",
					layer = var_139_0
				})
			else
				if_set_color(var_139_0, var_139_1:getName(), cc.c3b(136, 136, 136))
				arg_139_1:getChildByName("img_check"):setVisible(true)
			end
		else
			if_set_color(var_139_0, var_139_1:getName(), cc.c3b(136, 136, 136))
			
			if arg_139_3.acquired then
				arg_139_1:getChildByName("img_check"):setVisible(true)
			end
		end
	end
end

function ArenaNetHall.selectChampionRing(arg_140_0, arg_140_1, arg_140_2)
	if not arg_140_1 or not arg_140_2 then
		return 
	end
	
	if not arg_140_2.ring_info.acquired then
		if os.time() > arg_140_2.ring_info.expire_time then
			balloon_message_with_sound("e7wc_cannot_have_ring")
			
			return 
		end
		
		query("e7wc_reward_get", {
			req_id = arg_140_2.id
		})
	else
		balloon_message_with_sound("e7wc_already_got_ring")
		
		return 
	end
end

function ArenaNetHall.show(arg_141_0, arg_141_1)
	arg_141_0.vars = {}
	arg_141_0.vars.wnd = arg_141_1.vars.base_wnd:getChildByName("CENTER_6")
	
	arg_141_0.vars.wnd:setVisible(true)
	
	arg_141_0.vars.tab = arg_141_1.vars.base_wnd:getChildByName("btn_tab_6")
	
	arg_141_0.vars.tab:setVisible(true)
	if_set_visible(arg_141_0.vars.wnd, "n_hall_of_fame_category", true)
	if_set_visible(arg_141_0.vars.tab, "bg", true)
	if_set_visible(arg_141_0.vars.wnd, "n_nodata", false)
	
	arg_141_0.vars.listview = arg_141_0.vars.wnd:getChildByName("listview_fame")
	
	arg_141_0.vars.listview:removeAllChildren()
	
	arg_141_0.vars.wc_banner_list = arg_141_0.vars.wnd:getChildByName("n_banner")
	
	arg_141_0.vars.wc_banner_list:setOpacity(255)
	
	arg_141_0.vars.wc_arrow = arg_141_0.vars.wnd:getChildByName("n_arrow")
	arg_141_0.vars.page_index = 0
	arg_141_0.vars.no_data = arg_141_0.vars.wnd:getChildByName("n_nodata")
	arg_141_0.vars.categories = {
		REGULAR = {},
		WORLD_CHAMPION = {}
	}
	arg_141_0.vars.categories.REGULAR.tab = arg_141_0.vars.wnd:getChildByName("fg_regularseason")
	arg_141_0.vars.categories.WORLD_CHAMPION.tab = arg_141_0.vars.wnd:getChildByName("fg_e7wc")
	
	if IS_PUBLISHER_ZLONG then
		if_set_visible(arg_141_0.vars.wnd, "n_e7wc", false)
	end
	
	LuaEventDispatcher:removeEventListenerByKey("arena_net_hall_event")
	LuaEventDispatcher:addEventListener("arena_net_hall", LISTENER(ArenaNetHall.onEvent, arg_141_0), "arena_net_hall_event")
	arg_141_0:setCategory("REGULAR")
end

function ArenaNetHall.setCategory(arg_142_0, arg_142_1)
	if not arg_142_0.vars.categories[arg_142_1] then
		Log.e("non category", arg_142_1)
		
		return 
	end
	
	if arg_142_0.vars.current == arg_142_1 then
		return 
	end
	
	if os.time() - (arg_142_0.last_send_time or 0) < 1 then
		return 
	else
		arg_142_0.last_send_time = os.time()
	end
	
	if arg_142_0.vars.ui_itemset_eff_on then
		arg_142_0.vars.ui_itemset_eff_on = false
	end
	
	arg_142_0.vars.current = arg_142_1
	arg_142_0.vars.page_index = 0
	
	for iter_142_0, iter_142_1 in pairs(arg_142_0.vars.categories) do
		if iter_142_0 == arg_142_0.vars.current then
			iter_142_1.tab:setVisible(true)
			arg_142_0.vars.listview:jumpToTop()
			
			if iter_142_0 == "REGULAR" then
				MatchService:query("arena_net_hall_of_fame", {
					page_index = arg_142_0.vars.page_index
				}, function(arg_143_0)
					arg_142_0:updateRegularSeason(arg_143_0)
					
					arg_142_0.last_send_time = 0
					
					ConditionContentsManager:dispatch("pvprta.fame", {
						seasons = arg_143_0.hall_of_fame
					})
				end)
			elseif iter_142_0 == "WORLD_CHAMPION" then
				MatchService:query("arena_net_e7wc_fame", nil, function(arg_144_0)
					arg_142_0:updateWorldChampion(arg_144_0)
					
					arg_142_0.last_send_time = 0
				end)
			else
				Log.e("invalid hall category")
			end
		else
			iter_142_1.tab:setVisible(false)
		end
	end
end

function ArenaNetHall.nextPage(arg_145_0)
	if os.time() - (arg_145_0.last_send_time or 0) < 1 then
		return 
	else
		arg_145_0.last_send_time = os.time()
	end
	
	MatchService:query("arena_net_hall_of_fame", {
		page_index = arg_145_0.vars.page_index + 1
	}, function(arg_146_0)
		for iter_146_0, iter_146_1 in pairs(arg_146_0.hall_of_fame or {}) do
			iter_146_1.season_name = iter_146_0
			
			table.insert(arg_145_0.vars.season_infos, iter_146_1)
		end
		
		arg_145_0:updateRegularSeason({
			hall_of_fame = arg_145_0.vars.season_infos,
			no_more_data = table.empty(arg_146_0.hall_of_fame)
		})
		
		if not table.empty(arg_146_0.hall_of_fame) then
			arg_145_0.vars.page_index = arg_145_0.vars.page_index + 1
		end
		
		arg_145_0.last_send_time = 0
		
		arg_145_0.vars.listview:jumpToBottom()
		ConditionContentsManager:dispatch("pvprta.fame", {
			seasons = arg_146_0.hall_of_fame
		})
	end)
end

function ArenaNetHall.setCharPort(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
	local var_147_0 = ur.ModelStage:create(CACHE:getModel(arg_147_2.db))
	
	var_147_0:setScaleX(-1)
	
	if var_147_0.model.setAnimation then
		UIAction:Add(SEQ(DELAY(math.random(0, 100)), CALL(function()
			var_147_0.model:setNoSoundAniFlag("b_idle_ready", arg_147_3)
		end), MOTION("idle", true), CALL(function()
			var_147_0.model:setNoSoundAniFlag("idle", false)
		end)), var_147_0.model, "block")
	end
	
	arg_147_1:addChild(var_147_0)
end

function ArenaNetHall.onEvent(arg_150_0, ...)
	local var_150_0 = ...
	
	if var_150_0.event == "REGULAR" then
		arg_150_0:setCategory(var_150_0.event)
	elseif var_150_0.event == "WORLD_CHAMPION" then
		arg_150_0:setCategory(var_150_0.event)
	elseif var_150_0.event == "page_next" then
		arg_150_0:nextPage()
	else
		arg_150_0:openVideo()
	end
end

function ArenaNetHall.updateRegularSeason(arg_151_0, arg_151_1)
	arg_151_0.vars.listview:setVisible(true)
	arg_151_0.vars.wc_banner_list:setVisible(false)
	arg_151_0.vars.wc_arrow:setVisible(false)
	arg_151_0.vars.no_data:setVisible(false)
	
	if not arg_151_1 or not arg_151_1.hall_of_fame or table.count(arg_151_1.hall_of_fame) == 0 then
		arg_151_0.vars.no_data:setVisible(true)
		
		return 
	end
	
	local var_151_0 = {}
	
	for iter_151_0, iter_151_1 in pairs(arg_151_1.hall_of_fame or {}) do
		iter_151_1.season_name = iter_151_0
		
		table.insert(var_151_0, iter_151_1)
	end
	
	arg_151_0.vars.season_infos = table.clone(var_151_0)
	
	table.sort(var_151_0, function(arg_152_0, arg_152_1)
		return arg_152_0.seqnum > arg_152_1.seqnum
	end)
	
	if arg_151_1.no_more_data then
		table.insert(var_151_0, {
			next_item = false,
			next_page = false
		})
	elseif table.count(arg_151_1.hall_of_fame) >= 10 then
		table.insert(var_151_0, {
			next_item = true,
			next_page = true
		})
	elseif table.count(arg_151_1.hall_of_fame) >= 1 then
		table.insert(var_151_0, {
			next_item = true,
			next_page = false
		})
	end
	
	arg_151_0.vars.listview:removeAllChildren()
	
	for iter_151_2, iter_151_3 in pairs(var_151_0) do
		if iter_151_3.next_item == false and iter_151_3.next_page == false then
		elseif iter_151_3.next_item then
			local var_151_1 = load_dlg("hall_of_fame_card_s", true, "wnd")
			
			if_set_visible(var_151_1, "LEFT", false)
			if_set_visible(var_151_1, "RIGHT", false)
			if_set_visible(var_151_1, "page_next", true)
			
			if arg_151_0.vars.listview.STRETCH_INFO then
				local var_151_2 = arg_151_0.vars.listview:getContentSize()
				
				resetControlPosAndSize(var_151_1:findChildByName("bar_"), var_151_2.width, arg_151_0.vars.listview.STRETCH_INFO.width_prev)
				resetControlPosAndSize(var_151_1, var_151_2.width, arg_151_0.vars.listview.STRETCH_INFO.width_prev)
			end
			
			arg_151_0.vars.listview:addChild(var_151_1)
		else
			local var_151_3 = iter_151_2 == 1
			local var_151_4 = var_151_3 and "hall_of_fame_card_l" or "hall_of_fame_card_s"
			local var_151_5 = load_dlg(var_151_4, true, "wnd")
			
			arg_151_0.vars.listview:addChild(var_151_5)
			
			local var_151_6
			
			if UIUtil:isChangeSeasonLabelPosition() then
				var_151_6 = var_151_5:getChildByName("n_season_2/2")
				
				var_151_6:setVisible(true)
				if_set_visible(var_151_5, "n_season_1/2", false)
			else
				var_151_6 = var_151_5:getChildByName("n_season_1/2")
				
				var_151_6:setVisible(true)
				if_set_visible(var_151_5, "n_season_2/2", false)
			end
			
			local var_151_7 = DB("pvp_rta_season", iter_151_3.season_name, {
				"season_name"
			})
			
			if_set(var_151_6, "txt_season_number", T(iter_151_3.season_name_abb))
			if_set(var_151_5, "txt_season_period", T("season_period", timeToStringDef({
				preceding_with_zeros = true,
				start_time = iter_151_3.start_date,
				end_time = iter_151_3.end_date
			})))
			
			local var_151_8 = var_151_5:getChildByName("n_season_honor")
			
			if var_151_4 == "hall_of_fame_card_s" then
				var_151_8:setPositionY(14)
			end
			
			for iter_151_4 = 1, 3 do
				local var_151_9 = iter_151_3.users[iter_151_4]
				local var_151_10 = var_151_5:getChildByName("n_" .. iter_151_4) or var_151_5:getChildByName("n_info" .. iter_151_4)
				
				if var_151_9 then
					var_151_10:setVisible(true)
					
					if var_151_3 then
						local var_151_11 = var_151_5:getChildByName("n_pos" .. iter_151_4 .. "_character")
						local var_151_12 = UNIT:create({
							code = var_151_9.leader_code
						})
						
						arg_151_0:setCharPort(var_151_11, var_151_12, iter_151_4 ~= 1)
					end
					
					if_set(var_151_10, "txt_user_name", check_abuse_filter(var_151_9.user_name, ABUSE_FILTER.WORLD_NAME) or var_151_9.user_name)
					
					local var_151_13 = var_151_9.border_code
					local var_151_14 = UNIT:create({
						code = var_151_9.leader_code
					})
					
					UIUtil:getUserIcon(var_151_14, {
						no_popup = true,
						no_lv = true,
						no_role = true,
						no_grade = true,
						parent = var_151_10:getChildByName("mob_icon_" .. iter_151_4),
						border_code = var_151_13
					})
					if_set_visible(var_151_10, "txt_clan_name", false)
					if_set_visible(var_151_10, "txt_nation", true)
					if_set(var_151_10, "txt_nation", getRegionText(var_151_9.user_world))
					
					if var_151_4 == "hall_of_fame_card_l" then
						var_151_10:setPositionY(133)
					end
					
					if_set(var_151_10, "txt_clan_name", clanNameFilter(var_151_9.clan_name))
					UIUtil:updateClanEmblem(var_151_10:getChildByName("n_emblem"), {
						emblem = var_151_9.clan_emblem
					})
					if_set_visible(var_151_10, "n_emblem", string.len(var_151_9.clan_name or "") > 0)
					
					local var_151_15 = string.len(var_151_9.clan_name or "") > 0 and 0 or 23
					
					if_set_add_position_y(var_151_10, "txt_nation", var_151_15)
					
					local var_151_16 = 0.75 / var_151_10:getChildByName("txt_clan_name"):getScaleX()
					
					var_151_10:getChildByName("n_emblem"):setScaleX(0.15 * var_151_16)
				else
					var_151_10:setVisible(false)
				end
			end
			
			PvpSAHOF:setPosRankNode(var_151_5)
			
			if arg_151_0.vars.listview.STRETCH_INFO then
				local var_151_17 = arg_151_0.vars.listview:getContentSize()
				
				resetControlPosAndSize(var_151_5:findChildByName("bar_"), var_151_17.width, arg_151_0.vars.listview.STRETCH_INFO.width_prev)
			end
		end
	end
	
	arg_151_0.vars.listview:setInnerContainerSize({
		width = 727,
		height = 473 + (table.count(var_151_0) - 1) * 228 + 90
	})
end

function ArenaNetHall.updateWorldChampion(arg_153_0, arg_153_1)
	arg_153_1 = arg_153_1 or {}
	
	arg_153_0.vars.listview:setVisible(false)
	arg_153_0.vars.wc_banner_list:setVisible(true)
	arg_153_0.vars.wc_arrow:setVisible(true)
	arg_153_0.vars.no_data:setVisible(false)
	
	if arg_153_1.err then
		arg_153_0.vars.wc_banner_list:setVisible(false)
		arg_153_0.vars.wc_arrow:setVisible(false)
		arg_153_0.vars.no_data:setVisible(true)
		
		return 
	end
	
	if not arg_153_0.vars.wc_season_list then
		arg_153_0.vars.wc_season_list = {
			E7WC2021,
			E7WC2022,
			E7WC2023
		}
		
		for iter_153_0, iter_153_1 in pairs(arg_153_1.e7wc_fame or {}) do
			local var_153_0 = {
				id = iter_153_1.id,
				user_name = iter_153_1.user_name,
				user_server = iter_153_1.user_server,
				leader_code = iter_153_1.leader_code,
				border_code = iter_153_1.border_code,
				user_ment = iter_153_1.user_ment,
				clan_name = iter_153_1.clan_name,
				clan_emblem = iter_153_1.clan_emblem_id
			}
			local var_153_1 = "url_" .. (getUserLanguage() or "")
			
			if iter_153_1[var_153_1] and string.len(iter_153_1[var_153_1]) > 0 then
				var_153_0.url = iter_153_1[var_153_1]
			else
				var_153_0.url = iter_153_1.url_default
			end
			
			local var_153_2 = arg_153_0.vars.wc_season_list[iter_153_1.sequence]
			
			if var_153_2 then
				var_153_2.wc_info = var_153_0
			end
			
			local var_153_3 = DB("pvp_rta_fame", var_153_0.id, {
				"csd_name"
			})
			
			var_153_2.wc_banner = arg_153_0:createBanner(var_153_3)
		end
	end
	
	if not IS_PUBLISHER_ZLONG then
		query("e7wc_reward_list")
	end
end

function ArenaNetHall.updateChampionRing(arg_154_0, arg_154_1)
	if table.empty(arg_154_0.vars.wc_season_list) or not arg_154_1.reward_list then
		return 
	end
	
	for iter_154_0, iter_154_1 in pairs(arg_154_1.reward_list) do
		for iter_154_2, iter_154_3 in pairs(arg_154_0.vars.wc_season_list or {}) do
			if iter_154_3.wc_info.id == iter_154_0 then
				iter_154_3.wc_info.ring_info = {
					equip_data = iter_154_1.reward_equip_data,
					expire_time = iter_154_1.expire_time,
					acquired = iter_154_1.acquired
				}
				
				break
			end
		end
	end
end

function ArenaNetHall.initPage(arg_155_0)
	if table.empty(arg_155_0.vars.wc_season_list) then
		return 
	end
	
	arg_155_0.vars.cur_page = 0
	arg_155_0.vars.max_page = table.count(arg_155_0.vars.wc_season_list)
	
	arg_155_0:setPage(arg_155_0.vars.max_page)
	
	if arg_155_0.vars.cur_page > 1 then
		arg_155_0:setActiveArrow("Left")
	end
end

function ArenaNetHall.createBanner(arg_156_0, arg_156_1)
	if not arg_156_1 then
		return 
	end
	
	local var_156_0 = load_control("wnd/pvplive_" .. arg_156_1 .. ".csb")
	
	if not get_cocos_refid(var_156_0) then
		return 
	end
	
	var_156_0:setVisible(false)
	var_156_0:setPosition(0, 0)
	if_set_visible(var_156_0, "btn_video", IS_PUBLISHER_STOVE)
	arg_156_0.vars.wc_banner_list:addChild(var_156_0)
	
	return var_156_0
end

function ArenaNetHall.movePage(arg_157_0, arg_157_1)
	if arg_157_1 and type(arg_157_1) == "number" and arg_157_0.vars.max_page > 1 then
		local var_157_0 = arg_157_0.vars.max_page
		local var_157_1 = arg_157_0.vars.cur_page + arg_157_1
		
		if var_157_0 <= var_157_1 then
			arg_157_0:setActiveArrow("Left")
			
			var_157_1 = var_157_0
		elseif var_157_1 <= 1 then
			arg_157_0:setActiveArrow("Right")
			
			var_157_1 = 1
		else
			arg_157_0:setActiveArrow("Both")
		end
		
		arg_157_0:setPage(var_157_1)
	end
end

function ArenaNetHall.setActiveArrow(arg_158_0, arg_158_1)
	if not arg_158_1 then
		return 
	end
	
	local var_158_0 = arg_158_0.vars.wc_arrow:getChildByName("btn_l_arrow")
	local var_158_1 = arg_158_0.vars.wc_arrow:getChildByName("btn_r_arrow")
	
	if var_158_0 and var_158_1 then
		if arg_158_1 == "Left" then
			var_158_0:setOpacity(255)
			var_158_1:setOpacity(76.5)
		elseif arg_158_1 == "Right" then
			var_158_0:setOpacity(76.5)
			var_158_1:setOpacity(255)
		elseif arg_158_1 == "Both" then
			var_158_0:setOpacity(255)
			var_158_1:setOpacity(255)
		end
	end
end

function ArenaNetHall.setPage(arg_159_0, arg_159_1)
	if table.empty(arg_159_0.vars.wc_season_list) or arg_159_0.vars.cur_page == arg_159_1 then
		return 
	end
	
	local var_159_0 = arg_159_0.vars.cur_page
	
	arg_159_0.vars.cur_page = arg_159_1
	
	local var_159_1 = arg_159_0.vars.wc_season_list
	
	if var_159_0 ~= 0 then
		var_159_1[var_159_0].wc_banner:setVisible(false)
	end
	
	var_159_1[arg_159_0.vars.cur_page].wc_banner:setVisible(true)
	arg_159_0:setPageDetail(arg_159_0.vars.cur_page)
end

function ArenaNetHall.setPageDetail(arg_160_0, arg_160_1)
	if not arg_160_0.vars.wc_season_list[arg_160_1] then
		return 
	end
	
	local var_160_0 = arg_160_0.vars.wc_season_list[arg_160_1]
	
	arg_160_0.vars.page_url = var_160_0.wc_info.url
	
	if arg_160_0.vars.ui_itemset_eff_on then
		arg_160_0.vars.ui_itemset_eff_on = false
	end
	
	var_160_0:setPageDetail()
	resetControlPosAndSize(var_160_0.wc_banner, VIEW_WIDTH, DESIGN_WIDTH, true)
end

function ArenaNetHall.openVideo(arg_161_0)
	Stove:openWorldChampionInterview(arg_161_0.vars.page_url)
end

function ArenaNetHall.unshow(arg_162_0)
	if arg_162_0.vars.current == "WORLD_CHAMPION" and table.count(arg_162_0.vars.wc_season_list) ~= 0 then
		for iter_162_0, iter_162_1 in pairs(arg_162_0.vars.wc_season_list) do
			iter_162_1.wc_banner:removeFromParent()
		end
	end
	
	arg_162_0.vars.wnd:setVisible(false)
	if_set_visible(arg_162_0.vars.tab, "bg", false)
end

ArenaNetVSEvent = {}

function ArenaNetVSEvent.show(arg_163_0, arg_163_1)
	arg_163_0.vars = {}
	arg_163_0.vars.wnd = arg_163_1.vars.base_wnd:getChildByName("CENTER_8")
	
	arg_163_0.vars.wnd:setVisible(true)
	
	arg_163_0.vars.bg = arg_163_1.vars.base_wnd:getChildByName("bg_main")
	
	arg_163_0.vars.bg:setVisible(true)
	
	arg_163_0.vars.tab = arg_163_1.vars.base_wnd:getChildByName("btn_tab_8")
	
	if_set_visible(arg_163_0.vars.tab, "bg", true)
	arg_163_0:updateInfo()
	
	arg_163_0.vars.eff = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_pvplive_base.cfx",
		pivot_y = 0,
		pivot_z = 99998,
		layer = arg_163_0.vars.wnd:getChildByName("n_eff")
	})
	
	if ArenaNetLobby:isTimeOfEventMatch() then
		arg_163_0:matchBtnState("NORMAL")
	else
		arg_163_0:matchBtnState("NOT_MATCH_TIME")
	end
end

function ArenaNetVSEvent.unshow(arg_164_0)
	arg_164_0.vars.wnd:setVisible(false)
	arg_164_0.vars.bg:setVisible(false)
	if_set_visible(arg_164_0.vars.tab, "bg", false)
	arg_164_0.vars.eff:removeFromParent()
	
	arg_164_0.vars.eff = nil
end

function ArenaNetVSEvent.updateInfo(arg_165_0)
	local var_165_0 = ArenaNetLobby:getEventSeasonInfo()
	local var_165_1, var_165_2 = DB("pvp_rta_season_event", var_165_0.id, {
		"mode_role_desc",
		"mode_desc"
	})
	local var_165_3 = arg_165_0.vars.wnd:getChildByName("n_season")
	local var_165_4 = arg_165_0.vars.wnd:getChildByName("n_info_event")
	local var_165_5 = arg_165_0.vars.wnd:getChildByName("n_info_battle")
	
	if_set(var_165_4, "label", T(var_165_2))
	if_set(var_165_5, "label", T(var_165_1))
	if_set(var_165_3, "txt_event_remaining", T("pvp_rta_event_period", timeToStringDef({
		preceding_with_zeros = true,
		start_time = var_165_0.start_time,
		end_time = var_165_0.end_time
	})))
	
	if ArenaNetLobby:isTimeOfEventMatch() then
		if_set(var_165_3, "txt_left_time", T("arena_wa_global_ban_time", {
			time = sec_to_string(var_165_0.end_time - os.time())
		}))
	else
		if_set(var_165_3, "txt_left_time", T("pvp_rta_event_end_time"))
	end
end

function ArenaNetVSEvent.matchBtnState(arg_166_0, arg_166_1)
	if not arg_166_0.vars then
		return 
	end
	
	if not arg_166_0.vars.wnd or not get_cocos_refid(arg_166_0.vars.wnd) then
		return 
	end
	
	local var_166_0 = arg_166_0.vars.wnd:getChildByName("btn_event_cancel"):getChildByName("icon")
	
	if_set_visible(arg_166_0.vars.wnd, "n_watching", false)
	
	if arg_166_1 == "NORMAL" then
		if_set_visible(arg_166_0.vars.wnd, "btn_event_go", true)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel", false)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel_msg", false)
		if_set_color(arg_166_0.vars.wnd, "btn_event_go", tocolor("#ffffff"))
		
		local var_166_1 = var_166_0:getRotationSkewX() < -180 and -360 or -180
		
		UIAction:Remove("match.auto")
		var_166_0:setRotation(var_166_1)
	elseif arg_166_1 == "CANCEL" then
		if_set_visible(arg_166_0.vars.wnd, "btn_event_go", false)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel", true)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel_msg", false)
		if_set_color(arg_166_0.vars.wnd, "btn_event_go", tocolor("#ffffff"))
		
		local var_166_2 = 0
		
		UIAction:Remove("match.auto")
		UIAction:Add(LOOP(ROTATE(2000, var_166_2, var_166_2 - 360)), var_166_0, "match.auto")
	elseif arg_166_1 == "CANCELING" then
		if_set_visible(arg_166_0.vars.wnd, "btn_event_go", false)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel", false)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel_msg", true)
		if_set_color(arg_166_0.vars.wnd, "btn_go", tocolor("#ffffff"))
	elseif arg_166_1 == "NOT_MATCH_TIME" then
		if_set_visible(arg_166_0.vars.wnd, "btn_event_go", true)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel", false)
		if_set_visible(arg_166_0.vars.wnd, "btn_event_cancel_msg", false)
		if_set_color(arg_166_0.vars.wnd, "btn_event_go", tocolor("#7f7f7f"))
		
		local var_166_3 = var_166_0:getRotationSkewX() < -180 and -360 or -180
		
		UIAction:Remove("match.auto")
		var_166_0:setRotation(var_166_3)
	end
end

function ArenaNetVSEvent.startWatch(arg_167_0)
	arg_167_0.scheduler = Scheduler:addGlobalInterval(ARENA_MATCH_INTERVAL, arg_167_0.update, arg_167_0)
	
	arg_167_0.scheduler:setName(ARENA_MATCH_SCHEDULER)
end

function ArenaNetVSEvent.update(arg_168_0)
	arg_168_0:watch()
	arg_168_0:updateTime()
end

function ArenaNetVSEvent.watch(arg_169_0)
	MatchService:query("arena_net_polling_match_for_event", nil, function(arg_170_0)
		if arg_170_0.match_info and arg_170_0.match_info.match_success == 1 then
			UIAction:Remove("match.canceling")
			Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
			ArenaService:init(arg_170_0.match_info, {
				init_state = "TRANS"
			})
		elseif arg_170_0.match_info and arg_170_0.match_info.keep_matching == 0 then
			Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
			ArenaNetLobby:setLock(false)
			arg_169_0:matchBtnState("NORMAL")
			
			if arg_170_0.match_info.err_code then
				if string.starts(arg_170_0.match_info.err_code, "no_arena") then
					Dialog:msgBox(T("server_busy_msg"))
				elseif string.starts(arg_170_0.match_info.err_code, "limit_match_try_max") then
					Dialog:msgBox(T("arena_wa_cancle_match"))
				elseif string.starts(arg_170_0.match_info.err_code, "week_schedule_off") then
					arg_169_0:matchBtnState("NOT_MATCH_TIME")
					Dialog:msgBox(T("pvp_rta_not_playtime"))
				end
			end
		end
	end)
end

function ArenaNetVSEvent.updateTime(arg_171_0)
	local var_171_0 = arg_171_0.vars.wnd:getChildByName("btn_event_cancel")
	local var_171_1 = arg_171_0.vars.start_time and os.time() - arg_171_0.vars.start_time or 0
	local var_171_2 = math.floor(var_171_1 / 60)
	local var_171_3 = string.format("%02d:%02d", var_171_2 % 60, var_171_1 % 60)
	
	if_set(var_171_0, "t_time", var_171_3)
end

function ArenaNetVSEvent.startEventMatch(arg_172_0)
	if ContentDisable:byAlias("world_arena") or ContentDisable:byAlias("world_arena_match_rank") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if ArenaNetLobby:isLock() then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	if not ArenaNetLobby:isTimeOfEventMatch() then
		balloon_message_with_sound("msg_rta_eventrank_notime")
		
		return 
	end
	
	local var_172_0, var_172_1 = checkCanStartMatch()
	
	if var_172_1 then
		Dialog:msgBox(T("arena_wa_notenough_4hero"))
		
		return 
	end
	
	ArenaNetLobby:setLock(true)
	UIAction:Add(SEQ(DELAY(1500)), arg_172_0, "block")
	MatchService:query("arena_net_register_match_for_event", nil, function(arg_173_0)
		if arg_173_0.match_register_info.result == 1 then
			arg_172_0.vars.start_time = os.time()
			
			arg_172_0:startWatch()
			arg_172_0:updateTime()
			arg_172_0:matchBtnState("CANCEL")
			ArenaNetLobby:setSchedule(arg_173_0.match_register_info.week_schedule, arg_173_0.match_register_info.server_week_of_day)
			LuaEventDispatcher:dispatchEvent("invite.event", "hide")
		else
			Log.i("register match fail", table.print(arg_173_0.match_register_info))
			ArenaNetLobby:setLock(false)
			ArenaNetLobby:setSchedule(arg_173_0.match_register_info.week_schedule, arg_173_0.match_register_info.server_week_of_day)
			arg_172_0:matchBtnState("NORMAL")
			
			if arg_173_0.match_register_info.err_msg then
				if string.starts(arg_173_0.match_register_info.err_msg, "no_arena") then
					Dialog:msgBox(T("server_busy_msg"))
				elseif string.starts(arg_173_0.match_register_info.err_msg, "already_playing") then
					balloon_message_with_sound("error_try_again")
				elseif string.starts(arg_173_0.match_register_info.err_msg, "already_lounge") then
					balloon_message_with_sound("pvp_rta_mock_already_in")
				elseif string.starts(arg_173_0.match_register_info.err_msg, "week_schedule_off") then
					arg_172_0:matchBtnState("NOT_MATCH_TIME")
					Dialog:msgBox(T("pvp_rta_not_playtime"))
				elseif string.starts(arg_173_0.match_register_info.err_msg, "content_disable") then
					Dialog:msgBox(T("content_disable"))
				else
					balloon_message_with_sound("error_try_again")
				end
			end
		end
	end)
end

function ArenaNetVSEvent.cancelEventMatch(arg_174_0)
	if not ArenaNetLobby:isLock() then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	UIAction:Add(SEQ(DELAY(1000)), arg_174_0, "block")
	MatchService:query("arena_net_unregister_for_event", nil, function(arg_175_0)
		if arg_175_0.match_unregister_info.result == 1 then
			arg_174_0.vars.start_time = nil
			
			UIAction:Add(SEQ(DELAY(1000)), arg_174_0, "block")
			UIAction:Remove("match.canceling")
			Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
			ArenaNetLobby:setLock(false)
			arg_174_0:matchBtnState("NORMAL")
			arg_174_0:updateTime()
			LuaEventDispatcher:dispatchEvent("invite.event", "reload")
		end
	end)
	UIAction:Add(SEQ(DELAY(1000), CALL(function()
		arg_174_0:matchBtnState("CANCELING")
	end)), arg_174_0, "match.canceling")
end

ArenaNetBattleRecord = {}

function ArenaNetBattleRecord.show(arg_177_0, arg_177_1)
	arg_177_0.vars = {}
	arg_177_0.vars.wnd = arg_177_1.vars.base_wnd:getChildByName("CENTER_7")
	
	arg_177_0.vars.wnd:setVisible(true)
	
	arg_177_0.vars.tab = arg_177_1.vars.base_wnd:getChildByName("btn_tab_7")
	
	arg_177_0.vars.tab:setVisible(true)
	if_set_visible(arg_177_0.vars.tab, "bg", true)
	if_set_visible(arg_177_0.vars.wnd, "n_nodata", false)
	if_set_visible(arg_177_0.vars.wnd, "n_tab", ArenaNetLobby:isTimeOfEventMatch(true))
	if_set_visible(arg_177_0.vars.wnd, "txt_info", not ArenaNetLobby:isTimeOfEventMatch(true))
	if_set_visible(arg_177_0.vars.wnd, "fg_history_category_common", true)
	if_set_visible(arg_177_0.vars.wnd, "fg_history_category_event", false)
	arg_177_0:loadListView()
	arg_177_0:setCategory("RANKING")
	LuaEventDispatcher:removeEventListenerByKey("arena_net_battle_record_event")
	LuaEventDispatcher:addEventListener("arena_net_battle_record", LISTENER(ArenaNetBattleRecord.onEvent, arg_177_0), "arena_net_battle_record_event")
end

function ArenaNetBattleRecord.unshow(arg_178_0)
	arg_178_0.vars.wnd:setVisible(false)
	if_set_visible(arg_178_0.vars.tab, "bg", false)
end

function ArenaNetBattleRecord.onEvent(arg_179_0, ...)
	local var_179_0 = ...
	
	if var_179_0.event == "open_detail" then
		arg_179_0:openDetail(var_179_0.info)
	elseif var_179_0.event == "RANKING" then
		arg_179_0:setCategory(var_179_0.event)
	elseif var_179_0.event == "EVENT" then
		arg_179_0:setCategory(var_179_0.event)
	end
end

function ArenaNetBattleRecord.setCategory(arg_180_0, arg_180_1)
	if arg_180_0.vars.current_cateogry == arg_180_1 then
		return 
	end
	
	if MatchService:isProgress() then
		return 
	end
	
	if arg_180_0.vars.detail_lock then
		return 
	end
	
	if arg_180_0.vars.category_lock then
		return 
	end
	
	if os.time() - (arg_180_0.last_send_time or 0) < 1 then
		return 
	else
		arg_180_0.last_send_time = os.time()
	end
	
	arg_180_0.vars.category_lock = true
	arg_180_0.vars.current_cateogry = arg_180_1
	
	if arg_180_1 == "RANKING" then
		MatchService:query("arena_net_battle_log", nil, function(arg_181_0)
			if_set_visible(arg_180_0.vars.wnd, "fg_history_category_common", true)
			if_set_visible(arg_180_0.vars.wnd, "fg_history_category_event", false)
			
			arg_180_0.vars.category_lock = false
			arg_180_0.last_send_time = 0
			
			arg_180_0:update(arg_181_0)
		end)
	elseif arg_180_1 == "EVENT" then
		MatchService:query("arena_net_event_battle_log", nil, function(arg_182_0)
			if_set_visible(arg_180_0.vars.wnd, "fg_history_category_common", false)
			if_set_visible(arg_180_0.vars.wnd, "fg_history_category_event", true)
			
			arg_180_0.vars.category_lock = false
			arg_180_0.last_send_time = 0
			
			arg_180_0:update(arg_182_0)
		end)
	end
end

function ArenaNetBattleRecord.loadListView(arg_183_0)
	local var_183_0 = arg_183_0.vars.wnd:getChildByName("listview_history")
	
	arg_183_0.vars.itemView = ItemListView_v2:bindControl(var_183_0)
	
	local var_183_1 = load_control("wnd/pvplive_history_item.csb")
	
	if var_183_0.STRETCH_INFO then
		local var_183_2 = var_183_0:getContentSize()
		
		resetControlPosAndSize(var_183_1, var_183_2.width, var_183_0.STRETCH_INFO.width_prev)
	end
	
	local var_183_3 = {
		onUpdate = function(arg_184_0, arg_184_1, arg_184_2, arg_184_3)
			ArenaNetBattleRecord:updateItem(arg_184_1, arg_184_3)
			
			return arg_184_3.id
		end
	}
	
	arg_183_0.vars.itemView:setVisible(true)
	arg_183_0.vars.itemView:setRenderer(var_183_1, var_183_3)
	arg_183_0.vars.itemView:removeAllChildren()
	arg_183_0.vars.itemView:setDataSource({})
end

local function var_0_0(arg_185_0)
	if arg_185_0 == 1 then
		return T("pvp_rta_win")
	elseif arg_185_0 == 0 then
		return T("pvp_rta_draw")
	else
		return T("pvp_rta_defeat")
	end
end

local function var_0_1(arg_186_0)
	if arg_186_0 == 1 then
		return "img/battle_pvp_icon_win.png"
	elseif arg_186_0 == 0 then
		return "img/battle_pvp_icon_draw.png"
	else
		return "img/battle_pvp_icon_lose.png"
	end
end

function ArenaNetBattleRecord.updateItem(arg_187_0, arg_187_1, arg_187_2)
	arg_187_1:getChildByName("btn_info").info = arg_187_2
	
	local var_187_0 = os.time() - to_n(arg_187_2.finished)
	local var_187_1 = var_187_0 < 60 and T("time_just_before") or T("time_before", {
		time = sec_to_string(math.floor(var_187_0))
	})
	local var_187_2 = false
	local var_187_3 = false
	local var_187_4 = ArenaNetLobby:getEventSeasonId()
	
	if arg_187_0.vars.current_cateogry == "RANKING" then
		var_187_4 = ArenaNetLobby:getSeasonId()
		var_187_2 = (arg_187_2.my_team.win or 0) + (arg_187_2.my_team.draw or 0) + (arg_187_2.my_team.lose or 0) < ARENA_MATCH_BATCH_COUNT
		var_187_3 = (arg_187_2.enemy_team.win or 0) + (arg_187_2.enemy_team.draw or 0) + (arg_187_2.enemy_team.lose or 0) < ARENA_MATCH_BATCH_COUNT
	end
	
	SpriteCache:resetSprite(arg_187_1:getChildByName("icon_sprite"), var_0_1(arg_187_2.win_lose))
	
	local var_187_5 = arg_187_1:getChildByName("t_result")
	local var_187_6 = arg_187_1:getChildByName("t_score")
	local var_187_7 = arg_187_1:getChildByName("t_time")
	local var_187_8 = arg_187_1:getChildByName("t_name")
	local var_187_9 = arg_187_1:getChildByName("txt_nation")
	
	var_187_5:setString(var_0_0(arg_187_2.win_lose))
	var_187_6:setString(var_187_2 and T(ARENA_UNRANK_TEXT) or T("pvp_point", {
		point = comma_value(arg_187_2.score or 0)
	}))
	var_187_7:setString(var_187_1)
	
	if arg_187_2.enemy_team then
		var_187_8:setString(check_abuse_filter(arg_187_2.enemy_team.name, ABUSE_FILTER.WORLD_NAME) or arg_187_2.enemy_team.name)
		var_187_9:setString(getRegionText(arg_187_2.enemy_team.server))
		UIUserData:call(var_187_5, "SINGLE_WSCALE(143)")
		UIUserData:call(var_187_6, "SINGLE_WSCALE(143)")
		UIUserData:call(var_187_7, "SINGLE_WSCALE(143)")
		UIUserData:call(var_187_8, "SINGLE_WSCALE(150)")
		UIUserData:call(var_187_9, "SINGLE_WSCALE(120)")
		
		local var_187_10, var_187_11 = getArenaNetRankInfo(var_187_4, arg_187_2.enemy_team.league_id)
		
		if var_187_3 then
			SpriteCache:resetSprite(arg_187_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
		else
			SpriteCache:resetSprite(arg_187_1:getChildByName("emblem"), "emblem/" .. var_187_11 .. ".png")
		end
		
		UIUtil:getUserIcon(arg_187_2.enemy_team.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_187_1:getChildByName("mob_icon"),
			border_code = arg_187_2.enemy_team.border_code
		})
	end
end

function ArenaNetBattleRecord.update(arg_188_0, arg_188_1)
	arg_188_1 = arg_188_1 or {}
	arg_188_0.vars.item_list = arg_188_1.battle_logs or arg_188_1.event_battle_logs
	
	if_set_visible(arg_188_0.vars.wnd, "n_nodata", table.empty(arg_188_0.vars.item_list))
	arg_188_0.vars.itemView:setDataSource(arg_188_0.vars.item_list or {})
	arg_188_0.vars.itemView:jumpToTop()
end

function ArenaNetBattleRecord.openDetail(arg_189_0, arg_189_1)
	if os.time() - (arg_189_0.last_send_time or 0) < 1 then
		return 
	else
		arg_189_0.last_send_time = os.time()
	end
	
	if arg_189_0.vars.category_lock then
		return 
	end
	
	if arg_189_0.vars.detail_lock then
		return 
	end
	
	if ArenaNetBattleDetailInfo:isShow() then
		return 
	end
	
	arg_189_0.vars.detail_lock = true
	
	if arg_189_0.vars.current_cateogry == "EVENT" then
		if not MatchService:isProgress() then
			MatchService:query("arena_net_event_battle_detail", {
				event_uid = arg_189_1.event_uid
			}, function(arg_190_0)
				ArenaNetBattleDetailInfo:show("EVENT", arg_190_0, {
					show_share = true,
					show_replay = true
				})
				
				arg_189_0.vars.detail_lock = false
			end)
		end
	else
		ArenaNetBattleDetailInfo:show("RANK", arg_189_1, {
			show_share = true,
			show_replay = true
		})
		
		arg_189_0.vars.detail_lock = false
	end
end

ArenaNetVSMyRanking = {}

function ArenaNetVSMyRanking.show(arg_191_0, arg_191_1)
	arg_191_0.vars = {}
	arg_191_0.vars.parent = load_dlg("pvplive_myrank", true, "wnd", function()
		Dialog:closeAll()
	end)
	
	Dialog:msgBox(nil, {
		no_back_button = true,
		dlg = arg_191_0.vars.parent,
		handler = function(arg_193_0, arg_193_1)
			if arg_193_1 == "btn_close" then
				return 
			end
			
			if string.starts(arg_193_1, "btn_category_") then
				local var_193_0 = string.split(arg_193_1, "_")[3]
				
				ArenaNetVSMyRanking:changeCategory(var_193_0)
			end
			
			return "dont_close"
		end
	})
	arg_191_0:initUI()
	arg_191_0:changeCategory(arg_191_1)
end

function ArenaNetVSMyRanking.initUI(arg_194_0)
	if_set_visible(arg_194_0.vars.parent, "n_ranking", false)
	
	local var_194_0 = arg_194_0.vars.parent:getChildByName("n_category")
	
	if_set_visible(var_194_0, "fg_category_total", false)
	if_set_visible(var_194_0, "fg_category_league", true)
end

function ArenaNetVSMyRanking.changeCategory(arg_195_0, arg_195_1)
	if arg_195_1 == nil or arg_195_1 == arg_195_0.vars.category then
		return 
	end
	
	if os.time() - (arg_195_0.last_send_time or 0) < 1 then
		return 
	else
		arg_195_0.last_send_time = os.time()
	end
	
	arg_195_0.vars.category = arg_195_1
	
	if arg_195_0.vars.category == "league" then
		MatchService:query("arena_net_league_my_rank", nil, function(arg_196_0)
			arg_195_0:update(arg_196_0)
		end)
	else
		MatchService:query("arena_net_season_my_rank", nil, function(arg_197_0)
			arg_195_0:update(arg_197_0)
		end)
	end
end

function ArenaNetVSMyRanking.update(arg_198_0, arg_198_1)
	if not arg_198_1 then
		return 
	end
	
	local var_198_0 = arg_198_0.vars.parent:getChildByName("n_ranking")
	local var_198_1 = arg_198_0.vars.parent:getChildByName("n_category")
	
	var_198_0:setVisible(true)
	if_set_visible(var_198_1, "fg_category_total", false)
	if_set_visible(var_198_1, "fg_category_league", false)
	if_set_visible(var_198_1, "fg_category_" .. arg_198_0.vars.category, true)
	
	for iter_198_0 = 1, 5 do
		local var_198_2 = var_198_0:getChildByName("n_" .. tostring(iter_198_0))
		local var_198_3 = var_198_2:getChildByName("n_item")
		
		var_198_3:removeAllChildren()
		
		local var_198_4 = arg_198_1.rank_list and arg_198_1.rank_list[iter_198_0] and arg_198_1.rank_list[iter_198_0].name == AccountData.name and ArenaNetLobby:getUserInfo().world == arg_198_1.rank_list[iter_198_0].world
		
		if_set_visible(var_198_2, "bg", var_198_4)
		
		local var_198_5 = arg_198_0:updateItem(iter_198_0, arg_198_1)
		
		if var_198_5 then
			var_198_3:addChild(var_198_5)
		end
	end
end

function ArenaNetVSMyRanking.updateItem(arg_199_0, arg_199_1, arg_199_2)
	local var_199_0 = arg_199_2.rank_list and arg_199_2.rank_list[arg_199_1] or nil
	
	if not var_199_0 then
		return 
	end
	
	local var_199_1 = load_control("wnd/pvplive_myrank_bar.csb")
	local var_199_2 = ArenaNetLobby:getSeasonId()
	local var_199_3, var_199_4 = getArenaNetRankInfo(var_199_2, var_199_0.league_id)
	
	SpriteCache:resetSprite(var_199_1:getChildByName("icon_league"), "emblem/" .. var_199_4 .. ".png")
	UIUtil:getUserIcon(var_199_0.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_199_1:getChildByName("mob_icon"),
		border_code = var_199_0.border_code
	})
	if_set(var_199_1, "txt_rank", T("pvp_list_rank", {
		rank = var_199_0.rank
	}))
	if_set(var_199_1, "txt_name", var_199_0.name)
	if_set(var_199_1, "txt_nation", getRegionText(var_199_0.world))
	if_set(var_199_1, "txt_rating", T("pvp_point", {
		point = comma_value(var_199_0.score)
	}))
	
	return var_199_1
end

function HANDLER.pvplive_battle_history_info(arg_200_0, arg_200_1)
	if arg_200_1 == "btn_close" then
		ArenaNetBattleDetailInfo:close()
	elseif string.starts(arg_200_1, "btn_round") then
		ArenaNetBattleDetailInfo:setTab(to_n(string.sub(arg_200_1, -1, -1)))
	elseif arg_200_1 == "btn_replay" then
		ArenaNetBattleDetailInfo:playReplay()
	elseif arg_200_1 == "btn_share" then
		ArenaNetBattleShare:show()
	elseif arg_200_1 == "btn_profile" and arg_200_0 then
		if arg_200_0.my_arena_uid and arg_200_0.enemy_arena_uid then
			MatchService:query("arena_net_server_preview_data", {
				my_arena_uid = arg_200_0.my_arena_uid,
				enemy_arena_uid = arg_200_0.enemy_arena_uid
			}, function(arg_201_0)
				Friend:preview(nil, nil, {
					preview_data = arg_201_0,
					is_diff_server = arg_200_0.is_diff_server
				})
			end)
		elseif arg_200_0.is_shared_replay then
			balloon_message_with_sound("msg_rta_cant_view_profile_shared")
		else
			balloon_message_with_sound("msg_rta_cant_view_profile")
		end
	end
end

function HANDLER.pvplive_battle_history_share(arg_202_0, arg_202_1)
	if arg_202_1 == "btn_close" then
		ArenaNetBattleShare:close()
	elseif arg_202_1 == "btn_yes" then
		ArenaNetBattleShare:shareReplay()
	end
end

ArenaNetBattleDetailInfo = {}

function ArenaNetBattleDetailInfo.show(arg_203_0, arg_203_1, arg_203_2, arg_203_3, arg_203_4)
	if arg_203_0.vars and arg_203_0.vars.wnd and get_cocos_refid(arg_203_0.vars.wnd) then
		arg_203_0:close()
	end
	
	arg_203_0.vars = {}
	arg_203_0.vars.wnd = load_dlg("pvplive_battle_history_info", true, "wnd", function()
		arg_203_0:close()
	end)
	arg_203_0.vars.mode = arg_203_1
	arg_203_0.vars.infos = arg_203_2
	
	if arg_203_0.vars.infos.season_id ~= nil then
		arg_203_0.vars.season_id = arg_203_0.vars.infos.season_id
	else
		arg_203_0.vars.season_id = arg_203_1 == "EVENT" and ArenaNetLobby:getEventSeasonId() or ArenaNetLobby:getSeasonId()
	end
	
	arg_203_3 = arg_203_3 or {
		show_share = false,
		show_replay = true
	}
	arg_203_0.vars.show_replay = arg_203_3.show_replay
	arg_203_0.vars.show_share = arg_203_3.show_share
	
	if arg_203_4 ~= nil and type(arg_203_4) == "number" then
		arg_203_0.vars.replay_share_id = arg_203_4
	end
	
	arg_203_0:cache()
	arg_203_0:initUI(arg_203_1)
	
	if arg_203_1 == "EVENT" then
		table.reverse(arg_203_0.vars.infos.battle_logs)
	end
	
	if arg_203_1 == "EVENT" then
		arg_203_0:setTab(1)
	else
		arg_203_0:updateUI(arg_203_2)
	end
	
	SceneManager:getRunningPopupScene():addChild(arg_203_0.vars.wnd)
	arg_203_0.vars.wnd:bringToFront()
end

function ArenaNetBattleDetailInfo.isShow(arg_205_0)
	return arg_205_0.vars and get_cocos_refid(arg_205_0.vars.wnd)
end

function ArenaNetBattleDetailInfo.getWnd(arg_206_0)
	if not arg_206_0.vars or not arg_206_0.vars.wnd or not get_cocos_refid(arg_206_0.vars.wnd) then
		return nil
	end
	
	return arg_206_0.vars.wnd
end

function ArenaNetBattleDetailInfo.cache(arg_207_0)
	local var_207_0 = {
		my_team = arg_207_0.vars.wnd:getChildByName("LEFT"),
		enemy_team = arg_207_0.vars.wnd:getChildByName("RIGHT")
	}
	
	arg_207_0.vars.user_info_roots = {}
	arg_207_0.vars.first_pick_nodes = {}
	arg_207_0.vars.user_slots = {}
	arg_207_0.vars.n_title = arg_207_0.vars.wnd:getChildByName("n_title")
	arg_207_0.vars.n_event_title = arg_207_0.vars.wnd:getChildByName("n_title_round")
	
	for iter_207_0, iter_207_1 in pairs(var_207_0 or {}) do
		arg_207_0.vars.user_info_roots[iter_207_0] = iter_207_1:getChildByName("n_user_info")
		arg_207_0.vars.first_pick_nodes[iter_207_0] = iter_207_1:getChildByName("n_first_pick")
		arg_207_0.vars.user_slots[iter_207_0] = {}
		
		local var_207_1 = iter_207_1:getChildByName("n_slot_info")
		
		for iter_207_2 = 1, 5 do
			arg_207_0.vars.user_slots[iter_207_0][iter_207_2] = var_207_1:getChildByName("slot" .. tostring(iter_207_2))
		end
	end
	
	local var_207_2 = arg_207_0.vars.wnd:getChildByName("CENTER")
	
	arg_207_0.vars.pre_ban_icons = {}
	arg_207_0.vars.pre_ban_icons.my_team = var_207_2:getChildByName("face_icon1")
	arg_207_0.vars.pre_ban_icons.enemy_team = var_207_2:getChildByName("face_icon2")
	arg_207_0.vars.preban_node = arg_207_0.vars.wnd:getChildByName("n_pre_ben")
	arg_207_0.vars.result_node = var_207_2:getChildByName("n_result")
	arg_207_0.vars.result_node.origin_pos_y = arg_207_0.vars.result_node:getPositionY()
	arg_207_0.vars.replay_node = arg_207_0.vars.wnd:getChildByName("n_replay")
	arg_207_0.vars.replay_node.origin_pos_y = arg_207_0.vars.replay_node:getPositionY()
end

function ArenaNetBattleDetailInfo.setTab(arg_208_0, arg_208_1)
	if arg_208_1 > table.count(arg_208_0.vars.infos.battle_logs) or arg_208_1 < 1 then
		return 
	end
	
	if arg_208_0.vars.cur_tab == arg_208_1 then
		return 
	end
	
	arg_208_0.vars.cur_tab = arg_208_1
	
	for iter_208_0 = 1, 3 do
		local var_208_0 = "bg_round" .. tostring(iter_208_0)
		
		arg_208_0.vars.n_event_title:getChildByName(var_208_0):setVisible(iter_208_0 == arg_208_1)
	end
	
	arg_208_0:updateUI(arg_208_0.vars.infos.battle_logs[arg_208_1])
end

function ArenaNetBattleDetailInfo.initUI(arg_209_0, arg_209_1)
	local var_209_0 = arg_209_1 == "EVENT"
	
	arg_209_0.vars.n_title:setVisible(not var_209_0)
	arg_209_0.vars.n_event_title:setVisible(var_209_0)
	
	local var_209_1 = arg_209_0.vars.wnd:getChildByName("btn_profile")
	
	if var_209_0 then
		local var_209_2 = table.count(arg_209_0.vars.infos.battle_logs)
		local var_209_3 = false
		local var_209_4 = false
		
		if var_209_2 == 1 then
			var_209_3 = true
		elseif var_209_2 == 2 then
			var_209_4 = true
		end
		
		local var_209_5 = {}
		local var_209_6
		local var_209_7
		local var_209_8
		local var_209_9
		
		for iter_209_0 = 1, 3 do
			local var_209_10 = "btn_round" .. tostring(iter_209_0)
			local var_209_11 = arg_209_0.vars.n_event_title:getChildByName(var_209_10)
			
			table.insert(var_209_5, var_209_11)
			
			if var_209_2 < iter_209_0 then
				var_209_11:setVisible(false)
			end
			
			local var_209_12 = arg_209_0.vars.infos.battle_logs[iter_209_0]
			
			if not table.empty(var_209_12) and not table.empty(var_209_12.my_team) and not table.empty(var_209_12.enemy_team) then
				var_209_7 = var_209_7 or var_209_12.my_team.arena_uid
				var_209_8 = var_209_8 or var_209_12.enemy_team.arena_uid
				var_209_6 = var_209_6 or var_209_12.my_team.server
				var_209_9 = var_209_9 or var_209_12.enemy_team.server
				
				if var_209_7 ~= var_209_12.my_team.arena_uid or var_209_8 ~= var_209_12.enemy_team.arena_uid or var_209_6 ~= var_209_12.my_team.server or var_209_9 ~= var_209_12.enemy_team.server then
					Log.e("모든 라운드에 대해서 정보가 동일해야 함. 있으면 안 되는 상황")
				end
			end
		end
		
		if not table.empty(var_209_5) then
			if var_209_3 then
				if_set_position_x(var_209_5[1], nil, 599)
			elseif var_209_4 then
				if_set_position_x(var_209_5[1], nil, 489)
				if_set_position_x(var_209_5[2], nil, 599)
			end
		end
		
		if get_cocos_refid(var_209_1) and var_209_7 then
			var_209_1.my_arena_uid = var_209_7
		end
		
		if get_cocos_refid(var_209_1) and var_209_8 then
			var_209_1.enemy_arena_uid = var_209_8
		end
		
		if var_209_6 and var_209_9 then
			var_209_1.is_diff_server = var_209_6 ~= var_209_9
		end
	else
		if get_cocos_refid(var_209_1) and arg_209_0.vars.infos.my_team.arena_uid then
			var_209_1.my_arena_uid = arg_209_0.vars.infos.my_team.arena_uid
		end
		
		if get_cocos_refid(var_209_1) and arg_209_0.vars.infos.enemy_team.arena_uid then
			var_209_1.enemy_arena_uid = arg_209_0.vars.infos.enemy_team.arena_uid
		end
		
		if arg_209_0.vars.infos.my_team.server and arg_209_0.vars.infos.enemy_team.server then
			var_209_1.is_diff_server = arg_209_0.vars.infos.my_team.server ~= arg_209_0.vars.infos.enemy_team.server
		end
	end
	
	if_set_opacity(var_209_1, nil, var_209_1.my_arena_uid and var_209_1.enemy_arena_uid and 255 or 76.5)
	
	if arg_209_0.vars.replay_share_id then
		var_209_1.my_arena_uid = nil
		var_209_1.enemy_arena_uid = nil
		var_209_1.is_shared_replay = true
		
		if_set_opacity(var_209_1, nil, 76.5)
	end
end

function ArenaNetBattleDetailInfo.updateUI(arg_210_0, arg_210_1)
	arg_210_0.vars.room_uid = tostring(arg_210_1.room_uid)
	
	arg_210_0:updateUserInfo(arg_210_1)
	arg_210_0:updateSlotInfo(arg_210_1)
	arg_210_0:updatePreBanInfo(arg_210_1)
	arg_210_0:updateResultInfo(arg_210_1)
end

function ArenaNetBattleDetailInfo.updateUserInfo(arg_211_0, arg_211_1)
	for iter_211_0, iter_211_1 in pairs({
		"my_team",
		"enemy_team"
	}) do
		local var_211_0 = arg_211_1[iter_211_1]
		local var_211_1 = arg_211_0.vars.user_info_roots[iter_211_1]
		local var_211_2, var_211_3 = getArenaNetRankInfo(arg_211_0.vars.season_id, var_211_0.league_id)
		
		if_set(var_211_1, "txt_name", check_abuse_filter(var_211_0.name, ABUSE_FILTER.WORLD_NAME) or var_211_0.name)
		if_set(var_211_1, "txt_nation", getRegionText(var_211_0.server))
		arg_211_0.vars.first_pick_nodes[iter_211_1]:setVisible(var_211_0.first_user)
		UIUtil:getUserIcon(var_211_0.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = var_211_1:getChildByName("mob_icon"),
			border_code = var_211_0.border_code
		})
		
		local var_211_4
		
		if (arg_211_0.vars.mode ~= "EVENT" or false) and (var_211_0.win or 0) + (var_211_0.draw or 0) + (var_211_0.lose or 0) < ARENA_MATCH_BATCH_COUNT then
			SpriteCache:resetSprite(var_211_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
		else
			SpriteCache:resetSprite(var_211_1:getChildByName("emblem"), "emblem/" .. var_211_3 .. ".png")
		end
		
		if_set(var_211_1, "txt_clan", clanNameFilter(var_211_0.clan_name))
		UIUtil:updateClanEmblem(var_211_1:getChildByName("n_emblem"), {
			emblem = var_211_0.clan_emblem
		})
		if_set_visible(var_211_1, "n_emblem", string.len(var_211_0.clan_name or "") > 0)
		
		local var_211_5 = string.len(var_211_0.clan_name or "") > 0 and 0 or -13
		local var_211_6 = string.len(var_211_0.clan_name or "") > 0 and 0 or 13
		
		if_set_add_position_y(var_211_1, "txt_name", var_211_5)
		if_set_add_position_y(var_211_1, "icon_menu_global", var_211_6)
		if_set_add_position_y(var_211_1, "txt_nation", var_211_6)
	end
end

function ArenaNetBattleDetailInfo.updateSlotInfo(arg_212_0, arg_212_1)
	for iter_212_0, iter_212_1 in pairs({
		"my_team",
		"enemy_team"
	}) do
		local var_212_0 = arg_212_1[iter_212_1]
		local var_212_1 = var_212_0.post_ban and var_212_0.post_ban.code
		
		for iter_212_2 = 1, 5 do
			local var_212_2 = arg_212_0.vars.user_slots[iter_212_1][iter_212_2]
			
			if var_212_0.picks and var_212_0.picks[iter_212_2] then
				local var_212_3 = var_212_0.picks[iter_212_2]
				local var_212_4 = UNIT:create({
					code = var_212_3.c,
					skin_code = var_212_3.s,
					exp = var_212_3.e,
					g = var_212_3.g,
					z = var_212_3.z,
					awake = var_212_3.awake
				})
				
				if var_212_4 then
					if var_212_3.gl then
						var_212_4.inst.lv = var_212_3.gl
					end
					
					if_set_visible(var_212_2, "n_unit", true)
					if_set_visible(var_212_2, "n_no_hero", false)
					if_set_visible(var_212_2, "icon_not_selected", false)
					if_set_visible(var_212_2, "icon_drop_off", false)
					SpriteCache:resetSprite(var_212_2:getChildByName("face"), "face/" .. (var_212_4.db.face_id or "") .. "_l.png")
					SpriteCache:resetSprite(var_212_2:getChildByName("role"), "img/cm_icon_role_" .. var_212_4.db.role .. ".png")
					SpriteCache:resetSprite(var_212_2:getChildByName("element"), UIUtil:getColorIcon(var_212_4))
					
					if iter_212_1 == "my_team" then
						if table.find(not_allow_flip_units, var_212_4.inst.code) then
							var_212_2:getChildByName("face"):setFlippedX(false)
						else
							var_212_2:getChildByName("face"):setFlippedX(true)
						end
					end
					
					UIUtil:setLevel(var_212_2, var_212_4:getLv(), var_212_4:getMaxLevel(), 6)
					UIUtil:setStarsByUnit(var_212_2, var_212_4)
					
					if var_212_1 == var_212_3.c then
						if_set_visible(var_212_2, "n_ban", true)
						if_set_color(var_212_2, "img_bg", cc.c3b(75, 75, 75))
						if_set_color(var_212_2, "n_unit", cc.c3b(75, 75, 75))
					else
						if_set_visible(var_212_2, "n_ban", false)
						if_set_color(var_212_2, "img_bg", cc.c3b(255, 255, 255))
						if_set_color(var_212_2, "n_unit", cc.c3b(255, 255, 255))
					end
				end
			else
				if_set_visible(var_212_2, "n_unit", false)
				if_set_visible(var_212_2, "n_ban", false)
				if_set_visible(var_212_2, "n_no_hero", true)
				if_set_color(var_212_2, "img_bg", tocolor("#333333"))
				
				if iter_212_1 == "my_team" then
					if arg_212_1.win_lose == 0 or arg_212_1.win_lose == 1 then
						if_set(var_212_2, "t_no_hero", T("pvp_rta_banpick_win"))
						if_set_visible(var_212_2, "icon_not_selected", true)
						if_set_visible(var_212_2, "icon_drop_off", false)
					else
						if_set(var_212_2, "t_no_hero", T("pvp_rta_banpick_lose"))
						if_set_visible(var_212_2, "icon_not_selected", false)
						if_set_visible(var_212_2, "icon_drop_off", true)
					end
				elseif iter_212_1 == "enemy_team" then
					if arg_212_1.win_lose == 0 or arg_212_1.win_lose == -1 then
						if_set(var_212_2, "t_no_hero", T("pvp_rta_banpick_win"))
						if_set_visible(var_212_2, "icon_not_selected", true)
						if_set_visible(var_212_2, "icon_drop_off", false)
					else
						if_set(var_212_2, "t_no_hero", T("pvp_rta_banpick_lose"))
						if_set_visible(var_212_2, "icon_not_selected", false)
						if_set_visible(var_212_2, "icon_drop_off", true)
					end
				end
			end
		end
	end
end

function ArenaNetBattleDetailInfo.updatePreBanInfo(arg_213_0, arg_213_1)
	arg_213_0.vars.preban_node:setVisible(true)
	if_set_visible(arg_213_0.vars.preban_node, "n_bann", false)
	
	local var_213_0 = arg_213_1.my_team.pre_ban
	local var_213_1 = arg_213_1.enemy_team.pre_ban
	
	updatePrebanNodes(arg_213_0.vars.preban_node:getChildByName("n_face_l"), makePrebanNodes("left", var_213_0), true)
	updatePrebanNodes(arg_213_0.vars.preban_node:getChildByName("n_face_r"), makePrebanNodes("right", var_213_1), true)
end

function ArenaNetBattleDetailInfo.updateResultInfo(arg_214_0, arg_214_1)
	local var_214_0 = os.time() - to_n(arg_214_1.finished)
	local var_214_1 = var_214_0 < 60 and T("time_just_before") or T("time_before", {
		time = sec_to_string(math.floor(var_214_0))
	})
	local var_214_2 = arg_214_1.my_team
	local var_214_3
	local var_214_4 = (arg_214_0.vars.mode ~= "EVENT" or false) and (var_214_2.win or 0) + (var_214_2.draw or 0) + (var_214_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	if_set(arg_214_0.vars.result_node, "t_result", var_0_0(arg_214_1.win_lose))
	if_set(arg_214_0.vars.result_node, "t_score", var_214_4 and T(ARENA_UNRANK_TEXT) or T("pvp_point", {
		point = comma_value(arg_214_1.score or 0)
	}))
	if_set(arg_214_0.vars.result_node, "t_time", var_214_1)
	if_set_visible(arg_214_0.vars.result_node, "t_score", arg_214_0.vars.mode ~= "EVENT")
	SpriteCache:resetSprite(arg_214_0.vars.result_node:getChildByName("icon_result_sprite"), var_0_1(arg_214_1.win_lose))
	
	local var_214_5 = arg_214_0.vars.replay_node
	
	if var_214_5 and get_cocos_refid(var_214_5) and (arg_214_0.vars.show_replay or arg_214_0.vars.show_share) then
		var_214_5:setVisible(true)
		
		local var_214_6 = var_214_5:getChildByName("btn_replay")
		local var_214_7 = var_214_5:getChildByName("btn_share")
		
		if_set(var_214_6, "txt_replay", T("ui_pvp_rta_replay_btn"))
		var_214_6:setVisible(arg_214_0.vars.show_replay)
		
		if not arg_214_0.vars.show_share then
			var_214_5:setPositionX(var_214_5:getPositionX() + 38)
		else
			var_214_6:setOpacity(255)
			var_214_7:setOpacity(255)
		end
		
		var_214_7:setVisible(arg_214_0.vars.show_share)
		
		if not Account:getClanId() or ArenaNetBattleShare:isDelay() then
			var_214_7:setOpacity(76.5)
			
			if ArenaNetBattleShare:isDelay() then
				Scheduler:addSlow(var_214_7, arg_214_0.updateDelay, arg_214_0):setName("share.updateDelay")
			end
		end
		
		local var_214_8 = false
		
		if ContentDisable:byAlias("world_arena_replay") then
			var_214_8 = true
		end
		
		if not arg_214_0.vars.replay_share_id then
			local var_214_9 = arg_214_0:getConvertedGameMode()
			local var_214_10 = arg_214_0:getRoomId()
			local var_214_11 = {
				mode = var_214_9,
				uid = var_214_10
			}
			local var_214_12, var_214_13 = BattleViewer:getLocalReplayFileNameByOpts(var_214_11)
			
			arg_214_0.vars.is_exist_local_file = var_214_13 == nil
			
			if not arg_214_0.vars.is_exist_local_file then
				var_214_8 = true
			end
		end
		
		if var_214_8 then
			var_214_6:setOpacity(76.5)
			var_214_7:setOpacity(76.5)
		end
	end
	
	if_set(arg_214_0.vars.wnd:getChildByName("CENTER"), "t_uid", "#" .. arg_214_0.vars.room_uid)
end

function ArenaNetBattleDetailInfo.getRoomId(arg_215_0)
	if not arg_215_0.vars or not arg_215_0.vars.wnd or not get_cocos_refid(arg_215_0.vars.wnd) then
		return 
	end
	
	return arg_215_0.vars.room_uid or -1
end

function ArenaNetBattleDetailInfo.getSeasonId(arg_216_0)
	if not arg_216_0.vars or not arg_216_0.vars.wnd or not get_cocos_refid(arg_216_0.vars.wnd) then
		return 
	end
	
	return arg_216_0.vars.season_id or ""
end

function ArenaNetBattleDetailInfo.getConvertedGameMode(arg_217_0)
	if not arg_217_0.vars or not arg_217_0.vars.wnd or not get_cocos_refid(arg_217_0.vars.wnd) then
		return 
	end
	
	if arg_217_0.vars.mode == "RANK" then
		return "net_rank"
	elseif arg_217_0.vars.mode == "EVENT" then
		return "net_event_rank"
	end
	
	return "net_rank"
end

function ArenaNetBattleDetailInfo.isExistLocalFile(arg_218_0)
	if not arg_218_0.vars or not arg_218_0.vars.wnd or not get_cocos_refid(arg_218_0.vars.wnd) then
		return 
	end
	
	return arg_218_0.vars.is_exist_local_file
end

function ArenaNetBattleDetailInfo.setShareButton(arg_219_0, arg_219_1)
	if not arg_219_0.vars or not arg_219_0.vars.wnd or not get_cocos_refid(arg_219_0.vars.wnd) then
		return 
	end
	
	if not arg_219_0.vars.replay_node then
		return 
	end
	
	local var_219_0 = arg_219_0.vars.replay_node:getChildByName("btn_share")
	
	if arg_219_1 then
		var_219_0:setOpacity(76.5)
	else
		var_219_0:setOpacity(255)
	end
end

function ArenaNetBattleDetailInfo.playReplay(arg_220_0)
	if not arg_220_0.vars or not arg_220_0.vars.wnd or not get_cocos_refid(arg_220_0.vars.wnd) then
		return 
	end
	
	if ContentDisable:byAlias("world_arena_replay") then
		balloon_message_with_sound("msg_pvp_rta_replay_share_contentoff")
		
		return 
	end
	
	local var_220_0 = arg_220_0:getSeasonId()
	local var_220_1 = arg_220_0:getRoomId()
	
	if var_220_0 ~= "" and var_220_1 ~= -1 then
		if arg_220_0.vars.replay_share_id ~= nil then
			local var_220_2 = ChatMBox:getReplayCache(arg_220_0.vars.replay_share_id)
			
			if var_220_2 then
				if var_220_2.battle_info and var_220_2.battle_info.finished and var_220_2.battle_recent_limit_day then
					local var_220_3 = var_220_2.battle_recent_limit_day * 24 * 60 * 60
					
					if var_220_2.battle_info.finished + var_220_3 <= os.time() then
						balloon_message_with_sound("msg_pvp_rta_replay_share_timeexpiration")
						
						return 
					end
				end
				
				if var_220_2.verify_data and var_220_2.unverify_data and var_220_2.replay_min_version then
					BattleViewer:playRemoteReplay(var_220_2.verify_data, var_220_2.unverify_data, var_220_2.replay_min_version)
					
					return 
				end
			end
		end
		
		local var_220_4 = arg_220_0:getConvertedGameMode()
		local var_220_5 = {
			mode = var_220_4,
			uid = var_220_1
		}
		local var_220_6 = BattleViewer:getLocalReplayFileNameByOpts(var_220_5)
		local var_220_7 = ArenaNetLobby:getReplayMinVersion()
		
		if var_220_6 and var_220_7 then
			BattleViewer:playLocalReplay(var_220_6, var_220_7)
			
			return 
		end
		
		if not arg_220_0.vars.is_exist_local_file then
			balloon_message_with_sound("msg_pvp_rta_replay_lock_crash")
			
			return 
		end
	end
end

function ArenaNetBattleDetailInfo.updateDelay(arg_221_0)
	if not arg_221_0.vars or not arg_221_0.vars.wnd or not get_cocos_refid(arg_221_0.vars.wnd) then
		return 
	end
	
	if not ArenaNetBattleShare:isDelay() then
		arg_221_0:setShareButton()
		Scheduler:removeByName("share.updateDelay")
	end
end

function ArenaNetBattleDetailInfo.close(arg_222_0)
	Scheduler:removeByName("share.updateDelay")
	BackButtonManager:pop("pvplive_battle_history_info")
	arg_222_0.vars.wnd:removeFromParent()
	UIAction:Add(SEQ(REMOVE()), arg_222_0.vars.wnd, "block")
	
	arg_222_0.vars = nil
end

ArenaNetBattleShare = {}

function ArenaNetBattleShare.show(arg_223_0)
	if not ArenaNetBattleDetailInfo:isShow() then
		return 
	end
	
	if ContentDisable:byAlias("world_arena_replay") then
		balloon_message_with_sound("msg_pvp_rta_replay_share_contentoff")
		
		return 
	end
	
	if not Account:getClanId() then
		balloon_message_with_sound("msg_pvp_rta_replay_clan_non")
		
		return 
	end
	
	if not ArenaNetBattleDetailInfo:isExistLocalFile() then
		balloon_message_with_sound("msg_pvp_rta_replay_lock_crash")
		
		return 
	end
	
	local var_223_0 = ArenaNetBattleDetailInfo:getConvertedGameMode()
	local var_223_1 = ArenaNetBattleDetailInfo:getRoomId()
	local var_223_2 = {
		mode = var_223_0,
		uid = var_223_1
	}
	local var_223_3 = BattleViewer:getLocalReplayFileNameByOpts(var_223_2)
	
	if not arg_223_0:checkVersion(var_223_3) then
		balloon_message_with_sound("msg_pvp_rta_replay_lock_version")
		
		return 
	end
	
	if arg_223_0:isDelay() then
		local var_223_4 = math.ceil((GAME_CONTENT_VARIABLE.pvp_rta_replay_share_delay or 10) - (systick() - arg_223_0.last_send_tick) / 1000)
		
		balloon_message_with_sound("msg_pvp_rta_replay_share_delay", {
			delay_time = var_223_4
		})
		
		return 
	end
	
	arg_223_0.vars = {}
	arg_223_0.vars.wnd = load_dlg("pvplive_battle_history_share", true, "wnd", function()
		arg_223_0:close()
	end)
	
	arg_223_0:setUI()
	arg_223_0:setInputEvent()
	
	if not arg_223_0.last_send_tick then
		arg_223_0.last_send_tick = 0
	end
	
	if not arg_223_0.delay then
		arg_223_0.delay = (GAME_CONTENT_VARIABLE.pvp_rta_replay_share_delay or 10) * 1000
	end
	
	SceneManager:getRunningPopupScene():addChild(arg_223_0.vars.wnd)
end

function ArenaNetBattleShare.checkVersion(arg_225_0, arg_225_1)
	if not arg_225_1 then
		return false
	end
	
	local var_225_0, var_225_1 = BattleViewer:loadLocalReplay(arg_225_1, true)
	
	if not var_225_0 then
		Log.e("load local replay data fail", arg_225_1, var_225_1)
		
		return false
	end
	
	if PLATFORM == "win32" and not PRODUCTION_MODE and DEBUG.ignore_res_version then
		return true
	end
	
	local var_225_2 = var_225_0.version_info
	local var_225_3 = ArenaNetLobby:getReplayMinVersion()
	
	if var_225_2 and var_225_2.res_version and var_225_3 and var_225_3 <= tonumber(var_225_2.res_version) then
		return true
	end
	
	return false
end

MAX_COMMENT_TEXT = 30

function ArenaNetBattleShare.setUI(arg_226_0)
	if not arg_226_0.vars or not arg_226_0.vars.wnd or not get_cocos_refid(arg_226_0.vars.wnd) then
		return 
	end
	
	local var_226_0 = arg_226_0.vars.wnd:getChildByName("n_top")
	
	if_set(var_226_0, "txt_title", T("ui_pvp_rta_replay_share_comment"))
	if_set(var_226_0, "txt_input_number", T("ui_pvp_rta_replay_share_comment_limit"))
	
	local var_226_1 = arg_226_0.vars.wnd:getChildByName("n_bottom")
	
	if_set(var_226_1, "txt_info", T("ui_pvp_rta_replay_share_desc"))
	if_set(var_226_1, "txt_share", T("ui_pvp_rta_replay_chatshare_btn"))
end

function ArenaNetBattleShare.setInputEvent(arg_227_0)
	if not arg_227_0.vars or not arg_227_0.vars.wnd or not get_cocos_refid(arg_227_0.vars.wnd) then
		return 
	end
	
	arg_227_0.vars.input = arg_227_0.vars.wnd:getChildByName("txt_input")
	
	local var_227_0 = arg_227_0.vars.input
	
	var_227_0:setMaxLength(MAX_COMMENT_TEXT)
	var_227_0:setMaxLengthEnabled(true)
	var_227_0:setCursorEnabled(true)
	var_227_0:setTextColor(cc.c3b(107, 101, 27))
	var_227_0:setPlaceHolder(T("ui_pvp_rta_replay_share_comment_select"))
	var_227_0:setEnabled(true)
	
	local var_227_1 = tolua.cast(var_227_0:getVirtualRenderer(), "cc.Label")
	
	var_227_0:addEventListener(function(arg_228_0, arg_228_1)
		UIUtil:updateTextWrapMode(var_227_1, var_227_0:getString(), 19)
	end)
end

function ArenaNetBattleShare.isDelay(arg_229_0)
	if not arg_229_0.last_send_tick then
		arg_229_0.last_send_tick = 0
	end
	
	if not arg_229_0.delay then
		arg_229_0.delay = (GAME_CONTENT_VARIABLE.pvp_rta_replay_share_delay or 10) * 1000
	end
	
	if systick() - arg_229_0.last_send_tick < arg_229_0.delay then
		return true
	end
	
	return false
end

function ArenaNetBattleShare.shareReplay(arg_230_0)
	if not arg_230_0.vars or not arg_230_0.vars.wnd or not get_cocos_refid(arg_230_0.vars.wnd) then
		return 
	end
	
	if not arg_230_0.vars.input or not get_cocos_refid(arg_230_0.vars.input) then
		return 
	end
	
	local var_230_0 = arg_230_0.vars.input:getString()
	local var_230_1 = string.trim(var_230_0)
	
	if var_230_1 == nil or var_230_1 == "" then
		var_230_1 = T("pvp_rta_replay_share_basecomment")
	end
	
	if check_abuse_filter(var_230_1, ABUSE_FILTER.CHAT) then
		balloon_message_with_sound("invalid_input_word")
		
		return 
	end
	
	local var_230_2 = ArenaNetBattleDetailInfo:getConvertedGameMode()
	local var_230_3 = ArenaNetBattleDetailInfo:getRoomId()
	
	if var_230_3 ~= -1 then
		local var_230_4 = {
			mode = var_230_2,
			uid = var_230_3
		}
		local var_230_5 = BattleViewer:getLocalReplayFileNameByOpts(var_230_4)
		local var_230_6, var_230_7 = BattleViewer:getLocalReplayData(var_230_5, true)
		
		if var_230_6 then
			local var_230_8 = {
				net_event_rank = 2,
				net_rank = 0
			}
			local var_230_9 = {
				room_uid = var_230_3,
				game_mode = var_230_8[var_230_2],
				verify_data = var_230_6.verify_data,
				unverify_data = var_230_6.unverify_data,
				comment = var_230_1
			}
			
			MatchService:query("arena_net_replay_share", var_230_9, function(arg_231_0)
				arg_230_0:shareReplayToClan(arg_231_0)
			end)
			UIAction:Add(DELAY(0), arg_230_0.vars.wnd, "block")
			
			arg_230_0.last_send_tick = systick()
		end
	end
end

function ArenaNetBattleShare.shareReplayToClan(arg_232_0, arg_232_1)
	if not arg_232_0.vars or not arg_232_0.vars.wnd or not get_cocos_refid(arg_232_0.vars.wnd) then
		return 
	end
	
	if UIAction:Find("block") then
		UIAction:Remove("block")
	end
	
	if arg_232_1 then
		if PLATFORM == "win32" then
			Log.i("replay share id", arg_232_1.replay_share_id)
		end
		
		local var_232_0 = {
			section = "clan",
			share_id = arg_232_1.replay_share_id,
			secret_key = arg_232_1.secret_key,
			comment = arg_232_1.comment
		}
		
		ChatSock:replay_share(var_232_0)
		arg_232_0:close()
		ArenaNetBattleDetailInfo:setShareButton(true)
		
		local var_232_1 = ArenaNetBattleDetailInfo:getWnd()
		
		if var_232_1 then
			Scheduler:addSlow(var_232_1, ArenaNetBattleDetailInfo.updateDelay, ArenaNetBattleDetailInfo):setName("share.updateDelay")
		end
	end
end

function ArenaNetBattleShare.close(arg_233_0)
	if not arg_233_0.vars.wnd or not get_cocos_refid(arg_233_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("pvplive_battle_history_share")
	UIAction:Add(SEQ(REMOVE()), arg_233_0.vars.wnd, "block")
	
	arg_233_0.vars = nil
end

function HANDLER.pvplive_ban_info(arg_234_0, arg_234_1)
	if arg_234_1 == "btn_close" then
		ArenaNetLobbyBanInfo:close()
	end
end

ArenaNetLobbyBanInfo = {}

function ArenaNetLobbyBanInfo.showBanInfoPopup(arg_235_0)
	local var_235_0 = ArenaNetLobby.vars.lobby_info.global_ban_info
	
	if not var_235_0 then
		return 
	end
	
	local var_235_1 = var_235_0.units or {}
	local var_235_2 = var_235_0.artifacts or {}
	
	if table.empty(var_235_1) and table.empty(var_235_2) then
		return 
	end
	
	arg_235_0.vars = {}
	arg_235_0.vars.wnd = load_dlg("pvplive_ban_info", true, "wnd", function()
		ArenaNetLobbyBanInfo:close()
	end)
	arg_235_0.vars.listview = ItemListView_v2:bindControl(arg_235_0.vars.wnd:getChildByName("ListView"))
	
	local var_235_3 = {
		onUpdate = function(arg_237_0, arg_237_1, arg_237_2, arg_237_3)
			ArenaNetLobbyBanInfo:updateItemRender(arg_237_1, arg_237_3)
			
			return arg_237_3.id
		end
	}
	local var_235_4 = {}
	
	table.add(var_235_4, var_235_1)
	table.add(var_235_4, var_235_2)
	arg_235_0.vars.listview:setRenderer(load_control("wnd/pvplive_ban_info_item.csb"), var_235_3)
	arg_235_0.vars.listview:removeAllChildren()
	arg_235_0.vars.listview:setDataSource(var_235_4)
	arg_235_0.vars.listview:jumpToTop()
	SceneManager:getRunningPopupScene():addChild(arg_235_0.vars.wnd)
end

function ArenaNetLobbyBanInfo.updateItemRender(arg_238_0, arg_238_1, arg_238_2)
	if string.starts(arg_238_2.code, "c") then
		if_set_visible(arg_238_1, "mob_icon", true)
		if_set_visible(arg_238_1, "item_art_icon", false)
		if_set_visible(arg_238_1, "btn_arti", false)
		arg_238_1:getChildByName("mob_icon"):removeAllChildren()
		UIUtil:getRewardIcon(nil, arg_238_2.code, {
			no_count = true,
			no_frame = true,
			no_tooltip = true,
			parent = arg_238_1:getChildByName("mob_icon")
		})
		
		local var_238_0 = DB("character", arg_238_2.code, {
			"name"
		})
		
		if_set(arg_238_1, "t_name", T(var_238_0))
	else
		if_set_visible(arg_238_1, "mob_icon", false)
		if_set_visible(arg_238_1, "item_art_icon", true)
		if_set_visible(arg_238_1, "btn_arti", true)
		arg_238_1:getChildByName("item_art_icon"):removeAllChildren()
		UIUtil:getRewardIcon(nil, arg_238_2.code, {
			no_popup = true,
			no_tooltip = true,
			no_count = true,
			scale = 1,
			parent = arg_238_1:getChildByName("item_art_icon")
		})
		
		local var_238_1 = DB("equip_item", arg_238_2.code, {
			"name"
		})
		
		if_set(arg_238_1, "t_name", T(var_238_1))
		
		local var_238_2, var_238_3 = DB("equip_item", arg_238_2.code, {
			"name",
			"artifact_grade"
		})
		local var_238_4 = EQUIP:createByInfo({
			code = arg_238_2.code
		})
		
		WidgetUtils:setupPopup({
			control = arg_238_1:getChildByName("btn_arti"),
			creator = function()
				return ItemTooltip:getItemTooltip({
					show_max_check_box = true,
					artifact_popup = true,
					code = arg_238_2.code,
					grade = var_238_3,
					equip = var_238_4,
					equip_stat = var_238_4.stats
				})
			end
		})
	end
	
	if arg_238_2.infinite == 1 then
		if_set(arg_238_1, "t_time", T("arena_wa_global_ban_notime"))
	elseif arg_238_2.end_time - os.time() > 0 then
		if_set(arg_238_1, "t_time", T("arena_wa_global_ban_time", {
			time = sec_to_string(arg_238_2.end_time - os.time())
		}))
	else
		if_set(arg_238_1, "t_time", "-")
	end
end

function ArenaNetLobbyBanInfo.isVisible(arg_240_0)
	return arg_240_0.vars and arg_240_0.vars.wnd
end

function ArenaNetLobbyBanInfo.close(arg_241_0)
	BackButtonManager:pop("pvplive_ban_info")
	UIAction:Add(SEQ(LOG(SPAWN(FADE_OUT(150), SCALE(150, 1, 0))), REMOVE()), arg_241_0.vars.wnd, "block")
	
	arg_241_0.vars = nil
end

ArenaNetCreatePopup = {}

function HANDLER.pvplive_mod_card(arg_242_0, arg_242_1)
	if arg_242_1 == "btn_sel" then
		ArenaNetCreatePopup:select(arg_242_0)
	end
end

copy_functions(ScrollView, ArenaNetCreatePopup)

function ArenaNetCreatePopup.show(arg_243_0, arg_243_1)
	arg_243_1 = arg_243_1 or {}
	arg_243_0.vars = {}
	arg_243_0.vars.wnd = load_dlg("pvplive_lounge_creat", true, "wnd", function()
		arg_243_0:close()
	end)
	
	arg_243_0.vars.wnd:setVisible(true)
	
	arg_243_0.vars.mode = arg_243_1.mode
	arg_243_0.vars.rule = arg_243_1.rule or ARENA_NET_BATTLE_RULE.DRAFT
	arg_243_0.vars.check_box = arg_243_0.vars.wnd:getChildByName("check_box")
	arg_243_0.vars.title = arg_243_0.vars.wnd:getChildByName("txt_nickname")
	arg_243_0.vars.node_pw = arg_243_0.vars.wnd:getChildByName("n_pw_enter")
	arg_243_0.vars.text_pw = arg_243_0.vars.wnd:getChildByName("txt_password")
	arg_243_0.vars.allow_chat = arg_243_0.vars.wnd:getChildByName("btn_allow_select")
	arg_243_0.vars.disallow_chat = arg_243_0.vars.wnd:getChildByName("btn_disallow_select")
	
	arg_243_0.vars.title:setMaxLength(ARENA_TITLE_MAX_LEN)
	arg_243_0.vars.title:setMaxLengthEnabled(true)
	arg_243_0.vars.title:setCursorEnabled(true)
	arg_243_0.vars.text_pw:setCursorEnabled(true)
	arg_243_0.vars.title:setString(arg_243_1.title or "")
	arg_243_0.vars.check_box:setSelected(not arg_243_1.is_public)
	arg_243_0.vars.text_pw:setString(arg_243_1.password or "")
	arg_243_0.vars.allow_chat:setVisible(arg_243_1.is_enable_chat)
	arg_243_0.vars.disallow_chat:setVisible(not arg_243_1.is_enable_chat)
	
	arg_243_0.vars.callback = arg_243_1.callback
	arg_243_0.vars.selected_rule = arg_243_1.rule or ARENA_NET_BATTLE_RULE.DRAFT
	
	arg_243_0:loadRuleListView(arg_243_1.rule or ARENA_NET_BATTLE_RULE.DRAFT)
	if_set_visible(arg_243_0.vars.wnd, "btn_allow", true)
	if_set_visible(arg_243_0.vars.wnd, "btn_disallow", true)
	
	if arg_243_0.vars.mode == "CREATE" then
		if_set(arg_243_0.vars.wnd, "title", T("pvp_rta_mock_create_room"))
	else
		if_set(arg_243_0.vars.wnd, "title", T("pvp_rta_mock_change_room"))
	end
	
	arg_243_0:togglePassword()
	SceneManager:getRunningPopupScene():addChild(arg_243_0.vars.wnd)
end

function ArenaNetCreatePopup.select(arg_245_0, arg_245_1)
	if arg_245_0.vars.selected_rule == arg_245_1.rule then
		return 
	end
	
	for iter_245_0, iter_245_1 in pairs(arg_245_0.ScrollViewItems or {}) do
		arg_245_0.vars.selected_rule = arg_245_1.rule
		
		if_set_visible(iter_245_1.control, "select", iter_245_1.item.rule == arg_245_1.rule)
	end
end

function ArenaNetCreatePopup.loadRuleListView(arg_246_0)
	local var_246_0 = {
		{
			img = "pvplive_mod_04.png",
			rule = ARENA_NET_BATTLE_RULE.DRAFT
		},
		{
			img = "pvplive_mod_03.png",
			rule = ARENA_NET_BATTLE_RULE.E7WC2
		},
		{
			img = "pvplive_mod_02.png",
			rule = ARENA_NET_BATTLE_RULE.LIMIT_CLASS
		},
		{
			img = "pvplive_mod_01.png",
			rule = ARENA_NET_BATTLE_RULE.NORMAL
		}
	}
	
	arg_246_0.vars.scrollview = arg_246_0.vars.wnd:getChildByName("scrollview")
	
	arg_246_0:initScrollView(arg_246_0.vars.scrollview, 220, 220, {
		force_horizontal = true
	})
	arg_246_0:createScrollViewItems(var_246_0)
end

function ArenaNetCreatePopup.getScrollViewItem(arg_247_0, arg_247_1)
	local var_247_0 = load_dlg("pvplive_mod_card", true, "wnd")
	
	var_247_0:getChildByName("btn_sel").rule = arg_247_1.rule
	
	if_set(var_247_0, "txt_subtitle", getArenaRuleName(arg_247_1.rule))
	SpriteCache:resetSprite(var_247_0:getChildByName("img_mod_thumbnail"), "img/" .. arg_247_1.img)
	if_set_visible(var_247_0, "select", arg_247_1.rule == arg_247_0.vars.rule)
	
	return var_247_0
end

function ArenaNetCreatePopup.confirm(arg_248_0)
	local var_248_0 = arg_248_0.vars.title:getString()
	local var_248_1 = arg_248_0.vars.text_pw:getString()
	local var_248_2 = utf8len(var_248_0)
	local var_248_3 = string.trim(var_248_0)
	local var_248_4 = utf8len(var_248_3)
	local var_248_5 = utf8len(var_248_1)
	
	if check_abuse_filter(var_248_3, ABUSE_FILTER.WORLD_NAME) then
		balloon_message_with_sound("pvp_rta_mock_bad_title")
		
		return 
	end
	
	if UIUtil:checkInvalidCharacter(var_248_3, false, {
		allow_jamo = true,
		allow_ascii = true
	}) then
		balloon_message_with_sound("pvp_rta_mock_bad_title")
		
		return 
	end
	
	for iter_248_0 in string.gmatch("@#$%*?'\",.", ".") do
		if string.find(var_248_3, iter_248_0, 1, true) ~= nil then
			balloon_message_with_sound("pvp_rta_mock_bad_title")
			
			return 
		end
	end
	
	if var_248_2 ~= var_248_4 then
		balloon_message_with_sound("pvp_rta_mock_bad_title")
		
		return 
	end
	
	if var_248_4 < ARENA_TITLE_MIN_LEN then
		balloon_message_with_sound("pvp_rta_mock_bad_title2")
		
		return 
	end
	
	if var_248_4 > ARENA_TITLE_MAX_LEN then
		balloon_message_with_sound("pvp_rta_mock_text_limit")
		
		return 
	end
	
	if arg_248_0.vars.check_box:isSelected() then
		if var_248_5 == 0 then
			balloon_message_with_sound("pvp_rta_mock_input_pwd")
			
			return 
		elseif not tonumber(var_248_1) then
			balloon_message_with_sound("pvp_rta_mock_input_number_pwd")
			
			return 
		elseif var_248_5 ~= 4 then
			balloon_message_with_sound("pvp_rta_mock_input_4digits_pwd")
			
			return 
		end
	end
	
	if arg_248_0.vars.mode == "CREATE" then
		ArenaNetLobby:setLock(true)
		
		local var_248_6 = {
			title = arg_248_0.vars.title:getString(),
			rule = arg_248_0.vars.selected_rule,
			is_public = arg_248_0.vars.check_box:isSelected() and 0 or 1,
			is_enable_chat = arg_248_0.vars.allow_chat:isVisible() and 1 or 0,
			password = arg_248_0.vars.text_pw:getString()
		}
		
		MatchService:query("arena_net_create_lounge", var_248_6, function(arg_249_0)
			ArenaNetLobby:setLock(false)
			
			if arg_249_0.create_info and arg_249_0.create_info.create_success == 1 then
				arg_248_0:close()
				ArenaService:init(arg_249_0.create_info)
			elseif arg_249_0.create_info and arg_249_0.create_info.err_code then
				Dialog:msgBox(T(arg_249_0.create_info.err_code))
			else
				Log.e("arena_net_create_lounge fail")
			end
		end)
	else
		local var_248_7 = {
			title = arg_248_0.vars.title:getString(),
			rule = arg_248_0.vars.selected_rule,
			is_public = arg_248_0.vars.check_box:isSelected() and 0 or 1,
			is_enable_chat = arg_248_0.vars.allow_chat:isVisible() and 1 or 0,
			password = arg_248_0.vars.check_box:isSelected() and arg_248_0.vars.text_pw:getString() or nil
		}
		
		if arg_248_0.vars.callback then
			arg_248_0.vars.callback(var_248_7)
		end
		
		arg_248_0:close()
	end
end

function ArenaNetCreatePopup.close(arg_250_0)
	if not arg_250_0.vars then
		return 
	end
	
	BackButtonManager:pop("pvplive_lounge_creat")
	ArenaNetLobby:setLock(false)
	
	if get_cocos_refid(arg_250_0.vars.wnd) then
		UIAction:Add(SEQ(REMOVE()), arg_250_0.vars.wnd, "block")
	end
	
	arg_250_0.vars = nil
end

function ArenaNetCreatePopup.toggleAllowChat(arg_251_0, arg_251_1)
	if arg_251_1 == "btn_allow" then
		arg_251_0.vars.allow_chat:setVisible(true)
		arg_251_0.vars.disallow_chat:setVisible(false)
	else
		arg_251_0.vars.allow_chat:setVisible(false)
		arg_251_0.vars.disallow_chat:setVisible(true)
	end
end

function ArenaNetCreatePopup.togglePassword(arg_252_0)
	if arg_252_0.vars.check_box:isSelected() then
		arg_252_0.vars.node_pw:setOpacity(255)
		arg_252_0.vars.text_pw:setTouchEnabled(true)
	else
		arg_252_0.vars.node_pw:setOpacity(76.5)
		arg_252_0.vars.text_pw:setTouchEnabled(false)
		arg_252_0.vars.text_pw:setString("")
	end
end

ArenaNetPasswordPopup = {}

function ArenaNetPasswordPopup.show(arg_253_0, arg_253_1)
	if arg_253_0.vars then
		return 
	end
	
	arg_253_0.vars = {}
	arg_253_0.vars.wnd = load_dlg("pvplive_lounge_pw", true, "wnd", function()
		arg_253_0:close()
	end)
	
	arg_253_0.vars.wnd:setVisible(true)
	
	arg_253_0.vars.text_pw = arg_253_0.vars.wnd:getChildByName("txt_password")
	
	arg_253_0.vars.text_pw:setMaxLength(4)
	arg_253_0.vars.text_pw:setMaxLengthEnabled(true)
	arg_253_0.vars.text_pw:setCursorEnabled(true)
	
	arg_253_0.vars.finish_cb = arg_253_1
	
	SceneManager:getRunningPopupScene():addChild(arg_253_0.vars.wnd)
end

function ArenaNetPasswordPopup.confirm(arg_255_0)
	if UIAction:Find("join.block") then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	local var_255_0 = arg_255_0.vars.text_pw:getString()
	local var_255_1 = utf8len(var_255_0)
	
	if var_255_1 == 0 then
		balloon_message_with_sound("pvp_rta_mock_input_pwd")
		
		return 
	elseif not tonumber(var_255_0) then
		balloon_message_with_sound("pvp_rta_mock_input_number_pwd")
		
		return 
	elseif var_255_1 ~= 4 then
		balloon_message_with_sound("pvp_rta_mock_input_4digits_pwd")
		
		return 
	end
	
	arg_255_0.vars.finish_cb(var_255_0)
end

function ArenaNetPasswordPopup.close(arg_256_0)
	if not arg_256_0.vars then
		return 
	end
	
	BackButtonManager:pop("pvplive_lounge_pw")
	
	if get_cocos_refid(arg_256_0.vars.wnd) then
		UIAction:Add(SEQ(REMOVE()), arg_256_0.vars.wnd, "block")
	end
	
	arg_256_0.vars = nil
end

ArenaNetInvitePopup = {}

function make_cache_tm(arg_257_0, arg_257_1)
	local var_257_0 = {}
	
	for iter_257_0, iter_257_1 in pairs(arg_257_0) do
		var_257_0[iter_257_1.ad.id] = iter_257_1.ad.login_tm
	end
	
	for iter_257_2, iter_257_3 in pairs(arg_257_1) do
		var_257_0[iter_257_3.user_info.id] = math.max(var_257_0[iter_257_3.user_info.id] or 0, iter_257_3.user_info.login_tm or 0)
	end
	
	return var_257_0
end

function make_friend_comma_list(arg_258_0)
	local var_258_0 = ""
	
	for iter_258_0, iter_258_1 in pairs(arg_258_0) do
		local var_258_1 = iter_258_0 == 1 and "" or ","
		
		var_258_0 = var_258_0 .. var_258_1 .. tostring(iter_258_1.ad.id)
	end
	
	return var_258_0
end

function make_member_comma_list(arg_259_0)
	local var_259_0 = ""
	
	for iter_259_0, iter_259_1 in pairs(arg_259_0) do
		local var_259_1 = iter_259_0 == 1 and "" or ","
		
		var_259_0 = var_259_0 .. var_259_1 .. tostring(iter_259_1.user_info.id)
	end
	
	return var_259_0
end

function getFriendNoDataText(arg_260_0)
	if arg_260_0 == "FRIEND" then
		return T("pvp_rta_mimic_no_friend")
	elseif arg_260_0 == "KNIGHT" then
		return T("pvp_rta_mimic_no_clan")
	elseif arg_260_0 == "RECENT" then
		return T("pvp_rta_mimic_no_recent")
	elseif arg_260_0 == "SEARCH" then
		return T("pvp_rta_mock_no_results")
	end
end

ArenaNetInvitePopup.PAGE_COUNT = 10

function ArenaNetInvitePopup.show(arg_261_0, arg_261_1)
	arg_261_0.vars = {}
	arg_261_0.vars.wnd = load_dlg("pvplive_invite", true, "wnd", function()
		arg_261_0:close()
	end)
	arg_261_0.vars.user_id = ArenaService:getUserUID()
	arg_261_0.vars.user_info = ArenaNetLounge.vars.infos.users[arg_261_0.vars.user_id]
	
	arg_261_0:loadCommunityListView()
	arg_261_0:loadSorter()
	
	local var_261_0 = arg_261_0.vars.wnd:getChildByName("txt_title")
	
	UIUserData:call(var_261_0, "SINGLE_WSCALE(178)")
	
	arg_261_0.vars.search_text = arg_261_0.vars.wnd:getChildByName("txt_input")
	arg_261_0.vars.categories = {
		FRIEND = {},
		KNIGHT = {},
		RECENT = {},
		SEARCH = {}
	}
	arg_261_0.vars.friends = arg_261_1.friends
	arg_261_0.vars.members = arg_261_1.members
	arg_261_0.vars.recents = {}
	arg_261_0.vars.cache_tm = make_cache_tm(arg_261_0.vars.friends, arg_261_0.vars.members)
	
	local function var_261_1(arg_263_0)
		return arg_261_0.vars.wnd:getChildByName("n_tab" .. tostring(arg_263_0)):getChildByName("bg")
	end
	
	arg_261_0.vars.categories.FRIEND.tab = var_261_1(1)
	arg_261_0.vars.categories.KNIGHT.tab = var_261_1(2)
	arg_261_0.vars.categories.RECENT.tab = var_261_1(3)
	arg_261_0.vars.categories.SEARCH.tab = var_261_1(4)
	arg_261_0.vars.categories.FRIEND.root = "NORMAL"
	arg_261_0.vars.categories.KNIGHT.root = "NORMAL"
	arg_261_0.vars.categories.RECENT.root = "NORMAL"
	arg_261_0.vars.categories.SEARCH.root = "SEARCH"
	arg_261_0.vars.categories.FRIEND.query = "arena_net_enemy_info"
	arg_261_0.vars.categories.KNIGHT.query = "arena_net_enemy_info"
	arg_261_0.vars.categories.RECENT.query = "arena_net_recent_enemy"
	arg_261_0.vars.categories.SEARCH.query = nil
	arg_261_0.vars.categories.FRIEND.args = {
		user_id_comma = make_friend_comma_list(arg_261_0.vars.friends)
	}
	arg_261_0.vars.categories.KNIGHT.args = {
		user_id_comma = make_member_comma_list(arg_261_0.vars.members)
	}
	arg_261_0.vars.categories.RECENT.args = {
		user_id_comma = "dummy_string",
		count = arg_261_0.PAGE_COUNT
	}
	
	arg_261_0:setCategory("FRIEND")
	SceneManager:getRunningPopupScene():addChild(arg_261_0.vars.wnd)
end

function ArenaNetInvitePopup.close(arg_264_0)
	BackButtonManager:pop("pvplive_invite")
	arg_264_0.vars.wnd:removeFromParent()
	
	arg_264_0.vars = nil
end

function ArenaNetInvitePopup.loadCommunityListView(arg_265_0)
	arg_265_0.vars.rootNodes = {}
	arg_265_0.vars.itemViews = {}
	
	local var_265_0 = load_control("wnd/pvplive_invite_item.csb")
	local var_265_1 = {
		onUpdate = function(arg_266_0, arg_266_1, arg_266_2, arg_266_3)
			ArenaNetInvitePopup:updateItem(arg_266_1, arg_266_3)
			
			return arg_266_3.id
		end
	}
	
	for iter_265_0, iter_265_1 in pairs({
		"NORMAL",
		"SEARCH"
	}) do
		arg_265_0.vars.rootNodes[iter_265_1] = arg_265_0.vars.wnd:getChildByName("n_" .. string.lower(iter_265_1))
		
		local var_265_2 = arg_265_0.vars.rootNodes[iter_265_1]:getChildByName("ScrollView")
		
		if var_265_2.STRETCH_INFO then
			local var_265_3 = var_265_2:getContentSize()
			
			resetControlPosAndSize(var_265_0, var_265_3.width, var_265_2.STRETCH_INFO.width_prev)
		end
		
		arg_265_0.vars.itemViews[iter_265_1] = ItemListView_v2:bindControl(var_265_2)
		
		arg_265_0.vars.itemViews[iter_265_1]:setRenderer(var_265_0, var_265_1)
		arg_265_0.vars.itemViews[iter_265_1]:removeAllChildren()
		arg_265_0.vars.itemViews[iter_265_1]:setDataSource({})
	end
end

function ArenaNetInvitePopup.loadSorter(arg_267_0)
	local var_267_0 = {
		{
			region = "eu",
			world = "world_id_eu",
			order = 1,
			name = T("eu_server")
		},
		{
			region = "asia",
			world = "world_id_asia",
			order = 1,
			name = T("asia_server")
		},
		{
			region = "global",
			world = "world_id_global",
			order = 1,
			name = T("global_server")
		},
		{
			region = "kor",
			world = "world_id_kor",
			order = 1,
			name = T("kor_server")
		},
		{
			region = "jpn",
			world = "world_id_jpn",
			order = 1,
			name = T("jpn_server")
		}
	}
	local var_267_1 = {}
	
	if IS_PUBLISHER_ZLONG then
		for iter_267_0 = 1, 5 do
			local var_267_2 = "world_id_zlong" .. tostring(iter_267_0)
			
			if RegionIds[var_267_2] and RegionIds[var_267_2][1] and string.len(RegionIds[var_267_2][1]) > 5 then
				local var_267_3 = "zlong" .. tostring(iter_267_0) .. "_server"
				local var_267_4 = "zlong" .. tostring(iter_267_0)
				local var_267_5 = "world_id_zlong" .. tostring(iter_267_0)
				
				table.insert(var_267_1, {
					order = 1,
					name = T(var_267_3),
					region = var_267_4,
					world = var_267_5
				})
			end
		end
	else
		var_267_1 = var_267_0
	end
	
	for iter_267_1, iter_267_2 in pairs(var_267_1) do
		if iter_267_2.region == Login:getRegion() then
			iter_267_2.order = 0
			arg_267_0.vars.selected_world = iter_267_2.world
		end
	end
	
	table.sort(var_267_1, function(arg_268_0, arg_268_1)
		return arg_268_0.order < arg_268_1.order
	end)
	
	arg_267_0.vars.sorter = Sorter:create(arg_267_0.vars.wnd:getChildByName("n_sorting_1"), {
		csb_file = "wnd/sorting_1.csb",
		bg_width_x = 210
	})
	
	arg_267_0.vars.sorter:setSorter({
		default_sort_index = 1,
		menus = var_267_1,
		callback_sort = function(arg_269_0, arg_269_1)
			if var_267_1[arg_269_1] then
				arg_267_0.vars.selected_world = var_267_1[arg_269_1].world
			end
		end
	})
	
	if not table.empty(var_267_1) then
		arg_267_0.vars.sorter:sort()
	end
end

function ArenaNetInvitePopup.search(arg_270_0)
	local var_270_0 = arg_270_0.vars.search_text:getString()
	local var_270_1 = utf8len(var_270_0)
	
	if var_270_1 < 2 then
		balloon_message_with_sound("pvp_rta_mock_err_nickname")
		
		return 
	end
	
	if var_270_1 > 20 then
		return 
	end
	
	local var_270_2 = {
		search_world_id = RegionIds[arg_270_0.vars.selected_world][1],
		search_user_name = var_270_0
	}
	
	var_270_2.page_index = 0
	var_270_2.page_count = arg_270_0.PAGE_COUNT
	
	MatchService:query("arena_net_user_search", var_270_2, function(arg_271_0)
		if not arg_270_0.vars or not get_cocos_refid(arg_270_0.vars.wnd) then
			return 
		end
		
		if arg_270_0.vars.current ~= "SEARCH" then
			return 
		end
		
		local var_271_0 = arg_270_0.vars.itemViews.SEARCH
		local var_271_1 = arg_270_0:makeInfo("SEARCH", arg_271_0.users)
		
		var_271_0:setDataSource(var_271_1 or {})
		var_271_0:jumpToTop()
		var_271_0:forceDoLayout()
		
		if table.empty(var_271_1) then
			if_set_visible(arg_270_0.vars.wnd, "n_nodata", true)
			if_set(arg_270_0.vars.wnd, "txt_nodata", getFriendNoDataText("SEARCH"))
		else
			if_set_visible(arg_270_0.vars.wnd, "n_nodata", false)
		end
	end)
end

function ArenaNetInvitePopup.invite(arg_272_0, arg_272_1, arg_272_2)
	MatchService:inviteUser(arg_272_2, function(arg_273_0)
		if not get_cocos_refid(arg_272_1) then
			return 
		end
		
		if arg_273_0 then
			arg_272_1:setColor(cc.c3b(66, 66, 66))
		else
			arg_272_1:setColor(cc.c3b(255, 255, 255))
		end
	end)
end

function ArenaNetInvitePopup.setCategory(arg_274_0, arg_274_1)
	local function var_274_0(arg_275_0)
		table.sort(arg_275_0, function(arg_276_0, arg_276_1)
			local var_276_0 = math.max(arg_276_0.rank_info.updated or 0, arg_276_0.login_tm or 0)
			local var_276_1 = math.max(arg_276_1.rank_info.updated or 0, arg_276_1.login_tm or 0)
			local var_276_2 = arg_276_0.rank_info.score or arg_276_0.score or 0
			local var_276_3 = arg_276_1.rank_info.score or arg_276_1.score or 0
			
			if var_276_1 < var_276_0 then
				return true
			elseif var_276_0 < var_276_1 then
				return false
			elseif var_276_3 < var_276_2 then
				return true
			elseif var_276_2 < var_276_3 then
				return false
			else
				return arg_276_0.id < arg_276_1.id
			end
		end)
	end
	
	if not arg_274_0.vars.categories[arg_274_1] then
		Log.e("non category", arg_274_1)
		
		return 
	end
	
	if arg_274_0.vars.current == arg_274_1 then
		return 
	end
	
	if os.time() - (arg_274_0.last_send_time or 0) < 1 then
		return 
	else
		arg_274_0.last_send_time = os.time()
	end
	
	arg_274_0.vars.current = arg_274_1
	
	for iter_274_0, iter_274_1 in pairs(arg_274_0.vars.categories) do
		if iter_274_0 == arg_274_0.vars.current then
			iter_274_1.tab:setVisible(true)
			if_set_visible(arg_274_0.vars.wnd, "n_nodata", false)
			
			for iter_274_2, iter_274_3 in pairs({
				"NORMAL",
				"SEARCH"
			}) do
				arg_274_0.vars.rootNodes[iter_274_3]:setVisible(iter_274_3 == iter_274_1.root)
				arg_274_0.vars.itemViews[iter_274_3]:setVisible(iter_274_3 == iter_274_1.root)
			end
			
			local var_274_1 = arg_274_0.vars.itemViews[iter_274_1.root]
			
			if iter_274_1.query and string.len(iter_274_1.args.user_id_comma) > 0 then
				MatchService:query(iter_274_1.query, iter_274_1.args, function(arg_277_0)
					if not arg_274_0.vars or not get_cocos_refid(arg_274_0.vars.wnd) then
						return 
					end
					
					var_274_1:removeAllChildren()
					var_274_1:setDataSource({})
					var_274_1:setInnerContainerSize({
						height = 200,
						width = var_274_1:getInnerContainerSize().width
					})
					
					local var_277_0 = arg_274_0:makeInfo(iter_274_0, arg_277_0.enemy_info)
					
					if table.empty(var_277_0) then
						if_set_visible(arg_274_0.vars.wnd, "n_nodata", true)
						if_set(arg_274_0.vars.wnd, "txt_nodata", getFriendNoDataText(iter_274_0))
					else
						if_set_visible(arg_274_0.vars.wnd, "n_nodata", false)
						var_274_0(var_277_0)
						var_274_1:setDataSource(var_277_0)
					end
					
					var_274_1:jumpToTop()
					var_274_1:forceDoLayout()
				end)
			else
				var_274_1:removeAllChildren()
				var_274_1:setDataSource({})
				var_274_1:setInnerContainerSize({
					height = 200,
					width = var_274_1:getInnerContainerSize().width
				})
				var_274_1:jumpToTop()
				var_274_1:forceDoLayout()
				if_set_visible(arg_274_0.vars.wnd, "n_nodata", true)
				if_set(arg_274_0.vars.wnd, "txt_nodata", getFriendNoDataText(iter_274_0))
			end
		else
			iter_274_1.tab:setVisible(false)
		end
	end
end

function ArenaNetInvitePopup.makeInfo(arg_278_0, arg_278_1, arg_278_2)
	local var_278_0 = {}
	
	if arg_278_1 == "FRIEND" then
		for iter_278_0, iter_278_1 in pairs(arg_278_0.vars.friends) do
			local var_278_1 = iter_278_1.ad
			
			var_278_1.rank_info = arg_278_2[var_278_1.id] or {}
			var_278_1.rank_info.world = arg_278_0.vars.user_info.world
			
			table.insert(var_278_0, var_278_1)
			
			arg_278_0.vars.cache_tm[var_278_1.id] = math.max(var_278_1.rank_info.updated or 0, var_278_1.login_tm or 0)
		end
	elseif arg_278_1 == "KNIGHT" then
		for iter_278_2, iter_278_3 in pairs(arg_278_0.vars.members) do
			local var_278_2 = iter_278_3.user_info
			
			if var_278_2.id ~= Account:getUserId() then
				var_278_2.rank_info = arg_278_2[var_278_2.id] or {}
				var_278_2.rank_info.world = arg_278_0.vars.user_info.world
				
				table.insert(var_278_0, var_278_2)
				
				arg_278_0.vars.cache_tm[var_278_2.id] = math.max(var_278_2.rank_info.updated or 0, var_278_2.login_tm or 0)
			end
		end
	elseif arg_278_1 == "RECENT" then
		for iter_278_4, iter_278_5 in pairs(arg_278_2 or {}) do
			local var_278_3 = {
				id = iter_278_5.user_id,
				rank_info = iter_278_5
			}
			
			if arg_278_0.vars.cache_tm[var_278_3.id] then
				var_278_3.rank_info.updated = arg_278_0.vars.cache_tm[var_278_3.id]
			end
			
			table.insert(var_278_0, var_278_3)
		end
	elseif arg_278_1 == "SEARCH" then
		for iter_278_6, iter_278_7 in pairs(arg_278_2 or {}) do
			if Account:getUserId() ~= iter_278_7.id then
				local var_278_4 = {
					id = iter_278_7.id,
					rank_info = iter_278_7
				}
				
				var_278_4.rank_info.league_id = var_278_4.rank_info.league
				var_278_4.rank_info.world = var_278_4.rank_info.world_id
				var_278_4.rank_info.updated = var_278_4.rank_info.login_tm
				
				if arg_278_0.vars.cache_tm[var_278_4.id] then
					var_278_4.rank_info.updated = arg_278_0.vars.cache_tm[var_278_4.id]
				end
				
				table.insert(var_278_0, var_278_4)
			end
		end
	end
	
	return var_278_0
end

function ArenaNetInvitePopup.updateItem(arg_279_0, arg_279_1, arg_279_2)
	local var_279_0 = {
		id = arg_279_2.id,
		name = arg_279_2.rank_info.name or arg_279_2.name,
		world = arg_279_2.rank_info.world or arg_279_2.world,
		level = arg_279_2.rank_info.level or arg_279_2.level,
		leader_code = arg_279_2.rank_info.leader_code or arg_279_2.leader_code,
		border_code = arg_279_2.rank_info.border_code or arg_279_2.border_code,
		login_tm = math.max(arg_279_2.rank_info.updated or 0, arg_279_2.login_tm or 0),
		league_id = arg_279_2.rank_info.league_id or arg_279_2.league_id,
		score = arg_279_2.rank_info.score or arg_279_2.score,
		win = arg_279_2.rank_info.win or arg_279_2.win or 0,
		draw = arg_279_2.rank_info.draw or arg_279_2.draw or 0,
		lose = arg_279_2.rank_info.lose or arg_279_2.lose or 0,
		is_batching = (var_279_0.win or 0) + (var_279_0.draw or 0) + (var_279_0.lose or 0) < ARENA_MATCH_BATCH_COUNT
	}
	
	if arg_279_2.rank_info.is_draft == 1 then
		var_279_0.is_batching = true
	elseif arg_279_2.rank_info.is_draft == 0 then
		var_279_0.is_batching = false
	end
	
	local var_279_1 = arg_279_1:getChildByName("btn_battle")
	
	var_279_1.info = var_279_0
	
	if ArenaService:isInInviteList(var_279_0.id) then
		var_279_1:setColor(cc.c3b(66, 66, 66))
	else
		var_279_1:setColor(cc.c3b(255, 255, 255))
	end
	
	if_set(arg_279_1, "txt_name", var_279_0.name)
	
	if arg_279_0.vars.current == "FRIEND" or arg_279_0.vars.current == "KNIGHT" then
		if_set_visible(arg_279_1, "icon_menu_global", false)
		if_set(arg_279_1, "txt_nation", "")
	else
		if_set_visible(arg_279_1, "icon_menu_global", true)
		if_set(arg_279_1, "txt_nation", getRegionText(var_279_0.world or arg_279_0.vars.user_info.world))
	end
	
	UIUserData:call(arg_279_1:getChildByName("txt_name"), "SINGLE_WSCALE(140)", {
		origin_scale_x = 0.82
	})
	
	if var_279_0.login_tm > 0 then
		if_set(arg_279_1, "last_time", T("time_before", {
			time = sec_to_string(os.time() - var_279_0.login_tm, nil, {
				login_tm = true
			})
		}))
	else
		if_set(arg_279_1, "last_time", T("have_not_connection_info"))
	end
	
	local var_279_2, var_279_3 = UIUtil:getTextWidthAndPos(arg_279_1, "txt_name")
	local var_279_4 = arg_279_1:getChildByName("txt_name")
	local var_279_5 = arg_279_1:getChildByName("icon_menu_global")
	local var_279_6 = arg_279_1:getChildByName("txt_nation")
	
	var_279_5:setPositionX(var_279_3 + (var_279_2 + 18))
	var_279_6:setPositionX(var_279_3 + (var_279_2 + 33))
	UIUtil:setLevel(arg_279_1:getChildByName("n_lv"), var_279_0.level, MAX_ACCOUNT_LEVEL, 2)
	UIUtil:getUserIcon(var_279_0.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_279_1:getChildByName("mob_icon"),
		border_code = var_279_0.border_code
	})
	
	if not var_279_0.is_batching and var_279_0.league_id and var_279_0.score then
		local var_279_7, var_279_8 = getArenaNetRankInfo(ArenaService:getSeasonId(), var_279_0.league_id)
		
		if_set(arg_279_1, "txt_user_rank", T(var_279_7))
		if_set(arg_279_1, "txt_rating", T("pvp_point", {
			point = comma_value(var_279_0.score)
		}))
		SpriteCache:resetSprite(arg_279_1:getChildByName("icon_league"), "emblem/" .. var_279_8 .. ".png")
	else
		if_set(arg_279_1, "txt_user_rank", T(ARENA_UNRANK_TEXT))
		if_set(arg_279_1, "txt_rating", "")
		SpriteCache:resetSprite(arg_279_1:getChildByName("icon_league"), "emblem/" .. ARENA_UNRANK_ICON)
	end
end

ArenaNetBanListPopup = {}

function HANDLER.pvplive_preban_hero(arg_280_0, arg_280_1)
	if arg_280_1 == "btn_close" then
		ArenaNetBanListPopup:close()
	end
end

function ArenaNetBanListPopup.show(arg_281_0, arg_281_1, arg_281_2)
	arg_281_0.vars = {}
	arg_281_0.vars.wnd = load_dlg("pvplive_preban_hero", true, "wnd", function()
		ArenaNetBanListPopup:close()
	end)
	arg_281_0.vars.window_box = arg_281_0.vars.wnd:getChildByName("cm_tooltipbox")
	arg_281_0.vars.bar = arg_281_0.vars.window_box:getChildByName("bar")
	arg_281_0.vars.preban_text_group = arg_281_0.vars.window_box:getChildByName("n_pre_ben")
	arg_281_0.vars.list_pivot = {}
	
	for iter_281_0 = 1, 7 do
		table.insert(arg_281_0.vars.list_pivot, arg_281_0.vars.window_box:getChildByName("n_" .. tostring(iter_281_0)))
	end
	
	ArenaNetBanListPopup:setPopupSize(arg_281_1.round_info.total)
	ArenaNetBanListPopup:createBanList(arg_281_1, arg_281_2)
	SceneManager:getRunningPopupScene():addChild(arg_281_0.vars.wnd)
end

function ArenaNetBanListPopup.setPopupSize(arg_283_0, arg_283_1)
	local var_283_0 = arg_283_0.vars.window_box:getContentSize()
	local var_283_1 = 0
	
	if arg_283_1 == 7 then
		var_283_1 = 324
	elseif arg_283_1 == 5 then
		var_283_1 = 162
	end
	
	if var_283_1 ~= 0 then
		arg_283_0.vars.window_box:setContentSize({
			width = var_283_0.width,
			height = var_283_0.height + var_283_1
		})
		if_set_add_position_y(arg_283_0.vars.window_box, nil, var_283_1 * 0.5)
		if_set_add_position_y(arg_283_0.vars.bar, nil, var_283_1)
		if_set_add_position_y(arg_283_0.vars.preban_text_group, nil, var_283_1)
		
		for iter_283_0 = 1, table.count(arg_283_0.vars.list_pivot) do
			if_set_add_position_y(arg_283_0.vars.list_pivot[iter_283_0], nil, var_283_1)
		end
	end
end

function ArenaNetBanListPopup.createBanList(arg_284_0, arg_284_1, arg_284_2)
	local var_284_0 = arg_284_1.round_info.total
	local var_284_1 = arg_284_1.round_info
	local var_284_2 = arg_284_1.user_info.uid
	local var_284_3 = arg_284_1.enemy_user_info.uid
	
	for iter_284_0 = 1, var_284_0 do
		local var_284_4 = load_dlg("pvplive_preban_hero_item", true, "wnd")
		
		if get_cocos_refid(var_284_4) then
			var_284_4:setAnchorPoint(0, 0)
			arg_284_0.vars.list_pivot[iter_284_0]:addChild(var_284_4)
			var_284_4:setPosition(0, 0)
			
			local var_284_5 = var_284_4:getChildByName("t_round")
			local var_284_6 = "pvp_rta_round" .. tostring(iter_284_0)
			
			if_set(var_284_5, nil, T(var_284_6))
			
			local var_284_7 = var_284_1.rounds[iter_284_0]
			
			if var_284_7 then
				if var_284_7.state == "benefit" then
					ArenaNetBanListPopup.setRoundData(arg_284_0, var_284_4, nil, nil, false)
				elseif var_284_7.state == "finish" then
					local var_284_8 = var_284_7.preban[var_284_2]
					local var_284_9 = var_284_7.preban[var_284_3]
					
					ArenaNetBanListPopup.setRoundData(arg_284_0, var_284_4, var_284_8, var_284_9)
				elseif var_284_7.state == "running" then
					local var_284_10 = arg_284_2[var_284_2]
					local var_284_11 = arg_284_2[var_284_3]
					
					ArenaNetBanListPopup.setRoundData(arg_284_0, var_284_4, var_284_10, var_284_11)
				end
			else
				ArenaNetBanListPopup.setRoundData(arg_284_0, var_284_4, nil, nil, true)
			end
		end
	end
end

function ArenaNetBanListPopup.setRoundData(arg_285_0, arg_285_1, arg_285_2, arg_285_3, arg_285_4)
	local var_285_0 = arg_285_1:getChildByName("t_round")
	local var_285_1 = arg_285_1:getChildByName("t_pre")
	
	if arg_285_4 then
		if_set_opacity(var_285_0, nil, 76.5)
		if_set(var_285_1, nil, T("pvp_rta_doit"))
		var_285_1:setVisible(true)
		
		return 
	end
	
	local var_285_2 = false
	
	if not arg_285_2 or not arg_285_3 then
		var_285_2 = true
	elseif table.count(arg_285_2) == 0 then
		var_285_2 = true
	end
	
	local var_285_5, var_285_7
	
	if var_285_2 then
		if_set(var_285_1, nil, T("pvp_rta_no_information"))
		var_285_1:setVisible(true)
	else
		var_285_1:setVisible(false)
		
		local var_285_3 = table.count(arg_285_2) >= 2 and 2 or 1
		local var_285_4 = arg_285_1:getChildByName("player1")
		
		var_285_5 = arg_285_1:getChildByName("player2")
		
		for iter_285_0 = 1, table.count(arg_285_2) do
			local var_285_6 = var_285_4:getChildByName("mob_icon" .. tostring(var_285_3))
			
			UIUtil:getUserIcon(arg_285_2[iter_285_0].code, {
				no_popup = true,
				name = false,
				no_role = true,
				no_lv = true,
				scale = 1,
				no_grade = true,
				parent = var_285_6
			})
			
			var_285_3 = var_285_3 + 1
		end
		
		var_285_7 = table.count(arg_285_3) >= 2 and 2 or 1
		
		for iter_285_1 = 1, table.count(arg_285_3) do
			local var_285_8 = var_285_5:getChildByName("mob_icon" .. tostring(var_285_7))
			
			UIUtil:getUserIcon(arg_285_3[iter_285_1].code, {
				no_popup = true,
				name = false,
				no_role = true,
				no_lv = true,
				scale = 1,
				no_grade = true,
				parent = var_285_8
			})
			
			var_285_7 = var_285_7 + 1
		end
	end
end

function ArenaNetBanListPopup.close(arg_286_0)
	BackButtonManager:pop("pvplive_preban_hero")
	arg_286_0.vars.wnd:removeFromParent()
	
	arg_286_0.vars = nil
end
