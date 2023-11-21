WorldMapManager = WorldMapManager or {}

function WorldMapManager.getController(arg_1_0)
	if SubstoryManager:getInfo() then
		return SubstoryManager:getContentsController()
	else
		return AdvWorldMapController
	end
end

function WorldMapManager.getControllerBySceneName(arg_2_0, arg_2_1)
	if arg_2_1 == "worldmap_scene" then
		return AdvWorldMapController
	elseif arg_2_1 == "world_sub" then
		return SubWorldMapController
	elseif arg_2_1 == "world_custom" then
		return CustomWorldMapController
	end
end

function WorldMapManager.getWorldMapUI(arg_3_0)
	local var_3_0 = arg_3_0:getController()
	
	if not var_3_0 or not var_3_0.vars then
		return 
	end
	
	return var_3_0.vars.worldmapUI
end

function WorldMapManager.getNavigator(arg_4_0)
	local var_4_0 = arg_4_0:getWorldMapUI()
	
	if not var_4_0 then
		return 
	end
	
	return var_4_0.navi
end

function WorldMapManager.hideNPC(arg_5_0)
end

function WorldMapManager.showNPC(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_0:getWorldMapUI():showNPC(arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
end

function WorldMapManager.getCurrentContinentKey(arg_7_0)
	local var_7_0 = WorldMapManager:getController()
	
	if not var_7_0 then
		return 
	end
	
	local var_7_1 = var_7_0:getWorldIDByMapKey()
	
	return DB("level_world_1_world", tostring(var_7_1), "key_continent")
end

function WorldMapManager.moveLastEpisode(arg_8_0)
	local var_8_0 = Account:getConfigData("last_clear_town") or "ije001"
	local var_8_1 = DB("level_enter", var_8_0, {
		"local_num"
	}) or "ije"
	local var_8_2 = WorldMapManager:getAdvLinkDB()
	local var_8_3 = var_8_2.chapter[var_8_1]
	
	if not var_8_3 then
		local var_8_4 = "ije"
		
		var_8_3 = var_8_2.chapter[var_8_4]
	end
	
	local var_8_5 = var_8_3.continent_id
	local var_8_6 = DB("level_world_2_continent", var_8_5, "ep_select_path")
	
	movetoPath(var_8_6)
end

local function var_0_0(arg_9_0)
	for iter_9_0, iter_9_1 in pairs(arg_9_0.world) do
		for iter_9_2 = 1, 999 do
			local var_9_0 = iter_9_1.key_continent .. string.format("%03d", iter_9_2)
			local var_9_1 = DB("level_world_2_continent", var_9_0, {
				"key_normal"
			})
			
			if var_9_1 then
				arg_9_0.continent[var_9_0] = {
					key_normal = var_9_1,
					world_id = iter_9_0,
					key_continent = iter_9_1.key_continent
				}
			end
		end
	end
	
	for iter_9_3, iter_9_4 in pairs(arg_9_0.continent) do
		local var_9_2 = iter_9_4.key_normal
		local var_9_3 = DB("level_world_3_chapter", var_9_2, {
			"id"
		})
		
		if var_9_3 then
			arg_9_0.chapter[var_9_3] = {
				world_id = iter_9_4.world_id,
				continent_id = iter_9_3,
				key_continent = iter_9_4.key_continent
			}
		end
	end
end

function WorldMapManager.getAdvLinkDB(arg_10_0)
	if arg_10_0.link_db == nil then
		arg_10_0.link_db = {}
	end
	
	if arg_10_0.link_db.adv == nil then
		arg_10_0.link_db.adv = {}
		arg_10_0.link_db.adv.world = {}
		arg_10_0.link_db.adv.continent = {}
		arg_10_0.link_db.adv.chapter = {}
		arg_10_0.link_db.adv.key_continent = {}
		
		for iter_10_0 = 2, 999 do
			local var_10_0, var_10_1, var_10_2 = DBN("level_world_1_world", iter_10_0, {
				"id",
				"key_continent",
				"type"
			})
			
			if not var_10_0 then
				break
			end
			
			if var_10_1 and var_10_2 == "adventure" then
				arg_10_0.link_db.adv.world[tostring(var_10_0)] = {
					key_continent = var_10_1
				}
				arg_10_0.link_db.adv.key_continent[var_10_1] = {
					world_id = tostring(var_10_0)
				}
			end
		end
		
		var_0_0(arg_10_0.link_db.adv)
	end
	
	return arg_10_0.link_db.adv
end

function WorldMapManager.getSubstoryLinkDB(arg_11_0, arg_11_1)
	if arg_11_0.link_db == nil then
		arg_11_0.link_db = {}
	end
	
	if not arg_11_0.link_db[arg_11_1] then
		arg_11_0.link_db[arg_11_1] = {}
		
		local var_11_0 = arg_11_0.link_db[arg_11_1]
		
		var_11_0.world = {}
		var_11_0.continent = {}
		var_11_0.chapter = {}
		var_11_0.key_continent = {}
		
		for iter_11_0 = 2, 999 do
			local var_11_1, var_11_2, var_11_3, var_11_4 = DBN("level_world_1_world", iter_11_0, {
				"id",
				"key_continent",
				"type",
				"sub_story"
			})
			
			if not var_11_1 then
				break
			end
			
			if var_11_2 and var_11_3 == "substory" and var_11_4 == arg_11_1 then
				var_11_0.world[tostring(var_11_1)] = {
					key_continent = var_11_2
				}
				var_11_0.key_continent[var_11_2] = {
					world_id = tostring(var_11_1)
				}
			end
		end
		
		var_0_0(var_11_0)
	end
	
	return arg_11_0.link_db[arg_11_1]
end

function WorldMapManager.isSubstoryWorldMapScene(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or SceneManager:getCurrentSceneName()
	
	if arg_12_1 == "world_sub" or arg_12_1 == "world_custom" then
		return true
	end
	
	return false
end

WorldMapUtil = WorldMapUtil or {}

function WorldMapUtil.getContinentListByContinentKey(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return {}
	end
	
	local var_13_0 = {}
	
	for iter_13_0 = 1, 99 do
		local var_13_1 = arg_13_1 .. string.format("%03d", iter_13_0)
		local var_13_2, var_13_3, var_13_4, var_13_5, var_13_6, var_13_7 = DB("level_world_2_continent", var_13_1, {
			"id",
			"name",
			"ep_select_sort",
			"ep_select_path",
			"key_normal",
			"lock"
		})
		
		if not var_13_2 then
			break
		end
		
		if var_13_6 then
			table.insert(var_13_0, {
				id = var_13_2,
				name = var_13_3,
				ep_sort = var_13_4,
				ep_select_path = var_13_5,
				key_normal = var_13_6,
				lock = var_13_7
			})
		end
	end
	
	return var_13_0
end
