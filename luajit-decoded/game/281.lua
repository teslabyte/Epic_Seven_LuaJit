CollectionScrollView = {}

copy_functions(ScrollView, CollectionScrollView)

function CollectionScrollView.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.parent = arg_1_1
	arg_1_0.vars.onChangeName = arg_1_2
	
	arg_1_0:initScrollView(arg_1_0.vars.parent:getChildByName("scrollview"), 290, 101)
end

function CollectionScrollView.updateReward(arg_2_0)
	if not arg_2_0.vars or not arg_2_0.vars.last_idx then
		return 
	end
	
	local var_2_0 = arg_2_0.ScrollViewItems[arg_2_0.vars.last_idx]
	
	if not var_2_0 then
		return 
	end
	
	var_2_0.item.noti = CollectionDB:isReceivableBgPackEpisode(var_2_0.item.id)
	
	if_set_visible(var_2_0.control, "icon_noti", var_2_0.item.noti)
end

function CollectionScrollView.setScrollViewForCollection(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = {}
	
	arg_3_0.vars.event_proc = arg_3_3
	
	for iter_3_0, iter_3_1 in pairs(arg_3_1) do
		local var_3_1, var_3_2 = DB("dic_ui", iter_3_0, {
			"sort",
			"global_only"
		})
		
		if var_3_2 ~= "y" or not IS_PUBLISHER_ZLONG then
			local var_3_3 = {
				id = iter_3_0,
				have_count = arg_3_2[iter_3_0].have_count,
				max_count = arg_3_2[iter_3_0].max_count,
				noti = CollectionDB:isReceivableBgPackEpisode(iter_3_0)
			}
			
			if not var_3_1 then
				var_3_0[arg_3_4[iter_3_0]] = var_3_3
				var_3_0[arg_3_4[iter_3_0]].text_id = arg_3_5[iter_3_0]
				var_3_0[arg_3_4[iter_3_0]].icon = arg_3_6[iter_3_0]
			else
				var_3_0[var_3_1] = var_3_3
			end
		end
	end
	
	arg_3_0:clearScrollViewItems()
	arg_3_0:setScrollViewItems(var_3_0)
end

function CollectionScrollView.getScrollViewItem(arg_4_0, arg_4_1)
	local var_4_0 = load_control("wnd/dict_bar.csb")
	local var_4_1, var_4_2 = DB("dic_ui", arg_4_1.id, {
		"name",
		"icon"
	})
	
	if_set(var_4_0, "title", T(var_4_1))
	
	if not var_4_1 and arg_4_1.text_id then
		if_set(var_4_0, "title", T(arg_4_1.text_id))
	elseif not var_4_1 then
		if_set(var_4_0, "title", T(arg_4_1))
	end
	
	if arg_4_1.have_count then
		if_set(var_4_0, "txt_exp", arg_4_1.have_count .. "/" .. arg_4_1.max_count)
	else
		if_set(var_4_0, "txt_exp", arg_4_1.max_count)
	end
	
	var_4_2 = var_4_2 or arg_4_1.icon
	
	if_set_visible(var_4_0, "bg", false)
	if_set_sprite(var_4_0, "icon", var_4_2)
	if_set_visible(var_4_0, "icon", var_4_2 ~= nil)
	if_set_visible(var_4_0, "icon_noti", arg_4_1.noti)
	
	return var_4_0
end

function CollectionScrollView.onSelectScrollViewItem(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0.vars.last_sel == arg_5_2.control then
		return 
	end
	
	if arg_5_0.vars.last_sel then
		SoundEngine:play("event:/ui/category/select")
	end
	
	if arg_5_0.vars.event_proc then
		arg_5_0.vars.event_proc(arg_5_1, arg_5_2)
	end
	
	if_set_visible(arg_5_2.control, "bg", true)
	if_set_visible(arg_5_0.vars.last_sel, "bg", false)
	
	arg_5_0.vars.last_sel = arg_5_2.control
	arg_5_0.vars.last_idx = arg_5_1
	
	if not arg_5_0.vars.onChangeName then
		return 
	end
	
	local var_5_0 = DB("dic_ui", arg_5_2.item.id, "name") or arg_5_2.item.text_id
	
	arg_5_0.vars.onChangeName(T(var_5_0))
end

function CollectionScrollView.setOnChangeName(arg_6_0, arg_6_1)
	arg_6_0.vars.onChangeName = arg_6_1
end

function CollectionScrollView.setToIndex(arg_7_0, arg_7_1)
	if not arg_7_0.ScrollViewItems[arg_7_1] then
		return 
	end
	
	if get_cocos_refid(arg_7_0.vars.last_sel) then
		if_set_visible(arg_7_0.vars.last_sel, "bg", false)
	end
	
	arg_7_0.vars.last_sel = nil
	arg_7_0.vars.last_idx = nil
	
	arg_7_0:onSelectScrollViewItem(arg_7_1, arg_7_0.ScrollViewItems[arg_7_1])
end

function CollectionScrollView.getIndex(arg_8_0)
	if not arg_8_0.vars then
		return 1
	end
	
	return arg_8_0.vars.last_idx or 1
end

function CollectionScrollView.getLastSelectItem(arg_9_0)
	if not arg_9_0.vars then
		return nil
	end
	
	local var_9_0 = arg_9_0.ScrollViewItems[arg_9_0.vars.last_idx or 1]
	
	if not var_9_0 then
		return nil
	end
	
	return var_9_0.item
end
