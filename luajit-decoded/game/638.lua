ArenaNetRoundNext = {}

function HANDLER.pvplive_round_lounge(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_result" then
		ArenaNetRoundNext:result()
	elseif arg_1_1 == "btn_top_chat" then
		ArenaNetRoundNext:openChatBox()
	elseif arg_1_1 == "btn_esc" then
		ArenaNetRoundNext:exit()
	elseif arg_1_1 == "btn_go" then
		ArenaNetRoundNext:start()
	end
end

copy_functions(ScrollView, ArenaNetRoundNext)

function ArenaNetRoundNext.show(arg_2_0, arg_2_1, arg_2_2)
	arg_2_2 = arg_2_2 or {}
	
	if arg_2_2.service and arg_2_2.service:isReset() then
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
	
	arg_2_0.vars = {}
	arg_2_0.vars.service = arg_2_2.service
	arg_2_0.vars.infos = arg_2_2.infos
	arg_2_0.vars.user_id = arg_2_0.vars.service:getUserUID()
	arg_2_0.vars.home_uid = arg_2_0.vars.infos.user_info.uid
	arg_2_0.vars.enemy_uid = arg_2_0.vars.infos.enemy_user_info.uid
	arg_2_0.vars.is_host = arg_2_0.vars.infos.host == arg_2_0.vars.service:getUserUID()
	arg_2_0.vars.wnd = load_dlg("pvplive_round_lounge", true, "wnd")
	arg_2_0.vars.parent = arg_2_1 or SceneManager:getDefaultLayer()
	
	arg_2_0.vars.parent:addChild(arg_2_0.vars.wnd)
	
	if arg_2_0.vars.service then
		function arg_2_0.vars.service.onUpdate()
			arg_2_0:onUpdate()
		end
	end
	
	local var_2_0 = DB("pvp_rta_season", arg_2_0.vars.service:getSeasonId(), {
		"bgm_semi_lounge"
	}) or DB("pvp_rta_season_event", arg_2_0.vars.service:getSeasonId(), {
		"bgm_semi_lounge"
	})
	
	var_2_0 = var_2_0 or DB("pvp_rta_season_event", arg_2_0.vars.service:getSeasonId(), {
		"bgm_semi_lounge"
	}) or DB("pvp_rta_season_event", arg_2_0.vars.service:getSeasonId(), {
		"bgm_semi_lounge"
	})
	
	local var_2_1 = arg_2_0.vars.infos.bgm_id
	local var_2_2
	local var_2_3
	
	if var_2_1 then
		var_2_2 = MusicBox:getSong(var_2_1).streaming_id
		var_2_3 = var_2_2 and cc.FileUtils:getInstance():fullPathForFilename("bgm_ost/" .. var_2_2)
	end
	
	SoundEngine:playBGM(var_2_2 and var_2_3 or "event:/bgm/" .. (var_2_1 or var_2_0), nil, true)
	arg_2_0:cacheUI()
	arg_2_0:initUI()
	arg_2_0:updateUI()
	LuaEventDispatcher:removeEventListenerByKey("arena.service.next_round")
	LuaEventDispatcher:addEventListener("arena.service.req", LISTENER(ArenaNetRoundNext.onRequest, arg_2_0), "arena.service.next_round")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetRoundNext.onResponse, arg_2_0), "arena.service.next_round")
end

function ArenaNetRoundNext.Enter(arg_5_0)
end

function ArenaNetRoundNext.isShow(arg_6_0)
	return arg_6_0.vars and get_cocos_refid(arg_6_0.vars.wnd)
end

function ArenaNetRoundNext.onLeave(arg_7_0)
	if get_cocos_refid(arg_7_0.vars.wnd) then
		UIAction:Add(SEQ(DELAY(80), FADE_OUT(200), SHOW(false), DELAY(40), CALL(arg_7_0.destroy, arg_7_0)), arg_7_0.vars.wnd, "block")
	end
end

function ArenaNetRoundNext.destroy(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_8_0.vars.wnd) then
		arg_8_0.vars.wnd:removeFromParent()
	end
	
	arg_8_0.vars = nil
end

