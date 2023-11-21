local var_0_0 = 75

WALK_SPEED = 400
MOVER_WALK_RATE = 1
BattleLayout = {}
BattleLayout.CENTER = 1
BattleLayout.OUR_CENTER = 2
BattleLayout.FOR_CENTER = 3
BattleLayout.OUR_FRONT = 4
BattleLayout.FOR_FRONT = 5

local var_0_1 = 0.24
local var_0_2 = 0.34
local var_0_3 = 0.24
local var_0_4 = 0.5 - var_0_3

BATTLE_LAYOUT = {}

setmetatable(BATTLE_LAYOUT, {
	__index = function(arg_1_0, arg_1_1)
		return rawget(arg_1_0.var, arg_1_1)()
	end
})

BATTLE_LAYOUT.var = {
	TEAM_WIDTH = function()
		return DESIGN_WIDTH * 0.22
	end,
	TEAM_HEIGHT = function()
		return DESIGN_HEIGHT * 0.25
	end,
	TEAM_FRONT = function()
		return DESIGN_WIDTH * 0.11
	end,
	TEAM_Y = function()
		return DESIGN_HEIGHT * 0.25
	end,
	XDIST_FROM_FOCUS = function()
		return DESIGN_WIDTH * var_0_3
	end,
	XDIST_FROM_SIDE = function()
		return DESIGN_WIDTH * var_0_4
	end,
	CONTENTS_GAP = function()
		return DESIGN_WIDTH * var_0_1 - DESIGN_WIDTH * var_0_3
	end
}
BattleConstants = {}

function BattleConstants.setMode(arg_9_0, arg_9_1)
	if arg_9_1 == "crehunt" then
		CAM_READY_SCALE = 0.8
		var_0_3 = var_0_2
	else
		CAM_READY_SCALE = 1.15
		var_0_3 = var_0_1
	end
end

function BattleConstants.debug(arg_10_0)
	return {
		CAM_READY_SCAL = CAM_READY_SCALE,
		XRATE_FROM_FOCUS = var_0_3
	}
end

local var_0_5 = ClassDef()

function var_0_5.constructor(arg_11_0, arg_11_1)
	arg_11_0.vars = {}
	arg_11_0.vars.unit = arg_11_1
	arg_11_0.vars.speed = WALK_SPEED
end

function var_0_5.clone(arg_12_0, arg_12_1)
	local var_12_0 = var_0_5(arg_12_1)
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars) do
		if type(iter_12_1) == "number" or type(iter_12_1) == "string" then
			var_12_0.vars[iter_12_0] = iter_12_1
		end
	end
	
	return var_12_0
end

function var_0_5.setSpeed(arg_13_0, arg_13_1)
	arg_13_0.vars.speed = arg_13_1
end

function var_0_5.getSpeed(arg_14_0)
	return arg_14_0.vars.speed
end

function var_0_5.getPosition(arg_15_0)
	return arg_15_0.vars.x, arg_15_0.vars.y
end

function var_0_5.setDirection(arg_16_0, arg_16_1)
	local var_16_0
	
	var_16_0 = arg_16_1 ~= arg_16_0.vars.dir
	arg_16_0.vars.dir = math.normalize(arg_16_1, 1)
	
	local var_16_1 = arg_16_0.vars.unit
	
	if var_16_1.isMoverPaused and var_16_1:isMoverPaused() then
		return 
	end
	
	if get_cocos_refid(var_16_1.model) then
		var_16_1.model:setScaleX(arg_16_0.vars.dir * math.abs(var_16_1.model:getScaleX()))
		var_16_1.model:foreachTimelineObject(function(arg_17_0)
			if arg_17_0 and get_cocos_refid(arg_17_0) and type(arg_17_0.setScaleX) == "function" then
				arg_17_0:setScaleX(arg_16_0.vars.dir * math.abs(arg_17_0:getScaleX()))
			end
		end)
	end
end

function var_0_5.refresh(arg_18_0)
	local var_18_0 = arg_18_0.vars.unit
	
	if get_cocos_refid(var_18_0.model) then
		var_18_0.model:setPosition(var_18_0.x, var_18_0.y)
		var_18_0.model:setScaleX(arg_18_0.vars.dir * math.abs(var_18_0.model:getScaleX()))
	end
end

