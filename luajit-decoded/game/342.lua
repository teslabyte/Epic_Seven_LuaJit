UnitSupport = {}

copy_functions(Formation, UnitSupport)
copy_functions(FormationEditor, UnitSupport)

function UnitSupport.onTouchDown(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars.touch_pos = arg_1_1:getLocation()
	
	arg_1_2:stopPropagation()
	
	return true
end

function UnitSupport.onTouchMove(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.vars.touch_pos then
		return 
	end
	
	local var_2_0 = arg_2_1:getLocation()
	
	if math.abs(arg_2_0.vars.touch_pos.x - var_2_0.x) > 30 or math.abs(arg_2_0.vars.touch_pos.y - var_2_0.y) > 30 then
		arg_2_0.vars.touch_drag = true
	end
	
	return true
end

function UnitSupport.onTouchUp(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars.touch_drag = nil
end

function UnitSupport.checkModelTouch(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1:getLocation()
	local var_4_1 = {}
	
	if arg_4_0.vars.model_ids[3] then
		var_4_1[3] = arg_4_0.vars.model_ids[3].model
	end
	
	if arg_4_0.vars.model_ids[4] then
		var_4_1[4] = arg_4_0.vars.model_ids[4].model
	end
	
	if arg_4_0.vars.model_ids[1] then
		var_4_1[1] = arg_4_0.vars.model_ids[1].model
	end
	
	if arg_4_0.vars.model_ids[2] then
		var_4_1[2] = arg_4_0.vars.model_ids[2].model
	end
	
	if_set_visible(arg_4_0.vars.wnd, "n_teamlist", false)
	if_set_visible(arg_4_0.vars.wnd, "n_infos", false)
	
	local var_4_2 = slowpick(arg_4_0.vars.form_node, var_4_1, var_4_0.x, var_4_0.y)
	
	if_set_visible(arg_4_0.vars.wnd, "n_teamlist", true)
	if_set_visible(arg_4_0.vars.wnd, "n_infos", true)
	
	if var_4_2 then
		arg_4_0.vars.touched_model_idx = var_4_2
		
		return true
	end
end

function UnitSupport.onCreate(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("unit_support", true, "wnd")
	arg_5_0.vars.wnd.class = arg_5_0
	arg_5_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	
	UnitMain.vars.base_wnd:addChild(arg_5_0.vars.wnd)
	FormationEditor:initFormationEditor(arg_5_0, {
		use_detail = true,
		ignore_team_selector = true,
		btns_ignore_notch = true,
		support_mode = true,
		wnd = arg_5_0.vars.wnd,
		callbackSelectTeam = function(arg_6_0)
			arg_5_0:setTeam(arg_6_0)
		end,
		callbackSelectUnit = function(arg_7_0)
			arg_5_0.vars.hero_belt:scrollToUnit(arg_7_0)
		end
	})
	arg_5_0:setFormationEditMode(true)
	arg_5_0:setTeam(12)
	arg_5_0:updateFormation()
	
	for iter_5_0 = 1, 7 do
		if_set_opacity(arg_5_0.vars.wnd, "slot" .. iter_5_0, 0)
	end
	
	if_set_opacity(arg_5_0.vars.wnd, "n_info", 0)
	if_set_opacity(arg_5_0.vars.wnd, "n_btns", 0)
	TopBarNew:forcedHelp_OnOff(false)
end

function UnitSupport.updateUI(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	arg_8_0:updateFormation()
	
	if arg_8_0.vars.hero_belt and arg_8_0.vars.hero_belt:isValid() then
		arg_8_0.vars.hero_belt:update()
	end
end

function UnitSupport.updateFormation(arg_9_0)
	arg_9_0:updateFormation()
end

function UnitSupport.onSelectUnit(arg_10_0, arg_10_1)
end

function UnitSupport.onPushBackground(arg_11_0)
	if not arg_11_0.vars.touched_model_idx then
		arg_11_0:setNormalMode()
	end
end

function UnitSupport.onCancelButton(arg_12_0)
	arg_12_0:setNormalMode()
end

function UnitSupport.close(arg_13_0)
	arg_13_0:removeModeEffects()
end

function UnitSupport.onEnter(arg_14_0, arg_14_1, arg_14_2)
	arg_14_2 = arg_14_2 or {}
	
	for iter_14_0 = 1, 7 do
		arg_14_0:updateHeroTag(iter_14_0, nil, nil)
	end
	
	local var_14_0 = arg_14_0.vars.hero_belt:getCurrentControl()
	
	if var_14_0 then
		var_14_0.add:setVisible(true)
	end
	
	arg_14_0:setNormalMode()
	arg_14_0:setFormationEditMode(true)
	
	for iter_14_1 = 1, 7 do
		eff_slide_in(arg_14_0.vars.wnd, "slot" .. iter_14_1, 300, iter_14_1 * 50)
	end
	
	UIAction:Add(FADE_IN(300), arg_14_0.vars.wnd:getChildByName("n_info"))
	UIAction:Add(FADE_IN(300), arg_14_0.vars.wnd:getChildByName("n_btns"))
	TutorialGuide:startGuide(UNLOCK_ID.SUPPORT)
	SoundEngine:play("event:/ui/menu/menu_2")
	
	if arg_14_1 then
		TopBarNew:setTitleName(T("hero"))
		UnitMain:showUnitList(true)
	end
	
	arg_14_0.vars.hero_belt:getWindow():setLocalZOrder(999998)
end

function UnitSupport.onLeave(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.hero_belt:getCurrentControl()
	
	if var_15_0 then
		var_15_0.add:setVisible(false)
	end
	
	for iter_15_0 = 1, 7 do
		eff_slide_out(arg_15_0.vars.wnd, "slot" .. iter_15_0, 200, iter_15_0 * 20)
	end
	
	UIAction:Add(SEQ(FADE_OUT(350), REMOVE()), arg_15_0.vars.wnd, "block")
	arg_15_0:setFormationEditMode(false)
	arg_15_0:saveTeamInfo()
end

function UnitSupport.showTeamFormation(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0.vars and arg_16_0.vars.form_node then
		if arg_16_2 then
			local var_16_0
			
			if arg_16_1 then
				var_16_0 = FADE_IN(arg_16_2)
			else
				var_16_0 = FADE_OUT(arg_16_2)
			end
			
			UIAction:Add(SEQ(var_16_0, SHOW(arg_16_1)), arg_16_0.vars.form_node, "block")
			UIAction:Add(SEQ(var_16_0, SHOW(arg_16_1)), arg_16_0.vars.hero_belt:getWindow(), "block")
		else
			arg_16_0.vars.form_node:setVisible(arg_16_1)
			arg_16_0.vars.hero_belt:setVisible(arg_16_1)
		end
	end
end

function UnitSupport.onUnitDetail(arg_17_0, arg_17_1)
	UnitMain:setMode("Detail", {
		unit = arg_17_1
	})
end

function UnitSupport.onPushBackButton(arg_18_0)
	arg_18_0:saveTeamInfo()
	UnitMain:setMode("Main")
end

function UnitSupport.setAutoSupport(arg_19_0)
	local var_19_0 = {
		{},
		{
			role = "warrior"
		},
		{
			role = "knight"
		},
		{
			role = "assassin"
		},
		{
			role = "ranger"
		},
		{
			role = "mage"
		},
		{
			role = "manauser"
		}
	}
	local var_19_1
	local var_19_2 = {}
	
	for iter_19_0, iter_19_1 in pairs(Account.units) do
		if iter_19_1.db.role ~= "material" and not iter_19_1:isMoonlightDestinyUnit() and not iter_19_1:isGrowthBoostRegistered() then
			local var_19_3 = iter_19_1:getPoint()
			
			if var_19_3 > to_n(var_19_2.score) then
				var_19_2.score = var_19_3
				var_19_2.unit = iter_19_1
			end
		end
	end
	
	var_19_0[1] = var_19_2
	
	for iter_19_2, iter_19_3 in pairs(Account.units) do
		if iter_19_3.inst.uid ~= var_19_2.unit.inst.uid and not iter_19_3:isMoonlightDestinyUnit() and not iter_19_3:isGrowthBoostRegistered() then
			for iter_19_4 = 2, 7 do
				local var_19_4 = var_19_0[iter_19_4]
				
				if iter_19_3.db.role == var_19_4.role then
					local var_19_5 = iter_19_3:getPoint()
					
					if var_19_5 > to_n(var_19_4.score) then
						var_19_4.score = var_19_5
						var_19_4.unit = iter_19_3
					end
				end
			end
		end
	end
	
	local var_19_6
	
	for iter_19_5, iter_19_6 in pairs(var_19_0) do
		if iter_19_6.unit then
			Account:addToTeam(iter_19_6.unit, 12, iter_19_5, true)
			
			var_19_6 = true
		end
	end
	
	if var_19_6 then
		arg_19_0:setFormationDirtyFlag(true)
		arg_19_0:updateFormation()
		balloon_message_with_sound("fin_auto_support")
	end
end
