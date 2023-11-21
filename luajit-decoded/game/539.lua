UnitZodiacPotential = {}

copy_functions(UnitZodiacBase, UnitZodiacPotential)

function UnitZodiacPotential.hide(arg_1_0)
	if arg_1_0.vars and get_cocos_refid(arg_1_0.vars.poten_layer) then
		arg_1_0.vars.poten_layer:setVisible(false)
	end
end

function UnitZodiacPotential.onEnter(arg_2_0, arg_2_1)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.poten_layer) then
		return 
	end
	
	arg_2_0.vars.poten_layer:setVisible(false)
	arg_2_0.vars.poten_layer:setScale(0)
	arg_2_0.vars.poten_layer:setOpacity(0)
	arg_2_0:onModeEnter()
end

function UnitZodiacPotential.onLeave(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	arg_3_0:onModeLeave()
	
	arg_3_0.vars = nil
end

function UnitZodiacPotential.onAfterUpdate(arg_4_0)
	if arg_4_0.vars then
		local var_4_0 = math.sin(uitick() / 2861 * 3.141592 / 2)
		local var_4_1 = math.sin(uitick() / 2179 * 3.141592 / 2)
		
		if get_cocos_refid(arg_4_0.vars.layer) then
			arg_4_0.vars.layer:setScaleX((var_4_1 + 1) / 2 * 0.03 + 1)
			arg_4_0.vars.layer:setScaleY((var_4_0 + 1) / 2 * 0.03 + 1)
		end
		
		if get_cocos_refid(arg_4_0.vars.eff_layer) then
			arg_4_0.vars.eff_layer:setScaleX((var_4_1 + 1) / 2 * 0.03 + 1)
			arg_4_0.vars.eff_layer:setScaleY((var_4_0 + 1) / 2 * 0.03 + 1)
		end
	end
end

function UnitZodiacPotential.onModeEnter(arg_5_0, arg_5_1)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.poten_layer) then
		return 
	end
	
	arg_5_0.vars.poten_layer:setScale(1)
	arg_5_0.vars.poten_layer:setOpacity(0)
	UnitZodiac:removeStars()
	arg_5_0:playBGEffect()
	
	if TutorialGuide:isPlayingTutorial("char_awake_unlock") then
		UIAction:Add(SEQ(DELAY(400), CALL(function()
			arg_5_0:playUnlockEffect()
		end)), arg_5_0.vars.poten_layer, "block")
	else
		UIAction:Add(SEQ(DELAY(arg_5_1 and 200 or 0), CALL(function()
			arg_5_0:playCircleEffect()
		end), SPAWN(BEZIER(SCALE(467, 8, 1), {
			0,
			0.45,
			0.55,
			1
		}), FADE_IN(467)), CALL(function()
			arg_5_0:createFlag()
		end)), arg_5_0.vars.poten_layer, "block")
	end
end

function UnitZodiacPotential.onModeLeave(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_9_0.vars.poten_layer) and arg_9_0.vars.poten_layer:isVisible() then
		arg_9_0.vars.poten_layer:setScale(1)
		UIAction:Add(SEQ(SPAWN(SCALE(200, 1, 2.5), FADE_OUT(200)), CALL(function()
			arg_9_0:removeCircleEffect()
		end), SHOW(false)), arg_9_0.vars.poten_layer, "block")
	end
	
	arg_9_0:removeBGEffect()
	arg_9_0:removeFlag()
end

function UnitZodiacPotential.createBaseLayer(arg_11_0, arg_11_1)
	local var_11_0 = (arg_11_1 or {}).parent or UnitZodiac:getWindos()
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	if not UnitZodiac:getUnit() then
		return 
	end
	
	if DB("char_awake", arg_11_0:getStoneID(nil, 1), "id") ~= nil then
		arg_11_0.vars.layer = cc.Layer:create()
		arg_11_0.vars.poten_layer = cc.Layer:create()
		
		arg_11_0.vars.layer:addChild(arg_11_0.vars.poten_layer)
		arg_11_0.vars.poten_layer:setCascadeOpacityEnabled(true)
		arg_11_0.vars.poten_layer:ignoreAnchorPointForPosition(false)
		arg_11_0.vars.poten_layer:setAnchorPoint(0.5, 0.5)
		
		local var_11_1, var_11_2 = UnitZodiac:getOffsetPos()
		
		arg_11_0.vars.poten_layer:setPosition(-var_11_1, -var_11_2)
		var_11_0:addChild(arg_11_0.vars.layer)
		UnitZodiac:push_BGLayer({
			arg_11_0.vars.poten_layer,
			0.5,
			1.6
		})
		
		arg_11_0.vars.wnd = load_dlg("unit_zodiac_potential", true, "wnd")
		
		arg_11_0.vars.wnd:setLocalZOrder(1)
		arg_11_0.vars.wnd:setAnchorPoint(0.5, 0.5)
		arg_11_0.vars.poten_layer:addChild(arg_11_0.vars.wnd)
		arg_11_0.vars.wnd:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		
		arg_11_0.vars.stones = {}
		arg_11_0.vars.lines = {}
		arg_11_0.vars.effs = {}
		
		for iter_11_0 = 1, 6 do
			local var_11_3 = arg_11_0.vars.wnd:getChildByName(iter_11_0)
			
			if not var_11_3 then
				break
			end
			
			local var_11_4 = arg_11_0:createStoneNode(iter_11_0)
			
			arg_11_0.vars.stones[iter_11_0] = var_11_3
			
			arg_11_0.vars.stones[iter_11_0]:addChild(var_11_4)
			arg_11_0:addEmptyButton(var_11_3, tostring(iter_11_0), 80, 80)
			
			arg_11_0.vars.lines[iter_11_0] = arg_11_0.vars.wnd:getChildByName("n_on_" .. iter_11_0)
		end
		
		arg_11_0.vars.reward_icons = {}
		arg_11_0.vars.reward_skills = {}
		
		return true
	end
