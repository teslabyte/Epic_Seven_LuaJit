GroupFormationEditor = {}
FormationEditorExtension = {}

copy_functions(FormationEditor, GroupFormationEditor)

function defaultGroupFormationEditEventHandler(arg_1_0, arg_1_1)
	local var_1_0 = getParentWindow(arg_1_0).parent
	local var_1_1 = getParentWindow(arg_1_0):getName()
	
	print("group_eventHandler", var_1_1, arg_1_1)
	
	local var_1_2 = getParentWindow(arg_1_0).class
	
	if var_1_2.opts and var_1_2.opts.ui_handler then
		var_1_2.opts.ui_handler(arg_1_0, arg_1_1)
	end
	
	if string.len(arg_1_1) == 4 and string.starts(arg_1_1, "btn") then
		var_1_0.vars.touched_group_name = var_1_1
		var_1_0.vars.touched_base_idx = tonumber(string.sub(arg_1_1, -1, -1))
		
		return 
	end
	
	if arg_1_1 == "btn_dedi" and var_1_0.showDedicationPopup then
		var_1_0:showDedicationPopup(var_1_1)
		
		if var_1_0.setNormalMode then
			var_1_0:setNormalMode()
		end
	end
	
	if arg_1_1 == "btn_ignore" then
		var_1_0:setNormalMode()
	end
	
	if string.starts(arg_1_1, "btn_change_") then
		var_1_0:onTouchPosition(var_1_1, tonumber(string.sub(arg_1_1, -1, -1)))
		
		return 
	end
	
	if string.starts(arg_1_1, "btn_remove") then
		var_1_0:removeUnitFromPos(var_1_1)
		var_1_0:setNormalMode()
		
		return 
	end
	
	if arg_1_1 == "btn_team_detail" and not UnitMain:isValid() and HeroBelt:CanUseMultipleInstance() and var_1_0.openPopupUnitDetail then
		var_1_0:openPopupUnitDetail(var_1_1)
	end
end

function FormationEditorExtension.isInTeam(arg_2_0, arg_2_1)
	return Account:isInTeam(arg_2_1, arg_2_0.vars.team_idx)
end

function FormationEditorExtension.getTeamMemberCount(arg_3_0, arg_3_1)
	return Account:getTeamMemberCount(arg_3_0.vars.team_idx, arg_3_1)
end

function FormationEditorExtension.haveSameVariationGroupInTeam(arg_4_0, arg_4_1)
	return Account:haveSameVariationGroupInTeam(arg_4_1, arg_4_0.vars.team_idx)
end

function FormationEditorExtension.getTeamUnitPosByCode(arg_5_0, arg_5_1, arg_5_2)
	return Account:getTeamUnitPosByCode(arg_5_1, arg_5_0.vars.team_idx, arg_5_2)
end

function FormationEditorExtension.addToTeam(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	Account:addToTeam(arg_6_1, arg_6_0.vars.team_idx, arg_6_2, arg_6_3)
end

function FormationEditorExtension.removeFromTeam(arg_7_0, arg_7_1, arg_7_2)
	Account:removeFromTeam(arg_7_1, arg_7_0.vars.team_idx, arg_7_2)
end

function GroupFormationEditor.visit_editors(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.control_groups) do
		arg_8_1(iter_8_1)
	end
end

function GroupFormationEditor.setAllEditors_states(arg_9_0, arg_9_1)
	local var_9_0
	
	var_9_0 = arg_9_1 or arg_9_0.vars.formation_status
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.control_groups) do
		if iter_9_1.vars then
			iter_9_1.vars.formation_status = arg_9_0.vars.formation_status
		end
	end
end

function GroupFormationEditor.setAllEditors_dirtyflags(arg_10_0, arg_10_1)
	local var_10_0
	
	var_10_0 = arg_10_1 or arg_10_0.vars.formation_dirty
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.control_groups) do
		if iter_10_1.vars then
			iter_10_1.vars.formation_dirty = arg_10_0.vars.formation_dirty
		end
	end
end

