ArenaNetReady = {}
ArenaNetReadyOrigin = {}
ArenaNetReadyUser = {}
ArenaNetReadySpectator = {}
not_allow_flip_units = {
	"c1134",
	"c1135",
	"c1136",
	"c1137",
	"c1138",
	"c1139",
	"c1140"
}

function HANDLER.arena_net_ready(arg_1_0, arg_1_1)
	local var_1_0 = string.split(arg_1_1, "_")
	
	if var_1_0[2] == "step1" then
		ArenaNetReady:pick()
	elseif var_1_0[2] == "step2" then
		ArenaNetReady:ban()
	elseif var_1_0[2] == "step3" then
		ArenaNetReady:ready()
	elseif var_1_0[2] == "slot" then
		ArenaNetReady:select(arg_1_0, var_1_0[3], tonumber(var_1_0[4]))
	elseif var_1_0[2] == "esc" then
		ArenaNetReady:giveup()
	elseif var_1_0[2] == "preban" then
		ArenaNetReady:showBanListPopup()
	end
end

function HANDLER.arena_net_ready_spectator(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_esc" then
		ArenaNetReady:exit()
	elseif arg_2_1 == "btn_top_chat" or arg_2_1 == "btn_top_chat_alram" then
		ArenaNetReady:openChatBox()
	elseif arg_2_1 == "btn_preban" then
		ArenaNetReady:showBanListPopup()
	end
end

function HANDLER.arena_net_ready_draft(arg_3_0, arg_3_1)
	local var_3_0 = string.split(arg_3_1, "_")
	
	if var_3_0[2] == "step2" then
		ArenaNetReady:ban()
	elseif var_3_0[2] == "step3" then
		ArenaNetReady:ready()
	elseif var_3_0[2] == "slot" then
		ArenaNetReady:select(arg_3_0, var_3_0[3], tonumber(var_3_0[4]))
	elseif arg_3_1 == "btn_esc" then
		ArenaNetReady:giveup()
	end
end

function HANDLER.arena_net_ready_draft_spectator(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_esc" then
		ArenaNetReady:exit()
	elseif arg_4_1 == "btn_top_chat" or arg_4_1 == "btn_top_chat_alram" then
		ArenaNetReady:openChatBox()
	end
end

local function var_0_0(arg_5_0, arg_5_1)
	if arg_5_0.uid == arg_5_1:getUID() then
		return true
	end
	
	if arg_5_0.code == arg_5_1.db.code then
		return true
	end
	
	if arg_5_0.set_group and arg_5_0.set_group == arg_5_1.db.set_group then
		return true
	end
	
	if (arg_5_1.db.code == "c1005" or arg_5_1.db.code == "c0001" or arg_5_1.db.code == "c0002") and (arg_5_0.code == "c1005" or arg_5_0.code == "c0001" or arg_5_0.code == "c0002") then
		return true
	end
	
	return false
end

CurveHandler = ClassDef()

function CurveHandler.constructor(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0.TOTAL_TIME = arg_6_2
	arg_6_0.eff = arg_6_1
	
	local var_6_0 = math.abs(arg_6_4.x - arg_6_3.x)
	local var_6_1 = math.abs(arg_6_4.y - arg_6_3.y)
	local var_6_2 = arg_6_4.x - arg_6_3.x > 0 and var_6_0 * 0.33 or -var_6_0 * 0.33
	local var_6_3 = arg_6_4.y - arg_6_3.y > 0 and var_6_1 * 0.33 or -var_6_1 * 0.33
	
	arg_6_0.p0 = arg_6_3
	arg_6_0.p1 = {
		x = arg_6_3.x + var_6_2 + arg_6_5.x,
		y = arg_6_3.y + var_6_3 + arg_6_5.y
	}
	arg_6_0.p2 = {
		x = arg_6_3.x + var_6_2 * 2 + arg_6_5.x,
		y = arg_6_3.y + var_6_3 * 2 + arg_6_5.y
	}
	arg_6_0.p3 = arg_6_4
	
	arg_6_0.eff:setPosition(arg_6_0.p0.x, arg_6_0.p0.y)
end

function CurveHandler.Start(arg_7_0)
	arg_7_0.eff:start()
end

function CurveHandler.Update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.elapsed_time + arg_8_2
	local var_8_1 = math.max(0, math.min(1, var_8_0 / arg_8_1.TOTAL_TIME))
	local var_8_2 = 1 - var_8_1
	local var_8_3 = var_8_1 * var_8_1
	local var_8_4 = var_8_2 * var_8_2
	local var_8_5 = var_8_4 * var_8_2
	local var_8_6 = var_8_3 * var_8_1
	local var_8_7 = var_8_5 * arg_8_0.p0.x + 3 * var_8_4 * var_8_1 * arg_8_0.p1.x + 3 * var_8_2 * var_8_3 * arg_8_0.p2.x + var_8_6 * arg_8_0.p3.x
	local var_8_8 = var_8_5 * arg_8_0.p0.y + 3 * var_8_4 * var_8_1 * arg_8_0.p1.y + 3 * var_8_2 * var_8_3 * arg_8_0.p2.y + var_8_6 * arg_8_0.p3.y
	
	arg_8_0.eff:setPosition(var_8_7, var_8_8)
end

function CurveHandler.Finish(arg_9_0)
	arg_9_0.eff:setPosition(arg_9_0.p3.x, arg_9_0.p3.y)
end

function actPreban(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or {}
	
	local function var_10_0(arg_11_0, arg_11_1, arg_11_2)
		arg_11_2 = arg_11_2 or {}
		
		local var_11_0 = cc.DrawNode:create()
		local var_11_1 = cc.c3b(255, 255, 255)
		
		var_11_0:drawPolygon(arg_11_1, 4, var_11_1, 0, var_11_1)
		var_11_0:setPosition(0, 0)
		
		local var_11_2 = cc.ClippingNode:create()
		
		var_11_2:setStencil(var_11_0)
		
		local var_11_3, var_11_4 = UIUtil:getPortraitAni(arg_11_0)
		
		var_11_3:setScale(arg_11_2.scale or 1)
		var_11_2:addChild(var_11_3)
		
		return var_11_2, var_11_3, var_11_4
	end
	
	local function var_10_1(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = arg_12_2.start_pt
		local var_12_1 = arg_12_2.target_pt
		local var_12_2 = arg_12_2.curve_offset
		local var_12_3 = CACHE:getEffect("ui_preben_node.cfx")
		
		var_12_3:setLocalZOrder(9999999)
		var_12_3:setGlobalZOrder(9999999)
		var_12_3:setScale(0.5)
		
		local var_12_4 = CACHE:getEffect("ui_preben_icon.cfx")
		
		var_12_4:setLocalZOrder(9999999)
		var_12_4:setGlobalZOrder(9999999)
		var_12_4:setPosition(var_12_1)
		
		local var_12_5 = string.format("node.eff.%d", get_cocos_refid(var_12_3))
		
		UIAction:Add(SEQ(DELAY(arg_12_1), RLOG(USER_ACT(CurveHandler(var_12_3, arg_12_0, var_12_0, var_12_1, var_12_2))), SPAWN(FADE_OUT(200), CALL(function()
			var_12_4:start()
			
			if arg_10_2.preban_finish then
				arg_10_2.preban_finish(arg_12_3.ally, arg_12_3.order)
			end
		end)), DELAY(1000), CALL(function()
			remove_object(var_12_3)
			remove_object(var_12_4)
		end)), var_12_3, var_12_5)
		SceneManager:getRunningNativeScene():addChild(var_12_3)
		SceneManager:getRunningNativeScene():addChild(var_12_4)
	end
	
	local function var_10_2(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		arg_15_5 = arg_15_5 or {}
		
		local var_15_0 = 3000
		local var_15_1 = 120
		local var_15_2 = string.format("clip.%d", get_cocos_refid(arg_15_0))
		
		arg_15_0:setPosition(arg_15_1[1])
		UIAction:Add(SEQ(DELAY(arg_15_3), SPAWN(SEQ(DELAY(500 * arg_15_4), CALL(function()
			local var_16_0 = cc.GLProgramCache:getInstance():getGLProgram("GraySkeletonRenderer")
			
			if var_16_0 then
				local var_16_1 = cc.GLProgramState:create(var_16_0)
				
				if var_16_1 and arg_15_0.body then
					arg_15_0.body:setDefaultGLProgramState(var_16_1)
					arg_15_0.body:setGLProgramState(var_16_1)
				else
					arg_15_0:setDefaultGLProgramState(var_16_1)
					arg_15_0:setGLProgramState(var_16_1)
				end
			end
		end)), LOG(MOVE_TO(900 * arg_15_4, arg_15_1[2].x, arg_15_1[2].y), var_15_0)), CALL(function()
			if arg_15_2 then
				var_10_1(1100 * arg_15_4, 100, arg_15_2, arg_15_5)
			end
		end), RLOG(MOVE_TO(400 * arg_15_4, arg_15_1[3].x, arg_15_1[3].y), var_15_1)), arg_15_0, var_15_2)
	end
	
	local function var_10_3(arg_18_0)
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_livepvp_bann_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = arg_18_0
		})
	end
	
	local function var_10_4(arg_19_0)
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_preben_divid.cfx",
			pivot_y = 0,
			pivot_z = 99999,
			scale = 0.5,
			layer = arg_19_0
		})
	end
	
	local function var_10_5(arg_20_0, arg_20_1)
		if not arg_20_1.node then
			return 
		end
		
		local var_20_0 = {
			ally = {},
			enemy = {},
			ally = {
				start_pt = {
					x = VIEW_WIDTH * 0.2,
					y = VIEW_HEIGHT * 0.66
				},
				curve_offset = {
					x = -350,
					y = 0
				}
			},
			enemy = {
				start_pt = {
					x = VIEW_WIDTH * 0.65,
					y = VIEW_HEIGHT * 0.33
				},
				curve_offset = {
					x = 300,
					y = 0
				}
			}
		}
		local var_20_1 = table.clone(var_20_0[arg_20_0])
		
		var_20_1.target_pt = SceneManager:convertToSceneSpace(arg_20_1.node, {
			y = 0,
			x = arg_20_1.offset_x or 0
		})
		var_20_1.target_pt.y = 46
		
		return var_20_1
	end
	
	local var_10_6 = load_dlg("pvplive_ready_pre_ben_eff", true, "wnd")
	local var_10_7 = {}
	
	for iter_10_0 = 1, 6 do
		local var_10_8 = var_10_6:getChildByName("p" .. tostring(iter_10_0))
		
		table.insert(var_10_7, cc.p(var_10_8:getPositionX(), var_10_8:getPositionY()))
	end
	
	local var_10_9 = table.count(arg_10_0.ally) or 0
	local var_10_10 = {
		1300,
		2000,
		2700
	}
	local var_10_11 = {
		1,
		0.8,
		0.6
	}
	local var_10_12 = -600
	local var_10_13 = -800
	local var_10_14 = 700
	local var_10_15 = 250
	local var_10_16 = {
		0,
		900,
		1600
	}
	local var_10_17 = {
		ally = {
			var_10_7[5],
			var_10_7[1],
			var_10_7[3],
			var_10_7[6]
		},
		enemy = {
			var_10_7[4],
			var_10_7[5],
			var_10_7[6],
			var_10_7[2]
		}
	}
	local var_10_18 = {
		ally = {
			cc.p(VIEW_WIDTH + var_10_14, var_10_12 + var_10_15),
			cc.p(VIEW_WIDTH * 0.2, var_10_12),
			cc.p(-var_10_14, var_10_12 - var_10_15)
		},
		enemy = {
			cc.p(-var_10_14, var_10_13 - var_10_15),
			cc.p(VIEW_WIDTH * 0.6, var_10_13),
			cc.p(VIEW_WIDTH + var_10_14, var_10_13 + var_10_15)
		}
	}
	local var_10_19 = var_10_6:getChildByName("n_left")
	local var_10_20 = {
		ally = {},
		enemy = {}
	}
	
	for iter_10_1, iter_10_2 in pairs(arg_10_0 or {}) do
		for iter_10_3, iter_10_4 in pairs(iter_10_2 or {}) do
			local var_10_21, var_10_22, var_10_23 = var_10_0(iter_10_4, var_10_17[iter_10_1], {
				scale = 1.6
			})
			
			if not var_10_23 then
				for iter_10_5, iter_10_6 in pairs(var_10_18[iter_10_1]) do
					iter_10_6.y = iter_10_6.y + 900
				end
			end
			
			var_10_19:addChild(var_10_21)
			
			var_10_20[iter_10_1][iter_10_3] = {}
			var_10_20[iter_10_1][iter_10_3].port = var_10_22
			var_10_20[iter_10_1][iter_10_3].points = var_10_18[iter_10_1]
			var_10_20[iter_10_1][iter_10_3].curves = var_10_5(iter_10_1, arg_10_1[iter_10_1][iter_10_3])
			var_10_20[iter_10_1][iter_10_3].delay = var_10_16[iter_10_3]
		end
	end
	
	UIAction:Add(SEQ(SPAWN(CALL(function()
		for iter_21_0, iter_21_1 in pairs(var_10_20 or {}) do
			for iter_21_2, iter_21_3 in pairs(iter_21_1 or {}) do
				var_10_2(iter_21_3.port, iter_21_3.points, iter_21_3.curves, iter_21_3.delay, var_10_11[var_10_9], {
					ally = iter_21_0,
					order = iter_21_2
				})
			end
		end
		
		var_10_3(var_10_6:getChildByName("n_banned"))
		var_10_4(var_10_6:getChildByName("n_banned_diagonal"))
	end)), DELAY(var_10_10[var_10_9]), FADE_OUT(100), REMOVE()), var_10_6, "act.clip")
	SceneManager:getRunningNativeScene():addChild(var_10_6)
end

local function var_0_1(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0[arg_22_1] = arg_22_0[arg_22_1] or {}
	arg_22_0[arg_22_2] = arg_22_0[arg_22_2] or {}
	
	local var_22_0 = {}
	local var_22_1 = {}
	
	for iter_22_0 = 1, 5 do
		if arg_22_0[arg_22_1][iter_22_0] then
			local var_22_2 = arg_22_0[arg_22_1][iter_22_0].code
			
			if not var_22_1[var_22_2] then
				var_22_1[var_22_2] = true
				
				table.insert(var_22_0, var_22_2)
			end
		end
		
		if arg_22_0[arg_22_2][iter_22_0] then
			local var_22_3 = arg_22_0[arg_22_2][iter_22_0].code
			
			if not var_22_1[var_22_3] then
				var_22_1[var_22_3] = true
				
				table.insert(var_22_0, var_22_3)
			end
		end
	end
	
	return var_22_0
end

function ArenaNetReady.show(arg_23_0, arg_23_1, arg_23_2)
	arg_23_2 = arg_23_2 or {}
	
	if arg_23_2.service and arg_23_2.service:isReset() then
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
	
	arg_23_0.vars = {}
	arg_23_0.vars.service = arg_23_2.service
	arg_23_0.vars.match_info = arg_23_2.match_info
	arg_23_0.vars.owner = arg_23_0.vars.service:getUserUID()
	arg_23_0.vars.is_spectator = arg_23_0.vars.service:isSpectator()
	arg_23_0.vars.user_uid = arg_23_0.vars.match_info.user_info.uid
	arg_23_0.vars.enemy_uid = arg_23_0.vars.match_info.enemy_user_info.uid
	arg_23_0.vars.base_wnd = load_dlg("unit_base", true, "wnd")
	arg_23_0.vars.parent = arg_23_1 or SceneManager:getDefaultLayer()
	
	arg_23_0.vars.parent:addChild(arg_23_0.vars.base_wnd)
	copy_functions(ArenaNetReadyOrigin, arg_23_0)
	
	local var_23_0 = arg_23_0.vars.service:getGameInfo()
	
	if var_23_0 and var_23_0.rule == ARENA_NET_BATTLE_RULE.DRAFT then
		if not arg_23_0.vars.is_spectator then
			copy_functions(ArenaNetReadyDraft, arg_23_0)
			
			arg_23_0.vars.wnd = load_dlg("pvplive_ready_draft", true, "wnd")
			
			arg_23_0.vars.wnd:setName("arena_net_ready_draft")
		else
			copy_functions(ArenaNetReadyDraftSpectator, arg_23_0)
			
			arg_23_0.vars.wnd = load_dlg("pvplive_ready_draft_watching", true, "wnd")
			
			arg_23_0.vars.wnd:setName("arena_net_ready_draft_spectator")
		end
	elseif not arg_23_0.vars.is_spectator then
		copy_functions(ArenaNetReadyUser, arg_23_0)
		
		arg_23_0.vars.wnd = load_dlg("pvplive_ready", true, "wnd")
		
		arg_23_0.vars.wnd:setName("arena_net_ready")
	else
		copy_functions(ArenaNetReadySpectator, arg_23_0)
		
		arg_23_0.vars.wnd = load_dlg("pvplive_ready_watching", true, "wnd")
		
		arg_23_0.vars.wnd:setName("arena_net_ready_spectator")
	end
	
	arg_23_0.vars.base_wnd:addChild(arg_23_0.vars.wnd)
	
	arg_23_0.vars.seq_info = {
		seq_id = 0,
		seq = "ENTERED"
	}
	arg_23_0.vars.preban_info = {}
	arg_23_0.vars.pick_info = {}
	arg_23_0.vars.ban_info = {}
	arg_23_0.vars.rest_time = {}
	arg_23_0.vars.accumulate_preban_info = BroadCastHelper.make_accumulate_preban_info(arg_23_0.vars.match_info.round_info)
	arg_23_0.vars.interval_time = arg_23_0.vars.match_info.interval_time or 0
	arg_23_0.vars.input_lock = {}
	arg_23_0.vars.slot_roots = {}
	arg_23_0.vars.slot_lists = {}
	arg_23_0.vars.progress_bars = {}
	arg_23_0.vars.guide_arrows = {}
	
	arg_23_0:cache()
	arg_23_0:initUI()
	arg_23_0:createFormation()
	arg_23_0:updateBG()
	
	if arg_23_0.vars.service then
		function arg_23_0.vars.service.onUpdate()
			arg_23_0:onUpdate()
		end
	end
	
	LuaEventDispatcher:removeEventListenerByKey("arena.service.ready")
	LuaEventDispatcher:addEventListener("arena.service.req", LISTENER(ArenaNetReady.onRequest, arg_23_0), "arena.service.ready")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetReady.onResponse, arg_23_0), "arena.service.ready")
	
	if arg_23_0.vars.service:isRoundMode() and not arg_23_0.vars.is_spectator then
		SAVE:setKeep("net_arena_join_info", arg_23_0.vars.service:getRoomKey())
	else
		SAVE:setKeep("net_arena_join_info", nil)
	end
	
	arg_23_0.vars.service:query("command", {
		type = "pre",
		candidate_pick = arg_23_0:generatePickCandidate(),
		candidate_preban = arg_23_0:generatePreBanCandidate()
	}, nil, {
		retry = 9999
	})
	UIAction:Add(SEQ(DELAY(80), CALL(arg_23_0.onEnter, arg_23_0, 0)), arg_23_0.vars.base_wnd, "block")
	Analytics:setMode("arena_net_battle_ready")
	
	arg_23_0.vars.seq_infos = {}
end

function ArenaNetReady.onEnter(arg_26_0)
	local var_26_0 = {
		"LEFT",
		"CENTER",
		"RIGHT"
	}
	
	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		local var_26_1 = arg_26_0.vars.wnd:getChildByName(iter_26_1)
		
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, nil, var_26_1.origin_y), 100)), var_26_1, "block")
	end
	
	arg_26_0:showUnitList(true)
