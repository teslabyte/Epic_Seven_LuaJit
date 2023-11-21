RumbleBoard = {}

local var_0_0 = 62
local var_0_1 = 56
local var_0_2 = 10
local var_0_3 = 0
local var_0_4 = {
	{
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	},
	{
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2,
		0
	},
	{
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		3,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2
	},
	{
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2,
		0
	},
	{
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		3,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2
	},
	{
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2,
		0
	},
	{
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		3,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2
	},
	{
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		1,
		0,
		2,
		0,
		2,
		0,
		2,
		0,
		2,
		0
	}
}
local var_0_5 = {
	[1] = "img/z_tile_add.png"
}

function RumbleBoard.getTileMapWidth(arg_1_0)
	return var_0_4[1] and #var_0_4[1] or 0
end

function RumbleBoard.getTileMapHeight(arg_2_0)
	return #var_0_4
end

function RumbleBoard.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars = {}
	arg_3_0.vars.layer = cc.Node:create()
	arg_3_0.vars.units = {}
	arg_3_0.vars.sprite_map = {}
	
	for iter_3_0 = 1, #var_0_4 do
		arg_3_0.vars.sprite_map[iter_3_0] = {}
	end
	
	arg_3_0.vars.tile_layer = cc.Node:create()
	
	arg_3_0.vars.tile_layer:setCascadeOpacityEnabled(true)
	arg_3_0:showTiles(false, true)
	arg_3_0:drawTiles(arg_3_0.vars.tile_layer)
	arg_3_0.vars.layer:addChild(arg_3_0.vars.tile_layer)
	arg_3_0.vars.layer:setPosition(0, 0)
	arg_3_0.vars.layer:setCascadeOpacityEnabled(true)
	arg_3_1:addChild(arg_3_0.vars.layer)
	
	if arg_3_2.pos then
		arg_3_0:setPosition(arg_3_2.pos)
	end
	
	return arg_3_0
end

function RumbleBoard.getLayer(arg_4_0)
	return arg_4_0.vars and arg_4_0.vars.layer
end

