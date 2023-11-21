BONUS_ON_SPHERE_UPGRADE = true

local var_0_0 = {
	wind = "green",
	fire = "red",
	light = "yellow",
	dark = "purple",
	ice = "blue"
}

UnitZodiacBase = {}

function UnitZodiacBase.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1 or {}
	
	arg_1_0.vars = {}
	arg_1_0.vars.enable = arg_1_0:createBaseLayer(var_1_0)
	
	arg_1_0:hide()
end

function UnitZodiacBase.onEnter(arg_2_0)
end

function UnitZodiacBase.onLeave(arg_3_0)
	arg_3_0.vars = nil
end

function UnitZodiacBase.onAfterUpdate(arg_4_0)
	if arg_4_0.vars and get_cocos_refid(arg_4_0.vars.layer) then
		local var_4_0 = math.sin(uitick() / 2861 * 3.141592 / 2)
		local var_4_1 = math.sin(uitick() / 2179 * 3.141592 / 2)
		
		arg_4_0.vars.layer:setScaleX((var_4_1 + 1) / 2 * 0.03 + 1)
		arg_4_0.vars.layer:setScaleY((var_4_0 + 1) / 2 * 0.03 + 1)
	end
end

function UnitZodiacBase.isEnabled(arg_5_0)
	return arg_5_0.vars.enable
end

function UnitZodiacBase.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
end

function UnitZodiacBase.createBaseLayer(arg_7_0, arg_7_1)
end

function UnitZodiacBase.regCursor(arg_8_0, arg_8_1)
end

function UnitZodiacBase.focusIn(arg_9_0)
end

function UnitZodiacBase.focusOut(arg_10_0)
end

function UnitZodiacBase.updateComponents(arg_11_0)
end

function UnitZodiacBase.updateInterfaces(arg_12_0, arg_12_1)
end

function UnitZodiacBase.onModeEnter(arg_13_0)
end

function UnitZodiacBase.onModeLeave(arg_14_0)
end

function UnitZodiacBase.hide(arg_15_0)
end

function UnitZodiacBase.updateSidePanel(arg_16_0, arg_16_1, arg_16_2)
end

function UnitZodiacBase.reqEnhance(arg_17_0, arg_17_1)
end

function UnitZodiacBase.respEnhance(arg_18_0, arg_18_1)
end

function UnitZodiacBase.onPushMaterial(arg_19_0, arg_19_1)
	if UIAction:Find("block") then
		return 
	end
	
	if not TutorialGuide:isAllowEvent(arg_19_0) then
		return 
	end
	
	if arg_19_1 == 2 then
		UnitZodiac:focusIn(arg_19_0:getName())
	end
end

function UnitZodiacBase.displayUpgradeReward(arg_20_0, arg_20_1)
end

function UnitZodiacBase.resetSidePanel(arg_21_0, arg_21_1)
	for iter_21_0, iter_21_1 in pairs({
		"n_res1/1",
		"n_res1/2",
		"n_res2/2",
		"n_res1/3",
		"n_res2/3",
		"n_res3/3"
	}) do
		local var_21_0 = arg_21_1:getChildByName(iter_21_1)
		
		if get_cocos_refid(var_21_0) then
			var_21_0:removeAllChildren()
		end
	end
end

function UnitZodiacBase.getNeedItemList(arg_22_0)
	return {}
end

