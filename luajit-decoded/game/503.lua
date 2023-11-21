CustomProfileCardBg = {}

function CustomProfileCardBg.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.bg_tab = arg_1_1.n_tab
	arg_1_0.vars.bg_wnd = arg_1_1.category_wnd
	
	arg_1_0:initDB()
	arg_1_0:initUI()
end

function CustomProfileCardBg.release(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.bg_tab) or not get_cocos_refid(arg_2_0.vars.bg_wnd) then
		return 
	end
	
	arg_2_0.listview_bg:release()
	
	if not ContentDisable:byAlias("profile_card_illust") then
		arg_2_0.listview_illust:release()
	end
	
	arg_2_0.vars.bg_tab = nil
	arg_2_0.vars.bg_wnd = nil
	arg_2_0.vars = nil
end

function CustomProfileCardBg.initDB(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	arg_3_0:initBgData()
	
	if not ContentDisable:byAlias("profile_card_illust") then
		arg_3_0:initIllustData()
	end
end

function CustomProfileCardBg.initUI(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.bg_tab) or not get_cocos_refid(arg_4_0.vars.bg_wnd) then
		return 
	end
	
	arg_4_0:showNoData(false)
	arg_4_0.listview_bg:create(arg_4_0.vars.bg_wnd)
	
	if ContentDisable:byAlias("profile_card_illust") then
		local var_4_0 = arg_4_0.vars.bg_wnd:getChildByName("n_sub")
		
		if get_cocos_refid(var_4_0) then
			if_set_visible(var_4_0, "tab_2", false)
		end
	else
		arg_4_0.listview_illust:create(arg_4_0.vars.bg_wnd)
		arg_4_0:initIllustCategoryListUI()
		arg_4_0:updateDropDownBtn()
	end
	
	arg_4_0:setListViewMode("1")
end

function CustomProfileCardBg.resetUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.bg_tab) or not get_cocos_refid(arg_5_0.vars.bg_wnd) then
		return 
	end
	
	if_set_visible(arg_5_0.vars.bg_tab, "bg_tab", false)
	if_set_visible(arg_5_0.vars.bg_wnd, nil, false)
	
	if not ContentDisable:byAlias("profile_card_illust") then
		arg_5_0:clearIllustCategory()
	end
end

function CustomProfileCardBg.setUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.bg_tab) or not get_cocos_refid(arg_6_0.vars.bg_wnd) then
		return 
	end
	
	if_set_visible(arg_6_0.vars.bg_tab, "bg_tab", true)
	if_set_visible(arg_6_0.vars.bg_wnd, nil, true)
	
	local var_6_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_6_0 and var_6_0:getType() == "bg" then
		if var_6_0:isIllust() and not ContentDisable:byAlias("profile_card_illust") then
			local var_6_1 = var_6_0:getId()
			local var_6_2 = arg_6_0:getIllustCategory(var_6_1)
			local var_6_3 = arg_6_0:getIllustCategoryIndex(var_6_2)
			
			if var_6_3 and not table.empty(arg_6_0.vars.sort_node_list) then
				arg_6_0:setIllustCategory(arg_6_0.vars.sort_node_list[tonumber(var_6_3)])
			end
			
			arg_6_0:setListViewMode("2")
		else
			arg_6_0:setListViewMode("1")
		end
	else
		arg_6_0:setListViewMode("1")
	end
end

function CustomProfileCardBg.setListViewMode(arg_7_0, arg_7_1)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.bg_tab) or not get_cocos_refid(arg_7_0.vars.bg_wnd) then
		return 
	end
	
	if not arg_7_1 then
		return 
	end
	
	local var_7_0 = false
	
	if arg_7_1 == "1" then
		var_7_0 = false
	elseif arg_7_1 == "2" then
		var_7_0 = true
	else
		return 
	end
	
	if_set_visible(arg_7_0.vars.bg_wnd, "listview_bg", not var_7_0)
	if_set_visible(arg_7_0.vars.bg_wnd, "listview_illust", var_7_0)
	arg_7_0:showNoData(false)
	
	local var_7_1 = arg_7_0.vars.bg_wnd:getChildByName("n_sub")
	
	if get_cocos_refid(var_7_1) then
		local var_7_2 = var_7_1:getChildByName("tab_1")
		
		if_set_visible(var_7_2, "bg_sel", not var_7_0)
		
		local var_7_3 = var_7_1:getChildByName("tab_2")
		
		if_set_visible(var_7_3, "bg_sel", var_7_0)
		if_set_visible(var_7_1, "btn_dropdown", var_7_0)
	end
	
	if var_7_0 then
		arg_7_0:setillustList()
	else
		arg_7_0:setBgList()
	end
