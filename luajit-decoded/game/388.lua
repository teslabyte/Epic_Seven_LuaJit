SubStoryViewerScroll = {}

copy_functions(ScrollView, SubStoryViewerScroll)

function substory_viewer_scroll_update_control(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = SubStoryViewerUtil:checkIsActive(arg_1_1)
	local var_1_1 = SubStoryViewerUtil:isMain(arg_1_1, arg_1_3)
	
	if_set_visible(arg_1_0, "select", false)
	
	local var_1_2 = arg_1_0:getChildByName("n_story_banner")
	local var_1_3 = DB("substory_main", arg_1_1.id, "icon_enter")
	local var_1_4, var_1_5 = DB("substory_bg", var_1_3, {
		"logo_position",
		"logo"
	})
	
	var_1_4 = var_1_4 and totable(var_1_4)
	var_1_5 = var_1_5 and totable(var_1_5)
	
	local var_1_6
	
	if not get_cocos_refid(var_1_2:getChildByName("story_banner")) then
		var_1_6 = SubstoryUIUtil:createBanner(arg_1_1.icon, var_1_5.img, var_1_4)
		
		var_1_6:setAnchorPoint(0.5, 0.5)
		if_set_visible(arg_1_0, "img", false)
		var_1_2:addChild(var_1_6)
		var_1_6:setName("story_banner")
	else
		var_1_6 = var_1_2:getChildByName("story_banner")
	end
	
	local var_1_7 = var_1_1 and "hero_detail_story_banner_main" or "hero_detail_story_banner_sub"
	
	if_set(arg_1_0, "disc", T(var_1_7))
	if_set_visible(arg_1_0, "icon_locked", not var_1_0)
	if_set_visible(arg_1_0, "t_locked", not var_1_0)
	if_set_visible(arg_1_0, "t_count", false)
	if_set_visible(arg_1_0, "btn", false)
	if_set_visible(arg_1_0, "img_noti", false)
	
	if not var_1_0 then
		if_set_color(arg_1_0, "n_banner", cc.c3b(80, 80, 80))
	end
	
	if string.find(arg_1_2, "dict_substory_list_item") or string.find(arg_1_2, "hero_detail_substory_item") then
		var_1_6:getChildByName("panel_clipping"):setTouchEnabled(false)
	end
end

function SubStoryViewerScroll.create(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	SubStoryViewerDB:create()
	
	local var_2_0
	
	if arg_2_1 == nil then
		var_2_0 = SubStoryViewerDB:getParentDB()
	else
		var_2_0 = SubStoryViewerDB:getCharacterSubStories(arg_2_1)
	end
	
	if not var_2_0 or not (table.count(var_2_0) > 0) then
		return 
	end
	
	arg_2_6 = arg_2_6 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.select_callback = arg_2_6.select_callback
	arg_2_0.vars.code = arg_2_1
	arg_2_0.vars.scrollView = arg_2_5
	arg_2_0.vars.item_csb_name = "wnd/" .. arg_2_4 .. ".csb"
	arg_2_0.vars.origin_db = table.shallow_clone(var_2_0)
	arg_2_0.vars.db = arg_2_0.vars.origin_db
	
	SubStoryViewerUtil:sortDB(arg_2_0.vars.db, arg_2_1)
	arg_2_0:initScrollView(arg_2_0.vars.scrollView, arg_2_2, arg_2_3)
	arg_2_0:createScrollViewItems(arg_2_0.vars.db)
	
	if arg_2_1 ~= nil then
		arg_2_0:selectItem(1)
	end
end

function SubStoryViewerScroll.setData(arg_3_0, arg_3_1)
	local var_3_0
	
	if arg_3_0.vars.prv_idx then
		var_3_0 = arg_3_0.vars.db[arg_3_0.vars.prv_idx]
	end
	
	arg_3_0:createScrollViewItems(arg_3_1)
	
	arg_3_0.vars.db = arg_3_1
	
	if var_3_0 then
		local var_3_1
		
		for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.db) do
			if iter_3_1.id == var_3_0.id then
				var_3_1 = iter_3_0
				
				break
			end
		end
		
		if var_3_1 then
			arg_3_0.vars.prv_idx = nil
			
			arg_3_0:selectItem(var_3_1)
			
			return 
		end
	end
	
	arg_3_0.vars.prv_idx = nil
end

function SubStoryViewerScroll.updateItems(arg_4_0)
	if not arg_4_0.vars.origin_db then
		return 
	end
	
	arg_4_0:setData(arg_4_0.vars.origin_db)
end

function SubStoryViewerScroll.reset(arg_5_0)
	arg_5_0:createScrollViewItems(arg_5_0.vars.origin_db)
	
	arg_5_0.vars.db = arg_5_0.vars.origin_db
end

function SubStoryViewerScroll.getScrollViewItem(arg_6_0, arg_6_1)
	local var_6_0 = load_control(arg_6_0.vars.item_csb_name)
	
	substory_viewer_scroll_update_control(var_6_0, arg_6_1, arg_6_0.vars.item_csb_name, arg_6_0.vars.code)
	
	return var_6_0
end

function SubStoryViewerScroll.findItemIdx(arg_7_0, arg_7_1)
	local var_7_0
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.db) do
		if iter_7_1.id == arg_7_1 then
			var_7_0 = iter_7_0
			
			break
		end
	end
	
	return var_7_0
