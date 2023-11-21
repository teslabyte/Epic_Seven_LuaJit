G_VIDEO = nil
G_TEST_DOWN_pos = nil

function shadertool()
	SceneManager:nextScene("shadertool", {
		x = 1280,
		y = 720
	})
end

function testfile()
	SHADER_TOOL_FG_LAYER:removeAllChildren()
	
	local var_2_0 = "http://nas/sounds/ep3.mp4"
	local var_2_1 = cc.SpriteFrameCache:getInstance():getOrCreateSpriteFrame(var_2_0)
	local var_2_2 = cc.Sprite:createWithSpriteFrame(var_2_1)
	
	SHADER_TOOL_FG_LAYER:addChild(var_2_2)
end

function testfile2()
	print("error       ")
	SHADER_TOOL_FG_LAYER:removeAllChildren()
	
	local var_3_0 = "http://nas/sounds/ep3.mp4"
	local var_3_1 = create_movie_clip(var_3_0)
	
	SHADER_TOOL_FG_LAYER:addChild(var_3_1)
	var_3_1:seekTo(43)
	var_3_1:play()
	var_3_1:setVolume(0.5)
	
	G_VIDEO = var_3_1
	
	SHADER_TOOL_FG_LAYER:addChild(var_3_1)
end

function reload_shader()
	ShaderManager:loadShader()
end

Scene.shadertool = Scene.shadertool or SceneHandler:create("shadertool")

function Scene.shadertool.initKeyboard(arg_5_0)
	arg_5_0._KEY_MAP = {}
	
	if EFFECTTOOL_KEYBOARD_EVENT_LISTENER then
		return 
	end
	
	EFFECTTOOL_KEYBOARD_EVENT_LISTENER = cc.EventListenerKeyboard:create()
	
	EFFECTTOOL_KEYBOARD_EVENT_LISTENER:registerScriptHandler(function(arg_6_0, arg_6_1)
		local var_6_0 = SceneManager:getCurrentScene()
		
		if var_6_0 and var_6_0.onKeyReleased then
			var_6_0:onKeyReleased(arg_6_0, arg_6_1)
		end
	end, cc.Handler.EVENT_KEYBOARD_RELEASED)
	EFFECTTOOL_KEYBOARD_EVENT_LISTENER:registerScriptHandler(function(arg_7_0, arg_7_1)
		local var_7_0 = SceneManager:getCurrentScene()
		
		if var_7_0 and var_7_0.onKeyPressed then
			var_7_0:onKeyPressed(arg_7_0, arg_7_1)
		end
	end, cc.Handler.EVENT_KEYBOARD_PRESSED)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(EFFECTTOOL_KEYBOARD_EVENT_LISTENER, 1)
end

function Scene.shadertool.onLoad(arg_8_0)
	IS_TOOL_MODE = true
	
	cc.Director:getInstance():setDisplayStats(true)
	
	SHADER_TOOL_FG_LAYER = cc.LayerColor:create(cc.c3b(0, 0, 255))
	
	if false then
		SHADER_TOOL_FG_LAYER = cc.Layer:create()
	end
	
	arg_8_0.layer = SHADER_TOOL_FG_LAYER
	VARS.GAME_STARTED = true
	
	arg_8_0:initKeyboard()
	reload_db()
	reload_master_sound()
	ShaderManager:loadShader()
	
	SHADER_SCENE = arg_8_0
	
	print("error test 3 ")
end

