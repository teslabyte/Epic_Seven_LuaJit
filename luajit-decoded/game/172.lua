TeamLayoutEffect = ClassDef()

local var_0_0 = {
	[FRIEND] = ENEMY,
	[ENEMY] = FRIEND
}

local function var_0_1(arg_1_0)
	return var_0_0[arg_1_0]
end

function TeamLayoutEffect.constructor(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0.alone = arg_2_2.alone
	arg_2_0.info = arg_2_2
	arg_2_0.fade_time = math.max(0, math.min(arg_2_2.time or 0, arg_2_2.fade or 0))
	arg_2_0.TOTAL_TIME = arg_2_2.time or 0
	arg_2_0.mode = arg_2_2.mode or UNIT_LAYOUT_CHANGE_MODE.GO_AWAY
	arg_2_0.stroy_mode = is_using_story_v2()
	
	local var_2_0 = {}
	
	for iter_2_0, iter_2_1 in pairs(arg_2_3.units.friends) do
		if arg_2_1 ~= iter_2_1 then
			table.insert(var_2_0, iter_2_1)
		end
	end
	
	arg_2_0.friends = {
		to_opacity = true,
		ally = arg_2_1.inst.ally,
		unit = arg_2_1,
		units = var_2_0
	}
	
	local var_2_1 = {}
	
	for iter_2_2, iter_2_3 in pairs(arg_2_3.units.hide_units or {}) do
		if arg_2_1 ~= iter_2_3 then
			table.insert(var_2_1, iter_2_3)
		end
	end
	
	arg_2_0.hide_units = {
		to_opacity = true,
		units = var_2_1
	}
	
	local var_2_2
	
	if arg_2_3.att_info.d_unit.inst.ally ~= arg_2_1.inst.ally then
		var_2_2 = arg_2_3.att_info.d_unit
	end
	
	if not var_2_2 and arg_2_3.att_info.d_unit and arg_2_0.stroy_mode then
		var_2_2 = arg_2_3.att_info.d_unit
	end
	
	arg_2_0.enemies = {
		ally = var_0_1(arg_2_1.inst.ally),
		unit = var_2_2,
		units = arg_2_3.units.enemies,
		to_opacity = arg_2_0.alone
	}
end

function TeamLayoutEffect.initPosVar(arg_3_0)
	local var_3_0 = arg_3_0.friends.unit
	local var_3_1
	local var_3_2
	
	if var_3_0 then
		var_3_1 = var_3_0.uid
	end
	
	if arg_3_0.enemies.units and arg_3_0.enemies.units[1] then
		var_3_2 = arg_3_0.enemies.units[1].uid
	end
	
	arg_3_0.friends.layout = BattleLayout:getTeamLayout(arg_3_0.friends.ally, var_3_1)
	arg_3_0.enemies.layout = BattleLayout:getTeamLayout(arg_3_0.enemies.ally, var_3_2)
	arg_3_0.self_start_x, arg_3_0.self_start_y = arg_3_0.friends.layout:getOffset()
	arg_3_0.away_start_x, arg_3_0.away_start_y = arg_3_0.enemies.layout:getOffset()
	
	if arg_3_0.mode == UNIT_LAYOUT_CHANGE_MODE.GO_AWAY then
		local var_3_3 = 0 - BattleLayout:getDirection()
		local var_3_4 = arg_3_0.enemies.layout:getDirection() * var_3_3
		local var_3_5 = var_3_4
		local var_3_6, var_3_7 = arg_3_0.friends.layout:getWorldPosition()
		
		if var_3_0:isSummon() then
			local var_3_8 = var_3_0.logic:getTurnOwner()
			
			var_3_6 = var_3_6 - var_3_8.x
			var_3_7 = var_3_7 - var_3_8.y
		else
			var_3_6 = var_3_6 - var_3_0.x
			var_3_7 = var_3_7 - var_3_0.y
		end
		
		arg_3_0.self_dir_x, arg_3_0.self_dir_y = (arg_3_0.info.self_x or 0) * var_3_5 + var_3_6 - arg_3_0.self_start_x, (arg_3_0.info.self_y or 0) + var_3_7 - arg_3_0.self_start_y
		
		if arg_3_0.alone and arg_3_0.enemies.unit then
			local var_3_9 = arg_3_0.enemies.unit
			
			var_3_6, var_3_7 = arg_3_0.enemies.layout:getWorldPosition()
			var_3_6 = var_3_6 - var_3_9.x
			var_3_7 = var_3_7 - var_3_9.y
		else
			var_3_6, var_3_7 = 0, 0
		end
		
		local var_3_10 = var_3_6
		
		if arg_3_0.enemies.ally == ENEMY then
			var_3_6 = var_3_6 + var_3_4 * (BATTLE_LAYOUT.CONTENTS_GAP * 2)
		end
		
		arg_3_0.away_dir_x, arg_3_0.away_dir_y = (arg_3_0.info.away_x or 0) * var_3_4 + var_3_6 - arg_3_0.away_start_x, (arg_3_0.info.away_y or 0) + var_3_7 - arg_3_0.away_start_y
	else
		arg_3_0.self_dir_x, arg_3_0.self_dir_y = arg_3_0.friends.layout:getOffset()
		arg_3_0.away_dir_x, arg_3_0.away_dir_y = arg_3_0.enemies.layout:getOffset()
	end
	
	arg_3_0.inited_pos = true
end

function TeamLayoutEffect.initPosVarStory(arg_4_0)
	local var_4_0 = arg_4_0.friends.unit
	local var_4_1
	local var_4_2
	
	if var_4_0 then
		var_4_1 = var_4_0.uid
	end
	
	if arg_4_0.enemies.units and arg_4_0.enemies.units[1] then
		local var_4_3 = arg_4_0.enemies.units[1].uid
	end
	
	arg_4_0.friends.layout = BattleLayout:getTeamLayout(arg_4_0.friends.ally, var_4_1)
	arg_4_0.self_start_x, arg_4_0.self_start_y = arg_4_0.friends.layout:getOffset()
	arg_4_0.enemies.layouts = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.enemies.units) do
		local var_4_4 = BattleLayout:getTeamLayout(arg_4_0.enemies.ally, iter_4_1.uid)
		
		var_4_4.away_start_x, var_4_4.away_start_y = var_4_4:getOffset()
		
		table.insert(arg_4_0.enemies.layouts, var_4_4)
	end
	
	if arg_4_0.mode == UNIT_LAYOUT_CHANGE_MODE.GO_AWAY then
		for iter_4_2, iter_4_3 in pairs(arg_4_0.enemies.layouts) do
			local var_4_5 = 0 - BattleLayout:getDirection()
			local var_4_6 = iter_4_3:getDirection() * var_4_5
			local var_4_7 = var_4_6
			local var_4_8, var_4_9 = arg_4_0.friends.layout:getWorldPosition()
			
			if var_4_0:isSummon() and var_4_0.logic then
				local var_4_10 = var_4_0.logic:getTurnOwner()
				
				var_4_8 = var_4_8 - var_4_10.x
				var_4_9 = var_4_9 - var_4_10.y
			else
				var_4_8 = var_4_8 - var_4_0.x
				var_4_9 = var_4_9 - var_4_0.y
			end
			
			arg_4_0.self_dir_x, arg_4_0.self_dir_y = (arg_4_0.info.self_x or 0) * var_4_7 + var_4_8 - arg_4_0.self_start_x, (arg_4_0.info.self_y or 0) + var_4_9 - arg_4_0.self_start_y
			
			if arg_4_0.alone and arg_4_0.enemies.unit then
				local var_4_11 = arg_4_0.enemies.unit
				
				var_4_8, var_4_9 = iter_4_3:getWorldPosition()
				var_4_8 = var_4_8 - var_4_11.x
				var_4_9 = var_4_9 - var_4_11.y
			else
				var_4_8, var_4_9 = 0, 0
			end
			
			iter_4_3.away_dir_x, iter_4_3.away_dir_y = (arg_4_0.info.away_x or 0) * var_4_6 + var_4_8 - iter_4_3.away_start_x, (arg_4_0.info.away_y or 0) + var_4_9 - iter_4_3.away_start_y
		end
	else
		arg_4_0.self_dir_x, arg_4_0.self_dir_y = arg_4_0.friends.layout:getOffset()
		
		for iter_4_4, iter_4_5 in pairs(arg_4_0.enemies.layouts) do
			iter_4_5.away_dir_x, iter_4_5.away_dir_y = iter_4_5:getOffset()
		end
	end
	
	arg_4_0.inited_pos = true