function GroupFormationEditor.any_editors(arg_11_0, arg_11_1)
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.control_groups) do
		if arg_11_1(iter_11_1) then
			return true
		end
	end
	
	return false
end

function GroupFormationEditor.initFormationEditor(arg_12_0, arg_12_1, arg_12_2)
	copy_functions(GroupFormationEditor, arg_12_1)
	
	arg_12_1.vars = {}
	arg_12_1.vars.groups = {}
	arg_12_1.vars.control_groups = {}
	arg_12_1.vars.opts = arg_12_2
	arg_12_1.vars.least_unit = arg_12_2.least_unit or 1
	arg_12_1.vars.max_unit = arg_12_2.max_unit or 3
	arg_12_1.vars.key_slot_idx = arg_12_2.key_slot_idx
	arg_12_1.vars.onFormationResEvent_UpdateFormation = arg_12_2.onFormationResEvent_UpdateFormation
	arg_12_1.vars.onFormationResEvent_UpdateTeamPoint = arg_12_2.onFormationResEvent_UpdateTeamPoint
	arg_12_1.vars.is_burning = arg_12_2.is_burning
	arg_12_1.vars.use_duplicate = arg_12_2.use_duplicate
	
	for iter_12_0 = 1, #arg_12_2.infos do
		local var_12_0 = arg_12_2.infos[iter_12_0]
		local var_12_1 = {
			vars = var_12_1.vars or {}
		}
		
		var_12_1.vars.formation_wnd = var_12_0.wnd
		var_12_1.vars.formation_wnd.class = var_12_1
		var_12_1.vars.formation_wnd.parent = arg_12_1
		
		var_12_1.vars.formation_wnd:setName(var_12_0.group_name)
		
		var_12_1.vars.group_name = var_12_0.group_name
		var_12_1.vars.least_unit = var_12_0.least_unit
		arg_12_2.wnd = var_12_0.wnd
		arg_12_2.ignore_team_selector = true
		arg_12_2.is_enemy = var_12_0.is_enemy
		arg_12_2.max_unit = var_12_0.max_unit or 3
		arg_12_2.key_slot_idx = var_12_0.key_slot_idx
		arg_12_2.flip_model = var_12_0.flip_model
		arg_12_2.use_detail = var_12_0.use_detail
		
		if arg_12_2.is_descent and var_12_0.descent_team_idx then
			arg_12_2.descent_team_idx = var_12_0.descent_team_idx
		elseif arg_12_2.is_burning and var_12_0.burning_team_idx then
			arg_12_2.burning_team_idx = var_12_0.burning_team_idx
		end
		
		if not var_12_0.custom then
			Formation:initFormation(var_12_1, table.shallow_clone(arg_12_2))
			copy_functions(FormationEditor, var_12_1)
			copy_functions(FormationEditorExtension, var_12_1)
		else
			CustomFormation:initFormation(var_12_1, table.shallow_clone(arg_12_2))
			copy_functions(CustomFormationEditor, var_12_1)
		end
		
		var_12_1:addFormationUpdateLuaEvent("editor" .. tostring(iter_12_0))
		
		if arg_12_2.sprite_mode then
			var_12_1.vars.model_mode = "Sprite"
		end
		
		local var_12_2 = var_12_1.vars.formation_wnd:getChildByName("n_formation")
		
		if var_12_2 then
			if_set_visible(var_12_2, "t_pos1", false)
			if_set_visible(var_12_2, "t_pos2", false)
			if_set_visible(var_12_2, "t_pos3", false)
			if_set_visible(var_12_2, "t_pos4", false)
		end
		
		if var_12_0.title then
			if_set(var_12_0.wnd, var_12_0.title.cont, var_12_0.title.text)
		end
		
		arg_12_1.vars.groups[var_12_0.group_name] = var_12_1
		
		if var_12_0.can_edit then
			HANDLER[var_12_0.group_name] = defaultGroupFormationEditEventHandler
			arg_12_1.vars.control_groups[var_12_0.group_name] = var_12_1
		end
		
		if var_12_0.can_edit and iter_12_0 == 1 then
			Scheduler:removeByName("group_formation_scheduler")
			Scheduler:add(var_12_0.wnd, arg_12_1.procTouchUnit, arg_12_1):setName("group_formation_scheduler")
		end
	end
	
	arg_12_1.vars._event_listener_wnd = arg_12_2.lua_event_wnd
	
	arg_12_1:addFormationUpdateLuaEvent("group_formation_editor")
	arg_12_1:setNormalMode()