function Scene.shadertool.touchTest(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = cc.Director:getInstance():getRunningScene()
	local var_9_1 = math.random() * VIEW_WIDTH
	local var_9_2 = math.random() * VIEW_HEIGHT
	
	do return  end
	
	if G_TEST_DOWN_pos then
		var_9_1 = G_TEST_DOWN_pos.x
		var_9_2 = G_TEST_DOWN_pos.y
	end
	
	local var_9_3 = ccui.Text:create()
	
	var_9_3:setPosition(var_9_1, var_9_2)
	var_9_3:setFontName("font/daum2.ttf")
	var_9_3:setFontSize(30)
	var_9_3:setColor(cc.c3b(255, 0, 0), cc.c3b(100, 0, 0))
	var_9_3:setString("ABCWyZ아하ABCWyZ아하ABCWyZ아하ABCWyZ아하")
	var_9_3:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	
	local var_9_4 = CACHE:getEffect("achates_heal_pati.particle", "effect")
	
	SHADER_TOOL_FG_LAYER:addChild(var_9_4)
	var_9_4:setPosition(G_TEST_DOWN_pos.x, G_TEST_DOWN_pos.y)
	var_9_4:setVisible(true)
	var_9_4:start()
end

function Scene.shadertool.onTouchDown(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2:stopPropagation()
	
	G_TEST_DOWN_pos = arg_10_1:getLocation()
	
	arg_10_0:touchTest(arg_10_1, arg_10_2)
end

function Scene.shadertool.onTouchMove(arg_11_0, arg_11_1, arg_11_2)
	arg_11_2:stopPropagation()
	
	local var_11_0 = arg_11_1:getLocation()
	
	if G_TEST_DOWN_pos and get_cocos_refid(G_TEST_EFFECT) then
		local var_11_1 = (var_11_0.x - G_TEST_DOWN_pos.x) * 0.0001
		
		G_TEST_EFFECT:setScale(math.min(10, math.max(0.1, G_TEST_EFFECT:getScale() + var_11_1)))
	end
end

function Scene.shadertool.onAfterDraw(arg_12_0)
end

function Scene.shadertool.test0(arg_13_0)
	local var_13_0 = ur.Model:create("model/cecilia2.scsp", "model/cecilia2.atlas", 1)
	
	var_13_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.1)
	var_13_0:setAnimation(0, "camping", true)
	SHADER_TOOL_FG_LAYER:addChild(var_13_0)
end

function Scene.shadertool.test1(arg_14_0)
	local var_14_0 = cc.LayerColor:create(cc.c3b(255, 0, 0))
	
	var_14_0:setContentSize(600, 200)
	var_14_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	var_14_0:setAnchorPoint(1, 0)
	var_14_0:ignoreAnchorPointForPosition(false)
	SHADER_TOOL_FG_LAYER:addChild(var_14_0)
end

function Scene.shadertool.test1_1(arg_15_0)
	local var_15_0 = {}
	local var_15_1 = su.HatchSprite:create()
	
	var_15_1:setContentSize(300, 200)
	
	local var_15_2 = cc.Director:getInstance():getTextureCache():addImage("effect/hatch_type_01.png")
	
	var_15_1:setTexture(var_15_2)
	var_15_1:setSpeed({
		var_15_0.speed0 or 10,
		var_15_0.speed1 or 7,
		var_15_0.speed2 or 8
	})
	var_15_1:setColors({
		tocolor(var_15_0.color0 or "255,214,95,255"),
		tocolor(var_15_0.color1 or "255,143,108,255"),
		tocolor(var_15_0.color2 or "186,55,34,127")
	})
	var_15_1:setAccTime(0)
	var_15_1:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	var_15_1:start()
	var_15_1:setVisible(true)
	SHADER_TOOL_FG_LAYER:addChild(var_15_1)
end

function Scene.shadertool.test2(arg_16_0)
end

function Scene.shadertool.test3(arg_17_0)
	print("error       ")
	SHADER_TOOL_FG_LAYER:removeAllChildren()
	
	local var_17_0 = create_movie_clip("cinema/event_02.mp4")
	
	SHADER_TOOL_FG_LAYER:addChild(var_17_0)
	var_17_0:seekTo(43)
	var_17_0:play()
	var_17_0:setVolume(0.5)
	
	G_VIDEO = var_17_0
end

function Scene.shadertool.test_ui(arg_18_0)
	local var_18_0 = cc.CSLoader:createNode("ui/rn_gauge_pollution.csb"):getChildByName("txt_num")
	
	var_18_0:setPosition(100, 100)
	var_18_0:setString("1234")
	
	local var_18_1 = cc.Sprite:create("face/npc1002_fu.png")
	
	SHADER_TOOL_FG_LAYER:addChild(var_18_1)
end

function Scene.shadertool.test4(arg_19_0)
	local function var_19_0(arg_20_0)
		local var_20_0 = cc.CSLoader:createNode("ui/" .. arg_20_0)
		
		var_20_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
		var_20_0:setAnchorPoint(0, 0)
		SHADER_TOOL_FG_LAYER:addChild(var_20_0)
		
		return var_20_0
	end
	
	g_test = {
		"rn_bhp.csb",
		"rn_hp.csb",
		"rn_bhp_big.csb",
		"rn_bhp_mid.csb",
		"rn_card_new.csb",
		"rn_automenu.csb",
		"rn_battle.csb",
		"rn_battle_minimap.csb",
		"rn_battle_pollution.csb",
		"rn_card_character.csb",
		"rn_collection.csb",
		"rn_combo.csb",
		"rn_entrance.csb",
		"rn_entrance_list.csb",
		"rn_entrance_new.csb",
		"rn_equip.csb",
		"rn_formation.csb",
		"rn_formation_1.csb",
		"rn_formation_2.csb",
		"rn_formation_3.csb",
		"rn_formation_new.csb",
		"rn_gauge_pollution.csb",
		"rn_hero.csb",
		"rn_hero_advance.csb",
		"rn_hero_buildup.csb",
		"rn_hero_deal.csb",
		"rn_hero_detail.csb",
		"rn_hero_equip.csb",
		"rn_hero_flag.csb",
		"rn_hero_formation.csb",
		"rn_hero_inventory.csb",
		"rn_hero_sell.csb",
		"rn_hero_statup.csb",
		"rn_hero_top.csb",
		"rn_hero_upgrade.csb",
		"rn_item_drop.csb"
	}
	
	if not g_index then
		g_index = 2
	else
		g_index = (g_index + 1) % #g_test
	end
	
	local var_19_1 = g_test[g_index + 1]
	
	var_19_0(var_19_1)
end

function Scene.shadertool.test5(arg_21_0)
	local var_21_0 = ccui.Text:create()
	
	var_21_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	var_21_0:setFontName("font/daum2.ttf")
	var_21_0:setFontSize(30)
	var_21_0:setColor(cc.c3b(255, 0, 0), cc.c3b(100, 0, 0))
	var_21_0:setString("ABCWyZ아하")
	var_21_0:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	SHADER_TOOL_FG_LAYER:addChild(var_21_0)
end

function Scene.shadertool.test6(arg_22_0)
	SpriteCache:load("cut/sk_10102_3.atlas")
	
	local var_22_0 = SpriteCache:getSprite("sk_10102_3_04")
	
	var_22_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	SHADER_TOOL_FG_LAYER:addChild(var_22_0)
end

function Scene.shadertool.test7(arg_23_0)
	local var_23_0 = {
		tocolor("255,0,0,255"),
		tocolor("255,143,108,255"),
		tocolor("186,55,34,127")
	}
	local var_23_1 = su.HatchSprite:create()
	
	var_23_1:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	
	local var_23_2 = cc.Director:getInstance():getTextureCache():addImage("effect/hatch_type_01.png")
	
	var_23_1:setTexture(var_23_2)
	var_23_1:setSpeed({
		9,
		19,
		-2
	})
	var_23_1:setColors(var_23_0)
	var_23_1:setColor(cc.c3b(255, 255, 255))
	var_23_1:setAccTime(0)
	var_23_1:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	var_23_1:setRotation(270)
	var_23_1:setScale(1)
	SHADER_TOOL_FG_LAYER:addChild(var_23_1)
	var_23_1:start()
end

function Scene.shadertool.onKeyPressed(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_1 == 27 or arg_24_1 == 26 then
		texture_next(arg_24_1 == 27)
	end
end

_CURRENT_VIEW_ATLAS = nil
_CURRENT_VIEW_LIST = {}
_CURRENT_VIEW_IDX = 1

function texture_next(arg_25_0)
	for iter_25_0 = 1, #_CURRENT_VIEW_LIST do
		local var_25_0 = _CURRENT_VIEW_LIST[iter_25_0]
		
		if get_cocos_refid(var_25_0) then
			var_25_0:setVisible(_CURRENT_VIEW_IDX == iter_25_0)
		end
	end
	
	if arg_25_0 then
		if _CURRENT_VIEW_IDX < #_CURRENT_VIEW_LIST then
			_CURRENT_VIEW_IDX = _CURRENT_VIEW_IDX + 1
		else
			_CURRENT_VIEW_IDX = 1
		end
	elseif _CURRENT_VIEW_IDX > 1 then
		_CURRENT_VIEW_IDX = _CURRENT_VIEW_IDX - 1
	else
		_CURRENT_VIEW_IDX = #_CURRENT_VIEW_LIST
	end
end

function texture_view(arg_26_0)
	if _CURRENT_VIEW_ATLAS == arg_26_0 then
		return 
	end
	
	SHADER_TOOL_FG_LAYER:removeAllChildren()
	
	_CURRENT_VIEW_ATLAS = arg_26_0
	_CURRENT_VIEW_LIST = {}
	_CURRENT_VIEW_IDX = 1
	
	local var_26_0 = SpriteCache:load(arg_26_0)
	
	for iter_26_0, iter_26_1 in pairs(var_26_0) do
		local var_26_1 = SpriteCache:getSprite(iter_26_1)
		
		if var_26_1 then
			local var_26_2 = cc.Node:create()
			local var_26_3 = ccui.Text:create()
			
			var_26_3:setPosition(0, 0)
			var_26_3:setFontName("font/daum.ttf")
			var_26_3:setFontSize(25)
			var_26_3:setColor(cc.c3b(255, 0, 0), cc.c3b(100, 0, 0))
			var_26_3:setString(iter_26_1)
			var_26_3:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			var_26_2:addChild(var_26_1)
			var_26_2:addChild(var_26_3)
			var_26_2:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			var_26_2:setVisible(false)
			table.insert(_CURRENT_VIEW_LIST, var_26_2)
			SHADER_TOOL_FG_LAYER:addChild(var_26_2)
			texture_next(true)
		end
	end
end

function Scene.shadertool.test8(arg_27_0)
	local var_27_0 = {
		{
			code = "cha10101"
		},
		{
			code = "cha10112"
		},
		{
			code = "cha10101"
		},
		{
			code = "cha10102"
		},
		{
			code = "cha10111"
		},
		{
			code = "cha10112"
		},
		{
			code = "cha10101"
		},
		{
			code = "cha10102"
		},
		{
			code = "cha10102"
		}
	}
	
	GachaPlayGround:show(var_27_0, var_27_0)
end

function Scene.shadertool.test9(arg_28_0)
	local var_28_0 = ccui.Scale9Sprite:create("img/battle_robby_thumbgrade.png")
	
	var_28_0:setState(1)
	var_28_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	SHADER_TOOL_FG_LAYER:addChild(var_28_0)
end

StateSprite = {}

function StateSprite.create(arg_29_0, arg_29_1)
	local var_29_0 = copy_functions(StateSprite, cc.Sprite:create())
	
	var_29_0.prefix = arg_29_1 or "dungeon_icon_"
	
	return var_29_0
end

function StateSprite.setState(arg_30_0, arg_30_1)
	SpriteCache:resetSprite(arg_30_0, arg_30_0.prefix .. arg_30_1 .. ".png")
end

function Scene.shadertool.test10(arg_31_0)
	local var_31_0 = (function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5, arg_32_6)
		local var_32_0 = su.HatchSprite:create()
		
		var_32_0:setContentSize(DESIGN_WIDTH + 200, DESIGN_HEIGHT)
		
		local var_32_1 = cc.Director:getInstance():getTextureCache():addImage("effect/hatch_type_01.png")
		
		var_32_0:setTexture(var_32_1)
		var_32_0:setSpeed({
			2,
			19,
			-2
		})
		var_32_0:setColors({
			tocolor("255,214,95,255"),
			tocolor("255,143,108,255"),
			tocolor("186,55,34,127")
		})
		var_32_0:setAccTime(0)
		var_32_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
		var_32_0:start()
		var_32_0:setVisible(true)
		
		return var_32_0
	end)()
	
	var_31_0:setOpacity(0)
	var_31_0:setScaleX(1)
	var_31_0:setScaleY(1)
	var_31_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	SHADER_TOOL_FG_LAYER:addChild(var_31_0)
end

function Scene.shadertool.test11(arg_33_0)
	SpriteCache:load("cut/sk_10118_3.atlas")
	
	local var_33_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_33_0:ignoreAnchorPointForPosition(false)
	var_33_0:setContentSize(568, 320)
	var_33_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	;(function(arg_34_0, arg_34_1, arg_34_2)
		local var_34_0 = SpriteCache:getSprite(arg_34_0)
		
		var_33_0:addChild(var_34_0)
		
		local var_34_1 = var_34_0:getContentSize().width / 2
		local var_34_2 = var_34_0:getContentSize().height / 2
		
		var_34_0:setPosition(var_34_1 + (arg_34_1 or 0), var_34_2 + (arg_34_2 or 0))
	end)("sk_10118_3_20", 0)
	SHADER_TOOL_FG_LAYER:addChild(var_33_0)
end

function Scene.shadertool.test12(arg_35_0)
	for iter_35_0 = 1, 1 do
		local var_35_0 = ur.Model:create("effect/kise_skill_03_2.scsp", "effect/kise_skill_03_2.atlas", 1)
		
		if var_35_0 then
			var_35_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			var_35_0:setScale(1)
			
			if var_35_0.setAnimation then
				var_35_0:setAnimation(0, "animation", true)
			end
			
			SHADER_TOOL_FG_LAYER:addChild(var_35_0)
			
			G_TEST_EFFECT = var_35_0
		end
	end
end

function play_shadertest_cut()
	local var_36_0 = "sk_10104_3"
	
	SpriteCache:playCut(SHADER_TOOL_FG_LAYER, "cut/" .. var_36_0 .. ".atlas", var_36_0 .. "_01", true, timing, true)
end

function Scene.shadertool.test13(arg_37_0)
end

local var_0_0 = 0.474
local var_0_1 = 0.7
local var_0_2 = 1.4
local var_0_3 = 3

function print_mapinfo()
	local var_38_0 = cc.Layer:create()
	
	var_38_0:setAnchorPoint(0, 0)
	var_38_0:setPosition(0, 0)
	
	local var_38_1 = cc.Sprite:create("ijera_1121.png")
	
	var_38_1:setAnchorPoint(0, 0)
	var_38_1:setPosition(0, 0)
	var_38_1:setScale(var_0_3)
	
	local var_38_2 = var_38_1:getContentSize()
	
	var_38_0:addChild(var_38_1)
	
	local var_38_3 = su.RoadSystem:create()
	local var_38_4 = cc.GLProgramCache:getInstance():getGLProgram("simple_shader")
	
	if var_38_4 then
		print(var_38_4, "program")
		var_38_3:setGLProgram(var_38_4)
	end
	
	var_38_3:setTexture(cc.TextureCache:getInstance():addImage("img/_bar_3.png"))
	var_38_3:setRoadWidth(15)
	var_38_3:setContentSize(var_38_2)
	var_38_3:setAnchorPoint(0, 0)
	var_38_3:setPosition(0, 0)
	
	local var_38_5 = {
		{
			x = 100,
			y = 100
		},
		{
			x = 100,
			y = 300
		},
		{
			x = 120,
			y = 150
		}
	}
	local var_38_6 = {}
	
	var_38_0:addChild(var_38_3)
	
	local var_38_7 = "ije"
	local var_38_8 = {}
	
	for iter_38_0 = 1, 999 do
		local var_38_9 = var_38_7 .. string.format("%03d", iter_38_0)
		local var_38_10, var_38_11, var_38_12, var_38_13, var_38_14, var_38_15, var_38_16, var_38_17, var_38_18, var_38_19 = DB("map", var_38_9, {
			"name",
			"lv",
			"x",
			"y",
			"local_icon",
			"desc",
			"req",
			"req_map_progress",
			"req_map_progress2",
			"sub",
			"quest1",
			"quest2",
			"quest3",
			"quest4"
		})
		
		if not var_38_10 then
			break
		end
		
		var_38_8[var_38_9] = {
			x = var_38_12,
			y = var_38_13,
			local_icon = var_38_14,
			req = var_38_16,
			req1 = var_38_17,
			req2 = var_38_18,
			sub = var_38_19,
			rel = {}
		}
	end
	
	for iter_38_1, iter_38_2 in pairs(var_38_8) do
		local var_38_20 = SpriteCache:getSprite(iter_38_2.local_icon .. ".png")
		local var_38_21 = {}
		
		var_38_21.x, var_38_21.y = iter_38_2.x * var_0_3, (var_38_2.height - iter_38_2.y) * var_0_3
		
		var_38_20:setPosition(var_38_21.x, var_38_21.y)
		var_38_20:setScale(MODEL_SCALE_FACTOR * TOWN_MAP_SCALE * var_0_2)
		var_38_0:addChild(var_38_20)
		
		local var_38_22 = var_38_8[iter_38_2.req1 or ""]
		
		print(iter_38_2.req, iter_38_2.req1, iter_38_2.req2)
		
		if var_38_22 then
			local var_38_23 = {}
			
			var_38_23.x, var_38_23.y = var_38_22.x * var_0_3, (var_38_2.height - var_38_22.y) * var_0_3
			
			var_38_3:addRoadPoint("name", {
				var_38_23,
				var_38_21,
				{
					x = 100,
					y = 300
				},
				{
					x = -100,
					y = -100
				}
			}, 20, iter_38_2.sub or 0)
		end
	end
	
	var_38_0:setScale(var_0_0)
	
	return var_38_0
end

function Scene.shadertool.test14(arg_39_0)
	G_TEST_EFFECT = CACHE:getEffect("stse_invincible")
	
	G_TEST_EFFECT:start()
	G_TEST_EFFECT:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT / 2)
	SHADER_TOOL_FG_LAYER:addChild(G_TEST_EFFECT)
