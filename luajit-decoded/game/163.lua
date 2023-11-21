Combo = {}

function Combo.init(arg_1_0)
	arg_1_0.wnd = cc.CSLoader:createNode("wnd/combo.csb")
	
	arg_1_0.wnd:setScale(1)
	BattleField:addUIControl(arg_1_0.wnd)
	
	arg_1_0.cnt = 0
	arg_1_0.damage = 0
	arg_1_0.tick = LAST_UI_TICK
	arg_1_0.blood = arg_1_0.wnd:getChildByName("blood")
	
	arg_1_0.blood:setVisible(false)
	
	arg_1_0.combo = arg_1_0.wnd:getChildByName("combo")
	arg_1_0.num01 = arg_1_0.wnd:getChildByName("num01")
	arg_1_0.num02 = arg_1_0.wnd:getChildByName("num02")
	
	arg_1_0.wnd:setVisible(false)
	arg_1_0.wnd:setAnchorPoint(0, 0.5)
	arg_1_0.wnd:setPosition(VIEW_BASE_LEFT, DESIGN_HEIGHT * 0.8)
end

function Combo.resetCombo(arg_2_0)
	arg_2_0.cnt = 0
	arg_2_0.damage = 0
end

function Combo.addCombo(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0.cnt = arg_3_0.cnt + 1
	arg_3_0.damage = arg_3_0.damage + arg_3_1
	arg_3_0.tick = LAST_UI_TICK
	
	if arg_3_0.wnd == nil then
	end
	
	if arg_3_0.cnt < 2 then
		return 
	end
	
	local var_3_0 = arg_3_0.cnt % 10
	local var_3_1 = math.floor(arg_3_0.cnt / 10) % 10
	
	SpriteCache:resetSprite(arg_3_0.num01, "img/game_eff_dmg_p" .. var_3_0 .. "b.png")
	arg_3_0.num01:setScale(3)
	arg_3_0.num02:setVisible(var_3_1 > 0)
	
	local var_3_2 = TARGET(arg_3_0.num01, SEQ(DELAY(50), RESET_SPRITE(0, "img/game_eff_dmg_p" .. var_3_0 .. ".png", 1)))
	local var_3_3 = TARGET(arg_3_0.num02, SHOW(false))
	
	if var_3_1 > 0 then
		SpriteCache:resetSprite(arg_3_0.num02, "img/game_eff_dmg_p" .. var_3_1 .. "b.png")
		arg_3_0.num02:setScale(3)
		
		var_3_3 = TARGET(arg_3_0.num02, SEQ(SHOW(true), DELAY(50), RESET_SPRITE(0, "img/game_eff_dmg_p" .. var_3_1 .. ".png", 1)))
	end
	
	arg_3_0.wnd:setOpacity(255)
	UIAction:Remove("combo")
	UIAction:Add(SEQ(SHOW(true), SPAWN(var_3_2, var_3_3, TARGET(arg_3_0.blood, SEQ(SHOW(true), RESET_SPRITE(80, "img/ef_blood01.png"), RESET_SPRITE(80, "img/ef_blood02.png"), RESET_SPRITE(80, "img/ef_blood03.png"))), TARGET(arg_3_0.combo, SEQ(RESET_SPRITE(40, "img/game_eff_dmg_hits_b.png", 2.5), RESET_SPRITE(40, "img/game_eff_dmg_hits.png", 1))), SHAKE_UI(100, 10)), DELAY(500), FADE_OUT(500)), arg_3_0.wnd, "combo")
	arg_3_0.blood:setRotation(math.random(-10, 10))
	SpriteCache:resetSprite(arg_3_0.wnd:getChildByName("blood"), "ef_blood02.png")
end

function Combo.showTotalDamage(arg_4_0, arg_4_1)
	local var_4_0 = cc.Label:createWithBMFont("font/damage.fnt", "TOTAL DAMAGE")
	local var_4_1 = cc.Label:createWithBMFont("font/damage.fnt", arg_4_1)
	
	var_4_0:setColor(COLOR_CRI_FONT[1], COLOR_CRI_FONT[2])
	var_4_1:setColor(COLOR_CRI_FONT[1], COLOR_CRI_FONT[2])
	var_4_0:setAnchorPoint(0, 0)
	var_4_1:setAnchorPoint(0, 0)
	var_4_0:setScale(0.5)
	var_4_1:setScale(0.8)
	var_4_0:setPosition(90, DESIGN_HEIGHT * 0.58)
	var_4_1:setPosition(340, DESIGN_HEIGHT * 0.58)
	BGI.ui_layer:addChild(var_4_0)
	BGI.ui_layer:addChild(var_4_1)
	UIAction:Add(SEQ(DELAY(700), FADE_OUT(300)), var_4_0, "battle")
	UIAction:Add(WAVESTRING(true), var_4_1, "battle")
end