end

function ArenaNetReady.Enter(arg_27_0)
	local var_27_0 = DB("pvp_rta_season", arg_27_0.vars.service:getSeasonId(), {
		"bgm_banpick"
	}) or DB("pvp_rta_season_event", arg_27_0.vars.service:getSeasonId(), {
		"bgm_banpick"
	})
	
	if var_27_0 then
		SoundEngine:playBGM("event:/bgm/" .. var_27_0)
	end
end

function ArenaNetReady.isShow(arg_28_0)
	return arg_28_0.vars and get_cocos_refid(arg_28_0.vars.base_wnd)
end

function ArenaNetReady.resetUIEvent(arg_29_0)
	UIAction:Remove("arena.portrait")
end

function ArenaNetReady.onLeave(arg_30_0)
	arg_30_0:resetUIEvent()
	arg_30_0:showUnitList(false)
	BackButtonManager:pop("arena_net_ready")
	
	if get_cocos_refid(arg_30_0.vars.base_wnd) then
		UIAction:Add(SEQ(DELAY(80), FADE_OUT(200), SHOW(false), DELAY(40), CALL(arg_30_0.destroy, arg_30_0)), arg_30_0.vars.base_wnd, "block")
	end
end

function ArenaNetReady.destroy(arg_31_0)
	if not arg_31_0.vars then
		return 
	end
	
	HeroBelt:destroy()
	
	if get_cocos_refid(arg_31_0.vars.base_wnd) then
		arg_31_0.vars.base_wnd:removeFromParent()
	end
	
	arg_31_0.vars = nil
end

function ArenaNetReady.cache(arg_32_0)
	for iter_32_0, iter_32_1 in pairs({
		arg_32_0.vars.user_uid,
		arg_32_0.vars.enemy_uid
	}) do
		local var_32_0 = iter_32_0 == 1 and "my" or "enemy"
		
		arg_32_0.vars.slot_roots[iter_32_1] = arg_32_0.vars.wnd:getChildByName("n_" .. var_32_0)
		arg_32_0.vars.slot_lists[iter_32_1] = arg_32_0.vars.slot_lists[iter_32_1] or {}
		
		for iter_32_2 = 1, 5 do
			local var_32_1 = var_32_0 .. "_slot" .. tostring(iter_32_2)
			local var_32_2 = arg_32_0.vars.slot_roots[iter_32_1]:getChildByName(var_32_1)
			
			var_32_2.index = iter_32_2
			var_32_2.name = var_32_1
			arg_32_0.vars.slot_lists[iter_32_1][iter_32_2] = var_32_2
		end
		
		arg_32_0.vars.progress_bars[iter_32_1] = arg_32_0.vars.wnd:getChildByName("progress_bar_" .. var_32_0)
		
		local var_32_3 = iter_32_0 == 1 and "l" or "r"
		
		arg_32_0.vars.guide_arrows[iter_32_1] = arg_32_0.vars.wnd:getChildByName("n_eff_arrow_" .. var_32_3)
	end
	
	if_set(arg_32_0.vars.wnd, "t_step", "")
	if_set(arg_32_0.vars.wnd, "t_step_desc", "")
	
	arg_32_0.vars.step_btns = {}
	arg_32_0.vars.steps = {}
	
	for iter_32_3, iter_32_4 in pairs({
		"PICK",
		"BAN",
		"CHANGE"
	}) do
		arg_32_0.vars.step_btns[iter_32_4] = arg_32_0.vars.wnd:getChildByName("btn_step" .. tostring(iter_32_3))
		arg_32_0.vars.steps[iter_32_4] = arg_32_0.vars.wnd:getChildByName("bg_step" .. tostring(iter_32_3))
	end
	
	arg_32_0.vars.ban_node = arg_32_0.vars.wnd:getChildByName("n_ban_hero")
	arg_32_0.vars.ban_line = arg_32_0.vars.wnd:getChildByName("ben_line")
	arg_32_0.vars.ban_panel = {}
	
	if arg_32_0.vars.ban_node then
		arg_32_0.vars.ban_panel[arg_32_0.vars.user_uid] = arg_32_0.vars.ban_node:getChildByName("n_panel_left")
		arg_32_0.vars.ban_panel[arg_32_0.vars.enemy_uid] = arg_32_0.vars.ban_node:getChildByName("n_panel_right")
	end
	
	arg_32_0.vars.preban_node = arg_32_0.vars.wnd:getChildByName("n_pre_ben")
	arg_32_0.vars.btn_top_chat = arg_32_0.vars.wnd:getChildByName("btn_top_chat")
	arg_32_0.vars.btn_top_alram = arg_32_0.vars.wnd:getChildByName("btn_top_chat_alram")
	arg_32_0.vars.n_tip_chat = arg_32_0.vars.wnd:getChildByName("n_tip")
	arg_32_0.vars.n_tip_emoji = arg_32_0.vars.wnd:getChildByName("n_tip_emoji")
	arg_32_0.vars.accumulate_preban_node = arg_32_0.vars.wnd:getChildByName("n_round_pre_ban")
	
	if_set_visible(arg_32_0.vars.accumulate_preban_node, "n_face_l", false)
	if_set_visible(arg_32_0.vars.accumulate_preban_node, "n_face_r", false)
end

function ArenaNetReady.initUI(arg_33_0)
	if_set_visible(arg_33_0.vars.base_wnd, "bg", true)
	if_set_visible(arg_33_0.vars.wnd, "n_my_formation", false)
	if_set_visible(arg_33_0.vars.wnd, "n_turn", false)
	if_set_visible(arg_33_0.vars.wnd, "n_exit", true)
	if_set_visible(arg_33_0.vars.wnd, "n_round_info", false)
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.slot_lists) do
		for iter_33_2, iter_33_3 in pairs(iter_33_1) do
			if_set_visible(iter_33_3, "img_bg", false)
			if_set_visible(iter_33_3, "img_ban", false)
			if_set_visible(iter_33_3, "n_unit", false)
		end
	end
	
	for iter_33_4, iter_33_5 in pairs(arg_33_0.vars.progress_bars) do
		iter_33_5:setPercent(0)
	end
	
	local var_33_0 = {
		"LEFT",
		"CENTER",
		"RIGHT"
	}
	
	for iter_33_6, iter_33_7 in pairs(var_33_0) do
		local var_33_1 = arg_33_0.vars.wnd:getChildByName(iter_33_7)
		
		var_33_1.origin_y = var_33_1:getPositionY()
		
		var_33_1:setPositionY(-800)
	end
	
	for iter_33_8, iter_33_9 in pairs(arg_33_0.vars.step_btns) do
		iter_33_9:setVisible(false)
	end
	
	if arg_33_0.vars.ban_node then
		arg_33_0.vars.ban_node:setVisible(false)
	end
	
	if arg_33_0.vars.preban_node then
		local var_33_2 = {
			262,
			322,
			438
		}
		local var_33_3 = arg_33_0.vars.preban_node:getChildByName("bg")
		local var_33_4 = var_33_2[arg_33_0.vars.match_info.preban_count] or 322
		local var_33_5 = 284
		
		if arg_33_0.vars.match_info.preban_count == 0 then
			if_set_visible(arg_33_0.vars.preban_node, "n_none", true)
			if_set_visible(arg_33_0.vars.preban_node, "bar", false)
			arg_33_0:actPrebanNode(true, 200, 1)
		end
		
		if var_33_3 then
			var_33_3:setContentSize(var_33_4, var_33_5)
		end
		
		if arg_33_0.vars.match_info.rule ~= ARENA_NET_BATTLE_RULE.E7WC2 then
			arg_33_0.vars.preban_node:getChildByName("label_0"):setVisible(false)
			
			local var_33_6 = arg_33_0.vars.preban_node:getChildByName("txt_banned")
			
			if_set_add_position_y(var_33_6, nil, -25)
		end
	end
	
	if get_cocos_refid(arg_33_0.vars.btn_top_chat) then
		arg_33_0.vars.btn_top_chat:setVisible(not ArenaNetChat:isDisabled())
	end
	
	arg_33_0:setUserInfo(arg_33_0.vars.wnd:getChildByName("n_my_info"), arg_33_0.vars.match_info.user_info, true)
	arg_33_0:setUserInfo(arg_33_0.vars.wnd:getChildByName("n_enemy_info"), arg_33_0.vars.match_info.enemy_user_info, false)
	
	if MatchService:isBroadCastUIHide() then
		if_set_visible(arg_33_0.vars.wnd, "n_my_info", false)
		if_set_visible(arg_33_0.vars.wnd, "n_enemy_info", false)
	end
	
	arg_33_0:updateRoundInfo()
	ArenaNetCardSelector:resetMode()
end

function ArenaNetReady.updateBG(arg_34_0)
	local var_34_0 = DB("pvp_rta_season", arg_34_0.vars.service:getSeasonId(), {
		"rta_bg3"
	}) or DB("pvp_rta_season_event", arg_34_0.vars.service:getSeasonId(), {
		"rta_bg3"
	})
	
	if var_34_0 then
		SpriteCache:resetSprite(arg_34_0.vars.wnd:getChildByName("base"), "img/" .. var_34_0 .. ".png")
	end
end

function ArenaNetReady.createUnitList(arg_35_0)
	arg_35_0.vars.unit_dock = HeroBelt:create("ArenaNet")
	
	arg_35_0.vars.unit_dock:setEventHandler(arg_35_0.onHeroListEvent, arg_35_0)
	arg_35_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_35_0.vars.wnd:addChild(arg_35_0.vars.unit_dock:getWindow())
	HeroBelt:resetData(Account.units, "ArenaNet", nil, nil, nil)
	HeroBelt:showAddInvenButton(false)
	
	local var_35_0 = arg_35_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_35_0.vars.unit_dock:getWindow():setPositionX(var_35_0 + 300)
end

function ArenaNetReady.isInPickUnitList(arg_36_0, arg_36_1)
	if not arg_36_0.vars then
		return 
	end
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0.vars.pick_info or {}) do
		if table.isInclude(iter_36_1 or {}, function(arg_37_0, arg_37_1)
			return var_0_0(arg_37_1, arg_36_1)
		end) then
			return true
		end
	end
	
	return false
end

function ArenaNetReady.isInDuplicateClass(arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_0.vars then
		return 
	end
	
	if arg_38_0.vars.match_info.rule ~= ARENA_NET_BATTLE_RULE.LIMIT_CLASS then
		return 
	end
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.slot_lists[arg_38_0.vars.user_uid] or {}) do
		if arg_38_1 and iter_38_1.unit and arg_38_1.db.role == iter_38_1.unit.db.role then
			return true
		end
	end
	
	return false
end

function ArenaNetReady.isInPreBanUnitList(arg_39_0, arg_39_1)
	if not arg_39_0.vars then
		return 
	end
	
	if arg_39_0.vars.seq_info.seq == "PRE_BAN" then
		return 
	end
	
	for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.preban_info) do
		if table.isInclude(iter_39_1 or {}, function(arg_40_0, arg_40_1)
			return var_0_0(arg_40_1, arg_39_1)
		end) then
			return true
		end
	end
	
	return false
end

function ArenaNetReady.isInAccumulatePreBanUnitList(arg_41_0, arg_41_1)
	if not arg_41_0.vars then
		return 
	end
	
	if arg_41_0.vars.seq_info.seq == "PRE_BAN" then
		return 
	end
	
	for iter_41_0, iter_41_1 in pairs(arg_41_0.vars.accumulate_preban_info) do
		if table.isInclude(iter_41_1 or {}, function(arg_42_0, arg_42_1)
			return var_0_0(arg_42_1, arg_41_1)
		end) then
			return true
		end
	end
	
	return false
end

function ArenaNetReady.checkFinished(arg_43_0, arg_43_1)
	if not arg_43_1 or table.empty(arg_43_1) then
		return 
	end
	
	if arg_43_0.vars.service:getMatchMode() == "net_rank" then
		arg_43_0.vars.service:reset()
	end
	
	arg_43_0.vars.service:battleClear(arg_43_1, arg_43_0.vars.is_spectator)
	arg_43_0:getBroadCastResultData(arg_43_0.vars.match_info, arg_43_1)
end

function ArenaNetReady.makeUnitInfo(arg_44_0, arg_44_1)
	if arg_44_1 then
		local var_44_0, var_44_1 = arg_44_1:getGrowthBoostLvAndMaxLv()
		
		return {
			uid = arg_44_1:getUID(),
			code = arg_44_1.db.code,
			role = arg_44_1.db.role,
			skin_code = arg_44_1:getSkinCode(),
			set_group = arg_44_1.db.set_group,
			exp = arg_44_1:getEXP(),
			grade = arg_44_1:getGrowthBoostGrade(),
			zodiac = arg_44_1:getGrowthBoostZodiac(),
			awake = arg_44_1:getAwakeGrade(),
			face_id = arg_44_1:getUnitOptionValue("face_num"),
			g_lv = var_44_0,
			g_max_lv = var_44_1
		}
	end
end