end

function Scene.shadertool.test15(arg_40_0)
	local var_40_0 = ur.Model:create("effect/gacha_book.scsp", "effect/gacha_book.atlas", 1)
	
	var_40_0:setScaleFactor(0.46)
	var_40_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	local var_40_1 = var_40_0:setAnimation(0, "jam_on", false)
	
	var_40_0:update(math.random())
	var_40_0:setCascadeOpacityEnabled(true)
	var_40_0:setCascadeColorEnabled(true)
	
	local var_40_2 = cc.Sprite:create("img/_notification.png")
	
	var_40_0:getBoneNode("pivot"):addChild(var_40_2)
	
	local var_40_3 = cc.Sprite:create("img/_notification.png")
	
	var_40_0:getBoneNode("mover"):addChild(var_40_3)
	
	local var_40_4, var_40_5 = var_40_0:getBoneNode("mover"):getPosition()
	
	var_40_0.moverX = var_40_4
	var_40_0.moverY = var_40_5
	
	Action:Add(SEQ(DMOTION("intro", false), MOTION("loop", true)), var_40_0)
	SHADER_TOOL_FG_LAYER:addChild(var_40_0)
	
	G_BOOK = var_40_0
end

function Scene.shadertool.test16(arg_41_0)
	local var_41_0 = getTestBattle("c1005")
	
	UIBattleAttackOrder:init(SHADER_TOOL_FG_LAYER, var_41_0)
	UIBattleAttackOrder:show()
	UIBattleAttackOrder:play()
