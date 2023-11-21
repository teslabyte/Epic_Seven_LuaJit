CameraZoom = ClassDef()

local function var_0_0()
	if is_using_story_v2() then
		return StoryAction:getTick()
	else
		return GET_LAST_TICK()
	end
end

function CameraZoom.constructor(arg_2_0, arg_2_1)
	arg_2_0._zoom = tonumber(arg_2_1) or 1
end

function CameraZoom.setTime(arg_3_0, arg_3_1)
	arg_3_0._time = arg_3_1
end

function CameraZoom.getTime(arg_4_0)
	return arg_4_0._time or 0
end

function CameraZoom.setCurves(arg_5_0, arg_5_1)
	arg_5_0._curves = arg_5_1
end

function CameraZoom.getRate(arg_6_0, arg_6_1)
	if arg_6_0._curves then
		return arg_6_0._curves:getPercentAtX(arg_6_1)
	end
	
	return arg_6_1
end

function CameraZoom.getScale(arg_7_0)
	return arg_7_0._zoom
end

function CameraZoom.getZoom(arg_8_0)
	return arg_8_0._zoom
end

CameraFocus = ClassDef()

function CameraFocus.constructor(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	arg_9_0._pivot = arg_9_1
	arg_9_0._offsetX = arg_9_2 or 0
	arg_9_0._offsetY = arg_9_3 or 0
end

function CameraFocus.setTime(arg_10_0, arg_10_1)
	arg_10_0._time = arg_10_1
end

function CameraFocus.getTime(arg_11_0)
	return arg_11_0._time or 0
end

function CameraFocus.setCurves(arg_12_0, arg_12_1)
	arg_12_0._curves = arg_12_1
end

function CameraFocus.getRate(arg_13_0, arg_13_1)
	if arg_13_0._curves then
		return arg_13_0._curves:getPercentAtX(arg_13_1)
	end
	
	return arg_13_1
end

function CameraFocus.getPivotPosition(arg_14_0)
	local var_14_0, var_14_1 = arg_14_0._pivot:getWorldPosition()
	
	return var_14_0, var_14_1 - DESIGN_HEIGHT * CAM_ANCHOR_Y
end

function CameraFocus.getWorldPosition(arg_15_0)
	local var_15_0, var_15_1 = arg_15_0:getPivotPosition()
	
	return var_15_0 + (arg_15_0._offsetX or 0), var_15_1 + (arg_15_0._offsetY or 0)
end

function CameraFocus.isValidate(arg_16_0)
	local var_16_0 = arg_16_0._pivot
	
	if not var_16_0 then
		return false
	end
	
	if var_16_0.isValidate and not var_16_0:isValidate() then
		return false
	end
	
	return true
end

CameraZoomActionHandler = ClassDef()

function CameraZoomActionHandler.constructor(arg_17_0, arg_17_1)
	arg_17_0.TOTAL_TIME = arg_17_1:getTime()
	arg_17_0._camera = CameraManager:getCamera()
	arg_17_0._zoomObject = arg_17_1
end

function CameraZoomActionHandler.Update(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0._started then
		arg_18_0._started = true
		
		arg_18_0._camera:setZoomObject(arg_18_0._zoomObject)
	end
end

function CameraZoomActionHandler.Finish(arg_19_0)
end

CameraFocusActionHandler = ClassDef()

function CameraFocusActionHandler.constructor(arg_20_0, arg_20_1)
	arg_20_0.TOTAL_TIME = arg_20_1:getTime()
	arg_20_0._camera = CameraManager:getCamera()
	arg_20_0._focusObject = arg_20_1
end

function CameraFocusActionHandler.Update(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0._started then
		arg_21_0._started = true
		
		arg_21_0._camera:setFocusObject(arg_21_0._focusObject)
	end
end

function CameraFocusActionHandler.Finish(arg_22_0)
end

local var_0_1 = {
	MOVABLE = 1,
	FIXED = 2
}

CameraObject = ClassDef()

function CameraObject.constructor(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	arg_23_0._curX, arg_23_0._curY = arg_23_1, arg_23_2
	arg_23_0._curZ = arg_23_3
	arg_23_0._type = var_0_1.MOVABLE
end

function CameraObject.setZoomObject(arg_24_0, arg_24_1)
end

function CameraObject.setFocusObject(arg_25_0, arg_25_1)
end

function CameraObject.setScale(arg_26_0, arg_26_1)
	arg_26_0._curZ = arg_26_1
end

function CameraObject.getScale(arg_27_0)
	return arg_27_0._curZ
end

function CameraObject.setPosition(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0._curX = arg_28_1
	arg_28_0._curY = arg_28_2
end

function CameraObject.getPosition(arg_29_0)
	return arg_29_0._curX, arg_29_0._curY
end

function CameraObject.finishFocusing(arg_30_0)
end

function CameraObject.finishZooming(arg_31_0)
end

function CameraObject.update(arg_32_0)
end

function CameraObject.getCameraType(arg_33_0)
	return arg_33_0._type
end

MovableCamera = ClassDef(CameraObject)

function MovableCamera.constructor(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	arg_34_0._curX, arg_34_0._curY = arg_34_1, arg_34_2
	arg_34_0._curZ = arg_34_3
	arg_34_0._nextZoomObjectList = {}
	arg_34_0._nextFocusObjectList = {}
	arg_34_0._type = var_0_1.MOVABLE
end

function MovableCamera.setZoomObject(arg_35_0, arg_35_1)
	table.insert(arg_35_0._nextZoomObjectList, arg_35_1)
end

function MovableCamera.setFocusObject(arg_36_0, arg_36_1)
	table.insert(arg_36_0._nextFocusObjectList, arg_36_1)
end

function MovableCamera.setScale(arg_37_0, arg_37_1)
	arg_37_0._curZ = arg_37_1
end

function MovableCamera.getScale(arg_38_0)
	return arg_38_0._curZ
end

function MovableCamera.setPosition(arg_39_0, arg_39_1, arg_39_2)
	arg_39_0._curX = arg_39_1
	arg_39_0._curY = arg_39_2
end

function MovableCamera.getPosition(arg_40_0)
	return arg_40_0._curX, arg_40_0._curY
end

function MovableCamera.finishFocusing(arg_41_0)
end

function MovableCamera.finishZooming(arg_42_0)
end

function MovableCamera.update(arg_43_0)
	local function var_43_0()
		if arg_43_0.focus and arg_43_0.focus.object and arg_43_0.focus.object:isValidate() then
			local var_44_0, var_44_1 = arg_43_0.focus.object:getWorldPosition()
			
			if var_44_0 ~= arg_43_0._curX or var_44_1 ~= arg_43_0._curY then
				local var_44_2
				
				if arg_43_0.focus.finalTime > 0 then
					var_44_2 = math.min(1, (var_0_0() - arg_43_0.focus.startTick) / arg_43_0.focus.finalTime)
				else
					var_44_2 = 1
				end
				
				local var_44_3 = arg_43_0.focus.object:getRate(var_44_2)
				
				arg_43_0._curX, arg_43_0._curY = arg_43_0.focus.startX + (var_44_0 - arg_43_0.focus.startX) * var_44_3, arg_43_0.focus.startY + (var_44_1 - arg_43_0.focus.startY) * var_44_3
			else
				arg_43_0:finishFocusing()
			end
		end
	end
	
	if #arg_43_0._nextFocusObjectList > 0 then
		var_43_0()
		
		local var_43_1 = table.remove(arg_43_0._nextFocusObjectList, 1)
		
		arg_43_0.focus = {}
		arg_43_0.focus.object = var_43_1
		arg_43_0.focus.finalTime = var_43_1:getTime()
		arg_43_0.focus.startTick = var_0_0()
		arg_43_0.focus.startX = arg_43_0._curX
		arg_43_0.focus.startY = arg_43_0._curY
	end
	
	var_43_0()
	
	local function var_43_2()
		if arg_43_0.zoom and arg_43_0.zoom.object then
			local var_45_0 = arg_43_0.zoom.object:getScale() or 1
			
			if var_45_0 ~= arg_43_0._curZ then
				local var_45_1
				
				if arg_43_0.zoom.finalTime > 0 then
					var_45_1 = math.min(1, (var_0_0() - arg_43_0.zoom.startTick) / arg_43_0.zoom.finalTime)
				else
					var_45_1 = 1
				end
				
				local var_45_2 = arg_43_0.zoom.object:getRate(var_45_1)
				
				arg_43_0._curZ = arg_43_0.zoom.startZ + (var_45_0 - arg_43_0.zoom.startZ) * var_45_2
			else
				arg_43_0:finishZooming()
			end
		end
	end
	
	if #arg_43_0._nextZoomObjectList > 0 then
		var_43_2()
		
		local var_43_3 = table.remove(arg_43_0._nextZoomObjectList, 1)
		
		arg_43_0.zoom = {}
		arg_43_0.zoom.object = var_43_3
		arg_43_0.zoom.finalTime = var_43_3:getTime()
		arg_43_0.zoom.startTick = var_0_0()
		arg_43_0.zoom.startZ = arg_43_0._curZ
	end
	
	var_43_2()
end

function MovableCamera.getCameraType(arg_46_0)
	return arg_46_0._type
end

function MovableCamera.getCurrentZoomScale(arg_47_0)
	return arg_47_0._curZ or 1
end

FixedCamera = ClassDef(CameraObject)

function FixedCamera.constructor(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	arg_48_0._curX, arg_48_0._curY = arg_48_1, arg_48_2
	arg_48_0._curZ = arg_48_3
	arg_48_0._type = var_0_1.FIXED
end

function FixedCamera.setZoomObject(arg_49_0, arg_49_1)
end

function FixedCamera.setFocusObject(arg_50_0, arg_50_1)
end

function FixedCamera.setScale(arg_51_0, arg_51_1)
	arg_51_0._curZ = arg_51_1
end

function FixedCamera.getScale(arg_52_0)
	return arg_52_0._curZ
end

function FixedCamera.setPosition(arg_53_0, arg_53_1, arg_53_2)
	arg_53_0._curX = arg_53_1
	arg_53_0._curY = arg_53_2
end

function FixedCamera.getPosition(arg_54_0)
	return arg_54_0._curX, arg_54_0._curY
end

function FixedCamera.finishFocusing(arg_55_0)
end

function FixedCamera.finishZooming(arg_56_0)
end

function FixedCamera.update(arg_57_0)
end

function FixedCamera.getCameraType(arg_58_0)
	return arg_58_0._type
end

CameraManager = {}

function CameraManager.init(arg_59_0)
	arg_59_0._def_focus = CameraFocus(ScreenFlexiblePivot())
	arg_59_0._def_zoom = CameraZoom(1)
	arg_59_0._def_cam = MovableCamera(DEF_CAM_X, DEF_CAM_Y, 1)
	
	arg_59_0._def_cam:setFocusObject(arg_59_0._def_focus)
	arg_59_0._def_cam:setZoomObject(arg_59_0._def_zoom)
end

function CameraManager.getBackup(arg_60_0, arg_60_1)
	return get_state_back_up_from_table(arg_60_0, arg_60_1)
end

function CameraManager.restoreFromBackup(arg_61_0, arg_61_1)
	restore_state_from_backup_from_table(arg_61_0, arg_61_1)
end

function CameraManager.setBackup(arg_62_0, arg_62_1)
	set_state_backup_from_table(arg_62_0, arg_62_1)
end

function CameraManager.playCamera(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
	if arg_63_1 == "ready" then
		CameraManager:resetReadyFocus()
	else
		CameraManager:resetDefault()
	end
end

function CameraManager.select(arg_64_0, arg_64_1)
	arg_64_0._prev = arg_64_0._cur_cam
	arg_64_0._cur_cam = arg_64_1
end

function CameraManager.resetReadyFocus(arg_65_0)
	arg_65_0:resetDefault()
	
	local var_65_0 = 200
	local var_65_1 = CameraFocus(ScreenFlexiblePivot())
	
	var_65_1:setTime(var_65_0)
	arg_65_0:setFocusObject(var_65_1)
	
	local var_65_2 = CameraZoom(CAM_READY_SCALE)
	
	var_65_2:setTime(var_65_0)
	arg_65_0:setZoomObject(var_65_2)
end

function CameraManager.zoomTargetOnStory(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	local var_66_0 = arg_66_2 or 200
	local var_66_1 = arg_66_3 or 1
	local var_66_2 = BattleLayout:getStoryLayout(arg_66_1)
	
	if not var_66_2 then
		return 
	end
	
	local var_66_3 = var_66_2:getUnits()[1]
	
	if not var_66_3 then
		return 
	end
	
	local var_66_4 = CameraFocus(PivotByUnit(var_66_3, "root"), 0, 0)
	
	var_66_4:setTime(var_66_0)
	arg_66_0:setFocusObject(var_66_4)
	
	local var_66_5 = CameraZoom(var_66_1)
	
	var_66_5:setTime(var_66_0)
	arg_66_0:setZoomObject(var_66_5)
end

function CameraManager.zoomAreaOnStory(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = arg_67_2 or 200
	local var_67_1 = arg_67_3 or 1
	
	arg_67_1 = BindLocationPivot(arg_67_1)
	
	local var_67_2 = CameraFocus(arg_67_1, 0, 0)
	
	var_67_2:setTime(var_67_0)
	arg_67_0:setFocusObject(var_67_2)
	
	local var_67_3 = CameraZoom(var_67_1)
	
	var_67_3:setTime(var_67_0)
	arg_67_0:setZoomObject(var_67_3)
end

function CameraManager.setFocusObject(arg_68_0, arg_68_1)
	arg_68_0:getCamera():setFocusObject(arg_68_1)
end

function CameraManager.setZoomObject(arg_69_0, arg_69_1)
	arg_69_0:getCamera():setZoomObject(arg_69_1)
end

function CameraManager.resetDefault(arg_70_0)
	arg_70_0._def_focus = CameraFocus(ScreenFlexiblePivot())
	arg_70_0._def_zoom = CameraZoom(1)
	arg_70_0._def_cam = MovableCamera(DEF_CAM_X, DEF_CAM_Y, 1)
	
	arg_70_0._def_cam:setFocusObject(arg_70_0._def_focus)
	arg_70_0._def_cam:setZoomObject(arg_70_0._def_zoom)
	
	arg_70_0._prev = arg_70_0._cur_cam
	arg_70_0._cur_cam = arg_70_0._def_cam
	
	arg_70_0._cur_cam:setFocusObject(arg_70_0._def_focus)
	arg_70_0._cur_cam:setZoomObject(arg_70_0._def_zoom)
end

function CameraManager.resetDefaultStory(arg_71_0, arg_71_1)
	local var_71_0 = CameraFocus(ScreenFlexiblePivot())
	
	var_71_0:setTime(arg_71_1)
	arg_71_0:setFocusObject(var_71_0)
	
	local var_71_1 = CameraZoom(1)
	
	var_71_1:setTime(arg_71_1)
	arg_71_0:setZoomObject(var_71_1)
end

function CameraManager.setOffset(arg_72_0, arg_72_1, arg_72_2)
	arg_72_0._offset_x, arg_72_0._offset_y = arg_72_1, arg_72_2
end

function CameraManager.getOffset(arg_73_0)
	return arg_73_0._offset_x or 0, arg_73_0._offset_y or 0
end

function CameraManager.getCamera(arg_74_0)
	return arg_74_0._cur_cam or arg_74_0._def_cam
end

function CameraManager.getCameraType(arg_75_0)
	if not arg_75_0._cur_cam then
		return 
	end
	
	return arg_75_0._cur_cam:getCameraType()
end

function CameraManager.resetGameLayer(arg_76_0, arg_76_1)
	arg_76_0.game_layer = arg_76_1
end

function CameraManager.update(arg_77_0)
	if DEBUG.SKIP_CAMERA then
		return 
	end
	
	local var_77_0 = arg_77_0:getCamera()
	
	var_77_0:update()
	
	local var_77_1 = var_77_0:getScale()
	
	ShakeManager:update()
	
	local var_77_2, var_77_3, var_77_4 = ShakeManager:getLastTransform()
	
	if get_cocos_refid(arg_77_0.game_layer) then
		arg_77_0.game_layer:setPosition(var_77_2 * var_77_1, var_77_3 * var_77_1)
	end
	
	local var_77_5, var_77_6 = var_77_0:getPosition()
	local var_77_7, var_77_8 = var_77_5 + (arg_77_0._offset_x or 0), var_77_6 + (arg_77_0._offset_y or 0)
	
	var_77_0:setPosition(var_77_7, var_77_8)
end

CameraManager:init()
