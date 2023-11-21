ArenaNetLounge = {}

function HANDLER.pvplive_lounge(arg_1_0, arg_1_1, arg_1_2)
	if arg_1_1 == "btn_edit1" then
		ArenaNetLounge:selectBattleSlot("HOME")
	elseif arg_1_1 == "btn_edit2" then
		ArenaNetLounge:selectBattleSlot("AWAY")
	elseif arg_1_1 == "btn_edit_cancel" or arg_1_1 == "btn_ignore" then
		ArenaNetLounge:resetEditMode()
	elseif arg_1_1 == "btn_add" or arg_1_1 == "btn_change" then
		ArenaNetLounge:changeSlot(arg_1_0.info)
	elseif arg_1_1 == "btn_remove" then
		ArenaNetLounge:removeSlot()
	elseif arg_1_1 == "btn_swap" then
		ArenaNetLounge:swapSlot(arg_1_0.info)
	elseif arg_1_1 == "btn_exile" then
		ArenaNetLounge:kickUser(arg_1_0.info)
	elseif arg_1_1 == "btn_exile_on" then
		ArenaNetLounge:selectSpectator(arg_1_0.info)
	elseif arg_1_1 == "btn_setting" then
		ArenaNetLounge:showSettings()
	elseif arg_1_1 == "btn_invite" then
		ArenaNetLounge:showInvitePopup()
	elseif arg_1_1 == "btn_background" then
		ArenaNetLounge:showBGPacks()
	elseif arg_1_1 == "btn_bgm_setting" then
		if MusicBox:isEnable() then
			ArenaNetLounge:showMusicBox()
		else
			balloon_message_with_sound("error_not_now")
		end
	elseif arg_1_1 == "btn_ban_setting" then
		ArenaNetLounge:showPrebanSetting()
	elseif arg_1_1 == "btn_close_ban" then
		ArenaNetLounge:closePrebanSetting()
	elseif arg_1_1 == "btn_round" then
		ArenaNetLounge:showRoundSetting()
	elseif arg_1_1 == "btn_draft_info" then
		ArenaNetLounge:showDraftInfo()
	elseif arg_1_1 == "btn_ready_go" then
		ArenaNetLounge:start()
	elseif arg_1_1 == "btn_cancel" then
		ArenaNetLounge:cancel()
	elseif arg_1_1 == "btn_close_bg" then
		ArenaNetLounge:closeBGPacks()
		ArenaNetLounge:closeRoundSetting()
	elseif arg_1_1 == "check_box" then
		if arg_1_0.type and arg_1_0.type == "FIRST_PICK" then
			ArenaNetLounge:selectFirstPickUser(arg_1_0.info)
		elseif arg_1_0.type and arg_1_0.type == "BENEFIT" then
			ArenaNetLounge:selectRoundBenefitUser(arg_1_0.info)
		end
	elseif arg_1_1 == "btn_esc" then
		ArenaNetLounge:exit()
	elseif arg_1_1 == "view_info" then
		ArenaNetLounge:setVisibleRoomSetting(false)
	end
end

function HANDLER_CANCEL.pvplive_lounge(arg_2_0, arg_2_1)
	if arg_2_1 == "view_info" then
		ArenaNetLounge:setVisibleRoomSetting(false)
	end
end

function HANDLER_BEFORE.pvplive_lounge(arg_3_0, arg_3_1)
	if arg_3_1 == "view_info" then
		ArenaNetLounge:setVisibleRoomSetting(true)
	end
end

function MsgHandler.arena_net_get_commu_list(arg_4_0)
	ArenaNetInvitePopup:show(arg_4_0)
end

function makeBGItem(arg_5_0)
	if arg_5_0 then
		local var_5_0 = DBT("item_material_bgpack", arg_5_0, {
			"id",
			"background_id",
			"bg_scale",
			"bg_position",
			"bg_scale_pet",
			"bg_position_pet",
			"ambient_color"
		}) or {}
		
		var_5_0.id = arg_5_0
		var_5_0.bg_id = var_5_0.background_id
		var_5_0.background_id = nil
		
		if not var_5_0.ambient_color then
			var_5_0.ambient_color = "FFFFFF"
		end
		
		table.merge(var_5_0, DBT("item_material", arg_5_0, {
			"name",
			"sort",
			"desc"
		}) or {})
		
		var_5_0.icon = UIUtil:getIconPath(arg_5_0)
		
		return var_5_0
	end
end

function getRoundNotiText(arg_6_0)
	local var_6_0 = "pvp_rta_battle_rule3_desc" .. tostring(arg_6_0)
	
	return T(var_6_0)
end