end

function Scene.shadertool.test17(arg_42_0)
	local var_42_0 = cc.Sprite:create("face/c1003_su.png")
	local var_42_1 = cc.GLProgramCache:getInstance():getGLProgram("sprite_mask")
	local var_42_2 = cc.Director:getInstance():getTextureCache():addImage("img/ch_frame_mask.png")
	
	if var_42_1 and var_42_2 then
		local var_42_3 = cc.GLProgramState:create(var_42_1)
		
		var_42_3:setUniformTexture("u_TexMask", var_42_2)
		var_42_0:setDefaultGLProgramState(var_42_3)
		var_42_0:setGLProgramState(nil)
	end
	
	SHADER_TOOL_FG_LAYER:addChild(var_42_0)
	var_42_0:setPosition(0, DESIGN_HEIGHT / 2)
	Action:Add(SEQ(DELAY(500), BEZIER(MOVE_TO(1500, DESIGN_WIDTH, DESIGN_HEIGHT / 2), {
		0,
		1,
		0,
		0.67
	}), CALL(function()
		print("fninished")
	end)), var_42_0)
end

function Scene.shadertool.test18(arg_44_0)
	local var_44_0 = UISoulBurnButton(nil, SHADER_TOOL_FG_LAYER)
	
	var_44_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_44_0:setVisible(true)
	Action:Add(SEQ(DELAY(5000), SHOW(false)), var_44_0)
