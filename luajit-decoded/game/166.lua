function HANDLER_BEFORE.inbattle_hud(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_sinsu" then
		local var_1_0 = Battle.logic:getSummon(FRIEND)
		
		if var_1_0 then
			arg_1_0.touch_tm = systick()
			
			BattleUIAction:Add(SEQ(DELAY(300), CALL(function()
				if StageStateManager:getActionHandleByActor(var_1_0.model) then
					return 
				end
				
				local var_2_0 = UIUtil:getSkillTooltip(var_1_0, 1, {
					show_effs = "left"
				})
				
				var_2_0:setName("@sinsu_tooltip")
				WidgetUtils:showTooltip({
					tooltip = var_2_0,
					control = arg_1_0
				})
			end)), arg_1_0, "battle.sinsu_tooltip")
		end
	end
end

function HANDLER.inbattle_hud(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_sinsu" then
		if BattleUIAction:Find("battle.sinsu_tooltip") then
			BattleUIAction:Remove("battle.sinsu_tooltip")
		end
		
		local var_3_0 = Battle.logic:getSummon(FRIEND)
		
		if var_3_0 and get_cocos_refid(var_3_0.model) and StageStateManager:getActionHandleByActor(var_3_0.model) then
			return 
		end
		
		if systick() - to_n(arg_3_0.touch_tm) < 200 then
			BattleUI:fireSummonSkill()
		end
	end
end

function HANDLER.inbattle_replay(arg_4_0, arg_4_1)
	if Battle:isPlayingBattleAction() or StageStateManager:isRunning() or Battle.viewer and Battle.viewer:isRunning() then
		return 
	end
	
	if arg_4_1 == "btn_play" then
		BattleUI:getReplayController():play()
	elseif arg_4_1 == "btn_pause" then
		BattleUI:getReplayController():pause()
	elseif arg_4_1 == "btn_back" then
		BattleUI:getReplayController():ff()
	elseif arg_4_1 == "btn_back2" then
		BattleUI:getReplayController():ff2()
	elseif arg_4_1 == "btn_front" then
		BattleUI:getReplayController():rff()
	elseif arg_4_1 == "btn_front2" then
		BattleUI:getReplayController():rff2()
	end
end

local var_0_0 = {
	bp = cc.c3b(255, 0, 0),
	mp = cc.c3b(0, 0, 255),
	cp = cc.c3b(180, 180, 0),
	rp = cc.c3b(180, 0, 180)
}

local function var_0_1(arg_5_0)
	if_set_visible(arg_5_0, "n_guard", false)
	if_set_visible(arg_5_0, "n_idle_guide", false)
end

local var_0_2 = 450

function HANDLER.hud_order(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_select" then
		local var_6_0 = getParentWindow(arg_6_0)
		
		Battle:onSelectTarget(var_6_0.unit)
	end
end

function HANDLER.pvplive_global_hp(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_emoji" then
		if Battle:isPlayingBattleAction() then
			return 
		end
		
		if BattleUI:isVisibleEmojiPanel() then
			BattleUI:hideEmojiPanel()
		else
			BattleUI:showEmojiPanel()
		end
	elseif arg_7_1 == "btn_close" then
		BattleUI:hideEmojiPanel()
	elseif arg_7_1 == "btn_block" or arg_7_1 == "btn_block_on" then
		BattleUI:toggleEmogiBlock()
	end
end

UISpriteNumber = {}

local var_0_3 = {
	"0123456789,"
}

function UISpriteNumber.create(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = cc.Node:create()
	
	copy_functions(UISpriteNumber, var_8_0)
	
	local var_8_1 = "img/" .. arg_8_1 .. "%s.png"
	
	var_8_0._fontname = arg_8_1
	var_8_0._pattern = var_8_1
	var_8_0._frames = {}
	
	for iter_8_0 = 0, 9 do
		var_8_0._frames[tostring(iter_8_0)] = string.format(var_8_1, tostring(iter_8_0))
	end
	
	var_8_0._frames[","] = string.format(var_8_1, "c")
	var_8_0._invalid = "img/404.png"
	var_8_0._wrate = arg_8_2 or 0
	var_8_0._comma = true
	
	return var_8_0
end

function UISpriteNumber.setValue(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._minValue = arg_9_1 or 0
	arg_9_0._maxValue = arg_9_2 or arg_9_1
	
	arg_9_0:setString(arg_9_0._minValue, true)
end

function UISpriteNumber.setPercent(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._maxValue - arg_10_0._minValue
	local var_10_1 = arg_10_0._minValue + math.floor(var_10_0 * arg_10_1 / 100)
	
	arg_10_0:setString(var_10_1, true)
end

function UISpriteNumber.setString(arg_11_0, arg_11_1)
	arg_11_0._value = tostring(arg_11_1) or "0"
	
	if arg_11_0._comma then
		arg_11_1 = comma_value(arg_11_1)
	end
	
	local var_11_0 = string.len(arg_11_1)
	
	arg_11_0:removeAllChildren()
	
	arg_11_0._width = 0
	
	for iter_11_0 = 1, var_11_0 do
		local var_11_1 = arg_11_0._frames[string.sub(arg_11_1, iter_11_0, iter_11_0)] or arg_11_0._invalid
		local var_11_2 = cc.Sprite:create()
		
		SpriteCache:resetSprite(var_11_2, var_11_1)
		var_11_2:setPositionX(arg_11_0._width)
		
		arg_11_0._width = arg_11_0._width + var_11_2:getContentSize().width - var_11_2:getContentSize().width * (1 - arg_11_0._wrate)
		
		arg_11_0:addChild(var_11_2)
	end
end

UISkillIcon = {}

function UISkillIcon.create(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = arg_12_2 or cc.Sprite:create()
	
	local var_12_0 = string.format("skill/%s.png", DB("skill", arg_12_1, "sk_icon") or "404")
	
	SpriteCache:resetSprite(arg_12_2, var_12_0)
	
	return arg_12_2
end

UISkillButton = {}

function UISkillButton.create(arg_13_0, arg_13_1)
	local var_13_0 = load_control("wnd/hud_skill.csb")
	
	if arg_13_1.index then
		var_13_0:setName("btn_skill" .. arg_13_1.index)
	end
	
	var_13_0:setAnchorPoint(0.5, 0.5)
	if_set_visible(var_13_0, "selected", false)
	copy_functions(UISkillButton, var_13_0)
	var_13_0:init(arg_13_1)
	
	return var_13_0
end

function UISkillButton.init(arg_14_0, arg_14_1)
	arg_14_0.unit = arg_14_1.unit
	arg_14_0.skill_id = arg_14_1.skill_id
	arg_14_0.listener = arg_14_1.listener
	arg_14_0.prop = {}
	arg_14_0.prop.selected = arg_14_1.selected
	arg_14_0.skill, arg_14_0.skill_idx = arg_14_0.unit:getSkillBundle():get(arg_14_0.skill_id)
	arg_14_0.refer_skill_idx = arg_14_0.unit:getReferSkillIndex(arg_14_0.skill_id) or arg_14_0.skill_idx
	
	local var_14_0, var_14_1 = arg_14_0.skill:getSoulBurnSkill()
	
	arg_14_0.soulburn_skill = var_14_0
	arg_14_0.soulburn_cost = var_14_1
	
	arg_14_0:updateInfo()
	SceneManager:setTouchHandler(arg_14_0, arg_14_0)
end

function UISkillButton.setSoulState(arg_15_0, arg_15_1)
	if not arg_15_0.soulburn_skill then
		return 
	end
	
	arg_15_0.soul_state = arg_15_1
	
	arg_15_0:updateSoulStateIcon()
end

function UISkillButton.updateSoulStateIcon(arg_16_0)
	local var_16_0 = arg_16_0.soulburn_skill
	local var_16_1 = arg_16_0.soulburn_cost or 0
	local var_16_2 = arg_16_0:getChildByName("soul")
	local var_16_3 = math.floor(var_16_1 / GAME_STATIC_VARIABLE.max_soul_point)
	
	if var_16_0 and var_16_1 and not arg_16_0.soul_icon_ctrls then
		arg_16_0.soul_icon_ctrls = {}
		
		var_16_2:removeAllChildren()
		
		for iter_16_0 = 1, var_16_3 do
			local var_16_4 = SpriteCache:getScale9Sprite("img/cm_icon_star_s.png")
			
			var_16_4:setAnchorPoint(iter_16_0 * 0.7, 0)
			var_16_2:addChild(var_16_4)
			table.insert(arg_16_0.soul_icon_ctrls, var_16_4)
		end
	end
	
	local var_16_5 = arg_16_0.listener
	local var_16_6 = 1
	
	if arg_16_0.soul_state == "burn" then
		local var_16_7 = 0
	end
	
	local var_16_8 = Battle.viewer:getTeamRes(arg_16_0.unit.inst.ally, "soul_piece") or 0
	local var_16_9 = math.floor(var_16_8 / GAME_STATIC_VARIABLE.max_soul_point)
	
	if arg_16_0.soul_icon_ctrls then
		local var_16_10 = table.count(arg_16_0.soul_icon_ctrls)
		
		for iter_16_1, iter_16_2 in pairs(arg_16_0.soul_icon_ctrls) do
			local var_16_11 = 1
			local var_16_12 = arg_16_0.unit.states:isExistEffect("CSP_FREE_SOULBURN")
			local var_16_13 = var_16_3 - iter_16_1
			
			if arg_16_0.soul_state == "burn" and (var_16_13 < var_16_9 or var_16_12) then
				var_16_11 = 0
			end
			
			iter_16_2:setState(var_16_11)
		end
	end
end

function UISkillButton.updateIcon(arg_17_0)
	local var_17_0 = "icon"
	local var_17_1 = arg_17_0:getChildByName(var_17_0)
	local var_17_2 = arg_17_0.skill:getSkillId()
	local var_17_3 = arg_17_0.skill:getSkillIdForSkillLevel()
	local var_17_4 = arg_17_0.refer_skill_idx
	local var_17_5 = DB("skill", var_17_3, "skill_type")
	
	if var_17_5 == "random" or var_17_5 == "turn_self_random" then
		var_17_2 = var_17_3
		var_17_4 = arg_17_0.skill_idx
	end
	
	local var_17_6, var_17_7, var_17_8 = DB("skill", var_17_2, {
		"sk_icon",
		"sk_show",
		"sk_passive"
	})
	
	if not var_17_6 then
		Log.e("no skill icon : " .. arg_17_0.skill:getSkillId())
		
		return 
	end
	
	local var_17_9 = true
	
	if var_17_7 ~= "y" then
		var_17_9 = false
	end
	
	if var_17_9 then
		local var_17_10 = "skill/" .. var_17_6 .. ".png"
		
		SpriteCache:resetSprite(var_17_1, var_17_10)
		
		local var_17_11 = var_17_8 ~= nil
		local var_17_12 = string.ends(var_17_3, "u") or string.ends(var_17_3, "us")
		
		if_set_visible(arg_17_0, "upgrade", not var_17_11 and var_17_12)
		if_set_visible(arg_17_0, "upgrade_passive", var_17_11 and var_17_12)
		
		local var_17_13 = arg_17_0.unit:getExclusiveEffect(var_17_4)
		
		if var_17_13.effect ~= nil then
			if var_17_11 then
				if_set_sprite(arg_17_0, "exclusive", "skill/frame_skillenchant_passive.png")
			else
				if_set_sprite(arg_17_0, "exclusive", "skill/frame_skillenchant.png")
			end
		end
		
		if_set_visible(arg_17_0, "exclusive", var_17_13.effect ~= nil)
		if_set_visible(arg_17_0, "frame", not var_17_11)
	end
	
	arg_17_0:updateSoulStateIcon()
	arg_17_0:setVisible(var_17_9)
end

function UISkillButton.updateSelected(arg_18_0)
end

function UISkillButton.updateDesc(arg_19_0)
	local var_19_0, var_19_1, var_19_2, var_19_3, var_19_4 = arg_19_0.skill:checkUseSkill()
	local var_19_5 = arg_19_0.skill:getTurnCool()
	local var_19_6, var_19_7 = DB("skill", arg_19_0.skill:getSkillId(), {
		"sk_passive",
		"showcooltimeskill"
	})
	
	if var_19_6 then
		if var_19_7 then
			local var_19_8 = arg_19_0.unit:getSkillByIndex(to_n(var_19_7))
			
			var_19_5 = to_n(arg_19_0.unit:getSkillMaxCool(var_19_8))
			var_19_1 = arg_19_0.unit:getSkillCool(var_19_8)
		else
			var_19_5 = to_n(arg_19_0.unit:getSkillMaxCool(arg_19_0.skill:getSkillId()))
			var_19_1 = arg_19_0.unit:getSkillCool(arg_19_0.skill:getSkillId())
		end
		
		if to_n(var_19_1) > 0 then
			var_19_0 = false
		end
	end
	
	local var_19_9 = arg_19_0:getChildByName("cost")
	local var_19_10 = arg_19_0:getChildByName("cooltime")
	local var_19_11 = var_19_10:getChildByName("@cooltime")
	
	if not get_cocos_refid(var_19_11) then
		var_19_11 = WidgetUtils:createCircleProgress(var_19_6 and "img/cm_cool_skill_passive.png" or "img/cm_cool_skill.png")
		
		var_19_11:setName("@cooltime")
		var_19_11:setScale(1.3)
		var_19_11:setOpacity(150)
		var_19_10:addChild(var_19_11)
	end
	
	if var_19_0 then
		arg_19_0:setColor(cc.c3b(255, 255, 255))
		var_19_9:setVisible(false)
		var_19_10:setVisible(false)
	else
		var_19_9:setVisible(true)
		
		if var_19_1 and var_19_1 > 0 then
			arg_19_0:setColor(UIUtil.WHITE)
			var_19_10:setVisible(true)
			var_19_11:setPercentage(var_19_1 * 100 / var_19_5)
			var_19_11:setOpacity(150)
			var_19_9:setString(T("skill_cool", {
				turn = var_19_1
			}))
		else
			var_19_10:setVisible(false)
			
			if var_19_6 then
				var_19_9:setVisible(false)
			else
				arg_19_0:setColor(cc.c3b(100, 100, 100))
				
				if var_19_4 == 0 then
					var_19_9:setString(T("no_target"))
				elseif var_19_3 then
					var_19_9:setString(T("cant_use_sk"))
				else
					var_19_9:setString(T("lack_" .. arg_19_0.unit:getSPName()))
				end
			end
		end
	end
end

function UISkillButton.setSelected(arg_20_0, arg_20_1)
	if arg_20_0.prop.selected ~= arg_20_1 then
		arg_20_0.prop.selected = arg_20_1
		
		arg_20_0:updateSelected()
	end
end

function UISkillButton.isSelected(arg_21_0)
	return arg_21_0.prop.selected or false
end

function UISkillButton.doSelectSkill(arg_22_0)
	Battle:onTouchSkill(arg_22_0.skill_idx)
	SoundEngine:play("event:/ui/battle_hud/skill_select")
end

function UISkillButton.onTouchDown(arg_23_0)
	if not arg_23_0:isVisible(true) then
		return 
	end
	
	if TutorialGuide:checkBlockSkillButton(BattleUI.logic, arg_23_0.skill_idx) then
		return 
	end
	
	BattleUIAction:Add(SEQ(DELAY(200), CALL(arg_23_0.showSkillInfo, arg_23_0)), arg_23_0, "battle.skill_info_wait")
	
	if arg_23_0.disabled then
		return 
	end
	
	arg_23_0:doSelectSkill()
	
	if arg_23_0.last_down_time and uitick() - arg_23_0.last_down_time < 250 then
		local var_23_0, var_23_1, var_23_2 = arg_23_0.skill:checkUseSkill()
		
		if var_23_0 and not DB("skill", arg_23_0.skill_id, "sk_passive") then
			local var_23_3, var_23_4, var_23_5, var_23_6 = Battle.logic:AI_SelectSkillIdxAndTarget(getRandom(systick()), arg_23_0.unit, nil, arg_23_0.skill_id, true)
			
			Battle:onSelectTarget(var_23_6)
		end
	end
	
	arg_23_0.last_down_time = uitick()
end

function UISkillButton.isSoulburnSkill(arg_24_0)
	local var_24_0, var_24_1 = DB("skill", arg_24_0.skill:getSkillId(), {
		"soul_req",
		"soulburn_skill"
	})
	
	if to_n(var_24_0) > 0 or var_24_1 then
		return true
	end
	
	return false
end

function UISkillButton.playSoulBurnSelectEffect(arg_25_0, arg_25_1)
	if arg_25_1 then
		local var_25_0 = arg_25_0:isSoulburnSkill()
		local var_25_1 = Battle.viewer:getTeamRes(arg_25_0.unit.inst.ally, "soul_piece") or 0
		local var_25_2 = arg_25_0.unit.states:isExistEffect("CSP_FREE_SOULBURN")
		
		if var_25_0 and (var_25_1 >= to_n(arg_25_0.soulburn_cost) or var_25_2) then
			EffectManager:Play({
				scale = 0.5,
				fn = "ui_soul_burn_use.cfx",
				y = 50,
				x = 50,
				layer = arg_25_0
			})
			
			arg_25_0.disabled = nil
			
			return true
		else
			arg_25_0.disabled = true
			
			arg_25_0:setColor(UIUtil.DARK_GREY)
		end
	else
		arg_25_0.disabled = nil
		
		arg_25_0:updateDesc()
	end
end

function UISkillButton.onTouchUp(arg_26_0, arg_26_1)
	if BattleUIAction:Find("battle.skill_info_wait") then
		BattleUIAction:Remove("battle.skill_info_wait")
	end
end

function UISkillButton.showSkillInfo(arg_27_0)
	local var_27_0 = UIUtil:getSkillTooltip(arg_27_0.unit, arg_27_0.skill_idx, {
		show_effs = "left",
		show_random_set = true
	})
	
	WidgetUtils:showTooltip({
		no_sound = true,
		style = "fade",
		tooltip = var_27_0,
		control = arg_27_0
	})
end

function UISkillButton.hideSkillInfo(arg_28_0)
	if arg_28_0.skill_info_time ~= nil then
		local var_28_0 = math.max(0, 500 - (uitick() - arg_28_0.skill_info_time))
		
		BattleUIAction:Add(SEQ(DELAY(var_28_0), FADE_OUT(300)), arg_28_0.skill_info, "battle.skill_info")
		
		arg_28_0.skill_info_time = nil
	end
end

function UISkillButton.updateInfo(arg_29_0)
	arg_29_0:updateIcon()
	arg_29_0:updateDesc()
	arg_29_0:updateSelected()
end

UISkillButtonGroup = {}

function UISkillButtonGroup.create(arg_30_0, arg_30_1)
	if not get_cocos_refid(arg_30_1.battle_wnd) then
		return 
	end
	
	local var_30_0 = arg_30_1.battle_wnd:getChildByName("skill")
	
	var_30_0.battleUI = arg_30_1
	var_30_0.button_slots = {}
	
	for iter_30_0 = 1, 10 do
		local var_30_1 = arg_30_1.battle_wnd:getChildByName(string.format("n_skill%d", iter_30_0))
		
		if not var_30_1 then
			break
		end
		
		var_30_0.button_slots[iter_30_0] = var_30_1
	end
	
	var_30_0.soulburn_button = UISoulBurnButton(arg_30_1)
	
	var_30_0.soulburn_button:setVisible(false)
	
	if NotchStatus:isRequireAdjustEdge() then
		local var_30_2 = var_30_0:getPositionX()
		
		if var_30_0.origin_x then
			var_30_2 = var_30_0.origin_x
		end
		
		var_30_0:setPositionX(var_30_2 - NotchStatus:getAdjustEdgeValue())
	end
	
	var_30_0.origin_x = var_30_0:getPositionX()
	var_30_0.origin_y = var_30_0:getPositionY()
	
	return copy_functions(UISkillButtonGroup, var_30_0)
end

function UISkillButtonGroup.hide(arg_31_0)
	arg_31_0.soulburn_button:setVisible(false)
	arg_31_0:setVisible(false)
	
	if BattleUIAction:Find(arg_31_0) then
		BattleUIAction:Remove(arg_31_0)
		arg_31_0:setPosition(arg_31_0.origin_x, arg_31_0.origin_y)
	end
	
	if BattleUI.skill_button_group.selection then
		BattleUI.skill_button_group.selection:setVisible(false)
		BattleUI.skill_button_group.selection:setOpacity(0)
		
		if BattleUIAction:Find(BattleUI.skill_button_group.selection) then
			BattleUIAction:Remove(BattleUI.skill_button_group.selection)
		end
	end
	
	BattleUIAction:Remove("battle.guide_target_focus")
	BattleUIAction:Remove("battle.guide")
	BattleUI:removeGuideFocusRing(arg_31_0)
end

function UISkillButtonGroup.show(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0.unit = arg_32_1
	
	local var_32_0 = arg_32_1:getActiveSkillIds()
	
	arg_32_0.selected_skill_idx = arg_32_0.selected_skill_idx or 1
	
	if arg_32_0.skill_buttons then
		for iter_32_0, iter_32_1 in pairs(arg_32_0.skill_buttons) do
			if get_cocos_refid(iter_32_1) then
				iter_32_1:removeFromParent()
			end
		end
	end
	
	local var_32_1 = 1
	local var_32_2 = 1
	
	for iter_32_2, iter_32_3 in pairs(arg_32_0.button_slots) do
		iter_32_3:removeAllChildren()
	end
	
	arg_32_0.skill_buttons = {}
	
	for iter_32_4 = 1, #var_32_0 do
		local var_32_3 = iter_32_4 == arg_32_0.selected_skill_idx
		local var_32_4 = UISkillButton:create({
			index = iter_32_4,
			unit = arg_32_1,
			skill_id = var_32_0[iter_32_4],
			selected = var_32_3,
			listener = arg_32_0
		})
		
		arg_32_0.skill_buttons[var_32_1] = var_32_4
		
		local var_32_5, var_32_6 = arg_32_0.skill_buttons[var_32_1]:getPosition()
		
		arg_32_0.skill_buttons[var_32_1]:setPositionX(DESIGN_WIDTH + arg_32_0:getContentSize().width)
		
		local var_32_7 = NONE()
		
		if iter_32_4 == #var_32_0 or var_32_1 == 3 then
			var_32_7 = CALL(function()
				TutorialGuide:onShowSkillButtons(BattleUI.logic)
			end)
		end
		
		if arg_32_2 then
			arg_32_0.button_slots[var_32_2]:addChild(arg_32_0.skill_buttons[var_32_1])
			
			var_32_2 = var_32_2 + 1
			
			arg_32_0.skill_buttons[var_32_1]:setVisible(true)
			arg_32_0.skill_buttons[var_32_1]:setPosition(var_32_5, var_32_6)
		elseif arg_32_0.skill_buttons[var_32_1]:isVisible() then
			arg_32_0.button_slots[var_32_2]:addChild(arg_32_0.skill_buttons[var_32_1])
			
			var_32_2 = var_32_2 + 1
			
			BattleUIAction:Add(SEQ(FADE_IN(0), DELAY(150 * var_32_1 - 1), SPAWN(BEZIER(MOVE_TO(var_0_2, var_32_5, var_32_6), {
				0,
				1,
				0.57,
				1
			}), SCALE_TO(var_0_2, 1)), var_32_7), arg_32_0.skill_buttons[var_32_1], "battle")
		else
			arg_32_0.button_slots[1]:addChild(arg_32_0.skill_buttons[var_32_1])
			BattleUIAction:Add(var_32_7, arg_32_0.skill_buttons[var_32_1], "battle")
		end
		
		if var_32_1 == 3 then
			break
		end
		
		var_32_1 = var_32_1 + 1
	end
	
	local var_32_8 = 380
	local var_32_9 = 200
	local var_32_10, var_32_11 = arg_32_0:getPosition()
	
	if Battle:isReplayMode() or Battle:isRealtimeMode() then
		var_32_10 = arg_32_0.origin_x
		var_32_11 = arg_32_0.origin_y
	end
	
	if arg_32_2 then
		arg_32_0:setVisible(true)
		arg_32_0:setPosition(var_32_10, var_32_11)
		arg_32_0:setScale(1)
		
		if BattleUI.skill_button_group.selection then
			BattleUI.skill_button_group.selection:setVisible(true)
			BattleUI.skill_button_group.selection:setOpacity(255)
		end
	else
		arg_32_0:setPositionX(DESIGN_WIDTH + arg_32_0:getContentSize().width)
		BattleUIAction:Add(SEQ(DELAY(280), FADE_IN(0), SPAWN(BEZIER(MOVE_TO(var_32_8, var_32_10, var_32_11), {
			0,
			1,
			0.8,
			1
		}), SCALE_TO(var_32_8, 1))), arg_32_0, "battle")
		
		if BattleUI.skill_button_group.selection then
			BattleUIAction:Add(SEQ(FADE_OUT(0), DELAY(450), FADE_IN(200)), BattleUI.skill_button_group.selection, "battle")
		end
	end
	
	arg_32_0.soulburn_button:checkShow(arg_32_0.unit)
end

function UISkillButtonGroup.highlightSkill(arg_34_0, arg_34_1)
	for iter_34_0, iter_34_1 in pairs(arg_34_0.skill_buttons or {}) do
		if arg_34_1 then
			local var_34_0 = iter_34_0 == arg_34_0.selected_skill_idx
			
			if_set_color(iter_34_1, "icon", var_34_0 and cc.c3b(255, 255, 255) or cc.c3b(91, 91, 91))
		else
			if_set_color(iter_34_1, "icon", cc.c3b(255, 255, 255))
		end
	end
end

function UISkillButtonGroup.playSoulBurnSelectEffect(arg_35_0, arg_35_1)
	local var_35_0 = Battle.viewer:getTeamRes(arg_35_0.unit.inst.ally, "soul_piece") or 0
	local var_35_1 = arg_35_0.unit.states:isExistEffect("CSP_FREE_SOULBURN")
	local var_35_2 = arg_35_0.selected_skill_idx
	local var_35_3
	
	if var_35_2 then
		local var_35_4 = arg_35_0.skill_buttons[var_35_2]
		
		if var_35_4 and var_35_4:isSoulburnSkill() and (var_35_0 >= to_n(var_35_4.soulburn_cost) or var_35_1) then
			var_35_3 = var_35_2
		end
	end
	
	for iter_35_0, iter_35_1 in pairs(arg_35_0.skill_buttons) do
		local var_35_5 = arg_35_0.skill_buttons[iter_35_0]
		
		if var_35_5 then
			local var_35_6 = var_35_5:isSoulburnSkill()
			
			if not var_35_3 and var_35_6 and (var_35_0 >= to_n(var_35_5.soulburn_cost) or var_35_1) then
				var_35_3 = iter_35_0
			end
			
			if var_35_3 and var_35_3 == iter_35_0 then
				Battle:selectSkill({
					force = true,
					idx = iter_35_0
				})
			end
			
			var_35_5:playSoulBurnSelectEffect(arg_35_1)
		end
	end
	
	if arg_35_0.selection then
		arg_35_0.selection:setVisible(not arg_35_1)
	end
end

function UISkillButtonGroup.setSoulState(arg_36_0, arg_36_1)
	for iter_36_0, iter_36_1 in pairs(arg_36_0.skill_buttons) do
		iter_36_1:setSoulState(arg_36_1)
	end
	
	arg_36_0.soulburn_button:setButtonMode(arg_36_1)
end

function UISkillButtonGroup.getSelectedIdx(arg_37_0)
	return arg_37_0.selected_skill_idx
end

function UISkillButtonGroup.getSelected(arg_38_0)
	return arg_38_0.selected_skill_button, {
		idx = arg_38_0.selected_skill_idx,
		skill = arg_38_0.selected_skill
	}
end

function UISkillButtonGroup.removeSoulSelection(arg_39_0)
	local var_39_0 = "@SOUL_BURN_EFFECT"
	
	if not get_cocos_refid(arg_39_0.soul_selection) then
		arg_39_0.soul_selection = arg_39_0:getChildByName(var_39_0)
	end
	
	if get_cocos_refid(arg_39_0.soul_selection) then
		arg_39_0.soul_selection:stop()
		arg_39_0.soul_selection:removeFromParent()
	end
end

function UISkillButtonGroup.getSoulSelection(arg_40_0, arg_40_1)
	local var_40_0 = "@SOUL_BURN_EFFECT"
	
	if not get_cocos_refid(arg_40_0.soul_selection) then
		arg_40_0.soul_selection = arg_40_0:getChildByName(var_40_0)
		
		if get_cocos_refid(arg_40_0.soul_selection) then
			arg_40_0.soul_selection:stop()
			arg_40_0.soul_selection:removeFromParent()
		end
		
		local var_40_1, var_40_2 = arg_40_0.button_slots[arg_40_1]:getPosition()
		
		arg_40_0.soul_selection = EffectManager:Play({
			extractNodes = true,
			fn = "hud_skill_select_burn.cfx",
			layer = arg_40_0,
			x = var_40_1,
			y = var_40_2,
			node_name = var_40_0
		})
	end
	
	return arg_40_0.soul_selection
end

function UISkillButtonGroup.getSelection(arg_41_0)
	if not get_cocos_refid(arg_41_0.selection) then
		arg_41_0.selection = su.CompositiveEffect2D:create(getEffectPath("hud_skill_select_nomal.cfx"))
		
		arg_41_0.selection:setScaleFactor(BASE_SCALE)
		arg_41_0.selection:setName("@SELECTOR")
		arg_41_0:removeChildByName("@SELECTOR")
		arg_41_0:addChild(arg_41_0.selection)
		arg_41_0.selection:start()
	end
	
	return arg_41_0.selection
end

function UISkillButtonGroup.setSelected(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = arg_42_0.selected_skill_button and 50 or 0
	
	arg_42_0.selected_skill_idx = arg_42_1
	arg_42_0.selected_skill_button = nil
	
	if arg_42_0.soulburn_button:getMode() ~= "burn" then
		arg_42_0:removeSoulSelection()
	end
	
	if arg_42_0.unit then
		arg_42_0.selected_skill = arg_42_0.unit:getSkillBundle():slot(arg_42_1)
		
		for iter_42_0, iter_42_1 in pairs(arg_42_0.skill_buttons) do
			if iter_42_0 == arg_42_1 then
				local var_42_1, var_42_2 = arg_42_0.button_slots[iter_42_0]:getPosition()
				
				if arg_42_0.soulburn_button:getMode() == "burn" then
					arg_42_0:getSelection():setVisible(false)
					UIAction:Add(MOVE_TO(var_42_0, var_42_1, var_42_2), arg_42_0:getSoulSelection(iter_42_0))
				else
					arg_42_0:getSelection():setVisible(true)
				end
				
				UIAction:Add(MOVE_TO(var_42_0, var_42_1, var_42_2), arg_42_0:getSelection())
				iter_42_1:setSelected(true)
				
				arg_42_0.selected_skill_button = iter_42_1
			else
				iter_42_1:setSelected(false)
			end
		end
	end
end

function UISkillButtonGroup.checkCollision(arg_43_0, arg_43_1, arg_43_2)
	local function var_43_0(arg_44_0, arg_44_1, arg_44_2)
		if not arg_44_0 then
			return 
		end
		
		local var_44_0 = SceneManager:convertToSceneSpace(arg_44_0, {
			x = 0,
			y = arg_44_2
		}).y
		local var_44_1 = SceneManager:convertToSceneSpace(arg_44_0, {
			x = 0,
			y = -arg_44_2
		}).y
		local var_44_2 = SceneManager:convertToSceneSpace(arg_44_0, {
			y = 0,
			x = -arg_44_1
		}).x
		local var_44_3 = SceneManager:convertToSceneSpace(arg_44_0, {
			y = 0,
			x = arg_44_1
		}).x
		
		return {
			top = var_44_0,
			bottom = var_44_1,
			left = var_44_2,
			right = var_44_3
		}
	end
	
	arg_43_1, arg_43_2 = SceneManager:convertLocation(arg_43_1, arg_43_2)
	
	for iter_43_0, iter_43_1 in pairs(arg_43_0.button_slots or {}) do
		local var_43_1 = var_43_0(iter_43_1, 50, 50)
		
		if var_43_1 and arg_43_1 >= var_43_1.left and arg_43_1 <= var_43_1.right and arg_43_2 <= var_43_1.top and arg_43_2 >= var_43_1.bottom then
			return true
		end
	end
	
	return false
end

UIPenaltyButton = {}

function UIPenaltyButton.create(arg_45_0, arg_45_1)
	local var_45_0 = load_control("wnd/hud_skill.csb")
	
	var_45_0:setName("penalty_icon")
	var_45_0:setAnchorPoint(0.5, 0.5)
	if_set_visible(var_45_0, "selected", false)
	copy_functions(UIPenaltyButton, var_45_0)
	var_45_0:init(arg_45_1)
	
	return var_45_0
end

function UIPenaltyButton.init(arg_46_0, arg_46_1)
	arg_46_0.listener = arg_46_1.listener
	arg_46_0.callbackActive = arg_46_1.callbackActive
	
	arg_46_0:createEffect()
	SceneManager:setTouchHandler(arg_46_0, arg_46_0)
end

function UIPenaltyButton.createEffect(arg_47_0)
	if not get_cocos_refid(arg_47_0.effect) then
		arg_47_0.effect = su.CompositiveEffect2D:create(getEffectPath("hud_skill_select_nomal.cfx"))
		
		arg_47_0.effect:setScaleFactor(BASE_SCALE)
		arg_47_0.effect:setPosition(50, 50)
		arg_47_0.effect:setName("@SELECTOR")
		arg_47_0:removeChildByName("@SELECTOR")
		arg_47_0:addChild(arg_47_0.effect)
		arg_47_0.effect:start()
		arg_47_0.effect:setVisible(false)
	end
end

function UIPenaltyButton.updateInfo(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	arg_48_0.db_turn = arg_48_1
	arg_48_0.damage = arg_48_4
	
	arg_48_0:updateIcon(arg_48_1)
	arg_48_0:updateDesc(arg_48_2, arg_48_3)
end

function UIPenaltyButton.updateIcon(arg_49_0, arg_49_1)
	local var_49_0 = "skill/" .. DB("pvp_penalty", arg_49_1, {
		"icon"
	}) .. ".png"
	local var_49_1 = arg_49_0:getChildByName("icon")
	
	SpriteCache:resetSprite(var_49_1, var_49_0)
	if_set_visible(arg_49_0, "upgrade_passive", false)
	if_set_visible(arg_49_0, "upgrade", false)
	if_set_visible(arg_49_0, "cooltime", false)
	if_set_visible(arg_49_0, "soul", false)
	if_set_visible(arg_49_0, "cost", false)
	if_set_visible(arg_49_0, "exclusive", false)
	if_set_visible(arg_49_0, "frame", true)
	arg_49_0:setVisible(true)
end

function UIPenaltyButton.updateDesc(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_0:getChildByName("cooltime")
	local var_50_1 = var_50_0:getChildByName("@cooltime")
	
	if not get_cocos_refid(var_50_1) then
		var_50_1 = WidgetUtils:createCircleProgress("img/cm_cool_skill.png")
		
		var_50_1:setName("@cooltime")
		var_50_1:setScale(1.3)
		var_50_1:setOpacity(150)
		var_50_0:addChild(var_50_1)
	end
	
	local function var_50_2()
		var_50_0:setVisible(false)
		var_50_1:setPercentage(0)
		arg_50_0.callbackActive(false)
		arg_50_0.effect:setVisible(true)
	end
	
	local function var_50_3()
		var_50_0:setVisible(true)
		var_50_1:setPercentage(math.clamp((arg_50_1 - 1) * 100 / arg_50_2, 0, 100))
		arg_50_0.callbackActive(true)
		arg_50_0.effect:setVisible(false)
	end
	
	if arg_50_1 <= 1 then
		var_50_2()
	else
		var_50_3()
	end
end

function UIPenaltyButton.onTouchDown(arg_53_0)
	if not arg_53_0:isVisible(true) then
		return 
	end
	
	BattleUIAction:Add(SEQ(CALL(BattleTopBar.initPenaltyInfo, arg_53_0.listener, arg_53_0.db_turn, arg_53_0.damage), DELAY(200), CALL(BattleTopBar.showPenaltyInfo, arg_53_0.listener)), arg_53_0, "battle.penalty_info_wait")
end

function UIPenaltyButton.onTouchUp(arg_54_0, arg_54_1)
	if Battle:isBlockTouchEvent() then
		return 
	end
	
	BattleUIAction:Remove("battle.penalty_info_wait")
	BattleTopBar:hidePenaltyInfo()
end

UIScorePanel = ClassDef()

function UIScorePanel.constructor(arg_55_0, arg_55_1, arg_55_2)
	arg_55_0.wnd = load_control("wnd/inbattle_score_board.csb")
	
	arg_55_0.wnd:setVisible(false)
	arg_55_0.wnd:setLocalZOrder(10)
	
	arg_55_0.base = nil
	
	if arg_55_2:isScoreType() then
		arg_55_0.base = arg_55_0.wnd:getChildByName("n_score")
		
		if_set_visible(arg_55_0.wnd, "n_expedition", false)
	elseif arg_55_2:isExpeditionType() then
		arg_55_0.base = arg_55_0.wnd:getChildByName("n_expedition")
		
		if_set_visible(arg_55_0.wnd, "n_score", false)
	end
	
	arg_55_0.base:setVisible(true)
	BattleField:addUIControl(arg_55_0.wnd)
	
	arg_55_0.battleUI = arg_55_1
	
	arg_55_0:update()
	
	arg_55_0.logic = arg_55_2
	
	local var_55_0 = cc.Label:createWithBMFont("font/score.fnt", 0)
	
	var_55_0:setName("damage_label")
	var_55_0:setAnchorPoint(1, 1)
	
	local var_55_1 = arg_55_0.base:getChildByName("n_score_font")
	
	if get_cocos_refid(var_55_1) then
		arg_55_0.score = var_55_0
		
		var_55_1:addChild(var_55_0)
	end
	
	arg_55_0.wnd_x = arg_55_0.wnd:getPositionX()
	
	if arg_55_2:isScoreType() then
		arg_55_0:initTrialHall()
	elseif arg_55_2:isExpeditionType() then
		arg_55_0:initExpedition()
	end
end

function UIScorePanel.initTrialHall(arg_56_0)
	arg_56_0.rank_value = 1
	arg_56_0.next_score = 0
	
	if_set_sprite(arg_56_0.base, "rank_raid", "rank_raid_f.png")
	
	local var_56_0 = arg_56_0.base:getChildByName("rank_raid")
	
	if get_cocos_refid(var_56_0) then
		arg_56_0.rank_x = var_56_0:getPositionX()
	end
	
	arg_56_0.score_rate = DB("level_enter", arg_56_0.logic.map.enter, "score_rate") or 1
end

function UIScorePanel.initExpedition(arg_57_0)
end

function UIScorePanel.updateTrialScore(arg_58_0)
	if not get_cocos_refid(arg_58_0.score) then
		return 
	end
	
	local var_58_0 = math.floor(to_n(arg_58_0.logic:getTrialScore()) * arg_58_0.score_rate)
	
	if arg_58_0.score_value == var_58_0 or var_58_0 == 0 then
		return 
	end
	
	arg_58_0.score:setString(comma_value(var_58_0))
	
	arg_58_0.score_value = var_58_0
	
	BattleUIAction:Add(SEQ(SCALE_TO(0, 2), SPAWN(SCALE_TO(80, 0.9)), SCALE_TO(30, 1)), arg_58_0.score, "battle")
	
	if arg_58_0.rank_value < 12 and var_58_0 > arg_58_0.next_score then
		local var_58_1
		local var_58_2
		local var_58_3
		
		for iter_58_0 = 1, 12 do
			local var_58_4 = string.format("trialhall_rank_%d", iter_58_0)
			local var_58_5, var_58_6 = DB("challenge_rank", var_58_4, {
				"rank",
				"rank_point"
			})
			
			var_58_3 = var_58_6
			
			if var_58_0 < to_n(var_58_6) then
				break
			end
			
			var_58_2 = iter_58_0
			var_58_1 = var_58_5
		end
		
		arg_58_0.next_score = to_n(var_58_3)
		
		if arg_58_0.rank_value ~= var_58_2 then
			arg_58_0.rank_value = var_58_2
			
			local var_58_7 = arg_58_0.base:getChildByName("rank_raid")
			
			if get_cocos_refid(var_58_7) then
				var_58_7:setPositionX(arg_58_0.rank_x + 100)
				
				local var_58_8 = string.replace(var_58_1, "+", "_plus")
				
				if_set_sprite(arg_58_0.base, "rank_raid", string.format("rank_raid_%s.png", var_58_8))
				BattleUIAction:Add(SEQ(MOVE_TO(160, arg_58_0.rank_x, var_58_7:getPositionY())), var_58_7, "battle")
			end
		end
	end
end

function UIScorePanel._updateExpeditionPannel(arg_59_0, arg_59_1)
	if not get_cocos_refid(arg_59_0.base) then
		return 
	end
	
	if not get_cocos_refid(arg_59_0.score) then
		return 
	end
	
	local var_59_0 = arg_59_0.base:getChildByName("n_ex_score")
	local var_59_1 = tostring(Account:getUserId())
	
	for iter_59_0, iter_59_1 in pairs(arg_59_1) do
		local var_59_2 = iter_59_1.rank
		
		if tostring(iter_59_1.uid) == var_59_1 then
			local var_59_3 = to_n(iter_59_1.total_score) + arg_59_0.logic:getExpeditionScore()
			
			arg_59_0.score:setString(comma_value(var_59_3))
			if_set(var_59_0, "t_my_rank", T("expedition_rank", {
				rank = var_59_2
			}))
			
			local var_59_4 = var_59_0:getChildByName("my_face_icon")
			
			if get_cocos_refid(var_59_4) then
				if not get_cocos_refid(var_59_4:getChildByName("unit_icon")) then
					local var_59_5 = DB("character", iter_59_1.leader_code, "face_id")
					
					if var_59_5 then
						local var_59_6 = SpriteCache:getSprite("face/" .. var_59_5 .. "_s.png")
						
						var_59_6:setName("unit_icon")
						var_59_6:setScale(0.7)
						var_59_4:addChild(var_59_6)
					end
				end
				
				if not get_cocos_refid(var_59_4:getChildByName("frame_icon")) then
					local var_59_7, var_59_8 = DB("item_material", iter_59_1.border_code, {
						"icon",
						"frame_effect"
					})
					
					if var_59_7 then
						local var_59_9 = SpriteCache:getSprite("item/" .. var_59_7 .. ".png")
						
						var_59_9:setName("frame_icon")
						var_59_9:setScale(0.7)
						var_59_4:addChild(var_59_9)
						if_set_effect(var_59_4, nil, var_59_8)
					end
				end
			end
		end
	end
end

local function var_0_4(arg_60_0)
	if arg_60_0 < 10000 then
		return comma_value(arg_60_0)
	end
	
	local var_60_0 = ""
	local var_60_1 = 0
	
	while true do
		arg_60_0 = arg_60_0 / 10000
		
		if arg_60_0 < 1 then
			break
		end
		
		if var_60_1 >= 4 then
			break
		end
		
		var_60_1 = var_60_1 + 1
		arg_60_0 = arg_60_0 * 10
	end
	
	local var_60_2 = ({
		"K",
		"M",
		"B",
		"T"
	})[var_60_1] or ""
	
	arg_60_0 = arg_60_0 * 10000
	
	local var_60_3 = 4 - string.len(tostring(math.floor(arg_60_0)))
	
	arg_60_0 = math.floor(arg_60_0 * 10^var_60_3) / 10^var_60_3
	
	return comma_value(arg_60_0) .. var_60_2
end

function UIScorePanel._updateExpeditionRank(arg_61_0, arg_61_1)
	if not get_cocos_refid(arg_61_0.base) then
		return 
	end
	
	local var_61_0 = arg_61_0.base:getChildByName("n_ex_rank")
	local var_61_1 = tostring(Account:getUserId())
	
	for iter_61_0 = 1, 3 do
		local var_61_2 = arg_61_0.base:getChildByName("n_rank_" .. iter_61_0)
		local var_61_3 = var_61_2:getChildByName("inbattle_expedition_ranker")
		
		if not get_cocos_refid(var_61_3) then
			var_61_3 = load_control("wnd/inbattle_expedition_ranker.csb")
			
			var_61_2:addChild(var_61_3)
		end
		
		local var_61_4 = arg_61_1[iter_61_0]
		
		if not var_61_4 then
			var_61_3:setVisible(false)
		else
			local var_61_5 = to_n(var_61_4.rank)
			
			var_61_3:setVisible(true)
			
			local var_61_6
			local var_61_7
			
			if iter_61_0 > 1 then
				var_61_6 = var_61_3:getChildByName("n_2_3")
				var_61_7 = var_61_3:getChildByName("n_1")
			else
				var_61_6 = var_61_3:getChildByName("n_1")
				var_61_7 = var_61_3:getChildByName("n_2_3")
			end
			
			if_set(var_61_6, "rank", T("expedition_rank", {
				rank = var_61_5
			}))
			var_61_6:setVisible(true)
			var_61_7:setVisible(false)
			
			local var_61_8 = tostring(var_61_4.uid)
			local var_61_9 = to_n(var_61_4.total_score)
			
			if var_61_8 == var_61_1 then
				var_61_9 = var_61_9 + arg_61_0.logic:getExpeditionScore()
			end
			
			if_set(var_61_3, "damage", var_0_4(var_61_9))
			
			if var_61_6._user_id ~= var_61_8 then
				var_61_6._user_id = var_61_8
				
				local var_61_10 = var_61_6:getChildByName("face_icon")
				
				if get_cocos_refid(var_61_10) then
					var_61_10:removeChildByName("unit_icon")
					
					local var_61_11 = DB("character", var_61_4.leader_code, "face_id")
					
					if var_61_11 then
						local var_61_12 = SpriteCache:getSprite("face/" .. var_61_11 .. "_s.png")
						
						var_61_12:setName("unit_icon")
						var_61_12:setScale(0.7)
						var_61_10:addChild(var_61_12)
					end
					
					var_61_10:removeChildByName("frame_icon")
					
					local var_61_13, var_61_14 = DB("item_material", var_61_4.border_code, {
						"icon",
						"frame_effect"
					})
					
					if var_61_13 then
						local var_61_15 = SpriteCache:getSprite("item/" .. var_61_13 .. ".png")
						
						var_61_15:setName("frame_icon")
						var_61_15:setScale(0.7)
						var_61_10:addChild(var_61_15)
						if_set_effect(var_61_10, nil, var_61_14)
					end
				end
			end
		end
	end
end

function UIScorePanel.updateExpeditionScore(arg_62_0)
	local var_62_0 = tostring(Account:getUserId())
	local var_62_1 = Battle:getExpeditionUserList() or {}
	local var_62_2 = CoopUtil:getRankList(CoopUtil:makeCoopMemberArray(var_62_1))
	
	arg_62_0:_updateExpeditionPannel(var_62_2)
	arg_62_0:_updateExpeditionRank(var_62_2)
end

function UIScorePanel.scoreUpdate(arg_63_0)
	if arg_63_0.logic:isScoreType() then
		arg_63_0:updateTrialScore()
	elseif arg_63_0.logic:isExpeditionType() then
		arg_63_0:updateExpeditionScore()
	end
end

function UIScorePanel.update(arg_64_0)
end

function UIScorePanel.show(arg_65_0)
	if not get_cocos_refid(arg_65_0.wnd) then
		return 
	end
	
	if arg_65_0.wnd:isVisible() then
		return 
	end
	
	if arg_65_0.logic:isExpeditionType() then
		if_set_visible(arg_65_0.wnd, "n_ex_rank", false)
	end
	
	arg_65_0.wnd:setPositionX(arg_65_0.wnd_x + 400)
	BattleUIAction:Add(SEQ(SHOW(true), MOVE_TO(450, arg_65_0.wnd_x, arg_65_0.wnd:getPositionY()), CALL(function()
		if arg_65_0.logic:isExpeditionType() then
			if_set_visible(arg_65_0.wnd, "n_ex_rank", true)
		end
	end)), arg_65_0.wnd, "battle")
end

function UIScorePanel.hide(arg_67_0)
	if not get_cocos_refid(arg_67_0.wnd) then
		return 
	end
	
	if arg_67_0.logic:isExpeditionType() then
		if_set_visible(arg_67_0.wnd, "n_ex_rank", false)
	end
	
	BattleUIAction:Add(SEQ(MOVE_TO(450, arg_67_0.wnd_x + 400, arg_67_0.wnd:getPositionY()), SHOW(false), MOVE_TO(450, arg_67_0.wnd_x, arg_67_0.wnd:getPositionY())), arg_67_0.wnd, "battle")
end

UIAutoPanel = ClassDef()

function HANDLER.hud_auto(arg_68_0, arg_68_1)
	getParentWindow(arg_68_0).parent:onTouchButton(to_n(string.sub(arg_68_1, -1, -1)))
end

function UIAutoPanel.constructor(arg_69_0, arg_69_1, arg_69_2)
	arg_69_0.wnd = load_dlg("hud_auto", true, "wnd")
	
	arg_69_0.wnd:setLocalZOrder(-1)
	
	arg_69_0.wnd.parent = arg_69_0
	
	BattleField:addUIControl(arg_69_0.wnd)
	
	arg_69_0.logic = arg_69_2
	arg_69_0.battleUI = arg_69_1
	arg_69_0.RIGHT = arg_69_0.wnd:getChildByName("RIGHT")
	
	arg_69_0.RIGHT:setPositionY(-110)
	arg_69_0.RIGHT:setVisible(false)
	arg_69_0:update()
	arg_69_0:updateAutoMode()
end

function UIAutoPanel.updateAutoMode(arg_70_0)
	local var_70_0 = Battle:isAutoPlaying()
	
	UIAction:Remove(arg_70_0.RIGHT)
	
	if Battle:isEnded() == true or arg_70_0.logic:isRealtimeMode() then
		arg_70_0:hide()
		
		return 
	end
	
	if var_70_0 then
		arg_70_0:show()
	else
		arg_70_0:hide()
	end
end

function UIAutoPanel.show(arg_71_0)
	if not get_cocos_refid(arg_71_0.RIGHT) then
		print("Why??? is nil ")
		
		return 
	end
	
	if arg_71_0.logic:isRealtimeMode() then
		return 
	end
	
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(300, nil, 0))), arg_71_0.RIGHT)
end

function UIAutoPanel.hide(arg_72_0)
	if not get_cocos_refid(arg_72_0.RIGHT) then
		print("Why??? is nil ")
		
		return 
	end
	
	UIAction:Add(SEQ(LOG(MOVE_TO(300, nil, -110)), SHOW(false)), arg_72_0.RIGHT)
end

function UIAutoPanel.update(arg_73_0)
	local var_73_0 = 0
	local var_73_1 = 4
	
	for iter_73_0 = 1, var_73_1 do
		local var_73_2 = arg_73_0.logic.friends[iter_73_0]
		
		if var_73_2 and var_73_2.inst.code ~= "cleardummy" then
			var_73_0 = var_73_0 + 1
		end
	end
	
	local var_73_3 = var_73_1 - var_73_0
	local var_73_4 = var_73_3
	
	for iter_73_1 = 1, 4 do
		local var_73_5 = arg_73_0.wnd:getChildByName("n_auto")
		local var_73_6 = arg_73_0.wnd:getChildByName("n_skill")
		local var_73_7 = arg_73_0.logic.friends[iter_73_1]
		
		if iter_73_1 <= var_73_3 then
			if_set_visible(var_73_5, tostring(iter_73_1), false)
			if_set_visible(var_73_6, tostring(iter_73_1), false)
		end
		
		if var_73_7 and var_73_7.inst.code ~= "cleardummy" then
			var_73_4 = var_73_4 + 1
			var_73_5:getChildByName(tostring(var_73_4)).unit = var_73_7
			
			local var_73_8
			local var_73_9 = Account:getUnitAutoSkillFlag(var_73_7.inst.uid)
			
			if var_73_7:isDead() or not var_73_9 then
				if_set_visible(var_73_6, tostring(var_73_4), true)
				if_set_visible(var_73_5, tostring(var_73_4), false)
				
				var_73_8 = var_73_6
			elseif var_73_9 then
				if_set_visible(var_73_5, tostring(var_73_4), true)
				if_set_visible(var_73_6, tostring(var_73_4), false)
				
				var_73_8 = var_73_5
			end
			
			if var_73_8 then
				local var_73_10 = var_73_8:getChildByName(tostring(var_73_4))
				local var_73_11 = var_73_10:getChildByName("face")
				local var_73_12 = var_73_10:getChildByName("thumb")
				
				if var_73_11.face_id ~= var_73_7.db.face_id then
					SpriteCache:resetSprite(var_73_12, "face/" .. var_73_7.db.face_id .. "_s.png")
					
					var_73_11.face_id = var_73_7.db.face_id
				end
				
				if var_73_7:isDead() then
					var_73_10:setColor(cc.c3b(172, 26, 36))
				else
					var_73_10:setColor(cc.c3b(255, 255, 255))
				end
			end
		end
	end
end

function UIAutoPanel.onTouchButton(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0.wnd:getChildByName("n_auto"):getChildByName(tostring(arg_74_1))
	
	if var_74_0.unit and not var_74_0.unit:isDead() then
		local var_74_1 = not Account:getUnitAutoSkillFlag(var_74_0.unit.inst.uid)
		
		Account:setUnitAutoSkillFlag(var_74_0.unit.inst.uid, var_74_1)
		var_74_0.unit:setAutoSkillFlag(var_74_1)
		arg_74_0:update()
	end
end

UIEmojiPanel = ClassDef()

function UIEmojiPanel.constructor(arg_75_0, arg_75_1)
	arg_75_0.left = arg_75_1:getChildByName("n_gauge_left")
	arg_75_0.right = arg_75_1:getChildByName("n_gauge_right")
	arg_75_0.block_on = arg_75_0.right:getChildByName("btn_block_on")
	arg_75_0.last_emogi_ids = {}
	arg_75_0.is_block = false
	
	arg_75_0.block_on:setVisible(arg_75_0.is_block)
	LuaEventDispatcher:removeEventListenerByKey("arena.emogi")
	LuaEventDispatcher:addEventListener("arena.emogi.res", LISTENER(UIEmojiPanel.onEvent, arg_75_0), "arena.emogi")
end

function UIEmojiPanel.isNewEmoji(arg_76_0, arg_76_1)
	for iter_76_0, iter_76_1 in pairs(arg_76_1 or {}) do
		arg_76_0.last_emogi_ids[iter_76_0] = arg_76_0.last_emogi_ids[iter_76_0] or 0
		
		if iter_76_1._id > arg_76_0.last_emogi_ids[iter_76_0] then
			return true
		end
	end
	
	return false
end

function UIEmojiPanel.isNewEmoji(arg_77_0, arg_77_1)
	for iter_77_0, iter_77_1 in pairs(arg_77_1 or {}) do
		arg_77_0.last_emogi_ids[iter_77_0] = arg_77_0.last_emogi_ids[iter_77_0] or 0
		
		if iter_77_1._id > arg_77_0.last_emogi_ids[iter_77_0] then
			return true
		end
	end
	
	return false
end

function UIEmojiPanel.onEvent(arg_78_0, arg_78_1, arg_78_2)
	if arg_78_1 == "push" then
		local var_78_0 = Battle.viewer:getMatchInfo()
		
		if not var_78_0 then
			return 
		end
		
		for iter_78_0, iter_78_1 in pairs(arg_78_2 or {}) do
			arg_78_0.last_emogi_ids[iter_78_0] = arg_78_0.last_emogi_ids[iter_78_0] or 0
			
			if iter_78_1._id > arg_78_0.last_emogi_ids[iter_78_0] then
				local var_78_1 = iter_78_0 == var_78_0.user_info.uid and FRIEND or ENEMY
				local var_78_2 = DB("pvp_rta_emoji", iter_78_1.name, {
					"res"
				})
				
				if not arg_78_0.is_block then
					if var_78_2 then
						arg_78_0:pushEmoji(var_78_2, var_78_1)
					else
						Log.e("invalid emoji res", iter_78_1.name)
					end
				end
				
				arg_78_0.last_emogi_ids[iter_78_0] = iter_78_1._id
			end
		end
	elseif arg_78_1 == "push_local" then
		arg_78_0:pushEmoji(arg_78_2.res, FRIEND)
		Battle.viewer.service:query("command", {
			type = "emogi",
			name = arg_78_2.id
		})
		RtaEmojiPopup:close()
	elseif arg_78_1 == "update_last_ids" then
		for iter_78_2, iter_78_3 in pairs(arg_78_2 or {}) do
			if iter_78_3._id and iter_78_3._id ~= arg_78_0.last_emogi_ids[iter_78_2] then
				arg_78_0.last_emogi_ids[iter_78_2] = iter_78_3._id
			end
		end
	elseif arg_78_1 == "push_force" then
		local var_78_3 = Battle.viewer:getMatchInfo()
		
		if not var_78_3 then
			return 
		end
		
		if arg_78_0.is_block then
			return 
		end
		
		for iter_78_4, iter_78_5 in pairs(arg_78_2 or {}) do
			local var_78_4 = iter_78_4 == var_78_3.user_info.uid and FRIEND or ENEMY
			local var_78_5 = DB("pvp_rta_emoji", iter_78_5.name, {
				"res"
			})
			
			if var_78_5 then
				arg_78_0:pushEmoji(var_78_5, var_78_4)
			else
				Log.e("invalid emoji res", iter_78_5.name)
			end
		end
	elseif arg_78_1 == "hide" then
		RtaEmojiPopup:close()
	end
end

function UIEmojiPanel.pushEmoji(arg_79_0, arg_79_1, arg_79_2)
	local var_79_0 = "emoji." .. arg_79_1 .. "." .. arg_79_2
	
	if UIAction:Find("block") then
		return 
	end
	
	if UIAction:Find(var_79_0) then
		return 
	end
	
	if not get_cocos_refid(BGI.ui_layer) then
		return 
	end
	
	local var_79_1 = "emoji." .. arg_79_1 .. "." .. arg_79_2
	local var_79_2 = arg_79_2 == FRIEND and arg_79_0.left or arg_79_0.right
	
	BGI.ui_layer:removeChildByName("emoji" .. arg_79_2)
	
	local var_79_3 = {
		Init = function(arg_80_0)
			if get_cocos_refid(arg_80_0.sprite) then
				SoundEngine:playBattle("event:/emoticon/" .. arg_79_1)
				arg_80_0.sprite:play()
			end
		end,
		Update = function(arg_81_0, arg_81_1, arg_81_2)
			if PAUSED and get_cocos_refid(arg_81_0.sprite) then
				arg_81_0.sprite:update(arg_81_2 / 1000)
			end
		end,
		Finish = function(arg_82_0)
			if get_cocos_refid(arg_82_0.sprite) then
				arg_82_0.sprite:removeFromParent()
				if_set_visible(var_79_2, "talk_emoji", false)
			end
		end
	}
	
	cc.AniSprite:createAsync("emoticon/" .. arg_79_1 .. ".webp", function(arg_83_0, arg_83_1)
		if not get_cocos_refid(arg_83_0) then
			return 
		end
		
		local var_83_0 = arg_79_2 == FRIEND and {
			x = 65,
			y = 60
		} or {
			x = 65,
			y = 60
		}
		local var_83_1 = SceneManager:convertToSceneSpace(var_79_2:getChildByName("talk_emoji"), var_83_0)
		
		if_set_visible(var_79_2, "talk_emoji", true)
		arg_83_0:setName("emoji" .. arg_79_2)
		arg_83_0:setScale(1)
		arg_83_0:setAnchorPoint(0.5, 0.5)
		arg_83_0:setPosition(var_83_1.x, var_83_1.y)
		
		local var_83_2 = arg_83_0:getPlayTime()
		
		print("emog total_tm ", arg_79_1, var_83_2)
		
		var_79_3.sprite = arg_83_0
		var_79_3.TOTAL_TIME = var_83_2
		
		UIAction:Add(SEQ(USER_ACT(var_79_3)), arg_83_0, var_79_1)
		BGI.ui_layer:addChildLast(arg_83_0)
	end)
end

function UIEmojiPanel.toggleEmogiBlock(arg_84_0)
	if arg_84_0.is_block then
		arg_84_0.is_block = false
	else
		arg_84_0.is_block = true
	end
	
	arg_84_0.block_on:setVisible(arg_84_0.is_block)
end

UIReplayController = ClassDef()

function UIReplayController.constructor(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	arg_85_0.wnd = load_dlg("inbattle_replay", true, "wnd")
	
	if arg_85_1 then
		arg_85_1:addChild(arg_85_0.wnd)
	else
		BattleField:addUIControl(arg_85_0.wnd)
	end
	
	arg_85_0.viewer = arg_85_2
	arg_85_0.replay_player = arg_85_2.player
	arg_85_0.vars = {}
	arg_85_0.vars.from = arg_85_3
	arg_85_0.vars.replay_bars = {}
	arg_85_0.vars.origin_source_x = 639
	arg_85_0.vars.origin_source_y = 57
	arg_85_0.vars.origin_target_x = 639
	arg_85_0.vars.origin_target_y = 357
	arg_85_0.vars.n_control = arg_85_0.wnd:getChildByName("n_control")
	
	arg_85_0:fillTurnGauge()
	arg_85_0.wnd:setPosition(arg_85_0.vars.origin_source_x, arg_85_0.vars.origin_source_y)
	arg_85_0.wnd:bringToFront()
	if_set_visible(arg_85_0.wnd, "n_play", true)
	if_set_visible(arg_85_0.wnd, "n_pause", false)
	LuaEventDispatcher:removeEventListenerByKey("replay.controller")
	LuaEventDispatcher:addEventListener("player.event", LISTENER(UIReplayController.onEvent, arg_85_0), "replay.controller")
end

function UIReplayController.show(arg_86_0, arg_86_1)
	if UIBattleAttackOrder:isVisible() then
		return 
	end
	
	local var_86_0 = arg_86_1 and 0 or 250
	
	arg_86_0:updateUI()
	
	arg_86_0.vars.is_visible = true
	
	UIAction:Remove("replay.controller.appear")
	UIAction:Add(SEQ(LOG(MOVE_TO(var_86_0, arg_86_0.vars.origin_target_x, arg_86_0.vars.origin_target_y))), arg_86_0.wnd, "replay.controller.appear")
end

function UIReplayController.hide(arg_87_0, arg_87_1)
	local var_87_0 = arg_87_1 and 0 or 250
	
	arg_87_0.vars.is_visible = false
	
	UIAction:Remove("replay.controller.disappear")
	UIAction:Add(SEQ(RLOG(MOVE_TO(var_87_0, arg_87_0.vars.origin_source_x, arg_87_0.vars.origin_source_y))), arg_87_0.wnd, "replay.controller.disappear")
end

function UIReplayController.toggle(arg_88_0)
	if arg_88_0.vars.is_visible then
		arg_88_0:hide()
	else
		arg_88_0:show()
	end
end

function UIReplayController.isVisible(arg_89_0)
	if not arg_89_0.vars then
		return false
	end
	
	return arg_89_0.vars.is_visible
end

function UIReplayController.onEvent(arg_90_0, arg_90_1)
	if arg_90_1.type == "EXECUTE" and not USE_SKIP_IMMDEIATE then
	end
end

function UIReplayController.fillTurnGauge(arg_91_0)
	local var_91_0 = arg_91_0.replay_player:getTotalTurn()
	local var_91_1 = var_91_0 - 1
	local var_91_2 = 2
	local var_91_3 = 30
	local var_91_4 = (VIEW_WIDTH - var_91_3 * 2 - var_91_2 * var_91_1) / var_91_0
	local var_91_5 = arg_91_0.wnd:getChildByName("n_bar")
	
	if not get_cocos_refid(var_91_5) then
		return 
	end
	
	for iter_91_0 = 1, var_91_0 do
		local var_91_6 = load_control("wnd/replay_bar.csb")
		
		var_91_6:setAnchorPoint(0, 0)
		var_91_6:setPosition(VIEW_BASE_LEFT + var_91_3 + (var_91_4 + var_91_2) * (iter_91_0 - 1), 0)
		var_91_6:setContentSize(var_91_4, var_91_6:getContentSize().height)
		var_91_6:getChildByName("n_frame"):setContentSize(var_91_4, var_91_6:getChildByName("n_frame"):getContentSize().height)
		var_91_6:getChildByName("n_turn_bar"):setContentSize(var_91_4, var_91_6:getChildByName("n_turn_bar"):getContentSize().height)
		
		local var_91_7 = ccui.Button:create()
		
		var_91_7:setTouchEnabled(true)
		var_91_7:setAnchorPoint(0, 0)
		var_91_7:setPosition(0, 50)
		var_91_7:ignoreContentAdaptWithSize(false)
		var_91_7:setContentSize(var_91_4, 70)
		var_91_7:setName("replay_btn_" .. tostring(iter_91_0))
		var_91_7:addTouchEventListener(function(arg_92_0, arg_92_1)
			if arg_92_1 ~= 2 then
				return 
			end
			
			local var_92_0 = string.split(arg_92_0:getName(), "_")
			
			if var_92_0 and var_92_0[3] then
				local var_92_1 = tonumber(var_92_0[3]) - arg_91_0.replay_player:getCurrentTurn()
				
				if var_92_1 ~= 0 then
					if not Battle:isPlayingBattleAction() and not StageStateManager:isRunning() and not BattleAction:Find("battle.dead") then
						arg_91_0.replay_player:moveTurn(var_92_1)
					end
					
					arg_91_0:updateUI()
				end
			end
		end)
		var_91_6:addChild(var_91_7)
		table.insert(arg_91_0.vars.replay_bars, var_91_6)
		var_91_5:addChild(var_91_6)
	end
end

function UIReplayController.update(arg_93_0)
	if Battle:isPlayingBattleAction() or StageStateManager:isRunning() or Battle.viewer and Battle.viewer:isRunning() then
		arg_93_0.vars.n_control:setColor(tocolor("#5B5B5B"))
	else
		arg_93_0.vars.n_control:setColor(tocolor("#FFFFFF"))
	end
end

function UIReplayController.updateUI(arg_94_0)
	arg_94_0:updateTurnInfo()
	arg_94_0:updateBtnStates()
	arg_94_0:updateBarStates()
end

function UIReplayController.updateTurnInfo(arg_95_0)
	local var_95_0 = T("ui_pvp_rta_replay_turn", {
		replay_turn = arg_95_0.replay_player:getCurrentTurn(),
		total_turn = arg_95_0.replay_player:getTotalTurn()
	})
	
	if_set(arg_95_0.wnd, "txt_turn", var_95_0)
end

function UIReplayController.updateBtnStates(arg_96_0)
	if_set_opacity(arg_96_0.wnd, "n_front", arg_96_0.replay_player:canMove(-1) and 255 or 80)
	if_set_opacity(arg_96_0.wnd, "n_front2", arg_96_0.replay_player:canMove(-3) and 255 or 80)
	if_set_opacity(arg_96_0.wnd, "n_back", arg_96_0.replay_player:canMove(1) and 255 or 80)
	if_set_opacity(arg_96_0.wnd, "n_back2", arg_96_0.replay_player:canMove(3) and 255 or 80)
end

function UIReplayController.updateBarStates(arg_97_0)
	local var_97_0 = arg_97_0.replay_player:getCurrentTurn()
	
	for iter_97_0, iter_97_1 in pairs(arg_97_0.vars.replay_bars or {}) do
		if iter_97_0 < var_97_0 then
			iter_97_1:getChildByName("n_turn_bar"):setColor(tocolor("#CB650D"))
		elseif iter_97_0 == var_97_0 then
			iter_97_1:getChildByName("n_turn_bar"):setColor(tocolor("#FFFFFF"))
		else
			iter_97_1:getChildByName("n_turn_bar"):setColor(tocolor("#808080"))
		end
	end
end

function UIReplayController.addDelay(arg_98_0, arg_98_1)
	do return  end
	
	arg_98_1 = arg_98_1 or 5000
	
	UIAction:Remove("replay.controller.delay")
	UIAction:Add(SEQ(DELAY(arg_98_1), CALL(function()
		arg_98_0:hide()
	end)), arg_98_0.wnd, "replay.controller.delay")
end

function UIReplayController.play(arg_100_0)
	arg_100_0.replay_player:play()
	if_set_visible(arg_100_0.wnd, "n_play", false)
	if_set_visible(arg_100_0.wnd, "n_pause", true)
end

function UIReplayController.pause(arg_101_0)
	arg_101_0.replay_player:stop()
	if_set_visible(arg_101_0.wnd, "n_play", true)
	if_set_visible(arg_101_0.wnd, "n_pause", false)
end

function UIReplayController.rff(arg_102_0)
	local var_102_0, var_102_1 = arg_102_0.replay_player:prevTurn()
	
	if var_102_0 then
		arg_102_0:updateUI()
	end
end

function UIReplayController.rff2(arg_103_0)
	local var_103_0, var_103_1 = arg_103_0.replay_player:prev3Turn()
	
	if var_103_0 then
		arg_103_0:updateUI()
	end
end

function UIReplayController.ff(arg_104_0)
	local var_104_0, var_104_1 = arg_104_0.replay_player:nextTurn()
	
	if var_104_0 then
		arg_104_0:updateUI()
	end
end

function UIReplayController.ff2(arg_105_0)
	local var_105_0, var_105_1 = arg_105_0.replay_player:next3Turn()
	
	if var_105_0 then
		arg_105_0:updateUI()
	end
end

UINotifySkill = ClassDef()

function UINotifySkill.constructor(arg_106_0, arg_106_1, arg_106_2)
	arg_106_0:show(arg_106_1, arg_106_2)
end

function UINotifySkill.show(arg_107_0, arg_107_1, arg_107_2)
	local var_107_0 = 1300
	
	if not get_cocos_refid(arg_107_0.skill_bg) then
		arg_107_0.skill_bg = SpriteCache:getSprite("bg_skillboard.png")
		
		arg_107_0.skill_bg:setAnchorPoint(0, 0)
		
		arg_107_0.skill_bg_width = arg_107_0.skill_bg:getContentSize().width
		
		arg_107_0.skill_bg:setPosition(-arg_107_0.skill_bg_width, 0)
		BGI.ui_layer:addChildLast(arg_107_0.skill_bg)
	end
	
	arg_107_0.skill_bg_x = 0
	
	local var_107_1 = UISkillIcon:create(arg_107_1)
	
	var_107_1:setAnchorPoint(0, 0)
	
	arg_107_0.skill_btn_width = var_107_1:getContentSize().width
	
	arg_107_0.skill_bg:addChild(var_107_1)
	arg_107_0.skill_bg:setOpacity(255)
	arg_107_0.skill_bg:setVisible(true)
	BattleUIAction:Add(SEQ(LOG(MOVE_TO(200, arg_107_0.skill_bg_x, 0), 5000), DELAY(var_107_0 - 300), SPAWN(RLOG(MOVE_TO(300, -arg_107_0.skill_bg_width, 0), 50000), FADE_OUT(500)), SHOW(false)), arg_107_0.skill_bg, "battle")
	
	local var_107_2 = ccui.Text:create()
	
	var_107_2:setFontName("font/daum.ttf")
	var_107_2:setString(SkillFactory.create(arg_107_1, arg_107_2):getSkillNameForPlay())
	var_107_2:setColor(cc.c3b(180, 180, 180), cc.c3b(255, 255, 255))
	var_107_2:enableOutline(cc.c3b(0, 0, 0), 1)
	var_107_2:setFontSize(24)
	var_107_2:setAnchorPoint(0, 0)
	var_107_2:setSkewX(15)
	var_107_2:setPosition(DESIGN_WIDTH - 200, var_107_1:getPositionY() + 25)
	var_107_2:setLocalZOrder(999999)
	BGI.ui_layer:addChildLast(var_107_2)
	BattleUIAction:Add(SPAWN(LOG(MOVE_TO(200, arg_107_0.skill_bg_x + arg_107_0.skill_btn_width + 10)), SEQ(DELAY(var_107_0), SPAWN(FADE_OUT(300), RLOG(MOVE_TO(200, DESIGN_WIDTH))), REMOVE())), var_107_2, "battle")
end

UISoulUnitGaugebar = ClassDef()

function UISoulUnitGaugebar.constructor(arg_108_0, arg_108_1, arg_108_2, arg_108_3)
	arg_108_0.logic = arg_108_3
	arg_108_0.ally = arg_108_1
	arg_108_0.control = arg_108_2
	arg_108_0.gauge_ctrl = arg_108_2:getChildByName("soul_gauge")
	
	arg_108_0.gauge_ctrl:setPercent(0)
	
	arg_108_0.grad_ctrls = {}
	
	for iter_108_0 = 1, 8 do
		arg_108_0.grad_ctrls[iter_108_0] = arg_108_2:getChildByName("n_soul" .. tonumber(iter_108_0))
	end
	
	arg_108_0.cur_soul_piece = 0
	arg_108_0.max_soul_piece = 0
	
	arg_108_0.control:setVisible(false)
	
	arg_108_0.action_height = 200
	
	local var_108_0 = arg_108_0.control:getPositionY()
	
	if NotchStatus:isSourGaugeBarUp() then
		if not arg_108_2._origin_to_y then
			arg_108_2._origin_to_y = var_108_0
		end
		
		var_108_0 = arg_108_2._origin_to_y
	end
	
	if var_108_0 == 0 then
		if NotchStatus:isSourGaugeBarUp() then
			var_108_0 = 20
		end
		
		arg_108_0.control:setPositionY(var_108_0 - arg_108_0.action_height)
	end
	
	arg_108_0.origin_x = arg_108_0.control:getPositionX()
	arg_108_0.origin_y = arg_108_0.control:getPositionY()
end

function UISoulUnitGaugebar.hide(arg_109_0)
	if not get_cocos_refid(arg_109_0.control) then
		return 
	end
	
	if arg_109_0.control:isVisible() then
		local var_109_0 = arg_109_0.origin_x
		local var_109_1 = arg_109_0.origin_y
		
		BattleUIAction:Add(SEQ(SPAWN(RLOG(MOVE_TO(var_0_2 + 100 + 320, var_109_0, var_109_1 - arg_109_0.action_height))), SHOW(false)), arg_109_0.control, "battle")
	end
end

function UISoulUnitGaugebar.isShow(arg_110_0)
	return arg_110_0.control:isVisible()
end

function UISoulUnitGaugebar.show(arg_111_0)
	arg_111_0.control:setVisible(true)
	
	local var_111_0 = arg_111_0.origin_x
	local var_111_1 = arg_111_0.origin_y
	
	BattleUIAction:Add(SEQ(SPAWN(BEZIER(MOVE_TO(var_0_2, var_111_0, var_111_1 + arg_111_0.action_height), {
		0,
		1,
		0.57,
		1
	}), SCALE_TO(var_0_2, 1), FADE_IN(var_0_2)), CALL(function()
		TutorialGuide:onShowSoulGaugeUI(arg_111_0.logic)
	end)), arg_111_0.control, "battle")
end

function UISoulUnitGaugebar.updateSoulPiece(arg_113_0)
	local var_113_0 = arg_113_0.max_soul_piece or 0
	
	arg_113_0.max_soul_piece = Battle.viewer:getTeamRes(arg_113_0.ally, "soul_piece") or 0
	arg_113_0.cur_soul_piece = arg_113_0.max_soul_piece
	
	if arg_113_0.max_soul_piece ~= var_113_0 then
		arg_113_0:update()
	end
end

function UISoulUnitGaugebar.setMaxSoulPiece(arg_114_0, arg_114_1)
	arg_114_0.max_soul_piece = arg_114_1 or 0
end

function UISoulUnitGaugebar.setSoulCount(arg_115_0, arg_115_1)
	arg_115_0.cur_soul_count = arg_115_1
	
	for iter_115_0 = 1, 8 do
		local var_115_0 = "@SOUL_NODE" .. tostring(iter_115_0)
		
		if iter_115_0 <= arg_115_0.cur_soul_count then
			if not arg_115_0.grad_ctrls[iter_115_0]:getChildByName(var_115_0) then
				local var_115_1 = CACHE:getEffect("soul_01.cfx")
				
				var_115_1:setName(var_115_0)
				var_115_1:setColor(cc.c3b(10, 10, 10))
				arg_115_0.grad_ctrls[iter_115_0]:addChild(var_115_1)
				var_115_1:start()
				SoundEngine:play("event:/battle/ui/soul_created")
			end
		else
			local var_115_2 = arg_115_0.grad_ctrls[iter_115_0]:getChildByName(var_115_0)
			
			if var_115_2 then
				var_115_2:setName("")
				EffectManager:Play({
					fn = "hud_soul_consume.cfx",
					layer = arg_115_0.grad_ctrls[iter_115_0]
				})
				stop_or_remove(var_115_2)
			end
		end
	end
end

function UISoulUnitGaugebar.readySoulburn(arg_116_0, arg_116_1, arg_116_2)
	if arg_116_1 == "burn" then
		SoundEngine:play("event:/battle/soulburn/ready")
		
		arg_116_0.ready_count = arg_116_2 or 0
		
		local var_116_0 = arg_116_0.cur_soul_count - arg_116_0.ready_count + 1
		
		if var_116_0 >= 1 then
			for iter_116_0 = var_116_0, arg_116_0.cur_soul_count do
				local var_116_1 = arg_116_0.grad_ctrls[iter_116_0]
				
				if var_116_1 then
					local var_116_2 = var_116_1:getChildByName("@SOUL_NODE" .. tostring(iter_116_0))
					
					if not var_116_2 then
						var_116_2 = CACHE:getEffect("soul_01.cfx")
						
						var_116_2:setName("@SOUL_NODE" .. tostring(iter_116_0))
						var_116_2:setColor(cc.c3b(10, 10, 10))
						var_116_1:addChild(var_116_2)
						var_116_2:start()
					end
					
					UIAction:Remove(var_116_2)
					UIAction:Add(SEQ(CALL(function()
						EffectManager:Play({
							fn = "ui_achieve_embleup.cfx",
							layer = var_116_2
						})
					end), DELAY(100), SCALE_TO(10, 0.6)), var_116_2, "battleui.soulscale")
				end
			end
		end
	else
		SoundEngine:play("event:/battle/soulburn/cancel")
		
		for iter_116_1 = 1, arg_116_0.cur_soul_count or 0 do
			if get_cocos_refid(arg_116_0.grad_ctrls[iter_116_1]) then
				local var_116_3 = arg_116_0.grad_ctrls[iter_116_1]:getChildByName("@SOUL_NODE" .. tostring(iter_116_1))
				
				if not var_116_3 then
					var_116_3 = CACHE:getEffect("soul_01.cfx")
					
					var_116_3:setName("@SOUL_NODE" .. tostring(iter_116_1))
					var_116_3:setColor(cc.c3b(10, 10, 10))
					arg_116_0.grad_ctrls[iter_116_1]:addChild(var_116_3)
					var_116_3:start()
				end
				
				if var_116_3:getScaleX() < 1 then
					UIAction:Remove(var_116_3)
					UIAction:Add(SCALE_TO(100, 1), var_116_3)
				end
			end
		end
	end
end

function UISoulUnitGaugebar.getSoulCount(arg_118_0, arg_118_1)
	return arg_118_0.cur_soul_count or 0
end

function UISoulUnitGaugebar.addSoulPiece(arg_119_0, arg_119_1)
	arg_119_0.cur_soul_piece = arg_119_0.cur_soul_piece + arg_119_1
	
	arg_119_0:update()
end

function UISoulUnitGaugebar.update(arg_120_0)
	if not arg_120_0.cur_soul_piece or not arg_120_0.max_soul_piece then
		return 
	end
	
	if arg_120_0.cur_soul_piece > arg_120_0.max_soul_piece then
		arg_120_0.cur_soul_piece = arg_120_0.max_soul_piece
	end
	
	arg_120_0.cur_soul_count = math.floor(arg_120_0.cur_soul_piece / GAME_STATIC_VARIABLE.max_soul_point)
	
	arg_120_0.gauge_ctrl:setPercent(arg_120_0.cur_soul_piece % GAME_STATIC_VARIABLE.max_soul_point * GAME_STATIC_VARIABLE.max_soul_point)
	arg_120_0:setSoulCount(arg_120_0.cur_soul_count)
	BattleUI:updateSummonState()
end

UISoulGainEffect = ClassDef()

function UISoulGainEffect.constructor(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
	if not arg_121_2 then
		return 
	end
	
	arg_121_0.index = arg_121_3
	arg_121_0.parent_ctrl = arg_121_1.summon_ctrl
	arg_121_0.target_ctrl = arg_121_1.summon_face_ctrl
	arg_121_0.soul_gauge = arg_121_1.soul_gauge
	arg_121_0.effect = CACHE:getEffect("soul_drop.cfx")
	
	arg_121_0.effect:setAutoRemoveOnFinish(true)
	BGI.ui_layer:addChildLast(arg_121_0.effect)
	arg_121_0.effect:start()
	SoundEngine:play("event:/battle/soul_drop")
	
	local var_121_0 = arg_121_2:convertToWorldSpace({
		x = 0,
		y = 120
	})
	local var_121_1 = arg_121_0.effect:convertToWorldSpace({
		x = 0,
		y = 0
	})
	
	arg_121_0.start_x = var_121_0.x - var_121_1.x + math.random(-150, 150)
	arg_121_0.start_y = var_121_0.y - var_121_1.y + math.random(-150, 150)
	
	local var_121_2 = arg_121_0.target_ctrl:getContentSize()
	local var_121_3 = arg_121_0.target_ctrl:convertToWorldSpace({
		x = var_121_2.width / 2,
		y = var_121_2.height / 2
	})
	
	arg_121_0.target_x = var_121_3.x
	arg_121_0.target_y = var_121_3.y
	
	arg_121_0.effect:setPosition(arg_121_0.start_x, arg_121_0.start_y)
	
	arg_121_0.curve = BezierCurves(1, 0.34, 1, 0)
	arg_121_0.duration = 900
	
	BattleUIAction:Add(SEQ(DELAY(arg_121_3 * math.random(50, 60)), COND_LOOP(CALL(UISoulGainEffect.update, arg_121_0), function(arg_122_0)
		return arg_122_0.is_finished or not get_cocos_refid(arg_122_0.effect)
	end, arg_121_0)), arg_121_0.effect)
end

function UISoulGainEffect.update(arg_123_0)
	if not get_cocos_refid(arg_123_0.effect) then
		return 
	end
	
	if not arg_123_0.start_tick then
		arg_123_0.start_tick = LAST_TICK
	end
	
	local var_123_0 = math.max(0, math.min(1, (LAST_TICK - arg_123_0.start_tick) / arg_123_0.duration))
	
	if var_123_0 >= 1 then
		arg_123_0.is_finished = true
		
		arg_123_0.effect:stop()
		arg_123_0.soul_gauge:addSoulPiece(1)
		EffectManager:Play({
			fn = "effect/soul_gain.cfx",
			layer = arg_123_0.parent_ctrl
		})
	else
		local var_123_1 = arg_123_0.curve:getPercentAtX(var_123_0)
		local var_123_2 = arg_123_0.start_x + (arg_123_0.target_x - arg_123_0.start_x) * var_123_1
		local var_123_3 = arg_123_0.start_y + (arg_123_0.target_y - arg_123_0.start_y) * var_123_1
		
		arg_123_0.effect:setPosition(var_123_2, var_123_3)
	end
end

UISoulBurnButton = ClassDef()

function UISoulBurnButton.constructor(arg_124_0, arg_124_1, arg_124_2)
	arg_124_0.battleUI = arg_124_1
	arg_124_0.parent = arg_124_2 or arg_124_1.battle_wnd:getChildByName("n_soulburn")
	
	arg_124_0.parent:removeAllChildren()
	
	arg_124_0.button = ccui.Button:create()
	
	arg_124_0.button:setName("btn_soulburn")
	arg_124_0.button:setTouchEnabled(true)
	arg_124_0.button:ignoreContentAdaptWithSize(false)
	arg_124_0.button:setContentSize({
		width = 228,
		height = 102
	})
	arg_124_0.button:setPosition(0, 0)
	arg_124_0.button:setAnchorPoint(1, 0)
	arg_124_0.button:addTouchEventListener(function(arg_125_0, arg_125_1)
		if arg_125_1 ~= 2 then
			return 
		end
		
		arg_124_0:toggleButtonMode()
	end)
	
	local var_124_0 = arg_124_0.button:getContentSize()
	
	arg_124_0.appear_effect = ur.Model:create("effect/soul_burn_bt.scsp", "effect/soul_burn_bt.atlas")
	
	arg_124_0.appear_effect:setScaleFactor(LEGACY_FACTOR * 0.7)
	arg_124_0.appear_effect:setScale(1)
	arg_124_0.appear_effect:setPosition(var_124_0.width / 2, var_124_0.height / 2)
	arg_124_0.button:addChild(arg_124_0.appear_effect)
	arg_124_0.parent:addChildLast(arg_124_0.button)
	arg_124_0:setButtonMode("")
end

function UISoulBurnButton.toggleButtonMode(arg_126_0)
	if BattleUIAction:Find("battleui.soulburn") then
		return 
	end
	
	if TutorialGuide:checkBlockSoulburnButton(BattleUI.logic) then
		return 
	end
	
	BattleUIAction:Remove("battleui.soulburn_appear")
	
	if arg_126_0.mode == "burn" then
		Battle:setSoulState(nil)
	else
		Battle:setSoulState("burn")
	end
end

function UISoulBurnButton.setButtonMode(arg_127_0, arg_127_1)
	if arg_127_0.mode == arg_127_1 then
		return 
	end
	
	arg_127_0.mode = arg_127_1
	
	if arg_127_1 == "burn" then
		BattleUIAction:Add(SEQ(MOTION("cancel_loop", true), DELAY(500)), arg_127_0.appear_effect, "battleui.soulburn")
	else
		BattleUIAction:Add(SEQ(MOTION("burn_loop", true), DELAY(500)), arg_127_0.appear_effect, "battleui.soulburn")
	end
end

function UISoulBurnButton.checkSoulburn(arg_128_0, arg_128_1)
	arg_128_0:setButtonMode("")
	
	local var_128_0 = arg_128_1:getOwner()
	local var_128_1, var_128_2 = arg_128_1:getSoulBurnSkill()
	
	if var_128_1 and var_128_2 then
		if var_128_2 <= (Battle.viewer:getTeamRes(var_128_0.inst.ally, "soul_piece") or 0) then
			arg_128_0:setVisible(true)
		else
			arg_128_0:setVisible(false)
		end
	else
		arg_128_0:setVisible(false)
	end
end

function UISoulBurnButton.setPosition(arg_129_0, arg_129_1, arg_129_2)
	arg_129_0.button:setPosition(arg_129_1, arg_129_2)
end

function UISoulBurnButton.checkShow(arg_130_0, arg_130_1)
	if Battle:isAutoPlaying() then
		arg_130_0:setVisible(false)
		
		return 
	end
	
	for iter_130_0 = 1, 3 do
		local var_130_0 = arg_130_1:getSkillBundle():slot(iter_130_0)
		
		if var_130_0:checkUseSkill() then
			local var_130_1, var_130_2 = var_130_0:getSoulBurnSkill()
			
			if var_130_2 and var_130_2 > 0 then
				local var_130_3 = Battle.viewer:getTeamRes(arg_130_1.inst.ally, "soul_piece") or 0
				local var_130_4 = arg_130_1.states:isExistEffect("CSP_FREE_SOULBURN")
				
				if var_130_2 <= var_130_3 or var_130_4 then
					arg_130_0:setVisible(true)
					
					return 
				end
			end
		end
	end
	
	arg_130_0:setVisible(false)
end

function UISoulBurnButton.isVisible(arg_131_0)
	return arg_131_0.button:isVisible()
end

function UISoulBurnButton.getMode(arg_132_0)
	return arg_132_0.mode
end

function UISoulBurnButton.setVisible(arg_133_0, arg_133_1)
	arg_133_0.mode = nil
	
	BattleUIAction:Remove("battleui.soulburn")
	BattleUIAction:Remove("battleui.soulburn_appear")
	arg_133_0.button:setVisible(arg_133_1)
	
	if arg_133_1 then
		BattleUIAction:Add(SEQ(DMOTION("burn_intro"), MOTION("burn_loop", true)), arg_133_0.appear_effect, "battleui.soulburn_appear")
	end
end

UITopSoulGaugebar = ClassDef()

function UITopSoulGaugebar.constructor(arg_134_0, arg_134_1)
	arg_134_0.grad_ctrls = {}
	arg_134_0.grad_ctrls[FRIEND] = {}
	arg_134_0.grad_ctrls[ENEMY] = {}
	
	for iter_134_0, iter_134_1 in pairs({
		FRIEND,
		ENEMY
	}) do
		arg_134_0.cur_soul_count = arg_134_0.cur_soul_count or {}
		arg_134_0.cur_soul_piece = arg_134_0.cur_soul_piece or {}
		arg_134_0.max_soul_piece = arg_134_0.max_soul_piece or {}
		arg_134_0.cur_soul_count[iter_134_1] = 0
		arg_134_0.cur_soul_piece[iter_134_1] = 0
		arg_134_0.max_soul_piece[iter_134_1] = 0
	end
	
	local var_134_0 = arg_134_1:getChildByName("n_gauge_left")
	local var_134_1 = arg_134_1:getChildByName("n_gauge_right")
	local var_134_2 = Battle.viewer:isSpectator() or Battle:isReplayMode()
	local var_134_3 = {
		[FRIEND] = var_134_0:getChildByName("n_soul_burn_watching"),
		[ENEMY] = var_134_1:getChildByName("n_soul_burn")
	}
	
	var_134_3[FRIEND]:setVisible(var_134_2)
	var_134_3[ENEMY]:setVisible(true)
	
	for iter_134_2, iter_134_3 in pairs(var_134_3) do
		for iter_134_4 = 1, 8 do
			arg_134_0.grad_ctrls[iter_134_2][iter_134_4] = iter_134_3:getChildByName("soulburn" .. tonumber(iter_134_4))
		end
	end
	
	arg_134_0.effNode = {}
	arg_134_0.effNode[FRIEND] = var_134_0:getChildByName("mob_icon")
	arg_134_0.effNode[ENEMY] = var_134_1:getChildByName("mob_icon")
end

function UITopSoulGaugebar.updateSoulPiece(arg_135_0)
	for iter_135_0, iter_135_1 in pairs({
		FRIEND,
		ENEMY
	}) do
		local var_135_0 = arg_135_0.max_soul_piece[iter_135_1] or 0
		
		arg_135_0.max_soul_piece[iter_135_1] = Battle.viewer:getTeamRes(iter_135_1, "soul_piece") or 0
		arg_135_0.cur_soul_piece[iter_135_1] = arg_135_0.max_soul_piece[iter_135_1]
		
		if arg_135_0.max_soul_piece[iter_135_1] ~= var_135_0 then
			arg_135_0:update(iter_135_1)
		end
	end
end

function UITopSoulGaugebar.setSoulCount(arg_136_0, arg_136_1, arg_136_2)
	arg_136_0.cur_soul_count[arg_136_1] = arg_136_2
	
	for iter_136_0 = 1, 8 do
		local var_136_0 = "@SOUL_NODE" .. tostring(iter_136_0)
		
		if iter_136_0 <= arg_136_0.cur_soul_count[arg_136_1] then
			if not arg_136_0.grad_ctrls[arg_136_1][iter_136_0]:getChildByName(var_136_0) then
				local var_136_1 = CACHE:getEffect("soul_01.cfx")
				
				var_136_1:setName(var_136_0)
				var_136_1:setColor(cc.c3b(10, 10, 10))
				arg_136_0.grad_ctrls[arg_136_1][iter_136_0]:addChild(var_136_1)
				var_136_1:start()
				SoundEngine:play("event:/battle/ui/soul_created")
			end
		else
			local var_136_2 = arg_136_0.grad_ctrls[arg_136_1][iter_136_0]:getChildByName(var_136_0)
			
			if var_136_2 then
				var_136_2:setName("")
				EffectManager:Play({
					fn = "hud_soul_consume.cfx",
					layer = arg_136_0.grad_ctrls[arg_136_1][iter_136_0]
				})
				stop_or_remove(var_136_2)
			end
		end
	end
end

function UITopSoulGaugebar.update(arg_137_0, arg_137_1)
	if not arg_137_0.cur_soul_piece[arg_137_1] or not arg_137_0.max_soul_piece[arg_137_1] then
		return 
	end
	
	if arg_137_0.cur_soul_piece[arg_137_1] > arg_137_0.max_soul_piece[arg_137_1] then
		arg_137_0.cur_soul_piece[arg_137_1] = arg_137_0.max_soul_piece[arg_137_1]
	end
	
	arg_137_0.cur_soul_count[arg_137_1] = math.floor(arg_137_0.cur_soul_piece[arg_137_1] / GAME_STATIC_VARIABLE.max_soul_point)
	
	arg_137_0:setSoulCount(arg_137_1, arg_137_0.cur_soul_count[arg_137_1])
end

function UITopSoulGaugebar.startSoulEffect(arg_138_0, arg_138_1)
	local var_138_0 = SceneManager:convertToSceneSpace(arg_138_0.effNode[arg_138_1], {
		x = 0,
		y = 0
	})
	
	arg_138_0.soul_effect = CACHE:getEffect("ui_livepvp_soulburn_eff.cfx")
	arg_138_0.soul_effect_dark = CACHE:getEffect("ui_livepvp_soulburn_dark.cfx")
	
	arg_138_0.soul_effect:setPosition(var_138_0.x, var_138_0.y)
	arg_138_0.soul_effect_dark:setPosition(var_138_0.x, var_138_0.y)
	arg_138_0.soul_effect:start()
	arg_138_0.soul_effect_dark:start()
	
	local var_138_1 = "event:/effect/ui_livepvp_soulburn_eff"
	
	if SoundEngine:existsEvent(var_138_1) then
		SoundEngine:playBattle(var_138_1)
	end
	
	BGI.ui_layer:addChildLast(arg_138_0.soul_effect)
	BGI.ui_layer:addChildFirst(arg_138_0.soul_effect_dark)
end

function UITopSoulGaugebar.stopSoulEffect(arg_139_0)
	if arg_139_0.soul_effect and get_cocos_refid(arg_139_0.soul_effect) then
		arg_139_0.soul_effect:stop()
		BattleUIAction:Add(SEQ(DELAY(1000), CALL(function()
			BGI.ui_layer:removeChild(arg_139_0.soul_effect)
			BGI.ui_layer:removeChild(arg_139_0.soul_effect_dark)
		end)), arg_139_0, "top.soul_effect")
	end
end

BattleUI = BattleUI or {}

function BattleUI.init(arg_141_0, arg_141_1, arg_141_2)
	arg_141_0.target_arrows = {}
	arg_141_0.logic = arg_141_1
	arg_141_0.viewer = arg_141_2
	arg_141_0.vars = {}
	arg_141_0.vars.unit_vars = arg_141_0.vars.unit_vars or {}
	arg_141_0.battle_wnd = load_dlg("inbattle_hud", true, "wnd")
	
	arg_141_0:initSummonReservation()
	
	arg_141_0.skill_button_group = nil
	
	var_0_1(arg_141_0.battle_wnd)
	BattleField:addUIControl(arg_141_0.battle_wnd)
	Combo:init()
	
	arg_141_0.auto_panel = UIAutoPanel(arg_141_0, arg_141_1)
	
	arg_141_0.auto_panel:updateAutoMode()
	arg_141_0:initActionBar()
	arg_141_0:initSupporterButton()
	arg_141_0:initSummonStateCtrl()
	arg_141_0:initReplayController()
	
	if arg_141_0.logic:isRealtimeMode() or Battle:isReplayMode() then
		local var_141_0 = Battle.viewer:getMatchInfo()
		local var_141_1 = Battle.viewer:isSpectator() or Battle:isReplayMode() or false
		
		arg_141_0.pvp_gauge_wnd = load_dlg("pvplive_global_hp", true, "wnd")
		
		arg_141_0.pvp_gauge_wnd:setVisible(true)
		
		if MatchService:isBroadCastUIHide() then
			for iter_141_0, iter_141_1 in pairs(arg_141_0.pvp_gauge_wnd:getChildren()) do
				iter_141_1:setVisible(false)
			end
			
			if_set_visible(arg_141_0.pvp_gauge_wnd, "n_turn", true)
		end
		
		arg_141_0.pvp_gauge_wnd.soul = UITopSoulGaugebar(arg_141_0.pvp_gauge_wnd)
		arg_141_0.emoji_panel = UIEmojiPanel(arg_141_0.pvp_gauge_wnd)
		
		arg_141_0:createTimerProgressBars()
		BattleField:addUIControl(arg_141_0.pvp_gauge_wnd)
		BattleTopBar:updateRTAPenalyInfo()
		
		local var_141_2 = arg_141_0.pvp_gauge_wnd:getChildByName("n_gauge_left")
		local var_141_3 = arg_141_0.pvp_gauge_wnd:getChildByName("n_gauge_right")
		local var_141_4 = arg_141_0.pvp_gauge_wnd:getChildByName("n_round_info")
		
		if_set_visible(var_141_2, "n_emoji", false)
		if_set_visible(var_141_3, "n_emoji", false)
		if_set_visible(var_141_2, "talk_emoji", false)
		if_set_visible(var_141_3, "talk_emoji", false)
		
		local var_141_5 = Battle:isReplayMode()
		
		if_set_visible(var_141_2, "n_ping", not var_141_5)
		if_set_visible(var_141_3, "n_ping", not var_141_5)
		
		if var_141_0 then
			if_set(var_141_2, "txt_name", check_abuse_filter(var_141_0.user_info.name, ABUSE_FILTER.WORLD_NAME) or var_141_0.user_info.name)
			if_set(var_141_3, "txt_name", check_abuse_filter(var_141_0.enemy_user_info.name, ABUSE_FILTER.WORLD_NAME) or var_141_0.enemy_user_info.name)
			
			if var_141_1 then
				if_set_text_color(var_141_2, "txt_name", cc.c3b(68, 148, 255))
				if_set_text_color(var_141_3, "txt_name", cc.c3b(254, 30, 30))
			end
			
			local var_141_6, var_141_7 = UIUtil:getTextWidthAndPos(var_141_3, "txt_name")
			
			var_141_3:getChildByName("icon_menu_global"):setPositionX(var_141_6 * 1.3 + 30)
			if_set_visible(arg_141_0.pvp_gauge_wnd, "n_turn", false)
			if_set_visible(var_141_2, "n_emoji", true)
			if_set_visible(var_141_3, "n_emoji", true)
			if_set_visible(var_141_2, "talk_emoji", false)
			if_set_visible(var_141_3, "talk_emoji", false)
			if_set(var_141_2, "txt_nation", getRegionText(var_141_0.user_info.world))
			if_set(var_141_3, "txt_nation", getRegionText(var_141_0.enemy_user_info.world))
			if_set_visible(var_141_2, "btn_emoji", not var_141_1)
			if_set_visible(var_141_3, "n_btn_block", not var_141_1)
			UIUtil:getUserIcon(var_141_0.user_info.leader_code, {
				no_popup = true,
				name = false,
				no_role = true,
				no_lv = true,
				scale = 1,
				no_grade = true,
				parent = var_141_2:getChildByName("mob_icon"),
				border_code = var_141_0.user_info.border_code
			})
			UIUtil:getUserIcon(var_141_0.enemy_user_info.leader_code, {
				no_popup = true,
				name = false,
				no_role = true,
				no_lv = true,
				scale = 1,
				no_grade = true,
				parent = var_141_3:getChildByName("mob_icon"),
				border_code = var_141_0.enemy_user_info.border_code
			})
			if_set(var_141_2, "txt_clan", clanNameFilter(var_141_0.user_info.clan_name))
			UIUtil:updateClanEmblem(var_141_2:getChildByName("n_emblem"), {
				emblem = var_141_0.user_info.clan_emblem
			})
			if_set_visible(var_141_2, "n_emblem", string.len(var_141_0.user_info.clan_name or "") > 0)
			if_set(var_141_3, "txt_clan", clanNameFilter(var_141_0.enemy_user_info.clan_name))
			UIUtil:updateClanEmblem(var_141_3:getChildByName("n_emblem"), {
				emblem = var_141_0.enemy_user_info.clan_emblem
			})
			if_set_visible(var_141_3, "n_emblem", string.len(var_141_0.enemy_user_info.clan_name or "") > 0)
			
			if var_141_0.round_info then
				var_141_4:setVisible(not MatchService:isBroadCastUIHide())
				
				local var_141_8 = 1
				
				for iter_141_2, iter_141_3 in pairs(var_141_0.round_info.rounds or {}) do
					if iter_141_3.state == "finish" or iter_141_3.state == "benefit" then
						var_141_8 = var_141_8 + 1
					end
				end
				
				if_set(var_141_4, "t", "Round " .. tostring(var_141_8))
				arg_141_0:updateRoundInfo(var_141_4:getChildByName("n_left"), var_141_0.user_info.uid, var_141_0.enemy_user_info.uid, var_141_0.round_info)
				arg_141_0:updateRoundInfo(var_141_4:getChildByName("n_right"), var_141_0.enemy_user_info.uid, var_141_0.user_info.uid, var_141_0.round_info)
			end
		else
			Log.e("match info not receive")
		end
	elseif arg_141_0.logic:isPVP() then
		arg_141_0.pvp_gauge_wnd = load_dlg("pvp_global_hp", true, "wnd")
		
		arg_141_0.pvp_gauge_wnd:setVisible(true)
		
		local var_141_9 = arg_141_0.pvp_gauge_wnd:getChildByName("n_gauge_left")
		local var_141_10 = arg_141_0.pvp_gauge_wnd:getChildByName("n_gauge_right")
		
		if_set_visible(arg_141_0.pvp_gauge_wnd, "n_clan_war_round", arg_141_0.logic.round and arg_141_0.logic.round > 0)
		
		if arg_141_0.logic.round then
			local var_141_11 = arg_141_0.pvp_gauge_wnd:getChildByName("n_clan_war_round")
			
			if get_cocos_refid(var_141_11) then
				if_set(var_141_11, "t", T("war_ui_round", {
					round = arg_141_0.logic.round
				}))
			end
		end
		
		BattleField:addUIControl(arg_141_0.pvp_gauge_wnd)
		
		arg_141_0.pvp_start_time = os.time() + 2
		
		if_set(var_141_9, "txt_name", AccountData.name)
		if_set(var_141_10, "txt_name", arg_141_0.logic.enemy_name)
		if_set_visible(arg_141_0.pvp_gauge_wnd, "n_turn", false)
		if_set_visible(arg_141_0.pvp_gauge_wnd, "n_pvp_warning", false)
		if_set_visible(var_141_9, "n_clan", false)
		if_set_visible(var_141_10, "n_clan", false)
		
		if string.split(arg_141_0.logic.enemy_uid, ":")[1] == "sa" then
			local var_141_12 = Clan:getClanInfo()
			
			if var_141_12 then
				if_set(var_141_9, "txt_clan", var_141_12.name or "")
				UIUtil:updateClanEmblem(var_141_9:getChildByName("n_clan"), var_141_12)
				if_set_visible(var_141_9, "n_clan", string.len(var_141_12.name or "") > 0)
			end
			
			local var_141_13 = arg_141_0.logic.enemy_clan
			
			if var_141_13 then
				if_set(var_141_10, "txt_clan", var_141_13.name)
				UIUtil:updateClanEmblem(var_141_10:getChildByName("n_clan"), {
					emblem = var_141_13.emblem
				})
				if_set_visible(var_141_10, "n_clan", string.len(var_141_13.name or "") > 0)
			end
		end
	end
	
	arg_141_0.guide_ring_eff = {}
	arg_141_0.ui_vars = {}
	arg_141_0.ui_vars.auto_target_focus = cc.Node:create()
	
	arg_141_0.ui_vars.auto_target_focus:setPosition(0, 180)
	arg_141_0.ui_vars.auto_target_focus:setScale(1.6)
	arg_141_0.ui_vars.auto_target_focus:retain()
	
	local var_141_14 = SpriteCache:getSprite("img/game_hud_target_c1.png")
	local var_141_15 = SpriteCache:getSprite("img/game_hud_target_c2.png")
	
	var_141_15:setName("border")
	var_141_14:setName("circle")
	var_141_14:setLocalZOrder(1)
	arg_141_0.ui_vars.auto_target_focus:addChild(var_141_14)
	arg_141_0.ui_vars.auto_target_focus:addChild(var_141_15)
	NotchManager:addListener(arg_141_0.battle_wnd:getChildByName("n_soul"), nil, function(arg_142_0, arg_142_1, arg_142_2)
		if not arg_142_0 then
			return 
		end
		
		if arg_142_2 then
			arg_142_0:setPositionX(arg_142_0:getPositionX() - NOTCH_LEFT_WIDTH / 2)
		else
			arg_142_0:setPositionX(arg_142_0:getPositionX() + NOTCH_LEFT_WIDTH / 2)
		end
	end)
	
	local var_141_16 = SceneManager:getRunningNativeScene()
	
	cc.AutoreleasePool:addObjectWithTarget(arg_141_0.ui_vars.auto_target_focus, var_141_16)
	
	if arg_141_1:isScoreType() or arg_141_1:isExpeditionType() then
		arg_141_0.score_panel = UIScorePanel(arg_141_0, arg_141_1)
	end
	
	return BattleUI
end

function BattleUI.highlightMainSkill(arg_143_0, arg_143_1)
	arg_143_0.skill_button_group:highlightSkill(arg_143_1)
end

function BattleUI.createTimerProgressBars(arg_144_0)
	arg_144_0.timer_progress_bars = {}
	
	local var_144_0 = arg_144_0.pvp_gauge_wnd:getChildByName("n_progress")
	local var_144_1 = arg_144_0.pvp_gauge_wnd:getChildByName("progress_bar_my")
	
	local function var_144_2(arg_145_0)
		local var_145_0 = arg_145_0 == FRIEND and "time_progress_bar_blue.png" or "time_progress_bar_red.png"
		local var_145_1 = WidgetUtils:createCircleProgress("img/" .. var_145_0)
		
		var_145_1:setCascadeOpacityEnabled(true)
		var_145_1:setPosition(var_144_1:getPosition())
		var_145_1:setScale(var_144_1:getScale())
		var_145_1:setOpacity(255)
		var_145_1:setReverseDirection(true)
		var_145_1:setName("@progress_" .. arg_145_0)
		
		arg_144_0.timer_progress_bars[arg_145_0] = var_145_1
		
		var_144_0:addChild(var_145_1)
	end
	
	var_144_2(FRIEND)
	var_144_2(ENEMY)
end

function BattleUI.updateRoundInfo(arg_146_0, arg_146_1, arg_146_2, arg_146_3, arg_146_4)
	local var_146_0 = 0
	
	for iter_146_0, iter_146_1 in pairs(arg_146_4.rounds or {}) do
		if (iter_146_1.state == "finish" or iter_146_1.state == "benefit") and iter_146_1.winner == arg_146_2 then
			var_146_0 = var_146_0 + 1
		end
	end
	
	local var_146_1 = math.ceil(arg_146_4.total * 0.5)
	
	for iter_146_2 = 1, 4 do
		local var_146_2 = arg_146_1:getChildByName(tostring(iter_146_2))
		
		if var_146_2 then
			var_146_2:setVisible(iter_146_2 <= var_146_1)
			
			if iter_146_2 <= var_146_0 then
				SpriteCache:resetSprite(var_146_2, "img/pvplive_win_on.png")
			end
		end
	end
end

function BattleUI.newTargetFocusIcon(arg_147_0)
	local var_147_0 = arg_147_0.ui_vars.auto_target_focus:clone()
	
	var_147_0:setName("guide_target_focus")
	
	return var_147_0
end

function BattleUI.showPVPDamageBanner(arg_148_0)
	arg_148_0.damage_infos = {}
	n_pvp_warning = arg_148_0.pvp_gauge_wnd:getChildByName("n_pvp_warning")
	
	n_pvp_warning:setVisible(true)
	n_pvp_warning:setOpacity(255)
	BattleUIAction:Add(SEQ(DELAY(800), FADE_OUT(400), SHOW(false)), n_pvp_warning)
end

function BattleUI.initActionBar(arg_149_0)
	local var_149_0 = BattleField:getUILayer()
	
	UIBattleAttackOrder:init(var_149_0, arg_149_0.logic)
end

function BattleUI.initSupporterButton(arg_150_0)
end

function BattleUI.register(arg_151_0, arg_151_1, arg_151_2)
	local var_151_0 = BattleField:getUILayer()
	
	if arg_151_1.ui_vars.gauge then
		arg_151_1.ui_vars.gauge:remove()
	end
	
	if arg_151_1.ui_vars.condition_bar then
		arg_151_1.ui_vars.condition_bar:remove()
	end
	
	local var_151_1 = false
	
	if arg_151_1.db.tier == "boss" and arg_151_0.logic:isCreviceHunt() then
		var_151_1 = true
	end
	
	arg_151_1.ui_vars.gauge = HPBar:create(arg_151_1, {
		show = false,
		layer = var_151_0,
		isSplitBar = var_151_1
	})
	
	if arg_151_1:isDead() then
		arg_151_1.ui_vars.gauge:setIndividualShow(false)
		arg_151_1.ui_vars.gauge:setVisible(false)
	end
	
	if arg_151_1.db.tier == "boss" and (arg_151_0.logic:isScoreType() or arg_151_0.logic:isExpeditionType()) then
		arg_151_1.ui_vars.condition_bar = ConditionBar:create(arg_151_1, {
			layer = var_151_0
		})
		
		if arg_151_1:isDead() then
			arg_151_1.ui_vars.condition_bar:setVisible(false)
		end
	end
end

function BattleUI.updateUnitGaugeInfo(arg_152_0, arg_152_1)
	if arg_152_1 then
		if arg_152_1.ui_vars.gauge then
			arg_152_1.ui_vars.gauge:updateSP()
		end
		
		if arg_152_1.ui_vars.condition_bar then
			arg_152_1.ui_vars.condition_bar:updateSP()
		end
		
		if arg_152_1 == Battle.logic:getTurnOwner() then
			UIBattleAttackOrder:updateBattleResInfo(arg_152_1)
			
			if FRIEND == arg_152_1.inst.ally and (arg_152_0.soul_gauge.max_soul_piece or 0) > (Battle.viewer:getTeamRes(arg_152_1.inst.ally, "soul_piece") or 0) then
				arg_152_0.soul_gauge:updateSoulPiece()
			end
			
			arg_152_0:updatePVPSoulPiece()
		end
	end
end

function BattleUI.setIndividualShow(arg_153_0, arg_153_1)
	for iter_153_0, iter_153_1 in pairs(arg_153_0.logic.friends) do
		if iter_153_1.model then
			if not iter_153_1.ui_vars.gauge then
				arg_153_0:register(iter_153_1)
			end
			
			if iter_153_1.ui_vars.gauge.individual_show ~= arg_153_1 then
				iter_153_1.ui_vars.gauge:setIndividualShow(arg_153_1)
				
				if get_cocos_refid(iter_153_1.ui_vars.gauge.control) then
					iter_153_1.ui_vars.gauge:setVisible(arg_153_1)
				end
				
				if arg_153_1 then
					arg_153_0:doIndividualShowAction(iter_153_1)
				end
			end
		end
	end
end

function BattleUI.refreshIndividualShow(arg_154_0)
	for iter_154_0, iter_154_1 in pairs(arg_154_0.logic.friends) do
		if iter_154_1.model then
			if not iter_154_1.ui_vars.gauge then
				arg_154_0:register(iter_154_1)
			end
			
			if iter_154_1.ui_vars.gauge.individual_show ~= iter_154_1.ui_vars.gauge:isVisible() then
				iter_154_1.ui_vars.gauge:setVisible(iter_154_1.ui_vars.gauge.individual_show)
				
				if iter_154_1.ui_vars.gauge.individual_show then
					arg_154_0:doIndividualShowAction(iter_154_1)
				end
			end
		end
	end
end

function BattleUI.doIndividualShowAction(arg_155_0, arg_155_1)
	local var_155_0 = "hpbar.IndividualShow" .. (arg_155_1:getName() or "")
	
	if not BattleUIAction:Find(var_155_0) then
		BattleUIAction:Add(SEQ(FADE_IN(200)), arg_155_1.ui_vars.gauge, var_155_0)
	end
end

function BattleUI.endBattleScene(arg_156_0)
end

function BattleUI.hideAutoPanel(arg_157_0)
	if arg_157_0.auto_panel then
		arg_157_0.auto_panel:hide()
	end
end

function BattleUI.isVisible(arg_158_0)
	return arg_158_0._visible
end

function BattleUI.setVisible(arg_159_0, arg_159_1)
	arg_159_0._visible = arg_159_1
	
	local var_159_0 = 450
	local var_159_1 = NONE()
	
	if arg_159_1 then
		arg_159_0.soul_gauge:updateSoulPiece()
		arg_159_0.soul_gauge:update()
		arg_159_0:updatePVPSoulPiece()
		arg_159_0:updateSummonState()
		
		if var_159_0 then
			local var_159_2 = 640
			local var_159_3 = 360
			
			var_159_1 = MOVE_TO(var_159_0, var_159_2, var_159_3)
		end
		
		BattleMapManager:updateBattleStageCount()
		BattleUIAction:Add(SEQ(SHOW(true), var_159_1, SHOW(arg_159_1)), arg_159_0.battle_wnd, "battle")
	else
		UIBattleAttackOrder:hide()
		
		if arg_159_0.score_panel then
			arg_159_0.score_panel:hide()
		end
		
		arg_159_0.soul_gauge:hide()
	end
end

function BattleUI.initSummonStateCtrl(arg_160_0)
	arg_160_0.summon_skill_gage = WidgetUtils:createCircleProgress("img/cm_cool_hero.png")
	
	arg_160_0.summon_skill_gage:setScale(0.9)
	arg_160_0.summon_skill_gage:setOpacity(150)
	arg_160_0.summon_skill_gage:setPercentage(50)
	
	arg_160_0.summon_state_ctrl = arg_160_0.battle_wnd:getChildByName("sinsu_state")
	
	arg_160_0.summon_state_ctrl:addChildFirst(arg_160_0.summon_skill_gage)
	arg_160_0.summon_state_ctrl:setVisible(true)
	if_set_visible(arg_160_0.summon_state_ctrl, "bg_lack", false)
	
	arg_160_0.summon_ctrl = arg_160_0.battle_wnd:getChildByName("n_sinsu")
	arg_160_0.summon_face_ctrl = arg_160_0.battle_wnd:getChildByName("sinsu_face")
	
	arg_160_0.summon_face_ctrl:setVisible(false)
	
	arg_160_0.summon_txt_res = arg_160_0.battle_wnd:getChildByName("txt_lack_res")
	
	if arg_160_0.logic:isScoreType() or Battle:isReplayMode() then
		arg_160_0.soul_gauge = {}
		
		for iter_160_0, iter_160_1 in pairs(UISoulUnitGaugebar) do
			if type(iter_160_1) == "function" then
				arg_160_0.soul_gauge[iter_160_0] = function()
				end
			end
		end
		
		local var_160_0 = arg_160_0.battle_wnd:getChildByName("n_soul")
		
		if get_cocos_refid(var_160_0) then
			var_160_0:setVisible(false)
		end
	else
		arg_160_0.soul_gauge = UISoulUnitGaugebar(FRIEND, arg_160_0.battle_wnd:getChildByName("n_soul"), arg_160_0.logic)
	end
	
	arg_160_0:initSummonButton()
end

function BattleUI.initSummonReservation(arg_162_0)
	local var_162_0 = Battle:isSummonReservationOn()
	
	arg_162_0:setVisibleSummonReservation(var_162_0)
end

function BattleUI.initReplayController(arg_163_0)
	if Battle:isReplayMode() then
		arg_163_0.replay_controller = UIReplayController(nil, Battle.viewer, "battle")
	else
		if_set_visible(arg_163_0.battle_wnd, "n_player", false)
	end
end

function BattleUI.getReplayController(arg_164_0)
	if ClearResult:isShow() then
		return ClearResult:getReplayController()
	else
		return arg_164_0.replay_controller
	end
end

function BattleUI.setVisibleSummonReservation(arg_165_0, arg_165_1)
	if_set_visible(arg_165_0.battle_wnd, "sinsu_reservation", arg_165_1)
	if_set_visible(arg_165_0.battle_wnd, "icon_check_sinsu", arg_165_1)
end

function BattleUI.toggleSummonReservation(arg_166_0)
	local var_166_0 = Battle:toggleSummonReservation()
	
	arg_166_0:setVisibleSummonReservation(var_166_0)
end

function BattleUI.onToggleSoulBurn(arg_167_0, arg_167_1)
	arg_167_0.skill_button_group:playSoulBurnSelectEffect(arg_167_1)
end

function BattleUI.fireSummonSkill(arg_168_0)
	if UIAction:Find("block") then
		return 
	end
	
	arg_168_0:toggleSummonReservation()
end

function BattleUI.initSummonButton(arg_169_0)
	if not arg_169_0.summon_face_ctrl.btn_sinsu then
		arg_169_0.summon_face_ctrl.btn_sinsu = arg_169_0.summon_face_ctrl:getChildByName("btn_sinsu")
	end
end

function BattleUI.showEmojiPanel(arg_170_0)
	RtaEmojiPopup:show()
end

function BattleUI.hideEmojiPanel(arg_171_0)
	RtaEmojiPopup:close()
end

function BattleUI.toggleEmogiBlock(arg_172_0)
	if arg_172_0.emoji_panel then
		arg_172_0.emoji_panel:toggleEmogiBlock()
	end
end

function BattleUI.isVisibleEmojiPanel(arg_173_0)
	return RtaEmojiPopup:isVisible()
end

function BattleUI.getEmojiPanel(arg_174_0)
	return arg_174_0.emoji_panel
end

function BattleUI.toggleReplayController(arg_175_0)
	if arg_175_0.replay_controller then
		arg_175_0.replay_controller:toggle()
	end
end

function BattleUI.showReplayController(arg_176_0)
	if arg_176_0.replay_controller then
		arg_176_0.replay_controller:show()
	end
end

function BattleUI.hideReplayController(arg_177_0, arg_177_1)
	if arg_177_0.replay_controller then
		arg_177_0.replay_controller:hide(arg_177_1)
	end
end

function BattleUI.startTopSoulEffect(arg_178_0, arg_178_1)
	if arg_178_0.pvp_gauge_wnd and arg_178_0.pvp_gauge_wnd.soul then
		arg_178_0.pvp_gauge_wnd.soul:startSoulEffect(arg_178_1)
	end
end

function BattleUI.stopTopSoulEffect(arg_179_0)
	if arg_179_0.pvp_gauge_wnd and arg_179_0.pvp_gauge_wnd.soul then
		arg_179_0.pvp_gauge_wnd.soul:stopSoulEffect()
	end
end

function BattleUI.gainSoulEffectByObject(arg_180_0, arg_180_1, arg_180_2)
	if arg_180_0.logic:isScoreType() then
		return 
	end
	
	if not arg_180_2 then
		arg_180_0.soul_gauge:show()
	end
	
	local var_180_0 = {}
	
	for iter_180_0 = 1, MAX_SOUL_FX_COUNT do
		table.insert(var_180_0, UISoulGainEffect(arg_180_0, arg_180_1, iter_180_0))
	end
	
	Thread("gain.soul", function()
		local var_181_0 = 6
		local var_181_1 = true
		
		while var_181_1 do
			coroutine.yield()
			
			var_181_1 = false
			
			for iter_181_0, iter_181_1 in pairs(var_180_0) do
				if not iter_181_1.is_finished then
					var_181_1 = true
					
					break
				end
			end
		end
		
		coroutine.yield()
		
		if not arg_180_2 then
			arg_180_0.soul_gauge:hide()
		end
	end)
	arg_180_0.soul_gauge:setMaxSoulPiece(Battle.viewer:getTeamRes(FRIEND, "soul_piece") or 0)
end

function BattleUI.gainSoulEffectByAttacker(arg_182_0, arg_182_1, arg_182_2, arg_182_3)
	if FRIEND == arg_182_1:getAlly() then
		if not arg_182_3 or arg_182_3 <= 0 then
			return 
		end
		
		for iter_182_0 = 1, arg_182_3 do
			local var_182_0 = math.random(1, #arg_182_2)
			
			if arg_182_2[var_182_0].model and get_cocos_refid(arg_182_2[var_182_0].model) then
				UISoulGainEffect(arg_182_0, arg_182_2[var_182_0].model, iter_182_0)
			end
		end
		
		arg_182_0.soul_gauge:setMaxSoulPiece(Battle.viewer:getTeamRes(FRIEND, "soul_piece") or 0)
		arg_182_0.soul_gauge:updateSoulPiece()
	end
	
	arg_182_0:updatePVPSoulPiece()
end

function BattleUI.updatePVPSoulPiece(arg_183_0)
	if arg_183_0.pvp_gauge_wnd and arg_183_0.pvp_gauge_wnd.soul then
		arg_183_0.pvp_gauge_wnd.soul:updateSoulPiece()
	end
end

function BattleUI.updateSummonState(arg_184_0)
	if not get_cocos_refid(arg_184_0.summon_face_ctrl) then
		return 
	end
	
	local var_184_0 = arg_184_0.logic:getSummon(FRIEND)
	local var_184_1 = Battle.viewer:getTeamRes(FRIEND, "soul_piece") or 0
	
	if var_184_0 then
		local var_184_2 = string.format("face/%s_s.png", var_184_0.inst.face_id or var_184_0.inst.code)
		
		SpriteCache:resetSprite(arg_184_0.summon_face_ctrl, var_184_2)
		arg_184_0.summon_face_ctrl:setVisible(true)
		
		local var_184_3 = to_n(var_184_0:getSkillReqPoint(var_184_0:getSkillByIndex(1)))
		local var_184_4 = var_184_3 - var_184_1
		
		if var_184_4 > 0 then
			arg_184_0.summon_txt_res:setString(T("txt_need_for_summon_point", {
				point = var_184_4
			}))
			arg_184_0.summon_txt_res:setVisible(true)
			arg_184_0.summon_skill_gage:setPercentage(var_184_4 * 100 / var_184_3)
			arg_184_0.summon_skill_gage:setVisible(true)
			
			if arg_184_0.summon_ctrl.effect then
				arg_184_0.summon_ctrl.effect:removeFromParent()
				
				arg_184_0.summon_ctrl.effect = nil
			end
		else
			arg_184_0.summon_txt_res:setVisible(false)
			arg_184_0.summon_skill_gage:setVisible(false)
			
			if not arg_184_0.summon_ctrl.effect then
				arg_184_0.summon_ctrl.effect = EffectManager:Play({
					scale = 0.8,
					name = "super_ready.cfx",
					y = 1,
					x = -1,
					layer = arg_184_0.summon_ctrl
				})
			end
		end
	else
		arg_184_0.summon_face_ctrl:setVisible(false)
		arg_184_0.summon_state_ctrl:setVisible(false)
	end
end

function BattleUI.showGauge(arg_185_0)
	if not Battle.logic then
		return 
	end
	
	if arg_185_0.score_panel then
		arg_185_0.score_panel:show()
	end
	
	if arg_185_0.soul_gauge and not arg_185_0.soul_gauge:isShow() then
		local var_185_0 = true
		
		if Battle.viewer and Battle.viewer:isSpectator() then
			var_185_0 = false
		end
		
		if var_185_0 then
			arg_185_0.soul_gauge:show()
		end
	end
	
	for iter_185_0, iter_185_1 in pairs(arg_185_0.logic.units) do
		if get_cocos_refid(iter_185_1.model) and iter_185_1.ui_vars.gauge and iter_185_1.ui_vars.gauge:isValid() then
			local var_185_1 = iter_185_1.ui_vars.gauge
			
			if not var_185_1:isVisible() or var_185_1:getOpacity() < 255 then
				var_185_1:setVisible(true)
			end
			
			iter_185_1.ui_vars.gauge:updateState()
		end
	end
end

function BattleUI.hideGauge(arg_186_0)
	if not Battle.logic then
		return 
	end
	
	local var_186_0 = Battle.logic:getTurnOwner()
	local var_186_1 = var_186_0 and var_186_0.inst.ally or nil
	
	for iter_186_0, iter_186_1 in pairs(arg_186_0.logic.units) do
		if (iter_186_1.inst.ally == var_186_1 or var_186_1 == nil) and get_cocos_refid(iter_186_1.model) and iter_186_1.ui_vars.gauge then
			local var_186_2 = iter_186_1.ui_vars.gauge
			
			if var_186_2:isValid() and var_186_2:isVisible() and var_186_2:getOpacity() > 0 then
				var_186_2:setVisible(false)
			end
		end
	end
end

function BattleUI.test(arg_187_0, arg_187_1)
	local var_187_0, var_187_1 = arg_187_0.skill_button_group:getPosition()
	
	arg_187_0.skill_button_group:setPositionX(DESIGN_WIDTH + arg_187_0.skill_button_group:getContentSize().width)
	BattleUIAction:Add(SEQ(FADE_IN(0), DELAY(50), SPAWN(LOG(MOVE_TO(var_0_2, var_187_0, var_187_1), arg_187_1 or 20), SCALE_TO(var_0_2, 1))), arg_187_0.skill_button_group, "battle")
end

function BattleUI.testui(arg_188_0)
	arg_188_0.vars = {}
	arg_188_0.ui_vars.auto_target_focus = cc.Node:create()
	
	arg_188_0.ui_vars.auto_target_focus:setPosition(0, 180)
	arg_188_0.ui_vars.auto_target_focus:setScale(1.6)
	arg_188_0.ui_vars.auto_target_focus:retain()
	
	local var_188_0 = SpriteCache:getSprite("img/game_hud_target_c1.png")
	local var_188_1 = SpriteCache:getSprite("img/game_hud_target_c2.png")
	
	var_188_1:setName("border")
	var_188_0:setName("circle")
	var_188_0:setLocalZOrder(1)
	arg_188_0.ui_vars.auto_target_focus:addChild(var_188_0)
	arg_188_0.ui_vars.auto_target_focus:addChild(var_188_1)
	BGI.ui_layer:addChild(arg_188_0.ui_vars.auto_target_focus)
end

function BattleUI.showAutoTargetFocusRing(arg_189_0, arg_189_1)
	arg_189_0:hideAutoTargetFocusRing()
	arg_189_1.model:addChild(arg_189_0.ui_vars.auto_target_focus)
	
	local var_189_0, var_189_1 = arg_189_1.model.body:getBonePosition("target")
	
	arg_189_0.ui_vars.auto_target_focus:setPosition(var_189_0, var_189_1)
	BattleAction:Remove("battle.auto_target_focus")
	
	local var_189_2 = arg_189_0.ui_vars.auto_target_focus:getChildByName("circle")
	
	if var_189_2 then
		var_189_2:setOpacity(0)
		BattleAction:Add(SEQ(FADE_IN(300), LOOP(SEQ(LOG(ROTATE(1200, 0, 360)), DELAY(400)))), var_189_2, "battle.auto_target_focus")
	end
	
	local var_189_3 = arg_189_0.ui_vars.auto_target_focus:getChildByName("border")
	
	if var_189_3 then
		var_189_3:setOpacity(0)
		BattleAction:Add(SEQ(FADE_IN(300), LOOP(SPAWN(SCALE(1600, 1, 0), ROTATE(1600, 360, 0), FADE_OUT(1600)))), arg_189_0.ui_vars.auto_target_focus:getChildByName("border"), "battle.auto_target_focus")
	end
	
	BattleAction:Remove("focus.adjust_auto_position")
	BattleAction:Add(SEQ(LOOP(SEQ(DELAY(100), CALL(function()
		if arg_189_1 and arg_189_1.model and get_cocos_refid(arg_189_1.model.body) then
			local var_190_0, var_190_1 = arg_189_1.model.body:getBonePosition("target")
			
			arg_189_0.ui_vars.auto_target_focus:setPosition(var_190_0, var_190_1)
		end
	end)))), arg_189_0.ui_vars.auto_target_focus, "focus.adjust_auto_position")
end

function BattleUI.hideAutoTargetFocusRing(arg_191_0)
	if arg_191_0.ui_vars and get_cocos_refid(arg_191_0.ui_vars.auto_target_focus) then
		arg_191_0.ui_vars.auto_target_focus:removeFromParent()
	end
	
	BattleAction:Remove("battle.auto_target_focus")
end

function BattleUI.showGuideFocusRing(arg_192_0, arg_192_1, arg_192_2)
	if arg_192_2 then
		for iter_192_0, iter_192_1 in pairs(Battle.vars.empty_position_targets) do
			local var_192_0 = arg_192_0:newTargetFocusIcon()
			
			table.insert(arg_192_0.guide_ring_eff, var_192_0)
			iter_192_1:addChild(var_192_0)
			
			local var_192_1, var_192_2 = iter_192_1.body:getBonePosition("target")
			
			var_192_0:setPosition(var_192_1, var_192_2)
			
			local var_192_3 = var_192_0:getChildByName("circle")
			
			if var_192_3 then
				var_192_3:setOpacity(0)
				BattleAction:Add(SEQ(FADE_IN(300), LOOP(SEQ(LOG(ROTATE(1200, 0, 360)), DELAY(400)))), var_192_3, "battle.guide_target_focus")
			end
			
			local var_192_4 = var_192_0:getChildByName("border")
			
			if var_192_4 then
				var_192_4:setOpacity(0)
				BattleAction:Add(SEQ(FADE_IN(300), LOOP(SPAWN(SCALE(1600, 1, 0), ROTATE(1600, 360, 0), FADE_OUT(1600)))), var_192_0:getChildByName("border"), "battle.guide_target_focus")
			end
			
			BattleAction:Remove("focus.adjust_position")
			BattleAction:Add(SEQ(LOOP(SEQ(DELAY(100), CALL(function()
				if iter_192_1 and iter_192_1.model and get_cocos_refid(var_192_0) and get_cocos_refid(iter_192_1.model.body) then
					local var_193_0, var_193_1 = iter_192_1.model.body:getBonePosition("target")
					
					var_192_0:setPosition(var_193_0, var_193_1)
				end
			end)))), var_192_0, "focus.adjust_position")
		end
	else
		for iter_192_2, iter_192_3 in pairs(Battle.vars.arrange_skill.target_candidates) do
			if iter_192_3.inst.ally == arg_192_1 and iter_192_3.model and not iter_192_3:isDead() then
				local var_192_5 = arg_192_0:newTargetFocusIcon()
				
				table.insert(arg_192_0.guide_ring_eff, var_192_5)
				iter_192_3.model:addChild(var_192_5)
				
				local var_192_6, var_192_7 = iter_192_3.model.body:getBonePosition("target")
				
				var_192_5:setPosition(var_192_6, var_192_7)
				
				local var_192_8 = var_192_5:getChildByName("circle")
				
				if var_192_8 then
					var_192_8:setOpacity(0)
					BattleAction:Add(SEQ(FADE_IN(300), LOOP(SEQ(LOG(ROTATE(1200, 0, 360)), DELAY(400)))), var_192_8, "battle.guide_target_focus")
				end
				
				local var_192_9 = var_192_5:getChildByName("border")
				
				if var_192_9 then
					var_192_9:setOpacity(0)
					BattleAction:Add(SEQ(FADE_IN(300), LOOP(SPAWN(SCALE(1600, 1, 0), ROTATE(1600, 360, 0), FADE_OUT(1600)))), var_192_5:getChildByName("border"), "battle.guide_target_focus")
				end
				
				BattleAction:Remove("focus.adjust_position")
				BattleAction:Add(SEQ(LOOP(SEQ(DELAY(100), CALL(function()
					if iter_192_3 and iter_192_3.model and get_cocos_refid(var_192_5) and get_cocos_refid(iter_192_3.model.body) then
						local var_194_0, var_194_1 = iter_192_3.model.body:getBonePosition("target")
						
						var_192_5:setPosition(var_194_0, var_194_1)
					end
				end)))), var_192_5, "focus.adjust_position")
			end
		end
	end
end

function BattleUI.GuideFocusRingRemoveAction(arg_195_0)
	BattleUIAction:Remove("battle.guide_target_focus")
	
	for iter_195_0, iter_195_1 in pairs(arg_195_0.guide_ring_eff) do
		if get_cocos_refid(iter_195_1) then
			BattleUIAction:Add(SEQ(FADE_OUT(400)), iter_195_1:getChildByName("border"), "battle.guide_target_focus")
			BattleUIAction:Add(SEQ(FADE_OUT(400), CALL(BattleUI.removeGuideFocusRing, arg_195_0)), iter_195_1:getChildByName("circle"), "battle.guide_target_focus")
		end
	end
end

function BattleUI.removeGuideFocusRing(arg_196_0)
	for iter_196_0, iter_196_1 in pairs(arg_196_0.guide_ring_eff or {}) do
		if get_cocos_refid(iter_196_1) then
			local var_196_0 = iter_196_1:getParent()
			
			if var_196_0 ~= nil and get_cocos_refid(var_196_0) then
				var_196_0:removeChild(iter_196_1)
			end
		end
	end
	
	arg_196_0.guide_ring_eff = {}
end

function BattleUI.showTargetGuide(arg_197_0, arg_197_1)
	if not Battle.vars.arrange_skill.target_candidates then
		return 
	end
	
	if not Battle.vars.arrange_skill.target_candidates[1] then
		return 
	end
	
	local var_197_0 = DB("skill", Battle.vars.arrange_skill.skill_id, "target")
	local var_197_1 = Battle.vars.arrange_skill.target_candidates[1].inst.ally
	local var_197_2 = var_197_0 == 32 or var_197_0 == 33
	
	if not arg_197_1 then
		local var_197_3 = BGI.ui_layer:getChildByName("guide_target")
		
		if var_197_3 then
			var_197_3:removeFromParent()
		end
		
		BattleUIAction:Remove("battle.guide")
		
		return 
	end
	
	if Battle:isReplayMode() then
		return 
	end
	
	if BattleUIAction:Find("battle.guide") then
		return 
	end
	
	local var_197_4 = cc.CSLoader:createNode("wnd/guide_target.csb")
	
	var_197_4:setName("guide_target")
	var_197_4:setOpacity(0)
	var_197_4:setLocalZOrder(-1)
	BGI.ui_layer:addChild(var_197_4)
	
	local var_197_5 = var_197_4:getChildByName("shade")
	
	if var_197_5 then
		local var_197_6 = var_197_5:getScaleX()
		
		if var_197_5 and var_197_1 == ENEMY then
			var_197_5:setScaleX(0 - var_197_6 * (Battle:isReverseDirection() and -1 or 1))
		end
	end
	
	local var_197_7 = var_197_4:getChildByName("txt")
	
	if var_197_7 then
		var_197_7:setString(T("touch_valid_target"))
	end
	
	arg_197_0:showGuideFocusRing(var_197_1, var_197_2)
	BattleUIAction:Add(SEQ(FADE_IN(300), DELAY(200), FADE_OUT(200), CALL(BattleUI.GuideFocusRingRemoveAction, arg_197_0), REMOVE()), var_197_4, "battle.guide")
end

function BattleUI.playAttackOrder(arg_198_0, arg_198_1, arg_198_2)
	UIBattleAttackOrder:play(arg_198_1, arg_198_2)
end

function BattleUI.restoreSkillButtons(arg_199_0)
	if arg_199_0.logic then
		local var_199_0 = arg_199_0.logic:getTurnState()
		local var_199_1 = arg_199_0.logic:getTurnOwner()
		
		if not Battle:isPlayingBattleAction() then
			if var_199_1 and var_199_1:getAlly() == FRIEND and (var_199_0 == "ready" or var_199_0 == "pending_ready") and Battle.viewer and not Battle.viewer:isSpectator() then
				if get_cocos_refid(arg_199_0.skill_button_group) and not arg_199_0.skill_button_group:isVisible() then
					arg_199_0:showSkillButtons(var_199_1, true)
				end
			elseif get_cocos_refid(arg_199_0.skill_button_group) then
				arg_199_0:hideSkillButtons()
			end
		end
	end
end

function BattleUI.showSkillButtons(arg_200_0, arg_200_1, arg_200_2)
	arg_200_0.attacker = arg_200_1
	
	if arg_200_1.inst.ally == FRIEND then
		UIBattleAttackOrder:showSupporterButton(arg_200_0.logic.friend_hidden)
	end
	
	local var_200_0 = arg_200_1:getActiveSkillIds()
	local var_200_1 = 1
	
	if not get_cocos_refid(arg_200_0.skill_button_group) then
		arg_200_0.skill_button_group = UISkillButtonGroup:create(arg_200_0)
	end
	
	if not arg_200_0.soul_gauge:isShow() then
		arg_200_0.soul_gauge:show()
	end
	
	if arg_200_1.inst and FRIEND == arg_200_1.inst.ally or Battle.logic:isDualControl() and not Battle:isAutoPlaying() or Battle:isReplayMode() then
		arg_200_0.skill_button_group:show(arg_200_1, arg_200_2)
	end
	
	arg_200_0.soul_gauge:readySoulburn(nil)
end

function BattleUI.hideSkillButtons(arg_201_0)
	if not arg_201_0.skill_button_group or not get_cocos_refid(arg_201_0.skill_button_group) then
		arg_201_0.skill_button_group = UISkillButtonGroup:create(arg_201_0)
	end
	
	if not arg_201_0.skill_button_group or not get_cocos_refid(arg_201_0.skill_button_group) then
		return 
	end
	
	arg_201_0.skill_button_group:hide()
	
	local var_201_0, var_201_1 = arg_201_0.skill_button_group:getSelected()
	
	if VARS.PLAY_SKILL_NAME then
		UINotifySkill(arg_201_0.selected_skill:getSkillId(), arg_201_0.attacker)
	end
	
	arg_201_0.soul_gauge:readySoulburn(nil)
	UIBattleAttackOrder:showSupporterButton(nil)
end

function BattleUI.setSoulState(arg_202_0, arg_202_1)
	local var_202_0 = 0
	
	for iter_202_0 = 1, 3 do
		local var_202_1 = arg_202_0.attacker:getSkillBundle():slot(iter_202_0)
		
		if var_202_1 then
			local var_202_2, var_202_3 = var_202_1:getSoulBurnSkill()
			
			var_202_0 = math.max(var_202_0, var_202_3 or 0)
		end
	end
	
	arg_202_0.soul_gauge:readySoulburn(arg_202_1, var_202_0)
	arg_202_0.skill_button_group:setSoulState(arg_202_1)
	arg_202_0:onToggleSoulBurn(arg_202_1 ~= nil)
end

function BattleUI.onSelectSkill(arg_203_0, arg_203_1, arg_203_2)
	arg_203_0.attacker = arg_203_1
	arg_203_0.selected_skill = arg_203_0.attacker:getSkillBundle():slot(arg_203_2)
	
	if not get_cocos_refid(arg_203_0.skill_button_group) then
		arg_203_0.skill_button_group = UISkillButtonGroup:create(arg_203_0)
		
		if arg_203_1.inst and FRIEND == arg_203_1.inst.ally then
			arg_203_0.skill_button_group:show(arg_203_1)
		end
	end
	
	if not Battle:isReplayMode() then
		arg_203_0.skill_button_group:setSelected(arg_203_2)
	end
end

function BattleUI.showSkillName(arg_204_0, arg_204_1, arg_204_2)
	if not get_cocos_refid(BGI.ui_layer) then
		return 
	end
	
	if MatchService:isBroadCastUIHide() then
		return 
	end
	
	BattleUIAction:Remove("battle.skill_name")
	
	local var_204_0 = BGI.ui_layer:getChildByName("@skill_name")
	
	if not get_cocos_refid(var_204_0) then
		var_204_0 = load_control("wnd/game_eff_skill.csb")
		
		var_204_0:setName("@skill_name")
		BGI.ui_layer:addChildLast(var_204_0)
	end
	
	if_set(var_204_0, "t_name", T(arg_204_1.db.name))
	if_set(var_204_0, "t_skill", T(DB("skill", arg_204_2, "name")))
	
	local var_204_1 = var_204_0:getChildByName("n_skill_icon")
	
	if get_cocos_refid(var_204_1) then
		var_204_1:removeChildByName("@skill_icon")
		
		local var_204_2 = UISkillIcon:create(arg_204_2)
		
		var_204_2:setName("@skill_icon")
		var_204_1:addChild(var_204_2)
	end
	
	var_204_0:setPositionX(NOTCH_LEFT_WIDTH / 2)
	var_204_0:setOpacity(255)
	BattleUIAction:Add(SEQ(SHOW(true), FADE_IN(200), DELAY(2000), FADE_OUT(200), SHOW(false)), var_204_0, "battle.skill_name")
	NotchManager:addListener(var_204_0, nil, function(arg_205_0, arg_205_1, arg_205_2)
		if arg_205_2 then
			var_204_0:setPositionX(NOTCH_LEFT_WIDTH / 2)
		else
			var_204_0:setPositionX(0)
		end
	end)
	
	local var_204_3 = var_204_0:getChildByName("n_bg_mover")
	
	if get_cocos_refid(var_204_3) then
		var_204_3:setPositionX(-300)
		BattleUIAction:Add(SEQ(LOG(MOVE_TO(200, 0, 0)), DELAY(2000), RLOG(MOVE_TO(200, -300, 0))), var_204_3, "battle.skill_name")
	end
	
	local var_204_4 = var_204_0:getChildByName("n_name_mover")
	
	if get_cocos_refid(var_204_4) then
		var_204_4:setPositionX(600)
		BattleUIAction:Add(SEQ(LOG(MOVE_TO(200, 0, 0)), SPAWN(DELAY(2000)), RLOG(MOVE_TO(200, 600, 0))), var_204_4, "battle.skill_name")
	end
end

function BattleUI.showAggroEffect(arg_206_0, arg_206_1, arg_206_2)
	local var_206_0 = arg_206_1:getProvoker()
	
	if not var_206_0 then
		return 
	end
	
	for iter_206_0, iter_206_1 in pairs(arg_206_2) do
		if not iter_206_1:isDead() then
			local var_206_1
			local var_206_2, var_206_3 = iter_206_1.model:getBonePosition("top")
			local var_206_4, var_206_5 = iter_206_1.model:getPosition()
			
			if iter_206_1 == var_206_0 then
				local var_206_6 = EffectManager:Play({
					name = "taunt_target.cfx",
					x = 0,
					layer = iter_206_1.model,
					y = var_206_3 - var_206_5
				})
				
				table.insert(arg_206_0.target_arrows, var_206_6)
			end
		end
	end
end

function BattleUI.showTargetButtons(arg_207_0, arg_207_1, arg_207_2)
	if Battle:isAutoPlaying() or not arg_207_2 then
		return 
	end
	
	local var_207_0 = BattleLayout:getDirection() or 1
	local var_207_1
	local var_207_2 = var_207_0 == 1 and "n_target_left" or "n_target_right"
	
	arg_207_0:hideTargetButtons()
	
	for iter_207_0, iter_207_1 in pairs(arg_207_2) do
		if not iter_207_1:isDead() then
			local var_207_3 = load_dlg("hud_order", true, "wnd")
			
			var_207_3.unit = iter_207_1
			
			table.insert(arg_207_0.target_arrows, var_207_3)
			if_set_sprite(var_207_3, "o", "img/itxt_num" .. to_n(iter_207_1.inst.team_order or 1) .. "_b.png")
			var_207_3:setLocalZOrder(9999)
			var_207_3:setPosition(0, 0)
			
			local var_207_4 = iter_207_1.ui_vars.gauge
			
			if var_207_4 and var_207_4:isValid() then
				local var_207_5 = var_207_4.control:getChildByName(var_207_2)
				
				if var_207_5 and get_cocos_refid(var_207_5) then
					var_207_5:addChild(var_207_3)
				end
				
				if iter_207_1.ui_vars.gauge.is_boss_mode then
					var_207_3:setVisible(false)
				end
			end
			
			UIBattleAttackOrder:showTargetNumbers(arg_207_2)
		end
	end
end

function BattleUI.hideTargetButtons(arg_208_0)
	for iter_208_0, iter_208_1 in pairs(arg_208_0.target_arrows) do
		if get_cocos_refid(iter_208_1) then
			iter_208_1:removeFromParent()
		end
	end
	
	arg_208_0.target_arrows = {}
	
	UIBattleAttackOrder:hideTargetNumbers()
end

function BattleUI.onUpdateGauge(arg_209_0, arg_209_1)
	if not arg_209_1 then
		return 
	end
	
	if arg_209_0.logic:isRealtimeMode() or arg_209_0.logic:isViewerMode() then
		arg_209_0:updatePVPGauge()
	end
	
	if arg_209_1.ui_vars.gauge and arg_209_1.ui_vars.gauge:isValid() then
		arg_209_1.ui_vars.gauge:set()
		arg_209_1.ui_vars.gauge:updateSkillSequencer()
	end
	
	if arg_209_1.ui_vars.condition_bar then
		arg_209_1.ui_vars.condition_bar:updateSP()
	end
end

function BattleUI.onUpdateStateOrder(arg_210_0)
	for iter_210_0, iter_210_1 in pairs(arg_210_0.logic.units) do
		if iter_210_1.ui_vars.gauge and iter_210_1.ui_vars.gauge:isValid() then
			iter_210_1.ui_vars.gauge:updateState(true)
		end
	end
end

function BattleUI.resetCombo(arg_211_0)
	Combo:resetCombo()
end

function BattleUI.checkOverlapSkillButtons(arg_212_0, arg_212_1, arg_212_2)
	if not arg_212_0.skill_button_group then
		return false
	end
	
	return arg_212_0.skill_button_group:checkCollision(arg_212_1, arg_212_2)
end

function BattleUI.updateTimeline(arg_213_0)
end

function BattleUI.checkSkillPick(arg_214_0)
end

function BattleUI.hideSkillInfo(arg_215_0)
end

function BattleUI.playFaceFrame(arg_216_0)
end

function BattleUI.displayState(arg_217_0, arg_217_1)
	if arg_217_1.type ~= "add_state" then
		return 
	end
	
	if not arg_217_1.state then
		return 
	end
	
	if not arg_217_1.state.db.name then
		return 
	end
	
	local var_217_0 = tostring(arg_217_1.state.id)
	local var_217_1 = arg_217_1.state:getName()
	local var_217_2 = {
		stack_count = tonumber(arg_217_1.state.stack_count)
	}
	local var_217_3 = UIUtil:getStateIcon(var_217_0, nil, var_217_2)
	
	if var_217_3 then
		var_217_3:setAnchorPoint(1.2, -0.1)
	end
	
	arg_217_0:displayText(arg_217_1.target, var_217_1, nil, var_217_3)
end

function BattleUI.displayBanner(arg_218_0, arg_218_1)
	arg_218_1 = arg_218_1 or {}
	arg_218_1.info = arg_218_1.info or {}
	
	if arg_218_1.info.type == "speech" then
		BattleUIAction:Append(SEQ(CALL(arg_218_0.logic.pause, arg_218_0.logic, "banner"), DELAY(arg_218_1.info.delay_time or 0), CALL(arg_218_0.logic.resume, arg_218_0.logic, "banner")), arg_218_0, "banner.pause")
	end
	
	flash_banner(T(arg_218_1.info.textid or ""), arg_218_1.info.type or "normal", arg_218_1.info)
end

function BattleUI.displayBGEffect(arg_219_0, arg_219_1)
	arg_219_1 = arg_219_1 or {}
	
	local var_219_0 = CACHE:getEffect(arg_219_1.eff_name .. ".cfx")
	
	var_219_0:setAutoRemoveOnFinish(true)
	var_219_0:setTimeScale(arg_219_1.speed or 1)
	BGI.ui_layer:addChildLast(var_219_0)
	var_219_0:setPosition(DESIGN_WIDTH / 2 + (arg_219_1.offset_x or 0), DESIGN_HEIGHT / 2 + (arg_219_1.offset_y or 0))
	BattleUIAction:Append(SEQ(DELAY(arg_219_1.st_delay or 0), CALL(function()
		var_219_0:start()
	end)), var_219_0, "bg.effect")
end

function BattleUI.getArtifactIconAndColor(arg_221_0, arg_221_1)
	local var_221_0 = cc.c3b(255, 190, 255)
	local var_221_1
	local var_221_2 = arg_221_1:getEquipByPos("artifact")
	
	if var_221_2 then
		var_221_1 = DB("equip_item", var_221_2.code, "icon")
		
		if var_221_1 then
			var_221_1 = SpriteCache:getSprite("item_arti/" .. var_221_1 .. ".png")
			
			if not get_cocos_refid(var_221_1) then
				var_221_1 = SpriteCache:getSprite("item_arti/icon_art0001.png")
				
				balloon_message_with_sound("No icon resources")
			end
			
			var_221_1:setScale(0.25)
			var_221_1:setAnchorPoint(1.1, 0)
		end
	end
	
	return var_221_1, var_221_0
end

function BattleUI.initTextDisplayCount(arg_222_0, arg_222_1)
	arg_222_0.vars.unit_vars[arg_222_1:getUID()] = 0
end

function BattleUI.displayPassive(arg_223_0, arg_223_1, arg_223_2)
	local var_223_0
	local var_223_1
	
	if arg_223_1.state then
		local var_223_2 = tostring(arg_223_1.state.id)
		local var_223_3 = arg_223_1.target
		
		arg_223_2 = arg_223_2 or arg_223_1.state:getName()
		
		if not (string.len(arg_223_2 or "") > 0) then
			return 
		end
		
		if arg_223_1.state.db.cs_attribute == 9 then
			var_223_0, var_223_1 = arg_223_0:getArtifactIconAndColor(var_223_3)
		end
	end
	
	arg_223_0:displayText(arg_223_1.target, arg_223_2, nil, var_223_0, var_223_1)
end

function BattleUI.displayText(arg_224_0, arg_224_1, arg_224_2, arg_224_3, arg_224_4, arg_224_5)
	if not arg_224_2 or not arg_224_1 then
		return 
	end
	
	local var_224_0 = arg_224_1.model
	
	if not var_224_0 then
		return 
	end
	
	if not get_cocos_refid(var_224_0) then
		return 
	end
	
	if not arg_224_1.ui_vars.gauge or not arg_224_1.ui_vars.gauge:isValid() then
		return 
	end
	
	arg_224_2 = arg_224_2 or ""
	
	local var_224_1, var_224_2 = var_224_0:getPosition()
	local var_224_3
	
	arg_224_3 = arg_224_3 or 0
	arg_224_3 = arg_224_3 + to_n(arg_224_0.vars.unit_vars[arg_224_1:getUID()]) * 30
	arg_224_0.vars.unit_vars[arg_224_1:getUID()] = to_n(arg_224_0.vars.unit_vars[arg_224_1:getUID()]) + 1
	
	local var_224_4, var_224_5 = var_224_0:getBonePosition("top")
	local var_224_6
	local var_224_7 = 0
	
	if string.ends(arg_224_2, ".png") then
		var_224_6 = SpriteCache:getSprite(arg_224_2)
		
		var_224_6:setName("img")
		
		local var_224_8 = var_224_6:getContentSize()
	else
		var_224_6 = ccui.Text:create()
		
		var_224_6:setFontName("font/daum.ttf")
		
		if arg_224_5 then
			var_224_6:setColor(arg_224_5)
		else
			var_224_6:setColor(cc.c3b(235, 205, 130), cc.c3b(220, 190, 85))
		end
		
		var_224_6:enableOutline(cc.c4b(0, 0, 0), 1)
		var_224_6:setFontSize(24)
		var_224_6:setScale(1.25)
		var_224_6:setString(arg_224_2)
		var_224_6:setAnchorPoint(0.5, 0.5)
		var_224_6:setCascadeOpacityEnabled(true)
		var_224_6:setName("text")
		
		local var_224_9 = var_224_6:getContentSize()
	end
	
	var_224_6:setPosition(30, 130 + to_n(arg_224_3))
	arg_224_1.ui_vars.gauge:addChildToRoot(var_224_6)
	
	if get_cocos_refid(arg_224_4) then
		var_224_6:addChild(arg_224_4)
	end
	
	BattleUIAction:Add(SEQ(SPAWN(LOG(MOVE_BY(1300, -20 * WIDGET_SCALE_FACTOR, 20 * WIDGET_SCALE_FACTOR)), SEQ(DELAY(700), FADE_OUT(500))), REMOVE()), var_224_6, "battle")
	
	return var_224_6
end

function BattleUI.resetVars(arg_225_0)
	arg_225_0.damage_infos = {}
end

function BattleUI.displayDamage(arg_226_0, arg_226_1, arg_226_2)
	if arg_226_0.score_panel then
		arg_226_0.score_panel:scoreUpdate()
	end
	
	if arg_226_2.type ~= "attack" and arg_226_2.type ~= "heal" and arg_226_2.type ~= "exp" and arg_226_2.type ~= "sp_heal" then
		return 
	end
	
	if not arg_226_0.damage_infos then
		arg_226_0.damage_infos = {}
	end
	
	local var_226_0 = arg_226_0.damage_infos[arg_226_1] or {}
	
	arg_226_0.damage_infos[arg_226_1] = var_226_0
	
	if arg_226_2.damage then
		var_226_0.damage = to_n(var_226_0.damage) + arg_226_2.damage
		var_226_0.critical = var_226_0.critical or arg_226_2.critical
	elseif arg_226_2.heal then
		var_226_0.heal = to_n(var_226_0.heal) + arg_226_2.heal
		var_226_0.critical = nil
	end
	
	local var_226_1 = var_226_0.damage
	local var_226_2 = arg_226_2.sp_heal
	local var_226_3 = 0.6
	local var_226_4 = arg_226_1.model
	
	if var_226_4 == nil or not get_cocos_refid(var_226_4) then
		return 
	end
	
	if arg_226_2.heal then
		var_226_1 = "+" .. tostring(var_226_0.heal)
	end
	
	if arg_226_2.sp_heal then
		var_226_1 = "+" .. tostring(arg_226_2.sp_heal)
	end
	
	if arg_226_2.miss and arg_226_2.cur_hit == 1 then
		arg_226_0:displayText(arg_226_1, T("miss"))
	end
	
	if arg_226_2.half and arg_226_2.cur_hit == 1 then
		arg_226_0:displayText(arg_226_1, T("tank_protect"))
	end
	
	if arg_226_2.type == "exp" then
		var_226_1 = arg_226_2.exp .. " EXP"
	end
	
	if var_226_0.damage and arg_226_2.damage and arg_226_2.damage > 0 and not arg_226_2.miss then
		Combo:addCombo(var_226_0.damage, arg_226_2.cur_hit, arg_226_2.tot_hit, arg_226_2.critical)
	end
	
	if var_226_0.damage == 0 and not arg_226_2.heal then
		if arg_226_2.cur_hit == 1 then
			if arg_226_2.shield then
				arg_226_0:displayText(arg_226_1, T("absorb"))
			elseif arg_226_2.antiskilldamage then
				arg_226_0:displayText(arg_226_1, T("sk_antiskilldamage"))
			else
				arg_226_0:displayText(arg_226_1, T("sk_invincible"))
			end
		end
		
		return 
	end
	
	local var_226_5 = "dmg." .. tostring(arg_226_1)
	local var_226_6
	
	if arg_226_1.ui_vars.gauge then
		var_226_6 = arg_226_1.ui_vars.gauge:getChildFromRoot(var_226_5 .. arg_226_2.type)
	end
	
	if get_cocos_refid(var_226_6) then
		BattleUIAction:Remove(var_226_6)
		var_226_6:removeFromParent()
	end
	
	if not arg_226_0.last_damaged_time then
		arg_226_0.last_damaged_time = {}
	end
	
	if not arg_226_2.heal then
		arg_226_0.last_damaged_time[arg_226_1:getUID()] = os.time()
	end
	
	local var_226_7 = cc.Label:createWithBMFont("font/damage.fnt", var_226_1)
	
	var_226_7:setName(var_226_5 .. arg_226_2.type)
	
	local var_226_8 = 0
	
	if var_226_0.critical then
		var_226_7:setColor(COLOR_CRI_FONT[1], COLOR_CRI_FONT[2])
		
		var_226_3 = 1
	elseif arg_226_2.heal then
		local var_226_9 = arg_226_0.last_damaged_time[arg_226_1:getUID()] or 0
		
		if os.time() - var_226_9 < 1 then
			var_226_8 = 60
		end
		
		var_226_7:setColor(COLOR_HEAL_FONT[1], COLOR_HEAL_FONT[2])
	elseif arg_226_2.sp_heal then
		var_226_7:setColor(COLOR_SP_HEAL_FONT[1], COLOR_SP_HEAL_FONT[2])
	elseif arg_226_2.exp then
		var_226_7:setColor(COLOR_LEVELUP_FONT[1], COLOR_LEVELUP_FONT[2])
	else
		if arg_226_2.smite then
			var_226_3 = 1
		end
		
		var_226_7:setColor(COLOR_DAMAGE_FONT[1], COLOR_DAMAGE_FONT[2])
	end
	
	var_226_7:setPosition(0, 70 + var_226_8)
	var_226_7:setLocalZOrder(100001)
	
	if arg_226_1.ui_vars.gauge and arg_226_1.ui_vars.gauge:isValid() and not arg_226_1:isDead() and get_cocos_refid(arg_226_1.model) and arg_226_1.model:isVisible() then
		arg_226_1.ui_vars.gauge:addChildToRoot(var_226_7)
	else
		local var_226_10 = var_226_4:getParent()
		local var_226_11 = var_226_10:getChildByName(var_226_5 .. arg_226_2.type)
		
		if get_cocos_refid(var_226_11) then
			var_226_11:removeFromParent()
		end
		
		var_226_10:addChild(var_226_7)
		var_226_7:setPosition(var_226_4:getPositionX(), var_226_4:getPositionY() + 70 + var_226_8)
	end
	
	if var_226_0.critical then
		if var_226_0.damage then
			BattleUIAction:Add(SEQ(SHAKE_UI(200, 50), MOVE_TO(0, 0, 0)), BGI.game_layer, "battle")
		end
		
		BattleUIAction:Add(SPAWN(WAVESTRING(false), SEQ(LOG(SCALE(150, 2 * var_226_3 * WIDGET_SCALE_FACTOR, var_226_3 * WIDGET_SCALE_FACTOR)), SPAWN(SHAKE_UI(240), REPEAT(3, SEQ(COLOR(0, COLOR_CRI_HIGH_FONT), DELAY(40), COLOR(0, COLOR_CRI_FONT[1], COLOR_CRI_FONT[2]), DELAY(40)))), DELAY(360), FADE_OUT(200), REMOVE())), var_226_7, "battle")
	else
		var_226_7:setScale(var_226_3 * WIDGET_SCALE_FACTOR)
		
		if var_226_0.damage then
			BattleUIAction:Add(SEQ(SHAKE_UI(150, 30), MOVE_TO(0, 0, 0)), BGI.game_layer, "battle")
		end
		
		BattleUIAction:Add(SEQ(WAVESTRING(false), DELAY(500), FADE_OUT(300), REMOVE(200)), var_226_7, "battle")
	end
end

function BattleUI.onScoreUpdate(arg_227_0)
	if arg_227_0.score_panel then
		arg_227_0.score_panel:scoreUpdate()
	end
end

function BattleUI.displayExp(arg_228_0, arg_228_1, arg_228_2)
	local var_228_0 = arg_228_1.model
	
	if arg_228_1:isDead() or not var_228_0 or not get_cocos_refid(var_228_0) then
		return 
	end
	
	if arg_228_1.ui_vars.exp_gauge == nil or not get_cocos_refid(arg_228_1.ui_vars.exp_gauge.control) then
		arg_228_1.ui_vars.exp_gauge = EXPBar:create(arg_228_1)
	end
	
	if arg_228_0.logic:isRealtimeMode() or arg_228_0.logic:isViewerMode() then
		arg_228_0:updatePVPGauge()
	end
	
	arg_228_1.ui_vars.exp_gauge:Set(arg_228_1.ui_vars.exp_gauge.control, arg_228_2.from, arg_228_2.to, arg_228_2.exp, arg_228_2.levelup, nil, nil, nil, arg_228_2.dist_exp)
	
	if arg_228_2.levelup and arg_228_1.ui_vars.gauge then
		arg_228_0:displayLevelup(arg_228_1, arg_228_2)
		arg_228_1.ui_vars.gauge:set(true)
	end
end

function BattleUI.displayStateEffect(arg_229_0, arg_229_1)
end

function BattleUI.displayLevelup(arg_230_0, arg_230_1, arg_230_2)
	local var_230_0 = arg_230_1.model
	
	EffectManager:Play({
		extractNodes = true,
		pivot_x = 0,
		fn = "levelup.cfx",
		pivot_y = 0,
		pivot_z = 0,
		layer = var_230_0
	}):setScaleFactor(1)
	BattleUI:displayText(arg_230_1, "img/game_eff_exp_lvup.png")
	
	if not Action:Find("battle.lvup_curtain") then
		play_curtain(BGI.main.layer, 0, 200, 2400, 300, "battle.lvup_curtain", true, -102, 0.7, cc.c3b(0, 0, 0))
	end
	
	SoundEngine:play("event:/battle/levelup")
	arg_230_0:reserveLevelUpVoc(arg_230_1.db.model_id)
	
	if not BattleUIAction:Find("battle.lvup") then
		BattleUIAction:Add(SEQ(DELAY(1580), CALL(BattleUI.playLevelupVoc, arg_230_0)), BGI.game_layer, "battle.lvup")
	end
end

function BattleUI.playLevelupVoc(arg_231_0)
	if not arg_231_0.reserved_lvup or #arg_231_0.reserved_lvup < 1 then
		return 
	end
	
	local var_231_0 = table.shuffle(arg_231_0.reserved_lvup)[1]
	
	SoundEngine:play("event:/voc/character/" .. var_231_0 .. "/evt/lvup")
	print("BATTLEUI.PLAYLEVELUPVOC", #arg_231_0.reserved_lvup, var_231_0)
	
	arg_231_0.reserved_lvup = nil
end

function BattleUI.reserveLevelUpVoc(arg_232_0, arg_232_1)
	arg_232_0.reserved_lvup = arg_232_0.reserved_lvup or {}
	
	table.insert(arg_232_0.reserved_lvup, arg_232_1)
	print("BATTLEUI.RESERVELEVELUPVOC", #arg_232_0.reserved_lvup, arg_232_1)
end

function BattleUI.displayRoadEventObjectGuideUI(arg_233_0, arg_233_1, arg_233_2)
	local var_233_0 = arg_233_1.type
	local var_233_1 = string.starts(var_233_0 or "", "gate")
	local var_233_2 = string.ends(var_233_0 or "", "heal")
	local var_233_3 = cc.Node:create()
	
	var_233_3:setLocalZOrder(1)
	
	local var_233_4 = "game_hud_object_bg"
	local var_233_5 = {
		scale_y = 1,
		scale_x = 1,
		x = 0,
		y = 0
	}
	local var_233_6 = 0
	local var_233_7 = ""
	local var_233_8 = false
	local var_233_9 = false
	local var_233_10
	
	if var_233_2 then
		local var_233_11 = T("object_name_hp_heal")
		
		var_233_5.y = 800
		
		if var_233_0 == "soul_heal" then
			var_233_10 = "game_map_icon_soul"
		else
			var_233_10 = "game_map_icon_heal"
		end
	elseif var_233_0 == "gate_chaos" then
		var_233_5.y = 200
		var_233_10 = "game_map_icon_gate"
	elseif var_233_0 == "gate_cross" then
		var_233_5.y = 600
	elseif var_233_0 == "gate_portal" then
		var_233_5.y = 600
	elseif var_233_0 == "gate_treasure" then
		var_233_5.y = 600
		var_233_10 = "game_map_icon_goblin"
	elseif var_233_0 == "item_crystal" then
		local var_233_12 = T("battle_ui_crystal")
		
		var_233_5.y = 600
		var_233_10 = "game_map_icon_crystal"
	elseif string.starts(var_233_0 or "", "box") then
		local var_233_13 = T("object_name_box_normal")
		
		var_233_5.y = 300
		
		if var_233_0 == "box_normal_gold" then
			var_233_10 = "game_map_icon_gold"
		elseif var_233_0 == "box_rare" or var_233_0 == "box_rarefix" then
			var_233_10 = "game_map_icon_rare"
		else
			var_233_10 = "game_map_icon_box"
		end
	elseif var_233_0 == "switch" or var_233_0 == "switch_mel" then
		local var_233_14 = T("object_name_switch")
		
		var_233_5.y = 300
		
		if var_233_0 == "switch_mel" then
			var_233_5.x = 8
		end
		
		var_233_10 = "game_map_icon_switch_ready"
	elseif var_233_0 == "obstacle" then
		local var_233_15 = T("battle_ui_obstacle")
		
		var_233_5.y = 600
		var_233_10 = "game_map_icon_obstacle_ready"
	elseif var_233_0 == "npc" then
		var_233_4 = arg_233_0.logic:getRoadEventCountingValue(arg_233_1.event_id) > 0 and "main_hud_c_pub_p" or "main_hud_c_pub"
		var_233_8 = true
		
		local var_233_16 = math.normalize(arg_233_2:getScaleX(), 1)
		
		var_233_5.y = 280
		var_233_5.x = -140
		var_233_5.scale_x = 0.8 * var_233_16 * -1
		var_233_5.scale_y = 0.8
		
		local var_233_17 = (arg_233_2 or {}).info or {}
		
		if not var_233_17.story_id_after and not var_233_17.story_id_before then
			return 
		end
		
		var_233_9 = true
	elseif var_233_0 == "npc_shop" then
		var_233_5.y = 330
		var_233_10 = "game_map_icon_npc_shop"
	elseif var_233_0 == "warp" then
		var_233_5.y = 600
		var_233_5.scale_x = 1.8
		var_233_5.scale_y = 1.1
		var_233_10 = "game_map_icon_portal"
	elseif var_233_0 == "clear" then
		var_233_5.scale_x = 1.8
		var_233_5.scale_y = 1.1
		var_233_5.y = 600
		var_233_10 = "game_map_icon_clear"
	else
		return 
	end
	
	local var_233_18 = cc.Sprite:create("img/" .. var_233_4 .. ".png")
	
	var_233_18:setAnchorPoint(0.5, 0)
	
	if not var_233_8 then
		local var_233_19 = var_233_0
		
		if string.starts(var_233_19 or "", "box_rare") then
			var_233_19 = "box_rare"
		end
		
		local var_233_20 = T("object_name_" .. var_233_19)
		
		if arg_233_1.name_tag then
			var_233_20 = T(arg_233_1.name_tag)
		end
		
		local var_233_21 = ccui.Text:create()
		
		var_233_21:setFontName("font/daum.ttf")
		var_233_21:setColor(cc.c3b(255, 220, 78))
		var_233_21:enableOutline(cc.c3b(0, 69, 155), 1)
		var_233_21:setFontSize(24)
		var_233_21:setScale(0.75)
		var_233_21:setString(var_233_20)
		var_233_21:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		var_233_21:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		var_233_21:setLocalZOrder(100000)
		var_233_21:setName("nametag")
		var_233_18:addChild(var_233_21)
		var_233_21:setPosition(var_233_18:getContentSize().width / 2 - 3, var_233_18:getContentSize().height / 2 - 6)
	end
	
	if var_233_10 then
		local var_233_22 = cc.Sprite:create("img/" .. var_233_10 .. ".png")
		
		var_233_22:setPosition(var_233_18:getContentSize().width / 2 - 3, var_233_18:getContentSize().height * 0.9)
		var_233_18:addChild(var_233_22)
	end
	
	if var_233_9 then
		local var_233_23 = ccui.Button:create()
		
		var_233_23:setTouchEnabled(true)
		var_233_23:ignoreContentAdaptWithSize(false)
		var_233_23:setContentSize(var_233_18:getContentSize().width, var_233_18:getContentSize().height)
		var_233_23:setAnchorPoint(0, 0)
		var_233_23:addTouchEventListener(function(arg_234_0, arg_234_1)
			if arg_234_1 ~= 2 then
				return 
			end
			
			Battle:procTouchFieldModel(arg_233_2)
		end)
		var_233_18:addChild(var_233_23)
	end
	
	var_233_3:addChild(var_233_18)
	var_233_3:setName("guide_ui")
	var_233_3:setScaleX(2 * var_233_5.scale_x)
	var_233_3:setScaleY(2 * var_233_5.scale_y)
	
	var_233_3.offsetX = var_233_5.x or 0
	var_233_3.offsetY = var_233_5.y or 0
	
	var_233_3:setPosition(var_233_3.offsetX, var_233_3.offsetY)
	
	function var_233_3.update_pos(arg_235_0, arg_235_1)
		if arg_235_1 and arg_235_1.model then
			if arg_235_0.isVisible and not arg_235_0:isVisible() then
				arg_235_0:setVisible(true)
			end
			
			local var_235_0, var_235_1 = arg_235_1.model:getPosition()
			
			arg_235_0:setPosition(var_235_0 + arg_235_0.offsetX, var_235_1 + arg_235_0.offsetY)
		end
	end
	
	function var_233_3.remove_ui(arg_236_0)
		BattleUIAction:Remove(arg_236_0)
		BattleUIAction:Add(SEQ(SHOW(false), REMOVE()), arg_236_0)
	end
	
	BattleUIAction:Add(SEQ(SHOW(true), LOOP(SEQ(RLOG(MOVE_BY(800, 0, -15), 15), LOG(MOVE_BY(800, 0, 15), 15)))), var_233_18, var_233_3)
	
	if get_cocos_refid(var_233_3) and get_cocos_refid(arg_233_2) then
		local var_233_24 = math.normalize(arg_233_2:getScaleX(), 1)
		
		var_233_3:setScaleX(var_233_3:getScaleX() * var_233_24)
		
		local var_233_25 = arg_233_2:getChildByName("guide_ui")
		
		if get_cocos_refid(var_233_25) then
			BattleUIAction:Remove(var_233_25)
			var_233_25:removeFromParent()
		end
		
		arg_233_2:addChild(var_233_3)
	end
	
	return var_233_3
end

function BattleUI.update(arg_237_0)
	for iter_237_0, iter_237_1 in pairs(arg_237_0.logic.friends) do
		if iter_237_1:getSPName() == "mp" then
			arg_237_0:onUpdateGauge(iter_237_1)
		end
	end
	
	for iter_237_2, iter_237_3 in pairs(arg_237_0.logic.units) do
		if get_cocos_refid(iter_237_3.model) then
			if iter_237_3.ui_vars.gauge then
				iter_237_3.ui_vars.gauge:update(true)
			end
			
			if iter_237_3.ui_vars.condition_bar then
				iter_237_3.ui_vars.condition_bar:update()
			end
		end
		
		if iter_237_3.ui_vars.element_mark then
			iter_237_3.ui_vars.element_mark:updatePos()
		end
		
		if get_cocos_refid(iter_237_3.ui_vars.timeline_face) then
			if_set_percent(iter_237_3.ui_vars.timeline_face, "partyhp_progressbar", iter_237_3:getHPRatio())
		end
	end
	
	if not arg_237_0.logic:isRealtimeMode() and not arg_237_0.logic:isViewerMode() then
		arg_237_0:updatePVPGauge()
		UIBattleAttackOrder:setTurnInfo()
	end
	
	if Battle:isReplayMode() then
		arg_237_0.replay_controller:update()
	end
end

function BattleUI.updatePVPGauge(arg_238_0, arg_238_1, arg_238_2)
	if not arg_238_0.pvp_gauge_wnd or not get_cocos_refid(arg_238_0.pvp_gauge_wnd) then
		return 
	end
	
	local var_238_0 = arg_238_0.logic:getStageCounter()
	
	arg_238_0.prev_stage_counter = arg_238_0.prev_stage_counter or var_238_0
	
	local var_238_1 = 100 - var_238_0
	
	if var_238_1 <= 10 and arg_238_0.prev_stage_counter ~= var_238_0 then
		arg_238_0.prev_stage_counter = var_238_0
		
		if var_238_1 < 0 then
			var_238_1 = 0
		end
		
		if_set(arg_238_0.pvp_gauge_wnd:getChildByName("n_turn"), "txt_turn", var_238_1)
		if_set_visible(arg_238_0.pvp_gauge_wnd, "n_turn", true)
	end
	
	if arg_238_1 then
		return 
	end
	
	local var_238_2 = arg_238_0.logic:getHPRatio(FRIEND)
	
	arg_238_0.prev_f_hp_ratio = arg_238_0.prev_f_hp_ratio or var_238_2
	
	if arg_238_2 or arg_238_0.prev_f_hp_ratio ~= var_238_2 then
		arg_238_0:setPVPGauge(arg_238_0.pvp_gauge_wnd:getChildByName("n_gauge_left"), arg_238_0.prev_f_hp_ratio, var_238_2, arg_238_2)
		
		arg_238_0.prev_f_hp_ratio = var_238_2
	end
	
	local var_238_3 = arg_238_0.logic:getHPRatio(ENEMY)
	
	arg_238_0.prev_e_hp_ratio = arg_238_0.prev_e_hp_ratio or var_238_3
	
	if arg_238_2 or arg_238_0.prev_e_hp_ratio ~= var_238_3 then
		arg_238_0:setPVPGauge(arg_238_0.pvp_gauge_wnd:getChildByName("n_gauge_right"), arg_238_0.prev_e_hp_ratio, var_238_3, arg_238_2)
		
		arg_238_0.prev_e_hp_ratio = var_238_3
	end
end

function BattleUI.setPVPGauge(arg_239_0, arg_239_1, arg_239_2, arg_239_3, arg_239_4)
	local var_239_0 = 30
	local var_239_1 = 800
	local var_239_2 = arg_239_3
	local var_239_3 = arg_239_1:getChildByName("hp")
	local var_239_4 = arg_239_1:getChildByName("hp_red")
	local var_239_5 = var_239_3:getScaleX()
	local var_239_6 = var_239_4:getScaleX()
	
	if arg_239_4 then
		BattleUIAction:Remove(var_239_4)
		BattleUIAction:Remove(var_239_3)
		var_239_3:setScaleX(var_239_2)
		var_239_4:setScaleX(var_239_2)
	elseif arg_239_3 < arg_239_2 then
		if not BattleUIAction:Find(var_239_4) then
			var_239_4:setScaleX(var_239_5)
		end
		
		var_239_4:setVisible(true)
		BattleUIAction:Remove(var_239_4)
		BattleUIAction:Remove(var_239_3)
		BattleUIAction:Add(SPAWN(REPEAT(3, SEQ(COLOR(0, 255, 255, 155), DELAY(var_239_0), COLOR(0, 255, 0, 0), DELAY(var_239_0))), SEQ(DELAY(600), SCALEX(var_239_1, var_239_6, var_239_2))), var_239_4, "battle")
		var_239_3:setScaleX(var_239_2)
	elseif arg_239_2 < arg_239_3 then
		BattleUIAction:Add(LOG(SCALEX(var_239_1, var_239_5, var_239_2)), var_239_3, "battle")
	else
		var_239_3:setScaleX(var_239_2)
		var_239_4:setVisible(false)
	end
end

function BattleUI.showTimelineAutoTarget(arg_240_0, arg_240_1)
end

function BattleUI.hideTimelineAutoTarget(arg_241_0, arg_241_1)
end

function BattleUI.updateAutoMode(arg_242_0, arg_242_1)
	arg_242_0.auto_panel:updateAutoMode(arg_242_1)
end

function BattleUI.updateUnitFaces(arg_243_0)
	arg_243_0.auto_panel:update()
end

function BattleUI.setStageMode(arg_244_0, arg_244_1)
	BattleTopBar:onUpdateStageMode(arg_244_1)
end

function BattleUI.hideArenaTimer(arg_245_0)
	if not get_cocos_refid(arg_245_0.pvp_gauge_wnd) then
		return 
	end
	
	arg_245_0.pvp_gauge_wnd:getChildByName("n_turn"):setVisible(false)
end

function BattleUI.updateArenaTimer(arg_246_0, arg_246_1)
	if not get_cocos_refid(arg_246_0.pvp_gauge_wnd) then
		return 
	end
	
	if not arg_246_1 then
		return 
	end
	
	local var_246_0 = arg_246_1.time[arg_246_1.owner].total
	local var_246_1 = arg_246_1.time[arg_246_1.owner].rest
	local var_246_2 = arg_246_0.logic:getTurnOwner()
	local var_246_3 = arg_246_0.pvp_gauge_wnd:getChildByName("n_turn")
	
	var_246_3:setVisible(false)
	
	if Battle:isPlayingBattleAction() then
		return 
	end
	
	if not var_246_1 or var_246_1 < 1 or var_246_0 < var_246_1 then
		return 
	end
	
	if not var_246_2 then
		return 
	end
	
	UIBattleActWait:hideActWaitPopup()
	var_246_3:setVisible(true)
	if_set_visible(var_246_3, "progress_bar_my", false)
	if_set_visible(var_246_3, "progress_bar_enemy", false)
	
	if Battle.viewer:isSpectator() then
		local var_246_4 = Battle.viewer:getMatchInfo()
		
		if_set(var_246_3, "t_my_turn", T("guide_idle_head", {
			name = check_abuse_filter(var_246_4.user_info.name, ABUSE_FILTER.WORLD_NAME) or var_246_4.user_info.name
		}))
		if_set(var_246_3, "t_enemy_turn", T("guide_idle_head", {
			name = check_abuse_filter(var_246_4.enemy_user_info.name, ABUSE_FILTER.WORLD_NAME) or var_246_4.enemy_user_info.name
		}))
	end
	
	if var_246_2:getAlly() == FRIEND then
		if_set_visible(var_246_3, "t_my_turn", true)
		if_set_visible(var_246_3, "t_enemy_turn", false)
		arg_246_0.timer_progress_bars[FRIEND]:setVisible(true)
		arg_246_0.timer_progress_bars[ENEMY]:setVisible(false)
	else
		if_set_visible(var_246_3, "t_my_turn", false)
		if_set_visible(var_246_3, "t_enemy_turn", true)
		arg_246_0.timer_progress_bars[FRIEND]:setVisible(false)
		arg_246_0.timer_progress_bars[ENEMY]:setVisible(true)
	end
	
	local var_246_5 = cc.Label:createWithBMFont("font/score.fnt", math.clamp(var_246_1, 1, var_246_0))
	
	var_246_5:setName("arena_timer")
	var_246_5:setAnchorPoint(0.5, 0.5)
	var_246_5:setScale(1)
	
	local var_246_6 = var_246_3:getChildByName("n_countdown")
	
	var_246_6:removeChildByName("arena_timer")
	var_246_6:addChild(var_246_5)
	arg_246_0.timer_progress_bars[var_246_2:getAlly()]:setPercentage(math.clamp(100 * var_246_1 / var_246_0, 0, 100))
end

function BattleUI.updatePingInfo(arg_247_0, arg_247_1)
	if not arg_247_1 then
		return 
	end
	
	if not get_cocos_refid(arg_247_0.pvp_gauge_wnd) then
		return 
	end
	
	for iter_247_0, iter_247_1 in pairs(arg_247_1) do
		local var_247_0 = Battle.viewer:getMatchInfo()
		local var_247_1, var_247_3
		
		if iter_247_1.ping and var_247_0 then
			var_247_1 = getNetCondition(tonumber(iter_247_1.ping))
			
			local var_247_2
			
			if iter_247_0 == var_247_0.user_info.uid then
				var_247_2 = arg_247_0.pvp_gauge_wnd:getChildByName("n_gauge_left")
			elseif iter_247_0 == var_247_0.enemy_user_info.uid then
				var_247_2 = arg_247_0.pvp_gauge_wnd:getChildByName("n_gauge_right")
			else
				return 
			end
			
			var_247_3 = var_247_2:getChildByName("n_ping")
			
			if var_247_3 then
				for iter_247_2 = 1, 3 do
					var_247_3:getChildByName(tostring(iter_247_2)):setVisible(var_247_1 == iter_247_2)
				end
			end
		end
	end
end

UIBattleActWait = {}

function UIBattleActWait.hideActWaitPopup(arg_248_0)
	if not arg_248_0.vars then
		return 
	end
	
	if getenv("app.viewer") == "true" then
		return 
	end
	
	UIAction:Remove("act.wait.bg")
	BattleField:removeUIControlByName("act.wait.ctrl")
	
	arg_248_0.vars = nil
end

function UIBattleActWait.showActWaitPopup(arg_249_0)
	if UIAction:Find("act.wait.bg") then
		return 
	end
	
	if getenv("app.viewer") == "true" then
		return 
	end
	
	arg_249_0.vars = {}
	arg_249_0.vars.wnd = load_dlg("caution_flash_2", true, "wnd")
	
	arg_249_0.vars.wnd:setName("act.wait.ctrl")
	
	local var_249_0 = arg_249_0.vars.wnd:getChildByName("bg")
	
	var_249_0:setVisible(false)
	var_249_0:setOpacity(0)
	
	local var_249_1 = arg_249_0.vars.wnd:getChildByName("txt")
	
	var_249_1:setVisible(false)
	var_249_1:setOpacity(0)
	UIAction:Add(SEQ(DELAY(2000), FADE_IN(650)), var_249_1, "act.wait.text")
	UIAction:Add(SEQ(DELAY(2000), LOOP(SEQ(FADE_IN(650), DELAY(200), FADE_OUT(650)))), var_249_0, "act.wait.bg")
	BattleField:addUIControl(arg_249_0.vars.wnd)
end

UIBattleGuideArrow = {}

function UIBattleGuideArrow.show(arg_250_0, arg_250_1)
	if get_cocos_refid(arg_250_0.arrow_effect) then
		return 
	end
	
	arg_250_0:remove()
	
	if not get_cocos_refid(BGI.ui_layer) then
		return 
	end
	
	local var_250_0 = BGI.ui_layer:getChildByName("game_hud_go")
	
	if not var_250_0 then
		var_250_0 = Dialog:open("wnd/game_hud_go", arg_250_0, {
			use_backbutton = false
		})
		
		BattleField:addUIControl(var_250_0)
	end
	
	local var_250_1 = BattleMapManager:getControl()
	
	if get_cocos_refid(var_250_1) then
		var_250_0:setLocalZOrder(var_250_1:getLocalZOrder() - 1)
	end
	
	local var_250_2 = arg_250_1 == "up" or arg_250_1 == "left"
	local var_250_3
	
	if not var_250_2 then
		var_250_3 = "n_right"
		
		var_250_0:getChildByName("n_left"):setVisible(false)
		var_250_0:getChildByName("n_right"):setVisible(true)
		var_250_0:getChildByName("n_right"):getChildByName("arrow"):setVisible(false)
	else
		var_250_3 = "n_left"
		
		var_250_0:getChildByName("n_right"):setVisible(false)
		var_250_0:getChildByName("n_left"):setVisible(true)
		var_250_0:getChildByName("n_left"):getChildByName("arrow"):setVisible(false)
	end
	
	arg_250_0.target = var_250_3
	
	var_250_0:getChildByName(var_250_3):setOpacity(0)
	
	arg_250_0.arrow_effect = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_game_hud_go.cfx",
		pivot_y = -50,
		pivot_z = 99998,
		layer = var_250_0:getChildByName(var_250_3),
		flip_x = var_250_2
	})
	
	local var_250_4 = 200
	
	BattleUIAction:Add(SPAWN(TARGET(var_250_0:getChildByName(var_250_3), OPACITY(var_250_4, 0, 1))), var_250_0, "battle.guide_arrow")
end

function UIBattleGuideArrow.remove(arg_251_0)
	if get_cocos_refid(arg_251_0.arrow_effect) then
		arg_251_0.arrow_effect:removeFromParent()
	end
	
	BattleField:removeUIControlByName("game_hud_go")
	BattleUIAction:Remove("battle.guide_arrow")
end

function UIBattleGuideArrow.hide(arg_252_0)
	if not get_cocos_refid(BGI.ui_layer) then
		return 
	end
	
	local var_252_0 = BGI.ui_layer:getChildByName("game_hud_go")
	
	if not var_252_0 then
		return 
	end
	
	local var_252_1 = 200
	
	BattleUIAction:Add(SPAWN(TARGET(var_252_0:getChildByName(arg_252_0.target), SEQ(OPACITY(var_252_1, 1, 0), CALL(function()
		UIBattleGuideArrow:remove()
	end)))), BGI.ui_layer, "battle.guide_arrow_remove")
end

UIBattleElementMark = {}

function UIBattleElementMark.create(arg_254_0, arg_254_1, arg_254_2)
	local var_254_0 = {
		owner = arg_254_1
	}
	
	copy_functions(UIBattleElementMark, var_254_0)
	var_254_0:createControl(arg_254_2)
	
	return var_254_0
end

function UIBattleElementMark.createControl(arg_255_0, arg_255_1)
	if get_cocos_refid(arg_255_0.control) then
		arg_255_0:remove()
	end
	
	if arg_255_1 then
		arg_255_0.control = cc.Sprite:create("img/" .. arg_255_1 .. ".png")
	end
	
	return arg_255_0
end

function UIBattleElementMark.updatePos(arg_256_0)
	if not arg_256_0.owner or not get_cocos_refid(arg_256_0.owner.model) then
		arg_256_0:remove()
		
		return 
	end
	
	if not get_cocos_refid(arg_256_0.control) then
		return 
	end
	
	local var_256_0 = arg_256_0.owner.model:getBoneNode("root"):getPositionY()
	local var_256_1 = SceneManager:convertToSceneSpace(arg_256_0.owner.model, {
		x = 0,
		y = var_256_0
	})
	
	arg_256_0.control:setPosition(math.floor(var_256_1.x), math.floor(var_256_1.y))
end

function UIBattleElementMark.getControl(arg_257_0)
	return arg_257_0.control
end

function UIBattleElementMark.remove(arg_258_0)
	if not get_cocos_refid(arg_258_0.control) then
		return 
	end
	
	arg_258_0.control:removeFromParent()
end
