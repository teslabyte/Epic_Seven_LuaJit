ClanTag = ClanTag or {}

function ClanTag.getCategoryDB(arg_1_0)
	return arg_1_0:getDB().category
end

function ClanTag.getCategoryList(arg_2_0)
	local var_2_0 = arg_2_0:getCategoryDB()
	local var_2_1 = {}
	
	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		table.insert(var_2_1, iter_2_1)
	end
	
	table.sort(var_2_1, function(arg_3_0, arg_3_1)
		return arg_3_0.sort < arg_3_1.sort
	end)
	
	return var_2_1
end

function ClanTag.getTagDB(arg_4_0)
	return arg_4_0:getDB().tag
end

function ClanTag.getTagListByParentID(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:getDB()
	local var_5_1 = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0.tag or {}) do
		if iter_5_1.parent_id and tonumber(iter_5_1.parent_id) == tonumber(arg_5_1) then
			table.insert(var_5_1, iter_5_1)
		end
	end
	
	table.sort(var_5_1, function(arg_6_0, arg_6_1)
		return arg_6_0.sort < arg_6_1.sort
	end)
	
	return var_5_1
end

function ClanTag.getDB(arg_7_0)
	if not arg_7_0.vars then
		arg_7_0.vars = {}
	end
	
	if not arg_7_0.vars.db then
		arg_7_0.vars.db = {}
		
		for iter_7_0 = 1, 999 do
			local var_7_0, var_7_1, var_7_2, var_7_3, var_7_4 = DBN("clan_tag", iter_7_0, {
				"id",
				"name",
				"parent_id",
				"type",
				"sort"
			})
			
			if not var_7_0 then
				break
			end
			
			if not arg_7_0.vars.db[var_7_3] then
				arg_7_0.vars.db[var_7_3] = {}
			end
			
			arg_7_0.vars.db[var_7_3][tostring(var_7_0)] = {
				id = tostring(var_7_0),
				name = var_7_1,
				parent_id = var_7_2,
				type = var_7_3,
				sort = var_7_4
			}
		end
	end
	
	return arg_7_0.vars.db
end

function ClanTag.setTagInfo(arg_8_0, arg_8_1)
	arg_8_0.tag_info = arg_8_1
end

function ClanTag.getTagInfo(arg_9_0)
	if Account:getClanId() == nil then
		return nil
	end
	
	return arg_9_0.tag_info
end

function ClanTag.getClanTagList(arg_10_0)
	local var_10_0 = ClanTag:getTagInfo()
	
	return arg_10_0:convertListByTagInfo(var_10_0)
end

function ClanTag.getClanTagListIncludeTempTag(arg_11_0)
	local var_11_0 = ClanTag:getTagInfo()
	local var_11_1 = Clan:getClanInfo()
	
	if var_11_0 then
		return arg_11_0:convertListByTagInfo(var_11_0)
	elseif var_11_1 then
		return arg_11_0:getTempTagList(var_11_1)
	end
	
	return {}
end

function ClanTag.getClanTagLabelList(arg_12_0)
	local var_12_0 = arg_12_0:getClanTagListIncludeTempTag()
	local var_12_1 = ClanTag:getTagDB()
	local var_12_2 = {}
	
	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		local var_12_3 = var_12_1[tostring(iter_12_1)]
		
		if var_12_3 then
			table.insert(var_12_2, T(var_12_3.name))
		end
	end
	
	return var_12_2
end

