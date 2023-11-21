Scene.substory_dlc_main = SceneHandler:create("substory_dlc_main", 1280, 720)

function Scene.substory_dlc_main.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	if not SubStoryDLCManager:isPlayedDLCEffect() then
		SubStoryDLCManager:setPlayedDLCEffect(true)
		EffectManager:Play({
			fn = "ui_storydlc.cfx",
			pivot_z = 99998,
			layer = arg_1_0.layer,
			pivot_x = DESIGN_WIDTH / 2,
			pivot_y = DESIGN_HEIGHT / 2
		})
		UIAction:Add(SEQ(DELAY(600), CALL(SubStoryDlcMain.init, SubStoryDlcMain, arg_1_0.layer, arg_1_1.move_item_id)), arg_1_0.layer, "block")
	else
		SubStoryDlcMain:init(arg_1_0.layer, arg_1_1.move_item_id)
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
end

function Scene.substory_dlc_main.onUnload(arg_3_0)
end

function Scene.substory_dlc_main.onEnter(arg_4_0)
end

function Scene.substory_dlc_main.onLeave(arg_5_0)
end

function Scene.substory_dlc_main.getSceneState(arg_6_0)
end

function Scene.substory_dlc_main.onTouchUp(arg_7_0, arg_7_1, arg_7_2)
	CollectionImageViewer:onTouchUp(arg_7_1, arg_7_2)
end

function Scene.substory_dlc_main.onTouchDown(arg_8_0, arg_8_1, arg_8_2)
	CollectionImageViewer:onTouchDown(arg_8_1, arg_8_2)
end

function Scene.substory_dlc_main.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
	CollectionImageViewer:onTouchMove(arg_9_1, arg_9_2)
	arg_9_2:stopPropagation()
end

function Scene.substory_dlc_main.onGestureZoom(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	CollectionImageViewer:onGestureZoom(arg_10_1, arg_10_2, arg_10_3)
end

function Scene.substory_dlc_main.onMouseWheel(arg_11_0, arg_11_1)
	CollectionImageViewer:onMouseWheel(arg_11_1)
end