end

function Scene.shadertool.test19(arg_45_0)
	local var_45_0 = cc.Sprite:create("face/c1003_su.png")
	local var_45_1 = cc.GLProgramCache:getInstance():getGLProgram("sprite_mask")
	local var_45_2 = cc.Director:getInstance():getTextureCache():addImage("img/ch_frame_mask.png")
	
	if var_45_1 and var_45_2 then
		local var_45_3 = cc.GLProgramState:create(var_45_1)
		
		var_45_3:setUniformTexture("u_TexMask", var_45_2)
		var_45_0:setDefaultGLProgramState(var_45_3)
		var_45_0:setGLProgramState(nil)
	end
	
	var_45_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	SHADER_TOOL_FG_LAYER:addChild(var_45_0)
end

function test_cinema()
	SceneManager:nextScene("cinema", {
		path = "cinema/event_02.mp4",
		callback = function()
			SceneManager:nextScene("shadertool")
		end
	})
end

function stop_book(arg_48_0)
	local var_48_0 = G_BOOK:getCurrent()
	
	var_48_0.timeScale = -5
	var_48_0.loop = false
	
	print(var_48_0.endTime)
	
	do return  end
	
	local var_48_1, var_48_2 = G_BOOK:getBoneNode("mover"):getPosition()
	
	print(G_BOOK.moverY, var_48_2)
	
	local var_48_3 = (var_48_2 - G_BOOK.moverY) * G_BOOK:getRealScaleY()
	
	print(var_48_3)
	G_BOOK:setPosition(DESIGN_WIDTH / 2 + (var_48_1 - G_BOOK.moverX), DESIGN_HEIGHT / 2 - var_48_3)
	G_BOOK:setAnimation(0, "jam_on", true)
	G_BOOK:update(math.random())
	table.print(var_48_0)
end

function resume_book()
	G_BOOK:setAnimation(0, "loop", true)
end

function p_book()
	print(G_BOOK:getBonePosition("mover"))
end

function build_listitem()
	math.randomseed(120931)
	
	local var_51_0 = {}
	
	for iter_51_0 = 1, 30 do
		local var_51_1 = {
			title = iter_51_0,
			items = {}
		}
		local var_51_2 = items
		
		math.random(5, 40)
		
		for iter_51_1 = 1, var_51_2 do
			table.insert(var_51_1.items, iter_51_1)
		end
		
		table.insert(var_51_0, var_51_1)
	end
end

function Scene.shadertool.test20(arg_52_0)
	local function var_52_0(arg_53_0)
		local var_53_0 = arg_53_0:clone()
		
		var_53_0:addEventListener(function()
			print(1)
		end)
		
		return var_53_0
	end
	
	local var_52_1 = ccui.HBox:create({
		width = 600,
		height = 80
	})
	local var_52_2 = ccui.Widget:create()
	local var_52_3 = load_control("wnd/unit_bar.csb")
	
	var_52_3:setVisible(true)
	var_52_2:setContentSize(var_52_3:getContentSize())
	var_52_2:addChild(var_52_3)
	var_52_1:addChild(var_52_2:clone())
	var_52_1:addChild(var_52_2:clone())
	var_52_1:addChild(var_52_2:clone())
	
	local var_52_4 = load_control("wnd/dict_header.csb")
	local var_52_5 = ccui.ScrollViewContentContainer:create()
	
	var_52_5:registerScriptHandler(function(arg_55_0, arg_55_1, arg_55_2)
		print("registerScriptHandler", arg_55_0, arg_55_1, arg_55_2)
	end)
	var_52_5:setContentSize(var_52_4:getContentSize())
	var_52_5:addChild(var_52_4)
	
	local var_52_6 = ccui.VBox:create({
		width = 600,
		height = DESIGN_HEIGHT / 2
	})
	
	var_52_6:addChild(var_52_5:clone())
	var_52_6:addChild(var_52_1:clone())
	var_52_6:addChild(var_52_1:clone())
	var_52_6:addChild(var_52_1:clone())
	
	local var_52_7 = ccui.ScrollView:create()
	
	var_52_7:setContentSize({
		width = 600,
		height = DESIGN_HEIGHT
	})
	var_52_7:setInnerContainerSize({
		width = 600,
		height = DESIGN_HEIGHT * 2
	})
	
	local var_52_8 = var_52_7:getInnerContainer()
	
	var_52_8:setLayoutType(1)
	var_52_8:setBackGroundColorType(1)
	var_52_8:setBackGroundColor(cc.c3b(255, 0, 255))
	var_52_8:addChild(var_52_6:clone())
	var_52_8:addChild(var_52_6:clone())
	var_52_7:setBounceEnabled(true)
	SHADER_TOOL_FG_LAYER:addChild(var_52_7)
end

function Scene.shadertool.test21(arg_56_0)
	local var_56_0 = cc.CSLoader:createNode("base/_examples.csb")
	local var_56_1 = ccui.Widget:create()
	
	var_56_1:setTouchEnabled(true)
	var_56_1:setContentSize({
		width = 300,
		height = 80
	})
	var_56_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_56_1:addChild(var_56_0)
	SHADER_TOOL_FG_LAYER:addChild(var_56_1:clone())
end

function Scene.shadertool.test22(arg_57_0)
	SCROLL_CONTENT = ccui.Widget:create()
	
	local var_57_0 = load_control("wnd/dict_header.csb")
	
	SCROLL_CONTENT:addChild(var_57_0)
	SCROLL_CONTENT:setContentSize(var_57_0:getContentSize())
	
	local var_57_1 = ccui.VBox:create({
		width = 600,
		height = DESIGN_HEIGHT / 2
	})
	
	var_57_1:addChild(cloneNode(SCROLL_CONTENT))
	var_57_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	SHADER_TOOL_FG_LAYER:addChild(var_57_1)
	SHADER_TOOL_FG_LAYER:addChild(SCROLL_CONTENT:clone())
