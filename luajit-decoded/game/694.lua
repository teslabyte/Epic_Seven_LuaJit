LotaPingRenderer = {}

function LotaPingRenderer.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.ping_layer = arg_1_1
	arg_1_0.vars.ping_sprite_data = {}
	arg_1_0.vars.y_gap = LotaWhiteboard:get("tile_y_gap")
	arg_1_0.vars.tile_width = LotaWhiteboard:get("tile_width")
	arg_1_0.vars.tile_height = LotaWhiteboard:get("tile_height")
	arg_1_0.vars.adj_x = 30
	arg_1_0.vars.adj_y = -50
	arg_1_0.vars.is_visible = true
end

function LotaPingRenderer.addPing(arg_2_0, arg_2_1)
	local var_2_0 = load_control("wnd/clan_heritage_mark.csb")
	
	arg_2_0.vars.ping_layer:addChild(var_2_0)
	
	arg_2_0.vars.ping_sprite_data[arg_2_1] = var_2_0
	
	if not arg_2_0.vars.use_on_minimap then
		arg_2_0:updateScale()
		if_set_visible(var_2_0, nil, arg_2_0.vars.is_visible)
	end
	
	return var_2_0
end

function LotaPingRenderer.iterUpdatePingOpacity(arg_3_0, arg_3_1)
	local var_3_0 = LotaPingSystem:getPingData(arg_3_1)
	local var_3_1 = tostring(arg_3_1)
	
	if not var_3_0 then
		return 
	end
	
	if not tostring(var_3_0:getFloor()) == tostring(LotaUserData:getFloor()) then
		return 
	end
	
	arg_3_0:updatePing(var_3_1, var_3_0)
	
	local var_3_2 = var_3_0:getPingNumber()
	local var_3_3 = arg_3_0.vars.ping_sprite_data[tostring(var_3_2)]
	local var_3_4 = var_3_0:getTileId()
	local var_3_5 = LotaTileMapSystem:getPosById(var_3_4)
	local var_3_6 = {
		{
			x = 1,
			y = 1
		},
		{
			x = 2,
			y = 0
		},
		{
			x = 1,
			y = -1
		}
	}
	local var_3_7 = false
	
	for iter_3_0, iter_3_1 in pairs(var_3_6) do
		local var_3_8 = LotaUtil:getAddedPosition(var_3_5, iter_3_1)
		local var_3_9 = LotaMovableSystem:getMovablesByPos(var_3_8)
		
		if table.count(var_3_9 or {}) > 0 then
			var_3_7 = true
			
			break
		end
	end
	
	local var_3_10 = "ping_action_fade_" .. tostring(var_3_2) .. "_"
	local var_3_11 = var_3_3:findChildByName("icon_tag")
	local var_3_12 = var_3_11:getOpacity() / 255
	
	if var_3_7 then
		if UIAction:Find(var_3_10 .. "in") then
			UIAction:Remove(var_3_10 .. "in")
		end
		
		if UIAction:Find(var_3_10 .. "out") or var_3_11:getOpacity() == 153 then
			return 
		end
		
		local var_3_13 = (var_3_12 - 0.6) * 2
		
		UIAction:Add(OPACITY(250 * var_3_13, var_3_12, 0.6), var_3_11, var_3_10 .. "out")
	else
		if UIAction:Find(var_3_10 .. "out") then
			UIAction:Remove(var_3_10 .. "out")
		end
		
		if UIAction:Find(var_3_10 .. "in") or var_3_11:getOpacity() == 255 then
			return 
		end
		
		local var_3_14 = (1 - var_3_12) * 2
		
		UIAction:Add(OPACITY(250 * var_3_14, var_3_12, 1), var_3_11, var_3_10 .. "in")
	end
end

function LotaPingRenderer.updatePingOpacity(arg_4_0)
	local var_4_0 = LotaPingSystem:getPingMaxCount()
	
	for iter_4_0 = 1, var_4_0 do
		arg_4_0:iterUpdatePingOpacity(iter_4_0)
	end
end

