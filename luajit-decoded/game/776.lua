SPLRingUI = {}

function HANDLER.spl_select_menu(arg_1_0, arg_1_1)
	if UIAction:Find("inter_ui_fade") then
		return 
	end
	
	if not SPLRingUI.vars then
		return 
	end
	
	if arg_1_1 == "btn_move" then
		SPLRingUI:moveTo()
	end
	
	if arg_1_1 == "btn_detail" then
		SPLRingUI:detail()
	end
	
	if arg_1_1 == "btn_battle" then
		SPLRingUI:battle()
	end
	
	if arg_1_1 == "btn_open" then
		SPLRingUI:useObject()
	end
end

function SPLRingUI.moveTo(arg_2_0)
	local var_2_0 = arg_2_0.vars.tile:getPos()
	local var_2_1 = SPLMovableSystem:getMovableById(SPLMovableSystem:getCurrentPlayerId())
	local var_2_2 = SPLPathFindingSystem:find(var_2_1:getPos(), var_2_0, var_2_1:getMoveCell())
	
	if var_2_2 then
		SPLSystem:procMovePath(SPLMovableSystem:getCurrentPlayerId(), var_2_2)
	end
	
	arg_2_0:close()
end

function SPLRingUI.isObjectUsable(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.vars.tile
	local var_3_1 = var_3_0.inst
	
	if not var_3_1 or not var_3_1.object_id then
		if arg_3_2 then
			return false
		end
		
		if arg_3_1 == "use" then
			balloon_message_with_sound("msg_clanheritage_ring_error_use")
		elseif arg_3_1 == "battle" then
			balloon_message_with_sound("msg_clanheritage_ring_error_battle")
		elseif arg_3_1 == "commu" then
			balloon_message_with_sound("msg_clanheritage_ring_error_commu")
		end
		
		return false
	end
	
	local var_3_2 = SPLObjectSystem:getObject(var_3_0:getTileId())
	local var_3_3 = SPLMovableSystem:calcPlayerMoveCost(var_3_0:getPos())
	
	if not arg_3_3 and var_3_3 > 1 then
		local var_3_4 = var_3_2:getChildTileList()
		local var_3_5 = false
		
		for iter_3_0, iter_3_1 in pairs(var_3_4 or {}) do
			local var_3_6 = SPLTileMapSystem:getTileById(iter_3_1)
			
			if not (SPLMovableSystem:calcPlayerMoveCost(var_3_6:getPos()) > 1) then
				var_3_5 = true
				
				break
			end
		end
		
		local var_3_7 = SPLTileMapSystem:getTileById(var_3_2:getUID())
		
		if not (SPLMovableSystem:calcPlayerMoveCost(var_3_7:getPos()) > 1) then
			var_3_5 = true
		end
		
		if not var_3_5 then
			if arg_3_2 then
				return false
			end
			
			balloon_message_with_sound("msg_clanheritage_ring_too_far")
			
			return false
		end
	end
	
	if not var_3_2:isActive() then
		if arg_3_2 then
			return false
		end
		
		balloon_message_with_sound("msg_clanheritage_ring_use_complete")
		
		return false
	end
	
	if var_3_2:isClanObject() and var_3_2:isUsedClanObject() then
		if arg_3_2 then
			return false
		end
		
		balloon_message_with_sound("msg_clanheritage_ring_use_max")
		
		return false
	end
	
	return true
end

function SPLRingUI.useObject(arg_4_0)
	local var_4_0 = arg_4_0.vars.tile
	local var_4_1 = var_4_0.inst
	
	if not arg_4_0:isObjectUsable("use") then
		return 
	end
	
	if not arg_4_0:isTileOnObjectOpen(var_4_0) then
		return 
	end
	
	SPLObjectSystem:onUseObject(var_4_0:getTileId())
	arg_4_0:close()
end

function SPLRingUI.battle(arg_5_0)
	local var_5_0 = arg_5_0.vars.tile
	local var_5_1 = var_5_0.inst
	
	if not arg_5_0:isObjectUsable("battle") then
		return 
	end
	
	local var_5_2 = SPLObjectSystem:getObjectType(var_5_0:getTileId())
	
	if not string.find(var_5_2, "monster") then
		balloon_message_with_sound("msg_clanheritage_ring_error_battle")
		
		return 
	end
	
	SPLObjectSystem:onUseObject(var_5_0:getTileId())
	arg_5_0:close()
end

function SPLRingUI.detail(arg_6_0)
	local var_6_0 = arg_6_0.vars.tile
	local var_6_1 = arg_6_0:isTileOnObject(var_6_0)
	
	if var_6_1 then
		balloon_message_with_sound("msg_clanheritage_ring_error_detail")
		
		return 
	end
	
	if arg_6_0:removeTooltip("detail_tooltip") then
		return 
	end
	
	if var_6_1 and arg_6_0:isTileRequireDetail(var_6_0) and (not arg_6_0:isTileOnObjectMonster(var_6_0, true) or arg_6_0:isTileOnObjectMonster(var_6_0)) then
		SPLObjectSystem:onDetailObject(var_6_0:getTileId())
	end
end

function SPLRingUI.isTileOnObject(arg_7_0, arg_7_1)
	if not arg_7_1.inst or not arg_7_1.inst.object_id then
		return false
	end
	
	local var_7_0 = SPLObjectSystem:getObjectType(arg_7_1:getTileId())
	
	return var_7_0 ~= "overlap" and var_7_0 ~= "empty"
end

function SPLRingUI.isTileMovable(arg_8_0, arg_8_1)
	if not arg_8_1:isMovable() then
		return 
	end
	
	return SPLMovableSystem:calcPlayerRealCost(arg_8_1:getPos()) ~= -1
end

function SPLRingUI.isTileRequireDetail(arg_9_0, arg_9_1)
	return arg_9_0:isTileOnObject(arg_9_1)
end

function SPLRingUI.isTileOnObjectOpen(arg_10_0, arg_10_1)
	if not arg_10_0:isTileOnObjectActive(arg_10_1) then
		return 
	end
	
	local var_10_0 = SPLObjectSystem:getObjectType(arg_10_1:getTileId())
	
	return ({
		usable = true
	})[var_10_0]
end

function SPLRingUI.isTileOnObjectActive(arg_11_0, arg_11_1)
	if not arg_11_0:isTileOnObject(arg_11_1) then
		return 
	end
	
	return SPLObjectSystem:isObjectActive(arg_11_1:getTileId())
end

function SPLRingUI.isTileOnObjectMonster(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0:isTileOnObject(arg_12_1) then
		return 
	end
	
	local var_12_0 = SPLObjectSystem:getObjectType(arg_12_1:getTileId()) or ""
	local var_12_1 = SPLObjectSystem:isObjectActive(arg_12_1:getTileId())
	
	if not arg_12_2 then
		return string.find(var_12_0, "monster") and var_12_1
	else
		return string.find(var_12_0, "monster")
	end
end

function SPLRingUI.getSelectedTile(arg_13_0)
	return arg_13_0.vars.tile
end

function SPLRingUI.getSelectedTileId(arg_14_0)
	if not arg_14_0.vars or not arg_14_0.vars.tile then
		return 
	end
	
	return arg_14_0.vars.tile:getTileId()
end

function SPLRingUI.isActive(arg_15_0)
	return arg_15_0.vars and get_cocos_refid(arg_15_0._dlg) and arg_15_0._dlg:isVisible()
end

function SPLRingUI.getDlg(arg_16_0)
	return arg_16_0._dlg
end

function SPLRingUI.open(arg_17_0, arg_17_1)
	arg_17_0._inter_info_flag = false
	
	if SPLUtil:isTileHaveAddSelect(arg_17_1) then
		local var_17_0 = SPLObjectSystem:getObject(arg_17_1:getTileId())
		
		if var_17_0 then
			arg_17_1 = SPLTileMapSystem:getTileById(var_17_0:getUID())
		end
	end
	
	arg_17_0:updateUsableButtonFlags(arg_17_1)
	
	if not arg_17_0:isAvailable() then
		balloon_message_with_sound("tile_sub_move_disable")
		
		return 
	end
	
	if UIAction:Find("inter_ui_fade") then
		UIAction:Remove("inter_ui_fade")
	end
	
	if get_cocos_refid(arg_17_0._tooltip) then
		arg_17_0._tooltip:removeFromParent()
	end
	
	arg_17_0.vars = {}
	arg_17_0.vars.tile = arg_17_1
	
	arg_17_0:updateUI(arg_17_1)
	arg_17_0:showTileFocusAni()
	
	return true
end

function SPLRingUI.fadeIn(arg_18_0)
	local var_18_0 = arg_18_0._dlg:findChildByName("n_select menu")
	
	var_18_0:setScale(0.2)
	var_18_0:setOpacity(0)
	var_18_0:setRotation(0)
	UIAction:Add(SPAWN(LOG(ROTATE(40, 0, 360)), LOG(SCALE(40, 0.2, 1)), FADE_IN(40)), var_18_0)
	if_set_visible(var_18_0, "n_btn_fix", false)
	
	local var_18_1 = arg_18_0:getUsableButtons()
	
	for iter_18_0, iter_18_1 in pairs(var_18_1) do
		if not iter_18_1._origin_pos then
			local var_18_2, var_18_3 = iter_18_1:getPosition()
			
			iter_18_1._origin_pos = {
				x = var_18_2,
				y = var_18_3
			}
		end
		
		if not iter_18_1._origin_pos then
			iter_18_1._origin_pos = {
				x = iter_18_1:getPositionX(),
				y = iter_18_1:getPositionY()
			}
		end
		
		iter_18_1:setPosition(0, 0)
		
		local var_18_4 = "n_btn1_1"
		
		if iter_18_1:getName() == "btn_detail" then
			var_18_4 = "n_btn_fix"
		end
		
		local var_18_5, var_18_6 = var_18_0:findChildByName(var_18_4):getPosition()
		
		iter_18_1:setOpacity(0)
		UIAction:Add(SEQ(CALL(function()
			iter_18_1:setTouchEnabled(false)
		end), DELAY(40), DELAY((iter_18_0 - 1) * 10), SPAWN(LOG(MOVE_TO(60, var_18_5, var_18_6)), FADE_IN(60)), CALL(function()
			iter_18_1:setTouchEnabled(true)
		end)), iter_18_1, "inter_ui_fade")
	end
end

function SPLRingUI.fadeOut(arg_21_0)
	arg_21_0:hideTileFocusAni()
	
	local var_21_0 = arg_21_0._dlg:findChildByName("n_select menu")
	
	var_21_0:setScale(1)
	var_21_0:setOpacity(255)
	UIAction:Add(SPAWN(LOG(ROTATE(40, 0, -360)), LOG(SCALE(40, 1, 0.2)), FADE_OUT(40)), var_21_0)
	
	local var_21_1 = arg_21_0:getUsableButtons()
	
	for iter_21_0, iter_21_1 in pairs(var_21_1) do
		iter_21_1:setOpacity(255)
		UIAction:Add(SEQ(DELAY(40), DELAY((iter_21_0 - 1) * 10), SPAWN(LOG(MOVE_TO(60, 0, 0)), FADE_OUT(60))), iter_21_1)
	end
end

function SPLRingUI.updatePosition(arg_22_0, arg_22_1)
	if not get_cocos_refid(arg_22_0._dlg) or not arg_22_1 then
		return 
	end
	
	local var_22_2
	
	if SPLUtil:isTileHaveAddSelect(arg_22_1) then
		local var_22_0 = SPLObjectSystem:getObject(arg_22_1:getTileId())
		local var_22_1 = table.clone(var_22_0:getChildTileList())
		
		table.insert(var_22_1, var_22_0:getUID())
		
		var_22_2 = 0
		
		for iter_22_0, iter_22_1 in pairs(var_22_1) do
			local var_22_3 = SPLTileMapSystem:getTileById(iter_22_1)
			local var_22_4 = var_22_3:getPos().y
			
			if var_22_2 < var_22_4 then
				var_22_2 = var_22_4
				arg_22_1 = var_22_3
			end
		end
	end
	
	local var_22_5 = SPLUtil:calcTilePosToWorldPos(arg_22_1:getPos())
	local var_22_6 = var_22_5.x
	local var_22_7 = var_22_5.y + 90
	local var_22_8 = arg_22_1:getTileId()
	local var_22_9 = -60
	
	if SPLObjectRenderer:findObject(var_22_8) then
		var_22_7 = SPLObjectRenderer:getFocusYPosition(var_22_8) + var_22_9
	end
	
	local var_22_10 = SPLMovableSystem:getMovablesByPos(arg_22_1:getPos()) or {}
	
	if #var_22_10 == 1 then
		var_22_7 = SPLMovableRenderer:getFocusYPosition(var_22_10[1]:getUID()) + var_22_9
	end
	
	arg_22_0._dlg:setPosition(var_22_6, var_22_7)
end

function SPLRingUI.recoverInfoUIVisible(arg_23_0)
	if arg_23_0._last_select_object_id and arg_23_0._inter_info_flag then
		SPLObjectRenderer:setVisibleInfo(arg_23_0._last_select_object_id, true)
		
		arg_23_0._last_select_object_id = nil
	end
	
	if arg_23_0._last_select_movable_id then
		SPLMovableRenderer:setVisibleInfo(arg_23_0._last_select_movable_id, true)
		
		arg_23_0._last_select_movable_id = nil
	end
end

function SPLRingUI.updateInfoUIVisible(arg_24_0, arg_24_1)
	arg_24_0:recoverInfoUIVisible()
	
	local var_24_0 = arg_24_1:getTileId()
	
	if SPLObjectRenderer:findObject(var_24_0) and arg_24_0:isTileOnObjectMonster(arg_24_1) and arg_24_0._inter_info_flag then
		SPLObjectRenderer:setVisibleInfo(var_24_0, false)
		
		arg_24_0._last_select_object_id = var_24_0
	else
		local var_24_1 = SPLMovableSystem:getMovablesByPos(arg_24_1:getPos()) or {}
		
		if #var_24_1 == 1 then
			local var_24_2 = var_24_1[1]:getUID()
			
			SPLMovableRenderer:setVisibleInfo(var_24_2, false)
			
			arg_24_0._last_select_movable_id = var_24_2
		end
	end
end

function SPLRingUI.updateInfo(arg_25_0, arg_25_1)
end

function SPLRingUI.updateUsableButtonFlags(arg_26_0, arg_26_1)
	arg_26_0._usable_btn_flags = {
		btn_detail = false,
		btn_interaction = false,
		btn_move = arg_26_0:isTileMovable(arg_26_1) or false,
		btn_open = arg_26_0:isTileOnObjectOpen(arg_26_1) or false,
		btn_battle = arg_26_0:isTileOnObjectMonster(arg_26_1) or false
	}
end

function SPLRingUI.updateUsableButtonUI(arg_27_0)
	for iter_27_0, iter_27_1 in pairs(arg_27_0._usable_btn_flags) do
		if_set_visible(arg_27_0._dlg, iter_27_0, iter_27_1)
	end
end

function SPLRingUI.isAvailable(arg_28_0)
	for iter_28_0, iter_28_1 in pairs(arg_28_0._usable_btn_flags) do
		if iter_28_1 then
			return true
		end
	end
	
	return false
end

function SPLRingUI.getUsableButtons(arg_29_0)
	if not arg_29_0._btn_list then
		return {}
	end
	
	local var_29_0 = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0._usable_btn_flags) do
		if iter_29_1 then
			local var_29_1 = arg_29_0._btn_name_to_idx[iter_29_0]
			local var_29_2 = arg_29_0._btn_list[var_29_1]
			
			if get_cocos_refid(var_29_2) then
				table.insert(var_29_0, var_29_2)
			end
		end
	end
	
	return var_29_0
end

function SPLRingUI.isTooltipActive(arg_30_0)
	return arg_30_0.vars and get_cocos_refid(arg_30_0._tooltip)
end

function SPLRingUI.removeTooltip(arg_31_0, arg_31_1)
	if get_cocos_refid(arg_31_0._tooltip) then
		local var_31_0 = arg_31_0._tooltip[arg_31_1]
		
		arg_31_0._tooltip:removeFromParent()
		
		arg_31_0._tooltip = nil
		
		if var_31_0 then
			return true
		end
	end
	
	return false
end

function SPLRingUI.attachTooltip(arg_32_0, arg_32_1)
	arg_32_0._dlg:addChild(arg_32_1)
	
	arg_32_0._tooltip = arg_32_1
	
	local var_32_0 = arg_32_1:getContentSize()
	local var_32_1 = 50
	local var_32_2 = VIEW_HEIGHT - var_32_0.height - var_32_1
	local var_32_3 = 100
	local var_32_4 = {
		{
			x = 285,
			y = 100
		},
		{
			x = -185,
			y = 100
		}
	}
	local var_32_5 = 1
	local var_32_6 = 100000
	
	for iter_32_0, iter_32_1 in pairs(var_32_4) do
		arg_32_0._tooltip:setPosition(iter_32_1.x, iter_32_1.y)
		
		local var_32_7 = SceneManager:convertToSceneSpace(arg_32_0._tooltip, {
			x = 0,
			y = 0
		})
		local var_32_8 = math.abs(VIEW_WIDTH / 2 - var_32_7.x)
		
		if var_32_2 < var_32_7.y then
			iter_32_1.y = iter_32_1.y - (var_32_7.y - var_32_2)
		elseif var_32_3 > var_32_7.y then
			iter_32_1.y = iter_32_1.y + (var_32_3 - var_32_7.y)
		end
		
		if var_32_8 < var_32_6 then
			var_32_6 = var_32_8
			var_32_5 = iter_32_0
		end
	end
	
	local var_32_9 = var_32_4[var_32_5]
	
	arg_32_0._tooltip:setPosition(var_32_9.x, var_32_9.y)
	arg_32_0:fadeOut()
end

function SPLRingUI.openDetailTooltip(arg_33_0, arg_33_1)
	local var_33_0 = ItemTooltip:getItemTooltip({
		code = arg_33_1.db.id,
		lota_object_type = arg_33_1:getTypeDetail(),
		lota_object = arg_33_1
	})
	
	var_33_0.detail_tooltip = true
	
	arg_33_0:attachTooltip(var_33_0)
end

function SPLRingUI.updateUI(arg_34_0, arg_34_1)
	if not get_cocos_refid(arg_34_0._dlg) then
		arg_34_0._dlg = load_dlg("clan_heritage_select_menu", true, "wnd")
		
		arg_34_0._dlg:setName("spl_select_menu")
		
		arg_34_0._btn_list = {
			arg_34_0._dlg:findChildByName("btn_move"),
			arg_34_0._dlg:findChildByName("btn_detail"),
			arg_34_0._dlg:findChildByName("btn_open"),
			arg_34_0._dlg:findChildByName("btn_battle"),
			arg_34_0._dlg:findChildByName("btn_interaction")
		}
		arg_34_0._btn_name_to_idx = {
			btn_detail = 2,
			btn_battle = 4,
			btn_interaction = 5,
			btn_move = 1,
			btn_open = 3
		}
		
		for iter_34_0, iter_34_1 in pairs(arg_34_0._btn_list) do
			iter_34_1:setTouchEnabled(true)
		end
		
		if_set_visible(arg_34_0._dlg, "btn_close", false)
		SPLFieldUI:addFieldUI(arg_34_0._dlg, {
			id = "ring_menu"
		})
	end
	
	if_set_visible(arg_34_0._dlg, "n_select menu", true)
	if_set_visible(arg_34_0._dlg, nil, true)
	arg_34_0:updateUsableButtonUI()
	arg_34_0:updatePosition(arg_34_1)
	arg_34_0:updateButtonIcon(arg_34_1)
	arg_34_0:fadeIn()
	
	local var_34_0 = SPLObjectSystem:getObject(arg_34_1:getTileId())
	
	if var_34_0 then
		table.print(var_34_0.inst, 2)
	end
end

function SPLRingUI.close(arg_35_0)
	local var_35_0 = CALL(SPLRingUI.fadeOut, SPLRingUI)
	
	if get_cocos_refid(arg_35_0._tooltip) then
		arg_35_0._tooltip:removeFromParent()
		
		arg_35_0._tooltip = nil
		var_35_0 = DELAY(0)
	end
	
	UIAction:Add(SEQ(var_35_0, CALL(SPLTileMapRenderer.unmarking, SPLTileMapRenderer), SPAWN(DELAY(340), CALL(function()
		arg_35_0:recoverInfoUIVisible()
		SPLFieldUI:removeFieldUI("ring_menu")
		
		arg_35_0.vars = nil
	end))), arg_35_0._dlg, "inter_ui_fade")
end

function SPLRingUI.updateButtonIcon(arg_37_0, arg_37_1)
	if not get_cocos_refid(arg_37_0._dlg) then
		return 
	end
	
	local var_37_0 = SPLObjectSystem:getObject(arg_37_1:getTileId())
	
	if not var_37_0 then
		return 
	end
	
	local var_37_1 = var_37_0:getButtonText()
	local var_37_2 = var_37_0:getButtonIcon()
	local var_37_3 = arg_37_0._dlg:getChildByName("btn_open")
	
	if get_cocos_refid(var_37_3) then
		if_set_visible(var_37_3, "n_item", false)
		if_set_visible(var_37_3, "n_count", false)
		
		if var_37_1 then
			if_set(var_37_3, "t_open", T(var_37_1))
		end
		
		if var_37_2 then
			if_set_sprite(var_37_3, "icon", "img/" .. var_37_2 .. ".png")
		end
		
		if_set_visible(var_37_3, "icon", true)
		if_set_visible(var_37_3, "n_normal", true)
	end
end

function SPLRingUI.tileFocusOpacity(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = 8
	local var_38_1 = SPLTileMapSystem:getTileById(arg_38_1):getPos()
	local var_38_2 = HTUtil:getDiscoverRange(var_38_1, var_38_0)
	local var_38_3 = SPLObjectSystem:getObject(arg_38_1)
	local var_38_4 = {}
	
	if var_38_3 then
		var_38_4 = var_38_3:getChildTileList()
	end
	
	local var_38_5 = SPLObjectRenderer:getObjectList() or {}
	local var_38_6 = math.ceil((255 - arg_38_2) / var_38_0)
	
	for iter_38_0, iter_38_1 in pairs(var_38_2) do
		local var_38_7 = SPLTileMapSystem:getTileIdByPos(iter_38_1)
		local var_38_8 = var_38_4 and table.isInclude(var_38_4, var_38_7)
		
		if var_38_7 and not var_38_8 and arg_38_1 ~= var_38_7 then
			local var_38_9 = HTUtil:getTileCost(var_38_1, iter_38_1)
			local var_38_10 = var_38_5[var_38_7]
			
			if var_38_10 then
				local var_38_11 = math.min(255, arg_38_2 + var_38_6 * var_38_9) / 255
				
				if arg_38_2 < 255 then
					UIAction:Add(SEQ(OPACITY(320, 1, var_38_11)), var_38_10)
				else
					UIAction:Add(SEQ(OPACITY(320, var_38_10:getOpacity() / 255, 1)), var_38_10)
				end
			end
		end
	end
end

function SPLRingUI.showTileFocusAni(arg_39_0)
	if arg_39_0.vars and arg_39_0.vars.tile then
		local var_39_0 = arg_39_0.vars.tile:getTileId()
		
		arg_39_0:tileFocusOpacity(var_39_0, 75)
	end
	
	arg_39_0:showVignetting()
end

function SPLRingUI.hideTileFocusAni(arg_40_0)
	if arg_40_0.vars and arg_40_0.vars.tile then
		local var_40_0 = arg_40_0.vars.tile:getTileId()
		
		arg_40_0:tileFocusOpacity(var_40_0, 255)
	end
	
	arg_40_0:HideVignetting()
end

function SPLRingUI.showVignetting(arg_41_0)
	if get_cocos_refid(arg_41_0._dlg) then
		arg_41_0:HideVignetting()
		
		local var_41_0 = LotaUtil:makeVignetting(arg_41_0._dlg:getPositionX(), arg_41_0._dlg:getPositionY())
		
		SPLFieldUI:addFieldUI(var_41_0, {
			id = "ring_vignet"
		})
		UIAction:Add(SEQ(OPACITY(320, 0, 0.4)), var_41_0)
		
		arg_41_0._vignet = var_41_0
	end
end

function SPLRingUI.HideVignetting(arg_42_0)
	SPLFieldUI:removeFieldUI("ring_vignet")
end
