LotaSystem = {}
LotaSystemInterface = {
	onCheckPos = function(arg_1_0)
		return LotaSystem:onCheckPos(arg_1_0)
	end,
	onScale = function(arg_2_0)
		LotaSystem:onScale(arg_2_0)
	end,
	onMouseWheel = function(arg_3_0)
		LotaSystem:onMouseWheel(arg_3_0)
	end,
	onKeyDown = function(arg_4_0)
		LotaSystem:onKeyDown(arg_4_0)
	end,
	onTouchDown = function(arg_5_0, arg_5_1)
		LotaSystem:onTouchDown(arg_5_0, arg_5_1)
	end,
	onTouchMove = function(arg_6_0, arg_6_1)
		LotaSystem:onTouchMove(arg_6_0, arg_6_1)
	end,
	onTouchUp = function(arg_7_0, arg_7_1)
		LotaSystem:onTouchUp(arg_7_0, arg_7_1)
	end
}

function LotaSystem.createLayer(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = cc.Node:create()
	
	var_8_0:setLocalZOrder(arg_8_2)
	var_8_0:setPosition(arg_8_3, arg_8_4)
	var_8_0:setCascadeColorEnabled(true)
	var_8_0:setName(arg_8_1)
	
	return var_8_0
end

function LotaSystem.injectionPivotFunctions(arg_9_0)
	arg_9_0.vars.pivot._setPosition = arg_9_0.vars.pivot.setPosition
	arg_9_0.vars.pivot._setPositionX = arg_9_0.vars.pivot.setPositionX
	arg_9_0.vars.pivot._setPositionY = arg_9_0.vars.pivot.setPositionY
	arg_9_0.vars.pivot._setScale = arg_9_0.vars.pivot.setScale
	arg_9_0.vars.pivot._setScaleX = arg_9_0.vars.pivot.setScaleX
	arg_9_0.vars.pivot._setScaleY = arg_9_0.vars.pivot.setScaleY
	
	function arg_9_0.vars.pivot.setPosition(arg_10_0, arg_10_1, arg_10_2)
		arg_10_0:_setPosition(arg_10_1, arg_10_2)
		LotaFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_9_0.vars.fog_behind_layer) then
			arg_9_0.vars.fog_behind_layer:setPosition(arg_10_1, arg_10_2)
		end
		
		if get_cocos_refid(arg_9_0.vars.fog_ahead_layer) then
			arg_9_0.vars.fog_ahead_layer:setPosition(arg_10_1, arg_10_2)
		end
		
		LotaCameraSystem:objectCulling()
		LotaBGRenderer:syncPosition()
	end
	
	function arg_9_0.vars.pivot.setPositionX(arg_11_0, arg_11_1)
		arg_11_0:_setPositionX(arg_11_1)
		LotaFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_9_0.vars.fog_behind_layer) then
			arg_9_0.vars.fog_behind_layer:setPositionX(arg_11_1)
		end
		
		if get_cocos_refid(arg_9_0.vars.fog_ahead_layer) then
			arg_9_0.vars.fog_ahead_layer:setPositionX(arg_11_1)
		end
		
		LotaCameraSystem:objectCulling()
		LotaBGRenderer:syncPosition()
	end
	
	function arg_9_0.vars.pivot.setPositionY(arg_12_0, arg_12_1)
		arg_12_0:setPositionY(arg_12_1)
		LotaFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_9_0.vars.fog_behind_layer) then
			arg_9_0.vars.fog_behind_layer:setPositionY(arg_12_1)
		end
		
		if get_cocos_refid(arg_9_0.vars.fog_ahead_layer) then
			arg_9_0.vars.fog_ahead_layer:setPositionY(arg_12_1)
		end
		
		LotaCameraSystem:objectCulling()
		LotaBGRenderer:syncPosition()
	end
	
	function arg_9_0.vars.pivot.setScale(arg_13_0, arg_13_1)
		arg_13_0:_setScale(arg_13_1)
		LotaMovableRenderer:updateMovableInfoUIScale()
		LotaObjectRenderer:updateMonsterInfoUIScale()
		LotaCameraSystem:setScaleJustValue(arg_13_1)
		LotaFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_9_0.vars.fog_behind_layer) then
			arg_9_0.vars.fog_behind_layer:setScale(arg_13_1)
		end
		
		if get_cocos_refid(arg_9_0.vars.fog_ahead_layer) then
			arg_9_0.vars.fog_ahead_layer:setScale(arg_13_1)
		end
	end
	
	function arg_9_0.vars.pivot.setScaleX(arg_14_0, arg_14_1)
		arg_14_0:_setScaleX(arg_14_1)
		LotaMovableRenderer:updateMovableInfoUIScale()
		LotaObjectRenderer:updateMonsterInfoUIScale()
		LotaCameraSystem:setScaleJustValue(arg_14_1)
		LotaFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_9_0.vars.fog_behind_layer) then
			arg_9_0.vars.fog_behind_layer:setScaleX(arg_14_1)
		end
		
		if get_cocos_refid(arg_9_0.vars.fog_ahead_layer) then
			arg_9_0.vars.fog_ahead_layer:setScaleX(arg_14_1)
		end
	end
	
	function arg_9_0.vars.pivot.setScaleY(arg_15_0, arg_15_1)
		arg_15_0:_setScaleY(arg_15_1)
		LotaMovableRenderer:updateMovableInfoUIScale()
		LotaObjectRenderer:updateMonsterInfoUIScale()
		LotaCameraSystem:setScaleJustValue(arg_15_1)
		LotaFogRenderer:syncPosition()
		
		if get_cocos_refid(arg_9_0.vars.fog_behind_layer) then
			arg_9_0.vars.fog_behind_layer:setScaleY(arg_15_1)
		end
		
		if get_cocos_refid(arg_9_0.vars.fog_ahead_layer) then
			arg_9_0.vars.fog_ahead_layer:setScaleY(arg_15_1)
		end
	end
end

