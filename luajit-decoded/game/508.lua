CustomProfileCard = {}

function CustomProfileCard.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	
	local var_1_0
	local var_1_1 = copy_functions(CustomProfileCard, var_1_0)
	
	var_1_1.vars = {}
	var_1_1.vars.wnd = load_dlg("profile_custom_unit_editing", true, "wnd")
	
	if_set_visible(var_1_1.vars.wnd, "n_edit_on", true)
	
	if get_cocos_refid(var_1_1.vars.wnd) then
		var_1_1.vars.wnd:setAnchorPoint(0, 0)
		var_1_1.vars.wnd:setPosition(0, 0)
	end
	
	var_1_1.vars.layers = {}
	var_1_1.vars.is_edit_mode = arg_1_1.is_edit_mode
	var_1_1.vars.is_capture = arg_1_1.is_capture
	
	if_set_visible(var_1_1.vars.wnd, "n_dim", not var_1_1.vars.is_edit_mode)
	if_set_visible(var_1_1.vars.wnd, "n_edit_back", var_1_1.vars.is_edit_mode)
	if_set_visible(var_1_1.vars.wnd, "n_edit_off", var_1_1.vars.is_edit_mode)
	
	local var_1_2 = var_1_1.vars.wnd:getChildByName("n_edit_off")
	
	if var_1_1.vars.is_edit_mode and get_cocos_refid(var_1_2) then
		local var_1_3 = cc.Node:create()
		
		var_1_3:setName("n_select_boxes")
		var_1_3:setAnchorPoint(0, 0)
		var_1_2:addChild(var_1_3)
		
		local var_1_4 = cc.Node:create()
		
		var_1_4:setName("n_edit_boxes")
		var_1_4:setAnchorPoint(0, 0)
		var_1_2:addChild(var_1_4)
	end
	
	if arg_1_1.is_new then
		return var_1_1
	end
	
	if arg_1_1.is_default and arg_1_1.leader_code and arg_1_1.face_id then
		var_1_1:drawDefaultCard(arg_1_1.leader_code, arg_1_1.face_id)
	elseif arg_1_1.card_data then
		var_1_1:load(arg_1_1.card_data)
	else
		return nil
	end
	
	if var_1_1.vars.is_capture then
		local var_1_5 = capture_node(var_1_1.vars.wnd, 37)
		
		var_1_5:getSprite():setAnchorPoint(0, 0)
		var_1_5:setCascadeOpacityEnabled(true)
		
		var_1_1.vars.wnd = var_1_5
	end
	
	return var_1_1
end

function CustomProfileCard.delete(arg_2_0)
	if not get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	for iter_2_0, iter_2_1 in pairs(arg_2_0.vars.layers) do
		iter_2_1:delete()
	end
	
	arg_2_0.layers = nil
	
	arg_2_0.vars.wnd:removeFromParent()
	
	arg_2_0.vars.wnd = nil
	arg_2_0 = nil
end

function CustomProfileCard.getWnd(arg_3_0)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.wnd) then
		return nil
	end
	
	return arg_3_0.vars.wnd
end

function CustomProfileCard.exportCloneData(arg_4_0)
	if not arg_4_0.layers then
		return 
	end
	
	return {
		layers = table.clone(arg_4_0.layers)
	}
end

function CustomProfileCard.load(arg_5_0, arg_5_1)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	local var_5_0 = json.decode(arg_5_1)
	
	for iter_5_0, iter_5_1 in pairs(var_5_0.layers) do
		arg_5_0:createLayer({
			load_data = iter_5_1
		}, true)
	end
end

function CustomProfileCard.save(arg_6_0)
	if not arg_6_0.vars or not arg_6_0.vars.layers then
		return 
	end
	
	local var_6_0 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.vars.layers) do
		local var_6_1 = iter_6_1:save()
		
		table.insert(var_6_0, var_6_1)
	end
	
	return (json.encode({
		layers = var_6_0
	}))
end

