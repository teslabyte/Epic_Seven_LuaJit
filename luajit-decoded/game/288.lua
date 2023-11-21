DEBUG.SHOW_STORY_COLLECTION = nil
CollectionStoryChapterView = {}

copy_functions(ScrollView, CollectionStoryChapterView)

function CollectionStoryChapterView.getScrollViewItem(arg_1_0, arg_1_1)
	local var_1_0 = load_control("wnd/dict_story_chapter_menu.csb")
	local var_1_1 = DB("dic_ui", arg_1_1.key, "name")
	
	arg_1_0.vars.origin_color = cc.c3b(171, 135, 89)
	
	if_set_scale_fit_width_long_word(var_1_0, "chapter_title", T(var_1_1), 180)
	if_set_visible(var_1_0, "bg_select", false)
	
	local var_1_2 = CollectionUtil:isStoryUnlock(arg_1_1.data)
	
	if_set_visible(var_1_0, "icon_lock", not var_1_2)
	
	local var_1_3 = var_1_0:findChildByName("noti_parent")
	
	if get_cocos_refid(var_1_3) then
		local var_1_4 = var_1_3:findChildByName("icon_noti")
		
		if get_cocos_refid(var_1_4) then
			var_1_3:setCascadeOpacityEnabled(false)
			var_1_4:setVisible(CollectionDB:isReceivableBgPackChapter(arg_1_1.key))
		end
	end
	
	if not var_1_2 then
		if_set_opacity(var_1_0, "chapter_title", 76.5)
	end
	
	arg_1_1.isCanShow = var_1_2
	
	return var_1_0
end

