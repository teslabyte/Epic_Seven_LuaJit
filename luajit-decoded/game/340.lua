CustomFormation = {}

copy_functions(Formation, CustomFormation)

CustomFormationEditor = {}

copy_functions(FormationEditor, CustomFormationEditor)

function CustomFormation.initFormation(arg_1_0, arg_1_1, arg_1_2)
	copy_functions(FormationBase, arg_1_1)
	copy_functions(CustomFormation, arg_1_1)
	
	arg_1_1.opts = arg_1_2
	arg_1_1.vars = arg_1_1.vars or {}
	arg_1_1.vars.model_ids = {}
	arg_1_1.vars.pvp_info = arg_1_2.pvp_info
	arg_1_1.vars.is_enemy = arg_1_2.is_enemy
	arg_1_1.vars.ignore_team_selector = true
	arg_1_1.vars.base_count = 4
	arg_1_1.vars.placable_base_count = 4
	arg_1_1.vars.max_unit = arg_1_2.max_unit or 4
	arg_1_1.vars.key_slot_idx = arg_1_2.key_slot_idx
	
	if arg_1_2.sprite_mode then
		arg_1_1.vars.model_mode = "Sprite"
	end
	
	arg_1_1:setFormWindow(arg_1_1.vars.formation_wnd)
	
	if not arg_1_1.vars.ignore_team_selector then
		FormationTeamSelector:initTeamSelector(arg_1_1, arg_1_2)
	end
	
	if arg_1_1.vars.pvp_info and arg_1_1.vars.pvp_info.defend_mode then
		arg_1_1.vars.form_node:getChildByName("scrollview_team"):setVisible(false)
	end
	
	if arg_1_2.can_edit then
		Scheduler:removeByName(arg_1_1.vars.group_name)
		Scheduler:addSlow(arg_1_1.vars.form_node, function()
			Formation.updateProgressingUnit(arg_1_1)
		end):setName(arg_1_1.vars.group_name)
	end
	
	if_set_visible(arg_1_2.wnd, "n_team_info", arg_1_2.npcteam_id)
	
	if arg_1_2.npcteam_id then
		local var_1_0 = arg_1_2.wnd:getChildByName("n_team_info")
		
		if get_cocos_refid(var_1_0) then
			local var_1_1 = DB("level_monstergroup_npcteam", arg_1_2.npcteam_id, "team_title")
			
			if_set(var_1_0, "t_name", T(var_1_1))
			
			local var_1_2 = var_1_0:getChildByName("t_name")
			local var_1_3 = var_1_0:getChildByName("t_disc")
			
			if get_cocos_refid(var_1_2) and get_cocos_refid(var_1_3) then
				if var_1_2:getStringNumLines() == 1 and not var_1_3.origin_y then
					var_1_3.origin_y = var_1_3:getPositionY()
					
					var_1_3:setPositionY(var_1_3.origin_y + 24)
				end
				
				if arg_1_2.npc_text_change then
					if_set(var_1_3, nil, T("npcteam_onetime_desc"))
				end
			end
		end
	end
	
	if_set_visible(arg_1_2.wnd, "btn_team_detail", false)
	
	return arg_1_1
end

function CustomFormation.getTeamIndex(arg_3_0, arg_3_1)
	return nil
end

function CustomFormationEditor.initFormationEditor(arg_4_0, arg_4_1, arg_4_2)
	arg_4_1.vars = arg_4_1.vars or {}
	arg_4_1.vars.formation_wnd = arg_4_2.wnd
	arg_4_2.wnd.class = arg_4_1
	
	CustomFormation:initFormation(arg_4_1, arg_4_2)
	copy_functions(CustomFormationEditor, arg_4_1)
	
	if not arg_4_2.notUseTouchHandler then
		HANDLER[arg_4_2.wnd:getName()] = defaultFormationEditEventHandler
		
		Scheduler:removeByName("FormationEditor_Scheduler")
		Scheduler:add(arg_4_2.wnd, arg_4_1.procTouchUnit, arg_4_1):setName("FormationEditor_Scheduler")
	end
	
	arg_4_1:setNormalMode()
	
	local var_4_0 = arg_4_1.vars.formation_wnd:getChildByName("n_formation")
	
	if var_4_0 then
		if_set_visible(var_4_0, "t_pos1", false)
		if_set_visible(var_4_0, "t_pos2", false)
		if_set_visible(var_4_0, "t_pos3", false)
		if_set_visible(var_4_0, "t_pos4", false)
	end
	
	if arg_4_2.wnd and arg_4_2.npcteam_id then
		if_set_opacity(arg_4_2.wnd, "n_btn_dedi", 76.5)
	end
end