end

function Scene.shadertool.test23(arg_58_0)
	SoundEngine:createEvent("event:/battle/levelup"):start()
end

function Scene.shadertool.test24(arg_59_0)
	TEST_NODE = cc.Node:create()
	
	TEST_NODE:retain()
	
	local var_59_0 = cc.Node:create()
	
	var_59_0:retain()
	cc.PoolManager:getDefaultPool():addObjectWithTarget(var_59_0, TEST_NODE)
	
	local var_59_1 = cc.Node:create()
	
	var_59_1:retain()
	cc.PoolManager:getDefaultPool():addObjectWithTarget(var_59_1, TEST_NODE)
	
	local var_59_2 = cc.Node:create()
	
	var_59_2:retain()
	cc.PoolManager:getDefaultPool():addObjectWithTarget(var_59_2, TEST_NODE)
end

function Scene.shadertool.test25(arg_60_0)
	local var_60_0 = {
		width = 600,
		height = 400
	}
	local var_60_1 = ccui.ScrollView:create()
	
	SHADER_TOOL_FG_LAYER:addChild(var_60_1)
	var_60_1:setBounceEnabled(true)
	var_60_1:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	var_60_1:setBackGroundColor(cc.c3b(255, 0, 0))
	var_60_1:setContentSize(var_60_0.width, var_60_0.height)
	var_60_1:setAnchorPoint(0.5, 0.5)
	var_60_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_60_1:setLayoutType(ccui.LayoutType.TILED_VERTICAL)
	
	local var_60_2 = load_control("wnd/unit_bar.csb")
	local var_60_3 = ccui.Widget:create()
	
	var_60_3:setAnchorPoint(0, 0)
	var_60_3:setContentSize(var_60_2:getContentSize())
	var_60_3:addChild(var_60_2)
	
	local var_60_4 = load_control("wnd/dict_header.csb")
	local var_60_5 = ccui.Widget:create()
	
	var_60_5:setAnchorPoint(0, 0)
	var_60_5:setContentSize(var_60_4:getContentSize())
	var_60_5:addChild(var_60_4)
	
	local var_60_6 = {
		[3] = true,
		[9] = true
	}
	
	for iter_60_0 = 1, 14 do
		if var_60_6[iter_60_0] then
			var_60_1:addChild(var_60_5:clone())
		else
			var_60_1:addChild(var_60_3:clone())
		end
	end
	
	do return  end
	
	for iter_60_1 = 1, 19 do
		local var_60_7 = var_60_3:clone()
		
		var_60_7:registerScriptHandler(function(arg_61_0, arg_61_1, arg_61_2)
			print("item:registerScriptHandler", arg_61_0, arg_61_1, arg_61_2)
		end)
		var_60_1:addChild(var_60_7)
		
		if iter_60_1 == 5 or iter_60_1 == 9 or iter_60_1 == 13 then
			var_60_1:addChild(var_60_5:clone())
		end
	end
	
	do return  end
	
	local var_60_8 = TableView:create("dict_header", "unit_bar")
	
	SHADER_TOOL_FG_LAYER:addChild(var_60_8)
	
	do return  end
	
	if not g_TBL_SCOPE_TEST then
		g_TBL_SCOPE_TEST = {}
	end
	
	local var_60_9 = "test_item"
	
	g_TBL_SCOPE_TEST[1] = var_60_9
	TEST_NODE = cc.LuaScope:new(var_60_9, g_TBL_SCOPE_TEST)
	
	TEST_NODE:retain()
	
	local var_60_10 = cc.ScrollView:create()
	local var_60_11 = cc.Node:create()
	
	var_60_11:retain()
	AutoreleasePool:addObjectWithTarget(var_60_11, var_60_10)
	
	if not g_TBL_SCOPE_TEST then
		g_TBL_SCOPE_TEST = {}
	end
	
	local var_60_12 = {
		id = "test_item"
	}
	
	table.insert(g_TBL_SCOPE_TEST, var_60_12)
	
	g_TBL_SCOPE_TEST[1] = var_60_12
	
	local var_60_13 = SceneManager:getRunningNativeScene()
	local var_60_14 = {
		id = "test_item"
	}
	
	table.insert(g_TBL_SCOPE_TEST, var_60_14)
	
	g_TBL_SCOPE_TEST[1] = var_60_14
	
	local var_60_15 = cc.LuaScope:new(var_60_14, g_TBL_SCOPE_TEST)
	
	node:setUserObject(var_60_15)
	AutoreleasePool:addObjectWithTarget(var_60_15, var_60_13)
end

function Scene.shadertool.test26(arg_62_0)
	local var_62_0 = load_control("wnd/dict_header.csb")
	local var_62_1 = ccui.Widget:create()
	
	var_62_1:setColor(cc.c3b(255, 255, 0))
	var_62_1:setContentSize(var_62_0:getContentSize())
	var_62_1:addChild(var_62_0)
	
	local var_62_2 = {
		width = 600,
		height = 400
	}
	local var_62_3 = ccui.GroupView:create()
	
	var_62_3:setBounceEnabled(true)
	var_62_3:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	var_62_3:setBackGroundColor(cc.c3b(255, 0, 0))
	var_62_3:setAnchorPoint(0.5, 0.5)
	var_62_3:setContentSize(var_62_2.width, var_62_2.height)
	var_62_3:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_62_3:setGroupHeaderModel(var_62_1)
	SHADER_TOOL_FG_LAYER:addChild(var_62_3)
	
	local var_62_4 = load_control("wnd/unit_bar.csb")
	local var_62_5 = ccui.Widget:create()
	
	var_62_5:setAnchorPoint(0, 0)
	var_62_5:setContentSize(var_62_4:getContentSize())
	var_62_5:addChild(var_62_4)
	
	for iter_62_0 = 1, 20 do
		local var_62_6 = var_62_3:addGroup()
		
		var_62_6:addChild(var_62_5:clone())
		var_62_6:addChild(var_62_5:clone())
		var_62_6:addChild(var_62_5:clone())
		var_62_6:addChild(var_62_5:clone())
		var_62_6:addChild(var_62_5:clone())
	end
	
	do return  end
	
	for iter_62_1 = 1, 20 do
		local var_62_7 = var_62_3:addGroup()
		
		var_62_7:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
		var_62_7:setBackGroundColor(cc.c3b(255, 255, 0))
	end
