WorldMapController = WorldMapController or {}
WORLDMAP_MODE_LIST = {
	cook = true,
	village = true,
	free = true,
	extra_quest = true,
	repair = true,
	quest = true,
	exorcist = true,
	story = true,
	volleyball = true,
	dungeon_quest = true,
	defense_quest = true,
	arcade = true
}
WORLDMAP_TYPE = {
	CUSTOM = "custom",
	ADV = "adventure",
	SUB_STORY = "substory"
}

function WorldMapController.getSubStroyData(arg_1_0)
	return (arg_1_0.vars or {}).sub_story
end

function WorldMapController.getType(arg_2_0)
	if not arg_2_0.vars then
		return nil
	end
	
	return arg_2_0.vars.type
end

function WorldMapController.worldmap(arg_3_0, arg_3_1)
	local var_3_0, var_3_1 = BackPlayUtil:checkAdventureInBackPlay()
	
	if not var_3_0 then
		balloon_message_with_sound(var_3_1)
		
		return 
	end
	
	arg_3_1 = arg_3_1 or {}
	
	if arg_3_1.no_check_dungeon then
		SceneManager:nextScene("worldmap_scene", arg_3_1)
		
		return 
	end
	
	if not Account:checkQueryEmptyDungeonData("worldmap.nextscene") then
		SceneManager:nextScene("worldmap_scene", arg_3_1)
		
		return 
	end
end

