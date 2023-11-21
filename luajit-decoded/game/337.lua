Formation = {}
FormationTeamSelector = {}

copy_functions(ScrollView, FormationTeamSelector)

function HANDLER.btn_team(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_name_set" then
		TeamNameModifyDialog:init(arg_1_0.team_idx, arg_1_0.cont)
	end
end

function FormationTeamSelector.getScrollViewItem(arg_2_0, arg_2_1)
	local var_2_0 = load_control(arg_2_0.opts.btn_team_name or "wnd/btn_team.csb")
	
	if_set_visible(var_2_0, "btn_name_set", false)
	
	if arg_2_0.opts.npcteam_id then
		if_set(var_2_0, "txt_team", T(arg_2_1))
		if_set_visible(var_2_0, "n_defence", false)
		if_set_visible(var_2_0, "txt_team", true)
		if_set_visible(var_2_0, "lock", false)
		
		return var_2_0
	end
	
	local var_2_1 = AccountData.team_names[arg_2_1]
	local var_2_2 = var_2_1 == nil or var_2_1.name == "" or var_2_1.name == nil
	
	if var_2_2 then
		local var_2_3 = arg_2_1
		
		if arg_2_1 > 1000 then
			var_2_3 = arg_2_1 - 990
		end
		
		if_set(var_2_0, "txt_team", T("team", {
			team = var_2_3
		}))
	else
		if_set(var_2_0, "txt_team", var_2_1.name)
	end
	
	if arg_2_0.opts.is_coop and var_2_2 then
		if_set(var_2_0, "txt_team", T("expedition_team_name", {
			sort = Account:getCoopTeamIdx(arg_2_1)
		}))
	end
	
	if arg_2_0.opts.is_automaton then
		if_set(var_2_0, "txt_team", T("automtn_team"))
	end
	
	if arg_2_0.opts.is_crehunt then
		if_set(var_2_0, "txt_team", T("crehunt_team"))
	end
	
	if_set_visible(var_2_0, "cm_icon_etc_fix", arg_2_1 == Account:getLobbyTeamIdx())
	if_set_visible(var_2_0, "n_defence", arg_2_1 == 11)
	if_set_visible(var_2_0, "txt_team", arg_2_1 ~= 11)
	if_set_visible(var_2_0, "lock", not Account:isUnlockedTeam(arg_2_1))
	
	var_2_0:findChildByName("btn_name_set").team_idx = arg_2_1
	var_2_0:findChildByName("btn_name_set").cont = var_2_0
	
	return var_2_0
end

function FormationTeamSelector.updateTeamInfo(arg_3_0)
	if not arg_3_0.ScrollViewItems then
		return 
	end
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.ScrollViewItems) do
		if get_cocos_refid(iter_3_1.control) then
			local var_3_0 = iter_3_1.control:getChildByName("bg_team")
			local var_3_1 = iter_3_1.control:getChildByName("txt_team")
			local var_3_2 = Account:getLobbyTeamIdx()
			local var_3_3 = arg_3_0.parent:getTeamIndex() or 0
			
			if_set_visible(iter_3_1.control, "cm_icon_etc_fix", iter_3_1.item == var_3_2 and var_3_3 ~= var_3_2)
			
			if var_3_0 then
				local var_3_4 = arg_3_0.parent:getTeamIndex() == iter_3_1.item or not not arg_3_0.opts.npcteam_id
				
				var_3_0:setVisible(var_3_4)
				
				if var_3_4 then
					for iter_3_2, iter_3_3 in pairs(iter_3_1.control:getChildren()) do
						if iter_3_3.getName and iter_3_3.setColor and iter_3_3:getName() ~= "cm_icon_etc_fix" then
							iter_3_3:setColor(cc.c3b(255, 255, 255))
						end
					end
					
					if not arg_3_0.opts.npcteam_id and not arg_3_0.opts.is_automaton and not arg_3_0.opts.is_crehunt then
						if arg_3_0.prv_cont then
							if_set_visible(arg_3_0.prv_cont, "btn_name_set", false)
						end
						
						if_set_visible(iter_3_1.control, "btn_name_set", true)
						
						arg_3_0.prv_cont = iter_3_1.control
					end
				else
					for iter_3_4, iter_3_5 in pairs(iter_3_1.control:getChildren()) do
						if iter_3_5.getName and iter_3_5.setColor and iter_3_5:getName() ~= "cm_icon_etc_fix" then
							iter_3_5:setColor(cc.c3b(97, 183, 255))
						end
					end
				end
			end
		end
	end
	
	arg_3_0:updateTeamSubtaskInfo()
end

function FormationTeamSelector.updateTeamSubtaskInfo(arg_4_0)
	if not arg_4_0.ScrollViewItems then
		return 
	end
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.ScrollViewItems) do
		local var_4_0 = Account:isTeamInSubtaskMission(iter_4_0)
		
		if_set_visible(iter_4_1.control, "n_time", var_4_0)
		
		if var_4_0 then
			if_set_visible(iter_4_1.control, "detail", arg_4_0.opts.show_subtask_detail == true)
			
			if arg_4_0.opts.show_subtask_detail then
				local var_4_1 = Account:getTeamSubtaskEndTime(iter_4_0)
				
				if var_4_1 then
					local var_4_2 = var_4_1 - os.time()
					
					if var_4_2 > 0 then
						if_set(iter_4_1.control, "txt_time", sec_to_string(var_4_2))
					else
						if_set(iter_4_1.control, "txt_time", T("complete_text"))
					end
				else
					if_set(iter_4_1.control, "txt_time", "-")
				end
			end
		end
	end
end

