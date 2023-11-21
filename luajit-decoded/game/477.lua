MissionUI = {}

function MissionUI.onDialogTouchBanner(arg_1_0, arg_1_1)
	if arg_1_1 ~= 2 then
		return 
	end
	
	local var_1_0, var_1_1, var_1_2 = DB("map_mission", arg_1_0:getName(), {
		"name",
		"icon",
		"lobby_tooltip"
	})
	local var_1_3 = Text:getText(var_1_2)
	
	Dialog:msgBox(var_1_3, {
		image = var_1_1
	})
	SoundEngine:play("event:/ui/btn_ok")
end

function MissionUI.updateMissionMark(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = 0
	local var_2_1 = {}
	
	var_2_1[1], var_2_1[2], var_2_1[3], var_2_1[4] = DB("level_enter", arg_2_2, {
		"mission1",
		"mission2",
		"mission3",
		"mission4"
	})
	
	local var_2_2 = 0
	
	for iter_2_0 = 1, 4 do
		if var_2_1[iter_2_0] == nil then
			break
		elseif Account:isDungeonMissionClearedByMissionId(arg_2_2, var_2_1[iter_2_0]) then
			var_2_2 = var_2_2 + 1
		end
		
		local var_2_3 = iter_2_0
	end
	
	local var_2_4 = 10
	local var_2_5 = arg_2_1:getChildByName("score")
	
	var_2_5:setLocalZOrder(999)
	
	if var_2_2 == 0 then
		var_2_5:setVisible(false)
	elseif var_2_2 <= 3 then
		var_2_5:setVisible(true)
		SpriteCache:resetSprite(var_2_5, "img/cm_icon_starmap" .. var_2_2 .. ".png")
	end
	
	if_set_visible(arg_2_1, "n_debug", DEBUG.DEBUG_MAP_ID)
	
	local var_2_6
	
	if DEBUG.DEBUG_MAP_ID then
		var_2_6 = {}
		
		if_set_visible(arg_2_1, "n_debug", true)
		
		for iter_2_1 = 1, 10 do
			var_2_6[1], var_2_6[2], var_2_6[3], var_2_6[4], var_2_6[5], var_2_6[6], var_2_6[7], var_2_6[8], var_2_6[9], var_2_6[10] = DB("level_enter", arg_2_2, {
				"hide_mission1",
				"hide_mission2",
				"hide_mission3",
				"hide_mission4",
				"hide_mission5",
				"hide_mission6",
				"hide_mission7",
				"hide_mission8",
				"hide_mission9",
				"hide_mission10"
			})
			
			local var_2_7 = arg_2_1:getChildByName("hide_mission_" .. iter_2_1)
			
			table.print(var_2_6)
			
			local var_2_8 = var_2_6[iter_2_1] ~= nil
			
			if get_cocos_refid(var_2_7) then
				var_2_7:setVisible(var_2_8)
			end
			
			if var_2_8 and Account:isDungeonMissionClearedByMissionId(arg_2_2, var_2_6[iter_2_1]) then
				SpriteCache:resetSprite(var_2_7, "img/_notification_num.png")
			end
		end
	end
end