function LotaSystem.initSystems(arg_16_0, arg_16_1)
	local var_16_0 = LotaUserData:documentToInterface(arg_16_1.user_default, arg_16_1.user_artifact_doc, arg_16_1.user_register)
	
	LotaUserData:init(var_16_0)
	LotaUserData:updateStartLegacyRefreshCount(arg_16_1.start_legacy_refresh_count)
	LotaOverSceneDataSystem:init()
	LotaWhiteboard:init()
	LotaWhiteboard:set("field_z_order", 1)
	
	local var_16_1 = 300
	local var_16_2 = 300
	
	LotaWhiteboard:set("field_layer_x", var_16_1)
	LotaWhiteboard:set("field_layer_y", var_16_2)
	arg_16_0:_addDebugPerformanceTracker("LotaSystem:initSystems:createCocosObjects", "start")
	
	arg_16_0.vars.pivot = arg_16_0:createLayer("pivot", 0, 0, 0)
	
	arg_16_0:injectionPivotFunctions()
	
	arg_16_0.vars.fog_behind_layer = arg_16_0:createLayer("fog_behind_layer", 1, 0, 0)
	arg_16_0.vars.field_layer = arg_16_0:createLayer("field_layer", 1, var_16_1, var_16_2)
	
	arg_16_0.vars.fog_behind_layer:addChild(arg_16_0.vars.field_layer)
	
	arg_16_0.vars.fog_layer = arg_16_0:createLayer("fog_layer", 2, 0, VIEW_HEIGHT / 2)
	arg_16_0.vars.fog_ahead_layer = arg_16_0:createLayer("fog_ahead_layer", 3, 0, 0)
	arg_16_0.vars.object_layer = arg_16_0:createLayer("player_layer", 2, var_16_1, var_16_2)
	arg_16_0.vars.effect_layer = arg_16_0:createLayer("effect_layer", 3, var_16_1, var_16_2)
	
	arg_16_0.vars.fog_ahead_layer:addChild(arg_16_0.vars.object_layer)
	arg_16_0.vars.fog_ahead_layer:addChild(arg_16_0.vars.effect_layer)
	
	arg_16_0.vars.field_pivot_layer = arg_16_0:createLayer("field_pivot_layer", 5, 0, 0)
	arg_16_0.vars.ping_field_ui_layer = arg_16_0:createLayer("ping_field_ui_layer", 0, var_16_1, var_16_2)
	arg_16_0.vars.monster_field_ui_layer = arg_16_0:createLayer("monster_field_ui_layer", 1, var_16_1, var_16_2)
	arg_16_0.vars.movable_field_ui_layer = arg_16_0:createLayer("movable_field_ui_layer", 2, var_16_1, var_16_2)
	arg_16_0.vars.effect_field_ui_layer = arg_16_0:createLayer("effect_field_ui_layer", 3, var_16_1, var_16_2)
	arg_16_0.vars.field_ui_layer = arg_16_0:createLayer("field_ui_layer", 5, var_16_1, var_16_2)
	
	arg_16_0.vars.monster_field_ui_layer:setCascadeOpacityEnabled(true)
	arg_16_0.vars.movable_field_ui_layer:setCascadeOpacityEnabled(true)
	arg_16_0.vars.ping_field_ui_layer:setCascadeOpacityEnabled(true)
	arg_16_0.vars.field_pivot_layer:addChild(arg_16_0.vars.monster_field_ui_layer)
	arg_16_0.vars.field_pivot_layer:addChild(arg_16_0.vars.movable_field_ui_layer)
	arg_16_0.vars.field_pivot_layer:addChild(arg_16_0.vars.effect_field_ui_layer)
	arg_16_0.vars.field_pivot_layer:addChild(arg_16_0.vars.ping_field_ui_layer)
	arg_16_0.vars.field_pivot_layer:addChild(arg_16_0.vars.field_ui_layer)
	arg_16_0.vars.layer:addChild(arg_16_0.vars.pivot)
	arg_16_0.vars.layer:addChild(arg_16_0.vars.fog_behind_layer)
	arg_16_0.vars.layer:addChild(arg_16_0.vars.fog_layer)
	arg_16_0.vars.layer:addChild(arg_16_0.vars.fog_ahead_layer)
	
	local var_16_3
	local var_16_4
	local var_16_5 = false
	
	if var_16_5 then
		var_16_3 = su.SimplePostProcessLayer:create()
		
		var_16_3:setName("post_process_layer")
		
		local var_16_6 = cc.GLProgramCache:getInstance():getGLProgram("pp_color_blend")
		
		if var_16_6 then
			local var_16_7 = cc.GLProgramState:create(var_16_6)
			
			if var_16_7 then
				local var_16_8 = 0.2
				local var_16_9 = DB("clan_heritage_world", arg_16_0:getWorldId(), "ambient_color") or "FFFFFF"
				
				if not PRODUCTION_MODE and DEBUG.LOTA_SET_COLOR then
					var_16_9 = DEBUG.LOTA_SET_COLOR
				end
				
				local var_16_10 = "#" .. var_16_9
				local var_16_11 = tocolor(var_16_10)
				local var_16_12 = cc.mat4.new({
					1,
					0,
					0,
					0,
					0,
					1,
					0,
					0,
					0,
					0,
					1,
					0,
					0,
					0,
					0,
					1
				})
				
				var_16_7:setUniformMat4("u_ColorMatrix", var_16_12)
				var_16_7:setUniformVec4("u_BlendColor", cc.vec4(var_16_11.r / 255, var_16_11.g / 255, var_16_11.b / 255, var_16_8 or 0))
				var_16_3:setPostProcessEnabled(true)
				var_16_3:addProcessGLProgramState(var_16_7, "", 5, 0)
				
				arg_16_0.vars._game_layer_pst = var_16_7
			end
		end
		
		LotaWhiteboard:set("ambient_color", cc.c3b(255, 255, 255))
	else
		local var_16_13 = DB("clan_heritage_world", arg_16_0:getWorldId(), "ambient_color") or "FFFFFF"
		
		if not PRODUCTION_MODE and DEBUG.LOTA_SET_COLOR then
			var_16_13 = DEBUG.LOTA_SET_COLOR
		end
		
		local var_16_14 = "#" .. var_16_13
		local var_16_15 = tocolor(var_16_14)
		
		var_16_3 = cc.Node:create()
	end
	
	LotaWhiteboard:set("ambient_color", cc.c3b(255, 255, 255))
	var_16_3:setName("post_process_layer")
	LotaWhiteboard:set("low_spec", SAVE:get("lota_low_spec", false))
	
	arg_16_0.vars.pp_layer = var_16_3
	
	arg_16_0.vars.pp_layer:ignoreAnchorPointForPosition(true)
	
	local var_16_16 = cc.Node:create()
	
	var_16_16:setPositionX(VIEW_BASE_LEFT)
	var_16_16:addChild(arg_16_0.vars.pp_layer)
	var_16_16:addChild(arg_16_0.vars.field_ui_parent_layer)
	arg_16_0.vars.parent_layer:addChild(var_16_16)
	
	local var_16_17 = LotaClanInfo:documentToInterface(arg_16_1.clan_base, arg_16_1.dead_boss_info)
	
	LotaClanInfo:init(var_16_17)
	LotaCameraSystem:init(arg_16_0.vars.layer, arg_16_0.vars.pp_layer, arg_16_0.vars.pivot)
	LotaCameraSystem:attachUIPivot(arg_16_0.vars.field_pivot_layer, arg_16_0.vars.field_ui_parent_layer)
	arg_16_0:_addDebugPerformanceTracker("LotaSystem:initSystems:createCocosObjects", "end")
	arg_16_0:_addDebugPerformanceTracker("LotaSystem:initSystems:LotaTileMapSystem", "start")
	LotaTileMapSystem:init(arg_16_0.vars.field_layer, arg_16_0:getMapId())
	arg_16_0:_addDebugPerformanceTracker("LotaSystem:initSystems:LotaTileMapSystem", "end")
	LotaFogSystem:init(arg_16_0.vars.fog_layer, arg_16_0:getMapId())
	LotaObjectSystem:init(arg_16_0.vars.object_layer, arg_16_0:getMapId())
	LotaPingSystem:init(arg_16_0.vars.ping_field_ui_layer)
	LotaMovableSystem:init(arg_16_0.vars.object_layer)
	LotaBoxSystem:init()
	LotaEffectRenderer:init(arg_16_0.vars.effect_layer)
	LotaBattleDataSystem:init()
	LotaBattleSlotSystem:init()
	LotaNetworkSystem:init(arg_16_0.vars.layer)
	LotaNetworkSystem:updateLastTm(arg_16_1.last_update_tm)
	LotaNetworkSystem:updateExpLastTm(arg_16_1.last_update_tm)
end

function LotaSystem.initVariables(arg_17_0)
end

function LotaSystem.leaveScene(arg_18_0)
	print("Lota.leaveScene")
	LotaTileRenderer:close()
	LotaObjectRenderer:release()
	LotaMovableRenderer:close()
	LotaFogRenderer:close()
	LotaEffectRenderer:close()
	LotaUIMainLayer:close()
	LotaMinimapRenderer:close()
	
	if get_cocos_refid(arg_18_0.vars.ui_layer) then
		arg_18_0.vars.ui_layer:removeFromParent()
	end
	
	if get_cocos_refid(arg_18_0.vars.layer) then
		arg_18_0.vars.layer:removeFromParent()
	end
	
	LotaCameraSystem:close()
end

