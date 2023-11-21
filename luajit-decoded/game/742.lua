HTBTileMapRenderer = {}

function HTBTileMapRenderer.base_init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.vars = {}
	arg_1_0.vars.pos_sprite_hash_map = {}
	arg_1_0.vars.layer = arg_1_2
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
	arg_1_0.vars.is_minimap = arg_1_3
	
	if not arg_1_0.vars.is_minimap then
		HTBInterface:whiteboardSet(arg_1_1, "tile_scale", 0.25)
		HTBInterface:whiteboardSet(arg_1_1, "tile_width", arg_1_0.vars.tile_width)
		HTBInterface:whiteboardSet(arg_1_1, "tile_height", arg_1_0.vars.tile_height)
		HTBInterface:whiteboardSet(arg_1_1, "tile_y_gap", var_1_1)
		HTBInterface:whiteboardSet(arg_1_1, "tile_y_scale", arg_1_0.vars.y_scale)
		HTBInterface:whiteboardSet(arg_1_1, "tile_map_z_order", arg_1_0.vars.base_z_order)
	end
	
	arg_1_0.vars.layer:addChild(arg_1_0.vars.marking_sprite)
	if_set_visible(arg_1_0.vars.marking_sprite, nil, false)
end

function HTBTileMapRenderer.base_setPosingSprite(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_3:getPos()
	local var_2_1 = arg_2_0.vars.tile_width
	local var_2_2 = arg_2_0.vars.tile_height
	local var_2_3 = HTBInterface:whiteboardGet(arg_2_1, "ambient_color")
	local var_2_4 = 0
	local var_2_5 = arg_2_3:getLocationZ() or 1
	local var_2_6 = var_2_5
	
	if arg_2_0.vars.is_minimap then
		var_2_6 = 0
	end
	
	local var_2_7 = arg_2_0:getTileSpritePos(var_2_0)
	
	arg_2_2:setPosition(var_2_7.x, var_2_7.y + var_2_4 + var_2_6)
	
	if not arg_2_0.vars.is_minimap then
		arg_2_2:setColor(var_2_3)
	end
	
	local var_2_8 = 0
	
	if var_2_0.z then
		local var_2_9 = var_2_0.z
	end
	
	local var_2_10 = 0
	
	if var_2_5 ~= 0 then
		var_2_10 = 1
	end
	
	local var_2_11 = var_2_0.y * -5 + var_2_10
	
	if arg_2_0.vars.is_minimap and arg_2_0:isTileMainId(arg_2_3) then
		var_2_11 = var_2_11 + 1
	end
	
	arg_2_2:setLocalZOrder(var_2_11)
	
	return arg_2_2
end

function HTBTileMapRenderer.base_iterDrawMovableAreaPerTile(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_3[arg_3_4]
	
	if arg_3_0.vars.marking_pos and HTUtil:isSamePosition(var_3_0.pos, arg_3_0.vars.marking_pos) then
		return 
	end
	
	local var_3_1 = arg_3_0:getTileSprite(var_3_0)
	local var_3_2 = HTBInterface:getObject(arg_3_1, var_3_0:getTileId())
	
	if not arg_3_5[var_3_0:getTileId()] then
		if not var_3_2 or not var_3_2:isActive() or table.empty(var_3_2:getChildTileList()) then
			arg_3_0:drawMovableAreaPerTile(var_3_1, var_3_0, arg_3_4, arg_3_6)
			
			arg_3_5[var_3_0:getTileId()] = true
		else
			for iter_3_0, iter_3_1 in pairs(var_3_2:getChildTileList()) do
				local var_3_3 = HTBInterface:getTileById(arg_3_2, iter_3_1)
				
				arg_3_5[var_3_3:getTileId()] = true
				
				local var_3_4 = arg_3_0:getTileSprite(var_3_3)
				
				arg_3_0:drawMovableAreaPerTile(var_3_4, var_3_3, arg_3_4, arg_3_6)
			end
			
			local var_3_5 = HTBInterface:getTileById(arg_3_2, var_3_2:getUID())
			local var_3_6 = arg_3_0:getTileSprite(var_3_5)
			
			arg_3_5[var_3_5:getTileId()] = true
			
			arg_3_0:drawMovableAreaPerTile(var_3_6, var_3_5, arg_3_4, arg_3_6)
		end
	end
end

function HTBTileMapRenderer.base_isTileMainId(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2:getTileId()
	
	if var_4_0 then
		local var_4_1 = HTBInterface:getObject(arg_4_1, var_4_0)
		
		if var_4_1 and not table.empty(var_4_1:getChildTileList()) and var_4_1:isMainId(arg_4_2:getTileId()) then
			return true
		end
	end
	
	return false
end

function HTBTileMapRenderer.base_isTileHaveAddSelect(arg_5_0, arg_5_1, arg_5_2)
	return HTBInterface:isTileHaveAddSelect(arg_5_1, arg_5_2)
end

function HTBTileMapRenderer.base_getMainTile(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3:getTileId()
	local var_6_1 = HTBInterface:getObject(arg_6_1, var_6_0)
	
	if not var_6_1 then
		return arg_6_3
	end
	
	return HTBInterface:getTileById(arg_6_2, var_6_1:getUID())
end

function HTBTileMapRenderer.base_revertToBack(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = HTBInterface:whiteboardGet(arg_7_1, "ambient_color")
	
	for iter_7_0, iter_7_1 in pairs(arg_7_2) do
		local var_7_1 = arg_7_0:getHashKey(iter_7_1)
		local var_7_2 = arg_7_0.vars.pos_sprite_hash_map[var_7_1]
		
		if arg_7_3 ~= "marking" and get_cocos_refid(var_7_2) then
			UIAction:Remove("draw_tile_" .. iter_7_0)
			
			local var_7_3 = var_7_2:findChildByName("overlay")
			
			if get_cocos_refid(var_7_3) then
				if not arg_7_4 then
					UIAction:Add(SEQ(FADE_OUT(1000), REMOVE()), var_7_3, "draw_tile_remove_" .. iter_7_0)
				else
					var_7_3:removeFromParent()
				end
			end
		elseif HTUtil:isSamePosition(iter_7_1, arg_7_0.vars.marking_pos) and get_cocos_refid(arg_7_0.vars.marking_sprite) then
			if_set_visible(arg_7_0.vars.marking_sprite, nil, false)
		end
		
		if_set_color(var_7_2, nil, var_7_0)
	end
end

function HTBTileMapRenderer.base_marking(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_0:unmarking()
	
	local var_8_0 = arg_8_0:getTileSprite(arg_8_2)
	
	if get_cocos_refid(var_8_0) then
		local var_8_1 = HTBInterface:getTileByPos(arg_8_1, arg_8_2)
		local var_8_2 = arg_8_0.vars.marking_sprite
		local var_8_3 = arg_8_0.vars.marking_sprite_default_name
		local var_8_4 = false
		
		if arg_8_0:isTileHaveAddSelect(var_8_1) then
			var_8_3 = arg_8_0.vars.marking_sprite_3select_name
			arg_8_2 = arg_8_0:getMainTile(var_8_1):getPos()
			var_8_0 = arg_8_0:getTileSprite(arg_8_2)
			var_8_4 = true
		end
		
		if var_8_2.last_sprite ~= var_8_3 then
			SpriteCache:resetSprite(arg_8_0.vars.marking_sprite, var_8_3)
			
			arg_8_0.vars.marking_sprite.last_sprite = var_8_3
			var_8_2 = arg_8_0.vars.marking_sprite
		end
		
		local var_8_5, var_8_6 = var_8_0:getPosition()
		local var_8_7 = var_8_6 + 86
		
		if_set_visible(var_8_2, nil, true)
		
		if var_8_4 then
			var_8_5 = var_8_5 + 54
			var_8_7 = var_8_7 + 26
		end
		
		var_8_2:setPosition(var_8_5, var_8_7)
		var_8_2:setLocalZOrder(var_8_0:getLocalZOrder() + 5)
		var_8_2:setOpacity(255)
		
		arg_8_3 = arg_8_3 or SEQ(DELAY(400), RLOG(FADE_OUT(1000)), LOG(FADE_IN(1000)))
		
		UIAction:Add(LOOP(arg_8_3), var_8_2, "blink_mark")
		if_set_visible(var_8_0, "overlay", false)
		
		arg_8_0.vars.marking_pos = arg_8_2
	end
end

function HTBTileMapRenderer.release(arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.pos_sprite_hash_map) do
		iter_9_1:removeFromParent()
	end
	
	arg_9_0.vars.pos_sprite_hash_map = {}
end

function HTBTileMapRenderer.draw(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1:getLength()
	
	for iter_10_0 = 1, var_10_0 do
		local var_10_1 = arg_10_1:getTileByIndex(iter_10_0)
		
		arg_10_0:drawTile(var_10_1)
	end
end

function HTBTileMapRenderer.makeSprite(arg_11_0, arg_11_1)
	local var_11_0 = cc.Node:create()
	local var_11_1 = arg_11_1:getPos()
	
	var_11_0.tile = arg_11_1
	var_11_0.render_object = nil
	
	var_11_0:setName(var_11_1.x .. "_" .. var_11_1.y)
	var_11_0:setScale(0.25)
	
	return var_11_0
end

function HTBTileMapRenderer.makeRenderObject(arg_12_0, arg_12_1)
	local var_12_0 = "tile/" .. arg_12_1:getResource() .. ".png"
	local var_12_1 = SpriteCache:getSprite(var_12_0)
	
	if not var_12_1 then
		Log.e("no sprite resource", var_12_0)
		
		return 
	end
	
	var_12_1:setPosition(0, 0)
	var_12_1:setName("render_object")
	var_12_1:setScale(4)
	var_12_1:setLocalZOrder(1)
	
	return var_12_1
end

function HTBTileMapRenderer.makeDebugText(arg_13_0, arg_13_1)
	local var_13_0 = ccui.Text:create()
	
	var_13_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	var_13_0:setFontName("font/daum.ttf")
	var_13_0:setFontSize(40)
	var_13_0:enableOutline(cc.c3b(0, 0, 0), 1)
	var_13_0:setScale(1)
	var_13_0:setPosition(200, 870)
	var_13_0:setLocalZOrder(999996)
	var_13_0:setAnchorPoint(0.5, 1)
	var_13_0:setName("_debug_text")
	
	local var_13_1 = arg_13_1:getPos()
	local var_13_2 = arg_13_1:getTileId()
	local var_13_3 = string.format("ID: %d\nX: %d, Y: %d", var_13_2, var_13_1.x, var_13_1.y)
	
	var_13_0:setString(var_13_3)
	
	return var_13_0
end

function HTBTileMapRenderer.getTileSpritePos(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.tile_width
	local var_14_1 = arg_14_0.vars.tile_height
	
	return {
		x = arg_14_1.x * (var_14_0 / 2),
		y = arg_14_1.y * (var_14_1 / 2)
	}
end

function HTBTileMapRenderer.getTempTile(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.layer
	local var_15_1 = arg_15_0:makeSprite(arg_15_1)
	
	var_15_1:setName("temp__" .. var_15_1:getName())
	
	local var_15_2 = arg_15_0:makeRenderObject(var_15_1.tile)
	
	var_15_1.render_object = var_15_2
	
	var_15_1:addChild(var_15_2)
	var_15_0:addChild(var_15_1)
	arg_15_0:setPosingSprite(var_15_1, arg_15_1)
	
	return var_15_1
end

function HTBTileMapRenderer.getTile(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0:getHashKey(arg_16_1)
	
	return arg_16_0.vars.pos_sprite_hash_map[var_16_0]
end

function HTBTileMapRenderer.getHashKey(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1
	
	if arg_17_1.getPos then
		var_17_0 = arg_17_1:getPos()
	end
	
	return var_17_0.x .. "/" .. var_17_0.y
end

DEBUG.TEST_TILE_POS = false

function HTBTileMapRenderer.drawTile(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.layer
	local var_18_1 = arg_18_0:makeSprite(arg_18_1)
	
	if DEBUG.TEST_TILE_POS then
		local var_18_2 = arg_18_0:makeDebugText(arg_18_1)
		
		var_18_1:addChild(var_18_2)
	end
	
	local var_18_3 = arg_18_0:getHashKey(arg_18_1)
	
	arg_18_0.vars.pos_sprite_hash_map[var_18_3] = var_18_1
	
	var_18_0:addChild(var_18_1)
	arg_18_0:setPosingSprite(var_18_1, arg_18_1)
end

function HTBTileMapRenderer.revertMovableArea(arg_19_0, arg_19_1)
	if arg_19_0.vars.prv_movable_list then
		arg_19_0:revertToBack(arg_19_0.vars.prv_movable_list, nil, arg_19_1)
		
		arg_19_0.vars.prv_movable_list = nil
	end
end

local function var_0_0(arg_20_0, arg_20_1)
	arg_20_0 = arg_20_0 or "tile/move.png"
	arg_20_1 = arg_20_1 or "overlay"
	
	local var_20_0 = SpriteCache:getSprite(arg_20_0)
	
	var_20_0:setName(arg_20_1)
	var_20_0:setOpacity(0)
	var_20_0:setPosition(0, 350)
	var_20_0:setLocalZOrder(2)
	
	return var_20_0
end

function HTBTileMapRenderer.drawInteractionArea(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1:getLength()
	
	for iter_21_0 = 1, var_21_0 do
		local var_21_1 = arg_21_1:getTileByIndex(iter_21_0)
		local var_21_2 = arg_21_0:getTileSprite(var_21_1)
		local var_21_3 = var_21_2:findChildByName("interaction_overlay")
		
		if var_21_1:isExistObject() and not var_21_3 then
			var_21_3 = var_0_0("tile/move_spot.png", "interaction_overlay")
			
			var_21_3:setOpacity(255)
			var_21_2:addChild(var_21_3)
		elseif var_21_3 then
			var_21_3:removeFromParent()
		end
	end
end

function HTBTileMapRenderer.base_drawMovableAreaPerTile(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0 = false
	local var_22_1 = "tile/move.png"
	
	if arg_22_3:isExistObject() then
		local var_22_2 = arg_22_3:getObjectId()
		
		if HTBInterface:getObject(arg_22_1, var_22_2):isActive() then
			var_22_1 = "tile/move_spot.png"
			var_22_0 = true
		end
	end
	
	if arg_22_3:isMovable() then
		var_22_0 = true
	end
	
	local var_22_3 = arg_22_2:findChildByName("overlay")
	
	if (not arg_22_5 or arg_22_5(var_22_3, var_22_1)) and var_22_0 then
		if var_22_3 then
			var_22_3:removeFromParent()
		end
		
		local var_22_4 = var_0_0(var_22_1)
		
		var_22_4.sprite_name = var_22_1
		
		arg_22_2:addChild(var_22_4)
		UIAction:Add(SEQ(FADE_IN(1000)), var_22_4, "draw_tile_" .. arg_22_4)
		table.insert(arg_22_0.vars.prv_movable_list, arg_22_3)
	end
end

function HTBTileMapRenderer.drawMovableArea(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.layer) then
		return 
	end
	
	local var_23_0 = {}
	
	if arg_23_2 and arg_23_0.vars.prv_movable_list then
		if UIAction:Find("block") then
			return 
		end
		
		for iter_23_0 = 1, #arg_23_1 do
			arg_23_0:iterDrawMovableAreaPerTile(arg_23_1, iter_23_0, var_23_0, function(arg_24_0, arg_24_1)
				return not arg_24_0 or arg_24_0.sprite_name ~= arg_24_1
			end)
		end
		
		return 
	end
	
	if arg_23_2 then
		return 
	end
	
	if arg_23_0.vars.prv_movable_list then
		arg_23_0:revertToBack(arg_23_0.vars.prv_movable_list)
	end
	
	arg_23_0.vars.prv_movable_list = {}
	
	for iter_23_1 = 1, #arg_23_1 do
		arg_23_0:iterDrawMovableAreaPerTile(arg_23_1, iter_23_1, var_23_0)
	end
end

function HTBTileMapRenderer.unmarking(arg_25_0)
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

function HTBTileMapRenderer.getTileSprite(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0:getHashKey(arg_26_1)
	
	return arg_26_0.vars.pos_sprite_hash_map[var_26_0]
end

function HTBTileMapRenderer.createAllTile(arg_27_0)
	for iter_27_0, iter_27_1 in pairs(arg_27_0.vars.pos_sprite_hash_map) do
		if not iter_27_1.render_object then
			local var_27_0 = arg_27_0:makeRenderObject(iter_27_1.tile)
			
			iter_27_1.render_object = var_27_0
			
			iter_27_1:addChild(var_27_0)
		end
	end
end

function HTBTileMapRenderer.visibleOff(arg_28_0)
	for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.pos_sprite_hash_map) do
		iter_28_1:setVisible(false)
	end
end

function HTBTileMapRenderer.createTile(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0:getTileSprite(arg_29_1)
	
	var_29_0:setVisible(true)
	
	if not var_29_0.render_object then
		local var_29_1 = arg_29_0:makeRenderObject(var_29_0.tile)
		
		var_29_0.render_object = var_29_1
		
		var_29_0:addChild(var_29_1)
	end
end

function HTBTileMapRenderer.considerExpire(arg_30_0)
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.pos_sprite_hash_map) do
		if iter_30_1.render_object and not iter_30_1:isVisible() then
			iter_30_1.render_object:removeFromParent()
			
			iter_30_1.render_object = nil
		end
	end
end

function HTBTileMapRenderer.close(arg_31_0)
	if not arg_31_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_31_0.vars.layer) then
		arg_31_0.vars.layer:removeFromParent()
	end
	
	arg_31_0.vars = nil
end