function RumbleBoard.drawTiles(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	for iter_5_0, iter_5_1 in ipairs(var_0_4) do
		for iter_5_2, iter_5_3 in ipairs(iter_5_1) do
			if var_0_5[iter_5_3] then
				local var_5_0 = cc.Node:create()
				local var_5_1 = cc.Sprite:create("img/z_tile_stay.png")
				local var_5_2 = cc.Sprite:create("img/z_tile_add.png")
				
				var_5_1:setName("stay")
				var_5_2:setName("add")
				var_5_0:setCascadeOpacityEnabled(true)
				var_5_0:addChild(var_5_1)
				var_5_0:addChild(var_5_2)
				arg_5_1:addChild(var_5_0)
				
				local var_5_3, var_5_4 = arg_5_0:tilePosToBoardPos(iter_5_2, iter_5_0)
				
				var_5_0:setPosition(var_5_3, var_5_4 - var_0_3)
				var_5_0:setLocalZOrder(var_0_2 - iter_5_0)
				var_5_0:setScale(0.72)
				
				arg_5_0.vars.sprite_map[iter_5_0][iter_5_2] = var_5_0
			end
		end
	end
end

function RumbleBoard.isPlacablePos(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if not arg_6_0.vars then
		return 
	end
	
	arg_6_3 = arg_6_3 or 1
	
	if not var_0_4[arg_6_2] or not var_0_4[arg_6_2][arg_6_1] then
		return false
	end
	
	if RumblePlayer:isFieldFull() and arg_6_0.vars.selected_unit and not arg_6_0.vars.selected_unit:isActive() then
		return arg_6_0:getUnitByPos(arg_6_1, arg_6_2) ~= nil
	end
	
	return var_0_4[arg_6_2][arg_6_1] == arg_6_3
end

function RumbleBoard.addUnit(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.vars then
		return 
	end
	
	local var_7_0 = arg_7_1:getUnitNode()
	
	if not get_cocos_refid(var_7_0) then
		local var_7_1 = arg_7_1:makeUnitNode()
		
		arg_7_0.vars.layer:addChild(var_7_1)
	end
	
	table.insert(arg_7_0.vars.units, arg_7_1)
	arg_7_1:setPlace(arg_7_2)
	arg_7_1:reset()
	arg_7_1:setPosition(arg_7_2)
end

function RumbleBoard.placeUnit(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_1:setPlace(arg_8_2)
	arg_8_1:setPosition(arg_8_2)
end

function RumbleBoard.swapUnit(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars then
		return 
	end
	
	if arg_9_1 == arg_9_2 then
		return 
	end
	
	local var_9_0 = arg_9_1:getPosition()
	local var_9_1 = arg_9_2:getPosition()
	
	arg_9_1:setPosition(var_9_1)
	arg_9_2:setPosition(var_9_0)
	arg_9_1:setPlace(var_9_1)
	arg_9_2:setPlace(var_9_0)
end

function RumbleBoard.clear(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.units) do
		iter_10_1:remove()
	end
	
	arg_10_0.vars.units = {}
end

function RumbleBoard.beginBattle(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	for iter_11_0, iter_11_1 in ipairs(arg_11_0.vars.units) do
		iter_11_1:prepareBattle()
	end
	
	table.sort(arg_11_0.vars.units, function(arg_12_0, arg_12_1)
		local var_12_0 = arg_12_0:isEnemy()
		
		if var_12_0 == arg_12_1:isEnemy() then
			local var_12_1 = arg_12_0:getPosition()
			local var_12_2 = arg_12_1:getPosition()
			
			if var_12_1.x == var_12_2.x then
				return var_12_1.y < var_12_2.y
			end
			
			if var_12_0 then
				return var_12_1.x < var_12_2.x
			else
				return var_12_1.x > var_12_2.x
			end
		else
			return var_12_0
		end
	end)
	
	for iter_11_2, iter_11_3 in ipairs(arg_11_0.vars.units) do
		iter_11_3:run()
		iter_11_3:updateAttackTimer(RumbleSystem:getRandom(0, 1000))
	end
end

function RumbleBoard.tilePosToBoardPos(arg_13_0, arg_13_1, arg_13_2)
	return arg_13_1 * var_0_0, arg_13_2 * var_0_1 + var_0_3
end

function RumbleBoard.worldPosToTilePos(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0, var_14_1 = arg_14_0:getPosition()
	
	arg_14_1 = arg_14_1 - var_14_0
	arg_14_2 = arg_14_2 - var_14_1
	
	local var_14_2 = 31.25
	local var_14_3 = 0.33
	
	arg_14_2 = arg_14_2 - var_0_3 + var_14_2
	
	local var_14_4 = arg_14_1 / var_0_0
	local var_14_5 = arg_14_2 / var_0_1
	local var_14_6 = math.floor(var_14_4)
	local var_14_7 = math.floor(var_14_5)
	local var_14_8 = var_14_4 - var_14_6
	local var_14_9 = var_14_5 - var_14_7
	
	if var_14_6 % 2 == var_14_7 % 2 then
		if var_14_9 > var_14_8 * var_14_3 then
			return var_14_6, var_14_7
		else
			return var_14_6 + 1, var_14_7 - 1
		end
	elseif var_14_9 > -1 * (var_14_8 - 1) * var_14_3 then
		return var_14_6 + 1, var_14_7
	else
		return var_14_6, var_14_7 - 1
	end
end

function RumbleBoard.mark(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0.vars then
		return 
	end
	
	if not arg_15_0.vars.mark then
		arg_15_0.vars.mark = cc.Sprite:create("img/z_tile_remove.png")
		
		arg_15_0.vars.mark:setName("mark")
		arg_15_0.vars.mark:setScale(0.72)
		arg_15_0.vars.layer:addChild(arg_15_0.vars.mark)
	end
	
	local var_15_0, var_15_1 = arg_15_0:tilePosToBoardPos(arg_15_1, arg_15_2)
	
	arg_15_0.vars.mark:setPosition(var_15_0, var_15_1)
	arg_15_0.vars.mark:setLocalZOrder(arg_15_2 + 10)
	UIAction:Add(LOOP(RumbleUtil:getOpacityAct(2000, 1, 0.6, arg_15_0.vars.mark)), arg_15_0.vars.mark, "blink_mark")
end

function RumbleBoard.unmark(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	UIAction:Remove("blink_mark")
	
	if get_cocos_refid(arg_16_0.vars.mark) then
		arg_16_0.vars.mark:removeFromParent()
	end
	
	arg_16_0.vars.mark = nil
end

function RumbleBoard.select(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0.vars then
		return 
	end
	
	if not var_0_4[arg_17_2] or not var_0_4[arg_17_2][arg_17_1] then
		arg_17_0:deselectUnit()
		
		return 
	end
	
	local var_17_0 = arg_17_0:getUnitByPos(arg_17_1, arg_17_2)
	
	if var_17_0 then
		arg_17_0:onSelectUnit(var_17_0)
	else
		arg_17_0:onSelectTile(arg_17_1, arg_17_2)
	end
end

function RumbleBoard.getSelectedUnit(arg_18_0)
	return arg_18_0.vars and arg_18_0.vars.selected_unit
end

function RumbleBoard.onSelectUnit(arg_19_0, arg_19_1)
	if not arg_19_0.vars then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.selected_unit
	
	if var_19_0 then
		if not var_19_0:isActive() then
			local var_19_1 = arg_19_1:getPosition()
			
			RumblePlayer:revertToBench(arg_19_1)
			RumblePlayer:addToTeam(var_19_0, var_19_1)
		elseif var_19_0 == arg_19_1 then
			if RumblePlayer:isBenchFull() then
				balloon_message_with_sound("rumble_main_msg_roommax")
			else
				RumblePlayer:revertToBench(arg_19_1)
			end
		else
			arg_19_0:swapUnit(var_19_0, arg_19_1)
		end
		
		arg_19_0:deselectUnit()
	else
		local var_19_2 = arg_19_1:getPosition()
		
		arg_19_0:mark(var_19_2.x, var_19_2.y)
		arg_19_0:selectUnit(arg_19_1)
	end
end

function RumbleBoard.onSelectTile(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0.vars.selected_unit then
		if arg_20_0:isPlacablePos(arg_20_1, arg_20_2) then
			if not arg_20_0.vars.selected_unit:isActive() then
				RumblePlayer:addToTeam(arg_20_0.vars.selected_unit, {
					x = arg_20_1,
					y = arg_20_2
				})
			else
				arg_20_0:placeUnit(arg_20_0.vars.selected_unit, {
					x = arg_20_1,
					y = arg_20_2
				})
			end
		end
		
		arg_20_0:deselectUnit()
	end
end

function RumbleBoard.deselectUnit(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	RumbleUI:onDeselectUnit(arg_21_0.vars.selected_unit)
	
	arg_21_0.vars.selected_unit = nil
	
	arg_21_0:unmark()
	arg_21_0:showTiles(false)
end

function RumbleBoard.selectUnit(arg_22_0, arg_22_1)
	if not arg_22_0.vars then
		return 
	end
	
	if arg_22_0.vars.selected_unit == arg_22_1 then
		return 
	end
	
	arg_22_0.vars.selected_unit = arg_22_1
	
	arg_22_0:showTiles(true)
	RumbleUI:onSelectUnit(arg_22_1)
end

function RumbleBoard.getUnitByUID(arg_23_0, arg_23_1)
	if not arg_23_0.vars then
		return 
	end
	
	for iter_23_0, iter_23_1 in ipairs(arg_23_0.vars.units) do
		if iter_23_1:getUID() == arg_23_1 then
			return iter_23_1
		end
	end
end

function RumbleBoard.getUnits(arg_24_0, arg_24_1)
	if not arg_24_0.vars then
		return 
	end
	
	if not arg_24_1 then
		return arg_24_0.vars.units
	else
		local var_24_0 = arg_24_0.vars.units
		
		if arg_24_1.area then
			var_24_0 = arg_24_0:getUnitsInArea(arg_24_1.area) or {}
		end
		
		local var_24_1 = {}
		
		for iter_24_0, iter_24_1 in ipairs(var_24_0) do
			local var_24_2 = true
			
			if var_24_2 and not arg_24_1.include_dead then
				var_24_2 = var_24_2 and not iter_24_1:isDead()
			end
			
			if var_24_2 and not arg_24_1.include_hide then
				var_24_2 = var_24_2 and not iter_24_1:isHide()
			end
			
			if var_24_2 and arg_24_1.exclude_creature then
				var_24_2 = var_24_2 and not iter_24_1:isCreature()
			end
			
			if var_24_2 and arg_24_1.team then
				var_24_2 = iter_24_1:getTeam() == arg_24_1.team
			end
			
			if var_24_2 and arg_24_1.except_units then
				var_24_2 = not table.isInclude(arg_24_1.except_units, iter_24_1)
			end
			
			if var_24_2 and arg_24_1.synergy then
				var_24_2 = iter_24_1:getRole() == arg_24_1.synergy or iter_24_1:getCamp() == arg_24_1.synergy
			end
			
			if var_24_2 and arg_24_1.role then
				var_24_2 = iter_24_1:getRole() == arg_24_1.role
			end
			
			if var_24_2 and arg_24_1.camp then
				var_24_2 = iter_24_1:getCamp() == arg_24_1.camp
			end
			
			if var_24_2 then
				table.insert(var_24_1, iter_24_1)
			end
		end
		
		return var_24_1
	end
end

function RumbleBoard.update(arg_25_0, arg_25_1)
	if not arg_25_0.vars then
		return 
	end
	
	for iter_25_0, iter_25_1 in ipairs(arg_25_0.vars.units or {}) do
		iter_25_1:update(arg_25_1)
	end
end

function RumbleBoard.setPosition(arg_26_0, arg_26_1)
	if not arg_26_0.vars then
		return 
	end
	
	arg_26_0.vars.layer:setPosition(arg_26_1.x, arg_26_1.y)
end

function RumbleBoard.getPosition(arg_27_0)
	if not arg_27_0.vars then
		return 
	end
	
	return arg_27_0.vars.layer:getPosition()
end

function RumbleBoard.getMovableTiles(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.vars then
		return 
	end
	
	arg_28_2 = arg_28_2 or 1
	
	local var_28_0 = {}
	local var_28_1 = arg_28_0:getCircle(arg_28_1, arg_28_2)
	
	for iter_28_0, iter_28_1 in ipairs(var_28_1) do
		if arg_28_0:isMovableTile(iter_28_1.x, iter_28_1.y) then
			table.insert(var_28_0, iter_28_1)
		end
	end
	
	return var_28_0
end

function RumbleBoard.isMovableTile(arg_29_0, arg_29_1, arg_29_2)
	if not var_0_4[arg_29_2] or not var_0_4[arg_29_2][arg_29_1] or var_0_4[arg_29_2][arg_29_1] < 1 then
		return false
	end
	
	if arg_29_0:getUnitByPos(arg_29_1, arg_29_2) then
		return false
	end
	
	return true
end

function RumbleBoard.getCircle(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = arg_30_3 and {} or {
		{
			x = arg_30_1.x,
			y = arg_30_1.y
		}
	}
	
	for iter_30_0 = 1, arg_30_2 do
		if arg_30_3 then
			iter_30_0 = arg_30_2
		end
		
		for iter_30_1 = 1, iter_30_0 do
			table.insert(var_30_0, {
				x = arg_30_1.x + iter_30_0 - iter_30_1 * 2,
				y = arg_30_1.y + iter_30_0
			})
			table.insert(var_30_0, {
				x = arg_30_1.x - iter_30_0 + iter_30_1 * 2,
				y = arg_30_1.y - iter_30_0
			})
			table.insert(var_30_0, {
				x = arg_30_1.x + iter_30_0 + iter_30_1,
				y = arg_30_1.y - iter_30_0 + iter_30_1
			})
			table.insert(var_30_0, {
				x = arg_30_1.x - iter_30_0 - iter_30_1,
				y = arg_30_1.y + iter_30_0 - iter_30_1
			})
			table.insert(var_30_0, {
				x = arg_30_1.x - iter_30_0 * 2 + iter_30_1,
				y = arg_30_1.y - iter_30_1
			})
			table.insert(var_30_0, {
				x = arg_30_1.x + iter_30_0 * 2 - iter_30_1,
				y = arg_30_1.y + iter_30_1
			})
		end
	end
	
	return var_30_0
end

function RumbleBoard.getUnitsInArea(arg_31_0, arg_31_1)
	if not arg_31_0.vars then
		return 
	end
	
	local var_31_0 = {}
	
	for iter_31_0, iter_31_1 in pairs(arg_31_1 or {}) do
		local var_31_1 = arg_31_0:getUnitByPos(iter_31_1.x, iter_31_1.y)
		
		if var_31_1 then
			table.insert(var_31_0, var_31_1)
		end
	end
	
	return var_31_0
end

function RumbleBoard.getUnitByPos(arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0.vars then
		return 
	end
	
	for iter_32_0, iter_32_1 in ipairs(arg_32_0.vars.units) do
		if not iter_32_1:isDead() then
			local var_32_0 = iter_32_1:getPosition()
			
			if var_32_0.x == arg_32_1 and var_32_0.y == arg_32_2 then
				return iter_32_1
			end
		end
	end
end

function RumbleBoard.removeUnit(arg_33_0, arg_33_1)
	if not arg_33_0.vars then
		return 
	end
	
	for iter_33_0, iter_33_1 in ipairs(arg_33_0.vars.units) do
		if iter_33_1 == arg_33_1 then
			table.remove(arg_33_0.vars.units, iter_33_0)
			
			break
		end
	end
	
	arg_33_1:remove()
end

function RumbleBoard.showSynergyEffect(arg_34_0, arg_34_1)
	if not arg_34_0.vars then
		return 
	end
	
	arg_34_1 = arg_34_1 or arg_34_0.vars.selected_unit
	
	if not arg_34_1 then
		return 
	end
	
	for iter_34_0, iter_34_1 in pairs(arg_34_0.vars.units) do
		if iter_34_1:getCamp() == arg_34_1:getCamp() or iter_34_1:getRole() == arg_34_1:getRole() then
			iter_34_1:playSynergyEffect()
		end
	end
end

function RumbleBoard.removeSynergyEffect(arg_35_0)
	if not arg_35_0.vars then
		return 
	end
	
	for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.units) do
		iter_35_1:removeSynergyEffect()
	end
end

function RumbleBoard.showTiles(arg_36_0, arg_36_1, arg_36_2)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.tile_layer) then
		return 
	end
	
	if arg_36_0.vars.tile_flag == arg_36_1 then
		return 
	end
	
	arg_36_0.vars.tile_flag = arg_36_1
	
	if arg_36_1 then
		for iter_36_0, iter_36_1 in pairs(arg_36_0.vars.sprite_map) do
			for iter_36_2, iter_36_3 in pairs(iter_36_1) do
				if_set_visible(iter_36_3, nil, arg_36_0:isPlacablePos(iter_36_2, iter_36_0))
				if_set_visible(iter_36_3, "stay", arg_36_0:getUnitByPos(iter_36_2, iter_36_0))
				if_set_visible(iter_36_3, "add", not arg_36_0:getUnitByPos(iter_36_2, iter_36_0))
			end
		end
	end
	
	if arg_36_2 then
		arg_36_0.vars.tile_layer:setVisible(arg_36_1)
		
		return 
	end
	
	if arg_36_1 then
		arg_36_0.vars.tile_layer:setOpacity(0)
		UIAction:Add(SEQ(SHOW(true), LOG(FADE_IN(200))), arg_36_0.vars.tile_layer, "block")
	else
		arg_36_0.vars.tile_layer:setOpacity(255)
		UIAction:Add(SEQ(LOG(FADE_OUT(200)), SHOW(false)), arg_36_0.vars.tile_layer, "block")
	end
end

function RumbleBoard.setVisible(arg_37_0, arg_37_1)
	if not arg_37_0.vars then
		return 
	end
	
	if_set_visible(arg_37_0.vars.layer, nil, arg_37_1)
end

function RumbleBoard.getPlacablePos(arg_38_0, arg_38_1, arg_38_2)
	if arg_38_1 then
		if RumbleBoard:getUnitByPos(arg_38_1.x, arg_38_1.y) then
			for iter_38_0 = 1, 6 do
				local var_38_0 = RumbleBoard:getMovableTiles(arg_38_1, iter_38_0)
				
				if var_38_0 and not table.empty(var_38_0) then
					return var_38_0[RumbleSystem:getRandom(1, #var_38_0)]
				end
			end
		else
			return arg_38_1
		end
	else
		local var_38_1 = {}
		
		for iter_38_1 = 1, arg_38_0:getTileMapWidth() do
			for iter_38_2 = 1, arg_38_0:getTileMapHeight() do
				if RumbleBoard:isMovableTile(iter_38_1, iter_38_2) and (not arg_38_2 or var_0_4[iter_38_2] and var_0_4[iter_38_2][iter_38_1] == arg_38_2) then
					table.insert(var_38_1, {
						x = iter_38_1,
						y = iter_38_2
					})
				end
			end
		end
		
		if #var_38_1 == 0 then
			return 
		end
		
		return var_38_1[RumbleSystem:getRandom(1, #var_38_1)]
	end
end