function WorldMapController.removeMovePathDelay(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	arg_4_0.vars.movepath_delay = nil
end

function WorldMapController.movetoPath(arg_5_0, arg_5_1, arg_5_2)
	arg_5_2 = arg_5_2 or {}
	
	if arg_5_0.vars and arg_5_0.vars.movepath_delay and arg_5_0.vars.movepath_delay + 1 > os.time() then
		balloon_message_with_sound("portal_interact_wait")
		
		return 
	end
	
	if arg_5_0.vars then
		arg_5_0.vars.movepath_delay = os.time()
	end
	
	local var_5_0 = string.split(arg_5_1, "://")
	
	if var_5_0[1] == "epic7" then
		local var_5_1 = string.split(var_5_0[2], "?")
		local var_5_2 = var_5_1[1]
		local var_5_3 = var_5_1[2] or ""
		local var_5_4 = {}
		
		for iter_5_0, iter_5_1 in pairs(string.split(var_5_3, "&")) do
			local var_5_5 = string.split(iter_5_1, "=")
			local var_5_6 = var_5_5[1]
			local var_5_7 = var_5_5[2] or ""
			
			if tonumber(var_5_7) then
				var_5_7 = tonumber(var_5_7)
			elseif string.lower(var_5_7) == "true" then
				var_5_7 = true
			elseif string.lower(var_5_7) == "false" then
				var_5_7 = false
			end
			
			var_5_4[var_5_6] = var_5_7
		end
		
		if var_5_4.continent then
			local var_5_8, var_5_9 = DB("level_world_3_chapter", var_5_4.continent, {
				"id",
				"lock_schedule"
			})
			
			if not var_5_8 then
				balloon_message_with_sound("notyet_dev")
				
				return 
			end
			
			if var_5_9 and not SubstoryManager:isActiveSchedule(var_5_9) then
				balloon_message_with_sound("notyet_adv")
				
				return 
			end
		end
		
		local var_5_10 = SceneManager:getCurrentSceneName()
		
		if string.starts(var_5_2, "world") and var_5_10 == var_5_2 then
			arg_5_0:moveLocalWorldScene(var_5_4, arg_5_2)
		elseif var_5_10 ~= var_5_2 then
			arg_5_0:moveWorldMap(var_5_4.continentkey, var_5_4.continent, var_5_4.map_id, arg_5_2)
			
			return true
		end
	end
end

function WorldMapController.moveLocalWorldScene(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = false
	
	if not Account:checkEnterMap(arg_6_1.map_id) then
		balloon_message_with_sound("mission_notyet")
		
		return 
	end
	
	if arg_6_0:getMode() == "LAND" then
		arg_6_0:changeMode("TOWN")
		
		var_6_0 = true
	end
	
	if arg_6_0:getMapKey() ~= arg_6_1.continent then
		Action:Add(SEQ(DELAY(100), CALL(arg_6_0.vars.worldmapUI.navi.playEff_shortcut, arg_6_0.vars.worldmapUI.navi, false), CALL(arg_6_0.setting_shortcut_town, arg_6_0, arg_6_1.continentkey, arg_6_1.continent, arg_6_1.map_id, false), DELAY(1200), CALL(arg_6_0.showMapDialog, arg_6_0, arg_6_1.map_id, arg_6_2)), arg_6_0.vars.worldmapUI.layer, "shortcut")
		
		return 
	else
		if arg_6_1.warp then
			if arg_6_2.target_area == arg_6_1.map_id then
				arg_6_2.target_area = nil
			end
			
			Action:Add(SEQ(DELAY(100), CALL(arg_6_0.vars.worldmapUI.navi.playEff_shortcut, arg_6_0.vars.worldmapUI.navi, false), CALL(arg_6_0.setting_shortcut_town, arg_6_0, arg_6_1.continentkey, arg_6_1.continent, arg_6_1.map_id, false), CALL(arg_6_0.clearRunRoad, arg_6_0), CALL(arg_6_0.focusRun, arg_6_0, arg_6_2.target_area, true)), arg_6_0.vars.worldmapUI.layer, "shortcut")
		elseif var_6_0 then
			Action:Add(SEQ(CALL(arg_6_0.setting_shortcut_town, arg_6_0, arg_6_1.continentkey, arg_6_1.continent, arg_6_1.map_id, false), DELAY(1200), CALL(arg_6_0.showMapDialog, arg_6_0, arg_6_1.map_id, arg_6_2)), arg_6_0.vars.worldmapUI.layer, "shortcut")
		elseif arg_6_1.map_id then
			arg_6_0:setting_shortcut_town(arg_6_1.continentkey, arg_6_1.continent, arg_6_1.map_id, true)
		end
		
		return 
	end
end

function WorldMapController.moveWorldMap(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if arg_7_3 and not Account:checkEnterMap(arg_7_3) then
		balloon_message_with_sound("notyet_adv")
		
		return 
	end
	
	local function var_7_0(arg_8_0)
	end
	
	local function var_7_1(arg_9_0)
		if arg_9_0 and arg_9_0.option then
			if arg_7_0.vars.land_navi_icon then
				arg_7_0.vars.land_navi_icon:setVisible(false)
			end
			
			if arg_9_0.option.unlock_before_id and arg_9_0.option.unlock_id and arg_9_0.option.sys_id then
				arg_7_0:getLand():unlockContinentAction(arg_9_0.option.unlock_before_id, arg_9_0.option.unlock_id, arg_9_0.option.sys_id)
				
				return 
			elseif arg_9_0.option.maze and arg_9_0.option.sys_id then
				arg_7_0:getLand():unlockMazeAction(arg_9_0.option.maze, arg_9_0.option.sys_id)
				
				return 
			end
		end
		
		arg_7_0:setting_shortcut_town(arg_7_1, arg_7_2, arg_9_0.map_id)
		
		if arg_7_3 and not Account:checkEnterMap(arg_9_0.map_id) then
		elseif arg_9_0.touch and arg_9_0.map_id then
			arg_7_0.vars.town:showMapDialog(arg_7_0.vars.town.maps[arg_9_0.map_id])
		end
	end
	
	arg_7_0:worldmap({
		touch = true,
		map_id = arg_7_3,
		preLoad = var_7_0,
		afterLoad = var_7_1,
		option = arg_7_4,
		is_story_map = arg_7_5
	})
end

function WorldMapController.getLand(arg_10_0)
	return arg_10_0.vars.land
end

function WorldMapController.lookEnter(arg_11_0, arg_11_1)
	if not arg_11_0.vars.town then
		return 
	end
	
	return arg_11_0.vars.town:lookEnter(arg_11_1)
end

function WorldMapController.getNavi(arg_12_0)
	return arg_12_0.vars.worldmapUI.navi
end

function WorldMapController.getTownIcon(arg_13_0, arg_13_1)
	if arg_13_0.vars.town and arg_13_0.vars.town.icons then
		return arg_13_0.vars.town.icons[arg_13_1]
	end
end

function WorldMapController.getWorldIcon(arg_14_0, arg_14_1)
	if arg_14_0.vars.world and arg_14_0.vars.town.icons then
		return arg_14_0.vars.world.icons[arg_14_1]
	end
end

function WorldMapController.getContinentIcon(arg_15_0, arg_15_1)
	if arg_15_0.vars.town and arg_15_0.vars.town.icons then
		return arg_15_0.vars.land.icons[arg_15_1]
	end
end

function WorldMapController.getWorld(arg_16_0)
	return arg_16_0.vars.world
end

function WorldMapController.getWorldMapUI(arg_17_0)
	return arg_17_0.vars.worldmapUI
end

function WorldMapController.getWorldMapNavi(arg_18_0)
	return arg_18_0.vars.worldmapUI.navi
end

function WorldMapController.onEnterScene(arg_19_0)
	TutorialGuide:onEnterWorldMap()
end

local function var_0_0(arg_20_0)
	if not arg_20_0 then
		return 
	end
	
	local var_20_0 = 0
	
	for iter_20_0 = 1, 999 do
		local var_20_1 = arg_20_0 .. string.format("%03d", iter_20_0)
		
		if not DB("level_enter", var_20_1, {
			"id"
		}) then
			break
		end
		
		local var_20_2 = Account:getStageScore(var_20_1)
		
		if var_20_2 then
			var_20_0 = var_20_0 + var_20_2
		end
	end
	
	local var_20_3 = Account:getWorldmapReward(arg_20_0) or 0
	local var_20_4 = var_20_0
	
	for iter_20_1 = 1, 3 do
		local var_20_5, var_20_6, var_20_7 = DB("level_world_3_chapter", arg_20_0, {
			"reward_star" .. iter_20_1,
			"reward_id" .. iter_20_1,
			"reward_num" .. iter_20_1
		})
		
		if not var_20_5 or not var_20_6 or not var_20_7 then
			break
		end
		
		if var_20_3 and var_20_5 <= var_20_3 then
		elseif var_20_5 <= var_20_4 then
			return true
		elseif var_20_4 < var_20_5 then
		end
	end
end

function WorldMapController.add_map_to_layer(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if not arg_21_2.img then
		return 
	end
	
	local var_21_0 = SpriteCache:getSprite(arg_21_2.img)
	
	if arg_21_0.vars.SCALE == nil then
		local var_21_1 = var_21_0:getContentSize()
		
		arg_21_0.vars.SCALE = arg_21_0.vars.HEIGHT / var_21_1.height
	end
	
	if arg_21_2.rotate then
		var_21_0:setRotation(arg_21_2.rotate)
	end
	
	local var_21_2 = 1
	local var_21_3 = 0
	
	if arg_21_2.align == "STRETCH" then
		var_21_2 = VIEW_WIDTH_RATIO
	end
	
	if arg_21_2.align == "LEFT" then
		var_21_3 = VIEW_BASE_LEFT
	end
	
	if arg_21_2.align == "RIGHT" then
		var_21_3 = 0 - VIEW_BASE_LEFT
	end
	
	var_21_0:setScale(arg_21_0.vars.SCALE * arg_21_2.scale * var_21_2)
	var_21_0:setAnchorPoint(0.5, 0.5)
	var_21_0:setPosition(arg_21_2.x * arg_21_0.vars.WIDTH + var_21_3, arg_21_2.y * arg_21_0.vars.HEIGHT)
	
	if arg_21_2.color ~= nil then
		var_21_0:setColor(arg_21_2.color)
	end
	
	arg_21_1:addChild(var_21_0)
	
	local var_21_4
	local var_21_5 = arg_21_0:getWorldMapUI()
	
	if arg_21_2.name ~= nil and arg_21_2.name ~= "" then
		var_21_4 = WorldMapIcon:create({
			no_userdata = true
		})
		
		local var_21_6 = var_21_4:getChildByName("noti_icon")
		
		var_21_4:setLandTitle(arg_21_2)
		var_21_4:setPosition((arg_21_2.x + arg_21_2.nx) * arg_21_0.vars.WIDTH, (arg_21_2.y + arg_21_2.ny) * arg_21_0.vars.HEIGHT)
		var_21_4:setName(arg_21_2.name)
		
		if get_cocos_refid(arg_21_3) then
			arg_21_3:addChild(var_21_4)
		else
			arg_21_1:addChild(var_21_4)
		end
		
		if arg_21_2.is_world then
			if NewChapterNavigator:isNew({
				continent = arg_21_2.key_continent
			}) then
				local var_21_7 = var_21_4:getChildByName("label_name")
				
				if get_cocos_refid(var_21_7) then
					local var_21_8 = {
						scale = 1,
						anchor = {
							x = 0.5,
							y = 0.5
						},
						pos = {
							y = 35,
							x = var_21_7:getContentSize().width + 30
						}
					}
					
					NewChapterNavigator:attachIndicator(var_21_7, var_21_8)
					var_21_4:bringToFront()
				end
			end
		else
			if not arg_21_0:isSubStoryWorld() then
				StarMissionUI:updateContinentUI(arg_21_2.key_normal, var_21_4)
			elseif get_cocos_refid(var_21_6) then
				local var_21_9 = var_0_0(arg_21_2.key_normal)
				
				if_set_visible(var_21_6, nil, var_21_9)
			end
			
			if NewChapterNavigator:isNew({
				chapter = arg_21_2.key_normal
			}) then
				local var_21_10 = var_21_4:getChildByName("label_name")
				
				if get_cocos_refid(var_21_10) then
					local var_21_11 = var_21_10:getTextBoxSize()
					local var_21_12 = {
						scale = 1,
						anchor = {
							x = 0.5,
							y = 0.5
						},
						pos = {
							x = var_21_11.width / 2 - var_21_11.width - 40,
							y = var_21_11.height / 2
						}
					}
					
					NewChapterNavigator:attachIndicator(var_21_10, var_21_12)
					var_21_4:bringToFront()
				end
			end
		end
		
		if var_21_5 then
			var_21_5:visibleZoomNoti(false)
		end
		
		if arg_21_2.check_text_bg_hide then
			if_set_visible(var_21_4, "label_bg", not arg_21_2.name_text_bg_hide)
		end
		
		local var_21_13 = var_21_4:getChildByName("label_name")
		
		if get_cocos_refid(var_21_13) then
			if arg_21_2.name_text_scale then
				var_21_13:setFontSize(arg_21_2.name_text_scale)
			end
			
			if arg_21_2.name_text_align then
				local var_21_14 = ({
					left = cc.TEXT_ALIGNMENT_LEFT,
					right = cc.TEXT_ALIGNMENT_RIGHT
				})[arg_21_2.name_text_align]
				
				if var_21_14 then
					var_21_13:setTextHorizontalAlignment(var_21_14)
				end
			end
			
			if arg_21_2.label_text_anchor_x or arg_21_2.label_text_anchor_y then
				local var_21_15 = var_21_13:getAnchorPoint()
				local var_21_16 = arg_21_2.label_text_anchor_x or var_21_15.x
				local var_21_17 = arg_21_2.label_text_anchor_y or var_21_15.y
				
				var_21_13:setAnchorPoint(var_21_16, var_21_17)
			end
		end
	end
	
	arg_21_0:setLandNavigator(arg_21_3 or arg_21_1, arg_21_2)
	
	return var_21_0, var_21_4
end

function WorldMapController.setLandNavigator(arg_22_0, arg_22_1, arg_22_2)
	if not get_cocos_refid(arg_22_1) then
		return 
	end
	
	local var_22_0 = ConditionContentsManager:getQuestMissions()
	
	if var_22_0:isActiveQuestInChapter(arg_22_2.key_normal) then
		local var_22_1 = UIUtil:makeNavigatorAni({
			scale = 0.55
		})
		
		var_22_1:setLocalZOrder(99999)
		var_22_1:setPosition((arg_22_2.x + arg_22_2.nx) * arg_22_0.vars.WIDTH, (arg_22_2.y + arg_22_2.ny) * arg_22_0.vars.HEIGHT + 22)
		arg_22_1:addChild(var_22_1)
		
		arg_22_0.vars.land_navi_icon = var_22_1
	end
	
	if arg_22_2.key_continent and arg_22_2.is_world and arg_22_2.key_continent and var_22_0:isActiveQuestInWorld(arg_22_2.key_continent) then
		local var_22_2 = UIUtil:makeNavigatorAni({
			scale = 0.55
		})
		
		var_22_2:setLocalZOrder(99999)
		var_22_2:setGlobalZOrder(999999)
		var_22_2:setPosition((arg_22_2.x + arg_22_2.nx) * arg_22_0.vars.WIDTH, (arg_22_2.y + arg_22_2.ny) * arg_22_0.vars.HEIGHT)
		arg_22_1:addChild(var_22_2)
		
		arg_22_0.vars.world_navi_icon = var_22_2
	end
end

function WorldMapController.setVisibleBackground(arg_23_0, arg_23_1)
	arg_23_0.vars.backgroundWorld:setVisible(arg_23_1)
end

function WorldMapController.setVisibleJustOneMode(arg_24_0, arg_24_1)
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.allLayers) do
		if get_cocos_refid(iter_24_1) then
			if iter_24_0 == arg_24_1 then
				iter_24_1:setVisible(true)
			else
				iter_24_1:setVisible(false)
			end
		end
	end
end

function WorldMapController.zoom(arg_25_0, arg_25_1)
	if not arg_25_0.last_zoom_time or arg_25_0.last_zoom_time + 0.5 < os.time() then
		local var_25_0 = ({
			IN = {
				LAND = "TOWN",
				WORLD = "LAND"
			},
			OUT = {
				LAND = "WORLD",
				TOWN = "LAND"
			}
		})[arg_25_1][arg_25_0.vars.mode]
		
		if var_25_0 then
			arg_25_0:changeMode(var_25_0)
		end
		
		arg_25_0.last_zoom_time = os.time()
	end
end

function WorldMapController.changeMode(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	arg_26_4 = arg_26_4 or {}
	
	local var_26_0 = arg_26_0.vars.mode
	
	if var_26_0 == arg_26_1 then
		return 
	end
	
	arg_26_0.vars.mode = arg_26_1
	
	SoundEngine:stopAmbient(SoundEngine.AMB_MUSIC_TRACK_2)
	
	if arg_26_1 then
		arg_26_0:updateContentButtons(arg_26_1)
	end
	
	if arg_26_1 == "LAND" and arg_26_0.vars.worldmapUI and arg_26_0.vars.worldmapUI.offAdinNode then
		arg_26_0.vars.worldmapUI:offAdinNode()
	end
	
	if var_26_0 == "LAND" and arg_26_1 == "TOWN" then
		local var_26_1 = arg_26_0:getContinentID()
		
		arg_26_2 = arg_26_0.vars.land:searchLandKey(var_26_1)
		
		arg_26_0:showTown()
		arg_26_0.vars.land:playTownEnterAction(arg_26_2, arg_26_3)
		arg_26_0.vars.worldmapUI:setBattleEnterBtn()
		SoundEngine:playAmbient("event:/ui/adventure/amb_small", SoundEngine.AMB_MUSIC_TRACK_2)
		arg_26_0.vars.worldmapUI:setMapMagnifier(arg_26_1)
		
		if not arg_26_3 then
			SoundEngine:play("event:/ui/adventure/zoom_out")
		end
		
		GrowthGuideNavigator:proc()
		
		return 
	end
	
	if var_26_0 == "WORLD" and arg_26_1 == "LAND" then
		arg_26_0.vars.allLayers.WORLD:setVisible(true)
		arg_26_0.vars.allLayers.LAND:setVisible(true)
		
		if not arg_26_2 then
			local var_26_2 = arg_26_0:getContinentID()
			
			arg_26_2 = arg_26_0.vars.world:getChildByKeyContinent(var_26_2)
		end
		
		arg_26_0:showLand(arg_26_2.key_continent)
		arg_26_0.vars.worldmapUI:setTreeIcons(arg_26_2.key_continent == "elasia")
		arg_26_0.vars.land:playLandEnterAction_world(arg_26_2)
		arg_26_0:setVisibleBackground(true)
		arg_26_0.vars.worldmapUI:setBattleEnterBtn()
		SoundEngine:playAmbient("event:/ui/adventure/amb_medium", SoundEngine.AMB_MUSIC_TRACK_2)
		arg_26_0.vars.worldmapUI:setMapMagnifier(arg_26_1)
		
		if not arg_26_3 then
			SoundEngine:play("event:/ui/adventure/zoom_out")
		end
		
		return 
	end
	
	if arg_26_1 == "WORLD" then
		arg_26_0:setVisibleJustOneMode(arg_26_1)
		arg_26_0.vars.world:showWorld()
		arg_26_0.vars.world:playEnterAction()
		arg_26_0:setVisibleBackground(true)
		SoundEngine:playAmbient("event:/ui/adventure/amb_large", SoundEngine.AMB_MUSIC_TRACK_2)
		
		if not arg_26_3 then
			SoundEngine:play("event:/ui/adventure/zoom_in")
		end
	elseif arg_26_1 == "LAND" then
		arg_26_0.vars.allLayers.WORLD:setVisible(true)
		arg_26_0:showLand(nil, arg_26_4)
		
		if not arg_26_3 then
			local var_26_3 = arg_26_0:getContinentID()
			
			arg_26_0.vars.land:playEnterAction(var_26_3)
		end
		
		if false then
		end
		
		arg_26_0:setVisibleBackground(true)
		arg_26_0:setVisibleJustOneMode(arg_26_1)
		SoundEngine:playAmbient("event:/ui/adventure/amb_medium", SoundEngine.AMB_MUSIC_TRACK_2)
		
		if not arg_26_3 then
			SoundEngine:play("event:/ui/adventure/zoom_in")
		end
	elseif arg_26_1 == "TOWN" then
		arg_26_0:setVisibleJustOneMode(arg_26_1)
		
		local var_26_4 = arg_26_0:getContinentID()
		
		arg_26_0.vars.town:playEnterAction()
		arg_26_0:setVisibleBackground(false)
		SoundEngine:playAmbient("event:/ui/adventure/amb_small", SoundEngine.AMB_MUSIC_TRACK_2)
		
		if not arg_26_3 then
			SoundEngine:play("event:/ui/adventure/zoom_out")
		end
	end
	
	arg_26_0.vars.worldmapUI:setMapMagnifier(arg_26_1)
	arg_26_0.vars.worldmapUI:setBattleEnterBtn()
end

function WorldMapController.updateContentButtons(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not arg_27_0.vars.worldmapUI then
		return 
	end
	
	if arg_27_0.vars.worldmapUI.updateContentButtons then
		arg_27_0.vars.worldmapUI:updateContentButtons(arg_27_1)
	end
end

function WorldMapController.isBlockTouchEvent(arg_28_0)
	if is_playing_story() or BattleAction:Find("block") or BattleUIAction:Find("block") or UIAction:Find("block") then
		return true
	end
end

function WorldMapController.onTouchDown(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_0:isBlockTouchEvent() then
		return 
	end
	
	if TutorialGuide:checkBlockWorldmapController() then
		return 
	end
	
	arg_29_0.vars.worldmapUI:onTouchDown(arg_29_1, arg_29_2)
	
	if arg_29_0.vars.mode == "TOWN" and arg_29_0.vars.worldmapUI.touched == false then
		if arg_29_0.vars.worldmapUI.navi.isOpen or arg_29_0.vars.land.unlock_action_mode then
			return 
		end
		
		arg_29_0.vars.town:onTouchDown(arg_29_1, arg_29_2, arg_29_3)
	elseif arg_29_0.vars.mode == "LAND" then
		if arg_29_0.vars.worldmapUI.navi.isOpen then
			return 
		end
		
		arg_29_0.vars.land:onTouchDown(arg_29_1, arg_29_2)
	else
		arg_29_0.vars.world:onTouchDown(arg_29_1, arg_29_2)
	end
end

function WorldMapController.onTouchUp(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	if arg_30_0:isBlockTouchEvent() then
		return 
	end
	
	if TutorialGuide:checkBlockWorldmapController() then
		return 
	end
	
	if arg_30_0.vars.mode == "TOWN" and arg_30_0.vars.worldmapUI.touched == false then
		if arg_30_0.vars.worldmapUI.navi.isOpen or arg_30_0.vars.land.unlock_action_mode then
			arg_30_0.vars.town:resetSelectTown()
			
			return 
		end
		
		arg_30_0.vars.town:onTouchUp(arg_30_1, arg_30_2, arg_30_3)
	end
	
	arg_30_0.vars.worldmapUI:onTouchUp(arg_30_1, arg_30_2)
end

function WorldMapController.onTouchMove(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	if arg_31_0:isBlockTouchEvent() then
		return 
	end
	
	if not TutorialGuide:isAllowEvent() then
		return 
	end
	
	if arg_31_0.vars.mode == "TOWN" and arg_31_0.vars.worldmapUI.touched == false then
		if arg_31_0.vars.worldmapUI.navi.isOpen or arg_31_0.vars.land.unlock_action_mode then
			return 
		end
		
		arg_31_0.vars.town:onTouchMove(arg_31_1, arg_31_2, arg_31_3)
	end
end

function WorldMapController.onGestureZoom(arg_32_0, arg_32_1, arg_32_2)
	if WorldMapTownView:blockZoomInOut() then
		return 
	end
	
	if arg_32_0.vars.mode == "TOWN" then
		if arg_32_0.vars.worldmapUI.navi.isOpen then
			return 
		end
		
		arg_32_0.vars.town:onGestureZoom(arg_32_1, arg_32_2)
	end
	
	if false then
	end
end

function WorldMapController.refreshAllLocalIcons(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = arg_33_0:getLayer()
	
	if not get_cocos_refid(var_33_0) then
		return 
	end
	
	arg_33_0.vars.town:refreshLocalIcons()
end

function WorldMapController.getMoveFlag(arg_34_0, arg_34_1)
	if not arg_34_1 then
		return 
	end
	
	return (DB("level_world_3_chapter", arg_34_1, "move_flag"))
end

function WorldMapController.onAfterUpdate(arg_35_0)
	BattleReady:update()
	
	if arg_35_0.vars.mode == "TOWN" then
		arg_35_0.vars.town:update()
	end
	
	if false then
	end
	
	arg_35_0.vars.town:updateVisibleUrgentMission()
end

function WorldMapController.getLastClearTownKey(arg_36_0)
	local var_36_0 = arg_36_0.vars.town:getLastClearTown()
	
	return string.sub(var_36_0, 1, 3) or "ije"
end

function WorldMapController.playCloudEffect(arg_37_0, arg_37_1)
	local var_37_0 = EffectManager:Play({
		fn = "stagechange_cloud.cfx",
		pivot_z = 99998,
		layer = arg_37_1,
		pivot_x = VIEW_WIDTH / 2,
		pivot_y = VIEW_HEIGHT / 2
	})
	
	arg_37_0.vars.cloud_effect = var_37_0
end

function WorldMapController.isPlayCloudEffect(arg_38_0)
	if not arg_38_0.vars then
		return false
	end
	
	if get_cocos_refid(arg_38_0.vars.cloud_effect) then
		return true
	end
	
	return false
end

function WorldMapController.saveLastTown(arg_39_0, arg_39_1)
	if arg_39_1 and arg_39_0.vars then
		local var_39_0, var_39_1 = DB("level_enter", arg_39_1, {
			"skip_stage_save",
			"local_num"
		})
		
		if var_39_0 then
			return 
		end
		
		if var_39_1 == nil then
			return 
		end
		
		if not string.starts(arg_39_1, var_39_1) then
			return 
		end
		
		SAVE:setTempConfigData("last_clear_town", arg_39_1)
	end
end

function WorldMapController.setting_shortcut_town(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4, arg_40_5)
	arg_40_0:changeMode("TOWN")
	arg_40_0:shortCutTown(arg_40_2, arg_40_5)
	
	if arg_40_3 then
		if arg_40_4 then
			arg_40_0.vars.town:focusRun(arg_40_3)
		else
			arg_40_0.vars.town:setCurTown(arg_40_3)
		end
	end
end

function WorldMapController.shortCutTown(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0
	
	if arg_41_1 then
		local var_41_1 = arg_41_0:getLinkDB().chapter[arg_41_1]
		
		if not var_41_1.world_id then
			Log.e("WorldMapController.shortCutTown", "no_world_id")
		end
		
		arg_41_0:setWorldID(var_41_1.world_id)
		arg_41_0:showTown(arg_41_1, arg_41_2)
		arg_41_0.vars.worldmapUI:UpdateAfterShowTown(arg_41_0:getMapKey())
	end
end

function WorldMapController.startSoundCharacterWalk(arg_42_0)
	SoundEngine:playAmbient("event:/action/walk_loop", SoundEngine.AMB_MUSIC_TRACK_1)
end

function WorldMapController.stopSoundCharacterWalk(arg_43_0)
	SoundEngine:stopAmbient(SoundEngine.AMB_MUSIC_TRACK_1)
end

function WorldMapController.goBackMainMenu(arg_44_0, arg_44_1, arg_44_2)
	if Action:Find("worldmap_action") then
		return 
	end
	
	SoundEngine:play("event:/ui/btn_cancel")
	arg_44_0:stopSoundCharacterWalk()
	UIAction:Remove("CHAR_MOVE")
	SceneManager:nextScene("lobby", {
		color = cc.c3b(255, 255, 255)
	})
end

function WorldMapController.getSceneState(arg_45_0)
	local var_45_0 = {}
	local var_45_1
	
	if arg_45_0.vars.town then
		var_45_1 = arg_45_0.vars.town:getCurTown()
	end
	
	if OriginTree and OriginTree.select_idx then
		var_45_0.tree_select_idx, var_45_0.tree_prev_star_count, var_45_0.camp_type = OriginTree:getSceneState()
	end
	
	if var_45_1 and DB("level_enter", var_45_1, "type") == "story" then
		var_45_0.map_id = var_45_1
		var_45_0.is_story_map = true
		
		return var_45_0
	end
	
	if not BattleReady or not BattleReady.vars then
		return var_45_0
	end
	
	if not BattleReady.vars.enter_id then
		return var_45_0
	end
	
	local function var_45_2(arg_46_0)
	end
	
	local function var_45_3(arg_47_0)
		local var_47_0 = arg_47_0.map_id
		local var_47_1 = arg_45_0:getKeyContinent()
		local var_47_2 = arg_45_0:getMapKey()
		
		arg_45_0:setting_shortcut_town(var_47_1, var_47_2, var_47_0, nil, true)
		
		if arg_47_0.touch then
			arg_45_0.vars.town:showMapDialog(arg_45_0.vars.town.maps[arg_47_0.map_id])
		end
	end
	
	var_45_0.map_id = BattleReady.vars.enter_id
	var_45_0.touch = true
	var_45_0.preLoad = var_45_2
	var_45_0.afterLoad = var_45_3
	
	return var_45_0
end

function WorldMapController.setVisibleLayer(arg_48_0, arg_48_1)
	if not arg_48_0.vars then
		return 
	end
	
	arg_48_0.vars.layer:setVisible(arg_48_1)
end

function WorldMapController.refreshUrgentMissionIcon(arg_49_0, arg_49_1)
	if not arg_49_0.vars or not arg_49_0.vars.town then
		return 
	end
	
	arg_49_0.vars.town:refreshUrgentMissionIcon(arg_49_1)
end

function WorldMapController.getTown(arg_50_0)
	if not arg_50_0.vars then
		return 
	end
	
	return arg_50_0.vars.town
end

function WorldMapController.updateFestivalTags(arg_51_0)
	if not arg_51_0.vars or not arg_51_0.vars.town then
		return 
	end
	
	arg_51_0.vars.town:updateFestivalTags()
end

function WorldMapController.showMapDialog(arg_52_0, arg_52_1, arg_52_2)
	arg_52_2 = arg_52_2 or {}
	arg_52_2.map_id = arg_52_1
	
	if not arg_52_0.vars or not arg_52_0.vars.town then
		return 
	end
	
	if not arg_52_2.portal and DB("level_enter", arg_52_2.map_id, "type") == "portal" then
		balloon_message_with_sound("err_prev_portal")
		
		return 
	end
	
	arg_52_0.vars.town:showMapDialog(arg_52_0.vars.town:getMapInfo(arg_52_1), arg_52_2)
end

function WorldMapController.clearRunRoad(arg_53_0)
	if not arg_53_0.vars or not arg_53_0.vars.town then
		return 
	end
	
	arg_53_0.vars.town:clearRunRoad()
end

function WorldMapController.focusRun(arg_54_0, arg_54_1, arg_54_2)
	if not arg_54_0.vars or not arg_54_0.vars.town then
		return 
	end
	
	if not arg_54_1 then
		return 
	end
	
	arg_54_0.vars.town:focusRun(arg_54_1, nil, arg_54_2)
end

function WorldMapController.setCurTown(arg_55_0, arg_55_1)
	if not arg_55_0.vars or not arg_55_0.vars.town then
		return 
	end
	
	arg_55_0.vars.town:setCurTown(arg_55_1)
end

function WorldMapController.getMode(arg_56_0)
	if not arg_56_0.vars then
		return 
	end
	
	return arg_56_0.vars.mode
end

function WorldMapController.setMapKey(arg_57_0, arg_57_1)
	if not arg_57_0.vars or not arg_57_0.vars.town then
		return 
	end
	
	arg_57_0.vars.town.map_key = arg_57_1
end

function WorldMapController.getMapKey(arg_58_0)
	if not arg_58_0.vars or not arg_58_0.vars.town then
		return 
	end
	
	return arg_58_0.vars.town.map_key
end

function WorldMapController.getTownMaps(arg_59_0)
	if not arg_59_0.vars or not arg_59_0.vars.town then
		return 
	end
	
	return arg_59_0.vars.town.maps
end

function WorldMapController.getLayer(arg_60_0)
	if not arg_60_0.vars or not arg_60_0.vars.layer then
		return 
	end
	
	return arg_60_0.vars.layer
end

function WorldMapController.getCurrentTown(arg_61_0)
	if not arg_61_0.vars or not arg_61_0.vars.town then
		return 
	end
	
	return arg_61_0.vars.town.cur_town
end

function WorldMapController.getTargetTown(arg_62_0)
	if not arg_62_0.vars or not arg_62_0.vars.town then
		return 
	end
	
	return arg_62_0.vars.town.target_town
end

function WorldMapController.isSubStoryWorld(arg_63_0)
	if arg_63_0.vars.sub_story then
		return true
	end
	
	return false
end

function WorldMapController.updateWorldBGM(arg_64_0)
	if not arg_64_0.vars or not arg_64_0.vars.world or not arg_64_0.vars.bgm then
		return 
	end
	
	local var_64_0, var_64_1 = DB("level_world_1_world", arg_64_0:getWorldID(), {
		"id",
		"bgm"
	})
	
	if var_64_0 and var_64_1 and arg_64_0.vars.bgm ~= var_64_1 then
		arg_64_0.vars.bgm = var_64_1
		
		local var_64_2 = arg_64_0:getBGM()
		
		SoundEngine:playBGM(var_64_2)
	end
end

function WorldMapController.getBGM(arg_65_0)
	if not arg_65_0.vars then
		return 
	end
	
	if not arg_65_0.vars.town then
		return 
	end
	
	if arg_65_0.vars.mode == "TOWN" then
		local var_65_0 = arg_65_0.vars.town:getBGM()
		
		if var_65_0 then
			return "event:/bgm/" .. var_65_0
		end
	end
	
	if arg_65_0.vars.bgm then
		return "event:/bgm/" .. arg_65_0.vars.bgm
	else
		return "event:/bgm/adventure_normal"
	end
end

function WorldMapController.setBGM(arg_66_0, arg_66_1)
	if not arg_66_0.vars then
		return 
	end
	
	if not arg_66_0.vars.town then
		return 
	end
	
	arg_66_0.vars.bgm = arg_66_1
end

function WorldMapController.playBGM(arg_67_0)
	local var_67_0 = arg_67_0:getBGM()
	
	if var_67_0 then
		SoundEngine:playBGM(var_67_0)
	end
end

function WorldMapController.showTown(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	arg_68_0.vars.town:showTown(arg_68_1, arg_68_2, arg_68_3)
	arg_68_0.vars.worldmapUI:UpdateAfterShowTown(arg_68_0:getMapKey())
end

function WorldMapController.showLand(arg_69_0, arg_69_1, arg_69_2)
	arg_69_2 = arg_69_2 or {}
	
	arg_69_0.vars.land:showLand(arg_69_2.force_continent_key or arg_69_1, arg_69_2)
	arg_69_0.vars.worldmapUI:UpdateAfterShowLand()
end

function WorldMapController.getContinentAtlas(arg_70_0, arg_70_1)
	local var_70_0
	
	if arg_70_1 then
		var_70_0 = arg_70_0:getLinkDB().key_continent[arg_70_1].world_id
	else
		var_70_0 = arg_70_0:getWorldID()
	end
	
	return DB("level_world_1_world", tostring(var_70_0), "continent_atlas")
end

function WorldMapController.getWorldID(arg_71_0)
	return tostring(arg_71_0.vars.world_id)
end

function WorldMapController.getKeyContinent(arg_72_0)
	local var_72_0 = arg_72_0:getLinkDB()
	local var_72_1 = arg_72_0:getWorldID()
	
	return var_72_0.world[var_72_1].key_continent
end

function WorldMapController.getKeyContinentLookChapter(arg_73_0)
	local var_73_0 = arg_73_0:getLinkDB()
	local var_73_1 = arg_73_0:getMapKey()
	
	return var_73_0.chapter[var_73_1].key_continent
end

function WorldMapController.getContinentID(arg_74_0)
	local var_74_0 = arg_74_0:getLinkDB()
	local var_74_1 = arg_74_0:getMapKey()
	
	return var_74_0.chapter[var_74_1].continent_id
end

function WorldMapController.getCustomContinent(arg_75_0)
	local var_75_0 = arg_75_0:getWorldID()
	
	return (DB("level_world_1_world", tostring(var_75_0), "custom_continent"))
end

function WorldMapController.setWorldID(arg_76_0, arg_76_1)
	arg_76_0.vars.world_id = tostring(arg_76_1)
end

function WorldMapController.canOpenAdin(arg_77_0)
	return to_n(arg_77_0:getWorldIDByMapKey()) == 5
end

function WorldMapController.getWorldIDByMapKey(arg_78_0)
	local var_78_0 = arg_78_0:getMapKey()
	local var_78_1 = DB("level_world_3_chapter", var_78_0, "world_id")
	
	return (tostring(var_78_1))
end

function WorldMapController.getLinkDB(arg_79_0)
	return WorldMapManager:getAdvLinkDB()
end

function WorldMapController.clear_link_db(arg_80_0)
	arg_80_0.link_db = nil
end

AdvWorldMapController = AdvWorldMapController or {}

copy_functions(WorldMapController, AdvWorldMapController)

function AdvWorldMapController.create(arg_81_0, arg_81_1)
	arg_81_0.vars = {}
	arg_81_0.vars.DARK = cc.c3b(180, 130, 130)
	arg_81_0.vars.DARK_NAME = cc.c3b(255, 180, 180)
	arg_81_0.vars.HEIGHT = DESIGN_HEIGHT
	arg_81_0.vars.WIDTH = DESIGN_WIDTH
	arg_81_0.vars.SCALE = nil
	arg_81_0.vars.mode = "TOWN"
	arg_81_0.vars.type = WORLDMAP_TYPE.ADV
	
	local var_81_0 = Account:getConfigData("last_clear_town") or "ije001"
	local var_81_1 = DB("level_enter", var_81_0, {
		"local_num"
	}) or "ije"
	local var_81_2 = arg_81_0:getLinkDB()
	local var_81_3 = var_81_2.chapter[var_81_1]
	
	if not var_81_3 then
		var_81_1 = "ije"
		var_81_3 = var_81_2.chapter[var_81_1]
	end
	
	arg_81_0.vars.world_id = var_81_3.world_id
	
	if get_cocos_refid(arg_81_0.vars.layer) then
		arg_81_0.vars.layer:removeAllChildren()
	end
	
	local var_81_4 = cc.Layer:create()
	
	arg_81_0.vars.layer = var_81_4
	
	local var_81_5 = WorldMapLandAdv()
	
	arg_81_0.vars.land = var_81_5
	
	local var_81_6, var_81_7, var_81_8, var_81_9, var_81_10 = DB("level_world_1_world", "1", {
		"img",
		"scale",
		"x",
		"y",
		"align"
	})
	local var_81_11 = {
		img = var_81_6,
		scale = var_81_7,
		x = var_81_8,
		y = var_81_9,
		align = var_81_10
	}
	
	arg_81_0.vars.backgroundWorld = arg_81_0:add_map_to_layer(arg_81_0.vars.layer, var_81_11)
	
	arg_81_0.vars.backgroundWorld:setLocalZOrder(1)
	arg_81_0.vars.backgroundWorld:setName(var_81_6)
	arg_81_0:setVisibleBackground(false)
	
	local var_81_12 = WorldMapWorldAdv()
	local var_81_13 = var_81_12:create(arg_81_0)
	
	arg_81_0.vars.world = var_81_12
	
	local var_81_14 = DB("level_world_1_world", tostring(arg_81_0.vars.world_id), {
		"bgm"
	})
	
	arg_81_0.vars.bgm = var_81_14
	
	arg_81_0.vars.layer:addChild(var_81_13)
	var_81_13:setLocalZOrder(2)
	
	local var_81_15 = var_81_5:create(arg_81_0)
	
	arg_81_0.vars.layer:addChild(var_81_15)
	var_81_15:setLocalZOrder(3)
	
	local var_81_16 = WorldMapTownAdv()
	local var_81_17 = var_81_16:create(arg_81_0, var_81_1, arg_81_1)
	
	arg_81_0.vars.town = var_81_16
	
	arg_81_0.vars.layer:addChild(var_81_17)
	var_81_17:setLocalZOrder(0)
	
	local var_81_18 = AdvWorldMapUI:create(arg_81_0)
	
	arg_81_0.vars.worldmapUI = AdvWorldMapUI
	arg_81_0.vars.ui_layer = var_81_18
	
	arg_81_0.vars.layer:addChild(var_81_18)
	arg_81_0.vars.ui_layer:setLocalZOrder(10)
	arg_81_0.vars.worldmapUI:setMapMagnifier("TOWN")
	arg_81_0.vars.ui_layer:setContentSize(arg_81_0.vars.WIDTH, arg_81_0.vars.HEIGHT)
	var_81_4:setContentSize(arg_81_0.vars.WIDTH, arg_81_0.vars.HEIGHT)
	var_81_4:setPosition(arg_81_0.vars.WIDTH / 2, arg_81_0.vars.HEIGHT / 2)
	var_81_4:setAnchorPoint(0.5, 0.5)
	var_81_4:ignoreAnchorPointForPosition(false)
	
	arg_81_0.vars.allLayers = {}
	arg_81_0.vars.allLayers.WORLD = var_81_13
	arg_81_0.vars.allLayers.LAND = var_81_15
	arg_81_0.vars.allLayers.TOWN = var_81_17
	
	arg_81_0.vars.worldmapUI:UpdateAfterShowTown(arg_81_0:getMapKey())
	arg_81_0:setVisibleJustOneMode(arg_81_0.vars.mode)
	arg_81_0.vars.worldmapUI:setBattleEnterBtn()
	
	return var_81_4
end