end

function UnitZodiacPotential.getHelpID(arg_12_0)
	return "growth_7"
end

function UnitZodiacPotential.playBGEffect(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	local var_13_0 = UnitZodiac:getWindos()
	local var_13_1 = DESIGN_WIDTH / 2
	local var_13_2 = DESIGN_HEIGHT / 2
	
	arg_13_0.vars.bg = EffectManager:Play({
		z = -10,
		fn = "ui_awaken_libration_glbg_idle.cfx",
		layer = var_13_0,
		x = var_13_1,
		y = var_13_2
	})
	
	UnitZodiac:push_BGLayer({
		arg_13_0.vars.bg,
		0.2,
		1.1
	})
	
	if get_cocos_refid(arg_13_0.vars.bg) then
		arg_13_0.vars.bg:setOpacity(0)
		UIAction:Add(SEQ(SPAWN(FADE_IN(667), LOG(SCALE(667, 2, 1)))), arg_13_0.vars.bg, "block")
	end
end

function UnitZodiacPotential.removeBGEffect(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_14_0.vars.bg) then
		UIAction:Add(SEQ(LOG(SPAWN(FADE_OUT(667), SCALE(667, 1, 2))), REMOVE()), arg_14_0.vars.bg, "block")
		
		arg_14_0.vars.bg = nil
	end
end

function UnitZodiacPotential.playCircleEffect(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.poten_layer) then
		return 
	end
	
	arg_15_0:playCircleIdle()
end

function UnitZodiacPotential.playUnlockEffect(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.poten_layer) then
		return 
	end
	
	arg_16_0.vars.poten_layer:setOpacity(255)
	arg_16_0.vars.poten_layer:setVisible(true)
	arg_16_0.vars.wnd:setOpacity(0)
	
	local var_16_0 = EffectManager:Play({
		z = 1,
		fn = "ui_awaken_libration_intro.cfx",
		layer = arg_16_0.vars.poten_layer,
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	local var_16_1 = 0
	
	if var_16_0 then
		local var_16_2 = var_16_0:getDuration() * 1000
		
		UIAction:Add(SEQ(DELAY(var_16_2 - 400), SPAWN(CALL(function()
			arg_16_0:playCircleIdle()
		end), TARGET(arg_16_0.vars.wnd, FADE_IN(400)), FADE_OUT(400))), var_16_0, "block")
	end
end

function UnitZodiacPotential.playCircleIdle(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.poten_layer) then
		return 
	end
	
	arg_18_0.vars.pp_circle_layer = su.SimplePostProcessLayer:create()
	
	arg_18_0.vars.pp_circle_layer:setCascadeOpacityEnabled(true)
	arg_18_0.vars.pp_circle_layer:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	local var_18_0 = EffectManager:Play({
		fn = "ui_awaken_libration_idle.cfx",
		layer = arg_18_0.vars.pp_circle_layer
	})
	local var_18_1 = cc.GLProgramCache:getInstance():getGLProgram("sprite_filter")
	
	if var_18_1 then
		local var_18_2 = cc.GLProgramState:create(var_18_1)
		
		if var_18_2 then
			var_18_2:setUniformVec2("u_resolution", {
				x = VIEW_WIDTH,
				y = VIEW_HEIGHT
			})
			var_18_2:setUniformFloat("u_ratio", 0)
			arg_18_0.vars.pp_circle_layer:setPostProcessEnabled(true)
			arg_18_0.vars.pp_circle_layer:addProcessGLProgramState(var_18_2, "", 5, 0)
			
			arg_18_0.vars.pp_circle_state = var_18_2
		end
	end
	
	arg_18_0.vars.poten_layer:addChild(arg_18_0.vars.pp_circle_layer)
end

function UnitZodiacPotential.removeCircleEffect(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_19_0.vars.pp_circle_layer) then
		arg_19_0.vars.pp_circle_layer:removeFromParent()
		
		arg_19_0.vars.pp_circle_layer = nil
		arg_19_0.vars.pp_circle_state = nil
	end
end

function UnitZodiacPotential.blurCircleEffect(arg_20_0, arg_20_1)
	if not arg_20_0.vars then
		return 
	end
	
	if arg_20_0.vars.pp_circle_state and get_cocos_refid(arg_20_0.vars.pp_circle_layer) then
		local var_20_0 = cc.mat4.new({
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1,
			1
		})
		local var_20_1 = 98
		local var_20_2 = arg_20_0.vars.pp_circle_state
		
		var_20_2:setUniformMat4("u_kernel", var_20_0)
		var_20_2:setUniformFloat("u_count", var_20_1)
		
		local var_20_3 = arg_20_1 and 0 or 1
		local var_20_4 = arg_20_1 and 1 or 0
		
		UIAction:Add(SPAWN(LINEAR_CALL(250, nil, function(arg_21_0, arg_21_1)
			var_20_2:setUniformFloat("u_ratio", to_n(arg_21_1))
		end, var_20_3, var_20_4)), arg_20_0.vars.pp_circle_layer, "block")
	end
end

function UnitZodiacPotential.regCursor(arg_22_0, arg_22_1)
	if not arg_22_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_22_1) then
		local var_22_0 = arg_22_1:clone()
		
		var_22_0:setVisible(false)
		var_22_0:setLocalZOrder(2)
		arg_22_0.vars.poten_layer:addChild(var_22_0)
		
		arg_22_0.vars.cursor = var_22_0
	end
end

function UnitZodiacPotential.getSkillBonus(arg_23_0, arg_23_1)
	return DB("char_awake", arg_23_0:getStoneID(nil, arg_23_1), "skill_up")
end

function UnitZodiacPotential.getStoneID(arg_24_0, arg_24_1, arg_24_2)
	arg_24_1 = arg_24_1 or UnitZodiac:getUnit()
	
	if not arg_24_1 then
		return ""
	end
	
	return "ca_" .. arg_24_1.db.code .. "_" .. arg_24_2
end

function UnitZodiacPotential.createStoneNode(arg_25_0, arg_25_1, arg_25_2)
	arg_25_2 = arg_25_2 or cc.CSLoader:createNode("wnd/zodiac_stone_potential.csb")
	arg_25_1 = arg_25_1 or arg_25_2.idx
	
	if_set_sprite(arg_25_2, "Sprite_1", arg_25_0:getStoneSprite(arg_25_1))
	
	arg_25_2.idx = arg_25_1
	
	return arg_25_2
end

function UnitZodiacPotential.getStoneSprite(arg_26_0, arg_26_1)
	if arg_26_0:getSkillBonus(arg_26_1) then
		return "img/hero_awaken_stone_core.png"
	else
		local var_26_0 = arg_26_0:getColor(UnitZodiac:getUnit()) or ""
		
		return "img/hero_awaken_stone_" .. var_26_0 .. ".png"
	end
end

function UnitZodiacPotential.addEmptyButton(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0 = ccui.Button:create()
	
	var_27_0:setTouchEnabled(true)
	var_27_0:ignoreContentAdaptWithSize(false)
	var_27_0:setContentSize(arg_27_3, arg_27_4)
	var_27_0:setPosition(arg_27_1:getPosition())
	var_27_0:setName(arg_27_2)
	var_27_0:addTouchEventListener(arg_27_0.onPushMaterial)
	arg_27_0.vars.wnd:addChild(var_27_0)
end

function UnitZodiacPotential.focusIn(arg_28_0, arg_28_1)
	arg_28_1 = tonumber(arg_28_1)
	
	if not arg_28_0.vars.stones[arg_28_1] then
		return 
	end
	
	local var_28_0, var_28_1 = arg_28_0.vars.stones[arg_28_1]:getPosition()
	local var_28_2 = 60
	
	UnitZodiac:updateSidePanel(arg_28_1)
	UnitZodiac:setZoomIndex(arg_28_1)
	UnitZodiac:zoominMaterial(var_28_0 - var_28_2, var_28_1)
	arg_28_0:showFlag(false)
	
	if get_cocos_refid(arg_28_0.vars.cursor) then
		arg_28_0.vars.cursor:setVisible(false)
		arg_28_0.vars.cursor:setOpacity(0)
		
		local var_28_3, var_28_4 = arg_28_0.vars.stones[arg_28_1]:getPosition()
		
		arg_28_0.vars.cursor:setPosition(var_28_3, var_28_4)
		
		local var_28_5 = UnitZodiac:getStoneState(arg_28_1)
		
		if var_28_5 == "locked" then
			if_set(arg_28_0.vars.cursor, "txt_caution", T("need_to_enhance_prev_zodiac_stone"))
		end
		
		if_set_visible(arg_28_0.vars.cursor, "txt_caution", not UnitZodiac:isDictMode() and var_28_5 == "locked")
		UIAction:Add(SEQ(DELAY(190), SHOW(true), SPAWN(FADE_IN(60), SCALE(60, 1.2, 0.8))), arg_28_0.vars.cursor)
	end
	
	local var_28_6 = arg_28_0.vars.wnd:getChildByName("n_circle_zoom")
	
	if get_cocos_refid(var_28_6) then
		UIAction:Add(LOG(FADE_IN(300)), var_28_6, "block")
	end
	
	arg_28_0:blurCircleEffect(true)
end

function UnitZodiacPotential.focusOut(arg_29_0)
	if not UnitZodiac:isDictMode() and arg_29_0:getAwakeLevel() ~= 6 then
		arg_29_0:showFlag(true)
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("n_circle_zoom")
	
	if get_cocos_refid(var_29_0) then
		UIAction:Add(LOG(FADE_OUT(300)), var_29_0, "block")
	end
	
	if get_cocos_refid(arg_29_0.vars.cursor) then
		arg_29_0.vars.cursor:setVisible(false)
	end
	
	arg_29_0:blurCircleEffect(false)
end

function UnitZodiacPotential.updateComponents(arg_30_0, arg_30_1)
	if not arg_30_0:isEnabled() then
		return 
	end
	
	local var_30_0 = math.min(6, arg_30_0:getAwakeLevel())
	
	if UnitZodiac:isDictMode() then
		var_30_0 = 6
	end
	
	arg_30_0:updateStones()
	
	for iter_30_0 = 1, 12 do
		if arg_30_1 and var_30_0 == iter_30_0 then
			arg_30_0:drawLine(iter_30_0, 0, 300)
		elseif iter_30_0 <= var_30_0 then
			arg_30_0:enableLine(iter_30_0)
		end
		
		if iter_30_0 <= var_30_0 and not arg_30_0.vars.effs[iter_30_0] then
			local var_30_1 = 0
			
			if arg_30_1 and var_30_0 == iter_30_0 then
				arg_30_0:playStoneEffect(iter_30_0, var_30_1, "on")
				
				var_30_1 = 500
			end
			
			arg_30_0.vars.effs[iter_30_0] = arg_30_0:playStoneEffect(iter_30_0, var_30_1, "loop")
		end
	end
	
	if arg_30_1 then
		UIAction:Add(SEQ(DELAY(500), CALL(UnitZodiac.updateSidePanel, UnitZodiac, var_30_0, true)), "block")
	end
end

function UnitZodiacPotential.updateStones(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0:isEnabled() then
		return 
	end
	
	if not arg_31_1 then
		for iter_31_0 = 1, 6 do
			arg_31_0:updateStones(arg_31_0.vars.stones[iter_31_0], iter_31_0)
		end
	else
		local var_31_0 = arg_31_0:getStoneState(arg_31_2) == "locked"
		
		if_set_color(arg_31_1, "Sprite_1", var_31_0 and cc.c3b(136, 136, 136) or cc.c3b(255, 255, 255))
	end
end

function UnitZodiacPotential.playStoneEffect(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	if UnitZodiac:isDictMode() then
		return 
	end
	
	arg_32_3 = arg_32_3 or "loop"
	
	local var_32_0, var_32_1 = arg_32_0.vars.stones[arg_32_1]:getPosition()
	local var_32_2 = 1
	local var_32_3 = arg_32_0:getColor(UnitZodiac:getUnit())
	
	if arg_32_0:getSkillBonus(arg_32_1) then
		var_32_3 = "skill"
	end
	
	return EffectManager:Play({
		fn = "zstone_" .. var_32_3 .. "_" .. arg_32_3 .. ".cfx",
		layer = arg_32_0.vars.wnd,
		x = var_32_0,
		y = var_32_1,
		scale = var_32_2,
		delay = arg_32_2
	})
end

function UnitZodiacPotential.getStoneState(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0:getAwakeLevel()
	local var_33_1 = arg_33_1 - 1
	
	if var_33_0 < var_33_1 then
		return "locked"
	elseif var_33_1 == var_33_0 then
		return "current"
	else
		return "unlocked"
	end
end

function UnitZodiacPotential.drawLine(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if not arg_34_0:isEnabled() then
		return 
	end
	
	local var_34_0 = arg_34_0.vars.lines[arg_34_1]
	
	if not get_cocos_refid(var_34_0) then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(arg_34_2), SPAWN(SHOW(true), OPACITY(arg_34_3, 0, 1))), var_34_0, "block")
end

function UnitZodiacPotential.enableLine(arg_35_0, arg_35_1)
	if not arg_35_0:isEnabled() then
		return 
	end
	
	if_set_visible(arg_35_0.vars.lines[arg_35_1], nil, true)
end

function UnitZodiacPotential.createFlag(arg_36_0)
	if not arg_36_0.vars or get_cocos_refid(arg_36_0.vars.flag) then
		return 
	end
	
	if UnitZodiac:isDictMode() then
		return 
	end
	
	local var_36_0 = UnitZodiac:getPotentialFlag()
	
	if get_cocos_refid(var_36_0) then
		var_36_0:ejectFromParent()
		var_36_0:setLocalZOrder(1)
		arg_36_0.vars.poten_layer:addChild(var_36_0)
		
		arg_36_0.vars.flag = var_36_0
		
		arg_36_0.vars.flag:setOpacity(0)
		UIAction:Add(LOOP(SEQ(LOG(MOVE_TO(250, 0, 30)), DELAY(150), RLOG(MOVE_TO(250, 0, 0)))), var_36_0:getChildByName("cursor"), "blink")
		arg_36_0:updateFlag()
		arg_36_0:showFlag(true)
	end
end

function UnitZodiacPotential.removeFlag(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	UIAction:Remove("blink")
	
	if get_cocos_refid(arg_37_0.vars.flag) then
		arg_37_0:showFlag(false)
		
		arg_37_0.vars.flag = nil
	end
end

function UnitZodiacPotential.updateFlag(arg_38_0, arg_38_1)
	if not arg_38_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_38_0.vars.flag) then
		return 
	end
	
	if UnitZodiac:isDictMode() then
		return 
	end
	
	local var_38_0 = arg_38_0:getAwakeLevel() + 1
	
	arg_38_0.vars.flag:setVisible(var_38_0 < 7)
	
	if var_38_0 >= 7 then
		return 
	end
	
	if arg_38_1 then
		local var_38_1, var_38_2 = arg_38_0.vars.stones[var_38_0]:getPosition()
		
		UIAction:Add(LOG(MOVE_TO(200, var_38_1, var_38_2)), arg_38_0.vars.flag, "block")
	else
		local var_38_3, var_38_4 = arg_38_0.vars.stones[var_38_0]:getPosition()
		
		arg_38_0.vars.flag:setPosition(var_38_3, var_38_4)
	end
end

function UnitZodiacPotential.showFlag(arg_39_0, arg_39_1)
	if not arg_39_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_39_0.vars.flag) then
		return 
	end
	
	if not UnitZodiac:isDictMode() then
		local var_39_0 = arg_39_0.vars.flag:getOpacity() / 255
		local var_39_1 = arg_39_1 and 1 or 0
		
		UIAction:Add(SEQ(OPACITY(300, var_39_0, var_39_1)), arg_39_0.vars.flag, "block")
	end
end

function UnitZodiacPotential.updateInterfaces(arg_40_0, arg_40_1)
	if not arg_40_0:isEnabled() then
		return 
	end
	
	arg_40_0:updateFlag(arg_40_1)
end

function UnitZodiacPotential.getNeedItemList(arg_41_0, arg_41_1)
	local var_41_0 = {}
	
	local function var_41_1(arg_42_0)
		for iter_42_0 = 1, 3 do
			local var_42_0, var_42_1 = DB("char_awake", arg_42_0, {
				"req" .. iter_42_0,
				"count" .. iter_42_0
			})
			
			if not var_42_0 then
				break
			end
			
			table.insert(var_41_0, {
				var_42_0,
				var_42_1
			})
		end
	end
	
	if not arg_41_1 then
		for iter_41_0 = 1, 6 do
			var_41_1(arg_41_0:getStoneID(nil, iter_41_0))
		end
	else
		var_41_1(arg_41_1)
	end
	
	return var_41_0
end

function UnitZodiacPotential.updateSidePanel(arg_43_0, arg_43_1, arg_43_2)
	if not get_cocos_refid(arg_43_1) then
		return 
	end
	
	arg_43_2 = tonumber(arg_43_2)
	
	if not arg_43_2 then
		return 
	end
	
	local var_43_0 = arg_43_0:getStoneID(nil, arg_43_2)
	local var_43_1, var_43_2 = DB("char_awake", var_43_0, {
		"name",
		"skill_up"
	})
	
	if_set(arg_43_1, "txt_stone_name", T(var_43_1))
	
	local var_43_3 = arg_43_1:getChildByName("n_upgrade")
	
	for iter_43_0 = 1, 6 do
		if_set_visible(var_43_3, "star" .. iter_43_0, iter_43_0 <= arg_43_2)
		
		if iter_43_0 <= arg_43_2 then
			if_set_sprite(var_43_3, "star" .. iter_43_0, "img/cm_icon_star_p.png")
		end
	end
	
	arg_43_1:getChildByName("n_right_stars"):getChildByName("star1"):setPositionX((6 - arg_43_2) * 10)
	
	local var_43_4 = arg_43_0:getNeedItemList(var_43_0)
	
	arg_43_0:resetSidePanel(arg_43_1)
	
	for iter_43_1 = 1, 3 do
		local var_43_5 = var_43_4[iter_43_1]
		
		if var_43_5 then
			local var_43_6 = var_43_5[1]
			local var_43_7 = var_43_5[2]
			local var_43_8 = var_43_3:getChildByName("n_res" .. iter_43_1 .. "/" .. #var_43_4)
			local var_43_9 = var_43_3:getChildByName("n_lack_item" .. iter_43_1 .. "/" .. #var_43_4)
			
			UIUtil:getRewardIcon(var_43_7, var_43_6, {
				show_count = true,
				no_frame = true,
				scale = 0.8,
				parent = var_43_8,
				count = to_n(var_43_7)
			})
			
			local var_43_10 = to_n(var_43_7) > Account:getItemCount(var_43_6)
			
			if_set_opacity(var_43_8, nil, (var_43_10 and 0.4 or 1) * 255)
			if_set_visible(var_43_9, nil, var_43_10)
		end
	end
	
	local var_43_11 = arg_43_1:getChildByName("n_potentail")
	
	if_set_sprite(var_43_11, "icon", arg_43_0:getStoneSprite(arg_43_2))
	if_set_visible(arg_43_1, "n_right_stars", true)
	if_set_visible(arg_43_1, "n_stone_pos", false)
	if_set_visible(arg_43_1, "n_rune_pos", false)
	if_set_visible(arg_43_1, "n_rune", false)
	arg_43_0:updateStatBonus(arg_43_1, arg_43_2, var_43_2 ~= nil)
	arg_43_1:getChildByName("n_skill_tooltip"):removeAllChildren()
	
	if var_43_2 then
		local var_43_12 = UIUtil:getAwakeSkillPopup(UnitZodiac:getUnit(), {
			show_effs = "left",
			force_active = true
		})
		
		if get_cocos_refid(var_43_12) then
			var_43_12:setAnchorPoint(1, 0)
			arg_43_1:getChildByName("n_skill_tooltip"):addChild(var_43_12)
			if_set_visible(var_43_12, "btn_close", false)
		end
	end
	
	local var_43_13 = arg_43_1:getChildByName("n_bonus_potential_skill")
	
	if get_cocos_refid(var_43_13) then
		local var_43_14 = var_43_13:getChildByName("label")
		
		var_43_13:getChildByName("icon"):setPositionX(var_43_14:getPositionX() - var_43_14:getContentSize().width * var_43_14:getScaleX() / 2 - 19)
	end
	
	if_set_visible(arg_43_1, "n_bonus_potential_skill", var_43_2)
	if_set_visible(arg_43_1, "n_bonus_skill", false)
	if_set_visible(arg_43_1, "n_zodiac", true)
	if_set_visible(arg_43_1, "n_skilltree", false)
end

function UnitZodiacPotential.updateStatBonus(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = UnitZodiac:getUnit():getAwakeBonus(arg_44_2, true)
	local var_44_1 = 1
	
	if arg_44_3 then
		var_44_1 = 0
	end
	
	for iter_44_0 = 0, 4 do
		local var_44_2 = iter_44_0 + var_44_1
		
		if var_44_0[var_44_2] then
			if_set(arg_44_1, "txt_diff" .. iter_44_0, to_var_str(to_n(var_44_0[var_44_2][2]), var_44_0[var_44_2][1]))
			if_set(arg_44_1, "txt_stat_name" .. iter_44_0, getStatName(var_44_0[var_44_2][1]))
			
			if iter_44_0 == 0 then
				if_set_sprite(arg_44_1, "stat_icon" .. iter_44_0, "img/icon_menu_" .. string.gsub(var_44_0[var_44_2][1], "_rate", "") .. ".png")
			else
				if_set_sprite(arg_44_1, "stat_icon" .. iter_44_0, "img/cm_icon_stat_" .. string.gsub(var_44_0[var_44_2][1], "_rate", "") .. ".png")
			end
		end
		
		if_set_visible(arg_44_1, "n_bonus_stat" .. iter_44_0, var_44_0[var_44_2] ~= nil)
	end
	
	return var_44_0
end

function UnitZodiacPotential.updateAwakeToUnit(arg_45_0, arg_45_1)
	arg_45_0.vars.rewards = {
		grade = arg_45_1
	}
	arg_45_0.vars.rewards.skill_after = arg_45_0:getSkillBonus(arg_45_1)
	
	local var_45_0 = UnitZodiac:getUnit()
	
	var_45_0.inst.awake = arg_45_1
	
	var_45_0:calc()
	
	local var_45_1 = var_45_0:clone()
	
	var_45_1.equips = {}
	var_45_1.inst.awake = arg_45_1 - 1
	
	var_45_1:calc()
	
	arg_45_0.vars.rewards.prev_grade = var_45_1.inst.awake
	arg_45_0.vars.rewards.status_before = table.clone(var_45_1.status)
	arg_45_0.vars.rewards.status_bonus = var_45_1:getAwakeBonus(arg_45_1)
	var_45_1.inst.awake = arg_45_1
	
	var_45_1:calc()
	
	arg_45_0.vars.rewards.status_after = table.clone(var_45_1.status)
end

function UnitZodiacPotential.displayUpgradeReward(arg_46_0, arg_46_1)
	if arg_46_1 then
		arg_46_0:updateAwakeToUnit(arg_46_1)
	end
	
	if not arg_46_0.vars.rewards then
		return 
	end
	
	if arg_46_0.vars.rewards.skill_after and not arg_46_0.vars.rewards.display_skill then
		local var_46_0 = load_dlg("unlock_system_open", true, "wnd")
		
		if_set(var_46_0, "txt_title", T("ui_awake_comp_title1"))
		if_set(var_46_0, "infor", T("ui_awake_comp_desc1"))
		if_set_sprite(var_46_0, "icon_storyguide", "img/icon_menu_awake_p.png")
		if_set_visible(var_46_0, "dim_real", false)
		
		arg_46_0.vars.rewards.display_skill = true
		
		Dialog:msgBox({
			fade_in = 500,
			dlg = var_46_0,
			handler = function()
				arg_46_0:displayUpgradeReward()
			end
		})
		
		return 
	end
	
	if arg_46_0.vars.rewards.status_after and not arg_46_0.vars.rewards.display_status then
		local var_46_1 = load_dlg("dlg_zodiac_reward_stat", true, "wnd")
		
		Dialog:msgBox({
			fade_in = 500,
			dlg = var_46_1,
			handler = function()
				arg_46_0:displayUpgradeReward()
			end
		})
		
		local var_46_2 = arg_46_0:updateStatBonus(var_46_1, arg_46_0.vars.rewards.grade)
		
		for iter_46_0 = 0, 3 do
			if var_46_2[iter_46_0 + 1] then
				local var_46_3 = string.gsub(var_46_2[iter_46_0 + 1][1], "_rate", "")
				
				if_set(var_46_1, "txt_stat" .. iter_46_0 .. "_before", to_var_str(arg_46_0.vars.rewards.status_before[var_46_3], var_46_3))
				
				local var_46_4
				local var_46_5 = arg_46_0.vars.rewards.status_after[var_46_3]
				
				if UNIT.is_percentage_stat(var_46_3) then
					local var_46_6 = 1e-07
					
					var_46_5 = math.floor(var_46_5 * 100 + var_46_6)
					var_46_4 = "%"
				end
				
				UIAction:Add(INC_NUMBER(700, var_46_5, var_46_4, arg_46_0.vars.rewards.status_before[var_46_3]), var_46_1:getChildByName("txt_stat" .. iter_46_0), "hey")
			end
		end
		
		if_set(var_46_1, "txt_title", T("zodiac_potential_reward_title"))
		if_set(var_46_1, "txt_disc", T("zodiac_potential_reward_desc"))
		
		arg_46_0.vars.rewards.display_status = true
		
		return 
	end
end

function UnitZodiacPotential.reqEnhance(arg_49_0)
	local var_49_0 = UnitZodiac:getUnit()
	
	if not var_49_0 then
		return 
	end
	
	local var_49_1 = arg_49_0:getAwakeLevel() + 1
	local var_49_2 = UnitZodiac:getZoomIndex()
	local var_49_3, var_49_4 = arg_49_0:checkEnhance(var_49_2)
	
	if not var_49_3 then
		if var_49_4 == "invalid" then
			balloon_message_with_sound("invalid_zodiac_stone_order")
		end
		
		if var_49_4 == "enhanced" then
			balloon_message_with_sound("already_enhanced_zodiac_stone")
		end
		
		if var_49_4 == "level" then
			balloon_message_with_sound("zodiac_can_upgrade", {
				level = 60
			})
		end
		
		if var_49_4 == "material" then
			balloon_message_with_sound("msg_potential_not_enough_material")
		end
		
		if var_49_4 == "complete" then
			balloon_message_with_sound("msg_all_complete_potential")
		end
		
		return 
	end
	
	if not var_49_2 then
		UnitZodiac:focusIn(var_49_1)
		
		return 
	end
	
	if var_49_1 ~= var_49_2 then
		return 
	end
	
	query("awake_enhance", {
		target = var_49_0:getUID(),
		begin_lv = arg_49_0:getAwakeLevel(),
		target_lv = var_49_1
	})
end

function MsgHandler.awake_enhance(arg_50_0)
	local var_50_0 = Account:getUnit(arg_50_0.target)
	
	if not var_50_0 then
		return 
	end
	
	for iter_50_0, iter_50_1 in pairs(arg_50_0.items) do
		Account:setItemCount(iter_50_0, iter_50_1)
	end
	
	local var_50_1 = var_50_0:getAwakeGrade()
	
	Account:setCurrency("gold", arg_50_0.gold)
	TopBarNew:topbarUpdate(true)
	UnitZodiac:respPotentialEnhance()
	
	local var_50_2 = HeroBelt:getInst("UnitMain")
	
	if var_50_2 then
		var_50_2:updateUnit(nil, var_50_0)
	end
end

function UnitZodiacPotential.respEnhance(arg_51_0)
	if arg_51_0:getAwakeLevel() >= 6 then
		return 
	end
	
	UnitZodiac:focusOut()
	arg_51_0:updateAwakeToUnit(arg_51_0:getAwakeLevel() + 1)
	
	local var_51_0 = arg_51_0:getAwakeLevel()
	local var_51_1 = load_dlg("unit_zodiac_upgrade", true, "wnd")
	local var_51_2 = UnitZodiac:getWindos()
	
	if get_cocos_refid(var_51_2) then
		var_51_2:addChild(var_51_1)
		var_51_1:setLocalZOrder(1)
	end
	
	local var_51_3 = var_51_1:getChildByName("star")
	
	var_51_3:setVisible(false)
	if_set_visible(var_51_1, "black", false)
	if_set_visible(var_51_1, "txt_sphere_name", false)
	
	local var_51_4, var_51_5 = UnitZodiac:getOffsetPos()
	
	arg_51_0.vars.eff_layer = cc.Layer:create()
	
	arg_51_0.vars.eff_layer:setLocalZOrder(2)
	arg_51_0.vars.eff_layer:setPosition(640 + var_51_4, 360 + var_51_5)
	arg_51_0.vars.eff_layer:setAnchorPoint(0.5, 0.5)
	arg_51_0.vars.eff_layer:setContentSize(1280, 720)
	var_51_2:addChild(arg_51_0.vars.eff_layer)
	EffectManager:Play({
		z = 3,
		fn = "ui_awaken_libration_compass.cfx",
		delay = 1000,
		layer = arg_51_0.vars.eff_layer,
		x = -var_51_4,
		y = -var_51_5
	})
	UIAction:Add(SEQ(DELAY(4633), REMOVE()), arg_51_0.vars.eff_layer, "block")
	UnitZodiac:setPotentialStars(var_51_3, var_51_0 - 1)
	UIAction:Add(SEQ(DELAY(1033), SHOW(true), DELAY(1100), CALL(function()
		UnitZodiac:setPotentialStars(var_51_3, var_51_0)
	end)), var_51_3, "block")
	var_51_1:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(1000), DELAY(2633), FADE_OUT(800), REMOVE()), var_51_1, "block")
	
	local var_51_6 = var_51_3:getChildByName("gs" .. var_51_0)
	
	if get_cocos_refid(var_51_6) then
		local var_51_7 = var_51_6:getContentSize()
		local var_51_8 = SceneManager:convertToSceneSpace(var_51_6, {
			x = var_51_7.width / 2,
			y = var_51_7.height / 2
		})
		
		EffectManager:Play({
			z = 4,
			fn = "ui_awaken_libration_star.cfx",
			delay = 2000,
			layer = var_51_2,
			x = var_51_8.x,
			y = var_51_8.y
		})
	end
	
	arg_51_0:updateComponents(true)
	arg_51_0:updateInterfaces(true)
	UIAction:Add(SEQ(DELAY(4633), CALL(arg_51_0.displayUpgradeReward, arg_51_0, var_51_0)), arg_51_0, "block")
end

function UnitZodiacPotential.checkEnhance(arg_53_0, arg_53_1)
	if not arg_53_1 then
		return arg_53_0:getAwakeLevel() < 6, "complete"
	end
	
	if arg_53_1 > 6 then
		return false
	end
	
	local var_53_0 = arg_53_0:getAwakeLevel() + 1
	
	if arg_53_1 < var_53_0 then
		return false, "enhanced"
	end
	
	if var_53_0 < arg_53_1 then
		return false, "invalid"
	end
	
	local var_53_1 = UnitZodiac:getUnit()
	
	if not var_53_1 then
		return false
	end
	
	if var_53_1:getLv() < 60 and not DEBUG.ZODIAC_IGNORE_LEVEL then
		return false, "level"
	end
	
	local var_53_2 = arg_53_0:getStoneID(var_53_1, arg_53_1)
	local var_53_3 = arg_53_0:getNeedItemList(var_53_2)
	
	for iter_53_0 = 1, 3 do
		local var_53_4 = var_53_3[iter_53_0]
		
		if var_53_4 then
			local var_53_5 = var_53_4[1]
			
			if var_53_4[2] > Account:getItemCount(var_53_5) then
				return false, "material"
			end
		end
	end
	
	return true
end

function UnitZodiacPotential.getAwakeLevel(arg_54_0)
	local var_54_0 = UnitZodiac:getUnit()
	
	if not var_54_0 then
		return 0
	end
	
	return to_n(var_54_0:getAwakeGrade())
end
