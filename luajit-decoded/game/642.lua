ArenaNetCardSelector = {}
ArenaNetCardWatcher = {}
DRAFT_CARD_MAX = 3
DEBUG_USE_CARD_SHADER = true

function HANDLER.pvplive_card_selector(arg_1_0, arg_1_1)
	local var_1_0 = string.split(arg_1_1, "_")
	
	if arg_1_1 == "btn_edit1" then
		ArenaNetCardSelector:select()
	elseif arg_1_1 == "btn_step1" then
		ArenaNetCardSelector:pick()
	elseif arg_1_1 == "btn_swap" then
		ArenaNetCardSelector:swap()
	end
end

local function var_0_0(arg_2_0, arg_2_1)
	ArenaNetCardSelector:onScrollViewEvent(arg_2_0, arg_2_1)
end

function ArenaNetCardSelector.show(arg_3_0, arg_3_1)
	if ClearResult:isShow() then
		return 
	end
	
	arg_3_1 = arg_3_1 or {}
	
	local var_3_0 = arg_3_1.parent or SceneManager:getRunningPopupScene()
	local var_3_1 = load_dlg("pvplive_card_selector", true, "wnd")
	
	arg_3_0.mode = arg_3_0.mode or "talent"
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = var_3_1
	arg_3_0.vars.infos = arg_3_1.infos
	arg_3_0.vars.stage = arg_3_0.vars.infos.stage
	arg_3_0.vars.user_uid = arg_3_1.user_uid
	arg_3_0.vars.enemy_uid = arg_3_1.enemy_uid
	arg_3_0.vars.is_first_pick = false
	arg_3_0.vars.is_selected = false
	arg_3_0.vars.panel = cc.Layer:create()
	arg_3_0.vars.layer = cc.Layer:create()
	
	arg_3_0.vars.layer:addChild(arg_3_0.vars.panel)
	arg_3_0.vars.wnd:addChild(arg_3_0.vars.layer)
	arg_3_0.vars.panel:setContentSize(900, 600)
	
	arg_3_0.vars.cards = {}
	arg_3_0.vars.back_cards = {}
	arg_3_0.vars.callback = arg_3_1.callback
	arg_3_0.vars.listerer = LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetCardSelector.onResponse, arg_3_0), "arena.service.ready")
	arg_3_0.act_start_style = 1
	arg_3_0.act_finish_style = 1
	
	arg_3_0:cache()
	arg_3_0:createCards(arg_3_0.mode)
	UIAction:Add(SEQ(DELAY(10), CALL(function()
		arg_3_0:createBackCard()
	end)), arg_3_0, "block")
	var_3_0:addChild(var_3_1)
	arg_3_0:swap(arg_3_0.mode)
	arg_3_0:updateState({
		seq_state = arg_3_1.state
	})
end

function ArenaNetCardSelector.resetMode(arg_5_0)
	arg_5_0.mode = nil
end

