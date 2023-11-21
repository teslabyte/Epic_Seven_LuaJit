ArenaService = {}
MatchService = {}
ARENA_MATCH_SCHEDULER = "ARENA_MATCH_SCHEDULER"
ARENA_MATCH_INTERVAL = 1000
ARENA_MATCH_MIN_LEVEL = 60
ARENA_MATCH_BATCH_COUNT = 10
ARENA_UNRANK_RATE = "-"
ARENA_UNRANK_TEXT = "pvp_rta_placing"
ARENA_UNRANK_ICON = "icon_pvp_sa_league_place.png"
PING_TIMEOUT_WARN = 1500
PING_TIMEOUT_ERROR = 3000
ARENA_NET_TRANS_SCHEDULER = "ARENA_NET_TRANS_SCHEDULE"
ARENA_NET_LOUNGE_SCHEDULER = "ARENA_NET_LOUNGE_SCHEDULE"
ARENA_NET_ROUND_NEXT_SCHEDULER = "ARENA_NET_ROUND_NEXT_SCHEDULER"
ARENA_NET_READY_SCHEDULER = "ARENA_NET_READY_SCHEDULE"
ARENA_NET_BATTLE_SCHEDULER = "ARENA_NET_BATTLE_SCHEDULE"
ARENA_NET_BATTLE_READY = "send_ready"
ARENA_NET_LOCAL_TIMEOUT = 100
ARENA_NET_TRANS_TIMEOUT = 40
ARENA_NET_REQUEST_TIMEOUT = 300
ARENA_NET_INVITE_INTERVAL = 10
ARENA_NET_BATTLE_MIN_ROLE_COUNT = 5
ARENA_NET_BATTLE_CANDIDATE_MIN_PICK_UNIT = 30
ARENA_NET_REQUEST = {}
ARENA_NET_REQUEST.REQUEST = 1
ARENA_NET_REQUEST.SUCCESS = 2
ARENA_NET_REQUEST.FAIL = 0
ARENA_NET_BATTLE_RULE = {}
ARENA_NET_BATTLE_RULE.NORMAL = 1
ARENA_NET_BATTLE_RULE.LIMIT_CLASS = 2
ARENA_NET_BATTLE_RULE.E7WC = 3
ARENA_NET_BATTLE_RULE.E7WC2 = 4
ARENA_NET_BATTLE_RULE.DRAFT = 5
CON_ERR = {}
CON_ERR.LOCAL_COUNT = 401
CON_ERR.NO_ROOM = 402
CON_ERR.INVALID = 403
CON_ERR.FINISHED = 404
CON_ERR.CLOSED = 405
CON_ERR.LUA_ERROR = 406
CON_ERR.UNKNOWN = 407
INVITE_REJECT_REASON = {}
INVITE_REJECT_REASON.NORMAL = 0
INVITE_REJECT_REASON.CONTENT_DISABLE = 1
INVITE_REJECT_REASON.NOT_ENOUGH_HERO = 2
INVITE_REJECT_REASON.USER_RANK = 3
INVITE_REJECT_REASON.USER_NOT_ALLOWED_SCENE = 4

function generateErrCode(arg_1_0)
	if not arg_1_0 then
		return ""
	end
	
	return (string.format(" (code:%d)", arg_1_0))
end

RegionIds = {}

local var_0_0 = {
	world_id_kor = "rta_server_kor",
	world_id_zlong3 = "zlong3_server",
	world_id_jpn = "rta_server_japan",
	world_id_global = "rta_server_global",
	world_id_zlong5 = "zlong5_server",
	world_id_zlong2 = "zlong2_server",
	world_id_asia = "rta_server_asia",
	world_id_zlong4 = "zlong4_server",
	world_id_zlong1 = "zlong1_server",
	world_id_eu = "rta_server_europe"
}
local var_0_1 = {
	jpn = "world_id_jpn",
	zlong3 = "world_id_zlong3",
	zlong5 = "world_id_zlong5",
	zlong4 = "world_id_zlong4",
	zlong1 = "world_id_zlong1",
	global = "world_id_global",
	zlong2 = "world_id_zlong2",
	asia = "world_id_asia",
	eu = "world_id_eu",
	kor = "world_id_kor"
}

function getRegionText(arg_2_0)
	arg_2_0 = arg_2_0 or ""
	
	for iter_2_0, iter_2_1 in pairs(RegionIds) do
		for iter_2_2, iter_2_3 in pairs(iter_2_1) do
			if arg_2_0 == iter_2_3 then
				return T(var_0_0[iter_2_0])
			end
		end
	end
	
	for iter_2_4, iter_2_5 in pairs(var_0_1) do
		if string.find(arg_2_0, iter_2_4) then
			return T(var_0_0[iter_2_5])
		end
	end
	
	return "default"
end

function updateRegionIds(arg_3_0)
	if not arg_3_0 then
		return 
	end
	
	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_0 = string.split(arg_3_0[iter_3_1], ",")
		
		RegionIds[iter_3_1] = {}
		
		if var_3_0 then
			for iter_3_2, iter_3_3 in pairs(var_3_0) do
				table.insert(RegionIds[iter_3_1], iter_3_3)
			end
		end
	end
end

function getNetCondition(arg_4_0)
	if arg_4_0 >= PING_TIMEOUT_ERROR then
		return 1
	elseif arg_4_0 >= PING_TIMEOUT_WARN then
		return 2
	else
		return 3
	end
end

function getArenaNetSeasonId()
	local var_5_0
	
	if AccountData.world_arena_season_schedule then
		for iter_5_0, iter_5_1 in pairs(AccountData.world_arena_season_schedule) do
			if iter_5_1.id and iter_5_1.start_time and iter_5_1.end_time then
				var_5_0 = iter_5_1.id
				
				if os.time() >= iter_5_1.start_time and os.time() <= iter_5_1.end_time then
					return iter_5_1.id
				end
			end
		end
	else
		Log.e("world_arena_season_schedule : no data")
	end
	
	Log.i("world arena season id", var_5_0)
	
	return var_5_0
end

function getArenaRuleName(arg_6_0)
	local var_6_0
	local var_6_1 = arg_6_0 == ARENA_NET_BATTLE_RULE.NORMAL and "pvp_rta_battle_rule1_name" or arg_6_0 == ARENA_NET_BATTLE_RULE.LIMIT_CLASS and "pvp_rta_battle_rule2_name" or not (arg_6_0 ~= ARENA_NET_BATTLE_RULE.E7WC and arg_6_0 ~= ARENA_NET_BATTLE_RULE.E7WC2) and "pvp_rta_battle_rule3_name" or arg_6_0 == ARENA_NET_BATTLE_RULE.DRAFT and "pvp_rta_battle_rule4_name" or "unknown"
	
	return T(var_6_1)
end

function getArenaNetRankInfo(arg_7_0, arg_7_1)
	arg_7_0 = arg_7_0 or getArenaNetSeasonId()
	
	if arg_7_1 then
		if arg_7_0 then
			local var_7_0 = string.split(arg_7_0, "_")[3] .. "_" .. arg_7_1
			local var_7_1, var_7_2, var_7_3 = DB("pvp_rta_basic", var_7_0, {
				"league_name",
				"emblem",
				"rankup_point"
			})
			
			return var_7_1, var_7_2, var_7_3
		else
			local var_7_4, var_7_5, var_7_6 = DB("pvp_rta", arg_7_1, {
				"league_name",
				"emblem",
				"rankup_point"
			})
			
			return var_7_4, var_7_5, var_7_6
		end
	end
end

function checkCanStartMatch(arg_8_0)
	local function var_8_0()
		local var_9_0 = Account:getUnits()
		local var_9_1 = {}
		local var_9_2 = {}
		local var_9_3 = {}
		
		for iter_9_0, iter_9_1 in pairs(var_9_0) do
			if iter_9_1 and not var_9_1[iter_9_1.db.code] and not var_9_2[iter_9_1.db.set_group] and iter_9_1:isOrganizable() and not ArenaService:isInGlobalBanUnit(iter_9_1) and not ArenaService:isInGlobalBanArtifact(iter_9_1) and not ArenaService:isInGlobalBanExclusive(iter_9_1) then
				var_9_1[iter_9_1.db.code] = true
				
				if iter_9_1.db.set_group then
					var_9_2[iter_9_1.db.set_group] = true
				end
				
				var_9_3[iter_9_1.db.role] = var_9_3[iter_9_1.db.role] or 0
				var_9_3[iter_9_1.db.role] = var_9_3[iter_9_1.db.role] + 1
			end
		end
		
		for iter_9_2, iter_9_3 in pairs({
			"knight",
			"mage",
			"assassin",
			"warrior",
			"ranger",
			"manauser"
		}) do
			if (var_9_3[iter_9_3] or 0) < ARENA_NET_BATTLE_MIN_ROLE_COUNT then
				return false
			end
		end
		
		return true
	end
	
	if Account:getLevel() < ARENA_MATCH_MIN_LEVEL then
		return false, INVITE_REJECT_REASON.USER_RANK
	end
	
	if not var_8_0() then
		return false, INVITE_REJECT_REASON.NOT_ENOUGH_HERO
	end
	
	return true, nil
end

function joinLoungeErrorMsg(arg_10_0)
	if string.starts(arg_10_0, "max_user") then
		Dialog:msgBox(T("pvp_rta_mock_full_room"))
	elseif string.starts(arg_10_0, "kick_user") then
		Dialog:msgBox(T("pvp_rta_mock_retry_room"))
	elseif string.starts(arg_10_0, "finish") or string.starts(arg_10_0, "invalid_lounge_id") then
		Dialog:msgBox(T("pvp_rta_mock_end_room"))
	elseif string.starts(arg_10_0, "invalid_password") then
		balloon_message_with_sound("pvp_rta_mock_retry_pwd")
	elseif string.starts(arg_10_0, "already_lounge") then
		Dialog:msgBox(T("pvp_rta_mock_already_in"))
	elseif string.starts(arg_10_0, "no_lounge") then
		Dialog:msgBox(T("pvp_rta_mock_end_room"))
	end
end

function clanNameFilter(arg_11_0)
	if not arg_11_0 then
		return ""
	end
	
	return check_abuse_filter(arg_11_0, ABUSE_FILTER.WORLD_NAME) or arg_11_0 or ""
end

function MatchService.init(arg_12_0)
	if not arg_12_0.match_queue then
		arg_12_0.match_queue = Queue.new()
	end
end

