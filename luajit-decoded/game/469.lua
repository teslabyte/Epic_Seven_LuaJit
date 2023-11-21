WorldMapWorld = ClassDef()

function WorldMapWorld.constructor(arg_1_0)
end

function WorldMapWorld.clear(arg_2_0)
	arg_2_0.main_map_layer = nil
	arg_2_0.main_cloud_layer = nil
	arg_2_0.SCALE = nil
end

function WorldMapWorld.create(arg_3_0, arg_3_1)
	arg_3_0:clear()
	
	arg_3_0.HEIGHT = DESIGN_HEIGHT
	arg_3_0.WIDTH = DESIGN_WIDTH
	
	local var_3_0 = cc.Layer:create()
	
	arg_3_0.layer = var_3_0
	arg_3_0.controller = arg_3_1
	
	var_3_0:setContentSize(arg_3_0.WIDTH, arg_3_0.HEIGHT)
	var_3_0:setPosition(arg_3_0.WIDTH / 2, arg_3_0.HEIGHT / 2)
	var_3_0:ignoreAnchorPointForPosition(false)
	
	return var_3_0
end

function WorldMapWorld.makeMap(arg_4_0)
	local var_4_0 = cc.Layer:create()
	
	var_4_0:setPosition(arg_4_0.WIDTH / 2, arg_4_0.HEIGHT / 2)
	var_4_0:setAnchorPoint(0.5, 0.5)
	var_4_0:setContentSize(arg_4_0.WIDTH, arg_4_0.HEIGHT)
	var_4_0:ignoreAnchorPointForPosition(false)
	
	local var_4_1 = cc.Layer:create()
	
	var_4_1:setPosition(arg_4_0.WIDTH / 2, arg_4_0.HEIGHT / 2)
	var_4_1:setAnchorPoint(0.5, 0.5)
	var_4_1:setContentSize(arg_4_0.WIDTH, arg_4_0.HEIGHT)
	var_4_1:ignoreAnchorPointForPosition(false)
	
	local var_4_2 = cc.Layer:create()
	
	var_4_2:setPosition(arg_4_0.WIDTH / 2, arg_4_0.HEIGHT / 2)
	var_4_2:setAnchorPoint(0.5, 0.5)
	var_4_2:setContentSize(arg_4_0.WIDTH, arg_4_0.HEIGHT)
	var_4_2:ignoreAnchorPointForPosition(false)
	
	local var_4_3 = {}
	
	arg_4_0.icons = {}
	
	for iter_4_0 = 2, 999 do
		local var_4_4, var_4_5, var_4_6, var_4_7, var_4_8, var_4_9, var_4_10, var_4_11, var_4_12, var_4_13, var_4_14, var_4_15, var_4_16, var_4_17, var_4_18, var_4_19, var_4_20, var_4_21 = DBN("level_world_1_world", iter_4_0, {
			"id",
			"key_continent",
			"name",
			"nx",
			"ny",
			"name_color",
			"img",
			"scale",
			"x",
			"y",
			"big_scale",
			"rotate",
			"color",
			"align",
			"type",
			"sub_story",
			"lock",
			"bgm"
		})
		
		if not var_4_4 then
			break
		end
		
		if arg_4_0.controller.vars.type == var_4_18 and (not arg_4_0.controller.vars.sub_story or tonumber(arg_4_0.controller.vars.sub_story.id) == tonumber(var_4_19)) then
			if var_4_16 == "dark" then
				var_4_16 = arg_4_0.controller.vars.DARK
			elseif var_4_16 == "name_dark" then
				var_4_9 = arg_4_0.controller.vars.DARK_NAME
			end
			
			local var_4_22 = {
				is_world = true,
				key_continent = var_4_5,
				name = var_4_6,
				nx = var_4_7,
				ny = var_4_8,
				nameColor = var_4_9,
				img = var_4_10,
				scale = var_4_11,
				x = var_4_12,
				y = var_4_13,
				big_scale = var_4_14,
				rotate = var_4_15,
				color = var_4_16,
				align = var_4_17,
				type = var_4_18,
				sub_story = var_4_19,
				lock = var_4_20
			}
			
			if var_4_6 == nil then
				local var_4_23 = arg_4_0.controller:add_map_to_layer(var_4_1, var_4_22)
				
				if not var_4_23 then
					break
				end
				
				var_4_23:setLocalZOrder(iter_4_0)
			else
				local var_4_24, var_4_25 = arg_4_0.controller:add_map_to_layer(var_4_0, var_4_22, var_4_2)
				
				if not var_4_24 then
					break
				end
				
				var_4_24:setLocalZOrder(iter_4_0)
				
				if var_4_6 ~= nil then
					table.insert(var_4_3, {
						id = tostring(var_4_4),
						name = T(var_4_6),
						key_continent = var_4_5,
						spr = var_4_24,
						x = var_4_12,
						y = var_4_13,
						big_scale = var_4_14,
						lock = var_4_20,
						bgm = var_4_21
					})
					
					arg_4_0.icons[var_4_5] = var_4_25
				end
			end
		end
	end
	
	return var_4_0, var_4_1, var_4_2, var_4_3