function LotaSystem.closeSystem(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	LotaNetworkSystem:close()
	LotaBattleDataSystem:close()
	LotaTileMapSystem:close()
	LotaObjectSystem:close()
	LotaMovableSystem:close()
	LotaFogSystem:close()
	LotaEffectRenderer:close()
	LotaCameraSystem:close()
	LotaUIMainLayer:close()
	LotaMinimapRenderer:close()
	LotaClanInfo:close()
	
	if get_cocos_refid(arg_19_0.vars.ui_layer) then
		arg_19_0.vars.ui_layer:removeFromParent()
	end
	
	if get_cocos_refid(arg_19_0.vars.layer) then
		arg_19_0.vars.layer:removeFromParent()
	end
	
	arg_19_0.vars = nil
end

function LotaSystem.onConfirmStartPoint(arg_20_0, arg_20_1)
	arg_20_0.vars.player_info.pos = LotaTileMapSystem:getTileById(arg_20_1):getPos()
	
	LotaMovableSystem:addPlayerMovable(arg_20_0.vars.player_info)
	LotaUserData:onConfirmStartPoint()
	LotaStartingPointUI:close()
	LotaSystem:initGameUI()
	LotaFogSystem:renderFogs()
	
	local var_20_0 = LotaMovableSystem:getPlayerPos()
	
	LotaMinimapRenderer:setPosCenter(var_20_0, true)
	
	arg_20_0.vars.player_info = nil
end

function LotaSystem.initGameUI(arg_21_0)
	LotaUIMainLayer:init(arg_21_0.vars.ui_layer)
	LotaMinimapRenderer:init(arg_21_0.vars.ui_layer:findChildByName("clip_panel"))
end

function LotaSystem.updateGameUI(arg_22_0)
	LotaMinimapRenderer:draw(LotaTileMapSystem:getTileMapData())
	
	local var_22_0 = LotaMovableSystem:getPlayerPos()
	
	if var_22_0 then
		LotaMinimapRenderer:setPosCenter(var_22_0, true)
	end
	
	LotaUIMainLayer:updateUI()
end

function LotaSystem.initUI(arg_23_0)
	arg_23_0.vars.ui_layer = cc.Node:create()
	
	arg_23_0.vars.ui_layer:setLocalZOrder(1)
	arg_23_0.vars.ui_layer:setCascadeOpacityEnabled(true)
	
	arg_23_0.vars.ui_popup_layer = cc.Node:create()
	
	arg_23_0.vars.ui_popup_layer:setLocalZOrder(2)
	arg_23_0.vars.ui_popup_layer:setCascadeOpacityEnabled(true)
	
	arg_23_0.vars.ui_dialog_layer = cc.Node:create()
	
	arg_23_0.vars.ui_dialog_layer:setLocalZOrder(3)
	arg_23_0.vars.ui_dialog_layer:setCascadeOpacityEnabled(true)
	arg_23_0.vars.parent_layer:addChild(arg_23_0.vars.ui_layer)
	arg_23_0.vars.parent_layer:addChild(arg_23_0.vars.ui_popup_layer)
	arg_23_0.vars.parent_layer:addChild(arg_23_0.vars.ui_dialog_layer)
	
	if not LotaUserData:isRequireSettingStartPoint() then
		arg_23_0:initGameUI()
	else
		LotaStartingPointUI:init(arg_23_0.vars.ui_layer)
	end
end

function LotaSystem.createDim(arg_24_0)
	arg_24_0.vars.dim_layer = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	arg_24_0.vars.dim_layer:setLocalZOrder(2)
	arg_24_0.vars.dim_layer:setPositionX(VIEW_BASE_LEFT)
	arg_24_0.vars.parent_layer:addChild(arg_24_0.vars.dim_layer)
	
	arg_24_0.vars.letter_box1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	arg_24_0.vars.letter_box2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	arg_24_0.vars.letter_box1:setName("letter_box1")
	arg_24_0.vars.letter_box2:setName("letter_box2")
	arg_24_0.vars.letter_box1:setPosition(VIEW_BASE_LEFT, 800)
	arg_24_0.vars.letter_box2:setPosition(VIEW_BASE_LEFT, -800 - HEIGHT_MARGIN)
	arg_24_0.vars.parent_layer:addChild(arg_24_0.vars.letter_box1)
	arg_24_0.vars.parent_layer:addChild(arg_24_0.vars.letter_box2)
	if_set_opacity(arg_24_0.vars.dim_layer, nil, 0)
end

function LotaSystem.getLetterBoxes(arg_25_0)
	return arg_25_0.vars.letter_box1, arg_25_0.vars.letter_box2
end

function LotaSystem.isActive(arg_26_0)
	return arg_26_0.vars and get_cocos_refid(arg_26_0.vars.layer)
end

function LotaSystem.getDimLayer(arg_27_0)
	return arg_27_0.vars.dim_layer
end

function LotaSystem.getCurrentSeasonDB(arg_28_0)
	return arg_28_0.vars.season_db
end

function LotaSystem.setupSchedule(arg_29_0, arg_29_1)
	arg_29_0.vars.current_schedule = LotaUtil:getCurrentScheduleData(arg_29_1.schedule_info)
	arg_29_0.vars.schedules = arg_29_1.schedule_info
	
	local var_29_0 = LotaUserData:getCurrentSeasonDB(arg_29_0.vars.current_schedule)
	
	arg_29_0.vars.season_db = var_29_0
end

function LotaSystem.preSetInfo(arg_30_0, arg_30_1)
	LotaUserData:setReqStartPointSetting(false)
end

function LotaSystem.setInfo(arg_31_0, arg_31_1)
	local var_31_0
	local var_31_1
	
	if DEBUG.LOTA_STR_TEST then
		var_31_1 = {
			50,
			92,
			135
		}
		
		for iter_31_0 = 1, 3 do
			local var_31_2 = var_31_1[iter_31_0]
			
			for iter_31_1 = 1, 10 do
				table.insert(arg_31_1.members, {
					dir = 2,
					floor = 4,
					tile_id = var_31_2 + iter_31_1,
					leader_code = string.format("c10%02d", iter_31_0 * 10 + iter_31_1),
					id = iter_31_0 * 10 + iter_31_1,
					name = "TEST" .. iter_31_0 * 10 + iter_31_1
				})
			end
		end
	end
	
	arg_31_0:_addDebugPerformanceTracker("LotaSystem:setInfo:add_movable", "start")
	
	for iter_31_2, iter_31_3 in pairs(arg_31_1.members) do
		iter_31_3.dir = 1 or -1
		
		if iter_31_3.id == AccountData.id then
			var_31_0 = iter_31_3
		else
			local var_31_3 = LotaTileMapSystem:getTileById(iter_31_3.tile_id)
			
			if var_31_3 then
				iter_31_3.pos = var_31_3:getPos()
			end
			
			LotaMovableSystem:addMovable(iter_31_3, true)
		end
	end
	
	arg_31_0:_addDebugPerformanceTracker("LotaSystem:setInfo:add_movable", "end")
	arg_31_0:_addDebugPerformanceTracker("LotaSystem:setInfo:object", "start")
	
	var_31_0.pos = LotaTileMapSystem:getTileById(var_31_0.tile_id):getPos()
	
	local var_31_4 = LotaUserData:getFloorKey()
	local var_31_5 = arg_31_1.floor_objects.clan
	local var_31_6 = arg_31_1.floor_objects.user
	
	arg_31_0.vars.discover_poses = {}
	
	for iter_31_4, iter_31_5 in pairs(var_31_5) do
		local var_31_7 = LotaTileMapSystem:getTileById(tostring(iter_31_5.tile_id))
		
		if not var_31_7 then
			local var_31_8 = "NOT EXIST TILE, BUT EXIST OBJECT! TILE_ID : " .. tostring(iter_31_5.tile_id) .. " OBJECT ID " .. tostring(iter_31_5.object)
			
			error(var_31_8)
		end
		
		LotaObjectSystem:debug_addObject(var_31_7, iter_31_5.object, iter_31_5)
		
		local var_31_9 = DB("clan_heritage_object_data", iter_31_5.object_id, "type_2")
		
		if var_31_9 == "keeper_monster" then
			local var_31_10 = LotaTileMapSystem:getPosById(tostring(iter_31_5.tile_id))
			
			table.insert(arg_31_0.vars.discover_poses, var_31_10)
		end
		
		if var_31_9 == "boss_monster" then
			local var_31_11 = LotaTileMapSystem:getPosById(tostring(iter_31_5.tile_id))
			
			table.insert(arg_31_0.vars.discover_poses, var_31_11)
			
			arg_31_0.vars.boss_pos = var_31_11
		end
		
		if var_31_9 == "portal" then
			local var_31_12 = LotaTileMapSystem:getPosById(tostring(iter_31_5.tile_id))
			
			table.insert(arg_31_0.vars.discover_poses, var_31_12)
		end
	end
	
	for iter_31_6, iter_31_7 in pairs(var_31_6) do
		local var_31_13 = LotaTileMapSystem:getTileById(tostring(iter_31_7.tile_id))
		
		if not var_31_13 then
			local var_31_14 = "NOT EXIST TILE, BUT EXIST OBJECT! TILE_ID : " .. tostring(iter_31_7.tile_id) .. " OBJECT ID " .. tostring(iter_31_7.object)
			
			error(var_31_14)
		end
		
		LotaObjectSystem:debug_addObject(var_31_13, iter_31_7.object, iter_31_7)
	end
	
	if arg_31_1.update_objects then
		LotaObjectSystem:updateObjectStatus(arg_31_1.update_objects)
	end
	
	arg_31_0:_addDebugPerformanceTracker("LotaSystem:setInfo:object", "end")
	
	local var_31_15 = arg_31_1.user_battle_data
	
	for iter_31_8, iter_31_9 in pairs(var_31_15) do
		LotaBattleDataSystem:addReward(iter_31_9)
	end
	
	LotaBoxSystem:updateBoxList(arg_31_1.box_list)
	LotaMovableSystem:addPlayerMovable(var_31_0)
	
	for iter_31_10, iter_31_11 in pairs(arg_31_1.members) do
		if iter_31_11.id ~= AccountData.id and tostring(iter_31_11.floor) == var_31_4 then
			local var_31_16 = LotaTileMapSystem:getTileById(iter_31_11.tile_id)
			
			if var_31_16 then
				LotaFogSystem:onAnotherPlayerConfirmStartPos(var_31_16:getPos())
			end
		end
	end
	
	LotaPingSystem:updatePingStatus(arg_31_1.ping_status)
	arg_31_0:updateGameUI()
	LotaBattleSlotSystem:updateBattleSlots(arg_31_1.slot_list)
	arg_31_0:_addDebugPerformanceTracker("LotaSystem:setInfo:parsingFogMap", "start")
	arg_31_0:parsingFogMap(arg_31_1)
	arg_31_0:_addDebugPerformanceTracker("LotaSystem:setInfo:parsingFogMap", "end")
	LotaPingRenderer:updatePingOpacity()
end

function LotaSystem.parsingFogMap(arg_32_0, arg_32_1)
	LotaFogSystem:parsingFogMap(arg_32_1.fog, LotaFogVisibilityEnum.DISCOVER)
	LotaFogSystem:parsingFogMap(arg_32_1.view, LotaFogVisibilityEnum.VISIBLE)
end

function LotaSystem.updateFog(arg_33_0, arg_33_1)
	if not arg_33_0.vars._debug_update_fog_call then
		arg_33_0.vars._debug_update_fog_call = 0
	end
	
	arg_33_0.vars._debug_update_fog_call = arg_33_0.vars._debug_update_fog_call + 1
	
	arg_33_0:_addDebugPerformanceTracker("updateFog:discover:" .. arg_33_0.vars._debug_update_fog_call, "start")
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.discover_poses) do
		LotaFogSystem:onlyDiscover(iter_33_1.x, iter_33_1.y, 0, LotaFogVisibilityEnum.DISCOVER)
	end
	
	arg_33_0:_addDebugPerformanceTracker("updateFog:discover:" .. arg_33_0.vars._debug_update_fog_call, "end")
	arg_33_0:_addDebugPerformanceTracker("updateFog:minimapRenderer:" .. arg_33_0.vars._debug_update_fog_call, "start")
	LotaMinimapRenderer:updateFogAll(LotaTileMapSystem:getTileMapData())
	arg_33_0:_addDebugPerformanceTracker("updateFog:minimapRenderer:" .. arg_33_0.vars._debug_update_fog_call, "end")
end

function LotaSystem.procDialog(arg_34_0)
	if LotaUserData:isRequireSelectArtifacts() then
		LotaLegacySelectUI:open(LotaSystem:getUIDialogLayer(), LotaUserData:getSelectableArtifacts())
		
		return 
	end
	
	local var_34_0 = LotaObjectSystem:getObjectsByType("event")
	
	for iter_34_0, iter_34_1 in pairs(var_34_0 or {}) do
		if iter_34_1 and iter_34_1:isUsableEvent() then
			LotaEventSystem:onResponseEventData(iter_34_1:getUID(), iter_34_1:getEventId())
			
			return 
		end
	end
end