end

function GroupFormationEditor.callback(arg_13_0, arg_13_1, ...)
	local var_13_0 = "callback" .. arg_13_1
	
	if arg_13_0.vars.opts[var_13_0] then
		return arg_13_0.vars.opts[var_13_0](...)
	end
	
	return true
end

function GroupFormationEditor.updateGroupFormation(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0.vars.groups[arg_14_1] then
		arg_14_0.vars.groups[arg_14_1]:updateFormation(arg_14_2)
	end
end

function GroupFormationEditor.updateGroupTeamPoint(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0.vars.groups[arg_15_1] then
		arg_15_0.vars.groups[arg_15_1]:updateTeamPoint(arg_15_2)
	end
end

function GroupFormationEditor.getGroupEditor(arg_16_0, arg_16_1)
	if arg_16_0.vars.groups[arg_16_1] then
		return arg_16_0.vars.groups[arg_16_1]
	end
end

function GroupFormationEditor.procTouchUnit(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if UnitMain:isValid() then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.touched_group_name
	local var_17_1 = arg_17_0.vars.touched_base_idx
	
	if var_17_0 and var_17_1 then
		arg_17_0:onTouchPosition(var_17_0, var_17_1)
	end
end

function GroupFormationEditor.onHeroListEventForFormationEditor(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not arg_18_0.vars or arg_18_0.vars and arg_18_0.vars.prevent_formation_edit then
		local var_18_0 = HeroBelt:getControl(arg_18_2)
		
		if var_18_0 then
			var_18_0:getChildByName("add"):setVisible(false)
		end
		
		return 
	end
	
	if arg_18_1 == "change" then
		local var_18_1 = HeroBelt:getControl(arg_18_2)
		local var_18_2 = HeroBelt:getControl(arg_18_3)
		
		if var_18_1 then
			var_18_1:getChildByName("add"):setVisible(false)
		end
		
		if var_18_2 then
			var_18_2:getChildByName("add"):setVisible(true)
		end
		
		if HeroBelt:isScrolling() then
			vibrate(VIBRATION_TYPE.Select)
		end
		
		if not arg_18_0:isNormalMode() then
			local function var_18_3()
				arg_18_0:setNormalMode()
				UIAction:Remove("dedication_effct")
				arg_18_0:visit_editors(function(arg_20_0)
					arg_20_0:removeDedicationEffect()
				end)
			end
			
			if arg_18_0.vars.formation_status == "ReadyToSwapUnit" then
				var_18_3()
			elseif arg_18_0.vars.formation_status == "ReadyToChangeUnit" and HeroBelt:isPushed() then
				var_18_3()
			end
		end
	elseif arg_18_1 == "add" then
		local var_18_4 = arg_18_0:isNormalMode()
		
		arg_18_0.vars.dedi_eff_dirty = not var_18_4
		
		arg_18_0:setAllEditors_dirtyflags()
		
		local var_18_5 = arg_18_0:onAddUnit(arg_18_2)
		
		vibrate(VIBRATION_TYPE.Select)
		
		if var_18_4 or var_18_5 == false then
			arg_18_0:visit_editors(function(arg_21_0)
				arg_21_0:setDedicationNotify(arg_18_2, arg_18_0:isNormalMode())
			end)
		else
			local var_18_6, var_18_7 = arg_18_2:getDevoteSkill()
			
			if var_18_7 ~= 0 then
				arg_18_0:visit_editors(function(arg_22_0)
					if_set_visible(arg_22_0:getDediSlider(), nil, true)
				end)
				arg_18_0:visit_editors(function(arg_23_0)
					arg_23_0:setDedicationDetail(arg_18_2)
				end)
			end
		end
	elseif arg_18_1 == "select" and not UnitMain:isValid() and HeroBelt:CanUseMultipleInstance() then
		local var_18_8 = arg_18_3
		
		if UnitMain:isUsablePopupScene(SceneManager:getCurrentSceneName()) and var_18_8 and arg_18_0.vars.formation_status ~= "ReadyToSwapUnit" and arg_18_0.vars.formation_status ~= "ReadyToChangeUnit" then
			UnitMain:beginPopupMode({
				unit = arg_18_2
			})
			
			return 
		end
	end
	
	if arg_18_1 == "highest_item" then
		local var_18_9 = HeroBelt:getControl(arg_18_2)
		
		if var_18_9 and not arg_18_2.isExclude then
			var_18_9:findChildByName("add"):setVisible(true)
		end
	end
end

function GroupFormationEditor.openPopupUnitDetail(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.groups[arg_24_1]
	
	if var_24_0 then
		local var_24_1 = var_24_0:getUnitByPos(arg_24_0.vars.selected_pos)
		
		if UnitMain:isUsablePopupScene(SceneManager:getCurrentSceneName()) and var_24_1 then
			arg_24_0:setNormalMode()
			UnitMain:beginPopupMode({
				unit = var_24_1
			})
			
			return 
		end
	end
end

function GroupFormationEditor.getDediSlider(arg_25_0)
	return (SceneManager:getRunningNativeScene():getChildByName("n_dedi_tooltip_slide"))
end

function GroupFormationEditor.isNormalMode(arg_26_0, arg_26_1)
	arg_26_1 = arg_26_1 or arg_26_0.vars.formation_status
	
	return arg_26_1 == "Normal"
end

function GroupFormationEditor.onAddUnit(arg_27_0, arg_27_1)
	if not arg_27_1:isOrganizable() or not arg_27_0:callback("CanAddUnit", arg_27_1) then
		balloon_message_with_sound("cant_form_unit")
		
		return 
	end
	
	arg_27_0:setNormalMode()
	
	if arg_27_0:any_editors(function(arg_28_0)
		return arg_28_0:isInTeam(arg_27_1)
	end) and not arg_27_0.vars.use_duplicate then
		balloon_message_with_sound("already_in_team")
		
		return false
	end
	
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.control_groups) do
		local var_27_0 = iter_27_1:haveSameVariationGroupInTeam(arg_27_1)
		local var_27_1 = iter_27_1:getTeamUnitPosByCode(arg_27_1.inst.code)
		local var_27_2 = var_27_0 or var_27_1
		
		if var_27_2 and not arg_27_0.vars.use_duplicate then
			arg_27_0.vars.formation_status = "ReadyToSwapUnit"
			
			arg_27_0:setAllEditors_states()
			
			arg_27_0.vars.swap_unit = arg_27_1
			
			iter_27_1:showChangeButton(var_27_2, true)
			
			return 
		end
	end
	
	if ClanWarTeam:getMode() == "clan_pvp_defence" and arg_27_1:isLockArenaAndClan() then
		balloon_message_with_sound("character_mc_cannot_enter")
		
		return false
	end
	
	arg_27_0:readyToSwapUnit(arg_27_1)
end

function GroupFormationEditor.setNormalMode(arg_29_0)
	if arg_29_0:isNormalMode() then
		return 
	end
	
	arg_29_0.vars.touched_model_idx = nil
	arg_29_0.vars.touched_base_idx = nil
	arg_29_0.vars.swap_unit = nil
	arg_29_0.vars.formation_status = "Normal"
	
	arg_29_0:visit_editors(function(arg_30_0)
		for iter_30_0 = 1, arg_30_0.vars.base_count do
			if_set_visible(arg_30_0.vars.formation_wnd, "btn_change_" .. iter_30_0, false)
		end
		
		if_set_visible(arg_30_0.vars.formation_wnd, "selected_btn", false)
		if_set_visible(arg_29_0:getDediSlider(), nil, false)
		arg_30_0:removeModeEffects()
		
		if not arg_29_0.vars.dedi_eff_dirty then
			arg_30_0:setNormalMode()
		end
	end)
	
	arg_29_0.vars.dedi_eff_dirty = nil
end

function GroupFormationEditor.onTouchPosition(arg_31_0, arg_31_1, arg_31_2)
	arg_31_0.vars.touched_group_name = nil
	arg_31_0.vars.touched_model_idx = nil
	arg_31_0.vars.touched_base_idx = nil
	
	local var_31_0 = arg_31_0.vars.control_groups[arg_31_1]
	
	if var_31_0 == nil then
		return 
	end
	
	if arg_31_0:isNormalMode() then
		if var_31_0.vars.model_ids[arg_31_2] then
			local var_31_1 = var_31_0.vars.model_ids[arg_31_2].unit
			
			arg_31_0.vars.selected_group = arg_31_1
			arg_31_0.vars.selected_pos = arg_31_2
			
			arg_31_0:callback("SelectUnit", var_31_1)
			arg_31_0:readyToChangeUnit(arg_31_1, arg_31_2)
		elseif var_31_0:getTeamMemberCount(true) >= arg_31_0.vars.max_unit then
			if arg_31_0.vars.opts and (arg_31_0.vars.opts.is_descent or arg_31_0.vars.opts.is_burning) then
			else
				balloon_message_with_sound("war_ui_0008")
			end
		else
			balloon_message_with_sound("form_hero")
		end
		
		return 
	end
	
	UIAction:Remove("dedication_effct")
	
	if arg_31_0.vars.formation_status == "ReadyToChangeUnit" then
		if arg_31_0.vars.selected_group == arg_31_1 and arg_31_0.vars.selected_pos == arg_31_2 then
			arg_31_0:setNormalMode()
		elseif var_31_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_31_2):isVisible() then
			local var_31_2 = arg_31_0:getUnit(arg_31_0.vars.selected_group, arg_31_0.vars.selected_pos)
			
			if var_31_2 and not arg_31_0:getUnit(arg_31_1, arg_31_2) and arg_31_0.vars.selected_group ~= arg_31_1 and arg_31_0:getUnitCount(arg_31_0.vars.selected_group) <= arg_31_0.vars.least_unit then
				balloon_message_with_sound("form_need")
				
				return 
			end
			
			arg_31_0:swapUnit(var_31_2, arg_31_1, arg_31_2)
		end
	end
	
	if arg_31_0.vars.formation_status == "ReadyToSwapUnit" and var_31_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_31_2):isVisible() then
		arg_31_0:swapUnit(arg_31_0.vars.swap_unit, arg_31_1, arg_31_2)
	end
end

function GroupFormationEditor.getUnit(arg_32_0, arg_32_1, arg_32_2)
	return (arg_32_0.vars.control_groups[arg_32_1].vars.model_ids[arg_32_2] or {}).unit
end

function GroupFormationEditor.getUnitGroup(arg_33_0, arg_33_1)
	if arg_33_0.vars.is_burning and arg_33_0.vars.selected_group then
		local var_33_0 = arg_33_0.vars.control_groups[arg_33_0.vars.selected_group]
		
		for iter_33_0 = 1, 4 do
			if (var_33_0.vars.model_ids[iter_33_0] or {}).unit == arg_33_1 then
				return var_33_0.vars.group_name, iter_33_0
			end
		end
	else
		for iter_33_1, iter_33_2 in pairs(arg_33_0.vars.control_groups) do
			for iter_33_3 = 1, 4 do
				if (iter_33_2.vars.model_ids[iter_33_3] or {}).unit == arg_33_1 then
					return iter_33_2.vars.group_name, iter_33_3
				end
			end
		end
	end
	
	return "None"
end

function GroupFormationEditor.getUnitCount(arg_34_0, arg_34_1)
	local var_34_0 = 0
	local var_34_1 = arg_34_0.vars.control_groups[arg_34_1] or {}
	
	if not var_34_1 or not var_34_1.vars then
		return var_34_0
	end
	
	for iter_34_0, iter_34_1 in pairs(var_34_1.vars.model_ids or {}) do
		if iter_34_1 then
			var_34_0 = var_34_0 + 1
		end
	end
	
	return var_34_0
end

function GroupFormationEditor.swapUnit(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = {}
	
	if arg_35_1 then
		local var_35_1, var_35_2 = arg_35_0:getUnitGroup(arg_35_1)
		local var_35_3 = arg_35_0.vars.control_groups[var_35_1]
		local var_35_4 = arg_35_0.vars.control_groups[arg_35_2]
		
		if arg_35_0.vars.is_burning then
			if arg_35_0.vars.key_slot_idx == arg_35_3 then
				for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.control_groups) do
					iter_35_1:addToTeam(arg_35_1, arg_35_3, true)
					
					var_35_0[iter_35_0] = {
						unit = arg_35_1
					}
				end
			elseif var_35_2 and var_35_2 == arg_35_0.vars.key_slot_idx then
				local var_35_5 = arg_35_0:getUnit(arg_35_2, arg_35_3)
				
				if var_35_5 then
					for iter_35_2, iter_35_3 in pairs(arg_35_0.vars.control_groups) do
						iter_35_3:addToTeam(var_35_5, var_35_2, true)
						
						var_35_0[iter_35_2] = {
							unit = var_35_5
						}
					end
				else
					for iter_35_4, iter_35_5 in pairs(arg_35_0.vars.control_groups) do
						iter_35_5:removeFromTeam(arg_35_1, var_35_2, true)
						
						var_35_0[iter_35_4] = {
							unit = arg_35_1
						}
					end
					
					if arg_35_3 then
						arg_35_0.vars.control_groups[arg_35_2]:addToTeam(arg_35_1, arg_35_3)
						
						var_35_0[arg_35_2] = {
							unit = arg_35_1 or nil
						}
					end
				end
			elseif var_35_1 == "None" or var_35_1 == arg_35_2 then
				var_35_4:addToTeam(arg_35_1, arg_35_3, true)
				
				var_35_0[arg_35_2] = {
					unit = arg_35_1
				}
			elseif var_35_1 then
				local var_35_6 = arg_35_0:getUnit(arg_35_2, arg_35_3)
				
				if var_35_6 then
					var_35_4:removeFromTeam(var_35_6, arg_35_3)
				end
				
				var_35_3:removeFromTeam(arg_35_1, var_35_2)
				
				if var_35_6 then
					var_35_3:addToTeam(var_35_6, var_35_2)
					
					var_35_0[var_35_1] = {
						unit = var_35_6 or nil
					}
				end
				
				var_35_4:addToTeam(arg_35_1, arg_35_3)
				
				var_35_0[arg_35_2] = {
					unit = arg_35_1
				}
				var_35_0[var_35_1] = {
					unit = var_35_6 or nil
				}
			end
		elseif arg_35_0.vars.use_duplicate then
			var_35_4:addToTeam(arg_35_1, arg_35_3, true)
			
			var_35_0[arg_35_2] = {
				unit = arg_35_1
			}
		elseif var_35_1 == "None" or var_35_1 == arg_35_2 then
			var_35_4:addToTeam(arg_35_1, arg_35_3, true)
			
			var_35_0[arg_35_2] = {
				unit = arg_35_1
			}
		elseif var_35_1 then
			local var_35_7 = arg_35_0:getUnit(arg_35_2, arg_35_3)
			
			if var_35_7 then
				var_35_4:removeFromTeam(var_35_7, arg_35_3)
			end
			
			var_35_3:removeFromTeam(arg_35_1, var_35_2)
			
			if var_35_7 then
				var_35_3:addToTeam(var_35_7, var_35_2)
				
				var_35_0[var_35_1] = {
					unit = var_35_7 or nil
				}
			end
			
			var_35_4:addToTeam(arg_35_1, arg_35_3)
			
			var_35_0[arg_35_2] = {
				unit = arg_35_1
			}
			var_35_0[var_35_1] = {
				unit = var_35_7 or nil
			}
		end
	end
	
	vibrate(VIBRATION_TYPE.Select)
	
	arg_35_0.vars.formation_dirty = true
	
	arg_35_0:setNormalMode()
	
	for iter_35_6, iter_35_7 in pairs(var_35_0) do
		arg_35_0.vars.control_groups[iter_35_6]:updateFormation()
		
		if iter_35_7 and iter_35_7.unit then
			arg_35_0.vars.control_groups[iter_35_6]:playBatchEffect(iter_35_7.unit, arg_35_3)
		end
	end
end

function GroupFormationEditor.changeButtonState(arg_36_0, arg_36_1, arg_36_2)
	arg_36_2 = arg_36_2 or {}
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0.vars.control_groups) do
		local var_36_0 = iter_36_1:getTeamMemberCount(true)
		
		for iter_36_2 = 1, iter_36_1.vars.placable_base_count do
			local var_36_1 = iter_36_1:isInTeam(arg_36_1)
			
			if not iter_36_1:getTeam(iter_36_1.vars.team_idx)[iter_36_2] then
				local var_36_2 = MAX_CLAN_TEAM_UNIT
				
				if arg_36_0.vars.max_unit then
					var_36_2 = arg_36_0.vars.max_unit
				end
				
				if iter_36_1.getMaxPlacablePos then
					var_36_2 = iter_36_1:getMaxPlacablePos()
				end
				
				if var_36_2 <= var_36_0 and not var_36_1 then
					iter_36_1:showChangeButton(iter_36_2, false)
				else
					iter_36_1:showChangeButton(iter_36_2, iter_36_1:isPlacablePos(arg_36_1, iter_36_2), arg_36_2.ignore_unit)
				end
			elseif arg_36_0:getUnit(iter_36_0, iter_36_2) == arg_36_1 then
				iter_36_1:showChangeButton(iter_36_2, false)
			else
				iter_36_1:showChangeButton(iter_36_2, iter_36_1:isPlacablePos(arg_36_1, iter_36_2))
			end
		end
	end
	
	arg_36_0.vars.formation_dirty = true
end

function GroupFormationEditor.readyToChangeUnit(arg_37_0, arg_37_1, arg_37_2)
	print("STATE : readyToChange")
	
	arg_37_0.vars.formation_status = "ReadyToChangeUnit"
	
	arg_37_0:setAllEditors_states()
	
	local var_37_0 = arg_37_0:getUnit(arg_37_0.vars.selected_group, arg_37_0.vars.selected_pos)
	local var_37_1 = arg_37_0.vars.control_groups[arg_37_1]
	
	if var_37_1 and var_37_1.vars.model_ids[arg_37_2] then
		local var_37_2 = var_37_1.vars.formation_wnd
		local var_37_3, var_37_4 = var_37_2:getChildByName("btn_change_" .. arg_37_2):getPosition()
		local var_37_5 = var_37_2:getChildByName("selected_btn")
		local var_37_6 = var_37_5:getChildByName("btn_team_detail")
		local var_37_7 = var_37_5:getChildByName("btn_remove")
		
		arg_37_0.vars.selected_idx = arg_37_2
		
		var_37_5:setVisible(true)
		var_37_5:setPosition(var_37_3 + var_37_6:getContentSize().width / 2, var_37_4)
		
		if var_37_1.opts and var_37_1.opts.use_detail and UnitMain:isUsablePopupScene(SceneManager:getCurrentSceneName()) then
			var_37_6:setVisible(true)
			var_37_6:setPositionX(0)
			var_37_7:setPositionX(-90)
		else
			var_37_6:setVisible(false)
			var_37_7:setPositionX(-45)
		end
		
		local var_37_8 = var_37_2:getChildByName("base" .. arg_37_2)
		
		if var_37_8 then
			local var_37_9 = var_37_8:getContentSize()
			local var_37_10 = var_37_8:getAnchorPoint()
			local var_37_11 = var_37_8:getScaleX()
			local var_37_12 = var_37_8:getScaleY()
			
			var_37_1.vars.blinking_marks = {}
			
			local var_37_13 = cc.Sprite:create("img/hero_config_panelcursor.png")
			
			table.push(var_37_1.vars.blinking_marks, var_37_13)
			var_37_13:setPosition(var_37_9.width * var_37_10.x, var_37_9.height * var_37_10.y)
			var_37_13:setScaleX(var_37_12)
			var_37_13:setScaleY(var_37_11)
			var_37_13:setRotationSkewX(0 - var_37_8:getRotationSkewY())
			var_37_13:setRotationSkewY(0 - var_37_8:getRotationSkewX())
			var_37_8:addChild(var_37_13)
			UIAction:Add(SEQ(DELAY(200), LOOP(SEQ(LOG(FADE_OUT(400)), LOG(FADE_IN(400))))), var_37_13, "team_ui.blink")
		end
	end
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.control_groups) do
		iter_37_1:setDedicationNotify(var_37_0)
	end
	
	arg_37_0:changeButtonState(var_37_0, {
		ignore_unit = true
	})