end

function WorldMapWorld.getChildByKeyContinent(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(arg_5_0.childs) do
		if arg_5_1 == iter_5_1.key_continent then
			return iter_5_1
		end
	end
end

function WorldMapWorld.showWorld(arg_6_0)
	SpriteCache:load("worldmap/world.atlas")
	SpriteCache:load("worldmap/land.atlas")
	arg_6_0.layer:removeAllChildren()
	
	if get_cocos_refid(arg_6_0.main_map_layer) == false and get_cocos_refid(arg_6_0.main_cloud_layer) == false then
		arg_6_0.main_map_layer, arg_6_0.main_cloud_layer, arg_6_0.ui_layer, arg_6_0.childs = arg_6_0:makeMap()
		
		arg_6_0.main_map_layer:setLocalZOrder(10)
		arg_6_0.main_cloud_layer:setLocalZOrder(11)
		arg_6_0.ui_layer:setLocalZOrder(12)
		arg_6_0.layer:addChild(arg_6_0.main_map_layer)
		arg_6_0.layer:addChild(arg_6_0.main_cloud_layer)
		arg_6_0.layer:addChild(arg_6_0.ui_layer)
	else
		arg_6_0.layer:setVisible(true)
	end
end

function WorldMapWorld.playEnterAction(arg_7_0)
	SET_LAYER_OPACITY(arg_7_0.main_map_layer, 255)
	SET_LAYER_OPACITY(arg_7_0.main_cloud_layer, 255)
	SET_LAYER_OPACITY(arg_7_0.ui_layer, 255)
	
	local var_7_0 = 500
	
	Action:AddAsync(LOG(SPAWN(SCALE(var_7_0, 2.13, 1), MOVE_TO(var_7_0, arg_7_0.WIDTH / 2, arg_7_0.HEIGHT / 2), ANCHOR(var_7_0, arg_7_0.main_map_layer:getAnchorPoint(), cc.p(0.5, 0.5)))), arg_7_0.main_map_layer, "worldmap_action")
	Action:AddAsync(LOG(SPAWN(SCALE(var_7_0, 4.26, 1), MOVE_TO(var_7_0, arg_7_0.WIDTH / 2, arg_7_0.HEIGHT / 2), ANCHOR(var_7_0, arg_7_0.main_cloud_layer:getAnchorPoint(), cc.p(0.5, 0.5)))), arg_7_0.main_cloud_layer, "worldmap_action")
	Action:AddAsync(LOG(SPAWN(SCALE(var_7_0, 2.13, 1), MOVE_TO(var_7_0, arg_7_0.WIDTH / 2, arg_7_0.HEIGHT / 2), ANCHOR(var_7_0, arg_7_0.ui_layer:getAnchorPoint(), cc.p(0.5, 0.5)))), arg_7_0.ui_layer, "worldmap_action")
end

function WorldMapWorld.onTouchDown(arg_8_0, arg_8_1, arg_8_2)
	if Action:Find("worldmap_action") ~= nil then
		return 
	end
	
	local var_8_0 = arg_8_0.childs
	local var_8_1 = arg_8_0.main_map_layer
	local var_8_2 = slowpick2(var_8_1, var_8_0, arg_8_1, arg_8_2)
	local var_8_3 = arg_8_0.childs[var_8_2]
	
	if not var_8_2 then
		return 
	end
	
	if arg_8_0.childs[var_8_2] and not arg_8_0.childs[var_8_2].lock then
		local var_8_4 = arg_8_0.childs[var_8_2].name
		
		arg_8_0:enterContinent(arg_8_0.childs[var_8_2].id, arg_8_0.childs[var_8_2])
	else
		Dialog:msgBox(T("mission_notyet"))
		
		return 
	end
end

function WorldMapWorld.enterContinent(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.controller:setWorldID(arg_9_1)
	arg_9_0.controller:changeMode("LAND", arg_9_2)
	
	if arg_9_0.controller.vars.bgm ~= arg_9_2.bgm and arg_9_2.bgm ~= nil then
		arg_9_0.controller.vars.bgm = arg_9_2.bgm
		
		local var_9_0 = arg_9_0.controller:getBGM()
		
		SoundEngine:playBGM(var_9_0)
	end
end

function WorldMapWorld.update(arg_10_0)
end

WorldMapWorldAdv = ClassDef(WorldMapWorld)

function WorldMapWorldAdv.constructor(arg_11_0)
end

WorldMapWorldSub = ClassDef(WorldMapWorld)

function WorldMapWorldSub.constructor(arg_12_0)
end

WorldMapWorldCustom = ClassDef(WorldMapWorld)

function WorldMapWorldCustom.constructor(arg_13_0)
end