function ArenaNetReady.onHeroListEvent(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	if arg_45_1 == "select" then
		Log.i("HERO EVENT SELECT")
	end
	
	if arg_45_0.vars.seq_info and (arg_45_0.vars.seq_info.seq == "ENTERED" or arg_45_0.vars.seq_info.seq == "PICK") and arg_45_1 == "change" then
		local var_45_0 = HeroBelt:getControl(arg_45_2)
		local var_45_1 = HeroBelt:getControl(arg_45_3)
		
		if var_45_0 then
			var_45_0:getChildByName("add"):setVisible(false)
		end
		
		if var_45_1 then
			var_45_1:getChildByName("add"):setVisible(false)
		end
		
		if arg_45_0.vars.input_lock.PICK then
			return 
		end
		
		UIAction:Remove("arena.portrait")
		UIAction:Add(SEQ(DELAY(1000), CALL(function()
			if arg_45_0.vars.seq_info.user == arg_45_0.vars.user_uid then
				local var_46_0 = HeroBelt:getCurrentItem()
				
				if not var_46_0 then
					return 
				end
				
				for iter_46_0, iter_46_1 in pairs(arg_45_0.vars.pick_info) do
					if table.isInclude(iter_46_1 or {}, function(arg_47_0, arg_47_1)
						return var_0_0(arg_47_1, var_46_0)
					end) then
						return 
					end
				end
				
				if arg_45_0:isInPreBanUnitList(var_46_0) or arg_45_0:isInAccumulatePreBanUnitList(var_46_0) or ArenaService:isInGlobalBanUnit(var_46_0) or ArenaService:isInGlobalBanArtifact(var_46_0) or ArenaService:isInGlobalBanExclusive(var_46_0) then
					return 
				end
				
				if var_46_0 then
					local var_46_1 = {
						type = "selecting",
						unit = arg_45_0:makeUnitInfo(var_46_0)
					}
					
					arg_45_0.vars.service:query("command", var_46_1)
				end
			end
		end)), arg_45_0.vars.base_wnd, "arena.portrait")
	end
end

function ArenaNetReady.exit(arg_48_0)
	if arg_48_0.vars.service:isAllowExitBattle() then
		local var_48_0 = arg_48_0.vars.service:isRoundMode() and T("pvp_rta_mock_leave_room2") or T("pvp_rta_mock_leave_room")
		
		Dialog:msgBox(var_48_0, {
			yesno = true,
			handler = function()
				arg_48_0.vars.service:resetWebSocket()
				arg_48_0.vars.service:query("command", {
					type = "exit"
				})
				arg_48_0.vars.service:reset()
				MatchService:query("arena_net_enter_lobby", nil, function(arg_50_0)
					arg_50_0.mode = "VS_FRIEND"
					
					SceneManager:nextScene("arena_net_lobby", arg_50_0)
					SceneManager:resetSceneFlow()
				end)
			end
		})
	elseif ArenaService:isAdminUser() or ArenaService:isHostUser() then
		Dialog:msgBox(T("pvp_rta_host_exit"), {
			yesno = true,
			handler = function()
				arg_48_0.vars.service:resetWebSocket()
				arg_48_0.vars.service:query("command", {
					type = "terminate"
				})
			end
		})
	else
		arg_48_0:giveup()
	end
end

function ArenaNetReady.giveup(arg_52_0)
	if not arg_52_0.vars or not arg_52_0.vars.current_seq then
		return 
	end
	
	if arg_52_0.vars.current_seq == "PRE" or arg_52_0.vars.current_seq == "PRE_BAN" then
		return 
	end
	
	local var_52_0 = ArenaService:getMatchMode() == "net_event_rank" and T("clanwar_giveup_caution") or T("arena_wa_giveup_desc")
	
	Dialog:msgBox(var_52_0, {
		yesno = true,
		handler = function()
			arg_52_0.vars.service:query("command", {
				type = "giveup"
			})
		end
	})
end

function ArenaNetReady.showBanListPopup(arg_54_0)
	if arg_54_0.vars.match_info.rule ~= ARENA_NET_BATTLE_RULE.E7WC2 then
		return 
	end
	
	local var_54_0 = arg_54_0.vars.match_info
	local var_54_1 = arg_54_0.vars.preban_info
	
	ArenaNetBanListPopup:show(var_54_0, var_54_1)
end

function ArenaNetReady.generatePickCandidate(arg_55_0)
	local var_55_0 = {}
	local var_55_1 = Account:getUnits()
	local var_55_2 = {}
	
	table.sort(var_55_1, UNIT.greaterThanPoint)
	
	for iter_55_0, iter_55_1 in pairs(var_55_1) do
		var_55_2[iter_55_1.db.role] = var_55_2[iter_55_1.db.role] or 0
		
		if not table.isInclude(var_55_0, function(arg_56_0, arg_56_1)
			return var_0_0(arg_56_1, iter_55_1)
		end) and var_55_2[iter_55_1.db.role] < ARENA_NET_BATTLE_MIN_ROLE_COUNT and not ArenaService:isInGlobalBanUnit(iter_55_1) and not ArenaService:isInGlobalBanArtifact(iter_55_1) and not ArenaService:isInGlobalBanExclusive(iter_55_1) and not arg_55_0:isInAccumulatePreBanUnitList(iter_55_1) and not iter_55_1:isMoonlightDestinyUnit() then
			local var_55_3 = arg_55_0:makeUnitInfo(iter_55_1)
			
			var_55_2[iter_55_1.db.role] = var_55_2[iter_55_1.db.role] + 1
			
			table.insert(var_55_0, var_55_3)
			
			local var_55_4 = 0
			
			for iter_55_2, iter_55_3 in pairs({
				"knight",
				"mage",
				"assassin",
				"warrior",
				"ranger",
				"manauser"
			}) do
				var_55_4 = var_55_4 + (var_55_2[iter_55_3] or 0)
			end
			
			if var_55_4 >= ARENA_NET_BATTLE_CANDIDATE_MIN_PICK_UNIT then
				break
			end
		end
	end
	
	return var_55_0
end

function ArenaNetReady.generatePreBanCandidate(arg_57_0)
	local var_57_0 = {}
	local var_57_1 = arg_57_0:loadRecentList() or {}
	
	for iter_57_0 = 1, arg_57_0.vars.match_info.preban_count do
		if var_57_1[iter_57_0] and var_57_1[iter_57_0].code and not table.find(var_57_0, function(arg_58_0, arg_58_1)
			return arg_58_1.code == var_57_1[iter_57_0].code
		end) then
			table.insert(var_57_0, var_57_1[iter_57_0])
		end
	end
	
	if table.count(var_57_0) == ARENA_NET_BATTLE_CANDIDATE_MIN_PICK_UNIT then
		return var_57_0
	end
	
	local function var_57_2()
		local var_59_0 = {}
		local var_59_1 = AccountData.dictionary_hide or {}
		
		for iter_59_0 = 1, 9999 do
			local var_59_2, var_59_3 = DBN("dic_data", iter_59_0, {
				"id",
				"show"
			})
			
			if var_59_2 then
				if string.starts(var_59_2, "c") then
					local var_59_4 = var_59_1[var_59_2]
					local var_59_5 = true
					
					if var_59_4 then
						local var_59_6 = os.time()
						
						if var_59_6 > var_59_4.start_time and var_59_6 < var_59_4.end_time then
							var_59_5 = false
						end
					end
					
					local var_59_7, var_59_8 = DB("character", var_59_2, "grade", "set_group")
					
					if var_59_7 then
						if var_59_7 < 5 then
							var_59_5 = false
						end
					else
						var_59_5 = false
					end
					
					if var_59_3 and var_59_3 == "n" then
						var_59_5 = false
					end
					
					local var_59_9 = Account:getUnitsByCode(var_59_2)
					
					for iter_59_1, iter_59_2 in pairs(var_59_9 or {}) do
						if ArenaService:isInGlobalBanArtifact(iter_59_2) or ArenaService:isInGlobalBanUnit(iter_59_2) or ArenaService:isInGlobalBanExclusive(iter_59_2) or arg_57_0:isInAccumulatePreBanUnitList(iter_59_2) or iter_59_2:isMoonlightDestinyUnit() then
							var_59_5 = false
							
							break
						end
					end
					
					if var_59_5 then
						local var_59_10 = {
							code = var_59_2,
							set_group = var_59_8
						}
						
						table.insert(var_59_0, var_59_10)
					end
				else
					break
				end
			end
		end
		
		return var_59_0
	end
	
	local var_57_3 = table.shuffle(var_57_2())
	
	for iter_57_1 = 1, ARENA_NET_BATTLE_CANDIDATE_MIN_PICK_UNIT do
		if var_57_3[iter_57_1] and not table.find(var_57_0, function(arg_60_0, arg_60_1)
			return arg_60_1.code == var_57_3[iter_57_1].code
		end) then
			table.insert(var_57_0, var_57_3[iter_57_1])
		end
	end
	
	return var_57_0
end

function ArenaNetReady.onUpdate(arg_61_0)
	if not arg_61_0.vars then
		return 
	end
	
	local var_61_0 = {
		seq_id = arg_61_0.vars.seq_info.seq_id
	}
	
	arg_61_0.vars.service:query("watch", var_61_0)
	
	if not arg_61_0.vars.is_spectator then
		local var_61_1 = {
			[arg_61_0.vars.owner] = {
				ping = ArenaNetMeter:lastPing()
			}
		}
		
		arg_61_0:updatePingInfo(var_61_1)
	end
end

function ArenaNetReady.updateState(arg_62_0, arg_62_1)
	if arg_62_0.vars.service:isChangeBlocked() then
		return 
	end
	
	if arg_62_1.cur_state == "LOUNGE" or ClearResult:isShow() then
		return 
	elseif arg_62_1.cur_state == "NEXT_ROUND" or ClearResult:isShow() then
		return 
	end
	
	arg_62_0.vars.service:changeState(arg_62_1.cur_state, arg_62_1)
end

function ArenaNetReady.select(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	if arg_63_2 == "my" then
		return 
	end
	
	local var_63_0 = arg_63_2 == "my" and arg_63_0.vars.user_uid or arg_63_0.vars.enemy_uid
	
	if arg_63_0.vars.seq_info.seq ~= "BAN" then
		return 
	end
	
	if arg_63_0.vars.select_lock then
		return 
	end
	
	if arg_63_0.vars.input_lock.BAN then
		return 
	end
	
	arg_63_0:onSelect({
		user_uid = var_63_0,
		slot_idx = arg_63_3
	})
end

function ArenaNetReady.pick(arg_64_0, arg_64_1)
	local var_64_0 = arg_64_1 or HeroBelt:getCurrentItem()
	
	if not var_64_0 then
		balloon_message_with_sound("ui_popup_hero_select_none_filtered")
		
		return 
	end
	
	local var_64_1 = {
		type = "pick",
		unit = arg_64_0:makeUnitInfo(var_64_0)
	}
	
	if arg_64_0.vars.seq_info.user ~= "both" and arg_64_0.vars.seq_info.user ~= arg_64_0.vars.user_uid then
		balloon_message_with_sound("arena_wa_enemy_select")
		
		return 
	end
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0.vars.pick_info) do
		if table.isInclude(iter_64_1 or {}, function(arg_65_0, arg_65_1)
			return var_0_0(arg_65_1, var_64_0)
		end) then
			if arg_64_0.vars.user_uid == iter_64_0 then
				balloon_message_with_sound("already_in_team")
			else
				balloon_message_with_sound("arena_wa_already_selected")
			end
			
			return 
		end
	end
	
	if arg_64_0:isInPreBanUnitList(var_64_0) then
		balloon_message_with_sound("pvp_rta_preban_cannot_select")
		
		return 
	end
	
	if arg_64_0:isInAccumulatePreBanUnitList(var_64_0) then
		balloon_message_with_sound("pvp_rta_preban_cannot_select")
		
		return 
	end
	
	if arg_64_0:isInDuplicateClass(var_64_0) then
		balloon_message_with_sound("arena_wa_cannot_selectable_desc")
		
		return 
	end
	
	if ArenaService:isInGlobalBanUnit(var_64_0) then
		balloon_message_with_sound("arena_wa_global_ban_desc")
		
		return 
	elseif ArenaService:isInGlobalBanArtifact(var_64_0) then
		balloon_message_with_sound("arena_wa_global_ban_desc")
		
		return 
	elseif ArenaService:isInGlobalBanExclusive(var_64_0) then
		balloon_message_with_sound("arena_wa_global_ban_desc")
		
		return 
	end
	
	if var_64_0:isLockWorldArena() then
		balloon_message_with_sound("character_arena_cannot_dispatch")
		
		return 
	end
	
	arg_64_0.vars.service:query("command", var_64_1, function(arg_66_0, arg_66_1)
		local var_66_0 = table.clone(arg_64_0.vars.pick_info)
		
		var_66_0[arg_64_0.vars.user_uid] = var_66_0[arg_64_0.vars.user_uid] or {}
		
		if arg_66_0 == ARENA_NET_REQUEST.REQUEST then
			if (arg_64_0.vars.count_limit[arg_64_0.vars.user_uid] or arg_64_0.vars.count_limit.both) > table.count(var_66_0[arg_64_0.vars.user_uid]) then
				table.insert(var_66_0[arg_64_0.vars.user_uid], var_64_1.unit)
			end
		elseif arg_66_0 == ARENA_NET_REQUEST.FAIL then
			local var_66_1 = table.find(var_66_0[arg_64_0.vars.user_uid], function(arg_67_0, arg_67_1)
				return var_64_1.unit.uid == arg_67_1.uid
			end)
			
			if var_66_1 then
				table.remove(var_66_0, var_66_1)
			end
		end
		
		arg_64_0:updateSlotInfo(var_66_0)
	end)
end

function ArenaNetReady.ban(arg_68_0)
	local var_68_0 = arg_68_0.vars.ban_info[arg_68_0.vars.enemy_uid]
	
	if var_68_0 and table.count(var_68_0) > 0 then
		return 
	end
	
	local var_68_1 = arg_68_0.vars.selected_slot
	
	if not var_68_1 or not var_68_1.unit then
		balloon_message_with_sound("arena_wa_ban_desc")
		
		return 
	end
	
	arg_68_0.vars.select_lock = true
	
	local var_68_2 = {
		type = "ban",
		slot = var_68_1.index
	}
	
	arg_68_0.vars.service:query("command", var_68_2, function(arg_69_0, arg_69_1)
		if arg_69_0 == ARENA_NET_REQUEST.REQUEST then
			arg_68_0.vars.step_btns.BAN:setOpacity(76.5)
			if_set(arg_68_0.vars.step_btns.BAN, "label", T("pvp_rta_wait_name"))
			table.each(arg_68_0.vars.slot_lists[arg_68_0.vars.user_uid], function(arg_70_0, arg_70_1)
				if not arg_70_1.ban and arg_70_1.unit and var_68_1.unit:getUID() == arg_70_1.unit:getUID() then
					arg_68_0.vars.wnd:getChildByName("n_ban"):removeAllChildren()
					EffectManager:Play({
						pivot_x = 0,
						fn = "ui_livepvp_bann_eff.cfx",
						pivot_y = 0,
						pivot_z = 99998,
						layer = arg_68_0.vars.wnd:getChildByName("n_ban")
					})
					arg_68_0:resetBlinkSlot(user, arg_70_0, arg_70_1)
					if_set_visible(arg_68_0.vars.wnd, "n_ban", arg_68_0.vars.seq_info.seq ~= "CHANGE")
					if_set_visible(arg_68_0.vars.wnd, "n_ban_ing", false)
					
					arg_70_1.ban = true
					
					arg_68_0:updatePortrait(arg_68_0.vars.user_uid, arg_70_1.unit, cc.c3b(95, 95, 95))
				end
			end)
		elseif arg_69_0 == ARENA_NET_REQUEST.FAIL then
			arg_68_0.vars.select_lock = false
			
			arg_68_0.vars.step_btns.BAN:setOpacity(255)
			if_set(arg_68_0.vars.step_btns.BAN, "label", T("arena_wa_btn_start"))
		end
	end)
end

function ArenaNetReady.ready(arg_71_0)
	if arg_71_0.vars.ready_info and arg_71_0.vars.ready_info[arg_71_0.vars.user_uid] then
		return 
	end
	
	if arg_71_0.vars.input_lock.CHANGE then
		return 
	end
	
	arg_71_0.vars.formation_editor:enableFormationEditMode(false)
	
	local var_71_0 = arg_71_0.vars.formation_editor:getTeam()
	
	if var_71_0 or arg_71_0.vars.ready_try and arg_71_0.vars.ready_try > 5 then
		if var_71_0 then
			Account:saveLocalCustomTeam("arena_net_last_team", var_71_0)
			
			local var_71_1 = {}
			
			for iter_71_0, iter_71_1 in pairs(var_71_0 or {}) do
				if iter_71_1 then
					var_71_1[iter_71_0] = {
						uid = iter_71_1:getUID(),
						point = iter_71_1:getPoint()
					}
				else
					var_71_1[iter_71_0] = nil
				end
			end
			
			local var_71_2 = {
				type = "ready",
				team = var_71_1
			}
			
			arg_71_0.vars.service:query("command", var_71_2, function(arg_72_0)
				if arg_72_0 == ARENA_NET_REQUEST.REQUEST then
					arg_71_0.vars.step_btns.CHANGE:setOpacity(76.5)
					if_set(arg_71_0.vars.step_btns.CHANGE, "label", T("pvp_rta_wait_name"))
				elseif arg_72_0 == ARENA_NET_REQUEST.FAIL then
					arg_71_0.vars.step_btns.BAN:setOpacity(255)
					if_set(arg_71_0.vars.step_btns.BAN, "label", T("arena_wa_btn_start"))
				end
			end)
		else
			Log.i("ready try count error")
		end
	else
		UIAction:Add(SEQ(DELAY(500), CALL(function()
			arg_71_0.vars.ready_try = (arg_71_0.vars.ready_try or 0) + 1
			
			arg_71_0:ready()
		end)), arg_71_0, "arena_net.ready")
	end
end

function ArenaNetReady.createTeamFromSlots(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0.vars.slot_lists[arg_74_1]
	local var_74_1 = {}
	
	for iter_74_0, iter_74_1 in pairs(var_74_0) do
		if not iter_74_1.ban then
			local var_74_2 = arg_74_0.vars.service:getGameInfo()
			
			if var_74_2 and var_74_2.rule == ARENA_NET_BATTLE_RULE.DRAFT then
				iter_74_1.unit:setUnitOptionValue("imprint_focus", iter_74_1.unit.draft_info.memory)
				
				iter_74_1.unit.is_draft_formation_unit = true
			end
			
			table.insert(var_74_1, iter_74_1.unit)
		end
	end
	
	return var_74_1
end

function ArenaNetReady.changeSequence(arg_75_0, arg_75_1, arg_75_2)
	if arg_75_0.vars.match_info.rule == ARENA_NET_BATTLE_RULE.E7WC2 and arg_75_0:getRoundCount() ~= 1 then
		arg_75_0.vars.finish_act_count = arg_75_0.vars.finish_act_count or 0
		arg_75_0.vars.finish_act_count = arg_75_0.vars.finish_act_count + 1
		
		if arg_75_0.vars.finish_act_count < 2 then
			if not arg_75_0:prebanFinishAct(arg_75_2) then
				local var_75_0 = arg_75_0:makeTotalPrebanInfo(arg_75_0.vars.accumulate_preban_info, arg_75_2)
				local var_75_1 = makePrebanNodes("left", var_75_0[arg_75_0.vars.user_uid])
				local var_75_2 = makePrebanNodes("right", var_75_0[arg_75_0.vars.enemy_uid])
				
				updatePrebanNodes(arg_75_0.vars.preban_node:getChildByName("n_face_l"), var_75_1)
				updatePrebanNodes(arg_75_0.vars.preban_node:getChildByName("n_face_r"), var_75_2)
				arg_75_0:actPrebanNode(true, 200, 1)
			end
			
			return 
		end
	end
	
	if not arg_75_1 then
		return 
	end
	
	if (arg_75_0.vars.seq_info.seq_id or 0) == arg_75_1.seq_id then
		return 
	end
	
	arg_75_0.vars.seq_info = arg_75_1
	
	if arg_75_0.vars.res_block then
		return 
	end
	
	if arg_75_1.seq == "PICK" then
		arg_75_0:updateBlinkSlot(arg_75_1)
	elseif arg_75_1.seq == "PICK_DRAFT" then
		arg_75_0.vars.res_block = true
		
		if not arg_75_0.vars.is_spectator and not ArenaNetCardSelector:isShow() then
			ArenaNetCardSelector:show({
				state = "start",
				user_uid = arg_75_0.vars.user_uid,
				enemy_uid = arg_75_0.vars.enemy_uid,
				infos = arg_75_1,
				callback = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
					if arg_76_0 == "pick" then
						arg_75_0.vars.service:query("command", {
							type = "draftpick",
							stage = arg_76_1,
							slot_id = arg_76_2,
							card_id = arg_76_3
						})
					elseif arg_76_0 == "finish" then
						arg_75_0.vars.res_block = false
					end
				end
			})
		else
			ArenaNetCardWatcher:show({
				state = "start",
				user_uid = arg_75_0.vars.user_uid,
				enemy_uid = arg_75_0.vars.enemy_uid,
				infos = arg_75_1,
				callback = function(arg_77_0, arg_77_1, arg_77_2)
					if arg_77_0 == "finish" then
						arg_75_0.vars.res_block = false
					end
				end
			})
		end
	end
	
	arg_75_0:updateGuideArrow()
	
	for iter_75_0, iter_75_1 in pairs(arg_75_0.vars.step_btns) do
		if get_cocos_refid(iter_75_1) then
			iter_75_1:setVisible(arg_75_1.seq == iter_75_0)
			
			if arg_75_0.vars.seq_info.user == arg_75_0.vars.user_uid or arg_75_0.vars.seq_info.user == "both" then
				iter_75_1:setOpacity(255)
				
				if iter_75_0 == "PICK" then
					if_set(iter_75_1, "label", T("pvp_rta_selection"))
				elseif iter_75_0 == "BAN" then
					if_set(iter_75_1, "label", T("arena_wa_btn_select"))
				elseif iter_75_0 == "CHANGE" then
					if_set(iter_75_1, "label", T("arena_wa_btn_start"))
				end
			else
				iter_75_1:setOpacity(76.5)
				if_set(iter_75_1, "label", T("pvp_rta_wait_name"))
			end
		end
	end
	
	if arg_75_1.seq_id ~= arg_75_0.vars.current_seq_id then
		arg_75_0.vars.current_seq_id = arg_75_1.seq_id
		
		if arg_75_1.count then
			arg_75_0.vars.count_limit = arg_75_0.vars.count_limit or {}
			arg_75_0.vars.count_limit[arg_75_1.user] = arg_75_0.vars.count_limit[arg_75_1.user] or 0
			arg_75_0.vars.count_limit[arg_75_1.user] = arg_75_0.vars.count_limit[arg_75_1.user] + arg_75_1.count
		end
	end
	
	if arg_75_1.seq ~= arg_75_0.vars.current_seq then
		arg_75_0.vars.current_seq = arg_75_1.seq
		
		if arg_75_1.seq == "PRE_BAN" then
			arg_75_0.vars.res_block = true
			
			if arg_75_0.vars.is_spectator then
				arg_75_0.vars.res_block = false
				
				if_set(arg_75_0.vars.wnd, "t_step", T("pvp_rta_mock_prebanning"))
				if_set_visible(arg_75_0.vars.wnd, "n_round_info", arg_75_0.vars.match_info.round_info)
			end
			
			ArenaNetPreBanPopup:init({
				parent = arg_75_0.vars.parent,
				user_id = arg_75_0.vars.user_uid,
				is_spectator = arg_75_0.vars.is_spectator,
				is_first_pick = arg_75_0.vars.user_uid == arg_75_0.vars.match_info.first_pick_arena_uid,
				preban_count = arg_75_0.vars.match_info.preban_count,
				accumulate_preban_arr = var_0_1(arg_75_0.vars.accumulate_preban_info, arg_75_0.vars.user_uid, arg_75_0.vars.enemy_uid),
				cbFinish = function(arg_78_0)
					arg_75_0:prebanFinishAct(arg_78_0)
				end
			})
		elseif arg_75_1.seq == "PICK" then
			if not arg_75_0.vars.is_spectator then
				if_set(arg_75_0.vars.wnd, "t_step", T("arena_wa_pick_name"))
			else
				if_set(arg_75_0.vars.wnd, "t_step", T("pvp_rta_mock_selecting_hero"))
			end
			
			if_set(arg_75_0.vars.wnd, "t_step_desc", T("arena_wa_pick_desc"))
			if_set_visible(arg_75_0.vars.wnd, "n_round_info", arg_75_0.vars.match_info.round_info)
		elseif arg_75_1.seq == "BAN" then
			if not arg_75_0.vars.is_spectator then
				if_set(arg_75_0.vars.wnd, "t_step", T("arena_wa_ban_name"))
			else
				arg_75_0.vars.ban_node:setVisible(true)
				if_set(arg_75_0.vars.wnd, "t_step", T("pvp_rta_mock_banning_hero"))
			end
			
			if_set(arg_75_0.vars.wnd, "t_step_desc", T("arena_wa_ban_desc"))
			
			local var_75_3 = arg_75_0.vars.service:getGameInfo()
			
			if var_75_3 and var_75_3.rule ~= ARENA_NET_BATTLE_RULE.DRAFT then
				if_set_add_position_y(arg_75_0.vars.wnd, "t_step_desc", -60)
			end
			
			if_set_visible(arg_75_0.vars.wnd, "n_ban_ing", not arg_75_0.vars.is_spectator)
			if_set_visible(arg_75_0.vars.wnd, "n_round_info", arg_75_0.vars.match_info.round_info)
			arg_75_0:resetPortrait()
			arg_75_0:actPrebanNode(false, 0, 1)
			
			if not arg_75_0.vars.is_spectator then
				local var_75_4 = arg_75_0.vars.wnd:getChildByName("n_round_info")
				
				if get_cocos_refid(var_75_4) then
					var_75_4:setPositionY(-70)
				end
			end
			
			arg_75_0.prev_code = nil
		elseif arg_75_1.seq == "CHANGE" then
			if not arg_75_0.vars.is_spectator then
				if_set(arg_75_0.vars.wnd, "t_step", T("arena_wa_posi_name"))
			else
				arg_75_0.vars.ban_node:setVisible(true)
				if_set(arg_75_0.vars.wnd, "t_step", T("pvp_rta_mock_ready_to_battle"))
			end
			
			if_set(arg_75_0.vars.wnd, "t_step_desc", T("arena_wa_posi_desc"))
			if_set_visible(arg_75_0.vars.wnd, "n_round_info", arg_75_0.vars.match_info.round_info)
			
			if not arg_75_0.vars.is_spectator then
				local var_75_5 = arg_75_0.vars.wnd:getChildByName("n_round_info")
				
				if get_cocos_refid(var_75_5) then
					var_75_5:setPositionY(-70)
				end
			end
			
			set_high_fps_tick(2000)
		end
		
		for iter_75_2, iter_75_3 in pairs(arg_75_0.vars.steps) do
			if get_cocos_refid(iter_75_3) then
				if arg_75_1.seq == iter_75_2 then
					iter_75_3:setColor(cc.c3b(28, 102, 237))
				else
					iter_75_3:setColor(cc.c3b(64, 64, 64))
				end
			end
		end
	end
end

function ArenaNetReady.updateRoundInfo(arg_79_0)
	if not arg_79_0.vars or not arg_79_0.vars.match_info or not arg_79_0.vars.match_info.round_info then
		return 
	end
	
	local var_79_0 = arg_79_0.vars.wnd:getChildByName("n_info")
	local var_79_1 = arg_79_0.vars.wnd:getChildByName("n_info_move_1")
	
	if var_79_0 and var_79_1 then
		var_79_0:setPositionY(var_79_1:getPositionY())
	end
	
	local var_79_2 = arg_79_0.vars.wnd:getChildByName("n_round_info")
	local var_79_3 = arg_79_0.vars.match_info.round_info
	local var_79_4 = arg_79_0.vars.match_info.round_info.total
	local var_79_5 = math.round(var_79_4 / 2)
	
	local function var_79_6(arg_80_0, arg_80_1)
		local var_80_0 = 0
		
		for iter_80_0, iter_80_1 in pairs(arg_80_0.rounds or {}) do
			if iter_80_1.winner and iter_80_1.winner == arg_80_1 then
				var_80_0 = var_80_0 + 1
			end
		end
		
		return var_80_0
	end
	
	local function var_79_7(arg_81_0, arg_81_1, arg_81_2)
		local var_81_0 = arg_81_0:getChildByName(arg_81_1)
		local var_81_1 = var_79_6(var_79_3, arg_81_2)
		
		for iter_81_0 = 1, 4 do
			local var_81_2 = var_81_0:getChildByName(tostring(iter_81_0))
			
			if iter_81_0 <= var_79_5 then
				var_81_2:setVisible(true)
				
				if iter_81_0 <= var_81_1 then
					SpriteCache:resetSprite(var_81_2, "img/pvplive_win_on.png")
				else
					SpriteCache:resetSprite(var_81_2, "img/pvplive_win_off.png")
				end
			else
				var_81_2:setVisible(false)
			end
		end
	end
	
	var_79_7(var_79_2, "n_left", arg_79_0.vars.user_uid)
	var_79_7(var_79_2, "n_right", arg_79_0.vars.enemy_uid)
	if_set(var_79_2, "t", T("war_ui_round", {
		round = table.count(var_79_3.rounds)
	}))
end

function ArenaNetReady.updateGuideArrow(arg_82_0)
	for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.guide_arrows) do
		if get_cocos_refid(iter_82_1) then
			iter_82_1:removeAllChildren()
		end
	end
	
	if arg_82_0.vars.seq_info.user == "both" or arg_82_0.vars.seq_info.user == arg_82_0.vars.user_uid then
		local var_82_0 = CACHE:getEffect("ui_livepvp_arrow_blue.cfx")
		
		var_82_0:start()
		arg_82_0.vars.guide_arrows[arg_82_0.vars.user_uid]:addChild(var_82_0)
	end
	
	if arg_82_0.vars.seq_info.user == "both" or arg_82_0.vars.seq_info.user == arg_82_0.vars.enemy_uid then
		local var_82_1 = CACHE:getEffect("ui_livepvp_arrow_red.cfx")
		
		var_82_1:start()
		arg_82_0.vars.guide_arrows[arg_82_0.vars.enemy_uid]:addChild(var_82_1)
	end
end

function ArenaNetReady.updateBlinkSlot(arg_83_0, arg_83_1)
	for iter_83_0, iter_83_1 in pairs(arg_83_0.vars.slot_lists) do
		if arg_83_1.user == iter_83_0 or arg_83_1.user == "both" then
			for iter_83_2 = 1, 5 do
				if iter_83_2 >= arg_83_1.start and iter_83_2 < arg_83_1.start + arg_83_1.count then
					arg_83_0:startBlinkSlot(iter_83_0, iter_83_2, iter_83_1[iter_83_2])
				end
			end
		else
			for iter_83_3 = 1, 5 do
				arg_83_0:resetBlinkSlot(iter_83_0, iter_83_3, iter_83_1[iter_83_3])
			end
		end
	end
end

function ArenaNetReady.startBlinkSlot(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
	local var_84_0 = arg_84_0.vars.user_uid == arg_84_1 and "blue" or "red"
	local var_84_1 = "ui_livepvp_slot_" .. tostring(var_84_0) .. tostring(arg_84_2) .. "_idle"
	local var_84_2 = arg_84_3:getChildByName("n_slot_eff")
	local var_84_3 = CACHE:getEffect(var_84_1 .. ".cfx")
	
	var_84_3:setVisible(true)
	var_84_3:start()
	var_84_2:addChild(var_84_3)
	if_set_visible(arg_84_3, "img_bg", false)
	UIAction:Add(LOOP(SEQ(FADE_OUT(500), FADE_IN(500))), arg_84_3, arg_84_3.name)
end

function ArenaNetReady.resetBlinkSlot(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	UIAction:Remove(arg_85_3.name)
	arg_85_3:setOpacity(255)
end

function ArenaNetReady.pickSlot(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	local var_86_0 = arg_86_0.vars.user_uid == arg_86_1 and "blue" or "red"
	local var_86_1 = "ui_livepvp_slot_" .. tostring(var_86_0) .. tostring(arg_86_2) .. "_set"
	
	if arg_86_4 then
		var_86_1 = "uieff_pvp_rta_draft_banpick_back_" .. tostring(var_86_0) .. "_0" .. tostring(arg_86_2)
	end
	
	local var_86_2 = arg_86_3:getChildByName("n_slot_eff")
	local var_86_3 = CACHE:getEffect(var_86_1 .. ".cfx")
	
	var_86_2:removeAllChildren()
	UIAction:Remove(arg_86_3.name)
	arg_86_3:setOpacity(255)
	var_86_3:start()
	var_86_2:addChild(var_86_3)
	
	if arg_86_0.vars.portrait then
		UIAction:Add(SPAWN(SEQ(LOG(BLEND(120, "white", 0, 1), 100), RLOG(BLEND(120, "white", 1, 0), 100), LOG(BLEND(0))), SEQ(LOG(SCALE(120, 1, 1.04)), RLOG(SCALE(120, 1.04, 1)))), arg_86_0.vars.portrait, "block")
	end
end

local function var_0_2(arg_87_0, arg_87_1, arg_87_2, arg_87_3)
	local var_87_0 = ArenaService:getGameInfo()
	local var_87_1 = string.starts(arg_87_0.name, "my")
	local var_87_2
	
	if var_87_0 and var_87_0.rule == ARENA_NET_BATTLE_RULE.DRAFT then
		var_87_2 = UNIT:create({
			g = 6,
			z = 6,
			d = 7,
			exp = 5000000000,
			f = 10,
			id = arg_87_1.uid,
			code = arg_87_1.code
		})
		var_87_2.draft_info = arg_87_1
	else
		var_87_2 = var_87_1 and Account:getUnit(arg_87_1.uid) or UNIT:create({
			id = arg_87_1.uid,
			code = arg_87_1.code,
			exp = arg_87_1.exp,
			g = arg_87_1.grade,
			z = arg_87_1.zodiac,
			awake = arg_87_1.awake
		})
		
		if var_87_1 then
			var_87_2 = var_87_2:clone()
			
			GrowthBoost:apply(var_87_2)
		end
	end
	
	if arg_87_1.skin_code then
		var_87_2:changeSkin(arg_87_1.skin_code)
	end
	
	SpriteCache:resetSprite(arg_87_0:getChildByName("face"), "face/" .. (var_87_2.db.face_id or "") .. "_l.png")
	SpriteCache:resetSprite(arg_87_0:getChildByName("role"), "img/cm_icon_role_" .. var_87_2.db.role .. ".png")
	SpriteCache:resetSprite(arg_87_0:getChildByName("element"), UIUtil:getColorIcon(var_87_2))
	
	if arg_87_3 then
		arg_87_0:getChildByName("face"):setFlippedX(false)
	elseif not arg_87_3 and var_87_1 then
		arg_87_0:getChildByName("face"):setFlippedX(true)
	end
	
	UIUtil:setLevel(arg_87_0, arg_87_1.g_lv or var_87_2:getLv(), arg_87_1.g_max_lv or var_87_2:getMaxLevel(), 6)
	UIUtil:setStarsByUnit(arg_87_0, var_87_2)
	if_set_visible(arg_87_0, "n_unit", true)
	if_set_visible(arg_87_0, "img_bg", not arg_87_2)
	
	return var_87_2
end

local function var_0_3(arg_88_0)
	if_set_visible(arg_88_0, "n_unit", false)
end

function ArenaNetReady.updateSelectingInfo(arg_89_0, arg_89_1)
	for iter_89_0, iter_89_1 in pairs(arg_89_1 or {}) do
		if table.find(arg_89_0.vars.slot_lists[iter_89_0], function(arg_90_0, arg_90_1)
			return arg_90_1.unit and iter_89_1.unit and arg_90_1.unit:getUID() == iter_89_1.unit.uid
		end) then
			iter_89_1.exist = true
		end
	end
	
	for iter_89_2, iter_89_3 in pairs(arg_89_1 or {}) do
		if iter_89_2 == arg_89_0.vars.seq_info.user then
			local var_89_0 = arg_89_0.vars.slot_lists[iter_89_2][iter_89_3.slot]
			
			if var_89_0 and not var_89_0.unit and not iter_89_3.exist then
				local var_89_1 = false
				
				if iter_89_2 == arg_89_0.vars.user_uid and table.find(not_allow_flip_units, iter_89_3.unit.code) then
					var_89_1 = true
				end
				
				local var_89_2 = var_0_2(var_89_0, iter_89_3.unit, true, var_89_1)
				
				arg_89_0:updatePortrait(iter_89_2, var_89_2)
			end
		end
	end
end

function ArenaNetReady.updateSlotInfo(arg_91_0, arg_91_1)
	if arg_91_1 then
		arg_91_0.vars.pick_info = arg_91_1
		
		for iter_91_0, iter_91_1 in pairs(arg_91_1 or {}) do
			for iter_91_2, iter_91_3 in pairs(iter_91_1) do
				local var_91_0 = arg_91_0.vars.slot_lists[iter_91_0][iter_91_2]
				
				if iter_91_3 and var_91_0 and (not var_91_0.unit or var_91_0.unit:getUID() ~= iter_91_3.uid) then
					local var_91_1 = false
					
					if iter_91_0 == arg_91_0.vars.user_uid and table.find(not_allow_flip_units, iter_91_3.code) then
						var_91_1 = true
					end
					
					local var_91_2 = var_0_2(var_91_0, iter_91_3, false, var_91_1)
					
					var_91_0.unit = var_91_2
					
					local var_91_3 = arg_91_0.vars.seq_info.seq == "PICK" and cc.c3b(255, 255, 255) or cc.c3b(95, 95, 95)
					
					if arg_91_0.vars.seq_info.seq ~= "BAN" then
						arg_91_0:updatePortrait(iter_91_0, var_91_2, var_91_3)
					end
					
					arg_91_0:pickSlot(iter_91_0, iter_91_2, var_91_0)
					arg_91_0:updateSlotVoice(var_91_0)
				elseif not iter_91_3 then
					var_91_0.unit = nil
					
					var_0_3(var_91_0)
				end
			end
		end
		
		if HeroBelt:isValid() then
			HeroBelt:updateCurrentViewItems(9)
		end
	end
end

function ArenaNetReady.updateSlotVoice(arg_92_0, arg_92_1)
	if arg_92_1.unit.db.model_id then
		if get_cocos_refid(arg_92_0.vars.voice1) then
			arg_92_0.vars.voice1:stop()
		end
		
		if get_cocos_refid(arg_92_0.vars.voice2) then
			arg_92_0.vars.voice2:stop()
		end
		
		arg_92_0.vars.voice1 = ccexp.SoundEngine:playBattle("event:/model/" .. arg_92_1.unit.db.model_id .. "/ani/" .. "b_idle_ready")
		arg_92_0.vars.voice2 = ccexp.SoundEngine:play("event:/voc/character/" .. arg_92_1.unit.db.model_id .. "/ani/" .. "b_idle_ready")
	end
end

function ArenaNetReady.actPrebanNode(arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	local var_93_0 = arg_93_0.vars.wnd:getChildByName("t_step")
	local var_93_1 = arg_93_0.vars.wnd:getChildByName("t_step_desc")
	local var_93_2 = arg_93_0.vars.wnd:getChildByName("n_round_info")
	local var_93_3 = 200
	
	if not arg_93_0.vars.preban_node then
		return 
	end
	
	if arg_93_1 then
		local var_93_4 = -var_93_3
		local var_93_5 = var_93_3 + (arg_93_3 - 1) * 50
		
		arg_93_0.vars.preban_node:setPositionY(var_93_4)
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_BY(arg_93_2, 0, var_93_5), 100)), arg_93_0.vars.preban_node, "block")
		
		if var_93_0 and var_93_1 then
			UIAction:Add(SEQ(LOG(MOVE_BY(arg_93_2, 0, arg_93_3 * 50), 100)), var_93_0, "block")
			UIAction:Add(SEQ(LOG(MOVE_BY(arg_93_2, 0, arg_93_3 * 50), 100)), var_93_1, "block")
		end
		
		if var_93_2 and not arg_93_0.vars.is_spectator then
			UIAction:Add(SEQ(LOG(MOVE_BY(arg_93_2, 0, (arg_93_3 - 1) * 90), 100)), var_93_2, "block")
		end
	else
		UIAction:Add(SEQ(LOG(MOVE_TO(arg_93_2, 0, -var_93_3), 100), SHOW(false)), arg_93_0.vars.preban_node, "block")
		
		if var_93_0 and var_93_1 then
			UIAction:Add(SEQ(LOG(MOVE_BY(0, 0, -(arg_93_3 * 50)), 100)), var_93_0, "block")
			UIAction:Add(SEQ(LOG(MOVE_BY(0, 0, -(arg_93_3 * 50)), 100)), var_93_1, "block")
		end
	end
end

function ArenaNetReady.loadRecentList(arg_94_0)
	if not arg_94_0.vars then
		return 
	end
	
	local var_94_0 = arg_94_0.vars.match_info.user_info.pre_ban
	
	if var_94_0 then
		local var_94_1 = {}
		local var_94_2 = json.decode(var_94_0)
		
		for iter_94_0, iter_94_1 in pairs(var_94_2) do
			if iter_94_1.code then
				local var_94_3 = UNIT:create({
					code = iter_94_1.code
				})
				
				if ArenaService:isInGlobalBanUnit({
					db = {
						code = iter_94_1.code
					}
				}) or var_94_3 and var_94_3:getBaseGrade() < 3 then
					table.insert(var_94_1, 1, iter_94_0)
				end
			end
		end
		
		for iter_94_2, iter_94_3 in ipairs(var_94_1) do
			table.remove(var_94_2, iter_94_3)
		end
		
		return var_94_2
	end
end

function ArenaNetReady.saveRecentList(arg_95_0, arg_95_1)
	if not arg_95_1 then
		return 
	end
	
	if arg_95_0.vars.is_spectator then
		return 
	end
	
	local var_95_0 = {}
	local var_95_1 = arg_95_0:loadRecentList()
	
	for iter_95_0, iter_95_1 in pairs(arg_95_1 or {}) do
		table.insert(var_95_0, {
			code = iter_95_1.code
		})
	end
	
	for iter_95_2, iter_95_3 in pairs(var_95_1 or {}) do
		local var_95_2 = table.count(var_95_0) == 4
		local var_95_3 = table.find(var_95_0, function(arg_96_0, arg_96_1)
			return arg_96_1.code == iter_95_3.code
		end)
		
		if var_95_2 then
			break
		elseif not var_95_3 then
			local var_95_4 = iter_95_3.code or iter_95_3.id
			
			if var_95_4 then
				local var_95_5 = UNIT:create({
					code = var_95_4
				})
				
				if var_95_5 and var_95_5:getBaseGrade() > 2 then
					table.insert(var_95_0, {
						code = var_95_4
					})
				end
			end
		end
	end
	
	MatchService:query("arena_net_preban_update", {
		pre_ban = json.encode(var_95_0)
	})
end

function ArenaNetReady.makeTotalPrebanInfo(arg_97_0, arg_97_1, arg_97_2)
	local var_97_0 = {
		[arg_97_0.vars.user_uid] = {},
		[arg_97_0.vars.enemy_uid] = {}
	}
	
	for iter_97_0, iter_97_1 in pairs(arg_97_1[arg_97_0.vars.user_uid] or {}) do
		table.insert(var_97_0[arg_97_0.vars.user_uid], iter_97_1)
	end
	
	for iter_97_2, iter_97_3 in pairs(arg_97_1[arg_97_0.vars.enemy_uid] or {}) do
		table.insert(var_97_0[arg_97_0.vars.enemy_uid], iter_97_3)
	end
	
	for iter_97_4, iter_97_5 in pairs(arg_97_2[arg_97_0.vars.user_uid] or {}) do
		table.insert(var_97_0[arg_97_0.vars.user_uid], iter_97_5)
	end
	
	for iter_97_6, iter_97_7 in pairs(arg_97_2[arg_97_0.vars.enemy_uid] or {}) do
		table.insert(var_97_0[arg_97_0.vars.enemy_uid], iter_97_7)
	end
	
	return var_97_0
end

function ArenaNetReady.prebanFinishAct(arg_98_0, arg_98_1)
	arg_98_1 = arg_98_1 or {}
	
	local var_98_0 = arg_98_0:makeTotalPrebanInfo(arg_98_0.vars.accumulate_preban_info, arg_98_1)
	local var_98_1 = makePrebanNodes("left", var_98_0[arg_98_0.vars.user_uid])
	local var_98_2 = makePrebanNodes("right", var_98_0[arg_98_0.vars.enemy_uid])
	local var_98_3 = {
		ally = {},
		enemy = {}
	}
	local var_98_4 = arg_98_0.vars.preban_node:getChildByName("n_face_l")
	
	for iter_98_0, iter_98_1 in pairs(arg_98_1[arg_98_0.vars.user_uid] or {}) do
		for iter_98_2, iter_98_3 in pairs(var_98_1 or {}) do
			if iter_98_3.code == iter_98_1.code then
				table.insert(var_98_3.ally, {
					node = var_98_4:getChildByName(iter_98_3.name)
				})
			end
		end
	end
	
	local var_98_5 = arg_98_0.vars.preban_node:getChildByName("n_face_r")
	
	for iter_98_4, iter_98_5 in pairs(arg_98_1[arg_98_0.vars.enemy_uid] or {}) do
		for iter_98_6, iter_98_7 in pairs(var_98_2 or {}) do
			if iter_98_7.code == iter_98_5.code then
				table.insert(var_98_3.enemy, {
					node = var_98_5:getChildByName(iter_98_7.name)
				})
			end
		end
	end
	
	arg_98_0.vars.res_block = false
	
	if not arg_98_1 or not arg_98_1[arg_98_0.vars.user_uid] or not arg_98_1[arg_98_0.vars.enemy_uid] or table.empty(arg_98_1[arg_98_0.vars.user_uid]) or table.empty(arg_98_1[arg_98_0.vars.enemy_uid]) then
		return 
	end
	
	local var_98_6 = {
		ally = {},
		enemy = {}
	}
	
	for iter_98_8, iter_98_9 in pairs(arg_98_1[arg_98_0.vars.user_uid] or {}) do
		table.insert(var_98_6.ally, DB("character", iter_98_9.code, "face_id"))
	end
	
	for iter_98_10, iter_98_11 in pairs(arg_98_1[arg_98_0.vars.enemy_uid] or {}) do
		table.insert(var_98_6.enemy, DB("character", iter_98_11.code, "face_id"))
	end
	
	if arg_98_0.vars.match_info.rule == ARENA_NET_BATTLE_RULE.E7WC2 and arg_98_0:getRoundCount() ~= 1 then
		arg_98_0.vars.res_block = true
		
		UIAction:Add(SEQ(DELAY(1200), CALL(function()
			set_high_fps_tick(5000)
			SceneManager:getRunningPopupScene():addChild(load_control("wnd/eff_dim.csb"))
			EffectManager:Play({
				scale = 1,
				z = 99999,
				fn = "uieff_pvplive_round2_trophy.cfx",
				layer = SceneManager:getRunningPopupScene(),
				x = DESIGN_WIDTH * 0.5,
				y = DESIGN_HEIGHT * 0.5,
				action = BattleAction
			})
		end), DELAY(2400), CALL(function()
			SceneManager:getRunningPopupScene():removeChildByName("eff_dim")
			actPreban(var_98_6, var_98_3, {
				preban_finish = function(arg_101_0, arg_101_1)
					arg_98_0.vars.res_block = false
				end
			})
		end)), SceneManager:getRunningNativeScene(), "act.round.event")
	else
		actPreban(var_98_6, var_98_3, {
			preban_finish = function(arg_102_0, arg_102_1)
			end
		})
	end
	
	return true
end

function testPrebanAct()
	local var_103_0 = {
		ally = {},
		enemy = {}
	}
	
	table.insert(var_103_0.ally, DB("character", "c1039", "face_id"))
	table.insert(var_103_0.enemy, DB("character", "c1027", "face_id"))
	
	local var_103_1 = {
		ally = {},
		enemy = {}
	}
	
	table.insert(var_103_1.ally, {})
	table.insert(var_103_1.enemy, {})
	UIAction:Add(SEQ(CALL(function()
		set_high_fps_tick(5000)
		SceneManager:getRunningPopupScene():addChild(load_control("wnd/eff_dim.csb"))
		EffectManager:Play({
			scale = 1,
			z = 99999,
			fn = "uieff_pvplive_round2_trophy.cfx",
			layer = SceneManager:getRunningPopupScene(),
			x = DESIGN_WIDTH * 0.5,
			y = DESIGN_HEIGHT * 0.5,
			action = BattleAction
		})
	end), DELAY(2500), CALL(function()
		SceneManager:getRunningPopupScene():removeChildByName("eff_dim")
		actPreban(var_103_0, var_103_1, {
			preban_finish = function(arg_106_0, arg_106_1)
			end
		})
	end)), SceneManager:getRunningNativeScene(), "act.round.event")
end

function ArenaNetReady.updatePrebanInfo(arg_107_0, arg_107_1)
	for iter_107_0, iter_107_1 in pairs(arg_107_1 or {}) do
		if not iter_107_1 or table.empty(iter_107_1) then
			return 
		end
	end
	
	if not table.empty(arg_107_0.vars.preban_info) then
		return 
	end
	
	arg_107_0.vars.preban_info = arg_107_1 or {}
	
	for iter_107_2, iter_107_3 in pairs(arg_107_0.vars.preban_info) do
		for iter_107_4, iter_107_5 in pairs(iter_107_3) do
			local var_107_0 = DB("character", iter_107_5.id or iter_107_5.code, {
				"set_group"
			})
			
			if var_107_0 then
				iter_107_5.set_group = var_107_0
			end
		end
	end
	
	arg_107_0:saveRecentList(arg_107_0.vars.preban_info[arg_107_0.vars.user_uid])
	
	local var_107_1 = arg_107_0:makeTotalPrebanInfo(arg_107_0.vars.accumulate_preban_info, arg_107_0.vars.preban_info)
	local var_107_2 = makePrebanNodes("left", var_107_1[arg_107_0.vars.user_uid])
	local var_107_3 = makePrebanNodes("right", var_107_1[arg_107_0.vars.enemy_uid])
	
	if arg_107_0.vars.preban_node then
		updatePrebanNodes(arg_107_0.vars.preban_node:getChildByName("n_face_l"), var_107_2)
		updatePrebanNodes(arg_107_0.vars.preban_node:getChildByName("n_face_r"), var_107_3)
	end
	
	arg_107_0:actPrebanNode(true, 200, 1)
	
	if HeroBelt:isValid() then
		HeroBelt:updateCurrentViewItems(9)
	end
end

function ArenaNetReady.updateTimeProgress(arg_108_0, arg_108_1)
	local var_108_0 = arg_108_0.vars.service:getGameInfo()
	local var_108_1 = arg_108_0.vars.seq_info.user
	
	for iter_108_0, iter_108_1 in pairs({
		arg_108_0.vars.user_uid,
		arg_108_0.vars.enemy_uid
	}) do
		if var_108_1 == iter_108_1 or var_108_1 == "both" then
			local var_108_2 = arg_108_1[iter_108_1]
			
			if var_108_2 and var_108_2.wait_time and var_108_2.total_time then
				local var_108_3 = var_108_2.total_time
				local var_108_4 = var_108_2.wait_time
				local var_108_5 = var_108_2.total_time - arg_108_0.vars.interval_time
				local var_108_6 = arg_108_0.vars.progress_bars[iter_108_1]
				
				if var_108_6 then
					local var_108_7 = math.clamp(100 * ((var_108_5 - var_108_4) / var_108_5), 0, 100)
					
					var_108_6:setPercent(var_108_7)
				end
				
				local var_108_8 = var_108_3 - var_108_4
				local var_108_9 = arg_108_0.vars.wnd:getChildByName("n_countdown")
				
				if var_108_9 then
					if var_108_0 and var_108_0.rule == ARENA_NET_BATTLE_RULE.DRAFT then
						var_108_9:setPositionY(60)
					end
					
					var_108_9:removeAllChildren()
					
					if var_108_8 >= 0 and var_108_8 <= var_108_2.total_time then
						local var_108_10 = cc.Label:createWithBMFont("font/score.fnt", math.clamp(var_108_8 - arg_108_0.vars.interval_time, 0, var_108_2.total_time))
						
						var_108_9:addChild(var_108_10)
					end
				end
				
				arg_108_0:setInputLock(var_108_8 - arg_108_0.vars.interval_time <= 0)
				
				arg_108_0.vars.rest_time[iter_108_1] = var_108_8 - arg_108_0.vars.interval_time
				
				arg_108_0:sendChangeInfo()
			end
		else
			local var_108_11 = arg_108_0.vars.progress_bars[iter_108_1]
			
			if get_cocos_refid(var_108_11) then
				var_108_11:setPercent(0)
			end
		end
	end
end

function ArenaNetReady.updatePingInfo(arg_109_0, arg_109_1)
	if not arg_109_1 then
		return 
	end
	
	if not get_cocos_refid(arg_109_0.vars.wnd) then
		return 
	end
	
	for iter_109_0, iter_109_1 in pairs(arg_109_1) do
		local var_109_0 = arg_109_0.vars.match_info
		local var_109_1, var_109_3
		
		if iter_109_1.ping and var_109_0 then
			var_109_1 = getNetCondition(tonumber(iter_109_1.ping))
			
			local var_109_2
			
			if iter_109_0 == var_109_0.user_info.uid then
				var_109_2 = arg_109_0.vars.wnd:getChildByName("n_my_info")
			elseif iter_109_0 == var_109_0.enemy_user_info.uid then
				var_109_2 = arg_109_0.vars.wnd:getChildByName("n_enemy_info")
			else
				return 
			end
			
			var_109_3 = var_109_2:getChildByName("n_ping")
			
			if var_109_3 then
				for iter_109_2 = 1, 3 do
					var_109_3:getChildByName(tostring(iter_109_2)):setVisible(var_109_1 == iter_109_2)
				end
			end
		end
	end
end

function ArenaNetReady.updateEnvInfo(arg_110_0, arg_110_1)
	if not arg_110_1 then
		return 
	end
	
	InBattleEsc:update(arg_110_1)
end

function ArenaNetReady.resetPortrait(arg_111_0)
	UIAction:Remove("arena.portrait")
	arg_111_0.vars.wnd:getChildByName("n_portrait"):removeAllChildren()
end

function ArenaNetReady.onRequest(arg_112_0, arg_112_1, arg_112_2, arg_112_3)
	if arg_112_3 then
		arg_112_3(arg_112_1, arg_112_2)
	end
end

function ArenaNetReady.onResponse(arg_113_0, arg_113_1, arg_113_2, arg_113_3)
	if PLATFORM == "win32" and not PRODUCTION_MODE and arg_113_0.vars and arg_113_0.vars.seq_infos then
		table.insert(arg_113_0.vars.seq_infos, arg_113_2)
	end
	
	if arg_113_0.vars.res_block then
		return 
	end
	
	local var_113_0 = table.count(arg_113_2 or {})
	
	if not arg_113_0.vars or var_113_0 == 0 or not arg_113_1 then
		return 
	end
	
	local var_113_1 = "on" .. string.ucfirst(arg_113_1)
	
	if arg_113_0[var_113_1] then
		arg_113_0[var_113_1](arg_113_0, arg_113_2, arg_113_3)
	end
end

function ArenaNetReady.onSelect(arg_114_0, arg_114_1)
	if arg_114_0.vars.selected_slot and arg_114_0.vars.selected_slot.index == arg_114_1.slot_idx then
		return 
	end
	
	local var_114_0 = arg_114_0.vars.slot_lists[arg_114_1.user_uid][arg_114_1.slot_idx]
	
	if arg_114_0.vars.selected_slot then
		local var_114_1 = cc.c3b(255, 255, 255)
		
		if_set_color(arg_114_0.vars.selected_slot, "img_bg", var_114_1)
		if_set_color(arg_114_0.vars.selected_slot, "n_unit", var_114_1)
	end
	
	if var_114_0 and var_114_0.unit then
		local var_114_2 = cc.c3b(75, 75, 75)
		
		if_set_color(var_114_0, "img_bg", var_114_2)
		if_set_color(var_114_0, "n_unit", var_114_2)
		
		arg_114_0.vars.selected_slot = var_114_0
		
		arg_114_0:updatePortrait(arg_114_1.user_uid, var_114_0.unit, cc.c3b(95, 95, 95))
		arg_114_0:sendChangeInfo()
	end
end

function ArenaNetReady.onWatch(arg_115_0, arg_115_1)
	if ClearResult:isShow() then
		return 
	end
	
	arg_115_0:updateState(arg_115_1)
	arg_115_0:checkFinished(arg_115_1.result)
	arg_115_0:changeSequence(arg_115_1.seqinfo, arg_115_1.prebaninfo)
	arg_115_0:updateSlotInfo(arg_115_1.pickinfo)
	arg_115_0:updateSelectingInfo(arg_115_1.selectinginfo)
	arg_115_0:updatePrebanInfo(arg_115_1.prebaninfo)
	arg_115_0:updateBanInfo(arg_115_1.baninfo)
	arg_115_0:updateTimeInfo(arg_115_1.timeinfo)
	arg_115_0:updatePingInfo(arg_115_1.pinginfo)
	arg_115_0:updateEnvInfo(arg_115_1.envinfo)
end

function ArenaNetReady.onReady(arg_116_0, arg_116_1)
	arg_116_0.vars.ready_info = arg_116_1.readyinfo
	
	arg_116_0.vars.step_btns.CHANGE:setOpacity(76.5)
	if_set(arg_116_0.vars.step_btns.CHANGE, "label", T("pvp_rta_wait_name"))
end

function ArenaNetReady.onPick(arg_117_0, arg_117_1)
	arg_117_0:changeSequence(arg_117_1.seqinfo)
	arg_117_0:updateSlotInfo(arg_117_1.pickinfo)
end

function ArenaNetReady.onPreban(arg_118_0, arg_118_1)
	arg_118_0:updatePrebanInfo(arg_118_1.prebaninfo)
end

function ArenaNetReady.onBan(arg_119_0, arg_119_1)
	arg_119_0.vars.step_btns.BAN:setOpacity(76.5)
	if_set(arg_119_0.vars.step_btns.BAN, "label", T("pvp_rta_wait_name"))
	arg_119_0:changeSequence(arg_119_1.seqinfo)
	arg_119_0:updateBanInfo(arg_119_1.baninfo)
end

function ArenaNetReady.onSelecting(arg_120_0, arg_120_1)
	arg_120_0:updateSelectingInfo(arg_120_1.selectinginfo)
end

function ArenaNetReady.onUnPick(arg_121_0, arg_121_1)
end

function ArenaNetReady.onChange(arg_122_0, arg_122_1)
end

function ArenaNetReady.openChatBox(arg_123_0)
	ChatMain:show(SceneManager:getRunningPopupScene(), nil, {
		section = "arena"
	})
	ArenaNetChat:updateMemberCount()
end

function ArenaNetReady.tip(arg_124_0, arg_124_1)
	if not arg_124_0.vars or not get_cocos_refid(arg_124_0.vars.n_tip_chat) then
		return 
	end
	
	if arg_124_0:isDisableTip() then
		return 
	end
	
	arg_124_0:hideTip()
	UIUtil:tip(arg_124_0.vars.n_tip_chat, arg_124_1)
end

function ArenaNetReady.tipEmoji(arg_125_0, arg_125_1)
	if not arg_125_0.vars or not get_cocos_refid(arg_125_0.vars.n_tip_emoji) then
		return 
	end
	
	if arg_125_0:isDisableTip() then
		return 
	end
	
	arg_125_0:hideTip()
	UIUtil:tipEmoji(arg_125_0.vars.n_tip_emoji, arg_125_1)
end

function ArenaNetReady.hideTip(arg_126_0)
	if not arg_126_0.vars then
		return 
	end
	
	if_set_visible(arg_126_0.vars.n_tip, nil, false)
	if_set_visible(arg_126_0.vars.n_tip_emoji, nil, false)
end

function ArenaNetReady.isDisableTip(arg_127_0)
	if ArenaService:isAdminMode() then
		return true
	end
	
	if ArenaNetChat:isDisabled() then
		return true
	end
	
	return false
end

function ArenaNetReady.checkChatNotification(arg_128_0)
	if not arg_128_0.vars then
		return 
	end
	
	if arg_128_0:isDisableTip() then
		return 
	end
	
	local var_128_0 = arg_128_0.vars.btn_top_chat
	local var_128_1 = arg_128_0.vars.btn_top_alram
	
	if not get_cocos_refid(var_128_0) or not get_cocos_refid(var_128_1) then
		return 
	end
	
	local var_128_2 = ChatMain:checkNotification()
	
	if_set_visible(var_128_1, nil, var_128_2)
	if_set_visible(var_128_0, nil, not var_128_2)
	
	if var_128_2 then
		if not get_cocos_refid(arg_128_0.vars.eff_chat_noti) then
			arg_128_0.vars.eff_chat_noti = ChatMain:getNotificationEffect(var_128_1:getChildByName("n_eff"))
		end
	elseif get_cocos_refid(arg_128_0.vars.eff_chat_noti) then
		arg_128_0.vars.eff_chat_noti:removeFromParent()
		
		arg_128_0.vars.eff_chat_noti = nil
	end
end

function ArenaNetReady.checkModelTouch(arg_129_0, arg_129_1, arg_129_2)
	if not arg_129_0.vars then
		return 
	end
	
	if arg_129_0.vars.current_seq ~= "CHANGE" then
		return 
	end
	
	local var_129_0 = arg_129_1:getLocation()
	local var_129_1 = {}
	local var_129_2 = arg_129_0.vars.formation_editor
	
	if not var_129_2 then
		return 
	end
	
	if var_129_2.vars.model_ids[3] then
		var_129_1[3] = var_129_2.vars.model_ids[3].model
	end
	
	if var_129_2.vars.model_ids[4] then
		var_129_1[4] = var_129_2.vars.model_ids[4].model
	end
	
	if var_129_2.vars.model_ids[1] then
		var_129_1[1] = var_129_2.vars.model_ids[1].model
	end
	
	if var_129_2.vars.model_ids[2] then
		var_129_1[2] = var_129_2.vars.model_ids[2].model
	end
	
	local var_129_3 = var_129_2.vars.formation_wnd
	
	if not var_129_3 then
		return 
	end
	
	if_set_visible(var_129_3, "n_scale", false)
	if_set_visible(var_129_3, "n_infos", false)
	
	local var_129_4 = slowpick(arg_129_0.vars.wnd, var_129_1, var_129_0.x, var_129_0.y)
	
	if_set_visible(var_129_3, "n_scale", true)
	if_set_visible(var_129_3, "n_infos", true)
	
	if var_129_4 then
		var_129_2.vars.touched_model_idx = var_129_4
		
		return true
	end
end

function ArenaNetReady.onTouchUp(arg_130_0, arg_130_1, arg_130_2)
	if not arg_130_0.vars or not arg_130_0.vars.mode then
		return 
	end
	
	return arg_130_0:checkModelTouch(arg_130_1, arg_130_2)
end

function ArenaNetReady.onTouchDown(arg_131_0, arg_131_1, arg_131_2)
end

function ArenaNetReady.onTouchMove(arg_132_0, arg_132_1, arg_132_2)
end

function ArenaNetReady.getBroadCastData(arg_133_0)
	local function var_133_0(arg_134_0, arg_134_1)
		if not arg_134_0 or not arg_134_1 or not arg_134_0[arg_134_1] then
			return {}
		end
		
		local var_134_0 = {}
		
		for iter_134_0, iter_134_1 in pairs(arg_134_0[arg_134_1]) do
			table.insert(var_134_0, iter_134_1.code)
		end
		
		return var_134_0
	end
	
	local function var_133_1(arg_135_0, arg_135_1, arg_135_2)
		local var_135_0 = {}
		
		arg_135_0 = arg_135_0 or {}
		
		local var_135_1 = 5
		
		if arg_135_2 and arg_135_2 >= 7 then
			var_135_1 = 7
		end
		
		for iter_135_0 = 1, var_135_1 do
			local var_135_2 = "round" .. tostring(iter_135_0) .. "Win"
			
			if arg_135_0[iter_135_0] then
				if arg_135_0[iter_135_0].state == "finish" or arg_135_0[iter_135_0].state == "benefit" then
					if arg_135_0[iter_135_0].winner == "draw" then
						var_135_0[var_135_2] = 0
					elseif arg_135_0[iter_135_0].winner == arg_135_1 then
						var_135_0[var_135_2] = 1
					else
						var_135_0[var_135_2] = -1
					end
				else
					var_135_0[var_135_2] = -2
				end
			else
				var_135_0[var_135_2] = -2
			end
		end
		
		return var_135_0
	end
	
	local function var_133_2(arg_136_0)
		return {
			name = arg_136_0.name,
			world = arg_136_0.world,
			clan_name = arg_136_0.clan_name,
			user_id = tostring(arg_136_0.user_id)
		}
	end
	
	if not arg_133_0.vars or not arg_133_0.vars.match_info then
		return 
	end
	
	local var_133_3 = arg_133_0.vars.match_info.user_info.uid
	local var_133_4 = arg_133_0.vars.match_info.enemy_user_info.uid
	local var_133_5 = arg_133_0.vars.match_info.round_info or {}
	local var_133_6 = {
		deviceID = BroadCastHelper.get_device_info(),
		header = {}
	}
	
	if var_133_5.rounds then
		var_133_6.header.cur_round = table.count(var_133_5.rounds)
	else
		var_133_6.header.cur_round = 1
	end
	
	var_133_6.header.tot_round = var_133_5.total or 1
	
	if arg_133_0.vars.match_info.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		var_133_6.header.game_type = 1
		var_133_6.header.firstPickPlayer = arg_133_0.vars.match_info.first_pick_arena_uid == var_133_3 and 1 or 2
	elseif arg_133_0.vars.match_info.rule == ARENA_NET_BATTLE_RULE.DRAFT then
		var_133_6.header.game_type = 2
		var_133_6.header.firstPickPlayer = 1
	end
	
	var_133_6.pickAndBanPlayer1 = {}
	var_133_6.pickAndBanPlayer1.playerInfo = var_133_2(arg_133_0.vars.match_info.user_info)
	var_133_6.pickAndBanPlayer1.roundInfo = var_133_1(var_133_5.rounds, arg_133_0.vars.match_info.user_info.uid, var_133_5.total)
	var_133_6.pickAndBanPlayer1.preBanHeroList = var_133_0(arg_133_0.vars.preban_info, arg_133_0.vars.match_info.user_info.uid)
	var_133_6.pickAndBanPlayer1.accumulatePreBanHeroList = var_133_0(arg_133_0.vars.accumulate_preban_info, arg_133_0.vars.match_info.user_info.uid)
	var_133_6.pickAndBanPlayer1.pickHeroList = var_133_0(arg_133_0.vars.pick_info, arg_133_0.vars.match_info.user_info.uid)
	var_133_6.pickAndBanPlayer1.banHeroList = var_133_0(arg_133_0.vars.ban_info, arg_133_0.vars.match_info.user_info.uid)
	var_133_6.pickAndBanPlayer1.isPreBanComplete = not table.empty(var_133_6.pickAndBanPlayer1.preBanHeroList)
	var_133_6.pickAndBanPlayer1.isBanComplete = not table.empty(var_133_6.pickAndBanPlayer1.banHeroList)
	var_133_6.pickAndBanPlayer2 = {}
	var_133_6.pickAndBanPlayer2.playerInfo = var_133_2(arg_133_0.vars.match_info.enemy_user_info)
	var_133_6.pickAndBanPlayer2.roundInfo = var_133_1(var_133_5.rounds, arg_133_0.vars.match_info.enemy_user_info.uid, var_133_5.total)
	var_133_6.pickAndBanPlayer2.preBanHeroList = var_133_0(arg_133_0.vars.preban_info, arg_133_0.vars.match_info.enemy_user_info.uid)
	var_133_6.pickAndBanPlayer2.accumulatePreBanHeroList = var_133_0(arg_133_0.vars.accumulate_preban_info, arg_133_0.vars.match_info.enemy_user_info.uid)
	var_133_6.pickAndBanPlayer2.pickHeroList = var_133_0(arg_133_0.vars.pick_info, arg_133_0.vars.match_info.enemy_user_info.uid)
	var_133_6.pickAndBanPlayer2.banHeroList = var_133_0(arg_133_0.vars.ban_info, arg_133_0.vars.match_info.enemy_user_info.uid)
	var_133_6.pickAndBanPlayer2.isPreBanComplete = not table.empty(var_133_6.pickAndBanPlayer2.preBanHeroList)
	var_133_6.pickAndBanPlayer2.isBanComplete = not table.empty(var_133_6.pickAndBanPlayer2.banHeroList)
	
	if diff_check(arg_133_0.vars.prev_broad_data or {}, var_133_6) then
		arg_133_0.vars.prev_broad_data = var_133_6
		
		ArenaWebSocket:save("/broad_cast_ready", var_133_6)
		
		return var_133_6
	end
	
	return nil
end

function ArenaNetReady.getBroadCastResultData(arg_137_0, arg_137_1, arg_137_2)
	if not arg_137_1 or not arg_137_2 or not arg_137_2.home_user_end_info then
		return 
	end
	
	if arg_137_1.game_info.rule ~= ARENA_NET_BATTLE_RULE.DRAFT then
		return 
	end
	
	if not MatchService:isBroadCastMode() then
		return 
	end
	
	local var_137_0 = "draw"
	
	if arg_137_2.winner ~= "draw" then
		if not arg_137_2.home_user_end_info then
			return 
		end
		
		local var_137_1 = tostring(arg_137_2.home_user_end_info.id)
		
		var_137_0 = tostring(arg_137_2.winner) == var_137_1 and "win" or "lose"
	end
	
	local var_137_2 = ArenaNetRoundNext:getBroadCastData(arg_137_1, arg_137_2, var_137_0)
	
	if var_137_2 then
		local var_137_3 = MatchService:getBroadCastUrl("result")
		
		ArenaWebSocket:createSingleShotWebSocket({
			scene = "result",
			url = var_137_3,
			data = var_137_2
		})
	end
end

function ArenaNetReady.save(arg_138_0)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local var_138_0 = {
		is_spectator = arg_138_0.vars.service:isSpectator(),
		game_info = arg_138_0.vars.service:getGameInfo(),
		match_info = arg_138_0.vars.match_info,
		seq_infos = arg_138_0.vars.seq_infos
	}
	local var_138_1 = json.encode(var_138_0)
	local var_138_2 = "/ready_seq"
	
	io.writefile(getenv("app.data_path") .. var_138_2, var_138_1)
end

function ArenaNetReady.load(arg_139_0)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	local var_139_0 = "/ready_seq"
	local var_139_1 = getenv("app.data_path") .. var_139_0
	local var_139_2 = io.open(var_139_1)
	
	if var_139_2 then
		local var_139_3 = var_139_2:read("*a")
		local var_139_4 = json.decode(var_139_3)
		
		arg_139_0.seq_idx = 0
		arg_139_0.seq_infos = var_139_4.seq_infos
		
		ArenaService:init(var_139_4.match_info, {
			not_use_network = true
		})
		ArenaService:setGameInfo(var_139_4.game_info)
		ArenaService:setMatchInfo(var_139_4.match_info)
		ArenaService:setSpectator(var_139_4.is_spectator or false)
		ArenaNetReady:show(nil, {
			service = ArenaService,
			match_info = var_139_4.match_info
		})
	end
end

function ArenaNetReady.next(arg_140_0)
	if PLATFORM ~= "win32" or PRODUCTION_MODE then
		return 
	end
	
	arg_140_0.seq_idx = arg_140_0.seq_idx + 1
	
	local var_140_0 = arg_140_0.seq_infos[arg_140_0.seq_idx]
	
	if var_140_0 then
		if var_140_0.prebaninfo and ArenaNetPreBanPopup.vars and get_cocos_refid(ArenaNetPreBanPopup.vars.wnd) and ArenaNetPreBanPopup.vars.wnd:isVisible() then
			ArenaNetPreBanPopup:close(var_140_0.prebaninfo)
		end
		
		LuaEventDispatcher:dispatchEvent("arena.service.res", "Watch", var_140_0)
	end
end

function ArenaNetReady.getRoundCount(arg_141_0)
	local var_141_0 = 0
	
	for iter_141_0, iter_141_1 in pairs(arg_141_0.vars.match_info.round_info.rounds) do
		if iter_141_1.state ~= "benefit" then
			var_141_0 = var_141_0 + 1
		end
	end
	
	return var_141_0
end

function ArenaNetReadyUser.setInputLock(arg_142_0, arg_142_1)
	local var_142_0 = arg_142_0.vars.seq_info.seq
	
	arg_142_0.vars.input_lock[var_142_0] = arg_142_1
	
	if var_142_0 == "CHANGE" and arg_142_1 then
		arg_142_0.vars.formation_editor:enableFormationEditMode(false)
		arg_142_0.vars.step_btns.CHANGE:setOpacity(76.5)
	end
end

function ArenaNetReadyUser.updatePortrait(arg_143_0, arg_143_1, arg_143_2, arg_143_3)
	if arg_143_0.prev_code == arg_143_2.db.code then
		return 
	end
	
	local var_143_0 = arg_143_0.vars.wnd:getChildByName("n_portrait")
	local var_143_1 = DB("character", arg_143_2:getDisplayCode(), "face_id")
	local var_143_2 = DB("character", arg_143_2.db.code, "emotion_id")
	
	if var_143_1 then
		local var_143_3, var_143_4 = UIUtil:getPortraitAni(var_143_1)
		
		if var_143_3 then
			var_143_0:removeAllChildren()
			var_143_0:addChild(var_143_3)
			var_143_3:setColor(arg_143_3 or cc.c3b(255, 255, 255))
			
			if not var_143_4 then
				var_143_3:setScale(0.8)
				var_143_3:setPositionY(550)
			end
			
			arg_143_0.vars.portrait = var_143_3
		end
	end
	
	arg_143_0.prev_code = arg_143_2.db.code
end

function ArenaNetReadyUser.updateBanInfo(arg_144_0, arg_144_1)
	if arg_144_1 then
		arg_144_0.vars.ban_info = arg_144_1
		
		local var_144_0 = table.count(arg_144_0.vars.ban_info)
		
		for iter_144_0, iter_144_1 in pairs(arg_144_1 or {}) do
			for iter_144_2, iter_144_3 in pairs(iter_144_1) do
				table.each(arg_144_0.vars.slot_lists[iter_144_0], function(arg_145_0, arg_145_1)
					if not arg_145_1.ban and iter_144_3 and arg_145_1.unit and iter_144_3.uid == arg_145_1.unit:getUID() then
						arg_144_0.vars.wnd:getChildByName("n_ban"):removeAllChildren()
						EffectManager:Play({
							pivot_x = 0,
							fn = "ui_livepvp_bann_eff.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							layer = arg_144_0.vars.wnd:getChildByName("n_ban")
						})
						arg_144_0:resetBlinkSlot(iter_144_0, arg_145_0, arg_145_1)
						if_set_visible(arg_144_0.vars.wnd, "n_ban", arg_144_0.vars.seq_info.seq ~= "CHANGE")
						if_set_visible(arg_144_0.vars.wnd, "n_ban_ing", false)
						
						arg_145_1.ban = true
						
						arg_144_0:updatePortrait(iter_144_0, arg_145_1.unit, cc.c3b(95, 95, 95))
					end
				end)
			end
		end
		
		if arg_144_0.vars.seq_info.seq == "CHANGE" then
			arg_144_0:updateFormation()
			if_set_visible(arg_144_0.vars.wnd, "n_ban", arg_144_0.vars.is_spectator)
			if_set_visible(arg_144_0.vars.wnd, "n_ban_ing", false)
			if_set_visible(arg_144_0.vars.wnd, "n_portrait", arg_144_0.vars.is_spectator)
			if_set_visible(arg_144_0.vars.wnd, "n_my_formation", true)
			
			for iter_144_4, iter_144_5 in pairs(arg_144_0.vars.ban_info or {}) do
				for iter_144_6, iter_144_7 in pairs(arg_144_0.vars.slot_lists[iter_144_4]) do
					if iter_144_7.ban then
						local var_144_1 = iter_144_7:getChildByName("n_ban")
						
						if not var_144_1:isVisible() then
							EffectManager:Play({
								pivot_x = 0,
								fn = "ui_livepvp_bann_eff.cfx",
								pivot_y = 0,
								pivot_z = 99998,
								scale = 0.5,
								layer = var_144_1
							})
						end
						
						var_144_1:setVisible(true)
						
						local var_144_2 = cc.c3b(75, 75, 75)
						
						if_set_color(iter_144_7, "img_bg", var_144_2)
						if_set_color(iter_144_7, "n_unit", var_144_2)
					else
						iter_144_7:getChildByName("n_ban"):setVisible(false)
						
						local var_144_3 = cc.c3b(255, 255, 255)
						
						if_set_color(iter_144_7, "img_bg", var_144_3)
						if_set_color(iter_144_7, "n_unit", var_144_3)
					end
				end
			end
		end
	end
end

function ArenaNetReadyUser.updateTimeInfo(arg_146_0, arg_146_1)
	if not arg_146_1 then
		return 
	end
	
	local var_146_0 = arg_146_0.vars.seq_info.user
	
	if_set_visible(arg_146_0.vars.wnd, "n_turn", true)
	
	if arg_146_0.vars.seq_info.seq == "PICK" then
		if_set(arg_146_0.vars.wnd, "t_my_turn", T("arena_wa_timer_you"))
		if_set(arg_146_0.vars.wnd, "t_enemy_turn", T("arena_wa_timer_enemy"))
		if_set_visible(arg_146_0.vars.wnd, "t_my_turn", var_146_0 == arg_146_0.vars.user_uid)
		if_set_visible(arg_146_0.vars.wnd, "t_enemy_turn", var_146_0 ~= arg_146_0.vars.user_uid)
	elseif arg_146_0.vars.seq_info.seq == "BAN" then
		if_set(arg_146_0.vars.wnd, "t_my_turn", T("arena_wa_ban_name"))
		if_set_visible(arg_146_0.vars.wnd, "t_enemy_turn", false)
	else
		if_set(arg_146_0.vars.wnd, "t_my_turn", T("battle_map_ready"))
		if_set_visible(arg_146_0.vars.wnd, "t_enemy_turn", false)
	end
	
	arg_146_0:updateTimeProgress(arg_146_1)
end

function ArenaNetReadyUser.setUserInfo(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
	local var_147_0 = arg_147_0.vars.service:getSeasonId()
	local var_147_1 = arg_147_2.league_id
	local var_147_2, var_147_3 = getArenaNetRankInfo(var_147_0, var_147_1)
	local var_147_4 = (arg_147_2.win or 0) + (arg_147_2.draw or 0) + (arg_147_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	if arg_147_0.vars.service:getMatchMode() == "net_event_rank" then
		var_147_4 = false
	end
	
	if var_147_4 then
		if_set(arg_147_1, "txt_user_rank", T(ARENA_UNRANK_TEXT))
	else
		if_set(arg_147_1, "txt_user_rank", T(var_147_2))
	end
	
	if arg_147_0.vars.service:getMatchMode() == "net_rank" and arg_147_3 == false then
		UIUtil:getUserIcon(arg_147_2.leader_code, {
			name = false,
			no_role = true,
			blind = true,
			no_popup = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_147_1:getChildByName("mob_icon"),
			border_code = arg_147_2.border_code
		})
		if_set(arg_147_1, "txt_name", T("pvp_blind_name"))
		if_set_visible(arg_147_1, "icon_menu_global", false)
		if_set_visible(arg_147_1, "txt_nation", false)
		if_set_visible(arg_147_1, "n_clan", false)
	else
		UIUtil:getUserIcon(arg_147_2.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_147_1:getChildByName("mob_icon"),
			border_code = arg_147_2.border_code
		})
		if_set(arg_147_1, "txt_name", check_abuse_filter(arg_147_2.name, ABUSE_FILTER.WORLD_NAME) or arg_147_2.name)
		if_set(arg_147_1, "txt_nation", getRegionText(arg_147_2.world))
		if_set(arg_147_1, "txt_clan", clanNameFilter(arg_147_2.clan_name))
		UIUtil:updateClanEmblem(arg_147_1:getChildByName("n_emblem"), {
			emblem = arg_147_2.clan_emblem
		})
		if_set_visible(arg_147_1, "n_emblem", string.len(arg_147_2.clan_name or "") > 0)
	end
	
	local var_147_5 = arg_147_1:getChildByName("txt_name")
	local var_147_6, var_147_7 = UIUtil:getTextWidthAndPos(arg_147_1, "txt_user_rank")
	local var_147_8 = 0
	
	if arg_147_3 then
		var_147_8 = var_147_7 + (var_147_6 + 10)
	else
		var_147_8 = var_147_7 - (var_147_6 + 10)
	end
	
	var_147_5:setPositionX(var_147_8)
end

function ArenaNetReadyUser.createFormation(arg_148_0)
	local var_148_0 = arg_148_0.vars.wnd:getChildByName("n_my_formation")
	
	var_148_0:removeAllChildren()
	
	local var_148_1 = load_dlg("pvplive_ready_formation", true, "wnd")
	
	var_148_1.class = arg_148_0
	
	var_148_0:addChild(var_148_1)
	
	local var_148_2 = {}
	
	CustomFormationEditor:initFormationEditor(var_148_2, {
		useSimpleTag = true,
		tagScale = 1,
		tagOffsetY = 80,
		model_scale = 1,
		hide_hpbar = true,
		hide_hpbar_color = true,
		wnd = var_148_1,
		callbackUpdateFormation = function(arg_149_0)
			arg_148_0:sendChangeInfo()
		end
	})
	var_148_1:setPosition(var_148_1:getContentSize().width * 0.5, var_148_1:getContentSize().height * 0.5)
	
	arg_148_0.vars.formation_editor = var_148_2
end

function ArenaNetReadyUser.showUnitList(arg_150_0, arg_150_1)
	if not arg_150_0.vars.unit_dock then
		arg_150_0:createUnitList()
	end
	
	if not get_cocos_refid(arg_150_0.vars.unit_dock:getWindow()) then
		return 
	end
	
	local var_150_0 = arg_150_0.vars.unit_dock:getWindow():getPositionX()
	
	if arg_150_1 then
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, var_150_0 - 300), 100)), arg_150_0.vars.unit_dock:getWindow(), "block")
	else
		UIAction:Add(SEQ(LOG(MOVE_TO(200, var_150_0 + 300), 100), SHOW(false)), arg_150_0.vars.unit_dock:getWindow(), "block")
	end