function var_0_5.setPosition(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0.vars.target_x, arg_19_0.vars.target_y = arg_19_1, arg_19_2
	
	arg_19_0:_setInterpolatedPosition(arg_19_1, arg_19_2)
end

function var_0_5._setInterpolatedPosition(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_1 then
		arg_20_0.vars.x = arg_20_1
	end
	
	if arg_20_2 then
		arg_20_0.vars.y = arg_20_2
	end
	
	local var_20_0 = arg_20_0.vars.unit
	
	if get_cocos_refid(var_20_0.model) and (not var_20_0.isMoverPaused or not var_20_0:isMoverPaused()) then
		if arg_20_1 then
			var_20_0.model:setPositionX(arg_20_1)
		end
		
		if arg_20_2 then
			var_20_0.model:setPositionY(arg_20_2)
		end
	end
end

function var_0_5.moveTo(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0.vars.target_x = arg_21_1
	arg_21_0.vars.target_y = arg_21_2
	arg_21_0.vars.target_dir = math.normalize(arg_21_3, 1)
end

function var_0_5.stopScheduler(arg_22_0)
	arg_22_0:setAniState(nil)
	arg_22_0:updateInstanceAni()
end

function var_0_5.onUpdateStory(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:getSpeed()
	local var_23_1 = var_0_0 * arg_23_1
	
	if arg_23_0.vars.elapsed_time and var_23_0 <= arg_23_0.vars.elapsed_time then
		arg_23_0:_setInterpolatedPosition(arg_23_0.vars.target_x, arg_23_0.vars.target_y)
	elseif arg_23_0.vars.target_x ~= arg_23_0.vars.x or arg_23_0.vars.target_y ~= arg_23_0.vars.y then
		if not arg_23_0.vars.tx then
			arg_23_0.vars.tx = arg_23_0.vars.x
			arg_23_0.vars.ty = arg_23_0.vars.y
			arg_23_0.vars.elapsed_time = 0
		end
		
		local var_23_2 = (arg_23_0.vars.elapsed_time + var_23_1) / var_23_0
		local var_23_3 = math.floor((arg_23_0.vars.target_x - arg_23_0.vars.tx) * var_23_2 + arg_23_0.vars.tx)
		local var_23_4 = (arg_23_0.vars.target_y - arg_23_0.vars.ty) * var_23_2 + arg_23_0.vars.ty
		
		arg_23_0:_setInterpolatedPosition(var_23_3, var_23_4)
		arg_23_0:setDirection(arg_23_0.vars.target_dir)
		
		if not arg_23_0:getAniState() then
			arg_23_0:setAniState(arg_23_0:getAniStateOnStory() or "run")
			arg_23_0:updateInstanceAni()
		end
		
		arg_23_0.vars.elapsed_time = arg_23_0.vars.elapsed_time + var_23_1
		
		return 
	end
	
	arg_23_0.vars.tx = nil
	arg_23_0.vars.ty = nil
	arg_23_0.vars.elapsed_time = nil
	
	if arg_23_0:getAniState() then
		arg_23_0:setAniState(nil)
		arg_23_0:setDirection(arg_23_0.vars.target_dir)
		arg_23_0:updateInstanceAni()
	end
end

function var_0_5.onUpdate(arg_24_0, arg_24_1)
	if arg_24_0.vars.target_x ~= arg_24_0.vars.x or arg_24_0.vars.target_y ~= arg_24_0.vars.y then
		local var_24_0 = arg_24_0.vars.x or 0
		local var_24_1 = arg_24_0.vars.y or 0
		local var_24_2 = arg_24_0.vars.target_x - var_24_0
		local var_24_3 = arg_24_0.vars.target_y - var_24_1
		local var_24_4 = math.normalize(var_24_2, 1)
		
		if not arg_24_0.vars.target_distance or arg_24_0.vars.target_distance < var_24_2 * var_24_4 then
			arg_24_0.vars.target_distance = math.abs(var_24_2)
		end
		
		local var_24_5 = arg_24_1 * arg_24_0.vars.target_distance + arg_24_1 * (WALK_SPEED * MOVER_WALK_RATE)
		
		if var_24_5 < math.abs(var_24_2) then
			var_24_2 = var_24_5 * var_24_4
		end
		
		arg_24_0:_setInterpolatedPosition(var_24_0 + var_24_2, var_24_1 + var_24_3)
		arg_24_0:setDirection(arg_24_0.vars.target_dir)
		
		if not arg_24_0:getAniState() then
			arg_24_0:setAniState("run")
			arg_24_0:updateInstanceAni()
		end
		
		return 
	end
	
	arg_24_0.vars.target_distance = nil
	
	if arg_24_0:getAniState() then
		arg_24_0:setAniState(nil)
		arg_24_0:setDirection(arg_24_0.vars.target_dir)
		arg_24_0:updateInstanceAni()
	end
end

function var_0_5.updateInstanceAni(arg_25_0)
	local var_25_0 = arg_25_0:getAniState() or arg_25_0:getIdleAniStateOnStory() or "idle"
	local var_25_1 = arg_25_0.vars.unit
	
	if not get_cocos_refid(var_25_1.model) then
		return 
	end
	
	if var_25_1.isDead and var_25_1:isDead() then
		return 
	end
	
	if var_25_1.isMoverPaused and var_25_1:isMoverPaused() then
		return 
	end
	
	if var_25_0 == "run" then
		var_25_1.model:playRunAnimation()
	else
		var_25_1.model:setAnimation(0, var_25_0, true)
	end
	
	var_25_1.model:setScaleX(arg_25_0.vars.dir * math.abs(var_25_1.model:getScaleX()))
end

function var_0_5.setAniState(arg_26_0, arg_26_1)
	arg_26_0.vars.ani_state = arg_26_1
end

function var_0_5.getAniState(arg_27_0)
	return arg_27_0.vars.ani_state
end

function var_0_5.setAniStateOnStory(arg_28_0, arg_28_1)
	arg_28_0.vars.story_ani_state = arg_28_1
end

function var_0_5.getAniStateOnStory(arg_29_0)
	return arg_29_0.vars.story_ani_state
end

function var_0_5.setIdleAniStateOnStory(arg_30_0, arg_30_1)
	arg_30_0.vars.story_idle_ani_state = arg_30_1 or "idle"
end

function var_0_5.getIdleAniStateOnStory(arg_31_0)
	return arg_31_0.vars.story_idle_ani_state or "idle"
end

WorldBossLayout = ClassDef()

function WorldBossLayout.build(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = {}
	local var_32_1 = DESIGN_WIDTH / 2
	
	local function var_32_2(arg_33_0)
		return var_32_1 - (arg_33_0 - var_32_1)
	end
	
	local var_32_3 = sp.SkeletonAnimation:create(arg_32_2)
	
	if not get_cocos_refid(var_32_3) then
		return 
	end
	
	local var_32_4 = {}
	
	for iter_32_0 = 1, table.count(arg_32_1) do
		local var_32_5 = arg_32_1[iter_32_0]
		local var_32_6 = var_32_3:getBoneNode("node" .. var_32_5.inst.pos)
		
		var_32_6:setInheritScale(true)
		var_32_6:setInheritRotation(true)
		table.insert(var_32_4, var_32_6)
	end
	
	BGI.game_layer:addChild(var_32_3)
	
	local var_32_7 = var_32_3:setAnimation(0, "animation", false)
	
	if not var_32_7 then
		return 
	end
	
	var_32_7.timeScale = 1
	
	var_32_3:update(0)
	
	for iter_32_1 = 1, table.count(var_32_4) do
		local var_32_8 = arg_32_1[iter_32_1]
		local var_32_9 = var_32_4[iter_32_1]
		local var_32_10, var_32_11 = var_32_9:getPosition()
		local var_32_12 = math.abs(var_32_9:getScaleX())
		local var_32_13 = var_32_9:getScaleY()
		local var_32_14 = math.floor(var_32_10 * BASE_SCALE + DESIGN_WIDTH / 2)
		local var_32_15 = math.floor(var_32_11 * BASE_SCALE + DESIGN_HEIGHT / 2)
		
		if BattleLayout:getDirection() < 0 then
			var_32_14 = var_32_2(var_32_14)
		end
		
		local var_32_16 = var_32_9:getLocalZOrder() - var_32_15
		
		if arg_32_3 then
			var_32_16 = -1000
		end
		
		table.insert(var_32_0, {
			unit = var_32_8,
			x = var_32_14,
			y = var_32_15,
			z = var_32_16,
			sx = var_32_12,
			sy = var_32_13,
			is_worldboss = arg_32_3
		})
	end
	
	var_32_3:removeFromParent()
	
	return var_32_0
end

function WorldBossLayout.constructor(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.vars = {}
	arg_34_0.vars.x = 0
	arg_34_0.vars.y = 0
	arg_34_0.vars.z = 0
	arg_34_0.vars.ally = arg_34_2
	arg_34_0.vars.slots = arg_34_1
	arg_34_0.vars.visible = true
	arg_34_0.vars.offsets = {}
	
	arg_34_0:init()
end

function WorldBossLayout.init(arg_35_0)
	for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.slots) do
		local var_35_0 = iter_35_1.unit
		
		var_35_0.dir = arg_35_0:getDirection()
		var_35_0.init_x = iter_35_1.x
		var_35_0.init_y = iter_35_1.y
		var_35_0.init_z = iter_35_1.z
		var_35_0.x = var_35_0.init_x
		var_35_0.y = var_35_0.init_y
		var_35_0.z = var_35_0.init_z
		var_35_0.sx = iter_35_1.sx
		var_35_0.sy = iter_35_1.sy
		var_35_0.rot = 0
	end
	
	local var_35_1 = arg_35_0.vars.slots[1]
	local var_35_2 = var_35_1.x
	local var_35_3 = var_35_1.x
	local var_35_4 = var_35_1.y
	local var_35_5 = var_35_1.y
	
	for iter_35_2, iter_35_3 in pairs(arg_35_0.vars.slots) do
		local var_35_6 = iter_35_3.x
		local var_35_7 = iter_35_3.y
		
		if var_35_6 < var_35_2 then
			var_35_2 = var_35_6
		end
		
		if var_35_3 < var_35_6 then
			var_35_3 = var_35_6
		end
		
		if var_35_7 < var_35_4 then
			var_35_4 = var_35_7
		end
		
		if var_35_5 < var_35_7 then
			var_35_5 = var_35_7
		end
	end
	
	if var_35_2 == var_35_3 then
		arg_35_0.vars.x = var_35_2
		arg_35_0.vars.y = var_35_4
	else
		arg_35_0.vars.x = (var_35_2 + var_35_3) / 2
		arg_35_0.vars.y = (var_35_4 + var_35_5) / 2
	end
	
	arg_35_0.vars.z = 0
end

function WorldBossLayout.updatePose(arg_36_0)
end

function WorldBossLayout.updateModelPose(arg_37_0, arg_37_1)
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.slots) do
		local var_37_0 = iter_37_1.unit
		local var_37_1 = var_37_0.model
		local var_37_2 = math.normalize(BattleLayout:getDirection() * arg_37_0:getDirection(), 1)
		
		if get_cocos_refid(var_37_1) then
			var_37_1:setPosition(var_37_0.x, var_37_0.y)
			var_37_1:setLocalZOrder(var_37_0.z)
			var_37_1:setScaleX((var_37_0.sx or 1) * var_37_2)
			var_37_1:setScaleY(var_37_0.sy or 1)
			var_37_1:setRotation(var_37_0.rot or 0)
		end
	end
end

function WorldBossLayout.getUnits(arg_38_0)
	local var_38_0 = {}
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.slots) do
		table.insert(var_38_0, iter_38_1.unit)
	end
	
	return var_38_0
end

function WorldBossLayout.getAlly(arg_39_0)
	return arg_39_0.vars.ally
end

function WorldBossLayout.getLocalZOrder(arg_40_0)
	return arg_40_0.vars.z
end

function WorldBossLayout.setPosition(arg_41_0, arg_41_1, arg_41_2)
	arg_41_0.vars.x, arg_41_0.vars.y = arg_41_1, arg_41_2
end

function WorldBossLayout.getPosition(arg_42_0)
	return arg_42_0.vars.x, arg_42_0.vars.y
end

function WorldBossLayout.getDirection(arg_43_0)
	return arg_43_0.vars.dir or 1
end

function WorldBossLayout.setDirection(arg_44_0, arg_44_1)
	arg_44_0.vars.dir = arg_44_1
end

function WorldBossLayout.setRotation(arg_45_0, arg_45_1)
	arg_45_0.vars.rotation = arg_45_1
end

function WorldBossLayout.getRotation(arg_46_0)
	return arg_46_0.vars.rotation or 0
end

function WorldBossLayout.getScaleX(arg_47_0)
	return arg_47_0.vars.sx or arg_47_0:getDirection() * BattleLayout:getDirection()
end

function WorldBossLayout.getScaleY(arg_48_0)
	return arg_48_0.vars.sy or 1
end

function WorldBossLayout.setScaleX(arg_49_0, arg_49_1)
	arg_49_0.vars.sx = arg_49_1
end

function WorldBossLayout.setScaleY(arg_50_0, arg_50_1)
	arg_50_0.vars.sy = arg_50_1
end

function WorldBossLayout.getWorldPosition(arg_51_0)
	local var_51_0, var_51_1 = arg_51_0:getOffset()
	
	return arg_51_0.vars.x + var_51_0, arg_51_0.vars.y + var_51_1
end

function WorldBossLayout.getFrontDistance(arg_52_0)
	return (BATTLE_LAYOUT.TEAM_WIDTH / 2 + BATTLE_LAYOUT.TEAM_FRONT) * (arg_52_0:getDirection() * BattleLayout:getDirection())
end

function WorldBossLayout.setOffset(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	if arg_53_3 then
		if (arg_53_1 or 0) == 0 and (arg_53_2 or 0) == 0 then
			arg_53_0.vars.offsets[arg_53_3] = nil
		else
			arg_53_0.vars.offsets[arg_53_3] = {
				arg_53_1 or 0,
				arg_53_2 or 0
			}
		end
	else
		arg_53_0.vars.offset_x, arg_53_0.vars.offset_y = arg_53_1, arg_53_2
	end
end

function WorldBossLayout.getOffset(arg_54_0)
	if arg_54_0.vars.disable_offset then
		return 0, 0
	end
	
	local var_54_0 = 0
	local var_54_1 = 0
	
	for iter_54_0, iter_54_1 in pairs(arg_54_0.vars.offsets) do
		var_54_0 = var_54_0 + iter_54_1[1]
		var_54_1 = var_54_1 + iter_54_1[2]
	end
	
	if var_54_0 == math.huge or var_54_1 == math.huge then
		var_54_0, var_54_1 = 0, 0
	end
	
	return var_54_0 + (arg_54_0.vars.offset_x or 0), var_54_1 + (arg_54_0.vars.offset_y or 0)
end

function WorldBossLayout.getUnitFieldPosition(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	return arg_55_1.x + (arg_55_2 or 0), arg_55_1.y + (arg_55_3 or 0)
end

function WorldBossLayout.setVisible(arg_56_0, arg_56_1)
	if arg_56_0.vars.visible ~= arg_56_1 then
		arg_56_0.vars.visible = arg_56_1
		
		arg_56_0:updateVisible()
	end
end

function WorldBossLayout.isVisible(arg_57_0)
	return arg_57_0.vars.visible
end

function WorldBossLayout.updateVisible(arg_58_0)
	local var_58_0 = arg_58_0:isVisible()
	
	for iter_58_0, iter_58_1 in pairs(arg_58_0.vars.slots) do
		local var_58_1 = iter_58_1.unit
		
		if get_cocos_refid(var_58_1.model) then
			var_58_1.model:setVisible(var_58_0)
		end
	end
end

StoryUnitLayout = ClassDef()

function StoryUnitLayout.build(arg_59_0, arg_59_1)
	return (function()
		local var_60_0 = {}
		
		for iter_60_0, iter_60_1 in pairs(arg_59_1) do
			table.insert(var_60_0, {
				ry = 0,
				rx = 0,
				rz = 100,
				unit = iter_60_1
			})
		end
		
		return var_60_0
	end)()
end

function StoryUnitLayout.constructor(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
	arg_61_0.vars = {}
	arg_61_0.vars.x = 0
	arg_61_0.vars.y = 0
	arg_61_0.vars.z = 0
	arg_61_0.vars.init_x = 0
	arg_61_0.vars.init_y = 0
	arg_61_0.vars.init_sx = 1
	arg_61_0.vars.init_sy = 1
	arg_61_0.vars.uid = arg_61_3
	arg_61_0.vars.slots = arg_61_1
	arg_61_0.vars.dir = arg_61_4
	arg_61_0.vars.visible = true
	arg_61_0.vars.offsets = {}
	arg_61_0.vars.disable_rotation_self = false
	arg_61_0.vars.disable_rotation_team = false
	arg_61_0.vars.rotation_pivot = "root"
	
	arg_61_0:init(arg_61_4)
end

function StoryUnitLayout.init(arg_62_0, arg_62_1)
	local var_62_0 = BATTLE_LAYOUT.TEAM_WIDTH * 0.5
	local var_62_1 = BATTLE_LAYOUT.TEAM_HEIGHT * 0.5
	local var_62_2 = 0
	local var_62_3
	
	for iter_62_0, iter_62_1 in pairs(arg_62_0.vars.slots) do
		local var_62_4 = iter_62_1.unit
		
		if var_62_4.inst.line ~= var_62_3 and var_62_4.inst.line == BACK then
			var_62_3 = var_62_4.inst.line
			var_62_2 = var_62_2 - 1
		end
		
		iter_62_1.x = arg_62_0:getDirection()
		iter_62_1.y = iter_62_1.ry
		iter_62_1.z = iter_62_1.rz + var_62_2
		var_62_4.init_x = iter_62_1.x
		var_62_4.init_y = iter_62_1.y
		var_62_4.init_z = iter_62_1.z
		var_62_4.dir = arg_62_1
		var_62_4.x = var_62_4.init_x
		var_62_4.y = var_62_4.init_y
		var_62_4.z = var_62_4.init_z
		var_62_4.rot = arg_62_0:getRotation()
		var_62_4.mover = var_0_5(var_62_4)
	end
	
	arg_62_0:updatePose()
	
	DEBUG.TEST_LAYOUT = arg_62_0
end

function StoryUnitLayout.updatePose(arg_63_0)
	local var_63_0 = BATTLE_LAYOUT.TEAM_WIDTH * 0.5
	local var_63_1 = BATTLE_LAYOUT.TEAM_HEIGHT * 0.5
	local var_63_2, var_63_3 = arg_63_0:getPosition()
	local var_63_4, var_63_5 = arg_63_0:getOffset()
	local var_63_6 = var_63_2 + var_63_4
	local var_63_7 = var_63_3 + BATTLE_LAYOUT.TEAM_Y + var_63_5
	
	for iter_63_0, iter_63_1 in pairs(arg_63_0.vars.slots) do
		local var_63_8 = iter_63_1.unit
		
		var_63_8.dir = arg_63_0:getDirection()
		
		local var_63_9 = math.abs(arg_63_0:getScaleX())
		local var_63_10 = arg_63_0:getScaleY()
		local var_63_11 = math.rad(arg_63_0:getRotation() * arg_63_0:getDirection())
		local var_63_12 = 0
		local var_63_13 = 0
		
		if arg_63_0.vars.rotation_pivot == "target" then
			local var_63_14, var_63_15 = var_63_8.model:getBonePosition("target")
			local var_63_16, var_63_17 = var_63_8.model:getPosition()
			
			var_63_12, var_63_13 = var_63_14 - var_63_16, var_63_15 - var_63_17
		end
		
		local var_63_18 = var_63_0 * iter_63_1.rx * var_63_8.dir - var_63_12
		local var_63_19 = var_63_1 * iter_63_1.ry - var_63_13
		local var_63_20 = 0
		local var_63_21 = 0
		
		if arg_63_0.vars.disable_rotation_team then
			var_63_20, var_63_21 = var_63_18, var_63_19
		else
			var_63_20 = var_63_9 * (var_63_18 * math.cos(var_63_11) - var_63_19 * math.sin(var_63_11))
			var_63_21 = var_63_10 * (var_63_19 * math.cos(var_63_11) + var_63_18 * math.sin(var_63_11))
		end
		
		var_63_8.x = var_63_6 + var_63_20
		var_63_8.y = var_63_7 + var_63_21
		var_63_8.z = iter_63_1.z
		
		if not arg_63_0.vars.disable_rotation_self then
			var_63_8.rot = arg_63_0:getRotation()
		end
		
		var_63_8.sx = math.abs(var_63_9 * (var_63_8.db.scale or 1)) * arg_63_0:getDirection()
		var_63_8.sy = math.abs(var_63_10 * (var_63_8.db.scale or 1))
	end
end

function StoryUnitLayout.updateModelPose(arg_64_0, arg_64_1)
	if not arg_64_0:isVisible() then
		return 
	end
	
	arg_64_0.vars.lastUpdateCount = 0
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0.vars.slots) do
		local var_64_0 = iter_64_1.unit
		local var_64_1 = var_64_0.x
		local var_64_2 = var_64_0.y
		local var_64_3 = arg_64_0:getDirection()
		
		if get_cocos_refid(var_64_0.model) then
			var_64_0.model:setLocalZOrder(var_64_0.y * -1)
			
			if var_64_0.sx then
				var_64_0.model:setScaleX(var_64_0.sx or 1)
			end
			
			if var_64_0.sy then
				var_64_0.model:setScaleY(var_64_0.sy or 1)
			end
			
			if var_64_0.rot then
				var_64_0.model:setRotation(var_64_0.rot or 0)
			end
		end
		
		if arg_64_1 then
			var_64_0.mover:moveTo(var_64_1, var_64_2, var_64_3)
		else
			var_64_0.mover:setPosition(var_64_1, var_64_2)
			var_64_0.mover:setDirection(var_64_3)
		end
	end
end

function StoryUnitLayout.getUnits(arg_65_0)
	local var_65_0 = {}
	
	for iter_65_0, iter_65_1 in pairs(arg_65_0.vars.slots) do
		table.insert(var_65_0, iter_65_1.unit)
	end
	
	return var_65_0
end

function StoryUnitLayout.setRotationPivot(arg_66_0, arg_66_1)
	arg_66_0.vars.rotation_pivot = arg_66_1
end

function StoryUnitLayout.setDisableRotationSelf(arg_67_0, arg_67_1)
	arg_67_0.vars.disable_rotation_self = arg_67_1
end

function StoryUnitLayout.setDisableRotationTeam(arg_68_0, arg_68_1)
	arg_68_0.vars.disable_rotation_team = arg_68_1
end

function StoryUnitLayout.getAlly(arg_69_0)
	return arg_69_0.vars.ally or 1
end

function StoryUnitLayout.getLocalZOrder(arg_70_0)
	return arg_70_0.vars.z
end

function StoryUnitLayout.getInitScaleX(arg_71_0)
	return arg_71_0.vars.init_scale_x or arg_71_0:getDirection() * BattleLayout:getDirection()
end

function StoryUnitLayout.getInitScaleY(arg_72_0)
	return arg_72_0.vars.init_scale_y or 1
end

function StoryUnitLayout.initScale(arg_73_0)
	arg_73_0.vars.sx = arg_73_0:getInitScaleX()
	arg_73_0.vars.sy = arg_73_0:getInitScaleY()
end

function StoryUnitLayout.initPosition(arg_74_0)
end

function StoryUnitLayout.setPosition(arg_75_0, arg_75_1, arg_75_2)
	arg_75_0.vars.x, arg_75_0.vars.y = arg_75_1, arg_75_2
end

function StoryUnitLayout.getPosition(arg_76_0)
	return arg_76_0.vars.x, arg_76_0.vars.y
end

function StoryUnitLayout.setFuturePosition(arg_77_0, arg_77_1, arg_77_2)
	arg_77_0.vars.ft_x, arg_77_0.vars.ft_y = arg_77_1, arg_77_2
end

function StoryUnitLayout.getFuturePosition(arg_78_0)
	return arg_78_0.vars.ft_x, arg_78_0.vars.ft_y
end

function StoryUnitLayout.getDirection(arg_79_0)
	return arg_79_0.vars.dir or 1
end

function StoryUnitLayout.setDirection(arg_80_0, arg_80_1)
	arg_80_1 = tonumber(arg_80_1)
	arg_80_0.vars.dir = arg_80_1
end

function StoryUnitLayout.setRotation(arg_81_0, arg_81_1)
	arg_81_0.vars.rotation = arg_81_1
end

function StoryUnitLayout.getRotation(arg_82_0)
	return arg_82_0.vars.rotation or 0
end

function StoryUnitLayout.getScaleX(arg_83_0)
	return arg_83_0.vars.sx or arg_83_0:getDirection()
end

function StoryUnitLayout.getScaleY(arg_84_0)
	return arg_84_0.vars.sy or 1
end

function StoryUnitLayout.setScaleX(arg_85_0, arg_85_1)
	arg_85_0.vars.sx = arg_85_1
end

function StoryUnitLayout.setScaleY(arg_86_0, arg_86_1)
	arg_86_0.vars.sy = arg_86_1
end

function StoryUnitLayout.getWorldPosition(arg_87_0)
	local var_87_0, var_87_1 = arg_87_0:getOffset()
	
	return arg_87_0.vars.x + var_87_0, arg_87_0.vars.y + var_87_1 + BATTLE_LAYOUT.TEAM_Y
end

function StoryUnitLayout.getFrontDistance(arg_88_0)
	return (BATTLE_LAYOUT.TEAM_WIDTH / 2 + BATTLE_LAYOUT.TEAM_FRONT) * arg_88_0:getDirection()
end

function StoryUnitLayout.setOffset(arg_89_0, arg_89_1, arg_89_2, arg_89_3)
	if arg_89_3 then
		if (arg_89_1 or 0) == 0 and (arg_89_2 or 0) == 0 then
			arg_89_0.vars.offsets[arg_89_3] = nil
		else
			arg_89_0.vars.offsets[arg_89_3] = {
				arg_89_1 or 0,
				arg_89_2 or 0
			}
		end
	end
	
	if not arg_89_0.vars.nextPosX and not arg_89_0.vars.nextPosY or arg_89_0.vars.nextPosY and arg_89_0.vars.nextPosY == curY or arg_89_0.vars.nextPosX and arg_89_0.vars.nextPosX == curX then
		arg_89_0.vars.offset_x, arg_89_0.vars.offset_y = arg_89_1, arg_89_2
	end
end

function StoryUnitLayout.getOffset(arg_90_0)
	if arg_90_0.vars.disable_offset then
		return 0, 0
	end
	
	local var_90_0 = 0
	local var_90_1 = 0
	
	for iter_90_0, iter_90_1 in pairs(arg_90_0.vars.offsets) do
		var_90_0 = var_90_0 + iter_90_1[1]
		var_90_1 = var_90_1 + iter_90_1[2]
	end
	
	if var_90_0 == math.huge or var_90_1 == math.huge then
		var_90_0, var_90_1 = 0, 0
	end
	
	return var_90_0 + (arg_90_0.vars.offset_x or 0), var_90_1 + (arg_90_0.vars.offset_y or 0)
end

function StoryUnitLayout.getUnitFieldPosition(arg_91_0, arg_91_1, arg_91_2, arg_91_3)
	local var_91_0, var_91_1 = arg_91_0:getPosition()
	local var_91_2 = arg_91_0:getDirection()
	
	return arg_91_1.x + var_91_2 * (arg_91_2 or 0), arg_91_1.y + (arg_91_3 or 0)
end

function StoryUnitLayout.setVisible(arg_92_0, arg_92_1)
	if arg_92_0.vars.visible ~= arg_92_1 then
		arg_92_0.vars.visible = arg_92_1
		
		arg_92_0:updateVisible()
	end
end

function StoryUnitLayout.isVisible(arg_93_0)
	return arg_93_0.vars.visible
end

function StoryUnitLayout.updateVisible(arg_94_0)
	local var_94_0 = arg_94_0:isVisible()
	
	for iter_94_0, iter_94_1 in pairs(arg_94_0.vars.slots) do
		local var_94_1 = iter_94_1.unit
		
		if get_cocos_refid(var_94_1.model) then
			var_94_1.model:setVisible(var_94_0)
		end
	end
end

function StoryUnitLayout.updateMoveProcess(arg_95_0, arg_95_1)
	if not arg_95_0.vars then
		return 
	end
	
	for iter_95_0, iter_95_1 in pairs(arg_95_0.vars.slots) do
		if iter_95_1.unit and iter_95_1.unit.mover then
			iter_95_1.unit.mover:onUpdateStory(arg_95_1)
		end
	end
end

TeamLayout = ClassDef()

function TeamLayout.build(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	local function var_96_0()
		local var_97_0 = {
			{
				{
					0
				},
				{
					0
				}
			},
			{
				{
					-50,
					50
				},
				{
					0.4,
					-0.4
				}
			},
			{
				{
					-100,
					0,
					100
				},
				{
					0.6,
					0,
					-0.6
				}
			}
		}
		local var_97_1 = 0.08
		local var_97_2 = 0.83
		local var_97_3 = {
			[FRONT] = {
				x = 1,
				y = -0.3
			},
			[BACK] = {
				x = -0.43,
				y = -0.1
			}
		}
		local var_97_4 = {}
		local var_97_5 = {}
		local var_97_6 = {}
		local var_97_7 = {
			[FRONT] = 0,
			[BACK] = 0
		}
		
		for iter_97_0, iter_97_1 in pairs(arg_96_1) do
			if not var_97_5[iter_97_1.inst.line] then
				var_97_5[iter_97_1.inst.line] = 1
			else
				var_97_5[iter_97_1.inst.line] = var_97_5[iter_97_1.inst.line] + 1
			end
			
			var_97_6[iter_97_1.inst.line] = math.max(var_97_6[iter_97_1.inst.line] or 1, iter_97_1.db.size)
		end
		
		for iter_97_2, iter_97_3 in pairs(arg_96_1) do
			local var_97_8
			local var_97_9
			local var_97_10 = {
				x = 0,
				y = 0
			}
			
			if #arg_96_1 > 1 and var_97_3[iter_97_3.inst.line] then
				var_97_10 = var_97_3[iter_97_3.inst.line]
			end
			
			local var_97_11 = math.min(#var_97_0, var_97_5[iter_97_3.inst.line] or 1)
			local var_97_12 = var_97_6[iter_97_3.inst.line] or 1
			local var_97_13 = var_97_7[iter_97_3.inst.line] + 1
			
			var_97_7[iter_97_3.inst.line] = var_97_13
			
			local var_97_14 = var_97_0[var_97_11][1][var_97_13] or 0
			local var_97_15 = (var_97_0[var_97_11][2][var_97_13] or 0) * (1 + math.min(var_97_12 - 1, 1 / var_97_1) * var_97_1) + var_97_10.y
			local var_97_16 = var_97_2 * var_97_15 + var_97_10.x
			
			table.insert(var_97_4, {
				unit = arg_96_1[iter_97_2],
				rx = var_97_16,
				ry = var_97_15,
				rz = var_97_14
			})
		end
		
		return var_97_4
	end
	
	local function var_96_1(arg_98_0)
		local var_98_0 = {}
		local var_98_1 = {
			{
				z = 0,
				x = 0.9,
				y = 0
			},
			{
				z = 100,
				x = 0.1,
				y = -0.8
			},
			{
				z = -100,
				x = -0.1,
				y = 0.8
			},
			{
				z = 0,
				x = -0.9,
				y = 0.2
			}
		}
		
		if arg_98_0 then
			var_98_1[4], var_98_1[1] = var_98_1[1], var_98_1[4]
		end
		
		for iter_98_0, iter_98_1 in pairs(arg_96_1) do
			local var_98_2 = var_98_1[iter_98_1.inst.pos]
			
			if var_98_2 then
				table.insert(var_98_0, {
					unit = iter_98_1,
					rx = var_98_2.x,
					ry = var_98_2.y,
					rz = var_98_2.z
				})
			end
		end
		
		local var_98_3
		
		if arg_96_4 and arg_96_4.db then
			local var_98_4 = arg_96_4.db.code
			local var_98_5, var_98_6, var_98_7 = PetUtil:getLayoutPosition(var_98_4)
			
			var_98_3 = {
				pet = arg_96_4,
				rx = var_98_5,
				ry = var_98_6,
				rz = var_98_7
			}
		end
		
		return var_98_0, var_98_3
	end
	
	if arg_96_2 then
		return var_96_1(arg_96_3)
	end
	
	return var_96_0()
end

function TeamLayout.constructor(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	arg_99_0.vars = {}
	arg_99_0.vars.x = 0
	arg_99_0.vars.y = 0
	arg_99_0.vars.z = 0
	arg_99_0.vars.init_x = 0
	arg_99_0.vars.init_y = 0
	arg_99_0.vars.init_sx = 1
	arg_99_0.vars.init_sy = 1
	arg_99_0.vars.ally = arg_99_2
	arg_99_0.vars.slots = arg_99_1
	arg_99_0.vars.visible = true
	arg_99_0.vars.offsets = {}
	arg_99_0.vars.pet_slot = arg_99_3
	arg_99_0.vars.disable_rotation_self = false
	arg_99_0.vars.disable_rotation_team = false
	arg_99_0.vars.rotation_pivot = "root"
	
	arg_99_0:init()
end

function TeamLayout.init(arg_100_0)
	local var_100_0 = BATTLE_LAYOUT.TEAM_WIDTH * 0.5
	local var_100_1 = BATTLE_LAYOUT.TEAM_HEIGHT * 0.5
	local var_100_2 = 0
	local var_100_3
	
	for iter_100_0, iter_100_1 in pairs(arg_100_0.vars.slots) do
		local var_100_4 = iter_100_1.unit
		
		if var_100_4.inst.line ~= var_100_3 and var_100_4.inst.line == BACK then
			var_100_3 = var_100_4.inst.line
			var_100_2 = var_100_2 - 1
		end
		
		iter_100_1.dir = arg_100_0:getDirection()
		iter_100_1.x = var_100_0 * iter_100_1.rx * iter_100_1.dir
		iter_100_1.y = var_100_1 * iter_100_1.ry
		iter_100_1.z = iter_100_1.rz + var_100_2
		var_100_4.init_x = iter_100_1.x
		var_100_4.init_y = iter_100_1.y
		var_100_4.init_z = iter_100_1.z
		var_100_4.x = var_100_4.init_x
		var_100_4.y = var_100_4.init_y
		var_100_4.z = var_100_4.init_z
		var_100_4.rot = arg_100_0:getRotation()
		var_100_4.mover = var_0_5(var_100_4)
	end
	
	if arg_100_0.vars.pet_slot then
		local var_100_5 = arg_100_0.vars.pet_slot
		local var_100_6 = arg_100_0.vars.pet_slot.pet
		
		var_100_5.dir = arg_100_0:getDirection()
		var_100_5.x = var_100_0 * var_100_5.rx * var_100_5.dir
		var_100_5.y = var_100_1 * var_100_5.ry
		var_100_5.z = var_100_5.rz
		var_100_6.init_x = var_100_5.x
		var_100_6.init_y = var_100_5.y
		var_100_6.init_z = var_100_5.z
		var_100_6.x = var_100_6.init_x
		var_100_6.y = var_100_6.init_y
		var_100_6.z = var_100_6.init_z
		var_100_6.mover = var_0_5(var_100_6)
		var_100_6.isPet = true
	end
	
	arg_100_0:updatePose()
	
	DEBUG.TEST_LAYOUT = arg_100_0
end

function TeamLayout.swap(arg_101_0, arg_101_1, arg_101_2)
	for iter_101_0, iter_101_1 in pairs(arg_101_0.vars.slots) do
		if iter_101_1.unit == arg_101_1 then
			iter_101_1.unit = arg_101_2
			arg_101_2.init_x = iter_101_1.x
			arg_101_2.init_y = iter_101_1.y
			arg_101_2.init_z = iter_101_1.z
			arg_101_2.x = arg_101_2.init_x
			arg_101_2.y = arg_101_2.init_y
			arg_101_2.z = arg_101_2.init_z
			arg_101_2.mover = arg_101_1.mover:clone(arg_101_2)
			
			break
		end
	end
	
	arg_101_0:updatePose()
end

function TeamLayout.removeUnitSlot(arg_102_0, arg_102_1)
	local var_102_0 = {}
	
	for iter_102_0, iter_102_1 in pairs(arg_102_0.vars.slots) do
		if iter_102_1.unit == arg_102_1 then
			table.insert(var_102_0, 1, iter_102_0)
		end
	end
	
	for iter_102_2, iter_102_3 in ipairs(var_102_0) do
		table.remove(arg_102_0.vars.slots, iter_102_3)
	end
end

function TeamLayout.getUnits(arg_103_0)
	local var_103_0 = {}
	
	for iter_103_0, iter_103_1 in pairs(arg_103_0.vars.slots) do
		table.insert(var_103_0, iter_103_1.unit)
	end
	
	return var_103_0
end

function TeamLayout.getAlly(arg_104_0)
	return arg_104_0.vars.ally
end

function TeamLayout.getLocalZOrder(arg_105_0)
	return arg_105_0.vars.z
end

function TeamLayout.getDirection(arg_106_0)
	return arg_106_0.vars.dir or 1
end

function TeamLayout.getScaleX(arg_107_0)
	return arg_107_0.vars.sx or arg_107_0:getDirection() * BattleLayout:getDirection()
end

function TeamLayout.getScaleY(arg_108_0)
	return arg_108_0.vars.sy or 1
end

function TeamLayout.setScaleX(arg_109_0, arg_109_1)
	arg_109_0.vars.sx = arg_109_1
end

function TeamLayout.setScaleY(arg_110_0, arg_110_1)
	arg_110_0.vars.sy = arg_110_1
end

function TeamLayout.setInitScaleX(arg_111_0, arg_111_1)
	arg_111_0.vars.init_scale_x = arg_111_1
end

function TeamLayout.setInitScaleY(arg_112_0, arg_112_1)
	arg_112_0.vars.init_scale_y = arg_112_1
end

function TeamLayout.getInitScaleX(arg_113_0)
	return arg_113_0.vars.init_scale_x or arg_113_0:getDirection() * BattleLayout:getDirection()
end

function TeamLayout.getInitScaleY(arg_114_0)
	return arg_114_0.vars.init_scale_y or 1
end

function TeamLayout.initScale(arg_115_0)
	arg_115_0.vars.sx = arg_115_0:getInitScaleX()
	arg_115_0.vars.sy = arg_115_0:getInitScaleY()
end

function TeamLayout.setRotation(arg_116_0, arg_116_1)
	arg_116_0.vars.rotation = arg_116_1
end

function TeamLayout.getRotation(arg_117_0)
	return arg_117_0.vars.rotation or 0
end

function TeamLayout.setPosition(arg_118_0, arg_118_1, arg_118_2)
	arg_118_0.vars.x, arg_118_0.vars.y = arg_118_1, arg_118_2
end

function TeamLayout.getPosition(arg_119_0)
	return arg_119_0.vars.x, arg_119_0.vars.y
end

function TeamLayout.setInitPosition(arg_120_0, arg_120_1, arg_120_2)
	arg_120_0.vars.init_x, arg_120_0.vars.init_y = arg_120_1, arg_120_2
end

function TeamLayout.initPosition(arg_121_0)
	arg_121_0.vars.x, arg_121_0.vars.y = arg_121_0.vars.init_x, arg_121_0.vars.init_y
end

function TeamLayout.setOffset(arg_122_0, arg_122_1, arg_122_2, arg_122_3)
	if arg_122_3 then
		if (arg_122_1 or 0) == 0 and (arg_122_2 or 0) == 0 then
			arg_122_0.vars.offsets[arg_122_3] = nil
		else
			arg_122_0.vars.offsets[arg_122_3] = {
				arg_122_1 or 0,
				arg_122_2 or 0
			}
		end
	else
		arg_122_0.vars.offset_x, arg_122_0.vars.offset_y = arg_122_1, arg_122_2
	end
end

function TeamLayout.getOffset(arg_123_0)
	if arg_123_0.vars.disable_offset then
		return 0, 0
	end
	
	local var_123_0 = 0
	local var_123_1 = 0
	
	for iter_123_0, iter_123_1 in pairs(arg_123_0.vars.offsets) do
		var_123_0 = var_123_0 + iter_123_1[1]
		var_123_1 = var_123_1 + iter_123_1[2]
	end
	
	if var_123_0 == math.huge or var_123_1 == math.huge then
		var_123_0, var_123_1 = 0, 0
	end
	
	return var_123_0 + (arg_123_0.vars.offset_x or 0), var_123_1 + (arg_123_0.vars.offset_y or 0)
end

function TeamLayout.setDirection(arg_124_0, arg_124_1)
	arg_124_0.vars.dir = arg_124_1
end

function TeamLayout.getWorldPosition(arg_125_0)
	local var_125_0, var_125_1 = arg_125_0:getOffset()
	local var_125_2 = BattleLayout:getFieldPosition()
	
	return arg_125_0.vars.x + var_125_0 + var_125_2, arg_125_0.vars.y + var_125_1 + BATTLE_LAYOUT.TEAM_Y
end

function TeamLayout.getFrontDistance(arg_126_0)
	return (BATTLE_LAYOUT.TEAM_WIDTH / 2 + BATTLE_LAYOUT.TEAM_FRONT) * (arg_126_0:getDirection() * BattleLayout:getDirection())
end

function TeamLayout.getUnitFieldPosition(arg_127_0, arg_127_1, arg_127_2, arg_127_3)
	local var_127_0, var_127_1 = arg_127_0:getPosition()
	local var_127_2 = arg_127_0:getDirection()
	
	return arg_127_1.x + var_127_2 * (arg_127_2 or 0), arg_127_1.y + (arg_127_3 or 0) + var_127_1
end

function TeamLayout.getLastUpdateCount(arg_128_0)
	arg_128_0.vars.lastUpdateCount = 0
end

function TeamLayout.setVisible(arg_129_0, arg_129_1)
	if arg_129_0.vars.visible ~= arg_129_1 then
		arg_129_0.vars.visible = arg_129_1
		
		arg_129_0:updateVisible()
	end
end

function TeamLayout.isVisible(arg_130_0)
	return arg_130_0.vars.visible
end

function TeamLayout.updateVisible(arg_131_0)
	local var_131_0 = arg_131_0:isVisible()
	
	for iter_131_0, iter_131_1 in pairs(arg_131_0.vars.slots) do
		local var_131_1 = iter_131_1.unit
		
		if get_cocos_refid(var_131_1.model) and var_131_1.inst.code ~= "cleardummy" then
			var_131_1.model:setVisible(var_131_0)
		end
	end
	
	if arg_131_0.vars.pet_slot then
		local var_131_2 = arg_131_0.vars.pet_slot.pet
		
		if get_cocos_refid(var_131_2.model) then
			var_131_2.model:setVisible(var_131_0)
		end
	end
end

function TeamLayout.updateMoveProcess(arg_132_0, arg_132_1)
	for iter_132_0, iter_132_1 in pairs(arg_132_0.vars.slots) do
		if iter_132_1.unit and iter_132_1.unit.mover then
			iter_132_1.unit.mover:onUpdate(arg_132_1)
		end
	end
	
	if arg_132_0.vars.pet_slot then
		local var_132_0 = arg_132_0.vars.pet_slot
		
		if var_132_0.pet and var_132_0.pet.mover then
			var_132_0.pet.mover:onUpdate(arg_132_1)
		end
	end
end

function TeamLayout.updatePose(arg_133_0)
	local var_133_0 = BATTLE_LAYOUT.TEAM_WIDTH * 0.5
	local var_133_1 = BATTLE_LAYOUT.TEAM_HEIGHT * 0.5
	local var_133_2, var_133_3 = arg_133_0:getPosition()
	local var_133_4, var_133_5 = arg_133_0:getOffset()
	local var_133_6 = var_133_2 + BattleLayout:getFieldPosition() + var_133_4
	local var_133_7 = var_133_3 + BATTLE_LAYOUT.TEAM_Y + var_133_5
	
	for iter_133_0, iter_133_1 in pairs(arg_133_0.vars.slots) do
		local var_133_8 = iter_133_1.unit
		local var_133_9 = BattleLayout:getDirection() * iter_133_1.dir
		
		var_133_8.dir = var_133_9
		
		local var_133_10 = math.abs(arg_133_0:getScaleX())
		local var_133_11 = arg_133_0:getScaleY()
		local var_133_12 = math.rad(arg_133_0:getRotation() * -iter_133_1.dir)
		local var_133_13 = 0
		local var_133_14 = 0
		
		if arg_133_0.vars.rotation_pivot == "target" then
			local var_133_15, var_133_16 = var_133_8.model:getBonePosition("target")
			local var_133_17, var_133_18 = var_133_8.model:getPosition()
			
			var_133_13, var_133_14 = var_133_15 - var_133_17, var_133_16 - var_133_18
		end
		
		local var_133_19 = var_133_0 * iter_133_1.rx * var_133_8.dir - var_133_13
		local var_133_20 = var_133_1 * iter_133_1.ry - var_133_14
		local var_133_21 = 0
		local var_133_22 = 0
		
		if arg_133_0.vars.disable_rotation_team then
			var_133_21, var_133_22 = var_133_19, var_133_20
		else
			var_133_21 = var_133_10 * (var_133_19 * math.cos(var_133_12) - var_133_20 * math.sin(var_133_12))
			var_133_22 = var_133_11 * (var_133_20 * math.cos(var_133_12) + var_133_19 * math.sin(var_133_12))
		end
		
		var_133_8.x = var_133_6 + var_133_21
		var_133_8.y = var_133_7 + var_133_22
		var_133_8.z = iter_133_1.z
		
		if not arg_133_0.vars.disable_rotation_self then
			var_133_8.rot = arg_133_0:getRotation()
		end
		
		var_133_8.sx = math.abs(var_133_10 * (var_133_8.db.scale or 1)) * var_133_9 * arg_133_0:getDirection()
		var_133_8.sy = math.abs(var_133_11 * (var_133_8.db.scale or 1))
	end
	
	if arg_133_0.vars.pet_slot then
		local var_133_23 = arg_133_0.vars.pet_slot
		local var_133_24 = var_133_23.pet
		local var_133_25 = BattleLayout:getDirection() * var_133_23.dir
		
		var_133_24.dir = var_133_25
		
		local var_133_26 = math.rad(arg_133_0:getRotation() * -var_133_23.dir)
		local var_133_27 = math.abs(arg_133_0:getScaleX())
		local var_133_28 = arg_133_0:getScaleY()
		local var_133_29 = var_133_0 * var_133_23.rx * var_133_24.dir
		local var_133_30 = var_133_1 * var_133_23.ry
		local var_133_31 = var_133_27 * (var_133_29 * math.cos(var_133_26) - var_133_30 * math.sin(var_133_26))
		local var_133_32 = var_133_28 * (var_133_30 * math.cos(var_133_26) + var_133_29 * math.sin(var_133_26))
		
		var_133_24.x = var_133_6 + var_133_31
		var_133_24.y = var_133_7 + var_133_32
		var_133_24.sx = math.abs(var_133_27 * (var_133_24.db.pet_scale or 1)) * var_133_25
		var_133_24.sy = math.abs(var_133_28 * (var_133_24.db.pet_scale or 1))
		var_133_24.rot = arg_133_0:getRotation() * -var_133_23.dir
		var_133_24.z = var_133_23.z
	end
end

function TeamLayout.updateModelPose(arg_134_0, arg_134_1)
	if not arg_134_0:isVisible() then
		return 
	end
	
	arg_134_0.vars.lastUpdateCount = 0
	
	for iter_134_0, iter_134_1 in pairs(arg_134_0.vars.slots) do
		local var_134_0 = iter_134_1.unit
		local var_134_1 = var_134_0.x
		local var_134_2 = var_134_0.y
		local var_134_3 = BattleLayout:getDirection() * arg_134_0:getDirection()
		
		if get_cocos_refid(var_134_0.model) then
			var_134_0.model:setLocalZOrder(var_134_0.z)
			
			if var_134_0.sx then
				var_134_0.model:setScaleX(var_134_0.sx or 1)
			end
			
			if var_134_0.sy then
				var_134_0.model:setScaleY(var_134_0.sy or 1)
			end
			
			if var_134_0.rot then
				var_134_0.model:setRotation(var_134_0.rot or 0)
			end
		end
		
		if arg_134_1 then
			var_134_0.mover:moveTo(var_134_1, var_134_2, var_134_3)
		else
			var_134_0.mover:setPosition(var_134_1, var_134_2)
			var_134_0.mover:setDirection(var_134_3)
		end
	end
	
	if arg_134_0.vars.pet_slot then
		local var_134_4 = arg_134_0.vars.pet_slot.pet
		local var_134_5 = var_134_4.x
		local var_134_6 = var_134_4.y
		local var_134_7 = BattleLayout:getDirection() * arg_134_0:getDirection()
		
		if get_cocos_refid(var_134_4.model) and not var_134_4:isMoverPaused() then
			var_134_4.model:setLocalZOrder(var_134_4.z)
			
			if var_134_4.sx then
				var_134_4.model:setScaleX(var_134_4.sx or 1)
			end
			
			if var_134_4.sy then
				var_134_4.model:setScaleY(var_134_4.sy or 1)
			end
			
			if var_134_4.rot then
				var_134_4.model:setRotation(var_134_4.rot or 0)
			end
		end
		
		if arg_134_1 then
			var_134_4.mover:moveTo(var_134_5, var_134_6, var_134_7)
		else
			var_134_4.mover:setPosition(var_134_5, var_134_6)
			var_134_4.mover:setDirection(var_134_7)
		end
	end
end

function TeamLayout.appearEffect(arg_135_0, arg_135_1, arg_135_2, arg_135_3)
	local function var_135_0(arg_136_0, arg_136_1)
		local var_136_0, var_136_1 = arg_136_1.model:getBonePosition("root")
		local var_136_2 = CACHE:getEffect("dust_landing")
		
		var_136_2:setPosition(var_136_0, var_136_1)
		var_136_2:setLocalZOrder(arg_136_1.z)
		BGI.main.layer:addChild(var_136_2)
		BattleAction:Add(SEQ(DMOTION("animation"), REMOVE()), var_136_2, "battle.enter")
	end
	
	local function var_135_1(arg_137_0, arg_137_1, arg_137_2)
		arg_137_2 = arg_137_2 or 1
		
		arg_137_0:updatePose()
		
		for iter_137_0, iter_137_1 in pairs(arg_137_0.vars.slots) do
			local var_137_0 = iter_137_1.unit
			
			local function var_137_1(arg_138_0)
				if arg_138_0 and arg_138_0.ui_vars and arg_138_0.ui_vars.gauge then
					arg_138_0.ui_vars.gauge:setIndividualShow(nil)
				end
			end
			
			if not var_137_0:isDead() and get_cocos_refid(var_137_0.model) then
				local var_137_2 = var_137_0.model
				local var_137_3, var_137_4 = arg_137_0:getUnitFieldPosition(var_137_0, -(VIEW_WIDTH / 2) * arg_137_2, DESIGN_HEIGHT / 4)
				local var_137_5, var_137_6 = arg_137_0:getUnitFieldPosition(var_137_0)
				local var_137_7 = 0
				
				var_137_2:setScaleX(var_137_0.db.scale)
				var_137_2:setVisible(true)
				
				if var_137_0.inst.ally == ENEMY and var_137_2:getScaleX() > 0 then
					var_137_2:setScaleX(-1 * var_137_2:getScaleX() * arg_137_2)
				end
				
				local var_137_8 = NONE()
				
				local function var_137_9(arg_139_0)
					if arg_139_0.states:find("3004") then
						arg_139_0.tmp_vars.handle_restore = true
						
						arg_139_0.model:setOpacity(0)
						arg_139_0.model:setOpacityByKey("banshee_queen", 0)
					end
				end
				
				if var_137_0.db.designed_appear then
					var_137_2:setPosition(var_137_5, var_137_6)
					var_137_2:setOpacity(0)
					
					if var_137_2:isExistAnimation("appear") then
						var_137_8 = DMOTION("appear")
					end
					
					BattleAction:Add(SEQ(DELAY(to_n(arg_137_1)), SHOW(true), OPACITY(400, 0, 1), CALL(var_137_1, var_137_0), var_137_8, Battle:getIdleAction(var_137_0)), var_137_2, "battle.appear")
				elseif arg_135_3 then
					var_137_2:setPosition(var_137_5, var_137_6)
					var_137_2:setOpacity(0)
					
					if var_137_2:isExistAnimation("appear") then
						var_137_8 = DMOTION("appear")
					end
					
					BattleAction:Add(SEQ(SHOW(true), CALL(var_137_1, var_137_0), var_137_8, Battle:getIdleAction(var_137_0), CALL(var_137_9, var_137_0)), var_137_2, "battle.appear")
				else
					var_137_2:setPosition(var_137_3, var_137_4)
					
					if var_137_0.inst.line == BACK then
						var_137_7 = 250
					end
					
					local var_137_10 = var_137_7 + math.random(0, #arg_137_0.vars.slots * 50)
					local var_137_11 = Battle:getIdleAction(var_137_0)
					
					if var_137_2:isExistAnimation("appear") then
						var_137_11 = MOTION("appear")
					end
					
					BattleAction:Add(SEQ(DELAY(to_n(arg_137_1)), SHOW(true), var_137_11, DELAY(var_137_10), SPAWN(CALL(var_137_1, var_137_0), JUMP_TO(300, var_137_5 + 40 * arg_137_2, var_137_6)), CALL(var_135_0, arg_137_0, var_137_0), Battle:getIdleAction(var_137_0), MOVE_TO(200, var_137_5, var_137_6)), var_137_2, "battle.appear")
				end
			end
		end
	end
	
	for iter_135_0, iter_135_1 in pairs(arg_135_0.vars.slots) do
		local var_135_2 = iter_135_1.unit
		
		if not var_135_2:isDead() and get_cocos_refid(var_135_2.model) then
			var_135_2.model:setVisible(false)
		end
	end
	
	if arg_135_3 then
		var_135_1(arg_135_0, 0, arg_135_2)
	else
		BattleAction:Add(SEQ(DELAY(100), CALL(var_135_1, arg_135_0, arg_135_1, arg_135_2)), BGI.ui_layer, "battle.appear")
	end
	
	if arg_135_0.vars.pet_slot then
		local var_135_3 = arg_135_0.vars.pet_slot.pet
		
		if get_cocos_refid(var_135_3.model) then
			var_135_3.model:setVisible(true)
		end
	end
end

function TeamLayout.getTeamAniState(arg_140_0)
	for iter_140_0, iter_140_1 in pairs(arg_140_0.vars.slots) do
		local var_140_0 = iter_140_1.unit.mover:getAniState()
		
		if var_140_0 then
			return var_140_0
		end
	end
	
	return nil
end

function TeamLayout.setRotationPivot(arg_141_0, arg_141_1)
	arg_141_0.vars.rotation_pivot = arg_141_1
end

function TeamLayout.setDisableRotationSelf(arg_142_0, arg_142_1)
	arg_142_0.vars.disable_rotation_self = arg_142_1
end

function TeamLayout.setDisableRotationTeam(arg_143_0, arg_143_1)
	arg_143_0.vars.disable_rotation_team = arg_143_1
end

function BattleLayout.getLayoutCenter(arg_144_0)
	return DESIGN_WIDTH / 2, BATTLE_LAYOUT.TEAM_Y
end

function BattleLayout.init(arg_145_0, arg_145_1)
	local var_145_0 = arg_145_1 or "default"
	
	BattleConstants:setMode(var_145_0)
	arg_145_0:reset()
end

function BattleLayout.reset(arg_146_0)
	arg_146_0.vars = {}
	arg_146_0._teamLayoutMap = nil
	arg_146_0._x = nil
	arg_146_0._y = nil
	arg_146_0._defTeamLayout = nil
	arg_146_0._direction = nil
	arg_146_0.vars.pause_tbl = {}
	arg_146_0._storyLayoutMap = nil
end

function BattleLayout.restoreFromBackup(arg_147_0, arg_147_1)
	restore_state_from_backup_from_table(arg_147_0, arg_147_1)
end

function BattleLayout.setBackup(arg_148_0, arg_148_1)
	set_state_backup_from_table(arg_148_0, arg_148_1)
end

function BattleLayout.setWalking(arg_149_0, arg_149_1)
	arg_149_0.vars.walking = arg_149_1
end

function BattleLayout.isWalking(arg_150_0)
	return arg_150_0.vars and arg_150_0.vars.walking and not arg_150_0:isPaused()
end

function BattleLayout.setPauseByTag(arg_151_0, arg_151_1, arg_151_2)
	if arg_151_1 then
		arg_151_0.vars.pause_tbl[arg_151_2] = true
	else
		arg_151_0.vars.pause_tbl[arg_151_2] = nil
	end
	
	if arg_151_0:isPaused() then
		arg_151_0.vars.walking = nil
	end
	
	Battle:testAutoPlayingMode()
end

function BattleLayout.setPause(arg_152_0, arg_152_1)
	arg_152_0:setPauseByTag(arg_152_1, "default")
end

function BattleLayout.isPaused(arg_153_0)
	return not table.empty(arg_153_0.vars.pause_tbl)
end

function BattleLayout.isBlocked(arg_154_0)
	return arg_154_0.vars and arg_154_0.vars.blocked
end

function BattleLayout.isForwardLock(arg_155_0)
	return arg_155_0.vars and arg_155_0.vars.forward_lock
end

function BattleLayout.setForwardLock(arg_156_0, arg_156_1)
	arg_156_0.vars.forward_lock = arg_156_1
end

function BattleLayout.setDirection(arg_157_0, arg_157_1, arg_157_2)
	local var_157_0 = arg_157_0:getDirection()
	local var_157_1 = math.normalize(arg_157_1, 1)
	
	if var_157_0 ~= var_157_1 then
		arg_157_0._direction = var_157_1
		
		arg_157_0:retainFieldPosition(nil)
		arg_157_0:updatePose()
		arg_157_0:updateModelPose(arg_157_2)
		
		return true, var_157_0
	end
end

function BattleLayout.getAllyDirection(arg_158_0, arg_158_1, arg_158_2)
	if arg_158_2 then
		return arg_158_0:getTeamLayout(assert(arg_158_1), arg_158_2):getDirection()
	else
		return arg_158_0:getDirection() * arg_158_0:getTeamLayout(assert(arg_158_1), arg_158_2):getDirection()
	end
end

function BattleLayout.getDirection(arg_159_0)
	return arg_159_0._direction or 1
end

function BattleLayout.getFieldPosition(arg_160_0)
	return arg_160_0._x or 0, arg_160_0._y or 0
end

function BattleLayout.getRetainedFieldPosition(arg_161_0)
	return arg_161_0._retain_x
end

function BattleLayout.getFocusPosition(arg_162_0)
	local var_162_0, var_162_1 = arg_162_0:getFieldPosition()
	
	return var_162_0 + BATTLE_LAYOUT.XDIST_FROM_FOCUS * arg_162_0:getDirection()
end

function BattleLayout.setFieldPosition(arg_163_0, arg_163_1, arg_163_2)
	if arg_163_0._x ~= (arg_163_1 or 0) then
		arg_163_0:retainFieldPosition(arg_163_2 and arg_163_0._x)
		
		arg_163_0._x = arg_163_1 or 0
	end
end

function BattleLayout.setFieldPositionY(arg_164_0, arg_164_1, arg_164_2)
	if arg_164_0._y ~= (arg_164_1 or 0) then
		arg_164_0._y = arg_164_1 or 0
	end
end

function BattleLayout.retainFieldPosition(arg_165_0, arg_165_1)
	arg_165_0._retain_x = arg_165_1
end

function BattleLayout.moveToFieldPosition(arg_166_0, arg_166_1, arg_166_2)
	arg_166_0.vars.nextPosX = arg_166_1
	arg_166_0.vars.nextPosY = arg_166_2
end

function BattleLayout.stopImmediate(arg_167_0)
	arg_167_0.vars.nextDist = nil
end

function BattleLayout.registMoveFinishCB(arg_168_0, arg_168_1)
	arg_168_0.vars.moveFinishCB = arg_168_1
end

function BattleLayout.isInverse(arg_169_0, arg_169_1)
	if arg_169_0:getDirection() < 0 then
		return arg_169_1 == FRIEND
	end
	
	return arg_169_1 == ENEMY
end

function BattleLayout.addTeamLayoutData(arg_170_0, arg_170_1, arg_170_2, arg_170_3)
	if not arg_170_0._teamLayoutMap then
		arg_170_0._teamLayoutMap = {}
	end
	
	local var_170_0 = TeamLayout(arg_170_1, arg_170_2, arg_170_3)
	
	arg_170_0._teamLayoutMap[arg_170_2] = var_170_0
	
	if arg_170_0._teamLayoutMap[FRIEND] then
		arg_170_0._defTeamLayout = arg_170_0._teamLayoutMap[FRIEND]
	end
	
	return var_170_0
end

function BattleLayout.addWorldBossLayoutData(arg_171_0, arg_171_1, arg_171_2)
	if not arg_171_0._teamLayoutMap then
		arg_171_0._teamLayoutMap = {}
	end
	
	local var_171_0 = WorldBossLayout(arg_171_1, arg_171_2)
	
	arg_171_0._teamLayoutMap[arg_171_2] = var_171_0
	
	if arg_171_0._teamLayoutMap[FRIEND] then
		arg_171_0._defTeamLayout = arg_171_0._teamLayoutMap[FRIEND]
	end
	
	return var_171_0
end

function BattleLayout.addStoryUnitLayoutData(arg_172_0, arg_172_1, arg_172_2, arg_172_3, arg_172_4)
	if not arg_172_0._storyLayoutMap then
		arg_172_0._storyLayoutMap = {}
	end
	
	local var_172_0 = StoryUnitLayout(arg_172_1, arg_172_2, arg_172_3, arg_172_4)
	
	table.insert(arg_172_0._storyLayoutMap, var_172_0)
	
	return var_172_0
end

function BattleLayout.removeTeamLayout(arg_173_0, arg_173_1)
	local var_173_0 = arg_173_0:getTeamLayout(arg_173_1)
	
	if var_173_0 then
		local var_173_1 = var_173_0:getUnits()
		
		for iter_173_0, iter_173_1 in pairs(var_173_1) do
			BattleUtil:clearUnit(iter_173_1)
			BattleUtil:removeModel(iter_173_1)
		end
	end
end

function BattleLayout.removeStoryLayout(arg_174_0, arg_174_1, arg_174_2)
	local var_174_0 = arg_174_0:getTeamLayout(arg_174_1, arg_174_2)
	
	if var_174_0 then
		local var_174_1 = var_174_0:getUnits()
		
		for iter_174_0, iter_174_1 in pairs(var_174_1) do
			BattleUtil:clearUnit(iter_174_1)
			BattleUtil:removeModel(iter_174_1.model)
		end
	end
end

function BattleLayout.updatePoseStory(arg_175_0)
	if not arg_175_0._storyLayoutMap then
		return 
	end
	
	for iter_175_0, iter_175_1 in pairs(arg_175_0._storyLayoutMap) do
		iter_175_1:updatePose()
	end
end

function BattleLayout.updateModelPoseStory(arg_176_0, arg_176_1)
	if not arg_176_0._storyLayoutMap then
		return 
	end
	
	for iter_176_0, iter_176_1 in pairs(arg_176_0._storyLayoutMap) do
		iter_176_1:updateModelPose(arg_176_1)
	end
end

function BattleLayout.updatePose(arg_177_0)
	if not arg_177_0._teamLayoutMap then
		return 
	end
	
	for iter_177_0, iter_177_1 in pairs(arg_177_0._teamLayoutMap) do
		iter_177_1:updatePose()
	end
end

function BattleLayout.updateModelPose(arg_178_0, arg_178_1)
	if not arg_178_0._teamLayoutMap then
		return 
	end
	
	for iter_178_0, iter_178_1 in pairs(arg_178_0._teamLayoutMap) do
		iter_178_1:updateModelPose(arg_178_1)
	end
end

function BattleLayout.updateMoveProcess(arg_179_0, arg_179_1)
	if not arg_179_0._defTeamLayout then
		return 
	end
	
	arg_179_0._defTeamLayout:updateMoveProcess(arg_179_1)
	
	local var_179_0 = false
	local var_179_1 = arg_179_0:getFieldPosition()
	
	if arg_179_0.vars.nextPosX and var_179_1 ~= arg_179_0.vars.nextPosX then
		if not arg_179_0.vars.nextDist then
			local var_179_2 = arg_179_0.vars.nextPosX - var_179_1
			
			arg_179_0.vars.begnPosX = var_179_1
			arg_179_0.vars.nextDirX = math.normalize(var_179_2, 1)
			arg_179_0.vars.nextDist = var_179_2
			arg_179_0.vars.moveDist = 0
			
			arg_179_0:setDirection(arg_179_0.vars.nextDirX, true)
		end
		
		local var_179_3 = arg_179_1 * WALK_SPEED * arg_179_0.vars.nextDirX
		
		arg_179_0.vars.moveDist = arg_179_0.vars.moveDist + var_179_3
		
		if math.abs(arg_179_0.vars.moveDist) >= math.abs(arg_179_0.vars.nextDist) then
			arg_179_0.vars.moveDist = arg_179_0.vars.nextDist
			arg_179_0.vars.nextDist = nil
			arg_179_0.vars.nextPosX = nil
			
			if arg_179_0.vars.moveFinishCB then
				arg_179_0.vars.moveFinishCB()
				
				arg_179_0.vars.moveFinishCB = nil
			end
		end
		
		local var_179_4 = arg_179_0.vars.begnPosX + arg_179_0.vars.moveDist
		
		arg_179_0:setFieldPosition(var_179_4, true)
		
		if arg_179_0._defTeamLayout then
			arg_179_0._defTeamLayout:updatePose()
			arg_179_0._defTeamLayout:updateModelPose(true)
		end
		
		return true
	end
end

function BattleLayout.setTeamDistance(arg_180_0, arg_180_1)
	arg_180_0._team_distance_set = arg_180_1
	
	arg_180_0:update()
end

function BattleLayout.getTeamDistance(arg_181_0)
	if not arg_181_0._team_distance or arg_181_0._team_distance ~= arg_181_0._team_distance_set then
		arg_181_0._team_distance = arg_181_0._team_distance_set or 2 * BATTLE_LAYOUT.XDIST_FROM_FOCUS
	end
	
	return arg_181_0._team_distance
end

function BattleLayout.getStoryLayout(arg_182_0, arg_182_1)
	if not arg_182_0._storyLayoutMap then
		return nil
	end
	
	for iter_182_0, iter_182_1 in pairs(arg_182_0._storyLayoutMap) do
		if iter_182_1.vars and iter_182_1.vars.uid and iter_182_1.vars.uid == arg_182_1 then
			return iter_182_1
		end
	end
end

function BattleLayout.setStoryLayoutMoverSpeed(arg_183_0, arg_183_1, arg_183_2)
	if not arg_183_0._storyLayoutMap then
		return nil
	end
	
	local var_183_0 = arg_183_0:getStoryLayout(arg_183_1)
	
	if not var_183_0 then
		return 
	end
	
	local var_183_1 = var_183_0.vars.slots[1]
	
	if not var_183_1 then
		return 
	end
	
	local var_183_2 = var_183_1.unit
	
	if not var_183_2 then
		return 
	end
	
	if var_183_2.mover then
		var_183_2.mover:setSpeed(arg_183_2)
	end
end

function BattleLayout.getStoryLayoutUnit(arg_184_0, arg_184_1)
	if not arg_184_0._storyLayoutMap then
		return nil
	end
	
	for iter_184_0, iter_184_1 in pairs(arg_184_0._storyLayoutMap) do
		if iter_184_1.vars and iter_184_1.vars.uid and iter_184_1.vars.uid == arg_184_1 then
			return iter_184_1.vars.slots[1].unit
		end
	end
end

function BattleLayout.getStoryLayoutModel(arg_185_0, arg_185_1)
	if not arg_185_0._storyLayoutMap then
		return nil
	end
	
	for iter_185_0, iter_185_1 in pairs(arg_185_0._storyLayoutMap) do
		if iter_185_1.vars and iter_185_1.vars.uid and iter_185_1.vars.uid == arg_185_1 then
			return iter_185_1.vars.slots[1].unit.model
		end
	end
end

function BattleLayout.getTeamLayout(arg_186_0, arg_186_1, arg_186_2)
	if not arg_186_0._teamLayoutMap then
		if arg_186_0._storyLayoutMap then
			if arg_186_2 then
				for iter_186_0, iter_186_1 in pairs(arg_186_0._storyLayoutMap) do
					if iter_186_1.vars and iter_186_1.vars.uid and iter_186_1.vars.uid == arg_186_2 then
						return iter_186_1
					end
				end
			else
				return arg_186_0._storyLayoutMap[1]
			end
		end
		
		return nil
	end
	
	return arg_186_0._teamLayoutMap[arg_186_1]
end

function BattleLayout.getUnitFieldPosition(arg_187_0, arg_187_1, arg_187_2, arg_187_3)
	return arg_187_0:getTeamLayout(arg_187_1.inst.ally, arg_187_1.uid):getUnitFieldPosition(arg_187_1, arg_187_2, arg_187_3)
end

function BattleLayout.getTeamOffset(arg_188_0, arg_188_1)
	local var_188_0 = (DESIGN_WIDTH - arg_188_0:getTeamDistance()) * 0.5
	local var_188_1 = BATTLE_LAYOUT.TEAM_Y
	
	if arg_188_0:isInverse(arg_188_1) then
		return DESIGN_WIDTH - var_188_0, var_188_1
	end
	
	return var_188_0, var_188_1
end

function BattleLayout.appearTeamLayout(arg_189_0, arg_189_1, arg_189_2, arg_189_3)
	arg_189_0:getTeamLayout(arg_189_1):appearEffect(arg_189_2, arg_189_3, Battle.is_screen_restoring)
end

function BattleLayout.getTeamRect(arg_190_0, arg_190_1)
	local var_190_0, var_190_1 = arg_190_0:getTeamOffset(arg_190_1)
	
	return cc.rect(var_190_0 - BATTLE_LAYOUT.TEAM_WIDTH / 2, var_190_1 - BATTLE_LAYOUT.TEAM_HEIGHT / 2, BATTLE_LAYOUT.TEAM_WIDTH, BATTLE_LAYOUT.TEAM_HEIGHT)
end

function BattleLayout.getTeamFront(arg_191_0, arg_191_1)
	local var_191_0, var_191_1 = arg_191_0:getTeamOffset(arg_191_1)
	local var_191_2 = BATTLE_LAYOUT.TEAM_WIDTH / 2 + BATTLE_LAYOUT.TEAM_FRONT
	
	if arg_191_0:isInverse(arg_191_1) then
		return var_191_0 - var_191_2, var_191_1
	end
	
	return var_191_0 + var_191_2, var_191_1
end

function BattleLayout.update(arg_192_0)
	if arg_192_0.prepos ~= arg_192_0:getFieldPosition() then
		arg_192_0.prepos = arg_192_0:getFieldPosition()
	end
	
	local var_192_0 = GET_LAST_TICK()
	local var_192_1 = (var_192_0 - (arg_192_0.processed_last_tick or var_192_0)) / 1000
	
	arg_192_0.processed_last_tick = var_192_0
	
	if arg_192_0:updateMoveProcess(var_192_1) then
		return 
	end
	
	if arg_192_0:isWalking() then
		local var_192_2 = arg_192_0:getDirection()
		
		if arg_192_0:isForwardLock() then
			if var_192_2 == (Battle.logic:getCurrentRoadInfo().road_reverse and -1 or 1) then
				return 
			else
				arg_192_0:setForwardLock(nil)
			end
		else
			local var_192_3 = WALK_SPEED * var_192_1 * var_192_2
			
			arg_192_0:setFieldPosition(arg_192_0:getFieldPosition() + var_192_3, true)
			
			if arg_192_0._defTeamLayout then
				arg_192_0._defTeamLayout:updatePose()
				arg_192_0._defTeamLayout:updateModelPose(true)
			end
		end
	end
end

function BattleLayout.updateOnStory(arg_193_0)
	if not arg_193_0._storyLayoutMap or table.empty(arg_193_0._storyLayoutMap) then
		return 
	end
	
	if not STORY_ACTION_MANAGER:isNotPausedStoryAction() then
		return 
	end
	
	if arg_193_0.prepos ~= arg_193_0:getFieldPosition() then
		arg_193_0.prepos = arg_193_0:getFieldPosition()
	end
	
	local var_193_0 = (STORY_ACTION_TICK - (arg_193_0.processed_last_tick_story or STORY_ACTION_TICK)) / 100
	
	arg_193_0.processed_last_tick_story = STORY_ACTION_TICK
	
	if arg_193_0:updateMoveProcessOnStory(var_193_0) then
		return 
	end
	
	if arg_193_0._storyLayoutMap then
		for iter_193_0, iter_193_1 in pairs(arg_193_0._storyLayoutMap) do
			iter_193_1:updatePose()
			iter_193_1:updateModelPose(true)
		end
	end
end

function BattleLayout.updateMoveProcessOnStory(arg_194_0, arg_194_1)
	if not arg_194_0._storyLayoutMap or table.empty(arg_194_0._storyLayoutMap) then
		return 
	end
	
	local function var_194_0()
		arg_194_0.vars.nextDist = nil
		arg_194_0.vars.nextDistY = nil
		arg_194_0.vars.nextPosX = nil
		arg_194_0.vars.nextPosY = nil
		arg_194_0.vars.elapsed_time = nil
		
		if arg_194_0.vars.moveFinishCB then
			arg_194_0.vars.moveFinishCB()
			
			arg_194_0.vars.moveFinishCB = nil
		end
	end
	
	for iter_194_0, iter_194_1 in pairs(arg_194_0._storyLayoutMap) do
		iter_194_1:updateMoveProcess(arg_194_1)
	end
	
	local var_194_1 = STORY_ACTION_MANAGER:getBGSpeed()
	local var_194_2 = false
	local var_194_3, var_194_4 = arg_194_0:getFieldPosition()
	
	if (arg_194_0.vars.nextPosX or arg_194_0.vars.nextPosY) and arg_194_0.vars.elapsed_time and var_194_1 <= arg_194_0.vars.elapsed_time then
		var_194_0()
	end
	
	local var_194_5 = false
	
	if arg_194_0.vars.nextPosY and var_194_4 ~= arg_194_0.vars.nextPosY then
		if not arg_194_0.vars.nextDistY then
			local var_194_6 = arg_194_0.vars.nextPosY - var_194_4
			
			arg_194_0.vars.begnPosY = var_194_4
			arg_194_0.vars.nextDistY = var_194_6
			
			if not arg_194_0.vars.elapsed_time then
				arg_194_0.vars.elapsed_time = 0
			end
		end
		
		local var_194_7 = var_0_0 * arg_194_1
		local var_194_8 = (arg_194_0.vars.elapsed_time + var_194_7) / var_194_1
		local var_194_9 = math.floor((arg_194_0.vars.nextPosY - arg_194_0.vars.begnPosY) * var_194_8 + arg_194_0.vars.begnPosY)
		
		if var_194_4 < arg_194_0.vars.nextPosY then
			var_194_9 = math.min(var_194_9, arg_194_0.vars.nextPosY)
		else
			var_194_9 = math.max(var_194_9, arg_194_0.vars.nextPosY)
		end
		
		arg_194_0:setFieldPositionY(var_194_9)
		
		var_194_5 = true
	end
	
	if arg_194_0.vars.nextPosX and var_194_3 ~= arg_194_0.vars.nextPosX then
		if not arg_194_0.vars.nextDist then
			local var_194_10 = arg_194_0.vars.nextPosX - var_194_3
			
			arg_194_0.vars.begnPosX = var_194_3
			arg_194_0.vars.nextDist = var_194_10
			
			if not arg_194_0.vars.elapsed_time then
				arg_194_0.vars.elapsed_time = 0
			end
		end
		
		local var_194_11 = var_0_0 * arg_194_1
		local var_194_12 = (arg_194_0.vars.elapsed_time + var_194_11) / var_194_1
		local var_194_13 = math.floor((arg_194_0.vars.nextPosX - arg_194_0.vars.begnPosX) * var_194_12 + arg_194_0.vars.begnPosX)
		
		if var_194_3 < arg_194_0.vars.nextPosX then
			var_194_13 = math.min(var_194_13, arg_194_0.vars.nextPosX)
		else
			var_194_13 = math.max(var_194_13, arg_194_0.vars.nextPosX)
		end
		
		arg_194_0:setFieldPosition(var_194_13)
		
		var_194_5 = true
	end
	
	if var_194_5 then
		if arg_194_0._storyLayoutMap then
			for iter_194_2, iter_194_3 in pairs(arg_194_0._storyLayoutMap) do
				iter_194_3:updatePose()
				iter_194_3:updateModelPose(true)
			end
		end
		
		arg_194_0.vars.elapsed_time = arg_194_0.vars.elapsed_time + var_0_0 * arg_194_1
		
		return true
	end
	
	if not arg_194_0.vars.nextPosX and not arg_194_0.vars.nextPosY or arg_194_0.vars.nextPosY and arg_194_0.vars.nextPosY == var_194_4 or arg_194_0.vars.nextPosX and arg_194_0.vars.nextPosX == var_194_3 then
		var_194_0()
	end
end

function BattleLayout.moveLayOutOnStory(arg_196_0, arg_196_1, arg_196_2, arg_196_3)
	if not arg_196_0._storyLayoutMap or table.empty(arg_196_0._storyLayoutMap) or not arg_196_1 then
		return 
	end
	
	local var_196_0
	
	for iter_196_0, iter_196_1 in pairs(arg_196_0._storyLayoutMap) do
		if iter_196_1.vars and iter_196_1.vars.uid and iter_196_1.vars.uid == arg_196_1 then
			var_196_0 = iter_196_1
			
			break
		end
	end
	
	if not var_196_0 then
		return 
	end
	
	var_196_0:setPosition(arg_196_2, arg_196_3)
	var_196_0:updatePose()
	var_196_0:updateModelPose(true)
end

function BattleLayout.updateLayoutMark(arg_197_0)
	local var_197_0 = IS_SHOW_LAYOUTMARK
	local var_197_1 = ":LAYOUT_DISPLAYER"
	
	if not BGI or not BGI.main.layer then
		return 
	end
	
	if not var_197_0 then
		BGI.main.layer:removeChildByName(var_197_1)
		
		return 
	end
	
	local var_197_2 = BGI.main.layer:getChildByName(var_197_1)
	
	if not var_197_2 then
		var_197_2 = cc.Layer:create()
		
		var_197_2:setName(var_197_1)
		BGI.main.layer:addChild(var_197_2)
	end
	
	var_197_2:removeAllChildren()
	
	local function var_197_3(arg_198_0, arg_198_1, arg_198_2)
		(function()
			if arg_198_1 then
				local var_199_0, var_199_1 = arg_198_1()
				local var_199_2 = cc.LayerColor:create(arg_198_0)
				
				var_197_2:addChild(var_199_2)
				var_199_2:setContentSize(7, 7)
				var_199_2:ignoreAnchorPointForPosition(false)
				var_199_2:setAnchorPoint(0.5, 0.5)
				var_199_2:setGlobalZOrder(1000)
				var_199_2:setPosition(var_199_0, var_199_1)
				var_199_2:scheduleUpdateWithPriorityLua(function(arg_200_0)
					local var_200_0, var_200_1 = arg_198_1()
					local var_200_2 = BattleLayout:getFieldPosition() - BATTLE_LAYOUT.XDIST_FROM_SIDE
					
					var_199_2:setPosition(var_200_2 + var_200_0, var_200_1)
				end, 1)
			end
			
			if arg_198_2 then
				local var_199_3 = cc.LayerColor:create(arg_198_0)
				
				var_199_3:setOpacity(80)
				var_197_2:addChild(var_199_3)
				
				local var_199_4 = arg_198_2()
				
				var_199_3:setContentSize(var_199_4.width, var_199_4.height)
				var_199_3:setGlobalZOrder(1000)
				var_199_3:scheduleUpdateWithPriorityLua(function(arg_201_0)
					local var_201_0 = BattleLayout:getFieldPosition() - BATTLE_LAYOUT.XDIST_FROM_SIDE
					local var_201_1 = arg_198_2()
					
					var_199_3:setPosition(var_201_0 + var_201_1.x, var_201_1.y)
				end, 1)
			end
		end)()
	end
	
	var_197_3(cc.c4b(100, 255, 100, 255), function()
		return arg_197_0:getTeamOffset()
	end, function()
		return arg_197_0:getTeamRect()
	end)
	var_197_3(cc.c4b(255, 100, 100, 255), function()
		return arg_197_0:getTeamOffset(ENEMY)
	end, function()
		return arg_197_0:getTeamRect(ENEMY)
	end)
	var_197_3(cc.c4b(0, 255, 0, 255), function()
		return arg_197_0:getTeamFront()
	end)
	var_197_3(cc.c4b(255, 0, 0, 255), function()
		return arg_197_0:getTeamFront(ENEMY)
	end)
end

function BattleLayout.convertToFieldPositionX(arg_208_0, arg_208_1)
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return arg_208_1
	end
	
	return arg_208_1 + (arg_208_0:getFocusPosition() - DESIGN_WIDTH / 2 * arg_208_0:getDirection())
end

function BattleLayout.convertToScreenX(arg_209_0, arg_209_1)
	if SceneManager:getCurrentSceneName() ~= "battle" then
		return arg_209_1
	end
	
	return arg_209_1 - (arg_209_0:getFocusPosition() - DESIGN_WIDTH / 2 * arg_209_0:getDirection())
end