function ArenaNetCardSelector.close(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	LuaEventDispatcher:removeEventListener(arg_6_0.vars.listerer)
	
	if arg_6_0.vars.callback then
		arg_6_0.vars.callback("finish")
	end
	
	arg_6_0.vars.wnd:removeFromParent()
	
	arg_6_0.vars = nil
end

function ArenaNetCardSelector.cache(arg_7_0)
	arg_7_0.vars.scrollview = arg_7_0.vars.wnd:getChildByName("scrollview")
	
	if arg_7_0.vars.scrollview then
		arg_7_0.vars.scrollview:setVisible(false)
		arg_7_0.vars.scrollview:setScrollBarEnabled(false)
		arg_7_0.vars.scrollview:addEventListener(var_0_0)
	end
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("CENTER")
	
	var_7_0:setPosition(150, 260)
	
	arg_7_0.vars.card_slots = {}
	
	for iter_7_0 = 1, DRAFT_CARD_MAX do
		local var_7_1 = var_7_0:getChildByName("n_card" .. tostring(iter_7_0))
		
		table.insert(arg_7_0.vars.card_slots, var_7_1)
	end
	
	arg_7_0.vars.ui_slider = arg_7_0.vars.wnd:getChildByName("Slider_btn")
	
	if get_cocos_refid(arg_7_0.vars.ui_slider) then
		arg_7_0.vars.ui_slider:addEventListener(function(arg_8_0, arg_8_1)
			if UIAction:Find("block") then
				return 
			end
			
			if arg_8_1 ~= 2 then
				return 
			end
			
			arg_7_0:swap()
		end)
	end
	
	arg_7_0.vars.txt_stat = arg_7_0.vars.wnd:getChildByName("txt_stat")
	arg_7_0.vars.txt_talent = arg_7_0.vars.wnd:getChildByName("txt_profile")
end

function ArenaNetCardSelector.isShow(arg_9_0)
	return arg_9_0.vars and get_cocos_refid(arg_9_0.vars.wnd)
end

function ArenaNetCardSelector.onScrollViewEvent(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.vars then
		return 
	end
end

function ArenaNetCardSelector.getPickInfos(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) or arg_11_0.vars.is_selected then
		return nil, nil
	end
	
	return arg_11_0.vars.stage, arg_11_0.vars.selected_slot_id
end

function ArenaNetCardSelector.updatePick(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 or not arg_12_2 then
		return 
	end
	
	if arg_12_0.vars.select_lock then
		return 
	end
	
	arg_12_0.vars.select_lock = true
	
	arg_12_0:onSelect(arg_12_1, arg_12_2)
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.card_slots or {}) do
		local var_12_0 = arg_12_0.vars.cards[iter_12_0]
		
		if iter_12_0 == arg_12_1 then
			UIAction:Add(SPAWN(SEQ(LOG(BLEND(620, "white", 0, 1), 100), RLOG(BLEND(620, "white", 1, 0), 100), LOG(BLEND(0))), SEQ(LOG(SCALE(120, 1, 1.04)), RLOG(SCALE(120, 1.04, 1)))), var_12_0, "block")
			var_12_0:onPick()
			
			if get_cocos_refid(arg_12_0.vars.voice1) then
				arg_12_0.vars.voice1:stop()
			end
			
			if get_cocos_refid(arg_12_0.vars.voice2) then
				arg_12_0.vars.voice2:stop()
			end
			
			arg_12_0.vars.voice1 = ccexp.SoundEngine:playBattle("event:/model/" .. var_12_0.unit.db.model_id .. "/ani/" .. "b_idle_ready")
			arg_12_0.vars.voice2 = ccexp.SoundEngine:play("event:/voc/character/" .. var_12_0.unit.db.model_id .. "/ani/" .. "b_idle_ready")
		else
			var_12_0:onDiscard()
		end
	end
	
	arg_12_0:updateDesc("pick")
end

function ArenaNetCardSelector.updateDesc(arg_13_0, arg_13_1)
	if arg_13_1 == "pick" then
		local var_13_0 = arg_13_0.vars.wnd:getChildByName("n_bottom")
		
		var_13_0:getChildByName("btn_step1"):setColor(cc.c3b(66, 66, 66))
		if_set(var_13_0, "txt_select", T("pvp_rta_wait_name"))
		if_set(var_13_0, "t_step_desc", T("pvp_rta_draft_wait"))
	end
end

function ArenaNetCardSelector.onSelect(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0.vars.selected_slot_id == arg_14_1 then
		return 
	end
	
	Log.i("draft card select", arg_14_1, arg_14_2)
	
	arg_14_0.vars.selected_slot_id = arg_14_1
	arg_14_0.vars.selected_card_id = arg_14_2
	
	arg_14_0:arrangeItems()
end

function ArenaNetCardSelector.createCards(arg_15_0, arg_15_1)
	for iter_15_0 = 1, DRAFT_CARD_MAX do
		local var_15_0 = arg_15_0.vars.infos.candidate[arg_15_0.vars.user_uid]
		local var_15_1 = ArenaNetCard:create({
			slot_id = iter_15_0,
			draft_card_id = var_15_0[iter_15_0].uid,
			mode = arg_15_1,
			callback = function(arg_16_0, arg_16_1)
				if not arg_15_0.vars.select_lock then
					arg_15_0:onSelect(arg_16_0, arg_16_1)
				end
			end
		})
		
		var_15_1:setAnchorPoint(0.5, 0.5)
		arg_15_0.vars.card_slots[iter_15_0]:addChild(var_15_1)
		table.insert(arg_15_0.vars.cards, var_15_1)
	end
end

function ArenaNetCardSelector.createBackCard(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.cards or {}) do
		local var_17_0 = 1.1
		local var_17_1 = cc.RenderTexture:create(iter_17_1:getContentSize().width * var_17_0, iter_17_1:getContentSize().height * var_17_0, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 37)
		
		var_17_1:clear(0, 0, 0, 0)
		var_17_1:retain()
		iter_17_1:setVisible(true)
		iter_17_1:setScale(1.1)
		iter_17_1:setAnchorPoint(0, 0)
		var_17_1:begin()
		iter_17_1:visit()
		var_17_1:endToLua()
		var_17_1:setScale(0.91)
		var_17_1:setVisible(false)
		iter_17_1:setScale(1)
		iter_17_1:setAnchorPoint(0.5, 0.5)
		iter_17_1:setVisible(false)
		iter_17_1:getParent():addChild(var_17_1)
		table.insert(arg_17_0.vars.back_cards, var_17_1)
	end
end

function ArenaNetCardSelector.findSlotIndexByUID(arg_18_0, arg_18_1, arg_18_2)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.infos.candidate[arg_18_1]) do
		if arg_18_2 == iter_18_1.uid then
			return iter_18_0
		end
	end
	
	return -1
end

function ArenaNetCardSelector.arrangeItems(arg_19_0)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.card_slots or {}) do
		if iter_19_0 == arg_19_0.vars.selected_slot_id then
			iter_19_1:setScale(1.05)
			arg_19_0.vars.cards[iter_19_0]:onSelect(true)
		else
			iter_19_1:setScale(0.95)
			arg_19_0.vars.cards[iter_19_0]:onSelect(false)
		end
	end
end

function ArenaNetCardSelector.onResponse(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = table.count(arg_20_2 or {})
	
	if not arg_20_0.vars or var_20_0 == 0 or not arg_20_1 then
		return 
	end
	
	local var_20_1 = "on" .. string.ucfirst(arg_20_1)
	
	if arg_20_0[var_20_1] then
		arg_20_0[var_20_1](arg_20_0, arg_20_2, arg_20_3)
	end
end

function ArenaNetCardSelector.onWatch(arg_21_0, arg_21_1)
	if not arg_21_0.vars or not arg_21_0.vars.listerer then
		return 
	end
	
	if arg_21_1.seqinfo then
		arg_21_0:updateState(arg_21_1.seqinfo, arg_21_1.pickinfo)
	end
	
	ArenaNetReady:updateState(arg_21_1)
	ArenaNetReady:updatePingInfo(arg_21_1.pinginfo)
	ArenaNetReady:checkFinished(arg_21_1.result)
	ArenaNetReady:updateTimeInfo(arg_21_1.timeinfo)
	
	arg_21_0.vars.seqinfo = arg_21_1.seqinfo
end

function ArenaNetCardSelector.updateState(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_0:isActing() or arg_22_0.vars.seqinfo and arg_22_0.vars.seqinfo.seq_state == "finish" then
		return 
	end
	
	local var_22_0 = arg_22_1.stage
	local var_22_1 = arg_22_1.seq_state
	
	Log.i("seq state", var_22_1)
	
	if var_22_1 == "finish" or var_22_0 and arg_22_0.vars.seqinfo and arg_22_0.vars.seqinfo.stage ~= var_22_0 or arg_22_1.seq == "BAN" or arg_22_1.seq == "CHANGE" then
		arg_22_0:act("finish", arg_22_1, arg_22_2)
	elseif var_22_1 == "start" then
		arg_22_0:act("start", arg_22_1, arg_22_2)
	elseif var_22_1 == "wait" then
		arg_22_0:act("wait", arg_22_1, arg_22_2)
	elseif var_22_1 == "add" then
		arg_22_0:act("add", arg_22_1, arg_22_2)
	else
		Log.i("invalid state", var_22_1)
	end
end

function ArenaNetCardSelector.isActing(arg_23_0)
	if UIAction:Find("selector.seq.start") or UIAction:Find("selector.seq.finish") then
		return true
	else
		for iter_23_0 = 1, 3 do
			if UIAction:Find("selector.seq.start." .. tostring(iter_23_0)) or UIAction:Find("selector.seq.finish." .. tostring(iter_23_0)) then
				return true
			end
		end
	end
	
	return false
end

function ArenaNetCardSelector.act(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if arg_24_0.cur_act == arg_24_1 then
		return 
	end
	
	if arg_24_1 == "start" then
		for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.cards or {}) do
			iter_24_1:setVisible(false)
		end
		
		UIAction:Add(SEQ(DELAY(100), CALL(function()
			arg_24_0:onStart()
		end)), arg_24_0.vars.wnd, "selector.seq.start")
	elseif arg_24_1 == "finish" then
		Log.i("종료중")
		UIAction:Add(SEQ(CALL(function()
			arg_24_0:onPick(arg_24_3)
		end), DELAY(600), CALL(function()
			arg_24_0:onBeforeFinish(arg_24_3)
		end), DELAY(600), CALL(function()
			arg_24_0:onFinish(arg_24_3)
		end)), arg_24_0.vars.wnd, "selector.seq.finish")
	elseif arg_24_1 == "wait" then
		Log.i("두명 선택 대기중")
	elseif arg_24_1 == "add" then
		Log.i("한명 선택 대기중")
		arg_24_0:onPick(arg_24_3)
	end
	
	arg_24_0.cur_act = arg_24_1
end

function ArenaNetCardSelector.onStart(arg_29_0)
	local var_29_0 = 100
	local var_29_1 = 5
	local var_29_2 = 0
	local var_29_3 = 200
	local var_29_4 = 200
	local var_29_5 = 150
	local var_29_6 = 100
	local var_29_7 = 0.8
	local var_29_8 = false
	local var_29_9 = false
	
	Log.i("시작중")
	
	local var_29_10 = {
		{
			act_sound = "event:/ui/pvp_draft/pvp_draft_sound_eff_1",
			delay = 100,
			init_pos = {
				-650,
				450
			},
			init_scale = var_29_1,
			init_opacity = var_29_2,
			scale_tm = var_29_0 + var_29_3,
			move_tm = var_29_0 + var_29_4,
			opacity_tm = var_29_0 + var_29_5,
			ratio_tm = var_29_0 + var_29_6
		},
		{
			init_scale = 2.5,
			delay = 250,
			init_pos = {
				0,
				450
			},
			init_opacity = var_29_2,
			scale_tm = var_29_0 + var_29_3,
			move_tm = var_29_0 + var_29_4,
			opacity_tm = var_29_0 + var_29_5,
			ratio_tm = var_29_0 + var_29_6
		},
		{
			delay = 400,
			init_pos = {
				650,
				450
			},
			init_scale = var_29_1,
			init_opacity = var_29_2,
			scale_tm = var_29_0 + var_29_3,
			move_tm = var_29_0 + var_29_4,
			opacity_tm = var_29_0 + var_29_5,
			ratio_tm = var_29_0 + var_29_6
		}
	}
	
	if arg_29_0.act_start_style == 2 then
		var_29_8 = true
		var_29_10[1].init_pos = {
			-450,
			450
		}
		var_29_10[2].init_pos = {
			-450,
			450
		}
		var_29_10[3].init_pos = {
			-450,
			450
		}
		var_29_10[1].init_scale = 0
		var_29_10[2].init_scale = 0
		var_29_10[3].init_scale = 0
		var_29_10[1].delay = 100
		var_29_10[2].delay = 150
		var_29_10[3].delay = 200
		var_29_10[1].scale_tm = 400
		var_29_10[2].scale_tm = 400
		var_29_10[3].scale_tm = 400
	end
	
	set_scene_fps(30, 60)
	set_high_fps_tick(5000)
	
	for iter_29_0, iter_29_1 in pairs(var_29_10 or {}) do
		local var_29_11 = var_29_10[iter_29_0]
		local var_29_12 = arg_29_0.vars.cards[iter_29_0]
		local var_29_13 = arg_29_0.vars.back_cards[iter_29_0]
		
		if var_29_9 then
			local var_29_14 = cc.GLProgramCache:getInstance():getGLProgram("sprite_blur")
			local var_29_15
			
			if var_29_14 and var_29_9 then
				local var_29_16 = cc.GLProgramState:create(var_29_14)
				
				if var_29_16 then
					var_29_16:setUniformVec2("u_resolution", {
						x = VIEW_WIDTH,
						y = VIEW_HEIGHT
					})
					var_29_16:setUniformVec2("u_direction", {
						x = 1,
						y = 0
					})
					var_29_16:setUniformFloat("u_range", 40)
					var_29_16:setUniformFloat("u_sample", 3)
					var_29_16:setUniformFloat("u_ratio", 0)
					var_29_13:getSprite():setDefaultGLProgramState(var_29_16)
					var_29_13:getSprite():setGLProgramState(var_29_16)
				end
			end
			
			var_29_13:setPosition(var_29_11.init_pos[1], var_29_11.init_pos[2])
			var_29_13:setScale(var_29_11.init_scale)
			var_29_13:setOpacity(var_29_11.init_opacity)
			
			local var_29_17 = 120
			
			UIAction:Add(SEQ(DELAY(var_29_11.delay), CALL(function()
				var_29_13:setVisible(true)
			end), SPAWN(LOG(SCALE(var_29_11.scale_tm, var_29_11.init_scale, 0.9), var_29_17), LOG(MOVE_TO(var_29_11.move_tm, 0, 0), var_29_17), LOG(OPACITY(var_29_11.opacity_tm, 0, 1)), LOG(LINEAR_CALL(500, nil, function(arg_31_0, arg_31_1)
				if var_29_8 then
					var_29_13:setRotationSkewY(arg_31_1)
				end
			end, 0, 1080), 30), LOG(LINEAR_CALL(var_29_11.ratio_tm, nil, function(arg_32_0, arg_32_1)
				local var_32_0 = var_29_13:getSprite():getGLProgramState()
				
				if var_32_0 then
					var_32_0:setUniformFloat("u_ratio", arg_32_1)
				end
			end, 0, 1))), CALL(function()
				var_29_12:setVisible(true)
				var_29_13:setVisible(false)
			end)), var_29_13, "selector.seq.start." .. tostring(iter_29_0))
		else
			var_29_12:setVisible(true)
			var_29_12:setPosition(var_29_11.init_pos[1], var_29_11.init_pos[2])
			var_29_12:setScale(var_29_11.init_scale)
			var_29_12:setOpacity(var_29_11.init_opacity)
			
			local var_29_18 = 80
			
			UIAction:Add(SEQ(DELAY(var_29_11.delay * var_29_7), CALL(function()
				var_29_12:setVisible(true)
			end), SPAWN(RLOG(SCALE(var_29_11.scale_tm * var_29_7, var_29_11.init_scale, 1), var_29_18), RLOG(MOVE_TO(var_29_11.move_tm * var_29_7, 0, 0), var_29_18), RLOG(OPACITY(var_29_11.opacity_tm * var_29_7, 0, 1))), CALL(function()
				if var_29_11.act_sound then
					SoundEngine:play(var_29_11.act_sound)
				end
			end)), var_29_12, "selector.seq.start." .. tostring(iter_29_0))
		end
	end
end

function ArenaNetCardSelector.pick(arg_36_0)
	if not arg_36_0.vars.selected_slot_id then
		balloon_message_with_sound("pvp_rta_draft_select_hero")
		
		return 
	end
	
	if arg_36_0.vars.select_lock then
		return 
	end
	
	arg_36_0:updatePick(arg_36_0.vars.selected_slot_id, arg_36_0.vars.selected_card_id)
	
	if arg_36_0.vars.callback then
		arg_36_0.vars.callback("pick", arg_36_0.vars.stage, arg_36_0.vars.selected_slot_id, arg_36_0.vars.selected_card_id)
		
		arg_36_0.vars.is_selected = true
	end
end

function ArenaNetCardSelector.onPick(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1[arg_37_0.vars.user_uid]
	local var_37_1 = var_37_0[arg_37_0.vars.stage]
	
	if not table.empty(var_37_1) and not arg_37_0.vars.is_first_pick then
		arg_37_0.vars.is_first_pick = true
		
		for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.card_slots or {}) do
			if iter_37_0 == arg_37_0:findSlotIndexByUID(arg_37_0.vars.user_uid, (var_37_0[arg_37_0.vars.stage] or {}).uid) then
				iter_37_1:setScale(1.05)
				arg_37_0.vars.cards[iter_37_0]:onPick()
				arg_37_0:updatePick(iter_37_0, (var_37_0[arg_37_0.vars.stage] or {}).uid)
			end
		end
	end
end

function ArenaNetCardSelector.onBeforeFinish(arg_38_0, arg_38_1)
	local var_38_0
	
	if arg_38_0.act_finish_style == 1 then
		var_38_0 = arg_38_1[arg_38_0.vars.user_uid]
		
		for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.card_slots or {}) do
			if iter_38_0 ~= arg_38_0:findSlotIndexByUID(arg_38_0.vars.user_uid, (var_38_0[arg_38_0.vars.stage] or {}).uid) then
				local var_38_1 = arg_38_0.vars.cards[iter_38_0]:getChildByName("n_eff_off")
				
				if_set_visible(var_38_1, nil, true)
				var_38_1:removeAllChildren()
				UIAction:Add(SEQ(CALL(function()
					EffectManager:Play({
						pivot_x = 0,
						fn = "uieff_pvp_rta_draft_dust_1.cfx",
						pivot_y = 0,
						pivot_z = 99998,
						layer = var_38_1
					}):setCascadeOpacityEnabled(false)
					SoundEngine:play("event:/ui/pvp_draft/pvp_draft_sound_eff_2")
				end), DELAY(66.5), RLOG(OPACITY(0, 1, 0))), arg_38_0.vars.cards[iter_38_0])
			end
		end
	end
end

function ArenaNetCardSelector.onFinish(arg_40_0, arg_40_1)
	local function var_40_0(arg_41_0, arg_41_1, arg_41_2)
		local var_41_0 = "selector.seq.spawn." .. tostring(arg_41_0)
		local var_41_1 = 30
		
		arg_41_1:setVisible(true)
		arg_41_1:setRotationSkewY(0)
		arg_41_0:setRotationSkewY(arg_41_2.init_skew_y)
		arg_41_0:setPosition(arg_41_2.init_pos[1], arg_41_2.init_pos[2])
		UIAction:Add(SEQ(SPAWN(LOG(SCALE(arg_41_2.scale_tm * arg_41_2.multi_tm, 0, 1), var_41_1), RLOG(LINEAR_CALL(arg_41_2.rotation_tm * arg_41_2.multi_tm, nil, function(arg_42_0, arg_42_1)
			arg_41_0:setRotationSkewY(arg_41_2.init_skew_y + -arg_42_1)
		end, 0, arg_41_2.init_skew_y), 30), RLOG(OPACITY(arg_41_2.opacity_tm * arg_41_2.multi_tm, 0, 1)), RLOG(MOVE_TO(arg_41_2.move_tm * arg_41_2.multi_tm, arg_41_2.target_pos[1], arg_41_2.target_pos[2])), CALL(function()
			local var_43_0 = arg_41_1:getChildByName("n_eff_fin")
			
			if_set_visible(var_43_0, nil, true)
			var_43_0:removeAllChildren()
			EffectManager:Play({
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 99998,
				fn = arg_41_2.select_loop_effect,
				layer = var_43_0
			})
		end))), arg_41_0, var_41_0)
	end
	
	local function var_40_1(arg_44_0, arg_44_1, arg_44_2)
		local var_44_0 = "selector.seq.moveToSlot." .. tostring(arg_44_0)
		
		arg_44_1:setVisible(true)
		arg_44_1:setOpacity(255)
		UIAction:Add(SEQ(CALL(function()
			local var_45_0 = arg_44_1:getChildByName("n_eff_off")
			
			if_set_visible(var_45_0, nil, true)
			var_45_0:removeAllChildren()
			EffectManager:Play({
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 99998,
				fn = arg_44_2.move_to_slot_effect,
				layer = var_45_0
			}):setCascadeOpacityEnabled(false)
		end), DELAY(66.5), RLOG(OPACITY(0, 1, 0))), arg_44_1, var_44_0)
	end
	
	local var_40_2 = arg_40_1[arg_40_0.vars.user_uid]
	local var_40_3 = arg_40_1[arg_40_0.vars.enemy_uid]
	local var_40_4 = {
		rotation_tm = 400,
		target_scale2 = 0,
		delay = 200,
		init_scale = 1,
		target_scale1 = 1.2,
		move_tm = 500,
		opacity_delay = 120,
		multi_tm = 0.2,
		rotation_delay = 120,
		target_scale_tm2 = 600,
		target_scale_tm1 = 100,
		opacity_tm = 600,
		init_pos = {
			-650,
			0
		}
	}
	local var_40_5 = {
		rotation_tm = 400,
		init_skew_y = 90,
		scale_tm = 400,
		move_tm = 400,
		move_to_slot_effect = "uieff_pvp_rta_draft_banpick_front_1.cfx",
		select_loop_effect = "uieff_pvp_rta_draft_select_1.cfx",
		multi_tm = 0.6,
		opacity_tm = 400,
		init_pos = {
			320,
			20
		},
		target_pos = {
			320,
			80
		}
	}
	local var_40_6 = {
		rotation_tm = 400,
		init_skew_y = -90,
		scale_tm = 400,
		move_tm = 400,
		move_to_slot_effect = "uieff_pvp_rta_draft_banpick_front_2.cfx",
		select_loop_effect = "uieff_pvp_rta_draft_select_2.cfx",
		multi_tm = 0.6,
		opacity_tm = 400,
		init_pos = {
			640,
			20
		},
		target_pos = {
			640,
			80
		}
	}
	
	if arg_40_0.act_finish_style == 1 then
		local var_40_7
		local var_40_8 = ArenaNetCard:create({
			slot_id = -1,
			draft_card_id = (var_40_2[arg_40_0.vars.stage] or {}).uid
		})
		local var_40_9
		
		var_40_8:setVisible(false)
		var_40_8:setAnchorPoint(0.5, 0.5)
		var_40_8:updateMode(arg_40_0.mode)
		
		local var_40_10
		local var_40_11 = ArenaNetCard:create({
			slot_id = -1,
			draft_card_id = (var_40_3[arg_40_0.vars.stage] or {}).uid
		})
		local var_40_12
		
		var_40_11:setVisible(false)
		var_40_11:setAnchorPoint(0.5, 0.5)
		var_40_11:updateMode(arg_40_0.mode)
		
		for iter_40_0, iter_40_1 in pairs(arg_40_0.vars.card_slots or {}) do
			local var_40_13 = arg_40_0.vars.cards[iter_40_0]
			local var_40_14 = "selector.seq.finish." .. tostring(iter_40_0)
			
			if iter_40_0 == arg_40_0:findSlotIndexByUID(arg_40_0.vars.user_uid, (var_40_2[arg_40_0.vars.stage] or {}).uid) then
				local var_40_15 = 120
				
				iter_40_1:addChild(var_40_8)
				
				var_40_9 = var_40_13
				var_40_7 = iter_40_1
				
				UIAction:Add(SEQ(DELAY(var_40_4.delay), SPAWN(CALL(function()
					var_40_13:onSelect(false)
					arg_40_0.vars.wnd:getChildByName("n_bottom"):setVisible(false)
				end), LOG(SCALE(var_40_4.target_scale_tm1 * var_40_4.multi_tm, var_40_4.init_scale, var_40_4.target_scale1), var_40_15)), SPAWN(RLOG(SCALE(var_40_4.target_scale_tm2 * var_40_4.multi_tm, var_40_4.target_scale1, var_40_4.target_scale2), var_40_15), SEQ(DELAY(var_40_4.rotation_delay * var_40_4.multi_tm), RLOG(LINEAR_CALL(var_40_4.rotation_tm * var_40_4.multi_tm, nil, function(arg_47_0, arg_47_1)
					var_40_13:setRotationSkewY(arg_47_1)
				end, 0, -90), var_40_15)), SEQ(DELAY(var_40_4.opacity_delay * var_40_4.multi_tm), RLOG(OPACITY(var_40_4.opacity_tm * var_40_4.multi_tm, 1, 0)))), DELAY(100), SPAWN(CALL(function()
					var_40_9:setVisible(false)
					var_40_12:setVisible(false)
				end), CALL(function()
					var_40_0(var_40_7, var_40_8, var_40_5)
				end), CALL(function()
					var_40_0(var_40_10, var_40_11, var_40_6)
				end)), DELAY(240), CALL(function()
					SoundEngine:play("event:/ui/pvp_draft/pvp_draft_sound_eff_3")
				end), DELAY(1500), SPAWN(CALL(function()
					var_40_1(var_40_7, var_40_8, var_40_5)
				end), CALL(function()
					var_40_1(var_40_10, var_40_11, var_40_6)
				end)), DELAY(200), CALL(function()
					ArenaNetReady:updateSlotInfo(arg_40_1)
				end), DELAY(600), CALL(function()
					arg_40_0:close()
				end)), iter_40_1, var_40_14)
			else
				if not var_40_10 then
					iter_40_1:addChild(var_40_11)
					
					var_40_12 = var_40_13
					var_40_10 = iter_40_1
				end
				
				UIAction:Add(SEQ(DELAY(var_40_4.delay + var_40_4.target_scale_tm1 * var_40_4.multi_tm), LOG(OPACITY(var_40_4.opacity_tm * var_40_4.multi_tm, 1, 0))), iter_40_1, var_40_14)
			end
		end
	elseif arg_40_0.act_finish_style == 2 then
		local var_40_16 = 0
		local var_40_17 = 1.24
		local var_40_18 = 1.05
		
		if var_40_2 then
			local var_40_19 = ArenaNetCard:create({
				slot_id = -1,
				draft_card_id = (var_40_2[arg_40_0.vars.stage] or {}).uid
			})
			
			var_40_19:setScale(var_40_16)
			var_40_19:setAnchorPoint(0.5, 0.5)
			var_40_19:setPosition(330, 86)
			arg_40_0.vars.wnd:getChildByName("CENTER"):addChild(var_40_19)
			UIAction:Add(SEQ(LOG(SCALE(120, var_40_16, var_40_17)), RLOG(SCALE(120, var_40_17, var_40_18))), var_40_19)
		end
		
		if var_40_3 then
			local var_40_20 = ArenaNetCard:create({
				slot_id = -1,
				draft_card_id = (var_40_3[arg_40_0.vars.stage] or {}).uid
			})
			
			var_40_20:setScale(var_40_16)
			var_40_20:setAnchorPoint(0.5, 0.5)
			var_40_20:setPosition(670, 86)
			arg_40_0.vars.wnd:getChildByName("CENTER"):addChild(var_40_20)
			UIAction:Add(SEQ(LOG(SCALE(120, var_40_16, var_40_17)), RLOG(SCALE(120, var_40_17, var_40_18))), var_40_20)
		end
		
		arg_40_0.vars.wnd:getChildByName("n_bottom"):setVisible(false)
	elseif arg_40_0.act_finish_style == 3 then
	end
end

function ArenaNetCardSelector.spawnCard(arg_56_0, arg_56_1, arg_56_2)
end

function ArenaNetCardSelector.swap(arg_57_0, arg_57_1)
	if arg_57_1 then
		arg_57_0.mode = arg_57_1
	elseif arg_57_0.mode == "stat" then
		arg_57_0.mode = "talent"
	else
		arg_57_0.mode = "stat"
	end
	
	arg_57_0:updateToggleText()
	arg_57_0.vars.ui_slider:setPercent(arg_57_0.mode == "stat" and 0 or 100)
	
	for iter_57_0, iter_57_1 in pairs(arg_57_0.vars.cards) do
		iter_57_1:updateMode(arg_57_0.mode)
	end
end

function ArenaNetCardSelector.updateToggleText(arg_58_0)
	if arg_58_0.mode == "talent" then
		arg_58_0.vars.txt_stat:setTextColor(tocolor("#949494"))
		arg_58_0.vars.txt_talent:setTextColor(tocolor("#ffbd63"))
	else
		arg_58_0.vars.txt_stat:setTextColor(tocolor("#ffbd63"))
		arg_58_0.vars.txt_talent:setTextColor(tocolor("#949494"))
	end
end

function ArenaNetCardSelector.test1(arg_59_0, arg_59_1)
	local var_59_0 = load_dlg("unit_base", true, "wnd")
	
	SceneManager:getDefaultLayer():addChild(var_59_0)
	
	local var_59_1 = load_dlg("pvplive_ready_draft", true, "wnd")
	
	var_59_0:addChild(var_59_1)
	
	local var_59_2 = 1
	local var_59_3 = 2
	local var_59_4 = {
		stage = 1,
		candidate = {}
	}
	
	var_59_4.candidate[var_59_2] = {}
	var_59_4.candidate[var_59_3] = {}
	
	for iter_59_0, iter_59_1 in pairs({
		7,
		16,
		28
	}) do
		table.insert(var_59_4.candidate[var_59_2], {
			uid = iter_59_1
		})
	end
	
	for iter_59_2, iter_59_3 in pairs({
		3,
		11,
		19
	}) do
		table.insert(var_59_4.candidate[var_59_3], {
			uid = iter_59_3
		})
	end
	
	ArenaNetCardSelector:show({
		state = "start",
		infos = var_59_4,
		user_uid = var_59_2,
		enemy_uid = var_59_3,
		callback = function(arg_60_0, arg_60_1, arg_60_2)
			local var_60_0 = {
				[var_59_2] = {}
			}
			
			table.insert(var_60_0[var_59_2], var_59_4.candidate[var_59_2][arg_60_1])
			arg_59_0:updateState({
				seq_state = "add"
			}, var_60_0)
		end
	})
end

function ArenaNetCardSelector.test2(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = load_dlg("unit_base", true, "wnd")
	
	SceneManager:getDefaultLayer():addChild(var_61_0)
	
	local var_61_1 = load_dlg("pvplive_ready_draft", true, "wnd")
	
	var_61_0:addChild(var_61_1)
	
	local var_61_2 = 1
	local var_61_3 = 2
	local var_61_4 = {
		stage = 1,
		candidate = {}
	}
	
	var_61_4.candidate[var_61_2] = {}
	var_61_4.candidate[var_61_3] = {}
	
	for iter_61_0, iter_61_1 in pairs(arg_61_1 or {
		7,
		16,
		28
	}) do
		table.insert(var_61_4.candidate[var_61_2], {
			uid = iter_61_1
		})
	end
	
	for iter_61_2, iter_61_3 in pairs(arg_61_2 or {
		3,
		11,
		19
	}) do
		table.insert(var_61_4.candidate[var_61_3], {
			uid = iter_61_3
		})
	end
	
	ArenaNetCardSelector:show({
		state = "start",
		infos = var_61_4,
		user_uid = var_61_2,
		enemy_uid = var_61_3,
		callback = function(arg_62_0, arg_62_1, arg_62_2)
			local var_62_0 = {
				[var_61_2] = {},
				[var_61_3] = {}
			}
			
			table.insert(var_62_0[var_61_2], var_61_4.candidate[var_61_2][arg_62_1])
			table.insert(var_62_0[var_61_3], var_61_4.candidate[var_61_3][2])
			arg_61_0:updateState({
				seq_state = "finish"
			}, var_62_0)
		end
	})
end

function ArenaNetCardSelector.eff0(arg_63_0)
	local var_63_0 = 1
	local var_63_1 = 2
	local var_63_2 = arg_63_0.vars.cards[1]
	
	Log.e("ttttt", var_63_2)
	
	local var_63_3 = 0
	
	UIAction:Add(LOOP(SEQ(DELAY(40), CALL(function()
		var_63_3 = var_63_3 + 10
	end)), 100), var_63_2, "eff0")
	
	local var_63_4 = 500
	local var_63_5 = 400
	local var_63_6 = 10
	local var_63_7 = 30
	
	var_63_2:setScale(0)
	var_63_2:setPosition(-300, 300)
	UIAction:Add(SPAWN(LOG(MOVE_TO(var_63_4, 0, 0)), LOG(SCALE(var_63_4, 0, 1), var_63_6), LOG(LINEAR_CALL(var_63_4 + var_63_5, nil, function(arg_65_0, arg_65_1)
		var_63_2:setRotationSkewY(arg_65_1)
	end, 0, 2160), var_63_7)), var_63_2)
end

function getCard(arg_66_0)
	local var_66_0 = arg_66_0 or 2
	
	return ArenaNetCardSelector.vars.cards[var_66_0]
end

function ArenaNetCardSelector.eff1(arg_67_0)
	local var_67_0 = arg_67_0.vars.cards[1]:getChildByName("n_frame")
	local var_67_1 = cc.GLProgramCache:getInstance():getGLProgram("sprite_glow")
	
	if var_67_1 then
		local var_67_2 = cc.GLProgramState:create(var_67_1)
		
		if var_67_2 then
			var_67_2:setUniformFloat("u_ctime", 0)
			var_67_2:setUniformFloat("u_gtime", 1)
			var_67_2:setUniformFloat("u_radius", 1)
			var_67_2:setUniformVec4("u_color", cc.vec4(1, 0.9, 0, 1))
			var_67_0:setDefaultGLProgramState(var_67_2)
			var_67_0:setGLProgramState(var_67_2)
			
			local var_67_3 = systick()
			local var_67_4 = 0
			
			UIAction:Add(LOOP(SEQ(DELAY(40), CALL(function()
				local var_68_0 = var_67_0:getGLProgramState()
				
				if var_68_0 then
					var_67_4 = var_67_4 + (systick() - var_67_3)
					var_67_3 = systick()
					
					var_68_0:setUniformFloat("u_ctime", math.sin(var_67_4 * 0.2 % 314 * 0.01))
				end
			end)), 100), var_67_0, "eff1")
		end
	end
end

function ArenaNetCardSelector.eff2(arg_69_0)
	local var_69_0 = arg_69_0.vars.cards[1]:getChildByName("n_frame")
	local var_69_1 = ArenaNetCard:create({
		draft_card_id = 12
	})
	local var_69_2 = 1.1
	
	arg_69_0.tex_map = cc.RenderTexture:create(var_69_1:getContentSize().width * var_69_2, var_69_1:getContentSize().height * var_69_2, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 37)
	
	arg_69_0.tex_map:clear(0, 0, 0, 0)
	arg_69_0.tex_map:retain()
	var_69_1:setScale(1.1)
	var_69_1:setAnchorPoint(0, 0)
	arg_69_0.tex_map:begin()
	var_69_1:visit()
	arg_69_0.tex_map:endToLua()
	arg_69_0.tex_map:setPosition(400, 300)
	arg_69_0.vars.wnd:addChild(arg_69_0.tex_map)
	
	local var_69_3 = cc.Director:getInstance():getTextureCache():addImage("img/dissolve_noise.png")
	local var_69_4 = cc.GLProgramCache:getInstance():getGLProgram("sprite_dissolve")
	
	if var_69_4 then
		local var_69_5 = cc.GLProgramState:create(var_69_4)
		
		if var_69_5 then
			var_69_5:setUniformTexture("u_texNoise", var_69_3)
			var_69_5:setUniformFloat("u_outline", 1.04)
			var_69_5:setUniformVec4("u_outlineColor", cc.vec4(0, 0, 0, 1))
			arg_69_0.tex_map:getSprite():setDefaultGLProgramState(var_69_5)
			arg_69_0.tex_map:getSprite():setGLProgramState(var_69_5)
			UIAction:Add(LOG(LINEAR_CALL(3000, nil, function(arg_70_0, arg_70_1)
				local var_70_0 = arg_69_0.tex_map:getSprite():getGLProgramState()
				
				if var_70_0 then
					var_70_0:setUniformFloat("u_cut", arg_70_1)
				end
			end, 0, 1)), arg_69_0.tex_map)
		end
	end
end

function ArenaNetCardSelector.eff3(arg_71_0)
	local var_71_0 = arg_71_0.vars.cards[1]
	local var_71_1 = var_71_0:getChildByName("n_frame")
	
	var_71_0:setVisible(false)
	
	local var_71_2 = ArenaNetCard:create({
		draft_card_id = 7
	})
	local var_71_3 = 1.1
	
	arg_71_0.tex_map = cc.RenderTexture:create(var_71_2:getContentSize().width * var_71_3, var_71_2:getContentSize().height * var_71_3, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 37)
	
	arg_71_0.tex_map:clear(0, 0, 0, 0)
	arg_71_0.tex_map:retain()
	var_71_2:setScale(1.1)
	var_71_2:setAnchorPoint(0, 0)
	arg_71_0.tex_map:begin()
	var_71_2:visit()
	arg_71_0.tex_map:endToLua()
	arg_71_0.tex_map:setScale(1.2)
	arg_71_0.tex_map:setPosition(200, 500)
	arg_71_0.vars.wnd:addChild(arg_71_0.tex_map)
	
	local var_71_4 = cc.GLProgramCache:getInstance():getGLProgram("sprite_blur")
	
	if var_71_4 then
		local var_71_5 = cc.GLProgramState:create(var_71_4)
		
		if var_71_5 then
			var_71_5:setUniformVec2("u_resolution", {
				x = VIEW_WIDTH,
				y = VIEW_HEIGHT
			})
			var_71_5:setUniformVec2("u_direction", {
				x = 1,
				y = 0
			})
			var_71_5:setUniformFloat("u_range", 40)
			var_71_5:setUniformFloat("u_sample", 3)
			var_71_5:setUniformFloat("u_ratio", 0)
			arg_71_0.tex_map:getSprite():setDefaultGLProgramState(var_71_5)
			arg_71_0.tex_map:getSprite():setGLProgramState(var_71_5)
			
			local var_71_6 = 30
			local var_71_7 = 320
			local var_71_8 = var_71_7 + 0
			local var_71_9 = var_71_7 + 30
			local var_71_10 = var_71_7 + 30
			local var_71_11 = var_71_7
			
			UIAction:Add(SEQ(SPAWN(LOG(LINEAR_CALL(var_71_8, nil, function(arg_72_0, arg_72_1)
				local var_72_0 = arg_71_0.tex_map:getSprite():getGLProgramState()
				
				if var_72_0 then
					var_72_0:setUniformFloat("u_ratio", arg_72_1)
				end
			end, 0, 1)), LOG(MOVE_TO(var_71_9, 320, 350), var_71_6), LOG(SCALE(var_71_10, 1.2, 0.9), var_71_6), LOG(OPACITY(var_71_11, 0.3, 1))), CALL(function()
				arg_71_0.tex_map:setVisible(false)
				var_71_0:setVisible(true)
			end)), arg_71_0.tex_map)
		end
	end
end

function ArenaNetCardWatcher.show(arg_74_0, arg_74_1)
	if ClearResult:isShow() then
		return 
	end
	
	arg_74_1 = arg_74_1 or {}
	
	local var_74_0 = arg_74_1.parent or SceneManager:getRunningPopupScene()
	local var_74_1 = load_dlg("pvplive_card_watching", true, "wnd")
	
	arg_74_0.vars = {}
	arg_74_0.vars.wnd = var_74_1
	arg_74_0.vars.infos = arg_74_1.infos
	arg_74_0.vars.stage = arg_74_0.vars.infos.stage
	arg_74_0.vars.user_uid = arg_74_1.user_uid
	arg_74_0.vars.enemy_uid = arg_74_1.enemy_uid
	arg_74_0.vars.cards = {}
	arg_74_0.vars.cards[arg_74_0.vars.user_uid] = {}
	arg_74_0.vars.cards[arg_74_0.vars.enemy_uid] = {}
	arg_74_0.vars.callback = arg_74_1.callback
	arg_74_0.vars.listerer = LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetCardWatcher.onResponse, arg_74_0), "arena.service.ready")
	
	arg_74_0:cache()
	arg_74_0:createCards()
	var_74_0:addChild(var_74_1)
	arg_74_0:updateState({
		seq_state = arg_74_1.state
	})
end

function ArenaNetCardWatcher.close(arg_75_0, arg_75_1)
	if not arg_75_0.vars or not get_cocos_refid(arg_75_0.vars.wnd) then
		return 
	end
	
	LuaEventDispatcher:removeEventListener(arg_75_0.vars.listerer)
	
	if arg_75_0.vars.callback then
		arg_75_0.vars.callback("finish")
	end
	
	arg_75_0.vars.wnd:removeFromParent()
	
	arg_75_0.vars = nil
end

function ArenaNetCardWatcher.cache(arg_76_0)
	local var_76_0 = arg_76_0.vars.wnd:getChildByName("CENTER")
	
	var_76_0:setPosition(80, 160)
	
	arg_76_0.vars.card_slots = {}
	arg_76_0.vars.card_slots[arg_76_0.vars.user_uid] = {}
	arg_76_0.vars.card_slots[arg_76_0.vars.enemy_uid] = {}
	
	for iter_76_0 = 1, DRAFT_CARD_MAX do
		local var_76_1 = var_76_0:getChildByName("n_b_card" .. tostring(iter_76_0))
		
		table.insert(arg_76_0.vars.card_slots[arg_76_0.vars.user_uid], var_76_1)
	end
	
	for iter_76_1 = 1, DRAFT_CARD_MAX do
		local var_76_2 = var_76_0:getChildByName("n_t_card" .. tostring(iter_76_1))
		
		table.insert(arg_76_0.vars.card_slots[arg_76_0.vars.enemy_uid], var_76_2)
	end
end

function ArenaNetCardWatcher.createCards(arg_77_0)
	for iter_77_0, iter_77_1 in pairs({
		arg_77_0.vars.user_uid,
		arg_77_0.vars.enemy_uid
	}) do
		for iter_77_2 = 1, DRAFT_CARD_MAX do
			local var_77_0 = arg_77_0.vars.infos.candidate[iter_77_1]
			local var_77_1 = ArenaNetCardMini:create({
				user = iter_77_1,
				slot_id = iter_77_2,
				draft_card_id = var_77_0[iter_77_2].uid
			})
			
			var_77_1:setAnchorPoint(0.5, 0.5)
			var_77_1:setVisible(false)
			
			local var_77_2 = "#4494ff"
			
			if arg_77_0.vars.user_uid ~= iter_77_1 then
				var_77_2 = "#fe1e1e"
			end
			
			local var_77_3 = getChildByPath(var_77_1, "n_info/txt_name")
			
			if_set_color(var_77_3, nil, tocolor(var_77_2))
			arg_77_0.vars.card_slots[iter_77_1][iter_77_2]:addChild(var_77_1)
			table.insert(arg_77_0.vars.cards[iter_77_1], var_77_1)
		end
	end
end

function ArenaNetCardWatcher.onResponse(arg_78_0, arg_78_1, arg_78_2, arg_78_3)
	local var_78_0 = table.count(arg_78_2 or {})
	
	if not arg_78_0.vars or var_78_0 == 0 or not arg_78_1 then
		return 
	end
	
	local var_78_1 = "on" .. string.ucfirst(arg_78_1)
	
	if arg_78_0[var_78_1] then
		arg_78_0[var_78_1](arg_78_0, arg_78_2, arg_78_3)
	end
end

function ArenaNetCardWatcher.onWatch(arg_79_0, arg_79_1)
	if not arg_79_0.vars or not arg_79_0.vars.listerer then
		return 
	end
	
	ArenaNetReady:updateState(arg_79_1)
	ArenaNetReady:updatePingInfo(arg_79_1.pinginfo)
	ArenaNetReady:checkFinished(arg_79_1.result)
	ArenaNetReady:updateTimeInfo(arg_79_1.timeinfo)
	
	if arg_79_1.seqinfo then
		arg_79_0:updateState(arg_79_1.seqinfo, arg_79_1.pickinfo)
	end
	
	arg_79_0.vars.seqinfo = arg_79_1.seqinfo
end

function ArenaNetCardWatcher.updateState(arg_80_0, arg_80_1, arg_80_2)
	if arg_80_0:isActing() or arg_80_0.vars.seqinfo and arg_80_0.vars.seqinfo.seq == "BAN" then
		return 
	end
	
	local var_80_0 = arg_80_1.stage
	local var_80_1 = arg_80_1.seq_state
	
	Log.i("seq state", arg_80_1.stage, arg_80_0.vars.seqinfo and arg_80_0.vars.seqinfo.stage)
	
	if var_80_1 == "finish" or var_80_0 and arg_80_0.vars.seqinfo and arg_80_0.vars.seqinfo.stage ~= var_80_0 or arg_80_1.seq == "BAN" or arg_80_1.seq == "CHANGE" then
		arg_80_0:act("finish", arg_80_1, arg_80_2)
	elseif var_80_1 == "start" then
		arg_80_0:act("start", arg_80_1, arg_80_2)
	elseif var_80_1 == "wait" then
		arg_80_0:act("wait", arg_80_1, arg_80_2)
	elseif var_80_1 == "add" then
		arg_80_0:act("add", arg_80_1, arg_80_2)
	else
		Log.i("invalid state", var_80_1)
	end
end

function ArenaNetCardWatcher.isActing(arg_81_0)
	if UIAction:Find("watcher.seq.finish") then
		return true
	else
		for iter_81_0, iter_81_1 in pairs(arg_81_0.vars.cards or {}) do
			for iter_81_2, iter_81_3 in pairs(iter_81_1 or {}) do
				if UIAction:Find("watcher.seq.start." .. tostring(iter_81_0) .. "." .. tostring(iter_81_2)) then
					return true
				end
			end
		end
	end
	
	return false
end

function ArenaNetCardWatcher.act(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	if arg_82_1 == "start" then
		UIAction:Add(SEQ(DELAY(100), CALL(function()
			arg_82_0:onStart()
		end)), arg_82_0.vars.wnd, "act.start")
	elseif arg_82_1 == "finish" then
		Log.i("종료중")
		UIAction:Add(SEQ(CALL(function()
			arg_82_0:onBeforeFinish(arg_82_3)
		end), DELAY(1400), CALL(function()
			arg_82_0:onFinish(arg_82_3)
		end)), arg_82_0.vars.wnd, "selector.seq.finish")
	elseif arg_82_1 == "wait" then
		Log.i("선택 대기중")
	elseif arg_82_1 == "add" then
		Log.i("상대방 대기중")
	end
end

function ArenaNetCardWatcher.onStart(arg_86_0)
	Log.i("시작중")
	
	local var_86_0 = 200
	local var_86_1 = 5
	local var_86_2 = 0
	local var_86_3 = 0
	local var_86_4 = 0
	local var_86_5 = 0
	local var_86_6 = 0
	
	if not DEBUG_USE_CARD_SHADER then
		local var_86_7 = true
	end
	
	local var_86_8 = {
		[arg_86_0.vars.enemy_uid] = {
			{
				delay = 0,
				init_pos = {
					-349.22,
					1123.54
				},
				init_scale = var_86_1,
				init_opacity = var_86_2,
				scale_tm = var_86_0 + var_86_3,
				move_tm = var_86_0 + var_86_4,
				opacity_tm = var_86_0 + var_86_5,
				ratio_tm = var_86_0 + var_86_6
			},
			{
				delay = 100,
				init_pos = {
					-526.21,
					1123.54
				},
				init_scale = var_86_1,
				init_opacity = var_86_2,
				scale_tm = var_86_0 + var_86_3,
				move_tm = var_86_0 + var_86_4,
				opacity_tm = var_86_0 + var_86_5,
				ratio_tm = var_86_0 + var_86_6
			},
			{
				delay = 200,
				init_pos = {
					-703.21,
					1123.54
				},
				init_scale = var_86_1,
				init_opacity = var_86_2,
				scale_tm = var_86_0 + var_86_3,
				move_tm = var_86_0 + var_86_4,
				opacity_tm = var_86_0 + var_86_5,
				ratio_tm = var_86_0 + var_86_6
			}
		},
		[arg_86_0.vars.user_uid] = {
			{
				delay = 0,
				init_pos = {
					520.82,
					-1161.53
				},
				init_scale = var_86_1,
				init_opacity = var_86_2,
				scale_tm = var_86_0 + var_86_3,
				move_tm = var_86_0 + var_86_4,
				opacity_tm = var_86_0 + var_86_5,
				ratio_tm = var_86_0 + var_86_6
			},
			{
				delay = 50,
				init_pos = {
					697.81,
					-1161.53
				},
				init_scale = var_86_1,
				init_opacity = var_86_2,
				scale_tm = var_86_0 + var_86_3,
				move_tm = var_86_0 + var_86_4,
				opacity_tm = var_86_0 + var_86_5,
				ratio_tm = var_86_0 + var_86_6
			},
			{
				delay = 100,
				init_pos = {
					874.81,
					-1161.53
				},
				init_scale = var_86_1,
				init_opacity = var_86_2,
				scale_tm = var_86_0 + var_86_3,
				move_tm = var_86_0 + var_86_4,
				opacity_tm = var_86_0 + var_86_5,
				ratio_tm = var_86_0 + var_86_6
			}
		}
	}
	
	set_high_fps_tick(5000)
	
	for iter_86_0, iter_86_1 in pairs({
		arg_86_0.vars.user_uid,
		arg_86_0.vars.enemy_uid
	}) do
		for iter_86_2 = 1, 3 do
			local var_86_9 = arg_86_0.vars.cards[iter_86_1][iter_86_2]
			local var_86_10 = var_86_8[iter_86_1][iter_86_2]
			
			var_86_9:setPosition(var_86_10.init_pos[1], var_86_10.init_pos[2])
			var_86_9:setScale(var_86_10.init_scale)
			var_86_9:setCascadeOpacityEnabled(true)
			var_86_9:setOpacity(var_86_10.init_opacity)
			
			local var_86_11 = 4
			
			UIAction:Add(SEQ(DELAY(var_86_10.delay), CALL(function()
				var_86_9:setVisible(true)
			end), SPAWN(RLOG(SCALE(var_86_10.scale_tm, 5, 1), var_86_11), MOVE_TO(var_86_10.move_tm, 0, 0), RLOG(OPACITY(var_86_10.opacity_tm, 0, 1), var_86_11))), var_86_9, "watcher.seq.start." .. tostring(iter_86_1) .. "." .. tostring(iter_86_2))
		end
	end
end

function ArenaNetCardWatcher.onBeforeFinish(arg_88_0, arg_88_1)
	if not arg_88_0.vars or table.empty(arg_88_0.vars.infos.candidate) or table.empty(arg_88_1) then
		return 
	end
	
	for iter_88_0, iter_88_1 in pairs(arg_88_0.vars.cards or {}) do
		local var_88_0 = arg_88_1[iter_88_0]
		
		for iter_88_2, iter_88_3 in pairs(iter_88_1 or {}) do
			iter_88_3:onSelect(false)
			
			if iter_88_2 == arg_88_0:findSlotIndexByUID(iter_88_0, (var_88_0[arg_88_0.vars.stage] or {}).uid) then
				UIAction:Add(SEQ(CALL(function()
					iter_88_3:onSelect(true)
				end), RLOG(SCALE_TO(200, 0.85)), RLOG(SCALE_TO(200, 1.05)), DELAY(800), CALL(function()
					iter_88_3:onSelect(false)
				end), DELAY(20), RLOG(LINEAR_CALL(80, nil, function(arg_91_0, arg_91_1)
					iter_88_3:setRotationSkewY(arg_91_1)
				end, 0, -90), 120)), iter_88_3)
			else
				local var_88_1 = iter_88_3:getChildByName("n_eff_off")
				
				if_set_visible(var_88_1, nil, true)
				var_88_1:removeAllChildren()
				UIAction:Add(SEQ(CALL(function()
					iter_88_3:onDiscard()
				end), COLOR(200, 69, 69, 69), DELAY(400), CALL(function()
					EffectManager:Play({
						pivot_x = 0,
						fn = "uieff_pvp_rta_draft_dust_2.cfx",
						pivot_y = 0,
						pivot_z = 99998,
						layer = var_88_1
					}):setCascadeOpacityEnabled(false)
					SoundEngine:play("event:/ui/pvp_draft/pvp_draft_sound_eff_2")
				end), DELAY(66.5), RLOG(OPACITY(0, 1, 0))), iter_88_3)
			end
		end
	end
end

function ArenaNetCardWatcher.onFinish(arg_94_0, arg_94_1)
	local function var_94_0(arg_95_0, arg_95_1, arg_95_2)
		local var_95_0 = "watcher.seq.spawn." .. tostring(arg_95_0)
		local var_95_1 = 30
		
		arg_95_1:setVisible(true)
		arg_95_1:setRotationSkewY(0)
		arg_95_0:setRotationSkewY(arg_95_2.init_skew_y)
		arg_95_0:setPosition(arg_95_2.init_pos[1], arg_95_2.init_pos[2])
		UIAction:Add(SEQ(SPAWN(LOG(SCALE(arg_95_2.scale_tm * arg_95_2.multi_tm, 0, 1), var_95_1), RLOG(LINEAR_CALL(arg_95_2.rotation_tm * arg_95_2.multi_tm, nil, function(arg_96_0, arg_96_1)
			arg_95_0:setRotationSkewY(arg_95_2.init_skew_y + -arg_96_1)
		end, 0, arg_95_2.init_skew_y), 30), RLOG(OPACITY(arg_95_2.opacity_tm * arg_95_2.multi_tm, 0, 1)), RLOG(MOVE_TO(arg_95_2.move_tm * arg_95_2.multi_tm, arg_95_2.target_pos[1], arg_95_2.target_pos[2])), CALL(function()
			local var_97_0 = arg_95_1:getChildByName("n_eff_fin")
			
			if_set_visible(var_97_0, nil, true)
			var_97_0:removeAllChildren()
			EffectManager:Play({
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 99998,
				fn = arg_95_2.select_loop_effect,
				layer = var_97_0
			})
		end))), arg_95_0, var_95_0)
	end
	
	local function var_94_1(arg_98_0, arg_98_1, arg_98_2)
		local var_98_0 = "watcher.seq.moveToSlot." .. tostring(arg_98_0)
		
		arg_98_1:setVisible(true)
		arg_98_1:setOpacity(255)
		UIAction:Add(SEQ(CALL(function()
			local var_99_0 = arg_98_1:getChildByName("n_eff_off")
			
			if_set_visible(var_99_0, nil, true)
			var_99_0:removeAllChildren()
			EffectManager:Play({
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 99998,
				fn = arg_98_2.move_to_slot_effect,
				layer = var_99_0
			}):setCascadeOpacityEnabled(false)
		end), DELAY(66.5), RLOG(OPACITY(0, 1, 0))), arg_98_1, var_98_0)
	end
	
	local var_94_2 = arg_94_1[arg_94_0.vars.user_uid]
	local var_94_3 = arg_94_1[arg_94_0.vars.enemy_uid]
	local var_94_4 = {
		rotation_tm = 400,
		init_skew_y = 90,
		scale_tm = 400,
		move_tm = 400,
		move_to_slot_effect = "uieff_pvp_rta_draft_banpick_front_1.cfx",
		select_loop_effect = "uieff_pvp_rta_draft_select_1.cfx",
		multi_tm = 0.6,
		opacity_tm = 400,
		init_pos = {
			390,
			120
		},
		target_pos = {
			390,
			180
		}
	}
	local var_94_5 = {
		rotation_tm = 400,
		init_skew_y = -90,
		scale_tm = 400,
		move_tm = 400,
		move_to_slot_effect = "uieff_pvp_rta_draft_banpick_front_2.cfx",
		select_loop_effect = "uieff_pvp_rta_draft_select_2.cfx",
		multi_tm = 0.6,
		opacity_tm = 400,
		init_pos = {
			710,
			120
		},
		target_pos = {
			710,
			180
		}
	}
	local var_94_6 = arg_94_0.vars.card_slots[arg_94_0.vars.user_uid][1]
	local var_94_7 = ArenaNetCard:create({
		mode = "talent",
		slot_id = -1,
		draft_card_id = (var_94_2[arg_94_0.vars.stage] or {}).uid
	})
	
	var_94_6:addChild(var_94_7)
	var_94_7:setVisible(false)
	var_94_7:setAnchorPoint(0.5, 0.5)
	var_94_7:updateMode(arg_94_0.mode)
	
	local var_94_8 = arg_94_0.vars.card_slots[arg_94_0.vars.user_uid][2]
	local var_94_9 = ArenaNetCard:create({
		mode = "talent",
		slot_id = -1,
		draft_card_id = (var_94_3[arg_94_0.vars.stage] or {}).uid
	})
	
	var_94_8:addChild(var_94_9)
	var_94_9:setVisible(false)
	var_94_9:setAnchorPoint(0.5, 0.5)
	var_94_9:updateMode(arg_94_0.mode)
	UIAction:Add(SEQ(SPAWN(CALL(function()
		var_94_0(var_94_6, var_94_7, var_94_4)
	end), CALL(function()
		var_94_0(var_94_8, var_94_9, var_94_5)
	end)), DELAY(240), CALL(function()
		SoundEngine:play("event:/ui/pvp_draft/pvp_draft_sound_eff_3")
	end), DELAY(1500), SPAWN(CALL(function()
		var_94_1(var_94_6, var_94_7, var_94_4)
	end), CALL(function()
		var_94_1(var_94_8, var_94_9, var_94_5)
	end)), DELAY(200), CALL(function()
		ArenaNetReady:updateSlotInfo(arg_94_1)
	end), DELAY(600), CALL(function()
		arg_94_0:close()
	end)), arg_94_0.vars.wnd, "watcher.seq.finish")
end

function ArenaNetCardWatcher.findSlotIndexByUID(arg_107_0, arg_107_1, arg_107_2)
	for iter_107_0, iter_107_1 in pairs(arg_107_0.vars.cards[arg_107_1] or {}) do
		if arg_107_2 == iter_107_1.draft_card_id then
			return iter_107_0
		end
	end
	
	return -1
end

function ArenaNetCardWatcher.updatePick(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	if not arg_108_2 or not arg_108_3 then
		return 
	end
	
	for iter_108_0, iter_108_1 in pairs(arg_108_0.vars.card_slots[arg_108_1] or {}) do
		local var_108_0 = arg_108_0.vars.cards[arg_108_1][iter_108_0]
		
		if iter_108_0 == arg_108_2 then
			var_108_0:setColor(cc.c3b(255, 255, 255))
		else
			var_108_0:onDiscard()
			var_108_0:setColor(cc.c3b(69, 69, 69))
		end
	end
end

function ArenaNetCardWatcher.test1(arg_109_0)
	local var_109_0 = load_dlg("unit_base", true, "wnd")
	
	SceneManager:getDefaultLayer():addChild(var_109_0)
	
	local var_109_1 = load_dlg("pvplive_ready_draft", true, "wnd")
	
	var_109_0:addChild(var_109_1)
	
	local var_109_2 = 1
	local var_109_3 = 2
	local var_109_4 = {
		stage = 1,
		candidate = {}
	}
	
	var_109_4.candidate[var_109_2] = {}
	var_109_4.candidate[var_109_3] = {}
	
	for iter_109_0, iter_109_1 in pairs({
		7,
		16,
		28
	}) do
		table.insert(var_109_4.candidate[var_109_2], {
			uid = iter_109_1
		})
	end
	
	for iter_109_2, iter_109_3 in pairs({
		3,
		11,
		19
	}) do
		table.insert(var_109_4.candidate[var_109_3], {
			uid = iter_109_3
		})
	end
	
	ArenaNetCardWatcher:show({
		state = "start",
		user_uid = var_109_2,
		enemy_uid = var_109_3,
		infos = var_109_4,
		callback = function(arg_110_0, arg_110_1, arg_110_2)
		end
	})
end
