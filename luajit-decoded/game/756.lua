SPLTileMapRenderer = {}

copy_functions(HTBTileMapRenderer, SPLTileMapRenderer)

function SPLTileMapRenderer.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0:base_init(SPLInterfaceImpl.whiteboardSet, arg_1_1, arg_1_2)
end

function SPLTileMapRenderer.setPosingSprite(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0:base_setPosingSprite(SPLInterfaceImpl.whiteboardGet, arg_2_1, arg_2_2)
end

function SPLTileMapRenderer.drawMovableAreaPerTile(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:base_drawMovableAreaPerTile(SPLInterfaceImpl.getObject, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
end

function SPLTileMapRenderer.iterDrawMovableAreaPerTile(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:base_iterDrawMovableAreaPerTile(SPLInterfaceImpl.getObject, SPLInterfaceImpl.getTileById, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
end

function SPLTileMapRenderer.isTileMainId(arg_5_0, arg_5_1)
	return arg_5_0:base_isTileMainId(SPLInterfaceImpl.getObject, arg_5_1)
end

function SPLTileMapRenderer.isTileHaveAddSelect(arg_6_0, arg_6_1)
	return arg_6_0:base_isTileHaveAddSelect(SPLInterfaceImpl.isTileHaveAddSelect, arg_6_1)
end

function SPLTileMapRenderer.getMainTile(arg_7_0, arg_7_1)
	return arg_7_0:base_getMainTile(SPLInterfaceImpl.getObject, SPLInterfaceImpl.getTileById, arg_7_1)
end

function SPLTileMapRenderer.revertToBack(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_3 = true
	
	arg_8_0:base_revertToBack(SPLInterfaceImpl.whiteboardGet, arg_8_1, arg_8_2, arg_8_3)
	
	if arg_8_2 == "marking" then
		arg_8_0:removeMoveArrow()
		SPLObjectRenderer:resetClairPosition("marking")
	end
end

function SPLTileMapRenderer.marking(arg_9_0, arg_9_1)
	arg_9_0:base_marking(SPLInterfaceImpl.getTileByPos, arg_9_1, SEQ(RLOG(OPACITY(350, 1, 0.8)), LOG(OPACITY(350, 0.8, 1))))
	
	arg_9_0.vars.move_arrow = arg_9_0:makeMoveArrow(arg_9_1)
	
	SPLObjectRenderer:setClairPosition("marking", arg_9_0.vars.marking_pos)
end

function SPLTileMapRenderer.makeMoveArrow(arg_10_0, arg_10_1)
	local var_10_0 = SPLSystem:getFieldLayer()
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = arg_10_0.vars.marking_sprite
	
	if not get_cocos_refid(var_10_1) then
		return 
	end
	
	local var_10_2 = SpriteCache:getSprite("img/_cm_arrow_glow2.png")
	
	if not get_cocos_refid(var_10_2) then
		return 
	end
	
	var_10_0:addChild(var_10_2)
	
	local var_10_3, var_10_4 = var_10_1:getPosition()
	local var_10_5 = var_10_4 + 50
	
	var_10_2:setVisible(true)
	var_10_2:setPosition(var_10_3, var_10_5)
	var_10_2:setScale(0.66)
	
	local var_10_6 = SPLTileMapSystem:getTileByPos(arg_10_1)
	
	if var_10_6 then
		local var_10_7 = arg_10_0:getMainTile(var_10_6)
		local var_10_8 = var_10_7 and var_10_7:getPos() or arg_10_1
		
		var_10_2:setLocalZOrder(var_10_8.y * -5 + 3)
	end
	
	UIAction:Add(LOOP(SEQ(RLOG(MOVE_TO(350, var_10_3, var_10_5 - 20)), LOG(MOVE_TO(350, var_10_3, var_10_5)))), var_10_2, "move_arrow")
	
	return var_10_2
end

function SPLTileMapRenderer.removeMoveArrow(arg_11_0)
	local var_11_0 = arg_11_0.vars.move_arrow
	
	if get_cocos_refid(var_11_0) then
		UIAction:Add(SEQ(FADE_OUT(200), CALL(function()
			UIAction:Remove("move_arrow")
		end), REMOVE()), var_11_0)
	end
	
	arg_11_0.vars.move_arrow = nil
end

function SPLTileMapRenderer.makeDebugText(arg_13_0, arg_13_1)
	local var_13_0 = ccui.Text:create()
	
	var_13_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	var_13_0:setFontName("font/daum.ttf")
	var_13_0:setFontSize(40)
	var_13_0:enableOutline(cc.c3b(0, 0, 0), 1)
	var_13_0:setScale(1)
	var_13_0:setPosition(0, 400)
	var_13_0:setLocalZOrder(999996)
	var_13_0:setAnchorPoint(0.5, 1)
	var_13_0:setName("_debug_text")
	
	local var_13_1 = arg_13_1:getPos()
	local var_13_2 = arg_13_1:getTileId()
	local var_13_3 = string.format("ID: %d\nX: %d, Y: %d", var_13_2, var_13_1.x, var_13_1.y)
	
	var_13_0:setString(var_13_3)
	
	return var_13_0
end

function SPLTileMapRenderer.debug_tile_text(arg_14_0, arg_14_1)
	DEBUG.TEST_TILE_POS = arg_14_1
	
	arg_14_0:release()
	arg_14_0:draw(SPLTileMapSystem:getTileMapData())
	arg_14_0:createAllTile()
end
