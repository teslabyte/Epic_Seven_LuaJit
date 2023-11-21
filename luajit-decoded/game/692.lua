LotaTileRenderer = {}

function LotaTileRenderer.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.pos_sprite_hash_map = {}
	arg_1_0.vars.layer = arg_1_1
	arg_1_0.vars.marking_sprite_default_name = "img/heritage_select.png"
	arg_1_0.vars.marking_sprite_3select_name = "img/heritage_select_3.png"
	arg_1_0.vars.marking_sprite = SpriteCache:getSprite(arg_1_0.vars.marking_sprite_default_name)
	arg_1_0.vars.marking_sprite.last_sprite = arg_1_0.vars.marking_sprite_default_name
	
	arg_1_0.vars.marking_sprite:setScale(0.25)
	
	local var_1_0 = 0
	local var_1_1 = -140.5
	
	arg_1_0.vars.y_scale = 1
	
	local var_1_2 = 428
	local var_1_3 = 950
	
	arg_1_0.vars.tile_width = var_1_2 / 4 + var_1_0
	arg_1_0.vars.tile_height = (var_1_3 / 4 + var_1_1) * arg_1_0.vars.y_scale
	arg_1_0.vars.not_movable_effect_y = 8.5
	arg_1_0.vars.is_minimap = arg_1_2
	
	if not arg_1_0.vars.is_minimap then
		LotaWhiteboard:set("tile_scale", 0.25)
		LotaWhiteboard:set("tile_width", arg_1_0.vars.tile_width)
		LotaWhiteboard:set("tile_height", arg_1_0.vars.tile_height)
		LotaWhiteboard:set("tile_y_gap", var_1_1)
		LotaWhiteboard:set("tile_y_scale", arg_1_0.vars.y_scale)
		LotaWhiteboard:set("tile_map_z_order", arg_1_0.vars.base_z_order)
	end
	
	arg_1_0.vars.layer:addChild(arg_1_0.vars.marking_sprite)
	if_set_visible(arg_1_0.vars.marking_sprite, nil, false)
end

function LotaTileRenderer.release(arg_2_0)
	for iter_2_0, iter_2_1 in pairs(arg_2_0.vars.pos_sprite_hash_map) do
		iter_2_1:removeFromParent()
	end
	
	arg_2_0.vars.pos_sprite_hash_map = {}
end