end

function ArenaNetReadyUser.updateUnitInfo(arg_151_0, arg_151_1)
	if not arg_151_0.vars or not arg_151_0.vars.wnd or not arg_151_0.vars.formation_editor then
		return 
	end
	
	for iter_151_0, iter_151_1 in pairs(arg_151_0.vars.team_info or {}) do
		if arg_151_1:getUID() == iter_151_1:getUID() then
			local var_151_0 = arg_151_1:getUnitOptionValue("imprint_focus")
			
			iter_151_1:setUnitOptionValue("imprint_focus", var_151_0)
			
			break
		end
	end
end

function ArenaNetReadyUser.updateFormation(arg_152_0)
	if not arg_152_0.vars.team_info then
		arg_152_0.vars.team_info = arg_152_0:createTeamFromSlots(arg_152_0.vars.user_uid)
		
		arg_152_0.vars.formation_editor:updateFormation(arg_152_0.vars.team_info)
	end
end

function ArenaNetReadyUser.updateAccumulatePrebanInfo(arg_153_0, arg_153_1)
end

function ArenaNetReadyUser.sendChangeInfo(arg_154_0)
	local var_154_0 = arg_154_0.vars.rest_time[arg_154_0.vars.user_uid]
	
	if not var_154_0 then
		return 
	end
	
	if var_154_0 < 0 or var_154_0 > 2 then
		return 
	end
	
	if arg_154_0.vars.seq_info.seq == "BAN" then
		local var_154_1 = arg_154_0.vars.selected_slot
		
		if not var_154_1 or not var_154_1.unit or not var_154_1.index then
			return 
		end
		
		arg_154_0.vars.service:query("command", {
			type = "change",
			slot = var_154_1.index
		})
	elseif arg_154_0.vars.seq_info.seq == "CHANGE" then
		local var_154_2 = arg_154_0.vars.formation_editor:getTeam()
		
		if not var_154_2 then
			return 
		end
		
		local var_154_3 = {}
		
		for iter_154_0, iter_154_1 in pairs(var_154_2 or {}) do
			if iter_154_1 then
				var_154_3[iter_154_0] = {
					uid = iter_154_1:getUID(),
					point = iter_154_1:getPoint()
				}
			else
				var_154_3[iter_154_0] = nil
			end
		end
		
		arg_154_0.vars.service:query("command", {
			type = "change",
			team = var_154_3
		})
	end
