ROAD_SECTOR_WIDTH = 1500
BGI = {}
BGIManager = {}

function BGIManager.removeBGI(arg_1_0, arg_1_1)
	if not arg_1_0.bgi then
		arg_1_0.bgi = {}
	end
	
	arg_1_0.bgi[arg_1_1] = nil
	
	if arg_1_0.current_mode == arg_1_1 then
		arg_1_0.current_mode = nil
	end
end

function BGIManager.setCurrentMode(arg_2_0, arg_2_1)
	arg_2_0.current_mode = arg_2_1
end

function BGIManager.setBGI(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0.bgi then
		arg_3_0.bgi = {}
	end
	
	arg_3_0.bgi[arg_3_1] = arg_3_2
	arg_3_0.current_mode = arg_3_1
end

function BGIManager.getBGI(arg_4_0)
	if not arg_4_0.bgi or not arg_4_0.current_mode or not arg_4_0.bgi[arg_4_0.current_mode] or not get_cocos_refid(arg_4_0.bgi[arg_4_0.current_mode].game_layer) then
		return BGI
	end
	
	return arg_4_0.bgi[arg_4_0.current_mode]
end

BattleField = {}

function _onBgTouchDown(arg_5_0, arg_5_1)
	DEBUG.PUSHED = true
	
	local var_5_0, var_5_1 = CameraManager:getOffset()
	
	DEBUG.START_TOUCH_X = arg_5_0 + var_5_0
	DEBUG.START_TOUCH_Y = arg_5_1 + var_5_1
	
	return DEBUG.MAP_TEST
end

function _onBgTouchUp(arg_6_0, arg_6_1)
	DEBUG.PUSHED = false
	
	return DEBUG.MAP_TEST
end

function _onBgMouseScrollDown(arg_7_0)
	if not DEBUG.MAP_TEST_CAMERA then
		return 
	end
	
	local var_7_0 = (DEBUG.MAP_TEST_CAMERA:getScale() or 1) + arg_7_0 * 0.05
	local var_7_1 = math.min(3, math.max(0.1, var_7_0))
	
	DEBUG.MAP_TEST_CAMERA:setScale(var_7_1)
end

function _onBgTouchMove(arg_8_0, arg_8_1)
	if DEBUG.MAP_TEST and DEBUG.START_TOUCH_X and DEBUG.START_TOUCH_Y then
		CameraManager:setOffset(DEBUG.START_TOUCH_X - arg_8_0, DEBUG.START_TOUCH_Y - arg_8_1)
		
		return true
	elseif DEBUG.MAP_TEST_CAMERA then
		DEBUG.MAP_TEST_CAMERA = nil
		
		CameraManager:resetDefault()
		
		return true
	end
end

function onKeyDown(arg_9_0, arg_9_1)
	print("Key:" .. arg_9_1)
	
	if arg_9_1 == 18 or arg_9_1 == 31 then
		local var_9_0 = BGI.main.layer:getScale() + 0.2
		
		if var_9_0 >= 1.9 then
			var_9_0 = 1
		end
		
		BGI:setScale(var_9_0)
	end
end

local function var_0_0(arg_10_0)
	if arg_10_0 == "up" or arg_10_0 == "down" then
		return "up"
	end
	
	return "left"
end

local function var_0_1(arg_11_0)
	if arg_11_0 == "up" or arg_11_0 == "down" then
		return "down"
	end
	
	return "right"
end

function BattleField.create(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or "battle"
	
	arg_12_0:init(arg_12_1)
	
	return arg_12_0.root_layer
end

function BattleField.getBackup(arg_13_0, arg_13_1)
	return get_state_back_up_from_table(arg_13_0, arg_13_1)
end

function BattleField.restoreFromBackup(arg_14_0, arg_14_1)
	restore_state_from_backup_from_table(arg_14_0, arg_14_1)
	BattleLayout:restoreFromBackup(arg_14_1)
	CameraManager:restoreFromBackup(arg_14_1)
end

function BattleField.setBackup(arg_15_0, arg_15_1)
	set_state_backup_from_table(arg_15_0, arg_15_1)
	BattleLayout:setBackup(arg_15_1)
	CameraManager:setBackup(arg_15_1)
end

function BattleField.init(arg_16_0, arg_16_1)
	arg_16_1 = arg_16_1 or "battle"
	
	if arg_16_0.mode == arg_16_1 and get_cocos_refid(arg_16_0.root_layer) then
		return 
	end
	
	if arg_16_0:getBackup(arg_16_1) then
		if get_cocos_refid(arg_16_0.root_layer) then
			arg_16_0.root_layer:removeFromParent()
		end
		
		arg_16_0:restoreFromBackup(arg_16_1)
		
		return 
	end
	
	if arg_16_0.mode ~= nil and arg_16_0.mode ~= arg_16_1 then
		arg_16_0:setBackup(arg_16_0.mode)
	end
	
	arg_16_0.vars = {}
	arg_16_0.root_layer = cc.Layer:create()
	arg_16_0.ui_layer = cc.Layer:create()
	
	arg_16_0.ui_layer:setLocalZOrder(999)
	arg_16_0.root_layer:addChild(arg_16_0.ui_layer)
	
	arg_16_0.cutin_layer = cc.Layer:create()
	
	arg_16_0.cutin_layer:setLocalZOrder(1000)
	arg_16_0.root_layer:addChild(arg_16_0.cutin_layer)
	
	arg_16_0.road_field_info_tbl = {}
	arg_16_0.field_list = {}
	arg_16_0.mode = arg_16_1
end

function BattleField.getUILayer(arg_17_0)
	return arg_17_0.ui_layer
end

function BattleField.addUIControl(arg_18_0, arg_18_1)
	arg_18_0.ui_layer:addChild(arg_18_1)
end

function BattleField.removeUIControlByName(arg_19_0, arg_19_1)
	if arg_19_0.ui_layer and get_cocos_refid(arg_19_0.ui_layer) and get_cocos_refid(arg_19_0.ui_layer:findChildByName(arg_19_1)) then
		arg_19_0.ui_layer:removeChildByName(arg_19_1)
	end
end

function BattleField.createField(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0:init()
	arg_20_0:addEventStageField(arg_20_1.way, arg_20_2)
	
	return arg_20_0.root_layer
end

function BattleField.setVisibleFieldGrid(arg_21_0, arg_21_1)
	arg_21_0.visible_grid = arg_21_1
	
	local var_21_0 = arg_21_0:getCurrentField()
	
	if var_21_0 then
		var_21_0:setVisibleGrid(arg_21_1)
	end
end

function BattleField.clear(arg_22_0)
	arg_22_0.root_layer = nil
	arg_22_0.field_list = nil
end

function BattleField.addTestField(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0, var_23_1 = arg_23_0:createFieldLayer(arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	
	arg_23_0:setVisibleField(true)
	
	arg_23_0.field_data = {
		field_theme = var_23_1,
		layer = var_23_0,
		flip = arg_23_3
	}
end

function BattleField.createRoadSectorFieldInfo(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = {
		road_id = assert(arg_24_1.road_id),
		road_sector_id = assert(arg_24_1.sector_id),
		position = arg_24_2,
		is_single_sector = arg_24_3.is_single_sector
	}
	
	var_24_0.bounds_sector_left = var_24_0.position - ROAD_SECTOR_WIDTH * 0.5
	var_24_0.bounds_sector_right = var_24_0.position + ROAD_SECTOR_WIDTH * 0.5
	var_24_0.trigger_event_left = var_24_0.position - ROAD_SECTOR_WIDTH * 0.02
	var_24_0.trigger_event_right = var_24_0.position + ROAD_SECTOR_WIDTH * 0.02
	var_24_0.pet_recognize_left = var_24_0.position - ROAD_SECTOR_WIDTH * 0.34
	var_24_0.pet_recognize_right = var_24_0.position + ROAD_SECTOR_WIDTH * 0.34
	var_24_0.width = var_24_0.bounds_sector_right - var_24_0.bounds_sector_left
	
	return var_24_0
end

function BattleField.createRoadFieldInfo(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0:getCurrentField()
	local var_25_1 = arg_25_2.road_id
	local var_25_2 = arg_25_2.road_type
	local var_25_3 = arg_25_2.is_single_sector
	local var_25_4 = var_25_2 == "goblin"
	local var_25_5 = DESIGN_WIDTH * 0.5
	
	if var_25_4 then
		var_25_5 = var_25_5 + DESIGN_WIDTH * 0.63
	end
	
	local var_25_6 = {
		is_single_sector = var_25_3,
		is_goblin = var_25_4,
		is_reverse = arg_25_2.road_reverse
	}
	local var_25_7 = {}
	local var_25_8 = {}
	local var_25_9 = arg_25_1:getRoadSectorObjectList(arg_25_2.road_id)
	local var_25_10 = #var_25_9 * ROAD_SECTOR_WIDTH
	
	for iter_25_0, iter_25_1 in pairs(var_25_9) do
		var_25_7[iter_25_1] = arg_25_0:createRoadSectorFieldInfo(iter_25_1, var_25_5, var_25_6)
		
		for iter_25_2, iter_25_3 in pairs(iter_25_1.event_list) do
			var_25_8[iter_25_3] = {
				event_id = iter_25_3.event_id,
				event_type = iter_25_3.type,
				position = var_25_5
			}
		end
		
		var_25_5 = var_25_5 + (var_25_3 and 0 or ROAD_SECTOR_WIDTH)
	end
	
	local var_25_11 = {
		res = arg_25_0:getTheme(var_25_1),
		width = var_25_10,
		field_model_offset = {
			position_y = 0
		},
		road_reverse = arg_25_2.road_reverse
	}
	
	if var_25_3 and (not var_25_11.road_reverse or true) then
	else
		var_25_11.reach_wall_left = -(DESIGN_WIDTH * 0.3)
		var_25_11.reach_wall_right = var_25_11.width + ROAD_SECTOR_WIDTH / 2 - DESIGN_WIDTH * 0.3
	end
	
	if var_25_4 then
		var_25_11.width = DESIGN_WIDTH
		var_25_11.min_moveable_left = 0
		var_25_11.max_moveable_right = DESIGN_WIDTH * 0.74
		var_25_11.field_model_offset = {
			position_y = -110
		}
	else
		var_25_11.min_moveable_left = -ROAD_SECTOR_WIDTH
		var_25_11.max_moveable_right = var_25_11.width + ROAD_SECTOR_WIDTH
	end
	
	var_25_11.moveable_left = var_25_11.min_moveable_left
	var_25_11.moveable_right = var_25_11.max_moveable_right
	var_25_11.sector_field_info_tbl = var_25_7
	var_25_11.event_field_info_tbl = var_25_8
	var_25_11.field_block_list = {}
	
	for iter_25_4, iter_25_5 in pairs(var_25_8) do
		if iter_25_5.event_type == "obstacle" then
			iter_25_5.width = 580
			
			table.insert(var_25_11.field_block_list, iter_25_5)
		end
	end
	
	return var_25_11
end

function BattleField.updateReachMoveable(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.road_field_info
	
	if not var_26_0 then
		return 
	end
	
	var_26_0.moveable_left = var_26_0.min_moveable_left
	var_26_0.moveable_right = var_26_0.max_moveable_right
	
	if var_26_0.road_reverse then
		for iter_26_0, iter_26_1 in pairs(var_26_0.field_block_list) do
			if not arg_26_1:isCompletedRoadEvent(iter_26_1.event_id) then
				var_26_0.moveable_left = math.max(var_26_0.moveable_left, iter_26_1.position + iter_26_1.width * 0.5)
			end
		end
	else
		for iter_26_2, iter_26_3 in pairs(var_26_0.field_block_list) do
			if not arg_26_1:isCompletedRoadEvent(iter_26_3.event_id) then
				var_26_0.moveable_right = math.min(var_26_0.moveable_right, iter_26_3.position - iter_26_3.width * 0.5)
			end
		end
	end
end

function BattleField.createFieldLayer(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	local var_27_0
	
	if arg_27_4 then
		var_27_0 = arg_27_4.additional_bgi_mode
	end
	
	local var_27_1, var_27_2 = FIELD_NEW:create(arg_27_1, arg_27_2, arg_27_3, arg_27_4)
	
	var_27_1:setName("@FIELD_TOP_LAYER")
	var_27_2:setVisibleGrid(arg_27_0.visible_grid)
	
	var_27_2.ui_layer = arg_27_0.ui_layer
	var_27_2.cutin_layer = arg_27_0.cutin_layer
	
	local var_27_3 = arg_27_0.field_layer
	
	arg_27_0.field_theme = var_27_2
	arg_27_0.field_layer = var_27_1
	
	arg_27_0.root_layer:addChild(var_27_1)
	
	if var_27_0 then
		var_27_3 = nil
	end
	
	if var_27_3 and get_cocos_refid(var_27_3) then
		var_27_3:removeFromParent()
	end
	
	if var_27_0 then
		BGIManager:setBGI(var_27_0, var_27_2)
	else
		BGI = var_27_2
	end
	
	CameraManager:resetGameLayer(var_27_2.game_layer)
	
	return var_27_1, var_27_2
end

function BattleField.loadRoadTheme(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	arg_28_4 = arg_28_4 or {}
	
	local var_28_0 = arg_28_4.restore_road_field_info or arg_28_0:createRoadFieldInfo(arg_28_1, arg_28_2)
	
	arg_28_0.vars.current_sector_field_info = arg_28_4.restore_current_sector_info
	
	local var_28_1 = arg_28_2.road_reverse
	local var_28_2, var_28_3 = arg_28_0:createFieldLayer(arg_28_3.theme or var_28_0.res.theme, var_28_0.width, var_28_1)
	
	arg_28_0.field_data = {
		field_theme = var_28_3,
		layer = var_28_2,
		road_info = arg_28_2,
		flip = var_28_1
	}
	
	local var_28_4 = arg_28_1:getRoadSectorObjectList(arg_28_2.road_id)
	
	arg_28_0.road_sector_object_list = table.shallow_clone(var_28_4)
	
	if arg_28_2.road_reverse then
		table.sort(arg_28_0.road_sector_object_list, function(arg_29_0, arg_29_1)
			local var_29_0 = var_28_0.sector_field_info_tbl[arg_29_0]
			local var_29_1 = var_28_0.sector_field_info_tbl[arg_29_1]
			
			return var_29_0.position > var_29_1.position
		end)
	else
		table.sort(arg_28_0.road_sector_object_list, function(arg_30_0, arg_30_1)
			local var_30_0 = var_28_0.sector_field_info_tbl[arg_30_0]
			local var_30_1 = var_28_0.sector_field_info_tbl[arg_30_1]
			
			return var_30_0.position < var_30_1.position
		end)
	end
	
	if arg_28_0.warp_lines then
		for iter_28_0, iter_28_1 in pairs(arg_28_0.warp_lines) do
			if get_cocos_refid(iter_28_1) then
				iter_28_1:removeFromParent()
			end
		end
	end
	
	arg_28_0.warp_lines = {}
	arg_28_0.road_field_info = var_28_0
	arg_28_0.road_field_info_tbl[arg_28_2.road_id] = var_28_0
	
	arg_28_0:updateReachMoveable(arg_28_1)
	
	local var_28_5 = arg_28_1:getRoadObject(arg_28_2.road_id)
	
	if not var_28_5.is_single_sector then
		local var_28_6 = var_28_3.main.layer
		
		if var_28_5.dirs then
			arg_28_0:addWarpLine("left")
			arg_28_0:addWarpLine("right")
		elseif arg_28_2.road_reverse then
			arg_28_0:addWarpLine("right")
		else
			arg_28_0:addWarpLine("left")
		end
	end
	
	return var_28_0
end

function BattleField.IsOutOfWarpLine(arg_31_0)
	local var_31_0 = BattleLayout:getFieldPosition()
	local var_31_1 = arg_31_0.road_field_info
	
	if var_31_1.reach_wall_left and var_31_0 < var_31_1.reach_wall_left or var_31_1.reach_wall_right and var_31_0 > var_31_1.reach_wall_right then
		return true
	else
		return false
	end
end

function BattleField.addWarpLine(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.field_data.field_theme.main.layer
	
	if arg_32_0.road_field_info.reach_wall_left and arg_32_1 == "left" then
		if not get_cocos_refid(arg_32_0.warp_lines.left) then
			arg_32_0.warp_lines.left = EffectManager:Play({
				z = 99998,
				fn = "ui_nextarea_guide.cfx",
				flip_x = true,
				layer = var_32_0,
				x = arg_32_0.road_field_info.reach_wall_left,
				y = DESIGN_HEIGHT * 0.26
			})
		end
	elseif arg_32_1 == "right" then
		if arg_32_0.road_field_info.reach_wall_right and not get_cocos_refid(arg_32_0.warp_lines.right) then
			arg_32_0.warp_lines.right = EffectManager:Play({
				z = 99998,
				fn = "ui_nextarea_guide.cfx",
				layer = var_32_0,
				x = arg_32_0.road_field_info.reach_wall_right,
				y = DESIGN_HEIGHT * 0.26
			})
		end
	elseif arg_32_1 == "finishToNext" then
		if not get_cocos_refid(arg_32_0.warp_lines.finishToNext) then
			local var_32_1 = BattleLayout:getFieldPosition()
			
			arg_32_0.road_field_info.reach_wall_right = var_32_1 + DESIGN_WIDTH * 0.6
			arg_32_0.warp_lines.finishToNext = EffectManager:Play({
				z = 99998,
				fn = "ui_nextarea_guide.cfx",
				layer = var_32_0,
				x = arg_32_0.road_field_info.reach_wall_right,
				y = DESIGN_HEIGHT * 0.26
			})
		end
	elseif not get_cocos_refid(arg_32_0.warp_lines.finishToLobby) then
		local var_32_2 = BattleLayout:getFieldPosition()
		
		arg_32_0.road_field_info.reach_wall_left = var_32_2 - DESIGN_WIDTH * 0.65
		arg_32_0.warp_lines.finishToLobby = EffectManager:Play({
			z = 99998,
			fn = "ui_nextarea_guide.cfx",
			flip_x = true,
			layer = var_32_0,
			x = arg_32_0.road_field_info.reach_wall_left,
			y = DESIGN_HEIGHT * 0.26
		})
	end
end

function BattleField.getRoadFieldInfo(arg_33_0, arg_33_1)
	return arg_33_0.road_field_info_tbl[arg_33_1]
end

function BattleField.isVisibleField(arg_34_0)
	local var_34_0 = arg_34_0:getCurrentField()
	
	if not var_34_0 then
		return 
	end
	
	return var_34_0:isVisibleField()
end

function BattleField.setForgroundOpacityByTag(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0:getCurrentField()
	
	if not var_35_0 then
		return 
	end
	
	var_35_0:setForgroundOpacityByTag(arg_35_1, arg_35_2)
end

function BattleField.setVisibleField(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0:getCurrentField()
	
	if not var_36_0 then
		return 
	end
	
	var_36_0:setVisibleField(arg_36_1, arg_36_2)
end

function BattleField.setVisible(arg_37_0, arg_37_1)
	if get_cocos_refid(arg_37_0.root_layer) then
		arg_37_0.root_layer:setVisible(arg_37_1)
	end
end

function BattleField.getCurrentField(arg_38_0)
	return arg_38_0.field_theme
end

function BattleField.buildChangeInfo(arg_39_0)
	arg_39_0.field_change_info = {}
	
	for iter_39_0 = 1, 99 do
		local var_39_0, var_39_1, var_39_2, var_39_3, var_39_4, var_39_5 = DBN("smart_bg_static", iter_39_0, {
			"id",
			"bg_id",
			"condition_type",
			"condition",
			"action_info",
			"ambient"
		})
		
		if var_39_1 then
			if not arg_39_0.field_change_info[var_39_1] then
				arg_39_0.field_change_info[var_39_1] = {}
			end
			
			table.insert(arg_39_0.field_change_info[var_39_1], {
				id = var_39_0,
				condition_type = var_39_2,
				condition = var_39_3,
				action_info = var_39_4,
				ambient = var_39_5
			})
		end
	end
end

function BattleField.onCheckFieldState(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.field_change_info then
		arg_40_0:buildChangeInfo()
	end
	
	local var_40_0 = arg_40_0:getCurrentField()
	
	if not var_40_0 then
		return 
	end
	
	local var_40_1 = var_40_0.theme_name
	local var_40_2 = arg_40_0.field_change_info[var_40_1]
	
	if not var_40_2 then
		return 
	end
	
	for iter_40_0, iter_40_1 in pairs(var_40_2) do
		if iter_40_1.condition_type == arg_40_1 then
			local var_40_3 = totable(iter_40_1.condition)
			local var_40_4 = false
			
			if arg_40_1 == "rta" then
				var_40_4 = var_40_3.apply_cs == arg_40_2
			elseif arg_40_1 == "adventure" then
				var_40_4 = var_40_3.enter == arg_40_2
			end
			
			if var_40_4 then
				arg_40_0:setChangeAnimation(totable(iter_40_1.action_info), iter_40_1.ambient)
				
				break
			end
		end
	end
end

function BattleField.setChangeAnimation(arg_41_0, arg_41_1, arg_41_2)
	if BattleAction:Find("battle.field.anim") then
		BattleAction:Remove("battle.field.anim")
	end
	
	arg_41_1 = arg_41_1 or {}
	
	local var_41_0 = arg_41_1.change
	local var_41_1 = arg_41_1.idle or "idle"
	
	local function var_41_2(arg_42_0)
		if not arg_42_0 then
			return 
		end
		
		if not arg_42_0.setAnimation then
			return 
		end
		
		local var_42_0 = 0
		local var_42_1 = NONE()
		
		if var_41_0 then
			var_42_1 = DMOTION(var_41_0)
		end
		
		BattleAction:Add(SEQ(CALL(function()
			local var_43_0 = arg_42_0:getCurrent()
			
			if var_43_0 and to_n(var_43_0.endTime) > 0 then
				local var_43_1 = var_43_0.time % var_43_0.endTime
				local var_43_2 = var_43_0.endTime - var_43_1
			end
		end), CALL(function()
			local var_44_0 = arg_42_0:getCurrent()
			
			if var_44_0 then
				var_44_0.timeScale = 1
			end
		end), var_42_1, MOTION(var_41_1, true)), arg_42_0, "battle.field.anim")
	end
	
	;(function(arg_45_0)
		local var_45_0 = "#" .. arg_45_0
		
		Battle:changeAmbientColor(nil, {
			ambient_color = arg_45_0
		})
		
		for iter_45_0, iter_45_1 in pairs(Battle.logic.units or {}) do
			BattleAction:Add(SEQ(FIX_MODEL_FROM_COLOR(100, tocolor(var_45_0))), iter_45_1.model, "unit.model.ambient." .. tostring(iter_45_0))
		end
	end)(arg_41_2)
	
	local var_41_3 = arg_41_0:getCurrentField()
	
	if not var_41_3 then
		return 
	end
	
	return var_41_3:setChangeAnimation(var_41_2)
end

function BattleField.getTheme(arg_46_0, arg_46_1)
	local var_46_0 = {
		"image",
		"bgm",
		"ambient_color"
	}
	
	for iter_46_0 = 1, 10 do
		table.insert(var_46_0, "mission" .. iter_46_0)
		table.insert(var_46_0, "change" .. iter_46_0)
	end
	
	local var_46_1 = DBT("level_stage_1_info", arg_46_1, var_46_0)
	local var_46_2 = var_46_1.image
	local var_46_3 = var_46_1.bgm
	local var_46_4 = var_46_1.ambient_color
	local var_46_5
	
	for iter_46_1 = 1, 10 do
		local var_46_6 = var_46_1["mission" .. iter_46_1]
		
		if var_46_6 then
			if ConditionContentsManager:isMissionCleared(var_46_6, {
				inbattle = true
			}) then
				var_46_5 = var_46_1["change" .. iter_46_1]
			end
		else
			break
		end
	end
	
	if var_46_5 then
		var_46_2, var_46_3, var_46_4 = DB("level_stage_1_info", var_46_5, {
			"image",
			"bgm",
			"ambient_color"
		})
	end
	
	return {
		theme = DEBUG.MAP_NAME or var_46_2,
		bgm = var_46_3,
		ambient_color = var_46_4
	}
end

function BattleField.getPlayground(arg_47_0)
	local var_47_0 = arg_47_0:getCurrentField()
	
	if not var_47_0 then
		return 
	end
	
	return var_47_0.main.layer
end

function BattleField.lockViewPort(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0:getCurrentField()
	
	if not var_48_0 then
		return 
	end
	
	var_48_0:lockViewPort(arg_48_1)
end

function BattleField.lockViewPortRange(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0:getCurrentField()
	
	if not var_49_0 then
		return 
	end
	
	local var_49_1
	local var_49_2
	
	if arg_49_1 then
		local var_49_3 = var_49_0:getViewPortPosition()
		
		var_49_1 = var_49_3 + arg_49_2.minOffsetX or -DESIGN_WIDTH / 2
		var_49_2 = var_49_3 + arg_49_2.maxOffsetX or 0
	else
		var_49_1 = nil
		var_49_2 = nil
	end
	
	var_49_0:lockViewPortRange({
		minRangeX = var_49_1,
		maxRangeX = var_49_2
	})
end

function BattleField.clearOverlay(arg_50_0)
	arg_50_0:overlay(nil)
end

function BattleField.overlay(arg_51_0, arg_51_1)
	if not arg_51_0.vars or not arg_51_0.root_layer then
		return 
	end
	
	arg_51_0.vars.overlay = arg_51_1
	
	if get_cocos_refid(arg_51_0.root_layer) then
		arg_51_0.root_layer:setVisible(arg_51_0.vars.overlay == nil)
	end
end

function BattleField.isRootLayerValid(arg_52_0)
	if not arg_52_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_52_0.root_layer)
end

function BattleField.update(arg_53_0)
	local var_53_0 = arg_53_0:getCurrentField()
	
	if not var_53_0 then
		return 
	end
	
	local var_53_1 = CameraManager:getCamera()
	local var_53_2, var_53_3 = var_53_1:getPosition()
	local var_53_4 = BattleLayout:getFocusPosition()
	
	var_53_0:setScale(var_53_1:getScale())
	var_53_0:setViewPortPosition(var_53_2, var_53_3)
	var_53_0:updateViewport()
	BattleDropManager:setVisible(arg_53_0:isVisibleField())
	
	if arg_53_0.vars.overlay then
		if get_cocos_refid(arg_53_0.vars.overlay) then
			if arg_53_0.vars.overlay:isVisible() and arg_53_0.vars.overlay:getOpacity() == 255 then
				arg_53_0.root_layer:setVisible(false)
			end
		else
			arg_53_0:clearOverlay()
		end
	end
end

function BattleField.setCheckableEvent(arg_54_0, arg_54_1)
	arg_54_0.vars.isCheckableEvent = arg_54_1
end

function BattleField.isCheckableEvent(arg_55_0)
	if is_playing_story() then
		return false
	end
	
	return arg_55_0.vars and arg_55_0.vars.isCheckableEvent
end

function BattleField.checkRoadSector(arg_56_0, arg_56_1)
	if not arg_56_0:isCheckableEvent() then
		return 
	end
	
	local var_56_0 = arg_56_1:getCurrentRoadInfo()
	local var_56_1
	
	var_56_1 = var_56_0.road_reverse and -1 or 1
	
	local var_56_2 = BattleLayout:getDirection()
	local var_56_3 = BattleLayout:getRetainedFieldPosition()
	local var_56_4 = BattleLayout:getFieldPosition()
	
	if arg_56_0.vars.current_sector_field_info and var_56_0.road_id ~= arg_56_0.vars.current_sector_field_info.road_id then
		arg_56_0.vars.current_sector_field_info = nil
	end
	
	local function var_56_5(arg_57_0, arg_57_1)
		local var_57_0 = var_56_3 or var_56_4
		local var_57_1 = var_56_4
		
		if var_56_2 == -1 then
			return var_57_1 <= arg_57_1 and arg_57_0 <= var_57_0
		end
		
		return var_57_0 <= arg_57_1 and arg_57_0 <= var_57_1
	end
	
	local function var_56_6(arg_58_0)
		if not arg_58_0 then
			return 
		end
		
		if var_56_0.road_id ~= arg_58_0.road_id then
			return 
		end
		
		return arg_58_0.is_single_sector or var_56_5(arg_58_0.bounds_sector_left, arg_58_0.bounds_sector_right)
	end
	
	local function var_56_7(arg_59_0)
		if not arg_59_0 then
			return 
		end
		
		if var_56_0.road_id ~= arg_59_0.road_id then
			return 
		end
		
		return arg_59_0.is_single_sector or var_56_5(arg_59_0.trigger_event_left, arg_59_0.trigger_event_right)
	end
	
	local function var_56_8(arg_60_0)
		if not Battle:isAutoPlaying() then
			return 
		end
		
		if not arg_60_0 then
			return 
		end
		
		if var_56_0.road_id ~= arg_60_0.road_id then
			return 
		end
		
		return arg_60_0.is_single_sector or var_56_5(arg_60_0.pet_recognize_left, arg_60_0.pet_recognize_right)
	end
	
	if not var_56_6(arg_56_0.vars.current_sector_field_info) then
		for iter_56_0, iter_56_1 in pairs(arg_56_0.road_sector_object_list) do
			local var_56_9 = arg_56_0.road_field_info.sector_field_info_tbl[iter_56_1]
			
			if not var_56_9.ignore and not var_56_9.closed and var_56_9.position then
				local var_56_10 = false
				
				if var_56_6(var_56_9) then
					arg_56_0.vars.current_sector_field_info = var_56_9
					arg_56_0.vars.current_sector_field_info.excuted_event = false
					
					local var_56_11 = iter_56_1.sector_id
					
					arg_56_1:command({
						cmd = "EnterRoadSector",
						road_sector_id = var_56_11
					})
					
					break
				end
			end
		end
	end
	
	if var_56_7(arg_56_0.vars.current_sector_field_info) and not arg_56_0.vars.current_sector_field_info.excuted_event then
		arg_56_0.vars.current_sector_field_info.excuted_event = true
		
		arg_56_1:command({
			cmd = "ExecuteRoadEvent"
		})
	end
	
	if var_56_8(arg_56_0.vars.current_sector_field_info) and not arg_56_0.vars.current_sector_field_info.pet_recognize then
		arg_56_0.vars.current_sector_field_info.pet_recognize = true
		
		arg_56_1:command({
			cmd = "PetRecognizeRoadEvent"
		})
	end
	
	local var_56_12 = arg_56_0.road_field_info
	
	if var_56_12.moveable_left and var_56_4 < var_56_12.moveable_left then
		Battle:onReachMoveable(var_0_0(var_56_0.road_dir), var_56_12.moveable_left)
	elseif var_56_12.moveable_right and var_56_4 > var_56_12.moveable_right then
		Battle:onReachMoveable(var_0_1(var_56_0.road_dir), var_56_12.moveable_right)
	end
	
	if var_56_12.reach_wall_left and var_56_4 < var_56_12.reach_wall_left then
		if arg_56_0.vars.reach_wall_pos ~= "left" then
			arg_56_0.vars.reach_wall_pos = "left"
			
			Battle:onArrivedWarpLine(var_0_0(var_56_0.road_dir))
		end
	elseif var_56_12.reach_wall_right and var_56_4 > var_56_12.reach_wall_right then
		if arg_56_0.vars.reach_wall_pos ~= "right" then
			arg_56_0.vars.reach_wall_pos = "right"
			
			Battle:onArrivedWarpLine(var_0_1(var_56_0.road_dir))
		end
	else
		arg_56_0.vars.reach_wall_pos = nil
	end
end

function BattleField.getRoadSectorFieldInfo(arg_61_0, arg_61_1)
	if not arg_61_0:getCurrentField() then
		return 
	end
	
	return arg_61_0.road_field_info.sector_field_info_tbl[arg_61_1]
end

function BattleField.getRoadEventFieldModelList(arg_62_0)
	local var_62_0 = arg_62_0:getCurrentField()
	
	if not var_62_0 then
		return 
	end
	
	return var_62_0:getRoadEventFieldModelList()
end

function BattleField.getRoadEventObjectList(arg_63_0)
	local var_63_0 = arg_63_0:getCurrentField()
	
	if not var_63_0 then
		return 
	end
	
	return var_63_0:getRoadEventObjectList()
end

function BattleField.getRoadEventObjectByModel(arg_64_0, arg_64_1)
	local var_64_0 = arg_64_0:getCurrentField()
	
	if not var_64_0 then
		return 
	end
	
	return var_64_0:getRoadEventObjectByModel(arg_64_1)
end

function BattleField.getRoadEventFieldModel(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0:getCurrentField()
	
	if not var_65_0 then
		return 
	end
	
	return var_65_0:getRoadEventFieldModel(arg_65_1)
end

function BattleField.getRoadEventFieldModelByName(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_0:getCurrentField()
	
	if not var_66_0 then
		return 
	end
	
	return var_66_0:getRoadEventFieldModelByName(arg_66_1)
end

function BattleField.makeRoadEventModel(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = arg_67_0:getCurrentField()
	
	if not var_67_0 then
		return 
	end
	
	arg_67_3 = arg_67_3 or {}
	
	local var_67_1 = arg_67_1:getRoadSectorObject(arg_67_2.sector_id)
	
	if var_67_1 then
		local var_67_2 = arg_67_0:getRoadSectorFieldInfo(var_67_1)
		
		if not var_67_2 then
			return 
		end
		
		arg_67_3.position = var_67_2.position
	end
	
	for iter_67_0, iter_67_1 in pairs(arg_67_0.road_field_info.field_model_offset) do
		if not arg_67_3[iter_67_0] then
			arg_67_3[iter_67_0] = iter_67_1
		end
	end
	
	return var_67_0:makeRoadEventModel(arg_67_2, arg_67_3)
end

function BattleField.getRoadEventModelData(arg_68_0, arg_68_1)
	local var_68_0 = {}
	local var_68_1 = arg_68_0:getCurrentField()
	
	if not var_68_1 then
		return 
	end
	
	return var_68_1:getRoadEventModelData(arg_68_1, var_68_0)
end

function BattleField.setVisibleFieldModel(arg_69_0, arg_69_1, arg_69_2)
	for iter_69_0, iter_69_1 in pairs(arg_69_0.warp_lines) do
		if get_cocos_refid(iter_69_1) then
			iter_69_1:setVisible(arg_69_1)
		end
	end
	
	local var_69_0 = arg_69_0:getCurrentField()
	
	if not var_69_0 then
		return 
	end
	
	return var_69_0:setVisibleFieldModel(arg_69_1, arg_69_2)
end