function diff_check(arg_13_0, arg_13_1)
	local var_13_0 = false
	
	arg_13_0 = arg_13_0 or {}
	arg_13_1 = arg_13_1 or {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		if type(arg_13_1[iter_13_0]) == "table" then
			var_13_0 = var_13_0 or diff_check(arg_13_0[iter_13_0], arg_13_1[iter_13_0])
		elseif arg_13_0[iter_13_0] ~= arg_13_1[iter_13_0] then
			var_13_0 = true
			
			break
		end
	end
	
	return var_13_0
end

function file_drop(arg_14_0)
	if not arg_14_0 then
		balloon_message("no file data")
		
		return 
	end
	
	local function var_14_0(arg_15_0)
		local var_15_0 = arg_15_0:seek()
		local var_15_1 = arg_15_0:seek("end")
		
		arg_15_0:seek("set", var_15_0)
		
		return var_15_1
	end
	
	reload_db()
	
	local var_14_1 = io.open(arg_14_0, "rb")
	
	if var_14_1 then
		local var_14_2 = var_14_0(var_14_1)
		local var_14_3 = var_14_1:read("*a")
		local var_14_4 = lz4_uncompress(var_14_3)
		local var_14_5 = json.decode(var_14_4)
		
		if var_14_5 then
			BattleViewer:playAIReplay(var_14_5)
		end
	end
end

function makePrebanNodes(arg_16_0, arg_16_1)
	local var_16_0 = {}
	local var_16_1 = table.count(arg_16_1 or {})
	local var_16_2
	
	if var_16_1 == 0 then
		return 
	else
		var_16_2 = 1
		
		for iter_16_0 = var_16_1, math.max(1, var_16_1 - 5), -1 do
			table.insert(var_16_0, {
				name = "n_" .. tostring(var_16_2),
				code = arg_16_1[iter_16_0].code
			})
			
			var_16_2 = var_16_2 + 1
		end
	end
	
	return var_16_0
end

function updatePrebanNodes(arg_17_0, arg_17_1, arg_17_2)
	for iter_17_0, iter_17_1 in pairs(arg_17_1 or {}) do
		local var_17_0 = arg_17_0:getChildByName(iter_17_1.name)
		
		if var_17_0 and iter_17_1.code then
			UIUtil:getUserIcon(iter_17_1.code, {
				no_popup = true,
				name = false,
				no_role = true,
				no_lv = true,
				scale = 1,
				no_grade = true,
				parent = var_17_0
			})
		end
	end
	
	if arg_17_2 then
		for iter_17_2, iter_17_3 in pairs({
			"n_1",
			"n_2",
			"n_3",
			"n_4",
			"n_5"
		}) do
			local var_17_1 = table.find(arg_17_1, function(arg_18_0, arg_18_1)
				return iter_17_3 == arg_18_1.name
			end)
			
			if_set_visible(arg_17_0, iter_17_3, var_17_1)
		end
	end
end

function makeDraftTest(arg_19_0)
	if not arg_19_0 then
		Log.e("with call 1 arguments: find_unit_uid")
		
		return 
	end
	
	BattleLogic:makeDraftPool("ABC", "DEF", nil, arg_19_0)
end

function MatchService.clear(arg_20_0)
	arg_20_0.arena_uid = nil
	arg_20_0.match_queue = nil
	arg_20_0.match_uri = nil
	
	Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
end

function MatchService.setArenaUID(arg_21_0, arg_21_1)
	arg_21_0.arena_uid = arg_21_1
end

function MatchService.getArenaUID(arg_22_0)
	return arg_22_0.arena_uid
end

function MatchService.setUri(arg_23_0, arg_23_1)
	arg_23_0.match_uri = arg_23_1
end

function MatchService.getUri(arg_24_0)
	return arg_24_0.match_uri
end

function MatchService.inviteUser(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = ArenaService:getUserInfo()
	
	if var_25_0.uid ~= ArenaService:getHost() then
		balloon_message_with_sound("pvp_rta_mock_not_have_authority")
		
		return 
	end
	
	if arg_25_1.level < ARENA_MATCH_MIN_LEVEL then
		balloon_message_with_sound("pvp_rta_notenough_rank")
		
		return 
	end
	
	if ArenaNetChat:isMaxUser() then
		balloon_message_with_sound("pvp_rta_mock_no_more_invite")
		
		return 
	end
	
	if ArenaService:isInInviteList(arg_25_1.id) then
		balloon_message_with_sound("pvp_rta_mock_invite_wait")
		
		return 
	end
	
	local var_25_1 = {
		lounge_id = ArenaService:getRoomKey(),
		enemy_user_id = arg_25_1.id,
		enemy_user_world = arg_25_1.world or var_25_0.world
	}
	
	ArenaService:addInviteList(arg_25_1.id, arg_25_2)
	MatchService:query("arena_net_invite_ask", var_25_1, function(arg_26_0)
		if arg_26_0 and arg_26_0.result then
			if arg_26_0.result.result == 1 then
				if arg_25_2 then
					arg_25_2(true)
				end
			else
				ArenaService:removeInviteList(arg_25_1.id)
				balloon_message_with_sound("pvp_rta_mock_cannot_accept_invite")
				
				if arg_25_2 then
					arg_25_2(false)
				end
			end
		end
	end)
end

function MatchService.isProgress(arg_27_0)
	return arg_27_0.match_queue and not Queue.empty(arg_27_0.match_queue)
end

function MatchService.query(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	arg_28_4 = arg_28_4 or {}
	arg_28_4.retry = 2
	arg_28_4.read_timeout = 5000
	arg_28_2 = arg_28_2 or {}
	arg_28_2.arena_uid = arg_28_0.arena_uid
	
	if not arg_28_0.match_queue then
		return false
	end
	
	local var_28_0 = not Queue.empty(arg_28_0.match_queue)
	
	if var_28_0 and not arg_28_4.immediate and Queue.exist(arg_28_0.match_queue, function(arg_29_0)
		return arg_29_0.cmd == arg_28_1
	end) then
		return false
	end
	
	Queue.push(arg_28_0.match_queue, {
		cmd = arg_28_1,
		params = arg_28_2,
		callback = arg_28_3,
		opts = arg_28_4
	})
	
	if not var_28_0 then
		arg_28_0:send()
		
		return true
	end
	
	return false
end

function MatchService.send(arg_30_0)
	local var_30_0 = Queue.top(arg_30_0.match_queue)
	
	if not var_30_0 then
		return 
	end
	
	Net:direct_query(var_30_0.cmd, var_30_0.params, {
		no_qctl = true,
		uri = arg_30_0.match_uri,
		read_timeout = var_30_0.opts.read_timeout,
		callback = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			arg_30_0:done(arg_31_0, var_30_0, arg_31_2, arg_31_3)
		end
	})
end

function MatchService.done(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	if not arg_32_0.match_queue then
		MatchService:clear()
		
		return 
	end
	
	if not arg_32_1 or arg_32_4 ~= 0 then
		if arg_32_2.opts and arg_32_2.opts.retry and arg_32_2.opts.retry > 0 then
			arg_32_2.opts.retry = arg_32_2.opts.retry - 1
			
			MatchService:send()
			
			return 
		end
		
		MatchService:clear()
		UIAction:Remove("block")
		Dialog:msgBox(T("game_connect_lost"), {
			handler = function()
				SceneManager:nextScene("lobby")
				SceneManager:resetSceneFlow()
			end
		})
		
		return 
	end
	
	if arg_32_1.err then
		if arg_32_1.next_scene then
			MatchService:clear()
			UIAction:Remove("block")
			Dialog:msgBox(T(arg_32_1.err or "game_connect_lost"), {
				handler = function()
					SceneManager:nextScene(arg_32_1.next_scene or "lobby")
					SceneManager:resetSceneFlow()
				end
			})
		else
			if string.starts(arg_32_1.err, "session") then
				Scheduler:removeByName(ARENA_MATCH_SCHEDULER)
				
				if not get_cocos_refid(arg_32_0.session_msg_box) then
					arg_32_0:clear()
					
					arg_32_0.session_msg_box = Dialog:msgBox(T("session_error_desc"), {
						handler = function()
							restart_contents()
						end
					})
				end
			else
				Dialog:msgBox(T(arg_32_1.err or "game_connect_lost"))
			end
			
			if arg_32_0.match_queue then
				Queue.pop(arg_32_0.match_queue)
			end
		end
		
		return 
	end
	
	if arg_32_2.cmd == "arena_net_enter_lobby" and arg_32_1 and arg_32_1.arena_net_lobby_info and arg_32_1.arena_net_lobby_info.user_info then
		arg_32_0.api_mode = arg_32_1.arena_net_lobby_info.user_info.api_mode or 0
		arg_32_0.api_urls = arg_32_1.arena_net_lobby_info.api_url
	end
	
	if arg_32_2.callback then
		arg_32_2.callback(arg_32_1)
	end
	
	if arg_32_0.match_queue then
		Queue.pop(arg_32_0.match_queue)
	end
	
	if arg_32_0.match_queue and not Queue.empty(arg_32_0.match_queue) then
		arg_32_0:send()
	end
end

function MatchService.isBroadCastMode(arg_36_0)
	return (arg_36_0.api_mode or 0) > 0
end

function MatchService.isBroadCastUIHide(arg_37_0)
	return (arg_37_0.api_mode or 0) == 2
end

function MatchService.getBroadCastUrl(arg_38_0, arg_38_1)
	if arg_38_0.api_urls then
		return arg_38_0.api_urls[arg_38_1]
	end
end

function ArenaService.init(arg_39_0, arg_39_1, arg_39_2)
	arg_39_2 = arg_39_2 or {}
	arg_39_0.mode = arg_39_1.mode
	arg_39_0.trans_block = false
	arg_39_0.match_info = nil
	arg_39_0.vars = {}
	
	if not arg_39_2.not_use_network then
		arg_39_0.vars.uri = getenv("arena_net.url.battle") or arg_39_1.arena_server_host .. ":" .. tostring(arg_39_1.arena_server_port) .. "/api/"
	end
	
	arg_39_1.user_info.uid = tostring(arg_39_1.user_info.uid)
	arg_39_0.vars.season_id = arg_39_1.mode == "net_event_rank" and arg_39_1.user_info.event.season_id or arg_39_1.user_info.season_id
	arg_39_0.vars.user_id = arg_39_1.user_info.uid
	arg_39_0.vars.room_key = arg_39_1.room_key
	arg_39_0.vars.user_info = arg_39_1.user_info
	arg_39_0.vars.invite_list = {}
	arg_39_0.vars.state_machine = table.clone(SERVICE_STATE)
	arg_39_0.vars.not_use_network = arg_39_2.not_use_network
	
	if arg_39_2.not_use_network then
		arg_39_0.trans_block = true
		
		return 
	end
	
	Net:arena_queue_start()
	ArenaNetMeter:init()
	ArenaNetChat:init(arg_39_0)
	LuaEventDispatcher:removeEventListenerByKey("transion.event")
	LuaEventDispatcher:addEventListener("transion.finished", LISTENER(function()
		arg_39_0.trans_block = false
	end), "transion.event")
	arg_39_0:query("watch", {}, nil, {
		conn_reset = true
	})
	arg_39_0:changeState(arg_39_2.init_state or "TRANS", arg_39_1)
end

function ArenaService.reset(arg_41_0)
	if not arg_41_0.vars then
		return 
	end
	
	print("ARENA SERVICE RESET")
	
	local var_41_0 = arg_41_0.vars.state_machine[arg_41_0.vars.cur_state]
	
	if var_41_0 and var_41_0.Leave then
		var_41_0:Leave(arg_41_0)
	end
	
	arg_41_0.trans_block = nil
	arg_41_0.vars = nil
	
	ArenaNetChat:reset()
	Net:arena_queue_reset()
	arg_41_0:clear()
end

function ArenaService.resetWebSocket(arg_42_0)
	if not arg_42_0.vars then
		return 
	end
	
	local var_42_0 = arg_42_0.vars.state_machine[arg_42_0.vars.cur_state]
	
	if var_42_0 then
		var_42_0:resetWebSocket()
	end
end

function ArenaService.isDummy(arg_43_0)
	return false
end

function ArenaService.isReset(arg_44_0)
	return not arg_44_0.vars
end

function ArenaService.isActiveUIScene(arg_45_0, arg_45_1)
	arg_45_1 = arg_45_1 or SceneManager:getCurrentSceneName()
	
	if not arg_45_0:isReset() and arg_45_1 == "battle" or arg_45_1 == "arena_net_ready" or arg_45_1 == "arena_net_lounge" or arg_45_1 == "arena_net_round_next" or arg_45_1 == "arena_net_round_result" then
		return true
	else
		return false
	end
end

function ArenaService.isHostUser(arg_46_0)
	if not arg_46_0.vars or not arg_46_0.vars.user_info or not arg_46_0.vars.game_info then
		return false
	end
	
	return arg_46_0.vars.game_info.host == arg_46_0.vars.user_info.uid
end

function ArenaService.isAdminMode(arg_47_0)
	if not arg_47_0.vars or not arg_47_0.vars.admin_info then
		return false
	end
	
	return arg_47_0.vars.admin_info.admin_mode
end

function ArenaService.isAdminUser(arg_48_0)
	if not arg_48_0.vars or not arg_48_0.vars.admin_info then
		return false
	end
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.admin_info.admin_users or {}) do
		if iter_48_1 == arg_48_0.vars.user_info.uid then
			return true
		end
	end
	
	return false
end

function ArenaService.isRoundMode(arg_49_0)
	if not arg_49_0.vars or not arg_49_0.vars.game_info then
		return false
	end
	
	return arg_49_0.vars.game_info.rule == ARENA_NET_BATTLE_RULE.E7WC or arg_49_0.vars.game_info.rule == ARENA_NET_BATTLE_RULE.E7WC2
end

function ArenaService.isBroadCastRule(arg_50_0)
	if not arg_50_0.vars or not arg_50_0.vars.game_info then
		return false
	end
	
	return arg_50_0.vars.game_info.rule == ARENA_NET_BATTLE_RULE.E7WC2 or arg_50_0.vars.game_info.rule == ARENA_NET_BATTLE_RULE.DRAFT
end

function ArenaService.isAllowPauseGame(arg_51_0)
	if not arg_51_0.vars then
		return false
	end
	
	if arg_51_0:getMatchMode() ~= "net_friend" then
		return false
	end
	
	local var_51_0 = arg_51_0:getGameInfo().host == arg_51_0:getUserUID()
	local var_51_1 = false
	
	if arg_51_0:isAdminUser() then
		var_51_1 = true
	elseif var_51_0 and arg_51_0:isRoundMode() then
		var_51_1 = true
	end
	
	return var_51_1
end

function ArenaService.isAllowResumeGame(arg_52_0)
	if not arg_52_0.vars then
		return false
	end
	
	if arg_52_0:getMatchMode() ~= "net_friend" then
		return false
	end
	
	if arg_52_0:isAdminMode() then
		return arg_52_0:isAdminUser()
	end
	
	return true
end

function ArenaService.isAllowExitBattle(arg_53_0)
	if not arg_53_0:isRoundMode() then
		return arg_53_0:isSpectator() and not arg_53_0:isAdminUser()
	end
	
	return arg_53_0:isSpectator() and not arg_53_0:isAdminUser() and not arg_53_0:isHostUser()
end

function ArenaService.isEnableRtaPenalty(arg_54_0)
	return true
end

function ArenaService.getVersionInfo(arg_55_0)
	local var_55_0 = ""
	
	if PRODUCTION_MODE or not arg_55_0.vars or not arg_55_0.vars.version_info then
		return var_55_0
	end
	
	local var_55_1 = "Arena Server Info\n"
	local var_55_2 = string.split(arg_55_0.vars.version_info, "/")
	
	for iter_55_0, iter_55_1 in pairs(var_55_2) do
		var_55_1 = var_55_1 .. iter_55_1 .. "\n"
	end
	
	return var_55_1
end

function ArenaService.setMatchInfo(arg_56_0, arg_56_1)
	arg_56_0.match_info = arg_56_1
end

function ArenaService.getMatchInfo(arg_57_0)
	return arg_57_0.match_info
end

function ArenaService.setSpectator(arg_58_0, arg_58_1)
	arg_58_0.vars.is_spectator = arg_58_1
end

function ArenaService.isSpectator(arg_59_0)
	return arg_59_0.vars and arg_59_0.vars.is_spectator
end

function ArenaService.setGlobalBanInfo(arg_60_0, arg_60_1)
	arg_60_0.vars.global_ban_info = arg_60_1
end

function ArenaService.getRoomKey(arg_61_0)
	return arg_61_0.vars.room_key
end

function ArenaService.getBattleRoomKey(arg_62_0)
	if arg_62_0.match_info then
		return arg_62_0.match_info.battle_room_key
	end
end

function ArenaService.getUserUID(arg_63_0)
	if arg_63_0.vars then
		return arg_63_0.vars.user_id
	end
end

function ArenaService.getSeasonId(arg_64_0)
	if arg_64_0.vars then
		return arg_64_0.vars.season_id
	end
end

function ArenaService.getUserInfo(arg_65_0)
	if arg_65_0.vars then
		return arg_65_0.vars.user_info
	end
end

function ArenaService.setGameInfo(arg_66_0, arg_66_1)
	if arg_66_0.vars then
		arg_66_0.vars.game_info = arg_66_1
	end
end

function ArenaService.getGameInfo(arg_67_0)
	if arg_67_0.vars then
		return arg_67_0.vars.game_info
	end
end

function ArenaService.getHost(arg_68_0)
	if arg_68_0.vars then
		return arg_68_0.vars.game_info.host
	end
end

function ArenaService.setMatchMode(arg_69_0, arg_69_1)
	arg_69_0.mode = arg_69_1
end

function ArenaService.getMatchMode(arg_70_0)
	return arg_70_0.mode
end

function ArenaService.isChangeBlocked(arg_71_0)
	return arg_71_0.trans_block
end

function ArenaService.isInGlobalBanUnit(arg_72_0, arg_72_1)
	if not arg_72_1 or not arg_72_0.vars or not arg_72_0.vars.global_ban_info or not arg_72_0.vars.global_ban_info.units then
		return false
	end
	
	local var_72_0 = {}
	
	if arg_72_0:isAdminMode() and arg_72_0:isRoundMode() then
		if IS_PUBLISHER_ZLONG then
			var_72_0 = {
				"c1147",
				"c2069",
				"c1121",
				"c1122",
				"c1123",
				"c1146"
			}
		else
			var_72_0 = {}
		end
	end
	
	for iter_72_0, iter_72_1 in pairs(var_72_0) do
		if not table.find(arg_72_0.vars.global_ban_info.units, function(arg_73_0, arg_73_1)
			return arg_73_1.code == iter_72_1
		end) then
			table.insert(arg_72_0.vars.global_ban_info.units, {
				code = iter_72_1
			})
		end
	end
	
	return table.find(arg_72_0.vars.global_ban_info.units, function(arg_74_0, arg_74_1)
		return arg_74_1.code == arg_72_1.db.code
	end)
end

function ArenaService.isInGlobalBanArtifact(arg_75_0, arg_75_1)
	if not arg_75_1 or not arg_75_0.vars or not arg_75_0.vars.global_ban_info or not arg_75_0.vars.global_ban_info.artifacts then
		return false
	end
	
	local var_75_0 = arg_75_1:getEquipByPos("artifact")
	
	if not var_75_0 then
		return false
	end
	
	local var_75_1 = {}
	
	if arg_75_0:isAdminMode() and arg_75_0:isRoundMode() then
		if IS_PUBLISHER_ZLONG then
			var_75_1 = {
				"efm29",
				"efw23",
				"efm24",
				"efh15",
				"efw30"
			}
		else
			var_75_1 = {}
		end
	end
	
	for iter_75_0, iter_75_1 in pairs(var_75_1) do
		if not table.find(arg_75_0.vars.global_ban_info.artifacts, function(arg_76_0, arg_76_1)
			return arg_76_1.code == iter_75_1
		end) then
			table.insert(arg_75_0.vars.global_ban_info.artifacts, {
				code = iter_75_1
			})
		end
	end
	
	return table.find(arg_75_0.vars.global_ban_info.artifacts, function(arg_77_0, arg_77_1)
		return arg_77_1.code == var_75_0.code
	end)
end

function ArenaService.isInGlobalBanExclusive(arg_78_0, arg_78_1)
	if not arg_78_1 or not arg_78_0.vars or not arg_78_0.vars.global_ban_info or not arg_78_0.vars.global_ban_info.exclusive then
		return false
	end
	
	local var_78_0 = arg_78_1:getEquipByPos("exclusive")
	
	if not var_78_0 then
		return false
	end
	
	return table.find(arg_78_0.vars.global_ban_info.exclusive, function(arg_79_0, arg_79_1)
		return arg_79_1 == var_78_0.code
	end)
end

function ArenaService.addInviteList(arg_80_0, arg_80_1, arg_80_2)
	if arg_80_0.vars then
		arg_80_0.vars.invite_list[arg_80_1] = {
			tm = os.time(),
			callback = arg_80_2
		}
	end
end

function ArenaService.removeInviteList(arg_81_0, arg_81_1)
	if arg_81_0.vars then
		arg_81_0.vars.invite_list[arg_81_1] = nil
	end
end

function ArenaService.updateInviteList(arg_82_0)
	if arg_82_0.vars then
		for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.invite_list or {}) do
			if os.time() - iter_82_1.tm > ARENA_NET_INVITE_INTERVAL then
				if iter_82_1.callback then
					iter_82_1.callback(false)
				end
				
				arg_82_0.vars.invite_list[iter_82_0] = nil
			end
		end
	end
end

function ArenaService.clearInviteList(arg_83_0)
	if arg_83_0.vars then
		arg_83_0.vars.invite_list = {}
	end
end

function ArenaService.isInInviteList(arg_84_0, arg_84_1)
	if arg_84_0.vars then
		return arg_84_0.vars.invite_list[arg_84_1]
	end
end

function ArenaService.clear(arg_85_0)
	Log.i("-------------- ArenaService clear ---------------")
	LuaEventDispatcher:removeEventListenerByKey("transion.event")
	Scheduler:removeByName(ARENA_NET_TRANS_SCHEDULER)
	Scheduler:removeByName(ARENA_NET_LOUNGE_SCHEDULER)
	Scheduler:removeByName(ARENA_NET_ROUND_NEXT_SCHEDULER)
	Scheduler:removeByName(ARENA_NET_READY_SCHEDULER)
	Scheduler:removeByName(ARENA_NET_BATTLE_SCHEDULER)
	Scheduler:removeByName(ARENA_NET_BATTLE_READY)
end

function ArenaService.checkQuery(arg_86_0, arg_86_1, arg_86_2)
	if not arg_86_0.vars then
		return false
	end
	
	if arg_86_0.vars.is_spectator and not arg_86_0:isAdminUser() and not arg_86_0:isHostUser() then
		if arg_86_1 == "watch" then
			return true
		elseif arg_86_1 == "command" and (arg_86_2.type == "exit" or arg_86_2.type == "resume") then
			return true
		elseif arg_86_1 == "chat" then
			return true
		else
			return false
		end
	else
		return true
	end
end

function ArenaService.getCurrentState(arg_87_0)
	if arg_87_0.vars then
		return arg_87_0.vars.state_machine[arg_87_0.vars.cur_state]
	end
end

function ArenaService.changeState(arg_88_0, arg_88_1, arg_88_2)
	if arg_88_0.vars.cur_state == arg_88_1 then
		return 
	end
	
	if arg_88_0:isReset() then
		return 
	end
	
	local var_88_0 = arg_88_0.vars.state_machine[arg_88_0.vars.cur_state]
	
	if var_88_0 and var_88_0.Leave then
		var_88_0:Leave(arg_88_0)
	end
	
	local var_88_1 = arg_88_0.vars.state_machine[arg_88_1]
	
	if var_88_1 and var_88_1.Enter then
		Log.i("arena service state change", arg_88_0.vars.cur_state, arg_88_1)
		
		arg_88_0.trans_block = true
		arg_88_0.vars.cur_state = arg_88_1
		
		var_88_1:Enter(arg_88_0, arg_88_2)
	end
end

function ArenaService.sendImmediateDataToWebsock(arg_89_0, arg_89_1, arg_89_2)
	if not arg_89_0.vars then
		return 
	end
	
	local var_89_0 = arg_89_0.vars.state_machine[arg_89_0.vars.cur_state]
	
	if var_89_0 and var_89_0.sendImmediateDataToWebsock then
		var_89_0:sendImmediateDataToWebsock(arg_89_1, arg_89_2)
	end
end

function ArenaService.query(arg_90_0, arg_90_1, arg_90_2, arg_90_3, arg_90_4)
	local function var_90_0(arg_91_0, arg_91_1, arg_91_2)
		arg_90_0:reset()
		TransitionScreen:hide()
		UIAction:Remove("block")
		Dialog:msgBox(arg_91_0 .. generateErrCode(arg_91_1), {
			handler = function()
				if ArenaNetReady:isShow() then
					ArenaNetReady:onLeave()
				end
				
				if ArenaNetRoundNext:isShow() then
					ArenaNetRoundNext:onLeave()
				end
				
				if SceneManager:getCurrentSceneName() ~= arg_91_2 then
					if arg_91_2 == "arena_net_lobby" then
						MatchService:query("arena_net_enter_lobby", nil, function(arg_93_0)
							SceneManager:nextScene("arena_net_lobby", arg_93_0)
							SceneManager:resetSceneFlow()
						end)
					else
						SceneManager:nextScene(arg_91_2)
						SceneManager:resetSceneFlow()
					end
				end
			end
		})
	end
	
	arg_90_4 = arg_90_4 or {}
	
	if arg_90_0.vars and arg_90_0.vars.not_use_network then
		return 
	end
	
	if not arg_90_0.vars and not ClearResult:isShow() and not Battle:isPlayingBattleAction() then
		if arg_90_0.result then
			local var_90_1 = {
				net_pvp = true,
				map_id = "pvp001",
				net_pvp_result = arg_90_0.result
			}
			
			ClearResult:show(SceneManager:getCurrentSceneName() == "battle" and Battle.logic, var_90_1)
		else
			var_90_0(T("game_connect_lost"), CON_ERR.FINISHED, "lobby")
		end
		
		return 
	end
	
	if not arg_90_0:checkQuery(arg_90_1, arg_90_2) then
		return 
	end
	
	if arg_90_1 == "watch" and os.time() - (arg_90_0.vars.last_recv_time or os.time()) > ARENA_NET_LOCAL_TIMEOUT then
		var_90_0(T("game_connect_lost"), CON_ERR.LOCAL_COUNT, "lobby")
		
		return 
	end
	
	arg_90_2.cur_state = arg_90_4.state or arg_90_0.vars.cur_state
	arg_90_2.chat_seq_id = ArenaNetChat:getSeqId()
	
	local var_90_2 = {
		room_key = arg_90_0.vars.room_key,
		arena_uid = arg_90_0.vars.user_id,
		ping = ArenaNetMeter:lastPing(),
		payload = json.encode(arg_90_2 or {})
	}
	local var_90_3 = Net:arena_query(arg_90_1, var_90_2, {
		no_qctl = true,
		read_timeout = 5000,
		uri = arg_90_0.vars.uri,
		retry = arg_90_4.retry or 0,
		conn_reset = arg_90_4.conn_reset or false,
		callback = function(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
			arg_94_0 = arg_94_0 or ""
			
			if arg_90_1 == "watch" then
				ArenaNetMeter:onResponse(arg_94_3 == 0)
			end
			
			if not arg_90_0.vars then
				return 
			end
			
			if arg_90_1 == "watch" then
				if string.starts(arg_94_0, "no_room") then
					var_90_0(T("game_connect_lost"), CON_ERR.NO_ROOM, "lobby")
					
					return 
				elseif string.starts(arg_94_0, "invalid") then
					var_90_0(T("game_connect_lost"), CON_ERR.INVALID, "lobby")
					
					return 
				elseif string.starts(arg_94_0, "closed") then
					var_90_0(T("game_connect_lost"), CON_ERR.CLOSED, "lobby")
					
					return 
				elseif string.starts(arg_94_0, "lua") then
					var_90_0(T("game_connect_lost"), CON_ERR.LUA_ERROR, "lobby")
				end
			end
			
			local var_94_0 = json.decode(arg_94_0)
			
			if not var_94_0 or table.empty(var_94_0) then
				Log.e("arena service response error", arg_90_1, arg_94_3)
				LuaEventDispatcher:dispatchEvent("arena.service.req", ARENA_NET_REQUEST.FAIL, arg_90_2, arg_90_3)
				
				return 
			end
			
			if var_94_0.kicked then
				var_90_0(T("pvp_rta_mock_banned_room"), nil, "arena_net_lobby")
				
				return 
			end
			
			arg_90_0.vars.last_recv_time = os.time()
			
			if var_94_0.result then
				arg_90_0.result = var_94_0.result
			end
			
			if var_94_0.game_info then
				arg_90_0.vars.game_info = var_94_0.game_info
			end
			
			if var_94_0.admin_info then
				arg_90_0.vars.admin_info = var_94_0.admin_info
			end
			
			if var_94_0.version_info then
				arg_90_0.vars.version_info = var_94_0.version_info
			end
			
			LuaEventDispatcher:dispatchEvent("arena.service.res", var_94_0.type, var_94_0)
			
			if arg_90_3 then
				arg_90_3(ARENA_NET_REQUEST.SUCCESS, var_94_0)
			end
		end
	})
	
	if var_90_3 and arg_90_1 == "watch" then
		ArenaNetMeter:onRequest()
	end
	
	if var_90_3 then
		LuaEventDispatcher:dispatchEvent("arena.service.req", ARENA_NET_REQUEST.REQUEST, arg_90_2, arg_90_3)
	end
	
	return var_90_3
end

function ArenaService.getClearSceneName(arg_95_0)
	return arg_95_0.last_clear_scene_name
end

function ArenaService.battleClear(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	if not arg_96_1 then
		return 
	end
	
	arg_96_0.last_clear_scene_name = SceneManager:getCurrentSceneName()
	
	local var_96_0 = {
		net_pvp = true,
		map_id = "pvp001",
		net_pvp_season = arg_96_1.season_id,
		net_pvp_result = arg_96_1
	}
	local var_96_1 = getNetUserEndInfo(arg_96_1, MatchService.arena_uid)
	
	if var_96_1 and var_96_1.invalid_session == 1 then
		arg_96_0:reset()
		Dialog:msgBox(T("session_error_desc"), {
			handler = function()
				restart_contents()
			end
		})
	else
		if not arg_96_2 then
			if arg_96_1.reason ~= 5 and arg_96_0:getMatchMode() ~= "net_friend" then
				ConditionContentsManager:setIgnoreQuery(true)
				ConditionContentsManager:dispatch("pvprta.play")
				
				if arg_96_1 and arg_96_1.winner == MatchService.arena_uid then
					ConditionContentsManager:dispatch("pvprta.win")
				end
			end
			
			ConditionContentsManager:setIgnoreQuery(false)
			ConditionContentsManager:queryUpdateConditions("f:PvpRTA.clear")
		end
		
		ArenaNetPreBanPopup:close()
		
		if arg_96_0:getMatchMode() == "net_event_rank" and arg_96_1.round_info and arg_96_1.round_info.finish then
			arg_96_0:reset()
			SceneManager:nextScene("arena_net_round_result", {
				result = arg_96_1,
				match_info = arg_96_0:getMatchInfo()
			})
			SceneManager:resetSceneFlow()
		elseif not ClearResult:isShow() then
			ClearResult:show(arg_96_3 and Battle.logic, var_96_0)
		end
	end
end

function ArenaService.sendWebsockData(arg_98_0, arg_98_1)
	if arg_98_0.vars.web_sock then
		arg_98_0.vars.web_sock:send(arg_98_1)
	end
end

function ArenaService.cheat(arg_99_0, arg_99_1, arg_99_2)
	if PLATFORM ~= "win32" then
		return 
	end
	
	Log.e("로컬 테스트 환경(DEL키)에서만 치트 작동하게 수정(DummyService.cheat 참고)")
end

SERVICE_STATE = {}
SERVICE_STATE.TRANS = {}

function SERVICE_STATE.TRANS.Enter(arg_100_0, arg_100_1, arg_100_2)
	arg_100_2 = arg_100_2 or {}
	
	BackButtonManager:clear()
	LuaEventDispatcher:removeEventListenerByKey("arena.service.trans")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(SERVICE_STATE.TRANS.onEvent, arg_100_0), "arena.service.trans")
	
	arg_100_0.service = arg_100_1
	arg_100_0.start_tick = os.time()
	arg_100_0.scheduler = Scheduler:addGlobalInterval(1000, arg_100_0.Update, arg_100_0, arg_100_1)
	
	arg_100_0.scheduler:setName(ARENA_NET_TRANS_SCHEDULER)
	
	if arg_100_2.offscreen then
		arg_100_0.block = true
		
		SceneManager:nextScene("arena_net_lobby", {
			offscreen = true
		})
	end
end

function SERVICE_STATE.TRANS.Update(arg_101_0, arg_101_1)
	if arg_101_0.block and os.time() - arg_101_0.start_tick > 0 then
		arg_101_0.block = false
	end
	
	if os.time() - arg_101_0.start_tick < ARENA_NET_TRANS_TIMEOUT then
		arg_101_1:query("watch", {})
	else
		arg_101_1:reset()
		UIAction:Remove("block")
		Dialog:msgBox(T("game_connect_lost") .. generateErrCode(CON_ERR.UNKNOWN), {
			handler = function()
				SceneManager:nextScene("lobby")
				SceneManager:resetSceneFlow()
			end
		})
	end
end

function SERVICE_STATE.TRANS.onEvent(arg_103_0, arg_103_1, arg_103_2)
	if arg_103_0.block then
		return 
	end
	
	if arg_103_2 then
		arg_103_0.service:changeState(arg_103_2.cur_state, arg_103_2)
	end
end

function SERVICE_STATE.TRANS.Leave(arg_104_0, arg_104_1)
	LuaEventDispatcher:removeEventListenerByKey("arena.service.trans")
	Scheduler:removeByName(ARENA_NET_TRANS_SCHEDULER)
end

SERVICE_STATE.LOUNGE = {}

function SERVICE_STATE.LOUNGE.Enter(arg_105_0, arg_105_1, arg_105_2)
	UIAction:Remove("block")
	BackButtonManager:clear()
	arg_105_1:setMatchInfo(nil)
	arg_105_1:setSpectator(false)
	
	local function var_105_0()
		if SceneManager:getCurrentSceneName() ~= "arena_net_lounge" then
			SceneManager:nextScene("arena_net_lounge", {
				service = arg_105_1,
				infos = arg_105_2
			})
		end
	end
	
	arg_105_0.scheduler = Scheduler:addGlobalInterval(1000, arg_105_0.Update, arg_105_0, arg_105_1)
	
	arg_105_0.scheduler:setName(ARENA_NET_LOUNGE_SCHEDULER)
	var_105_0()
end

function SERVICE_STATE.LOUNGE.Update(arg_107_0, arg_107_1)
	if arg_107_1.onUpdate then
		arg_107_1.onUpdate()
	else
		arg_107_1:query("watch", {}, nil, {
			state = "TRANS"
		})
	end
	
	arg_107_1:updateInviteList()
end

function SERVICE_STATE.LOUNGE.Leave(arg_108_0, arg_108_1)
	Scheduler:removeByName(ARENA_NET_LOUNGE_SCHEDULER)
	arg_108_1:clearInviteList()
end

SERVICE_STATE.NEXT_ROUND = {}

function SERVICE_STATE.NEXT_ROUND.Enter(arg_109_0, arg_109_1, arg_109_2)
	UIAction:Remove("block")
	BackButtonManager:clear()
	arg_109_1:setMatchInfo(nil)
	arg_109_1:setSpectator(arg_109_2.is_spectator or false)
	
	local function var_109_0()
		if SceneManager:getCurrentSceneName() ~= "arena_net_round_next" then
			SceneManager:nextScene("arena_net_round_next", {
				service = arg_109_1,
				infos = arg_109_2
			})
		end
	end
	
	arg_109_0.scheduler = Scheduler:addGlobalInterval(1000, arg_109_0.Update, arg_109_0, arg_109_1)
	
	arg_109_0.scheduler:setName(ARENA_NET_ROUND_NEXT_SCHEDULER)
	
	if MatchService:isBroadCastMode() then
		local var_109_1 = MatchService:getBroadCastUrl("result")
		
		if var_109_1 then
			arg_109_0.web_sock = ArenaWebSocket:create({
				scene = "result",
				url = var_109_1,
				state = ArenaNetRoundNext
			})
			
			arg_109_0.web_sock:start()
		end
	end
	
	var_109_0()
end

function SERVICE_STATE.NEXT_ROUND.Update(arg_111_0, arg_111_1)
	if arg_111_1.onUpdate then
		arg_111_1.onUpdate()
	else
		arg_111_1:query("watch", {}, nil, {
			state = "TRANS"
		})
	end
end

function SERVICE_STATE.NEXT_ROUND.Leave(arg_112_0, arg_112_1)
	arg_112_0:resetWebSocket()
	Scheduler:removeByName(ARENA_NET_ROUND_NEXT_SCHEDULER)
end

function SERVICE_STATE.NEXT_ROUND.resetWebSocket(arg_113_0)
	if arg_113_0.web_sock then
		arg_113_0.web_sock:reset()
		
		arg_113_0.web_sock = nil
	end
end

SERVICE_STATE.READY = {}

function SERVICE_STATE.READY.Enter(arg_114_0, arg_114_1, arg_114_2)
	local var_114_0 = arg_114_2
	
	var_114_0.first_pick_arena_uid = tostring(var_114_0.first_pick_arena_uid)
	var_114_0.user_info.uid = tostring(var_114_0.user_info.uid)
	var_114_0.enemy_user_info.uid = tostring(var_114_0.enemy_user_info.uid)
	
	arg_114_1:setMatchInfo(var_114_0)
	arg_114_1:setSpectator(var_114_0.is_spectator or false)
	
	local var_114_1 = var_114_0.global_ban_info or {}
	local var_114_2 = var_114_0.e7wc_ban_info or {}
	
	if arg_114_1:isAdminMode() then
		var_114_1.units = var_114_1.units or {}
		var_114_1.artifacts = var_114_1.artifacts or {}
		
		for iter_114_0, iter_114_1 in pairs(var_114_2.units or {}) do
			table.insert(var_114_1.units, {
				code = iter_114_1.code
			})
		end
		
		for iter_114_2, iter_114_3 in pairs(var_114_2.artifacts or {}) do
			table.insert(var_114_1.artifacts, {
				code = iter_114_3.code
			})
		end
	end
	
	arg_114_1:setGlobalBanInfo(var_114_1)
	
	if UIAction:Find("match.success") then
		return 
	end
	
	BackButtonManager:clear()
	
	local function var_114_3()
		local var_115_0
		local var_115_1 = arg_114_1:getMatchMode()
		
		if var_115_1 == "net_rank" then
			var_115_0 = "ui_livepvp_que_eff.cfx"
		elseif arg_114_1:isRoundMode() then
			local var_115_2 = arg_114_2.round_info and #arg_114_2.round_info.rounds or 1
			
			var_115_0 = "ui_livepvp_round_eff_" .. tostring(var_115_2) .. ".cfx"
		elseif var_115_1 == "net_event_rank" then
			local var_115_3 = arg_114_2.round_info and #arg_114_2.round_info.rounds or 1
			
			if var_115_3 > 1 then
				var_115_0 = "ui_livepvp_round_eff_" .. tostring(var_115_3) .. ".cfx"
			else
				var_115_0 = "ui_livepvp_que_eff.cfx"
			end
		else
			var_115_0 = "ui_livepvp_watching.cfx"
		end
		
		EffectManager:Play({
			scale = 1,
			z = 99999,
			fn = var_115_0,
			layer = SceneManager:getRunningPopupScene(),
			x = DESIGN_WIDTH * 0.5,
			y = DESIGN_HEIGHT * 0.5,
			action = BattleAction
		})
	end
	
	local function var_114_4()
		ArenaNetMatchBanner:show(SceneManager:getRunningPopupScene(), var_114_0)
	end
	
	local function var_114_5()
		UIAction:Remove("block")
		Singular:event("join_worldarena")
		SceneManager:nextScene("arena_net_ready", {
			service = arg_114_1,
			match_info = var_114_0
		})
	end
	
	arg_114_0.scheduler = Scheduler:addGlobalInterval(1000, arg_114_0.Update, arg_114_0, arg_114_1)
	
	arg_114_0.scheduler:setName(ARENA_NET_READY_SCHEDULER)
	set_high_fps_tick(4000)
	UIAction:Add(SEQ(CALL(var_114_3), DELAY(1200), CALL(var_114_4), DELAY(2300), CALL(var_114_5)), arg_114_0, "match.success")
	
	if MatchService:isBroadCastMode() and arg_114_1:isBroadCastRule() then
		local var_114_6 = MatchService:getBroadCastUrl("pickban")
		
		if var_114_6 then
			arg_114_0.web_sock = ArenaWebSocket:create({
				scene = "pickban",
				url = var_114_6,
				state = ArenaNetReady
			})
			
			arg_114_0.web_sock:start()
		end
	end
end

function SERVICE_STATE.READY.Update(arg_118_0, arg_118_1)
	if arg_118_1.onUpdate then
		arg_118_1.onUpdate()
	else
		arg_118_1:query("watch", {}, nil, {
			state = "TRANS"
		})
	end
end

function SERVICE_STATE.READY.Leave(arg_119_0, arg_119_1)
	arg_119_0:resetWebSocket()
	ArenaNetReady:resetUIEvent()
	Scheduler:removeByName(ARENA_NET_READY_SCHEDULER)
end

function SERVICE_STATE.READY.resetWebSocket(arg_120_0)
	if arg_120_0.web_sock then
		arg_120_0.web_sock:reset()
		
		arg_120_0.web_sock = nil
	end
end

SERVICE_STATE.BATTLE = {}

function SERVICE_STATE.BATTLE.Enter(arg_121_0, arg_121_1, arg_121_2)
	local var_121_0 = arg_121_2
	
	var_121_0.first_pick_arena_uid = tostring(var_121_0.first_pick_arena_uid)
	var_121_0.user_info.uid = tostring(var_121_0.user_info.uid)
	var_121_0.enemy_user_info.uid = tostring(var_121_0.enemy_user_info.uid)
	arg_121_1.onUpdate = nil
	arg_121_1.battle_init = nil
	
	arg_121_1:setMatchInfo(var_121_0)
	arg_121_1:setSpectator(var_121_0.is_spectator or false)
	
	local var_121_1 = var_121_0.road_id or "rta00100"
	
	PreLoad:beforeReqBattle(var_121_1)
	TransitionScreen:show({
		on_show_before = function(arg_122_0)
			SoundEngine:play("event:/ui/pvp/door_close")
			
			return EffectManager:Play({
				fn = "pvp_gate_close.cfx",
				pivot_z = 99998,
				layer = arg_122_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_hide_before = function(arg_123_0)
			arg_123_0:removeAllChildren()
			SoundEngine:play("event:/ui/pvp/door_open")
			
			return EffectManager:Play({
				fn = "pvp_gate_open.cfx",
				pivot_z = 99998,
				layer = arg_123_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 2000
		end,
		on_show = function()
			function arg_121_1.onUpdate()
				if arg_121_1.battle_init then
					return 
				end
				
				arg_121_1:query("watch", {
					record_id = 0
				}, function(arg_126_0, arg_126_1)
					if arg_126_1 then
						local var_126_0 = arg_126_1.recordinfo
						
						if arg_121_1.battle_init then
							Log.e("battle already created")
							
							return 
						end
						
						if not var_126_0 then
							Log.e("record info nil")
							
							return 
						end
						
						local var_126_1 = BattleLogic:makeLogic(var_126_0.map, var_126_0.team, {
							mode = arg_121_1.mode,
							service = arg_121_1,
							world_arena_season_id = arg_121_1:getSeasonId()
						})
						
						if not var_126_1 then
							Log.e("logic gen fail")
							
							return 
						end
						
						arg_121_1.battle_init = true
						
						restoreArenaNetBattle(var_126_1, var_126_0)
						
						var_126_1.enemy_name = var_126_0.map.ways[var_121_1][1].team.name
						var_126_1.enemy_leader_code = Account:getMainUnitCode()
						
						SceneManager:nextScene("battle", {
							logic = var_126_1,
							service = arg_121_1,
							match_info = var_121_0,
							mode = arg_121_1.mode,
							record_id = var_126_0.id,
							init_snap = var_126_0.records_snap,
							records = var_126_0.records,
							bgm_id = arg_121_2.bgm_id
						})
					end
				end)
			end
		end
	})
	
	arg_121_0.scheduler = Scheduler:addGlobalInterval(1000, arg_121_0.Update, arg_121_0, arg_121_1)
	
	arg_121_0.scheduler:setName(ARENA_NET_BATTLE_SCHEDULER)
	
	if MatchService:isBroadCastMode() and arg_121_1:isBroadCastRule() then
		local var_121_2 = MatchService:getBroadCastUrl("battle")
		
		if var_121_2 then
			arg_121_0.web_sock = ArenaWebSocket:create({
				scene = "battle",
				url = var_121_2,
				state = Battle
			})
			
			arg_121_0.web_sock:start()
		end
	end
end

function SERVICE_STATE.BATTLE.Update(arg_127_0, arg_127_1)
	if arg_127_1.onUpdate then
		arg_127_1.onUpdate()
	else
		arg_127_1:query("watch", {}, nil, {
			state = "TRANS"
		})
	end
end

function SERVICE_STATE.BATTLE.Leave(arg_128_0)
	arg_128_0:resetWebSocket()
	Scheduler:removeByName(ARENA_NET_BATTLE_READY)
	Scheduler:removeByName(ARENA_NET_BATTLE_SCHEDULER)
end

function SERVICE_STATE.BATTLE.sendImmediateDataToWebsock(arg_129_0, arg_129_1, arg_129_2)
	if not MatchService:isBroadCastMode() then
		return 
	end
	
	if not arg_129_1 or not arg_129_2 then
		return 
	end
	
	if arg_129_1 ~= "skill" then
		return 
	end
	
	if arg_129_0.web_sock then
		arg_129_0.web_sock:send(arg_129_2)
	end
end

function SERVICE_STATE.BATTLE.resetWebSocket(arg_130_0)
	if arg_130_0.web_sock then
		arg_130_0.web_sock:reset()
		
		arg_130_0.web_sock = nil
	end
end

ArenaNetMeter = ArenaNetMeter or {}

function ArenaNetMeter.init(arg_131_0)
	arg_131_0.vars = {}
	arg_131_0.vars.pings = {}
	arg_131_0.vars.req_time = 0
	arg_131_0.vars.last_ping = 0
	arg_131_0.vars.report = {}
	arg_131_0.vars.report.samples = 0
	arg_131_0.vars.report.min = 0
	arg_131_0.vars.report.max = 0
	arg_131_0.vars.report.ave = 0
	arg_131_0.vars.report.err = 0
end

function ArenaNetMeter.clear(arg_132_0)
	arg_132_0.vars.pings = {}
end

function ArenaNetMeter.report(arg_133_0)
	return arg_133_0.vars.report
end

function ArenaNetMeter.onRequest(arg_134_0)
	arg_134_0.vars.report.samples = arg_134_0.vars.report.samples + 1
	arg_134_0.vars.req_time = systick()
end

function ArenaNetMeter.onResponse(arg_135_0, arg_135_1)
	if arg_135_0.vars.req_time == 0 then
		return 
	end
	
	arg_135_0.vars.last_ping = systick() - arg_135_0.vars.req_time
	arg_135_0.vars.req_time = 0
	
	if arg_135_1 == false then
		arg_135_0.vars.last_ping = PING_TIMEOUT_ERROR
	end
end

function ArenaNetMeter.calc(arg_136_0)
	if not arg_136_0.vars then
		return false
	end
	
	if #arg_136_0.vars.pings <= 0 then
		return false
	end
	
	local var_136_0 = 0
	
	table.each(arg_136_0.vars.pings, function(arg_137_0, arg_137_1)
		if arg_137_1 >= arg_136_0.vars.report.max then
			arg_136_0.vars.report.max = arg_137_1
		end
		
		if arg_136_0.vars.report.min == 0 then
			arg_136_0.vars.report.min = arg_137_1
		elseif arg_137_1 <= arg_136_0.vars.report.min then
			arg_136_0.vars.report.min = arg_137_1
		end
		
		var_136_0 = var_136_0 + arg_137_1
	end)
	
	arg_136_0.vars.report.ave = math.floor(var_136_0 / #arg_136_0.vars.pings)
	arg_136_0.vars.report.err = arg_136_0.vars.report.samples - #arg_136_0.vars.pings
	
	return true
end

function ArenaNetMeter.lastPing(arg_138_0)
	return arg_138_0.vars.last_ping
end

ArenaNetChat = ArenaNetChat or {}

function ArenaNetChat.init(arg_139_0, arg_139_1)
	arg_139_0.vars = {}
	arg_139_0.vars.service = arg_139_1
	
	ChatMBox:clearHistory("arena")
	LuaEventDispatcher:removeEventListenerByKey("arena.chat")
	LuaEventDispatcher:addEventListener("arena.chat.msg", LISTENER(ArenaNetChat.onSendMessage, arg_139_0), "arena.chat")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetChat.onRecvMessage, arg_139_0), "arena.chat")
end

function ArenaNetChat.reset(arg_140_0)
	arg_140_0.vars = nil
	
	LuaEventDispatcher:dispatchEvent("arena.service.res", nil, {
		is_enable_chat = 1
	})
	LuaEventDispatcher:removeEventListenerByKey("arena.chat")
end

function ArenaNetChat.getSeqId(arg_141_0)
	return arg_141_0.vars.seq_id
end

function ArenaNetChat.onSendMessage(arg_142_0, arg_142_1)
	if not arg_142_0.vars then
		return 
	end
	
	arg_142_0.vars.service:query("chat", {
		cmd = "push",
		msg_doc = arg_142_1
	})
end

function ArenaNetChat.onRecvMessage(arg_143_0, arg_143_1, arg_143_2)
	if not arg_143_0.vars or not arg_143_2 then
		return 
	end
	
	if arg_143_2.chat_seq_id then
		arg_143_0.vars.seq_id = arg_143_2.chat_seq_id
	end
	
	arg_143_0.vars.is_enable_chat = arg_143_2.is_enable_chat
	
	local var_143_0 = arg_143_0.vars.service:getMatchInfo()
	local var_143_1
	
	for iter_143_0, iter_143_1 in pairs(arg_143_2.msgs or {}) do
		arg_143_0.vars.seq_id = iter_143_1.msg_id
		
		if iter_143_1.msg_doc and iter_143_1.msg_doc.sender then
			iter_143_1.msg_doc.sender.name = check_abuse_filter(iter_143_1.msg_doc.sender.name, ABUSE_FILTER.WORLD_NAME) or iter_143_1.msg_doc.sender.name
			
			if var_143_0 then
				if iter_143_1.msg_doc.sender.id == var_143_0.home_user then
					iter_143_1.msg_doc.tag = "[" .. T("pvp_rta_mock_player1") .. "]"
					iter_143_1.msg_doc.color = "#4494ff"
				elseif iter_143_1.msg_doc.sender.id == var_143_0.away_user then
					iter_143_1.msg_doc.tag = "[" .. T("pvp_rta_mock_player2") .. "]"
					iter_143_1.msg_doc.color = "#fe1e1e"
				end
			end
			
			if iter_143_1.msg_doc.style == "host_change" then
				iter_143_1.msg_doc.text = T("pvp_rta_mock_ur_host_chat", {
					user_name = iter_143_1.msg_doc.sender.name,
					user_server = getRegionText(iter_143_1.msg_doc.sender.world)
				})
			elseif iter_143_1.msg_doc.style == "rule_change" then
				iter_143_1.msg_doc.text = T("pvp_rta_battle_rule_changed", {
					battle_rule_name = getArenaRuleName(iter_143_1.msg_doc.rule)
				})
			elseif iter_143_1.msg_doc.style == "home_user_change" then
				iter_143_1.msg_doc.text = T("pvp_rta_mock_ur_player1_chat", {
					user_name = iter_143_1.msg_doc.sender.name,
					user_server = getRegionText(iter_143_1.msg_doc.sender.world)
				})
			elseif iter_143_1.msg_doc.style == "away_user_change" then
				iter_143_1.msg_doc.text = T("pvp_rta_mock_ur_player2_chat", {
					user_name = iter_143_1.msg_doc.sender.name,
					user_server = getRegionText(iter_143_1.msg_doc.sender.world)
				})
			elseif iter_143_1.msg_doc.style == "preban_count_change" then
				iter_143_1.msg_doc.text = T("pvp_rta_pre_ban_changed" .. tostring(iter_143_1.msg_doc.preban_count))
			elseif iter_143_1.msg_doc.style == "total_round_change" then
				iter_143_1.msg_doc.text = T("pvp_rta_rchange_" .. tostring(iter_143_1.msg_doc.total_round))
			elseif iter_143_1.msg_doc.style == "first_pick_change" then
				if iter_143_1.msg_doc.first_pick == "HOME" then
					iter_143_1.msg_doc.text = T("pvp_rta_first_pick_player1")
				elseif iter_143_1.msg_doc.first_pick == "AWAY" then
					iter_143_1.msg_doc.text = T("pvp_rta_first_pick_player2")
				else
					iter_143_1.msg_doc.text = T("pvp_rta_first_pick_random")
				end
			end
		end
		
		iter_143_1.msg_tm = os.time()
		
		ChatMain:addChatData(iter_143_1)
		
		var_143_1 = iter_143_1
	end
	
	if var_143_1 and not ChatMain:isVisible() then
		if var_143_1.msg_doc.emoji then
			ChatMain:onCastEmoji(var_143_1)
		else
			ChatMain:onCastToolTip(var_143_1)
		end
	end
	
	if arg_143_2.user_count and arg_143_2.total_count then
		arg_143_0.vars.user_count = arg_143_2.user_count
		arg_143_0.vars.total_user_count = arg_143_2.total_count
		
		arg_143_0:updateMemberCount()
	end
end

function ArenaNetChat.isMaxUser(arg_144_0)
	return arg_144_0.vars.user_count >= arg_144_0.vars.total_user_count
end

function ArenaNetChat.isDisabled(arg_145_0)
	if not arg_145_0.vars then
		return false
	end
	
	return arg_145_0.vars.is_enable_chat ~= 1
end

function ArenaNetChat.updateMemberCount(arg_146_0)
	if arg_146_0.vars and arg_146_0.vars.user_count and arg_146_0.vars.total_user_count then
		ChatMain:updateMemberCount(arg_146_0.vars.user_count, arg_146_0.vars.total_user_count)
	end
end

ArenaNetNotifier = {}

function onBtnAccept(arg_147_0, arg_147_1)
	if arg_147_1 ~= 2 then
		return 
	end
	
	ArenaNetNotifier:answer(arg_147_0:getParent(), true)
end

function onBtnReject(arg_148_0, arg_148_1)
	if arg_148_1 ~= 2 then
		return 
	end
	
	ArenaNetNotifier:answer(arg_148_0:getParent(), false, INVITE_REJECT_REASON.NORMAL)
end

function ArenaNetNotifier.init(arg_149_0, arg_149_1)
	arg_149_1 = arg_149_1 or {}
	
	if arg_149_0.vars then
		return 
	end
	
	arg_149_0.vars = {}
	arg_149_0.vars.infos = {}
	arg_149_0.vars.scheduler = Scheduler:addGlobalInterval(1000, ArenaNetNotifier.onUpdate, arg_149_0)
	arg_149_0.vars.max_visible = arg_149_1.max_visible or 1
	
	LuaEventDispatcher:addEventListener("invite.event", LISTENER(ArenaNetNotifier.onEvent, arg_149_0), "invite")
	arg_149_0:createPool(arg_149_0.vars.max_visible * 2)
end

function ArenaNetNotifier.createPool(arg_150_0, arg_150_1)
	arg_150_0.vars.pool = arg_150_0.vars.pool or {}
	
	for iter_150_0 = 1, arg_150_1 do
		local var_150_0 = ArenaNetNotifierCtrl:create()
		
		var_150_0:setName("arena_notifier_" .. tostring(iter_150_0))
		table.insert(arg_150_0.vars.pool, var_150_0)
	end
end

function ArenaNetNotifier.getPool(arg_151_0)
	if arg_151_0.vars then
		return arg_151_0.vars.pool
	end
end

function ArenaNetNotifier.findNotifyCtrl(arg_152_0, arg_152_1)
	for iter_152_0, iter_152_1 in pairs(arg_152_0.vars.infos) do
		if iter_152_1.host_arena_id == arg_152_1 then
			return iter_152_1.ctrl
		end
	end
end

function ArenaNetNotifier._alloc(arg_153_0)
	for iter_153_0, iter_153_1 in pairs(arg_153_0.vars.pool) do
		if iter_153_1 and not iter_153_1:getParent() then
			return iter_153_1
		end
	end
end

function ArenaNetNotifier.onUpdate(arg_154_0)
	local var_154_0 = {}
	
	for iter_154_0, iter_154_1 in pairs(arg_154_0.vars.infos) do
		if arg_154_0.vars.infos[iter_154_0].ctrl:update() then
			table.insert(var_154_0, iter_154_0)
		end
	end
	
	for iter_154_2 = #var_154_0, 1, -1 do
		arg_154_0.vars.infos[var_154_0[iter_154_2]].ctrl.order = nil
		
		table.remove(arg_154_0.vars.infos, var_154_0[iter_154_2])
	end
	
	if not table.empty(var_154_0) then
		arg_154_0:reorder()
		arg_154_0:moveAll()
	end
end

inviteStep = {}
inviteStep.step1 = {}
inviteStep.step2 = {}
inviteStep.step3 = {}

function inviteStep.step1.onEvent(arg_155_0, arg_155_1, arg_155_2)
	if arg_155_1 then
		Log.i("invite step1 success")
		MatchService:query("arena_net_enter_lobby", nil, function(arg_156_0)
			inviteStep.step2:onEvent(arg_156_0, arg_155_2)
		end)
	else
		arg_155_2.cbFail()
		Log.e("invite step1 fail", arg_155_2.answer, arg_155_2.arena_host_uid)
	end
end

function inviteStep.step2.onEvent(arg_157_0, arg_157_1, arg_157_2)
	if arg_157_1 then
		Log.i("invite step2 success")
		updateRegionIds(arg_157_1.arena_net_lobby_info)
		
		local var_157_0 = arg_157_2.answer and 1 or 0
		
		MatchService:query("arena_net_invite_answer", {
			answer = var_157_0,
			refuse_reason = arg_157_2.reason,
			invite_uid = arg_157_2.invite_uid,
			arena_host_uid = arg_157_2.arena_host_uid
		}, function(arg_158_0)
			inviteStep.step3:onEvent(arg_158_0, arg_157_2)
		end)
	else
		arg_157_2.cbFail()
		Log.e("invite step2 fail", arg_157_2.answer, arg_157_2.arena_host_uid)
	end
end

function inviteStep.step3.onEvent(arg_159_0, arg_159_1, arg_159_2)
	if arg_159_1 then
		Log.i("invite step3 success", table.print(arg_159_1))
		
		if arg_159_1 and arg_159_1.match_info and arg_159_1.match_info.match_success == 1 then
			LuaEventDispatcher:dispatchEvent("invite.event", "hide")
			ChatMain:hide()
			ArenaService:init(arg_159_1.match_info)
		else
			arg_159_2.cbFail(arg_159_2, arg_159_1.error_code)
		end
	else
		arg_159_2.cbFail()
		Log.e("invite step3 fail", arg_159_2.answer, arg_159_2.arena_host_uid)
	end
end

function ArenaNetNotifier.answer(arg_160_0, arg_160_1, arg_160_2, arg_160_3)
	if UIAction:Find("block") then
		return 
	end
	
	UIAction:Add(LOOP(SEQ(DELAY(10000))), arg_160_0, "block")
	
	if arg_160_1.order then
		arg_160_0:remove(arg_160_1.order)
	end
	
	local var_160_0, var_160_1 = checkCanStartMatch()
	
	if var_160_1 then
		UIAction:Remove("block")
		Dialog:msgBox(T("arena_wa_notenough_4hero"))
		
		return 
	end
	
	local var_160_2 = {
		invite_uid = arg_160_1.invite_uid,
		arena_host_uid = arg_160_1.host_arena_uid,
		answer = arg_160_2,
		reason = tostring(var_160_1),
		cbFail = function(arg_161_0, arg_161_1)
			UIAction:Remove("block")
			
			if arg_161_1 then
				joinLoungeErrorMsg(arg_161_1)
			end
		end
	}
	
	LuaEventDispatcher:removeEventListenerByKey("arena_net_invite")
	LuaEventDispatcher:addEventListener("arena_net_invite_step", LISTENER(function(arg_162_0)
		if CustomProfileCardEditor:isOpen() then
			balloon_message_with_sound("msg_profile_edit_can_pvp_mimic")
			
			return 
		end
		
		if arg_162_0.success then
			inviteStep.step1:onEvent(arg_162_0, var_160_2)
		else
			var_160_2:cbFail()
		end
	end), "arena_net_invite")
	query("arena_net_enter_ready", {
		match_friend = true
	})
end

function ArenaNetNotifier.onEvent(arg_163_0, arg_163_1, arg_163_2)
	if arg_163_1 == "push" then
		arg_163_0:push(arg_163_2)
	elseif arg_163_1 == "pop" then
		arg_163_0:pop(arg_163_2)
	elseif arg_163_1 == "hide" then
		arg_163_0:hide()
	elseif arg_163_1 == "reload" then
		arg_163_0:reload()
	end
end

function ArenaNetNotifier.reorder(arg_164_0)
	local var_164_0 = 1
	
	for iter_164_0 = #arg_164_0.vars.infos, 1, -1 do
		arg_164_0.vars.infos[iter_164_0].ctrl.order = var_164_0
		var_164_0 = var_164_0 + 1
	end
end

function ArenaNetNotifier.push(arg_165_0, arg_165_1)
	local var_165_0 = arg_165_0:findNotifyCtrl(arg_165_1.host_arena_id)
	
	if var_165_0 then
		var_165_0.rest = ARENA_NET_REQUEST_TIMEOUT
	else
		arg_165_1.ctrl = arg_165_0:_alloc()
		
		if arg_165_1.ctrl then
			arg_165_1.ctrl.order = 0
			arg_165_1.ctrl.rest = ARENA_NET_REQUEST_TIMEOUT
			arg_165_1.ctrl.invite_uid = arg_165_1.invite_uid
			arg_165_1.ctrl.host_arena_uid = arg_165_1.host_arena_id
			
			arg_165_1.ctrl:setInfo(arg_165_1)
			arg_165_1.ctrl:setPosition(VIEW_BASE_LEFT, -arg_165_1.ctrl:getContentSize().height)
			
			arg_165_1.start = os.time()
			
			table.insert(arg_165_0.vars.infos, arg_165_1)
			
			if table.count(arg_165_0.vars.infos) > arg_165_0.vars.max_visible then
				arg_165_0.vars.infos[1].ctrl.order = nil
				
				table.remove(arg_165_0.vars.infos, 1)
			end
			
			arg_165_0:reorder()
			arg_165_0:moveAll()
		else
			Log.e("alloc notify ctrl fail")
		end
	end
end

function ArenaNetNotifier.pop(arg_166_0, arg_166_1)
	arg_166_0:remove(nil, arg_166_1.invite_uid)
end

function ArenaNetNotifier.remove(arg_167_0, arg_167_1, arg_167_2)
	local var_167_0 = {}
	
	for iter_167_0, iter_167_1 in pairs(arg_167_0.vars.infos) do
		if iter_167_1.ctrl.order == arg_167_1 or iter_167_1.ctrl.invite_uid == arg_167_2 then
			table.insert(var_167_0, iter_167_0)
		end
	end
	
	for iter_167_2 = #var_167_0, 1, -1 do
		arg_167_0.vars.infos[var_167_0[iter_167_2]].ctrl.order = nil
		
		table.remove(arg_167_0.vars.infos, var_167_0[iter_167_2])
	end
	
	arg_167_0:reorder()
	arg_167_0:moveAll()
end

function ArenaNetNotifier.removeAll(arg_168_0)
	if not arg_168_0.vars or not arg_168_0.vars.infos then
		return 
	end
	
	arg_168_0.vars.infos = {}
end

function ArenaNetNotifier.hide(arg_169_0)
	for iter_169_0, iter_169_1 in pairs(arg_169_0.vars.infos) do
		local var_169_0 = iter_169_1.ctrl
		
		if var_169_0 then
			var_169_0:setVisible(false)
		end
	end
end

function ArenaNetNotifier.reload(arg_170_0)
	for iter_170_0, iter_170_1 in pairs(arg_170_0.vars.pool) do
		iter_170_1:removeFromParent()
	end
	
	arg_170_0:reorder()
	arg_170_0:moveAll()
end

function ArenaNetNotifier.moveAll(arg_171_0, arg_171_1)
	local var_171_0 = SceneManager:getCurrentSceneName()
	
	if var_171_0 ~= "lobby" and var_171_0 ~= "arena_net_lobby" then
		return 
	end
	
	if is_playing_story() then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if SeasonPassBase:isVisible() then
		return 
	end
	
	if CustomProfileCardEditor:isOpen() then
		return 
	end
	
	if var_171_0 == "lobby" then
		if Lobby:checkNotiSeqActive() then
			return 
		elseif Lobby:isBartenderMode() or Lobby:isGuerrillaMode() then
			return 
		end
	end
	
	for iter_171_0, iter_171_1 in pairs(arg_171_0.vars.infos) do
		local var_171_1 = iter_171_1.ctrl
		
		if var_171_1 then
			UIAction:Add(SEQ(MOVE_TO(280, VIEW_BASE_LEFT, var_171_1:getContentSize().height * (var_171_1.order - 1))), var_171_1, "move.action." .. tostring(iter_171_0))
			
			if not var_171_1:getParent() then
				var_171_1:setVisible(true)
				SceneManager:getRunningPopupScene(true):addChild(var_171_1)
			end
		end
	end
	
	for iter_171_2, iter_171_3 in pairs(arg_171_0.vars.pool) do
		if iter_171_3:getParent() and not iter_171_3.order then
			UIAction:Add(SEQ(MOVE_BY(280, -800, 0), CALL(function()
				iter_171_3:removeFromParent()
			end)), iter_171_3, "remove.action." .. tostring(iter_171_2))
		end
	end
end

ArenaNetNotifierCtrl = ClassDef()

function ArenaNetNotifierCtrl.create(arg_173_0)
	local var_173_0 = cc.CSLoader:createNode("wnd/pvplive_battle_invite.csb")
	
	copy_functions(ArenaNetNotifierCtrl, var_173_0)
	var_173_0:setGlobalZOrder(1000000)
	var_173_0:setLocalZOrder(1000000)
	var_173_0:retain()
	var_173_0:registTouchEventListener()
	
	return var_173_0
end

function ArenaNetNotifierCtrl.registTouchEventListener(arg_174_0)
	local var_174_0 = arg_174_0:getChildByName("btn_ok")
	
	if var_174_0 then
		var_174_0:addTouchEventListener(onBtnAccept)
	end
	
	local var_174_1 = arg_174_0:getChildByName("btn_cancel")
	
	if var_174_1 then
		var_174_1:addTouchEventListener(onBtnReject)
	end
end

local function var_0_2(arg_175_0)
	local var_175_0 = math.floor(arg_175_0 / 60)
	local var_175_1 = math.floor(arg_175_0 - var_175_0 * 60)
	
	return string.format("%02d:%02d", var_175_0, var_175_1)
end

function ArenaNetNotifierCtrl.setInfo(arg_176_0, arg_176_1)
	if_set(arg_176_0, "txt_title", T("pvp_rta_mock_invite_popup"))
	if_set(arg_176_0, "label_accept", T("pvp_rta_mimic_accept"))
	if_set(arg_176_0, "label_cancel", T("pvp_rta_mimic_cancel"))
	if_set(arg_176_0, "txt_name", arg_176_1.host_user_name)
	if_set(arg_176_0, "t_time", var_0_2(arg_176_0.rest or 0))
	UIAction:Remove(arg_176_0:getName())
	UIAction:Add(LOOP(ROTATE(2000, 0, -360)), arg_176_0:getChildByName("icon"), arg_176_0:getName())
end

function ArenaNetNotifierCtrl.update(arg_177_0)
	arg_177_0.rest = arg_177_0.rest - 1
	
	if arg_177_0.rest < 0 then
		return true
	else
		if_set(arg_177_0, "t_time", var_0_2(arg_177_0.rest or 0))
		
		return false
	end
end

ArenaWebSocket = {}

function ArenaWebSocket.create(arg_178_0, arg_178_1)
	local var_178_0 = {}
	
	copy_functions(ArenaWebSocket, var_178_0)
	var_178_0:init(arg_178_1)
	
	return var_178_0
end

function ArenaWebSocket.init(arg_179_0, arg_179_1)
	arg_179_1 = arg_179_1 or {}
	arg_179_0.vars = {}
	arg_179_0.vars.url = arg_179_1.url
	arg_179_0.vars.state = arg_179_1.state
	arg_179_0.vars.scheduler_name = "api_url_" .. (arg_179_1.scene or "")
end

function ArenaWebSocket.start(arg_180_0, arg_180_1)
	arg_180_1 = arg_180_1 or {}
	arg_180_0.vars.websocket = cc.WebSocket:createByCAFile(arg_180_0.vars.url, cc.FileUtils:getInstance():fullPathForFilename("ssl/cacert.pem"))
	arg_180_1.open = arg_180_1.open or function(...)
		arg_180_0:onOpen(...)
	end
	arg_180_1.msg = arg_180_1.msg or function(...)
		arg_180_0:onMessage(...)
	end
	arg_180_1.close = arg_180_1.close or function(...)
		arg_180_0:onClose(...)
	end
	arg_180_1.error = arg_180_1.error or function(...)
		arg_180_0:onError(...)
	end
	
	arg_180_0.vars.websocket:registerScriptHandler(arg_180_1.open, cc.WEBSOCKET_OPEN)
	arg_180_0.vars.websocket:registerScriptHandler(arg_180_1.msg, cc.WEBSOCKET_MESSAGE)
	arg_180_0.vars.websocket:registerScriptHandler(arg_180_1.close, cc.WEBSOCKET_CLOSE)
	arg_180_0.vars.websocket:registerScriptHandler(arg_180_1.error, cc.WEBSOCKET_ERROR)
end

function ArenaWebSocket.createSingleShotWebSocket(arg_185_0, arg_185_1)
	arg_185_1 = arg_185_1 or {}
	arg_185_0.vars = {}
	arg_185_0.vars.url = arg_185_1.url
	arg_185_0.vars.scheduler_name = "api_url_" .. (arg_185_1.scene or "")
	arg_185_0.vars.reserve_data = arg_185_1.data
	
	arg_185_0:start({
		open = function(...)
			arg_185_0:onSingleShotOpen(...)
		end,
		msg = function(...)
			arg_185_0:reset(...)
		end,
		error = function(...)
			arg_185_0:reset(...)
		end
	})
end

function ArenaWebSocket.onSingleShotOpen(arg_189_0)
	arg_189_0.vars.connected = true
	arg_189_0.vars.scheduler = Scheduler:addGlobalInterval(200, arg_189_0.onSingleShotUpdate, arg_189_0)
	
	arg_189_0.vars.scheduler:setName(arg_189_0.vars.scheduler_name)
end

function ArenaWebSocket.onSingleShotUpdate(arg_190_0)
	if not arg_190_0.vars.reserve_data then
		return 
	end
	
	arg_190_0:send(arg_190_0.vars.reserve_data)
	
	arg_190_0.vars.reserve_data = nil
end

function ArenaWebSocket.reset(arg_191_0)
	Scheduler:removeByName(arg_191_0.vars.scheduler_name)
	
	if arg_191_0.vars.websocket then
		arg_191_0.vars.websocket:asyncClose()
	end
	
	arg_191_0.vars = nil
end

function ArenaWebSocket.send(arg_192_0, arg_192_1)
	if not arg_192_0.vars or not arg_192_1 then
		return 
	end
	
	local var_192_0 = json.encode(arg_192_1)
	
	arg_192_0.vars.websocket:sendString(var_192_0)
end

function ArenaWebSocket.update(arg_193_0)
	if not arg_193_0.vars or not arg_193_0.vars.websocket or not arg_193_0.vars.connected then
		return 
	end
	
	if not arg_193_0.vars.state then
		return 
	end
	
	local var_193_0 = arg_193_0.vars.state:getBroadCastData()
	
	if var_193_0 then
		arg_193_0:send(var_193_0)
	end
end

function ArenaWebSocket.onOpen(arg_194_0)
	print("arena websocket opened")
	
	arg_194_0.vars.connected = true
	arg_194_0.vars.scheduler = Scheduler:addGlobalInterval(200, arg_194_0.update, arg_194_0)
	
	arg_194_0.vars.scheduler:setName(arg_194_0.vars.scheduler_name)
end

function ArenaWebSocket.onMessage(arg_195_0, arg_195_1)
	print("arena websocket message")
end

function ArenaWebSocket.onClose(arg_196_0, ...)
	print("arena websocket closed")
	
	local var_196_0 = {
		...
	}
	
	if arg_196_0.vars then
		arg_196_0.vars.connected = false
		arg_196_0.vars.websocket = nil
	end
end

function ArenaWebSocket.onError(arg_197_0, ...)
	print("arena websocket error")
	
	if arg_197_0.vars then
		arg_197_0.vars.connected = false
	end
end

function ArenaWebSocket.save(arg_198_0, arg_198_1, arg_198_2)
	if not PRODUCTION_MODE and PLATFORM == "win32" then
		local var_198_0 = json.encode(arg_198_2)
		
		io.writefile(getenv("app.data_path") .. arg_198_1, var_198_0)
	end
end

BroadCastHelper = {}

function BroadCastHelper.make_accumulate_preban_info(arg_199_0)
	local var_199_0 = {}
	
	if arg_199_0 and arg_199_0.rounds then
		local var_199_1 = table.count(arg_199_0.rounds) - 1
		
		for iter_199_0 = 1, var_199_1 do
			local var_199_2 = arg_199_0.rounds[iter_199_0] or {}
			
			for iter_199_1, iter_199_2 in pairs(var_199_2.preban or {}) do
				for iter_199_3, iter_199_4 in pairs(iter_199_2 or {}) do
					var_199_0[iter_199_1] = var_199_0[iter_199_1] or {}
					
					table.insert(var_199_0[iter_199_1], {
						code = iter_199_4.code,
						set_group = iter_199_4.set_group
					})
				end
			end
		end
	end
	
	return var_199_0
end

function BroadCastHelper.get_device_info()
	local var_200_0 = ArenaService:getUserInfo()
	local var_200_1 = ""
	local var_200_2 = ""
	
	if var_200_0 then
		var_200_1 = var_200_0.world or ""
		var_200_2 = var_200_0.name or ""
	end
	
	return string.format("%s@%s", var_200_1, var_200_2)
end

local function var_0_3(arg_201_0, arg_201_1)
	for iter_201_0 = 1, 4 do
		if arg_201_0.units[iter_201_0] and arg_201_0.units[iter_201_0].unit then
			arg_201_0.units[iter_201_0].unit.id = iter_201_0 + (arg_201_1 - 1)
			arg_201_0.units[iter_201_0].unit.h = nil
			arg_201_0.units[iter_201_0].unit.ca = nil
			arg_201_0.units[iter_201_0].unit.cat = nil
		end
	end
end

DummyService = {}

copy_functions(ArenaService, DummyService)

function DummyService.init(arg_202_0, arg_202_1, arg_202_2)
	arg_202_2 = arg_202_2 or {}
	arg_202_0.vars = {}
	arg_202_0.vars.battle_info = arg_202_1
	arg_202_0.vars.enable_rta_penalty = arg_202_2.enable_rta_penalty
	arg_202_0.vars.state_machine = table.clone(SERVICE_STATE)
	arg_202_0.vars.cur_state = "BATTLE"
	
	arg_202_0:removeSchedules()
end

function DummyService.clear(arg_203_0)
	arg_203_0.vars = nil
end

function DummyService.removeSchedules(arg_204_0)
	Scheduler:removeByName("battle.dummyplay")
	Scheduler:removeByName("battle.background")
end

function DummyService.isActive(arg_205_0)
	return arg_205_0.vars ~= nil
end

function DummyService.isDummy(arg_206_0)
	return true
end

function DummyService.isEnableRtaPenalty(arg_207_0)
	return arg_207_0.vars.enable_rta_penalty
end

function DummyService.isAllowPauseGame(arg_208_0)
	return false
end

function DummyService.cheat(arg_209_0, arg_209_1, arg_209_2)
	if PLATFORM ~= "win32" then
		return 
	end
	
	Log.e("전투 서버 <-> 클라이언트 view sync")
	arg_209_0.vars.logic:onInfos({
		type = "all"
	})
	
	local var_209_0 = arg_209_0.vars.logic.view_logger:popAll()
	
	Battle.viewer:applySnapData(var_209_0[1])
	Battle.viewer:updateViewState({})
end

function DummyService.start(arg_210_0, arg_210_1)
	arg_210_1 = arg_210_1 or {}
	
	if arg_210_1.is_ai_mode then
		arg_210_0:ai(arg_210_1)
		SceneManager:nextScene("battle", {
			logic = arg_210_0.vars.logic,
			service = arg_210_0
		})
	elseif arg_210_1.is_draft_mode then
		arg_210_0:draft(arg_210_1)
		SceneManager:nextScene("battle", {
			logic = arg_210_0.vars.logic,
			service = arg_210_0
		})
	elseif arg_210_1.is_simulate_mode then
		arg_210_0:simulate(arg_210_1)
	elseif arg_210_1.is_normal_pvp then
		arg_210_0:makeLocalBattle(arg_210_1)
		SceneManager:nextScene("battle", {
			logic = arg_210_0.vars.logic
		})
	else
		arg_210_0:makeNetBattle(arg_210_1)
		SceneManager:nextScene("battle", {
			logic = arg_210_0.vars.client_logic,
			service = arg_210_0,
			mode = arg_210_1.mode,
			records = arg_210_0.vars.logic.view_history[1]
		})
	end
end

function DummyService.ai(arg_211_0, arg_211_1)
	local var_211_0 = BattleLogic:make_template_team(arg_211_1.ai_info[FRIEND], 1)
	local var_211_1 = BattleLogic:make_template_team(arg_211_1.ai_info[ENEMY], 5)
	local var_211_2 = gen_pvp_map(var_211_1, arg_211_1.seed1, arg_211_1.seed2)
	
	var_211_2.select_map_data = {}
	arg_211_0.vars.logic = BattleLogic:makeLogic(var_211_2, var_211_0, {
		home_arena_uid = "1234",
		mode = "pvp",
		away_arena_uid = "5678",
		dual_control = arg_211_1.is_dual_control
	})
end

function DummyService.draft(arg_212_0, arg_212_1)
	local var_212_0 = BattleLogic:make_draft_team(arg_212_1.ai_info[FRIEND], 1)
	local var_212_1 = BattleLogic:make_draft_team(arg_212_1.ai_info[ENEMY], 5)
	local var_212_2 = gen_pvp_map(var_212_1, arg_212_1.seed1, arg_212_1.seed2)
	
	var_212_2.select_map_data = {}
	arg_212_0.vars.logic = BattleLogic:makeLogic(var_212_2, var_212_0, {
		home_arena_uid = "1234",
		mode = "pvp",
		away_arena_uid = "5678",
		dual_control = arg_212_1.is_dual_control
	})
end

function DummyService.makeLocalBattle(arg_213_0, arg_213_1)
	local var_213_0 = table.clone(arg_213_0.vars.battle_info.team1)
	local var_213_1 = table.clone(arg_213_0.vars.battle_info.team2)
	
	var_0_3(var_213_0, 1)
	var_0_3(var_213_1, 5)
	
	local var_213_2 = gen_pvp_map(var_213_1, arg_213_1.seed1, arg_213_1.seed2)
	
	var_213_2.select_map_data = {}
	arg_213_0.vars.logic = BattleLogic:makeLogic(var_213_2, var_213_0, {
		mode = "pvp",
		dual_control = arg_213_1.is_dual_control
	})
end

function DummyService.makeNetBattle(arg_214_0, arg_214_1)
	local var_214_0 = table.clone(arg_214_0.vars.battle_info.team1)
	local var_214_1 = table.clone(arg_214_0.vars.battle_info.team2)
	local var_214_2 = arg_214_1.world_arena_season_id or getArenaNetSeasonId()
	
	var_0_3(var_214_0, 1)
	var_0_3(var_214_1, 5)
	
	local var_214_3 = gen_pvp_map(var_214_1, arg_214_1.seed1, arg_214_1.seed2)
	
	var_214_3.select_map_data = {}
	arg_214_0.vars.logic = BattleLogic:makeLogic(var_214_3, var_214_0, {
		mode = "net_server",
		home_arena_uid = 1234,
		away_arena_uid = 5678,
		service = arg_214_0,
		rta_passive_info = arg_214_1.cs_info,
		dual_control = arg_214_1.is_dual_control,
		world_arena_season_id = var_214_2
	})
	arg_214_0.vars.logic.getTotalHitCount = BattleLogic.getTotalHitCount
	
	arg_214_0.vars.logic:command({
		cmd = "TestRunRoadEvent",
		road_event_id = "rta00100_1"
	})
	arg_214_0.vars.logic:procinfos()
	
	arg_214_0.vars.server_logic = arg_214_0.vars.logic
	arg_214_0.vars.client_logic = BattleLogic:makeLogic(var_214_3, var_214_0, {
		mode = arg_214_1.mode,
		service = arg_214_0,
		rta_passive_info = arg_214_1.cs_info,
		dual_control = arg_214_1.is_dual_control,
		world_arena_season_id = var_214_2
	})
	
	Log.e("SEED INFO", var_214_2, var_214_3.seed, var_214_3.logic_seed)
end

function DummyService.simulate(arg_215_0, arg_215_1)
	balloon_message_with_sound("시뮬레이트는 현재 지원되지 않는 기능입니다.(체크해제)")
end

function DummyService.query(arg_216_0, arg_216_1, arg_216_2)
	local function var_216_0(arg_217_0, arg_217_1)
		local var_217_0 = arg_217_0:getUnit(arg_217_1.attacker)
		local var_217_1 = arg_217_0:getUnit(arg_217_1.target)
		local var_217_2
		local var_217_3
		
		if arg_217_0:getTurnOwner() ~= var_217_0 then
			return 
		end
		
		if not var_217_0 or not var_217_1 then
			return 
		end
		
		local var_217_4 = var_217_0:getSkillBundle():slot(arg_217_1.skill_idx)
		local var_217_5 = var_217_4:getSkillId()
		
		if var_217_4 and arg_217_1.is_soul then
			local var_217_6 = var_217_0:getSkillDB(var_217_5, "soulburn_skill")
			local var_217_7 = DB("skill", var_217_6, {
				"soul_req"
			})
			local var_217_8 = arg_217_0:getTeamRes(var_217_0.inst.ally, "soul_piece") or 0
			local var_217_9 = var_217_0.states:isExistEffect("CSP_FREE_SOULBURN")
			
			if var_217_6 and var_217_7 and (var_217_7 <= var_217_8 or var_217_9) then
				var_217_5 = var_217_6
			else
				return 
			end
		end
		
		if var_217_4 and var_217_5 and var_217_4:getOwner() and var_217_4:checkUseSkill() then
			print("USE SKILL", var_217_5)
			arg_217_0:onStartSkill(arg_217_1.attacker, var_217_5, arg_217_1.target)
			arg_217_0:procinfos()
		end
	end
	
	if arg_216_2.type == "skill" then
		var_216_0(arg_216_0.vars.logic, arg_216_2)
	elseif arg_216_2.type == "giveup" then
		arg_216_0:clear()
		SceneManager:nextScene("lobby")
	end
end