function LotaSystem._addDebugPerformanceTracker(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0._debug then
		arg_35_0._debug = {}
	end
	
	if not arg_35_0._debug[arg_35_1] then
		arg_35_0._debug[arg_35_1] = {}
	end
	
	if arg_35_2 == "start" then
		arg_35_0._debug[arg_35_1].start_tm = uitick()
	else
		arg_35_0._debug[arg_35_1].end_tm = uitick()
	end
end

function LotaSystem._showPT(arg_36_0)
	local var_36_0 = {}
	
	for iter_36_0, iter_36_1 in pairs(arg_36_0._debug) do
		local var_36_1 = string.split(iter_36_0, ":")
		local var_36_2 = table.count(var_36_1)
		local var_36_3 = var_36_1[var_36_2]
		local var_36_4 = var_36_0
		
		for iter_36_2 = 1, var_36_2 - 1 do
			if not var_36_4[var_36_1[iter_36_2]] then
				var_36_4[var_36_1[iter_36_2]] = {
					childs = {},
					name = var_36_1[iter_36_2]
				}
			end
			
			var_36_4 = var_36_4[var_36_1[iter_36_2]].childs
		end
		
		if not var_36_4[var_36_3] then
			var_36_4[var_36_3] = {
				childs = {},
				name = var_36_3
			}
		end
		
		var_36_4[var_36_3].tm = iter_36_1.end_tm - iter_36_1.start_tm
	end
	
	for iter_36_3, iter_36_4 in pairs(var_36_0) do
		print(iter_36_4.name, " processed in : ", iter_36_4.tm)
		
		if iter_36_4.childs then
			for iter_36_5, iter_36_6 in pairs(iter_36_4.childs) do
				print("     - " .. iter_36_6.name, " child in : ", iter_36_6.tm)
				
				if iter_36_6.childs then
					for iter_36_7, iter_36_8 in pairs(iter_36_6.childs) do
						print("          - " .. iter_36_8.name, " child in : ", iter_36_8.tm)
					end
				end
			end
		end
	end
end

function lspt()
	LotaSystem:_showPT()
end

function LotaSystem.requestAutoHandlingEffects(arg_38_0)
	local var_38_0 = false
	local var_38_1 = {}
	local var_38_2 = arg_38_0.vars.executed_effects
	
	if arg_38_0.vars.info.first_enter and not var_38_2.first_enter then
		var_38_2.first_enter = true
		
		arg_38_0:startOpeningEffect()
		
		return 
	elseif LotaOverSceneDataSystem:get("lota_next_floor") and not var_38_2.first_enter then
		var_38_2.first_enter = true
		
		arg_38_0:startOpeningEffect()
		LotaOverSceneDataSystem:clear("lota_next_floor")
		
		return 
	end
	
	if LotaUserData:isRequireSelectArtifacts() and not var_38_2.select_artifact then
		LotaLegacySelectUI:open(LotaSystem:getUIDialogLayer(), LotaUserData:getSelectableArtifacts())
		
		var_38_2.select_artifact = true
		
		return 
	end
	
	if not var_38_2.req_event_check then
		var_38_2.req_event_check = true
		
		local var_38_3 = LotaObjectSystem:getObjectsByType("event")
		
		for iter_38_0, iter_38_1 in pairs(var_38_3 or {}) do
			if iter_38_1 and iter_38_1:isUsableEvent() then
				LotaEventSystem:onResponseEventData(iter_38_1:getUID(), iter_38_1:getEventId())
				
				return 
			end
		end
	end
	
	if arg_38_0:requireBossAppearEffect() then
		arg_38_0:bossAppearEffect()
		
		return 
	end
	
	if arg_38_0:requireBossDeadEffect() then
		if arg_38_0:isFinalFloor() then
			arg_38_0:newBossEffect()
		else
			arg_38_0:nextFloorEffect()
		end
		
		return 
	end
	
	if not var_38_2.guide_ui then
		var_38_2.guide_ui = true
		
		LotaUIMainLayer:addGuideEffect()
	end
	
	LotaObjectRenderer:procRequestEffects()
	
	if TutorialGuide:isClearedTutorial("tuto_heritage_legacy") then
		TutorialGuide:startGuide("tuto_heritage_quest")
	end
	
	if not var_38_2.enter_scene_lv_up then
		var_38_2.enter_scene_lv_up = true
		
		arg_38_0:procLevelUp()
		
		return 
	else
		LotaUserData:procLevelUp()
	end
end

function LotaSystem.init(arg_39_0, arg_39_1, arg_39_2)
	arg_39_0:_addDebugPerformanceTracker("LotaSystem", "start")
	
	arg_39_0.vars = {}
	arg_39_0.vars.info = arg_39_2 or {}
	arg_39_0.vars.event_info = arg_39_2.event
	arg_39_0.vars.parent_layer = arg_39_1
	arg_39_0.vars.executed_effects = {}
	arg_39_0.vars.layer = cc.Node:create()
	
	arg_39_0.vars.layer:setLocalZOrder(0)
	arg_39_0.vars.layer:setCascadeColorEnabled(false)
	
	arg_39_0.vars.field_ui_parent_layer = cc.Node:create()
	
	arg_39_0.vars.field_ui_parent_layer:setLocalZOrder(1)
	arg_39_0:setupSchedule(arg_39_2)
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:initSystems", "start")
	arg_39_0:initSystems(arg_39_2)
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:initSystems", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:initVariables", "start")
	arg_39_0:initVariables()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:initVariables", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:preSetInfo", "start")
	arg_39_0:preSetInfo(arg_39_2)
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:preSetInfo", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:initUI", "start")
	arg_39_0:initUI()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:initUI", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:addEvent", "start")
	arg_39_0:addEvent()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:addEvent", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:setInfo", "start")
	arg_39_0:setInfo(arg_39_0.vars.info)
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:setInfo", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:createDim", "start")
	arg_39_0:createDim()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:createDim", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:updateFog", "start")
	arg_39_0:updateFog(arg_39_0.vars.info)
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:updateFog", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:etc", "start")
	arg_39_0:setPlayScale()
	LotaCameraSystem:setCameraPlayerPos()
	arg_39_0:debug_setDebugData()
	LotaMovableSystem:drawMovableArea()
	
	if arg_39_2.first_enter then
		arg_39_0:removeAllBossAppearSaveData()
	end
	
	arg_39_0:requestAutoHandlingEffects()
	LotaUIMainLayer:updateVisibleButtons(LotaMovableSystem:isPlayerOutScreen())
	LotaMovableRenderer:updateMovableInfoUIScale()
	LotaObjectRenderer:updateMonsterInfoUIScale()
	
	local var_39_0 = arg_39_0:getCurrentBGM()
	
	if var_39_0 then
		SoundEngine:playBGM("event:/bgm/" .. var_39_0)
	end
	
	LotaBGRenderer:init(arg_39_1)
	LotaNetworkSystem:acceptAllContentsQueryAndReceive()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:etc", "end")
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:renderFogs", "start")
	LotaFogSystem:renderFogs()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem:renderFogs", "end")
	LotaCameraSystem:objectCulling()
	arg_39_0:_addDebugPerformanceTracker("LotaSystem", "end")
end

function LotaSystem.isAvailableExecuteEffect(arg_40_0)
	return not TutorialGuide:isPlayingTutorial() and LotaSystem:isPopupEmpty() and LotaSystem:isDialogEmpty()
end

function LotaSystem.isAvailableEnterWaitMode(arg_41_0)
	return not TutorialGuide:isPlayingTutorial() and LotaSystem:isPopupEmpty() and LotaSystem:isDialogEmpty()
end

function LotaSystem.procInputWaitMode(arg_42_0)
	if not arg_42_0.vars or arg_42_0.vars.input_wait_mode then
		return 
	end
	
	if not arg_42_0:isAvailableEnterWaitMode() then
		return 
	end
	
	arg_42_0.vars.input_wait_mode = true
	arg_42_0.vars.last_camera_status = LotaCameraSystem:saveCameraStatus()
	
	UIAction:Add(SEQ(TARGET(arg_42_0.vars.dim_layer, FADE_IN(500)), CALL(function()
		LotaCameraSystem:setScale(LotaCameraSystem:getPlayScale() * 2)
		LotaCameraSystem:setCameraPlayerPos()
		LotaCameraSystem:moveCameraPos(0, -150)
		
		local var_43_0 = LotaMovableSystem:getPlayerPos()
		local var_43_1 = LotaUtil:calcTilePosToWorldPos(var_43_0)
		local var_43_2 = 150
		local var_43_3 = LotaUtil:makeVignetting(var_43_1.x, var_43_1.y + var_43_2)
		
		LotaSystem:addToEffectFieldUI(var_43_3)
		var_43_3:setScale(0.6)
		var_43_3:setOpacity(204)
		
		arg_42_0.vars.vig_main_node = var_43_3
		
		if_set_visible(arg_42_0.vars.monster_field_ui_layer, nil, false)
		if_set_visible(arg_42_0.vars.movable_field_ui_layer, nil, false)
		if_set_visible(arg_42_0.vars.ping_field_ui_layer, nil, false)
		if_set_visible(arg_42_0.vars.field_ui_layer, nil, false)
		if_set_visible(arg_42_0.vars.ui_layer, nil, false)
		if_set_visible(arg_42_0.vars.ui_popup_layer, nil, false)
		LotaTileRenderer:revertMovableArea(true)
		LotaObjectRenderer:visibleOff()
		LotaMovableRenderer:visibleOnlyCurrentPlayer()
		LotaMovableRenderer:setGroupIconVisible(false)
		LotaPingRenderer:setVisible(false)
		
		if LotaInteractiveUI:isActive() then
			LotaInteractiveUI:close()
		end
	end), DELAY(100), TARGET(arg_42_0.vars.dim_layer, FADE_OUT(500))), arg_42_0.vars.layer, "block")
end

function LotaSystem.procOutInputWaitMode(arg_44_0)
	if not arg_44_0.vars or not arg_44_0.vars.input_wait_mode then
		return 
	end
	
	arg_44_0.vars.input_wait_mode = false
	
	UIAction:Add(SEQ(TARGET(arg_44_0.vars.dim_layer, FADE_IN(500)), CALL(function()
		LotaCameraSystem:loadCameraStatus(arg_44_0.vars.last_camera_status)
		LotaBGRenderer:syncPosition()
		
		if get_cocos_refid(arg_44_0.vars.vig_main_node) then
			arg_44_0.vars.vig_main_node:removeFromParent()
		end
		
		if get_cocos_refid(arg_44_0.vars.pet_model) then
			arg_44_0.vars.pet_model:removeFromParent()
		end
		
		if_set_visible(arg_44_0.vars.monster_field_ui_layer, nil, true)
		if_set_visible(arg_44_0.vars.movable_field_ui_layer, nil, true)
		if_set_visible(arg_44_0.vars.ping_field_ui_layer, nil, true)
		if_set_visible(arg_44_0.vars.field_ui_layer, nil, true)
		if_set_visible(arg_44_0.vars.ui_layer, nil, true)
		if_set_visible(arg_44_0.vars.ui_popup_layer, nil, true)
		LotaCameraSystem:objectCulling()
		LotaMovableSystem:drawMovableArea()
		LotaMovableRenderer:updateMovableInfoUIScale()
		LotaMovableRenderer:setGroupIconVisible(true)
		LotaPingRenderer:updateScale()
		LotaPingRenderer:setVisible(true)
		LotaSystem:updateFieldUIScale()
	end), TARGET(arg_44_0.vars.dim_layer, FADE_OUT(500))), arg_44_0.vars.layer, "block")
end

function LotaSystem.procLevelUp(arg_46_0)
	local var_46_0 = LotaOverSceneDataSystem:get("battle.level_up")
	
	if not table.empty(var_46_0) then
		for iter_46_0, iter_46_1 in pairs(var_46_0) do
			LotaUserData:procLevelUp(iter_46_1.new_lv - iter_46_1.prv_lv)
		end
		
		LotaOverSceneDataSystem:clear("battle.level_up")
	end
end

