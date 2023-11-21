HTBMovableRenderer = {}

function HTBMovableRenderer.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0.vars = {}
	arg_1_0.vars.wait_queue = {}
	arg_1_0.vars.layer = arg_1_2
	arg_1_0.vars.adjust_y_model_pos = 75
	arg_1_0.vars.skip_ui_mode = arg_1_3
	arg_1_0.vars.deferred_create = arg_1_4
	arg_1_0.vars.deferred_created_count = 0
	
	HTBInterface:whiteboardSet(arg_1_1, "model_adjust_magic_pos", arg_1_0.vars.adjust_y_model_pos)
end

function HTBMovableRenderer.findGroupIconByPos(arg_2_0, arg_2_1)
	local var_2_0 = HTUtil:getPosToHashKey(arg_2_1)
	
	return arg_2_0.vars.pos_to_draw_group_icon[var_2_0]
end

function HTBMovableRenderer.addGroupIconWithPos(arg_3_0, arg_3_1)
	local var_3_0 = HTUtil:getPosToHashKey(arg_3_1)
	local var_3_1 = SpriteCache:getSprite("tile/heritage_icon_people.png")
	
	var_3_1:setScale(0.6)
	
	local var_3_2 = arg_3_0:addToLayerOnIcon(var_3_1)
	
	arg_3_0.vars.pos_to_draw_group_icon[var_3_0] = var_3_2
	
	local var_3_3 = arg_3_0:calcSpriteWorldPos(var_3_2, arg_3_1)
	
	var_3_2:setLocalZOrder(arg_3_1.y * -5 + 2)
	var_3_2:setPosition(var_3_3.x, var_3_3.y + 26)
	
	return var_3_2
end