end

function ArenaNetReadyUser.onPushBackground(arg_155_0)
	if not arg_155_0.vars then
		return 
	end
	
	if arg_155_0.vars.current_seq ~= "CHANGE" then
		return 
	end
	
	arg_155_0.vars.formation_editor:setNormalMode()
end

function ArenaNetReadySpectator.updateTimeInfo(arg_156_0, arg_156_1)
	if not arg_156_1 then
		return 
	end
	
	local var_156_0 = arg_156_0.vars.seq_info.user
	
	if arg_156_0.vars.seq_info.seq == "PICK" then
		if_set_visible(arg_156_0.vars.wnd, "n_turn", true)
	else
		if_set_visible(arg_156_0.vars.wnd, "n_turn", false)
		if_set_visible(arg_156_0.vars.wnd, "t_my_turn", false)
		if_set_visible(arg_156_0.vars.wnd, "t_enemy_turn", false)
	end
	
	arg_156_0:updateTimeProgress(arg_156_1)
end

function ArenaNetReadySpectator.updatePortrait(arg_157_0, arg_157_1, arg_157_2, arg_157_3)
	if arg_157_0.prev_code == arg_157_2.db.code then
		return 
	end
	
	if arg_157_0.vars.seq_info.seq == "BAN" or arg_157_0.vars.seq_info.seq == "CHANGE" then
		return 
	end
	
	local var_157_0 = arg_157_0.vars.wnd:getChildByName("n_portrait")
	local var_157_1 = DB("character", arg_157_2:getDisplayCode(), "face_id")
	local var_157_2 = DB("character", arg_157_2.db.code, "emotion_id")
	
	if var_157_1 then
		local var_157_3, var_157_4 = UIUtil:getPortraitAni(var_157_1)
		
		if var_157_3 then
			var_157_0:removeAllChildren()
			var_157_0:addChild(var_157_3)
			var_157_3:setColor(arg_157_3 or cc.c3b(255, 255, 255))
			
			if not var_157_4 then
				var_157_3:setScale(0.8)
				var_157_3:setPositionY(550)
			end
			
			arg_157_0.vars.portrait = var_157_3
		end
		
		if_set(arg_157_0.vars.wnd, "t_my_turn", T(arg_157_2.db.name))
		if_set(arg_157_0.vars.wnd, "t_enemy_turn", T(arg_157_2.db.name))
		if_set_visible(arg_157_0.vars.wnd, "t_my_turn", arg_157_1 == arg_157_0.vars.user_uid)
		if_set_visible(arg_157_0.vars.wnd, "t_enemy_turn", arg_157_1 ~= arg_157_0.vars.user_uid)
	end
	
	arg_157_0.prev_code = arg_157_2.db.code
