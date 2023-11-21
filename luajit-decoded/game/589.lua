ShopBuyAgeBase = ShopBuyAgeBase or {}
ShopBuyAgeBase.vars = {}
ShopBuyAgeBase.year_scroll_view = {}
ShopBuyAgeBase.month_scroll_view = {}
ShopBuyAgeBase.day_scroll_view = {}

function HANDLER.shop_buy_age_p(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_block" then
		return 
	end
	
	if arg_1_1 == "btn_close" then
		ShopBuyAgeBase:close()
		
		return 
	end
	
	if arg_1_1 == "btn_close_select" then
		ShopBuyAgeBase:onButtonCloseSelect()
		
		return 
	end
	
	if arg_1_1 == "btn_year" then
		ShopBuyAgeBase:onButtonYear()
		
		return 
	end
	
	if arg_1_1 == "btn_month" then
		ShopBuyAgeBase:onButtonMonth()
		
		return 
	end
	
	if arg_1_1 == "btn_day" then
		ShopBuyAgeBase:onButtonDay()
		
		return 
	end
	
	if arg_1_1 == "btn_cancel" then
		ShopBuyAgeBase:close()
		
		return 
	end
	
	if arg_1_1 == "btn_confirm" then
		ShopBuyAgeBase:onButtonConfirm()
		
		return 
	end
end

function HANDLER.shop_age_item(arg_2_0, arg_2_1)
	if arg_2_1 == "button" then
		if arg_2_0.year then
			ShopBuyAgeBase:selectYear(arg_2_0)
			ShopBuyAge:setYear(arg_2_0.year)
		elseif arg_2_0.month then
			ShopBuyAgeBase:selectMonth(arg_2_0)
			ShopBuyAge:setMonth(arg_2_0.month)
		elseif arg_2_0.day then
			ShopBuyAgeBase:selectDay(arg_2_0)
			ShopBuyAge:setDay(arg_2_0.day)
		end
	end
end

function ShopBuyAgeBase.removeEvents(arg_3_0)
	ShopBuyAge.onSelectDate:remove("shop_buy_age_base")
end

function ShopBuyAgeBase.addEvents(arg_4_0)
	ShopBuyAge.onSelectDate:add("shop_buy_age_base", function()
		arg_4_0:onSelectDate()
	end)
end

function ShopBuyAgeBase.close(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	arg_6_0:removeEvents()
	BackButtonManager:pop("shop_buy_age_p")
	arg_6_0.vars.wnd:removeFromParent()
	
	arg_6_0.vars.wnd = nil
end

function ShopBuyAgeBase.show(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.vars = {}
	arg_7_0.vars.opts = arg_7_2 or {}
	arg_7_0.vars.parent = arg_7_1 or SceneManager:getDefaultLayer()
	arg_7_0.vars.wnd = load_dlg("shop_buy_age_p", true, "wnd", function()
		arg_7_0:close()
	end)
	
	UIAction:Add(DELAY(100), arg_7_0.vars.wnd, "block")
	arg_7_0.vars.parent:addChild(arg_7_0.vars.wnd)
	arg_7_0:initScrollViews()
	arg_7_0:addEvents()
	if_set_visible(arg_7_0.vars.wnd, "n_select_slot", true)
	if_set_visible(arg_7_0.vars.wnd, "n_select_year_all", false)
	if_set_visible(arg_7_0.vars.wnd, "n_select_month_all", false)
	if_set_visible(arg_7_0.vars.wnd, "n_select_day_all", false)
	if_set_visible(arg_7_0.vars.wnd, "n_select_day_all", false)
	arg_7_0:setLimitText()
	
	local var_7_0, var_7_1, var_7_2 = ShopBuyAge:getDate()
	
	arg_7_0:selectYear(var_7_0)
	ShopBuyAge:setYear(var_7_0)
	arg_7_0:selectMonth(var_7_1)
	ShopBuyAge:setMonth(var_7_1)
	arg_7_0:selectDay(var_7_2)
	ShopBuyAge:setDay(var_7_2)
end

function ShopBuyAgeBase.setLimitText(arg_9_0)
	if not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	local var_9_0 = GAME_STATIC_VARIABLE.jpn_payment_age1
	local var_9_1 = GAME_STATIC_VARIABLE.jpn_payment_age2
	local var_9_2 = T("jpn_payment_age1", {
		age1 = var_9_0
	}) .. "\n" .. T("jpn_payment_age2", {
		age1 = var_9_0,
		age2 = var_9_1
	}) .. "\n" .. T("jpn_payment_age3", {
		age2 = var_9_1
	})
	
	if_set(getChildByPath(arg_9_0.vars.wnd, "n_window/n_content/n_info/txt_age"), nil, var_9_2)
	
	local var_9_3 = GAME_STATIC_VARIABLE.jpn_payment_limit1
	local var_9_4 = GAME_STATIC_VARIABLE.jpn_payment_limit2
	local var_9_5 = T("jpn_payment_age1_limit", {
		limit1 = var_9_3
	}) .. "\n" .. T("jpn_payment_age2_limit", {
		limit2 = var_9_4
	}) .. "\n" .. T("jpn_payment_age3_limit")
	
	if_set(getChildByPath(arg_9_0.vars.wnd, "n_window/n_content/n_info/txt_limit"), nil, var_9_5)
end

function ShopBuyAgeBase.updateValidDate(arg_10_0)
	local var_10_0 = ShopBuyAge:isValidDate()
	
	if_set_opacity(arg_10_0.vars.wnd, "btn_confirm", var_10_0 and 255 or 76.5)
	
	if not var_10_0 then
		balloon_message_with_sound("jpn_payment_err")
		ShopBuyAge:setDay(1)
	end
end

function ShopBuyAgeBase.onSelectDate(arg_11_0)
	local var_11_0, var_11_1, var_11_2 = ShopBuyAge:getDate()
	local var_11_3 = arg_11_0.vars.wnd:findChildByName("btn_year")
	local var_11_4 = arg_11_0.vars.wnd:findChildByName("btn_month")
	local var_11_5 = arg_11_0.vars.wnd:findChildByName("btn_day")
	
	if_set(var_11_3, "txt", T("public_year", {
		year = var_11_0
	}))
	if_set(var_11_4, "txt", T("public_month", {
		month = var_11_1
	}))
	if_set(var_11_5, "txt", T("public_day", {
		day = var_11_2
	}))
	arg_11_0:closeSelectDate()
	arg_11_0:updateValidDate()
	arg_11_0:updateDayScrollViews()
	arg_11_0:selectYear(var_11_0)
	arg_11_0:selectMonth(var_11_1)
	arg_11_0:selectDay(var_11_2)
end

function ShopBuyAgeBase.closeSelectDate(arg_12_0)
	if_set_visible(arg_12_0.vars.wnd, "n_select_year_all", false)
	if_set_visible(arg_12_0.vars.wnd, "n_select_month_all", false)
	if_set_visible(arg_12_0.vars.wnd, "n_select_day_all", false)
end

function ShopBuyAgeBase.onButtonCloseSelect(arg_13_0)
	arg_13_0:closeSelectDate()
end

function MsgHandler.set_birthday(arg_14_0)
	ShopBuyAgeBase:close()
	
	if to_n(arg_14_0.birthday) > 0 then
		AccountData.birthday = arg_14_0.birthday
	end
	
	if arg_14_0.birthday_limit then
		AccountData.birthday_limit = arg_14_0.birthday_limit
	end
end

function ShopBuyAgeBase.onButtonConfirm(arg_15_0)
	local var_15_0, var_15_1, var_15_2 = ShopBuyAge:getDate()
	
	local function var_15_3()
		query("set_birthday", {
			year = var_15_0,
			month = var_15_1,
			day = var_15_2
		})
	end
	
	local var_15_4 = Dialog:msgBox("", {
		yesno = true,
		title = T("jpn_payment_check_title"),
		handler = var_15_3
	})
	
	upgradeLabelToRichLabel(var_15_4, "text", true)
	
	local var_15_5 = T("jpn_payment_check_desc") .. "\n \n<#ffffff>" .. T("public_year", {
		year = var_15_0
	}) .. " " .. T("public_month", {
		month = var_15_1
	}) .. " " .. T("public_day", {
		day = var_15_2
	}) .. "</>"
	
	if_set(var_15_4, "text", var_15_5)
end

function ShopBuyAgeBase.onButtonYear(arg_17_0)
	if_set_visible(arg_17_0.vars.wnd, "n_select_year_all", true)
	
	local var_17_0, var_17_1 = ShopBuyAge:getFromToYear()
	local var_17_2 = ShopBuyAge:getYear() - var_17_0 + 1
	
	arg_17_0.year_scroll_view:jumpToIndex(var_17_2)
end

function ShopBuyAgeBase.onButtonMonth(arg_18_0)
	if_set_visible(arg_18_0.vars.wnd, "n_select_month_all", true)
	arg_18_0.month_scroll_view:jumpToIndex(ShopBuyAge:getMonth())
end

function ShopBuyAgeBase.onButtonDay(arg_19_0)
	if_set_visible(arg_19_0.vars.wnd, "n_select_day_all", true)
	arg_19_0.day_scroll_view:jumpToIndex(ShopBuyAge:getDay())
end

function ShopBuyAgeBase.selectYear(arg_20_0, arg_20_1)
	if tolua.type(arg_20_1) == "number" then
		if not arg_20_0.year_scroll_view.nodes then
			return 
		end
		
		arg_20_1 = arg_20_0.year_scroll_view.nodes[arg_20_1]
		
		if not get_cocos_refid(arg_20_1) then
			return 
		end
	end
	
	if arg_20_0.vars.select_year == arg_20_1 then
		return 
	end
	
	if arg_20_0.vars.select_year then
		if_set_visible(arg_20_0.vars.select_year, "bg_select", false)
	end
	
	arg_20_0.vars.select_year = arg_20_1
	
	if_set_visible(arg_20_0.vars.select_year, "bg_select", true)
end

function ShopBuyAgeBase.selectMonth(arg_21_0, arg_21_1)
	if tolua.type(arg_21_1) == "number" then
		if not arg_21_0.month_scroll_view.nodes then
			return 
		end
		
		arg_21_1 = arg_21_0.month_scroll_view.nodes[arg_21_1]
		
		if not get_cocos_refid(arg_21_1) then
			return 
		end
	end
	
	if arg_21_0.vars.select_month == arg_21_1 then
		return 
	end
	
	if arg_21_0.vars.select_month then
		if_set_visible(arg_21_0.vars.select_month, "bg_select", false)
	end
	
	arg_21_0.vars.select_month = arg_21_1
	
	if_set_visible(arg_21_0.vars.select_month, "bg_select", true)
end

function ShopBuyAgeBase.selectDay(arg_22_0, arg_22_1)
	if tolua.type(arg_22_1) == "number" then
		if not arg_22_0.day_scroll_view.nodes then
			return 
		end
		
		arg_22_1 = arg_22_0.day_scroll_view.nodes[arg_22_1]
		
		if not get_cocos_refid(arg_22_1) then
			return 
		end
	end
	
	if arg_22_0.vars.select_day == arg_22_1 then
		return 
	end
	
	if arg_22_0.vars.select_day then
		if_set_visible(arg_22_0.vars.select_day, "bg_select", false)
	end
	
	arg_22_0.vars.select_day = arg_22_1
	
	if_set_visible(arg_22_0.vars.select_day, "bg_select", true)
end

function ShopBuyAgeBase.initNumsScrollView(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	copy_functions(ScrollView, arg_23_2)
	
	local var_23_0 = {}
	
	for iter_23_0 = arg_23_3, arg_23_4 do
		table.insert(var_23_0, iter_23_0)
	end
	
	arg_23_2:initScrollView(arg_23_1, 200, 54)
	arg_23_2:createScrollViewItems(var_23_0)
end

function ShopBuyAgeBase.updateDayScrollViews(arg_24_0)
	local var_24_0 = ShopBuyAge:getEndDay(ShopBuyAge:getDate())
	
	if arg_24_0.day_scroll_view and arg_24_0.day_scroll_view.ScrollViewItems and #arg_24_0.day_scroll_view.ScrollViewItems == var_24_0 then
		return 
	end
	
	arg_24_0:initNumsScrollView(arg_24_0.vars.wnd:findChildByName("n_select_day_all"):findChildByName("scrollview_select"), arg_24_0.day_scroll_view, 1, var_24_0)
end

function ShopBuyAgeBase.initScrollViews(arg_25_0)
	arg_25_0:initNumsScrollView(arg_25_0.vars.wnd:findChildByName("n_select_year_all"):findChildByName("scrollview_select"), arg_25_0.year_scroll_view, ShopBuyAge:getFromToYear())
	arg_25_0:initNumsScrollView(arg_25_0.vars.wnd:findChildByName("n_select_month_all"):findChildByName("scrollview_select"), arg_25_0.month_scroll_view, 1, 12)
	arg_25_0:initNumsScrollView(arg_25_0.vars.wnd:findChildByName("n_select_day_all"):findChildByName("scrollview_select"), arg_25_0.day_scroll_view, 1, ShopBuyAge:getEndDay(ShopBuyAge:getDate()))
end

function ShopBuyAgeBase.year_scroll_view.getScrollViewItem(arg_26_0, arg_26_1)
	local var_26_0 = load_control("wnd/shop_age_item.csb")
	
	if_set(var_26_0, "*txt", arg_26_1)
	
	arg_26_0.nodes = arg_26_0.nodes or {}
	arg_26_0.nodes[arg_26_1] = var_26_0
	
	local var_26_1 = var_26_0:findChildByName("button")
	
	var_26_1.year = arg_26_1
	
	if_set_visible(var_26_1, "bg_select", false)
	
	return var_26_0
end

function ShopBuyAgeBase.month_scroll_view.getScrollViewItem(arg_27_0, arg_27_1)
	local var_27_0 = load_control("wnd/shop_age_item.csb")
	
	if_set(var_27_0, "*txt", arg_27_1)
	
	arg_27_0.nodes = arg_27_0.nodes or {}
	arg_27_0.nodes[arg_27_1] = var_27_0
	
	local var_27_1 = var_27_0:findChildByName("button")
	
	var_27_1.month = arg_27_1
	
	if_set_visible(var_27_1, "bg_select", false)
	
	return var_27_0
end

function ShopBuyAgeBase.day_scroll_view.getScrollViewItem(arg_28_0, arg_28_1)
	local var_28_0 = load_control("wnd/shop_age_item.csb")
	
	if_set(var_28_0, "*txt", arg_28_1)
	
	arg_28_0.nodes = arg_28_0.nodes or {}
	arg_28_0.nodes[arg_28_1] = var_28_0
	
	local var_28_1 = var_28_0:findChildByName("button")
	
	var_28_1.day = arg_28_1
	
	if_set_visible(var_28_1, "bg_select", false)
	
	return var_28_0
end