function CustomProfileCard.createLayer(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) or not arg_7_0.vars.layers then
		return 
	end
	
	arg_7_1 = arg_7_1 or {}
	
	local var_7_0 = arg_7_1.layer or nil
	local var_7_1 = arg_7_1.type or arg_7_0:convertNumberToType(arg_7_1.load_data[1])
	
	if (var_7_1 == "text" or var_7_1 == "shape") and ContentDisable:byAlias("profile_card_" .. var_7_1) then
		return 
	end
	
	var_7_0 = var_7_0 or copy_functions(CustomProfileCard[var_7_1], var_7_0)
	arg_7_1.parent = arg_7_0
	arg_7_1.is_edit_mode = arg_7_0.vars.is_edit_mode
	arg_7_1.is_capture = arg_7_0.vars.is_capture
	arg_7_1.order = arg_7_1.order or arg_7_0:getLayerCount() + 1
	
	if var_7_0 then
		var_7_0:create(arg_7_1)
		
		local var_7_2 = var_7_0:getOrder()
		
		table.insert(arg_7_0.vars.layers, var_7_2, var_7_0)
		
		if not arg_7_2 then
			local var_7_3 = {
				order = var_7_2,
				type = var_7_0:getType()
			}
			local var_7_4 = {
				load_data = var_7_0:save(),
				layer = var_7_0
			}
			
			CustomProfileCardEditor:getLayerCommand():pushUndo({
				undo_func = bind_func(arg_7_0.deleteLayer, arg_7_0, var_7_3, true),
				redo_func = bind_func(arg_7_0.createLayer, arg_7_0, var_7_4, true)
			}, true)
		else
			for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.layers) do
				iter_7_1:setOrder(iter_7_0)
			end
		end
		
		CustomProfileCardEditor:setFocusLayer(var_7_0)
		CustomProfileCardEditor:updateBottom(arg_7_1.type)
		CustomProfileCardEditor:updateLayerView()
	end
end

function CustomProfileCard.deleteLayer(arg_8_0, arg_8_1, arg_8_2)
	if table.empty(arg_8_0.vars.layers) then
		return 
	end
	
	arg_8_1 = arg_8_1 or {}
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.layers) do
		local var_8_0 = iter_8_1:getOrder()
		local var_8_1 = iter_8_1:getType()
		
		if var_8_0 and var_8_0 == arg_8_1.order and var_8_1 and var_8_1 == arg_8_1.type then
			local var_8_2 = table.remove(arg_8_0.vars.layers, iter_8_0)
			
			if not arg_8_2 then
				local var_8_3 = {
					load_data = var_8_2:save(),
					layer = var_8_2,
					order = var_8_0
				}
				local var_8_4 = {
					order = var_8_2:getOrder(),
					type = var_8_2:getType()
				}
				
				CustomProfileCardEditor:getLayerCommand():pushUndo({
					undo_func = bind_func(arg_8_0.createLayer, arg_8_0, var_8_3, true),
					redo_func = bind_func(arg_8_0.deleteLayer, arg_8_0, var_8_4, true)
				}, true)
			end
			
			iter_8_1:delete()
			CustomProfileCardEditor:setFocusLayer(nil)
			CustomProfileCardEditor:updateBottom(arg_8_1.type)
			CustomProfileCardEditor:updateLayerView()
		end
	end
	
	for iter_8_2 = arg_8_1.order, table.count(arg_8_0.vars.layers) do
		arg_8_0.vars.layers[iter_8_2]:setOrder(iter_8_2)
	end
end

function CustomProfileCard.setLayerOrder(arg_9_0, arg_9_1)
	if table.empty(arg_9_0.vars.layers) then
		return 
	end
	
	if not arg_9_1 or not arg_9_1.layer or not arg_9_1.order or not arg_9_1.from then
		return 
	end
	
	local var_9_0
	
	if arg_9_1.from == "move_first" then
		var_9_0 = table.count(arg_9_0.vars.layers)
	elseif arg_9_1.from == "move_last" then
		var_9_0 = 1
	end
	
	table.remove(arg_9_0.vars.layers, var_9_0)
	table.insert(arg_9_0.vars.layers, arg_9_1.order, arg_9_1.layer)
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.layers) do
		iter_9_1:setOrder(iter_9_0)
	end
	
	CustomProfileCardEditor:updateLayerView()
