UnitTeam = {}

copy_functions(Formation, UnitTeam)
copy_functions(FormationEditor, UnitTeam)

local function var_0_0(arg_1_0)
	local var_1_0 = Account:getCurrentTeamIndex()
	local var_1_1 = Account:getTeam(var_1_0)
	local var_1_2 = 0
	
	for iter_1_0 = 1, 10 do
		local var_1_3 = var_1_1[iter_1_0]
		
		if var_1_3 then
			var_1_2 = var_1_2 + var_1_3:getPoint()
		end
	end
	
	if var_1_2 <= UnitTeam.vars.enemy_point * 0.75 then
		return true
	else
		return false
	end
end

function HANDLER.unit_team(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_go" then
		if to_n(UnitTeam.vars.pvp_info.enemy_info.revenge_count) >= 3 then
			local var_2_0 = load_dlg("pvp_revenge_msgbox", true, "wnd")
			
			Dialog:msgBox(nil, {
				yesno = true,
				dlg = var_2_0,
				handler = function()
					PvpSA:startPVP(UnitTeam.vars.pvp_info.enemy_info.enemy_uid, UnitTeam.vars.team_idx)
				end
			})
		else
			PvpSA:startPVP(UnitTeam.vars.pvp_info.enemy_info.enemy_uid, UnitTeam.vars.team_idx)
		end
	elseif arg_2_1 == "btn_ballon_rvg" or arg_2_1 == "btn_ballon_rvg_reset" then
		UnitTeam:closeRevengeBalloon(arg_2_1)
	end
end

function UnitTeam.onTouchDown(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars.touch_pos = arg_4_1:getLocation()
	
	arg_4_2:stopPropagation()
	
	return true
end

function UnitTeam.onTouchMove(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0.vars.touch_pos then
		return 
	end
	
	local var_5_0 = arg_5_1:getLocation()
	
	if math.abs(arg_5_0.vars.touch_pos.x - var_5_0.x) > 30 or math.abs(arg_5_0.vars.touch_pos.y - var_5_0.y) > 30 then
		arg_5_0.vars.touch_drag = true
	end
	
	return true
end

function UnitTeam.onTouchUp(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars.touch_drag = nil
end

function UnitTeam.checkModelTouch(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getLocation()
	local var_7_1 = {}
	
	if arg_7_0.vars.model_ids[3] then
		var_7_1[3] = arg_7_0.vars.model_ids[3].model.model
	end
	
	if arg_7_0.vars.model_ids[4] then
		var_7_1[4] = arg_7_0.vars.model_ids[4].model.model
	end
	
	if arg_7_0.vars.model_ids[1] then
		var_7_1[1] = arg_7_0.vars.model_ids[1].model.model
	end
	
	if arg_7_0.vars.model_ids[2] then
		var_7_1[2] = arg_7_0.vars.model_ids[2].model.model
	end
	
	if_set_visible(arg_7_0.vars.wnd, "n_teamlist", false)
	if_set_visible(arg_7_0.vars.wnd, "n_infos", false)
	
	local var_7_2 = slowpick(arg_7_0.vars.form_node, var_7_1, var_7_0.x, var_7_0.y)
	
	if_set_visible(arg_7_0.vars.wnd, "n_teamlist", true)
	if_set_visible(arg_7_0.vars.wnd, "n_infos", true)
	
	if var_7_2 then
		arg_7_0.vars.touched_model_idx = var_7_2
		
		return true
	end
end

function UnitTeam.openBossGuide(arg_8_0)
	local var_8_0 = CoopMission:getCurrentBossLastLevelInfo()
	
	if not var_8_0 then
		return 
	end
	
	BossGuide:show({
		parent = SceneManager:getRunningNativeScene(),
		enter_id = var_8_0.level_enter
	})
end

function UnitTeam.openMultiPromote(arg_9_0)
	arg_9_0:setNormalMode()
	UnitMain:setMode("MultiPromote")
end

function UnitTeam.create(arg_10_0, arg_10_1)
	arg_10_1 = arg_10_1 or {}
	arg_10_0.vars = {}
	arg_10_0.vars.pvp_info = arg_10_1.pvp_info
	arg_10_0.vars.is_coop = arg_10_1.is_coop
	arg_10_0.vars.is_automaton = arg_10_1.is_automaton
	
	local var_10_0 = 1
	local var_10_1
	
	if arg_10_0.vars.pvp_info and not arg_10_0.vars.pvp_info.defend_mode then
		arg_10_0.vars.wnd = load_dlg("pvp_ready", true, "wnd")
		
		arg_10_0.vars.wnd:setName("unit_team")
		
		var_10_1 = load_dlg("pvp_team_formation", true, "wnd")
		var_10_1.class = arg_10_0
		var_10_0 = 0.77
	else
		arg_10_0.vars.wnd = load_dlg("unit_team", true, "wnd")
		var_10_1 = load_dlg("unit_team_formation", true, "wnd")
		var_10_1.class = arg_10_0
		
		local var_10_2 = arg_10_0.vars.pvp_info == nil and not arg_10_0.vars.is_coop and not arg_10_0.vars.is_automaton
		
		var_10_2 = var_10_2 and UnlockSystem:isUnlockSystem(UNLOCK_ID.MULTI_PROMOTE)
		
		if_set_visible(var_10_1, "n_add_team", var_10_2)
		if_set_visible(var_10_1, "btn_bulk_up", var_10_2)
		
		if var_10_2 then
			local var_10_3 = var_10_1:findChildByName("btn_bulk_up")
			local var_10_4 = var_10_1:findChildByName("formation_infor")
			
			if var_10_3 and var_10_4 then
				local var_10_5 = var_10_4:getParent():findChildByName("n_formation_infor_move")
				
				var_10_4:setPositionX(var_10_5:getPositionX())
				
				local var_10_6 = NotchManager:findNotchEvent(var_10_5).origin_x
				
				NotchManager:resetOriginPos(var_10_4, var_10_6)
			end
			
			local var_10_7 = 255
			
			if_set_opacity(var_10_3, nil, var_10_7)
		end
	end
	
	if arg_10_0.vars.is_coop then
		if_set_visible(var_10_1, "n_info", true)
		if_set_visible(var_10_1, "btn_boss_guide", true)
	end
	
	TopBarNew:checkhelpbuttonID("infounit1_6")
	
	arg_10_0.vars.wnd.class = arg_10_0
	
	arg_10_0.vars.wnd:getChildByName("n_pos_formation"):addChild(var_10_1)
	
	local var_10_8 = false
	
	if not arg_10_1.pvp_info and not arg_10_1.is_coop and not arg_10_1.is_automaton then
		var_10_8 = true
	end
	
	FormationEditor:initFormationEditor(arg_10_0, {
		useSimpleTag = true,
		disable_hp_info = true,
		hide_hpbar = true,
		hide_hpbar_color = true,
		use_detail = true,
		btns_ignore_notch = true,
		tagScale = 1,
		tagOffsetY = 80,
		wnd = var_10_1,
		is_coop = arg_10_1.is_coop,
		pvp_info = arg_10_0.vars.pvp_info,
		is_automaton = arg_10_1.is_automaton,
		lobbyTeam = arg_10_1.lobbyTeam,
		is_enable_pet = var_10_8,
		model_scale = var_10_0,
		callbackUpdateFormation = function(arg_11_0)
			HeroBelt:getInst("UnitMain"):updateTeamMarkers()
		end,
		callbackSelectUnit = function(arg_12_0)
			HeroBelt:getInst("UnitMain"):scrollToUnit(arg_12_0)
		end,
		callbackSelectTeam = function(arg_13_0)
			arg_10_0:setTeam(arg_13_0)
		end
	})
	
	if arg_10_0.vars.pvp_info then
		arg_10_0:updatePvPInfo(arg_10_0.vars.wnd:getChildByName("n_my_formation"))
		arg_10_0:updatePvPInfo(arg_10_0.vars.wnd:getChildByName("n_peer_formation"), true)
		
		local var_10_9 = arg_10_0.vars.wnd:getChildByName("n_progress")
		
		if arg_10_0.vars.pvp_info.no_repeat then
			if_set_visible(arg_10_0.vars.wnd, "n_progress", false)
		elseif var_10_9 then
			var_10_9:setVisible(true)
			
			local var_10_10 = math.floor(arg_10_0.vars.pvp_info.my_battle_count / arg_10_0.vars.pvp_info.repeat_reward_period) % arg_10_0.vars.pvp_info.repeat_reward_type_max + 1
			local var_10_11, var_10_12 = DB("pvp_sa", arg_10_0.vars.pvp_info.my_league, {
				"repeat_reward_id" .. var_10_10,
				"repeat_reward_count" .. var_10_10
			})
			
			UIUtil:getRewardIcon(var_10_12, var_10_11, {
				scale = 0.6,
				detail = false,
				parent = var_10_9:getChildByName("icon_repeat_reward")
			})
			
			local var_10_13 = arg_10_0.vars.pvp_info.my_battle_count % arg_10_0.vars.pvp_info.repeat_reward_period
			
			if_set(var_10_9, "txt_floor_exp", T("pvp_rapid_prize", {
				num = var_10_13,
				need = arg_10_0.vars.pvp_info.repeat_reward_period
			}))
			var_10_9:getChildByName("exp_gauge"):setPercent(100 * var_10_13 / arg_10_0.vars.pvp_info.repeat_reward_period)
			UIUtil:setButtonEnterInfo(arg_10_0.vars.wnd:getChildByName("btn_go"), "pvp001")
		end
		
		local var_10_14 = arg_10_0.vars.wnd:getChildByName("btn_go")
		
		if arg_10_0.vars.pvp_info.enemy_info then
			local var_10_15 = to_n(arg_10_0.vars.pvp_info.enemy_info.revenge_id)
			local var_10_16 = to_n(arg_10_0.vars.pvp_info.enemy_info.revenge_count)
			
			if var_10_15 > 0 then
				if var_10_16 >= 3 then
					if_set_visible(var_10_14, "n_ballon_rvg", false)
					if_set_visible(var_10_14, "n_ballon_rvg_reset", true)
					
					local var_10_17 = var_10_14:getChildByName("n_ballon_rvg_reset")
					local var_10_18, var_10_19, var_10_20 = Account:serverTimeDayLocalDetail()
					
					if_set(var_10_17, "t_count", "3/3")
					if_set(var_10_17, "t_time", T("pvp_revenge_reset", {
						time = sec_to_string(var_10_20 - os.time())
					}))
				else
					if_set_visible(var_10_14, "n_ballon_rvg", true)
					if_set_visible(var_10_14, "n_ballon_rvg_reset", false)
					
					local var_10_21 = var_10_14:getChildByName("n_ballon_rvg")
					
					if_set(var_10_21, "t_count", to_n(var_10_16) .. "/3")
				end
			else
				if_set_visible(var_10_14, "n_ballon_rvg", false)
				if_set_visible(var_10_14, "n_ballon_rvg_reset", false)
			end
			
			local var_10_22 = arg_10_0.vars.wnd:getChildByName("n_victory_bonus")
			
			if var_10_22 then
				local var_10_23 = false
				
				if arg_10_0.vars.pvp_info.enemy_info.enemy_uid then
					var_10_23 = string.split(arg_10_0.vars.pvp_info.enemy_info.enemy_uid, ":")[1] == "npc"
				end
				
				if var_10_15 > 0 or var_10_23 then
					if_set_visible(var_10_22, "n_on", false)
					if_set_visible(var_10_22, "n_off", false)
					if_set_visible(var_10_22, "n_cv_info", false)
					if_set_visible(var_10_22, "n_revenge", true)
				else
					if_set_visible(var_10_22, "n_cv_info", true)
					if_set_visible(var_10_22, "n_revenge", false)
					
					local var_10_24 = to_n(arg_10_0.vars.pvp_info.continuous_victory)
					local var_10_25
					
					for iter_10_0 = 1, 999 do
						local var_10_26 = {}
						
						var_10_26.id, var_10_26.step, var_10_26.count_min, var_10_26.count_max, var_10_26.bonus_point, var_10_26.bonus_item, var_10_26.bonus_item_value = DBN("pvp_streak", iter_10_0, {
							"id",
							"step",
							"count_min",
							"count_max",
							"bonus_point",
							"bonus_item",
							"bonus_item_value"
						})
						
						if not var_10_26.id then
							break
						end
						
						var_10_25 = var_10_26
						
						if var_10_24 >= var_10_26.count_min and var_10_24 <= var_10_26.count_max then
							var_10_25 = var_10_26
							
							break
						end
					end
					
					WidgetUtils:setupTooltip({
						control = var_10_22:getChildByName("btn_bonus"),
						creator = function()
							return PvpSAArenaInfo:bonus_tooltip(var_10_24)
						end
					})
					
					if var_10_25 and (to_n(var_10_25.bonus_point) > 0 or to_n(var_10_25.bonus_item_value) > 0) then
						if_set(var_10_22, "txt_count_conti_win", T("pvp_win_rapid", {
							count = comma_value(var_10_24)
						}))
						if_set_visible(var_10_22, "n_pts", to_n(var_10_25.bonus_point) > 0)
						
						if to_n(var_10_25.bonus_point) > 0 then
							if_set(var_10_22, "txt_point", T("pvp_streak_bonus_point", {
								bonus_point = var_10_25.bonus_point
							}))
						end
						
						if_set_visible(var_10_22, "n_con_point", to_n(var_10_25.bonus_item_value) > 0)
						
						if to_n(var_10_25.bonus_item_value) > 0 then
							if_set(var_10_22, "txt_pvpgold", T("pvp_streak_bonus_item", {
								bonus_item = var_10_25.bonus_item_value
							}))
						end
						
						if_set_visible(var_10_22, "n_on", true)
						if_set_visible(var_10_22, "n_off", false)
					else
						if_set_visible(var_10_22, "n_on", false)
						if_set_visible(var_10_22, "n_off", true)
					end
				end
			end
		end
	end
	
	local var_10_27 = arg_10_0.vars.wnd:getChildByName("LEFT")
	local var_10_28 = arg_10_0.vars.wnd:getChildByName("RIGHT")
	local var_10_29 = arg_10_0.vars.wnd:getChildByName("CENTER")
	local var_10_30 = arg_10_0.vars.wnd:getChildByName("FORMATION")
	
	var_10_27:setPositionX(var_10_27:getPositionX() - 250)
	
	if var_10_28 then
		var_10_28:setPositionX(var_10_28:getPositionX() + 250)
	end
	
	var_10_29:setPositionY(-800)
	
	if var_10_30 then
		var_10_30:setPositionY(-800)
	end
end

function UnitTeam.closeRevengeBalloon(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("btn_go")
	
	if arg_15_1 == "btn_ballon_rvg" then
		local var_15_1 = var_15_0:getChildByName("n_ballon_rvg")
		
		UIAction:Add(SEQ(DELAY(300), FADE_OUT(200), SHOW(false)), var_15_1, "ballon_rvg")
	elseif arg_15_1 == "btn_ballon_rvg_reset" then
		local var_15_2 = var_15_0:getChildByName("n_ballon_rvg_reset")
		
		UIAction:Add(SEQ(DELAY(300), FADE_OUT(200), SHOW(false)), var_15_2, "ballon_rvg_reset")
	end
end

function UnitTeam.onGameEvent(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars then
		return 
	end
	
	if arg_16_1 == "shop_buy" or arg_16_1 == "read_mail" then
		arg_16_0:updatePvpKey()
	end
end

function UnitTeam.updatePvpKey(arg_17_0)
	if arg_17_0.vars and arg_17_0.vars.pvp_info and get_cocos_refid(arg_17_0.vars.wnd) then
		local var_17_0 = {}
		
		var_17_0.replace_enterpoint = 1
		
		UIUtil:setButtonEnterInfo(arg_17_0.vars.wnd:getChildByName("btn_go"), "pvp001", var_17_0)
	end
end

function UnitTeam.updatePvPInfo(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 or not get_cocos_refid(arg_18_1) then
		return 
	end
	
	local var_18_0
	local var_18_1
	local var_18_2
	local var_18_3
	local var_18_4
	local var_18_5
	
	if not arg_18_2 then
		var_18_1 = AccountData.name
		var_18_0 = AccountData.level
		var_18_2 = arg_18_0.vars.pvp_info.my_score
		var_18_3 = Clan:getClanInfo()
	elseif arg_18_0.vars.pvp_info.enemy_info then
		var_18_1 = arg_18_0.vars.pvp_info.enemy_info.name
		var_18_0 = arg_18_0.vars.pvp_info.enemy_info.level
		var_18_2 = arg_18_0.vars.pvp_info.enemy_info.score
		var_18_3 = arg_18_0.vars.pvp_info.enemy_info.clan
		
		if arg_18_0.vars.pvp_info.enemy_info.enemy_uid then
			local var_18_6 = string.split(arg_18_0.vars.pvp_info.enemy_info.enemy_uid, ":")
			
			if var_18_6[1] == "npc" then
				var_18_5 = tonumber(var_18_6[2])
				var_18_4 = var_18_6[3]
			end
		end
	end
	
	if var_18_4 then
		if_set_visible(arg_18_1, "infor_npc", true)
		if_set_visible(arg_18_1, "infor", false)
		
		local var_18_7 = arg_18_1:getChildByName("infor_npc")
		local var_18_8 = DBT("pvp_npcbattle", var_18_4, {
			"name",
			"sort",
			"unlock_id",
			"team_leader",
			"reset_time",
			"reward1_normal",
			"count1_normal",
			"reward2_normal",
			"count2_normal",
			"reward1_hard",
			"count1_hard",
			"reward2_hard",
			"count2_hard",
			"reward1_hell",
			"count1_hell",
			"reward2_hell",
			"count2_hell"
		})
		
		if_set(var_18_7, "txt_name", var_18_1)
		if_set(var_18_7, "txt_name", T(var_18_8.name))
		
		local var_18_9 = var_18_8["reward1_" .. PvpNPC:getDifficultyString(var_18_5)]
		local var_18_10 = var_18_8["count1_" .. PvpNPC:getDifficultyString(var_18_5)]
		local var_18_11 = var_18_8["reward2_" .. PvpNPC:getDifficultyString(var_18_5)]
		local var_18_12 = var_18_8["count2_" .. PvpNPC:getDifficultyString(var_18_5)]
		
		UIUtil:getRewardIcon(var_18_10, var_18_9, {
			show_small_count = true,
			show_name = false,
			scale = 1,
			detail = true,
			parent = var_18_7:getChildByName("n_item_reward1")
		})
		UIUtil:getRewardIcon(var_18_12, var_18_11, {
			show_small_count = true,
			show_name = false,
			scale = 1,
			detail = true,
			parent = var_18_7:getChildByName("n_item_reward2")
		})
	elseif PvpSA:isCurrentBlind() and arg_18_2 then
		if_set_visible(arg_18_1, "infor_npc", false)
		if_set_visible(arg_18_1, "infor", false)
		if_set_visible(arg_18_1, "n_blind", true)
		
		local var_18_13 = arg_18_1:getChildByName("n_blind")
		
		if var_18_13 then
			local var_18_14 = var_18_13:getChildByName("txt_blind_info")
			local var_18_15 = UIUtil:setTextAndReturnHeight(var_18_14)
			local var_18_16 = var_18_13:getChildByName("txt_unkown")
			
			if var_18_16 then
				var_18_16:setPositionY(var_18_14:getPositionY() + var_18_15 + 9)
			end
			
			if_set(var_18_13, "txt_win_point", T("pvp_point", {
				point = comma_value(var_18_2)
			}))
		end
	else
		if_set_visible(arg_18_1, "infor_npc", false)
		if_set_visible(arg_18_1, "infor", true)
		if_set_visible(arg_18_1, "n_blind", false)
		
		local var_18_17 = arg_18_1:getChildByName("infor")
		
		if_set(var_18_17, "txt_name", var_18_1)
		if_set(var_18_17, "txt_rating", T("pvp_point", {
			point = comma_value(var_18_2)
		}))
		
		local var_18_18 = var_18_17:getChildByName("n_rank")
		
		if var_18_18 and var_18_0 then
			UIUtil:setLevel(var_18_18, var_18_0, MAX_ACCOUNT_LEVEL, 2)
			
			local var_18_19 = var_18_18:getChildByName("n_lv_num")
			
			if var_18_19 ~= nil then
				if var_18_0 < 10 then
					var_18_19:setPositionX(var_18_19:getPositionX() - 38)
				elseif var_18_0 < 100 then
					var_18_19:setPositionX(var_18_19:getPositionX() - 18)
				end
			end
		end
		
		local var_18_20 = var_18_17:getChildByName("n_clan")
		
		if var_18_3 then
			if_set_visible(var_18_17, "n_clan", true)
			if_set(var_18_20, "txt_clan", var_18_3.name)
			UIUtil:updateClanEmblem(var_18_20, var_18_3)
		else
			if_set_visible(var_18_17, "n_clan", false)
		end
	end
end

function UnitTeam.onSelectUnit(arg_19_0, arg_19_1)
	if arg_19_0.vars.formation_status == "ReadyToChangeUnit" then
		arg_19_0:changeUnit(arg_19_1, true)
		
		return true
	end
end

function UnitTeam.onPushBackground(arg_20_0)
	if not arg_20_0.vars.touched_model_idx then
		if not TutorialGuide:isAllowEvent() then
			return 
		end
		
		arg_20_0:setNormalMode()
	end
end

function UnitTeam.onCancelButton(arg_21_0)
	arg_21_0:setNormalMode()
end

function UnitTeam.close(arg_22_0)
	arg_22_0:removeModeEffects()
end

function UnitTeam.onEnter(arg_23_0, arg_23_1, arg_23_2)
	HeroBelt:getInst("UnitMain"):changeMode("Main")
	HeroBelt:getInst("UnitMain"):tempSaveFilter("Main")
	
	arg_23_2 = arg_23_2 or {}
	
	local var_23_0 = UnitMain:getPortrait()
	
	if get_cocos_refid(var_23_0) then
		UnitMain:leavePortrait(nil, false)
	end
	
	if arg_23_1 == "Detail" or arg_23_1 == "MultiPromote" then
		UnitTeam:updateTeamPoint(Account:getTeam(arg_23_0.vars.team_idx))
		UnitTeam:updateHeroTags()
		SoundEngine:play("event:/ui/menu/menu_1")
		if_set_visible(arg_23_0.vars.wnd, "bg_base", true)
		UnitMain:showUnitList(true)
	end
	
	local var_23_1 = arg_23_0.vars.wnd:getChildByName("LEFT")
	local var_23_2 = arg_23_0.vars.wnd:getChildByName("RIGHT")
	local var_23_3 = arg_23_0.vars.wnd:getChildByName("CENTER")
	local var_23_4 = arg_23_0.vars.wnd:getChildByName("FORMATION")
	
	if_set_opacity(arg_23_0.vars.wnd, "img_bg", 255)
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, NotchStatus:getNotchBaseLeft()), 100)), var_23_1, "block")
	
	if var_23_2 then
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, NotchStatus:getNotchSafeRight() - VIEW_BASE_LEFT), 100)), var_23_2, "block")
	end
	
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, nil, 0), 100)), var_23_3, "block")
	
	if var_23_4 then
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, nil, 0), 100)), var_23_4, "block")
	end
	
	for iter_23_0 = 1, 4 do
	end
	
	local var_23_5 = HeroBelt:getInst("UnitMain"):getCurrentControl()
	
	if var_23_5 then
		var_23_5.add:setVisible(true)
	end
	
	arg_23_0:setNormalMode()
	
	if arg_23_0.vars.pvp_info and not arg_23_0.vars.pvp_info.defend_mode and not arg_23_0.vars.pvp_peer_formation_editor then
		local var_23_6 = {}
		
		copy_functions(FormationEditor, var_23_6)
		FormationEditor:initFormationEditor(var_23_6, {
			hide_hpbar = true,
			tagScale = 1,
			flip_model = true,
			useSimpleTag = true,
			tagOffsetY = 80,
			model_scale = 0.77,
			notUseTouchHandler = true,
			hide_hpbar_color = true,
			wnd = arg_23_0.vars.wnd:getChildByName("n_peer_formation"),
			pvp_info = arg_23_0.vars.pvp_info,
			callbackUpdateFormation = function(arg_24_0)
				HeroBelt:getInst("UnitMain"):updateTeamMarkers()
			end,
			callbackSelectUnit = function(arg_25_0)
				HeroBelt:getInst("UnitMain"):scrollToUnit(arg_25_0)
			end,
			callbackSelectTeam = function(arg_26_0)
				arg_23_0:setTeam(arg_26_0)
			end
		})
		var_23_6:updateFormation(arg_23_0.vars.pvp_info.enemy_team)
		
		arg_23_0.vars.pvp_peer_formation_editor = var_23_6
	end
	
	arg_23_0:setFormationEditMode(true)
	
	if UnitMain:isVisibleBackground() then
		UnitMain:fadeOutBackground()
	end
	
	if_set_visible(arg_23_0.vars.wnd, "noti_support", Account:getTeam(12)[1] == nil)
	
	if arg_23_0.removeDedicationEffect then
		arg_23_0:removeDedicationEffect()
	end