end

function GroupFormationEditor.readyToSwapUnit(arg_38_0, arg_38_1)
	print("STATE : readyToSwap")
	
	arg_38_0.vars.formation_status = "ReadyToSwapUnit"
	
	arg_38_0:setAllEditors_states()
	
	arg_38_0.vars.swap_unit = arg_38_1
	
	arg_38_0:changeButtonState(arg_38_1)
end

function GroupFormationEditor.removeUnitFromPos(arg_39_0, arg_39_1)
	if arg_39_0.vars.is_burning and arg_39_0.vars.selected_idx == arg_39_0.vars.key_slot_idx then
		for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.groups) do
			iter_39_1.vars.selected_idx = arg_39_0.vars.selected_idx
			
			iter_39_1:removeUnitFromPos(arg_39_0.vars.selected_idx)
		end
		
		arg_39_0.vars.formation_dirty = true
		arg_39_0.vars.selected_idx = nil
	else
		local var_39_0 = arg_39_0.vars.groups[arg_39_1]
		
		if var_39_0 then
			var_39_0.vars.selected_idx = arg_39_0.vars.selected_idx
			
			var_39_0:removeUnitFromPos(arg_39_0.vars.selected_idx)
			
			arg_39_0.vars.formation_dirty = true
			arg_39_0.vars.selected_idx = nil
		end
	end
