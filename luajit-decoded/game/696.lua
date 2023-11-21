LotaMovableRenderer = {}

function LotaMovableRenderer.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.wait_queue = {}
	arg_1_0.vars.layer = arg_1_1
	arg_1_0.vars.adjust_y_model_pos = 75
	arg_1_0.vars.skip_ui_mode = arg_1_2
	arg_1_0.vars.deferred_create = SceneManager:getCurrentSceneName() == "lota"
	arg_1_0.vars.deferred_created_count = 0
	
	LotaWhiteboard:set("model_adjust_magic_pos", arg_1_0.vars.adjust_y_model_pos)
end

function LotaMovableRenderer.release(arg_2_0)
	for iter_2_0, iter_2_1 in pairs(arg_2_0.vars.id_to_draw_object) do
		iter_2_1:removeFromParent()
	end
	
	arg_2_0.vars.id_to_draw_object = {}
end

function LotaMovableRenderer.firstDraw(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1
	
	arg_3_0.vars.id_to_draw_object = {}
	arg_3_0.vars.pos_to_draw_group_icon = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		arg_3_0:makeMovable(iter_3_1)
		arg_3_0:updateMovable(iter_3_1)
	end
end

function LotaMovableRenderer.findGroupIconByPos(arg_4_0, arg_4_1)
	local var_4_0 = LotaUtil:getPosToHashKey(arg_4_1)
	
	return arg_4_0.vars.pos_to_draw_group_icon[var_4_0]
end

function LotaMovableRenderer.addGroupIconWithPos(arg_5_0, arg_5_1)
	local var_5_0 = LotaUtil:getPosToHashKey(arg_5_1)
	local var_5_1 = SpriteCache:getSprite("tile/heritage_icon_people.png")
	
	var_5_1:setScale(0.6)
	
	local var_5_2 = arg_5_0:addToLayerOnIcon(var_5_1)
	
	arg_5_0.vars.pos_to_draw_group_icon[var_5_0] = var_5_2
	
	local var_5_3 = arg_5_0:calcSpriteWorldPos(var_5_2, arg_5_1)
	
	var_5_2:setLocalZOrder(arg_5_1.y * -5 + 2)
	var_5_2:setPosition(var_5_3.x, var_5_3.y + 26)
	
	return var_5_2
end

function LotaMovableRenderer.removeGroupIconWithPos(arg_6_0, arg_6_1)
	local var_6_0 = LotaUtil:getPosToHashKey(arg_6_1)
	
	arg_6_0.vars.pos_to_draw_group_icon[var_6_0]:removeFromParent()
	
	arg_6_0.vars.pos_to_draw_group_icon[var_6_0] = nil
end

function LotaMovableRenderer.setGroupIconVisible(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.pos_to_draw_group_icon or {}
	
	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if_set_visible(iter_7_1, nil, arg_7_1)
	end
end

function LotaMovableRenderer.addDrawObject(arg_8_0, arg_8_1)
	arg_8_0:makeMovable(arg_8_1)
	arg_8_0:updateMovable(arg_8_1)
end

function LotaMovableRenderer.removeDrawObject(arg_9_0, arg_9_1)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.layer) then
		return 
	end
	
	local var_9_0 = arg_9_1 or 0
	local var_9_1 = arg_9_0.vars.layer:findChildByName("movable_" .. tostring(var_9_0))
	
	if var_9_1 then
		if var_9_1.ui then
			var_9_1.ui:remove()
		end
		
		var_9_1:removeFromParent()
	end
	
	arg_9_0.vars.id_to_draw_object[var_9_0] = nil
end

function LotaMovableRenderer.updateDraw(arg_10_0, arg_10_1, arg_10_2)
end

function LotaMovableRenderer.addToLayerOnIcon(arg_11_0, arg_11_1)
	local var_11_0 = LotaWhiteboard:get("ambient_color")
	local var_11_1 = cc.Node:create()
	
	var_11_1:setName("movable_icon")
	
	var_11_1.is_icon = true
	
	var_11_1:addChild(arg_11_1)
	arg_11_0.vars.layer:addChild(var_11_1)
	
	return var_11_1
end

function LotaMovableRenderer.addToLayer(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = LotaWhiteboard:get("ambient_color")
	local var_12_1 = cc.Node:create()
	
	var_12_1:setName("movable_" .. tostring(arg_12_2:getUID()))
	
	var_12_1.model_unit = arg_12_1
	var_12_1.movable = arg_12_2
	
	arg_12_0.vars.layer:addChild(var_12_1)
	
	return var_12_1
end

function LotaMovableRenderer.preloadModel(arg_13_0, arg_13_1)
	local var_13_0, var_13_1 = getModelNameAndAtlasPath(arg_13_1.db.model_id, "model", arg_13_1.db.atlas)
	
	preload(var_13_0, var_13_1, {
		"idle",
		"run_start",
		"run",
		"camping"
	})
end

function LotaMovableRenderer._addModel(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = CACHE:getModel(arg_14_1.db.model_id, arg_14_1.db.skin, nil, arg_14_1.db.atlas, arg_14_1.db.model_opt)
	
	if not var_14_0 then
		Log.e("NOT EXIST MODEL ID ", arg_14_1.db.model_id)
		
		return 
	end
	
	arg_14_2:addChild(var_14_0)
	
	arg_14_2.model = var_14_0
	arg_14_2.last_visible_tm = uitick()
	arg_14_2.is_temp = arg_14_3
	
	local var_14_1 = var_14_0:createShadow()
	
	var_14_1:setGlobalZOrder(0)
	var_14_1:setLocalZOrder(-10)
	
	var_14_0._setScaleX = var_14_0.setScaleX
	
	function var_14_0.setScaleX(arg_15_0, arg_15_1)
		arg_15_0:getParent().ui:onSetScaleX(arg_15_1)
		arg_15_0:_setScaleX(arg_15_1)
	end
	
	var_14_0:setScale(tonumber(arg_14_2.movable.dir))
	
	if not arg_14_0.vars.skip_ui_mode and not arg_14_2.ui then
		local var_14_2, var_14_3 = var_14_0:getBonePosition("top")
		
		arg_14_2.ui = LotaUIMovableInfo(arg_14_2, arg_14_2.movable, var_14_3)
	end
	
	if not arg_14_3 then
		arg_14_0.vars.deferred_created_count = arg_14_0.vars.deferred_created_count + 1
	end
	
	arg_14_0:updatePosition(arg_14_2.movable, arg_14_2)
end

function LotaMovableRenderer.addTempModel(arg_16_0, arg_16_1)
	arg_16_0:_addModel(UNIT:create({
		code = "c1001"
	}), arg_16_1, true)
end

function LotaMovableRenderer.addModel(arg_17_0, arg_17_1)
	if get_cocos_refid(arg_17_1.model) then
		return 
	end
	
	local var_17_0 = arg_17_1.model_unit
	
	if not var_17_0 then
		Log.e("NOT EXIST MODEL UNIT")
		
		return 
	end
	
	arg_17_0:_addModel(var_17_0, arg_17_1)
end

function LotaMovableRenderer.addIcon(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1.movable
	local var_18_1 = var_18_0:getLeaderCode()
	local var_18_2 = var_18_0:getBorderCode()
	local var_18_3 = UIUtil:getLightIcon(var_18_1, var_18_2, arg_18_0:getIconScale())
	
	arg_18_1:addChild(var_18_3)
	
	arg_18_1.icon = var_18_3
	
	if not arg_18_0.vars.skip_ui_mode and not arg_18_1.ui then
		arg_18_1.ui = LotaUIMovableInfo(arg_18_1, var_18_0, 58)
	end
	
	var_18_3:setPositionY(12)
	arg_18_0:updatePosition(arg_18_1.movable, arg_18_1)
end

function LotaMovableRenderer.removeModel(arg_19_0, arg_19_1)
	if get_cocos_refid(arg_19_1.model) then
		arg_19_1.model:cleanupReferencedObject()
		arg_19_1.model:removeFromParent()
		
		arg_19_1.model = nil
		
		if not arg_19_1.is_temp then
			arg_19_0.vars.deferred_created_count = arg_19_0.vars.deferred_created_count - 1
		end
		
		arg_19_1.is_temp = nil
	end
end

function LotaMovableRenderer.makeMovable(arg_20_0, arg_20_1)
	local var_20_0 = UNIT:create({
		code = arg_20_1.leader_code
	})
	local var_20_1 = arg_20_0:addToLayer(var_20_0, arg_20_1)
	local var_20_2 = SAVE:get("lota_low_spec", false)
	
	if not arg_20_0.vars.deferred_create then
		if var_20_2 and SceneManager:getCurrentSceneName() == "lota" and arg_20_1:getUID() ~= AccountData.id then
			arg_20_0:addIcon(var_20_1)
		else
			arg_20_0:addModel(var_20_1)
		end
	end
	
	arg_20_0.vars.id_to_draw_object[arg_20_1:getUID()] = var_20_1
	var_20_1._setPosition = var_20_1.setPosition
	var_20_1._setPositionX = var_20_1.setPositionX
	var_20_1._setPositionY = var_20_1.setPositionY
	
	function var_20_1.setPosition(arg_21_0, arg_21_1, arg_21_2)
		if arg_21_0.ui then
			arg_21_0.ui:updatePosition(arg_21_1, arg_21_2)
		end
		
		arg_21_0:_setPosition(arg_21_1, arg_21_2)
	end
	
	function var_20_1.setPositionX(arg_22_0, arg_22_1)
		if arg_22_0.ui then
			arg_22_0.ui:updatePosition(arg_22_1, arg_22_0:getPositionY())
		end
		
		arg_22_0:_setPositionX(arg_22_1)
	end
	
	function var_20_1.setPositionY(arg_23_0, arg_23_1)
		if arg_23_0.ui then
			arg_23_0.ui:updatePosition(arg_23_0:getPositionX(), arg_23_1)
		end
		
		arg_23_0:_setPositionY(arg_23_1)
	end
end

function LotaMovableRenderer.calcTilePosToWorldPos(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.layer) then
		return 
	end
	
	local var_24_0 = LotaUtil:calcTilePosToWorldPos(arg_24_2)
	local var_24_1 = arg_24_0.vars.adjust_y_model_pos
	local var_24_2 = arg_24_1.model
	local var_24_3 = 0
	
	if var_24_2 then
		local var_24_4
		local var_24_5
		
		if var_24_2.getBonePosition then
			local var_24_6
			
			var_24_6, var_24_5 = var_24_2.body:getBonePosition("root")
		else
			var_24_5 = var_24_2:getContentSize().height
		end
		
		var_24_3 = var_24_5 * arg_24_0:getModelScale(var_24_2) * 0.5
	end
	
	var_24_0.y = var_24_0.y + var_24_3 + var_24_1
	
	return var_24_0
end

function LotaMovableRenderer.setMovableVisible(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1:getUID()
	local var_25_1 = arg_25_0.vars.id_to_draw_object[var_25_0]
	
	if_set_visible(var_25_1, nil, arg_25_2)
	LotaMovableRenderer:setVisibleInfo(var_25_0, arg_25_2)
end

function LotaMovableRenderer.addLevelUpEffect(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.layer) then
		return 
	end
	
	arg_26_0:addEffect(arg_26_1, "ui_eff_heritage_levelup.cfx")
	
	arg_26_2 = arg_26_2 or 1
	
	if arg_26_1:getUID() == AccountData.id then
		UIAction:Add(SEQ(DELAY(1500), CALL(function()
			for iter_27_0 = 1, arg_26_2 do
				if arg_26_3 then
					LotaUtil:openUserLevelUpPopup(arg_26_3 - (arg_26_2 - iter_27_0))
				else
					LotaUserData:openUserLevelUpPopup(arg_26_2 - (iter_27_0 - 1))
				end
			end
		end)), arg_26_0.vars.layer, "block")
	end
end

function LotaMovableRenderer.addJobLevelUpEffect(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.layer) then
		return 
	end
	
	arg_28_0:addEffectOnTop(arg_28_1, "ui_eff_roleup_" .. arg_28_2 .. ".cfx")
end

function LotaMovableRenderer.addSpawnEffect(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.layer) then
		return 
	end
	
	arg_29_0:addEffect(arg_29_1, "ui_eff_heritage_spwan.cfx")
	arg_29_0:setMovableVisible(arg_29_1, false)
	UIAction:Add(SEQ(DELAY(366), CALL(function()
		arg_29_0:setMovableVisible(arg_29_1, true)
	end)), arg_29_0)
end

function LotaMovableRenderer.addEffectOnTop(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0.vars then
		return 
	end
	
	local var_31_0 = cc.Node:create()
	local var_31_1 = arg_31_1:getUID()
	local var_31_2 = EffectManager:Play({
		scale = 0.9,
		fn = arg_31_2 or "ui_pet_act_eff.cfx",
		layer = var_31_0
	})
	local var_31_3 = arg_31_0.vars.id_to_draw_object[var_31_1]
	local var_31_4 = arg_31_0:calcMovableWorldPos(var_31_3, arg_31_1)
	local var_31_5 = arg_31_0:getFocusYPosition(var_31_1)
	
	var_31_2:setPosition(var_31_4.x, var_31_5 + 30)
	LotaSystem:addToEffectFieldUI(var_31_0)
	UIAction:Add(SEQ(DELAY(1333), REMOVE()), var_31_0)
end

function LotaMovableRenderer.addEffect(arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.layer) then
		return 
	end
	
	local var_32_0 = EffectManager:Play({
		fn = arg_32_2 or "ui_pet_act_eff.cfx",
		layer = arg_32_0.vars.layer
	})
	local var_32_1 = arg_32_0.vars.id_to_draw_object[arg_32_1:getUID()]
	local var_32_2 = arg_32_0:calcMovableWorldPos(var_32_1, arg_32_1)
	
	var_32_0:setPosition(var_32_2.x, var_32_2.y)
end

function LotaMovableRenderer.addEffectToWaitQueue(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.layer) then
		return 
	end
	
	local var_33_0 = arg_33_1:getUID()
	
	if not arg_33_0.vars.wait_queue[var_33_0] then
		arg_33_0.vars.wait_queue[var_33_0] = {}
	end
	
	for iter_33_0 = 1, #arg_33_2 do
		if arg_33_3 then
			if not arg_33_0.vars.wait_queue[var_33_0][arg_33_3] then
				arg_33_0.vars.wait_queue[var_33_0][arg_33_3] = {}
			end
			
			table.insert(arg_33_0.vars.wait_queue[var_33_0][arg_33_3], arg_33_2[iter_33_0])
		else
			table.insert(arg_33_0.vars.wait_queue[var_33_0], arg_33_2[iter_33_0])
		end
	end
end

function LotaMovableRenderer.procEffectsOnWaitQueue(arg_34_0)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.layer) then
		return 
	end
	
	for iter_34_0, iter_34_1 in pairs(arg_34_0.vars.wait_queue) do
		if iter_34_1.low then
			for iter_34_2, iter_34_3 in pairs(iter_34_1.low) do
				table.insert(iter_34_1, iter_34_3)
			end
			
			iter_34_1.low = nil
		end
	end
	
	for iter_34_4, iter_34_5 in pairs(arg_34_0.vars.wait_queue) do
		local var_34_0 = LotaMovableSystem:getMovableById(iter_34_4)
		
		arg_34_0:addMovableEffectAction(var_34_0, iter_34_5)
	end
	
	arg_34_0.vars.wait_queue = {}
end

function LotaMovableRenderer.addMovableEffectAction(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.layer) then
		return 
	end
	
	local var_35_0 = cc.Node:create()
	
	var_35_0:setName("string_list_actions")
	
	local var_35_1 = 0
	local var_35_2 = 1000
	
	var_35_0:setScale(0.75)
	
	for iter_35_0, iter_35_1 in pairs(arg_35_2) do
		if type(iter_35_1) == "string" or type(iter_35_1) == "table" then
			local var_35_3
			
			if type(iter_35_1) == "table" then
				var_35_3 = load_control("wnd/clan_heritage_exp.csb")
				
				local var_35_4 = var_35_3:getChildByName("t_exp")
				
				if_set(var_35_4, nil, "+" .. iter_35_1.exp)
				
				if iter_35_1.additional_exp then
					if_set_visible(var_35_3, "n_exp_add", true)
					if_set(var_35_3, "t_exp_add", iter_35_1.additional_exp)
					
					if get_cocos_refid(var_35_4) then
						local var_35_5 = var_35_4:getContentSize().width * var_35_4:getScaleX() * 0.5 + 40
						
						if_set_position_x(var_35_3, "n_exp_add", var_35_5)
					end
				end
			else
				var_35_3 = LotaUtil:createDebugLabel(iter_35_0, iter_35_1, {
					width = 100,
					height = 30
				}, cc.c3b(0, 0, 0), nil, true)
			end
			
			var_35_3:setOpacity(0)
			var_35_3:setPositionY(0)
			var_35_0:addChild(var_35_3)
			UIAction:Add(SEQ(DELAY(var_35_1), SEQ(SPAWN(MOVE_TO(var_35_2, 0, 100), SEQ(LOG(FADE_IN(var_35_2 / 2)), RLOG(FADE_OUT(var_35_2 / 2)))), REMOVE())), var_35_3)
		elseif type(iter_35_1) == "function" then
			UIAction:Add(SEQ(DELAY(var_35_1), CALL(iter_35_1)), arg_35_0.vars.layer)
		end
		
		var_35_1 = var_35_1 + var_35_2
	end
	
	UIAction:Add(SEQ(DELAY(var_35_1), REMOVE()), var_35_0)
	
	local var_35_6 = arg_35_0.vars.id_to_draw_object[arg_35_1:getUID()]
	
	if not get_cocos_refid(var_35_6) then
		return 
	end
	
	local var_35_7 = arg_35_0:calcMovableWorldPos(var_35_6, arg_35_1)
	
	LotaSystem:addToEffectFieldUI(var_35_0)
	var_35_0:setLocalZOrder(9999999)
	var_35_0:setPosition(var_35_7.x, var_35_7.y)
end

function LotaMovableRenderer.getStringListForArtifactEffects(arg_36_0, arg_36_1)
	local var_36_0 = {}
	
	for iter_36_0, iter_36_1 in pairs(arg_36_1) do
		table.insert(var_36_0, iter_36_0 .. "+" .. tostring(iter_36_1))
	end
	
	return var_36_0
end

function LotaMovableRenderer.addArtifactEffectsAction(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.layer) then
		return 
	end
	
	local var_37_0 = {}
	
	for iter_37_0, iter_37_1 in pairs(arg_37_2) do
		var_37_0[iter_37_0] = iter_37_0 .. "+" .. tostring(iter_37_1)
	end
	
	arg_37_0:addMovableEffectAction(arg_37_1, var_37_0)
end

function LotaMovableRenderer.calcMovableWorldPos(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_2:getPos()
	
	return arg_38_0:calcTilePosToWorldPos(arg_38_1, var_38_0)
end

function LotaMovableRenderer.calcSpriteWorldPos(arg_39_0, arg_39_1, arg_39_2)
	return arg_39_0:calcTilePosToWorldPos(arg_39_1, arg_39_2)
end

function LotaMovableRenderer.getModelScale(arg_40_0, arg_40_1)
	return 0.6
end

function LotaMovableRenderer.getIconScale(arg_41_0)
	return 0.6
end

function LotaMovableRenderer.setDrawObjectScale(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1.model
	local var_42_1 = arg_42_1.icon
	
	if not var_42_0 and not var_42_1 then
		return 
	end
	
	if var_42_0 then
		local var_42_2 = arg_42_0:getModelScale(var_42_0)
		
		var_42_0:setScale(var_42_2)
	end
	
	if var_42_1 then
		local var_42_3 = arg_42_0:getIconScale()
		
		var_42_1:setScale(var_42_3)
	end
	
	if arg_42_1.ui then
		arg_42_1.ui:updateUIScale()
	end
end

function LotaMovableRenderer.updateMovableInfoUIScale(arg_43_0)
	for iter_43_0, iter_43_1 in pairs(arg_43_0.vars.id_to_draw_object) do
		if get_cocos_refid(iter_43_1) and iter_43_1.ui then
			iter_43_1.ui:updateUIScale()
		end
	end
end

function LotaMovableRenderer.updatePosition(arg_44_0, arg_44_1, arg_44_2)
	arg_44_0:setDrawObjectScale(arg_44_2)
	
	local var_44_0 = arg_44_1:getPos()
	
	arg_44_0:setPosition(arg_44_2, var_44_0)
	arg_44_0:updateColor(arg_44_2, var_44_0)
	arg_44_0:updateGroupView(arg_44_1:getPos())
end

function LotaMovableRenderer.updateColor(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = LotaFogSystem:getFogVisibility(arg_45_2.x, arg_45_2.y)
	
	arg_45_0:setFogColorToDrawObject(arg_45_1, var_45_0)
end

function LotaMovableRenderer.setFogColorToDrawObject(arg_46_0, arg_46_1, arg_46_2)
	if not arg_46_1.model then
		return 
	end
	
	local var_46_0 = 1
	
	if arg_46_2 == LotaFogVisibilityEnum.DISCOVER then
		var_46_0 = 0.7352941176470589
	elseif arg_46_2 == LotaFogVisibilityEnum.NOT_DISCOVER then
		var_46_0 = 0.5
	end
	
	local var_46_1 = LotaWhiteboard:get("ambient_color")
	local var_46_2 = cc.c3b(var_46_1.r * var_46_0, var_46_1.g * var_46_0, var_46_1.b * var_46_0)
	
	arg_46_1.model:setColor(var_46_2)
end

function LotaMovableRenderer.updateColorByFog(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = LotaMovableSystem:getMovablesByPos({
		x = arg_47_1,
		y = arg_47_2
	})
	
	if not var_47_0 then
		return 
	end
	
	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		local var_47_1 = arg_47_0.vars.id_to_draw_object[iter_47_1:getUID()]
		
		if var_47_1 then
			arg_47_0:setFogColorToDrawObject(var_47_1, arg_47_3)
		end
	end
end

function LotaMovableRenderer.updateMovable(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0.vars.id_to_draw_object[arg_48_1:getUID()]
	
	arg_48_0:updatePosition(arg_48_1, var_48_0)
	arg_48_0:updateMovableExp(arg_48_1)
end

function LotaMovableRenderer.updateMovableExp(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0.vars.id_to_draw_object[arg_49_1:getUID()]
	
	if not var_49_0 then
		print("NO MODEL!!!!")
		
		return 
	end
	
	if var_49_0.ui then
		var_49_0.ui:updateUI()
	end
end

function LotaMovableRenderer.isRequireGroupView(arg_50_0, arg_50_1, arg_50_2)
	arg_50_2 = arg_50_2 or LotaMovableSystem:getMovablesByPos(arg_50_1)
	
	return table.count(arg_50_2) > 1
end

function LotaMovableRenderer.updateDrawObjectsVisible(arg_51_0, arg_51_1, arg_51_2)
	for iter_51_0, iter_51_1 in pairs(arg_51_1) do
		local var_51_0 = iter_51_1:getUID() == AccountData.id
		local var_51_1 = var_51_0 or iter_51_1.is_running or arg_51_2
		
		if var_51_0 and LotaMovableSystem:isProcJumpPath() then
			var_51_1 = false
		end
		
		arg_51_0:setMovableVisible(iter_51_1, var_51_1)
	end
end

function LotaMovableRenderer.updateGroupView(arg_52_0, arg_52_1)
	local var_52_0 = LotaMovableSystem:getMovablesByPos(arg_52_1) or {}
	
	if table.count(var_52_0) > 1 then
		arg_52_0:updateDrawObjectsVisible(var_52_0, false)
		
		if not arg_52_0:findGroupIconByPos(arg_52_1) then
			arg_52_0:addGroupIconWithPos(arg_52_1)
		end
	else
		arg_52_0:updateDrawObjectsVisible(var_52_0, true)
		
		if arg_52_0:findGroupIconByPos(arg_52_1) then
			arg_52_0:removeGroupIconWithPos(arg_52_1)
		end
	end
end

function LotaMovableRenderer.setPosition(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0:calcTilePosToWorldPos(arg_53_1, arg_53_2)
	
	arg_53_1:setPosition(var_53_0.x, var_53_0.y)
	arg_53_1:setLocalZOrder(arg_53_2.y * -5 + 1)
end

function LotaMovableRenderer.startCampingAnimation(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0.vars.id_to_draw_object[arg_54_1:getUID()].model
	
	if not var_54_0 then
		return 
	end
	
	var_54_0:setAnimation(0, "camping", true)
end

function LotaMovableRenderer.startRunAnimation(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0.vars.id_to_draw_object[arg_55_1:getUID()].model
	
	if not var_55_0 then
		return 
	end
	
	var_55_0:playRunAnimation()
end

function LotaMovableRenderer.stopRunAnimation(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.vars.id_to_draw_object[arg_56_1:getUID()].model
	
	if not var_56_0 then
		return 
	end
	
	var_56_0:setAnimation(0, "idle", true)
end

function LotaMovableRenderer.getDrawObject(arg_57_0, arg_57_1)
	if not arg_57_0.vars then
		return 
	end
	
	return arg_57_0.vars.id_to_draw_object[arg_57_1:getUID()]
end

function LotaMovableRenderer.setPosMovable(arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = arg_58_0.vars.id_to_draw_object[arg_58_1:getUID()]
	
	arg_58_0:setPosition(var_58_0, arg_58_2)
end

function LotaMovableRenderer.getFocusYPosition(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0.vars.id_to_draw_object[arg_59_1]
	
	if not var_59_0 then
		return 
	end
	
	if var_59_0.icon then
		return var_59_0:getPositionY() + 72
	end
	
	local var_59_1 = var_59_0.model
	
	if not var_59_1 then
		return 
	end
	
	if var_59_1.getBonePosition then
		local var_59_2, var_59_3 = var_59_1:getBonePosition("top")
		
		return var_59_3 + var_59_0:getPositionY()
	end
	
	return var_59_0:getPositionY() + var_59_1:getContentSize().height
end

function LotaMovableRenderer.setVisibleInfo(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_0.vars.id_to_draw_object[arg_60_1]
	
	if not var_60_0 then
		return 
	end
	
	if var_60_0.ui then
		var_60_0.ui:setVisible(arg_60_2)
	end
end

function LotaMovableRenderer.visibleOff(arg_61_0)
	for iter_61_0, iter_61_1 in pairs(arg_61_0.vars.id_to_draw_object) do
		if iter_61_1.model then
			iter_61_1.model:setVisible(false)
		end
	end
end

function LotaMovableRenderer.visibleOnlyCurrentPlayer(arg_62_0)
	local var_62_0 = tostring(AccountData.id)
	
	for iter_62_0, iter_62_1 in pairs(arg_62_0.vars.id_to_draw_object) do
		if iter_62_1.model then
			iter_62_1.model:setVisible(tostring(iter_62_0) == var_62_0)
		end
		
		if iter_62_1.icon then
			iter_62_1.icon:setVisible(tostring(iter_62_0) == var_62_0)
		end
	end
end

function LotaMovableRenderer.requirePreload(arg_63_0, arg_63_1)
	local var_63_0 = LotaMovableSystem:getMovablesByPos(LotaTileMapSystem:getPosById(arg_63_1))
	
	if not var_63_0 then
		return 
	end
	
	for iter_63_0, iter_63_1 in pairs(var_63_0) do
		local var_63_1 = arg_63_0.vars.id_to_draw_object[iter_63_1:getUID()]
		
		if not var_63_1.model then
			arg_63_0:preloadModel(var_63_1.model_unit)
		end
	end
end

function LotaMovableRenderer.setVisibleMovable(arg_64_0, arg_64_1)
	if not arg_64_0.vars or not arg_64_0.vars.deferred_create then
		return 
	end
	
	local var_64_0 = LotaMovableSystem:getMovablesByPos(LotaTileMapSystem:getPosById(arg_64_1))
	
	if not var_64_0 then
		return 
	end
	
	if table.count(var_64_0) > 1 then
		for iter_64_0 = #var_64_0, 1, -1 do
			local var_64_1 = var_64_0[iter_64_0]
			
			if tostring(var_64_1:getUID()) ~= tostring(AccountData.id) and not var_64_1.is_running then
				table.remove(var_64_0, iter_64_0)
			end
		end
		
		if table.count(var_64_0) == 0 then
			return 
		end
	end
	
	local var_64_2 = LotaWhiteboard:get("low_spec")
	local var_64_3 = 100 - arg_64_0.vars.deferred_created_count
	
	for iter_64_1, iter_64_2 in pairs(var_64_0) do
		local var_64_4 = arg_64_0.vars.id_to_draw_object[iter_64_2:getUID()]
		
		if var_64_2 and iter_64_2:getUID() ~= AccountData.id then
			if not var_64_4.icon then
				arg_64_0:addIcon(var_64_4)
			end
		elseif not var_64_4.model and var_64_3 > 0 then
			arg_64_0:addModel(var_64_4)
			
			var_64_3 = var_64_3 - 1
		elseif not var_64_4.model then
			arg_64_0:addTempModel(var_64_4)
		end
		
		if var_64_4.icon then
			var_64_4.icon:setVisible(true)
		end
		
		if var_64_4.model then
			var_64_4.model:setVisible(true)
			
			var_64_4.last_visible_tm = uitick()
		end
	end
end

function LotaMovableRenderer.considerExpire(arg_65_0)
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

function LotaMovableRenderer.close(arg_66_0)
	if not arg_66_0.vars or not get_cocos_refid(arg_66_0.vars.layer) then
		return 
	end
	
	arg_66_0.vars.layer:removeFromParent()
	
	arg_66_0.vars.layer = nil
	arg_66_0.vars = nil
end