function CollectionStoryChapterView.onSelectScrollViewItem(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2.control == arg_2_0.vars.last_sel then
		return 
	end
	
	if arg_2_0.vars.last_sel then
		SoundEngine:play("event:/ui/btn_small")
	end
	
	arg_2_0.vars.listener(arg_2_1, arg_2_2)
	
	local var_2_0, var_2_1 = DB("dic_ui", arg_2_2.item.key, {
		"name",
		"desc"
	})
	
	arg_2_0.vars.onChangeName(T(var_2_0), T(var_2_1))
	
	local var_2_2
	
	if arg_2_0.vars.last_sel then
		if_set_visible(arg_2_0.vars.last_sel, "bg_select", false)
		
		if not arg_2_0.vars.last_isCanShow then
			if_set_opacity(arg_2_0.vars.last_sel, "chapter_title", 76.5)
		end
		
		local var_2_3 = arg_2_0.vars.last_sel:getChildByName("chapter_title")
		
		if var_2_3 then
			var_2_3:setTextColor(arg_2_0.vars.origin_color)
		end
	end
	
	if_set_visible(arg_2_2.control, "bg_select", true)
	if_set_opacity(arg_2_2.control, "chapter_title", 255)
	
	local var_2_4 = arg_2_2.control:getChildByName("chapter_title")
	
	if var_2_4 then
		var_2_4:setTextColor(cc.c3b(255, 255, 255))
	end
	
	arg_2_0.vars.last_sel = arg_2_2.control
	arg_2_0.vars.last_isCanShow = arg_2_2.item.isCanShow
	arg_2_0.vars.last_idx = arg_2_1
end

function CollectionStoryChapterView.updateReward(arg_3_0)
	if not arg_3_0.vars or not arg_3_0.vars.last_idx then
		return 
	end
	
	local var_3_0 = arg_3_0.ScrollViewItems[arg_3_0.vars.last_idx]
	
	if not var_3_0 then
		return 
	end
	
	if_set_visible(var_3_0.control, "icon_noti", CollectionDB:isReceivableBgPackChapter(var_3_0.item.key))
end

function CollectionStoryChapterView.setToIndex(arg_4_0, arg_4_1)
	if not arg_4_0.ScrollViewItems[arg_4_1] then
		return 
	end
	
	if get_cocos_refid(arg_4_0.vars.last_sel) then
		if_set_visible(arg_4_0.vars.last_sel, "bg_select", false)
		
		if not arg_4_0.vars.last_isCanShow then
			if_set_opacity(arg_4_0.vars.last_sel, "chapter_title", 76.5)
		end
		
		local var_4_0 = arg_4_0.vars.last_sel:getChildByName("chapter_title")
		
		if var_4_0 then
			var_4_0:setTextColor(arg_4_0.vars.origin_color)
		end
	end
	
	arg_4_0.vars.last_idx = nil
	arg_4_0.vars.last_sel = nil
	
	arg_4_0:onSelectScrollViewItem(arg_4_1, arg_4_0.ScrollViewItems[arg_4_1])
end

function CollectionStoryChapterView.getIndex(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 1
	end
	
	return arg_5_0.vars.last_idx or 1
end

function CollectionStoryChapterView.setListener(arg_6_0, arg_6_1)
	arg_6_0.vars.listener = arg_6_1
end

function CollectionStoryChapterView.setOnChangeName(arg_7_0, arg_7_1)
	arg_7_0.vars.onChangeName = arg_7_1
end

function CollectionStoryChapterView.init(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.vars = {}
	arg_8_0.vars.wnd = arg_8_1
	arg_8_0.vars.onChangeName = arg_8_2
	
	arg_8_0:initScrollView(arg_8_1, 186, 62)
end

CollectionStoryList = {}

copy_functions(CollectionListBase, CollectionStoryList)

function CollectionStoryList.onItemUpdate(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars then
		return 
	end
	
	local var_9_0 = CollectionUtil:makeQuestData(arg_9_2)
	local var_9_1 = true
	local var_9_2 = 255
	
	if not CollectionUtil:isStoryUnlock(arg_9_2) then
		var_9_2 = var_9_2 * 0.3
		var_9_1 = false
		var_9_0.name = "mission_name_unlock"
		var_9_0.desc = "mission_name_desc"
		var_9_0.icon = "m0000_s"
	end
	
	if_set_opacity(arg_9_1, nil, var_9_2)
	CollectionUtil:setStoryRendererBasic(arg_9_1, var_9_0)
	if_set_visible(arg_9_1, "btn_movie", arg_9_2.movie)
	if_set_visible(arg_9_1, "btn_illust", arg_9_2.illust)
	
	local var_9_3 = arg_9_1:findChildByName("btn_illust")
	local var_9_4 = arg_9_1:findChildByName("btn_movie")
	
	if not arg_9_0.vars.illust_origin_x then
		arg_9_0.vars.illust_origin_x = var_9_3:getPositionX()
	end
	
	if not arg_9_2.movie and arg_9_2.illust then
		var_9_3:setPositionX(var_9_4:getPositionX())
	else
		var_9_3:setPositionX(arg_9_0.vars.illust_origin_x)
	end
	
	arg_9_1:getChildByName("btn_illust").data = {
		type = "illust",
		illust = arg_9_2.illust,
		isCanShow = var_9_1
	}
	arg_9_1:getChildByName("btn_movie").data = {
		movie = arg_9_2.movie,
		isCanShow = var_9_1
	}
	arg_9_1:getChildByName("btn_play_brown").data = {
		type = "story",
		id = arg_9_2.story_id,
		default_bg = arg_9_2.default_bg,
		default_bgm = arg_9_2.default_bgm,
		level_enter = arg_9_2.level_enter,
		isCanShow = var_9_1
	}
end

function CollectionStoryList.onSubStoryItemUpdate(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = SubStoryViewerUtil:checkIsActive(SubStoryViewerDB:getParentByID(arg_10_2.parent_id))
	
	SubStoryViewerUtil:onSubStoryItemUpdate(arg_10_1, arg_10_2, var_10_0)
end

function CollectionStoryList.onSelectSubStoryChapter(arg_11_0, arg_11_1)
	local var_11_0 = SubStoryViewerDB:getSubStory(arg_11_1.item.id)
	
	if not var_11_0 then
		return 
	end
	
	local var_11_1 = {}
	
	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		var_11_1[iter_11_1.sort] = iter_11_1
	end
	
	SubStoryViewerUtil:setHeroes(arg_11_0.vars.n_list_substory:findChildByName("n_hero"), arg_11_1.item, true)
	if_set(arg_11_0.vars.n_list_substory, "title_chapter", T(arg_11_1.item.name))
	if_set(arg_11_0.vars.n_list_substory, "t_story_disc", T(arg_11_1.item.desc))
	arg_11_0:setSubStoryVisible(true)
	
	arg_11_0.vars.cur_render_db = var_11_1
	
	arg_11_0.vars.substory_listView:setDataSource(var_11_1)
end

function CollectionStoryList.setLayerVisible(arg_12_0, arg_12_1, arg_12_2)
	if_set_visible(arg_12_0.vars.n_list_substory, "layer_search", arg_12_2)
	arg_12_0.vars.n_list_substory:getChildByName("input_search"):setString("")
end

function CollectionStoryList.getSearchKeyword(arg_13_0)
	if not get_cocos_refid(arg_13_0.vars.n_list_substory) then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.n_list_substory:getChildByName("input_search"):getString()
	
	return (CollectionUtil:removeRegexCharacters(var_13_0))
end

function CollectionStoryList.search(arg_14_0, arg_14_1)
	if arg_14_1 == nil or arg_14_1 == "" then
		return false
	end
	
	local var_14_0 = arg_14_0:_search(arg_14_0.vars.substory_pure_DB, arg_14_1, "dic_ui", "name", nil, true)
	local var_14_1 = SubStoryViewerDB:searchByUnitName(arg_14_1)
	local var_14_2 = {}
	local var_14_3 = {}
	
	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		table.insert(var_14_2, arg_14_0.vars.substory_pure_DB[iter_14_1])
		
		var_14_3[arg_14_0.vars.substory_pure_DB[iter_14_1].id] = true
	end
	
	for iter_14_2, iter_14_3 in pairs(var_14_1) do
		if not var_14_3[iter_14_3.id] then
			table.insert(var_14_2, iter_14_3)
			
			var_14_3[iter_14_3.id] = true
		end
	end
	
	SubStoryViewerUtil:sortDB(var_14_2)
	SubStoryViewerScrollListView:setData(var_14_2)
	SubStoryViewerScrollListView:jumpToTop()
	
	if table.count(var_14_2 or {}) == 0 then
		arg_14_0:setSubStoryVisible(false, T("ui_friends_search_none"))
	else
		arg_14_0:setSubStoryVisible(false)
	end
end

function CollectionStoryList.onSelectChapterView(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_2.substory then
		arg_15_0:onSelectSubStoryChapter(arg_15_2)
		
		return 
	end
	
	local var_15_0 = arg_15_0.vars.parent_DB[arg_15_2.item.key]
	
	if not var_15_0 then
		return 
	end
	
	local var_15_1 = {}
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		var_15_1[iter_15_1.sort] = iter_15_1
	end
	
	arg_15_0.vars.cur_render_db = var_15_1
	
	arg_15_0.vars.listView:setDataSource(var_15_1)
	arg_15_0.vars.onChangeChapter(arg_15_2.item.key, CollectionUtil:isStoryUnlock(arg_15_0.vars.cur_render_db[1]))
end

function CollectionStoryList.setSubStoryVisible(arg_16_0, arg_16_1, arg_16_2)
	if_set_visible(arg_16_0.vars.n_list_substory, nil, true)
	if_set_visible(arg_16_0.vars.n_belt_substory, nil, true)
	if_set_visible(arg_16_0.vars.n_belt_substory, "n_none", false)
	
	local var_16_0 = T("dic_substory_list_none")
	
	if arg_16_2 then
		var_16_0 = arg_16_2
	end
	
	local var_16_1 = arg_16_0.vars.n_list_substory:findChildByName("n_none")
	
	if_set(var_16_1, "label", var_16_0)
	if_set(arg_16_0.vars.n_belt_substory, "title_substory", T("dict_substory_list_title"))
	
	local var_16_2 = {
		n_none = true,
		n_cast = false,
		n_top = false,
		listview_subtory = false
	}
	
	for iter_16_0, iter_16_1 in pairs(var_16_2) do
		if_set_visible(arg_16_0.vars.n_list_substory, iter_16_0, iter_16_1 ~= arg_16_1)
	end
	
	if_set_visible(arg_16_0.vars.n_list_substory, "layer_search", false)
	
	if arg_16_1 == false then
		SubStoryViewerScrollListView:clearPrvIndex()
	end
end

function CollectionStoryList.resetSubStoryScroll(arg_17_0)
	SubStoryViewerScrollListView:reset()
end

function CollectionStoryList.onSelectScrollView(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {}
	local var_18_1 = arg_18_2 == "story7"
	local var_18_2 = {
		n_belt_substory = true,
		n_belt_chapter = false,
		n_list_story = false,
		n_list_substory = true
	}
	
	for iter_18_0, iter_18_1 in pairs(var_18_2) do
		if_set_visible(arg_18_0.vars[iter_18_0], nil, iter_18_1 == var_18_1)
	end
	
	if var_18_1 then
		arg_18_0:setSubStoryVisible(false)
		arg_18_0:resetSubStoryScroll()
		
		return 
	else
		SubStoryViewerScrollListView:clearPrvIndex()
	end
	
	for iter_18_2, iter_18_3 in pairs(arg_18_1) do
		local var_18_3 = DB("dic_ui", iter_18_2, "sort")
		local var_18_4
		
		for iter_18_4, iter_18_5 in pairs(iter_18_3) do
			local var_18_5 = CollectionUtil:isStoryUnlock(iter_18_5)
			
			if var_18_5 and not var_18_4 then
				var_18_4 = iter_18_5
			elseif var_18_5 and var_18_4 and var_18_4.sort >= iter_18_5.sort then
				var_18_4 = iter_18_5
			end
		end
		
		table.insert(var_18_0, {
			key = iter_18_2,
			data = var_18_4,
			sort = var_18_3
		})
	end
	
	table.sort(var_18_0, function(arg_19_0, arg_19_1)
		return arg_19_0.sort < arg_19_1.sort
	end)
	arg_18_0.vars.chapter_scrollView:clearScrollViewItems()
	arg_18_0.vars.chapter_scrollView:setScrollViewItems(var_18_0)
	arg_18_0.vars.chapter_scrollView:setToIndex(1)
end

function CollectionStoryList.init(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0.vars = {}
	arg_20_0.vars.pure_DB = arg_20_2
	arg_20_0.vars.parent_DB = arg_20_1
	arg_20_0.vars.story_DB = {}
	arg_20_0.vars.story_count_DB = {}
	
	arg_20_0:makeParentDB(arg_20_1, arg_20_0.vars.story_DB, arg_20_0.vars.story_count_DB, function(arg_21_0)
		return CollectionUtil:isStoryUnlock(arg_21_0)
	end)
	CollectionDB:addSubStoryToStoryDB(arg_20_0.vars.story_DB, arg_20_0.vars.story_count_DB)
	
	arg_20_0.vars.substory_pure_DB = {}
	
	for iter_20_0, iter_20_1 in pairs(SubStoryViewerDB:getParentDB()) do
		arg_20_0.vars.substory_pure_DB[iter_20_1.id] = iter_20_1
	end
end

function CollectionStoryList.close(arg_22_0)
	SubStoryViewerScrollListView:destroy()
	
	arg_22_0.vars = nil
end

function CollectionStoryList.getCurrentEpisodeData(arg_23_0)
	local var_23_0 = {}
	
	for iter_23_0 = 1, #arg_23_0.vars.cur_render_db do
		if CollectionUtil:isStoryUnlock(arg_23_0.vars.cur_render_db[iter_23_0]) then
			table.insert(var_23_0, arg_23_0.vars.cur_render_db[iter_23_0])
		end
	end
	
	return var_23_0
end

function CollectionStoryList.subStoryInit(arg_24_0, arg_24_1)
	arg_24_0.vars.substory_scrollView = arg_24_1.substory_scrollView
	
	function arg_24_1.select_callback(arg_25_0, arg_25_1)
		arg_24_0:onSelectChapterView(arg_25_1, {
			substory = true,
			item = arg_25_0
		})
	end
	
	SubStoryViewerScrollListView:create(nil, 208, 116, "dict_substory_list_item", arg_24_0.vars.substory_scrollView, arg_24_1)
	
	local var_24_0 = arg_24_0.vars.n_list_substory:findChildByName("listview_subtory")
	
	arg_24_0.vars.substory_listView = ItemListView_v2:bindControl(var_24_0)
	
	local var_24_1 = load_control("wnd/dict_substory_bar.csb")
	local var_24_2 = {
		onUpdate = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
			arg_24_0:onSubStoryItemUpdate(arg_26_1, arg_26_3)
		end
	}
	
	if var_24_0.STRETCH_INFO then
		local var_24_3 = var_24_0:getContentSize()
		
		resetControlPosAndSize(var_24_1, var_24_3.width, var_24_0.STRETCH_INFO.width_prev)
	end
	
	arg_24_0.vars.substory_listView:setRenderer(var_24_1, var_24_2)
	arg_24_0.vars.substory_listView:removeAllChildren()
	arg_24_0.vars.substory_listView:setListViewCascadeEnabled(true)
end

function CollectionStoryList.open(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_0.vars.listView = ItemListView_v2:bindControl(arg_27_1)
	
	local var_27_0 = load_control("wnd/dict_story_bar.csb")
	local var_27_1 = {
		onUpdate = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			arg_27_0:onItemUpdate(arg_28_1, arg_28_3)
		end
	}
	
	if arg_27_1.STRETCH_INFO then
		local var_27_2 = arg_27_1:getContentSize()
		
		resetControlPosAndSize(var_27_0, var_27_2.width, arg_27_1.STRETCH_INFO.width_prev)
	end
	
	arg_27_0.vars.listView:setRenderer(var_27_0, var_27_1)
	arg_27_0.vars.listView:removeAllChildren()
	arg_27_0.vars.listView:setListViewCascadeEnabled(true)
	
	arg_27_0.vars.scrollview = arg_27_2
	arg_27_0.vars.chapter_scrollView = arg_27_3.chapter_scrollView
	
	arg_27_0.vars.chapter_scrollView:setListener(function(arg_29_0, arg_29_1)
		arg_27_0:onSelectChapterView(arg_29_0, arg_29_1)
	end)
	
	arg_27_0.vars.n_belt_substory = arg_27_3.n_belt_substory
	arg_27_0.vars.n_belt_chapter = arg_27_3.n_belt_chapter
	arg_27_0.vars.n_list_substory = arg_27_3.n_list_substory
	arg_27_0.vars.n_list_story = arg_27_3.n_list_story
	
	arg_27_0:subStoryInit(arg_27_3)
	
	arg_27_0.vars.onChangeChapter = arg_27_3.onChangeChapter
	arg_27_0.vars.db_type = "ch"
	
	arg_27_0:_scrollViewInit(arg_27_2, arg_27_0.vars.story_DB, arg_27_0.vars.story_count_DB, function(arg_30_0, arg_30_1)
		return arg_27_0:onSelectScrollView(arg_27_0.vars.story_DB[arg_30_1.item.id], arg_30_1.item.id)
	end, arg_27_3)
	
	if arg_27_3.parent_id == "story7" and arg_27_3.select_item then
		SubStoryViewerScrollListView:reset()
		SubStoryViewerScrollListView:selectItemById(arg_27_3.select_item.id)
		SubStoryViewerScrollListView:scrollToItem(arg_27_3.select_item.id)
	end
end

CollectionStoryDetail = {}

function CollectionStoryDetail.layerSetting(arg_31_0)
	local var_31_0 = #arg_31_0.vars.resource_list
	local var_31_1 = arg_31_0.vars.resource_list[var_31_0]
	
	if not var_31_1.bg then
		return 
	end
	
	if arg_31_0.vars.prv_bg_name == var_31_1.bg then
		return 
	end
	
	local var_31_2, var_31_3 = FIELD_NEW:create(var_31_1.bg)
	
	var_31_3:setViewPortPosition(DESIGN_WIDTH * 0.5)
	var_31_3:updateViewport()
	
	if get_cocos_refid(arg_31_0.vars.parent) then
		arg_31_0.vars.parent:addChild(var_31_2)
	else
		SceneManager:getRunningPopupScene():addChild(var_31_2)
	end
	
	arg_31_0.vars.prv_bg = var_31_2
	arg_31_0.vars.prv_bg_name = var_31_1.bg
end

function CollectionStoryDetail.anotherBGMPlayed(arg_32_0)
	arg_32_0.vars.prv_bgm_name = nil
end

function CollectionStoryDetail.onMute(arg_33_0)
	arg_33_0.vars.prv_bgm_name = nil
end

function CollectionStoryDetail.bgmSetting(arg_34_0)
	local var_34_0 = #arg_34_0.vars.resource_list
	local var_34_1 = arg_34_0.vars.resource_list[var_34_0]
	
	if not var_34_1.bgm then
		return 
	end
	
	if arg_34_0.vars.prv_bgm_name == var_34_1.bgm then
		return 
	end
	
	if STORY.story then
		local var_34_2 = STORY.index
		local var_34_3 = STORY.story
		
		for iter_34_0, iter_34_1 in pairs(var_34_3[var_34_2] or {}) do
			if iter_34_1.movie ~= "" and iter_34_1.movie ~= nil then
				return 
			end
		end
	end
	
	SoundEngine:playBGMWithFadeInOut("event:/bgm/" .. var_34_1.bgm, 500, true)
	
	arg_34_0.vars.prv_bgm_name = var_34_1.bgm
end

function CollectionStoryDetail.isContinueBGM(arg_35_0)
	if not arg_35_0.vars.prv_bgm_name or arg_35_0.vars.prv_bgm_name == "" then
		return false
	end
	
	local var_35_0 = #arg_35_0.vars.resource_list
	
	if var_35_0 > 0 and arg_35_0.vars.prv_bgm_name == arg_35_0.vars.resource_list[var_35_0].bgm then
		return true
	else
		arg_35_0.vars.prv_bgm_name = nil
	end
	
	return false
end

function CollectionStoryDetail.fade_out(arg_36_0)
	local var_36_0 = #arg_36_0.vars.resource_list
	
	if not arg_36_0.vars.resource_list[var_36_0].fade_out then
		return 
	end
	
	if UIAction:Find("curtain") then
		return 
	end
	
	local var_36_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	local var_36_2 = SceneManager:getDefaultLayer()
	
	var_36_1:setOpacity(255)
	var_36_1:setPosition(VIEW_BASE_LEFT, 0)
	var_36_1:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_36_2:addChild(var_36_1)
	UIAction:Add(SEQ(FADE_OUT(400), REMOVE()), var_36_1, "curtain")
end

function CollectionStoryDetail.resourceDelete(arg_37_0)
	if get_cocos_refid(arg_37_0.vars.prv_bg) then
		arg_37_0.vars.prv_bg:removeFromParent()
		
		arg_37_0.vars.prv_bg_name = nil
	end
	
	table.remove(arg_37_0.vars.resource_list)
end

function CollectionStoryDetail._play_list(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	arg_38_0.vars = {}
	arg_38_0.vars.resource_list = {}
	arg_38_0.vars.parent = arg_38_2
	
	local var_38_0 = arg_38_4 or {}
	
	StoryLogger:destroyWithViewer()
	
	local function var_38_1()
		arg_38_0:layerSetting()
	end
	
	local function var_38_2()
		arg_38_0:fade_out()
		arg_38_0:resourceDelete()
	end
	
	local function var_38_3(arg_41_0)
		if arg_41_0 then
			arg_38_0:onMute()
		else
			arg_38_0:bgmSetting()
		end
	end
	
	local function var_38_4()
	end
	
	local function var_38_5()
		return arg_38_0:isContinueBGM()
	end
	
	for iter_38_0 = #arg_38_1, 1, -1 do
		table.insert(arg_38_0.vars.resource_list, {
			bg = arg_38_1[iter_38_0].default_bg,
			bgm = arg_38_1[iter_38_0].default_bgm,
			fade_out = arg_38_1[iter_38_0].fade_out
		})
	end
	
	if DB("story_action_main", arg_38_1[1].story_id, {
		"id"
	}) then
		play_story(arg_38_1[1].story_id, {
			play_on_collection = true,
			force = true,
			layer = arg_38_2,
			on_bg_empty = var_38_1,
			on_bgm_empty = var_38_3,
			on_clear = var_38_2,
			isBGMContinue = var_38_5,
			on_bgm_played = var_38_4,
			skip_chosen_opacity = var_38_0.skip_chosen_opacity
		})
		attach_story_finished_callback(function()
			arg_38_3()
			CollectionStoryDetail:close()
		end, true)
		
		for iter_38_1 = #arg_38_1, 2, -1 do
			play_story(arg_38_1[iter_38_1].story_id, {
				do_not_play = true,
				play_on_collection = true,
				force = true,
				layer = arg_38_2,
				on_bg_empty = var_38_1,
				on_bgm_empty = var_38_3,
				on_clear = var_38_2,
				isBGMContinue = var_38_5,
				on_bgm_played = var_38_4,
				skip_chosen_opacity = var_38_0.skip_chosen_opacity
			})
		end
	else
		play_story(arg_38_1[1].story_id, {
			play_on_collection = true,
			force = true,
			layer = arg_38_2,
			on_bg_empty = var_38_1,
			on_bgm_empty = var_38_3,
			on_clear = var_38_2,
			isBGMContinue = var_38_5,
			on_bgm_played = var_38_4,
			skip_chosen_opacity = var_38_0.skip_chosen_opacity
		})
		attach_story_finished_callback(function()
			arg_38_3()
			CollectionStoryDetail:close()
		end)
		
		for iter_38_2 = #arg_38_1, 2, -1 do
			play_story(arg_38_1[iter_38_2].story_id, {
				play_on_collection = true,
				force = true,
				layer = arg_38_2,
				on_bg_empty = var_38_1,
				on_bgm_empty = var_38_3,
				on_clear = var_38_2,
				isBGMContinue = var_38_5,
				on_bgm_played = var_38_4,
				skip_chosen_opacity = var_38_0.skip_chosen_opacity
			})
		end
	end
end

function CollectionStoryDetail.play_all(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	arg_46_2.type = nil
	
	local var_46_0 = {}
	
	for iter_46_0, iter_46_1 in pairs(arg_46_2) do
		local var_46_1 = string.split(iter_46_1.story_id, ",")
		
		for iter_46_2, iter_46_3 in pairs(var_46_1) do
			table.push(var_46_0, {
				story_id = iter_46_3,
				default_bg = iter_46_1.default_bg,
				default_bgm = iter_46_1.default_bgm
			})
		end
		
		var_46_0[#var_46_0].fade_out = true
	end
	
	if #var_46_0 == 0 then
		return 
	end
	
	arg_46_0:_play_list(var_46_0, arg_46_1, arg_46_3, arg_46_4)
end

function CollectionStoryDetail.onCloseBattleReadyDialog(arg_47_0, arg_47_1)
	CollectionMainUI:closeDetail("ignore", {
		no_delay = true
	})
end

function CollectionStoryDetail.onStartBattle(arg_48_0, arg_48_1)
	if Account:getCurrentTeam()[1] == nil and Account:getCurrentTeam()[2] == nil and Account:getCurrentTeam()[3] == nil and Account:getCurrentTeam()[4] == nil and not arg_48_1.npcteam_id then
		message(T("ui_need_hero"))
		
		return 
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_48_1.enter_id)
	SceneManager:cancelReseveResetSceneFlow()
	startBattle(arg_48_1.enter_id, arg_48_1)
	BattleReady:hide()
end

function CollectionStoryDetail.isMovieStory(arg_49_0, arg_49_1)
	local var_49_0 = DB("story_main_script_1", arg_49_1, "info") or DB("story_sub_script_1", arg_49_1, "info") or DB("story_etc_script_1", arg_49_1, "info")
	
	if not var_49_0 and not PRODUCTION_MODE then
		var_49_0 = DB("story_dev_script_1", arg_49_1, "info")
	end
	
	if not var_49_0 then
		return nil
	end
	
	local var_49_1 = json.decode(var_49_0)
	local var_49_2 = getUserLanguage()
	
	for iter_49_0, iter_49_1 in pairs(var_49_1) do
		if iter_49_1.sub_id then
			local var_49_3 = DB("story", "@" .. iter_49_1.sub_id, "text")
			
			if var_49_3 then
				iter_49_1.text = var_49_3
			end
			
			if false then
			end
			
			if var_49_2 ~= "ko" then
				iter_49_1.text = iter_49_1["text_" .. var_49_2]
			end
		end
		
		if iter_49_1.text == "" then
			iter_49_1.text = nil
		end
		
		if iter_49_1.movie and iter_49_1.movie ~= "" or iter_49_1.choice_flag and iter_49_1.choice_flag ~= "" then
			iter_49_1.text = iter_49_1.text or ""
		end
	end
	
	local var_49_4
	
	for iter_49_2, iter_49_3 in pairs(var_49_1) do
		if iter_49_3.movie then
			var_49_4 = var_49_4 or {}
			
			table.push(var_49_4, iter_49_3.movie)
		end
	end
	
	return var_49_4
end

function CollectionStoryDetail.play(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	if not arg_50_2.isCanShow then
		if arg_50_2.unlock_msg then
			balloon_message_with_sound(arg_50_2.unlock_msg)
		else
			balloon_message_with_sound("ui_dict_story_yet")
		end
		
		return 
	end
	
	if arg_50_2.level_enter then
		BattleReady:show({
			enter_id = arg_50_2.level_enter,
			callback = CollectionStoryDetail
		})
		
		return 
	end
	
	local var_50_0 = {}
	local var_50_1 = string.split(arg_50_2.id, ",")
	local var_50_2 = {}
	
	for iter_50_0 = 1, #var_50_1 do
		table.insert(var_50_0, {
			story_id = var_50_1[iter_50_0],
			default_bg = arg_50_2.default_bg,
			default_bgm = arg_50_2.default_bgm
		})
		
		local var_50_3 = arg_50_0:isMovieStory(var_50_1[iter_50_0])
		
		if var_50_3 then
			for iter_50_1, iter_50_2 in pairs(var_50_3) do
				table.push(var_50_2, iter_50_2)
			end
		end
	end
	
	if #var_50_1 == 0 then
		return 
	end
	
	local var_50_4 = false
	
	if table.count(var_50_2) > 0 then
		for iter_50_3, iter_50_4 in pairs(var_50_2) do
			download_file("cinema/" .. iter_50_4)
		end
	end
	
	CollectionStoryDetail:_play_list(var_50_0, arg_50_1, arg_50_3, arg_50_4)
end

function CollectionStoryDetail.proc_next(arg_51_0)
	if not arg_51_0.vars then
		return 
	end
	
	table.remove(arg_51_0.vars.movie_stack, 1)
	
	if #arg_51_0.vars.movie_stack > 0 then
		SceneManager:getCurrentScene():addNextMovie("cinema/" .. arg_51_0.vars.movie_stack[1])
	else
		SceneManager:popScene()
		CollectionStoryDetail:close()
	end
end

function CollectionStoryDetail.play_movie(arg_52_0, arg_52_1)
	if not arg_52_1.isCanShow then
		balloon_message_with_sound("ui_dict_story_yet")
		
		return 
	end
	
	local var_52_0 = string.split(arg_52_1.movie, ",")
	
	arg_52_0.vars = {}
	arg_52_0.vars.movie_stack = var_52_0
	
	local var_52_1 = #arg_52_0.vars.movie_stack > 0 and arg_52_0.vars.movie_stack[1] or ""
	local var_52_2 = getUserLanguage()
	local var_52_3 = getenv("media.quality")
	local var_52_4 = var_52_1
	
	if var_52_2 == "zht" then
		if var_52_1 == "event_01.mp4" then
			var_52_4 = var_52_2 .. "/" .. var_52_3 .. "/" .. var_52_1
		elseif var_52_1 == "event_03.mp4" then
			var_52_4 = getenv("cdn.url") .. "/webpubs/res/cinema/zht/" .. var_52_3 .. "/" .. var_52_1
		end
		
		print("changing zht movie file name", var_52_1, "to", var_52_4)
	end
	
	if not string.starts(var_52_4, "http://") and not string.starts(var_52_4, "https://") then
		var_52_4 = "cinema/" .. var_52_4
	end
	
	SceneManager:cancelReseveResetSceneFlow()
	SceneManager:nextScene("cinema", {
		path = var_52_4,
		callback = function()
			CollectionStoryDetail:proc_next()
			BackButtonManager:push({
				back_func = function()
					SceneManager:popScene()
				end
			})
		end
	})
end

function CollectionStoryDetail.close(arg_55_0)
	arg_55_0.vars = nil
	
	StoryLogger:destroyWithViewer()
end