function Formation.setFormWindow(arg_5_0, arg_5_1)
	arg_5_0.vars.form_node = arg_5_1
	
	for iter_5_0 = 1, 10 do
		local var_5_0 = arg_5_1:getChildByName("n_eat" .. iter_5_0)
		
		if get_cocos_refid(var_5_0) then
			if_set(var_5_0, "txt_eat", T("time_heal"))
		end
		
		if not arg_5_1:getChildByName("pos" .. iter_5_0) then
			break
		end
		
		arg_5_0.vars.base_count = iter_5_0
	end
	
	local var_5_1 = arg_5_1:getChildByName("base_sinsu")
	
	if var_5_1 then
		if arg_5_0.vars.pvp_info == nil and not arg_5_0.vars.is_coop and not arg_5_0.vars.is_automaton then
			var_5_1:setVisible(true)
			
			if #Account.summons == 0 then
				var_5_1:setOpacity(155)
				var_5_1:setColor(cc.c3b(100, 100, 100))
			else
				var_5_1:setVisible(false)
			end
			
			UnlockSystem:setUnlockUIState(arg_5_1, "btn_sinsu", UNLOCK_ID.SINSU, {
				icon_name = "icon_locked_sinsu",
				no_opacity = true
			})
		else
			var_5_1:setVisible(false)
			if_set_visible(arg_5_1, "icon_locked_sinsu", false)
		end
	end
	
	local var_5_2 = arg_5_1:getChildByName("base_pet")
	
	if var_5_2 then
		if arg_5_0.vars.pvp_info == nil then
			var_5_2:setVisible(true)
			
			local var_5_3 = not arg_5_0.opts.is_enable_pet or not not arg_5_0.opts.npcteam_id
			
			BattleRepeat:init_repeatCheckbox(arg_5_1:getChildByName("n_check_box"), nil, var_5_3)
			if_set_visible(arg_5_1, "n_check_box", true)
			
			if not Account:isHaveBattlePets() then
				var_5_2:setOpacity(155)
				var_5_2:setColor(cc.c3b(100, 100, 100))
				if_set_opacity(arg_5_1, "n_check_box", 155)
			else
				if_set_opacity(arg_5_1, "base_pet", var_5_3 and 76 or 255)
				if_set_visible(arg_5_1, "n_check_box", not var_5_3)
			end
			
			arg_5_0:_movePosByPetContentState()
		else
			var_5_2:setVisible(false)
			if_set_visible(arg_5_1, "icon_locked_pet", false)
			if_set_visible(arg_5_1, "n_check_box", false)
		end
	end
	
	if arg_5_0.vars.is_automaton then
		if_set_visible(arg_5_1, "btn_device_inven", true)
		
		local var_5_4 = arg_5_1:getChildByName("n_btn_dedi")
		
		if var_5_4 and not var_5_4.originPos then
			var_5_4.originPos = var_5_4:getPosition()
			
			local var_5_5 = arg_5_1:getChildByName("n_btn_dedi_atomtn_move")
			
			if var_5_5 then
				var_5_4:setPosition(var_5_5:getPosition())
			end
			
			if_set_visible(arg_5_1, "n_power", false)
			if_set_visible(arg_5_1, "n_automtn_power", true)
			
			local var_5_6 = arg_5_1:getChildByName("n_device_apply_tip")
			
			if var_5_6 then
				var_5_6:setVisible(true)
				if_set(var_5_6, "txt_device_apply", T("automtn_power_device_info"))
				UIAction:Add(SEQ(DELAY(3000), LOG(FADE_OUT(500)), REMOVE()), var_5_6)
			end
		end
	end
	
	if_set_visible(arg_5_1, "base_hidden", arg_5_0.vars.pvp_info ~= nil and arg_5_0.vars.pvp_info.defend_mode == true or arg_5_0.vars.is_coop or arg_5_0.vars.is_automaton)
end

function Formation.update_repeatCount(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1 or SceneManager:getRunningNativeScene():getChildByName("formation")
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	local var_6_1 = var_6_0:getChildByName("n_check_box")
	
	if not get_cocos_refid(var_6_1) then
		return 
	end
	
	local var_6_2, var_6_3 = BattleRepeat:getConfigRepeatBattleCount(arg_6_0.vars and arg_6_0.vars.team_idx)
	
	if arg_6_2 and arg_6_2.getRepeat_count then
		local var_6_4 = arg_6_2:getRepeat_count()
		
		if var_6_4 < var_6_2 or var_6_3 then
			var_6_2 = var_6_4
		end
	end
	
	if not arg_6_2 then
		var_6_2 = 0
	end
	
	if_set(var_6_1, "label", var_6_2)
end

local var_0_0

function MsgHandler.inc_team_slot(arg_7_0)
	AccountData.max_team = arg_7_0.max_team
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.currency) do
		Account:setCurrency(iter_7_0, iter_7_1)
	end
	
	FormationTeamSelector:initTeamSelector(var_0_0.parent, var_0_0.opts)
	
	local var_7_0 = AccountData.max_team
	
	if var_7_0 > 10 then
		var_7_0 = var_7_0 + 990
	end
	
	FormationTeamSelector:selectTeam(var_7_0)
	
	if var_7_0 > 9 then
		FormationTeamSelector:jumpToPercent(100)
	end
end

function FormationTeamSelector.reqAddTeam(arg_8_0)
	if AccountData.max_team >= Account:getMaxPublicReservedTeam() then
		balloon_message_with_sound("team_add_max")
		
		return 
	end
	
	local var_8_0, var_8_1 = DB("team_slot_price", tostring(AccountData.max_team + 1), {
		"token",
		"price"
	})
	
	Dialog:msgBox(T("inc_team_slot"), {
		title = T("inc_team"),
		token = var_8_0,
		cost = var_8_1,
		handler = function()
			query("inc_team_slot", {
				idx = AccountData.max_team + 1
			})
			
			var_0_0 = arg_8_0
		end
	})
