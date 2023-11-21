function HANDLER.chapter_shop_change(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		Dialog:close("chapter_shop_change")
		
		return 
	end
	
	if arg_1_1 == "btn_cshop_go" then
		local var_1_0 = ShopChapterUtil:getShopChatperObj(true)
		
		if var_1_0 then
			var_1_0:onBtnGo(arg_1_0)
		end
		
		if arg_1_0.state == 0 and arg_1_0.btn_move and arg_1_0.give_code == nil then
			Dialog:close("chapter_shop_change")
			
			local var_1_1 = WorldMapManager:getNavigator()
			
			if var_1_1.isOpen then
				var_1_1:backNavi()
			end
		end
		
		return 
	end
	
	if arg_1_1 == "btn_move" then
		TutorialGuide:procGuide("tuto_merc_shop2")
		ShopChapterUtil:getShopChatperObj(true):onBtnMove()
		Dialog:close("chapter_shop_change")
		
		local var_1_2 = WorldMapManager:getNavigator()
		
		if var_1_2 then
			var_1_2:backNavi()
		end
		
		return 
	end
end

ShopChapterPopup = ShopChapterPopup or {}

copy_functions(ShopChapter, ShopChapterPopup)

function ShopChapterPopup.show(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	arg_2_1 = arg_2_1 or SceneManager:getRunningPopupScene()
	arg_2_0.vars.wnd = Dialog:open("wnd/chapter_shop_change", arg_2_0)
	
	arg_2_1:addChild(arg_2_0.vars.wnd)
	
	local var_2_0 = WorldMapManager:getNavigator():getWnd()
	
	arg_2_0.vars.parents = var_2_0
	
	local var_2_1 = arg_2_0.vars.wnd:getChildByName("n_shop_items")
	
	arg_2_0.vars.scrollview = var_2_1:getChildByName("scrollview")
	
	arg_2_0:initScrollView(arg_2_0.vars.scrollview, 666, 150)
	
	local var_2_2 = WorldMapManager:getController()
	local var_2_3 = var_2_2:getMapKey()
	local var_2_4 = var_2_2:getWorldIDByMapKey()
	local var_2_5 = DB("level_world_1_world", tostring(var_2_4), "key_continent")
	
	arg_2_0.vars.key_continent = var_2_5
	arg_2_0.vars.world_id = var_2_4
	
	ShopChapterPopupChapterList:show(arg_2_0.vars.wnd, arg_2_0)
	arg_2_0:onUpdateChapter(var_2_3, true)
end

function ShopChapterPopup.onUpdateChapter(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = DB("level_world_3_chapter", arg_3_1, "shop_cp_category")
	
	arg_3_0.vars.category_id = var_3_0
	
	if not var_3_0 then
		return 
	end
	
	local var_3_1 = DBT("shop_chapter_category", arg_3_0.vars.category_id, {
		"id",
		"npc",
		"material",
		"name",
		"desc",
		"unlock_stage",
		"unlock_stage_desc",
		"unlock_quest",
		"pre_quest_story",
		"clear_quest_story",
		"condition_state",
		"core_reward1",
		"core_reward2",
		"force_id",
		"unlock_story"
	})
	
	arg_3_0.vars.category_db = var_3_1
	arg_3_0.vars.chapter_id = arg_3_1
	
	local var_3_2 = Account:getChapterShopItems(arg_3_0.vars.world_id, arg_3_0.vars.chapter_id) or {}
	
	arg_3_0.vars.list = var_3_2
	arg_3_0.vars.DB = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_2) do
		arg_3_0.vars.DB[iter_3_1.id] = iter_3_1
	end
	
	if not arg_3_2 then
		arg_3_0:loadData()
		arg_3_0:initUI(arg_3_0.vars.wnd, true)
	end
	
	arg_3_0:updateUI()
end

function ShopChapterPopup.query(arg_4_0)
	local var_4_0 = WorldMapManager:getController():getWorldIDByMapKey()
	local var_4_1 = Account:getChapterShopItemsByWorldID(var_4_0)
	
	if table.count(var_4_1) <= 0 then
		query("market_episode", {
			popup = true,
			worldmap_world_id = var_4_0
		})
	else
		ShopChapterUtil:onMsgHandler(true)
	end
end

function ShopChapterPopup.updateUI(arg_5_0)
	if not arg_5_0:isShow() then
		return 
	end
	
	local var_5_0 = Account:getItemCount(arg_5_0.vars.category_db.material)
	
	if_set(arg_5_0.vars.wnd, "count_cp", T("mission_base_cpshop_cp_value", {
		value = var_5_0
	}))
	
	if DEBUG.DEBUG_MAP_ID and arg_5_0.vars.category_db and arg_5_0.vars.category_db.material then
		if_set(arg_5_0.vars.wnd, "count_cp", arg_5_0.vars.category_db.material .. ":" .. T("mission_base_cpshop_cp_value", {
			value = var_5_0
		}))
	end
end

function ShopChapterPopup.onBtnMove(arg_6_0)
	movetoPath(arg_6_0.vars.movepath)
end

function ShopChapterPopup.setMovePath(arg_7_0, arg_7_1)
	arg_7_0.vars.movepath = arg_7_1
end

function ShopChapterPopup.getKeyContinent(arg_8_0)
	return arg_8_0.vars.key_continent
end

ShopChapterForcePopup = ShopChapterForcePopup or {}

copy_functions(ShopChapterForce, ShopChapterForcePopup)

function ShopChapterForcePopup.show(arg_9_0, arg_9_1)
	arg_9_0.vars = {}
	arg_9_1 = arg_9_1 or SceneManager:getRunningPopupScene()
	arg_9_0.vars.wnd = Dialog:open("wnd/chapter_shop_change", arg_9_0)
	
	arg_9_1:addChild(arg_9_0.vars.wnd)
	
	local var_9_0 = WorldMapManager:getNavigator():getWnd()
	
	arg_9_0.vars.parents = var_9_0
	
	local var_9_1 = arg_9_0.vars.wnd:getChildByName("n_shop_items")
	
	arg_9_0.vars.scrollview = var_9_1:getChildByName("scrollview")
	
	arg_9_0:initScrollView(arg_9_0.vars.scrollview, 666, 150)
	
	local var_9_2 = WorldMapManager:getController()
	local var_9_3 = var_9_2:getMapKey()
	local var_9_4 = var_9_2:getWorldIDByMapKey()
	local var_9_5 = DB("level_world_1_world", tostring(var_9_4), "key_continent")
	
	arg_9_0.vars.key_continent = var_9_5
	arg_9_0.vars.world_id = var_9_4
	
	ShopChapterPopupChapterList:show(arg_9_0.vars.wnd, arg_9_0)
	arg_9_0:onUpdateChapter(var_9_3, true)
end

function ShopChapterForcePopup.onUpdateChapter(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = DB("level_world_3_chapter", arg_10_1, "shop_cp_category")
	
	arg_10_0.vars.category_id = var_10_0
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = DBT("shop_chapter_category", arg_10_0.vars.category_id, {
		"id",
		"npc",
		"material",
		"name",
		"desc",
		"unlock_stage",
		"unlock_stage_desc",
		"unlock_quest",
		"pre_quest_story",
		"clear_quest_story",
		"condition_state",
		"core_reward1",
		"core_reward2",
		"force_id"
	})
	
	arg_10_0.vars.category_db = var_10_1
	arg_10_0.vars.chapter_id = arg_10_1
	
	local var_10_2 = Account:getChapterShopItems(arg_10_0.vars.world_id, arg_10_0.vars.chapter_id) or {}
	
	arg_10_0.vars.list = var_10_2
	arg_10_0.vars.DB = {}
	
	for iter_10_0, iter_10_1 in pairs(var_10_2) do
		arg_10_0.vars.DB[iter_10_1.id] = iter_10_1
	end
	
	if not arg_10_2 then
		arg_10_0:loadData()
		arg_10_0:initUI(arg_10_0.vars.wnd, true)
	end
	
	arg_10_0:updateUI()
end

function ShopChapterForcePopup.query(arg_11_0)
	local var_11_0 = WorldMapManager:getController():getWorldIDByMapKey()
	local var_11_1 = Account:getChapterShopItemsByWorldID(var_11_0)
	
	if table.count(var_11_1) <= 0 then
		query("market_episode", {
			popup = true,
			worldmap_world_id = var_11_0
		})
	else
		ShopChapterUtil:onMsgHandler(true)
	end
end

function ShopChapterForcePopup.updateUI(arg_12_0)
	if not arg_12_0:isShow() then
		return 
	end
	
	local var_12_0 = Account:getItemCount(arg_12_0.vars.category_db.material)
	
	if_set(arg_12_0.vars.wnd, "count_cp", T("mission_base_cpshop_cp_value", {
		value = var_12_0
	}))
	
	if DEBUG.DEBUG_MAP_ID and arg_12_0.vars.category_db and arg_12_0.vars.category_db.material then
		if_set(arg_12_0.vars.wnd, "count_cp", arg_12_0.vars.category_db.material .. ":" .. T("mission_base_cpshop_cp_value", {
			value = var_12_0
		}))
	end
	
	local var_12_1 = false
	local var_12_2 = EpisodeForce:getForceIDByChapterID(arg_12_0.vars.category_db.id)
	
	if var_12_2 then
		var_12_1 = EpisodeForce:isNoti(var_12_2)
	end
	
	local var_12_3 = arg_12_0.vars.wnd:getChildByName("btn_move")
	
	if_set_visible(var_12_3, "noti", var_12_1)
end

function ShopChapterForcePopup.onBtnMove(arg_13_0)
	movetoPath(arg_13_0.vars.movepath)
end

function ShopChapterForcePopup.setMovePath(arg_14_0, arg_14_1)
	arg_14_0.vars.movepath = arg_14_1
end

function ShopChapterForcePopup.getKeyContinent(arg_15_0)
	return arg_15_0.vars.key_continent
end

ShopChapterPopupChapterList = ShopChapterPopupChapterList or {}

copy_functions(ScrollView, ShopChapterPopupChapterList)

function ShopChapterPopupChapterList.show(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0.vars = {}
	arg_16_0.vars.wnd = arg_16_1
	arg_16_0.parent_func = arg_16_2
	
	arg_16_0:createChapterListView()
end

function ShopChapterPopupChapterList.createChapterListView(arg_17_0)
	arg_17_0.vars.scrollview = arg_17_0.vars.wnd:getChildByName("area_listview")
	
	arg_17_0:initScrollView(arg_17_0.vars.scrollview, 260, 70)
	
	local var_17_0 = arg_17_0.parent_func:getKeyContinent()
	local var_17_1 = WorldMapUtil:getContinentListByContinentKey(var_17_0)
	
	table.sort(var_17_1, function(arg_18_0, arg_18_1)
		return (tonumber(arg_18_0.ep_sort) or 999) < (tonumber(arg_18_1.ep_sort) or 999)
	end)
	
	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		local var_17_2 = DBT("shop_chapter_category", iter_17_1.key_normal, {
			"id",
			"material"
		})
		
		if var_17_2 and var_17_2.material then
			var_17_1[iter_17_0].material = var_17_2.material
		end
	end
	
	arg_17_0.vars.list = var_17_1
	
	arg_17_0:createScrollViewItems(var_17_1)
	
	local var_17_3 = WorldMapManager:getController():getMapKey()
	local var_17_4 = arg_17_0:getChapterScrollViewInfoByChapterId(var_17_3)
	local var_17_5 = arg_17_0:getChapterScrollViewIdxByChapterId(var_17_3)
	
	arg_17_0:onSelectScrollViewItem(var_17_5, var_17_4)
	arg_17_0:jumpToIndex(var_17_5)
end

function ShopChapterPopupChapterList.getScrollViewItem(arg_19_0, arg_19_1)
	local var_19_0 = load_dlg("chapter_area_bar", true, "wnd")
	local var_19_1 = T(arg_19_1.name)
	local var_19_2 = string.split(var_19_1, ".")
	
	if_set(var_19_0, "txt_number", var_19_2[1])
	
	local var_19_3 = var_19_0:findChildByName("txt_area")
	local var_19_4 = var_19_0:findChildByName("txt_area_cp")
	
	if_set(var_19_3, nil, string.trim(var_19_2[2]))
	set_scale_fit_width_multi_line(var_19_3, 2, 30)
	
	if var_19_3:getStringNumLines() == 2 then
		var_19_3:setPositionY(var_19_3:getPositionY() - 10)
		var_19_4:setPositionY(var_19_4:getPositionY() - 10)
	end
	
	arg_19_0:updateItem(var_19_0, arg_19_1)
	
	return var_19_0
end

function ShopChapterPopupChapterList.updateItem(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = false
	local var_20_1 = EpisodeForce:getForceIDByChapterID(arg_20_2.key_normal)
	
	if var_20_1 then
		var_20_0 = EpisodeForce:isNoti(var_20_1)
	else
		var_20_0 = ShopChapter:hasEffectNoti(arg_20_2.key_normal)
	end
	
	if_set_visible(arg_20_1, "icon_noti", var_20_0)
	
	if arg_20_2.material then
		local var_20_2 = Account:getItemCount(arg_20_2.material)
		
		if_set(arg_20_1, "txt_area_cp", T("mission_base_cpshop_cp_value", {
			value = var_20_2
		}))
	else
		if_set(arg_20_1, "txt_area_cp", T("mission_base_cpshop_cp_value", {
			value = 0
		}))
	end
end

function ShopChapterPopupChapterList.updateScrollItems(arg_21_0)
	if not arg_21_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_21_0.vars.wnd) then
		return 
	end
	
	if not arg_21_0.ScrollViewItems then
		return 
	end
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.ScrollViewItems) do
		if get_cocos_refid(iter_21_1.control) then
			arg_21_0:updateItem(iter_21_1.control, iter_21_1.item)
		end
	end
end

function ShopChapterPopupChapterList.onSelectScrollViewItem(arg_22_0, arg_22_1, arg_22_2)
	if UIAction:Find("block") then
		return 
	end
	
	if arg_22_0.vars.selected_chapter_id == arg_22_2.item.key_normal then
		return 
	end
	
	if arg_22_2.item.lock then
		Dialog:msgBox(T("mission_notyet"))
		
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if arg_22_0.vars.selected_chapter_id then
		arg_22_0:getChapterScrollViewInfoByChapterId(arg_22_0.vars.selected_chapter_id).control:getChildByName("select"):setVisible(false)
	end
	
	arg_22_2.control:getChildByName("select"):setVisible(true)
	
	arg_22_0.vars.selected_chapter_id = arg_22_2.item.key_normal
	
	local var_22_0, var_22_1 = DB("level_world_3_chapter", arg_22_0.vars.selected_chapter_id, {
		"name",
		"shop_cp_category"
	})
	
	arg_22_0.vars.category_id = var_22_1
	
	local var_22_2 = DBT("shop_chapter_category", arg_22_0.vars.category_id, {
		"id",
		"npc",
		"material",
		"name",
		"desc",
		"unlock_stage",
		"unlock_stage_desc",
		"unlock_quest",
		"pre_quest_story",
		"clear_quest_story",
		"condition_state",
		"core_reward1",
		"core_reward2",
		"force_id"
	})
	
	arg_22_0.vars.category_db = var_22_2
	
	if_set(arg_22_0.vars.wnd, "txt_title", T(var_22_0))
	arg_22_0.parent_func:setMovePath(arg_22_2.item.ep_select_path)
	arg_22_0.parent_func:onUpdateChapter(arg_22_2.item.key_normal)
end

function ShopChapterPopupChapterList.onUpdateSelectedChapter(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	if not arg_23_0.parent_func then
		return 
	end
	
	if not arg_23_0.parent_func.onUpdateChapter then
		return 
	end
	
	arg_23_0.parent_func:onUpdateChapter(arg_23_0.vars.selected_chapter_id)
end

function ShopChapterPopupChapterList.getChapterScrollViewInfoByChapterId(arg_24_0, arg_24_1)
	for iter_24_0, iter_24_1 in pairs(arg_24_0.ScrollViewItems) do
		if arg_24_1 == iter_24_1.item.key_normal then
			return iter_24_1
		end
	end
end

function ShopChapterPopupChapterList.getChapterScrollViewIdxByChapterId(arg_25_0, arg_25_1)
	for iter_25_0, iter_25_1 in pairs(arg_25_0.ScrollViewItems) do
		if arg_25_1 == iter_25_1.item.key_normal then
			return iter_25_0
		end
	end
end
