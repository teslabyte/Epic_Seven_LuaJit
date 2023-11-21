SPLUtil = {}

function SPLUtil.calcTilePosToWorldPos(arg_1_0, arg_1_1)
	local var_1_0 = SPLWhiteboard:get("tile_width")
	local var_1_1 = SPLWhiteboard:get("tile_height")
	local var_1_2 = var_1_0 / 2
	local var_1_3 = var_1_1 / 2
	
	return {
		x = arg_1_1.x * var_1_2,
		y = var_1_3 * arg_1_1.y
	}
end

function SPLUtil.getMapMinMaxPos(arg_2_0)
	local var_2_0 = SPLWhiteboard:get("map_min_x")
	local var_2_1 = SPLWhiteboard:get("map_min_y")
	local var_2_2 = SPLWhiteboard:get("map_max_x")
	local var_2_3 = SPLWhiteboard:get("map_max_y")
	
	return {
		x = var_2_0,
		y = var_2_1
	}, {
		x = var_2_2,
		y = var_2_3
	}
end

function SPLUtil.getWorldMinMaxPos(arg_3_0)
	local var_3_0, var_3_1 = arg_3_0:getMapMinMaxPos()
	local var_3_2 = SPLUtil:calcTilePosToWorldPos(var_3_0)
	local var_3_3 = SPLUtil:calcTilePosToWorldPos(var_3_1)
	
	return var_3_2, var_3_3
end

