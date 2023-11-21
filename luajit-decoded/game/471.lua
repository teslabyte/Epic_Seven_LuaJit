SubWorldMapController = SubWorldMapController or {}

copy_functions(WorldMapController, SubWorldMapController)

SUB_WORLDMAP_CONTINENT_ZOOM = {
	IN = {
		LAND = "TOWN"
	},
	OUT = {
		TOWN = "LAND"
	}
}
SUB_WORLDMAP_WORLD_ZOOM = {
	IN = {
		LAND = "TOWN",
		WORLD = "LAND"
	},
	OUT = {
		LAND = "WORLD",
		TOWN = "LAND"
	}
}
WORLDMAP_LIMIT_ZOOM_TYPE = {
	CHAPTER = "chapter",
	WORLD = "world",
	CONTINENT = "continent"
}

function SubWorldMapController.getLinkDB(arg_1_0)
	local var_1_0 = SubstoryManager:getInfo().id
	
	return WorldMapManager:getSubstoryLinkDB(var_1_0)
end

function SubWorldMapController.create(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_0.vars.DARK = cc.c3b(180, 130, 130)
	arg_2_0.vars.DARK_NAME = cc.c3b(255, 180, 180)
	arg_2_0.vars.HEIGHT = DESIGN_HEIGHT
	arg_2_0.vars.WIDTH = DESIGN_WIDTH
	arg_2_0.vars.SCALE = nil
	arg_2_0.vars.type = WORLDMAP_TYPE.SUB_STORY
	arg_2_0.vars.sub_story = SubstoryManager:getInfo()
	
	local var_2_0 = arg_2_0.vars.sub_story.id
	
	arg_2_0.vars.mode = "TOWN"
	
	if get_cocos_refid(arg_2_0.vars.layer) then
		arg_2_0.vars.layer:removeAllChildren()
	end
	
	local var_2_1 = cc.Layer:create()
	
	arg_2_0.vars.layer = var_2_1
	
	local var_2_2 = WorldMapLandSub()
	
	arg_2_0.vars.land = var_2_2
	
	local var_2_3 = tostring(SubstoryManager:getWorldMapContentsDB().world_id)
	local var_2_4, var_2_5, var_2_6, var_2_7, var_2_8 = DB("level_world_1_world", var_2_3, {
		"img",
		"scale",
		"x",
		"y",
		"align"
	})
	local var_2_9 = {
		img = var_2_4,
		scale = var_2_5,
		x = var_2_6,
		y = var_2_7,
		align = var_2_8
	}
	
	arg_2_0.vars.backgroundWorld = arg_2_0:add_map_to_layer(arg_2_0.vars.layer, var_2_9)
	
	arg_2_0.vars.backgroundWorld:setLocalZOrder(1)
	arg_2_0.vars.backgroundWorld:setName(var_2_4)
	arg_2_0:setVisibleBackground(false)
	
	local var_2_10 = WorldMapWorldSub()
	local var_2_11 = var_2_10:create(arg_2_0)
	
	arg_2_0.vars.world = var_2_10
	arg_2_0.vars.sub_story.world_depth, arg_2_0.vars.sub_story.world_id = DB(arg_2_0.vars.sub_story.contents_type, arg_2_0.vars.sub_story.id, {
		"world_depth",
		"world_id"
	})
	
	if not arg_2_0.vars.sub_story.world_depth or not arg_2_0.vars.sub_story.world_id then
		Log.e("contents_db_err", arg_2_0.vars.sub_story.contents_type .. ":" .. arg_2_0.vars.sub_story.id)
	end
	
	local var_2_12, var_2_13, var_2_14, var_2_15 = DB("level_world_1_world", tostring(arg_2_0.vars.sub_story.world_id), {
		"key_continent",
		"default_continent",
		"default_chapter",
		"bgm"
	})
	local var_2_16 = Account:getConfigData("last_clear_town." .. var_2_0) or var_2_14 .. "001"
	local var_2_17 = DB("level_enter", var_2_16, {
		"local_num"
	}) or var_2_14
	local var_2_18 = arg_2_0:getLinkDB()
	local var_2_19 = var_2_18.chapter[var_2_17]
	
	if not var_2_19 then
		var_2_17 = var_2_14
		var_2_19 = var_2_18.chapter[var_2_17]
	end
	
	arg_2_0.vars.world_id = var_2_19.world_id
	arg_2_0.vars.bgm = var_2_15
	
	arg_2_0.vars.layer:addChild(var_2_11)
	var_2_11:setLocalZOrder(2)
	
	local var_2_20 = var_2_2:create(arg_2_0)
	
	arg_2_0.vars.layer:addChild(var_2_20)
	var_2_20:setLocalZOrder(3)
	
	local var_2_21 = WorldMapTownSub()
	local var_2_22 = var_2_21:create(arg_2_0, var_2_17, arg_2_1)
	
	arg_2_0.vars.town = var_2_21
	
	arg_2_0.vars.layer:addChild(var_2_22)
	var_2_22:setLocalZOrder(0)
	
	local var_2_23 = SubWorldMapUI:create(arg_2_0)
	
	arg_2_0.vars.worldmapUI = SubWorldMapUI
	
	arg_2_0.vars.layer:addChild(var_2_23)
	
	arg_2_0.vars.ui_layer = var_2_23
	
	var_2_23:setLocalZOrder(10)
	arg_2_0.vars.worldmapUI:setMapMagnifier("TOWN")
	var_2_23:setContentSize(arg_2_0.vars.WIDTH, arg_2_0.vars.HEIGHT)
	var_2_1:setContentSize(arg_2_0.vars.WIDTH, arg_2_0.vars.HEIGHT)
	var_2_1:setPosition(arg_2_0.vars.WIDTH / 2, arg_2_0.vars.HEIGHT / 2)
	var_2_1:setAnchorPoint(0.5, 0.5)
	var_2_1:ignoreAnchorPointForPosition(false)
	
	arg_2_0.vars.allLayers = {}
	arg_2_0.vars.allLayers.WORLD = var_2_11
	arg_2_0.vars.allLayers.LAND = var_2_20
	arg_2_0.vars.allLayers.TOWN = var_2_22
	
	arg_2_0.vars.worldmapUI:UpdateAfterShowTown(arg_2_0:getMapKey())
	arg_2_0:setVisibleJustOneMode(arg_2_0.vars.mode)
	arg_2_0.vars.worldmapUI:setBattleEnterBtn()
	
	return var_2_1
end

function SubWorldMapController.getZoomContentsType(arg_3_0)
	return arg_3_0.vars.sub_story.world_depth
end

function SubWorldMapController.zoom(arg_4_0, arg_4_1)
	local var_4_0 = {}
	
	if arg_4_0.vars.sub_story.world_depth == WORLDMAP_LIMIT_ZOOM_TYPE.CONTINENT then
		var_4_0 = SUB_WORLDMAP_CONTINENT_ZOOM
	else
		var_4_0 = SUB_WORLDMAP_WORLD_ZOOM
	end
	
	if arg_4_0.vars.sub_story.world_depth == WORLDMAP_LIMIT_ZOOM_TYPE.CHAPTER then
	else
		local var_4_1 = var_4_0[arg_4_1][arg_4_0.vars.mode]
		
		if var_4_1 then
			arg_4_0:changeMode(var_4_1)
		end
	end
end

function SubWorldMapController.setLandNavigator(arg_5_0, arg_5_1, arg_5_2)
	if SubstoryManager:isActiveQuestInChapter(arg_5_2.key_normal) then
		local var_5_0 = arg_5_2.quest_target_x or 0
		local var_5_1 = arg_5_2.quest_target_y or 0
		local var_5_2 = UIUtil:makeNavigatorAni({
			scale = 0.55
		})
		
		var_5_2:setLocalZOrder(99999)
		var_5_2:setPosition((arg_5_2.x + arg_5_2.nx) * arg_5_0.vars.WIDTH, (arg_5_2.y + arg_5_2.ny) * arg_5_0.vars.HEIGHT + 22)
		var_5_2:setPositionX(var_5_2:getPositionX() + var_5_0)
		var_5_2:setPositionY(var_5_2:getPositionY() + var_5_1)
		arg_5_1:addChild(var_5_2)
		
		arg_5_0.vars.land_navi_icon = var_5_2
	end
end

function SubWorldMapController.saveLastTown(arg_6_0, arg_6_1)
	if arg_6_1 and arg_6_0.vars then
		if DB("level_enter", arg_6_1, "skip_stage_save") then
			return 
		end
		
		local var_6_0 = arg_6_0:getSubStroyData()
		local var_6_1 = SubstoryManager:getInfo()
		
		if not var_6_1 then
			return 
		end
		
		if var_6_1.id ~= var_6_0.id then
			return 
		end
		
		SAVE:setTempConfigData("last_clear_town." .. var_6_0.id, arg_6_1)
	end
end

function SubWorldMapController.onEnterScene(arg_7_0)
	if TutorialGuide:onEnterWorldMap() and BattleReady:isValid() then
		BattleReady:hide(true)
	end
end

function SubWorldMapController.worldmap(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or {}
	
	if arg_8_1.no_check_dungeon then
		SceneManager:nextScene("world_sub", arg_8_1)
		
		return 
	end
	
	if not Account:checkQueryEmptyDungeonData("worldmap.nextscene") then
		SceneManager:nextScene("world_sub", arg_8_1)
	end
end

CustomWorldMapController = CustomWorldMapController or {}

copy_functions(SubWorldMapController, CustomWorldMapController)

function CustomWorldMapController.create(arg_9_0, arg_9_1)
	arg_9_0.vars = {}
	arg_9_0.vars.DARK = cc.c3b(180, 130, 130)
	arg_9_0.vars.DARK_NAME = cc.c3b(255, 180, 180)
	arg_9_0.vars.HEIGHT = DESIGN_HEIGHT
	arg_9_0.vars.WIDTH = DESIGN_WIDTH
	arg_9_0.vars.SCALE = nil
	arg_9_0.vars.type = WORLDMAP_TYPE.CUSTOM
	arg_9_0.vars.sub_story = SubstoryManager:getInfo()
	
	local var_9_0 = arg_9_0.vars.sub_story.id
	
	arg_9_0.vars.mode = "TOWN"
	
	if get_cocos_refid(arg_9_0.vars.layer) then
		arg_9_0.vars.layer:removeAllChildren()
	end
	
	local var_9_1 = cc.Layer:create()
	
	arg_9_0.vars.layer = var_9_1
	
	local var_9_2 = tostring(SubstoryManager:getWorldMapContentsDB().world_id)
	local var_9_3 = WorldMapLandCustom()
	
	arg_9_0.vars.land = var_9_3
	
	local var_9_4, var_9_5, var_9_6, var_9_7, var_9_8 = DB("level_world_1_world", var_9_2, {
		"img",
		"scale",
		"x",
		"y",
		"align"
	})
	local var_9_9 = {
		img = var_9_4,
		scale = var_9_5,
		x = var_9_6,
		y = var_9_7,
		align = var_9_8
	}
	
	arg_9_0.vars.backgroundWorld = arg_9_0:add_map_to_layer(arg_9_0.vars.layer, var_9_9)
	
	arg_9_0.vars.backgroundWorld:setLocalZOrder(1)
	arg_9_0.vars.backgroundWorld:setName(var_9_4)
	arg_9_0:setVisibleBackground(false)
	
	local var_9_10 = WorldMapWorldCustom()
	local var_9_11 = var_9_10:create(arg_9_0)
	
	arg_9_0.vars.world = var_9_10
	arg_9_0.vars.sub_story.world_depth, arg_9_0.vars.sub_story.world_id = DB(arg_9_0.vars.sub_story.contents_type, arg_9_0.vars.sub_story.id, {
		"world_depth",
		"world_id"
	})
	
	local var_9_12, var_9_13, var_9_14, var_9_15 = DB("level_world_1_world", tostring(arg_9_0.vars.sub_story.world_id), {
		"key_continent",
		"default_continent",
		"default_chapter",
		"bgm"
	})
	local var_9_16 = Account:getConfigData("last_clear_town." .. var_9_0) or var_9_14 .. "001"
	local var_9_17 = DB("level_enter", var_9_16, {
		"local_num"
	}) or var_9_14
	local var_9_18 = arg_9_0:getLinkDB()
	local var_9_19 = var_9_18.chapter[var_9_17]
	
	if not var_9_19 then
		var_9_17 = var_9_14
		var_9_19 = var_9_18.chapter[var_9_17]
		
		arg_9_0:saveLastTown(var_9_14 .. "001")
	end
	
	arg_9_0.vars.world_id = var_9_19.world_id
	arg_9_0.vars.bgm = var_9_15
	
	arg_9_0.vars.layer:addChild(var_9_11)
	var_9_11:setLocalZOrder(2)
	
	local var_9_20 = var_9_3:create(arg_9_0)
	
	arg_9_0.vars.layer:addChild(var_9_20)
	var_9_20:setLocalZOrder(3)
	
	local var_9_21 = WorldMapTownCustom()
	local var_9_22 = var_9_21:create(arg_9_0, var_9_17, arg_9_1)
	
	arg_9_0.vars.town = var_9_21
	
	arg_9_0.vars.layer:addChild(var_9_22)
	var_9_22:setLocalZOrder(0)
	
	local var_9_23 = CustomWorldMapUI:create(arg_9_0)
	
	arg_9_0.vars.worldmapUI = CustomWorldMapUI
	
	arg_9_0.vars.layer:addChild(var_9_23)
	
	arg_9_0.vars.ui_layer = var_9_23
	
	var_9_23:setLocalZOrder(10)
	arg_9_0.vars.worldmapUI:setMapMagnifier("TOWN")
	var_9_23:setContentSize(arg_9_0.vars.WIDTH, arg_9_0.vars.HEIGHT)
	var_9_1:setContentSize(arg_9_0.vars.WIDTH, arg_9_0.vars.HEIGHT)
	var_9_1:setPosition(arg_9_0.vars.WIDTH / 2, arg_9_0.vars.HEIGHT / 2)
	var_9_1:setAnchorPoint(0.5, 0.5)
	var_9_1:ignoreAnchorPointForPosition(false)
	
	arg_9_0.vars.allLayers = {}
	arg_9_0.vars.allLayers.WORLD = var_9_11
	arg_9_0.vars.allLayers.LAND = var_9_20
	arg_9_0.vars.allLayers.TOWN = var_9_22
	
	arg_9_0.vars.worldmapUI:UpdateAfterShowTown(arg_9_0:getMapKey())
	arg_9_0:setVisibleJustOneMode(arg_9_0.vars.mode)
	arg_9_0.vars.worldmapUI:setBattleEnterBtn()
	
	if arg_9_1.pathParams and arg_9_1.pathParams.continentkey and arg_9_1.pathParams.continent then
		arg_9_0:setting_shortcut_town(arg_9_1.pathParams.continentkey or "vewrda", arg_9_1.pathParams.continent or "wrd_rehas")
		
		if arg_9_1.pathParams.substory_id == "vewrda" and arg_9_1.pathParams.map_id then
			UIAction:Remove("block")
			arg_9_0.vars.town:showMapDialog(arg_9_0.vars.town.maps[arg_9_1.pathParams.map_id])
		end
	end
	
	return var_9_1
end

function CustomWorldMapController.worldmap(arg_10_0, arg_10_1)
	arg_10_1 = arg_10_1 or {}
	
	if arg_10_1.no_check_dungeon then
		SceneManager:nextScene("world_custom", arg_10_1)
		
		return 
	end
	
	if not Account:checkQueryEmptyDungeonData("worldmap.nextscene") then
		SceneManager:nextScene("world_custom", arg_10_1)
	end
end

function CustomWorldMapController.onEnterScene(arg_11_0)
	if TutorialGuide:onEnterWorldMap() and BattleReady:isValid() then
		BattleReady:hide(true)
	end
end