end

function CustomProfileCard.moveFirstLayer(arg_10_0, arg_10_1, arg_10_2)
	if table.empty(arg_10_0.vars.layers) or not arg_10_1 then
		return 
	end
	
	local var_10_0 = table.count(arg_10_0.vars.layers)
	local var_10_1 = arg_10_1:getOrder()
	
	if var_10_0 <= var_10_1 then
		return 
	end
	
	if not arg_10_2 then
		local var_10_2 = {
			from = "move_first",
			layer = arg_10_1,
			order = var_10_1
		}
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_10_1,
			undo_func = bind_func(arg_10_0.setLayerOrder, arg_10_0, var_10_2),
			redo_func = bind_func(arg_10_0.moveFirstLayer, arg_10_0, arg_10_1, true)
		}, true)
	end
	
	table.remove(arg_10_0.vars.layers, var_10_1)
	table.insert(arg_10_0.vars.layers, arg_10_1)
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.layers) do
		iter_10_1:setOrder(iter_10_0)
	end
	
	CustomProfileCardEditor:updateLayerView()
end

function CustomProfileCard.moveFrontLayer(arg_11_0, arg_11_1, arg_11_2)
	if table.empty(arg_11_0.vars.layers) or not arg_11_1 then
		return 
	end
	
	local var_11_0 = table.count(arg_11_0.vars.layers)
	local var_11_1 = arg_11_1:getOrder()
	
	if var_11_0 <= var_11_1 then
		return 
	end
	
	if not arg_11_2 then
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_11_1,
			undo_func = bind_func(arg_11_0.moveBackLayer, arg_11_0, arg_11_1, true),
			redo_func = bind_func(arg_11_0.moveFrontLayer, arg_11_0, arg_11_1, true)
		}, true)
	end
	
	arg_11_0.vars.layers[var_11_1] = arg_11_0.vars.layers[var_11_1 + 1]
	arg_11_0.vars.layers[var_11_1 + 1] = arg_11_1
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.layers) do
		iter_11_1:setOrder(iter_11_0)
	end
	
	CustomProfileCardEditor:updateLayerView()
end

function CustomProfileCard.moveBackLayer(arg_12_0, arg_12_1, arg_12_2)
	if table.empty(arg_12_0.vars.layers) or not arg_12_1 then
		return 
	end
	
	local var_12_0 = arg_12_1:getOrder()
	
	if var_12_0 <= 1 then
		return 
	end
	
	if not arg_12_2 then
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_12_1,
			undo_func = bind_func(arg_12_0.moveFrontLayer, arg_12_0, arg_12_1, true),
			redo_func = bind_func(arg_12_0.moveBackLayer, arg_12_0, arg_12_1, true)
		}, true)
	end
	
	arg_12_0.vars.layers[var_12_0] = arg_12_0.vars.layers[var_12_0 - 1]
	arg_12_0.vars.layers[var_12_0 - 1] = arg_12_1
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.layers) do
		iter_12_1:setOrder(iter_12_0)
	end
	
	CustomProfileCardEditor:updateLayerView()
end

