function HANDLER.hero_config_dedication(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		closeHeroConfigDedication(arg_1_0)
	elseif string.starts(arg_1_1, "btn_memory_") or string.starts(arg_1_1, "btn_expand_") then
		local var_1_0 = tonumber(string.sub(arg_1_1, -1, -1)) or 0
		local var_1_1 = SceneManager:getRunningNativeScene():getChildByName("hero_config_dedication")
		local var_1_2
		
		if get_cocos_refid(var_1_1) and var_1_1.team_idx then
			var_1_2 = var_1_1:getTeamInfo(var_1_1.team_idx)
		end
		
		if not var_1_2 then
			return 
		end
		
		local var_1_3 = var_1_2[var_1_0]
		
		if not var_1_3 then
			return 
		end
		
		if var_1_3.is_draft_formation_unit then
			return 
		end
		
		if var_1_3 then
			DevoteTooltip:showDevoteDetail(var_1_3, SceneManager:getRunningNativeScene())
		end
	end
end

function closeHeroConfigDedication(arg_2_0)
	Formation:change_buttonImg(arg_2_0:getParent().formation_wnd, arg_2_0:getParent().team_idx)
	arg_2_0:getParent():removeFromParent()
	BackButtonManager:pop("hero_config_dedication")
end

FormationEditor = {}

function defaultFormationEditEventHandler(arg_3_0, arg_3_1)
	local var_3_0 = getParentWindow(arg_3_0).class
	
	if string.starts(arg_3_1, "btn_heal") then
		if var_3_0.opts and var_3_0.opts.is_automaton then
			var_3_0:onTouchAutomatonHeal(tonumber(string.sub(arg_3_1, -1, -1)))
		else
			var_3_0:onTouchHeal(tonumber(string.sub(arg_3_1, -1, -1)))
		end
		
		return 
	end
	
	if var_3_0.opts and var_3_0.opts.ui_handler then
		var_3_0.opts.ui_handler(arg_3_0, arg_3_1)
	end
	
	if arg_3_1 == "btn_sinsu" then
		if var_3_0.opts then
			if var_3_0.opts.sinsu_block then
				balloon_message_with_sound("ui_pvp_ready_formationinfor_label")
				
				return 
			elseif var_3_0.opts.npcteam_id then
				return 
			end
		end
		
		SummonUI:show(nil, var_3_0)
	end
	
	if arg_3_1 == "btn_pet" and var_3_0.opts then
		if not Account:isHaveBattlePets() then
			return 
		end
		
		if var_3_0:isEnablePet() and var_3_0.showPetSettingPopup then
			var_3_0:showPetSettingPopup()
			
			return 
		else
			return 
		end
	end
	
	if arg_3_1 == "btn_checkbox_g" then
		if var_3_0:isEnablePet() then
			BattleRepeat:toggle_repeatPlay()
		else
			balloon_message_with_sound("pet_ui_battle_no_repeat")
			
			return 
		end
	end
	
	if arg_3_1 == "btn_dedi" and var_3_0.showDedicationPopup then
		var_3_0:setNormalMode()
		var_3_0:showDedicationPopup(var_3_0.vars.formation_wnd)
	end
	
	if arg_3_1 == "btn_device_inven" then
		var_3_0:openMyDeviceInventory()
	end
	
	if var_3_0.vars.disabled then
		return 
	end
	
	if string.starts(arg_3_1, "btn_team_detail") then
		if ContentDisable:byAlias("hero") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		if var_3_0.onUnitDetail then
			var_3_0:setNormalMode()
			var_3_0:onUnitDetail(var_3_0.vars.model_ids[var_3_0.vars.selected_idx].unit)
		elseif var_3_0.opts and var_3_0.opts.use_detail and not UnitMain:isValid() and HeroBelt:CanUseMultipleInstance() then
			local var_3_1 = SceneManager:getCurrentSceneName()
			
			if var_3_1 ~= "battle" and var_3_1 ~= "lota" then
				var_3_0:setNormalMode()
				UnitMain:beginPopupMode({
					unit = var_3_0.vars.model_ids[var_3_0.vars.selected_idx].unit
				})
			end
		end
		
		return 
	end
	
	if arg_3_1 == "btn_add_team" then
		FormationTeamSelector:reqAddTeam()
		var_3_0:setNormalMode()
	end
	
	if arg_3_1 == "btn_hidden" then
		balloon_message_with_sound("notyet_dev")
	end
	
	if arg_3_1 == "btn_ignore" then
		var_3_0:setNormalMode()
	end
	
	if string.len(arg_3_1) == 4 and string.starts(arg_3_1, "btn") then
		var_3_0.vars.touched_base_idx = tonumber(string.sub(arg_3_1, -1, -1))
		
		return true
	end
	
	if string.starts(arg_3_1, "btn_change_") then
		var_3_0:onTouchPosition(tonumber(string.sub(arg_3_1, -1, -1)))
		
		return 
	end
	
	if string.starts(arg_3_1, "btn_remove") then
		var_3_0:removeUnitFromPos(var_3_0.vars.selected_idx)
		var_3_0:setNormalMode()
		
		return 
	end
	
	if getParentWindow(arg_3_0):getName() == "unit_team" and not FormationEditor:isNormalMode(var_3_0.vars.formation_status) then
		var_3_0:setNormalMode()
		
		return 
	end
	
	if arg_3_1 == "btn_auto_support" then
		Dialog:msgBox(T("autoset_support"), {
			yesno = true,
			handler = function()
				UnitSupport:setAutoSupport()
			end
		})
	end
	
	if arg_3_1 == "btn_fix" then
		var_3_0:toggleLobbyTeamCheckbox()
	end
	
	if arg_3_1 == "btn_boss_guide" and var_3_0.openBossGuide then
		var_3_0:openBossGuide()
	end
	
	if arg_3_1 == "btn_bulk_up" and var_3_0.openMultiPromote then
		var_3_0:openMultiPromote()
	end
end

function FormationEditor.initLobbyTeamCheckbox(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.formation_wnd) then
		return 
	end
	
	if_set_visible(arg_5_0.vars.formation_wnd, "n_fix", arg_5_0.vars.pvp_info == nil and not arg_5_0.vars.is_coop and not arg_5_0.vars.is_automaton)
	
	local var_5_0 = arg_5_0.vars.formation_wnd:getChildByName("n_fix")
	
	arg_5_0.vars.lobbyTeamCheckbox = var_5_0:getChildByName("check_box")
	
	arg_5_0.vars.lobbyTeamCheckbox:addEventListener(function()
		arg_5_0:toggleLobbyTeamCheckbox()
	end)
	
	local var_5_1 = arg_5_0:getTeamIndex()
	local var_5_2 = Account:getLobbyTeamIdx()
	
	arg_5_0.vars.lobbyTeamCheckbox:setSelected(var_5_1 == var_5_2)
	
	local var_5_3 = "ui_team_lobby_pin"
	
	if var_5_1 == var_5_2 then
		var_5_3 = "ui_team_lobby_pined"
	end
	
	if_set(arg_5_0.vars.formation_wnd, "text_pin", T(var_5_3))
end

function FormationEditor.updateLobbyTeamCheckbox(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.formation_wnd) or not get_cocos_refid(arg_7_0.vars.lobbyTeamCheckbox) then
		return 
	end
	
	local var_7_0 = arg_7_0:getTeamIndex()
	local var_7_1 = Account:getLobbyTeamIdx()
	local var_7_2 = "ui_team_lobby_pin"
	
	if var_7_0 == var_7_1 then
		arg_7_0.vars.lobbyTeamCheckbox:setSelected(true)
		
		var_7_2 = "ui_team_lobby_pined"
	else
		arg_7_0.vars.lobbyTeamCheckbox:setSelected(false)
	end
	
	if_set(arg_7_0.vars.formation_wnd, "text_pin", T(var_7_2))
end

function FormationEditor.toggleLobbyTeamCheckbox(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.formation_wnd) or not get_cocos_refid(arg_8_0.vars.lobbyTeamCheckbox) then
		return 
	end
	
	local var_8_0 = arg_8_0:getTeamIndex()
	local var_8_1 = Account:getLobbyTeamIdx()
	local var_8_2 = "ui_team_lobby_pin"
	
	if var_8_0 == var_8_1 then
		Account:setLobbyTeamIdx(0)
		arg_8_0.vars.lobbyTeamCheckbox:setSelected(false)
	else
		Account:setLobbyTeamIdx(var_8_0)
		arg_8_0.vars.lobbyTeamCheckbox:setSelected(true)
		
		var_8_2 = "ui_team_lobby_pined"
	end
	
	FormationTeamSelector:updateTeamInfo()
	if_set(arg_8_0.vars.formation_wnd, "text_pin", T(var_8_2))
end

function FormationEditor.addFormationUpdateLuaEvent(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or ""
	
	local var_9_0 = arg_9_0.vars.formation_wnd
	
	if not get_cocos_refid(arg_9_0.vars.formation_wnd) then
		var_9_0 = arg_9_0.vars._event_listener_wnd
	end
	
	arg_9_0._formation_event_uid = tostring(get_cocos_refid(var_9_0)) .. arg_9_1
	
	LuaEventDispatcher:addEventListener("formation.res", LISTENER(function(arg_10_0, arg_10_1, arg_10_2)
		if not arg_10_0 or not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.formation_wnd) and not get_cocos_refid(arg_10_0.vars._event_listener_wnd) then
			LuaEventDispatcher:delayRemoveEventListenerByKey(arg_10_0._formation_event_uid)
			
			arg_10_0._formation_event_uid = nil
			
			return 
		end
		
		if arg_10_0.vars.is_enemy then
			return 
		end
		
		if arg_10_1 == "inventory.update" then
			if arg_10_0.vars.onFormationResEvent_UpdateTeamPoint then
				arg_10_0.vars.onFormationResEvent_UpdateTeamPoint()
			else
				if not arg_10_0.getDecideTeam then
					return 
				end
				
				local var_10_0 = arg_10_0:getDecideTeam()
				
				if not var_10_0 then
					return 
				end
				
				local var_10_1 = not arg_10_0.opts or not arg_10_0.opts.npcteam_id
				local var_10_2
				
				if arg_10_0.opts and arg_10_0.opts.sinsu_block then
					var_10_2 = true
				end
				
				if arg_10_0.updateTeamPoint and var_10_1 then
					arg_10_0:updateTeamPoint(var_10_0, nil, {
						no_summon = var_10_2
					})
				end
				
				if arg_10_0.updateTeamArtifactBonus and var_10_1 then
					arg_10_0:updateTeamArtifactBonus(var_10_0)
				end
			end
		end
		
		local function var_10_3()
			if arg_9_0.opts and arg_9_0.opts.npcteam_id then
				return 
			end
			
			if arg_9_0.vars.onFormationResEvent_UpdateFormation then
				arg_9_0.vars.onFormationResEvent_UpdateFormation()
			elseif arg_10_0.updateFormation and arg_10_0.getTeamIndex then
				local var_11_0 = arg_10_0:getTeamIndex()
				
				if not var_11_0 then
					return 
				end
				
				arg_10_0:updateFormation(var_11_0)
			end
		end
		
		if arg_10_1 == "bistro.update" then
			var_10_3()
		end
		
		if arg_10_1 == "automaton_hp.update" then
			var_10_3()
		end
		
		if arg_10_1 == "unit_popup_detail.update" then
			var_10_3()
		end
	end, arg_9_0), arg_9_0._formation_event_uid)
end

function FormationEditor.initFormationEditor(arg_12_0, arg_12_1, arg_12_2)
	Formation:initFormation(arg_12_1, arg_12_2)
	copy_functions(FormationEditor, arg_12_1)
	
	arg_12_1.vars = arg_12_1.vars or {}
	arg_12_1.vars.formation_wnd = arg_12_2.wnd
	arg_12_2.wnd.class = arg_12_1
	
	if not arg_12_2.notUseTouchHandler then
		HANDLER[arg_12_2.wnd:getName()] = defaultFormationEditEventHandler
		
		Scheduler:removeByName("FormationEditor_Scheduler")
		Scheduler:add(arg_12_2.wnd, arg_12_1.procTouchUnit, arg_12_1):setName("FormationEditor_Scheduler")
	end
	
	if arg_12_2.lobbyTeam and not arg_12_2.pvp_info then
		arg_12_1:initLobbyTeamCheckbox()
	end
	
	local var_12_0
	
	if arg_12_2.pvp_info or arg_12_2.map_id then
		if arg_12_2.pvp_info then
			local var_12_1 = "pvp001"
		elseif arg_12_2.map_id then
			local var_12_2 = arg_12_2.map_id
		end
	end
	
	arg_12_1:addFormationUpdateLuaEvent()
	arg_12_1:setNormalMode()
	
	local var_12_3 = arg_12_1.vars.formation_wnd:getChildByName("n_formation")
	
	if var_12_3 then
		if_set_visible(var_12_3, "t_pos1", false)
		if_set_visible(var_12_3, "t_pos2", false)
		if_set_visible(var_12_3, "t_pos3", false)
		if_set_visible(var_12_3, "t_pos4", false)
	end
	
	if arg_12_2.wnd and arg_12_2.npcteam_id then
		if_set_opacity(arg_12_2.wnd, "n_btn_dedi", 76.5)
	end
	
	if arg_12_2.is_coop or arg_12_2.is_automaton then
		if_set_visible(arg_12_2.wnd, "formation_infor", false)
	end
end

function FormationEditor.enableFormationEditMode(arg_13_0, arg_13_1)
	arg_13_0.vars.disabled = not arg_13_1
end

function FormationEditor.removeUnitFromPos(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0:getTeamIndex()
	local var_14_1 = arg_14_0.vars.least_unit or 1
	
	if arg_14_0.vars.formation_mode ~= "support" and var_14_1 >= Account:getTeamMemberCount(var_14_0, true) and arg_14_1 ~= 5 then
		balloon_message_with_sound("form_need")
		
		return 
	end
	
	local var_14_2 = arg_14_0.vars.model_ids[arg_14_0.vars.selected_idx].unit
	
	arg_14_0.vars.formation_dirty = true
	
	vibrate(VIBRATION_TYPE.Select)
	Account:removeFromTeam(var_14_2, var_14_0, arg_14_1)
	arg_14_0:updateFormation()
end

function FormationEditor.getUnitByPos(arg_15_0, arg_15_1)
	if not arg_15_0.vars.model_ids[arg_15_1] then
		return 
	end
	
	return arg_15_0.vars.model_ids[arg_15_1].unit
end

function FormationEditor.getFreePos(arg_16_0, arg_16_1)
	local var_16_0
	local var_16_1 = {
		1,
		3,
		2,
		4,
		5,
		6,
		7
	}
	
	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		if arg_16_0:isPlacablePos(arg_16_1, iter_16_1) and arg_16_0.vars.model_ids[iter_16_1] == nil then
			var_16_0 = iter_16_1
			
			break
		end
	end
	
	return {
		var_16_0
	}
end

function FormationEditor.isPlacablePos(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2 > arg_17_0.vars.placable_base_count then
		return false
	end
	
	if arg_17_1:isSummon() then
		return arg_17_0.vars.team_idx <= 10 and arg_17_2 == 5
	end
	
	if arg_17_0.vars.formation_mode == "support" then
		if arg_17_2 == 2 and arg_17_1.db.role ~= "warrior" then
			return false
		end
		
		if arg_17_2 == 3 and arg_17_1.db.role ~= "knight" then
			return false
		end
		
		if arg_17_2 == 4 and arg_17_1.db.role ~= "assassin" then
			return false
		end
		
		if arg_17_2 == 5 and arg_17_1.db.role ~= "ranger" then
			return false
		end
		
		if arg_17_2 == 6 and arg_17_1.db.role ~= "mage" then
			return false
		end
		
		if arg_17_2 == 7 and arg_17_1.db.role ~= "manauser" then
			return false
		end
	end
	
	if arg_17_0.vars.team_idx <= 10 then
	end
	
	return true
end

function FormationEditor.onAddUnit(arg_18_0, arg_18_1)
	if DEBUG.OLD_PROMOTION_RULE and arg_18_1.db.role == "material" then
		balloon_message_with_sound("role_material_none")
		
		return 
	end
	
	if not arg_18_1:isOrganizable() then
		balloon_message_with_sound("cant_form_unit")
		
		return 
	end
	
	TutorialGuide:procGuide()
	arg_18_0:setNormalMode(true)
	
	if Account:isInTeam(arg_18_1, arg_18_0.vars.team_idx) then
		balloon_message_with_sound("already_in_team")
		
		return false
	end
	
	if arg_18_0.vars.formation_mode == "pvp" and arg_18_0.vars.pvp_info and arg_18_0.vars.pvp_info.defend_mode and arg_18_1:isLockArenaAndClan() then
		balloon_message_with_sound("character_mc_cannot_enter")
		
		return false
	end
	
	if arg_18_0.vars.formation_mode ~= "support" then
		if Account:haveSameVariationGroupInTeam(arg_18_1, arg_18_0.vars.team_idx) or Account:getTeamUnitPosByCode(arg_18_1.inst.code, arg_18_0.vars.team_idx) then
			arg_18_0:readyToSwapUnit(arg_18_1)
			
			return 
		end
	elseif not Account:getTeam(arg_18_0.vars.team_idx)[1] then
		arg_18_0.vars.pos = 1
		
		arg_18_0:changeUnit(arg_18_1)
		SoundEngine:play("event:/unit_team/add_unit")
		
		return 
	end
	
	arg_18_0:readyToSwapUnit(arg_18_1)
end

function FormationEditor.onAddSupportUnit(arg_19_0, arg_19_1)
end

function FormationEditor.onTouchHeal(arg_20_0, arg_20_1)
	Bistro:ReqFastHeal(arg_20_0.vars.model_ids[arg_20_1].unit)
end

function FormationEditor.onTouchAutomatonHeal(arg_21_0, arg_21_1)
	AutomatonUtil:unitResurrection(arg_21_0.vars.model_ids[arg_21_1].unit)
end

function FormationEditor.onTouchPosition(arg_22_0, arg_22_1)
	arg_22_0.vars.touched_model_idx = nil
	arg_22_0.vars.touched_base_idx = nil
	
	if arg_22_0:isNormalMode() then
		if arg_22_0.vars.model_ids[arg_22_1] then
			if not TutorialGuide:isAllowEvent(arg_22_0.vars.formation_wnd:getChildByName("btn" .. arg_22_1)) then
				return 
			end
			
			TutorialGuide:procGuide()
			arg_22_0:callback("SelectUnit", arg_22_0.vars.model_ids[arg_22_1].unit)
			arg_22_0:readyToChangeUnit(arg_22_1, arg_22_0.vars.model_ids[arg_22_1].unit)
		elseif arg_22_0.vars.is_guide_position then
			arg_22_0:callback("SelectEmptySlot", arg_22_1)
		else
			balloon_message_with_sound("form_hero")
		end
		
		return 
	end
	
	UIAction:Remove("dedication_effct")
	
	if arg_22_0.vars.formation_status == "ReadyToChangeUnit" then
		if not TutorialGuide:isAllowEvent(arg_22_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_22_1)) then
			return 
		end
		
		TutorialGuide:procGuide()
		
		if arg_22_0.vars.pos == arg_22_1 then
			arg_22_0:setNormalMode()
		elseif arg_22_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_22_1):isVisible() then
			arg_22_0:swapPosition(arg_22_0.vars.pos, arg_22_1)
		end
	end
	
	if arg_22_0.vars.formation_status == "ReadyToSwapUnit" then
		if not TutorialGuide:isAllowEvent(arg_22_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_22_1)) then
			return 
		end
		
		TutorialGuide:procGuide()
		
		if arg_22_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_22_1):isVisible() then
			arg_22_0:swapUnit(arg_22_0.vars.swap_unit, arg_22_1)
		end
	end
