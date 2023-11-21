LotaPortalUI = {}

function LotaPortalUI.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_map")
	
	if_set_visible(arg_1_0.vars.dlg, "Panel_1", false)
	if_set_visible(arg_1_0.vars.dlg, "btn_close", false)
	
	local var_1_0
	
	for iter_1_0, iter_1_1 in pairs(arg_1_0.vars.dlg:getChildren()) do
		if iter_1_1:getName() == "n_potal" then
			var_1_0 = iter_1_1
		end
	end
	
	local var_1_1 = LotaSystem:getWorldId()
	local var_1_2 = DB("clan_heritage_world", var_1_1, "name")
	local var_1_3 = LotaSystem:getCurrentSeasonDB()
	local var_1_4 = arg_1_0.vars.dlg:findChildByName("t_point")
	
	if_set(var_1_4, nil, T(var_1_3.name) .. "\n" .. T(var_1_2))
	
	arg_1_0.vars.n_potal = var_1_0
	
	if_set_visible(var_1_0, nil, true)
	
	local var_1_5 = arg_1_0.vars.n_potal:findChildByName("btn_move")
	
	if_set(var_1_5, "label_0", arg_1_1:getCost())
	
	arg_1_0.vars.target_object = arg_1_1
	
	LotaSystem:getUIDialogLayer():addChild(arg_1_0.vars.dlg)
	
	local var_1_6 = arg_1_0.vars.dlg:findChildByName("MAP")
	
	LotaMinimapRenderer:setScale(1.02)
	LotaMinimapRenderer:convertToPortalUI(var_1_6)
	
	arg_1_0.vars.cur_portal_idx = 1
	arg_1_0.vars.portal_list = LotaObjectSystem:getObjectsByType("portal")
	
	table.sort(arg_1_0.vars.portal_list, function(arg_2_0, arg_2_1)
		local var_2_0 = LotaTileMapSystem:getPosById(arg_2_0:getTileId())
		local var_2_1 = LotaTileMapSystem:getPosById(arg_2_1:getTileId())
		
		if var_2_0.x ~= var_2_1.x then
			return var_2_0.x < var_2_1.x
		end
		
		if var_2_0.y ~= var_2_1.y then
			return var_2_0.y < var_2_1.y
		end
		
		return tonumber(arg_2_0:getTileId()) > tonumber(arg_2_1:getTileId())
	end)
	
	arg_1_0.vars.portal_count = table.count(arg_1_0.vars.portal_list)
	
	arg_1_0:setPortalPlayerPos()
	BackButtonManager:push({
		check_id = "lota_minimap",
		back_func = function()
			LotaPortalUI:close()
		end
	})
end

function LotaPortalUI.prvPortal(arg_4_0)
	local var_4_0 = arg_4_0.vars.cur_portal_idx - 1
	
	if var_4_0 < 1 then
		var_4_0 = arg_4_0.vars.portal_count
	end
	
	arg_4_0:setPortalPosition(var_4_0)
end

function LotaPortalUI.nextPortal(arg_5_0)
	local var_5_0 = arg_5_0.vars.cur_portal_idx + 1
	
	if var_5_0 > arg_5_0.vars.portal_count then
		var_5_0 = 1
	end
	
	arg_5_0:setPortalPosition(var_5_0)
end

function LotaPortalUI.getDlg(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.dlg) then
		return 
	end
	
	return arg_6_0.vars.dlg
end

function LotaPortalUI.setCurPortalCenter(arg_7_0)
	local var_7_0 = arg_7_0.vars.portal_list[arg_7_0.vars.cur_portal_idx]
	
	if not var_7_0 then
		return false
	end
	
	local var_7_1 = var_7_0:getTileId()
	
	LotaMinimapRenderer:setPosCenter(LotaTileMapSystem:getPosById(var_7_1), true)
end

function LotaPortalUI.setPortalPosition(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.portal_list[arg_8_1]
	
	if not var_8_0 then
		return false
	end
	
	local var_8_1 = var_8_0:getTileId()
	
	LotaMinimapRenderer:setPosCenter(LotaTileMapSystem:getPosById(var_8_1), true)
	
	arg_8_0.vars.cur_portal_idx = arg_8_1
	
	LotaMinimapRenderer:setPortalOverlayColor(LotaTileMapSystem:getTileById(var_8_1))
	
	local var_8_2 = arg_8_0.vars.target_object:getTileId() == var_8_1
	local var_8_3 = cc.c3b(255, 255, 255)
	
	if var_8_2 then
		var_8_3 = cc.c3b(77, 77, 77)
	end
	
	LotaPortalUI:setPortalEffect(var_8_1)
	if_set_color(arg_8_0.vars.dlg, "btn_move", var_8_3)
	
	return true
end

function LotaPortalUI.setPortalPlayerPos(arg_9_0)
	for iter_9_0 = 1, arg_9_0.vars.portal_count do
		if arg_9_0.vars.portal_list[iter_9_0]:getTileId() == arg_9_0.vars.target_object:getTileId() then
			LotaPortalUI:setPortalPosition(iter_9_0)
			
			break
		end
	end
end

function LotaPortalUI.setPortalEffect(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	local var_10_0 = LotaMinimapRenderer:getTileSprite(LotaTileMapSystem:getPosById(arg_10_1))
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = arg_10_0.vars.portal_effect
	
	if get_cocos_refid(var_10_1) then
		var_10_1:setVisible(false)
		var_10_1:ejectFromParent()
		var_10_0:addChild(var_10_1)
		var_10_1:setPosition({
			x = var_10_0:getContentSize().width / 2,
			y = var_10_0:getContentSize().height / 2
		})
		var_10_1:setVisible(true)
	else
		var_10_1 = EffectManager:Play({
			fn = "ui_eff_heritage_portal.cfx",
			pivot_z = 99998,
			layer = var_10_0,
			pivot_x = var_10_0:getContentSize().width / 2,
			pivot_y = var_10_0:getContentSize().height / 2
		})
		
		var_10_1:setName("portal_effect")
	end
	
	arg_10_0.vars.portal_effect = var_10_1
end

function LotaPortalUI.isActive(arg_11_0)
	return arg_11_0.vars ~= nil
end

function LotaPortalUI.close(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	LotaMinimapRenderer:revertPortalOverlay()
	LotaMinimapRenderer:covertToWindow()
	
	if get_cocos_refid(arg_12_0.vars.portal_effect) then
		arg_12_0.vars.portal_effect:removeFromParent()
	end
	
	if get_cocos_refid(arg_12_0.vars.dlg) then
		arg_12_0.vars.dlg:removeFromParent()
	end
	
	arg_12_0.vars = nil
end

function LotaPortalUI.requestJumpToPortal(arg_13_0)
	if arg_13_0.vars.target_object:getCost() > LotaUserData:getActionPoint() then
		Log.e("NOT ENHOUGH!!!! COST!!!!")
		
		return 
	end
	
	local var_13_0 = arg_13_0.vars.portal_list[arg_13_0.vars.cur_portal_idx]
	local var_13_1 = var_13_0:getTileId()
	
	if var_13_0:getTileId() == arg_13_0.vars.target_object:getTileId() then
		balloon_message_with_sound("msg_clan_heritage_portal_same_position")
		
		return 
	end
	
	LotaNetworkSystem:sendQuery("lota_interaction_object", {
		tile_id = arg_13_0.vars.target_object:getTileId(),
		target_tile_id = var_13_1
	})
end