end

function ArenaNetReadySpectator.updateAccumulatePrebanInfo(arg_158_0, arg_158_1)
	if not arg_158_0.vars.accumulate_preban_node then
		return 
	end
	
	if table.empty(arg_158_0.vars.accumulate_preban_info) or arg_158_0.vars.current_seq ~= "PRE_BAN" then
		arg_158_0.vars.accumulate_preban_node:setVisible(false)
		
		return 
	end
	
	arg_158_0.vars.accumulate_preban_node:setVisible(true)
	
	local var_158_0 = arg_158_0:makeTotalPrebanInfo(arg_158_0.vars.accumulate_preban_info, {})
	local var_158_1 = makePrebanNodes("left", var_158_0[arg_158_0.vars.user_uid])
	local var_158_2 = makePrebanNodes("right", var_158_0[arg_158_0.vars.enemy_uid])
	
	updatePrebanNodes(arg_158_0.vars.accumulate_preban_node:getChildByName("n_face_l"), var_158_1)
	updatePrebanNodes(arg_158_0.vars.accumulate_preban_node:getChildByName("n_face_r"), var_158_2)
end

function ArenaNetReadySpectator.updateBanInfo(arg_159_0, arg_159_1)
	local function var_159_0(arg_160_0)
		local var_160_0 = {}
		
		for iter_160_0 = 1, 3 do
			var_160_0[iter_160_0] = arg_159_0.vars.ban_panel[arg_160_0]:getChildByName("loading_dot" .. tostring(iter_160_0))
		end
		
		local var_160_1 = arg_159_0.vars.ban_panel[arg_160_0]:getChildByName("ben_blind_hero")
		local var_160_2 = 0
		local var_160_3 = "dot.action." .. tostring(arg_160_0)
		local var_160_4 = "fade.action." .. tostring(arg_160_0)
		
		if not arg_159_0.vars.ban_info[arg_160_0] then
			if_set_visible(arg_159_0.vars.ban_panel[arg_160_0], "n_loding_choose", true)
			
			if not UIAction:Find(var_160_3) then
				UIAction:Add(LOOP(SEQ(DELAY(1000), CALL(function()
					var_160_2 = var_160_2 + 1
					
					for iter_161_0 = 1, 3 do
						var_160_0[iter_161_0]:setVisible(iter_161_0 == var_160_2 % 3 + 1)
					end
				end))), arg_159_0.vars.ban_panel[arg_160_0], var_160_3)
				UIAction:Add(LOOP(SEQ(FADE_OUT(400), FADE_IN(400), DELAY(200))), var_160_1, var_160_4)
			end
		else
			if_set_visible(arg_159_0.vars.ban_panel[arg_160_0], "n_hero_select_ban", true)
			if_set_visible(arg_159_0.vars.ban_panel[arg_160_0], "n_dot", false)
			var_160_1:setOpacity(255)
			UIAction:Remove(var_160_3)
			UIAction:Remove(var_160_4)
		end
	end
	
	local function var_159_1(arg_162_0)
		if_set_visible(arg_159_0.vars.ban_panel[arg_162_0], "n_loding_choose", false)
		if_set_visible(arg_159_0.vars.ban_panel[arg_162_0], "n_hero_select_ban", false)
	end
	
	local function var_159_2(arg_163_0, arg_163_1, arg_163_2)
		UIAction:Add(SEQ(FADE_IN(arg_163_2)), arg_163_1, "match.banner" .. tostring(arg_163_0))
	end
	
	local function var_159_3()
		local var_164_0 = arg_159_0.vars.wnd:getChildByName("n_ban")
		
		var_164_0:removeAllChildren()
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_livepvp_bann_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_164_0
		})
		var_164_0:setVisible(true)
		
		for iter_164_0, iter_164_1 in pairs(arg_159_0.vars.ban_info or {}) do
			for iter_164_2, iter_164_3 in pairs(arg_159_0.vars.slot_lists[iter_164_0]) do
				if iter_164_3.ban then
					local var_164_1 = iter_164_3:getChildByName("n_ban")
					
					if not var_164_1:isVisible() then
						EffectManager:Play({
							pivot_x = 0,
							fn = "ui_livepvp_bann_eff.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							scale = 0.5,
							layer = var_164_1
						})
					end
					
					var_164_1:setVisible(true)
					
					local var_164_2 = cc.c3b(75, 75, 75)
					
					if_set_color(iter_164_3, "img_bg", var_164_2)
					if_set_color(iter_164_3, "n_unit", var_164_2)
				else
					iter_164_3:getChildByName("n_ban"):setVisible(false)
					
					local var_164_3 = cc.c3b(255, 255, 255)
					
					if_set_color(iter_164_3, "img_bg", var_164_3)
					if_set_color(iter_164_3, "n_unit", var_164_3)
				end
			end
		end
	end
	
	local function var_159_4(arg_165_0)
		local var_165_0 = cc.GLProgramCache:getInstance():getGLProgram("GraySkeletonRenderer")
		
		if var_165_0 then
			local var_165_1 = cc.GLProgramState:create(var_165_0)
			
			if var_165_1 and arg_165_0.body then
				arg_165_0.body:setDefaultGLProgramState(var_165_1)
				arg_165_0.body:setGLProgramState(var_165_1)
			else
				arg_165_0:setDefaultGLProgramState(var_165_1)
				arg_165_0:setGLProgramState(var_165_1)
			end
		end
	end
	
	if not arg_159_1 then
		return 
	end
	
	arg_159_0.vars.ban_info = arg_159_1
	
	if arg_159_0.vars.seq_info.seq == "BAN" then
		if_set_visible(arg_159_0.vars.ban_line, nil, true)
		
		for iter_159_0, iter_159_1 in pairs({
			arg_159_0.vars.user_uid,
			arg_159_0.vars.enemy_uid
		}) do
			var_159_0(iter_159_1)
		end
	elseif arg_159_0.vars.seq_info.seq == "CHANGE" then
		for iter_159_2, iter_159_3 in pairs(arg_159_1 or {}) do
			for iter_159_4, iter_159_5 in pairs(iter_159_3) do
				table.each(arg_159_0.vars.slot_lists[iter_159_2], function(arg_166_0, arg_166_1)
					if not arg_166_1.ban and iter_159_5 and arg_166_1.unit and iter_159_5.uid == arg_166_1.unit:getUID() then
						arg_166_1.ban = true
					end
				end)
			end
		end
		
		for iter_159_6, iter_159_7 in pairs({
			arg_159_0.vars.user_uid,
			arg_159_0.vars.enemy_uid
		}) do
			local var_159_5 = arg_159_0.vars.ban_info[iter_159_7][1] or {}
			local var_159_6 = "portrait." .. tostring(iter_159_7)
			local var_159_7 = DB("character", var_159_5.code, "face_id")
			local var_159_8 = false
			
			if iter_159_7 == arg_159_0.vars.enemy_uid and table.find(not_allow_flip_units, var_159_5.code) then
				var_159_8 = true
			end
			
			local var_159_9 = arg_159_0.vars.ban_panel[iter_159_7]:getChildByName("n_ban_hero")
			
			var_159_9:setVisible(true)
			var_159_9:getChildByName("portrait"):setVisible(false)
			
			if var_159_7 and not var_159_9:getChildByName(var_159_6) then
				local var_159_10, var_159_11 = UIUtil:getPortraitAni(var_159_7)
				
				var_159_10:setScale(1)
				var_159_10:setName(var_159_6)
				var_159_10:setVisible(false)
				
				if not var_159_11 then
					var_159_10:setScale(0.8)
					var_159_10:setPositionY(550)
				end
				
				if var_159_8 and var_159_11 then
					var_159_10:setScaleX(-1)
				end
				
				var_159_9:addChild(var_159_10)
				UIAction:Add(SEQ(SEQ(CALL(function()
					var_159_0(iter_159_7)
				end), DELAY(600), CALL(function()
					var_159_1(iter_159_7)
				end), CALL(function()
					var_159_2(iter_159_7, var_159_10, 600)
				end), DELAY(800), CALL(function()
					var_159_3()
				end), CALL(function()
					var_159_4(var_159_10)
				end))), var_159_9, var_159_6)
			end
		end
	end
