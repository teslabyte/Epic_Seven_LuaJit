TOWN_MARK_SCALE = 1.8
TOWN_MAP_SCALE = 1
ICON_SIMPLIFY_START = 0.85
TOWN_MIN_SCALE = 0.57
TOWN_DEFAULT_SCALE = 0.38
TOUCH_SENSITIVITY_DUNGEON_ENTER = 0.06
CHARACTER_SPEED = 0.7
CHARACTER_ANI_TIMESCALE = 0.9
TOWN_CHARACTER_SCALE = 1
TOWN_VIEW_CHARACTER_SCALE = 5

local var_0_0 = {
	CLOSE = 2,
	NEW = 3,
	OPEN = 1
}
local var_0_1 = {
	FOCUS = 9999,
	MAP_ICON = 99,
	WND = 3,
	NAVIGATOR = 99999,
	MAP = 1
}

function decodeTownTagIcon(arg_1_0)
	if arg_1_0 then
		local var_1_0 = totable(arg_1_0, "=", ";")
		
		if var_1_0["1"] then
			for iter_1_0 = 1, 3 do
				local var_1_1 = false
				local var_1_2 = string.split(var_1_0[tostring(iter_1_0)], ",")
				local var_1_3 = string.split(var_1_2[1], "&")
				local var_1_4 = var_1_3[1]
				local var_1_5 = var_1_3[2]
				
				if var_1_5 == "sub_ach" then
					var_1_1 = ConditionContentsManager:getSubStoryAchievement():isCleared(var_1_4)
				elseif var_1_5 == "sys_ach" then
					var_1_1 = Account:isSysAchieveCleared(var_1_4)
				elseif var_1_5 == "stage_clear" then
					var_1_1 = Account:isMapCleared(var_1_4)
				else
					var_1_1 = ConditionContentsManager:isMissionCleared(var_1_4)
				end
				
				if var_1_5 == "sys_ach" or not var_1_1 and var_1_2[2] and var_1_2[2] ~= "" then
					if var_1_2[2] ~= "none" then
						return var_1_2[2]
					end
					
					do break end
					break
				end
			end
		else
			return arg_1_0
		end
	end
	
	return nil
end

function decodeLocalIcon(arg_2_0)
	if arg_2_0 then
		local var_2_0 = totable(arg_2_0, "=", ";")
		
		if var_2_0["1"] then
			for iter_2_0 = 1, 3 do
				local var_2_1 = false
				local var_2_2 = string.split(var_2_0[tostring(iter_2_0)], ",")
				local var_2_3 = string.split(var_2_2[1], "&")
				local var_2_4 = var_2_3[1]
				local var_2_5 = var_2_3[2]
				
				if var_2_5 == "sub_ach" then
					var_2_1 = ConditionContentsManager:getSubStoryAchievement():isCleared(var_2_4)
				elseif var_2_5 == "sys_ach" then
					var_2_1 = Account:isSysAchieveCleared(var_2_4)
				elseif var_2_5 == "stage_clear" then
					var_2_1 = Account:isMapCleared(var_2_4)
				else
					var_2_1 = ConditionContentsManager:isMissionCleared(var_2_4)
				end
				
				if var_2_5 == "sys_ach" or not var_2_1 and var_2_2[2] and var_2_2[2] ~= "" then
					if var_2_2[2] ~= "none" then
						return var_2_2[2], true
					end
					
					do break end
					break
				end
			end
		else
			return arg_2_0
		end
	end
	
	return nil
end

WorldMapTown = ClassDef()

function WorldMapTown.constructor(arg_3_0)
end

function WorldMapTown.clear(arg_4_0)
	arg_4_0.navigator = nil
	arg_4_0.layout = nil
	arg_4_0.icons = {}
	arg_4_0.iconInfo = {}
	arg_4_0.lines = {}
	arg_4_0.maps = {}
	arg_4_0.wnds = {}
	arg_4_0.start_area = nil
end