function ClanTag.getTagListByTagInfoIncludeTempInfo(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = {}
	
	if arg_13_1 then
		var_13_0 = ClanTag:convertListByTagInfo(arg_13_1)
	elseif arg_13_2 then
		var_13_0 = ClanTag:getTempTagList(arg_13_2)
	end
	
	return var_13_0
end

function ClanTag.convertListByTagInfo(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return {}
	end
	
	local var_14_0 = arg_14_1.tag1
	local var_14_1 = arg_14_1.tag2
	local var_14_2 = {}
	
	if var_14_0 then
		table.insert(var_14_2, to_n(var_14_0))
	end
	
	if var_14_1 then
		table.insert(var_14_2, to_n(var_14_1))
	end
	
	return var_14_2
end

function ClanTag.getTempTagList(arg_15_0, arg_15_1)
	if not arg_15_1 then
		return {}
	end
	
	if not arg_15_1.temp_info then
		return {}
	end
	
	return arg_15_1.temp_info.tags or {}
end

function ClanTag.getUpdateTagList(arg_16_0)
	return arg_16_0.update_tag_list
end

function ClanTag.removeUpdateTagList(arg_17_0)
	arg_17_0.update_tag_list = nil
end

function ClanTag.setUpdateTagList(arg_18_0, arg_18_1)
	arg_18_0.update_tag_list = arg_18_1
end

function ClanTag.isChangeUpdateList(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:getClanTagListIncludeTempTag()
	
	return var_19_0[1] ~= arg_19_1[1] or var_19_0[2] ~= arg_19_1[2]
end

function ClanTag.updateUISelectAbleTag(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = arg_20_1:getChildByName("btn_tag1")
	local var_20_1 = arg_20_1:getChildByName("btn_tag2")
	
	arg_20_0:updateUITagList(arg_20_1, arg_20_2, var_20_0, var_20_1)
end

function ClanTag.updateUIPreviewTag(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1:getChildByName("tag1")
	local var_21_1 = arg_21_1:getChildByName("tag2")
	
	arg_21_0:updateUITagList(arg_21_1, arg_21_2, var_21_0, var_21_1)
	
	if #arg_21_2 <= 0 then
		if_set_visible(arg_21_1, "n_tag_nodata", true)
	end
end

function ClanTag.updateUIRecommendItemTag(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1:getChildByName("tag1")
	local var_22_1 = arg_22_1:getChildByName("tag2")
	
	arg_22_0:updateUITagList(arg_22_1, arg_22_2, var_22_0, var_22_1)
	
	if #arg_22_2 > 1 then
		local var_22_2 = var_22_0:getContentSize().width
		local var_22_3 = var_22_0:getPositionX()
		local var_22_4 = var_22_0:getScaleX()
		
		var_22_1:setPositionX(var_22_3 + var_22_2 * var_22_4)
	end
end

function ClanTag.updateUITagList(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	local var_23_0 = #arg_23_2
	local var_23_1 = {}
	
	table.insert(var_23_1, arg_23_3)
	table.insert(var_23_1, arg_23_4)
	if_set_visible(arg_23_1, "btn_no_tag", var_23_0 <= 0)
	arg_23_3:setVisible(false)
	arg_23_4:setVisible(false)
	
	if var_23_0 <= 0 then
		return 
	end
	
	local var_23_2 = ClanTag:getTagDB()
	
	for iter_23_0, iter_23_1 in pairs(arg_23_2) do
		if get_cocos_refid(var_23_1[iter_23_0]) then
			local var_23_3 = var_23_2[tostring(iter_23_1)]
			
			if var_23_3 then
				if_set(var_23_1[iter_23_0], "tag_label", T(var_23_3.name))
				var_23_1[iter_23_0]:setVisible(true)
			end
		end
	end
end

function ClanTag.onTagSearch(arg_24_0)
	if (arg_24_0.cool_time_tag_search or 0) + 3 > os.time() then
		balloon_message_with_sound("msg_clan_tag_search_cooltime")
	elseif ContentDisable:byAlias("clan_tag_search") then
		balloon_message_with_sound("content_disable")
	else
		local var_24_0 = ClanJoin:getTagListNode()
		
		ClanTagSearchListUI:show(var_24_0)
	end
end

function ClanTag.setCoolTimeSearch(arg_25_0)
	arg_25_0.cool_time_tag_search = os.time()
end

function HANDLER.tag_list(arg_26_0, arg_26_1)
	if arg_26_1 == "btn_close" then
		if arg_26_0.parent then
			arg_26_0.parent:close()
		end
		
		return 
	end
	
	if arg_26_1 == "btn_tag1" and arg_26_0.parent then
		arg_26_0.parent:selectTag(arg_26_0)
	end
end

ClanTagListUI = ClanTagListUI or {}

function ClanTagListUI.show(arg_27_0, arg_27_1)
	local var_27_0 = Dialog:open("wnd/tag_list", arg_27_0, {
		use_backbutton = true,
		back_func = function()
			arg_27_0:close()
		end
	})
	
	SceneManager:getRunningPopupScene():addChild(var_27_0)
	var_27_0:getChildByName("n_tag_list"):setPosition(arg_27_1:getPosition())
	
	arg_27_0.vars = {}
	arg_27_0.vars.listView = var_27_0:getChildByName("listview")
	arg_27_0.vars.wnd = var_27_0
	
	if_set(var_27_0, "t_1_title", T("ui_tag_list_set_tl"))
	if_set(var_27_0, "t_disc", T("ui_tag_list_set_de"))
	
	arg_27_0.vars.info_list = ClanTag:getUpdateTagList()
	
	if not arg_27_0.vars.info_list then
		arg_27_0.vars.info_list = ClanTag:getClanTagListIncludeTempTag()
	end
	
	arg_27_0.vars.select_list = table.clone(arg_27_0.vars.info_list)
	
	local var_27_1 = arg_27_0:initListView()
	local var_27_2 = ClanTag:getCategoryList()
	
	for iter_27_0, iter_27_1 in pairs(var_27_2) do
		local var_27_3 = ClanTag:getTagListByParentID(iter_27_1.id)
		
		var_27_1:addGroup(iter_27_1, var_27_3)
	end
	
	var_27_0:getChildByName("btn_close").parent = arg_27_0
end

function ClanTagListUI.selectTag(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_1.tag_id
	
	if not var_29_0 then
		Log.e("no_tag_id", "ClanTagListUI.selectTag")
		
		return 
	end
	
	if not get_cocos_refid(arg_29_1) then
		Log.e("no_cont", "ClanTagListUI.selectTag")
		
		return 
	end
	
	if not get_cocos_refid(arg_29_1.obj_on) then
		Log.e("no_cont.obj_on", "ClanTagListUI.selectTag")
		
		return 
	end
	
	if not get_cocos_refid(arg_29_1.obj_off) then
		Log.e("no_cont.obj_off", "ClanTagListUI.selectTag")
		
		return 
	end
	
	local var_29_1 = table.find(arg_29_0.vars.select_list, to_n(var_29_0))
	
	if var_29_1 then
		arg_29_1.obj_on:setVisible(false)
		arg_29_1.obj_off:setVisible(true)
		table.remove(arg_29_0.vars.select_list, var_29_1)
	else
		if table.count(arg_29_0.vars.select_list) >= 2 then
			balloon_message_with_sound("msg_clan_tag_set_max")
			
			return 
		end
		
		arg_29_1.obj_on:setVisible(true)
		arg_29_1.obj_off:setVisible(false)
		table.insert(arg_29_0.vars.select_list, to_n(var_29_0))
	end
end

function ClanTagListUI.getUpdateList(arg_30_0)
	return arg_30_0.vars.select_list
end

function ClanTagListUI.initListView(arg_31_0)
	if not arg_31_0.vars.listView then
		return 
	end
	
	local var_31_0 = GroupListView:bindControl(arg_31_0.vars.listView)
	
	var_31_0:setListViewCascadeOpacityEnabled(true)
	var_31_0:setEnableMargin(true)
	
	local var_31_1 = load_control("wnd/tag_item.csb")
	local var_31_2 = var_31_1:getContentSize()
	
	var_31_1:setContentSize(var_31_2.width, var_31_2.height + 6)
	
	local var_31_3 = {
		onUpdate = function(arg_32_0, arg_32_1, arg_32_2)
			if_set_visible(arg_32_1, "n_tag1", false)
			if_set(arg_32_1, "title_text", T(arg_32_2.name))
		end
	}
	local var_31_4 = load_control("wnd/tag_item.csb")
	local var_31_5 = {
		onUpdate = function(arg_33_0, arg_33_1, arg_33_2)
			if_set_visible(arg_33_1, "n_tag1", true)
			if_set_visible(arg_33_1, "title_text", false)
			
			local var_33_0 = ClanTagListUI:getUpdateList()
			local var_33_1 = table.find(var_33_0, to_n(arg_33_2.id))
			local var_33_2 = arg_33_1:getChildByName("tag1_on")
			local var_33_3 = arg_33_1:getChildByName("tag1_off")
			
			if var_33_1 then
				var_33_2:setVisible(true)
				var_33_3:setVisible(false)
			else
				var_33_2:setVisible(false)
				var_33_3:setVisible(true)
			end
			
			if_set(var_33_2, "tag_label", T(arg_33_2.name))
			if_set(var_33_3, "tag_label", T(arg_33_2.name))
			UIUserData:call(var_33_2:getChildByName("tag_label"), "SINGLE_WSCALE(210)", {
				origin_scale_x = 0.74
			})
			UIUserData:call(var_33_3:getChildByName("tag_label"), "SINGLE_WSCALE(210)", {
				origin_scale_x = 0.74
			})
			
			local var_33_4 = arg_33_1:getChildByName("btn_tag1")
			
			var_33_4.tag_id = to_n(arg_33_2.id)
			var_33_4.obj_on = var_33_2
			var_33_4.obj_off = var_33_3
			var_33_4.parent = ClanTagListUI
		end
	}
	
	var_31_0:setRenderer(var_31_1, var_31_4, var_31_3, var_31_5)
	
	return var_31_0
end

function ClanTagListUI.close(arg_34_0)
	BackButtonManager:pop("Dialog.tag_list")
	arg_34_0.vars.wnd:removeFromParent()
	
	if arg_34_0.vars.info_list[1] ~= arg_34_0.vars.select_list[1] or arg_34_0.vars.info_list[2] ~= arg_34_0.vars.select_list[2] then
		table.sort(arg_34_0.vars.select_list, function(arg_35_0, arg_35_1)
			return to_n(arg_35_0) < to_n(arg_35_1)
		end)
		ClanTag:setUpdateTagList(arg_34_0.vars.select_list)
		ClanJoin:updateTagClanCreatePopup(arg_34_0.vars.select_list)
		ClanEdit:updateTagUI(arg_34_0.vars.select_list)
	end
end

ClanTagSearchListUI = ClanTagSearchListUI or {}

function ClanTagSearchListUI.show(arg_36_0, arg_36_1)
	local var_36_0 = Dialog:open("wnd/tag_list", arg_36_0, {
		use_backbutton = true,
		back_func = function()
			arg_36_0:close()
		end
	})
	
	SceneManager:getRunningPopupScene():addChild(var_36_0)
	var_36_0:getChildByName("n_tag_list"):setPosition(arg_36_1:getPosition())
	
	arg_36_0.vars = {}
	arg_36_0.vars.wnd = var_36_0
	arg_36_0.vars.listView = var_36_0:getChildByName("listview")
	arg_36_0.vars.select_list = {}
	
	if_set(var_36_0, "t_1_title", T("ui_tag_list_search_tl"))
	if_set(var_36_0, "t_disc", T("ui_tag_list_search_de"))
	
	local var_36_1 = arg_36_0:initListView()
	local var_36_2 = ClanTag:getCategoryList()
	
	for iter_36_0, iter_36_1 in pairs(var_36_2) do
		local var_36_3 = ClanTag:getTagListByParentID(iter_36_1.id)
		
		var_36_1:addGroup(iter_36_1, var_36_3)
	end
	
	var_36_0:getChildByName("btn_close").parent = arg_36_0
	
	ClanJoin:toogleActiveTagSearchButton(true)
end

function ClanTagSearchListUI.selectTag(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_1.tag_id
	
	if not var_38_0 then
		Log.e("no_tag_id", "ClanTagListUI.selectTag")
		
		return 
	end
	
	if not get_cocos_refid(arg_38_1) then
		Log.e("no_cont", "ClanTagListUI.selectTag")
		
		return 
	end
	
	if not get_cocos_refid(arg_38_1.obj_on) then
		Log.e("no_cont.obj_on", "ClanTagListUI.selectTag")
		
		return 
	end
	
	if not get_cocos_refid(arg_38_1.obj_off) then
		Log.e("no_cont.obj_off", "ClanTagListUI.selectTag")
		
		return 
	end
	
	local var_38_1 = table.find(arg_38_0.vars.select_list, to_n(var_38_0))
	
	if var_38_1 then
		arg_38_1.obj_on:setVisible(false)
		arg_38_1.obj_off:setVisible(true)
		table.remove(arg_38_0.vars.select_list, var_38_1)
	else
		if table.count(arg_38_0.vars.select_list) >= 5 then
			balloon_message_with_sound("msg_clan_tag_search_set_max")
			
			return 
		end
		
		arg_38_1.obj_on:setVisible(true)
		arg_38_1.obj_off:setVisible(false)
		table.insert(arg_38_0.vars.select_list, to_n(var_38_0))
	end
end

function ClanTagSearchListUI.getUpdateList(arg_39_0)
	return arg_39_0.vars.select_list
end

function ClanTagSearchListUI.initListView(arg_40_0)
	if not arg_40_0.vars.listView then
		return 
	end
	
	local var_40_0 = GroupListView:bindControl(arg_40_0.vars.listView)
	
	var_40_0:setListViewCascadeOpacityEnabled(true)
	var_40_0:setEnableMargin(true)
	
	local var_40_1 = load_control("wnd/tag_item.csb")
	local var_40_2 = var_40_1:getContentSize()
	
	var_40_1:setContentSize(var_40_2.width, var_40_2.height + 6)
	
	local var_40_3 = {
		onUpdate = function(arg_41_0, arg_41_1, arg_41_2)
			if_set_visible(arg_41_1, "n_tag1", false)
			if_set(arg_41_1, "title_text", T(arg_41_2.name))
		end
	}
	local var_40_4 = load_control("wnd/tag_item.csb")
	local var_40_5 = {
		onUpdate = function(arg_42_0, arg_42_1, arg_42_2)
			if_set_visible(arg_42_1, "n_tag1", true)
			if_set_visible(arg_42_1, "title_text", false)
			
			local var_42_0 = ClanTagSearchListUI:getUpdateList()
			local var_42_1 = table.find(var_42_0, to_n(arg_42_2.id))
			local var_42_2 = arg_42_1:getChildByName("tag1_on")
			local var_42_3 = arg_42_1:getChildByName("tag1_off")
			
			if var_42_1 then
				var_42_2:setVisible(true)
				var_42_3:setVisible(false)
			else
				var_42_2:setVisible(false)
				var_42_3:setVisible(true)
			end
			
			if_set(var_42_2, "tag_label", T(arg_42_2.name))
			if_set(var_42_3, "tag_label", T(arg_42_2.name))
			UIUserData:call(var_42_2:getChildByName("tag_label"), "SINGLE_WSCALE(210)", {
				origin_scale_x = 0.74
			})
			UIUserData:call(var_42_3:getChildByName("tag_label"), "SINGLE_WSCALE(210)", {
				origin_scale_x = 0.74
			})
			
			local var_42_4 = arg_42_1:getChildByName("btn_tag1")
			
			var_42_4.tag_id = to_n(arg_42_2.id)
			var_42_4.obj_on = var_42_2
			var_42_4.obj_off = var_42_3
			var_42_4.parent = ClanTagSearchListUI
		end
	}
	
	var_40_0:setRenderer(var_40_1, var_40_4, var_40_3, var_40_5)
	
	return var_40_0
end

function ClanTagSearchListUI.close(arg_43_0)
	BackButtonManager:pop("Dialog.tag_list")
	arg_43_0.vars.wnd:removeFromParent()
	ClanJoin:toogleActiveTagSearchButton(false)
	
	if #arg_43_0.vars.select_list > 0 then
		ClanRecommend:clearFilter()
		ClanTag:setCoolTimeSearch()
		query("clan_search_tag", {
			list = array_to_json(arg_43_0.vars.select_list)
		})
	end
end