end

function TeamLayoutEffect.updateOpcacity(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_1.to_opacity or arg_5_3 then
		for iter_5_0, iter_5_1 in pairs(arg_5_1.units) do
			if not iter_5_1:isDead() and arg_5_1.unit ~= iter_5_1 then
				if arg_5_3 then
					iter_5_1.model:setOpacityByKey("@TEAM_LAYOUT", math.max(iter_5_1.model:getOpacityByKey("@TEAM_LAYOUT"), (1 - arg_5_2) * 255))
				else
					iter_5_1.model:setOpacityByKey("@TEAM_LAYOUT", (1 - arg_5_2) * 255)
				end
			end
		end
	end
end

function TeamLayoutEffect.updateHideUnitOpcacity(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_1.to_opacity or arg_6_3 then
		for iter_6_0, iter_6_1 in pairs(arg_6_1.units) do
			if not iter_6_1:isDead() then
				if arg_6_3 then
					iter_6_1.model:setOpacityByKey("@TEAM_LAYOUT", math.max(iter_6_1.model:getOpacityByKey("@TEAM_LAYOUT"), (1 - arg_6_2) * 255))
				else
					iter_6_1.model:setOpacityByKey("@TEAM_LAYOUT", (1 - arg_6_2) * 255)
				end
			end
		end
	end
end

function TeamLayoutEffect.Update(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.inited_pos then
		if arg_7_0.stroy_mode then
			arg_7_0:initPosVarStory()
		else
			arg_7_0:initPosVar()
		end
	end
	
	local var_7_0 = math.min(1, (arg_7_1.elapsed_time + (arg_7_2 or 0)) / arg_7_0.TOTAL_TIME)
	
	if var_7_0 ~= var_7_0 then
		var_7_0 = 1
	end
	
	local var_7_1
	
	if arg_7_0.mode == UNIT_LAYOUT_CHANGE_MODE.GO_AWAY then
		local var_7_2 = var_7_0
		
		arg_7_0.friends.layout:setOffset(arg_7_0.self_dir_x * var_7_2 + arg_7_0.self_start_x, arg_7_0.self_dir_y * var_7_2 + arg_7_0.self_start_y, "@LayoutEffect")
		
		if arg_7_0.stroy_mode then
			for iter_7_0, iter_7_1 in pairs(arg_7_0.enemies.layouts) do
				iter_7_1:setOffset(iter_7_1.away_dir_x * var_7_2 + iter_7_1.away_start_x, iter_7_1.away_dir_y * var_7_2 + iter_7_1.away_start_y, "@LayoutEffect")
			end
		else
			arg_7_0.enemies.layout:setOffset(arg_7_0.away_dir_x * var_7_2 + arg_7_0.away_start_x, arg_7_0.away_dir_y * var_7_2 + arg_7_0.away_start_y, "@LayoutEffect")
		end
		
		arg_7_0:updateOpcacity(arg_7_0.friends, var_7_2)
		arg_7_0:updateOpcacity(arg_7_0.enemies, var_7_2, nil)
		arg_7_0:updateHideUnitOpcacity(arg_7_0.hide_units, 1)
	else
		local var_7_3 = 1 - var_7_0
		
		if arg_7_0.stroy_mode then
			for iter_7_2, iter_7_3 in pairs(arg_7_0.enemies.layouts) do
				iter_7_3:setOffset(iter_7_3.away_start_x * var_7_3, iter_7_3.away_start_y * var_7_3, "@LayoutEffect")
			end
		else
			arg_7_0.enemies.layout:setOffset(arg_7_0.away_start_x * var_7_3, arg_7_0.away_start_y * var_7_3, "@LayoutEffect")
		end
		
		arg_7_0.friends.layout:setOffset(arg_7_0.self_start_x * var_7_3, arg_7_0.self_start_y * var_7_3, "@LayoutEffect")
		arg_7_0:updateOpcacity(arg_7_0.friends, var_7_3, true)
		arg_7_0:updateOpcacity(arg_7_0.enemies, var_7_3, true)
		arg_7_0:updateHideUnitOpcacity(arg_7_0.hide_units, var_7_3, true)
	end
	
	arg_7_0.friends.layout:updatePose()
	arg_7_0.friends.layout:updateModelPose()
	
	if arg_7_0.stroy_mode then
		for iter_7_4, iter_7_5 in pairs(arg_7_0.enemies.layouts) do
			iter_7_5:updatePose()
			iter_7_5:updateModelPose()
		end
	else
		arg_7_0.enemies.layout:updatePose()
		arg_7_0.enemies.layout:updateModelPose()
	end
end

function TeamLayoutEffect.Finish(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1.elapsed_time = arg_8_0.TOTAL_TIME
	
	arg_8_0:Update(arg_8_1, arg_8_2)
end

UnitMoveAction = ClassDef()

function UnitMoveAction.constructor(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_0.target = arg_9_1
	arg_9_0.TOTAL_TIME = arg_9_4 or 0
	arg_9_0.POWER = arg_9_2.power or 0
	arg_9_0.location = arg_9_2.location
	arg_9_0.locationParam = arg_9_2.locationParam
	arg_9_0.locationForce = arg_9_2.locationForce
	arg_9_0.info = arg_9_2
	arg_9_0.params = arg_9_3
	arg_9_0.distance = 0
	arg_9_0.zorder_by_y = arg_9_5
	
	if not arg_9_0.target.getShadowY then
		function arg_9_0.target.getShadowY(arg_10_0)
			return 0
		end
	end
	
	if not arg_9_0.target.setShadowY then
		function arg_9_0.target.setShadowY(arg_11_0)
		end
	end
	
	if arg_9_1:getScaleX() < 0 then
		arg_9_0.offset_x = -(arg_9_0.info.x or 0)
	else
		arg_9_0.offset_x = arg_9_0.info.x or 0
	end
	
	arg_9_0.target_h = arg_9_0.info.h or 0
	arg_9_0.offset_y = (arg_9_0.info.y or 0) + arg_9_0.target_h
	
	local var_9_0 = arg_9_0.info.style
	
	if var_9_0 == MOVE_STYLE.Jump then
		arg_9_0.Update = UnitMoveAction.DoJumpUpdate
	elseif var_9_0 == MOVE_STYLE.Warp then
		arg_9_0.Update = UnitMoveAction.DoWarpUpdate
	else
		arg_9_0.Update = UnitMoveAction.DoMoveUpdate
	end
end

function UnitMoveAction.Start(arg_12_0)
	arg_12_0.start_x, arg_12_0.start_y = arg_12_0.target:getPosition()
	arg_12_0.start_h = arg_12_0.target:getShadowY()
	arg_12_0.start_z = arg_12_0.target:getLocalZOrder()
	arg_12_0.pivotObject = StageStateManager:getLocationPivotObject(arg_12_0.location, arg_12_0.locationParam, arg_12_0.locationForce, arg_12_0.params.att_info)
	
	if LOCATION_TYPE_VER2.Field_TargetFront == arg_12_0.location then
		local var_12_0 = {
			width = 0,
			height = 0,
			x = 0,
			y = 0
		}
		local var_12_1
		
		if arg_12_0.target.getAttachmentBoundingBox then
			var_12_1 = arg_12_0.target:getAttachmentBoundingBox("bounding_box", "bounding_box") or {
				width = 0,
				height = 0,
				x = 0,
				y = 0
			}
		else
			var_12_1 = {
				width = 0,
				height = 0,
				x = 0,
				y = 0
			}
		end
		
		arg_12_0.distance = (var_12_1.width * 0.5 + var_12_0.width * 0.5 + 50) * (arg_12_0.target:getScaleX() / math.abs(arg_12_0.target:getScaleX()))
	end
end

function UnitMoveAction.getTargetPos(arg_13_0)
	local var_13_0, var_13_1 = arg_13_0.pivotObject:getWorldPosition()
	
	if LOCATION_TYPE_VER2.Field_TargetFront == arg_13_0.location then
		var_13_0 = var_13_0 - arg_13_0.distance
	end
	
	return var_13_0 + arg_13_0.offset_x, var_13_1 + arg_13_0.offset_y, arg_13_0.target_h
end

function UnitMoveAction.getRate(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.elapsed_time / arg_14_0.TOTAL_TIME
	
	if var_14_0 ~= var_14_0 then
		var_14_0 = 1
	end
	
	return var_14_0
end

function UnitMoveAction.DoWarpUpdate(arg_15_0, arg_15_1)
	if arg_15_0:getRate(arg_15_1) < 1 then
		arg_15_0.target:setPosition(arg_15_0.start_x, arg_15_0.start_y)
		arg_15_0.target:setLocalZOrder(arg_15_0.start_z)
		arg_15_0.target:setShadowY(arg_15_0.start_h)
	else
		local var_15_0, var_15_1, var_15_2 = arg_15_0:getTargetPos()
		local var_15_3 = arg_15_0.pivotObject:getLocalZOrder() + 10
		
		arg_15_0.target:setPosition(var_15_0, var_15_1)
		arg_15_0.target:setShadowY(var_15_2)
		arg_15_0.target:setLocalZOrder(var_15_3)
	end
end

function UnitMoveAction.DoJumpUpdate(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0:getRate(arg_16_1)
	local var_16_1, var_16_2, var_16_3 = arg_16_0:getTargetPos()
	local var_16_4 = arg_16_0.pivotObject:getLocalZOrder() + 10
	local var_16_5 = math.log(1 + 4 * var_16_0, 5) / 1
	local var_16_6 = arg_16_0.start_x + (var_16_1 - arg_16_0.start_x) * var_16_5
	local var_16_7 = arg_16_0.start_y + (var_16_2 - arg_16_0.start_y) * var_16_0 + math.sin(var_16_5 * math.pi) * arg_16_0.POWER
	local var_16_8 = arg_16_0.start_h + (var_16_3 - arg_16_0.start_h) * var_16_0 + math.sin(var_16_5 * math.pi) * arg_16_0.POWER
	local var_16_9 = arg_16_0.start_z + (var_16_4 - arg_16_0.start_z) * var_16_0
	
	if arg_16_0.zorder_by_y and LOCATION_TYPE_VER2.Field_Self ~= arg_16_0.location then
		var_16_9 = -var_16_7
	end
	
	arg_16_0.target:setPosition(var_16_6, var_16_7)
	arg_16_0.target:setShadowY(var_16_8)
	arg_16_0.target:setLocalZOrder(var_16_9)
end

function UnitMoveAction.DoMoveUpdate(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0:getRate(arg_17_1)
	local var_17_1, var_17_2, var_17_3 = arg_17_0:getTargetPos()
	local var_17_4 = arg_17_0.pivotObject:getLocalZOrder() + 10
	local var_17_5 = arg_17_0.start_x + (var_17_1 - arg_17_0.start_x) * var_17_0
	local var_17_6 = arg_17_0.start_y + (var_17_2 - arg_17_0.start_y) * var_17_0
	local var_17_7 = arg_17_0.start_h + (var_17_3 - arg_17_0.start_h) * var_17_0
	local var_17_8 = arg_17_0.start_z + (var_17_4 - arg_17_0.start_z) * var_17_0
	
	if arg_17_0.zorder_by_y and LOCATION_TYPE_VER2.Field_Self ~= arg_17_0.location then
		var_17_8 = -var_17_6
	end
	
	arg_17_0.target:setPosition(var_17_5, var_17_6)
	arg_17_0.target:setShadowY(var_17_7)
	arg_17_0.target:setLocalZOrder(var_17_8)
end

function UnitMoveAction.Finish(arg_18_0, arg_18_1, arg_18_2)
	arg_18_1.elapsed_time = arg_18_0.TOTAL_TIME
	
	arg_18_0:Update(arg_18_1, arg_18_2)
	
	if LOCATION_TYPE_VER2.Field_Self == arg_18_0.location then
		local var_18_0 = arg_18_0.pivotObject:getLocalZOrder()
		
		arg_18_0.target:setLocalZOrder(var_18_0)
	end
end

StageUtils = {}

function StageUtils.setMetatable(arg_19_0, arg_19_1)
	local var_19_0 = {}
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0) do
		var_19_0[iter_19_0] = iter_19_1
		
		rawset(arg_19_0, iter_19_0, nil)
	end
	
	setmetatable(arg_19_0, arg_19_1)
	
	for iter_19_2, iter_19_3 in pairs(var_19_0) do
		arg_19_0[iter_19_2] = iter_19_3
	end
end

function StageUtils.getEnemyAlly(arg_20_0)
	return var_0_1(arg_20_0)
end

function StageUtils.shotSkill(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local function var_21_0(arg_22_0)
		local var_22_0
		
		if string.ends(arg_22_0, ".cfx") or string.ends(arg_22_0, ".scsp") then
			var_22_0 = CACHE:getEffect(arg_22_0)
			
			var_22_0:start()
		else
			local var_22_1 = arg_21_1.model:getScaleY()
			
			var_22_0 = arg_21_1.model:getSprite(arg_22_0)
			var_22_0 = var_22_0 or cc.Node:create()
			
			var_22_0:setScaleFactor(BASE_SCALE)
			var_22_0:setScale(var_22_1)
		end
		
		return var_22_0
	end
	
	local var_21_1 = arg_21_3.selfBone or "arrow_start"
	local var_21_2 = arg_21_3.targetBone or "target"
	local var_21_3 = arg_21_0:reformValue(arg_21_3.source or "arrow")
	local var_21_4 = arg_21_3.interval or 100
	local var_21_5, var_21_6 = arg_21_1.model:getBonePosition(var_21_1)
	local var_21_7, var_21_8 = arg_21_2.model:getBonePosition(var_21_2)
	local var_21_9 = arg_21_3.count or 1
	local var_21_10 = arg_21_3.rotate or 90
	
	if arg_21_1.model:getScaleX() < 0 then
		var_21_10 = -var_21_10
	end
	
	local var_21_11 = 1000
	
	for iter_21_0 = 1, var_21_9 do
		local var_21_12 = var_21_0(var_21_3)
		
		if not var_21_12 then
			return 
		end
		
		var_21_12:setLocalZOrder(arg_21_2.model:getLocalZOrder() + 1)
		var_21_12:setPosition(var_21_5, var_21_6)
		var_21_12:setRotation(var_21_10)
		BGIManager:getBGI().main.layer:addChild(var_21_12)
		BattleAction:Add(SEQ(DELAY((iter_21_0 - 1) * var_21_4), LOG(MOVE_TO(arg_21_5, var_21_7, var_21_8), 3), SHOW(false), CALL(function(arg_23_0)
			if arg_23_0 then
				LuaEventDispatcher:dispatchEvent("battle.event", "Fire", {
					sender = "shot",
					unit = arg_21_1
				})
			end
		end, arg_21_3.fire), DELAY(var_21_11), STOP()), var_21_12, "battle")
	end
end

function StageUtils.prepareCameraAni(arg_24_0)
	if not arg_24_0 then
		return 
	end
	
	local var_24_0 = arg_24_0
	
	if not var_24_0:find("/") then
		var_24_0 = "camera/" .. var_24_0
	end
	
	if not var_24_0:ends(".scsp") then
		var_24_0 = var_24_0 .. ".scsp"
	end
	
	preload(var_24_0)
end