end

function Scene.shadertool.test27(arg_63_0)
	local var_63_0 = UIMiniCutin(SHADER_TOOL_FG_LAYER)
	
	var_63_0:setMode("helper")
	var_63_0:show()
end

function Scene.shadertool.test28(arg_64_0)
	local var_64_0 = su.ViewportLayer:createWithProjection(0)
	
	var_64_0:setAnchorPoint(0, 0)
	
	local var_64_1 = "@EFFECTTOOL_SCREEN_GRID"
	local var_64_2 = DESIGN_WIDTH * 2
	
	gridPanelCtrl = cc.DrawNode:create()
	
	local var_64_3 = {
		{
			y = 0,
			x = -var_64_2
		},
		{
			y = 0,
			x = -var_64_2
		},
		{
			y = 0,
			x = var_64_2
		},
		{
			0,
			x = var_64_2
		}
	}
	local var_64_4 = {
		{
			x = 0,
			y = -var_64_2
		},
		{
			x = 0,
			y = -var_64_2
		},
		{
			x = 0,
			y = var_64_2
		},
		{
			x = 0,
			y = var_64_2
		}
	}
	local var_64_5 = 0
	local var_64_6 = 0
	local var_64_7 = 2000
	local var_64_8 = 100
	
	for iter_64_0 = var_64_8, var_64_7, var_64_8 do
		gridPanelCtrl:drawLine(cc.p(var_64_5 + iter_64_0, -var_64_7), cc.p(var_64_5 + iter_64_0, var_64_7), cc.c4f(1, 1, 0, 1))
		gridPanelCtrl:drawLine(cc.p(var_64_5 - iter_64_0, -var_64_7), cc.p(var_64_5 - iter_64_0, var_64_7), cc.c4f(1, 1, 0, 1))
		gridPanelCtrl:drawLine(cc.p(-var_64_7, var_64_6 + iter_64_0), cc.p(var_64_7, var_64_6 + iter_64_0), cc.c4f(1, 1, 0, 1))
		gridPanelCtrl:drawLine(cc.p(-var_64_7, var_64_6 - iter_64_0), cc.p(var_64_7, var_64_6 - iter_64_0), cc.c4f(1, 1, 0, 1))
	end
	
	gridPanelCtrl:drawLine(cc.p(var_64_5, -var_64_7), cc.p(var_64_5, var_64_7), cc.c4f(1, 0, 1, 1))
	gridPanelCtrl:drawLine(cc.p(-var_64_7, var_64_6), cc.p(var_64_7, var_64_6), cc.c4f(1, 0, 1, 1))
	print(" ==================================== position ================================ ")
	gridPanelCtrl:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	gridPanelCtrl:setGlobalZOrder(1000)
	gridPanelCtrl:setLineWidth(3)
	var_64_0:addProtectedChild(gridPanelCtrl)
	
	local var_64_9 = cc.Sprite:create("system/default/crosshair.png")
	
	var_64_0:addProtectedChild(var_64_9)
	var_64_0:setScale(1.5)
	SHADER_TOOL_FG_LAYER:addChild(var_64_0)
end

function Scene.shadertool.test30(arg_65_0)
	local var_65_0 = CACHE:getModel({
		model_opt = "dreamer_leech_fire.opt",
		model_id = "model/dreamer_leech_fire.scsp"
	})
	
	var_65_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	SHADER_TOOL_FG_LAYER:addChild(var_65_0)
	var_65_0:setAnimation(0, "idle", false)
	
	g_model = var_65_0
end

function Scene.shadertool.test31(arg_66_0)
	local var_66_0 = CACHE:getModel("model/chaosgate.scsp")
	
	var_66_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT * 0.5)
	SHADER_TOOL_FG_LAYER:addChild(var_66_0)
	var_66_0:setAnimation(0, "animation", true)
	
	g_model = var_66_0
end

function Scene.shadertool.test32(arg_67_0)
	GAME_LAYER = su.SimplePostProcessLayer:create()
	
	local var_67_0 = cc.Sprite:create("img/shop_product_penguin_b.png")
	
	var_67_0:setScale(2)
	var_67_0:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
	GAME_LAYER:addChild(var_67_0)
	
	local var_67_1 = cc.GLProgramCache:getInstance():getGLProgram("sprite_grayscale")
	
	if var_67_1 then
		local var_67_2 = cc.GLProgramState:create(var_67_1)
		
		if var_67_2 then
			var_67_2:setUniformVec2("u_resolution", {
				x = VIEW_WIDTH,
				y = VIEW_HEIGHT
			})
			var_67_2:setUniformVec2("u_direction", {
				x = 1,
				y = 0
			})
			var_67_2:setUniformFloat("u_range", 20)
			var_67_2:setUniformFloat("u_sample", 3)
			var_67_2:setUniformFloat("u_ratio", 0.3)
			GAME_LAYER:setPostProcessEnabled(true)
			GAME_LAYER:addProcessGLProgramState(var_67_2, "", 5, 0)
		end
	end
	
	local var_67_3 = cc.GLProgramCache:getInstance():getGLProgram("sprite_blur")
	
	if var_67_3 then
		local var_67_4 = cc.GLProgramState:create(var_67_3)
		
		if var_67_4 then
			var_67_4:setUniformVec2("u_resolution", {
				x = VIEW_WIDTH,
				y = VIEW_HEIGHT
			})
			var_67_4:setUniformVec2("u_direction", {
				x = 1,
				y = 0
			})
			var_67_4:setUniformFloat("u_range", 20)
			var_67_4:setUniformFloat("u_sample", 3)
			var_67_4:setUniformFloat("u_ratio", 0.3)
			GAME_LAYER:setPostProcessEnabled(true)
			GAME_LAYER:addProcessGLProgramState(var_67_4, "", 5, 0)
		end
	end
	
	SHADER_TOOL_FG_LAYER:addChild(GAME_LAYER)
end

