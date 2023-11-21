ArenaNetRoundResult = {}

function HANDLER.pvplive_mock_round_end(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ok" then
		ArenaNetRoundResult:next()
	end
end

function dummySave()
	if not ArenaNetRoundResult.vars then
		return 
	end
	
	local var_2_0 = {
		match_info = ArenaNetRoundResult.vars.match_info,
		result = ArenaNetRoundResult.vars.result
	}
	local var_2_1 = json.encode(var_2_0)
	
	Log.i("save local to json", string.len(var_2_1))
	
	local var_2_2 = "/result_data"
	
	io.writefile(getenv("app.data_path") .. var_2_2, var_2_1)
end

function dummyLoad()
	local function var_3_0(arg_4_0)
		local var_4_0 = arg_4_0:seek()
		local var_4_1 = arg_4_0:seek("end")
		
		arg_4_0:seek("set", var_4_0)
		
		return var_4_1
	end
	
	local var_3_1 = getenv("app.data_path") .. "/result_data"
	local var_3_2 = io.open(var_3_1):read("*a")
	local var_3_3 = json.decode(var_3_2)
	
	var_3_3.ignore_service = true
	
	ArenaNetRoundResult:show(nil, var_3_3)
end

function ArenaNetRoundResult.show(arg_5_0, arg_5_1, arg_5_2)
	arg_5_2 = arg_5_2 or {}
	
	if not arg_5_2.ignore_service and ArenaService:isReset() and ArenaService:getMatchMode() ~= "net_event_rank" then
		TransitionScreen:hide()
		UIAction:Remove("block")
		Dialog:msgBox(T("game_connect_lost") .. generateErrCode(CON_ERR.UNKNOWN), {
			handler = function()
				SceneManager:nextScene("lobby")
				SceneManager:resetSceneFlow()
			end
		})
		
		return 
	end
	
	arg_5_0.vars = {}
	arg_5_0.vars.result = arg_5_2.result
	arg_5_0.vars.match_info = arg_5_2.match_info
	arg_5_0.vars.final_winner = arg_5_2.final_winner or arg_5_0.vars.result.final_winner
	arg_5_0.vars.user_uid = arg_5_0.vars.match_info.user_info.uid
	arg_5_0.vars.enemy_uid = arg_5_0.vars.match_info.enemy_user_info.uid
	arg_5_0.vars.wnd = load_dlg("pvplive_mock_round_end", true, "wnd")
	arg_5_0.vars.parent = arg_5_1 or SceneManager:getDefaultLayer()
	
	arg_5_0.vars.parent:addChild(arg_5_0.vars.wnd)
	arg_5_0:checkWinner()
	arg_5_0:cache()
	arg_5_0:initUI()
	SAVE:setKeep("net_arena_join_info", nil)
	LuaEventDispatcher:removeEventListenerByKey("arena.service.next_round")
	LuaEventDispatcher:addEventListener("arena.service.req", LISTENER(ArenaNetRoundNext.onRequest, arg_5_0), "arena.service.next_round")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetRoundNext.onResponse, arg_5_0), "arena.service.next_round")
	
	if MatchService:isBroadCastMode() then
		local var_5_0 = MatchService:getBroadCastUrl("result")
		
		if var_5_0 then
			ArenaService:resetWebSocket()
			
			arg_5_0.web_sock = ArenaWebSocket:create({
				scene = "result",
				url = var_5_0,
				state = arg_5_0
			})
			
			arg_5_0.web_sock:start()
		end
	end
	
	if Battle.viewer and Battle.viewer:checkSaveLocalReplay(arg_5_0.vars.result) then
		Battle.viewer:saveReplay(arg_5_0.vars.result.replay_data, true)
	end
end

function ArenaNetRoundResult.Enter(arg_7_0)
end

function ArenaNetRoundResult.isShow(arg_8_0)
	return arg_8_0.vars and get_cocos_refid(arg_8_0.vars.base_wnd)
end

