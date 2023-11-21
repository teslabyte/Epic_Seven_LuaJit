LotaInteractiveUI = {}

function HANDLER.clan_heritage_select_menu(arg_1_0, arg_1_1)
	if UIAction:Find("inter_ui_fade") then
		return 
	end
	
	if not LotaInteractiveUI.vars then
		return 
	end
	
	if arg_1_1 == "btn_move" then
		LotaInteractiveUI:moveTo()
	end
	
	if arg_1_1 == "btn_interaction" then
		LotaInteractiveUI:openMemoInputTooltip()
	end
	
	if arg_1_1 == "btn_detail" then
		LotaInteractiveUI:detail()
	end
	
	if arg_1_1 == "btn_battle" then
		LotaInteractiveUI:battle()
	end
	
	if arg_1_1 == "btn_open" then
		LotaInteractiveUI:useObject()
	end
end

function HANDLER.clan_heritage_group_info(arg_2_0, arg_2_1)
end

function HANDLER.clan_heritage_group_info_item(arg_3_0, arg_3_1)
end

function HANDLER.clan_heritage_mark_list(arg_4_0, arg_4_1)
	if string.find(arg_4_1, "btn_mark") then
		local var_4_0 = string.sub(arg_4_1, -1)
		
		LotaMemoInputView:sendQuery(var_4_0)
		LotaSystem:setBlockCoolTime()
	end
end

