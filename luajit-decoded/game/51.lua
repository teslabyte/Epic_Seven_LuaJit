FIELD_REDUCE_SCALE = 0.6666666666666666
FIELD_TAG_GRID = 1001
FIELD_TAG_DARK = 2001
FIELD_SCROLL_ANCHOR_RATE = 0.025
DEBUG.DEBUG_BG = false
DEBUG.BG_SCALE = DEBUG.BG_SCALE or 1
DEBUG.BG_PROP = DEBUG.BG_PROP or false
DEBUG.BG_SCROLL = DEBUG.BG_SCROLL or false
DEBUG.BG_LABEL = DEBUG.BG_LABEL or false

local var_0_0 = 1
local var_0_1 = 0.6

mark_filter("screen,floor,field")
mark_filter("")

local function var_0_2()
	if DEBUG.DEBUG_BG then
		return DEBUG.BG_SCALE
	end
	
	return 1
end

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0 = {}
	
	if not arg_2_0 then
		local var_2_1 = {
			per_x = 1,
			main_ground = "y",
			y = 0,
			x = 0,
			per_y = var_0_1,
			width = DESIGN_WIDTH
		}
		
		table.insert(var_2_0, var_2_1)
		
		return var_2_0
	end
	
	local var_2_2 = MODEL_SCALE_FACTOR
	local var_2_3
	local var_2_4
	
	if arg_2_1 then
		var_2_3, var_2_4 = DB("background_flip", arg_2_0 .. "_1", {
			"type",
			"bg_atlas"
		})
	end
	
	if not var_2_3 then
		var_2_4 = DB("background", arg_2_0 .. "_1", "bg_atlas")
	end
	
	local var_2_5 = true
	local var_2_6 = var_2_4 or arg_2_0
	
	if var_2_6 == "mashroom" then
		SpriteCache:load("bg/" .. var_2_6 .. ".atlas")
		
		var_2_5 = false
	else
		SpriteCache:load("bg/" .. var_2_6 .. ".sca")
	end
	
	for iter_2_0 = 1, 50 do
		local var_2_7 = {}
		
		var_2_7.spr, var_2_7.scale, var_2_7.x, var_2_7.y, var_2_7.width, var_2_7.per_x, var_2_7.per_y, var_2_7.scroll, var_2_7.type, var_2_7.zoom_scale, var_2_7.r, var_2_7.g, var_2_7.b, var_2_7.anchor_y, var_2_7.atlas, var_2_7.roof_obj, var_2_7.main_land, var_2_7.main_ground = DB(var_2_3 and "background_flip" or "background", arg_2_0 .. "_" .. iter_2_0, {
			"spr",
			"scale",
			"x",
			"y",
			"width",
			"per_x",
			"per_y",
			"scroll",
			"type",
			"zoom_scale",
			"r",
			"g",
			"b",
			"anchor_y",
			"atlas",
			"roof_obj",
			"main_land",
			"main_ground"
		})
		
		if var_2_5 then
			var_2_7.bg_atlas = var_2_6
		end
		
		var_2_7.theme_name = arg_2_0
		
		if var_2_7.spr then
			if var_2_7.scale then
				var_2_7.scale = var_2_7.scale * var_2_2
			end
			
			if var_2_7.x then
				var_2_7.x = var_2_7.x * var_2_2
			end
			
			if var_2_7.y then
				var_2_7.y = var_2_7.y * var_2_2
			end
			
			var_2_7.width = var_2_7.width or 0
			
			table.insert(var_2_0, var_2_7)
		end
	end
	
	return var_2_0
end

local function var_0_4(arg_3_0)
	local var_3_0
	local var_3_1 = su.BatchedLayer:create()
	
	var_3_1:ignoreAnchorPointForPosition(false)
	var_3_1:setCascadeOpacityEnabled(true)
	var_3_1:setName(arg_3_0 or string.format("FieldLayer<%p>", var_3_1))
	
	return var_3_1
end