function LotaPingRenderer.updatePing(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.ping_layer) then
		return 
	end
	
	if not arg_5_0.vars.ping_sprite_data then
		return 
	end
	
	if not arg_5_2 then
		return 
	end
	
	if not arg_5_1 then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.ping_sprite_data[arg_5_1]
	
	if not get_cocos_refid(var_5_0) then
		var_5_0 = arg_5_0:addPing(arg_5_1)
	end
	
	if not var_5_0 then
		return 
	end
	
	local var_5_1 = arg_5_2:getTileId()
	local var_5_2 = LotaTileMapSystem:getPosById(var_5_1)
	local var_5_3 = arg_5_0.vars.tile_width
	local var_5_4 = arg_5_0.vars.tile_height
	local var_5_5 = arg_5_0.vars.y_gap
	local var_5_6 = var_5_2.x * (var_5_3 / 2)
	local var_5_7 = var_5_2.y * (var_5_4 / 2) - var_5_5
	
	var_5_0:setLocalZOrder(var_5_2.y * -5 + 3)
	var_5_0:setVisible(true)
	var_5_0:setOpacity(255)
	var_5_0:setPosition(var_5_6 + arg_5_0.vars.adj_x, var_5_7 + arg_5_0.vars.adj_y)
end

function LotaPingRenderer.removePing(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.ping_layer) then
		return 
	end
	
	if not arg_6_0.vars.ping_sprite_data then
		return 
	end
	
	if not arg_6_1 then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.ping_sprite_data[arg_6_1]
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	var_6_0:removeFromParent()
	
	arg_6_0.vars.ping_sprite_data[arg_6_1] = nil
end

function LotaPingRenderer.update(arg_7_0)
	local var_7_0 = LotaPingSystem:getPingMaxCount()
	
	for iter_7_0 = 1, var_7_0 do
		local var_7_1 = LotaPingSystem:getPingData(iter_7_0)
		local var_7_2 = tostring(iter_7_0)
		local var_7_3 = false
		
		if var_7_1 then
			var_7_3 = tostring(var_7_1:getFloor()) == tostring(LotaUserData:getFloor())
		end
		
		if var_7_1 and var_7_3 then
			arg_7_0:updatePing(var_7_2, var_7_1)
		elseif (not var_7_1 or not var_7_3) and arg_7_0.vars.ping_sprite_data[var_7_2] then
			arg_7_0:removePing(var_7_2)
		end
	end
end

function LotaPingRenderer.updateScale(arg_8_0)
	local var_8_0 = arg_8_0.vars.ping_sprite_data or {}
	
	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if not iter_8_1._origin_scale then
			iter_8_1._origin_scale = iter_8_1:getScale()
		end
		
		iter_8_1:setScale(iter_8_1._origin_scale / LotaCameraSystem:getScale())
	end
end

function LotaPingRenderer.setVisibleByTileId(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.vars.ping_sprite_data or {}
	
	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		local var_9_1 = LotaPingSystem:getPingData(iter_9_0)
		local var_9_2 = false
		
		if var_9_1 then
			var_9_2 = tostring(var_9_1:getFloor()) == tostring(LotaUserData:getFloor())
		end
		
		if var_9_2 and var_9_1:getTileId() == arg_9_1 and get_cocos_refid(iter_9_1) then
			if not arg_9_2 then
				if UIAction:Find(arg_9_1 .. "_out") then
					UIAction:Remove(arg_9_1 .. "_out")
				end
				
				iter_9_1:setOpacity(255)
				UIAction:Add(SEQ(OPACITY(100, 1, 0), SHOW(arg_9_2)), iter_9_1, arg_9_1 .. "_in")
			else
				if UIAction:Find(arg_9_1 .. "_in") then
					UIAction:Remove(arg_9_1 .. "_in")
				end
				
				iter_9_1:setOpacity(0)
				UIAction:Add(SEQ(SHOW(arg_9_2), OPACITY(100, 0, 1)), iter_9_1)
			end
		end
	end
end

function LotaPingRenderer.setVisible(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.vars.ping_sprite_data or {}
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		iter_10_1:setVisible(arg_10_1)
	end
	
	arg_10_0.vars.is_visible = arg_10_1
end
