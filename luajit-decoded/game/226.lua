Scene.substory_album = SceneHandler:create("substory_album", 1280, 720)

function Scene.substory_album.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	SubstoryAlbumMain:show(arg_1_0.layer, arg_1_1)
	arg_1_0:setTransition(cc.TransitionCrossFade, 0.2)
end

function Scene.substory_album.onUnload(arg_2_0)
end

function Scene.substory_album.onEnter(arg_3_0)
	set_scene_fps(15)
	set_high_fps_tick(10000)
	SoundEngine:playBGM(SubStoryUtil:getLobbySound())
end

function Scene.substory_album.onLeave(arg_4_0)
end

function Scene.substory_album.onAfterUpdate(arg_5_0)
	BattleReady:update()
end

function Scene.substory_album.getSceneState(arg_6_0)
	return SubstoryAlbumMain:getSceneState()
end

function Scene.substory_album.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
end

function Scene.substory_album.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
end

function Scene.substory_album.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
end
