WorldMapLand = ClassDef()

function WorldMapLand.constructor(arg_1_0)
end

function WorldMapLand.clear(arg_2_0)
	arg_2_0.main_map_layer = nil
	arg_2_0.main_cloud_layer = nil
end

function WorldMapLand.create(arg_3_0, arg_3_1)
	arg_3_0:clear()
	
	arg_3_0.HEIGHT = DESIGN_HEIGHT
	arg_3_0.WIDTH = DESIGN_WIDTH
	
	local var_3_0 = cc.Layer:create()
	
	arg_3_0.layer = var_3_0
	arg_3_0.controller = arg_3_1
	
	var_3_0:setContentSize(arg_3_0.WIDTH, arg_3_0.HEIGHT)
	var_3_0:setPosition(arg_3_0.WIDTH / 2, arg_3_0.HEIGHT / 2)
	var_3_0:ignoreAnchorPointForPosition(false)
	
	arg_3_0.land_name = nil
	
	return var_3_0
end

function WorldMapLand.showLand(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2 = arg_4_2 or {}
	
	arg_4_0.layer:removeAllChildren()
	
	local var_4_0 = arg_4_0.controller:getContinentAtlas(arg_4_1)
	
	SpriteCache:load("worldmap/" .. var_4_0 .. ".atlas")
	SpriteCache:load("worldmap/common.atlas")
	
	arg_4_0.main_map_layer, arg_4_0.main_cloud_layer, arg_4_0.childs = arg_4_0:makeMap(arg_4_2)
	
	arg_4_0.main_map_layer:setLocalZOrder(10)
	arg_4_0.main_cloud_layer:setLocalZOrder(11)
	arg_4_0.layer:addChild(arg_4_0.main_map_layer)
	arg_4_0.layer:addChild(arg_4_0.main_cloud_layer)
	arg_4_0:viewMaze(false)
	GrowthGuideNavigator:proc()
end

function WorldMapLand.cheatSprSetPosition(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.childs_img) do
		if iter_5_1.key == arg_5_1 then
			var_5_0 = iter_5_1.spr
			
			break
		end
	end
	
	if not var_5_0 then
		Log.e("no_cheat", "invalid_id")
	end
	
	if arg_5_3 then
		arg_5_3 = arg_5_3 * arg_5_0.controller.vars.HEIGHT
	else
		arg_5_3 = var_5_0:getPositionY()
	end
	
	if arg_5_2 then
		arg_5_2 = arg_5_2 * arg_5_0.controller.vars.WIDTH
	else
		arg_5_2 = var_5_0:getPositionX()
	end
	
	var_5_0:setPosition(arg_5_2, arg_5_3)
end

function WorldMapLand.cheatWndSetPosition(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = DBT("level_world_2_continent", arg_6_1, {
		"nx",
		"ny",
		"x",
		"y",
		"label_text_anchor_x",
		"label_text_anchor_y"
	})
	
	if not var_6_0 then
		Log.e("no_cheat", "invalid_id")
	end
	
	if arg_6_3 then
		arg_6_3 = (var_6_0.y + arg_6_3) * arg_6_0.controller.vars.HEIGHT
	else
		arg_6_3 = arg_6_0.icons[arg_6_1]:getPositionY()
	end
	
	if arg_6_2 then
		arg_6_2 = (var_6_0.x + arg_6_2) * arg_6_0.controller.vars.WIDTH
	else
		arg_6_2 = arg_6_0.icons[arg_6_1]:getPositionX()
	end
	
	if arg_6_0.icons[arg_6_1] then
		local var_6_1 = arg_6_0.icons[arg_6_1]:getChildByName("label_name")
		
		if get_cocos_refid(var_6_1) then
			local var_6_2 = var_6_1:getAnchorPoint()
			local var_6_3 = arg_6_4 or var_6_0.label_text_anchor_x or var_6_2.x
			local var_6_4 = arg_6_5 or var_6_0.label_text_anchor_y or var_6_2.y
			
			var_6_1:setAnchorPoint(var_6_3, var_6_4)
		end
	end
	
	arg_6_0.icons[arg_6_1]:setPosition(arg_6_2, arg_6_3)
end

function WorldMapLand.makeMap(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or {}
	
	local var_7_0 = cc.Layer:create()
	
	var_7_0:setPosition(arg_7_0.WIDTH / 2, arg_7_0.HEIGHT / 2)
	var_7_0:setAnchorPoint(0.5, 0.5)
	var_7_0:setContentSize(arg_7_0.WIDTH, arg_7_0.HEIGHT)
	var_7_0:ignoreAnchorPointForPosition(false)
	
	local var_7_1 = cc.Layer:create()
	
	var_7_1:setPosition(arg_7_0.WIDTH / 2, arg_7_0.HEIGHT / 2)
	var_7_1:setAnchorPoint(0.5, 0.5)
	var_7_1:setContentSize(arg_7_0.WIDTH, arg_7_0.HEIGHT)
	var_7_1:ignoreAnchorPointForPosition(false)
	var_7_0:setOpacity(50)
	
	arg_7_0.childs_img = {}
	arg_7_0.icons = {}
	
	local var_7_2 = arg_7_1.force_world_id or arg_7_0.controller:getWorldID()
	local var_7_3 = arg_7_0.controller:getLinkDB().world[var_7_2].key_continent
	local var_7_4 = arg_7_0.controller:getContinentID()
	local var_7_5 = {}
	
	for iter_7_0 = 1, 9999 do
		local var_7_6 = var_7_3 .. string.format("%03d", iter_7_0)
		local var_7_7, var_7_8, var_7_9, var_7_10, var_7_11, var_7_12, var_7_13, var_7_14, var_7_15, var_7_16, var_7_17, var_7_18, var_7_19, var_7_20, var_7_21, var_7_22, var_7_23, var_7_24, var_7_25, var_7_26, var_7_27, var_7_28, var_7_29, var_7_30, var_7_31, var_7_32, var_7_33 = DB("level_world_2_continent", var_7_6, {
			"name",
			"key_normal",
			"key_world",
			"nx",
			"ny",
			"name_color",
			"img",
			"scale",
			"x",
			"y",
			"z",
			"big_scale",
			"rotate",
			"color",
			"dungeon_id",
			"lock",
			"name_tag_img",
			"name_tag_tint",
			"name_tag_icon",
			"name_text_align",
			"name_text_bg_hide",
			"name_text_scale",
			"label_text_anchor_x",
			"label_text_anchor_y",
			"quest_target_x",
			"quest_target_y",
			"topbar_name"
		})
		local var_7_34
		
		if var_7_20 == "dark" then
			var_7_20 = arg_7_0.controller.vars.DARK
		elseif var_7_20 == "name_dark" then
			var_7_34 = arg_7_0.controller.vars.DARK_NAME
		end
		
		local var_7_35 = {
			check_text_bg_hide = true,
			name = var_7_7,
			key_normal = var_7_8,
			key_world = var_7_9,
			nx = var_7_10,
			ny = var_7_11,
			nameColor = var_7_34,
			img = var_7_13,
			scale = var_7_14,
			x = var_7_15,
			y = var_7_16,
			z = var_7_17,
			big_scale = var_7_18,
			rotate = var_7_19,
			color = var_7_20,
			dungeon_id = var_7_21,
			lock = var_7_22,
			name_tag_img = var_7_23,
			name_tag_tint = var_7_24,
			name_tag_icon = var_7_25,
			name_text_align = var_7_26,
			name_text_bg_hide = var_7_27,
			name_text_scale = var_7_28,
			label_text_anchor_x = var_7_29,
			label_text_anchor_y = var_7_30,
			quest_target_x = var_7_31,
			quest_target_y = var_7_32,
			topbar_name = var_7_33
		}
		local var_7_36, var_7_37 = arg_7_0.controller:add_map_to_layer(var_7_0, var_7_35)
		
		if not var_7_36 then
			break
		end
		
		var_7_36:setLocalZOrder(var_7_35.z or iter_7_0)
		
		local var_7_38
		local var_7_39
		
		if var_7_21 then
			local var_7_40, var_7_41, var_7_42, var_7_43, var_7_44, var_7_45 = DB("level_battlemenu_dungeon", tostring(var_7_21), {
				"icon_worldmap",
				"x",
				"y",
				"nx",
				"ny",
				"name"
			})
			
			if var_7_40 then
				var_7_38 = var_7_40
				
				local var_7_46 = cc.Sprite:create("map/" .. var_7_40 .. ".png")
				
				if var_7_46 then
					var_7_0:addChild(var_7_46)
					var_7_46:setAnchorPoint(0.5, 0.5)
					var_7_46:setLocalZOrder(100)
					var_7_46:setScale(0.6)
					var_7_46:setPosition(var_7_41 * DESIGN_WIDTH, var_7_42 * DESIGN_HEIGHT)
					var_7_46:setName("dungeon" .. var_7_21)
					
					local var_7_47 = ccui.Text:create()
					
					var_7_47:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
					var_7_47:setFontName("font/daum.ttf")
					var_7_47:setFontSize(24)
					var_7_47:enableOutline(cc.c3b(0, 0, 0), 1)
					var_7_47:setAnchorPoint(0.5, 0.5)
					var_7_47:setPosition(var_7_46:getContentSize().width / 2 + var_7_46:getContentSize().width * var_7_43, var_7_46:getContentSize().height / 2 + var_7_46:getContentSize().height * var_7_44)
					var_7_47:setString(T(var_7_45))
					var_7_47:setName("name" .. var_7_21)
					var_7_47:setLocalZOrder(9999)
					var_7_47:setTextColor(cc.c4b(255, 240, 220, 255))
					var_7_47:setScale(1.6)
					var_7_46:addChild(var_7_47)
					
					var_7_39 = var_7_46
				end
			else
				var_7_21 = nil
			end
		end
		
		local var_7_48 = DB("level_world_3_chapter", var_7_8, "system_ach_id")
		local var_7_49 = UnlockSystem:isUnlockSystem(var_7_48)
		
		if var_7_8 == "ije" then
			var_7_49 = true
		end
		
		if var_7_36 and var_7_48 and not var_7_49 then
			var_7_36:setColor(arg_7_0.controller.vars.DARK)
		end
		
		if var_7_7 ~= nil then
			table.insert(var_7_5, {
				name = var_7_7,
				key = var_7_6,
				key_normal = var_7_8,
				key_world = var_7_9,
				spr = var_7_36,
				img = var_7_13,
				x = var_7_15,
				y = var_7_16,
				icon_wnd = var_7_37,
				big_scale = var_7_18,
				dungeon_id = var_7_21,
				lock = var_7_22
			})
			
			if var_7_37 then
				arg_7_0.icons[var_7_6] = var_7_37
			end
		end
		
		if var_7_4 and var_7_33 and var_7_4 == var_7_6 then
			local var_7_50 = SubstoryManager:getInfo()
			
			TopBarNew:setTitleName(T(var_7_33), nil, var_7_50)
		end
		
		table.insert(arg_7_0.childs_img, {
			name = T(var_7_7),
			key = var_7_6,
			unlock_id = var_7_48,
			color = var_7_20,
			img = var_7_13,
			spr = var_7_36,
			icon_wnd = var_7_37,
			d_img = var_7_38,
			d_spr = var_7_39,
			is_unlock = var_7_49
		})
	end
	
	return var_7_0, var_7_1, var_7_5
end

function WorldMapLand.createQuestNaviIcon(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = cc.Sprite:create("img/map_noti_quest.png")
	
	if var_8_0 then
		arg_8_1:addChild(var_8_0)
		var_8_0:setAnchorPoint(0.5, 0.45)
		var_8_0:setLocalZOrder(99999)
		var_8_0:setScale(0.7)
		var_8_0:setPosition(arg_8_2, arg_8_3)
		
		return var_8_0
	end
end

function WorldMapLand.viewMaze(arg_9_0, arg_9_1, arg_9_2)
	for iter_9_0, iter_9_1 in pairs(arg_9_0.childs) do
		if iter_9_1.dungeon_id then
			local var_9_0 = arg_9_0.main_map_layer:getChildByName("dungeon" .. iter_9_1.dungeon_id)
			
			if var_9_0 then
				local var_9_1 = arg_9_1
				
				if tostring(iter_9_1.dungeon_id) == tostring(arg_9_2) then
					var_9_1 = true
				end
				
				var_9_0:setVisible(var_9_1)
			end
			
			local var_9_2 = arg_9_0.main_map_layer:getChildByName("name" .. iter_9_1.dungeon_id)
			
			if var_9_2 then
				local var_9_3 = arg_9_1
				
				if tostring(iter_9_1.dungeon_id) == tostring(arg_9_2) then
					var_9_3 = true
				end
				
				var_9_2:setVisible(var_9_3)
			end
		end
	end
end

function WorldMapLand.searchLandKey(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.childs) do
		if arg_10_1 == iter_10_1.key then
			return iter_10_1
		end
	end
end

function WorldMapLand.getContinentByKey(arg_11_0, arg_11_1)
	local var_11_0 = cc.c3b(255, 255, 255)
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.childs_img) do
		if iter_11_1.img and iter_11_1.key == (arg_11_1 or "hasud005") then
			return iter_11_1.spr, iter_11_1.d_spr
		end
	end
end

function WorldMapLand.playTownEnterAction(arg_12_0, arg_12_1, arg_12_2)
	SoundEngine:playAmbient("event:/ui/adventure/amb_medium", SoundEngine.AMB_MUSIC_TRACK_1)
	
	if arg_12_2 then
		arg_12_0.main_map_layer:setVisible(false)
		arg_12_0.main_cloud_layer:setVisible(false)
		arg_12_0.controller.vars.backgroundWorld:setVisible(false)
		
		return 
	end
	
	local var_12_0
	local var_12_1
	
	if arg_12_1 then
		var_12_0, var_12_1 = arg_12_1.spr:getPosition()
	else
		var_12_0, var_12_1 = DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2
	end
	
	Action:Add(SEQ(SPAWN(SCALE(600, 1, 4), LOG(ANCHOR(600, cc.p(0.5, 0.5), cc.p(var_12_0 / VIEW_WIDTH, var_12_1 / VIEW_HEIGHT)), 3), SEQ(DELAY(300), FADE_OUT(200))), SHOW(false), CALL(arg_12_0.controller.setVisibleBackground, arg_12_0.controller, false)), arg_12_0.main_map_layer, "worldmap_action")
	Action:Add(SEQ(SPAWN(SCALE(600, 1, 4), LOG(ANCHOR(600, cc.p(0.5, 0.5), cc.p(var_12_0 / VIEW_WIDTH, var_12_1 / VIEW_HEIGHT)), 3), SEQ(DELAY(300), FADE_OUT(200))), SHOW(false)), arg_12_0.main_cloud_layer, "worldmap_action")
	arg_12_0.controller:playCloudEffect(arg_12_0.controller.vars.worldmapUI.wnd)
	set_high_fps_tick(1000)
end

function WorldMapLand.playLandEnterAction_world(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.controller:getWorld()
	
	var_13_0.main_map_layer:setAnchorPoint(arg_13_1.x, arg_13_1.y)
	var_13_0.main_cloud_layer:setAnchorPoint(arg_13_1.x, arg_13_1.y)
	var_13_0.ui_layer:setAnchorPoint(arg_13_1.x, arg_13_1.y)
	var_13_0.main_map_layer:setPosition(arg_13_0.WIDTH * arg_13_1.x, arg_13_0.HEIGHT * arg_13_1.y)
	var_13_0.main_cloud_layer:setPosition(arg_13_0.WIDTH * arg_13_1.x, arg_13_0.HEIGHT * arg_13_1.y)
	var_13_0.ui_layer:setPosition(arg_13_0.WIDTH * arg_13_1.x, arg_13_0.HEIGHT * arg_13_1.y)
	arg_13_0.main_map_layer:setOpacity(255)
	arg_13_0.main_cloud_layer:setOpacity(255)
	
	local var_13_1 = 500
	
	arg_13_0.main_map_layer:setPosition(arg_13_0.WIDTH * arg_13_1.x, arg_13_0.HEIGHT * arg_13_1.y)
	arg_13_0.main_cloud_layer:setPosition(arg_13_0.WIDTH * arg_13_1.x, arg_13_0.HEIGHT * arg_13_1.y)
	arg_13_0.main_map_layer:setAnchorPoint(0.5, 0.5)
	arg_13_0.main_cloud_layer:setAnchorPoint(0.5, 0.5)
	arg_13_0.main_map_layer:setScale(0.5)
	arg_13_0.main_cloud_layer:setScale(0.5)
	arg_13_0.main_map_layer:setVisible(false)
	arg_13_0.main_cloud_layer:setVisible(false)
	Action:AddAsync(SPAWN(SEQ(DELAY(var_13_1 * 0.6), LAYER_OPACITY(var_13_1 * 0.3, 1, 1), LAYER_OPACITY(var_13_1 * 0.05, 1, 0), SHOW(false)), SCALE(var_13_1, 1, arg_13_1.big_scale), MOVE_TO(var_13_1, arg_13_0.WIDTH / 2, arg_13_0.HEIGHT / 2)), var_13_0.main_map_layer, "worldmap_action")
	Action:AddAsync(SPAWN(SEQ(DELAY(var_13_1 * 0.6), LAYER_OPACITY(var_13_1 * 0.6, 1, 0), SHOW(false)), SCALE(var_13_1, 1, arg_13_1.big_scale * 2), MOVE_TO(var_13_1, arg_13_0.WIDTH / 2, arg_13_0.HEIGHT / 2)), var_13_0.main_cloud_layer, "worldmap_action")
	Action:AddAsync(SPAWN(SEQ(DELAY(var_13_1 * 0.6), LAYER_OPACITY(var_13_1 * 0.3, 1, 1), LAYER_OPACITY(var_13_1 * 0.05, 1, 0), SHOW(false)), SCALE(var_13_1, 1, arg_13_1.big_scale), MOVE_TO(var_13_1, arg_13_0.WIDTH / 2, arg_13_0.HEIGHT / 2)), var_13_0.ui_layer, "worldmap_action")
	Action:AddAsync(SPAWN(SHOW(true), LAYER_OPACITY(var_13_1 * 0.8, 0, 1), SCALE(var_13_1, 0.5, 1), MOVE_TO(var_13_1, arg_13_0.WIDTH / 2, arg_13_0.HEIGHT / 2)), arg_13_0.main_map_layer, "worldmap_action")
	Action:AddAsync(SPAWN(SHOW(true), LAYER_OPACITY(var_13_1, 0, 1), SCALE(var_13_1, 0.5, 1), MOVE_TO(var_13_1, arg_13_0.WIDTH / 2, arg_13_0.HEIGHT / 2)), arg_13_0.main_cloud_layer, "worldmap_action")
end

function WorldMapLand.playEnterAction(arg_14_0, arg_14_1)
	arg_14_0.main_map_layer:setVisible(false)
	arg_14_0.main_cloud_layer:setVisible(false)
	arg_14_0.main_map_layer:setOpacity(255)
	arg_14_0.main_cloud_layer:setOpacity(255)
	arg_14_0.controller:playCloudEffect(arg_14_0.controller.vars.worldmapUI.layer)
	set_high_fps_tick(1000)
	Action:Add(SEQ(DELAY(300), SHOW(true), LOG(SPAWN(SCALE(400, 5, 1), RLOG(ANCHOR(400, arg_14_0.main_map_layer:getAnchorPoint(), cc.p(0.5, 0.5)))))), arg_14_0.main_map_layer, "worldmap_action")
	Action:Add(SEQ(DELAY(300), SHOW(true), LOG(SPAWN(SCALE(400, 5, 1), RLOG(ANCHOR(400, arg_14_0.main_cloud_layer:getAnchorPoint(), cc.p(0.5, 0.5)))))), arg_14_0.main_cloud_layer, "worldmap_action")
end

function WorldMapLand.onUnlockActiSkip(arg_15_0)
	if arg_15_0.unlock_action_mode.type == "maze" then
		UIAction:Remove("unlockAction")
		
		if get_cocos_refid(arg_15_0.unlock_action_mode.effect) then
			arg_15_0.unlock_action_mode.effect:setVisible(false)
			stop_or_remove(arg_15_0.unlock_action_mode.effect)
			stop_or_remove(arg_15_0.unlock_action_mode.particle)
		end
		
		UIAction:Add(SEQ(DELAY(200), CALL(arg_15_0.unlockAction_maze_showMaze, arg_15_0, arg_15_0.unlock_action_mode.sys_id), TARGET(arg_15_0.unlock_action_mode.dungeon_spr, BLEND(1, "white", 1, 0))), arg_15_0.main_map_layer, "worldmap_action")
		play_curtain(arg_15_0.controller.vars.layer, 0, 150, 250, 800, "worldmap_action", true)
	elseif arg_15_0.unlock_action_mode.type == "continent" then
		UIAction:Remove("unlockAction")
		stop_or_remove(arg_15_0.unlock_action_mode.effect)
		CACHE:releaseModel(arg_15_0.unlock_action_mode.particle)
		UIAction:Add(SEQ(DELAY(200), CALL(arg_15_0.unlockAction_moveTown, arg_15_0, nil), DELAY(0), CALL(arg_15_0.unlockAction_moveTown_startStory, arg_15_0, arg_15_0.unlock_action_mode)), arg_15_0.main_map_layer, "worldmap_action")
		play_curtain(arg_15_0.controller.vars.layer, 0, 150, 250, 800, "worldmap_action", true)
	end
end

function WorldMapLand.onTouchDown(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0.unlock_action_mode then
		return 
	end
	
	if Action:Find("worldmap_action") ~= nil then
		return 
	end
	
	local var_16_0 = arg_16_0.childs
	local var_16_1 = arg_16_0.main_map_layer
	local var_16_2 = var_16_0[slowpick2(var_16_1, var_16_0, arg_16_1, arg_16_2)]
	
	if not var_16_2 then
	elseif var_16_2.lock then
		Dialog:msgBox(T("mission_notyet"))
	elseif var_16_2.key_normal then
		arg_16_0:enterChapter(var_16_2.key, var_16_2.key_normal, var_16_2)
	else
		Dialog:msgBox(T("mission_notyet"))
	end
end

function WorldMapLand.enterChapter(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = DB("level_world_3_chapter", arg_17_2, "lock_schedule")
	
	if var_17_0 and not SubstoryManager:isActiveSchedule(var_17_0) then
		local var_17_1 = SubstoryManager:getRemainEnterTime(var_17_0)
		
		if var_17_1 then
			Dialog:msgBox(T("continent_lock_schedule_desc", {
				time = sec_to_full_string(var_17_1)
			}))
		end
		
		return 
	end
	
	arg_17_0.controller:setMapKey(arg_17_2)
	arg_17_0.controller:changeMode("TOWN", arg_17_3)
end

function WorldMapLand.getChildByContinentID(arg_18_0, arg_18_1)
	for iter_18_0, iter_18_1 in pairs(arg_18_0.childs) do
		if iter_18_1.key == arg_18_1 then
			return iter_18_1
		end
	end
	
	return v
end

function WorldMapLand.unlockMazeAction(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = DB("system_achievement_effect", arg_19_2, "effect_value") or "continent_id=cidonia002,world_id=6"
	local var_19_1 = totable(var_19_0)
	local var_19_2 = var_19_1.continent_id
	local var_19_3 = string.sub(var_19_1.continent_id, 1, -4)
	
	arg_19_0.controller:changeMode("LAND", nil, true, {
		force_continent_key = var_19_3,
		force_world_id = var_19_1.world_id
	})
	arg_19_0:setVisible_unlockActionUI({
		maze = false,
		ui = false,
		maze_key = arg_19_1
	})
	
	arg_19_0.unlock_action_mode = {
		type = "maze",
		sys_id = arg_19_2,
		maze_key = arg_19_1
	}
	arg_19_2 = arg_19_2 or "system_003"
	arg_19_1 = arg_19_1 or "1"
	
	arg_19_0:changeAllContinentColor(var_19_2, {
		hide_continent = true
	})
	
	local var_19_4 = 1.5
	local var_19_5, var_19_6 = arg_19_0:getContinentByKey(var_19_2)
	local var_19_7 = (var_19_5:getPositionX() - arg_19_0.main_map_layer:getPositionX()) / VIEW_WIDTH
	local var_19_8 = (var_19_5:getPositionY() - arg_19_0.main_map_layer:getPositionY()) / VIEW_HEIGHT
	
	arg_19_0.main_map_layer:ignoreAnchorPointForPosition(false)
	arg_19_0.main_map_layer:setAnchorPoint(0.5 + var_19_7, 0.5 + var_19_8)
	arg_19_0.main_map_layer:setScale(var_19_4)
	set_high_fps_tick(6000)
	UIAction:Add(SEQ(LOG(SCALE(825, var_19_4, var_19_4 + 0.23)), CALL(arg_19_0.unlockAction_maze_curtain, arg_19_0), CALL(arg_19_0.unlockAction_maze_eff1, arg_19_0, var_19_5, var_19_6, arg_19_2, arg_19_1), DELAY(2937), DELAY(2673), SCALE(495, var_19_4 + 0.23, var_19_4 + 0.45), CALL(arg_19_0.unlockAction_maze_showMaze, arg_19_0, arg_19_2)), arg_19_0.main_map_layer, "unlockAction")
end

function WorldMapLand.unlockContinentAction(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	set_high_fps_tick(6000)
	arg_20_0.controller:changeMode("LAND", nil, true)
	arg_20_0:setVisible_unlockActionUI({
		ui = false
	})
	
	arg_20_0.unlock_action_mode = {
		type = "continent",
		sys_id = arg_20_3,
		last_continent = arg_20_1
	}
	
	local var_20_0 = 1.5
	local var_20_1 = arg_20_0:changeAllContinentColor(arg_20_1)
	local var_20_2 = (var_20_1:getPositionX() - arg_20_0.main_map_layer:getPositionX()) / VIEW_WIDTH
	local var_20_3 = (var_20_1:getPositionY() - arg_20_0.main_map_layer:getPositionY()) / VIEW_HEIGHT
	
	arg_20_0.main_map_layer:ignoreAnchorPointForPosition(false)
	arg_20_0.main_map_layer:setAnchorPoint(0.5 + var_20_2, 0.5 + var_20_3)
	arg_20_0.main_map_layer:setScale(var_20_0)
	
	arg_20_2 = arg_20_2 or "hasud005"
	
	local var_20_4 = arg_20_0.controller:getLinkDB().continent[arg_20_2].key_normal
	
	arg_20_0.controller:setMapKey(var_20_4)
	
	local var_20_5, var_20_6, var_20_7 = DB("level_world_2_continent", arg_20_2, {
		"id",
		"key_normal",
		"key_world"
	})
	local var_20_8 = DB("level_world_3_chapter", var_20_6, {
		"start_enter"
	})
	
	arg_20_0.controller:saveLastTown(var_20_8)
	
	local var_20_9 = arg_20_0:getContinentByKey(arg_20_2)
	local var_20_10, var_20_11 = var_20_9:getPosition()
	
	UIAction:Add(SEQ(LOG(ANCHOR(990, arg_20_0.main_map_layer:getAnchorPoint(), cc.p(var_20_10 / VIEW_WIDTH, var_20_11 / VIEW_HEIGHT))), DELAY(198), CALL(arg_20_0.eff_newContinent, arg_20_0, var_20_9, arg_20_3, arg_20_2), DELAY(170), CALL(arg_20_0.changeColorNewContinent, arg_20_0, arg_20_2), DELAY(4582), SPAWN(SCALE(495, var_20_0, var_20_0 + 0.25), CALL(arg_20_0.unlockAction_enterTown, arg_20_0, nil)), DELAY(330), CALL(arg_20_0.unlockAction_moveTown, arg_20_0, nil), DELAY(0), CALL(arg_20_0.unlockAction_moveTown_startStory, arg_20_0, arg_20_0.unlock_action_mode)), arg_20_0.main_map_layer, "unlockAction")
end

function WorldMapLand.changeAllContinentColor(arg_21_0, arg_21_1, arg_21_2)
	arg_21_2 = arg_21_2 or {}
	
	local var_21_0 = cc.c3b(100, 100, 100)
	local var_21_1 = 100
	
	if arg_21_2.all then
		var_21_0 = cc.c3b(255, 255, 255)
		var_21_1 = 255
	end
	
	local var_21_2
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.childs_img) do
		if iter_21_1.spr and (iter_21_1.key ~= arg_21_1 or arg_21_2.all) then
			iter_21_1.spr:setColor(var_21_0)
		else
			var_21_2 = iter_21_1.spr
		end
		
		if arg_21_2.hide_continent then
			if iter_21_1.icon_wnd then
				iter_21_1.icon_wnd:setVisible(false)
			end
		elseif iter_21_1.icon_wnd and (iter_21_1.key ~= arg_21_1 or arg_21_2.all) then
			iter_21_1.icon_wnd:setColor(var_21_0)
			iter_21_1.icon_wnd:setOpacity(var_21_1)
		end
	end
	
	if arg_21_0.controller.vars.backgroundWorld then
		arg_21_0.controller.vars.backgroundWorld:setColor(var_21_0)
	end
	
	return var_21_2
end

function WorldMapLand.revertAllContinentColor(arg_22_0)
	local var_22_0
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.childs_img) do
		if iter_22_1.spr and not iter_22_1.is_unlock and iter_22_1.unlock_id then
			if iter_22_1.color then
				iter_22_1.spr:setColor(iter_22_1.color)
			else
				iter_22_1.spr:setColor(arg_22_0.controller.vars.DARK)
				
				if iter_22_1.icon_wnd then
				end
			end
		elseif iter_22_1.spr and iter_22_1.color then
			iter_22_1.spr:setColor(iter_22_1.color)
		end
	end
	
	return var_22_0
end

function WorldMapLand.changeColorNewContinent(arg_23_0, arg_23_1)
	local var_23_0 = cc.c3b(255, 255, 255)
	local var_23_1
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.childs_img) do
		if iter_23_1.img and iter_23_1.key == (arg_23_1 or "hasud005") then
			iter_23_1.spr:setColor(var_23_0)
			
			var_23_1 = iter_23_1.spr
		end
		
		if iter_23_1.icon_wnd and iter_23_1.key == (arg_23_1 or "hasud005") then
			iter_23_1.icon_wnd:setColor(var_23_0)
			iter_23_1.icon_wnd:setOpacity(255)
			
			break
		end
	end
	
	return var_23_1
end

function WorldMapLand.unlock_UI_Action(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = load_dlg("unlock_world_action", true, "wnd")
	
	var_24_0:setName("unlock_world_action")
	var_24_0:setPositionY(505)
	arg_24_0.layer:addChild(var_24_0)
	
	local var_24_1, var_24_2 = DB("system_achievement_effect", arg_24_2, {
		"effect_title",
		"type"
	})
	
	if_set(var_24_0, "txt_open", T(var_24_1))
	
	if var_24_2 == UNLOCK_TYPE.MAZE then
		local var_24_3 = DB("level_battlemenu_dungeon", arg_24_3, {
			"name"
		})
		
		if_set(var_24_0, "txt_title", T(var_24_3))
	elseif var_24_2 == UNLOCK_TYPE.CONTINENT then
		local var_24_4 = DB("level_world_2_continent", arg_24_3, {
			"name"
		})
		
		if_set(var_24_0, "txt_title", T(var_24_4))
	end
	
	local var_24_5 = var_24_0:getChildByName("txt_open")
	local var_24_6 = var_24_0:getChildByName("txt_title")
	local var_24_7 = var_24_0:getChildByName("grow")
	
	var_24_5:setOpacity(0)
	var_24_7:setOpacity(0)
	var_24_5:setPositionY(var_24_5:getPositionY() + 50)
	var_24_6:setOpacity(0)
	
	arg_24_1 = arg_24_1 or 0
	
	UIAction:Add(SEQ(DELAY(arg_24_1), SPAWN(LOG(FADE_IN(825)), LOG(MOVE_BY(825, 0, -50)))), var_24_5, "unlockAction")
	UIAction:Add(SEQ(DELAY(495), FADE_IN(1320)), var_24_6, "unlockAction")
	UIAction:Add(SEQ(DELAY(495), OPACITY(1320, 0, 0.6)), var_24_7, "unlockAction")
	
	local var_24_8 = CACHE:getEffect("ui_worldmap_unlock_pati1.particle", "effect")
	
	var_24_8:setAutoRemoveOnFinish(true)
	var_24_8:setScale(1.3)
	var_24_8:setPosition(var_24_6:getContentSize().width / 2 + var_24_8:getPositionX(), var_24_6:getContentSize().height / 2 + var_24_8:getPositionY())
	var_24_0:getChildByName("txt_title"):addChildLast(var_24_8)
	var_24_8:start()
	
	arg_24_0.unlock_action_mode.particle = var_24_8
end

function WorldMapLand.setVisible_unlockActionUI(arg_25_0, arg_25_1)
	arg_25_1 = arg_25_1 or {}
	
	arg_25_0.controller.vars.ui_layer:setVisible(arg_25_1.ui)
	arg_25_0:viewMaze(arg_25_1.ui or arg_25_1.maze, arg_25_1.maze_key)
end

function WorldMapLand.eff_newContinent(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if arg_26_0.unlock_action_mode then
		arg_26_0.unlock_action_mode.effect = EffectManager:Play({
			fn = "ui_worldmap_unlock.cfx",
			pivot_z = 99999999,
			layer = arg_26_0.main_map_layer,
			pivot_x = arg_26_1:getPositionX(),
			pivot_y = arg_26_1:getPositionY()
		})
	end
	
	arg_26_0:unlock_UI_Action(297, arg_26_2, arg_26_3)
end

function WorldMapLand.unlockAction_enterTown(arg_27_0)
	play_curtain(arg_27_0.controller.vars.layer, 0, 825, 33, 462, "worldmap_action", true, nil, nil, cc.c3b(0, 0, 0))
end

function WorldMapLand.unlockAction_moveTown(arg_28_0)
	arg_28_0.controller:changeMode("TOWN", nil, true)
	arg_28_0.layer:removeChildByName("unlock_world_action")
	arg_28_0:setVisible_unlockActionUI({
		ui = true
	})
	arg_28_0:changeAllContinentColor(nil, {
		all = true
	})
	arg_28_0:viewMaze(false)
	arg_28_0:revertAllContinentColor()
	
	if arg_28_0.controller.vars.land_navi_icon then
		arg_28_0.controller.vars.land_navi_icon:setVisible(true)
	end
end

function WorldMapLand.unlockAction_moveTown_startStory(arg_29_0, arg_29_1)
	arg_29_0.unlock_action_mode = nil
	arg_29_0.isSkip_mode = nil
	
	local var_29_0 = DB("system_achievement_effect", arg_29_1.sys_id, {
		"effect_after_story"
	})
	
	if var_29_0 then
		if TutorialGuide:getTutorialID(arg_29_1.sys_id) then
			start_new_story(arg_29_0.layer, var_29_0, {
				force = true,
				on_finish = function()
					TutorialGuide:startGuide(arg_29_1.sys_id)
				end
			})
		else
			start_new_story(arg_29_0.layer, var_29_0, {
				force = true
			})
		end
	elseif TutorialGuide:getTutorialID(arg_29_1.sys_id) then
		TutorialGuide:startGuide(arg_29_1.sys_id)
	elseif arg_29_1.sys_id == UNLOCK_ID.ADIN_AWAKE then
		TutorialGuide:ifStartGuide("tuto_adin_awake_1")
	end
end

function WorldMapLand.unlockAction_maze_showMaze(arg_31_0, arg_31_1)
	arg_31_0.layer:removeChildByName("unlock_world_action")
	
	if arg_31_0.controller.vars.land_navi_icon then
		arg_31_0.controller.vars.land_navi_icon:setVisible(true)
	end
	
	local var_31_0 = DB("system_achievement_effect", arg_31_1, {
		"effect_after_story"
	})
	
	if var_31_0 then
		start_new_story(arg_31_0.layer, var_31_0, {
			force = true,
			on_finish = function()
				arg_31_0.isSkip_mode = nil
				arg_31_0.unlock_action_mode = nil
				
				SceneManager:nextScene("lobby", {
					unlock_id = UNLOCK_ID.MAZE
				})
			end
		})
	else
		arg_31_0.isSkip_mode = nil
		arg_31_0.unlock_action_mode = nil
		
		SceneManager:nextScene("lobby", {
			unlock_id = UNLOCK_ID.MAZE
		})
	end
end

function WorldMapLand.unlockAction_maze_curtain(arg_33_0)
	play_curtain(arg_33_0.layer, 0, 957, 330, 1650, "unlockAction", true, 999, 0.8)
end

function WorldMapLand.unlockAction_maze_eff1(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	UIAction:Add(SEQ(LOG(BLEND(957, "white", 0, 1)), DELAY(198), CALL(arg_34_0.unlock_UI_Action, arg_34_0, nil, arg_34_3, arg_34_4), DELAY(132), BLEND(1650, "white", 1, 0)), arg_34_2, "unlockAction")
	
	arg_34_0.unlock_action_mode.dungeon_spr = arg_34_2
	arg_34_0.unlock_action_mode.effect = EffectManager:Play({
		fn = "ui_maze_unlock.cfx",
		pivot_z = 99999,
		layer = arg_34_0.main_map_layer,
		pivot_x = arg_34_2:getPositionX(),
		pivot_y = arg_34_2:getPositionY()
	})
end

WorldMapLandAdv = ClassDef(WorldMapLand)

function WorldMapLandAdv.constructor(arg_35_0)
end

WorldMapLandSub = ClassDef(WorldMapLand)

function WorldMapLandSub.constructor(arg_36_0)
end

WorldMapLandCustom = ClassDef(WorldMapLand)

function WorldMapLandCustom.constructor(arg_37_0)
end