function field_getSprite(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0, var_4_1, var_4_2 = path.split(arg_4_0)
	
	if var_4_2 == ".scsp" or var_4_2 == ".json" or var_4_2 == ".skel" then
		arg_4_1 = arg_4_1 or string.sub(arg_4_0, 1, -5) .. "atlas"
		
		local var_4_3 = ur.Model:create("bg/" .. arg_4_0, "bg/" .. arg_4_1, 1)
		
		var_4_3:setAnimation(0, "idle", true)
		var_4_3:update(math.random())
		
		return var_4_3, true
	end
	
	if var_4_2 == ".cfx" then
		local var_4_4 = su.CompositiveEffect2D:create("effect/" .. arg_4_0)
		
		if not var_4_4 then
			return var_4_4, false
		end
		
		var_4_4:setAncestor(arg_4_3)
		var_4_4:setScaleFactor(BASE_SCALE)
		var_4_4:start()
		
		return var_4_4, true
	end
	
	if arg_4_0 == "road.png" then
		return cc.Sprite:create(arg_4_0), false
	end
	
	if arg_4_2 then
		var_4_1 = arg_4_2 .. "/" .. var_4_1
	end
	
	return SpriteCache:getSprite(var_4_1) or SpriteCache:getSprite(arg_4_0), false
end

FieldTileProp = ClassDef()

function FieldTileProp.constructor(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.parent = arg_5_1
	arg_5_0.field = arg_5_1.field
	arg_5_0.layout = arg_5_1.layout
	arg_5_0.position = {
		x = 0,
		y = 0
	}
	arg_5_0.viewport = arg_5_0.field:getViewPort()
	arg_5_0.instance_pool = arg_5_2
	arg_5_0.info = arg_5_0.instance_pool:getInstanceInfo()
	
	arg_5_0:loadResource()
end

function FieldTileProp.updateScroll(arg_6_0, arg_6_1)
	arg_6_0.scroll = arg_6_1 or 0
	
	if get_cocos_refid(arg_6_0.instance) then
		local var_6_0 = arg_6_0.instance:getAnchorPoint()
		local var_6_1 = arg_6_0.info.pattern.width / arg_6_0.instance:getContentSize().width
		
		var_6_0.x = arg_6_0.scroll * var_6_1
		
		arg_6_0.instance:setAnchorPoint(var_6_0)
	end
end

function FieldTileProp.updatePosition(arg_7_0, arg_7_1)
	if arg_7_0.position_id == arg_7_1 then
		return 
	end
	
	arg_7_0.position_id = arg_7_1
	
	local var_7_0 = arg_7_0.parent:getPositionX()
	
	arg_7_0.position_x = arg_7_0.info.pattern.x + (arg_7_1 - 1) * arg_7_0.info.pattern.width
	
	if get_cocos_refid(arg_7_0.instance) and (not (arg_7_0.info.offset_x > 0) or true) then
		arg_7_0.instance:setPosition(arg_7_0.info.offset_x + arg_7_0.position_x, (arg_7_0.position.y or 0) + arg_7_0.info.offset_y)
	end
end

function FieldTileProp.loadResource(arg_8_0)
	if get_cocos_refid(arg_8_0.instance) then
		return 
	end
	
	local var_8_0 = arg_8_0.instance_pool:get(arg_8_0.field.layer)
	
	if not var_8_0 then
		return 
	end
	
	arg_8_0.instance = var_8_0
	
	arg_8_0.instance:setVisible(true)
	
	return true
end

function FieldTileProp.unloadResource(arg_9_0)
	if not arg_9_0.instance then
		return 
	end
	
	arg_9_0.instance_pool:release(arg_9_0.instance)
	
	arg_9_0.instance = nil
	
	return true
end

FieldTilePropInstancePool = ClassDef()

function FieldTilePropInstancePool.constructor(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_0.parent = arg_10_1
	arg_10_0.sprite_name = arg_10_2
	arg_10_0.atlas_name = arg_10_3
	arg_10_0.bg_atlas = arg_10_4
	arg_10_0.field = arg_10_1.field
	arg_10_0.layout = arg_10_1.layout
	arg_10_0.released_list = {}
end

function FieldTilePropInstancePool.calcPatternInfo(arg_11_0, arg_11_1)
	local var_11_0 = {
		x = 0,
		width = 0,
		count = 0
	}
	local var_11_1 = arg_11_0.field:getViewPort().width
	
	if arg_11_0.layout.width == -1 then
		var_11_0.count = 1
		var_11_0.width = var_11_1
	else
		var_11_0.x = -var_11_1 * 0.5
		var_11_0.width = arg_11_0.layout.width * arg_11_0.layout.scale
		
		if var_11_0.width == 0 then
			var_11_0.width = arg_11_1.width
		end
		
		var_11_0.count = math.ceil(var_11_1 / var_11_0.width) * 4 + 1
		
		local var_11_2 = arg_11_0.layout.per_x * var_11_0.width
		
		if (arg_11_0.layout.scroll or 0) == 0 and var_11_1 < var_11_0.width - var_11_2 then
		end
	end
	
	return var_11_0
end

function FieldTilePropInstancePool.getInstanceInfo(arg_12_0)
	return arg_12_0.info or {}
end

function FieldTilePropInstancePool.createInstance(arg_13_0, arg_13_1)
	local var_13_0, var_13_1 = field_getSprite(arg_13_0.sprite_name, arg_13_0.atlas_name, arg_13_0.bg_atlas, arg_13_1)
	
	if not get_cocos_refid(var_13_0) then
		return 
	end
	
	arg_13_0.reserve_y = 0
	
	local var_13_2
	local var_13_3 = cc.Node:create()
	
	var_13_3:setCascadeColorEnabled(true)
	var_13_3:setCascadeOpacityEnabled(true)
	var_13_3:setAnchorPoint(0, 0)
	var_13_3:ignoreAnchorPointForPosition(false)
	var_13_3:addChild(var_13_0)
	
	local var_13_4
	local var_13_5
	local var_13_6 = 0
	local var_13_7 = arg_13_0.field:getViewPort()
	
	if var_13_1 then
		if DEBUG.DEBUG_BG then
			if var_13_0.getBoneNode then
				var_13_4 = var_13_0:getBoneNode("root")
			else
				var_13_4 = var_13_0
			end
			
			var_13_5 = cc.c3b(255, 0, 0)
		end
		
		var_13_2 = {
			width = var_13_7.width * arg_13_0.layout.scale,
			height = var_13_7.height * arg_13_0.layout.scale
		}
		
		var_13_0:setAnchorPoint(0, 0)
		var_13_0:setPosition(0, var_13_2.height / 2)
	else
		if DEBUG.DEBUG_BG then
			var_13_4 = var_13_0
			var_13_5 = cc.c3b(0, 0, 255)
		end
		
		var_13_0:setPosition(0, 0)
		
		if var_13_0:getRotation() > 0 then
			var_13_0:setAnchorPoint(1, 1)
			var_13_0:setRotation(180)
		else
			var_13_0:setAnchorPoint(0, 0)
		end
		
		local var_13_8 = var_13_0:getContentSize()
		
		var_13_2 = {
			width = var_13_8.width * arg_13_0.layout.scale / FIELD_REDUCE_SCALE,
			height = var_13_8.height * arg_13_0.layout.scale / FIELD_REDUCE_SCALE
		}
	end
	
	var_13_0:setColor(cc.c3b(arg_13_0.layout.r, arg_13_0.layout.g, arg_13_0.layout.b))
	
	if var_13_1 then
		var_13_0:setScale(arg_13_0.layout.scale)
	else
		var_13_0:setScale(arg_13_0.layout.scale / FIELD_REDUCE_SCALE)
	end
	
	var_13_3:setContentSize(var_13_2.width, var_13_2.height)
	
	if not arg_13_0.info then
		arg_13_0.info = {}
		arg_13_0.info.name = arg_13_0.sprite_name
		arg_13_0.info.width = var_13_2.width
		arg_13_0.info.height = var_13_2.height
		arg_13_0.info.offset_x = arg_13_0.layout.x
		arg_13_0.info.offset_y = arg_13_0.field:getHeight() - arg_13_0.layout.y - (var_13_2.height - var_13_0:getPositionY())
		arg_13_0.info.pattern = arg_13_0:calcPatternInfo(var_13_2)
	end
	
	if DEBUG.BG_LABEL and var_13_4 then
		local var_13_9 = ccui.Text:create()
		
		var_13_9:setFontName("font/daum.ttf")
		var_13_9:setString(arg_13_0.layout.spr .. "-" .. tostring(DEBUG.LODING_LAYER_ID))
		var_13_9:setFontSize(22)
		var_13_9:setGlobalZOrder(1000)
		
		local var_13_10 = cc.Sprite:create("system/default/bigdot.png")
		
		var_13_10:setColor(var_13_5)
		var_13_9:enableOutline(var_13_5, 1)
		var_13_4:addChild(var_13_10)
		var_13_4:addChild(var_13_9)
	end
	
	var_13_3.sprite = var_13_0
	
	var_13_3:setVisible(true)
	arg_13_0.parent:addChild(var_13_3)
	table.insert(arg_13_0.released_list, var_13_3)
	
	if DEBUG.BG_PROP then
		local var_13_11 = var_13_3:getContentSize()
		local var_13_12 = cc.DrawNode:create()
		
		var_13_12:drawRect(cc.p(0, 0), cc.p(var_13_11.width, var_13_11.height), cc.c4f(1, 1, 1, 1))
		var_13_3:addChild(var_13_12)
	end
	
	return var_13_3
end

function FieldTilePropInstancePool.get(arg_14_0, arg_14_1)
	local var_14_0 = table.remove(arg_14_0.released_list)
	
	if not var_14_0 then
		arg_14_0:createInstance(arg_14_1)
		
		var_14_0 = table.remove(arg_14_0.released_list)
	end
	
	return var_14_0
end

function FieldTilePropInstancePool.release(arg_15_0, arg_15_1)
	if not get_cocos_refid(arg_15_1) then
		return 
	end
	
	table.insert(arg_15_0.released_list, arg_15_1)
	arg_15_1:setVisible(false)
end

FieldLayer = {}

function FieldLayer.create(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = var_0_4("FieldLayer")
	
	copy_functions(FieldLayer, var_16_0)
	
	var_16_0.field = arg_16_1
	var_16_0.layout = arg_16_2
	
	var_16_0:setup()
	
	return var_16_0
end

function FieldLayer.setup(arg_17_0)
	arg_17_0.layer_width = arg_17_0.field:getWidth()
	
	arg_17_0:setContentSize(arg_17_0.layer_width, arg_17_0.field:getHeight())
	
	if DEBUG.DEBUG_BG then
		mark(arg_17_0, cc.c3b(0, 255, 0), "field")
		
		local var_17_0 = cc.Sprite:create("system/default/bigdot.png")
		
		var_17_0:setColor(cc.c3b(255, 0, 0))
		var_17_0:setScale(4)
		arg_17_0:addChild(var_17_0)
		
		arg_17_0.debugDot = var_17_0
	end
end

function FieldLayer.setOpacityByTag(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.opacity_tags then
		arg_18_0.opacity_tags = {}
	end
	
	arg_18_1 = tonumber(arg_18_1) or 255
	
	if not arg_18_1 or arg_18_1 >= 255 then
		arg_18_0.opacity_tags[arg_18_2] = nil
	else
		arg_18_0.opacity_tags[arg_18_2] = arg_18_1 / 255
	end
	
	local var_18_0 = 1
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.opacity_tags) do
		var_18_0 = var_18_0 * iter_18_1
	end
	
	arg_18_0:setOpacity(var_18_0 * 255)
end

function FieldLayer.updateViewport(arg_19_0)
	arg_19_0.vp = arg_19_0.vp or {}
	arg_19_0.vp.viewport = arg_19_0.field:getViewPort()
	arg_19_0.vp.field_scale = arg_19_0.field:getScale()
	arg_19_0.vp.layout_per_x = arg_19_0.layout.per_x / var_0_0
	arg_19_0.vp.layout_per_y = arg_19_0.layout.per_y / var_0_1
	
	if arg_19_0.getCamera then
		arg_19_0:updateViewportByCamera()
	else
		arg_19_0:updateViewportByTransform()
	end
	
	if arg_19_0.onAfterUpdated then
		arg_19_0:onAfterUpdated()
	end
	
	arg_19_0:procCulling()
end

function FieldLayer.updateViewportByCamera(arg_20_0)
	local var_20_0 = 1 / arg_20_0.vp.field_scale
	local var_20_1 = arg_20_0.vp.viewport.x * arg_20_0.vp.layout_per_x
	local var_20_2 = (arg_20_0.vp.viewport.y + arg_20_0.vp.viewport.height * CAM_ANCHOR_Y) * arg_20_0.vp.layout_per_y
	local var_20_3 = var_20_1 * arg_20_0.vp.viewport.scale
	local var_20_4 = var_20_2 * arg_20_0.vp.viewport.scale
	local var_20_5 = arg_20_0:getCamera()
	
	var_20_5:setContentSize(arg_20_0.vp.viewport.width * arg_20_0.vp.viewport.scale, arg_20_0.vp.viewport.height * arg_20_0.vp.viewport.scale)
	var_20_5:setAnchorPoint(CAM_ANCHOR_X, CAM_ANCHOR_Y)
	
	local var_20_6 = arg_20_0.vp.viewport.width * (1 - arg_20_0.vp.viewport.scale) * (1 - var_20_0) * CAM_ANCHOR_X
	local var_20_7 = arg_20_0.vp.viewport.height * (1 - arg_20_0.vp.viewport.scale) * (1 - var_20_0) * CAM_ANCHOR_Y
	local var_20_8 = var_20_3 + var_20_6
	local var_20_9 = var_20_4 + var_20_7
	
	var_20_5:setPosition(var_20_8, var_20_9)
	var_20_5:setScale(var_20_0)
end

function FieldLayer.updateViewportByTransform(arg_21_0)
	local var_21_0 = arg_21_0:getContentSize().width
	local var_21_1 = arg_21_0:getContentSize().height
	local var_21_2 = arg_21_0.vp.viewport.x
	local var_21_3 = arg_21_0.vp.viewport.y
	local var_21_4 = var_21_2 * arg_21_0.vp.layout_per_x / var_21_0
	local var_21_5 = var_21_3 * arg_21_0.vp.layout_per_y / var_21_1
	local var_21_6 = 0
	local var_21_7 = arg_21_0.vp.viewport.height * CAM_ANCHOR_Y / var_21_1
	local var_21_8 = var_21_4 + var_21_6
	local var_21_9 = var_21_5 + var_21_7
	
	arg_21_0:setAnchorPoint(var_21_8, var_21_9)
	
	if get_cocos_refid(arg_21_0.debugDot) then
		arg_21_0.debugDot:setPosition(var_21_8 * var_21_0, var_21_9 * var_21_1)
	end
end

function FieldLayer.procCulling(arg_22_0)
end

FieldTilePropLayer = {}

function FieldTilePropLayer.create(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = var_0_4("FieldTilePropLayer")
	
	copy_functions(FieldLayer, var_23_0)
	copy_functions(FieldTilePropLayer, var_23_0)
	
	var_23_0.field = arg_23_1
	var_23_0.layout = arg_23_2
	
	var_23_0:setup()
	
	return var_23_0
end

function FieldTilePropLayer.setup(arg_24_0)
	FieldLayer.setup(arg_24_0)
	
	arg_24_0.prop_instance_pool = FieldTilePropInstancePool(arg_24_0, arg_24_0.layout.spr, arg_24_0.layout.atlas, arg_24_0.layout.bg_atlas)
	
	if not arg_24_0.prop_instance_pool:createInstance(arg_24_0) then
		print("파일없음: FieldTilePropLayer(" .. tostring(arg_24_0.layout.spr) .. ")")
		
		return 
	end
	
	arg_24_0.prop_info = arg_24_0.prop_instance_pool:getInstanceInfo()
	arg_24_0.prop_list = {}
	
	for iter_24_0 = 1, arg_24_0.prop_info.pattern.count do
		local var_24_0 = FieldTileProp(arg_24_0, arg_24_0.prop_instance_pool)
		
		table.insert(arg_24_0.prop_list, var_24_0)
	end
	
	if (arg_24_0.layout.scroll or 0) ~= 0 then
		arg_24_0:enableScrollingStage()
	end
	
	arg_24_0:updateViewport()
	
	if DEBUG.DEBUG_BG then
		mark(arg_24_0, cc.c3b(0, 255, 0), "layer")
	end
end

function FieldTilePropLayer.doScrollingStage(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0.layout.scroll * FIELD_SCROLL_ANCHOR_RATE * arg_25_1
	
	if math.abs(var_25_0) > 1 then
		var_25_0 = math.mod(var_25_0, 1)
	end
	
	arg_25_0.pre_scroll = arg_25_0.scroll or 0
	arg_25_0.scroll = (arg_25_0.scroll or 0) + var_25_0
	
	if math.abs(arg_25_0.scroll) >= 1 then
		arg_25_0.scroll = math.mod(arg_25_0.scroll, 1) + var_25_0
	end
end

function FieldTilePropLayer.onAfterUpdated(arg_26_0)
	if not arg_26_0.enabled_scroll then
		return 
	end
	
	local var_26_0 = GET_CUR_PROCESS_DELTA()
	
	arg_26_0:doScrollingStage(var_26_0)
end

function FieldTilePropLayer.enableScrollingStage(arg_27_0)
	arg_27_0.enabled_scroll = true
end

function FieldTilePropLayer.procCulling(arg_28_0)
	local function var_28_0(arg_29_0)
		return (arg_28_0.inbounds_id + (arg_29_0 - 1)) % arg_28_0.prop_info.pattern.count + 1
	end
	
	local var_28_1 = arg_28_0:getContentSize().width
	local var_28_2 = arg_28_0:getAnchorPoint().x * var_28_1 - arg_28_0.prop_info.offset_x
	
	if arg_28_0.left_pixel ~= var_28_2 then
		arg_28_0.left_pixel = var_28_2
		
		local var_28_3 = math.floor(math.abs(var_28_2) / arg_28_0.prop_info.pattern.width) - 2
		
		if arg_28_0.inbounds_id ~= var_28_3 then
			arg_28_0.inbounds_id = var_28_3
			
			for iter_28_0 = 1, #arg_28_0.prop_list do
				local var_28_4 = var_28_0(iter_28_0)
				
				arg_28_0.prop_list[var_28_4]:updatePosition(arg_28_0.inbounds_id + iter_28_0)
			end
		end
	end
	
	for iter_28_1, iter_28_2 in pairs(arg_28_0.prop_list) do
		iter_28_2:updateScroll(arg_28_0.scroll)
	end
end

FieldFloorLayer = {}

function FieldFloorLayer.create(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = var_0_4("FieldFloorLayer")
	
	copy_functions(FieldLayer, var_30_0)
	copy_functions(FieldFloorLayer, var_30_0)
	
	var_30_0.is_floor = true
	var_30_0.field = arg_30_1
	var_30_0.layout = arg_30_2
	
	if su.createSpecialLayer then
		var_30_0.front_layer = su.createSpecialLayer("BlendAligmentLayer")
	end
	
	if not var_30_0.front_layer then
		var_30_0.front_layer = cc.Layer:create()
	end
	
	var_30_0.front_layer:setContentSize(var_30_0:getContentSize())
	var_30_0.front_layer:setPosition(0, 0)
	var_30_0.front_layer:setName("@FRONT_LAYER")
	var_30_0.front_layer:setLocalZOrder(100)
	var_30_0:addProtectedChild(var_30_0.front_layer)
	
	var_30_0.object_layer = cc.Layer:create()
	
	var_30_0.object_layer:setContentSize(var_30_0:getContentSize())
	var_30_0.object_layer:setPosition(0, 0)
	var_30_0.object_layer:setName("@OBJECT_LAYER")
	var_30_0.object_layer:setLocalZOrder(-100)
	var_30_0:addProtectedChild(var_30_0.object_layer)
	var_30_0:setup()
	
	return var_30_0
end

function FieldFloorLayer.setup(arg_31_0)
	FieldLayer.setup(arg_31_0)
end

function FieldFloorLayer.getFrontLayer(arg_32_0)
	return arg_32_0.front_layer or arg_32_0
end

function FieldFloorLayer.getContainer(arg_33_0)
	return arg_33_0.layer or arg_33_0
end

function FieldFloorLayer.onAfterUpdated(arg_34_0)
end

function FieldFloorLayer.addFieldObjectModel(arg_35_0, arg_35_1)
	arg_35_0.object_layer:addChild(arg_35_1)
end

DEBUG.LODING_LAYER_ID = 0
FIELD_NEW = {}

function FIELD_NEW.makeField(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
	arg_36_5 = arg_36_5 or {}
	
	local var_36_0 = {}
	
	var_36_0.scale = 1
	var_36_0.theme_name = arg_36_2
	var_36_0.layer = arg_36_1
	var_36_0.background_list = {}
	var_36_0.forground_list = {}
	var_36_0.data = {}
	var_36_0.fields = {}
	var_36_0.viewport = {}
	var_36_0.walk_anchor = 0
	var_36_0.start_time = GET_LAST_TICK()
	var_36_0.main_land = {}
	var_36_0.main_land.idx = 1
	var_36_0.main_land.last_move = 0
	
	copy_functions(FIELD_NEW, var_36_0)
	
	local var_36_1 = var_0_2()
	
	var_36_0.viewport.x = 0
	var_36_0.viewport.y = 0
	var_36_0.viewport.width = arg_36_5.viewport_width or tonumber(DESIGN_WIDTH)
	var_36_0.viewport.height = arg_36_5.viewport_height or tonumber(DESIGN_HEIGHT)
	var_36_0.viewport.scale = var_36_1
	
	var_36_0:setWidth(arg_36_3)
	arg_36_1:setScale(var_36_1)
	
	var_36_0.layout = var_0_3(arg_36_2, arg_36_4)
	
	for iter_36_0, iter_36_1 in pairs(var_36_0.layout) do
		if (tonumber(iter_36_1.spec) or 0) <= DEVICE_SPEC_NUM and (not DEBUG.DEBUG_BG or DEBUG.BG_LOADMAP.all or DEBUG.BG_LOADMAP[iter_36_0]) then
			DEBUG.LODING_LAYER_ID = iter_36_0
			
			var_36_0:addOneLayer(arg_36_1, iter_36_1)
		end
		
		if iter_36_1.main_ground == "y" then
			DEBUG.LODING_LAYER_ID = iter_36_0
			var_36_0.main = var_36_0:addOneLayer(arg_36_1, iter_36_1, true)
			
			if DEBUG.DEBUG_BG then
				var_36_0.debug = var_36_0:addOneLayer(arg_36_1, iter_36_1, true)
				
				local var_36_2 = cc.LayerColor:create(cc.c3b(255, 255, 0))
				
				var_36_2:setOpacity(60)
				var_36_2:setContentSize(var_36_0:getWidth(), var_36_0:getHeight())
				var_36_2:setPosition(0, 0)
				var_36_0.debug.layer:addChild(var_36_2)
			end
		end
	end
	
	var_36_0.road_event_object_list = {}
	var_36_0.road_event_model_tbl = {}
	var_36_0.top_layer = cc.Layer:create()
	
	arg_36_1:addChild(var_36_0.top_layer)
	arg_36_1:setVisible(true)
	
	if DEBUG.DEBUG_BG or DEBUG.SHOW_BG_MARK then
		mark(arg_36_1, cc.c3b(255, 0, 0), "screen")
	end
	
	return var_36_0
end

function FIELD_NEW.setWidth(arg_37_0, arg_37_1)
	arg_37_0.max_width = arg_37_1
end

function FIELD_NEW.getWidth(arg_38_0)
	return arg_38_0.max_width or DESIGN_WIDTH * 2
end

function FIELD_NEW.getScrollWidth(arg_39_0)
	return arg_39_0:getWidth() - DESIGN_WIDTH
end

function FIELD_NEW.setHeight(arg_40_0, arg_40_1)
	arg_40_0.max_height = arg_40_1
end

function FIELD_NEW.getHeight(arg_41_0)
	if not arg_41_0 or not arg_41_0.max_height then
		return DESIGN_HEIGHT * 1.1
	end
	
	return arg_41_0.max_height
end

function FIELD_NEW.getScale(arg_42_0)
	return arg_42_0.scale or 1
end

function FIELD_NEW.setScale(arg_43_0, arg_43_1)
	arg_43_0.scale = arg_43_1
end

function FIELD_NEW.getColor(arg_44_0, arg_44_1)
	return arg_44_0.data[1].layer:getChildren()[1]:getColor()
end

function FIELD_NEW.setColor(arg_45_0, arg_45_1)
	for iter_45_0 = 1, #arg_45_0.data do
		local var_45_0 = arg_45_0.data[iter_45_0].layer:getChildren()
		
		for iter_45_1 = 1, #var_45_0 do
			var_45_0[iter_45_1]:setColor(arg_45_1)
		end
	end
end

function FIELD_NEW.setVisibleGrid(arg_46_0, arg_46_1)
	if arg_46_1 then
		local var_46_0 = make_grid()
		
		arg_46_0.main.layer:addProtectedChild(var_46_0, 0, FIELD_TAG_GRID)
		
		arg_46_0.main.layer.grid = var_46_0
	else
		arg_46_0.main.layer.grid = nil
		
		arg_46_0.main.layer:removeProtectedChildByTag(FIELD_TAG_GRID)
	end
end

function FIELD_NEW.getViewPort(arg_47_0)
	return arg_47_0.viewport
end

function FIELD_NEW.lockViewPort(arg_48_0, arg_48_1)
	arg_48_0.viewport.lock = arg_48_1
end

function FIELD_NEW.lockViewPortRange(arg_49_0, arg_49_1)
	if arg_49_1 then
		arg_49_0.minRangeX = arg_49_1.minRangeX or nil
		arg_49_0.maxRangeX = arg_49_1.maxRangeX or nil
	end
end

function FIELD_NEW.setViewPortPosition(arg_50_0, arg_50_1, arg_50_2)
	if DEBUG.BG_SCROLL then
		return 
	end
	
	if arg_50_0.viewport.lock then
		return 
	end
	
	local var_50_0 = arg_50_0:isVisibleField()
	
	if var_50_0 and arg_50_0.minRangeX and arg_50_0.maxRangeX then
		arg_50_0.viewport.x = math.clamp(arg_50_1, arg_50_0.minRangeX, arg_50_0.maxRangeX)
	elseif var_50_0 then
		local var_50_1 = 0
		
		arg_50_0.viewport.x = math.min(math.max(var_50_1, arg_50_1), arg_50_0:getWidth() - var_50_1)
	else
		arg_50_0.viewport.x = arg_50_1
	end
	
	if arg_50_2 then
		if is_using_story_v2() then
			arg_50_0.viewport.y = arg_50_2
		elseif var_50_0 then
			local var_50_2 = 0
			local var_50_3 = arg_50_0.viewport.height * arg_50_0.scale * CAM_ANCHOR_Y
			
			arg_50_0.viewport.y = math.min(math.max(var_50_2, arg_50_2), var_50_3)
		else
			arg_50_0.viewport.y = arg_50_2
		end
	end
end

function FIELD_NEW.getViewPortPosition(arg_51_0)
	return arg_51_0.viewport.x or 0, arg_51_0.viewport.y
end

function FIELD_NEW.dbgBackgroundScrolling(arg_52_0)
end

function FIELD_NEW.updateViewport(arg_53_0)
	if DEBUG.BG_SCROLL then
		arg_53_0:dbgBackgroundScrolling()
		
		if not arg_53_0.scroll_dir then
			arg_53_0.scroll_dir = 1
		end
		
		arg_53_0.viewport.x = (arg_53_0.viewport.x or 0) + arg_53_0.scroll_dir * 10
		
		if arg_53_0.scroll_dir > 0 and arg_53_0.viewport.x > arg_53_0:getWidth() or arg_53_0.scroll_dir < 0 and arg_53_0.viewport.x < 0 then
			arg_53_0.scroll_dir = -arg_53_0.scroll_dir
		end
	end
	
	arg_53_0:updateScale()
	
	for iter_53_0, iter_53_1 in pairs(arg_53_0.data) do
		if get_cocos_refid(iter_53_1.field_layer) then
			iter_53_1.field_layer:updateViewport()
		end
	end
end

function FIELD_NEW.updateScale(arg_54_0)
	if arg_54_0.scale ~= arg_54_0.display_scale then
		local var_54_0 = 1
		local var_54_1 = arg_54_0.scale
		
		for iter_54_0, iter_54_1 in ipairs(arg_54_0.data) do
			iter_54_1.layer:setScale(var_54_0 + (var_54_1 - var_54_0) * iter_54_1.zoom_scale_ratio)
		end
		
		arg_54_0.display_scale = var_54_1
		
		if arg_54_0.main then
			arg_54_0.main.layer:setScale(var_54_1)
		end
	end
end

function FIELD_NEW.addOneLayer(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0
	local var_55_1
	local var_55_2
	
	if arg_55_3 then
		var_55_1 = FieldFloorLayer:create(arg_55_0, arg_55_2)
		var_55_2 = var_55_1:getContainer()
	else
		if not arg_55_2.spr then
			return 
		end
		
		var_55_0 = arg_55_2.roof_obj
		var_55_1 = FieldTilePropLayer:create(arg_55_0, arg_55_2)
		var_55_2 = var_55_1
	end
	
	var_55_1:setPositionX(arg_55_0.viewport.width * CAM_ANCHOR_X)
	var_55_1:setPositionY(arg_55_0.viewport.height * CAM_ANCHOR_Y)
	arg_55_1:addChild(var_55_1)
	
	local var_55_3 = arg_55_2 == nil
	local var_55_4 = arg_55_2.zoom_scale or 1
	local var_55_5
	
	if arg_55_2 then
		var_55_5 = arg_55_2.spr
	end
	
	local var_55_6 = {
		is_floor = arg_55_3,
		layer = var_55_2,
		field_layer = var_55_1,
		spr = var_55_5,
		zoom_scale_ratio = var_55_4,
		is_main_layer = var_55_3,
		roof_obj = var_55_0
	}
	
	if arg_55_2 ~= nil then
		table.insert(arg_55_0.data, var_55_6)
		
		if arg_55_3 then
			if var_55_1.object_layer then
				table.insert(arg_55_0.background_list, var_55_1.object_layer)
			end
		elseif arg_55_0.main then
			table.insert(arg_55_0.forground_list, var_55_2)
		else
			table.insert(arg_55_0.background_list, var_55_2)
		end
	end
	
	return var_55_6
end

DEBUG.BG_LOADMAP = {
	all = true
}

function FIELD_NEW.create(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	arg_56_4 = arg_56_4 or {}
	
	print("field create!  theme< " .. tostring(arg_56_1) .. " >.", arg_56_2)
	
	local var_56_0 = cc.Layer:create()
	
	var_56_0:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	var_56_0:setAnchorPoint(0, 0)
	var_56_0:setPosition(0, 0)
	
	local var_56_1 = su.SimplePostProcessLayer:create()
	local var_56_2 = cc.Director:getInstance():getWinSize()
	local var_56_3 = (var_56_2.width - DESIGN_WIDTH) / 2
	local var_56_4 = (var_56_2.height - DESIGN_HEIGHT) / 2
	
	var_56_1:setRenderTargetOffset(-1 * var_56_3, -1 * var_56_4)
	
	local var_56_5 = su.BatchedLayer:create()
	
	var_56_5:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_56_5:ignoreAnchorPointForPosition(true)
	var_56_5:setAnchorPoint(CAM_ANCHOR_X, CAM_ANCHOR_Y)
	var_56_5:setPosition(0, 0)
	var_56_5:setName("@field_game_layer")
	
	if DEBUG.DEBUG_BG then
		local var_56_6 = cc.LayerColor:create(cc.c3b(255, 0, 255))
		
		var_56_6:setGlobalZOrder(1)
		var_56_6:setOpacity(50)
		var_56_5:addChild(var_56_6)
	end
	
	var_56_1:addChild(var_56_5)
	var_56_0:addChild(var_56_1)
	
	local var_56_7 = arg_56_0:makeField(var_56_5, arg_56_1, arg_56_2 or VIEW_WIDTH, arg_56_3, arg_56_4)
	
	var_56_7.ppeffect_layer = var_56_1
	var_56_7.game_layer = var_56_5
	var_56_7.flip = arg_56_3
	
	var_56_7:updateViewport()
	
	if DEBUG.DEBUG_BG then
		local var_56_8 = make_viewport_rect(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.2, DESIGN_WIDTH, DESIGN_HEIGHT)
		
		var_56_5:addChild(var_56_8)
	end
	
	return var_56_0, var_56_7
end

function FIELD_NEW.isVisibleField(arg_57_0)
	if not arg_57_0.theme_name then
		return false
	end
	
	return not arg_57_0.field_hide
end

function FIELD_NEW.setForgroundOpacityByTag(arg_58_0, arg_58_1, arg_58_2)
	for iter_58_0, iter_58_1 in pairs(arg_58_0.forground_list) do
		iter_58_1:setOpacityByTag(arg_58_1, arg_58_2)
	end
end

function FIELD_NEW.setVisibleField(arg_59_0, arg_59_1, arg_59_2)
	if arg_59_1 == not arg_59_0.field_hide then
		return 
	end
	
	arg_59_0.field_hide = not arg_59_1
	
	local function var_59_0(arg_60_0, arg_60_1)
		for iter_60_0, iter_60_1 in pairs(arg_60_0.background_list) do
			iter_60_1:setVisible(arg_60_1)
		end
		
		arg_60_0:setForgroundOpacityByTag(arg_60_1 and 255 or 0, "bgshow")
		arg_60_0.main.layer:removeProtectedChildByTag(FIELD_TAG_DARK)
	end
	
	local function var_59_1(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
		local var_61_0 = GET_LAST_TICK()
		
		if arg_61_2 > var_61_0 - arg_61_3 then
			local var_61_1 = math.max(0, math.min(1, math.if_nan_or_inf((var_61_0 - arg_61_3) / arg_61_2, 0)))
			local var_61_2 = arg_61_1 and var_61_1 or 1 - var_61_1
			
			for iter_61_0, iter_61_1 in pairs(arg_61_0.background_list) do
				iter_61_1:setVisible(true)
			end
			
			arg_61_0:setForgroundOpacityByTag(var_61_2 * 255, "bgshow")
			
			if get_cocos_refid(arg_61_4) then
				arg_61_4:setOpacity(255 - var_61_2 * 255)
			end
		else
			Scheduler:remove(var_59_1)
			var_59_0(arg_61_0, arg_61_1)
		end
	end
	
	arg_59_2 = arg_59_2 or 0
	
	if arg_59_2 > 0 then
		local var_59_2 = arg_59_0.main.layer:getProtectedChildByTag(FIELD_TAG_DARK)
		
		if not var_59_2 then
			var_59_2 = get_curtain("bgshow")
			
			var_59_2:setColor(cc.c3b(0, 0, 0))
			var_59_2:setGlobalZOrder(-1000000)
			arg_59_0.main.layer:addProtectedChild(var_59_2, -999999999, FIELD_TAG_DARK)
		end
		
		var_59_2:setOpacity(arg_59_1 and 255 or 0)
		arg_59_0:setForgroundOpacityByTag(arg_59_1 and 0 or 255, "bgshow")
		Scheduler:add(arg_59_0.main.layer, var_59_1, arg_59_0, arg_59_1, arg_59_2, GET_LAST_TICK(), var_59_2)
	else
		var_59_0(arg_59_0, arg_59_1)
	end
end

function FIELD_NEW.setChangeAnimation(arg_62_0, arg_62_1)
	for iter_62_0, iter_62_1 in pairs(arg_62_0.forground_list) do
		for iter_62_2, iter_62_3 in pairs(iter_62_1:getChildren()) do
			for iter_62_4, iter_62_5 in pairs(iter_62_3:getChildren()) do
				arg_62_1(iter_62_5)
			end
		end
	end
	
	for iter_62_6, iter_62_7 in pairs(arg_62_0.background_list) do
		for iter_62_8, iter_62_9 in pairs(iter_62_7:getChildren()) do
			for iter_62_10, iter_62_11 in pairs(iter_62_9:getChildren()) do
				arg_62_1(iter_62_11)
			end
		end
	end
end
