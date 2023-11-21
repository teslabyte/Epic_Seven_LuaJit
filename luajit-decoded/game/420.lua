UnitInfosScrollView = {}

copy_functions(ScrollView, UnitInfosScrollView)

function UnitInfosScrollView.onCreate(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.scrollView = load_dlg("hero_detail_list", true, "wnd")
	
	arg_1_1:addChild(arg_1_0.vars.scrollView)
	
	arg_1_0.vars.not_used_mode = arg_1_2.not_used_mode or {}
	
	arg_1_0:initScrollView(arg_1_0.vars.scrollView:findChildByName("scrollview"), 290, 101)
	arg_1_0:setScrollView()
end

function UnitInfosScrollView.setScrollView(arg_2_0)
	local var_2_0 = {
		{
			icon = "icon_menu_info",
			id = "Detail",
			text = T("hero_detail_learn_title1")
		},
		{
			icon = "icon_menu_relationship",
			id = "Story",
			text = T("hero_detail_learn_title2")
		},
		{
			icon = "icon_menu_face_voice",
			id = "Emotion",
			text = T("hero_detail_learn_title3")
		},
		{
			icon = "icon_menu_story",
			id = "SubStory",
			text = T("hero_detail_learn_title4")
		},
		{
			icon = "icon_menu_good",
			id = "Review",
			text = T("ui_unit_detail_evaluation")
		}
	}
	
	arg_2_0:clearScrollViewItems()
	arg_2_0:setScrollViewItems(var_2_0)
	
	arg_2_0.vars.item = var_2_0
	arg_2_0.vars.hash_item = {}
	
	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		arg_2_0.vars.hash_item[iter_2_1.id] = iter_2_0
	end
end

function UnitInfosScrollView.setVisible(arg_3_0, arg_3_1)
	arg_3_0.vars.scrollView:setVisible(arg_3_1)
end

function UnitInfosScrollView.fadeInOut(arg_4_0, arg_4_1)
	UIAction:Add(LOG(OPACITY(500, arg_4_0.vars.scrollView:getOpacity() / 255, arg_4_1)), arg_4_0.vars.scrollView)
end

function UnitInfosScrollView.selectItem(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.vars.item[arg_5_1]
	
	if arg_5_0.vars.not_used_mode[var_5_0.id] then
		return 
	end
	
	if arg_5_0.vars.prv_idx == arg_5_1 then
		return 
	end
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.ScrollViewItems) do
		if var_5_0.id == iter_5_1.item.id then
			if_set_visible(iter_5_1.control, "bg", true)
		else
			if_set_visible(iter_5_1.control, "bg", false)
		end
	end
	
	UnitInfosController:setMode(var_5_0.id)
	
	arg_5_0.vars.prv_idx = arg_5_1
end

function UnitInfosScrollView.selectItemById(arg_6_0, arg_6_1)
	arg_6_0:selectItem(arg_6_0.vars.hash_item[arg_6_1])
end

function UnitInfosScrollView.getScrollViewItem(arg_7_0, arg_7_1)
	local var_7_0 = load_control("wnd/hero_detail_menu_item.csb")
	
	var_7_0.id = arg_7_1.id
	
	if_set(var_7_0, "txt_title", arg_7_1.text)
	if_set_visible(var_7_0, "bg", false)
	if_set_sprite(var_7_0, "icon", "img/" .. arg_7_1.icon)
	
	if arg_7_0.vars.not_used_mode[arg_7_1.id] then
		var_7_0:setOpacity(76.5)
	end
	
	return var_7_0
end

function UnitInfosScrollView.onSelectScrollViewItem(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:selectItem(arg_8_1)
end

function UnitInfosScrollView.onLeave(arg_9_0)
	arg_9_0.vars.scrollView:removeFromParent()
end