end

function CustomProfileCardBg.setBgList(arg_8_0)
	if not arg_8_0.vars or table.empty(arg_8_0.vars.bg_items) then
		return 
	end
	
	table.sort(arg_8_0.vars.bg_items, function(arg_9_0, arg_9_1)
		local var_9_0, var_9_1 = CustomProfileCardEditor:checkLayerItemUnlock(arg_9_0.id)
		local var_9_2, var_9_3 = CustomProfileCardEditor:checkLayerItemUnlock(arg_9_1.id)
		
		if var_9_0 and var_9_2 then
			return arg_9_0.sort < arg_9_1.sort
		end
		
		if var_9_0 or var_9_2 then
			return var_9_0 and not var_9_2
		end
		
		return arg_9_0.sort < arg_9_1.sort
	end)
	arg_8_0.listview_bg:setData(arg_8_0.vars.bg_items)
end

function CustomProfileCardBg.setillustList(arg_10_0)
	if not arg_10_0.vars or table.empty(arg_10_0.vars.bg_items) then
		return 
	end
	
	local var_10_0 = arg_10_0:getCurrentDataList()
	
	arg_10_0.listview_illust:setData(var_10_0)
	arg_10_0:showNoData(table.count(var_10_0) == 0)
end

function CustomProfileCardBg.initIllustCategoryListUI(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.bg_tab) or not get_cocos_refid(arg_11_0.vars.bg_wnd) then
		return 
	end
	
	local var_11_0 = arg_11_0:getIllustCategories()
	
	if table.empty(var_11_0) then
		return 
	end
	
	local var_11_1 = table.count(var_11_0)
	local var_11_2 = 4
	local var_11_3 = arg_11_0.vars.bg_wnd:getChildByName("layer_sort_illust")
	
	if get_cocos_refid(var_11_3) then
		local var_11_4 = var_11_3:getChildByName("bg")
		
		if get_cocos_refid(var_11_4) then
			local var_11_5 = var_11_4:getContentSize()
			
			var_11_4:setContentSize(var_11_5.width, var_11_5.height + (var_11_1 - var_11_2) * 49)
		end
	end
	
	arg_11_0.vars.sort_node_list = {}
	
	for iter_11_0 = 1, var_11_1 do
		local var_11_6 = var_11_0[iter_11_0]
		local var_11_7 = "sort_" .. tostring(iter_11_0)
		local var_11_8 = var_11_3:getChildByName(var_11_7)
		
		if get_cocos_refid(var_11_8) and var_11_6 and var_11_6.id then
			var_11_8:setVisible(true)
			
			local var_11_9, var_11_10 = DB("dic_ui", var_11_6.id, {
				"name",
				"icon"
			})
			
			arg_11_0.vars.sort_node_list[iter_11_0] = var_11_8
			
			if_set(var_11_8, "label", T(var_11_9))
			if_set_sprite(var_11_8, "icon_" .. tostring(iter_11_0), var_11_10)
			if_set_visible(var_11_8, "sort_cursor", false)
			
			var_11_8.id = var_11_6.id
			
			if iter_11_0 == 1 then
				arg_11_0:setIllustCategory(var_11_8)
			end
		else
			var_11_8:setVisible(false)
		end
	end
end

