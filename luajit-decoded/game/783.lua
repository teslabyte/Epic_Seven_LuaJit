Scene.rumble = SceneHandler:create("rumble", 1280, 720)

function Scene.rumble.onLoad(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	
	local var_1_0 = SubstoryManager:getInfo()
	
	if var_1_0 then
		arg_1_1.substory_info = var_1_0
		arg_1_1.rumble_info = Account:getSubStoryRumble()
		
		function arg_1_1.doAfterNextSceneLoaded()
			SubstoryRumble:show()
		end
	end
	
	RumbleSystem:init(arg_1_1)
end

function Scene.rumble.onUnload(arg_3_0)
	RumbleSystem:onUnload()
end

function Scene.rumble.onEnter(arg_4_0)
	set_scene_fps(60)
	RumbleSystem:onEnter()
	SoundEngine:playBGM("event:/bgm/fmf2023_Battle1_Loop")
end

function Scene.rumble.onLeave(arg_5_0)
	RumbleSystem:onLeave()
end

function Scene.rumble.onAfterUpdate(arg_6_0)
	local var_6_0 = cc.Director:getInstance():getDeltaTime() * 1000
	
	RumbleSystem:onUpdate(var_6_0)
end

function Scene.rumble.onAppForeground(arg_7_0)
	RumbleSystem:onWillEnterForeground()
end

function Scene.rumble.getSceneState(arg_8_0)
	return {}
end

function Scene.rumble.onTouchDown(arg_9_0, arg_9_1, arg_9_2)
	RumbleSystem:onTouchDown(arg_9_1, arg_9_2)
end

function Scene.rumble.onTouchMove(arg_10_0, arg_10_1, arg_10_2)
	RumbleSystem:onTouchMove(arg_10_1, arg_10_2)
end

function Scene.rumble.onTouchUp(arg_11_0, arg_11_1, arg_11_2)
	RumbleSystem:onTouchUp(arg_11_1, arg_11_2)
end

function Scene.rumble.onChangeResolution(arg_12_0)
	RumbleUI:updateOffset()
end
