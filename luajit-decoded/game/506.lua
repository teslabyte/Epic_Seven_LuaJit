CustomProfileCardBadge = {}

function CustomProfileCardBadge.create(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.badge_tab = arg_1_1.n_tab
	arg_1_0.vars.badge_wnd = arg_1_1.category_wnd
	
	arg_1_0:initDB()
	arg_1_0:initUI()
end

function CustomProfileCardBadge.release(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.badge_tab) or not get_cocos_refid(arg_2_0.vars.badge_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_2_0.vars.listview) then
		return 
	end
	
	arg_2_0.vars.listview:removeAllChildren()
	arg_2_0.vars.listview:setDataSource(nil)
	
	arg_2_0.vars.listview = nil
	arg_2_0.vars.badge_tab = nil
	arg_2_0.vars.badge_wnd = nil
	arg_2_0.vars = nil
end

function CustomProfileCardBadge.initDB(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	arg_3_0.vars.badge_items = {}
	
	for iter_3_0 = 1, 9999 do
		local var_3_0, var_3_1, var_3_2 = DBN("item_material_profile", iter_3_0, {
			"id",
			"material_id",
			"type"
		})
		
		if not var_3_0 then
			break
		end
		
		local var_3_3 = CustomProfileCardEditor:isNeedHideCheckLayerItem(var_3_0)
		
		if var_3_2 == "badge" and var_3_1 and (not var_3_3 or Account:getItemCount(var_3_1) > 0) then
			local var_3_4 = DBT("item_material", var_3_1, {
				"sort",
				"ma_type",
				"drop_icon",
				"desc"
			})
			
			table.insert(arg_3_0.vars.badge_items, {
				id = var_3_0,
				material_id = var_3_1,
				sort = var_3_4.sort,
				content_type = var_3_4.ma_type,
				type = var_3_2,
				icon = var_3_4.drop_icon,
				desc = var_3_4.desc
			})
		end
	end
end

function CustomProfileCardBadge.initUI(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.badge_tab) or not get_cocos_refid(arg_4_0.vars.badge_wnd) then
		return 
	end
	
	if table.empty(arg_4_0.vars.badge_items) then
		return 
	end
	
	arg_4_0.vars.listview = ItemListView_v2:bindControl(arg_4_0.vars.badge_wnd:getChildByName("listview_badge"))
	
	local var_4_0 = {
		onUpdate = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
			arg_4_0:updateListViewItem(arg_5_1, arg_5_3)
			
			return arg_5_3.id
		end
	}
	local var_4_1 = load_control("wnd/profile_custom_badge_card.csb")
	
	arg_4_0.vars.listview:setRenderer(var_4_1, var_4_0)
	arg_4_0:setListItems()
	arg_4_0:updateTapNoti()
	if_set_visible(arg_4_0.vars.badge_wnd, "n_info_action", true)
	if_set_visible(arg_4_0.vars.badge_wnd, "n_info_badge", false)
end

function CustomProfileCardBadge.resetUI(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.badge_tab) or not get_cocos_refid(arg_6_0.vars.badge_wnd) then
		return 
	end
	
	if_set_visible(arg_6_0.vars.badge_tab, "bg_tab", false)
	if_set_visible(arg_6_0.vars.badge_wnd, nil, false)
	if_set_visible(arg_6_0.vars.badge_wnd, "n_info_action", true)
	if_set_visible(arg_6_0.vars.badge_wnd, "n_info_badge", false)
end

function CustomProfileCardBadge.setUI(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.badge_tab) or not get_cocos_refid(arg_7_0.vars.badge_wnd) then
		return 
	end
	
	if_set_visible(arg_7_0.vars.badge_tab, "bg_tab", true)
	if_set_visible(arg_7_0.vars.badge_wnd, nil, true)
	arg_7_0:updateTapNoti()
	
	local var_7_0 = CustomProfileCardEditor:getFocusLayer()
	
	if var_7_0 and var_7_0:getType() == "badge" then
		if_set_visible(arg_7_0.vars.badge_wnd, "n_info_action", false)
		
		local var_7_1 = var_7_0:getId()
		
		arg_7_0:setBadgeInfo(var_7_1)
	else
		if_set_visible(arg_7_0.vars.badge_wnd, "n_info_action", true)
	end
	
	arg_7_0:setListItems()
end

function CustomProfileCardBadge.setListItems(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.badge_wnd) or not get_cocos_refid(arg_8_0.vars.listview) then
		return 
	end
	
	if table.empty(arg_8_0.vars.badge_items) then
		return 
	end
	
	arg_8_0.vars.listview:removeAllChildren()
	table.sort(arg_8_0.vars.badge_items, function(arg_9_0, arg_9_1)
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
	arg_8_0.vars.listview:setDataSource(arg_8_0.vars.badge_items)
	arg_8_0.vars.listview:jumpToTop()
end

function CustomProfileCardBadge.updateTapNoti(arg_10_0)
	if arg_10_0.vars and arg_10_0.vars.badge_tab then
		if_set_visible(arg_10_0.vars.badge_tab, "noti", HiddenMission:isExistClearedMission(HIDDEN_MISSION_TYPE.CUSTOM_PROFILE))
	end
end

function CustomProfileCardBadge.updateListViewItem(arg_11_0, arg_11_1, arg_11_2)
	if not get_cocos_refid(arg_11_1) or not arg_11_2 then
		return 
	end
	
	local var_11_0 = arg_11_2.id
	
	if var_11_0 then
		local var_11_1 = arg_11_1:getChildByName("btn_select")
		
		var_11_1.item = arg_11_2
		
		if arg_11_2.content_type and arg_11_2.type and arg_11_2.icon then
			if_set_sprite(arg_11_1, "icon_badge", arg_11_2.content_type .. "/" .. arg_11_2.type .. "/" .. arg_11_2.icon .. ".png")
		end
		
		local var_11_2, var_11_3 = CustomProfileCardEditor:checkLayerItemUnlock(var_11_0)
		
		if var_11_2 then
			var_11_1.callback = CustomProfileCardBadge.createBadgeLayer
		elseif var_11_0 == "a36" then
			var_11_1.callback = CustomProfileCardBadge.onClickLockedA36
		end
		
		if_set_color(arg_11_1, "icon_badge", var_11_2 and cc.c3b(255, 255, 255) or tocolor("#5b5b5b"))
		if_set_visible(arg_11_1, "icon_locked", not var_11_2)
		
		if var_11_3 then
			if_set_visible(arg_11_1, "n_shop", var_11_3 == "purchase" and not var_11_2)
			
			if var_11_3 == "purchase" and not var_11_2 then
				function var_11_1.after_buy_callback()
					arg_11_0:setListItems()
				end
			end
		end
		
		local var_11_4 = CustomProfileCardEditor:getTargetCard()
		local var_11_5
		
		if var_11_4 then
			var_11_5 = var_11_4:checkDuplicationLayer("badge", var_11_0)
		end
		
		if_set_visible(arg_11_1, "n_select", var_11_5)
		if_set_visible(arg_11_1, "icon_check", var_11_5)
	end
end

function CustomProfileCardBadge.createBadgeLayer(arg_13_0, arg_13_1)
	if table.empty(arg_13_1) or not arg_13_1.type or arg_13_1.type ~= "badge" or not arg_13_1.id then
		return 
	end
	
	CustomProfileCardEditor:createLayer({
		type = arg_13_1.type,
		id = arg_13_1.id
	})
end

function CustomProfileCardBadge.setBadgeInfo(arg_14_0, arg_14_1)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.badge_tab) or not get_cocos_refid(arg_14_0.vars.badge_wnd) then
		return 
	end
	
	if table.empty(arg_14_0.vars.badge_items) or not arg_14_1 then
		return 
	end
	
	local var_14_0
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.badge_items) do
		if iter_14_1.id and iter_14_1.id == arg_14_1 then
			var_14_0 = iter_14_1
			
			break
		end
	end
	
	if var_14_0 then
		local var_14_1 = arg_14_0.vars.badge_wnd:getChildByName("n_info_badge")
		
		var_14_1:setVisible(true)
		
		if var_14_0.content_type and var_14_0.type and var_14_0.icon then
			if_set_sprite(var_14_1, "n_badge", var_14_0.content_type .. "/" .. var_14_0.type .. "/" .. var_14_0.icon .. ".png")
		end
		
		if var_14_0.desc then
			if_set(var_14_1, "txt_badge", T(var_14_0.desc))
		end
	end
end

function CustomProfileCardBadge.onClickLockedA36(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return 
	end
	
	if DB("item_material_profile", arg_15_1.id, {
		"mission_id"
	}) ~= "badge_profile_12" then
		Log.e("CustomProfileCardBadge", "mission_id of a36 must be badge_profile_12. item_id = " .. arg_15_1.id)
		
		return 
	end
	
	ConditionContentsManager:dispatch("sync.badge_profile_12")
	
	return true
end