function CustomProfileCard.moveLastLayer(arg_13_0, arg_13_1, arg_13_2)
	if table.empty(arg_13_0.vars.layers) or not arg_13_1 then
		return 
	end
	
	local var_13_0 = arg_13_1:getOrder()
	
	if var_13_0 <= 1 then
		return 
	end
	
	if not arg_13_2 then
		local var_13_1 = {
			from = "move_last",
			layer = arg_13_1,
			order = var_13_0
		}
		
		CustomProfileCardEditor:getLayerCommand():pushUndo({
			layer = arg_13_1,
			undo_func = bind_func(arg_13_0.setLayerOrder, arg_13_0, var_13_1),
			redo_func = bind_func(arg_13_0.moveLastLayer, arg_13_0, arg_13_1, true)
		}, true)
	end
	
	table.remove(arg_13_0.vars.layers, var_13_0)
	table.insert(arg_13_0.vars.layers, 1, arg_13_1)
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.layers) do
		iter_13_1:setOrder(iter_13_0)
	end
	
	CustomProfileCardEditor:updateLayerView()
end

function CustomProfileCard.checkDuplicationLayer(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) or table.empty(arg_14_0.vars.layers) then
		return false
	end
	
	if not arg_14_1 or arg_14_1 == "text" or not arg_14_2 then
		return false
	end
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.layers) do
		local var_14_0 = iter_14_1:getType()
		
		if var_14_0 ~= "text" then
			local var_14_1 = iter_14_1:getId()
			
			if arg_14_1 == "hero" and string.find(var_14_1, "_s%d") then
				local var_14_2 = string.find(var_14_1, "_s%d")
				
				var_14_1 = string.sub(var_14_1, 1, var_14_2 - 1)
			end
			
			if var_14_0 and var_14_0 == arg_14_1 and arg_14_2 and (var_14_1 == arg_14_2 or is_mer_series(var_14_1) and is_mer_series(arg_14_2)) then
				return true
			end
		end
	end
	
	return false
end

function CustomProfileCard.getTypeLayers(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) or table.empty(arg_15_0.vars.layers) or not arg_15_1 then
		return nil
	end
	
	local var_15_0 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.layers) do
		local var_15_1 = iter_15_1:getType()
		
		if var_15_1 and var_15_1 == arg_15_1 then
			table.insert(var_15_0, iter_15_1)
		end
	end
	
	return var_15_0
end

function CustomProfileCard.getLayer(arg_16_0, arg_16_1, arg_16_2)
	if table.empty(arg_16_0.vars.layers) then
		return 
	end
	
	if not arg_16_1 and arg_16_2(arg_16_1) ~= "number" then
		return 
	end
	
	if not arg_16_2 and arg_16_2(arg_16_2) ~= "string" then
		return 
	end
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.layers) do
		local var_16_0 = iter_16_1:getOrder()
		local var_16_1 = iter_16_1:getType()
		
		if var_16_0 and var_16_0 == arg_16_1 and var_16_1 and var_16_1 == arg_16_2 then
			return iter_16_1
		end
	end
end

function CustomProfileCard.getLayers(arg_17_0)
	return arg_17_0.vars.layers or {}
end

function CustomProfileCard.getLayerCount(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) or table.empty(arg_18_0.vars.layers) then
		return 0
	end
	
	return table.count(arg_18_0.vars.layers)
end

function CustomProfileCard.checkInvalidLayerType(arg_19_0, arg_19_1)
	return table.isInclude({
		"hero",
		"bg",
		"badge",
		"shape",
		"text"
	}, arg_19_1)
end

function CustomProfileCard.convertNumberToType(arg_20_0, arg_20_1)
	if arg_20_1 == 1 then
		return "hero"
	elseif arg_20_1 == 2 then
		return "bg"
	elseif arg_20_1 == 3 then
		return "badge"
	elseif arg_20_1 == 4 then
		return "shape"
	elseif arg_20_1 == 5 then
		return "text"
	end
	
	return nil
end

function CustomProfileCard.convertTypeToNumber(arg_21_0, arg_21_1)
	if arg_21_1 == "hero" then
		return 1
	elseif arg_21_1 == "bg" then
		return 2
	elseif arg_21_1 == "badge" then
		return 3
	elseif arg_21_1 == "shape" then
		return 4
	elseif arg_21_1 == "text" then
		return 5
	end
	
	return nil
end

function CustomProfileCard.convertNumberToBoolen(arg_22_0, arg_22_1)
	if arg_22_1 == 0 then
		return false
	elseif arg_22_1 == 1 then
		return true
	end
	
	return false