end

function GroupFormationEditor.showDedicationPopup(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.vars.groups[arg_40_1]
	
	var_40_0:showDedicationPopup(var_40_0:getFormation_wnd())
end

function GroupFormationEditor.collectModelInfos(arg_41_0, arg_41_1)
	arg_41_0:visit_editors(function(arg_42_0)
		local var_42_0 = {
			group = arg_42_0.vars.group_name,
			units = {}
		}
		
		if arg_42_0.vars.model_ids[3] then
			var_42_0.units[3] = arg_42_0.vars.model_ids[3].model.model
		end
		
		if arg_42_0.vars.model_ids[4] then
			var_42_0.units[4] = arg_42_0.vars.model_ids[4].model.model
		end
		
		if arg_42_0.vars.model_ids[1] then
			var_42_0.units[1] = arg_42_0.vars.model_ids[1].model.model
		end
		
		if arg_42_0.vars.model_ids[2] then
			var_42_0.units[2] = arg_42_0.vars.model_ids[2].model.model
		end
		
		table.insert(arg_41_1, var_42_0)
	end)
end

function GroupFormationEditor.getTeamMemberCount(arg_43_0, arg_43_1)
	for iter_43_0, iter_43_1 in pairs(arg_43_0.vars.control_groups) do
		if iter_43_0 == arg_43_1 then
			return iter_43_1:getTeamMemberCount()
		end
	end
	
	return 0
end