function ArenaNetRoundResult.onLeave(arg_9_0)
	if get_cocos_refid(arg_9_0.vars.base_wnd) then
		UIAction:Add(SEQ(DELAY(80), FADE_OUT(200), SHOW(false), DELAY(40), CALL(arg_9_0.destroy, arg_9_0)), arg_9_0.vars.base_wnd, "block")
	end
end

function ArenaNetRoundResult.destroy(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if arg_10_0.web_sock then
		arg_10_0.web_sock:reset()
		
		arg_10_0.web_sock = nil
	end
	
	if get_cocos_refid(arg_10_0.vars.base_wnd) then
		arg_10_0.vars.base_wnd:removeFromParent()
	end
	
	arg_10_0.vars = nil
end

function ArenaNetRoundResult.cache(arg_11_0)
	arg_11_0.vars.win_node = arg_11_0.vars.wnd:getChildByName("n_winner")
	arg_11_0.vars.draw_node = arg_11_0.vars.wnd:getChildByName("n_draw")
	arg_11_0.vars.bottom_node = arg_11_0.vars.wnd:getChildByName("n_bottom")
	arg_11_0.vars.event_node = arg_11_0.vars.wnd:getChildByName("n_event")
	arg_11_0.vars.n_bg = arg_11_0.vars.wnd:getChildByName("bg")
	arg_11_0.vars.n_portrait = arg_11_0.vars.win_node:getChildByName("n_portrait")
	arg_11_0.vars.n_winner_info = arg_11_0.vars.win_node:getChildByName("n_winner_info")
	arg_11_0.vars.n_player1_info = arg_11_0.vars.draw_node:getChildByName("n_player1")
	arg_11_0.vars.n_player2_info = arg_11_0.vars.draw_node:getChildByName("n_player2")
	arg_11_0.vars.n_player1 = arg_11_0.vars.bottom_node:getChildByName("n_player1")
	arg_11_0.vars.n_player2 = arg_11_0.vars.bottom_node:getChildByName("n_player2")
end

function ArenaNetRoundResult.initUI(arg_12_0)
	if ArenaService:getMatchMode() ~= "net_event_rank" then
		arg_12_0.vars.win_node:setVisible(arg_12_0.vars.win_result ~= "draw")
		arg_12_0.vars.draw_node:setVisible(arg_12_0.vars.win_result == "draw")
		arg_12_0.vars.event_node:setVisible(false)
		
		if arg_12_0.vars.win_result == "draw" then
			arg_12_0:updateBG()
			arg_12_0:updateDrawInfo(arg_12_0.vars.n_player1_info, arg_12_0.vars.user_uid, arg_12_0.vars.enemy_uid)
			arg_12_0:updateDrawInfo(arg_12_0.vars.n_player2_info, arg_12_0.vars.enemy_uid, arg_12_0.vars.user_uid)
			arg_12_0:updateUserInfo(arg_12_0.vars.n_player1, arg_12_0.vars.match_info.user_info)
			arg_12_0:updateUserInfo(arg_12_0.vars.n_player2, arg_12_0.vars.match_info.enemy_user_info)
			if_set_visible(arg_12_0.vars.wnd, "n_no_result", true)
			EffectManager:Play({
				y = -120,
				fn = "ui_rta_result_draw_eff.cfx",
				layer = arg_12_0.vars.draw_node:getChildByName("n_eff")
			})
		else
			arg_12_0:updateBG()
			arg_12_0:updateWinnerInfo(arg_12_0.vars.n_winner_info, arg_12_0.vars.user_uid, arg_12_0.vars.enemy_uid)
			arg_12_0:updateUserInfo(arg_12_0.vars.n_player1, arg_12_0.vars.match_info.user_info)
			arg_12_0:updateUserInfo(arg_12_0.vars.n_player2, arg_12_0.vars.match_info.enemy_user_info)
			if_set_visible(arg_12_0.vars.wnd, "n_no_result", false)
			EffectManager:Play({
				y = -120,
				fn = "ui_rta_result_win_eff.cfx",
				layer = arg_12_0.vars.win_node:getChildByName("n_eff")
			})
		end
	else
		arg_12_0.vars.win_node:setVisible(false)
		arg_12_0.vars.draw_node:setVisible(false)
		arg_12_0.vars.event_node:setVisible(true)
		if_set_visible(arg_12_0.vars.bottom_node, "n_winner", false)
		arg_12_0:updateBG()
		arg_12_0:updateEventMatchInfo(arg_12_0.vars.event_node)
	end
end

function ArenaNetRoundResult.checkWinner(arg_13_0)
	local var_13_0 = 0
	local var_13_1 = 0
	local var_13_2 = 0
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.result.round_info.rounds or {}) do
		if iter_13_1.winner == arg_13_0.vars.user_uid then
			var_13_0 = var_13_0 + 1
		elseif iter_13_1.winner == arg_13_0.vars.enemy_uid then
			var_13_2 = var_13_2 + 1
		else
			var_13_1 = var_13_1 + 1
		end
	end
	
	if arg_13_0.vars.final_winner then
		if arg_13_0.vars.final_winner == "draw" then
			arg_13_0.vars.win_result = "draw"
		elseif arg_13_0.vars.user_uid == arg_13_0.vars.final_winner then
			arg_13_0.vars.win_result = "win"
			arg_13_0.vars.winner_info = arg_13_0.vars.match_info.user_info
		else
			arg_13_0.vars.win_result = "lose"
			arg_13_0.vars.winner_info = arg_13_0.vars.match_info.enemy_user_info
		end
	elseif var_13_0 == var_13_2 then
		arg_13_0.vars.win_result = "draw"
		arg_13_0.vars.winner_info = nil
	elseif var_13_2 < var_13_0 then
		arg_13_0.vars.win_result = "win"
		arg_13_0.vars.winner_info = arg_13_0.vars.match_info.user_info
	else
		arg_13_0.vars.win_result = "lose"
		arg_13_0.vars.winner_info = arg_13_0.vars.match_info.enemy_user_info
	end
