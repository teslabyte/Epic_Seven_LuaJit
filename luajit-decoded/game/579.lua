ChapterMonsterData = ChapterMonsterData or {}

function ChapterMonsterData.getChapterInfos(arg_1_0)
	if not arg_1_0.datas then
		ChapterMonsterData:setChapterInfos()
	end
	
	return arg_1_0.datas
end

function ChapterMonsterData.setChapterInfos(arg_2_0)
	arg_2_0.datas = ChapterMonsterData:initData()
end

function ChapterMonsterData.getMonsterInfoByChapterID(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return {}
	end
	
	return arg_3_0:getChapterInfos()[arg_3_1]
end

function ChapterMonsterData.initData(arg_4_0)
	local var_4_0 = {}
	
	for iter_4_0 = 1, 999 do
		local var_4_1 = DBN("level_world_3_chapter", iter_4_0, {
			"id"
		})
		
		if not var_4_1 then
			break
		end
		
		var_4_0[var_4_1] = arg_4_0:initChapterData(var_4_1)
	end
	
	return var_4_0
end

function ChapterMonsterData.initChapterData(arg_5_0, arg_5_1)
	local var_5_0 = DBT("level_enter_chapters", arg_5_1, {
		"id",
		"monster_ids"
	})
	local var_5_1 = {}
	
	if var_5_0.monster_ids then
		local var_5_2 = totable(var_5_0.monster_ids)
		
		for iter_5_0, iter_5_1 in pairs(var_5_2) do
			local var_5_3 = DBT("level_chapter_monsters", arg_5_1 .. "@" .. iter_5_0, {
				"id",
				"map_ids",
				"essence"
			})
			local var_5_4 = false
			local var_5_5
			local var_5_6 = {}
			
			var_5_3.map_ids = var_5_3.map_ids or {}
			
			local var_5_7 = totable(var_5_3.map_ids)
			local var_5_8 = totable(var_5_3.essence)
			
			for iter_5_2, iter_5_3 in pairs(var_5_7 or {}) do
				table.insert(var_5_6, iter_5_2)
				
				local var_5_9, var_5_10 = DB("level_enter", iter_5_2, {
					"type",
					"hide_boss"
				})
				local var_5_11 = DB("character", iter_5_0, {
					"monster_tier"
				})
				local var_5_12 = Account:isMapCleared(iter_5_2)
				
				if var_5_10 == "y" and (var_5_9 == "quest" or var_5_9 == "extra_quest" or var_5_9 == "dungeon_quest" or var_5_9 == "defense_quest") and not var_5_12 and var_5_11 == "boss" then
					var_5_4 = true
				end
			end
			
			table.sort(var_5_6, function(arg_6_0, arg_6_1)
				return tonumber(string.sub(arg_6_0, -3, -1)) < tonumber(string.sub(arg_6_1, -3, -1))
			end)
			
			for iter_5_4, iter_5_5 in pairs(var_5_8 or {}) do
				if iter_5_4 ~= "none" and iter_5_4 ~= "nil" then
					var_5_5 = iter_5_4
					
					break
				end
			end
			
			local var_5_13 = 100000000
			
			if var_5_5 then
				var_5_13 = DB("item_material", var_5_5, "sort")
			end
			
			table.insert(var_5_1, {
				chapter_id = arg_5_1,
				monster_id = iter_5_0,
				map_ids = var_5_6,
				essence = var_5_5,
				sort = var_5_13,
				is_hide = var_5_4
			})
		end
		
		table.sort(var_5_1, function(arg_7_0, arg_7_1)
			return (tonumber(arg_7_0.sort) or 999) < (tonumber(arg_7_1.sort) or 999)
		end)
	end
	
	return var_5_1
end

MissionNavigatorInfo = MissionNavigatorInfo or {}

function MissionNavigatorInfo.init(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.vars = {}
	arg_8_0.vars.navigator = arg_8_2
	arg_8_0.vars.wnd = arg_8_1:getChildByName("n_infomation")
end

function MissionNavigatorInfo.show(arg_9_0)
	arg_9_0.vars.wnd:setVisible(true)
	
	local var_9_0 = arg_9_0.vars.navigator.controller:getMapKey()
	
	if var_9_0 ~= arg_9_0.vars.chapter_key then
		arg_9_0.vars.chapter_key = var_9_0
		
		arg_9_0:updateInfomation()
	end
end

function MissionNavigatorInfo.hide(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if not arg_10_0.vars.wnd or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	arg_10_0.vars.wnd:setVisible(false)
end

function MissionNavigatorInfo.updateInfomation(arg_11_0)
	local var_11_0 = DBT("level_world_3_chapter", arg_11_0.vars.chapter_key, {
		"name",
		"desc",
		"info_image"
	})
	
	if_set_sprite(arg_11_0.vars.wnd, "bg_Image", "map/" .. var_11_0.info_image .. ".png")
	
	local var_11_1 = arg_11_0.vars.wnd:getChildByName("txt_local")
	local var_11_2 = arg_11_0.vars.wnd:getChildByName("txt_desc")
	
	if get_cocos_refid(var_11_1) and get_cocos_refid(var_11_2) then
		if_set(var_11_1, nil, T(var_11_0.name))
		if_set(var_11_2, nil, T(var_11_0.desc))
	end
end

MissionNavigatorMonsterInfo = MissionNavigatorMonsterInfo or {}

function MissionNavigatorMonsterInfo.init(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0.vars = {}
	arg_12_0.vars.wnd = arg_12_1:getChildByName("n_monster")
	arg_12_0.vars.navigator = arg_12_2
	
	arg_12_0:initMonsterListView()
	arg_12_0:initMonsterEnterListView()
end

function MissionNavigatorMonsterInfo.show(arg_13_0)
	arg_13_0.vars.wnd:setVisible(true)
	
	local var_13_0 = arg_13_0.vars.navigator.controller:getMapKey()
	
	if var_13_0 ~= arg_13_0.vars.chapter_key then
		arg_13_0.vars.chapter_key = var_13_0
		
		arg_13_0:setData()
		arg_13_0:setEnterData({}, true)
	end
end

function MissionNavigatorMonsterInfo.hide(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if not arg_14_0.vars.wnd or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	arg_14_0.vars.wnd:setVisible(false)
end

function MissionNavigatorMonsterInfo.initMonsterListView(arg_15_0)
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("listview_mon")
	
	arg_15_0.vars.monster_itemView = ItemListView_v2:bindControl(var_15_0)
	
	local var_15_1 = load_control("wnd/mission_base_monster_info_item.csb")
	local var_15_2 = {
		onTouchUp = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
			if arg_16_4.cancelled then
				return 
			end
			
			MissionNavigatorMonsterInfo:selectItem(arg_16_1, arg_16_3)
		end,
		onUpdate = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			MissionNavigatorMonsterInfo:updateMonsterInfo(arg_17_1, arg_17_3)
			
			return arg_17_3.monster_id
		end
	}
	
	arg_15_0.vars.monster_itemView:setRenderer(var_15_1, var_15_2)
	arg_15_0.vars.monster_itemView:removeAllChildren()
	arg_15_0.vars.monster_itemView:setDataSource({})
end

function MissionNavigatorMonsterInfo.isEmptyData(arg_18_0)
	return arg_18_0.vars and arg_18_0.vars.data and table.empty(arg_18_0.vars.data)
end

function MissionNavigatorMonsterInfo.setData(arg_19_0)
	local var_19_0 = ChapterMonsterData:getMonsterInfoByChapterID(arg_19_0.vars.chapter_key)
	
	arg_19_0.vars.data = table.clone(var_19_0)
	
	arg_19_0.vars.monster_itemView:setDataSource({})
	arg_19_0.vars.monster_itemView:setDataSource(arg_19_0.vars.data)
	arg_19_0.vars.monster_itemView:jumpToTop()
end

function MissionNavigatorMonsterInfo.updateMonsterInfo(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_1.data ~= arg_20_2 then
		if arg_20_2.is_hide then
			arg_20_2.monster_id = "m0000"
		end
		
		UIUtil:getRewardIcon(nil, arg_20_2.monster_id, {
			no_popup = true,
			hide_star = true,
			monster = true,
			scale = 1.6,
			no_grade = true,
			parent = arg_20_1:getChildByName("face_enemy")
		})
		
		if arg_20_2.essence and arg_20_2.essence ~= "nil" then
			UIUtil:getRewardIcon(nil, arg_20_2.essence, {
				no_popup = true,
				no_detail_popup = true,
				tooltip_delay = 200,
				no_bg = true,
				scale = 1.1,
				no_grade = true,
				parent = arg_20_1:getChildByName("n_item")
			})
		end
		
		arg_20_1.data = arg_20_2
	end
	
	if_set_visible(arg_20_1, "select", arg_20_2.selected)
end

function MissionNavigatorMonsterInfo.selectItem(arg_21_0, arg_21_1, arg_21_2)
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.data) do
		iter_21_1.selected = false
	end
	
	arg_21_2.selected = true
	
	arg_21_0.vars.monster_itemView:refresh()
	
	local var_21_0 = {}
	local var_21_1 = WorldMapManager:getController()
	
	for iter_21_2, iter_21_3 in pairs(arg_21_2.map_ids) do
		local var_21_2, var_21_3, var_21_4, var_21_5, var_21_6, var_21_7 = DB("level_enter", iter_21_3, {
			"id",
			"local_icon",
			"name",
			"local_num",
			"difficulty_id",
			"quest_chapter_icon"
		})
		local var_21_8 = false
		
		if var_21_2 and var_21_1 then
			if get_cocos_refid(var_21_1:getTownIcon(var_21_2)) then
				var_21_8 = true
			end
		else
			var_21_8 = true
		end
		
		if var_21_8 then
			table.insert(var_21_0, {
				enter_id = var_21_2,
				name = var_21_4,
				icon = var_21_3,
				chapter_id = var_21_5,
				difficulty_id = var_21_6,
				chapter_icon = var_21_7
			})
		end
	end
	
	arg_21_0:setEnterData(var_21_0)
end

function MissionNavigatorMonsterInfo.initMonsterEnterListView(arg_22_0)
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("listview_map")
	
	arg_22_0.vars.enter_itemView = ItemListView_v2:bindControl(var_22_0)
	
	local var_22_1 = load_control("wnd/mission_base_monster_location_item.csb")
	
	var_22_1.parent = arg_22_0
	
	local var_22_2 = {
		onUpdate = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			MissionNavigatorMonsterInfo:updateEnterInfo(arg_23_1, arg_23_3)
			
			return arg_23_3.enter_id
		end
	}
	
	arg_22_0.vars.enter_itemView:setRenderer(var_22_1, var_22_2)
	arg_22_0.vars.enter_itemView:removeAllChildren()
	arg_22_0.vars.enter_itemView:setDataSource({})
end

function MissionNavigatorMonsterInfo.updateEnterInfo(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_2.chapter_icon or arg_24_2.icon
	local var_24_1 = WorldMapTown:getLocalIcon(var_24_0)
	
	if_set_sprite(arg_24_1, "map_icon", "map/" .. var_24_1 .. ".png")
	if_set(arg_24_1, "txt_monster_map_0", T(arg_24_2.name))
	
	local var_24_2 = arg_24_1:getChildByName("btn_move")
	local var_24_3 = arg_24_2.difficulty_id or arg_24_2.enter_id
	local var_24_4 = WorldMapManager:getController():getKeyContinentLookChapter()
	
	var_24_2.btn_move = "epic7://" .. SceneManager:getCurrentSceneName() .. "?" .. "continentkey=" .. var_24_4 .. "&continent=" .. arg_24_2.chapter_id .. "&map_id=" .. var_24_3
end

function MissionNavigatorMonsterInfo.setEnterData(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0.vars.enter_itemView:setDataSource(arg_25_1)
	arg_25_0.vars.enter_itemView:jumpToTop()
	
	local var_25_0 = #(arg_25_1 or {}) <= 0
	
	if_set_visible(arg_25_0.vars.wnd, "n_no_select", var_25_0)
	
	if get_cocos_refid(arg_25_0.vars.wnd) then
		local var_25_1 = arg_25_0.vars.wnd:getChildByName("n_no_select")
		
		if var_25_0 and get_cocos_refid(var_25_1) then
			local var_25_2 = arg_25_2 and T("mission_base_select_first") or T("mission_base_select_second")
			
			if_set(var_25_1, "label", var_25_2)
		end
	end
end
