Scene.equip_storage = SceneHandler:create("equip_storage", 1280, 720)

function Scene.equip_storage.onLoad(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_1.prev_scene_name = SceneManager:getPrevSceneName()
	arg_1_1.start_mode = arg_1_1.start_mode or EquipStorageMode.Main
	Scene.equip_storage.args = arg_1_1
	
	if AccountData.equip_storage then
		EquipStorage:init(arg_1_1)
	else
		query("equip_storage_list", {
			caller = "storage"
		})
	end
end

function Scene.equip_storage.onUnload(arg_2_0)
end

function Scene.equip_storage.onEnter(arg_3_0)
end

function Scene.equip_storage.onLeave(arg_4_0)
	EquipStorage:leave({
		ignore_popscene = true
	})
end

function Scene.equip_storage.onAfterUpdate(arg_5_0)
end

function Scene.equip_storage.onEnterFinished(arg_6_0)
end

function Scene.equip_storage.onAfterDraw(arg_7_0)
end
