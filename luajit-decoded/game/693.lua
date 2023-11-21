LotaMinimapRenderer = {}

copy_functions(LotaTileRenderer, LotaMinimapRenderer)

function HANDLER.clan_heritage_map(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		LotaMinimapRenderer:covertToWindow()
	end
	
	if arg_1_1 == "btn_cancel" then
		LotaPortalUI:close()
	end
	
	if arg_1_1 == "btn_left" then
		LotaPortalUI:prvPortal()
	end
	
	if arg_1_1 == "btn_right" then
		LotaPortalUI:nextPortal()
	end
	
	if arg_1_1 == "btn_move" then
		LotaPortalUI:requestJumpToPortal()
	end
	
	if arg_1_1 == "btn_zoom_in" then
		LotaMinimapRenderer:zoomIn()
	end
	
	if arg_1_1 == "btn_zoom_out" then
		LotaMinimapRenderer:zoomOut()
	end
end

function LotaMinimapRenderer.setScale(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars.scale = arg_2_1
	
	local var_2_0 = arg_2_0.vars.layout
	
	var_2_0:setScale(arg_2_1)
	
	arg_2_0.vars.window_width = 224 * (1 / arg_2_1)
	arg_2_0.vars.window_height = 170 * (1 / arg_2_1)
	arg_2_0.vars.fullscreen_width = (VIEW_WIDTH - arg_2_0.vars.fullscreen_gap) * (1 / arg_2_1)
	arg_2_0.vars.fullscreen_height = VIEW_HEIGHT * (1 / arg_2_1)
	arg_2_0.vars.portal_width = VIEW_WIDTH * (1 / arg_2_1)
	arg_2_0.vars.portal_height = VIEW_HEIGHT * (1 / arg_2_1)
	
	if arg_2_0.vars.is_fullscreen then
		arg_2_0.vars.minimap_width = arg_2_0.vars.fullscreen_width
		arg_2_0.vars.minimap_height = arg_2_0.vars.fullscreen_height
	elseif arg_2_0.vars.is_portal then
		arg_2_0.vars.minimap_width = arg_2_0.vars.portal_width
		arg_2_0.vars.minimap_height = arg_2_0.vars.portal_height
	else
		arg_2_0.vars.minimap_width = arg_2_0.vars.window_width
		arg_2_0.vars.minimap_height = arg_2_0.vars.window_height
	end
	
	var_2_0:setContentSize(arg_2_0.vars.minimap_width, arg_2_0.vars.minimap_height)
	
	if get_cocos_refid(arg_2_0.vars.ping_layout) then
		arg_2_0.vars.ping_layout:setScale(arg_2_1)
		arg_2_0.vars.ping_layout:setContentSize(arg_2_0.vars.minimap_width, arg_2_0.vars.minimap_height)
		LotaMinimapPingRenderer:updateScale()
	end
	
	if arg_2_0.vars.cur_pos and not arg_2_2 then
		arg_2_0:setPosCenter(arg_2_0.vars.cur_pos, true)
	end
end

function LotaMinimapRenderer.calcTilePosToMinimapPos(arg_3_0, arg_3_1)
	return arg_3_1.x * (arg_3_0.vars.tile_width / 2) * -1 + arg_3_0.vars.minimap_width / 2, arg_3_1.y * (arg_3_0.vars.tile_height / 2) * -1 + arg_3_0.vars.minimap_height / 2
end

function LotaMinimapRenderer.init(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	
	LotaTileRenderer.init(arg_4_0, arg_4_1, true)
	
	local var_4_0 = ccui.Layout:create()
	
	arg_4_0.vars.layout = var_4_0
	arg_4_0.vars.layer = cc.Layer:create()
	
	arg_4_0.vars.layer:setCascadeOpacityEnabled(false)
	
	arg_4_0.vars.ping_layer = cc.Layer:create()
	
	arg_4_0.vars.ping_layer:setLocalZOrder(10000)
	
	local var_4_1 = 0.6
	
	arg_4_0.vars.scale = var_4_1
	
	var_4_0:addChild(arg_4_0.vars.layer)
	var_4_0:addChild(arg_4_0.vars.ping_layer)
	var_4_0:setPositionY(0)
	var_4_0:setCascadeOpacityEnabled(false)
	
	arg_4_0.vars.markers = {}
	arg_4_0.vars.fullscreen_gap = 380
	arg_4_0.vars.is_fullscreen = false
	
	var_4_0:setContentSize(arg_4_0.vars.minimap_width, arg_4_0.vars.minimap_height)
	var_4_0:setClippingEnabled(true)
	var_4_0:setTouchEnabled(true)
	var_4_0:addTouchEventListener(function(arg_5_0, arg_5_1)
		if arg_5_1 ~= 2 then
			return 
		end
		
		if arg_4_0.vars.is_fullscreen then
			return 
		end
		
		LotaMinimapRenderer:convertToFullScreen()
	end)
	
	arg_4_0.vars.layout = var_4_0
	
	local var_4_2 = cc.Layer:create()
	
	arg_4_0.vars.layout:addChild(var_4_2)
	var_4_2:setName("overlay_parent")
	var_4_2:setLocalZOrder(9999)
	
	arg_4_0.vars.overlay_parent = var_4_2
	arg_4_0.vars.parent_layer = arg_4_1
	
	arg_4_0.vars.parent_layer:addChild(var_4_0)
	
	arg_4_0.vars.tile_width = 42
	arg_4_0.vars.tile_height = 70
	arg_4_0.vars.not_movable_effect_y = 0
	arg_4_0.vars.minimap_paths = {
		normal_monster = {
			path = "img/game_map_icon_battle.png",
			color = cc.c3b(197, 56, 56)
		},
		elite_monster = {
			path = "img/game_map_icon_mob_elite.png",
			color = cc.c3b(197, 56, 56)
		},
		boss_monster = {
			effect = "ui_eff_minimap_boss.cfx",
			path = "img/game_map_icon_mob_boss.png",
			color = cc.c3b(197, 56, 56)
		},
		keeper_monster = {
			effect = "ui_eff_minimap_keeper.cfx",
			path = "img/game_map_icon_guardian.png",
			color = cc.c3b(197, 56, 56)
		},
		portal = {
			path = "img/game_map_icon_portal.png",
			color = cc.c3b(255, 126, 0)
		},
		boss_portal = {
			path = "img/game_map_icon_portal.png",
			color = cc.c3b(197, 56, 56)
		}
	}
	arg_4_0.vars.default_object_path = {
		path = "img/game_map_icon_object.png",
		color = cc.c3b(88, 194, 42)
	}
	
	arg_4_0:setScale(0.6)
	if_set_visible(var_4_0, nil, false)
	LotaMinimapPingRenderer:init(arg_4_0.vars.ping_layer)
end

function LotaMinimapRenderer.makeDebugText(arg_6_0, arg_6_1)
	local var_6_0 = ccui.Text:create()
	
	var_6_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	var_6_0:setFontName("font/daum.ttf")
	var_6_0:setFontSize(12)
	var_6_0:enableOutline(cc.c3b(0, 0, 0), 1)
	var_6_0:setScale(1)
	var_6_0:setPosition(15, 65)
	var_6_0:setLocalZOrder(999996)
	var_6_0:setAnchorPoint(0, 1)
	var_6_0:setName("_debug_text")
	
	local var_6_1 = arg_6_1:getPos()
	local var_6_2 = var_6_1.x .. " / " .. var_6_1.y
	
	var_6_0:setString(var_6_2)
	
	return var_6_0
end

function LotaMinimapRenderer.releaseCurrentMapResource(arg_7_0)
	arg_7_0:release()
	arg_7_0:draw(LotaTileMapSystem:getTileMapData())
end

function LotaMinimapRenderer.convert(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_0.vars.layout:ejectFromParent()
	arg_8_1:addChild(arg_8_0.vars.layout)
	
	arg_8_0.vars.minimap_width = arg_8_2
	arg_8_0.vars.minimap_height = arg_8_3
	arg_8_0.vars.is_fullscreen = arg_8_4
	
	arg_8_0.vars.layout:setContentSize(arg_8_0.vars.minimap_width, arg_8_0.vars.minimap_height)
	
	if arg_8_5 then
		arg_8_0.vars.layout:setPositionX(arg_8_5)
	else
		arg_8_0.vars.layout:setPositionX(0)
	end
	
	local var_8_0 = LotaMovableSystem:getPlayerMovable()
	
	if var_8_0 then
		local var_8_1 = var_8_0:getPos()
		local var_8_2 = LotaTileMapSystem:getTileByPos(var_8_1)
		
		if var_8_2 then
			arg_8_0:updateSprite(var_8_2)
		end
	end
end

function LotaMinimapRenderer.covertToWindow(arg_9_0)
	LotaMinimapPingRenderer:resetParent(arg_9_0.vars.layout)
	
	arg_9_0.vars.additional_opacity = nil
	
	arg_9_0:convert(arg_9_0.vars.parent_layer, arg_9_0.vars.window_width, arg_9_0.vars.window_height, false)
	arg_9_0:cleanUpMarkers()
	
	if get_cocos_refid(arg_9_0.vars.fullscreen_dlg) then
		arg_9_0.vars.fullscreen_dlg:removeFromParent()
		
		arg_9_0.vars.fullscreen_dlg = nil
	end
	
	if arg_9_0.vars.cur_pos then
		arg_9_0:setPosCenter(arg_9_0.vars.cur_pos, true)
	end
	
	if_set_visible(arg_9_0.vars.layout, nil, false)
	LotaSystem:setBlockCoolTime()
	BackButtonManager:pop("lota_minimap")
	TutorialGuide:procGuide("tuto_heritage_quest")
end

function LotaMinimapRenderer.getMinimapSize(arg_10_0)
	return arg_10_0.vars.minimap_width, arg_10_0.vars.minimap_height
end

function LotaMinimapRenderer.getCurrentCenterPos(arg_11_0)
	local var_11_0, var_11_1 = arg_11_0.vars.layer:getPosition()
	
	return arg_11_0.vars.minimap_width * 0.5 - var_11_0, arg_11_0.vars.minimap_height * 0.5 - var_11_1
end

function LotaMinimapRenderer.getMinimapObjects(arg_12_0, arg_12_1)
	local var_12_0 = LotaObjectSystem:getObjectsByType(arg_12_1)
	local var_12_1 = {}
	local var_12_2 = {}
	local var_12_3 = {}
	
	for iter_12_0, iter_12_1 in pairs(var_12_0 or {}) do
		local var_12_4 = arg_12_0:getHashKey(LotaTileMapSystem:getTileById(iter_12_1:getTileId()))
		local var_12_5 = arg_12_0.vars.pos_sprite_hash_map[var_12_4]
		
		if get_cocos_refid(var_12_5) and iter_12_1:isActive() then
			local var_12_6, var_12_7 = var_12_5:getPosition()
			local var_12_8 = arg_12_0.vars.minimap_width * 0.5
			local var_12_9 = arg_12_0.vars.minimap_height * 0.5
			local var_12_10, var_12_11 = arg_12_0:getCurrentCenterPos()
			
			if var_12_6 < var_12_10 - var_12_8 or var_12_7 < var_12_11 - var_12_9 or var_12_6 > var_12_10 + var_12_8 or var_12_7 > var_12_11 + var_12_9 then
				var_12_1[iter_12_1:getTileId()] = true
			end
			
			table.insert(var_12_2, var_12_5)
			table.insert(var_12_3, iter_12_1:getTileId())
		end
	end
	
	return var_12_2, var_12_3, var_12_1
end

function LotaMinimapRenderer.getCurrentTarget(arg_13_0)
	local var_13_0 = LotaClanInfo:getCurrentQuestType()
	
	if arg_13_0.vars.last_progress ~= var_13_0 then
		arg_13_0:cleanUpMarkers()
		
		arg_13_0.vars.last_progress = var_13_0
	end
	
	return arg_13_0:getMinimapObjects(var_13_0)
end

function LotaMinimapRenderer.updateMarker(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	if not get_cocos_refid(arg_14_0.vars.fullscreen_dlg) then
		return 
	end
	
	local var_14_0 = arg_14_4 * -1
	local var_14_1 = arg_14_5
	local var_14_2 = arg_14_0.vars.markers[arg_14_1]
	local var_14_3 = 1 / arg_14_0.vars.current_zoom_scale
	
	if not var_14_2 then
		var_14_2 = arg_14_0.vars.fullscreen_dlg:findChildByName("n_pointer"):clone()
		
		var_14_2:setVisible(true)
		
		local var_14_4 = LotaClanInfo:getCurrentQuestIcon()
		local var_14_5 = var_14_2:findChildByName("grade_icon")
		
		SpriteCache:resetSprite(var_14_5, "img/" .. var_14_4 .. ".png")
		
		arg_14_0.vars.markers[arg_14_1] = var_14_2
		
		arg_14_0.vars.layer:addChild(var_14_2)
	end
	
	local var_14_6 = var_14_2:getContentSize()
	
	var_14_6.height = 159
	
	local var_14_7 = math.atan2(arg_14_5, arg_14_4) * 180 / math.pi
	
	var_14_2:findChildByName("grade_icon"):setRotation((-var_14_7 + 90) * -1)
	var_14_2:setScale(var_14_3)
	var_14_2:setRotation(-var_14_7 + 90)
	var_14_2:setPosition(arg_14_2 + var_14_6.width * var_14_3 / 2 * var_14_0, arg_14_3 - var_14_6.height * var_14_3 / 2 * var_14_1)
end

function LotaMinimapRenderer.setVisibleMarkers(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {}
	
	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		var_15_0[iter_15_1] = arg_15_2[iter_15_1]
	end
	
	for iter_15_2, iter_15_3 in pairs(arg_15_0.vars.markers) do
		iter_15_3:setVisible(var_15_0[iter_15_2])
	end
end

function LotaMinimapRenderer.setVisibleTargetEffects(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		local var_16_0 = arg_16_2[iter_16_0]
		
		if_set_visible(iter_16_1, "effect_target", not arg_16_3[var_16_0])
	end
end

function LotaMinimapRenderer.fullscreenOnTouchDown(arg_17_0, arg_17_1, arg_17_2)
	LotaMinimapPingRenderer:hideMemo()
	
	arg_17_0.vars.touch_pivot = {
		x = arg_17_1,
		y = arg_17_2
	}
end

function LotaMinimapRenderer.getInMinMaxPos(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0, var_18_1 = LotaUtil:getMapMinMaxPos()
	local var_18_2, var_18_3 = arg_18_0:calcTilePosToMinimapPos(var_18_0)
	local var_18_4, var_18_5 = arg_18_0:calcTilePosToMinimapPos(var_18_1)
	
	if var_18_2 < arg_18_1 or arg_18_1 < var_18_4 or var_18_3 < arg_18_2 or arg_18_2 < var_18_5 then
		if (arg_18_3.x > 0.1 or arg_18_4) and var_18_2 < arg_18_1 then
			arg_18_1 = var_18_2
		end
		
		if (arg_18_3.x < -0.1 or arg_18_4) and arg_18_1 < var_18_4 then
			arg_18_1 = var_18_4
		end
		
		if (arg_18_3.y > 0.1 or arg_18_4) and var_18_3 < arg_18_2 then
			arg_18_2 = var_18_3
		end
		
		if (arg_18_3.y < -0.1 or arg_18_4) and arg_18_2 < var_18_5 then
			arg_18_2 = var_18_5
		end
	end
	
	return arg_18_1, arg_18_2
end

function LotaMinimapRenderer.fullscreenOnTouchMove(arg_19_0, arg_19_1, arg_19_2)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	local var_19_0 = {
		x = arg_19_1,
		y = arg_19_2
	}
	local var_19_1 = LotaUtil:getDecedPosition(var_19_0, arg_19_0.vars.touch_pivot)
	local var_19_2, var_19_3 = arg_19_0.vars.layer:getPosition()
	local var_19_4 = var_19_2 + var_19_1.x
	local var_19_5 = var_19_3 + var_19_1.y
	local var_19_6, var_19_7 = arg_19_0:getInMinMaxPos(var_19_4, var_19_5, var_19_1)
	
	arg_19_0.vars.layer:setPosition(var_19_6, var_19_7)
	arg_19_0.vars.ping_layer:setPosition(arg_19_0.vars.layer:getPosition())
	
	arg_19_0.vars.touch_pivot.x = arg_19_1
	arg_19_0.vars.touch_pivot.y = arg_19_2
	
	arg_19_0:updateMarkers()
	LotaMinimapPingRenderer:hideMemo()
end

function LotaMinimapRenderer.updateMarkers(arg_20_0)
	local var_20_0, var_20_1, var_20_2 = arg_20_0:getCurrentTarget()
	local var_20_3, var_20_4 = arg_20_0:getCurrentCenterPos()
	local var_20_5 = {
		x = var_20_3,
		y = var_20_4
	}
	
	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		local var_20_6, var_20_7 = iter_20_1:getPosition()
		
		if var_20_2[var_20_1[iter_20_0]] then
			local var_20_8 = LotaUtil:getDecedPosition({
				x = var_20_6,
				y = var_20_7
			}, var_20_5)
			local var_20_9 = LotaUtil:getNormalVector(var_20_8)
			local var_20_10, var_20_11 = arg_20_0:getMinimapSize()
			local var_20_12 = (var_20_10 - 176) / 2 / math.abs(var_20_9.x)
			local var_20_13 = var_20_11 / 2 / math.abs(var_20_9.y)
			local var_20_14 = math.min(var_20_12, var_20_13)
			
			arg_20_0:updateMarker(var_20_1[iter_20_0], var_20_9.x * var_20_14 + var_20_3, var_20_9.y * var_20_14 + var_20_4, var_20_9.x, var_20_9.y)
		end
		
		if false then
		end
	end
	
	arg_20_0:setVisibleMarkers(var_20_1, var_20_2)
	arg_20_0:setVisibleTargetEffects(var_20_0, var_20_1, var_20_2)
end

function LotaMinimapRenderer.cleanUpMarkers(arg_21_0)
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.markers) do
		if get_cocos_refid(iter_21_1) then
			iter_21_1:removeFromParent()
		end
	end
	
	arg_21_0.vars.markers = {}
end

function LotaMinimapRenderer.fullscreenOnTouchUp(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0.vars.touch_pivot = {
		x = arg_22_1,
		y = arg_22_2
	}
end

function LotaMinimapRenderer.convertToPortalUI(arg_23_0, arg_23_1)
	arg_23_0.vars.is_portal = true
	arg_23_0.vars.additional_opacity = 0.4
	
	arg_23_0:setZoomStatusVariable()
	arg_23_0:updateZoomInOutState()
	arg_23_0:updateSpriteAll(LotaTileMapSystem:getTileMapData())
	arg_23_0:convert(arg_23_1, arg_23_0.vars.portal_width, arg_23_0.vars.portal_height, true, VIEW_BASE_LEFT)
	
	arg_23_0.vars.is_fullscreen = false
	
	if_set_visible(arg_23_0.vars.layout, nil, true)
end

function LotaMinimapRenderer.zoomIn(arg_24_0)
	if arg_24_0.vars.current_zoom_scale < arg_24_0.vars.map_view_max then
		arg_24_0.vars.current_zoom_scale = arg_24_0.vars.current_zoom_scale + arg_24_0.vars.map_view_zoom_rate
		
		arg_24_0:updateZoomStatus(arg_24_0.vars.current_zoom_scale)
		LotaMinimapPingRenderer:hideMemo()
	end
end

function LotaMinimapRenderer.zoomOut(arg_25_0)
	if arg_25_0.vars.current_zoom_scale > arg_25_0.vars.map_view_min then
		arg_25_0.vars.current_zoom_scale = arg_25_0.vars.current_zoom_scale - arg_25_0.vars.map_view_zoom_rate
		
		arg_25_0:updateZoomStatus(arg_25_0.vars.current_zoom_scale)
		LotaMinimapPingRenderer:hideMemo()
	end
end

function LotaMinimapRenderer.convertCurrentPosInDiffScale(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0, var_26_1 = arg_26_0.vars.layer:getPosition()
	local var_26_2 = var_26_0 + (arg_26_0.vars.minimap_width - arg_26_1) * 0.5
	local var_26_3 = var_26_1 + (arg_26_0.vars.minimap_height - arg_26_2) * 0.5
	local var_26_4, var_26_5 = arg_26_0:getInMinMaxPos(var_26_2, var_26_3, {
		x = 0,
		y = 0
	}, true)
	
	arg_26_0.vars.layer:setPosition(var_26_4, var_26_5)
	arg_26_0.vars.ping_layer:setPosition(arg_26_0.vars.layer:getPosition())
	arg_26_0.vars.overlay_parent:setPosition(arg_26_0.vars.layer:getPosition())
end

function LotaMinimapRenderer.updateZoomStatus(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0.vars.tile_width
	local var_27_1 = arg_27_0.vars.minimap_width
	local var_27_2 = arg_27_0.vars.tile_height
	local var_27_3 = arg_27_0.vars.minimap_height
	
	arg_27_0:setScale(arg_27_0.vars.fullscreen_default_scale * arg_27_1, true)
	
	arg_27_0.vars.current_zoom_scale = arg_27_1
	
	arg_27_0:updateZoomInOutState()
	arg_27_0:updatePortalOverlayStatus()
	
	if arg_27_0.vars.cur_pos then
	end
	
	arg_27_0:convertCurrentPosInDiffScale(var_27_1, var_27_3)
	arg_27_0:updateMarkers()
	LotaMinimapPingRenderer:updateScale()
	
	if arg_27_0.vars.is_portal then
		LotaPortalUI:setCurPortalCenter()
	end
end

function LotaMinimapRenderer.updateZoomInOutState(arg_28_0)
	local var_28_0 = arg_28_0.vars.current_zoom_scale >= arg_28_0.vars.map_view_max
	local var_28_1 = arg_28_0.vars.current_zoom_scale <= arg_28_0.vars.map_view_min
	local var_28_2 = 255
	local var_28_3 = 255
	
	if var_28_0 then
		var_28_2 = var_28_2 * 0.3
	end
	
	if var_28_1 then
		var_28_3 = var_28_3 * 0.3
	end
	
	local var_28_4
	
	if arg_28_0.vars.is_portal then
		var_28_4 = LotaPortalUI:getDlg():getChildByName("n_zoom_portal")
	else
		var_28_4 = arg_28_0.vars.fullscreen_dlg:findChildByName("n_zoom")
	end
	
	if_set_opacity(var_28_4, "btn_zoom_in", var_28_2)
	if_set_opacity(var_28_4, "btn_zoom_out", var_28_3)
end

function LotaMinimapRenderer.getZoomScale(arg_29_0)
	if not arg_29_0.vars then
		return 1
	end
	
	return arg_29_0.vars.current_zoom_scale or 1
end

function LotaMinimapRenderer.setZoomStatusVariable(arg_30_0)
	arg_30_0.vars.current_zoom_scale = 1
	arg_30_0.vars.fullscreen_default_scale = 1.02
	arg_30_0.vars.map_view_max = DB("clan_heritage_config", "map_view_max", "client_value")
	arg_30_0.vars.map_view_min = DB("clan_heritage_config", "map_view_min", "client_value")
	arg_30_0.vars.map_view_zoom_rate = DB("clan_heritage_config", "map_view_zoom_rate", "client_value")
end

function LotaMinimapRenderer.convertToFullScreen(arg_31_0)
	local var_31_0 = LotaUtil:getUIDlg("clan_heritage_map")
	local var_31_1 = LotaSystem:getWorldId()
	local var_31_2 = DB("clan_heritage_world", var_31_1, "name")
	local var_31_3 = LotaSystem:getCurrentSeasonDB()
	local var_31_4 = var_31_0:findChildByName("title_nfo")
	
	arg_31_0.vars.fullscreen_dlg = var_31_0
	arg_31_0.vars.is_portal = false
	
	arg_31_0:setZoomStatusVariable()
	if_set(var_31_4, "t1", T(var_31_3.name))
	if_set(var_31_4, "t2", T(var_31_2))
	if_set_visible(var_31_0, "n_zoom", true)
	arg_31_0:updateZoomInOutState()
	arg_31_0:updateSpriteAll(LotaTileMapSystem:getTileMapData())
	arg_31_0:convert(var_31_0:findChildByName("MAP"), arg_31_0.vars.fullscreen_width, arg_31_0.vars.fullscreen_height, true, VIEW_BASE_LEFT)
	
	local var_31_5 = ccui.Layout:create()
	
	var_31_5:setName("ping_layout")
	var_31_5:setContentSize(arg_31_0.vars.fullscreen_width, arg_31_0.vars.fullscreen_height)
	var_31_5:setClippingEnabled(true)
	var_31_5:setTouchEnabled(false)
	
	local var_31_6 = arg_31_0.vars.fullscreen_dlg:findChildByName("scroll_area")
	
	var_31_6:addTouchEventListener(function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
		if arg_32_1 == 2 then
			arg_31_0:fullscreenOnTouchDown(arg_32_2, arg_32_3)
		end
		
		if arg_32_1 == 1 then
			arg_31_0:fullscreenOnTouchMove(arg_32_2, arg_32_3)
		end
		
		if arg_32_1 == 0 then
			arg_31_0:fullscreenOnTouchUp(arg_32_2, arg_32_3)
		end
	end)
	var_31_5:setPositionX(VIEW_BASE_LEFT)
	var_31_5:setLocalZOrder(var_31_6:getLocalZOrder() + 1)
	var_31_0:findChildByName("n_zoom"):setLocalZOrder(var_31_5:getLocalZOrder() + 1)
	LotaMinimapPingRenderer:resetParent(var_31_5)
	var_31_6:getParent():addChild(var_31_5)
	
	arg_31_0.vars.ping_layout = var_31_5
	
	arg_31_0:setScale(arg_31_0.vars.fullscreen_default_scale)
	
	arg_31_0.vars.cur_pos = LotaMovableSystem:getPlayerPos()
	
	if arg_31_0.vars.cur_pos then
		arg_31_0:setPosCenter(arg_31_0.vars.cur_pos, true)
	end
	
	LotaSystem:getUIDialogLayer():addChild(var_31_0)
	arg_31_0:updateMarkers()
	if_set_visible(arg_31_0.vars.layout, nil, true)
	BackButtonManager:push({
		check_id = "lota_minimap",
		back_func = function()
			arg_31_0:covertToWindow()
		end
	})
	TutorialGuide:procGuide("tuto_heritage_quest")
end

function LotaMinimapRenderer.setPosCenter(arg_34_0, arg_34_1, arg_34_2)
	if (arg_34_0.vars.is_fullscreen or arg_34_0.vars.is_portal) and not arg_34_2 then
		return 
	end
	
	local var_34_0, var_34_1 = arg_34_0:calcTilePosToMinimapPos(arg_34_1)
	
	arg_34_0.vars.layer:setPosition(var_34_0, var_34_1)
	arg_34_0.vars.ping_layer:setPosition(arg_34_0.vars.layer:getPosition())
	
	arg_34_0.vars.cur_pos = arg_34_1
end

function LotaMinimapRenderer.getSpriteDrawData(arg_35_0, arg_35_1, arg_35_2)
	arg_35_2 = arg_35_2 or 0
	
	local var_35_0
	local var_35_1 = 1
	local var_35_2 = 1
	local var_35_3 = cc.c3b(255, 255, 255)
	local var_35_4 = arg_35_1:getPos()
	local var_35_5 = LotaMovableSystem:isPlayerOnPos(var_35_4)
	local var_35_6 = "img/game_map_icon_tile_heritage.png"
	local var_35_7 = 1
	local var_35_8 = 1
	local var_35_9
	
	if var_35_5 then
		var_35_0 = "img/game_map_now.png"
		var_35_3 = cc.c3b(53, 139, 255)
	elseif not arg_35_1:isExistObject() then
		var_35_2 = 0.2
	else
		local var_35_10 = arg_35_1:getTileId()
		local var_35_11 = LotaObjectSystem:getObject(var_35_10)
		local var_35_12 = var_35_11:getTypeDetail()
		local var_35_13 = arg_35_0.vars.default_object_path
		local var_35_14 = arg_35_0.vars.minimap_paths
		
		if var_35_14[var_35_12] then
			var_35_13 = var_35_14[var_35_12]
		end
		
		var_35_0 = var_35_13.path
		var_35_9 = var_35_13.effect
		
		if not var_35_11:isMainId(arg_35_1:getTileId()) then
			var_35_0 = nil
			var_35_9 = nil
		end
		
		if not var_35_11:isMonsterType() and not string.find(var_35_12, "portal") and (not var_35_11:isActive() or var_35_11:isClanObject() and var_35_11:isUsedClanObject()) then
			var_35_1 = 0.3
		end
		
		var_35_7, var_35_8 = var_35_11:getMinimapIconMiddlePosition()
		var_35_3 = table.clone(var_35_13.color)
		var_35_6 = "img/game_map_icon_tile_heritage_spot.png"
	end
	
	local var_35_15 = arg_35_2 / 3
	
	var_35_3.r = var_35_3.r * var_35_15
	var_35_3.g = var_35_3.g * var_35_15
	var_35_3.b = var_35_3.b * var_35_15
	
	if arg_35_0.vars.additional_opacity then
		var_35_2 = math.min(1, var_35_2 + arg_35_0.vars.additional_opacity)
	end
	
	return var_35_0, var_35_1, var_35_2, var_35_3, arg_35_2, var_35_6, var_35_7, var_35_8, var_35_9
end

function LotaMinimapRenderer.makeSprite(arg_36_0, arg_36_1)
	local var_36_0, var_36_1, var_36_2, var_36_3, var_36_4, var_36_5, var_36_6, var_36_7, var_36_8 = arg_36_0:getSpriteDrawData(arg_36_1)
	local var_36_9 = SpriteCache:getSprite(var_36_5)
	
	var_36_9.tile_path = var_36_5
	
	var_36_9:setCascadeOpacityEnabled(true)
	
	local var_36_10 = arg_36_1:getPos()
	
	var_36_9._object_path = var_36_0
	var_36_9._fog = nil
	
	if var_36_0 then
		local var_36_11 = SpriteCache:getSprite(var_36_0)
		
		var_36_11:setPosition(arg_36_0.vars.tile_width / 2 * var_36_6, 23 * var_36_7)
		var_36_11:setName("_object_sprite")
		var_36_11:setOpacity(255 * var_36_1)
		var_36_9:addChild(var_36_11)
	end
	
	if var_36_8 then
		local var_36_12 = EffectManager:Play({
			pivot_z = 99998,
			fn = var_36_8,
			layer = var_36_9,
			pivot_x = arg_36_0.vars.tile_width / 2 * var_36_6,
			pivot_y = 23 * var_36_7
		})
		
		var_36_12:setName("effect_target")
		var_36_12:setVisible(false)
	end
	
	var_36_9:setColor(var_36_3)
	var_36_9:setName(var_36_10.x .. "_" .. var_36_10.y)
	var_36_9:setOpacity(255 * var_36_2)
	
	return var_36_9
end

function LotaMinimapRenderer.updatePortalOverlayStatus(arg_37_0)
	if arg_37_0.vars.overlay_sprite and get_cocos_refid(arg_37_0.vars.overlay_sprite) then
		arg_37_0:setPosingSprite(arg_37_0.vars.overlay_sprite, arg_37_0.vars.overlay_tile)
		arg_37_0:updateSpriteWithSprite(arg_37_0.vars.overlay_tile, arg_37_0.vars.overlay_sprite)
	end
end

function LotaMinimapRenderer.setPortalOverlayColor(arg_38_0, arg_38_1)
	arg_38_0.vars.layer:setOpacity(140.25)
	arg_38_0.vars.layer:setCascadeOpacityEnabled(true)
	
	if arg_38_0.vars.overlay_sprite and get_cocos_refid(arg_38_0.vars.overlay_sprite) then
		arg_38_0.vars.overlay_sprite:removeFromParent()
	end
	
	local var_38_0 = arg_38_0:makeSprite(arg_38_1)
	local var_38_1 = arg_38_0.vars.overlay_parent
	
	var_38_1:setPosition(arg_38_0.vars.layer:getPosition())
	var_38_1:addChild(var_38_0)
	var_38_1:setVisible(true)
	arg_38_0:setPosingSprite(var_38_0, arg_38_1)
	arg_38_0:updateSpriteWithSprite(arg_38_1, var_38_0)
	var_38_0:setColor(cc.c3b(255, 126, 0))
	
	arg_38_0.vars.overlay_sprite = var_38_0
	arg_38_0.vars.overlay_tile = arg_38_1
end

function LotaMinimapRenderer.revertPortalOverlay(arg_39_0)
	arg_39_0.vars.layer:setOpacity(255)
	arg_39_0.vars.layer:setCascadeOpacityEnabled(false)
	arg_39_0.vars.overlay_parent:setVisible(false)
end

function LotaMinimapRenderer.updateFogAll(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_1:getLength()
	
	for iter_40_0 = 1, var_40_0 do
		local var_40_1 = arg_40_1:getTileByIndex(iter_40_0)
		local var_40_2 = var_40_1:getPos()
		local var_40_3 = LotaFogSystem:getFogVisibility(var_40_2.x, var_40_2.y)
		
		arg_40_0:updateFog(var_40_1, var_40_3)
	end
end

function LotaMinimapRenderer.updateSpriteAll(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_1:getLength()
	
	for iter_41_0 = 1, var_41_0 do
		local var_41_1 = arg_41_1:getTileByIndex(iter_41_0)
		
		arg_41_0:updateSprite(var_41_1)
	end
end

function LotaMinimapRenderer.updateFog(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.layout) then
		return 
	end
	
	if not arg_42_1 then
		return 
	end
	
	local var_42_0 = arg_42_0:getTileSprite(arg_42_1)
	local var_42_1, var_42_2, var_42_3, var_42_4, var_42_5 = arg_42_0:getSpriteDrawData(arg_42_1, arg_42_2)
	local var_42_6 = arg_42_1:getTileId()
	local var_42_7, var_42_8 = LotaObjectSystem:getObjectType(var_42_6)
	local var_42_9 = LotaUtil:isDiscoverAllowType(var_42_8, var_42_7)
	local var_42_10 = var_42_0:findChildByName("_object_sprite")
	
	if get_cocos_refid(var_42_10) then
		local var_42_11 = arg_42_2 / 3
		
		if arg_42_2 == LotaFogVisibilityEnum.DISCOVER then
			var_42_3 = 0.2
			var_42_4 = var_42_9 and var_42_4 or cc.c3b(255 * var_42_11, 255 * var_42_11, 255 * var_42_11)
			
			var_42_10:setVisible(var_42_9)
		elseif arg_42_2 == LotaFogVisibilityEnum.NOT_DISCOVER then
			var_42_10:setVisible(false)
		else
			var_42_10:setVisible(true)
		end
	end
	
	if var_42_0._fog == arg_42_2 then
		return 
	end
	
	var_42_0:setOpacity(var_42_3 * 255)
	var_42_0:setColor(var_42_4)
	
	var_42_0._fog = arg_42_2
end

function LotaMinimapRenderer.updateSpriteWithSprite(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_1:getPos()
	local var_43_1 = LotaFogSystem:getFogVisibility(var_43_0.x, var_43_0.y)
	local var_43_2, var_43_3, var_43_4, var_43_5, var_43_6, var_43_7, var_43_8, var_43_9, var_43_10 = arg_43_0:getSpriteDrawData(arg_43_1, var_43_1)
	
	if LotaMovableSystem:isPlayerOnPos(var_43_0) then
		local var_43_11 = arg_43_2:findChildByName("effect_now")
		
		if arg_43_0.vars.is_fullscreen and not get_cocos_refid(var_43_11) then
			EffectManager:Play({
				fn = "ui_game_map_now.cfx",
				pivot_z = 99998,
				layer = arg_43_2,
				pivot_x = arg_43_2:getContentSize().width / 2,
				pivot_y = arg_43_2:getContentSize().height / 2
			}):setName("effect_now")
		elseif get_cocos_refid(var_43_11) then
			var_43_11:removeFromParent()
		end
	end
	
	local var_43_12 = arg_43_2:findChildByName("_object_sprite")
	
	if var_43_12 then
		var_43_12:setOpacity(255 * var_43_3)
	end
	
	arg_43_0:updateFog(arg_43_1, var_43_1)
	
	if arg_43_2.tile_path ~= var_43_7 then
		local var_43_13 = arg_43_2._object_path
		
		SpriteCache:resetSprite(arg_43_2, var_43_7)
		
		arg_43_2.tile_path = var_43_7
		arg_43_2._object_path = var_43_13
	end
	
	arg_43_2:setColor(var_43_5)
	arg_43_2:setOpacity(255 * var_43_4)
	
	if arg_43_2._object_path == var_43_2 then
		return 
	end
	
	arg_43_2:removeAllChildren()
	
	if var_43_2 then
		local var_43_14 = SpriteCache:getSprite(var_43_2)
		
		var_43_14:setPosition(arg_43_0.vars.tile_width / 2 * var_43_8, 23 * var_43_9)
		var_43_14:setName("_object_sprite")
		var_43_14:setOpacity(255 * var_43_3)
		arg_43_2:addChild(var_43_14)
		
		if arg_43_0:isTileMainId(arg_43_1) then
			arg_43_2:setLocalZOrder(arg_43_2:getLocalZOrder() + 1)
		end
		
		if var_43_10 then
			local var_43_15 = EffectManager:Play({
				pivot_z = 99998,
				fn = var_43_10,
				layer = arg_43_2,
				pivot_x = arg_43_0.vars.tile_width / 2 * var_43_8,
				pivot_y = 23 * var_43_9
			})
			
			var_43_15:setName("effect_target")
			var_43_15:setVisible(false)
		else
			local var_43_16 = arg_43_2:findChildByName("effect_target")
			
			if var_43_16 then
				var_43_16:removeFromParent()
			end
		end
	end
	
	arg_43_2._object_path = var_43_2
end

function LotaMinimapRenderer.updateSprite(arg_44_0, arg_44_1)
	if not arg_44_0.vars then
		return 
	end
	
	if not arg_44_1 then
		return 
	end
	
	local var_44_0 = arg_44_0:getTileSprite(arg_44_1)
	
	if not var_44_0 then
		return 
	end
	
	arg_44_0:updateSpriteWithSprite(arg_44_1, var_44_0)
end

function LotaMinimapRenderer.close(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_45_0.vars.layout) then
		arg_45_0.vars.layout:removeFromParent()
	end
	
	arg_45_0.vars = nil
end