function ArenaNetLounge.Show(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	arg_7_0.vars = {}
	arg_7_0.vars.service = arg_7_2.service
	arg_7_0.vars.user_id = arg_7_0.vars.service:getUserUID()
	arg_7_0.vars.seq_id = arg_7_2.infos.seq_id or 1
	arg_7_0.vars.infos = {}
	arg_7_0.vars.edit_mode = "none"
	arg_7_0.vars.bg_item = {}
	arg_7_0.vars.wnd = load_dlg("pvplive_lounge", true, "wnd")
	arg_7_0.vars.parent = arg_7_1 or SceneManager:getDefaultLayer()
	
	arg_7_0.vars.parent:addChild(arg_7_0.vars.wnd)
	arg_7_0:init()
	arg_7_0:update(arg_7_2.infos)
	arg_7_0:updateUI()
	
	local var_7_0
	
	if arg_7_0.vars.user_id == arg_7_2.infos.host then
		Log.i("my create lounge")
		
		if Account:getItemCount(arg_7_2.infos.bg_id) > 0 then
			var_7_0 = arg_7_2.infos.bg_id
		elseif Account:getItemCount(SAVE:get("net_arena_lounge_bg")) > 0 then
			var_7_0 = SAVE:get("net_arena_lounge_bg")
		else
			var_7_0 = "ma_bg_pet_base"
		end
	else
		Log.i("other create lounge")
		
		var_7_0 = arg_7_2.infos.bg_id or SAVE:get("net_arena_lounge_bg") or "ma_bg_pet_base"
	end
	
	arg_7_0:onChangeBackground(makeBGItem(var_7_0))
	
	local var_7_1 = DB("pvp_rta_season", arg_7_0.vars.service:getSeasonId(), {
		"bgm_lounge"
	}) or DB("pvp_rta_season_event", arg_7_0.vars.service:getSeasonId(), {
		"bgm_lounge"
	})
	local var_7_2 = arg_7_2.infos.bgm_id
	local var_7_3
	local var_7_4
	
	if var_7_2 then
		var_7_3 = MusicBox:getSong(var_7_2).streaming_id
		var_7_4 = var_7_3 and cc.FileUtils:getInstance():fullPathForFilename("bgm_ost/" .. var_7_3)
	end
	
	SoundEngine:playBGM(var_7_3 and var_7_4 or "event:/bgm/" .. (var_7_2 or var_7_1))
	
	if arg_7_0.vars.service then
		function arg_7_0.vars.service.onUpdate()
			arg_7_0:onUpdate()
		end
	end
	
	ChatMain:show(SceneManager:getRunningPopupScene(), nil, {
		no_close = true,
		section = "arena",
		z_order = 1
	})
	ArenaNetChat:updateMemberCount()
	LuaEventDispatcher:removeEventListenerByKey("arena.service.lounge")
	LuaEventDispatcher:addEventListener("arena.service.req", LISTENER(ArenaNetLounge.onRequest, arg_7_0), "arena.service.lounge")
	LuaEventDispatcher:addEventListener("arena.service.res", LISTENER(ArenaNetLounge.onResponse, arg_7_0), "arena.service.lounge")
	SAVE:setKeep("net_arena_join_info", nil)
	query("arena_net_lobby_update")
end

function ArenaNetLounge.init(arg_9_0)
	arg_9_0.vars.LEFT = arg_9_0.vars.wnd:getChildByName("LEFT")
	arg_9_0.vars.RIGHT = arg_9_0.vars.wnd:getChildByName("RIGHT")
	arg_9_0.vars.CENTER = arg_9_0.vars.wnd:getChildByName("CENTER")
	arg_9_0.vars.MOD = arg_9_0.vars.wnd:getChildByName("n_mod")
	arg_9_0.vars.slots = {}
	arg_9_0.vars.slots.HOME = arg_9_0.vars.CENTER:getChildByName("n_player1")
	arg_9_0.vars.slots.HOME.reverse = false
	arg_9_0.vars.slots.HOME.ally = "HOME"
	arg_9_0.vars.slots.HOME.cursor = arg_9_0.vars.slots.HOME:getChildByName("cursor")
	arg_9_0.vars.slots.AWAY = arg_9_0.vars.CENTER:getChildByName("n_player2")
	arg_9_0.vars.slots.AWAY.reverse = true
	arg_9_0.vars.slots.AWAY.ally = "AWAY"
	arg_9_0.vars.slots.AWAY.cursor = arg_9_0.vars.slots.AWAY:getChildByName("cursor")
	
	if_set_visible(arg_9_0.vars.slots.HOME, "n_state", false)
	if_set_visible(arg_9_0.vars.slots.AWAY, "n_state", false)
	
	for iter_9_0, iter_9_1 in pairs({
		"HOME",
		"AWAY"
	}) do
		arg_9_0.vars.slots[iter_9_1]:getChildByName("btn_remove").info = iter_9_1
		arg_9_0.vars.slots[iter_9_1]:getChildByName("btn_swap").info = iter_9_1
	end
	
	arg_9_0.vars.btn_ready = arg_9_0.vars.CENTER:getChildByName("btn_ready_go")
	arg_9_0.vars.btn_cancel = arg_9_0.vars.CENTER:getChildByName("btn_cancel")
	arg_9_0.vars.btn_ban_setting = arg_9_0.vars.RIGHT:getChildByName("btn_ban_setting")
	arg_9_0.vars.btn_ban_setting_node = arg_9_0.vars.wnd:getChildByName("n_preban_setting")
	arg_9_0.vars.ban_setting_noti_node = arg_9_0.vars.RIGHT:getChildByName("n_ban_noti")
	arg_9_0.vars.btn_round_setting = arg_9_0.vars.RIGHT:getChildByName("btn_round")
	arg_9_0.vars.round_setting_noti_node = arg_9_0.vars.RIGHT:getChildByName("n_round_noti")
	arg_9_0.vars.listview = ItemListView_v2:bindControl(arg_9_0.vars.LEFT:getChildByName("listview"))
	
	local var_9_0 = {
		onUpdate = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			ArenaNetLounge:updateItemRender(arg_10_1, arg_10_3)
			
			return arg_10_3.id
		end
	}
	
	arg_9_0.vars.listview:setRenderer(load_control("wnd/pvplive_spectator_bar.csb"), var_9_0)
	arg_9_0.vars.listview:removeAllChildren()
	arg_9_0.vars.listview:setDataSource({})
	arg_9_0.vars.listview:jumpToTop()
	
	arg_9_0.vars.btn_close_bg = arg_9_0.vars.wnd:getChildByName("btn_close_bg")
	arg_9_0.vars.btn_close_ban = arg_9_0.vars.wnd:getChildByName("btn_close_ban")
	arg_9_0.vars.btn_bgm_setting = arg_9_0.vars.wnd:getChildByName("btn_bgm_setting")
	arg_9_0.vars.first_pick_noties = {}
	arg_9_0.vars.first_pick_checkers = {}
	arg_9_0.vars.first_pick_checkbox = {}
	arg_9_0.vars.first_pick_checkbox_btns = {}
	arg_9_0.vars.first_pick_checkbox_text = {}
	arg_9_0.vars.round_benefit_checkers = {}
	arg_9_0.vars.round_benefit_checkbox_btns = {}
	arg_9_0.vars.round_benefit_checkbox_text = {}
	arg_9_0.vars.round_benefit_checkbox = {}
	
	for iter_9_2, iter_9_3 in pairs({
		"HOME",
		"AWAY"
	}) do
		arg_9_0.vars.first_pick_noties[iter_9_3] = arg_9_0.vars.slots[iter_9_3]:getChildByName("n_first_pick_noti")
		arg_9_0.vars.first_pick_checkers[iter_9_3] = arg_9_0.vars.slots[iter_9_3]:getChildByName("n_first_pick_check")
		arg_9_0.vars.first_pick_checkbox_btns[iter_9_3] = arg_9_0.vars.first_pick_checkers[iter_9_3]:getChildByName("check_box")
		arg_9_0.vars.first_pick_checkbox_text[iter_9_3] = arg_9_0.vars.first_pick_checkers[iter_9_3]:getChildByName("t_first")
		arg_9_0.vars.first_pick_checkbox[iter_9_3] = arg_9_0.vars.first_pick_checkbox_text[iter_9_3]:getChildByName("check_box")
		arg_9_0.vars.first_pick_checkbox_btns[iter_9_3].info = iter_9_3
		arg_9_0.vars.first_pick_checkbox_btns[iter_9_3].type = "FIRST_PICK"
		arg_9_0.vars.round_benefit_checkers[iter_9_3] = arg_9_0.vars.slots[iter_9_3]:getChildByName("n_admin_only")
		arg_9_0.vars.round_benefit_checkbox_btns[iter_9_3] = arg_9_0.vars.round_benefit_checkers[iter_9_3]:getChildByName("check_box")
		arg_9_0.vars.round_benefit_checkbox_text[iter_9_3] = arg_9_0.vars.round_benefit_checkers[iter_9_3]:getChildByName("t_first")
		arg_9_0.vars.round_benefit_checkbox[iter_9_3] = arg_9_0.vars.round_benefit_checkbox_text[iter_9_3]:getChildByName("check_box")
		arg_9_0.vars.round_benefit_checkbox_btns[iter_9_3].info = iter_9_3
		arg_9_0.vars.round_benefit_checkbox_btns[iter_9_3].type = "BENEFIT"
	end
end

function ArenaNetLounge.Enter(arg_11_0)
end

function ArenaNetLounge.onUpdate(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = {
		seq_id = arg_12_0.vars.seq_id
	}
	
	arg_12_0.vars.service:query("watch", var_12_0)
end

function ArenaNetLounge.onRequest(arg_13_0, arg_13_1, arg_13_2)
end

function ArenaNetLounge.onResponse(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = table.count(arg_14_2 or {})
	
	if not arg_14_0.vars or var_14_0 == 0 or not arg_14_1 then
		return 
	end
	
	local var_14_1 = "on" .. string.ucfirst(arg_14_1)
	
	if arg_14_0[var_14_1] then
		arg_14_0[var_14_1](arg_14_0, arg_14_2, arg_14_3)
	end
end

function ArenaNetLounge.onWatch(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not arg_15_1.seq_id then
		return 
	end
	
	if arg_15_0.vars.seq_id >= arg_15_1.seq_id then
		return 
	end
	
	arg_15_0.vars.seq_id = arg_15_1.seq_id
	
	arg_15_0:updateState(arg_15_1)
	arg_15_0:update(arg_15_1)
	arg_15_0:updateUI()
end

function ArenaNetLounge.setVisibleRoomSetting(arg_16_0, arg_16_1)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = getChildByPath(arg_16_0.vars.wnd, "n_info")
	
	if_set(var_16_0, "t_bg_info", T(arg_16_0.vars.bg_item.name))
	
	local var_16_1 = DB("musicplayer_song", arg_16_0.vars.infos.bgm_id or "bgm_rta_lounge2", "song_title")
	
	if_set(var_16_0, "t_bgm_info", T(var_16_1))
	if_set(var_16_0, "t_title", T("ui_worldarena_mapinfo"))
	var_16_0:setVisible(arg_16_1)
end

function ArenaNetLounge.onStart(arg_17_0, arg_17_1)
	if not arg_17_1 or not arg_17_1.succees then
		UIAction:Remove("block")
	end
end

function ArenaNetLounge.onExit(arg_18_0, arg_18_1)
	if arg_18_1.cur_state ~= "LOUNGE" then
		return 
	end
	
	if arg_18_1.success then
		arg_18_0.vars.service:reset()
		MatchService:query("arena_net_enter_lobby", nil, function(arg_19_0)
			arg_19_0.mode = "VS_FRIEND"
			
			SceneManager:nextScene("arena_net_lobby", arg_19_0)
			SceneManager:resetSceneFlow()
		end)
	else
		balloon_message(T("pvp_rta_mock_cannot_leave"))
	end
end

function ArenaNetLounge.resetEditMode(arg_20_0)
	arg_20_0.vars.edit_mode = "none"
	arg_20_0.vars.selected_slot = nil
	arg_20_0.vars.selected_spectator = nil
	
	arg_20_0.vars.listview:refresh()
	arg_20_0:updateSlot(arg_20_0.vars.slots.HOME, arg_20_0.vars.infos.home_user)
	arg_20_0:updateSlot(arg_20_0.vars.slots.AWAY, arg_20_0.vars.infos.away_user)
end

function ArenaNetLounge.exit(arg_21_0)
	if arg_21_0.vars.service:isReset() then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.service:isRoundMode() and T("pvp_rta_mock_leave_room2") or T("pvp_rta_mock_leave_room")
	
	Dialog:msgBox(var_21_0, {
		yesno = true,
		handler = function()
			if not arg_21_0.vars.service:isReset() then
				arg_21_0.vars.service:query("command", {
					type = "exit"
				})
			end
		end
	})
end

function ArenaNetLounge.selectBattleSlot(arg_23_0, arg_23_1)
	if not arg_23_0.vars.is_host then
		return 
	end
	
	if arg_23_1 == "HOME" then
		arg_23_0.vars.selected_slot = "HOME"
		
		if arg_23_0.vars.infos.home_user then
			arg_23_0.vars.edit_mode = "replace"
		else
			arg_23_0.vars.edit_mode = "add"
		end
	else
		arg_23_0.vars.selected_slot = "AWAY"
		
		if arg_23_0.vars.infos.away_user then
			arg_23_0.vars.edit_mode = "replace"
		else
			arg_23_0.vars.edit_mode = "add"
		end
	end
	
	arg_23_0.vars.selected_spectator = nil
	
	arg_23_0.vars.listview:refresh()
	arg_23_0:updateSlot(arg_23_0.vars.slots.HOME, arg_23_0.vars.infos.home_user)
	arg_23_0:updateSlot(arg_23_0.vars.slots.AWAY, arg_23_0.vars.infos.away_user)
end

function ArenaNetLounge.selectSpectator(arg_24_0, arg_24_1)
	if not arg_24_0.vars.is_host then
		return 
	end
	
	if arg_24_0.vars.edit_mode == "exile" and arg_24_0.vars.selected_spectator == arg_24_1 then
		arg_24_0:resetEditMode()
	else
		arg_24_0.vars.edit_mode = "exile"
		arg_24_0.vars.selected_spectator = arg_24_1
	end
	
	arg_24_0.vars.listview:refresh()
	arg_24_0:updateSlot(arg_24_0.vars.slots.HOME, arg_24_0.vars.infos.home_user)
	arg_24_0:updateSlot(arg_24_0.vars.slots.AWAY, arg_24_0.vars.infos.away_user)
end

function ArenaNetLounge.removeSlot(arg_25_0)
	if not arg_25_0.vars.is_host then
		return 
	end
	
	arg_25_0.vars.edit_mode = "none"
	
	if arg_25_0.vars.selected_slot == "HOME" then
		arg_25_0.vars.infos.home_user = nil
		arg_25_0.vars.infos.home_ready = false
	else
		arg_25_0.vars.infos.away_user = nil
		arg_25_0.vars.infos.away_ready = false
	end
	
	arg_25_0:updateUI()
	
	local var_25_0 = {
		type = "removeslot",
		slot = arg_25_0.vars.selected_slot
	}
	
	arg_25_0.vars.selected_slot = nil
	
	arg_25_0.vars.service:query("command", var_25_0)
end

function ArenaNetLounge.changeSlot(arg_26_0, arg_26_1)
	if not arg_26_0.vars.is_host then
		return 
	end
	
	arg_26_0.vars.edit_mode = "none"
	
	if arg_26_0.vars.selected_slot == "HOME" then
		arg_26_0.vars.infos.home_user = arg_26_1
		arg_26_0.vars.infos.home_ready = false
	else
		arg_26_0.vars.infos.away_user = arg_26_1
		arg_26_0.vars.infos.away_ready = false
	end
	
	arg_26_0:updateUI()
	
	local var_26_0 = {
		type = "changeslot",
		slot = arg_26_0.vars.selected_slot,
		user = arg_26_1
	}
	
	arg_26_0.vars.selected_slot = nil
	
	arg_26_0.vars.service:query("command", var_26_0)
end

function ArenaNetLounge.swapSlot(arg_27_0, arg_27_1)
	arg_27_0.vars.edit_mode = "none"
	
	if arg_27_0.vars.selected_spectator then
		if arg_27_1 == "HOME" then
			arg_27_0.vars.infos.home_user = arg_27_0.vars.selected_spectator
			arg_27_0.vars.infos.home_ready = false
		else
			arg_27_0.vars.infos.away_user = arg_27_0.vars.selected_spectator
			arg_27_0.vars.infos.away_ready = false
		end
		
		arg_27_0:updateUI()
		
		local var_27_0 = {
			type = "changeslot",
			slot = arg_27_1,
			user = arg_27_0.vars.selected_spectator
		}
		
		arg_27_0.vars.selected_slot = nil
		
		arg_27_0.vars.service:query("command", var_27_0)
	else
		local var_27_1 = arg_27_0.vars.infos.home_user
		
		arg_27_0.vars.infos.home_user = arg_27_0.vars.infos.away_user
		arg_27_0.vars.infos.away_user = var_27_1
		arg_27_0.vars.infos.home_ready = false
		arg_27_0.vars.infos.away_ready = false
		
		arg_27_0:updateUI()
		
		local var_27_2 = {
			type = "swapslot"
		}
		
		arg_27_0.vars.selected_slot = nil
		
		arg_27_0.vars.service:query("command", var_27_2)
	end
end

function ArenaNetLounge.kickUser(arg_28_0, arg_28_1)
	if not arg_28_0.vars.is_host then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.infos.users[arg_28_1]
	local var_28_1 = check_abuse_filter(var_28_0.name, ABUSE_FILTER.WORLD_NAME) or var_28_0.name
	
	Dialog:msgBox(T("pvp_rta_mock_ban_user", {
		user_name = var_28_1,
		user_server = getRegionText(var_28_0.world)
	}), {
		yesno = true,
		handler = function()
			arg_28_0.vars.edit_mode = "none"
			arg_28_0.vars.infos.users[arg_28_1] = nil
			
			arg_28_0:updateUI()
			
			local var_29_0 = {
				type = "removeuser",
				user = arg_28_1
			}
			
			arg_28_0.vars.service:query("command", var_29_0)
		end
	})
end

function ArenaNetLounge.start(arg_30_0)
	local function var_30_0()
		if arg_30_0.vars.is_host then
			if arg_30_0.vars.user_id == arg_30_0.vars.infos.home_user or arg_30_0.vars.user_id == arg_30_0.vars.infos.away_user then
				if not arg_30_0.vars.infos.home_ready and not arg_30_0.vars.infos.away_ready then
					balloon_message(T("pvp_rta_mock_not_ready"))
					
					return false
				end
			elseif not arg_30_0.vars.infos.home_ready or not arg_30_0.vars.infos.away_ready then
				balloon_message(T("pvp_rta_mock_not_ready"))
				
				return false
			end
		end
		
		return true
	end
	
	local function var_30_1()
		if not var_30_0() then
			return 
		end
		
		ArenaNetLounge:resetEditMode()
		UIAction:Add(SEQ(DELAY(6000)), arg_30_0, "block")
		arg_30_0.vars.service:query("command", {
			type = "start"
		})
	end
	
	local function var_30_2()
		local var_33_0 = arg_30_0.vars.infos.round_benefit == "HOME" and arg_30_0.vars.infos.home_user or arg_30_0.vars.infos.away_user
		
		ArenaNetFirstpickConfirmPopup:show({
			type = "benefit",
			ready_next_popup = false,
			user_info = arg_30_0.vars.infos.users[var_33_0],
			callback = var_30_1
		})
	end
	
	if arg_30_0.vars.is_host and arg_30_0.vars.infos.first_pick and arg_30_0.vars.infos.rule ~= ARENA_NET_BATTLE_RULE.DRAFT then
		if not var_30_0() then
			return 
		end
		
		if arg_30_0.vars.first_pick_checkbox.HOME:isSelected() or arg_30_0.vars.first_pick_checkbox.AWAY:isSelected() then
			local var_30_3 = arg_30_0.vars.infos.first_pick == "HOME" and arg_30_0.vars.infos.home_user or arg_30_0.vars.infos.away_user
			local var_30_4 = var_30_1
			local var_30_5 = false
			
			if arg_30_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC2 and arg_30_0.vars.infos.round_benefit and (arg_30_0.vars.round_benefit_checkbox.HOME:isSelected() or arg_30_0.vars.round_benefit_checkbox.AWAY:isSelected()) == true then
				var_30_4 = var_30_2
				var_30_5 = true
			end
			
			ArenaNetFirstpickConfirmPopup:show({
				type = "first_pick",
				user_info = arg_30_0.vars.infos.users[var_30_3],
				callback = var_30_4,
				ready_next_popup = var_30_5
			})
		elseif arg_30_0.vars.infos.round_benefit and arg_30_0.vars.round_benefit_checkbox.HOME:isSelected() or arg_30_0.vars.round_benefit_checkbox.AWAY:isSelected() then
			var_30_2()
		else
			var_30_1()
		end
	elseif arg_30_0.vars.is_host and arg_30_0.vars.infos.round_benefit and arg_30_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		if not var_30_0() then
			return 
		end
		
		if arg_30_0.vars.round_benefit_checkbox.HOME:isSelected() or arg_30_0.vars.round_benefit_checkbox.AWAY:isSelected() then
			var_30_2()
		else
			var_30_1()
		end
	else
		var_30_1()
	end
end

function ArenaNetLounge.cancel(arg_34_0)
	arg_34_0.vars.service:query("command", {
		type = "cancel"
	})
end

function ArenaNetLounge.update(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.vars.infos.bgm_id == arg_35_1.bgm_id
	
	arg_35_0.vars.infos.host = arg_35_1.host
	arg_35_0.vars.infos.title = arg_35_1.title
	arg_35_0.vars.infos.rule = arg_35_1.rule
	arg_35_0.vars.infos.is_public = arg_35_1.is_public == 1
	arg_35_0.vars.infos.is_enable_chat = arg_35_1.is_enable_chat == 1
	arg_35_0.vars.infos.password = arg_35_1.password
	arg_35_0.vars.infos.bg_id = arg_35_1.bg_id
	arg_35_0.vars.infos.bgm_id = arg_35_1.bgm_id
	arg_35_0.vars.infos.first_pick = arg_35_1.first_pick
	arg_35_0.vars.infos.round_benefit = arg_35_1.round_benefit
	arg_35_0.vars.infos.preban_count = arg_35_1.preban_count
	arg_35_0.vars.infos.home_user = arg_35_1.home_user
	arg_35_0.vars.infos.away_user = arg_35_1.away_user
	arg_35_0.vars.infos.home_ready = arg_35_1.home_ready
	arg_35_0.vars.infos.away_ready = arg_35_1.away_ready
	arg_35_0.vars.infos.total_round = arg_35_1.total_round
	arg_35_0.vars.is_host = arg_35_0.vars.user_id == arg_35_0.vars.infos.host
	
	if not var_35_0 then
		local var_35_1 = arg_35_0.vars.infos.bgm_id
		local var_35_2
		local var_35_3
		
		if var_35_1 then
			var_35_2 = MusicBox:getSong(var_35_1).streaming_id
			var_35_3 = var_35_2 and cc.FileUtils:getInstance():fullPathForFilename("bgm_ost/" .. var_35_2)
		end
		
		SoundEngine:playBGM(tostring(var_35_2 and var_35_3 or "event:/bgm/" .. (var_35_1 or "bgm_rta_lounge2")), nil, true)
	end
	
	if arg_35_1.users then
		arg_35_0.vars.infos.users = arg_35_1.users
	elseif arg_35_1.user_diff then
		for iter_35_0, iter_35_1 in pairs(arg_35_1.user_diff or {}) do
			local var_35_4 = iter_35_1.A
			local var_35_5 = iter_35_1.R
			
			if var_35_4 then
				arg_35_0.vars.infos.users[var_35_4.uid] = var_35_4
			elseif var_35_5 then
				arg_35_0.vars.infos.users[var_35_5] = nil
			end
		end
	end
end

function ArenaNetLounge.checkVisibleBtnBanSetting(arg_36_0, arg_36_1)
	if arg_36_0.vars.is_host then
		if arg_36_1 == ARENA_NET_BATTLE_RULE.DRAFT then
			return false
		end
		
		return arg_36_1 ~= ARENA_NET_BATTLE_RULE.E7WC
	else
		return false
	end
end

function ArenaNetLounge.checkVisibleBtnRoundSetting(arg_37_0, arg_37_1)
	if arg_37_0.vars.is_host then
		if arg_37_1 == ARENA_NET_BATTLE_RULE.DRAFT then
			return false
		end
		
		return arg_37_1 == ARENA_NET_BATTLE_RULE.E7WC or arg_37_1 == ARENA_NET_BATTLE_RULE.E7WC2
	else
		return false
	end
end

function ArenaNetLounge.checkVisibleBtnDraftInfo(arg_38_0, arg_38_1)
	return arg_38_1 == ARENA_NET_BATTLE_RULE.DRAFT
end

function ArenaNetLounge.updateUI(arg_39_0)
	if not get_cocos_refid(arg_39_0.vars.wnd) then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.user_id == arg_39_0.vars.infos.home_user or arg_39_0.vars.user_id == arg_39_0.vars.infos.away_user
	
	if_set_visible(arg_39_0.vars.RIGHT, "btn_setting", arg_39_0.vars.is_host)
	if_set_visible(arg_39_0.vars.RIGHT, "btn_invite", arg_39_0.vars.is_host)
	if_set_visible(arg_39_0.vars.RIGHT, "btn_background", arg_39_0.vars.is_host)
	if_set_visible(arg_39_0.vars.RIGHT, "btn_bgm_setting", arg_39_0.vars.is_host)
	if_set_opacity(arg_39_0.vars.RIGHT, "btn_bgm_setting", arg_39_0.vars.is_host and MusicBox:isEnable() and 255 or 76.5)
	if_set_visible(arg_39_0.vars.RIGHT, "btn_ban_setting", arg_39_0:checkVisibleBtnBanSetting(arg_39_0.vars.infos.rule))
	if_set_visible(arg_39_0.vars.RIGHT, "btn_round", arg_39_0:checkVisibleBtnRoundSetting(arg_39_0.vars.infos.rule))
	if_set_visible(arg_39_0.vars.RIGHT, "btn_draft_info", arg_39_0:checkVisibleBtnDraftInfo(arg_39_0.vars.infos.rule))
	if_set(arg_39_0.vars.LEFT, "title", check_abuse_filter(arg_39_0.vars.infos.title, ABUSE_FILTER.CHAT) or arg_39_0.vars.infos.title)
	if_set_visible(arg_39_0.vars.LEFT, "icon_locked", not arg_39_0.vars.infos.is_public)
	if_set(arg_39_0.vars.btn_ban_setting, "t_count_ban", tostring(arg_39_0.vars.infos.preban_count))
	if_set(arg_39_0.vars.MOD, "t_mod", getArenaRuleName(arg_39_0.vars.infos.rule))
	arg_39_0.vars.ban_setting_noti_node:setVisible(not arg_39_0.vars.is_host and arg_39_0.vars.infos.rule ~= ARENA_NET_BATTLE_RULE.E7WC and arg_39_0.vars.infos.rule ~= ARENA_NET_BATTLE_RULE.DRAFT)
	if_set(arg_39_0.vars.ban_setting_noti_node, "t_count_ban", tostring(arg_39_0.vars.infos.preban_count))
	arg_39_0.vars.round_setting_noti_node:setVisible(not arg_39_0.vars.is_host and (arg_39_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC or arg_39_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC2))
	if_set(arg_39_0.vars.round_setting_noti_node, "t_round", getRoundNotiText(arg_39_0.vars.infos.total_round))
	if_set(arg_39_0.vars.round_setting_noti_node, "t_count_round", tostring(arg_39_0.vars.infos.total_round))
	if_set(arg_39_0.vars.btn_round_setting, "t_count_round", tostring(arg_39_0.vars.infos.total_round))
	
	local var_39_1, var_39_2 = UIUtil:getTextWidthAndPos(arg_39_0.vars.LEFT, "title")
	
	arg_39_0.vars.LEFT:getChildByName("icon_locked"):setPositionX(var_39_2 + (var_39_1 + 18))
	
	if arg_39_0.vars.is_host then
		if arg_39_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
			if_set_position_x(arg_39_0.vars.RIGHT, "btn_round", 300)
		else
			if_set_position_x(arg_39_0.vars.RIGHT, "btn_round", 365)
			if_set_position_x(arg_39_0.vars.RIGHT, "btn_draft_info", 365)
		end
	elseif arg_39_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		local var_39_3 = arg_39_0.vars.ban_setting_noti_node:getChildByName("t_preban")
		
		if get_cocos_refid(var_39_3) then
			local var_39_4 = var_39_3:getContentSize().width
			local var_39_5 = var_39_3:getScaleX()
			local var_39_6 = var_39_3:getChildByName("icon_menu_ban")
			
			if get_cocos_refid(var_39_6) then
				local var_39_7 = var_39_5 * (var_39_4 + var_39_6:getContentSize().width * var_39_6:getScaleX()) + 10
				local var_39_8 = arg_39_0.vars.round_setting_noti_node:getChildByName("t_round")
				
				if get_cocos_refid(var_39_8) then
					var_39_8:setPositionX(var_39_3:getPositionX() - var_39_7)
				end
			end
		end
	else
		if_set_position_x(arg_39_0.vars.round_setting_noti_node, nil, 0)
		if_set_position_x(arg_39_0.vars.RIGHT, "btn_draft_info", 615)
	end
	
	arg_39_0:updateSlot(arg_39_0.vars.slots.HOME, arg_39_0.vars.infos.home_user)
	arg_39_0:updateSlot(arg_39_0.vars.slots.AWAY, arg_39_0.vars.infos.away_user)
	
	if arg_39_0.vars.is_host and var_39_0 then
		if_set(arg_39_0.vars.btn_ready, "label", T("pvp_rta_mock_start"))
		arg_39_0.vars.btn_ready:setVisible(true)
		arg_39_0.vars.btn_cancel:setVisible(false)
		
		if arg_39_0.vars.infos.home_ready or arg_39_0.vars.infos.away_ready then
			arg_39_0.vars.btn_ready:setOpacity(255)
		else
			arg_39_0.vars.btn_ready:setOpacity(127.5)
		end
	elseif arg_39_0.vars.is_host and not var_39_0 then
		if_set(arg_39_0.vars.btn_ready, "label", T("pvp_rta_mock_start"))
		arg_39_0.vars.btn_ready:setVisible(true)
		
		if arg_39_0.vars.infos.home_ready and arg_39_0.vars.infos.away_ready then
			arg_39_0.vars.btn_ready:setOpacity(255)
		else
			arg_39_0.vars.btn_ready:setOpacity(127.5)
		end
	elseif var_39_0 then
		if_set(arg_39_0.vars.btn_ready, "label", T("pvp_rta_mock_ready"))
		if_set(arg_39_0.vars.btn_cancel, "label", T("pvp_rta_mock_cancle"))
		
		if arg_39_0.vars.user_id == arg_39_0.vars.infos.home_user then
			arg_39_0.vars.btn_ready:setVisible(not arg_39_0.vars.infos.home_ready)
			arg_39_0.vars.btn_cancel:setVisible(arg_39_0.vars.infos.home_ready)
		else
			arg_39_0.vars.btn_ready:setVisible(not arg_39_0.vars.infos.away_ready)
			arg_39_0.vars.btn_cancel:setVisible(arg_39_0.vars.infos.away_ready)
		end
	else
		arg_39_0.vars.btn_ready:setVisible(false)
		arg_39_0.vars.btn_cancel:setVisible(false)
	end
	
	if arg_39_0.vars.is_host then
		for iter_39_0, iter_39_1 in pairs({
			"HOME",
			"AWAY"
		}) do
			arg_39_0.vars.first_pick_noties[iter_39_1]:setVisible(false)
			arg_39_0.vars.first_pick_checkers[iter_39_1]:setVisible(arg_39_0.vars.infos.rule ~= ARENA_NET_BATTLE_RULE.DRAFT)
			arg_39_0.vars.first_pick_checkbox[iter_39_1]:setSelected(iter_39_1 == arg_39_0.vars.infos.first_pick)
			
			local var_39_9 = iter_39_1 == arg_39_0.vars.infos.first_pick and tocolor("#6bc11b") or tocolor("#888888")
			
			arg_39_0.vars.first_pick_checkbox_text[iter_39_1]:setTextColor(var_39_9)
			
			local var_39_10 = false
			
			if ArenaService:isAdminUser() and arg_39_0.vars.infos.rule == ARENA_NET_BATTLE_RULE.E7WC2 and arg_39_0.vars.infos.total_round == 7 then
				var_39_10 = true
			end
			
			arg_39_0.vars.round_benefit_checkers[iter_39_1]:setVisible(var_39_10)
			arg_39_0.vars.round_benefit_checkbox[iter_39_1]:setSelected(iter_39_1 == arg_39_0.vars.infos.round_benefit)
			
			local var_39_11 = iter_39_1 == arg_39_0.vars.infos.round_benefit and tocolor("#ff7800") or tocolor("#888888")
			
			arg_39_0.vars.round_benefit_checkbox_text[iter_39_1]:setTextColor(var_39_11)
		end
	else
		for iter_39_2, iter_39_3 in pairs({
			"HOME",
			"AWAY"
		}) do
			arg_39_0.vars.first_pick_checkers[iter_39_3]:setVisible(false)
			arg_39_0.vars.first_pick_noties[iter_39_3]:setVisible(iter_39_3 == arg_39_0.vars.infos.first_pick)
			arg_39_0.vars.round_benefit_checkers[iter_39_3]:setVisible(false)
		end
	end
	
	local var_39_12 = {}
	
	for iter_39_4, iter_39_5 in pairs(arg_39_0.vars.infos.users) do
		table.insert(var_39_12, iter_39_5)
	end
	
	table.sort(var_39_12, function(arg_40_0, arg_40_1)
		return arg_40_0.index < arg_40_1.index
	end)
	arg_39_0.vars.listview:setDataSource(var_39_12 or {})
	arg_39_0.vars.listview:refresh()
	arg_39_0:onChangeBackground(makeBGItem(arg_39_0.vars.infos.bg_id), {
		is_watch = true
	})
end

function ArenaNetLounge.updateSlot(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0.vars.infos.users[arg_41_2]
	
	if arg_41_2 and var_41_0 then
		local var_41_1 = arg_41_2 == arg_41_0.vars.user_id
		local var_41_2 = arg_41_2 == arg_41_0.vars.infos.host
		local var_41_3 = (var_41_0.win or 0) + (var_41_0.draw or 0) + (var_41_0.lose or 0) < ARENA_MATCH_BATCH_COUNT
		
		arg_41_1:getChildByName("pos"):setVisible(true)
		if_set_visible(arg_41_1, "n_none", false)
		if_set_visible(arg_41_1, "infor", true)
		if_set_visible(arg_41_1, "icon_master", var_41_2)
		
		local var_41_4 = arg_41_1:getChildByName("txt_name")
		local var_41_5 = check_abuse_filter(var_41_0.name, ABUSE_FILTER.WORLD_NAME) or var_41_0.name
		
		if var_41_1 then
			var_41_4:setString(var_41_5 .. "[me]")
			var_41_4:setTextColor(cc.c3b(107, 193, 27))
			var_41_4:enableOutline(cc.c3b(107, 193, 27), 1)
		else
			var_41_4:setString(var_41_5)
			var_41_4:setTextColor(cc.c3b(255, 255, 255))
			var_41_4:enableOutline(cc.c3b(255, 255, 255), 1)
		end
		
		if_set(arg_41_1, "txt_nation", getRegionText(var_41_0.world))
		UIUtil:getUserIcon(var_41_0.leader_code, {
			no_popup = true,
			name = false,
			no_role = true,
			no_lv = true,
			scale = 1,
			no_grade = true,
			parent = arg_41_1:getChildByName("n_face"),
			border_code = var_41_0.border_code
		})
		
		if var_41_3 then
			SpriteCache:resetSprite(arg_41_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
		else
			local var_41_6, var_41_7 = getArenaNetRankInfo(var_41_0.season_id, var_41_0.league_id)
			
			SpriteCache:resetSprite(arg_41_1:getChildByName("emblem"), "emblem/" .. var_41_7 .. ".png")
		end
		
		local var_41_8 = arg_41_1:getChildByName("n_clan")
		
		if_set(arg_41_1, "txt_clan", clanNameFilter(var_41_0.clan_name))
		UIUtil:updateClanEmblem(var_41_8, {
			emblem = var_41_0.clan_emblem
		})
		var_41_8:getChildByName("emblem"):setPosition(100, 100)
		if_set_visible(var_41_8, "emblem", string.len(var_41_0.clan_name or "") > 0)
		
		local var_41_9 = string.len(var_41_0.clan_name or "") > 0 and 0 or 26
		
		if_set_add_position_y(arg_41_1, "n_node", var_41_9)
		
		local function var_41_10(arg_42_0, arg_42_1, arg_42_2)
			local var_42_0 = arg_42_0:getChildByName("disc")
			
			if not get_cocos_refid(var_42_0) then
				return 
			end
			
			if not arg_42_1 then
				arg_42_0:setVisible(false)
			elseif arg_42_2 then
				arg_42_0:setVisible(true)
				var_42_0:setString(T("pvp_rta_mock_player_ready_on"))
				var_42_0:setTextColor(cc.c3b(25, 107, 0))
			else
				arg_42_0:setVisible(true)
				var_42_0:setString(T("pvp_rta_mock_player_ready"))
				var_42_0:setTextColor(cc.c3b(96, 61, 42))
			end
			
			UIUserData:proc(var_42_0)
		end
		
		local var_41_11 = arg_41_1:getChildByName("n_state")
		
		if var_41_2 then
			var_41_11:setVisible(false)
		elseif arg_41_1.ally == "HOME" then
			var_41_10(var_41_11, arg_41_0.vars.infos.home_user, arg_41_0.vars.infos.home_ready)
		elseif arg_41_1.ally == "AWAY" then
			var_41_10(var_41_11, arg_41_0.vars.infos.away_user, arg_41_0.vars.infos.away_ready)
		end
		
		if arg_41_0.vars.edit_mode == "replace" then
			if_set_visible(arg_41_1, "selected_btn", true)
			if_set_visible(arg_41_1, "btn_remove", arg_41_1.ally == arg_41_0.vars.selected_slot)
			if_set_visible(arg_41_1, "btn_swap", arg_41_1.ally ~= arg_41_0.vars.selected_slot)
		elseif arg_41_0.vars.edit_mode == "add" then
			if_set_visible(arg_41_1, "selected_btn", true)
			if_set_visible(arg_41_1, "btn_remove", false)
			if_set_visible(arg_41_1, "btn_swap", true)
		elseif arg_41_0.vars.edit_mode == "exile" then
			if_set_visible(arg_41_1, "selected_btn", true)
			if_set_visible(arg_41_1, "btn_remove", false)
			if_set_visible(arg_41_1, "btn_swap", arg_41_0.vars.selected_spectator ~= arg_41_0.vars.infos.home_user and arg_41_0.vars.selected_spectator ~= arg_41_0.vars.infos.away_user)
		else
			if_set_visible(arg_41_1, "selected_btn", false)
			if_set_visible(arg_41_1, "btn_remove", false)
			if_set_visible(arg_41_1, "btn_swap", false)
		end
	else
		local var_41_12 = arg_41_1:getChildByName("pos")
		
		var_41_12.code = nil
		var_41_12.model = nil
		
		var_41_12:setVisible(false)
		var_41_12:removeAllChildren()
		if_set_visible(arg_41_1, "n_none", true)
		if_set_visible(arg_41_1, "infor", false)
		if_set_visible(arg_41_1, "selected_btn", false)
		if_set_visible(arg_41_1, "btn_remove", false)
		
		if arg_41_0.vars.edit_mode == "replace" then
			if_set_visible(arg_41_1, "selected_btn", true)
			if_set_visible(arg_41_1, "btn_swap", true)
		elseif arg_41_0.vars.edit_mode == "exile" then
			if_set_visible(arg_41_1, "selected_btn", true)
			if_set_visible(arg_41_1, "btn_remove", false)
			if_set_visible(arg_41_1, "btn_swap", arg_41_0.vars.selected_spectator ~= arg_41_0.vars.infos.home_user and arg_41_0.vars.selected_spectator ~= arg_41_0.vars.infos.away_user)
		else
			if_set_visible(arg_41_1, "selected_btn", false)
			if_set_visible(arg_41_1, "btn_swap", false)
		end
	end
	
	local var_41_13 = string.format("blink.%d", get_cocos_refid(arg_41_1.cursor))
	
	if arg_41_0.vars.edit_mode == "add" and arg_41_0.vars.selected_slot == arg_41_1.ally then
		if not UIAction:Find(var_41_13) then
			arg_41_1.cursor:setVisible(true)
			arg_41_1.cursor:setOpacity(255)
			UIAction:Add(SEQ(DELAY(200), LOOP(SEQ(LOG(FADE_OUT(400)), LOG(FADE_IN(400))))), arg_41_1.cursor, var_41_13)
		end
	else
		arg_41_1.cursor:setVisible(false)
		arg_41_1.cursor:setOpacity(0)
		UIAction:Remove(var_41_13)
	end
end

function ArenaNetLounge.updateItemRender(arg_43_0, arg_43_1, arg_43_2)
	if not get_cocos_refid(arg_43_1) then
		return 
	end
	
	arg_43_1:getChildByName("btn_add").info = arg_43_2.uid
	arg_43_1:getChildByName("btn_change").info = arg_43_2.uid
	arg_43_1:getChildByName("btn_exile").info = arg_43_2.uid
	arg_43_1:getChildByName("btn_exile_on").info = arg_43_2.uid
	
	local var_43_0 = arg_43_0.vars.user_id == arg_43_2.uid
	local var_43_1 = arg_43_0.vars.infos.home_user ~= arg_43_2.uid and arg_43_0.vars.infos.away_user ~= arg_43_2.uid
	local var_43_2 = arg_43_0.vars.selected_spectator == arg_43_2.uid
	local var_43_3 = (arg_43_2.win or 0) + (arg_43_2.draw or 0) + (arg_43_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	if_set_visible(arg_43_1, "icon_master", arg_43_0.vars.infos.host == arg_43_2.uid)
	if_set_visible(arg_43_1, "btn_add", var_43_1 and arg_43_0.vars.edit_mode == "add")
	if_set_visible(arg_43_1, "btn_change", var_43_1 and arg_43_0.vars.edit_mode == "replace")
	if_set_visible(arg_43_1, "n_btn_exile", var_43_2 and not var_43_0 and arg_43_0.vars.edit_mode == "exile")
	if_set_visible(arg_43_1, "btn_exile_on", not var_43_0 and (arg_43_0.vars.edit_mode == "none" or arg_43_0.vars.edit_mode == "exile"))
	
	if arg_43_0.vars.selected_spectator then
		if_set_visible(arg_43_1, "formation_bg", var_43_2 and not var_43_0 and arg_43_0.vars.edit_mode == "exile")
	else
		if_set_visible(arg_43_1, "formation_bg", var_43_1 and (arg_43_0.vars.edit_mode == "replace" or arg_43_0.vars.edit_mode == "add"))
	end
	
	local var_43_4 = arg_43_1:getChildByName("txt_name")
	local var_43_5 = arg_43_1:getChildByName("txt_nation")
	
	UIUserData:call(var_43_4, "SINGLE_WSCALE(138)")
	UIUserData:call(var_43_5, "SINGLE_WSCALE(103)")
	
	local var_43_6 = check_abuse_filter(arg_43_2.name, ABUSE_FILTER.WORLD_NAME) or arg_43_2.name
	
	if var_43_0 then
		var_43_4:setString(var_43_6 .. "[me]")
		var_43_4:setTextColor(cc.c3b(107, 193, 27))
	else
		var_43_4:setString(var_43_6)
		var_43_4:setTextColor(cc.c3b(255, 255, 255))
	end
	
	var_43_5:setString(getRegionText(arg_43_2.world))
	UIUtil:getUserIcon(arg_43_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_43_1:getChildByName("face_icon"),
		border_code = arg_43_2.border_code
	})
	
	if var_43_3 then
		SpriteCache:resetSprite(arg_43_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		local var_43_7, var_43_8 = getArenaNetRankInfo(arg_43_2.season_id, arg_43_2.league_id)
		
		SpriteCache:resetSprite(arg_43_1:getChildByName("emblem"), "emblem/" .. var_43_8 .. ".png")
	end
end

function ArenaNetLounge.setBackground(arg_44_0, arg_44_1)
	local var_44_0 = DEBUG.BG_ID or arg_44_1.bg_id
	local var_44_1 = arg_44_0.vars.wnd:findChildByName("n_bg")
	
	if get_cocos_refid(arg_44_0.vars.bg) then
		arg_44_0.vars.bg:removeFromParent()
	end
	
	local var_44_2, var_44_3 = FIELD_NEW:create(var_44_0, DESIGN_WIDTH * 2)
	
	var_44_2:setAnchorPoint(0.5, 0.5)
	var_44_2:setPosition(0, -(DESIGN_HEIGHT * 0.5))
	var_44_2:setScale(1)
	var_44_3:setViewPortPosition(VIEW_WIDTH / 2)
	var_44_3:updateViewport()
	var_44_1:addChild(var_44_2)
	
	local var_44_4 = cc.c3b(255, 255, 255)
	
	if arg_44_1.ambient_color then
		local var_44_5 = tonumber(string.sub(arg_44_1.ambient_color, 1, 2), 16)
		local var_44_6 = tonumber(string.sub(arg_44_1.ambient_color, 3, 4), 16)
		local var_44_7 = tonumber(string.sub(arg_44_1.ambient_color, 5, 6), 16)
		
		var_44_4 = cc.c3b(var_44_5, var_44_6, var_44_7)
	end
	
	arg_44_0:applyAmbient(var_44_4)
	
	arg_44_0.vars.ambient_color = var_44_4
	arg_44_0.vars.bg = var_44_2
end

function ArenaNetLounge.applyAmbient(arg_45_0, arg_45_1)
	for iter_45_0, iter_45_1 in pairs({
		"HOME",
		"AWAY"
	}) do
		local var_45_0 = arg_45_0.vars.slots[iter_45_1]
		
		if var_45_0 then
			local var_45_1 = var_45_0:getChildByName("pos")
			
			if var_45_1 and get_cocos_refid(var_45_1.model) then
				var_45_1.model:setColor(arg_45_1)
			end
		end
	end
end

function ArenaNetLounge.updateState(arg_46_0, arg_46_1)
	if arg_46_0.vars.service:isChangeBlocked() then
		return 
	end
	
	SAVE:set("net_arena_lounge_bg", arg_46_0.vars.bg_item.id)
	
	if arg_46_1.cur_state ~= "LOUNGE" then
		Dialog:closeAll()
		UIAction:Add(SEQ(DELAY(6000)), arg_46_0, "block")
	end
	
	arg_46_0.vars.service:changeState(arg_46_1.cur_state, arg_46_1)
end

function ArenaNetLounge.onChangeBackground(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_1 or arg_47_0.vars.bg_item.id == arg_47_1.id then
		return 
	end
	
	arg_47_2 = arg_47_2 or {}
	
	if_set_sprite(arg_47_0.vars.bg_change, "bg_base", arg_47_1.icon)
	if_set(arg_47_0.vars.bg_change, "txt_title", T(arg_47_1.name))
	if_set(arg_47_0.vars.bg_change, "txt_desc", T(arg_47_1.desc))
	
	local var_47_0 = getChildByPath(arg_47_0.vars.wnd, "n_info")
	
	if_set(var_47_0, "t_bg_info", T(arg_47_1.name))
	
	arg_47_0.vars.bg_item = arg_47_1
	
	arg_47_0:setBackground(arg_47_1)
	
	if not arg_47_2.is_watch and arg_47_0.vars.is_host then
		arg_47_0.vars.service:query("command", {
			type = "changebg",
			bg_id = arg_47_1.id,
			theme = arg_47_1.bg_id,
			ambient_color = arg_47_1.ambient_color or "FFFFFF"
		})
	end
end

function ArenaNetLounge.showBGPacks(arg_48_0)
	if arg_48_0.vars.bg_change then
		return 
	end
	
	if not arg_48_0.vars.is_host then
		return 
	end
	
	local var_48_0 = load_control("wnd/bg_change_popup.csb")
	local var_48_1 = arg_48_0.vars.wnd:findChildByName("n_bg_change_popup")
	
	BackButtonManager:push({
		check_id = "bg_change_popup",
		back_func = function()
			ArenaNetLounge:closeBGPacks()
		end
	})
	var_48_1:addChild(var_48_0)
	
	arg_48_0.vars.bg_change = var_48_0
	
	arg_48_0.vars.btn_close_bg:setVisible(true)
	
	local var_48_2 = arg_48_0.vars.bg_item
	
	if_set_sprite(arg_48_0.vars.bg_change, "bg_base", var_48_2.icon)
	if_set(arg_48_0.vars.bg_change, "txt_title", T(var_48_2.name))
	if_set(arg_48_0.vars.bg_change, "txt_desc", T(var_48_2.desc))
	if_set(arg_48_0.vars.wnd, "t_bg_info", T(var_48_2.name))
	if_set_visible(arg_48_0.vars.bg_change, "n_infor", false)
	BGSelector:init(var_48_0:findChildByName("scrollview"), function(arg_50_0, arg_50_1)
		arg_48_0:onChangeBackground(arg_50_1)
	end, "PetHouse")
	
	local var_48_3 = BGSelector:getIdx(arg_48_0.vars.infos.bg_id)
	
	BGSelector:setToIndex(var_48_3)
	var_48_0:setPositionY(-800)
	UIAction:Add(LOG(MOVE_TO(400, nil, 0)), var_48_0, "block")
end

function ArenaNetLounge.closeBGPacks(arg_51_0)
	if not arg_51_0.vars.bg_change then
		return 
	end
	
	BackButtonManager:pop("bg_change_popup")
	UIAction:Add(SEQ(LOG(MOVE_TO(400, nil, -800)), REMOVE()), arg_51_0.vars.bg_change, "block")
	
	arg_51_0.vars.bg_change = nil
	
	arg_51_0.vars.btn_close_bg:setVisible(false)
	BGSelector:close()
end

function ArenaNetLounge.onChangeBGM(arg_52_0, arg_52_1)
	if arg_52_0.vars.bgm_id == arg_52_1 then
		return 
	end
	
	arg_52_0.vars.bgm_id = arg_52_1
	
	if arg_52_0.vars.is_host then
		arg_52_0.vars.service:query("command", {
			type = "changebgm",
			bgm_id = arg_52_0.vars.bgm_id
		})
	end
end

function ArenaNetLounge.showMusicBox(arg_53_0)
	if not arg_53_0.vars.is_host then
		return 
	end
	
	ArenaNetMusicBox:requestShowSimple()
end

function ArenaNetLounge.closeMusicBox(arg_54_0)
	arg_54_0.vars.btn_close_ban:setVisible(false)
	ArenaNetPreBanCountPopup:close()
end

function ArenaNetLounge.showSettings(arg_55_0)
	if not arg_55_0.vars.is_host then
		return 
	end
	
	local var_55_0 = {}
	
	var_55_0.mode = "CHANGE"
	var_55_0.title = arg_55_0.vars.infos.title
	var_55_0.rule = arg_55_0.vars.infos.rule
	var_55_0.password = arg_55_0.vars.infos.password
	var_55_0.is_public = arg_55_0.vars.infos.is_public
	var_55_0.is_enable_chat = arg_55_0.vars.infos.is_enable_chat
	
	function var_55_0.callback(arg_56_0)
		local var_56_0 = {
			type = "changeinfo",
			title = arg_56_0.title,
			rule = arg_56_0.rule,
			is_public = arg_56_0.is_public,
			is_enable_chat = arg_56_0.is_enable_chat,
			password = arg_56_0.password
		}
		
		if_set_visible(arg_55_0.vars.RIGHT, "btn_ban_setting", arg_55_0:checkVisibleBtnBanSetting(var_56_0.rule))
		if_set_visible(arg_55_0.vars.RIGHT, "btn_round", arg_55_0:checkVisibleBtnRoundSetting(var_56_0.rule))
		if_set_visible(arg_55_0.vars.RIGHT, "btn_draft_info", arg_55_0:checkVisibleBtnDraftInfo(var_56_0.rule))
		
		if arg_56_0.rule == ARENA_NET_BATTLE_RULE.E7WC then
			if_set_position_x(arg_55_0.vars.RIGHT, "btn_round", 365)
		elseif arg_56_0.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
			if_set_position_x(arg_55_0.vars.RIGHT, "btn_round", 300)
		end
		
		arg_55_0.vars.service:query("command", var_56_0)
	end
	
	ArenaNetCreatePopup:show(var_55_0)
end

function ArenaNetLounge.showInvitePopup(arg_57_0)
	query("arena_net_get_commu_list", {
		clan_id = AccountData.clan_id or -1
	})
end

function ArenaNetLounge.showPrebanSetting(arg_58_0)
	arg_58_0.vars.btn_close_ban:setVisible(true)
	ArenaNetPreBanCountPopup:show(arg_58_0.vars.btn_ban_setting_node, arg_58_0.vars.infos.rule, arg_58_0.vars.infos.preban_count, function(arg_59_0)
		local var_59_0 = {
			type = "bansetting",
			preban_count = arg_59_0
		}
		
		arg_58_0.vars.service:query("command", var_59_0)
	end)
end

function ArenaNetLounge.closePrebanSetting(arg_60_0)
	arg_60_0.vars.btn_close_ban:setVisible(false)
	ArenaNetPreBanCountPopup:close()
end

function ArenaNetLounge.showRoundSetting(arg_61_0)
	arg_61_0.vars.btn_close_bg:setVisible(true)
	ArenaNetRoundSettingPopup:show({
		parent = arg_61_0.vars.btn_round_setting,
		round = arg_61_0.vars.infos.total_round,
		callback = function(arg_62_0)
			local var_62_0 = {
				1,
				3,
				5,
				7
			}
			
			arg_61_0.vars.service:query("command", {
				type = "roundsetting",
				total_round = var_62_0[arg_62_0]
			})
		end
	})
end

function ArenaNetLounge.showDraftInfo(arg_63_0)
	ArenaNetCardCollection:show({
		parent = SceneManager:getRunningPopupScene()
	})
end

function ArenaNetLounge.closeRoundSetting(arg_64_0)
	arg_64_0.vars.btn_close_bg:setVisible(false)
	ArenaNetRoundSettingPopup:close()
end

function ArenaNetLounge.selectFirstPickUser(arg_65_0, arg_65_1)
	arg_65_0.vars.first_pick_checkbox[arg_65_1]:setSelected(not arg_65_0.vars.first_pick_checkbox[arg_65_1]:isSelected())
	
	if arg_65_0.vars.first_pick_checkbox.HOME:isSelected() and arg_65_0.vars.first_pick_checkbox.AWAY:isSelected() then
		if arg_65_1 == "HOME" then
			arg_65_0.vars.first_pick_checkbox.AWAY:setSelected(false)
		else
			arg_65_0.vars.first_pick_checkbox.HOME:setSelected(false)
		end
	end
	
	local var_65_0
	
	if arg_65_0.vars.first_pick_checkbox.HOME:isSelected() then
		var_65_0 = "HOME"
	elseif arg_65_0.vars.first_pick_checkbox.AWAY:isSelected() then
		var_65_0 = "AWAY"
	end
	
	arg_65_0.vars.infos.first_pick = var_65_0
	
	local var_65_1 = arg_65_0.vars.first_pick_checkbox.HOME:isSelected() and tocolor("#6bc11b") or tocolor("#888888")
	local var_65_2 = arg_65_0.vars.first_pick_checkbox.AWAY:isSelected() and tocolor("#6bc11b") or tocolor("#888888")
	
	arg_65_0.vars.first_pick_checkbox_text.HOME:setTextColor(var_65_1)
	arg_65_0.vars.first_pick_checkbox_text.AWAY:setTextColor(var_65_2)
	
	local var_65_3 = {
		type = "firstpick",
		first_pick = var_65_0
	}
	
	arg_65_0.vars.service:query("command", var_65_3)
end

function ArenaNetLounge.selectRoundBenefitUser(arg_66_0, arg_66_1)
	arg_66_0.vars.round_benefit_checkbox[arg_66_1]:setSelected(not arg_66_0.vars.round_benefit_checkbox[arg_66_1]:isSelected())
	
	if arg_66_0.vars.round_benefit_checkbox.HOME:isSelected() and arg_66_0.vars.round_benefit_checkbox.AWAY:isSelected() then
		if arg_66_1 == "HOME" then
			arg_66_0.vars.round_benefit_checkbox.AWAY:setSelected(false)
		else
			arg_66_0.vars.round_benefit_checkbox.HOME:setSelected(false)
		end
	end
	
	local var_66_0
	
	if arg_66_0.vars.round_benefit_checkbox.HOME:isSelected() then
		var_66_0 = "HOME"
	elseif arg_66_0.vars.round_benefit_checkbox.AWAY:isSelected() then
		var_66_0 = "AWAY"
	end
	
	arg_66_0.vars.infos.round_benefit = var_66_0
	
	local var_66_1 = arg_66_0.vars.round_benefit_checkbox.HOME:isSelected() and tocolor("#ff7800") or tocolor("#888888")
	local var_66_2 = arg_66_0.vars.round_benefit_checkbox.AWAY:isSelected() and tocolor("#ff7800") or tocolor("#888888")
	
	arg_66_0.vars.round_benefit_checkbox_text.HOME:setTextColor(var_66_1)
	arg_66_0.vars.round_benefit_checkbox_text.AWAY:setTextColor(var_66_2)
	
	local var_66_3 = {
		type = "roundbenefit",
		round_benefit = var_66_0
	}
	
	arg_66_0.vars.service:query("command", var_66_3)
end

function HANDLER.pvplive_lounge_ban_setting(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = tonumber(string.sub(arg_67_1, -1, -1))
	
	if var_67_0 then
		ArenaNetPreBanCountPopup:select(var_67_0, true)
	end
end

ArenaNetPreBanCountPopup = {}

function ArenaNetPreBanCountPopup.show(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
	arg_68_0.vars = {}
	arg_68_0.vars.wnd = load_control("wnd/pvplive_lounge_ban_setting.csb")
	
	arg_68_0.vars.wnd:setAnchorPoint(0.4, 1)
	BackButtonManager:push({
		check_id = "preban_count_popup",
		back_func = function()
			ArenaNetLounge:closePrebanSetting()
		end
	})
	
	arg_68_0.vars.btns = {}
	arg_68_0.vars.callback = arg_68_4
	arg_68_0.vars.rule = arg_68_2
	
	for iter_68_0 = 0, 3 do
		local var_68_0 = "btn_" .. tostring(iter_68_0) .. "_on"
		
		arg_68_0.vars.btns[iter_68_0 + 1] = arg_68_0.vars.wnd:getChildByName(var_68_0)
	end
	
	if arg_68_0.vars.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		if_set_color(arg_68_0.vars.wnd, "btn_3", cc.c3b(136, 136, 136))
	end
	
	arg_68_0:select(arg_68_3)
	arg_68_1:addChild(arg_68_0.vars.wnd)
end

function ArenaNetPreBanCountPopup.close(arg_70_0)
	BackButtonManager:pop("preban_count_popup")
	arg_70_0.vars.wnd:removeFromParent()
	
	arg_70_0.vars = nil
end

function ArenaNetPreBanCountPopup.select(arg_71_0, arg_71_1, arg_71_2)
	if os.time() - (arg_71_0.vars.elapsed or 0) < 1 then
		balloon_message_with_sound("nickname.check_wait_seconds")
		
		return 
	end
	
	if arg_71_1 == 3 and arg_71_0.vars.rule == ARENA_NET_BATTLE_RULE.E7WC2 then
		balloon_message_with_sound("pvp_rta_cannot_select_preban_num")
		
		return 
	end
	
	for iter_71_0 = 1, 4 do
		if iter_71_0 == arg_71_1 + 1 then
			arg_71_0.vars.btns[iter_71_0]:setVisible(true)
		else
			arg_71_0.vars.btns[iter_71_0]:setVisible(false)
		end
	end
	
	arg_71_0.vars.elapsed = os.time()
	
	if arg_71_2 and arg_71_0.vars.callback then
		arg_71_0.vars.callback(arg_71_1)
	end
end

function HANDLER.pvplive_first_confirm(arg_72_0, arg_72_1)
	if arg_72_1 == "btn_ok" then
		ArenaNetFirstpickConfirmPopup:ok()
	elseif arg_72_1 == "btn_cancel" then
		ArenaNetFirstpickConfirmPopup:close()
	elseif arg_72_1 == "btn_close" then
		ArenaNetFirstpickConfirmPopup:close()
	end
end

ArenaNetFirstpickConfirmPopup = {}

function ArenaNetFirstpickConfirmPopup.show(arg_73_0, arg_73_1)
	arg_73_1 = arg_73_1 or {}
	
	if arg_73_0.vars then
		arg_73_0.vars.ready_next_popup = arg_73_1.ready_next_popup
		arg_73_0.vars.callback = arg_73_1.callback
		
		arg_73_0:updateUI(arg_73_1)
		
		return 
	end
	
	arg_73_0.vars = {}
	arg_73_0.vars.wnd = load_dlg("pvplive_first_confirm", true, "wnd", function()
		arg_73_0:close()
	end)
	arg_73_0.vars.ready_next_popup = arg_73_1.ready_next_popup
	arg_73_0.vars.callback = arg_73_1.callback
	
	arg_73_0:updateUI(arg_73_1)
	SceneManager:getRunningPopupScene():addChild(arg_73_0.vars.wnd)
end

function ArenaNetFirstpickConfirmPopup.updateUI(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_1.user_info or {}
	local var_75_1 = arg_75_0.vars.wnd:getChildByName("n_user_info")
	local var_75_2 = (var_75_0.win or 0) + (var_75_0.draw or 0) + (var_75_0.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	if arg_75_1.type then
		if arg_75_1.type == "first_pick" then
			if_set(arg_75_0.vars.wnd, "txt_title", T("pvp_rta_first_pick_ask2"))
			if_set(arg_75_0.vars.wnd, "t_disc", T("pvp_rta_first_pick_ask2_desc"))
		elseif arg_75_1.type == "benefit" then
			local var_75_3 = arg_75_0.vars.wnd:getChildByName("n_user_info")
			
			if_set_add_position_y(var_75_3, nil, 24)
			arg_75_0.vars.wnd:getChildByName("n_first_pick"):setVisible(false)
			if_set(arg_75_0.vars.wnd, "txt_title", T("pvp_rta_round_benefit_chk"))
			if_set(arg_75_0.vars.wnd, "t_disc", T("pvp_rta_round_benefit_desc"))
		end
	end
	
	if_set(var_75_1, "txt_name", check_abuse_filter(var_75_0.name, ABUSE_FILTER.WORLD_NAME) or var_75_0.name)
	if_set(var_75_1, "txt_nation", getRegionText(var_75_0.world))
	UIUtil:getUserIcon(var_75_0.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_75_1:getChildByName("mob_icon"),
		border_code = var_75_0.border_code
	})
	
	if var_75_2 then
		SpriteCache:resetSprite(var_75_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		local var_75_4, var_75_5 = getArenaNetRankInfo(var_75_0.season_id, var_75_0.league_id)
		
		SpriteCache:resetSprite(var_75_1:getChildByName("emblem"), "emblem/" .. var_75_5 .. ".png")
	end
end

function ArenaNetFirstpickConfirmPopup.ok(arg_76_0)
	local var_76_0 = arg_76_0.vars.ready_next_popup
	
	arg_76_0.vars.callback()
	
	if not var_76_0 then
		arg_76_0:close()
	end
end

function ArenaNetFirstpickConfirmPopup.close(arg_77_0)
	if not arg_77_0.vars then
		return 
	end
	
	arg_77_0.vars.wnd:removeFromParent()
	
	arg_77_0.vars = nil
end

function HANDLER.pvplive_lounge_round_setting(arg_78_0, arg_78_1, arg_78_2)
	if string.starts(arg_78_1, "round") then
		ArenaNetRoundSettingPopup:select(string.sub(arg_78_1, -1, -1))
	end
end

ArenaNetRoundSettingPopup = {}

function ArenaNetRoundSettingPopup.show(arg_79_0, arg_79_1)
	arg_79_1 = arg_79_1 or {}
	arg_79_0.vars = {}
	arg_79_0.vars.wnd = load_dlg("pvplive_lounge_round_setting", true, "wnd", function()
		arg_79_0:close()
	end)
	arg_79_0.vars.callback = arg_79_1.callback
	
	arg_79_0:updateSelectedRound(arg_79_1.round)
	
	local var_79_0 = SceneManager:convertToSceneSpace(arg_79_1.parent, {
		x = 0,
		y = -80
	})
	
	arg_79_0.vars.wnd:setPosition(var_79_0.x, var_79_0.y)
	SceneManager:getRunningPopupScene():addChild(arg_79_0.vars.wnd)
end

function ArenaNetRoundSettingPopup.close(arg_81_0, arg_81_1)
	if not arg_81_0.vars then
		return 
	end
	
	if arg_81_1 and arg_81_0.vars.callback then
		arg_81_0.vars.callback(arg_81_1)
	end
	
	arg_81_0.vars.wnd:removeFromParent()
	
	arg_81_0.vars = nil
end

function ArenaNetRoundSettingPopup.select(arg_82_0, arg_82_1)
	arg_82_0:close(tonumber(arg_82_1))
end

function ArenaNetRoundSettingPopup.updateSelectedRound(arg_83_0, arg_83_1)
	local var_83_0 = arg_83_0:getRoundUINumber(arg_83_1)
	
	for iter_83_0 = 1, 4 do
		local var_83_1 = arg_83_0.vars.wnd:getChildByName("round" .. tostring(iter_83_0))
		
		if var_83_1 then
			if_set_visible(var_83_1, "sort_cursor", iter_83_0 == var_83_0)
		end
	end
end

function ArenaNetRoundSettingPopup.getRoundUINumber(arg_84_0, arg_84_1)
	return ({
		1,
		nil,
		2,
		nil,
		3,
		nil,
		4
	})[arg_84_1]
end