function UnitZodiacBase.getColor(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or UnitZodiac:getUnit()
	
	return arg_23_1 and var_0_0[arg_23_1.db.color]
end

function UnitZodiacBase.getStoneNode(arg_24_0, arg_24_1)
	if arg_24_0.vars and arg_24_0.vars.stones then
		return arg_24_0.vars.stones[arg_24_1]
	end
end

function UnitZodiacBase.getHelpID(arg_25_0)
	return "growth_2_1"
end

UnitZodiacStone = {}

copy_functions(UnitZodiacBase, UnitZodiacStone)

function UnitZodiacStone.hide(arg_26_0)
	if arg_26_0.vars and get_cocos_refid(arg_26_0.vars.stone_layer) then
		arg_26_0.vars.stone_layer:setVisible(false)
	end
end

function UnitZodiacStone.onEnter(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.stone_layer) then
		return 
	end
	
	arg_27_0.vars.stone_layer:setVisible(false)
	arg_27_0.vars.stone_layer:setScale(0)
	arg_27_0.vars.stone_layer:setOpacity(0)
	UIAction:Add(SEQ(SHOW(true), SPAWN(TARGET(arg_27_0.vars.wnd, OPACITY(200, 0, 1)), SCALE(200, 0, 1))), arg_27_0.vars.stone_layer, "block")
end

function UnitZodiacStone.onLeave(arg_28_0)
	UIAction:Add(SPAWN(SCALE(250, 1, 0)), arg_28_0.vars.stone_layer, "block")
	
	arg_28_0.vars = nil
end

function UnitZodiacStone.onModeEnter(arg_29_0, arg_29_1)
	local var_29_0 = 2
	
	if arg_29_1 == "Potential" then
		var_29_0 = 0
		
		UnitZodiac:addStars()
	end
	
	UIAction:Add(SEQ(SHOW(true), SPAWN(TARGET(arg_29_0.vars.wnd, OPACITY(200, 0, 1)), SCALE(200, var_29_0, 1))), arg_29_0.vars.stone_layer, "block")
	
	if EpisodeAdin:isAdinCode(UnitZodiac:getUnit().db.code) then
		local var_29_1 = UnitZodiac.vars.wnd:getChildByName("n_item_mix2")
		
		if_set_opacity(var_29_1, "btn_catalyst", 255)
		if_set_opacity(var_29_1, "btn_item_mix", 255)
	end
end

function UnitZodiacStone.onModeLeave(arg_30_0, arg_30_1)
	local var_30_0 = 2
	local var_30_1 = 200
	
	if arg_30_1 == "Potential" then
		var_30_0 = 0
	end
	
	UIAction:Add(SEQ(SPAWN(TARGET(arg_30_0.vars.wnd, OPACITY(var_30_1, 1, 0)), SCALE(var_30_1, 1, var_30_0)), SHOW(false)), arg_30_0.vars.stone_layer, "block")
end

function UnitZodiacStone.createBaseLayer(arg_31_0, arg_31_1)
	local var_31_0 = (arg_31_1 or {}).parent
	local var_31_1, var_31_2 = DB("zodiac_sphere_2", UnitZodiac:getSphereName(), {
		"wnd",
		"name"
	})
	
	arg_31_0.vars.layer = cc.Layer:create()
	arg_31_0.vars.stone_layer = cc.Layer:create()
	
	arg_31_0.vars.layer:addChild(arg_31_0.vars.stone_layer)
	arg_31_0.vars.stone_layer:ignoreAnchorPointForPosition(false)
	arg_31_0.vars.stone_layer:setAnchorPoint(0.5, 0.5)
	arg_31_0.vars.stone_layer:setPosition(0, 0)
	
	if get_cocos_refid(var_31_0) then
		var_31_0:addChild(arg_31_0.vars.layer)
	end
	
	UnitZodiac:push_BGLayer({
		arg_31_0.vars.stone_layer,
		0.5,
		2
	})
	
	arg_31_0.vars.wnd = load_dlg(var_31_1, true, "zodiac2")
	
	arg_31_0.vars.wnd:setLocalZOrder(1)
	arg_31_0.vars.wnd:setAnchorPoint(0.5, 0.5)
	arg_31_0.vars.wnd:setPosition(var_31_0:getPosition())
	arg_31_0.vars.stone_layer:addChild(arg_31_0.vars.wnd)
	
	arg_31_0.vars.nodes = {}
	arg_31_0.vars.stones = {}
	arg_31_0.vars.effs = {}
	arg_31_0.vars.lines = {}
	arg_31_0.vars.grades = {}
	
	local var_31_3 = 0
	
	for iter_31_0 = 1, 12 do
		local var_31_4 = true
		local var_31_5 = arg_31_0.vars.wnd:getChildByName(iter_31_0)
		
		if not var_31_5 then
			var_31_4 = false
			var_31_5 = arg_31_0.vars.wnd:getChildByName(iter_31_0 .. "_")
		end
		
		if not var_31_5 then
			break
		end
		
		arg_31_0.vars.grades[iter_31_0] = var_31_3
		
		if not var_31_4 then
			var_31_3 = var_31_3 + 1
			arg_31_0.vars.nodes[iter_31_0] = arg_31_0:createStoneNode(var_31_3)
			arg_31_0.vars.stones[var_31_3] = arg_31_0.vars.nodes[iter_31_0]
			
			arg_31_0:addEmptyButton(var_31_5, tostring(var_31_3), 80, 80)
		else
			local var_31_6 = CACHE:getEffect("zstone_small")
			
			var_31_6:setAnimation(0, "loop", true)
			var_31_6:setScale(0.8)
			
			arg_31_0.vars.nodes[iter_31_0] = var_31_6
		end
		
		arg_31_0.vars.nodes[iter_31_0]:setPosition(var_31_5:getPosition())
		arg_31_0.vars.wnd:addChild(arg_31_0.vars.nodes[iter_31_0])
		
		arg_31_0.vars.lines[iter_31_0] = {
			arg_31_0:addLine(arg_31_0.vars.wnd:getChildByName("l_" .. iter_31_0)),
			arg_31_0:addLine(arg_31_0.vars.wnd:getChildByName("l_" .. iter_31_0 .. "_0")),
			arg_31_0:addLine(arg_31_0.vars.wnd:getChildByName("l_" .. iter_31_0 .. "_0_0"))
		}
	end
	
	arg_31_0.vars.reward_icons = {}
	arg_31_0.vars.reward_skills = {}
	arg_31_0.vars.flag = nil
	
	if not UnitZodiac:isDictMode() then
		local var_31_7 = UnitZodiac:getFlagCtrl()
		
		if get_cocos_refid(var_31_7) then
			var_31_7:removeFromParent()
			var_31_7:setLocalZOrder(1)
			arg_31_0.vars.stone_layer:addChild(var_31_7)
			
			arg_31_0.vars.flag = var_31_7
			
			UIAction:Add(LOOP(SEQ(LOG(MOVE_TO(250, 0, 30)), DELAY(150), RLOG(MOVE_TO(250, 0, 0)))), var_31_7:getChildByName("cursor"), "blink")
		end
	end
	
	return true
end

function UnitZodiacStone.regCursor(arg_32_0, arg_32_1)
	if get_cocos_refid(arg_32_1) then
		arg_32_1:setVisible(false)
		arg_32_1:removeFromParent()
		arg_32_1:setLocalZOrder(2)
		arg_32_0.vars.stone_layer:addChild(arg_32_1)
		
		arg_32_0.vars.cursor = arg_32_1
	end
end

function UnitZodiacStone.getSkillBonusIdx(arg_33_0, arg_33_1)
	return DB("zodiac_stone_2", arg_33_0:getStoneID(arg_33_1), "skill_up")
end

function UnitZodiacStone.getStoneID(arg_34_0, arg_34_1)
	return string.format("%s_%d", UnitZodiac:getUnit().db.sphere_bonus_id, arg_34_1)
end

function UnitZodiacStone.createStoneNode(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_2 = arg_35_2 or cc.CSLoader:createNode("wnd/zodiac_stone.csb")
	arg_35_1 = arg_35_1 or arg_35_2.idx
	arg_35_2.guide_tag = tostring(arg_35_1)
	
	local var_35_0
	local var_35_1 = UnitZodiac:getUnit()
	local var_35_2 = arg_35_0:getSkillBonusIdx(arg_35_1)
	
	if var_35_2 then
		var_35_0 = CACHE:getEffect("zstone_skill")
		
		if not arg_35_3 then
			local var_35_3 = UIUtil:getSkillIcon(var_35_1, UIUtil:getSkillByUIIdx(var_35_1, var_35_2), {
				no_tooltip = true
			})
			
			var_35_3:setScale(0.5)
			arg_35_2:getChildByName("n_skill"):addChild(var_35_3)
		end
	else
		var_35_0 = CACHE:getEffect("zstone_" .. arg_35_0:getColor(var_35_1) .. "_big")
	end
	
	var_35_0:setAnimation(0, "loop", true)
	var_35_0:setScale(1)
	arg_35_2:getChildByName("n_stone"):addChild(var_35_0)
	
	arg_35_2.idx = arg_35_1
	arg_35_2.stone = var_35_0
	
	return arg_35_2
end

function UnitZodiacStone.addEmptyButton(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
	local var_36_0 = ccui.Button:create()
	
	var_36_0:setTouchEnabled(true)
	var_36_0:ignoreContentAdaptWithSize(false)
	var_36_0:setContentSize(arg_36_3, arg_36_4)
	var_36_0:setPosition(arg_36_1:getPosition())
	var_36_0:setName(arg_36_2)
	var_36_0:addTouchEventListener(arg_36_0.onPushMaterial)
	arg_36_0.vars.wnd:addChild(var_36_0)
end

function UnitZodiacStone.addLine(arg_37_0, arg_37_1)
	if arg_37_1 then
		local var_37_0 = SpriteCache:getSprite("img/cm_select_lineon.png")
		
		var_37_0:setPosition(0, 0)
		var_37_0:setAnchorPoint(0, 0)
		var_37_0:setVisible(false)
		arg_37_1:addChild(var_37_0)
		
		return var_37_0
	end
end

function UnitZodiacStone.onTouchDown(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_1:getLocation()
	
	if arg_38_3 then
	else
		for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.reward_icons) do
			if checkCollision(iter_38_1, var_38_0.x, var_38_0.y) and not string.starts(arg_38_0.vars.reward_skills[iter_38_0], "keyslot") then
				return 
			end
		end
	end
	
	return true
end

function UnitZodiacStone.focusIn(arg_39_0, arg_39_1)
	arg_39_1 = tonumber(arg_39_1) or math.min(6, UnitZodiac:getSphereGrade() + 1)
	
	if not arg_39_0.vars.stones[arg_39_1] then
		return 
	end
	
	local var_39_0, var_39_1 = arg_39_0.vars.stones[arg_39_1]:getPosition()
	local var_39_2 = 60
	
	if arg_39_0:getSkillBonusIdx(arg_39_1) then
		var_39_2 = 200
	end
	
	UnitZodiac:updateSidePanel(arg_39_1)
	UnitZodiac:setZoomIndex(arg_39_1)
	UnitZodiac:zoominMaterial(var_39_0 + var_39_2, var_39_1)
	arg_39_0:hideFlag()
	
	if get_cocos_refid(arg_39_0.vars.cursor) then
		arg_39_0.vars.cursor:setVisible(false)
		arg_39_0.vars.cursor:setOpacity(0)
		
		local var_39_3, var_39_4 = arg_39_0.vars.stones[arg_39_1]:getPosition()
		local var_39_5, var_39_6 = UnitZodiac:getOffsetPos()
		
		arg_39_0.vars.cursor:setPosition(var_39_3 + var_39_5, var_39_4 + var_39_6)
		
		local var_39_7 = UnitZodiac:getStoneState(arg_39_1)
		
		if var_39_7 == "locked" then
			if arg_39_1 == UnitZodiac:getSphereGrade() + 1 and arg_39_1 > 1 then
				if_set(arg_39_0.vars.cursor, "txt_caution", T("level_limit", {
					level = arg_39_1 * 10
				}))
			else
				if_set(arg_39_0.vars.cursor, "txt_caution", T("need_to_enhance_prev_zodiac_stone"))
			end
		end
		
		if_set_visible(arg_39_0.vars.cursor, "txt_caution", not UnitZodiac:isDictMode() and var_39_7 == "locked")
		UIAction:Add(SEQ(DELAY(190), SHOW(true), SPAWN(FADE_IN(60), SCALE(60, 1.2, 0.8))), arg_39_0.vars.cursor)
	end
	
	TutorialGuide:procGuide("system_049")
end

function UnitZodiacStone.focusOut(arg_40_0)
	if not UnitZodiac:isDictMode() and arg_40_0:getZodiacLevel() ~= 6 then
		UIAction:Add(SEQ(OPACITY(300, 0, 1)), arg_40_0.vars.flag, "block")
	end
	
	if get_cocos_refid(arg_40_0.vars.cursor) then
		arg_40_0.vars.cursor:setVisible(false)
	end
end

function UnitZodiacStone.updateComponents(arg_41_0, arg_41_1)
	local var_41_0 = math.min(6, arg_41_0:getZodiacLevel())
	
	if UnitZodiac:isDictMode() then
		var_41_0 = 6
	end
	
	arg_41_0:updateZodiacStones()
	
	for iter_41_0 = 1, 12 do
		if arg_41_0.vars.lines[iter_41_0][1] and var_41_0 > arg_41_0.vars.grades[iter_41_0] then
			if arg_41_1 and var_41_0 == iter_41_0 then
				arg_41_0:drawLine(iter_41_0, 0, 300)
			else
				arg_41_0:enableLine(iter_41_0)
			end
		end
		
		if iter_41_0 <= var_41_0 and not arg_41_0.vars.effs[iter_41_0] then
			local var_41_1 = 0
			
			if arg_41_1 and var_41_0 == iter_41_0 then
				arg_41_0:playStoneEffect(iter_41_0, var_41_1, "on")
				
				var_41_1 = 500
			end
			
			arg_41_0.vars.effs[iter_41_0] = arg_41_0:playStoneEffect(iter_41_0, var_41_1, "loop")
		end
	end
	
	if arg_41_1 then
		UIAction:Add(SEQ(DELAY(500), CALL(UnitZodiac.updateSidePanel, UnitZodiac, var_41_0, true)), "block")
	end
end

function UnitZodiacStone.updateZodiacStones(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if not arg_42_1 then
		for iter_42_0 = 1, 6 do
			arg_42_0:updateZodiacStones(arg_42_0.vars.stones[iter_42_0], iter_42_0)
		end
	else
		if UnitZodiac:isDictMode() then
			if_set_visible(arg_42_1, "lock", false)
			
			return 
		end
		
		if arg_42_2 > UnitZodiac:getSphereGrade() + 1 and not arg_42_3 then
			arg_42_1.stone:setColor(cc.c3b(100, 100, 100))
		else
			arg_42_1.stone:setColor(cc.c3b(255, 255, 255))
		end
		
		if_set_visible(arg_42_1, "lock", not arg_42_3 and UnitZodiac:getStoneState(arg_42_2) == "locked")
		if_set_visible(arg_42_1, "n_stars", not arg_42_3)
	end
end

function UnitZodiacStone.playStoneEffect(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if UnitZodiac:isDictMode() then
		return 
	end
	
	arg_43_3 = arg_43_3 or "loop"
	
	local var_43_0, var_43_1 = arg_43_0.vars.stones[arg_43_1]:getPosition()
	local var_43_2 = 1
	local var_43_3 = arg_43_0:getColor(UnitZodiac:getUnit())
	
	if arg_43_0:getSkillBonusIdx(arg_43_1) then
		var_43_3 = "skill"
	end
	
	return EffectManager:Play({
		fn = "zstone_" .. var_43_3 .. "_" .. arg_43_3 .. ".cfx",
		layer = arg_43_0.vars.wnd,
		x = var_43_0,
		y = var_43_1,
		scale = var_43_2,
		delay = arg_43_2
	})
end

function UnitZodiacStone.drawLine(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	arg_44_4 = arg_44_4 or 50
	
	for iter_44_0, iter_44_1 in pairs(arg_44_0.vars.lines[arg_44_1]) do
		local var_44_0 = iter_44_1:getScaleY()
		
		iter_44_1:setScaleY(0)
		UIAction:Add(SEQ(DELAY(arg_44_2), SPAWN(SHOW(true), OPACITY(0, 0, 1), LOG(SCALEY(arg_44_3, 0, var_44_0), arg_44_4))), iter_44_1, "block")
	end
end

function UnitZodiacStone.enableLine(arg_45_0, arg_45_1)
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.lines[arg_45_1]) do
		iter_45_1:setOpacity(255)
		iter_45_1:setVisible(true)
	end
end

function UnitZodiacStone.updateFlag(arg_46_0, arg_46_1)
	if UnitZodiac:isDictMode() then
		return 
	end
	
	local var_46_0 = UnitZodiac:getSphereGrade() + 1
	
	arg_46_0.vars.flag:setVisible(var_46_0 < 7)
	
	if var_46_0 >= 7 then
		return 
	end
	
	local var_46_1, var_46_2 = UnitZodiac:getOffsetPos()
	
	if arg_46_1 then
		local var_46_3, var_46_4 = arg_46_0.vars.stones[var_46_0]:getPosition()
		
		UIAction:Add(LOG(MOVE_TO(200, var_46_3 + var_46_1, var_46_4 + var_46_2)), arg_46_0.vars.flag, "block")
	else
		local var_46_5, var_46_6 = arg_46_0.vars.stones[var_46_0]:getPosition()
		
		arg_46_0.vars.flag:setPosition(var_46_5 + var_46_1, var_46_6 + var_46_2)
	end
end

function UnitZodiacStone.hideFlag(arg_47_0)
	if not UnitZodiac:isDictMode() and arg_47_0.vars.flag:getOpacity() ~= 0 then
		UIAction:Add(SEQ(OPACITY(300, 1, 0)), arg_47_0.vars.flag, "block")
	end
end

function UnitZodiacStone.updateInterfaces(arg_48_0, arg_48_1)
	arg_48_0:updateFlag(arg_48_1)
end

function UnitZodiacStone.updateSidePanel(arg_49_0, arg_49_1, arg_49_2)
	if not get_cocos_refid(arg_49_1) then
		return 
	end
	
	arg_49_2 = tonumber(arg_49_2)
	
	if not arg_49_2 then
		return 
	end
	
	local var_49_0 = UnitZodiac:getStoneID(arg_49_2)
	local var_49_1, var_49_2, var_49_3 = DB("zodiac_stone_2", var_49_0, {
		"name",
		"skill_up",
		"keystone"
	})
	
	if_set(arg_49_1, "txt_stone_name", T(var_49_1))
	
	local var_49_4 = arg_49_1:getChildByName("n_upgrade")
	
	for iter_49_0 = 1, 6 do
		if_set_visible(var_49_4, "star" .. iter_49_0, iter_49_0 <= arg_49_2)
		
		if iter_49_0 <= arg_49_2 then
			if_set_sprite(var_49_4, "star" .. iter_49_0, "img/cm_icon_star_j.png")
		end
	end
	
	arg_49_1:getChildByName("n_right_stars"):getChildByName("star1"):setPositionX((6 - arg_49_2) * 10)
	
	local var_49_5 = {
		arg_49_0:getNeedItem(1, arg_49_2 - 1),
		arg_49_0:getNeedItem(2, arg_49_2 - 1)
	}
	
	arg_49_0:resetSidePanel(arg_49_1)
	
	for iter_49_1 = 1, 2 do
		local var_49_6 = var_49_5[iter_49_1]
		
		if var_49_6 then
			local var_49_7 = arg_49_0:getNeedItemCount(iter_49_1, arg_49_2 - 1)
			local var_49_8 = var_49_4:getChildByName("n_res" .. iter_49_1 .. "/" .. #var_49_5)
			
			UIUtil:getRewardIcon(var_49_7, var_49_6, {
				show_count = true,
				no_frame = true,
				scale = 0.8,
				parent = var_49_8,
				count = to_n(var_49_7)
			})
			
			if to_n(var_49_7) > Account:getItemCount(var_49_5[iter_49_1]) then
				var_49_8:setOpacity(102)
			else
				var_49_8:setOpacity(255)
			end
		end
	end
	
	if_set_visible(arg_49_1, "n_lack_item1/2", #var_49_5 == 2 and arg_49_0:getNeedItemCount(1, arg_49_2 - 1) > Account:getItemCount(var_49_5[1]))
	if_set_visible(arg_49_1, "n_lack_item2/2", #var_49_5 == 2 and arg_49_0:getNeedItemCount(2, arg_49_2 - 1) > Account:getItemCount(var_49_5[2]))
	if_set_visible(arg_49_1, "n_lack_item1/1", #var_49_5 == 1 and arg_49_0:getNeedItemCount(1, arg_49_2 - 1) > Account:getItemCount(var_49_5[1]))
	
	local var_49_9 = arg_49_0:createStoneNode(arg_49_2, nil, true)
	
	arg_49_0:updateZodiacStones(var_49_9, arg_49_2, true)
	if_set_visible(arg_49_1, "n_right_stars", true)
	if_set_visible(arg_49_1, "n_stone_pos", true)
	if_set_visible(arg_49_1, "n_rune_pos", false)
	if_set_visible(arg_49_1, "n_rune", false)
	arg_49_1:getChildByName("n_stone_pos"):removeAllChildren()
	arg_49_1:getChildByName("n_stone_pos"):addChild(var_49_9)
	arg_49_0:updateStatBonus(arg_49_1, arg_49_2, var_49_2 ~= nil or var_49_3 ~= nil)
	if_set_visible(arg_49_1, "n_bonus_keystone", var_49_3 ~= nil)
	arg_49_1:getChildByName("n_skill_tooltip"):removeAllChildren()
	
	if var_49_2 then
		local var_49_10 = UnitZodiac:getUnit()
		local var_49_11 = arg_49_1:getChildByName("n_bonus_skill_pos")
		
		var_49_11:removeAllChildren()
		
		local var_49_12 = var_49_10:getRawSkillIds(var_49_10.inst.code)[var_49_2]
		local var_49_13 = UnitZodiac:getSkillID(arg_49_2)
		local var_49_14 = UIUtil:getSkillIcon(var_49_10, var_49_13, {
			no_tooltip = true
		})
		
		var_49_11:addChild(var_49_14)
		if_set(arg_49_1, "txt_skill_name", T(DB("skill", var_49_13, "name")))
		
		local var_49_15 = UIUtil:getSkillTooltip(var_49_10, var_49_12, {
			hide_stat = true,
			detail_before = true,
			hide_combo = true,
			ignore_exclusive_bonus = true
		})
		local var_49_16 = UIUtil:getSkillTooltip(var_49_10, var_49_13, {
			hide_stat = true,
			hide_combo = true,
			detail_after = true
		})
		local var_49_17 = 60
		local var_49_18 = var_49_15:getContentSize().height + var_49_16:getContentSize().height - var_49_17 * 2
		local var_49_19 = 650
		local var_49_20 = var_49_19 < var_49_18 and var_49_19 / var_49_18 or 1
		
		var_49_15:setScale(var_49_20)
		var_49_16:setScale(var_49_20)
		var_49_15:setAnchorPoint(1, 0)
		var_49_16:setAnchorPoint(1, 0)
		var_49_15:setPositionY((var_49_16:getContentSize().height - var_49_17) * var_49_20)
		arg_49_1:getChildByName("n_skill_tooltip"):addChild(var_49_15)
		arg_49_1:getChildByName("n_skill_tooltip"):addChild(var_49_16)
	end
	
	if_set_visible(arg_49_1, "n_bonus_potential_skill", false)
	if_set_visible(arg_49_1, "n_bonus_skill", var_49_2 ~= nil)
	if_set_visible(arg_49_1, "n_zodiac", true)
	if_set_visible(arg_49_1, "n_skilltree", false)
end

function UnitZodiacStone.updateStatBonus(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = UnitZodiac:getUnit():getZodiacBonus(arg_50_2, nil, true)
	local var_50_1 = 1
	
	if arg_50_3 then
		var_50_1 = 0
	end
	
	for iter_50_0 = 0, 4 do
		local var_50_2 = iter_50_0 + var_50_1
		
		if var_50_0[var_50_2] then
			if_set(arg_50_1, "txt_diff" .. iter_50_0, to_var_str(to_n(var_50_0[var_50_2][2]), var_50_0[var_50_2][1]))
			if_set(arg_50_1, "txt_stat_name" .. iter_50_0, getStatName(var_50_0[var_50_2][1]))
			
			if iter_50_0 == 0 then
				if_set_sprite(arg_50_1, "stat_icon" .. iter_50_0, "img/icon_menu_" .. string.gsub(var_50_0[var_50_2][1], "_rate", "") .. ".png")
			else
				if_set_sprite(arg_50_1, "stat_icon" .. iter_50_0, "img/cm_icon_stat_" .. string.gsub(var_50_0[var_50_2][1], "_rate", "") .. ".png")
			end
		end
		
		if_set_visible(arg_50_1, "n_bonus_stat" .. iter_50_0, var_50_0[var_50_2] ~= nil)
	end
	
	return var_50_0
end

function UnitZodiacStone.updateZodiacGradeToUnit(arg_51_0, arg_51_1)
	arg_51_0.vars.rewards = {
		grade = arg_51_1
	}
	arg_51_0.vars.rewards.skill_after = UnitZodiac:getSkillID(arg_51_1)
	
	local var_51_0 = UnitZodiac:getUnit()
	
	var_51_0.inst.zodiac = arg_51_1
	
	var_51_0:updateZodiacSkills()
	var_51_0:calc()
	SkillEffectFilterManager:refreshUnit(var_51_0)
	
	local var_51_1 = var_51_0:clone()
	
	var_51_1.equips = {}
	var_51_1.inst.zodiac = arg_51_1 - 1
	
	var_51_1:updateZodiacSkills()
	var_51_1:calc()
	
	arg_51_0.vars.rewards.prev_grade = var_51_1.inst.zodiac
	arg_51_0.vars.rewards.status_before = table.clone(var_51_1.status)
	arg_51_0.vars.rewards.status_bonus = var_51_1:getZodiacBonus(arg_51_1)
	var_51_1.inst.zodiac = arg_51_1
	
	var_51_1:updateZodiacSkills()
	var_51_1:calc()
	
	arg_51_0.vars.rewards.status_after = table.clone(var_51_1.status)
	arg_51_0.vars.rewards.keystone = DB("zodiac_stone_2", arg_51_0:getStoneID(arg_51_1), "keystone")
end

function UnitZodiacStone.displayUpgradeReward(arg_52_0, arg_52_1)
	if arg_52_1 then
		arg_52_0:updateZodiacGradeToUnit(arg_52_1)
	end
	
	if not arg_52_0.vars.rewards then
		return 
	end
	
	if arg_52_0.vars.rewards.keystone and not arg_52_0.vars.rewards.display_zodiac then
		local var_52_0 = load_dlg("dlg_zodiac_reward_keystone", true, "wnd")
		
		Dialog:msgBox({
			fade_in = 500,
			dlg = var_52_0,
			handler = function()
				arg_52_0:displayUpgradeReward()
			end
		})
		
		arg_52_0.vars.rewards.display_zodiac = true
		
		return 
	end
	
	if arg_52_0.vars.rewards.skill_after and not arg_52_0.vars.rewards.display_skill then
		local var_52_1 = UnitZodiac:getUnit()
		local var_52_2 = load_dlg("dlg_zodiac_reward_skill", true, "wnd")
		local var_52_3 = var_52_2:getChildByName("skill_01")
		local var_52_4 = var_52_2:getChildByName("skill_02")
		local var_52_5 = DB("skill", arg_52_0.vars.rewards.skill_after, "base_skill")
		
		UIUtil:getSkillDetail(var_52_1, nil, {
			ignore_check = true,
			wnd = var_52_3,
			skill_id = var_52_5
		})
		UIUtil:getSkillDetail(var_52_1, nil, {
			ignore_check = true,
			wnd = var_52_4,
			skill_id = arg_52_0.vars.rewards.skill_after
		})
		
		arg_52_0.vars.rewards.display_skill = true
		
		Dialog:msgBox({
			fade_in = 500,
			dlg = var_52_2,
			handler = function()
				arg_52_0:displayUpgradeReward()
			end
		})
		
		return 
	end
	
	if arg_52_0.vars.rewards.status_after and not arg_52_0.vars.rewards.display_status then
		local var_52_6 = load_dlg("dlg_zodiac_reward_stat", true, "wnd")
		
		Dialog:msgBox({
			fade_in = 500,
			dlg = var_52_6,
			handler = function()
				arg_52_0:displayUpgradeReward()
				UnitZodiac:playPotentialTutorial()
				TutorialGuide:procGuide("system_049")
			end
		})
		
		local var_52_7 = arg_52_0:updateStatBonus(var_52_6, arg_52_0.vars.rewards.grade)
		
		for iter_52_0 = 0, 3 do
			if var_52_7[iter_52_0 + 1] then
				local var_52_8 = string.gsub(var_52_7[iter_52_0 + 1][1], "_rate", "")
				
				if_set(var_52_6, "txt_stat" .. iter_52_0 .. "_before", to_var_str(arg_52_0.vars.rewards.status_before[var_52_8], var_52_8))
				
				local var_52_9
				local var_52_10 = arg_52_0.vars.rewards.status_after[var_52_8]
				
				if UNIT.is_percentage_stat(var_52_8) then
					local var_52_11 = 1e-07
					
					var_52_10 = math.floor(var_52_10 * 100 + var_52_11)
					var_52_9 = "%"
				end
				
				UIAction:Add(INC_NUMBER(700, var_52_10, var_52_9, arg_52_0.vars.rewards.status_before[var_52_8]), var_52_6:getChildByName("txt_stat" .. iter_52_0), "hey")
			end
		end
		
		arg_52_0.vars.rewards.display_status = true
		
		return 
	end
end

function UnitZodiacStone.reqEnhance(arg_56_0)
	local var_56_0 = UnitZodiac:getUnit()
	
	if not var_56_0 then
		return 
	end
	
	local var_56_1 = arg_56_0:getZodiacLevel() + 1
	local var_56_2 = UnitZodiac:getZoomIndex()
	local var_56_3, var_56_4 = arg_56_0:checkEnhance(var_56_2)
	
	if not var_56_3 then
		if var_56_4 == "invalid" then
			balloon_message_with_sound("invalid_zodiac_stone_order")
		end
		
		if var_56_4 == "enhanced" then
			balloon_message_with_sound("already_enhanced_zodiac_stone")
		end
		
		if var_56_4 == "level" then
			balloon_message_with_sound("zodiac_can_upgrade", {
				level = var_56_2 * 10
			})
		end
		
		if var_56_4 == "moonlight" then
			balloon_message_with_sound("character_stone_cannot_upgrade")
		end
		
		if var_56_4 == "material" then
			balloon_message_with_sound("need_material")
		end
		
		if var_56_4 == "complete" then
			balloon_message_with_sound("msg_all_complete_awaken")
		end
		
		return 
	end
	
	if not var_56_2 then
		UnitZodiac:focusIn(var_56_1)
		
		return 
	end
	
	if var_56_1 ~= var_56_2 then
		return 
	end
	
	local var_56_5
	local var_56_6
	
	if IS_PUBLISHER_ZLONG then
		var_56_5 = var_56_0:getPoint()
		
		local var_56_7 = var_56_0:clone()
		
		var_56_7.inst.zodiac = var_56_1
		
		var_56_7:calc()
		
		var_56_6 = var_56_7:getPoint()
	end
	
	query("zodiac_enhance", {
		mode = "enhance",
		target = var_56_0:getUID(),
		begin_lv = arg_56_0:getZodiacLevel(),
		target_lv = var_56_1,
		begin_point = var_56_5,
		after_point = var_56_6
	})
end

function MsgHandler.zodiac_enhance(arg_57_0)
	local var_57_0 = Account:getUnit(arg_57_0.target)
	local var_57_1 = var_57_0:getZodiacGrade()
	
	for iter_57_0, iter_57_1 in pairs(arg_57_0.items) do
		Account:setItemCount(iter_57_0, iter_57_1)
	end
	
	ConditionContentsManager:dispatch("unit.zodiac", {
		unit = var_57_0,
		grade = var_57_0:getBaseGrade(),
		pre_level = var_57_1,
		level = arg_57_0.zodiac
	})
	ConditionContentsManager:dispatch("hero.awaken.count", {
		grade = var_57_0:getBaseGrade(),
		level = arg_57_0.zodiac
	})
	Account:setCurrency("gold", arg_57_0.gold)
	TopBarNew:topbarUpdate(true)
	TutorialGuide:procGuide("system_049")
	UnitZodiac:respStoneEnhance()
	
	local var_57_2 = HeroBelt:getInst("UnitMain")
	
	if var_57_2 then
		var_57_2:updateUnit(nil, var_57_0)
	end
	
	if var_57_0.db.code == "c3026" then
		ConditionContentsManager:dispatch("c3026.zodiac", {
			unit = var_57_0
		})
	end
end

function UnitZodiacStone.checkEnhance(arg_58_0, arg_58_1)
	if not arg_58_1 then
		return arg_58_0:getZodiacLevel() < 6, "complete"
	end
	
	if arg_58_1 > 6 then
		return false
	end
	
	local var_58_0 = arg_58_0:getZodiacLevel() + 1
	
	if arg_58_1 < var_58_0 then
		return false, "enhanced"
	end
	
	if var_58_0 < arg_58_1 then
		return false, "invalid"
	end
	
	local var_58_1 = UnitZodiac:getUnit()
	
	if arg_58_1 > 1 and var_58_1:getLv() < arg_58_1 * 10 and not DEBUG.ZODIAC_IGNORE_LEVEL then
		return false, "level"
	end
	
	if var_58_1:isLockZodiacUpgrade5() and var_58_0 > 4 then
		return false, "moonlight"
	end
	
	local var_58_2 = 0
	local var_58_3 = 0
	local var_58_4 = arg_58_0:getNeedItem(1)
	
	if var_58_4 then
		var_58_2 = Account:getItemCount(var_58_4)
	end
	
	local var_58_5 = arg_58_0:getNeedItem(2)
	
	if var_58_5 then
		var_58_3 = Account:getItemCount(var_58_5)
	end
	
	local var_58_6 = arg_58_0:getNeedItemCount(1)
	local var_58_7 = arg_58_0:getNeedItemCount(2)
	
	return var_58_6 <= var_58_2 and var_58_7 <= var_58_3, "material"
end

function UnitZodiacStone.getZodiacLevel(arg_59_0)
	return UnitZodiac:getSphereGrade()
end

function UnitZodiacStone.respEnhance(arg_60_0)
	if arg_60_0:getZodiacLevel() >= 6 then
		return 
	end
	
	local var_60_0 = UnitZodiac:getUnit()
	
	if not var_60_0 then
		return 
	end
	
	UnitZodiac:focusOut()
	arg_60_0:updateZodiacGradeToUnit(arg_60_0:getZodiacLevel() + 1)
	
	local var_60_1 = var_60_0.inst.zodiac
	local var_60_2 = load_dlg("unit_zodiac_upgrade", true, "wnd")
	local var_60_3 = UnitZodiac:getWindos()
	
	if get_cocos_refid(var_60_3) then
		var_60_3:addChild(var_60_2)
	end
	
	EffectManager:Play({
		z = 3,
		fn = "zodiac_star_up_pati.cfx",
		y = 0,
		x = 0,
		layer = var_60_2:getChildByName("n_eff")
	})
	EffectManager:Play({
		z = 3,
		y = 0,
		x = 0,
		fn = "zodiac_" .. string.split(UnitZodiac:getSphereName(), "_")[1] .. ".cfx",
		layer = var_60_2:getChildByName("n_eff")
	})
	UnitZodiac:setSphereStars(var_60_2, var_60_1 - 1)
	UIAction:Add(SEQ(DELAY(2000), CALL(UnitZodiac.setSphereStars, UnitZodiac, var_60_2, var_60_1)), arg_60_0, "block")
	
	local var_60_4 = DB("zodiac_sphere_2", UnitZodiac:getSphereName(), "name")
	
	if_set(var_60_2, "txt_sphere_name", T(var_60_4))
	var_60_2:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(1000), DELAY(2500), FADE_OUT(800), REMOVE()), var_60_2, "block")
	
	local var_60_5, var_60_6 = var_60_2:getChildByName("gs" .. var_60_1):getPosition()
	
	EffectManager:Play({
		z = 3,
		fn = "zodiac_star_up.cfx",
		delay = 1000,
		layer = var_60_2:getChildByName("star"),
		x = var_60_5,
		y = var_60_6
	})
	arg_60_0:updateComponents(true)
	arg_60_0:updateInterfaces(true)
	UIAction:Add(SEQ(DELAY(4500), CALL(arg_60_0.displayUpgradeReward, arg_60_0, var_60_1)), arg_60_0, "block")
end

function UnitZodiacStone.getNeedItemList(arg_61_0)
	local var_61_0 = {}
	
	for iter_61_0 = 0, 5 do
		local var_61_1 = arg_61_0:getNeedItem(1, iter_61_0)
		local var_61_2 = arg_61_0:getNeedItem(2, iter_61_0)
		local var_61_3 = arg_61_0:getNeedItemCount(1, iter_61_0)
		local var_61_4 = arg_61_0:getNeedItemCount(2, iter_61_0)
		
		table.insert(var_61_0, {
			var_61_1,
			var_61_3
		})
		table.insert(var_61_0, {
			var_61_2,
			var_61_4
		})
	end
	
	return var_61_0
end

function UnitZodiacStone.getNeedItem(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = UnitZodiac:getUnit()
	
	if not var_62_0 then
		return 
	end
	
	arg_62_2 = arg_62_2 or arg_62_0:getZodiacLevel()
	
	return DB("rune_req", var_62_0:getRuneDBKey(), "req" .. arg_62_2 + 1 .. "_" .. arg_62_1)
end

function UnitZodiacStone.getNeedItemCount(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = UnitZodiac:getUnit()
	
	if not var_63_0 then
		return 
	end
	
	arg_63_2 = arg_63_2 or arg_63_0:getZodiacLevel()
	
	return to_n(DB("rune_req", var_63_0:getRuneDBKey(), "count" .. arg_63_2 + 1 .. "_" .. arg_63_1))
end