end

function ArenaNetRoundResult.updateBG(arg_14_0)
	local var_14_0
	
	if ArenaService:getMatchMode() == "net_event_rank" then
		local var_14_1 = arg_14_0.vars.result.season_id .. "00"
		local var_14_2, var_14_3 = DB("level_stage_1_info", var_14_1, {
			"image",
			"ambient_color"
		})
		
		var_14_0 = {
			bg_id = var_14_2,
			ambient_color = var_14_3
		}
	else
		local var_14_4 = arg_14_0.vars.result.bg_id or SAVE:get("net_arena_lounge_bg") or "ma_bg_pet_base"
		
		if not var_14_4 then
			return 
		end
		
		var_14_0 = makeBGItem(var_14_4)
	end
	
	if var_14_0 then
		local var_14_5, var_14_6 = FIELD_NEW:create(var_14_0.bg_id, DESIGN_WIDTH * 2)
		
		var_14_5:setAnchorPoint(0.5, 0.5)
		var_14_5:setPosition(0, 0)
		var_14_5:setScale(1)
		var_14_6:setViewPortPosition(VIEW_WIDTH / 2)
		var_14_6:updateViewport()
		arg_14_0.vars.n_bg:addChild(var_14_5)
	end
end

function ArenaNetRoundResult.updateDrawInfo(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.vars.result.round_info or {}
	local var_15_1 = 0
	local var_15_2 = 0
	local var_15_3 = 0
	local var_15_4 = 0
	
	for iter_15_0 = 1, 7 do
		local var_15_5 = var_15_0.rounds[iter_15_0]
		local var_15_6 = arg_15_1:getChildByName("round" .. tostring(iter_15_0))
		
		if var_15_5 then
			if_set_visible(var_15_6, nil, true)
			
			if var_15_5.winner == arg_15_2 then
				var_15_2 = var_15_2 + 1
				
				SpriteCache:resetSprite(var_15_6, "img/battle_pvp_icon_win.png")
			elseif var_15_5.winner == arg_15_3 then
				var_15_3 = var_15_3 + 1
				
				SpriteCache:resetSprite(var_15_6, "img/battle_pvp_icon_lose.png")
			else
				var_15_4 = var_15_4 + 1
				
				SpriteCache:resetSprite(var_15_6, "img/battle_pvp_icon_draw.png")
			end
			
			var_15_1 = var_15_1 + 1
		elseif iter_15_0 <= var_15_0.total then
			if_set_opacity(var_15_6, nil, 76.5)
			SpriteCache:resetSprite(var_15_6, "img/icon_menu_x.png")
		else
			if_set_visible(var_15_6, nil, false)
		end
	end
	
	if_set(arg_15_1, "txt_win_info", T("pvp_rta_wdl", {
		win = var_15_2,
		draw = var_15_4,
		lose = var_15_3
	}))
	
	if var_15_0.total == 1 then
		if_set_add_position_x(arg_15_1, "n_round_info", 115)
		if_set_add_position_x(arg_15_1, "txt_win_info", -115)
	elseif var_15_0.total == 3 then
		if_set_add_position_x(arg_15_1, "n_round_info", 75)
		if_set_add_position_x(arg_15_1, "txt_win_info", -75)
	elseif var_15_0.total == 5 then
		if_set_add_position_x(arg_15_1, "n_round_info", 35)
		if_set_add_position_x(arg_15_1, "txt_win_info", -35)
	end
	
	local var_15_7
	
	if arg_15_2 == arg_15_0.vars.match_info.user_info.uid then
		var_15_7 = arg_15_0.vars.match_info.user_info
	else
		var_15_7 = arg_15_0.vars.match_info.enemy_user_info
	end
	
	if var_15_7 then
		local var_15_8 = (var_15_7.win or 0) + (var_15_7.draw or 0) + (var_15_7.lose or 0) < ARENA_MATCH_BATCH_COUNT
		
		if_set(arg_15_1, "txt_name", check_abuse_filter(var_15_7.name, ABUSE_FILTER.WORLD_NAME) or var_15_7.name)
		if_set(arg_15_1, "txt_nation", getRegionText(var_15_7.world))
		if_set(arg_15_1, "txt_clan", clanNameFilter(var_15_7.clan_name))
		UIUtil:updateClanEmblem(arg_15_1:getChildByName("n_clan"), {
			emblem = var_15_7.clan_emblem
		})
		if_set_visible(arg_15_1, "n_clan", string.len(var_15_7.clan_name or "") > 0)
		UIUtil:getUserIcon(var_15_7.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_15_1:getChildByName("n_face"),
			border_code = var_15_7.border_code
		})
		
		if var_15_8 then
			SpriteCache:resetSprite(arg_15_1:getChildByName("t_emblem"), "emblem/" .. ARENA_UNRANK_ICON)
		else
			local var_15_9, var_15_10 = getArenaNetRankInfo(arg_15_0.vars.result.season_id, var_15_7.league_id)
			
			SpriteCache:resetSprite(arg_15_1:getChildByName("t_emblem"), "emblem/" .. var_15_10 .. ".png")
		end
	end