function HTBMovableRenderer.base_addIcon(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2.movable
	local var_4_1 = var_4_0:getLeaderCode()
	local var_4_2 = var_4_0:getBorderCode()
	local var_4_3 = UIUtil:getLightIcon(var_4_1, var_4_2, arg_4_0:getIconScale())
	
	arg_4_2:addChild(var_4_3)
	
	arg_4_2.icon = var_4_3
	
	if not arg_4_0.vars.skip_ui_mode and not arg_4_2.ui then
		arg_4_2.ui = HTBInterface:createUIMovableInfo(arg_4_1, arg_4_2, arg_4_2.movable, 58)
	end
	
	var_4_3:setPositionY(12)
	arg_4_0:updatePosition(arg_4_2.movable, arg_4_2)
end

function HTBMovableRenderer.base_makeMovable(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = UNIT:create({
		code = arg_5_2.leader_code
	})
	local var_5_1 = arg_5_0:addToLayer(var_5_0, arg_5_2)
	local var_5_2 = arg_5_1 or false
	
	if not arg_5_0.vars.deferred_create then
		if var_5_2 and SceneManager:getCurrentSceneName() == "lota" and arg_5_2:getUID() ~= AccountData.id then
			arg_5_0:addIcon(var_5_1)
		else
			arg_5_0:addModel(var_5_1)
		end
	end
	
	arg_5_0.vars.id_to_draw_object[arg_5_2:getUID()] = var_5_1
	var_5_1._setPosition = var_5_1.setPosition
	var_5_1._setPositionX = var_5_1.setPositionX
	var_5_1._setPositionY = var_5_1.setPositionY
	
	function var_5_1.setPosition(arg_6_0, arg_6_1, arg_6_2)
		if arg_6_0.ui then
			arg_6_0.ui:updatePosition(arg_6_1, arg_6_2)
		end
		
		arg_6_0:_setPosition(arg_6_1, arg_6_2)
	end
	
	function var_5_1.setPositionX(arg_7_0, arg_7_1)
		if arg_7_0.ui then
			arg_7_0.ui:updatePosition(arg_7_1, arg_7_0:getPositionY())
		end
		
		arg_7_0:_setPositionX(arg_7_1)
	end
	
	function var_5_1.setPositionY(arg_8_0, arg_8_1)
		if arg_8_0.ui then
			arg_8_0.ui:updatePosition(arg_8_0:getPositionX(), arg_8_1)
		end
		
		arg_8_0:_setPositionY(arg_8_1)
	end
end

function HTBMovableRenderer.base_calcTilePosToWorldPos(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.layer) then
		return 
	end
	
	local var_9_0 = HTBInterface:calcTilePosToWorldPos(arg_9_1, arg_9_3)
	local var_9_1 = arg_9_0.vars.adjust_y_model_pos
	local var_9_2 = arg_9_2.model
	local var_9_3 = 0
	
	if var_9_2 then
		local var_9_4
		local var_9_5
		
		if var_9_2.getBonePosition then
			local var_9_6
			
			var_9_6, var_9_5 = var_9_2.body:getBonePosition("root")
		else
			var_9_5 = var_9_2:getContentSize().height
		end
		
		var_9_3 = var_9_5 * arg_9_0:getModelScale(var_9_2) * 0.5
	end
	
	var_9_0.y = var_9_0.y + var_9_3 + var_9_1
	
	return var_9_0
end

function HTBMovableRenderer.base_addLevelUpEffect(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.layer) then
		return 
	end
	
	arg_10_0:addEffect(arg_10_3, "ui_eff_heritage_levelup.cfx")
	
	arg_10_4 = arg_10_4 or 1
	
	if HTBInterface:isMyMovableUId(arg_10_2, arg_10_3:getUID()) then
		UIAction:Add(SEQ(DELAY(1500), CALL(function()
			for iter_11_0 = 1, arg_10_4 do
				HTBInterface:onOpenPopup(arg_10_1, arg_10_5, arg_10_4, iter_11_0)
			end
		end)), arg_10_0.vars.layer, "block")
	end
end

function HTBMovableRenderer.base_addEffectOnTop(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if not arg_12_0.vars then
		return 
	end
	
	local var_12_0 = cc.Node:create()
	local var_12_1 = arg_12_2:getUID()
	local var_12_2 = EffectManager:Play({
		scale = 0.9,
		fn = arg_12_3 or "ui_pet_act_eff.cfx",
		layer = var_12_0
	})
	local var_12_3 = arg_12_0.vars.id_to_draw_object[var_12_1]
	local var_12_4 = arg_12_0:calcMovableWorldPos(var_12_3, arg_12_2)
	local var_12_5 = arg_12_0:getFocusYPosition(var_12_1)
	
	var_12_2:setPosition(var_12_4.x, var_12_5 + 30)
	HTBInterface:addToEffectFieldUI(arg_12_1, var_12_0)
	UIAction:Add(SEQ(DELAY(1333), REMOVE()), var_12_0)
end

function HTBMovableRenderer.base_procEffectsOnWaitQueue(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.layer) then
		return 
	end
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.wait_queue) do
		if iter_13_1.low then
			for iter_13_2, iter_13_3 in pairs(iter_13_1.low) do
				table.insert(iter_13_1, iter_13_3)
			end
			
			iter_13_1.low = nil
		end
	end
	
	for iter_13_4, iter_13_5 in pairs(arg_13_0.vars.wait_queue) do
		local var_13_0 = HTBInterface:getMovableById(arg_13_1, iter_13_4)
		
		arg_13_0:addMovableEffectAction(var_13_0, iter_13_5)
	end
	
	arg_13_0.vars.wait_queue = {}
end

function HTBMovableRenderer.base_addMovableEffectAction(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.layer) then
		return 
	end
	
	local var_14_0 = cc.Node:create()
	
	var_14_0:setName("string_list_actions")
	
	local var_14_1 = 0
	local var_14_2 = 1000
	
	var_14_0:setScale(0.75)
	
	for iter_14_0, iter_14_1 in pairs(arg_14_3) do
		if type(iter_14_1) == "string" or type(iter_14_1) == "table" then
			local var_14_3
			
			if type(iter_14_1) == "table" then
				var_14_3 = load_control("wnd/clan_heritage_exp.csb")
				
				local var_14_4 = var_14_3:getChildByName("t_exp")
				
				if_set(var_14_4, nil, "+" .. iter_14_1.exp)
				
				if iter_14_1.additional_exp then
					if_set_visible(var_14_3, "n_exp_add", true)
					if_set(var_14_3, "t_exp_add", iter_14_1.additional_exp)
					
					if get_cocos_refid(var_14_4) then
						local var_14_5 = var_14_4:getContentSize().width * var_14_4:getScaleX() * 0.5 + 40
						
						if_set_position_x(var_14_3, "n_exp_add", var_14_5)
					end
				end
			else
				var_14_3 = HTUtil:createDebugLabel(iter_14_0, iter_14_1, {
					width = 100,
					height = 30
				}, cc.c3b(0, 0, 0), nil, true)
			end
			
			var_14_3:setOpacity(0)
			var_14_3:setPositionY(0)
			var_14_0:addChild(var_14_3)
			UIAction:Add(SEQ(DELAY(var_14_1), SEQ(SPAWN(MOVE_TO(var_14_2, 0, 100), SEQ(LOG(FADE_IN(var_14_2 / 2)), RLOG(FADE_OUT(var_14_2 / 2)))), REMOVE())), var_14_3)
		elseif type(iter_14_1) == "function" then
			UIAction:Add(SEQ(DELAY(var_14_1), CALL(iter_14_1)), arg_14_0.vars.layer)
		end
		
		var_14_1 = var_14_1 + var_14_2
	end
	
	UIAction:Add(SEQ(DELAY(var_14_1), REMOVE()), var_14_0)
	
	local var_14_6 = arg_14_0.vars.id_to_draw_object[arg_14_2:getUID()]
	
	if not get_cocos_refid(var_14_6) then
		return 
	end
	
	local var_14_7 = arg_14_0:calcMovableWorldPos(var_14_6, arg_14_2)
	
	HTBInterface:addToEffectFieldUI(arg_14_1, var_14_0)
	var_14_0:setLocalZOrder(9999999)
	var_14_0:setPosition(var_14_7.x, var_14_7.y)
end

function HTBMovableRenderer.base_updateColor(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = HTBInterface:getFogVisibility(arg_15_1, arg_15_3.x, arg_15_3.y)
	
	arg_15_0:setFogColorToDrawObject(arg_15_2, var_15_0)
end

function HTBMovableRenderer.base_setFogColorToDrawObject(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if not arg_16_2.model then
		return 
	end
	
	local var_16_0 = 1
	
	if arg_16_3 == LotaFogVisibilityEnum.DISCOVER then
		var_16_0 = 0.7352941176470589
	elseif arg_16_3 == LotaFogVisibilityEnum.NOT_DISCOVER then
		var_16_0 = 0.5
	end
	
	local var_16_1 = HTBInterface:whiteboardGet(arg_16_1, "ambient_color")
	local var_16_2 = cc.c3b(var_16_1.r * var_16_0, var_16_1.g * var_16_0, var_16_1.b * var_16_0)
	
	arg_16_2.model:setColor(var_16_2)
end

function HTBMovableRenderer.base_updateColorByFog(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = HTBInterface:getMovablesByPos(arg_17_1, {
		x = arg_17_2,
		y = arg_17_3
	})
	
	if not var_17_0 then
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		local var_17_1 = arg_17_0.vars.id_to_draw_object[iter_17_1:getUID()]
		
		if var_17_1 then
			arg_17_0:setFogColorToDrawObject(var_17_1, arg_17_4)
		end
	end
end

function HTBMovableRenderer.base_isRequireGroupView(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_3 = arg_18_3 or HTBInterface:getMovablesByPos(arg_18_1, arg_18_2)
	
	return table.count(arg_18_3) > 1
end

function HTBMovableRenderer.base_updateDrawObjectsVisible(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	for iter_19_0, iter_19_1 in pairs(arg_19_2) do
		local var_19_0 = iter_19_1:getUID() == AccountData.id
		local var_19_1 = var_19_0 or iter_19_1.is_running or arg_19_3
		
		if var_19_0 and HTBInterface:isProcJumpPath(arg_19_1) then
			var_19_1 = false
		end
		
		arg_19_0:setMovableVisible(iter_19_1, var_19_1)
	end
end

function HTBMovableRenderer.base_updateGroupView(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = HTBInterface:getMovablesByPos(arg_20_1, arg_20_2) or {}
	
	if table.count(var_20_0) > 1 then
		arg_20_0:updateDrawObjectsVisible(var_20_0, false)
		
		if not arg_20_0:findGroupIconByPos(arg_20_2) then
			arg_20_0:addGroupIconWithPos(arg_20_2)
		end
	else
		arg_20_0:updateDrawObjectsVisible(var_20_0, true)
		
		if arg_20_0:findGroupIconByPos(arg_20_2) then
			arg_20_0:removeGroupIconWithPos(arg_20_2)
		end
	end
end

function HTBMovableRenderer.base_requirePreload(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = HTBInterface:getMovablesByPos(arg_21_1, HTBInterface:getPosById(arg_21_2, arg_21_3))
	
	if not var_21_0 then
		return 
	end
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		local var_21_1 = arg_21_0.vars.id_to_draw_object[iter_21_1:getUID()]
		
		if not var_21_1.model then
			arg_21_0:preloadModel(var_21_1.model_unit)
		end
	end
end

function HTBMovableRenderer.base_setVisibleMovable(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	if not arg_22_0.vars or not arg_22_0.vars.deferred_create then
		return 
	end
	
	local var_22_0 = HTBInterface:getMovablesByPos(arg_22_1, HTBInterface:getPosById(arg_22_2, arg_22_4))
	
	if not var_22_0 then
		return 
	end
	
	if table.count(var_22_0) > 1 then
		for iter_22_0 = #var_22_0, 1, -1 do
			local var_22_1 = var_22_0[iter_22_0]
			
			if tostring(var_22_1:getUID()) ~= tostring(AccountData.id) and not var_22_1.is_running then
				table.remove(var_22_0, iter_22_0)
			end
		end
		
		if table.count(var_22_0) == 0 then
			return 
		end
	end
	
	local var_22_2 = arg_22_3 or false
	local var_22_3 = 100 - arg_22_0.vars.deferred_created_count
	
	for iter_22_1, iter_22_2 in pairs(var_22_0) do
		local var_22_4 = arg_22_0.vars.id_to_draw_object[iter_22_2:getUID()]
		
		if var_22_2 and iter_22_2:getUID() ~= AccountData.id then
			if not var_22_4.icon then
				arg_22_0:addIcon(var_22_4)
			end
		elseif not var_22_4.model and var_22_3 > 0 then
			arg_22_0:addModel(var_22_4)
			
			var_22_3 = var_22_3 - 1
		elseif not var_22_4.model then
			arg_22_0:addTempModel(var_22_4)
		end
		
		if var_22_4.icon then
			var_22_4.icon:setVisible(true)
		end
		
		if var_22_4.model then
			var_22_4.model:setVisible(true)
			
			var_22_4.last_visible_tm = uitick()
		end
	end
end

function HTBMovableRenderer.release(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.id_to_draw_object) do
		iter_23_1:removeFromParent()
	end
	
	arg_23_0.vars.id_to_draw_object = {}
end

function HTBMovableRenderer.firstDraw(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1
	
	arg_24_0.vars.id_to_draw_object = {}
	arg_24_0.vars.pos_to_draw_group_icon = {}
	
	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		arg_24_0:makeMovable(iter_24_1)
		arg_24_0:updateMovable(iter_24_1)
	end
end

function HTBMovableRenderer.removeGroupIconWithPos(arg_25_0, arg_25_1)
	local var_25_0 = HTUtil:getPosToHashKey(arg_25_1)
	
	arg_25_0.vars.pos_to_draw_group_icon[var_25_0]:removeFromParent()
	
	arg_25_0.vars.pos_to_draw_group_icon[var_25_0] = nil
end

function HTBMovableRenderer.setGroupIconVisible(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.vars.pos_to_draw_group_icon or {}
	
	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		if_set_visible(iter_26_1, nil, arg_26_1)
	end
end

function HTBMovableRenderer.addDrawObject(arg_27_0, arg_27_1)
	arg_27_0:makeMovable(arg_27_1)
	arg_27_0:updateMovable(arg_27_1)
end

function HTBMovableRenderer.removeDrawObject(arg_28_0, arg_28_1)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.layer) then
		return 
	end
	
	local var_28_0 = arg_28_1 or 0
	local var_28_1 = arg_28_0.vars.layer:findChildByName("movable_" .. tostring(var_28_0))
	
	if var_28_1 then
		if var_28_1.ui then
			var_28_1.ui:remove()
		end
		
		var_28_1:removeFromParent()
	end
	
	arg_28_0.vars.id_to_draw_object[var_28_0] = nil
end

function HTBMovableRenderer.updateDraw(arg_29_0, arg_29_1, arg_29_2)
end

function HTBMovableRenderer.addToLayerOnIcon(arg_30_0, arg_30_1)
	local var_30_0 = cc.Node:create()
	
	var_30_0:setName("movable_icon")
	
	var_30_0.is_icon = true
	
	var_30_0:addChild(arg_30_1)
	arg_30_0.vars.layer:addChild(var_30_0)
	
	return var_30_0
end

function HTBMovableRenderer.addToLayer(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = cc.Node:create()
	
	var_31_0:setName("movable_" .. tostring(arg_31_2:getUID()))
	
	var_31_0.model_unit = arg_31_1
	var_31_0.movable = arg_31_2
	
	arg_31_0.vars.layer:addChild(var_31_0)
	
	return var_31_0
end

function HTBMovableRenderer.preloadModel(arg_32_0, arg_32_1)
	local var_32_0, var_32_1 = getModelNameAndAtlasPath(arg_32_1.db.model_id, "model", arg_32_1.db.atlas)
	
	preload(var_32_0, var_32_1, {
		"idle",
		"run_start",
		"run",
		"camping"
	})
end

function HTBMovableRenderer.base__addModel(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	local var_33_0 = CACHE:getModel(arg_33_2.db.model_id, arg_33_2.db.skin, nil, arg_33_2.db.atlas, arg_33_2.db.model_opt)
	
	if not var_33_0 then
		Log.e("NOT EXIST MODEL ID ", arg_33_2.db.model_id)
		
		return 
	end
	
	arg_33_3:addChild(var_33_0)
	
	arg_33_3.model = var_33_0
	arg_33_3.last_visible_tm = uitick()
	arg_33_3.is_temp = arg_33_4
	
	local var_33_1 = var_33_0:createShadow()
	
	var_33_1:setGlobalZOrder(0)
	var_33_1:setLocalZOrder(-10)
	
	var_33_0._setScaleX = var_33_0.setScaleX
	
	function var_33_0.setScaleX(arg_34_0, arg_34_1)
		if get_cocos_refid(arg_34_0:getParent().ui) then
			arg_34_0:getParent().ui:onSetScaleX(arg_34_1)
		end
		
		arg_34_0:_setScaleX(arg_34_1)
	end
	
	var_33_0:setScale(tonumber(arg_33_3.movable.dir))
	
	if not arg_33_0.vars.skip_ui_mode and not arg_33_3.ui then
		local var_33_2, var_33_3 = var_33_0:getBonePosition("top")
		
		arg_33_3.ui = HTBInterface:createUIMovableInfo(arg_33_1, arg_33_3, arg_33_3.movable, var_33_3)
	end
	
	if not arg_33_4 then
		arg_33_0.vars.deferred_created_count = arg_33_0.vars.deferred_created_count + 1
	end
	
	arg_33_0:updatePosition(arg_33_3.movable, arg_33_3)
end

function HTBMovableRenderer.addTempModel(arg_35_0, arg_35_1)
	arg_35_0:_addModel(UNIT:create({
		code = "c1001"
	}), arg_35_1, true)
end

function HTBMovableRenderer.addModel(arg_36_0, arg_36_1)
	if get_cocos_refid(arg_36_1.model) then
		return 
	end
	
	local var_36_0 = arg_36_1.model_unit
	
	if not var_36_0 then
		Log.e("NOT EXIST MODEL UNIT")
		
		return 
	end
	
	arg_36_0:_addModel(var_36_0, arg_36_1)
end

function HTBMovableRenderer.removeModel(arg_37_0, arg_37_1)
	if get_cocos_refid(arg_37_1.model) then
		arg_37_1.model:cleanupReferencedObject()
		arg_37_1.model:removeFromParent()
		
		arg_37_1.model = nil
		
		if not arg_37_1.is_temp then
			arg_37_0.vars.deferred_created_count = arg_37_0.vars.deferred_created_count - 1
		end
		
		arg_37_1.is_temp = nil
	end
end

function HTBMovableRenderer.setMovableVisible(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_1:getUID()
	local var_38_1 = arg_38_0.vars.id_to_draw_object[var_38_0]
	
	if_set_visible(var_38_1, nil, arg_38_2)
	arg_38_0:setVisibleInfo(var_38_0, arg_38_2)
end

function HTBMovableRenderer.addJobLevelUpEffect(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.layer) then
		return 
	end
	
	arg_39_0:addEffectOnTop(arg_39_1, "ui_eff_roleup_" .. arg_39_2 .. ".cfx")
end

function HTBMovableRenderer.addSpawnEffect(arg_40_0, arg_40_1)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.layer) then
		return 
	end
	
	arg_40_0:addEffect(arg_40_1, "ui_eff_heritage_spwan.cfx")
	arg_40_0:setMovableVisible(arg_40_1, false)
	UIAction:Add(SEQ(DELAY(366), CALL(function()
		arg_40_0:setMovableVisible(arg_40_1, true)
	end)), arg_40_0)
end

function HTBMovableRenderer.addEffect(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.layer) then
		return 
	end
	
	local var_42_0 = EffectManager:Play({
		fn = arg_42_2 or "ui_pet_act_eff.cfx",
		layer = arg_42_0.vars.layer
	})
	local var_42_1 = arg_42_0.vars.id_to_draw_object[arg_42_1:getUID()]
	local var_42_2 = arg_42_0:calcMovableWorldPos(var_42_1, arg_42_1)
	
	var_42_0:setPosition(var_42_2.x, var_42_2.y)
end

function HTBMovableRenderer.addEffectToWaitQueue(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.layer) then
		return 
	end
	
	local var_43_0 = arg_43_1:getUID()
	
	if not arg_43_0.vars.wait_queue[var_43_0] then
		arg_43_0.vars.wait_queue[var_43_0] = {}
	end
	
	for iter_43_0 = 1, #arg_43_2 do
		if arg_43_3 then
			if not arg_43_0.vars.wait_queue[var_43_0][arg_43_3] then
				arg_43_0.vars.wait_queue[var_43_0][arg_43_3] = {}
			end
			
			table.insert(arg_43_0.vars.wait_queue[var_43_0][arg_43_3], arg_43_2[iter_43_0])
		else
			table.insert(arg_43_0.vars.wait_queue[var_43_0], arg_43_2[iter_43_0])
		end
	end
end

function HTBMovableRenderer.getStringListForArtifactEffects(arg_44_0, arg_44_1)
	local var_44_0 = {}
	
	for iter_44_0, iter_44_1 in pairs(arg_44_1) do
		table.insert(var_44_0, iter_44_0 .. "+" .. tostring(iter_44_1))
	end
	
	return var_44_0
end

function HTBMovableRenderer.addArtifactEffectsAction(arg_45_0, arg_45_1, arg_45_2)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.layer) then
		return 
	end
	
	local var_45_0 = {}
	
	for iter_45_0, iter_45_1 in pairs(arg_45_2) do
		var_45_0[iter_45_0] = iter_45_0 .. "+" .. tostring(iter_45_1)
	end
	
	arg_45_0:addMovableEffectAction(arg_45_1, var_45_0)
end

function HTBMovableRenderer.calcMovableWorldPos(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_2:getPos()
	
	return arg_46_0:calcTilePosToWorldPos(arg_46_1, var_46_0)
end

function HTBMovableRenderer.calcSpriteWorldPos(arg_47_0, arg_47_1, arg_47_2)
	return arg_47_0:calcTilePosToWorldPos(arg_47_1, arg_47_2)
end

function HTBMovableRenderer.getModelScale(arg_48_0, arg_48_1)
	return 0.6
end

function HTBMovableRenderer.getIconScale(arg_49_0)
	return 0.6
end

function HTBMovableRenderer.setDrawObjectScale(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_1.model
	local var_50_1 = arg_50_1.icon
	
	if not var_50_0 and not var_50_1 then
		return 
	end
	
	if var_50_0 then
		local var_50_2 = arg_50_0:getModelScale(var_50_0)
		
		var_50_0:setScale(var_50_2)
	end
	
	if var_50_1 then
		local var_50_3 = arg_50_0:getIconScale()
		
		var_50_1:setScale(var_50_3)
	end
	
	if arg_50_1.ui then
		arg_50_1.ui:updateUIScale()
	end
end

function HTBMovableRenderer.updateMovableInfoUIScale(arg_51_0)
	for iter_51_0, iter_51_1 in pairs(arg_51_0.vars.id_to_draw_object) do
		if get_cocos_refid(iter_51_1) and iter_51_1.ui then
			iter_51_1.ui:updateUIScale()
		end
	end
end

function HTBMovableRenderer.updatePosition(arg_52_0, arg_52_1, arg_52_2)
	arg_52_0:setDrawObjectScale(arg_52_2)
	
	local var_52_0 = arg_52_1:getPos()
	
	arg_52_0:setPosition(arg_52_2, var_52_0)
	arg_52_0:updateColor(arg_52_2, var_52_0)
	arg_52_0:updateGroupView(arg_52_1:getPos())
end

function HTBMovableRenderer.updateMovable(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0.vars.id_to_draw_object[arg_53_1:getUID()]
	
	arg_53_0:updatePosition(arg_53_1, var_53_0)
	arg_53_0:updateMovableExp(arg_53_1)
end

function HTBMovableRenderer.updateMovableExp(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.vars.id_to_draw_object[arg_54_1:getUID()]
	
	if not var_54_0 then
		print("NO MODEL!!!!")
		
		return 
	end
	
	if var_54_0.ui then
		var_54_0.ui:updateUI()
	end
end

function HTBMovableRenderer.setPosition(arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = arg_55_0:calcTilePosToWorldPos(arg_55_1, arg_55_2)
	
	arg_55_1:setPosition(var_55_0.x, var_55_0.y)
	arg_55_1:setLocalZOrder(arg_55_2.y * -5 + 1)
end

function HTBMovableRenderer.startCampingAnimation(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.vars.id_to_draw_object[arg_56_1:getUID()].model
	
	if not var_56_0 then
		return 
	end
	
	var_56_0:setAnimation(0, "camping", true)
end

function HTBMovableRenderer.startRunAnimation(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0.vars.id_to_draw_object[arg_57_1:getUID()].model
	
	if not var_57_0 then
		return 
	end
	
	var_57_0:playRunAnimation()
end

function HTBMovableRenderer.stopRunAnimation(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0.vars.id_to_draw_object[arg_58_1:getUID()].model
	
	if not var_58_0 then
		return 
	end
	
	var_58_0:setAnimation(0, "idle", true)
end

function HTBMovableRenderer.getDrawObject(arg_59_0, arg_59_1)
	if not arg_59_0.vars then
		return 
	end
	
	return arg_59_0.vars.id_to_draw_object[arg_59_1:getUID()]
end

function HTBMovableRenderer.setPosMovable(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_0.vars.id_to_draw_object[arg_60_1:getUID()]
	
	arg_60_0:setPosition(var_60_0, arg_60_2)
end

function HTBMovableRenderer.getFocusYPosition(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0.vars.id_to_draw_object[arg_61_1]
	
	if not var_61_0 then
		return 
	end
	
	if var_61_0.icon then
		return var_61_0:getPositionY() + 72
	end
	
	local var_61_1 = var_61_0.model
	
	if not var_61_1 then
		return 
	end
	
	if var_61_1.getBonePosition then
		local var_61_2, var_61_3 = var_61_1:getBonePosition("top")
		
		return var_61_3 + var_61_0:getPositionY()
	end
	
	return var_61_0:getPositionY() + var_61_1:getContentSize().height
end

function HTBMovableRenderer.setVisibleInfo(arg_62_0, arg_62_1, arg_62_2)
	local var_62_0 = arg_62_0.vars.id_to_draw_object[arg_62_1]
	
	if not var_62_0 then
		return 
	end
	
	if var_62_0.ui then
		var_62_0.ui:setVisible(arg_62_2)
	end
end

function HTBMovableRenderer.visibleOff(arg_63_0)
	for iter_63_0, iter_63_1 in pairs(arg_63_0.vars.id_to_draw_object) do
		if iter_63_1.model then
			iter_63_1.model:setVisible(false)
		end
	end
end

function HTBMovableRenderer.visibleOnlyCurrentPlayer(arg_64_0)
	local var_64_0 = tostring(AccountData.id)
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0.vars.id_to_draw_object) do
		if iter_64_1.model then
			iter_64_1.model:setVisible(tostring(iter_64_0) == var_64_0)
		end
		
		if iter_64_1.icon then
			iter_64_1.icon:setVisible(tostring(iter_64_0) == var_64_0)
		end
	end
end

function HTBMovableRenderer.considerExpire(arg_65_0)
	local var_65_0 = uitick()
	local var_65_1 = 0
	
	for iter_65_0, iter_65_1 in pairs(arg_65_0.vars.id_to_draw_object) do
		if iter_65_1.last_visible_tm and var_65_0 - iter_65_1.last_visible_tm > 500 then
			arg_65_0:setVisibleInfo(iter_65_0, false)
			arg_65_0:removeModel(iter_65_1)
			
			var_65_1 = var_65_1 + 1
		end
	end
	
	return 0, var_65_1
end

function HTBMovableRenderer.close(arg_66_0)
	if not arg_66_0.vars or not get_cocos_refid(arg_66_0.vars.layer) then
		return 
	end
	
	arg_66_0.vars.layer:removeFromParent()
	
	arg_66_0.vars.layer = nil
	arg_66_0.vars = nil
end