end

function SubStoryViewerScroll.selectItemById(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0:findItemIdx(arg_8_1)
	
	if not var_8_0 then
		return 
	end
	
	arg_8_0:selectItem(var_8_0)
end

function SubStoryViewerScroll.selectItem(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.vars.db[arg_9_1]
	
	if arg_9_0.vars.prv_idx == arg_9_1 then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.ScrollViewItems) do
		if var_9_0.id == iter_9_1.item.id then
			if_set_visible(iter_9_1.control, "select", true)
		else
			if_set_visible(iter_9_1.control, "select", false)
		end
	end
	
	if arg_9_0.vars.select_callback then
		arg_9_0.vars.select_callback(arg_9_0.vars.db[arg_9_1], arg_9_1)
	end
	
	arg_9_0.vars.prv_idx = arg_9_1
end

function SubStoryViewerScroll.clearPrvIndex(arg_10_0)
	if not arg_10_0.vars or not arg_10_0.vars.prv_idx then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.db[arg_10_0.vars.prv_idx]
	
	if not var_10_0 then
		return 
	end
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.ScrollViewItems or {}) do
		if var_10_0.id == iter_10_1.item.id then
			if_set_visible(iter_10_1.control, "select", false)
			
			break
		end
	end
	
	arg_10_0.vars.prv_idx = nil
end