function LotaInteractiveUI.cheat_double_call(arg_5_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.tile:getTileId()
	
	LotaNetworkSystem:sendQuery("lota_interaction_object", {
		tile_id = var_5_0
	})
	LotaNetworkSystem:sendQuery("lota_interaction_object", {
		tile_id = var_5_0
	})
end

function LotaInteractiveUI.cheat_warp(arg_6_0)
	local var_6_0 = arg_6_0.vars.tile:getTileId()
	
	LotaNetworkSystem:sendQuery("lota_cheat_warp", {
		tile_id = var_6_0
	})
end

function LotaInteractiveUI.moveTo(arg_7_0)
	local var_7_0 = arg_7_0.vars.tile:getPos()
	local var_7_1 = LotaMovableSystem:calcPlayerRealCost(var_7_0)
	
	print("Cost : ", var_7_1)
	
	if var_7_1 ~= -1 then
		if LotaNetworkSystem:procMoveTo(var_7_0) then
			LotaTileRenderer:revertMovableArea(true)
		end
		
		arg_7_0:close()
	end
end

function LotaInteractiveUI.isObjectUsable(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0.vars.tile
	local var_8_1 = var_8_0.inst
	
	if LotaHeroInformationUI:isShow() then
		return false
	end
	
	if not var_8_1 or not var_8_1.object_id then
		if arg_8_2 then
			return false
		end
		
		if arg_8_1 == "use" then
			balloon_message_with_sound("msg_clanheritage_ring_error_use")
		elseif arg_8_1 == "battle" then
			balloon_message_with_sound("msg_clanheritage_ring_error_battle")
		elseif arg_8_1 == "commu" then
			balloon_message_with_sound("msg_clanheritage_ring_error_commu")
		end
		
		return false
	end
	
	local var_8_2 = LotaObjectSystem:getObject(var_8_0:getTileId())
	local var_8_3 = LotaMovableSystem:calcPlayerMoveCost(var_8_0:getPos())
	
	if not arg_8_3 and var_8_3 > 1 then
		local var_8_4 = var_8_2:getChildTileList()
		local var_8_5 = false
		
		for iter_8_0, iter_8_1 in pairs(var_8_4 or {}) do
			local var_8_6 = LotaTileMapSystem:getTileById(iter_8_1)
			
			if not (LotaMovableSystem:calcPlayerMoveCost(var_8_6:getPos()) > 1) then
				var_8_5 = true
				
				break
			end
		end
		
		local var_8_7 = LotaTileMapSystem:getTileById(var_8_2:getUID())
		
		if not (LotaMovableSystem:calcPlayerMoveCost(var_8_7:getPos()) > 1) then
			var_8_5 = true
		end
		
		if not var_8_5 then
			if arg_8_2 then
				return false
			end
			
			balloon_message_with_sound("msg_clanheritage_ring_too_far")
			
			return false
		end
	end
	
	if not var_8_2:isActive() then
		if arg_8_2 then
			return false
		end
		
		balloon_message_with_sound("msg_clanheritage_ring_use_complete")
		
		return false
	end
	
	if var_8_2:isClanObject() and var_8_2:isUsedClanObject() then
		if arg_8_2 then
			return false
		end
		
		balloon_message_with_sound("msg_clanheritage_ring_use_max")
		
		return false
	end
	
	return true
end

function LotaInteractiveUI.useObject(arg_9_0)
	local var_9_0 = arg_9_0.vars.tile
	local var_9_1 = var_9_0.inst
	
	if not arg_9_0:isObjectUsable("use") then
		return 
	end
	
	if not arg_9_0:isTileOnObjectOpen(var_9_0) then
		return 
	end
	
	if not arg_9_0:isActionPointEnough(var_9_0) then
		return 
	end
	
	LotaObjectSystem:onUseObject(var_9_0:getTileId())
	arg_9_0:close()
end

function LotaInteractiveUI.battle(arg_10_0)
	local var_10_0 = arg_10_0.vars.tile
	local var_10_1 = var_10_0.inst
	
	if not arg_10_0:isObjectUsable("battle") then
		return 
	end
	
	local var_10_2 = LotaObjectSystem:getObjectType(var_10_0:getTileId())
	
	if not string.find(var_10_2, "monster") then
		balloon_message_with_sound("msg_clanheritage_ring_error_battle")
		
		return 
	end
	
	if not LotaUtil:isSlotHaveRemainEnterCount(var_10_0:getTileId()) then
		balloon_message_with_sound("msg_clan_heritage_normal_warning")
		
		return 
	end
	
	LotaObjectSystem:onUseObject(var_10_0:getTileId())
	arg_10_0:close()
end

function LotaInteractiveUI.detail(arg_11_0)
	local var_11_0 = arg_11_0.vars.tile
	local var_11_1 = var_11_0:getPos()
	local var_11_2 = LotaMovableSystem:getMovablesByPos(var_11_1)
	local var_11_3 = arg_11_0:isTileRequirePlayersInfo(var_11_0, var_11_2)
	local var_11_4 = arg_11_0:isTileOnObject(var_11_0)
	
	if not var_11_4 and not var_11_3 then
		balloon_message_with_sound("msg_clanheritage_ring_error_detail")
		
		return 
	end
	
	if arg_11_0:removeTooltip("detail_tooltip") then
		return 
	end
	
	if var_11_4 and arg_11_0:isTileRequireDetail(var_11_0) and (not arg_11_0:isTileOnObjectMonster(var_11_0, true) or arg_11_0:isTileOnObjectMonster(var_11_0)) then
		LotaObjectSystem:onDetailObject(var_11_0:getTileId())
	elseif var_11_3 then
		arg_11_0:openPlayersInfoTooltip(var_11_2)
	end
end

function LotaInteractiveUI.isTileOnObject(arg_12_0, arg_12_1)
	if not arg_12_1.inst or not arg_12_1.inst.object_id then
		return false
	end
	
	local var_12_0 = LotaObjectSystem:getObjectType(arg_12_1:getTileId())
	
	return var_12_0 ~= "overlap" and var_12_0 ~= "floating_tile_dest"
end

function LotaInteractiveUI.isTileRequirePlayersInfo(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_1:getPos()
	
	arg_13_2 = arg_13_2 or LotaMovableSystem:getMovablesByPos(var_13_0)
	
	return table.count(arg_13_2 or {}) > 1
end

function LotaInteractiveUI.isActionPointEnough(arg_14_0, arg_14_1)
	if LotaObjectSystem:getObject(arg_14_1:getTileId()):getCost() > LotaUserData:getActionPoint() then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return false
	end
	
	return true
end

function LotaInteractiveUI.isTileMovable(arg_15_0, arg_15_1)
	if not arg_15_1:isMovable() then
		return 
	end
	
	return LotaMovableSystem:calcPlayerRealCost(arg_15_1:getPos()) ~= -1
end

function LotaInteractiveUI.isTileRequireDetail(arg_16_0, arg_16_1)
	if arg_16_0:isTileRequirePlayersInfo(arg_16_1) then
		return true
	end
	
	if arg_16_0:isTileOnObjectMonster(arg_16_1, true) then
		return arg_16_0:isTileOnObjectActive(arg_16_1)
	elseif arg_16_0:isTileOnObject(arg_16_1) then
		return true
	end
	
	return false
end

function LotaInteractiveUI.isTileOnObjectOpen(arg_17_0, arg_17_1)
	if not arg_17_0:isTileOnObject(arg_17_1) then
		return 
	end
	
	local var_17_0 = LotaObjectSystem:getObjectType(arg_17_1:getTileId())
	
	return not ({
		keeper_monster = true,
		elite_monster = true,
		overlap = true,
		boss_monster = true,
		normal_monster = true
	})[var_17_0] and arg_17_0:isTileOnObjectActive(arg_17_1) and arg_17_0:isObjectUsable(nil, true, true)
end

function LotaInteractiveUI.isTileOnObjectActive(arg_18_0, arg_18_1)
	if not arg_18_0:isTileOnObject(arg_18_1) then
		return 
	end
	
	return LotaObjectSystem:isObjectActive(arg_18_1:getTileId())
end

function LotaInteractiveUI.isTileOnObjectMonster(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0:isTileOnObject(arg_19_1) then
		return 
	end
	
	local var_19_0 = LotaObjectSystem:getObjectType(arg_19_1:getTileId())
	local var_19_1 = LotaObjectSystem:isObjectActive(arg_19_1:getTileId())
	
	if not arg_19_2 then
		return string.find(var_19_0, "monster") and var_19_1
	else
		return string.find(var_19_0, "monster")
	end
end

function LotaInteractiveUI.isTileOnObjectInteraction(arg_20_0, arg_20_1)
	return true
end

function LotaInteractiveUI.getSelectedTile(arg_21_0)
	return arg_21_0.vars.tile
end

function LotaInteractiveUI.getSelectedTileId(arg_22_0)
	if not arg_22_0.vars or not arg_22_0.vars.tile then
		return 
	end
	
	return arg_22_0.vars.tile:getTileId()
end

function LotaInteractiveUI.isActive(arg_23_0)
	return arg_23_0.vars and get_cocos_refid(arg_23_0._dlg) and arg_23_0._dlg:isVisible()
end

function LotaInteractiveUI.getDlg(arg_24_0)
	return arg_24_0._dlg
end

function LotaInteractiveUI.open(arg_25_0, arg_25_1)
	arg_25_0._inter_info_flag = false
	
	local var_25_0 = arg_25_1:getPos()
	
	if LotaFogSystem:getFogVisibility(var_25_0.x, var_25_0.y) == LotaFogVisibilityEnum.NOT_DISCOVER then
		return 
	end
	
	if not arg_25_1:isMovable() and not arg_25_1:isExistObject() then
		balloon_message_with_sound("msg_clanheritage_ring_cant_go")
		
		return 
	end
	
	if UIAction:Find("inter_ui_fade") then
		UIAction:Remove("inter_ui_fade")
	end
	
	if get_cocos_refid(arg_25_0._tooltip) then
		arg_25_0._tooltip:removeFromParent()
	end
	
	local var_25_1 = arg_25_1:getTileId()
	
	if arg_25_0:isTileOnObjectMonster(arg_25_1) and LotaObjectSystem:isObjectDead(var_25_1) then
		if LotaObjectSystem:getObjectType(arg_25_1:getTileId()) == "boss_monster" then
			LotaNetworkSystem:sendQuery("lota_next_floor")
		end
		
		return 
	end
	
	if LotaUtil:isTileHaveAddSelect(arg_25_1) then
		local var_25_2 = LotaObjectSystem:getObject(arg_25_1:getTileId())
		
		if var_25_2 then
			arg_25_1 = LotaTileMapSystem:getTileById(var_25_2:getUID())
		end
	end
	
	arg_25_0.vars = {}
	arg_25_0.vars.tile = arg_25_1
	
	arg_25_0:updateUI(arg_25_1)
	arg_25_0:showTileFocusAni()
	
	return true
end

function LotaInteractiveUI.fadeIn(arg_26_0)
	local var_26_0 = arg_26_0._dlg:findChildByName("n_select menu")
	
	var_26_0:setScale(0.2)
	var_26_0:setOpacity(0)
	var_26_0:setRotation(0)
	UIAction:Add(SPAWN(LOG(ROTATE(40, 0, 360)), LOG(SCALE(40, 0.2, 1)), FADE_IN(40)), var_26_0)
	
	local var_26_1 = table.count(arg_26_0._usable_btn_list) - 1
	local var_26_2 = 1
	local var_26_3 = var_26_0:findChildByName("n_btn_1")
	
	if var_26_1 == 2 then
		var_26_3 = var_26_0:findChildByName("n_btn_2")
	end
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0._usable_btn_list) do
		if not iter_26_1._origin_pos then
			local var_26_4, var_26_5 = iter_26_1:getPosition()
			
			iter_26_1._origin_pos = {
				x = var_26_4,
				y = var_26_5
			}
		end
		
		if not iter_26_1._origin_pos then
			iter_26_1._origin_pos = {
				x = iter_26_1:getPositionX(),
				y = iter_26_1:getPositionY()
			}
		end
		
		iter_26_1:setPosition(0, 0)
		
		local var_26_6
		local var_26_7
		
		if iter_26_1:getName() == "btn_interaction" then
			var_26_6, var_26_7 = iter_26_1._origin_pos.x, iter_26_1._origin_pos.y
		else
			var_26_6, var_26_7 = var_26_3:findChildByName("n_btn" .. var_26_1 .. "_" .. var_26_2):getPosition()
			var_26_2 = var_26_2 + 1
		end
		
		iter_26_1:setOpacity(0)
		UIAction:Add(SEQ(CALL(function()
			iter_26_1:setTouchEnabled(false)
		end), DELAY(40), DELAY((iter_26_0 - 1) * 10), SPAWN(LOG(MOVE_TO(60, var_26_6, var_26_7)), FADE_IN(60)), CALL(function()
			iter_26_1:setTouchEnabled(true)
		end)), iter_26_1, "inter_ui_fade")
	end
end

function LotaInteractiveUI.fadeOut(arg_29_0)
	arg_29_0:hideTileFocusAni()
	
	local var_29_0 = arg_29_0._dlg:findChildByName("n_select menu")
	
	var_29_0:setScale(1)
	var_29_0:setOpacity(255)
	UIAction:Add(SPAWN(LOG(SCALE(80, 1, 0.2)), FADE_OUT(80)), var_29_0)
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0._usable_btn_list) do
		iter_29_1:setOpacity(255)
		iter_29_1:setTouchEnabled(false)
		UIAction:Add(SEQ(DELAY(40), DELAY((iter_29_0 - 1) * 10), SPAWN(LOG(MOVE_TO(80, 0, 0)), FADE_OUT(80))), iter_29_1)
	end
end

function LotaInteractiveUI.updateYPosition(arg_30_0, arg_30_1)
	local var_30_0
	local var_30_1 = arg_30_1:getTileId()
	local var_30_2 = -60
	
	if LotaObjectRenderer:findObject(var_30_1) then
		var_30_0 = LotaObjectRenderer:getFocusYPosition(var_30_1) + var_30_2
	end
	
	local var_30_3 = LotaMovableSystem:getMovablesByPos(arg_30_1:getPos()) or {}
	
	if #var_30_3 == 1 then
		var_30_0 = LotaMovableRenderer:getFocusYPosition(var_30_3[1]:getUID()) + var_30_2
	end
	
	if var_30_0 then
		arg_30_0._dlg:setPositionY(var_30_0)
	end
end

function LotaInteractiveUI.recoverInfoUIVisible(arg_31_0)
	if arg_31_0._last_select_object_id and arg_31_0._inter_info_flag then
		LotaObjectRenderer:setVisibleInfo(arg_31_0._last_select_object_id, true)
		
		arg_31_0._last_select_object_id = nil
	end
	
	if arg_31_0._last_select_movable_id then
		LotaMovableRenderer:setVisibleInfo(arg_31_0._last_select_movable_id, true)
		
		arg_31_0._last_select_movable_id = nil
	end
	
	if arg_31_0._hide_on_tile_memo_id then
		LotaPingRenderer:setVisibleByTileId(arg_31_0._hide_on_tile_memo_id, true)
		
		arg_31_0._hide_on_tile_memo_id = true
	end
end

function LotaInteractiveUI.updateInfoUIVisible(arg_32_0, arg_32_1)
	arg_32_0:recoverInfoUIVisible()
	
	local var_32_0 = arg_32_1:getTileId()
	
	if LotaObjectRenderer:findObject(var_32_0) and arg_32_0:isTileOnObjectMonster(arg_32_1) and arg_32_0._inter_info_flag then
		LotaObjectRenderer:setVisibleInfo(var_32_0, false)
		
		arg_32_0._last_select_object_id = var_32_0
	else
		local var_32_1 = LotaMovableSystem:getMovablesByPos(arg_32_1:getPos()) or {}
		
		if #var_32_1 == 1 then
			local var_32_2 = var_32_1[1]:getUID()
			
			LotaMovableRenderer:setVisibleInfo(var_32_2, false)
			
			arg_32_0._last_select_movable_id = var_32_2
		end
	end
end

function LotaInteractiveUI.updateInfo(arg_33_0, arg_33_1)
	local var_33_0 = LotaMovableSystem:getMovablesByPos(arg_33_1:getPos()) or {}
	
	if_set_visible(arg_33_0._dlg, "n_mob", arg_33_0:isTileOnObjectMonster(arg_33_1) and arg_33_0._inter_info_flag)
	if_set_visible(arg_33_0._dlg, "n_hero_info", #var_33_0 == 1 and arg_33_0._inter_info_flag)
	
	if arg_33_0:isTileOnObjectMonster(arg_33_1) and arg_33_0._inter_info_flag then
		local var_33_1 = arg_33_0._dlg:findChildByName("n_mob")
		local var_33_2 = LotaObjectSystem:getObject(arg_33_1:getTileId())
		
		LotaUtil:updateMonsterInfoUI(var_33_1, var_33_2:getDBId(), arg_33_1:getTileId())
	end
	
	if #var_33_0 == 1 and arg_33_0._inter_info_flag then
		local var_33_3 = arg_33_0._dlg:findChildByName("n_hero_info")
		
		LotaUtil:updateMovableInfoUI(var_33_3, var_33_0[1])
	end
end

function LotaInteractiveUI.updateUsableButtons(arg_34_0, arg_34_1)
	local var_34_0 = 90
	local var_34_3
	
	if LotaUtil:isTileHaveAddSelect(arg_34_1) then
		local var_34_1 = LotaObjectSystem:getObject(arg_34_1:getTileId())
		local var_34_2 = table.clone(var_34_1:getChildTileList())
		
		table.insert(var_34_2, var_34_1:getUID())
		
		var_34_3 = 0
		
		for iter_34_0, iter_34_1 in pairs(var_34_2) do
			local var_34_4 = LotaTileMapSystem:getTileById(iter_34_1)
			local var_34_5 = var_34_4:getPos().y
			
			if var_34_3 < var_34_5 then
				var_34_3 = var_34_5
				arg_34_1 = var_34_4
			end
		end
	end
	
	local var_34_6 = LotaUtil:calcTilePosToWorldPos(arg_34_1:getPos())
	
	arg_34_0._dlg:setPosition(var_34_6.x, var_34_6.y + var_34_0)
	if_set_visible(arg_34_0._dlg, nil, true)
	
	local var_34_7 = {
		btn_move = arg_34_0:isTileMovable(arg_34_1) or false,
		btn_detail = arg_34_0:isTileRequireDetail(arg_34_1) or false,
		btn_open = arg_34_0:isTileOnObjectOpen(arg_34_1) or false,
		btn_battle = arg_34_0:isTileOnObjectMonster(arg_34_1) or false,
		btn_interaction = arg_34_0:isTileOnObjectInteraction(arg_34_1) or false
	}
	
	arg_34_0._usable_btn_list = {}
	
	for iter_34_2, iter_34_3 in pairs(var_34_7) do
		local var_34_8 = iter_34_3
		local var_34_9 = arg_34_0._btn_name_to_idx[iter_34_2]
		local var_34_10 = 255
		
		if not var_34_8 then
			local var_34_11 = 85
		end
		
		if_set_visible(arg_34_0._btn_list[var_34_9], "n_item", iter_34_2 == "btn_open")
		if_set_visible(arg_34_0._btn_list[var_34_9], "n_count", iter_34_2 == "btn_open")
		if_set_visible(arg_34_0._btn_list[var_34_9], nil, var_34_8)
		
		if iter_34_2 == "btn_interaction" then
			local var_34_12 = arg_34_0._btn_list[var_34_9]:findChildByName("n_count")
			
			if_set_visible(var_34_12, nil, true)
			if_set(var_34_12, "txt_count", T("ring_menu_clan_heritage_memo_max", {
				floor = LotaUserData:getFloor(),
				number = LotaPingSystem:getPingRemainCount(),
				number1 = LotaPingSystem:getPingMaxCount()
			}))
		end
		
		if var_34_8 then
			table.insert(arg_34_0._usable_btn_list, arg_34_0._btn_list[var_34_9])
		end
	end
end

function LotaInteractiveUI.isTooltipActive(arg_35_0)
	return arg_35_0.vars and get_cocos_refid(arg_35_0._tooltip)
end

function LotaInteractiveUI.removeTooltip(arg_36_0, arg_36_1)
	if get_cocos_refid(arg_36_0._tooltip) then
		local var_36_0 = arg_36_0._tooltip[arg_36_1]
		
		arg_36_0._tooltip:removeFromParent()
		
		arg_36_0._tooltip = nil
		
		if var_36_0 then
			return true
		end
	end
	
	return false
end

function LotaInteractiveUI.attachTooltip(arg_37_0, arg_37_1)
	arg_37_0._dlg:addChild(arg_37_1)
	
	arg_37_0._tooltip = arg_37_1
	
	local var_37_0 = arg_37_1:getContentSize()
	local var_37_1 = 50
	local var_37_2 = VIEW_HEIGHT - var_37_0.height - var_37_1
	local var_37_3 = 100
	local var_37_4 = {
		{
			x = 285,
			y = 100
		},
		{
			x = -185,
			y = 100
		}
	}
	local var_37_5 = 1
	local var_37_6 = 100000
	
	for iter_37_0, iter_37_1 in pairs(var_37_4) do
		arg_37_0._tooltip:setPosition(iter_37_1.x, iter_37_1.y)
		
		local var_37_7 = SceneManager:convertToSceneSpace(arg_37_0._tooltip, {
			x = 0,
			y = 0
		})
		local var_37_8 = math.abs(VIEW_WIDTH / 2 - var_37_7.x)
		
		if var_37_2 < var_37_7.y then
			iter_37_1.y = iter_37_1.y - (var_37_7.y - var_37_2)
		elseif var_37_3 > var_37_7.y then
			iter_37_1.y = iter_37_1.y + (var_37_3 - var_37_7.y)
		end
		
		if var_37_8 < var_37_6 then
			var_37_6 = var_37_8
			var_37_5 = iter_37_0
		end
	end
	
	local var_37_9 = var_37_4[var_37_5]
	
	arg_37_0._tooltip:setPosition(var_37_9.x, var_37_9.y)
	LotaInteractiveUI:fadeOut()
end

function LotaInteractiveUI.openDetailTooltip(arg_38_0, arg_38_1)
	local var_38_0 = ItemTooltip:getItemTooltip({
		code = arg_38_1.db.id,
		lota_object_type = arg_38_1:getTypeDetail(),
		lota_object = arg_38_1
	})
	
	var_38_0.detail_tooltip = true
	
	arg_38_0:attachTooltip(var_38_0)
end

LotaGroupScrollView = {}

copy_functions(ScrollView, LotaGroupScrollView)

function LotaGroupScrollView.getScrollViewItem(arg_39_0, arg_39_1)
	local var_39_0 = LotaUtil:getUIControl("clan_heritage_group_info_item")
	
	if_set(var_39_0, "t_name", arg_39_1:getName())
	if_set(var_39_0, "t_level", arg_39_1:getLevel())
	
	local var_39_1 = arg_39_1:getLeaderCode()
	local var_39_2 = arg_39_1:getBorderCode()
	local var_39_3 = UIUtil:getLightIcon(var_39_1, var_39_2, 1)
	
	var_39_0:findChildByName("n_face_icon"):addChild(var_39_3)
	
	return var_39_0
end

function LotaGroupScrollView.setItems(arg_40_0, arg_40_1)
	arg_40_0._group_scroll_view_items = arg_40_1
end

function LotaGroupScrollView.updateItems(arg_41_0)
	local var_41_0 = arg_41_0._group_scroll_view_items
	
	if not var_41_0 or not arg_41_0:isActive() then
		return 
	end
	
	table.sort(var_41_0, function(arg_42_0, arg_42_1)
		if arg_42_0:getUID() == AccountData.id then
			return true
		end
		
		if arg_42_1:getUID() == AccountData.id then
			return false
		end
		
		return arg_42_0:getExp() > arg_42_1:getExp()
	end)
	arg_41_0:clearScrollViewItems()
	arg_41_0:setScrollViewItems(var_41_0)
end

function LotaGroupScrollView.isActive(arg_43_0)
	return get_cocos_refid(arg_43_0.scrollview)
end

function LotaInteractiveUI.openPlayersInfoTooltip(arg_44_0, arg_44_1)
	if arg_44_0:removeTooltip("detail_tooltip") then
		return 
	end
	
	local var_44_0 = LotaUtil:getUIControl("clan_heritage_group_info")
	
	if_set_visible(var_44_0, "btn_close", false)
	
	var_44_0.detail_tooltip = true
	
	local var_44_1 = var_44_0:findChildByName("ScrollView")
	
	LotaGroupScrollView:initScrollView(var_44_1, 335, 94)
	
	local var_44_2 = {}
	
	for iter_44_0, iter_44_1 in pairs(arg_44_1) do
		table.insert(var_44_2, iter_44_1)
	end
	
	LotaGroupScrollView:setItems(var_44_2)
	LotaGroupScrollView:updateItems()
	arg_44_0:attachTooltip(var_44_0)
end

LotaMemoInputView = {}

function LotaMemoInputView.makeTooltip(arg_45_0)
	arg_45_0.vars = {}
	arg_45_0.vars.selected_tile = LotaUtil:getMemoTile(LotaInteractiveUI:getSelectedTile())
	
	local var_45_0 = LotaPingSystem:getPingDataByTileId(arg_45_0.vars.selected_tile:getTileId())
	local var_45_1
	local var_45_2
	
	if var_45_0 then
		var_45_2 = var_45_0:getPingNumber()
		var_45_1 = LotaPingSystem:getMemoData(var_45_2)
	elseif LotaPingSystem:getPingCount() >= LotaPingSystem:getPingMaxCount() then
		arg_45_0.vars = nil
		
		return 
	end
	
	arg_45_0.vars.fix_ping_number = var_45_2
	arg_45_0.vars.keyword_info = {
		prev_text = var_45_1 or ""
	}
	
	local var_45_3 = Dialog:openInputBox(arg_45_0, function()
		local var_46_0 = arg_45_0.vars.keyword_info.text
		local var_46_1 = string.trim(var_46_0)
		local var_46_2 = utf8len(var_46_1)
		
		if var_46_2 < 5 or var_46_2 > 20 then
			balloon_message_with_sound("msg_clanheritage_mark_text_error")
			
			return 
		end
		
		if var_46_1 == arg_45_0.vars.keyword_info.prev_text then
			return 
		end
		
		if check_abuse_filter(var_46_1, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return "dont_close"
		end
		
		arg_45_0.vars.keyword_info.text = var_46_1
		
		LotaMemoInputView:sendQuery()
	end, {
		max_limit = 20,
		custom_txt_input_limit = "ui_clanheritage_memo_max_text",
		title = T("btn_clanheritage_memo_title"),
		info = arg_45_0.vars.keyword_info
	})
	
	var_45_3.ping_info = true
	
	local var_45_4 = var_45_3:findChildByName("n_bottom")
	
	if_set_visible(var_45_4, "btn_cancel", var_45_1 == nil)
	if_set_visible(var_45_4, "btn_delete", var_45_1 ~= nil)
	
	local var_45_5 = var_45_3:findChildByName("btn_yes")
	
	if var_45_1 == nil then
		if_set(var_45_5, "label", T("ui_btn_clanheritage_memo_save"))
	else
		if_set(var_45_5, "label", T("nickset_confirm"))
	end
	
	arg_45_0.vars.tooltip = var_45_3
	
	return var_45_3
end

function LotaMemoInputView.onCloseChildDialog(arg_47_0, arg_47_1, arg_47_2)
	if arg_47_0:isActive() then
		arg_47_0.vars.tooltip:removeFromParent()
		BackButtonManager:pop({
			check_id = "Dialog." .. arg_47_1,
			dlg = arg_47_2
		})
	end
end

function LotaMemoInputView.isRequestRemoved(arg_48_0)
	if not arg_48_0:isRemainData() then
		return nil
	end
	
	return arg_48_0.vars.request_remove == true
end

function LotaMemoInputView.isRemainData(arg_49_0)
	return arg_49_0.vars ~= nil
end

function LotaMemoInputView.requestDeleteMemo(arg_50_0)
	Dialog:msgBox(T("ui_clan_heritage_mark_remove"), {
		yesno = true,
		handler = function()
			LotaMemoInputView:sendQuery(true)
			Dialog:close("_z_input")
		end
	})
end

function LotaMemoInputView.isActive(arg_52_0)
	return arg_52_0.vars and get_cocos_refid(arg_52_0.vars.tooltip)
end

function LotaMemoInputView.sendQuery(arg_53_0, arg_53_1)
	local var_53_0 = LotaUtil:getMemoTile(arg_53_0.vars.selected_tile)
	
	arg_53_0.vars.request_remove = arg_53_1
	
	if arg_53_1 then
		LotaNetworkSystem:sendQuery("lota_set_ping", {
			tile_id = -1,
			ping_number = arg_53_0.vars.fix_ping_number
		})
	else
		LotaNetworkSystem:sendQuery("lota_set_ping", {
			ping_number = arg_53_0.vars.fix_ping_number,
			tile_id = var_53_0:getTileId(),
			msg = arg_53_0.vars.keyword_info.text
		})
	end
end

function LotaInteractiveUI.openMemoInputTooltip(arg_54_0)
	local var_54_0 = LotaMemoInputView:makeTooltip()
	
	if not var_54_0 then
		balloon_message_with_sound("msg_clanheritage_memo_max")
		
		return 
	end
	
	LotaSystem:getUIDialogLayer():addChild(var_54_0)
	arg_54_0:close()
end

function LotaInteractiveUI.addTokenImg(arg_55_0, arg_55_1)
	local var_55_0 = "to_clanheritage"
	local var_55_1 = DB("item_token", var_55_0, "icon")
	local var_55_2 = arg_55_0._dlg:findChildByName(arg_55_1)
	
	if not var_55_2:findChildByName("img_token") then
		local var_55_3 = var_55_2:findChildByName("n_item")
		local var_55_4 = SpriteCache:getSprite("item/" .. var_55_1 .. ".png")
		
		if var_55_4 then
			var_55_4:setName("img_token")
			var_55_3:addChild(var_55_4)
		end
	end
end

function LotaInteractiveUI.updateTokenInfo(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	arg_56_0:addTokenImg(arg_56_3)
	
	local var_56_0 = arg_56_0._dlg:findChildByName(arg_56_3):findChildByName("n_count")
	
	if_set_visible(var_56_0, "t_count", arg_56_1[arg_56_2] ~= nil)
	
	if arg_56_1[arg_56_2] then
		if_set(var_56_0, "t_count", arg_56_1[arg_56_2])
	end
end

function LotaInteractiveUI.updateUsageToken(arg_57_0, arg_57_1)
	local var_57_0 = LotaMovableSystem:getPlayerPos()
	local var_57_1 = {
		move = LotaPathFindingSystem:find(var_57_0, arg_57_1:getPos())
	}
	
	if var_57_1.move then
		var_57_1.move = table.count(var_57_1.move)
	end
	
	local var_57_2 = LotaObjectSystem:getObject(arg_57_1:getTileId())
	
	if var_57_2 then
		var_57_1.open = var_57_2:getUseToken()
	end
	
	arg_57_0:updateTokenInfo(var_57_1, "move", "btn_move")
	arg_57_0:updateTokenInfo(var_57_1, "open", "btn_open")
end

function LotaInteractiveUI.updateMemo(arg_58_0, arg_58_1)
	if_set_visible(arg_58_0._dlg, "n_note", false)
	
	local var_58_0 = LotaUtil:getMemoTile(arg_58_1)
	
	if not var_58_0 then
		return 
	end
	
	local var_58_1 = var_58_0:getTileId()
	local var_58_2 = LotaPingSystem:getPingDataByTileId(var_58_1)
	
	if not var_58_2 then
		return 
	end
	
	local var_58_3 = LotaPingSystem:getMemoData(var_58_2:getPingNumber())
	
	if not var_58_3 then
		return 
	end
	
	arg_58_0._hide_on_tile_memo_id = var_58_1
	
	LotaPingRenderer:setVisibleByTileId(var_58_1, false)
	if_set_visible(arg_58_0._dlg, "n_note", true)
	if_set(arg_58_0._dlg, "txt_note", var_58_3)
	UIUtil:updateTextWrapMode(arg_58_0._dlg:findChildByName("txt_note"), var_58_3)
end

function LotaInteractiveUI.updateUI(arg_59_0, arg_59_1)
	if not arg_59_0._dlg or not get_cocos_refid(arg_59_0._dlg) then
		arg_59_0._dlg = LotaUtil:getUIDlg("clan_heritage_select_menu")
		arg_59_0._btn_list = {
			arg_59_0._dlg:findChildByName("btn_move"),
			arg_59_0._dlg:findChildByName("btn_detail"),
			arg_59_0._dlg:findChildByName("btn_open"),
			arg_59_0._dlg:findChildByName("btn_battle"),
			arg_59_0._dlg:findChildByName("btn_interaction")
		}
		arg_59_0._btn_name_to_idx = {
			btn_detail = 2,
			btn_battle = 4,
			btn_interaction = 5,
			btn_move = 1,
			btn_open = 3
		}
		
		for iter_59_0, iter_59_1 in pairs(arg_59_0._btn_list) do
			iter_59_1:setTouchEnabled(true)
		end
		
		if_set_visible(arg_59_0._dlg, "btn_close", false)
		LotaSystem:addNodeToFieldUI(arg_59_0._dlg)
	end
	
	if_set_visible(arg_59_0._dlg, "n_select menu", true)
	arg_59_0:updateInfo(arg_59_1)
	arg_59_0:updateUsableButtons(arg_59_1)
	arg_59_0:updateYPosition(arg_59_1)
	arg_59_0:updateInfoUIVisible(arg_59_1)
	arg_59_0:updateUsageToken(arg_59_1)
	arg_59_0:updateMemo(arg_59_1)
	arg_59_0:fadeIn()
end

function LotaInteractiveUI.close(arg_60_0)
	local var_60_0 = CALL(LotaInteractiveUI.fadeOut, LotaInteractiveUI)
	
	if get_cocos_refid(arg_60_0._tooltip) then
		arg_60_0._tooltip:removeFromParent()
		
		arg_60_0._tooltip = nil
		var_60_0 = DELAY(0)
	end
	
	UIAction:Add(SEQ(var_60_0, CALL(LotaTileRenderer.unmarking, LotaTileRenderer), SPAWN(DELAY(340), CALL(function()
		arg_60_0:recoverInfoUIVisible()
		
		arg_60_0.vars = nil
	end)), CALL(function()
		if_set_visible(arg_60_0._dlg, nil, false)
	end)), arg_60_0._dlg, "inter_ui_fade")
end

function LotaInteractiveUI.tileFocusOpacity(arg_63_0, arg_63_1, arg_63_2)
	local var_63_0 = 8
	local var_63_1 = LotaTileMapSystem:getTileById(arg_63_1):getPos()
	local var_63_2 = LotaUtil:getDiscoverRange(var_63_1, var_63_0)
	local var_63_3 = LotaObjectSystem:getObject(arg_63_1)
	local var_63_4 = {}
	
	if var_63_3 then
		var_63_4 = var_63_3:getChildTileList()
	end
	
	local var_63_5 = LotaObjectRenderer:getObjectList() or {}
	local var_63_6 = math.ceil((255 - arg_63_2) / var_63_0)
	
	for iter_63_0, iter_63_1 in pairs(var_63_2) do
		local var_63_7 = LotaTileMapSystem:getTileIdByPos(iter_63_1)
		local var_63_8 = var_63_4 and table.isInclude(var_63_4, var_63_7)
		
		if var_63_7 and not var_63_8 and arg_63_1 ~= var_63_7 then
			local var_63_9 = LotaUtil:getTileCost(var_63_1, iter_63_1)
			local var_63_10 = var_63_5[var_63_7]
			
			if var_63_10 then
				local var_63_11 = math.min(255, arg_63_2 + var_63_6 * var_63_9) / 255
				
				if arg_63_2 < 255 then
					UIAction:Add(SEQ(OPACITY(320, 1, var_63_11)), var_63_10)
					
					if var_63_10.ui_info then
						UIAction:Add(SEQ(OPACITY(320, 1, var_63_11)), var_63_10.ui_info)
					end
				else
					UIAction:Add(SEQ(OPACITY(320, var_63_10:getOpacity() / 255, 1)), var_63_10)
					
					if var_63_10.ui_info then
						UIAction:Add(SEQ(OPACITY(320, var_63_10.ui_info:getOpacity() / 255, 1)), var_63_10.ui_info)
					end
				end
			end
		end
	end
end

function LotaInteractiveUI.showTileFocusAni(arg_64_0)
	if arg_64_0.vars and arg_64_0.vars.tile then
		local var_64_0 = arg_64_0.vars.tile:getTileId()
		
		arg_64_0:tileFocusOpacity(var_64_0, 75)
	end
	
	arg_64_0:showVignetting()
end

function LotaInteractiveUI.hideTileFocusAni(arg_65_0)
	if arg_65_0.vars and arg_65_0.vars.tile then
		local var_65_0 = arg_65_0.vars.tile:getTileId()
		
		arg_65_0:tileFocusOpacity(var_65_0, 255)
	end
	
	arg_65_0:HideVignetting()
end

function LotaInteractiveUI.showVignetting(arg_66_0)
	if get_cocos_refid(arg_66_0._dlg) then
		if get_cocos_refid(arg_66_0._vignet) then
			arg_66_0._vignet:removeFromParent()
		end
		
		local var_66_0 = LotaUtil:makeVignetting(arg_66_0._dlg:getPositionX(), arg_66_0._dlg:getPositionY())
		
		LotaSystem:addNodeToFieldUI(var_66_0)
		UIAction:Add(SEQ(OPACITY(320, 0, 0.4)), var_66_0)
		
		arg_66_0._vignet = var_66_0
	end
end

function LotaInteractiveUI.HideVignetting(arg_67_0)
	if get_cocos_refid(arg_67_0._vignet) then
		arg_67_0._vignet:removeFromParent()
	end
end