end

function CustomProfileCard.convertBoolenToNumber(arg_23_0, arg_23_1)
	if arg_23_1 then
		return 1
	else
		return 0
	end
	
	return 0
end

function CustomProfileCard.createParentLayerNode(arg_24_0, arg_24_1)
	if not arg_24_0:checkInvalidLayerType(arg_24_1) then
		return nil
	end
	
	local var_24_0 = cc.Node:create()
	
	var_24_0:setName("layer_" .. arg_24_1)
	var_24_0:setCascadeOpacityEnabled(true)
	
	if arg_24_1 == "hero" then
		var_24_0:setPositionX(192)
		var_24_0:setPositionY(425)
	elseif arg_24_1 == "bg" then
		var_24_0:setPositionX(189)
		var_24_0:setPositionY(0)
	elseif arg_24_1 == "shape" or arg_24_1 == "text" or arg_24_1 == "badge" then
		var_24_0:setPositionX(192)
		var_24_0:setPositionY(282)
	end
	
	return var_24_0
end

function CustomProfileCard.drawDefaultCard(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) or not arg_25_0.vars.layers then
		return 
	end
	
	if not arg_25_1 and not arg_25_2 then
		return 
	end
	
	arg_25_0:createLayer({
		id = "a13",
		is_illust = false,
		type = "bg"
	})
	arg_25_0:createLayer({
		is_sd = false,
		type = "hero",
		id = arg_25_1,
		face_id = arg_25_2
	})
end

function CustomProfileCard.test(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) or not arg_26_0.vars.layers then
		return 
	end
	
	arg_26_0:createLayer({
		id = "a01",
		is_illust = false,
		type = "bg"
	})
	arg_26_0:createLayer({
		id = "a02",
		is_illust = false,
		type = "bg"
	})
	arg_26_0:createLayer({
		id = "a03",
		is_illust = false,
		type = "bg"
	})
	arg_26_0:createLayer({
		id = "a04",
		is_illust = false,
		type = "bg"
	})
	
	for iter_26_0 = 1, 15 do
		arg_26_0:createLayer({
			is_illust = true,
			type = "bg",
			id = "episode_1_" .. tostring(iter_26_0)
		})
	end
	
	arg_26_0:createLayer({
		is_sd = false,
		face_id = 0,
		type = "hero",
		id = "c1119",
		is_flip = false
	})
	arg_26_0:createLayer({
		is_sd = false,
		face_id = 0,
		type = "hero",
		id = "c1017",
		is_flip = false
	})
	arg_26_0:createLayer({
		is_sd = false,
		face_id = 0,
		type = "hero",
		id = "c1020",
		is_flip = false
	})
	arg_26_0:createLayer({
		is_sd = false,
		face_id = 0,
		type = "hero",
		id = "c2031",
		is_flip = false
	})
	arg_26_0:createLayer({
		is_sd = false,
		face_id = 0,
		type = "hero",
		id = "c2033",
		is_flip = false
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~1",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~2",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~3",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~4",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~5",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~6",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~7",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~8",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~9",
		type = "text"
	})
	arg_26_0:createLayer({
		text = "빨리 퇴근하자~10",
		type = "text"
	})
	
	for iter_26_1 = 1, 61 do
		arg_26_0:createLayer({
			id = "a21",
			type = "shape"
		})
	end
	
	arg_26_0:createLayer({
		id = "ma_badge_rank70",
		type = "badge"
	})
	arg_26_0:createLayer({
		id = "ma_badge_a_fame",
		type = "badge"
	})
	arg_26_0:createLayer({
		id = "ma_badge_a_legend",
		type = "badge"
	})
	arg_26_0:createLayer({
		id = "ma_badge_accumu_a_a",
		type = "badge"
	})
	arg_26_0:createLayer({
		id = "ma_badge_accumu_a_s",
		type = "badge"
	})
end