function LotaSystem.debug_setDebugData(arg_47_0)
	if not DEBUG.ROTA_NETWORK_MOCKING then
		return 
	end
	
	LotaObjectSystem:debug_addFromDB()
	
	if not DEBUG.ROTA_OBJECT_DEBUG then
		return 
	end
	
	local var_47_0 = LotaTileMapSystem:getRandomStartPositionByIdx(1)
	local var_47_1 = LotaTileMapSystem:getRandomStartPositionByIdx(2)
	local var_47_2 = LotaTileMapSystem:getRandomStartPositionByIdx(3)
	local var_47_3 = var_47_0:getPos()
	local var_47_4 = LotaUtil:getAddedPosition(var_47_3, {
		x = 1,
		y = 1
	})
	local var_47_5 = LotaTileMapSystem:getTileByPos(var_47_4)
	
	LotaObjectSystem:debug_addObject(var_47_5, "legacy_1")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 42,
		y = 6
	}), "legacy_1")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 32,
		y = 6
	}), "library_1_01")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 32,
		y = 4
	}), "watchtower_1_01")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 36,
		y = 4
	}), "ststue_1_01")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 38,
		y = 6
	}), "n_monster_1_01")
	
	local var_47_6 = LotaUtil:getAddedPosition(var_47_2:getPos(), {
		x = 2,
		y = 2
	})
	
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos(var_47_6), "e_monster_1_01")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 42,
		y = 2
	}), "b_monster_1_01")
	LotaObjectSystem:debug_addObject(LotaTileMapSystem:getTileByPos({
		x = 44,
		y = 2
	}), "e_monster_1_01")
	
	local var_47_7 = table.clone(LotaEffectDataInterface)
	
	var_47_7.pos = table.clone(var_47_3)
	
	LotaEffectRenderer:addEffectData(var_47_7)
	
	local var_47_8 = table.clone(LotaEffectDataInterface)
	
	var_47_8.pos = table.clone(var_47_6)
	
	LotaEffectRenderer:addEffectData(var_47_8)
	LotaMovableSystem:requestJumpTo(2, var_47_1:getTileId())
	LotaMovableSystem:requestJumpTo(3, var_47_2:getTileId())
end

function LotaSystem.addNodeToFieldUI(arg_48_0, arg_48_1)
	arg_48_0:getFieldUILayer():addChild(arg_48_1)
	arg_48_0:updateFieldUIScale()
end

function LotaSystem.addToMovableFieldUI(arg_49_0, arg_49_1)
	arg_49_0.vars.movable_field_ui_layer:addChild(arg_49_1)
end

function LotaSystem.addToMonsterFieldUI(arg_50_0, arg_50_1)
	arg_50_0.vars.monster_field_ui_layer:addChild(arg_50_1)
end

function LotaSystem.addToEffectFieldUI(arg_51_0, arg_51_1)
	arg_51_0.vars.effect_field_ui_layer:addChild(arg_51_1)
end

function LotaSystem.getMonsterFieldUILayer(arg_52_0)
	return arg_52_0.vars.monster_field_ui_layer
end

function LotaSystem.getFieldUILayer(arg_53_0)
	return arg_53_0.vars.field_ui_layer
end

function LotaSystem.getUILayer(arg_54_0)
	return arg_54_0.vars.ui_layer
end

function LotaSystem.getUIPopupLayer(arg_55_0)
	return arg_55_0.vars.ui_popup_layer
end

function LotaSystem.getUIDialogLayer(arg_56_0)
	return arg_56_0.vars.ui_dialog_layer
end

function LotaSystem.isDialogEmpty(arg_57_0)
	return table.count(arg_57_0.vars.ui_dialog_layer:getChildren()) == 0 and not Dialog:isExistMsgHandler()
end

function LotaSystem.getWorldId(arg_58_0)
	local var_58_0
	local var_58_1 = LotaUserData:getFloor()
	local var_58_2 = arg_58_0:getCurrentSeasonDB().world_id
	
	for iter_58_0 = 1, 99 do
		local var_58_3, var_58_4, var_58_5 = DBN("clan_heritage_world", iter_58_0, {
			"id",
			"floor",
			"world_id"
		})
		
		if var_58_1 == tonumber(var_58_4) and var_58_5 == var_58_2 then
			var_58_0 = var_58_3
			
			break
		end
	end
	
	return var_58_0
end

function LotaSystem.getMapId(arg_59_0)
	return DB("clan_heritage_world", arg_59_0:getWorldId(), "map_id")
end

function LotaSystem.getCurrentBGM(arg_60_0)
	return DB("clan_heritage_world", arg_60_0:getWorldId(), "map_bgm")
end

function LotaSystem.setPlayScale(arg_61_0)
	LotaCameraSystem:setPlayScale()
	arg_61_0:updateFieldUIScale()
	LotaPingRenderer:updateScale()
end

