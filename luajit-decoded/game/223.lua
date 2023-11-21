Scene.collection = SceneHandler:create("collection", 1280, 720)

function Scene.collection.onLoad(arg_1_0, arg_1_1)
	if Account:checkQueryEmptyDungeonData("exception") then
		return false
	end
	
	arg_1_0.layer = cc.Layer:create()
	
	if UnitMain:isPopupMode() then
		UnitMain:destroy()
	end
	
	if PLATFORM == "win32" then
		local var_1_0 = arg_1_0.layer:getEventDispatcher()
		local var_1_1 = cc.EventListenerMouse:create()
		
		var_1_1:registerScriptHandler(function(arg_2_0, arg_2_1)
			arg_1_0:onMouseWheel(arg_2_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_1_0:addEventListenerWithSceneGraphPriority(var_1_1, arg_1_0.layer)
	end
	
	CollectionController:initScene(arg_1_1)
end

function Scene.collection.onUnload(arg_3_0)
	if SceneManager:getCurrentSceneName() ~= "collection" then
		CollectionController:releaseEnterMode()
		CollectionController:release()
	end
end

function Scene.collection.onEnter(arg_4_0)
	set_scene_fps(10)
	print("enter")
	
	if not UnitMain:isPopupMode() then
		UnitMain:destroy()
	end
end

function Scene.collection.onLeave(arg_5_0)
end

function Scene.collection.onAfterUpdate(arg_6_0)
end

function Scene.collection.getSceneState(arg_7_0)
	return CollectionController:getSceneState()
end

function Scene.collection.onTouchDown(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1:getLocation()
	
	CollectionImageViewer:onTouchDown(arg_8_1, arg_8_2)
	arg_8_2:stopPropagation()
end

function Scene.collection.onTouchUp(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1:getLocation()
	
	CollectionImageViewer:onTouchUp(arg_9_1, arg_9_2)
	arg_9_2:stopPropagation()
end

function Scene.collection.onTouchMove(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_1:getLocation()
	
	CollectionImageViewer:onTouchMove(arg_10_1, arg_10_2)
	arg_10_2:stopPropagation()
end

function Scene.collection.onGestureZoom(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	CollectionImageViewer:onGestureZoom(arg_11_1, arg_11_2, arg_11_3)
end

function Scene.collection.onMouseWheel(arg_12_0, arg_12_1)
	CollectionImageViewer:onMouseWheel(arg_12_1)
end
