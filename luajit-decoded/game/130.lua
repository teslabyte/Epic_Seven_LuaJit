SubstoryEpisodeScrollView = {}

copy_functions(ScrollView, SubstoryEpisodeScrollView)

function SubstoryEpisodeScrollView.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.parent = arg_1_1
	
	arg_1_0:initScrollView(arg_1_0.vars.parent:getChildByName("scrollview_category"), 290, 101, {
		fit_height = true
	})
end

function SubstoryEpisodeScrollView.setEpisodeScrollViewItems(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.vars or table.empty(arg_2_1) then
		return 
	end
	
	if arg_2_2 and type(arg_2_2) == "function" then
		arg_2_0.vars.call_back = arg_2_2
	end
	
	local var_2_0 = {}
	
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		local var_2_1 = {}
		local var_2_2 = string.match(iter_2_0, "%d+")
		
		var_2_1.title = iter_2_0
		var_2_1.text = "ui_systemsubstory_episode_info"
		var_2_1.icon = "img/main_hud_btn_adventure.png"
		var_2_1.sort = var_2_2
		var_2_1.bind_count = table.count(iter_2_1)
		
		local var_2_3 = 0
		
		for iter_2_2 = 1, #iter_2_1 do
			local var_2_4 = iter_2_1[iter_2_2].id
			
			if Account:isMapCleared(iter_2_1[iter_2_2].unlock_stage) then
				var_2_3 = var_2_3 + 1
			end
			
			var_2_1.exist_new = false
			
			local var_2_5 = Account:getSystemSubstory()
			local var_2_6 = not SubstorySystemStory:isSubstoryCleared(var_2_4) and (table.empty(var_2_5) or var_2_5.substory_id ~= var_2_4)
			
			if iter_2_1[iter_2_2].new == "y" and var_2_6 then
				var_2_1.exist_new = true
				var_2_1.new_icon = "img/shop_icon_new.png"
			end
		end
		
		var_2_1.unlock_count = var_2_3
		
		table.insert(var_2_0, var_2_1)
	end
	
	if table.count(var_2_0) >= 2 then
		table.sort(var_2_0, function(arg_3_0, arg_3_1)
			return arg_3_0.sort < arg_3_1.sort
		end)
	end
	
	arg_2_0:clearScrollViewItems()
	arg_2_0:setScrollViewItems(var_2_0)
end

function SubstoryEpisodeScrollView.getScrollViewItem(arg_4_0, arg_4_1)
	local var_4_0 = load_control("wnd/dict_bar.csb")
	
	if_set(var_4_0, "title", T(arg_4_1.text, {
		num = arg_4_1.sort
	}))
	if_set(var_4_0, "txt_exp", arg_4_1.unlock_count .. "/" .. arg_4_1.bind_count)
	if_set_sprite(var_4_0, "icon", arg_4_1.icon)
	
	if arg_4_1.exist_new and arg_4_1.new_icon then
		local var_4_1 = cc.Sprite:create()
		
		SpriteCache:resetSprite(var_4_1, arg_4_1.new_icon)
		
		local var_4_2 = var_4_0:getChildByName("n_badge")
		
		var_4_2:setVisible(arg_4_1.exist_new)
		var_4_2:addChild(var_4_1)
	end
	
	if_set_visible(var_4_0, "bg", false)
	
	return var_4_0
end

function SubstoryEpisodeScrollView.getScrollViewItems(arg_5_0)
	if not arg_5_0.ScrollViewItems or table.empty(arg_5_0.ScrollViewItems) then
		return {}
	end
	
	return arg_5_0.ScrollViewItems
end

function SubstoryEpisodeScrollView.onSelectScrollViewItem(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.vars.last_item == arg_6_2.control then
		return 
	end
	
	if arg_6_0.vars.call_back then
		arg_6_0.vars.call_back(arg_6_2.item.title, false)
	end
	
	if_set_visible(arg_6_2.control, "bg", true)
	
	if arg_6_0.vars.last_item and get_cocos_refid(arg_6_0.vars.last_item) then
		if_set_visible(arg_6_0.vars.last_item, "bg", false)
	end
	
	arg_6_0.vars.last_item = arg_6_2.control
end

function SubstoryEpisodeScrollView.reset(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_0:clearScrollViewItems()
	
	arg_7_0.vars = {}
end

SubstorySystemStoryListView = {}

local function var_0_0(arg_8_0)
	if not arg_8_0 or not get_cocos_refid(arg_8_0) then
		return nil
	end
	
	local var_8_0 = arg_8_0:getChildByName("n_story_banner")
	
	if var_8_0 and get_cocos_refid(var_8_0) then
		local var_8_1 = load_control("wnd/story_banner.csb")
		
		var_8_1:setAnchorPoint(0.5, 0.5)
		var_8_1:getChildByName("panel_clipping"):setTouchEnabled(false)
		if_set_visible(arg_8_0, "select", false)
		if_set_visible(arg_8_0, "img", false)
		if_set_visible(arg_8_0, "img_noti", false)
		var_8_0:addChild(var_8_1)
	end
	
	return arg_8_0
end

function SubstorySystemStoryListView.init(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.vars = {}
	arg_9_0.vars.parent = arg_9_1
	
	if arg_9_2 then
		arg_9_0.vars.cur_seleted_id = arg_9_2
	end
	
	arg_9_0.vars.listview = ItemListView_v2:bindControl(arg_9_0.vars.parent:getChildByName("ListView_substory"))
	
	local var_9_0 = {
		onUpdate = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			arg_9_0:updateListViewItem(arg_10_1, arg_10_3)
			
			return arg_10_3.id
		end,
		onLightUpdate = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			arg_9_0:initBanner(arg_11_1)
		end
	}
	local var_9_1 = load_control("wnd/dict_substory_list_item.csb")
	local var_9_2 = var_0_0(var_9_1)
	
	arg_9_0.vars.listview:setRenderer(var_9_2, var_9_0)
	arg_9_0.vars.listview:removeAllChildren()
end

function SubstorySystemStoryListView.getListView(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	return arg_12_0.vars.listview
end

function SubstorySystemStoryListView.initBanner(arg_13_0, arg_13_1)
	if not arg_13_1 or not get_cocos_refid(arg_13_1) then
		return 
	end
	
	if_set_visible(arg_13_1, "select", false)
	if_set_color(arg_13_1, "banner_bg", cc.c3b(255, 255, 255))
	if_set_visible(arg_13_1, "t_completed", false)
	if_set_visible(arg_13_1, "t_ing", false)
	if_set_visible(arg_13_1, "icon_locked", false)
	arg_13_1:getChildByName("n_badge"):removeAllChildren()
end

function SubstorySystemStoryListView.createListItems(arg_14_0, arg_14_1)
	if not arg_14_0.vars or table.empty(arg_14_1) then
		return nil
	end
	
	local var_14_0 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		local var_14_1 = {
			id = iter_14_1.id,
			prologue = iter_14_1.prologue,
			hero_db = iter_14_1.hero_db,
			unlock_stage = iter_14_1.unlock_stage,
			gacha_banner = iter_14_1.gacha_banner,
			substory_name = iter_14_1.substory_name,
			db_sort = iter_14_1.db_sort
		}
		
		var_14_1.sort = 4
		
		if Account:isMapCleared(var_14_1.unlock_stage) then
			var_14_1.sort = 3
		end
		
		if iter_14_1.new == "y" then
			var_14_1.sort = 2
		end
		
		if SubstorySystemStory:isSubstoryCleared(var_14_1.id) then
			var_14_1.sort = 5
		end
		
		local var_14_2 = Account:getSystemSubstory()
		
		if not table.empty(var_14_2) and var_14_2.substory_id == var_14_1.id then
			var_14_1.sort = 1
		end
		
		table.insert(var_14_0, var_14_1)
	end
	
	return var_14_0
end

function SubstorySystemStoryListView.sort(arg_15_0, arg_15_1)
	if not arg_15_0.vars or table.empty(arg_15_1) then
		return nil
	end
	
	if table.count(arg_15_1) >= 2 then
		table.sort(arg_15_1, function(arg_16_0, arg_16_1)
			if arg_16_0.sort == arg_16_1.sort then
				return arg_16_0.db_sort < arg_16_1.db_sort
			end
			
			return arg_16_0.sort < arg_16_1.sort
		end)
	end
	
	return arg_15_1
end

function SubstorySystemStoryListView.setItems(arg_17_0, arg_17_1)
	if not arg_17_0.vars or table.empty(arg_17_1) or not get_cocos_refid(arg_17_0.vars.listview) then
		return 
	end
	
	arg_17_0.vars.listview:lightRefresh()
	arg_17_0.vars.listview:setDataSource(arg_17_1)
	arg_17_0.vars.listview:jumpToTop()
end

function SubstorySystemStoryListView.setBannerByState(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 or not get_cocos_refid(arg_18_1) or not arg_18_2 then
		return nil
	end
	
	if arg_18_0.vars.cur_seleted_id and arg_18_0.vars.cur_seleted_id == arg_18_2.id then
		if_set_visible(arg_18_1, "select", true)
	end
	
	local var_18_0
	
	if arg_18_2.sort == 1 then
		if DEBUG.DEBUG_MAP_ID then
			var_18_0 = arg_18_0:getDebugText(arg_18_2) .. T("ui_systemsubstory_list_pro")
		else
			var_18_0 = T("ui_systemsubstory_list_pro")
		end
		
		if_set(arg_18_1, "t_ing", var_18_0)
	elseif arg_18_2.sort == 5 then
		if DEBUG.DEBUG_MAP_ID then
			var_18_0 = arg_18_0:getDebugText(arg_18_2) .. T("ui_systemsubstory_list_com")
		else
			var_18_0 = T("ui_systemsubstory_list_com")
		end
		
		if_set(arg_18_1, "t_completed", var_18_0)
	else
		if Account:isMapCleared(arg_18_2.unlock_stage) then
			if DEBUG.DEBUG_MAP_ID then
				var_18_0 = arg_18_0:getDebugText(arg_18_2)
				
				if_set(arg_18_1, "t_ing", var_18_0)
			end
		else
			if_set_visible(arg_18_1, "icon_locked", true)
			
			if DEBUG.DEBUG_MAP_ID then
				var_18_0 = arg_18_0:getDebugText(arg_18_2) .. T("ui_systemsubstory_list_lock")
			else
				var_18_0 = T("ui_systemsubstory_list_lock")
			end
			
			if_set(arg_18_1, "t_locked", var_18_0)
			if_set_color(arg_18_1, "banner_bg", cc.c3b(136, 136, 136))
		end
		
		if arg_18_2.sort == 2 then
			local var_18_1 = cc.Sprite:create()
			
			SpriteCache:resetSprite(var_18_1, "img/shop_icon_new.png")
			
			local var_18_2 = arg_18_1:getChildByName("n_badge")
			
			var_18_2:setVisible(true)
			var_18_2:addChild(var_18_1)
		end
	end
end

function SubstorySystemStoryListView.updateListViewItem(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_1 or not get_cocos_refid(arg_19_1) or not arg_19_2 then
		return 
	end
	
	local var_19_0 = arg_19_2.id
	
	if var_19_0 then
		local var_19_1 = SubStoryUtil:getSubstoryDB(var_19_0)
		local var_19_2 = arg_19_1:getChildByName("story_banner")
		local var_19_3 = var_19_2:getChildByName("bi_img")
		local var_19_4 = var_19_2:getChildByName("banner_bg")
		local var_19_5 = var_19_1.banner_icon
		
		if not string.starts(var_19_5, "banner/") then
			if_set_sprite(var_19_3, nil, "banner/" .. (var_19_5 or "banner_sample") .. ".png")
		else
			if_set_sprite(var_19_3, nil, var_19_5)
		end
		
		local var_19_6 = var_19_1.icon_enter
		
		if not string.starts(var_19_6, "banner/") then
			if_set_sprite(var_19_4, nil, "banner/" .. (var_19_6 or "banner_sample") .. ".png")
		else
			if_set_sprite(var_19_4, nil, var_19_6)
		end
		
		local var_19_7 = var_19_1.logo_position
		
		if_set_visible(var_19_3, nil, var_19_7)
		
		if var_19_7 then
			var_19_3:setAnchorPoint(0, 0)
			var_19_3:setPositionY(var_19_7.y or 0)
			var_19_3:setPositionX(var_19_7.x or 0)
		end
	end
	
	arg_19_1:getChildByName("btn").item = arg_19_2
	
	arg_19_0:setBannerByState(arg_19_1, arg_19_2)
end

function SubstorySystemStoryListView.setSelectedBanner(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not arg_20_1 then
		return 
	end
	
	local var_20_0
	
	if arg_20_0.vars.cur_seleted_id then
		if arg_20_0.vars.cur_seleted_id == arg_20_1 then
			return 
		else
			local var_20_1 = arg_20_0:getBanner(arg_20_0.vars.cur_seleted_id)
			
			if_set_visible(var_20_1, "select", false)
		end
	end
	
	arg_20_0.vars.cur_seleted_id = arg_20_1
	
	local var_20_2 = arg_20_0:getBanner(arg_20_0.vars.cur_seleted_id)
	
	if_set_visible(var_20_2, "select", true)
end

function SubstorySystemStoryListView.getListItems(arg_21_0)
	if not arg_21_0.vars or not arg_21_0.vars.listview or not get_cocos_refid(arg_21_0.vars.listview) then
		return nil
	end
	
	return arg_21_0.vars.listview:getDataSource() or {}
end

function SubstorySystemStoryListView.getListItemById(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return nil
	end
	
	local var_22_0 = arg_22_0:getListItems()
	
	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if iter_22_1.id == arg_22_1 then
			return iter_22_1
		end
	end
	
	return nil
end

function SubstorySystemStoryListView.getListItemIdx(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return nil
	end
	
	local var_23_0 = arg_23_0:getListItems()
	
	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		if iter_23_1.id == arg_23_1 then
			return iter_23_0
		end
	end
	
	return nil
end

function SubstorySystemStoryListView.getBanner(arg_24_0, arg_24_1)
	if not arg_24_0.vars or not arg_24_0.vars.listview or not get_cocos_refid(arg_24_0.vars.listview) then
		return nil
	end
	
	if not arg_24_1 then
		return nil
	end
	
	local var_24_0 = arg_24_0.vars.listview:getDataSource()
	
	if table.empty(var_24_0) then
		return nil
	end
	
	local var_24_1
	
	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		if iter_24_1.id == arg_24_1 then
			var_24_1 = iter_24_1
			
			break
		end
	end
	
	return (arg_24_0.vars.listview:getControl(var_24_1))
end

function SubstorySystemStoryListView.scrollToItem(arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0:getListItemIdx(arg_25_1)
	
	if not var_25_0 then
		return 
	end
	
	arg_25_0.vars.listview:forceDoLayout()
	arg_25_0.vars.listview:jumpToIndex(var_25_0)
end

function SubstorySystemStoryListView.getCurrentSelectedId(arg_26_0)
	if not arg_26_0.vars or not arg_26_0.vars.cur_seleted_id then
		return nil
	end
	
	return arg_26_0.vars.cur_seleted_id
end

function SubstorySystemStoryListView.getCurrentSelectedItem(arg_27_0)
	if not arg_27_0.vars or not arg_27_0.vars.cur_seleted_id then
		return nil
	end
	
	return arg_27_0:getListItemById(arg_27_0.vars.cur_seleted_id)
end

function SubstorySystemStoryListView.reset(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.listview) then
		return 
	end
	
	arg_28_0.vars.listview:setDataSource({})
	
	arg_28_0.vars = {}
end

function SubstorySystemStoryListView.getDebugText(arg_29_0, arg_29_1)
	if not arg_29_1 then
		return ""
	end
	
	local var_29_0 = arg_29_1.hero_db
	local var_29_1 = string.sub(var_29_0.element, 1, 1)
	local var_29_2 = string.sub(var_29_0.role, 1, 3)
	
	return "(" .. arg_29_1.id .. ", " .. var_29_1 .. ", " .. var_29_2 .. ", " .. tostring(arg_29_1.db_sort) .. ")"
end