function LotaSystem.addEvent(arg_62_0)
	if PLATFORM == "win32" then
		local var_62_0 = arg_62_0.vars.layer:getEventDispatcher()
		local var_62_1 = cc.EventListenerMouse:create()
		
		var_62_1:registerScriptHandler(function(arg_63_0, arg_63_1)
			LotaSystemInterface.onMouseWheel(arg_63_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_62_0:addEventListenerWithSceneGraphPriority(var_62_1, arg_62_0.vars.layer)
		
		local var_62_2 = cc.EventListenerKeyboard:create()
		
		var_62_2:registerScriptHandler(function(arg_64_0)
			LotaSystemInterface.onKeyDown(arg_64_0)
		end, cc.Handler.EVENT_KEYBOARD_PRESSED)
		var_62_0:addEventListenerWithSceneGraphPriority(var_62_2, arg_62_0.vars.layer)
	end
end

function LotaSystem.onMouseWheel(arg_65_0, arg_65_1)
	SceneManager:getRunningScene():updateTouchEventTime()
	
	if arg_65_0.vars.input_wait_mode then
		arg_65_0:procOutInputWaitMode()
		
		return 
	end
	
	if arg_65_0:isRequireTouchIgnore() then
		return 
	end
	
	local var_65_0 = {
		x = arg_65_1:getCursorX(),
		y = arg_65_1:getCursorY()
	}
	
	LotaCameraSystem:onScaling(arg_65_1:getScrollY(), var_65_0)
end

function LotaSystem.onWillEnterForeground(arg_66_0)
	if not arg_66_0.vars then
		return 
	end
	
	arg_66_0.vars.on_gesture_zoom = nil
	arg_66_0.vars.touch_started = nil
end

function LotaSystem.onGestureEnd(arg_67_0)
	arg_67_0.vars.on_gesture_zoom = false
end

function LotaSystem.onGestureZoom(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	SceneManager:getRunningScene():updateTouchEventTime()
	
	if arg_68_0.vars.input_wait_mode then
		arg_68_0:procOutInputWaitMode()
		
		return 
	end
	
	if arg_68_0:isRequireTouchIgnore() then
		return 
	end
	
	arg_68_0.vars.on_gesture_zoom = true
	
	local var_68_0 = (arg_68_2 - arg_68_1) * 4 * 20 / VIEW_WIDTH * LotaCameraSystem:getScale()
	
	LotaCameraSystem:onScaling(-var_68_0, arg_68_3)
end

function LotaSystem.onKeyDown(arg_69_0, arg_69_1)
	do return  end
	
	local var_69_0 = 0
	local var_69_1 = 0
	
	if arg_69_1 == 26 then
		var_69_0 = 1
	elseif arg_69_1 == 27 then
		var_69_0 = -1
	elseif arg_69_1 == 28 then
		var_69_1 = -1
	elseif arg_69_1 == 29 then
		var_69_1 = 1
	end
	
	LotaCameraSystem:procMovePosition(var_69_0 * 10, var_69_1 * 10)
end

function LotaSystem.onScale(arg_70_0, arg_70_1)
	LotaCameraSystem:onScale(arg_70_1)
end

function LotaSystem.updateFieldUIScale(arg_71_0)
	local var_71_0 = arg_71_0.vars.field_ui_layer
	
	for iter_71_0, iter_71_1 in pairs(var_71_0:getChildren()) do
		if not iter_71_1._origin_scale then
			iter_71_1._origin_scale = iter_71_1:getScale()
		end
		
		iter_71_1:setScale(iter_71_1._origin_scale / LotaCameraSystem:getScale())
	end
end

function LotaSystem._procTranslateFloor(arg_72_0, arg_72_1)
	LotaUserData:updateFloorKey(2)
	LotaTileMapSystem:loadNextMap()
	LotaObjectSystem:releaseCurrentMapResource()
	LotaMovableSystem:releaseCurrentMapResource()
	LotaFogSystem:releaseCurrentMapResource()
	LotaMinimapRenderer:releaseCurrentMapResource()
	arg_72_0:setInfo(arg_72_1)
	arg_72_0:updateFog(arg_72_1)
end

function LotaSystem.toPlayerOpeningEffect(arg_73_0)
	LotaCameraSystem:setScale(LotaCameraSystem:getPlayScale() * 0.5)
	LotaCameraSystem:setCameraPlayerPos()
	
	local var_73_0 = LotaMovableSystem:getPlayerMovable()
	
	LotaMovableRenderer:setMovableVisible(var_73_0, false)
	LotaTileRenderer:revertMovableArea(true)
	if_set_opacity(arg_73_0.vars.ui_layer, nil, 0)
	LotaCameraSystem:beginCommand()
	
	local var_73_1 = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
	local var_73_2 = LotaCameraCommands:CameraScale(5000, {
		x = ORIGIN_VIEW_WIDTH / 2,
		y = var_73_1
	}, LotaCameraSystem:getPlayScale(), true)
	local var_73_3 = LotaCameraCommands:SPAWN(var_73_2, LotaCameraCommands:SEQ(LotaCameraCommands:CameraWait(3134), LotaCameraCommands:CALL(function()
		LotaMovableRenderer:addSpawnEffect(var_73_0)
	end), LotaCameraCommands:CameraWait(366), LotaCameraCommands:CALL(function()
		LotaMovableSystem:drawMovableArea()
		UIAction:Add(FADE_IN(1500), arg_73_0.vars.ui_layer)
	end), LotaCameraCommands:CameraWait(1500), LotaCameraCommands:CALL(function()
		arg_73_0:requestAutoHandlingEffects()
	end)))
	
	LotaCameraSystem:addCommand(var_73_3)
	LotaCameraSystem:executeCommand("block")
end

function LotaSystem.toBossAndPlayerOpeningEffect(arg_77_0)
	LotaCameraSystem:setScale(LotaCameraSystem:getPlayScale())
	
	local var_77_0 = LotaMovableSystem:getPlayerPos()
	local var_77_1 = arg_77_0.vars.boss_pos
	
	LotaCameraSystem:setCameraPosByTilePos(var_77_1)
	
	local var_77_2 = LotaMovableSystem:getPlayerMovable()
	
	LotaMovableRenderer:setMovableVisible(var_77_2, false)
	LotaTileRenderer:revertMovableArea(true)
	if_set_opacity(arg_77_0.vars.ui_layer, nil, 0)
	LotaCameraSystem:beginCommand()
	
	local var_77_3 = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
	
	LotaCameraSystem:addCommand(LotaCameraCommands:CameraScale(3000, {
		x = VIEW_WIDTH / 2 + 150,
		y = var_77_3 + 250
	}, LotaCameraSystem:getPlayScale() * 2, true))
	LotaCameraSystem:addCommand(LotaCameraCommands:CameraScale(5000, {
		x = VIEW_WIDTH / 2,
		y = var_77_3
	}, LotaCameraSystem:getPlayScale() / 2, "rlog"))
	LotaCameraSystem:addCommand(LotaCameraCommands:CameraWait(500))
	LotaCameraSystem:addCommand(LotaCameraCommands:CameraMoveByTile(var_77_0.x, var_77_0.y, 5000, true, 10))
	
	local var_77_4 = LotaCameraCommands:CameraScale(5000, {
		x = VIEW_WIDTH / 2,
		y = var_77_3
	}, LotaCameraSystem:getPlayScale(), true)
	local var_77_5 = LotaCameraCommands:SPAWN(var_77_4, LotaCameraCommands:SEQ(LotaCameraCommands:CameraWait(3500), LotaCameraCommands:CALL(function()
		LotaMovableRenderer:addEffect(var_77_2)
		LotaMovableRenderer:setMovableVisible(var_77_2, true)
		LotaMovableSystem:drawMovableArea()
		UIAction:Add(FADE_IN(1500), arg_77_0.vars.ui_layer)
	end), LotaCameraCommands:CameraWait(1500), LotaCameraCommands:CALL(function()
		if LotaUserData:isRequireSelectArtifacts() then
			LotaLegacySelectUI:open(LotaSystem:getUIDialogLayer(), LotaUserData:getSelectableArtifacts())
		end
	end)))
	
	LotaCameraSystem:addCommand(var_77_5)
	LotaCameraSystem:executeCommand()
end

function LotaSystem.procBossAppearEffect(arg_80_0)
	if arg_80_0:requireBossAppearEffect() then
		arg_80_0:bossAppearEffect()
		
		return true
	end
	
	return false
end

function LotaSystem.procBossDeadEffect(arg_81_0)
	if arg_81_0:requireBossDeadEffect() then
		if arg_81_0:isFinalFloor() then
			arg_81_0:newBossEffect()
			
			return true
		else
			arg_81_0:nextFloorEffect()
			
			return true
		end
	end
	
	return false
end

function LotaSystem.newBossEffect(arg_82_0)
	local var_82_0 = LotaObjectSystem:getObjectsByType("boss_monster")
	
	if var_82_0 and var_82_0[1] then
		local var_82_1 = var_82_0[1]:getUID()
		local var_82_2 = LotaTileMapSystem:getTileById(var_82_1)
		
		if not var_82_2 then
			return 
		end
		
		local var_82_3 = var_82_2:getPos()
		
		arg_82_0:focusAndTextEffect(var_82_3, T("ui_clan_heritage_new_boss_alert"), "icon_menu_heritage_boss.png")
		
		local var_82_4 = LotaClanInfo:getBossDeadCount(LotaUserData:getFloor())
		local var_82_5 = arg_82_0:getBossDeadSaveKey(LotaClanInfo:getSeasonId(), LotaSystem:getMapId(), var_82_4)
		local var_82_6 = arg_82_0:getAppearEffectTable()
		
		var_82_6[var_82_5] = true
		
		arg_82_0:saveAppearEffect(var_82_6)
	end
end

function LotaSystem.nextFloorEffect(arg_83_0)
	local var_83_0 = LotaObjectSystem:getObjectsByType("boss_portal")
	
	if var_83_0 and var_83_0[1] then
		local var_83_1 = var_83_0[1]:getUID()
		local var_83_2 = LotaTileMapSystem:getTileById(var_83_1)
		
		if not var_83_2 then
			return 
		end
		
		local var_83_3 = var_83_2:getPos()
		
		arg_83_0:focusAndTextEffect(var_83_3, T("ui_clan_heritage_move_portal_ok"), "icon_menu_heritage_potal.png", {
			scale = 1.5,
			is_portal = true
		})
		
		local var_83_4 = LotaClanInfo:getBossDeadCount(LotaUserData:getFloor())
		local var_83_5 = arg_83_0:getBossDeadSaveKey(LotaClanInfo:getSeasonId(), LotaSystem:getMapId(), var_83_4)
		local var_83_6 = arg_83_0:getAppearEffectTable()
		
		var_83_6[var_83_5] = true
		
		arg_83_0:saveAppearEffect(var_83_6)
	end
end

DEBUG.FORCE_APPEAR_EFFECT_VIEW = nil

function LotaSystem.getBossAppearSaveKey(arg_84_0, arg_84_1, arg_84_2)
	return arg_84_1 .. "_" .. arg_84_2
end

function LotaSystem.prepareBeforeBattleStart(arg_85_0)
	arg_85_0.vars.object_layer:removeFromParent()
	cc.Director:getInstance():removeUnusedCachedData()
	
	if sp.SkeletoneCache then
		sp.SkeletoneCache:getInstance():removeUnusedCachedData()
	end
end

function LotaSystem.removeAllBossAppearSaveData(arg_86_0)
	SAVE:set("lota_effect.save", json.encode({}))
end

function LotaSystem.getAppearEffectTable()
	local var_87_0 = SAVE:get("lota_effect.save", "")
	
	return json.decode(var_87_0) or {}
end

function LotaSystem.saveAppearEffect(arg_88_0, arg_88_1)
	local var_88_0 = json.encode(arg_88_1)
	
	SAVE:set("lota_effect.save", var_88_0)
end

function LotaSystem.requireBossAppearEffect(arg_89_0)
	if not LotaUtil:isBossActive() then
		return false
	end
	
	if arg_89_0:isFinalFloor() and LotaClanInfo:getCurrentQuestProgress() > 2 then
		return false
	end
	
	local var_89_0 = arg_89_0:getAppearEffectTable()
	local var_89_1 = arg_89_0:getBossAppearSaveKey(LotaClanInfo:getSeasonId(), LotaSystem:getMapId())
	
	if not (var_89_0[var_89_1] or false) then
		var_89_0[var_89_1] = true
		
		arg_89_0:saveAppearEffect(var_89_0)
		
		if not arg_89_0.vars.boss_pos then
			return false
		end
		
		return true
	end
	
	if not arg_89_0.vars.boss_pos then
		return false
	end
	
	if not PRODUCTION_MODE and DEBUG.FORCE_APPEAR_EFFECT_VIEW then
		DEBUG.FORCE_APPEAR_EFFECT_VIEW = nil
		
		return true
	end
	
	return false
end

function LotaSystem.getBossDeadSaveKey(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
	return arg_90_1 .. "_" .. arg_90_2 .. "_" .. "boss_dead_check" .. "_" .. arg_90_3
end

function LotaSystem.requireBossDeadEffect(arg_91_0)
	if not LotaUtil:isBossDead() then
		return false
	end
	
	if arg_91_0:isFinalFloor() and LotaClanInfo:getCurrentQuestProgress() > 3 then
		return false
	end
	
	local var_91_0 = LotaClanInfo:getBossDeadCount(LotaUserData:getFloor())
	local var_91_1 = arg_91_0:getBossDeadSaveKey(LotaClanInfo:getSeasonId(), LotaSystem:getMapId(), var_91_0)
	
	if not arg_91_0:getAppearEffectTable()[var_91_1] then
		return true
	end
	
	if not PRODUCTION_MODE and DEBUG.FORCE_APPEAR_EFFECT_VIEW then
		DEBUG.FORCE_APPEAR_EFFECT_VIEW = nil
		
		return true
	end
	
	return false
end

function LotaSystem.isFinalFloor(arg_92_0)
	local var_92_0 = LotaUserData:getFloor()
	local var_92_1 = LotaClanInfo:getSeasonId()
	local var_92_2 = DB("clan_heritage_season", var_92_1, "world_id")
	
	for iter_92_0 = 1, 99 do
		local var_92_3, var_92_4, var_92_5 = DBN("clan_heritage_world", iter_92_0, {
			"id",
			"floor",
			"world_id"
		})
		local var_92_6 = tonumber(var_92_0)
		local var_92_7 = tonumber(var_92_4)
		
		if var_92_2 == var_92_5 and var_92_6 < var_92_7 then
			return false
		end
	end
	
	return true
end

function LotaSystem.focusAndTextEffect(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4)
	if_set_visible(arg_93_0.vars.ui_layer, nil, false)
	
	arg_93_4 = arg_93_4 or {}
	arg_93_4.scale = arg_93_4.scale or 1.8
	
	if LotaInteractiveUI:isActive() then
		LotaInteractiveUI:close()
	end
	
	LotaCameraSystem:beginCommand()
	LotaSystem:showCurtain()
	LotaCameraSystem:addCommand(LotaCameraCommands:SEQ(LotaCameraCommands:CameraWait(500), LotaCameraCommands:CALL(function()
		LotaCameraSystem:setScale(LotaCameraSystem:getPlayScale() * arg_93_4.scale)
		
		local var_94_0 = (LotaObjectRenderer:getObjectList() or {})[LotaTileMapSystem:getTileIdByPos(arg_93_1)]
		
		if get_cocos_refid(var_94_0) then
			if arg_93_4.is_portal then
				LotaCameraSystem:setCameraPosByEffect(var_94_0, true)
			elseif not LotaCameraSystem:setCameraPosBySprite(var_94_0, true) then
				LotaCameraSystem:setCameraPosBySprite(var_94_0, true)
			end
		else
			local var_94_1 = LotaUtil:getAddedPosition(arg_93_1, {
				x = 1,
				y = 0.5
			})
			
			LotaCameraSystem:setCameraPosByTilePos(var_94_1, true)
		end
		
		LotaCameraSystem:setPivotReset()
	end), LotaCameraCommands:CameraWait(4000), LotaCameraCommands:CALL(function()
		LotaSystem:showCurtain()
	end), LotaCameraCommands:CameraWait(500), LotaCameraCommands:CALL(function()
		LotaCameraSystem:setScale(LotaCameraSystem:getPlayScale())
		LotaCameraSystem:setCameraPlayerPos()
		LotaMovableRenderer:updateMovableInfoUIScale()
		if_set_visible(arg_93_0.vars.ui_layer, nil, true)
	end)))
	
	local var_93_0 = load_dlg("caution_flash_3", true, "wnd")
	
	if_set(var_93_0, "txt", arg_93_2)
	var_93_0:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, 300)
	var_93_0:setOpacity(0)
	
	local var_93_1 = var_93_0:findChildByName("n_icon_menu")
	local var_93_2 = SpriteCache:getSprite("img/" .. arg_93_3)
	
	var_93_1:addChild(var_93_2)
	arg_93_0:getUIDialogLayer():addChild(var_93_0)
	UIAction:Add(SEQ(DELAY(1550), OPACITY(450, 0, 1), DELAY(5000), CALL(function()
		LotaSystem:requestAutoHandlingEffects()
	end), OPACITY(450, 1, 0), REMOVE()), var_93_0, "block")
	LotaCameraSystem:executeCommand()
end

function LotaSystem.bossAppearEffect(arg_98_0)
	local var_98_0 = arg_98_0.vars.boss_pos
	
	arg_98_0:focusAndTextEffect(var_98_0, T("ui_clan_heritage_move_boss_ok"), "icon_menu_heritage_boss.png")
end

function LotaSystem.startOpeningEffect(arg_99_0)
	arg_99_0:toPlayerOpeningEffect()
end

function LotaSystem.translateFloor(arg_100_0, arg_100_1)
	local var_100_0 = {
		before = function()
		end,
		proc = function()
			arg_100_0:_procTranslateFloor(arg_100_0.vars.next_floor_info)
			arg_100_0.vars.warpCurtain:stop()
			
			arg_100_0.vars.next_floor_info = nil
		end,
		after = function()
			arg_100_0:toPlayerOpeningEffect()
		end
	}
	
	arg_100_0.vars.next_floor_info = arg_100_1
	
	local var_100_1 = SceneManager:getRunningNativeScene()
	local var_100_2 = {
		sprite = EffectManager:Play({
			fn = "eff_anc_floor.cfx",
			layer = var_100_1
		}),
		start = function(arg_104_0)
			arg_104_0.sprite:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			arg_104_0.sprite:setLocalZOrder(99999)
			arg_104_0.sprite:setScale(arg_104_0.sprite:getScale() * 1.5)
			arg_104_0.sprite:setVisible(false)
			Action:Add(SEQ(SHOW(true), CALL(var_100_0.before), DELAY(200), CALL(var_100_0.proc)), arg_104_0.sprite, "block")
		end,
		stop = function(arg_105_0)
			Action:Add(SEQ(DELAY(200), SHOW(false), CALL(var_100_0.after), REMOVE()), arg_105_0.sprite, "block")
		end
	}
	
	var_100_2:start()
	
	arg_100_0.vars.warpCurtain = var_100_2
end

function LotaSystem.showCurtain(arg_106_0)
	local var_106_0 = SceneManager:getRunningNativeScene()
	
	EffectManager:Play({
		fn = "eff_anc_floor.cfx",
		layer = var_106_0
	})
end

function LotaSystem.onNextFloor(arg_107_0)
	LotaNetworkSystem:ignoreAllContentsQueryAndReceive()
end

function LotaSystem.requestNextFloor(arg_108_0)
	LotaNetworkSystem:sendQuery("lota_next_floor")
	LotaNetworkSystem:stopSync()
end

function LotaSystem.procNextFloor(arg_109_0, arg_109_1, arg_109_2)
	LotaUserData:updateFloorKey(arg_109_2)
	arg_109_0:translateFloor(arg_109_1)
end

function LotaSystem.getScale(arg_110_0)
	return arg_110_0.vars.scale
end

function LotaSystem.procPosition(arg_111_0)
	if systick() - arg_111_0.vars.pos.start_tm > arg_111_0.vars.pos.target_tm then
		return 
	end
end

function LotaSystem.updateObjectRewardState(arg_112_0, arg_112_1)
	LotaBattleDataSystem:updateObjectRewardState(arg_112_1)
	LotaObjectSystem:updateObjectRewardState(arg_112_1)
	LotaMovableSystem:drawMovableArea(nil, true)
end

function LotaSystem.updateObjectStatus(arg_113_0, arg_113_1)
	LotaObjectSystem:updateObjectStatus(arg_113_1)
	LotaMovableSystem:drawMovableArea(nil, true)
end

function LotaSystem.updateBossDeadStatus(arg_114_0, arg_114_1)
	LotaObjectSystem:updateBossDeadStatus(arg_114_1)
	LotaMovableSystem:drawMovableArea(nil, true)
end

function LotaSystem.updateActionPoint(arg_115_0, arg_115_1)
	if arg_115_1.movable_id ~= LotaMovableSystem:getCurrentPlayerId() then
		return 
	end
	
	LotaUserData:updateActionPoint(arg_115_1.action_point)
	LotaUIMainLayer:updateActionPoint()
end

function LotaSystem.getPathInJumpResponse(arg_116_0, arg_116_1)
	local var_116_0 = {}
	
	for iter_116_0, iter_116_1 in pairs(arg_116_1.tiles) do
		local var_116_1 = LotaTileMapSystem:getTileById(iter_116_1)
		
		if not var_116_1 then
			error("Query Proc : NOT A TILE")
		end
		
		table.insert(var_116_0, var_116_1:getPos())
	end
	
	return var_116_0
end

function LotaSystem.procJumpTo(arg_117_0, arg_117_1)
	local var_117_0 = LotaMovableSystem:getMovableById(arg_117_1.id)
	local var_117_1 = arg_117_0:getPathInJumpResponse(arg_117_1, var_117_0)
	
	var_117_0:updateLastMoveTm(arg_117_1.tm)
	LotaMovableSystem:jumpPath(var_117_0, var_117_1)
end

function LotaSystem.procFloatingTileTravelTo(arg_118_0, arg_118_1, arg_118_2)
	local var_118_0
	
	for iter_118_0, iter_118_1 in pairs(arg_118_2.member_move_data) do
		if tostring(iter_118_1.id) == tostring(AccountData.id) then
			var_118_0 = iter_118_1
			
			break
		end
	end
	
	local var_118_1 = LotaMovableSystem:getMovableById(var_118_0.id)
	local var_118_2 = arg_118_0:getPathInJumpResponse(var_118_0, var_118_1)
	
	var_118_1:updateLastMoveTm(var_118_0.tm)
	
	local var_118_3 = var_118_2[1]
	
	LotaFogSystem:onSetPosJumpTo(var_118_3, true)
	
	local var_118_4
	local var_118_5 = arg_118_1:getFloatingIdx()
	
	for iter_118_2, iter_118_3 in pairs(LotaObjectSystem:getObjectsByType("floating_tile_dest")) do
		if iter_118_3:getFloatingIdx() == var_118_5 then
			var_118_4 = iter_118_3
			
			break
		end
	end
	
	if not var_118_4 then
		error("no dest_object. check floating index " .. tostring(var_118_5))
	end
	
	LotaMovableSystem:floatingTileTravelPath(var_118_1, arg_118_1:getTileId(), var_118_4:getTileId(), LotaTileMapSystem:getTileIdByPos(var_118_2[1]))
end

function LotaSystem.procMovePath(arg_119_0, arg_119_1)
	local var_119_0 = {}
	local var_119_1 = LotaMovableSystem:getMovableById(arg_119_1.id)
	
	if not var_119_1 then
		print("????????? NOT SYNC NOT MOVE PATH", arg_119_1.id)
		
		return 
	end
	
	local var_119_2
	local var_119_3 = var_119_1:getLastMoveTm()
	
	for iter_119_0 = 1, #arg_119_1.res_tm_list do
		local var_119_4 = arg_119_1.res_tm_list[iter_119_0]
		
		if var_119_3 < var_119_4.tm then
			var_119_2 = var_119_4.tile_index
			
			var_119_1:updateLastMoveTm(var_119_4.tm)
		end
	end
	
	if not var_119_2 then
		return 
	end
	
	for iter_119_1 = var_119_2, #arg_119_1.tiles do
		local var_119_5 = arg_119_1.tiles[iter_119_1]
		local var_119_6 = LotaTileMapSystem:getTileById(var_119_5)
		
		if not var_119_6 then
			error("Query Proc : NOT A TILE")
		end
		
		table.insert(var_119_0, var_119_6:getPos())
	end
	
	for iter_119_2, iter_119_3 in pairs(arg_119_1.tiles) do
		local var_119_7 = iter_119_3
		local var_119_8 = LotaTileMapSystem:getTileById(var_119_7)
		
		if var_119_8 then
			LotaFogSystem:onAnotherPlayerSyncFog(var_119_8:getPos())
		end
	end
	
	if LotaMovableSystem:isWaitToDrawMovable(arg_119_1.id) then
		local var_119_9 = var_119_0[1]
		
		LotaMovableSystem:addWaitDrawMovable(arg_119_1.id, var_119_9)
		table.remove(var_119_0, 1)
	end
	
	local var_119_10
	local var_119_11
	local var_119_12
	
	if arg_119_1.exp then
		var_119_10 = arg_119_1.exp - LotaUserData:getExp()
		
		local var_119_13 = var_119_1:getLevel()
		
		var_119_1:updateExp(arg_119_1.exp)
		
		local var_119_14 = var_119_1:getLevel()
		
		if var_119_13 ~= var_119_14 then
			var_119_11 = true
			var_119_12 = var_119_14 - var_119_13
		end
		
		LotaMovableRenderer:updateMovableExp(var_119_1)
		
		if arg_119_1.id == AccountData.id then
			LotaUserData:updateExp(arg_119_1.exp, true)
		end
	end
	
	if table.count(var_119_0) > 0 then
		LotaMovableSystem:movePath(var_119_1, var_119_0, var_119_10, var_119_11, var_119_12)
	end
end

function LotaSystem.updateExplorePoint(arg_120_0, arg_120_1)
	LotaClanInfo:updateExplorePoint(arg_120_1)
	LotaUIMainLayer:updateExplorePoint()
end

function LotaSystem.debug_moveTo(arg_121_0, arg_121_1, arg_121_2, arg_121_3)
	LotaMovableSystem:moveToById(arg_121_1, arg_121_2, arg_121_3)
end

function LotaSystem.isPopupEmpty(arg_122_0)
	if not arg_122_0:isActive() then
		return 
	end
	
	local var_122_0 = arg_122_0:getUIPopupLayer():getChildren()
	
	return (table.empty(var_122_0))
end

function LotaSystem.onUpdate(arg_123_0)
	if not arg_123_0.vars or not get_cocos_refid(arg_123_0.vars.layer) then
		return 
	end
	
	LotaNetworkSystem:update()
	LotaUIMainLayer:updateVisibleButtons(LotaMovableSystem:isPlayerOutScreen())
	LotaObjectRenderer:onUpdate()
	
	local var_123_0 = arg_123_0:getUIPopupLayer():getChildren()
	local var_123_1 = table.empty(var_123_0)
	
	arg_123_0.vars.is_popup_empty = var_123_1
	
	LotaCameraSystem:setVisible(var_123_1)
	LotaUIMainLayer:setVisible(var_123_1)
end

function LotaSystem.isRequireTouchIgnore(arg_124_0)
	if not arg_124_0.vars then
		return true
	end
	
	if not arg_124_0.vars.is_popup_empty then
		return true
	end
	
	if UIAction:Find("lota_camera") or UIAction:Find("block") then
		return true
	end
	
	if TutorialGuide:isPlayingTutorial() then
		return true
	end
	
	local var_124_0 = SceneManager:getRunningPopupScene():getChildren()
	
	for iter_124_0, iter_124_1 in pairs(var_124_0) do
		if iter_124_1:getName() == "popup_legacy_tooltip" then
			return true
		end
	end
	
	if UIAction:Find("start_tooptip") then
		print("CALL CALL CALL")
		
		return true
	end
	
	local var_124_1 = arg_124_0:getUIDialogLayer()
	
	if not table.empty(var_124_1:getChildren()) then
		return true
	end
	
	return false
end

function LotaSystem.onTouchDown(arg_125_0, arg_125_1, arg_125_2)
	if arg_125_0.vars.on_gesture_zoom then
		return 
	end
	
	if arg_125_0.vars.touch_started then
		return 
	end
	
	arg_125_0.vars.touch_down_was_ignored = arg_125_0:isRequireTouchIgnore()
	
	if arg_125_0:isRequireTouchIgnore() then
		return 
	end
	
	if arg_125_0.vars.input_wait_mode then
		arg_125_0:procOutInputWaitMode()
		
		return 
	end
	
	arg_125_0.vars.pivot_pos = arg_125_1:getLocation()
	
	local var_125_0 = {}
	
	var_125_0.x, var_125_0.y = SceneManager:convertLocation(arg_125_0.vars.pivot_pos.x, arg_125_0.vars.pivot_pos.y)
	arg_125_0.vars.pivot_pos = var_125_0
	arg_125_0.vars.touch_moved = false
	arg_125_0.vars.total_moved = 0
	arg_125_0.vars.start_location = arg_125_1:getStartLocation()
	arg_125_0.vars.touch_started = true
end

function LotaSystem.onTouchMove(arg_126_0, arg_126_1, arg_126_2)
	if arg_126_0.vars.on_gesture_zoom then
		return 
	end
	
	local var_126_0 = arg_126_1:getStartLocation()
	
	if not arg_126_0.vars.start_location then
		arg_126_0.vars.touch_started = false
		
		return 
	end
	
	if arg_126_0.vars.start_location and (arg_126_0.vars.start_location.x ~= var_126_0.x or arg_126_0.vars.start_location.y ~= var_126_0.y) then
		return 
	end
	
	if arg_126_0:isRequireTouchIgnore() or arg_126_0.vars.touch_down_was_ignored then
		return 
	end
	
	if not arg_126_0.vars.pivot_pos then
		return 
	end
	
	local var_126_1 = arg_126_1:getLocation()
	local var_126_2 = {}
	
	var_126_2.x, var_126_2.y = SceneManager:convertLocation(var_126_1.x, var_126_1.y)
	
	local var_126_3 = var_126_2
	local var_126_4 = var_126_3.x - arg_126_0.vars.pivot_pos.x
	local var_126_5 = var_126_3.y - arg_126_0.vars.pivot_pos.y
	
	LotaCameraSystem:procMovePosition(var_126_4, var_126_5)
	
	if var_126_4 > 10 or var_126_5 > 10 or arg_126_0.vars.total_moved > 20 then
		arg_126_0.vars.touch_moved = true
	end
	
	arg_126_0.vars.total_moved = arg_126_0.vars.total_moved + math.abs(var_126_4) + math.abs(var_126_5)
	arg_126_0.vars.pivot_pos = var_126_3
	
	if LotaInteractiveUI:isTooltipActive() then
		LotaInteractiveUI:close()
	elseif LotaInteractiveUI:isActive() then
		local var_126_6 = LotaInteractiveUI:getDlg()
		
		if get_cocos_refid(var_126_6) then
			local var_126_7 = var_126_6:getContentSize()
			local var_126_8 = SceneManager:convertToSceneSpace(var_126_6, {
				x = 0,
				y = 0
			})
			local var_126_9 = var_126_7.width * 2
			local var_126_10 = var_126_7.height * 2
			
			if var_126_8.x < -var_126_9 or var_126_8.x > VIEW_WIDTH + var_126_7.width or var_126_8.y > VIEW_HEIGHT + var_126_7.height or var_126_8.y < -var_126_10 then
				LotaInteractiveUI:close()
			end
		end
	end
end

function LotaSystem.setBlockCoolTime(arg_127_0)
	if not arg_127_0.vars then
		return 
	end
	
	arg_127_0.vars.set_cool_time = uitick()
end

function LotaSystem.touchPosToWorldPos(arg_128_0, arg_128_1)
	local var_128_0 = table.clone(arg_128_1)
	local var_128_1 = cc.Director:getInstance():getWinSize()
	
	;({}).width = VIEW_WIDTH
	var_128_0.x = var_128_0.x + (var_128_1.width - DESIGN_WIDTH) / 2
	var_128_0.y = var_128_0.y + (var_128_1.height - DESIGN_HEIGHT) / 2
	
	local var_128_2 = arg_128_0.vars.field_layer:convertToWorldSpace({
		x = 0,
		y = -10
	})
	local var_128_3 = arg_128_0.vars.pivot:getScale()
	
	return {
		x = (var_128_0.x - var_128_2.x) / var_128_3,
		y = (var_128_0.y - var_128_2.y) / var_128_3
	}
end

function LotaSystem.touchPosConvertSceneForInput(arg_129_0, arg_129_1)
	local var_129_0 = {}
	
	var_129_0.x, var_129_0.y = SceneManager:convertLocation(arg_129_1.x, arg_129_1.y)
	
	return var_129_0
end

function LotaSystem.onTouchUp(arg_130_0, arg_130_1, arg_130_2)
	if not arg_130_0.vars.start_location then
		arg_130_0.vars.touch_started = false
		
		return 
	end
	
	local var_130_0 = arg_130_1:getStartLocation()
	
	if arg_130_0.vars.start_location.x ~= var_130_0.x or arg_130_0.vars.start_location.y ~= var_130_0.y then
		return 
	else
		arg_130_0.vars.touch_started = false
	end
	
	if arg_130_0.vars.on_gesture_zoom then
		return 
	end
	
	if arg_130_0:isRequireTouchIgnore() or arg_130_0.vars.touch_down_was_ignored then
		return 
	end
	
	if not arg_130_0.vars.pivot_pos then
		return 
	end
	
	if LotaBattleReady:isActive() then
		return 
	end
	
	if uitick() - (arg_130_0.vars.set_cool_time or 0) < 100 then
		return 
	end
	
	if not arg_130_0.vars.touch_moved then
		local var_130_1 = AccountData.id
		local var_130_2 = arg_130_0:touchPosToWorldPos(arg_130_0.vars.pivot_pos)
		local var_130_3 = LotaTileMapSystem:calcWorldPosToTilePos(var_130_2)
		
		if UIAction:Find("block") then
			return 
		end
		
		if var_130_3 and not LotaInteractiveUI:isActive() then
			local var_130_4 = LotaTileMapSystem:getTileByPos(var_130_3)
			local var_130_5
			local var_130_6
			
			if var_130_4 then
				local var_130_7 = LotaObjectSystem:getObject(tostring(var_130_4:getTileId()))
				
				var_130_6 = var_130_7 and var_130_7:isActive() and LotaObjectRenderer:isExistRenderObject(var_130_7:getTileId()) or not var_130_7 or not var_130_7:isActive()
			end
			
			if var_130_6 then
				LotaTileRenderer:marking(var_130_3)
			end
			
			if var_130_4 and var_130_6 then
				LotaInteractiveUI:open(var_130_4)
			end
		elseif LotaInteractiveUI:isActive() then
			LotaInteractiveUI:close()
		end
	end
	
	if LOW_RESOLUTION_MODE then
		cc.Director:getInstance():removeUnusedCachedData()
		
		if sp.SkeletoneCache then
			sp.SkeletoneCache:getInstance():removeUnusedCachedData()
		end
	end
end

function LotaSystem.onCheckPos(arg_131_0, arg_131_1)
	local var_131_0, var_131_1 = LotaTileMapSystemInterface.onCheckPos(arg_131_1)
	
	if not var_131_0 then
		return var_131_0, var_131_1
	end
	
	return var_131_0
end
