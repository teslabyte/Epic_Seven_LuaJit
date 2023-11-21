RumbleUnit = ClassDef()

local var_0_0 = 100
local var_0_1 = 0.6
local var_0_2 = {
	Stun = 8,
	Attack = 5,
	Idle = 1,
	Dead = 7,
	Awake = 0,
	Move = 2
}

RumbleUnit.handler = {}
RumbleUnit.handler.onEnter = {}
RumbleUnit.handler.onUpdate = {}
RumbleUnit.handler.onLeave = {}

local var_0_3 = RumbleUnit.handler.onEnter
local var_0_4 = RumbleUnit.handler.onUpdate
local var_0_5 = RumbleUnit.handler.onLeave

var_0_3[var_0_2.Idle] = function(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.unit
	
	if not var_1_0 then
		return 
	end
	
	if get_cocos_refid(arg_1_1) then
		arg_1_1:foreachTimelineObject(function(arg_2_0)
			arg_2_0:removeFromParent()
		end)
	end
	
	var_1_0:setAnimation("idle", {
		loop = true
	})
end
var_0_4[var_0_2.Idle] = function(arg_3_0, arg_3_1)
	if RumbleSystem:isPaused() then
		return 
	end
	
	local var_3_0 = arg_3_0.unit
	
	if not var_3_0 then
		return 
	end
	
	local var_3_1 = var_3_0:getUsableSkill()
	
	if not var_3_1 then
		return 
	end
	
	local var_3_2 = var_3_1:getMainTarget()
	
	if var_3_2 then
		if var_3_2 ~= var_3_0 then
			var_3_0:updateFlipX(var_3_2:getPosition())
		end
		
		if var_3_0:canAttack() then
			var_3_0:setState(var_0_2.Attack, {
				target = var_3_2,
				skill = var_3_1
			})
		end
		
		return 
	end
	
	local var_3_3 = var_3_0:findNextTile(var_3_1:getRange())
	
	if var_3_3 then
		var_3_0:setState(var_0_2.Move, {
			dest_pos = var_3_3
		})
		
		return 
	end
	
	local var_3_4 = var_3_0:findClosestEnemy()
	
	if var_3_4 then
		var_3_0:updateFlipX(var_3_4:getPosition())
	end
end
var_0_3[var_0_2.Move] = function(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.unit
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = arg_4_0.dest_pos
	
	if not var_4_1 then
		var_4_0:setState(var_0_2.Idle)
		
		return 
	end
	
	var_4_0:updateNodePosition()
	var_4_0:updateFlipX(var_4_1)
	var_4_0:setPosition(var_4_1, true)
	
	local var_4_2 = 800
	local var_4_3, var_4_4 = RumbleBoard:tilePosToBoardPos(var_4_1.x, var_4_1.y)
	
	BattleAction:Add(SEQ(MOVE_TO(var_4_2, var_4_3, var_4_4), CALL(function()
		var_4_0:updateNodePosition()
		var_4_0:setState(var_0_2.Idle)
	end)), var_4_0:getUnitNode())
	var_4_0:setAnimation("run", {
		loop = true
	})
end
var_0_4[var_0_2.Move] = function(arg_6_0, arg_6_1)
end
var_0_3[var_0_2.Attack] = function(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.unit
	
	if not var_7_0 then
		return 
	end
	
	local var_7_1 = arg_7_0.target
	
	if not var_7_1 or var_7_1:isDead() then
		var_7_0:setState(var_0_2.Idle)
		
		return 
	end
	
	local var_7_2 = arg_7_0.skill
	
	if not var_7_2 then
		var_7_0:setState(var_0_2.Idle)
		
		return 
	end
	
	var_7_2:fire({
		target = var_7_1
	})
	
	local var_7_3 = var_7_2:getAnimationData()
	local var_7_4 = arg_7_1:getPositionX()
	local var_7_5 = var_7_3.start_anim or "skill1"
	local var_7_6 = var_7_0:setAnimation(var_7_5, var_7_3.anim_opts)
	
	BattleAction:Add(SEQ(CALL(function()
		if var_7_3.shadow_x then
			arg_7_1.shadow:setPositionX(var_7_3.shadow_x)
			arg_7_1.shadow:unscheduleUpdate()
		end
		
		arg_7_1:setPositionX(var_7_4 + to_n(var_7_3.offset_x) * arg_7_1:getScaleX())
	end), DELAY(var_7_6.duration), CALL(function()
		arg_7_1:setPositionX(var_7_4)
		
		if var_7_3.shadow_x then
			arg_7_1.shadow:scheduleUpdate()
		end
		
		var_7_0:setState(var_0_2.Idle)
	end)), arg_7_1)
	var_7_0:reduceCooldown()
	var_7_2:resetCooldown()
	var_7_0:resetAttackTimer()
	var_7_0:updateSP()
end
var_0_3[var_0_2.Dead] = function(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.unit
	
	if not var_10_0 then
		return 
	end
	
	var_10_0:setAnimation("groggy", {
		loop = true
	})
	
	local var_10_1, var_10_2 = var_10_0:getWorldPosition("target")
	local var_10_3 = var_10_0:getUnitZOrder() + 2
	
	EffectManager:Play({
		fn = "death_eff_01",
		layer = RumbleBoard:getLayer(),
		pivot_x = var_10_1,
		pivot_y = var_10_2,
		pivot_z = var_10_3,
		scale = var_0_1,
		flip_x = arg_10_1:getScaleX() < 0
	})
	BattleAction:Remove(var_10_0:getUnitNode())
	BattleAction:Add(SPAWN(COLOR(500, 30, 30, 30), SEQ(FADE_OUT(1000))), arg_10_1)
end
var_0_3[var_0_2.Stun] = function(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.unit
	
	if not var_11_0 then
		return 
	end
	
	var_11_0:setAnimation("groggy", {
		loop = true
	})
	BattleAction:Remove(var_11_0:getUnitNode())
	BattleAction:Remove(arg_11_1)
end

local var_0_6 = 0

function RumbleUnit.constructor(arg_12_0, arg_12_1, arg_12_2)
	arg_12_2 = arg_12_2 or {}
	var_0_6 = var_0_6 + 1
	arg_12_2.uid = var_0_6
	
	arg_12_0:init(arg_12_1, arg_12_2)
end

function RumbleUnit.getModelScale(arg_13_0)
	return var_0_1
end

function RumbleUnit.init(arg_14_0, arg_14_1, arg_14_2)
	arg_14_2 = arg_14_2 or {}
	arg_14_0.db = DBT("rumble_character", arg_14_1, {
		"id",
		"base_chr",
		"rol",
		"camp",
		"atk",
		"hp",
		"def",
		"atk_spd",
		"memory_imprint_rate",
		"skill1",
		"skill2",
		"skill3"
	})
	
	if not arg_14_0.db or not arg_14_0.db.id then
		return 
	end
	
	arg_14_0.db.grade = DB("character", arg_14_0.db.base_chr, {
		"grade"
	})
	arg_14_0.vars = {}
	arg_14_0.vars.uid = arg_14_2.uid
	arg_14_0.vars.team = arg_14_2.team or 1
	arg_14_0.vars.power_rate = arg_14_2.power_rate
	arg_14_0.vars.devote = arg_14_2.devote or 0
	arg_14_0.vars.cs_list = RumbleBuffList(arg_14_0)
	arg_14_0.vars.is_creature = arg_14_2.is_creature
	
	arg_14_0:initSkills()
	arg_14_0:updateStat()
end

function RumbleUnit.makeInfoUI(arg_15_0)
	local var_15_0 = RumbleUnitDevote:create(arg_15_0)
	
	if not get_cocos_refid(var_15_0) then
		return 
	end
	
	var_15_0:setScale(var_0_1)
	
	return var_15_0
end

function RumbleUnit.reset(arg_16_0)
	if not arg_16_0.vars then
		return 
	end
	
	arg_16_0:setState(var_0_2.Awake)
	
	arg_16_0.vars.followers = nil
	arg_16_0.vars.pos = arg_16_0.vars.place or {
		x = 1,
		y = 1
	}
	
	if get_cocos_refid(arg_16_0.vars.model) then
		BattleAction:Remove(arg_16_0.vars.model)
		setBlendColor2(arg_16_0.vars.model, "def")
		arg_16_0.vars.model:setColor(arg_16_0:getAmbientColor())
		arg_16_0.vars.model:setOpacity(255)
		arg_16_0.vars.model:setAnimation(0, "idle", true)
	end
	
	if not arg_16_0:isEnemy() and not get_cocos_refid(arg_16_0.vars.info_ui) then
		arg_16_0.vars.info_ui = arg_16_0:makeInfoUI()
	end
	
	arg_16_0:clearDamageInfo()
	arg_16_0:resetBuff()
	arg_16_0:updateStat()
end

function RumbleUnit.resetBuff(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if arg_17_0.vars.cs_list then
		arg_17_0.vars.cs_list:clear()
	end
end

function RumbleUnit.prepareBattle(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	if arg_18_0.vars.cs_list then
		arg_18_0.vars.cs_list:onPreBattle()
	end
end

function RumbleUnit.run(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	if not arg_19_0.db then
		return 
	end
	
	if arg_19_0.vars.cs_list then
		arg_19_0.vars.cs_list:onBattleStart()
	end
	
	arg_19_0:applyPassiveSkills()
	arg_19_0:resetAttackTimer()
	arg_19_0:resetCooldown()
	arg_19_0:setState(var_0_2.Idle)
	
	arg_19_0.vars.gauge = RumbleUnitGauge:create(arg_19_0)
	
	if_set_visible(arg_19_0.vars.info_ui, nil, false)
end

function RumbleUnit.updateStat(arg_20_0)
	arg_20_0.status = arg_20_0:getBaseStat()
	arg_20_0.status.max_hp = arg_20_0:getMaxHp()
	arg_20_0.status.cur_hp = arg_20_0.status.max_hp
	arg_20_0.status.sp = 0
end

function RumbleUnit.onBattleEnd(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if arg_21_0.vars.cs_list then
		arg_21_0.vars.cs_list:onBattleEnd()
	end
	
	arg_21_0:reset()
end

function RumbleUnit.getGauge(arg_22_0)
	return arg_22_0.vars and arg_22_0.vars.gauge
end

function RumbleUnit.setState(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars then
		return 
	end
	
	if arg_23_0:isDead() then
		return 
	end
	
	if arg_23_0.vars.state and type(arg_23_0.vars.state.onLeave) == "function" then
		arg_23_0.vars.state:onLeave()
	end
	
	local var_23_0 = {
		type = arg_23_1,
		unit = arg_23_0,
		onEnter = var_0_3[arg_23_1],
		onUpdate = var_0_4[arg_23_1],
		onLeave = var_0_5[arg_23_1]
	}
	
	for iter_23_0, iter_23_1 in pairs(arg_23_2 or {}) do
		var_23_0[iter_23_0] = iter_23_1
	end
	
	arg_23_0.vars.state = var_23_0
	
	if type(arg_23_0.vars.state.onEnter) == "function" then
		arg_23_0.vars.state:onEnter(arg_23_0.vars.model)
	end
end

function RumbleUnit.makeUnitNode(arg_24_0)
	if not arg_24_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_24_0.vars.node) then
		return arg_24_0.vars.node
	end
	
	local var_24_0 = cc.Node:create()
	
	var_24_0:setName(arg_24_0.db.id)
	var_24_0:setLocalZOrder(var_0_0)
	var_24_0:setPosition(0, 0)
	var_24_0:addChild(arg_24_0:makeModel())
	var_24_0:setCascadeOpacityEnabled(true)
	
	arg_24_0.vars.node = var_24_0
	
	return var_24_0
end

function RumbleUnit.getUnitNode(arg_25_0)
	return arg_25_0.vars and arg_25_0.vars.node
end

function RumbleUnit.getUID(arg_26_0)
	return arg_26_0.vars and arg_26_0.vars.uid or 0
end

function RumbleUnit.getBaseCode(arg_27_0)
	return arg_27_0.db and arg_27_0.db.base_chr or ""
end

function RumbleUnit.getCode(arg_28_0)
	return arg_28_0.db and arg_28_0.db.id or ""
end

function RumbleUnit.isActive(arg_29_0)
	return get_cocos_refid(arg_29_0:getUnitNode())
end

function RumbleUnit.makeModel(arg_30_0, arg_30_1)
	if not arg_30_0.vars then
		return 
	end
	
	arg_30_1 = arg_30_1 or arg_30_0.db.base_chr
	
	local var_30_0, var_30_1, var_30_2, var_30_3 = DB("character", arg_30_1, {
		"model_id",
		"skin",
		"atlas",
		"model_opt"
	})
	local var_30_4 = CACHE:getModel(var_30_0, var_30_1, nil, var_30_2, var_30_3)
	
	if get_cocos_refid(var_30_4) then
		var_30_4:setScale(var_0_1)
		
		if arg_30_0:isEnemy() then
			var_30_4:setScaleX(-var_0_1)
		end
	end
	
	local var_30_5 = var_30_4:createShadow()
	
	var_30_5:setGlobalZOrder(0)
	var_30_5:setLocalZOrder(-10)
	
	arg_30_0.vars.model = var_30_4
	
	return var_30_4
end

function RumbleUnit.getModel(arg_31_0)
	return arg_31_0.vars and arg_31_0.vars.model
end

local function var_0_7(arg_32_0, arg_32_1)
	local var_32_0 = {}
	local var_32_1 = {}
	local var_32_2 = {}
	
	local function var_32_3(arg_33_0, arg_33_1)
		return arg_33_0 .. "_" .. arg_33_1
	end
	
	local function var_32_4(arg_34_0)
		return var_32_1[arg_34_0] or 9999
	end
	
	local function var_32_5(arg_35_0)
		return HTUtil:getTileCost(arg_35_0, arg_32_1)
	end
	
	local function var_32_6(arg_36_0, arg_36_1, arg_36_2)
		local var_36_0 = #var_32_0 + 1
		local var_36_1 = arg_36_1 + var_32_5(arg_36_0)
		
		while var_36_0 > 1 do
			local var_36_2 = math.floor(var_36_0 / 2)
			
			if var_32_0[var_36_2] and var_36_1 < var_32_0[var_36_2].cost then
				var_32_0[var_36_0] = var_32_0[var_36_2]
				var_36_0 = var_36_2
			else
				break
			end
		end
		
		local var_36_3 = var_32_3(arg_36_0.x, arg_36_0.y)
		
		var_32_0[var_36_0] = {
			key = var_36_3,
			cost = var_36_1,
			pos = arg_36_0
		}
		var_32_1[var_36_3] = arg_36_1
		var_32_2[var_36_3] = arg_36_2
	end
	
	local function var_32_7()
		local var_37_0 = var_32_0[1]
		local var_37_1 = var_32_0[#var_32_0]
		local var_37_2 = #var_32_0 - 1
		local var_37_3 = 1
		
		while var_37_3 <= var_37_2 do
			if var_37_2 < var_37_3 * 2 then
				break
			else
				local var_37_4 = var_32_0[var_37_3 * 2]
				local var_37_5 = var_32_0[var_37_3 * 2 + 1]
				
				if not var_37_5 or var_37_4.cost < var_37_5.cost then
					if var_37_4.cost < var_37_1.cost then
						var_32_0[var_37_3] = var_37_4
						var_37_3 = var_37_3 * 2
					else
						break
					end
				elseif var_37_5.cost < var_37_1.cost then
					var_32_0[var_37_3] = var_37_5
					var_37_3 = var_37_3 * 2 + 1
				else
					break
				end
			end
		end
		
		var_32_0[var_37_3] = var_37_1
		var_32_0[#var_32_0] = nil
		
		return var_37_0
	end
	
	var_32_6(arg_32_0, 0)
	
	local var_32_8 = 0
	
	while #var_32_0 > 0 do
		local var_32_9 = var_32_7()
		local var_32_10 = var_32_9.key
		local var_32_11 = var_32_9.pos
		
		var_32_8 = var_32_8 + 1
		
		if var_32_8 > 128 then
			break
		end
		
		if HTUtil:isSamePosition(var_32_11, arg_32_1) then
			local var_32_12 = {}
			
			while var_32_10 do
				var_32_11 = string.split(var_32_10, "_")
				
				if not var_32_11 then
					return 
				end
				
				table.insert(var_32_12, {
					x = to_n(var_32_11[1]),
					y = to_n(var_32_11[2])
				})
				
				var_32_10 = var_32_2[var_32_10]
			end
			
			table.reverse(var_32_12)
			
			return var_32_12
		end
		
		local var_32_13 = RumbleBoard:getMovableTiles(var_32_11, 1) or {}
		local var_32_14 = var_32_4(var_32_10) + 1
		
		for iter_32_0, iter_32_1 in ipairs(var_32_13) do
			local var_32_15 = var_32_3(iter_32_1.x, iter_32_1.y)
			
			if var_32_14 < var_32_4(var_32_15) then
				var_32_6(iter_32_1, var_32_14, var_32_10)
			end
		end
	end
end

local function var_0_8(arg_38_0)
	local var_38_0 = RumbleBoard:getUnits(arg_38_0)
	
	if not var_38_0 or table.empty(var_38_0) then
		arg_38_0.include_hide = true
		var_38_0 = RumbleBoard:getUnits(arg_38_0)
	end
	
	return var_38_0
end

local function var_0_9(arg_39_0, arg_39_1)
	local var_39_0
	local var_39_1 = 9999
	local var_39_2 = 99
	
	for iter_39_0, iter_39_1 in ipairs(arg_39_1) do
		local var_39_3 = iter_39_1.getPosition and iter_39_1:getPosition() or iter_39_1
		local var_39_4 = HTUtil:getTileCost(arg_39_0, var_39_3)
		local var_39_5 = math.abs(arg_39_0.y - var_39_3.y)
		
		if var_39_4 < var_39_1 then
			var_39_1 = var_39_4
			var_39_2 = var_39_5
			var_39_0 = iter_39_1
		elseif var_39_4 == var_39_1 and var_39_5 < var_39_2 then
			var_39_2 = var_39_5
			var_39_0 = iter_39_1
		end
	end
	
	return var_39_0
end

local function var_0_10(arg_40_0)
	local var_40_0 = {}
	
	local function var_40_1(arg_41_0, arg_41_1, arg_41_2)
		var_40_0[arg_41_1] = var_40_0[arg_41_1] or {}
		var_40_0[arg_41_1][arg_41_0] = arg_41_2
	end
	
	local function var_40_2(arg_42_0, arg_42_1)
		return var_40_0[arg_42_1] and var_40_0[arg_42_1][arg_42_0]
	end
	
	local var_40_3 = {
		arg_40_0
	}
	
	for iter_40_0 = 0, 32 do
		local var_40_4 = {}
		
		while #var_40_3 > 0 do
			local var_40_5 = table.remove(var_40_3, 1)
			
			if not var_40_2(var_40_5.x, var_40_5.y) then
				var_40_1(var_40_5.x, var_40_5.y, iter_40_0)
				
				local var_40_6 = RumbleBoard:getMovableTiles(var_40_5, 1) or {}
				
				for iter_40_1, iter_40_2 in ipairs(var_40_6) do
					if not var_40_2(iter_40_2.x, iter_40_2.y) then
						table.insert(var_40_4, iter_40_2)
					end
				end
			end
		end
		
		if table.empty(var_40_4) then
			break
		end
		
		var_40_3 = var_40_4
	end
	
	return var_40_0
end

function RumbleUnit.findNextTile(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0:getPosition()
	
	if not var_43_0 then
		return 
	end
	
	local var_43_1 = {}
	local var_43_2 = var_0_8({
		team = arg_43_0.vars.team == 1 and 2 or 1
	}) or {}
	
	for iter_43_0, iter_43_1 in pairs(var_43_2) do
		local var_43_3 = RumbleBoard:getMovableTiles(iter_43_1:getPosition(), arg_43_1) or {}
		
		for iter_43_2, iter_43_3 in ipairs(var_43_3) do
			table.insert(var_43_1, iter_43_3)
		end
	end
	
	local var_43_4
	local var_43_5 = 999
	local var_43_6 = 99
	local var_43_7 = var_0_10(var_43_0)
	
	for iter_43_4, iter_43_5 in pairs(var_43_1) do
		local var_43_8 = var_43_7[iter_43_5.y] and var_43_7[iter_43_5.y][iter_43_5.x] or 999
		local var_43_9 = math.abs(var_43_0.y - iter_43_5.y)
		
		if var_43_8 < var_43_5 then
			var_43_5 = var_43_8
			var_43_6 = var_43_9
			var_43_4 = iter_43_5
		elseif var_43_8 == var_43_5 and var_43_9 < var_43_6 then
			var_43_6 = var_43_9
			var_43_4 = iter_43_5
		end
	end
	
	if var_43_4 then
		local var_43_10 = var_0_7(var_43_0, var_43_4)
		
		if var_43_10 then
			return var_43_10[2]
		end
	end
	
	local var_43_11 = arg_43_0:findClosestEnemy(var_43_2)
	
	if var_43_11 then
		local var_43_12 = arg_43_0:findClosestTile(var_43_11:getPosition(), RumbleBoard:getMovableTiles(var_43_0, 1))
		
		if not var_43_12 then
			return 
		end
		
		if HTUtil:getTileCost(var_43_12, var_43_11:getPosition()) < HTUtil:getTileCost(var_43_0, var_43_11:getPosition()) then
			return var_43_12
		end
	end
end

function RumbleUnit.findClosestAlly(arg_44_0)
	if not arg_44_0.vars then
		return 
	end
	
	local var_44_0 = arg_44_0:getPosition()
	
	if not var_44_0 then
		return 
	end
	
	local var_44_1 = var_0_8({
		team = arg_44_0.vars.team == 1 and 2 or 1
	}) or {}
	
	return var_0_9(var_44_0, var_44_1)
end

function RumbleUnit.findClosestEnemy(arg_45_0, arg_45_1)
	if not arg_45_0.vars then
		return 
	end
	
	local var_45_0 = arg_45_0:getPosition()
	
	if not var_45_0 then
		return 
	end
	
	arg_45_1 = arg_45_1 or var_0_8({
		team = arg_45_0.vars.team == 1 and 2 or 1
	}) or {}
	
	return var_0_9(var_45_0, arg_45_1)
end

function RumbleUnit.findClosestTile(arg_46_0, arg_46_1, arg_46_2)
	arg_46_2 = arg_46_2 or RumbleBoard:getMovableTiles(arg_46_1, 1) or {}
	
	return var_0_9(arg_46_1, arg_46_2)
end

function RumbleUnit.update(arg_47_0, arg_47_1)
	if not arg_47_0.vars then
		return 
	end
	
	if arg_47_0:isDead() then
		return 
	end
	
	arg_47_0:updateFollower(arg_47_1)
	
	local var_47_0 = arg_47_0.vars.state
	
	if not var_47_0 then
		return 
	end
	
	if arg_47_0.vars.cs_list then
		arg_47_0.vars.cs_list:update(arg_47_1)
	end
	
	arg_47_0:updateAttackTimer(arg_47_1)
	
	if type(var_47_0.onUpdate) == "function" then
		var_47_0:onUpdate(arg_47_1)
	end
end

function RumbleUnit.updateAttackTimer(arg_48_0, arg_48_1)
	if not arg_48_0.vars then
		return 
	end
	
	arg_48_0.vars.attack_tm = (arg_48_0.vars.attack_tm or 0) + arg_48_1 * (arg_48_0:getAttackSpeed() or 0.3)
end

function RumbleUnit.setPlace(arg_49_0, arg_49_1)
	if not arg_49_0.vars then
		return 
	end
	
	arg_49_0.vars.place = arg_49_1
end

function RumbleUnit.getPlace(arg_50_0)
	return arg_50_0.vars and arg_50_0.vars.place
end

function RumbleUnit.setPosition(arg_51_0, arg_51_1, arg_51_2)
	if not arg_51_0.vars then
		return 
	end
	
	arg_51_0.vars.pos = arg_51_1
	
	if not arg_51_2 then
		arg_51_0:updateNodePosition()
	end
end

function RumbleUnit.initSkills(arg_52_0)
	if not arg_52_0.vars then
		return 
	end
	
	arg_52_0.vars.skills = {}
	
	for iter_52_0 = 1, 3 do
		if arg_52_0.db["skill" .. iter_52_0] then
			table.insert(arg_52_0.vars.skills, RumbleSkill(arg_52_0, arg_52_0.db["skill" .. iter_52_0]))
		end
	end
end

function RumbleUnit.getSkill(arg_53_0, arg_53_1)
	return arg_53_0.vars and arg_53_0.vars.skills[arg_53_1]
end

local var_0_11 = {
	HP_HALF = function(arg_54_0, arg_54_1)
		return arg_54_0 and arg_54_0:getHPRatio() <= 0.5
	end,
	SP_MAX = function(arg_55_0, arg_55_1)
		return arg_55_0 and arg_55_0:getSPRatio() >= 1
	end,
	REQ_CS = function(arg_56_0, arg_56_1)
		local var_56_0 = arg_56_0:getBuffList()
		
		return var_56_0 and var_56_0:isExist(arg_56_1)
	end,
	MAX_STACK_CS = function(arg_57_0, arg_57_1)
		local var_57_0 = arg_57_0:getBuffList()
		local var_57_1 = var_57_0 and var_57_0:getBuff(arg_57_1)
		
		return var_57_1 and var_57_1:isMaxStack()
	end,
	BUFF_COUNT = function(arg_58_0, arg_58_1)
		local var_58_0 = arg_58_0:getBuffList()
		
		return var_58_0 and arg_58_1 <= var_58_0:getBuffCount()
	end,
	DEBUFF_COUNT = function(arg_59_0, arg_59_1)
		local var_59_0 = arg_59_0:getBuffList()
		
		return var_59_0 and arg_59_1 <= var_59_0:getDebuffCount()
	end,
	RANDOM = function(arg_60_0, arg_60_1)
		return arg_60_1 >= RumbleSystem:getRandom(1, 100) * 0.01
	end
}

function RumbleUnit.checkCondition(arg_61_0, arg_61_1, arg_61_2)
	if not arg_61_0.vars then
		return false
	end
	
	local var_61_0 = var_0_11[arg_61_1]
	
	if not var_61_0 then
		return false
	end
	
	return var_61_0(arg_61_0, arg_61_2)
end

function RumbleUnit.getUsableSkill(arg_62_0)
	if not arg_62_0.vars then
		return 
	end
	
	local var_62_0 = arg_62_0.vars.skills[3]
	
	if var_62_0 and var_62_0:checkCondition() and not RumbleSystem:isUltimateLocked() then
		return var_62_0
	end
	
	local var_62_1 = arg_62_0.vars.skills[2]
	
	if var_62_1 and not var_62_1:isPassive() and var_62_1:checkCondition() then
		return var_62_1
	end
	
	return arg_62_0.vars.skills[1]
end

function RumbleUnit.applyPassiveSkills(arg_63_0)
	if not arg_63_0.db then
		return 
	end
	
	for iter_63_0 = 1, 3 do
		local var_63_0 = DB("rumble_character", arg_63_0.db.id, "cs" .. iter_63_0)
		
		if not var_63_0 then
			break
		end
		
		arg_63_0:addBuff(var_63_0)
	end
end

function RumbleUnit.getPosition(arg_64_0)
	if not arg_64_0.vars then
		return 
	end
	
	return arg_64_0.vars.pos
end

function RumbleUnit.getUnitZOrder(arg_65_0)
	if not arg_65_0.vars or not arg_65_0.vars.pos then
		return 0
	end
	
	return var_0_0 - arg_65_0.vars.pos.y * 5
end

function RumbleUnit.updateNodePosition(arg_66_0)
	if not arg_66_0.vars then
		return 
	end
	
	local var_66_0 = arg_66_0.vars.pos
	
	if not var_66_0 or not get_cocos_refid(arg_66_0.vars.node) then
		return 
	end
	
	local var_66_1, var_66_2 = RumbleBoard:tilePosToBoardPos(var_66_0.x, var_66_0.y)
	
	arg_66_0.vars.node:setPosition(var_66_1, var_66_2)
	arg_66_0.vars.node:setLocalZOrder(arg_66_0:getUnitZOrder())
end

function RumbleUnit.updateFlipX(arg_67_0, arg_67_1)
	if not arg_67_0.vars then
		return 
	end
	
	local var_67_0 = arg_67_0.vars.model
	
	if not get_cocos_refid(var_67_0) then
		return 
	end
	
	local var_67_1 = math.abs(var_67_0:getScaleX())
	
	if arg_67_1.x < arg_67_0:getPosition().x then
		var_67_1 = var_67_1 * -1
	end
	
	var_67_0:setScaleX(var_67_1)
end

function RumbleUnit.reduceCooldown(arg_68_0, arg_68_1)
	if not arg_68_0.vars then
		return 
	end
	
	for iter_68_0 = 3, 2, -1 do
		local var_68_0 = arg_68_0.vars.skills[iter_68_0]
		
		if var_68_0 then
			var_68_0:reduceCooldown(arg_68_1)
		end
	end
	
	arg_68_0:updateSP()
end

function RumbleUnit.resetCooldown(arg_69_0)
	if not arg_69_0.vars then
		return 
	end
	
	for iter_69_0 = 3, 2, -1 do
		local var_69_0 = arg_69_0.vars.skills[iter_69_0]
		
		if var_69_0 then
			var_69_0:resetCooldown()
		end
	end
	
	arg_69_0:updateSP()
end

function RumbleUnit.updateSP(arg_70_0)
	if arg_70_0.vars and get_cocos_refid(arg_70_0.vars.gauge) then
		arg_70_0.vars.gauge:updateSP()
	end
end

function RumbleUnit.updateHP(arg_71_0)
	if arg_71_0.vars and get_cocos_refid(arg_71_0.vars.gauge) then
		arg_71_0.vars.gauge:updateHP()
	end
	
	if RumbleUnitPopup:getUnit() == arg_71_0 then
		RumbleUnitPopup:updateInfo()
	end
end

function RumbleUnit.canAttack(arg_72_0)
	if not arg_72_0.vars then
		return false
	end
	
	return arg_72_0.vars.attack_tm > 1000
end

function RumbleUnit.resetAttackTimer(arg_73_0)
	if not arg_73_0.vars then
		return 
	end
	
	arg_73_0.vars.attack_tm = 0
end

function RumbleUnit.playEffect(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	if not arg_74_0.vars or not get_cocos_refid(arg_74_0.vars.model) then
		return 
	end
	
	if not arg_74_2 then
		return 
	end
	
	arg_74_3 = arg_74_3 or {}
	
	local var_74_0 = 0
	local var_74_1 = 0
	local var_74_2 = arg_74_0:getUnitZOrder() + 2
	local var_74_3 = arg_74_2[2]
	
	if var_74_3 == "Unit_Target" or var_74_3 == "Attach_Target" then
		if not arg_74_1 or arg_74_1:isDead() then
			return 
		end
		
		var_74_0, var_74_1 = arg_74_1:getWorldPosition(arg_74_3.bone)
		var_74_2 = arg_74_1:getUnitZOrder() + 2
	elseif var_74_3 == "Attach_Self" or var_74_3 == "Unit_Self" then
		var_74_0, var_74_1 = arg_74_0:getWorldPosition(arg_74_3.bone)
	elseif var_74_3 == "Field_Target" then
		if not arg_74_1 then
			return 
		end
		
		var_74_0, var_74_1 = RumbleBoard:tilePosToBoardPos(arg_74_1:getPosition().x, arg_74_1:getPosition().y)
		
		local var_74_4, var_74_5 = arg_74_1:getBonePosition(arg_74_3.bone)
		
		var_74_0 = var_74_0 + var_74_4
		var_74_1 = var_74_1 + var_74_5
		var_74_2 = arg_74_1:getUnitZOrder() + 2
	elseif var_74_3 == "Field_Self" then
		var_74_0, var_74_1 = RumbleBoard:tilePosToBoardPos(arg_74_0:getPosition().x, arg_74_0:getPosition().y)
	elseif var_74_3 == "Screen_Center" then
		var_74_0, var_74_1 = DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2
	else
		return 
	end
	
	local var_74_6 = arg_74_0.vars.model:getScaleX() < 0
	local var_74_7 = (arg_74_3.scale or 1) * var_0_1
	local var_74_8 = (arg_74_3.x or 0) * var_74_7 * (var_74_6 and -1 or 1)
	local var_74_9 = (arg_74_3.y or 0) * var_74_7
	local var_74_10 = var_74_0 + var_74_8
	local var_74_11 = var_74_1 + var_74_9
	local var_74_12 = var_74_2 + (arg_74_3.z or 0)
	
	if arg_74_2[3] then
		local var_74_13 = EffectManager:Play({
			extractNodes = true,
			is_battle_effect = true,
			fn = arg_74_2[3] .. ".cfx",
			layer = RumbleBoard:getLayer(),
			pivot_x = var_74_10,
			pivot_y = var_74_11,
			pivot_z = var_74_12,
			scale = var_74_7,
			flip_x = var_74_6
		})
		
		if get_cocos_refid(var_74_13) then
			if arg_74_3.action then
				local function var_74_14(arg_75_0, arg_75_1)
					if arg_75_0 == "delay" then
						return DELAY(arg_75_1 or 1000)
					elseif arg_75_0 == "move_to" then
						local var_75_0 = var_74_10 + (arg_75_1.x or 0) * var_74_7 * (var_74_6 and -1 or 1)
						local var_75_1 = var_74_11 + (arg_75_1.y or 0) * var_74_7
						
						return BEZIER(MOVE_TO(arg_75_1.time or 1000, var_75_0, var_75_1), {
							0.3,
							0,
							0.57,
							1
						})
					elseif arg_75_0 == "fade_out" then
						return FADE_OUT(arg_75_1 or 1000)
					elseif arg_75_0 == "shake" then
						return SHAKE_UI(arg_75_1.time or 1000, arg_75_1.power)
					end
				end
				
				local var_74_15 = {}
				
				for iter_74_0, iter_74_1 in ipairs(arg_74_3.action) do
					local var_74_16 = {}
					
					for iter_74_2, iter_74_3 in pairs(iter_74_1) do
						local var_74_17 = var_74_14(iter_74_2, iter_74_3)
						
						if var_74_17 then
							table.insert(var_74_16, var_74_17)
						end
					end
					
					if not table.empty(var_74_16) then
						table.insert(var_74_15, SPAWN(table.unpack(var_74_16)))
					end
				end
				
				if not table.empty(var_74_15) then
					BattleAction:Add(SEQ(table.unpack(var_74_15)), var_74_13)
				end
			end
			
			if var_74_3 == "Attach_Self" then
				arg_74_0:addFollower(var_74_13, {
					offset_x = var_74_8,
					offset_y = var_74_9,
					bone = arg_74_3.bone
				})
			elseif var_74_3 == "Attach_Target" then
				arg_74_1:addFollower(var_74_13, {
					offset_x = var_74_8,
					offset_y = var_74_9,
					bone = arg_74_3.bone
				})
			end
		end
	end
end

function RumbleUnit.addFollower(arg_76_0, arg_76_1, arg_76_2)
	if not arg_76_0.vars then
		return 
	end
	
	if not arg_76_0.vars.followers then
		arg_76_0.vars.followers = {}
	end
	
	arg_76_2 = arg_76_2 or {}
	arg_76_2.inst = arg_76_1
	
	table.insert(arg_76_0.vars.followers, arg_76_2)
end

function RumbleUnit.updateFollower(arg_77_0, arg_77_1)
	if not arg_77_0.vars then
		return 
	end
	
	if not arg_77_0.vars.followers then
		return 
	end
	
	for iter_77_0, iter_77_1 in pairs(arg_77_0.vars.followers) do
		if get_cocos_refid(iter_77_1.inst) then
			local var_77_0, var_77_1 = arg_77_0:getWorldPosition(iter_77_1.bone or "root")
			local var_77_2 = var_77_0 + (iter_77_1.offset_x or 0)
			local var_77_3 = var_77_1 + (iter_77_1.offset_y or 0)
			
			iter_77_1.inst:setPosition(var_77_2, var_77_3)
		end
	end
end

function RumbleUnit.setAnimation(arg_78_0, arg_78_1, arg_78_2)
	local var_78_0 = arg_78_0:getModel()
	
	if not get_cocos_refid(var_78_0) then
		return 
	end
	
	arg_78_2 = arg_78_2 or {}
	
	var_78_0:setAnimation(0, arg_78_1, arg_78_2.loop)
	
	local var_78_1 = var_78_0:getCurrent()
	
	if not var_78_1 then
		return {
			duration = 0
		}
	end
	
	local var_78_2 = arg_78_2.start_time or 0
	local var_78_3 = arg_78_2.end_time or var_78_1.endTime * 1000
	local var_78_4 = arg_78_2.duration or var_78_3 - var_78_2
	
	if var_78_1 then
		var_78_1.time = var_78_2 / 1000
	end
	
	return {
		track = var_78_1,
		duration = var_78_4,
		start_time = var_78_2,
		end_time = var_78_3
	}
end

function RumbleUnit.getWorldPosition(arg_79_0, arg_79_1)
	if not arg_79_0.vars or not get_cocos_refid(arg_79_0.vars.node) then
		return 0, 0
	end
	
	local var_79_0, var_79_1 = arg_79_0.vars.node:getPosition()
	
	if not arg_79_1 or not get_cocos_refid(arg_79_0.vars.model) then
		return var_79_0, var_79_1
	end
	
	local var_79_2, var_79_3 = arg_79_0:getBonePosition(arg_79_1)
	
	return var_79_0 + var_79_2, var_79_1 + var_79_3
end

function RumbleUnit.getBonePosition(arg_80_0, arg_80_1)
	if not arg_80_0.vars or not get_cocos_refid(arg_80_0.vars.model) then
		return 0, 0
	end
	
	return arg_80_0.vars.model:getBonePosition(arg_80_1)
end

function RumbleUnit.getAmbientColor(arg_81_0)
	if not arg_81_0.vars then
		return cc.c3b(255, 255, 255)
	end
	
	if not arg_81_0.vars.color then
		if arg_81_0:isEnemy() then
			arg_81_0.vars.color = tocolor(RumbleSystem:getConfig("ambient_color_enemy"))
		else
			arg_81_0.vars.color = tocolor(RumbleSystem:getConfig("ambient_color_ally"))
		end
	end
	
	return arg_81_0.vars.color
end

function RumbleUnit.damage(arg_82_0, arg_82_1)
	if not arg_82_0.vars then
		return 
	end
	
	if not arg_82_1 then
		return 
	end
	
	if arg_82_0:isDead() then
		return 
	end
	
	if arg_82_0.vars.cs_list:isInvincible() then
		return 
	end
	
	if arg_82_0:isEnemy() and table.find(DEBUG.INVINCIBLE, ENEMY) or not arg_82_0:isEnemy() and table.find(DEBUG.INVINCIBLE, FRIEND) then
		return 
	end
	
	local var_82_0 = arg_82_0.vars.cs_list:getEndure()
	
	if var_82_0 and var_82_0:isValid() then
		var_82_0:damage()
		arg_82_0.vars.gauge:resetBuffIcon()
		
		return 
	end
	
	local var_82_1 = 1 + arg_82_0.vars.cs_list:getBonusStat("self_dmg")
	local var_82_2 = math.floor(to_n(arg_82_1.damage) * var_82_1)
	
	if DEBUG.DEBUG_DAMAGE_1 then
		var_82_2 = 1
	end
	
	arg_82_1.damage = var_82_2
	
	local var_82_3 = arg_82_0.vars.cs_list:getShield()
	
	if var_82_3 and var_82_3:isValid() then
		local var_82_4 = var_82_3:getShieldAmount()
		
		var_82_3:damage(var_82_2)
		
		var_82_2 = var_82_2 - var_82_4
	end
	
	arg_82_0.vars.cs_list:onHit(arg_82_1)
	RumbleStat:onHit(arg_82_1)
	
	if var_82_2 > 0 then
		arg_82_0:addDamageInfo({
			damage = var_82_2,
			critical = arg_82_1.critical
		})
		
		arg_82_0.status.cur_hp = arg_82_0.status.cur_hp - var_82_2
		
		if arg_82_0.status.cur_hp <= 0 then
			arg_82_0.status.cur_hp = 0
			
			arg_82_0:dead()
			
			return 
		end
		
		local var_82_5 = arg_82_0:getAmbientColor()
		
		BattleAction:Add(SEQ(BLEND(1, "red", 0, 1), DELAY(33), BLEND(1, "white", 0, 1), DELAY(25), BLEND(0), COLOR(0, cc.c3b(255, 0, 0)), DELAY(80), COLOR(350, var_82_5)), arg_82_0.vars.model)
		arg_82_0.vars.cs_list:onDamage(arg_82_1)
	end
	
	arg_82_0:updateHP()
	arg_82_0.vars.cs_list:updateBonusStats()
end

function RumbleUnit.heal(arg_83_0, arg_83_1)
	if not arg_83_0.vars then
		return 
	end
	
	if arg_83_0:isDead() then
		return 
	end
	
	arg_83_1 = math.floor(arg_83_1)
	
	if arg_83_1 > 0 then
		arg_83_0:addDamageInfo({
			heal = arg_83_1
		})
		
		arg_83_0.status.cur_hp = arg_83_0.status.cur_hp + arg_83_1
		
		if arg_83_0.status.cur_hp > arg_83_0.status.max_hp then
			arg_83_0.status.cur_hp = arg_83_0.status.max_hp
		end
		
		arg_83_0:playEffect(arg_83_0, {
			0,
			"Unit_Self",
			"heal_hp_01"
		}, {
			bone = "target",
			scale = var_0_1
		})
	end
	
	arg_83_0:updateHP()
	arg_83_0.vars.cs_list:updateBonusStats()
end

function RumbleUnit.addDamageInfo(arg_84_0, arg_84_1)
	if not arg_84_0.vars then
		return 
	end
	
	if not arg_84_1 then
		return 
	end
	
	if not arg_84_0.vars.damage_list then
		arg_84_0.vars.damage_list = {}
	end
	
	table.insert(arg_84_0.vars.damage_list, arg_84_1)
end

function RumbleUnit.clearDamageInfo(arg_85_0)
	if not arg_85_0.vars then
		return 
	end
	
	arg_85_0.vars.damage_list = {}
end

function RumbleUnit.showInfoText(arg_86_0)
	if not arg_86_0.vars or not arg_86_0.vars.damage_list then
		return 
	end
	
	local var_86_0 = 0
	local var_86_1 = 0
	local var_86_2 = false
	
	for iter_86_0, iter_86_1 in ipairs(arg_86_0.vars.damage_list) do
		if iter_86_1.heal then
			var_86_0 = var_86_0 + iter_86_1.heal
		elseif iter_86_1.damage then
			var_86_1 = var_86_1 + iter_86_1.damage
		end
		
		if iter_86_1.critical then
			var_86_2 = true
		end
	end
	
	if var_86_0 > 0 then
		RumbleUnitText:create(arg_86_0, {
			heal = var_86_0
		})
	end
	
	if var_86_1 > 0 then
		RumbleUnitText:create(arg_86_0, {
			damage = var_86_1,
			critical = var_86_2
		})
	end
	
	table.clear(arg_86_0.vars.damage_list)
end

function RumbleUnit.getRole(arg_87_0)
	return arg_87_0.db and arg_87_0.db.rol
end

function RumbleUnit.getCamp(arg_88_0)
	return arg_88_0.db and arg_88_0.db.camp
end

function RumbleUnit.getHPRatio(arg_89_0)
	if not arg_89_0.status then
		return 0
	end
	
	if not arg_89_0.status.max_hp or arg_89_0.status.max_hp <= 0 then
		return 0
	end
	
	return arg_89_0.status.cur_hp / arg_89_0.status.max_hp
end

function RumbleUnit.getShield(arg_90_0)
	if not arg_90_0.vars then
		return 0
	end
	
	local var_90_0 = arg_90_0.vars.cs_list:getShield()
	
	if not var_90_0 then
		return 0
	end
	
	return var_90_0:getShieldAmount() or 0
end

function RumbleUnit.getShieldRatio(arg_91_0)
	if not arg_91_0.status then
		return 0
	end
	
	local var_91_0 = arg_91_0:getShield()
	
	return var_91_0 / (arg_91_0.status.max_hp + var_91_0)
end

function RumbleUnit.getSPRatio(arg_92_0)
	if not arg_92_0.vars then
		return 0
	end
	
	if not arg_92_0.vars.skills then
		return 0
	end
	
	if not arg_92_0.vars.skills[2] then
		return 0
	end
	
	return arg_92_0.vars.skills[2]:getSPRatio()
end

function RumbleUnit.getBaseStat(arg_93_0, arg_93_1)
	if not arg_93_0.db then
		return 0
	end
	
	local var_93_0 = 1e-09
	local var_93_1 = arg_93_0:getDevotePower(arg_93_1)
	
	return {
		crc = 0.15,
		crd = 1.5,
		atk = math.floor(to_n(arg_93_0.db.atk) * var_93_1 + var_93_0),
		hp = math.floor(to_n(arg_93_0.db.hp) * var_93_1 + var_93_0),
		def = to_n(arg_93_0.db.def),
		atk_spd = to_n(arg_93_0.db.atk_spd)
	}
end

function RumbleUnit.getStats(arg_94_0)
	return {
		atk = arg_94_0:getStatAttack(),
		def = arg_94_0:getStatDefense(),
		hp = arg_94_0.status and arg_94_0.status.cur_hp or arg_94_0:getMaxHp(),
		atk_spd = arg_94_0:getAttackSpeed(),
		crc = arg_94_0:getCriticalChance(),
		crd = arg_94_0:getCriticalDamage()
	}
end

function RumbleUnit.getStat(arg_95_0, arg_95_1)
	if not arg_95_0.status or not arg_95_0.status[arg_95_1] then
		return 0
	end
	
	local var_95_0 = to_n(arg_95_0.status[arg_95_1])
	local var_95_1 = arg_95_0.vars.cs_list:getBonusStats() or {}
	
	if var_95_1[arg_95_1 .. "_rate"] then
		var_95_0 = var_95_0 * (1 + var_95_1[arg_95_1 .. "_rate"])
	end
	
	if var_95_1[arg_95_1] then
		var_95_0 = var_95_0 + var_95_1[arg_95_1]
	end
	
	return var_95_0
end

function RumbleUnit.getStatAttack(arg_96_0)
	return arg_96_0:getStat("atk")
end

function RumbleUnit.getStatDefense(arg_97_0)
	return arg_97_0:getStat("def")
end

function RumbleUnit.getAttackSpeed(arg_98_0)
	return arg_98_0:getStat("atk_spd")
end

function RumbleUnit.getCriticalChance(arg_99_0)
	return arg_99_0:getStat("crc")
end

function RumbleUnit.getCriticalDamage(arg_100_0)
	return arg_100_0:getStat("crd")
end

function RumbleUnit.getMaxHp(arg_101_0)
	return arg_101_0:getStat("hp")
end

function RumbleUnit.getCurHp(arg_102_0)
	return arg_102_0:getStat("cur_hp")
end

function RumbleUnit.getBonusRange(arg_103_0)
	return arg_103_0.vars.cs_list:getBonusStat("range")
end

function RumbleUnit.getBonusPower(arg_104_0)
	return arg_104_0.vars.cs_list:getBonusStat("pow")
end

function RumbleUnit.getBonusGold(arg_105_0)
	return arg_105_0.vars.cs_list:getBonusStat("gold")
end

function RumbleUnit.dead(arg_106_0)
	if not arg_106_0.vars then
		return 
	end
	
	if RumbleSystem:isPaused() then
		return 
	end
	
	if arg_106_0.vars.cs_list then
		arg_106_0.vars.cs_list:onDead()
		arg_106_0.vars.cs_list:clear()
	end
	
	if get_cocos_refid(arg_106_0.vars.gauge) then
		arg_106_0.vars.gauge:dead()
	end
	
	if arg_106_0.vars.followers then
		for iter_106_0, iter_106_1 in ipairs(arg_106_0.vars.followers) do
			if get_cocos_refid(iter_106_1) then
				BattleAction:Add(SEQ(FADE_OUT(500), REMOVE()), iter_106_1)
			end
		end
	end
	
	if RumbleUnitPopup:getUnit() == arg_106_0 then
		RumbleUnitPopup:close()
	end
	
	arg_106_0:setState(var_0_2.Dead)
	RumbleSystem:checkEndBattle()
end

function RumbleUnit.revive(arg_107_0, arg_107_1)
	if not arg_107_0.vars then
		return 
	end
	
	arg_107_0.vars.state = nil
	
	arg_107_0:setState(var_0_2.Idle)
	
	arg_107_0.vars.gauge = RumbleUnitGauge:create(arg_107_0)
	
	local var_107_0 = RumbleBoard:getPlacablePos(arg_107_0:getPosition() or {
		x = 1,
		y = 1
	}, arg_107_0:getTeam())
	
	setBlendColor2(arg_107_0.vars.model, "def")
	arg_107_0.vars.model:setColor(arg_107_0:getAmbientColor())
	arg_107_0.vars.model:setOpacity(255)
	arg_107_0:setPosition(var_107_0)
	arg_107_0:applyPassiveSkills()
	RumbleSynergy:applySynergyToUnit(arg_107_0)
	arg_107_0:playEffect(arg_107_0, {
		0,
		"Unit_Self",
		"rescue_success"
	})
	arg_107_0:heal(arg_107_1)
end

function RumbleUnit.stun(arg_108_0)
	if not arg_108_0.vars then
		return 
	end
	
	arg_108_0:setState(var_0_2.Stun)
end

function RumbleUnit.recover(arg_109_0)
	if not arg_109_0.vars then
		return 
	end
	
	arg_109_0:setState(var_0_2.Idle)
end

function RumbleUnit.isDead(arg_110_0)
	if not arg_110_0.vars then
		return false
	end
	
	if not arg_110_0.vars.state then
		return false
	end
	
	if arg_110_0.vars.state.type == var_0_2.Dead then
		return true
	end
	
	return false
end

function RumbleUnit.getTeam(arg_111_0)
	return arg_111_0.vars and arg_111_0.vars.team
end

function RumbleUnit.isEnemy(arg_112_0)
	return arg_112_0.vars and arg_112_0.vars.team == 2
end

function RumbleUnit.isCreature(arg_113_0)
	return arg_113_0.vars and arg_113_0.vars.is_creature
end

function RumbleUnit.remove(arg_114_0)
	if not arg_114_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_114_0.vars.model) then
		BattleAction:Remove(arg_114_0.vars.model)
		arg_114_0.vars.model:removeFromParent()
	end
	
	arg_114_0.vars.model = nil
	
	if get_cocos_refid(arg_114_0.vars.gauge) then
		arg_114_0.vars.gauge:removeFromParent()
	end
	
	arg_114_0.vars.gauge = nil
	
	if get_cocos_refid(arg_114_0.vars.info_ui) then
		arg_114_0.vars.info_ui:removeFromParent()
	end
	
	arg_114_0.vars.info_ui = nil
	
	if get_cocos_refid(arg_114_0.vars.node) then
		arg_114_0.vars.node:removeFromParent()
	end
	
	arg_114_0.vars.node = nil
	arg_114_0.vars.state = nil
	
	if arg_114_0.vars.cs_list then
		arg_114_0.vars.cs_list:clear()
	end
	
	if arg_114_0:isEnemy() then
		arg_114_0.vars = nil
		arg_114_0.db = nil
		arg_114_0.status = nil
	end
end

function RumbleUnit.addDevote(arg_115_0)
	if not arg_115_0.vars then
		return 
	end
	
	arg_115_0.vars.devote = (arg_115_0.vars.devote or 0) + 1
	
	if get_cocos_refid(arg_115_0.vars.info_ui) then
		arg_115_0.vars.info_ui:setDevoteGrade(arg_115_0:getDevoteGrade())
	end
	
	arg_115_0:updateStat()
end

function RumbleUnit.playDevoteEffect(arg_116_0)
	if not arg_116_0.vars then
		return 
	end
	
	local var_116_0 = arg_116_0:getUnitNode()
	
	if not get_cocos_refid(var_116_0) then
		RumbleBench:playDevoteEffect(arg_116_0)
		
		return 
	end
	
	local var_116_1 = EffectManager:Play({
		pivot_z = 1,
		fn = "ui_super_battle_buff_f.cfx",
		layer = var_116_0
	})
	local var_116_2 = EffectManager:Play({
		pivot_z = -1,
		fn = "ui_super_battle_buff_b.cfx",
		layer = var_116_0
	})
	
	if_set_opacity(var_116_1, nil, 110)
	if_set_opacity(var_116_2, nil, 150)
end

function RumbleUnit.playSynergyEffect(arg_117_0)
	local var_117_0 = arg_117_0:getUnitNode()
	
	if not get_cocos_refid(var_117_0) then
		return 
	end
	
	local var_117_1 = 0.5
	local var_117_2 = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_hero_config_buffpos_front.cfx",
		pivot_y = 0,
		pivot_z = 1,
		layer = var_117_0,
		scale = var_117_1
	})
	local var_117_3 = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_hero_config_buffpos_back.cfx",
		pivot_y = 0,
		pivot_z = -1,
		layer = var_117_0,
		scale = var_117_1
	})
	
	if_set_opacity(var_117_2, nil, 110)
	if_set_opacity(var_117_3, nil, 150)
	var_117_2:setName("@effect_front")
	var_117_3:setName("@effect_back")
end

function RumbleUnit.removeSynergyEffect(arg_118_0)
	local var_118_0 = arg_118_0:getUnitNode()
	
	if not get_cocos_refid(var_118_0) then
		return 
	end
	
	local var_118_1 = var_118_0:getChildByName("@effect_front")
	
	if get_cocos_refid(var_118_1) then
		var_118_1:removeFromParent()
	end
	
	local var_118_2 = var_118_0:getChildByName("@effect_back")
	
	if get_cocos_refid(var_118_2) then
		var_118_2:removeFromParent()
	end
end

function RumbleUnit.playBuffEffect(arg_119_0, arg_119_1, arg_119_2)
	local var_119_0 = arg_119_0:getUnitNode()
	
	if not get_cocos_refid(var_119_0) then
		return 
	end
	
	arg_119_0:removeBuffEffect(arg_119_1)
	
	local var_119_1, var_119_2 = arg_119_0:getBonePosition(arg_119_2 or "top")
	local var_119_3 = 0.6
	
	EffectManager:Play({
		pivot_x = 0,
		pivot_z = 1,
		fn = "stse_" .. arg_119_1 .. ".cfx",
		layer = var_119_0,
		pivot_y = var_119_2,
		scale = var_119_3
	}):setName("@effect_" .. arg_119_1)
end

function RumbleUnit.removeBuffEffect(arg_120_0, arg_120_1)
	local var_120_0 = arg_120_0:getUnitNode()
	
	if not get_cocos_refid(var_120_0) then
		return 
	end
	
	local var_120_1 = var_120_0:getChildByName("@effect_" .. arg_120_1)
	
	if get_cocos_refid(var_120_1) and not BattleAction:Find(var_120_1) then
		BattleAction:Add(SEQ(FADE_OUT(400), REMOVE()), var_120_1)
		var_120_1:setName("")
	end
end

function RumbleUnit.getGrade(arg_121_0)
	return arg_121_0.db and arg_121_0.db.grade or 3
end

function RumbleUnit.getDevote(arg_122_0, arg_122_1)
	if not arg_122_0.vars then
		return 0
	end
	
	local var_122_0 = arg_122_0.vars.devote or 0
	
	if not arg_122_1 and arg_122_0.vars.cs_list then
		var_122_0 = var_122_0 + arg_122_0.vars.cs_list:getBonusStat("devote")
	end
	
	local var_122_1 = 7 - (arg_122_0.db and DB("character", arg_122_0.db.base_chr, "grade") or 3) + 3
	
	return math.min(var_122_0, var_122_1)
end

function RumbleUnit.getDevoteGrade(arg_123_0, arg_123_1, arg_123_2)
	if not arg_123_0.vars then
		return "none"
	end
	
	local var_123_0 = arg_123_1 or arg_123_0:getDevote(arg_123_2)
	
	return RumbleUtil:getDevoteGrade(arg_123_0:getCode(), var_123_0)
end

function RumbleUnit.getDevoteSkill(arg_124_0)
	return nil, arg_124_0:getDevote()
end

function RumbleUnit.isMaxDevoteLevel(arg_125_0)
	return arg_125_0:getDevoteGrade(nil, true) == "SSS"
end

function RumbleUnit.getDevotePower(arg_126_0, arg_126_1)
	if arg_126_0.vars and arg_126_0.vars.power_rate then
		return arg_126_0.vars.power_rate
	end
	
	if not arg_126_0.db or not arg_126_0.db.memory_imprint_rate then
		return 1
	end
	
	return 1 + arg_126_0.db.memory_imprint_rate * (arg_126_1 or arg_126_0:getDevote())
end

function RumbleUnit.getSellPrice(arg_127_0, arg_127_1)
	local var_127_0 = arg_127_0.db.grade or 3
	local var_127_1 = RumbleSystem:getConfig("rumble_sell_" .. var_127_0 .. "stars")
	
	arg_127_1 = arg_127_1 or arg_127_0:getDevote(true)
	
	return (arg_127_1 + 1) * var_127_1
end

function RumbleUnit.getBuffList(arg_128_0)
	return arg_128_0.vars and arg_128_0.vars.cs_list
end

function RumbleUnit.addBuff(arg_129_0, arg_129_1, arg_129_2)
	if not arg_129_0.vars or not arg_129_0.vars.cs_list then
		return 
	end
	
	arg_129_0.vars.cs_list:add(arg_129_1, arg_129_2)
end

function RumbleUnit.onAttack(arg_130_0, arg_130_1)
	if not arg_130_0.vars or not arg_130_0.vars.cs_list then
		return 
	end
	
	arg_130_0.vars.cs_list:onAttack(arg_130_1)
end

function RumbleUnit.onKill(arg_131_0)
	if not arg_131_0.vars or not arg_131_0.vars.cs_list then
		return 
	end
	
	arg_131_0.vars.cs_list:onKill()
end

function RumbleUnit.isHide(arg_132_0)
	if not arg_132_0.vars then
		return 
	end
	
	if not arg_132_0.vars.cs_list then
		return false
	end
	
	return arg_132_0.vars.cs_list:isExistHide()
end

function RumbleUnit.isImmuned(arg_133_0)
	if not arg_133_0.vars then
		return 
	end
	
	if not arg_133_0.vars.cs_list then
		return false
	end
	
	return arg_133_0.vars.cs_list:isImmuned()
end

function RumbleUnit.onUpdateBuff(arg_134_0)
	if not arg_134_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_134_0.vars.info_ui) then
		arg_134_0.vars.info_ui:setDevoteGrade(arg_134_0:getDevoteGrade())
	end
	
	if get_cocos_refid(arg_134_0.vars.gauge) then
		arg_134_0.vars.gauge:updateAll()
	end
	
	if RumbleUnitPopup:getUnit() == arg_134_0 then
		RumbleUnitPopup:updateInfo()
	end
end
