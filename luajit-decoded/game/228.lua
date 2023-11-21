if PLATFORM == "win32" then
	function mapviewer()
		SceneManager:nextScene("mapviewer")
	end
	
	function reload_shader()
		ShaderManager:loadShader()
	end
	
	Scene.mapviewer = Scene.mapviewer or SceneHandler:create("mapviewer")
	MAP_NAME = "dis_dimension5"
	
	function Scene.mapviewer.initKeyboard(arg_3_0)
		local var_3_0 = cc.EventListenerMouse:create()
		
		var_3_0:registerScriptHandler(function(arg_4_0)
			local var_4_0 = arg_4_0:getLocation()
			
			arg_3_0._down_location = var_4_0
			
			local var_4_1, var_4_2 = CameraManager:getOffset()
			
			arg_3_0._cam_offset_x = var_4_1
			arg_3_0._cam_offset_y = var_4_2
			arg_3_0._scroll_pos = 0
			arg_3_0._scroll_factor = 0
		end, cc.Handler.EVENT_MOUSE_DOWN)
		var_3_0:registerScriptHandler(function(arg_5_0)
			local var_5_0 = arg_5_0:getLocation()
			
			arg_3_0._down_location = nil
			arg_3_0._scroll_pos = nil
			arg_3_0._scroll_factor = nil
		end, cc.Handler.EVENT_MOUSE_UP)
		var_3_0:registerScriptHandler(function(arg_6_0)
			local var_6_0 = arg_6_0:getLocation()
			
			if arg_6_0:getMouseButton() == 0 and arg_3_0._down_location then
				local var_6_1 = arg_3_0._down_location.x - var_6_0.x
				local var_6_2 = var_6_0.y - arg_3_0._down_location.y
				
				print(var_6_1, var_6_0.x)
				
				if var_6_0.x < 0 then
					arg_3_0._scroll_factor = 12
				elseif var_6_0.x > cc.Director:getInstance():getWinSize().width then
					arg_3_0._scroll_factor = -12
				else
					arg_3_0._scroll_factor = 0
				end
				
				arg_3_0._cam_offset_x = var_6_1
				arg_3_0._cam_offset_y = var_6_2
			end
		end, cc.Handler.EVENT_MOUSE_MOVE)
		var_3_0:registerScriptHandler(function(arg_7_0)
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(var_3_0, arg_3_0.layer)
		
		return layer, base_layer
	end
	
	function Scene.mapviewer.onLoad(arg_8_0)
		IS_TOOL_MODE = true
		
		cc.Director:getInstance():setDisplayStats(true)
		
		MAPVIEWER_FG_LAYER = cc.Layer:create()
		arg_8_0.layer = MAPVIEWER_FG_LAYER
		
		arg_8_0:initKeyboard()
		
		VARS.GAME_STARTED = true
		
		reload_db()
		reload_master_sound()
		ShaderManager:loadShader()
		print("[DEBUG] Console Command > #MAP_NAME='dis_dimension1'")
	end
	
	function Scene.mapviewer.onAfterUpdate(arg_9_0)
		if arg_9_0.current_map_name ~= MAP_NAME then
			arg_9_0:showmap()
		end
		
		if arg_9_0._scroll_factor then
			arg_9_0._scroll_pos = (arg_9_0._scroll_pos or 0) + arg_9_0._scroll_factor
		end
		
		CameraManager:setOffset((arg_9_0._cam_offset_x or 0) + (arg_9_0._scroll_pos or 0), arg_9_0._cam_offset_y or 0)
		CameraManager:update()
		BattleField:update()
	end
	
	function Scene.mapviewer.showmap(arg_10_0)
		arg_10_0.current_map_name = MAP_NAME
		
		local var_10_0 = BattleField:create()
		
		BattleField:addTestField(arg_10_0.current_map_name, DESIGN_WIDTH * 8)
		CameraManager:setOffset(DESIGN_WIDTH * 2, 0)
		var_10_0:ejectFromParent()
		var_10_0:setPositionX(-VIEW_BASE_LEFT)
		MAPVIEWER_FG_LAYER:addChild(var_10_0)
		collectgarbage("collect")
		cc.Director:getInstance():removeUnusedCachedData()
	end
end