function CustomProfileCardBg.clearIllustCategory(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.bg_tab) or not get_cocos_refid(arg_12_0.vars.bg_wnd) then
		return 
	end
	
	arg_12_0.vars.pre_sort_node = nil
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.sort_node_list) do
		if get_cocos_refid(iter_12_1) then
			if_set_visible(iter_12_1, "sort_cursor", false)
			
			if iter_12_0 == 1 and iter_12_1.id then
				arg_12_0.vars.illust_category_id = iter_12_1.id
			end
		end
	end
	
	arg_12_0:updateDropDownBtn()
end

function CustomProfileCardBg.setIllustCategory(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_1) then
		return 
	end
	
	if arg_13_1.id and arg_13_0.vars.illust_category_id == arg_13_1.id then
		return 
	end
	
	arg_13_0.vars.illust_category_id = arg_13_1.id
	
	if get_cocos_refid(arg_13_0.vars.pre_sort_node) then
		if_set_visible(arg_13_0.vars.pre_sort_node, "sort_cursor", false)
	end
	
	arg_13_0.vars.pre_sort_node = arg_13_1
	
	if_set_visible(arg_13_0.vars.pre_sort_node, "sort_cursor", true)
	arg_13_0:updateDropDownBtn()
	arg_13_0:showDropDown(false)
	
	local var_13_0 = arg_13_0:getCurrentDataList()
	
	arg_13_0.listview_illust:setData(var_13_0)
	arg_13_0:showNoData(table.count(var_13_0) == 0)
end

function CustomProfileCardBg.updateDropDownBtn(arg_14_0)
	if not arg_14_0.vars or not arg_14_0.vars.illust_category_id or not get_cocos_refid(arg_14_0.vars.bg_wnd) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.bg_wnd:getChildByName("btn_dropdown")
	
	if get_cocos_refid(var_14_0) then
		local var_14_1, var_14_2 = DB("dic_ui", arg_14_0.vars.illust_category_id, {
			"name",
			"icon"
		})
		
		if_set(var_14_0, "label", T(var_14_1))
		if_set_sprite(var_14_0, "icon_story", var_14_2)
	end
end

function CustomProfileCardBg.showDropDown(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.bg_tab) or not get_cocos_refid(arg_15_0.vars.bg_wnd) then
		return 
	end
	
	if_set_visible(arg_15_0.vars.bg_wnd, "layer_sort_illust", arg_15_1)
end

function CustomProfileCardBg.showNoData(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.bg_tab) or not get_cocos_refid(arg_16_0.vars.bg_wnd) then
		return 
	end
	
	if_set_visible(arg_16_0.vars.bg_wnd, "n_info", arg_16_1)
end

function CustomProfileCardBg.createBgLayer(arg_17_0, arg_17_1)
	if table.empty(arg_17_1) or not arg_17_1.type or arg_17_1.type ~= "bg" or not arg_17_1.id then
		return 
	end
	
	CustomProfileCardEditor:createLayer({
		type = arg_17_1.type,
		id = arg_17_1.id,
		is_illust = arg_17_1.is_illust
	})
end

function CustomProfileCardBg.initBgData(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	arg_18_0.vars.bg_items = {}
	
	for iter_18_0 = 1, 9999 do
		local var_18_0, var_18_1, var_18_2 = DBN("item_material_profile", iter_18_0, {
			"id",
			"material_id",
			"type"
		})
		
		if not var_18_0 then
			break
		end
		
		local var_18_3 = CustomProfileCardEditor:isNeedHideCheckLayerItem(var_18_0)
		
		if var_18_2 == "bg" and var_18_1 and (not var_18_3 or Account:getItemCount(var_18_1) > 0) then
			local var_18_4 = DBT("item_material", var_18_1, {
				"sort",
				"ma_type",
				"drop_icon",
				"desc"
			})
			
			table.insert(arg_18_0.vars.bg_items, {
				is_illust = false,
				id = var_18_0,
				material_id = var_18_1,
				sort = var_18_4.sort,
				content_type = var_18_4.ma_type,
				type = var_18_2,
				icon = var_18_4.drop_icon,
				desc = var_18_4.desc
			})
		end
	end
end

function CustomProfileCardBg.getBgItems(arg_19_0)
	if not arg_19_0.vars then
		return nil
	end
	
	return arg_19_0.vars.bg_items
end

function CustomProfileCardBg.initIllustData(arg_20_0)
	if not arg_20_0.vars then
		return 
	end
	
	arg_20_0.vars.illust_db = CollectionDB:CreateIllustDB()
	
	local var_20_0 = {}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.illust_db.parent_DB) do
		local var_20_1 = DB("dic_ui", iter_20_0, "parent_id")
		
		if not var_20_0[var_20_1] then
			var_20_0[var_20_1] = {}
		end
		
		var_20_0[var_20_1][iter_20_0] = iter_20_1
	end
	
	arg_20_0.vars.illust_db.category_db = var_20_0
