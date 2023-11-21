PivotBase = ClassDef()

function PivotBase.constructor(arg_1_0)
	arg_1_0.offset_x, arg_1_0.offset_y, arg_1_0.offset_zOrder = 0, 0, 0
end

function PivotBase.getLocalZOrder(arg_2_0)
	return 0
end

function PivotBase.isValidate(arg_3_0)
	return true
end

function PivotBase.setOffset(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.offset_x, arg_4_0.offset_y = arg_4_1 or 0, arg_4_2 or 0
end

function PivotBase.setOffsetZOrder(arg_5_0, arg_5_1)
	arg_5_0.offset_zOrder = arg_5_1 or 0
end

function PivotBase.setFollower(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0.follower = arg_6_1
	
	if arg_6_2 then
		arg_6_0.offset_x = arg_6_2
	end
	
	if arg_6_3 then
		arg_6_0.offset_y = arg_6_3
	end
	
	if arg_6_4 then
		arg_6_0.offset_zOrder = arg_6_4
	end
	
	if get_cocos_refid(arg_6_0.follower) then
		Scheduler:add(arg_6_0.follower, PivotBase.updateFollower, arg_6_0, arg_6_5).priority = "afterdraw"
	end
end

function PivotBase.updateFollower(arg_7_0, arg_7_1)
	if get_cocos_refid(arg_7_0.follower) then
		if isusertype(arg_7_0.ref, "cc.Ref") and not get_cocos_refid(arg_7_0.ref) then
			return 
		end
		
		local var_7_0, var_7_1 = arg_7_0:getWorldPosition()
		local var_7_2 = arg_7_0:getLocalZOrder()
		
		arg_7_0.follower:setPosition(var_7_0 + (arg_7_0.offset_x or 0), var_7_1 + (arg_7_0.offset_y or 0))
		arg_7_0.follower:setLocalZOrder(var_7_2 + (arg_7_0.offset_zOrder or 0))
		arg_7_0.follower:update(0)
	end
	
	if arg_7_1 then
		arg_7_1()
	end
end

ScreenCenterPivot = ClassDef(PivotBase)

function ScreenCenterPivot.constructor(arg_8_0)
end

function ScreenCenterPivot.getPosition(arg_9_0)
	return 0, 0
end

function ScreenCenterPivot.getWorldPosition(arg_10_0)
	local var_10_0 = BATTLE_LAYOUT.XDIST_FROM_FOCUS * BattleLayout:getDirection()
	local var_10_1 = 0
	local var_10_2, var_10_3 = BattleLayout:getFieldPosition()
	
	if is_using_story_v2() then
		return (var_10_2 or 0) + (var_10_0 or 0), (var_10_3 or 0) + (var_10_1 or 0) + DESIGN_HEIGHT * CAM_ANCHOR_Y
	else
		return (var_10_2 or 0) + (var_10_0 or 0), (var_10_1 or 0) + DESIGN_HEIGHT * CAM_ANCHOR_Y
	end
end

ScreenViewCenterPivot = ClassDef(PivotBase)

function ScreenViewCenterPivot.constructor(arg_11_0)
end

function ScreenViewCenterPivot.getPosition(arg_12_0)
	return 0, 0
end

function ScreenViewCenterPivot.getWorldPosition(arg_13_0)
	return DESIGN_WIDTH * CAM_ANCHOR_X, DESIGN_HEIGHT * CAM_ANCHOR_Y
end

ScreenFlexiblePivot = ClassDef(PivotBase)

function ScreenFlexiblePivot.constructor(arg_14_0)
end

function ScreenFlexiblePivot.getPosition(arg_15_0)
	return 0, 0
end

function ScreenFlexiblePivot.getWorldPosition(arg_16_0)
	local var_16_0 = BATTLE_LAYOUT.XDIST_FROM_FOCUS * BattleLayout:getDirection()
	
	if not arg_16_0.current_flexing_x then
		arg_16_0.current_flexing_x = var_16_0
	end
	
	if arg_16_0.target_flexing_x ~= var_16_0 then
		arg_16_0.flexing_tick = LAST_TICK
		arg_16_0.target_flexing_x = var_16_0
		arg_16_0.target_distance_x = arg_16_0.target_flexing_x - arg_16_0.current_flexing_x
	end
	
	if arg_16_0.target_flexing_x ~= arg_16_0.current_flexing_x then
		local var_16_1 = math.min(1, (LAST_TICK - arg_16_0.flexing_tick) * 1.8 / 1000)
		
		arg_16_0.current_flexing_x = arg_16_0.target_flexing_x - arg_16_0.target_distance_x * (1 - var_16_1)
	end
	
	local var_16_2 = arg_16_0.current_flexing_x
	local var_16_3, var_16_4 = BattleLayout:getFieldPosition()
	
	if is_using_story_v2() then
		return (var_16_3 or 0) + (var_16_2 or 0), (var_16_4 or 0) + DESIGN_HEIGHT * CAM_ANCHOR_Y
	else
		return (var_16_3 or 0) + (var_16_2 or 0), DESIGN_HEIGHT * CAM_ANCHOR_Y
	end
end

PivotByBone = ClassDef(PivotBase)

function PivotByBone.constructor(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0.ref = arg_17_1
	arg_17_0.owner = arg_17_2
end

function PivotByBone.getLocalZOrder(arg_18_0)
	if get_cocos_refid(arg_18_0.owner) then
		return arg_18_0.owner:getLocalZOrder()
	end
	
	return arg_18_0.ref:getBoneOwner():getLocalZOrder()
end

function PivotByBone.getPosition(arg_19_0)
	return arg_19_0.ref:getPosition()
end

function PivotByBone.getWorldPosition(arg_20_0)
	local function var_20_0(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
		local var_21_0, var_21_1 = arg_21_0:getPosition()
		
		return var_21_0 * arg_21_3 + arg_21_1, var_21_1 * arg_21_4 + arg_21_2, arg_21_3 * arg_21_0:getRealScaleX(), arg_21_4 * arg_21_0:getRealScaleY()
	end
	
	if not get_cocos_refid(arg_20_0.ref) then
		return 0, 0
	end
	
	if arg_20_0.ref.getBoneOwner then
		local var_20_1 = arg_20_0.ref:getBoneOwner()
		local var_20_2, var_20_3, var_20_4, var_20_5 = var_20_0(var_20_1:getParent(), 0, 0, 1, 1)
		local var_20_6, var_20_7, var_20_8, var_20_9 = var_20_0(var_20_1, var_20_2, var_20_3, var_20_4, var_20_5)
		local var_20_10, var_20_11 = var_20_0(arg_20_0.ref, var_20_6, var_20_7, var_20_8, var_20_9)
		local var_20_12 = var_20_11
		
		return var_20_10, var_20_12
	end
	
	return arg_20_0.ref:getPosition()
end

PivotByModel = ClassDef(PivotBase)

function PivotByModel.constructor(arg_22_0, arg_22_1)
	arg_22_0.ref = arg_22_1
	
	if arg_22_0.ref.getAttachmentBoundingBox then
		arg_22_0.boundingBox = arg_22_0.ref:getAttachmentBoundingBox("bounding_box", "bounding_box") or {
			0,
			0,
			0,
			0
		}
		arg_22_0.frontDist = arg_22_0.ref:getScaleX() / math.abs(arg_22_0.ref:getScaleX()) * arg_22_0.boundingBox.width * 0.5
	else
		arg_22_0.boundingBox = {
			0,
			0,
			0,
			0
		}
		arg_22_0.frontDist = 0
	end
end

function PivotByModel.getLocalZOrder(arg_23_0)
	return arg_23_0.ref:getLocalZOrder()
end

function PivotByModel.getPosition(arg_24_0)
	return 0, 0
end

function PivotByModel.getFrontDistance(arg_25_0)
	return arg_25_0.frontDist
end

function PivotByModel.getWorldPosition(arg_26_0)
	return arg_26_0.ref:getPosition()
end

function PivotByModel.isValidate(arg_27_0)
	if isusertype(arg_27_0.ref, "cc.Ref") and not get_cocos_refid(arg_27_0.ref) then
		return false
	end
	
	return true
end

PivotByUnit = ClassDef(PivotBase)

function PivotByUnit.constructor(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0.ref = arg_28_1
	arg_28_0.frontDist = 0
	arg_28_0.pivot_bone = arg_28_2
	arg_28_0.pivot_x = 0
	arg_28_0.pivot_y = 0
	
	arg_28_0:updatePivotProp()
end

function PivotByUnit.updatePivotProp(arg_29_0)
	if not arg_29_0.inited_prop and get_cocos_refid(arg_29_0.ref.model) then
		arg_29_0.direction = math.normalize(arg_29_0.ref.model:getScaleX(), 1)
		arg_29_0.boundingBox = arg_29_0.ref.model:getAttachmentBoundingBox("bounding_box", "bounding_box") or {
			width = 0,
			height = 0,
			x = 0,
			y = 0
		}
		arg_29_0.frontDist = arg_29_0.direction * math.max(75, arg_29_0.boundingBox.width * 0.5)
		
		local var_29_0 = 0
		local var_29_1 = 0
		
		if arg_29_0.pivot_bone then
			local var_29_2 = arg_29_0.ref.model:getBoneNode(arg_29_0.pivot_bone)
			
			if var_29_2 then
				var_29_0, var_29_1 = var_29_2:getPosition()
			end
		end
		
		arg_29_0.pivot_x = var_29_0 * arg_29_0.direction
		arg_29_0.pivot_y = var_29_1
		arg_29_0.inited_prop = true
	end
end

function PivotByUnit.getLocalZOrder(arg_30_0)
	return arg_30_0.ref.z
end

function PivotByUnit.getPosition(arg_31_0)
	return 0, 0
end

function PivotByUnit.getFrontDistance(arg_32_0)
	arg_32_0:updatePivotProp()
	
	return arg_32_0.frontDist
end

function PivotByUnit.getWorldPosition(arg_33_0)
	local var_33_0, var_33_1 = BattleLayout:getUnitFieldPosition(arg_33_0.ref)
	
	if get_cocos_refid(arg_33_0.ref.model) then
		arg_33_0:updatePivotProp()
		
		return var_33_0 + arg_33_0.pivot_x * arg_33_0.ref.model:getRealScaleX(), var_33_1 + arg_33_0.pivot_y * arg_33_0.ref.model:getRealScaleY()
	end
	
	return var_33_0, var_33_1
end

function PivotByUnit.isValidate(arg_34_0)
	if arg_34_0.inited_prop and isusertype(arg_34_0.ref.model, "cc.Ref") and not get_cocos_refid(arg_34_0.ref.model) then
		return false
	end
	
	return true
end

PivotByTarget = ClassDef(PivotBase)

function PivotByTarget.constructor(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_0.ref = arg_35_1
	arg_35_0.frontDist = 0
	arg_35_0.target = arg_35_2 or 0
	arg_35_0.bone_name = arg_35_3 and "field" or "target"
	
	arg_35_0:updatePivotProp()
end

function PivotByTarget.updatePivotProp(arg_36_0)
	if not arg_36_0.inited_prop and get_cocos_refid(arg_36_0.ref.model) then
		arg_36_0.direction = BattleLayout:getAllyDirection(arg_36_0.ref.inst.ally) or 1
		
		local var_36_0 = arg_36_0.target == 0 and "" or arg_36_0.target
		local var_36_1 = "bounding_box" .. var_36_0
		
		arg_36_0.boundingBox = arg_36_0.ref.model:getAttachmentBoundingBox(var_36_1, "bounding_box") or {
			width = 0,
			height = 0,
			x = 0,
			y = 0
		}
		arg_36_0.frontDist = arg_36_0.direction * math.max(75, arg_36_0.boundingBox.width * 0.5)
		arg_36_0.target_bone = arg_36_0.ref.model:getBoneNode(arg_36_0.bone_name .. var_36_0)
		arg_36_0.inited_prop = true
	end
end

function PivotByTarget.getLocalZOrder(arg_37_0)
	return arg_37_0.ref.z + arg_37_0.target
end

function PivotByTarget.getPosition(arg_38_0)
	if not arg_38_0.target_bone then
		return 0, 0
	end
	
	local var_38_0, var_38_1 = arg_38_0.target_bone:getPosition()
	
	return var_38_0, var_38_1
end

function PivotByTarget.getFrontDistance(arg_39_0)
	arg_39_0:updatePivotProp()
	
	return arg_39_0.frontDist
end

function PivotByTarget.getWorldPosition(arg_40_0)
	local var_40_0, var_40_1 = arg_40_0.target_bone:getPosition()
	
	local function var_40_2(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
		local var_41_0, var_41_1 = arg_41_0:getPosition()
		
		return var_41_0 * arg_41_3 + arg_41_1, var_41_1 * arg_41_4 + arg_41_2, arg_41_3 * arg_41_0:getRealScaleX(), arg_41_4 * arg_41_0:getRealScaleY()
	end
	
	if arg_40_0.target_bone.getBoneOwner then
		local var_40_3 = arg_40_0.target_bone:getBoneOwner()
		
		if get_cocos_refid(var_40_3) then
			local var_40_4, var_40_5, var_40_6, var_40_7 = var_40_2(var_40_3:getParent(), 0, 0, 1, 1)
			local var_40_8, var_40_9, var_40_10, var_40_11 = var_40_2(var_40_3, var_40_4, var_40_5, var_40_6, var_40_7)
			local var_40_12, var_40_13 = var_40_2(arg_40_0.target_bone, var_40_8, var_40_9, var_40_10, var_40_11)
			local var_40_14 = var_40_13
			
			return var_40_12, var_40_14
		end
	end
	
	return var_40_0, var_40_1
end

function PivotByTarget.isValidate(arg_42_0)
	if arg_42_0.inited_prop and isusertype(arg_42_0.ref.model, "cc.Ref") and not get_cocos_refid(arg_42_0.ref.model) then
		return false
	end
	
	return true
end

FrontPivot = ClassDef(PivotBase)

function FrontPivot.constructor(arg_43_0, arg_43_1)
	arg_43_0.pivot = arg_43_1
end

function FrontPivot.getLocalZOrder(arg_44_0)
	return arg_44_0.pivot:getLocalZOrder()
end

function FrontPivot.getFrontDistance(arg_45_0)
	if arg_45_0.pivot.getFrontDistance then
		return arg_45_0.pivot:getFrontDistance() or 0
	end
	
	return 0
end

function FrontPivot.getPosition(arg_46_0)
	local var_46_0, var_46_1 = arg_46_0.pivot:getPosition()
	
	return var_46_0 + arg_46_0:getFrontDistance(), var_46_1
end

function FrontPivot.getWorldPosition(arg_47_0)
	local var_47_0, var_47_1 = arg_47_0.pivot:getWorldPosition()
	
	return var_47_0 + arg_47_0:getFrontDistance(), var_47_1
end

LuaObjectPivot = ClassDef(PivotBase)

function LuaObjectPivot.constructor(arg_48_0, arg_48_1)
	arg_48_0.object = arg_48_1
end

function LuaObjectPivot.getLocalZOrder(arg_49_0)
	return arg_49_0.object:getLocalZOrder()
end

function LuaObjectPivot.getFrontDistance(arg_50_0)
	if arg_50_0.object.getFrontDistance then
		local var_50_0 = arg_50_0.object:getFrontDistance()
		
		return math.if_nan_or_inf(var_50_0)
	end
	
	return 0
end

function LuaObjectPivot.isValidate(arg_51_0)
	return true
end

function LuaObjectPivot.getPosition(arg_52_0)
	return arg_52_0.object:getPosition()
end

function LuaObjectPivot.getWorldPosition(arg_53_0)
	return arg_53_0.object:getWorldPosition()
end

function BindLocationPivot(arg_54_0, arg_54_1)
	local var_54_0
	
	if is_class_table(arg_54_0, PivotBase) then
		var_54_0 = arg_54_0
	else
		if arg_54_0 and arg_54_0.getPosition and arg_54_0.getWorldPosition then
			var_54_0 = LuaObjectPivot(arg_54_0)
		end
		
		if arg_54_0 and get_cocos_refid(arg_54_0) then
			var_54_0 = PivotByModel(arg_54_0)
		end
		
		if arg_54_0.model and get_cocos_refid(arg_54_0.model) then
			var_54_0 = PivotByUnit(arg_54_0)
		end
	end
	
	if not var_54_0 then
		return 
	end
	
	if not var_54_0.getLocalZOrder then
		function var_54_0.getLocalZOrder()
			return 0
		end
	end
	
	if arg_54_1 then
		return FrontPivot(var_54_0)
	end
	
	return var_54_0
end
