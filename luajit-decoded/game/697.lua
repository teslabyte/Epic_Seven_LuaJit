LotaObjectRenderer = {}

local function var_0_0()
	if PRODUCTION_MODE then
		return 
	end
	
	local var_1_0 = {}
	
	for iter_1_0 = 1, 9999 do
		local var_1_1, var_1_2 = DBN("clan_heritage_object_icon", iter_1_0, {
			"id",
			"character"
		})
		
		if not var_1_1 then
			break
		end
		
		if var_1_2 and not DB("character", var_1_2, "model_id") then
			table.insert(var_1_0, var_1_1)
		end
	end
	
	if table.count(var_1_0) > 0 then
		print("CHARACTER 컬럼은 존재하지만 CHARACTER DB에 없는 ID LIST!")
		table.print(var_1_0)
		error("CHARACTER COLUMN EXIST, BUT CHARACTER DB WAS NOT EXIST!! CHECK CONSOLE!")
	end
end

DEBUG.LOTA_ICON_MODE = false

function LotaObjectRenderer.init(arg_2_0, arg_2_1)
	var_0_0()
	
	arg_2_0.vars = {}
	arg_2_0.vars.object_layer = arg_2_1
	arg_2_0.vars.object_hash = {}
	arg_2_0.vars._object_data_hash = {}
	arg_2_0.vars._request_effects = {}
	arg_2_0.vars._temp_object_data_hash = {}
	arg_2_0.vars.y_gap = LotaWhiteboard:get("tile_y_gap")
	arg_2_0.vars.tile_width = LotaWhiteboard:get("tile_width")
	arg_2_0.vars.tile_height = LotaWhiteboard:get("tile_height")
	arg_2_0.vars.debug_mode = not PRODUCTION_MODE
	arg_2_0.vars.deferred_max_created_count = 150
	arg_2_0.vars.deferred_created_count = 0
	arg_2_0.vars.deferred_create = SceneManager:getCurrentSceneName() == "lota"
	arg_2_0.vars.expire_opacity = 0.5
	arg_2_0.vars.expire_color = cc.c3b(128, 128, 128)
	arg_2_0.vars.icon_mode = DEBUG.LOTA_ICON_MODE
end