end

function ArenaNetRoundResult.updateWinnerInfo(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_0.vars.result.round_info or {}
	local var_16_1 = arg_16_0.vars.winner_info
	local var_16_2 = 0
	local var_16_3 = 0
	local var_16_4 = 0
	local var_16_5 = 0
	local var_16_6
	
	for iter_16_0 = 1, 7 do
		local var_16_7 = var_16_0.rounds[iter_16_0]
		local var_16_8 = arg_16_1:getChildByName("round" .. tostring(iter_16_0))
		
		if var_16_7 then
			if_set_visible(var_16_8, nil, true)
			
			if var_16_7.winner == "draw" then
				var_16_5 = var_16_5 + 1
				
				SpriteCache:resetSprite(var_16_8, "img/battle_pvp_icon_draw.png")
			elseif var_16_7.winner == var_16_1.uid then
				var_16_3 = var_16_3 + 1
				
				SpriteCache:resetSprite(var_16_8, "img/battle_pvp_icon_win.png")
			else
				var_16_4 = var_16_4 + 1
				
				SpriteCache:resetSprite(var_16_8, "img/battle_pvp_icon_lose.png")
			end
			
			var_16_2 = var_16_2 + 1
			var_16_6 = var_16_7.pos
		elseif iter_16_0 <= var_16_0.total then
			if_set_opacity(var_16_8, nil, 76.5)
			SpriteCache:resetSprite(var_16_8, "img/icon_menu_x.png")
		else
			if_set_visible(var_16_8, nil, false)
		end
	end
	
	if_set(arg_16_1, "txt_win_info", T("pvp_rta_wdl", {
		win = var_16_3,
		draw = var_16_5,
		lose = var_16_4
	}))
	
	if var_16_0.total == 1 then
		if_set_add_position_x(arg_16_1, "n_round_info", 115)
		if_set_add_position_x(arg_16_1, "txt_win_info", -115)
	elseif var_16_0.total == 3 then
		if_set_add_position_x(arg_16_1, "n_round_info", 75)
		if_set_add_position_x(arg_16_1, "txt_win_info", -75)
	elseif var_16_0.total == 5 then
		if_set_add_position_x(arg_16_1, "n_round_info", 35)
		if_set_add_position_x(arg_16_1, "txt_win_info", -35)
	end
	
	if_set(arg_16_1, "txt_name", check_abuse_filter(var_16_1.name, ABUSE_FILTER.WORLD_NAME) or var_16_1.name)
	if_set(arg_16_1, "txt_nation", getRegionText(var_16_1.world))
	if_set(arg_16_1, "txt_clan", clanNameFilter(var_16_1.clan_name))
	UIUtil:updateClanEmblem(arg_16_1:getChildByName("n_clan"), {
		emblem = var_16_1.clan_emblem
	})
	if_set_visible(arg_16_1, "n_clan", string.len(var_16_1.clan_name or "") > 0)
	arg_16_0.vars.n_portrait:removeAllChildren()
	
	if var_16_6 == "BATTLE" then
		local var_16_9 = table.clone(arg_16_0.vars.result.pick_units[var_16_1.uid] or {})
		local var_16_10 = (arg_16_0.vars.result.ban_units[var_16_1.uid][1] or {}).code or ""
		local var_16_11 = table.find(var_16_9, function(arg_17_0, arg_17_1)
			return arg_17_1.code == var_16_10
		end)
		
		if var_16_11 then
			table.remove(var_16_9, var_16_11)
		end
		
		local var_16_12 = var_16_9[math.random(1, table.count(var_16_9))]
		
		if var_16_12 then
			arg_16_0:updatePortrait(var_16_12.skin_code or var_16_12.code, var_16_12.face_id)
		end
	else
		local var_16_13 = var_16_1.leader_code
		local var_16_14 = var_16_1.face_id
		
		if var_16_13 and var_16_14 then
			arg_16_0:updatePortrait(var_16_13, var_16_14)
		end
	end
end

function ArenaNetRoundResult.updateEventMatchInfo(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = arg_18_0.vars.result.round_info or {}
	local var_18_1 = arg_18_0.vars.winner_info
	local var_18_2 = arg_18_0.vars.result.round_result or {}
	local var_18_3 = 0
	local var_18_4 = 0
	local var_18_5 = 0
	local var_18_6 = 0
	local var_18_7
	
	for iter_18_0 = 1, 7 do
		local var_18_8 = var_18_0.rounds[iter_18_0]
		local var_18_9 = arg_18_1:getChildByName("round" .. tostring(iter_18_0))
		
		if var_18_8 then
			if_set_visible(var_18_9, nil, true)
			
			if var_18_8.winner == "draw" then
				var_18_6 = var_18_6 + 1
				
				SpriteCache:resetSprite(var_18_9, "img/battle_pvp_icon_draw.png")
			elseif var_18_8.winner == arg_18_0.vars.user_uid then
				var_18_4 = var_18_4 + 1
				
				SpriteCache:resetSprite(var_18_9, "img/battle_pvp_icon_win.png")
			else
				var_18_5 = var_18_5 + 1
				
				SpriteCache:resetSprite(var_18_9, "img/battle_pvp_icon_lose.png")
			end
			
			var_18_3 = var_18_3 + 1
			
			local var_18_10 = var_18_8.pos
		elseif iter_18_0 <= var_18_0.total then
			if_set_opacity(var_18_9, nil, 76.5)
			SpriteCache:resetSprite(var_18_9, "img/icon_menu_x.png")
		else
			if_set_visible(var_18_9, nil, false)
		end
	end
	
	if_set(arg_18_1, "txt_win_info", T("pvp_rta_wdl", {
		win = var_18_4,
		draw = var_18_6,
		lose = var_18_5
	}))
	
	if var_18_0.total == 1 then
		if_set_add_position_x(arg_18_1, "n_round_info", 115)
		if_set_add_position_x(arg_18_1, "txt_win_info", -115)
	elseif var_18_0.total == 3 then
		if_set_add_position_x(arg_18_1, "n_round_info", 75)
		if_set_add_position_x(arg_18_1, "txt_win_info", -75)
	elseif var_18_0.total == 5 then
		if_set_add_position_x(arg_18_1, "n_round_info", 35)
		if_set_add_position_x(arg_18_1, "txt_win_info", -35)
	end
	
	local var_18_11
	
	if tostring(var_18_2.home_user_end_info.id) == arg_18_0.vars.user_uid then
		var_18_11 = var_18_2.home_user_end_info
	elseif tostring(var_18_2.away_user_end_info.id) == arg_18_0.vars.user_uid then
		var_18_11 = var_18_2.away_user_end_info
	end
	
	local var_18_12 = to_n(var_18_11.old_score)
	local var_18_13 = to_n(var_18_11.new_score)
	local var_18_14 = to_n(var_18_13 - var_18_12)
	local var_18_15 = arg_18_1:getChildByName("t_count")
	local var_18_16 = arg_18_1:getChildByName("icon")
	
	if var_18_14 == 0 then
		var_18_15:setString("-")
	else
		var_18_15:setString(tostring(var_18_14))
	end
	
	if var_18_14 == 0 then
		local var_18_17 = cc.c3b(255, 255, 195)
		
		var_18_15:setTextColor(var_18_17)
		var_18_15:setPositionX(643)
	elseif var_18_14 < 0 then
		local var_18_18 = cc.c3b(51, 122, 195)
		
		var_18_15:setTextColor(var_18_18)
		var_18_16:setColor(var_18_18)
	elseif var_18_14 > 0 then
		local var_18_19 = cc.c3b(107, 193, 27)
		
		var_18_15:setTextColor(var_18_19)
		var_18_16:setColor(var_18_19)
	end
	
	UIAction:Add(INC_NUMBER(800, var_18_13, false, 0), arg_18_1:getChildByName("txt_point"), "block")
	
	if var_18_14 == 0 then
		var_18_16:setVisible(false)
	elseif var_18_14 > 0 then
		var_18_16:setVisible(true)
	elseif var_18_14 < 0 then
		var_18_16:setVisible(true)
		var_18_16:setRotation(180)
		var_18_16:setColor(cc.c3b(0, 120, 255))
	else
		var_18_16:setVisible(false)
	end
	
	local var_18_20 = arg_18_1:getChildByName("n_eff")
	local var_18_21
	local var_18_22 = arg_18_0.vars.win_result == "win" and "ui_rta_result_win_eff.cfx" or arg_18_0.vars.win_result == "lose" and "ui_rta_result_lose_eff.cfx" or "ui_rta_result_draw_eff.cfx"
	
	EffectManager:Play({
		z = 99999,
		y = -140,
		scale = 1,
		fn = var_18_22,
		layer = var_18_20,
		action = BattleAction
	})
end

function ArenaNetRoundResult.updatePortrait(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_1 then
		return 
	end
	
	arg_19_2 = arg_19_2 or 0
	
	local var_19_0 = UNIT:create({
		code = arg_19_1
	})
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = DB("character", var_19_0:getDisplayCode(), "face_id")
	local var_19_2, var_19_3 = UIUtil:getPortraitAni(var_19_1)
	
	if var_19_2 then
		UnitMain:setMainUnitSkin(var_19_0:getDisplayCode(), var_19_2, arg_19_2)
		var_19_2:setScale(1.2)
		var_19_2:setPositionY(-600)
		arg_19_0.vars.n_portrait:addChild(var_19_2)
		ccexp.SoundEngine:playBattle("event:/model/" .. var_19_0.db.model_id .. "/ani/" .. "b_idle_ready")
		ccexp.SoundEngine:play("event:/voc/character/" .. var_19_0.db.model_id .. "/ani/" .. "b_idle_ready")
	end
	
	if not var_19_3 then
		var_19_2:setScale(1)
		var_19_2:setPositionY(100)
	end
end

function ArenaNetRoundResult.updateUserInfo(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2.league_id
	local var_20_1, var_20_2 = getArenaNetRankInfo(arg_20_0.vars.result.season_id, var_20_0)
	local var_20_3 = (arg_20_2.win or 0) + (arg_20_2.draw or 0) + (arg_20_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	UIUtil:getUserIcon(arg_20_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_20_1:getChildByName("n_face"),
		border_code = arg_20_2.border_code
	})
	if_set(arg_20_1, "txt_nation", getRegionText(arg_20_2.world))
	if_set(arg_20_1, "txt_name", check_abuse_filter(arg_20_2.name, ABUSE_FILTER.WORLD_NAME) or arg_20_2.name)
	
	if var_20_3 then
		SpriteCache:resetSprite(arg_20_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		SpriteCache:resetSprite(arg_20_1:getChildByName("emblem"), "emblem/" .. var_20_2 .. ".png")
	end
	
	if_set(arg_20_1, "txt_clan", clanNameFilter(arg_20_2.clan_name))
	UIUtil:updateClanEmblem(arg_20_1:getChildByName("n_clan"), {
		emblem = arg_20_2.clan_emblem
	})
	if_set_visible(arg_20_1, "n_clan", string.len(arg_20_2.clan_name or "") > 0)
	
	if string.len(arg_20_2.clan_name or "") <= 0 then
		if_set_add_position_y(arg_20_1, "txt_name", -14)
		if_set_add_position_y(arg_20_1, "n_server", 14)
		if_set_add_position_y(arg_20_1, "n_ping", 14)
	end
	
	if arg_20_0.vars.winner_info and arg_20_0.vars.winner_info.uid ~= arg_20_2.uid then
		arg_20_1:setColor(tocolor("#888888"))
	end
end

function ArenaNetRoundResult.next(arg_21_0)
	if arg_21_0.web_sock then
		arg_21_0.web_sock:reset()
		
		arg_21_0.web_sock = nil
	end
	
	if ArenaService:getMatchMode() == "net_event_rank" then
		MatchService:query("arena_net_enter_lobby", nil, function(arg_22_0)
			arg_22_0.mode = "VS_EVENT"
			
			SceneManager:nextScene("arena_net_lobby", arg_22_0)
			SceneManager:resetSceneFlow()
		end)
	else
		ArenaService:changeState("TRANS")
		SceneManager:resetSceneFlow()
	end
end

function ArenaNetRoundResult.getBroadCastData(arg_23_0)
	return ArenaNetRoundNext:getBroadCastData(arg_23_0.vars.match_info, arg_23_0.vars.result, arg_23_0.vars.win_result)
end
