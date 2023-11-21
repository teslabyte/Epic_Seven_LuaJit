local var_0_0 = 10

ActionBarItem = ActionBarItem or {}

function HANDLER.hud_face(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_face" then
		if Battle:isPlayingBattleAction() then
			return 
		end
		
		if Battle.logic:isRealtimeMode() then
			return 
		end
		
		local var_1_0 = Battle.logic:getTurnOwner()
		
		if not var_1_0 then
			return 
		end
		
		if Battle.logic:isAIPlayer(var_1_0) then
			return 
		end
		
		local var_1_1 = getParentWindow(arg_1_0)
		
		if var_1_1 then
			local var_1_2 = var_1_1.unit
			
			if Battle:isSelectTargetable(var_1_2) then
				Battle:onSelectTarget(var_1_2)
			else
				BattleUI:showTargetGuide(true)
			end
		end
	end
end

function HANDLER.inbattle_order(arg_2_0, arg_2_1)
	if Battle:isPlayingBattleAction() then
		return 
	end
	
	if arg_2_1 == "btn_tag" then
		Battle:swapSupporter()
	end
	
	if arg_2_1 == "btn_detail" then
		UIBattleAttackOrder:showDetail()
	end
end

function HANDLER.inbattle_order_detail(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close_detail" then
		UIBattleAttackOrder:hideDetail()
	end
end

function ActionBarItem.setInBattleTabFaceInfo(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1:getSPName()
	local var_4_1 = math.min(1, arg_4_1:getSPRatio() or 0)
	local var_4_2 = ""
	
	if var_4_0 == "berserk_gauge" then
		var_4_2 = "berserk"
	elseif var_4_0 == "week_gauge" or var_4_0 == "weak_gauge" then
		var_4_2 = "weak"
		var_4_0 = "weak_gauge"
	end
	
	if_set_visible(arg_4_2, var_4_2 .. "_on", var_4_1 >= 1)
	if_set_visible(arg_4_2, var_4_2 .. "_off", var_4_1 < 1)
	if_set_visible(arg_4_2, "n_condition", var_4_2 ~= "")
	if_set_visible(arg_4_2, "weak", var_4_2 == "weak")
	
	if var_4_2 ~= "" then
		local var_4_3 = arg_4_2:getChildByName(var_4_0)
		
		if var_4_0 then
			var_4_3:setPercent(arg_4_1:getSPRatio() * 100)
			if_set_visible(arg_4_2, var_4_0, var_4_0)
		end
	end
end

function ActionBarItem.create(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_3 = arg_5_3 or {}
	
	local var_5_0 = load_control("wnd/hud_face.csb")
	
	var_5_0:setAnchorPoint(0.5, 0.5)
	var_5_0:ignoreAnchorPointForPosition(false)
	if_set_visible(var_5_0, "bg_ticket", false)
	arg_5_0:setInBattleTabFaceInfo(arg_5_2, var_5_0)
	copy_functions(ActionBarItem, var_5_0)
	arg_5_1:addChild(var_5_0)
	var_5_0:_init(arg_5_2)
	
	if arg_5_3.onActionBar then
		if_set_visible(var_5_0, "n_condition", false)
	end
	
	return var_5_0
end

function ActionBarItem.getOrder(arg_6_0)
	return arg_6_0.unit
end

function ActionBarItem.isValid(arg_7_0)
	return arg_7_0.unit and not arg_7_0.unit:isDead()
end

function ActionBarItem.getOnwer(arg_8_0)
	return arg_8_0.unit
end

function ActionBarItem._init(arg_9_0, arg_9_1)
	arg_9_0.size = arg_9_0:getContentSize()
	arg_9_0.root_ctrl = arg_9_0:getChildByName("n_root")
	arg_9_0.back_ctrl = arg_9_0:getChildByName("bg_face")
	arg_9_0.face_ctrl = arg_9_0:getChildByName("icon_face")
	arg_9_0.shake_ctrl = arg_9_0:getChildByName("n_shake")
	arg_9_0.scale_ctrl = arg_9_0:getChildByName("n_scale")
	arg_9_0.tag_ctrl = arg_9_0:getChildByName("bg_ticket")
	arg_9_0.num_ctrl = arg_9_0:getChildByName("txt_num")
	arg_9_0.unit = arg_9_1
	
	if arg_9_1.inst.ally ~= FRIEND then
		if_set_color(arg_9_0, "gage_actbar", cc.c3b(255, 80, 80))
	end
	
	if Battle.viewer:isSpectator() then
		local var_9_0 = arg_9_1.inst.ally == FRIEND and cc.c3b(68, 148, 255) or cc.c3b(254, 30, 30)
		
		if_set_color(arg_9_0, "gage_actbar", var_9_0)
	end
	
	arg_9_0:updateUnitInfo()
end

function ActionBarItem.dead(arg_10_0, arg_10_1)
	if arg_10_1 then
		BattleUIAction:Add(SEQ(REMOVE()), arg_10_0)
	else
		BattleUIAction:Add(SEQ(TARGET(arg_10_0.root_ctrl, SPAWN(FADE_OUT(700), SHAKE_UI(700, 12), COLOR(500, 0, 0, 0))), DELAY(1500), REMOVE()), arg_10_0)
		
		local var_10_0 = EffectManager:Play({
			fn = "death_eff_01.cfx",
			y = 30,
			delay = 300,
			x = 30,
			layer = arg_10_0
		})
		
		var_10_0:setScaleX(-0.5)
		var_10_0:setScaleY(0.5)
	end
end

function ActionBarItem.showTargetNumber(arg_11_0)
	SpriteCache:resetSprite(arg_11_0.num_ctrl, "img/itxt_num" .. to_n(arg_11_0.unit.inst.team_order or 1) .. "_b.png")
	arg_11_0.tag_ctrl:setVisible(true)
end

function ActionBarItem.updateUnitInfo(arg_12_0)
	if arg_12_0.unit.inst.ally == ENEMY then
		SpriteCache:resetSprite(arg_12_0.back_ctrl, "img/_hero_s_bg_enemy.png")
	else
		SpriteCache:resetSprite(arg_12_0.back_ctrl, "img/_hero_s_bg_ally.png")
	end
	
	local var_12_0
	local var_12_1 = arg_12_0.unit:isModelChange() and arg_12_0.unit.db.face_id2
	local var_12_2 = arg_12_0.unit:isTransformed() and arg_12_0.unit:getTransformVars().face_id or var_12_1 or arg_12_0.unit.db.face_id
	
	SpriteCache:resetSprite(arg_12_0.face_ctrl, "face/" .. var_12_2 .. "_s.png")
end

function ActionBarItem.getPosY(arg_13_0, arg_13_1)
	arg_13_1 = arg_13_1 or arg_13_0.unit.inst.elapsed_ut
	arg_13_1 = math.min(MAX_UNIT_TICK, math.max(0, arg_13_1))
	
	return (MAX_UNIT_TICK - to_n(arg_13_1)) / MAX_UNIT_TICK * 440 + 50
end

function ActionBarItem.arrange(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = 800
	
	if arg_14_3 then
		if arg_14_3 ~= 0 then
			var_14_0 = 200 + math.min(200, arg_14_3 * 20)
		end
	else
		var_14_0 = 600
	end
	
	local var_14_1 = 0
	local var_14_2
	local var_14_3
	local var_14_4 = Battle.logic:getTurnOwner()
	local var_14_5 = math.min(MAX_UNIT_TICK, arg_14_0.unit.inst.elapsed_ut)
	local var_14_6 = var_14_4.turn_vars.actionbar_dirty
	
	if var_14_4 == arg_14_0.unit and not var_14_6 then
		var_14_5 = MAX_UNIT_TICK
	end
	
	if not arg_14_0.prevElapsedUT then
		var_14_3 = true
		arg_14_0.prevElapsedUT = 0
		var_14_0 = var_14_0 + 100
		var_14_1 = 200 + (MAX_UNIT_TICK - var_14_5) / MAX_UNIT_TICK * 500
	end
	
	local var_14_7 = arg_14_0:getPosY(arg_14_0.prevElapsedUT)
	local var_14_8 = arg_14_0:getPosY(var_14_5)
	
	if arg_14_2 then
		arg_14_0:setPosition(0, var_14_8)
		
		return 
	end
	
	if arg_14_0:getOpacity() == 0 then
		arg_14_0:setPositionY(arg_14_0:getPosY(0))
		BattleUIAction:Add(LOG(SPAWN(FADE_IN(var_14_0 * 0.2), SCALE(var_14_0 * 0.2, arg_14_0:getScale(), 1))), arg_14_0)
	end
	
	local var_14_9 = MOVE_TO(var_14_0, 0, var_14_8)
	
	if var_14_3 then
		var_14_9 = BEZIER(var_14_9, {
			0,
			1,
			0.57,
			1
		})
	end
	
	local var_14_10 = "actionbar_" .. arg_14_0.unit:getUID()
	
	if var_14_4 == arg_14_0.unit and not var_14_6 then
		if BattleUIAction:Find(var_14_10) then
			BattleUIAction:Remove(var_14_10)
		end
		
		BattleUIAction:Add(SEQ(DELAY(var_14_1), SPAWN(ZORDER(var_14_5), var_14_9, SEQ(DELAY(var_14_0), OPACITY(100, 1, 0)))), arg_14_0, var_14_10)
	else
		local var_14_11 = SEQ(ZORDER(var_14_5), DELAY(var_14_1), var_14_9)
		
		if BattleUIAction:Find(var_14_10) then
			BattleUIAction:Remove(var_14_10)
		end
		
		BattleUIAction:Add(var_14_11, arg_14_0, var_14_10)
	end
	
	if var_14_6 then
		var_14_4.turn_vars.actionbar_dirty = nil
	end
	
	if arg_14_1 then
		arg_14_0.scale_ctrl:setScale(3)
		BattleUIAction:Add(RLOG(SCALE(var_14_0, 3, 1)), arg_14_0.scale_ctrl)
		BattleUIAction:Add(SEQ(ZORDER(var_14_5 + 1000), DELAY(var_14_0), ZORDER(var_14_5)), arg_14_0)
	end
	
	arg_14_0.prevElapsedUT = var_14_5
	
	return var_14_8
end

UIBattleAttackOrder = UIBattleAttackOrder or {}
UIBattleAttackOrder.detailed = nil

function UIBattleAttackOrder.init(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0.parent = arg_15_1
	arg_15_0.logic = arg_15_2
	
	arg_15_0.parent:removeChildByName("inbattle_order")
	
	arg_15_0.dlg = load_dlg("inbattle_order", true, "wnd")
	
	arg_15_0.dlg:setVisible(false)
	arg_15_0.parent:addChild(arg_15_0.dlg)
	arg_15_0.dlg:setLocalZOrder(899999)
	if_set_visible(arg_15_0.dlg, "n_detail", false)
	if_set_visible(arg_15_0.dlg, "n_supporter", false)
	if_set_visible(arg_15_0.dlg, "btn_detail", not MatchService:isBroadCastUIHide())
	
	if arg_15_0.logic and arg_15_0.logic:isCreviceHunt() then
		if_set_visible(arg_15_0.dlg, "n_turn", true)
		arg_15_0:initCrehuntTurnInfo()
		arg_15_0:setTurnInfo()
	end
	
	arg_15_0.sequencer_wnd = arg_15_0.dlg:getChildByName("n_sequencer")
	arg_15_0.unit_node = arg_15_0.dlg:getChildByName("n_unit")
	arg_15_0.item_ctrls = {}
	arg_15_0.ctrl_index = 1
	
	arg_15_0.sequencer_wnd:removeAllChildren()
end

function UIBattleAttackOrder.incCtrlIndex(arg_16_0)
	arg_16_0.ctrl_index = arg_16_0.ctrl_index + 1
	arg_16_0.ctrl_index = arg_16_0.ctrl_index - 1 % #arg_16_0.item_ctrls + 1
end

function UIBattleAttackOrder.getControl(arg_17_0, arg_17_1)
	arg_17_1 = arg_17_1 - 1 % #arg_17_0.item_ctrls + 1
	
	return arg_17_0.item_ctrls[arg_17_1]
end

local function var_0_1(arg_18_0, arg_18_1)
	return arg_18_0.rest < arg_18_1.rest
end

function UIBattleAttackOrder.playAttacked(arg_19_0, arg_19_1)
	for iter_19_0, iter_19_1 in pairs(arg_19_0.item_ctrls) do
		if iter_19_1.unit == arg_19_1 then
			BattleUIAction:Remove(iter_19_1.face_ctrl)
			BattleUIAction:Add(REPEAT(3, SEQ(BLEND(1, "red", 0, 1), DELAY(40), BLEND(1, "white", 0, 1), DELAY(30), BLEND(0), DELAY(20))), iter_19_1.face_ctrl)
			BattleUIAction:Remove(iter_19_1.shake_ctrl)
			BattleUIAction:Add(SEQ(SHAKE_UI(300, 12), MOVE_TO(0, 0, 0)), iter_19_1.shake_ctrl)
		end
	end
end

function UIBattleAttackOrder.removeCtrl(arg_20_0, arg_20_1)
	for iter_20_0 = #arg_20_0.item_ctrls, 1, -1 do
		local var_20_0 = arg_20_0.item_ctrls[iter_20_0]
		
		if arg_20_0.item_ctrls[iter_20_0].unit == arg_20_1 then
			table.remove(arg_20_0.item_ctrls, iter_20_0)
			remove_object(var_20_0)
		end
	end
end

function UIBattleAttackOrder.listup(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.logic.tick + 1
	local var_21_1 = arg_21_0.logic:getAliveUnitMap()
	
	for iter_21_0 = #arg_21_0.item_ctrls, 1, -1 do
		local var_21_2 = arg_21_0.item_ctrls[iter_21_0]
		local var_21_3 = arg_21_0.item_ctrls[iter_21_0].unit
		
		if var_21_1[var_21_3] then
			var_21_1[var_21_3] = nil
		else
			var_21_2:dead()
			table.remove(arg_21_0.item_ctrls, iter_21_0)
		end
	end
	
	for iter_21_1, iter_21_2 in pairs(var_21_1) do
		local var_21_4 = ActionBarItem:create(arg_21_0.sequencer_wnd, iter_21_1, {
			onActionBar = true
		})
		
		var_21_4:setPositionY(var_21_4:getPosY(0))
		table.insert(arg_21_0.item_ctrls, var_21_4)
	end
	
	for iter_21_3, iter_21_4 in pairs(arg_21_0.item_ctrls) do
		iter_21_4:arrange(nil, arg_21_1, arg_21_2)
	end
end

function UIBattleAttackOrder.update(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	for iter_22_0, iter_22_1 in pairs(arg_22_0.item_ctrls) do
		if iter_22_1.unit == arg_22_1 then
			if arg_22_1:isDead() then
				iter_22_1:dead(arg_22_4)
				table.remove(arg_22_0.item_ctrls, iter_22_0)
				
				break
			end
			
			iter_22_1:arrange(arg_22_2, arg_22_3)
			
			break
		end
	end
end

function UIBattleAttackOrder.updateUnitInfo(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in pairs(arg_23_0.item_ctrls) do
		if iter_23_1.unit == arg_23_1 then
			iter_23_1:updateUnitInfo()
			
			break
		end
	end
end

function UIBattleAttackOrder.show(arg_24_0)
	local var_24_0 = false
	
	if arg_24_0.dlg:isVisible() then
		return var_24_0
	end
	
	arg_24_0.dlg:setVisible(true)
	
	if get_cocos_refid(arg_24_0.face_sprite) then
		arg_24_0.face_sprite:removeFromParent()
		
		arg_24_0.face_sprite = nil
	end
	
	if get_cocos_refid(arg_24_0.unit_plate) then
		arg_24_0.unit_plate:removeFromParent()
		
		arg_24_0.unit_plate = nil
	end
	
	local var_24_1 = 450
	local var_24_2 = arg_24_0.dlg:getChildByName("n_info")
	
	var_24_2:setPosition(VIEW_BASE_LEFT + -150, -150)
	BattleUIAction:Add(SPAWN(BEZIER(MOVE_TO(var_24_1, VIEW_BASE_LEFT, 0), {
		0,
		1,
		0.57,
		1
	}), FADE_IN(var_24_1)), var_24_2)
	NotchManager:addListener(var_24_2, false, function(arg_25_0, arg_25_1, arg_25_2)
		local var_25_0 = NOTCH_WIDTH ~= 0 and NOTCH_WIDTH or NOTCH_LEFT_WIDTH
		local var_25_1 = {
			"n_sequencer",
			"game_hud_timebg1_417",
			"game_hud_timebg2_notch",
			"btn_detail"
		}
		
		if var_25_0 ~= 0 then
			if arg_25_2 then
				var_25_0 = 0
			end
			
			for iter_25_0, iter_25_1 in pairs(var_25_1) do
				local var_25_2 = arg_25_0:getChildByName(iter_25_1)
				
				if var_25_2 then
					if not arg_24_0[iter_25_1 .. "origin_x"] then
						arg_24_0[iter_25_1 .. "origin_x"] = var_25_2:getPositionX()
					end
					
					var_25_2:setPositionX(arg_24_0[iter_25_1 .. "origin_x"] + var_25_0 / 2)
				end
			end
		end
		
		if_set_visible(arg_25_0, "game_hud_timebg2_418", var_25_0 == 0)
		if_set_visible(arg_25_0, "game_hud_timebg2_notch", var_25_0 ~= 0)
	end)
	
	return true
end

function UIBattleAttackOrder.hide(arg_26_0, arg_26_1)
	if not get_cocos_refid(arg_26_0.dlg) then
		return 
	end
	
	if not arg_26_0.dlg:isVisible() then
		return 
	end
	
	local var_26_0 = arg_26_0.dlg:getChildByName("n_info")
	local var_26_1 = arg_26_0.dlg:getChildByName("n_portrait")
	local var_26_2 = arg_26_1 or 700
	
	arg_26_0:hideDetail()
	BattleUIAction:Add(SEQ(SPAWN(RLOG(MOVE_TO(var_26_2, -150, -150))), TARGET(arg_26_0.dlg, SHOW(false))), var_26_0, "actionbar.hide")
end

function UIBattleAttackOrder.isVisible(arg_27_0)
	if get_cocos_refid(arg_27_0.dlg) then
		return arg_27_0.detailed
	end
end

function UIBattleAttackOrder._changeControlPlate(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = 300
	
	if get_cocos_refid(arg_28_2) then
		BattleUIAction:Add(LOG(SEQ(DELAY(100), SPAWN(MOVE_TO(var_28_0, 200), SCALE_TO(var_28_0, 0.5), FADE_OUT(var_28_0)), REMOVE()), 30), arg_28_2)
	end
	
	if get_cocos_refid(arg_28_3) then
		arg_28_3:setPositionX(-200)
		arg_28_3:setScale(0.5)
		BattleUIAction:Add(SEQ(DELAY(100), LOG(SPAWN(MOVE_TO(var_28_0, 0), SCALE_TO(var_28_0, 1), FADE_IN(var_28_0)), 30)), arg_28_3)
		arg_28_1:addChildFirst(arg_28_3)
	end
end

function UIBattleAttackOrder.activeUnitInfo(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0.active_unit ~= arg_29_1
	
	arg_29_0.active_unit = arg_29_1
	
	local var_29_1 = arg_29_0.face_sprite
	local var_29_2 = arg_29_0.unit_plate
	
	if not var_29_0 then
		if get_cocos_refid(var_29_1) then
			var_29_1:removeFromParent()
		end
		
		if get_cocos_refid(var_29_2) then
			var_29_2:removeFromParent()
		end
	end
	
	local var_29_3
	local var_29_4 = arg_29_1:isModelChange() and arg_29_1.db.face_id2
	local var_29_5 = arg_29_1:isTransformed() and arg_29_1:getTransformVars().face_id or var_29_4 or arg_29_1.db.face_id
	
	arg_29_0.face_sprite = cc.Sprite:create("face/" .. var_29_5 .. "_su.png")
	
	if not get_cocos_refid(arg_29_0.face_sprite) then
		arg_29_0.face_sprite = cc.Sprite:create("img/404.png")
	end
	
	arg_29_0.face_sprite:setAnchorPoint(0, 0)
	
	local var_29_6 = arg_29_0.dlg:getChildByName("n_portrait")
	
	arg_29_0:_changeControlPlate(var_29_6, var_29_1, arg_29_0.face_sprite)
	
	arg_29_0.unit_plate = load_control("wnd/unit_plate.csb")
	
	UIUtil:setUnitAllInfo(arg_29_0.unit_plate, arg_29_1)
	arg_29_0:updateBattleResInfo(arg_29_1)
	
	local var_29_7 = arg_29_0.dlg:getChildByName("n_unit")
	
	arg_29_0:_changeControlPlate(var_29_7, var_29_2, arg_29_0.unit_plate)
end

function UIBattleAttackOrder.updateBattleResInfo(arg_30_0, arg_30_1)
	if arg_30_0.active_unit ~= arg_30_1 then
		return 
	end
	
	local var_30_0 = arg_30_1:getSPName()
	
	if_set_visible(arg_30_0.unit_plate, "n_mp", var_30_0 == "mp")
	if_set_visible(arg_30_0.unit_plate, "n_bp", var_30_0 == "bp")
	if_set_visible(arg_30_0.unit_plate, "n_cp", var_30_0 == "cp")
	arg_30_0.unit_plate:getChildByName("exp"):setScaleX(arg_30_1:getEXPRatio())
	
	local var_30_1 = arg_30_0.unit_plate:getChildByName("n_res_y")
	local var_30_2 = arg_30_0.unit_plate:getChildByName("bar_" .. var_30_0)
	
	if var_30_0 and var_30_0 ~= "none" and get_cocos_refid(var_30_2) then
		if_set(arg_30_0.unit_plate, "txt_" .. var_30_0, arg_30_1:getSP() .. "/" .. arg_30_1:getMaxSP())
		var_30_2:setPercent(arg_30_1:getSPRatio() * 100)
		var_30_1:setPosition(0, 0)
	else
		var_30_1:setPosition(-3, -7)
	end
	
	if_set(arg_30_0.unit_plate, "txt_hp", math.floor(arg_30_1:getHP()) .. "/" .. math.floor(arg_30_1:getMaxHP()))
	
	local var_30_3 = (1 - arg_30_1:getBrokenHPRatio()) * arg_30_1:getHPRatio()
	
	arg_30_0.unit_plate:getChildByName("bar"):setPercent(var_30_3 * 100)
	
	local var_30_4 = arg_30_0.unit_plate:getChildByName("dhp")
	
	if get_cocos_refid(var_30_4) then
		var_30_4:setVisible(true)
		var_30_4:setPercent(arg_30_1:getBrokenHPRatio() * 100)
	end
end

function UIBattleAttackOrder.showSupporterButton(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.dlg:getChildByName("n_supporter")
	
	if arg_31_1 then
		replaceSprite(var_31_0, "thumb", "face/" .. arg_31_1.db.face_id .. "_s.png")
	end
	
	var_31_0:setVisible(arg_31_1 ~= nil)
end

function UIBattleAttackOrder.play(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0:show()
	local var_32_1 = arg_32_0.logic:predictAttackers()
	
	arg_32_1 = arg_32_1 or var_32_1[1]
	
	arg_32_0:activeUnitInfo(arg_32_1)
	arg_32_0:listup(nil, arg_32_2)
end

function UIBattleAttackOrder.hideTargetNumbers(arg_33_0)
	if not get_cocos_refid(arg_33_0.dlg) then
		return 
	end
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.item_ctrls) do
		iter_33_1.tag_ctrl:setVisible(false)
	end
end

function UIBattleAttackOrder.showTargetNumbers(arg_34_0, arg_34_1)
	for iter_34_0, iter_34_1 in pairs(arg_34_0.item_ctrls) do
		iter_34_1.tag_ctrl:setVisible(false)
		
		for iter_34_2, iter_34_3 in ipairs(arg_34_1) do
			if iter_34_3 == iter_34_1.unit then
				iter_34_1:showTargetNumber()
				
				break
			end
		end
	end
end

function UIBattleAttackOrder.showDetail(arg_35_0)
	if get_cocos_refid(arg_35_0.detailed) then
		return 
	end
	
	if BattleUIAction:Find("actionbar.hide") then
		return 
	end
	
	local function var_35_0()
		if not Battle.logic:isRealtimeMode() then
			pause()
		end
		
		if Battle:isReplayMode() then
			BattleUI:hideReplayController()
			Battle:setPause(true)
		end
	end
	
	UIAction:Remove("actionbar.detail")
	
	arg_35_0.detailed = load_dlg("inbattle_order_detail", true, "wnd")
	
	arg_35_0.dlg:addChild(arg_35_0.detailed)
	arg_35_0.detailed:setVisible(false)
	BattleUIAction:Add(SEQ(DELAY(100), SHOW(true), CALL(arg_35_0.fillDetail, arg_35_0), CALL(function()
		BackButtonManager:push({
			check_id = "actionbar.detail",
			back_func = function()
				arg_35_0:hideDetail()
			end
		})
	end), LOG(FADE_IN(200)), CALL(var_35_0)), arg_35_0.detailed, "actionbar.detail")
end

function getStateBanner(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	local var_39_0
	
	if arg_39_3 then
		var_39_0 = arg_39_3:clone()
	else
		var_39_0 = cc.CSLoader:createNode("wnd/inbattle_state.csb")
	end
	
	local var_39_1 = UIUtil:getStateIconPath(arg_39_0, arg_39_1)
	local var_39_2 = if_set_sprite(var_39_0, "icon", var_39_1)
	local var_39_3, var_39_4, var_39_5, var_39_6 = UNIT.getCSDB(arg_39_1, arg_39_0, {
		"name",
		"cs_type",
		"cs_turn",
		"cs_effectexplain"
	})
	local var_39_7 = 1
	
	if arg_39_1 then
		local var_39_8 = arg_39_1.states:find(arg_39_0)
		
		if var_39_8 then
			var_39_7 = var_39_8.stack_count
		end
	end
	
	if var_39_4 == "buff" then
		if_set_color(var_39_0, "turn", cc.c3b(162, 243, 255))
	elseif var_39_4 == "debuff" then
		if_set_color(var_39_0, "turn", cc.c3b(255, 124, 89))
	else
		if_set_color(var_39_0, "turn", cc.c3b(255, 255, 255))
	end
	
	if var_39_6 then
		WidgetUtils:setupTooltip({
			delay = 100,
			control = var_39_2,
			creator = function()
				return UIUtil:getSkillEffectTip(var_39_6, var_39_7)
			end
		})
	end
	
	if not arg_39_4 then
		local var_39_9 = var_39_0:getChildByName("name")
		
		if var_39_3 then
			var_39_9:setString(T(var_39_3))
			if_set_scale_fit_width(var_39_9, nil, 210)
		else
			var_39_9:setString(arg_39_0)
			var_39_9:setScaleX(0.6)
		end
		
		if var_39_4 == "buff" then
			var_39_9:setTextColor(cc.c3b(93, 196, 215))
		elseif var_39_4 ~= "passive" then
			var_39_9:setTextColor(cc.c3b(215, 80, 65))
		elseif var_39_4 == "passive" then
			var_39_9:setTextColor(cc.c3b(0, 0, 0))
		end
	end
	
	if arg_39_2 then
		arg_39_2 = math.max(1, math.min(9, arg_39_2))
		
		if_set_sprite(var_39_0, "turn", "img/itxt_num" .. arg_39_2 .. "_b.png")
		if_set_visible(var_39_0, "turn", var_39_4 ~= "passive" and var_39_5 ~= 0)
	else
		if_set_visible(var_39_0, "turn", false)
	end
	
	return var_39_0
end

function getDevoteBanner(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = cc.CSLoader:createNode("wnd/inbattle_state.csb")
	local var_41_1 = if_set_sprite(var_41_0, "icon", "img/cm_icon_storymap_trust.png")
	local var_41_2 = arg_41_2
	
	if string.ends(arg_41_1, "rate") then
		var_41_2 = arg_41_2 * 100 .. "%"
		arg_41_1 = string.gsub(arg_41_1, "_rate", "")
	end
	
	if_set(var_41_0, "name", T(arg_41_1) .. " + " .. var_41_2)
	if_set_color(var_41_0, "name", cc.c3b(0, 0, 0))
	if_set_visible(var_41_0, "turn", false)
	
	return var_41_0
end

function _fillBuffInfo(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	arg_42_4 = arg_42_4 or 130
	
	local var_42_0 = 0
	local var_42_1 = {}
	
	for iter_42_0, iter_42_1 in pairs(arg_42_2.states.List) do
		if iter_42_1:isValid() and (iter_42_1.db.isshow == "y" or arg_42_5) then
			local var_42_2 = getStateBanner(iter_42_1.id, arg_42_2, iter_42_1.turn, arg_42_1, arg_42_3)
			
			arg_42_0:addChild(var_42_2)
			var_42_2:setPositionX(var_42_0)
			
			var_42_0 = var_42_0 + arg_42_4
			
			table.push(var_42_1, var_42_2)
		end
	end
	
	return var_42_1
end

function UIBattleAttackOrder.fillDetail(arg_43_0)
	local function var_43_0(arg_44_0)
		table.sort(arg_44_0, function(arg_45_0, arg_45_1)
			local var_45_0 = arg_45_0
			local var_45_1 = arg_45_1
			local var_45_2, var_45_3 = var_45_0:getRestTimeAndTick()
			local var_45_4, var_45_5 = var_45_1:getRestTimeAndTick()
			
			if var_45_2 == var_45_4 then
				return var_45_0.status.speed > var_45_1.status.speed
			end
			
			return var_45_2 < var_45_4
		end)
	end
	
	local var_43_1 = {}
	
	for iter_43_0, iter_43_1 in pairs(arg_43_0.logic.units or {}) do
		if not iter_43_1:getResurrectBlock(true) and (arg_43_0.logic:isPVP() or not iter_43_1:isDead()) then
			table.insert(var_43_1, iter_43_1)
		end
	end
	
	if arg_43_0.active_unit then
		local var_43_2
		local var_43_3
		
		for iter_43_2, iter_43_3 in pairs(var_43_1) do
			if iter_43_3 == arg_43_0.active_unit then
				var_43_2 = iter_43_2
				var_43_3 = iter_43_3
				
				break
			end
		end
		
		if var_43_2 and var_43_3 then
			table.remove(var_43_1, var_43_2)
			var_43_0(var_43_1)
			table.insert(var_43_1, 1, var_43_3)
		end
	else
		var_43_0(var_43_1)
	end
	
	local var_43_4 = arg_43_0.detailed
	local var_43_5 = cc.CSLoader:createNode("wnd/inbattle_detail.csb")
	local var_43_6 = cc.CSLoader:createNode("wnd/inbattle_state.csb")
	
	for iter_43_4, iter_43_5 in pairs(var_43_1) do
		local var_43_7 = var_43_4:getChildByName("n_pos" .. iter_43_4)
		local var_43_8, var_43_14
		
		if var_43_7 then
			var_43_8 = var_43_5:clone()
			
			if iter_43_5:isDead() then
				var_43_8:setColor(cc.c3b(83, 83, 83))
			end
			
			var_43_7:addChild(var_43_8)
			
			local var_43_9 = var_43_8:getChildByName("n_hpbar")
			
			if get_cocos_refid(var_43_9) then
				local var_43_10 = HPBar:createForInbattleTab(iter_43_5)
				
				var_43_10.control:setPosition(42, 30)
				var_43_9:setVisible(true)
				var_43_9:addChild(var_43_10.control)
			end
			
			local var_43_11 = 1e-07
			local var_43_12 = math.min(iter_43_5.inst.elapsed_ut, MAX_UNIT_TICK) * 100 / MAX_UNIT_TICK
			local var_43_13 = math.floor(var_43_12 + var_43_11)
			
			if iter_43_4 == 1 then
				var_43_13 = 100
			end
			
			if_set(var_43_8, "t_ut", tostring(var_43_13) .. "%")
			ActionBarItem:create(var_43_8:getChildByName("n_face"), iter_43_5, {
				onActionBar = false
			}).c.btn_face:removeFromParent()
			
			if not iter_43_5:isDead() then
				_fillBuffInfo(var_43_8:getChildByName("n_states"), var_43_6, iter_43_5, true, 32)
			end
			
			function var_43_14(arg_46_0, arg_46_1, arg_46_2)
				if not get_cocos_refid(arg_46_0) then
					return 
				end
				
				local var_46_0, var_46_1, var_46_2, var_46_3, var_46_4 = DB("skill", arg_46_1, {
					"id",
					"sk_show",
					"sk_passive",
					"isshowcooltime",
					"showcooltimeskill"
				})
				
				if arg_46_1 and arg_46_1 ~= "none" and var_46_0 and var_46_1 == "y" then
					arg_46_2 = arg_46_2 or {}
					
					local var_46_5 = {
						no_tooltip = true
					}
					
					if Battle.logic:isPVP() then
						var_46_5 = {
							tooltip_opts = {
								show_effs = "right",
								hide_stat = true
							}
						}
					end
					
					local var_46_6 = UIUtil:getSkillIcon(iter_43_5, arg_46_1, var_46_5)
					
					var_46_6:setLocalZOrder(-1)
					arg_46_0:addChild(var_46_6)
					
					local var_46_7
					
					if var_46_4 then
						var_46_7 = iter_43_5:getSkillByIndex(to_n(var_46_4))
					else
						var_46_7 = arg_46_1
					end
					
					local var_46_8 = iter_43_5:getSkillCool(var_46_7)
					
					if var_46_8 and var_46_8 > 0 then
						if var_46_2 and var_46_3 ~= "y" then
							if_set_visible(arg_46_0, "t_turn", false)
							if_set_visible(arg_46_0, "i_turn", false)
						else
							if_set(arg_46_0, "t_turn", var_46_8)
							
							local var_46_9 = iter_43_5:getSkillBundle():get(var_46_7)
							local var_46_10 = iter_43_5:getSkillMaxCool(var_46_7) or SkillFactory.create(var_46_7, iter_43_5):getTurnCool() or var_46_8
							local var_46_11 = var_46_2 ~= nil and "img/cm_cool_skill_passive.png" or "img/cm_cool_skill.png"
							local var_46_12 = arg_46_0:getChildByName("n_cooltime")
							
							if not get_cocos_refid(var_46_12) then
								return 
							end
							
							local var_46_13 = var_46_12:getChildByName("sk_cool_progress")
							
							if var_46_10 and not get_cocos_refid(var_46_13) then
								var_46_13 = WidgetUtils:createCircleProgress(var_46_11)
								
								var_46_13:setScale(1)
								var_46_13:setOpacity(200)
								var_46_13:setName("sk_cool_progress")
							end
							
							if get_cocos_refid(var_46_13) and var_46_10 then
								var_46_13:setPercentage(var_46_8 * 100 / var_46_10)
							end
							
							if not var_46_12:getChildByName("sk_cool_progress") then
								var_46_12:addChild(var_46_13)
								if_set_visible(arg_46_0, "n_cooltime", true)
							end
						end
					else
						if_set_visible(arg_46_0, "t_turn", false)
						if_set_visible(arg_46_0, "i_turn", false)
					end
				else
					arg_46_0:setVisible(false)
				end
			end
			
			for iter_43_6 = 1, 3 do
				local var_43_15 = UIUtil:getSkillByUIIdx(iter_43_5, iter_43_6)
				local var_43_16 = var_43_8:getChildByName("n_skill" .. iter_43_6)
				
				var_43_14(var_43_16, var_43_15)
			end
		end
	end
end

function UIBattleAttackOrder.hideDetail(arg_47_0)
	if get_cocos_refid(arg_47_0.detailed) then
		resume()
		
		if Battle:isReplayMode() then
			BattleUI:showReplayController()
			Battle:setPause(false)
		end
		
		BattleUIAction:Remove("actionbar.detail")
		
		local var_47_0 = arg_47_0.detailed
		
		for iter_47_0 = 1, 10 do
			local var_47_1 = var_47_0:getChildByName("n_pos" .. iter_47_0)
			
			if var_47_1 then
				var_47_1:removeAllChildren()
			end
		end
		
		if var_47_0:isVisible() then
			BackButtonManager:pop("actionbar.detail")
			BattleUIAction:Add(SEQ(LOG(OPACITY(200, var_47_0:getOpacity() / 255, 0)), SHOW(false)), var_47_0)
		end
		
		arg_47_0.detailed:removeFromParent()
		
		arg_47_0.detailed = nil
	end
end

function UIBattleAttackOrder.initCrehuntTurnInfo(arg_48_0)
	if not get_cocos_refid(arg_48_0.dlg) then
		return 
	end
	
	local var_48_0 = arg_48_0.dlg:getChildByName("n_turn")
	
	if get_cocos_refid(var_48_0) then
		local var_48_1 = var_48_0:getChildByName("n_tooltip")
		
		if get_cocos_refid(var_48_1) then
			if_set(var_48_1, "txt_title", T("ui_crevicehunt_limittrun_popup_name"))
			if_set(var_48_1, "txt_info", T("ui_crevicehunt_limittrun_popup_desc"))
			
			local var_48_2 = var_48_1:getChildByName("txt_info")
			local var_48_3 = 0
			
			if get_cocos_refid(var_48_2) then
				var_48_3 = var_48_2:getStringNumLines()
			end
			
			local var_48_4 = var_48_1:getChildByName("n_bg")
			
			if get_cocos_refid(var_48_4) then
				local var_48_5 = var_48_4:getContentSize()
				
				if var_48_5 and var_48_3 then
					var_48_4:setContentSize(var_48_5.width, var_48_5.height + var_48_3 * 18)
				end
			end
		end
		
		var_48_0:getChildByName("btn_turn"):addTouchEventListener(function(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
			local var_49_0 = false
			local var_49_1 = not (arg_49_1 ~= 0 and arg_49_1 ~= 1) and true or false
			
			arg_48_0:showCrehuntTurnInfo(var_49_1)
		end)
	end
end

function UIBattleAttackOrder.showCrehuntTurnInfo(arg_50_0, arg_50_1)
	if not get_cocos_refid(arg_50_0.dlg) then
		return 
	end
	
	local var_50_0 = arg_50_0.dlg:getChildByName("n_turn")
	
	if get_cocos_refid(var_50_0) then
		if_set_visible(var_50_0, "n_tooltip", arg_50_1)
	end
end

function UIBattleAttackOrder.setTurnInfo(arg_51_0)
	if not arg_51_0.logic or not arg_51_0.logic:isCreviceHunt() or not get_cocos_refid(arg_51_0.dlg) then
		return 
	end
	
	local var_51_0 = arg_51_0.dlg:getChildByName("n_turn")
	
	if get_cocos_refid(var_51_0) then
		local var_51_1 = (GAME_CONTENT_VARIABLE.crevicehunt_limit_turn or 40) + arg_51_0.logic:getCreviceTeamReturnAdd() - (arg_51_0.logic and arg_51_0.logic:getTeamStageCounter("friend") or 0)
		
		if var_51_1 < 0 then
			var_51_1 = 0
		end
		
		if_set(var_51_0, "txt_count", var_51_1)
	end
end