end

function ArenaNetReadySpectator.setUserInfo(arg_172_0, arg_172_1, arg_172_2, arg_172_3)
	local var_172_0 = arg_172_0.vars.service:getSeasonId()
	local var_172_1 = arg_172_2.league_id
	local var_172_2, var_172_3 = getArenaNetRankInfo(var_172_0, var_172_1)
	local var_172_4 = (arg_172_2.win or 0) + (arg_172_2.draw or 0) + (arg_172_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	UIUtil:getUserIcon(arg_172_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_172_1:getChildByName("mob_icon"),
		border_code = arg_172_2.border_code
	})
	if_set(arg_172_1, "txt_nation", getRegionText(arg_172_2.world))
	if_set(arg_172_1, "txt_name", arg_172_2.name)
	
	if var_172_4 then
		SpriteCache:resetSprite(arg_172_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		SpriteCache:resetSprite(arg_172_1:getChildByName("emblem"), "emblem/" .. var_172_3 .. ".png")
	end
	
	if_set(arg_172_1, "txt_clan", clanNameFilter(arg_172_2.clan_name))
	UIUtil:updateClanEmblem(arg_172_1:getChildByName("n_emblem"), {
		emblem = arg_172_2.clan_emblem
	})
	if_set_visible(arg_172_1, "n_emblem", string.len(arg_172_2.clan_name or "") > 0)
	
	local var_172_5 = string.len(arg_172_2.clan_name or "") > 0 and 0 or -13
	local var_172_6 = string.len(arg_172_2.clan_name or "") > 0 and 0 or 13
	
	if_set_add_position_y(arg_172_1, "txt_name", var_172_5)
	if_set_add_position_y(arg_172_1, "icon_menu_global", var_172_6)
	if_set_add_position_y(arg_172_1, "txt_nation", var_172_6)
	if_set_add_position_y(arg_172_1, "n_ping", var_172_6)
end

function ArenaNetReadySpectator.setInputLock(arg_173_0, arg_173_1)
	local var_173_0 = arg_173_0.vars.seq_info.seq
	
	arg_173_0.vars.input_lock[var_173_0] = arg_173_1
end

function ArenaNetReadySpectator.createFormation(arg_174_0)
end

function ArenaNetReadySpectator.showUnitList(arg_175_0, arg_175_1)
end

function ArenaNetReadySpectator.updateFormation(arg_176_0)
end

function ArenaNetReadySpectator.sendChangeInfo(arg_177_0)
end

function ArenaNetReadySpectator.onPushBackground(arg_178_0)
end

copy_functions(ArenaNetReady, ArenaNetReadyOrigin)