end

function CustomProfileCardBg.getIllustCategories(arg_21_0)
	return CollectionDB:GetCategories(arg_21_0.vars.illust_db.category_db)
end

function CustomProfileCardBg.getCurrentDataList(arg_22_0)
	return arg_22_0:GetCategoryDataList(arg_22_0.vars.illust_db.category_db, arg_22_0.vars.illust_category_id)
end

function CustomProfileCardBg.getIllustCategory(arg_23_0, arg_23_1)
	if not arg_23_0.vars or table.empty(arg_23_0.vars.illust_db) or table.empty(arg_23_0.vars.illust_db.category_db) then
		return nil
	end
	
	if not arg_23_1 then
		return 
	end
	
	local var_23_0 = DB("dic_data_illust", arg_23_1, {
		"parent_id"
	})
	
	if not var_23_0 then
		return nil
	end
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.illust_db.category_db) do
		if not table.empty(iter_23_1) then
			for iter_23_2, iter_23_3 in pairs(iter_23_1) do
				if iter_23_2 == var_23_0 then
					return iter_23_0
				end
			end
		end
	end
	
	return nil
end

function CustomProfileCardBg.getIllustCategoryIndex(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return nil
	end
	
	return DB("dic_ui", arg_24_1, "sort")
end

function CustomProfileCardBg.GetCategoryDataList(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_1[arg_25_2]
	local var_25_1 = {}
	
	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		local var_25_2 = DB("dic_ui", iter_25_0, "sort")
		local var_25_3 = {}
		
		for iter_25_2, iter_25_3 in pairs(iter_25_1) do
			if CollectionUtil:isIllustUnlock(iter_25_3) then
				table.insert(var_25_3, iter_25_3)
			end
		end
		
		if #var_25_3 > 0 then
			table.sort(var_25_3, function(arg_26_0, arg_26_1)
				return arg_26_0.sort < arg_26_1.sort
			end)
			table.insert(var_25_1, {
				data = var_25_3,
				sort = var_25_2,
				id = iter_25_0
			})
		end
	end
	
	table.sort(var_25_1, function(arg_27_0, arg_27_1)
		return arg_27_0.sort < arg_27_1.sort
	end)
	
	return var_25_1
end

CustomProfileCardBg.listview_bg = {}
CustomProfileCardBg.listview_illust = {}

function CustomProfileCardBg.listview_bg.create(arg_28_0, arg_28_1)
	if not get_cocos_refid(arg_28_1) then
		return 
	end
	
	arg_28_0.vars = {}
	arg_28_0.vars.listview = ItemListView_v2:bindControl(arg_28_1:getChildByName("listview_bg"))
	
	local var_28_0 = {
		onUpdate = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
			arg_28_0:updateListViewItem(arg_29_1, arg_29_3)
			
			return arg_29_3.id
		end
	}
	local var_28_1 = load_control("wnd/profile_custom_bg_card.csb")
	
	arg_28_0.vars.listview:setRenderer(var_28_1, var_28_0)
	arg_28_0.vars.listview:removeAllChildren()
end

function CustomProfileCardBg.listview_bg.release(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.listview) then
		return 
	end
	
	arg_30_0.vars.listview:removeAllChildren()
	arg_30_0.vars.listview:setDataSource(nil)
	
	arg_30_0.vars.listview = nil
	arg_30_0.vars = nil
end

function CustomProfileCardBg.listview_bg.updateListViewItem(arg_31_0, arg_31_1, arg_31_2)
	if not get_cocos_refid(arg_31_1) or not arg_31_2 then
		return 
	end
	
	local var_31_0 = arg_31_2.id
	
	if var_31_0 then
		local var_31_1 = arg_31_1:getChildByName("btn_select")
		
		var_31_1.item = arg_31_2
		
		if arg_31_2.content_type and arg_31_2.type and arg_31_2.icon then
			if_set_sprite(arg_31_1, "n_bg", arg_31_2.content_type .. "/" .. arg_31_2.type .. "/" .. arg_31_2.icon .. ".png")
		end
		
		local var_31_2, var_31_3 = CustomProfileCardEditor:checkLayerItemUnlock(var_31_0)
		
		if var_31_2 then
			var_31_1.callback = CustomProfileCardBg.createBgLayer
		end
		
		if_set_color(arg_31_1, "n_bg", var_31_2 and cc.c3b(255, 255, 255) or tocolor("#5b5b5b"))
		if_set_visible(arg_31_1, "icon_locked", not var_31_2)
		
		if var_31_3 then
			if_set_visible(arg_31_1, "n_shop", var_31_3 == "purchase" and not var_31_2)
			
			if var_31_3 == "purchase" and not var_31_2 then
				function var_31_1.after_buy_callback()
					CustomProfileCardBg:setBgList()
				end
			end
		end
		
		local var_31_4 = CustomProfileCardEditor:getTargetCard()
		local var_31_5
		
		if var_31_4 then
			var_31_5 = var_31_4:checkDuplicationLayer("bg", var_31_0)
		end
		
		if_set_visible(arg_31_1, "n_select", var_31_5)
		if_set_visible(arg_31_1, "icon_check", var_31_5)
	end
end

function CustomProfileCardBg.listview_bg.setData(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.listview) then
		return 
	end
	
	arg_33_1 = arg_33_1 or {}
	
	arg_33_0.vars.listview:removeAllChildren()
	arg_33_0.vars.listview:setDataSource(arg_33_1)
	arg_33_0.vars.listview:jumpToTop()
end

function CustomProfileCardBg.listview_illust.create(arg_34_0, arg_34_1)
	if not get_cocos_refid(arg_34_1) then
		return 
	end
	
	arg_34_0.vars = {}
	arg_34_0.vars.listview = GroupListView:bindControl(arg_34_1:getChildByName("listview_illust"))
	
	arg_34_0.vars.listview:setListViewCascadeOpacityEnabled(true)
	arg_34_0.vars.listview:setEnableMargin(true)
	
	local var_34_0 = load_control("wnd/lobby_custom_illust_header.csb")
	local var_34_1 = {
		onUpdate = function(arg_35_0, arg_35_1, arg_35_2)
			local var_35_0, var_35_1 = DB("dic_ui", arg_35_2, {
				"name",
				"desc"
			})
			
			if_set(arg_35_1, "txt_name", T(var_35_0))
			UIUserData:call(arg_35_1:getChildByName("txt_name"), "SINGLE_WSCALE(420)")
		end
	}
	local var_34_2 = {
		onUpdate = function(arg_36_0, arg_36_1, arg_36_2)
			arg_34_0:updateListViewItem(arg_36_1, arg_36_2)
		end
	}
	
	if arg_34_0.vars.listview.STRETCH_INFO then
		local var_34_3 = arg_34_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(renderer, var_34_3.width, arg_34_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	local var_34_4 = load_control("wnd/profile_custom_illust_card.csb")
	
	arg_34_0.vars.listview:setRenderer(var_34_0, var_34_4, var_34_1, var_34_2)
	arg_34_0.vars.listview:clear()
end

function CustomProfileCardBg.listview_illust.release(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.listview) then
		return 
	end
	
	arg_37_0.vars.listview:clear()
	
	arg_37_0.vars.listview = nil
	arg_37_0.vars = nil
end

function CustomProfileCardBg.listview_illust.updateListViewItem(arg_38_0, arg_38_1, arg_38_2)
	if not get_cocos_refid(arg_38_1) or not arg_38_2 then
		return 
	end
	
	local var_38_0 = CollectionUtil:isIllustUnlock(arg_38_2) or false
	
	if_set_visible(arg_38_1, "img_nodata", not var_38_0)
	if_set_visible(arg_38_1, "n_illust", var_38_0)
	
	local var_38_1 = arg_38_1:getChildByName("n_illust")
	local var_38_2 = arg_38_1:getChildByName("img")
	
	if get_cocos_refid(var_38_2) then
		var_38_2:removeFromParent()
	end
	
	if var_38_0 and not arg_38_1:getChildByName("thumbnail_img") then
		local var_38_3 = arg_38_2.illust or ""
		
		if arg_38_2.thumbnail then
			if string.starts(arg_38_2.thumbnail, "story/bg/") then
				local var_38_4 = UIUtil:getIllustPath("story/bg/", string.replace(arg_38_2.thumbnail, "story/bg/", ""))
				
				var_38_2 = SpriteCache:getSprite(var_38_4)
			else
				var_38_2 = cc.Sprite:create("item/art/" .. arg_38_2.thumbnail .. ".png")
			end
			
			var_38_2:setName("img")
			var_38_2:setPosition(109, 62)
			var_38_1:addChild(var_38_2)
		elseif string.find(var_38_3, ".cfx") then
			var_38_2 = CACHE:getEffect(var_38_3, "effect")
			
			local var_38_5 = {
				effect = var_38_2,
				fn = var_38_3
			}
			
			var_38_5.x = 109
			var_38_5.y = 62
			var_38_5.scale = 0.23
			var_38_5.layer = var_38_1
			
			EffectManager:EffectPlay(var_38_5)
		else
			local var_38_6
			local var_38_7 = true
			
			if arg_38_2.thumbnail then
				var_38_6 = "item/art/" .. arg_38_2.thumbnail .. ".png"
			else
				local var_38_8 = UIUtil:getIllustPathWithCheckExist("story/bg/", var_38_3 .. "_th")
				
				if var_38_8 then
					var_38_6 = var_38_8
				else
					var_38_7 = false
					var_38_6 = UIUtil:getIllustPath("story/bg/", var_38_3)
				end
			end
			
			if get_cocos_refid(var_38_2) then
				local var_38_9 = SpriteCache:getSprite(var_38_6)
				
				var_38_9:setPosition(109, 62)
				
				if get_cocos_refid(var_38_9) and not var_38_7 then
					var_38_9:setScale(0.23)
					var_38_9:setAnchorPoint(0.5, 0.5)
				else
					local var_38_10 = var_38_9:getContentSize()
					local var_38_11 = var_38_1:getContentSize()
					
					var_38_9:setScale(math.max(var_38_11.width / var_38_10.width, var_38_11.height / var_38_10.height))
				end
				
				var_38_1:addChild(var_38_9)
			end
		end
	end
	
	local var_38_12 = arg_38_2.id
	
	if var_38_12 then
		local var_38_13 = arg_38_1:getChildByName("btn_select")
		
		var_38_13.item = {
			is_illust = true,
			type = "bg",
			id = var_38_12
		}
		var_38_13.callback = CustomProfileCardBg.createBgLayer
		
		local var_38_14 = CustomProfileCardEditor:getTargetCard()
		local var_38_15
		
		if var_38_14 then
			var_38_15 = var_38_14:checkDuplicationLayer("bg", var_38_12)
		end
		
		if_set_visible(arg_38_1, "n_select", var_38_15)
		if_set_visible(arg_38_1, "icon_check", var_38_15)
	end
end

function CustomProfileCardBg.listview_illust.setData(arg_39_0, arg_39_1)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.listview) then
		return 
	end
	
	arg_39_0.vars.listview:clear()
	
	for iter_39_0, iter_39_1 in pairs(arg_39_1) do
		arg_39_0.vars.listview:addGroup(iter_39_1.id, iter_39_1.data)
	end
end