function ArenaNetRoundNext.onUpdate(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	local var_9_0 = {}
	
	arg_9_0.vars.service:query("watch", var_9_0)
end

function ArenaNetRoundNext.cacheUI(arg_10_0)
	arg_10_0.vars.n_go = arg_10_0.vars.wnd:getChildByName("btn_go")
	arg_10_0.vars.n_bg = arg_10_0.vars.wnd:getChildByName("n_bg")
	arg_10_0.vars.n_ready = arg_10_0.vars.wnd:getChildByName("n_get_ready")
	arg_10_0.vars.n_watching = arg_10_0.vars.wnd:getChildByName("n_watching")
	arg_10_0.vars.n_preban = arg_10_0.vars.wnd:getChildByName("n_pre_ben")
	arg_10_0.vars.n_countdown = arg_10_0.vars.wnd:getChildByName("n_countdown")
	arg_10_0.vars.n_player_info = arg_10_0.vars.wnd:getChildByName("n_player1_info")
	arg_10_0.vars.n_enemy_player_info = arg_10_0.vars.wnd:getChildByName("n_player2_info")
	arg_10_0.vars.n_player_result = arg_10_0.vars.wnd:getChildByName("n_result_player1")
	arg_10_0.vars.n_enemy_player_result = arg_10_0.vars.wnd:getChildByName("n_result_player2")
	arg_10_0.vars.n_round_info = arg_10_0.vars.wnd:getChildByName("n_round_info")
	arg_10_0.vars.n_player_slot = arg_10_0.vars.wnd:getChildByName("n_player1")
	arg_10_0.vars.n_enemy_player_slot = arg_10_0.vars.wnd:getChildByName("n_player2")
	arg_10_0.vars.btn_top_chat = arg_10_0.vars.wnd:getChildByName("btn_top_chat")
	arg_10_0.vars.btn_top_alram = arg_10_0.vars.wnd:getChildByName("btn_top_chat_alram")
	arg_10_0.vars.n_tip_chat = arg_10_0.vars.wnd:getChildByName("n_tip")
	arg_10_0.vars.n_tip_emoji = arg_10_0.vars.wnd:getChildByName("n_tip_emoji")
end

function ArenaNetRoundNext.update(arg_11_0, arg_11_1)
	if arg_11_1.cur_state ~= "NEXT_ROUND" then
		return 
	end
	
	arg_11_0.vars.infos.first_pick_selector = arg_11_1.first_pick_selector
	arg_11_0.vars.infos.first_pick_user = arg_11_1.first_pick_user
	arg_11_0.vars.infos.home_ready = arg_11_1.home_ready
	arg_11_0.vars.infos.away_ready = arg_11_1.away_ready
	arg_11_0.vars.infos.time_info = arg_11_1.time_info
	arg_11_0.vars.infos.ping_info = arg_11_1.pinginfo
end

function ArenaNetRoundNext.initUI(arg_12_0)
	local var_12_0 = arg_12_0.vars.service:getClearSceneName() == "battle"
	
	if_set_visible(arg_12_0.vars.wnd, "btn_result", var_12_0)
	
	if var_12_0 == false then
		local var_12_1 = arg_12_0.vars.wnd:getChildByName("n_bottom"):getChildByName("bar_on")
		
		if_set_add_position_x(var_12_1, nil, 209)
	end
	
	arg_12_0.vars.btn_top_chat:setVisible(arg_12_0.vars.service:getMatchMode() ~= "net_event_rank")
	arg_12_0:updateBG()
	arg_12_0:updateScore()
	arg_12_0:updatePrebanInfo()
	arg_12_0:updateUserInfo(arg_12_0.vars.n_player_info, arg_12_0.vars.infos.user_info)
	arg_12_0:updateUserInfo(arg_12_0.vars.n_enemy_player_info, arg_12_0.vars.infos.enemy_user_info)
	arg_12_0:updateModelInfo(arg_12_0.vars.n_player_slot, arg_12_0.vars.infos.user_info)
	arg_12_0:updateModelInfo(arg_12_0.vars.n_enemy_player_slot, arg_12_0.vars.infos.enemy_user_info, true)
	arg_12_0:updateRoundInfo(arg_12_0.vars.n_round_info, arg_12_0.vars.home_uid, arg_12_0.vars.enemy_uid)
	arg_12_0:updateResultInfo(arg_12_0.vars.n_player_result, arg_12_0.vars.home_uid, arg_12_0.vars.enemy_uid)
	arg_12_0:updateResultInfo(arg_12_0.vars.n_enemy_player_result, arg_12_0.vars.enemy_uid, arg_12_0.vars.home_uid)
end

function ArenaNetRoundNext.updateBG(arg_13_0)
	local var_13_0
	
	if arg_13_0.vars.service:getMatchMode() == "net_event_rank" then
		local var_13_1 = arg_13_0.vars.service:getSeasonId() .. "00"
		local var_13_2, var_13_3 = DB("level_stage_1_info", var_13_1, {
			"image",
			"ambient_color"
		})
		
		var_13_0 = {
			bg_id = var_13_2,
			ambient_color = var_13_3
		}
	else
		local var_13_4 = arg_13_0.vars.infos.result.bg_id or SAVE:get("net_arena_lounge_bg") or "ma_bg_pet_base"
		
		if not var_13_4 then
			return 
		end
		
		var_13_0 = makeBGItem(var_13_4)
	end
	
	if var_13_0 then
		local var_13_5, var_13_6 = FIELD_NEW:create(var_13_0.bg_id, DESIGN_WIDTH * 2)
		
		var_13_5:setAnchorPoint(0.5, 0.5)
		var_13_5:setPosition(0, -(DESIGN_HEIGHT * 0.5))
		var_13_5:setScale(1)
		var_13_6:setViewPortPosition(VIEW_WIDTH / 2)
		var_13_6:updateViewport()
		arg_13_0.vars.n_bg:addChild(var_13_5)
		
		local var_13_7 = cc.c3b(255, 255, 255)
		
		if var_13_0.ambient_color then
			local var_13_8 = tonumber(string.sub(var_13_0.ambient_color, 1, 2), 16)
			local var_13_9 = tonumber(string.sub(var_13_0.ambient_color, 3, 4), 16)
			local var_13_10 = tonumber(string.sub(var_13_0.ambient_color, 5, 6), 16)
			
			var_13_7 = cc.c3b(var_13_8, var_13_9, var_13_10)
		end
		
		arg_13_0:applyAmbient(var_13_7)
	end
end

function ArenaNetRoundNext.applyAmbient(arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs({
		arg_14_0.vars.n_player_slot,
		arg_14_0.vars.n_enemy_player_slot
	}) do
		local var_14_0 = iter_14_1:getChildByName("n_pos1_character") or iter_14_1:getChildByName("n_pos2_character")
		
		if var_14_0 and get_cocos_refid(var_14_0.model) then
			var_14_0.model:setColor(arg_14_1)
		end
	end
end

function ArenaNetRoundNext.updateScore(arg_15_0)
	local var_15_0 = arg_15_0.vars.infos.round_info
	local var_15_1 = 0
	local var_15_2 = 0
	
	for iter_15_0, iter_15_1 in pairs(var_15_0.rounds or {}) do
		if iter_15_1.state == "finish" or iter_15_1.state == "benefit" then
			if iter_15_1.winner == arg_15_0.vars.home_uid then
				var_15_1 = var_15_1 + 1
			elseif iter_15_1.winner == arg_15_0.vars.enemy_uid then
				var_15_2 = var_15_2 + 1
			end
		end
	end
	
	local var_15_3 = true
	
	if arg_15_0.vars.user_id == arg_15_0.vars.enemy_uid then
		var_15_3 = false
	end
	
	local var_15_4 = tostring(var_15_3 and var_15_1 or var_15_2) .. " : " .. tostring(var_15_3 and var_15_2 or var_15_1)
	
	if_set(arg_15_0.vars.wnd, "t_score", var_15_4)
end

function ArenaNetRoundNext.updatePrebanInfo(arg_16_0)
	arg_16_0.vars.scrollview = arg_16_0.vars.wnd:getChildByName("scroll_view_preban")
	arg_16_0.vars.scrollview.STRETCH_INFO = nil
	
	if arg_16_0.vars.service:getClearSceneName() ~= "battle" then
		arg_16_0.vars.scrollview:setContentSize(arg_16_0.vars.scrollview:getContentSize().width + 209, arg_16_0.vars.scrollview:getContentSize().height)
	end
	
	arg_16_0:initScrollView(arg_16_0.vars.scrollview, 134, 115, {
		force_horizontal = true
	})
	
	local var_16_0 = false
	local var_16_1 = arg_16_0.vars.infos.round_info
	local var_16_2 = var_16_1.total - 1
	
	for iter_16_0 = 1, var_16_2 do
		local var_16_3 = var_16_1.rounds[iter_16_0]
		local var_16_4 = table.count(var_16_3 and var_16_3.preban[arg_16_0.vars.home_uid] or {})
		local var_16_5 = table.count(var_16_3 and var_16_3.preban[arg_16_0.vars.enemy_uid] or {})
		local var_16_6 = var_16_4 == 0 and var_16_5 == 0
		
		if var_16_4 >= 2 then
			var_16_0 = true
		end
		
		local var_16_7 = {
			round = iter_16_0,
			multi_preban_mode = var_16_0,
			preban_count = var_16_4,
			unit_info = {}
		}
		
		if var_16_3 and not var_16_6 then
			var_16_7.state = var_16_3.state
			
			for iter_16_1, iter_16_2 in pairs(var_16_3.preban or {}) do
				for iter_16_3, iter_16_4 in pairs(iter_16_2 or {}) do
					local var_16_8
					
					if var_16_4 >= 2 then
						var_16_8 = iter_16_1 == arg_16_0.vars.home_uid and "ban_face_icon1_" .. tostring(iter_16_3) or "ban_face_icon2_" .. tostring(iter_16_3)
					else
						var_16_8 = iter_16_1 == arg_16_0.vars.home_uid and "ban_face_icon1" or "ban_face_icon2"
					end
					
					local var_16_9 = {
						code = iter_16_4.code,
						node = var_16_8
					}
					
					table.insert(var_16_7.unit_info, var_16_9)
				end
			end
		elseif var_16_3 and var_16_6 then
			var_16_7.state = var_16_3.state
		end
		
		arg_16_0:addScrollViewItem(var_16_7)
	end
	
	local var_16_10 = arg_16_0.vars.scrollview:getInnerContainerSize()
	
	if var_16_0 then
		arg_16_0.vars.scrollview:setInnerContainerSize({
			width = var_16_10.width + 74,
			height = var_16_10.height
		})
	else
		arg_16_0.vars.scrollview:setInnerContainerSize({
			width = var_16_10.width + 10,
			height = var_16_10.height
		})
	end
	
	arg_16_0.vars.scrollview:forceDoLayout()
	
	if var_16_1.rounds and table.count(var_16_1.rounds) > 4 then
		arg_16_0:jumpToIndex(table.count(var_16_1.rounds))
	end
end

function ArenaNetRoundNext.getScrollViewItem(arg_17_0, arg_17_1)
	local var_17_0
	
	if arg_17_1.state and arg_17_1.state == "finish" then
		if arg_17_1.preban_count >= 2 then
			var_17_0 = cc.CSLoader:createNode("wnd/pvplive_round_lounge_item2.csb")
			
			var_17_0:getChildByName("n_1_2"):setPositionX(30)
			
			for iter_17_0, iter_17_1 in pairs(arg_17_1.unit_info) do
				UIUtil:getUserIcon(iter_17_1.code, {
					no_popup = true,
					name = false,
					no_role = true,
					no_lv = true,
					scale = 1,
					no_grade = true,
					parent = var_17_0:getChildByName(iter_17_1.node)
				})
			end
			
			var_17_0:getChildByName("t_no_data"):setVisible(false)
		elseif arg_17_1.preban_count == 1 then
			var_17_0 = cc.CSLoader:createNode("wnd/pvplive_round_lounge_item.csb")
			
			if arg_17_1.multi_preban_mode then
				var_17_0:getChildByName("n_1"):setPositionX(80)
			else
				var_17_0:getChildByName("n_1"):setPositionX(0)
			end
			
			for iter_17_2, iter_17_3 in pairs(arg_17_1.unit_info) do
				UIUtil:getUserIcon(iter_17_3.code, {
					no_popup = true,
					name = false,
					no_role = true,
					no_lv = true,
					scale = 1,
					no_grade = true,
					parent = var_17_0:getChildByName(iter_17_3.node)
				})
			end
			
			var_17_0:getChildByName("t_no_data"):setVisible(false)
		else
			var_17_0 = cc.CSLoader:createNode("wnd/pvplive_round_lounge_item.csb")
			
			if arg_17_1.multi_preban_mode then
				var_17_0:getChildByName("n_1"):setPositionX(80)
			else
				var_17_0:getChildByName("n_1"):setPositionX(0)
			end
			
			local var_17_1 = var_17_0:getChildByName("t_no_data")
			
			if_set(var_17_1, nil, T("pvp_rta_no_information"))
		end
	elseif not arg_17_1.state then
		var_17_0 = cc.CSLoader:createNode("wnd/pvplive_round_lounge_item.csb")
		
		if arg_17_1.multi_preban_mode then
			var_17_0:getChildByName("n_1"):setPositionX(80)
		else
			var_17_0:getChildByName("n_1"):setPositionX(0)
		end
		
		local var_17_2 = var_17_0:getChildByName("t_no_data")
		
		if_set(var_17_2, nil, T("pvp_rta_doit"))
	end
	
	if var_17_0 then
		local var_17_3 = var_17_0:getChildByName("t_round1")
		local var_17_4 = "pvp_rta_round" .. tostring(arg_17_1.round)
		
		if_set(var_17_3, nil, T(var_17_4))
	end
	
	return var_17_0
end

function ArenaNetRoundNext.updateUserInfo(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.vars.service:getSeasonId()
	local var_18_1 = arg_18_2.league_id
	local var_18_2, var_18_3 = getArenaNetRankInfo(var_18_0, var_18_1)
	local var_18_4 = (arg_18_2.win or 0) + (arg_18_2.draw or 0) + (arg_18_2.lose or 0)
	local var_18_5
	local var_18_6 = (arg_18_0.vars.service:getMatchMode() ~= "net_event_rank" or false) and var_18_4 < ARENA_MATCH_BATCH_COUNT
	
	UIUtil:getUserIcon(arg_18_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_18_1:getChildByName("mob_icon"),
		border_code = arg_18_2.border_code
	})
	if_set(arg_18_1, "txt_nation", getRegionText(arg_18_2.world))
	if_set(arg_18_1, "txt_name", check_abuse_filter(arg_18_2.name, ABUSE_FILTER.WORLD_NAME) or arg_18_2.name)
	
	if var_18_6 then
		SpriteCache:resetSprite(arg_18_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		SpriteCache:resetSprite(arg_18_1:getChildByName("emblem"), "emblem/" .. var_18_3 .. ".png")
	end
	
	if_set(arg_18_1, "txt_clan", clanNameFilter(arg_18_2.clan_name))
	UIUtil:updateClanEmblem(arg_18_1:getChildByName("n_emblem"), {
		emblem = arg_18_2.clan_emblem
	})
	if_set_visible(arg_18_1, "n_emblem", string.len(arg_18_2.clan_name or "") > 0)
	
	if string.len(arg_18_2.clan_name or "") <= 0 then
		if_set_add_position_y(arg_18_1, "txt_name", -14)
		if_set_add_position_y(arg_18_1, "n_server", 14)
		if_set_add_position_y(arg_18_1, "n_ping", 14)
	end
end

function ArenaNetRoundNext.updateModelInfo(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = UNIT:create({
		exp = 0,
		lv = 1,
		code = arg_19_2.leader_code,
		skin_code = arg_19_2.skin_code
	})
	local var_19_1 = CACHE:getModel(var_19_0.db.model_id, var_19_0.db.skin, nil, var_19_0.db.atlas, var_19_0.db.model_opt)
	local var_19_2 = arg_19_1:getChildByName("n_pos1_character") or arg_19_1:getChildByName("n_pos2_character")
	
	if arg_19_1 then
		var_19_1:setScale(0.95)
		var_19_2:addChild(var_19_1)
		
		if arg_19_3 then
			var_19_1:setScaleX(-0.95)
		end
	end
end

function ArenaNetRoundNext.updateRoundInfo(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_0.vars.infos.round_info
	local var_20_1 = arg_20_0.vars.infos.round_info.total
	local var_20_2 = math.round(var_20_1 / 2)
	
	local function var_20_3(arg_21_0, arg_21_1)
		local var_21_0 = 0
		
		for iter_21_0, iter_21_1 in pairs(arg_21_0.rounds or {}) do
			if iter_21_1.winner and iter_21_1.winner == arg_21_1 then
				var_21_0 = var_21_0 + 1
			end
		end
		
		return var_21_0
	end
	
	local function var_20_4(arg_22_0, arg_22_1, arg_22_2)
		local var_22_0 = arg_22_0:getChildByName(arg_22_1)
		local var_22_1 = var_20_3(var_20_0, arg_22_2)
		
		for iter_22_0 = 1, 4 do
			local var_22_2 = var_22_0:getChildByName(tostring(iter_22_0))
			
			if iter_22_0 <= var_20_2 then
				var_22_2:setVisible(true)
				
				if iter_22_0 <= var_22_1 then
					SpriteCache:resetSprite(var_22_2, "img/pvplive_win_on.png")
				else
					SpriteCache:resetSprite(var_22_2, "img/pvplive_win_off.png")
				end
			else
				var_22_2:setVisible(false)
			end
		end
	end
	
	var_20_4(arg_20_1, "n_left", arg_20_2)
	var_20_4(arg_20_1, "n_right", arg_20_3)
	if_set(arg_20_1, "t", T("war_ui_round", {
		round = table.count(var_20_0.rounds)
	}))
end

function ArenaNetRoundNext.updateResultInfo(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_0.vars.infos.round_info
	local var_23_1 = 0
	local var_23_2
	
	for iter_23_0 = 1, 6 do
		local var_23_3 = var_23_0.rounds[iter_23_0]
		local var_23_4
		local var_23_5 = iter_23_0
		
		if iter_23_0 < 4 then
			local var_23_6 = arg_23_1:getChildByName("n_1")
			
			if_set_visible(var_23_6, nil, true)
			
			var_23_4 = var_23_6:getChildByName(tostring(var_23_5))
		else
			local var_23_7 = var_23_5 - 3
			local var_23_8 = arg_23_1:getChildByName("n_2")
			
			if_set_visible(var_23_8, nil, true)
			
			var_23_4 = var_23_8:getChildByName(tostring(var_23_7))
		end
		
		if var_23_3 then
			var_23_4:setVisible(true)
			
			if var_23_3.winner == arg_23_2 then
				SpriteCache:resetSprite(var_23_4, "img/battle_pvp_icon_win.png")
			elseif var_23_3.winner == arg_23_3 then
				SpriteCache:resetSprite(var_23_4, "img/battle_pvp_icon_lose.png")
			else
				SpriteCache:resetSprite(var_23_4, "img/battle_pvp_icon_draw.png")
			end
			
			var_23_1 = var_23_1 + 1
			var_23_2 = var_23_3
		else
			var_23_4:setVisible(false)
		end
	end
	
	if var_23_1 == 1 then
		if_set_add_position_x(arg_23_1, "result_ex", 50)
	elseif var_23_1 == 2 then
		if_set_add_position_x(arg_23_1, "result_ex", 25)
	end
	
	if var_23_2 then
		local var_23_9 = arg_23_1:getChildByName("result_icon")
		local var_23_10 = arg_23_1:getChildByName("t_win")
		local var_23_11 = arg_23_1:getChildByName("t_lose")
		local var_23_12 = arg_23_1:getChildByName("t_draw")
		
		if var_23_2.winner == arg_23_2 then
			SpriteCache:resetSprite(var_23_9, "img/battle_pvp_icon_win.png")
			var_23_10:setVisible(true)
			var_23_11:setVisible(false)
			var_23_12:setVisible(false)
		elseif var_23_2.winner == arg_23_3 then
			SpriteCache:resetSprite(var_23_9, "img/battle_pvp_icon_lose.png")
			var_23_10:setVisible(false)
			var_23_11:setVisible(true)
			var_23_12:setVisible(false)
		else
			SpriteCache:resetSprite(var_23_9, "img/battle_pvp_icon_draw.png")
			var_23_10:setVisible(false)
			var_23_11:setVisible(false)
			var_23_12:setVisible(true)
		end
	end
end

function ArenaNetRoundNext.openChatBox(arg_24_0)
	ChatMain:show(SceneManager:getRunningPopupScene(), nil, {
		section = "arena"
	})
	ArenaNetChat:updateMemberCount()
end

function ArenaNetRoundNext.exit(arg_25_0)
	local var_25_0 = arg_25_0.vars.service:isHostUser()
	local var_25_1 = arg_25_0.vars.home_uid == arg_25_0.vars.user_id or arg_25_0.vars.enemy_uid == arg_25_0.vars.user_id
	
	if var_25_0 and not var_25_1 then
		Dialog:msgBox(T("pvp_rta_host_exit"), {
			yesno = true,
			handler = function()
				arg_25_0.vars.service:resetWebSocket()
				arg_25_0.vars.service:query("command", {
					type = "terminate"
				})
			end
		})
	elseif var_25_1 then
		Dialog:msgBox(T("txt_pvp_e7wc_really_out"), {
			yesno = true,
			handler = function()
				arg_25_0.vars.service:resetWebSocket()
				arg_25_0.vars.service:query("command", {
					type = "giveup"
				})
			end
		})
	else
		Dialog:msgBox(T("pvp_rta_mock_leave_room2"), {
			yesno = true,
			handler = function()
				arg_25_0.vars.service:resetWebSocket()
				arg_25_0.vars.service:query("command", {
					type = "exit"
				})
				arg_25_0.vars.service:reset()
				MatchService:query("arena_net_enter_lobby", nil, function(arg_29_0)
					arg_29_0.mode = "VS_FRIEND"
					
					SceneManager:nextScene("arena_net_lobby", arg_29_0)
					SceneManager:resetSceneFlow()
				end)
			end
		})
	end
end

function ArenaNetRoundNext.result(arg_30_0)
	ClearResult:showResultStatUI({
		result = arg_30_0.vars.infos.result
	})
end

function ArenaNetRoundNext.tip(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.n_tip_chat) then
		return 
	end
	
	if arg_31_0:isDisableTip() then
		return 
	end
	
	arg_31_0:hideTip()
	UIUtil:tip(arg_31_0.vars.n_tip_chat, arg_31_1)
end

function ArenaNetRoundNext.tipEmoji(arg_32_0, arg_32_1)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.n_tip_emoji) then
		return 
	end
	
	if arg_32_0:isDisableTip() then
		return 
	end
	
	arg_32_0:hideTip()
	UIUtil:tipEmoji(arg_32_0.vars.n_tip_emoji, arg_32_1)
end

function ArenaNetRoundNext.hideTip(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	if_set_visible(arg_33_0.vars.n_tip, nil, false)
	if_set_visible(arg_33_0.vars.n_tip_emoji, nil, false)
end

function ArenaNetRoundNext.isDisableTip(arg_34_0)
	if ArenaService:isAdminMode() then
		return true
	end
	
	if ArenaNetChat:isDisabled() then
		return true
	end
	
	if arg_34_0.vars and arg_34_0.vars.service and arg_34_0.vars.service:getMatchMode() == "net_event_rank" then
		return true
	end
	
	return false
end

function ArenaNetRoundNext.checkChatNotification(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	if arg_35_0:isDisableTip() then
		return 
	end
	
	local var_35_0 = arg_35_0.vars.btn_top_chat
	local var_35_1 = arg_35_0.vars.btn_top_alram
	
	if not get_cocos_refid(var_35_0) or not get_cocos_refid(var_35_1) then
		return 
	end
	
	local var_35_2 = ChatMain:checkNotification()
	
	if_set_visible(var_35_1, nil, var_35_2)
	if_set_visible(var_35_0, nil, not var_35_2)
	
	if var_35_2 then
		if not get_cocos_refid(arg_35_0.vars.eff_chat_noti) then
			arg_35_0.vars.eff_chat_noti = ChatMain:getNotificationEffect(var_35_1:getChildByName("n_eff"))
		end
	elseif get_cocos_refid(arg_35_0.vars.eff_chat_noti) then
		arg_35_0.vars.eff_chat_noti:removeFromParent()
		
		arg_35_0.vars.eff_chat_noti = nil
	end
end

function ArenaNetRoundNext.onRequest(arg_36_0, arg_36_1, arg_36_2)
end

function ArenaNetRoundNext.onResponse(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	if arg_37_0.vars.res_block then
		return 
	end
	
	local var_37_0 = table.count(arg_37_2 or {})
	
	if not arg_37_0.vars or var_37_0 == 0 or not arg_37_1 then
		return 
	end
	
	local var_37_1 = "on" .. string.ucfirst(arg_37_1)
	
	if arg_37_0[var_37_1] then
		arg_37_0[var_37_1](arg_37_0, arg_37_2, arg_37_3)
	end
end

function ArenaNetRoundNext.onWatch(arg_38_0, arg_38_1)
	if not arg_38_0.vars then
		return 
	end
	
	arg_38_0:updateState(arg_38_1)
	arg_38_0:update(arg_38_1)
	arg_38_0:updateUI()
end

function ArenaNetRoundNext.updateState(arg_39_0, arg_39_1)
	if arg_39_0.vars.service:isChangeBlocked() then
		return 
	end
	
	if arg_39_0.vars.service:getMatchMode() == "net_event_rank" and arg_39_1.result and arg_39_1.result.round_info and arg_39_1.result.round_info.finish then
		arg_39_0.vars.service:reset()
		SceneManager:nextScene("arena_net_round_result", {
			result = arg_39_1.result,
			match_info = arg_39_0.vars.infos,
			final_winner = arg_39_1.final_winner
		})
		SceneManager:resetSceneFlow()
		ClearResult:hide()
	elseif arg_39_1.cur_state == "LOUNGE" then
		SceneManager:nextScene("arena_net_round_result", {
			result = arg_39_0.vars.infos.result,
			match_info = arg_39_0.vars.infos,
			final_winner = arg_39_1.final_winner
		})
		SceneManager:resetSceneFlow()
		ClearResult:hide()
	else
		if arg_39_1.cur_state ~= "NEXT_ROUND" then
			Dialog:closeAll()
			UIAction:Add(SEQ(DELAY(6000)), arg_39_0, "block")
		end
		
		arg_39_0.vars.service:changeState(arg_39_1.cur_state, arg_39_1)
	end
end

function ArenaNetRoundNext.updateUI(arg_40_0)
	arg_40_0:updateReadyInfo()
	arg_40_0:updateSlotInfo()
	arg_40_0:updateTimeInfo()
	arg_40_0:updatePingInfo()
end

function ArenaNetRoundNext.updateReadyInfo(arg_41_0)
	if not arg_41_0.vars or not arg_41_0.vars.infos then
		return 
	end
	
	if not get_cocos_refid(arg_41_0.vars.wnd) then
		return 
	end
	
	local function var_41_0(arg_42_0)
		if arg_42_0 == arg_41_0.vars.infos.home_user then
			return arg_41_0.vars.infos.home_ready
		elseif arg_42_0 == arg_41_0.vars.infos.away_user then
			return arg_41_0.vars.infos.away_ready
		else
			return false
		end
	end
	
	local var_41_1 = arg_41_0.vars.user_id == arg_41_0.vars.infos.home_user or arg_41_0.vars.user_id == arg_41_0.vars.infos.away_user
	local var_41_2 = var_41_0(arg_41_0.vars.user_id)
	local var_41_3 = var_41_0(arg_41_0.vars.user_id)
	
	if arg_41_0.vars.infos.first_pick_user then
		if get_cocos_refid(arg_41_0.vars.pickPopup) then
			ArenaNetRoundFirstPick:close()
			
			arg_41_0.vars.pickPopup = nil
		end
	elseif arg_41_0.vars.infos.first_pick_selector == arg_41_0.vars.user_id and not get_cocos_refid(arg_41_0.vars.pickPopup) and not arg_41_0.vars.sended then
		arg_41_0.vars.pickPopup = ArenaNetRoundFirstPick:show({
			service = arg_41_0.vars.service,
			callback = function(arg_43_0)
				local var_43_0 = {
					type = "firstpick",
					first = arg_43_0
				}
				
				arg_41_0.vars.service:query("command", var_43_0)
				
				arg_41_0.vars.sended = true
			end
		})
	end
	
	if arg_41_0.vars.is_host and var_41_1 then
		arg_41_0.vars.n_watching:setVisible(false)
		
		if arg_41_0.vars.infos.home_ready and arg_41_0.vars.infos.away_ready then
			arg_41_0.vars.n_go:setVisible(true)
			arg_41_0.vars.n_ready:setVisible(false)
			if_set(arg_41_0.vars.n_go, "label", T("pvp_rta_srounge_bstart"))
		elseif var_41_2 then
			arg_41_0.vars.n_go:setVisible(false)
			arg_41_0.vars.n_ready:setVisible(true)
			if_set(arg_41_0.vars.n_go, "label", T("pvp_rta_srounge_bready"))
		else
			arg_41_0.vars.n_go:setVisible(true)
			arg_41_0.vars.n_ready:setVisible(false)
			if_set(arg_41_0.vars.n_go, "label", T("pvp_rta_srounge_bready"))
		end
	elseif arg_41_0.vars.is_host then
		arg_41_0.vars.n_watching:setVisible(false)
		arg_41_0.vars.n_ready:setVisible(false)
		if_set(arg_41_0.vars.n_go, "label", T("pvp_rta_srounge_bstart"))
		
		if arg_41_0.vars.infos.home_ready and arg_41_0.vars.infos.away_ready then
			arg_41_0.vars.n_go:setOpacity(255)
		else
			arg_41_0.vars.n_go:setOpacity(127.5)
		end
	elseif var_41_1 then
		arg_41_0.vars.n_watching:setVisible(false)
		if_set(arg_41_0.vars.n_go, "label", T("pvp_rta_srounge_bready"))
		
		if var_41_2 then
			arg_41_0.vars.n_go:setVisible(false)
			arg_41_0.vars.n_ready:setVisible(true)
		else
			arg_41_0.vars.n_go:setVisible(true)
			arg_41_0.vars.n_ready:setVisible(false)
		end
	else
		arg_41_0.vars.n_watching:setVisible(true)
		arg_41_0.vars.n_go:setVisible(false)
		arg_41_0.vars.n_ready:setVisible(false)
	end
	
	arg_41_0.vars.is_host_offline = false
	arg_41_0.vars.is_home_user_offline = false
	arg_41_0.vars.is_away_user_offline = false
	
	if arg_41_0.vars.infos.ping_info and arg_41_0.vars.infos.host then
		if arg_41_0.vars.infos.ping_info[arg_41_0.vars.infos.host] then
			local var_41_4 = getNetCondition(tonumber(arg_41_0.vars.infos.ping_info[arg_41_0.vars.infos.host].ping or PING_TIMEOUT_ERROR))
			
			arg_41_0.vars.is_host_offline = var_41_4 <= 1
		end
		
		if arg_41_0.vars.infos.ping_info[arg_41_0.vars.infos.home_user] then
			local var_41_5 = getNetCondition(tonumber(arg_41_0.vars.infos.ping_info[arg_41_0.vars.infos.home_user].ping or PING_TIMEOUT_ERROR))
			
			arg_41_0.vars.is_home_user_offline = var_41_5 <= 1
		end
		
		if arg_41_0.vars.infos.ping_info[arg_41_0.vars.infos.away_user] then
			local var_41_6 = getNetCondition(tonumber(arg_41_0.vars.infos.ping_info[arg_41_0.vars.infos.away_user].ping or PING_TIMEOUT_ERROR))
			
			arg_41_0.vars.is_away_user_offline = var_41_6 <= 1
		end
	end
	
	if arg_41_0.vars.service:getMatchMode() == "net_event_rank" then
		if arg_41_0.vars.is_home_user_offline or arg_41_0.vars.is_away_user_offline then
			if_set(arg_41_0.vars.wnd, "t_step", T("pvp_rta_event_waiting"))
		elseif arg_41_0.vars.infos.home_ready and arg_41_0.vars.infos.away_ready then
			if_set(arg_41_0.vars.wnd, "t_step", T("pvp_scrounge_next_start"))
		else
			if_set(arg_41_0.vars.wnd, "t_step", T("pvp_srounge_ready_for"))
		end
	elseif arg_41_0.vars.is_host_offline then
		if_set(arg_41_0.vars.wnd, "t_step", T("pvp_rta_host_waiting"))
	elseif arg_41_0.vars.infos.home_ready and arg_41_0.vars.infos.away_ready then
		if_set(arg_41_0.vars.wnd, "t_step", T("pvp_scrounge_next_start"))
	else
		if_set(arg_41_0.vars.wnd, "t_step", T("pvp_srounge_ready_for"))
	end
	
	if arg_41_0.vars.infos.home_ready and arg_41_0.vars.infos.away_ready then
		if arg_41_0.vars.is_home_user_offline or arg_41_0.vars.is_away_user_offline then
			arg_41_0.vars.n_go:setColor(cc.c3b(66, 66, 66))
		else
			arg_41_0.vars.n_go:setColor(cc.c3b(255, 255, 255))
		end
	end
end

function ArenaNetRoundNext.updateSlotInfo(arg_44_0)
	if not arg_44_0.vars or not arg_44_0.vars.infos then
		return 
	end
	
	if not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	local function var_44_0(arg_45_0)
		if arg_45_0 == arg_44_0.vars.infos.home_user then
			return arg_44_0.vars.infos.home_ready
		elseif arg_45_0 == arg_44_0.vars.infos.away_user then
			return arg_44_0.vars.infos.away_ready
		else
			return false
		end
	end
	
	if not arg_44_0.vars.infos.first_pick_user then
		for iter_44_0, iter_44_1 in pairs({
			arg_44_0.vars.n_player_slot,
			arg_44_0.vars.n_enemy_player_slot
		}) do
			local var_44_1 = arg_44_0.vars.n_player_slot == iter_44_1 and arg_44_0.vars.home_uid or arg_44_0.vars.enemy_uid
			
			if arg_44_0.vars.infos.first_pick_selector == var_44_1 then
				if_set_visible(iter_44_1, "n_ready", true)
				if_set_visible(iter_44_1, "n_ready_ok", false)
				if_set_visible(iter_44_1, "n_firstpick", false)
				if_set(iter_44_1:getChildByName("n_ready"), "disc", T("pvp_rta_srounge_pick"))
			elseif var_44_0(var_44_1) then
				if_set_visible(iter_44_1, "n_ready", false)
				if_set_visible(iter_44_1, "n_ready_ok", true)
				if_set_visible(iter_44_1, "n_firstpick", false)
				if_set(iter_44_1:getChildByName("n_ready_ok"), "disc", T("pvp_rta_srounge_ready"))
			else
				if_set_visible(iter_44_1, "n_ready", true)
				if_set_visible(iter_44_1, "n_ready_ok", false)
				if_set_visible(iter_44_1, "n_firstpick", false)
				if_set(iter_44_1:getChildByName("n_ready"), "disc", T("pvp_rta_srounge_pre"))
			end
		end
	else
		for iter_44_2, iter_44_3 in pairs({
			arg_44_0.vars.n_player_slot,
			arg_44_0.vars.n_enemy_player_slot
		}) do
			local var_44_2 = arg_44_0.vars.n_player_slot == iter_44_3 and arg_44_0.vars.home_uid or arg_44_0.vars.enemy_uid
			
			if arg_44_0.vars.infos.first_pick_user == var_44_2 then
				if_set_visible(iter_44_3, "n_ready", false)
				if_set_visible(iter_44_3, "n_ready_ok", false)
				if_set_visible(iter_44_3, "n_firstpick", true)
				if_set(iter_44_3:getChildByName("n_firstpick"), "disc", T("pvp_rta_first_pick"))
			elseif var_44_0(var_44_2) then
				if_set_visible(iter_44_3, "n_ready", false)
				if_set_visible(iter_44_3, "n_ready_ok", true)
				if_set_visible(iter_44_3, "n_firstpick", false)
				if_set(iter_44_3:getChildByName("n_ready_ok"), "disc", T("pvp_rta_srounge_ready"))
			else
				if_set_visible(iter_44_3, "n_ready", true)
				if_set_visible(iter_44_3, "n_ready_ok", false)
				if_set_visible(iter_44_3, "n_firstpick", false)
				if_set(iter_44_3:getChildByName("n_ready"), "disc", T("pvp_rta_srounge_pre"))
			end
		end
	end
end

function ArenaNetRoundNext.updateTimeInfo(arg_46_0)
	if not arg_46_0.vars or not arg_46_0.vars.infos or not arg_46_0.vars.infos.time_info then
		return 
	end
	
	if not get_cocos_refid(arg_46_0.vars.wnd) then
		return 
	end
	
	local var_46_0 = arg_46_0.vars.infos.time_info
	
	if ArenaNetRoundFirstPick:update(var_46_0) then
		return 
	end
	
	if table.empty(var_46_0) then
		arg_46_0.vars.n_countdown:setVisible(false)
	else
		local var_46_1 = var_46_0.total_time or 0
		local var_46_2 = var_46_1 - (var_46_0.wait_time or 0)
		
		if get_cocos_refid(arg_46_0.vars.n_countdown) then
			arg_46_0.vars.n_countdown:removeAllChildren()
			
			if var_46_2 >= 0 and var_46_2 <= var_46_1 then
				local var_46_3 = cc.Label:createWithBMFont("font/score.fnt", math.clamp(var_46_2, 0, var_46_1))
				
				arg_46_0.vars.n_countdown:addChild(var_46_3)
			end
		end
	end
end

function ArenaNetRoundNext.updatePingInfo(arg_47_0)
	if not arg_47_0.vars or not arg_47_0.vars.infos or not arg_47_0.vars.infos.ping_info then
		return 
	end
	
	if not get_cocos_refid(arg_47_0.vars.wnd) then
		return 
	end
	
	local var_47_0 = arg_47_0.vars.infos.ping_info
	
	for iter_47_0, iter_47_1 in pairs(var_47_0 or {}) do
		local var_47_1, var_47_3
		
		if iter_47_1.ping then
			var_47_1 = getNetCondition(tonumber(iter_47_1.ping))
			
			local var_47_2
			
			if iter_47_0 == arg_47_0.vars.home_uid then
				var_47_2 = arg_47_0.vars.n_player_info
			elseif iter_47_0 == arg_47_0.vars.enemy_uid then
				var_47_2 = arg_47_0.vars.n_enemy_player_info
			end
			
			if var_47_2 then
				var_47_3 = var_47_2:getChildByName("n_ping")
				
				if var_47_3 then
					for iter_47_2 = 1, 3 do
						var_47_3:getChildByName(tostring(iter_47_2)):setVisible(var_47_1 == iter_47_2)
					end
				end
			end
		end
	end
end

function ArenaNetRoundNext.start(arg_48_0)
	if arg_48_0.vars.is_home_user_offline or arg_48_0.vars.is_away_user_offline then
		return 
	end
	
	if arg_48_0.vars.infos.home_ready and arg_48_0.vars.infos.away_ready then
		arg_48_0.vars.service:query("command", {
			type = "start"
		})
	else
		arg_48_0.vars.service:query("command", {
			type = "ready"
		})
	end
end

function ArenaNetRoundNext.getBroadCastData(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local function var_49_0(arg_50_0, arg_50_1)
		if not arg_50_0 or not arg_50_1 or not arg_50_0[arg_50_1] then
			return {}
		end
		
		local var_50_0 = {}
		
		for iter_50_0, iter_50_1 in pairs(arg_50_0[arg_50_1]) do
			table.insert(var_50_0, iter_50_1.code)
		end
		
		return var_50_0
	end
	
	local function var_49_1(arg_51_0, arg_51_1, arg_51_2)
		local var_51_0 = {}
		
		arg_51_0 = arg_51_0 or {}
		
		local var_51_1 = 5
		
		if arg_51_2 and arg_51_2 >= 7 then
			var_51_1 = 7
		end
		
		for iter_51_0 = 1, var_51_1 do
			local var_51_2 = "round" .. tostring(iter_51_0) .. "Win"
			
			if arg_51_0[iter_51_0] then
				if arg_51_0[iter_51_0].state == "finish" or arg_51_0[iter_51_0].state == "benefit" then
					if arg_51_0[iter_51_0].winner == "draw" then
						var_51_0[var_51_2] = 0
					elseif arg_51_0[iter_51_0].winner == arg_51_1 then
						var_51_0[var_51_2] = 1
					else
						var_51_0[var_51_2] = -1
					end
				else
					var_51_0[var_51_2] = -2
				end
			else
				var_51_0[var_51_2] = -2
			end
		end
		
		return var_51_0
	end
	
	local function var_49_2(arg_52_0)
		return {
			world = arg_52_0.world,
			user_id = tostring(arg_52_0.user_id),
			name = arg_52_0.name,
			clan_name = arg_52_0.clan_name
		}
	end
	
	local function var_49_3(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
		if arg_53_1 and arg_53_2 and arg_53_3 then
			arg_53_0.totalRoundContribution, arg_53_0.mvpHero, arg_53_0.mvpScore = BattleStat:getContribution("all", arg_53_1, arg_53_2, arg_53_3)
			arg_53_0.attackRoundContribution = BattleStat:getContribution("att", arg_53_1, arg_53_2, arg_53_3)
			arg_53_0.defenseRoundContribution = BattleStat:getContribution("def", arg_53_1, arg_53_2, arg_53_3)
		end
	end
	
	local function var_49_4(arg_54_0, arg_54_1)
		if not arg_54_0 then
			return -2
		end
		
		if arg_54_0 == "draw" then
			return 0
		elseif arg_54_0 == "win" then
			if arg_54_1 then
				return -1
			else
				return 1
			end
		elseif arg_54_1 then
			return 1
		else
			return -1
		end
	end
	
	arg_49_1 = arg_49_1 or arg_49_0.vars and arg_49_0.vars.infos
	arg_49_2 = arg_49_2 or arg_49_1 and arg_49_1.result
	
	local var_49_5 = (arg_49_1 or {}).home_user
	
	if not arg_49_1 or not arg_49_2 or not var_49_5 then
		return 
	end
	
	local var_49_6 = {
		deviceID = BroadCastHelper.get_device_info()
	}
	local var_49_7 = arg_49_1.user_info.uid
	local var_49_8 = arg_49_1.enemy_user_info.uid
	local var_49_9 = arg_49_2.round_info or {}
	local var_49_10 = BroadCastHelper.make_accumulate_preban_info(var_49_9)
	local var_49_11 = var_49_9.rounds and var_49_9.rounds[#var_49_9.rounds] or {}
	
	var_49_6.header = {}
	
	if var_49_9.rounds then
		var_49_6.header.cur_round = table.count(var_49_9.rounds)
	else
		var_49_6.header.cur_round = 1
	end
	
	var_49_6.header.tot_round = var_49_9.total or 1
	
	if arg_49_1.game_info.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		var_49_6.header.game_type = 1
		var_49_6.header.firstPickPlayer = var_49_11.first_pick_arena_uid == var_49_7 and 1 or 2
	elseif arg_49_1.game_info.rule == ARENA_NET_BATTLE_RULE.DRAFT then
		var_49_6.header.game_type = 2
		var_49_6.header.firstPickPlayer = 1
	end
	
	var_49_6.roundResultPlayer1 = {}
	var_49_6.roundResultPlayer1.playerInfo = var_49_2(arg_49_1.user_info)
	var_49_6.roundResultPlayer1.roundInfo = var_49_1(var_49_9.rounds, var_49_7, var_49_9.total)
	var_49_6.roundResultPlayer1.accumulatePreBanHeroList = var_49_0(var_49_10, var_49_7)
	var_49_6.roundResultPlayer1.preBanHeroList = var_49_0(arg_49_2.preban_units, var_49_7)
	var_49_6.roundResultPlayer1.banHeroList = var_49_0(arg_49_2.ban_units, var_49_7)
	var_49_6.roundResultPlayer1.finalWin = var_49_4(arg_49_3)
	var_49_6.roundResultPlayer1.pickHeroList = var_49_0(arg_49_2.pick_units, var_49_7)
	var_49_6.roundResultPlayer1.postBanHero = arg_49_2.ban_units and arg_49_2.ban_units[var_49_7] and arg_49_2.ban_units[var_49_7][1] and arg_49_2.ban_units[var_49_7][1].code
	
	var_49_3(var_49_6.roundResultPlayer1, var_49_5, FRIEND, arg_49_2.result_stat)
	
	var_49_6.roundResultPlayer2 = {}
	var_49_6.roundResultPlayer2.playerInfo = var_49_2(arg_49_1.enemy_user_info)
	var_49_6.roundResultPlayer2.roundInfo = var_49_1(var_49_9.rounds, var_49_8, var_49_9.total)
	var_49_6.roundResultPlayer2.accumulatePreBanHeroList = var_49_0(var_49_10, var_49_8)
	var_49_6.roundResultPlayer2.preBanHeroList = var_49_0(arg_49_2.preban_units, var_49_8)
	var_49_6.roundResultPlayer2.banHeroList = var_49_0(arg_49_2.ban_units, var_49_8)
	var_49_6.roundResultPlayer2.finalWin = var_49_4(arg_49_3, true)
	var_49_6.roundResultPlayer2.pickHeroList = var_49_0(arg_49_2.pick_units, var_49_8)
	var_49_6.roundResultPlayer2.postBanHero = arg_49_2.ban_units and arg_49_2.ban_units[var_49_8] and arg_49_2.ban_units[var_49_8][1] and arg_49_2.ban_units[var_49_8][1].code
	
	var_49_3(var_49_6.roundResultPlayer2, var_49_5, ENEMY, arg_49_2.result_stat)
	
	if var_49_6.roundResultPlayer1.mvpScore and var_49_6.roundResultPlayer2.mvpScore then
		if var_49_6.roundResultPlayer1.finalWin > -2 then
			if var_49_6.roundResultPlayer1.finalWin == 1 then
				var_49_6.roundResultPlayer2.mvpHero = nil
			elseif var_49_6.roundResultPlayer2.finalWin == 1 then
				var_49_6.roundResultPlayer1.mvpHero = nil
			end
		elseif var_49_11 then
			if var_49_11.winner == var_49_7 then
				var_49_6.roundResultPlayer2.mvpHero = nil
			elseif var_49_11.winner == var_49_8 then
				var_49_6.roundResultPlayer1.mvpHero = nil
			end
		end
		
		var_49_6.roundResultPlayer1.mvpScore = nil
		var_49_6.roundResultPlayer2.mvpScore = nil
	end
	
	var_49_6.resultInfo = {}
	var_49_6.resultInfo.runningTime = arg_49_2.battle_play_time
	var_49_6.resultInfo.turnCount = arg_49_2.turn_count
	var_49_6.resultInfo.enthusiasmBattleLevel = arg_49_2.rta_penalty_level or 0
	
	if diff_check(arg_49_0.prev_broad_data or {}, var_49_6) then
		arg_49_0.prev_broad_data = var_49_6
		
		ArenaWebSocket:save("/broad_cast_result", var_49_6)
		
		return var_49_6
	end
	
	return nil
end

function HANDLER.pvplive_pick_sel(arg_55_0, arg_55_1)
	if arg_55_1 == "btn_2nd_on" or arg_55_1 == "btn_2nd_off" then
		ArenaNetRoundFirstPick:select(arg_55_0.tag)
	elseif arg_55_1 == "btn_ok" then
		ArenaNetRoundFirstPick:confirm()
	end
end

ArenaNetRoundFirstPick = {}

function ArenaNetRoundFirstPick.show(arg_56_0, arg_56_1)
	arg_56_1 = arg_56_1 or {}
	arg_56_0.vars = {}
	arg_56_0.vars.wnd = load_dlg("pvplive_pick_sel", true, "wnd")
	arg_56_0.vars.service = arg_56_1.service
	arg_56_0.vars.n_time = arg_56_0.vars.wnd:getChildByName("n_time")
	arg_56_0.vars.n_first = arg_56_0.vars.wnd:getChildByName("n_1st")
	arg_56_0.vars.n_second = arg_56_0.vars.wnd:getChildByName("n_2nd")
	arg_56_0.vars.n_first:getChildByName("btn_2nd_on").tag = "first"
	arg_56_0.vars.n_first:getChildByName("btn_2nd_off").tag = "first"
	arg_56_0.vars.n_second:getChildByName("btn_2nd_on").tag = "second"
	arg_56_0.vars.n_second:getChildByName("btn_2nd_off").tag = "second"
	arg_56_0.vars.callback = arg_56_1.callback
	
	SceneManager:getRunningPopupScene():addChild(arg_56_0.vars.wnd)
	arg_56_0:select("first")
	
	return arg_56_0.vars.wnd
end

function ArenaNetRoundFirstPick.close(arg_57_0)
	if not arg_57_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_57_0.vars.wnd) then
		arg_57_0.vars.wnd:removeFromParent()
	end
	
	arg_57_0.vars = nil
end

function ArenaNetRoundFirstPick.update(arg_58_0, arg_58_1)
	if not arg_58_1 then
		return 
	end
	
	if not arg_58_0.vars or not get_cocos_refid(arg_58_0.vars.wnd) then
		return 
	end
	
	local var_58_0 = arg_58_1.total_time or 0
	local var_58_1 = var_58_0 - (arg_58_1.wait_time or 0)
	local var_58_2 = arg_58_0.vars.n_time:getChildByName("t_time")
	
	if var_58_2 then
		var_58_2:removeAllChildren()
		
		if var_58_1 >= 0 and var_58_1 <= var_58_0 then
			var_58_2:setString(tostring(var_58_1))
		end
	end
	
	return true
end

function ArenaNetRoundFirstPick.select(arg_59_0, arg_59_1)
	if arg_59_1 == "first" then
		if_set_visible(arg_59_0.vars.n_first, "btn_2nd_on", true)
		if_set_visible(arg_59_0.vars.n_first, "btn_2nd_off", true)
		if_set_visible(arg_59_0.vars.n_second, "btn_2nd_on", false)
		if_set_visible(arg_59_0.vars.n_second, "btn_2nd_off", true)
		
		arg_59_0.vars.selected_first = true
	else
		if_set_visible(arg_59_0.vars.n_first, "btn_2nd_on", false)
		if_set_visible(arg_59_0.vars.n_first, "btn_2nd_off", true)
		if_set_visible(arg_59_0.vars.n_second, "btn_2nd_on", true)
		if_set_visible(arg_59_0.vars.n_second, "btn_2nd_off", true)
		
		arg_59_0.vars.selected_first = false
	end
	
	local var_59_0 = {
		type = "selecting",
		selected_first = arg_59_0.vars.selected_first
	}
	
	arg_59_0.vars.service:query("command", var_59_0)
end

function ArenaNetRoundFirstPick.confirm(arg_60_0)
	if arg_60_0.vars.callback then
		arg_60_0.vars.callback(arg_60_0.vars.selected_first)
	end
	
	arg_60_0:close()
end

function HANDLER.pvplive_mock_winner_sel(arg_61_0, arg_61_1)
	if string.starts(arg_61_1, "btn_n") then
		ArenaNetRoundWinnerSelect:select(arg_61_0.tag)
	elseif arg_61_1 == "btn_ok" then
		ArenaNetRoundWinnerSelect:confirm()
	elseif arg_61_1 == "btn_cancel" then
		ArenaNetRoundWinnerSelect:close()
	end
end

ArenaNetRoundWinnerSelect = {}

function ArenaNetRoundWinnerSelect.show(arg_62_0, arg_62_1)
	arg_62_1 = arg_62_1 or {}
	arg_62_0.vars = {}
	arg_62_0.vars.wnd = load_dlg("pvplive_mock_winner_sel", true, "wnd")
	arg_62_0.vars.n_player1 = arg_62_0.vars.wnd:getChildByName("n_player1")
	arg_62_0.vars.n_player2 = arg_62_0.vars.wnd:getChildByName("n_player2")
	arg_62_0.vars.n_draw = arg_62_0.vars.wnd:getChildByName("n_draw")
	arg_62_0.vars.n_player1:getChildByName("btn_n_player1_on").tag = "player1"
	arg_62_0.vars.n_player1:getChildByName("btn_n_player1_off").tag = "player1"
	arg_62_0.vars.n_player2:getChildByName("btn_n_player2_on").tag = "player2"
	arg_62_0.vars.n_player2:getChildByName("btn_n_player2_off").tag = "player2"
	arg_62_0.vars.n_draw:getChildByName("btn_n_draw_on").tag = "draw"
	arg_62_0.vars.n_draw:getChildByName("btn_n_draw_off").tag = "draw"
	arg_62_0.vars.callback = arg_62_1.callback
	
	arg_62_0:update()
	SceneManager:getRunningPopupScene():addChild(arg_62_0.vars.wnd)
	
	return arg_62_0.vars.wnd
end

function ArenaNetRoundWinnerSelect.close(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_63_0.vars.wnd) then
		arg_63_0.vars.wnd:removeFromParent()
	end
	
	arg_63_0.vars = nil
end

function ArenaNetRoundWinnerSelect.update(arg_64_0)
	local function var_64_0(arg_65_0, arg_65_1)
		if_set(arg_65_0, "txt_nation", getRegionText(arg_65_1.world))
		if_set(arg_65_0, "txt_name", check_abuse_filter(arg_65_1.name, ABUSE_FILTER.WORLD_NAME) or arg_65_1.name)
		UIUtil:getUserIcon(arg_65_1.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_65_0:getChildByName("mob_icon"),
			border_code = arg_65_1.border_code
		})
	end
	
	local var_64_1 = ArenaService:getMatchInfo()
	
	var_64_0(arg_64_0.vars.n_player1:getChildByName("btn_n_player1_off"), var_64_1.user_info)
	var_64_0(arg_64_0.vars.n_player1:getChildByName("btn_n_player1_on"), var_64_1.user_info)
	var_64_0(arg_64_0.vars.n_player2:getChildByName("btn_n_player2_off"), var_64_1.enemy_user_info)
	var_64_0(arg_64_0.vars.n_player2:getChildByName("btn_n_player2_on"), var_64_1.enemy_user_info)
	
	return true
end

function ArenaNetRoundWinnerSelect.select(arg_66_0, arg_66_1)
	if arg_66_1 == "player1" then
		if_set_visible(arg_66_0.vars.n_player1, "btn_n_player1_on", true)
		if_set_visible(arg_66_0.vars.n_player2, "btn_n_player2_on", false)
		if_set_visible(arg_66_0.vars.n_draw, "btn_n_draw_on", false)
		
		arg_66_0.vars.selected = arg_66_1
	elseif arg_66_1 == "player2" then
		if_set_visible(arg_66_0.vars.n_player1, "btn_n_player1_on", false)
		if_set_visible(arg_66_0.vars.n_player2, "btn_n_player2_on", true)
		if_set_visible(arg_66_0.vars.n_draw, "btn_n_draw_on", false)
		
		arg_66_0.vars.selected = arg_66_1
	elseif arg_66_1 == "draw" then
		if_set_visible(arg_66_0.vars.n_player1, "btn_n_player1_on", false)
		if_set_visible(arg_66_0.vars.n_player2, "btn_n_player2_on", false)
		if_set_visible(arg_66_0.vars.n_draw, "btn_n_draw_on", true)
		
		arg_66_0.vars.selected = arg_66_1
	end
end

function ArenaNetRoundWinnerSelect.confirm(arg_67_0)
	if not arg_67_0.vars.selected then
		balloon_message_with_sound("no_winner_select")
		
		return 
	end
	
	if arg_67_0.vars.callback then
		local var_67_0 = ArenaService:getMatchInfo()
		local var_67_1
		
		if arg_67_0.vars.selected == "player1" then
			var_67_1 = var_67_0.user_info.uid
		elseif arg_67_0.vars.selected == "player2" then
			var_67_1 = var_67_0.enemy_user_info.uid
		elseif arg_67_0.vars.selected == "draw" then
			var_67_1 = "draw"
		end
		
		arg_67_0.vars.callback(var_67_1)
	end
	
	arg_67_0:close()
end

function ArenaNetRoundNext.save(arg_68_0)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local var_68_0 = arg_68_0.vars.infos
	local var_68_1 = json.encode(var_68_0)
	local var_68_2 = "/broadcast_result"
	
	io.writefile(getenv("app.data_path") .. var_68_2, var_68_1)
end

function ArenaNetRoundNext.load(arg_69_0)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "arena_net_lobby" then
		return 
	end
	
	local var_69_0 = "/broadcast_result"
	local var_69_1 = io.readfile(getenv("app.data_path") .. var_69_0)
	
	if var_69_1 then
		local var_69_2 = json.decode(var_69_1)
		
		var_69_2.arena_uid = tostring(ArenaNetLobby.vars.lobby_info.user_info.uid)
		
		local var_69_3 = ArenaNetRoundNext:getBroadCastData(var_69_2)
		
		Log.e("broad cast data", var_69_3)
	end
end
