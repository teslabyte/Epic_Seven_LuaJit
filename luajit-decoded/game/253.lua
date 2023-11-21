Scene.CharPreview = SceneHandler:create("char_preview", 1280, 720)

function Scene.CharPreview.onLoad(arg_1_0, arg_1_1)
	arg_1_0.layer = cc.Layer:create()
	
	BackButtonManager:clear()
	CharPreviewController:onLoad(arg_1_0.layer)
end

function Scene.CharPreview.onAfterUpdate(arg_2_0)
end

function Scene.CharPreview.onEnter(arg_3_0, arg_3_1)
	set_scene_fps(30, 45)
end

function Scene.CharPreview.onLeave(arg_4_0)
	BattleAction:Resume()
	CameraManager:resetDefault()
end

function Scene.CharPreview.onUnload(arg_5_0)
	BattleAction:Resume()
	CharPreviewController:onUnload()
	CharPreviewViewer:Destroy()
	CameraManager:resetDefault()
end

function Scene.CharPreview.onAfterDraw(arg_6_0)
	CharPreviewViewer:onAfterDraw()
end