function CustomFormationEditor.swapPosition(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.vars.custom_team[arg_5_1]
	
	if not var_5_0 then
		return 
	end
	
	vibrate(VIBRATION_TYPE.Select)
	arg_5_0:addToTeam(var_5_0, arg_5_2, true)
	
	arg_5_0.vars.formation_dirty = true
	
	arg_5_0:setNormalMode()
	arg_5_0:updateFormation()
	arg_5_0:playBatchEffect(var_5_0)
end

function CustomFormationEditor.showChangeButton(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0.vars.formation_wnd:getChildByName("btn_change_" .. arg_6_1)
	
	var_6_0:setVisible(arg_6_2)
	
	local var_6_1 = arg_6_0.vars.custom_team
	
	if arg_6_3 or var_6_1[arg_6_1] then
		var_6_0:loadTextures("img/hero_config_btn_change.png", "img/hero_config_btn_change.png")
	else
		var_6_0:loadTextures("img/hero_config_btn_add.png", "img/hero_config_btn_add.png")
	end
end

function CustomFormationEditor.getTeamMemberCount(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.custom_team
	local var_7_1 = 0
	local var_7_2 = 5
	
	if arg_7_1 then
		var_7_2 = 4
	end
	
	for iter_7_0 = 1, var_7_2 do
		if var_7_0[iter_7_0] then
			var_7_1 = var_7_1 + 1
		end
	end
	
	return var_7_1
end

function CustomFormationEditor.isInTeam(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.custom_team
	
	for iter_8_0 = 1, 7 do
		if var_8_0[iter_8_0] and arg_8_1 and var_8_0[iter_8_0]:getUID() == arg_8_1:getUID() then
			return true
		end
	end
	
	return false
end

function CustomFormationEditor.getMaxPlacablePos(arg_9_0)
	return arg_9_0.vars.max_unit
end

function CustomFormationEditor.isPlacablePos(arg_10_0, arg_10_1, arg_10_2)
	return not (arg_10_2 > arg_10_0.vars.placable_base_count)
end

function CustomFormationEditor.removeUnitFromPos(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.vars.model_ids[arg_11_0.vars.selected_idx].unit
	
	arg_11_0.vars.formation_dirty = true
	
	arg_11_0:removeFromTeam(var_11_0)
	arg_11_0:updateFormation()
end

function CustomFormationEditor.addToTeam(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.vars.custom_team
	local var_12_1 = arg_12_0:getTeamPos(arg_12_1, var_12_0)
	local var_12_2 = false
	
	if var_12_1 then
		if arg_12_3 and var_12_0[var_12_1] then
			var_12_0[var_12_1] = var_12_0[arg_12_2]
			
			local var_12_3 = true
		else
			arg_12_0:removeFromTeam(arg_12_1, var_12_0)
		end
	end
	
	for iter_12_0 = 1, 7 do
		local var_12_4 = var_12_0[iter_12_0]
		
		if var_12_4 and var_12_4.db.code == arg_12_1.db.code and arg_12_2 ~= iter_12_0 then
			print("duplicate unit!")
			
			return 
		end
	end
	
	var_12_0[arg_12_2] = arg_12_1
end

function CustomFormationEditor.removeFromTeam(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.vars.custom_team
	
	arg_13_2 = arg_13_2 or arg_13_0:getTeamPos(arg_13_1)
	var_13_0[arg_13_2] = nil
end

function CustomFormationEditor.getTeam(arg_14_0)
	return arg_14_0.vars.custom_team
end

function CustomFormationEditor.getBattleTeam(arg_15_0)
	local var_15_0 = Team:makeTeamData(arg_15_0.vars.custom_team)
	
	return (Team:makeTeam(var_15_0))
end

function CustomFormationEditor.getTeamPos(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.custom_team
	
	for iter_16_0 = 1, 7 do
		local var_16_1 = var_16_0[iter_16_0]
		
		if var_16_1 and var_16_1.inst.uid == arg_16_1.inst.uid then
			return iter_16_0
		end
	end
	
	return false
end

function CustomFormationEditor.swapUnit(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:addToTeam(arg_17_1, arg_17_2, true)
	vibrate(VIBRATION_TYPE.Select)
	
	arg_17_0.vars.formation_dirty = true
	
	arg_17_0:setNormalMode()
	arg_17_0:updateFormation()
	arg_17_0:playBatchEffect(arg_17_1)
end

function CustomFormationEditor.haveSameVariationGroupInTeam(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.custom_team
	
	if arg_18_1 == nil or arg_18_1.db.variation_group == nil then
		return false
	end
	
	for iter_18_0 = 1, 5 do
		if var_18_0[iter_18_0] and var_18_0[iter_18_0]:getUID() ~= arg_18_1:getUID() and var_18_0[iter_18_0]:isSameVariationGroupOnlyPlayer(arg_18_1) then
			return iter_18_0
		end
	end
	
	return false
end

function CustomFormationEditor.getTeamUnitPosByCode(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0.vars.custom_team
	
	for iter_19_0 = 1, 5 do
		if var_19_0[iter_19_0] and var_19_0[iter_19_0].inst.code == arg_19_1 and (not arg_19_2 or arg_19_2 ~= var_19_0[iter_19_0]) then
			return iter_19_0
		end
	end
	
	return nil
end

function CustomFormationEditor.change_position(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_1 then
		return 
	end
	
	local var_20_0
	
	var_20_0 = arg_20_2 or {}
	
	local var_20_1 = Account:getTeamPos(arg_20_1, arg_20_0.vars.custom_team) or 0
	local var_20_2 = {}
	
	if var_20_1 then
		table.insert(var_20_2, var_20_1)
	else
		table.insert(var_20_2, 0)
	end
	
	return var_20_2
end

function CustomFormationEditor.updateFormation(arg_21_0, arg_21_1)
	if arg_21_1 then
		arg_21_0.vars.custom_team = arg_21_1
	end
	
	for iter_21_0 = 1, arg_21_0.vars.base_count do
		arg_21_0:setModelTo(iter_21_0, arg_21_0.vars.custom_team[iter_21_0], nil)
	end
	
	if_set_visible(arg_21_0.vars.form_node, "base_sinsu", false)
	
	if not arg_21_0.vars.ignore_team_selector then
		FormationTeamSelector:updateTeamInfo()
	end
	
	arg_21_0:updateTeamPoint(arg_21_0.vars.custom_team)
	arg_21_0:updateTeamArtifactBonus(arg_21_0.vars.custom_team)
	arg_21_0:updateProgressingUnit()
	arg_21_0:change_buttonImg(arg_21_0.vars.form_node)
	arg_21_0:callback("UpdateFormation", arg_21_0.vars.custom_team)
end

function CustomFormationEditor.playBatchEffect(arg_22_0, arg_22_1)
	local var_22_0, var_22_1 = arg_22_1:getDevoteSkill()
	local var_22_2 = arg_22_1:getDevoteGrade()
	local var_22_3, var_22_4 = DB("character", arg_22_1.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	
	if var_22_1 == 0 or not var_22_3 or not var_22_4 then
		return 
	end
	
	local var_22_5 = string.split(var_22_4, ";")
	
	for iter_22_0, iter_22_1 in pairs(var_22_5) do
		local var_22_6 = arg_22_0.vars.formation_wnd:getChildByName("pos" .. iter_22_1)
		
		if get_cocos_refid(var_22_6) then
			local var_22_7 = arg_22_0.vars.custom_team[tonumber(iter_22_1)]
			
			if var_22_7 and var_22_7 ~= arg_22_1 then
				set_high_fps_tick(5000)
				
				local var_22_8 = arg_22_0.vars.pvp_info and 0.9 or 1.15
				local var_22_9 = EffectManager:Play({
					pivot_x = 0,
					fn = "ui_hero_config_buffset_front.cfx",
					pivot_y = -5,
					pivot_z = 1,
					layer = var_22_6,
					scale = var_22_8
				})
				local var_22_10 = EffectManager:Play({
					pivot_x = 0,
					fn = "ui_hero_config_buffset_back.cfx",
					pivot_y = -5,
					pivot_z = -1,
					layer = var_22_6,
					scale = var_22_8
				})
				
				var_22_9:setOpacity(110)
				var_22_10:setOpacity(150)
				
				local var_22_11 = var_22_6:getChildByName("t_pos" .. iter_22_1)
				
				if get_cocos_refid(var_22_11) then
					local var_22_12, var_22_13 = arg_22_1:getDevoteGrade()
					local var_22_14 = arg_22_1:getDevoteColor(var_22_12)
					
					if not var_22_11.origin_x then
						var_22_11.origin_x, var_22_11.origin_y = var_22_11:getPosition()
					end
					
					var_22_11:setPosition(var_22_11.origin_x, var_22_11.origin_y + 150)
					var_22_11:setVisible(true)
					var_22_11:setColor(var_22_14)
					var_22_11:setString(getStatName(var_22_0) .. " + " .. to_var_str(var_22_1, var_22_0, 1))
					var_22_11:setOpacity(255)
					var_22_11:setLocalZOrder(10000)
					
					local var_22_15, var_22_16 = var_22_6:getPosition()
					
					UIAction:Add(SEQ(SPAWN(SEQ(LOG(SCALE(200, 0.1, 1.2)), RLOG(SCALE(100, 1.2, 1))), LOG(MOVE_TO(150, var_22_11.origin_x, var_22_11.origin_y + arg_22_0:getModelHeight(tonumber(iter_22_1)) + 100))), DELAY(500), LOG(FADE_OUT(500)), SHOW(false)), var_22_11)
				end
			end
		end
	end
end