end

function FormationTeamSelector.selectTeam(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.ScrollViewItems) do
		if iter_10_1.item == arg_10_1 then
			arg_10_0:onSelectScrollViewItem(iter_10_0, iter_10_1)
		end
	end
end

function FormationTeamSelector.onSelectScrollViewItem(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.opts.callbackSelectTeam then
		arg_11_0.opts.callbackSelectTeam(arg_11_2.item)
	end
	
	if arg_11_0.opts.npcteam_id then
		return 
	end
	
	if arg_11_0.opts.is_coop then
		return 
	end
	
	if arg_11_0.opts.is_automaton then
		return 
	end
	
	if arg_11_0.opts.is_crehunt then
		return 
	end
	
	if arg_11_0.prv_cont then
		if_set_visible(arg_11_0.prv_cont, "btn_name_set", false)
	end
	
	if_set_visible(arg_11_2.control, "btn_name_set", true)
	
	arg_11_0.prv_item = arg_11_2.control
end

function FormationTeamSelector.initTeamSelector(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.teamlist_scrollview or arg_12_1.vars.form_node and arg_12_1.vars.form_node:getChildByName("scrollview_team")
	
	if not var_12_0 then
		return 
	end
	
	arg_12_0.ScrollViewItems = nil
	arg_12_0.parent = arg_12_1
	arg_12_0.opts = arg_12_2
	
	arg_12_0:initScrollView(var_12_0, arg_12_2.team_btn_width or 140, 60)
	
	if arg_12_2.pvp_info and arg_12_2.pvp_info.defend_mode then
		FormationTeamSelector:createScrollViewItems({
			11
		})
	elseif arg_12_2.pvp_info and arg_12_2.pvp_info.clan_pvp_mode then
		FormationTeamSelector:createScrollViewItems({
			1
		})
	elseif arg_12_2.npcteam_id then
		FormationTeamSelector:createScrollViewItems({
			"npcteam_name"
		})
	elseif arg_12_2.is_coop then
		FormationTeamSelector:createScrollViewItems(Account:getCoopReservedTeamSlot())
	elseif arg_12_2.is_automaton then
		FormationTeamSelector:createScrollViewItems({
			Account:getAutomatonTeamIndex()
		})
	elseif arg_12_2.is_crehunt then
		FormationTeamSelector:createScrollViewItems({
			Account:getCrehuntTeamIndex()
		})
	else
		local var_12_1 = {}
		
		if arg_12_2.show_defend_team then
			var_12_1[1] = 11
		end
		
		for iter_12_0, iter_12_1 in pairs(Account:getPublicReservedTeamSlot()) do
			if iter_12_0 <= AccountData.max_team then
				table.push(var_12_1, iter_12_1)
			end
		end
		
		FormationTeamSelector:createScrollViewItems(var_12_1)
	end
	
	local var_12_2 = Account:getMaxPublicReservedTeam()
	
	if arg_12_0.parent:getTeamIndex() > 9 then
		arg_12_0:jumpToPercent(100)
	end
	
	local var_12_3 = arg_12_1.vars and get_cocos_refid(arg_12_1.vars.form_node) and arg_12_1.vars.form_node:getChildByName("n_add_team")
	
	if get_cocos_refid(var_12_3) and var_12_2 <= to_n(AccountData.max_team) then
		if_set_opacity(var_12_3, "icon", 76.5)
		if_set_opacity(var_12_3, "label", 76.5)
	end
	
	arg_12_0:updateTeamInfo()
end

function Formation.initFormation(arg_13_0, arg_13_1, arg_13_2)
	copy_functions(FormationBase, arg_13_1)
	copy_functions(Formation, arg_13_1)
	
	arg_13_1.opts = arg_13_2
	arg_13_1.vars = arg_13_1.vars or {}
	arg_13_1.vars.model_ids = {}
	arg_13_1.vars.pvp_info = arg_13_2.pvp_info
	arg_13_1.vars.is_coop = arg_13_2.is_coop
	arg_13_1.vars.is_automaton = arg_13_2.is_automaton
	arg_13_1.vars.is_crehunt = arg_13_2.is_crehunt
	arg_13_1.vars.is_enemy = arg_13_2.is_enemy
	arg_13_1.vars.ignore_team_selector = arg_13_2.ignore_team_selector
	
	local var_13_0 = arg_13_1.vars.enter_id
	
	if arg_13_2.tournament_id then
		var_13_0 = "tournament001"
	elseif arg_13_2.pvp_info then
		var_13_0 = "pvp001"
	end
	
	if arg_13_2.is_coop and CoopMission:isValid() then
		arg_13_1.vars.team_idx = CoopUtil:getTeamIdx(CoopMission:getCurrentBossCode())
	elseif arg_13_2.is_automaton then
		arg_13_1.vars.team_idx = Account:getAutomatonTeamIndex()
	elseif arg_13_2.is_crehunt then
		arg_13_1.vars.team_idx = Account:getCrehuntTeamIndex()
	elseif arg_13_2.is_descent and arg_13_2.descent_team_idx then
		arg_13_1.vars.team_idx = arg_13_2.descent_team_idx
	elseif arg_13_2.is_burning and arg_13_2.burning_team_idx then
		arg_13_1.vars.team_idx = arg_13_2.burning_team_idx
		arg_13_1.vars.key_slot_idx = arg_13_2.key_slot_idx
		arg_13_1.vars.key_slot_idx = arg_13_2.key_slot_idx
	else
		arg_13_1.vars.team_idx = Account:loadLocalTeamIndex(var_13_0) or Account:getCurrentTeamIndex()
		
		if arg_13_2.lobbyTeam and arg_13_1.vars.team_idx and not Account:isPublicTeam(arg_13_1.vars.team_idx) then
			arg_13_1.vars.team_idx = Account:getLobbyTeamIdx()
			
			if arg_13_1.vars.team_idx <= 0 then
				arg_13_1.vars.team_idx = 1
			end
		end
		
		Account:selectTeam(arg_13_1.vars.team_idx)
	end
	
	if arg_13_2.pvp_info then
		arg_13_1.vars.formation_mode = "pvp"
		arg_13_1.vars.hidden_unit_index = 5
		
		if arg_13_2.pvp_info.defend_mode then
			arg_13_1.vars.placable_base_count = 4
		else
			arg_13_1.vars.placable_base_count = 4
		end
	elseif arg_13_2.support_mode then
		arg_13_1.vars.formation_mode = "support"
		arg_13_1.vars.ignore_team_selector = true
		arg_13_1.vars.placable_base_count = 7
	else
		arg_13_1.vars.formation_mode = "normal"
		arg_13_1.vars.placable_base_count = 4
	end
	
	if arg_13_1.vars.formation_mode == "support" then
		arg_13_1.vars.model_mode = "Sprite"
	end
	
	if arg_13_2.model_mode then
		arg_13_1.vars.model_mode = arg_13_2.model_mode
	end
	
	arg_13_1:setFormWindow(arg_13_2.wnd)
	
	if not arg_13_1.vars.ignore_team_selector then
		FormationTeamSelector:initTeamSelector(arg_13_1, arg_13_2)
	end
	
	if arg_13_1.vars.pvp_info and arg_13_1.vars.pvp_info.defend_mode then
		arg_13_1.vars.form_node:getChildByName("scrollview_team"):setVisible(false)
	end
	
	Scheduler:removeByName("Formation_Scheduler")
	Scheduler:addSlow(arg_13_1.vars.form_node, function()
		Formation.updateProgressingUnit(arg_13_1)
	end):setName("Formation_Scheduler")
	
	local var_13_1 = arg_13_2.wnd:getChildByName("n_team_info")
	
	if arg_13_2.auto_battle_able and get_cocos_refid(var_13_1) then
		if_set(var_13_1, "t_disc", T("npcteam_desc_2"))
	end
	
	if_set_visible(arg_13_2.wnd, "n_team_info", arg_13_2.npcteam_id)
	if_set_visible(arg_13_2.wnd, "btn_difficulty_select", arg_13_2.is_difficulty and not arg_13_2.npcteam_id)
	if_set_visible(arg_13_2.wnd, "base_pet", arg_13_2.is_enable_pet and not arg_13_2.npcteam_id)
	
	if arg_13_2.npcteam_id then
		local var_13_2 = arg_13_2.wnd:getChildByName("n_team_info")
		
		if get_cocos_refid(var_13_2) then
			local var_13_3 = DB("level_monstergroup_npcteam", arg_13_2.npcteam_id, "team_title")
			
			if_set(var_13_2, "t_name", T(var_13_3))
			
			local var_13_4 = var_13_2:getChildByName("t_name")
			local var_13_5 = var_13_2:getChildByName("t_disc")
			
			if get_cocos_refid(var_13_4) and get_cocos_refid(var_13_5) then
				if var_13_4:getStringNumLines() == 1 and not var_13_5.origin_y then
					var_13_5.origin_y = var_13_5:getPositionY()
					
					var_13_5:setPositionY(var_13_5.origin_y + 24)
				end
				
				if arg_13_2.npc_text_change then
					if_set(var_13_5, nil, T("npcteam_onetime_desc"))
				end
			end
		end
	end
	
	if_set_visible(arg_13_2.wnd, "n_sinsu_cant", arg_13_2.sinsu_block)
	
	return arg_13_1
end

function Formation.isEnablePet(arg_15_0)
	return arg_15_0.opts.is_enable_pet and not arg_15_0.opts.npcteam_id
end

function Formation.updateTeamPoint(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_3 = arg_16_3 or {}
	
	if arg_16_2 or arg_16_3.is_nullable_supporter then
		arg_16_0.vars.supporter = arg_16_2
	end
	
	local var_16_0 = TeamUtil:getTeamPoint(arg_16_0.vars.team_idx, arg_16_0.vars.supporter, {
		formation = true,
		team = arg_16_1,
		no_summon = arg_16_3.no_summon
	})
	
	if arg_16_0.vars.point ~= var_16_0 then
		if get_cocos_refid(arg_16_0.vars.form_node) then
			local var_16_1 = arg_16_0.vars.form_node:getChildByName("txt_point")
			
			if arg_16_0.vars.is_automaton then
				var_16_1 = arg_16_0.vars.form_node:getChildByName("txt_point_automtn_my") or arg_16_0.vars.form_node:getChildByName("txt_point")
				
				local var_16_2 = Account:getTeam(arg_16_0.vars.team_idx)
				
				if var_16_2 and not table.empty(var_16_2) then
					for iter_16_0, iter_16_1 in pairs(var_16_2) do
						var_16_0 = var_16_0 + AutomatonUtil:getUserDevicePoint(iter_16_1)
					end
				end
			end
			
			if var_16_1 then
				arg_16_0.vars.point = arg_16_0.vars.point or 0
				
				if UnitMain.vars and UnitMain:getMode() == "Main" then
					UIAction:Add(INC_NUMBER(400, var_16_0, nil, arg_16_0.vars.point), var_16_1)
				else
					if_set(arg_16_0.vars.form_node, "txt_point", comma_value(var_16_0))
					if_set(arg_16_0.vars.form_node, "txt_point_automtn_my", comma_value(var_16_0))
				end
			end
			
			arg_16_0:callback("UpdatePoint", {
				wnd = arg_16_0.vars.form_node,
				team_idx = arg_16_0.vars.team_idx,
				pre = arg_16_0.vars.point,
				cur = var_16_0
			})
		end
		
		arg_16_0.vars.point = var_16_0
	end
	
	if arg_16_0.vars.req_point and arg_16_0.vars.req_point > 0 then
		if_set(arg_16_0.vars.form_node, "txt_recom", comma_value(arg_16_0.vars.req_point))
		
		if arg_16_0.opts and arg_16_0.opts.npcteam_id then
			if_set_visible(arg_16_0.vars.form_node, "compare_up", true)
			if_set_visible(arg_16_0.vars.form_node, "compare_ok", false)
			if_set_visible(arg_16_0.vars.form_node, "compare_down", false)
		else
			if_set_visible(arg_16_0.vars.form_node, "compare_up", arg_16_0.vars.point > arg_16_0.vars.req_point * 1.2)
			if_set_visible(arg_16_0.vars.form_node, "compare_ok", arg_16_0.vars.point <= arg_16_0.vars.req_point * 1.2 and arg_16_0.vars.point >= arg_16_0.vars.req_point * 0.8)
			if_set_visible(arg_16_0.vars.form_node, "compare_down", arg_16_0.vars.point < arg_16_0.vars.req_point * 0.8)
		end
	else
		if_set_visible(arg_16_0.vars.form_node, "n_recom", false)
	end
	
	if arg_16_0.vars.is_automaton then
		if_set_visible(arg_16_0.vars.form_node, "n_recom", false)
		if_set(arg_16_0.vars.form_node, "txt_point_automtn_need", comma_value(arg_16_0.vars.req_point))
	end
	
	local var_16_3 = BossGuide:hasGuide(arg_16_0.vars.enter_id)
	
	if_set_visible(arg_16_0.vars.form_node, "n_boss_guide", var_16_3)
	
	if var_16_3 then
		local var_16_4 = arg_16_0.vars.form_node:getChildByName("n_recom")
		
		if var_16_4 then
			var_16_4:setPositionX(arg_16_0.vars.form_node:getChildByName("n_boss_guide"):getPositionX() - 160)
		end
	end
end

function Formation.adjustNodeOnDifficulty(arg_17_0)
	local var_17_0 = arg_17_0.vars.form_node:getChildByName("base_sinsu")
	local var_17_1 = arg_17_0.vars.form_node:getChildByName("base_support")
	local var_17_2 = arg_17_0.vars.form_node:getChildByName("base_pet")
	local var_17_3 = arg_17_0.vars.form_node:getChildByName("n_difficulty_sinsu_pos")
	local var_17_4 = arg_17_0.vars.form_node:getChildByName("n_difficulty_team_support_pos")
	local var_17_5 = arg_17_0.vars.form_node:getChildByName("n_difficulty_pet_pos")
	
	var_17_0:setPosition(var_17_3:getPosition())
	var_17_1:setPosition(var_17_4:getPosition())
	var_17_2:setPosition(var_17_5:getPosition())
	arg_17_0:_movePosByPetContentState()
end

function Formation._movePosByPetContentState(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.form_node) then
		return 
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
		local var_18_0 = arg_18_0.vars.form_node:getName() or " "
		local var_18_1 = arg_18_0.vars.form_node:getChildByName("n_sinsu")
		local var_18_2 = arg_18_0.vars.form_node:getChildByName("n_fix")
		local var_18_3 = arg_18_0.vars.form_node:getChildByName("base_sinsu")
		local var_18_4 = arg_18_0.vars.form_node:getChildByName("base_support")
		local var_18_5 = arg_18_0.vars.form_node:getChildByName("btn_difficulty_select")
		
		if arg_18_0.opts and arg_18_0.opts.lobbyTeam and var_18_0 == "unit_team_formation" and get_cocos_refid(var_18_1) and get_cocos_refid(var_18_2) then
			var_18_1:setPositionY(305)
			var_18_2:setPositionY(289)
		elseif var_18_0 == "formation" and get_cocos_refid(var_18_3) and get_cocos_refid(var_18_4) and get_cocos_refid(var_18_5) and not arg_18_0.opts.sinsu_only and not DungeonHell:isAbyssHardMap(arg_18_0.vars.enter_id) then
			var_18_3:setPositionY(-37)
			var_18_4:setPositionY(84)
			var_18_5:setPositionY(483)
		end
	end
end

function Formation.updateDiffculty(arg_19_0, arg_19_1)
	if arg_19_1 then
		local var_19_0 = arg_19_0.vars.form_node:getChildByName("btn_difficulty_select")
		local var_19_1 = {
			"ui_battle_ready_difficulty_easy",
			"ui_battle_ready_difficulty_normal",
			"ui_battle_ready_difficulty_hard",
			"ui_battle_ready_difficulty_hell"
		}
		
		if_set(var_19_0, "label", T(var_19_1[arg_19_1 + 1]))
		if_set_visible(var_19_0, "n_select_bg", true)
		if_set_sprite(var_19_0, "n_select_bg", "img/_cm_difficulty0" .. arg_19_1 + 1 .. "_b.png")
		
		for iter_19_0 = 1, 4 do
			if_set_visible(var_19_0, tostring(iter_19_0), arg_19_1 + 1 == iter_19_0)
		end
		
		arg_19_0:adjustNodeOnDifficulty()
	end
end

function Formation.updatePenguinBonus(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.form_node) or not arg_20_0.opts or not arg_20_0.vars.enter_id then
		return 
	end
	
	if_set_visible(arg_20_0.vars.form_node, "btn_penguin", false)
	
	if arg_20_0.opts.npcteam_id or arg_20_0.opts.is_descent or arg_20_0.opts.is_burning then
		return 
	end
	
	if not UnlockSystem:isUnlockSystem("system_142") then
		return 
	end
	
	local var_20_0 = DB("level_enter", arg_20_0.vars.enter_id, {
		"contents_type"
	})
	
	if not var_20_0 or var_20_0 ~= "substory" and var_20_0 ~= "adventure" then
		return 
	end
	
	local var_20_1 = arg_20_1 or Account:getTeam(arg_20_0.vars.team_idx)
	
	if not var_20_1 or table.empty(var_20_1) then
		return 
	end
	
	arg_20_0.vars.is_max_level_exist = false
	
	for iter_20_0, iter_20_1 in pairs(var_20_1) do
		if iter_20_1:getLv() == iter_20_1:getMaxLevel() then
			arg_20_0.vars.is_max_level_exist = true
			
			break
		end
	end
	
	if_set_visible(arg_20_0.vars.form_node, "btn_penguin", true)
	if_set_opacity(arg_20_0.vars.form_node, "btn_penguin", arg_20_0.vars.is_max_level_exist and 255 or 76.5)
end

function Formation.updateTeamArtifactBonus(arg_21_0, arg_21_1)
	if not arg_21_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_21_0.vars.form_node) then
		return 
	end
	
	arg_21_1 = arg_21_1 or Account:getTeam(arg_21_0.vars.team_idx)
	
	local var_21_0 = arg_21_0.vars.form_node:getChildByName("btn_bonus")
	
	if not get_cocos_refid(var_21_0) then
		return 
	end
	
	local var_21_1 = Team:getGrowthBonusArtifactsCount(arg_21_1, arg_21_0.vars.level_type) + Team:getSubStoryCurrencyBonusArtifactsCount(arg_21_1, SubstoryManager:getArtifactBonusInfo(), arg_21_0.vars.enter_id)
	
	if var_21_1 == 0 then
		if_set_opacity(var_21_0, nil, 102)
		if_set_opacity(var_21_0, "img", 255)
		if_set_opacity(var_21_0, "icon_order", 255)
		if_set(var_21_0, "txt_booster_cnt", "")
		if_set_visible(var_21_0, "n_cnt", false)
		if_set_color(var_21_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	local var_21_2 = Team:getGrowthBonusApplyArtifactsCount(arg_21_1, arg_21_0.vars.level_type)
	local var_21_3 = Team:getSubStoryCurrencyBonusApplyArtifactsCount(arg_21_1, SubstoryManager:getArtifactBonusInfo(), arg_21_0.vars.enter_id) + var_21_2
	
	if var_21_3 == 0 then
		if_set_opacity(var_21_0, nil, 255)
		if_set_opacity(var_21_0, "img", 102)
		if_set_opacity(var_21_0, "icon_order", 102)
		if_set_visible(var_21_0, "n_cnt", false)
		if_set_visible(var_21_0, "n_cnt_off", true)
		if_set(var_21_0:getChildByName("n_cnt_off"), "txt_booster_cnt", "+" .. var_21_1)
		if_set_color(var_21_0, "icon_order", cc.c3b(255, 255, 255))
		
		return 
	end
	
	if_set_opacity(var_21_0, nil, 255)
	if_set_opacity(var_21_0, "img", 255)
	if_set_opacity(var_21_0, "icon_order", 255)
	if_set_visible(var_21_0, "n_cnt", true)
	if_set(var_21_0:getChildByName("n_cnt"), "txt_booster_cnt", "+" .. var_21_3)
	if_set_visible(var_21_0, "n_cnt_off", false)
	if_set_color(var_21_0, "icon_order", cc.c3b(255, 120, 0))
end

function Formation.getDecideTeam(arg_22_0, arg_22_1)
	local var_22_0
	
	if arg_22_0.vars.pvp_info and arg_22_0.vars.pvp_info.defend_mode then
		arg_22_1 = 11
	end
	
	if arg_22_0.vars.is_coop then
		local var_22_1 = Account:getCoopReservedTeamSlot()
		
		arg_22_1 = arg_22_1 or arg_22_0.vars.team_idx
		
		if not table.find(var_22_1, arg_22_1) then
			arg_22_1 = var_22_1[1]
		end
	end
	
	if arg_22_0.vars.is_automaton or arg_22_0.vars.is_crehunt then
		arg_22_1 = arg_22_0.vars.team_idx
	end
	
	if type(arg_22_1) == "table" then
		arg_22_0.vars.custom_team = arg_22_1
		var_22_0 = arg_22_0.vars.custom_team
	else
		arg_22_0.vars.team_idx = arg_22_1 or arg_22_0.vars.team_idx or Account:getCurrentTeamIndex()
		var_22_0 = Account:getTeam(arg_22_0.vars.team_idx)
	end
	
	if arg_22_0.vars.is_automaton and not table.empty(var_22_0) and type(arg_22_1) == "number" then
		var_22_0 = arg_22_0:checkAutomatonHP(var_22_0, arg_22_1)
	end
	
	return var_22_0
end

function Formation.checkAutomatonHP(arg_23_0, arg_23_1, arg_23_2)
	for iter_23_0, iter_23_1 in pairs(arg_23_1) do
		if iter_23_1:getAutomatonHPRatio() <= 0 then
			print("automaton hp 0 unit", iter_23_1:getName())
		end
	end
	
	return arg_23_1
end

function Formation.updateFormation(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars then
		return 
	end
	
	local var_24_0 = arg_24_0:getDecideTeam(arg_24_1)
	
	for iter_24_0 = 1, arg_24_0.vars.base_count do
		arg_24_0:setModelTo(iter_24_0, var_24_0[iter_24_0], arg_24_2)
	end
	
	if arg_24_0:isEnablePet() then
		arg_24_0:setPetModelTo(var_24_0[PET_TEAM_IDX])
	end
	
	arg_24_0:update_repeatCount(arg_24_0.vars.form_node, var_24_0[PET_TEAM_IDX])
	if_set_visible(arg_24_0.vars.form_node, "base_sinsu", arg_24_1 ~= 11 and not arg_24_0.opts.sinsu_block and arg_24_0.opts.pvp_info == nil and not arg_24_0.opts.is_coop and not arg_24_0.opts.is_automaton)
	
	if not arg_24_0.vars.ignore_team_selector then
		FormationTeamSelector:updateTeamInfo()
		
		if arg_24_0.updateLobbyTeamCheckbox then
			arg_24_0:updateLobbyTeamCheckbox()
		end
	end
	
	arg_24_0:updateTeamPoint(var_24_0, nil, {
		no_summon = arg_24_0.opts.sinsu_block
	})
	arg_24_0:updateTeamArtifactBonus(var_24_0)
	arg_24_0:updatePenguinBonus(var_24_0)
	arg_24_0:updateProgressingUnit()
	
	if arg_24_0.opts.show_role_info then
		for iter_24_1 = 1, arg_24_0.vars.base_count do
			local var_24_1 = arg_24_0.vars.form_node:getChildByName("info" .. iter_24_1)
			local var_24_2 = var_24_0[iter_24_1]
			
			if var_24_1 and var_24_2 then
				if_set_sprite(var_24_1, "role", "img/cm_icon_role_" .. var_24_2.db.role .. ".png")
				if_set_visible(var_24_1, "n_role", true)
			elseif var_24_1 then
				if_set_visible(var_24_1, "n_role", false)
			end
		end
	end
	
	if arg_24_0.vars.team_idx ~= 12 then
		if_set_visible(arg_24_0.vars.form_node, "n_none_pet", var_24_0[PET_TEAM_IDX] == nil)
		if_set_visible(arg_24_0.vars.form_node, "icon_pow", var_24_0[PET_TEAM_IDX] ~= nil)
		if_set_visible(arg_24_0.vars.form_node, "n_none_sinsu", var_24_0[5] == nil)
		if_set_visible(arg_24_0.vars.form_node, "icon_sinsuadd", var_24_0[5] == nil)
		
		if get_cocos_refid(arg_24_0.vars.form_node) then
			local var_24_3 = arg_24_0.vars.form_node:getChildByName("base_sinsu")
			
			if_set_visible(var_24_3, "kind", var_24_0[5] == nil)
		end
		
		if_set_visible(arg_24_0.vars.form_node, "icon_spritanimal", var_24_0[5] ~= nil)
		BattleRepeat:set_checkBox(var_24_0[7] ~= nil)
		
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
			if_set_visible(arg_24_0.vars.form_node, "n_pet", false)
		end
	end
	
	if DungeonHell:isAbyssHardMap(arg_24_0.vars.enter_id) then
		if_set_visible(arg_24_0.vars.form_node, "n_abyss_challenge_info", true)
		
		local var_24_4 = arg_24_0.vars.form_node:getChildByName("n_sinsu_only_move")
		
		arg_24_0.vars.form_node:getChildByName("n_sinsu_only"):setPosition(var_24_4:getPositionX(), var_24_4:getPositionY())
	end
	
	local var_24_5
	
	if get_cocos_refid(arg_24_0.vars.form_node) then
		var_24_5 = arg_24_0.vars.form_node:getChildByName("key_slot")
		
		if get_cocos_refid(var_24_5) and arg_24_0.vars.key_slot_idx then
			for iter_24_2 = 1, 4 do
				local var_24_6 = "base" .. iter_24_2
				local var_24_7 = var_24_5:getChildByName(var_24_6)
				
				if get_cocos_refid(var_24_7) then
					var_24_7:setVisible(iter_24_2 == arg_24_0.vars.key_slot_idx)
				end
			end
		end
	end
	
	arg_24_0:change_buttonImg(arg_24_0.vars.form_node)
	arg_24_0:callback("UpdateFormation", var_24_0)
end

function Formation.getBattleTeam(arg_25_0, arg_25_1)
	if not arg_25_1 and not arg_25_0.vars then
		return 
	end
	
	local var_25_0
	local var_25_1 = arg_25_1 or arg_25_0.vars.team_idx
	
	if type(var_25_1) == "table" then
		local var_25_2 = Team:makeTeamData(var_25_1)
		
		var_25_0 = Team:makeTeam(var_25_2)
	else
		var_25_0 = Account:getBattleTeam(var_25_1)
	end
	
	return var_25_0
end

function Formation.getFormation_wnd(arg_26_0)
	if not arg_26_0.vars then
		return 
	end
	
	return arg_26_0.vars.formation_wnd
end

function Formation.change_buttonImg(arg_27_0, arg_27_1, arg_27_2)
	if not get_cocos_refid(arg_27_1) then
		return 
	end
	
	local var_27_0 = arg_27_1
	
	if arg_27_1:getName() ~= "n_btn_dedi" then
		var_27_0 = arg_27_1:getChildByName("n_btn_dedi")
	end
	
	if not get_cocos_refid(var_27_0) and arg_27_0.opts and arg_27_0.opts.is_burning then
		var_27_0 = arg_27_1:getChildByName("btn_dedi")
	end
	
	if not get_cocos_refid(var_27_0) then
		return 
	end
	
	local var_27_1
	
	if arg_27_2 then
		var_27_1 = arg_27_0:getBattleTeam(arg_27_2)
	elseif arg_27_0.vars then
		var_27_1 = arg_27_0:getBattleTeam(arg_27_0.vars.team_idx)
	else
		var_27_1 = Account:getBattleTeam()
	end
	
	if not var_27_1 then
		return 
	end
	
	local var_27_2 = var_27_1:getDevoteStats()
	local var_27_3 = {}
	local var_27_4 = ""
	
	for iter_27_0, iter_27_1 in pairs(var_27_2) do
		local var_27_5 = false
		
		for iter_27_2, iter_27_3 in pairs(iter_27_1) do
			if iter_27_3.stat > 0 then
				var_27_5 = true
			end
		end
		
		if var_27_5 then
			table.insert(var_27_3, iter_27_0)
		end
	end
	
	table.sort(var_27_3, function(arg_28_0, arg_28_1)
		return arg_28_0 < arg_28_1
	end)
	
	for iter_27_4, iter_27_5 in pairs(var_27_3) do
		var_27_4 = var_27_4 .. iter_27_5
	end
	
	if var_27_4 == "" or arg_27_0.opts and arg_27_0.opts.npcteam_id then
		var_27_4 = 0
	end
	
	local var_27_6 = string.format("img/hero_dedi_p_%s.png", var_27_4)
	
	if_set_sprite(var_27_0, "icon", var_27_6)
end

function Formation.getFormation_icon(arg_29_0, arg_29_1)
	local var_29_0 = string.split(devotion_skill_slot, ";")
	local var_29_1 = ""
	
	for iter_29_0, iter_29_1 in pairs(var_29_0) do
		var_29_1 = var_29_1 .. (iter_29_1 or "")
	end
	
	local var_29_2 = string.format("img/hero_dedi_p_%s.png", var_29_1)
	
	if_set_sprite(n_icon, nil, var_29_2)
end

function Formation.setTeam(arg_30_0, arg_30_1)
	if not tonumber(arg_30_1) then
		return 
	end
	
	local var_30_0 = arg_30_0.vars.team_idx
	
	if arg_30_1 == var_30_0 then
		return 
	end
	
	set_high_fps_tick()
	
	if arg_30_0.vars.is_coop then
		CoopUtil:saveTeamIdx(CoopMission:getCurrentBossCode(), arg_30_1)
	else
		arg_30_1 = arg_30_0:getTeamIndex(arg_30_1)
		
		Account:selectTeam(arg_30_1)
	end
	
	arg_30_0:updateFormation(arg_30_1, var_30_0)
	SoundEngine:play("event:/unit_team/change_team")
end

function Formation.callback(arg_31_0, arg_31_1, ...)
	local var_31_0 = "callback" .. arg_31_1
	
	if arg_31_0.opts[var_31_0] then
		arg_31_0.opts[var_31_0](...)
	end
end

function Formation.updateHeroTags(arg_32_0)
	for iter_32_0 = 1, arg_32_0.vars.base_count do
		if arg_32_0.vars.model_ids[iter_32_0] and arg_32_0.vars.model_ids[iter_32_0].unit then
			arg_32_0:updateHeroTag(iter_32_0, arg_32_0.vars.model_ids[iter_32_0].unit)
		end
	end
end

function Formation.updateProgressingUnit(arg_33_0)
	if not arg_33_0.vars or not arg_33_0.vars.model_ids then
		return 
	end
	
	if not get_cocos_refid(arg_33_0.vars.form_node) then
		return 
	end
	
	for iter_33_0 = 1, arg_33_0.vars.base_count do
		local var_33_0
		
		if arg_33_0.vars.model_ids[iter_33_0] then
			var_33_0 = arg_33_0.vars.model_ids[iter_33_0].unit
		end
		
		if not arg_33_0.opts.disable_hp_info and var_33_0 then
			local var_33_1 = arg_33_0.vars.form_node:getChildByName("info" .. iter_33_0)
			
			if var_33_1 then
				local var_33_2 = var_33_1:getChildByName("n_hp_pos"):getChildByName("n_heal")
				
				if var_33_2 then
					if arg_33_0.vars.is_automaton then
						local var_33_3 = var_33_0:getAutomatonHPRatio()
						
						var_33_2:setVisible(var_33_3 < 1000)
					elseif var_33_2:isVisible() and UIUtil:updateEatingEndTime(var_33_1, var_33_0, {
						short = true
					}) == 0 then
						arg_33_0:updateHeroTag(iter_33_0, var_33_0)
					end
				end
				
				local var_33_4 = arg_33_0.vars.form_node:getChildByName("n_eat" .. iter_33_0)
				
				if get_cocos_refid(var_33_4) then
					if_set_visible(arg_33_0.vars.form_node, "n_sick" .. iter_33_0, not var_33_0:isEating() and var_33_0:isGetInjured())
					var_33_4:setVisible(var_33_0:isEating())
				end
			end
		else
			if_set_visible(arg_33_0.vars.form_node, "n_eat" .. iter_33_0, false)
			if_set_visible(arg_33_0.vars.form_node, "n_sick" .. iter_33_0, false)
		end
	end
end

function Formation.getTeam(arg_34_0)
	return Account:getTeam(arg_34_0.vars.team_idx)
end

function Formation.getTeamIndex(arg_35_0, arg_35_1)
	if arg_35_0.vars.pvp_info and arg_35_0.vars.pvp_info.defend_mode then
		return 11
	end
	
	if arg_35_0.vars.formation_mode == "support" then
		return 12
	end
	
	if arg_35_0.vars.is_automaton then
		return Account:getAutomatonTeamIndex()
	end
	
	return arg_35_1 or arg_35_0.vars.team_idx
end
