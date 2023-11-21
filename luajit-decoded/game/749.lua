SPLSystem = {}

function SPLSystem.onMouseWheel(arg_1_0, arg_1_1)
	SceneManager:getRunningScene():updateTouchEventTime()
	
	if arg_1_0:isRequireTouchIgnore() then
		return 
	end
	
	local var_1_0 = {
		x = arg_1_1:getCursorX(),
		y = arg_1_1:getCursorY()
	}
	
	SPLCameraSystem:onScaling(arg_1_1:getScrollY(), var_1_0)
end

function SPLSystem.onWillEnterForeground(arg_2_0)
	if not arg_2_0.vars then
		return 
	end
	
	arg_2_0.vars.on_gesture_zoom = nil
	arg_2_0.vars.touch_started = nil
end

function SPLSystem.onGestureEnd(arg_3_0)
	arg_3_0.vars.on_gesture_zoom = false
end

function SPLSystem.onGestureZoom(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	SceneManager:getRunningScene():updateTouchEventTime()
	
	if arg_4_0:isRequireTouchIgnore() then
		return 
	end
	
	arg_4_0.vars.on_gesture_zoom = true
	
	local var_4_0 = (arg_4_2 - arg_4_1) * 4 * 20 / VIEW_WIDTH * SPLCameraSystem:getScale()
	
	SPLCameraSystem:onScaling(-var_4_0, arg_4_3)
end

function SPLSystem.isRequireTouchIgnore(arg_5_0)
	if not arg_5_0.vars then
		return true
	end
	
	if SPLEventSystem:isPlayingEvent() then
		return true
	end
	
	if TransitionScreen:isShow() then
		return true
	end
	
	if UIAction:Find("spl.block") then
		return true
	end
	
	return false
end

function SPLSystem.onTouchDown(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.vars.touch_started then
		return 
	end
	
	if arg_6_0.vars.on_gesture_zoom then
		return 
	end
	
	arg_6_0.vars.touch_down_was_ignored = arg_6_0:isRequireTouchIgnore()
	
	if arg_6_0.vars.touch_down_was_ignored then
		return 
	end
	
	arg_6_0.vars.pivot_pos = arg_6_1:getLocation()
	
	local var_6_0 = {}
	
	var_6_0.x, var_6_0.y = SceneManager:convertLocation(arg_6_0.vars.pivot_pos.x, arg_6_0.vars.pivot_pos.y)
	arg_6_0.vars.pivot_pos = var_6_0
	arg_6_0.vars.touch_moved = false
	arg_6_0.vars.total_moved = 0
	arg_6_0.vars.start_location = arg_6_1:getStartLocation()
	arg_6_0.vars.touch_started = true
	
	SPLCameraSystem:stopMoveAction()
end

function SPLSystem.onTouchMove(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1:getStartLocation()
	
	if not arg_7_0.vars.start_location then
		arg_7_0.vars.touch_started = false
		
		return 
	end
	
	if arg_7_0.vars.start_location and (arg_7_0.vars.start_location.x ~= var_7_0.x or arg_7_0.vars.start_location.y ~= var_7_0.y) then
		return 
	end
	
	if arg_7_0.vars.on_gesture_zoom then
		return 
	end
	
	if arg_7_0.vars.touch_down_was_ignored then
		return 
	end
	
	if arg_7_0:isRequireTouchIgnore() then
		return 
	end
	
	if not arg_7_0.vars.pivot_pos then
		return 
	end
	
	local var_7_1 = arg_7_1:getLocation()
	local var_7_2 = {}
	
	var_7_2.x, var_7_2.y = SceneManager:convertLocation(var_7_1.x, var_7_1.y)
	
	local var_7_3 = var_7_2
	local var_7_4 = var_7_3.x - arg_7_0.vars.pivot_pos.x
	local var_7_5 = var_7_3.y - arg_7_0.vars.pivot_pos.y
	
	SPLCameraSystem:procTouchMove(var_7_4, var_7_5)
	
	if var_7_4 > 10 or var_7_5 > 10 or arg_7_0.vars.total_moved > 20 then
		arg_7_0.vars.touch_moved = true
	end
	
	arg_7_0.vars.total_moved = arg_7_0.vars.total_moved + math.abs(var_7_4) + math.abs(var_7_5)
	arg_7_0.vars.pivot_pos = var_7_3
end

function SPLSystem.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getStartLocation()
	
	if not arg_8_0.vars.start_location then
		arg_8_0.vars.touch_started = false
		
		return 
	end
	
	if arg_8_0.vars.start_location.x ~= var_8_0.x or arg_8_0.vars.start_location.y ~= var_8_0.y then
		return 
	else
		arg_8_0.vars.touch_started = false
	end
	
	if arg_8_0.vars.on_gesture_zoom then
		return 
	end
	
	if arg_8_0.vars.touch_down_was_ignored then
		return 
	end
	
	if arg_8_0:isRequireTouchIgnore() then
		return 
	end
	
	if not arg_8_0.vars.pivot_pos then
		return 
	end
	
	if uitick() - (arg_8_0.vars.set_cool_time or 0) < 100 then
		return 
	end
	
	if arg_8_0.vars.touch_moved then
		SPLCameraSystem:decelMoveAction()
	else
		if UIAction:Find("block") then
			return 
		end
		
		local var_8_1 = arg_8_0:touchPosToWorldPos(arg_8_0.vars.pivot_pos)
		local var_8_2 = SPLTileMapSystem:calcWorldPosToTilePos(var_8_1)
		
		if var_8_2 then
			arg_8_0:procTouchInteract(var_8_2)
		end
	end
end

function SPLSystem.procTouchInteract(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	local var_9_0 = SPLMovableSystem:getPlayer()
	local var_9_1 = var_9_0:getPos()
	
	if not (SPLFogSystem:getFogVisibility(arg_9_1.x, arg_9_1.y) > HTBFogVisibilityEnum.NOT_DISCOVER) then
		return 
	end
	
	local var_9_2 = SPLTileMapSystem:getTileByPos(arg_9_1)
	
	if not var_9_2 then
		return 
	end
	
	local var_9_3 = var_9_2:getTileId()
	
	if not SPLTileMapSystem:isInteractableTile(var_9_3) then
		arg_9_0:_balloon_message("tile_sub_move_disable")
		
		return 
	end
	
	local var_9_4 = SPLObjectSystem:getObject(var_9_3)
	
	if var_9_4 and var_9_4:isActive() and var_9_4:getType() ~= "empty" then
		local var_9_5 = {}
		
		table.insert(var_9_5, var_9_4:getUID())
		
		local var_9_6 = var_9_4:getChildTileList() or {}
		
		for iter_9_0, iter_9_1 in pairs(var_9_6) do
			table.insert(var_9_5, iter_9_1)
		end
		
		local var_9_7 = SPLUtil:getTileOutLine(var_9_5)
		
		if table.find(var_9_7, function(arg_10_0, arg_10_1)
			local var_10_0 = arg_10_1:getPos()
			
			return var_10_0.x == var_9_1.x and var_10_0.y == var_9_1.y
		end) then
			SPLObjectSystem:onUseObject(var_9_3)
			
			return 
		elseif #var_9_5 > 3 then
			local var_9_8 = SPLTileMapSystem:getInteractableArea()
			local var_9_9 = SPLUtil:getTileIntersection(var_9_7, var_9_8)
			local var_9_10 = SPLUtil:getNearestTile(arg_9_1, var_9_9)
			
			if not var_9_10 then
				return 
			end
			
			local var_9_11 = SPLPathFindingSystem:find(var_9_1, var_9_10:getPos(), var_9_0:getMoveCell())
			
			if var_9_11 then
				SPLSystem:procMovePath(SPLMovableSystem:getCurrentPlayerId(), var_9_11)
				
				return 
			end
		else
			local var_9_12, var_9_13 = SPLPathFindingSystem:findNearestTile(var_9_1, var_9_7, var_9_0:getMoveCell())
			
			if var_9_13 then
				SPLSystem:procMovePath(SPLMovableSystem:getCurrentPlayerId(), var_9_13, arg_9_1)
				
				return 
			end
		end
	elseif var_9_2:isMovable() then
		local var_9_14 = SPLPathFindingSystem:getReachableTiles(var_9_1, var_9_0:getMoveCell(), true)
		
		if table.find(var_9_14, function(arg_11_0, arg_11_1)
			return arg_11_1.x == arg_9_1.x and arg_11_1.y == arg_9_1.y
		end) then
			local var_9_15 = SPLPathFindingSystem:find(var_9_1, arg_9_1, var_9_0:getMoveCell())
			
			if var_9_15 then
				SPLSystem:procMovePath(SPLMovableSystem:getCurrentPlayerId(), var_9_15)
				
				return 
			end
		end
	end
	
	arg_9_0:_balloon_message("tile_sub_move_disable")
end

function SPLSystem._balloon_message(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		return 
	end
	
	if arg_12_0.vars.last_msg_id == arg_12_1 and arg_12_0.vars.last_msg_tm and uitick() - arg_12_0.vars.last_msg_tm < 400 then
		return 
	end
	
	arg_12_0.vars.last_msg_id = arg_12_1
	arg_12_0.vars.last_msg_tm = uitick()
	
	balloon_message_with_sound(arg_12_1)
end

function SPLSystem.onUpdate(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.parent_layer) then
		return 
	end
	
	SPLMainUI:updateLocationButton()
end

function SPLSystem.procMovePath(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = SPLMovableSystem:getMovableById(arg_14_1)
	
	if not var_14_0 then
		print("????????? NOT SYNC NOT MOVE PATH", arg_14_1)
		
		return 
	end
	
	if table.count(arg_14_2) > 0 then
		local var_14_1 = arg_14_2[#arg_14_2]
		
		SPLMovableSystem:movePath(var_14_0, arg_14_2)
		
		arg_14_3 = arg_14_3 or var_14_1
		
		SPLTileMapRenderer:marking(arg_14_3)
		SPLSystem:playSelectSound()
	end
end

function SPLSystem.playSelectSound(arg_15_0)
	SoundEngine:play("event:/ui/ok")
end

function SPLSystem.startBattle(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_1 then
		return 
	end
	
	if not SPLMovableSystem:getPlayer() then
		return 
	end
	
	SPLMissionUI:close()
	arg_16_0:showCurtain(function()
		SPLUserData:queryBattle(arg_16_1, arg_16_2)
	end)
end

function SPLSystem.giveUpBattle(arg_18_0)
	balloon_message_with_sound("tile_sub_ui_giveup")
end

function SPLSystem.releaseAllModel(arg_19_0)
	SPLObjectRenderer:release()
	SPLMovableRenderer:release()
	cc.Director:getInstance():removeUnusedCachedData()
	
	if sp.SkeletoneCache then
		sp.SkeletoneCache:getInstance():removeUnusedCachedData()
	end
end

function SPLSystem.warp(arg_20_0)
	SPLMissionUI:close()
	SceneManager:nextScene("spl")
end

function SPLSystem.showCurtain(arg_21_0, arg_21_1)
	TransitionScreen:show({
		on_show_before = function(arg_22_0)
			return EffectManager:Play({
				fn = "eff_anc_floor.cfx",
				pivot_z = 99998,
				layer = arg_22_0,
				pivot_x = VIEW_WIDTH / 2,
				pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
			}), 800
		end,
		on_hide_before = function(arg_23_0)
			return nil, 800
		end,
		on_show = arg_21_1
	})
end

function SPLSystem.getEffectLayer(arg_24_0)
	return arg_24_0.vars.effect_layer
end

function SPLSystem.getFieldLayer(arg_25_0)
	return arg_25_0.vars.field_layer
end

function SPLSystem.setVisible(arg_26_0, arg_26_1)
	if not arg_26_0.vars then
		return 
	end
	
	if_set_visible(arg_26_0.vars.parent_layer, nil, arg_26_1)
end

function SPLSystem.touchPosToWorldPos(arg_27_0, arg_27_1)
	local var_27_0 = table.clone(arg_27_1)
	local var_27_1 = cc.Director:getInstance():getWinSize()
	
	var_27_0.x = var_27_0.x + (var_27_1.width - DESIGN_WIDTH) / 2
	var_27_0.y = var_27_0.y + (var_27_1.height - DESIGN_HEIGHT) / 2
	
	local var_27_2 = arg_27_0.vars.tile_layer:convertToWorldSpace({
		x = 0,
		y = -10
	})
	local var_27_3 = arg_27_0.vars.pivot:getScale()
	
	return {
		x = (var_27_0.x - var_27_2.x) / var_27_3,
		y = (var_27_0.y - var_27_2.y) / var_27_3
	}
end

function SPLSystem.touchPosConvertSceneForInput(arg_28_0, arg_28_1)
	local var_28_0 = {}
	
	var_28_0.x, var_28_0.y = SceneManager:convertLocation(arg_28_1.x, arg_28_1.y)
	
	return var_28_0
end

function SPLSystem.getCurrentMapId(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	return arg_29_0.vars.scene_info and arg_29_0.vars.scene_info.map_id
end

function SPLSystem.getCurrentBgm(arg_30_0)
	return DB("tile_sub", arg_30_0:getCurrentMapId(), "map_bgm")
end

function SPLSystem.isExceptPreloadModel(arg_31_0, arg_31_1)
	if not arg_31_0.vars then
		return 
	end
	
	if not arg_31_0.vars.except_preload_list then
		arg_31_0.vars.except_preload_list = {}
		
		local var_31_0 = DB("tile_sub", arg_31_0:getCurrentMapId(), "preload_id")
		
		if var_31_0 then
			for iter_31_0, iter_31_1 in pairs(string.split(var_31_0, ";") or {}) do
				local var_31_1 = DB("character", iter_31_1, "model_id")
				
				if var_31_1 then
					arg_31_0.vars.except_preload_list[var_31_1] = true
				end
			end
		end
	end
	
	return arg_31_0.vars.except_preload_list[arg_31_1]
end

function SPLSystem.init(arg_32_0, arg_32_1, arg_32_2)
	arg_32_2 = arg_32_2 or {}
	
	arg_32_0:baseInit(arg_32_1, arg_32_2)
	arg_32_0:executeInitList()
	
	local var_32_0 = arg_32_2.spl_data or {}
	local var_32_1 = table.clone(HTBMovableDataInterface)
	
	if var_32_0.pos then
		var_32_1.pos = SPLTileMapSystem:getPosById(var_32_0.pos)
	else
		local var_32_2 = DB("tile_sub", arg_32_0:getCurrentMapId(), "start_point") or 2
		
		var_32_1.pos = SPLTileMapSystem:getPosById(var_32_2)
	end
	
	var_32_1.id = 1
	var_32_1.preset_id = var_32_0.preset_id or "vaf3aa_preset_1"
	
	SPLMovableSystem:addMovable(var_32_1)
	SPLCameraSystem:setPlayScale()
	SPLCameraSystem:setCameraPlayerPos()
	SPLMainUI:updateLocationButton()
	SPLEventSystem:onEndStep()
end

function SPLSystem.baseInit(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.vars = {}
	arg_33_0.vars.parent_layer = arg_33_1
	arg_33_0.vars.scene_info = arg_33_2
end

function SPLSystem.executeInitList(arg_34_0)
	local var_34_0 = {}
	
	for iter_34_0, iter_34_1 in pairs(SPLSystem.InitList) do
		table.insert(var_34_0, {
			name = iter_34_0,
			tbl = iter_34_1
		})
	end
	
	table.sort(var_34_0, function(arg_35_0, arg_35_1)
		return arg_35_0.tbl.Priority < arg_35_1.tbl.Priority
	end)
	
	for iter_34_2, iter_34_3 in pairs(var_34_0) do
		iter_34_3.tbl:Func(arg_34_0)
	end
end

function SPLSystem.onEnter(arg_36_0)
	SPLMissionData:updateShowMissions()
	SPLMissionUI:onEnter()
end

function SPLSystem.onLeave(arg_37_0)
	for iter_37_0, iter_37_1 in pairs(SPLSystem.InitList) do
		if type(iter_37_1.onLeave) == "function" then
			iter_37_1:onLeave()
		end
	end
end

SPLSystem.InitList = {}

local function var_0_0(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = cc.Node:create()
	
	var_38_0:setLocalZOrder(arg_38_1)
	var_38_0:setPosition(arg_38_2, arg_38_3)
	var_38_0:setCascadeColorEnabled(true)
	var_38_0:setName(arg_38_0)
	
	return var_38_0
end

SPLSystem.InitList.Layers = {}
SPLSystem.InitList.Layers.Priority = 0

function SPLSystem.InitList.Layers.Func(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_1.vars.parent_layer
	
	arg_39_1.vars.pos_adj_layer = var_0_0("pos_adj_layer", 0, VIEW_BASE_LEFT, 0)
	arg_39_1.vars.game_layer = var_0_0("game_layer", 0, 0, 0)
	
	var_39_0:addChild(arg_39_1.vars.pos_adj_layer)
	
	local var_39_1 = arg_39_1.vars.parent_layer
	
	arg_39_1.vars.ui_layer = var_0_0("ui_layer", 1, 0, 0)
	
	var_39_1:addChild(arg_39_1.vars.ui_layer)
	
	local var_39_2 = arg_39_1.vars.parent_layer
	
	arg_39_1.vars.dim_layer = var_0_0("dim_layer", 2, VIEW_BASE_LEFT, 0)
	
	var_39_2:addChild(arg_39_1.vars.dim_layer)
	
	local var_39_3 = arg_39_1.vars.parent_layer
	
	arg_39_1.vars.story_layer = var_0_0("story_layer", 3, 0, 0)
	
	var_39_3:addChild(arg_39_1.vars.story_layer)
	
	local var_39_4 = arg_39_1.vars.parent_layer
	
	arg_39_1.vars.bg_layer = var_0_0("bg_layer", -1, VIEW_BASE_LEFT, 0)
	
	var_39_4:addChild(arg_39_1.vars.bg_layer)
	
	local var_39_5 = arg_39_1.vars.game_layer
	
	arg_39_1.vars.pivot = var_0_0("pivot", 0, 0, 0)
	
	var_39_5:addChild(arg_39_1.vars.pivot)
	
	local var_39_6 = arg_39_1.vars.game_layer
	
	arg_39_1.vars.fog_behind_layer = var_0_0("fog_behind_layer", 1, 0, 0)
	arg_39_1.vars.fog_layer = var_0_0("fog_layer", 2, 0, VIEW_HEIGHT / 2)
	arg_39_1.vars.fog_ahead_layer = var_0_0("fog_ahead_layer", 3, 0, 0)
	
	var_39_6:addChild(arg_39_1.vars.fog_behind_layer)
	var_39_6:addChild(arg_39_1.vars.fog_layer)
	var_39_6:addChild(arg_39_1.vars.fog_ahead_layer)
	
	local var_39_7 = arg_39_1.vars.fog_behind_layer
	
	arg_39_1.vars.tile_layer = var_0_0("tile_layer", 1, 300, 300)
	
	var_39_7:addChild(arg_39_1.vars.tile_layer)
	
	local var_39_8 = arg_39_1.vars.fog_ahead_layer
	
	arg_39_1.vars.field_layer = var_0_0("field_layer", 2, 300, 300)
	
	var_39_8:addChild(arg_39_1.vars.field_layer)
	
	local var_39_9 = arg_39_1.vars.fog_ahead_layer
	
	arg_39_1.vars.field_ui_layer = var_0_0("field_ui_layer", 3, 300, 300)
	
	var_39_9:addChild(arg_39_1.vars.field_ui_layer)
	
	local var_39_10 = arg_39_1.vars.fog_ahead_layer
	
	arg_39_1.vars.effect_layer = var_0_0("effect_layer", 4, 300, 300)
	
	var_39_10:addChild(arg_39_1.vars.effect_layer)
end

SPLSystem.InitList.Whiteboard = {}
SPLSystem.InitList.Whiteboard.Priority = 1

function SPLSystem.InitList.Whiteboard.Func(arg_40_0, arg_40_1)
	SPLWhiteboard:init()
	SPLWhiteboard:set("ambient_color", cc.c3b(255, 255, 255))
end

SPLSystem.InitList.Tile = {}
SPLSystem.InitList.Tile.Priority = 2

function SPLSystem.InitList.Tile.Func(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1.vars.tile_layer
	local var_41_1 = SPLMapLoader:getMapId()
	
	SPLTileMapSystem:init(var_41_0, var_41_1)
end

SPLSystem.InitList.Movable = {}
SPLSystem.InitList.Movable.Priority = 3

function SPLSystem.InitList.Movable.Func(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1.vars.field_layer
	
	SPLMovableSystem:init(var_42_0)
end

SPLSystem.InitList.Event = {}
SPLSystem.InitList.Event.Priority = 3

function SPLSystem.InitList.Event.Func(arg_43_0, arg_43_1)
	SPLEventSystem:init()
end

SPLSystem.InitList.Object = {}
SPLSystem.InitList.Object.Priority = 4

function SPLSystem.InitList.Object.Func(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1.vars.field_layer
	
	SPLObjectSystem:init(var_44_0)
end

SPLSystem.InitList.Fog = {}
SPLSystem.InitList.Fog.Priority = 6

function SPLSystem.InitList.Fog.Func(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_1.vars.fog_layer
	
	SPLFogSystem:init(var_45_0, SPLSystem:getCurrentMapId())
	
	local var_45_1 = SPLUserData:getCurrentFloor()
	local var_45_2 = SPLUserData:getFloorFogData(var_45_1)
	
	if var_45_2 then
		SPLFogSystem:parsingFogMap(var_45_2)
	end
end

SPLSystem.InitList.Camera = {}
SPLSystem.InitList.Camera.Priority = 5

function SPLSystem.InitList.Camera.injectionPivotFunctions(arg_46_0, arg_46_1, arg_46_2)
	arg_46_1._setPosition = arg_46_1.setPosition
	arg_46_1._setPositionX = arg_46_1.setPositionX
	arg_46_1._setPositionY = arg_46_1.setPositionY
	arg_46_1._setScale = arg_46_1.setScale
	arg_46_1._setScaleX = arg_46_1.setScaleX
	arg_46_1._setScaleY = arg_46_1.setScaleY
	
	function arg_46_1.setPosition(arg_47_0, arg_47_1, arg_47_2)
		arg_47_0:_setPosition(arg_47_1, arg_47_2)
		SPLFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_46_2.vars.fog_behind_layer) then
			arg_46_2.vars.fog_behind_layer:setPosition(arg_47_1, arg_47_2)
		end
		
		if get_cocos_refid(arg_46_2.vars.fog_ahead_layer) then
			arg_46_2.vars.fog_ahead_layer:setPosition(arg_47_1, arg_47_2)
		end
		
		SPLCameraSystem:objectCulling()
		SPLBGRenderer:syncPosition()
	end
	
	function arg_46_1.setPositionX(arg_48_0, arg_48_1)
		arg_48_0:_setPositionX(arg_48_1)
		SPLFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_46_2.vars.fog_behind_layer) then
			arg_46_2.vars.fog_behind_layer:setPositionX(arg_48_1)
		end
		
		if get_cocos_refid(arg_46_2.vars.fog_ahead_layer) then
			arg_46_2.vars.fog_ahead_layer:setPositionX(arg_48_1)
		end
		
		SPLCameraSystem:objectCulling()
		SPLBGRenderer:syncPosition()
	end
	
	function arg_46_1.setPositionY(arg_49_0, arg_49_1)
		arg_49_0:_setPositionY(arg_49_1)
		SPLFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_46_2.vars.fog_behind_layer) then
			arg_46_2.vars.fog_behind_layer:setPositionY(arg_49_1)
		end
		
		if get_cocos_refid(arg_46_2.vars.fog_ahead_layer) then
			arg_46_2.vars.fog_ahead_layer:setPositionY(arg_49_1)
		end
		
		SPLCameraSystem:objectCulling()
		SPLBGRenderer:syncPosition()
	end
	
	function arg_46_1.setScale(arg_50_0, arg_50_1)
		arg_50_0:_setScale(arg_50_1)
		SPLFogRenderer:syncPosition()
		SPLCameraSystem:setScaleJustValue(arg_50_1)
		SPLCameraSystem:updateCameraMinMax()
		SPLFieldUI:updateFieldUIScale()
		
		if get_cocos_refid(arg_46_2.vars.fog_behind_layer) then
			arg_46_2.vars.fog_behind_layer:setScale(arg_50_1)
		end
		
		if get_cocos_refid(arg_46_2.vars.fog_ahead_layer) then
			arg_46_2.vars.fog_ahead_layer:setScale(arg_50_1)
		end
	end
	
	function arg_46_1.setScaleX(arg_51_0, arg_51_1)
		arg_51_0:_setScaleX(arg_51_1)
		SPLFogRenderer:syncPosition()
		SPLCameraSystem:setScaleJustValue(arg_51_1)
		SPLCameraSystem:updateCameraMinMax()
		SPLFieldUI:updateFieldUIScale()
		
		if get_cocos_refid(arg_46_2.vars.fog_behind_layer) then
			arg_46_2.vars.fog_behind_layer:setScaleX(arg_51_1)
		end
		
		if get_cocos_refid(arg_46_2.vars.fog_ahead_layer) then
			arg_46_2.vars.fog_ahead_layer:setScaleX(arg_51_1)
		end
	end
	
	function arg_46_1.setScaleY(arg_52_0, arg_52_1)
		arg_52_0:_setScaleY(arg_52_1)
		SPLFogRenderer:syncPosition()
		SPLCameraSystem:setScaleJustValue(arg_52_1)
		SPLCameraSystem:updateCameraMinMax()
		SPLFieldUI:updateFieldUIScale()
		
		if get_cocos_refid(arg_46_2.vars.fog_behind_layer) then
			arg_46_2.vars.fog_behind_layer:setScaleY(arg_52_1)
		end
		
		if get_cocos_refid(arg_46_2.vars.fog_ahead_layer) then
			arg_46_2.vars.fog_ahead_layer:setScaleY(arg_52_1)
		end
	end
end

function SPLSystem.InitList.Camera.Func(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_1.vars.game_layer
	local var_53_1 = arg_53_1.vars.parent_layer
	local var_53_2 = arg_53_1.vars.pivot
	
	arg_53_0:injectionPivotFunctions(var_53_2, arg_53_1)
	SPLCameraSystem:init(var_53_0, arg_53_1.vars.pos_adj_layer, var_53_2)
	SPLCameraSystem:initDim(arg_53_1.vars.dim_layer)
end

SPLSystem.InitList.UI = {}
SPLSystem.InitList.UI.Priority = 7

function SPLSystem.InitList.UI.Func(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_1.vars.ui_layer
	local var_54_1 = arg_54_1.vars.field_ui_layer
	
	SPLMainUI:init(var_54_0)
	SPLFieldUI:init(var_54_1)
end

SPLSystem.InitList.Story = {}
SPLSystem.InitList.Story.Priority = 7

function SPLSystem.InitList.Story.Func(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_1.vars.story_layer
	
	SPLStorySystem:init(var_55_0)
end

SPLSystem.InitList.BG = {}
SPLSystem.InitList.BG.Priority = 7

function SPLSystem.InitList.BG.Func(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_1.vars.bg_layer
	
	SPLBGRenderer:init(var_56_0)
	
	local var_56_1 = arg_56_1:getCurrentBgm()
	
	if var_56_1 then
		SoundEngine:playBGM("event:/bgm/" .. var_56_1)
	end
end

SPLSystem.InitList.UIEvent = {}
SPLSystem.InitList.UIEvent.Priority = 98

function SPLSystem.InitList.UIEvent.Func(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_1.vars.parent_layer
	local var_57_1 = cc.Director:getInstance():getEventDispatcher()
	
	if get_cocos_refid(SPL_MOUSE_EVENT) then
		var_57_1:removeEventListener(SPL_MOUSE_EVENT)
		
		SPL_MOUSE_EVENT = nil
	end
	
	if PLATFORM == "win32" then
		local var_57_2 = var_57_0:getEventDispatcher()
		local var_57_3 = cc.EventListenerMouse:create()
		
		var_57_3:registerScriptHandler(function(arg_58_0, arg_58_1)
			SPLSystem:onMouseWheel(arg_58_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_57_2:addEventListenerWithSceneGraphPriority(var_57_3, var_57_0)
		
		SPL_MOUSE_EVENT = var_57_3
	end
end

SPLSystem.InitList.Debug = {}
SPLSystem.InitList.Debug.Priority = 99

function SPLSystem.InitList.Debug.Func(arg_59_0, arg_59_1)
end