end

function UnitTeam.playPvPReadyAnimation(arg_27_0)
	arg_27_0:playReadyAnimation(true)
	
	if arg_27_0.vars.pvp_peer_formation_editor then
		arg_27_0.vars.pvp_peer_formation_editor:playReadyAnimation(true)
	end
end

function UnitTeam.onLeave(arg_28_0, arg_28_1)
	if not Account:getLeaderUnit() and not arg_28_0.vars.is_coop then
		Account:selectTeam(1)
	end
	
	arg_28_0:setFormationEditMode(false)
	
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("LEFT")
	local var_28_1 = arg_28_0.vars.wnd:getChildByName("RIGHT")
	local var_28_2 = arg_28_0.vars.wnd:getChildByName("CENTER")
	local var_28_3 = arg_28_0.vars.wnd:getChildByName("FORMATION")
	local var_28_4 = arg_28_0.vars.wnd:getChildByName("img_bg")
	
	if get_cocos_refid(var_28_4) then
		UIAction:Add(FADE_OUT(200), var_28_4, "block")
	end
	
	UIAction:Add(SEQ(RLOG(MOVE_TO(200, -300), 100), SHOW(false)), var_28_0, "block")
	UIAction:Add(SEQ(RLOG(MOVE_TO(200, nil, -800), 100), SHOW(false)), var_28_2, "block")
	
	if var_28_1 then
		UIAction:Add(SEQ(RLOG(MOVE_TO(200, 300), 100), SHOW(false)), var_28_1, "block")
	end
	
	if var_28_3 then
		UIAction:Add(SEQ(RLOG(MOVE_TO(200, nil, -800), 100), SHOW(false)), var_28_3, "block")
	end
	
	if_set_visible(arg_28_0.vars.wnd, "bg_base", false)
	
	local var_28_5 = HeroBelt:getInst("UnitMain"):getCurrentControl()
	
	if var_28_5 then
		var_28_5.add:setVisible(false)
	end
end

function UnitTeam.showTeamFormation(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0.vars and arg_29_0.vars.form_node then
		if arg_29_2 then
			local var_29_0
			
			if arg_29_1 then
				var_29_0 = FADE_IN(arg_29_2)
			else
				var_29_0 = FADE_OUT(arg_29_2)
			end
			
			UIAction:Add(SEQ(var_29_0, SHOW(arg_29_1)), arg_29_0.vars.form_node, "block")
			UIAction:Add(SEQ(var_29_0, SHOW(arg_29_1)), HeroBelt:getInst("UnitMain"):getWindow(), "block")
		else
			arg_29_0.vars.form_node:setVisible(arg_29_1)
			HeroBelt:getInst("UnitMain"):setVisible(arg_29_1)
		end
	end
end

function UnitTeam.onUnitDetail(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0.vars.pvp_info ~= nil
	
	UnitMain:setMode("Detail", {
		unit = arg_30_1,
		pvp_mode = var_30_0
	})
end
