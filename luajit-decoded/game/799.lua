RumbleUnitHUD = {}

function RumbleUnitHUD.create(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_1 then
		return 
	end
	
	if type(arg_1_0.loadControl) ~= "function" then
		return 
	end
	
	local var_1_0 = arg_1_0:loadControl()
	
	if not get_cocos_refid(var_1_0) then
		return 
	end
	
	copy_functions(arg_1_0, var_1_0)
	
	local var_1_1 = RumbleSystem:getFieldUILayer()
	
	if get_cocos_refid(var_1_1) then
		var_1_1:addChild(var_1_0)
	end
	
	var_1_0:setCascadeOpacityEnabled(true)
	
	var_1_0.unit = arg_1_1
	
	if type(var_1_0.onCreate) == "function" then
		var_1_0:onCreate(arg_1_2)
	end
	
	return var_1_0
end

function RumbleUnitHUD.update(arg_2_0, arg_2_1)
	if type(arg_2_0.onUpdate) == "function" then
		arg_2_0:onUpdate(arg_2_1)
	end
	
	if type(arg_2_0.getDisplayPos) == "function" then
		local var_2_0, var_2_1 = arg_2_0:getDisplayPos()
		
		if var_2_0 and var_2_1 then
			arg_2_0:setPosition(var_2_0, var_2_1)
		end
	end
end

RumbleUnitGauge = {}

copy_functions(RumbleUnitHUD, RumbleUnitGauge)

function RumbleUnitGauge.loadControl(arg_3_0)
	local var_3_0 = load_control("wnd/hp_bar_r.csb")
	
	var_3_0:setAnchorPoint(0.5, 0.5)
	
	return var_3_0
end

function RumbleUnitGauge.onCreate(arg_4_0)
	if not arg_4_0.unit then
		return 
	end
	
	arg_4_0.hp = arg_4_0:getChildByName("hp")
	arg_4_0.sp = arg_4_0:getChildByName("sp")
	arg_4_0.sh = arg_4_0:getChildByName("sh")
	arg_4_0.hp_red = arg_4_0:getChildByName("hp_red")
	arg_4_0.n_hpmark = arg_4_0:getChildByName("n_hpmark")
	arg_4_0.n_buff = arg_4_0:getChildByName("n_buff")
	
	arg_4_0:getChildByName("n_shield"):bringToFront()
	
	arg_4_0.BAR_SIZE = arg_4_0.hp:getContentSize()
	arg_4_0.bar_render_scale = 1
	
	if arg_4_0.unit:isEnemy() then
		if_set_sprite(arg_4_0.hp, nil, "img/game_hud_bar_hp_pur.png")
	end
	
	arg_4_0:updateAll()
	arg_4_0:resetMarks()
end

function RumbleUnitGauge.updateAll(arg_5_0)
	arg_5_0:updateHP()
	arg_5_0:updateSP()
	arg_5_0:resetBuffIcon()
end

function RumbleUnitGauge.updateHP(arg_6_0)
	if not arg_6_0.unit then
		return 
	end
	
	local var_6_0 = arg_6_0.unit:getHPRatio()
	local var_6_1 = arg_6_0.unit:getShieldRatio()
	local var_6_2 = 1
	
	if get_cocos_refid(arg_6_0.hp) then
		arg_6_0.hp:setScaleX(var_6_0)
	end
	
	if get_cocos_refid(arg_6_0.sh) then
		arg_6_0.sh:setScaleX(var_6_1)
		
		if var_6_0 + var_6_1 > 1 then
			local var_6_3 = arg_6_0.unit:getMaxHp()
			
			var_6_2 = var_6_3 / (var_6_3 + arg_6_0.unit:getShield())
			
			arg_6_0.sh:setPositionX(-arg_6_0.BAR_SIZE.width * var_6_1)
		else
			arg_6_0.sh:setPositionX(arg_6_0.BAR_SIZE.width * var_6_0 - arg_6_0.BAR_SIZE.width)
		end
	end
	
	if arg_6_0.bar_render_scale ~= var_6_2 then
		arg_6_0.bar_render_scale = var_6_2
		
		arg_6_0:resetMarks()
	end
	
	if get_cocos_refid(arg_6_0.hp_red) then
		local var_6_4 = arg_6_0.hp_red:getScaleX()
		
		BattleUIAction:Remove(arg_6_0.hp_red)
		BattleUIAction:Add(SEQ(DELAY(600), LOG(SCALEX(800, var_6_4, var_6_0))), arg_6_0.hp_red, "rumble")
	end
end

function RumbleUnitGauge.resetMarks(arg_7_0)
	if not get_cocos_refid(arg_7_0.n_hpmark) then
		return 
	end
	
	arg_7_0.n_hpmark:removeAllChildren()
	
	local var_7_0 = 25
	
	if arg_7_0.bar_render_scale > 0.51 then
		var_7_0 = 10
	elseif arg_7_0.bar_render_scale > 0.25 then
		var_7_0 = 12.5
	end
	
	HPBar:addMarks(arg_7_0.BAR_SIZE.width * arg_7_0.bar_render_scale, arg_7_0.n_hpmark, 100, var_7_0, 50, 0.9, 0)
end

function RumbleUnitGauge.updateSP(arg_8_0)
	if not arg_8_0.unit then
		return 
	end
	
	if get_cocos_refid(arg_8_0.sp) then
		arg_8_0.sp:setScaleX(arg_8_0.unit:getSPRatio())
	end
end

function RumbleUnitGauge.getDisplayPos(arg_9_0)
	if not arg_9_0.unit then
		return 
	end
	
	local var_9_0 = arg_9_0.unit:getUnitNode()
	local var_9_1 = arg_9_0.unit:getModel()
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	local var_9_2 = SceneManager:convertToSceneSpace(var_9_0, {
		x = 0,
		y = 0
	})
	
	if not get_cocos_refid(var_9_1) then
		return var_9_2.x, var_9_2.y
	end
	
	local var_9_3, var_9_4 = var_9_1:getBonePosition("top")
	local var_9_5 = 0
	
	return var_9_2.x, var_9_2.y + (var_9_4 + var_9_5) * RumbleCamera:getCameraScale()
end

function RumbleUnitGauge.dead(arg_10_0)
	if_set_visible(arg_10_0, "hp", false)
	if_set_visible(arg_10_0, "sp", false)
	UIAction:Add(SEQ(FADE_OUT(1000), REMOVE()), arg_10_0)
end

local function var_0_0(arg_11_0)
	return string.format("buff/stic_%s.png", arg_11_0)
end

local function var_0_1(arg_12_0, arg_12_1)
	if (arg_12_0.state or 0) == arg_12_1 then
		return 
	end
	
	arg_12_0.state = arg_12_1
	
	if arg_12_1 == 1 then
		arg_12_0:setOpacity(255)
	elseif arg_12_1 == 2 then
		UIAction:Remove(arg_12_0)
		UIAction:Add(LOOP(RumbleUtil:getOpacityAct(1000, 1, 0.3, arg_12_0)), arg_12_0)
	elseif arg_12_1 == 3 then
		UIAction:Remove(arg_12_0)
		UIAction:Add(LOOP(RumbleUtil:getOpacityAct(400, 1, 0.3, arg_12_0)), arg_12_0)
	end
end

function RumbleUnitGauge.resetBuffIcon(arg_13_0)
	if not arg_13_0.unit or not get_cocos_refid(arg_13_0.n_buff) then
		return 
	end
	
	local var_13_0 = 28
	local var_13_1 = 28
	
	arg_13_0.n_buff:removeAllChildren()
	
	local var_13_2 = arg_13_0.unit:getBuffList()
	
	if not var_13_2 then
		return 
	end
	
	local var_13_3 = var_13_2:getShowBuffList() or {}
	
	for iter_13_0, iter_13_1 in ipairs(var_13_3) do
		local var_13_4 = cc.Sprite:create(var_0_0(iter_13_1:getIcon()))
		
		if get_cocos_refid(var_13_4) then
			var_13_4:setAnchorPoint(0, 0)
			var_13_4:setPosition((iter_13_0 - 1) % 3 * var_13_0, math.floor((iter_13_0 - 1) / 3) * var_13_1)
			
			var_13_4.buff = iter_13_1
			
			arg_13_0.n_buff:addChild(var_13_4)
		end
	end
end

function RumbleUnitGauge.onUpdate(arg_14_0, arg_14_1)
	if not arg_14_0.unit then
		return 
	end
	
	if get_cocos_refid(arg_14_0.n_buff) then
		local var_14_0 = arg_14_0.n_buff:getChildren()
		
		for iter_14_0, iter_14_1 in ipairs(var_14_0) do
			if iter_14_1.buff then
				local var_14_1 = iter_14_1.buff:getTimeRemain()
				
				if var_14_1 < 1000 then
					var_0_1(iter_14_1, 3)
				elseif var_14_1 < 3000 then
					var_0_1(iter_14_1, 2)
				else
					var_0_1(iter_14_1, 1)
				end
			end
		end
	end
end

RumbleUnitText = {}

copy_functions(RumbleUnitHUD, RumbleUnitText)

function RumbleUnitText.loadControl(arg_15_0)
	local var_15_0 = cc.Label:createWithBMFont("font/damage.fnt", 0)
	
	var_15_0:setAnchorPoint(0.5, 0.5)
	var_15_0:setScale(0.5)
	
	return var_15_0
end

function RumbleUnitText.onCreate(arg_16_0, arg_16_1)
	arg_16_0.elapsed = 0
	arg_16_0.y_offset = 0
	
	arg_16_0:setOpacity(255)
	
	arg_16_1 = arg_16_1 or {}
	
	arg_16_0:setString(arg_16_1.damage or 0)
	
	if arg_16_1.critical then
		arg_16_0:setColor(COLOR_CRI_FONT[1], COLOR_CRI_FONT[2])
		arg_16_0:setScale(0.6)
	end
	
	if arg_16_1.heal then
		arg_16_0:setString("+" .. arg_16_1.heal)
		arg_16_0:setColor(COLOR_HEAL_FONT[1], COLOR_HEAL_FONT[2])
	end
end

function RumbleUnitText.onUpdate(arg_17_0, arg_17_1)
	arg_17_0.elapsed = arg_17_0.elapsed + arg_17_1
	arg_17_0.y_offset = arg_17_0.elapsed * 0.01
	
	local var_17_0 = 1 - arg_17_0.elapsed * 0.001
	local var_17_1 = 100
	local var_17_2 = math.log(1 + var_17_0 * (var_17_1 - 1), var_17_1)
	
	arg_17_0:setOpacity(255 * var_17_2)
	
	if arg_17_0.elapsed > 1000 then
		arg_17_0:removeFromParent()
	end
end

function RumbleUnitText.getDisplayPos(arg_18_0)
	if not arg_18_0.unit then
		return 
	end
	
	local var_18_0 = arg_18_0.unit:getUnitNode()
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	local var_18_1 = SceneManager:convertToSceneSpace(var_18_0, {
		x = 0,
		y = 0
	})
	
	return var_18_1.x, var_18_1.y + 60 * RumbleCamera:getCameraScale() + arg_18_0.y_offset
end

RumbleUnitDevote = {}

copy_functions(RumbleUnitHUD, RumbleUnitDevote)

function RumbleUnitDevote.loadControl(arg_19_0)
	return (load_control("wnd/rumble_hero_info.csb"))
end

function RumbleUnitDevote.onCreate(arg_20_0)
	if not arg_20_0.unit then
		return 
	end
	
	arg_20_0:setDevoteGrade(arg_20_0.unit:getDevoteGrade())
end

function RumbleUnitDevote.setDevoteGrade(arg_21_0, arg_21_1)
	RumbleUtil:setHeroInfoNode(arg_21_0, arg_21_1, arg_21_0.unit:getRole(), arg_21_0.unit:getCamp())
end

function RumbleUnitDevote.getDisplayPos(arg_22_0)
	if not arg_22_0.unit then
		return 
	end
	
	local var_22_0 = arg_22_0.unit:getUnitNode()
	local var_22_1 = arg_22_0.unit:getModel()
	
	if not get_cocos_refid(var_22_0) then
		return 
	end
	
	local var_22_2 = SceneManager:convertToSceneSpace(var_22_0, {
		x = 0,
		y = 0
	})
	
	if not get_cocos_refid(var_22_1) then
		return var_22_2.x, var_22_2.y
	end
	
	local var_22_3, var_22_4 = var_22_1:getBonePosition("top")
	local var_22_5 = 0
	
	return var_22_2.x, var_22_2.y + (var_22_4 + var_22_5) * RumbleCamera:getCameraScale()
end
