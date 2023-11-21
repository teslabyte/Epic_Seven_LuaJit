Scene.spl = SceneHandler:create("spl", 1280, 720)

function Scene.spl.onLoad(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.spl_scene_begin = uitick()
	arg_1_0.layer = cc.Node:create()
	arg_1_0.touch_listener = cc.EventListenerTouchOneByOne:create()
	
	local var_1_0 = arg_1_0.layer:getEventDispatcher()
	
	local function var_1_1(arg_2_0, arg_2_1)
		arg_1_0:onPriorityTouchDown(arg_2_0, arg_2_1)
	end
	
	local function var_1_2(arg_3_0, arg_3_1)
		arg_1_0:onPriorityTouchMove(arg_3_0, arg_3_1)
	end
	
	local function var_1_3(arg_4_0, arg_4_1)
		arg_1_0:onPriorityTouchUp(arg_4_0, arg_4_1)
	end
	
	arg_1_0.touch_listener:setForceClaimed(true)
	arg_1_0.touch_listener:registerScriptHandler(var_1_1, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_1_0.touch_listener:registerScriptHandler(var_1_2, cc.Handler.EVENT_TOUCH_MOVED)
	arg_1_0.touch_listener:registerScriptHandler(var_1_3, cc.Handler.EVENT_TOUCH_ENDED)
	var_1_0:addEventListenerWithSceneGraphPriority(arg_1_0.touch_listener, arg_1_0.layer)
	
	local var_1_4 = SPLUserData:getSplData()
	
	if var_1_4 then
		arg_1_1.map_id = SPLUtil:getMapId(SPLData:getSubstoryID(), var_1_4.floor)
		arg_1_1.spl_data = var_1_4
	end
	
	SPLMapLoader:load(arg_1_1.map_id)
	SPLSystem:init(arg_1_0.layer, arg_1_1)
end

function Scene.spl.onUnload(arg_5_0)
	print("unload")
	
	if get_cocos_refid(arg_5_0.touch_listener) then
		local var_5_0 = arg_5_0._layer:getEventDispatcher()
		
		if get_cocos_refid(var_5_0) then
			var_5_0:removeEventListener(arg_5_0.touch_listener)
		end
		
		arg_5_0.touch_listener:setEnabled(false)
		
		arg_5_0.touch_listener = nil
	end
end

function Scene.spl.getTouchEventTime(arg_6_0)
	return arg_6_0.touchEventTime
end

function Scene.spl.onEnter(arg_7_0)
	set_scene_fps(60)
	print("enter proc tm ", uitick() - arg_7_0.spl_scene_begin)
	SPLSystem:onEnter()
end

function Scene.spl.onLeave(arg_8_0)
	SPLSystem:onLeave()
end

function Scene.spl.onAfterUpdate(arg_9_0)
	SPLSystem:onUpdate()
end

function Scene.spl.onAppForeground(arg_10_0)
	SPLSystem:onWillEnterForeground()
end

function Scene.spl.getSceneState(arg_11_0)
	return {
		map_id = "tile_vaf3aa_01"
	}
end

function Scene.spl.onPriorityTouchDown(arg_12_0, arg_12_1, arg_12_2)
	SPLSystem:onTouchDown(arg_12_1, arg_12_2)
end

function Scene.spl.onPriorityTouchUp(arg_13_0, arg_13_1, arg_13_2)
	SPLSystem:onTouchUp(arg_13_1, arg_13_2)
end

function Scene.spl.onPriorityTouchMove(arg_14_0, arg_14_1, arg_14_2)
	SPLSystem:onTouchMove(arg_14_1, arg_14_2)
end

function Scene.spl.onTouchDown(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_0._gestureFactor == nil then
		SPLSystem:onGestureEnd()
	end
end

function Scene.spl.onTouchMove(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0._gestureFactor == nil then
		SPLSystem:onGestureEnd()
	end
end

function Scene.spl.onTouchUp(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_0._gestureFactor == nil then
		SPLSystem:onGestureEnd()
	end
end

function Scene.spl.onGestureZoom(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	SPLSystem:onGestureZoom(arg_18_1, arg_18_2, arg_18_3)
end

function Scene.spl.onMouseWheel(arg_19_0, arg_19_1)
end
