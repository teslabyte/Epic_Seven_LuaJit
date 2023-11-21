HTBObjectRenderer = {}

local function var_0_0(arg_1_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_1_0 = {}
	
	for iter_1_0 = 1, 9999 do
		local var_1_1, var_1_2 = DBN(arg_1_0, iter_1_0, {
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

function HTBObjectRenderer.base_init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	var_0_0(arg_2_3)
	
	arg_2_0.vars = {}
	arg_2_0.vars.object_layer = arg_2_4
	arg_2_0.vars.object_hash = {}
	arg_2_0.vars._object_data_hash = {}
	arg_2_0.vars._request_effects = {}
	arg_2_0.vars._temp_object_data_hash = {}
	arg_2_0.vars.y_gap = HTBInterface:whiteboardGet(arg_2_1, "tile_y_gap")
	arg_2_0.vars.tile_width = HTBInterface:whiteboardGet(arg_2_1, "tile_width")
	arg_2_0.vars.tile_height = HTBInterface:whiteboardGet(arg_2_1, "tile_height")
	arg_2_0.vars.debug_mode = not PRODUCTION_MODE
	arg_2_0.vars.deferred_max_created_count = 150
	arg_2_0.vars.deferred_created_count = 0
	arg_2_0.vars.deferred_create = arg_2_2
	arg_2_0.vars.expire_opacity = 0.5
	arg_2_0.vars.expire_color = cc.c3b(128, 128, 128)
	arg_2_0.vars.icon_mode = DEBUG.LOTA_ICON_MODE
end

function HTBObjectRenderer.doRequestEffects(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
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
				arg_3_0:removeObjectUI(arg_3_3)
			end), FADE_OUT(1000), DELAY(500), CALL(HTBObjectRenderer.removeTempRenderObject, HTBObjectRenderer, arg_3_3)), arg_3_2)
			
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

function HTBObjectRenderer._procRequestEffectsOnAdded(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0.vars._request_effects[arg_5_1] then
		local var_5_0 = arg_5_0.vars._request_effects[arg_5_1].state
		
		arg_5_0:doRequestEffects(var_5_0, arg_5_2, arg_5_1, 250)
		
		arg_5_0.vars._request_effects[arg_5_1] = nil
	end
end

function HTBObjectRenderer.procRequestEffects(arg_6_0, arg_6_1)
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

function HTBObjectRenderer.release(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	if arg_7_0.vars.object_hash then
		for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.object_hash) do
			if get_cocos_refid(iter_7_1) then
				iter_7_1:removeFromParent()
			end
		end
		
		arg_7_0.vars.object_hash = nil
	end
end

function HTBObjectRenderer.addRenderObjectList(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		arg_8_0:addRenderObject(iter_8_1)
	end
end

function HTBObjectRenderer.isRequireIconLoad(arg_9_0)
	return DEBUG.LOTA_ICON_MODE
end

function HTBObjectRenderer.preloadRenderObject(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1:getSpritePath()
	
	if arg_10_1:isModel() and not arg_10_0:isRequireIconLoad() then
		local var_10_1, var_10_2, var_10_3, var_10_4 = DB("character", var_10_0, {
			"model_id",
			"skin",
			"atlas",
			"model_opt"
		})
		local var_10_5, var_10_6 = getModelNameAndAtlasPath(var_10_1, "model", var_10_3)
		
		preload(var_10_5, var_10_6, {
			"idle"
		})
	elseif not arg_10_1:isModel() and LotaUtil:isUsePreload() then
		preload(var_10_0, var_10_0)
	end
end

function HTBObjectRenderer.createRenderObject(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_1:getSpritePath()
	
	if not var_11_0 then
		return 
	end
	
	local var_11_1
	
	if arg_11_1:isModel() then
		if not arg_11_0:isRequireIconLoad() then
			local var_11_2, var_11_3, var_11_4, var_11_5 = DB("character", var_11_0, {
				"model_id",
				"skin",
				"atlas",
				"model_opt"
			})
			
			var_11_1 = CACHE:getModel(var_11_2, var_11_3, nil, var_11_4, var_11_5)
			
			local var_11_6 = var_11_1:createShadow()
			
			var_11_6:setGlobalZOrder(0)
			var_11_6:setLocalZOrder(-10)
			arg_11_0:updateMonsterInfoUIScale()
		else
			local var_11_7 = DB("character", var_11_0, "face_id")
			
			var_11_1 = UIUtil:getLightIcon(var_11_7, nil, 0.6)
		end
	else
		local var_11_8 = string.split(var_11_0, ".")
		local var_11_9 = false
		
		if string.starts(var_11_8[1], "tile") then
			var_11_0 = var_11_8[1] .. "." .. var_11_8[2]
			var_11_9 = true
		end
		
		var_11_1 = SpriteCache:getSprite(var_11_0)
		
		if not var_11_1 then
			var_11_1 = SpriteCache:getSprite("img/cm_icon_notification.png")
			
			Log.e("LOTA IS NOT FOUND : " .. var_11_0)
		end
		
		if var_11_9 and var_11_1 then
			var_11_1.req_scale_up = true
		end
	end
	
	var_11_1:setName("render_object")
	var_11_1:setPosition(0, 0)
	var_11_1:setCascadeColorEnabled(true)
	var_11_1:setCascadeOpacityEnabled(true)
	var_11_1:setLocalZOrder(-1)
	
	var_11_1.offset_key = arg_11_1:getOffsetDBKey()
	
	return var_11_1
end

function HTBObjectRenderer.createRenderEffect(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1:isExistEffect() then
		return 
	end
	
	local var_12_0 = arg_12_1:getEffect()
	local var_12_1 = arg_12_1:getEffectScale()
	local var_12_2 = arg_12_1:getEffectLocation()
	local var_12_3
	
	if string.find(var_12_0, ".cfx") then
		var_12_3 = "effect/" .. var_12_0
	else
		var_12_3 = var_12_0
	end
	
	local var_12_4 = EffectManager:Play({
		loop = true,
		fn = var_12_3,
		x = var_12_2.x,
		y = var_12_2.y,
		scale = var_12_1,
		layer = arg_12_2
	})
	
	if not var_12_4 then
		LotaUtil:sendERROR("LOTA OBJECT EFFECT CREATE FAILED!!!!!! " .. var_12_0)
		
		return 
	end
	
	var_12_4.eff_name = var_12_0
	
	var_12_4:setName("effect_node")
	var_12_4:setLocalZOrder(1)
	
	return var_12_4
end

function HTBObjectRenderer.getObjectSprite(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = cc.Node:create()
	local var_13_1
	
	if not arg_13_0.vars.deferred_create and not arg_13_2 then
		var_13_1 = arg_13_0:createRenderObject(arg_13_1)
	end
	
	local var_13_2 = ""
	
	if arg_13_0.vars.debug_mode then
		local var_13_3 = arg_13_1:getPositionXOffset()
		local var_13_4 = arg_13_1:getPositionYOffset()
		local var_13_5 = arg_13_1:getScaleOffset()
		
		if var_13_3 == nil then
			var_13_2 = var_13_2 .. " X "
		end
		
		if var_13_4 == nil then
			var_13_2 = var_13_2 .. " Y "
		end
		
		if var_13_5 == nil then
			var_13_2 = var_13_2 .. " SCALE "
		end
		
		if #var_13_2 ~= 0 then
			print("MISSING!!!")
			
			local var_13_6 = "object_icon db MISSING!!! " .. var_13_2 .. " ID : " .. arg_13_1:getOffsetDBKey()
			local var_13_7 = HTUtil:createDebugLabel(arg_13_1:getOffsetDBKey(), var_13_6, {
				width = 140,
				height = 30
			})
			
			var_13_7:setPositionY(-80)
			var_13_0:addChild(var_13_7)
		end
	end
	
	var_13_0:setCascadeColorEnabled(true)
	var_13_0:setCascadeOpacityEnabled(true)
	var_13_0:setName("object_" .. arg_13_1:getUID())
	
	local var_13_8 = arg_13_0:createRenderEffect(arg_13_1, var_13_0)
	
	if DEBUG.TEST_LOTA_EFFECT and var_13_8 then
		local var_13_9 = arg_13_1:getEffectLocation()
		local var_13_10 = HTUtil:createDebugLabel(arg_13_1:getOffsetDBKey(), string.format("%s, el: (%d, %d), p_t_id: (%s) ", arg_13_1:getOffsetDBKey(), var_13_9.x, var_13_9.y, arg_13_1:getUID()), {
			width = 140,
			height = 30
		})
		
		var_13_10:setScale(8)
		var_13_8:addChild(var_13_10)
	end
	
	if not (arg_13_1:getTypeDetail() == "overlap") then
	end
	
	if arg_13_0.vars.deferred_create then
		var_13_0:setVisible(false)
	end
	
	if get_cocos_refid(var_13_1) then
		var_13_0:addChild(var_13_1)
	end
	
	var_13_0.object_data = arg_13_1
	
	arg_13_0.vars.object_layer:addChild(var_13_0)
	
	return var_13_0
end

lor = HTBObjectRenderer

function HTBObjectRenderer.fro(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if PRODUCTION_MODE then
		return 
	end
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.object_hash) do
		local var_14_0 = arg_14_0.vars._object_data_hash[iter_14_0]
		
		var_14_0:debug_updateOffsetDB(arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		arg_14_0:updateObjectSprite(iter_14_1, var_14_0)
	end
end

function HTBObjectRenderer.ueo(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	if PRODUCTION_MODE then
		return 
	end
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.object_hash) do
		local var_15_0 = arg_15_0.vars._object_data_hash[iter_15_0]
		
		var_15_0:debug_updateEffectOffsetDB(arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
		arg_15_0:updateObjectSprite(iter_15_1, var_15_0)
	end
end

function HTBObjectRenderer.getRenderObjectInHash(arg_16_0, arg_16_1)
	return arg_16_0.vars.object_hash[arg_16_1]
end

function HTBObjectRenderer.addRenderObject(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_1:getUID()
	
	if arg_17_0.vars.object_hash[var_17_0] then
		print("WARN. ALREADY EXIST. PLEASE ADD AFTER CHECK")
		
		return 
	end
	
	local var_17_1 = arg_17_0:getObjectSprite(arg_17_1)
	
	arg_17_0.vars.object_hash[var_17_0] = var_17_1
	arg_17_0.vars._object_data_hash[var_17_0] = arg_17_1
	
	arg_17_0:updateObjectSprite(var_17_1, arg_17_1)
	
	if not arg_17_2 then
		arg_17_0:_procRequestEffectsOnAdded(var_17_0, var_17_1)
	end
end

function HTBObjectRenderer.base_addTempRenderObject(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = {
		object_id = arg_18_2,
		tile_id = arg_18_3,
		force_active = arg_18_4
	}
	local var_18_1 = HTBInterface:createObjectData(arg_18_1, var_18_0)
	
	arg_18_0:addRenderObject(var_18_1, true)
	
	arg_18_0.vars._temp_object_data_hash[arg_18_3] = true
end

function HTBObjectRenderer.removeTempRenderObject(arg_19_0, arg_19_1)
	arg_19_0:removeRenderObject(arg_19_1)
	
	arg_19_0.vars._temp_object_data_hash[arg_19_1] = nil
end

function HTBObjectRenderer.removeRenderObject(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0.vars or not arg_20_0.vars.object_hash then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.object_hash[arg_20_1]
	
	arg_20_0.vars._object_data_hash[arg_20_1] = nil
	
	if not get_cocos_refid(var_20_0) then
		Log.e("WARN WARN WARN SPRITE NOT EXIST")
		
		return 
	end
	
	if arg_20_2 then
		UIAction:Add(SEQ(CALL(function()
			arg_20_0:removeObjectUI(arg_20_1)
		end), CALL(EffectManager.Play, EffectManager, {
			delay = 0,
			fn = "death_eff_01",
			layer = var_20_0
		}), FADE_OUT(1000), REMOVE()), var_20_0)
		
		local var_20_1 = var_20_0:findChildByName("render_object")
		
		if var_20_1 then
			UIAction:Add(SEQ(MOTION("groggy", true), COLOR(0, 30, 30, 30)), var_20_1)
		end
	else
		arg_20_0:removeObjectUI(arg_20_1)
		var_20_0:removeFromParent()
	end
	
	arg_20_0.vars.object_hash[arg_20_1] = nil
end

function HTBObjectRenderer.getObjectPosition(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.tile_width
	local var_22_1 = arg_22_0.vars.tile_height
	local var_22_2 = arg_22_0.vars.y_gap
	local var_22_3 = arg_22_1.x * (var_22_0 / 2)
	local var_22_4 = arg_22_1.y * (var_22_1 / 2) - var_22_2
	
	return {
		x = var_22_3,
		y = var_22_4
	}
end

function HTBObjectRenderer.base_updateObjectSprite(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = HTBInterface:getPosById(arg_23_1, arg_23_3:getTileId())
	local var_23_1 = arg_23_0.vars.tile_width
	local var_23_2 = arg_23_0.vars.tile_height
	local var_23_3 = arg_23_0.vars.y_gap
	local var_23_4 = arg_23_3:getPositionXOffset()
	local var_23_5 = arg_23_3:getPositionYOffset()
	local var_23_6 = arg_23_3:getScaleOffset()
	local var_23_7 = arg_23_3:isReflect()
	
	var_23_4 = var_23_4 or 0
	var_23_5 = var_23_5 or 0
	var_23_6 = var_23_6 or 1
	
	local var_23_8 = arg_23_2:findChildByName("render_object")
	
	if var_23_8 and var_23_8.offset_key ~= arg_23_3:getOffsetDBKey() then
		var_23_8:removeFromParent()
		
		var_23_8 = arg_23_0:createRenderObject(arg_23_3)
		
		arg_23_2:addChild(var_23_8)
	end
	
	local var_23_9 = arg_23_2:getContentSize()
	
	if get_cocos_refid(var_23_8) then
		if var_23_8.req_scale_up then
			var_23_8:setScale(var_23_6 * 4)
		end
		
		if var_23_8.req_scale_up then
			local var_23_10 = var_23_8:getContentSize()
			
			var_23_8:setPosition(var_23_4, -(var_23_10.height * 4 / 2) + var_23_5)
		else
			local var_23_11 = var_23_8:getContentSize()
			
			var_23_8:setPosition(var_23_4, -(var_23_11.height / 2) + var_23_5)
		end
	end
	
	local var_23_12 = arg_23_2:findChildByName("effect_node")
	local var_23_13 = arg_23_3:getEffect()
	
	if get_cocos_refid(var_23_12) and var_23_12.eff_name ~= var_23_13 then
		var_23_12:removeFromParent()
		
		var_23_12 = arg_23_0:createRenderEffect(arg_23_3, arg_23_2)
	elseif not get_cocos_refid(var_23_12) and var_23_13 ~= nil then
		var_23_12 = arg_23_0:createRenderEffect(arg_23_3, arg_23_2)
	end
	
	if get_cocos_refid(var_23_12) then
		local var_23_14 = arg_23_3:getEffectScale()
		local var_23_15 = arg_23_3:getEffectLocation()
		
		var_23_12:setScale(var_23_14)
		
		if var_23_7 == "y" then
			var_23_12:setScaleX(var_23_14 * -1)
			
			var_23_15.x = var_23_15.x * -1
		end
		
		var_23_12:setPosition(var_23_15.x, var_23_15.y)
	end
	
	local var_23_16 = var_23_0.x * (var_23_1 / 2)
	local var_23_17 = var_23_0.y * (var_23_2 / 2) - var_23_3
	
	arg_23_2:setPosition(var_23_16, var_23_17)
	
	if arg_23_3:isMonsterType() and arg_23_3:isActive() and var_23_8 then
		local var_23_18 = arg_23_3:getHPBarPositionXOffset()
		local var_23_19 = arg_23_3:getHPBarPositionYOffset()
		
		if not arg_23_2.ui_info then
		end
		
		if arg_23_2.ui_info then
			arg_23_2.ui_info:updateScale(var_23_6)
			
			if var_23_8 and var_23_8.getBonePosition then
				local var_23_20, var_23_21 = var_23_8:getBonePosition("top")
				
				arg_23_2.ui_info:setBonePositionY(var_23_21, var_23_5)
			end
		end
	elseif arg_23_3:isClanObject() and arg_23_3:isUsedClanObject() and var_23_8 and (arg_23_2.ui_info or true) then
	else
		arg_23_0:removeObjectUI(arg_23_3:getTileId())
	end
	
	if var_23_8 and not var_23_8.req_scale_up then
		var_23_8:setScale(var_23_6)
	end
	
	arg_23_2:setLocalZOrder(var_23_0.y * -5 + 0)
	
	if var_23_7 == "y" and var_23_8 then
		local var_23_22 = var_23_8:getScaleX()
		
		var_23_8:setScaleX(var_23_22 * -1)
	end
end

function HTBObjectRenderer.base_requestExpire(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0.vars.object_hash[arg_24_2]
	
	EffectManager:Play({
		fn = "ui_pet_act_eff.cfx",
		layer = var_24_0
	})
	UIAction:Add(SPAWN(DELAY(300), CALL(function()
		local var_25_0 = var_24_0:findChildByName("render_object")
		
		if get_cocos_refid(var_25_0) then
			var_25_0:removeFromParent()
		end
		
		local var_25_1 = HTBInterface:getObject(arg_24_1, arg_24_2)
		local var_25_2 = arg_24_0:createRenderObject(var_25_1)
		
		var_24_0:addChild(var_25_2)
		arg_24_0:updateObjectSprite(var_24_0, var_25_1)
	end)), var_24_0)
end

function HTBObjectRenderer.base_updateColorByFog(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	local var_26_0 = HTBInterface:getTileByPos(arg_26_1, {
		x = arg_26_2,
		y = arg_26_3
	})
	
	if not var_26_0 then
		return 
	end
	
	local var_26_1 = var_26_0:getObjectId()
	local var_26_2 = arg_26_0.vars.object_hash[var_26_1]
	
	if not var_26_2 then
		return 
	end
	
	arg_26_0:setRenderObjectFogColor(var_26_2, arg_26_4)
end

function HTBObjectRenderer.base_setRenderObjectFogColor(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	local var_27_0 = arg_27_2:findChildByName("render_object")
	
	if not var_27_0 then
		return 
	end
	
	local var_27_1 = 1
	
	if arg_27_3 == LotaFogVisibilityEnum.DISCOVER then
		var_27_1 = 0.7352941176470589
	elseif arg_27_3 == LotaFogVisibilityEnum.NOT_DISCOVER then
		var_27_1 = 0.5
	end
	
	local var_27_2 = HTBInterface:whiteboardGet(arg_27_1, "ambient_color")
	
	if not var_27_2 then
		return 
	end
	
	local var_27_3 = cc.c3b(var_27_2.r * var_27_1, var_27_2.g * var_27_1, var_27_2.b * var_27_1)
	
	var_27_0:setColor(var_27_3)
end

function HTBObjectRenderer.onUpdate(arg_28_0)
	if arg_28_0.vars.req_monster_info_scale_update then
		for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.object_hash) do
			if iter_28_1.ui_info then
				iter_28_1.ui_info:updateUIScale()
			end
		end
		
		arg_28_0.vars.req_monster_info_scale_update = nil
	end
end

function HTBObjectRenderer.updateMonsterInfoUIScale(arg_29_0)
	arg_29_0.vars.req_monster_info_scale_update = true
end

function HTBObjectRenderer.getChildVisibleStatus(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_2:getFogDataByIdx(tonumber(arg_30_1:getUID()))
	local var_30_1 = LotaFogVisibilityEnum.NOT_DISCOVER
	
	if var_30_0 then
		var_30_1 = var_30_0:getVisibility()
	end
	
	local var_30_2 = arg_30_1:getType()
	local var_30_3 = arg_30_1:getTypeDetail()
	local var_30_4 = LotaUtil:isDiscoverAllowType(var_30_2, var_30_3)
	local var_30_5
	
	if var_30_1 == LotaFogVisibilityEnum.VISIBLE or var_30_1 == LotaFogVisibilityEnum.DISCOVER and var_30_4 then
		var_30_5 = true
		
		return var_30_5
	end
	
	local var_30_6 = arg_30_1:getChildTileList()
	
	if var_30_6 then
		for iter_30_0, iter_30_1 in pairs(var_30_6) do
			local var_30_7 = arg_30_2:getFogDataByIdx(tonumber(iter_30_1))
			
			if var_30_7 then
				local var_30_8 = var_30_7:getVisibility()
				
				if var_30_8 == LotaFogVisibilityEnum.VISIBLE or var_30_8 == LotaFogVisibilityEnum.DISCOVER and var_30_4 then
					var_30_5 = true
					
					break
				end
			end
		end
	end
	
	return var_30_5
end

function HTBObjectRenderer.setNodeChildVisible(arg_31_0, arg_31_1, arg_31_2)
	if not get_cocos_refid(arg_31_1) then
		return 
	end
	
	if_set_visible(arg_31_1, "effect_node", arg_31_2)
	if_set_visible(arg_31_1, "render_object", arg_31_2)
end

function HTBObjectRenderer.addEffect(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0.vars.object_hash[arg_32_1]
	
	if not var_32_0 then
		return 
	end
	
	arg_32_2 = arg_32_2 or {}
	
	if not arg_32_2.fn then
		arg_32_2.fn = "ui_pet_act_eff.cfx"
	end
	
	arg_32_2.layer = var_32_0
	
	EffectManager:Play(arg_32_2)
end

function HTBObjectRenderer.updateObject(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.object_layer) then
		return 
	end
	
	if not arg_33_1 then
		return 
	end
	
	local var_33_0 = LotaObjectSystem:getObject(arg_33_1)
	
	if not var_33_0 then
		return 
	end
	
	local var_33_1 = arg_33_0.vars.object_hash[arg_33_1]
	
	arg_33_0:updateObjectSprite(var_33_1, var_33_0)
end

function HTBObjectRenderer.findObject(arg_34_0, arg_34_1)
	return arg_34_0.vars.object_hash[arg_34_1] ~= nil
end

function HTBObjectRenderer.isExistRenderObject(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0.vars.object_hash[arg_35_1]
	
	if not var_35_0 then
		return 
	end
	
	return var_35_0:findChildByName("render_object") ~= nil
end

function HTBObjectRenderer.getFocusYPosition(arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0.vars.object_hash[arg_36_1]
	
	if not var_36_0 then
		return 
	end
	
	local var_36_1 = var_36_0.object_data
	local var_36_2 = var_36_0:findChildByName("render_object")
	
	if not var_36_2 then
		print("[ERROR] THIS FUNCTION MUST BE EXIST RENDER OBJECT, BUT NOT EXIST. deferred_create?", arg_36_0.vars.deferred_create)
		
		return 
	end
	
	local var_36_3 = var_36_1:getAdjustFocusYPos()
	
	if var_36_2.getBonePosition then
		local var_36_4, var_36_5 = var_36_2:getBonePosition("top")
		
		return var_36_5 / 2 + var_36_0:getPositionY() + var_36_3
	end
	
	return var_36_2:getContentSize().height * var_36_2:getAnchorPoint().y * var_36_2:getScaleY() + var_36_0:getPositionY() + var_36_3
end

function HTBObjectRenderer.updateObjectUI(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0.vars.object_hash[arg_37_1]
	
	if not var_37_0 then
		return 
	end
	
	if var_37_0.ui_info then
		var_37_0.ui_info:updateUI()
	end
end

function HTBObjectRenderer.setVisibleInfo(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0.vars.object_hash[arg_38_1]
	
	if not var_38_0 then
		return 
	end
	
	if var_38_0.ui_info then
		var_38_0.ui_info:setVisible(arg_38_2)
	end
end

function HTBObjectRenderer.visibleOff(arg_39_0)
	for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.object_hash) do
		iter_39_1:setVisible(false)
	end
end

function HTBObjectRenderer.requirePreload(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.vars.object_hash[arg_40_1]
	
	if not var_40_0 then
		return 
	end
	
	if LOW_RESOLUTION_MODE then
		return 
	end
	
	if not var_40_0:findChildByName("render_object") then
		arg_40_0:preloadRenderObject(var_40_0.object_data)
	end
end

function HTBObjectRenderer.setVisibleObject(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0.vars.object_hash[arg_41_1]
	
	if not var_41_0 then
		return 
	end
	
	if var_41_0 then
		var_41_0:setVisible(arg_41_2)
		
		if arg_41_2 then
			var_41_0.last_visible_tm = uitick()
		end
		
		if arg_41_0.vars.deferred_create and arg_41_2 and not var_41_0:findChildByName("render_object") then
			local var_41_1 = var_41_0.object_data:isModel()
			local var_41_2 = false
			local var_41_3
			
			if var_41_1 and arg_41_0.vars.deferred_created_count >= arg_41_0.vars.deferred_max_created_count then
				var_41_2 = true
				var_41_3 = arg_41_0:createRenderObject(var_41_0.object_data, true)
				var_41_3.on_limit_create = true
			else
				var_41_3 = arg_41_0:createRenderObject(var_41_0.object_data)
			end
			
			if get_cocos_refid(var_41_3) then
				var_41_0:addChild(var_41_3)
				arg_41_0:updateObjectSprite(var_41_0, var_41_0.object_data)
				
				if var_41_1 and not var_41_2 then
					arg_41_0.vars.deferred_created_count = arg_41_0.vars.deferred_created_count + 1
				end
			end
		end
	end
end

function HTBObjectRenderer.considerExpirePerSprite(arg_42_0, arg_42_1)
	if arg_42_1 then
		local var_42_0 = arg_42_1:findChildByName("render_object")
		
		if var_42_0 then
			local var_42_1 = var_42_0.on_limit_create
			
			var_42_0:removeFromParent()
			
			if arg_42_1.object_data:isModel() and not var_42_1 then
				arg_42_0.vars.deferred_created_count = arg_42_0.vars.deferred_created_count - 1
			end
			
			if LOW_RESOLUTION_MODE and arg_42_1.ui_info then
				arg_42_0:removeObjectUI(arg_42_1.ui_info:getUID())
			end
			
			arg_42_1.last_visible_tm = nil
			
			return true
		end
	end
	
	return false
end

function HTBObjectRenderer.considerExpire(arg_43_0, arg_43_1)
	local var_43_0 = uitick()
	local var_43_1 = 0
	
	for iter_43_0, iter_43_1 in pairs(arg_43_0.vars.object_hash) do
		if iter_43_1.last_visible_tm and var_43_0 - iter_43_1.last_visible_tm > 500 and arg_43_0:considerExpirePerSprite(iter_43_1) then
			var_43_1 = var_43_1 + 1
		end
	end
	
	return arg_43_0.vars.deferred_created_count, var_43_1
end

function HTBObjectRenderer.getObjectList(arg_44_0)
	if not arg_44_0.vars then
		return 
	end
	
	return arg_44_0.vars.object_hash
end