function LotaTileRenderer.draw(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1:getLength()
	
	for iter_3_0 = 1, var_3_0 do
		local var_3_1 = arg_3_1:getTileByIndex(iter_3_0)
		
		arg_3_0:drawTile(var_3_1)
	end
end

function LotaTileRenderer.makeSprite(arg_4_0, arg_4_1)
	local var_4_0 = cc.Node:create()
	local var_4_1 = arg_4_1:getPos()
	
	var_4_0.tile = arg_4_1
	var_4_0.render_object = nil
	
	var_4_0:setName(var_4_1.x .. "_" .. var_4_1.y)
	var_4_0:setScale(0.25)
	
	return var_4_0
end

function LotaTileRenderer.makeRenderObject(arg_5_0, arg_5_1)
	local var_5_0 = "tile/" .. arg_5_1:getResource() .. ".png"
	local var_5_1 = SpriteCache:getSprite(var_5_0)
	
	var_5_1:setPosition(0, 0)
	var_5_1:setName("render_object")
	var_5_1:setScale(4)
	var_5_1:setLocalZOrder(1)
	
	return var_5_1
end

function LotaTileRenderer.makeDebugText(arg_6_0, arg_6_1)
	local var_6_0 = ccui.Text:create()
	
	var_6_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	var_6_0:setFontName("font/daum.ttf")
	var_6_0:setFontSize(40)
	var_6_0:enableOutline(cc.c3b(0, 0, 0), 1)
	var_6_0:setScale(1)
	var_6_0:setPosition(200, 870)
	var_6_0:setLocalZOrder(999996)
	var_6_0:setAnchorPoint(0.5, 1)
	var_6_0:setName("_debug_text")
	
	local var_6_1 = arg_6_1:getPos()
	local var_6_2 = arg_6_1:getTileId()
	local var_6_3 = string.format("ID: %d\nX: %d, Y: %d", var_6_2, var_6_1.x, var_6_1.y)
	
	var_6_0:setString(var_6_3)
	
	return var_6_0
end

function LotaTileRenderer.isTileMainId(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1:getTileId()
	
	if var_7_0 then
		local var_7_1 = LotaObjectSystem:getObject(var_7_0)
		
		if var_7_1 and not table.empty(var_7_1:getChildTileList()) and var_7_1:isMainId(arg_7_1:getTileId()) then
			return true
		end
	end
	
	return false
end

function LotaTileRenderer.isTileHaveAddSelect(arg_8_0, arg_8_1)
	return LotaUtil:isTileHaveAddSelect(arg_8_1)
end

function LotaTileRenderer.getMainTile(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1:getTileId()
	local var_9_1 = LotaObjectSystem:getObject(var_9_0)
	
	if not var_9_1 then
		return var_9_0
	end
	
	return LotaTileMapSystem:getTileById(var_9_1:getUID())
end

function LotaTileRenderer.getTileSpritePos(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.vars.tile_width
	local var_10_1 = arg_10_0.vars.tile_height
	
	return {
		x = arg_10_1.x * (var_10_0 / 2),
		y = arg_10_1.y * (var_10_1 / 2)
	}
end

function LotaTileRenderer.setPosingSprite(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_2:getPos()
	local var_11_1 = arg_11_0.vars.tile_width
	local var_11_2 = arg_11_0.vars.tile_height
	local var_11_3 = LotaWhiteboard:get("ambient_color")
	local var_11_4 = 0
	local var_11_5 = arg_11_2:getLocationZ() or 1
	local var_11_6 = var_11_5
	
	if arg_11_0.vars.is_minimap then
		var_11_6 = 0
	end
	
	local var_11_7 = arg_11_0:getTileSpritePos(var_11_0)
	
	arg_11_1:setPosition(var_11_7.x, var_11_7.y + var_11_4 + var_11_6)
	
	if not arg_11_0.vars.is_minimap then
		arg_11_1:setColor(var_11_3)
	end
	
	local var_11_8 = 0
	
	if var_11_0.z then
		local var_11_9 = var_11_0.z
	end
	
	local var_11_10 = 0
	
	if var_11_5 ~= 0 then
		var_11_10 = 1
	end
	
	local var_11_11 = var_11_0.y * -5 + var_11_10
	
	if arg_11_0.vars.is_minimap and arg_11_0:isTileMainId(arg_11_2) then
		var_11_11 = var_11_11 + 1
	end
	
	arg_11_1:setLocalZOrder(var_11_11)
	
	return arg_11_1
end

function LotaTileRenderer.getTempTile(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.vars.layer
	local var_12_1 = arg_12_0:makeSprite(arg_12_1)
	
	var_12_1:setName("temp__" .. var_12_1:getName())
	
	local var_12_2 = arg_12_0:makeRenderObject(var_12_1.tile)
	
	var_12_1.render_object = var_12_2
	
	var_12_1:addChild(var_12_2)
	var_12_0:addChild(var_12_1)
	arg_12_0:setPosingSprite(var_12_1, arg_12_1)
	
	return var_12_1
end

function LotaTileRenderer.getTile(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0:getHashKey(arg_13_1)
	
	return arg_13_0.vars.pos_sprite_hash_map[var_13_0]
end

function LotaTileRenderer.getHashKey(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1
	
	if arg_14_1.getPos then
		var_14_0 = arg_14_1:getPos()
	end
	
	return var_14_0.x .. "/" .. var_14_0.y
end

DEBUG.TEST_TILE_POS = false

function LotaTileRenderer.drawTile(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.layer
	local var_15_1 = arg_15_0:makeSprite(arg_15_1)
	
	if DEBUG.TEST_TILE_POS then
		local var_15_2 = arg_15_0:makeDebugText(arg_15_1)
		
		var_15_1:addChild(var_15_2)
	end
	
	local var_15_3 = arg_15_0:getHashKey(arg_15_1)
	
	arg_15_0.vars.pos_sprite_hash_map[var_15_3] = var_15_1
	
	var_15_0:addChild(var_15_1)
	arg_15_0:setPosingSprite(var_15_1, arg_15_1)
end

function LotaTileRenderer.revertToBack(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = LotaWhiteboard:get("ambient_color")
	
	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		local var_16_1 = arg_16_0:getHashKey(iter_16_1)
		local var_16_2 = arg_16_0.vars.pos_sprite_hash_map[var_16_1]
		
		if arg_16_2 ~= "marking" then
			UIAction:Remove("draw_tile_" .. iter_16_0)
			
			local var_16_3 = var_16_2:findChildByName("overlay")
			
			if get_cocos_refid(var_16_3) then
				local var_16_4
				
				if not arg_16_3 then
					var_16_4 = SEQ(FADE_OUT(1000), REMOVE())
				else
					var_16_4 = REMOVE()
				end
				
				UIAction:Add(var_16_4, var_16_3, "draw_tile_remove_" .. iter_16_0)
			end
		elseif LotaUtil:isSamePosition(iter_16_1, arg_16_0.vars.marking_pos) and get_cocos_refid(arg_16_0.vars.marking_sprite) then
			if_set_visible(arg_16_0.vars.marking_sprite, nil, false)
		end
		
		if_set_color(var_16_2, nil, var_16_0)
	end
end

function LotaTileRenderer.revertMovableArea(arg_17_0, arg_17_1)
	if arg_17_0.vars.prv_movable_list then
		arg_17_0:revertToBack(arg_17_0.vars.prv_movable_list, nil, arg_17_1)
		
		arg_17_0.vars.prv_movable_list = nil
	end
end

local function var_0_0(arg_18_0, arg_18_1)
	arg_18_0 = arg_18_0 or "tile/move.png"
	arg_18_1 = arg_18_1 or "overlay"
	
	local var_18_0 = SpriteCache:getSprite(arg_18_0)
	
	var_18_0:setName(arg_18_1)
	var_18_0:setOpacity(0)
	var_18_0:setPosition(0, 350)
	var_18_0:setLocalZOrder(2)
	
	return var_18_0
end

function LotaTileRenderer.drawInteractionArea(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1:getLength()
	
	for iter_19_0 = 1, var_19_0 do
		local var_19_1 = arg_19_1:getTileByIndex(iter_19_0)
		local var_19_2 = arg_19_0:getTileSprite(var_19_1)
		local var_19_3 = var_19_2:findChildByName("interaction_overlay")
		
		if var_19_1:isExistObject() and not var_19_3 then
			var_19_3 = var_0_0("tile/move_spot.png", "interaction_overlay")
			
			var_19_3:setOpacity(255)
			var_19_2:addChild(var_19_3)
		elseif var_19_3 then
			var_19_3:removeFromParent()
		end
	end
end

function LotaTileRenderer.drawMovableAreaPerTile(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = false
	local var_20_1 = "tile/move.png"
	
	if arg_20_2:isExistObject() then
		local var_20_2 = arg_20_2:getObjectId()
		
		if LotaObjectSystem:getObject(var_20_2):isActive() then
			var_20_1 = "tile/move_spot.png"
			var_20_0 = true
		end
	end
	
	if arg_20_2:isMovable() then
		var_20_0 = true
	end
	
	local var_20_3 = arg_20_1:findChildByName("overlay")
	
	if (not arg_20_4 or arg_20_4(var_20_3, var_20_1)) and var_20_0 then
		if var_20_3 then
			var_20_3:removeFromParent()
		end
		
		local var_20_4 = var_0_0(var_20_1)
		
		var_20_4.sprite_name = var_20_1
		
		arg_20_1:addChild(var_20_4)
		UIAction:Add(SEQ(FADE_IN(1000)), var_20_4, "draw_tile_" .. arg_20_3)
		table.insert(arg_20_0.vars.prv_movable_list, arg_20_2)
	end
end

function LotaTileRenderer.iterDrawMovableAreaPerTile(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_1[arg_21_2]
	
	if arg_21_0.vars.marking_pos and LotaUtil:isSamePosition(var_21_0.pos, arg_21_0.vars.marking_pos) then
		return 
	end
	
	local var_21_1 = arg_21_0:getTileSprite(var_21_0)
	local var_21_2 = LotaObjectSystem:getObject(var_21_0:getTileId())
	
	if not var_21_2 or not var_21_2:isActive() or table.empty(var_21_2:getChildTileList()) then
		arg_21_0:drawMovableAreaPerTile(var_21_1, var_21_0, arg_21_2, arg_21_4)
	elseif not arg_21_3[var_21_0:getTileId()] then
		for iter_21_0, iter_21_1 in pairs(var_21_2:getChildTileList()) do
			local var_21_3 = LotaTileMapSystem:getTileById(iter_21_1)
			
			arg_21_3[var_21_3:getTileId()] = true
			
			local var_21_4 = arg_21_0:getTileSprite(var_21_3)
			
			arg_21_0:drawMovableAreaPerTile(var_21_4, var_21_3, arg_21_2, arg_21_4)
		end
		
		local var_21_5 = LotaTileMapSystem:getTileById(var_21_2:getUID())
		local var_21_6 = arg_21_0:getTileSprite(var_21_5)
		
		arg_21_3[var_21_5:getTileId()] = true
		
		arg_21_0:drawMovableAreaPerTile(var_21_6, var_21_5, arg_21_2, arg_21_4)
	end
end

function LotaTileRenderer.drawMovableArea(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.layer) then
		return 
	end
	
	local var_22_0 = {}
	
	if arg_22_2 and arg_22_0.vars.prv_movable_list then
		if UIAction:Find("block") then
			return 
		end
		
		for iter_22_0 = 1, #arg_22_1 do
			arg_22_0:iterDrawMovableAreaPerTile(arg_22_1, iter_22_0, var_22_0, function(arg_23_0, arg_23_1)
				return not arg_23_0 or arg_23_0.sprite_name ~= arg_23_1
			end)
		end
		
		return 
	end
	
	if arg_22_2 then
		return 
	end
	
	if arg_22_0.vars.prv_movable_list then
		arg_22_0:revertToBack(arg_22_0.vars.prv_movable_list)
	end
	
	arg_22_0.vars.prv_movable_list = {}
	
	for iter_22_1 = 1, #arg_22_1 do
		arg_22_0:iterDrawMovableAreaPerTile(arg_22_1, iter_22_1, var_22_0)
	end
end

function LotaTileRenderer.marking(arg_24_0, arg_24_1)
	arg_24_0:unmarking()
	
	local var_24_0 = arg_24_0:getTileSprite(arg_24_1)
	
	if get_cocos_refid(var_24_0) then
		local var_24_1 = LotaTileMapSystem:getTileByPos(arg_24_1)
		local var_24_2 = arg_24_0.vars.marking_sprite
		local var_24_3 = arg_24_0.vars.marking_sprite_default_name
		local var_24_4 = false
		
		if arg_24_0:isTileHaveAddSelect(var_24_1) then
			var_24_3 = arg_24_0.vars.marking_sprite_3select_name
			arg_24_1 = arg_24_0:getMainTile(var_24_1):getPos()
			var_24_0 = arg_24_0:getTileSprite(arg_24_1)
			var_24_4 = true
		end
		
		if var_24_2.last_sprite ~= var_24_3 then
			SpriteCache:resetSprite(arg_24_0.vars.marking_sprite, var_24_3)
			
			arg_24_0.vars.marking_sprite.last_sprite = var_24_3
			var_24_2 = arg_24_0.vars.marking_sprite
		end
		
		local var_24_5, var_24_6 = var_24_0:getPosition()
		local var_24_7 = var_24_6 + 86
		
		if_set_visible(var_24_2, nil, true)
		
		if var_24_4 then
			var_24_5 = var_24_5 + 54
			var_24_7 = var_24_7 + 26
		end
		
		var_24_2:setPosition(var_24_5, var_24_7)
		var_24_2:setLocalZOrder(var_24_0:getLocalZOrder() + 5)
		var_24_2:setOpacity(255)
		UIAction:Add(LOOP(SEQ(DELAY(400), RLOG(FADE_OUT(1000)), LOG(FADE_IN(1000)))), var_24_2, "blink_mark")
		if_set_visible(var_24_0, "overlay", false)
		
		arg_24_0.vars.marking_pos = arg_24_1
	end
end

function LotaTileRenderer.unmarking(arg_25_0)
	if arg_25_0.vars.marking_pos then
		UIAction:Remove("blink_mark")
		arg_25_0:revertToBack({
			arg_25_0.vars.marking_pos
		}, "marking")
		
		local var_25_0 = arg_25_0.vars.marking_pos.x .. "/" .. arg_25_0.vars.marking_pos.y
		local var_25_1 = arg_25_0.vars.pos_sprite_hash_map[var_25_0]
		
		if_set_visible(var_25_1, "overlay", true)
		
		arg_25_0.vars.marking_pos = nil
	end
end

function LotaTileRenderer.getTileSprite(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0:getHashKey(arg_26_1)
	
	return arg_26_0.vars.pos_sprite_hash_map[var_26_0]
end

function LotaTileRenderer.createAllTile(arg_27_0)
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.pos_sprite_hash_map) do
		if not iter_27_1.render_object then
			local var_27_0 = arg_27_0:makeRenderObject(iter_27_1.tile)
			
			iter_27_1.render_object = var_27_0
			
			iter_27_1:addChild(var_27_0)
		end
	end
end

function LotaTileRenderer.visibleOff(arg_28_0)
	for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.pos_sprite_hash_map) do
		iter_28_1:setVisible(false)
	end
end

function LotaTileRenderer.createTile(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0:getTileSprite(arg_29_1)
	
	var_29_0:setVisible(true)
	
	if not var_29_0.render_object then
		local var_29_1 = arg_29_0:makeRenderObject(var_29_0.tile)
		
		var_29_0.render_object = var_29_1
		
		var_29_0:addChild(var_29_1)
	end
end

function LotaTileRenderer.considerExpire(arg_30_0)
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.pos_sprite_hash_map) do
		if iter_30_1.render_object and not iter_30_1:isVisible() then
			iter_30_1.render_object:removeFromParent()
			
			iter_30_1.render_object = nil
		end
	end
end

function LotaTileRenderer.close(arg_31_0)
	if not arg_31_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_31_0.vars.layer) then
		arg_31_0.vars.layer:removeFromParent()
	end
	
	arg_31_0.vars = nil
end