end

function FormationEditor.procTouchUnit(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if arg_23_0.vars.touched_model_idx then
		arg_23_0:onTouchPosition(arg_23_0.vars.touched_model_idx)
	elseif arg_23_0.vars.touched_base_idx then
		arg_23_0:onTouchPosition(arg_23_0.vars.touched_base_idx)
	end
end

function FormationEditor.setNormalMode(arg_24_0, arg_24_1)
	if arg_24_0:isNormalMode() then
		return 
	end
	
	if not get_cocos_refid(arg_24_0.vars.formation_wnd) then
		Log.e("formation_wnd is invalid!")
		
		return 
	end
	
	arg_24_0.vars.touched_model_idx = nil
	arg_24_0.vars.touched_base_idx = nil
	arg_24_0.vars.swap_unit = nil
	arg_24_0.vars.formation_status = "Normal"
	
	if arg_24_0.vars.is_guide_position then
		if not arg_24_1 then
			for iter_24_0 = 1, arg_24_0.vars.base_count do
				if Account:getTeam(arg_24_0.vars.team_idx)[iter_24_0] then
					local var_24_0 = arg_24_0.vars.formation_wnd:getChildByName("btn_change_" .. tostring(iter_24_0))
					
					if var_24_0 then
						var_24_0:loadTextures("img/hero_config_btn_change.png", "img/hero_config_btn_change.png", "img/hero_config_btn_change.png", 1)
						var_24_0:setVisible(false)
						arg_24_0:removeBtnGuideEffect(var_24_0, iter_24_0)
					end
				else
					local var_24_1 = arg_24_0.vars.formation_wnd:getChildByName("btn_change_" .. tostring(iter_24_0))
					
					if var_24_1 then
						var_24_1:loadTextures("img/hero_config_btn_add.png", "img/hero_config_btn_add.png", "img/hero_config_btn_add.png", 1)
						var_24_1:setVisible(true)
						var_24_1:setOpacity(229.5)
						arg_24_0:addBtnGuideEffect(var_24_1, iter_24_0)
					end
				end
			end
		end
	else
		for iter_24_1 = 1, arg_24_0.vars.base_count do
			if_set_visible(arg_24_0.vars.formation_wnd, "btn_change_" .. tostring(iter_24_1), false)
		end
	end
	
	if_set_visible(arg_24_0.vars.formation_wnd, "selected_btn", false)
	arg_24_0:removeModeEffects()
	
	if not arg_24_0.vars.dedi_eff_dirty then
		arg_24_0:removeDedicationEffect()
		if_set_visible(arg_24_0:getDediSlider(), nil, false)
		
		local var_24_2 = arg_24_0.vars.formation_wnd:getChildByName("@effect_notify")
		
		if get_cocos_refid(var_24_2) then
			var_24_2:removeFromParent()
		end
	end
	
	arg_24_0:callback("ChangeStatus", arg_24_0.vars.formation_status)
	
	arg_24_0.vars.dedi_eff_dirty = nil
end

function FormationEditor.changeUnit(arg_25_0, arg_25_1, arg_25_2)
	if Account:isTeamInSubtaskMission(arg_25_0.vars.team_idx) then
		balloon_message_with_sound("form_change")
		
		return 
	end
	
	if DEBUG.OLD_PROMOTION_RULE and arg_25_1.db.role == "material" then
		balloon_message_with_sound("role_material_none")
		
		return 
	end
	
	if not arg_25_1:isOrganizable() then
		balloon_message_with_sound("role_material_none")
		
		return 
	end
	
	if arg_25_1:isLockArenaAndClan() then
		balloon_message_with_sound("character_mc_cannot_enter")
		
		return 
	end
	
	local var_25_0 = Account:getTeamUnitPosByCode(arg_25_1.inst.code, arg_25_0.vars.team_idx)
	local var_25_1 = Account:getTeam(arg_25_0.vars.team_idx)[arg_25_0.vars.pos]
	
	if var_25_0 and var_25_0 ~= arg_25_0.vars.pos and not Account:isInTeam(arg_25_1, arg_25_0.vars.team_idx) then
		balloon_message_with_sound("form_same")
		
		return 
	end
	
	if Account:haveSameVariationGroupInTeam(arg_25_1, arg_25_0.vars.team_idx) then
		if var_25_1 then
			if var_25_1:isSameVariationGroupOnlyPlayer(arg_25_1) then
			else
				balloon_message_with_sound("form_moon")
				
				return 
			end
		else
			balloon_message_with_sound("form_moon")
			
			return 
		end
	end
	
	arg_25_0:swapUnit(arg_25_1, arg_25_0.vars.pos)
end

function FormationEditor.removeModeEffects(arg_26_0)
	if arg_26_0.vars.blinking_marks then
		for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.blinking_marks) do
			if get_cocos_refid(iter_26_1) then
				UIAction:Remove(iter_26_1)
				iter_26_1:removeFromParent()
			end
		end
		
		UIAction:Remove("team_ui.blink")
		
		arg_26_0.vars.blinking_marks = nil
	end
	
	for iter_26_2 = 1, arg_26_0.vars.base_count do
		if_set_visible(arg_26_0.vars.formation_wnd, "base" .. iter_26_2, true)
	end
