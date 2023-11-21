Scene.substory_dlc_lobby = SceneHandler:create("substory_dlc_lobby", 1280, 720)

function Scene.substory_dlc_lobby.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	SubStoryDlcLobby:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
	
	if PLATFORM == "win32" then
		local var_1_0 = arg_1_0.layer:getEventDispatcher()
		local var_1_1 = cc.EventListenerMouse:create()
		
		var_1_1:registerScriptHandler(function(arg_2_0, arg_2_1)
			arg_1_0:onMouseWheel(arg_2_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_1_0:addEventListenerWithSceneGraphPriority(var_1_1, arg_1_0.layer)
	end
end

function Scene.substory_dlc_lobby.onEnter(arg_3_0)
	set_scene_fps(15)
	SoundEngine:playBGM(SubStoryUtil:getLobbySound())
end

function Scene.substory_dlc_lobby.onLeave(arg_4_0)
end

function Scene.substory_dlc_lobby.onUnload(arg_5_0)
end

function Scene.substory_dlc_lobby.onAfterDraw(arg_6_0)
end

function Scene.substory_dlc_lobby.onAfterUpdate(arg_7_0)
end

function Scene.substory_dlc_lobby.onTouchDown(arg_8_0, arg_8_1, arg_8_2)
	CollectionImageViewer:onTouchDown(arg_8_1, arg_8_2)
end

function Scene.substory_dlc_lobby.onTouchUp(arg_9_0, arg_9_1, arg_9_2)
	CollectionImageViewer:onTouchUp(arg_9_1, arg_9_2)
end

function Scene.substory_dlc_lobby.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	CollectionImageViewer:onGestureZoom(arg_10_1, arg_10_2, arg_10_3)
end

function Scene.substory_dlc_lobby.onMouseWheel(arg_11_0, arg_11_1)
	CollectionImageViewer:onMouseWheel(arg_11_1)
end

function Scene.substory_dlc_lobby.onTouchMove(arg_12_0, arg_12_1, arg_12_2)
	CollectionImageViewer:onTouchMove(arg_12_1, arg_12_2)
	arg_12_2:stopPropagation()
end

function Scene.substory_dlc_lobby.getSceneState(arg_13_0)
end