function Scene.shadertool.test33(arg_68_0)
	print("test33()")
	
	local var_68_0 = su.createSpecialLayer("BlendAligmentLayer")
	
	BattleAction:Add(LOOP(SEQ(DELAY(10), CALL(function()
		EffectManager:Play({
			scale = 0.5,
			fn = "hit_new_blunt_normal.cfx",
			x = math.random(0, VIEW_WIDTH * 0.4),
			y = math.random(VIEW_HEIGHT * 0.4, VIEW_HEIGHT * 0.6),
			layer = var_68_0
		})
	end))), SHADER_TOOL_FG_LAYER)
	SHADER_TOOL_FG_LAYER:addChild(var_68_0)
end

function Scene.shadertool.test33(arg_70_0)
	g_model = CACHE:getModel("model/godess.scsp", nil, "blue")
	
	g_model:setPosition(VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.25)
	g_model:setVisible(false)
	SHADER_TOOL_FG_LAYER:addChild(g_model)
end

function Scene.shadertool.test34(arg_71_0)
	cc.AniSprite:createAsync("https://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp", function(arg_72_0)
		arg_72_0:setPosition(DESIGN_WIDTH * 0.1, DESIGN_HEIGHT / 2)
		arg_72_0:setLoop(true)
		arg_72_0:play()
		SHADER_TOOL_FG_LAYER:addChild(arg_72_0)
	end)
	cc.Sprite:createAsync("https://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp", function(arg_73_0)
		arg_73_0:setPosition(DESIGN_WIDTH * 0.3, DESIGN_HEIGHT / 2)
		SHADER_TOOL_FG_LAYER:addChild(arg_73_0)
	end)
	cc.AniSprite:createAsync("https://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp", function(arg_74_0)
		arg_74_0:setPosition(DESIGN_WIDTH * 0.5, DESIGN_HEIGHT / 2)
		arg_74_0:setLoop(true)
		arg_74_0:play()
		SHADER_TOOL_FG_LAYER:addChild(arg_74_0)
	end)
	cc.Sprite:createAsync("https://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp", function(arg_75_0)
		arg_75_0:setPosition(DESIGN_WIDTH * 0.6, DESIGN_HEIGHT / 2)
		SHADER_TOOL_FG_LAYER:addChild(arg_75_0)
	end)
	cc.AniSprite:createAsync("https://res.cloudinary.com/demo/image/upload/fl_awebp/bored_animation.webp", function(arg_76_0)
		arg_76_0:setPosition(DESIGN_WIDTH * 0.8, DESIGN_HEIGHT / 2)
		arg_76_0:setLoop(true)
		arg_76_0:play()
		SHADER_TOOL_FG_LAYER:addChild(arg_76_0)
	end)
end

function Scene.shadertool.test35(arg_77_0)
	local var_77_0 = sp.SkeletonAnimation:create("portrait/c1001.scsp", "portrait/c1001.atlas", 1)
	
	var_77_0:setPosition(DESIGN_WIDTH / 2, -100)
	SHADER_TOOL_FG_LAYER:addChild(var_77_0)
end

function test_snd()
	Thread("test_thread", function()
		for iter_79_0 = 1, 100 do
			coroutine.yield()
			SoundEngine:createEvent("event:/battle/levelup"):start()
		end
	end)
end

function test_ani()
	if g_model then
		g_model:setAnimation(0, "destroy", false)
	end
end

g_FACESPRITE = {}
g_FACEIMAGE = {}
g_FACEINDEX = 0

function test_spr(arg_81_0)
	if table.empty(g_FACEIMAGE) then
		local var_81_0 = cc.FileUtils:getInstance():fullPathForFilename("face.txt")
		
		for iter_81_0 in io.lines(var_81_0) do
			table.insert(g_FACEIMAGE, "face/" .. iter_81_0)
		end
		
		table.print(g_FACEIMAGE)
		
		g_FACEIMAGE = {}
		
		for iter_81_1 = 1, 9 do
			g_FACEIMAGE[iter_81_1] = string.format("test/%d.png", iter_81_1)
		end
	end
	
	g_FACEINDEX = arg_81_0 or g_FACEINDEX % #g_FACEIMAGE + 1
	
	print("DEBUG  face ++ ", g_FACEINDEX, g_FACEIMAGE[g_FACEINDEX])
	
	local var_81_1 = SpriteCache:getSprite(g_FACEIMAGE[g_FACEINDEX])
	
	g_FACESPRITE[g_FACEINDEX] = var_81_1
	
	var_81_1:setPosition(DESIGN_WIDTH * 0.5 * math.random() + DESIGN_WIDTH / 2, DESIGN_HEIGHT * 0.5 * math.random() + DESIGN_HEIGHT / 2)
	SHADER_TOOL_FG_LAYER:addChild(var_81_1)
	var_81_1:setScale(0.5)
	
	if g_FACEINDEX > 5 then
		cc.Director:getInstance():setAnimationInterval(0.5)
		g_FACESPRITE[1]:setTag(10000)
		g_FACESPRITE[1]:setColor(cc.c3b(255, 0, 0))
	end
end

function sqlite3_test()
	local var_82_0 = cc.FileUtils:getInstance():getWritablePath() .. "/userid.mbox"
	local var_82_1 = string.char(243, 37, 25, 82, 92, 238, 239, 22, 39, 107, 185, 92, 207, 96, 237, 78)
	local var_82_2 = AES256_ECB_encrypt(var_82_1, string.format("%16u", 1234))
	
	if not SQLITEDB then
		SQLITEDB = sqlite3.open(var_82_0)
		
		SQLITEDB:key(var_82_2)
		assert(SQLITEDB:exec("CREATE TABLE test (col1, col2)"))
	end
	
	local var_82_3 = SQLITEDB:prepare("INSERT INTO test VALUES ( ? ,? )")
	
	for iter_82_0 = 1, 1 do
		var_82_3:bind_values(math.random(), "INSERT INTO test VALUES ( ? ,? )")
		var_82_3:step()
		var_82_3:reset()
	end
	
	print(" 1 ")
	
	for iter_82_1 in SQLITEDB:rows("SELECT *FROM test order by col1 LIMIT 3 ") do
		table.print(iter_82_1)
	end
end

function __G__DESTROY_STACK__()
end
