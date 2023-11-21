TLCharacterRenderer = {}

function TLCharacterRenderer.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.field_layer = arg_1_1
	arg_1_0.vars.main_char_id = arg_1_2
	
	arg_1_0:createCharacter()
end

function TLCharacterRenderer.setMainCharID(arg_2_0, arg_2_1)
	arg_2_0.vars.main_char_id = arg_2_1
end

function TLCharacterRenderer.isActive(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_3_0.vars.field_layer) then
		return 
	end
	
	return true
end

function TLCharacterRenderer.getCharDataList(arg_4_0)
	return arg_4_0.vars.char_data_list
end

function TLCharacterRenderer.getCharSpriteList(arg_5_0)
	return arg_5_0.vars.char_sprite_list
end

function TLCharacterRenderer.createCharacter(arg_6_0)
	arg_6_0.vars.char_data_list = {}
	arg_6_0.vars.char_sprite_list = {}
	
	local var_6_0 = arg_6_0.vars.field_layer:findChildByName("@field_game_layer")
	
	arg_6_0.vars.field_game_layer = var_6_0
	
	local var_6_1 = arg_6_0.vars.field_game_layer:getChildren()
	
	if not arg_6_0.vars.main_char_id then
		return 
	end
	
	for iter_6_0 = 1, 99 do
		local var_6_2 = TLDatabase:getRenderCharData(arg_6_0.vars.main_char_id, iter_6_0)
		
		if var_6_2 then
			if not arg_6_0:updateCharData(nil, var_6_2) then
				print("TLCharacterRenderer.createCharacter: target_layer is nil.")
			end
		else
			break
		end
	end
end

function TLCharacterRenderer.addToLayerCharSprite(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.pet_id
	local var_7_1
	
	if var_7_0 then
		local var_7_2, var_7_3, var_7_4, var_7_5 = DB("pet_character", var_7_0, {
			"type",
			"model_1",
			"model_3",
			"model_5"
		})
		local var_7_6 = var_7_5 or var_7_4
		
		if not var_7_6 then
			return nil, "no_model_id", var_7_6
		end
		
		var_7_1 = CACHE:getModel(var_7_5 or var_7_4)
	else
		local var_7_7 = arg_7_1.character_skin or arg_7_1.character_id
		local var_7_8 = UNIT:create({
			code = var_7_7
		})
		
		if not var_7_8 then
			return nil, "no_model_id", var_7_7
		end
		
		var_7_8.db.model_ani = arg_7_1.ani
		var_7_1 = CACHE:getModel(var_7_8.db)
	end
	
	local var_7_9 = arg_7_0.vars.field_game_layer:getChildren()
	local var_7_10 = arg_7_1.target_layer
	local var_7_11
	
	if var_7_10 == 0 then
		var_7_11 = arg_7_0.vars.field_game_layer:findChildByName("FieldFloorLayer")
	else
		var_7_11 = var_7_9[var_7_10]
	end
	
	if not var_7_11 then
		return nil, "no_target_layer", var_7_11
	end
	
	var_7_11:addChild(var_7_1)
	
	return var_7_1
end

function TLCharacterRenderer.removeCharDataLast(arg_8_0)
	local var_8_0 = table.remove(arg_8_0.vars.char_data_list)
	local var_8_1 = table.remove(arg_8_0.vars.char_sprite_list)
	
	if not var_8_1 or not get_cocos_refid(var_8_1) then
		return 
	end
	
	var_8_1:cleanupReferencedObject()
	var_8_1:removeFromParent()
end

function TLCharacterRenderer.removeCharData(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	if not arg_9_0.vars.char_data_list[arg_9_1] then
		return 
	end
	
	table.remove(arg_9_0.vars.char_data_list, arg_9_1)
	
	local var_9_0 = arg_9_0.vars.char_sprite_list[arg_9_1]
	
	if not var_9_0 or not get_cocos_refid(var_9_0) then
		return 
	end
	
	var_9_0:cleanupReferencedObject()
	var_9_0:removeFromParent()
	table.remove(arg_9_0.vars.char_sprite_list, arg_9_1)
end

function TLCharacterRenderer.updateCharData(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = true
	
	if not arg_10_1 or not arg_10_0.vars.char_data_list[arg_10_1] then
		var_10_0 = false
	end
	
	local var_10_1
	local var_10_2
	
	if arg_10_1 then
		var_10_1 = arg_10_0.vars.char_data_list[arg_10_1]
		var_10_2 = arg_10_0.vars.char_sprite_list[arg_10_1]
	end
	
	if not var_10_1 or var_10_1.character_id ~= arg_10_2.character_id or var_10_1.character_skin ~= arg_10_2.character_skin or var_10_1.pet_id ~= arg_10_2.pet_id or var_10_1.target_layer ~= arg_10_2.target_layer then
		local var_10_3, var_10_4, var_10_5 = arg_10_0:addToLayerCharSprite(arg_10_2)
		
		if not var_10_3 then
			return false, var_10_4, var_10_5
		end
		
		if get_cocos_refid(var_10_2) then
			var_10_2:cleanupReferencedObject()
			var_10_2:removeFromParent()
		end
		
		var_10_2 = var_10_3
	end
	
	if var_10_2 then
		var_10_2:setPosition(arg_10_2.x, arg_10_2.y)
		var_10_2:setScale(arg_10_2.scale)
		
		if arg_10_2.flip == "y" then
			var_10_2:setScaleX(-arg_10_2.scale)
		end
		
		local var_10_6 = cc.c3b(arg_10_2.r, arg_10_2.g, arg_10_2.b)
		
		var_10_2:setColor(var_10_6)
		
		if arg_10_2.ani then
			var_10_2:setAnimation(0, arg_10_2.ani, true)
		end
	else
		print("err : not exist sprite. check.")
		table.print(arg_10_2)
	end
	
	if var_10_0 then
		arg_10_0.vars.char_data_list[arg_10_1] = arg_10_2
		arg_10_0.vars.char_sprite_list[arg_10_1] = var_10_2
	else
		table.insert(arg_10_0.vars.char_data_list, arg_10_2)
		table.insert(arg_10_0.vars.char_sprite_list, var_10_2)
	end
	
	return true
end

function TLCharacterRenderer.addCharData(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.field_layer) then
		return 
	end
	
	arg_11_0:updateCharData(nil, arg_11_1)
end

function TLCharacterRenderer.clearCharDataList(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.field_layer) then
		return 
	end
	
	local var_12_0 = #arg_12_0.vars.char_data_list
	
	for iter_12_0 = 1, var_12_0 do
		arg_12_0:removeCharDataLast()
	end
	
	arg_12_0.vars.char_data_list = {}
	arg_12_0.vars.char_sprite_list = {}
end

function TLCharacterRenderer.setCharDataList(arg_13_0, arg_13_1)
	if not arg_13_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_13_0.vars.field_layer) then
		return 
	end
	
	arg_13_0:clearCharDataList()
	
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		arg_13_0:updateCharData(nil, iter_13_1)
	end
end