function LotaObjectRenderer.doRequestEffects(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_4 = arg_3_4 or 0
	
	local var_3_0 = arg_3_2:getChildByName("render_object")
	
	if not arg_3_1 then
		EffectManager:Play({
			scale = 0.5,
			fn = "hit_new_slash_normal.cfx",
			layer = arg_3_2,
			delay = arg_3_4
		})
		
		if var_3_0 then
		end
	elseif arg_3_1 then
		if arg_3_0.vars._temp_object_data_hash[arg_3_3] then
			UIAction:Add(SEQ(DELAY(300), CALL(EffectManager.Play, EffectManager, {
				fn = "death_eff_01",
				layer = arg_3_2,
				delay = arg_3_4
			}), CALL(function()
				if arg_3_2.ui_info then
					arg_3_2.ui_info:remove()
					
					arg_3_2.ui_info = nil
				end
			end), FADE_OUT(1000), DELAY(500), CALL(LotaObjectRenderer.removeTempRenderObject, LotaObjectRenderer, arg_3_3)), arg_3_2)
			
			if var_3_0 then
			end
		else
			EffectManager:Play({
				fn = "death_eff_01",
				layer = arg_3_2,
				delay = arg_3_4
			})
		end
	end
end

function LotaObjectRenderer._procRequestEffectsOnAdded(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0.vars._request_effects[arg_5_1] then
		local var_5_0 = arg_5_0.vars._request_effects[arg_5_1].state
		
		arg_5_0:doRequestEffects(var_5_0, arg_5_2, arg_5_1, 250)
		
		arg_5_0.vars._request_effects[arg_5_1] = nil
	end
end

function LotaObjectRenderer.procRequestEffects(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1 == nil
	
	arg_6_1 = arg_6_1 or LotaOverSceneDataSystem:get("object_renderer")
	
	if not arg_6_1 or table.empty(arg_6_1) then
		return 
	end
	
	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		local var_6_1 = iter_6_1.is_dead
		local var_6_2 = arg_6_0.vars.object_hash[iter_6_1.tile_id]
		
		if var_6_2 then
			arg_6_0:doRequestEffects(var_6_1, var_6_2, iter_6_1.tile_id)
		elseif iter_6_1.request_create then
			arg_6_0:addTempRenderObject(iter_6_1.db_id, iter_6_1.tile_id, iter_6_1.force_active)
			
			local var_6_3 = arg_6_0.vars.object_hash[iter_6_1.tile_id]
			
			arg_6_0:doRequestEffects(var_6_1, var_6_3, iter_6_1.tile_id)
		else
			arg_6_0.vars._request_effects[iter_6_1.tile_id] = iter_6_1
		end
	end
	
	if var_6_0 then
		LotaOverSceneDataSystem:clear("object_renderer")
	end
end

function LotaObjectRenderer.release(arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.object_hash) do
		if get_cocos_refid(iter_7_1) then
			iter_7_1:removeFromParent()
		end
	end
	
	arg_7_0.vars.object_hash = nil
end

function LotaObjectSystem.close(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.layer) then
		return 
	end
	
	arg_8_0.vars.layer:removeFromParent()
	
	arg_8_0.vars = nil
end

function LotaObjectRenderer.addRenderObjectList(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in pairs(arg_9_1) do
		arg_9_0:addRenderObject(iter_9_1)
	end
end

function LotaObjectRenderer.isRequireIconLoad(arg_10_0)
	return DEBUG.LOTA_ICON_MODE
end

function LotaObjectRenderer.preloadRenderObject(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1:getSpritePath()
	
	if arg_11_1:isModel() and not arg_11_0:isRequireIconLoad() then
		local var_11_1, var_11_2, var_11_3, var_11_4 = DB("character", var_11_0, {
			"model_id",
			"skin",
			"atlas",
			"model_opt"
		})
		local var_11_5, var_11_6 = getModelNameAndAtlasPath(var_11_1, "model", var_11_3)
		
		preload(var_11_5, var_11_6, {
			"idle"
		})
	elseif not arg_11_1:isModel() and LotaUtil:isUsePreload() then
		preload(var_11_0, var_11_0)
	end
end

function LotaObjectRenderer.createRenderObject(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_1:getSpritePath()
	local var_12_1
	
	if arg_12_1:isModel() then
		if not arg_12_0:isRequireIconLoad() then
			local var_12_2, var_12_3, var_12_4, var_12_5 = DB("character", var_12_0, {
				"model_id",
				"skin",
				"atlas",
				"model_opt"
			})
			
			var_12_1 = CACHE:getModel(var_12_2, var_12_3, nil, var_12_4, var_12_5)
			
			local var_12_6 = var_12_1:createShadow()
			
			var_12_6:setGlobalZOrder(0)
			var_12_6:setLocalZOrder(-10)
			arg_12_0:updateMonsterInfoUIScale()
		else
			local var_12_7 = DB("character", var_12_0, "face_id")
			
			var_12_1 = UIUtil:getLightIcon(var_12_7, nil, 0.6)
		end
	else
		local var_12_8 = string.split(var_12_0, ".")
		local var_12_9 = false
		
		if string.starts(var_12_8[1], "tile") then
			var_12_0 = var_12_8[1] .. "." .. var_12_8[2]
			var_12_9 = true
		end
		
		var_12_1 = SpriteCache:getSprite(var_12_0)
		
		if not var_12_1 then
			var_12_1 = SpriteCache:getSprite("img/cm_icon_notification.png")
			
			Log.e("LOTA IS NOT FOUND : " .. var_12_0)
		end
		
		if var_12_9 and var_12_1 then
			var_12_1.req_scale_up = true
		end
	end
	
	var_12_1:setName("render_object")
	var_12_1:setPosition(0, 0)
	var_12_1:setCascadeColorEnabled(true)
	var_12_1:setCascadeOpacityEnabled(true)
	var_12_1:setLocalZOrder(-1)
	
	var_12_1.offset_key = arg_12_1:getOffsetDBKey()
	
	return var_12_1
end

function LotaObjectRenderer.createRenderEffect(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1:isExistEffect() then
		return 
	end
	
	local var_13_0 = arg_13_1:getEffect()
	local var_13_1 = arg_13_1:getEffectScale()
	local var_13_2 = arg_13_1:getEffectLocation()
	local var_13_3
	
	if string.find(var_13_0, ".cfx") then
		var_13_3 = "effect/" .. var_13_0
	else
		var_13_3 = var_13_0
	end
	
	local var_13_4 = EffectManager:Play({
		loop = true,
		fn = var_13_3,
		x = var_13_2.x,
		y = var_13_2.y,
		scale = var_13_1,
		layer = arg_13_2
	})
	
	if not var_13_4 then
		LotaUtil:sendERROR("LOTA OBJECT EFFECT CREATE FAILED!!!!!! " .. var_13_0)
		
		return 
	end
	
	var_13_4.eff_name = var_13_0
	
	var_13_4:setName("effect_node")
	var_13_4:setLocalZOrder(1)
	
	return var_13_4
end

function LotaObjectRenderer.getRenderObjectInHash(arg_14_0, arg_14_1)
end

function LotaObjectRenderer.getObjectSprite(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = cc.Node:create()
	local var_15_1
	
	if not arg_15_0.vars.deferred_create and not arg_15_2 then
		var_15_1 = arg_15_0:createRenderObject(arg_15_1)
	end
	
	local var_15_2 = ""
	
	if arg_15_0.vars.debug_mode then
		local var_15_3 = arg_15_1:getPositionXOffset()
		local var_15_4 = arg_15_1:getPositionYOffset()
		local var_15_5 = arg_15_1:getScaleOffset()
		
		if var_15_3 == nil then
			var_15_2 = var_15_2 .. " X "
		end
		
		if var_15_4 == nil then
			var_15_2 = var_15_2 .. " Y "
		end
		
		if var_15_5 == nil then
			var_15_2 = var_15_2 .. " SCALE "
		end
		
		if #var_15_2 ~= 0 then
			local var_15_6 = "object_icon db MISSING!!! " .. var_15_2 .. " ID : " .. arg_15_1:getOffsetDBKey()
			local var_15_7 = LotaUtil:createDebugLabel(arg_15_1:getOffsetDBKey(), var_15_6, {
				width = 140,
				height = 30
			})
			
			var_15_7:setPositionY(-80)
			var_15_0:addChild(var_15_7)
		end
	end
	
	var_15_0:setCascadeColorEnabled(true)
	var_15_0:setCascadeOpacityEnabled(true)
	var_15_0:setName("object_" .. arg_15_1:getUID())
	
	local var_15_8 = arg_15_0:createRenderEffect(arg_15_1, var_15_0)
	
	if DEBUG.TEST_LOTA_EFFECT and var_15_8 then
		local var_15_9 = arg_15_1:getEffectLocation()
		local var_15_10 = LotaUtil:createDebugLabel(arg_15_1:getOffsetDBKey(), string.format("%s, el: (%d, %d), p_t_id: (%s) ", arg_15_1:getOffsetDBKey(), var_15_9.x, var_15_9.y, arg_15_1:getUID()), {
			width = 140,
			height = 30
		})
		
		var_15_10:setScale(8)
		var_15_8:addChild(var_15_10)
	end
	
	if not (arg_15_1:getTypeDetail() == "overlap") then
		local var_15_11 = arg_15_0:getChildVisibleStatus(arg_15_1, LotaFogSystem:getFogData())
	end
	
	var_15_0:setVisible(false)
	
	if get_cocos_refid(var_15_1) then
		var_15_0:addChild(var_15_1)
	end
	
	var_15_0.object_data = arg_15_1
	
	arg_15_0.vars.object_layer:addChild(var_15_0)
	
	return var_15_0
end

lor = LotaObjectRenderer

function LotaObjectRenderer.fro(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	if PRODUCTION_MODE then
		return 
	end
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.object_hash) do
		local var_16_0 = arg_16_0.vars._object_data_hash[iter_16_0]
		
		var_16_0:debug_updateOffsetDB(arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		arg_16_0:updateObjectSprite(iter_16_1, var_16_0)
	end
end

function LotaObjectRenderer.ueo(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	if PRODUCTION_MODE then
		return 
	end
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.object_hash) do
		local var_17_0 = arg_17_0.vars._object_data_hash[iter_17_0]
		
		var_17_0:debug_updateEffectOffsetDB(arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
		arg_17_0:updateObjectSprite(iter_17_1, var_17_0)
	end
end

function LotaObjectRenderer.getRenderObjectInHash(arg_18_0, arg_18_1)
	return arg_18_0.vars.object_hash[arg_18_1]
end

function LotaObjectRenderer.addRenderObject(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_1:getUID()
	
	if arg_19_0.vars.object_hash[var_19_0] then
		print("WARN. ALREADY EXIST. PLEASE ADD AFTER CHECK")
		
		return 
	end
	
	local var_19_1 = arg_19_0:getObjectSprite(arg_19_1)
	
	arg_19_0.vars.object_hash[var_19_0] = var_19_1
	arg_19_0.vars._object_data_hash[var_19_0] = arg_19_1
	
	arg_19_0:updateObjectSprite(var_19_1, arg_19_1)
	
	if not arg_19_2 then
		arg_19_0:_procRequestEffectsOnAdded(var_19_0, var_19_1)
	end
end

function LotaObjectRenderer.addTempRenderObject(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = LotaObjectData({
		object_id = arg_20_1,
		tile_id = arg_20_2,
		force_active = arg_20_3
	})
	
	arg_20_0:addRenderObject(var_20_0, true)
	
	arg_20_0.vars._temp_object_data_hash[arg_20_2] = true
end

function LotaObjectRenderer.removeTempRenderObject(arg_21_0, arg_21_1)
	arg_21_0:removeRenderObject(arg_21_1)
	
	arg_21_0.vars._temp_object_data_hash[arg_21_1] = nil
end

function LotaObjectRenderer.removeRenderObject(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars or not arg_22_0.vars.object_hash then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.object_hash[arg_22_1]
	
	arg_22_0.vars._object_data_hash[arg_22_1] = nil
	
	if not get_cocos_refid(var_22_0) then
		Log.e("WARN WARN WARN SPRITE NOT EXIST")
		
		return 
	end
	
	if arg_22_2 then
		UIAction:Add(SEQ(CALL(function()
			if var_22_0.ui_info then
				var_22_0.ui_info:remove()
				
				var_22_0.ui_info = nil
			end
		end), CALL(EffectManager.Play, EffectManager, {
			delay = 0,
			fn = "death_eff_01",
			layer = var_22_0
		}), FADE_OUT(1000), REMOVE()), var_22_0)
		
		local var_22_1 = var_22_0:findChildByName("render_object")
		
		if var_22_1 then
			UIAction:Add(SEQ(MOTION("groggy", true), COLOR(0, 30, 30, 30)), var_22_1)
		end
	else
		if var_22_0.ui_info then
			var_22_0.ui_info:remove()
			
			var_22_0.ui_info = nil
		end
		
		var_22_0:removeFromParent()
	end
	
	arg_22_0.vars.object_hash[arg_22_1] = nil
end

function LotaObjectRenderer.getObjectPosition(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.tile_width
	local var_24_1 = arg_24_0.vars.tile_height
	local var_24_2 = arg_24_0.vars.y_gap
	local var_24_3 = arg_24_1.x * (var_24_0 / 2)
	local var_24_4 = arg_24_1.y * (var_24_1 / 2) - var_24_2
	
	return {
		x = var_24_3,
		y = var_24_4
	}
end

function LotaObjectRenderer.getResultColor(arg_25_0, arg_25_1)
	local var_25_0 = LotaWhiteboard:get("ambient_color")
	
	if arg_25_1 then
		return var_25_0
	end
	
	return cc.c3b(var_25_0.r * (arg_25_0.vars.expire_color.r / 255), var_25_0.g * (arg_25_0.vars.expire_color.g / 255), var_25_0.b * (arg_25_0.vars.expire_color.b / 255))
end

function LotaObjectRenderer.updateObjectSprite(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = LotaTileMapSystem:getPosById(arg_26_2:getTileId())
	local var_26_1 = arg_26_0.vars.tile_width
	local var_26_2 = arg_26_0.vars.tile_height
	local var_26_3 = arg_26_0.vars.y_gap
	local var_26_4 = arg_26_2:getPositionXOffset()
	local var_26_5 = arg_26_2:getPositionYOffset()
	local var_26_6 = arg_26_2:getScaleOffset()
	local var_26_7 = arg_26_2:isReflect()
	
	var_26_4 = var_26_4 or 0
	var_26_5 = var_26_5 or 0
	var_26_6 = var_26_6 or 1
	
	local var_26_8 = arg_26_1:findChildByName("render_object")
	
	if var_26_8 and var_26_8.offset_key ~= arg_26_2:getOffsetDBKey() then
		var_26_8:removeFromParent()
		
		var_26_8 = arg_26_0:createRenderObject(arg_26_2)
		
		arg_26_1:addChild(var_26_8)
	end
	
	local var_26_9 = arg_26_1:getContentSize()
	
	if get_cocos_refid(var_26_8) then
		if var_26_8.req_scale_up then
			var_26_8:setScale(var_26_6 * 4)
		end
		
		if var_26_8.req_scale_up then
			local var_26_10 = var_26_8:getContentSize()
			
			var_26_8:setPosition(var_26_4, -(var_26_10.height * 4 / 2) + var_26_5)
		else
			local var_26_11 = var_26_8:getContentSize()
			
			var_26_8:setPosition(var_26_4, -(var_26_11.height / 2) + var_26_5)
		end
	end
	
	local var_26_12 = arg_26_1:findChildByName("effect_node")
	local var_26_13 = arg_26_2:getEffect()
	
	if get_cocos_refid(var_26_12) and var_26_12.eff_name ~= var_26_13 then
		var_26_12:removeFromParent()
		
		var_26_12 = arg_26_0:createRenderEffect(arg_26_2, arg_26_1)
	elseif not get_cocos_refid(var_26_12) and var_26_13 ~= nil then
		var_26_12 = arg_26_0:createRenderEffect(arg_26_2, arg_26_1)
	end
	
	if get_cocos_refid(var_26_12) then
		local var_26_14 = arg_26_2:getEffectScale()
		local var_26_15 = arg_26_2:getEffectLocation()
		
		var_26_12:setScale(var_26_14)
		
		if var_26_7 == "y" then
			var_26_12:setScaleX(var_26_14 * -1)
			
			var_26_15.x = var_26_15.x * -1
		end
		
		var_26_12:setPosition(var_26_15.x, var_26_15.y)
	end
	
	local var_26_16 = var_26_0.x * (var_26_1 / 2)
	local var_26_17 = var_26_0.y * (var_26_2 / 2) - var_26_3
	
	arg_26_1:setPosition(var_26_16, var_26_17)
	
	if arg_26_2:isMonsterType() and arg_26_2:isActive() and var_26_8 then
		local var_26_18 = arg_26_2:getHPBarPositionXOffset()
		local var_26_19 = arg_26_2:getHPBarPositionYOffset()
		
		if not arg_26_1.ui_info then
			arg_26_1.ui_info = LotaUIMonsterInfo(arg_26_1, arg_26_2:getDBId(), arg_26_2:getTileId(), var_26_18, var_26_19)
		end
		
		arg_26_1.ui_info:updateScale(var_26_6)
		
		if var_26_8 and var_26_8.getBonePosition then
			local var_26_20, var_26_21 = var_26_8:getBonePosition("top")
			
			arg_26_1.ui_info:setBonePositionY(var_26_21, var_26_5)
		end
	elseif arg_26_2:isClanObject() and arg_26_2:isUsedClanObject() and var_26_8 then
		if not arg_26_1.ui_info then
			local var_26_22 = SpriteCache:getSprite("img/cm_icon_clear_check.png")
			
			var_26_22:setName("used_sprite")
			
			local var_26_23, var_26_24 = arg_26_1:getPosition()
			local var_26_25, var_26_26 = var_26_8:getPosition()
			
			var_26_22:setPositionX(var_26_23 + var_26_25)
			var_26_22:setPositionY(var_26_26 + var_26_24)
			LotaSystem:addToMonsterFieldUI(var_26_22)
			
			arg_26_1.ui_info = var_26_22
			arg_26_1.ui_info.org_scale = 1
			
			function arg_26_1.ui_info.updateUIScale(arg_27_0)
				local var_27_0 = LotaCameraSystem:getScale() or 1
				
				arg_27_0:setScale(arg_27_0.org_scale / var_27_0)
			end
			
			function arg_26_1.ui_info.remove(arg_28_0)
				arg_28_0:removeFromParent()
			end
			
			arg_26_1.ui_info:updateUIScale()
		end
	elseif arg_26_1.ui_info then
		arg_26_1.ui_info:remove()
		
		arg_26_1.ui_info = nil
	end
	
	if var_26_8 and not var_26_8.req_scale_up then
		var_26_8:setScale(var_26_6)
	end
	
	arg_26_1:setLocalZOrder(var_26_0.y * -5 + 0)
	
	if var_26_7 == "y" and var_26_8 then
		local var_26_27 = var_26_8:getScaleX()
		
		var_26_8:setScaleX(var_26_27 * -1)
	end
	
	if LotaFogSystem.vars then
		arg_26_0:setRenderObjectFogColor(arg_26_1, LotaFogSystem:getFogVisibility(var_26_0.x, var_26_0.y))
	end
end

function LotaObjectRenderer.onUpdate(arg_29_0)
	if arg_29_0.vars.req_monster_info_scale_update then
		for iter_29_0, iter_29_1 in pairs(arg_29_0.vars.object_hash) do
			if iter_29_1.ui_info then
				iter_29_1.ui_info:updateUIScale()
			end
		end
		
		arg_29_0.vars.req_monster_info_scale_update = nil
	end
end

function LotaObjectRenderer.updateMonsterInfoUIScale(arg_30_0)
	arg_30_0.vars.req_monster_info_scale_update = true
end

function LotaObjectRenderer.getChildVisibleStatus(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_2:getFogDataByIdx(tonumber(arg_31_1:getUID()))
	local var_31_1 = LotaFogVisibilityEnum.NOT_DISCOVER
	
	if var_31_0 then
		var_31_1 = var_31_0:getVisibility()
	end
	
	local var_31_2 = arg_31_1:getType()
	local var_31_3 = arg_31_1:getTypeDetail()
	local var_31_4 = LotaUtil:isDiscoverAllowType(var_31_2, var_31_3)
	local var_31_5
	
	if var_31_1 == LotaFogVisibilityEnum.VISIBLE or var_31_1 == LotaFogVisibilityEnum.DISCOVER and var_31_4 then
		var_31_5 = true
		
		return var_31_5
	end
	
	local var_31_6 = arg_31_1:getChildTileList()
	
	if var_31_6 then
		for iter_31_0, iter_31_1 in pairs(var_31_6) do
			local var_31_7 = arg_31_2:getFogDataByIdx(tonumber(iter_31_1))
			
			if var_31_7 then
				local var_31_8 = var_31_7:getVisibility()
				
				if var_31_8 == LotaFogVisibilityEnum.VISIBLE or var_31_8 == LotaFogVisibilityEnum.DISCOVER and var_31_4 then
					var_31_5 = true
					
					break
				end
			end
		end
	end
	
	return var_31_5
end

function LotaObjectRenderer.setNodeChildVisible(arg_32_0, arg_32_1, arg_32_2)
	if not get_cocos_refid(arg_32_1) then
		return 
	end
	
	if_set_visible(arg_32_1, "effect_node", arg_32_2)
	if_set_visible(arg_32_1, "render_object", arg_32_2)
end

function LotaObjectRenderer.setRenderObjectFogColor(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_1:findChildByName("render_object")
	
	if not var_33_0 then
		return 
	end
	
	local var_33_1 = 1
	
	if arg_33_2 == LotaFogVisibilityEnum.DISCOVER then
		var_33_1 = 0.7352941176470589
	elseif arg_33_2 == LotaFogVisibilityEnum.NOT_DISCOVER then
		var_33_1 = 0.5
	end
	
	local var_33_2 = LotaWhiteboard:get("ambient_color")
	local var_33_3 = cc.c3b(var_33_2.r * var_33_1, var_33_2.g * var_33_1, var_33_2.b * var_33_1)
	
	var_33_0:setColor(var_33_3)
end

function LotaObjectRenderer.updateColorByFog(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = LotaTileMapSystem:getTileByPos({
		x = arg_34_1,
		y = arg_34_2
	})
	
	if not var_34_0 then
		return 
	end
	
	local var_34_1 = var_34_0:getObjectId()
	local var_34_2 = arg_34_0.vars.object_hash[var_34_1]
	
	if not var_34_2 then
		return 
	end
	
	arg_34_0:setRenderObjectFogColor(var_34_2, arg_34_3)
end

function LotaObjectRenderer.addEffect(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.vars.object_hash[arg_35_1]
	
	if not var_35_0 then
		return 
	end
	
	arg_35_2 = arg_35_2 or {}
	
	if not arg_35_2.fn then
		arg_35_2.fn = "ui_pet_act_eff.cfx"
	end
	
	arg_35_2.layer = var_35_0
	
	EffectManager:Play(arg_35_2)
end

function LotaObjectRenderer.requestExpire(arg_36_0, arg_36_1)
	do return  end
	
	local var_36_0 = arg_36_0.vars.object_hash[arg_36_1]
	local var_36_1 = arg_36_0:getResultColor(false)
	
	EffectManager:Play({
		fn = "ui_pet_act_eff.cfx",
		layer = var_36_0
	})
	UIAction:Add(SPAWN(DELAY(300), CALL(function()
		local var_37_0 = var_36_0:findChildByName("render_object")
		
		if get_cocos_refid(var_37_0) then
			var_37_0:removeFromParent()
		end
		
		local var_37_1 = LotaObjectSystem:getObject(arg_36_1)
		local var_37_2 = arg_36_0:createRenderObject(var_37_1)
		
		var_36_0:addChild(var_37_2)
		arg_36_0:updateObjectSprite(var_36_0, var_37_1)
	end)), var_36_0)
end

function LotaObjectRenderer.updateObject(arg_38_0, arg_38_1)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.object_layer) then
		return 
	end
	
	if not arg_38_1 then
		return 
	end
	
	local var_38_0 = LotaObjectSystem:getObject(arg_38_1)
	
	if not var_38_0 then
		return 
	end
	
	local var_38_1 = arg_38_0.vars.object_hash[arg_38_1]
	
	arg_38_0:updateObjectSprite(var_38_1, var_38_0)
end

function LotaObjectRenderer.findObject(arg_39_0, arg_39_1)
	return arg_39_0.vars.object_hash[arg_39_1] ~= nil
end

function LotaObjectRenderer.isExistRenderObject(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.vars.object_hash[arg_40_1]
	
	if not var_40_0 then
		return 
	end
	
	return var_40_0:findChildByName("render_object") ~= nil
end

function LotaObjectRenderer.getFocusYPosition(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.vars.object_hash[arg_41_1]
	
	if not var_41_0 then
		return 
	end
	
	local var_41_1 = var_41_0.object_data
	local var_41_2 = var_41_0:findChildByName("render_object")
	
	if not var_41_2 then
		print("[ERROR] THIS FUNCTION MUST BE EXIST RENDER OBJECT, BUT NOT EXIST. deferred_create?", arg_41_0.vars.deferred_create)
		
		return 
	end
	
	local var_41_3 = var_41_1:getAdjustFocusYPos()
	
	if var_41_2.getBonePosition then
		local var_41_4, var_41_5 = var_41_2:getBonePosition("top")
		
		return var_41_5 / 2 + var_41_0:getPositionY() + var_41_3
	end
	
	return var_41_2:getContentSize().height * var_41_2:getAnchorPoint().y * var_41_2:getScaleY() + var_41_0:getPositionY() + var_41_3
end

function LotaObjectRenderer.updateObjectUI(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.vars.object_hash[arg_42_1]
	
	if not var_42_0 then
		return 
	end
	
	if var_42_0.ui_info then
		var_42_0.ui_info:updateUI()
	end
end

function LotaObjectRenderer.setVisibleInfo(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0.vars.object_hash[arg_43_1]
	
	if not var_43_0 then
		return 
	end
	
	if var_43_0.ui_info then
		var_43_0.ui_info:setVisible(arg_43_2)
	end
end

function LotaObjectRenderer.visibleOff(arg_44_0)
	for iter_44_0, iter_44_1 in pairs(arg_44_0.vars.object_hash) do
		iter_44_1:setVisible(false)
	end
end

function LotaObjectRenderer.requirePreload(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0.vars.object_hash[arg_45_1]
	
	if not var_45_0 then
		return 
	end
	
	if LOW_RESOLUTION_MODE then
		return 
	end
	
	if not var_45_0:findChildByName("render_object") then
		arg_45_0:preloadRenderObject(var_45_0.object_data)
	end
end

function LotaObjectRenderer.setVisibleObject(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_0.vars.object_hash[arg_46_1]
	
	if not var_46_0 then
		return 
	end
	
	if var_46_0 then
		var_46_0:setVisible(arg_46_2)
		
		if arg_46_2 then
			var_46_0.last_visible_tm = uitick()
		end
		
		if arg_46_0.vars.deferred_create and arg_46_2 and not var_46_0:findChildByName("render_object") then
			local var_46_1 = var_46_0.object_data:isModel()
			local var_46_2 = false
			local var_46_3
			
			if var_46_1 and arg_46_0.vars.deferred_created_count >= arg_46_0.vars.deferred_max_created_count then
				var_46_2 = true
				var_46_3 = arg_46_0:createRenderObject(var_46_0.object_data, true)
				var_46_3.on_limit_create = true
			else
				var_46_3 = arg_46_0:createRenderObject(var_46_0.object_data)
			end
			
			if get_cocos_refid(var_46_3) then
				var_46_0:addChild(var_46_3)
				arg_46_0:updateObjectSprite(var_46_0, var_46_0.object_data)
				
				if var_46_1 and not var_46_2 then
					arg_46_0.vars.deferred_created_count = arg_46_0.vars.deferred_created_count + 1
				end
			end
		end
	end
end

function LotaObjectRenderer.considerExpirePerSprite(arg_47_0, arg_47_1)
	if arg_47_1 then
		local var_47_0 = arg_47_1:findChildByName("render_object")
		
		if var_47_0 then
			local var_47_1 = var_47_0.on_limit_create
			
			var_47_0:removeFromParent()
			
			if arg_47_1.object_data:isModel() and not var_47_1 then
				arg_47_0.vars.deferred_created_count = arg_47_0.vars.deferred_created_count - 1
			end
			
			if LOW_RESOLUTION_MODE and arg_47_1.ui_info then
				if arg_47_1.ui_info.remove then
					arg_47_1.ui_info:remove()
				end
				
				arg_47_1.ui_info = nil
			end
			
			arg_47_1.last_visible_tm = nil
			
			return true
		end
	end
	
	return false
end

function LotaObjectRenderer.considerExpire(arg_48_0, arg_48_1)
	local var_48_0 = uitick()
	local var_48_1 = 0
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.object_hash) do
		if iter_48_1.last_visible_tm and var_48_0 - iter_48_1.last_visible_tm > 500 and arg_48_0:considerExpirePerSprite(iter_48_1) then
			var_48_1 = var_48_1 + 1
		end
	end
	
	return arg_48_0.vars.deferred_created_count, var_48_1
end

function LotaObjectRenderer.getObjectList(arg_49_0)
	if not arg_49_0.vars then
		return 
	end
	
	return arg_49_0.vars.object_hash
end