function SubStoryViewerScroll.scrollToItem(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0:findItemIdx(arg_11_1)
	
	if not var_11_0 then
		return 
	end
	
	arg_11_0:scrollToIndex(var_11_0)
end

function SubStoryViewerScroll.onSelectScrollViewItem(arg_12_0, arg_12_1)
	arg_12_0:selectItem(arg_12_1)
end

function SubStoryViewerScroll.destroy(arg_13_0)
	arg_13_0.vars = nil
end

SubStoryViewerScrollListView = {}

function SubStoryViewerScrollListView.create(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
	SubStoryViewerDB:create()
	
	local var_14_0
	
	if arg_14_1 == nil then
		var_14_0 = SubStoryViewerDB:getParentDB()
	else
		var_14_0 = SubStoryViewerDB:getCharacterSubStories(arg_14_1)
	end
	
	if not var_14_0 or not (table.count(var_14_0) > 0) then
		return 
	end
	
	arg_14_6 = arg_14_6 or {}
	arg_14_0.vars = {}
	arg_14_0.vars.select_callback = arg_14_6.select_callback
	arg_14_0.vars.code = arg_14_1
	arg_14_0.vars.item_csb_name = "wnd/" .. arg_14_4 .. ".csb"
	arg_14_0.vars.origin_db = table.shallow_clone(var_14_0)
	arg_14_0.vars.db = arg_14_0.vars.origin_db
	
	SubStoryViewerUtil:sortDB(arg_14_0.vars.db, arg_14_1)
	
	arg_14_0.vars.listview = ItemListView_v2:bindControl(arg_14_5)
	
	local var_14_1 = {
		onTouchUp = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
			if arg_15_4.cancelled then
				return 
			end
		end,
		onTouchDown = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
			arg_14_0:selectItem(arg_16_2, arg_16_3)
		end,
		onUpdate = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
			arg_14_0:updateListViewItem(arg_17_1, arg_17_3)
		end
	}
	local var_14_2 = load_control(arg_14_0.vars.item_csb_name)
	
	if arg_14_0.vars.listview.STRETCH_INFO then
		local var_14_3 = arg_14_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_14_2, var_14_3.width, arg_14_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	if_set_visible(var_14_2, "dim", false)
	if_set_visible(var_14_2, "selected", false)
	arg_14_0.vars.listview:setRenderer(var_14_2, var_14_1)
end

function SubStoryViewerScrollListView.setData(arg_18_0, arg_18_1)
	local var_18_0
	
	if arg_18_0.vars.prv_idx then
		var_18_0 = arg_18_0.vars.db[arg_18_0.vars.prv_idx]
	end
	
	arg_18_0.vars.listview:removeAllChildren()
	arg_18_0.vars.listview:setDataSource(arg_18_1)
	
	arg_18_0.vars.db = arg_18_1
	
	if var_18_0 then
		local var_18_1
		
		for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.db) do
			if iter_18_1.id == var_18_0.id then
				var_18_1 = iter_18_0
				
				break
			end
		end
		
		if var_18_1 then
			arg_18_0.vars.prv_idx = nil
			
			arg_18_0:selectItem(var_18_1)
			
			return 
		end
	end
	
	arg_18_0.vars.prv_idx = nil
end

function SubStoryViewerScrollListView.reset(arg_19_0)
	arg_19_0.vars.listview:removeAllChildren()
	arg_19_0.vars.listview:setDataSource(arg_19_0.vars.origin_db)
	
	arg_19_0.vars.db = arg_19_0.vars.origin_db
end

function SubStoryViewerScrollListView.updateListViewItem(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0.vars then
		return 
	end
	
	substory_viewer_scroll_update_control(arg_20_1, arg_20_2, arg_20_0.vars.item_csb_name, arg_20_0.vars.code)
	
	if arg_20_0.vars then
		if arg_20_0.vars.selected_item and arg_20_0.vars.selected_item.id == arg_20_2.id then
			if_set_visible(arg_20_1, "select", true)
		else
			if_set_visible(arg_20_1, "select", false)
		end
	end
	
	arg_20_1.id = arg_20_2.id
	arg_20_1.data = arg_20_2
end

function SubStoryViewerScrollListView.getSelectedItem(arg_21_0, arg_21_1)
	if not arg_21_0.vars then
		return 
	end
	
	return arg_21_0.vars.selected_item
end

function SubStoryViewerScrollListView.findItemIdx(arg_22_0, arg_22_1)
	local var_22_0
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.db) do
		if iter_22_1.id == arg_22_1 then
			var_22_0 = iter_22_0
			
			break
		end
	end
	
	return var_22_0
end

function SubStoryViewerScrollListView.selectItemById(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:findItemIdx(arg_23_1)
	
	if not var_23_0 then
		return 
	end
	
	arg_23_0:selectItem(var_23_0)
end

function SubStoryViewerScrollListView.selectItem(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.vars.db[arg_24_1]
	
	if arg_24_0.vars.prv_idx == arg_24_1 then
		return 
	end
	
	local var_24_1 = arg_24_0.vars.db[arg_24_0.vars.prv_idx] or {}
	
	arg_24_0.vars.selected_item = var_24_0
	
	arg_24_0.vars.listview:enumControls(function(arg_25_0)
		if arg_25_0.id == var_24_0.id or arg_25_0.id == var_24_1.id then
			arg_24_0:updateListViewItem(arg_25_0, arg_25_0.data)
		end
	end)
	
	if arg_24_0.vars.select_callback then
		arg_24_0.vars.select_callback(arg_24_0.vars.db[arg_24_1], arg_24_1)
	end
	
	arg_24_0.vars.prv_idx = arg_24_1
end

function SubStoryViewerScrollListView.clearPrvIndex(arg_26_0)
	if not arg_26_0.vars or not arg_26_0.vars.prv_idx then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.db[arg_26_0.vars.prv_idx]
	
	if not var_26_0 then
		return 
	end
	
	arg_26_0.vars.selected_item = nil
	
	arg_26_0.vars.listview:enumControls(function(arg_27_0)
		if arg_27_0.id == var_26_0.id then
			arg_26_0:updateListViewItem(arg_27_0, arg_27_0.data)
		end
	end)
	
	arg_26_0.vars.prv_idx = nil
end

function SubStoryViewerScrollListView.scrollToItem(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0:findItemIdx(arg_28_1)
	
	if not var_28_0 then
		return 
	end
	
	arg_28_0.vars.listview:forceDoLayout()
	arg_28_0.vars.listview:jumpToIndex(var_28_0)
end

function SubStoryViewerScrollListView.onSelectScrollViewItem(arg_29_0, arg_29_1)
	arg_29_0:selectItem(arg_29_1)
end

function SubStoryViewerScrollListView.destroy(arg_30_0)
	arg_30_0.vars = nil
end

function SubStoryViewerScrollListView.jumpToTop(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.listview) then
		return 
	end
	
	arg_31_0.vars.listview:jumpToTop()
end