function SPLUtil.getChildIdList(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_2 then
		return 
	end
	
	local var_4_0 = string.split(arg_4_2, ";")
	local var_4_1 = SPLTileMapSystem:getPosById(arg_4_1)
	local var_4_2 = {}
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		local var_4_3 = string.split(iter_4_1, ",")
		local var_4_4 = to_n(var_4_3[1])
		local var_4_5 = to_n(var_4_3[2])
		local var_4_6 = HTUtil:getAddedPosition(var_4_1, {
			x = var_4_4,
			y = var_4_5
		})
		local var_4_7 = SPLTileMapSystem:getTileIdByPos(var_4_6)
		
		table.insert(var_4_2, var_4_7)
	end
	
	return var_4_2
end

function SPLUtil.createChildIdListToObjectInfo(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	if arg_5_1.child_id and not table.empty(arg_5_1.child_id) then
		return 
	end
	
	local var_5_0 = arg_5_1.object_id
	local var_5_1 = DB("tile_sub_object_data", var_5_0, "add_select")
	
	if not var_5_1 then
		return 
	end
	
	arg_5_1.child_id = arg_5_0:getChildIdList(arg_5_1.tile_id, var_5_1)
end

function SPLUtil.isTileHaveAddSelect(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1:getTileId()
	local var_6_1 = SPLObjectSystem:getObject(var_6_0)
	
	if not var_6_1 then
		return false
	end
	
	return not table.empty(var_6_1:getChildTileList())
end

function SPLUtil.getDecedPosition(arg_7_0, arg_7_1, arg_7_2)
	return {
		x = arg_7_1.x - arg_7_2.x,
		y = arg_7_1.y - arg_7_2.y
	}
end

function SPLUtil.getAbsPosition(arg_8_0, arg_8_1)
	return {
		x = math.abs(arg_8_1.x),
		y = math.abs(arg_8_1.y)
	}
end

function SPLUtil.getTileCircle(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = {}
	
	arg_9_2 = arg_9_2 or 0
	
	local function var_9_1(arg_10_0, arg_10_1)
		local var_10_0 = SPLTileMapSystem:getTileByPos({
			x = arg_10_0,
			y = arg_10_1
		})
		
		if var_10_0 then
			table.insert(var_9_0, var_10_0)
		end
	end
	
	for iter_9_0 = 1, arg_9_2 do
		for iter_9_1 = 1, iter_9_0 do
			var_9_1(arg_9_1.x + iter_9_0 - iter_9_1 * 2, arg_9_1.y + iter_9_0)
			var_9_1(arg_9_1.x - iter_9_0 + iter_9_1 * 2, arg_9_1.y - iter_9_0)
			var_9_1(arg_9_1.x + iter_9_0 + iter_9_1, arg_9_1.y - iter_9_0 + iter_9_1)
			var_9_1(arg_9_1.x - iter_9_0 - iter_9_1, arg_9_1.y + iter_9_0 - iter_9_1)
			var_9_1(arg_9_1.x - iter_9_0 * 2 + iter_9_1, arg_9_1.y - iter_9_1)
			var_9_1(arg_9_1.x + iter_9_0 * 2 - iter_9_1, arg_9_1.y + iter_9_1)
		end
	end
	
	var_9_1(arg_9_1.x, arg_9_1.y)
	
	return var_9_0
end

function SPLUtil.getTileOutLine(arg_11_0, arg_11_1)
	local var_11_0 = {}
	
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		var_11_0[iter_11_1] = true
	end
	
	local var_11_1 = {}
	
	for iter_11_2, iter_11_3 in pairs(arg_11_1) do
		local var_11_2 = SPLTileMapSystem:getTileById(iter_11_3)
		
		if var_11_2 then
			local var_11_3 = SPLUtil:getTileCircle(var_11_2:getPos(), 1)
			
			for iter_11_4, iter_11_5 in pairs(var_11_3) do
				local var_11_4 = iter_11_5:getTileId()
				
				if not var_11_0[var_11_4] then
					var_11_1[var_11_4] = true
				end
			end
		end
	end
	
	local var_11_5 = {}
	
	for iter_11_6, iter_11_7 in pairs(var_11_1) do
		local var_11_6 = SPLTileMapSystem:getTileById(iter_11_6)
		
		table.insert(var_11_5, var_11_6)
	end
	
	return var_11_5
end

function SPLUtil.getTileIntersection(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_1) do
		for iter_12_2, iter_12_3 in pairs(arg_12_2) do
			if HTUtil:isSamePosition(iter_12_1:getPos(), iter_12_3:getPos()) then
				table.insert(var_12_0, iter_12_1)
			end
		end
	end
	
	return var_12_0
end

function SPLUtil.getNearestTile(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 or not arg_13_2 then
		return 
	end
	
	local var_13_0
	local var_13_1 = 999
	
	for iter_13_0, iter_13_1 in pairs(arg_13_2) do
		local var_13_2 = HTUtil:getTileCost(arg_13_1, iter_13_1:getPos())
		
		if var_13_2 < var_13_1 then
			var_13_1 = var_13_2
			var_13_0 = iter_13_1
		end
	end
	
	return var_13_0, var_13_1
end

function SPLUtil.getTileLine(arg_14_0, arg_14_1, arg_14_2)
	if HTUtil:isSamePosition(arg_14_1, arg_14_2) then
		return 
	end
	
	local var_14_0 = {}
	
	local function var_14_1(arg_15_0, arg_15_1)
		local var_15_0 = SPLTileMapSystem:getTileByPos({
			x = arg_15_0,
			y = arg_15_1
		})
		
		if var_15_0 then
			table.insert(var_14_0, var_15_0)
		end
	end
	
	local function var_14_2(arg_16_0)
		return math.round(arg_16_0 * 0.5) * 2
	end
	
	local function var_14_3(arg_17_0, arg_17_1, arg_17_2)
		if arg_17_0 == 0 then
			return 
		end
		
		local var_17_0 = arg_17_1 / arg_17_0
		local var_17_1 = arg_17_0 < 0 and -1 or 1
		
		for iter_17_0 = 0, arg_17_0, var_17_1 do
			local var_17_2 = iter_17_0 * var_17_0
			local var_17_3 = iter_17_0 % 2 == 0 and var_14_2(var_17_2) or var_14_2(var_17_2 - 1) + 1
			local var_17_4 = math.abs(var_17_3 - var_17_2)
			
			arg_17_2(iter_17_0, var_17_3, var_17_4)
		end
	end
	
	local var_14_4 = arg_14_2.x - arg_14_1.x
	local var_14_5 = arg_14_2.y - arg_14_1.y
	
	if math.abs(var_14_4) > math.abs(var_14_5) then
		if math.abs(var_14_5 / var_14_4) < 0.34 then
			var_14_3(var_14_4, var_14_5, function(arg_18_0, arg_18_1, arg_18_2)
				if arg_18_2 < 0.67 then
					var_14_1(arg_14_1.x + arg_18_0, arg_14_1.y + arg_18_1)
				end
			end)
		else
			var_14_3(var_14_4, var_14_5, function(arg_19_0, arg_19_1, arg_19_2)
				if arg_19_2 < 1 then
					var_14_1(arg_14_1.x + arg_19_0, arg_14_1.y + arg_19_1)
				end
			end)
		end
	else
		var_14_3(var_14_5, var_14_4, function(arg_20_0, arg_20_1)
			var_14_1(arg_14_1.x + arg_20_1, arg_14_1.y + arg_20_0)
		end)
	end
	
	return var_14_0
end

function SPLUtil.raycast(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = SPLUtil:getTileLine(arg_21_1, arg_21_2)
	
	if not var_21_0 then
		return 
	end
	
	for iter_21_0, iter_21_1 in ipairs(var_21_0) do
		if not HTUtil:isSamePosition(arg_21_1, iter_21_1:getPos()) then
			local var_21_1 = iter_21_1:getObjectId()
			
			if var_21_1 then
				return var_21_1
			end
		end
	end
end

function SPLUtil.getMapId(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = string.format("tile_%s_%02d", arg_22_1, arg_22_2)
	
	return DB("tile_sub", var_22_0, "map_id")
end

function SPLUtil.makeTextPopup(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = load_dlg("dungeon_heritage_easteregg", true, "wnd")
	
	if_set(var_23_0, "disc", arg_23_1)
	
	local var_23_1 = var_23_0:getChildByName("btn_close")
	
	if get_cocos_refid(var_23_1) then
		var_23_1.parent = var_23_0
		var_23_1.on_close = arg_23_2
		
		var_23_1:addTouchEventListener(function(arg_24_0, arg_24_1)
			if arg_24_1 ~= 2 then
				return 
			end
			
			if UIAction:Find("block") then
				return 
			end
			
			arg_24_0:setVisible(false)
			
			if get_cocos_refid(var_23_1.parent) then
				UIAction:Add(SEQ(FADE_OUT(200), CALL(function()
					if type(var_23_1.on_close) == "function" then
						var_23_1.on_close()
					end
				end), REMOVE()), var_23_1.parent, "block")
			end
		end)
	end
	
	var_23_0:setOpacity(0)
	UIAction:Add(FADE_IN(200), var_23_0, "block")
	
	return var_23_0
end

function SPLUtil.makeSystemAnnounce(arg_26_0, arg_26_1)
	local var_26_0 = load_dlg("caution_flash_3", true, "wnd")
	
	if_set_visible(var_26_0, "popnoti", false)
	
	local var_26_1 = var_26_0:getChildByName("popnoti_no_icon")
	
	if get_cocos_refid(var_26_1) then
		if_set(var_26_1, "txt", arg_26_1)
		if_set_visible(var_26_1, nil, true)
	end
	
	return var_26_0
end

function SPLUtil.makeCompleteDlg(arg_27_0, arg_27_1)
	local var_27_0 = load_dlg("msgbox_xbg", true, "wnd")
	
	if arg_27_1.bi then
		if_set_visible(var_27_0, "bi_info", true)
		
		local var_27_1 = var_27_0:getChildByName("n_story_bi")
		
		if get_cocos_refid(var_27_1) then
			local var_27_2 = SpriteCache:getSprite("banner/" .. arg_27_1.bi .. ".png")
			
			if get_cocos_refid(var_27_2) then
				var_27_1:addChild(var_27_2)
			end
		end
	elseif arg_27_1.text then
		if_set_visible(var_27_0, "normal_info", true)
		if_set(var_27_0, "txt_title", T(arg_27_1.text))
	end
	
	if false then
	end
	
	local var_27_3 = var_27_0:getChildByName("btn_close")
	
	if get_cocos_refid(var_27_3) then
		var_27_3.on_close = arg_27_1.on_close
		var_27_3.parent = var_27_0
		
		var_27_3:addTouchEventListener(function(arg_28_0, arg_28_1)
			if arg_28_1 ~= 2 then
				return 
			end
			
			if UIAction:Find("block") then
				return 
			end
			
			arg_28_0:setVisible(false)
			
			if get_cocos_refid(var_27_3.parent) then
				UIAction:Add(SEQ(FADE_OUT(400), CALL(function()
					if type(var_27_3.on_close) == "function" then
						var_27_3.on_close()
					end
				end), REMOVE()), var_27_3.parent, "block")
			end
		end)
	end
	
	return var_27_0
end

function SPLUtil.showCompleteDlg(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:makeCompleteDlg(arg_30_1)
	
	if not get_cocos_refid(var_30_0) then
		return 
	end
	
	local var_30_1 = {}
	
	var_30_0:setOpacity(0)
	table.insert(var_30_1, TARGET(var_30_0, FADE_IN(450)))
	
	if arg_30_1.text then
		local var_30_2 = var_30_0:getChildByName("normal_info")
		
		if get_cocos_refid(var_30_2) then
			local var_30_3 = var_30_2:getChildByName("txt_title")
			local var_30_4 = var_30_2:getChildByName("txt_desc")
			local var_30_5 = var_30_2:getChildByName("bar1_l")
			local var_30_6 = var_30_2:getChildByName("bar1_r")
			
			var_30_3:setOpacity(0)
			var_30_4:setOpacity(0)
			var_30_5:setOpacity(0)
			var_30_6:setOpacity(0)
			
			local var_30_7 = var_30_5:getContentSize()
			
			var_30_5:setContentSize(64, var_30_7.height)
			var_30_6:setContentSize(64, var_30_7.height)
			
			local var_30_8 = SEQ(DELAY(300), SPAWN(LOG(CONTENT_SIZE(700, var_30_7.width, var_30_7.height)), FADE_IN(500)))
			
			table.insert(var_30_1, TARGET(var_30_5, var_30_8))
			table.insert(var_30_1, TARGET(var_30_6, var_30_8))
			table.insert(var_30_1, TARGET(var_30_3, SEQ(DELAY(400), FADE_IN(500))))
			table.insert(var_30_1, TARGET(var_30_4, SEQ(DELAY(1200), FADE_IN(400))))
			if_set(var_30_2, "txt_desc", T("ui_dungeon_archieve_desc"))
		end
	elseif arg_30_1.bi then
		local var_30_9 = var_30_0:getChildByName("bi_info")
		
		if get_cocos_refid(var_30_9) then
			local var_30_10 = var_30_9:getChildByName("n_story_bi")
			local var_30_11 = var_30_9:getChildByName("txt_desc")
			
			var_30_10:setOpacity(0)
			var_30_11:setOpacity(0)
			table.insert(var_30_1, TARGET(var_30_10, SEQ(DELAY(200), FADE_IN(1000))))
			table.insert(var_30_1, TARGET(var_30_11, SEQ(DELAY(1200), FADE_IN(400))))
			if_set(var_30_9, "txt_desc", T("ui_dungeon_archieve_desc"))
		end
	end
	
	local var_30_12 = NONE()
	local var_30_13 = var_30_0:getChildByName("txt_close")
	
	if get_cocos_refid(var_30_13) then
		local var_30_14 = var_30_13:getOpacity() / 255
		
		var_30_13:setOpacity(0)
		
		var_30_12 = TARGET(var_30_13, OPACITY(400, 0, var_30_14))
	end
	
	UIAction:Add(SEQ(SPAWN(table.unpack(var_30_1)), DELAY(400), var_30_12), var_30_0, "block")
	
	return var_30_0
end

function SPLUtil.makeInteractButton(arg_31_0)
	local var_31_0 = load_dlg("clan_heritage_select_menu", true, "wnd"):getChildByName("btn_open")
	
	var_31_0:ejectFromParent()
	if_set_visible(var_31_0, "icon", true)
	
	local var_31_1 = var_31_0:getChildByName("n_item")
	local var_31_2 = var_31_0:getChildByName("n_count")
	
	if get_cocos_refid(var_31_1) then
		var_31_1:removeFromParent()
	end
	
	if get_cocos_refid(var_31_2) then
		var_31_2:removeFromParent()
	end
	
	return var_31_0
end