function WorldMapTown.create(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_0:clear()
	
	arg_5_3 = arg_5_3 or {}
	arg_5_0.controller = arg_5_1
	
	local var_5_0 = WorldMapTownView(arg_5_0)
	local var_5_1, var_5_2 = var_5_0:create(arg_5_0)
	
	var_5_2:setPositionX(var_5_2:getPositionX() + VIEW_BASE_LEFT)
	
	arg_5_0.base_layer = var_5_2
	arg_5_0.layer = var_5_1
	
	arg_5_0.layer:ignoreAnchorPointForPosition(false)
	
	arg_5_0.view = var_5_0
	arg_5_0.map_layer = cc.Layer:create()
	
	arg_5_0:showTown(arg_5_2, nil, arg_5_3)
	
	return var_5_2
end

function WorldMapTown.showTown(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3 = arg_6_3 or {}
	
	if not arg_6_2 and arg_6_1 and arg_6_1 == arg_6_0.map_key then
		return 
	end
	
	if arg_6_0.layout then
		arg_6_0:clear()
		arg_6_0.view:clear()
		arg_6_0:makeTown(arg_6_1, arg_6_3)
		arg_6_0.base_layer:setVisible(true)
	else
		arg_6_0:clear()
		arg_6_0.view:clear()
		arg_6_0:makeTown(arg_6_1, arg_6_3)
	end
	
	if arg_6_0.map_key then
		Analytics:toggleTab(arg_6_0.map_key)
	end
	
	GrowthGuideNavigator:proc()
	
	if not arg_6_3.option then
		TutorialGuide:onEnterWorldMapTown(arg_6_0.map_key)
	end
	
	arg_6_0.controller:playBGM()
end

function WorldMapTown.makeTown(arg_7_0, arg_7_1, arg_7_2)
	arg_7_2 = arg_7_2 or {}
	
	arg_7_0.map_layer:removeAllChildren()
	
	local var_7_0 = {}
	local var_7_1 = arg_7_0.controller:getLinkDB()
	
	arg_7_0.map_key = arg_7_1 or arg_7_0.map_key
	
	local var_7_2 = var_7_1.chapter[arg_7_0.map_key].continent_id
	
	UIUtil:closePopups()
	
	local var_7_3, var_7_4 = DB("level_world_2_continent", var_7_2, {
		"name",
		"topbar_name"
	})
	
	if var_7_4 then
		var_7_3 = var_7_4
	end
	
	TopBarNew:setTitleName(T(var_7_3), "infoadve1")
	
	local var_7_5 = arg_7_0.controller:getSubStroyData()
	local var_7_6 = arg_7_0.controller:getType()
	local var_7_7 = var_7_5
	
	TopBarNew:setTitleName(T(var_7_3), "infoadve1", var_7_7)
	
	if var_7_5 then
		TopBarNew:checkhelpbuttonID(var_7_5.help_id or "infosubs")
	end
	
	local var_7_8, var_7_9 = DB("level_world_3_chapter", arg_7_0.map_key, {
		"image",
		"direct_connection"
	})
	
	var_7_0.image = var_7_8 .. ".png"
	
	local var_7_10, var_7_11 = arg_7_0:getChangeBGResource()
	
	arg_7_0.direct_connection = var_7_9
	
	if var_7_10 then
		var_7_0.image = var_7_10 .. ".png"
	end
	
	if var_7_11 then
		arg_7_0.bgm = var_7_11
	end
	
	arg_7_0.MAP_SCALE = 3 * TOWN_MAP_SCALE
	
	print(var_7_0.image, "layout.image")
	
	local var_7_12 = SpriteCache:getSprite("worldmap/" .. var_7_0.image)
	
	arg_7_0.map = var_7_12
	
	var_7_12:setScale(arg_7_0.MAP_SCALE)
	
	local var_7_13 = var_7_12:getContentSize()
	
	arg_7_0.view.WIDTH = var_7_13.width * arg_7_0.MAP_SCALE
	arg_7_0.view.HEIGHT = var_7_13.height * arg_7_0.MAP_SCALE
	arg_7_0.view.maxScale = tonumber(DESIGN_WIDTH) / arg_7_0.view.WIDTH
	arg_7_0.view.mapContentSize = var_7_13
	
	arg_7_0.view:init(var_7_13.width * arg_7_0.MAP_SCALE, var_7_13.height * arg_7_0.MAP_SCALE, tonumber(VIEW_WIDTH) / arg_7_0.view.WIDTH, var_7_13, 3 * TOWN_MAP_SCALE, TOWN_DEFAULT_SCALE)
	
	local var_7_14 = math.min(TOWN_DEFAULT_SCALE, arg_7_0.view:getZoomMaxScale())
	
	arg_7_0.layer:setPosition(0, 0)
	arg_7_0.layer:setAnchorPoint(0, 0)
	arg_7_0.layer:setScale(var_7_14)
	arg_7_0.layer:setContentSize(var_7_13.width * arg_7_0.MAP_SCALE, var_7_13.height * arg_7_0.MAP_SCALE)
	arg_7_0.view:calcInitScaleAccumulate(var_7_14)
	
	if not arg_7_0.layer:getChildByName("layer") then
		arg_7_0.layer:addChild(arg_7_0.map_layer)
	end
	
	var_7_12:setAnchorPoint(0, 0)
	var_7_12:setPosition(0, 0)
	arg_7_0.map_layer:setPosition(0, 0)
	arg_7_0.map_layer:setAnchorPoint(0, 0)
	arg_7_0.map_layer:setContentSize(var_7_13.width * arg_7_0.MAP_SCALE, var_7_13.height * arg_7_0.MAP_SCALE)
	arg_7_0.map_layer:addChild(var_7_12)
	arg_7_0.map_layer:setName("layer")
	
	arg_7_0.layout = var_7_0
	
	arg_7_0:createRoadData()
	arg_7_0:makeIcons_csb(arg_7_0.map_layer)
	
	local var_7_15 = arg_7_0:getLastClearTown()
	
	if not var_7_15 or arg_7_0.maps[var_7_15] == nil then
		var_7_15 = arg_7_0.start_area
		
		local var_7_16 = DB("level_enter", var_7_15, "change_enter")
		
		if var_7_16 then
			local var_7_17 = totable(var_7_16)
			local var_7_18 = arg_7_0:getChangeEnterID(var_7_17.id)
			
			if var_7_18 then
				var_7_15 = var_7_18
			end
		end
	end
	
	arg_7_0:setCurTown(var_7_15)
	
	local var_7_19 = arg_7_0:procNewTownEffect()
	
	arg_7_0:updateEventNavigator()
	arg_7_0:scrollScale(true)
	TutorialGuide:procGuide("adventure_free")
	TutorialGuide:procGuide("substory_hurdle")
	TutorialGuide:procGuide("substory_end")
end

function WorldMapTown.getBGM(arg_8_0)
	return arg_8_0.bgm or DB("level_world_3_chapter", arg_8_0.map_key, "bgm")
end

function WorldMapTown.createRoadData(arg_9_0)
	local var_9_0, var_9_1 = DB("level_world_3_chapter", arg_9_0.map_key, {
		"name",
		"start_enter"
	})
	
	arg_9_0.roadData = {}
	arg_9_0.start_area = var_9_1
	arg_9_0.runRoads = {}
	
	arg_9_0:createAreaPath(arg_9_0.start_area)
	arg_9_0:createCombinePrevNext()
end

function WorldMapTown.isDirectConnection(arg_10_0)
	return arg_10_0.direct_connection == "y"
end

function WorldMapTown.changeEnterRoad(arg_11_0, arg_11_1, arg_11_2)
	for iter_11_0, iter_11_1 in pairs(arg_11_0.roadData) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1.prev or {}) do
			if iter_11_3 == arg_11_1 then
				iter_11_1.prev[iter_11_2] = arg_11_2
			end
		end
		
		for iter_11_4, iter_11_5 in pairs(iter_11_1.next or {}) do
			if iter_11_5 == arg_11_1 then
				iter_11_1.next[iter_11_4] = arg_11_2
			end
		end
		
		for iter_11_6, iter_11_7 in pairs(iter_11_1.road or {}) do
			if iter_11_7 == arg_11_1 then
				iter_11_1.road[iter_11_6] = arg_11_2
			end
		end
	end
	
	local var_11_0 = arg_11_0.roadData[arg_11_1]
	
	arg_11_0.roadData[arg_11_2] = var_11_0
	arg_11_0.roadData[arg_11_1] = nil
end

function WorldMapTown.createAreaPath(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.roadData[arg_12_1] = {}
	arg_12_0.roadData[arg_12_1].next = {}
	arg_12_0.roadData[arg_12_1].prev = {}
	
	if arg_12_2 then
		table.insert(arg_12_0.roadData[arg_12_1].prev, arg_12_2)
	end
	
	local var_12_0, var_12_1, var_12_2, var_12_3, var_12_4 = DB("level_enter", arg_12_1, {
		"type",
		"road",
		"portal",
		"hide_line",
		"stage_group"
	})
	
	if var_12_0 == "portal" then
		arg_12_0.roadData[arg_12_1].portal = var_12_2 or "empty"
	end
	
	if var_12_3 then
		arg_12_0.roadData[arg_12_1].hide_line = true
	end
	
	arg_12_0.roadData[arg_12_1].stage_group = var_12_4
	
	if var_12_1 then
		local var_12_5 = string.split(var_12_1, ",")
		
		for iter_12_0, iter_12_1 in pairs(var_12_5) do
			local var_12_6 = string.trim(iter_12_1)
			
			table.insert(arg_12_0.roadData[arg_12_1].next, var_12_6)
		end
	end
	
	if not var_12_1 or #arg_12_0.roadData[arg_12_1].next <= 0 then
		return 
	end
	
	for iter_12_2, iter_12_3 in pairs(arg_12_0.roadData[arg_12_1].next) do
		arg_12_0:createAreaPath(iter_12_3, arg_12_1)
	end
end

function WorldMapTown.createCombinePrevNext(arg_13_0)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.roadData) do
		iter_13_1.road = {}
		
		for iter_13_2, iter_13_3 in pairs(iter_13_1.next) do
			table.insert(iter_13_1.road, iter_13_3)
		end
		
		for iter_13_4, iter_13_5 in pairs(iter_13_1.prev) do
			table.insert(iter_13_1.road, iter_13_5)
		end
	end
end

function WorldMapTown.searchRoad(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.cur_town
	local var_14_1 = {}
	
	arg_14_0.isSucessRoadPath = false
	
	local var_14_2 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.roadData[var_14_0].road) do
		local var_14_3 = {}
		local var_14_4
		
		var_14_4, arg_14_0.isSucessRoadPath = arg_14_0:searchAreaPath(var_14_0, var_14_0, iter_14_1, arg_14_1)
		
		if arg_14_0.isSucessRoadPath then
			table.insert(var_14_2, var_14_4)
		end
	end
	
	local var_14_5 = var_14_2[1] or {}
	
	for iter_14_2, iter_14_3 in pairs(var_14_2) do
		if #var_14_5 > #iter_14_3 then
			var_14_5 = iter_14_3
		end
	end
	
	return var_14_5
end

function WorldMapTown.searchAreaPath(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_5 = arg_15_5 or {}
	
	local var_15_0 = false
	
	if arg_15_2 == arg_15_3 then
		return {}, false
	elseif arg_15_3 == arg_15_4 then
		table.insert(arg_15_5, arg_15_3)
		
		return arg_15_5, true
	elseif #arg_15_0.roadData[arg_15_3].road <= 1 then
		return {}, false
	else
		table.insert(arg_15_5, arg_15_3)
		
		for iter_15_0, iter_15_1 in pairs(arg_15_0.roadData[arg_15_3].road) do
			if arg_15_1 ~= iter_15_1 then
				local var_15_1, var_15_2 = arg_15_0:searchAreaPath(arg_15_3, arg_15_2, iter_15_1, arg_15_4, {})
				
				if var_15_2 then
					for iter_15_2, iter_15_3 in pairs(var_15_1) do
						table.insert(arg_15_5, iter_15_3)
					end
					
					return arg_15_5, var_15_2
				elseif #arg_15_0.roadData[arg_15_3].road > 2 then
				else
					return {}, false
				end
			end
			
			if false then
			end
		end
	end
	
	if var_15_0 then
		return arg_15_5, true
	else
		return {}, false
	end
end

function WorldMapTown.update_townIcon_csb_forStory(arg_16_0, arg_16_1)
	if not get_cocos_refid(arg_16_0.map_layer) or not arg_16_1 then
		return 
	end
	
	local var_16_0 = arg_16_0.map_layer
	local var_16_1 = arg_16_1
	local var_16_2, var_16_3, var_16_4, var_16_5, var_16_6, var_16_7, var_16_8, var_16_9, var_16_10, var_16_11, var_16_12 = DB("level_enter", var_16_1, {
		"name",
		"x",
		"y",
		"type",
		"image",
		"desc",
		"info_id",
		"road",
		"skip_stage_save",
		"hide_map_icon",
		"change_enter"
	})
	
	if not var_16_12 or var_16_2 == nil then
		return 
	end
	
	local var_16_13, var_16_14 = arg_16_0:getLocation(var_16_1, var_16_3, var_16_4)
	local var_16_15 = totable(var_16_12)
	local var_16_16 = arg_16_0:getChangeEnterID(var_16_15.id, arg_16_1)
	
	if not var_16_16 then
		return 
	end
	
	if arg_16_0.wnds[arg_16_1] then
		arg_16_0.wnds[arg_16_1]:setVisible(false)
	end
	
	arg_16_0:changeEnterRoad(var_16_1, var_16_16)
	
	local var_16_17 = var_16_16
	local var_16_18 = 0
	
	if var_16_5 == "free" then
		if Account:isMapCleared(var_16_17) then
			var_16_18 = var_0_0.OPEN
		elseif not Account:isMapOpened(var_16_17) then
			var_16_18 = var_0_0.CLOSE
		else
			var_16_18 = var_0_0.NEW
		end
	end
	
	local var_16_19 = {
		id = var_16_17,
		name = var_16_2,
		x = var_16_13,
		y = var_16_14,
		type = var_16_5,
		clearType = var_16_18,
		image = var_16_6,
		desc = var_16_7,
		battles = {
			var_16_8
		},
		skip_stage_save = var_16_10,
		hide_map_icon = var_16_11
	}
	
	arg_16_0.maps[var_16_17] = var_16_19
	
	local var_16_20 = arg_16_0:getTownIcon_csb(var_16_17)
	local var_16_21 = var_16_20:getContentSize().height / 2
	local var_16_22 = {
		x = var_16_13,
		y = var_16_14
	}
	
	var_16_0:addChild(var_16_20)
	var_16_20:setLocalZOrder(var_0_1.WND)
	
	arg_16_0.icons[var_16_17] = var_16_20:getChildByName("spot")
	
	var_16_20:getChildByName("spot"):setName(var_16_17)
	
	arg_16_0.iconInfo[var_16_17] = var_16_20:getChildByName("center")
	arg_16_0.wnds[var_16_17] = var_16_20
	
	if DEBUG.DEBUG_MAP_ID then
		local var_16_23 = ccui.Text:create()
		
		if var_16_23 then
			var_16_23:setFontName("font/daum.ttf")
			var_16_23:setColor(cc.c3b(255, 255, 255))
			var_16_23:enableOutline(cc.c3b(0, 0, 0), 5)
			var_16_23:setFontSize(50)
			var_16_23:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			var_16_23:setAnchorPoint(0, 0.5)
			var_16_23:setString(var_16_17)
			var_16_20:addChild(var_16_23)
		end
	end
	
	local var_16_24 = SubstoryManager:getInfo()
	
	if var_16_24 then
		local var_16_25 = Account:getSubStoryFestivalInfo(var_16_24.id)
		
		if var_16_25 and not table.empty(var_16_25) then
			arg_16_0:updateFestivalTags()
		end
	end
	
	arg_16_0:setCurTown(var_16_16)
	arg_16_0:procNewTownEffect()
end

function WorldMapTown.makeIcons_csb(arg_17_0, arg_17_1)
	arg_17_0.prev_map = nil
	arg_17_0.new_map = nil
	
	for iter_17_0 = 1, 999 do
		local var_17_0 = arg_17_0.map_key .. string.format("%03d", iter_17_0)
		local var_17_1, var_17_2, var_17_3, var_17_4, var_17_5, var_17_6, var_17_7, var_17_8, var_17_9, var_17_10, var_17_11 = DB("level_enter", var_17_0, {
			"name",
			"x",
			"y",
			"type",
			"image",
			"desc",
			"info_id",
			"road",
			"skip_stage_save",
			"hide_map_icon",
			"change_enter"
		})
		local var_17_12, var_17_13 = arg_17_0:getLocation(var_17_0, var_17_2, var_17_3)
		
		if var_17_11 then
			local var_17_14 = totable(var_17_11)
			local var_17_15 = arg_17_0:getChangeEnterID(var_17_14.id, var_17_0)
			
			if var_17_15 then
				local var_17_16 = DB("level_enter", var_17_0, {
					"change_enter"
				})
				
				if var_17_16 then
					local var_17_17 = totable(var_17_16)
					
					var_17_15 = arg_17_0:getChangeEnterID(var_17_17.id, var_17_0)
				end
				
				arg_17_0:changeEnterRoad(var_17_0, var_17_15)
				
				arg_17_0.prev_map = var_17_0
				arg_17_0.new_map = var_17_15
				var_17_0 = var_17_15
			end
		end
		
		local var_17_18 = 0
		
		if var_17_4 == "free" then
			if Account:isMapCleared(var_17_0) then
				var_17_18 = var_0_0.OPEN
			elseif not Account:isMapOpened(var_17_0) then
				var_17_18 = var_0_0.CLOSE
			else
				var_17_18 = var_0_0.NEW
			end
		end
		
		if var_17_1 == nil then
			break
		end
		
		local var_17_19 = {
			id = var_17_0,
			name = var_17_1,
			x = var_17_12,
			y = var_17_13,
			type = var_17_4,
			clearType = var_17_18,
			image = var_17_5,
			desc = var_17_6,
			battles = {
				var_17_7
			},
			skip_stage_save = var_17_9,
			hide_map_icon = var_17_10
		}
		
		arg_17_0.maps[var_17_0] = var_17_19
		
		local var_17_20 = arg_17_0:getTownIcon_csb(var_17_0)
		local var_17_21 = var_17_20:getContentSize().height / 2
		local var_17_22 = {
			x = var_17_12,
			y = var_17_13
		}
		
		arg_17_0:createLine(var_17_0, var_17_8, var_17_22)
		arg_17_1:addChild(var_17_20)
		var_17_20:setLocalZOrder(var_0_1.WND)
		
		arg_17_0.icons[var_17_0] = var_17_20:getChildByName("spot")
		
		var_17_20:getChildByName("spot"):setName(var_17_0)
		
		arg_17_0.iconInfo[var_17_0] = var_17_20:getChildByName("center")
		arg_17_0.wnds[var_17_0] = var_17_20
		
		if DEBUG.DEBUG_MAP_ID then
			local var_17_23 = ccui.Text:create()
			
			if var_17_23 then
				var_17_23:setFontName("font/daum.ttf")
				var_17_23:setColor(cc.c3b(255, 255, 255))
				var_17_23:enableOutline(cc.c3b(0, 0, 0), 5)
				var_17_23:setFontSize(50)
				var_17_23:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
				var_17_23:setAnchorPoint(0, 0.5)
				var_17_23:setString(var_17_0)
				var_17_20:addChild(var_17_23)
			end
		end
	end
	
	local var_17_24 = SubstoryManager:getInfo()
	
	if var_17_24 and var_17_24.move_character then
		local var_17_25 = UNIT:create({
			code = var_17_24.move_character
		})
		
		arg_17_0.focus = arg_17_0:createFocusNode(var_17_25, arg_17_0.map_key)
	else
		local var_17_26 = Account:getMainUnit()
		
		arg_17_0.focus = arg_17_0:createFocusNode(var_17_26, arg_17_0.map_key)
	end
	
	arg_17_0.focus:setLocalZOrder(var_0_1.FOCUS)
	arg_17_0.focus:setScaleFactor(TOWN_CHARACTER_SCALE)
	arg_17_1:addChild(arg_17_0.focus)
	
	arg_17_0.controller.vars.land.unlock_action_mode = nil
	
	if var_17_24 then
		local var_17_27 = Account:getSubStoryFestivalInfo(var_17_24.id)
		
		if var_17_27 and not table.empty(var_17_27) then
			arg_17_0:updateFestivalTags()
		end
	end
	
	arg_17_0:updateGuideMarker()
end

function WorldMapTown.getLocation(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not arg_18_1 then
		return 
	end
	
	local var_18_0 = arg_18_2
	local var_18_1 = arg_18_3
	
	for iter_18_0 = 1, 3 do
		local var_18_2, var_18_3, var_18_4, var_18_5 = DB("level_change_location", arg_18_1, {
			"id",
			"condition_" .. iter_18_0,
			"x_change" .. iter_18_0,
			"y_change" .. iter_18_0
		})
		
		if not var_18_2 or not var_18_3 then
			break
		end
		
		if string.starts(var_18_3, "enter") then
			local var_18_6 = string.split(var_18_3, "=")[2]
			
			if var_18_6 and Account:isMapCleared(var_18_6) then
				var_18_0 = tonumber(var_18_4 or var_18_0)
				var_18_1 = tonumber(var_18_5 or var_18_1)
			end
		end
	end
	
	return var_18_0, var_18_1
end

function WorldMapTown.getFocusEffect(arg_19_0)
	if not arg_19_0.focus then
		return 
	end
	
	return arg_19_0.focus.eff
end

function WorldMapTown.createFocusNode(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0.controller:getMoveFlag(arg_20_2)
	local var_20_1
	
	if var_20_0 then
		var_20_1 = cc.Node:create()
		var_20_1.eff = EffectManager:Play({
			fn = var_20_0,
			layer = var_20_1
		})
	elseif arg_20_1 then
		var_20_1 = ur.ModelStage:create(CACHE:getModel(arg_20_1.db))
	end
	
	return var_20_1
end

function WorldMapTown.cheatWndSetPosition(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_3 then
		arg_21_3 = (arg_21_0.view.mapContentSize.height - arg_21_3) * arg_21_0.MAP_SCALE
	else
		arg_21_3 = arg_21_0.wnds[arg_21_1]:getPositionY()
	end
	
	if arg_21_2 then
		arg_21_2 = arg_21_2 * arg_21_0.MAP_SCALE
	else
		arg_21_2 = arg_21_0.wnds[arg_21_1]:getPositionX()
	end
	
	arg_21_0.wnds[arg_21_1]:setPosition(arg_21_2, arg_21_3)
end

function WorldMapTown.getLocalIcon(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return 
	end
	
	local var_22_0, var_22_1 = decodeLocalIcon(arg_22_1)
	
	return var_22_0, var_22_1
end

function WorldMapTown.refreshLocalIcons(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.maps
	local var_23_1 = arg_23_0.controller:getLayer()
	
	if not var_23_0 or not get_cocos_refid(var_23_1) then
		return 
	end
	
	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		if iter_23_1.check_icon then
			local var_23_2 = var_23_1:getChildByName(iter_23_0)
			local var_23_3 = DB("level_enter", iter_23_0, {
				"local_icon"
			})
			
			if not get_cocos_refid(var_23_2) or not var_23_3 then
				break
			end
			
			local var_23_4 = arg_23_0:getLocalIcon(var_23_3)
			local var_23_5 = var_23_2:getChildByName("img")
			
			SpriteCache:resetSprite(var_23_5, "map/" .. var_23_4 .. ".png")
		end
	end
end

function WorldMapTown.getTownIcon_csb(arg_24_0, arg_24_1)
	local var_24_0, var_24_1, var_24_2, var_24_3, var_24_4, var_24_5, var_24_6, var_24_7, var_24_8, var_24_9, var_24_10, var_24_11 = DB("level_enter", arg_24_1, {
		"id",
		"local_icon",
		"tag_icon",
		"name",
		"type",
		"info_id",
		"achievement_link",
		"difficulty_id",
		"hide_map_icon",
		"substory_contents_id",
		"name_tag_img",
		"name_tag_tint"
	})
	local var_24_12 = T(var_24_3)
	local var_24_13
	local var_24_14
	local var_24_15
	local var_24_16 = arg_24_0.maps[arg_24_1].x
	local var_24_17 = arg_24_0.maps[arg_24_1].y
	local var_24_18 = WorldMapIcon:create()
	
	var_24_18:setAnchorPoint(0.5, 0.5)
	var_24_18:setPosition(var_24_16 * arg_24_0.MAP_SCALE, (arg_24_0.view.mapContentSize.height - var_24_17) * arg_24_0.MAP_SCALE)
	
	local var_24_19 = var_24_18:getChildByName("img")
	local var_24_20 = 255
	
	if_set_visible(var_24_18, "score", false)
	
	local var_24_21, var_24_22, var_24_23 = Account:getEnterLimitInfo(var_24_0)
	local var_24_24 = var_24_18:getChildByName("n_limit")
	
	var_24_24:setVisible(var_24_23 and true or false)
	
	if var_24_22 and var_24_21 and var_24_23 then
		local var_24_25 = var_24_24:getChildByName("talk_small_bg")
		local var_24_26 = var_24_24:findChildByName("disc")
		local var_24_27 = var_24_24:findChildByName("t_count")
		
		if get_cocos_refid(var_24_26) and get_cocos_refid(var_24_27) and get_cocos_refid(var_24_25) then
			var_24_24:setLocalZOrder(var_0_1.MAP_ICON + 1)
			if_set(var_24_26, nil, T("level_enter_limit_desc"))
			
			local var_24_28 = string.format("%d/%d", math.min(var_24_22, math.max(var_24_21, 0)), var_24_22)
			
			if_set(var_24_27, nil, var_24_28)
			var_24_27:setPositionX(var_24_26:getContentSize().width + 7)
			
			if string.len(var_24_28) > 4 then
				var_24_25:setContentSize(var_24_25:getContentSize().width + 20, var_24_25:getContentSize().height)
			elseif string.len(var_24_28) > 3 then
				var_24_25:setContentSize(var_24_25:getContentSize().width + 10, var_24_25:getContentSize().height)
			end
		end
	end
	
	local var_24_29 = false
	local var_24_30, var_24_31 = arg_24_0:getLocalIcon(var_24_1)
	
	arg_24_0.maps[arg_24_1].check_icon = var_24_31
	
	if Account:isMapCleared(arg_24_1) or var_24_4 and var_24_4 == "village" then
		if arg_24_0:isMapIconType(var_24_4) then
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
			MissionUI:updateMissionMark(var_24_18, arg_24_1, true)
		elseif var_24_4 == "portal" then
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
			MissionUI:updateMissionMark(var_24_18, arg_24_1)
		else
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
			MissionUI:updateMissionMark(var_24_18, arg_24_1)
		end
		
		arg_24_0:showMapaAchievementGauge(var_24_18, arg_24_1, var_24_6, var_24_24)
	elseif not Account:checkEnterMap(arg_24_1) or not Account:isMapOpened(arg_24_1) then
		if_set_visible(var_24_18, "center", false)
		
		if arg_24_0:isMapIconType(var_24_4) then
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png?grayscale=1")
			var_24_19:setColor(cc.c3b(100, 100, 100))
			
			var_24_20 = 76.5
		elseif var_24_4 == "portal" then
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
		else
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
		end
		
		if var_24_8 and (not Account:checkEnterMap(arg_24_1) or var_24_4 and var_24_4 ~= "portal" and SubstoryManager:blockBeforeChapter(var_24_0)) then
			var_24_18:setVisible(false)
		end
	elseif arg_24_0:isMapIconType(var_24_4) then
		if var_24_4 == "dungeon_quest" then
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
			var_24_18:setTitle(T(var_24_3))
			MissionUI:updateMissionMark(var_24_18, arg_24_1, true)
		else
			SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
			if_set_visible(var_24_18, "center", false)
		end
		
		if_set_visible(var_24_18, "n_progress", false)
		if_set_visible(var_24_18, "progress_grow", false)
		arg_24_0:showMapaAchievementGauge(var_24_18, arg_24_1, var_24_6, var_24_24)
	elseif var_24_4 == "portal" then
		SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
		if_set_visible(var_24_18, "center", false)
	else
		SpriteCache:resetSprite(var_24_19, "map/" .. var_24_30 .. ".png")
		if_set_visible(var_24_18, "center", false)
	end
	
	if var_24_12 then
		var_24_18:setTitle(var_24_12, nil, nil, var_24_20)
	else
		if_set_visible(var_24_18, "n_label", false)
	end
	
	if var_24_10 then
		if_set_sprite(var_24_18, "label_bg", var_24_10)
	end
	
	if var_24_11 then
		local var_24_32 = totable(var_24_11)
		local var_24_33 = var_24_32.r or 255
		local var_24_34 = var_24_32.g or 255
		local var_24_35 = var_24_32.b or 255
		
		if_set_color(var_24_18, "label_bg", cc.c3b(var_24_33, var_24_34, var_24_35))
	end
	
	if var_24_7 then
		if_set_color(var_24_18, "label_bg", cc.c3b(255, 0, 0))
	end
	
	local var_24_36, var_24_37 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(arg_24_1)
	
	if var_24_36 then
		local var_24_38 = var_24_18:getChildByName("argent_m")
		local var_24_39 = DB("mission_data", var_24_36, {
			"icon2"
		})
		
		if_set_visible(var_24_18, "n_urgent", true)
		if_set_sprite(var_24_38, "simbol", "map/" .. var_24_39 .. ".png")
		
		if var_24_4 ~= "free" then
			var_24_38:setPositionX(var_24_38:getPositionX())
		end
	end
	
	arg_24_0:updateTagIcon(arg_24_1, var_24_18, var_24_2)
	
	if not Account:checkEnterMap(arg_24_1) then
		if_set_color(var_24_18, "spr_tag_icon", cc.c3b(136, 136, 136))
	end
	
	arg_24_0:updateLock(var_24_18, arg_24_1)
	
	return var_24_18
end

function WorldMapTown.updateTags(arg_25_0)
	if not arg_25_0.wnds then
		return 
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.wnds) do
		if not Account:checkEnterMap(iter_25_0) then
			if_set_color(iter_25_1, "spr_tag_icon", cc.c3b(136, 136, 136))
		else
			if_set_color(iter_25_1, "spr_tag_icon", cc.c3b(255, 255, 255))
		end
	end
end

local function var_0_2(arg_26_0, arg_26_1)
	if not arg_26_0 or not arg_26_1 then
		return 
	end
	
	local var_26_0 = string.split(arg_26_1, ";")
	
	if arg_26_0 == "map" then
		for iter_26_0, iter_26_1 in pairs(var_26_0) do
			if Account:checkEnterMap(iter_26_1) then
				return true
			end
		end
	elseif arg_26_0 == "sub_ach" then
		for iter_26_2, iter_26_3 in pairs(var_26_0) do
			if SubstoryManager:isActiveAchieve(iter_26_3) then
				return true
			end
		end
	elseif arg_26_0 == "sub_tra" then
		for iter_26_4, iter_26_5 in pairs(var_26_0) do
			local var_26_1, var_26_2 = DB("substory_travel", iter_26_5, {
				"id",
				"unlock_predecessor"
			})
			
			if not SubStoryTravel:isLocked(iter_26_5, var_26_2) then
				return true
			end
		end
	end
end

local function var_0_3(arg_27_0, arg_27_1)
	if not arg_27_0 or not arg_27_1 then
		return 
	end
	
	local var_27_0 = string.split(arg_27_1, ";")
	
	if arg_27_0 == "map" then
		for iter_27_0, iter_27_1 in pairs(var_27_0) do
			if Account:isMapCleared(iter_27_1) then
				return true
			end
		end
	elseif arg_27_0 == "sub_ach" then
		for iter_27_2, iter_27_3 in pairs(var_27_0) do
			if Account:isClearedSubStoryAchievement(iter_27_3) then
				return true
			end
		end
	elseif arg_27_0 == "sub_tra" then
		for iter_27_4, iter_27_5 in pairs(var_27_0) do
			if SubStoryTravel:isReceivedReward(iter_27_5) then
				return true
			end
		end
	end
end

function WorldMapTown.updateGuideMarker(arg_28_0)
	if not arg_28_0.wnds then
		return 
	end
	
	if not SubstoryManager:getInfo() then
		return 
	end
	
	local var_28_0 = {}
	
	arg_28_0.guide_effs = {}
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.wnds) do
		local var_28_1
		
		if get_cocos_refid(iter_28_1) then
			var_28_1 = false
			
			for iter_28_2 = 1, 5 do
				local var_28_2 = iter_28_0 .. string.format("_%02d", iter_28_2)
				local var_28_3, var_28_4, var_28_5, var_28_6, var_28_7, var_28_8, var_28_9, var_28_10, var_28_11, var_28_12, var_28_13 = DB("level_guidemarker", var_28_2, {
					"id",
					"map",
					"show_type",
					"show_condition",
					"and_show_type",
					"and_show_condition",
					"hide_type",
					"hide_condition",
					"and_hide_type",
					"and_hide_condition",
					"lock_marker"
				})
				
				if not var_28_3 or not var_28_4 then
					break
				end
				
				local var_28_14 = string.split(var_28_4, ";")
				local var_28_15 = var_28_13 and var_28_13 == "y" or false
				
				if var_28_5 then
					var_28_1 = var_0_2(var_28_5, var_28_6)
					
					if var_28_1 and var_28_7 then
						var_28_1 = var_0_2(var_28_7, var_28_8)
					end
				end
				
				local var_28_16 = false
				
				if var_28_9 then
					var_28_16 = var_0_3(var_28_9, var_28_10)
					
					if var_28_16 and var_28_11 then
						var_28_16 = not var_0_3(var_28_7, var_28_12)
					end
				end
				
				local var_28_17 = Account:checkEnterMap(iter_28_0) or var_28_15
				
				if var_28_1 and not var_28_16 and var_28_17 or DEBUG.SHOW_GUIDE_MARK then
					for iter_28_3, iter_28_4 in pairs(var_28_14) do
						if not table.find(var_28_0, iter_28_4) then
							table.insert(var_28_0, iter_28_4)
						end
					end
					
					break
				end
			end
		end
	end
	
	for iter_28_5, iter_28_6 in pairs(arg_28_0.wnds) do
		if get_cocos_refid(iter_28_6) then
			if iter_28_6.eff_guide_marker then
				iter_28_6.eff_guide_marker:removeFromParent()
				
				iter_28_6.eff_guide_marker = nil
			end
			
			local var_28_18 = arg_28_0.map_layer:getChildByName("n_guidemarker_" .. iter_28_5)
			
			if get_cocos_refid(var_28_18) then
				var_28_18:removeFromParent()
				
				iter_28_6.eff_guide_marker = nil
			end
			
			if table.find(var_28_0, iter_28_5) then
				iter_28_6.eff_guide_marker = EffectManager:Play({
					fn = "ui_customstory_guidemarker.cfx",
					layer = arg_28_0.map_layer,
					x = iter_28_6:getPositionX(),
					y = iter_28_6:getPositionY() + 28 / arg_28_0.layer:getScale(),
					scale = 1 / arg_28_0.layer:getScale()
				})
				
				iter_28_6.eff_guide_marker:setLocalZOrder(var_0_1.FOCUS - 1)
				iter_28_6.eff_guide_marker:setName("n_guidemarker_" .. iter_28_5)
				
				iter_28_6.eff_guide_marker.y = iter_28_6:getPositionY()
				
				table.insert(arg_28_0.guide_effs, iter_28_6.eff_guide_marker)
			end
		end
	end
end

function WorldMapTown.updateFestivalTags(arg_29_0)
	if not arg_29_0.wnds then
		return 
	end
	
	local var_29_0 = SubstoryManager:getInfo()
	
	if not var_29_0 then
		return 
	end
	
	local var_29_1 = Account:getSubStoryFestivalInfo(var_29_0.id)
	
	if not var_29_1 or table.empty(var_29_1) then
		return 
	end
	
	local var_29_2 = {}
	
	for iter_29_0 = 1, 3 do
		local var_29_3 = var_29_1["mission_id" .. iter_29_0]
		local var_29_4 = var_29_1["mission_state" .. iter_29_0]
		local var_29_5 = DB("substory_festival_mission", var_29_3, {
			"mission_area"
		})
		
		if var_29_3 and var_29_4 and var_29_5 then
			table.insert(var_29_2, {
				mission_id = var_29_3,
				mission_state = var_29_4,
				mission_area = var_29_5
			})
		end
	end
	
	if table.empty(var_29_2) then
		return 
	end
	
	for iter_29_1, iter_29_2 in pairs(arg_29_0.wnds) do
		local var_29_6 = false
		
		for iter_29_3, iter_29_4 in pairs(var_29_2) do
			if iter_29_4.mission_area and iter_29_4.mission_area == iter_29_1 and iter_29_4.mission_state and iter_29_4.mission_state == SUBSTORY_FESTIVAL_STATE.ACTIVE then
				var_29_6 = true
				
				break
			end
		end
		
		if get_cocos_refid(iter_29_2) then
			local var_29_7 = iter_29_2:getChildByName("n_urgent_othere")
			
			if_set_visible(iter_29_2, "n_urgent_othere", var_29_6)
			
			if var_29_6 then
				if_set_sprite(var_29_7, "simbol", "img/cm_icon_battlerequest.png")
				if_set(var_29_7, "argent_txt", T("fm_mission_icon_title"))
				UIUserData:call(var_29_7:getChildByName("argent_txt"), "SINGLE_WSCALE(60)")
			end
		end
	end
end

function WorldMapTown.updateTagIcon(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if not arg_30_0.wnds then
		return 
	end
	
	arg_30_2 = arg_30_2 or arg_30_0.wnds[arg_30_1]
	arg_30_3 = arg_30_3 or DB("level_enter", arg_30_1, {
		"tag_icon"
	})
	
	if not get_cocos_refid(arg_30_2) then
		return 
	end
	
	local var_30_0 = decodeTownTagIcon(arg_30_3)
	local var_30_1 = var_30_0 == "tag_seal" or var_30_0 == "tag_defense"
	local var_30_2 = var_30_0 and not var_30_1
	
	if var_30_2 then
		if_set_sprite(arg_30_2, "spr_tag_icon", "map/" .. var_30_0 .. ".png")
	end
	
	if var_30_1 then
		if_set_sprite(arg_30_2, "spr_tag_seal", "map/" .. var_30_0 .. "_big.png")
	end
	
	if_set_visible(arg_30_2, "spr_tag_icon", var_30_2)
	if_set_visible(arg_30_2, "spr_tag_seal", var_30_1)
end

function WorldMapTown.updateLock(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1 then
		if not arg_31_0.wnds then
			return 
		end
		
		arg_31_1 = arg_31_0.wnds[arg_31_2]
	end
	
	if not get_cocos_refid(arg_31_1) then
		return 
	end
	
	local var_31_0 = SubstoryManager:getDungeonPropertyDB(arg_31_2)
	
	if var_31_0 and var_31_0.id and var_31_0.unlock_icon then
		if_set_sprite(arg_31_1, "icon_stage_lock", "img/" .. var_31_0.unlock_icon .. ".png")
	end
	
	if_set_visible(arg_31_1, "n_stage_lock", not SubstoryManager:isUnlockDungeon(nil, arg_31_2))
end

function WorldMapTown.updateAchievementGauge(arg_32_0)
	for iter_32_0, iter_32_1 in pairs(arg_32_0.wnds) do
		local var_32_0, var_32_1 = DB("level_enter", iter_32_0, {
			"id",
			"achievement_link"
		})
		
		if var_32_1 then
			local var_32_2 = iter_32_1:getChildByName("n_limit")
			
			arg_32_0:showMapaAchievementGauge(iter_32_1, iter_32_0, var_32_1, var_32_2)
		end
	end
end

function WorldMapTown.showMapaAchievementGauge(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	if arg_33_3 and Account:checkEnterMap(arg_33_2) then
		local var_33_0 = string.split(string.trim(arg_33_3), "=")
		local var_33_1 = var_33_0[1]
		local var_33_2 = string.trim(var_33_0[2])
		local var_33_3 = string.split(var_33_2, ";")
		
		if var_33_1 == "subachieve" and SubstoryManager:getInfo() then
			for iter_33_0, iter_33_1 in pairs(var_33_3 or {}) do
				if ((Account:getSubStoryAchievement(iter_33_1) or {}).state or SUBSTORY_ACHIEVE_STATE.ACTIVE) == SUBSTORY_ACHIEVE_STATE.ACTIVE then
					local var_33_4 = DB("substory_achievement", iter_33_1, {
						"unlock_state_id"
					})
					
					if var_33_4 == nil or ConditionContentsState:isClearedByStateID(var_33_4) then
						if_set_visible(arg_33_1, "n_progress", true)
						if_set_visible(arg_33_1, "progress_grow", true)
						
						local var_33_5 = ConditionContentsManager:getSubStoryAchievement():getScore(iter_33_1)
						local var_33_6 = DB("substory_achievement", iter_33_1, "value")
						local var_33_7 = tonumber(totable(var_33_6).count) or 0
						
						if_set(arg_33_1, "txt", var_33_5 .. "/" .. var_33_7)
						if_set_percent(arg_33_1, "pogress_bar", var_33_5 / var_33_7)
						
						if get_cocos_refid(arg_33_4) then
							arg_33_4:setPositionY(arg_33_4:getPositionY() - 16)
						end
						
						break
					end
				else
					if_set_visible(arg_33_1, "n_progress", false)
					if_set_visible(arg_33_1, "progress_grow", false)
				end
			end
		end
	end
end

function WorldMapTown.refreshUrgentMissionIcon(arg_34_0, arg_34_1)
	local var_34_0, var_34_1 = DB("mission_data", arg_34_1, {
		"icon2",
		"area_enter_id"
	})
	
	if arg_34_0.wnds and get_cocos_refid(arg_34_0.wnds[var_34_1]) and get_cocos_refid(arg_34_0.wnds[var_34_1]:getChildByName("argent_m")) then
		if_set_sprite(arg_34_0.wnds[var_34_1]:getChildByName("argent_m"), "simbol", "map/" .. var_34_0 .. ".png")
	end
end

function WorldMapTown.scrollScale(arg_35_0, arg_35_1)
	if arg_35_0.view.maxScale / ICON_SIMPLIFY_START > arg_35_0.layer:getScale() then
		for iter_35_0, iter_35_1 in pairs(arg_35_0.icons) do
			if arg_35_0.maps[iter_35_0].clearType == var_0_0.OPEN then
				SpriteCache:resetSprite(iter_35_1:getChildByName("img"), "img/map_spotsm_fin.png")
				arg_35_0.iconInfo[iter_35_0]:setVisible(false)
			elseif arg_35_0.maps[iter_35_0].clearType == var_0_0.CLOSE then
				SpriteCache:resetSprite(iter_35_1:getChildByName("img"), "img/map_spotsm_yet.png")
			elseif arg_35_0.maps[iter_35_0].clearType == var_0_0.NEW then
				SpriteCache:resetSprite(iter_35_1:getChildByName("img"), "img/map_spotsm_now.png")
			end
			
			iter_35_1:setScale(arg_35_0:getTownScale())
			arg_35_0.focus:setScale(TOWN_CHARACTER_SCALE / arg_35_0.layer:getScale() + arg_35_0.view.scaleAccumulate * TOWN_VIEW_CHARACTER_SCALE)
		end
	else
		for iter_35_2, iter_35_3 in pairs(arg_35_0.icons) do
			if arg_35_0.maps[iter_35_2].clearType == var_0_0.OPEN then
				SpriteCache:resetSprite(iter_35_3:getChildByName("img"), "img/map_spot_fin.png")
				arg_35_0.iconInfo[iter_35_2]:setVisible(true)
			elseif arg_35_0.maps[iter_35_2].clearType == var_0_0.CLOSE then
				SpriteCache:resetSprite(iter_35_3:getChildByName("img"), "img/map_spot_yet.png")
			elseif arg_35_0.maps[iter_35_2].clearType == var_0_0.NEW then
				SpriteCache:resetSprite(iter_35_3:getChildByName("img"), "img/map_spot_now.png")
			end
			
			if false then
			end
			
			iter_35_3:setScale(arg_35_0:getTownScale())
			arg_35_0.focus:setScale(TOWN_CHARACTER_SCALE / arg_35_0.layer:getScale() + arg_35_0.view.scaleAccumulate * TOWN_VIEW_CHARACTER_SCALE)
		end
	end
	
	if get_cocos_refid(arg_35_0.navigator) then
		arg_35_0.navigator:setScale(arg_35_0.navigator.scale / arg_35_0.layer:getScale())
	end
	
	for iter_35_4 = 1, #arg_35_0.lines do
		local var_35_0 = arg_35_0.lines[iter_35_4]
		
		for iter_35_5, iter_35_6 in pairs(arg_35_0.lines[iter_35_4]) do
			iter_35_6[1]:setScaleX(1.2 / arg_35_0.layer:getScale())
		end
	end
	
	if arg_35_0.guide_effs and not table.empty(arg_35_0.guide_effs) then
		for iter_35_7, iter_35_8 in pairs(arg_35_0.guide_effs) do
			iter_35_8:setScale(1 / arg_35_0.layer:getScale())
			iter_35_8:setPositionY(iter_35_8.y + 28 / arg_35_0.layer:getScale())
		end
	end
end

function WorldMapTown.playEnterAction(arg_36_0, arg_36_1)
	local var_36_0 = 0
	
	if arg_36_1 ~= nil then
		local var_36_1 = arg_36_1
	end
	
	arg_36_0.controller:playCloudEffect(arg_36_0.controller.vars.worldmapUI.layer)
	set_high_fps_tick(1000)
end

function WorldMapTown.getLastClearTown(arg_37_0)
	local var_37_0 = arg_37_0.controller:getSubStroyData()
	
	if var_37_0 then
		if DB("level_enter", Account:getConfigData("last_clear_town." .. var_37_0.id), "id") == nil then
			SAVE:setTempConfigData("last_clear_town." .. var_37_0.id, arg_37_0.start_area)
		end
		
		return Account:getConfigData("last_clear_town." .. var_37_0.id)
	else
		if DB("level_enter", Account:getConfigData("last_clear_town"), "id") == nil then
			SAVE:setTempConfigData("last_clear_town", arg_37_0.start_area)
		end
		
		return Account:getConfigData("last_clear_town")
	end
end

function WorldMapTown.setVisibleUrgentMission(arg_38_0, arg_38_1)
	for iter_38_0, iter_38_1 in pairs(arg_38_0.icons) do
		local var_38_0, var_38_1 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(iter_38_0)
		
		if var_38_0 then
			arg_38_0.wnds[iter_38_0]:getChildByName("argent_m"):setVisible(arg_38_1)
		end
	end
end

function WorldMapTown.updateVisibleUrgentMission(arg_39_0)
	for iter_39_0, iter_39_1 in pairs(arg_39_0.icons) do
		local var_39_0, var_39_1 = ConditionContentsManager:getUrgentMissions():checkUrgentMissionsInDungeon(iter_39_0)
		
		if var_39_0 then
			local var_39_2 = arg_39_0.wnds[iter_39_0]:getChildByName("argent_m")
			
			if_set_visible(arg_39_0.wnds[iter_39_0], "argent_m", true)
			
			local var_39_3 = var_39_1
			
			if_set(arg_39_0.wnds[iter_39_0], "argent_time", sec_to_string(var_39_3))
		else
			if_set_visible(arg_39_0.wnds[iter_39_0], "argent_m", false)
			if_set(arg_39_0.wnds[iter_39_0], "argent_time", "")
		end
	end
end

function WorldMapTown.playOpenEffect(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if not get_cocos_refid(arg_40_0.wnds[arg_40_1]) then
		return 
	end
	
	local var_40_0 = CACHE:getEffect("ui_stage_unlock")
	local var_40_1, var_40_2 = arg_40_0.wnds[arg_40_1]:getPosition()
	
	var_40_0:setPosition(var_40_1, var_40_2 + 7)
	var_40_0:start()
	var_40_0:setLocalZOrder(9999999)
	var_40_0:setScale(arg_40_0:getTownScale())
	arg_40_0.map_layer:addChild(var_40_0)
	
	return var_40_0
end

function WorldMapTown.procNewTownEffect(arg_41_0)
	if arg_41_0.navigator and get_cocos_refid(arg_41_0.navigator) then
		arg_41_0.navigator:setVisible(false)
	end
	
	local var_41_0 = false
	local var_41_1 = SceneManager:getCurrentSceneName()
	
	if var_41_1 == "world_sub" or var_41_1 == "world_custom" then
		var_41_0 = true
	end
	
	print("EnterProcTwon!!!!")
	
	local var_41_2
	local var_41_3 = {}
	
	for iter_41_0, iter_41_1 in pairs(arg_41_0.icons) do
		if var_41_0 and SubstoryManager:blockBeforeChapter(iter_41_0) then
			return 
		end
		
		print("LoopProcTwon:   ", iter_41_0, Account:checkEnterMap(iter_41_0), not Account:isMapOpened(iter_41_0), Account:getMapClearCount(iter_41_0) <= 0, arg_41_0.maps[iter_41_0] and arg_41_0.maps[iter_41_0].skip_stage_save == nil)
		
		if Account:checkEnterMap(iter_41_0) then
			local var_41_4 = arg_41_0.maps[iter_41_0].type == "portal"
			local var_41_5 = arg_41_0.maps[iter_41_0].hide_map_icon
			
			if not Account:isMapOpened(iter_41_0) and arg_41_0.maps[iter_41_0] and Account:getMapClearCount(iter_41_0) <= 0 and arg_41_0.maps[iter_41_0].skip_stage_save == nil then
				if not var_41_4 or var_41_4 and var_41_5 then
					local var_41_6 = arg_41_0.wnds[iter_41_0]
					
					print("procTwon:   ", iter_41_0)
					
					if get_cocos_refid(var_41_6) then
						var_41_6:setVisible(true)
					end
				end
				
				if not var_41_4 then
					table.insert(var_41_3, iter_41_0)
					
					local var_41_7 = iter_41_1:getContentSize()
					local var_41_8 = iter_41_1:getLocalZOrder()
					local var_41_9, var_41_10 = arg_41_0.wnds[iter_41_0]:getPosition()
					local var_41_11 = arg_41_0.maps[iter_41_0].x
					local var_41_12 = arg_41_0.maps[iter_41_0].y
					
					arg_41_0.view:look(var_41_11, var_41_12)
					Action:Add(SEQ(DELAY(800), CALL(arg_41_0.playOpenEffect, arg_41_0, iter_41_0, var_41_9, var_41_10), CALL(arg_41_0.openTown, arg_41_0, iter_41_0, var_41_8)), arg_41_0, "block")
					Account:openMap(iter_41_0)
					
					var_41_2 = iter_41_0
				end
			end
		end
	end
	
	if #var_41_3 > 0 then
		Action:Add(SEQ(DELAY(800), CALL(function()
			SoundEngine:play("event:/effect/ui_stage_unlock")
		end)), arg_41_0, "open")
	end
	
	if #var_41_3 >= 2 then
		for iter_41_2, iter_41_3 in pairs(var_41_3) do
			if DB("level_enter", iter_41_3, "type") == "portal" then
			else
				var_41_2 = iter_41_3
			end
		end
	end
	
	if #var_41_3 > 0 then
		Action:Add(SEQ(DELAY(2000), CALL(function()
			for iter_43_0, iter_43_1 in pairs(var_41_3) do
				local var_43_0 = arg_41_0.wnds[iter_43_1]
				
				if get_cocos_refid(var_43_0) and not var_43_0:isVisible() then
					var_43_0:setVisible(true)
				end
			end
			
			arg_41_0:focusRun(var_41_2, true)
		end)), arg_41_0)
	end
	
	return var_41_2, var_41_3
end

function WorldMapTown.openTown(arg_44_0, arg_44_1, arg_44_2)
	if not get_cocos_refid(arg_44_0.map_layer) then
		return 
	end
	
	SoundEngine:play("event:/ui/open_stage")
	
	local var_44_0 = arg_44_0.map_layer:getChildByName(arg_44_1)
	
	if not var_44_0 or not get_cocos_refid(var_44_0) then
		return 
	end
	
	var_44_0:getParent():removeChild(var_44_0)
	
	local var_44_1 = arg_44_0:getTownIcon_csb(arg_44_1)
	local var_44_2 = var_44_1:getChildByName("img")
	
	var_44_1:setLocalZOrder(arg_44_2)
	
	if arg_44_0.maps[arg_44_1].type == "free" then
		arg_44_0.maps[arg_44_1].clearType = var_0_0.NEW
	end
	
	arg_44_0.map_layer:addChild(var_44_1)
	
	local var_44_3 = var_44_1:getChildByName("spot")
	
	arg_44_0.icons[arg_44_1] = var_44_3
	
	var_44_3:setName(arg_44_1)
	
	arg_44_0.wnds[arg_44_1] = var_44_1
	
	arg_44_0:scrollScale()
	
	local function var_44_4(arg_45_0)
		if not arg_45_0.wnds then
			return 
		end
		
		if not arg_45_0.navigator then
			return 
		end
		
		if not arg_45_0.navigator.target then
			return 
		end
		
		local var_45_0 = arg_45_0.wnds[arg_45_0.navigator.target]
		
		if var_45_0 and var_45_0:isVisible() == true then
			arg_45_0.navigator:setVisible(true)
			arg_45_0:scrollScale()
		end
	end
	
	Action:Add(SEQ(DELAY(0), CALL(var_44_4, arg_44_0)), var_44_3, "open")
end

function WorldMapTown.updateLastClearMark(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_1 or arg_46_0:getLastClearTown()
	
	if arg_46_0.maps[var_46_0] == nil then
		var_46_0 = arg_46_0.start_area
		
		if not Account:checkEnterMap(var_46_0) then
			arg_46_0.focus:setVisible(false)
		end
	end
	
	if var_46_0 then
		local var_46_1 = arg_46_0.maps[var_46_0].x
		local var_46_2 = arg_46_0.maps[var_46_0].y
		local var_46_3 = var_46_1 * arg_46_0.MAP_SCALE
		local var_46_4 = (arg_46_0.view.mapContentSize.height - var_46_2) * arg_46_0.MAP_SCALE
		
		if arg_46_0:getFocusEffect() and arg_46_0.wnds and get_cocos_refid(arg_46_0.wnds[var_46_0]) then
			local var_46_5 = arg_46_0.wnds[var_46_0]:getChildByName("n_sub_position")
			local var_46_6 = 40
			local var_46_7 = 40
			
			if get_cocos_refid(var_46_5) then
				arg_46_0.focus:setPosition(var_46_3 - var_46_6 * arg_46_0.MAP_SCALE + var_46_5:getPositionX() * arg_46_0.MAP_SCALE, var_46_4 - var_46_7 * arg_46_0.MAP_SCALE + var_46_5:getPositionY() * arg_46_0.MAP_SCALE)
			end
		else
			arg_46_0.focus:setPosition(var_46_3, var_46_4 - 15)
		end
	else
		arg_46_0.view:look(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
	end
end

function WorldMapTown.setCurTown(arg_47_0, arg_47_1)
	if arg_47_0:getLastClearTown() and arg_47_0.maps[arg_47_0:getLastClearTown()] then
		arg_47_1 = arg_47_1 or arg_47_0:getLastClearTown()
	elseif arg_47_0.start_area then
		arg_47_1 = arg_47_1 or arg_47_0.start_area
	end
	
	print("CUR", arg_47_1)
	
	if arg_47_0.maps[arg_47_1] == nil then
		for iter_47_0, iter_47_1 in pairs(arg_47_0.maps) do
			arg_47_1 = iter_47_0
		end
	end
	
	if arg_47_0.maps[arg_47_1] then
		local var_47_0 = arg_47_0.maps[arg_47_1].x
		local var_47_1 = arg_47_0.maps[arg_47_1].y
		
		arg_47_0.view:look(var_47_0, var_47_1)
	end
	
	arg_47_0:updateLastClearMark(arg_47_1)
	
	arg_47_0.cur_town = arg_47_1
	
	arg_47_0:updateEventNavigator()
	NewChapterNavigator:check(arg_47_0.map_key)
end

function WorldMapTown.lookEnter(arg_48_0, arg_48_1)
	if arg_48_0.maps[arg_48_1] == nil then
		for iter_48_0, iter_48_1 in pairs(arg_48_0.maps) do
			arg_48_1 = iter_48_0
		end
	end
	
	if arg_48_0.maps[arg_48_1] then
		local var_48_0 = arg_48_0.maps[arg_48_1].x
		local var_48_1 = arg_48_0.maps[arg_48_1].y
		
		arg_48_0.view:look(var_48_0, var_48_1)
	end
end

function WorldMapTown.setCurPosCamera(arg_49_0)
	local var_49_0, var_49_1 = arg_49_0.focus:getPosition()
	
	arg_49_0.view:look(var_49_0 / arg_49_0.MAP_SCALE, arg_49_0.view.mapContentSize.height - var_49_1 / arg_49_0.MAP_SCALE)
end

function WorldMapTown.getCurTown(arg_50_0)
	return arg_50_0.cur_town or arg_50_0:getLastClearTown()
end

function WorldMapTown.onPlayAgainButton(arg_51_0, arg_51_1)
	if arg_51_1 and arg_51_1 ~= 2 then
		return 
	end
	
	local var_51_0 = self:getLastClearTown()
	
	self:showMapDialog(self.maps[var_51_0])
end

function WorldMapTown.getChangeBGResource(arg_52_0)
	local var_52_0 = 9
	local var_52_1 = {}
	
	table.insert(var_52_1, "id")
	
	for iter_52_0 = 1, var_52_0 do
		table.insert(var_52_1, "condition_" .. iter_52_0)
		table.insert(var_52_1, "image_" .. iter_52_0)
		table.insert(var_52_1, "bgm_" .. iter_52_0)
	end
	
	local var_52_2 = DBT("level_change_chapter", arg_52_0.map_key, var_52_1) or {}
	
	if not var_52_2.id then
		return nil
	end
	
	local var_52_3
	local var_52_4
	
	local function var_52_5(arg_53_0)
		for iter_53_0, iter_53_1 in pairs(arg_53_0) do
			if iter_53_0 == "schedule" then
				if not SubstoryManager:isActiveSchedule(iter_53_1) then
					return false
				end
			elseif iter_53_0 == "enter" then
				if not Account:isMapCleared(iter_53_1) then
					return false
				end
			else
				Log.e("level_change_chapter.invalid_condition", arg_52_0.map_key)
				
				return nil
			end
		end
		
		return true
	end
	
	for iter_52_1 = 1, var_52_0 do
		local var_52_6 = var_52_2["condition_" .. iter_52_1]
		
		if not var_52_6 then
			break
		end
		
		local var_52_7 = totable(var_52_6)
		
		if var_52_5(var_52_7) then
			var_52_3 = var_52_2["image_" .. iter_52_1]
			var_52_4 = var_52_2["bgm_" .. iter_52_1]
		end
	end
	
	return var_52_3, var_52_4
end

function WorldMapTown.onPushTown(arg_54_0, arg_54_1, arg_54_2)
	if Action:Find("shortcut") then
		return 
	end
	
	if arg_54_2 ~= 2 then
		return 
	end
	
	local var_54_0 = arg_54_1:getName()
	local var_54_1 = var_54_0
	local var_54_2 = DB("level_enter", var_54_0, {
		"type"
	})
	local var_54_3 = {}
	
	ConditionContentsNotifier:resetPendingNotifications()
	
	if not Account:checkEnterMap(var_54_1, var_54_3) and not DEBUG.MAP_DEBUG then
		local var_54_4 = UIUtil:setMsgCheckEnterMapErr(var_54_1, var_54_3)
		local var_54_5 = table.empty(SubstoryManager:getDungeonPropertyDB(var_54_1))
		
		if var_54_2 == "portal" then
			balloon_message_with_sound_raw_text(var_54_4)
			
			return 
		elseif var_54_2 == "story" or var_54_2 == "volleyball" or var_54_2 == "cook" or var_54_2 == "village" or var_54_2 == "arcade" or var_54_2 == "repair" or var_54_2 == "exorcist" then
			balloon_message_with_sound_raw_text(var_54_4 or "ui_story_ready_progress_error")
			
			return 
		elseif (var_54_2 == "quest" or var_54_2 == "extra_quest") and not var_54_5 then
			balloon_message_with_sound_raw_text(var_54_4 or "ui_story_ready_progress_error")
			
			return 
		end
		
		BattleReady:show({
			enter_id = var_54_0,
			callback = arg_54_0,
			enter_error_text = var_54_4
		})
	elseif not BattleReady:isShow() then
		arg_54_0:focusRun(var_54_0)
		SoundEngine:play("event:/ui/ok")
	end
	
	local var_54_6 = {
		"substory_NPC",
		"substory_hurdle",
		"vsu2aa_token"
	}
	
	if var_54_2 == "village" then
		table.insert(var_54_6, "substory_vch1ba_3rd")
		table.insert(var_54_6, "substory_vch1ba_1st")
	end
	
	TutorialGuide:procGuide(nil, var_54_6)
end

function WorldMapTown.clearRunRoad(arg_55_0)
	arg_55_0.runRoads = {}
	
	UIAction:Remove("CHAR_MOVE")
	
	if not arg_55_0:getFocusEffect() then
		arg_55_0.focus:setAnimation(0, "idle", true)
	end
end

function WorldMapTown.focusRun(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	if not arg_56_1 then
		return 
	end
	
	if not get_cocos_refid(arg_56_0.focus) then
		return 
	end
	
	if arg_56_0.roadData[arg_56_1] == nil then
		balloon_message_with_sound("crossroad_stop")
		
		return 
	end
	
	if arg_56_0.roadData[arg_56_1] and not arg_56_0.roadData[arg_56_1].portal then
		arg_56_0.target_town = arg_56_1
	end
	
	if arg_56_0.roadData[arg_56_1] and arg_56_0.roadData[arg_56_1].portal then
		local var_56_0 = parseEpic7Link(arg_56_0.roadData[arg_56_1].portal).params
		
		if var_56_0 and var_56_0.continent then
			if not DB("level_world_3_chapter", var_56_0.continent, "id") then
				balloon_message_with_sound("notyet_dev")
				
				return 
			end
		else
			balloon_message_with_sound("notyet_dev")
			
			return 
		end
	end
	
	if arg_56_0:getFocusEffect() then
		arg_56_0:updateLastClearMark(arg_56_1)
		
		if not arg_56_2 then
			arg_56_0:onDialog(arg_56_1)
		end
		
		return 
	end
	
	if arg_56_0:isDirectConnection() then
		local var_56_1 = arg_56_0.focusTown
		
		if arg_56_0.runRoads and #arg_56_0.runRoads > 0 and arg_56_0.runRoads[#arg_56_0.runRoads] == arg_56_1 then
			if not arg_56_2 then
				arg_56_0:jumpRoad(arg_56_1)
			end
			
			return 
		elseif arg_56_0.cur_town == arg_56_1 then
			if not arg_56_2 then
				arg_56_0:jumpRoad(arg_56_1)
			end
			
			return 
		end
		
		arg_56_0.runRoads = {}
		
		UIAction:Remove("CHAR_MOVE")
		table.insert(arg_56_0.runRoads, arg_56_1)
	else
		if arg_56_0.runRoads and #arg_56_0.runRoads > 0 then
			if arg_56_0.runRoads[#arg_56_0.runRoads] == arg_56_1 and not arg_56_2 then
				arg_56_0:jumpRoad(arg_56_1)
				
				return 
			end
			
			arg_56_0.runRoads = arg_56_0:searchRoad(arg_56_1)
			
			return 
		end
		
		arg_56_0.runRoads = arg_56_0:searchRoad(arg_56_1)
		
		if arg_56_0.roadData[arg_56_0.runRoads[1]] and arg_56_0.roadData[arg_56_0.cur_town].portal and arg_56_0.roadData[arg_56_0.runRoads[1]].stage_group ~= arg_56_0.roadData[arg_56_0.cur_town].stage_group and arg_56_3 ~= true then
			arg_56_0.controller:movetoPath(arg_56_0.roadData[arg_56_0.cur_town].portal, {
				no_movepath = true,
				portal = true,
				target_area = arg_56_1
			})
			
			return 
		end
	end
	
	if #arg_56_0.runRoads > 0 then
		if not arg_56_0:getFocusEffect() then
			arg_56_0.focus:setAnimation(0, "run", true)
			
			arg_56_0.focus:getCurrent().timeScale = CHARACTER_ANI_TIMESCALE
		end
		
		arg_56_0.controller:startSoundCharacterWalk()
		arg_56_0:focusRunAction(arg_56_2)
	elseif not arg_56_2 then
		arg_56_0:onDialog(arg_56_1)
	end
end

function WorldMapTown.jumpRoad(arg_57_0, arg_57_1)
	if arg_57_0.roadData[arg_57_1].portal and arg_57_0.roadData[arg_57_1].portal ~= "empty" then
		if arg_57_0.controller:movetoPath(arg_57_0.roadData[arg_57_1].portal, {
			portal = true
		}) then
			UIAction:Remove("CHAR_MOVE")
		end
	else
		UIAction:Remove("CHAR_MOVE")
		arg_57_0:setCurTown(arg_57_1)
		arg_57_0:showMapDialog(arg_57_0.maps[arg_57_1])
	end
end

function WorldMapTown.updateFocusDir(arg_58_0, arg_58_1)
	if not arg_58_0.runRoads or not arg_58_0.focus or not arg_58_0.maps or not arg_58_0.view then
		return 
	end
	
	arg_58_1 = arg_58_1 or arg_58_0.runRoads[1]
	
	if not arg_58_1 or not arg_58_0.maps[arg_58_1] then
		return 
	end
	
	if arg_58_0:getFocusEffect() then
		return 
	end
	
	local var_58_0 = (arg_58_0.focus:getPositionX() - tonumber(arg_58_0.maps[arg_58_1].x * 3)) * -1
	local var_58_1 = (arg_58_0.focus:getPositionY() - (arg_58_0.view.HEIGHT - tonumber(arg_58_0.maps[arg_58_1].y) * arg_58_0.MAP_SCALE)) * -1
	local var_58_2 = math.sqrt(math.pow(var_58_0, 2) + math.pow(var_58_1, 2))
	local var_58_3 = 1
	
	if arg_58_0.focus:getPositionX() > tonumber(arg_58_0.maps[arg_58_1].x * arg_58_0.MAP_SCALE) then
		var_58_3 = -1
	end
	
	arg_58_0.focus:setScaleX(math.abs(arg_58_0.focus:getScaleX()) * var_58_3)
	
	return var_58_0, var_58_1, var_58_2
end

function WorldMapTown.focusRunAction(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = arg_59_0.runRoads[1]
	
	if not BattleReady:isShow() and not arg_59_2 then
		arg_59_0.cur_town = var_59_0
	end
	
	local var_59_1, var_59_2, var_59_3 = arg_59_0:updateFocusDir()
	local var_59_4 = MOVE_BY(var_59_3 * CHARACTER_SPEED, var_59_1, var_59_2)
	
	if not arg_59_2 then
		set_high_fps_tick()
		UIAction:Add(SEQ(MOVE_BY(var_59_3 * CHARACTER_SPEED, var_59_1, var_59_2), CALL(arg_59_0.onDialog, arg_59_0, var_59_0, arg_59_1)), arg_59_0.focus, "CHAR_MOVE")
	end
end

function WorldMapTown.onDialog(arg_60_0, arg_60_1, arg_60_2)
	if TransitionScreen:isShow() then
		arg_60_0:clearRunRoad()
		
		return 
	end
	
	if arg_60_1 == arg_60_0.runRoads[1] then
		table.remove(arg_60_0.runRoads, 1)
	end
	
	if arg_60_0.roadData[arg_60_1] == nil then
		balloon_message_with_sound("crossroad_stop")
		
		return 
	end
	
	if arg_60_0.roadData[arg_60_1].portal then
		local var_60_0 = arg_60_0.runRoads[math.max(1, #arg_60_0.runRoads)]
		
		if arg_60_1 == var_60_0 then
			var_60_0 = nil
		end
		
		arg_60_0.controller:movetoPath(arg_60_0.roadData[arg_60_1].portal, {
			portal = true,
			target_area = var_60_0
		})
		
		return 
	end
	
	if #arg_60_0.runRoads <= 0 then
		if arg_60_0.roadData[arg_60_1] and arg_60_0.roadData[arg_60_1].portal and arg_60_0.roadData[arg_60_1].portal ~= "empty" then
			if not arg_60_2 then
				arg_60_0.controller:movetoPath(arg_60_0.roadData[arg_60_1].portal, {
					portal = true
				})
			end
			
			arg_60_0.controller:stopSoundCharacterWalk()
		elseif not BattleReady:isShow() and not arg_60_2 then
			arg_60_0:setCurTown(arg_60_1)
			arg_60_0:showMapDialog(arg_60_0.maps[arg_60_1])
			arg_60_0.controller:stopSoundCharacterWalk()
		end
		
		if not arg_60_0:getFocusEffect() then
			arg_60_0.focus:setAnimation(0, "idle", true)
		end
	else
		arg_60_0:focusRunAction(arg_60_2)
	end
end

function WorldMapTown.createLine(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = string.split(arg_61_2, ",")
	local var_61_1 = {}
	local var_61_2
	local var_61_3
	
	for iter_61_0, iter_61_1 in pairs(var_61_0) do
		local var_61_4 = string.trim(iter_61_1)
		
		if var_61_4 then
			local var_61_5, var_61_6
			
			var_61_1.x, var_61_1.y, var_61_5, var_61_6 = DB("level_enter", var_61_4, {
				"x",
				"y",
				"hide_line",
				"hide_map_icon"
			})
			var_61_1.x, var_61_1.y = arg_61_0:getLocation(var_61_4, var_61_1.x, var_61_1.y)
			
			if not var_61_1.x then
				var_61_1.x = tonumber(var_61_1.x)
			end
			
			if not var_61_1.x then
				var_61_1.y = tonumber(var_61_1.y)
			end
			
			local var_61_7 = ""
			local var_61_8 = cc.Node:create()
			
			if var_61_5 then
				var_61_8:setVisible(false)
			end
			
			if Account:checkEnterMap(arg_61_1) and Account:checkEnterMap(var_61_4) then
				var_61_7 = "img/map_cm_select_lineon.png"
				
				if not var_61_5 and var_61_6 then
					var_61_8:setVisible(true)
				end
				
				if SubstoryManager:blockBeforeChapter(arg_61_1) and Account:isMapCleared(arg_61_1) and not Account:isMapCleared(var_61_4) then
					var_61_8:setVisible(false)
				end
			else
				var_61_7 = "img/map_cm_select_lineof.png"
				
				if not var_61_5 and var_61_6 then
					var_61_8:setVisible(false)
				end
			end
			
			if var_61_1.x then
				local var_61_9 = cc.pSub(arg_61_3, var_61_1)
				
				var_61_8:setPosition(var_61_1.x * arg_61_0.MAP_SCALE, arg_61_0.view.HEIGHT - var_61_1.y * arg_61_0.MAP_SCALE)
				
				local var_61_10 = cc.pGetAngle(arg_61_3, var_61_1) * 180 / math.pi - 90
				local var_61_11 = var_61_8:getContentSize()
				
				var_61_8:setAnchorPoint(0.5, 0.5)
				
				local var_61_12 = math.sqrt(math.pow(arg_61_3.x - var_61_1.x, 2) + math.pow(arg_61_3.y - var_61_1.y, 2))
				local var_61_13 = arg_61_0:getDegreesFromTo(var_61_1, arg_61_3)
				
				var_61_8:setRotation(var_61_13)
				arg_61_0.map_layer:addChild(var_61_8)
				addLine(var_61_8, var_61_7, var_61_12 * arg_61_0.MAP_SCALE)
				arg_61_0.map_layer:setLocalZOrder(var_0_1.MAP)
				
				local var_61_14 = {
					[var_61_4] = {
						var_61_8,
						var_61_13,
						var_61_12,
						arg_61_1
					}
				}
				
				table.insert(arg_61_0.lines, var_61_14)
			end
		end
	end
end

function WorldMapTown.updateEnterLine(arg_62_0, arg_62_1)
	local var_62_0 = DB("level_enter", arg_62_1, "road")
	local var_62_1 = string.split(var_62_0, ",")
	
	for iter_62_0, iter_62_1 in pairs(var_62_1) do
		if not DB("level_enter", iter_62_1, {
			"hide_line"
		}) then
			arg_62_0:updateMapLine(iter_62_1)
		end
	end
end

function WorldMapTown.updateMapLine(arg_63_0, arg_63_1)
	if not arg_63_1 then
		return 
	end
	
	for iter_63_0, iter_63_1 in pairs(arg_63_0.lines) do
		if arg_63_0.lines[iter_63_0][arg_63_1] then
			local var_63_0 = arg_63_0.lines[iter_63_0][arg_63_1][1]
			local var_63_1 = arg_63_0.lines[iter_63_0][arg_63_1][3]
			local var_63_2 = arg_63_0.lines[iter_63_0][arg_63_1][4]
			
			var_63_0:removeAllChildren()
			
			local var_63_3 = "img/map_cm_select_lineof.png"
			
			if Account:checkEnterMap(var_63_2) and Account:checkEnterMap(arg_63_1) then
				var_63_3 = "img/map_cm_select_lineon.png"
				
				if get_cocos_refid(var_63_0) then
					var_63_0:setVisible(true)
				end
			end
			
			addLine(var_63_0, var_63_3, var_63_1 * arg_63_0.MAP_SCALE)
		end
	end
end

function WorldMapTown.getDegreesFromTo(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = 0
	local var_64_1 = math.atan2(arg_64_1.y - arg_64_2.y, arg_64_1.x - arg_64_2.x) * 180 / math.pi - 90
	
	if arg_64_1.x == arg_64_2.x and var_64_1 > 0 then
		var_64_1 = 0
	elseif arg_64_1.y == arg_64_2.y and var_64_1 > 0 then
		var_64_1 = 90
	end
	
	return var_64_1
end

function WorldMapTown.getTownScale(arg_65_0)
	return (MODEL_SCALE_FACTOR - 0.5) * TOWN_MARK_SCALE / arg_65_0.layer:getScale()
end

function WorldMapTown.revertTownScale(arg_66_0, arg_66_1)
	if get_cocos_refid(arg_66_1) then
		local var_66_0 = arg_66_0:getTownScale()
		
		Action:Add(SEQ(SCALE(0, var_66_0 * 1.4, var_66_0)), arg_66_1, "revert_town")
	end
end

function WorldMapTown.resetSelectTown(arg_67_0)
	if get_cocos_refid(arg_67_0.select_town) then
		Action:Remove("select_town")
		arg_67_0:revertTownScale(arg_67_0.select_town)
	end
	
	arg_67_0.select_town = nil
end

function WorldMapTown.onTouchDown(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	arg_68_0.view:onTouchDown(arg_68_1, arg_68_2, arg_68_3)
	
	arg_68_0.move_cnt = 0
	arg_68_0.move_pos = {}
	arg_68_0.move_pos.x, arg_68_0.move_pos.y = arg_68_1, arg_68_2
	arg_68_0.isZoom = false
	arg_68_0.isDialog = false
	
	arg_68_0:resetSelectTown()
	
	for iter_68_0, iter_68_1 in pairs(arg_68_0.icons) do
		local var_68_0, var_68_1 = iter_68_1:getPosition()
		local var_68_2 = arg_68_0.wnds[iter_68_0]
		
		if var_68_2 and var_68_2:isVisible() and checkCollision(iter_68_1:getChildByName("img"), arg_68_1, arg_68_2, {
			add_width = 10,
			add_height = 10
		}) then
			arg_68_0.select_town = iter_68_1
			
			local var_68_3 = arg_68_0:getTownScale()
			
			Action:Add(SEQ(SCALE(100, var_68_3, var_68_3 * 1.4)), iter_68_1, "select_town")
			
			break
		end
	end
	
	return true
end

function WorldMapTown.onTouchUp(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	arg_69_0.isZoom = false
	
	if get_cocos_refid(arg_69_0.select_town) then
		if arg_69_0.isDialog == true then
		else
			arg_69_0:onPushTown(arg_69_0.select_town, 2)
		end
		
		arg_69_0:resetSelectTown()
	end
	
	arg_69_0.view:onTouchUp(arg_69_1, arg_69_2, arg_69_3)
	
	arg_69_0.isDialog = false
	arg_69_0.isZoom = false
	
	arg_69_3:stopPropagation()
	
	return true
end

function WorldMapTown.onTouchMove(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	if arg_70_0.isZoom == true then
		return 
	end
	
	if not arg_70_0.move_pos then
		arg_70_0.move_pos = {
			x = arg_70_1,
			y = arg_70_2
		}
	end
	
	local var_70_0 = arg_70_0.move_pos
	local var_70_1 = {
		x = arg_70_1,
		y = arg_70_2
	}
	
	if math.sqrt(math.pow(var_70_0.x - var_70_1.x, 2) + math.pow(var_70_0.y - var_70_1.y, 2)) > math.sqrt(math.pow(0 - VIEW_WIDTH, 2) + math.pow(0 - VIEW_HEIGHT, 2)) * TOUCH_SENSITIVITY_DUNGEON_ENTER or arg_70_0.select_town == nil then
		arg_70_0.view:onTouchMove(arg_70_1, arg_70_2, arg_70_3)
		arg_70_3:stopPropagation()
		arg_70_0:updateEventNavigator()
		arg_70_0:resetSelectTown()
		
		arg_70_0.isDialog = true
	else
		arg_70_0.view:onTouchDown(arg_70_1, arg_70_2, arg_70_3)
	end
	
	return true
end

function WorldMapTown.onGestureZoom(arg_71_0, arg_71_1, arg_71_2)
	arg_71_0:resetSelectTown()
	
	arg_71_0.isZoom = true
	arg_71_0.move_cnt = 11
	
	arg_71_0.view:onGestureZoom(arg_71_1, arg_71_2)
end

function WorldMapTown.update(arg_72_0)
	arg_72_0.view:updateMoveAction()
end

function WorldMapTown.makeEventNavigator(arg_73_0)
	arg_73_0.navigator = UIUtil:makeNavigatorAni()
	
	arg_73_0.map_layer:addChild(arg_73_0.navigator)
	arg_73_0.navigator:setVisible(false)
	arg_73_0.navigator:setLocalZOrder(var_0_1.NAVIGATOR)
	
	if AccountData.quests.quest_m_id then
		arg_73_0.navigator.target = DB("mission_data", AccountData.quests.quest_m_id, "area_enter_id")
	end
	
	arg_73_0.navigator.scale = 0.55
end

function WorldMapTown.updateNavigatorTarget(arg_74_0)
	if AccountData.quests.quest_m_id then
		arg_74_0.navigator.target = DB("mission_data", AccountData.quests.quest_m_id, "area_enter_id")
	end
end

function WorldMapTown.isShowNavigator(arg_75_0)
	if not ConditionContentsManager:getQuestMissions():hasNextQuest() then
		return false
	end
	
	return true
end

function WorldMapTown.updateEventNavigator(arg_76_0)
	if not get_cocos_refid(arg_76_0.navigator) then
		arg_76_0.navigator = nil
	end
	
	if not arg_76_0:isShowNavigator() then
		return 
	end
	
	if not arg_76_0.navigator then
		arg_76_0:makeEventNavigator()
	end
	
	if not arg_76_0.wnds then
		return 
	end
	
	if not arg_76_0.navigator.target then
		return 
	end
	
	for iter_76_0, iter_76_1 in pairs(arg_76_0.wnds) do
		if arg_76_0.navigator.target and iter_76_0 == arg_76_0.navigator.target and get_cocos_refid(iter_76_1) then
			if not iter_76_1:isVisible() then
				arg_76_0.navigator:setVisible(false)
				
				break
			end
			
			if not Action:Find("open") then
				arg_76_0.navigator:setVisible(true)
			end
			
			local var_76_0 = arg_76_0.navigator:getChildByName("arrow"):getContentSize()
			local var_76_1 = iter_76_1:getContentSize()
			local var_76_2 = iter_76_1:getPositionX()
			local var_76_3 = iter_76_1:getPositionY() + var_76_1.height / 2
			local var_76_4 = arg_76_0.layer:getScale()
			local var_76_5 = arg_76_0.layer:getPositionX()
			local var_76_6 = arg_76_0.layer:getPositionY()
			local var_76_7 = arg_76_0.layer:getAnchorPoint().x * arg_76_0.view.WIDTH * arg_76_0.layer:getScale()
			local var_76_8 = arg_76_0.layer:getAnchorPoint().y * arg_76_0.view.HEIGHT * arg_76_0.layer:getScale()
			local var_76_9 = (var_76_5 * -1 + VIEW_WIDTH / 2 + var_76_7) / arg_76_0.layer:getScale()
			local var_76_10 = (var_76_6 * -1 + VIEW_HEIGHT / 2 + var_76_8) / arg_76_0.layer:getScale()
			local var_76_11 = var_76_2
			local var_76_12 = var_76_3
			local var_76_13 = var_76_10 + VIEW_HEIGHT * 0.5 / var_76_4 - VIEW_HEIGHT * 0.09 / var_76_4 - var_76_1.height / 2
			local var_76_14 = var_76_10 - VIEW_HEIGHT * 0.5 / var_76_4
			local var_76_15 = var_76_9 - VIEW_WIDTH * 0.5 / var_76_4
			local var_76_16 = var_76_9 + VIEW_WIDTH * 0.5 / var_76_4
			local var_76_17 = math.max(var_76_11, var_76_15)
			local var_76_18 = math.min(var_76_17, var_76_16)
			local var_76_19 = math.min(var_76_12, var_76_13)
			local var_76_20 = math.max(var_76_19, var_76_14)
			
			arg_76_0.navigator:setPosition(var_76_18, var_76_20)
			
			if var_76_18 == var_76_2 and var_76_20 == var_76_3 then
				local var_76_21 = arg_76_0.navigator:getChildByName("arrow"):getRotation()
				
				if arg_76_0.navigator.revert_dirty then
					if var_76_21 < -180 then
						var_76_21 = 360 + var_76_21
					end
					
					Action:Add(SEQ(ROTATE(200, var_76_21, 0)), arg_76_0.navigator:getChildByName("arrow"), "revert")
					Action:Add(SEQ(MOTION("idle_stage", true)), arg_76_0.navigator:getChildByName("ani"), "revert")
					
					local var_76_22 = math.abs(var_76_21)
					local var_76_23 = var_76_21 / var_76_22
					
					Action:Add(SEQ(ROTATE(200, var_76_21, var_76_22 * 0.2 * var_76_23), ROTATE(400, var_76_22 * 0.2 * var_76_23, -(var_76_22 * 0.05) * var_76_23), ROTATE(600, -(var_76_22 * 0.05) * var_76_23, 0)), arg_76_0.navigator:getChildByName("back"), "revert")
					
					arg_76_0.navigator.revert_dirty = false
				end
				
				break
			end
			
			Action:Remove("revert")
			
			local var_76_24 = math.atan2(var_76_10 - var_76_20, var_76_18 - var_76_9) * 180 / math.pi - 90
			
			arg_76_0.navigator:getChildByName("arrow"):setRotation(var_76_24)
			arg_76_0.navigator:getChildByName("back"):setRotation(-var_76_24)
			
			if not arg_76_0.navigator.revert_dirty then
				arg_76_0.navigator:getChildByName("ani"):setAnimation(0, "guide", true)
				
				arg_76_0.navigator.revert_dirty = true
			end
			
			break
		end
	end
end

function WorldMapTown.getMapInfo(arg_77_0, arg_77_1)
	if not arg_77_0.maps then
		return 
	end
	
	return arg_77_0.maps[arg_77_1]
end

function WorldMapTown.isMapIconType(arg_78_0, arg_78_1)
	if arg_78_1 == "quest" or arg_78_1 == "extra_quest" or arg_78_1 == "stage" or arg_78_1 == "dungeon_quest" or arg_78_1 == "defense_quest" or arg_78_1 == "story" or arg_78_1 == "volleyball" or arg_78_1 == "cook" or arg_78_1 == "village" or arg_78_1 == "arcade" or arg_78_1 == "repair" or arg_78_1 == "exorcist" then
		return true
	end
end

function WorldMapTown.showMapDialog(arg_79_0, arg_79_1, arg_79_2)
	arg_79_2 = arg_79_2 or {}
	
	local var_79_0
	
	if arg_79_2.portal then
		return 
	end
	
	arg_79_0.runRoads = {}
	
	arg_79_0.controller:stopSoundCharacterWalk()
	
	if not arg_79_0:getFocusEffect() then
		arg_79_0.focus:setAnimation(0, "idle", true)
	end
	
	UIAction:Remove("CHAR_MOVE")
	
	if not arg_79_2.no_info and not arg_79_1 then
		return 
	end
	
	if arg_79_1 and arg_79_0.roadData[arg_79_1.id] then
		if arg_79_0.roadData[arg_79_1.id].portal == "empty" then
			balloon_message_with_sound("can_not_moved_yet")
			
			return 
		end
		
		if arg_79_0.roadData[arg_79_1.id].portal then
			return 
		end
		
		if arg_79_1 and arg_79_1.id and not Account:checkEnterMap(arg_79_1.id) then
			balloon_message_with_sound("can_not_moved_yet")
			
			return 
		end
		
		arg_79_0.target_town = nil
		var_79_0 = arg_79_1.id
		
		arg_79_0:setCurTown(var_79_0)
	else
		var_79_0 = arg_79_2.map_id
	end
	
	if arg_79_0:blockBeforeChapter(var_79_0) then
		balloon_message_with_sound("msg_substory_reset_lock")
		
		return 
	end
	
	if not arg_79_0:isOpenPropertyLock(var_79_0) then
		SubstoryEnterLockPopup:show(nil, var_79_0)
		
		return 
	end
	
	if arg_79_0:isResetSubCusItem(var_79_0) then
		SubstoryResetItemPopup:show(nil, var_79_0)
		
		return 
	end
	
	if arg_79_0:checkSubCusResetData(var_79_0) then
		Log.e("Err: level_world_3_chapter, level_substory_enter_property DB", var_79_0)
		
		return 
	end
	
	local var_79_1 = DB("level_enter", var_79_0, "type")
	
	if var_79_1 == "story" then
		StoryReady:show({
			enter_id = var_79_0
		})
		
		return 
	end
	
	if var_79_1 and var_79_1 == "volleyball" then
		VolleyBallReady:show({
			enter_id = var_79_0
		})
		
		return 
	end
	
	if var_79_1 and var_79_1 == "cook" then
		StoryReady:show({
			cook_type = true,
			enter_id = var_79_0
		})
		
		return 
	end
	
	if var_79_1 and var_79_1 == "repair" then
		StoryReady:show({
			repair_type = true,
			enter_id = var_79_0
		})
		
		return 
	end
	
	if var_79_1 and var_79_1 == "arcade" then
		StoryReady:show({
			arcade_type = true,
			enter_id = var_79_0
		})
		
		return 
	end
	
	if var_79_1 and var_79_1 == "exorcist" then
		StoryReady:show({
			exorcist_type = true,
			enter_id = var_79_0
		})
		
		return 
	end
	
	if var_79_1 and var_79_1 == "village" then
		SubStoryChristmasVillage:show()
		
		return 
	end
	
	if TutorialGuide:isPlayingTutorial("vfm0aa_epichell") then
		return 
	end
	
	BattleReady:show({
		ignore_block = true,
		enter_id = var_79_0,
		callback = arg_79_0
	})
end

function WorldMapTown.onStartBattle(arg_80_0, arg_80_1)
	if Account:getCurrentTeam()[1] == nil and Account:getCurrentTeam()[2] == nil and Account:getCurrentTeam()[3] == nil and Account:getCurrentTeam()[4] == nil and not arg_80_1.npcteam_id then
		message(T("ui_need_hero"))
		
		return 
	end
	
	local var_80_0 = DB("level_enter", arg_80_1.enter_id, {
		"type"
	})
	
	if WORLDMAP_MODE_LIST[var_80_0] then
		if arg_80_1.difficulty_id then
			arg_80_0.controller:saveLastTown(arg_80_1.difficulty_id)
		else
			arg_80_0.controller:saveLastTown(arg_80_1.enter_id)
		end
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_80_1.enter_id)
	startBattle(arg_80_1.enter_id, arg_80_1)
	BattleReady:hide()
end

function WorldMapTown.isOpenPropertyLock(arg_81_0, arg_81_1)
	return true
end

function WorldMapTown.isResetSubCusItem(arg_82_0, arg_82_1)
	return false
end

function WorldMapTown.checkSubCusResetData(arg_83_0, arg_83_1)
	return false
end

function WorldMapTown.blockBeforeChapter(arg_84_0, arg_84_1)
	return false
end

WorldMapTownAdv = ClassDef(WorldMapTown)

function WorldMapTownAdv.constructor(arg_85_0)
end

WorldMapTownSub = ClassDef(WorldMapTown)

function WorldMapTownSub.constructor(arg_86_0)
end

function WorldMapTownSub.isOpenPropertyLock(arg_87_0, arg_87_1)
	return (SubstoryManager:isUnlockDungeon(nil, arg_87_1))
end

function WorldMapTownSub.isResetSubCusItem(arg_88_0, arg_88_1)
	return (SubstoryManager:isResetSubCusItem(arg_88_1))
end

function WorldMapTownSub.checkSubCusResetData(arg_89_0, arg_89_1)
	return (SubstoryManager:checkSubCusResetData(arg_89_1))
end

function WorldMapTownSub.blockBeforeChapter(arg_90_0, arg_90_1)
	return (SubstoryManager:blockBeforeChapter(arg_90_1))
end

function WorldMapTownSub.makeEventNavigator(arg_91_0)
	arg_91_0.navigator = UIUtil:makeNavigatorAni()
	
	arg_91_0.map_layer:addChild(arg_91_0.navigator)
	arg_91_0.navigator:setVisible(false)
	arg_91_0.navigator:setLocalZOrder(var_0_1.NAVIGATOR)
	
	local var_91_0 = SubstoryManager:getCurrentQuestData()
	
	if var_91_0 and SubstoryManager:isApplyQuestInBattle(var_91_0.id) then
		arg_91_0.navigator.target = DB("substory_quest", var_91_0.id, "area_enter_id")
	end
	
	arg_91_0.navigator.scale = 0.55
end

function WorldMapTownSub.updateNavigatorTarget(arg_92_0)
	local var_92_0 = SubstoryManager:getCurrentQuestData()
	
	if var_92_0 and SubstoryManager:isApplyQuestInBattle(var_92_0.id) then
		arg_92_0.navigator.target = DB("substory_quest", var_92_0.id, "area_enter_id")
	end
end

function WorldMapTownSub.isShowNavigator(arg_93_0)
	if not SubstoryManager:getInfo() then
		return false
	end
	
	local var_93_0 = SubstoryManager:getInfo().id
	local var_93_1 = Account:getSubStory(var_93_0).quest_reward_state or SUBSTORY_QUEST_STATE.ACTIVE
	
	if tonumber(var_93_1) ~= SUBSTORY_QUEST_STATE.ACTIVE then
		return false
	end
	
	return true
end

WorldMapTownCustom = ClassDef(WorldMapTown)

function WorldMapTownCustom.constructor(arg_94_0)
end

function WorldMapTownCustom.isOpenPropertyLock(arg_95_0, arg_95_1)
	return (SubstoryManager:isUnlockDungeon(nil, arg_95_1))
end

function WorldMapTownCustom.isResetSubCusItem(arg_96_0, arg_96_1)
	return (SubstoryManager:isResetSubCusItem(arg_96_1))
end

function WorldMapTownCustom.checkSubCusResetData(arg_97_0, arg_97_1)
	return (SubstoryManager:checkSubCusResetData(arg_97_1))
end

function WorldMapTownCustom.blockBeforeChapter(arg_98_0, arg_98_1)
	return (SubstoryManager:blockBeforeChapter(arg_98_1))
end

function WorldMapTownCustom.isShowNavigator(arg_99_0)
	if not SubstoryManager:getInfo() then
		return false
	end
	
	local var_99_0 = SubstoryManager:getInfo().id
	local var_99_1 = Account:getSubStory(var_99_0).quest_reward_state or SUBSTORY_QUEST_STATE.ACTIVE
	
	if tonumber(var_99_1) ~= SUBSTORY_QUEST_STATE.ACTIVE then
		return false
	end
	
	return true
end

function WorldMapTownCustom.updateNavigatorTarget(arg_100_0)
	local var_100_0 = SubstoryManager:getCurrentQuestData()
	
	if var_100_0 and SubstoryManager:isApplyQuestInBattle(var_100_0.id) then
		arg_100_0.navigator.target = DB("substory_quest", var_100_0.id, "area_enter_id")
	end
end

function WorldMapTownCustom.makeEventNavigator(arg_101_0)
	arg_101_0.navigator = UIUtil:makeNavigatorAni()
	
	arg_101_0.map_layer:addChild(arg_101_0.navigator)
	arg_101_0.navigator:setVisible(false)
	arg_101_0.navigator:setLocalZOrder(var_0_1.NAVIGATOR)
	
	local var_101_0 = SubstoryManager:getCurrentQuestData()
	
	if var_101_0 and SubstoryManager:isApplyQuestInBattle(var_101_0.id) then
		arg_101_0.navigator.target = DB("substory_quest", var_101_0.id, "area_enter_id")
	end
	
	arg_101_0.navigator.scale = 0.55
end

function WorldMapTown.getChangeEnterID(arg_102_0, arg_102_1)
	if arg_102_1 == nil then
		return 
	end
	
	local var_102_0
	
	for iter_102_0 = 1, 10 do
		local var_102_1, var_102_2, var_102_3, var_102_4, var_102_5, var_102_6 = DB("level_enter_change", arg_102_1 .. "_" .. iter_102_0, {
			"id",
			"change_enter_id",
			"type",
			"condition_enter_id",
			"mission_type",
			"condition_mission_id"
		})
		
		if not var_102_1 then
			break
		end
		
		local var_102_7 = true
		
		if var_102_5 and var_102_6 then
			if var_102_5 == "sub_quest" then
				var_102_7 = ConditionContentsManager:getContents(CONTENTS_TYPE.SUBSTORY_QUETS):isCleared(var_102_6)
			elseif var_102_5 == "sub_cus_m" then
				var_102_7 = ConditionContentsManager:getContents(CONTENTS_TYPE.SUBSTORY_CUSTOM_MISSION):isCleared(var_102_6)
			else
				var_102_7 = false
			end
		end
		
		if var_102_3 == "stage_clear" then
			if var_102_7 and Account:isMapCleared(var_102_4) then
				var_102_0 = var_102_2
				
				break
			end
		elseif var_102_3 == "sub_ach" then
			local var_102_8 = string.split(var_102_4, ",")
			local var_102_9 = false
			
			for iter_102_1, iter_102_2 in pairs(var_102_8) do
				if not ConditionContentsManager:getSubStoryAchievement():isCleared(iter_102_2) then
					var_102_9 = true
					
					break
				end
			end
			
			if var_102_7 and not var_102_9 then
				var_102_0 = var_102_2
				
				break
			end
		end
	end
	
	return var_102_0
end
