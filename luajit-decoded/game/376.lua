UnitZodiac = {}
BONUS_ON_SPHERE_UPGRADE = true

if PLATFORM == "win32" then
	function zodiac(arg_1_0)
		SceneManager:nextScene("unit_ui", {
			mode = "Zodiac",
			unit = Account.units[1],
			dict_mode = arg_1_0
		})
	end
end

function HANDLER.unit_zodiac2(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_up" then
		if UnitZodiac:isDictMode() then
			UnitZodiac:focusFirstStone()
			
			return 
		end
		
		UnitZodiac:reqEnhance()
		
		return 
	end
	
	if arg_2_1 == "btn_prev" then
		UnitZodiac:focusIn(UnitZodiac.vars.focus_idx - 1)
	end
	
	if arg_2_1 == "btn_next" then
		UnitZodiac:focusIn(UnitZodiac.vars.focus_idx + 1)
	end
	
	if arg_2_1 == "btn_bg" and UnitZodiac:getZoomIndex() then
		UnitZodiac:focusOut()
	end
	
	if arg_2_1 == "btn_item_mix" then
		UnitZodiac:openMixWindow()
	end
	
	if arg_2_1 == "btn_catalyst" then
		if UnitZodiac.vars.is_invisible_button_unit then
			balloon_message_with_sound("msg_cannot_use_btn_hero")
			
			return 
		end
		
		local var_2_0 = UnitZodiac:getUnit()
		
		if var_2_0 then
			local var_2_1 = var_2_0.db.code
			
			if is_enhanced_mer(var_2_1) then
				var_2_1 = get_origin_mer()
			end
			
			Stove:openEssenceGuidePage(var_2_1)
		else
			Log.e("unit is nil")
		end
	end
	
	if arg_2_1 == "btn_go_awake" then
		UnitZodiac:setMode("Stone")
	end
	
	if arg_2_1 == "btn_go_potential" then
		local var_2_2 = UnitZodiac:getUnit()
		
		if var_2_2 then
			if var_2_2:isGrowthBoostRegistered() then
				balloon_message_with_sound("msg_cannot_awaken_while_gb")
				
				return 
			end
			
			if var_2_2:getZodiacGrade() < 6 then
				balloon_message_with_sound("msg_cant_potential_full_awaken")
				
				return 
			end
			
			UnitZodiac:setMode("Potential")
			TutorialGuide:procGuide("char_awake_unlock")
		end
	end
	
	if arg_2_1 == "btn_skill_summary" then
		UnitZodiac:openSkillSummary()
	end
	
	if arg_2_1 == "btn_go_skilltree" then
		UnitZodiac:setMode("Rune")
		TutorialGuide:procGuide("classchange_fire")
		TutorialGuide:procGuide("classchange_ice")
		TutorialGuide:procGuide("classchange_wind")
		TutorialGuide:procGuide("classchange_light")
		TutorialGuide:procGuide("classchange_dark")
	end
	
	if arg_2_1 == "btn_active_skilltree" then
		local var_2_3 = UnitZodiac:getUnit()
		
		if var_2_3 then
			if BackPlayManager:isInBackPlayTeam(var_2_3:getUID()) then
				balloon_message_with_sound("msg_bgbattle_cant_classchange")
				
				return 
			end
			
			Dialog:msgBox(T("ui_cc_finish_desc"), {
				yesno = true,
				title = T("ui_cc_finish_title"),
				handler = function()
					query("classchange_finish", {
						code = var_2_3.db.code,
						uid = var_2_3:getUID()
					})
				end
			})
		end
	end
	
	if arg_2_1 == "btn_skill_enhancement" then
		UnitZodiac:reqRuneEnhance()
	end
	
	if arg_2_1 == "btn_reset" then
		UnitZodiac:reqSkillReset()
	end
	
	if string.len(arg_2_1) <= 2 then
		UnitZodiac:focusIn(tonumber(arg_2_1))
	end
end

function UnitZodiac.focusFirstStone(arg_4_0)
	arg_4_0:hideBtnUpOnDictMode()
	arg_4_0:focusIn(1)
end

function UnitZodiac.onPushBackButton(arg_5_0)
	if arg_5_0:getZoomIndex() then
		arg_5_0:focusOut()
	elseif arg_5_0.vars.dict_mode then
	else
		UnitMain:setMode("Detail", {
			unit = arg_5_0.vars.unit
		})
	end
end

function UnitZodiac.hideBtnUpOnDictMode(arg_6_0)
	if arg_6_0.vars.mode == "Rune" then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("btn_up")
	local var_6_1 = arg_6_0.vars.wnd:getChildByName("btn_prev")
	local var_6_2 = arg_6_0.vars.wnd:getChildByName("btn_next")
	
	UIAction:Add(SPAWN(MOVE_TO(200, var_6_0:getPositionX(), -100), FADE_OUT(200)), var_6_0, "block")
	UIAction:Add(FADE_IN(200), var_6_1, "block")
	UIAction:Add(FADE_IN(200), var_6_2, "block")
end

function UnitZodiac.showBtnUpOnDictMode(arg_7_0)
	if arg_7_0.vars.mode == "Rune" then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("btn_up")
	local var_7_1 = arg_7_0.vars.wnd:getChildByName("btn_prev")
	local var_7_2 = arg_7_0.vars.wnd:getChildByName("btn_next")
	
	UIAction:Add(SPAWN(MOVE_TO(200, var_7_0:getPositionX(), 28), FADE_IN(200)), var_7_0, "block")
	UIAction:Add(FADE_OUT(200, true), var_7_1, "block")
	UIAction:Add(FADE_OUT(200, true), var_7_2, "block")
end

function UnitZodiac.reqEnhance(arg_8_0)
	arg_8_0:procFunc(nil, "reqEnhance")
end

function UnitZodiac.onEnter(arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or {}
	
	local var_9_0 = arg_9_2.enter_mode or "Stone"
	
	arg_9_0:setMode(var_9_0)
	arg_9_0:procFunc(nil, "onEnter")
	arg_9_0:focusOut(0, true)
	
	arg_9_0.vars.is_invisible_button_unit = EpisodeAdin:isAdinCode(arg_9_0:getUnit().db.code) and var_9_0 == "Rune"
	
	if arg_9_0.vars.is_invisible_button_unit then
		if_set_opacity(arg_9_0.vars.wnd, "btn_catalyst", 76.5)
		if_set_opacity(arg_9_0.vars.wnd, "btn_item_mix", 76.5)
	end
	
	UIAction:Add(OPACITY(250, 0, 0.7), arg_9_0.vars.wnd:getChildByName("bg_black"), "block")
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_9_0.vars.wnd:getChildByName("LEFT"), "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 200)), arg_9_0.vars.wnd:getChildByName("BOTTOM"), "block")
	
	if not arg_9_0.vars.dict_mode then
		UIAction:Add(SEQ(SLIDE_IN_Y(200, 200)), arg_9_0.vars.wnd:getChildByName("n_progress"), "block")
		if_set_visible(arg_9_0.vars.wnd, "btn_prev", false)
		if_set_visible(arg_9_0.vars.wnd, "btn_next", false)
	end
	
	UIAction:Add(LOOP(SEQ(DELAY(2000), CALL(set_high_fps_tick))), arg_9_0.vars.wnd, "high_fps")
	TopBarNew:setDisableTopRight()
end

function UnitZodiac.removeStars(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_10_0.vars.pp_layer) then
		return 
	end
	
	local var_10_0 = 200
	local var_10_1 = cc.GLProgramCache:getInstance():getGLProgram("zodiac_gravity_post")
	
	if var_10_1 then
		local var_10_2 = cc.GLProgramState:create(var_10_1)
		
		if var_10_2 then
			var_10_2:setUniformVec2("u_origin", {
				x = 0.5,
				y = 0.5
			})
			var_10_2:setUniformVec2("u_resolution", {
				x = DESIGN_WIDTH,
				y = DESIGN_HEIGHT
			})
			var_10_2:setUniformFloat("u_range", 1)
			var_10_2:setUniformFloat("u_start", 0)
			
			local var_10_3 = arg_10_0.vars.pp_layer:getOpacity() / 255
			
			UIAction:Add(SEQ(SPAWN(RLOG(LINEAR_CALL(var_10_0, nil, function(arg_11_0, arg_11_1)
				if not arg_11_1 then
					return 
				end
				
				var_10_2:setUniformFloat("u_range", arg_11_1)
			end, 1, 200), 10), RLOG(LINEAR_CALL(var_10_0, nil, function(arg_12_0, arg_12_1)
				if not arg_12_1 then
					return 
				end
				
				var_10_2:setUniformFloat("u_start", arg_12_1)
			end, 0, 200), 20), OPACITY(var_10_0, var_10_3, 0)), REMOVE()), arg_10_0.vars.pp_layer, "block")
			arg_10_0.vars.pp_layer:setPostProcessEnabled(true)
			arg_10_0.vars.pp_layer:addProcessGLProgramState(var_10_2, "zodiac_gravity_post", 5)
			arg_10_0.vars.pp_layer:setPosition(VIEW_BASE_LEFT, math.min(0, (VIEW_HEIGHT - SCREEN_HEIGHT) / 2))
			
			local var_10_4 = arg_10_0.vars.pp_layer:getChildren()
			
			for iter_10_0, iter_10_1 in pairs(var_10_4) do
				if iter_10_1:getName() == "star_back" then
					iter_10_1:setPosition(VIEW_WIDTH / 2, SCREEN_HEIGHT / 2)
				end
			end
		end
	else
		UIAction:Add(SEQ(SPAWN(OPACITY(var_10_0, 1, 0), SCALE(var_10_0, 1, 0)), REMOVE()), arg_10_0.vars.pp_layer, "block")
	end
	
	arg_10_0.vars.pp_layer:setOpacity(255)
	arg_10_0.vars.pp_layer:setCascadeOpacityEnabled(true)
end

function UnitZodiac.onLeave(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	UIAction:Remove("high_fps")
	
	local var_13_0 = {
		TARGET(arg_13_0.vars.pp_layer, FADE_OUT(250))
	}
	
	local function var_13_1(arg_14_0, arg_14_1)
		local var_14_0 = arg_13_0.vars.wnd:getChildByName(arg_14_0)
		
		if get_cocos_refid(var_14_0) then
			table.insert(var_13_0, TARGET(var_14_0, arg_14_1))
		end
	end
	
	var_13_1("LEFT", SLIDE_OUT(200, -600))
	var_13_1("BOTTOM", SLIDE_OUT_Y(200, -200))
	var_13_1("n_progress", SLIDE_OUT_Y(200, -200))
	var_13_1("bg_black", OPACITY(50, 0.7, 0))
	
	if arg_13_0:getZoomIndex() then
		var_13_1("n_upgrade", SLIDE_OUT(200, 400))
	end
	
	if not arg_13_0.vars.dict_mode then
		var_13_1("n_main_btns", FADE_OUT(200))
	end
	
	UIAction:Add(SEQ(SPAWN(table.unpack(var_13_0)), DELAY(30), REMOVE()), arg_13_0.vars.wnd, "block")
	
	if arg_13_1 then
		UnitDetail:updateUnitInfo(arg_13_0.vars.unit)
	end
	
	if ClassChange.vars and get_cocos_refid(ClassChange.vars.detail) then
		TopBarNew.vars.help_id = "growth_5_1"
	end
	
	TopBarNew:setEnableTopRight()
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.childs) do
		arg_13_0:procFunc(iter_13_0, "onLeave")
	end
	
	if arg_13_0.vars.on_leave then
		arg_13_0.vars.on_leave()
	end
	
	arg_13_0.vars = nil
end

function UnitZodiac.addStars(arg_15_0)
	local var_15_0 = {
		0.03,
		0.09,
		0.2,
		0.6,
		0.8,
		1.2,
		2.4
	}
	
	arg_15_0.vars.pp_layer = su.SimplePostProcessLayer:create()
	
	arg_15_0.vars.pp_layer:setCascadeOpacityEnabled(true)
	arg_15_0.vars.pp_layer:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	
	for iter_15_0 = 1, #var_15_0 do
		local var_15_1 = cc.Layer:create()
		
		var_15_1:ignoreAnchorPointForPosition(false)
		var_15_1:setCascadeOpacityEnabled(true)
		var_15_1:setAnchorPoint(0.5, 0.5)
		var_15_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_15_1:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
		var_15_1:setName("star_back")
		arg_15_0.vars.pp_layer:addChild(var_15_1)
		
		arg_15_0.vars.back_layers[iter_15_0] = {
			var_15_1,
			var_15_0[iter_15_0],
			1 + var_15_0[iter_15_0] / 2
		}
	end
	
	for iter_15_1 = 1, #var_15_0 do
		for iter_15_2 = 1, 6 * (12 / (iter_15_1 / 2)) do
			local var_15_2 = SpriteCache:getSprite("img/cm_icon_prolight.png")
			
			var_15_2:setPosition(math.random(50, 1230), math.random(1, 720))
			var_15_2:setScale(0.1 + math.random() * 0.2)
			
			if iter_15_2 > 2 then
				var_15_2:setOpacity(255 * (0.2 + math.random() * 0.4))
			end
			
			arg_15_0.vars.back_layers[iter_15_1][1]:addChild(var_15_2)
		end
	end
	
	EffectManager:Play({
		z = 2,
		fn = "zodiac_stars_front.cfx",
		y = 400,
		x = 640,
		layer = arg_15_0.vars.pp_layer
	})
	EffectManager:Play({
		z = -1,
		fn = "zodiac_stars_back.cfx",
		y = 400,
		x = 640,
		layer = arg_15_0.vars.pp_layer
	})
	arg_15_0.vars.wnd:addChild(arg_15_0.vars.pp_layer)
	arg_15_0.vars.pp_layer:setLocalZOrder(-1)
	arg_15_0.vars.wnd:getChildByName("bg"):setLocalZOrder(-2)
	arg_15_0.vars.wnd:getChildByName("bg_black"):setLocalZOrder(-3)
	arg_15_0.vars.pp_layer:setOpacity(0)
	UIAction:Add(FADE_IN(200), arg_15_0.vars.pp_layer, "block")
end

function UnitZodiac.updateSidePanelWithoutInfo(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	local var_16_0 = arg_16_0:getZoomIndex()
	
	if not var_16_0 then
		return 
	end
	
	if var_16_0 > 0 then
		UnitZodiac:updateSidePanel(var_16_0)
	elseif var_16_0 < 0 then
		if arg_16_0.vars.mode ~= "Rune" then
			return 
		end
		
		local var_16_1 = arg_16_0:procFunc(arg_16_0.vars.mode, "getInfoByIndex", var_16_0)
		
		UnitZodiac:updateSidePanel(var_16_1)
	end
end

function UnitZodiac.getStoneState(arg_17_0, arg_17_1)
	if arg_17_1 <= arg_17_0:getSphereGrade() then
		return "enhanced"
	end
	
	if (arg_17_1 > arg_17_0:getSphereGrade() + 1 or arg_17_0.vars.unit:getLv() < arg_17_1 * 10) and arg_17_1 > 1 then
		return "locked"
	end
	
	if arg_17_0.vars.unit:isLockZodiacUpgrade5() and arg_17_1 > 4 then
		return "locked"
	end
	
	return "open"
end

function UnitZodiac.beginDictMode(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	arg_18_0:onCreate({
		dict_mode = true,
		parent = arg_18_1,
		unit = arg_18_2,
		able_swap_button = arg_18_4,
		force_front_show = arg_18_5
	})
	arg_18_0:onEnter(nil, {
		enter_mode = arg_18_3 and "Rune" or "Stone"
	})
end

function UnitZodiac.endDictMode(arg_19_0)
	arg_19_0:onLeave()
end

function UnitZodiac.isDictMode(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	return arg_20_0.vars.dict_mode
end

function UnitZodiac.getWindos(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	return arg_21_0.vars.wnd
end

function UnitZodiac.getFlagCtrl(arg_22_0)
	return arg_22_0.vars.wnd:getChildByName("n_cursor")
end

function UnitZodiac.getPotentialFlag(arg_23_0)
	return arg_23_0.vars.wnd:getChildByName("n_cursor_potentail")
end

function UnitZodiac.getAwakeStone(arg_24_0, arg_24_1)
	return arg_24_0:procFunc(nil, "getStoneNode", arg_24_1)
end

function UnitZodiac.getUnit(arg_25_0)
	return arg_25_0.vars.unit
end

function UnitZodiac.getOffsetPos(arg_26_0)
	return arg_26_0.vars.x_offset, arg_26_0.vars.y_offset
end

function UnitZodiac.getSphereName(arg_27_0)
	return arg_27_0.vars.sphere_name
end

function UnitZodiac.isValid(arg_28_0)
	return arg_28_0.vars and get_cocos_refid(arg_28_0.vars.wnd)
end

function UnitZodiac.onUIUpdate(arg_29_0)
	arg_29_0:updateInterfaces()
	arg_29_0:updateSidePanelWithoutInfo()
end

function UnitZodiac.onCreate(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or {}
	arg_30_0.vars = {}
	arg_30_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	arg_30_0.vars.unit = arg_30_1.unit or arg_30_0.vars.hero_belt:getCurrentItem()
	arg_30_0.vars.sphere_name = arg_30_0.vars.unit.db.zodiac
	arg_30_0.vars.start_mode = UnitMain:getStartMode()
	arg_30_0.vars.childs = {
		Stone = UnitZodiacStone,
		Rune = UnitZodiacRune,
		Potential = UnitZodiacPotential
	}
	
	local var_30_0 = arg_30_0.vars.unit
	
	if var_30_0 and not arg_30_1.dict_mode then
		local var_30_1 = "game.unit." .. var_30_0:getUID() .. ".zd"
		
		if SAVE:get(var_30_1) then
			SAVE:set(var_30_1, nil)
			
			if arg_30_0.vars.hero_belt then
				arg_30_0.vars.hero_belt:updateUnit(nil, var_30_0)
			end
		end
	end
	
	arg_30_0.vars.wnd = load_dlg("unit_zodiac2", true, "wnd")
	
	arg_30_0.vars.wnd:setLocalZOrder(10)
	
	arg_30_0.vars.back_layers = {}
	arg_30_0.vars.dict_mode = arg_30_1.dict_mode
	arg_30_0.vars.able_swap_button = arg_30_1.able_swap_button
	arg_30_0.vars.force_front_show = arg_30_1.force_front_show
	arg_30_0.vars.on_leave = arg_30_1.on_leave
	
	UIUtil:setUnitAllInfo(arg_30_0.vars.wnd:getChildByName("name"), var_30_0, {
		no_repos_sphere = true
	})
	UIUtil:setUnitSkillInfo(arg_30_0.vars.wnd:getChildByName("LEFT"), var_30_0, {
		style = "scale",
		tooltip_opts = {
			show_effs = "right"
		}
	})
	if_set(arg_30_0.vars.wnd, "txt_story", T(DB("character", var_30_0.db.code, "2line"), "text"))
	if_set(arg_30_0.vars.wnd, "txt_zodiac", T(DB("zodiac_sphere_2", var_30_0.db.zodiac, "name"), "text"))
	UIUtil:alignControl(arg_30_0.vars.wnd:getChildByName("name"), "txt_name", "star1")
	UIUtil:alignControl(arg_30_0.vars.wnd:getChildByName("name"), "txt_color", "n_role")
	SpriteCache:resetSprite(arg_30_0.vars.wnd:getChildByName("face"), "face/" .. var_30_0.db.face_id .. "_s.png")
	
	if arg_30_0:isDictMode() then
		arg_30_0.vars.dict_grade = 1
		
		if_set_visible(arg_30_0.vars.wnd, "n_progress", false)
		
		local var_30_2 = arg_30_0.vars.wnd:getChildByName("btn_up")
		
		if get_cocos_refid(var_30_2) then
			if_set(var_30_2, "label", T("preview_zodiac"))
		end
		
		if_set_visible(arg_30_0.vars.wnd, "btn_skill_summary", arg_30_0.vars.unit:isClassChangeableUnit() and arg_30_0.vars.mode == "Rune" and not UnitDetail.vars and not EpisodeAdin:isAdinCode(arg_30_0.vars.unit.db.code))
		if_set_visible(arg_30_0.vars.wnd, "star1", arg_30_0.vars.mode == "Rune")
		if_set_visible(arg_30_0.vars.wnd, "n_parts", false)
		if_set_visible(arg_30_0.vars.wnd, "n_res", false)
		if_set_visible(arg_30_0.vars.wnd, "n_item_mix1", false)
		if_set_visible(arg_30_0.vars.wnd, "n_item_mix2", false)
	end
	
	if_set_visible(arg_30_0.vars.wnd, "n_info_collabo", DB("character_reference", var_30_0.db.code, "collabo_char") == "y")
	if_set_visible(arg_30_0.vars.wnd, "n_parts", not arg_30_0:isDictMode())
	if_set_visible(arg_30_0.vars.wnd, "btn_ng", arg_30_0:isDictMode())
	arg_30_0:addStars()
	
	local var_30_3 = arg_30_0.vars.wnd:getChildByName("n_space")
	
	if get_cocos_refid(var_30_3) then
		local var_30_4, var_30_5 = var_30_3:getPosition()
		
		arg_30_0.vars.x_offset = var_30_4 - DESIGN_WIDTH / 2
		arg_30_0.vars.y_offset = var_30_5 - DESIGN_HEIGHT / 2
		
		for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.childs) do
			iter_30_1:onCreate({
				parent = var_30_3
			})
			arg_30_0:procFunc(iter_30_0, "updateComponents")
		end
		
		arg_30_0:procFunc("Stone", "regCursor", arg_30_0.vars.wnd:getChildByName("selected"))
		arg_30_0:procFunc("Rune", "regCursor", arg_30_0.vars.wnd:getChildByName("rune_selector"))
		arg_30_0:procFunc("Potential", "regCursor", arg_30_0.vars.wnd:getChildByName("selected"))
	end
	
	SpriteCache:resetSprite(arg_30_0.vars.wnd:getChildByName("icon_zodiac"), "img/cm_icon_zodiac_" .. string.split(var_30_0.db.zodiac, "_")[1] .. ".png")
	SpriteCache:resetSprite(arg_30_0.vars.wnd:getChildByName("icon_zodiac_small"), "img/cm_icon_zodiac_" .. string.split(var_30_0.db.zodiac, "_")[1] .. ".png")
	
	arg_30_0.vars.flag = arg_30_0.vars.wnd:getChildByName("n_cursor")
	
	arg_30_0.vars.flag:setVisible(not arg_30_0:isDictMode())
	;(arg_30_1.parent or UnitMain.vars.base_wnd):addChild(arg_30_0.vars.wnd)
	
	if arg_30_1.force_front_show then
		arg_30_0.vars.wnd:bringToFront()
	end
	
	for iter_30_2, iter_30_3 in pairs(arg_30_0.vars.back_layers) do
		iter_30_3[1]:setScale(0.1 * iter_30_2)
		iter_30_3[1]:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	end
	
	if_set_visible(arg_30_0.vars.wnd, "CENTER", false)
	if_set_opacity(arg_30_0.vars.wnd, "vignetting", 0)
	if_set_opacity(arg_30_0.vars.wnd, "bg_black", 0)
	if_set_opacity(arg_30_0.vars.wnd, "LEFT", 0)
	if_set_opacity(arg_30_0.vars.wnd, "BOTTOM", 0)
	if_set_opacity(arg_30_0.vars.wnd, "n_progress", 0)
	if_set_visible(arg_30_0.vars.wnd, "n_upgrade", false)
	if_set_visible(arg_30_0.vars.wnd, "n_cursor", false)
	if_set_visible(arg_30_0.vars.wnd, "txt_rune_name", false)
	if_set_visible(arg_30_0.vars.wnd, "txt_desc", false)
	
	local var_30_6 = Account:getClassChangeInfo()
	
	if table.count(var_30_6) > 0 then
		for iter_30_4 = 1, 99 do
			local var_30_7, var_30_8 = DBN("classchange_category", iter_30_4, {
				"id",
				"char_id_cc"
			})
			
			if not var_30_7 then
				break
			end
			
			if var_30_8 == arg_30_0.vars.unit.db.code then
				TutorialGuide:ifStartGuide("classchange_" .. arg_30_0.vars.unit.db.color)
				
				break
			end
		end
	end
	
	arg_30_0:playPotentialTutorial()
	arg_30_0:updateHelpButton()
	ItemEventSender:addListener(arg_30_0)
	
	if not arg_30_1.dict_mode then
		TutorialGuide:ifStartGuide("system_049")
	end
end

function UnitZodiac.updateHelpButton(arg_31_0)
	local var_31_0 = arg_31_0:procFunc(nil, "getHelpID")
	
	TopBarNew:checkhelpbuttonID(var_31_0)
end

function UnitZodiac.push_BGLayer(arg_32_0, arg_32_1)
	if not get_cocos_refid(arg_32_1[1]) then
		return 
	end
	
	arg_32_0.vars.back_layers[#arg_32_0.vars.back_layers + 1] = arg_32_1
end

function UnitZodiac.updateFlag(arg_33_0, arg_33_1)
end

function UnitZodiac.setSphereStars(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_3 = arg_34_3 or "gs"
	
	for iter_34_0 = 1, 6 do
		local var_34_0 = arg_34_1:getChildByName(arg_34_3 .. iter_34_0)
		
		if iter_34_0 > arg_34_0.vars.unit:getGrade() then
			SpriteCache:resetSprite(var_34_0, "img/cm_icon_star_e.png")
		elseif arg_34_2 < iter_34_0 then
			SpriteCache:resetSprite(var_34_0, "img/cm_icon_star.png")
		else
			SpriteCache:resetSprite(var_34_0, "img/cm_icon_star_j.png")
		end
	end
end

function UnitZodiac.setPotentialStars(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_3 = arg_35_3 or "gs"
	
	for iter_35_0 = 1, 6 do
		local var_35_0 = arg_35_1:getChildByName(arg_35_3 .. iter_35_0)
		
		if arg_35_2 < iter_35_0 then
			SpriteCache:resetSprite(var_35_0, "img/cm_icon_star_j.png")
		else
			SpriteCache:resetSprite(var_35_0, "img/cm_icon_star_p.png")
		end
	end
end

function UnitZodiac.updateMainButtons(arg_36_0)
	arg_36_0.vars.wnd:getChildByName("n_main_btns"):setVisible(not arg_36_0.vars.zoom_idx and not arg_36_0:isDictMode())
	if_set_visible(arg_36_0.vars.wnd, "n_dict", arg_36_0:isDictMode())
	if_set_visible(arg_36_0.vars.wnd, "n_parts", not arg_36_0:isDictMode())
	arg_36_0:updateUpgradeButton()
end

function UnitZodiac.updateLeftButtons(arg_37_0)
	if not arg_37_0.vars then
		return 
	end
	
	if not arg_37_0:isDictMode() then
		local var_37_0 = arg_37_0.vars.mode == "Potential"
		local var_37_1 = arg_37_0.vars.mode == "Rune"
		local var_37_2 = arg_37_0.vars.wnd:getChildByName("n_item_mix1")
		local var_37_3 = arg_37_0.vars.wnd:getChildByName("n_item_mix2")
		local var_37_4 = ContentDisable:byAlias("essence_guide") or IS_PUBLISHER_ZLONG
		
		if_set_visible(var_37_2, nil, var_37_4)
		if_set_visible(var_37_3, nil, not var_37_4)
		
		arg_37_0.vars.is_block_reset = EpisodeAdin:isAdinCode(arg_37_0:getUnit().db.code)
		
		if_set_opacity(arg_37_0.vars.wnd, "btn_reset", arg_37_0.vars.is_block_reset == true and 76.5 or 255)
		
		if not var_37_4 then
			local var_37_5 = var_37_3:getChildByName("btn_catalyst")
			local var_37_6 = var_37_3:getChildByName("btn_item_mix")
			
			if_set_visible(var_37_5, nil, not var_37_1)
			if_set_visible(var_37_6, nil, not var_37_0)
			
			if get_cocos_refid(var_37_6) then
				var_37_6.origin_pos_x = var_37_6.origin_pos_x or var_37_6:getPositionX()
				var_37_6.origin_anchor = var_37_6.origin_anchor or var_37_6:getAnchorPoint()
				
				if var_37_1 and get_cocos_refid(var_37_5) then
					var_37_6:setPositionX(var_37_5:getPositionX())
					var_37_6:setAnchorPoint(var_37_5:getAnchorPoint())
				else
					var_37_6:setPositionX(var_37_6.origin_pos_x)
					var_37_6:setAnchorPoint(var_37_6.origin_anchor)
				end
			end
		else
			if_set_visible(var_37_2, "btn_item_mix", not var_37_0)
		end
	end
end

function UnitZodiac.isMoonlightDestinyUnit(arg_38_0)
	if not arg_38_0.vars.unit then
		return false
	end
	
	return arg_38_0.vars.unit:isMoonlightDestinyUnit()
end

function UnitZodiac.updateUpgradeButton(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.vars.wnd:getChildByName("btn_up")
	local var_39_1 = arg_39_0:isDictMode() or arg_39_0:procFunc(nil, "checkEnhance", arg_39_1)
	local var_39_2 = "zodiac_reinforce_btn"
	
	if arg_39_0.vars.mode == "Potential" then
		var_39_2 = "ui_unit_zodiac2_btn_awake2"
	end
	
	if_set(var_39_0, "label", T(var_39_2))
	UIUtil:changeButtonState(var_39_0, var_39_1, true)
end

function UnitZodiac.getSkillBonusIdx(arg_40_0, arg_40_1)
	return DB("zodiac_stone_2", arg_40_0:getStoneID(arg_40_1), "skill_up")
end

function UnitZodiac.getSkillID(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0:getSkillBonusIdx(arg_41_1)
	
	if not var_41_0 then
		return 
	end
	
	local var_41_1 = UIUtil:getSkillByUIIdx(arg_41_0.vars.unit, var_41_0)
	
	if string.ends(var_41_1, "u") then
		return var_41_1
	end
	
	return var_41_1 .. "u"
end

function UnitZodiac.getStoneIDByUnit(arg_42_0, arg_42_1, arg_42_2)
	return string.format("%s_%d", arg_42_1.db.sphere_bonus_id, arg_42_2)
end

function UnitZodiac.getSkillBonusIdxByUnit(arg_43_0, arg_43_1, arg_43_2)
	return DB("zodiac_stone_2", arg_43_0:getStoneIDByUnit(arg_43_1, arg_43_2), "skill_up")
end

function UnitZodiac.getSkillIDByUnit(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0:getSkillBonusIdxByUnit(arg_44_1, arg_44_2)
	
	if not var_44_0 then
		return 
	end
	
	local var_44_1 = UIUtil:getSkillByUIIdx(arg_44_1, var_44_0)
	
	if string.ends(var_44_1, "u") then
		return var_44_1
	end
	
	return var_44_1 .. "u"
end

function UnitZodiac.getSphereGrade(arg_45_0)
	if arg_45_0:isDictMode() then
		return arg_45_0.vars.dict_grade
	end
	
	return arg_45_0.vars.unit:getZodiacGrade()
end

function UnitZodiac._zoomInBG(arg_46_0, arg_46_1, arg_46_2)
	arg_46_1 = arg_46_1 + arg_46_0.vars.x_offset
	arg_46_2 = arg_46_2 + arg_46_0.vars.y_offset
	
	local var_46_0 = arg_46_1 / DESIGN_WIDTH
	local var_46_1 = arg_46_2 / DESIGN_HEIGHT
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0.vars.back_layers) do
		if get_cocos_refid(iter_46_1[1]) then
			local var_46_2 = iter_46_1[2]
			local var_46_3 = 0.5 - (0.5 - var_46_0) * var_46_2
			local var_46_4 = 0.5 - (0.5 - var_46_1) * var_46_2
			local var_46_5 = iter_46_1[1]:getAnchorPoint()
			
			Action:Add(LOG(SPAWN(ANCHOR(300, {
				x = var_46_5.x,
				y = var_46_5.y
			}, {
				x = var_46_3,
				y = var_46_4
			}), SCALE(300, iter_46_1[1]:getScale(), iter_46_1[3]))), iter_46_1[1])
		end
	end
end

function UnitZodiac.getStoneID(arg_47_0, arg_47_1)
	return string.format("%s_%d", arg_47_0.vars.unit.db.sphere_bonus_id, arg_47_1)
end

function UnitZodiac.getSelectIdx(arg_48_0)
	if not arg_48_0.vars then
		return nil
	end
	
	return arg_48_0.vars.select_idx
end

function UnitZodiac.setMode(arg_49_0, arg_49_1)
	if arg_49_1 == arg_49_0.vars.mode then
		return 
	end
	
	local var_49_0 = arg_49_0.vars.mode
	local var_49_1 = arg_49_1
	
	arg_49_0.vars.mode = var_49_1
	
	if not var_49_0 then
	else
		arg_49_0:procFunc(var_49_0, "onModeLeave", var_49_1)
		arg_49_0:procFunc(var_49_1, "onModeEnter", var_49_0)
	end
	
	arg_49_0:updateSkillPoint()
	arg_49_0:updateInterfaces()
	arg_49_0:updateHelpButton()
	
	arg_49_0.vars.is_invisible_button_unit = EpisodeAdin:isAdinCode(arg_49_0:getUnit().db.code) and var_49_1 == "Rune"
	
	if arg_49_0.vars.is_invisible_button_unit then
		if_set_opacity(arg_49_0.vars.wnd, "btn_catalyst", 76.5)
		if_set_opacity(arg_49_0.vars.wnd, "btn_item_mix", 76.5)
	end
	
	local var_49_2 = arg_49_0.vars.wnd:getChildByName("LEFT")
	
	if_set_visible(var_49_2, "n_progress", var_49_1 == "Stone" and not arg_49_0:isDictMode())
	if_set_visible(var_49_2, "n_zodiac", var_49_1 == "Stone")
	if_set_visible(var_49_2, "n_skill", var_49_1 == "Rune")
	if_set_visible(var_49_2, "btn_skill_summary", var_49_1 == "Rune" and arg_49_0.vars.unit:isClassChangeableUnit() ~= nil)
	SoundEngine:play("event:/ui/zodiac/enter")
end

function UnitZodiac.openSkillSummary(arg_50_0)
	if not arg_50_0.vars then
		return 
	end
	
	local var_50_0 = arg_50_0.vars.unit
	
	if not var_50_0 then
		return 
	end
	
	local var_50_1 = var_50_0:isClassChangeableUnit()
	
	if not var_50_1 then
		return 
	end
	
	local var_50_2 = EpisodeAdin:isAdinCode(var_50_0.db.code) and UnitExtensionSkillList or ClassChangeSkillList
	local var_50_3 = ClassChange:openInfoPopup(var_50_2, SceneManager:getRunningPopupScene(), "ui_classchange_list_skill", var_50_1)
	
	if not get_cocos_refid(var_50_3) then
		return 
	end
	
	if arg_50_0.vars.force_front_show then
		var_50_3:bringToFront()
	end
end

function UnitZodiac.reqSkillReset(arg_51_0)
	if arg_51_0.vars.is_block_reset then
		balloon_message_with_sound("msg_cannot_use_btn_hero")
		
		return 
	end
	
	local var_51_0 = load_dlg("zodiac_skilltree_p_reset", true, "wnd")
	local var_51_1 = arg_51_0.vars.unit
	local var_51_2 = var_51_1:getSTreeTotalPoint()
	
	if var_51_2 == 0 then
		return balloon_message_with_sound("ui_rest_skilltree_zero")
	end
	
	local var_51_3 = var_51_1:getColor() .. "_" .. var_51_2
	local var_51_4, var_51_5 = DB("skill_tree_material", var_51_3, {
		"reset_token",
		"reset_count"
	})
	
	if_set(var_51_0, "txt_cost", var_51_5)
	Dialog:msgBox(T("ui_reset_skilltree_desc"), {
		yesno = true,
		dlg = var_51_0,
		handler = function()
			if UIUtil:checkCurrencyDialog(var_51_4, var_51_5) then
				query("skillrune_reset", {
					target = var_51_1:getUID()
				})
			end
		end,
		title = T("ui_reset_skilltree_title")
	})
end

function UnitZodiac.getSceneState(arg_53_0)
	if not arg_53_0.vars then
		return {}
	end
	
	return {
		unit = Account:getUnit(arg_53_0.vars.unit:getUID()),
		enter_mode = arg_53_0.vars.mode,
		start_mode = arg_53_0.vars.start_mode
	}
end

function UnitZodiac.updateSkillPoint(arg_54_0)
	if_set_visible(arg_54_0.vars.wnd, "n_skill_point", arg_54_0.vars.mode == "Rune" and not arg_54_0:isDictMode())
	
	if arg_54_0.vars.mode ~= "Rune" then
		return 
	end
	
	local var_54_0 = arg_54_0.vars.unit:getSTreeTotalPoint()
	local var_54_1 = "+"
	
	if var_54_0 < 0 then
		var_54_1 = "-"
	end
	
	if_set(arg_54_0.vars.wnd, "txt_count", var_54_1 .. var_54_0)
end

function UnitZodiac.updateSwapButtons(arg_55_0)
	if not arg_55_0.vars then
		return 
	end
	
	if not arg_55_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_55_0.vars.wnd) then
		return 
	end
	
	local var_55_0 = arg_55_0:getUnit()
	local var_55_1 = arg_55_0:isDictMode()
	local var_55_2 = arg_55_0.vars.mode == "Rune"
	local var_55_3 = arg_55_0.vars.mode == "Stone"
	local var_55_4 = arg_55_0.vars.mode == "Potential"
	local var_55_5 = arg_55_0.vars.zoom_idx ~= nil
	local var_55_6 = false
	local var_55_7 = (Account:getClassChangeInfo()[var_55_0.db.code] or {}).state == 2
	
	if var_55_0:getLv() < (GAME_STATIC_VARIABLE.class_change_level or 50) then
		var_55_7 = false
	end
	
	if var_55_5 and arg_55_0.vars.zoom_idx and arg_55_0.vars.zoom_idx < 0 then
		var_55_6 = arg_55_0:procFunc("Rune", "getEnhancable", math.abs(arg_55_0.vars.zoom_idx))
	end
	
	local var_55_8 = arg_55_0:procFunc("Rune", "isEnabled")
	local var_55_9 = arg_55_0:procFunc("Potential", "isEnabled")
	
	if_set_visible(arg_55_0.vars.wnd, "btn_go_awake", not var_55_3 and not var_55_5 and not var_55_1)
	if_set_visible(arg_55_0.vars.wnd, "btn_active_skilltree", var_55_7 and var_55_3 and not var_55_5 and not var_55_1)
	if_set_visible(arg_55_0.vars.wnd, "btn_go_skilltree", var_55_8 and not var_55_7 and var_55_3 and not var_55_5 and not var_55_1)
	if_set_visible(arg_55_0.vars.wnd, "btn_up", var_55_3 or var_55_4)
	if_set_visible(arg_55_0.vars.wnd, "btn_skill_enhancement", var_55_8 and not var_55_7 and var_55_2 and not var_55_1)
	if_set_opacity(arg_55_0.vars.wnd, "btn_skill_enhancement", var_55_5 and var_55_6 and 255 or 75)
	
	local var_55_10 = TutorialGuide:isClearedTutorial("char_awake_unlock") or TutorialGuide:isPlayingTutorial("char_awake_unlock")
	
	if_set_visible(arg_55_0.vars.wnd, "btn_go_potential", var_55_10 and var_55_9 and not var_55_4 and not var_55_5)
	if_set_opacity(arg_55_0.vars.wnd, "btn_go_potential", not (not var_55_0:isGrowthBoostRegistered() and not (var_55_0:getZodiacGrade() < 6)) and 75 or 255)
	
	if var_55_1 then
		local var_55_11 = arg_55_0.vars.wnd:getChildByName("disc_pannel")
		
		var_55_11._origin_size = {
			width = 280,
			height = 403
		}
		
		UIUserData:proc(var_55_11)
		
		if arg_55_0.vars.able_swap_button then
			local var_55_12 = arg_55_0.vars.wnd:findChildByName("btn_go_skilltree")
			
			if_set_visible(var_55_12, nil, var_55_8 and not var_55_2 and not var_55_5)
			if_set(var_55_12, "label", T("preview_skilltree"))
			
			local var_55_13 = arg_55_0.vars.wnd:findChildByName("btn_go_potential")
			
			if_set_visible(var_55_13, nil, var_55_9 and not var_55_4 and not var_55_5)
			
			local var_55_14 = arg_55_0.vars.wnd:findChildByName("btn_go_awake")
			
			if_set_visible(var_55_14, nil, (var_55_2 or var_55_4) and not var_55_5)
			
			local var_55_15 = arg_55_0.vars.wnd:findChildByName("btn_up")
			
			if get_cocos_refid(var_55_15) then
				if_set_position_y(var_55_12, nil, var_55_15:getPositionY())
				if_set_position_y(var_55_13, nil, var_55_15:getPositionY())
				if_set_position_y(var_55_14, nil, var_55_15:getPositionY())
			end
		end
	end
end

function UnitZodiac.updateInterfaces(arg_56_0, arg_56_1)
	arg_56_0:procFunc(nil, "updateInterfaces", arg_56_1)
	
	local var_56_0 = arg_56_0.vars.wnd:getChildByName("n_parts")
	
	if get_cocos_refid(var_56_0) then
		local var_56_1 = {}
		local var_56_2 = {}
		local var_56_3 = arg_56_0:procFunc(nil, "getNeedItemList") or {}
		
		for iter_56_0, iter_56_1 in ipairs(var_56_3) do
			local var_56_4 = iter_56_1[1]
			
			if var_56_4 and not var_56_2[var_56_4] then
				var_56_2[var_56_4] = true
				
				table.insert(var_56_1, var_56_4)
			end
		end
		
		for iter_56_2 = 1, 5 do
			if_set_visible(var_56_0, "n_res" .. iter_56_2, false)
		end
		
		for iter_56_3, iter_56_4 in pairs(var_56_1) do
			local var_56_5 = Account:getItemCount(iter_56_4)
			local var_56_6 = var_56_0:getChildByName("n_res" .. iter_56_3)
			
			if not var_56_6 then
				break
			end
			
			if_set_visible(var_56_0, "n_res" .. iter_56_3, true)
			
			local var_56_7 = TutorialGuide:isPlayingTutorial("char_awake_unlock")
			
			UIUtil:getRewardIcon(var_56_5, iter_56_4, {
				show_count = true,
				no_frame = true,
				scale = 0.8,
				parent = var_56_6,
				count = to_n(var_56_5),
				no_tooltip = var_56_7
			})
		end
		
		var_56_0.origin_pos_y = var_56_0.origin_pos_y or var_56_0:getPositionY()
		
		if arg_56_0.vars.mode == "Potential" and (ContentDisable:byAlias("essence_guide") or IS_PUBLISHER_ZLONG) then
			local var_56_8 = arg_56_0.vars.wnd:getChildByName("n_parts_move")
			
			if get_cocos_refid(var_56_8) then
				var_56_0:setPositionY(var_56_8:getPositionY())
			end
		else
			var_56_0:setPositionY(var_56_0.origin_pos_y)
		end
	end
	
	local var_56_9 = arg_56_0.vars.wnd:getChildByName("name")
	
	if get_cocos_refid(var_56_9) then
		if not arg_56_0:isDictMode() then
			UIUtil:setStarsByUnit(arg_56_0.vars.wnd:getChildByName("name"), arg_56_0:getUnit())
		end
		
		if_set_visible(var_56_9, "grow", arg_56_0.vars.mode ~= "Potential")
		if_set_visible(var_56_9, "bar1_l", arg_56_0.vars.mode ~= "Potential")
		if_set_visible(var_56_9, "bar1_r", arg_56_0.vars.mode ~= "Potential")
	end
	
	if_set_visible(arg_56_0.vars.wnd:getChildByName("LEFT"), "grow", arg_56_0.vars.mode ~= "Potential")
	arg_56_0.vars.wnd:getChildByName("progress"):setPercent(arg_56_0:getSphereGrade() * 100 / 6)
	if_set(arg_56_0.vars.wnd:getChildByName("n_progress"), "t_percent", string.format("%d%%", arg_56_0:getSphereGrade() * 100 / 6))
	if_set_visible(arg_56_0.vars.wnd, "keystone_lock1", arg_56_0.vars.unit.inst.keystone < 1)
	if_set_visible(arg_56_0.vars.wnd, "keystone_lock2", arg_56_0.vars.unit.inst.keystone < 2)
	arg_56_0:updateMainButtons()
	arg_56_0:updateSwapButtons()
	arg_56_0:updateLeftButtons()
	
	if arg_56_1 and arg_56_0.vars.hero_belt then
		arg_56_0.vars.hero_belt:updateUnit(nil, arg_56_0.vars.unit)
	end
end

function UnitZodiac.updateSidePanel(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0.vars.wnd:getChildByName("RIGHT")
	
	if not get_cocos_refid(var_57_0) then
		return 
	end
	
	if_set_visible(var_57_0, "n_potentail", arg_57_0.vars.mode == "Potential")
	
	for iter_57_0 = 1, 3 do
		for iter_57_1 = 1, iter_57_0 do
			if_set_visible(var_57_0, "n_lack_item" .. iter_57_1 .. "/" .. iter_57_0, false)
		end
	end
	
	arg_57_0:procFunc(nil, "updateSidePanel", var_57_0, arg_57_1)
end

function UnitZodiac.playPotentialTutorial(arg_58_0)
	if not arg_58_0.vars then
		return 
	end
	
	if TutorialCondition:isEnable("char_awake_unlock", {
		unit = arg_58_0.vars.unit
	}) then
		TutorialGuide:startGuide("char_awake_unlock")
		TutorialGuide:setOnFinish(function()
			if TutorialGuide:isPlayingTutorial("char_awake_unlock") then
				arg_58_0:procFunc("Potential", "createFlag")
				arg_58_0:procFunc("Potential", "updateComponents")
			end
			
			UIAction:Add(SEQ(DELAY(200), CALL(function()
				arg_58_0:updateInterfaces()
			end)), arg_58_0.vars.wnd, "block")
		end)
		
		for iter_58_0 = 1, 6 do
			if_set_color(arg_58_0:procFunc("Potential", "getStoneNode", iter_58_0), "Sprite_1", cc.c3b(255, 255, 255))
		end
		
		arg_58_0:updateSwapButtons()
	end
end

function UnitZodiac.procFunc(arg_61_0, arg_61_1, arg_61_2, ...)
	if arg_61_0.vars then
		local var_61_0 = arg_61_1 or arg_61_0.vars.mode
		
		if var_61_0 and arg_61_0.vars.childs[var_61_0] then
			local var_61_1 = arg_61_0.vars.childs[var_61_0]
			
			if var_61_1:isEnabled() and var_61_1[arg_61_2] then
				return var_61_1[arg_61_2](var_61_1, argument_unpack({
					...
				}))
			end
		end
	end
end

function UnitZodiac.onAfterUpdate(arg_62_0)
	arg_62_0:procFunc(nil, "onAfterUpdate")
end

function UnitZodiac.onTouchDown(arg_63_0, arg_63_1, arg_63_2)
	if UIAction:Find("block") then
		return 
	end
	
	if not TutorialGuide:isAllowEvent() then
		return 
	end
	
	local var_63_0 = arg_63_0:getZoomIndex() ~= nil
	
	arg_63_0:procFunc(nil, "onTouchDown", arg_63_1, arg_63_2, var_63_0)
	
	if var_63_0 then
		arg_63_0:focusOut()
	end
end

function UnitZodiac.onTouchUp(arg_64_0, arg_64_1, arg_64_2)
end

function UnitZodiac.displayUpgradeReward(arg_65_0, arg_65_1)
	arg_65_0:procFunc(nil, "displayUpgradeReward", arg_65_1)
end

function UnitZodiac.openMixWindow(arg_66_0)
	if not arg_66_0.vars then
		return nil
	end
	
	if not arg_66_0.vars.wnd then
		return nil
	end
	
	if arg_66_0.vars.is_invisible_button_unit then
		balloon_message_with_sound("msg_cannot_use_btn_hero")
		
		return 
	end
	
	if not get_cocos_refid(arg_66_0.vars.wnd) then
		return nil
	end
	
	UnitZodiacMix:open(arg_66_0.vars.wnd, arg_66_0.vars.unit.db.color)
end

function UnitZodiac.setZoomIndex(arg_67_0, arg_67_1)
	arg_67_0.vars.zoom_idx = arg_67_1
end

function UnitZodiac.getZoomIndex(arg_68_0)
	return arg_68_0.vars.zoom_idx
end

function UnitZodiac.focusIn(arg_69_0, arg_69_1)
	arg_69_0:procFunc(nil, "focusIn", arg_69_1)
	
	if arg_69_0:isDictMode() then
		if arg_69_0.vars.mode == "Stone" or arg_69_0.vars.mode == "Potential" then
			local var_69_0 = tonumber(arg_69_1)
			
			arg_69_0.vars.focus_idx = var_69_0
			
			arg_69_0:hideBtnUpOnDictMode()
			
			local var_69_1 = arg_69_0.vars.wnd:getChildByName("btn_prev")
			local var_69_2 = arg_69_0.vars.wnd:getChildByName("btn_next")
			local var_69_3 = var_69_1:isTouchEnabled()
			
			var_69_1:setTouchEnabled(var_69_0 > 1)
			
			if var_69_3 ~= var_69_1:isTouchEnabled() then
				if var_69_1:isTouchEnabled() then
					var_69_1:setOpacity(255)
					var_69_1:setColor(cc.c3b(255, 255, 255))
				else
					var_69_1:setColor(cc.c3b(76, 76, 76))
				end
			end
			
			local var_69_4 = var_69_2:isTouchEnabled()
			
			var_69_2:setTouchEnabled(var_69_0 < 6)
			
			if var_69_4 ~= var_69_2:isTouchEnabled() then
				if var_69_2:isTouchEnabled() then
					var_69_2:setColor(cc.c3b(255, 255, 255))
				else
					var_69_2:setColor(cc.c3b(76, 76, 76))
				end
			end
		else
			if_set_visible(arg_69_0.vars.wnd, "btn_prev", false)
			if_set_visible(arg_69_0.vars.wnd, "btn_next", false)
		end
	end
	
	arg_69_0:updateUpgradeButton(arg_69_0:getZoomIndex())
end

function UnitZodiac.zoominMaterial(arg_70_0, arg_70_1, arg_70_2)
	arg_70_0:_zoomInBG(arg_70_1, arg_70_2)
	SoundEngine:play("event:/ui/world_zoom")
	UIAction:Add(SLIDE_IN(200, -400), arg_70_0.vars.wnd:getChildByName("n_upgrade"), "block")
	arg_70_0:updateSwapButtons()
end

function UnitZodiac.focusOut(arg_71_0, arg_71_1, arg_71_2)
	arg_71_0:procFunc(nil, "focusOut")
	arg_71_0:zoomoutMaterial(arg_71_1, arg_71_2)
	arg_71_0:updateUpgradeButton()
end

function UnitZodiac.zoomoutMaterial(arg_72_0, arg_72_1, arg_72_2)
	if arg_72_0:isDictMode() then
		arg_72_0:showBtnUpOnDictMode()
	end
	
	arg_72_1 = arg_72_1 or 300
	
	for iter_72_0, iter_72_1 in pairs(arg_72_0.vars.back_layers) do
		if get_cocos_refid(iter_72_1[1]) then
			Action:Add(LOG(SPAWN(ANCHOR(arg_72_1, {
				x = 0.5,
				y = 0.5
			}), SCALE(arg_72_1, iter_72_1[1]:getScale(), 1))), iter_72_1[1])
		end
	end
	
	if not arg_72_2 then
		local var_72_0 = arg_72_0.vars.wnd:getChildByName("n_upgrade")
		
		if arg_72_0:getZoomIndex() and arg_72_0:getZoomIndex() <= 12 then
			UIAction:Add(SLIDE_OUT(200, 400), var_72_0, "block")
		end
	end
	
	UIAction:Add(SEQ(DELAY(200), CALL(arg_72_0.updateInterfaces, arg_72_0)), arg_72_0, "block")
	arg_72_0:setZoomIndex(nil)
	arg_72_0:updateSwapButtons()
end

function UnitZodiac.reqRuneEnhance(arg_73_0)
	arg_73_0:procFunc("Rune", "reqEnhance", arg_73_0:getZoomIndex())
end

function UnitZodiac.respRuneEnhance(arg_74_0, arg_74_1)
	arg_74_0:procFunc("Rune", "respEnhance", arg_74_1)
	arg_74_0:updateInterfaces(true)
	arg_74_0:updateSkillPoint()
end

function UnitZodiac.respStoneEnhance(arg_75_0, arg_75_1)
	arg_75_0:procFunc("Stone", "respEnhance", arg_75_1)
end

function UnitZodiac.respPotentialEnhance(arg_76_0, arg_76_1)
	arg_76_0:procFunc("Potential", "respEnhance", arg_76_1)
end