end

function FormationEditor.setFormationEditMode(arg_27_0, arg_27_1)
	arg_27_0.vars.prevent_formation_edit = not arg_27_1
end

function FormationEditor.onHeroListEventForFormationEditor(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	BattleReady:showSimpleInfo(false)
	
	local var_28_0
	local var_28_1 = arg_28_0.opts and arg_28_0.opts.is_automaton
	local var_28_2 = arg_28_0.opts and arg_28_0.opts.is_lota
	local var_28_3 = arg_28_0.opts and arg_28_0.opts.is_unit_once
	
	if UnitMain:isValid() then
		var_28_0 = HeroBelt:getInst("UnitMain")
	else
		var_28_0 = HeroBelt:getInst()
	end
	
	if not arg_28_0.vars or arg_28_0.vars and arg_28_0.vars.prevent_formation_edit then
		local var_28_4 = var_28_0:getControl(arg_28_2)
		
		if var_28_4 then
			var_28_4:getChildByName("add"):setVisible(false)
			var_28_4:getChildByName("resurrection"):setVisible(false)
		end
		
		return 
	end
	
	if arg_28_1 == "select" and not UnitMain:isValid() and HeroBelt:CanUseMultipleInstance() then
		local var_28_5 = arg_28_3
		local var_28_6 = SceneManager:getCurrentSceneName()
		
		if var_28_6 ~= "battle" and var_28_5 and arg_28_0.vars.formation_status ~= "ReadyToSwapUnit" and arg_28_0.vars.formation_status ~= "ReadyToChangeUnit" then
			if var_28_6 == "lota" then
				LotaBattleReady:openHeroInfoUI({
					code = arg_28_2.inst.code
				})
				
				return 
			end
			
			if var_28_3 and Account:isMazeUsedUnit(arg_28_0.opts.map_id, arg_28_2:getUID()) then
				balloon_message_with_sound("msg_dungeon_challenge_claer_hero")
				
				return 
			end
			
			UnitMain:beginPopupMode({
				unit = arg_28_2
			})
			
			return 
		end
	end
	
	if arg_28_1 == "change" then
		local var_28_7 = var_28_0:getControl(arg_28_2)
		local var_28_8 = var_28_0:getControl(arg_28_3)
		
		if var_28_7 then
			var_28_7:getChildByName("add"):setVisible(false)
		end
		
		if var_28_8 then
			var_28_8:getChildByName("add"):setVisible(true)
		end
		
		if var_28_2 and var_28_8 and arg_28_3 and not LotaUserData:isUsableUnit(arg_28_3) then
			var_28_8:getChildByName("add"):setVisible(false)
		end
		
		if var_28_1 and var_28_8 and var_28_7 then
			if arg_28_3 and arg_28_3.getAutomatonHPRatio then
				local var_28_9 = arg_28_3:getAutomatonHPRatio()
				
				var_28_8:getChildByName("add"):setVisible(false)
				var_28_8:getChildByName("resurrection"):setVisible(var_28_9 <= 0)
			else
				var_28_8:getChildByName("resurrection"):setVisible(false)
			end
			
			if arg_28_3 and arg_28_3.getAutomatonHPRatio then
				var_28_7:getChildByName("resurrection"):setVisible(false)
			end
		end
		
		if var_28_3 and Account:isMazeUsedUnit(arg_28_0.opts.map_id, arg_28_3:getUID()) then
			var_28_8:findChildByName("add"):setVisible(false)
		end
		
		if var_28_0:isScrolling() then
			vibrate(VIBRATION_TYPE.Select)
		end
		
		if not arg_28_0:isNormalMode() then
			local function var_28_10()
				arg_28_0:setNormalMode()
				UIAction:Remove("dedication_effct")
				arg_28_0:removeDedicationEffect()
			end
			
			if arg_28_0.vars.formation_status == "ReadyToSwapUnit" then
				var_28_10()
			elseif arg_28_0.vars.formation_status == "ReadyToChangeUnit" and var_28_0:isPushed() then
				var_28_10()
			end
		end
	end
	
	if arg_28_1 == "add" then
		local var_28_11 = arg_28_0:isNormalMode()
		
		arg_28_0.vars.dedi_eff_dirty = not var_28_11
		
		local var_28_12 = arg_28_0:onAddUnit(arg_28_2)
		
		vibrate(VIBRATION_TYPE.Select)
		
		if var_28_11 or var_28_12 == false then
			arg_28_0:setDedicationNotify(arg_28_2)
		else
			local var_28_13, var_28_14 = arg_28_2:getDevoteSkill()
			
			if var_28_14 ~= 0 then
				arg_28_0:setDedicationDetail(arg_28_2)
			end
		end
	end
	
	if arg_28_1 == "highest_item" then
		local var_28_15 = var_28_0:getControl(arg_28_2)
		
		if var_28_15 then
			var_28_15:findChildByName("add"):setVisible(true)
			
			if var_28_1 and arg_28_2 and arg_28_2.getAutomatonHPRatio and arg_28_2:getAutomatonHPRatio() <= 0 then
				var_28_15:getChildByName("add"):setVisible(false)
				var_28_15:getChildByName("resurrection"):setVisible(true)
			end
			
			if var_28_2 and arg_28_2 and not LotaUserData:isUsableUnit(arg_28_2) then
				var_28_15:getChildByName("add"):setVisible(false)
			end
			
			if var_28_3 and Account:isMazeUsedUnit(arg_28_0.opts.map_id, arg_28_2:getUID()) then
				var_28_15:findChildByName("add"):setVisible(false)
			end
		end
	end
	
	if arg_28_1 == "resurrection" and var_28_1 then
		local var_28_16 = var_28_0:getControl(arg_28_2)
		
		if arg_28_2 and arg_28_2.getAutomatonHPRatio then
			AutomatonUtil:unitResurrection(arg_28_2)
		end
	end
end

function FormationEditor.setDedicationNotify(arg_30_0, arg_30_1, arg_30_2)
	UIAction:Remove("dedication_effct")
	
	local var_30_0 = arg_30_0:getDediSlider()
	
	if not get_cocos_refid(var_30_0) then
		return 
	end
	
	local var_30_1, var_30_2 = arg_30_1:getDevoteSkill()
	local var_30_3, var_30_4 = DB("character", arg_30_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	local var_30_5 = arg_30_2 or arg_30_0:isNormalMode()
	
	if var_30_2 == 0 or not var_30_3 or not var_30_4 or var_30_5 then
		arg_30_0:removeDedicationEffect()
		var_30_0:setVisible(false)
		
		return 
	end
	
	if var_30_0:isVisible() then
		arg_30_0:setDedicationDetail(arg_30_1)
	else
		local var_30_6 = var_30_0:getChildByName("@effect_notify")
		
		if get_cocos_refid(var_30_6) then
			var_30_6:removeFromParent()
		end
		
		local var_30_7 = var_30_0:getChildByName("bg")
		local var_30_8 = arg_30_0.vars.pvp_info and 1.05 or 1
		local var_30_9 = EffectManager:Play({
			fn = "ui_hero_config_buffbar.cfx",
			layer = var_30_7,
			pivot_x = var_30_7:getContentSize().width / 2 - 26,
			pivot_y = var_30_7:getContentSize().height / 2 + 3,
			scaleX = var_30_8
		})
		
		var_30_9:setName("@effect_notify")
		Scheduler:addSlow(var_30_9, function()
			set_high_fps_tick(1500)
		end)
		var_30_0:setPositionX(0)
		UIAction:Add(SEQ(SHOW(false), CALL(FormationEditor.setDedicationDetail, arg_30_0, arg_30_1), LOG(SLIDE_IN(400, 1200))), var_30_0, "dedication_notify")
	end
	
	arg_30_0:playDedicationEffect(arg_30_1)
end

function FormationEditor.removeDedicationEffect(arg_32_0, arg_32_1)
	if not get_cocos_refid(arg_32_0.vars.formation_wnd) then
		Log.e("formation_wnd is invalid")
		
		return 
	end
	
	local function var_32_0(arg_33_0, arg_33_1)
		local var_33_0 = arg_33_0:getChildByName(arg_33_1)
		
		if get_cocos_refid(var_33_0) then
			if arg_32_1 then
				stop_or_remove(var_33_0)
			else
				var_33_0:removeFromParent()
			end
		end
	end
	
	for iter_32_0 = 1, 4 do
		local var_32_1 = arg_32_0.vars.formation_wnd:getChildByName("pos" .. iter_32_0)
		
		if get_cocos_refid(var_32_1) then
			var_32_0(var_32_1, "@effect_front")
			var_32_0(var_32_1, "@effect_back")
		end
	end
end

function FormationEditor.playDediEffectAtBattleReady(arg_34_0, arg_34_1)
	for iter_34_0, iter_34_1 in pairs(arg_34_1) do
		local var_34_0 = arg_34_0.vars.formation_wnd:getChildByName("pos" .. iter_34_1)
		local var_34_1 = arg_34_0.vars.formation_wnd:getChildByName("base" .. iter_34_1)
		
		if var_34_0 and var_34_1 then
			set_high_fps_tick(5000)
			
			local var_34_2 = var_34_1:getPositionX() - var_34_0:getPositionX() - 4
			local var_34_3 = var_34_1:getPositionY() - var_34_0:getPositionY() - 4
			local var_34_4 = var_34_0:getScale()
			local var_34_5 = var_34_4 * (1.3 / var_34_4)
			local var_34_6 = EffectManager:Play({
				fn = "ui_hero_config_buffpos_front.cfx",
				pivot_z = 1,
				layer = var_34_0,
				pivot_x = var_34_2,
				pivot_y = var_34_3,
				scale = var_34_5
			})
			local var_34_7 = EffectManager:Play({
				fn = "ui_hero_config_buffpos_back.cfx",
				pivot_z = -1,
				layer = var_34_0,
				pivot_x = var_34_2,
				pivot_y = var_34_3,
				scale = var_34_5
			})
			
			var_34_6:setOpacity(110)
			var_34_7:setOpacity(150)
			var_34_6:setName("@effect_front")
			var_34_7:setName("@effect_back")
		end
	end
end

function FormationEditor.playDediEffectAtFormation(arg_35_0, arg_35_1)
	for iter_35_0, iter_35_1 in pairs(arg_35_1) do
		local var_35_0 = arg_35_0.vars.formation_wnd:getChildByName("pos" .. iter_35_1)
		
		if get_cocos_refid(var_35_0) then
			set_high_fps_tick(5000)
			
			local var_35_1 = arg_35_0.vars.pvp_info and 0.9 or 1.15
			
			if arg_35_0.vars.pvp_info and arg_35_0.vars.pvp_info.defend_mode then
				var_35_1 = 1.15
			end
			
			local var_35_2 = EffectManager:Play({
				pivot_x = 0,
				fn = "ui_hero_config_buffpos_front.cfx",
				pivot_y = -5,
				pivot_z = 1,
				layer = var_35_0,
				scale = var_35_1
			})
			local var_35_3 = EffectManager:Play({
				pivot_x = 0,
				fn = "ui_hero_config_buffpos_back.cfx",
				pivot_y = -5,
				pivot_z = -1,
				layer = var_35_0,
				scale = var_35_1
			})
			
			var_35_2:setOpacity(110)
			var_35_3:setOpacity(150)
			var_35_2:setName("@effect_front")
			var_35_3:setName("@effect_back")
		end
	end
end

function FormationEditor.playDedicationEffect(arg_36_0, arg_36_1)
	arg_36_0:removeDedicationEffect()
	
	local var_36_0, var_36_1 = arg_36_1:getDevoteSkill()
	local var_36_2, var_36_3 = DB("character", arg_36_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	
	if var_36_1 == 0 or not var_36_2 or not var_36_3 then
		return 
	end
	
	local var_36_4 = string.split(var_36_3, ";")
	
	if arg_36_1:getUnitOptionValue("imprint_focus") == 2 then
		var_36_4 = arg_36_0:change_position(arg_36_1, var_36_4)
	end
	
	if arg_36_0.opts.battle_ready_dedi_effect then
		arg_36_0:playDediEffectAtBattleReady(var_36_4)
	else
		arg_36_0:playDediEffectAtFormation(var_36_4)
	end
end

function FormationEditor.change_position(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_1 then
		return 
	end
	
	local var_37_0
	
	var_37_0 = arg_37_2 or {}
	
	local var_37_1 = Account:getTeamPos(arg_37_1, arg_37_0.vars.team_idx) or 0
	local var_37_2 = {}
	
	if var_37_1 then
		table.insert(var_37_2, var_37_1)
	else
		table.insert(var_37_2, 0)
	end
	
	return var_37_2
end

function FormationEditor.playBatchEffect(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0, var_38_1 = arg_38_1:getDevoteSkill()
	local var_38_2 = arg_38_1:getDevoteGrade()
	local var_38_3, var_38_4 = DB("character", arg_38_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	
	if var_38_1 == 0 or not var_38_3 or not var_38_4 then
		return 
	end
	
	local var_38_5 = string.split(var_38_4, ";")
	local var_38_6 = false
	
	if arg_38_1:getUnitOptionValue("imprint_focus") == 2 and arg_38_2 then
		var_38_6 = true
		var_38_5 = {}
		
		table.insert(var_38_5, arg_38_2)
	end
	
	for iter_38_0, iter_38_1 in pairs(var_38_5) do
		local var_38_7 = arg_38_0.vars.formation_wnd:getChildByName("pos" .. iter_38_1)
		
		if get_cocos_refid(var_38_7) then
			local var_38_8
			
			if type(arg_38_0.vars.team_idx) == "table" then
				var_38_8 = arg_38_0.vars.team_idx[tonumber(iter_38_1)]
			else
				var_38_8 = Account:getTeam(arg_38_0.vars.team_idx)[tonumber(iter_38_1)]
			end
			
			if var_38_8 and var_38_8 ~= arg_38_1 or var_38_6 then
				set_high_fps_tick(5000)
				
				local var_38_9 = arg_38_0.vars.pvp_info and 0.9 or 1.15
				local var_38_10 = EffectManager:Play({
					pivot_x = 0,
					fn = "ui_hero_config_buffset_front.cfx",
					pivot_y = -5,
					pivot_z = 1,
					layer = var_38_7,
					scale = var_38_9
				})
				local var_38_11 = EffectManager:Play({
					pivot_x = 0,
					fn = "ui_hero_config_buffset_back.cfx",
					pivot_y = -5,
					pivot_z = -1,
					layer = var_38_7,
					scale = var_38_9
				})
				
				var_38_10:setOpacity(110)
				var_38_11:setOpacity(150)
				
				local var_38_12 = var_38_7:getChildByName("t_pos" .. iter_38_1)
				
				if get_cocos_refid(var_38_12) then
					local var_38_13, var_38_14 = arg_38_1:getDevoteGrade()
					local var_38_15 = arg_38_1:getDevoteColor(var_38_13)
					
					if not var_38_12.origin_x then
						var_38_12.origin_x, var_38_12.origin_y = var_38_12:getPosition()
					end
					
					var_38_12:setPosition(var_38_12.origin_x, var_38_12.origin_y + 150)
					var_38_12:setVisible(true)
					var_38_12:setColor(var_38_15)
					var_38_12:setString(getStatName(var_38_0) .. " + " .. to_var_str(var_38_1, var_38_0, 1))
					var_38_12:setOpacity(255)
					var_38_12:setLocalZOrder(10000)
					
					local var_38_16, var_38_17 = var_38_7:getPosition()
					
					UIAction:Add(SEQ(SPAWN(SEQ(LOG(SCALE(200, 0.1, 1.2)), RLOG(SCALE(100, 1.2, 1))), LOG(MOVE_TO(150, var_38_12.origin_x, var_38_12.origin_y + arg_38_0:getModelHeight(tonumber(iter_38_1)) + 100))), DELAY(500), LOG(FADE_OUT(500)), SHOW(false)), var_38_12)
				end
			end
		end
	end
end

function FormationEditor.getDediSlider(arg_39_0)
	local var_39_0
	
	if arg_39_0.vars and get_cocos_refid(arg_39_0.vars.formation_wnd) then
		var_39_0 = arg_39_0.vars.formation_wnd:getChildByName("n_dedi_tooltip_slide")
	end
	
	if not get_cocos_refid(var_39_0) then
		var_39_0 = SceneManager:getRunningNativeScene():getChildByName("n_dedi_tooltip_slide")
	end
	
	return var_39_0
end

function FormationEditor.setDedicationDetail(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0:getDediSlider()
	
	if not var_40_0 then
		return 
	end
	
	UIUtil:setDevoteDetail_new(var_40_0, arg_40_1)
	
	local var_40_1, var_40_2 = arg_40_1:getDevoteSkill()
	local var_40_3, var_40_4 = DB("character", arg_40_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	
	if var_40_2 == 0 or not var_40_3 or not var_40_4 then
		if_set_visible(var_40_0, nil, false)
	end
	
	local var_40_5 = DB("character", arg_40_1:getDisplayCode(), {
		"face_id"
	}) or "no_image"
	
	if_set_sprite(var_40_0:getChildByName("circle_face_ally"), "face", "face/" .. var_40_5 .. "_s.png")
end

function FormationEditor.swapPosition(arg_41_0, arg_41_1, arg_41_2)
	if Account:isTeamInSubtaskMission(arg_41_0.vars.team_idx) then
		balloon_message_with_sound("form_change")
		
		return 
	end
	
	local var_41_0 = Account:getTeam(arg_41_0.vars.team_idx)[arg_41_1]
	
	if not var_41_0 then
		return 
	end
	
	vibrate(VIBRATION_TYPE.Select)
	
	if not TutorialGuide:isPlayingTutorial() and TutorialCondition:isEnable("system_059") then
		TutorialGuide:forceClearTutorials({
			"system_059"
		})
	end
	
	Account:addToTeam(var_41_0, arg_41_0.vars.team_idx, arg_41_2, true)
	
	arg_41_0.vars.formation_dirty = true
	
	arg_41_0:setNormalMode()
	arg_41_0:updateFormation()
	
	if arg_41_0.vars.team_idx ~= 12 then
		arg_41_0:playBatchEffect(var_41_0, arg_41_2)
	end
end

function FormationEditor.swapUnit(arg_42_0, arg_42_1, arg_42_2)
	if Account:isTeamInSubtaskMission(arg_42_0.vars.team_idx) then
		balloon_message_with_sound("form_change")
		
		return 
	end
	
	if arg_42_1 then
		Account:addToTeam(arg_42_1, arg_42_0.vars.team_idx, arg_42_2, true)
	end
	
	vibrate(VIBRATION_TYPE.Select)
	
	if not TutorialGuide:isPlayingTutorial() and TutorialCondition:isEnable("system_059") then
		TutorialGuide:forceClearTutorials({
			"system_059"
		})
	end
	
	arg_42_0.vars.formation_dirty = true
	
	arg_42_0:setNormalMode()
	arg_42_0:updateFormation()
	
	if arg_42_0.vars.team_idx ~= 12 then
		arg_42_0:playBatchEffect(arg_42_1, arg_42_2)
	end
end

function FormationEditor.showChangeButton(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0 = arg_43_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_43_1)
	
	if arg_43_3 or Account:getTeam(arg_43_0.vars.team_idx)[arg_43_1] then
		var_43_0:loadTextures("img/hero_config_btn_change.png", "img/hero_config_btn_change.png", "img/hero_config_btn_change.png", 1)
		arg_43_0:removeBtnGuideEffect(var_43_0, arg_43_1)
	else
		var_43_0:resetNormalRender()
		var_43_0:loadTextures("img/hero_config_btn_add.png", "img/hero_config_btn_add.png", "img/hero_config_btn_add.png", 1)
		var_43_0:setOpacity(229.5)
		arg_43_0:addBtnGuideEffect(var_43_0, arg_43_1)
	end
	
	var_43_0:setVisible(arg_43_2)
end

function FormationEditor.addBtnGuideEffect(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_0.vars.is_guide_position then
		local var_44_0
		local var_44_1 = arg_44_0.vars.formation_status ~= "ReadyToSwapUnit" and "uieff_team_empty_position_1.cfx" or "uieff_team_empty_position_2.cfx"
		
		arg_44_0.vars.cur_guide_eff = arg_44_0.vars.cur_guide_eff or {}
		
		if arg_44_0.vars.cur_guide_eff[arg_44_2] ~= var_44_1 then
			arg_44_0.vars.cur_guide_eff[arg_44_2] = var_44_1
			
			arg_44_1:removeChildByName("@guide_position_eff" .. tostring(arg_44_2))
			
			local var_44_2 = EffectManager:Play({
				pivot_x = 43,
				pivot_y = 43,
				pivot_z = -1,
				scale = 1,
				fn = var_44_1,
				layer = arg_44_1
			})
			
			var_44_2:setOpacity(255)
			var_44_2:setName("@guide_position_eff" .. tostring(arg_44_2))
		end
	end
end

function FormationEditor.removeBtnGuideEffect(arg_45_0, arg_45_1, arg_45_2)
	if arg_45_0.vars.is_guide_position then
		arg_45_1:removeChildByName("@guide_position_eff" .. tostring(arg_45_2))
	end
	
	arg_45_0.vars.cur_guide_eff = {}
end

function FormationEditor.showChangeButtonWithEffect(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	arg_46_0:enableFormationEditMode(true)
	
	for iter_46_0 = 1, arg_46_0.vars.placable_base_count do
		local var_46_0 = arg_46_0.vars.formation_wnd:getChildByName("pos" .. iter_46_0)
		
		if get_cocos_refid(var_46_0) then
			local var_46_1
			
			if type(arg_46_0.vars.team_idx) == "table" then
				var_46_1 = arg_46_0.vars.team_idx[tonumber(iter_46_0)]
			else
				var_46_1 = Account:getTeam(arg_46_0.vars.team_idx)[tonumber(iter_46_0)]
			end
			
			if not var_46_1 then
				arg_46_0:showChangeButton(iter_46_0, true)
			else
				arg_46_0:showChangeButton(iter_46_0, false)
			end
		end
	end
end

function FormationEditor.refreshGuideButtons(arg_47_0)
	if arg_47_0.vars.is_guide_position then
		for iter_47_0 = 1, arg_47_0.vars.base_count do
			local var_47_0 = arg_47_0.vars.formation_wnd:getChildByName("btn_change_" .. tostring(iter_47_0))
			
			if var_47_0 then
				var_47_0:setVisible(false)
				arg_47_0:removeBtnGuideEffect(var_47_0, iter_47_0)
			end
		end
	end
	
	for iter_47_1 = 1, arg_47_0.vars.base_count do
		if Account:getTeam(arg_47_0.vars.team_idx)[iter_47_1] then
			local var_47_1 = arg_47_0.vars.formation_wnd:getChildByName("btn_change_" .. tostring(iter_47_1))
			
			if var_47_1 then
				var_47_1:loadTextures("img/hero_config_btn_change.png", "img/hero_config_btn_change.png", "img/hero_config_btn_change.png", 1)
				var_47_1:setVisible(false)
				arg_47_0:removeBtnGuideEffect(var_47_1, iter_47_1)
			end
		else
			local var_47_2 = arg_47_0.vars.formation_wnd:getChildByName("btn_change_" .. tostring(iter_47_1))
			
			if var_47_2 then
				var_47_2:loadTextures("img/hero_config_btn_add.png", "img/hero_config_btn_add.png", "img/hero_config_btn_add.png", 1)
				var_47_2:setVisible(true)
				var_47_2:setOpacity(229.5)
				arg_47_0:addBtnGuideEffect(var_47_2, iter_47_1)
			end
		end
	end
end

function FormationEditor.showPetSettingPopup(arg_48_0)
	PetSettingPopup:init({
		mode = "Battle",
		team_idx = arg_48_0.vars.team_idx,
		close_callback = function(arg_49_0)
			arg_48_0:updateFormation(arg_48_0.vars.team_idx)
			
			if arg_48_0.opts.on_pet_select_save_team then
				arg_48_0:saveTeamInfo()
			end
			
			if arg_49_0 then
				arg_48_0.vars.formation_dirty = true
			end
			
			Analytics:closePopup()
		end
	})
	
	local var_48_0 = "select_pet"
	
	if BattleReady.vars and BattleReady.vars.enter_id then
		var_48_0 = Analytics:getMapKey(BattleReady.vars.enter_id) .. "/" .. var_48_0
	end
	
	Analytics:setPopup(var_48_0)
end

function FormationEditor.readyToSwapUnit(arg_50_0, arg_50_1)
	arg_50_0.vars.formation_status = "ReadyToSwapUnit"
	arg_50_0.vars.swap_unit = arg_50_1
	
	if arg_50_0.vars.formation_mode ~= "support" then
		local var_50_0 = Account:haveSameVariationGroupInTeam(arg_50_1, arg_50_0.vars.team_idx)
		
		if var_50_0 then
			arg_50_0:showChangeButton(var_50_0, true)
			
			return 
		end
		
		local var_50_1 = Account:getTeamUnitPosByCode(arg_50_1.inst.code, arg_50_0.vars.team_idx)
		
		if var_50_1 then
			arg_50_0:showChangeButton(var_50_1, true)
			
			return 
		end
	end
	
	for iter_50_0 = 1, arg_50_0.vars.placable_base_count do
		arg_50_0:showChangeButton(iter_50_0, arg_50_0:isPlacablePos(arg_50_1, iter_50_0))
	end
end

function Formation.getCursorPanelName(arg_51_0)
	return "img/hero_config_panelcursor.png"
end

function FormationEditor.readyToChangeUnit(arg_52_0, arg_52_1, arg_52_2)
	arg_52_0.vars.pos = arg_52_1
	
	if arg_52_0.vars.model_ids[arg_52_1] then
		local var_52_0 = arg_52_0.vars.formation_wnd:getChildByName("selected_btn")
		
		if var_52_0 then
			var_52_0:setVisible(true)
			
			local var_52_1 = SceneManager:convertToSceneSpace(arg_52_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_52_1), {
				x = 43,
				y = 43
			})
			
			if arg_52_0.opts.btns_ignore_notch then
				var_52_0:setPosition(var_52_1.x, var_52_1.y - HEIGHT_MARGIN / 2)
			elseif arg_52_0.opts.is_lota then
				local var_52_2 = arg_52_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_52_1)
				
				var_52_0:setPosition(var_52_2:getPosition())
			else
				var_52_0:setPosition(var_52_1.x - NotchStatus:getNotchSafeLeft(), var_52_1.y - HEIGHT_MARGIN / 2)
			end
			
			var_52_0:setVisible(true)
		end
		
		arg_52_0.vars.selected_idx = arg_52_1
		
		if arg_52_0.vars.formation_mode == "support" then
			if_set_visible(var_52_0, "btn_remove", arg_52_1 ~= 1)
		end
		
		for iter_52_0 = 1, arg_52_0.vars.placable_base_count do
			if iter_52_0 ~= arg_52_1 then
				local var_52_3
				
				if arg_52_0.vars.formation_mode == "support" then
					var_52_3 = arg_52_2 and arg_52_0.vars.model_ids[iter_52_0] and arg_52_0:isPlacablePos(arg_52_2, iter_52_0) and arg_52_0:isPlacablePos(arg_52_0.vars.model_ids[iter_52_0].unit, arg_52_1)
				else
					var_52_3 = not arg_52_2 or arg_52_0:isPlacablePos(arg_52_2, iter_52_0)
				end
				
				arg_52_0:showChangeButton(iter_52_0, var_52_3, true)
			end
		end
		
		if arg_52_1 ~= 5 and arg_52_0.vars.pvp_info and arg_52_0.vars.pvp_info.defend_mode then
			arg_52_0:showChangeButton(5, Account:getTeamMemberCount(arg_52_0.vars.team_idx) == 5)
		end
		
		if arg_52_0.vars.pvp_info and not arg_52_0.vars.pvp_info.defend_mode then
		end
		
		if var_52_0 then
			local var_52_4 = var_52_0:findChildByName("btn_team_detail")
			local var_52_5 = var_52_0:findChildByName("btn_remove")
			
			if arg_52_0.opts.use_detail and SceneManager:getCurrentSceneName() ~= "battle" then
				if_set_visible(var_52_0, "btn_team_detail", true)
			elseif (not arg_52_0.opts.use_detail or SceneManager:getCurrentSceneName() == "battle") and var_52_4 then
				if_set_visible(var_52_4, nil, false)
				
				if var_52_5 then
					var_52_5:setPositionX(0)
				end
			end
		end
	end
	
	if arg_52_0.vars.formation_status ~= "ReadyToChangeUnit" then
	end
	
	arg_52_0.vars.formation_status = "ReadyToChangeUnit"
	
	if arg_52_0.vars.formation_mode == "normal" and arg_52_1 == 5 then
		return 
	end
	
	local var_52_6 = arg_52_0.vars.formation_wnd:getChildByName("base" .. arg_52_1)
	
	if not var_52_6 then
		Log.e("base" .. arg_52_1 .. " 없음")
		
		return 
	end
	
	local var_52_7 = var_52_6:getContentSize()
	local var_52_8 = var_52_6:getAnchorPoint()
	local var_52_9 = var_52_6:getScaleX()
	local var_52_10 = var_52_6:getScaleY()
	
	arg_52_0.vars.blinking_marks = {}
	
	local var_52_11 = cc.Sprite:create(arg_52_0:getCursorPanelName())
	
	table.push(arg_52_0.vars.blinking_marks, var_52_11)
	var_52_11:setPosition(var_52_7.width * var_52_8.x, var_52_7.height * var_52_8.y)
	var_52_11:setScaleX(var_52_10)
	var_52_11:setScaleY(var_52_9)
	var_52_11:setRotationSkewX(0 - var_52_6:getRotationSkewY())
	var_52_11:setRotationSkewY(0 - var_52_6:getRotationSkewX())
	var_52_6:addChild(var_52_11)
	UIAction:Add(SEQ(DELAY(200), LOOP(SEQ(LOG(FADE_OUT(400)), LOG(FADE_IN(400))))), var_52_11, "team_ui.blink")
	arg_52_0:setDedicationNotify(arg_52_2)
end

function FormationEditor.isNormalMode(arg_53_0, arg_53_1)
	arg_53_1 = arg_53_1 or arg_53_0.vars.formation_status
	
	return arg_53_1 == "Normal"
end

function FormationEditor.saveTeamInfo(arg_54_0)
	if arg_54_0.vars and arg_54_0.vars.formation_dirty then
		Account:saveTeamInfo()
		
		arg_54_0.vars.formation_dirty = nil
	end
end

function FormationEditor.setFormationDirtyFlag(arg_55_0, arg_55_1)
	arg_55_0.vars.formation_dirty = arg_55_1
end

function FormationEditor.updateFormation_popup(arg_56_0, arg_56_1)
	if not arg_56_0 or not arg_56_0.vars or not get_cocos_refid(arg_56_1) then
		return 
	end
	
	if arg_56_0.opts.is_lota then
		arg_56_0:onDedicationPopup()
	end
	
	local var_56_0 = arg_56_0:getBattleTeam(arg_56_0.vars.team_idx)
	local var_56_1 = var_56_0:getDevoteStats()
	local var_56_2 = arg_56_1:getChildByName("n_dedi_detail")
	
	local function var_56_3(arg_57_0, arg_57_1, arg_57_2)
		local var_57_0 = cc.Node:create()
		local var_57_1 = cc.Sprite:create("img/cm_hero_cirbg2.png")
		
		var_57_1:setScale(1.4)
		var_57_0:addChild(var_57_1)
		
		local var_57_2 = DB("character", arg_57_0, "face_id") or "no_image"
		local var_57_3 = cc.Sprite:create("face/" .. var_57_2 .. "_s.png")
		
		var_57_0:addChild(var_57_3)
		
		local var_57_4 = cc.Sprite:create("img/cm_hero_circool1.png")
		
		var_57_4:setScale(1.4)
		var_57_0:addChild(var_57_4)
		
		if arg_57_1 then
			var_57_3:setColor(cc.c3b(102, 102, 102))
			var_57_4:setColor(cc.c3b(102, 102, 102))
		elseif arg_57_2 then
			var_57_4:setColor(tocolor("#ba69f7"))
		else
			var_57_4:setColor(tocolor("#b48447"))
		end
		
		return var_57_0
	end
	
	local var_56_4 = {
		{},
		{},
		{},
		{}
	}
	local var_56_5 = {}
	
	for iter_56_0, iter_56_1 in pairs(var_56_0.units) do
		if iter_56_1 then
			var_56_5[iter_56_1.inst.pos] = iter_56_1
		end
	end
	
	for iter_56_2 = 1, 4 do
		local var_56_6 = var_56_5[iter_56_2]
		local var_56_7 = var_56_2:getChildByName("n_pos" .. iter_56_2)
		
		var_56_7:getChildByName("n_bonus"):removeAllChildren()
		
		local var_56_8 = ""
		local var_56_9 = var_56_1[tostring(iter_56_2)] or {}
		local var_56_10 = 0
		local var_56_11 = {}
		
		for iter_56_3, iter_56_4 in pairs(var_56_9) do
			if iter_56_4.stat ~= 0 and var_56_6 then
				local var_56_12 = false
				
				if iter_56_4.uid ~= var_56_6.inst.uid then
					var_56_10 = var_56_10 + 1
				elseif iter_56_4.uid == var_56_6.inst.uid and var_56_6:getUnitOptionValue("imprint_focus") == 2 then
					var_56_12 = true
				end
				
				table.push(var_56_4[iter_56_2], {
					valid = var_56_6 and iter_56_4.uid ~= var_56_6.inst.uid,
					stat = iter_56_4,
					self_effect = var_56_12
				})
			end
		end
		
		if var_56_6 then
			local var_56_13 = arg_56_1:getChildByName("btn_memory_" .. iter_56_2)
			
			if get_cocos_refid(var_56_13) then
				if var_56_6:getUnitOptionValue("imprint_focus") == 2 then
					if_set_opacity(var_56_13, "icon_memory_type1", 76.5)
					if_set_opacity(var_56_13, "icon_memory_type2", 255)
				elseif var_56_6:getDevote() == 0 then
					if_set_opacity(var_56_13, "icon_memory_type1", 76.5)
					if_set_opacity(var_56_13, "icon_memory_type2", 76.5)
				else
					if_set_opacity(var_56_13, "icon_memory_type1", 255)
					if_set_opacity(var_56_13, "icon_memory_type2", 76.5)
				end
			end
		else
			if_set_opacity(arg_56_1, "btn_memory_" .. iter_56_2, 76.5)
		end
		
		local var_56_14 = arg_56_1:getChildByName("b_pos_" .. iter_56_2)
		
		for iter_56_5, iter_56_6 in pairs(var_56_4[iter_56_2]) do
			local var_56_15 = load_control("wnd/hero_config_dedication_item.csb")
			
			if iter_56_6.self_effect then
				iter_56_6.valid = not iter_56_6.valid
				
				if_set_color(var_56_15, "n_up", tocolor("#ba69f7"))
			end
			
			if not iter_56_6.valid then
				var_56_15:setColor(UIUtil.DARK_GREY)
				if_set_visible(var_56_15, "n_up", false)
				if_set(var_56_15, "t_bonus_name", T("devotion_skill_no_effect"))
			else
				if_set(var_56_15, "t_up", to_var_str(iter_56_6.stat.stat, iter_56_6.stat.type, 1))
				if_set(var_56_15, "t_bonus_name", getStatName(iter_56_6.stat.type))
			end
			
			local var_56_16 = 30
			
			if iter_56_2 == 2 or iter_56_2 == 4 then
				var_56_16 = -30
			end
			
			var_56_15:setPositionY((iter_56_5 - 1) * var_56_16)
			var_56_7:getChildByName("n_bonus"):addChild(var_56_15)
			
			local var_56_17
			
			for iter_56_7, iter_56_8 in pairs(var_56_5) do
				if iter_56_6.stat.uid == iter_56_8.inst.uid then
					var_56_17 = iter_56_8
				end
			end
			
			local var_56_18 = var_56_3(var_56_17:getDisplayCode(), not iter_56_6.valid, iter_56_6.self_effect)
			
			var_56_15:getChildByName("n_hud_face"):addChild(var_56_18)
			
			local var_56_19 = UIUtil:alignControl(var_56_15, "t_bonus_name", "n_up", 15)
			
			if iter_56_2 > 2 then
				local var_56_20 = UIUtil:getTextWidthAndPos(var_56_15, "t_up") + 20
				
				if not iter_56_6.valid then
					var_56_20 = 0
				end
				
				var_56_15:getChildByName("n_info"):setPositionX(0 - var_56_19 - var_56_20 - 40 - 15)
			end
		end
		
		local var_56_21 = var_56_10 > 0 and tocolor("#b48447") or cc.c3b(102, 102, 102)
		
		if_set_color(var_56_14, "bg", var_56_21)
		
		if var_56_6 and var_56_6:getUnitOptionValue("imprint_focus") == 2 then
			if_set_color(var_56_14, "bg", tocolor("#ba69f7"))
		end
		
		if_set_visible(var_56_7, "t_noeff", true)
		
		if not var_56_6 then
			if_set_visible(var_56_14, "n_hero", false)
		else
			local var_56_22 = DB("character", var_56_6:getDisplayCode(), "face_id") or "no_image"
			
			if_set_sprite(var_56_14, "face", "face/" .. var_56_22 .. "_s.png")
			
			if var_56_10 < 1 and #var_56_9 < 0 or #(var_56_4[iter_56_2] or {}) <= 0 then
				if_set_color(var_56_14, "n_hero", cc.c3b(102, 102, 102))
			else
				if_set_color(var_56_14, "n_hero", cc.c3b(255, 255, 255))
				if_set_visible(var_56_7, "t_noeff", false)
			end
		end
	end
end

function FormationEditor.getBattleTeam(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_1 or arg_58_0.vars.team_idx
	
	return Account:getBattleTeam(var_58_0)
end

function FormationEditor.getTeamInfo(arg_59_0, arg_59_1)
	local var_59_0
	
	if type(arg_59_1) == "table" then
		return arg_59_1
	else
		var_59_0 = Account:getTeam(arg_59_1)
	end
	
	return var_59_0
end

function FormationEditor.showDedicationPopup(arg_60_0, arg_60_1)
	if arg_60_0.opts.npcteam_id then
		balloon_message_with_sound("devotion_npc_disable")
		
		return 
	end
	
	local var_60_0 = load_dlg("hero_config_dedication", true, "wnd")
	
	var_60_0.updateFormation_popup = arg_60_0.updateFormation_popup
	var_60_0.getTeamInfo = arg_60_0.getTeamInfo
	var_60_0.self = arg_60_0
	var_60_0.team_idx = arg_60_0.vars.team_idx
	
	if arg_60_0.vars.custom_team then
		var_60_0.team_idx = arg_60_0.vars.custom_team
	end
	
	var_60_0.formation_wnd = arg_60_1
	
	BackButtonManager:push({
		check_id = "hero_config_dedication",
		back_func = function()
			closeHeroConfigDedication(var_60_0:getChildByName("btn_close"))
		end
	})
	if_set(var_60_0, "txt_caution", T("devotion_skill_no_effect_self"))
	SceneManager:getRunningNativeScene():addChild(var_60_0)
	
	local var_60_1 = arg_60_0:getBattleTeam(arg_60_0.vars.team_idx)
	local var_60_2 = var_60_1:getDevoteStats()
	local var_60_3 = var_60_0:getChildByName("n_dedi_detail")
	
	local function var_60_4(arg_62_0, arg_62_1, arg_62_2)
		local var_62_0 = cc.Node:create()
		local var_62_1 = cc.Sprite:create("img/cm_hero_cirbg2.png")
		
		var_62_1:setScale(1.4)
		var_62_0:addChild(var_62_1)
		
		local var_62_2 = DB("character", arg_62_0, "face_id") or "no_image"
		local var_62_3 = cc.Sprite:create("face/" .. var_62_2 .. "_s.png")
		
		var_62_0:addChild(var_62_3)
		
		local var_62_4 = cc.Sprite:create("img/cm_hero_circool1.png")
		
		var_62_4:setScale(1.4)
		var_62_0:addChild(var_62_4)
		
		if arg_62_1 then
			var_62_3:setColor(cc.c3b(102, 102, 102))
			var_62_4:setColor(cc.c3b(102, 102, 102))
		elseif arg_62_2 then
			var_62_4:setColor(tocolor("#ba69f7"))
		else
			var_62_4:setColor(tocolor("#b48447"))
		end
		
		return var_62_0
	end
	
	local var_60_5 = {
		{},
		{},
		{},
		{}
	}
	local var_60_6 = {}
	
	for iter_60_0, iter_60_1 in pairs(var_60_1.units) do
		if iter_60_1 then
			var_60_6[iter_60_1.inst.pos] = iter_60_1
		end
	end
	
	for iter_60_2 = 1, 4 do
		local var_60_7 = var_60_6[iter_60_2]
		local var_60_8 = var_60_3:getChildByName("n_pos" .. iter_60_2)
		local var_60_9 = ""
		local var_60_10 = var_60_2[tostring(iter_60_2)] or {}
		local var_60_11 = 0
		local var_60_12 = {}
		
		for iter_60_3, iter_60_4 in pairs(var_60_10) do
			if iter_60_4.stat ~= 0 and var_60_7 then
				local var_60_13 = false
				
				if iter_60_4.uid ~= var_60_7.inst.uid then
					var_60_11 = var_60_11 + 1
				elseif iter_60_4.uid == var_60_7.inst.uid and var_60_7:getUnitOptionValue("imprint_focus") == 2 then
					var_60_13 = true
				end
				
				table.push(var_60_5[iter_60_2], {
					valid = var_60_7 and iter_60_4.uid ~= var_60_7.inst.uid,
					stat = iter_60_4,
					self_effect = var_60_13
				})
			end
		end
		
		if var_60_7 then
			local var_60_14 = DB("character", var_60_7.db.code, {
				"devotion_skill_slot"
			})
			local var_60_15 = string.split(var_60_14, ";")
			local var_60_16 = var_60_0:getChildByName("btn_memory_" .. iter_60_2)
			
			if var_60_15 and get_cocos_refid(var_60_16) then
				local var_60_17 = ""
				
				for iter_60_5, iter_60_6 in pairs(var_60_15) do
					var_60_17 = var_60_17 .. (iter_60_6 or "")
				end
				
				local var_60_18 = string.format("img/hero_dedi_p_%s.png", var_60_17)
				
				if_set_sprite(var_60_16, "icon_memory_type1", var_60_18)
				
				if var_60_7:getUnitOptionValue("imprint_focus") == 2 then
					if_set_opacity(var_60_16, "icon_memory_type1", 76.5)
					if_set_opacity(var_60_16, "icon_memory_type2", 255)
				elseif var_60_7:getDevote() == 0 then
					if_set_opacity(var_60_16, "icon_memory_type1", 76.5)
					if_set_opacity(var_60_16, "icon_memory_type2", 76.5)
				else
					if_set_opacity(var_60_16, "icon_memory_type1", 255)
					if_set_opacity(var_60_16, "icon_memory_type2", 76.5)
				end
			end
		else
			if_set_opacity(var_60_0, "btn_memory_" .. iter_60_2, 76.5)
		end
		
		local var_60_19 = var_60_0:getChildByName("b_pos_" .. iter_60_2)
		
		for iter_60_7, iter_60_8 in pairs(var_60_5[iter_60_2]) do
			local var_60_20 = load_control("wnd/hero_config_dedication_item.csb")
			
			if iter_60_8.self_effect then
				iter_60_8.valid = not iter_60_8.valid
				
				if_set_color(var_60_20, "n_up", tocolor("#ba69f7"))
			end
			
			if not iter_60_8.valid then
				var_60_20:setColor(UIUtil.DARK_GREY)
				if_set_visible(var_60_20, "n_up", false)
				if_set(var_60_20, "t_bonus_name", T("devotion_skill_no_effect"))
			else
				if_set(var_60_20, "t_up", to_var_str(iter_60_8.stat.stat, iter_60_8.stat.type, 1))
				if_set(var_60_20, "t_bonus_name", getStatName(iter_60_8.stat.type))
			end
			
			local var_60_21 = 30
			
			if iter_60_2 == 2 or iter_60_2 == 4 then
				var_60_21 = -30
			end
			
			var_60_20:setPositionY((iter_60_7 - 1) * var_60_21)
			var_60_8:getChildByName("n_bonus"):addChild(var_60_20)
			
			local var_60_22
			
			for iter_60_9, iter_60_10 in pairs(var_60_6) do
				if iter_60_8.stat.uid == iter_60_10.inst.uid then
					var_60_22 = iter_60_10
				end
			end
			
			local var_60_23 = var_60_4(var_60_22:getDisplayCode(), not iter_60_8.valid, iter_60_8.self_effect)
			
			var_60_20:getChildByName("n_hud_face"):addChild(var_60_23)
			
			local var_60_24 = UIUtil:alignControl(var_60_20, "t_bonus_name", "n_up", 15)
			
			if iter_60_2 > 2 then
				local var_60_25 = UIUtil:getTextWidthAndPos(var_60_20, "t_up") + 20
				
				if not iter_60_8.valid then
					var_60_25 = 0
				end
				
				var_60_20:getChildByName("n_info"):setPositionX(0 - var_60_24 - var_60_25 - 40 - 15)
			end
		end
		
		if var_60_11 > 0 then
		end
		
		if false then
		end
		
		local var_60_26 = var_60_11 > 0 and tocolor("#b48447") or cc.c3b(102, 102, 102)
		
		if_set_color(var_60_19, "bg", var_60_26)
		
		if var_60_7 and var_60_7:getUnitOptionValue("imprint_focus") == 2 then
			if_set_color(var_60_19, "bg", tocolor("#ba69f7"))
		end
		
		if not var_60_7 then
			if_set_visible(var_60_19, "n_hero", false)
		else
			local var_60_27 = DB("character", var_60_7:getDisplayCode(), "face_id") or "no_image"
			
			if_set_sprite(var_60_19, "face", "face/" .. var_60_27 .. "_s.png")
			
			if var_60_11 < 1 and #var_60_10 < 0 or #(var_60_5[iter_60_2] or {}) <= 0 then
				if_set_color(var_60_19, "n_hero", cc.c3b(102, 102, 102))
			else
				if_set_color(var_60_19, "n_hero", cc.c3b(255, 255, 255))
				if_set_visible(var_60_8, "t_noeff", false)
			end
		end
	end
end

function FormationEditor.openMyDeviceInventory(arg_63_0)
	if not arg_63_0.opts or not arg_63_0.opts.is_automaton then
		return 
	end
	
	DeviceInventory:openDeviceInventory()
end

function FormationEditor.showDedicationPopupExtension(arg_64_0, arg_64_1, arg_64_2)
	if not arg_64_1 then
		return 
	end
	
	local var_64_0 = arg_64_2 or SceneManager:getRunningNativeScene()
	local var_64_1 = load_dlg("hero_config_dedication", true, "wnd")
	
	BackButtonManager:push({
		check_id = "hero_config_dedication",
		back_func = function()
			closeHeroConfigDedication(var_64_1:getChildByName("btn_close"))
		end
	})
	if_set(var_64_1, "txt_caution", T("devotion_skill_no_effect_self"))
	var_64_0:addChild(var_64_1)
	
	local var_64_2 = Team:makeTeamData(arg_64_1)
	local var_64_3 = Team:makeTeam(var_64_2)
	local var_64_4 = var_64_3:getDevoteStats()
	local var_64_5 = var_64_1:getChildByName("n_dedi_detail")
	
	local function var_64_6(arg_66_0, arg_66_1, arg_66_2)
		local var_66_0 = cc.Node:create()
		local var_66_1 = cc.Sprite:create("img/cm_hero_cirbg2.png")
		
		var_66_1:setScale(1.4)
		var_66_0:addChild(var_66_1)
		
		local var_66_2 = DB("character", arg_66_0, "face_id") or "no_image"
		local var_66_3 = cc.Sprite:create("face/" .. var_66_2 .. "_s.png")
		
		var_66_0:addChild(var_66_3)
		
		local var_66_4 = cc.Sprite:create("img/cm_hero_circool1.png")
		
		var_66_4:setScale(1.4)
		var_66_0:addChild(var_66_4)
		
		if arg_66_1 then
			var_66_3:setColor(cc.c3b(102, 102, 102))
			var_66_4:setColor(cc.c3b(102, 102, 102))
		elseif arg_66_2 then
			var_66_4:setColor(tocolor("#ba69f7"))
		else
			var_66_4:setColor(tocolor("#b48447"))
		end
		
		return var_66_0
	end
	
	local var_64_7 = {
		{},
		{},
		{},
		{}
	}
	local var_64_8 = {}
	
	for iter_64_0, iter_64_1 in pairs(var_64_3.units) do
		if iter_64_1 then
			var_64_8[iter_64_1.inst.pos] = iter_64_1
		end
	end
	
	for iter_64_2 = 1, 4 do
		local var_64_9 = var_64_8[iter_64_2]
		local var_64_10 = var_64_5:getChildByName("n_pos" .. iter_64_2)
		local var_64_11 = ""
		local var_64_12 = var_64_4[tostring(iter_64_2)] or {}
		local var_64_13 = 0
		local var_64_14 = {}
		
		for iter_64_3, iter_64_4 in pairs(var_64_12) do
			if iter_64_4.stat ~= 0 and var_64_9 then
				local var_64_15 = false
				
				if iter_64_4.uid ~= var_64_9.inst.uid then
					var_64_13 = var_64_13 + 1
				elseif iter_64_4.uid == var_64_9.inst.uid and var_64_9:getUnitOptionValue("imprint_focus") == 2 then
					var_64_15 = true
				end
				
				table.push(var_64_7[iter_64_2], {
					valid = var_64_9 and iter_64_4.uid ~= var_64_9.inst.uid,
					stat = iter_64_4,
					self_effect = var_64_15
				})
			end
		end
		
		if var_64_9 then
			local var_64_16 = DB("character", var_64_9.db.code, {
				"devotion_skill_slot"
			})
			local var_64_17 = string.split(var_64_16, ";")
			local var_64_18 = var_64_1:getChildByName("btn_memory_" .. iter_64_2)
			
			if var_64_17 and get_cocos_refid(var_64_18) then
				local var_64_19 = ""
				
				for iter_64_5, iter_64_6 in pairs(var_64_17) do
					var_64_19 = var_64_19 .. (iter_64_6 or "")
				end
				
				local var_64_20 = string.format("img/hero_dedi_p_%s.png", var_64_19)
				
				if_set_sprite(var_64_18, "icon_memory_type1", var_64_20)
				
				if var_64_9:getUnitOptionValue("imprint_focus") == 2 then
					if_set_opacity(var_64_18, "icon_memory_type1", 76.5)
					if_set_opacity(var_64_18, "icon_memory_type2", 255)
				elseif var_64_9:getDevote() == 0 then
					if_set_opacity(var_64_18, "icon_memory_type1", 76.5)
					if_set_opacity(var_64_18, "icon_memory_type2", 76.5)
				else
					if_set_opacity(var_64_18, "icon_memory_type1", 255)
					if_set_opacity(var_64_18, "icon_memory_type2", 76.5)
				end
			end
		else
			if_set_opacity(var_64_1, "btn_memory_" .. iter_64_2, 76.5)
		end
		
		for iter_64_7 = 1, 4 do
			local var_64_21 = var_64_1:getChildByName("btn_memory_" .. iter_64_7)
			
			if var_64_21 then
				var_64_21:setTouchEnabled(false)
			end
		end
		
		local var_64_22 = var_64_1:getChildByName("b_pos_" .. iter_64_2)
		
		for iter_64_8, iter_64_9 in pairs(var_64_7[iter_64_2]) do
			local var_64_23 = load_control("wnd/hero_config_dedication_item.csb")
			
			if iter_64_9.self_effect then
				iter_64_9.valid = not iter_64_9.valid
				
				if_set_color(var_64_23, "n_up", tocolor("#ba69f7"))
			end
			
			if not iter_64_9.valid then
				var_64_23:setColor(UIUtil.DARK_GREY)
				if_set_visible(var_64_23, "n_up", false)
				if_set(var_64_23, "t_bonus_name", T("devotion_skill_no_effect"))
			else
				if_set(var_64_23, "t_up", to_var_str(iter_64_9.stat.stat, iter_64_9.stat.type, 1))
				if_set(var_64_23, "t_bonus_name", getStatName(iter_64_9.stat.type))
			end
			
			local var_64_24 = 30
			
			if iter_64_2 == 2 or iter_64_2 == 4 then
				var_64_24 = -30
			end
			
			var_64_23:setPositionY((iter_64_8 - 1) * var_64_24)
			var_64_10:getChildByName("n_bonus"):addChild(var_64_23)
			
			local var_64_25
			
			for iter_64_10, iter_64_11 in pairs(var_64_8) do
				if iter_64_9.stat.uid == iter_64_11.inst.uid then
					var_64_25 = iter_64_11
				end
			end
			
			local var_64_26 = var_64_6(var_64_25:getDisplayCode(), not iter_64_9.valid, iter_64_9.self_effect)
			
			var_64_23:getChildByName("n_hud_face"):addChild(var_64_26)
			
			local var_64_27 = UIUtil:alignControl(var_64_23, "t_bonus_name", "n_up", 15)
			
			if iter_64_2 > 2 then
				local var_64_28 = UIUtil:getTextWidthAndPos(var_64_23, "t_up") + 20
				
				if not iter_64_9.valid then
					var_64_28 = 0
				end
				
				var_64_23:getChildByName("n_info"):setPositionX(0 - var_64_27 - var_64_28 - 40 - 15)
			end
		end
		
		local var_64_29 = var_64_13 > 0 and tocolor("#b48447") or cc.c3b(102, 102, 102)
		
		if_set_color(var_64_22, "bg", var_64_29)
		
		if var_64_9 and var_64_9:getUnitOptionValue("imprint_focus") == 2 then
			if_set_color(var_64_22, "bg", tocolor("#ba69f7"))
		end
		
		if not var_64_9 then
			if_set_visible(var_64_22, "n_hero", false)
		else
			local var_64_30 = DB("character", var_64_9:getDisplayCode(), "face_id") or "no_image"
			
			if_set_sprite(var_64_22, "face", "face/" .. var_64_30 .. "_s.png")
			
			if var_64_13 < 1 and #var_64_12 < 0 or #(var_64_7[iter_64_2] or {}) <= 0 then
				if_set_color(var_64_22, "n_hero", cc.c3b(102, 102, 102))
			else
				if_set_visible(var_64_10, "t_noeff", false)
			end
		end
	end
end
